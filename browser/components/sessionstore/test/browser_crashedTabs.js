/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

requestLongerTimeout(10);

const PAGE_1 = "data:text/html,<html><body>A%20regular,%20everyday,%20normal%20page.";
const PAGE_2 = "data:text/html,<html><body>Another%20regular,%20everyday,%20normal%20page.";

// Turn off tab animations for testing and use a single content process
// for these tests since we want to test tabs within the crashing process here.
add_task(function* test_initialize() {
  yield SpecialPowers.pushPrefEnv({
    set: [
      [ "dom.ipc.processCount", 1 ],
      [ "browser.tabs.animate", false]
  ] });
});

// Allow tabs to restore on demand so we can test pending states
Services.prefs.clearUserPref("browser.sessionstore.restore_on_demand");

function clickButton(browser, id) {
  info("Clicking " + id);

  let frame_script = (id) => {
    let button = content.document.getElementById(id);
    button.click();
  };

  let mm = browser.messageManager;
  mm.loadFrameScript("data:,(" + frame_script.toString() + ")('" + id + "');", false);
}

/**
 * Checks the documentURI of the root document of a remote browser
 * to see if it equals URI. Returns a Promise that resolves if
 * there is a match, and rejects with an error message if they
 * do not match.
 *
 * @param browser
 *        The remote <xul:browser> to check the root document URI in.
 * @param URI
 *        A string to match the root document URI against.
 * @return Promise
 */
function promiseContentDocumentURIEquals(browser, URI) {
  return new Promise((resolve, reject) => {
    let frame_script = () => {
      sendAsyncMessage("test:documenturi", {
        uri: content.document.documentURI,
      });
    };

    let mm = browser.messageManager;
    mm.addMessageListener("test:documenturi", function onMessage(message) {
      mm.removeMessageListener("test:documenturi", onMessage);
      let contentURI = message.data.uri;
      if (contentURI == URI) {
        resolve();
      } else {
        reject(`Content has URI ${contentURI} which does not match ${URI}`);
      }
    });

    mm.loadFrameScript("data:,(" + frame_script.toString() + ")();", false);
  });
}

/**
 * Checks the window.history.length of the root window of a remote
 * browser to see if it equals length. Returns a Promise that resolves
 * if there is a match, and rejects with an error message if they
 * do not match.
 *
 * @param browser
 *        The remote <xul:browser> to check the root window.history.length
 * @param length
 *        The expected history length
 * @return Promise
 */
function promiseHistoryLength(browser, length) {
  return new Promise((resolve, reject) => {
    let frame_script = () => {
      sendAsyncMessage("test:historylength", {
        length: content.history.length,
      });
    };

    let mm = browser.messageManager;
    mm.addMessageListener("test:historylength", function onMessage(message) {
      mm.removeMessageListener("test:historylength", onMessage);
      let contentLength = message.data.length;
      if (contentLength == length) {
        resolve();
      } else {
        reject(`Content has window.history.length ${contentLength} which does ` +
               `not equal expected ${length}`);
      }
    });

    mm.loadFrameScript("data:,(" + frame_script.toString() + ")();", false);
  });
}

/**
 * Returns a Promise that resolves when a browser has fired the
 * AboutTabCrashedReady event.
 *
 * @param browser
 *        The remote <xul:browser> that will fire the event.
 * @return Promise
 */
function promiseTabCrashedReady(browser) {
  return new Promise((resolve) => {
    browser.addEventListener("AboutTabCrashedReady", function ready(e) {
      browser.removeEventListener("AboutTabCrashedReady", ready, false, true);
      resolve();
    }, false, true);
  });
}

/**
 * Checks that if a tab crashes, that information about the tab crashed
 * page does not get added to the tab history.
 */
add_task(function test_crash_page_not_in_history() {
  let newTab = gBrowser.addTab();
  gBrowser.selectedTab = newTab;
  let browser = newTab.linkedBrowser;
  ok(browser.isRemoteBrowser, "Should be a remote browser");
  yield promiseBrowserLoaded(browser);

  browser.loadURI(PAGE_1);
  yield promiseBrowserLoaded(browser);
  yield TabStateFlusher.flush(browser);

  // Crash the tab
  yield BrowserTestUtils.crashBrowser(browser);

  // Check the tab state and make sure the tab crashed page isn't
  // mentioned.
  let {entries} = JSON.parse(ss.getTabState(newTab));
  is(entries.length, 1, "Should have a single history entry");
  is(entries[0].url, PAGE_1,
    "Single entry should be the page we visited before crashing");

  gBrowser.removeTab(newTab);
});

