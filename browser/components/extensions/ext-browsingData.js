/* -*- Mode: indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set sts=2 sw=2 et tw=80: */
"use strict";


XPCOMUtils.defineLazyModuleGetter(this, "PlacesUtils",
                                  "resource://gre/modules/PlacesUtils.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "Preferences",
                                  "resource://gre/modules/Preferences.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "Sanitizer",
                                  "resource:///modules/Sanitizer.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "Services",
                                  "resource://gre/modules/Services.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "setTimeout",
                                  "resource://gre/modules/Timer.jsm");

XPCOMUtils.defineLazyServiceGetter(this, "serviceWorkerManager",
                                   "@mozilla.org/serviceworkers/manager;1",
                                   "nsIServiceWorkerManager");

/**
* A number of iterations after which to yield time back
* to the system.
*/
const YIELD_PERIOD = 10;

const PREF_DOMAIN = "privacy.cpd.";

XPCOMUtils.defineLazyGetter(this, "sanitizer", () => {
  let sanitizer = new Sanitizer();
  sanitizer.prefDomain = PREF_DOMAIN;
  return sanitizer;
});

const makeRange = options => {
  return (options.since == null) ?
    null :
    [PlacesUtils.toPRTime(options.since), PlacesUtils.toPRTime(Date.now())];
};

const clearCache = () => {
  // Clearing the cache does not support timestamps.
  return sanitizer.items.cache.clear();
};

const clearCookies = async function(options) {
  let cookieMgr = Services.cookies;
  // This code has been borrowed from sanitize.js.
  let yieldCounter = 0;

  if (options.since) {
    // Iterate through the cookies and delete any created after our cutoff.
    let cookiesEnum = cookieMgr.enumerator;
    while (cookiesEnum.hasMoreElements()) {
      let cookie = cookiesEnum.getNext().QueryInterface(Ci.nsICookie2);

      if (cookie.creationTime >= PlacesUtils.toPRTime(options.since)) {
        // This cookie was created after our cutoff, clear it.
        cookieMgr.remove(cookie.host, cookie.name, cookie.path,
                         false, cookie.originAttributes);

        if (++yieldCounter % YIELD_PERIOD == 0) {
          await new Promise(resolve => setTimeout(resolve, 0)); // Don't block the main thread too long.
        }
      }
    }
  } else {
    // Remove everything.
    cookieMgr.removeAll();
  }
};

const clearDownloads = options => {
  return sanitizer.items.downloads.clear(makeRange(options));
};

const clearFormData = options => {
  return sanitizer.items.formdata.clear(makeRange(options));
};

const clearHistory = options => {
  return sanitizer.items.history.clear(makeRange(options));
};

const clearPasswords = async function(options) {
  let loginManager = Services.logins;
  let yieldCounter = 0;

  if (options.since) {
    // Iterate through the logins and delete any updated after our cutoff.
    let logins = loginManager.getAllLogins();
    for (let login of logins) {
      login.QueryInterface(Ci.nsILoginMetaInfo);
      if (login.timePasswordChanged >= options.since) {
        loginManager.removeLogin(login);
        if (++yieldCounter % YIELD_PERIOD == 0) {
          await new Promise(resolve => setTimeout(resolve, 0)); // Don't block the main thread too long.
        }
      }
    }
  } else {
    // Remove everything.
    loginManager.removeAllLogins();
  }
};

const clearPluginData = options => {
  return sanitizer.items.pluginData.clear(makeRange(options));
};

const clearServiceWorkers = async function() {
  // Clearing service workers does not support timestamps.
  let yieldCounter = 0;

  // Iterate through the service workers and remove them.
  let serviceWorkers = serviceWorkerManager.getAllRegistrations();
  for (let i = 0; i < serviceWorkers.length; i++) {
    let sw = serviceWorkers.queryElementAt(i, Ci.nsIServiceWorkerRegistrationInfo);
    let host = sw.principal.URI.host;
    serviceWorkerManager.removeAndPropagate(host);
    if (++yieldCounter % YIELD_PERIOD == 0) {
      await new Promise(resolve => setTimeout(resolve, 0)); // Don't block the main thread too long.
    }
  }
};

const doRemoval = (options, dataToRemove, extension) => {
  if (options.originTypes &&
      (options.originTypes.protectedWeb || options.originTypes.extension)) {
    return Promise.reject(
      {message: "Firefox does not support protectedWeb or extension as originTypes."});
  }

  let removalPromises = [];
  let invalidDataTypes = [];
  for (let dataType in dataToRemove) {
    if (dataToRemove[dataType]) {
      switch (dataType) {
        case "cache":
          removalPromises.push(clearCache());
          break;
        case "cookies":
          removalPromises.push(clearCookies(options));
          break;
        case "downloads":
          removalPromises.push(clearDownloads(options));
          break;
        case "formData":
          removalPromises.push(clearFormData(options));
          break;
        case "history":
          removalPromises.push(clearHistory(options));
          break;
        case "passwords":
          removalPromises.push(clearPasswords(options));
          break;
        case "pluginData":
          removalPromises.push(clearPluginData(options));
          break;
        case "serviceWorkers":
          removalPromises.push(clearServiceWorkers());
          break;
        default:
          invalidDataTypes.push(dataType);
      }
    }
  }
  if (extension && invalidDataTypes.length) {
    extension.logger.warn(
      `Firefox does not support dataTypes: ${invalidDataTypes.toString()}.`);
  }
  return Promise.all(removalPromises);
};

this.browsingData = class extends ExtensionAPI {
  getAPI(context) {
    let {extension} = context;
    return {
      browsingData: {
        settings() {
          const PREF_DOMAIN = "privacy.cpd.";
          // The following prefs are the only ones in Firefox that match corresponding
          // values used by Chrome when rerturning settings.
          const PREF_LIST = ["cache", "cookies", "history", "formdata", "downloads"];

          // since will be the start of what is returned by Sanitizer.getClearRange
          // divided by 1000 to convert to ms.
          // If Sanitizer.getClearRange returns undefined that means the range is
          // currently "Everything", so we should set since to 0.
          let clearRange = Sanitizer.getClearRange();
          let since = clearRange ? clearRange[0] / 1000 : 0;
          let options = {since};

          let dataToRemove = {};
          let dataRemovalPermitted = {};

          for (let item of PREF_LIST) {
            // The property formData needs a different case than the
            // formdata preference.
            const name = item === "formdata" ? "formData" : item;
            dataToRemove[name] = Preferences.get(`${PREF_DOMAIN}${item}`);
            // Firefox doesn't have the same concept of dataRemovalPermitted
            // as Chrome, so it will always be true.
            dataRemovalPermitted[name] = true;
          }

          return Promise.resolve({options, dataToRemove, dataRemovalPermitted});
        },
        remove(options, dataToRemove) {
          return doRemoval(options, dataToRemove, extension);
        },
        removeCache(options) {
          return doRemoval(options, {cache: true});
        },
        removeCookies(options) {
          return doRemoval(options, {cookies: true});
        },
        removeDownloads(options) {
          return doRemoval(options, {downloads: true});
        },
        removeFormData(options) {
          return doRemoval(options, {formData: true});
        },
        removeHistory(options) {
          return doRemoval(options, {history: true});
        },
        removePasswords(options) {
          return doRemoval(options, {passwords: true});
        },
        removePluginData(options) {
          return doRemoval(options, {pluginData: true});
        },
      },
    };
  }
};
