// Test elements exist in correct locations
add_task(async function testButtonsExist() {
  let b1 = document.getElementById("openAllPrivate");
  ok(b1, "Multiple bookmark context menu item added.");
  let b2 = document.getElementById("openAllLinksPrivate");
  ok(b2, "Multiple link context menu item added.");
  let b3 = document.getElementById("openPrivate");
  ok(b3, "New private tab item added.");
  let b4 = document.getElementById("menu_newPrivateTab");
  ok(b4, "Menu item added.");
  let b5 = document.getElementById("openLinkInPrivateTab");
  ok(b5, "Link context menu item added.");
  let b6 = document.getElementById("newPrivateTab-button");
  ok(b6, "Toolbar button added.");
  let b7 = document.getElementById("toggleTabPrivateState");
  ok(b7, "Tab context menu item added.");
});

// Test container exists
add_task(async function testContainer() {
  ContextualIdentityService.ensureDataReady();
  let container = ContextualIdentityService._identities.find(
    c => c.name == "Private"
  );
  ok(container, "Found Private container.");
});

// Test clicking context menu item changes userContextId to match private container
add_task(async function testTogglePrivateTab() {
  await BrowserTestUtils.openNewForegroundTab(gBrowser);
  let tab = gBrowser.selectedTab;
  is(tab.userContextId, 0, "Tab is not private");
  await openTabContextMenu(tab);
  let openPrivate = document.getElementById("toggleTabPrivateState");
  openPrivate.click();
  tab = gBrowser.selectedTab;
  is(
    tab.userContextId,
    window.PrivateTab.container.userContextId,
    "Tab is private"
  );

  BrowserTestUtils.removeTab(tab);
});
