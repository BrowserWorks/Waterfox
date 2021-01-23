"use strict";

const SCALAR_SEARCHBAR = "browser.engagement.navigation.searchbar";

ChromeUtils.defineModuleGetter(
  this,
  "URLBAR_SELECTED_RESULT_METHODS",
  "resource:///modules/BrowserUsageTelemetry.jsm"
);

ChromeUtils.import(
  "resource://testing-common/CustomizableUITestUtils.jsm",
  this
);
let gCUITestUtils = new CustomizableUITestUtils(window);

function checkHistogramResults(resultIndexes, expected, histogram) {
  for (let [i, val] of Object.entries(resultIndexes.values)) {
    if (i == expected) {
      Assert.equal(
        val,
        1,
        `expected counts should match for ${histogram} index ${i}`
      );
    } else {
      Assert.equal(
        !!val,
        false,
        `unexpected counts should be zero for ${histogram} index ${i}`
      );
    }
  }
}

let searchInSearchbar = async function(inputText) {
  let win = window;
  await new Promise(r => waitForFocus(r, win));
  let sb = BrowserSearch.searchBar;
  // Write the search query in the searchbar.
  sb.focus();
  sb.value = inputText;
  sb.textbox.controller.startSearch(inputText);
  // Wait for the popup to show.
  await BrowserTestUtils.waitForEvent(sb.textbox.popup, "popupshown");
  // And then for the search to complete.
  await BrowserTestUtils.waitForCondition(
    () =>
      sb.textbox.controller.searchStatus >=
      Ci.nsIAutoCompleteController.STATUS_COMPLETE_NO_MATCH,
    "The search in the searchbar must complete."
  );
};

/**
 * Click one of the entries in the search suggestion popup.
 *
 * @param {String} entryName
 *        The name of the elemet to click on.
 */
function clickSearchbarSuggestion(entryName) {
  let richlistbox = BrowserSearch.searchBar.textbox.popup.richlistbox;
  let richlistitem = Array.prototype.find.call(
    richlistbox.children,
    item => item.getAttribute("ac-value") == entryName
  );

  // Make sure the suggestion is visible and simulate the click.
  richlistbox.ensureElementIsVisible(richlistitem);
  EventUtils.synthesizeMouseAtCenter(richlistitem, {});
}

add_task(async function setup() {
  await gCUITestUtils.addSearchBar();
  registerCleanupFunction(() => {
    gCUITestUtils.removeSearchBar();
  });

  // Create two new search engines. Mark one as the default engine, so
  // the test don't crash. We need to engines for this test as the searchbar
  // doesn't display the default search engine among the one-off engines.
  await Services.search.addEngineWithDetails("MozSearch", {
    alias: "mozalias",
    method: "GET",
    template: "http://example.com/?q={searchTerms}",
  });

  await Services.search.addEngineWithDetails("MozSearch2", {
    alias: "mozalias2",
    method: "GET",
    template: "http://example.com/?q={searchTerms}",
  });

  // Make the first engine the default search engine.
  let engineDefault = Services.search.getEngineByName("MozSearch");
  let originalEngine = await Services.search.getDefault();
  await Services.search.setDefault(engineDefault);

  // Move the second engine at the beginning of the one-off list.
  let engineOneOff = Services.search.getEngineByName("MozSearch2");
  await Services.search.moveEngine(engineOneOff, 0);

  // Enable local telemetry recording for the duration of the tests.
  let oldCanRecord = Services.telemetry.canRecordExtended;
  Services.telemetry.canRecordExtended = true;

  // Enable event recording for the events tested here.
  Services.telemetry.setEventRecordingEnabled("navigation", true);

  // Make sure to restore the engine once we're done.
  registerCleanupFunction(async function() {
    Services.telemetry.canRecordExtended = oldCanRecord;
    await Services.search.setDefault(originalEngine);
    await Services.search.removeEngine(engineDefault);
    await Services.search.removeEngine(engineOneOff);
    Services.telemetry.setEventRecordingEnabled("navigation", false);
  });
});

