#!/usr/bin/env python

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

import copy
import mozversion
import os
import sys
import time
import traceback
import urllib
import utils
import mozhttpd

from mozlog import get_proxy_logger

from talos.mitmproxy import mitmproxy
from talos.results import TalosResults
from talos.ttest import TTest
from talos.utils import TalosError, TalosRegression
from talos.config import get_configs, ConfigurationError

# directory of this file
here = os.path.dirname(os.path.realpath(__file__))
LOG = get_proxy_logger()


def useBaseTestDefaults(base, tests):
    for test in tests:
        for item in base:
            if item not in test:
                test[item] = base[item]
                if test[item] is None:
                    test[item] = ''
    return tests


def buildCommandLine(test):
    """build firefox command line options for tp tests"""

    # sanity check pageloader values
    # mandatory options: tpmanifest, tpcycles
    if test['tpcycles'] not in range(1, 1000):
        raise TalosError('pageloader cycles must be int 1 to 1,000')
    if test.get('tpdelay') and test['tpdelay'] not in range(1, 10000):
        raise TalosError('pageloader delay must be int 1 to 10,000')
    if 'tpmanifest' not in test:
        raise TalosError("tpmanifest not found in test: %s" % test)

    # if profiling is on, override tppagecycles to prevent test hanging
    if test['gecko_profile']:
        LOG.info("Gecko profiling is enabled so talos is reducing the number "
                 "of cycles, please disregard reported numbers")
        for cycle_var in ['tppagecycles', 'tpcycles', 'cycles']:
            if test[cycle_var] > 2:
                test[cycle_var] = 2

    # build pageloader command from options
    url = ['-tp', test['tpmanifest']]
    CLI_bool_options = ['tpchrome', 'tpmozafterpaint', 'tpdisable_e10s',
                        'tpnoisy', 'rss', 'tprender', 'tploadnocache',
                        'tpscrolltest', 'fnbpaint']
    CLI_options = ['tpcycles', 'tppagecycles', 'tpdelay', 'tptimeout']
    for key in CLI_bool_options:
        if test.get(key):
            url.append('-%s' % key)

    for key in CLI_options:
        value = test.get(key)
        if value:
            url.extend(['-%s' % key, str(value)])

    # XXX we should actually return the list but since we abuse
    # the url as a command line flag to pass to firefox all over the place
    # will just make a string for now
    return ' '.join(url)


def setup_webserver(webserver):
    """use mozhttpd to setup a webserver"""
    LOG.info("starting webserver on %r" % webserver)

    host, port = webserver.split(':')
    return mozhttpd.MozHttpd(host=host, port=int(port), docroot=here)


