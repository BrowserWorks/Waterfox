# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

from marionette_driver.by import By
from marionette_driver.errors import (
    JavascriptException,
    NoSuchFrameException,
)

from marionette_harness import MarionetteTestCase


class TestSwitchFrame(MarionetteTestCase):
    def test_switch_simple(self):
        start_url = "test_iframe.html"
        verify_title = "Marionette IFrame Test"
        test_html = self.marionette.absolute_url(start_url)
        self.marionette.navigate(test_html)
        self.assertEqual(self.marionette.get_active_frame(), None)
        frame = self.marionette.find_element(By.ID, "test_iframe")
        self.marionette.switch_to_frame(frame)
        self.assertTrue(start_url in self.marionette.get_url())
        inner_frame_element = self.marionette.get_active_frame()
        # test that we can switch back to main frame, then switch back to the
        # inner frame with the value we got from get_active_frame
        self.marionette.switch_to_frame()
        self.assertEqual(verify_title, self.marionette.title)
        self.marionette.switch_to_frame(inner_frame_element)
        self.assertTrue(start_url in self.marionette.get_url())

    def test_switch_nested(self):
        start_url = "test_nested_iframe.html"
        verify_title = "Marionette IFrame Test"
        test_html = self.marionette.absolute_url(start_url)
        self.marionette.navigate(test_html)
        frame = self.marionette.find_element(By.ID, "test_iframe")
        self.assertEqual(self.marionette.get_active_frame(), None)
        self.marionette.switch_to_frame(frame)
        self.assertTrue(start_url in self.marionette.get_url())
        inner_frame_element = self.marionette.get_active_frame()
        # test that we can switch back to main frame, then switch back to the
        # inner frame with the value we got from get_active_frame
        self.marionette.switch_to_frame()
        self.assertEqual(verify_title, self.marionette.title)
        self.marionette.switch_to_frame(inner_frame_element)
        self.assertTrue(start_url in self.marionette.get_url())
        inner_frame = self.marionette.find_element(By.ID, 'inner_frame')
        self.marionette.switch_to_frame(inner_frame)
        self.assertTrue(start_url in self.marionette.get_url())
        self.marionette.switch_to_frame() # go back to main frame
        self.assertTrue(start_url in self.marionette.get_url())
        #test that we're using the right window object server-side
        self.assertTrue("test_nested_iframe.html" in self.marionette.execute_script("return window.location.href;"))

    def test_stack_trace(self):
        start_url = "test_iframe.html"
        verify_title = "Marionette IFrame Test"
        test_html = self.marionette.absolute_url(start_url)
        self.marionette.navigate(test_html)
        frame = self.marionette.find_element(By.ID, "test_iframe")
        self.assertEqual(self.marionette.get_active_frame(), None)
        self.marionette.switch_to_frame(frame)
        self.assertTrue(start_url in self.marionette.get_url())
        inner_frame_element = self.marionette.get_active_frame()
        # test that we can switch back to main frame, then switch back to the
        # inner frame with the value we got from get_active_frame
        self.marionette.switch_to_frame()
        self.assertEqual(verify_title, self.marionette.title)
        self.marionette.switch_to_frame(inner_frame_element)
        self.assertTrue(start_url in self.marionette.get_url())

        try:
            self.marionette.execute_async_script("foo();")
        except JavascriptException as e:
            self.assertTrue("foo" in e.message)

    def test_should_be_able_to_carry_on_working_if_the_frame_is_deleted_from_under_us(self):
        test_html = self.marionette.absolute_url("deletingFrame.html")
        self.marionette.navigate(test_html)

        self.marionette.switch_to_frame(self.marionette.find_element(By.ID,
                                                                     'iframe1'))
        killIframe = self.marionette.find_element(By.ID, "killIframe")
        killIframe.click()
        self.marionette.switch_to_frame()

        self.assertEqual(0, len(self.marionette.find_elements(By.ID, "iframe1")))

        addIFrame = self.marionette.find_element(By.ID, "addBackFrame")
        addIFrame.click()
        self.marionette.find_element(By.ID, "iframe1")

        self.marionette.switch_to_frame(self.marionette.find_element(By.ID,
                                                                     "iframe1"))

        self.marionette.find_element(By.ID, "checkbox")

    def test_should_allow_a_user_to_switch_from_an_iframe_back_to_the_main_content_of_the_page(self):
        test_iframe = self.marionette.absolute_url("test_iframe.html")
        self.marionette.navigate(test_iframe)
        self.marionette.switch_to_frame(0)
        self.marionette.switch_to_default_content()
        header = self.marionette.find_element(By.ID, "iframe_page_heading")
        self.assertEqual(header.text, "This is the heading")

    def test_should_be_able_to_switch_to_a_frame_by_its_index(self):
        test_html = self.marionette.absolute_url("frameset.html")
        self.marionette.navigate(test_html)
        self.marionette.switch_to_frame(2)
        element = self.marionette.find_element(By.ID, "email")
        self.assertEquals("email", element.get_attribute("type"))

    def test_should_be_able_to_switch_to_a_frame_using_a_previously_located_element(self):
        test_html = self.marionette.absolute_url("frameset.html")
        self.marionette.navigate(test_html)
        frame = self.marionette.find_element(By.NAME, "third")
        self.marionette.switch_to_frame(frame)

        element = self.marionette.find_element(By.ID, "email")
        self.assertEquals("email", element.get_attribute("type"))

    def test_switch_to_frame_with_out_of_bounds_index(self):
        self.marionette.navigate(self.marionette.absolute_url("test_iframe.html"))
        count = self.marionette.execute_script("return window.frames.length;")
        self.assertRaises(NoSuchFrameException, self.marionette.switch_to_frame, count)

    def test_switch_to_frame_with_negative_index(self):
        self.marionette.navigate(self.marionette.absolute_url("test_iframe.html"))
        self.assertRaises(NoSuchFrameException, self.marionette.switch_to_frame, -1)

    def test_switch_to_parent_frame(self):
        frame_html = self.marionette.absolute_url("frameset.html")
        self.marionette.navigate(frame_html)
        frame = self.marionette.find_element(By.NAME, "third")
        self.marionette.switch_to_frame(frame)

        # If we don't find the following element we aren't on the right page
        self.marionette.find_element(By.ID, "checky")
        form_page_title = self.marionette.execute_script("return document.title")
        self.assertEqual("We Leave From Here", form_page_title)

        self.marionette.switch_to_parent_frame()

        current_page_title = self.marionette.execute_script("return document.title")
        self.assertEqual("Unique title", current_page_title)

    def test_switch_to_parent_frame_from_default_context_is_a_noop(self):
        formpage = self.marionette.absolute_url("formPage.html")
        self.marionette.navigate(formpage)

        self.marionette.switch_to_parent_frame()

        form_page_title = self.marionette.execute_script("return document.title")
        self.assertEqual("We Leave From Here", form_page_title)

    def test_should_be_able_to_switch_to_parent_from_second_level(self):
        frame_html = self.marionette.absolute_url("frameset.html")
        self.marionette.navigate(frame_html)
        frame = self.marionette.find_element(By.NAME, "fourth")
        self.marionette.switch_to_frame(frame)

        second_level = self.marionette.find_element(By.NAME, "child1")
        self.marionette.switch_to_frame(second_level)
        self.marionette.find_element(By.NAME, "myCheckBox")

        self.marionette.switch_to_parent_frame()

        second_level = self.marionette.find_element(By.NAME, "child1")

    def test_should_be_able_to_switch_to_parent_from_iframe(self):
        frame_html = self.marionette.absolute_url("test_iframe.html")
        self.marionette.navigate(frame_html)
        frame = self.marionette.find_element(By.ID, "test_iframe")
        self.marionette.switch_to_frame(frame)

        current_page_title = self.marionette.execute_script("return document.title")
        self.assertEqual("Marionette Test", current_page_title)

        self.marionette.switch_to_parent_frame()

        parent_page_title = self.marionette.execute_script("return document.title")
        self.assertEqual("Marionette IFrame Test", parent_page_title)
