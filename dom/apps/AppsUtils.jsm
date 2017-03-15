/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const Cu = Components.utils;
const Cc = Components.classes;
const Ci = Components.interfaces;
const Cr = Components.results;

Cu.import("resource://gre/modules/Services.jsm");
Cu.import("resource://gre/modules/XPCOMUtils.jsm");
Cu.import("resource://gre/modules/Promise.jsm");

XPCOMUtils.defineLazyModuleGetter(this, "FileUtils",
  "resource://gre/modules/FileUtils.jsm");

XPCOMUtils.defineLazyModuleGetter(this, "NetUtil",
  "resource://gre/modules/NetUtil.jsm");

XPCOMUtils.defineLazyServiceGetter(this, "appsService",
                                   "@mozilla.org/AppsService;1",
                                   "nsIAppsService");

// Shared code for AppsServiceChild.jsm, Webapps.jsm and Webapps.js

this.EXPORTED_SYMBOLS =
  ["AppsUtils", "ManifestHelper", "isAbsoluteURI", "mozIApplication"];

function debug(s) {
  //dump("-*- AppsUtils.jsm: " + s + "\n");
}

this.isAbsoluteURI = function(aURI) {
  let foo = Services.io.newURI("http://foo", null, null);
  let bar = Services.io.newURI("http://bar", null, null);
  return Services.io.newURI(aURI, null, foo).prePath != foo.prePath ||
         Services.io.newURI(aURI, null, bar).prePath != bar.prePath;
}

this.mozIApplication = function(aApp) {
  _setAppProperties(this, aApp);
}

mozIApplication.prototype = {
  hasPermission: function(aPermission) {
    // This helper checks an URI inside |aApp|'s origin and part of |aApp| has a
    // specific permission. It is not checking if browsers inside |aApp| have such
    // permission.
    let perm = Services.perms.testExactPermissionFromPrincipal(this.principal,
                                                               aPermission);
    return (perm === Ci.nsIPermissionManager.ALLOW_ACTION);
  },

  get principal() {
    if (this._principal) {
      return this._principal;
    }

    this._principal = null;

    try {
      this._principal = Services.scriptSecurityManager.createCodebasePrincipal(
        Services.io.newURI(this.origin, null, null),
        {appId: this.localId});
    } catch(e) {
      dump("Could not create app principal " + e + "\n");
    }

    return this._principal;
  },

  QueryInterface: function(aIID) {
    if (aIID.equals(Ci.mozIApplication) ||
        aIID.equals(Ci.nsISupports))
      return this;
    throw Cr.NS_ERROR_NO_INTERFACE;
  }
}

function _setAppProperties(aObj, aApp) {
  aObj.name = aApp.name;
  aObj.csp = aApp.csp;
  aObj.installOrigin = aApp.installOrigin;
  aObj.origin = aApp.origin;
#ifdef MOZ_WIDGET_ANDROID
  aObj.apkPackageName = aApp.apkPackageName;
#endif
  aObj.receipts = aApp.receipts ? JSON.parse(JSON.stringify(aApp.receipts)) : null;
  aObj.installTime = aApp.installTime;
  aObj.manifestURL = aApp.manifestURL;
  aObj.appStatus = aApp.appStatus;
  aObj.removable = aApp.removable;
  aObj.id = aApp.id;
  aObj.localId = aApp.localId;
  aObj.basePath = aApp.basePath;
  aObj.progress = aApp.progress || 0.0;
  aObj.installState = aApp.installState || "installed";
  aObj.downloadAvailable = aApp.downloadAvailable;
  aObj.downloading = aApp.downloading;
  aObj.readyToApplyDownload = aApp.readyToApplyDownload;
  aObj.downloadSize = aApp.downloadSize || 0;
  aObj.lastUpdateCheck = aApp.lastUpdateCheck;
  aObj.updateTime = aApp.updateTime;
  aObj.etag = aApp.etag;
  aObj.packageEtag = aApp.packageEtag;
  aObj.manifestHash = aApp.manifestHash;
  aObj.packageHash = aApp.packageHash;
  aObj.staged = aApp.staged;
  aObj.installerAppId = aApp.installerAppId || Ci.nsIScriptSecurityManager.NO_APP_ID;
  aObj.installerIsBrowser = !!aApp.installerIsBrowser;
  aObj.storeId = aApp.storeId || "";
  aObj.storeVersion = aApp.storeVersion || 0;
  aObj.role = aApp.role || "";
  aObj.kind = aApp.kind;
  aObj.enabled = aApp.enabled !== undefined ? aApp.enabled : true;
  aObj.sideloaded = aApp.sideloaded;
  aObj.extensionVersion = aApp.extensionVersion;
  aObj.blockedStatus =
    aApp.blockedStatus !== undefined ? aApp.blockedStatus
                                     : Ci.nsIBlocklistService.STATE_NOT_BLOCKED;
  aObj.blocklistId = aApp.blocklistId;
}

