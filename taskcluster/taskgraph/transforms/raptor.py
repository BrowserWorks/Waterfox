# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

from __future__ import absolute_import, print_function, unicode_literals

from copy import deepcopy
from six import text_type

from voluptuous import (
    Any,
    Optional,
    Required,
    Extra,
)

from taskgraph.transforms.base import TransformSequence
from taskgraph.transforms.tests import test_description_schema
from taskgraph.util.schema import optionally_keyed_by, resolve_keyed_by, Schema
from taskgraph.util.treeherder import split_symbol, join_symbol

transforms = TransformSequence()


raptor_description_schema = Schema({
    # Raptor specific configs.
    Optional('apps'): optionally_keyed_by(
        'test-platform',
        [text_type]
    ),
    Optional('raptor-test'): text_type,
    Optional('raptor-subtests'): optionally_keyed_by(
        'app',
        list
    ),
    Optional('activity'): optionally_keyed_by(
        'app',
        text_type
    ),
    Optional('binary-path'): optionally_keyed_by(
        'app',
        text_type
    ),
    Optional('pageload'): optionally_keyed_by(
        'test-platform',
        'app',
        Any('cold', 'warm', 'both'),
    ),
    # Configs defined in the 'test_description_schema'.
    Optional('max-run-time'): optionally_keyed_by(
        'app',
        test_description_schema['max-run-time']
    ),
    Optional('run-on-projects'): optionally_keyed_by(
        'app',
        'pageload',
        'test-name',
        'raptor-test',
        test_description_schema['run-on-projects']
    ),
    Optional('variants'): optionally_keyed_by(
        'app',
        test_description_schema['variants']
    ),
    Optional('target'): optionally_keyed_by(
        'app',
        test_description_schema['target']
    ),
    Optional('tier'): optionally_keyed_by(
        'app',
        'raptor-test',
        test_description_schema['tier']
    ),
    Optional('run-visual-metrics'): optionally_keyed_by(
        'app',
        bool
    ),
    Required('test-name'): test_description_schema['test-name'],
    Required('test-platform'): test_description_schema['test-platform'],
    Required('require-signed-extensions'): test_description_schema['require-signed-extensions'],
    Required('treeherder-symbol'): test_description_schema['treeherder-symbol'],
    # Any unrecognized keys will be validated against the test_description_schema.
    Extra: object,
})

transforms.add_validate(raptor_description_schema)


@transforms.add
def set_defaults(config, tests):
    for test in tests:
        test.setdefault('pageload', 'warm')
        test.setdefault('run-visual-metrics', False)
        yield test


@transforms.add
def split_apps(config, tests):
    app_symbols = {
        'chrome': 'ChR',
        'chrome-m': 'ChR',
        'chromium': 'Cr',
        'fenix': 'fenix',
        'refbrow': 'refbrow',
    }

    for test in tests:
        apps = test.pop('apps', None)
        if not apps:
            yield test
            continue

        for app in apps:
            atest = deepcopy(test)
            suffix = "-{}".format(app)
            atest['app'] = app
            atest['description'] += " on {}".format(app.capitalize())

            name = atest['test-name']
            if name.endswith('-cold'):
                name = atest['test-name'][:-len('-cold')] + suffix + '-cold'
            else:
                name += suffix

            atest['test-name'] = name
            atest['try-name'] = name

            if app in app_symbols:
                group, symbol = split_symbol(atest['treeherder-symbol'])
                group += "-{}".format(app_symbols[app])
                atest['treeherder-symbol'] = join_symbol(group, symbol)

            yield atest


@transforms.add
def handle_keyed_by_prereqs(config, tests):
    """
    Only resolve keys for prerequisite fields here since the
    these keyed-by options might have keyed-by fields
    as well.
    """
    fields = ['raptor-subtests', 'pageload']
    for test in tests:
        for field in fields:
            resolve_keyed_by(test, field, item_name=test['test-name'])

        # We need to make the split immediately so that we can split
        # task configurations by pageload type, the `both` condition is
        # the same as not having a by-pageload split.
        if test['pageload'] == 'both':
            test['pageload'] = 'cold'

            warmtest = deepcopy(test)
            warmtest['pageload'] = 'warm'
            yield warmtest

        yield test


@transforms.add
def split_raptor_subtests(config, tests):
    for test in tests:
        # For tests that have 'raptor-subtests' listed, we want to create a separate
        # test job for every subtest (i.e. split out each page-load URL into its own job)
        subtests = test.pop('raptor-subtests', None)
        if not subtests:
            yield test
            continue

        chunk_number = 0

        for subtest in subtests:
            chunk_number += 1

            # Create new test job
            chunked = deepcopy(test)
            chunked['chunk-number'] = chunk_number
            chunked['subtest'] = subtest

            yield chunked


