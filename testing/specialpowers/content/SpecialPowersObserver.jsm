/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

// Based on:
// https://bugzilla.mozilla.org/show_bug.cgi?id=549539
// https://bug549539.bugzilla.mozilla.org/attachment.cgi?id=429661
// https://developer.mozilla.org/en/XPCOM/XPCOM_changes_in_Gecko_1.9.3
// https://developer.mozilla.org/en/how_to_build_an_xpcom_component_in_javascript

/* import-globals-from SpecialPowersObserverAPI.js */

var EXPORTED_SYMBOLS = ["SpecialPowersObserver", "SpecialPowersObserverFactory"];

Components.utils.import("resource://gre/modules/XPCOMUtils.jsm");
Components.utils.import("resource://gre/modules/Services.jsm");
Components.utils.importGlobalProperties(["File"]);

if (typeof(Cc) == "undefined") {
  const Cc = Components.classes;
  const Ci = Components.interfaces;
}

const CHILD_SCRIPT = "chrome://specialpowers/content/specialpowers.js"
const CHILD_SCRIPT_API = "chrome://specialpowers/content/specialpowersAPI.js"
const CHILD_LOGGER_SCRIPT = "chrome://specialpowers/content/MozillaLogger.js"


// Glue to add in the observer API to this object.  This allows us to share code with chrome tests
var loader = Components.classes["@mozilla.org/moz/jssubscript-loader;1"]
                       .getService(Components.interfaces.mozIJSSubScriptLoader);
loader.loadSubScript("chrome://specialpowers/content/SpecialPowersObserverAPI.js");

/* XPCOM gunk */
this.SpecialPowersObserver = function SpecialPowersObserver() {
  this._isFrameScriptLoaded = false;
  this._messageManager = Cc["@mozilla.org/globalmessagemanager;1"].
                         getService(Ci.nsIMessageBroadcaster);
}


SpecialPowersObserver.prototype = new SpecialPowersObserverAPI();

SpecialPowersObserver.prototype.classDescription = "Special powers Observer for use in testing.";
SpecialPowersObserver.prototype.classID = Components.ID("{59a52458-13e0-4d93-9d85-a637344f29a1}");
SpecialPowersObserver.prototype.contractID = "@mozilla.org/special-powers-observer;1";
SpecialPowersObserver.prototype.QueryInterface = XPCOMUtils.generateQI([Components.interfaces.nsIObserver]);

SpecialPowersObserver.prototype.observe = function(aSubject, aTopic, aData) {
  switch (aTopic) {
    case "chrome-document-global-created":
      this._loadFrameScript();
      break;

    case "http-on-modify-request":
      if (aSubject instanceof Ci.nsIChannel) {
        let uri = aSubject.URI.spec;
        this._sendAsyncMessage("specialpowers-http-notify-request", { uri });
      }
      break;

    default:
      this._observe(aSubject, aTopic, aData);
      break;
  }
};

SpecialPowersObserver.prototype._loadFrameScript = function() {
  if (!this._isFrameScriptLoaded) {
    // Register for any messages our API needs us to handle
    this._messageManager.addMessageListener("SPPrefService", this);
    this._messageManager.addMessageListener("SPProcessCrashService", this);
    this._messageManager.addMessageListener("SPPingService", this);
    this._messageManager.addMessageListener("SpecialPowers.Quit", this);
    this._messageManager.addMessageListener("SpecialPowers.Focus", this);
    this._messageManager.addMessageListener("SpecialPowers.CreateFiles", this);
    this._messageManager.addMessageListener("SpecialPowers.RemoveFiles", this);
    this._messageManager.addMessageListener("SPPermissionManager", this);
    this._messageManager.addMessageListener("SPObserverService", this);
    this._messageManager.addMessageListener("SPLoadChromeScript", this);
    this._messageManager.addMessageListener("SPImportInMainProcess", this);
    this._messageManager.addMessageListener("SPChromeScriptMessage", this);
    this._messageManager.addMessageListener("SPQuotaManager", this);
    this._messageManager.addMessageListener("SPSetTestPluginEnabledState", this);
    this._messageManager.addMessageListener("SPLoadExtension", this);
    this._messageManager.addMessageListener("SPStartupExtension", this);
    this._messageManager.addMessageListener("SPUnloadExtension", this);
    this._messageManager.addMessageListener("SPExtensionMessage", this);
    this._messageManager.addMessageListener("SPCleanUpSTSData", this);

    this._messageManager.loadFrameScript(CHILD_LOGGER_SCRIPT, true);
    this._messageManager.loadFrameScript(CHILD_SCRIPT_API, true);
    this._messageManager.loadFrameScript(CHILD_SCRIPT, true);
    this._isFrameScriptLoaded = true;
    this._createdFiles = null;
  }
};

