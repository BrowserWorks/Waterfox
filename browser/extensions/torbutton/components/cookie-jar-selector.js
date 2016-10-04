// Bug 1506 P1: This component is currently only used to protect
// user-selected cookies from deletion. Moreover, all the E4X code is
// deprecated and needs to be replaced with JSON.

/*************************************************************************
 * Cookie Jar Selector (JavaScript XPCOM component)
 * Enables selection of separate cookie jars for (more) anonymous browsing.
 * Designed as a component of FoxTor, http://cups.cs.cmu.edu/foxtor/
 * Copyright 2006, distributed under the same (open source) license as FoxTor
 *
 * Contributor(s):
 *         Collin Jackson <mozilla@collinjackson.com>
 *
 *************************************************************************/

// Module specific constants
const kMODULE_NAME = "Cookie Jar Selector";
const kMODULE_CONTRACTID = "@torproject.org/cookie-jar-selector;1";
const kMODULE_CID = Components.ID("e6204253-b690-4159-bfe8-d4eedab6b3be");

const Cr = Components.results;

// XXX: Must match the definition in torcookie.js :/
function Cookie(number,name,value,isDomain,host,rawHost,HttpOnly,path,isSecure,isSession,
                expires,isProtected) {
  this.number = number;
  this.name = name;
  this.value = value;
  this.isDomain = isDomain;
  this.host = host;
  this.rawHost = rawHost;
  this.isHttpOnly = HttpOnly;
  this.path = path;
  this.isSecure = isSecure;
  this.isSession = isSession;
  this.expires = expires;
  this.isProtected = isProtected;
}

