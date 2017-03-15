/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/**
 * This component serves as integration between the platform and AddonManager.
 * It is responsible for initializing and shutting down the AddonManager as well
 * as passing new installs from webpages to the AddonManager.
 */

"use strict";

const { classes: Cc, interfaces: Ci, utils: Cu, results: Cr } = Components;

// The old XPInstall error codes
const EXECUTION_ERROR   = -203;
const CANT_READ_ARCHIVE = -207;
const USER_CANCELLED    = -210;
const DOWNLOAD_ERROR    = -228;
const UNSUPPORTED_TYPE  = -244;
const SUCCESS           = 0;

const MSG_INSTALL_ENABLED  = "WebInstallerIsInstallEnabled";
const MSG_INSTALL_ADDONS   = "WebInstallerInstallAddonsFromWebpage";
const MSG_INSTALL_CALLBACK = "WebInstallerInstallCallback";

const MSG_PROMISE_REQUEST  = "WebAPIPromiseRequest";
const MSG_PROMISE_RESULT   = "WebAPIPromiseResult";
const MSG_INSTALL_EVENT    = "WebAPIInstallEvent";
const MSG_INSTALL_CLEANUP  = "WebAPICleanup";
const MSG_ADDON_EVENT_REQ  = "WebAPIAddonEventRequest";
const MSG_ADDON_EVENT      = "WebAPIAddonEvent";

const CHILD_SCRIPT = "resource://gre/modules/addons/Content.js";

Cu.import("resource://gre/modules/XPCOMUtils.jsm");
Cu.import("resource://gre/modules/Services.jsm");

var gSingleton = null;

function amManager() {
  Cu.import("resource://gre/modules/AddonManager.jsm");
  /* globals AddonManagerPrivate*/

  Services.mm.loadFrameScript(CHILD_SCRIPT, true);
  Services.mm.addMessageListener(MSG_INSTALL_ENABLED, this);
  Services.mm.addMessageListener(MSG_INSTALL_ADDONS, this);
  Services.mm.addMessageListener(MSG_PROMISE_REQUEST, this);
  Services.mm.addMessageListener(MSG_INSTALL_CLEANUP, this);
  Services.mm.addMessageListener(MSG_ADDON_EVENT_REQ, this);

  Services.obs.addObserver(this, "message-manager-close", false);
  Services.obs.addObserver(this, "message-manager-disconnect", false);

  AddonManager.webAPI.setEventHandler(this.sendEvent);

  // Needed so receiveMessage can be called directly by JS callers
  this.wrappedJSObject = this;
}

