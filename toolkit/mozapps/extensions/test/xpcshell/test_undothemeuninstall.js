/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
 */

// This verifies that forcing undo for uninstall works for themes
Components.utils.import("resource://gre/modules/LightweightThemeManager.jsm");

const PREF_GENERAL_SKINS_SELECTEDSKIN = "general.skins.selectedSkin";

var defaultTheme = {
  id: "default@tests.mozilla.org",
  version: "1.0",
  name: "Test 1",
  internalName: "classic/1.0",
  targetApplications: [{
    id: "xpcshell@tests.mozilla.org",
    minVersion: "1",
    maxVersion: "1"
  }]
};

var theme1 = {
  id: "theme1@tests.mozilla.org",
  version: "1.0",
  name: "Test 1",
  internalName: "theme1",
  targetApplications: [{
    id: "xpcshell@tests.mozilla.org",
    minVersion: "1",
    maxVersion: "1"
  }]
};

const profileDir = gProfD.clone();
profileDir.append("extensions");

// Sets up the profile by installing an add-on.
function run_test() {
  createAppInfo("xpcshell@tests.mozilla.org", "XPCShell", "1", "1.9.2");

  startupManager();
  do_register_cleanup(promiseShutdownManager);

  run_next_test();
}

add_task(async function checkDefault() {
  writeInstallRDFForExtension(defaultTheme, profileDir);
  await promiseRestartManager();

  let d = await promiseAddonByID("default@tests.mozilla.org");

  do_check_neq(d, null);
  do_check_true(d.isActive);
  do_check_false(d.userDisabled);
  do_check_eq(Services.prefs.getCharPref(PREF_GENERAL_SKINS_SELECTEDSKIN), "classic/1.0");
});

// Tests that uninstalling an enabled theme offers the option to undo
add_task(async function uninstallEnabledOffersUndo() {
  writeInstallRDFForExtension(theme1, profileDir);

  await promiseRestartManager();

  let t1 = await promiseAddonByID("theme1@tests.mozilla.org");

  do_check_neq(t1, null);
  do_check_true(t1.userDisabled);

  t1.userDisabled = false;

  await promiseRestartManager();

  let d = null;
  [ t1, d ] = await promiseAddonsByIDs(["theme1@tests.mozilla.org",
                                        "default@tests.mozilla.org"]);
  do_check_neq(d, null);
  do_check_false(d.isActive);
  do_check_true(d.userDisabled);
  do_check_eq(d.pendingOperations, AddonManager.PENDING_NONE);

  do_check_neq(t1, null);
  do_check_true(t1.isActive);
  do_check_false(t1.userDisabled);
  do_check_eq(t1.pendingOperations, AddonManager.PENDING_NONE);

  do_check_eq(Services.prefs.getCharPref(PREF_GENERAL_SKINS_SELECTEDSKIN), "theme1");

  prepare_test({
    "default@tests.mozilla.org": [
      "onEnabling"
    ],
    "theme1@tests.mozilla.org": [
      "onUninstalling"
    ]
  });
  t1.uninstall(true);
  ensure_test_completed();

  do_check_neq(d, null);
  do_check_false(d.isActive);
  do_check_false(d.userDisabled);
  do_check_eq(d.pendingOperations, AddonManager.PENDING_ENABLE);

  do_check_true(t1.isActive);
  do_check_false(t1.userDisabled);
  do_check_true(hasFlag(t1.pendingOperations, AddonManager.PENDING_UNINSTALL));

  do_check_eq(Services.prefs.getCharPref(PREF_GENERAL_SKINS_SELECTEDSKIN), "theme1");

  await promiseRestartManager();

  [ t1, d ] = await promiseAddonsByIDs(["theme1@tests.mozilla.org",
                                        "default@tests.mozilla.org"]);
  do_check_neq(d, null);
  do_check_true(d.isActive);
  do_check_false(d.userDisabled);
  do_check_eq(d.pendingOperations, AddonManager.PENDING_NONE);

  do_check_eq(t1, null);

  do_check_eq(Services.prefs.getCharPref(PREF_GENERAL_SKINS_SELECTEDSKIN), "classic/1.0");
});

