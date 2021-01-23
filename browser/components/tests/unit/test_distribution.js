/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

/**
 * Tests that preferences are properly set by distribution.ini
 */

// Import common head.
var commonFile = do_get_file(
  "../../../../toolkit/components/places/tests/head_common.js",
  false
);
/* import-globals-from ../../../../toolkit/components/places/tests/head_common.js */
if (commonFile) {
  let uri = Services.io.newFileURI(commonFile);
  Services.scriptloader.loadSubScript(uri.spec, this);
}

const { AddonTestUtils } = ChromeUtils.import(
  "resource://testing-common/AddonTestUtils.jsm"
);
const { PromiseTestUtils } = ChromeUtils.import(
  "resource://testing-common/PromiseTestUtils.jsm"
);

AddonTestUtils.init(this);
AddonTestUtils.createAppInfo(
  "xpcshell@tests.mozilla.org",
  "XPCShell",
  "42",
  "42"
);

add_task(async function setup() {
  Services.prefs.setBoolPref("browser.search.modernConfig", false);
  await AddonTestUtils.promiseStartupManager();
});

// This test causes BrowserGlue to start but not fully initialise, when the
// AddonManager shuts down BrowserGlue will then try to uninit which will
// cause AutoComplete.jsm to throw an error.
// TODO: Fix in https://bugzilla.mozilla.org/show_bug.cgi?id=1543112.
PromiseTestUtils.whitelistRejectionsGlobally(/A request was aborted/);
PromiseTestUtils.whitelistRejectionsGlobally(
  /The operation failed for reasons unrelated/
);

const TOPICDATA_DISTRIBUTION_CUSTOMIZATION = "force-distribution-customization";
const TOPIC_BROWSERGLUE_TEST = "browser-glue-test";

/**
 * Copy the engine-distribution.xml engine to a fake distribution
 * created in the profile, and registered with the directory service.
 * Create an empty en-US directory to make sure it isn't used.
 */
function installDistributionEngine() {
  const XRE_APP_DISTRIBUTION_DIR = "XREAppDist";

  let dir = gProfD.clone();
  dir.append("distribution");
  let distDir = dir.clone();

  dir.append("searchplugins");
  dir.create(dir.DIRECTORY_TYPE, FileUtils.PERMS_DIRECTORY);

  dir.append("locale");
  dir.create(dir.DIRECTORY_TYPE, FileUtils.PERMS_DIRECTORY);
  let localeDir = dir.clone();

  dir.append("en-US");
  dir.create(dir.DIRECTORY_TYPE, FileUtils.PERMS_DIRECTORY);

  localeDir.append("de-DE");
  localeDir.create(dir.DIRECTORY_TYPE, FileUtils.PERMS_DIRECTORY);

  do_get_file("data/engine-de-DE.xml").copyTo(localeDir, "engine-de-DE.xml");

  Services.dirsvc.registerProvider({
    getFile(aProp, aPersistent) {
      aPersistent.value = true;
      if (aProp == XRE_APP_DISTRIBUTION_DIR) {
        return distDir.clone();
      }
      return null;
    },
  });
}

registerCleanupFunction(async function() {
  // Remove the distribution dir, even if the test failed, otherwise all
  // next tests will use it.
  let folderPath = OS.Path.join(OS.Constants.Path.profileDir, "distribution");
  await OS.File.removeDir(folderPath, { ignoreAbsent: true });
  Assert.ok(!(await OS.File.exists(folderPath)));
  Services.prefs.clearUserPref("distribution.testing.loadFromProfile");
});

add_task(async function() {
  // Set special pref to load distribution.ini from the profile folder.
  Services.prefs.setBoolPref("distribution.testing.loadFromProfile", true);

  // Copy distribution.ini file to the profile dir.
  let distroDir = gProfD.clone();
  distroDir.leafName = "distribution";
  let iniFile = distroDir.clone();
  iniFile.append("distribution.ini");
  if (iniFile.exists()) {
    iniFile.remove(false);
    print("distribution.ini already exists, did some test forget to cleanup?");
  }

  let testDistributionFile = gTestDir.clone();
  testDistributionFile.append("distribution.ini");
  testDistributionFile.copyTo(distroDir, "distribution.ini");
  Assert.ok(testDistributionFile.exists());

  installDistributionEngine();
});