add_task(async function test_plainQuery() {
  // Let's reset the counts.
  Services.telemetry.clearScalars();
  Services.telemetry.clearEvents();
  let resultMethodHist = TelemetryTestUtils.getAndClearHistogram(
    "FX_SEARCHBAR_SELECTED_RESULT_METHOD"
  );
  let search_hist = TelemetryTestUtils.getAndClearKeyedHistogram(
    "SEARCH_COUNTS"
  );

  let tab = await BrowserTestUtils.openNewForegroundTab(
    gBrowser,
    "about:blank"
  );

  info("Simulate entering a simple search.");
  let p = BrowserTestUtils.browserLoaded(tab.linkedBrowser);
  await searchInSearchbar("simple query");
  EventUtils.synthesizeKey("KEY_Enter");
  await p;

  // Check if the scalars contain the expected values.
  const scalars = TelemetryTestUtils.getProcessScalars("parent", true, false);
  TelemetryTestUtils.assertKeyedScalar(
    scalars,
    SCALAR_SEARCHBAR,
    "search_enter",
    1
  );
  Assert.equal(
    Object.keys(scalars[SCALAR_SEARCHBAR]).length,
    1,
    "This search must only increment one entry in the scalar."
  );

  // Make sure SEARCH_COUNTS contains identical values.
  TelemetryTestUtils.assertKeyedHistogramSum(
    search_hist,
    "other-MozSearch.searchbar",
    1
  );

  // Also check events.
  TelemetryTestUtils.assertEvents(
    [
      {
        object: "searchbar",
        value: "enter",
        extra: { engine: "other-MozSearch" },
      },
    ],
    { category: "navigation", method: "search" }
  );

  // Check the histograms as well.
  let resultMethods = resultMethodHist.snapshot();
  checkHistogramResults(
    resultMethods,
    URLBAR_SELECTED_RESULT_METHODS.enter,
    "FX_SEARCHBAR_SELECTED_RESULT_METHOD"
  );

  BrowserTestUtils.removeTab(tab);
});

// Performs a search using the first result, a one-off button, and the Return
// (Enter) key.
add_task(async function test_oneOff_enter() {
  // Let's reset the counts.
  Services.telemetry.clearScalars();
  Services.telemetry.clearEvents();
  let resultMethodHist = TelemetryTestUtils.getAndClearHistogram(
    "FX_SEARCHBAR_SELECTED_RESULT_METHOD"
  );
  let search_hist = TelemetryTestUtils.getAndClearKeyedHistogram(
    "SEARCH_COUNTS"
  );

  let tab = await BrowserTestUtils.openNewForegroundTab(
    gBrowser,
    "about:blank"
  );

  info("Perform a one-off search using the first engine.");
  let p = BrowserTestUtils.browserLoaded(tab.linkedBrowser);
  await searchInSearchbar("query");

  info("Pressing Alt+Down to highlight the first one off engine.");
  EventUtils.synthesizeKey("KEY_ArrowDown", { altKey: true });
  EventUtils.synthesizeKey("KEY_Enter");
  await p;

  // Check if the scalars contain the expected values.
  const scalars = TelemetryTestUtils.getProcessScalars("parent", true, false);
  TelemetryTestUtils.assertKeyedScalar(
    scalars,
    SCALAR_SEARCHBAR,
    "search_oneoff",
    1
  );
  Assert.equal(
    Object.keys(scalars[SCALAR_SEARCHBAR]).length,
    1,
    "This search must only increment one entry in the scalar."
  );

  // Make sure SEARCH_COUNTS contains identical values.
  TelemetryTestUtils.assertKeyedHistogramSum(
    search_hist,
    "other-MozSearch2.searchbar",
    1
  );

  // Also check events.
  TelemetryTestUtils.assertEvents(
    [
      {
        object: "searchbar",
        value: "oneoff",
        extra: { engine: "other-MozSearch2" },
      },
    ],
    { category: "navigation", method: "search" }
  );

  // Check the histograms as well.
  let resultMethods = resultMethodHist.snapshot();
  checkHistogramResults(
    resultMethods,
    URLBAR_SELECTED_RESULT_METHODS.enter,
    "FX_SEARCHBAR_SELECTED_RESULT_METHOD"
  );

  BrowserTestUtils.removeTab(tab);
});