// Tests that uninstalling an enabled theme can be undone
add_task(async function canUndoUninstallEnabled() {
  writeInstallRDFForExtension(theme1, profileDir);

  await promiseRestartManager();

  let t1 = await promiseAddonByID("theme1@tests.mozilla.org");

  do_check_neq(t1, null);
  do_check_true(t1.userDisabled);

  t1.userDisabled = false;

  await promiseRestartManager();

  let d = null;
  [ t1, d ] = await promiseAddonsByIDs(["theme1@tests.mozilla.org",
                                        "default@tests.mozilla.org"]);

  do_check_neq(d, null);
  do_check_false(d.isActive);
  do_check_true(d.userDisabled);
  do_check_eq(d.pendingOperations, AddonManager.PENDING_NONE);

  do_check_neq(t1, null);
  do_check_true(t1.isActive);
  do_check_false(t1.userDisabled);
  do_check_eq(t1.pendingOperations, AddonManager.PENDING_NONE);

  do_check_eq(Services.prefs.getCharPref(PREF_GENERAL_SKINS_SELECTEDSKIN), "theme1");

  prepare_test({
    "default@tests.mozilla.org": [
      "onEnabling"
    ],
    "theme1@tests.mozilla.org": [
      "onUninstalling"
    ]
  });
  t1.uninstall(true);
  ensure_test_completed();

  do_check_neq(d, null);
  do_check_false(d.isActive);
  do_check_false(d.userDisabled);
  do_check_eq(d.pendingOperations, AddonManager.PENDING_ENABLE);

  do_check_true(t1.isActive);
  do_check_false(t1.userDisabled);
  do_check_true(hasFlag(t1.pendingOperations, AddonManager.PENDING_UNINSTALL));

  do_check_eq(Services.prefs.getCharPref(PREF_GENERAL_SKINS_SELECTEDSKIN), "theme1");

  prepare_test({
    "default@tests.mozilla.org": [
      "onOperationCancelled"
    ],
    "theme1@tests.mozilla.org": [
      "onOperationCancelled"
    ]
  });
  t1.cancelUninstall();
  ensure_test_completed();

  do_check_neq(d, null);
  do_check_false(d.isActive);
  do_check_true(d.userDisabled);
  do_check_eq(d.pendingOperations, AddonManager.PENDING_NONE);

  do_check_neq(t1, null);
  do_check_true(t1.isActive);
  do_check_false(t1.userDisabled);
  do_check_eq(t1.pendingOperations, AddonManager.PENDING_NONE);

  await promiseRestartManager();

  [ t1, d ] = await promiseAddonsByIDs(["theme1@tests.mozilla.org",
                                        "default@tests.mozilla.org"]);

  do_check_neq(d, null);
  do_check_false(d.isActive);
  do_check_true(d.userDisabled);
  do_check_eq(d.pendingOperations, AddonManager.PENDING_NONE);

  do_check_neq(t1, null);
  do_check_true(t1.isActive);
  do_check_false(t1.userDisabled);
  do_check_eq(t1.pendingOperations, AddonManager.PENDING_NONE);

  do_check_eq(Services.prefs.getCharPref(PREF_GENERAL_SKINS_SELECTEDSKIN), "theme1");

  t1.uninstall();
  await promiseRestartManager();
});

// Tests that uninstalling a disabled theme offers the option to undo
add_task(async function uninstallDisabledOffersUndo() {
  writeInstallRDFForExtension(theme1, profileDir);

  await promiseRestartManager();

  let [ t1, d ] = await promiseAddonsByIDs(["theme1@tests.mozilla.org",
                                            "default@tests.mozilla.org"]);

  do_check_neq(d, null);
  do_check_true(d.isActive);
  do_check_false(d.userDisabled);
  do_check_eq(d.pendingOperations, AddonManager.PENDING_NONE);

  do_check_neq(t1, null);
  do_check_false(t1.isActive);
  do_check_true(t1.userDisabled);
  do_check_eq(t1.pendingOperations, AddonManager.PENDING_NONE);

  do_check_eq(Services.prefs.getCharPref(PREF_GENERAL_SKINS_SELECTEDSKIN), "classic/1.0");

  prepare_test({
    "theme1@tests.mozilla.org": [
      "onUninstalling"
    ]
  });
  t1.uninstall(true);
  ensure_test_completed();

  do_check_neq(d, null);
  do_check_true(d.isActive);
  do_check_false(d.userDisabled);
  do_check_eq(d.pendingOperations, AddonManager.PENDING_NONE);

  do_check_false(t1.isActive);
  do_check_true(t1.userDisabled);
  do_check_true(hasFlag(t1.pendingOperations, AddonManager.PENDING_UNINSTALL));

  do_check_eq(Services.prefs.getCharPref(PREF_GENERAL_SKINS_SELECTEDSKIN), "classic/1.0");

  await promiseRestartManager();

  [ t1, d ] = await promiseAddonsByIDs(["theme1@tests.mozilla.org",
                                        "default@tests.mozilla.org"]);

  do_check_neq(d, null);
  do_check_true(d.isActive);
  do_check_false(d.userDisabled);
  do_check_eq(d.pendingOperations, AddonManager.PENDING_NONE);

  do_check_eq(t1, null);

  do_check_eq(Services.prefs.getCharPref(PREF_GENERAL_SKINS_SELECTEDSKIN), "classic/1.0");
});