/**
 * Checks that if a tab crashes, that when we browse away from that page
 * to a non-blacklisted site (so the browser becomes remote again), that
 * we record history for that new visit.
 */
add_task(function test_revived_history_from_remote() {
  let newTab = gBrowser.addTab();
  gBrowser.selectedTab = newTab;
  let browser = newTab.linkedBrowser;
  ok(browser.isRemoteBrowser, "Should be a remote browser");
  yield promiseBrowserLoaded(browser);

  browser.loadURI(PAGE_1);
  yield promiseBrowserLoaded(browser);
  yield TabStateFlusher.flush(browser);

  // Crash the tab
  yield BrowserTestUtils.crashBrowser(browser);

  // Browse to a new site that will cause the browser to
  // become remote again.
  browser.loadURI(PAGE_2);
  yield promiseTabRestored(newTab);
  ok(!newTab.hasAttribute("crashed"), "Tab shouldn't be marked as crashed anymore.");
  ok(browser.isRemoteBrowser, "Should be a remote browser");
  yield TabStateFlusher.flush(browser);

  // Check the tab state and make sure the tab crashed page isn't
  // mentioned.
  let {entries} = JSON.parse(ss.getTabState(newTab));
  is(entries.length, 2, "Should have two history entries");
  is(entries[0].url, PAGE_1,
    "First entry should be the page we visited before crashing");
  is(entries[1].url, PAGE_2,
    "Second entry should be the page we visited after crashing");

  gBrowser.removeTab(newTab);
});

/**
 * Checks that if a tab crashes, that when we browse away from that page
 * to a blacklisted site (so the browser stays non-remote), that
 * we record history for that new visit.
 */
add_task(function test_revived_history_from_non_remote() {
  let newTab = gBrowser.addTab();
  gBrowser.selectedTab = newTab;
  let browser = newTab.linkedBrowser;
  ok(browser.isRemoteBrowser, "Should be a remote browser");
  yield promiseBrowserLoaded(browser);

  browser.loadURI(PAGE_1);
  yield promiseBrowserLoaded(browser);
  yield TabStateFlusher.flush(browser);

  // Crash the tab
  yield BrowserTestUtils.crashBrowser(browser);

  // Browse to a new site that will not cause the browser to
  // become remote again.
  browser.loadURI("about:mozilla");
  yield promiseBrowserLoaded(browser);
  ok(!newTab.hasAttribute("crashed"), "Tab shouldn't be marked as crashed anymore.");
  ok(!browser.isRemoteBrowser, "Should not be a remote browser");
  yield TabStateFlusher.flush(browser);

  // Check the tab state and make sure the tab crashed page isn't
  // mentioned.
  let {entries} = JSON.parse(ss.getTabState(newTab));
  is(entries.length, 2, "Should have two history entries");
  is(entries[0].url, PAGE_1,
    "First entry should be the page we visited before crashing");
  is(entries[1].url, "about:mozilla",
    "Second entry should be the page we visited after crashing");

  gBrowser.removeTab(newTab);
});

/**
 * Checks that we can revive a crashed tab back to the page that
 * it was on when it crashed.
 */