SpecialPowersObserver.prototype._sendAsyncMessage = function(msgname, msg) {
  this._messageManager.broadcastAsyncMessage(msgname, msg);
};

SpecialPowersObserver.prototype._receiveMessage = function(aMessage) {
  return this._receiveMessageAPI(aMessage);
};

SpecialPowersObserver.prototype.init = function() {
  var obs = Services.obs;
  obs.addObserver(this, "chrome-document-global-created");

  // Register special testing modules.
  var testsURI = Cc["@mozilla.org/file/directory_service;1"].
                   getService(Ci.nsIProperties).
                   get("ProfD", Ci.nsILocalFile);
  testsURI.append("tests.manifest");
  var ioSvc = Cc["@mozilla.org/network/io-service;1"].
                getService(Ci.nsIIOService);
  var manifestFile = ioSvc.newFileURI(testsURI).
                       QueryInterface(Ci.nsIFileURL).file;

  Components.manager.QueryInterface(Ci.nsIComponentRegistrar).
                 autoRegister(manifestFile);

  obs.addObserver(this, "http-on-modify-request");

  this._loadFrameScript();
};

SpecialPowersObserver.prototype.uninit = function() {
  var obs = Services.obs;
  obs.removeObserver(this, "chrome-document-global-created");
  obs.removeObserver(this, "http-on-modify-request");
  this._registerObservers._topics.forEach(function(element) {
    obs.removeObserver(this._registerObservers, element);
  });
  this._removeProcessCrashObservers();

  if (this._isFrameScriptLoaded) {
    this._messageManager.removeMessageListener("SPPrefService", this);
    this._messageManager.removeMessageListener("SPProcessCrashService", this);
    this._messageManager.removeMessageListener("SPPingService", this);
    this._messageManager.removeMessageListener("SpecialPowers.Quit", this);
    this._messageManager.removeMessageListener("SpecialPowers.Focus", this);
    this._messageManager.removeMessageListener("SpecialPowers.CreateFiles", this);
    this._messageManager.removeMessageListener("SpecialPowers.RemoveFiles", this);
    this._messageManager.removeMessageListener("SPPermissionManager", this);
    this._messageManager.removeMessageListener("SPObserverService", this);
    this._messageManager.removeMessageListener("SPLoadChromeScript", this);
    this._messageManager.removeMessageListener("SPImportInMainProcess", this);
    this._messageManager.removeMessageListener("SPChromeScriptMessage", this);
    this._messageManager.removeMessageListener("SPQuotaManager", this);
    this._messageManager.removeMessageListener("SPSetTestPluginEnabledState", this);
    this._messageManager.removeMessageListener("SPLoadExtension", this);
    this._messageManager.removeMessageListener("SPStartupExtension", this);
    this._messageManager.removeMessageListener("SPUnloadExtension", this);
    this._messageManager.removeMessageListener("SPExtensionMessage", this);
    this._messageManager.removeMessageListener("SPCleanUpSTSData", this);

    this._messageManager.removeDelayedFrameScript(CHILD_LOGGER_SCRIPT);
    this._messageManager.removeDelayedFrameScript(CHILD_SCRIPT_API);
    this._messageManager.removeDelayedFrameScript(CHILD_SCRIPT);
    this._isFrameScriptLoaded = false;
  }
};

SpecialPowersObserver.prototype._addProcessCrashObservers = function() {
  if (this._processCrashObserversRegistered) {
    return;
  }

  var obs = Components.classes["@mozilla.org/observer-service;1"]
                      .getService(Components.interfaces.nsIObserverService);

  obs.addObserver(this, "plugin-crashed");
  obs.addObserver(this, "ipc:content-shutdown");
  this._processCrashObserversRegistered = true;
};

SpecialPowersObserver.prototype._removeProcessCrashObservers = function() {
  if (!this._processCrashObserversRegistered) {
    return;
  }

  var obs = Components.classes["@mozilla.org/observer-service;1"]
                      .getService(Components.interfaces.nsIObserverService);

  obs.removeObserver(this, "plugin-crashed");
  obs.removeObserver(this, "ipc:content-shutdown");
  this._processCrashObserversRegistered = false;
};

