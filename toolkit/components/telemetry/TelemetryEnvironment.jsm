/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

this.EXPORTED_SYMBOLS = [
  "TelemetryEnvironment",
];

const {classes: Cc, interfaces: Ci, utils: Cu} = Components;
const myScope = this;

Cu.import("resource://gre/modules/XPCOMUtils.jsm", this);
Cu.import("resource://gre/modules/Log.jsm");
Cu.import("resource://gre/modules/Preferences.jsm");
Cu.import("resource://gre/modules/Services.jsm");
Cu.import("resource://gre/modules/TelemetryUtils.jsm", this);
Cu.import("resource://gre/modules/ObjectUtils.jsm");
Cu.import("resource://gre/modules/TelemetryController.jsm", this);
Cu.import("resource://gre/modules/AppConstants.jsm");

const Utils = TelemetryUtils;

XPCOMUtils.defineLazyModuleGetter(this, "AttributionCode",
                                  "resource:///modules/AttributionCode.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "ctypes",
                                  "resource://gre/modules/ctypes.jsm");
Cu.import("resource://gre/modules/AddonManager.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "LightweightThemeManager",
                                  "resource://gre/modules/LightweightThemeManager.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "ProfileAge",
                                  "resource://gre/modules/ProfileAge.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "UpdateUtils",
                                  "resource://gre/modules/UpdateUtils.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "WindowsRegistry",
                                  "resource://gre/modules/WindowsRegistry.jsm");

// The maximum length of a string (e.g. description) in the addons section.
const MAX_ADDON_STRING_LENGTH = 100;
// The maximum length of a string value in the settings.attribution object.
const MAX_ATTRIBUTION_STRING_LENGTH = 100;
// The maximum lengths for the experiment id and branch in the experiments section.
const MAX_EXPERIMENT_ID_LENGTH = 100;
const MAX_EXPERIMENT_BRANCH_LENGTH = 100;
const MAX_EXPERIMENT_TYPE_LENGTH = 20;

/**
 * This is a policy object used to override behavior for testing.
 */
var Policy = {
  now: () => new Date(),
};

var gGlobalEnvironment;
function getGlobal() {
  if (!gGlobalEnvironment) {
    gGlobalEnvironment = new EnvironmentCache();
  }
  return gGlobalEnvironment;
}

this.TelemetryEnvironment = {
  get currentEnvironment() {
    return getGlobal().currentEnvironment;
  },

  onInitialized() {
    return getGlobal().onInitialized();
  },

  delayedInit() {
    return getGlobal().delayedInit();
  },

  registerChangeListener(name, listener) {
    return getGlobal().registerChangeListener(name, listener);
  },

  unregisterChangeListener(name) {
    return getGlobal().unregisterChangeListener(name);
  },

  /**
   * Add an experiment annotation to the environment.
   * If an annotation with the same id already exists, it will be overwritten.
   * This triggers a new subsession, subject to throttling.
   *
   * @param {String} id The id of the active experiment.
   * @param {String} branch The experiment branch.
   * @param {Object} [options] Optional object with options.
   * @param {String} [options.type=false] The specific experiment type.
   */
  setExperimentActive(id, branch, options = {}) {
    return getGlobal().setExperimentActive(id, branch, options);
  },

  /**
   * Remove an experiment annotation from the environment.
   * If the annotation exists, a new subsession will triggered.
   *
   * @param {String} id The id of the active experiment.
   */
  setExperimentInactive(id) {
    return getGlobal().setExperimentInactive(id);
  },

  /**
   * Returns an object containing the data for the active experiments.
   *
   * The returned object is of the format:
   *
   * {
   *   "<experiment id>": { branch: "<branch>" },
   *   // …
   * }
   */
  getActiveExperiments() {
    return getGlobal().getActiveExperiments();
  },

  shutdown() {
    return getGlobal().shutdown();
  },

  // Policy to use when saving preferences. Exported for using them in tests.
  RECORD_PREF_STATE: 1, // Don't record the preference value
  RECORD_PREF_VALUE: 2, // We only record user-set prefs.
  RECORD_DEFAULTPREF_VALUE: 3, // We only record default pref if set

  // Testing method
  testWatchPreferences(prefMap) {
    return getGlobal()._watchPreferences(prefMap);
  },

  /**
   * Intended for use in tests only.
   *
   * In multiple tests we need a way to shut and re-start telemetry together
   * with TelemetryEnvironment. This is problematic due to the fact that
   * TelemetryEnvironment is a singleton. We, therefore, need this helper
   * method to be able to re-set TelemetryEnvironment.
   */
  testReset() {
    return getGlobal().reset();
  },

  /**
   * Intended for use in tests only.
   */
  testCleanRestart() {
    getGlobal().shutdown();
    gGlobalEnvironment = null;
    return getGlobal();
  },
};

