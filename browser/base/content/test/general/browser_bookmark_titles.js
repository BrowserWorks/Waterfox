/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

// This file is tests for the default titles that new bookmarks get.

var tests = [
  // Common page.
  ["http://example.com/browser/browser/base/content/test/general/dummy_page.html",
   "Dummy test page"],
  // Data URI.
  ["data:text/html;charset=utf-8,<title>test%20data:%20url</title>",
   "test data: url"],
  // about:neterror
  ["data:application/vnd.mozilla.xul+xml,",
   "data:application/vnd.mozilla.xul+xml,"],
  // about:certerror
  ["https://untrusted.example.com/somepage.html",
   "https://untrusted.example.com/somepage.html"]
];

add_task(async function() {
  let tab = await BrowserTestUtils.openNewForegroundTab(gBrowser);
  let browser = tab.linkedBrowser;

  // Test that a bookmark of each URI gets the corresponding default title.
  for (let i = 0; i < tests.length; ++i) {
    let [url, title] = tests[i];

    // We use promisePageLoaded rather than BrowserTestUtils.browserLoaded - see
    // note on function definition below.
    let promiseLoaded = promisePageLoaded(browser);
    BrowserTestUtils.loadURI(browser, url);
    await promiseLoaded;

    await checkBookmark(url, title);
  }

  // Network failure test: now that dummy_page.html is in history, bookmarking
  // it should give the last known page title as the default bookmark title.

  // Simulate a network outage with offline mode. (Localhost is still
  // accessible in offline mode, so disable the test proxy as well.)
  BrowserOffline.toggleOfflineStatus();
  let proxy = Services.prefs.getIntPref("network.proxy.type");
  Services.prefs.setIntPref("network.proxy.type", 0);
  registerCleanupFunction(function() {
    BrowserOffline.toggleOfflineStatus();
    Services.prefs.setIntPref("network.proxy.type", proxy);
  });

  // LOAD_FLAGS_BYPASS_CACHE isn't good enough. So clear the cache.
  Services.cache2.clear();

  let [url, title] = tests[0];

  // We use promisePageLoaded rather than BrowserTestUtils.browserLoaded - see
  // note on function definition below.
  let promiseLoaded = promisePageLoaded(browser);
  BrowserTestUtils.loadURI(browser, url);
  await promiseLoaded;

  // The offline mode test is only good if the page failed to load.
  await ContentTask.spawn(browser, null, function() {
    Assert.equal(content.document.documentURI.substring(0, 14), "about:neterror",
      "Offline mode successfully simulated network outage.");
  });
  await checkBookmark(url, title);

  await BrowserTestUtils.removeTab(tab);
});

// Bookmark the current page and confirm that the new bookmark has the expected
// title. (Then delete the bookmark.)
async function checkBookmark(url, expected_title) {
  Assert.equal(gBrowser.selectedBrowser.currentURI.spec, url,
    "Trying to bookmark the expected uri");

  let promiseBookmark = PlacesTestUtils.waitForNotification("onItemAdded",
    (id, parentId, index, type, itemUrl) => itemUrl.equals(gBrowser.selectedBrowser.currentURI));
  PlacesCommandHook.bookmarkCurrentPage(false);
  await promiseBookmark;

  let bookmark = await PlacesUtils.bookmarks.fetch({url});

  Assert.ok(bookmark, "Found the expected bookmark");
  Assert.equal(bookmark.title, expected_title, "Bookmark got a good default title.");

  await PlacesUtils.bookmarks.remove(bookmark);
}

// BrowserTestUtils.browserLoaded doesn't work for the about pages, so use a
// custom page load listener.
function promisePageLoaded(browser) {
  return ContentTask.spawn(browser, null, async function() {
    await ContentTaskUtils.waitForEvent(this, "DOMContentLoaded", true,
      (event) => {
        return event.originalTarget === content.document &&
               event.target.location.href !== "about:blank"
      });
  });
}
