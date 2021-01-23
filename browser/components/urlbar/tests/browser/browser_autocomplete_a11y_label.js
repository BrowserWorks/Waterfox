/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

/**
 * This test ensures that we produce good labels for a11y purposes.
 */

const SUGGEST_ALL_PREF = "browser.search.suggest.enabled";
const SUGGEST_URLBAR_PREF = "browser.urlbar.suggest.searches";
const TEST_ENGINE_BASENAME = "searchSuggestionEngine.xml";

async function getResultText(element) {
  await initAccessibilityService();
  await BrowserTestUtils.waitForCondition(() =>
    accService.getAccessibleFor(element)
  );
  let accessible = accService.getAccessibleFor(element);
  return accessible.name;
}

let accService;
async function initAccessibilityService() {
  if (accService) {
    return;
  }
  accService = Cc["@mozilla.org/accessibilityService;1"].getService(
    Ci.nsIAccessibilityService
  );
  if (Services.appinfo.accessibilityEnabled) {
    return;
  }

  async function promiseInitOrShutdown(init = true) {
    await new Promise(resolve => {
      let observe = (subject, topic, data) => {
        Services.obs.removeObserver(observe, "a11y-init-or-shutdown");
        // "1" indicates that the accessibility service is initialized.
        if (data === (init ? "1" : "0")) {
          resolve();
        }
      };
      Services.obs.addObserver(observe, "a11y-init-or-shutdown");
    });
  }
  await promiseInitOrShutdown(true);
  registerCleanupFunction(async () => {
    accService = null;
    await promiseInitOrShutdown(false);
  });
}

add_task(async function switchToTab() {
  let tab = BrowserTestUtils.addTab(gBrowser, "about:robots");

  await UrlbarTestUtils.promiseAutocompleteResultPopup({
    window,
    waitForFocus: SimpleTest.waitForFocus,
    value: "% robots",
  });
  let result = await UrlbarTestUtils.getDetailsOfResultAt(window, 1);
  Assert.equal(
    result.type,
    UrlbarUtils.RESULT_TYPE.TAB_SWITCH,
    "Should have a switch tab result"
  );

  let element = await UrlbarTestUtils.waitForAutocompleteResultAt(window, 1);
  is(
    await getResultText(element),
    "about: robots— Switch to Tab",
    "Result a11y label should be: <title>— Switch to Tab"
  );

  await UrlbarTestUtils.promisePopupClose(window);
  gBrowser.removeTab(tab);
});

add_task(async function searchSuggestions() {
  let engine = await SearchTestUtils.promiseNewSearchEngine(
    getRootDirectory(gTestPath) + TEST_ENGINE_BASENAME
  );
  let oldDefaultEngine = await Services.search.getDefault();
  await Services.search.setDefault(engine);
  Services.prefs.setBoolPref(SUGGEST_ALL_PREF, true);
  let suggestionsEnabled = Services.prefs.getBoolPref(SUGGEST_URLBAR_PREF);
  Services.prefs.setBoolPref(SUGGEST_URLBAR_PREF, true);
  registerCleanupFunction(async function() {
    await Services.search.setDefault(oldDefaultEngine);
    Services.prefs.clearUserPref(SUGGEST_ALL_PREF);
    Services.prefs.setBoolPref(SUGGEST_URLBAR_PREF, suggestionsEnabled);
  });

  await UrlbarTestUtils.promiseAutocompleteResultPopup({
    window,
    waitForFocus: SimpleTest.waitForFocus,
    value: "foo",
  });
  let length = await UrlbarTestUtils.getResultCount(window);
  // Don't assume that the search doesn't match history or bookmarks left around
  // by earlier tests.
  Assert.greaterOrEqual(
    length,
    3,
    "Should get at least heuristic result + two search suggestions"
  );
  // The first expected search is the search term itself since the heuristic
  // result will come before the search suggestions.
  // The extra spaces are here due to bug 1550644.
  let searchTerm = "foo ";
  let expectedSearches = [searchTerm, "foo foo", "foo bar"];
  for (let i = 0; i < length; i++) {
    let result = await UrlbarTestUtils.getDetailsOfResultAt(window, i);
    if (result.type === UrlbarUtils.RESULT_TYPE.SEARCH) {
      Assert.greaterOrEqual(
        expectedSearches.length,
        0,
        "Should still have expected searches remaining"
      );

      let element = await UrlbarTestUtils.waitForAutocompleteResultAt(
        window,
        i
      );
      let selected = element.hasAttribute("selected");
      if (!selected) {
        // Simulate the result being selected so we see the expanded text.
        element.toggleAttribute("selected", true);
      }
      if (result.searchParams.inPrivateWindow) {
        Assert.equal(
          await getResultText(element),
          searchTerm + "— Search in a Private Window",
          "Check result label"
        );
      } else {
        let suggestion = expectedSearches.shift();
        Assert.equal(
          await getResultText(element),
          suggestion +
            "— Search with browser_searchSuggestionEngine searchSuggestionEngine.xml",
          "Check result label"
        );
      }
      if (!selected) {
        element.toggleAttribute("selected", false);
      }
    }
  }
  Assert.ok(!expectedSearches.length);
});