const RECORD_PREF_STATE = TelemetryEnvironment.RECORD_PREF_STATE;
const RECORD_PREF_VALUE = TelemetryEnvironment.RECORD_PREF_VALUE;
const RECORD_DEFAULTPREF_VALUE = TelemetryEnvironment.RECORD_DEFAULTPREF_VALUE;
const DEFAULT_ENVIRONMENT_PREFS = new Map([
  ["app.feedback.baseURL", {what: RECORD_PREF_VALUE}],
  ["app.support.baseURL", {what: RECORD_PREF_VALUE}],
  ["accessibility.browsewithcaret", {what: RECORD_PREF_VALUE}],
  ["accessibility.force_disabled", {what:  RECORD_PREF_VALUE}],
  ["app.update.auto", {what: RECORD_PREF_VALUE}],
  ["app.update.enabled", {what: RECORD_PREF_VALUE}],
  ["app.update.interval", {what: RECORD_PREF_VALUE}],
  ["app.update.service.enabled", {what: RECORD_PREF_VALUE}],
  ["app.update.silent", {what: RECORD_PREF_VALUE}],
  ["app.update.url", {what: RECORD_PREF_VALUE}],
  ["browser.cache.disk.enable", {what: RECORD_PREF_VALUE}],
  ["browser.cache.disk.capacity", {what: RECORD_PREF_VALUE}],
  ["browser.cache.memory.enable", {what: RECORD_PREF_VALUE}],
  ["browser.cache.offline.enable", {what: RECORD_PREF_VALUE}],
  ["browser.formfill.enable", {what: RECORD_PREF_VALUE}],
  ["browser.newtabpage.enabled", {what: RECORD_PREF_VALUE}],
  ["browser.newtabpage.enhanced", {what: RECORD_PREF_VALUE}],
  ["browser.shell.checkDefaultBrowser", {what: RECORD_PREF_VALUE}],
  ["browser.search.ignoredJAREngines", {what: RECORD_DEFAULTPREF_VALUE}],
  ["browser.search.suggest.enabled", {what: RECORD_PREF_VALUE}],
  ["browser.startup.homepage", {what: RECORD_PREF_STATE}],
  ["browser.startup.page", {what: RECORD_PREF_VALUE}],
  ["toolkit.cosmeticAnimations.enabled", {what: RECORD_PREF_VALUE}],
  ["browser.urlbar.suggest.searches", {what: RECORD_PREF_VALUE}],
  ["browser.urlbar.userMadeSearchSuggestionsChoice", {what: RECORD_PREF_VALUE}],
  ["devtools.chrome.enabled", {what: RECORD_PREF_VALUE}],
  ["devtools.debugger.enabled", {what: RECORD_PREF_VALUE}],
  ["devtools.debugger.remote-enabled", {what: RECORD_PREF_VALUE}],
  ["dom.ipc.plugins.asyncInit.enabled", {what: RECORD_PREF_VALUE}],
  ["dom.ipc.plugins.enabled", {what: RECORD_PREF_VALUE}],
  ["dom.ipc.processCount", {what: RECORD_PREF_VALUE}],
  ["dom.max_script_run_time", {what: RECORD_PREF_VALUE}],
  ["experiments.manifest.uri", {what: RECORD_PREF_VALUE}],
  ["extensions.allow-non-mpc-extensions", {what: RECORD_PREF_VALUE}],
  ["extensions.autoDisableScopes", {what: RECORD_PREF_VALUE}],
  ["extensions.enabledScopes", {what: RECORD_PREF_VALUE}],
  ["extensions.blocklist.enabled", {what: RECORD_PREF_VALUE}],
  ["extensions.blocklist.url", {what: RECORD_PREF_VALUE}],
  ["extensions.strictCompatibility", {what: RECORD_PREF_VALUE}],
  ["extensions.update.enabled", {what: RECORD_PREF_VALUE}],
  ["extensions.update.url", {what: RECORD_PREF_VALUE}],
  ["extensions.update.background.url", {what: RECORD_PREF_VALUE}],
  ["extensions.screenshots.disabled", {what: RECORD_PREF_VALUE}],
  ["extensions.screenshots.system-disabled", {what: RECORD_PREF_VALUE}],
  ["general.smoothScroll", {what: RECORD_PREF_VALUE}],
  ["gfx.direct2d.disabled", {what: RECORD_PREF_VALUE}],
  ["gfx.direct2d.force-enabled", {what: RECORD_PREF_VALUE}],
  ["gfx.direct2d.use1_1", {what: RECORD_PREF_VALUE}],
  ["layers.acceleration.disabled", {what: RECORD_PREF_VALUE}],
  ["layers.acceleration.force-enabled", {what: RECORD_PREF_VALUE}],
  ["layers.async-pan-zoom.enabled", {what: RECORD_PREF_VALUE}],
  ["layers.async-video-oop.enabled", {what: RECORD_PREF_VALUE}],
  ["layers.async-video.enabled", {what: RECORD_PREF_VALUE}],
  ["layers.componentalpha.enabled", {what: RECORD_PREF_VALUE}],
  ["layers.d3d11.disable-warp", {what: RECORD_PREF_VALUE}],
  ["layers.d3d11.force-warp", {what: RECORD_PREF_VALUE}],
  ["layers.offmainthreadcomposition.force-disabled", {what: RECORD_PREF_VALUE}],
  ["layers.prefer-d3d9", {what: RECORD_PREF_VALUE}],
  ["layers.prefer-opengl", {what: RECORD_PREF_VALUE}],
  ["layout.css.devPixelsPerPx", {what: RECORD_PREF_VALUE}],
  ["network.proxy.autoconfig_url", {what: RECORD_PREF_STATE}],
  ["network.proxy.http", {what: RECORD_PREF_STATE}],
  ["network.proxy.ssl", {what: RECORD_PREF_STATE}],
  ["pdfjs.disabled", {what: RECORD_PREF_VALUE}],
  ["places.history.enabled", {what: RECORD_PREF_VALUE}],
  ["plugins.remember_infobar_dismissal", {what: RECORD_PREF_VALUE}],
  ["plugins.show_infobar", {what: RECORD_PREF_VALUE}],
  ["privacy.trackingprotection.enabled", {what: RECORD_PREF_VALUE}],
  ["privacy.donottrackheader.enabled", {what: RECORD_PREF_VALUE}],
  ["security.mixed_content.block_active_content", {what: RECORD_PREF_VALUE}],
  ["security.mixed_content.block_display_content", {what: RECORD_PREF_VALUE}],
  ["xpinstall.signatures.required", {what: RECORD_PREF_VALUE}],
]);

const LOGGER_NAME = "Toolkit.Telemetry";

const PREF_BLOCKLIST_ENABLED = "extensions.blocklist.enabled";
const PREF_DISTRIBUTION_ID = "distribution.id";
const PREF_DISTRIBUTION_VERSION = "distribution.version";
const PREF_DISTRIBUTOR = "app.distributor";
const PREF_DISTRIBUTOR_CHANNEL = "app.distributor.channel";
const PREF_HOTFIX_LASTVERSION = "extensions.hotfix.lastVersion";
const PREF_APP_PARTNER_BRANCH = "app.partner.";
const PREF_PARTNER_ID = "mozilla.partner.id";
const PREF_UPDATE_ENABLED = "app.update.enabled";
const PREF_UPDATE_AUTODOWNLOAD = "app.update.auto";
const PREF_SEARCH_COHORT = "browser.search.cohort";
const PREF_E10S_COHORT = "e10s.rollout.cohort";

const COMPOSITOR_CREATED_TOPIC = "compositor:created";
const COMPOSITOR_PROCESS_ABORTED_TOPIC = "compositor:process-aborted";
const DISTRIBUTION_CUSTOMIZATION_COMPLETE_TOPIC = "distribution-customization-complete";
const EXPERIMENTS_CHANGED_TOPIC = "experiments-changed";
const GFX_FEATURES_READY_TOPIC = "gfx-features-ready";
const SEARCH_ENGINE_MODIFIED_TOPIC = "browser-search-engine-modified";
const SEARCH_SERVICE_TOPIC = "browser-search-service";
const SESSIONSTORE_WINDOWS_RESTORED_TOPIC = "sessionstore-windows-restored";

/**
 * Enforces the parameter to a boolean value.
 * @param aValue The input value.
 * @return {Boolean|Object} If aValue is a boolean or a number, returns its truthfulness
 *         value. Otherwise, return null.
 */
function enforceBoolean(aValue) {
  if (typeof(aValue) !== "number" && typeof(aValue) !== "boolean") {
    return null;
  }
  return (new Boolean(aValue)).valueOf();
}

/**
 * Get the current browser locale.
 * @return a string with the locale or null on failure.
 */
function getBrowserLocale() {
  try {
    return Services.locale.getAppLocaleAsLangTag();
  } catch (e) {
    return null;
  }
}

/**
 * Get the current OS locale.
 * @return a string with the OS locale or null on failure.
 */
function getSystemLocale() {
  try {
    return Cc["@mozilla.org/intl/ospreferences;1"].
             getService(Ci.mozIOSPreferences).
             systemLocale;
  } catch (e) {
    return null;
  }
}

/**
 * Safely get a sysinfo property and return its value. If the property is not
 * available, return aDefault.
 *
 * @param aPropertyName the property name to get.
 * @param aDefault the value to return if aPropertyName is not available.
 * @return The property value, if available, or aDefault.
 */