// Performs a search using the second result, a one-off button, and the Return
// (Enter) key.  This only tests the FX_SEARCHBAR_SELECTED_RESULT_METHOD
// histogram since test_oneOff_enter covers everything else.
add_task(async function test_oneOff_enterSelection() {
  // Let's reset the counts.
  Services.telemetry.clearScalars();
  let resultMethodHist = TelemetryTestUtils.getAndClearHistogram(
    "FX_SEARCHBAR_SELECTED_RESULT_METHOD"
  );

  // Create an engine to generate search suggestions and add it as default
  // for this test.
  const url =
    getRootDirectory(gTestPath) + "usageTelemetrySearchSuggestions.xml";
  let suggestionEngine = await Services.search.addEngine(url, "", false);
  let previousEngine = await Services.search.getDefault();
  await Services.search.setDefault(suggestionEngine);

  let tab = await BrowserTestUtils.openNewForegroundTab(
    gBrowser,
    "about:blank"
  );

  info("Type a query. Suggestions should be generated by the test engine.");
  let p = BrowserTestUtils.browserLoaded(tab.linkedBrowser);
  await searchInSearchbar("query");

  info(
    "Select the second result, press Alt+Down to take us to the first one-off engine."
  );
  EventUtils.synthesizeKey("KEY_ArrowDown");
  EventUtils.synthesizeKey("KEY_ArrowDown", { altKey: true });
  EventUtils.synthesizeKey("KEY_Enter");
  await p;

  let resultMethods = resultMethodHist.snapshot();
  checkHistogramResults(
    resultMethods,
    URLBAR_SELECTED_RESULT_METHODS.enterSelection,
    "FX_SEARCHBAR_SELECTED_RESULT_METHOD"
  );

  await Services.search.setDefault(previousEngine);
  await Services.search.removeEngine(suggestionEngine);
  BrowserTestUtils.removeTab(tab);
});

// Performs a search using a click on a one-off button.  This only tests the
// FX_SEARCHBAR_SELECTED_RESULT_METHOD histogram since test_oneOff_enter covers
// everything else.
add_task(async function test_oneOff_click() {
  // Let's reset the counts.
  Services.telemetry.clearScalars();
  let resultMethodHist = TelemetryTestUtils.getAndClearHistogram(
    "FX_SEARCHBAR_SELECTED_RESULT_METHOD"
  );

  let tab = await BrowserTestUtils.openNewForegroundTab(
    gBrowser,
    "about:blank"
  );

  info("Type a query.");
  let p = BrowserTestUtils.browserLoaded(tab.linkedBrowser);
  await searchInSearchbar("query");
  info("Click the first one-off button.");
  BrowserSearch.searchBar.textbox.popup.oneOffButtons
    .getSelectableButtons(false)[0]
    .click();
  await p;

  let resultMethods = resultMethodHist.snapshot();
  checkHistogramResults(
    resultMethods,
    URLBAR_SELECTED_RESULT_METHODS.click,
    "FX_SEARCHBAR_SELECTED_RESULT_METHOD"
  );

  BrowserTestUtils.removeTab(tab);
});

