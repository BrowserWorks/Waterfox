/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

XPCOMUtils.defineLazyModuleGetters(this, {
  AboutNewTab: "resource:///modules/AboutNewTab.jsm",
  NewTabUtils: "resource://gre/modules/NewTabUtils.jsm",
  PlacesSearchAutocompleteProvider:
    "resource://gre/modules/PlacesSearchAutocompleteProvider.jsm",
});

const EN_US_TOPSITES =
  "https://www.youtube.com/,https://www.facebook.com/,https://www.amazon.com/,https://www.reddit.com/,https://www.wikipedia.org/,https://twitter.com/";

async function addTestVisits() {
  // Add some visits to a URL.
  for (let i = 0; i < 5; i++) {
    await PlacesTestUtils.addVisits("http://example.com/");
  }

  // Wait for example.com to be listed first.
  await updateTopSites(sites => {
    return sites && sites[0] && sites[0].url == "http://example.com/";
  });

  await PlacesUtils.bookmarks.insert({
    parentGuid: PlacesUtils.bookmarks.unfiledGuid,
    url: "https://www.youtube.com/",
    title: "YouTube",
  });
}

async function checkDoesNotOpenOnFocus(win = window) {
  // The view should not open when the input is focused programmatically.
  win.gURLBar.blur();
  win.gURLBar.focus();
  Assert.ok(!win.gURLBar.view.isOpen, "check urlbar panel is not open");
  win.gURLBar.blur();

  // Check the keyboard shortcut.
  win.document.getElementById("Browser:OpenLocation").doCommand();
  // Because the panel opening may not be immediate, we must wait a bit.
  // eslint-disable-next-line mozilla/no-arbitrary-setTimeout
  await new Promise(resolve => setTimeout(resolve, 500));
  Assert.ok(!win.gURLBar.view.isOpen, "check urlbar panel is not open");
  win.gURLBar.blur();

  // Focus with the mouse.
  EventUtils.synthesizeMouseAtCenter(win.gURLBar.inputField, {});
  // Because the panel opening may not be immediate, we must wait a bit.
  // eslint-disable-next-line mozilla/no-arbitrary-setTimeout
  await new Promise(resolve => setTimeout(resolve, 500));
  Assert.ok(!win.gURLBar.view.isOpen, "check urlbar panel is not open");
  win.gURLBar.blur();
}

add_task(async function init() {
  await SpecialPowers.pushPrefEnv({
    set: [
      ["browser.urlbar.suggest.topsites", true],
      ["browser.newtabpage.activity-stream.default.sites", EN_US_TOPSITES],
    ],
  });

  await updateTopSites(
    sites => sites && sites.length == EN_US_TOPSITES.split(",").length
  );

  let tab = await BrowserTestUtils.openNewForegroundTab(
    gBrowser,
    "http://example.com/"
  );

  registerCleanupFunction(() => {
    BrowserTestUtils.removeTab(tab);
  });
});

add_task(async function topSitesShown() {
  let sites = AboutNewTab.getTopSites();

  for (let prefVal of [true, false]) {
    // This test should work regardless of whether Top Sites are enabled on
    // about:newtab.
    await SpecialPowers.pushPrefEnv({
      set: [["browser.newtabpage.activity-stream.feeds.topsites", prefVal]],
    });
    // We don't expect this to change, but we run updateTopSites just in case
    // feeds.topsites were to have an effect on the composition of Top Sites.
    await updateTopSites(siteList => siteList.length == 6);

    await UrlbarTestUtils.promisePopupOpen(window, () => {
      if (gURLBar.getAttribute("pageproxystate") == "invalid") {
        gURLBar.handleRevert();
      }
      EventUtils.synthesizeMouseAtCenter(window.gURLBar.inputField, {});
    });
    Assert.ok(window.gURLBar.view.isOpen, "UrlbarView should be open.");
    await UrlbarTestUtils.promiseSearchComplete(window);
    Assert.equal(
      UrlbarTestUtils.getResultCount(window),
      sites.length,
      "The number of results should be the same as the number of Top Sites (6)."
    );

    for (let i = 0; i < sites.length; i++) {
      let site = sites[i];
      let result = await UrlbarTestUtils.getDetailsOfResultAt(window, i);
      if (site.searchTopSite) {
        Assert.equal(
          result.searchParams.keyword,
          site.label,
          "The search Top Site should have an alias."
        );
        continue;
      }

      Assert.equal(
        site.url,
        result.url,
        "The Top Site URL and the result URL shoud match."
      );
      Assert.equal(
        site.label || site.title || site.hostname,
        result.title,
        "The Top Site title and the result title shoud match."
      );
    }
    await UrlbarTestUtils.promisePopupClose(window, () => {
      window.gURLBar.blur();
    });
    await SpecialPowers.popPrefEnv();
  }
});