function CookieJarSelector() {
  var Cc = Components.classes;
  var Ci = Components.interfaces;

  this.logger = Components.classes["@torproject.org/torbutton-logger;1"]
      .getService(Components.interfaces.nsISupports).wrappedJSObject;

  this.logger.log(3, "Component Load 5: New CookieJarSelector "+kMODULE_CONTRACTID);

  this.prefs = Cc["@mozilla.org/preferences-service;1"].getService(Ci.nsIPrefBranch);

  var getProfileFile = function(filename) {
    var loc = "ProfD";  // profile directory
    var file = 
      Cc["@mozilla.org/file/directory_service;1"]
      .getService(Ci.nsIProperties)
      .get(loc, Ci.nsILocalFile)
      .clone();
    file.append(filename); 
    return file;
  };

  var copyProfileFile = function(src, dest) {
    var srcfile = getProfileFile(src);    
    var destfile = getProfileFile(dest);
    if (srcfile.exists()) {
      // XXX: Permissions issue with Vista roaming profiles? 
      // Maybe file locking?
      try {
          if (destfile.exists()) {
              destfile.remove(false);
          }
      } catch(e) {
          this.logger.log(4, "Cookie file deletion exception: "+e);
      }
      try {
          srcfile.copyTo(null, dest);
      } catch(e) {
          this.logger.log(5, "Cookie file copy exception: "+e);
      }
    }
  };

  var moveProfileFile = function(src, dest) { // FIXME: Why does this not work?
    var srcfile = getProfileFile(src);    
    var destfile = getProfileFile(dest);
    if (srcfile.exists()) {
      if (destfile.exists()) {
        destfile.remove(false);
      }
      srcfile.moveTo(null, dest);
    }
  };

  this.clearCookies = function() {
    try {
        Cc["@mozilla.org/cookiemanager;1"]
            .getService(Ci.nsICookieManager)
            .removeAll();
    } catch(e) {
        this.logger.log(4, "Cookie clearing exception: "+e);
    }
  };

  this._cookiesToJS = function(getSession) {
    var cookieManager =
      Cc["@mozilla.org/cookiemanager;1"]
      .getService(Ci.nsICookieManager);
    var cookiesEnum = cookieManager.enumerator;
    var cookiesAsJS = [];
    var count = 0;
    while (cookiesEnum.hasMoreElements()) {
        var nextCookie = cookiesEnum.getNext().QueryInterface(Ci.nsICookie2);
        var JSCookie = new Cookie(count++, nextCookie.name, nextCookie.value, nextCookie.isDomain, nextCookie.host,
                   (nextCookie.host.charAt(0)==".") ? nextCookie.host.substring(1,nextCookie.host.length) : nextCookie.host,
                   nextCookie.isHttpOnly, nextCookie.path, nextCookie.isSecure, nextCookie.isSession, nextCookie.expires,
                   false);
        // Save either session or non-session cookies this time around:
        if (JSCookie.isSession && getSession ||
                !JSCookie.isSession && !getSession)
            cookiesAsJS.push(JSCookie);
    }
    return cookiesAsJS;
  };

  this._loadCookiesFromJS = function(cookiesAsJS) {
        if (typeof(cookiesAsJS) == "undefined" || !cookiesAsJS)
            return;

        var cookieManager =
            Cc["@mozilla.org/cookiemanager;1"]
            .getService(Ci.nsICookieManager2);

        for (var i = 0; i < cookiesAsJS.length; i++) {
            var cookie = cookiesAsJS[i];
            //this.logger.log(2, "Loading cookie: "+host+":"+cname+" until: "+expiry);
            cookieManager.add(cookie.host, cookie.path, cookie.name, cookie.value,
                              cookie.isSecure, cookie.isHttpOnly, cookie.isSession,
                              cookie.expires);
        }
  };

  this._cookiesToFile = function(name) {
    var file = getProfileFile("cookies-" + name + ".json");
    var foStream = Cc["@mozilla.org/network/file-output-stream;1"]
          .createInstance(Ci.nsIFileOutputStream);
    foStream.init(file, 0x02 | 0x08 | 0x20, 0666, 0);
    var data = JSON.stringify(this["cookiesobj-" + name]);
    foStream.write(data, data.length);
    foStream.close();
  };

  // Start1506
  this._protectedCookiesToFile = function(name) {
    var file = getProfileFile("protected-" + name + ".json");
    var foStream = Cc["@mozilla.org/network/file-output-stream;1"]
        .createInstance(Ci.nsIFileOutputStream);
    foStream.init(file, 0x02 | 0x08 | 0x20, 0666, 0);
    var data = JSON.stringify(this["protected-" + name]);
    foStream.write(data, data.length);
    foStream.close();
  };

  this.addProtectedCookie = function(cookie) {
    var name = "tor";
    var cookies = this.getProtectedCookies(name);

    if (typeof(cookies) == "undefined" || cookies == null
            || cookies.length == 0)
      cookies = [];

    if (cookie.isSession) {
      // session cookies get fucked up expiry. Give it 1yr if
      // the user wants to save their session cookies
      cookie.expires = Date.now()/1000 + 365*24*60*60;
    }

    cookies.push(cookie);
    this["protected-" + name] = cookies;

    if (!this.prefs.getBoolPref("extensions.torbutton.block_disk")) {
      // save protected cookies to file
      this._protectedCookiesToFile(name);
    } else {
      try {
        var file = getProfileFile("protected-" + name + ".json");
        if (file.exists()) {
          file.remove(false);
        }
      } catch(e) {
        this.logger.log(5, "Can't remove "+name+" cookie file: "+e);
      }
    }
  };

  this.getProtectedCookies = function(name) {
      var file = getProfileFile("protected-" + name + ".json");
      if (!file.exists()) {
        return this["protected-" + name];
      }
      var data = "";
      var fstream = Cc["@mozilla.org/network/file-input-stream;1"]
          .createInstance(Ci.nsIFileInputStream);
      var sstream = Cc["@mozilla.org/scriptableinputstream;1"]
          .createInstance(Ci.nsIScriptableInputStream);
      fstream.init(file, -1, 0, 0);
      sstream.init(fstream); 

      var str = sstream.read(4096);
      while (str.length > 0) {
          data += str;
          str = sstream.read(4096);
      }

      sstream.close();
      fstream.close();
      try {
          var ret = JSON.parse(data);
      } catch(e) { // file has been corrupted; XXX: handle error differently
          this.logger.log(5, "Cookies corrupted: "+e);
          try {
              file.remove(false); //XXX: is it necessary to remove it ?
              var ret = null;
          } catch(e2) {
              this.logger.log(5, "Can't remove file "+e);
          }
      }
      return ret;
  };

  this.protectCookies = function(cookies) {
    var name = "tor";
    this._writeProtectCookies(cookies,name);
    if (!this.prefs.getBoolPref("extensions.torbutton.block_disk")) {
      // save protected cookies to file
      this._protectedCookiesToFile(name);
    } else {
      try {
        var file = getProfileFile("protected-" + name + ".json");
        if (file.exists()) {
          file.remove(false);
        }
      } catch(e) {
        this.logger.log(5, "Can't remove "+name+" cookie file: "+e);
      }
    }
  };

  this._writeProtectCookies = function(cookies, name) {
    for (var i = 0; i < cookies.length; i++) {
        if (cookies[i].isSession) {
            // session cookies get fucked up expiry. Give it 1yr if
            // the user wants to save their session cookies
            cookies[i].expires = Date.now()/1000 + 365*24*60*60;
        }
        cookies[i].isProtected = true;
    }
    this["protected-" + name] = cookies;
  };
  // End1506

  this._cookiesFromFile = function(name) {
      var file = getProfileFile("cookies-" + name + ".json");
      if (!file.exists())
          return null;
      var data = "";
      var fstream = Cc["@mozilla.org/network/file-input-stream;1"]
          .createInstance(Ci.nsIFileInputStream);
      var sstream = Cc["@mozilla.org/scriptableinputstream;1"]
          .createInstance(Ci.nsIScriptableInputStream);
      fstream.init(file, -1, 0, 0);
      sstream.init(fstream); 

      var str = sstream.read(4096);
      while (str.length > 0) {
          data += str;
          str = sstream.read(4096);
      }

      sstream.close();
      fstream.close();
      try {
          var ret = JSON.parse(data);
      } catch(e) { // file has been corrupted; XXX: handle error differently
          this.logger.log(5, "Cookies corrupted: "+e);
          try {
              file.remove(false); //XXX: is it necessary to remove it ?
              var ret = null;
          } catch(e2) {
              this.logger.log(5, "Can't remove file "+e);
          }
      }
      return ret;
  };

  this.saveCookies = function(name) {
    // transition removes old tor-style cookie file
    try {
        var oldCookieFile = getProfileFile("cookies-"+name+".xml");
        if (oldCookieFile.exists()) {
            oldCookieFile.remove(false);
        }
    } catch(e) {
        this.logger.log(5, "Can't remove old "+name+" file "+e);
    }

    // save cookies to JS objects
    this["session-cookiesobj-" + name] = this._cookiesToJS(true);
    this["cookiesobj-" + name] = this._cookiesToJS(false);

    if (!this.prefs.getBoolPref("extensions.torbutton.block_disk")) {
        // save cookies to file
        this._cookiesToFile(name);
    } else {
        // Clear the old file
        try {
            var file = getProfileFile("cookies-" + name + ".json");
            if (file.exists()) {
                file.remove(false);
            }
        } catch(e) {
            this.logger.log(5, "Can't remove "+name+" cookie file "+e);
        }
    }

    // ok, everything's fine
    this.logger.log(2, "Cookies saved");
  };

  // Start1506
  this.clearUnprotectedCookies = function(name) {
    try {
      var protCookies = this.getProtectedCookies(name);
      if (protCookies == null || typeof(protCookies) == "undefined"
              || protCookies.length == 0) {
        //file does not exist - no protected cookies. Clear them all.
        this.logger.log(3, "No protected cookies. Clearing all cookies.");
        this.clearCookies();
        return;
      }
      var cookiemanager =
        Cc["@mozilla.org/cookiemanager;1"]
        .getService(Ci.nsICookieManager2);

      var enumerator = cookiemanager.enumerator;
      var count = 0;
      var protcookie = false;

      while (enumerator.hasMoreElements()) {
        var nextCookie = enumerator.getNext();
        if (!nextCookie) break;

        nextCookie = nextCookie.QueryInterface(Components.interfaces.nsICookie);
        for (var i = 0; i < protCookies.length; i++) {
          protcookie = protcookie || (nextCookie.host == protCookies[i].host &&
                                      nextCookie.name == protCookies[i].name &&
                                      nextCookie.path == protCookies[i].path);
        }

        if (!protcookie) {
          cookiemanager.remove(nextCookie.host,
                             nextCookie.name,
                             nextCookie.path, false);
        } else {
          this.logger.log(3, "Found protected cookie for "+nextCookie.host);
        }
        protcookie = false;
      }
      // Emit cookie-changed event. This instructs other components to clear their identifiers
      // (Specifically DOM storage and safe browsing, but possibly others)
      var obsSvc = Components.classes["@mozilla.org/observer-service;1"].getService(nsIObserverService);
      obsSvc.notifyObservers(this, "cookie-changed", "cleared");
    } catch (e) {
      this.logger.log(5, "Error deleting unprotected cookies: " + e);
    }
  };
  // End1506

  this.loadCookies = function(name, deleteSavedCookieJar) {
    // remove cookies before loading old ones
    this.clearCookies();

    if (!this.prefs.getBoolPref("extensions.torbutton.block_disk")) {
        // load cookies from file
        this["cookiesobj-" + name] = this._cookiesFromFile(name);
    }

    //delete file if needed
    if (deleteSavedCookieJar) { 
        try {
            var file = getProfileFile("cookies-" + name + ".json");
            if (file.exists())
                file.remove(false);
        } catch(e) {
            this.logger.log(5, "Can't remove saved "+name+" file "+e);
        }
    }

    // load cookies from JS objects
    this._loadCookiesFromJS(this["cookiesobj-"+name]);
    this._loadCookiesFromJS(this["session-cookiesobj-"+name]);

    // XXX: send a profile-do-change event?

    // ok, everything's fine
    this.logger.log(2, "Cookies reloaded");
  };

  // Check firefox version to know filename
  var appInfo = Components.classes["@mozilla.org/xre/app-info;1"]
      .getService(Components.interfaces.nsIXULAppInfo);
  var versionChecker = Components.classes["@mozilla.org/xpcom/version-comparator;1"]
      .getService(Components.interfaces.nsIVersionComparator);

  // This JSObject is exported directly to chrome
  this.wrappedJSObject = this;

  // This timer is done so that in the event of a crash, we at least
  // have recent cookies in a jar to reload from.
  var jarThis = this;
  this.timerCallback = {
    cookie_changed: false,

    QueryInterface: function(iid) {
       if (!iid.equals(Component.interfaces.nsISupports) &&
           !iid.equals(Component.interfaces.nsITimer)) {
         Components.returnCode = Cr.NS_ERROR_NO_INTERFACE;
         return null;
       }
       return this;
    },
    notify: function() {
       // this refers to timerCallback object. use jarThis to reference
       // CookieJarSelector object.
       if(!this.cookie_changed) {
           jarThis.logger.log(2, "Got timer update, but no cookie change.");
           return;
       }
       jarThis.logger.log(3, "Got timer update. Saving changed cookies to jar.");

       this.cookie_changed = false;

       jarThis.saveCookies("tor");
       jarThis.logger.log(2, "Timer done. Cookies saved");
    }
  };

}

