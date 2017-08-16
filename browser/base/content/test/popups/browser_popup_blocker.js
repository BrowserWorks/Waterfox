/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

const baseURL = getRootDirectory(gTestPath).replace("chrome://mochitests/content", "http://example.com");

function clearAllPermissionsByPrefix(aPrefix) {
  let perms = Services.perms.enumerator;
  while (perms.hasMoreElements()) {
    let perm = perms.getNext();
    if (perm.type.startsWith(aPrefix)) {
      Services.perms.removePermission(perm);
    }
  }
}

add_task(async function test_opening_blocked_popups() {
  // Enable the popup blocker.
  await SpecialPowers.pushPrefEnv({set: [["dom.disable_open_during_load", true]]});

  // Open the test page.
  let tab = await BrowserTestUtils.openNewForegroundTab(gBrowser, baseURL + "popup_blocker.html");

  // Wait for the popup-blocked notification.
  let notification;
  await BrowserTestUtils.waitForCondition(() =>
    notification = gBrowser.getNotificationBox().getNotificationWithValue("popup-blocked"));

  // Show the menu.
  let popupShown = BrowserTestUtils.waitForEvent(window, "popupshown");
  let popupFilled = BrowserTestUtils.waitForMessage(gBrowser.selectedBrowser.messageManager,
                                                    "PopupBlocking:ReplyGetBlockedPopupList");
  notification.querySelector("button").doCommand();
  let popup_event = await popupShown;
  let menu = popup_event.target;
  is(menu.id, "blockedPopupOptions", "Blocked popup menu shown");

  await popupFilled;
  // The menu is filled on the same message that we waited for, so let's ensure that it
  // had a chance of running before this test code.
  await new Promise(resolve => executeSoon(resolve));

  // Check the menu contents.
  let sep = menu.querySelector("menuseparator");
  let popupCount = 0;
  for (let i = sep.nextElementSibling; i; i = i.nextElementSibling) {
    popupCount++;
  }
  is(popupCount, 2, "Two popups were blocked");

  // Pressing "allow" should open all blocked popups.
  let popupTabs = [];
  function onTabOpen(event) {
    popupTabs.push(event.target);
  }
  gBrowser.tabContainer.addEventListener("TabOpen", onTabOpen);

  // Press the button.
  let allow = menu.querySelector("[observes='blockedPopupAllowSite']");
  allow.doCommand();
  await BrowserTestUtils.waitForCondition(() =>
    popupTabs.length == 2 &&
    popupTabs.every(aTab => aTab.linkedBrowser.currentURI.spec != "about:blank"));

  gBrowser.tabContainer.removeEventListener("TabOpen", onTabOpen);

  is(popupTabs[0].linkedBrowser.currentURI.spec, "data:text/plain;charset=utf-8,a", "Popup a");
  is(popupTabs[1].linkedBrowser.currentURI.spec, "data:text/plain;charset=utf-8,b", "Popup b");

  // Clean up.
  gBrowser.removeTab(tab);
  for (let popup of popupTabs) {
    gBrowser.removeTab(popup);
  }
  clearAllPermissionsByPrefix("popup");
  // Ensure the menu closes.
  menu.hidePopup();
});

add_task(async function check_icon_hides() {
  // Enable the popup blocker.
  await SpecialPowers.pushPrefEnv({set: [["dom.disable_open_during_load", true]]});

  let tab = await BrowserTestUtils.openNewForegroundTab(gBrowser, baseURL + "popup_blocker.html");

  let button = document.getElementById("page-report-button");
  await BrowserTestUtils.waitForCondition(() =>
    gBrowser.getNotificationBox().getNotificationWithValue("popup-blocked"));
  ok(!button.hidden, "Button should be visible");

  let otherPageLoaded = BrowserTestUtils.browserLoaded(tab.linkedBrowser);
  openLinkIn(baseURL, "current", {});
  await otherPageLoaded;
  ok(button.hidden, "Button should have hidden again after another page loaded.");
  await BrowserTestUtils.removeTab(tab);
});
