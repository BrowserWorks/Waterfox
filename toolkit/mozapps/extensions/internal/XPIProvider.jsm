 /* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const Cc = Components.classes;
const Ci = Components.interfaces;
const Cr = Components.results;
const Cu = Components.utils;

this.EXPORTED_SYMBOLS = ["XPIProvider", "XPIInternal"];

/* globals WebExtensionPolicy */

Cu.import("resource://gre/modules/Services.jsm");
Cu.import("resource://gre/modules/XPCOMUtils.jsm");
Cu.import("resource://gre/modules/AddonManager.jsm");
Cu.import("resource://gre/modules/Preferences.jsm");

XPCOMUtils.defineLazyModuleGetter(this, "AddonRepository",
                                  "resource://gre/modules/addons/AddonRepository.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "AddonSettings",
                                  "resource://gre/modules/addons/AddonSettings.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "AppConstants",
                                  "resource://gre/modules/AppConstants.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "ChromeManifestParser",
                                  "resource://gre/modules/ChromeManifestParser.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "LightweightThemeManager",
                                  "resource://gre/modules/LightweightThemeManager.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "Locale",
                                  "resource://gre/modules/Locale.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "FileUtils",
                                  "resource://gre/modules/FileUtils.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "ZipUtils",
                                  "resource://gre/modules/ZipUtils.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "NetUtil",
                                  "resource://gre/modules/NetUtil.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "PermissionsUtils",
                                  "resource://gre/modules/PermissionsUtils.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "Promise",
                                  "resource://gre/modules/Promise.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "OS",
                                  "resource://gre/modules/osfile.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "BrowserToolboxProcess",
                                  "resource://devtools/client/framework/ToolboxProcess.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "ConsoleAPI",
                                  "resource://gre/modules/Console.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "ProductAddonChecker",
                                  "resource://gre/modules/addons/ProductAddonChecker.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "UpdateUtils",
                                  "resource://gre/modules/UpdateUtils.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "AppConstants",
                                  "resource://gre/modules/AppConstants.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "isAddonPartOfE10SRollout",
                                  "resource://gre/modules/addons/E10SAddonsRollout.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "JSONFile",
                                  "resource://gre/modules/JSONFile.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "LegacyExtensionsUtils",
                                  "resource://gre/modules/LegacyExtensionsUtils.jsm");

/* globals DownloadAddonInstall, LocalAddonInstall, StagedAddonInstall, UpdateChecker, loadManifestFromFile, verifyBundleSignedState */
for (let sym of [
  "DownloadAddonInstall",
  "LocalAddonInstall",
  "StagedAddonInstall",
  "UpdateChecker",
  "loadManifestFromFile",
  "verifyBundleSignedState",
]) {
  XPCOMUtils.defineLazyModuleGetter(this, sym, "resource://gre/modules/addons/XPIInstall.jsm");
}

const {nsIBlocklistService} = Ci;
XPCOMUtils.defineLazyServiceGetter(this, "Blocklist",
                                   "@mozilla.org/extensions/blocklist;1",
                                   "nsIBlocklistService");
XPCOMUtils.defineLazyServiceGetter(this,
                                   "ChromeRegistry",
                                   "@mozilla.org/chrome/chrome-registry;1",
                                   "nsIChromeRegistry");
XPCOMUtils.defineLazyServiceGetter(this,
                                   "ResProtocolHandler",
                                   "@mozilla.org/network/protocol;1?name=resource",
                                   "nsIResProtocolHandler");
XPCOMUtils.defineLazyServiceGetter(this,
                                   "AddonPolicyService",
                                   "@mozilla.org/addons/policy-service;1",
                                   "nsIAddonPolicyService");
XPCOMUtils.defineLazyServiceGetter(this,
                                   "AddonPathService",
                                   "@mozilla.org/addon-path-service;1",
                                   "amIAddonPathService");
XPCOMUtils.defineLazyServiceGetter(this, "aomStartup",
                                   "@mozilla.org/addons/addon-manager-startup;1",
                                   "amIAddonManagerStartup");

Cu.importGlobalProperties(["URL"]);

const nsIFile = Components.Constructor("@mozilla.org/file/local;1", "nsIFile",
                                       "initWithPath");

const PREF_DB_SCHEMA                  = "extensions.databaseSchema";
const PREF_XPI_STATE                  = "extensions.xpiState";
const PREF_BOOTSTRAP_ADDONS           = "extensions.bootstrappedAddons";
const PREF_PENDING_OPERATIONS         = "extensions.pendingOperations";
const PREF_SKIN_SWITCHPENDING         = "extensions.dss.switchPending";
const PREF_SKIN_TO_SELECT             = "extensions.lastSelectedSkin";
const PREF_GENERAL_SKINS_SELECTEDSKIN = "general.skins.selectedSkin";
const PREF_EM_EXTENSION_FORMAT        = "extensions.";
const PREF_EM_ENABLED_SCOPES          = "extensions.enabledScopes";
const PREF_EM_STARTUP_SCAN_SCOPES     = "extensions.startupScanScopes";
const PREF_EM_SHOW_MISMATCH_UI        = "extensions.showMismatchUI";
const PREF_XPI_ENABLED                = "xpinstall.enabled";
const PREF_XPI_WHITELIST_REQUIRED     = "xpinstall.whitelist.required";
const PREF_XPI_DIRECT_WHITELISTED     = "xpinstall.whitelist.directRequest";
const PREF_XPI_FILE_WHITELISTED       = "xpinstall.whitelist.fileRequest";
// xpinstall.signatures.required only supported in dev builds
const PREF_XPI_SIGNATURES_REQUIRED    = "xpinstall.signatures.required";
const PREF_XPI_SIGNATURES_DEV_ROOT    = "xpinstall.signatures.dev-root";
const PREF_XPI_PERMISSIONS_BRANCH     = "xpinstall.";
const PREF_INSTALL_REQUIRESECUREORIGIN = "extensions.install.requireSecureOrigin";
const PREF_INSTALL_DISTRO_ADDONS      = "extensions.installDistroAddons";
const PREF_BRANCH_INSTALLED_ADDON     = "extensions.installedDistroAddon.";
const PREF_INTERPOSITION_ENABLED      = "extensions.interposition.enabled";
const PREF_SYSTEM_ADDON_SET           = "extensions.systemAddonSet";
const PREF_SYSTEM_ADDON_UPDATE_URL    = "extensions.systemAddon.update.url";
const PREF_E10S_BLOCK_ENABLE          = "extensions.e10sBlocksEnabling";
const PREF_E10S_ADDON_BLOCKLIST       = "extensions.e10s.rollout.blocklist";
const PREF_E10S_ADDON_POLICY          = "extensions.e10s.rollout.policy";
const PREF_E10S_HAS_NONEXEMPT_ADDON   = "extensions.e10s.rollout.hasAddon";
const PREF_ALLOW_LEGACY               = "extensions.legacy.enabled";
const PREF_ALLOW_NON_MPC              = "extensions.allow-non-mpc-extensions";

const PREF_EM_MIN_COMPAT_APP_VERSION      = "extensions.minCompatibleAppVersion";
const PREF_EM_MIN_COMPAT_PLATFORM_VERSION = "extensions.minCompatiblePlatformVersion";

const PREF_CHECKCOMAT_THEMEOVERRIDE   = "extensions.checkCompatibility.temporaryThemeOverride_minAppVersion";

const PREF_EM_HOTFIX_ID               = "extensions.hotfix.id";

const OBSOLETE_PREFERENCES = [
  "extensions.bootstrappedAddons",
  "extensions.enabledAddons",
  "extensions.xpiState",
  "extensions.installCache",
];

const URI_EXTENSION_UPDATE_DIALOG     = "chrome://mozapps/content/extensions/update.xul";
const URI_EXTENSION_STRINGS           = "chrome://mozapps/locale/extensions/extensions.properties";

const STRING_TYPE_NAME                = "type.%ID%.name";

const DIR_EXTENSIONS                  = "extensions";
const DIR_SYSTEM_ADDONS               = "features";
const DIR_STAGE                       = "staged";
const DIR_TRASH                       = "trash";

const FILE_XPI_STATES                 = "addonStartup.json.lz4";
const FILE_DATABASE                   = "extensions.json";
const FILE_OLD_CACHE                  = "extensions.cache";
const FILE_RDF_MANIFEST               = "install.rdf";
const FILE_WEB_MANIFEST               = "manifest.json";
const FILE_XPI_ADDONS_LIST            = "extensions.ini";

const ADDON_ID_DEFAULT_THEME          = "{972ce4c6-7e08-4474-a285-3208198ce6fd}";

const KEY_PROFILEDIR                  = "ProfD";
const KEY_ADDON_APP_DIR               = "XREAddonAppDir";
const KEY_APP_DISTRIBUTION            = "XREAppDist";
const KEY_APP_FEATURES                = "XREAppFeat";

const KEY_APP_PROFILE                 = "app-profile";
const KEY_APP_SYSTEM_ADDONS           = "app-system-addons";
const KEY_APP_SYSTEM_DEFAULTS         = "app-system-defaults";
const KEY_APP_GLOBAL                  = "app-global";
const KEY_APP_SYSTEM_LOCAL            = "app-system-local";
const KEY_APP_SYSTEM_SHARE            = "app-system-share";
const KEY_APP_SYSTEM_USER             = "app-system-user";
const KEY_APP_TEMPORARY               = "app-temporary";

const TEMPORARY_ADDON_SUFFIX = "@temporary-addon";

const STARTUP_MTIME_SCOPES = [KEY_APP_GLOBAL,
                              KEY_APP_SYSTEM_LOCAL,
                              KEY_APP_SYSTEM_SHARE,
                              KEY_APP_SYSTEM_USER];

const NOTIFICATION_FLUSH_PERMISSIONS  = "flush-pending-permissions";
const XPI_PERMISSION                  = "install";

const TOOLKIT_ID                      = "toolkit@mozilla.org";

const XPI_SIGNATURE_CHECK_PERIOD      = 24 * 60 * 60;

XPCOMUtils.defineConstant(this, "DB_SCHEMA", 21);

XPCOMUtils.defineLazyPreferenceGetter(this, "ALLOW_NON_MPC", PREF_ALLOW_NON_MPC);

const NOTIFICATION_TOOLBOXPROCESS_LOADED      = "ToolboxProcessLoaded";

// Properties that exist in the install manifest
const PROP_LOCALE_SINGLE = ["name", "description", "creator", "homepageURL"];
const PROP_LOCALE_MULTI  = ["developers", "translators", "contributors"];

// Properties to cache and reload when an addon installation is pending
const PENDING_INSTALL_METADATA =
    ["syncGUID", "targetApplications", "userDisabled", "softDisabled",
     "existingAddonID", "sourceURI", "releaseNotesURI", "installDate",
     "updateDate", "applyBackgroundUpdates", "compatibilityOverrides"];

// Note: When adding/changing/removing items here, remember to change the
// DB schema version to ensure changes are picked up ASAP.
const STATIC_BLOCKLIST_PATTERNS = [
  { creator: "Mozilla Corp.",
    level: nsIBlocklistService.STATE_BLOCKED,
    blockID: "i162" },
  { creator: "Mozilla.org",
    level: nsIBlocklistService.STATE_BLOCKED,
    blockID: "i162" }
];

function encoded(strings, ...values) {
  let result = [];

  for (let [i, string] of strings.entries()) {
    result.push(string);
    if (i < values.length)
      result.push(encodeURIComponent(values[i]));
  }

  return result.join("");
}

const BOOTSTRAP_REASONS = {
  APP_STARTUP: 1,
  APP_SHUTDOWN: 2,
  ADDON_ENABLE: 3,
  ADDON_DISABLE: 4,
  ADDON_INSTALL: 5,
  ADDON_UNINSTALL: 6,
  ADDON_UPGRADE: 7,
  ADDON_DOWNGRADE: 8
};

// Some add-on types that we track internally are presented as other types
// externally
const TYPE_ALIASES = {
  "apiextension": "extension",
  "webextension": "extension",
  "webextension-theme": "theme",
};

const CHROME_TYPES = new Set([
  "extension",
  "locale",
  "experiment",
]);

const SIGNED_TYPES = new Set([
  "apiextension",
  "extension",
  "experiment",
  "webextension",
  "webextension-theme",
]);

const ALL_TYPES = new Set([
  "dictionary",
  "extension",
  "experiment",
  "locale",
  "theme",
]);

// Whether add-on signing is required.
function mustSign(aType) {
  if (!SIGNED_TYPES.has(aType))
    return false;

  return AddonSettings.REQUIRE_SIGNING;
}

// Keep track of where we are in startup for telemetry
// event happened during XPIDatabase.startup()
const XPI_STARTING = "XPIStarting";
// event happened after startup() but before the final-ui-startup event
const XPI_BEFORE_UI_STARTUP = "BeforeFinalUIStartup";
// event happened after final-ui-startup
const XPI_AFTER_UI_STARTUP = "AfterFinalUIStartup";

const COMPATIBLE_BY_DEFAULT_TYPES = {
  extension: true,
  dictionary: true
};

const MSG_JAR_FLUSH = "AddonJarFlush";
const MSG_MESSAGE_MANAGER_CACHES_FLUSH = "AddonMessageManagerCachesFlush";

var gGlobalScope = this;

/**
 * Valid IDs fit this pattern.
 */
