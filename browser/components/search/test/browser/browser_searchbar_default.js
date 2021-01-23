/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

/*
 * Tests the correct default engines in the search bar.
 */

"use strict";

const templateNormal = "https://example.com/?q=";
const templatePrivate = "https://example.com/?query=";

async function searchInSearchbar(win, inputText) {
  await new Promise(r => waitForFocus(r, win));
  let searchbar = win.BrowserSearch.searchBar;
  // Write the search query in the searchbar.
  searchbar.focus();
  searchbar.value = inputText;
  searchbar.textbox.controller.startSearch(inputText);
  // Wait for the popup to show.
  await BrowserTestUtils.waitForEvent(searchbar.textbox.popup, "popupshown");
  // And then for the search to complete.
  await BrowserTestUtils.waitForCondition(
    () =>
      searchbar.textbox.controller.searchStatus >=
      Ci.nsIAutoCompleteController.STATUS_COMPLETE_NO_MATCH,
    "The search in the searchbar must complete."
  );
}

add_task(async function setup() {
  await gCUITestUtils.addSearchBar();

  await SpecialPowers.pushPrefEnv({
    set: [["browser.search.separatePrivateDefault", false]],
  });

  // Create two new search engines. Mark one as the default engine, so
  // the test don't crash. We need to engines for this test as the searchbar
  // doesn't display the default search engine among the one-off engines.
  await Services.search.addEngineWithDetails("MozSearch1", {
    alias: "mozalias",
    method: "GET",
    template: templateNormal + "{searchTerms}",
  });

  await Services.search.addEngineWithDetails("MozSearch2", {
    alias: "mozalias2",
    method: "GET",
    template: templatePrivate + "{searchTerms}",
  });

  await SpecialPowers.pushPrefEnv({
    set: [
      ["browser.search.separatePrivateDefault.ui.enabled", true],
      ["browser.search.separatePrivateDefault", false],
    ],
  });

  let originalEngine = await Services.search.getDefault();
  let originalPrivateEngine = await Services.search.getDefaultPrivate();

  let engineDefault = Services.search.getEngineByName("MozSearch1");
  await Services.search.setDefault(engineDefault);

  let engineOneOff = Services.search.getEngineByName("MozSearch2");

  registerCleanupFunction(async function() {
    gCUITestUtils.removeSearchBar();
    await Services.search.setDefault(originalEngine);
    await Services.search.setDefaultPrivate(originalPrivateEngine);
    await Services.search.removeEngine(engineDefault);
    await Services.search.removeEngine(engineOneOff);
  });
});

async function doSearch(win, tab, engineName, expectedUrl) {
  await searchInSearchbar(win, "query");

  Assert.ok(
    win.BrowserSearch.searchBar.textbox.popup.searchbarEngineName
      .getAttribute("value")
      .includes(engineName),
    "Should have the correct engine name displayed in the bar"
  );

  let p = BrowserTestUtils.browserLoaded(tab.linkedBrowser);
  EventUtils.synthesizeKey("KEY_Enter", {}, win);
  await p;

  Assert.equal(
    tab.linkedBrowser.currentURI.spec,
    expectedUrl,
    "Should have loaded the expected search page."
  );
}

add_task(async function test_default_search() {
  const tab = await BrowserTestUtils.openNewForegroundTab(
    gBrowser,
    "about:blank"
  );

  await doSearch(window, tab, "MozSearch1", templateNormal + "query");

  BrowserTestUtils.removeTab(tab);
});

add_task(async function test_default_search_private_no_separate() {
  const win = await BrowserTestUtils.openNewBrowserWindow({ private: true });

  await doSearch(
    win,
    win.gBrowser.selectedTab,
    "MozSearch1",
    templateNormal + "query"
  );

  await BrowserTestUtils.closeWindow(win);
});

add_task(async function test_default_search_private_no_separate() {
  await SpecialPowers.pushPrefEnv({
    set: [["browser.search.separatePrivateDefault", true]],
  });

  await Services.search.setDefaultPrivate(
    Services.search.getEngineByName("MozSearch2")
  );

  const win = await BrowserTestUtils.openNewBrowserWindow({ private: true });

  await doSearch(
    win,
    win.gBrowser.selectedTab,
    "MozSearch2",
    templatePrivate + "query"
  );

  await BrowserTestUtils.closeWindow(win);
});