amManager.prototype = {
  observe: function(aSubject, aTopic, aData) {
    switch (aTopic) {
      case "addons-startup":
        AddonManagerPrivate.startup();
        break;

      case "message-manager-close":
      case "message-manager-disconnect":
        this.childClosed(aSubject);
        break;
    }
  },

  /**
   * @see amIAddonManager.idl
   */
  mapURIToAddonID: function(uri, id) {
    id.value = AddonManager.mapURIToAddonID(uri);
    return !!id.value;
  },

  /**
   * @see amIWebInstaller.idl
   */
  isInstallEnabled: function(aMimetype, aReferer) {
    return AddonManager.isInstallEnabled(aMimetype);
  },

  /**
   * @see amIWebInstaller.idl
   */
  installAddonsFromWebpage: function(aMimetype, aBrowser, aInstallingPrincipal,
                                     aUris, aHashes, aNames, aIcons, aCallback) {
    if (aUris.length == 0)
      return false;

    let retval = true;
    if (!AddonManager.isInstallAllowed(aMimetype, aInstallingPrincipal)) {
      aCallback = null;
      retval = false;
    }

    let installs = [];
    function buildNextInstall() {
      if (aUris.length == 0) {
        AddonManager.installAddonsFromWebpage(aMimetype, aBrowser, aInstallingPrincipal, installs);
        return;
      }
      let uri = aUris.shift();
      AddonManager.getInstallForURL(uri, function(aInstall) {
        function callCallback(aUri, aStatus) {
          try {
            aCallback.onInstallEnded(aUri, aStatus);
          }
          catch (e) {
            Components.utils.reportError(e);
          }
        }

        if (aInstall) {
          installs.push(aInstall);
          if (aCallback) {
            aInstall.addListener({
              onDownloadCancelled: function(aInstall) {
                callCallback(uri, USER_CANCELLED);
              },

              onDownloadFailed: function(aInstall) {
                if (aInstall.error == AddonManager.ERROR_CORRUPT_FILE)
                  callCallback(uri, CANT_READ_ARCHIVE);
                else
                  callCallback(uri, DOWNLOAD_ERROR);
              },

              onInstallFailed: function(aInstall) {
                callCallback(uri, EXECUTION_ERROR);
              },

              onInstallEnded: function(aInstall, aStatus) {
                callCallback(uri, SUCCESS);
              }
            });
          }
        }
        else if (aCallback) {
          aCallback.onInstallEnded(uri, UNSUPPORTED_TYPE);
        }
        buildNextInstall();
      }, aMimetype, aHashes.shift(), aNames.shift(), aIcons.shift(), null, aBrowser);
    }
    buildNextInstall();

    return retval;
  },

  notify: function(aTimer) {
    AddonManagerPrivate.backgroundUpdateTimerHandler();
  },

  // Maps message manager instances for content processes to the associated
  // AddonListener instances.
  addonListeners: new Map(),

  _addAddonListener(target) {
    if (!this.addonListeners.has(target)) {
      let handler = (event, id, needsRestart) => {
        target.sendAsyncMessage(MSG_ADDON_EVENT, {event, id, needsRestart});
      };
      let listener = {
        onEnabling: (addon, needsRestart) => handler("onEnabling", addon.id, needsRestart),
        onEnabled: (addon) => handler("onEnabled", addon.id, false),
        onDisabling: (addon, needsRestart) => handler("onDisabling", addon.id, needsRestart),
        onDisabled: (addon) => handler("onDisabled", addon.id, false),
        onInstalling: (addon, needsRestart) => handler("onInstalling", addon.id, needsRestart),
        onInstalled: (addon) => handler("onInstalled", addon.id, false),
        onUninstalling: (addon, needsRestart) => handler("onUninstalling", addon.id, needsRestart),
        onUninstalled: (addon) => handler("onUninstalled", addon.id, false),
        onOperationCancelled: (addon) => handler("onOperationCancelled", addon.id, false),
      };
      this.addonListeners.set(target, listener);
      AddonManager.addAddonListener(listener);
    }
  },

  _removeAddonListener(target) {
    if (this.addonListeners.has(target)) {
      AddonManager.removeAddonListener(this.addonListeners.get(target));
      this.addonListeners.delete(target);
    }
  },

  /**
   * messageManager callback function.
   *
   * Listens to requests from child processes for InstallTrigger
   * activity, and sends back callbacks.
   */
  receiveMessage: function(aMessage) {
    let payload = aMessage.data;

    switch (aMessage.name) {
      case MSG_INSTALL_ENABLED:
        return AddonManager.isInstallEnabled(payload.mimetype);

      case MSG_INSTALL_ADDONS: {
        let callback = null;
        if (payload.callbackID != -1) {
          let mm = aMessage.target.messageManager;
          callback = {
            onInstallEnded: function(url, status) {
              mm.sendAsyncMessage(MSG_INSTALL_CALLBACK, {
                callbackID: payload.callbackID,
                url: url,
                status: status
              });
            },
          };
        }

        return this.installAddonsFromWebpage(payload.mimetype,
          aMessage.target, payload.principalToInherit, payload.uris,
          payload.hashes, payload.names, payload.icons, callback);
      }

      case MSG_PROMISE_REQUEST: {
        let mm = aMessage.target.messageManager;
        let resolve = (value) => {
          mm.sendAsyncMessage(MSG_PROMISE_RESULT, {
            callbackID: payload.callbackID,
            resolve: value
          });
        }
        let reject = (value) => {
          mm.sendAsyncMessage(MSG_PROMISE_RESULT, {
            callbackID: payload.callbackID,
            reject: value
          });
        }

        let API = AddonManager.webAPI;
        if (payload.type in API) {
          API[payload.type](aMessage.target, ...payload.args).then(resolve, reject);
        }
        else {
          reject("Unknown Add-on API request.");
        }
        break;
      }

      case MSG_INSTALL_CLEANUP: {
        AddonManager.webAPI.clearInstalls(payload.ids);
        break;
      }

      case MSG_ADDON_EVENT_REQ: {
        let target = aMessage.target.messageManager;
        if (payload.enabled) {
          this._addAddonListener(target);
        } else {
          this._removeAddonListener(target);
        }
      }
    }
    return undefined;
  },

  childClosed(target) {
    AddonManager.webAPI.clearInstallsFrom(target);
    this._removeAddonListener(target);
  },

  sendEvent(mm, data) {
    mm.sendAsyncMessage(MSG_INSTALL_EVENT, data);
  },

  classID: Components.ID("{4399533d-08d1-458c-a87a-235f74451cfa}"),
  _xpcom_factory: {
    createInstance: function(aOuter, aIid) {
      if (aOuter != null)
        throw Components.Exception("Component does not support aggregation",
                                   Cr.NS_ERROR_NO_AGGREGATION);

      if (!gSingleton)
        gSingleton = new amManager();
      return gSingleton.QueryInterface(aIid);
    }
  },
  QueryInterface: XPCOMUtils.generateQI([Ci.amIAddonManager,
                                         Ci.amIWebInstaller,
                                         Ci.nsITimerCallback,
                                         Ci.nsIObserver,
                                         Ci.nsIMessageListener])
};

this.NSGetFactory = XPCOMUtils.generateNSGetFactory([amManager]);
