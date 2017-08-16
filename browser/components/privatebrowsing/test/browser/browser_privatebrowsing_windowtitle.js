/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

// This test makes sure that the window title changes correctly while switching
// from and to private browsing mode.

add_task(async function test() {
  const testPageURL = "http://mochi.test:8888/browser/" +
    "browser/components/privatebrowsing/test/browser/browser_privatebrowsing_windowtitle_page.html";
  requestLongerTimeout(2);

  // initialization of expected titles
  let test_title = "Test title";
  let app_name = document.documentElement.getAttribute("title");
  const isOSX = ("nsILocalFileMac" in Ci);
  let page_with_title;
  let page_without_title;
  let about_pb_title;
  let pb_page_with_title;
  let pb_page_without_title;
  let pb_about_pb_title;
  if (isOSX) {
    page_with_title = test_title;
    page_without_title = app_name;
    about_pb_title = "Open a private window?";
    pb_page_with_title = test_title + " - (Private Browsing)";
    pb_page_without_title = app_name + " - (Private Browsing)";
    pb_about_pb_title = "Private Browsing - (Private Browsing)";
  } else {
    page_with_title = test_title + " - " + app_name;
    page_without_title = app_name;
    about_pb_title = "Open a private window? - " + app_name;
    pb_page_with_title = test_title + " - " + app_name + " (Private Browsing)";
    pb_page_without_title = app_name + " (Private Browsing)";
    pb_about_pb_title = "Private Browsing - " + app_name + " (Private Browsing)";
  }

  async function testTabTitle(aWindow, url, insidePB, expected_title) {
    let tab = (await BrowserTestUtils.openNewForegroundTab(aWindow.gBrowser));
    await BrowserTestUtils.loadURI(tab.linkedBrowser, url);
    await BrowserTestUtils.browserLoaded(tab.linkedBrowser);

    await BrowserTestUtils.waitForCondition(() => {
      return aWindow.document.title === expected_title;
    }, `Window title should be ${expected_title}, got ${aWindow.document.title}`);

    is(aWindow.document.title, expected_title, "The window title for " + url +
       " is correct (" + (insidePB ? "inside" : "outside") +
       " private browsing mode)");

    let win = aWindow.gBrowser.replaceTabWithWindow(tab);
    await BrowserTestUtils.waitForEvent(win, "load", false);

    await BrowserTestUtils.waitForCondition(() => {
      return win.document.title === expected_title;
    }, `Window title should be ${expected_title}, got ${aWindow.document.title}`);

    is(win.document.title, expected_title, "The window title for " + url +
       " detached tab is correct (" + (insidePB ? "inside" : "outside") +
       " private browsing mode)");

    await Promise.all([ BrowserTestUtils.closeWindow(win),
                        BrowserTestUtils.closeWindow(aWindow) ]);
  }

  function openWin(private) {
    return BrowserTestUtils.openNewBrowserWindow({ private });
  }
  await testTabTitle((await openWin(false)), "about:blank", false, page_without_title);
  await testTabTitle((await openWin(false)), testPageURL, false, page_with_title);
  await testTabTitle((await openWin(false)), "about:privatebrowsing", false, about_pb_title);
  await testTabTitle((await openWin(true)), "about:blank", true, pb_page_without_title);
  await testTabTitle((await openWin(true)), testPageURL, true, pb_page_with_title);
  await testTabTitle((await openWin(true)), "about:privatebrowsing", true, pb_about_pb_title);
});
