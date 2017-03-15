var gTestRoot = getRootDirectory(gTestPath).replace("chrome://mochitests/content/", "http://127.0.0.1:8888/");
var gTestBrowser = null;
var gConsoleErrors = 0;

var Cc = Components.classes;
var Ci = Components.interfaces;

add_task(function* () {
  registerCleanupFunction(function () {
    clearAllPluginPermissions();
    setTestPluginEnabledState(Ci.nsIPluginTag.STATE_ENABLED, "Test Plug-in");
    setTestPluginEnabledState(Ci.nsIPluginTag.STATE_ENABLED, "Second Test Plug-in");
    consoleService.unregisterListener(errorListener);
    gBrowser.removeCurrentTab();
    window.focus();
    gTestBrowser = null;
  });

  gBrowser.selectedTab = gBrowser.addTab();
  gTestBrowser = gBrowser.selectedBrowser;

  let consoleService = Cc["@mozilla.org/consoleservice;1"]
                         .getService(Ci.nsIConsoleService);
  let errorListener = {
    observe: function(aMessage) {
      if (aMessage.message.includes("NS_ERROR_FAILURE"))
        gConsoleErrors++;
    }
  };
  consoleService.registerListener(errorListener);

  yield promiseTabLoadEvent(gBrowser.selectedTab, gTestRoot + "plugin_bug797677.html");

  let pluginInfo = yield promiseForPluginInfo("plugin");
  is(pluginInfo.pluginFallbackType, Ci.nsIObjectLoadingContent.PLUGIN_UNSUPPORTED, "plugin should not have been found.");

  // simple cpows
  yield ContentTask.spawn(gTestBrowser, null, function() {
    let plugin = content.document.getElementById("plugin");
    ok(plugin, "plugin should be in the page");
  });
  is(gConsoleErrors, 0, "should have no console errors");
});