add_task(function test_revive_tab_from_session_store() {
  let newTab = gBrowser.addTab();
  gBrowser.selectedTab = newTab;
  let browser = newTab.linkedBrowser;
  ok(browser.isRemoteBrowser, "Should be a remote browser");
  yield promiseBrowserLoaded(browser);

  browser.loadURI(PAGE_1);
  yield promiseBrowserLoaded(browser);

  let newTab2 = gBrowser.addTab();
  let browser2 = newTab2.linkedBrowser;
  ok(browser2.isRemoteBrowser, "Should be a remote browser");
  yield promiseBrowserLoaded(browser2);

  browser.loadURI(PAGE_1);
  yield promiseBrowserLoaded(browser);

  browser.loadURI(PAGE_2);
  yield promiseBrowserLoaded(browser);

  yield TabStateFlusher.flush(browser);

  // Crash the tab
  yield BrowserTestUtils.crashBrowser(browser);
  // Background tabs should not be crashed, but should be in the "to be restored"
  // state.
  ok(!newTab2.hasAttribute("crashed"), "Second tab should not be crashed.");
  ok(newTab2.hasAttribute("pending"), "Second tab should be pending.");

  // Use SessionStore to revive the first tab
  clickButton(browser, "restoreTab");
  yield promiseTabRestored(newTab);
  ok(!newTab.hasAttribute("crashed"), "Tab shouldn't be marked as crashed anymore.");
  ok(newTab2.hasAttribute("pending"), "Second tab should still be pending.");

  // We can't just check browser.currentURI.spec, because from
  // the outside, a crashed tab has the same URI as the page
  // it crashed on (much like an about:neterror page). Instead,
  // we have to use the documentURI on the content.
  yield promiseContentDocumentURIEquals(browser, PAGE_2);

  // We should also have two entries in the browser history.
  yield promiseHistoryLength(browser, 2);

  gBrowser.removeTab(newTab);
  gBrowser.removeTab(newTab2);
});

/**
 * Checks that we can revive multiple crashed tabs back to the pages
 * that they were on when they crashed.
 */
add_task(function test_revive_all_tabs_from_session_store() {
  let newTab = gBrowser.addTab();
  gBrowser.selectedTab = newTab;
  let browser = newTab.linkedBrowser;
  ok(browser.isRemoteBrowser, "Should be a remote browser");
  yield promiseBrowserLoaded(browser);

  browser.loadURI(PAGE_1);
  yield promiseBrowserLoaded(browser);

  // In order to see a second about:tabcrashed page, we'll need
  // a second window, since only selected tabs will show
  // about:tabcrashed.
  let win2 = yield BrowserTestUtils.openNewBrowserWindow();
  let newTab2 = win2.gBrowser.addTab(PAGE_1);
  win2.gBrowser.selectedTab = newTab2;
  let browser2 = newTab2.linkedBrowser;
  ok(browser2.isRemoteBrowser, "Should be a remote browser");
  yield promiseBrowserLoaded(browser2);

  browser.loadURI(PAGE_1);
  yield promiseBrowserLoaded(browser);

  browser.loadURI(PAGE_2);
  yield promiseBrowserLoaded(browser);

  yield TabStateFlusher.flush(browser);
  yield TabStateFlusher.flush(browser2);

  // Crash the tab
  yield BrowserTestUtils.crashBrowser(browser);
  // Both tabs should now be crashed.
  is(newTab.getAttribute("crashed"), "true", "First tab should be crashed");
  is(newTab2.getAttribute("crashed"), "true", "Second window tab should be crashed");

  // Use SessionStore to revive all the tabs
  clickButton(browser, "restoreAll");
  yield promiseTabRestored(newTab);
  ok(!newTab.hasAttribute("crashed"), "Tab shouldn't be marked as crashed anymore.");
  ok(!newTab.hasAttribute("pending"), "Tab shouldn't be pending.");
  ok(!newTab2.hasAttribute("crashed"), "Second tab shouldn't be marked as crashed anymore.");
  ok(!newTab2.hasAttribute("pending"), "Second tab shouldn't be pending.");

  // We can't just check browser.currentURI.spec, because from
  // the outside, a crashed tab has the same URI as the page
  // it crashed on (much like an about:neterror page). Instead,
  // we have to use the documentURI on the content.
  yield promiseContentDocumentURIEquals(browser, PAGE_2);
  yield promiseContentDocumentURIEquals(browser2, PAGE_1);

  // We should also have two entries in the browser history.
  yield promiseHistoryLength(browser, 2);

  yield BrowserTestUtils.closeWindow(win2);
  gBrowser.removeTab(newTab);
});

/**
 * Checks that about:tabcrashed can close the current tab
 */
