import unittest
import os
import sys
import subprocess
from datetime import datetime

import requests
from selenium import webdriver
from selenium.webdriver.firefox.firefox_binary import FirefoxBinary
from selenium.webdriver.firefox.options import Options
from selenium.webdriver.firefox.firefox_profile import FirefoxProfile

p = os.path.abspath("../../../../../python/mozrelease/mozrelease")
sys.path.insert(1, p)
from partner_attribution import write_attribution_data


def get_preference():
    return """
            document.getElementById("about-config-search").value = arguments[0];
            filterPrefs({
                shortString: true
            });
            value = document.querySelector("#prefs .has-user-value .cell-value span span")
                .innerText;
            return value;
        """


class TestWindowsAttribution(unittest.TestCase):
    working_dir = ""
    version = ""

    def setUp(self):
        os.chdir(self.working_dir)

        # Get the installer
        installer_loc = (
            "obj-x86_64-pc-mingw32\dist\install\sea\Waterfox {version} Setup.exe"
        )
        if not os.path.isfile(installer_loc):
            installer_loc = "waterfox.exe"
            url = f"https://cdn.waterfox.net/releases/win64/installer/Waterfox%20{self.version}%20Setup.exe"
            r = requests.get(url, stream=True)
            r.raise_for_status()
            with open(installer_loc, "wb") as outfile:
                for chunk in r.iter_content(chunk_size=4096):
                    if chunk:
                        outfile.write(chunk)

        # Inject some attribution data
        write_attribution_data(
            installer_loc,
            "mtm_group=test&mtm_source=test&gclid=test&PTAG=SYS1000043&hsimp=test&hspart=test2&typetag=tagtest&engine=yahoo",
        )

        # Install it silently
        ps_opts = [
            r"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe",
            "-ExecutionPolicy",
            "Unrestricted",
            self.working_dir
            + r"\browser\extensions\extensibles\test\functional\helpers\install_waterfox.ps1",
        ]
        result = subprocess.run(
            ps_opts, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, shell=True
        )

        assert result.returncode == 0

        # Set up the web driver
        binary = FirefoxBinary(r"C:\Program Files\Waterfox\waterfox.exe")
        options = Options()
        firefox_profile = FirefoxProfile()
        firefox_profile.set_preference("browser.aboutConfig.showWarning", False)
        options.profile = firefox_profile
        self.driver = webdriver.Firefox(firefox_binary=binary, options=options)

    def test_windows_attribution(self):
        # Launch the browser
        self.driver.get("about:config")

        # Verify that attribution data has been pulled through
        source = self.driver.execute_script(get_preference(), "distribution.source")
        self.assertEqual(source, "test")
        cohort = self.driver.execute_script(get_preference(), "distribution.cohort")
        self.assertEqual(cohort, datetime.today().strftime("%d%m%y"))

    def tearDown(self):
        # Remove installer
        os.remove("waterfox.exe")

        # Quit the web driver
        self.driver.quit()

        # Uninstall
        ps_opts = [
            r"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe",
            "-ExecutionPolicy",
            "Unrestricted",
            self.working_dir
            + r"\browser\extensions\extensibles\test\functional\helpers\uninstall_waterfox.ps1",
        ]
        result = subprocess.run(
            ps_opts, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, shell=True
        )

        assert result.returncode == 0


if __name__ == "__main__":
    if len(sys.argv) < 3 and not os.path.isdir(sys.argv[1]):
        print(
            "Two arguments must be present, a working directory and Waterfox version."
        )
        sys.exit()

    TestWindowsAttribution.version = sys.argv.pop()
    TestWindowsAttribution.working_dir = sys.argv.pop()
    unittest.main()
