add_task(async function() {
  is(gBrowser.tabs.length, 1, "one tab is open");

  gBrowser.selectedBrowser.focus();
  isnot(document.activeElement, gURLBar.inputField, "location bar is not focused");

  var tab = gBrowser.selectedTab;
  gPrefService.setBoolPref("browser.tabs.closeWindowWithLastTab", false);

  let tabClosedPromise = BrowserTestUtils.tabRemoved(tab);
  EventUtils.synthesizeKey("w", { accelKey: true });
  await tabClosedPromise;

  is(tab.parentNode, null, "ctrl+w removes the tab");
  is(gBrowser.tabs.length, 1, "a new tab has been opened");
  is(document.activeElement, gURLBar.inputField, "location bar is focused for the new tab");

  if (gPrefService.prefHasUserValue("browser.tabs.closeWindowWithLastTab"))
    gPrefService.clearUserPref("browser.tabs.closeWindowWithLastTab");
});
