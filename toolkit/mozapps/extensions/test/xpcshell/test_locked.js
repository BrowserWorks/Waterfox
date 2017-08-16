/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
 */

// Checks that we rebuild something sensible from a corrupt database

Components.utils.import("resource://testing-common/httpd.js");
Components.utils.import("resource://gre/modules/osfile.jsm");

var testserver = new HttpServer();
testserver.start(-1);
gPort = testserver.identity.primaryPort;
mapFile("/data/test_corrupt.rdf", testserver);
testserver.registerDirectory("/addons/", do_get_file("addons"));

// The test extension uses an insecure update url.
Services.prefs.setBoolPref(PREF_EM_CHECK_UPDATE_SECURITY, false);
Services.prefs.setBoolPref(PREF_EM_STRICT_COMPATIBILITY, false);

// Will be enabled
var addon1 = {
  id: "addon1@tests.mozilla.org",
  version: "1.0",
  name: "Test 1",
  targetApplications: [{
    id: "xpcshell@tests.mozilla.org",
    minVersion: "2",
    maxVersion: "2"
  }]
};

// Will be disabled
var addon2 = {
  id: "addon2@tests.mozilla.org",
  version: "1.0",
  name: "Test 2",
  targetApplications: [{
    id: "xpcshell@tests.mozilla.org",
    minVersion: "2",
    maxVersion: "2"
  }]
};

// Will get a compatibility update and stay enabled
var addon3 = {
  id: "addon3@tests.mozilla.org",
  version: "1.0",
  name: "Test 3",
  updateURL: "http://localhost:" + gPort + "/data/test_corrupt.rdf",
  targetApplications: [{
    id: "xpcshell@tests.mozilla.org",
    minVersion: "1",
    maxVersion: "1"
  }]
};

// Will get a compatibility update and be enabled
var addon4 = {
  id: "addon4@tests.mozilla.org",
  version: "1.0",
  name: "Test 4",
  updateURL: "http://localhost:" + gPort + "/data/test_corrupt.rdf",
  targetApplications: [{
    id: "xpcshell@tests.mozilla.org",
    minVersion: "1",
    maxVersion: "1"
  }]
};

// Would stay incompatible with strict compat
var addon5 = {
  id: "addon5@tests.mozilla.org",
  version: "1.0",
  name: "Test 5",
  targetApplications: [{
    id: "xpcshell@tests.mozilla.org",
    minVersion: "1",
    maxVersion: "1"
  }]
};

// Enabled bootstrapped
var addon6 = {
  id: "addon6@tests.mozilla.org",
  version: "1.0",
  name: "Test 6",
  bootstrap: "true",
  targetApplications: [{
    id: "xpcshell@tests.mozilla.org",
    minVersion: "2",
    maxVersion: "2"
  }]
};

// Disabled bootstrapped
var addon7 = {
  id: "addon7@tests.mozilla.org",
  version: "1.0",
  name: "Test 7",
  bootstrap: "true",
  targetApplications: [{
    id: "xpcshell@tests.mozilla.org",
    minVersion: "2",
    maxVersion: "2"
  }]
};

// The default theme
var theme1 = {
  id: "theme1@tests.mozilla.org",
  version: "1.0",
  name: "Theme 1",
  internalName: "classic/1.0",
  targetApplications: [{
    id: "xpcshell@tests.mozilla.org",
    minVersion: "2",
    maxVersion: "2"
  }]
};

// The selected theme
var theme2 = {
  id: "theme2@tests.mozilla.org",
  version: "1.0",
  name: "Theme 2",
  internalName: "test/1.0",
  targetApplications: [{
    id: "xpcshell@tests.mozilla.org",
    minVersion: "2",
    maxVersion: "2"
  }]
};

const profileDir = gProfD.clone();
profileDir.append("extensions");

