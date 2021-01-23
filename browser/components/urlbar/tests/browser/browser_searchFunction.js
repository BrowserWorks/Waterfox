/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

// This test checks the urlbar.search() function.

"use strict";

add_task(async function init() {
  // Run this in a new tab, to ensure all the locationchange notifications have
  // fired.
  let tab = await BrowserTestUtils.openNewForegroundTab(gBrowser);
  registerCleanupFunction(async function() {
    BrowserTestUtils.removeTab(tab);
    gURLBar.handleRevert();
  });
});

// Calls search() with a normal, non-"@engine" search-string argument.
add_task(async function basic() {
  gURLBar.blur();
  gURLBar.search("basic");
  ok(gURLBar.hasAttribute("focused"), "url bar is focused");
  await assertUrlbarValue("basic");

  assertOneOffButtonsVisible(true);

  await UrlbarTestUtils.promisePopupClose(window, () =>
    EventUtils.synthesizeKey("KEY_Escape")
  );
});

// Calls search() with an "@engine" search engine alias so that the one-off
// search buttons are disabled.
add_task(async function searchEngineAlias() {
  gURLBar.blur();
  await UrlbarTestUtils.promisePopupOpen(window, () =>
    gURLBar.search("@example")
  );
  ok(gURLBar.hasAttribute("focused"), "url bar is focused");
  await assertUrlbarValue("@example");

  assertOneOffButtonsVisible(false);

  await UrlbarTestUtils.promisePopupClose(window, () =>
    EventUtils.synthesizeKey("KEY_Escape")
  );

  // Open the popup again (by doing another search) to make sure the one-off
  // buttons are shown -- i.e., that we didn't accidentally break them.
  await UrlbarTestUtils.promisePopupOpen(window, () =>
    gURLBar.search("not an engine alias")
  );
  await assertUrlbarValue("not an engine alias");
  assertOneOffButtonsVisible(true);

  await UrlbarTestUtils.promisePopupClose(window, () =>
    EventUtils.synthesizeKey("KEY_Escape")
  );
});

// Calls search() with a restriction character.
add_task(async function searchRestriction() {
  gURLBar.blur();
  await UrlbarTestUtils.promisePopupOpen(window, () =>
    gURLBar.search(UrlbarTokenizer.RESTRICT.SEARCH)
  );
  ok(gURLBar.hasAttribute("focused"), "url bar is focused");
  // We always add a whitespace to restrict tokens.
  await assertUrlbarValue(UrlbarTokenizer.RESTRICT.SEARCH + " ");

  assertOneOffButtonsVisible(false);

  await UrlbarTestUtils.promisePopupClose(window);
});

// Calls search() twice with the same value. The popup should reopen.
add_task(async function searchTwice() {
  gURLBar.blur();
  await UrlbarTestUtils.promisePopupOpen(window, () => gURLBar.search("test"));
  ok(gURLBar.hasAttribute("focused"), "url bar is focused");
  await assertUrlbarValue("test");
  assertOneOffButtonsVisible(true);
  await UrlbarTestUtils.promisePopupClose(window);

  await UrlbarTestUtils.promisePopupOpen(window, () => gURLBar.search("test"));
  ok(gURLBar.hasAttribute("focused"), "url bar is focused");
  await assertUrlbarValue("test");
  assertOneOffButtonsVisible(true);
  await UrlbarTestUtils.promisePopupClose(window);
});

// Calls search() during an IME composition.
add_task(async function searchIME() {
  // First run a search.
  gURLBar.blur();
  await UrlbarTestUtils.promisePopupOpen(window, () => gURLBar.search("test"));
  ok(gURLBar.hasAttribute("focused"), "url bar is focused");
  await assertUrlbarValue("test");
  // Start composition.
  await UrlbarTestUtils.promisePopupClose(window, () =>
    EventUtils.synthesizeComposition({ type: "compositionstart" })
  );

  gURLBar.search("test");
  // Unfortunately there's no other way to check we don't open the view than to
  // wait for it.
  // eslint-disable-next-line mozilla/no-arbitrary-setTimeout
  await new Promise(resolve => setTimeout(resolve, 1000));
  ok(!UrlbarTestUtils.isPopupOpen(window), "The panel should still be closed");

  await UrlbarTestUtils.promisePopupOpen(window, () =>
    EventUtils.synthesizeComposition({ type: "compositioncommitasis" })
  );

  assertOneOffButtonsVisible(true);

  await UrlbarTestUtils.promisePopupClose(window);
});

/**
 * Asserts that the one-off search buttons are or aren't visible.
 *
 * @param {boolean} visible
 *        True if they should be visible, false if not.
 */
function assertOneOffButtonsVisible(visible) {
  Assert.equal(
    UrlbarTestUtils.getOneOffSearchButtonsVisible(window),
    visible,
    "Should show or not the one-off search buttons"
  );
}

/**
 * Asserts that the urlbar's input value is the given value.  Also asserts that
 * the first (heuristic) result in the popup is a search suggestion whose search
 * query is the given value.
 *
 * @param {string} value
 *        The urlbar's expected value.
 */
async function assertUrlbarValue(value) {
  await UrlbarTestUtils.waitForAutocompleteResultAt(window, 0);

  Assert.equal(gURLBar.value, value);
  Assert.greater(
    UrlbarTestUtils.getResultCount(window),
    0,
    "Should have at least one result"
  );

  let result = await UrlbarTestUtils.getDetailsOfResultAt(window, 0);
  Assert.equal(
    result.type,
    UrlbarUtils.RESULT_TYPE.SEARCH,
    "Should have type search for the first result"
  );
  // Strip restriction token from value.
  let restrictTokens = Object.values(UrlbarTokenizer.RESTRICT);
  if (restrictTokens.includes(value[0])) {
    value = value.substring(1).trim();
  }
  Assert.equal(
    result.searchParams.query,
    value,
    "Should have the correct query for the first result"
  );
}
