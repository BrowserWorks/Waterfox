import sys
import os
import unittest

from selenium import webdriver
from selenium.webdriver.firefox.firefox_binary import FirefoxBinary
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException


class TestStoreHandler(unittest.TestCase):
    binary_path = ""
    url = "https://chrome.google.com/webstore/detail/metamask/nkbihfbeogaeaoehlefnkodbefgpgknn"

    def setUp(self):
        binary = FirefoxBinary(self.binary_path)
        self.driver = webdriver.Firefox(firefox_binary=binary)

    def test_chrome_web_store_handler(self):
        TEST_ID = "waterfox-extension-test"
        # Open webstore test URL, accepting consent if required
        self.driver.get(self.url)
        if self.driver.title == "Before you continue":
            consent = self.driver.find_element(
                by=By.CSS_SELECTOR, value='[aria-label*="Agree to the use of cookies"'
            )
            consent.click()

        # Get the install button and click it
        try:
            element = WebDriverWait(self.driver, 20).until(
                EC.presence_of_element_located(
                    (By.CSS_SELECTOR, '[aria-label*="Chrome"')
                )
            )
            element.click()

            # Get the resulting popup
            notif = WebDriverWait(self.driver, 20).until(
                EC.presence_of_element_located((By.ID, TEST_ID))
            )
        except TimeoutException:
            raise Exception("Element acquisition timed out.")

        # Verify that popup is opened
        self.assertEqual(notif.get_attribute("id"), TEST_ID, "Store handler intiated.")

    def tearDown(self):
        self.driver.quit()


if __name__ == "__main__":
    if len(sys.argv) > 2 and not os.path.isfile(sys.argv[1]):
        print("Only 1 argument is allowed and it must be a path to a Waterfox binary")
        sys.exit()
    TestStoreHandler.binary_path = sys.argv.pop()
    unittest.main()