function getSysinfoProperty(aPropertyName, aDefault) {
  try {
    // |getProperty| may throw if |aPropertyName| does not exist.
    return Services.sysinfo.getProperty(aPropertyName);
  } catch (e) {}

  return aDefault;
}

/**
 * Safely get a gfxInfo field and return its value. If the field is not available, return
 * aDefault.
 *
 * @param aPropertyName the property name to get.
 * @param aDefault the value to return if aPropertyName is not available.
 * @return The property value, if available, or aDefault.
 */
function getGfxField(aPropertyName, aDefault) {
  let gfxInfo = Cc["@mozilla.org/gfx/info;1"].getService(Ci.nsIGfxInfo);

  try {
    // Accessing the field may throw if |aPropertyName| does not exist.
    let gfxProp = gfxInfo[aPropertyName];
    if (gfxProp !== undefined && gfxProp !== "") {
      return gfxProp;
    }
  } catch (e) {}

  return aDefault;
}

/**
 * Returns a substring of the input string.
 *
 * @param {String} aString The input string.
 * @param {Integer} aMaxLength The maximum length of the returned substring. If this is
 *        greater than the length of the input string, we return the whole input string.
 * @return {String} The substring or null if the input string is null.
 */
function limitStringToLength(aString, aMaxLength) {
  if (typeof(aString) !== "string") {
    return null;
  }
  return aString.substring(0, aMaxLength);
}

/**
 * Force a value to be a string.
 * Only if the value is null, null is returned instead.
 */
function forceToStringOrNull(aValue) {
  if (aValue === null) {
    return null;
  }

  return String(aValue);
}

/**
 * Get the information about a graphic adapter.
 *
 * @param aSuffix A suffix to add to the properties names.
 * @return An object containing the adapter properties.
 */
function getGfxAdapter(aSuffix = "") {
  // Note that gfxInfo, and so getGfxField, might return "Unknown" for the RAM on failures,
  // not null.
  let memoryMB = parseInt(getGfxField("adapterRAM" + aSuffix, null), 10);
  if (Number.isNaN(memoryMB)) {
    memoryMB = null;
  }

  return {
    description: getGfxField("adapterDescription" + aSuffix, null),
    vendorID: getGfxField("adapterVendorID" + aSuffix, null),
    deviceID: getGfxField("adapterDeviceID" + aSuffix, null),
    subsysID: getGfxField("adapterSubsysID" + aSuffix, null),
    RAM: memoryMB,
    driver: getGfxField("adapterDriver" + aSuffix, null),
    driverVersion: getGfxField("adapterDriverVersion" + aSuffix, null),
    driverDate: getGfxField("adapterDriverDate" + aSuffix, null),
  };
}

/**
 * Gets the service pack and build information on Windows platforms. The initial version
 * was copied from nsUpdateService.js.
 *
 * @return An object containing the service pack major and minor versions, along with the
 *         build number.
 */
function getWindowsVersionInfo() {
  const UNKNOWN_VERSION_INFO = {servicePackMajor: null, servicePackMinor: null, buildNumber: null};

  if (AppConstants.platform !== "win") {
    return UNKNOWN_VERSION_INFO;
  }

  const BYTE = ctypes.uint8_t;
  const WORD = ctypes.uint16_t;
  const DWORD = ctypes.uint32_t;
  const WCHAR = ctypes.char16_t;
  const BOOL = ctypes.int;

  // This structure is described at:
  // http://msdn.microsoft.com/en-us/library/ms724833%28v=vs.85%29.aspx
  const SZCSDVERSIONLENGTH = 128;
  const OSVERSIONINFOEXW = new ctypes.StructType("OSVERSIONINFOEXW",
      [
      {dwOSVersionInfoSize: DWORD},
      {dwMajorVersion: DWORD},
      {dwMinorVersion: DWORD},
      {dwBuildNumber: DWORD},
      {dwPlatformId: DWORD},
      {szCSDVersion: ctypes.ArrayType(WCHAR, SZCSDVERSIONLENGTH)},
      {wServicePackMajor: WORD},
      {wServicePackMinor: WORD},
      {wSuiteMask: WORD},
      {wProductType: BYTE},
      {wReserved: BYTE}
      ]);

  let kernel32 = ctypes.open("kernel32");
  try {
    let GetVersionEx = kernel32.declare("GetVersionExW",
                                        ctypes.winapi_abi,
                                        BOOL,
                                        OSVERSIONINFOEXW.ptr);
    let winVer = OSVERSIONINFOEXW();
    winVer.dwOSVersionInfoSize = OSVERSIONINFOEXW.size;

    if (0 === GetVersionEx(winVer.address())) {
      throw ("Failure in GetVersionEx (returned 0)");
    }

    return {
      servicePackMajor: winVer.wServicePackMajor,
      servicePackMinor: winVer.wServicePackMinor,
      buildNumber: winVer.dwBuildNumber,
    };
  } catch (e) {
    return UNKNOWN_VERSION_INFO;
  } finally {
    kernel32.close();
  }
}

/**
 * Encapsulates the asynchronous magic interfacing with the addon manager. The builder
 * is owned by a parent environment object and is an addon listener.
 */