add_task(function test_close_tab_after_crash() {
  let newTab = gBrowser.addTab();
  gBrowser.selectedTab = newTab;
  let browser = newTab.linkedBrowser;
  ok(browser.isRemoteBrowser, "Should be a remote browser");
  yield promiseBrowserLoaded(browser);

  browser.loadURI(PAGE_1);
  yield promiseBrowserLoaded(browser);

  yield TabStateFlusher.flush(browser);

  // Crash the tab
  yield BrowserTestUtils.crashBrowser(browser);

  let promise = promiseEvent(gBrowser.tabContainer, "TabClose");

  // Click the close tab button
  clickButton(browser, "closeTab");
  yield promise;

  is(gBrowser.tabs.length, 1, "Should have closed the tab");
});


/**
 * Checks that "restore all" button is only shown if more than one tab
 * is showing about:tabcrashed
 */
add_task(function* test_hide_restore_all_button() {
  let newTab = gBrowser.addTab();
  gBrowser.selectedTab = newTab;
  let browser = newTab.linkedBrowser;
  ok(browser.isRemoteBrowser, "Should be a remote browser");
  yield promiseBrowserLoaded(browser);

  browser.loadURI(PAGE_1);
  yield promiseBrowserLoaded(browser);

  yield TabStateFlusher.flush(browser);

  // Crash the tab
  yield BrowserTestUtils.crashBrowser(browser);

  let doc = browser.contentDocument;
  let restoreAllButton = doc.getElementById("restoreAll");
  let restoreOneButton = doc.getElementById("restoreTab");

  let restoreAllStyles = window.getComputedStyle(restoreAllButton);
  is(restoreAllStyles.display, "none", "Restore All button should be hidden");
  ok(restoreOneButton.classList.contains("primary"), "Restore Tab button should have the primary class");

  let newTab2 = gBrowser.addTab();
  gBrowser.selectedTab = newTab;

  browser.loadURI(PAGE_2);
  yield promiseBrowserLoaded(browser);

  // Load up a second window so we can get another tab to show
  // about:tabcrashed
  let win2 = yield BrowserTestUtils.openNewBrowserWindow();
  let newTab3 = win2.gBrowser.addTab(PAGE_2);
  win2.gBrowser.selectedTab = newTab3;
  let otherWinBrowser = newTab3.linkedBrowser;
  yield promiseBrowserLoaded(otherWinBrowser);
  // We'll need to make sure the second tab's browser has finished
  // sending its AboutTabCrashedReady event before we know for
  // sure whether or not we're showing the right Restore buttons.
  let otherBrowserReady = promiseTabCrashedReady(otherWinBrowser);

  // Crash the first tab.
  yield BrowserTestUtils.crashBrowser(browser);
  yield otherBrowserReady;

  doc = browser.contentDocument;
  restoreAllButton = doc.getElementById("restoreAll");
  restoreOneButton = doc.getElementById("restoreTab");

  restoreAllStyles = window.getComputedStyle(restoreAllButton);
  isnot(restoreAllStyles.display, "none", "Restore All button should not be hidden");
  ok(!(restoreOneButton.classList.contains("primary")), "Restore Tab button should not have the primary class");

  yield BrowserTestUtils.closeWindow(win2);
  gBrowser.removeTab(newTab);
  gBrowser.removeTab(newTab2);
});

add_task(function* test_aboutcrashedtabzoom() {
  let newTab = gBrowser.addTab();
  gBrowser.selectedTab = newTab;
  let browser = newTab.linkedBrowser;
  ok(browser.isRemoteBrowser, "Should be a remote browser");
  yield promiseBrowserLoaded(browser);

  browser.loadURI(PAGE_1);
  yield promiseBrowserLoaded(browser);

  FullZoom.enlarge();
  let zoomLevel = ZoomManager.getZoomForBrowser(browser);
  ok(zoomLevel !== 1, "should have enlarged");

  yield TabStateFlusher.flush(browser);

  // Crash the tab
  yield BrowserTestUtils.crashBrowser(browser);

  ok(ZoomManager.getZoomForBrowser(browser) === 1, "zoom should have reset on crash");

  clickButton(browser, "restoreTab");
  yield promiseTabRestored(newTab);

  ok(ZoomManager.getZoomForBrowser(browser) === zoomLevel, "zoom should have gone back to enlarged");
  FullZoom.reset();

  gBrowser.removeTab(newTab);
});
