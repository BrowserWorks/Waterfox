"use strict";

const TEST_ENGINE_NAME = "Foo";
const TEST_ENGINE_BASENAME = "testEngine.xml";

const searchbar = document.getElementById("searchbar");
const searchPopup = document.getElementById("PopupSearchAutoComplete");
const searchIcon = document.getAnonymousElementByAttribute(
  searchbar, "anonid", "searchbar-search-button"
);
const oneOffBinding = document.getAnonymousElementByAttribute(
  searchPopup, "anonid", "search-one-off-buttons"
);
const contextMenu = document.getAnonymousElementByAttribute(
  oneOffBinding, "anonid", "search-one-offs-context-menu"
);
const oneOffButtons = document.getAnonymousElementByAttribute(
  oneOffBinding, "anonid", "search-panel-one-offs"
);
const searchInNewTabMenuItem = document.getAnonymousElementByAttribute(
  oneOffBinding, "anonid", "search-one-offs-context-open-in-new-tab"
);

add_task(async function init() {
  await promiseNewEngine(TEST_ENGINE_BASENAME, {
    setAsCurrent: false,
  });
});

add_task(async function extendedTelemetryDisabled() {
  await SpecialPowers.pushPrefEnv({set: [["toolkit.telemetry.enabled", false]]});
  await doTest();
  checkTelemetry("other");
});

add_task(async function extendedTelemetryEnabled() {
  await SpecialPowers.pushPrefEnv({set: [["toolkit.telemetry.enabled", true]]});
  await doTest();
  checkTelemetry("other-" + TEST_ENGINE_NAME);
});

async function doTest() {
  // Open the popup.
  let promise = promiseEvent(searchPopup, "popupshown");
  info("Opening search panel");
  EventUtils.synthesizeMouseAtCenter(searchIcon, {});
  await promise;

  // Get the one-off button for the test engine.
  let oneOffButton;
  for (let node of oneOffButtons.childNodes) {
    if (node.engine && node.engine.name == TEST_ENGINE_NAME) {
      oneOffButton = node;
      break;
    }
  }
  Assert.notEqual(oneOffButton, undefined,
                  "One-off for test engine should exist");

  // Open the context menu on the one-off.
  promise = BrowserTestUtils.waitForEvent(contextMenu, "popupshown");
  EventUtils.synthesizeMouseAtCenter(oneOffButton, {
    type: "contextmenu",
    button: 2,
  });
  await promise;

  // Click the Search in New Tab menu item.
  promise = BrowserTestUtils.waitForNewTab(gBrowser);
  EventUtils.synthesizeMouseAtCenter(searchInNewTabMenuItem, {});
  let tab = await promise;

  // By default the search will open in the background and the popup will stay open:
  promise = promiseEvent(searchPopup, "popuphidden");
  info("Closing search panel");
  EventUtils.synthesizeKey("VK_ESCAPE", {});
  await promise;

  // Check the loaded tab.
  Assert.equal(tab.linkedBrowser.currentURI.spec,
               "http://mochi.test:8888/browser/browser/components/search/test/",
               "Expected search tab should have loaded");

  await BrowserTestUtils.removeTab(tab);

  // Move the cursor out of the panel area to avoid messing with other tests.
  await EventUtils.synthesizeNativeMouseMove(searchbar);
}