add_task(async function selectSearchTopSite() {
  await updateTopSites(
    sites => sites && sites[0] && sites[0].searchTopSite,
    true
  );
  await UrlbarTestUtils.promisePopupOpen(window, () => {
    if (gURLBar.getAttribute("pageproxystate") == "invalid") {
      gURLBar.handleRevert();
    }
    EventUtils.synthesizeMouseAtCenter(window.gURLBar.inputField, {});
  });
  await UrlbarTestUtils.promiseSearchComplete(window);

  let amazonSearch = await UrlbarTestUtils.waitForAutocompleteResultAt(
    window,
    0
  );

  Assert.equal(
    amazonSearch.result.type,
    UrlbarUtils.RESULT_TYPE.SEARCH,
    "First result should have SEARCH type."
  );

  Assert.equal(
    amazonSearch.result.payload.keyword,
    "@amazon",
    "First result should have the Amazon keyword."
  );

  EventUtils.synthesizeMouseAtCenter(amazonSearch, {});

  Assert.equal(
    gURLBar.value,
    "@amazon ",
    "The Urlbar should be populated with the search alias."
  );
  await UrlbarTestUtils.promisePopupClose(window, () => {
    window.gURLBar.blur();
  });
});

add_task(async function topSitesBookmarksAndTabs() {
  await addTestVisits();
  let sites = AboutNewTab.getTopSites();
  Assert.equal(
    sites.length,
    7,
    "The test suite browser should have 7 Top Sites."
  );

  await UrlbarTestUtils.promisePopupOpen(window, () => {
    if (gURLBar.getAttribute("pageproxystate") == "invalid") {
      gURLBar.handleRevert();
    }
    EventUtils.synthesizeMouseAtCenter(window.gURLBar.inputField, {});
  });
  Assert.ok(window.gURLBar.view.isOpen, "UrlbarView should be open.");
  await UrlbarTestUtils.promiseSearchComplete(window);

  Assert.equal(
    UrlbarTestUtils.getResultCount(window),
    7,
    "The number of results should be the same as the number of Top Sites (7)."
  );

  let exampleResult = await UrlbarTestUtils.getDetailsOfResultAt(window, 0);
  Assert.equal(
    exampleResult.url,
    "http://example.com/",
    "The example.com Top Site should be the first result."
  );
  Assert.equal(
    exampleResult.source,
    UrlbarUtils.RESULT_SOURCE.TABS,
    "The example.com Top Site should appear in the view as an open tab result."
  );

  let youtubeResult = await UrlbarTestUtils.getDetailsOfResultAt(window, 1);
  Assert.equal(
    youtubeResult.url,
    "https://www.youtube.com/",
    "The YouTube Top Site should be the second result."
  );
  Assert.equal(
    youtubeResult.source,
    UrlbarUtils.RESULT_SOURCE.BOOKMARKS,
    "The YouTube Top Site should appear in the view as a bookmark result."
  );
  await UrlbarTestUtils.promisePopupClose(window, () => {
    window.gURLBar.blur();
  });

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesUtils.history.clear();
});

add_task(async function topSitesKeywordNavigationPageproxystate() {
  await addTestVisits();
  Assert.equal(
    gURLBar.getAttribute("pageproxystate"),
    "valid",
    "Sanity check initial state"
  );

  await UrlbarTestUtils.promisePopupOpen(window, () => {
    if (gURLBar.getAttribute("pageproxystate") == "invalid") {
      gURLBar.handleRevert();
    }
    EventUtils.synthesizeMouseAtCenter(window.gURLBar.inputField, {});
  });
  Assert.ok(window.gURLBar.view.isOpen, "UrlbarView should be open.");
  await UrlbarTestUtils.promiseSearchComplete(window);

  let count = UrlbarTestUtils.getResultCount(window);
  Assert.equal(count, 7, "The number of results should be the expected one.");

  for (let i = 0; i < count; ++i) {
    EventUtils.synthesizeKey("KEY_ArrowDown");
    Assert.equal(
      gURLBar.getAttribute("pageproxystate"),
      "invalid",
      "Moving through results"
    );
  }
  for (let i = 0; i < count; ++i) {
    EventUtils.synthesizeKey("KEY_ArrowUp");
    Assert.equal(
      gURLBar.getAttribute("pageproxystate"),
      "invalid",
      "Moving through results"
    );
  }

  // Double ESC should restore state.
  await UrlbarTestUtils.promisePopupClose(window, () => {
    EventUtils.synthesizeKey("KEY_Escape");
  });
  EventUtils.synthesizeKey("KEY_Escape");
  Assert.equal(
    gURLBar.getAttribute("pageproxystate"),
    "valid",
    "Double ESC should restore state"
  );
  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesUtils.history.clear();
});

