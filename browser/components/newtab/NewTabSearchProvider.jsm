"use strict";

this.EXPORTED_SYMBOLS = ["NewTabSearchProvider"];

const {utils: Cu, interfaces: Ci} = Components;
const CURRENT_ENGINE = "browser-search-engine-modified";

Cu.import("resource://gre/modules/XPCOMUtils.jsm");
Cu.import("resource://gre/modules/Services.jsm");

XPCOMUtils.defineLazyModuleGetter(this, "ContentSearch",
                                  "resource:///modules/ContentSearch.jsm");

XPCOMUtils.defineLazyGetter(this, "EventEmitter", function() {
  const {EventEmitter} = Cu.import("resource://gre/modules/EventEmitter.jsm", {});
  return EventEmitter;
});

function SearchProvider() {
  EventEmitter.decorate(this);
}

SearchProvider.prototype = {

  observe(subject, topic, data) { // jshint unused:false
    // all other topics are not relevant to content searches and can be
    // ignored by NewTabSearchProvider
    if (data === "engine-current" && topic === CURRENT_ENGINE) {
      (async () => {
        try {
          let state = await ContentSearch.currentStateObj(true);
          let engine = state.currentEngine;
          this.emit(CURRENT_ENGINE, engine);
        } catch (e) {
          Cu.reportError(e);
        }
      })();
    }
  },

  init() {
    try {
      Services.obs.addObserver(this, CURRENT_ENGINE, true);
    } catch (e) {
      Cu.reportError(e);
    }
  },

  QueryInterface: XPCOMUtils.generateQI([Ci.nsIObserver,
    Ci.nsISupportsWeakReference
  ]),

  uninit() {
    try {
      Services.obs.removeObserver(this, CURRENT_ENGINE);
    } catch (e) {
      Cu.reportError(e);
    }
  },

  get searchSuggestionUIStrings() {
    return ContentSearch.searchSuggestionUIStrings;
  },

  removeFormHistory({browser}, suggestion) {
    ContentSearch.removeFormHistoryEntry({target: browser}, suggestion);
  },

  manageEngines(browser) {
    const browserWin = browser.ownerGlobal;
    if (Services.prefs.getBoolPref("browser.preferences.useOldOrganization")) {
      browserWin.openPreferences("paneSearch", { origin: "contentSearch" });
    } else {
      browserWin.openPreferences("paneGeneral", { origin: "contentSearch" });
    }
  },

  async asyncGetState() {
    let state = await ContentSearch.currentStateObj(true);
    return state;
  },

  async asyncPerformSearch({browser}, searchData) {
    ContentSearch.performSearch({target: browser}, searchData);
    await ContentSearch.addFormHistoryEntry({target: browser}, searchData.searchString);
  },

  async asyncCycleEngine(engineName) {
    Services.search.currentEngine = Services.search.getEngineByName(engineName);
    let state = await ContentSearch.currentStateObj(true);
    let newEngine = state.currentEngine;
    this.emit(CURRENT_ENGINE, newEngine);
  },

  async asyncGetSuggestions(engineName, searchString, target) {
    let suggestions = ContentSearch.getSuggestions(engineName, searchString, target.browser);
    return suggestions;
  },
};

const NewTabSearchProvider = {
  search: new SearchProvider(),
};
