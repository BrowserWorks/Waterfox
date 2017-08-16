/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
 */

// Tests various aspects of the details view

var gManagerWindow;
var gProvider;

function test() {
  waitForExplicitFinish();

  gProvider = new MockProvider();

  gProvider.createAddons([{
    id: "tabsettings@tests.mozilla.org",
    name: "Tab Settings",
    version: "1",
    optionsURL: CHROMEROOT + "addon_prefs.xul",
    optionsType: AddonManager.OPTIONS_TYPE_TAB
  }]);

  open_manager("addons://list/extension", function(aWindow) {
    gManagerWindow = aWindow;

    run_next_test();
  });
}

function end_test() {
  close_manager(gManagerWindow, function() {
    finish();
  });
}

add_test(function() {
  var addon = get_addon_element(gManagerWindow, "tabsettings@tests.mozilla.org");
  is(addon.mAddon.optionsType, AddonManager.OPTIONS_TYPE_TAB, "Options should be inline type");
  addon.parentNode.ensureElementIsVisible(addon);

  var button = gManagerWindow.document.getAnonymousElementByAttribute(addon, "anonid", "preferences-btn");
  is_element_visible(button, "Preferences button should be visible");

  EventUtils.synthesizeMouseAtCenter(button, { clickCount: 1 }, gManagerWindow);

  var browser = gBrowser.selectedBrowser;
  browser.addEventListener("DOMContentLoaded", function() {
    is(browser.currentURI.spec, addon.mAddon.optionsURL, "New tab should have loaded the options URL");
    browser.contentWindow.close();
    run_next_test();
  }, {once: true});
});