def run_tests(config, browser_config):
    """Runs the talos tests on the given configuration and generates a report.
    """
    # get the test data
    tests = config['tests']
    tests = useBaseTestDefaults(config.get('basetest', {}), tests)
    paths = ['profile_path', 'tpmanifest', 'extensions', 'setup', 'cleanup']
    for test in tests:
        # Check for profile_path, tpmanifest and interpolate based on Talos
        # root https://bugzilla.mozilla.org/show_bug.cgi?id=727711
        # Build command line from config
        for path in paths:
            if test.get(path):
                test[path] = utils.interpolate(test[path])
        if test.get('tpmanifest'):
            test['tpmanifest'] = \
                os.path.normpath('file:/%s' % (urllib.quote(test['tpmanifest'],
                                               '/\\t:\\')))
        if not test.get('url'):
            # build 'url' for tptest
            test['url'] = buildCommandLine(test)
        test['url'] = utils.interpolate(test['url'])
        test['setup'] = utils.interpolate(test['setup'])
        test['cleanup'] = utils.interpolate(test['cleanup'])

    # pass --no-remote to firefox launch, if --develop is specified
    # we do that to allow locally the user to have another running firefox
    # instance
    if browser_config['develop']:
        browser_config['extra_args'] = '--no-remote'

    # with addon signing for production talos, we want to develop without it
    if browser_config['develop'] or browser_config['branch_name'] == 'Try':
        browser_config['preferences']['xpinstall.signatures.required'] = False

    browser_config['preferences']['extensions.allow-non-mpc-extensions'] = True

    # if using firstNonBlankPaint, must turn on pref for it
    if test.get('fnbpaint', False):
        LOG.info("Using firstNonBlankPaint, so turning on pref for it")
        browser_config['preferences']['dom.performance.time_to_non_blank_paint.enabled'] = True

    # set defaults
    testdate = config.get('testdate', '')

    # get the process name from the path to the browser
    if not browser_config['process']:
        browser_config['process'] = \
            os.path.basename(browser_config['browser_path'])

    # fix paths to substitute
    # `os.path.dirname(os.path.abspath(__file__))` for ${talos}
    # https://bugzilla.mozilla.org/show_bug.cgi?id=705809
    browser_config['extensions'] = [utils.interpolate(i)
                                    for i in browser_config['extensions']]
    browser_config['bcontroller_config'] = \
        utils.interpolate(browser_config['bcontroller_config'])

    # normalize browser path to work across platforms
    browser_config['browser_path'] = \
        os.path.normpath(browser_config['browser_path'])

    binary = browser_config["browser_path"]
    version_info = mozversion.get_version(binary=binary)
    browser_config['browser_name'] = version_info['application_name']
    browser_config['browser_version'] = version_info['application_version']
    browser_config['buildid'] = version_info['application_buildid']
    try:
        browser_config['repository'] = version_info['application_repository']
        browser_config['sourcestamp'] = version_info['application_changeset']
    except KeyError:
        if not browser_config['develop']:
            print("Abort: unable to find changeset or repository: %s" % version_info)
            sys.exit(1)
        else:
            browser_config['repository'] = 'develop'
            browser_config['sourcestamp'] = 'develop'

    # get test date in seconds since epoch
    if testdate:
        date = int(time.mktime(time.strptime(testdate,
                                             '%a, %d %b %Y %H:%M:%S GMT')))
    else:
        date = int(time.time())
    LOG.debug("using testdate: %d" % date)
    LOG.debug("actual date: %d" % int(time.time()))

    # results container
    talos_results = TalosResults()

    # results links
    if not browser_config['develop'] and not config['gecko_profile']:
        results_urls = dict(
            # another hack; datazilla stands for Perfherder
            # and do not require url, but a non empty dict is required...
            output_urls=['local.json'],
        )
    else:
        # local mode, output to files
        results_urls = dict(output_urls=[os.path.abspath('local.json')])

    httpd = setup_webserver(browser_config['webserver'])
    httpd.start()

    # if e10s add as extra results option
    if config['e10s']:
        talos_results.add_extra_option('e10s')

    # stylo is another option for testing
    if config['stylo']:
        talos_results.add_extra_option('stylo')

    # measuring the difference of a a certain thread level
    if config.get('stylothreads', 0) > 0:
        talos_results.add_extra_option('%s_thread' % config['stylothreads'])

    if config['gecko_profile']:
        talos_results.add_extra_option('geckoProfile')

    # some tests use mitmproxy to playback pages
    mitmproxy_recordings_list = config.get('mitmproxy', False)
    if mitmproxy_recordings_list is not False:
        # needed so can tell talos ttest to allow external connections
        browser_config['mitmproxy'] = True

        # start mitmproxy playback; this also generates the CA certificate
        mitmdump_path = config.get('mitmdumpPath', False)
        if mitmdump_path is False:
            # cannot continue, need path for mitmdump playback tool
            raise TalosError('Aborting: mitmdumpPath not provided on cmd line but is required')

        mitmproxy_recording_path = os.path.join(here, 'mitmproxy')
        mitmproxy_proc = mitmproxy.start_mitmproxy_playback(mitmdump_path,
                                                            mitmproxy_recording_path,
                                                            mitmproxy_recordings_list.split(),
                                                            browser_config['browser_path'])

        # install the generated CA certificate into Firefox
        # mitmproxy cert setup needs path to mozharness install; mozharness has set this
        # value in the SCRIPTSPATH env var for us in mozharness/mozilla/testing/talos.py
        scripts_path = os.environ.get('SCRIPTSPATH')
        LOG.info('scripts_path: %s' % str(scripts_path))
        mitmproxy.install_mitmproxy_cert(mitmproxy_proc,
                                         browser_config['browser_path'],
                                         str(scripts_path))

    testname = None
    # run the tests
    timer = utils.Timer()
    LOG.suite_start(tests=[test['name'] for test in tests])
    try:
        for test in tests:
            testname = test['name']
            LOG.test_start(testname)

            mytest = TTest()

            # some tests like ts_paint return multiple results in a single iteration
            if test.get('firstpaint', False) or test.get('userready', None):
                # we need a 'testeventmap' to tell us which tests each event should map to
                multi_value_result = None
                separate_results_list = []

                test_event_map = test.get('testeventmap', None)
                if test_event_map is None:
                    raise TalosError("Need 'testeventmap' in test.py for %s" % test.get('name'))

                # run the test
                multi_value_result = mytest.runTest(browser_config, test)
                if multi_value_result is None:
                    raise TalosError("Abort: no results returned for %s" % test.get('name'))

                # parse out the multi-value results, and 'fake it' to appear like separate tests
                separate_results_list = convert_to_separate_test_results(multi_value_result,
                                                                         test_event_map)

                # now we have three separate test results, store them
                for test_result in separate_results_list:
                    talos_results.add(test_result)

            # some tests like bloom_basic run two separate tests and then compare those values
            # we want the results in perfherder to only be the actual difference between those
            # and store the base and reference test replicates in results.json for upload
            elif test.get('base_vs_ref', False):
                # run the test, results will be reported for each page like two tests in the suite
                base_and_reference_results = mytest.runTest(browser_config, test)
                # now compare each test, and create a new test object for the comparison
                talos_results.add(make_comparison_result(base_and_reference_results))
            else:
                # just expecting regular test - one result value per iteration
                talos_results.add(mytest.runTest(browser_config, test))
            LOG.test_end(testname, status='OK')

    except TalosRegression as exc:
        LOG.error("Detected a regression for %s" % testname)
        # by returning 1, we report an orange to buildbot
        # http://docs.buildbot.net/latest/developer/results.html
        LOG.test_end(testname, status='FAIL', message=str(exc),
                     stack=traceback.format_exc())
        return 1
    except Exception as exc:
        # NOTE: if we get into this condition, talos has an internal
        # problem and cannot continue
        #       this will prevent future tests from running
        LOG.test_end(testname, status='ERROR', message=str(exc),
                     stack=traceback.format_exc())
        # indicate a failure to buildbot, turn the job red
        return 2
    finally:
        LOG.suite_end()
        httpd.stop()

    LOG.info("Completed test suite (%s)" % timer.elapsed())

    # if mitmproxy was used for page playback, stop it
    if mitmproxy_recordings_list is not False:
        mitmproxy.stop_mitmproxy_playback(mitmproxy_proc)

    # output results
    if results_urls and not browser_config['no_upload_results']:
        talos_results.output(results_urls)
        if browser_config['develop'] or config['gecko_profile']:
            print("Thanks for running Talos locally. Results are in %s"
                  % (results_urls['output_urls']))

    # we will stop running tests on a failed test, or we will return 0 for
    # green
    return 0


