"use scrict";

const { AppConstants } = ChromeUtils.import(
  "resource://gre/modules/AppConstants.jsm"
);

const { PrivateTab } = ChromeUtils.import("resource:///modules/PrivateTab.jsm");

var { synthesizeDrop, synthesizeMouseAtCenter } = EventUtils;

const COPY_URL_PREF = "browser.tabs.copyurl";
const COPY_ALL_URLS_PREF = "browser.tabs.copyallurls";
const DUPLICATE_TAB_PREF = "browser.tabs.duplicateTab";
const RESTART_PREF = "browser.restart_menu.showpanelmenubtn";
const TABBAR_POSITION_PREF = "browser.tabs.toolbarposition";
const BOOKMARKBAR_POSITION_PREF = "browser.bookmarks.toolbarposition";
const STATUSBAR_ENABLED_PREF = "browser.statusbar.enabled";

let OS = AppConstants.platform;
/**
 * Helper for opening the toolbar context menu.
 */
async function openTabContextMenu(tab) {
  info("Opening tab context menu");
  let contextMenu = document.getElementById("tabContextMenu");
  let openTabContextMenuPromise = BrowserTestUtils.waitForPopupEvent(
    contextMenu,
    "shown"
  );

  EventUtils.synthesizeMouseAtCenter(tab, { type: "contextmenu" });
  await openTabContextMenuPromise;
  return contextMenu;
}

async function openAndCloseTabContextMenu(tab) {
  await openTabContextMenu(tab);
  info("Opened tab context menu");
  await EventUtils.synthesizeKey("VK_ESCAPE", {});
  info("Closed tab context menu");
}

/**
 * Helper for opening the file menu.
 */
async function openFileMenu() {
  info("Opening file menu");
  let fileMenu = document.getElementById("file-menu");
  let openFileMenuPromise = BrowserTestUtils.waitForPopupEvent(
    fileMenu,
    "shown"
  );
  EventUtils.synthesizeMouseAtCenter(fileMenu, {});
  await openFileMenuPromise;
  return fileMenu;
}

async function openAndCloseFileMenu() {
  await openFileMenu();
  await EventUtils.synthesizeKey("VK_ESCAPE", {});
  info("Closed file menu");
}

/**
 * Helper for opening toolbar context menu.
 */
async function openToolbarContextMenu(contextMenu, target) {
  let popupshown = BrowserTestUtils.waitForEvent(contextMenu, "popupshown");
  EventUtils.synthesizeMouseAtCenter(target, { type: "contextmenu" });
  await popupshown;
}

/**
 * Helpers for Customizable UI
 */

function startCustomizing(aWindow = window) {
  if (aWindow.document.documentElement.getAttribute("customizing") == "true") {
    return null;
  }
  let customizationReadyPromise = BrowserTestUtils.waitForEvent(
    aWindow.gNavToolbox,
    "customizationready"
  );
  aWindow.gCustomizeMode.enter();
  return customizationReadyPromise;
}

function endCustomizing(aWindow = window) {
  if (aWindow.document.documentElement.getAttribute("customizing") != "true") {
    return true;
  }
  let afterCustomizationPromise = BrowserTestUtils.waitForEvent(
    aWindow.gNavToolbox,
    "aftercustomization"
  );
  aWindow.gCustomizeMode.exit();
  return afterCustomizationPromise;
}

function assertAreaPlacements(areaId, expectedPlacements) {
  let actualPlacements = getAreaWidgetIds(areaId);
  placementArraysEqual(areaId, actualPlacements, expectedPlacements);
}

function getAreaWidgetIds(areaId) {
  return CustomizableUI.getWidgetIdsInArea(areaId);
}

function placementArraysEqual(areaId, actualPlacements, expectedPlacements) {
  info("Actual placements: " + actualPlacements.join(", "));
  info("Expected placements: " + expectedPlacements.join(", "));
  is(
    actualPlacements.length,
    expectedPlacements.length,
    "Area " + areaId + " should have " + expectedPlacements.length + " items."
  );
  let minItems = Math.min(expectedPlacements.length, actualPlacements.length);
  for (let i = 0; i < minItems; i++) {
    if (typeof expectedPlacements[i] == "string") {
      is(
        actualPlacements[i],
        expectedPlacements[i],
        "Item " + i + " in " + areaId + " should match expectations."
      );
    } else if (expectedPlacements[i] instanceof RegExp) {
      ok(
        expectedPlacements[i].test(actualPlacements[i]),
        "Item " +
          i +
          " (" +
          actualPlacements[i] +
          ") in " +
          areaId +
          " should match " +
          expectedPlacements[i]
      );
    } else {
      ok(
        false,
        "Unknown type of expected placement passed to " +
          " assertAreaPlacements. Is your test broken?"
      );
    }
  }
}

function simulateItemDrag(aToDrag, aTarget, aEvent = {}, aOffset = 2) {
  let ev = aEvent;
  if (ev == "end" || ev == "start") {
    let win = aTarget.ownerGlobal;
    const dwu = win.windowUtils;
    let bounds = dwu.getBoundsWithoutFlushing(aTarget);
    if (ev == "end") {
      ev = {
        clientX: bounds.right - aOffset,
        clientY: bounds.bottom - aOffset,
      };
    } else {
      ev = { clientX: bounds.left + aOffset, clientY: bounds.top + aOffset };
    }
  }
  ev._domDispatchOnly = true;
  synthesizeDrop(
    aToDrag.parentNode,
    aTarget,
    null,
    null,
    aToDrag.ownerGlobal,
    aTarget.ownerGlobal,
    ev
  );
  // Ensure dnd suppression is cleared.
  synthesizeMouseAtCenter(aTarget, { type: "mouseup" }, aTarget.ownerGlobal);
}
