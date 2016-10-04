// Bug 1506 Android P1/TBB P5: This code provides users with notification
// in the event of external app launch. We want it to exist in the desktop
// port, but it is probably useless for Android.

/*************************************************************************
 * External App Handler.
 * Handles displaying confirmation dialogs for external apps and protocols
 * due to Firefox Bug https://bugzilla.mozilla.org/show_bug.cgi?id=440892
 *
 * Also implements an observer that filters drag events to prevent OS
 * access to URLs (a potential proxy bypass vector).
 *************************************************************************/

const Cc = Components.classes;
const Ci = Components.interfaces;
const Cu = Components.utils;

Cu.import("resource://gre/modules/XPCOMUtils.jsm");

// Module specific constants
const kMODULE_NAME = "Torbutton External App Handler";
const kCONTRACT_ID = "@torproject.org/torbutton-extAppBlockerService;1";
const kMODULE_CID = Components.ID("3da0269f-fc29-4e9e-a678-c3b1cafcf13f");

const kInterfaces = [Ci.nsIObserver, Ci.nsIClassInfo];

function ExternalAppBlocker() {
  this.logger = Cc["@torproject.org/torbutton-logger;1"]
      .getService(Ci.nsISupports).wrappedJSObject;
  this.logger.log(3, "Component Load 0: New ExternalAppBlocker.");

  this._prefs = Cc["@mozilla.org/preferences-service;1"]
      .getService(Ci.nsIPrefBranch);

  try {
    var observerService = Cc["@mozilla.org/observer-service;1"].
        getService(Ci.nsIObserverService);
    observerService.addObserver(this, "external-app-requested", false);
    observerService.addObserver(this, "on-datatransfer-available", false);
  } catch(e) {
    this.logger.log(5, "Failed to register external app observer or drag observer");
  }
}

ExternalAppBlocker.prototype =
{
  QueryInterface: XPCOMUtils.generateQI([Ci.nsISupports, Ci.nsIObserver]),

  // make this an nsIClassInfo object
  flags: Ci.nsIClassInfo.DOM_OBJECT,
  classDescription: kMODULE_NAME,
  contractID: kCONTRACT_ID,
  classID: kMODULE_CID,

  // method of nsIClassInfo
  getInterfaces: function(count) {
    count.value = kInterfaces.length;
    return kInterfaces;
  },

  // method of nsIClassInfo  
  getHelperForLanguage: function(count) { return null; },

  // Returns true if launch should proceed.
  _confirmLaunch: function() {
    if (!this._prefs.getBoolPref("extensions.torbutton.launch_warning")) {
      return true;
    }

    var wm = Cc["@mozilla.org/appshell/window-mediator;1"]
               .getService(Ci.nsIWindowMediator);
    var chrome = wm.getMostRecentWindow("navigator:browser");

    var prompts = Cc["@mozilla.org/embedcomp/prompt-service;1"]
                            .getService(Ci.nsIPromptService);
    var flags = prompts.BUTTON_POS_0 * prompts.BUTTON_TITLE_IS_STRING +
                prompts.BUTTON_POS_1 * prompts.BUTTON_TITLE_IS_STRING +
                prompts.BUTTON_DELAY_ENABLE +
                prompts.BUTTON_POS_1_DEFAULT;

    var title = chrome.torbutton_get_property_string("torbutton.popup.external.title");
    var app = chrome.torbutton_get_property_string("torbutton.popup.external.app");
    var note = chrome.torbutton_get_property_string("torbutton.popup.external.note");
    var suggest = chrome.torbutton_get_property_string("torbutton.popup.external.suggest");
    var launch = chrome.torbutton_get_property_string("torbutton.popup.launch");
    var cancel = chrome.torbutton_get_property_string("torbutton.popup.cancel");
    var dontask = chrome.torbutton_get_property_string("torbutton.popup.dontask");

    var check = {value: false};
    var result = prompts.confirmEx(chrome, title, app+note+suggest+" ",
                                   flags, launch, cancel, "", dontask, check);

    if (check.value) {
      this._prefs.setBoolPref("extensions.torbutton.launch_warning", false);
    }

    return (0 == result);
  },
  
  observe: function(subject, topic, data) {
    if (topic == "external-app-requested") {
      this.logger.log(3, "External app requested");
      // subject.data is true if the launch should be canceled.
      if ((subject instanceof Ci.nsISupportsPRBool)
          && !subject.data /* not canceled already */
          && !this._confirmLaunch()) {
        subject.data = true; // The user said to cancel the launch.
      }
    } else if (topic == "on-datatransfer-available") {
      this.logger.log(3, "The DataTransfer is available");
      return this.filterDataTransferURLs(subject);
    }
  },

  filterDataTransferURLs: function(aDataTransfer) {
    var types = null;
    var type = "";
    var count = aDataTransfer.mozItemCount;
    var len = 0;
    for (var i = 0; i < count; ++i) {
      this.logger.log(3, "Inspecting the data transfer: " + i);
      types = aDataTransfer.mozTypesAt(i);
      len = types.length;
      for (var j = 0; j < len; ++j) {
        type = types[j];
        this.logger.log(3, "Type is: " + type);
        if (type == "text/x-moz-url" ||
            type == "text/x-moz-url-data" ||
            type == "text/uri-list" ||
            type == "application/x-moz-file-promise-url") {
          aDataTransfer.clearData(type);
          this.logger.log(3, "Removing " + type);
        }
      }
    }
  }

};

var NSGetFactory = XPCOMUtils.generateNSGetFactory([ExternalAppBlocker]);
