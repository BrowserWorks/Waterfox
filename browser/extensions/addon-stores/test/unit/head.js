/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
 */

/* eslint no-unused-vars: ["error", {vars: "local", args: "none"}] */


var { AppConstants } = ChromeUtils.import(
  "resource://gre/modules/AppConstants.jsm"
);
var { FileUtils } = ChromeUtils.import("resource://gre/modules/FileUtils.jsm");
var { NetUtil } = ChromeUtils.import("resource://gre/modules/NetUtil.jsm");
var { Services } = ChromeUtils.import("resource://gre/modules/Services.jsm");
var { XPCOMUtils } = ChromeUtils.import(
  "resource://gre/modules/XPCOMUtils.jsm"
);
var { AddonRepository } = ChromeUtils.import(
  "resource://gre/modules/addons/AddonRepository.jsm"
);
var { OS, require } = ChromeUtils.import("resource://gre/modules/osfile.jsm");

var { AddonTestUtils, MockAsyncShutdown } = ChromeUtils.import(
  "resource://testing-common/AddonTestUtils.jsm"
);

ChromeUtils.defineModuleGetter(
  this,
  "Blocklist",
  "resource://gre/modules/Blocklist.jsm"
);
ChromeUtils.defineModuleGetter(
  this,
  "Extension",
  "resource://gre/modules/Extension.jsm"
);
ChromeUtils.defineModuleGetter(
  this,
  "ExtensionTestUtils",
  "resource://testing-common/ExtensionXPCShellUtils.jsm"
);
ChromeUtils.defineModuleGetter(
  this,
  "ExtensionTestCommon",
  "resource://testing-common/ExtensionTestCommon.jsm"
);
ChromeUtils.defineModuleGetter(
  this,
  "HttpServer",
  "resource://testing-common/httpd.js"
);
ChromeUtils.defineModuleGetter(
  this,
  "MockRegistrar",
  "resource://testing-common/MockRegistrar.jsm"
);
ChromeUtils.defineModuleGetter(
  this,
  "MockRegistry",
  "resource://testing-common/MockRegistry.jsm"
);
ChromeUtils.defineModuleGetter(
  this,
  "PromiseTestUtils",
  "resource://testing-common/PromiseTestUtils.jsm"
);
ChromeUtils.defineModuleGetter(
  this,
  "RemoteSettings",
  "resource://services-settings/remote-settings.js"
);
ChromeUtils.defineModuleGetter(
  this,
  "TestUtils",
  "resource://testing-common/TestUtils.jsm"
);
ChromeUtils.defineModuleGetter(
  this,
  "setTimeout",
  "resource://gre/modules/Timer.jsm"
);
ChromeUtils.defineModuleGetter(
  this,
  "StoreHandler",
  "resource://addonstores.js/StoreHandler.jsm"
);

  const ZipReader = Components.Constructor(
    "@mozilla.org/libjar/zip-reader;1",
    "nsIZipReader",
    "open"
  );
  
  const ReusableStreamInstance = Components.Constructor(
    "@mozilla.org/scriptableinputstream;1",
    "nsIScriptableInputStream",
    "init"
  );
  
  const FileStream = Components.Constructor(
    "@mozilla.org/network/file-input-stream;1",
    "nsIFileInputStream",
    "init"
  );

  const {
    createAppInfo,
    createHttpServer,
    createTempWebExtensionFile,
    getFileForAddon,
    manuallyInstall,
    manuallyUninstall,
    overrideBuiltIns,
    promiseAddonEvent,
    promiseCompleteAllInstalls,
    promiseCompleteInstall,
    promiseConsoleOutput,
    promiseFindAddonUpdates,
    promiseInstallAllFiles,
    promiseInstallFile,
    promiseRestartManager,
    promiseSetExtensionModifiedTime,
    promiseShutdownManager,
    promiseStartupManager,
    promiseWebExtensionStartup,
    promiseWriteProxyFileToDir,
    registerDirectory,
    setExtensionModifiedTime,
    writeFilesToZip,
  } = AddonTestUtils;

// WebExtension wrapper for ease of testing
ExtensionTestUtils.init(this);

AddonTestUtils.init(this);
AddonTestUtils.overrideCertDB();

Object.defineProperty(this, "gAppInfo", {
  get() {
    return AddonTestUtils.appInfo;
  },
});

Object.defineProperty(this, "gAddonStartup", {
  get() {
    return AddonTestUtils.addonStartup.clone();
  },
});

Object.defineProperty(this, "gInternalManager", {
  get() {
    return AddonTestUtils.addonIntegrationService.QueryInterface(
      Ci.nsITimerCallback
    );
  },
});

Object.defineProperty(this, "gProfD", {
  get() {
    return AddonTestUtils.profileDir.clone();
  },
});

Object.defineProperty(this, "gTmpD", {
  get() {
    return AddonTestUtils.tempDir.clone();
  },
});

Object.defineProperty(this, "gUseRealCertChecks", {
  get() {
    return AddonTestUtils.useRealCertChecks;
  },
  set(val) {
    return (AddonTestUtils.useRealCertChecks = val);
  },
});

Object.defineProperty(this, "TEST_UNPACKED", {
  get() {
    return AddonTestUtils.testUnpacked;
  },
  set(val) {
    return (AddonTestUtils.testUnpacked = val);
  },
});

createAppInfo("xpcshell@tests.mozilla.org", "XPCShell", "1", "1.9.2");