// Tests that uninstalling a disabled theme can be undone
add_task(async function canUndoUninstallDisabled() {
  writeInstallRDFForExtension(theme1, profileDir);

  await promiseRestartManager();

  let [ t1, d ] = await promiseAddonsByIDs(["theme1@tests.mozilla.org",
                                            "default@tests.mozilla.org"]);

  do_check_neq(d, null);
  do_check_true(d.isActive);
  do_check_false(d.userDisabled);
  do_check_eq(d.pendingOperations, AddonManager.PENDING_NONE);

  do_check_neq(t1, null);
  do_check_false(t1.isActive);
  do_check_true(t1.userDisabled);
  do_check_eq(t1.pendingOperations, AddonManager.PENDING_NONE);

  do_check_eq(Services.prefs.getCharPref(PREF_GENERAL_SKINS_SELECTEDSKIN), "classic/1.0");

  prepare_test({
    "theme1@tests.mozilla.org": [
      "onUninstalling"
    ]
  });
  t1.uninstall(true);
  ensure_test_completed();

  do_check_neq(d, null);
  do_check_true(d.isActive);
  do_check_false(d.userDisabled);
  do_check_eq(d.pendingOperations, AddonManager.PENDING_NONE);

  do_check_false(t1.isActive);
  do_check_true(t1.userDisabled);
  do_check_true(hasFlag(t1.pendingOperations, AddonManager.PENDING_UNINSTALL));

  do_check_eq(Services.prefs.getCharPref(PREF_GENERAL_SKINS_SELECTEDSKIN), "classic/1.0");

  prepare_test({
    "theme1@tests.mozilla.org": [
      "onOperationCancelled"
    ]
  });
  t1.cancelUninstall();
  ensure_test_completed();

  do_check_neq(d, null);
  do_check_true(d.isActive);
  do_check_false(d.userDisabled);
  do_check_eq(d.pendingOperations, AddonManager.PENDING_NONE);

  do_check_neq(t1, null);
  do_check_false(t1.isActive);
  do_check_true(t1.userDisabled);
  do_check_eq(t1.pendingOperations, AddonManager.PENDING_NONE);

  await promiseRestartManager();

  [ t1, d ] = await promiseAddonsByIDs(["theme1@tests.mozilla.org",
                                        "default@tests.mozilla.org"]);

  do_check_neq(d, null);
  do_check_true(d.isActive);
  do_check_false(d.userDisabled);
  do_check_eq(d.pendingOperations, AddonManager.PENDING_NONE);

  do_check_neq(t1, null);
  do_check_false(t1.isActive);
  do_check_true(t1.userDisabled);
  do_check_eq(t1.pendingOperations, AddonManager.PENDING_NONE);

  do_check_eq(Services.prefs.getCharPref(PREF_GENERAL_SKINS_SELECTEDSKIN), "classic/1.0");

  t1.uninstall();
  await promiseRestartManager();
});

