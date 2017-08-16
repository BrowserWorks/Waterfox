/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
 */

var { classes: Cc, interfaces: Ci } = Components;

// Test whether the blacklist succesfully adds and removes the prefs that store
// its decisions when the remote blacklist is changed.
// Uses test_gfxBlacklist.xml and test_gfxBlacklist2.xml

Components.utils.import("resource://testing-common/httpd.js");

var gTestserver = new HttpServer();
gTestserver.start(-1);
gPort = gTestserver.identity.primaryPort;
mapFile("/data/test_gfxBlacklist.xml", gTestserver);
mapFile("/data/test_gfxBlacklist2.xml", gTestserver);

function get_platform() {
  var xulRuntime = Components.classes["@mozilla.org/xre/app-info;1"]
                             .getService(Components.interfaces.nsIXULRuntime);
  return xulRuntime.OS;
}

function load_blocklist(file) {
  Services.prefs.setCharPref("extensions.blocklist.url", "http://localhost:" +
                             gPort + "/data/" + file);
  var blocklist = Cc["@mozilla.org/extensions/blocklist;1"].
                  getService(Ci.nsITimerCallback);
  blocklist.notify(null);
}

// Performs the initial setup
function run_test() {
  try {
    var gfxInfo = Cc["@mozilla.org/gfx/info;1"].getService(Ci.nsIGfxInfo);
  } catch (e) {
    do_test_finished();
    return;
  }

  // We can't do anything if we can't spoof the stuff we need.
  if (!(gfxInfo instanceof Ci.nsIGfxInfoDebug)) {
    do_test_finished();
    return;
  }

  gfxInfo.QueryInterface(Ci.nsIGfxInfoDebug);

  // Set the vendor/device ID, etc, to match the test file.
  switch (get_platform()) {
    case "WINNT":
      gfxInfo.spoofVendorID("0xabcd");
      gfxInfo.spoofDeviceID("0x1234");
      gfxInfo.spoofDriverVersion("8.52.322.2201");
      // Windows 7
      gfxInfo.spoofOSVersion(0x60001);
      break;
    case "Linux":
      gfxInfo.spoofVendorID("0xabcd");
      gfxInfo.spoofDeviceID("0x1234");
      break;
    case "Darwin":
      gfxInfo.spoofVendorID("0xabcd");
      gfxInfo.spoofDeviceID("0x1234");
      gfxInfo.spoofOSVersion(0x1090);
      break;
    case "Android":
      gfxInfo.spoofVendorID("abcd");
      gfxInfo.spoofDeviceID("asdf");
      gfxInfo.spoofDriverVersion("5");
      break;
  }

  createAppInfo("xpcshell@tests.mozilla.org", "XPCShell", "3", "8");
  startupManager();

  do_test_pending();

  function blacklistAdded(aSubject, aTopic, aData) {
    // If we wait until after we go through the event loop, gfxInfo is sure to
    // have processed the gfxItems event.
    do_execute_soon(ensureBlacklistSet);
  }
  function ensureBlacklistSet() {
    var status = gfxInfo.getFeatureStatus(Ci.nsIGfxInfo.FEATURE_DIRECT2D);
    do_check_eq(status, Ci.nsIGfxInfo.FEATURE_BLOCKED_DRIVER_VERSION);

    // Make sure unrelated features aren't affected
    status = gfxInfo.getFeatureStatus(Ci.nsIGfxInfo.FEATURE_DIRECT3D_9_LAYERS);
    do_check_eq(status, Ci.nsIGfxInfo.FEATURE_STATUS_OK);

    var prefs = Cc["@mozilla.org/preferences-service;1"].
          getService(Ci.nsIPrefBranch);
    do_check_eq(prefs.getIntPref("gfx.blacklist.direct2d"),
                Ci.nsIGfxInfo.FEATURE_BLOCKED_DRIVER_VERSION);

    Services.obs.removeObserver(blacklistAdded, "blocklist-data-gfxItems");
    Services.obs.addObserver(blacklistRemoved, "blocklist-data-gfxItems");
    load_blocklist("test_gfxBlacklist2.xml");
  }

  function blacklistRemoved(aSubject, aTopic, aData) {
    // If we wait until after we go through the event loop, gfxInfo is sure to
    // have processed the gfxItems event.
    do_execute_soon(ensureBlacklistUnset);
  }
  function ensureBlacklistUnset() {
    var status = gfxInfo.getFeatureStatus(Ci.nsIGfxInfo.FEATURE_DIRECT2D);
    do_check_eq(status, Ci.nsIGfxInfo.FEATURE_STATUS_OK);

    // Make sure unrelated features aren't affected
    status = gfxInfo.getFeatureStatus(Ci.nsIGfxInfo.FEATURE_DIRECT3D_9_LAYERS);
    do_check_eq(status, Ci.nsIGfxInfo.FEATURE_STATUS_OK);

    var prefs = Cc["@mozilla.org/preferences-service;1"].
          getService(Ci.nsIPrefBranch);
    var exists = false;
    try {
      prefs.getIntPref("gfx.blacklist.direct2d");
      exists = true;
    } catch (e) {}

    do_check_false(exists);

    gTestserver.stop(do_test_finished);
  }

  Services.obs.addObserver(blacklistAdded, "blocklist-data-gfxItems");
  load_blocklist("test_gfxBlacklist.xml");
}