@transforms.add
def handle_keyed_by(config, tests):
    fields = [
        'variants',
        'limit-platforms',
        'activity',
        'binary-path',
        'fetches.fetch',
        'fission-run-on-projects',
        'max-run-time',
        'run-on-projects',
        'target',
        'tier',
        'run-visual-metrics'
    ]
    for test in tests:
        for field in fields:
            resolve_keyed_by(test, field, item_name=test['test-name'])
        yield test


@transforms.add
def split_pageload(config, tests):
    # Split test by pageload type (cold, warm)
    for test in tests:
        pageload = test.pop('pageload', 'warm')

        if pageload not in ('cold', 'both'):
            yield test
            continue

        if pageload == 'both':
            orig = deepcopy(test)
            yield orig

        assert 'subtest' in test
        test['description'] += " using cold pageload"

        test['cold'] = True

        test['max-run-time'] = 3000
        test['test-name'] += '-cold'
        test['try-name'] += '-cold'

        group, symbol = split_symbol(test['treeherder-symbol'])
        symbol += '-c'
        test['treeherder-symbol'] = join_symbol(group, symbol)
        yield test


@transforms.add
def split_page_load_by_url(config, tests):
    for test in tests:
        # `chunk-number` and 'subtest' only exists when the task had a
        # definition for `raptor-subtests`
        chunk_number = test.pop('chunk-number', None)
        subtest = test.pop('subtest', None)

        if not chunk_number or not subtest:
            yield test
            continue

        if isinstance(subtest, list):
            subtest, subtest_symbol = subtest
        else:
            subtest_symbol = subtest
            subtest = subtest

        if len(subtest_symbol) > 10:
            raise Exception(
                "Treeherder symbol %s is lager than 10 char! Please use a different symbol."
                % subtest_symbol)

        if test['test-name'].startswith('browsertime-tp6'):
            test['raptor-test'] = subtest
        else:
            # Use full test name if running on webextension
            test['raptor-test'] = 'raptor-tp6-' + subtest + "-{}".format(test['app'])

        # Only run the subtest/single URL
        test['test-name'] += "-{}".format(subtest)
        test['try-name'] += "-{}".format(subtest)

        # Set treeherder symbol and description
        group, symbol = split_symbol(test['treeherder-symbol'])

        symbol = subtest_symbol
        if test.get("cold"):
            symbol += "-c"

        test['treeherder-symbol'] = join_symbol(group, symbol)
        test['description'] += " on {}".format(subtest)

        yield test


@transforms.add
def add_extra_options(config, tests):
    for test in tests:
        mozharness = test.setdefault('mozharness', {})
        if test.get('app', '') == 'chrome-m':
            mozharness['tooltool-downloads'] = 'internal'

        extra_options = mozharness.setdefault('extra-options', [])

        # Adding device name if we're on android
        test_platform = test['test-platform']
        if test_platform.startswith('android-hw-g5'):
            extra_options.append('--device-name=g5')
        elif test_platform.startswith('android-hw-p2'):
            extra_options.append('--device-name=p2_aarch64')

        if test.pop('run-visual-metrics', False):
            extra_options.append('--browsertime-video')
            test['attributes']['run-visual-metrics'] = True

        if 'app' in test:
            extra_options.append('--app={}'.format(test.pop('app')))

        if test.pop('cold', False) is True:
            extra_options.append('--cold')

        if 'activity' in test:
            extra_options.append('--activity={}'.format(test.pop('activity')))

        if 'binary-path' in test:
            extra_options.append('--binary-path={}'.format(test.pop('binary-path')))

        if 'raptor-test' in test:
            extra_options.append('--test={}'.format(test.pop('raptor-test')))

        if test['require-signed-extensions']:
            extra_options.append('--is-release-build')

        extra_options.append("--project={}".format(config.params.get('project')))

        # Add urlparams based on platform, test names and projects
        testurlparams_by_platform_and_project = {
            "android-hw-g5": [
                {
                    "branches": [],  # For all branches
                    "testnames": ["youtube-playback"],
                    "urlparams": [
                        # It excludes all VP9 tests
                        "exclude=1-34"
                    ]
                },
            ]
        }

        for platform, testurlparams_by_project_definitions \
                in testurlparams_by_platform_and_project.items():

            if test['test-platform'].startswith(platform):
                # For every platform it may have several definitions
                for testurlparams_by_project in testurlparams_by_project_definitions:
                    # The test should contain at least one defined testname
                    if any(
                        testname in test['test-name']
                        for testname in testurlparams_by_project['testnames']
                    ):
                        branches = testurlparams_by_project['branches']
                        if (
                            branches == [] or
                            config.params.get('project') in branches or
                            config.params.is_try() and 'try' in branches
                        ):
                            params_query = '&'.join(testurlparams_by_project['urlparams'])
                            add_extra_params_option = "--test-url-params={}".format(params_query)
                            extra_options.append(add_extra_params_option)

        yield test
