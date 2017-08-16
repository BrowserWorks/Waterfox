# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

from marionette_driver import errors

from marionette_harness import MarionetteTestCase, skip


class TestServerQuitApplication(MarionetteTestCase):

    def tearDown(self):
        if self.marionette.session is None:
            self.marionette.start_session()

    def quit(self, flags=None):
        body = None
        if flags is not None:
            body = {"flags": list(flags)}

        try:
            resp = self.marionette._send_message("quit", body)
        finally:
            self.marionette.session_id = None
            self.marionette.session = None
            self.marionette.process_id = None
            self.marionette.profile = None
            self.marionette.window = None

        self.assertIn("cause", resp)

        self.marionette.client.close()
        self.marionette.instance.runner.wait()

        return resp["cause"]

    def test_types(self):
        for typ in [42, True, "foo", []]:
            print("testing type {}".format(type(typ)))
            with self.assertRaises(errors.InvalidArgumentException):
                self.marionette._send_message("quit", typ)

        with self.assertRaises(errors.InvalidArgumentException):
            self.quit("foo")

    def test_undefined_default(self):
        cause = self.quit()
        self.assertEqual("shutdown", cause)

    def test_empty_default(self):
        cause = self.quit(())
        self.assertEqual("shutdown", cause)

    def test_incompatible_flags(self):
        with self.assertRaises(errors.InvalidArgumentException):
            self.quit(("eAttemptQuit", "eForceQuit"))

    def test_attempt_quit(self):
        cause = self.quit(("eAttemptQuit",))
        self.assertEqual("shutdown", cause)

    def test_force_quit(self):
        cause = self.quit(("eForceQuit",))
        self.assertEqual("shutdown", cause)