// Clicks the first suggestion offered by the test search engine.
add_task(async function test_suggestion_click() {
  // Let's reset the counts.
  Services.telemetry.clearScalars();
  Services.telemetry.clearEvents();
  let resultMethodHist = TelemetryTestUtils.getAndClearHistogram(
    "FX_SEARCHBAR_SELECTED_RESULT_METHOD"
  );
  let search_hist = TelemetryTestUtils.getAndClearKeyedHistogram(
    "SEARCH_COUNTS"
  );

  // Create an engine to generate search suggestions and add it as default
  // for this test.
  const url =
    getRootDirectory(gTestPath) + "usageTelemetrySearchSuggestions.xml";
  let suggestionEngine = await Services.search.addEngine(url, "", false);
  let previousEngine = await Services.search.getDefault();
  await Services.search.setDefault(suggestionEngine);

  let tab = await BrowserTestUtils.openNewForegroundTab(
    gBrowser,
    "about:blank"
  );

  info("Perform a one-off search using the first engine.");
  let p = BrowserTestUtils.browserLoaded(tab.linkedBrowser);
  await searchInSearchbar("query");
  info("Clicking the searchbar suggestion.");
  clickSearchbarSuggestion("queryfoo");
  await p;

  // Check if the scalars contain the expected values.
  const scalars = TelemetryTestUtils.getProcessScalars("parent", true, false);
  TelemetryTestUtils.assertKeyedScalar(
    scalars,
    SCALAR_SEARCHBAR,
    "search_suggestion",
    1
  );
  Assert.equal(
    Object.keys(scalars[SCALAR_SEARCHBAR]).length,
    1,
    "This search must only increment one entry in the scalar."
  );

  // Make sure SEARCH_COUNTS contains identical values.
  let searchEngineId = "other-" + suggestionEngine.name;
  TelemetryTestUtils.assertKeyedHistogramSum(
    search_hist,
    searchEngineId + ".searchbar",
    1
  );

  // Also check events.
  TelemetryTestUtils.assertEvents(
    [
      {
        object: "searchbar",
        value: "suggestion",
        extra: { engine: searchEngineId },
      },
    ],
    { category: "navigation", method: "search" }
  );

  // Check the histograms as well.
  let resultMethods = resultMethodHist.snapshot();
  checkHistogramResults(
    resultMethods,
    URLBAR_SELECTED_RESULT_METHODS.click,
    "FX_SEARCHBAR_SELECTED_RESULT_METHOD"
  );

  await Services.search.setDefault(previousEngine);
  await Services.search.removeEngine(suggestionEngine);
  BrowserTestUtils.removeTab(tab);
});

// Selects and presses the Return (Enter) key on the first suggestion offered by
// the test search engine.  This only tests the
// FX_SEARCHBAR_SELECTED_RESULT_METHOD histogram since test_suggestion_click
// covers everything else.
add_task(async function test_suggestion_enterSelection() {
  // Let's reset the counts.
  Services.telemetry.clearScalars();
  let resultMethodHist = TelemetryTestUtils.getAndClearHistogram(
    "FX_SEARCHBAR_SELECTED_RESULT_METHOD"
  );

  // Create an engine to generate search suggestions and add it as default
  // for this test.
  const url =
    getRootDirectory(gTestPath) + "usageTelemetrySearchSuggestions.xml";
  let suggestionEngine = await Services.search.addEngine(url, "", false);
  let previousEngine = await Services.search.getDefault();
  await Services.search.setDefault(suggestionEngine);

  let tab = await BrowserTestUtils.openNewForegroundTab(
    gBrowser,
    "about:blank"
  );

  info("Type a query. Suggestions should be generated by the test engine.");
  let p = BrowserTestUtils.browserLoaded(tab.linkedBrowser);
  await searchInSearchbar("query");
  info("Select the second result and press Return.");
  EventUtils.synthesizeKey("KEY_ArrowDown");
  EventUtils.synthesizeKey("KEY_Enter");
  await p;

  let resultMethods = resultMethodHist.snapshot();
  checkHistogramResults(
    resultMethods,
    URLBAR_SELECTED_RESULT_METHODS.enterSelection,
    "FX_SEARCHBAR_SELECTED_RESULT_METHOD"
  );

  await Services.search.setDefault(previousEngine);
  await Services.search.removeEngine(suggestionEngine);
  BrowserTestUtils.removeTab(tab);
});
