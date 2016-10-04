// Bug 1506 P1: This is just a handy logger. If you have a better one, toss
// this in the trash.

/*************************************************************************
 * TBLogger (JavaScript XPCOM component)
 *
 * Allows loglevel-based logging to different logging mechanisms.
 *
 *************************************************************************/

// Module specific constants
const kMODULE_NAME = "Torbutton Logger";
const kMODULE_CONTRACTID = "@torproject.org/torbutton-logger;1";
const kMODULE_CID = Components.ID("f36d72c9-9718-4134-b550-e109638331d7");

const Cr = Components.results;
const Cc = Components.classes;
const Ci = Components.interfaces;

function TorbuttonLogger() {
    this.prefs = Components.classes["@mozilla.org/preferences-service;1"]
        .getService(Components.interfaces.nsIPrefBranch);

    // Register observer
    var pref_service = Components.classes["@mozilla.org/preferences-service;1"]
        .getService(Components.interfaces.nsIPrefBranchInternal);
    this._branch = pref_service.QueryInterface(Components.interfaces.nsIPrefBranchInternal);
    this._branch.addObserver("extensions.torbutton", this, false);

    this.loglevel = this.prefs.getIntPref("extensions.torbutton.loglevel");
    this.logmethod = this.prefs.getIntPref("extensions.torbutton.logmethod");

    try {
        var logMngr = Components.classes["@mozmonkey.com/debuglogger/manager;1"]
            .getService(Components.interfaces.nsIDebugLoggerManager); 
        this._debuglog = logMngr.registerLogger("torbutton");
    } catch (exErr) {
        this._debuglog = false;
    }
    this._console = Components.classes["@mozilla.org/consoleservice;1"]
        .getService(Components.interfaces.nsIConsoleService);

    // This JSObject is exported directly to chrome
    this.wrappedJSObject = this;
    this.log(3, "Torbutton debug output ready");
}

/**
 * JS XPCOM component registration goop:
 *
 * Everything below is boring boilerplate and can probably be ignored.
 */

const nsISupports = Components.interfaces.nsISupports;
const nsIClassInfo = Components.interfaces.nsIClassInfo;
const nsIComponentRegistrar = Components.interfaces.nsIComponentRegistrar;
const nsIObserverService = Components.interfaces.nsIObserverService;

const logString = { 1:"VERB", 2:"DBUG", 3: "INFO", 4:"NOTE", 5:"WARN" };

function padInt(i)
{
    return (i < 10) ? '0' + i : i;
}

TorbuttonLogger.prototype =
{
  QueryInterface: function(iid)
  {
    if (!iid.equals(nsIClassInfo) &&
        !iid.equals(nsISupports)) {
      Components.returnCode = Cr.NS_ERROR_NO_INTERFACE;
      return null;
    }
    return this;
  },

  wrappedJSObject: null,  // Initialized by constructor

  // make this an nsIClassInfo object
  flags: nsIClassInfo.DOM_OBJECT,

  // method of nsIClassInfo
  classDescription: "TorbuttonLogger",
  classID: kMODULE_CID,
  contractID: kMODULE_CONTRACTID,

  // method of nsIClassInfo
  getInterfaces: function(count) {
    var interfaceList = [nsIClassInfo];
    count.value = interfaceList.length;
    return interfaceList;
  },

  // method of nsIClassInfo
  getHelperForLanguage: function(count) { return null; },

  formatLog: function(str, level) {
      var d = new Date();
      var now = padInt(d.getUTCMonth()+1)+"-"+padInt(d.getUTCDate())+" "+padInt(d.getUTCHours())+":"+padInt(d.getUTCMinutes())+":"+padInt(d.getUTCSeconds());
      return "["+now+"] Torbutton "+logString[level]+": "+str;
  },

  // error console log
  eclog: function(level, str) {
      switch(this.logmethod) {
          case 0: // stderr
              if(this.loglevel <= level)
                  dump(this.formatLog(str, level)+"\n");
              break;
          default: // errorconsole
              if(this.loglevel <= level)
                  this._console.logStringMessage(this.formatLog(str,level));
              break;
      }
  },

  safe_log: function(level, str, scrub) {
      if (this.loglevel < 4) {
          this.eclog(level, str+scrub);
      } else {
          this.eclog(level, str+" [scrubbed]");
      }
  },

  log: function(level, str) {
      switch(this.logmethod) {
          case 2: // debuglogger
              if(this._debuglog) {
                  this._debuglog.log((6-level), this.formatLog(str,level));
                  break;
              }
              // fallthrough
          case 0: // stderr
              if(this.loglevel <= level) 
                  dump(this.formatLog(str,level)+"\n");
              break;
          default:
              dump("Bad log method: "+this.logmethod);
          case 1: // errorconsole
              if(this.loglevel <= level)
                  this._console.logStringMessage(this.formatLog(str,level));
              break;
      }
  },

  // Pref observer interface implementation

  // topic:   what event occurred
  // subject: what nsIPrefBranch we're observing
  // data:    which pref has been changed (relative to subject)
  observe: function(subject, topic, data)
  {
      if (topic != "nsPref:changed") return;
      switch (data) {
          case "extensions.torbutton.logmethod":
              this.logmethod = this.prefs.getIntPref("extensions.torbutton.logmethod");
              break;
          case "extensions.torbutton.loglevel":
              this.loglevel = this.prefs.getIntPref("extensions.torbutton.loglevel");
              break;
      }
  }
}

/**
* XPCOMUtils.generateNSGetFactory was introduced in Mozilla 2 (Firefox 4).
* XPCOMUtils.generateNSGetModule is for Mozilla 1.9.2 (Firefox 3.6).
*/
Components.utils.import("resource://gre/modules/XPCOMUtils.jsm");
if (XPCOMUtils.generateNSGetFactory)
    var NSGetFactory = XPCOMUtils.generateNSGetFactory([TorbuttonLogger]);
else
    var NSGetModule = XPCOMUtils.generateNSGetModule([TorbuttonLogger]);
