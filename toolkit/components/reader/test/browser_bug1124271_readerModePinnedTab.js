/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

// Test that the reader mode button won't open in a new tab when clicked from a pinned tab

const PREF = "reader.parse-on-load.enabled";

const TEST_PATH = getRootDirectory(gTestPath).replace("chrome://mochitests/content", "http://example.com");

var readerButton = document.getElementById("reader-mode-button");

add_task(function* () {
  registerCleanupFunction(function() {
    Services.prefs.clearUserPref(PREF);
    while (gBrowser.tabs.length > 1) {
      gBrowser.removeCurrentTab();
    }
  });

  // Enable the reader mode button.
  Services.prefs.setBoolPref(PREF, true);

  let tab = gBrowser.selectedTab = gBrowser.addTab();
  gBrowser.pinTab(tab);

  let initialTabsCount = gBrowser.tabs.length;

  // Point tab to a test page that is reader-able.
  let url = TEST_PATH + "readerModeArticle.html";
  yield promiseTabLoadEvent(tab, url);
  yield promiseWaitForCondition(() => !readerButton.hidden);

  readerButton.click();
  yield promiseTabLoadEvent(tab);

  // Ensure no new tabs are opened when exiting reader mode in a pinned tab
  is(gBrowser.tabs.length, initialTabsCount, "No additional tabs were opened.");

  let pageShownPromise = BrowserTestUtils.waitForContentEvent(tab.linkedBrowser, "pageshow");
  readerButton.click();
  yield pageShownPromise;
  // Ensure no new tabs are opened when exiting reader mode in a pinned tab
  is(gBrowser.tabs.length, initialTabsCount, "No additional tabs were opened.");

  gBrowser.removeCurrentTab();
});