function EnvironmentAddonBuilder(environment) {
  this._environment = environment;

  // The pending task blocks addon manager shutdown. It can either be the initial load
  // or a change load.
  this._pendingTask = null;

  // Set to true once initial load is complete and we're watching for changes.
  this._loaded = false;
}
EnvironmentAddonBuilder.prototype = {
  /**
   * Get the initial set of addons.
   * @returns Promise<void> when the initial load is complete.
   */
  init() {
    // Some tests don't initialize the addon manager. This accounts for the
    // unfortunate reality of life.
    try {
      AddonManager.shutdown.addBlocker("EnvironmentAddonBuilder",
        () => this._shutdownBlocker());
    } catch (err) {
      return Promise.reject(err);
    }

    this._pendingTask = this._updateAddons().then(
      () => { this._pendingTask = null; },
      (err) => {
        this._environment._log.error("init - Exception in _updateAddons", err);
        this._pendingTask = null;
      }
    );

    return this._pendingTask;
  },

  /**
   * Register an addon listener and watch for changes.
   */
  watchForChanges() {
    this._loaded = true;
    AddonManager.addAddonListener(this);
    Services.obs.addObserver(this, EXPERIMENTS_CHANGED_TOPIC);
  },

  // AddonListener
  onEnabled() {
    this._onAddonChange();
  },
  onDisabled() {
    this._onAddonChange();
  },
  onInstalled() {
    this._onAddonChange();
  },
  onUninstalling() {
    this._onAddonChange();
  },

  _onAddonChange() {
    this._environment._log.trace("_onAddonChange");
    this._checkForChanges("addons-changed");
  },

  // nsIObserver
  observe(aSubject, aTopic, aData) {
    this._environment._log.trace("observe - Topic " + aTopic);
    this._checkForChanges("experiment-changed");
  },

  _checkForChanges(changeReason) {
    if (this._pendingTask) {
      this._environment._log.trace("_checkForChanges - task already pending, dropping change with reason " + changeReason);
      return;
    }

    this._pendingTask = this._updateAddons().then(
      (result) => {
        this._pendingTask = null;
        if (result.changed) {
          this._environment._onEnvironmentChange(changeReason, result.oldEnvironment);
        }
      },
      (err) => {
        this._pendingTask = null;
        this._environment._log.error("_checkForChanges: Error collecting addons", err);
      });
  },

  _shutdownBlocker() {
    if (this._loaded) {
      AddonManager.removeAddonListener(this);
      Services.obs.removeObserver(this, EXPERIMENTS_CHANGED_TOPIC);
    }
    return this._pendingTask;
  },

  /**
   * Collect the addon data for the environment.
   *
   * This should only be called from _pendingTask; otherwise we risk
   * running this during addon manager shutdown.
   *
   * @returns Promise<Object> This returns a Promise resolved with a status object with the following members:
   *   changed - Whether the environment changed.
   *   oldEnvironment - Only set if a change occured, contains the environment data before the change.
   */
  async _updateAddons() {
    this._environment._log.trace("_updateAddons");
    let personaId = null;
    let theme = LightweightThemeManager.currentTheme;
    if (theme) {
      personaId = theme.id;
    }

    let addons = {
      activeAddons: await this._getActiveAddons(),
      theme: await this._getActiveTheme(),
      activePlugins: this._getActivePlugins(),
      activeGMPlugins: await this._getActiveGMPlugins(),
      activeExperiment: this._getActiveExperiment(),
      persona: personaId,
    };

    let result = {
      changed: !this._environment._currentEnvironment.addons ||
               !ObjectUtils.deepEqual(addons, this._environment._currentEnvironment.addons),
    };

    if (result.changed) {
      this._environment._log.trace("_updateAddons: addons differ");
      result.oldEnvironment = Cu.cloneInto(this._environment._currentEnvironment, myScope);
      this._environment._currentEnvironment.addons = addons;
    }

    return result;
  },

  /**
   * Get the addon data in object form.
   * @return Promise<object> containing the addon data.
   */
  async _getActiveAddons() {
    // Request addons, asynchronously.
    let allAddons = await AddonManager.getAddonsByTypes(["extension", "service"]);

    let activeAddons = {};
    for (let addon of allAddons) {
      // Skip addons which are not active.
      if (!addon.isActive) {
        continue;
      }

      // Weird addon data in the wild can lead to exceptions while collecting
      // the data.
      try {
        // Make sure to have valid dates.
        let installDate = new Date(Math.max(0, addon.installDate));
        let updateDate = new Date(Math.max(0, addon.updateDate));

        activeAddons[addon.id] = {
          blocklisted: (addon.blocklistState !== Ci.nsIBlocklistService.STATE_NOT_BLOCKED),
          description: limitStringToLength(addon.description, MAX_ADDON_STRING_LENGTH),
          name: limitStringToLength(addon.name, MAX_ADDON_STRING_LENGTH),
          userDisabled: enforceBoolean(addon.userDisabled),
          appDisabled: addon.appDisabled,
          version: limitStringToLength(addon.version, MAX_ADDON_STRING_LENGTH),
          scope: addon.scope,
          type: addon.type,
          foreignInstall: enforceBoolean(addon.foreignInstall),
          hasBinaryComponents: addon.hasBinaryComponents,
          installDay: Utils.millisecondsToDays(installDate.getTime()),
          updateDay: Utils.millisecondsToDays(updateDate.getTime()),
          signedState: addon.signedState,
          isSystem: addon.isSystem,
          isWebExtension: addon.isWebExtension,
          multiprocessCompatible: Boolean(addon.multiprocessCompatible),
        };

        if (addon.signedState !== undefined)
          activeAddons[addon.id].signedState = addon.signedState;

      } catch (ex) {
        this._environment._log.error("_getActiveAddons - An addon was discarded due to an error", ex);
        continue;
      }
    }

    return activeAddons;
  },

  /**
   * Get the currently active theme data in object form.
   * @return Promise<object> containing the active theme data.
   */
  async _getActiveTheme() {
    // Request themes, asynchronously.
    let themes = await AddonManager.getAddonsByTypes(["theme"]);

    let activeTheme = {};
    // We only store information about the active theme.
    let theme = themes.find(theme => theme.isActive);
    if (theme) {
      // Make sure to have valid dates.
      let installDate = new Date(Math.max(0, theme.installDate));
      let updateDate = new Date(Math.max(0, theme.updateDate));

      activeTheme = {
        id: theme.id,
        blocklisted: (theme.blocklistState !== Ci.nsIBlocklistService.STATE_NOT_BLOCKED),
        description: limitStringToLength(theme.description, MAX_ADDON_STRING_LENGTH),
        name: limitStringToLength(theme.name, MAX_ADDON_STRING_LENGTH),
        userDisabled: enforceBoolean(theme.userDisabled),
        appDisabled: theme.appDisabled,
        version: limitStringToLength(theme.version, MAX_ADDON_STRING_LENGTH),
        scope: theme.scope,
        foreignInstall: enforceBoolean(theme.foreignInstall),
        hasBinaryComponents: theme.hasBinaryComponents,
        installDay: Utils.millisecondsToDays(installDate.getTime()),
        updateDay: Utils.millisecondsToDays(updateDate.getTime()),
      };
    }

    return activeTheme;
  },

  /**
   * Get the plugins data in object form.
   * @return Object containing the plugins data.
   */
  _getActivePlugins() {
    let pluginTags =
      Cc["@mozilla.org/plugin/host;1"].getService(Ci.nsIPluginHost).getPluginTags({});

    let activePlugins = [];
    for (let tag of pluginTags) {
      // Skip plugins which are not active.
      if (tag.disabled) {
        continue;
      }

      try {
        // Make sure to have a valid date.
        let updateDate = new Date(Math.max(0, tag.lastModifiedTime));

        activePlugins.push({
          name: limitStringToLength(tag.name, MAX_ADDON_STRING_LENGTH),
          version: limitStringToLength(tag.version, MAX_ADDON_STRING_LENGTH),
          description: limitStringToLength(tag.description, MAX_ADDON_STRING_LENGTH),
          blocklisted: tag.blocklisted,
          disabled: tag.disabled,
          clicktoplay: tag.clicktoplay,
          mimeTypes: tag.getMimeTypes({}),
          updateDay: Utils.millisecondsToDays(updateDate.getTime()),
        });
      } catch (ex) {
        this._environment._log.error("_getActivePlugins - A plugin was discarded due to an error", ex);
        continue;
      }
    }

    return activePlugins;
  },

  /**
   * Get the GMPlugins data in object form.
   * @return Object containing the GMPlugins data.
   *
   * This should only be called from _pendingTask; otherwise we risk
   * running this during addon manager shutdown.
   */
  async _getActiveGMPlugins() {
    // Request plugins, asynchronously.
    let allPlugins = await AddonManager.getAddonsByTypes(["plugin"]);

    let activeGMPlugins = {};
    for (let plugin of allPlugins) {
      // Only get info for active GMplugins.
      if (!plugin.isGMPlugin || !plugin.isActive) {
        continue;
      }

      try {
        activeGMPlugins[plugin.id] = {
          version: plugin.version,
          userDisabled: enforceBoolean(plugin.userDisabled),
          applyBackgroundUpdates: plugin.applyBackgroundUpdates,
        };
      } catch (ex) {
        this._environment._log.error("_getActiveGMPlugins - A GMPlugin was discarded due to an error", ex);
        continue;
      }
    }

    return activeGMPlugins;
  },

  /**
   * Get the active experiment data in object form.
   * @return Object containing the active experiment data.
   */
  _getActiveExperiment() {
    let experimentInfo = {};
    try {
      let scope = {};
      Cu.import("resource:///modules/experiments/Experiments.jsm", scope);
      let experiments = scope.Experiments.instance();
      let activeExperiment = experiments.getActiveExperimentID();
      if (activeExperiment) {
        experimentInfo.id = activeExperiment;
        experimentInfo.branch = experiments.getActiveExperimentBranch();
      }
    } catch (e) {
      // If this is not Firefox, the import will fail.
    }

    return experimentInfo;
  },
};

