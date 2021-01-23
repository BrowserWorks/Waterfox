var rootDir = getRootDirectory(gTestPath);
const gTestRoot = rootDir.replace(
  "chrome://mochitests/content/",
  "http://127.0.0.1:8888/"
);

add_task(async function() {
  registerCleanupFunction(function() {
    clearAllPluginPermissions();
    setTestPluginEnabledState(Ci.nsIPluginTag.STATE_ENABLED, "Test Plug-in");
    setTestPluginEnabledState(
      Ci.nsIPluginTag.STATE_ENABLED,
      "Second Test Plug-in"
    );
    Services.prefs.clearUserPref("extensions.blocklist.suppressUI");
    gBrowser.removeCurrentTab();
    window.focus();
  });
});

add_task(async function() {
  Services.prefs.setBoolPref("extensions.blocklist.suppressUI", true);

  gBrowser.selectedTab = BrowserTestUtils.addTab(gBrowser);

  setTestPluginEnabledState(Ci.nsIPluginTag.STATE_CLICKTOPLAY, "Test Plug-in");

  await promiseTabLoadEvent(
    gBrowser.selectedTab,
    gTestRoot + "plugin_iframe.html"
  );

  // Tests that the overlays are visible and actionable if the plugin is in an iframe.

  await SpecialPowers.spawn(gBrowser.selectedBrowser, [], async function() {
    let frame = content.document.getElementById("frame");
    let doc = frame.contentDocument;
    let plugin = doc.getElementById("test");
    await ContentTaskUtils.waitForCondition(
      () => plugin.openOrClosedShadowRoot?.getElementById("main"),
      "Wait for plugin shadow root"
    );
    let overlay = plugin.openOrClosedShadowRoot.getElementById("main");
    Assert.ok(
      plugin && overlay.classList.contains("visible"),
      "Test 1, Plugin overlay should exist, not be hidden"
    );

    let closeIcon = plugin.openOrClosedShadowRoot.getElementById("closeIcon");
    let bounds = closeIcon.getBoundingClientRect();
    let left = (bounds.left + bounds.right) / 2;
    let top = (bounds.top + bounds.bottom) / 2;
    let utils = doc.defaultView.windowUtils;
    utils.sendMouseEvent("mousedown", left, top, 0, 1, 0, false, 0, 0);
    utils.sendMouseEvent("mouseup", left, top, 0, 1, 0, false, 0, 0);
    Assert.ok(
      !overlay.classList.contains("visible"),
      "Test 1, Plugin overlay should exist, be hidden"
    );
  });
});
