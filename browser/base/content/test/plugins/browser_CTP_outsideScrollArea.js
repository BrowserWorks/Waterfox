var rootDir = getRootDirectory(gTestPath);
const gTestRoot = rootDir.replace(
  "chrome://mochitests/content/",
  "http://127.0.0.1:8888/"
);
var gTestBrowser = null;
var gPluginHost = Cc["@mozilla.org/plugin/host;1"].getService(Ci.nsIPluginHost);

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
    gTestBrowser = null;
  });
});

add_task(async function() {
  Services.prefs.setBoolPref("extensions.blocklist.suppressUI", true);

  let newTab = BrowserTestUtils.addTab(gBrowser);
  gBrowser.selectedTab = newTab;
  gTestBrowser = gBrowser.selectedBrowser;

  setTestPluginEnabledState(Ci.nsIPluginTag.STATE_CLICKTOPLAY, "Test Plug-in");

  let popupNotification = PopupNotifications.getNotification(
    "click-to-play-plugins",
    gTestBrowser
  );
  ok(
    !popupNotification,
    "Test 1, Should not have a click-to-play notification"
  );
});

// Test that the click-to-play overlay is not hidden for elements
// partially or fully outside the viewport.

add_task(async function() {
  await promiseTabLoadEvent(
    gBrowser.selectedTab,
    gTestRoot + "plugin_outsideScrollArea.html"
  );

  await SpecialPowers.spawn(gTestBrowser, [], async function() {
    let doc = content.document;
    let p = doc.createElement("embed");

    p.setAttribute("id", "test");
    p.setAttribute("type", "application/x-test");
    p.style.left = "0";
    p.style.bottom = "200px";

    doc.getElementById("container").appendChild(p);
  });

  // Work around for delayed PluginBindingAttached
  await promiseUpdatePluginBindings(gTestBrowser);

  await promisePopupNotification("click-to-play-plugins");

  await SpecialPowers.spawn(gTestBrowser, [], async function() {
    let plugin = content.document.getElementById("test");
    let overlay = plugin.openOrClosedShadowRoot.getElementById("main");
    Assert.ok(
      overlay &&
        overlay.classList.contains("visible") &&
        overlay.getAttribute("sizing") != "blank",
      "Test 2, overlay should be visible."
    );
  });
});

add_task(async function() {
  await promiseTabLoadEvent(
    gBrowser.selectedTab,
    gTestRoot + "plugin_outsideScrollArea.html"
  );

  await SpecialPowers.spawn(gTestBrowser, [], async function() {
    let doc = content.document;
    let p = doc.createElement("embed");

    p.setAttribute("id", "test");
    p.setAttribute("type", "application/x-test");
    p.style.left = "0";
    p.style.bottom = "-410px";

    doc.getElementById("container").appendChild(p);
  });

  // Work around for delayed PluginBindingAttached
  await promiseUpdatePluginBindings(gTestBrowser);

  await promisePopupNotification("click-to-play-plugins");

  await SpecialPowers.spawn(gTestBrowser, [], async function() {
    let plugin = content.document.getElementById("test");
    let overlay = plugin.openOrClosedShadowRoot.getElementById("main");
    Assert.ok(
      overlay &&
        overlay.classList.contains("visible") &&
        overlay.getAttribute("sizing") != "blank",
      "Test 3, overlay should be visible."
    );
  });
});

add_task(async function() {
  await promiseTabLoadEvent(
    gBrowser.selectedTab,
    gTestRoot + "plugin_outsideScrollArea.html"
  );

  await SpecialPowers.spawn(gTestBrowser, [], async function() {
    let doc = content.document;
    let p = doc.createElement("embed");

    p.setAttribute("id", "test");
    p.setAttribute("type", "application/x-test");
    p.style.left = "-600px";
    p.style.bottom = "0";

    doc.getElementById("container").appendChild(p);
  });

  // Work around for delayed PluginBindingAttached
  await promiseUpdatePluginBindings(gTestBrowser);

  await promisePopupNotification("click-to-play-plugins");
  await SpecialPowers.spawn(gTestBrowser, [], async function() {
    let plugin = content.document.getElementById("test");
    let overlay = plugin.openOrClosedShadowRoot.getElementById("main");
    Assert.ok(
      !overlay || overlay.getAttribute("sizing") == "blank",
      "Test 4, overlay should be blank."
    );
  });
});
