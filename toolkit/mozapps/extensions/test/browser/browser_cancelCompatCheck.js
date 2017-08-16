/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
 */

// Test that we can cancel the add-on compatibility check while it is
// in progress (bug 772484).
// Test framework copied from browser_bug557956.js

const URI_EXTENSION_UPDATE_DIALOG = "chrome://mozapps/content/extensions/update.xul";

const PREF_GETADDONS_BYIDS            = "extensions.getAddons.get.url";
const PREF_MIN_PLATFORM_COMPAT        = "extensions.minCompatiblePlatformVersion";
const PREF_METADATA_LASTUPDATE        = "extensions.getAddons.cache.lastUpdate";

var repo = {};
Components.utils.import("resource://gre/modules/addons/AddonRepository.jsm", repo);
Components.utils.import("resource://gre/modules/Promise.jsm", this);

/**
 * Test add-ons:
 *
 * Addon    minVersion   maxVersion   Notes
 * addon1   0            *
 * addon2   0            0
 * addon3   0            0
 * addon4   1            *
 * addon5   0            0            Made compatible by update check
 * addon6   0            0            Made compatible by update check
 * addon7   0            0            Has a broken update available
 * addon8   0            0            Has an update available
 * addon9   0            0            Has an update available
 * addon10  0            0            Made incompatible by override check
 */

// describe the addons
var ao1 = { file: "browser_bug557956_1", id: "bug557956-1@tests.mozilla.org"};
var ao2 = { file: "browser_bug557956_2", id: "bug557956-2@tests.mozilla.org"};
var ao3 = { file: "browser_bug557956_3", id: "bug557956-3@tests.mozilla.org"};
var ao4 = { file: "browser_bug557956_4", id: "bug557956-4@tests.mozilla.org"};
var ao5 = { file: "browser_bug557956_5", id: "bug557956-5@tests.mozilla.org"};
var ao6 = { file: "browser_bug557956_6", id: "bug557956-6@tests.mozilla.org"};
var ao7 = { file: "browser_bug557956_7", id: "bug557956-7@tests.mozilla.org"};
var ao8 = { file: "browser_bug557956_8_1", id: "bug557956-8@tests.mozilla.org"};
var ao9 = { file: "browser_bug557956_9_1", id: "bug557956-9@tests.mozilla.org"};
var ao10 = { file: "browser_bug557956_10", id: "bug557956-10@tests.mozilla.org"};

// Return a promise that resolves after the specified delay in MS
function delayMS(aDelay) {
  return new Promise(resolve => {
    setTimeout(resolve, aDelay);
  });
}

// Return a promise that resolves when the specified observer topic is notified
function promise_observer(aTopic) {
  return new Promise(resolve => {
    Services.obs.addObserver(function observe(aSubject, aObsTopic, aData) {
      Services.obs.removeObserver(arguments.callee, aObsTopic);
      resolve([aSubject, aData]);
    }, aTopic);
  });
}

// Install a set of addons using a bogus update URL so that we can force
// the compatibility update to happen later
// @param aUpdateURL The real update URL to use after the add-ons are installed
function promise_install_test_addons(aAddonList, aUpdateURL) {
  info("Starting add-on installs");
  return new Promise(resolve => {

    // Use a blank update URL
    Services.prefs.setCharPref(PREF_UPDATEURL, TESTROOT + "missing.rdf");

    let installPromises = Promise.all(
      aAddonList.map(addon => AddonManager.getInstallForURL(`${TESTROOT}addons/${addon.file}.xpi`,
                                                            null, "application/x-xpinstall")));

    installPromises.then(installs => {
      var listener = {
        installCount: 0,

        onInstallEnded() {
          this.installCount++;
          if (this.installCount == installs.length) {
            info("Done add-on installs");
            // Switch to the test update URL
            Services.prefs.setCharPref(PREF_UPDATEURL, aUpdateURL);
            resolve();
          }
        }
      };

      for (let install of installs) {
        install.addListener(listener);
        install.install();
      }
    });

  });
}

function promise_addons_by_ids(aAddonIDs) {
  info("promise_addons_by_ids " + aAddonIDs.toSource());
  return new Promise(resolve => {
    AddonManager.getAddonsByIDs(aAddonIDs, resolve);
  });
}

async function promise_uninstall_test_addons() {
  info("Starting add-on uninstalls");
  let addons = await promise_addons_by_ids([ao1.id, ao2.id, ao3.id, ao4.id, ao5.id,
                                            ao6.id, ao7.id, ao8.id, ao9.id, ao10.id]);
  await new Promise(resolve => {
    let uninstallCount = addons.length;
    let listener = {
      onUninstalled(aAddon) {
        if (aAddon) {
          info("Finished uninstalling " + aAddon.id);
        }
        if (--uninstallCount == 0) {
          info("Done add-on uninstalls");
          AddonManager.removeAddonListener(listener);
          resolve();
        }
      }};
    AddonManager.addAddonListener(listener);
    for (let addon of addons) {
      if (addon)
        addon.uninstall();
      else
        listener.onUninstalled(null);
    }
  });
}

