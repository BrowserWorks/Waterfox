"use strict";

this.EXPORTED_SYMBOLS = ["NewTabPrefsProvider"];

const {interfaces: Ci, utils: Cu} = Components;
Cu.import("resource://gre/modules/Services.jsm");
Cu.import("resource://gre/modules/XPCOMUtils.jsm");

XPCOMUtils.defineLazyGetter(this, "EventEmitter", function() {
  const {EventEmitter} = Cu.import("resource://gre/modules/EventEmitter.jsm", {});
  return EventEmitter;
});

// Supported prefs and data type
const gPrefsMap = new Map([
  ["browser.newtabpage.activity-stream.enabled", "bool"],
  ["browser.newtabpage.enabled", "bool"],
  ["browser.newtabpage.enhanced", "bool"],
  ["browser.newtabpage.introShown", "bool"],
  ["browser.newtabpage.updateIntroShown", "bool"],
  ["browser.newtabpage.pinned", "str"],
  ["browser.newtabpage.blocked", "str"],
  ["browser.search.hiddenOneOffs", "str"],
]);

// prefs that are important for the newtab page
const gNewtabPagePrefs = new Set([
  "browser.newtabpage.enabled",
  "browser.newtabpage.enhanced",
  "browser.newtabpage.pinned",
  "browser.newtabpage.blocked",
  "browser.newtabpage.introShown",
  "browser.newtabpage.updateIntroShown",
  "browser.search.hiddenOneOffs",
]);

let PrefsProvider = function PrefsProvider() {
  EventEmitter.decorate(this);
};

PrefsProvider.prototype = {

  observe(subject, topic, data) { // jshint ignore:line
    if (topic === "nsPref:changed") {
      if (gPrefsMap.has(data)) {
        switch (gPrefsMap.get(data)) {
          case "bool":
            this.emit(data, Services.prefs.getBoolPref(data, false));
            break;
          case "str":
            this.emit(data, Services.prefs.getStringPref(data, ""));
            break;
          case "localized":
            if (Services.prefs.getPrefType(data) == Ci.nsIPrefBranch.PREF_INVALID) {
              this.emit(data, "");
            } else {
              try {
                this.emit(data, Services.prefs.getComplexValue(data, Ci.nsIPrefLocalizedString));
              } catch (e) {
                this.emit(data, Services.prefs.getStringPref(data));
              }
            }
            break;
          default:
            this.emit(data);
            break;
        }
      }
    } else {
      Cu.reportError(new Error("NewTabPrefsProvider observing unknown topic"));
    }
  },

  /*
   * Return the preferences that are important to the newtab page
   */
  get newtabPagePrefs() {
    let results = {};
    for (let pref of gNewtabPagePrefs) {
      results[pref] = null;

      if (Services.prefs.getPrefType(pref) != Ci.nsIPrefBranch.PREF_INVALID) {
        switch (gPrefsMap.get(pref)) {
          case "bool":
            results[pref] = Services.prefs.getBoolPref(pref);
            break;
          case "str":
            results[pref] = Services.prefs.getStringPref(pref);
            break;
          case "localized":
            try {
              results[pref] = Services.prefs.getComplexValue(pref, Ci.nsIPrefLocalizedString);
            } catch (e) {
              results[pref] = Services.prefs.getStringPref(pref);
            }
            break;
        }
      }
    }
    return results;
  },

  get prefsMap() {
    return gPrefsMap;
  },

  init() {
    for (let pref of gPrefsMap.keys()) {
      Services.prefs.addObserver(pref, this);
    }
  },

  uninit() {
    for (let pref of gPrefsMap.keys()) {
      Services.prefs.removeObserver(pref, this);
    }
  }
};

/**
 * Singleton that serves as the default new tab pref provider for the grid.
 */
const gPrefs = new PrefsProvider();

let NewTabPrefsProvider = {
  prefs: gPrefs,
  newtabPagePrefSet: gNewtabPagePrefs,
};