add_task(async function topSitesPinned() {
  await addTestVisits();
  let info = { url: "http://example.com/" };
  NewTabUtils.pinnedLinks.pin(info, 0);

  await updateTopSites(sites => sites && sites[0] && sites[0].isPinned);

  let sites = AboutNewTab.getTopSites();
  Assert.equal(
    sites.length,
    7,
    "The test suite browser should have 7 Top Sites."
  );

  await UrlbarTestUtils.promisePopupOpen(window, () => {
    EventUtils.synthesizeMouseAtCenter(window.gURLBar.inputField, {});
  });
  Assert.ok(window.gURLBar.view.isOpen, "UrlbarView should be open.");
  await UrlbarTestUtils.promiseSearchComplete(window);

  Assert.equal(
    UrlbarTestUtils.getResultCount(window),
    7,
    "The number of results should be the same as the number of Top Sites (7)."
  );

  let exampleResult = await UrlbarTestUtils.getDetailsOfResultAt(window, 0);
  Assert.equal(
    exampleResult.url,
    "http://example.com/",
    "The example.com Top Site should be the first result."
  );

  Assert.equal(
    exampleResult.source,
    UrlbarUtils.RESULT_SOURCE.TABS,
    "The example.com Top Site should be an open tab result."
  );

  Assert.ok(
    exampleResult.element.row.hasAttribute("pinned"),
    "The example.com Top Site should have the pinned property."
  );

  await UrlbarTestUtils.promisePopupClose(window, () => {
    window.gURLBar.blur();
  });
  NewTabUtils.pinnedLinks.unpin(info);

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesUtils.history.clear();
});

add_task(async function topSitesBookmarksAndTabsDisabled() {
  await SpecialPowers.pushPrefEnv({
    set: [
      ["browser.urlbar.suggest.openpage", false],
      ["browser.urlbar.suggest.bookmark", false],
    ],
  });
  await addTestVisits();

  let sites = AboutNewTab.getTopSites();
  Assert.equal(
    sites.length,
    7,
    "The test suite browser should have 7 Top Sites."
  );

  await UrlbarTestUtils.promisePopupOpen(window, () => {
    if (gURLBar.getAttribute("pageproxystate") == "invalid") {
      gURLBar.handleRevert();
    }
    EventUtils.synthesizeMouseAtCenter(window.gURLBar.inputField, {});
  });
  Assert.ok(window.gURLBar.view.isOpen, "UrlbarView should be open.");
  await UrlbarTestUtils.promiseSearchComplete(window);

  Assert.equal(
    UrlbarTestUtils.getResultCount(window),
    7,
    "The number of results should be the same as the number of Top Sites (7)."
  );

  let exampleResult = await UrlbarTestUtils.getDetailsOfResultAt(window, 0);
  Assert.equal(
    exampleResult.url,
    "http://example.com/",
    "The example.com Top Site should be the second result."
  );
  Assert.equal(
    exampleResult.source,
    UrlbarUtils.RESULT_SOURCE.OTHER_LOCAL,
    "The example.com Top Site should appear as a normal result even though it's open in a tab."
  );

  let youtubeResult = await UrlbarTestUtils.getDetailsOfResultAt(window, 1);
  Assert.equal(
    youtubeResult.url,
    "https://www.youtube.com/",
    "The YouTube Top Site should be the third result."
  );
  Assert.equal(
    youtubeResult.source,
    UrlbarUtils.RESULT_SOURCE.OTHER_LOCAL,
    "The YouTube Top Site should appear as a normal result even though it's bookmarked."
  );
  await UrlbarTestUtils.promisePopupClose(window, () => {
    window.gURLBar.blur();
  });

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesUtils.history.clear();
  await SpecialPowers.popPrefEnv();
});

add_task(async function topSitesDisabled() {
  // Disable Top Sites feed.
  await SpecialPowers.pushPrefEnv({
    set: [["browser.newtabpage.activity-stream.feeds.system.topsites", false]],
  });
  await checkDoesNotOpenOnFocus();
  await SpecialPowers.popPrefEnv();

  // Top Sites should also not be shown when Urlbar Top Sites are disabled.
  await SpecialPowers.pushPrefEnv({
    set: [["browser.urlbar.suggest.topsites", false]],
  });
  await checkDoesNotOpenOnFocus();
  await SpecialPowers.popPrefEnv();

  // Top Sites should not be shown in private windows.
  let privateWin = await BrowserTestUtils.openNewBrowserWindow({
    private: true,
  });
  await checkDoesNotOpenOnFocus(privateWin);

  // Top sites should also not be shown in a private window if the search string
  // gets cleared.
  await UrlbarTestUtils.promiseAutocompleteResultPopup({
    window: privateWin,
    waitForFocus,
    value: "example",
  });
  privateWin.gURLBar.select();
  EventUtils.synthesizeKey("KEY_Backspace", {}, privateWin);
  // Because the panel opening may not be immediate, we must wait a bit.
  // eslint-disable-next-line mozilla/no-arbitrary-setTimeout
  await new Promise(resolve => setTimeout(resolve, 500));
  Assert.ok(!privateWin.gURLBar.view.isOpen, "check urlbar panel is not open");

  await BrowserTestUtils.closeWindow(privateWin);

  await PlacesUtils.bookmarks.eraseEverything();
  await PlacesUtils.history.clear();
});
