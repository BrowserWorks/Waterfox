"use strict";

add_task(async function testCopyTabUrls() {
  // Make sure elements are present
  let copyTabUrl = document.getElementById("context_copyTabUrl");
  let copyAllTabUrls = document.getElementById("context_copyAllTabUrls");
  ok(copyTabUrl, "Copy tab URL is included");
  ok(copyAllTabUrls, "Copy all tab URLs is included");
  // Make sure that defaults are set correctly
  let contextMenu = await openAndCloseTabContextMenu(gBrowser.selectedTab);
  Assert.equal(copyTabUrl.hidden, false, "Copy tab URL visible by default");
  Assert.equal(
    copyAllTabUrls.hidden,
    true,
    "Copy all tab URLs hidden by default"
  );
  // Make sure changing prefs causes elements to be shown/hidden
  Services.prefs.setBoolPref(COPY_URL_PREF, false);
  Services.prefs.setBoolPref(COPY_ALL_URLS_PREF, false);
  contextMenu = await openAndCloseTabContextMenu(gBrowser.selectedTab);
  Assert.equal(copyTabUrl.hidden, true, "Copy tab URL hidden");
  Assert.equal(copyAllTabUrls.hidden, true, "Copy all tab URLs hidden");
  Services.prefs.setBoolPref(COPY_URL_PREF, true);
  Services.prefs.setBoolPref(COPY_ALL_URLS_PREF, true);
  contextMenu = await openAndCloseTabContextMenu(gBrowser.selectedTab);
  Assert.equal(copyTabUrl.hidden, false, "Copy tab URL visible");
  Assert.equal(copyAllTabUrls.hidden, false, "Copy all tab URLs visible");
  Services.prefs.clearUserPref(COPY_URL_PREF);
  Services.prefs.clearUserPref(COPY_ALL_URLS_PREF);
  // TODO: Make sure functionality works
  // TODO: Test copy tab url copies URL
  // TODO: Make sure active tab pref works
  // TODO: Test copy all tab urls works
});

add_task(async function testHideDuplicateTab() {
  // Setting duplicateTab pref to false should hide element in all windows
  let duplicateTab = document.getElementById("context_duplicateTab");
  Services.prefs.setBoolPref(DUPLICATE_TAB_PREF, false);
  let contextMenu = await openAndCloseTabContextMenu(gBrowser.selectedTab);
  Assert.equal(duplicateTab.hidden, true, "Duplicate tab hidden");
  // Should fall back to default value of true, i.e. element showing
  Services.prefs.clearUserPref(DUPLICATE_TAB_PREF);
  // Ensure showing
  contextMenu = await openAndCloseTabContextMenu(gBrowser.selectedTab);
  Assert.equal(duplicateTab.hidden, false, "Duplicate tab showing");
})

add_task(async function testRestartItem() {
  // TODO: Set pref to show, ensure is visible, set to hide, check is hidden
  // Make sure element is present
  let restartBrowserMenu = document.getElementById("app_restartBrowser");
  let restartBrowserApp = document.getElementById("appMenu-restart-button");
  ok(restartBrowserMenu, "Restart browser menu bar item is included");
  is(restartBrowserApp, null, "Restart browser appMenu item not included.")
  // Make sure element is visible
  Services.prefs.setBoolPref(RESTART_PREF, true);
  // Make sure element visibility changed in new window
  // TODO: Make sure functionality works
  // TODO: Test requireconfirm pops up confirmation window
  // TODO: Test purgecache clears cache
})

// TODO: Move tab bar
// TODO: Move bookmarks bar
// TODO: Style buttonbox and menubar

// TODO: PrivateTab
// TODO: StatusBar