add_task(async function init() {
  createAppInfo("xpcshell@tests.mozilla.org", "XPCShell", "2", "2");

  writeInstallRDFForExtension(addon1, profileDir);
  writeInstallRDFForExtension(addon2, profileDir);
  writeInstallRDFForExtension(addon3, profileDir);
  writeInstallRDFForExtension(addon4, profileDir);
  writeInstallRDFForExtension(addon5, profileDir);
  writeInstallRDFForExtension(addon6, profileDir);
  writeInstallRDFForExtension(addon7, profileDir);
  writeInstallRDFForExtension(theme1, profileDir);
  writeInstallRDFForExtension(theme2, profileDir);

  // Startup the profile and setup the initial state
  startupManager();

  // New profile so new add-ons are ignored
  check_startup_changes(AddonManager.STARTUP_CHANGE_INSTALLED, []);

  let [a2, a3, a4, a7, t2] =
    await promiseAddonsByIDs(["addon2@tests.mozilla.org",
                               "addon3@tests.mozilla.org",
                               "addon4@tests.mozilla.org",
                               "addon7@tests.mozilla.org",
                               "theme2@tests.mozilla.org"]);
  await new Promise(resolve => {
    // Set up the initial state
    a2.userDisabled = true;
    a4.userDisabled = true;
    a7.userDisabled = true;
    t2.userDisabled = false;
    a3.findUpdates({
      onUpdateFinished() {
        a4.findUpdates({
          onUpdateFinished() {
            // Let the updates finish before restarting the manager
            resolve();
          }
        }, AddonManager.UPDATE_WHEN_PERIODIC_UPDATE);
      }
    }, AddonManager.UPDATE_WHEN_PERIODIC_UPDATE);

  });
});