this.AppsUtils = {
  // Clones a app, without the manifest.
  cloneAppObject: function(aApp) {
    let obj = {};
    _setAppProperties(obj, aApp);
    return obj;
  },

  // Creates a nsILoadContext object with a given appId and inIsolatedMozBrowser
  // flag.
  createLoadContext: function createLoadContext(aAppId, aInIsolatedMozBrowser) {
    return {
       associatedWindow: null,
       topWindow : null,
       appId: aAppId,
       isInIsolatedMozBrowserElement: aInIsolatedMozBrowser,
       originAttributes: {
         appId: aAppId,
         inIsolatedMozBrowser: aInIsolatedMozBrowser
       },
       usePrivateBrowsing: false,
       isContent: false,

       QueryInterface: XPCOMUtils.generateQI([Ci.nsILoadContext,
                                              Ci.nsIInterfaceRequestor,
                                              Ci.nsISupports]),
       getInterface: function(iid) {
         if (iid.equals(Ci.nsILoadContext))
           return this;
         throw Cr.NS_ERROR_NO_INTERFACE;
       }
     }
  },

  // Sends data downloaded from aRequestChannel to a file
  // identified by aId and aFileName.
  getFile: function(aRequestChannel, aId, aFileName) {
    let deferred = Promise.defer();

    // Staging the file in TmpD until all the checks are done.
    let file = FileUtils.getFile("TmpD", ["webapps", aId, aFileName], true);

    // We need an output stream to write the channel content to the out file.
    let outputStream = Cc["@mozilla.org/network/file-output-stream;1"]
                         .createInstance(Ci.nsIFileOutputStream);
    // write, create, truncate
    outputStream.init(file, 0x02 | 0x08 | 0x20, parseInt("0664", 8), 0);
    let bufferedOutputStream =
      Cc['@mozilla.org/network/buffered-output-stream;1']
        .createInstance(Ci.nsIBufferedOutputStream);
    bufferedOutputStream.init(outputStream, 1024);

    // Create a listener that will give data to the file output stream.
    let listener = Cc["@mozilla.org/network/simple-stream-listener;1"]
                     .createInstance(Ci.nsISimpleStreamListener);

    listener.init(bufferedOutputStream, {
      onStartRequest: function(aRequest, aContext) {
        // Nothing to do there anymore.
      },

      onStopRequest: function(aRequest, aContext, aStatusCode) {
        bufferedOutputStream.close();
        outputStream.close();

        if (!Components.isSuccessCode(aStatusCode)) {
          deferred.reject({ msg: "NETWORK_ERROR", downloadAvailable: true});
          return;
        }

        // If we get a 4XX or a 5XX http status, bail out like if we had a
        // network error.
        let responseStatus = aRequestChannel.responseStatus;
        if (responseStatus >= 400 && responseStatus <= 599) {
          // unrecoverable error, don't bug the user
          deferred.reject({ msg: "NETWORK_ERROR", downloadAvailable: false});
          return;
        }

        deferred.resolve(file);
      }
    });
    aRequestChannel.asyncOpen2(listener);

    return deferred.promise;
  },

  // Eliminate query and hash string.
  getFilePath: function(aPagePath) {
    let urlParser = Cc["@mozilla.org/network/url-parser;1?auth=no"]
                    .getService(Ci.nsIURLParser);
    let uriData = [aPagePath, aPagePath.length, {}, {}, {}, {}, {}, {}];
    urlParser.parsePath.apply(urlParser, uriData);
    let [{value: pathPos}, {value: pathLen}] = uriData.slice(2, 4);
    return aPagePath.substr(pathPos, pathLen);
  },

  getAppByManifestURL: function getAppByManifestURL(aApps, aManifestURL) {
    debug("getAppByManifestURL " + aManifestURL);
    // This could be O(1) if |webapps| was a dictionary indexed on manifestURL
    // which should be the unique app identifier.
    // It's currently O(n).
    for (let id in aApps) {
      let app = aApps[id];
      if (app.manifestURL == aManifestURL) {
        return new mozIApplication(app);
      }
    }

    return null;
  },

  getManifestFor: function getManifestFor(aManifestURL) {
    debug("getManifestFor(" + aManifestURL + ")");
    return DOMApplicationRegistry.getManifestFor(aManifestURL);
  },

  getAppLocalIdByManifestURL: function getAppLocalIdByManifestURL(aApps, aManifestURL) {
    debug("getAppLocalIdByManifestURL " + aManifestURL);
    for (let id in aApps) {
      if (aApps[id].manifestURL == aManifestURL) {
        return aApps[id].localId;
      }
    }

    return Ci.nsIScriptSecurityManager.NO_APP_ID;
  },

  getAppLocalIdByStoreId: function(aApps, aStoreId) {
    debug("getAppLocalIdByStoreId:" + aStoreId);
    for (let id in aApps) {
      if (aApps[id].storeId == aStoreId) {
        return aApps[id].localId;
      }
    }

    return Ci.nsIScriptSecurityManager.NO_APP_ID;
  },

  getAppByLocalId: function getAppByLocalId(aApps, aLocalId) {
    debug("getAppByLocalId " + aLocalId);
    for (let id in aApps) {
      let app = aApps[id];
      if (app.localId == aLocalId) {
        return new mozIApplication(app);
      }
    }

    return null;
  },

  getManifestURLByLocalId: function getManifestURLByLocalId(aApps, aLocalId) {
    debug("getManifestURLByLocalId " + aLocalId);
    for (let id in aApps) {
      let app = aApps[id];
      if (app.localId == aLocalId) {
        return app.manifestURL;
      }
    }

    return "";
  },

  areAnyAppsInstalled: function(aApps) {
    return Object.getOwnPropertyNames(aApps).length > 0;
  },

  getCoreAppsBasePath: function getCoreAppsBasePath() {
    debug("getCoreAppsBasePath()");
    try {
      return FileUtils.getDir("coreAppsDir", ["webapps"], false).path;
    } catch(e) {
      return null;
    }
  },

  getAppInfo: function getAppInfo(aApps, aAppId) {
    let app = aApps[aAppId];

    if (!app) {
      debug("No webapp for " + aAppId);
      return null;
    }

    // We can have 3rd party apps that are non-removable,
    // so we can't use the 'removable' property for isCoreApp
    // Instead, we check if the app is installed under /system/b2g
    let isCoreApp = false;

#ifdef MOZ_WIDGET_GONK
    isCoreApp = app.basePath == this.getCoreAppsBasePath();
#endif
    debug(app.basePath + " isCoreApp: " + isCoreApp);

    return { "path": app.basePath + "/" + app.id,
             "isCoreApp": isCoreApp };
  },

  /**
    * Remove potential HTML tags from displayable fields in the manifest.
    * We check name, description, developer name, and permission description
    */
  sanitizeManifest: function(aManifest) {
    let sanitizer = Cc["@mozilla.org/parserutils;1"]
                      .getService(Ci.nsIParserUtils);
    if (!sanitizer) {
      return;
    }

    function sanitize(aStr) {
      return sanitizer.convertToPlainText(aStr,
               Ci.nsIDocumentEncoder.OutputRaw, 0);
    }

    function sanitizeEntryPoint(aRoot) {
      aRoot.name = sanitize(aRoot.name);

      if (aRoot.description) {
        aRoot.description = sanitize(aRoot.description);
      }

      if (aRoot.developer && aRoot.developer.name) {
        aRoot.developer.name = sanitize(aRoot.developer.name);
      }

      if (aRoot.permissions) {
        for (let permission in aRoot.permissions) {
          if (aRoot.permissions[permission].description) {
            aRoot.permissions[permission].description =
             sanitize(aRoot.permissions[permission].description);
          }
        }
      }
    }

    // First process the main section, then the entry points.
    sanitizeEntryPoint(aManifest);

    if (aManifest.entry_points) {
      for (let entry in aManifest.entry_points) {
        sanitizeEntryPoint(aManifest.entry_points[entry]);
      }
    }
  },

  /**
   * From https://developer.mozilla.org/en/OpenWebApps/The_Manifest
   * Only the name property is mandatory.
   */
  checkManifest: function(aManifest, app) {
    if (aManifest.name == undefined)
      return false;

    this.sanitizeManifest(aManifest);

    // launch_path, entry_points launch paths, message hrefs, and activity hrefs can't be absolute
    if (aManifest.launch_path && isAbsoluteURI(aManifest.launch_path))
      return false;

    function checkAbsoluteEntryPoints(entryPoints) {
      for (let name in entryPoints) {
        if (entryPoints[name].launch_path && isAbsoluteURI(entryPoints[name].launch_path)) {
          return true;
        }
      }
      return false;
    }

    if (checkAbsoluteEntryPoints(aManifest.entry_points))
      return false;

    for (let localeName in aManifest.locales) {
      if (checkAbsoluteEntryPoints(aManifest.locales[localeName].entry_points)) {
        return false;
      }
    }

    if (aManifest.activities) {
      for (let activityName in aManifest.activities) {
        let activity = aManifest.activities[activityName];
        if (activity.href && isAbsoluteURI(activity.href)) {
          return false;
        }
      }
    }

    // |messages| is an array of items, where each item is either a string or
    // a {name: href} object.
    let messages = aManifest.messages;
    if (messages) {
      if (!Array.isArray(messages)) {
        return false;
      }
      for (let item of aManifest.messages) {
        if (typeof item == "object") {
          let keys = Object.keys(item);
          if (keys.length != 1) {
            return false;
          }
          if (isAbsoluteURI(item[keys[0]])) {
            return false;
          }
        }
      }
    }

    // The 'size' field must be a positive integer.
    if (aManifest.size) {
      aManifest.size = parseInt(aManifest.size);
      if (Number.isNaN(aManifest.size) || aManifest.size < 0) {
        return false;
      }
    }

    // The 'role' field must be a string.
    if (aManifest.role && (typeof aManifest.role !== "string")) {
      return false;
    }
    return true;
  },

  checkManifestContentType: function
     checkManifestContentType(aInstallOrigin, aWebappOrigin, aContentType) {
    let hadCharset = { };
    let charset = { };
    let netutil = Cc["@mozilla.org/network/util;1"].getService(Ci.nsINetUtil);
    let contentType = netutil.parseResponseContentType(aContentType, charset, hadCharset);
    if (aInstallOrigin != aWebappOrigin &&
        !(contentType == "application/x-web-app-manifest+json" ||
          contentType == "application/manifest+json")) {
      return false;
    }
    return true;
  },

  allowUnsignedAddons: false, // for testing purposes.

  /**
   * Checks if the app role is allowed:
   * Only certified apps can be themes.
   * Only privileged or certified apps can be addons.
   * @param aRole   : the role assigned to this app.
   * @param aStatus : the APP_STATUS_* for this app.
   */
  checkAppRole: function(aRole, aStatus) {
    try {
      // Anything is possible in developer mode.
      if (Services.prefs.getBoolPref("dom.apps.developer_mode")) {
        return true;
      }
    } catch(e) {}

    if (aRole == "theme" && aStatus !== Ci.nsIPrincipal.APP_STATUS_CERTIFIED) {
      return false;
    }
    if (!this.allowUnsignedAddons &&
        (aRole == "addon" &&
         aStatus !== Ci.nsIPrincipal.APP_STATUS_CERTIFIED &&
         aStatus !== Ci.nsIPrincipal.APP_STATUS_PRIVILEGED)) {
      return false;
    }
    return true;
  },

  /**
   * Method to apply modifications to webapp manifests file saved internally.
   * For now, only ensure app can't rename itself.
   */
  ensureSameAppName: function ensureSameAppName(aOldManifest, aNewManifest, aApp) {
    // Ensure that app name can't be updated
    aNewManifest.name = aApp.name;

    let defaultShortName =
      new ManifestHelper(aOldManifest, aApp.origin, aApp.manifestURL).short_name;
    aNewManifest.short_name = defaultShortName;

    // Nor through localized names
    if ("locales" in aNewManifest) {
      for (let locale in aNewManifest.locales) {
        let newLocaleEntry = aNewManifest.locales[locale];

        let oldLocaleEntry = aOldManifest && "locales" in aOldManifest &&
            locale in aOldManifest.locales && aOldManifest.locales[locale];

        if (newLocaleEntry.name) {
          // In case previous manifest didn't had a name,
          // we use the default app name
          newLocaleEntry.name =
            (oldLocaleEntry && oldLocaleEntry.name) || aApp.name;
        }
        if (newLocaleEntry.short_name) {
          newLocaleEntry.short_name =
            (oldLocaleEntry && oldLocaleEntry.short_name) || defaultShortName;
        }
      }
    }
  },

  /**
   * Determines whether the manifest allows installs for the given origin.
   * @param object aManifest
   * @param string aInstallOrigin
   * @return boolean
   **/
  checkInstallAllowed: function checkInstallAllowed(aManifest, aInstallOrigin) {
    if (!aManifest.installs_allowed_from) {
      return true;
    }

    function cbCheckAllowedOrigin(aOrigin) {
      return aOrigin == "*" || aOrigin == aInstallOrigin;
    }

    return aManifest.installs_allowed_from.some(cbCheckAllowedOrigin);
  },

  /**
   * Determine the type of app (app, privileged, certified)
   * that is installed by the manifest
   * @param object aManifest
   * @returns integer
   **/
  getAppManifestStatus: function getAppManifestStatus(aManifest) {
    let type = aManifest.type || "web";

    switch(type) {
    case "web":
      return Ci.nsIPrincipal.APP_STATUS_INSTALLED;
    case "privileged":
      return Ci.nsIPrincipal.APP_STATUS_PRIVILEGED;
    case "certified":
      return Ci.nsIPrincipal.APP_STATUS_CERTIFIED;
    default:
      throw new Error("Webapps.jsm: Undetermined app manifest type");
    }
  },

  /**
   * Check if two manifests have the same set of properties and that the
   * values of these properties are the same, in each locale.
   * Manifests here are raw json ones.
   */
  compareManifests: function compareManifests(aManifest1, aManifest2) {
    // 1. check if we have the same locales in both manifests.
    let locales1 = [];
    let locales2 = [];
    if (aManifest1.locales) {
      for (let locale in aManifest1.locales) {
        locales1.push(locale);
      }
    }
    if (aManifest2.locales) {
      for (let locale in aManifest2.locales) {
        locales2.push(locale);
      }
    }
    if (locales1.sort().join() !== locales2.sort().join()) {
      return false;
    }

    // Helper function to check the app name and developer information for
    // two given roots.
    let checkNameAndDev = function(aRoot1, aRoot2) {
      let name1 = aRoot1.name;
      let name2 = aRoot2.name;
      if (name1 !== name2) {
        return false;
      }

      let dev1 = aRoot1.developer;
      let dev2 = aRoot2.developer;
      if ((dev1 && !dev2) || (dev2 && !dev1)) {
        return false;
      }

      return (!dev1 && !dev2) ||
             (dev1.name === dev2.name && dev1.url === dev2.url);
    }

    // 2. For each locale, check if the name and dev info are the same.
    if (!checkNameAndDev(aManifest1, aManifest2)) {
      return false;
    }

    for (let locale in aManifest1.locales) {
      if (!checkNameAndDev(aManifest1.locales[locale],
                           aManifest2.locales[locale])) {
        return false;
      }
    }

    // Nothing failed.
    return true;
  },

  // Asynchronously loads a JSON file. aPath is a string representing the path
  // of the file to be read.
  loadJSONAsync: function(aPath) {
    let deferred = Promise.defer();

    try {
      let file = Cc["@mozilla.org/file/local;1"].createInstance(Ci.nsIFile);
      file.initWithPath(aPath);

      let channel = NetUtil.newChannel({
        uri: NetUtil.newURI(file),
        loadUsingSystemPrincipal: true});

      channel.contentType = "application/json";

      NetUtil.asyncFetch(channel, function(aStream, aResult) {
        if (!Components.isSuccessCode(aResult)) {
          deferred.resolve(null);

          if (aResult == Cr.NS_ERROR_FILE_NOT_FOUND) {
            // We expect this under certain circumstances, like for webapps.json
            // on firstrun, so we return early without reporting an error.
            return;
          }

          Cu.reportError("AppsUtils: Could not read from json file " + aPath);
          return;
        }

        try {
          // Obtain a converter to read from a UTF-8 encoded input stream.
          let converter = Cc["@mozilla.org/intl/scriptableunicodeconverter"]
                            .createInstance(Ci.nsIScriptableUnicodeConverter);
          converter.charset = "UTF-8";

          // Read json file into a string
          let data = JSON.parse(converter.ConvertToUnicode(NetUtil.readInputStreamToString(aStream,
                                                            aStream.available()) || ""));
          aStream.close();

          deferred.resolve(data);
        } catch (ex) {
          Cu.reportError("AppsUtils: Could not parse JSON: " +
                         aPath + " " + ex + "\n" + ex.stack);
          deferred.resolve(null);
        }
      });
    } catch (ex) {
      Cu.reportError("AppsUtils: Could not read from " +
                     aPath + " : " + ex + "\n" + ex.stack);
      deferred.resolve(null);
    }

    return deferred.promise;
  },

  // Returns the hash of a string, with MD5 as a default hashing function.
  computeHash: function(aString, aAlgorithm = "MD5") {
    let converter = Cc["@mozilla.org/intl/scriptableunicodeconverter"]
                      .createInstance(Ci.nsIScriptableUnicodeConverter);
    converter.charset = "UTF-8";
    let result = {};
    // Data is an array of bytes.
    let data = converter.convertToByteArray(aString, result);

    let hasher = Cc["@mozilla.org/security/hash;1"]
                   .createInstance(Ci.nsICryptoHash);
    hasher.initWithString(aAlgorithm);
    hasher.update(data, data.length);
    // We're passing false to get the binary hash and not base64.
    let hash = hasher.finish(false);

    function toHexString(charCode) {
      return ("0" + charCode.toString(16)).slice(-2);
    }

    // Convert the binary hash data to a hex string.
    return Array.from(hash, (c, i) => toHexString(hash.charCodeAt(i))).join("");
  },

  // Returns the hash for a JS object.
  computeObjectHash: function(aObject) {
    return this.computeHash(JSON.stringify(aObject));
  },

  getAppManifestURLFromWindow: function(aWindow) {
    let appId = aWindow.document.nodePrincipal.appId;
    if (appId === Ci.nsIScriptSecurityManager.NO_APP_ID) {
      return null;
    }

    return appsService.getManifestURLByLocalId(appId);
  },
}

