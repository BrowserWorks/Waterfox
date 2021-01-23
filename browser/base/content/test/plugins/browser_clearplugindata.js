var gTestRoot = getRootDirectory(gTestPath).replace(
  "chrome://mochitests/content/",
  "http://127.0.0.1:8888/"
);
var gPluginHost = Cc["@mozilla.org/plugin/host;1"].getService(Ci.nsIPluginHost);
var gTestBrowser = null;

// Test clearing plugin data using Sanitizer.jsm.
const testURL1 = gTestRoot + "browser_clearplugindata.html";
const testURL2 = gTestRoot + "browser_clearplugindata_noage.html";

const { Sanitizer } = ChromeUtils.import("resource:///modules/Sanitizer.jsm");

const pluginHostIface = Ci.nsIPluginHost;
var pluginHost = Cc["@mozilla.org/plugin/host;1"].getService(Ci.nsIPluginHost);
pluginHost.QueryInterface(pluginHostIface);

var pluginTag = getTestPlugin();

function stored(needles) {
  let something = pluginHost.siteHasData(this.pluginTag, null);
  if (!needles) {
    return something;
  }

  if (!something) {
    return false;
  }

  for (let i = 0; i < needles.length; ++i) {
    if (!pluginHost.siteHasData(this.pluginTag, needles[i])) {
      return false;
    }
  }
  return true;
}

add_task(async function() {
  registerCleanupFunction(function() {
    clearAllPluginPermissions();
    Services.prefs.clearUserPref("extensions.blocklist.suppressUI");
    setTestPluginEnabledState(Ci.nsIPluginTag.STATE_ENABLED, "Test Plug-in");
    setTestPluginEnabledState(
      Ci.nsIPluginTag.STATE_ENABLED,
      "Second Test Plug-in"
    );
    if (gTestBrowser) {
      gBrowser.removeCurrentTab();
    }
    window.focus();
    gTestBrowser = null;
  });

  setTestPluginEnabledState(Ci.nsIPluginTag.STATE_ENABLED, "Test Plug-in");
  setTestPluginEnabledState(
    Ci.nsIPluginTag.STATE_ENABLED,
    "Second Test Plug-in"
  );
});

function setPrefs(cookies, pluginData) {
  let itemPrefs = Services.prefs.getBranch("privacy.cpd.");
  itemPrefs.setBoolPref("history", false);
  itemPrefs.setBoolPref("downloads", false);
  itemPrefs.setBoolPref("cache", false);
  itemPrefs.setBoolPref("cookies", cookies);
  itemPrefs.setBoolPref("formdata", false);
  itemPrefs.setBoolPref("offlineApps", false);
  itemPrefs.setBoolPref("passwords", false);
  itemPrefs.setBoolPref("sessions", false);
  itemPrefs.setBoolPref("siteSettings", false);
  itemPrefs.setBoolPref("pluginData", pluginData);
}

async function testClearingData(url) {
  // Load page to set data for the plugin.
  gBrowser.selectedTab = BrowserTestUtils.addTab(gBrowser);
  gTestBrowser = gBrowser.selectedBrowser;

  await promiseTabLoadEvent(gBrowser.selectedTab, url);

  await promiseUpdatePluginBindings(gTestBrowser);

  ok(
    stored(["foo.com", "bar.com", "baz.com", "qux.com"]),
    "Data stored for sites"
  );

  // Clear 20 seconds ago.
  // In the case of testURL2 the plugin will throw
  // NS_ERROR_PLUGIN_TIME_RANGE_NOT_SUPPORTED, which should result in us
  // clearing all data regardless of age.
  let now_uSec = Date.now() * 1000;
  let range = [now_uSec - 20 * 1000000, now_uSec];
  await Sanitizer.sanitize(null, { range, ignoreTimespan: false });

  if (url == testURL1) {
    ok(stored(["bar.com", "qux.com"]), "Data stored for sites");
    ok(!stored(["foo.com"]), "Data cleared for foo.com");
    ok(!stored(["baz.com"]), "Data cleared for baz.com");

    // Clear everything.
    await Sanitizer.sanitize(null, { ignoreTimespan: false });
  }

  ok(!stored(null), "All data cleared");

  gBrowser.removeCurrentTab();
  gTestBrowser = null;
}

add_task(async function() {
  // Test when sanitizing cookies.
  await setPrefs(true, false);
  await testClearingData(testURL1);
  await testClearingData(testURL2);

  // Test when sanitizing pluginData.
  await setPrefs(false, true);
  await testClearingData(testURL1);
  await testClearingData(testURL2);
});
