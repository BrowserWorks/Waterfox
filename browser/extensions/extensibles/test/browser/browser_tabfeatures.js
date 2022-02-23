"use strict";

add_task(async function testCopyTabUrls() {
  // Make sure elements are present
  let copyTabUrl = document.getElementById("context_copyTabUrl");
  let copyAllTabUrls = document.getElementById("context_copyAllTabUrls");
  ok(copyTabUrl, "Copy tab URL is included");
  ok(copyAllTabUrls, "Copy all tab URLs is included");
  // Make sure that defaults are set correctly
  await openAndCloseTabContextMenu(gBrowser.selectedTab);
  is(copyTabUrl.hidden, false, "Copy tab URL visible by default");
  is(copyAllTabUrls.hidden, true, "Copy all tab URLs hidden by default");
  // Make sure changing prefs causes elements to be shown/hidden
  Services.prefs.setBoolPref(COPY_URL_PREF, false);
  Services.prefs.setBoolPref(COPY_ALL_URLS_PREF, false);
  await openAndCloseTabContextMenu(gBrowser.selectedTab);
  is(copyTabUrl.hidden, true, "Copy tab URL hidden");
  is(copyAllTabUrls.hidden, true, "Copy all tab URLs hidden");
  Services.prefs.setBoolPref(COPY_URL_PREF, true);
  Services.prefs.setBoolPref(COPY_ALL_URLS_PREF, true);
  await openAndCloseTabContextMenu(gBrowser.selectedTab);
  is(copyTabUrl.hidden, false, "Copy tab URL visible");
  is(copyAllTabUrls.hidden, false, "Copy all tab URLs visible");
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
  await openAndCloseTabContextMenu(gBrowser.selectedTab);
  is(duplicateTab.hidden, true, "Duplicate tab hidden");
  // Should fall back to default value of true, i.e. element showing
  Services.prefs.clearUserPref(DUPLICATE_TAB_PREF);
  // Ensure showing
  await openAndCloseTabContextMenu(gBrowser.selectedTab);
  is(duplicateTab.hidden, false, "Duplicate tab showing");
});

add_task(async function testRestartItem() {
  // Make sure element is present
  let restartBrowserMenu = document.getElementById("app_restartBrowser");
  let restartBrowserApp = document.getElementById("appMenu-restart-button");
  if (OS == "macosx") {
    ok(restartBrowserMenu, "Restart browser menu bar item is included");
    is(restartBrowserApp, null, "Restart browser appMenu item not included");
    await openAndCloseFileMenu();
    is(
      restartBrowserMenu.hidden,
      false,
      "Restart browser menu bar item is visible"
    );
  } else {
    is(
      restartBrowserMenu,
      null,
      "Restart browser menu bar item is not included"
    );
    ok(restartBrowserApp, "Restart browser appMenu item included");
  }
  // Make sure element is hidden
  Services.prefs.setBoolPref(RESTART_PREF, false);
  if (OS == "macosx") {
    await openAndCloseFileMenu();
    is(
      restartBrowserMenu.hidden,
      true,
      "Restart browser menu bar item is hidden"
    );
  }
  Services.prefs.clearUserPref(RESTART_PREF);
  // TODO: Make sure functionality works
  // TODO: Test requireconfirm pops up confirmation window
  // TODO: Test purgecache clears cache
});

add_task(async function testMoveTabBar() {
  // Test default (topabove)
  let el = document.querySelector("#TabsToolbar");
  let bottomBox = document.querySelector("#browser-bottombox");
  is(el.parentElement.id, "titlebar", "Tab toolbar is below menu bar");
  // Test topbelow
  Services.prefs.setCharPref(TABBAR_POSITION_PREF, "topbelow");
  is(el.parentElement.id, "navigator-toolbox", "Tabs toolbar is below nav bar");
  // Test bottom above
  Services.prefs.setCharPref(TABBAR_POSITION_PREF, "bottomabove");
  is(el.parentElement.id, "browser-bottombox", "Tabs toolbar is in bottom box");
  is(
    bottomBox.firstChild.id,
    "TabsToolbar",
    "Tabs toolbar is first element in bottom box"
  );
  // Test bottom below (reliance upon StatusBar.jsm)
  Services.prefs.setCharPref(TABBAR_POSITION_PREF, "bottombelow");
  is(el.parentElement.id, "browser-bottombox", "Tabs toolbar is in bottom box");
  is(
    bottomBox.firstChild.id,
    "status-bar",
    "Tabs toolbar is not first element in bottom box"
  );
  // Clear pref
  Services.prefs.clearUserPref(TABBAR_POSITION_PREF);
});

add_task(async function testMoveBookmarksBar() {
  // Test default (top)
  let el = document.querySelector("#PersonalToolbar");
  is(
    el.parentElement.id,
    "navigator-toolbox",
    "Bookmarks bar is below nav bar"
  );
  // Test bottom
  Services.prefs.setCharPref(BOOKMARKBAR_POSITION_PREF, "bottom");
  is(
    el.parentElement.id,
    "browser-bottombox",
    "Bookmarks bar is in bottom box"
  );
  // Test bottom buttons not disabled
  // Test bottom context menu item still visible
  // Clear pref
  Services.prefs.clearUserPref(BOOKMARKBAR_POSITION_PREF);
});

add_task(async function testWindowButtons() {
  // Test menu bar visible and tabs in default position
  // Test menu bar visible and tabs not in default position
  // Test menu bar hidden and tabs in default position
  // Test menu bar hidden and tabs not in default position
});

add_task(async function testSecondWindow() {
  // Change all prefs to non default values
  // Open new browser window
  // Test all cases reflected in new window
});
