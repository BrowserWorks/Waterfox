var gTestRoot = getRootDirectory(gTestPath).replace(
  "chrome://mochitests/content/",
  "http://127.0.0.1:8888/"
);
var gTestBrowser = null;
var gWrapperClickCount = 0;

add_task(async function() {
  registerCleanupFunction(function() {
    clearAllPluginPermissions();
    setTestPluginEnabledState(Ci.nsIPluginTag.STATE_ENABLED, "Test Plug-in");
    setTestPluginEnabledState(
      Ci.nsIPluginTag.STATE_ENABLED,
      "Second Test Plug-in"
    );
    gBrowser.removeCurrentTab();
    window.focus();
    gTestBrowser = null;
  });
});

add_task(async function() {
  gBrowser.selectedTab = BrowserTestUtils.addTab(gBrowser);
  gTestBrowser = gBrowser.selectedBrowser;

  setTestPluginEnabledState(Ci.nsIPluginTag.STATE_CLICKTOPLAY, "Test Plug-in");

  let testRoot = getRootDirectory(gTestPath).replace(
    "chrome://mochitests/content/",
    "http://127.0.0.1:8888/"
  );
  await promiseTabLoadEvent(
    gBrowser.selectedTab,
    testRoot + "plugin_bug787619.html"
  );

  // Due to layout being async, "PluginBindAttached" may trigger later.
  // This forces a layout flush, thus triggering it, and schedules the
  // test so it is definitely executed afterwards.
  await promiseUpdatePluginBindings(gTestBrowser);

  // check plugin state
  let pluginInfo = await promiseForPluginInfo("plugin");
  ok(!pluginInfo.activated, "1a plugin should not be activated");

  // click the overlay to prompt
  let promise = promisePopupNotification("click-to-play-plugins");
  await SpecialPowers.spawn(gTestBrowser, [], async function() {
    let plugin = content.document.getElementById("plugin");
    let bounds = plugin.getBoundingClientRect();
    let left = (bounds.left + bounds.right) / 2;
    let top = (bounds.top + bounds.bottom) / 2;
    let utils = content.windowUtils;
    utils.sendMouseEvent("mousedown", left, top, 0, 1, 0, false, 0, 0);
    utils.sendMouseEvent("mouseup", left, top, 0, 1, 0, false, 0, 0);
  });
  await promise;

  // check plugin state
  pluginInfo = await promiseForPluginInfo("plugin");
  ok(!pluginInfo.activated, "1b plugin should not be activated");

  let condition = () =>
    !PopupNotifications.getNotification("click-to-play-plugins", gTestBrowser)
      .dismissed && PopupNotifications.panel.firstElementChild;
  await promiseForCondition(condition);
  PopupNotifications.panel.firstElementChild.button.click();

  // check plugin state
  pluginInfo = await promiseForPluginInfo("plugin");
  ok(pluginInfo.activated, "plugin should be activated");

  is(gWrapperClickCount, 0, "wrapper should not have received any clicks");
});