const nsISupports = Components.interfaces.nsISupports;
const nsIClassInfo = Components.interfaces.nsIClassInfo;
const nsIObserver = Components.interfaces.nsIObserver;
const nsITimer = Components.interfaces.nsITimer;
const nsIComponentRegistrar = Components.interfaces.nsIComponentRegistrar;
const nsIObserverService = Components.interfaces.nsIObserverService;
const nsICategoryManager = Components.interfaces.nsICategoryManager;

// Start1506: You may or may not care about this:
CookieJarSelector.prototype =
{
  QueryInterface: function(iid)
  {
    if (!iid.equals(nsIClassInfo) &&
        !iid.equals(nsIObserver) &&
        !iid.equals(nsISupports)) {
      Components.returnCode = Cr.NS_ERROR_NO_INTERFACE;
      return null;
    }
    return this;
  },

  wrappedJSObject: null,  // Initialized by constructor

  // make this an nsIClassInfo object
  flags: nsIClassInfo.DOM_OBJECT,

  _xpcom_categories: [{category:"profile-after-change"}],
  classID: kMODULE_CID,
  contractID: kMODULE_CONTRACTID,
  classDescription: "CookieJarSelector",

  // method of nsIClassInfo
  getInterfaces: function(count) {
    var interfaceList = [nsIClassInfo];
    count.value = interfaceList.length;
    return interfaceList;
  },

  // method of nsIClassInfo
  getHelperForLanguage: function(count) { return null; },

  // method of nsIObserver
  observe : function(aSubject, aTopic, aData) {
       switch(aTopic) { 
        case "cookie-changed":
            var prefs = Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefBranch);          
            this.timerCallback.cookie_changed = true;
    
            if (aData == "added"
                && prefs.getBoolPref("extensions.torbutton.cookie_auto_protect")
                && !prefs.getBoolPref("extensions.torbutton.tor_memory_jar"))
            {
              this.addProtectedCookie(aSubject.QueryInterface(Components.interfaces.nsICookie2));//protect the new cookie!    
            }
            break;
        case "profile-after-change":
            var obsSvc = Components.classes["@mozilla.org/observer-service;1"].getService(nsIObserverService);
            obsSvc.addObserver(this, "cookie-changed", false);
            // after profil loading, initialize a timer to call timerCallback
            // at a specified interval
            this.timer.initWithCallback(this.timerCallback, 60 * 1000, nsITimer.TYPE_REPEATING_SLACK); // 1 minute
            this.logger.log(3, "Cookie jar selector got profile-after-change");
            break;
       }
  },

  timer:  Components.classes["@mozilla.org/timer;1"].createInstance(nsITimer),

}

/**
* XPCOMUtils.generateNSGetFactory was introduced in Mozilla 2 (Firefox 4).
* XPCOMUtils.generateNSGetModule is for Mozilla 1.9.2 (Firefox 3.6).
*/
Components.utils.import("resource://gre/modules/XPCOMUtils.jsm");
if (XPCOMUtils.generateNSGetFactory)
    var NSGetFactory = XPCOMUtils.generateNSGetFactory([CookieJarSelector]);
else
    var NSGetModule = XPCOMUtils.generateNSGetModule([CookieJarSelector]);

// End1506