// Returns promise{window}, resolves with a handle to the compatibility
// check window
function promise_open_compatibility_window(aInactiveAddonIds) {
  return new Promise(resolve => {
    // This will reset the longer timeout multiplier to 2 which will give each
    // test that calls open_compatibility_window a minimum of 60 seconds to
    // complete.
    requestLongerTimeout(2);

    var variant = Cc["@mozilla.org/variant;1"].
                  createInstance(Ci.nsIWritableVariant);
    variant.setFromVariant(aInactiveAddonIds);

    // Cannot be modal as we want to interract with it, shouldn't cause problems
    // with testing though.
    var features = "chrome,centerscreen,dialog,titlebar";
    var ww = Cc["@mozilla.org/embedcomp/window-watcher;1"].
             getService(Ci.nsIWindowWatcher);
    var win = ww.openWindow(null, URI_EXTENSION_UPDATE_DIALOG, "", features, variant);

    win.addEventListener("load", function() {
      function page_shown(aEvent) {
        if (aEvent.target.pageid)
          info("Page " + aEvent.target.pageid + " shown");
      }

      win.removeEventListener("load", arguments.callee);

      info("Compatibility dialog opened");

      win.addEventListener("pageshow", page_shown);
      win.addEventListener("unload", function() {
        win.removeEventListener("pageshow", page_shown);
        dump("Compatibility dialog closed\n");
      }, {once: true});

      resolve(win);
    });
  });
}

function promise_window_close(aWindow) {
  return new Promise(resolve => {
    aWindow.addEventListener("unload", function() {
      resolve(aWindow);
    }, {once: true});
  });
}

function promise_page(aWindow, aPageId) {
  return new Promise(resolve => {
    var page = aWindow.document.getElementById(aPageId);
    if (aWindow.document.getElementById("updateWizard").currentPage === page) {
      resolve(aWindow);
    } else {
      page.addEventListener("pageshow", function() {
        executeSoon(function() {
          resolve(aWindow);
        });
      }, {once: true});
    }
  });
}

// These add-ons became inactive during the upgrade
var inactiveAddonIds = [
  ao5.id,
  ao6.id,
  ao7.id,
  ao8.id,
  ao9.id
];

// Make sure the addons in the list are not installed
async function check_addons_uninstalled(aAddonList) {
  let foundList = await promise_addons_by_ids(aAddonList.map(a => a.id));
  for (let i = 0; i < aAddonList.length; i++) {
    ok(!foundList[i], "Addon " + aAddonList[i].id + " is not installed");
  }
  info("Add-on uninstall check complete");
  await true;
}

// Test what happens when the user cancels during AddonRepository.repopulateCache()
// Add-ons that have updates available should not update if they were disabled before
// For this test, addon8 became disabled during update and addon9 was previously disabled,
// so addon8 should update and addon9 should not
add_task(async function cancel_during_repopulate() {
  let a5, a8, a9, a10;

  Services.prefs.setBoolPref(PREF_STRICT_COMPAT, true);
  Services.prefs.setCharPref(PREF_MIN_PLATFORM_COMPAT, "0");
  Services.prefs.setCharPref(PREF_UPDATEURL, TESTROOT + "missing.rdf");

  let installsDone = promise_observer("TEST:all-updates-done");

  // Don't pull compatibility data during add-on install
  Services.prefs.setBoolPref(PREF_GETADDONS_CACHE_ENABLED, false);
  // Set up our test addons so that the server-side JS has a 500ms delay to make
  // sure we cancel the dialog before we get the data we want to refill our
  // AddonRepository cache
  let addonList = [ao5, ao8, ao9, ao10];
  await promise_install_test_addons(addonList,
                                    TESTROOT + "cancelCompatCheck.sjs?500");

  Services.prefs.setBoolPref(PREF_GETADDONS_CACHE_ENABLED, true);
  Services.prefs.setCharPref(PREF_GETADDONS_BYIDS, TESTROOT + "browser_bug557956.xml");

  [a5, a8, a9] = await promise_addons_by_ids([ao5.id, ao8.id, ao9.id]);
  ok(!a5.isCompatible, "addon5 should not be compatible");
  ok(!a8.isCompatible, "addon8 should not be compatible");
  ok(!a9.isCompatible, "addon9 should not be compatible");

  let compatWindow = await promise_open_compatibility_window([ao5.id, ao8.id]);
  var doc = compatWindow.document;
  await promise_page(compatWindow, "versioninfo");

  // Brief delay to let the update window finish requesting all add-ons and start
  // reloading the addon repository
  await delayMS(50);

  info("Cancel the compatibility check dialog");
  var button = doc.documentElement.getButton("cancel");
  EventUtils.synthesizeMouse(button, 2, 2, { }, compatWindow);

  info("Waiting for installs to complete");
  await installsDone;
  ok(!repo.AddonRepository.isSearching, "Background installs are done");

  // There should be no active updates
  let installs = await new Promise(resolve => {
    AddonManager.getAllInstalls(resolve);
  });
  is(installs.length, 0, "There should be no active installs after background installs are done");

  // addon8 should have updated in the background,
  // addon9 was listed as previously disabled so it should not have updated
  [a5, a8, a9, a10] = await promise_addons_by_ids([ao5.id, ao8.id, ao9.id, ao10.id]);
  ok(a5.isCompatible, "addon5 should be compatible");
  ok(a8.isCompatible, "addon8 should have been upgraded");
  ok(!a9.isCompatible, "addon9 should not have been upgraded");
  ok(!a10.isCompatible, "addon10 should not be compatible");

  info("Updates done");
  await promise_uninstall_test_addons();
  info("done uninstalling add-ons");
});

