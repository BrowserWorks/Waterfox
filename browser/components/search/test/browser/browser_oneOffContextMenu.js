"use strict";

const TEST_ENGINE_NAME = "Foo";
const TEST_ENGINE_BASENAME = "testEngine.xml";

const searchPopup = document.getElementById("PopupSearchAutoComplete");
const oneOffInstance = searchPopup.oneOffButtons;
const contextMenu = oneOffInstance.querySelector(
  ".search-one-offs-context-menu"
);
const oneOffButtons = oneOffInstance.buttons;
const searchInNewTabMenuItem = oneOffInstance.querySelector(
  ".search-one-offs-context-open-in-new-tab"
);

let searchbar;
let searchIcon;

add_task(async function init() {
  searchbar = await gCUITestUtils.addSearchBar();
  registerCleanupFunction(() => {
    gCUITestUtils.removeSearchBar();
  });
  searchIcon = searchbar.querySelector(".searchbar-search-button");

  await promiseNewEngine(TEST_ENGINE_BASENAME, {
    setAsCurrent: false,
  });
});

add_task(async function telemetry() {
  // Open the popup.
  let shownPromise = promiseEvent(searchPopup, "popupshown");
  let builtPromise = promiseEvent(oneOffInstance, "rebuild");
  info("Opening search panel");
  EventUtils.synthesizeMouseAtCenter(searchIcon, {});
  await Promise.all([shownPromise, builtPromise]);

  // Get the one-off button for the test engine.
  let oneOffButton;
  for (let node of oneOffButtons.children) {
    if (node.engine && node.engine.name == TEST_ENGINE_NAME) {
      oneOffButton = node;
      break;
    }
  }
  Assert.notEqual(
    oneOffButton,
    undefined,
    "One-off for test engine should exist"
  );

  // Open the context menu on the one-off.
  let promise = BrowserTestUtils.waitForEvent(contextMenu, "popupshown");
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
  EventUtils.synthesizeKey("KEY_Escape");
  await promise;

  // Check the loaded tab.
  Assert.equal(
    tab.linkedBrowser.currentURI.spec,
    "http://mochi.test:8888/browser/browser/components/search/test/browser/",
    "Expected search tab should have loaded"
  );

  BrowserTestUtils.removeTab(tab);

  // Move the cursor out of the panel area to avoid messing with other tests.
  await EventUtils.synthesizeNativeMouseMove(searchbar);
});