var gIDTest = /^(\{[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\}|[a-z0-9-\._]*\@[a-z0-9-\._]+)$/i;

Cu.import("resource://gre/modules/Log.jsm");
const LOGGER_ID = "addons.xpi";

// Create a new logger for use by all objects in this Addons XPI Provider module
// (Requires AddonManager.jsm)
var logger = Log.repository.getLogger(LOGGER_ID);

const LAZY_OBJECTS = ["XPIDatabase", "XPIDatabaseReconcile"];
/* globals XPIDatabase, XPIDatabaseReconcile*/

var gLazyObjectsLoaded = false;

XPCOMUtils.defineLazyPreferenceGetter(this, "gStartupScanScopes",
                                      PREF_EM_STARTUP_SCAN_SCOPES, 0);

function loadLazyObjects() {
  let uri = "resource://gre/modules/addons/XPIProviderUtils.js";
  let scope = Cu.Sandbox(Services.scriptSecurityManager.getSystemPrincipal(), {
    sandboxName: uri,
    wantGlobalProperties: ["TextDecoder"],
  });

  Object.assign(scope, {
    ADDON_SIGNING: AddonSettings.ADDON_SIGNING,
    SIGNED_TYPES,
    BOOTSTRAP_REASONS,
    DB_SCHEMA,
    AddonInternal,
    XPIProvider,
    XPIStates,
    syncLoadManifestFromFile,
    isUsableAddon,
    recordAddonTelemetry,
    applyBlocklistChanges,
    flushChromeCaches,
    descriptorToPath,
  });

  Services.scriptloader.loadSubScript(uri, scope);

  for (let name of LAZY_OBJECTS) {
    delete gGlobalScope[name];
    gGlobalScope[name] = scope[name];
  }
  gLazyObjectsLoaded = true;
  return scope;
}

LAZY_OBJECTS.forEach(name => {
  Object.defineProperty(gGlobalScope, name, {
    get() {
      let objs = loadLazyObjects();
      return objs[name];
    },
    configurable: true
  });
});

/**
 * Returns a nsIFile instance for the given path, relative to the given
 * base file, if provided.
 *
 * @param {string} path
 *        The (possibly relative) path of the file.
 * @param {nsIFile} [base]
 *        An optional file to use as a base path if `path` is relative.
 * @returns {nsIFile}
 */
function getFile(path, base = null) {
  // First try for an absolute path, as we get in the case of proxy
  // files. Ideally we would try a relative path first, but on Windows,
  // paths which begin with a drive letter are valid as relative paths,
  // and treated as such.
  try {
    return new nsIFile(path);
  } catch (e) {
    // Ignore invalid relative paths. The only other error we should see
    // here is EOM, and either way, any errors that we care about should
    // be re-thrown below.
  }

  // If the path isn't absolute, we must have a base path.
  let file = base.clone();
  file.appendRelativePath(path);
  return file;
}

/**
 * Returns the modification time of the given file, or 0 if the file
 * does not exist, or cannot be accessed.
 *
 * @param {nsIFile} file
 *        The file to retrieve the modification time for.
 * @returns {double}
 *        The file's modification time, in seconds since the Unix epoch.
 */
function tryGetMtime(file) {
  try {
    return file.lastModifiedTime;
  } catch (e) {
    return 0;
  }
}

/**
 * Returns the path to `file` relative to the directory `dir`, or an
 * absolute path to the file if no directory is passed, or the file is
 * not a descendant of it.
 *
 * @param {nsIFile} file
 *        The file to return a relative path to.
 * @param {nsIFile} [dir]
 *        If passed, return a path relative to this directory.
 * @returns {string}
 */
function getRelativePath(file, dir) {
  if (dir && dir.contains(file)) {
    let path = file.getRelativePath(dir);
    if (AppConstants.platform == "win") {
      path = path.replace(/\//g, "\\");
    }
    return path;
  }
  return file.path;
}

/**
 * Converts the given opaque descriptor string into an ordinary path
 * string. In practice, the path string is always exactly equal to the
 * descriptor string, but theoretically may not have been on some legacy
 * systems.
 *
 * @param {string} descriptor
 *        The opaque descriptor string to convert.
 * @param {nsIFile} [dir]
 *        If passed, return a path relative to this directory.
 * @returns {string}
 *        The file's path.
 */
function descriptorToPath(descriptor, dir) {
  try {
    let file = Cc["@mozilla.org/file/local;1"].createInstance(Ci.nsIFile);
    file.persistentDescriptor = descriptor;
    return getRelativePath(file, dir);
  } catch (e) {
    return null;
  }
}


// Behaves like Promise.all except waits for all promises to resolve/reject
// before resolving/rejecting itself
function waitForAllPromises(promises) {
  return new Promise((resolve, reject) => {
    let shouldReject = false;
    let rejectValue = null;

    let newPromises = promises.map(
      p => p.catch(value => {
        shouldReject = true;
        rejectValue = value;
      })
    );
    Promise.all(newPromises)
           .then((results) => shouldReject ? reject(rejectValue) : resolve(results));
  });
}

function findMatchingStaticBlocklistItem(aAddon) {
  for (let item of STATIC_BLOCKLIST_PATTERNS) {
    if ("creator" in item && typeof item.creator == "string") {
      if ((aAddon.defaultLocale && aAddon.defaultLocale.creator == item.creator) ||
          (aAddon.selectedLocale && aAddon.selectedLocale.creator == item.creator)) {
        return item;
      }
    }
  }
  return null;
}

/**
 * Converts an iterable of addon objects into a map with the add-on's ID as key.
 */
function addonMap(addons) {
  return new Map(addons.map(a => [a.id, a]));
}

/**
 * Helper function that determines whether an addon of a certain type is a
 * WebExtension.
 *
 * @param  {String} type
 * @return {Boolean}
 */
function isWebExtension(type) {
  return type == "webextension" || type == "webextension-theme";
}

var gThemeAliases = null;
/**
 * Helper function that determines whether an addon of a certain type is a
 * theme.
 *
 * @param  {String} type
 * @return {Boolean}
 */
function isTheme(type) {
  if (!gThemeAliases)
    gThemeAliases = getAllAliasesForTypes(["theme"]);
  return gThemeAliases.includes(type);
}

/**
 * Sets permissions on a file
 *
 * @param  aFile
 *         The file or directory to operate on.
 * @param  aPermissions
 *         The permisions to set
 */
function setFilePermissions(aFile, aPermissions) {
  try {
    aFile.permissions = aPermissions;
  } catch (e) {
    logger.warn("Failed to set permissions " + aPermissions.toString(8) + " on " +
         aFile.path, e);
  }
}

/**
 * Write a given string to a file
 *
 * @param  file
 *         The nsIFile instance to write into
 * @param  string
 *         The string to write
 */
function writeStringToFile(file, string) {
  let stream = Cc["@mozilla.org/network/file-output-stream;1"].
               createInstance(Ci.nsIFileOutputStream);
  let converter = Cc["@mozilla.org/intl/converter-output-stream;1"].
                  createInstance(Ci.nsIConverterOutputStream);

  try {
    stream.init(file, FileUtils.MODE_WRONLY | FileUtils.MODE_CREATE |
                            FileUtils.MODE_TRUNCATE, FileUtils.PERMS_FILE,
                           0);
    converter.init(stream, "UTF-8", 0, 0x0000);
    converter.writeString(string);
  } finally {
    converter.close();
    stream.close();
  }
}

/**
 * A safe way to install a file or the contents of a directory to a new
 * directory. The file or directory is moved or copied recursively and if
 * anything fails an attempt is made to rollback the entire operation. The
 * operation may also be rolled back to its original state after it has
 * completed by calling the rollback method.
 *
 * Operations can be chained. Calling move or copy multiple times will remember
 * the whole set and if one fails all of the operations will be rolled back.
 */
function SafeInstallOperation() {
  this._installedFiles = [];
  this._createdDirs = [];
}

SafeInstallOperation.prototype = {
  _installedFiles: null,
  _createdDirs: null,

  _installFile(aFile, aTargetDirectory, aCopy) {
    let oldFile = aCopy ? null : aFile.clone();
    let newFile = aFile.clone();
    try {
      if (aCopy) {
        newFile.copyTo(aTargetDirectory, null);
        // copyTo does not update the nsIFile with the new.
        newFile = getFile(aFile.leafName, aTargetDirectory);
        // Windows roaming profiles won't properly sync directories if a new file
        // has an older lastModifiedTime than a previous file, so update.
        newFile.lastModifiedTime = Date.now();
      } else {
        newFile.moveTo(aTargetDirectory, null);
      }
    } catch (e) {
      logger.error("Failed to " + (aCopy ? "copy" : "move") + " file " + aFile.path +
            " to " + aTargetDirectory.path, e);
      throw e;
    }
    this._installedFiles.push({ oldFile, newFile });
  },

  _installDirectory(aDirectory, aTargetDirectory, aCopy) {
    if (aDirectory.contains(aTargetDirectory)) {
      let err = new Error(`Not installing ${aDirectory} into its own descendent ${aTargetDirectory}`);
      logger.error(err);
      throw err;
    }

    let newDir = getFile(aDirectory.leafName, aTargetDirectory);
    try {
      newDir.create(Ci.nsIFile.DIRECTORY_TYPE, FileUtils.PERMS_DIRECTORY);
    } catch (e) {
      logger.error("Failed to create directory " + newDir.path, e);
      throw e;
    }
    this._createdDirs.push(newDir);

    // Use a snapshot of the directory contents to avoid possible issues with
    // iterating over a directory while removing files from it (the YAFFS2
    // embedded filesystem has this issue, see bug 772238), and to remove
    // normal files before their resource forks on OSX (see bug 733436).
    let entries = getDirectoryEntries(aDirectory, true);
    for (let entry of entries) {
      try {
        this._installDirEntry(entry, newDir, aCopy);
      } catch (e) {
        logger.error("Failed to " + (aCopy ? "copy" : "move") + " entry " +
                     entry.path, e);
        throw e;
      }
    }

    // If this is only a copy operation then there is nothing else to do
    if (aCopy)
      return;

    // The directory should be empty by this point. If it isn't this will throw
    // and all of the operations will be rolled back
    try {
      setFilePermissions(aDirectory, FileUtils.PERMS_DIRECTORY);
      aDirectory.remove(false);
    } catch (e) {
      logger.error("Failed to remove directory " + aDirectory.path, e);
      throw e;
    }

    // Note we put the directory move in after all the file moves so the
    // directory is recreated before all the files are moved back
    this._installedFiles.push({ oldFile: aDirectory, newFile: newDir });
  },

  _installDirEntry(aDirEntry, aTargetDirectory, aCopy) {
    let isDir = null;

    try {
      isDir = aDirEntry.isDirectory() && !aDirEntry.isSymlink();
    } catch (e) {
      // If the file has already gone away then don't worry about it, this can
      // happen on OSX where the resource fork is automatically moved with the
      // data fork for the file. See bug 733436.
      if (e.result == Cr.NS_ERROR_FILE_TARGET_DOES_NOT_EXIST)
        return;

      logger.error("Failure " + (aCopy ? "copying" : "moving") + " " + aDirEntry.path +
            " to " + aTargetDirectory.path);
      throw e;
    }

    try {
      if (isDir)
        this._installDirectory(aDirEntry, aTargetDirectory, aCopy);
      else
        this._installFile(aDirEntry, aTargetDirectory, aCopy);
    } catch (e) {
      logger.error("Failure " + (aCopy ? "copying" : "moving") + " " + aDirEntry.path +
            " to " + aTargetDirectory.path);
      throw e;
    }
  },

  /**
   * Moves a file or directory into a new directory. If an error occurs then all
   * files that have been moved will be moved back to their original location.
   *
   * @param  aFile
   *         The file or directory to be moved.
   * @param  aTargetDirectory
   *         The directory to move into, this is expected to be an empty
   *         directory.
   */
  moveUnder(aFile, aTargetDirectory) {
    try {
      this._installDirEntry(aFile, aTargetDirectory, false);
    } catch (e) {
      this.rollback();
      throw e;
    }
  },

  /**
   * Renames a file to a new location.  If an error occurs then all
   * files that have been moved will be moved back to their original location.
   *
   * @param  aOldLocation
   *         The old location of the file.
   * @param  aNewLocation
   *         The new location of the file.
   */
  moveTo(aOldLocation, aNewLocation) {
    try {
      let oldFile = aOldLocation.clone(), newFile = aNewLocation.clone();
      oldFile.moveTo(newFile.parent, newFile.leafName);
      this._installedFiles.push({ oldFile, newFile, isMoveTo: true});
    } catch (e) {
      this.rollback();
      throw e;
    }
  },

  /**
   * Copies a file or directory into a new directory. If an error occurs then
   * all new files that have been created will be removed.
   *
   * @param  aFile
   *         The file or directory to be copied.
   * @param  aTargetDirectory
   *         The directory to copy into, this is expected to be an empty
   *         directory.
   */
  copy(aFile, aTargetDirectory) {
    try {
      this._installDirEntry(aFile, aTargetDirectory, true);
    } catch (e) {
      this.rollback();
      throw e;
    }
  },

  /**
   * Rolls back all the moves that this operation performed. If an exception
   * occurs here then both old and new directories are left in an indeterminate
   * state
   */
  rollback() {
    while (this._installedFiles.length > 0) {
      let move = this._installedFiles.pop();
      if (move.isMoveTo) {
        move.newFile.moveTo(move.oldDir.parent, move.oldDir.leafName);
      } else if (move.newFile.isDirectory() && !move.newFile.isSymlink()) {
        let oldDir = getFile(move.oldFile.leafName, move.oldFile.parent);
        oldDir.create(Ci.nsIFile.DIRECTORY_TYPE, FileUtils.PERMS_DIRECTORY);
      } else if (!move.oldFile) {
        // No old file means this was a copied file
        move.newFile.remove(true);
      } else {
        move.newFile.moveTo(move.oldFile.parent, null);
      }
    }

    while (this._createdDirs.length > 0)
      recursiveRemove(this._createdDirs.pop());
  }
};

/**
 * Sets the userDisabled and softDisabled properties of an add-on based on what
 * values those properties had for a previous instance of the add-on. The
 * previous instance may be a previous install or in the case of an application
 * version change the same add-on.
 *
 * NOTE: this may modify aNewAddon in place; callers should save the database if
 * necessary
 *
 * @param  aOldAddon
 *         The previous instance of the add-on
 * @param  aNewAddon
 *         The new instance of the add-on
 * @param  aAppVersion
 *         The optional application version to use when checking the blocklist
 *         or undefined to use the current application
 * @param  aPlatformVersion
 *         The optional platform version to use when checking the blocklist or
 *         undefined to use the current platform
 */
function applyBlocklistChanges(aOldAddon, aNewAddon, aOldAppVersion,
                               aOldPlatformVersion) {
  // Copy the properties by default
  aNewAddon.userDisabled = aOldAddon.userDisabled;
  aNewAddon.softDisabled = aOldAddon.softDisabled;

  let oldBlocklistState = Blocklist.getAddonBlocklistState(aOldAddon.wrapper,
                                                           aOldAppVersion,
                                                           aOldPlatformVersion);
  let newBlocklistState = Blocklist.getAddonBlocklistState(aNewAddon.wrapper);

  // If the blocklist state hasn't changed then the properties don't need to
  // change
  if (newBlocklistState == oldBlocklistState)
    return;

  if (newBlocklistState == Blocklist.STATE_SOFTBLOCKED) {
    if (aNewAddon.type != "theme") {
      // The add-on has become softblocked, set softDisabled if it isn't already
      // userDisabled
      aNewAddon.softDisabled = !aNewAddon.userDisabled;
    } else {
      // Themes just get userDisabled to switch back to the default theme
      aNewAddon.userDisabled = true;
    }
  } else {
    // If the new add-on is not softblocked then it cannot be softDisabled
    aNewAddon.softDisabled = false;
  }
}

/**
 * Evaluates whether an add-on is allowed to run in safe mode.
 *
 * @param  aAddon
 *         The add-on to check
 * @return true if the add-on should run in safe mode
 */
function canRunInSafeMode(aAddon) {
  // Even though the updated system add-ons aren't generally run in safe mode we
  // include them here so their uninstall functions get called when switching
  // back to the default set.

  // TODO product should make the call about temporary add-ons running
  // in safe mode. assuming for now that they are.
  if (aAddon._installLocation.name == KEY_APP_TEMPORARY)
    return true;

  return aAddon._installLocation.isSystem;
}

/**
 * Calculates whether an add-on should be appDisabled or not.
 *
 * @param  aAddon
 *         The add-on to check
 * @return true if the add-on should not be appDisabled
 */
function isUsableAddon(aAddon) {
  // Hack to ensure the default theme is always usable
  if (aAddon.type == "theme" && aAddon.internalName == XPIProvider.defaultSkin)
    return true;

  if (mustSign(aAddon.type) && !aAddon.isCorrectlySigned) {
    logger.warn(`Add-on ${aAddon.id} is not correctly signed.`);
    if (Preferences.get(PREF_XPI_SIGNATURES_DEV_ROOT, false)) {
      logger.warn(`Preference ${PREF_XPI_SIGNATURES_DEV_ROOT} is set.`);
    }
    return false;
  }

  if (aAddon.blocklistState == nsIBlocklistService.STATE_BLOCKED) {
    logger.warn(`Add-on ${aAddon.id} is blocklisted.`);
    return false;
  }

  // Experiments are installed through an external mechanism that
  // limits target audience to compatible clients. We trust it knows what
  // it's doing and skip compatibility checks.
  //
  // This decision does forfeit defense in depth. If the experiments system
  // is ever wrong about targeting an add-on to a specific application
  // or platform, the client will likely see errors.
  if (aAddon.type == "experiment")
    return true;

  if (AddonManager.checkUpdateSecurity && !aAddon.providesUpdatesSecurely) {
    logger.warn(`Updates for add-on ${aAddon.id} must be provided over HTTPS.`);
    return false;
  }


  if (!aAddon.isPlatformCompatible) {
    logger.warn(`Add-on ${aAddon.id} is not compatible with platform.`);
    return false;
  }

  if (aAddon.dependencies.length) {
    let isActive = id => {
      let active = XPIProvider.activeAddons.get(id);
      return active && !active.disable;
    };

    if (aAddon.dependencies.some(id => !isActive(id)))
      return false;
  }

  if (!AddonSettings.ALLOW_LEGACY_EXTENSIONS &&
      aAddon.type == "extension" && !aAddon._installLocation.isSystem &&
      aAddon.signedState !== AddonManager.SIGNEDSTATE_PRIVILEGED) {
    logger.warn(`disabling legacy extension ${aAddon.id}`);
    return false;
  }

  if (!ALLOW_NON_MPC && aAddon.type == "extension" &&
      aAddon.multiprocessCompatible !== true) {
    logger.warn(`disabling ${aAddon.id} since it is not multiprocess compatible`);
    return false;
  }

  if (AddonManager.checkCompatibility) {
    if (!aAddon.isCompatible) {
      logger.warn(`Add-on ${aAddon.id} is not compatible with application version.`);
      return false;
    }
  } else {
    let app = aAddon.matchingTargetApplication;
    if (!app) {
      logger.warn(`Add-on ${aAddon.id} is not compatible with target application.`);
      return false;
    }

    // XXX Temporary solution to let applications opt-in to make themes safer
    //     following significant UI changes even if checkCompatibility=false has
    //     been set, until we get bug 962001.
    if (aAddon.type == "theme" && app.id == Services.appinfo.ID) {
      try {
        let minCompatVersion = Services.prefs.getCharPref(PREF_CHECKCOMAT_THEMEOVERRIDE);
        if (minCompatVersion &&
            Services.vc.compare(minCompatVersion, app.maxVersion) > 0) {
          logger.warn(`Theme ${aAddon.id} is not compatible with application version.`);
          return false;
        }
      } catch (e) {}
    }
  }

  return true;
}

function createAddonDetails(id, aAddon) {
  return {
    id: id || aAddon.id,
    type: aAddon.type,
    version: aAddon.version,
    multiprocessCompatible: aAddon.multiprocessCompatible,
    mpcOptedOut: aAddon.mpcOptedOut,
    runInSafeMode: aAddon.runInSafeMode,
    dependencies: aAddon.dependencies,
    hasEmbeddedWebExtension: aAddon.hasEmbeddedWebExtension,
  };
}

/**
 * Converts an internal add-on type to the type presented through the API.
 *
 * @param  aType
 *         The internal add-on type
 * @return an external add-on type
 */
function getExternalType(aType) {
  if (aType in TYPE_ALIASES)
    return TYPE_ALIASES[aType];
  return aType;
}

function getManifestFileForDir(aDir) {
  let file = getFile(FILE_RDF_MANIFEST, aDir);
  if (file.exists() && file.isFile())
    return file;
  file.leafName = FILE_WEB_MANIFEST;
  if (file.exists() && file.isFile())
    return file;
  return null;
}

/**
 * Converts a list of API types to a list of API types and any aliases for those
 * types.
 *
 * @param  aTypes
 *         An array of types or null for all types
 * @return an array of types or null for all types
 */
function getAllAliasesForTypes(aTypes) {
  if (!aTypes)
    return null;

  // Build a set of all requested types and their aliases
  let typeset = new Set(aTypes);

  for (let alias of Object.keys(TYPE_ALIASES)) {
    // Ignore any requested internal types
    typeset.delete(alias);

    // Add any alias for the internal type
    if (typeset.has(TYPE_ALIASES[alias]))
      typeset.add(alias);
  }

  return [...typeset];
}

/**
 * A synchronous method for loading an add-on's manifest. This should only ever
 * be used during startup or a sync load of the add-ons DB
 */
function syncLoadManifestFromFile(aFile, aInstallLocation) {
  let success = undefined;
  let result = null;

  loadManifestFromFile(aFile, aInstallLocation).then(val => {
    success = true;
    result = val;
  }, val => {
    success = false;
    result = val
  });

  let thread = Services.tm.currentThread;

  while (success === undefined)
    thread.processNextEvent(true);

  if (!success)
    throw result;
  return result;
}

/**
 * Gets an nsIURI for a file within another file, either a directory or an XPI
 * file. If aFile is a directory then this will return a file: URI, if it is an
 * XPI file then it will return a jar: URI.
 *
 * @param  aFile
 *         The file containing the resources, must be either a directory or an
 *         XPI file
 * @param  aPath
 *         The path to find the resource at, "/" separated. If aPath is empty
 *         then the uri to the root of the contained files will be returned
 * @return an nsIURI pointing at the resource
 */
function getURIForResourceInFile(aFile, aPath) {
  if (aFile.exists() && aFile.isDirectory()) {
    let resource = aFile.clone();
    if (aPath)
      aPath.split("/").forEach(part => resource.append(part));

    return Services.io.newFileURI(resource);
  }

  return buildJarURI(aFile, aPath);
}

/**
 * Creates a jar: URI for a file inside a ZIP file.
 *
 * @param  aJarfile
 *         The ZIP file as an nsIFile
 * @param  aPath
 *         The path inside the ZIP file
 * @return an nsIURI for the file
 */
function buildJarURI(aJarfile, aPath) {
  let uri = Services.io.newFileURI(aJarfile);
  uri = "jar:" + uri.spec + "!/" + aPath;
  return Services.io.newURI(uri);
}

/**
 * Sends local and remote notifications to flush a JAR file cache entry
 *
 * @param aJarFile
 *        The ZIP/XPI/JAR file as a nsIFile
 */
function flushJarCache(aJarFile) {
  Services.obs.notifyObservers(aJarFile, "flush-cache-entry");
  Services.mm.broadcastAsyncMessage(MSG_JAR_FLUSH, aJarFile.path);
}

function flushChromeCaches() {
  // Init this, so it will get the notification.
  Services.obs.notifyObservers(null, "startupcache-invalidate");
  // Flush message manager cached scripts
  Services.obs.notifyObservers(null, "message-manager-flush-caches");
  // Also dispatch this event to child processes
  Services.mm.broadcastAsyncMessage(MSG_MESSAGE_MANAGER_CACHES_FLUSH, null);
}

/**
 * Recursively removes a directory or file fixing permissions when necessary.
 *
 * @param  aFile
 *         The nsIFile to remove
 */
function recursiveRemove(aFile) {
  let isDir = null;

  try {
    isDir = aFile.isDirectory();
  } catch (e) {
    // If the file has already gone away then don't worry about it, this can
    // happen on OSX where the resource fork is automatically moved with the
    // data fork for the file. See bug 733436.
    if (e.result == Cr.NS_ERROR_FILE_TARGET_DOES_NOT_EXIST)
      return;
    if (e.result == Cr.NS_ERROR_FILE_NOT_FOUND)
      return;

    throw e;
  }

  setFilePermissions(aFile, isDir ? FileUtils.PERMS_DIRECTORY
                                  : FileUtils.PERMS_FILE);

  try {
    aFile.remove(true);
    return;
  } catch (e) {
    if (!aFile.isDirectory() || aFile.isSymlink()) {
      logger.error("Failed to remove file " + aFile.path, e);
      throw e;
    }
  }

  // Use a snapshot of the directory contents to avoid possible issues with
  // iterating over a directory while removing files from it (the YAFFS2
  // embedded filesystem has this issue, see bug 772238), and to remove
  // normal files before their resource forks on OSX (see bug 733436).
  let entries = getDirectoryEntries(aFile, true);
  entries.forEach(recursiveRemove);

  try {
    aFile.remove(true);
  } catch (e) {
    logger.error("Failed to remove empty directory " + aFile.path, e);
    throw e;
  }
}

/**
 * Gets a snapshot of directory entries.
 *
 * @param  aDir
 *         Directory to look at
 * @param  aSortEntries
 *         True to sort entries by filename
 * @return An array of nsIFile, or an empty array if aDir is not a readable directory
 */
function getDirectoryEntries(aDir, aSortEntries) {
  let dirEnum;
  try {
    dirEnum = aDir.directoryEntries.QueryInterface(Ci.nsIDirectoryEnumerator);
    let entries = [];
    while (dirEnum.hasMoreElements())
      entries.push(dirEnum.nextFile);

    if (aSortEntries) {
      entries.sort(function(a, b) {
        return a.path > b.path ? -1 : 1;
      });
    }

    return entries
  } catch (e) {
    if (aDir.exists()) {
      logger.warn("Can't iterate directory " + aDir.path, e);
    }
    return [];
  } finally {
    if (dirEnum) {
      dirEnum.close();
    }
  }
}

/**
 * Record a bit of per-addon telemetry
 * @param aAddon the addon to record
 */
function recordAddonTelemetry(aAddon) {
  let locale = aAddon.defaultLocale;
  if (locale) {
    if (locale.name)
      XPIProvider.setTelemetry(aAddon.id, "name", locale.name);
    if (locale.creator)
      XPIProvider.setTelemetry(aAddon.id, "creator", locale.creator);
  }
}

/**
 * The on-disk state of an individual XPI, created from an Object
 * as stored in the addonStartup.json file.
 */
const JSON_FIELDS = Object.freeze([
  "bootstrapped",
  "changed",
  "dependencies",
  "enabled",
  "enableShims",
  "file",
  "hasEmbeddedWebExtension",
  "lastModifiedTime",
  "path",
  "runInSafeMode",
  "type",
  "version",
]);

const BOOTSTRAPPED_FIELDS = Object.freeze([
  "dependencies",
  "hasEmbeddedWebExtension",
  "runInSafeMode",
  "type",
  "version",
]);

class XPIState {
  constructor(location, id, saved = {}) {
    this.location = location;
    this.id = id;

    // Set default values.
    this.type = "extension";
    this.bootstrapped = false;
    this.enableShims = false;

    for (let prop of JSON_FIELDS) {
      if (prop in saved) {
        this[prop] = saved[prop];
      }
    }

    if (saved.currentModifiedTime && saved.currentModifiedTime != this.lastModifiedTime) {
      this.lastModifiedTime = saved.currentModifiedTime;
      this.changed = true;
    }

    if (this.enabled) {
      XPIProvider._addURIMapping(id, this.file);
    }
  }

  /**
   * Migrates an add-on's data from xpiState and bootstrappedAddons
   * preferences, and returns an XPIState object for it.
   *
   * @param {XPIStateLocation} location
   *        The location of the add-on.
   * @param {string} id
   *        The ID of the add-on to migrate.
   * @param {object} state
   *        The add-on's data from the xpiState preference.
   * @param {object} [bootstrapped]
   *        The add-on's data from the bootstrappedAddons preference, if
   *        applicable.
   */
  static migrate(location, id, saved, bootstrapped) {
    let data = {
      enabled: saved.e,
      path: descriptorToPath(saved.d, location.dir),
      lastModifiedTime: saved.mt || saved.st,
      version: saved.v,
      enableShims: false,
    };

    if (bootstrapped) {
      data.bootstrapped = true;
      data.enabled = true;
      data.enableShims = !bootstrapped.multiprocessCompatible;
      data.path = descriptorToPath(bootstrapped.descriptor, location.dir);

      for (let field of BOOTSTRAPPED_FIELDS) {
        if (field in bootstrapped) {
          data[field] = bootstrapped[field];
        }
      }
    }

    return new XPIState(location, id, data);
  }

  // Compatibility shim getters for legacy callers in XPIProviderUtils:
  get mtime() {
    return this.lastModifiedTime;
  }
  get active() {
    return this.enabled;
  }
  get multiprocessCompatible() {
    return !this.enableShims;
  }


  /**
   * @property {string} path
   *        The full on-disk path of the add-on.
   */
  get path() {
    return this.file && this.file.path;
  }
  set path(path) {
    this.file = getFile(path, this.location.dir)
  }

  /**
   * @property {string} relativePath
   *        The path to the add-on relative to its parent location, or
   *        the full path if its parent location has no on-disk path.
   */
  get relativePath() {
    if (this.location.dir && this.location.dir.contains(this.file)) {
      let path = this.file.getRelativePath(this.location.dir);
      if (AppConstants.platform == "win") {
        path = path.replace(/\//g, "\\");
      }
      return path;
    }
    return this.path;
  }

  /**
   * Returns a JSON-compatible representation of this add-on's state
   * data, to be saved to addonStartup.json.
   */
  toJSON() {
    let json = {
      enabled: this.enabled,
      lastModifiedTime: this.lastModifiedTime,
      path: this.relativePath,
      version: this.version,
    };
    if (this.type != "extension") {
      json.type = this.type;
    }
    if (this.enableShims) {
      json.enableShims = true;
    }
    if (this.bootstrapped) {
      json.bootstrapped = true;
      json.dependencies = this.dependencies;
      json.runInSafeMode = this.runInSafeMode;
      json.hasEmbeddedWebExtension = this.hasEmbeddedWebExtension;
    }
    return json;
  }

  /**
   * Update the last modified time for an add-on on disk.
   * @param aFile: nsIFile path of the add-on.
   * @param aId: The add-on ID.
   * @return True if the time stamp has changed.
   */
  getModTime(aFile, aId) {
    // Modified time is the install manifest time, if any. If no manifest
    // exists, we assume this is a packed .xpi and use the time stamp of
    // {path}
    let mtime = (tryGetMtime(getManifestFileForDir(aFile)) ||
                 tryGetMtime(aFile));
    if (!mtime) {
      logger.warn("Can't get modified time of ${file}", {file: aFile.path});
    }

    this.changed = mtime != this.lastModifiedTime;
    this.lastModifiedTime = mtime;
    return this.changed;
  }

  /**
   * Update the XPIState to match an XPIDatabase entry; if 'enabled' is changed to true,
   * update the last-modified time. This should probably be made async, but for now we
   * don't want to maintain parallel sync and async versions of the scan.
   * Caller is responsible for doing XPIStates.save() if necessary.
   * @param aDBAddon The DBAddonInternal for this add-on.
   * @param aUpdated The add-on was updated, so we must record new modified time.
   */
  syncWithDB(aDBAddon, aUpdated = false) {
    logger.debug("Updating XPIState for " + JSON.stringify(aDBAddon));
    // If the add-on changes from disabled to enabled, we should re-check the modified time.
    // If this is a newly found add-on, it won't have an 'enabled' field but we
    // did a full recursive scan in that case, so we don't need to do it again.
    // We don't use aDBAddon.active here because it's not updated until after restart.
    let mustGetMod = (aDBAddon.visible && !aDBAddon.disabled && !this.enabled);

    // We need to treat XUL themes specially here, since lightweight
    // themes require the default theme's chrome to be registered even
    // though we report it as disabled for UI purposes.
    if (aDBAddon.type == "theme") {
      this.enabled = aDBAddon.internalName == XPIProvider.selectedSkin;
    } else {
      this.enabled = aDBAddon.visible && !aDBAddon.disabled;
    }

    this.version = aDBAddon.version;
    this.type = aDBAddon.type;
    this.enableShims = this.type == "extension" && !aDBAddon.multiprocessCompatible;

    this.bootstrapped = !!aDBAddon.bootstrap;
    if (this.bootstrapped) {
      this.hasEmbeddedWebExtension = aDBAddon.hasEmbeddedWebExtension;
      this.dependencies = aDBAddon.dependencies;
      this.runInSafeMode = canRunInSafeMode(aDBAddon);
    }

    if (aUpdated || mustGetMod) {
      this.getModTime(this.file, aDBAddon.id);
      if (this.lastModifiedTime != aDBAddon.updateDate) {
        aDBAddon.updateDate = this.lastModifiedTime;
        if (XPIDatabase.initialized) {
          XPIDatabase.saveChanges();
        }
      }
    }
  }
}

/**
 * Manages the state data for add-ons in a given install location.
 *
 * @param {string} name
 *        The name of the install location (e.g., "app-profile").
 * @param {string?} path
 *        The on-disk path of the install location. May be null for some
 *        locations which do not map to a specific on-disk path.
 * @param {object} [saved = {}]
 *        The persisted JSON state data to restore.
 */
class XPIStateLocation extends Map {
  constructor(name, path, saved = {}) {
    super();

    this.name = name;
    this.path = path || saved.path || null;
    this.dir = this.path && new nsIFile(this.path);

    for (let [id, data] of Object.entries(saved.addons || {})) {
      let xpiState = this._addState(id, data);
      // Make a note that this state was restored from saved data.
      xpiState.wasRestored = true;
    }
  }

  /**
   * Returns a JSON-compatible representation of this location's state
   * data, to be saved to addonStartup.json.
   */
  toJSON() {
    let json = { addons: {} };

    if (this.path) {
      json.path = this.path;
    }

    if (STARTUP_MTIME_SCOPES.includes(this.name)) {
      json.checkStartupModifications = true;
    }

    for (let [id, addon] of this.entries()) {
      if (addon.type != "experiment") {
        json.addons[id] = addon;
      }
    }
    return json;
  }

  _addState(addonId, saved) {
    let xpiState = new XPIState(this, addonId, saved);
    this.set(addonId, xpiState);
    return xpiState;
  }

  /**
   * Adds state data for the given DB add-on to the DB.
   *
   * @param {DBAddon} addon
   *        The DBAddon to add.
   */
  addAddon(addon) {
    logger.debug("XPIStates adding add-on ${id} in ${location}: ${path}", addon);

    let xpiState = this._addState(addon.id, {file: addon._sourceBundle});
    xpiState.syncWithDB(addon, true);

    XPIProvider.setTelemetry(addon.id, "location", this.name);
  }

  /**
   * Adds stub state data for the local file to the DB.
   *
   * @param {string} addonId
   *        The ID of the add-on represented by the given file.
   * @param {nsIFile} file
   *        The local file or directory containing the add-on.
   * @returns {XPIState}
   */
  addFile(addonId, file) {
    let xpiState = this._addState(addonId, {enabled: true, file: file.clone()});
    xpiState.getModTime(xpiState.file, addonId);
    return xpiState;
  }

  /**
   * Migrates saved state data for the given add-on from the values
   * stored in xpiState and bootstrappedAddons preferences, and adds it to
   * the DB.
   *
   * @param {string} id
   *        The ID of the add-on to migrate.
   * @param {object} state
   *        The add-on's data from the xpiState preference.
   * @param {object} [bootstrapped]
   *        The add-on's data from the bootstrappedAddons preference, if
   *        applicable.
   */
  migrateAddon(id, state, bootstrapped) {
    this.set(id, XPIState.migrate(this, id, state, bootstrapped));
  }
}

/**
 * Keeps track of the state of XPI add-ons on the file system.
 */
this.XPIStates = {
  // Map(location name -> Map(add-on ID -> XPIState))
  db: null,

  _jsonFile: null,

  /**
   * @property {Map<string, XPIState>} sideLoadedAddons
   *        A map of new add-ons detected during install location
   *        directory scans. Keys are add-on IDs, values are XPIState
   *        objects corresponding to those add-ons.
   */
  sideLoadedAddons: new Map(),

  get size() {
    let count = 0;
    if (this.db) {
      for (let location of this.db.values()) {
        count += location.size;
      }
    }
    return count;
  },

  /**
   * Migrates state data from the xpiState and bootstrappedAddons
   * preferences and adds it to the DB. Returns a JSON-compatible
   * representation of the current state of the DB.
   *
   * @returns {object}
   */
  migrateStateFromPrefs() {
    logger.info("No addonStartup.json found. Attempting to migrate data from preferences");

    let state;
    // Try to migrate state data from old storage locations.
    let bootstrappedAddons;
    try {
      state = JSON.parse(Preferences.get(PREF_XPI_STATE));
      bootstrappedAddons = JSON.parse(Preferences.get(PREF_BOOTSTRAP_ADDONS, "{}"));
    } catch (e) {
      logger.warn("Error parsing extensions.xpiState and " +
                  "extensions.bootstrappedAddons: ${error}",
                  {error: e});

    }

    for (let [locName, addons] of Object.entries(state)) {
      for (let [id, addon] of Object.entries(addons)) {
        let loc = this.getLocation(locName);
        if (loc) {
          loc.migrateAddon(id, addon, bootstrappedAddons[id] || null);
        }
      }
    }

    // Clear out old state data.
    for (let pref of OBSOLETE_PREFERENCES) {
      Preferences.reset(pref);
    }
    OS.File.remove(OS.Path.join(OS.Constants.Path.profileDir,
                                FILE_XPI_ADDONS_LIST));

    // Serialize and deserialize so we get the expected JSON data.
    let data = JSON.parse(JSON.stringify(this));

    logger.debug("Migrated data: ${}", data);

    return data;
  },

  /**
   * Load extension state data from addonStartup.json, or migrates it
   * from legacy state preferences, if they exist.
   */
  loadExtensionState() {
    let state;
    try {
      state = aomStartup.readStartupData();
    } catch (e) {
      logger.warn("Error parsing extensions state: ${error}",
                  {error: e});
    }

    if (!state && Preferences.has(PREF_XPI_STATE)) {
      try {
        state = this.migrateStateFromPrefs();
      } catch (e) {
        logger.warn("Error migrating extensions.xpiState and " +
                    "extensions.bootstrappedAddons: ${error}",
                    {error: e});
      }
    }

    logger.debug("Loaded add-on state: ${}", state);
    return state || {};
  },

  /**
   * Walk through all install locations, highest priority first,
   * comparing the on-disk state of extensions to what is stored in prefs.
   *
   * @param {bool} [ignoreSideloads = true]
   *        If true, ignore changes in scopes where we don't accept
   *        side-loads.
   *
   * @return true if anything has changed.
   */
  getInstallState(ignoreSideloads = true) {
    if (!this.db) {
      this.db = new Map();
    }

    let oldState = this.initialStateData || this.loadExtensionState();
    this.initialStateData = oldState;

    let changed = false;
    let oldLocations = new Set(Object.keys(oldState));

    for (let location of XPIProvider.installLocations) {
      oldLocations.delete(location.name);

      // The results of scanning this location.
      let loc = this.getLocation(location.name, location.path || null,
                                 oldState[location.name]);
      changed = changed || loc.changed;

      // Don't bother checking scopes where we don't accept side-loads.
      if (ignoreSideloads && !(location.scope & gStartupScanScopes)) {
        continue;
      }

      if (location.name == KEY_APP_TEMPORARY) {
        continue;
      }

      let knownIds = new Set(loc.keys());
      for (let [id, file] of location.getAddonLocations(true)) {
        knownIds.delete(id);

        let xpiState = loc.get(id);
        if (!xpiState) {
          logger.debug("New add-on ${id} in ${location}", {id, location: location.name});

          changed = true;
          xpiState = loc.addFile(id, file);
          if (!location.isSystem) {
            this.sideLoadedAddons.set(id, xpiState);
          }
        } else {
          let addonChanged = (xpiState.getModTime(file, id) ||
                              file.path != xpiState.path);
          xpiState.file = file.clone();

          if (addonChanged) {
            changed = true;
            logger.debug("Changed add-on ${id} in ${location}", {id, location: location.name});
          } else {
            logger.debug("Existing add-on ${id} in ${location}", {id, location: location.name});
          }
        }
        XPIProvider.setTelemetry(id, "location", location.name);
      }

      // Anything left behind in oldState was removed from the file system.
      for (let id of knownIds) {
        loc.delete(id);
        changed = true;
      }
    }

    // If there's anything left in oldState, an install location that held add-ons
    // was removed from the browser configuration.
    changed = changed || oldLocations.size > 0;

    logger.debug("getInstallState changed: ${rv}, state: ${state}",
        {rv: changed, state: this.db});
    return changed;
  },

  /**
   * Get the Map of XPI states for a particular location.
   * @param name The name of the install location.
   * @return XPIStateLocation (id -> XPIState) or null if there are no add-ons in the location.
   */
  getLocation(name, path, saved) {
    let location = this.db.get(name);

    if (path && location && location.path != path) {
      location = null;
      saved = null;
    }

    if (!location || (path && location.path != path)) {
      let loc = XPIProvider.installLocationsByName[name];
      if (loc) {
        location = new XPIStateLocation(name, path || loc.path || null, saved);
        this.db.set(name, location);
      }
    }
    return location;
  },

  /**
   * Get the XPI state for a specific add-on in a location.
   * If the state is not in our cache, return null.
   * @param aLocation The name of the location where the add-on is installed.
   * @param aId       The add-on ID
   * @return The XPIState entry for the add-on, or null.
   */
  getAddon(aLocation, aId) {
    let location = this.db.get(aLocation);
    return location && location.get(aId);
  },

  /**
   * Find the highest priority location of an add-on by ID and return the
   * location and the XPIState.
   * @param aId   The add-on ID
   * @return {XPIState?}
   */
  findAddon(aId) {
    // Fortunately the Map iterator returns in order of insertion, which is
    // also our highest -> lowest priority order.
    for (let location of this.db.values()) {
      if (location.has(aId)) {
        return location.get(aId);
      }
    }
    return undefined;
  },

  /**
   * Iterates over the list of all enabled add-ons in any location.
   */
  * enabledAddons() {
    for (let location of this.db.values()) {
      for (let entry of location.values()) {
        if (entry.enabled) {
          yield entry;
        }
      }
    }
  },

  /**
   * Iterates over the list of all add-ons which were initially restored
   * from the startup state cache.
   */
  * initialEnabledAddons() {
    for (let addon of this.enabledAddons()) {
      if (addon.wasRestored) {
        yield addon;
      }
    }
  },

  /**
   * Iterates over all enabled bootstrapped add-ons, in any location.
   */
  * bootstrappedAddons() {
    for (let addon of this.enabledAddons()) {
      if (addon.bootstrapped) {
        yield addon;
      }
    }
  },

  /**
   * Add a new XPIState for an add-on and synchronize it with the DBAddonInternal.
   * @param aAddon DBAddonInternal for the new add-on.
   */
  addAddon(aAddon) {
    let location = this.getLocation(aAddon._installLocation.name);
    location.addAddon(aAddon);
  },

  /**
   * Save the current state of installed add-ons.
   */
  save() {
    if (!this._jsonFile) {
      this._jsonFile = new JSONFile({
        path: OS.Path.join(OS.Constants.Path.profileDir, FILE_XPI_STATES),
        finalizeAt: AddonManager.shutdown,
        compression: "lz4",
      })
      this._jsonFile.data = this;
    }

    this._jsonFile.saveSoon();
  },

  toJSON() {
    let data = {};
    for (let [key, loc] of this.db.entries()) {
      if (key != TemporaryInstallLocation.name && loc.size) {
        data[key] = loc;
      }
    }
    return data;
  },

  /**
   * Remove the XPIState for an add-on and save the new state.
   * @param aLocation  The name of the add-on location.
   * @param aId        The ID of the add-on.
   */
  removeAddon(aLocation, aId) {
    logger.debug("Removing XPIState for " + aLocation + ":" + aId);
    let location = this.db.get(aLocation);
    if (location) {
      location.delete(aId);
      if (location.size == 0) {
        this.db.delete(aLocation);
      }
      this.save();
    }
  },

  /**
   * Disable the XPIState for an add-on.
   */
  disableAddon(aId) {
    logger.debug(`Disabling XPIState for ${aId}`);
    let state = this.findAddon(aId);
    if (state) {
      state.enabled = false;
    }
  },
};

this.XPIProvider = {
  get name() {
    return "XPIProvider";
  },

  // An array of known install locations
  installLocations: null,
  // A dictionary of known install locations by name
  installLocationsByName: null,
  // An array of currently active AddonInstalls
  installs: null,
  // The default skin for the application
  defaultSkin: "classic/1.0",
  // The current skin used by the application
  currentSkin: null,
  // The selected skin to be used by the application when it is restarted. This
  // will be the same as currentSkin when it is the skin to be used when the
  // application is restarted
  selectedSkin: null,
  // The value of the minCompatibleAppVersion preference
  minCompatibleAppVersion: null,
  // The value of the minCompatiblePlatformVersion preference
  minCompatiblePlatformVersion: null,
  // A Map of active addons to their bootstrapScope by ID
  activeAddons: new Map(),
  // True if the platform could have activated extensions
  extensionsActive: false,
  // True if all of the add-ons found during startup were installed in the
  // application install location
  allAppGlobal: true,
  // Keep track of startup phases for telemetry
  runPhase: XPI_STARTING,
  // Per-addon telemetry information
  _telemetryDetails: {},
  // A Map from an add-on install to its ID
  _addonFileMap: new Map(),
  // Flag to know if ToolboxProcess.jsm has already been loaded by someone or not
  _toolboxProcessLoaded: false,
  // Have we started shutting down bootstrap add-ons?
  _closing: false,

  // Check if the XPIDatabase has been loaded (without actually
  // triggering unwanted imports or I/O)
  get isDBLoaded() {
    return gLazyObjectsLoaded && XPIDatabase.initialized;
  },

  /**
   * Returns true if the add-on with the given ID is currently active,
   * without forcing the add-ons database to load.
   *
   * @param {string} addonId
   *        The ID of the add-on to check.
   * @returns {boolean}
   */
  addonIsActive(addonId) {
    let state = XPIStates.findAddon(addonId);
    return state && state.enabled;
  },

  /**
   * Returns an array of the add-on values in `bootstrappedAddons`,
   * sorted so that all of an add-on's dependencies appear in the array
   * before itself.
   *
   * @returns {Array<object>}
   *   A sorted array of add-on objects. Each value is a copy of the
   *   corresponding value in the `bootstrappedAddons` object, with an
   *   additional `id` property, which corresponds to the key in that
   *   object, which is the same as the add-ons ID.
   */
  sortBootstrappedAddons() {
    function compare(a, b) {
      if (a === b) {
        return 0;
      }
      return (a < b) ? -1 : 1;
    }

    // Sort the list so that ordering is deterministic.
    let list = Array.from(XPIStates.bootstrappedAddons());
    list.sort((a, b) => compare(a.id, b.id));

    let addons = {};
    for (let entry of list) {
      addons[entry.id] = entry;
    }

    let res = new Set();
    let seen = new Set();

    let add = addon => {
      seen.add(addon.id);

      for (let id of addon.dependencies || []) {
        if (id in addons && !seen.has(id)) {
          add(addons[id]);
        }
      }

      res.add(addon.id);
    }

    Object.values(addons).forEach(add);

    return Array.from(res, id => addons[id]);
  },

  /*
   * Set a value in the telemetry hash for a given ID
   */
  setTelemetry(aId, aName, aValue) {
    if (!this._telemetryDetails[aId])
      this._telemetryDetails[aId] = {};
    this._telemetryDetails[aId][aName] = aValue;
  },

  // Keep track of in-progress operations that support cancel()
  _inProgress: [],

  doing(aCancellable) {
    this._inProgress.push(aCancellable);
  },

  done(aCancellable) {
    let i = this._inProgress.indexOf(aCancellable);
    if (i != -1) {
      this._inProgress.splice(i, 1);
      return true;
    }
    return false;
  },

  cancelAll() {
    // Cancelling one may alter _inProgress, so don't use a simple iterator
    while (this._inProgress.length > 0) {
      let c = this._inProgress.shift();
      try {
        c.cancel();
      } catch (e) {
        logger.warn("Cancel failed", e);
      }
    }
  },

  /**
   * Adds or updates a URI mapping for an Addon.id.
   *
   * Mappings should not be removed at any point. This is so that the mappings
   * will be still valid after an add-on gets disabled or uninstalled, as
   * consumers may still have URIs of (leaked) resources they want to map.
   */
  _addURIMapping(aID, aFile) {
    logger.info("Mapping " + aID + " to " + aFile.path);
    this._addonFileMap.set(aID, aFile.path);

    AddonPathService.insertPath(aFile.path, aID);
  },

  /**
   * Resolve a URI back to physical file.
   *
   * Of course, this works only for URIs pointing to local resources.
   *
   * @param  aURI
   *         URI to resolve
   * @return
   *         resolved nsIFileURL
   */
  _resolveURIToFile(aURI) {
    switch (aURI.scheme) {
      case "jar":
      case "file":
        if (aURI instanceof Ci.nsIJARURI) {
          return this._resolveURIToFile(aURI.JARFile);
        }
        return aURI;

      case "chrome":
        aURI = ChromeRegistry.convertChromeURL(aURI);
        return this._resolveURIToFile(aURI);

      case "resource":
        aURI = Services.io.newURI(ResProtocolHandler.resolveURI(aURI));
        return this._resolveURIToFile(aURI);

      case "view-source":
        aURI = Services.io.newURI(aURI.path);
        return this._resolveURIToFile(aURI);

      case "about":
        if (aURI.spec == "about:blank") {
          // Do not attempt to map about:blank
          return null;
        }

        let chan;
        try {
          chan = NetUtil.newChannel({
            uri: aURI,
            loadUsingSystemPrincipal: true
          });
        } catch (ex) {
          return null;
        }
        // Avoid looping
        if (chan.URI.equals(aURI)) {
          return null;
        }
        // We want to clone the channel URI to avoid accidentially keeping
        // unnecessary references to the channel or implementation details
        // around.
        return this._resolveURIToFile(chan.URI.clone());

      default:
        return null;
    }
  },

  /**
   * Starts the XPI provider initializes the install locations and prefs.
   *
   * @param  aAppChanged
   *         A tri-state value. Undefined means the current profile was created
   *         for this session, true means the profile already existed but was
   *         last used with an application with a different version number,
   *         false means that the profile was last used by this version of the
   *         application.
   * @param  aOldAppVersion
   *         The version of the application last run with this profile or null
   *         if it is a new profile or the version is unknown
   * @param  aOldPlatformVersion
   *         The version of the platform last run with this profile or null
   *         if it is a new profile or the version is unknown
   */
  startup(aAppChanged, aOldAppVersion, aOldPlatformVersion) {
    function addDirectoryInstallLocation(aName, aKey, aPaths, aScope, aLocked) {
      try {
        var dir = FileUtils.getDir(aKey, aPaths);
      } catch (e) {
        // Some directories aren't defined on some platforms, ignore them
        logger.debug("Skipping unavailable install location " + aName);
        return;
      }

      try {
        var location = aLocked ? new DirectoryInstallLocation(aName, dir, aScope)
                               : new MutableDirectoryInstallLocation(aName, dir, aScope);
      } catch (e) {
        logger.warn("Failed to add directory install location " + aName, e);
        return;
      }

      XPIProvider.installLocations.push(location);
      XPIProvider.installLocationsByName[location.name] = location;
    }

    function addSystemAddonInstallLocation(aName, aKey, aPaths, aScope) {
      try {
        var dir = FileUtils.getDir(aKey, aPaths);
      } catch (e) {
        // Some directories aren't defined on some platforms, ignore them
        logger.debug("Skipping unavailable install location " + aName);
        return;
      }

      try {
        var location = new SystemAddonInstallLocation(aName, dir, aScope, aAppChanged !== false);
      } catch (e) {
        logger.warn("Failed to add system add-on install location " + aName, e);
        return;
      }

      XPIProvider.installLocations.push(location);
      XPIProvider.installLocationsByName[location.name] = location;
    }

    function addRegistryInstallLocation(aName, aRootkey, aScope) {
      try {
        var location = new WinRegInstallLocation(aName, aRootkey, aScope);
      } catch (e) {
        logger.warn("Failed to add registry install location " + aName, e);
        return;
      }

      XPIProvider.installLocations.push(location);
      XPIProvider.installLocationsByName[location.name] = location;
    }

    try {
      AddonManagerPrivate.recordTimestamp("XPI_startup_begin");

      logger.debug("startup");
      this.runPhase = XPI_STARTING;
      this.installs = new Set();
      this.installLocations = [];
      this.installLocationsByName = {};
      // Hook for tests to detect when saving database at shutdown time fails
      this._shutdownError = null;
      // Clear this at startup for xpcshell test restarts
      this._telemetryDetails = {};
      // Register our details structure with AddonManager
      AddonManagerPrivate.setTelemetryDetails("XPI", this._telemetryDetails);

      let hasRegistry = ("nsIWindowsRegKey" in Ci);

      let enabledScopes = Preferences.get(PREF_EM_ENABLED_SCOPES,
                                          AddonManager.SCOPE_ALL);

      // These must be in order of priority, highest to lowest,
      // for processFileChanges etc. to work

      XPIProvider.installLocations.push(TemporaryInstallLocation);
      XPIProvider.installLocationsByName[TemporaryInstallLocation.name] =
        TemporaryInstallLocation;

      // The profile location is always enabled
      addDirectoryInstallLocation(KEY_APP_PROFILE, KEY_PROFILEDIR,
                                  [DIR_EXTENSIONS],
                                  AddonManager.SCOPE_PROFILE, false);

      addSystemAddonInstallLocation(KEY_APP_SYSTEM_ADDONS, KEY_PROFILEDIR,
                                    [DIR_SYSTEM_ADDONS],
                                    AddonManager.SCOPE_PROFILE);

      addDirectoryInstallLocation(KEY_APP_SYSTEM_DEFAULTS, KEY_APP_FEATURES,
                                  [], AddonManager.SCOPE_PROFILE, true);

      if (enabledScopes & AddonManager.SCOPE_USER) {
        addDirectoryInstallLocation(KEY_APP_SYSTEM_USER, "XREUSysExt",
                                    [Services.appinfo.ID],
                                    AddonManager.SCOPE_USER, true);
        if (hasRegistry) {
          addRegistryInstallLocation("winreg-app-user",
                                     Ci.nsIWindowsRegKey.ROOT_KEY_CURRENT_USER,
                                     AddonManager.SCOPE_USER);
        }
      }

      addDirectoryInstallLocation(KEY_APP_GLOBAL, KEY_ADDON_APP_DIR,
                                  [DIR_EXTENSIONS],
                                  AddonManager.SCOPE_APPLICATION, true);

      if (enabledScopes & AddonManager.SCOPE_SYSTEM) {
        addDirectoryInstallLocation(KEY_APP_SYSTEM_SHARE, "XRESysSExtPD",
                                    [Services.appinfo.ID],
                                    AddonManager.SCOPE_SYSTEM, true);
        addDirectoryInstallLocation(KEY_APP_SYSTEM_LOCAL, "XRESysLExtPD",
                                    [Services.appinfo.ID],
                                    AddonManager.SCOPE_SYSTEM, true);
        if (hasRegistry) {
          addRegistryInstallLocation("winreg-app-global",
                                     Ci.nsIWindowsRegKey.ROOT_KEY_LOCAL_MACHINE,
                                     AddonManager.SCOPE_SYSTEM);
        }
      }

      let defaultPrefs = new Preferences({ defaultBranch: true });
      this.defaultSkin = defaultPrefs.get(PREF_GENERAL_SKINS_SELECTEDSKIN,
                                          "classic/1.0");
      this.currentSkin = Preferences.get(PREF_GENERAL_SKINS_SELECTEDSKIN,
                                         this.defaultSkin);
      this.selectedSkin = this.currentSkin;
      this.applyThemeChange();

      this.minCompatibleAppVersion = Preferences.get(PREF_EM_MIN_COMPAT_APP_VERSION,
                                                     null);
      this.minCompatiblePlatformVersion = Preferences.get(PREF_EM_MIN_COMPAT_PLATFORM_VERSION,
                                                          null);

      Services.prefs.addObserver(PREF_EM_MIN_COMPAT_APP_VERSION, this);
      Services.prefs.addObserver(PREF_EM_MIN_COMPAT_PLATFORM_VERSION, this);
      Services.prefs.addObserver(PREF_E10S_ADDON_BLOCKLIST, this);
      Services.prefs.addObserver(PREF_E10S_ADDON_POLICY, this);
      if (!AppConstants.MOZ_REQUIRE_SIGNING || Cu.isInAutomation)
        Services.prefs.addObserver(PREF_XPI_SIGNATURES_REQUIRED, this);
      Services.prefs.addObserver(PREF_ALLOW_LEGACY, this);
      Services.prefs.addObserver(PREF_ALLOW_NON_MPC, this);
      Services.obs.addObserver(this, NOTIFICATION_FLUSH_PERMISSIONS);

      // Cu.isModuleLoaded can fail here for external XUL apps where there is
      // no chrome.manifest that defines resource://devtools.
      if (ResProtocolHandler.hasSubstitution("devtools")) {
        if (Cu.isModuleLoaded("resource://devtools/client/framework/ToolboxProcess.jsm")) {
          // If BrowserToolboxProcess is already loaded, set the boolean to true
          // and do whatever is needed
          this._toolboxProcessLoaded = true;
          BrowserToolboxProcess.on("connectionchange",
                                   this.onDebugConnectionChange.bind(this));
        } else {
          // Else, wait for it to load
          Services.obs.addObserver(this, NOTIFICATION_TOOLBOXPROCESS_LOADED);
        }
      }


      let flushCaches = this.checkForChanges(aAppChanged, aOldAppVersion,
                                             aOldPlatformVersion);

      // Changes to installed extensions may have changed which theme is selected
      this.applyThemeChange();

      AddonManagerPrivate.markProviderSafe(this);

      if (aAppChanged && !this.allAppGlobal &&
          Preferences.get(PREF_EM_SHOW_MISMATCH_UI, true)) {
        let addonsToUpdate = this.shouldForceUpdateCheck(aAppChanged);
        if (addonsToUpdate) {
          this.showUpgradeUI(addonsToUpdate);
          flushCaches = true;
        }
      }

      if (flushCaches) {
        Services.obs.notifyObservers(null, "startupcache-invalidate");
        // UI displayed early in startup (like the compatibility UI) may have
        // caused us to cache parts of the skin or locale in memory. These must
        // be flushed to allow extension provided skins and locales to take full
        // effect
        Services.obs.notifyObservers(null, "chrome-flush-skin-caches");
        Services.obs.notifyObservers(null, "chrome-flush-caches");
      }

      if ("nsICrashReporter" in Ci &&
          Services.appinfo instanceof Ci.nsICrashReporter) {
        // Annotate the crash report with relevant add-on information.
        try {
          Services.appinfo.annotateCrashReport("Theme", this.currentSkin);
        } catch (e) { }
        try {
          Services.appinfo.annotateCrashReport("EMCheckCompatibility",
                                               AddonManager.checkCompatibility);
        } catch (e) { }
        this.addAddonsToCrashReporter();
      }

      try {
        AddonManagerPrivate.recordTimestamp("XPI_bootstrap_addons_begin");

        for (let addon of this.sortBootstrappedAddons()) {
          try {
            let reason = BOOTSTRAP_REASONS.APP_STARTUP;
            // Eventually set INSTALLED reason when a bootstrap addon
            // is dropped in profile folder and automatically installed
            if (AddonManager.getStartupChanges(AddonManager.STARTUP_CHANGE_INSTALLED)
                            .indexOf(addon.id) !== -1)
              reason = BOOTSTRAP_REASONS.ADDON_INSTALL;
            this.callBootstrapMethod(createAddonDetails(addon.id, addon),
                                     addon.file, "startup", reason);
          } catch (e) {
            logger.error("Failed to load bootstrap addon " + addon.id + " from " +
                         addon.descriptor, e);
          }
        }
        AddonManagerPrivate.recordTimestamp("XPI_bootstrap_addons_end");
      } catch (e) {
        logger.error("bootstrap startup failed", e);
        AddonManagerPrivate.recordException("XPI-BOOTSTRAP", "startup failed", e);
      }

      // Let these shutdown a little earlier when they still have access to most
      // of XPCOM
      Services.obs.addObserver({
        observe(aSubject, aTopic, aData) {
          XPIProvider._closing = true;
          for (let addon of XPIProvider.sortBootstrappedAddons().reverse()) {
            // If no scope has been loaded for this add-on then there is no need
            // to shut it down (should only happen when a bootstrapped add-on is
            // pending enable)
            if (!XPIProvider.activeAddons.has(addon.id))
              continue;

            let addonDetails = createAddonDetails(addon.id, addon);

            // If the add-on was pending disable then shut it down and remove it
            // from the persisted data.
            if (addon.disable) {
              XPIProvider.callBootstrapMethod(addonDetails, addon.file, "shutdown",
                                              BOOTSTRAP_REASONS.ADDON_DISABLE);
            } else {
              XPIProvider.callBootstrapMethod(addonDetails, addon.file, "shutdown",
                                              BOOTSTRAP_REASONS.APP_SHUTDOWN);
            }
          }
          Services.obs.removeObserver(this, "quit-application-granted");
        }
      }, "quit-application-granted");

      // Detect final-ui-startup for telemetry reporting
      Services.obs.addObserver({
        observe(aSubject, aTopic, aData) {
          AddonManagerPrivate.recordTimestamp("XPI_finalUIStartup");
          XPIProvider.runPhase = XPI_AFTER_UI_STARTUP;
          Services.obs.removeObserver(this, "final-ui-startup");
        }
      }, "final-ui-startup");

      // Once other important startup work is finished, try to load the
      // XPI database so that the telemetry environment can be populated
      // with detailed addon information.
      if (!this.isDBLoaded) {
        Services.obs.addObserver({
          observe(subject, topic, data) {
            Services.obs.removeObserver(this, "sessionstore-windows-restored");

            // It would be nice to defer some of the work here until we
            // have idle time but we can't yet use requestIdleCallback()
            // from chrome.  See bug 1358476.
            XPIDatabase.asyncLoadDB();
          },
        }, "sessionstore-windows-restored");
      }

      AddonManagerPrivate.recordTimestamp("XPI_startup_end");

      this.extensionsActive = true;
      this.runPhase = XPI_BEFORE_UI_STARTUP;

      let timerManager = Cc["@mozilla.org/updates/timer-manager;1"].
                         getService(Ci.nsIUpdateTimerManager);
      timerManager.registerTimer("xpi-signature-verification", () => {
        this.verifySignatures();
      }, XPI_SIGNATURE_CHECK_PERIOD);
    } catch (e) {
      logger.error("startup failed", e);
      AddonManagerPrivate.recordException("XPI", "startup failed", e);
    }
  },

  /**
   * Shuts down the database and releases all references.
   * Return: Promise{integer} resolves / rejects with the result of
   *                          flushing the XPI Database if it was loaded,
   *                          0 otherwise.
   */
  shutdown() {
    logger.debug("shutdown");

    // Stop anything we were doing asynchronously
    this.cancelAll();

    // Uninstall any temporary add-ons.
    let tempLocation = XPIStates.getLocation(TemporaryInstallLocation.name);
    if (tempLocation) {
      for (let [id, addon] of tempLocation.entries()) {
        tempLocation.delete(id);

        this.callBootstrapMethod(createAddonDetails(id, addon),
                                 addon.file, "uninstall",
                                 BOOTSTRAP_REASONS.ADDON_UNINSTALL);
        this.unloadBootstrapScope(id);
        TemporaryInstallLocation.uninstallAddon(id);

        let state = XPIStates.findAddon(id);
        if (state) {
          let newAddon = XPIDatabase.makeAddonLocationVisible(id, state.location.name);

          let file = new nsIFile(newAddon.path);

          this.callBootstrapMethod(createAddonDetails(id, newAddon),
                                   file, "install",
                                   BOOTSTRAP_REASONS.ADDON_INSTALL);
        }
      }
    }

    this.activeAddons.clear();
    this.allAppGlobal = true;

    // If there are pending operations then we must update the list of active
    // add-ons
    if (Preferences.get(PREF_PENDING_OPERATIONS, false)) {
      AddonManagerPrivate.recordSimpleMeasure("XPIDB_pending_ops", 1);
      XPIDatabase.updateActiveAddons();
      Services.prefs.setBoolPref(PREF_PENDING_OPERATIONS, false);
    }

    this.installs = null;
    this.installLocations = null;
    this.installLocationsByName = null;

    // This is needed to allow xpcshell tests to simulate a restart
    this.extensionsActive = false;
    this._addonFileMap.clear();

    if (gLazyObjectsLoaded) {
      let done = XPIDatabase.shutdown();
      done.then(
        ret => {
          logger.debug("Notifying XPI shutdown observers");
          Services.obs.notifyObservers(null, "xpi-provider-shutdown");
        },
        err => {
          logger.debug("Notifying XPI shutdown observers");
          this._shutdownError = err;
          Services.obs.notifyObservers(null, "xpi-provider-shutdown", err);
        }
      );
      return done;
    }
    logger.debug("Notifying XPI shutdown observers");
    Services.obs.notifyObservers(null, "xpi-provider-shutdown");
    return undefined;
  },

  /**
   * Applies any pending theme change to the preferences.
   */
  applyThemeChange() {
    if (!Preferences.get(PREF_SKIN_SWITCHPENDING, false))
      return;

    // Tell the Chrome Registry which Skin to select
    try {
      this.selectedSkin = Preferences.get(PREF_SKIN_TO_SELECT);
      Services.prefs.setCharPref(PREF_GENERAL_SKINS_SELECTEDSKIN,
                                 this.selectedSkin);
      Services.prefs.clearUserPref(PREF_SKIN_TO_SELECT);
      logger.debug("Changed skin to " + this.selectedSkin);
      this.currentSkin = this.selectedSkin;
    } catch (e) {
      logger.error("Error applying theme change", e);
    }
    Services.prefs.clearUserPref(PREF_SKIN_SWITCHPENDING);
  },

  /**
   * If the application has been upgraded and there are add-ons outside the
   * application directory then we may need to synchronize compatibility
   * information but only if the mismatch UI isn't disabled.
   *
   * @returns False if no update check is needed, otherwise an array of add-on
   *          IDs to check for updates. Array may be empty if no add-ons can be/need
   *           to be updated, but the metadata check needs to be performed.
   */
  shouldForceUpdateCheck(aAppChanged) {
    AddonManagerPrivate.recordSimpleMeasure("XPIDB_metadata_age", AddonRepository.metadataAge());

    let startupChanges = AddonManager.getStartupChanges(AddonManager.STARTUP_CHANGE_DISABLED);
    logger.debug("shouldForceUpdateCheck startupChanges: " + startupChanges.toSource());
    AddonManagerPrivate.recordSimpleMeasure("XPIDB_startup_disabled", startupChanges.length);

    let forceUpdate = [];
    if (startupChanges.length > 0) {
    let addons = XPIDatabase.getAddons();
      for (let addon of addons) {
        if ((startupChanges.indexOf(addon.id) != -1) &&
            (addon.permissions() & AddonManager.PERM_CAN_UPGRADE) &&
            !addon.isCompatible) {
          logger.debug("shouldForceUpdateCheck: can upgrade disabled add-on " + addon.id);
          forceUpdate.push(addon.id);
        }
      }
    }

    if (AddonRepository.isMetadataStale()) {
      logger.debug("shouldForceUpdateCheck: metadata is stale");
      return forceUpdate;
    }
    if (forceUpdate.length > 0) {
      return forceUpdate;
    }

    return false;
  },

  /**
   * Shows the "Compatibility Updates" UI.
   *
   * @param  aAddonIDs
   *         Array opf addon IDs that were disabled by the application update, and
   *         should therefore be checked for updates.
   */
  showUpgradeUI(aAddonIDs) {
    logger.debug("XPI_showUpgradeUI: " + aAddonIDs.toSource());
    Services.telemetry.getHistogramById("ADDON_MANAGER_UPGRADE_UI_SHOWN").add(1);

    // Flip a flag to indicate that we interrupted startup with an interactive prompt
    Services.startup.interrupted = true;

    var variant = Cc["@mozilla.org/variant;1"].
                  createInstance(Ci.nsIWritableVariant);
    variant.setFromVariant(aAddonIDs);

    // This *must* be modal as it has to block startup.
    var features = "chrome,centerscreen,dialog,titlebar,modal";
    var ww = Cc["@mozilla.org/embedcomp/window-watcher;1"].
             getService(Ci.nsIWindowWatcher);
    ww.openWindow(null, URI_EXTENSION_UPDATE_DIALOG, "", features, variant);

    Services.prefs.setBoolPref(PREF_PENDING_OPERATIONS, false);
  },

  async updateSystemAddons() {
    let systemAddonLocation = XPIProvider.installLocationsByName[KEY_APP_SYSTEM_ADDONS];
    if (!systemAddonLocation)
      return;

    // Don't do anything in safe mode
    if (Services.appinfo.inSafeMode)
      return;

    // Download the list of system add-ons
    let url = Preferences.get(PREF_SYSTEM_ADDON_UPDATE_URL, null);
    if (!url) {
      await systemAddonLocation.cleanDirectories();
      return;
    }

    url = UpdateUtils.formatUpdateURL(url);

    logger.info(`Starting system add-on update check from ${url}.`);
    let res = await ProductAddonChecker.getProductAddonList(url);

    // If there was no list then do nothing.
    if (!res || !res.gmpAddons) {
      logger.info("No system add-ons list was returned.");
      await systemAddonLocation.cleanDirectories();
      return;
    }

    let addonList = new Map(
      res.gmpAddons.map(spec => [spec.id, { spec, path: null, addon: null }]));

    let getAddonsInLocation = (location) => {
      return new Promise(resolve => {
        XPIDatabase.getAddonsInLocation(location, resolve);
      });
    };

    let setMatches = (wanted, existing) => {
      if (wanted.size != existing.size)
        return false;

      for (let [id, addon] of existing) {
        let wantedInfo = wanted.get(id);

        if (!wantedInfo)
          return false;
        if (wantedInfo.spec.version != addon.version)
          return false;
      }

      return true;
    };

    // If this matches the current set in the profile location then do nothing.
    let updatedAddons = addonMap(await getAddonsInLocation(KEY_APP_SYSTEM_ADDONS));
    if (setMatches(addonList, updatedAddons)) {
      logger.info("Retaining existing updated system add-ons.");
      await systemAddonLocation.cleanDirectories();
      return;
    }

    // If this matches the current set in the default location then reset the
    // updated set.
    let defaultAddons = addonMap(await getAddonsInLocation(KEY_APP_SYSTEM_DEFAULTS));
    if (setMatches(addonList, defaultAddons)) {
      logger.info("Resetting system add-ons.");
      systemAddonLocation.resetAddonSet();
      await systemAddonLocation.cleanDirectories();
      return;
    }

    // Download all the add-ons
    async function downloadAddon(item) {
      try {
        let sourceAddon = updatedAddons.get(item.spec.id);
        if (sourceAddon && sourceAddon.version == item.spec.version) {
          // Copying the file to a temporary location has some benefits. If the
          // file is locked and cannot be read then we'll fall back to
          // downloading a fresh copy. It also means we don't have to remember
          // whether to delete the temporary copy later.
          try {
            let path = OS.Path.join(OS.Constants.Path.tmpDir, "tmpaddon");
            let unique = await OS.File.openUnique(path);
            unique.file.close();
            await OS.File.copy(sourceAddon._sourceBundle.path, unique.path);
            // Make sure to update file modification times so this is detected
            // as a new add-on.
            await OS.File.setDates(unique.path);
            item.path = unique.path;
          } catch (e) {
            logger.warn(`Failed make temporary copy of ${sourceAddon._sourceBundle.path}.`, e);
          }
        }
        if (!item.path) {
          item.path = await ProductAddonChecker.downloadAddon(item.spec);
        }
        item.addon = await loadManifestFromFile(nsIFile(item.path), systemAddonLocation);
      } catch (e) {
        logger.error(`Failed to download system add-on ${item.spec.id}`, e);
      }
    }
    await Promise.all(Array.from(addonList.values()).map(downloadAddon));

    // The download promises all resolve regardless, now check if they all
    // succeeded
    let validateAddon = (item) => {
      if (item.spec.id != item.addon.id) {
        logger.warn(`Downloaded system add-on expected to be ${item.spec.id} but was ${item.addon.id}.`);
        return false;
      }

      if (item.spec.version != item.addon.version) {
        logger.warn(`Expected system add-on ${item.spec.id} to be version ${item.spec.version} but was ${item.addon.version}.`);
        return false;
      }

      if (!systemAddonLocation.isValidAddon(item.addon))
        return false;

      return true;
    }

    if (!Array.from(addonList.values()).every(item => item.path && item.addon && validateAddon(item))) {
      throw new Error("Rejecting updated system add-on set that either could not " +
                      "be downloaded or contained unusable add-ons.");
    }

    // Install into the install location
    logger.info("Installing new system add-on set");
    await systemAddonLocation.installAddonSet(Array.from(addonList.values())
      .map(a => a.addon));
  },

  /**
   * Verifies that all installed add-ons are still correctly signed.
   */
  async verifySignatures() {
    try {
      let addons = await XPIDatabase.getAddonList(a => true);

      let changes = {
        enabled: [],
        disabled: []
      };

      for (let addon of addons) {
        // The add-on might have vanished, we'll catch that on the next startup
        if (!addon._sourceBundle.exists())
          continue;

        let signedState = await verifyBundleSignedState(addon._sourceBundle, addon);

        if (signedState != addon.signedState) {
          addon.signedState = signedState;
          AddonManagerPrivate.callAddonListeners("onPropertyChanged",
                                                 addon.wrapper,
                                                 ["signedState"]);
        }

        let disabled = XPIProvider.updateAddonDisabledState(addon);
        if (disabled !== undefined)
          changes[disabled ? "disabled" : "enabled"].push(addon.id);
      }

      XPIDatabase.saveChanges();

      Services.obs.notifyObservers(null, "xpi-signature-changed", JSON.stringify(changes));
    } catch (err) {
      logger.error("XPI_verifySignature: " + err);
    }
  },

  /**
   * Adds a list of currently active add-ons to the next crash report.
   */
  addAddonsToCrashReporter() {
    if (!("nsICrashReporter" in Ci) ||
        !(Services.appinfo instanceof Ci.nsICrashReporter))
      return;

    // In safe mode no add-ons are loaded so we should not include them in the
    // crash report
    if (Services.appinfo.inSafeMode)
      return;

    let data = Array.from(XPIStates.enabledAddons(),
                          a => encoded`${a.id}:${a.version}`).join(",");

    try {
      Services.appinfo.annotateCrashReport("Add-ons", data);
    } catch (e) { }

    let TelemetrySession =
      Cu.import("resource://gre/modules/TelemetrySession.jsm", {}).TelemetrySession;
    TelemetrySession.setAddOns(data);
  },

  /**
   * Check the staging directories of install locations for any add-ons to be
   * installed or add-ons to be uninstalled.
   *
   * @param  aManifests
   *         A dictionary to add detected install manifests to for the purpose
   *         of passing through updated compatibility information
   * @return true if an add-on was installed or uninstalled
   */
  processPendingFileChanges(aManifests) {
    let changed = false;
    for (let location of this.installLocations) {
      aManifests[location.name] = {};
      // We can't install or uninstall anything in locked locations
      if (location.locked) {
        continue;
      }

      let stagingDir = location.getStagingDir();

      try {
        if (!stagingDir || !stagingDir.exists() || !stagingDir.isDirectory())
          continue;
      } catch (e) {
        logger.warn("Failed to find staging directory", e);
        continue;
      }

      let seenFiles = [];
      // Use a snapshot of the directory contents to avoid possible issues with
      // iterating over a directory while removing files from it (the YAFFS2
      // embedded filesystem has this issue, see bug 772238), and to remove
      // normal files before their resource forks on OSX (see bug 733436).
      let stagingDirEntries = getDirectoryEntries(stagingDir, true);
      for (let stageDirEntry of stagingDirEntries) {
        let id = stageDirEntry.leafName;

        let isDir;
        try {
          isDir = stageDirEntry.isDirectory();
        } catch (e) {
          if (e.result != Cr.NS_ERROR_FILE_TARGET_DOES_NOT_EXIST)
            throw e;
          // If the file has already gone away then don't worry about it, this
          // can happen on OSX where the resource fork is automatically moved
          // with the data fork for the file. See bug 733436.
          continue;
        }

        if (!isDir) {
          if (id.substring(id.length - 4).toLowerCase() == ".xpi") {
            id = id.substring(0, id.length - 4);
          } else {
            if (id.substring(id.length - 5).toLowerCase() != ".json") {
              logger.warn("Ignoring file: " + stageDirEntry.path);
              seenFiles.push(stageDirEntry.leafName);
            }
            continue;
          }
        }

        // Check that the directory's name is a valid ID.
        if (!gIDTest.test(id)) {
          logger.warn("Ignoring directory whose name is not a valid add-on ID: " +
               stageDirEntry.path);
          seenFiles.push(stageDirEntry.leafName);
          continue;
        }

        changed = true;

        if (isDir) {
          // Check if the directory contains an install manifest.
          let manifest = getManifestFileForDir(stageDirEntry);

          // If the install manifest doesn't exist uninstall this add-on in this
          // install location.
          if (!manifest) {
            logger.debug("Processing uninstall of " + id + " in " + location.name);

            try {
              let addonFile = location.getLocationForID(id);
              let addonToUninstall = syncLoadManifestFromFile(addonFile, location);
              if (addonToUninstall.bootstrap) {
                this.callBootstrapMethod(addonToUninstall, addonToUninstall._sourceBundle,
                                         "uninstall", BOOTSTRAP_REASONS.ADDON_UNINSTALL);
              }
            } catch (e) {
              logger.warn("Failed to call uninstall for " + id, e);
            }

            try {
              location.uninstallAddon(id);
              XPIStates.removeAddon(location.name, id);
              seenFiles.push(stageDirEntry.leafName);
            } catch (e) {
              logger.error("Failed to uninstall add-on " + id + " in " + location.name, e);
            }
            // The file check later will spot the removal and cleanup the database
            continue;
          }
        }

        aManifests[location.name][id] = null;
        let existingAddonID = id;

        let jsonfile = getFile(`${id}.json`, stagingDir);
        // Assume this was a foreign install if there is no cached metadata file
        let foreignInstall = !jsonfile.exists();
        let addon;

        try {
          addon = syncLoadManifestFromFile(stageDirEntry, location);
        } catch (e) {
          logger.error("Unable to read add-on manifest from " + stageDirEntry.path, e);
          // This add-on can't be installed so just remove it now
          seenFiles.push(stageDirEntry.leafName);
          seenFiles.push(jsonfile.leafName);
          continue;
        }

        if (mustSign(addon.type) &&
            addon.signedState <= AddonManager.SIGNEDSTATE_MISSING) {
          logger.warn("Refusing to install staged add-on " + id + " with signed state " + addon.signedState);
          seenFiles.push(stageDirEntry.leafName);
          seenFiles.push(jsonfile.leafName);
          continue;
        }

        // Check for a cached metadata for this add-on, it may contain updated
        // compatibility information
        if (!foreignInstall) {
          logger.debug("Found updated metadata for " + id + " in " + location.name);
          let fis = Cc["@mozilla.org/network/file-input-stream;1"].
                       createInstance(Ci.nsIFileInputStream);
          let json = Cc["@mozilla.org/dom/json;1"].
                     createInstance(Ci.nsIJSON);

          try {
            fis.init(jsonfile, -1, 0, 0);
            let metadata = json.decodeFromStream(fis, jsonfile.fileSize);
            addon.importMetadata(metadata);

            // Pass this through to addMetadata so it knows this add-on was
            // likely installed through the UI
            aManifests[location.name][id] = addon;
          } catch (e) {
            // If some data can't be recovered from the cached metadata then it
            // is unlikely to be a problem big enough to justify throwing away
            // the install, just log an error and continue
            logger.error("Unable to read metadata from " + jsonfile.path, e);
          } finally {
            fis.close();
          }
        }
        seenFiles.push(jsonfile.leafName);

        existingAddonID = addon.existingAddonID || id;

        var oldBootstrap = null;
        logger.debug("Processing install of " + id + " in " + location.name);
        let existingAddon = XPIStates.findAddon(existingAddonID);
        if (existingAddon && existingAddon.bootstrapped) {
          try {
            var file = existingAddon.file;
            if (file.exists()) {
              oldBootstrap = existingAddon;

              // We'll be replacing a currently active bootstrapped add-on so
              // call its uninstall method
              let newVersion = addon.version;
              let oldVersion = existingAddon;
              let uninstallReason = Services.vc.compare(oldVersion, newVersion) < 0 ?
                                    BOOTSTRAP_REASONS.ADDON_UPGRADE :
                                    BOOTSTRAP_REASONS.ADDON_DOWNGRADE;

              this.callBootstrapMethod(createAddonDetails(existingAddonID, existingAddon),
                                       file, "uninstall", uninstallReason,
                                       { newVersion });
              this.unloadBootstrapScope(existingAddonID);
              flushChromeCaches();
            }
          } catch (e) {
          }
        }

        try {
          addon._sourceBundle = location.installAddon({
            id,
            source: stageDirEntry,
            existingAddonID
          });
          XPIStates.addAddon(addon);
        } catch (e) {
          logger.error("Failed to install staged add-on " + id + " in " + location.name,
                e);
          // Re-create the staged install
          new StagedAddonInstall(location, stageDirEntry, addon);
          // Make sure not to delete the cached manifest json file
          seenFiles.pop();

          delete aManifests[location.name][id];

          if (oldBootstrap) {
            // Re-install the old add-on
            this.callBootstrapMethod(createAddonDetails(existingAddonID, oldBootstrap),
                                     existingAddon, "install",
                                     BOOTSTRAP_REASONS.ADDON_INSTALL);
          }
          continue;
        }
      }

      try {
        location.cleanStagingDir(seenFiles);
      } catch (e) {
        // Non-critical, just saves some perf on startup if we clean this up.
        logger.debug("Error cleaning staging dir " + stagingDir.path, e);
      }
    }
    return changed;
  },

  /**
   * Installs any add-ons located in the extensions directory of the
   * application's distribution specific directory into the profile unless a
   * newer version already exists or the user has previously uninstalled the
   * distributed add-on.
   *
   * @param  aManifests
   *         A dictionary to add new install manifests to to save having to
   *         reload them later
   * @param  aAppChanged
   *         See checkForChanges
   * @return true if any new add-ons were installed
   */
  installDistributionAddons(aManifests, aAppChanged) {
    let distroDir;
    try {
      distroDir = FileUtils.getDir(KEY_APP_DISTRIBUTION, [DIR_EXTENSIONS]);
    } catch (e) {
      return false;
    }

    if (!distroDir.exists())
      return false;

    if (!distroDir.isDirectory())
      return false;

    let changed = false;
    let profileLocation = this.installLocationsByName[KEY_APP_PROFILE];

    let entries = distroDir.directoryEntries
                           .QueryInterface(Ci.nsIDirectoryEnumerator);
    let entry;
    while ((entry = entries.nextFile)) {

      let id = entry.leafName;

      if (entry.isFile()) {
        if (id.substring(id.length - 4).toLowerCase() == ".xpi") {
          id = id.substring(0, id.length - 4);
        } else {
          logger.debug("Ignoring distribution add-on that isn't an XPI: " + entry.path);
          continue;
        }
      } else if (!entry.isDirectory()) {
        logger.debug("Ignoring distribution add-on that isn't a file or directory: " +
            entry.path);
        continue;
      }

      if (!gIDTest.test(id)) {
        logger.debug("Ignoring distribution add-on whose name is not a valid add-on ID: " +
            entry.path);
        continue;
      }

      /* If this is not an upgrade and we've already handled this extension
       * just continue */
      if (!aAppChanged && Preferences.isSet(PREF_BRANCH_INSTALLED_ADDON + id)) {
        continue;
      }

      let addon;
      try {
        addon = syncLoadManifestFromFile(entry, profileLocation);
      } catch (e) {
        logger.warn("File entry " + entry.path + " contains an invalid add-on", e);
        continue;
      }

      if (addon.id != id) {
        logger.warn("File entry " + entry.path + " contains an add-on with an " +
             "incorrect ID")
        continue;
      }

      let existingEntry = null;
      try {
        existingEntry = profileLocation.getLocationForID(id);
      } catch (e) {
      }

      if (existingEntry) {
        let existingAddon;
        try {
          existingAddon = syncLoadManifestFromFile(existingEntry, profileLocation);

          if (Services.vc.compare(addon.version, existingAddon.version) <= 0)
            continue;
        } catch (e) {
          // Bad add-on in the profile so just proceed and install over the top
          logger.warn("Profile contains an add-on with a bad or missing install " +
               "manifest at " + existingEntry.path + ", overwriting", e);
        }
      } else if (Preferences.get(PREF_BRANCH_INSTALLED_ADDON + id, false)) {
        continue;
      }

      // Install the add-on
      try {
        addon._sourceBundle = profileLocation.installAddon({ id, source: entry, action: "copy" });
        XPIStates.addAddon(addon);
        logger.debug("Installed distribution add-on " + id);

        Services.prefs.setBoolPref(PREF_BRANCH_INSTALLED_ADDON + id, true)

        // aManifests may contain a copy of a newly installed add-on's manifest
        // and we'll have overwritten that so instead cache our install manifest
        // which will later be put into the database in processFileChanges
        if (!(KEY_APP_PROFILE in aManifests))
          aManifests[KEY_APP_PROFILE] = {};
        aManifests[KEY_APP_PROFILE][id] = addon;
        changed = true;
      } catch (e) {
        logger.error("Failed to install distribution add-on " + entry.path, e);
      }
    }

    entries.close();

    return changed;
  },

  /**
   * Imports the xpinstall permissions from preferences into the permissions
   * manager for the user to change later.
   */
  importPermissions() {
    PermissionsUtils.importFromPrefs(PREF_XPI_PERMISSIONS_BRANCH,
                                     XPI_PERMISSION);
  },

  getDependentAddons(aAddon) {
    return Array.from(XPIDatabase.getAddons())
                .filter(addon => addon.dependencies.includes(aAddon.id));
  },

  /**
   * Returns the add-on state data for the restartful extensions which
   * should be available in safe mode. In particular, this means the
   * default theme, and only the default theme.
   *
   * @returns {object}
   */
  getSafeModeExtensions() {
    let loc = XPIStates.getLocation(KEY_APP_GLOBAL);
    let state = loc.get(ADDON_ID_DEFAULT_THEME);

    // Use the default state data for the default theme, but always mark
    // it enabled, in case another theme is enabled in normal mode.
    let addonData = state.toJSON();
    addonData.enabled = true;

    return {
      [KEY_APP_GLOBAL]: {
        path: loc.path,
        addons: { [ADDON_ID_DEFAULT_THEME]: addonData },
      },
    };
  },

  /**
   * Checks for any changes that have occurred since the last time the
   * application was launched.
   *
   * @param  aAppChanged
   *         A tri-state value. Undefined means the current profile was created
   *         for this session, true means the profile already existed but was
   *         last used with an application with a different version number,
   *         false means that the profile was last used by this version of the
   *         application.
   * @param  aOldAppVersion
   *         The version of the application last run with this profile or null
   *         if it is a new profile or the version is unknown
   * @param  aOldPlatformVersion
   *         The version of the platform last run with this profile or null
   *         if it is a new profile or the version is unknown
   * @return true if a change requiring a restart was detected
   */
  checkForChanges(aAppChanged, aOldAppVersion, aOldPlatformVersion) {
    logger.debug("checkForChanges");

    // Keep track of whether and why we need to open and update the database at
    // startup time.
    let updateReasons = [];
    if (aAppChanged) {
      updateReasons.push("appChanged");
    }

    let installChanged = XPIStates.getInstallState(aAppChanged === false);
    if (installChanged) {
      updateReasons.push("directoryState");
    }

    // First install any new add-ons into the locations, if there are any
    // changes then we must update the database with the information in the
    // install locations
    let manifests = {};
    let updated = this.processPendingFileChanges(manifests);
    if (updated) {
      updateReasons.push("pendingFileChanges");
    }

    // This will be true if the previous session made changes that affect the
    // active state of add-ons but didn't commit them properly (normally due
    // to the application crashing)
    let hasPendingChanges = Preferences.get(PREF_PENDING_OPERATIONS);
    if (hasPendingChanges) {
      updateReasons.push("hasPendingChanges");
    }

    // If the application has changed then check for new distribution add-ons
    if (Preferences.get(PREF_INSTALL_DISTRO_ADDONS, true)) {
      updated = this.installDistributionAddons(manifests, aAppChanged);
      if (updated) {
        updateReasons.push("installDistributionAddons");
      }
    }

    let haveAnyAddons = (XPIStates.size > 0);

    // If the schema appears to have changed then we should update the database
    if (DB_SCHEMA != Preferences.get(PREF_DB_SCHEMA, 0)) {
      // If we don't have any add-ons, just update the pref, since we don't need to
      // write the database
      if (!haveAnyAddons) {
        logger.debug("Empty XPI database, setting schema version preference to " + DB_SCHEMA);
        Services.prefs.setIntPref(PREF_DB_SCHEMA, DB_SCHEMA);
      } else {
        updateReasons.push("schemaChanged");
      }
    }

    // If the database doesn't exist and there are add-ons installed then we
    // must update the database however if there are no add-ons then there is
    // no need to update the database.
    let dbFile = FileUtils.getFile(KEY_PROFILEDIR, [FILE_DATABASE], true);
    if (!dbFile.exists() && haveAnyAddons) {
      updateReasons.push("needNewDatabase");
    }

    // Catch and log any errors during the main startup
    try {
      let extensionListChanged = false;
      // If the database needs to be updated then open it and then update it
      // from the filesystem
      if (updateReasons.length > 0) {
        AddonManagerPrivate.recordSimpleMeasure("XPIDB_startup_load_reasons", updateReasons);
        XPIDatabase.syncLoadDB(false);
        try {
          extensionListChanged = XPIDatabaseReconcile.processFileChanges(manifests,
                                                                         aAppChanged,
                                                                         aOldAppVersion,
                                                                         aOldPlatformVersion,
                                                                         updateReasons.includes("schemaChanged"));
        } catch (e) {
          logger.error("Failed to process extension changes at startup", e);
        }
      }

      if (aAppChanged) {
        // When upgrading the app and using a custom skin make sure it is still
        // compatible otherwise switch back the default
        if (this.currentSkin != this.defaultSkin) {
          let oldSkin = XPIDatabase.getVisibleAddonForInternalName(this.currentSkin);
          if (!oldSkin || oldSkin.disabled)
            this.enableDefaultTheme();
        }

        // When upgrading remove the old extensions cache to force older
        // versions to rescan the entire list of extensions
        let oldCache = FileUtils.getFile(KEY_PROFILEDIR, [FILE_OLD_CACHE], true);
        try {
          if (oldCache.exists())
            oldCache.remove(true);
        } catch (e) {
          logger.warn("Unable to remove old extension cache " + oldCache.path, e);
        }
      }

      if (Services.appinfo.inSafeMode) {
        aomStartup.initializeExtensions(this.getSafeModeExtensions());
        logger.debug("Initialized safe mode add-ons");
        return false;
      }

      // If the application crashed before completing any pending operations then
      // we should perform them now.
      if (extensionListChanged || hasPendingChanges) {
        this._updateActiveAddons();

        // Serialize and deserialize so we get the expected JSON data.
        let state = JSON.parse(JSON.stringify(XPIStates));
        aomStartup.initializeExtensions(state);
        return true;
      }

      aomStartup.initializeExtensions(XPIStates.initialStateData);

      logger.debug("No changes found");
    } catch (e) {
      logger.error("Error during startup file checks", e);
    }

    return false;
  },

  _updateActiveAddons() {
    logger.debug("Updating database with changes to installed add-ons");
    XPIDatabase.updateActiveAddons();
    Services.prefs.setBoolPref(PREF_PENDING_OPERATIONS, false);
  },

  /**
   * Gets an array of add-ons which were placed in a known install location
   * prior to startup of the current session, were detected by a directory scan
   * of those locations, and are currently disabled.
   *
   * @returns {Promise<Array<Addon>>}
   */
  async getNewSideloads() {
    if (XPIStates.getInstallState(false)) {
      // We detected changes. Update the database to account for them.
      await XPIDatabase.asyncLoadDB(false);
      XPIDatabaseReconcile.processFileChanges({}, false);
      this._updateActiveAddons();
    }

    let addons = await Promise.all(
      Array.from(XPIStates.sideLoadedAddons.keys(),
                 id => AddonManager.getAddonByID(id)));

    return addons.filter(addon => (addon.seen === false &&
                                   addon.permissions & AddonManager.PERM_CAN_ENABLE));
  },

  /**
   * Called to test whether this provider supports installing a particular
   * mimetype.
   *
   * @param  aMimetype
   *         The mimetype to check for
   * @return true if the mimetype is application/x-xpinstall
   */
  supportsMimetype(aMimetype) {
    return aMimetype == "application/x-xpinstall";
  },

  /**
   * Called to test whether installing XPI add-ons is enabled.
   *
   * @return true if installing is enabled
   */
  isInstallEnabled() {
    // Default to enabled if the preference does not exist
    return Preferences.get(PREF_XPI_ENABLED, true);
  },

  /**
   * Called to test whether installing XPI add-ons by direct URL requests is
   * whitelisted.
   *
   * @return true if installing by direct requests is whitelisted
   */
  isDirectRequestWhitelisted() {
    // Default to whitelisted if the preference does not exist.
    return Preferences.get(PREF_XPI_DIRECT_WHITELISTED, true);
  },

  /**
   * Called to test whether installing XPI add-ons from file referrers is
   * whitelisted.
   *
   * @return true if installing from file referrers is whitelisted
   */
  isFileRequestWhitelisted() {
    // Default to whitelisted if the preference does not exist.
    return Preferences.get(PREF_XPI_FILE_WHITELISTED, true);
  },

  /**
   * Called to test whether installing XPI add-ons from a URI is allowed.
   *
   * @param  aInstallingPrincipal
   *         The nsIPrincipal that initiated the install
   * @return true if installing is allowed
   */
  isInstallAllowed(aInstallingPrincipal) {
    if (!this.isInstallEnabled())
      return false;

    let uri = aInstallingPrincipal.URI;

    // Direct requests without a referrer are either whitelisted or blocked.
    if (!uri)
      return this.isDirectRequestWhitelisted();

    // Local referrers can be whitelisted.
    if (this.isFileRequestWhitelisted() &&
        (uri.schemeIs("chrome") || uri.schemeIs("file")))
      return true;

    this.importPermissions();

    let permission = Services.perms.testPermissionFromPrincipal(aInstallingPrincipal, XPI_PERMISSION);
    if (permission == Ci.nsIPermissionManager.DENY_ACTION)
      return false;

    let requireWhitelist = Preferences.get(PREF_XPI_WHITELIST_REQUIRED, true);
    if (requireWhitelist && (permission != Ci.nsIPermissionManager.ALLOW_ACTION))
      return false;

    let requireSecureOrigin = Preferences.get(PREF_INSTALL_REQUIRESECUREORIGIN, true);
    let safeSchemes = ["https", "chrome", "file"];
    if (requireSecureOrigin && safeSchemes.indexOf(uri.scheme) == -1)
      return false;

    return true;
  },

  // Identify temporary install IDs.
  isTemporaryInstallID(id) {
    return id.endsWith(TEMPORARY_ADDON_SUFFIX);
  },

  /**
   * Called to get an AddonInstall to download and install an add-on from a URL.
   *
   * @param  aUrl
   *         The URL to be installed
   * @param  aHash
   *         A hash for the install
   * @param  aName
   *         A name for the install
   * @param  aIcons
   *         Icon URLs for the install
   * @param  aVersion
   *         A version for the install
   * @param  aBrowser
   *         The browser performing the install
   * @param  aCallback
   *         A callback to pass the AddonInstall to
   */
  getInstallForURL(aUrl, aHash, aName, aIcons, aVersion, aBrowser,
                             aCallback) {
    let location = XPIProvider.installLocationsByName[KEY_APP_PROFILE];
    let url = Services.io.newURI(aUrl);

    let options = {
      hash: aHash,
      browser: aBrowser,
      name: aName,
      icons: aIcons,
      version: aVersion,
    };

    if (url instanceof Ci.nsIFileURL) {
      let install = new LocalAddonInstall(location, url, options);
      install.init().then(() => { aCallback(install.wrapper); });
    } else {
      let install = new DownloadAddonInstall(location, url, options);
      aCallback(install.wrapper);
    }
  },

  /**
   * Called to get an AddonInstall to install an add-on from a local file.
   *
   * @param  aFile
   *         The file to be installed
   * @param  aCallback
   *         A callback to pass the AddonInstall to
   */
  getInstallForFile(aFile, aCallback) {
    createLocalInstall(aFile).then(install => {
      aCallback(install ? install.wrapper : null);
    });
  },

  /**
   * Temporarily installs add-on from a local XPI file or directory.
   * As this is intended for development, the signature is not checked and
   * the add-on does not persist on application restart.
   *
   * @param aFile
   *        An nsIFile for the unpacked add-on directory or XPI file.
   *
   * @return See installAddonFromLocation return value.
   */
  installTemporaryAddon(aFile) {
    return this.installAddonFromLocation(aFile, TemporaryInstallLocation);
  },

  /**
   * Permanently installs add-on from a local XPI file or directory.
   * The signature is checked but the add-on persist on application restart.
   *
   * @param aFile
   *        An nsIFile for the unpacked add-on directory or XPI file.
   *
   * @return See installAddonFromLocation return value.
   */
  async installAddonFromSources(aFile) {
    let location = XPIProvider.installLocationsByName[KEY_APP_PROFILE];
    return this.installAddonFromLocation(aFile, location, "proxy");
  },

  /**
   * Installs add-on from a local XPI file or directory.
   *
   * @param aFile
   *        An nsIFile for the unpacked add-on directory or XPI file.
   * @param aInstallLocation
   *        Define a custom install location object to use for the install.
   * @param aInstallAction
   *        Optional action mode to use when installing the addon
   *        (see MutableDirectoryInstallLocation.installAddon)
   *
   * @return a Promise that resolves to an Addon object on success, or rejects
   *         if the add-on is not a valid restartless add-on or if the
   *         same ID is already installed.
   */
  async installAddonFromLocation(aFile, aInstallLocation, aInstallAction) {
    if (aFile.exists() && aFile.isFile()) {
      flushJarCache(aFile);
    }
    let addon = await loadManifestFromFile(aFile, aInstallLocation);

    aInstallLocation.installAddon({ id: addon.id, source: aFile, action: aInstallAction });

    if (addon.appDisabled) {
      let message = `Add-on ${addon.id} is not compatible with application version.`;

      let app = addon.matchingTargetApplication;
      if (app) {
        if (app.minVersion) {
          message += ` add-on minVersion: ${app.minVersion}.`;
        }
        if (app.maxVersion) {
          message += ` add-on maxVersion: ${app.maxVersion}.`;
        }
      }
      throw new Error(message);
    }

    if (!addon.bootstrap) {
      throw new Error("Only restartless (bootstrap) add-ons"
                    + " can be installed from sources:", addon.id);
    }
    let installReason = BOOTSTRAP_REASONS.ADDON_INSTALL;
    let oldAddon = await new Promise(
                   resolve => XPIDatabase.getVisibleAddonForID(addon.id, resolve));

    let extraParams = {};
    extraParams.temporarilyInstalled = aInstallLocation === TemporaryInstallLocation;
    if (oldAddon) {
      if (!oldAddon.bootstrap) {
        logger.warn("Non-restartless Add-on is already installed", addon.id);
        throw new Error("Non-restartless add-on with ID "
                        + oldAddon.id + " is already installed");
      } else {
        logger.warn("Addon with ID " + oldAddon.id + " already installed,"
                    + " older version will be disabled");

        let existingAddonID = oldAddon.id;
        let existingAddon = oldAddon._sourceBundle;

        // We'll be replacing a currently active bootstrapped add-on so
        // call its uninstall method
        let newVersion = addon.version;
        let oldVersion = oldAddon.version;

        if (Services.vc.compare(newVersion, oldVersion) >= 0) {
          installReason = BOOTSTRAP_REASONS.ADDON_UPGRADE;
        } else {
          installReason = BOOTSTRAP_REASONS.ADDON_DOWNGRADE;
        }
        let uninstallReason = installReason;

        extraParams.newVersion = newVersion;
        extraParams.oldVersion = oldVersion;

        if (oldAddon.active) {
          XPIProvider.callBootstrapMethod(oldAddon, existingAddon,
                                          "shutdown", uninstallReason,
                                          extraParams);
        }
        this.callBootstrapMethod(oldAddon, existingAddon,
                                 "uninstall", uninstallReason, extraParams);
        this.unloadBootstrapScope(existingAddonID);
        flushChromeCaches();
      }
    } else {
      addon.installDate = Date.now();
    }

    let file = addon._sourceBundle;

    XPIProvider._addURIMapping(addon.id, file);
    XPIProvider.callBootstrapMethod(addon, file, "install", installReason, extraParams);
    addon.state = AddonManager.STATE_INSTALLED;
    logger.debug("Install of temporary addon in " + aFile.path + " completed.");
    addon.visible = true;
    addon.enabled = true;
    addon.active = true;
    // WebExtension themes are installed as disabled, fix that here.
    addon.userDisabled = false;

    addon = XPIDatabase.addAddonMetadata(addon, file.persistentDescriptor);

    XPIStates.addAddon(addon);
    XPIDatabase.saveChanges();
    XPIStates.save();

    AddonManagerPrivate.callAddonListeners("onInstalling", addon.wrapper,
                                           false);
    XPIProvider.callBootstrapMethod(addon, file, "startup", installReason, extraParams);
    AddonManagerPrivate.callInstallListeners("onExternalInstall",
                                             null, addon.wrapper,
                                             oldAddon ? oldAddon.wrapper : null,
                                             false);
    AddonManagerPrivate.callAddonListeners("onInstalled", addon.wrapper);

    // Notify providers that a new theme has been enabled.
    if (isTheme(addon.type))
      AddonManagerPrivate.notifyAddonChanged(addon.id, addon.type, false);

    return addon.wrapper;
  },

  /**
   * Returns an Addon corresponding to an instance ID.
   * @param aInstanceID
   *        An Addon Instance ID
   * @return {Promise}
   * @resolves The found Addon or null if no such add-on exists.
   * @rejects  Never
   * @throws if the aInstanceID argument is not specified
   */
   getAddonByInstanceID(aInstanceID) {
     if (!aInstanceID || typeof aInstanceID != "symbol")
       throw Components.Exception("aInstanceID must be a Symbol()",
                                  Cr.NS_ERROR_INVALID_ARG);

     for (let [id, val] of this.activeAddons) {
       if (aInstanceID == val.instanceID) {
         return new Promise(resolve => this.getAddonByID(id, resolve));
       }
     }

     return Promise.resolve(null);
   },

  /**
   * Removes an AddonInstall from the list of active installs.
   *
   * @param  install
   *         The AddonInstall to remove
   */
  removeActiveInstall(aInstall) {
    this.installs.delete(aInstall);
  },

  /**
   * Called to get an Addon with a particular ID.
   *
   * @param  aId
   *         The ID of the add-on to retrieve
   * @param  aCallback
   *         A callback to pass the Addon to
   */
  getAddonByID(aId, aCallback) {
    XPIDatabase.getVisibleAddonForID(aId, function(aAddon) {
      aCallback(aAddon ? aAddon.wrapper : null);
    });
  },

  /**
   * Called to get Addons of a particular type.
   *
   * @param  aTypes
   *         An array of types to fetch. Can be null to get all types.
   * @param  aCallback
   *         A callback to pass an array of Addons to
   */
  getAddonsByTypes(aTypes, aCallback) {
    let typesToGet = getAllAliasesForTypes(aTypes);
    if (typesToGet && !typesToGet.some(type => ALL_TYPES.has(type))) {
      aCallback([]);
      return;
    }

    XPIDatabase.getVisibleAddons(typesToGet, function(aAddons) {
      aCallback(aAddons.map(a => a.wrapper));
    });
  },

  /**
   * Called to get active Addons of a particular type
   *
   * @param  aTypes
   *         An array of types to fetch. Can be null to get all types.
   * @returns {Promise<Array<Addon>>}
   */
  getActiveAddons(aTypes) {
    // If we already have the database loaded, returning full info is fast.
    if (this.isDBLoaded) {
      return new Promise(resolve => {
        this.getAddonsByTypes(aTypes, addons => {
          // The thing with experiments is an ugly hack but we want
          // Experiments.jsm to use this interface instead of getAddonsByTypes.
          // They'll go away at some point and we can forget this ever happened.
          resolve(addons.filter(addon => addon.isActive ||
                                       (addon.type == "experiment" && !addon.appDisabled)));
        });
      });
    }

    // Construct addon-like objects with the information we already
    // have in memory.
    if (!XPIStates.db) {
      return Promise.reject(new Error("XPIStates not yet initialized"));
    }

    let result = [];
    for (let addon of XPIStates.enabledAddons()) {
      let location = this.installLocationsByName[addon.location.name];
      let scope, isSystem;
      if (location) {
        ({scope, isSystem} = location);
      }
      result.push({
        id: addon.id,
        version: addon.version,
        type: addon.type,
        updateDate: addon.lastModifiedTime,
        scope,
        isSystem,
        isWebExtension: isWebExtension(addon),
        multiprocessCompatible: addon.multiprocessCompatible,
      });
    }

    return Promise.resolve(result);
  },


  /**
   * Obtain an Addon having the specified Sync GUID.
   *
   * @param  aGUID
   *         String GUID of add-on to retrieve
   * @param  aCallback
   *         A callback to pass the Addon to. Receives null if not found.
   */
  getAddonBySyncGUID(aGUID, aCallback) {
    XPIDatabase.getAddonBySyncGUID(aGUID, function(aAddon) {
      aCallback(aAddon ? aAddon.wrapper : null);
    });
  },

  /**
   * Called to get Addons that have pending operations.
   *
   * @param  aTypes
   *         An array of types to fetch. Can be null to get all types
   * @param  aCallback
   *         A callback to pass an array of Addons to
   */
  getAddonsWithOperationsByTypes(aTypes, aCallback) {
    let typesToGet = getAllAliasesForTypes(aTypes);

    XPIDatabase.getVisibleAddonsWithPendingOperations(typesToGet, function(aAddons) {
      let results = aAddons.map(a => a.wrapper);
      for (let install of XPIProvider.installs) {
        if (install.state == AddonManager.STATE_INSTALLED &&
            !(install.addon.inDatabase))
          results.push(install.addon.wrapper);
      }
      aCallback(results);
    });
  },

  /**
   * Called to get the current AddonInstalls, optionally limiting to a list of
   * types.
   *
   * @param  aTypes
   *         An array of types or null to get all types
   * @param  aCallback
   *         A callback to pass the array of AddonInstalls to
   */
  getInstallsByTypes(aTypes, aCallback) {
    let results = [...this.installs];
    if (aTypes) {
      results = results.filter(install => {
        return aTypes.includes(getExternalType(install.type));
      });
    }

    aCallback(results.map(install => install.wrapper));
  },

  /**
   * Synchronously map a URI to the corresponding Addon ID.
   *
   * Mappable URIs are limited to in-application resources belonging to the
   * add-on, such as Javascript compartments, XUL windows, XBL bindings, etc.
   * but do not include URIs from meta data, such as the add-on homepage.
   *
   * @param  aURI
   *         nsIURI to map or null
   * @return string containing the Addon ID
   * @see    AddonManager.mapURIToAddonID
   * @see    amIAddonManager.mapURIToAddonID
   */
  mapURIToAddonID(aURI) {
    // Returns `null` instead of empty string if the URI can't be mapped.
    return AddonPathService.mapURIToAddonId(aURI) || null;
  },

  /**
   * Called when a new add-on has been enabled when only one add-on of that type
   * can be enabled.
   *
   * @param  aId
   *         The ID of the newly enabled add-on
   * @param  aType
   *         The type of the newly enabled add-on
   * @param  aPendingRestart
   *         true if the newly enabled add-on will only become enabled after a
   *         restart
   */
  addonChanged(aId, aType, aPendingRestart) {
    // We only care about themes in this provider
    if (!isTheme(aType))
      return;

    if (!aId) {
      // Fallback to the default theme when no theme was enabled
      this.enableDefaultTheme();
      return;
    }

    // Look for the previously enabled theme and find the internalName of the
    // currently selected theme
    let previousTheme = null;
    let newSkin = this.defaultSkin;
    let addons = XPIDatabase.getAddonsByType("theme", "webextension-theme");
    for (let theme of addons) {
      if (!theme.visible)
        return;
      let isChangedAddon = (theme.id == aId);
      if (isWebExtension(theme.type)) {
        if (!isChangedAddon)
          this.updateAddonDisabledState(theme, true, undefined, aPendingRestart);
      } else if (isChangedAddon) {
        newSkin = theme.internalName;
      } else if (theme.userDisabled == false && !theme.pendingUninstall) {
        previousTheme = theme;
      }
    }

    if (aPendingRestart) {
      Services.prefs.setBoolPref(PREF_SKIN_SWITCHPENDING, true);
      Services.prefs.setCharPref(PREF_SKIN_TO_SELECT, newSkin);
    } else if (newSkin == this.currentSkin) {
      try {
        Services.prefs.clearUserPref(PREF_SKIN_SWITCHPENDING);
      } catch (e) { }
      try {
        Services.prefs.clearUserPref(PREF_SKIN_TO_SELECT);
      } catch (e) { }
    } else {
      Services.prefs.setCharPref(PREF_GENERAL_SKINS_SELECTEDSKIN, newSkin);
      this.currentSkin = newSkin;
    }
    this.selectedSkin = newSkin;

    // Flush the preferences to disk so they don't get out of sync with the
    // database
    Services.prefs.savePrefFile(null);

    // Mark the previous theme as disabled. This won't cause recursion since
    // only enabled calls notifyAddonChanged.
    if (previousTheme)
      this.updateAddonDisabledState(previousTheme, true, undefined, aPendingRestart);
  },

  /**
   * Update the appDisabled property for all add-ons.
   */
  updateAddonAppDisabledStates() {
    let addons = XPIDatabase.getAddons();
    for (let addon of addons) {
      this.updateAddonDisabledState(addon);
    }
  },

  /**
   * Update the repositoryAddon property for all add-ons.
   *
   * @param  aCallback
   *         Function to call when operation is complete.
   */
  updateAddonRepositoryData(aCallback) {
    XPIDatabase.getVisibleAddons(null, aAddons => {
      let pending = aAddons.length;
      logger.debug("updateAddonRepositoryData found " + pending + " visible add-ons");
      if (pending == 0) {
        aCallback();
        return;
      }

      function notifyComplete() {
        if (--pending == 0)
          aCallback();
      }

      for (let addon of aAddons) {
        AddonRepository.getCachedAddonByID(addon.id, aRepoAddon => {
          if (aRepoAddon) {
            logger.debug("updateAddonRepositoryData got info for " + addon.id);
            addon._repositoryAddon = aRepoAddon;
            addon.compatibilityOverrides = aRepoAddon.compatibilityOverrides;
            this.updateAddonDisabledState(addon);
          }

          notifyComplete();
        });
      }
    });
  },

  /**
   * When the previously selected theme is removed this method will be called
   * to enable the default theme.
   */
  enableDefaultTheme() {
    logger.debug("Activating default theme");
    let addon = XPIDatabase.getVisibleAddonForInternalName(this.defaultSkin);
    if (addon) {
      if (addon.userDisabled) {
        this.updateAddonDisabledState(addon, false);
      } else if (!this.extensionsActive) {
        // During startup we may end up trying to enable the default theme when
        // the database thinks it is already enabled (see f.e. bug 638847). In
        // this case just force the theme preferences to be correct
        Services.prefs.setCharPref(PREF_GENERAL_SKINS_SELECTEDSKIN,
                                   addon.internalName);
        this.currentSkin = this.selectedSkin = addon.internalName;
        Preferences.reset(PREF_SKIN_TO_SELECT);
        Preferences.reset(PREF_SKIN_SWITCHPENDING);
      } else {
        logger.warn("Attempting to activate an already active default theme");
      }
    } else {
      logger.warn("Unable to activate the default theme");
    }
  },

  onDebugConnectionChange(aEvent, aWhat, aConnection) {
    if (aWhat != "opened")
      return;

    for (let [id, val] of this.activeAddons) {
      aConnection.setAddonOptions(
        id, { global: val.bootstrapScope });
    }
  },

  /**
   * Notified when a preference we're interested in has changed.
   *
   * @see nsIObserver
   */
  observe(aSubject, aTopic, aData) {
    if (aTopic == NOTIFICATION_FLUSH_PERMISSIONS) {
      if (!aData || aData == XPI_PERMISSION) {
        this.importPermissions();
      }
      return;
    } else if (aTopic == NOTIFICATION_TOOLBOXPROCESS_LOADED) {
      Services.obs.removeObserver(this, NOTIFICATION_TOOLBOXPROCESS_LOADED);
      this._toolboxProcessLoaded = true;
      BrowserToolboxProcess.on("connectionchange",
                               this.onDebugConnectionChange.bind(this));
    }

    if (aTopic == "nsPref:changed") {
      switch (aData) {
      case PREF_EM_MIN_COMPAT_APP_VERSION:
        this.minCompatibleAppVersion = Preferences.get(PREF_EM_MIN_COMPAT_APP_VERSION,
                                                       null);
        this.updateAddonAppDisabledStates();
        break;
      case PREF_EM_MIN_COMPAT_PLATFORM_VERSION:
        this.minCompatiblePlatformVersion = Preferences.get(PREF_EM_MIN_COMPAT_PLATFORM_VERSION,
                                                            null);
        this.updateAddonAppDisabledStates();
        break;
      case PREF_XPI_SIGNATURES_REQUIRED:
      case PREF_ALLOW_LEGACY:
      case PREF_ALLOW_NON_MPC:
        this.updateAddonAppDisabledStates();
        break;

      case PREF_E10S_ADDON_BLOCKLIST:
      case PREF_E10S_ADDON_POLICY:
        XPIDatabase.updateAddonsBlockingE10s();
        break;
      }
    }
  },

  /**
   * Determine if an add-on should be blocking e10s if enabled.
   *
   * @param  aAddon
   *         The add-on to test
   * @return true if enabling the add-on should block e10s
   */
  isBlockingE10s(aAddon) {
    if (aAddon.type != "extension" &&
        aAddon.type != "theme" &&
        aAddon.type != "webextension" &&
        aAddon.type != "webextension-theme")
      return false;

    // The hotfix is exempt
    let hotfixID = Preferences.get(PREF_EM_HOTFIX_ID, undefined);
    if (hotfixID && hotfixID == aAddon.id)
      return false;

    // The default theme is exempt
    if (aAddon.type == "theme" &&
        aAddon.internalName == XPIProvider.defaultSkin)
      return false;

    // System add-ons are exempt
    let loc = aAddon._installLocation;
    if (loc && loc.isSystem)
      return false;

    if (isAddonPartOfE10SRollout(aAddon)) {
      Preferences.set(PREF_E10S_HAS_NONEXEMPT_ADDON, true);
      return false;
    }

    logger.debug("Add-on " + aAddon.id + " blocks e10s rollout.");
    return true;
  },

  /**
   * Determine if an add-on should be blocking multiple content processes.
   *
   * @param  aAddon
   *         The add-on to test
   * @return true if enabling the add-on should block multiple content processes.
   */
  isBlockingE10sMulti(aAddon) {
    // WebExtensions have type = "webextension" or type="webextension-theme",
    // so they won't block multi.
    if (aAddon.type != "extension")
      return false;

    // The hotfix is exempt
    let hotfixID = Preferences.get(PREF_EM_HOTFIX_ID, undefined);
    if (hotfixID && hotfixID == aAddon.id)
      return false;

    // System add-ons are exempt
    let loc = aAddon._installLocation;
    if (loc && loc.isSystem)
      return false;

    return true;
  },

  /**
   * In some cases having add-ons active blocks e10s but turning off e10s
   * requires a restart so some add-ons that are normally restartless will
   * require a restart to install or enable.
   *
   * @param  aAddon
   *         The add-on to test
   * @return true if enabling the add-on requires a restart
   */
  e10sBlocksEnabling(aAddon) {
    // If the preference isn't set then don't block anything
    if (!Preferences.get(PREF_E10S_BLOCK_ENABLE, false))
      return false;

    // If e10s isn't active then don't block anything
    if (!Services.appinfo.browserTabsRemoteAutostart)
      return false;

    return this.isBlockingE10s(aAddon);
  },

  /**
   * Tests whether enabling an add-on will require a restart.
   *
   * @param  aAddon
   *         The add-on to test
   * @return true if the operation requires a restart
   */
  enableRequiresRestart(aAddon) {
    // If the platform couldn't have activated extensions then we can make
    // changes without any restart.
    if (!this.extensionsActive)
      return false;

    // If the application is in safe mode then any change can be made without
    // restarting
    if (Services.appinfo.inSafeMode)
      return false;

    // Anything that is active is already enabled
    if (aAddon.active)
      return false;

    if (isTheme(aAddon.type)) {
      if (isWebExtension(aAddon.type)) {
        // Enabling a WebExtension type theme requires a restart ONLY when the
        // theme-to-be-disabled requires a restart.
        let theme = XPIDatabase.getVisibleAddonForInternalName(this.currentSkin);
        return !theme || this.disableRequiresRestart(theme);
      }

      // If the theme is already the theme in use then no restart is necessary.
      // This covers the case where the default theme is in use but a
      // lightweight theme is considered active.
      return aAddon.internalName != this.currentSkin;
    }

    if (this.e10sBlocksEnabling(aAddon))
      return true;

    return !aAddon.bootstrap;
  },

  /**
   * Tests whether disabling an add-on will require a restart.
   *
   * @param  aAddon
   *         The add-on to test
   * @return true if the operation requires a restart
   */
  disableRequiresRestart(aAddon) {
    // If the platform couldn't have activated up extensions then we can make
    // changes without any restart.
    if (!this.extensionsActive)
      return false;

    // If the application is in safe mode then any change can be made without
    // restarting
    if (Services.appinfo.inSafeMode)
      return false;

    // Anything that isn't active is already disabled
    if (!aAddon.active)
      return false;

    if (aAddon.type == "theme") {
      // Non-default themes always require a restart to disable since it will
      // be switching from one theme to another or to the default theme and a
      // lightweight theme.
      if (aAddon.internalName != this.defaultSkin)
        return true;

      // The default theme requires a restart to disable if we are in the
      // process of switching to a different theme. Note that this makes the
      // disabled flag of operationsRequiringRestart incorrect for the default
      // theme (it will be false most of the time). Bug 520124 would be required
      // to fix it. For the UI this isn't a problem since we never try to
      // disable or uninstall the default theme.
      return this.selectedSkin != this.currentSkin;
    }

    return !aAddon.bootstrap;
  },

  /**
   * Tests whether installing an add-on will require a restart.
   *
   * @param  aAddon
   *         The add-on to test
   * @return true if the operation requires a restart
   */
  installRequiresRestart(aAddon) {
    // If the platform couldn't have activated up extensions then we can make
    // changes without any restart.
    if (!this.extensionsActive)
      return false;

    // If the application is in safe mode then any change can be made without
    // restarting
    if (Services.appinfo.inSafeMode)
      return false;

    // Add-ons that are already installed don't require a restart to install.
    // This wouldn't normally be called for an already installed add-on (except
    // for forming the operationsRequiringRestart flags) so is really here as
    // a safety measure.
    if (aAddon.inDatabase)
      return false;

    // If we have an AddonInstall for this add-on then we can see if there is
    // an existing installed add-on with the same ID
    if ("_install" in aAddon && aAddon._install) {
      // If there is an existing installed add-on and uninstalling it would
      // require a restart then installing the update will also require a
      // restart
      let existingAddon = aAddon._install.existingAddon;
      if (existingAddon && this.uninstallRequiresRestart(existingAddon))
        return true;
    }

    // If the add-on is not going to be active after installation then it
    // doesn't require a restart to install.
    if (aAddon.disabled)
      return false;

    if (this.e10sBlocksEnabling(aAddon))
      return true;

    // Themes will require a restart (even if dynamic switching is enabled due
    // to some caching issues) and non-bootstrapped add-ons will require a
    // restart
    return aAddon.type == "theme" || !aAddon.bootstrap;
  },

  /**
   * Tests whether uninstalling an add-on will require a restart.
   *
   * @param  aAddon
   *         The add-on to test
   * @return true if the operation requires a restart
   */
  uninstallRequiresRestart(aAddon) {
    // If the platform couldn't have activated up extensions then we can make
    // changes without any restart.
    if (!this.extensionsActive)
      return false;

    // If the application is in safe mode then any change can be made without
    // restarting
    if (Services.appinfo.inSafeMode)
      return false;

    // If the add-on can be disabled without a restart then it can also be
    // uninstalled without a restart
    return this.disableRequiresRestart(aAddon);
  },

  /**
   * Loads a bootstrapped add-on's bootstrap.js into a sandbox and the reason
   * values as constants in the scope. This will also add information about the
   * add-on to the bootstrappedAddons dictionary and notify the crash reporter
   * that new add-ons have been loaded.
   *
   * @param  aId
   *         The add-on's ID
   * @param  aFile
   *         The nsIFile for the add-on
   * @param  aVersion
   *         The add-on's version
   * @param  aType
   *         The type for the add-on
   * @param  aMultiprocessCompatible
   *         Boolean indicating whether the add-on is compatible with electrolysis.
   * @param  aRunInSafeMode
   *         Boolean indicating whether the add-on can run in safe mode.
   * @param  aDependencies
   *         An array of add-on IDs on which this add-on depends.
   * @param  hasEmbeddedWebExtension
   *         Boolean indicating whether the add-on has an embedded webextension.
   * @return a JavaScript scope
   */
  loadBootstrapScope(aId, aFile, aVersion, aType,
                               aMultiprocessCompatible, aRunInSafeMode,
                               aDependencies, hasEmbeddedWebExtension) {
    this.activeAddons.set(aId, {
      bootstrapScope: null,
      // a Symbol passed to this add-on, which it can use to identify itself
      instanceID: Symbol(aId),
    });

    // Mark the add-on as active for the crash reporter before loading
    this.addAddonsToCrashReporter();

    let activeAddon = this.activeAddons.get(aId);

    // Locales only contain chrome and can't have bootstrap scripts
    if (aType == "locale") {
      return;
    }

    logger.debug("Loading bootstrap scope from " + aFile.path);

    let principal = Cc["@mozilla.org/systemprincipal;1"].
                    createInstance(Ci.nsIPrincipal);
    if (!aMultiprocessCompatible && Preferences.get(PREF_INTERPOSITION_ENABLED, false)) {
      let interposition = Cc["@mozilla.org/addons/multiprocess-shims;1"].
        getService(Ci.nsIAddonInterposition);
      Cu.setAddonInterposition(aId, interposition);
      Cu.allowCPOWsInAddon(aId, true);
    }

    if (!aFile.exists()) {
      activeAddon.bootstrapScope =
        new Cu.Sandbox(principal, { sandboxName: aFile.path,
                                    wantGlobalProperties: ["indexedDB"],
                                    addonId: aId,
                                    metadata: { addonID: aId } });
      logger.error("Attempted to load bootstrap scope from missing directory " + aFile.path);
      return;
    }

    let uri = getURIForResourceInFile(aFile, "bootstrap.js").spec;
    if (aType == "dictionary")
      uri = "resource://gre/modules/addons/SpellCheckDictionaryBootstrap.js"
    else if (isWebExtension(aType))
      uri = "resource://gre/modules/addons/WebExtensionBootstrap.js"
    else if (aType == "apiextension")
      uri = "resource://gre/modules/addons/APIExtensionBootstrap.js"

    activeAddon.bootstrapScope =
      new Cu.Sandbox(principal, { sandboxName: uri,
                                  wantGlobalProperties: ["indexedDB"],
                                  addonId: aId,
                                  metadata: { addonID: aId, URI: uri } });

    try {
      // Copy the reason values from the global object into the bootstrap scope.
      for (let name in BOOTSTRAP_REASONS)
        activeAddon.bootstrapScope[name] = BOOTSTRAP_REASONS[name];

      // Add other stuff that extensions want.
      Object.assign(activeAddon.bootstrapScope, {Worker, ChromeWorker});

      // Define a console for the add-on
      XPCOMUtils.defineLazyGetter(
        activeAddon.bootstrapScope, "console",
        () => new ConsoleAPI({ consoleID: "addon/" + aId }));

      activeAddon.bootstrapScope.__SCRIPT_URI_SPEC__ = uri;
      Services.scriptloader.loadSubScript(uri, activeAddon.bootstrapScope);
    } catch (e) {
      logger.warn("Error loading bootstrap.js for " + aId, e);
    }

    // Only access BrowserToolboxProcess if ToolboxProcess.jsm has been
    // initialized as otherwise, when it will be initialized, all addons'
    // globals will be added anyways
    if (this._toolboxProcessLoaded) {
      BrowserToolboxProcess.setAddonOptions(aId,
        { global: activeAddon.bootstrapScope });
    }
  },

  /**
   * Unloads a bootstrap scope by dropping all references to it and then
   * updating the list of active add-ons with the crash reporter.
   *
   * @param  aId
   *         The add-on's ID
   */
  unloadBootstrapScope(aId) {
    // In case the add-on was not multiprocess-compatible, deregister
    // any interpositions for it.
    Cu.setAddonInterposition(aId, null);
    Cu.allowCPOWsInAddon(aId, false);

    this.activeAddons.delete(aId);
    this.addAddonsToCrashReporter();

    // Only access BrowserToolboxProcess if ToolboxProcess.jsm has been
    // initialized as otherwise, there won't be any addon globals added to it
    if (this._toolboxProcessLoaded) {
      BrowserToolboxProcess.setAddonOptions(aId, { global: null });
    }
  },

  /**
   * Calls a bootstrap method for an add-on.
   *
   * @param  aAddon
   *         An object representing the add-on, with `id`, `type` and `version`
   * @param  aFile
   *         The nsIFile for the add-on
   * @param  aMethod
   *         The name of the bootstrap method to call
   * @param  aReason
   *         The reason flag to pass to the bootstrap's startup method
   * @param  aExtraParams
   *         An object of additional key/value pairs to pass to the method in
   *         the params argument
   */
  callBootstrapMethod(aAddon, aFile, aMethod, aReason, aExtraParams) {
    if (!aAddon.id || !aAddon.version || !aAddon.type) {
      throw new Error("aAddon must include an id, version, and type");
    }

    // Only run in safe mode if allowed to
    let runInSafeMode = "runInSafeMode" in aAddon ? aAddon.runInSafeMode : canRunInSafeMode(aAddon);
    if (Services.appinfo.inSafeMode && !runInSafeMode)
      return;

    let timeStart = new Date();
    if (CHROME_TYPES.has(aAddon.type) && aMethod == "startup") {
      logger.debug("Registering manifest for " + aFile.path);
      Components.manager.addBootstrappedManifestLocation(aFile);
    }

    try {
      // Load the scope if it hasn't already been loaded
      let activeAddon = this.activeAddons.get(aAddon.id);
      if (!activeAddon) {
        this.loadBootstrapScope(aAddon.id, aFile, aAddon.version, aAddon.type,
                                aAddon.multiprocessCompatible || false,
                                runInSafeMode, aAddon.dependencies,
                                aAddon.hasEmbeddedWebExtension || false);
        activeAddon = this.activeAddons.get(aAddon.id);
      }

      if (aMethod == "startup" || aMethod == "shutdown") {
        if (!aExtraParams) {
          aExtraParams = {};
        }
        aExtraParams["instanceID"] = this.activeAddons.get(aAddon.id).instanceID;
      }

      // Nothing to call for locales
      if (aAddon.type == "locale")
        return;

      let method = undefined;
      try {
        let scope = activeAddon.bootstrapScope;
        method = scope[aMethod] || Cu.evalInSandbox(`${aMethod};`, scope);
      } catch (e) {
        // An exception will be caught if the expected method is not defined.
        // That will be logged below.
      }

      // Extensions are automatically deinitialized in the correct order at shutdown.
      if (aMethod == "shutdown" && aReason != BOOTSTRAP_REASONS.APP_SHUTDOWN) {
        activeAddon.disable = true;
        for (let addon of this.getDependentAddons(aAddon)) {
          if (addon.active)
            this.updateAddonDisabledState(addon);
        }
      }

      let params = {
        id: aAddon.id,
        version: aAddon.version,
        installPath: aFile.clone(),
        resourceURI: getURIForResourceInFile(aFile, "")
      };

      if (aExtraParams) {
        for (let key in aExtraParams) {
          params[key] = aExtraParams[key];
        }
      }

      if (aAddon.hasEmbeddedWebExtension) {
        if (aMethod == "startup") {
          const webExtension = LegacyExtensionsUtils.getEmbeddedExtensionFor(params);
          params.webExtension = {
            startup: () => webExtension.startup(),
          };
        } else if (aMethod == "shutdown") {
          LegacyExtensionsUtils.getEmbeddedExtensionFor(params).shutdown();
        }
      }

      if (!method) {
        logger.warn("Add-on " + aAddon.id + " is missing bootstrap method " + aMethod);
      } else {
        logger.debug("Calling bootstrap method " + aMethod + " on " + aAddon.id + " version " +
                     aAddon.version);
        try {
          method(params, aReason);
        } catch (e) {
          logger.warn("Exception running bootstrap method " + aMethod + " on " + aAddon.id, e);
        }
      }
    } finally {
      // Extensions are automatically initialized in the correct order at startup.
      if (aMethod == "startup" && aReason != BOOTSTRAP_REASONS.APP_STARTUP) {
        for (let addon of this.getDependentAddons(aAddon))
          this.updateAddonDisabledState(addon);
      }

      if (CHROME_TYPES.has(aAddon.type) && aMethod == "shutdown" && aReason != BOOTSTRAP_REASONS.APP_SHUTDOWN) {
        logger.debug("Removing manifest for " + aFile.path);
        Components.manager.removeBootstrappedManifestLocation(aFile);

        let manifest = getURIForResourceInFile(aFile, "chrome.manifest");
        for (let line of ChromeManifestParser.parseSync(manifest)) {
          if (line.type == "resource") {
            ResProtocolHandler.setSubstitution(line.args[0], null);
          }
        }
      }
      this.setTelemetry(aAddon.id, aMethod + "_MS", new Date() - timeStart);
    }
  },

  /**
   * Updates the disabled state for an add-on. Its appDisabled property will be
   * calculated and if the add-on is changed the database will be saved and
   * appropriate notifications will be sent out to the registered AddonListeners.
   *
   * @param  aAddon
   *         The DBAddonInternal to update
   * @param  aUserDisabled
   *         Value for the userDisabled property. If undefined the value will
   *         not change
   * @param  aSoftDisabled
   *         Value for the softDisabled property. If undefined the value will
   *         not change. If true this will force userDisabled to be true
   * @param  aPendingRestart
   *         If the addon is updated whilst the disabled state of another non-
   *         restartless addon is also set, we need to carry that forward.
   * @return a tri-state indicating the action taken for the add-on:
   *           - undefined: The add-on did not change state
   *           - true: The add-on because disabled
   *           - false: The add-on became enabled
   * @throws if addon is not a DBAddonInternal
   */
  updateAddonDisabledState(aAddon, aUserDisabled, aSoftDisabled, aPendingRestart = false) {
    if (!(aAddon.inDatabase))
      throw new Error("Can only update addon states for installed addons.");
    if (aUserDisabled !== undefined && aSoftDisabled !== undefined) {
      throw new Error("Cannot change userDisabled and softDisabled at the " +
                      "same time");
    }

    if (aUserDisabled === undefined) {
      aUserDisabled = aAddon.userDisabled;
    } else if (!aUserDisabled) {
      // If enabling the add-on then remove softDisabled
      aSoftDisabled = false;
    }

    // If not changing softDisabled or the add-on is already userDisabled then
    // use the existing value for softDisabled
    if (aSoftDisabled === undefined || aUserDisabled)
      aSoftDisabled = aAddon.softDisabled;

    let appDisabled = !isUsableAddon(aAddon);
    // No change means nothing to do here
    if (aAddon.userDisabled == aUserDisabled &&
        aAddon.appDisabled == appDisabled &&
        aAddon.softDisabled == aSoftDisabled)
      return undefined;

    let wasDisabled = aAddon.disabled;
    let isDisabled = aUserDisabled || aSoftDisabled || appDisabled;

    // If appDisabled changes but addon.disabled doesn't,
    // no onDisabling/onEnabling is sent - so send a onPropertyChanged.
    let appDisabledChanged = aAddon.appDisabled != appDisabled;

    // Update the properties in the database.
    XPIDatabase.setAddonProperties(aAddon, {
      userDisabled: aUserDisabled,
      appDisabled,
      softDisabled: aSoftDisabled
    });

    let wrapper = aAddon.wrapper;

    if (appDisabledChanged) {
      AddonManagerPrivate.callAddonListeners("onPropertyChanged",
                                             wrapper,
                                             ["appDisabled"]);
    }

    // If the add-on is not visible or the add-on is not changing state then
    // there is no need to do anything else
    if (!aAddon.visible || (wasDisabled == isDisabled))
      return undefined;

    // Flag that active states in the database need to be updated on shutdown
    Services.prefs.setBoolPref(PREF_PENDING_OPERATIONS, true);

    // Sync with XPIStates.
    let xpiState = XPIStates.getAddon(aAddon.location, aAddon.id);
    if (xpiState) {
      xpiState.syncWithDB(aAddon);
      XPIStates.save();
    } else {
      // There should always be an xpiState
      logger.warn("No XPIState for ${id} in ${location}", aAddon);
    }

    // Have we just gone back to the current state?
    if (isDisabled != aAddon.active) {
      AddonManagerPrivate.callAddonListeners("onOperationCancelled", wrapper);
    } else {
      if (isDisabled) {
        var needsRestart = aPendingRestart || this.disableRequiresRestart(aAddon);
        AddonManagerPrivate.callAddonListeners("onDisabling", wrapper,
                                               needsRestart);
      } else {
        needsRestart = this.enableRequiresRestart(aAddon);
        AddonManagerPrivate.callAddonListeners("onEnabling", wrapper,
                                               needsRestart);
      }

      if (!needsRestart) {
        XPIDatabase.updateAddonActive(aAddon, !isDisabled);

        if (isDisabled) {
          if (aAddon.bootstrap) {
            this.callBootstrapMethod(aAddon, aAddon._sourceBundle, "shutdown",
                                     BOOTSTRAP_REASONS.ADDON_DISABLE);
            this.unloadBootstrapScope(aAddon.id);
          }
          AddonManagerPrivate.callAddonListeners("onDisabled", wrapper);
        } else {
          if (aAddon.bootstrap) {
            this.callBootstrapMethod(aAddon, aAddon._sourceBundle, "startup",
                                     BOOTSTRAP_REASONS.ADDON_ENABLE);
          }
          AddonManagerPrivate.callAddonListeners("onEnabled", wrapper);
        }
      }
    }

    // Notify any other providers that a new theme has been enabled
    if (isTheme(aAddon.type) && !isDisabled) {
      AddonManagerPrivate.notifyAddonChanged(aAddon.id, aAddon.type, needsRestart);

      if (xpiState) {
        xpiState.syncWithDB(aAddon);
        XPIStates.save();
      }
    }

    return isDisabled;
  },

  /**
   * Uninstalls an add-on, immediately if possible or marks it as pending
   * uninstall if not.
   *
   * @param  aAddon
   *         The DBAddonInternal to uninstall
   * @param  aForcePending
   *         Force this addon into the pending uninstall state, even if
   *         it isn't marked as requiring a restart (used e.g. while the
   *         add-on manager is open and offering an "undo" button)
   * @throws if the addon cannot be uninstalled because it is in an install
   *         location that does not allow it
   */
  uninstallAddon(aAddon, aForcePending) {
    if (!(aAddon.inDatabase))
      throw new Error("Cannot uninstall addon " + aAddon.id + " because it is not installed");

    if (aAddon._installLocation.locked)
      throw new Error("Cannot uninstall addon " + aAddon.id
          + " from locked install location " + aAddon._installLocation.name);

    // Inactive add-ons don't require a restart to uninstall
    let requiresRestart = this.uninstallRequiresRestart(aAddon);

    // if makePending is true, we don't actually apply the uninstall,
    // we just mark the addon as having a pending uninstall
    let makePending = aForcePending || requiresRestart;

    if (makePending && aAddon.pendingUninstall)
      throw new Error("Add-on is already marked to be uninstalled");

    aAddon._hasResourceCache.clear();

    if (aAddon._updateCheck) {
      logger.debug("Cancel in-progress update check for " + aAddon.id);
      aAddon._updateCheck.cancel();
    }

    let wasPending = aAddon.pendingUninstall;

    if (makePending) {
      // We create an empty directory in the staging directory to indicate
      // that an uninstall is necessary on next startup. Temporary add-ons are
      // automatically uninstalled on shutdown anyway so there is no need to
      // do this for them.
      if (aAddon._installLocation.name != KEY_APP_TEMPORARY) {
        let stage = getFile(aAddon.id, aAddon._installLocation.getStagingDir());
        if (!stage.exists())
          stage.create(Ci.nsIFile.DIRECTORY_TYPE, FileUtils.PERMS_DIRECTORY);
      }

      XPIDatabase.setAddonProperties(aAddon, {
        pendingUninstall: true
      });
      Services.prefs.setBoolPref(PREF_PENDING_OPERATIONS, true);
      let xpiState = XPIStates.getAddon(aAddon.location, aAddon.id);
      if (xpiState) {
        xpiState.enabled = false;
        XPIStates.save();
      } else {
        logger.warn("Can't find XPI state while uninstalling ${id} from ${location}", aAddon);
      }
    }

    // If the add-on is not visible then there is no need to notify listeners.
    if (!aAddon.visible)
      return;

    let wrapper = aAddon.wrapper;

    // If the add-on wasn't already pending uninstall then notify listeners.
    if (!wasPending) {
      // Passing makePending as the requiresRestart parameter is a little
      // strange as in some cases this operation can complete without a restart
      // so really this is now saying that the uninstall isn't going to happen
      // immediately but will happen later.
      AddonManagerPrivate.callAddonListeners("onUninstalling", wrapper,
                                             makePending);
    }

    // Reveal the highest priority add-on with the same ID
    function revealAddon(aAddon) {
      XPIDatabase.makeAddonVisible(aAddon);

      let wrappedAddon = aAddon.wrapper;
      AddonManagerPrivate.callAddonListeners("onInstalling", wrappedAddon, false);

      if (!aAddon.disabled && !XPIProvider.enableRequiresRestart(aAddon)) {
        XPIDatabase.updateAddonActive(aAddon, true);
      }

      if (aAddon.bootstrap) {
        XPIProvider.callBootstrapMethod(aAddon, aAddon._sourceBundle,
                                        "install", BOOTSTRAP_REASONS.ADDON_INSTALL);

        if (aAddon.active) {
          XPIProvider.callBootstrapMethod(aAddon, aAddon._sourceBundle,
                                          "startup", BOOTSTRAP_REASONS.ADDON_INSTALL);
        } else {
          XPIProvider.unloadBootstrapScope(aAddon.id);
        }
      }

      // We always send onInstalled even if a restart is required to enable
      // the revealed add-on
      AddonManagerPrivate.callAddonListeners("onInstalled", wrappedAddon);
    }

    function findAddonAndReveal(aId) {
      let state = XPIStates.findAddon(aId);
      if (state) {
        XPIDatabase.getAddonInLocation(aId, state.location.name, revealAddon);
      }
    }

    if (!makePending) {
      if (aAddon.bootstrap) {
        if (aAddon.active) {
          this.callBootstrapMethod(aAddon, aAddon._sourceBundle, "shutdown",
                                   BOOTSTRAP_REASONS.ADDON_UNINSTALL);
        }

        this.callBootstrapMethod(aAddon, aAddon._sourceBundle, "uninstall",
                                 BOOTSTRAP_REASONS.ADDON_UNINSTALL);
        XPIStates.disableAddon(aAddon.id);
        this.unloadBootstrapScope(aAddon.id);
        flushChromeCaches();
      }
      aAddon._installLocation.uninstallAddon(aAddon.id);
      XPIDatabase.removeAddonMetadata(aAddon);
      XPIStates.removeAddon(aAddon.location, aAddon.id);
      AddonManagerPrivate.callAddonListeners("onUninstalled", wrapper);

      findAddonAndReveal(aAddon.id);
    } else if (aAddon.bootstrap && aAddon.active && !this.disableRequiresRestart(aAddon)) {
      this.callBootstrapMethod(aAddon, aAddon._sourceBundle, "shutdown",
                               BOOTSTRAP_REASONS.ADDON_UNINSTALL);
      XPIStates.disableAddon(aAddon.id);
      this.unloadBootstrapScope(aAddon.id);
      XPIDatabase.updateAddonActive(aAddon, false);
    }

    // Notify any other providers that a new theme has been enabled
    if (isTheme(aAddon.type) && aAddon.active)
      AddonManagerPrivate.notifyAddonChanged(null, aAddon.type, requiresRestart);
  },

  /**
   * Cancels the pending uninstall of an add-on.
   *
   * @param  aAddon
   *         The DBAddonInternal to cancel uninstall for
   */
  cancelUninstallAddon(aAddon) {
    if (!(aAddon.inDatabase))
      throw new Error("Can only cancel uninstall for installed addons.");
    if (!aAddon.pendingUninstall)
      throw new Error("Add-on is not marked to be uninstalled");

    if (aAddon._installLocation.name != KEY_APP_TEMPORARY)
      aAddon._installLocation.cleanStagingDir([aAddon.id]);

    XPIDatabase.setAddonProperties(aAddon, {
      pendingUninstall: false
    });

    if (!aAddon.visible)
      return;

    XPIStates.getAddon(aAddon.location, aAddon.id).syncWithDB(aAddon);
    XPIStates.save();

    Services.prefs.setBoolPref(PREF_PENDING_OPERATIONS, true);

    // TODO hide hidden add-ons (bug 557710)
    let wrapper = aAddon.wrapper;
    AddonManagerPrivate.callAddonListeners("onOperationCancelled", wrapper);

    if (aAddon.bootstrap && !aAddon.disabled && !this.enableRequiresRestart(aAddon)) {
      this.callBootstrapMethod(aAddon, aAddon._sourceBundle, "startup",
                               BOOTSTRAP_REASONS.ADDON_INSTALL);
      XPIDatabase.updateAddonActive(aAddon, true);
    }

    // Notify any other providers that this theme is now enabled again.
    if (isTheme(aAddon.type) && aAddon.active)
      AddonManagerPrivate.notifyAddonChanged(aAddon.id, aAddon.type, false);
  }
};

/**
 * Creates a new AddonInstall to install an add-on from a local file.
 *
 * @param  file
 *         The file to install
 * @param  location
 *         The location to install to
 * @returns Promise
 *          A Promise that resolves with the new install object.
 */
function createLocalInstall(file, location) {
  if (!location) {
    location = XPIProvider.installLocationsByName[KEY_APP_PROFILE];
  }
  let url = Services.io.newFileURI(file);

  try {
    let install = new LocalAddonInstall(location, url);
    return install.init().then(() => install);
  } catch (e) {
    logger.error("Error creating install", e);
    XPIProvider.removeActiveInstall(this);
    return Promise.resolve(null);
  }
}

// Maps instances of AddonInternal to AddonWrapper
const wrapperMap = new WeakMap();
let addonFor = wrapper => wrapperMap.get(wrapper);

/**
 * The AddonInternal is an internal only representation of add-ons. It may
 * have come from the database (see DBAddonInternal in XPIProviderUtils.jsm)
 * or an install manifest.
 */
function AddonInternal() {
  this._hasResourceCache = new Map();

  XPCOMUtils.defineLazyGetter(this, "wrapper", () => {
    return new AddonWrapper(this);
  });
}

AddonInternal.prototype = {
  _selectedLocale: null,
  _hasResourceCache: null,
  active: false,
  visible: false,
  userDisabled: false,
  appDisabled: false,
  softDisabled: false,
  sourceURI: null,
  releaseNotesURI: null,
  foreignInstall: false,
  seen: true,
  skinnable: false,

  /**
   * @property {Array<string>} dependencies
   *   An array of bootstrapped add-on IDs on which this add-on depends.
   *   The add-on will remain appDisabled if any of the dependent
   *   add-ons is not installed and enabled.
   */
  dependencies: Object.freeze([]),
  hasEmbeddedWebExtension: false,

  get selectedLocale() {
    if (this._selectedLocale)
      return this._selectedLocale;
    let locale = Locale.findClosestLocale(this.locales);
    this._selectedLocale = locale ? locale : this.defaultLocale;
    return this._selectedLocale;
  },

  get providesUpdatesSecurely() {
    return !!(this.updateKey || !this.updateURL ||
              this.updateURL.substring(0, 6) == "https:");
  },

  get isCorrectlySigned() {
    switch (this._installLocation.name) {
      case KEY_APP_SYSTEM_ADDONS:
        // System add-ons must be signed by the system key.
        return this.signedState == AddonManager.SIGNEDSTATE_SYSTEM

      case KEY_APP_SYSTEM_DEFAULTS:
      case KEY_APP_TEMPORARY:
        // Temporary and built-in system add-ons do not require signing.
        return true;

      case KEY_APP_SYSTEM_SHARE:
      case KEY_APP_SYSTEM_LOCAL:
        // On UNIX platforms except OSX, an additional location for system
        // add-ons exists in /usr/{lib,share}/mozilla/extensions. Add-ons
        // installed there do not require signing.
        if (Services.appinfo.OS != "Darwin")
          return true;
        break;
    }

    if (this.signedState === AddonManager.SIGNEDSTATE_NOT_REQUIRED)
      return true;
    return this.signedState > AddonManager.SIGNEDSTATE_MISSING;
  },

  get isCompatible() {
    return this.isCompatibleWith();
  },

  get disabled() {
    return (this.userDisabled || this.appDisabled || this.softDisabled);
  },

  get isPlatformCompatible() {
    if (this.targetPlatforms.length == 0)
      return true;

    let matchedOS = false;

    // If any targetPlatform matches the OS and contains an ABI then we will
    // only match a targetPlatform that contains both the current OS and ABI
    let needsABI = false;

    // Some platforms do not specify an ABI, test against null in that case.
    let abi = null;
    try {
      abi = Services.appinfo.XPCOMABI;
    } catch (e) { }

    // Something is causing errors in here
    try {
      for (let platform of this.targetPlatforms) {
        if (platform.os == Services.appinfo.OS) {
          if (platform.abi) {
            needsABI = true;
            if (platform.abi === abi)
              return true;
          } else {
            matchedOS = true;
          }
        }
      }
    } catch (e) {
      let message = "Problem with addon " + this.id + " targetPlatforms "
                    + JSON.stringify(this.targetPlatforms);
      logger.error(message, e);
      AddonManagerPrivate.recordException("XPI", message, e);
      // don't trust this add-on
      return false;
    }

    return matchedOS && !needsABI;
  },

  isCompatibleWith(aAppVersion, aPlatformVersion) {
    let app = this.matchingTargetApplication;
    if (!app)
      return false;

    // set reasonable defaults for minVersion and maxVersion
    let minVersion = app.minVersion || "0";
    let maxVersion = app.maxVersion || "*";

    if (!aAppVersion)
      aAppVersion = Services.appinfo.version;
    if (!aPlatformVersion)
      aPlatformVersion = Services.appinfo.platformVersion;

    let version;
    if (app.id == Services.appinfo.ID)
      version = aAppVersion;
    else if (app.id == TOOLKIT_ID)
      version = aPlatformVersion

    // Only extensions and dictionaries can be compatible by default; themes
    // and language packs always use strict compatibility checking.
    if (this.type in COMPATIBLE_BY_DEFAULT_TYPES &&
        !AddonManager.strictCompatibility && !this.strictCompatibility &&
        !this.hasBinaryComponents) {

      // The repository can specify compatibility overrides.
      // Note: For now, only blacklisting is supported by overrides.
      if (this._repositoryAddon &&
          this._repositoryAddon.compatibilityOverrides) {
        let overrides = this._repositoryAddon.compatibilityOverrides;
        let override = AddonRepository.findMatchingCompatOverride(this.version,
                                                                  overrides);
        if (override && override.type == "incompatible")
          return false;
      }

      // Extremely old extensions should not be compatible by default.
      let minCompatVersion;
      if (app.id == Services.appinfo.ID)
        minCompatVersion = XPIProvider.minCompatibleAppVersion;
      else if (app.id == TOOLKIT_ID)
        minCompatVersion = XPIProvider.minCompatiblePlatformVersion;

      if (minCompatVersion &&
          Services.vc.compare(minCompatVersion, maxVersion) > 0)
        return false;

      return Services.vc.compare(version, minVersion) >= 0;
    }

    return (Services.vc.compare(version, minVersion) >= 0) &&
           (Services.vc.compare(version, maxVersion) <= 0)
  },

  get matchingTargetApplication() {
    let app = null;
    for (let targetApp of this.targetApplications) {
      if (targetApp.id == Services.appinfo.ID)
        return targetApp;
      if (targetApp.id == TOOLKIT_ID)
        app = targetApp;
    }
    return app;
  },

  get blocklistState() {
    let staticItem = findMatchingStaticBlocklistItem(this);
    if (staticItem)
      return staticItem.level;

    return Blocklist.getAddonBlocklistState(this.wrapper);
  },

  get blocklistURL() {
    let staticItem = findMatchingStaticBlocklistItem(this);
    if (staticItem) {
      let url = Services.urlFormatter.formatURLPref("extensions.blocklist.itemURL");
      return url.replace(/%blockID%/g, staticItem.blockID);
    }

    return Blocklist.getAddonBlocklistURL(this.wrapper);
  },

  applyCompatibilityUpdate(aUpdate, aSyncCompatibility) {
    for (let targetApp of this.targetApplications) {
      for (let updateTarget of aUpdate.targetApplications) {
        if (targetApp.id == updateTarget.id && (aSyncCompatibility ||
            Services.vc.compare(targetApp.maxVersion, updateTarget.maxVersion) < 0)) {
          targetApp.minVersion = updateTarget.minVersion;
          targetApp.maxVersion = updateTarget.maxVersion;
        }
      }
    }
    if (aUpdate.multiprocessCompatible !== undefined)
      this.multiprocessCompatible = aUpdate.multiprocessCompatible;
    this.appDisabled = !isUsableAddon(this);
  },

  /**
   * getDataDirectory tries to execute the callback with two arguments:
   * 1) the path of the data directory within the profile,
   * 2) any exception generated from trying to build it.
   */
  getDataDirectory(callback) {
    let parentPath = OS.Path.join(OS.Constants.Path.profileDir, "extension-data");
    let dirPath = OS.Path.join(parentPath, this.id);

    (async function() {
      await OS.File.makeDir(parentPath, {ignoreExisting: true});
      await OS.File.makeDir(dirPath, {ignoreExisting: true});
    })().then(() => callback(dirPath, null),
            e => callback(dirPath, e));
  },

  /**
   * toJSON is called by JSON.stringify in order to create a filtered version
   * of this object to be serialized to a JSON file. A new object is returned
   * with copies of all non-private properties. Functions, getters and setters
   * are not copied.
   *
   * @param  aKey
   *         The key that this object is being serialized as in the JSON.
   *         Unused here since this is always the main object serialized
   *
   * @return an object containing copies of the properties of this object
   *         ignoring private properties, functions, getters and setters
   */
  toJSON(aKey) {
    let obj = {};
    for (let prop in this) {
      // Ignore the wrapper property
      if (prop == "wrapper")
        continue;

      // Ignore private properties
      if (prop.substring(0, 1) == "_")
        continue;

      // Ignore getters
      if (this.__lookupGetter__(prop))
        continue;

      // Ignore setters
      if (this.__lookupSetter__(prop))
        continue;

      // Ignore functions
      if (typeof this[prop] == "function")
        continue;

      obj[prop] = this[prop];
    }

    return obj;
  },

  /**
   * When an add-on install is pending its metadata will be cached in a file.
   * This method reads particular properties of that metadata that may be newer
   * than that in the install manifest, like compatibility information.
   *
   * @param  aObj
   *         A JS object containing the cached metadata
   */
  importMetadata(aObj) {
    for (let prop of PENDING_INSTALL_METADATA) {
      if (!(prop in aObj))
        continue;

      this[prop] = aObj[prop];
    }

    // Compatibility info may have changed so update appDisabled
    this.appDisabled = !isUsableAddon(this);
  },

  permissions() {
    let permissions = 0;

    // Add-ons that aren't installed cannot be modified in any way
    if (!(this.inDatabase))
      return permissions;

    if (!this.appDisabled) {
      if (this.userDisabled || this.softDisabled) {
        permissions |= AddonManager.PERM_CAN_ENABLE;
      } else if (this.type != "theme") {
        permissions |= AddonManager.PERM_CAN_DISABLE;
      }
    }

    // Add-ons that are in locked install locations, or are pending uninstall
    // cannot be upgraded or uninstalled
    if (!this._installLocation.locked && !this.pendingUninstall) {
      // Experiments cannot be upgraded.
      // System add-on upgrades are triggered through a different mechanism (see updateSystemAddons())
      let isSystem = this._installLocation.isSystem;
      // Add-ons that are installed by a file link cannot be upgraded.
      if (this.type != "experiment" &&
          !this._installLocation.isLinkedAddon(this.id) && !isSystem) {
        permissions |= AddonManager.PERM_CAN_UPGRADE;
      }

      permissions |= AddonManager.PERM_CAN_UNINSTALL;
    }

    return permissions;
  },
};

/**
 * The AddonWrapper wraps an Addon to provide the data visible to consumers of
 * the public API.
 */
function AddonWrapper(aAddon) {
  wrapperMap.set(this, aAddon);
}

AddonWrapper.prototype = {
  get __AddonInternal__() {
    return AppConstants.DEBUG ? addonFor(this) : undefined;
  },

  get seen() {
    return addonFor(this).seen;
  },

  get hasEmbeddedWebExtension() {
    return addonFor(this).hasEmbeddedWebExtension;
  },

  markAsSeen() {
    addonFor(this).seen = true;
    XPIDatabase.saveChanges();
  },

  get type() {
    return getExternalType(addonFor(this).type);
  },

  get isWebExtension() {
    return isWebExtension(addonFor(this).type);
  },

  get temporarilyInstalled() {
    return addonFor(this)._installLocation == TemporaryInstallLocation;
  },

  get aboutURL() {
    return this.isActive ? addonFor(this)["aboutURL"] : null;
  },

  get optionsURL() {
    if (!this.isActive) {
      return null;
    }

    let addon = addonFor(this);
    if (addon.optionsURL) {
      if (this.isWebExtension || this.hasEmbeddedWebExtension) {
        // The internal object's optionsURL property comes from the addons
        // DB and should be a relative URL.  However, extensions with
        // options pages installed before bug 1293721 was fixed got absolute
        // URLs in the addons db.  This code handles both cases.
        let policy = WebExtensionPolicy.getByID(addon.id);
        if (!policy) {
          return null;
        }
        let base = policy.getURL();
        return new URL(addon.optionsURL, base).href;
      }
      return addon.optionsURL;
    }

    if (this.hasResource("options.xul"))
      return this.getResourceURI("options.xul").spec;

    return null;
  },

  get optionsType() {
    if (!this.isActive)
      return null;

    let addon = addonFor(this);
    let hasOptionsXUL = this.hasResource("options.xul");
    let hasOptionsURL = !!this.optionsURL;

    if (addon.optionsType) {
      switch (parseInt(addon.optionsType, 10)) {
      case AddonManager.OPTIONS_TYPE_DIALOG:
      case AddonManager.OPTIONS_TYPE_TAB:
        return hasOptionsURL ? addon.optionsType : null;
      case AddonManager.OPTIONS_TYPE_INLINE:
      case AddonManager.OPTIONS_TYPE_INLINE_INFO:
      case AddonManager.OPTIONS_TYPE_INLINE_BROWSER:
        return (hasOptionsXUL || hasOptionsURL) ? addon.optionsType : null;
      }
      return null;
    }

    if (hasOptionsXUL)
      return AddonManager.OPTIONS_TYPE_INLINE;

    if (hasOptionsURL)
      return AddonManager.OPTIONS_TYPE_DIALOG;

    return null;
  },

  get optionsBrowserStyle() {
    let addon = addonFor(this);
    return addon.optionsBrowserStyle;
  },

  get iconURL() {
    return AddonManager.getPreferredIconURL(this, 48);
  },

  get icon64URL() {
    return AddonManager.getPreferredIconURL(this, 64);
  },

  get icons() {
    let addon = addonFor(this);
    let icons = {};

    if (addon._repositoryAddon) {
      for (let size in addon._repositoryAddon.icons) {
        icons[size] = addon._repositoryAddon.icons[size];
      }
    }

    if (addon.icons) {
      for (let size in addon.icons) {
        icons[size] = this.getResourceURI(addon.icons[size]).spec;
      }
    } else {
      // legacy add-on that did not update its icon data yet
      if (this.hasResource("icon.png")) {
        icons[32] = icons[48] = this.getResourceURI("icon.png").spec;
      }
      if (this.hasResource("icon64.png")) {
        icons[64] = this.getResourceURI("icon64.png").spec;
      }
    }

    let canUseIconURLs = this.isActive ||
      (addon.type == "theme" && addon.internalName == XPIProvider.defaultSkin);
    if (canUseIconURLs && addon.iconURL) {
      icons[32] = addon.iconURL;
      icons[48] = addon.iconURL;
    }

    if (canUseIconURLs && addon.icon64URL) {
      icons[64] = addon.icon64URL;
    }

    Object.freeze(icons);
    return icons;
  },

  get screenshots() {
    let addon = addonFor(this);
    let repositoryAddon = addon._repositoryAddon;
    if (repositoryAddon && ("screenshots" in repositoryAddon)) {
      let repositoryScreenshots = repositoryAddon.screenshots;
      if (repositoryScreenshots && repositoryScreenshots.length > 0)
        return repositoryScreenshots;
    }

    if (isTheme(addon.type) && this.hasResource("preview.png")) {
      let url = this.getResourceURI("preview.png").spec;
      return [new AddonManagerPrivate.AddonScreenshot(url)];
    }

    return null;
  },

  get applyBackgroundUpdates() {
    return addonFor(this).applyBackgroundUpdates;
  },
  set applyBackgroundUpdates(val) {
    let addon = addonFor(this);
    if (this.type == "experiment") {
      logger.warn("Setting applyBackgroundUpdates on an experiment is not supported.");
      return addon.applyBackgroundUpdates;
    }

    if (val != AddonManager.AUTOUPDATE_DEFAULT &&
        val != AddonManager.AUTOUPDATE_DISABLE &&
        val != AddonManager.AUTOUPDATE_ENABLE) {
      val = val ? AddonManager.AUTOUPDATE_DEFAULT :
                  AddonManager.AUTOUPDATE_DISABLE;
    }

    if (val == addon.applyBackgroundUpdates)
      return val;

    XPIDatabase.setAddonProperties(addon, {
      applyBackgroundUpdates: val
    });
    AddonManagerPrivate.callAddonListeners("onPropertyChanged", this, ["applyBackgroundUpdates"]);

    return val;
  },

  set syncGUID(val) {
    let addon = addonFor(this);
    if (addon.syncGUID == val)
      return val;

    if (addon.inDatabase)
      XPIDatabase.setAddonSyncGUID(addon, val);

    addon.syncGUID = val;

    return val;
  },

  get install() {
    let addon = addonFor(this);
    if (!("_install" in addon) || !addon._install)
      return null;
    return addon._install.wrapper;
  },

  get pendingUpgrade() {
    let addon = addonFor(this);
    return addon.pendingUpgrade ? addon.pendingUpgrade.wrapper : null;
  },

  get scope() {
    let addon = addonFor(this);
    if (addon._installLocation)
      return addon._installLocation.scope;

    return AddonManager.SCOPE_PROFILE;
  },

  get pendingOperations() {
    let addon = addonFor(this);
    let pending = 0;
    if (!(addon.inDatabase)) {
      // Add-on is pending install if there is no associated install (shouldn't
      // happen here) or if the install is in the process of or has successfully
      // completed the install. If an add-on is pending install then we ignore
      // any other pending operations.
      if (!addon._install || addon._install.state == AddonManager.STATE_INSTALLING ||
          addon._install.state == AddonManager.STATE_INSTALLED)
        return AddonManager.PENDING_INSTALL;
    } else if (addon.pendingUninstall) {
      // If an add-on is pending uninstall then we ignore any other pending
      // operations
      return AddonManager.PENDING_UNINSTALL;
    }

    if (addon.active && addon.disabled)
      pending |= AddonManager.PENDING_DISABLE;
    else if (!addon.active && !addon.disabled)
      pending |= AddonManager.PENDING_ENABLE;

    if (addon.pendingUpgrade)
      pending |= AddonManager.PENDING_UPGRADE;

    return pending;
  },

  get operationsRequiringRestart() {
    let addon = addonFor(this);
    let ops = 0;
    if (XPIProvider.installRequiresRestart(addon))
      ops |= AddonManager.OP_NEEDS_RESTART_INSTALL;
    if (XPIProvider.uninstallRequiresRestart(addon))
      ops |= AddonManager.OP_NEEDS_RESTART_UNINSTALL;
    if (XPIProvider.enableRequiresRestart(addon))
      ops |= AddonManager.OP_NEEDS_RESTART_ENABLE;
    if (XPIProvider.disableRequiresRestart(addon))
      ops |= AddonManager.OP_NEEDS_RESTART_DISABLE;

    return ops;
  },

  get isDebuggable() {
    return this.isActive && addonFor(this).bootstrap;
  },

  get permissions() {
    return addonFor(this).permissions();
  },

  get isActive() {
    let addon = addonFor(this);
    if (!addon.active)
      return false;
    if (!Services.appinfo.inSafeMode)
      return true;
    return addon.bootstrap && canRunInSafeMode(addon);
  },

  get userDisabled() {
    let addon = addonFor(this);
    return addon.softDisabled || addon.userDisabled;
  },
  set userDisabled(val) {
    let addon = addonFor(this);
    if (val == this.userDisabled) {
      return val;
    }

    if (addon.inDatabase) {
      let theme = isTheme(addon.type);
      if (theme && val) {
        if (addon.internalName == XPIProvider.defaultSkin)
          throw new Error("Cannot disable the default theme");
        XPIProvider.enableDefaultTheme();
      }
      if (!(theme && val) || isWebExtension(addon.type)) {
        // hidden and system add-ons should not be user disasbled,
        // as there is no UI to re-enable them.
        if (this.hidden) {
          throw new Error(`Cannot disable hidden add-on ${addon.id}`);
        }
        XPIProvider.updateAddonDisabledState(addon, val);
      }
    } else {
      addon.userDisabled = val;
      // When enabling remove the softDisabled flag
      if (!val)
        addon.softDisabled = false;
    }

    return val;
  },

  set softDisabled(val) {
    let addon = addonFor(this);
    if (val == addon.softDisabled)
      return val;

    if (addon.inDatabase) {
      // When softDisabling a theme just enable the active theme
      if (isTheme(addon.type) && val && !addon.userDisabled) {
        if (addon.internalName == XPIProvider.defaultSkin)
          throw new Error("Cannot disable the default theme");
        XPIProvider.enableDefaultTheme();
        if (isWebExtension(addon.type))
          XPIProvider.updateAddonDisabledState(addon, undefined, val);
      } else {
        XPIProvider.updateAddonDisabledState(addon, undefined, val);
      }
    } else if (!addon.userDisabled) {
      // Only set softDisabled if not already disabled
      addon.softDisabled = val;
    }

    return val;
  },

  get hidden() {
    let addon = addonFor(this);
    if (addon._installLocation.name == KEY_APP_TEMPORARY)
      return false;

    return addon._installLocation.isSystem;
  },

  get isSystem() {
    let addon = addonFor(this);
    return addon._installLocation.isSystem;
  },

  // Returns true if Firefox Sync should sync this addon. Only non-hotfixes
  // directly in the profile are considered syncable.
  get isSyncable() {
    let addon = addonFor(this);
    let hotfixID = Preferences.get(PREF_EM_HOTFIX_ID, undefined);
    if (hotfixID && hotfixID == addon.id) {
      return false;
    }
    return (addon._installLocation.name == KEY_APP_PROFILE);
  },

  get userPermissions() {
    return addonFor(this).userPermissions;
  },

  isCompatibleWith(aAppVersion, aPlatformVersion) {
    return addonFor(this).isCompatibleWith(aAppVersion, aPlatformVersion);
  },

  uninstall(alwaysAllowUndo) {
    let addon = addonFor(this);
    XPIProvider.uninstallAddon(addon, alwaysAllowUndo);
  },

  cancelUninstall() {
    let addon = addonFor(this);
    XPIProvider.cancelUninstallAddon(addon);
  },

  findUpdates(aListener, aReason, aAppVersion, aPlatformVersion) {
    // Short-circuit updates for experiments because updates are handled
    // through the Experiments Manager.
    if (this.type == "experiment") {
      AddonManagerPrivate.callNoUpdateListeners(this, aListener, aReason,
                                                aAppVersion, aPlatformVersion);
      return;
    }

    new UpdateChecker(addonFor(this), aListener, aReason, aAppVersion, aPlatformVersion);
  },

  // Returns true if there was an update in progress, false if there was no update to cancel
  cancelUpdate() {
    let addon = addonFor(this);
    if (addon._updateCheck) {
      addon._updateCheck.cancel();
      return true;
    }
    return false;
  },

  hasResource(aPath) {
    let addon = addonFor(this);
    if (addon._hasResourceCache.has(aPath))
      return addon._hasResourceCache.get(aPath);

    let bundle = addon._sourceBundle.clone();

    // Bundle may not exist any more if the addon has just been uninstalled,
    // but explicitly first checking .exists() results in unneeded file I/O.
    try {
      var isDir = bundle.isDirectory();
    } catch (e) {
      addon._hasResourceCache.set(aPath, false);
      return false;
    }

    if (isDir) {
      if (aPath)
        aPath.split("/").forEach(part => bundle.append(part));
      let result = bundle.exists();
      addon._hasResourceCache.set(aPath, result);
      return result;
    }

    let zipReader = Cc["@mozilla.org/libjar/zip-reader;1"].
                    createInstance(Ci.nsIZipReader);
    try {
      zipReader.open(bundle);
      let result = zipReader.hasEntry(aPath);
      addon._hasResourceCache.set(aPath, result);
      return result;
    } catch (e) {
      addon._hasResourceCache.set(aPath, false);
      return false;
    } finally {
      zipReader.close();
    }
  },

  /**
   * Reloads the add-on.
   *
   * For temporarily installed add-ons, this uninstalls and re-installs the
   * add-on. Otherwise, the addon is disabled and then re-enabled, and the cache
   * is flushed.
   *
   * @return Promise
   */
  reload() {
    return new Promise((resolve) => {
      const addon = addonFor(this);

      logger.debug(`reloading add-on ${addon.id}`);

      if (!this.temporarilyInstalled) {
        let addonFile = addon.getResourceURI;
        XPIProvider.updateAddonDisabledState(addon, true);
        Services.obs.notifyObservers(addonFile, "flush-cache-entry");
        XPIProvider.updateAddonDisabledState(addon, false)
        resolve();
      } else {
        // This function supports re-installing an existing add-on.
        resolve(AddonManager.installTemporaryAddon(addon._sourceBundle));
      }
    });
  },

  /**
   * Returns a URI to the selected resource or to the add-on bundle if aPath
   * is null. URIs to the bundle will always be file: URIs. URIs to resources
   * will be file: URIs if the add-on is unpacked or jar: URIs if the add-on is
   * still an XPI file.
   *
   * @param  aPath
   *         The path in the add-on to get the URI for or null to get a URI to
   *         the file or directory the add-on is installed as.
   * @return an nsIURI
   */
  getResourceURI(aPath) {
    let addon = addonFor(this);
    if (!aPath)
      return Services.io.newFileURI(addon._sourceBundle);

    return getURIForResourceInFile(addon._sourceBundle, aPath);
  }
};

function chooseValue(aAddon, aObj, aProp) {
  let repositoryAddon = aAddon._repositoryAddon;
  let objValue = aObj[aProp];

  if (repositoryAddon && (aProp in repositoryAddon) &&
      (objValue === undefined || objValue === null)) {
    return [repositoryAddon[aProp], true];
  }

  return [objValue, false];
}

function defineAddonWrapperProperty(name, getter) {
  Object.defineProperty(AddonWrapper.prototype, name, {
    get: getter,
    enumerable: true,
  });
}

["id", "syncGUID", "version", "isCompatible", "isPlatformCompatible",
 "providesUpdatesSecurely", "blocklistState", "blocklistURL", "appDisabled",
 "softDisabled", "skinnable", "size", "foreignInstall", "hasBinaryComponents",
 "strictCompatibility", "compatibilityOverrides", "updateURL", "dependencies",
 "getDataDirectory", "multiprocessCompatible", "signedState", "mpcOptedOut",
 "isCorrectlySigned"].forEach(function(aProp) {
   defineAddonWrapperProperty(aProp, function() {
     let addon = addonFor(this);
     return (aProp in addon) ? addon[aProp] : undefined;
   });
});

["fullDescription", "developerComments", "eula", "supportURL",
 "contributionURL", "contributionAmount", "averageRating", "reviewCount",
 "reviewURL", "totalDownloads", "weeklyDownloads", "dailyUsers",
 "repositoryStatus"].forEach(function(aProp) {
  defineAddonWrapperProperty(aProp, function() {
    let addon = addonFor(this);
    if (addon._repositoryAddon)
      return addon._repositoryAddon[aProp];

    return null;
  });
});

["installDate", "updateDate"].forEach(function(aProp) {
  defineAddonWrapperProperty(aProp, function() {
    return new Date(addonFor(this)[aProp]);
  });
});

["sourceURI", "releaseNotesURI"].forEach(function(aProp) {
  defineAddonWrapperProperty(aProp, function() {
    let addon = addonFor(this);

    // Temporary Installed Addons do not have a "sourceURI",
    // But we can use the "_sourceBundle" as an alternative,
    // which points to the path of the addon xpi installed
    // or its source dir (if it has been installed from a
    // directory).
    if (aProp == "sourceURI" && this.temporarilyInstalled) {
      return Services.io.newFileURI(addon._sourceBundle);
    }

    let [target, fromRepo] = chooseValue(addon, addon, aProp);
    if (!target)
      return null;
    if (fromRepo)
      return target;
    return Services.io.newURI(target);
  });
});

PROP_LOCALE_SINGLE.forEach(function(aProp) {
  defineAddonWrapperProperty(aProp, function() {
    let addon = addonFor(this);
    // Override XPI creator if repository creator is defined
    if (aProp == "creator" &&
        addon._repositoryAddon && addon._repositoryAddon.creator) {
      return addon._repositoryAddon.creator;
    }

    let result = null;

    if (addon.active) {
      try {
        let pref = PREF_EM_EXTENSION_FORMAT + addon.id + "." + aProp;
        let value = Preferences.get(pref, null, Ci.nsIPrefLocalizedString);
        if (value)
          result = value;
      } catch (e) {
      }
    }

    if (result == null)
      [result] = chooseValue(addon, addon.selectedLocale, aProp);

    if (aProp == "creator")
      return result ? new AddonManagerPrivate.AddonAuthor(result) : null;

    return result;
  });
});

PROP_LOCALE_MULTI.forEach(function(aProp) {
  defineAddonWrapperProperty(aProp, function() {
    let addon = addonFor(this);
    let results = null;
    let usedRepository = false;

    if (addon.active) {
      let pref = PREF_EM_EXTENSION_FORMAT + addon.id + "." +
                 aProp.substring(0, aProp.length - 1);
      let list = Services.prefs.getChildList(pref, {});
      if (list.length > 0) {
        list.sort();
        results = [];
        for (let childPref of list) {
          let value = Preferences.get(childPref, null, Ci.nsIPrefLocalizedString);
          if (value)
            results.push(value);
        }
      }
    }

    if (results == null)
      [results, usedRepository] = chooseValue(addon, addon.selectedLocale, aProp);

    if (results && !usedRepository) {
      results = results.map(function(aResult) {
        return new AddonManagerPrivate.AddonAuthor(aResult);
      });
    }

    return results;
  });
});

/**
 * An object which identifies a directory install location for add-ons. The
 * location consists of a directory which contains the add-ons installed in the
 * location.
 *
 */
class DirectoryInstallLocation {
  /**
   * Each add-on installed in the location is either a directory containing the
   * add-on's files or a text file containing an absolute path to the directory
   * containing the add-ons files. The directory or text file must have the same
   * name as the add-on's ID.
   *
   * @param  aName
   *         The string identifier for the install location
   * @param  aDirectory
   *         The nsIFile directory for the install location
   * @param  aScope
   *         The scope of add-ons installed in this location
  */
  constructor(aName, aDirectory, aScope) {
    this._name = aName;
    this.locked = true;
    this._directory = aDirectory;
    this._scope = aScope
    this._IDToFileMap = {};
    this._linkedAddons = [];

    this.isSystem = (aName == KEY_APP_SYSTEM_ADDONS ||
                     aName == KEY_APP_SYSTEM_DEFAULTS);

    if (!aDirectory || !aDirectory.exists())
      return;
    if (!aDirectory.isDirectory())
      throw new Error("Location must be a directory.");

    this.initialized = false;
  }

  get path() {
    return this._directory && this._directory.path;
  }

  /**
   * Reads a directory linked to in a file.
   *
   * @param   file
   *          The file containing the directory path
   * @return  An nsIFile object representing the linked directory.
   */
  _readDirectoryFromFile(aFile) {
    let linkedDirectory;
    if (aFile.isSymlink()) {
      linkedDirectory = aFile.clone();
      try {
        linkedDirectory.normalize();
      } catch (e) {
        logger.warn("Symbolic link " + aFile.path + " points to a path" +
             " which does not exist");
        return null;
      }
    } else {
      let fis = Cc["@mozilla.org/network/file-input-stream;1"].
                createInstance(Ci.nsIFileInputStream);
      fis.init(aFile, -1, -1, false);
      let line = { value: "" };
      if (fis instanceof Ci.nsILineInputStream)
        fis.readLine(line);
      fis.close();
      if (line.value) {
        linkedDirectory = Cc["@mozilla.org/file/local;1"].
                              createInstance(Ci.nsIFile);

        try {
          linkedDirectory.initWithPath(line.value);
        } catch (e) {
          linkedDirectory.setRelativeDescriptor(aFile.parent, line.value);
        }
      }
    }

    if (linkedDirectory) {
      if (!linkedDirectory.exists()) {
        logger.warn("File pointer " + aFile.path + " points to " + linkedDirectory.path +
             " which does not exist");
        return null;
      }

      if (!linkedDirectory.isDirectory()) {
        logger.warn("File pointer " + aFile.path + " points to " + linkedDirectory.path +
             " which is not a directory");
        return null;
      }

      return linkedDirectory;
    }

    logger.warn("File pointer " + aFile.path + " does not contain a path");
    return null;
  }

  /**
   * Finds all the add-ons installed in this location.
   */
  _readAddons(rescan = false) {
    if ((this.initialized && !rescan) || !this._directory) {
      return;
    }
    this.initialized = true;

    // Use a snapshot of the directory contents to avoid possible issues with
    // iterating over a directory while removing files from it (the YAFFS2
    // embedded filesystem has this issue, see bug 772238).
    let entries = getDirectoryEntries(this._directory);
    for (let entry of entries) {
      let id = entry.leafName;

      if (id == DIR_STAGE || id == DIR_TRASH)
        continue;

      let directLoad = false;
      if (entry.isFile() &&
          id.substring(id.length - 4).toLowerCase() == ".xpi") {
        directLoad = true;
        id = id.substring(0, id.length - 4);
      }

      if (!gIDTest.test(id)) {
        logger.debug("Ignoring file entry whose name is not a valid add-on ID: " +
             entry.path);
        continue;
      }

      if (!directLoad && (entry.isFile() || entry.isSymlink())) {
        let newEntry = this._readDirectoryFromFile(entry);
        if (!newEntry) {
          logger.debug("Deleting stale pointer file " + entry.path);
          try {
            entry.remove(true);
          } catch (e) {
            logger.warn("Failed to remove stale pointer file " + entry.path, e);
            // Failing to remove the stale pointer file is ignorable
          }
          continue;
        }

        entry = newEntry;
        this._linkedAddons.push(id);
      }

      this._IDToFileMap[id] = entry;
      XPIProvider._addURIMapping(id, entry);
    }
  }

  /**
   * Gets the name of this install location.
   */
  get name() {
    return this._name;
  }

  /**
   * Gets the scope of this install location.
   */
  get scope() {
    return this._scope;
  }

  /**
   * Gets an array of nsIFiles for add-ons installed in this location.
   */
  getAddonLocations(rescan = false) {
    this._readAddons(rescan);

    let locations = new Map();
    for (let id in this._IDToFileMap) {
      locations.set(id, this._IDToFileMap[id].clone());
    }
    return locations;
  }

  /**
   * Gets the directory that the add-on with the given ID is installed in.
   *
   * @param  aId
   *         The ID of the add-on
   * @return The nsIFile
   * @throws if the ID does not match any of the add-ons installed
   */
  getLocationForID(aId) {
    if (!(aId in this._IDToFileMap))
      this._readAddons();

    if (aId in this._IDToFileMap)
      return this._IDToFileMap[aId].clone();
    throw new Error("Unknown add-on ID " + aId);
  }

  /**
   * Returns true if the given addon was installed in this location by a text
   * file pointing to its real path.
   *
   * @param aId
   *        The ID of the addon
   */
  isLinkedAddon(aId) {
    return this._linkedAddons.indexOf(aId) != -1;
  }
}

/**
 * An extension of DirectoryInstallLocation which adds methods to installing
 * and removing add-ons from the directory at runtime.
 */
class MutableDirectoryInstallLocation extends DirectoryInstallLocation {
  /**
   * @param  aName
   *         The string identifier for the install location
   * @param  aDirectory
   *         The nsIFile directory for the install location
   * @param  aScope
   *         The scope of add-ons installed in this location
   */
  constructor(aName, aDirectory, aScope) {
    super(aName, aDirectory, aScope);

    this.locked = false;
    this._stagingDirLock = 0;
  }

  /**
   * Gets the staging directory to put add-ons that are pending install and
   * uninstall into.
   *
   * @return an nsIFile
   */
  getStagingDir() {
    return getFile(DIR_STAGE, this._directory);
  }

  requestStagingDir() {
    this._stagingDirLock++;

    if (this._stagingDirPromise)
      return this._stagingDirPromise;

    OS.File.makeDir(this._directory.path);
    let stagepath = OS.Path.join(this._directory.path, DIR_STAGE);
    return this._stagingDirPromise = OS.File.makeDir(stagepath).then(null, (e) => {
      if (e instanceof OS.File.Error && e.becauseExists)
        return;
      logger.error("Failed to create staging directory", e);
      throw e;
    });
  }

  releaseStagingDir() {
    this._stagingDirLock--;

    if (this._stagingDirLock == 0) {
      this._stagingDirPromise = null;
      this.cleanStagingDir();
    }

    return Promise.resolve();
  }

  /**
   * Removes the specified files or directories in the staging directory and
   * then if the staging directory is empty attempts to remove it.
   *
   * @param  aLeafNames
   *         An array of file or directory to remove from the directory, the
   *         array may be empty
   */
  cleanStagingDir(aLeafNames = []) {
    let dir = this.getStagingDir();

    for (let name of aLeafNames) {
      let file = getFile(name, dir);
      recursiveRemove(file);
    }

    if (this._stagingDirLock > 0)
      return;

    let dirEntries = dir.directoryEntries.QueryInterface(Ci.nsIDirectoryEnumerator);
    try {
      if (dirEntries.nextFile)
        return;
    } finally {
      dirEntries.close();
    }

    try {
      setFilePermissions(dir, FileUtils.PERMS_DIRECTORY);
      dir.remove(false);
    } catch (e) {
      logger.warn("Failed to remove staging dir", e);
      // Failing to remove the staging directory is ignorable
    }
  }

  /**
   * Returns a directory that is normally on the same filesystem as the rest of
   * the install location and can be used for temporarily storing files during
   * safe move operations. Calling this method will delete the existing trash
   * directory and its contents.
   *
   * @return an nsIFile
   */
  getTrashDir() {
    let trashDir = getFile(DIR_TRASH, this._directory);
    let trashDirExists = trashDir.exists();
    try {
      if (trashDirExists)
        recursiveRemove(trashDir);
      trashDirExists = false;
    } catch (e) {
      logger.warn("Failed to remove trash directory", e);
    }
    if (!trashDirExists)
      trashDir.create(Ci.nsIFile.DIRECTORY_TYPE, FileUtils.PERMS_DIRECTORY);

    return trashDir;
  }

  /**
   * Installs an add-on into the install location.
   *
   * @param  id
   *         The ID of the add-on to install
   * @param  source
   *         The source nsIFile to install from
   * @param  existingAddonID
   *         The ID of an existing add-on to uninstall at the same time
   * @param  action
   *         What to we do with the given source file:
   *           "move"
   *           Default action, the source files will be moved to the new
   *           location,
   *           "copy"
   *           The source files will be copied,
   *           "proxy"
   *           A "proxy file" is going to refer to the source file path
   * @return an nsIFile indicating where the add-on was installed to
   */
  installAddon({ id, source, existingAddonID, action = "move" }) {
    let trashDir = this.getTrashDir();

    let transaction = new SafeInstallOperation();

    let moveOldAddon = aId => {
      let file = getFile(aId, this._directory);
      if (file.exists())
        transaction.moveUnder(file, trashDir);

      file = getFile(`${aId}.xpi`, this._directory);
      if (file.exists()) {
        flushJarCache(file);
        transaction.moveUnder(file, trashDir);
      }
    }

    // If any of these operations fails the finally block will clean up the
    // temporary directory
    try {
      moveOldAddon(id);
      if (existingAddonID && existingAddonID != id) {
        moveOldAddon(existingAddonID);

        {
          // Move the data directories.
          /* XXX ajvincent We can't use OS.File:  installAddon isn't compatible
           * with Promises, nor is SafeInstallOperation.  Bug 945540 has been filed
           * for porting to OS.File.
           */
          let oldDataDir = FileUtils.getDir(
            KEY_PROFILEDIR, ["extension-data", existingAddonID], false, true
          );

          if (oldDataDir.exists()) {
            let newDataDir = FileUtils.getDir(
              KEY_PROFILEDIR, ["extension-data", id], false, true
            );
            if (newDataDir.exists()) {
              let trashData = getFile("data-directory", trashDir);
              transaction.moveUnder(newDataDir, trashData);
            }

            transaction.moveTo(oldDataDir, newDataDir);
          }
        }
      }

      if (action == "copy") {
        transaction.copy(source, this._directory);
      } else if (action == "move") {
        if (source.isFile())
          flushJarCache(source);

        transaction.moveUnder(source, this._directory);
      }
      // Do nothing for the proxy file as we sideload an addon permanently
    } finally {
      // It isn't ideal if this cleanup fails but it isn't worth rolling back
      // the install because of it.
      try {
        recursiveRemove(trashDir);
      } catch (e) {
        logger.warn("Failed to remove trash directory when installing " + id, e);
      }
    }

    let newFile = this._directory.clone();

    if (action == "proxy") {
      // When permanently installing sideloaded addon, we just put a proxy file
      // refering to the addon sources
      newFile.append(id);

      writeStringToFile(newFile, source.path);
    } else {
      newFile.append(source.leafName);
    }

    try {
      newFile.lastModifiedTime = Date.now();
    } catch (e) {
      logger.warn("failed to set lastModifiedTime on " + newFile.path, e);
    }
    this._IDToFileMap[id] = newFile;
    XPIProvider._addURIMapping(id, newFile);

    if (existingAddonID && existingAddonID != id &&
        existingAddonID in this._IDToFileMap) {
      delete this._IDToFileMap[existingAddonID];
    }

    return newFile;
  }

  /**
   * Uninstalls an add-on from this location.
   *
   * @param  aId
   *         The ID of the add-on to uninstall
   * @throws if the ID does not match any of the add-ons installed
   */
  uninstallAddon(aId) {
    let file = this._IDToFileMap[aId];
    if (!file) {
      logger.warn("Attempted to remove " + aId + " from " +
           this._name + " but it was already gone");
      return;
    }

    file = getFile(aId, this._directory);
    if (!file.exists())
      file.leafName += ".xpi";

    if (!file.exists()) {
      logger.warn("Attempted to remove " + aId + " from " +
           this._name + " but it was already gone");

      delete this._IDToFileMap[aId];
      return;
    }

    let trashDir = this.getTrashDir();

    if (file.leafName != aId) {
      logger.debug("uninstallAddon: flushing jar cache " + file.path + " for addon " + aId);
      flushJarCache(file);
    }

    let transaction = new SafeInstallOperation();

    try {
      transaction.moveUnder(file, trashDir);
    } finally {
      // It isn't ideal if this cleanup fails, but it is probably better than
      // rolling back the uninstall at this point
      try {
        recursiveRemove(trashDir);
      } catch (e) {
        logger.warn("Failed to remove trash directory when uninstalling " + aId, e);
      }
    }

    XPIStates.removeAddon(this.name, aId);

    delete this._IDToFileMap[aId];
  }
}

/**
 * An object which identifies a directory install location for system add-ons
 * updates.
 */
class SystemAddonInstallLocation extends MutableDirectoryInstallLocation {
  /**
    * The location consists of a directory which contains the add-ons installed.
    *
    * @param  aName
    *         The string identifier for the install location
    * @param  aDirectory
    *         The nsIFile directory for the install location
    * @param  aScope
    *         The scope of add-ons installed in this location
    * @param  aResetSet
    *         True to throw away the current add-on set
    */
  constructor(aName, aDirectory, aScope, aResetSet) {
    let addonSet = SystemAddonInstallLocation._loadAddonSet();
    let directory = null;

    // The system add-on update directory is stored in a pref.
    // Therefore, this is looked up before calling the
    // constructor on the superclass.
    if (addonSet.directory) {
      directory = getFile(addonSet.directory, aDirectory);
      logger.info("SystemAddonInstallLocation scanning directory " + directory.path);
    } else {
      logger.info("SystemAddonInstallLocation directory is missing");
    }

    super(aName, directory, aScope);

    this._addonSet = addonSet;
    this._baseDir = aDirectory;
    this._nextDir = null;
    this._directory = directory;

    this._stagingDirLock = 0;

    if (aResetSet) {
      this.resetAddonSet();
    }

    this.locked = false;
  }

  /**
   * Gets the staging directory to put add-ons that are pending install and
   * uninstall into.
   *
   * @return {nsIFile} - staging directory for system add-on upgrades.
   */
  getStagingDir() {
    this._addonSet = SystemAddonInstallLocation._loadAddonSet();
    let dir = null;
    if (this._addonSet.directory) {
      this._directory = getFile(this._addonSet.directory, this._baseDir);
      dir = getFile(DIR_STAGE, this._directory);
    } else {
      logger.info("SystemAddonInstallLocation directory is missing");
    }

    return dir;
  }

  requestStagingDir() {
    this._addonSet = SystemAddonInstallLocation._loadAddonSet();
    if (this._addonSet.directory) {
      this._directory = getFile(this._addonSet.directory, this._baseDir);
    }
    return super.requestStagingDir();
  }

  /**
   * Reads the current set of system add-ons
   */
  static _loadAddonSet() {
    try {
      let setStr = Preferences.get(PREF_SYSTEM_ADDON_SET, null);
      if (setStr) {
        let addonSet = JSON.parse(setStr);
        if ((typeof addonSet == "object") && addonSet.schema == 1) {
          return addonSet;
        }
      }
    } catch (e) {
      logger.error("Malformed system add-on set, resetting.");
    }

    return { schema: 1, addons: {} };
  }

  /**
   * Saves the current set of system add-ons
   *
   * @param {Object} aAddonSet - object containing schema, directory and set
   *                 of system add-on IDs and versions.
   */
  static _saveAddonSet(aAddonSet) {
    Preferences.set(PREF_SYSTEM_ADDON_SET, JSON.stringify(aAddonSet));
  }

  getAddonLocations() {
    // Updated system add-ons are ignored in safe mode
    if (Services.appinfo.inSafeMode) {
      return new Map();
    }

    let addons = super.getAddonLocations();

    // Strip out any unexpected add-ons from the list
    for (let id of addons.keys()) {
      if (!(id in this._addonSet.addons)) {
        addons.delete(id);
      }
    }

    return addons;
  }

  /**
   * Tests whether updated system add-ons are expected.
   */
  isActive() {
    return this._directory != null;
  }

  isValidAddon(aAddon) {
    if (aAddon.appDisabled) {
      logger.warn(`System add-on ${aAddon.id} isn't compatible with the application.`);
      return false;
    }

    if (aAddon.unpack) {
      logger.warn(`System add-on ${aAddon.id} isn't a packed add-on.`);
      return false;
    }

    if (!aAddon.bootstrap) {
      logger.warn(`System add-on ${aAddon.id} isn't restartless.`);
      return false;
    }

    if (!aAddon.multiprocessCompatible) {
      logger.warn(`System add-on ${aAddon.id} isn't multiprocess compatible.`);
      return false;
    }

    return true;
  }

  /**
   * Tests whether the loaded add-on information matches what is expected.
   */
  isValid(aAddons) {
    for (let id of Object.keys(this._addonSet.addons)) {
      if (!aAddons.has(id)) {
        logger.warn(`Expected add-on ${id} is missing from the system add-on location.`);
        return false;
      }

      let addon = aAddons.get(id);
      if (addon.version != this._addonSet.addons[id].version) {
        logger.warn(`Expected system add-on ${id} to be version ${this._addonSet.addons[id].version} but was ${addon.version}.`);
        return false;
      }

      if (!this.isValidAddon(addon))
        return false;
    }

    return true;
  }

  /**
   * Resets the add-on set so on the next startup the default set will be used.
   */
  resetAddonSet() {
    logger.info("Removing all system add-on upgrades.");

    // remove everything from the pref first, if uninstall
    // fails then at least they will not be re-activated on
    // next restart.
    this._addonSet = { schema: 1, addons: {} };
    SystemAddonInstallLocation._saveAddonSet(this._addonSet);

    // If this is running at app startup, the pref being cleared
    // will cause later stages of startup to notice that the
    // old updates are now gone.
    //
    // Updates will only be explicitly uninstalled if they are
    // removed restartlessly, for instance if they are no longer
    // part of the latest update set.
    if (this._addonSet) {
      for (let id of Object.keys(this._addonSet.addons)) {
        AddonManager.getAddonByID(id, addon => {
          if (addon) {
            addon.uninstall();
          }
        });
      }
    }
  }

  /**
   * Removes any directories not currently in use or pending use after a
   * restart. Any errors that happen here don't really matter as we'll attempt
   * to cleanup again next time.
   */
  async cleanDirectories() {
    // System add-ons directory does not exist
    if (!(await OS.File.exists(this._baseDir.path))) {
      return;
    }

    let iterator;
    try {
      iterator = new OS.File.DirectoryIterator(this._baseDir.path);
    } catch (e) {
      logger.error("Failed to clean updated system add-ons directories.", e);
      return;
    }

    try {
      for (let promise in iterator) {
        let entry = await promise;

        // Skip the directory currently in use
        if (this._directory && this._directory.path == entry.path) {
          continue;
        }

        // Skip the next directory
        if (this._nextDir && this._nextDir.path == entry.path) {
          continue;
        }

        if (entry.isDir) {
           await OS.File.removeDir(entry.path, {
             ignoreAbsent: true,
             ignorePermissions: true,
           });
         } else {
           await OS.File.remove(entry.path, {
             ignoreAbsent: true,
           });
         }
       }

    } catch (e) {
      logger.error("Failed to clean updated system add-ons directories.", e);
    } finally {
      iterator.close();
    }
  }

  /**
   * Installs a new set of system add-ons into the location and updates the
   * add-on set in prefs.
   *
   * @param {Array} aAddons - An array of addons to install.
   */
  async installAddonSet(aAddons) {
    // Make sure the base dir exists
    await OS.File.makeDir(this._baseDir.path, { ignoreExisting: true });

    let addonSet = SystemAddonInstallLocation._loadAddonSet();

    // Remove any add-ons that are no longer part of the set.
    for (let addonID of Object.keys(addonSet.addons)) {
      if (!aAddons.includes(addonID)) {
        AddonManager.getAddonByID(addonID, a => a.uninstall());
      }
    }

    let newDir = this._baseDir.clone();

    let uuidGen = Cc["@mozilla.org/uuid-generator;1"].
                  getService(Ci.nsIUUIDGenerator);
    newDir.append("blank");

    while (true) {
      newDir.leafName = uuidGen.generateUUID().toString();

      try {
        await OS.File.makeDir(newDir.path, { ignoreExisting: false });
        break;
      } catch (e) {
        logger.debug("Could not create new system add-on updates dir, retrying", e);
      }
    }

    // Record the new upgrade directory.
    let state = { schema: 1, directory: newDir.leafName, addons: {} };
    SystemAddonInstallLocation._saveAddonSet(state);

    this._nextDir = newDir;
    let location = this;

    let installs = [];
    for (let addon of aAddons) {
      let install = await createLocalInstall(addon._sourceBundle, location);
      installs.push(install);
    }

    async function installAddon(install) {
      // Make the new install own its temporary file.
      install.ownsTempFile = true;
      install.install();
    }

    async function postponeAddon(install) {
      let resumeFn;
      if (AddonManagerPrivate.hasUpgradeListener(install.addon.id)) {
        logger.info(`system add-on ${install.addon.id} has an upgrade listener, postponing upgrade set until restart`);
        resumeFn = () => {
          logger.info(`${install.addon.id} has resumed a previously postponed addon set`);
          install.installLocation.resumeAddonSet(installs);
        }
      }
      await install.postpone(resumeFn);
    }

    let previousState;

    try {
      // All add-ons in position, create the new state and store it in prefs
      state = { schema: 1, directory: newDir.leafName, addons: {} };
      for (let addon of aAddons) {
        state.addons[addon.id] = {
          version: addon.version
        }
      }

      previousState = SystemAddonInstallLocation._loadAddonSet();
      SystemAddonInstallLocation._saveAddonSet(state);

      let blockers = aAddons.filter(
        addon => AddonManagerPrivate.hasUpgradeListener(addon.id)
      );

      if (blockers.length > 0) {
        await waitForAllPromises(installs.map(postponeAddon));
      } else {
        await waitForAllPromises(installs.map(installAddon));
      }
    } catch (e) {
      // Roll back to previous upgrade set (if present) on restart.
      if (previousState) {
        SystemAddonInstallLocation._saveAddonSet(previousState);
      }
      // Otherwise, roll back to built-in set on restart.
      // TODO try to do these restartlessly
      this.resetAddonSet();

      try {
        await OS.File.removeDir(newDir.path, { ignorePermissions: true });
      } catch (e) {
        logger.warn(`Failed to remove failed system add-on directory ${newDir.path}.`, e);
      }
      throw e;
    }
  }

 /**
  * Resumes upgrade of a previously-delayed add-on set.
  */
  async resumeAddonSet(installs) {
    async function resumeAddon(install) {
      install.state = AddonManager.STATE_DOWNLOADED;
      install.installLocation.releaseStagingDir();
      install.install();
    }

    let blockers = installs.filter(
      install => AddonManagerPrivate.hasUpgradeListener(install.addon.id)
    );

    if (blockers.length > 1) {
      logger.warn("Attempted to resume system add-on install but upgrade blockers are still present");
    } else {
      await waitForAllPromises(installs.map(resumeAddon));
    }
  }

  /**
   * Returns a directory that is normally on the same filesystem as the rest of
   * the install location and can be used for temporarily storing files during
   * safe move operations. Calling this method will delete the existing trash
   * directory and its contents.
   *
   * @return an nsIFile
   */
  getTrashDir() {
    let trashDir = getFile(DIR_TRASH, this._directory);
    let trashDirExists = trashDir.exists();
    try {
      if (trashDirExists)
        recursiveRemove(trashDir);
      trashDirExists = false;
    } catch (e) {
      logger.warn("Failed to remove trash directory", e);
    }
    if (!trashDirExists)
      trashDir.create(Ci.nsIFile.DIRECTORY_TYPE, FileUtils.PERMS_DIRECTORY);

    return trashDir;
  }

  /**
   * Installs an add-on into the install location.
   *
   * @param  id
   *         The ID of the add-on to install
   * @param  source
   *         The source nsIFile to install from
   * @return an nsIFile indicating where the add-on was installed to
   */
  installAddon({id, source}) {
    let trashDir = this.getTrashDir();
    let transaction = new SafeInstallOperation();

    // If any of these operations fails the finally block will clean up the
    // temporary directory
    try {
      if (source.isFile()) {
        flushJarCache(source);
      }

      transaction.moveUnder(source, this._directory);
    } finally {
      // It isn't ideal if this cleanup fails but it isn't worth rolling back
      // the install because of it.
      try {
        recursiveRemove(trashDir);
      } catch (e) {
        logger.warn("Failed to remove trash directory when installing " + id, e);
      }
    }

    let newFile = getFile(source.leafName, this._directory);

    try {
      newFile.lastModifiedTime = Date.now();
    } catch (e) {
      logger.warn("failed to set lastModifiedTime on " + newFile.path, e);
    }
    this._IDToFileMap[id] = newFile;
    XPIProvider._addURIMapping(id, newFile);

    return newFile;
  }

  // old system add-on upgrade dirs get automatically removed
  uninstallAddon(aAddon) {}
}

/**
 * An object which identifies an install location for temporary add-ons.
 */
const TemporaryInstallLocation = {
  locked: false,
  name: KEY_APP_TEMPORARY,
  scope: AddonManager.SCOPE_TEMPORARY,
  getAddonLocations: () => [],
  isLinkedAddon: () => false,
  installAddon: () => {},
  uninstallAddon: (aAddon) => {},
  getStagingDir: () => {},
}

/**
 * An object that identifies a registry install location for add-ons. The location
 * consists of a registry key which contains string values mapping ID to the
 * path where an add-on is installed
 *
 */
class WinRegInstallLocation extends DirectoryInstallLocation {
  /**
    * @param  aName
    *         The string identifier of this Install Location.
    * @param  aRootKey
    *         The root key (one of the ROOT_KEY_ values from nsIWindowsRegKey).
    * @param  scope
    *         The scope of add-ons installed in this location
    */
  constructor(aName, aRootKey, aScope) {
    super(aName, undefined, aScope);

    this.locked = true;
    this._name = aName;
    this._rootKey = aRootKey;
    this._scope = aScope;
    this._IDToFileMap = {};

    let path = this._appKeyPath + "\\Extensions";
    let key = Cc["@mozilla.org/windows-registry-key;1"].
              createInstance(Ci.nsIWindowsRegKey);

    // Reading the registry may throw an exception, and that's ok.  In error
    // cases, we just leave ourselves in the empty state.
    try {
      key.open(this._rootKey, path, Ci.nsIWindowsRegKey.ACCESS_READ);
    } catch (e) {
      return;
    }

    this._readAddons(key);
    key.close();
  }

  /**
   * Retrieves the path of this Application's data key in the registry.
   */
  get _appKeyPath() {
    let appVendor = Services.appinfo.vendor;
    let appName = Services.appinfo.name;

    // XXX Thunderbird doesn't specify a vendor string
    if (AppConstants.MOZ_APP_NAME == "thunderbird" && appVendor == "")
      appVendor = "Mozilla";

    // XULRunner-based apps may intentionally not specify a vendor
    if (appVendor != "")
      appVendor += "\\";

    return "SOFTWARE\\" + appVendor + appName;
  }

  /**
   * Read the registry and build a mapping between ID and path for each
   * installed add-on.
   *
   * @param  key
   *         The key that contains the ID to path mapping
   */
  _readAddons(aKey) {
    let count = aKey.valueCount;
    for (let i = 0; i < count; ++i) {
      let id = aKey.getValueName(i);

      let file = new nsIFile(aKey.readStringValue(id));

      if (!file.exists()) {
        logger.warn("Ignoring missing add-on in " + file.path);
        continue;
      }

      this._IDToFileMap[id] = file;
      XPIProvider._addURIMapping(id, file);
    }
  }

  /**
   * Gets the name of this install location.
   */
  get name() {
    return this._name;
  }

  /**
   * @see DirectoryInstallLocation
   */
  isLinkedAddon(aId) {
    return true;
  }
}

this.XPIInternal = {
  AddonInternal,
  BOOTSTRAP_REASONS,
  KEY_APP_SYSTEM_ADDONS,
  KEY_APP_SYSTEM_DEFAULTS,
  KEY_APP_TEMPORARY,
  TEMPORARY_ADDON_SUFFIX,
  TOOLKIT_ID,
  XPIStates,
  applyBlocklistChanges,
  getExternalType,
  isTheme,
  isUsableAddon,
  isWebExtension,
  recordAddonTelemetry,

  get XPIDatabase() { return gGlobalScope.XPIDatabase; },
};

var addonTypes = [
  new AddonManagerPrivate.AddonType("extension", URI_EXTENSION_STRINGS,
                                    STRING_TYPE_NAME,
                                    AddonManager.VIEW_TYPE_LIST, 4000,
                                    AddonManager.TYPE_SUPPORTS_UNDO_RESTARTLESS_UNINSTALL),
  new AddonManagerPrivate.AddonType("theme", URI_EXTENSION_STRINGS,
                                    STRING_TYPE_NAME,
                                    AddonManager.VIEW_TYPE_LIST, 5000),
  new AddonManagerPrivate.AddonType("dictionary", URI_EXTENSION_STRINGS,
                                    STRING_TYPE_NAME,
                                    AddonManager.VIEW_TYPE_LIST, 7000,
                                    AddonManager.TYPE_UI_HIDE_EMPTY | AddonManager.TYPE_SUPPORTS_UNDO_RESTARTLESS_UNINSTALL),
  new AddonManagerPrivate.AddonType("locale", URI_EXTENSION_STRINGS,
                                    STRING_TYPE_NAME,
                                    AddonManager.VIEW_TYPE_LIST, 8000,
                                    AddonManager.TYPE_UI_HIDE_EMPTY | AddonManager.TYPE_SUPPORTS_UNDO_RESTARTLESS_UNINSTALL),
];

// We only register experiments support if the application supports them.
// Ideally, we would install an observer to watch the pref. Installing
// an observer for this pref is not necessary here and may be buggy with
// regards to registering this XPIProvider twice.
if (Preferences.get("experiments.supported", false)) {
  addonTypes.push(
    new AddonManagerPrivate.AddonType("experiment",
                                      URI_EXTENSION_STRINGS,
                                      STRING_TYPE_NAME,
                                      AddonManager.VIEW_TYPE_LIST, 11000,
                                      AddonManager.TYPE_UI_HIDE_EMPTY | AddonManager.TYPE_SUPPORTS_UNDO_RESTARTLESS_UNINSTALL));
}

AddonManagerPrivate.registerProvider(XPIProvider, addonTypes);