// User cancels after repopulateCache, while we're waiting for the addon.findUpdates()
// calls in gVersionInfoPage_onPageShow() to complete
// For this test, both addon8 and addon9 were disabled by this update, but addon8
// is set to not auto-update, so only addon9 should update in the background
add_task(async function cancel_during_findUpdates() {
  let a5, a8, a9;

  Services.prefs.setBoolPref(PREF_STRICT_COMPAT, true);
  Services.prefs.setCharPref(PREF_MIN_PLATFORM_COMPAT, "0");

  // Clear the AddonRepository-last-updated preference to ensure that it reloads
  Services.prefs.clearUserPref(PREF_METADATA_LASTUPDATE);
  let observeUpdateDone = promise_observer("TEST:addon-repository-data-updated");
  let installsDone = promise_observer("TEST:all-updates-done");

  // Don't pull compatibility data during add-on install
  Services.prefs.setBoolPref(PREF_GETADDONS_CACHE_ENABLED, false);
  // No delay on the .sjs this time because we want the cache to repopulate
  let addonList = [ao3, ao5, ao6, ao7, ao8, ao9];
  await promise_install_test_addons(addonList,
                                    TESTROOT + "cancelCompatCheck.sjs");

  [a8] = await promise_addons_by_ids([ao8.id]);
  a8.applyBackgroundUpdates = AddonManager.AUTOUPDATE_DISABLE;

  Services.prefs.setBoolPref(PREF_GETADDONS_CACHE_ENABLED, true);
  let compatWindow = await promise_open_compatibility_window(inactiveAddonIds);
  var doc = compatWindow.document;
  await promise_page(compatWindow, "versioninfo");

  info("Waiting for repository-data-updated");
  await observeUpdateDone;

  // Quick wait to make sure the findUpdates calls get queued
  await delayMS(5);

  info("Cancel the compatibility check dialog");
  var button = doc.documentElement.getButton("cancel");
  EventUtils.synthesizeMouse(button, 2, 2, { }, compatWindow);

  info("Waiting for installs to complete 2");
  await installsDone;
  ok(!repo.AddonRepository.isSearching, "Background installs are done 2");

  // addon8 should have updated in the background,
  // addon9 was listed as previously disabled so it should not have updated
  [a5, a8, a9] = await promise_addons_by_ids([ao5.id, ao8.id, ao9.id]);
  ok(a5.isCompatible, "addon5 should be compatible");
  ok(!a8.isCompatible, "addon8 should not have been upgraded");
  ok(a9.isCompatible, "addon9 should have been upgraded");

  let installs = await new Promise(resolve => {
    AddonManager.getAllInstalls(resolve);
  });
  is(installs.length, 0, "There should be no active installs after the dialog is cancelled 2");

  info("findUpdates done");
  await promise_uninstall_test_addons();
});

