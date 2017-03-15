# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

from marionette_driver import By

from marionette_harness import MarionetteTestCase, WindowManagerMixin


class TestWindowHandles(WindowManagerMixin, MarionetteTestCase):

    def setUp(self):
        super(TestWindowHandles, self).setUp()

        self.empty_page = self.marionette.absolute_url("empty.html")
        self.test_page = self.marionette.absolute_url("windowHandles.html")
        self.marionette.navigate(self.test_page)

    def tearDown(self):
        self.close_all_tabs()

        super(TestWindowHandles, self).tearDown()

    def test_window_handles_after_opening_new_tab(self):
        def open_with_link():
            link = self.marionette.find_element(By.ID, "new-tab")
            link.click()

        new_tab = self.open_tab(trigger=open_with_link)
        self.assertEqual(len(self.marionette.window_handles), len(self.start_tabs) + 1)
        self.assertEqual(self.marionette.current_window_handle, self.start_tab)

        self.marionette.switch_to_window(new_tab)
        self.assertEqual(self.marionette.current_window_handle, new_tab)
        self.assertEqual(self.marionette.get_url(), self.empty_page)

        self.marionette.switch_to_window(self.start_tab)
        self.assertEqual(self.marionette.current_window_handle, self.start_tab)
        self.assertEqual(self.marionette.get_url(), self.test_page)

        self.marionette.switch_to_window(new_tab)
        self.marionette.close()
        self.assertEqual(len(self.marionette.window_handles), len(self.start_tabs))

        self.marionette.switch_to_window(self.start_tab)
        self.assertEqual(self.marionette.current_window_handle, self.start_tab)

    def test_window_handles_after_opening_new_window(self):
        def open_with_link():
            link = self.marionette.find_element(By.ID, "new-window")
            link.click()

        # We open a new window but are actually interested in the new tab
        new_tab = self.open_tab(trigger=open_with_link)
        self.assertEqual(len(self.marionette.window_handles), len(self.start_tabs) + 1)
        self.assertEqual(self.marionette.current_window_handle, self.start_tab)

        # Check that the new tab has the correct page loaded
        self.marionette.switch_to_window(new_tab)
        self.assertEqual(self.marionette.current_window_handle, new_tab)
        self.assertEqual(self.marionette.get_url(), self.empty_page)

        # Ensure navigate works in our current window
        other_page = self.marionette.absolute_url("test.html")
        self.marionette.navigate(other_page)
        self.assertEqual(self.marionette.get_url(), other_page)

        # Close the opened window and carry on in our original tab.
        self.marionette.close()
        self.assertEqual(len(self.marionette.window_handles), len(self.start_tabs))

        self.marionette.switch_to_window(self.start_tab)
        self.assertEqual(self.marionette.current_window_handle, self.start_tab)
        self.assertEqual(self.marionette.get_url(), self.test_page)

    def test_window_handles_after_closing_original_tab(self):
        def open_with_link():
            link = self.marionette.find_element(By.ID, "new-tab")
            link.click()

        new_tab = self.open_tab(trigger=open_with_link)
        self.assertEqual(len(self.marionette.window_handles), len(self.start_tabs) + 1)
        self.assertEqual(self.marionette.current_window_handle, self.start_tab)

        self.marionette.close()
        self.assertEqual(len(self.marionette.window_handles), len(self.start_tabs))

        self.marionette.switch_to_window(new_tab)
        self.assertEqual(self.marionette.current_window_handle, new_tab)
        self.assertEqual(self.marionette.get_url(), self.empty_page)
