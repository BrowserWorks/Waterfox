/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

Services.prefs.setBoolPref("browser.preferences.instantApply", true);

registerCleanupFunction(function() {
  Services.prefs.clearUserPref("browser.preferences.instantApply");
});

add_task(async function() {
  let prefs = await openPreferencesViaOpenPreferencesAPI("paneContent");
  is(prefs.selectedPane, "paneContent", "Content pane was selected");
  prefs = await openPreferencesViaOpenPreferencesAPI("advanced", "updateTab");
  is(prefs.selectedPane, "paneAdvanced", "Advanced pane was selected");
  is(prefs.selectedAdvancedTab, "updateTab", "The update tab within the advanced prefs should be selected");
  prefs = await openPreferencesViaHash("privacy");
  is(prefs.selectedPane, "panePrivacy", "Privacy pane is selected when hash is 'privacy'");
  prefs = await openPreferencesViaOpenPreferencesAPI("nonexistant-category");
  is(prefs.selectedPane, "paneGeneral", "General pane is selected by default when a nonexistant-category is requested");
  prefs = await openPreferencesViaHash("nonexistant-category");
  is(prefs.selectedPane, "paneGeneral", "General pane is selected when hash is a nonexistant-category");
  prefs = await openPreferencesViaHash();
  is(prefs.selectedPane, "paneGeneral", "General pane is selected by default");
});

function openPreferencesViaHash(aPane) {
  return new Promise(resolve => {
    gBrowser.selectedTab = BrowserTestUtils.addTab(gBrowser, "about:preferences" + (aPane ? "#" + aPane : ""));
    let newTabBrowser = gBrowser.selectedBrowser;

    newTabBrowser.addEventListener("Initialized", function() {
      newTabBrowser.contentWindow.addEventListener("load", function() {
        let win = gBrowser.contentWindow;
        let selectedPane = win.history.state;
        gBrowser.removeCurrentTab();
        resolve({selectedPane});
      }, {once: true});
    }, {capture: true, once: true});

  });
}
