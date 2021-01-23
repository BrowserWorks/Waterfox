var gTestRoot = getRootDirectory(gTestPath).replace(
  "chrome://mochitests/content/",
  "http://127.0.0.1:8888/"
);
var gTestBrowser = null;

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

  await promiseTabLoadEvent(
    gBrowser.selectedTab,
    gTestRoot + "plugin_both.html"
  );

  // Work around for delayed PluginBindingAttached
  await promiseUpdatePluginBindings(gTestBrowser);

  let popupNotification = PopupNotifications.getNotification(
    "click-to-play-plugins",
    gTestBrowser
  );
  ok(popupNotification, "should have a click-to-play notification");

  let pluginInfo = await promiseForPluginInfo("test");
  is(
    pluginInfo.pluginFallbackType,
    Ci.nsIObjectLoadingContent.PLUGIN_CLICK_TO_PLAY,
    "plugin should be click to play"
  );
  ok(!pluginInfo.activated, "plugin should not be activated");

  await SpecialPowers.spawn(gTestBrowser, [], () => {
    let unknown = content.document.getElementById("unknown");
    ok(unknown, "should have unknown plugin in page");
  });
});
