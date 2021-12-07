"use scrict";

const { AppConstants } = ChromeUtils.import(
  "resource://gre/modules/AppConstants.jsm"
);

const COPY_URL_PREF = "browser.tabs.copyurl";
const COPY_ALL_URLS_PREF = "browser.tabs.copyallurls";
const DUPLICATE_TAB_PREF = "browser.tabs.duplicateTab";
const RESTART_PREF = "browser.restart_menu.showpanelmenubtn";
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