/**
 * Helper object to access manifest information with locale support
 */
this.ManifestHelper = function(aManifest, aOrigin, aManifestURL, aLang) {
  // If the app is packaged, we resolve uris against the origin.
  // If it's not, against the manifest url.

  if (!aOrigin || !aManifestURL) {
    throw Error("ManifestHelper needs both origin and manifestURL");
  }

  this._baseURI = Services.io.newURI(
    aOrigin.startsWith("app://") ? aOrigin : aManifestURL, null, null);

  // We keep the manifest url in all cases since we need it to
  // resolve the package path for packaged apps.
  this._manifestURL = Services.io.newURI(aManifestURL, null, null);

  this._manifest = aManifest;

  let locale = aLang;
  if (!locale) {
    let chrome = Cc["@mozilla.org/chrome/chrome-registry;1"]
                   .getService(Ci.nsIXULChromeRegistry)
                   .QueryInterface(Ci.nsIToolkitChromeRegistry);
    locale = chrome.getSelectedLocale("global").toLowerCase();
  }

  this._localeRoot = this._manifest;

  if (this._manifest.locales && this._manifest.locales[locale]) {
    this._localeRoot = this._manifest.locales[locale];
  }
  else if (this._manifest.locales) {
    // try with the language part of the locale ("en" for en-GB) only
    let lang = locale.split('-')[0];
    if (lang != locale && this._manifest.locales[lang])
      this._localeRoot = this._manifest.locales[lang];
  }
};