// Cancelling during the 'mismatch' screen allows add-ons that can auto-update
// to continue updating in the background and cancels any other updates
// Same conditions as the previous test - addon8 and addon9 have updates available,
// addon8 is set to not auto-update so only addon9 should become compatible
add_task(async function cancel_mismatch() {
  let a3, a5, a7, a8, a9;

  Services.prefs.setBoolPref(PREF_STRICT_COMPAT, true);
  Services.prefs.setCharPref(PREF_MIN_PLATFORM_COMPAT, "0");

  // Clear the AddonRepository-last-updated preference to ensure that it reloads
  Services.prefs.clearUserPref(PREF_METADATA_LASTUPDATE);
  let installsDone = promise_observer("TEST:all-updates-done");

  // Don't pull compatibility data during add-on install
  Services.prefs.setBoolPref(PREF_GETADDONS_CACHE_ENABLED, false);
  // No delay on the .sjs this time because we want the cache to repopulate
  let addonList = [ao3, ao5, ao6, ao7, ao8, ao9];
  await promise_install_test_addons(addonList,
                                    TESTROOT + "cancelCompatCheck.sjs");

  [a8] = await promise_addons_by_ids([ao8.id]);
  a8.applyBackgroundUpdates = AddonManager.AUTOUPDATE_DISABLE;

  // Check that the addons start out not compatible.
  [a3, a7, a8, a9] = await promise_addons_by_ids([ao3.id, ao7.id, ao8.id, ao9.id]);
  ok(!a3.isCompatible, "addon3 should not be compatible");
  ok(!a7.isCompatible, "addon7 should not be compatible");
  ok(!a8.isCompatible, "addon8 should not be compatible");
  ok(!a9.isCompatible, "addon9 should not be compatible");

  Services.prefs.setBoolPref(PREF_GETADDONS_CACHE_ENABLED, true);
  let compatWindow = await promise_open_compatibility_window(inactiveAddonIds);
  var doc = compatWindow.document;
  info("Wait for mismatch page");
  await promise_page(compatWindow, "mismatch");
  info("Click the Don't Check button");
  var button = doc.documentElement.getButton("cancel");
  EventUtils.synthesizeMouse(button, 2, 2, { }, compatWindow);

  await promise_window_close(compatWindow);
  info("Waiting for installs to complete in cancel_mismatch");
  await installsDone;

  // addon8 should not have updated in the background,
  // addon9 was listed as previously disabled so it should not have updated
  [a5, a8, a9] = await promise_addons_by_ids([ao5.id, ao8.id, ao9.id]);
  ok(a5.isCompatible, "addon5 should be compatible");
  ok(!a8.isCompatible, "addon8 should not have been upgraded");
  ok(a9.isCompatible, "addon9 should have been upgraded");

  // Make sure there are no pending addon installs
  let installs = await new Promise(resolve => {
    AddonManager.getAllInstalls(resolve);
  });
  ok(installs.length == 0, "No remaining add-on installs (" + installs.toSource() + ")");

  await promise_uninstall_test_addons();
  await check_addons_uninstalled(addonList);
});

// Cancelling during the 'mismatch' screen with only add-ons that have
// no updates available
add_task(async function cancel_mismatch_no_updates() {
  let a3, a5, a6

  Services.prefs.setBoolPref(PREF_STRICT_COMPAT, true);
  Services.prefs.setCharPref(PREF_MIN_PLATFORM_COMPAT, "0");

  // Don't pull compatibility data during add-on install
  Services.prefs.setBoolPref(PREF_GETADDONS_CACHE_ENABLED, false);
  // No delay on the .sjs this time because we want the cache to repopulate
  let addonList = [ao3, ao5, ao6];
  await promise_install_test_addons(addonList,
                                    TESTROOT + "cancelCompatCheck.sjs");

  // Check that the addons start out not compatible.
  [a3, a5, a6] = await promise_addons_by_ids([ao3.id, ao5.id, ao6.id]);
  ok(!a3.isCompatible, "addon3 should not be compatible");
  ok(!a5.isCompatible, "addon5 should not be compatible");
  ok(!a6.isCompatible, "addon6 should not be compatible");

  Services.prefs.setBoolPref(PREF_GETADDONS_CACHE_ENABLED, true);
  let compatWindow = await promise_open_compatibility_window([ao3.id, ao5.id, ao6.id]);
  var doc = compatWindow.document;
  info("Wait for mismatch page");
  await promise_page(compatWindow, "mismatch");
  info("Click the Don't Check button");
  var button = doc.documentElement.getButton("cancel");
  EventUtils.synthesizeMouse(button, 2, 2, { }, compatWindow);

  await promise_window_close(compatWindow);

  [a3, a5, a6] = await promise_addons_by_ids([ao3.id, ao5.id, ao6.id]);
  ok(!a3.isCompatible, "addon3 should not be compatible");
  ok(a5.isCompatible, "addon5 should have become compatible");
  ok(a6.isCompatible, "addon6 should have become compatible");

  // Make sure there are no pending addon installs
  let installs = await new Promise(resolve => {
    AddonManager.getAllInstalls(resolve);
  });
  ok(installs.length == 0, "No remaining add-on installs (" + installs.toSource() + ")");

  await promise_uninstall_test_addons();
  await check_addons_uninstalled(addonList);
});
