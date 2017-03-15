/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

const TEST_URL = "http://mochi.test:8888/browser/browser/base/content/test/general/file_favicon_change.html"

add_task(function*() {
  let extraTab = gBrowser.selectedTab = gBrowser.addTab();
  extraTab.linkedBrowser.loadURI(TEST_URL);
  let tabLoaded = BrowserTestUtils.browserLoaded(extraTab.linkedBrowser);
  let expectedFavicon = "http://example.org/one-icon";
  let haveChanged = new Promise.defer();
  let observer = new MutationObserver(function(mutations) {
    for (let mut of mutations) {
      if (mut.attributeName != "image") {
        continue;
      }
      let imageVal = extraTab.getAttribute("image").replace(/#.*$/, "");
      if (!imageVal) {
        // The value gets removed because it doesn't load.
        continue;
      }
      is(imageVal, expectedFavicon, "Favicon image should correspond to expected image.");
      haveChanged.resolve();
    }
  });
  observer.observe(extraTab, {attributes: true});
  yield tabLoaded;
  yield haveChanged.promise;
  haveChanged = new Promise.defer();
  expectedFavicon = "http://example.org/other-icon";
  ContentTask.spawn(extraTab.linkedBrowser, null, function() {
    let ev = new content.CustomEvent("PleaseChangeFavicon", {});
    content.dispatchEvent(ev);
  });
  yield haveChanged.promise;
  observer.disconnect();
  gBrowser.removeTab(extraTab);
});

