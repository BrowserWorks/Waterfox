/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const {AddonManager} = require("resource://gre/modules/AddonManager.jsm");
const Services = require("Services");
const {getJSON} = require("devtools/client/shared/getjson");
const EventEmitter = require("devtools/shared/event-emitter");

const ADDONS_URL = "devtools.webide.addonsURL";

var SIMULATOR_LINK = Services.prefs.getCharPref("devtools.webide.simulatorAddonsURL");
var ADB_LINK = Services.prefs.getCharPref("devtools.webide.adbAddonURL");
var ADAPTERS_LINK = Services.prefs.getCharPref("devtools.webide.adaptersAddonURL");
var SIMULATOR_ADDON_ID = Services.prefs.getCharPref("devtools.webide.simulatorAddonID");
var ADB_ADDON_ID = Services.prefs.getCharPref("devtools.webide.adbAddonID");
var ADAPTERS_ADDON_ID = Services.prefs.getCharPref("devtools.webide.adaptersAddonID");

var platform = Services.appShell.hiddenDOMWindow.navigator.platform;
var OS = "";
if (platform.indexOf("Win") != -1) {
  OS = "win32";
} else if (platform.indexOf("Mac") != -1) {
  OS = "mac64";
} else if (platform.indexOf("Linux") != -1) {
  if (platform.indexOf("x86_64") != -1) {
    OS = "linux64";
  } else {
    OS = "linux32";
  }
}

var addonsListener = {};
addonsListener.onEnabled =
addonsListener.onDisabled =
addonsListener.onInstalled =
addonsListener.onUninstalled = (updatedAddon) => {
  GetAvailableAddons().then(addons => {
    for (let a of [...addons.simulators, addons.adb, addons.adapters]) {
      if (a.addonID == updatedAddon.id) {
        a.updateInstallStatus();
      }
    }
  });
};
AddonManager.addAddonListener(addonsListener);

var GetAvailableAddons_promise = null;
var GetAvailableAddons = exports.GetAvailableAddons = function () {
  if (!GetAvailableAddons_promise) {
    GetAvailableAddons_promise = new Promise((resolve, reject) => {
      let addons = {
        simulators: [],
        adb: null
      };
      getJSON(ADDONS_URL).then(json => {
        for (let stability in json) {
          for (let version of json[stability]) {
            addons.simulators.push(new SimulatorAddon(stability, version));
          }
        }
        addons.adb = new ADBAddon();
        addons.adapters = new AdaptersAddon();
        resolve(addons);
      }, e => {
        GetAvailableAddons_promise = null;
        reject(e);
      });
    });
  }
  return GetAvailableAddons_promise;
};

exports.ForgetAddonsList = function () {
  GetAvailableAddons_promise = null;
};

function Addon() {}
Addon.prototype = {
  _status: "unknown",
  set status(value) {
    if (this._status != value) {
      this._status = value;
      this.emit("update");
    }
  },
  get status() {
    return this._status;
  },

  updateInstallStatus: function () {
    AddonManager.getAddonByID(this.addonID, (addon) => {
      if (addon && !addon.userDisabled) {
        this.status = "installed";
      } else {
        this.status = "uninstalled";
      }
    });
  },

  install: function () {
    AddonManager.getAddonByID(this.addonID, (addon) => {
      if (addon && !addon.userDisabled) {
        this.status = "installed";
        return;
      }
      this.status = "preparing";
      if (addon && addon.userDisabled) {
        addon.userDisabled = false;
      } else {
        AddonManager.getInstallForURL(this.xpiLink, (install) => {
          install.addListener(this);
          install.install();
        }, "application/x-xpinstall");
      }
    });
  },

  uninstall: function () {
    AddonManager.getAddonByID(this.addonID, (addon) => {
      addon.uninstall();
    });
  },

  installFailureHandler: function (install, message) {
    this.status = "uninstalled";
    this.emit("failure", message);
  },

  onDownloadStarted: function () {
    this.status = "downloading";
  },

  onInstallStarted: function () {
    this.status = "installing";
  },

  onDownloadProgress: function (install) {
    if (install.maxProgress == -1) {
      this.emit("progress", -1);
    } else {
      this.emit("progress", install.progress / install.maxProgress);
    }
  },

  onInstallEnded: function ({addon}) {
    addon.userDisabled = false;
  },

  onDownloadCancelled: function (install) {
    this.installFailureHandler(install, "Download cancelled");
  },
  onDownloadFailed: function (install) {
    this.installFailureHandler(install, "Download failed");
  },
  onInstallCancelled: function (install) {
    this.installFailureHandler(install, "Install cancelled");
  },
  onInstallFailed: function (install) {
    this.installFailureHandler(install, "Install failed");
  },
};

function SimulatorAddon(stability, version) {
  EventEmitter.decorate(this);
  this.stability = stability;
  this.version = version;
  // This addon uses the string "linux" for "linux32"
  let fixedOS = OS == "linux32" ? "linux" : OS;
  this.xpiLink = SIMULATOR_LINK.replace(/#OS#/g, fixedOS)
                               .replace(/#VERSION#/g, version)
                               .replace(/#SLASHED_VERSION#/g, version.replace(/\./g, "_"));
  this.addonID = SIMULATOR_ADDON_ID.replace(/#SLASHED_VERSION#/g, version.replace(/\./g, "_"));
  this.updateInstallStatus();
}
SimulatorAddon.prototype = Object.create(Addon.prototype);

function ADBAddon() {
  EventEmitter.decorate(this);
  // This addon uses the string "linux" for "linux32"
  let fixedOS = OS == "linux32" ? "linux" : OS;
  this.xpiLink = ADB_LINK.replace(/#OS#/g, fixedOS);
  this.addonID = ADB_ADDON_ID;
  this.updateInstallStatus();
}
ADBAddon.prototype = Object.create(Addon.prototype);

function AdaptersAddon() {
  EventEmitter.decorate(this);
  this.xpiLink = ADAPTERS_LINK.replace(/#OS#/g, OS);
  this.addonID = ADAPTERS_ADDON_ID;
  this.updateInstallStatus();
}
AdaptersAddon.prototype = Object.create(Addon.prototype);