add_task(async function() {
  // Force distribution.
  let glue = Cc["@mozilla.org/browser/browserglue;1"].getService(
    Ci.nsIObserver
  );
  glue.observe(
    null,
    TOPIC_BROWSERGLUE_TEST,
    TOPICDATA_DISTRIBUTION_CUSTOMIZATION
  );

  var defaultBranch = Services.prefs.getDefaultBranch(null);

  Assert.equal(defaultBranch.getCharPref("distribution.id"), "disttest");
  Assert.equal(defaultBranch.getCharPref("distribution.version"), "1.0");
  Assert.equal(
    defaultBranch.getStringPref("distribution.about"),
    "Tèƨƭ δïƨƭřïβúƭïôñ ƒïℓè"
  );

  Assert.equal(
    defaultBranch.getCharPref("distribution.test.string"),
    "Test String"
  );
  Assert.equal(
    defaultBranch.getCharPref("distribution.test.string.noquotes"),
    "Test String"
  );
  Assert.equal(defaultBranch.getIntPref("distribution.test.int"), 777);
  Assert.equal(defaultBranch.getBoolPref("distribution.test.bool.true"), true);
  Assert.equal(
    defaultBranch.getBoolPref("distribution.test.bool.false"),
    false
  );

  Assert.throws(
    () => defaultBranch.getCharPref("distribution.test.empty"),
    /NS_ERROR_UNEXPECTED/
  );
  Assert.throws(
    () => defaultBranch.getIntPref("distribution.test.empty"),
    /NS_ERROR_UNEXPECTED/
  );
  Assert.throws(
    () => defaultBranch.getBoolPref("distribution.test.empty"),
    /NS_ERROR_UNEXPECTED/
  );

  Assert.equal(
    defaultBranch.getCharPref("distribution.test.pref.locale"),
    "en-US"
  );
  Assert.equal(
    defaultBranch.getCharPref("distribution.test.pref.language.en"),
    "en"
  );
  Assert.equal(
    defaultBranch.getCharPref("distribution.test.pref.locale.en-US"),
    "en-US"
  );
  Assert.throws(
    () => defaultBranch.getCharPref("distribution.test.pref.language.de"),
    /NS_ERROR_UNEXPECTED/
  );
  // This value was never set because of the empty language specific pref
  Assert.throws(
    () => defaultBranch.getCharPref("distribution.test.pref.language.reset"),
    /NS_ERROR_UNEXPECTED/
  );
  // This value was never set because of the empty locale specific pref
  Assert.throws(
    () => defaultBranch.getCharPref("distribution.test.pref.locale.reset"),
    /NS_ERROR_UNEXPECTED/
  );
  // This value was overridden by a locale specific setting
  Assert.equal(
    defaultBranch.getCharPref("distribution.test.pref.locale.set"),
    "Locale Set"
  );
  // This value was overridden by a language specific setting
  Assert.equal(
    defaultBranch.getCharPref("distribution.test.pref.language.set"),
    "Language Set"
  );
  // Language should not override locale
  Assert.notEqual(
    defaultBranch.getCharPref("distribution.test.pref.locale.set"),
    "Language Set"
  );

  Assert.equal(
    defaultBranch.getComplexValue(
      "distribution.test.locale",
      Ci.nsIPrefLocalizedString
    ).data,
    "en-US"
  );
  Assert.equal(
    defaultBranch.getComplexValue(
      "distribution.test.language.en",
      Ci.nsIPrefLocalizedString
    ).data,
    "en"
  );
  Assert.equal(
    defaultBranch.getComplexValue(
      "distribution.test.locale.en-US",
      Ci.nsIPrefLocalizedString
    ).data,
    "en-US"
  );
  Assert.throws(
    () =>
      defaultBranch.getComplexValue(
        "distribution.test.language.de",
        Ci.nsIPrefLocalizedString
      ),
    /NS_ERROR_UNEXPECTED/
  );
  // This value was never set because of the empty language specific pref
  Assert.throws(
    () =>
      defaultBranch.getComplexValue(
        "distribution.test.language.reset",
        Ci.nsIPrefLocalizedString
      ),
    /NS_ERROR_UNEXPECTED/
  );
  // This value was never set because of the empty locale specific pref
  Assert.throws(
    () =>
      defaultBranch.getComplexValue(
        "distribution.test.locale.reset",
        Ci.nsIPrefLocalizedString
      ),
    /NS_ERROR_UNEXPECTED/
  );
  // This value was overridden by a locale specific setting
  Assert.equal(
    defaultBranch.getComplexValue(
      "distribution.test.locale.set",
      Ci.nsIPrefLocalizedString
    ).data,
    "Locale Set"
  );
  // This value was overridden by a language specific setting
  Assert.equal(
    defaultBranch.getComplexValue(
      "distribution.test.language.set",
      Ci.nsIPrefLocalizedString
    ).data,
    "Language Set"
  );
  // Language should not override locale
  Assert.notEqual(
    defaultBranch.getComplexValue(
      "distribution.test.locale.set",
      Ci.nsIPrefLocalizedString
    ).data,
    "Language Set"
  );

  Services.prefs.setCharPref(
    "distribution.searchplugins.defaultLocale",
    "de-DE"
  );

  await Services.search.init();
  var engine = Services.search.getEngineByName("Google");
  Assert.equal(engine.description, "override-de-DE");
});
