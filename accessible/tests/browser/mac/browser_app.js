/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

/* import-globals-from ../../mochitest/role.js */
/* import-globals-from ../../mochitest/states.js */
loadScripts(
  { name: "role.js", dir: MOCHITESTS_DIR },
  { name: "states.js", dir: MOCHITESTS_DIR }
);

function getMacAccessible(accOrElmOrID) {
  return new Promise(resolve => {
    let intervalId = setInterval(() => {
      let acc = getAccessible(accOrElmOrID);
      if (acc) {
        clearInterval(intervalId);
        resolve(
          acc.nativeInterface.QueryInterface(Ci.nsIAccessibleMacInterface)
        );
      }
    }, 10);
  });
}

/**
 * Test browser tabs
 */
add_task(async () => {
  let newTabs = await Promise.all([
    BrowserTestUtils.openNewForegroundTab(
      gBrowser,
      "data:text/html,<title>Two</title>"
    ),
    BrowserTestUtils.openNewForegroundTab(
      gBrowser,
      "data:text/html,<title>Three</title>"
    ),
    BrowserTestUtils.openNewForegroundTab(
      gBrowser,
      "data:text/html,<title>Four</title>"
    ),
  ]);

  // Mochitests spawn with a tab, and we've opened 3 more for a total of 4 tabs
  is(gBrowser.tabs.length, 4, "We now have 4 open tabs");

  let tablist = await getMacAccessible("tabbrowser-tabs");
  is(
    tablist.getAttributeValue("AXRole"),
    "AXTabGroup",
    "Correct role for tablist"
  );

  let tabMacAccs = tablist.getAttributeValue("AXTabs");
  is(tabMacAccs.length, 4, "4 items in AXTabs");

  let selectedTabs = tablist.getAttributeValue("AXSelectedChildren");
  is(selectedTabs.length, 1, "one selected tab");

  let tab = selectedTabs[0];
  is(tab.getAttributeValue("AXRole"), "AXRadioButton", "Correct role for tab");
  is(
    tab.getAttributeValue("AXSubrole"),
    "AXTabButton",
    "Correct subrole for tab"
  );
  is(tab.getAttributeValue("AXTitle"), "Four", "Correct title for tab");

  let tabToSelect = tabMacAccs[2];
  is(
    tabToSelect.getAttributeValue("AXTitle"),
    "Three",
    "Correct title for tab"
  );

  let actions = tabToSelect.actionNames;
  ok(true, actions);
  ok(actions.includes("AXPress"), "Has switch action");

  // When tab is clicked selection of tab group changes,
  // and focus goes to the web area. Wait for both.
  let evt = Promise.all([
    waitForMacEvent("AXSelectedChildrenChanged"),
    waitForMacEvent(
      "AXFocusedUIElementChanged",
      iface => iface.getAttributeValue("AXRole") == "AXWebArea"
    ),
  ]);
  tabToSelect.performAction("AXPress");
  await evt;

  selectedTabs = tablist.getAttributeValue("AXSelectedChildren");
  is(selectedTabs.length, 1, "one selected tab");
  is(
    selectedTabs[0].getAttributeValue("AXTitle"),
    "Three",
    "Correct title for tab"
  );

  // Close all open tabs
  await Promise.all(newTabs.map(t => BrowserTestUtils.removeTab(t)));
});

/**
 * Test ignored invisible items in root
 */
add_task(async () => {
  await BrowserTestUtils.withNewTab(
    {
      gBrowser,
      url: "about:license",
    },
    async browser => {
      let root = await getMacAccessible(document);
      let rootChildCount = () => root.getAttributeValue("AXChildren").length;

      // With no popups, the root accessible has 5 visible children:
      // 1. Tab bar (#TabsToolbar)
      // 2. Navigation bar (#nav-bar)
      // 3. Content area (#tabbrowser-tabpanels)
      // 4. Some fullscreen pointer grabber (#fullscreen-and-pointerlock-wrapper)
      // 5. Accessibility announcements dialog (#a11y-announcement)
      is(rootChildCount(), 5, "Root with no popups has 5 children");

      // Open a context menu
      const menu = document.getElementById("contentAreaContextMenu");
      EventUtils.synthesizeMouseAtCenter(document.body, {
        type: "contextmenu",
      });
      await BrowserTestUtils.waitForPopupEvent(menu, "shown");

      // Now root has 6 children
      is(rootChildCount(), 6, "Root has 6 children");

      // Close context menu
      EventUtils.synthesizeKey("KEY_Escape");
      await BrowserTestUtils.waitForPopupEvent(menu, "hidden");

      // We're back to 5
      is(rootChildCount(), 5, "Root has 5 children");

      // Open site identity popup
      const identityPopup = document.getElementById("identity-popup");
      document.getElementById("identity-box").click();
      await BrowserTestUtils.waitForPopupEvent(identityPopup, "shown");

      // Now root has 6 children
      is(rootChildCount(), 6, "Root has 6 children");

      // Close popup
      EventUtils.synthesizeKey("KEY_Escape");
      await BrowserTestUtils.waitForPopupEvent(identityPopup, "hidden");

      // We're back to 5
      is(rootChildCount(), 5, "Root has 5 children");
    }
  );
});
