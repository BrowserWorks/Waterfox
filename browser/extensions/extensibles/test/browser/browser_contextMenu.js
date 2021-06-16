/* global COPY_TAB_PREF COPY_ALL_TABS_PREF */

"use strict";

add_task(async function test_addContextItems() {
  // get elements
  let copyTab = document.getElementById("context_copyCurrentTabUrl");
  let copyAllTabs = document.getElementById("context_copyAllTabUrls");
  // check that elements have been created
  ok(copyTab, "Check copy current tab url menu item added.");
  ok(copyAllTabs, "Check copy all tab urls menu item added.");
  // check that adjusting pref adjusts their state to be hidden
  var oldCopyTabPref = SpecialPowers.getBoolPref(COPY_TAB_PREF);
  var oldCopyAllPref = SpecialPowers.getBoolPref(COPY_ALL_TABS_PREF);
  SpecialPowers.setBoolPref(COPY_TAB_PREF, false);
  SpecialPowers.setBoolPref(COPY_ALL_TABS_PREF, false);
  ok(
    BrowserTestUtils.is_hidden(copyTab),
    "Check setting copy tab url pref to be hidden hides menu item."
  );
  ok(
    BrowserTestUtils.is_hidden(copyAllTabs),
    "Check setting copy all tab urls pref to be hidden hides menu item."
  );
  // check that reverting pref adjust their state again
  SpecialPowers.setBoolPref(COPY_TAB_PREF, true);
  SpecialPowers.setBoolPref(COPY_ALL_TABS_PREF, true);
  ok(
    BrowserTestUtils.is_visible(copyTab),
    "Check setting copy tab url pref to be visible shows menu item."
  );
  ok(
    BrowserTestUtils.is_visible(copyAllTabs),
    "Check setting copy all tab urls pref to be visible shows menu item."
  );
  // reset prefs
  SpecialPowers.setBoolPref(COPY_TAB_PREF, oldCopyTabPref);
  SpecialPowers.setBoolPref(COPY_ALL_TABS_PREF, oldCopyAllPref);
  // check that if a new window is opened, the elements are added there as well
  let newWin = await BrowserTestUtils.openNewBrowserWindow();
  let newDoc = newWin.document;
  let newCopyTab = newDoc.getElementById("context_copyCurrentTabUrl");
  let newCopyAllTabs = newDoc.getElementById("context_copyAllTabUrls");
  ok(newCopyTab, "Check copy current tab url menu item added.");
  ok(newCopyAllTabs, "Check copy all tab urls menu item added.");
  // check that correct label text is pulled from l10n files
  is(copyTab.label, "Copy Tab URL", "Check copy current tab url label loaded.");
  is(
    copyAllTabs.label,
    "Copy All Tab URLs",
    "Check copy all tab urls label loaded."
  );
  await BrowserTestUtils.closeWindow(newWin);
});