add_task(async function run_test_1() {
  restartManager();

  let [a1, a2, a3, a4, a5, a6, a7, t1, t2] =
    await promiseAddonsByIDs(["addon1@tests.mozilla.org",
                              "addon2@tests.mozilla.org",
                              "addon3@tests.mozilla.org",
                              "addon4@tests.mozilla.org",
                              "addon5@tests.mozilla.org",
                              "addon6@tests.mozilla.org",
                              "addon7@tests.mozilla.org",
                              "theme1@tests.mozilla.org",
                              "theme2@tests.mozilla.org"]);

  do_check_neq(a1, null);
  do_check_true(a1.isActive);
  do_check_false(a1.userDisabled);
  do_check_false(a1.appDisabled);
  do_check_eq(a1.pendingOperations, AddonManager.PENDING_NONE);
  do_check_true(isExtensionInAddonsList(profileDir, a1.id));

  do_check_neq(a2, null);
  do_check_false(a2.isActive);
  do_check_true(a2.userDisabled);
  do_check_false(a2.appDisabled);
  do_check_eq(a2.pendingOperations, AddonManager.PENDING_NONE);
  do_check_false(isExtensionInAddonsList(profileDir, a2.id));

  do_check_neq(a3, null);
  do_check_true(a3.isActive);
  do_check_false(a3.userDisabled);
  do_check_false(a3.appDisabled);
  do_check_eq(a3.pendingOperations, AddonManager.PENDING_NONE);
  do_check_true(isExtensionInAddonsList(profileDir, a3.id));

  do_check_neq(a4, null);
  do_check_false(a4.isActive);
  do_check_true(a4.userDisabled);
  do_check_false(a4.appDisabled);
  do_check_eq(a4.pendingOperations, AddonManager.PENDING_NONE);
  do_check_false(isExtensionInAddonsList(profileDir, a4.id));

  do_check_neq(a5, null);
  do_check_true(a5.isActive);
  do_check_false(a5.userDisabled);
  do_check_false(a5.appDisabled);
  do_check_eq(a5.pendingOperations, AddonManager.PENDING_NONE);
  do_check_true(isExtensionInAddonsList(profileDir, a5.id));

  do_check_neq(a6, null);
  do_check_true(a6.isActive);
  do_check_false(a6.userDisabled);
  do_check_false(a6.appDisabled);
  do_check_eq(a6.pendingOperations, AddonManager.PENDING_NONE);

  do_check_neq(a7, null);
  do_check_false(a7.isActive);
  do_check_true(a7.userDisabled);
  do_check_false(a7.appDisabled);
  do_check_eq(a7.pendingOperations, AddonManager.PENDING_NONE);

  do_check_neq(t1, null);
  do_check_false(t1.isActive);
  do_check_true(t1.userDisabled);
  do_check_false(t1.appDisabled);
  do_check_eq(t1.pendingOperations, AddonManager.PENDING_NONE);
  do_check_false(isThemeInAddonsList(profileDir, t1.id));

  do_check_neq(t2, null);
  do_check_true(t2.isActive);
  do_check_false(t2.userDisabled);
  do_check_false(t2.appDisabled);
  do_check_eq(t2.pendingOperations, AddonManager.PENDING_NONE);
  do_check_true(isThemeInAddonsList(profileDir, t2.id));

  // Open another handle on the JSON DB with as much Unix and Windows locking
  // as we can to simulate some other process interfering with it
  shutdownManager();
  do_print("Locking " + gExtensionsJSON.path);
  let options = {
    winShare: 0
  };
  if (OS.Constants.libc.O_EXLOCK)
    options.unixFlags = OS.Constants.libc.O_EXLOCK;

  let file = await OS.File.open(gExtensionsJSON.path, {read: true, write: true, existing: true}, options);

  let filePermissions = gExtensionsJSON.permissions;
  if (!OS.Constants.Win) {
    gExtensionsJSON.permissions = 0;
  }
  startupManager(false);

  // Shouldn't have seen any startup changes
  check_startup_changes(AddonManager.STARTUP_CHANGE_INSTALLED, []);

  // Accessing the add-ons should open and recover the database
  [a1, a2, a3, a4, a5, a6, a7, t1, t2] =
    await promiseAddonsByIDs(["addon1@tests.mozilla.org",
                              "addon2@tests.mozilla.org",
                              "addon3@tests.mozilla.org",
                              "addon4@tests.mozilla.org",
                              "addon5@tests.mozilla.org",
                              "addon6@tests.mozilla.org",
                              "addon7@tests.mozilla.org",
                              "theme1@tests.mozilla.org",
                              "theme2@tests.mozilla.org"]);

   // Should be correctly recovered
   do_check_neq(a1, null);
   do_check_true(a1.isActive);
   do_check_false(a1.userDisabled);
   do_check_false(a1.appDisabled);
   do_check_eq(a1.pendingOperations, AddonManager.PENDING_NONE);
   do_check_true(isExtensionInAddonsList(profileDir, a1.id));

   // Should be correctly recovered
   do_check_neq(a2, null);
   do_check_false(a2.isActive);
   do_check_true(a2.userDisabled);
   do_check_false(a2.appDisabled);
   do_check_eq(a2.pendingOperations, AddonManager.PENDING_NONE);
   do_check_false(isExtensionInAddonsList(profileDir, a2.id));

   // The compatibility update won't be recovered but it should still be
   // active for this session
   do_check_neq(a3, null);
   do_check_true(a3.isActive);
   do_check_false(a3.userDisabled);
   do_check_false(a3.appDisabled);
   do_check_eq(a3.pendingOperations, AddonManager.PENDING_NONE);
   do_check_true(isExtensionInAddonsList(profileDir, a3.id));

   // The compatibility update won't be recovered and with strict
   // compatibility it would not have been able to tell that it was
   // previously userDisabled. However, without strict compat, it wasn't
   // appDisabled, so it knows it must have been userDisabled.
   do_check_neq(a4, null);
   do_check_false(a4.isActive);
   do_check_true(a4.userDisabled);
   do_check_false(a4.appDisabled);
   do_check_eq(a4.pendingOperations, AddonManager.PENDING_NONE);
   do_check_false(isExtensionInAddonsList(profileDir, a4.id));

   do_check_neq(a5, null);
   do_check_true(a5.isActive);
   do_check_false(a5.userDisabled);
   do_check_false(a5.appDisabled);
   do_check_eq(a5.pendingOperations, AddonManager.PENDING_NONE);
   do_check_true(isExtensionInAddonsList(profileDir, a5.id));

   do_check_neq(a6, null);
   do_check_true(a6.isActive);
   do_check_false(a6.userDisabled);
   do_check_false(a6.appDisabled);
   do_check_eq(a6.pendingOperations, AddonManager.PENDING_NONE);

   do_check_neq(a7, null);
   do_check_false(a7.isActive);
   do_check_true(a7.userDisabled);
   do_check_false(a7.appDisabled);
   do_check_eq(a7.pendingOperations, AddonManager.PENDING_NONE);

   // Should be correctly recovered
   do_check_neq(t1, null);
   do_check_false(t1.isActive);
   do_check_true(t1.userDisabled);
   do_check_false(t1.appDisabled);
   do_check_eq(t1.pendingOperations, AddonManager.PENDING_NONE);
   do_check_false(isThemeInAddonsList(profileDir, t1.id));

   // Should be correctly recovered
   do_check_neq(t2, null);
   do_check_true(t2.isActive);
   do_check_false(t2.userDisabled);
   do_check_false(t2.appDisabled);
   do_check_eq(t2.pendingOperations, AddonManager.PENDING_NONE);
   do_check_true(isThemeInAddonsList(profileDir, t2.id));

   // Restarting will actually apply changes to extensions.ini which will
   // then be put into the in-memory database when we next fail to load the
   // real thing
   try {
     shutdownManager();
   } catch (e) {
     // We're expecting an error here.
   }
   startupManager(false);

   // Shouldn't have seen any startup changes
   check_startup_changes(AddonManager.STARTUP_CHANGE_INSTALLED, []);

   [a1, a2, a3, a4, a5, a6, a7, t1, t2] =
     await promiseAddonsByIDs(["addon1@tests.mozilla.org",
                               "addon2@tests.mozilla.org",
                               "addon3@tests.mozilla.org",
                               "addon4@tests.mozilla.org",
                               "addon5@tests.mozilla.org",
                               "addon6@tests.mozilla.org",
                               "addon7@tests.mozilla.org",
                               "theme1@tests.mozilla.org",
                               "theme2@tests.mozilla.org"]);

   do_check_neq(a1, null);
   do_check_true(a1.isActive);
   do_check_false(a1.userDisabled);
   do_check_false(a1.appDisabled);
   do_check_eq(a1.pendingOperations, AddonManager.PENDING_NONE);
   do_check_true(isExtensionInAddonsList(profileDir, a1.id));

   do_check_neq(a2, null);
   do_check_false(a2.isActive);
   do_check_true(a2.userDisabled);
   do_check_false(a2.appDisabled);
   do_check_eq(a2.pendingOperations, AddonManager.PENDING_NONE);
   do_check_false(isExtensionInAddonsList(profileDir, a2.id));

   do_check_neq(a3, null);
   do_check_true(a3.isActive);
   do_check_false(a3.userDisabled);
   do_check_false(a3.appDisabled);
   do_check_eq(a3.pendingOperations, AddonManager.PENDING_NONE);
   do_check_true(isExtensionInAddonsList(profileDir, a3.id));

   do_check_neq(a4, null);
   do_check_false(a4.isActive);
   do_check_true(a4.userDisabled);
   do_check_false(a4.appDisabled);
   do_check_eq(a4.pendingOperations, AddonManager.PENDING_NONE);
   do_check_false(isExtensionInAddonsList(profileDir, a4.id));

   do_check_neq(a5, null);
   do_check_true(a5.isActive);
   do_check_false(a5.userDisabled);
   do_check_false(a5.appDisabled);
   do_check_eq(a5.pendingOperations, AddonManager.PENDING_NONE);
   do_check_true(isExtensionInAddonsList(profileDir, a5.id));

   do_check_neq(a6, null);
   do_check_true(a6.isActive);
   do_check_false(a6.userDisabled);
   do_check_false(a6.appDisabled);
   do_check_eq(a6.pendingOperations, AddonManager.PENDING_NONE);

   do_check_neq(a7, null);
   do_check_false(a7.isActive);
   do_check_true(a7.userDisabled);
   do_check_false(a7.appDisabled);
   do_check_eq(a7.pendingOperations, AddonManager.PENDING_NONE);

   do_check_neq(t1, null);
   do_check_false(t1.isActive);
   do_check_true(t1.userDisabled);
   do_check_false(t1.appDisabled);
   do_check_eq(t1.pendingOperations, AddonManager.PENDING_NONE);
   do_check_false(isThemeInAddonsList(profileDir, t1.id));

   do_check_neq(t2, null);
   do_check_true(t2.isActive);
   do_check_false(t2.userDisabled);
   do_check_false(t2.appDisabled);
   do_check_eq(t2.pendingOperations, AddonManager.PENDING_NONE);
   do_check_true(isThemeInAddonsList(profileDir, t2.id));

   // After allowing access to the original DB things should go back to as
   // they were previously
   try {
     shutdownManager();
   } catch (e) {
     // We're expecting an error here.
   }
   do_print("Unlocking " + gExtensionsJSON.path);
   await file.close();
   gExtensionsJSON.permissions = filePermissions;
   await promiseStartupManager();

   // Shouldn't have seen any startup changes
   check_startup_changes(AddonManager.STARTUP_CHANGE_INSTALLED, []);

   [a1, a2, a3, a4, a5, a6, a7, t1, t2] =
     await promiseAddonsByIDs(["addon1@tests.mozilla.org",
                               "addon2@tests.mozilla.org",
                               "addon3@tests.mozilla.org",
                               "addon4@tests.mozilla.org",
                               "addon5@tests.mozilla.org",
                               "addon6@tests.mozilla.org",
                               "addon7@tests.mozilla.org",
                               "theme1@tests.mozilla.org",
                               "theme2@tests.mozilla.org"]);

   do_check_neq(a1, null);
   do_check_true(a1.isActive);
   do_check_false(a1.userDisabled);
   do_check_false(a1.appDisabled);
   do_check_eq(a1.pendingOperations, AddonManager.PENDING_NONE);
   do_check_true(isExtensionInAddonsList(profileDir, a1.id));

   do_check_neq(a2, null);
   do_check_false(a2.isActive);
   do_check_true(a2.userDisabled);
   do_check_false(a2.appDisabled);
   do_check_eq(a2.pendingOperations, AddonManager.PENDING_NONE);
   do_check_false(isExtensionInAddonsList(profileDir, a2.id));

   do_check_neq(a3, null);
   do_check_true(a3.isActive);
   do_check_false(a3.userDisabled);
   do_check_false(a3.appDisabled);
   do_check_eq(a3.pendingOperations, AddonManager.PENDING_NONE);
   do_check_true(isExtensionInAddonsList(profileDir, a3.id));

   do_check_neq(a4, null);
   do_check_false(a4.isActive);
   do_check_true(a4.userDisabled);
   do_check_false(a4.appDisabled);
   do_check_eq(a4.pendingOperations, AddonManager.PENDING_NONE);
   do_check_false(isExtensionInAddonsList(profileDir, a4.id));

   do_check_neq(a5, null);
   do_check_true(a5.isActive);
   do_check_false(a5.userDisabled);
   do_check_false(a5.appDisabled);
   do_check_eq(a5.pendingOperations, AddonManager.PENDING_NONE);
   do_check_true(isExtensionInAddonsList(profileDir, a5.id));

   do_check_neq(a6, null);
   do_check_true(a6.isActive);
   do_check_false(a6.userDisabled);
   do_check_false(a6.appDisabled);
   do_check_eq(a6.pendingOperations, AddonManager.PENDING_NONE);

   do_check_neq(a7, null);
   do_check_false(a7.isActive);
   do_check_true(a7.userDisabled);
   do_check_false(a7.appDisabled);
   do_check_eq(a7.pendingOperations, AddonManager.PENDING_NONE);

   do_check_neq(t1, null);
   do_check_false(t1.isActive);
   do_check_true(t1.userDisabled);
   do_check_false(t1.appDisabled);
   do_check_eq(t1.pendingOperations, AddonManager.PENDING_NONE);
   do_check_false(isThemeInAddonsList(profileDir, t1.id));

   do_check_neq(t2, null);
   do_check_true(t2.isActive);
   do_check_false(t2.userDisabled);
   do_check_false(t2.appDisabled);
   do_check_eq(t2.pendingOperations, AddonManager.PENDING_NONE);
   do_check_true(isThemeInAddonsList(profileDir, t2.id));

   try {
     shutdownManager();
   } catch (e) {
     // We're expecting an error here.
   }
});


function run_test() {
 run_next_test();
}
