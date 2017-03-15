#Copyright 2007-2009 WebDriver committers
#Copyright 2007-2009 Google Inc.
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

from marionette_driver.by import By

from marionette_harness import MarionetteTestCase


class RenderedElementTests(MarionetteTestCase):

    def testWeCanGetComputedStyleValueOnElement(self):
        test_url = self.marionette.absolute_url('javascriptPage.html')
        self.marionette.navigate(test_url)
        element = self.marionette.find_element(By.ID, "green-parent")
        backgroundColour = element.value_of_css_property("background-color")

        self.assertEqual("rgb(0, 128, 0)", backgroundColour)

        element = self.marionette.find_element(By.ID, "red-item")
        backgroundColour = element.value_of_css_property("background-color")

        self.assertEqual("rgb(255, 0, 0)", backgroundColour)