def make_comparison_result(base_and_reference_results):
    ''' Receive a test result object meant to be used as a base vs reference test. The result
    object will have one test with two subtests; instead of traditional subtests we want to
    treat them as separate tests, comparing them together and reporting the comparison results.

    Results with multiple pages used as subtests would look like this normally, with the overall
    result value being the mean of the pages/subtests:

    PERFHERDER_DATA: {"framework": {"name": "talos"}, "suites": [{"extraOptions": ["e10s"],
    "name": "bloom_basic", "lowerIsBetter": true, "alertThreshold": 5.0, "value": 594.81,
    "subtests": [{"name": ".html", "lowerIsBetter": true, "alertThreshold": 5.0, "replicates":
    [586.52, ...], "value": 586.52], "unit": "ms"}, {"name": "-ref.html", "lowerIsBetter": true,
    "alertThreshold": 5.0, "replicates": [603.225, ...], "value": 603.225, "unit": "ms"}]}]}

    We want to compare the subtests against eachother (base vs ref) and create a new single test
    results object with the comparison results, that will look like traditional single test results
    like this:

    PERFHERDER_DATA: {"framework": {"name": "talos"}, "suites": [{"lowerIsBetter": true,
    "subtests": [{"name": "", "lowerIsBetter": true, "alertThreshold": 5.0, "replicates":
    [16.705, ...], "value": 16.705, "unit": "ms"}], "extraOptions": ["e10s"], "name":
    "bloom_basic", "alertThreshold": 5.0}]}
    '''
    # separate the 'base' and 'reference' result run values
    base_result_runs = base_and_reference_results.results[0].results[0]['runs']
    ref_result_runs = base_and_reference_results.results[0].results[1]['runs']

    # create a new results object for the comparison result; keep replicates from both pages
    comparison_result = copy.deepcopy(base_and_reference_results)

    # remove original results from our copy as they will be replaced by one comparison result
    comparison_result.results[0].results = []

    # populate our new comparison result with 'base' and 'ref' replicates
    comparison_result.results[0].results.append({'index': 0,
                                                 'runs': [],
                                                 'page': '',
                                                 'base_runs': base_result_runs,
                                                 'ref_runs': ref_result_runs})

    # now step thru each result, compare 'base' vs 'ref', and store the difference in 'runs'
    _index = 0
    for next_ref in comparison_result.results[0].results[0]['ref_runs']:
        diff = abs(next_ref - comparison_result.results[0].results[0]['base_runs'][_index])
        comparison_result.results[0].results[0]['runs'].append(round(diff, 3))
        _index += 1

    return comparison_result