class TestQuitRestart(MarionetteTestCase):

    def setUp(self):
        MarionetteTestCase.setUp(self)

        self.pid = self.marionette.process_id
        self.profile = self.marionette.profile
        self.session_id = self.marionette.session_id

        # Use a preference to check that the restart was successful. If its
        # value has not been forced, a restart will cause a reset of it.
        self.assertNotEqual(self.marionette.get_pref("startup.homepage_welcome_url"),
                            "about:")
        self.marionette.set_pref("startup.homepage_welcome_url", "about:")

    def tearDown(self):
        # Ensure to restart a session if none exist for clean-up
        if self.marionette.session is None:
            self.marionette.start_session()

        self.marionette.clear_pref("startup.homepage_welcome_url")

        MarionetteTestCase.tearDown(self)

    def shutdown(self, restart=False):
        self.marionette.set_context("chrome")
        self.marionette.execute_script("""
            Components.utils.import("resource://gre/modules/Services.jsm");
            let flags = Ci.nsIAppStartup.eAttemptQuit;
            if (arguments[0]) {
              flags |= Ci.nsIAppStartup.eRestart;
            }
            Services.startup.quit(flags);
        """, script_args=(restart,))

    def test_force_clean_restart(self):
        self.marionette.restart(clean=True)
        self.assertNotEqual(self.marionette.profile, self.profile)
        self.assertEqual(self.marionette.session_id, self.session_id)

        # A forced restart will cause a new process id
        self.assertNotEqual(self.marionette.process_id, self.pid)
        self.assertNotEqual(self.marionette.get_pref("startup.homepage_welcome_url"),
                            "about:")

    def test_force_restart(self):
        self.marionette.restart()
        self.assertEqual(self.marionette.profile, self.profile)
        self.assertEqual(self.marionette.session_id, self.session_id)

        # A forced restart will cause a new process id
        self.assertNotEqual(self.marionette.process_id, self.pid)
        self.assertNotEqual(self.marionette.get_pref("startup.homepage_welcome_url"),
                            "about:")

    def test_force_clean_quit(self):
        self.marionette.quit(clean=True)

        self.assertEqual(self.marionette.session, None)
        with self.assertRaisesRegexp(errors.MarionetteException, "Please start a session"):
            self.marionette.get_url()

        self.marionette.start_session()
        self.assertNotEqual(self.marionette.profile, self.profile)
        self.assertNotEqual(self.marionette.session_id, self.session_id)
        self.assertNotEqual(self.marionette.get_pref("startup.homepage_welcome_url"),
                            "about:")

    def test_force_quit(self):
        self.marionette.quit()

        self.assertEqual(self.marionette.session, None)
        with self.assertRaisesRegexp(errors.MarionetteException, "Please start a session"):
            self.marionette.get_url()

        self.marionette.start_session()
        self.assertEqual(self.marionette.profile, self.profile)
        self.assertNotEqual(self.marionette.session_id, self.session_id)
        self.assertNotEqual(self.marionette.get_pref("startup.homepage_welcome_url"),
                            "about:")

    @skip("Bug 1363368 - Wrong window handles after in_app restarts")
    def test_no_in_app_clean_restart(self):
        # Test that in_app and clean cannot be used in combination
        with self.assertRaises(ValueError):
            self.marionette.restart(in_app=True, clean=True)

    @skip("Bug 1363368 - Wrong window handles after in_app restarts")
    def test_in_app_restart(self):
        if self.marionette.session_capabilities["platformName"] != "windows_nt":
            skip("Bug 1363368 - Wrong window handles after in_app restarts")

        self.marionette.restart(in_app=True)
        self.assertEqual(self.marionette.profile, self.profile)
        self.assertEqual(self.marionette.session_id, self.session_id)

        # An in-app restart will keep the same process id only on Linux
        if self.marionette.session_capabilities["platformName"] == "linux":
            self.assertEqual(self.marionette.process_id, self.pid)
        else:
            self.assertNotEqual(self.marionette.process_id, self.pid)

        self.assertNotEqual(self.marionette.get_pref("startup.homepage_welcome_url"),
                            "about:")

    @skip("Bug 1363368 - Wrong window handles after in_app restarts")
    def test_in_app_restart_with_callback(self):
        if self.marionette.session_capabilities["platformName"] != "windows_nt":
            skip("Bug 1363368 - Wrong window handles after in_app restarts")

        self.marionette.restart(in_app=True,
                                callback=lambda: self.shutdown(restart=True))

        self.assertEqual(self.marionette.profile, self.profile)
        self.assertEqual(self.marionette.session_id, self.session_id)

        # An in-app restart will keep the same process id only on Linux
        if self.marionette.session_capabilities["platformName"] == "linux":
            self.assertEqual(self.marionette.process_id, self.pid)
        else:
            self.assertNotEqual(self.marionette.process_id, self.pid)

        self.assertNotEqual(self.marionette.get_pref("startup.homepage_welcome_url"),
                            "about:")

    def test_in_app_restart_with_callback_no_shutdown(self):
        try:
            timeout_startup = self.marionette.DEFAULT_STARTUP_TIMEOUT
            timeout_shutdown = self.marionette.DEFAULT_SHUTDOWN_TIMEOUT
            self.marionette.DEFAULT_SHUTDOWN_TIMEOUT = 5
            self.marionette.DEFAULT_STARTUP_TIMEOUT = 5

            with self.assertRaisesRegexp(IOError, "the connection to Marionette server is lost"):
                self.marionette.restart(in_app=True, callback=lambda: False)
        finally:
            self.marionette.DEFAULT_STARTUP_TIMEOUT = timeout_startup
            self.marionette.DEFAULT_SHUTDOWN_TIMEOUT = timeout_shutdown

    @skip("Bug 1363368 - Wrong window handles after in_app restarts")
    def test_in_app_quit(self):
        if self.marionette.session_capabilities["platformName"] != "windows_nt":
            skip("Bug 1363368 - Wrong window handles after in_app restarts")

        self.marionette.quit(in_app=True)

        self.assertEqual(self.marionette.session, None)
        with self.assertRaisesRegexp(errors.MarionetteException, "Please start a session"):
            self.marionette.get_url()

        self.marionette.start_session()
        self.assertEqual(self.marionette.profile, self.profile)
        self.assertNotEqual(self.marionette.session_id, self.session_id)
        self.assertNotEqual(self.marionette.get_pref("startup.homepage_welcome_url"),
                            "about:")

    @skip("Bug 1363368 - Wrong window handles after in_app restarts")
    def test_in_app_quit_with_callback(self):
        if self.marionette.session_capabilities["platformName"] != "windows_nt":
            skip("Bug 1363368 - Wrong window handles after in_app restarts")

        self.marionette.quit(in_app=True, callback=self.shutdown)
        self.assertEqual(self.marionette.session, None)
        with self.assertRaisesRegexp(errors.MarionetteException, "Please start a session"):
            self.marionette.get_url()

        self.marionette.start_session()
        self.assertEqual(self.marionette.profile, self.profile)
        self.assertNotEqual(self.marionette.session_id, self.session_id)
        self.assertNotEqual(self.marionette.get_pref("startup.homepage_welcome_url"),
                            "about:")

    def test_in_app_quit_with_callback_no_shutdown(self):
        try:
            timeout = self.marionette.DEFAULT_SHUTDOWN_TIMEOUT
            self.marionette.DEFAULT_SHUTDOWN_TIMEOUT = 10

            with self.assertRaisesRegexp(IOError, "a requested application quit did not happen"):
                self.marionette.quit(in_app=True, callback=lambda: False)
        finally:
            self.marionette.DEFAULT_SHUTDOWN_TIMEOUT = timeout

    @skip("Bug 1363368 - Wrong window handles after in_app restarts")
    def test_reset_context_after_quit_by_set_context(self):
        if self.marionette.session_capabilities["platformName"] != "windows_nt":
            skip("Bug 1363368 - Wrong window handles after in_app restarts")

        # Check that we are in content context which is used by default in
        # Marionette
        self.assertNotIn("chrome://", self.marionette.get_url(),
                         "Context does not default to content")

        self.marionette.set_context("chrome")
        self.marionette.quit(in_app=True)
        self.assertEqual(self.marionette.session, None)
        self.marionette.start_session()
        self.assertNotIn("chrome://", self.marionette.get_url(),
                         "Not in content context after quit with using_context")

    @skip("Bug 1363368 - Wrong window handles after in_app restarts")
    def test_reset_context_after_quit_by_using_context(self):
        if self.marionette.session_capabilities["platformName"] != "windows_nt":
            skip("Bug 1363368 - Wrong window handles after in_app restarts")

        # Check that we are in content context which is used by default in
        # Marionette
        self.assertNotIn("chrome://", self.marionette.get_url(),
                         "Context does not default to content")

        with self.marionette.using_context("chrome"):
            self.marionette.quit(in_app=True)
            self.assertEqual(self.marionette.session, None)
            self.marionette.start_session()
            self.assertNotIn("chrome://", self.marionette.get_url(),
                             "Not in content context after quit with using_context")

    @skip("Bug 1363368 - Wrong window handles after in_app restarts")
    def test_keep_context_after_restart_by_set_context(self):
        if self.marionette.session_capabilities["platformName"] != "windows_nt":
            skip("Bug 1363368 - Wrong window handles after in_app restarts")

        # Check that we are in content context which is used by default in
        # Marionette
        self.assertNotIn("chrome://", self.marionette.get_url(),
                         "Context doesn't default to content")

        # restart while we are in chrome context
        self.marionette.set_context("chrome")
        self.marionette.restart(in_app=True)

        # An in-app restart will keep the same process id only on Linux
        if self.marionette.session_capabilities["platformName"] == "linux":
            self.assertEqual(self.marionette.process_id, self.pid)
        else:
            self.assertNotEqual(self.marionette.process_id, self.pid)

        self.assertIn("chrome://", self.marionette.get_url(),
                      "Not in chrome context after a restart with set_context")

    @skip("Bug 1363368 - Wrong window handles after in_app restarts")
    def test_keep_context_after_restart_by_using_context(self):
        if self.marionette.session_capabilities["platformName"] != "windows_nt":
            skip("Bug 1363368 - Wrong window handles after in_app restarts")

        # Check that we are in content context which is used by default in
        # Marionette
        self.assertNotIn("chrome://", self.marionette.get_url(),
                         "Context does not default to content")

        # restart while we are in chrome context
        with self.marionette.using_context('chrome'):
            self.marionette.restart(in_app=True)

            # An in-app restart will keep the same process id only on Linux
            if self.marionette.session_capabilities["platformName"] == "linux":
                self.assertEqual(self.marionette.process_id, self.pid)
            else:
                self.assertNotEqual(self.marionette.process_id, self.pid)

            self.assertIn("chrome://", self.marionette.get_url(),
                          "Not in chrome context after a restart with using_context")
