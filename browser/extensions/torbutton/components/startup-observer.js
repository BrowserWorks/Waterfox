// Bug 1506 P1-3: This code is mostly hackish remnants of session store
// support. There are a couple of observer events that *might* be worth
// listening to. Search for 1506 in the code.

/*************************************************************************
 * Startup observer (JavaScript XPCOM component)
 *
 * Cases tested (each during Tor and Non-Tor, FF4 and FF3.6)
 *    1. Crash
 *    2. Upgrade
 *    3. Fresh install
 *
 *************************************************************************/

const Cc = Components.classes;
const Ci = Components.interfaces;
const Cr = Components.results;

// Module specific constants
const kMODULE_NAME = "Startup";
const kMODULE_CONTRACTID = "@torproject.org/startup-observer;1";
const kMODULE_CID = Components.ID("06322def-6fde-4c06-aef6-47ae8e799629");

function StartupObserver() {
    this.logger = Components.classes["@torproject.org/torbutton-logger;1"]
         .getService(Components.interfaces.nsISupports).wrappedJSObject;
    this._prefs = Components.classes["@mozilla.org/preferences-service;1"]
         .getService(Components.interfaces.nsIPrefBranch);
    this.logger.log(3, "Startup Observer created");

    var env = Cc["@mozilla.org/process/environment;1"]
                .getService(Ci.nsIEnvironment);
    var prefName = "browser.startup.homepage";
    if (env.exists("TOR_DEFAULT_HOMEPAGE")) {
      // if the user has set this value in a previous installation, don't override it
      if (!this._prefs.prefHasUserValue(prefName)) {
        this._prefs.setCharPref(prefName, env.get("TOR_DEFAULT_HOMEPAGE"));
      }
    }

    try {
      var test = this._prefs.getCharPref("torbrowser.version");
      this.is_tbb = true;
      this.logger.log(3, "This is a Tor Browser's XPCOM");
    } catch(e) {
      this.logger.log(3, "This is not a Tor Browser's XPCOM");
    }

    try {
      // XXX: We're in a race with HTTPS-Everywhere to update our proxy settings
      // before the initial SSL-Observatory test... If we lose the race, Firefox
      // caches the old proxy settings for check.tp.o somehwere, and it never loads :(
      this.setProxySettings();
    } catch(e) {
      this.logger.log(4, "Early proxy change failed. Will try again at profile load. Error: "+e);
    }
}

StartupObserver.prototype = {
    // Bug 6803: We need to get the env vars early due to
    // some weird proxy caching code that showed up in FF15.
    // Otherwise, homepage domain loads fail forever.
    setProxySettings: function() {
      // Bug 1506: Still want to get these env vars
      var environ = Components.classes["@mozilla.org/process/environment;1"]
                 .getService(Components.interfaces.nsIEnvironment);

      if (environ.exists("TOR_SOCKS_PORT")) {
        if (this.is_tbb) {
            this._prefs.setIntPref('network.proxy.socks_port',
                                   parseInt(environ.get("TOR_SOCKS_PORT")));
            this._prefs.setBoolPref('network.proxy.socks_remote_dns', true);
            this._prefs.setIntPref('network.proxy.type', 1);
        }
        this.logger.log(3, "Reset socks port to "+environ.get("TOR_SOCKS_PORT"));
      }

      if (environ.exists("TOR_SOCKS_HOST")) {
        if (this.is_tbb) {
            this._prefs.setCharPref('network.proxy.socks', environ.get("TOR_SOCKS_HOST"));
        }
      }

      if (environ.exists("TOR_TRANSPROXY")) {
        this.logger.log(3, "Resetting Tor settings to transproxy");
        if (this.is_tbb) {
            this._prefs.setBoolPref('network.proxy.socks_remote_dns', false);
            this._prefs.setIntPref('network.proxy.type', 0);
            this._prefs.setIntPref('network.proxy.socks_port', 0);
            this._prefs.setCharPref('network.proxy.socks', "");
        }
      }

      // Force prefs to be synced to disk
      var prefService = Components.classes["@mozilla.org/preferences-service;1"]
          .getService(Components.interfaces.nsIPrefService);
      prefService.savePrefFile(null);
    
      this.logger.log(3, "Synced network settings to environment.");
    },

    observe: function(subject, topic, data) {
      if(topic == "profile-after-change") {
        // Bug 1506 P1: We listen to these prefs as signals for startup,
        // but only for hackish reasons.
        this._prefs.setBoolPref("extensions.torbutton.startup", true);

        this.setProxySettings();
      }

      // In all cases, force prefs to be synced to disk
      var prefService = Components.classes["@mozilla.org/preferences-service;1"]
          .getService(Components.interfaces.nsIPrefService);
      prefService.savePrefFile(null);
    },

  QueryInterface: function(iid) {
    if (iid.equals(Components.interfaces.nsISupports)) {
        return this;
    }
    if(iid.equals(Components.interfaces.nsIClassInfo)) {
      return this;
    }
    return this;
  },

  // method of nsIClassInfo
  classDescription: "Torbutton Startup Observer",
  classID: kMODULE_CID,
  contractID: kMODULE_CONTRACTID,

  // Hack to get us registered early to observe recovery
  _xpcom_categories: [{category:"profile-after-change"}],

  getInterfaces: function(count) {
    var interfaceList = [nsIClassInfo];
    count.value = interfaceList.length;
    return interfaceList;
  },
  getHelperForLanguage: function(count) { return null; }

};

/**
* XPCOMUtils.generateNSGetFactory was introduced in Mozilla 2 (Firefox 4).
* XPCOMUtils.generateNSGetModule is for Mozilla 1.9.2 (Firefox 3.6).
*/
Components.utils.import("resource://gre/modules/XPCOMUtils.jsm");
if (XPCOMUtils.generateNSGetFactory)
    var NSGetFactory = XPCOMUtils.generateNSGetFactory([StartupObserver]);
else
    var NSGetModule = XPCOMUtils.generateNSGetModule([StartupObserver]);
