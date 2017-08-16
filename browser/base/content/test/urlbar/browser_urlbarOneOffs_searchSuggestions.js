const TEST_ENGINE_BASENAME = "searchSuggestionEngine.xml";

add_task(async function init() {
  await PlacesTestUtils.clearHistory();
  await SpecialPowers.pushPrefEnv({
    set: [["browser.urlbar.oneOffSearches", true],
          ["browser.urlbar.suggest.searches", true]],
  });
  let engine = await promiseNewSearchEngine(TEST_ENGINE_BASENAME);
  let oldCurrentEngine = Services.search.currentEngine;
  Services.search.moveEngine(engine, 0);
  Services.search.currentEngine = engine;
  registerCleanupFunction(async function() {
    Services.search.currentEngine = oldCurrentEngine;

    await PlacesTestUtils.clearHistory();
    // Make sure the popup is closed for the next test.
    gURLBar.blur();
    Assert.ok(!gURLBar.popup.popupOpen, "popup should be closed");
  });
});

// Presses the Return key when a one-off is selected after selecting a search
// suggestion.
add_task(async function oneOffReturnAfterSuggestion() {
  let tab = await BrowserTestUtils.openNewForegroundTab(gBrowser);

  let typedValue = "foo";
  await promiseAutocompleteResultPopup(typedValue, window, true);
  await BrowserTestUtils.waitForCondition(suggestionsPresent,
                                          "waiting for suggestions");
  assertState(0, -1, typedValue);

  // Down to select the first search suggestion.
  EventUtils.synthesizeKey("VK_DOWN", {})
  assertState(1, -1, "foofoo");

  // Down to select the next search suggestion.
  EventUtils.synthesizeKey("VK_DOWN", {})
  assertState(2, -1, "foobar");

  // Alt+Down to select the first one-off.
  EventUtils.synthesizeKey("VK_DOWN", { altKey: true })
  assertState(2, 0, "foobar");

  let resultsPromise =
    BrowserTestUtils.browserLoaded(gBrowser.selectedBrowser, false,
                                   `http://mochi.test:8888/?terms=foobar`);
  EventUtils.synthesizeKey("VK_RETURN", {});
  await resultsPromise;

  await PlacesTestUtils.clearHistory();
  await BrowserTestUtils.removeTab(tab);
});

// Clicks a one-off engine after selecting a search suggestion.
add_task(async function oneOffClickAfterSuggestion() {
  let tab = await BrowserTestUtils.openNewForegroundTab(gBrowser);

  let typedValue = "foo";
  await promiseAutocompleteResultPopup(typedValue, window, true);
  await BrowserTestUtils.waitForCondition(suggestionsPresent,
                                          "waiting for suggestions");
  assertState(0, -1, typedValue);

  // Down to select the first search suggestion.
  EventUtils.synthesizeKey("VK_DOWN", {})
  assertState(1, -1, "foofoo");

  // Down to select the next search suggestion.
  EventUtils.synthesizeKey("VK_DOWN", {})
  assertState(2, -1, "foobar");

  let oneOffs = gURLBar.popup.oneOffSearchButtons.getSelectableButtons(true);
  let resultsPromise =
    BrowserTestUtils.browserLoaded(gBrowser.selectedBrowser, false,
                                   `http://mochi.test:8888/?terms=foobar`);
  EventUtils.synthesizeMouseAtCenter(oneOffs[0], {});
  await resultsPromise;

  await PlacesTestUtils.clearHistory();
  await BrowserTestUtils.removeTab(tab);
});

function assertState(result, oneOff, textValue = undefined) {
  Assert.equal(gURLBar.popup.selectedIndex, result,
               "Expected result should be selected");
  Assert.equal(gURLBar.popup.oneOffSearchButtons.selectedButtonIndex, oneOff,
               "Expected one-off should be selected");
  if (textValue !== undefined) {
    Assert.equal(gURLBar.textValue, textValue, "Expected textValue");
  }
}

async function hidePopup() {
  EventUtils.synthesizeKey("VK_ESCAPE", {});
  await promisePopupHidden(gURLBar.popup);
}

function suggestionsPresent() {
  let controller = gURLBar.popup.input.controller;
  let matchCount = controller.matchCount;
  for (let i = 0; i < matchCount; i++) {
    let url = controller.getValueAt(i);
    let mozActionMatch = url.match(/^moz-action:([^,]+),(.*)$/);
    if (mozActionMatch) {
      let [, type, paramStr] = mozActionMatch;
      let params = JSON.parse(paramStr);
      if (type == "searchengine" && "searchSuggestion" in params) {
        return true;
      }
    }
  }
  return false;
}
