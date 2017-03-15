const gHttpTestRoot = "http://127.0.0.1:8888/" + RELATIVE_DIR + "/";

function updateBlocklist(aCallback) {
  var blocklistNotifier = Cc["@mozilla.org/extensions/blocklist;1"]
                          .getService(Ci.nsITimerCallback);
  var observer = function() {
    Services.obs.removeObserver(observer, "blocklist-updated");
    SimpleTest.executeSoon(aCallback);
  };
  Services.obs.addObserver(observer, "blocklist-updated", false);
  blocklistNotifier.notify(null);
}

var _originalBlocklistURL = null;
function setAndUpdateBlocklist(aURL, aCallback) {
  if (!_originalBlocklistURL) {
    _originalBlocklistURL = Services.prefs.getCharPref("extensions.blocklist.url");
  }
  Services.prefs.setCharPref("extensions.blocklist.url", aURL);
  updateBlocklist(aCallback);
}

function resetBlocklist(aCallback) {
  Services.prefs.setCharPref("extensions.blocklist.url", _originalBlocklistURL);
}

add_task(function*() {
  SpecialPowers.pushPrefEnv({"set": [
    ["plugins.click_to_play", true],
    ["extensions.blocklist.suppressUI", true]
  ]});
  registerCleanupFunction(function*() {
    let pluginTag = getTestPluginTag();
    pluginTag.enabledState = Ci.nsIPluginTag.STATE_ENABLED;
    yield new Promise(resolve => {
      setAndUpdateBlocklist(gHttpTestRoot + "blockNoPlugins.xml", resolve);
    });
    resetBlocklist();
  });

  let pluginTag = getTestPluginTag();
  pluginTag.enabledState = Ci.nsIPluginTag.STATE_CLICKTOPLAY;
  let managerWindow = yield new Promise(resolve => open_manager("addons://list/plugin", resolve));

  let plugins = yield new Promise(resolve => AddonManager.getAddonsByTypes(["plugin"], resolve));

  let testPluginId;
  for (let plugin of plugins) {
    if (plugin.name == "Test Plug-in") {
      testPluginId = plugin.id;
      break;
    }
  }
  ok(testPluginId, "part2: Test Plug-in should exist");

  let testPlugin = yield new Promise(resolve => AddonManager.getAddonByID(testPluginId, resolve));

  let pluginEl = get_addon_element(managerWindow, testPluginId);
  pluginEl.parentNode.ensureElementIsVisible(pluginEl);
  let enableButton = managerWindow.document.getAnonymousElementByAttribute(pluginEl, "anonid", "enable-btn");
  is_element_hidden(enableButton, "part3: enable button should not be visible");
  let disableButton = managerWindow.document.getAnonymousElementByAttribute(pluginEl, "anonid", "enable-btn");
  is_element_hidden(disableButton, "part3: disable button should not be visible");
  let menu = managerWindow.document.getAnonymousElementByAttribute(pluginEl, "anonid", "state-menulist");
  is_element_visible(menu, "part3: state menu should be visible");
  let askToActivateItem = managerWindow.document.getAnonymousElementByAttribute(pluginEl, "anonid", "ask-to-activate-menuitem");
  is(menu.selectedItem, askToActivateItem, "part3: state menu should have 'Ask To Activate' selected");

  let pluginTab = yield BrowserTestUtils.openNewForegroundTab(gBrowser, gHttpTestRoot + "plugin_test.html");
  let pluginBrowser = pluginTab.linkedBrowser;

  let condition = () => PopupNotifications.getNotification("click-to-play-plugins", pluginBrowser);
  yield BrowserTestUtils.waitForCondition(condition, "part4: should have a click-to-play notification");

  yield BrowserTestUtils.removeTab(pluginTab);

  let alwaysActivateItem = managerWindow.document.getAnonymousElementByAttribute(pluginEl, "anonid", "always-activate-menuitem");
  menu.selectedItem = alwaysActivateItem;
  alwaysActivateItem.doCommand();

  pluginTab = yield BrowserTestUtils.openNewForegroundTab(gBrowser, gHttpTestRoot + "plugin_test.html");

  yield ContentTask.spawn(pluginTab.linkedBrowser, null, function*() {
    let testPlugin = content.document.getElementById("test");
    ok(testPlugin, "part5: should have a plugin element in the page");
    let objLoadingContent = testPlugin.QueryInterface(Ci.nsIObjectLoadingContent);
    let condition = () => objLoadingContent.activated;
    yield ContentTaskUtils.waitForCondition(condition, "part5: waited too long for plugin to activate");
    ok(objLoadingContent.activated, "part6: plugin should be activated");
  });

  yield BrowserTestUtils.removeTab(pluginTab);

  let neverActivateItem = managerWindow.document.getAnonymousElementByAttribute(pluginEl, "anonid", "never-activate-menuitem");
  menu.selectedItem = neverActivateItem;
  neverActivateItem.doCommand();

  pluginTab = yield BrowserTestUtils.openNewForegroundTab(gBrowser, gHttpTestRoot + "plugin_test.html");
  pluginBrowser = pluginTab.linkedBrowser;

  yield ContentTask.spawn(pluginTab.linkedBrowser, null, function*() {
    let testPlugin = content.document.getElementById("test");
    ok(testPlugin, "part7: should have a plugin element in the page");
    let objLoadingContent = testPlugin.QueryInterface(Ci.nsIObjectLoadingContent);
    ok(!objLoadingContent.activated, "part7: plugin should not be activated");
  });

  yield BrowserTestUtils.removeTab(pluginTab);

  let details = managerWindow.document.getAnonymousElementByAttribute(pluginEl, "anonid", "details-btn");
  is_element_visible(details, "part7: details link should be visible");
  EventUtils.synthesizeMouseAtCenter(details, {}, managerWindow);
  yield BrowserTestUtils.waitForEvent(managerWindow.document, "ViewChanged");

  is_element_hidden(enableButton, "part8: detail enable button should be hidden");
  is_element_hidden(disableButton, "part8: detail disable button should be hidden");
  is_element_visible(menu, "part8: detail state menu should be visible");
  is(menu.selectedItem, neverActivateItem, "part8: state menu should have 'Never Activate' selected");

  menu.selectedItem = alwaysActivateItem;
  alwaysActivateItem.doCommand();

  pluginTab = yield BrowserTestUtils.openNewForegroundTab(gBrowser, gHttpTestRoot + "plugin_test.html");
  pluginBrowser = pluginTab.linkedBrowser;

  yield ContentTask.spawn(pluginTab.linkedBrowser, null, function*() {
    let testPlugin = content.document.getElementById("test");
    ok(testPlugin, "part9: should have a plugin element in the page");
    let objLoadingContent = testPlugin.QueryInterface(Ci.nsIObjectLoadingContent);
    let condition = () => objLoadingContent.activated;
    yield ContentTaskUtils.waitForCondition(condition, "part9: waited too long for plugin to activate");
    ok(objLoadingContent.activated, "part10: plugin should be activated");
  });

  yield BrowserTestUtils.removeTab(pluginTab);

  menu.selectedItem = askToActivateItem;
  askToActivateItem.doCommand();

  pluginTab = yield BrowserTestUtils.openNewForegroundTab(gBrowser, gHttpTestRoot + "plugin_test.html");
  pluginBrowser = pluginTab.linkedBrowser;

  condition = () => PopupNotifications.getNotification("click-to-play-plugins", pluginBrowser);
  yield BrowserTestUtils.waitForCondition(condition, "part11: should have a click-to-play notification");

  yield BrowserTestUtils.removeTab(pluginTab);

  // causes appDisabled to be set
  managerWindow = yield new Promise(resolve => {
    setAndUpdateBlocklist(gHttpTestRoot + "blockPluginHard.xml",
      () => {
        close_manager(managerWindow, function() {
          open_manager("addons://list/plugin", resolve);
        });
      }
    );
  });

  pluginEl = get_addon_element(managerWindow, testPluginId);
  pluginEl.parentNode.ensureElementIsVisible(pluginEl);
  menu = managerWindow.document.getAnonymousElementByAttribute(pluginEl, "anonid", "state-menulist");
  is(menu.disabled, true, "part12: state menu should be disabled");

  details = managerWindow.document.getAnonymousElementByAttribute(pluginEl, "anonid", "details-btn");
  EventUtils.synthesizeMouseAtCenter(details, {}, managerWindow);
  yield BrowserTestUtils.waitForEvent(managerWindow.document, "ViewChanged");

  menu = managerWindow.document.getElementById("detail-state-menulist");
  is(menu.disabled, true, "part13: detail state menu should be disabled");

  managerWindow.close();
});