add_task(async function uninstallWebExtensionOffersUndo() {
  let { id: addonId } = await promiseInstallWebExtension({
    manifest: {
      "author": "Some author",
      manifest_version: 2,
      name: "Web Extension Name",
      version: "1.0",
      theme: { images: { headerURL: "example.png" } },
    }
  });

  let [ t1, d ] = await promiseAddonsByIDs([addonId, "default@tests.mozilla.org"]);

  Assert.ok(t1, "Addon should be there");
  Assert.ok(!t1.isActive);
  Assert.ok(t1.userDisabled);
  Assert.equal(t1.pendingOperations, AddonManager.PENDING_NONE);

  Assert.ok(d, "Addon should be there");
  Assert.ok(d.isActive);
  Assert.ok(!d.userDisabled);
  Assert.equal(d.pendingOperations, AddonManager.PENDING_NONE);

  Assert.equal(Services.prefs.getCharPref(PREF_GENERAL_SKINS_SELECTEDSKIN), "classic/1.0");

  prepare_test({ [addonId]: [ "onUninstalling" ] });
  t1.uninstall(true);
  ensure_test_completed();

  Assert.ok(!t1.isActive);
  Assert.ok(t1.userDisabled);
  Assert.ok(hasFlag(t1.pendingOperations, AddonManager.PENDING_UNINSTALL));

  Assert.equal(Services.prefs.getCharPref(PREF_GENERAL_SKINS_SELECTEDSKIN), "classic/1.0");

  prepare_test({
    [addonId]: [
      "onOperationCancelled"
    ]
  });
  t1.cancelUninstall();
  ensure_test_completed();

  Assert.ok(!t1.isActive);
  Assert.ok(t1.userDisabled);
  Assert.equal(t1.pendingOperations, AddonManager.PENDING_NONE);

  await promiseRestartManager();

  [ t1, d ] = await promiseAddonsByIDs([addonId, "default@tests.mozilla.org"]);

  Assert.ok(d);
  Assert.ok(d.isActive);
  Assert.ok(!d.userDisabled);
  Assert.equal(d.pendingOperations, AddonManager.PENDING_NONE);

  Assert.ok(t1);
  Assert.ok(!t1.isActive);
  Assert.ok(t1.userDisabled);
  Assert.equal(t1.pendingOperations, AddonManager.PENDING_NONE);

  Assert.equal(Services.prefs.getCharPref(PREF_GENERAL_SKINS_SELECTEDSKIN), "classic/1.0");

  t1.uninstall();
  await promiseRestartManager();
});

// Tests that uninstalling an enabled lightweight theme offers the option to undo
add_task(async function uninstallLWTOffersUndo() {
  // skipped since lightweight themes don't support undoable uninstall yet

  /*
  LightweightThemeManager.currentTheme = dummyLWTheme("theme1");

  let [ t1, d ] = yield promiseAddonsByIDs(["theme1@personas.mozilla.org",
                                            "default@tests.mozilla.org"]);

  do_check_neq(d, null);
  do_check_false(d.isActive);
  do_check_true(d.userDisabled);
  do_check_eq(d.pendingOperations, AddonManager.PENDING_NONE);

  do_check_neq(t1, null);
  do_check_true(t1.isActive);
  do_check_false(t1.userDisabled);
  do_check_eq(t1.pendingOperations, AddonManager.PENDING_NONE);

  do_check_eq(Services.prefs.getCharPref(PREF_GENERAL_SKINS_SELECTEDSKIN), "classic/1.0");

  prepare_test({
    "default@tests.mozilla.org": [
      "onEnabling"
    ],
    "theme1@personas.mozilla.org": [
      "onUninstalling"
    ]
  });
  t1.uninstall(true);
  ensure_test_completed();

  do_check_neq(d, null);
  do_check_false(d.isActive);
  do_check_false(d.userDisabled);
  do_check_eq(d.pendingOperations, AddonManager.PENDING_ENABLE);

  do_check_true(t1.isActive);
  do_check_false(t1.userDisabled);
  do_check_true(hasFlag(t1.pendingOperations, AddonManager.PENDING_UNINSTALL));

  do_check_eq(Services.prefs.getCharPref(PREF_GENERAL_SKINS_SELECTEDSKIN), "classic/1.0");

  yield promiseRestartManager();

  [ t1, d ] = yield promiseAddonsByIDs(["theme1@personas.mozilla.org",
                                        "default@tests.mozilla.org"]);

  do_check_neq(d, null);
  do_check_true(d.isActive);
  do_check_false(d.userDisabled);
  do_check_eq(d.pendingOperations, AddonManager.PENDING_NONE);

  do_check_eq(t1, null);

  do_check_eq(Services.prefs.getCharPref(PREF_GENERAL_SKINS_SELECTEDSKIN), "classic/1.0");
  */
});
