# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.
from __future__ import print_function, unicode_literals

import os
import signal
import sys

here = os.path.abspath(os.path.dirname(__file__))

from marionette_driver import expected
from marionette_driver.by import By
from marionette_driver.marionette import Marionette
from marionette_driver.wait import Wait

from mozprocess import ProcessHandler
from mozrunner import FirefoxRunner
import mozinfo
import mozlog

from runreftest import RefTest
from output import OutputHandler
import reftestcommandline


class MuletReftest(RefTest):
    build_type = "mulet"
    marionette = None

    def __init__(self, marionette_args):
        RefTest.__init__(self)
        self.last_test = os.path.basename(__file__)
        self.marionette_args = marionette_args
        self.profile = None
        self.runner = None
        self.test_script = os.path.join(here, 'b2g_start_script.js')
        self.timeout = None

    def run_marionette_script(self):
        self.marionette = Marionette(**self.marionette_args)
        assert(self.marionette.wait_for_port())
        self.marionette.start_session()
        if self.build_type == "mulet":
            self._wait_for_homescreen(timeout=300)
            self._unlockScreen()
        self.marionette.set_context(self.marionette.CONTEXT_CHROME)

        if os.path.isfile(self.test_script):
            f = open(self.test_script, 'r')
            self.test_script = f.read()
            f.close()
        self.marionette.execute_script(self.test_script)

    def run_tests(self, tests, options):
        manifests = self.resolver.resolveManifests(options, tests)

        self.profile = self.create_profile(options, manifests,
                                           profile_to_clone=options.profile)
        env = self.buildBrowserEnv(options, self.profile.profile)

        self._populate_logger(options)
        outputHandler = OutputHandler(self.log, options.utilityPath, symbolsPath=options.symbolsPath)

        kp_kwargs = { 'processOutputLine': [outputHandler],
                      'onTimeout': [self._on_timeout],
                      'kill_on_timeout': False }

        if not options.debugger:
            if not options.timeout:
                if mozinfo.info['debug']:
                    options.timeout = 420
                else:
                    options.timeout = 300
            self.timeout = options.timeout + 30.0

        self.log.info("%s | Running tests: start." % os.path.basename(__file__))
        cmd, args = self.build_command_line(options.app,
                            ignore_window_size=options.ignoreWindowSize,
                            browser_arg=options.browser_arg)
        self.runner = FirefoxRunner(profile=self.profile,
                                    binary=cmd,
                                    cmdargs=args,
                                    env=env,
                                    process_class=ProcessHandler,
                                    process_args=kp_kwargs,
                                    symbols_path=options.symbolsPath)

        status = 0
        try:
            self.runner.start(outputTimeout=self.timeout)
            self.log.info("%s | Application pid: %d" % (
                     os.path.basename(__file__),
                     self.runner.process_handler.pid))

            # kick starts the reftest harness
            self.run_marionette_script()
            status = self.runner.wait()
        finally:
            self.runner.check_for_crashes(test_name=self.last_test)
            self.runner.cleanup()

        if status > 0:
            self.log.testFail("%s | application terminated with exit code %s" % (
                         self.last_test, status))
        elif status < 0:
            self.log.info("%s | application killed with signal %s" % (
                         self.last_test, -status))

        self.log.info("%s | Running tests: end." % os.path.basename(__file__))
        return status

    def create_profile(self, options, manifests, profile_to_clone=None):
        profile = RefTest.createReftestProfile(self, options, manifests,
                                               profile_to_clone=profile_to_clone)

        prefs = {}
        # Turn off the locale picker screen
        prefs["browser.firstrun.show.localepicker"] = False
        if not self.build_type == "mulet":
            # FIXME: With Mulet we can't set this values since Gaia won't launch
            prefs["b2g.system_startup_url"] = \
                    "app://test-container.gaiamobile.org/index.html"
            prefs["b2g.system_manifest_url"] = \
                    "app://test-container.gaiamobile.org/manifest.webapp"
        # Make sure we disable system updates
        prefs["app.update.enabled"] = False
        prefs["app.update.url"] = ""
        # Disable webapp updates
        prefs["webapps.update.enabled"] = False
        # Disable tiles also
        prefs["browser.newtabpage.directory.source"] = ""
        prefs["browser.newtabpage.directory.ping"] = ""
        prefs["dom.ipc.tabs.disabled"] = False
        prefs["dom.mozBrowserFramesEnabled"] = True
        prefs["font.size.inflation.emPerLine"] = 0
        prefs["font.size.inflation.minTwips"] = 0
        prefs["network.dns.localDomains"] = "app://test-container.gaiamobile.org"
        prefs["reftest.browser.iframe.enabled"] = False
        prefs["reftest.remote"] = False

        # Set the extra prefs.
        profile.set_preferences(prefs)
        return profile

    def build_command_line(self, app, ignore_window_size=False,
                           browser_arg=None):
        cmd = os.path.abspath(app)
        args = ['-marionette']

        if browser_arg:
            args += [browser_arg]

        if not ignore_window_size:
            args.extend(['--screen', '800x1000'])

        if self.build_type == "mulet":
            args += ['-chrome', 'chrome://b2g/content/shell.html']
        return cmd, args

    def _on_timeout(self):
        msg = "%s | application timed out after %s seconds with no output"
        self.log.testFail(msg % (self.last_test, self.timeout))
        self.log.error("Force-terminating active process(es).");

        # kill process to get a stack
        self.runner.stop(sig=signal.SIGABRT)

    def _unlockScreen(self):
        self.marionette.set_context(self.marionette.CONTEXT_CONTENT)
        self.marionette.import_script(os.path.abspath(
            os.path.join(__file__, os.path.pardir, "gaia_lock_screen.js")))
        self.marionette.switch_to_frame()
        self.marionette.execute_async_script('GaiaLockScreen.unlock()')

    def _wait_for_homescreen(self, timeout):
        self.log.info("Waiting for home screen to load")
        Wait(self.marionette, timeout).until(expected.element_present(
            By.CSS_SELECTOR, '#homescreen[loading-state=false]'))


def run_test_harness(parser, options):
    marionette_args = {}
    if options.marionette:
        host, port = options.marionette.split(':')
        marionette_args['host'] = host
        marionette_args['port'] = int(port)

    reftest = MuletReftest(marionette_args)
    parser.validate(options, reftest)

    # add a -bin suffix if b2g-bin exists, but just b2g was specified
    if options.app[-4:] != '-bin':
        if os.path.isfile("%s-bin" % options.app):
            options.app = "%s-bin" % options.app

    if options.xrePath is None:
        options.xrePath = os.path.dirname(options.app)

    if options.mulet and not options.profile:
        raise Exception("must specify --profile when specifying --mulet")

    return reftest.run_tests(options.tests, options)