SpecialPowersObserver.prototype._registerObservers = {
  _self: null,
  _topics: [],
  _add(topic) {
    if (this._topics.indexOf(topic) < 0) {
      this._topics.push(topic);
      Services.obs.addObserver(this, topic);
    }
  },
  observe(aSubject, aTopic, aData) {
    var msg = { aData };
    switch (aTopic) {
      case "perm-changed":
        var permission = aSubject.QueryInterface(Ci.nsIPermission);

        // specialPowersAPI will consume this value, and it is used as a
        // fake permission, but only type and principal.appId will be used.
        //
        // We need to ensure that it looks the same as a real permission,
        // so we fake these properties.
        msg.permission = {
          principal: {
            originAttributes: {appId: permission.principal.appId}
          },
          type: permission.type
        };
      default:
        this._self._sendAsyncMessage("specialpowers-" + aTopic, msg);
    }
  }
};

/**
 * messageManager callback function
 * This will get requests from our API in the window and process them in chrome for it
 **/
SpecialPowersObserver.prototype.receiveMessage = function(aMessage) {
  switch (aMessage.name) {
    case "SPPingService":
      if (aMessage.json.op == "ping") {
        aMessage.target
                .QueryInterface(Ci.nsIFrameLoaderOwner)
                .frameLoader
                .messageManager
                .sendAsyncMessage("SPPingService", { op: "pong" });
      }
      break;
    case "SpecialPowers.Quit":
      let appStartup = Cc["@mozilla.org/toolkit/app-startup;1"].getService(Ci.nsIAppStartup);
      appStartup.quit(Ci.nsIAppStartup.eForceQuit);
      break;
    case "SpecialPowers.Focus":
      aMessage.target.focus();
      break;
    case "SpecialPowers.CreateFiles":
      let filePaths = [];
      if (!this._createdFiles) {
        this._createdFiles = [];
      }
      let createdFiles = this._createdFiles;
      try {
        let promises = [];
        aMessage.data.forEach(function(request) {
          const filePerms = 0666; // eslint-disable-line no-octal
          let testFile = Services.dirsvc.get("ProfD", Ci.nsIFile);
          if (request.name) {
            testFile.appendRelativePath(request.name);
          } else {
            testFile.createUnique(Ci.nsIFile.NORMAL_FILE_TYPE, filePerms);
          }
          let outStream = Cc["@mozilla.org/network/file-output-stream;1"].createInstance(Ci.nsIFileOutputStream);
          outStream.init(testFile, 0x02 | 0x08 | 0x20, // PR_WRONLY | PR_CREATE_FILE | PR_TRUNCATE
                         filePerms, 0);
          if (request.data) {
            outStream.write(request.data, request.data.length);
          }
          outStream.close();
          promises.push(File.createFromFileName(testFile.path, request.options).then(function(file) {
            filePaths.push(file);
          }));
          createdFiles.push(testFile);
        });

        Promise.all(promises).then(function() {
          aMessage.target
                  .QueryInterface(Ci.nsIFrameLoaderOwner)
                  .frameLoader
                  .messageManager
                  .sendAsyncMessage("SpecialPowers.FilesCreated", filePaths);
        }, function(e) {
          aMessage.target
                  .QueryInterface(Ci.nsIFrameLoaderOwner)
                  .frameLoader
                  .messageManager
                  .sendAsyncMessage("SpecialPowers.FilesError", e.toString());
        });
      } catch (e) {
          aMessage.target
                  .QueryInterface(Ci.nsIFrameLoaderOwner)
                  .frameLoader
                  .messageManager
                  .sendAsyncMessage("SpecialPowers.FilesError", e.toString());
      }

      break;
    case "SpecialPowers.RemoveFiles":
      if (this._createdFiles) {
        this._createdFiles.forEach(function(testFile) {
          try {
            testFile.remove(false);
          } catch (e) {}
        });
        this._createdFiles = null;
      }
      break;
    default:
      return this._receiveMessage(aMessage);
  }
  return undefined;
};

this.NSGetFactory = XPCOMUtils.generateNSGetFactory([SpecialPowersObserver]);
this.SpecialPowersObserverFactory = Object.freeze({
  createInstance(outer, id) {
    if (outer) { throw Components.results.NS_ERROR_NO_AGGREGATION }
    return new SpecialPowersObserver();
  },
  loadFactory(lock) {},
  QueryInterface: XPCOMUtils.generateQI([Ci.nsIFactory])
});