def convert_to_separate_test_results(multi_value_result, test_event_map):
    ''' Receive a test result that actually contains multiple values in a single iteration, and
    parse it out in order to 'fake' three seprate test results.

    Incoming result looks like this:

    [{'index': 0, 'runs': {'event_1': [1338, ...], 'event_2': [1438, ...], 'event_3':
    [1538, ...]}, 'page': 'NULL'}]

    We want to parse it out such that we have 'faked' three separate tests, setting test names
    and taking the run values for each. End goal is to have results reported as three separate
    tests, like this:

    PERFHERDER_DATA: {"framework": {"name": "talos"}, "suites": [{"subtests": [{"replicates":
    [1338, ...], "name": "ts_paint", "value": 1338}], "extraOptions": ["e10s"], "name":
    "ts_paint"}, {"subtests": [{"replicates": [1438, ...], "name": "ts_first_paint", "value":
    1438}], "extraOptions": ["e10s"], "name": "ts_first_paint"}, {"subtests": [{"replicates":
    [1538, ...], "name": "ts_user_ready", "value": 1538}], "extraOptions": ["e10s"], "name":
    "ts_user_ready"}]}
    '''
    list_of_separate_tests = []

    for next_test in test_event_map:
        # copy the original test result that has multiple values per iteration
        separate_test = copy.deepcopy(multi_value_result)
        # set the name of the new 'faked' test
        separate_test.test_config['name'] = next_test['name']
        # set the run values for the new test
        for x in separate_test.results:
            for item in x.results:
                all_runs = item['runs']
                item['runs'] = all_runs[next_test['label']]
        # add it to our list of results to return
        list_of_separate_tests.append(separate_test)

    return list_of_separate_tests


def main(args=sys.argv[1:]):
    try:
        config, browser_config = get_configs()
    except ConfigurationError as exc:
        sys.exit("ERROR: %s" % exc)
    sys.exit(run_tests(config, browser_config))


if __name__ == '__main__':
    main()