ManifestHelper.prototype = {
  _localeProp: function(aProp) {
    if (this._localeRoot[aProp] != undefined)
      return this._localeRoot[aProp];
    return (aProp in this._manifest) ? this._manifest[aProp] : undefined;
  },

  get name() {
    return this._localeProp("name");
  },

  get short_name() {
    return this._localeProp("short_name");
  },

  get description() {
    return this._localeProp("description");
  },

  get type() {
    return this._localeProp("type");
  },

  get version() {
    return this._localeProp("version");
  },

  get launch_path() {
    return this._localeProp("launch_path");
  },

  get developer() {
    // Default to {} in order to avoid exception in code
    // that doesn't check for null `developer`
    return this._localeProp("developer") || {};
  },

  get icons() {
    return this._localeProp("icons");
  },

  get appcache_path() {
    return this._localeProp("appcache_path");
  },

  get orientation() {
    return this._localeProp("orientation");
  },

  get package_path() {
    return this._localeProp("package_path");
  },

  get size() {
    return this._manifest["size"] || 0;
  },

  get permissions() {
    if (this._manifest.permissions) {
      return this._manifest.permissions;
    }
    return {};
  },

  biggestIconURL: function(predicate) {
    let icons = this._localeProp("icons");
    if (!icons) {
      return null;
    }

    let iconSizes = Object.keys(icons).sort((a, b) => a - b)
                          .filter(predicate || (() => true));
    if (iconSizes.length == 0) {
      return null;
    }
    let biggestIconSize = iconSizes.pop();
    let biggestIcon = icons[biggestIconSize];
    let biggestIconURL = this._baseURI.resolve(biggestIcon);

    return biggestIconURL;
  },

  iconURLForSize: function(aSize) {
    let icons = this._localeProp("icons");
    if (!icons)
      return null;
    let dist = 100000;
    let icon = null;
    for (let size in icons) {
      let iSize = parseInt(size);
      if (Math.abs(iSize - aSize) < dist) {
        icon = this._baseURI.resolve(icons[size]);
        dist = Math.abs(iSize - aSize);
      }
    }
    return icon;
  },

  fullLaunchPath: function(aStartPoint) {
    // If no start point is specified, we use the root launch path.
    // In all error cases, we just return null.
    if ((aStartPoint || "") === "") {
      // W3C start_url takes precedence over mozApps launch_path
      if (this._localeProp("start_url")) {
        return this._baseURI.resolve(this._localeProp("start_url") || "/");
      }
      return this._baseURI.resolve(this._localeProp("launch_path") || "/");
    }

    // Search for the l10n entry_points property.
    let entryPoints = this._localeProp("entry_points");
    if (!entryPoints) {
      return null;
    }

    if (entryPoints[aStartPoint]) {
      return this._baseURI.resolve(entryPoints[aStartPoint].launch_path || "/");
    }

    return null;
  },

  resolveURL: function(aURI) {
    // This should be enforced higher up, but check it here just in case.
    if (isAbsoluteURI(aURI)) {
      throw new Error("Webapps.jsm: non-relative URI passed to resolve");
    }
    return this._baseURI.resolve(aURI);
  },

  fullAppcachePath: function() {
    let appcachePath = this._localeProp("appcache_path");
    return this._baseURI.resolve(appcachePath ? appcachePath : "/");
  },

  fullPackagePath: function() {
    let packagePath = this._localeProp("package_path");
    return this._manifestURL.resolve(packagePath ? packagePath : "/");
  },

  get role() {
    return this._manifest.role || "";
  },

  get csp() {
    return this._manifest.csp || "";
  }
}