function EnvironmentCache() {
  this._log = Log.repository.getLoggerWithMessagePrefix(
    LOGGER_NAME, "TelemetryEnvironment::");
  this._log.trace("constructor");

  this._shutdown = false;
  this._delayedInitFinished = false;
  // Don't allow querying the search service too early to prevent
  // impacting the startup performance.
  this._canQuerySearch = false;

  // A map of listeners that will be called on environment changes.
  this._changeListeners = new Map();

  // A map of watched preferences which trigger an Environment change when
  // modified. Every entry contains a recording policy (RECORD_PREF_*).
  this._watchedPrefs = DEFAULT_ENVIRONMENT_PREFS;

  this._currentEnvironment = {
    build: this._getBuild(),
    partner: this._getPartner(),
    system: this._getSystem(),
  };

  this._updateSettings();
  this._addObservers();

  // Build the remaining asynchronous parts of the environment. Don't register change listeners
  // until the initial environment has been built.

  let p = [];
  this._addonBuilder = new EnvironmentAddonBuilder(this);
  p = [ this._addonBuilder.init() ];

  this._currentEnvironment.profile = {};
  p.push(this._updateProfile());
  if (AppConstants.MOZ_BUILD_APP == "browser") {
    p.push(this._updateAttribution());
  }

  let setup = () => {
    this._initTask = null;
    this._startWatchingPrefs();
    this._addonBuilder.watchForChanges();
    this._updateGraphicsFeatures();
    return this.currentEnvironment;
  };

  this._initTask = Promise.all(p)
    .then(
      () => setup(),
      (err) => {
        // log errors but eat them for consumers
        this._log.error("EnvironmentCache - error while initializing", err);
        return setup();
      });
}
EnvironmentCache.prototype = {
  /**
   * The current environment data. The returned data is cloned to avoid
   * unexpected sharing or mutation.
   * @returns object
   */
  get currentEnvironment() {
    return Cu.cloneInto(this._currentEnvironment, myScope);
  },

  /**
   * Wait for the current enviroment to be fully initialized.
   * @returns Promise<object>
   */
  onInitialized() {
    if (this._initTask) {
      return this._initTask;
    }
    return Promise.resolve(this.currentEnvironment);
  },

  /**
   * This gets called when the delayed init completes.
   */
  delayedInit() {
    this._delayedInitFinished = true;
  },

  /**
   * Register a listener for environment changes.
   * @param name The name of the listener. If a new listener is registered
   *             with the same name, the old listener will be replaced.
   * @param listener function(reason, oldEnvironment) - Will receive a reason for
                     the change and the environment data before the change.
   */
  registerChangeListener(name, listener) {
    this._log.trace("registerChangeListener for " + name);
    if (this._shutdown) {
      this._log.warn("registerChangeListener - already shutdown");
      return;
    }
    this._changeListeners.set(name, listener);
  },

  /**
   * Unregister from listening to environment changes.
   * It's fine to call this on an unitialized TelemetryEnvironment.
   * @param name The name of the listener to remove.
   */
  unregisterChangeListener(name) {
    this._log.trace("unregisterChangeListener for " + name);
    if (this._shutdown) {
      this._log.warn("registerChangeListener - already shutdown");
      return;
    }
    this._changeListeners.delete(name);
  },

  setExperimentActive(id, branch, options) {
    this._log.trace("setExperimentActive");
    // Make sure both the id and the branch have sane lengths.
    const saneId = limitStringToLength(id, MAX_EXPERIMENT_ID_LENGTH);
    const saneBranch = limitStringToLength(branch, MAX_EXPERIMENT_BRANCH_LENGTH);
    if (!saneId || !saneBranch) {
      this._log.error("setExperimentActive - the provided arguments are not strings.");
      return;
    }

    // Warn the user about any content truncation.
    if (saneId.length != id.length || saneBranch.length != branch.length) {
      this._log.warn("setExperimentActive - the experiment id or branch were truncated.");
    }

    // Truncate the experiment type if present.
    if (options.hasOwnProperty("type")) {
      let type = limitStringToLength(options.type, MAX_EXPERIMENT_TYPE_LENGTH);
      if (type.length != options.type.length) {
        options.type = type;
        this._log.warn("setExperimentActive - the experiment type was truncated.");
      }
    }

    let oldEnvironment = Cu.cloneInto(this._currentEnvironment, myScope);
    // Add the experiment annotation.
    let experiments = this._currentEnvironment.experiments || {};
    experiments[saneId] = { "branch": saneBranch };
    if (options.hasOwnProperty("type")) {
      experiments[saneId].type = options.type;
    }
    this._currentEnvironment.experiments = experiments;
    // Notify of the change.
    this._onEnvironmentChange("experiment-annotation-changed", oldEnvironment);
  },

  setExperimentInactive(id) {
    this._log.trace("setExperimentInactive");
    let experiments = this._currentEnvironment.experiments || {};
    if (id in experiments) {
      // Only attempt to notify if a previous annotation was found and removed.
      let oldEnvironment = Cu.cloneInto(this._currentEnvironment, myScope);
      // Remove the experiment annotation.
      delete this._currentEnvironment.experiments[id];
      // Notify of the change.
      this._onEnvironmentChange("experiment-annotation-changed", oldEnvironment);
    }
  },

  getActiveExperiments() {
    return Cu.cloneInto(this._currentEnvironment.experiments || {}, myScope);
  },

  shutdown() {
    this._log.trace("shutdown");
    this._shutdown = true;
  },

  /**
   * Only used in tests, set the preferences to watch.
   * @param aPreferences A map of preferences names and their recording policy.
   */
  _watchPreferences(aPreferences) {
    this._stopWatchingPrefs();
    this._watchedPrefs = aPreferences;
    this._updateSettings();
    this._startWatchingPrefs();
  },

  /**
   * Get an object containing the values for the watched preferences. Depending on the
   * policy, the value for a preference or whether it was changed by user is reported.
   *
   * @return An object containing the preferences values.
   */
  _getPrefData() {
    let prefData = {};
    for (let [pref, policy] of this._watchedPrefs.entries()) {
      if (policy.what == TelemetryEnvironment.RECORD_DEFAULTPREF_VALUE) {
        // For default prefs, make sure they exist
        if (!Preferences.has(pref)) {
          continue;
        }
      } else if (!Preferences.isSet(pref)) {
        // For user prefs, make sure they are set
        continue;
      }

      // Check the policy for the preference and decide if we need to store its value
      // or whether it changed from the default value.
      let prefValue = undefined;
      if (policy.what == TelemetryEnvironment.RECORD_PREF_STATE) {
        prefValue = "<user-set>";
      } else {
        prefValue = Preferences.get(pref, null);
      }
      prefData[pref] = prefValue;
    }
    return prefData;
  },

  /**
   * Start watching the preferences.
   */
  _startWatchingPrefs() {
    this._log.trace("_startWatchingPrefs - " + this._watchedPrefs);

    for (let [pref, options] of this._watchedPrefs) {
      if (!("requiresRestart" in options) || !options.requiresRestart) {
        Preferences.observe(pref, this._onPrefChanged, this);
      }
    }
  },

  _onPrefChanged() {
    this._log.trace("_onPrefChanged");
    let oldEnvironment = Cu.cloneInto(this._currentEnvironment, myScope);
    this._updateSettings();
    this._onEnvironmentChange("pref-changed", oldEnvironment);
  },

  /**
   * Do not receive any more change notifications for the preferences.
   */
  _stopWatchingPrefs() {
    this._log.trace("_stopWatchingPrefs");

    for (let [pref, options] of this._watchedPrefs) {
      if (!("requiresRestart" in options) || !options.requiresRestart) {
        Preferences.ignore(pref, this._onPrefChanged, this);
      }
    }
  },

  _addObservers() {
    // Watch the search engine change and service topics.
    Services.obs.addObserver(this, SESSIONSTORE_WINDOWS_RESTORED_TOPIC);
    Services.obs.addObserver(this, COMPOSITOR_CREATED_TOPIC);
    Services.obs.addObserver(this, COMPOSITOR_PROCESS_ABORTED_TOPIC);
    Services.obs.addObserver(this, DISTRIBUTION_CUSTOMIZATION_COMPLETE_TOPIC);
    Services.obs.addObserver(this, GFX_FEATURES_READY_TOPIC);
    Services.obs.addObserver(this, SEARCH_ENGINE_MODIFIED_TOPIC);
    Services.obs.addObserver(this, SEARCH_SERVICE_TOPIC);
  },

  _removeObservers() {
    Services.obs.removeObserver(this, SESSIONSTORE_WINDOWS_RESTORED_TOPIC);
    Services.obs.removeObserver(this, COMPOSITOR_CREATED_TOPIC);
    Services.obs.removeObserver(this, COMPOSITOR_PROCESS_ABORTED_TOPIC);
    try {
      Services.obs.removeObserver(this, DISTRIBUTION_CUSTOMIZATION_COMPLETE_TOPIC);
    } catch (ex) {}
    Services.obs.removeObserver(this, GFX_FEATURES_READY_TOPIC);
    Services.obs.removeObserver(this, SEARCH_ENGINE_MODIFIED_TOPIC);
    Services.obs.removeObserver(this, SEARCH_SERVICE_TOPIC);
  },

  observe(aSubject, aTopic, aData) {
    this._log.trace("observe - aTopic: " + aTopic + ", aData: " + aData);
    switch (aTopic) {
      case SEARCH_ENGINE_MODIFIED_TOPIC:
        if (aData != "engine-current") {
          return;
        }
        // Record the new default search choice and send the change notification.
        this._onSearchEngineChange();
        break;
      case SEARCH_SERVICE_TOPIC:
        if (aData != "init-complete") {
          return;
        }
        // Now that the search engine init is complete, record the default search choice.
        this._canQuerySearch = true;
        this._updateSearchEngine();
        break;
      case GFX_FEATURES_READY_TOPIC:
      case COMPOSITOR_CREATED_TOPIC:
        // Full graphics information is not available until we have created at
        // least one off-main-thread-composited window. Thus we wait for the
        // first compositor to be created and then query nsIGfxInfo again.
        this._updateGraphicsFeatures();
        break;
      case COMPOSITOR_PROCESS_ABORTED_TOPIC:
        // Our compositor process has been killed for whatever reason, so refresh
        // our reported graphics features and trigger an environment change.
        this._onCompositorProcessAborted();
        break;
      case DISTRIBUTION_CUSTOMIZATION_COMPLETE_TOPIC:
        // Distribution customizations are applied after final-ui-startup. query
        // partner prefs again when they are ready.
        this._updatePartner();
        Services.obs.removeObserver(this, aTopic);
        break;
      case SESSIONSTORE_WINDOWS_RESTORED_TOPIC:
        // Make sure to initialize the search service once we've done restoring
        // the windows, so that we don't risk loosing search data.
        Services.search.init();
        break;
    }
  },

  /**
   * Get the default search engine.
   * @return {String} Returns the search engine identifier, "NONE" if no default search
   *         engine is defined or "UNDEFINED" if no engine identifier or name can be found.
   */
  _getDefaultSearchEngine() {
    let engine;
    try {
      engine = Services.search.defaultEngine;
    } catch (e) {}

    let name;
    if (!engine) {
      name = "NONE";
    } else if (engine.identifier) {
      name = engine.identifier;
    } else if (engine.name) {
      name = "other-" + engine.name;
    } else {
      name = "UNDEFINED";
    }

    return name;
  },

  /**
   * Update the default search engine value.
   */
  _updateSearchEngine() {
    if (!this._canQuerySearch) {
      this._log.trace("_updateSearchEngine - ignoring early call");
      return;
    }

    if (!Services.search) {
      // Just ignore cases where the search service is not implemented.
      return;
    }

    this._log.trace("_updateSearchEngine - isInitialized: " + Services.search.isInitialized);
    if (!Services.search.isInitialized) {
      return;
    }

    // Make sure we have a settings section.
    this._currentEnvironment.settings = this._currentEnvironment.settings || {};
    // Update the search engine entry in the current environment.
    this._currentEnvironment.settings.defaultSearchEngine = this._getDefaultSearchEngine();
    this._currentEnvironment.settings.defaultSearchEngineData =
      Services.search.getDefaultEngineInfo();

    // Record the cohort identifier used for search defaults A/B testing.
    if (Services.prefs.prefHasUserValue(PREF_SEARCH_COHORT))
      this._currentEnvironment.settings.searchCohort = Services.prefs.getCharPref(PREF_SEARCH_COHORT);
  },

  /**
   * Update the default search engine value and trigger the environment change.
   */
  _onSearchEngineChange() {
    this._log.trace("_onSearchEngineChange");

    // Finally trigger the environment change notification.
    let oldEnvironment = Cu.cloneInto(this._currentEnvironment, myScope);
    this._updateSearchEngine();
    this._onEnvironmentChange("search-engine-changed", oldEnvironment);
  },

  /**
   * Refresh the Telemetry environment and trigger an environment change due to
   * a change in compositor process (normally this will mean we've fallen back
   * from out-of-process to in-process compositing).
   */
  _onCompositorProcessAborted() {
    this._log.trace("_onCompositorProcessAborted");

    // Trigger the environment change notification.
    let oldEnvironment = Cu.cloneInto(this._currentEnvironment, myScope);
    this._updateGraphicsFeatures();
    this._onEnvironmentChange("gfx-features-changed", oldEnvironment);
  },

  /**
   * Update the graphics features object.
   */
  _updateGraphicsFeatures() {
    let gfxData = this._currentEnvironment.system.gfx;
    try {
      let gfxInfo = Cc["@mozilla.org/gfx/info;1"].getService(Ci.nsIGfxInfo);
      gfxData.features = gfxInfo.getFeatures();
    } catch (e) {
      this._log.error("nsIGfxInfo.getFeatures() caught error", e);
    }
  },

  /**
   * Update the partner prefs.
   */
  _updatePartner() {
    this._currentEnvironment.partner = this._getPartner();
  },

  /**
   * Get the build data in object form.
   * @return Object containing the build data.
   */
  _getBuild() {
    let buildData = {
      applicationId: Services.appinfo.ID || null,
      applicationName: Services.appinfo.name || null,
      architecture: Services.sysinfo.get("arch"),
      buildId: Services.appinfo.appBuildID || null,
      version: Services.appinfo.version || null,
      vendor: Services.appinfo.vendor || null,
      platformVersion: Services.appinfo.platformVersion || null,
      xpcomAbi: Services.appinfo.XPCOMABI,
      hotfixVersion: Preferences.get(PREF_HOTFIX_LASTVERSION, null),
    };

    // Add |architecturesInBinary| only for Mac Universal builds.
    if ("@mozilla.org/xpcom/mac-utils;1" in Cc) {
      let macUtils = Cc["@mozilla.org/xpcom/mac-utils;1"].getService(Ci.nsIMacUtils);
      if (macUtils && macUtils.isUniversalBinary) {
        buildData.architecturesInBinary = macUtils.architecturesInBinary;
      }
    }

    return buildData;
  },

  /**
   * Determine if we're the default browser.
   * @returns null on error, true if we are the default browser, or false otherwise.
   */
  _isDefaultBrowser() {
    if (!("@mozilla.org/browser/shell-service;1" in Cc)) {
      this._log.info("_isDefaultBrowser - Could not obtain browser shell service");
      return null;
    }

    let shellService;
    try {
      let scope = {};
      Cu.import("resource:///modules/ShellService.jsm", scope);
      shellService = scope.ShellService;
    } catch (ex) {
      this._log.error("_isDefaultBrowser - Could not obtain shell service JSM");
    }

    if (!shellService) {
      try {
        shellService = Cc["@mozilla.org/browser/shell-service;1"]
                         .getService(Ci.nsIShellService);
      } catch (ex) {
        this._log.error("_isDefaultBrowser - Could not obtain shell service", ex);
        return null;
      }
    }

    try {
      // This uses the same set of flags used by the pref pane.
      return shellService.isDefaultBrowser(false, true) ? true : false;
    } catch (ex) {
      this._log.error("_isDefaultBrowser - Could not determine if default browser", ex);
      return null;
    }
  },

  /**
   * Update the cached settings data.
   */
  _updateSettings() {
    let updateChannel = null;
    try {
      updateChannel = UpdateUtils.getUpdateChannel(false);
    } catch (e) {}

    this._currentEnvironment.settings = {
      blocklistEnabled: Preferences.get(PREF_BLOCKLIST_ENABLED, true),
      e10sEnabled: Services.appinfo.browserTabsRemoteAutostart,
      e10sMultiProcesses: Services.appinfo.maxWebProcessCount,
      e10sCohort: Preferences.get(PREF_E10S_COHORT, "unknown"),
      telemetryEnabled: Utils.isTelemetryEnabled,
      locale: getBrowserLocale(),
      update: {
        channel: updateChannel,
        enabled: Preferences.get(PREF_UPDATE_ENABLED, true),
        autoDownload: Preferences.get(PREF_UPDATE_AUTODOWNLOAD, true),
      },
      userPrefs: this._getPrefData(),
      sandbox: this._getSandboxData(),
    };

    this._currentEnvironment.settings.addonCompatibilityCheckEnabled =
      AddonManager.checkCompatibility;

    if (AppConstants.platform !== "android") {
      this._currentEnvironment.settings.isDefaultBrowser =
        this._isDefaultBrowser();
    }

    this._updateSearchEngine();
  },

  _getSandboxData() {
    let effectiveContentProcessLevel = null;
    try {
      let sandboxSettings = Cc["@mozilla.org/sandbox/sandbox-settings;1"].
                            getService(Ci.mozISandboxSettings);
      effectiveContentProcessLevel =
        sandboxSettings.effectiveContentSandboxLevel;
    } catch (e) {}
    return {
      effectiveContentProcessLevel,
    };
  },

  /**
   * Update the cached profile data.
   * @returns Promise<> resolved when the I/O is complete.
   */
  async _updateProfile() {
    const logger = Log.repository.getLoggerWithMessagePrefix(LOGGER_NAME, "ProfileAge - ");
    let profileAccessor = new ProfileAge(null, logger);

    let creationDate = await profileAccessor.created;
    let resetDate = await profileAccessor.reset;

    this._currentEnvironment.profile.creationDate =
      Utils.millisecondsToDays(creationDate);
    if (resetDate) {
      this._currentEnvironment.profile.resetDate =
        Utils.millisecondsToDays(resetDate);
    }
  },

  /**
   * Update the cached attribution data object.
   * @returns Promise<> resolved when the I/O is complete.
   */
  async _updateAttribution() {
    let data = await AttributionCode.getAttrDataAsync();
    if (Object.keys(data).length > 0) {
      this._currentEnvironment.settings.attribution = {};
      for (let key in data) {
        this._currentEnvironment.settings.attribution[key] =
          limitStringToLength(data[key], MAX_ATTRIBUTION_STRING_LENGTH);
      }
    }
  },

  /**
   * Get the partner data in object form.
   * @return Object containing the partner data.
   */
  _getPartner() {
    let partnerData = {
      distributionId: Preferences.get(PREF_DISTRIBUTION_ID, null),
      distributionVersion: Preferences.get(PREF_DISTRIBUTION_VERSION, null),
      partnerId: Preferences.get(PREF_PARTNER_ID, null),
      distributor: Preferences.get(PREF_DISTRIBUTOR, null),
      distributorChannel: Preferences.get(PREF_DISTRIBUTOR_CHANNEL, null),
    };

    // Get the PREF_APP_PARTNER_BRANCH branch and append its children to partner data.
    let partnerBranch = Services.prefs.getBranch(PREF_APP_PARTNER_BRANCH);
    partnerData.partnerNames = partnerBranch.getChildList("");

    return partnerData;
  },

  /**
   * Get the CPU information.
   * @return Object containing the CPU information data.
   */
  _getCpuData() {
    let cpuData = {
      count: getSysinfoProperty("cpucount", null),
      cores: getSysinfoProperty("cpucores", null),
      vendor: getSysinfoProperty("cpuvendor", null),
      family: getSysinfoProperty("cpufamily", null),
      model: getSysinfoProperty("cpumodel", null),
      stepping: getSysinfoProperty("cpustepping", null),
      l2cacheKB: getSysinfoProperty("cpucachel2", null),
      l3cacheKB: getSysinfoProperty("cpucachel3", null),
      speedMHz: getSysinfoProperty("cpuspeed", null),
    };

    const CPU_EXTENSIONS = ["hasMMX", "hasSSE", "hasSSE2", "hasSSE3", "hasSSSE3",
                            "hasSSE4A", "hasSSE4_1", "hasSSE4_2", "hasAVX", "hasAVX2",
                            "hasAES", "hasEDSP", "hasARMv6", "hasARMv7", "hasNEON"];

    // Enumerate the available CPU extensions.
    let availableExts = [];
    for (let ext of CPU_EXTENSIONS) {
      if (getSysinfoProperty(ext, false)) {
        availableExts.push(ext);
      }
    }

    cpuData.extensions = availableExts;

    return cpuData;
  },

  /**
   * Get the device information, if we are on a portable device.
   * @return Object containing the device information data, or null if
   * not a portable device.
   */
  _getDeviceData() {
    if (AppConstants.platform !== "android") {
      return null;
    }

    return {
      model: getSysinfoProperty("device", null),
      manufacturer: getSysinfoProperty("manufacturer", null),
      hardware: getSysinfoProperty("hardware", null),
      isTablet: getSysinfoProperty("tablet", null),
    };
  },

  /**
   * Get the OS information.
   * @return Object containing the OS data.
   */
  _getOSData() {
    let data = {
      name: forceToStringOrNull(getSysinfoProperty("name", null)),
      version: forceToStringOrNull(getSysinfoProperty("version", null)),
      locale: forceToStringOrNull(getSystemLocale()),
    };

    if (AppConstants.platform == "android") {
      data.kernelVersion = forceToStringOrNull(getSysinfoProperty("kernel_version", null));
    } else if (AppConstants.platform === "win") {
      // The path to the "UBR" key, queried to get additional version details on Windows.
      const WINDOWS_UBR_KEY_PATH = "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion";

      let versionInfo = getWindowsVersionInfo();
      data.servicePackMajor = versionInfo.servicePackMajor;
      data.servicePackMinor = versionInfo.servicePackMinor;
      data.windowsBuildNumber = versionInfo.buildNumber;
      // We only need the UBR if we're at or above Windows 10.
      if (typeof(data.version) === "string" &&
          Services.vc.compare(data.version, "10") >= 0) {
        // Query the UBR key and only add it to the environment if it's available.
        // |readRegKey| doesn't throw, but rather returns 'undefined' on error.
        let ubr = WindowsRegistry.readRegKey(Ci.nsIWindowsRegKey.ROOT_KEY_LOCAL_MACHINE,
                                             WINDOWS_UBR_KEY_PATH, "UBR",
                                             Ci.nsIWindowsRegKey.WOW64_64);
        data.windowsUBR = (ubr !== undefined) ? ubr : null;
      }
      data.installYear = getSysinfoProperty("installYear", null);
    }

    return data;
  },

  /**
   * Get the HDD information.
   * @return Object containing the HDD data.
   */
  _getHDDData() {
    return {
      profile: { // hdd where the profile folder is located
        model: getSysinfoProperty("profileHDDModel", null),
        revision: getSysinfoProperty("profileHDDRevision", null),
      },
      binary:  { // hdd where the application binary is located
        model: getSysinfoProperty("binHDDModel", null),
        revision: getSysinfoProperty("binHDDRevision", null),
      },
      system:  { // hdd where the system files are located
        model: getSysinfoProperty("winHDDModel", null),
        revision: getSysinfoProperty("winHDDRevision", null),
      },
    };
  },

  /**
   * Get the GFX information.
   * @return Object containing the GFX data.
   */
  _getGFXData() {
    let gfxData = {
      D2DEnabled: getGfxField("D2DEnabled", null),
      DWriteEnabled: getGfxField("DWriteEnabled", null),
      ContentBackend: getGfxField("ContentBackend", null),
      // The following line is disabled due to main thread jank and will be enabled
      // again as part of bug 1154500.
      // DWriteVersion: getGfxField("DWriteVersion", null),
      adapters: [],
      monitors: [],
      features: {},
    };

    if (!["android", "linux"].includes(AppConstants.platform)) {
      let gfxInfo = Cc["@mozilla.org/gfx/info;1"].getService(Ci.nsIGfxInfo);
      try {
        gfxData.monitors = gfxInfo.getMonitors();
      } catch (e) {
        this._log.error("nsIGfxInfo.getMonitors() caught error", e);
      }
    }

    try {
      let gfxInfo = Cc["@mozilla.org/gfx/info;1"].getService(Ci.nsIGfxInfo);
      gfxData.features = gfxInfo.getFeatures();
    } catch (e) {
      this._log.error("nsIGfxInfo.getFeatures() caught error", e);
    }

    // GfxInfo does not yet expose a way to iterate through all the adapters.
    gfxData.adapters.push(getGfxAdapter(""));
    gfxData.adapters[0].GPUActive = true;

    // If we have a second adapter add it to the gfxData.adapters section.
    let hasGPU2 = getGfxField("adapterDeviceID2", null) !== null;
    if (!hasGPU2) {
      this._log.trace("_getGFXData - Only one display adapter detected.");
      return gfxData;
    }

    this._log.trace("_getGFXData - Two display adapters detected.");

    gfxData.adapters.push(getGfxAdapter("2"));
    gfxData.adapters[1].GPUActive = getGfxField("isGPU2Active", null);

    return gfxData;
  },

  /**
   * Get the system data in object form.
   * @return Object containing the system data.
   */
  _getSystem() {
    let memoryMB = getSysinfoProperty("memsize", null);
    if (memoryMB) {
      // Send RAM size in megabytes. Rounding because sysinfo doesn't
      // always provide RAM in multiples of 1024.
      memoryMB = Math.round(memoryMB / 1024 / 1024);
    }

    let virtualMB = getSysinfoProperty("virtualmemsize", null);
    if (virtualMB) {
      // Send the total virtual memory size in megabytes. Rounding because
      // sysinfo doesn't always provide RAM in multiples of 1024.
      virtualMB = Math.round(virtualMB / 1024 / 1024);
    }

    let data = {
      memoryMB,
      virtualMaxMB: virtualMB,
      cpu: this._getCpuData(),
      os: this._getOSData(),
      hdd: this._getHDDData(),
      gfx: this._getGFXData(),
    };

    if (AppConstants.platform === "win") {
      data.isWow64 = getSysinfoProperty("isWow64", null);
    } else if (AppConstants.platform == "android") {
      data.device = this._getDeviceData();
    }

    return data;
  },

  _onEnvironmentChange(what, oldEnvironment) {
    this._log.trace("_onEnvironmentChange for " + what);

    // We are already skipping change events in _checkChanges if there is a pending change task running.
    if (this._shutdown) {
      this._log.trace("_onEnvironmentChange - Already shut down.");
      return;
    }

    for (let [name, listener] of this._changeListeners) {
      try {
        this._log.debug("_onEnvironmentChange - calling " + name);
        listener(what, oldEnvironment);
      } catch (e) {
        this._log.error("_onEnvironmentChange - listener " + name + " caught error", e);
      }
    }
  },

  reset() {
    this._shutdown = false;
    this._delayedInitFinished = false;
  }
};
