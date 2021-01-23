/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

XPCOMUtils.defineLazyModuleGetters(this, {
  FormHistory: "resource://gre/modules/FormHistory.jsm",
});

add_task(async function test_remove_history() {
  const TEST_URL = "http://remove.me/from_urlbar/";
  await PlacesTestUtils.addVisits(TEST_URL);

  registerCleanupFunction(async function() {
    await PlacesUtils.history.clear();
  });

  let promiseVisitRemoved = PlacesTestUtils.waitForNotification(
    "onDeleteURI",
    uri => uri.spec == TEST_URL,
    "history"
  );

  await UrlbarTestUtils.promiseAutocompleteResultPopup({
    window,
    waitForFocus: SimpleTest.waitForFocus,
    value: "from_urlbar",
  });

  let result = await UrlbarTestUtils.getDetailsOfResultAt(window, 1);
  Assert.equal(result.url, TEST_URL, "Found the expected result");

  let expectedResultCount = UrlbarTestUtils.getResultCount(window) - 1;

  EventUtils.synthesizeKey("KEY_ArrowDown");
  Assert.equal(UrlbarTestUtils.getSelectedRowIndex(window), 1);
  EventUtils.synthesizeKey("KEY_Delete", { shiftKey: true });
  await promiseVisitRemoved;
  await TestUtils.waitForCondition(
    () => UrlbarTestUtils.getResultCount(window) == expectedResultCount,
    "Waiting for the result to disappear"
  );

  for (let i = 0; i < expectedResultCount; i++) {
    let details = await UrlbarTestUtils.getDetailsOfResultAt(window, i);
    Assert.notEqual(
      details.url,
      TEST_URL,
      "Should not find the test URL in the remaining results"
    );
  }

  await UrlbarTestUtils.promisePopupClose(window);
});

add_task(async function test_remove_form_history() {
  await SpecialPowers.pushPrefEnv({
    set: [
      ["browser.urlbar.suggest.searches", true],
      ["browser.urlbar.maxHistoricalSearchSuggestions", 1],
    ],
  });

  await Services.search.addEngineWithDetails("test", {
    method: "GET",
    template: "http://example.com/?q={searchTerms}",
  });
  let engine = Services.search.getEngineByName("test");
  let originalEngine = await Services.search.getDefault();
  await Services.search.setDefault(engine);

  let formHistoryValue = "foobar";
  await UrlbarTestUtils.formHistory.add([formHistoryValue]);

  let formHistory = (
    await UrlbarTestUtils.formHistory.search({
      value: formHistoryValue,
    })
  ).map(entry => entry.value);
  Assert.deepEqual(
    formHistory,
    [formHistoryValue],
    "Should find form history after adding it"
  );

  let promiseRemoved = UrlbarTestUtils.formHistory.promiseChanged("remove");

  await UrlbarTestUtils.promiseAutocompleteResultPopup({
    window,
    waitForFocus: SimpleTest.waitForFocus,
    value: "foo",
  });

  let index = 1;
  let count = UrlbarTestUtils.getResultCount(window);
  for (; index < count; index++) {
    let result = await UrlbarTestUtils.getDetailsOfResultAt(window, index);
    if (
      result.type == UrlbarUtils.RESULT_TYPE.SEARCH &&
      result.source == UrlbarUtils.RESULT_SOURCE.HISTORY
    ) {
      break;
    }
  }
  Assert.ok(index < count, "Result found");

  EventUtils.synthesizeKey("KEY_ArrowDown", { repeat: index });
  Assert.equal(UrlbarTestUtils.getSelectedRowIndex(window), index);
  EventUtils.synthesizeKey("KEY_Delete", { shiftKey: true });
  await promiseRemoved;

  await TestUtils.waitForCondition(
    () => UrlbarTestUtils.getResultCount(window) == count - 1,
    "Waiting for the result to disappear"
  );

  for (let i = 0; i < UrlbarTestUtils.getResultCount(window); i++) {
    let result = await UrlbarTestUtils.getDetailsOfResultAt(window, i);
    Assert.ok(
      result.type != UrlbarUtils.RESULT_TYPE.SEARCH ||
        result.source != UrlbarUtils.RESULT_SOURCE.HISTORY,
      "Should not find the form history result in the remaining results"
    );
  }

  await UrlbarTestUtils.promisePopupClose(window);

  formHistory = (
    await UrlbarTestUtils.formHistory.search({
      value: formHistoryValue,
    })
  ).map(entry => entry.value);
  Assert.deepEqual(
    formHistory,
    [],
    "Should not find form history after removing it"
  );

  await SpecialPowers.popPrefEnv();
  await Services.search.setDefault(originalEngine);
  await Services.search.removeEngine(engine);
});

// We shouldn't be able to remove a bookmark item.
add_task(async function test_remove_bookmark_doesnt() {
  const TEST_URL = "http://dont.remove.me/from_urlbar/";
  await PlacesUtils.bookmarks.insert({
    parentGuid: PlacesUtils.bookmarks.unfiledGuid,
    title: "test",
    url: TEST_URL,
  });

  registerCleanupFunction(async function() {
    await PlacesUtils.bookmarks.eraseEverything();
  });

  await UrlbarTestUtils.promiseAutocompleteResultPopup({
    window,
    waitForFocus: SimpleTest.waitForFocus,
    value: "from_urlbar",
  });
  let result = await UrlbarTestUtils.getDetailsOfResultAt(window, 1);
  Assert.equal(result.url, TEST_URL, "Found the expected result");

  EventUtils.synthesizeKey("KEY_ArrowDown");
  Assert.equal(UrlbarTestUtils.getSelectedRowIndex(window), 1);
  EventUtils.synthesizeKey("KEY_Delete", { shiftKey: true });

  // We don't have an easy way of determining if the event was process or not,
  // so let any event queues clear before testing.
  await new Promise(resolve => setTimeout(resolve, 0));
  await PlacesTestUtils.promiseAsyncUpdates();

  Assert.ok(
    await PlacesUtils.bookmarks.fetch({ url: TEST_URL }),
    "Should still have the URL bookmarked."
  );
});
