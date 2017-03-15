/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

this.EXPORTED_SYMBOLS = ["SessionStore"];

const Cu = Components.utils;
const Cc = Components.classes;
const Ci = Components.interfaces;
const Cr = Components.results;

// Current version of the format used by Session Restore.
const FORMAT_VERSION = 1;

const TAB_STATE_NEEDS_RESTORE = 1;
const TAB_STATE_RESTORING = 2;
const TAB_STATE_WILL_RESTORE = 3;

// A new window has just been restored. At this stage, tabs are generally
// not restored.
const NOTIFY_SINGLE_WINDOW_RESTORED = "sessionstore-single-window-restored";
const NOTIFY_WINDOWS_RESTORED = "sessionstore-windows-restored";
const NOTIFY_BROWSER_STATE_RESTORED = "sessionstore-browser-state-restored";
const NOTIFY_LAST_SESSION_CLEARED = "sessionstore-last-session-cleared";
const NOTIFY_RESTORING_ON_STARTUP = "sessionstore-restoring-on-startup";
const NOTIFY_INITIATING_MANUAL_RESTORE = "sessionstore-initiating-manual-restore";

const NOTIFY_TAB_RESTORED = "sessionstore-debug-tab-restored"; // WARNING: debug-only

// Maximum number of tabs to restore simultaneously. Previously controlled by
// the browser.sessionstore.max_concurrent_tabs pref.
const MAX_CONCURRENT_TAB_RESTORES = 3;

// Amount (in CSS px) by which we allow window edges to be off-screen
// when restoring a window, before we override the saved position to
// pull the window back within the available screen area.
const SCREEN_EDGE_SLOP = 8;

// global notifications observed
const OBSERVING = [
  "browser-window-before-show", "domwindowclosed",
  "quit-application-granted", "browser-lastwindow-close-granted",
  "quit-application", "browser:purge-session-history",
  "browser:purge-domain-data",
  "idle-daily",
];

// XUL Window properties to (re)store
// Restored in restoreDimensions()
const WINDOW_ATTRIBUTES = ["width", "height", "screenX", "screenY", "sizemode"];

// Hideable window features to (re)store
// Restored in restoreWindowFeatures()
const WINDOW_HIDEABLE_FEATURES = [
  "menubar", "toolbar", "locationbar", "personalbar", "statusbar", "scrollbars"
];

// Messages that will be received via the Frame Message Manager.
const MESSAGES = [
  // The content script sends us data that has been invalidated and needs to
  // be saved to disk.
  "SessionStore:update",

  // The restoreHistory code has run. This is a good time to run SSTabRestoring.
  "SessionStore:restoreHistoryComplete",

  // The load for the restoring tab has begun. We update the URL bar at this
  // time; if we did it before, the load would overwrite it.
  "SessionStore:restoreTabContentStarted",

  // All network loads for a restoring tab are done, so we should
  // consider restoring another tab in the queue. The document has
  // been restored, and forms have been filled. We trigger
  // SSTabRestored at this time.
  "SessionStore:restoreTabContentComplete",

  // A crashed tab was revived by navigating to a different page. Remove its
  // browser from the list of crashed browsers to stop ignoring its messages.
  "SessionStore:crashedTabRevived",

  // The content script encountered an error.
  "SessionStore:error",
];

// The list of messages we accept from <xul:browser>s that have no tab
// assigned, or whose windows have gone away. Those are for example the
// ones that preload about:newtab pages, or from browsers where the window
// has just been closed.
const NOTAB_MESSAGES = new Set([
  // For a description see above.
  "SessionStore:crashedTabRevived",

  // For a description see above.
  "SessionStore:update",

  // For a description see above.
  "SessionStore:error",
]);

// The list of messages we accept without an "epoch" parameter.
// See getCurrentEpoch() and friends to find out what an "epoch" is.
const NOEPOCH_MESSAGES = new Set([
  // For a description see above.
  "SessionStore:crashedTabRevived",

  // For a description see above.
  "SessionStore:error",
]);

// The list of messages we want to receive even during the short period after a
// frame has been removed from the DOM and before its frame script has finished
// unloading.
const CLOSED_MESSAGES = new Set([
  // For a description see above.
  "SessionStore:crashedTabRevived",

  // For a description see above.
  "SessionStore:update",

  // For a description see above.
  "SessionStore:error",
]);

// These are tab events that we listen to.
const TAB_EVENTS = [
  "TabOpen", "TabBrowserInserted", "TabClose", "TabSelect", "TabShow", "TabHide", "TabPinned",
  "TabUnpinned"
];

const NS_XUL = "http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul";

Cu.import("resource://gre/modules/PrivateBrowsingUtils.jsm", this);
Cu.import("resource://gre/modules/Promise.jsm", this);
Cu.import("resource://gre/modules/Services.jsm", this);
Cu.import("resource://gre/modules/Task.jsm", this);
Cu.import("resource://gre/modules/TelemetryStopwatch.jsm", this);
Cu.import("resource://gre/modules/TelemetryTimestamps.jsm", this);
Cu.import("resource://gre/modules/Timer.jsm", this);
Cu.import("resource://gre/modules/XPCOMUtils.jsm", this);
Cu.import("resource://gre/modules/debug.js", this);
Cu.import("resource://gre/modules/osfile.jsm", this);

XPCOMUtils.defineLazyServiceGetter(this, "gSessionStartup",
  "@mozilla.org/browser/sessionstartup;1", "nsISessionStartup");
XPCOMUtils.defineLazyServiceGetter(this, "gScreenManager",
  "@mozilla.org/gfx/screenmanager;1", "nsIScreenManager");
XPCOMUtils.defineLazyServiceGetter(this, "Telemetry",
  "@mozilla.org/base/telemetry;1", "nsITelemetry");
XPCOMUtils.defineLazyModuleGetter(this, "console",
  "resource://gre/modules/Console.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "RecentWindow",
  "resource:///modules/RecentWindow.jsm");

XPCOMUtils.defineLazyModuleGetter(this, "AppConstants",
  "resource://gre/modules/AppConstants.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "GlobalState",
  "resource:///modules/sessionstore/GlobalState.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "PrivacyFilter",
  "resource:///modules/sessionstore/PrivacyFilter.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "RunState",
  "resource:///modules/sessionstore/RunState.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "ScratchpadManager",
  "resource://devtools/client/scratchpad/scratchpad-manager.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "SessionSaver",
  "resource:///modules/sessionstore/SessionSaver.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "SessionCookies",
  "resource:///modules/sessionstore/SessionCookies.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "SessionFile",
  "resource:///modules/sessionstore/SessionFile.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "TabAttributes",
  "resource:///modules/sessionstore/TabAttributes.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "TabCrashHandler",
  "resource:///modules/ContentCrashHandlers.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "TabState",
  "resource:///modules/sessionstore/TabState.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "TabStateCache",
  "resource:///modules/sessionstore/TabStateCache.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "TabStateFlusher",
  "resource:///modules/sessionstore/TabStateFlusher.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "Utils",
  "resource://gre/modules/sessionstore/Utils.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "ViewSourceBrowser",
  "resource://gre/modules/ViewSourceBrowser.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "AsyncShutdown",
  "resource://gre/modules/AsyncShutdown.jsm");

/**
 * |true| if we are in debug mode, |false| otherwise.
 * Debug mode is controlled by preference browser.sessionstore.debug
 */
var gDebuggingEnabled = false;
function debug(aMsg) {
  if (gDebuggingEnabled) {
    aMsg = ("SessionStore: " + aMsg).replace(/\S{80}/g, "$&\n");
    Services.console.logStringMessage(aMsg);
  }
}

this.SessionStore = {
  get promiseInitialized() {
    return SessionStoreInternal.promiseInitialized;
  },

  get canRestoreLastSession() {
    return SessionStoreInternal.canRestoreLastSession;
  },

  set canRestoreLastSession(val) {
    SessionStoreInternal.canRestoreLastSession = val;
  },

  get lastClosedObjectType() {
    return SessionStoreInternal.lastClosedObjectType;
  },

  init: function ss_init() {
    SessionStoreInternal.init();
  },

  getBrowserState: function ss_getBrowserState() {
    return SessionStoreInternal.getBrowserState();
  },

  setBrowserState: function ss_setBrowserState(aState) {
    SessionStoreInternal.setBrowserState(aState);
  },

  getWindowState: function ss_getWindowState(aWindow) {
    return SessionStoreInternal.getWindowState(aWindow);
  },

  setWindowState: function ss_setWindowState(aWindow, aState, aOverwrite) {
    SessionStoreInternal.setWindowState(aWindow, aState, aOverwrite);
  },

  getTabState: function ss_getTabState(aTab) {
    return SessionStoreInternal.getTabState(aTab);
  },

  setTabState: function ss_setTabState(aTab, aState) {
    SessionStoreInternal.setTabState(aTab, aState);
  },

  duplicateTab: function ss_duplicateTab(aWindow, aTab, aDelta = 0) {
    return SessionStoreInternal.duplicateTab(aWindow, aTab, aDelta);
  },

  getClosedTabCount: function ss_getClosedTabCount(aWindow) {
    return SessionStoreInternal.getClosedTabCount(aWindow);
  },

  getClosedTabData: function ss_getClosedTabData(aWindow, aAsString = true) {
    return SessionStoreInternal.getClosedTabData(aWindow, aAsString);
  },

  undoCloseTab: function ss_undoCloseTab(aWindow, aIndex) {
    return SessionStoreInternal.undoCloseTab(aWindow, aIndex);
  },

  forgetClosedTab: function ss_forgetClosedTab(aWindow, aIndex) {
    return SessionStoreInternal.forgetClosedTab(aWindow, aIndex);
  },

  getClosedWindowCount: function ss_getClosedWindowCount() {
    return SessionStoreInternal.getClosedWindowCount();
  },

  getClosedWindowData: function ss_getClosedWindowData(aAsString = true) {
    return SessionStoreInternal.getClosedWindowData(aAsString);
  },

  undoCloseWindow: function ss_undoCloseWindow(aIndex) {
    return SessionStoreInternal.undoCloseWindow(aIndex);
  },

  forgetClosedWindow: function ss_forgetClosedWindow(aIndex) {
    return SessionStoreInternal.forgetClosedWindow(aIndex);
  },

  getWindowValue: function ss_getWindowValue(aWindow, aKey) {
    return SessionStoreInternal.getWindowValue(aWindow, aKey);
  },

  setWindowValue: function ss_setWindowValue(aWindow, aKey, aStringValue) {
    SessionStoreInternal.setWindowValue(aWindow, aKey, aStringValue);
  },

  deleteWindowValue: function ss_deleteWindowValue(aWindow, aKey) {
    SessionStoreInternal.deleteWindowValue(aWindow, aKey);
  },

  getTabValue: function ss_getTabValue(aTab, aKey) {
    return SessionStoreInternal.getTabValue(aTab, aKey);
  },

  setTabValue: function ss_setTabValue(aTab, aKey, aStringValue) {
    SessionStoreInternal.setTabValue(aTab, aKey, aStringValue);
  },

  deleteTabValue: function ss_deleteTabValue(aTab, aKey) {
    SessionStoreInternal.deleteTabValue(aTab, aKey);
  },

  getGlobalValue: function ss_getGlobalValue(aKey) {
    return SessionStoreInternal.getGlobalValue(aKey);
  },

  setGlobalValue: function ss_setGlobalValue(aKey, aStringValue) {
    SessionStoreInternal.setGlobalValue(aKey, aStringValue);
  },

  deleteGlobalValue: function ss_deleteGlobalValue(aKey) {
    SessionStoreInternal.deleteGlobalValue(aKey);
  },

  persistTabAttribute: function ss_persistTabAttribute(aName) {
    SessionStoreInternal.persistTabAttribute(aName);
  },

  restoreLastSession: function ss_restoreLastSession() {
    SessionStoreInternal.restoreLastSession();
  },

  getCurrentState: function (aUpdateAll) {
    return SessionStoreInternal.getCurrentState(aUpdateAll);
  },

  reviveCrashedTab(aTab) {
    return SessionStoreInternal.reviveCrashedTab(aTab);
  },

  reviveAllCrashedTabs() {
    return SessionStoreInternal.reviveAllCrashedTabs();
  },

  navigateAndRestore(tab, loadArguments, historyIndex) {
    return SessionStoreInternal.navigateAndRestore(tab, loadArguments, historyIndex);
  },

  getSessionHistory(tab, updatedCallback) {
    return SessionStoreInternal.getSessionHistory(tab, updatedCallback);
  },

  undoCloseById(aClosedId) {
    return SessionStoreInternal.undoCloseById(aClosedId);
  },

  /**
   * Determines whether the passed version number is compatible with
   * the current version number of the SessionStore.
   *
   * @param version The format and version of the file, as an array, e.g.
   * ["sessionrestore", 1]
   */
  isFormatVersionCompatible(version) {
    if (!version) {
      return false;
    }
    if (!Array.isArray(version)) {
      // Improper format.
      return false;
    }
    if (version[0] != "sessionrestore") {
      // Not a Session Restore file.
      return false;
    }
    let number = Number.parseFloat(version[1]);
    if (Number.isNaN(number)) {
      return false;
    }
    return number <= FORMAT_VERSION;
  },
};

// Freeze the SessionStore object. We don't want anyone to modify it.
Object.freeze(SessionStore);

var SessionStoreInternal = {
  QueryInterface: XPCOMUtils.generateQI([
    Ci.nsIDOMEventListener,
    Ci.nsIObserver,
    Ci.nsISupportsWeakReference
  ]),

  _globalState: new GlobalState(),

  // A counter to be used to generate a unique ID for each closed tab or window.
  _nextClosedId: 0,

  // During the initial restore and setBrowserState calls tracks the number of
  // windows yet to be restored
  _restoreCount: -1,

  // For each <browser> element, records the current epoch.
  _browserEpochs: new WeakMap(),

  // Any browsers that fires the oop-browser-crashed event gets stored in
  // here - that way we know which browsers to ignore messages from (until
  // they get restored).
  _crashedBrowsers: new WeakSet(),

  // A map (xul:browser -> nsIFrameLoader) that maps a browser to the last
  // associated frameLoader we heard about.
  _lastKnownFrameLoader: new WeakMap(),

  // A map (xul:browser -> object) that maps a browser associated with a
  // recently closed tab to all its necessary state information we need to
  // properly handle final update message.
  _closedTabs: new WeakMap(),

  // A map (xul:browser -> object) that maps a browser associated with a
  // recently closed tab due to a window closure to the tab state information
  // that is being stored in _closedWindows for that tab.
  _closedWindowTabs: new WeakMap(),

  // A set of window data that has the potential to be saved in the _closedWindows
  // array for the session. We will remove window data from this set whenever
  // forgetClosedWindow is called for the window, or when session history is
  // purged, so that we don't accidentally save that data after the flush has
  // completed. Closed tabs use a more complicated mechanism for this particular
  // problem. When forgetClosedTab is called, the browser is removed from the
  // _closedTabs map, so its data is not recorded. In the purge history case,
  // the closedTabs array per window is overwritten so that once the flush is
  // complete, the tab would only ever add itself to an array that SessionStore
  // no longer cares about. Bug 1230636 has been filed to make the tab case
  // work more like the window case, which is more explicit, and easier to
  // reason about.
  _saveableClosedWindowData: new WeakSet(),

  // A map (xul:browser -> object) that maps a browser that is switching
  // remoteness via navigateAndRestore, to the loadArguments that were
  // most recently passed when calling navigateAndRestore.
  _remotenessChangingBrowsers: new WeakMap(),

  // whether a setBrowserState call is in progress
  _browserSetState: false,

  // time in milliseconds when the session was started (saved across sessions),
  // defaults to now if no session was restored or timestamp doesn't exist
  _sessionStartTime: Date.now(),

  // states for all currently opened windows
  _windows: {},

  // counter for creating unique window IDs
  _nextWindowID: 0,

  // states for all recently closed windows
  _closedWindows: [],

  // collection of session states yet to be restored
  _statesToRestore: {},

  // counts the number of crashes since the last clean start
  _recentCrashes: 0,

  // whether the last window was closed and should be restored
  _restoreLastWindow: false,

  // number of tabs currently restoring
  _tabsRestoringCount: 0,

  // When starting Firefox with a single private window, this is the place
  // where we keep the session we actually wanted to restore in case the user
  // decides to later open a non-private window as well.
  _deferredInitialState: null,

  // A promise resolved once initialization is complete
  _deferredInitialized: (function () {
    let deferred = {};

    deferred.promise = new Promise((resolve, reject) => {
      deferred.resolve = resolve;
      deferred.reject = reject;
    });

    return deferred;
  })(),

  // Whether session has been initialized
  _sessionInitialized: false,

  // Promise that is resolved when we're ready to initialize
  // and restore the session.
  _promiseReadyForInitialization: null,

  // Keep busy state counters per window.
  _windowBusyStates: new WeakMap(),

  /**
   * A promise fulfilled once initialization is complete.
   */
  get promiseInitialized() {
    return this._deferredInitialized.promise;
  },

  get canRestoreLastSession() {
    return LastSession.canRestore;
  },

  set canRestoreLastSession(val) {
    // Cheat a bit; only allow false.
    if (!val) {
      LastSession.clear();
    }
  },

  /**
   * Returns a string describing the last closed object, either "tab" or "window".
   *
   * This was added to support the sessions.restore WebExtensions API.
   */
  get lastClosedObjectType() {
    if (this._closedWindows.length) {
      // Since there are closed windows, we need to check if there's a closed tab
      // in one of the currently open windows that was closed after the
      // last-closed window.
      let tabTimestamps = [];
      let windowsEnum = Services.wm.getEnumerator("navigator:browser");
      while (windowsEnum.hasMoreElements()) {
        let window = windowsEnum.getNext();
        let windowState = this._windows[window.__SSi];
        if (windowState && windowState._closedTabs[0]) {
          tabTimestamps.push(windowState._closedTabs[0].closedAt);
        }
      }
      if (!tabTimestamps.length ||
          (tabTimestamps.sort((a, b) => b - a)[0] < this._closedWindows[0].closedAt)) {
        return "window";
      }
    }
    return "tab";
  },

  /**
   * Initialize the sessionstore service.
   */
  init: function () {
    if (this._initialized) {
      throw new Error("SessionStore.init() must only be called once!");
    }

    TelemetryTimestamps.add("sessionRestoreInitialized");
    OBSERVING.forEach(function(aTopic) {
      Services.obs.addObserver(this, aTopic, true);
    }, this);

    this._initPrefs();
    this._initialized = true;
  },

  /**
   * Initialize the session using the state provided by SessionStartup
   */
  initSession: function () {
    TelemetryStopwatch.start("FX_SESSION_RESTORE_STARTUP_INIT_SESSION_MS");
    let state;
    let ss = gSessionStartup;

    if (ss.doRestore() ||
        ss.sessionType == Ci.nsISessionStartup.DEFER_SESSION) {
      state = ss.state;
    }

    if (state) {
      try {
        // If we're doing a DEFERRED session, then we want to pull pinned tabs
        // out so they can be restored.
        if (ss.sessionType == Ci.nsISessionStartup.DEFER_SESSION) {
          let [iniState, remainingState] = this._prepDataForDeferredRestore(state);
          // If we have a iniState with windows, that means that we have windows
          // with app tabs to restore.
          if (iniState.windows.length)
            state = iniState;
          else
            state = null;

          if (remainingState.windows.length) {
            LastSession.setState(remainingState);
          }
        }
        else {
          // Get the last deferred session in case the user still wants to
          // restore it
          LastSession.setState(state.lastSessionState);

          if (ss.previousSessionCrashed) {
            this._recentCrashes = (state.session &&
                                   state.session.recentCrashes || 0) + 1;

            if (this._needsRestorePage(state, this._recentCrashes)) {
              // replace the crashed session with a restore-page-only session
              let url = "about:sessionrestore";
              let formdata = {id: {sessionData: state}, url};
              state = { windows: [{ tabs: [{ entries: [{url}], formdata }] }] };
            } else if (this._hasSingleTabWithURL(state.windows,
                                                 "about:welcomeback")) {
              // On a single about:welcomeback URL that crashed, replace about:welcomeback
              // with about:sessionrestore, to make clear to the user that we crashed.
              state.windows[0].tabs[0].entries[0].url = "about:sessionrestore";
            }
          }

          // Update the session start time using the restored session state.
          this._updateSessionStartTime(state);

          // make sure that at least the first window doesn't have anything hidden
          delete state.windows[0].hidden;
          // Since nothing is hidden in the first window, it cannot be a popup
          delete state.windows[0].isPopup;
          // We don't want to minimize and then open a window at startup.
          if (state.windows[0].sizemode == "minimized")
            state.windows[0].sizemode = "normal";
          // clear any lastSessionWindowID attributes since those don't matter
          // during normal restore
          state.windows.forEach(function(aWindow) {
            delete aWindow.__lastSessionWindowID;
          });
        }
      }
      catch (ex) { debug("The session file is invalid: " + ex); }
    }

    // at this point, we've as good as resumed the session, so we can
    // clear the resume_session_once flag, if it's set
    if (!RunState.isQuitting &&
        this._prefBranch.getBoolPref("sessionstore.resume_session_once"))
      this._prefBranch.setBoolPref("sessionstore.resume_session_once", false);

    TelemetryStopwatch.finish("FX_SESSION_RESTORE_STARTUP_INIT_SESSION_MS");
    return state;
  },

  _initPrefs : function() {
    this._prefBranch = Services.prefs.getBranch("browser.");

    gDebuggingEnabled = this._prefBranch.getBoolPref("sessionstore.debug");

    Services.prefs.addObserver("browser.sessionstore.debug", () => {
      gDebuggingEnabled = this._prefBranch.getBoolPref("sessionstore.debug");
    }, false);

    this._max_tabs_undo = this._prefBranch.getIntPref("sessionstore.max_tabs_undo");
    this._prefBranch.addObserver("sessionstore.max_tabs_undo", this, true);

    this._max_windows_undo = this._prefBranch.getIntPref("sessionstore.max_windows_undo");
    this._prefBranch.addObserver("sessionstore.max_windows_undo", this, true);
  },

  /**
   * Called on application shutdown, after notifications:
   * quit-application-granted, quit-application
   */
  _uninit: function ssi_uninit() {
    if (!this._initialized) {
      throw new Error("SessionStore is not initialized.");
    }

    // Prepare to close the session file and write the last state.
    RunState.setClosing();

    // save all data for session resuming
    if (this._sessionInitialized) {
      SessionSaver.run();
    }

    // clear out priority queue in case it's still holding refs
    TabRestoreQueue.reset();

    // Make sure to cancel pending saves.
    SessionSaver.cancel();
  },

  /**
   * Handle notifications
   */
  observe: function ssi_observe(aSubject, aTopic, aData) {
    switch (aTopic) {
      case "browser-window-before-show": // catch new windows
        this.onBeforeBrowserWindowShown(aSubject);
        break;
      case "domwindowclosed": // catch closed windows
        this.onClose(aSubject);
        break;
      case "quit-application-granted":
        let syncShutdown = aData == "syncShutdown";
        this.onQuitApplicationGranted(syncShutdown);
        break;
      case "browser-lastwindow-close-granted":
        this.onLastWindowCloseGranted();
        break;
      case "quit-application":
        this.onQuitApplication(aData);
        break;
      case "browser:purge-session-history": // catch sanitization
        this.onPurgeSessionHistory();
        break;
      case "browser:purge-domain-data":
        this.onPurgeDomainData(aData);
        break;
      case "nsPref:changed": // catch pref changes
        this.onPrefChange(aData);
        break;
      case "idle-daily":
        this.onIdleDaily();
        break;
    }
  },

  /**
   * This method handles incoming messages sent by the session store content
   * script via the Frame Message Manager or Parent Process Message Manager,
   * and thus enables communication with OOP tabs.
   */
  receiveMessage(aMessage) {
    // If we got here, that means we're dealing with a frame message
    // manager message, so the target will be a <xul:browser>.
    var browser = aMessage.target;
    let win = browser.ownerGlobal;
    let tab = win ? win.gBrowser.getTabForBrowser(browser) : null;

    // Ensure we receive only specific messages from <xul:browser>s that
    // have no tab or window assigned, e.g. the ones that preload
    // about:newtab pages, or windows that have closed.
    if (!tab && !NOTAB_MESSAGES.has(aMessage.name)) {
      throw new Error(`received unexpected message '${aMessage.name}' ` +
                      `from a browser that has no tab or window`);
    }

    let data = aMessage.data || {};
    let hasEpoch = data.hasOwnProperty("epoch");

    // Most messages sent by frame scripts require to pass an epoch.
    if (!hasEpoch && !NOEPOCH_MESSAGES.has(aMessage.name)) {
      throw new Error(`received message '${aMessage.name}' without an epoch`);
    }

    // Ignore messages from previous epochs.
    if (hasEpoch && !this.isCurrentEpoch(browser, data.epoch)) {
      return;
    }

    switch (aMessage.name) {
      case "SessionStore:update":
        // |browser.frameLoader| might be empty if the browser was already
        // destroyed and its tab removed. In that case we still have the last
        // frameLoader we know about to compare.
        let frameLoader = browser.frameLoader ||
                          this._lastKnownFrameLoader.get(browser.permanentKey);

        // If the message isn't targeting the latest frameLoader discard it.
        if (frameLoader != aMessage.targetFrameLoader) {
          return;
        }

        if (aMessage.data.isFinal) {
          // If this the final message we need to resolve all pending flush
          // requests for the given browser as they might have been sent too
          // late and will never respond. If they have been sent shortly after
          // switching a browser's remoteness there isn't too much data to skip.
          TabStateFlusher.resolveAll(browser);
        } else if (aMessage.data.flushID) {
          // This is an update kicked off by an async flush request. Notify the
          // TabStateFlusher so that it can finish the request and notify its
          // consumer that's waiting for the flush to be done.
          TabStateFlusher.resolve(browser, aMessage.data.flushID);
        }

        // Ignore messages from <browser> elements that have crashed
        // and not yet been revived.
        if (this._crashedBrowsers.has(browser.permanentKey)) {
          return;
        }

        // Record telemetry measurements done in the child and update the tab's
        // cached state. Mark the window as dirty and trigger a delayed write.
        this.recordTelemetry(aMessage.data.telemetry);
        TabState.update(browser, aMessage.data);
        this.saveStateDelayed(win);

        // Handle any updates sent by the child after the tab was closed. This
        // might be the final update as sent by the "unload" handler but also
        // any async update message that was sent before the child unloaded.
        if (this._closedTabs.has(browser.permanentKey)) {
          let {closedTabs, tabData} = this._closedTabs.get(browser.permanentKey);

          // Update the closed tab's state. This will be reflected in its
          // window's list of closed tabs as that refers to the same object.
          TabState.copyFromCache(browser, tabData.state);

          // Is this the tab's final message?
          if (aMessage.data.isFinal) {
            // We expect no further updates.
            this._closedTabs.delete(browser.permanentKey);
            // The tab state no longer needs this reference.
            delete tabData.permanentKey;

            // Determine whether the tab state is worth saving.
            let shouldSave = this._shouldSaveTabState(tabData.state);
            let index = closedTabs.indexOf(tabData);

            if (shouldSave && index == -1) {
              // If the tab state is worth saving and we didn't push it onto
              // the list of closed tabs when it was closed (because we deemed
              // the state not worth saving) then add it to the window's list
              // of closed tabs now.
              this.saveClosedTabData(closedTabs, tabData);
            } else if (!shouldSave && index > -1) {
              // Remove from the list of closed tabs. The update messages sent
              // after the tab was closed changed enough state so that we no
              // longer consider its data interesting enough to keep around.
              this.removeClosedTabData(closedTabs, index);
            }
          }
        }
        break;
      case "SessionStore:restoreHistoryComplete":
        // Notify the tabbrowser that the tab chrome has been restored.
        let tabData = TabState.collect(tab);

        // wall-paper fix for bug 439675: make sure that the URL to be loaded
        // is always visible in the address bar if no other value is present
        let activePageData = tabData.entries[tabData.index - 1] || null;
        let uri = activePageData ? activePageData.url || null : null;
        // NB: we won't set initial URIs (about:home, about:newtab, etc.) here
        // because their load will not normally trigger a location bar clearing
        // when they finish loading (to avoid race conditions where we then
        // clear user input instead), so we shouldn't set them here either.
        // They also don't fall under the issues in bug 439675 where user input
        // needs to be preserved if the load doesn't succeed.
        // We also don't do this for remoteness updates, where it should not
        // be necessary.
        if (!browser.userTypedValue && uri && !data.isRemotenessUpdate &&
            !win.gInitialPages.includes(uri)) {
          browser.userTypedValue = uri;
        }

        // If the page has a title, set it.
        if (activePageData) {
          if (activePageData.title) {
            tab.label = activePageData.title;
            tab.crop = "end";
          } else if (activePageData.url != "about:blank") {
            tab.label = activePageData.url;
            tab.crop = "center";
          }
        } else if (tab.hasAttribute("customizemode")) {
          win.gCustomizeMode.setTab(tab);
        }

        // Restore the tab icon.
        if ("image" in tabData) {
          // Use the serialized contentPrincipal with the new icon load.
          let loadingPrincipal = Utils.deserializePrincipal(tabData.iconLoadingPrincipal);
          win.gBrowser.setIcon(tab, tabData.image, loadingPrincipal);
          TabStateCache.update(browser, { image: null, iconLoadingPrincipal: null });
        }

        let event = win.document.createEvent("Events");
        event.initEvent("SSTabRestoring", true, false);
        tab.dispatchEvent(event);
        break;
      case "SessionStore:restoreTabContentStarted":
        if (browser.__SS_restoreState == TAB_STATE_NEEDS_RESTORE) {
          // If a load not initiated by sessionstore was started in a
          // previously pending tab. Mark the tab as no longer pending.
          this.markTabAsRestoring(tab);
        } else if (!data.isRemotenessUpdate) {
          // If the user was typing into the URL bar when we crashed, but hadn't hit
          // enter yet, then we just need to write that value to the URL bar without
          // loading anything. This must happen after the load, as the load will clear
          // userTypedValue.
          let tabData = TabState.collect(tab);
          if (tabData.userTypedValue && !tabData.userTypedClear && !browser.userTypedValue) {
            browser.userTypedValue = tabData.userTypedValue;
            win.URLBarSetURI();
          }

          // Remove state we don't need any longer.
          TabStateCache.update(browser, {
            userTypedValue: null, userTypedClear: null
          });
        }
        break;
      case "SessionStore:restoreTabContentComplete":
        // This callback is used exclusively by tests that want to
        // monitor the progress of network loads.
        if (gDebuggingEnabled) {
          Services.obs.notifyObservers(browser, NOTIFY_TAB_RESTORED, null);
        }

        SessionStoreInternal._resetLocalTabRestoringState(tab);
        SessionStoreInternal.restoreNextTab();

        this._sendTabRestoredNotification(tab, data.isRemotenessUpdate);
        break;
      case "SessionStore:crashedTabRevived":
        // The browser was revived by navigating to a different page
        // manually, so we remove it from the ignored browser set.
        this._crashedBrowsers.delete(browser.permanentKey);
        break;
      case "SessionStore:error":
        this.reportInternalError(data);
        TabStateFlusher.resolveAll(browser, false, "Received error from the content process");
        break;
      default:
        throw new Error(`received unknown message '${aMessage.name}'`);
        break;
    }
  },

  /**
   * Record telemetry measurements stored in an object.
   * @param telemetry
   *        {histogramID: value, ...} An object mapping histogramIDs to the
   *        value to be recorded for that ID,
   */
  recordTelemetry: function (telemetry) {
    for (let histogramId in telemetry){
      Telemetry.getHistogramById(histogramId).add(telemetry[histogramId]);
    }
  },

  /* ........ Window Event Handlers .............. */

  /**
   * Implement nsIDOMEventListener for handling various window and tab events
   */
  handleEvent: function ssi_handleEvent(aEvent) {
    let win = aEvent.currentTarget.ownerGlobal;
    let target = aEvent.originalTarget;
    switch (aEvent.type) {
      case "TabOpen":
        this.onTabAdd(win);
        break;
      case "TabBrowserInserted":
        this.onTabBrowserInserted(win, target);
        break;
      case "TabClose":
        // `adoptedBy` will be set if the tab was closed because it is being
        // moved to a new window.
        if (!aEvent.detail.adoptedBy)
          this.onTabClose(win, target);
        this.onTabRemove(win, target);
        break;
      case "TabSelect":
        this.onTabSelect(win);
        break;
      case "TabShow":
        this.onTabShow(win, target);
        break;
      case "TabHide":
        this.onTabHide(win, target);
        break;
      case "TabPinned":
      case "TabUnpinned":
      case "SwapDocShells":
        this.saveStateDelayed(win);
        break;
      case "oop-browser-crashed":
        this.onBrowserCrashed(target);
        break;
      case "XULFrameLoaderCreated":
        if (target.namespaceURI == NS_XUL &&
            target.localName == "browser" &&
            target.frameLoader &&
            target.permanentKey) {
          this._lastKnownFrameLoader.set(target.permanentKey, target.frameLoader);
          this.resetEpoch(target);
        }
        break;
      default:
        throw new Error(`unhandled event ${aEvent.type}?`);
    }
    this._clearRestoringWindows();
  },

  /**
   * Generate a unique window identifier
   * @return string
   *         A unique string to identify a window
   */
  _generateWindowID: function ssi_generateWindowID() {
    return "window" + (this._nextWindowID++);
  },

  /**
   * Registers and tracks a given window.
   *
   * @param aWindow
   *        Window reference
   */
  onLoad(aWindow) {
    // return if window has already been initialized
    if (aWindow && aWindow.__SSi && this._windows[aWindow.__SSi])
      return;

    // ignore windows opened while shutting down
    if (RunState.isQuitting)
      return;

    // Assign the window a unique identifier we can use to reference
    // internal data about the window.
    aWindow.__SSi = this._generateWindowID();

    let mm = aWindow.getGroupMessageManager("browsers");
    MESSAGES.forEach(msg => {
      let listenWhenClosed = CLOSED_MESSAGES.has(msg);
      mm.addMessageListener(msg, this, listenWhenClosed);
    });

    // Load the frame script after registering listeners.
    mm.loadFrameScript("chrome://browser/content/content-sessionStore.js", true);

    // and create its data object
    this._windows[aWindow.__SSi] = { tabs: [], selected: 0, _closedTabs: [], busy: false };

    if (PrivateBrowsingUtils.isWindowPrivate(aWindow))
      this._windows[aWindow.__SSi].isPrivate = true;
    if (!this._isWindowLoaded(aWindow))
      this._windows[aWindow.__SSi]._restoring = true;
    if (!aWindow.toolbar.visible)
      this._windows[aWindow.__SSi].isPopup = true;

    let tabbrowser = aWindow.gBrowser;

    // add tab change listeners to all already existing tabs
    for (let i = 0; i < tabbrowser.tabs.length; i++) {
      this.onTabBrowserInserted(aWindow, tabbrowser.tabs[i]);
    }
    // notification of tab add/remove/selection/show/hide
    TAB_EVENTS.forEach(function(aEvent) {
      tabbrowser.tabContainer.addEventListener(aEvent, this, true);
    }, this);

    // Keep track of a browser's latest frameLoader.
    aWindow.gBrowser.addEventListener("XULFrameLoaderCreated", this);
  },

  /**
   * Initializes a given window.
   *
   * Windows are registered as soon as they are created but we need to wait for
   * the session file to load, and the initial window's delayed startup to
   * finish before initializing a window, i.e. restoring data into it.
   *
   * @param aWindow
   *        Window reference
   * @param aInitialState
   *        The initial state to be loaded after startup (optional)
   */
  initializeWindow(aWindow, aInitialState = null) {
    let isPrivateWindow = PrivateBrowsingUtils.isWindowPrivate(aWindow);

    // perform additional initialization when the first window is loading
    if (RunState.isStopped) {
      RunState.setRunning();

      // restore a crashed session resp. resume the last session if requested
      if (aInitialState) {
        // Don't write to disk right after startup. Set the last time we wrote
        // to disk to NOW() to enforce a full interval before the next write.
        SessionSaver.updateLastSaveTime();

        if (isPrivateWindow) {
          // We're starting with a single private window. Save the state we
          // actually wanted to restore so that we can do it later in case
          // the user opens another, non-private window.
          this._deferredInitialState = gSessionStartup.state;

          // Nothing to restore now, notify observers things are complete.
          Services.obs.notifyObservers(null, NOTIFY_WINDOWS_RESTORED, "");
        } else {
          TelemetryTimestamps.add("sessionRestoreRestoring");
          this._restoreCount = aInitialState.windows ? aInitialState.windows.length : 0;

          // global data must be restored before restoreWindow is called so that
          // it happens before observers are notified
          this._globalState.setFromState(aInitialState);

          let overwrite = this._isCmdLineEmpty(aWindow, aInitialState);
          let options = {firstWindow: true, overwriteTabs: overwrite};
          this.restoreWindows(aWindow, aInitialState, options);
        }
      }
      else {
        // Nothing to restore, notify observers things are complete.
        Services.obs.notifyObservers(null, NOTIFY_WINDOWS_RESTORED, "");
      }
    }
    // this window was opened by _openWindowWithState
    else if (!this._isWindowLoaded(aWindow)) {
      let state = this._statesToRestore[aWindow.__SS_restoreID];
      let options = {overwriteTabs: true, isFollowUp: state.windows.length == 1};
      this.restoreWindow(aWindow, state.windows[0], options);
    }
    // The user opened another, non-private window after starting up with
    // a single private one. Let's restore the session we actually wanted to
    // restore at startup.
    else if (this._deferredInitialState && !isPrivateWindow &&
             aWindow.toolbar.visible) {

      // global data must be restored before restoreWindow is called so that
      // it happens before observers are notified
      this._globalState.setFromState(this._deferredInitialState);

      this._restoreCount = this._deferredInitialState.windows ?
        this._deferredInitialState.windows.length : 0;
      this.restoreWindows(aWindow, this._deferredInitialState, {firstWindow: true});
      this._deferredInitialState = null;
    }
    else if (this._restoreLastWindow && aWindow.toolbar.visible &&
             this._closedWindows.length && !isPrivateWindow) {

      // default to the most-recently closed window
      // don't use popup windows
      let closedWindowState = null;
      let closedWindowIndex;
      for (let i = 0; i < this._closedWindows.length; i++) {
        // Take the first non-popup, point our object at it, and break out.
        if (!this._closedWindows[i].isPopup) {
          closedWindowState = this._closedWindows[i];
          closedWindowIndex = i;
          break;
        }
      }

      if (closedWindowState) {
        let newWindowState;
        if (AppConstants.platform == "macosx" || !this._doResumeSession()) {
          // We want to split the window up into pinned tabs and unpinned tabs.
          // Pinned tabs should be restored. If there are any remaining tabs,
          // they should be added back to _closedWindows.
          // We'll cheat a little bit and reuse _prepDataForDeferredRestore
          // even though it wasn't built exactly for this.
          let [appTabsState, normalTabsState] =
            this._prepDataForDeferredRestore({ windows: [closedWindowState] });

          // These are our pinned tabs, which we should restore
          if (appTabsState.windows.length) {
            newWindowState = appTabsState.windows[0];
            delete newWindowState.__lastSessionWindowID;
          }

          // In case there were no unpinned tabs, remove the window from _closedWindows
          if (!normalTabsState.windows.length) {
            this._closedWindows.splice(closedWindowIndex, 1);
          }
          // Or update _closedWindows with the modified state
          else {
            delete normalTabsState.windows[0].__lastSessionWindowID;
            this._closedWindows[closedWindowIndex] = normalTabsState.windows[0];
          }
        }
        else {
          // If we're just restoring the window, make sure it gets removed from
          // _closedWindows.
          this._closedWindows.splice(closedWindowIndex, 1);
          newWindowState = closedWindowState;
          delete newWindowState.hidden;
        }

        if (newWindowState) {
          // Ensure that the window state isn't hidden
          this._restoreCount = 1;
          let state = { windows: [newWindowState] };
          let options = {overwriteTabs: this._isCmdLineEmpty(aWindow, state)};
          this.restoreWindow(aWindow, newWindowState, options);
        }
      }
      // we actually restored the session just now.
      this._prefBranch.setBoolPref("sessionstore.resume_session_once", false);
    }
    if (this._restoreLastWindow && aWindow.toolbar.visible) {
      // always reset (if not a popup window)
      // we don't want to restore a window directly after, for example,
      // undoCloseWindow was executed.
      this._restoreLastWindow = false;
    }
  },

  /**
   * Called right before a new browser window is shown.
   * @param aWindow
   *        Window reference
   */
  onBeforeBrowserWindowShown: function (aWindow) {
    // Register the window.
    this.onLoad(aWindow);

    // Just call initializeWindow() directly if we're initialized already.
    if (this._sessionInitialized) {
      this.initializeWindow(aWindow);
      return;
    }

    // The very first window that is opened creates a promise that is then
    // re-used by all subsequent windows. The promise will be used to tell
    // when we're ready for initialization.
    if (!this._promiseReadyForInitialization) {
      // Wait for the given window's delayed startup to be finished.
      let promise = new Promise(resolve => {
        Services.obs.addObserver(function obs(subject, topic) {
          if (aWindow == subject) {
            Services.obs.removeObserver(obs, topic);
            resolve();
          }
        }, "browser-delayed-startup-finished", false);
      });

      // We are ready for initialization as soon as the session file has been
      // read from disk and the initial window's delayed startup has finished.
      this._promiseReadyForInitialization =
        Promise.all([promise, gSessionStartup.onceInitialized]);
    }

    // We can't call this.onLoad since initialization
    // hasn't completed, so we'll wait until it is done.
    // Even if additional windows are opened and wait
    // for initialization as well, the first opened
    // window should execute first, and this.onLoad
    // will be called with the initialState.
    this._promiseReadyForInitialization.then(() => {
      if (aWindow.closed) {
        return;
      }

      if (this._sessionInitialized) {
        this.initializeWindow(aWindow);
      } else {
        let initialState = this.initSession();
        this._sessionInitialized = true;

        if (initialState) {
          Services.obs.notifyObservers(null, NOTIFY_RESTORING_ON_STARTUP, "");
        }
        TelemetryStopwatch.start("FX_SESSION_RESTORE_STARTUP_ONLOAD_INITIAL_WINDOW_MS");
        this.initializeWindow(aWindow, initialState);
        TelemetryStopwatch.finish("FX_SESSION_RESTORE_STARTUP_ONLOAD_INITIAL_WINDOW_MS");

        // Let everyone know we're done.
        this._deferredInitialized.resolve();
      }
    }, console.error);
  },

  /**
   * On window close...
   * - remove event listeners from tabs
   * - save all window data
   * @param aWindow
   *        Window reference
   */
  onClose: function ssi_onClose(aWindow) {
    // this window was about to be restored - conserve its original data, if any
    let isFullyLoaded = this._isWindowLoaded(aWindow);
    if (!isFullyLoaded) {
      if (!aWindow.__SSi) {
        aWindow.__SSi = this._generateWindowID();
      }

      this._windows[aWindow.__SSi] = this._statesToRestore[aWindow.__SS_restoreID];
      delete this._statesToRestore[aWindow.__SS_restoreID];
      delete aWindow.__SS_restoreID;
    }

    // ignore windows not tracked by SessionStore
    if (!aWindow.__SSi || !this._windows[aWindow.__SSi]) {
      return;
    }

    // notify that the session store will stop tracking this window so that
    // extensions can store any data about this window in session store before
    // that's not possible anymore
    let event = aWindow.document.createEvent("Events");
    event.initEvent("SSWindowClosing", true, false);
    aWindow.dispatchEvent(event);

    if (this.windowToFocus && this.windowToFocus == aWindow) {
      delete this.windowToFocus;
    }

    var tabbrowser = aWindow.gBrowser;

    let browsers = Array.from(tabbrowser.browsers);

    TAB_EVENTS.forEach(function(aEvent) {
      tabbrowser.tabContainer.removeEventListener(aEvent, this, true);
    }, this);

    aWindow.gBrowser.removeEventListener("XULFrameLoaderCreated", this);

    let winData = this._windows[aWindow.__SSi];

    // Collect window data only when *not* closed during shutdown.
    if (RunState.isRunning) {
      // Grab the most recent window data. The tab data will be updated
      // once we finish flushing all of the messages from the tabs.
      let tabMap = this._collectWindowData(aWindow);

      for (let [tab, tabData] of tabMap) {
        let permanentKey = tab.linkedBrowser.permanentKey;
        this._closedWindowTabs.set(permanentKey, tabData);
      }

      if (isFullyLoaded) {
        winData.title = tabbrowser.selectedBrowser.contentTitle || tabbrowser.selectedTab.label;
        winData.title = this._replaceLoadingTitle(winData.title, tabbrowser,
                                                  tabbrowser.selectedTab);
        SessionCookies.update([winData]);
      }

      if (AppConstants.platform != "macosx") {
        // Until we decide otherwise elsewhere, this window is part of a series
        // of closing windows to quit.
        winData._shouldRestore = true;
      }

      // Store the window's close date to figure out when each individual tab
      // was closed. This timestamp should allow re-arranging data based on how
      // recently something was closed.
      winData.closedAt = Date.now();

      // we don't want to save the busy state
      delete winData.busy;

      // When closing windows one after the other until Firefox quits, we
      // will move those closed in series back to the "open windows" bucket
      // before writing to disk. If however there is only a single window
      // with tabs we deem not worth saving then we might end up with a
      // random closed or even a pop-up window re-opened. To prevent that
      // we explicitly allow saving an "empty" window state.
      let isLastWindow =
        Object.keys(this._windows).length == 1 &&
        !this._closedWindows.some(win => win._shouldRestore || false);

      // clear this window from the list, since it has definitely been closed.
      delete this._windows[aWindow.__SSi];

      // This window has the potential to be saved in the _closedWindows
      // array (maybeSaveClosedWindows gets the final call on that).
      this._saveableClosedWindowData.add(winData);

      // Now we have to figure out if this window is worth saving in the _closedWindows
      // Object.
      //
      // We're about to flush the tabs from this window, but it's possible that we
      // might never hear back from the content process(es) in time before the user
      // chooses to restore the closed window. So we do the following:
      //
      // 1) Use the tab state cache to determine synchronously if the window is
      //    worth stashing in _closedWindows.
      // 2) Flush the window.
      // 3) When the flush is complete, revisit our decision to store the window
      //    in _closedWindows, and add/remove as necessary.
      if (!winData.isPrivate) {
        // Remove any open private tabs the window may contain.
        PrivacyFilter.filterPrivateTabs(winData);
        this.maybeSaveClosedWindow(winData, isLastWindow);
      }

      TabStateFlusher.flushWindow(aWindow).then(() => {
        // At this point, aWindow is closed! You should probably not try to
        // access any DOM elements from aWindow within this callback unless
        // you're holding on to them in the closure.

        for (let browser of browsers) {
          if (this._closedWindowTabs.has(browser.permanentKey)) {
            let tabData = this._closedWindowTabs.get(browser.permanentKey);
            TabState.copyFromCache(browser, tabData);
            this._closedWindowTabs.delete(browser.permanentKey);
          }
        }

        // Save non-private windows if they have at
        // least one saveable tab or are the last window.
        if (!winData.isPrivate) {
          // It's possible that a tab switched its privacy state at some point
          // before our flush, so we need to filter again.
          PrivacyFilter.filterPrivateTabs(winData);
          this.maybeSaveClosedWindow(winData, isLastWindow);
        }

        // Update the tabs data now that we've got the most
        // recent information.
        this.cleanUpWindow(aWindow, winData, browsers);

        // save the state without this window to disk
        this.saveStateDelayed();
      });
    } else {
      this.cleanUpWindow(aWindow, winData, browsers);
    }

    for (let i = 0; i < tabbrowser.tabs.length; i++) {
      this.onTabRemove(aWindow, tabbrowser.tabs[i], true);
    }
  },

  /**
   * Clean up the message listeners on a window that has finally
   * gone away. Call this once you're sure you don't want to hear
   * from any of this windows tabs from here forward.
   *
   * @param aWindow
   *        The browser window we're cleaning up.
   * @param winData
   *        The data for the window that we should hold in the
   *        DyingWindowCache in case anybody is still holding a
   *        reference to it.
   */
  cleanUpWindow(aWindow, winData, browsers) {
    // Any leftover TabStateFlusher Promises need to be resolved now,
    // since we're about to remove the message listeners.
    for (let browser of browsers) {
      TabStateFlusher.resolveAll(browser);
    }

    // Cache the window state until it is completely gone.
    DyingWindowCache.set(aWindow, winData);

    let mm = aWindow.getGroupMessageManager("browsers");
    MESSAGES.forEach(msg => mm.removeMessageListener(msg, this));

    this._saveableClosedWindowData.delete(winData);
    delete aWindow.__SSi;
  },

  /**
   * Decides whether or not a closed window should be put into the
   * _closedWindows Object. This might be called multiple times per
   * window, and will do the right thing of moving the window data
   * in or out of _closedWindows if the winData indicates that our
   * need for saving it has changed.
   *
   * @param winData
   *        The data for the closed window that we might save.
   * @param isLastWindow
   *        Whether or not the window being closed is the last
   *        browser window. Callers of this function should pass
   *        in the value of SessionStoreInternal.atLastWindow for
   *        this argument, and pass in the same value if they happen
   *        to call this method again asynchronously (for example, after
   *        a window flush).
   */
  maybeSaveClosedWindow(winData, isLastWindow) {
    // Make sure SessionStore is still running, and make sure that we
    // haven't chosen to forget this window.
    if (RunState.isRunning && this._saveableClosedWindowData.has(winData)) {
      // Determine whether the window has any tabs worth saving.
      let hasSaveableTabs = winData.tabs.some(this._shouldSaveTabState);

      // Note that we might already have this window stored in
      // _closedWindows from a previous call to this function.
      let winIndex = this._closedWindows.indexOf(winData);
      let alreadyStored = (winIndex != -1);
      let shouldStore = (hasSaveableTabs || isLastWindow);

      if (shouldStore && !alreadyStored) {
        let index = this._closedWindows.findIndex(win => {
          return win.closedAt < winData.closedAt;
        });

        // If we found no tab closed before our
        // tab then just append it to the list.
        if (index == -1) {
          index = this._closedWindows.length;
        }

        // About to save the closed window, add a unique ID.
        winData.closedId = this._nextClosedId++;

        // Insert tabData at the right position.
        this._closedWindows.splice(index, 0, winData);
        this._capClosedWindows();
      } else if (!shouldStore && alreadyStored) {
        this._closedWindows.splice(winIndex, 1);
      }
    }
  },

  /**
   * On quit application granted
   */
  onQuitApplicationGranted: function ssi_onQuitApplicationGranted(syncShutdown=false) {
    // Collect an initial snapshot of window data before we do the flush
    this._forEachBrowserWindow((win) => {
      this._collectWindowData(win);
    });

    // Now add an AsyncShutdown blocker that'll spin the event loop
    // until the windows have all been flushed.

    // This progress object will track the state of async window flushing
    // and will help us debug things that go wrong with our AsyncShutdown
    // blocker.
    let progress = { total: -1, current: -1 };

    // We're going down! Switch state so that we treat closing windows and
    // tabs correctly.
    RunState.setQuitting();

    if (!syncShutdown) {
      // We've got some time to shut down, so let's do this properly.
      // To prevent blocker from breaking the 60 sec limit(which will cause a
      // crash) of async shutdown during flushing all windows, we resolve the
      // promise passed to blocker once:
      // 1. the flushing exceed 50 sec, or
      // 2. 'oop-frameloader-crashed' or 'ipc:content-shutdown' is observed.
      // Thus, Firefox still can open the last session on next startup.
      AsyncShutdown.quitApplicationGranted.addBlocker(
        "SessionStore: flushing all windows",
        () => {
          var promises = [];
          promises.push(this.flushAllWindowsAsync(progress));
          promises.push(this.looseTimer(50000));

          var promiseOFC = new Promise(resolve => {
            Services.obs.addObserver(function obs(subject, topic) {
              Services.obs.removeObserver(obs, topic);
              resolve();
            }, "oop-frameloader-crashed", false);
          });
          promises.push(promiseOFC);

          var promiseICS = new Promise(resolve => {
            Services.obs.addObserver(function obs(subject, topic) {
              Services.obs.removeObserver(obs, topic);
              resolve();
            }, "ipc:content-shutdown", false);
          });
          promises.push(promiseICS);

          return Promise.race(promises);
        },
        () => progress);
    } else {
      // We have to shut down NOW, which means we only get to save whatever
      // we already had cached.
    }
  },

  /**
   * An async Task that iterates all open browser windows and flushes
   * any outstanding messages from their tabs. This will also close
   * all of the currently open windows while we wait for the flushes
   * to complete.
   *
   * @param progress (Object)
   *        Optional progress object that will be updated as async
   *        window flushing progresses. flushAllWindowsSync will
   *        write to the following properties:
   *
   *        total (int):
   *          The total number of windows to be flushed.
   *        current (int):
   *          The current window that we're waiting for a flush on.
   *
   * @return Promise
   */
  flushAllWindowsAsync: Task.async(function*(progress={}) {
    let windowPromises = new Map();
    // We collect flush promises and close each window immediately so that
    // the user can't start changing any window state while we're waiting
    // for the flushes to finish.
    this._forEachBrowserWindow((win) => {
      windowPromises.set(win, TabStateFlusher.flushWindow(win));

      // We have to wait for these messages to come up from
      // each window and each browser. In the meantime, hide
      // the windows to improve perceived shutdown speed.
      let baseWin = win.QueryInterface(Ci.nsIInterfaceRequestor)
                       .getInterface(Ci.nsIDocShell)
                       .QueryInterface(Ci.nsIDocShellTreeItem)
                       .treeOwner
                       .QueryInterface(Ci.nsIBaseWindow);
      baseWin.visibility = false;
    });

    progress.total = windowPromises.size;
    progress.current = 0;

    // We'll iterate through the Promise array, yielding each one, so as to
    // provide useful progress information to AsyncShutdown.
    for (let [win, promise] of windowPromises) {
      yield promise;
      this._collectWindowData(win);
      progress.current++;
    };

    // We must cache this because _getMostRecentBrowserWindow will always
    // return null by the time quit-application occurs.
    var activeWindow = this._getMostRecentBrowserWindow();
    if (activeWindow)
      this.activeWindowSSiCache = activeWindow.__SSi || "";
    DirtyWindows.clear();
  }),

  /**
   * On last browser window close
   */
  onLastWindowCloseGranted: function ssi_onLastWindowCloseGranted() {
    // last browser window is quitting.
    // remember to restore the last window when another browser window is opened
    // do not account for pref(resume_session_once) at this point, as it might be
    // set by another observer getting this notice after us
    this._restoreLastWindow = true;
  },

  /**
   * On quitting application
   * @param aData
   *        String type of quitting
   */
  onQuitApplication: function ssi_onQuitApplication(aData) {
    if (aData == "restart") {
      this._prefBranch.setBoolPref("sessionstore.resume_session_once", true);
      // The browser:purge-session-history notification fires after the
      // quit-application notification so unregister the
      // browser:purge-session-history notification to prevent clearing
      // session data on disk on a restart.  It is also unnecessary to
      // perform any other sanitization processing on a restart as the
      // browser is about to exit anyway.
      Services.obs.removeObserver(this, "browser:purge-session-history");
    }

    if (aData != "restart") {
      // Throw away the previous session on shutdown
      LastSession.clear();
    }

    this._uninit();
  },

  /**
   * On purge of session history
   */
  onPurgeSessionHistory: function ssi_onPurgeSessionHistory() {
    SessionFile.wipe();
    // If the browser is shutting down, simply return after clearing the
    // session data on disk as this notification fires after the
    // quit-application notification so the browser is about to exit.
    if (RunState.isQuitting)
      return;
    LastSession.clear();

    let openWindows = {};
    // Collect open windows.
    this._forEachBrowserWindow(({__SSi: id}) => openWindows[id] = true);

    // also clear all data about closed tabs and windows
    for (let ix in this._windows) {
      if (ix in openWindows) {
        this._windows[ix]._closedTabs = [];
      } else {
        delete this._windows[ix];
      }
    }
    // also clear all data about closed windows
    this._closedWindows = [];
    // give the tabbrowsers a chance to clear their histories first
    var win = this._getMostRecentBrowserWindow();
    if (win) {
      win.setTimeout(() => SessionSaver.run(), 0);
    } else if (RunState.isRunning) {
      SessionSaver.run();
    }

    this._clearRestoringWindows();
    this._saveableClosedWindowData = new WeakSet();
  },

  /**
   * On purge of domain data
   * @param aData
   *        String domain data
   */
  onPurgeDomainData: function ssi_onPurgeDomainData(aData) {
    // does a session history entry contain a url for the given domain?
    function containsDomain(aEntry) {
      if (Utils.hasRootDomain(aEntry.url, aData)) {
        return true;
      }
      return aEntry.children && aEntry.children.some(containsDomain, this);
    }
    // remove all closed tabs containing a reference to the given domain
    for (let ix in this._windows) {
      let closedTabs = this._windows[ix]._closedTabs;
      for (let i = closedTabs.length - 1; i >= 0; i--) {
        if (closedTabs[i].state.entries.some(containsDomain, this))
          closedTabs.splice(i, 1);
      }
    }
    // remove all open & closed tabs containing a reference to the given
    // domain in closed windows
    for (let ix = this._closedWindows.length - 1; ix >= 0; ix--) {
      let closedTabs = this._closedWindows[ix]._closedTabs;
      let openTabs = this._closedWindows[ix].tabs;
      let openTabCount = openTabs.length;
      for (let i = closedTabs.length - 1; i >= 0; i--)
        if (closedTabs[i].state.entries.some(containsDomain, this))
          closedTabs.splice(i, 1);
      for (let j = openTabs.length - 1; j >= 0; j--) {
        if (openTabs[j].entries.some(containsDomain, this)) {
          openTabs.splice(j, 1);
          if (this._closedWindows[ix].selected > j)
            this._closedWindows[ix].selected--;
        }
      }
      if (openTabs.length == 0) {
        this._closedWindows.splice(ix, 1);
      }
      else if (openTabs.length != openTabCount) {
        // Adjust the window's title if we removed an open tab
        let selectedTab = openTabs[this._closedWindows[ix].selected - 1];
        // some duplication from restoreHistory - make sure we get the correct title
        let activeIndex = (selectedTab.index || selectedTab.entries.length) - 1;
        if (activeIndex >= selectedTab.entries.length)
          activeIndex = selectedTab.entries.length - 1;
        this._closedWindows[ix].title = selectedTab.entries[activeIndex].title;
      }
    }

    if (RunState.isRunning) {
      SessionSaver.run();
    }

    this._clearRestoringWindows();
  },

  /**
   * On preference change
   * @param aData
   *        String preference changed
   */
  onPrefChange: function ssi_onPrefChange(aData) {
    switch (aData) {
      // if the user decreases the max number of closed tabs they want
      // preserved update our internal states to match that max
      case "sessionstore.max_tabs_undo":
        this._max_tabs_undo = this._prefBranch.getIntPref("sessionstore.max_tabs_undo");
        for (let ix in this._windows) {
          this._windows[ix]._closedTabs.splice(this._max_tabs_undo, this._windows[ix]._closedTabs.length);
        }
        break;
      case "sessionstore.max_windows_undo":
        this._max_windows_undo = this._prefBranch.getIntPref("sessionstore.max_windows_undo");
        this._capClosedWindows();
        break;
    }
  },

  /**
   * save state when new tab is added
   * @param aWindow
   *        Window reference
   */
  onTabAdd: function ssi_onTabAdd(aWindow) {
    this.saveStateDelayed(aWindow);
  },

  /**
   * set up listeners for a new tab
   * @param aWindow
   *        Window reference
   * @param aTab
   *        Tab reference
   */
  onTabBrowserInserted: function ssi_onTabBrowserInserted(aWindow, aTab) {
    let browser = aTab.linkedBrowser;
    browser.addEventListener("SwapDocShells", this);
    browser.addEventListener("oop-browser-crashed", this);

    if (browser.frameLoader) {
      this._lastKnownFrameLoader.set(browser.permanentKey, browser.frameLoader);
    }
  },

  /**
   * remove listeners for a tab
   * @param aWindow
   *        Window reference
   * @param aTab
   *        Tab reference
   * @param aNoNotification
   *        bool Do not save state if we're updating an existing tab
   */
  onTabRemove: function ssi_onTabRemove(aWindow, aTab, aNoNotification) {
    let browser = aTab.linkedBrowser;
    browser.removeEventListener("SwapDocShells", this);
    browser.removeEventListener("oop-browser-crashed", this);

    // If this tab was in the middle of restoring or still needs to be restored,
    // we need to reset that state. If the tab was restoring, we will attempt to
    // restore the next tab.
    let previousState = browser.__SS_restoreState;
    if (previousState) {
      this._resetTabRestoringState(aTab);
      if (previousState == TAB_STATE_RESTORING)
        this.restoreNextTab();
    }

    if (!aNoNotification) {
      this.saveStateDelayed(aWindow);
    }
  },

  /**
   * When a tab closes, collect its properties
   * @param aWindow
   *        Window reference
   * @param aTab
   *        Tab reference
   */
  onTabClose: function ssi_onTabClose(aWindow, aTab) {
    // notify the tabbrowser that the tab state will be retrieved for the last time
    // (so that extension authors can easily set data on soon-to-be-closed tabs)
    var event = aWindow.document.createEvent("Events");
    event.initEvent("SSTabClosing", true, false);
    aTab.dispatchEvent(event);

    // don't update our internal state if we don't have to
    if (this._max_tabs_undo == 0) {
      return;
    }

    // Get the latest data for this tab (generally, from the cache)
    let tabState = TabState.collect(aTab);

    // Don't save private tabs
    let isPrivateWindow = PrivateBrowsingUtils.isWindowPrivate(aWindow);
    if (!isPrivateWindow && tabState.isPrivate) {
      return;
    }

    // Store closed-tab data for undo.
    let tabbrowser = aWindow.gBrowser;
    let tabTitle = this._replaceLoadingTitle(aTab.label, tabbrowser, aTab);
    let {permanentKey} = aTab.linkedBrowser;

    let tabData = {
      permanentKey,
      state: tabState,
      title: tabTitle,
      image: tabbrowser.getIcon(aTab),
      iconLoadingPrincipal: Utils.serializePrincipal(aTab.linkedBrowser.contentPrincipal),
      pos: aTab._tPos,
      closedAt: Date.now()
    };

    let closedTabs = this._windows[aWindow.__SSi]._closedTabs;

    // Determine whether the tab contains any information worth saving. Note
    // that there might be pending state changes queued in the child that
    // didn't reach the parent yet. If a tab is emptied before closing then we
    // might still remove it from the list of closed tabs later.
    if (this._shouldSaveTabState(tabState)) {
      // Save the tab state, for now. We might push a valid tab out
      // of the list but those cases should be extremely rare and
      // do probably never occur when using the browser normally.
      // (Tests or add-ons might do weird things though.)
      this.saveClosedTabData(closedTabs, tabData);
    }

    // Remember the closed tab to properly handle any last updates included in
    // the final "update" message sent by the frame script's unload handler.
    this._closedTabs.set(permanentKey, {closedTabs, tabData});
  },

  /**
   * Insert a given |tabData| object into the list of |closedTabs|. We will
   * determine the right insertion point based on the .closedAt properties of
   * all tabs already in the list. The list will be truncated to contain a
   * maximum of |this._max_tabs_undo| entries.
   *
   * @param closedTabs (array)
   *        The list of closed tabs for a window.
   * @param tabData (object)
   *        The tabData to be inserted.
   */
  saveClosedTabData(closedTabs, tabData) {
    // Find the index of the first tab in the list
    // of closed tabs that was closed before our tab.
    let index = closedTabs.findIndex(tab => {
      return tab.closedAt < tabData.closedAt;
    });

    // If we found no tab closed before our
    // tab then just append it to the list.
    if (index == -1) {
      index = closedTabs.length;
    }

    // About to save the closed tab, add a unique ID.
    tabData.closedId = this._nextClosedId++;

    // Insert tabData at the right position.
    closedTabs.splice(index, 0, tabData);

    // Truncate the list of closed tabs, if needed.
    if (closedTabs.length > this._max_tabs_undo) {
      closedTabs.splice(this._max_tabs_undo, closedTabs.length);
    }
  },

  /**
   * Remove the closed tab data at |index| from the list of |closedTabs|. If
   * the tab's final message is still pending we will simply discard it when
   * it arrives so that the tab doesn't reappear in the list.
   *
   * @param closedTabs (array)
   *        The list of closed tabs for a window.
   * @param index (uint)
   *        The index of the tab to remove.
   */
  removeClosedTabData(closedTabs, index) {
    // Remove the given index from the list.
    let [closedTab] = closedTabs.splice(index, 1);

    // If the closed tab's state still has a .permanentKey property then we
    // haven't seen its final update message yet. Remove it from the map of
    // closed tabs so that we will simply discard its last messages and will
    // not add it back to the list of closed tabs again.
    if (closedTab.permanentKey) {
      this._closedTabs.delete(closedTab.permanentKey);
      this._closedWindowTabs.delete(closedTab.permanentKey);
      delete closedTab.permanentKey;
    }

    return closedTab;
  },

  /**
   * When a tab is selected, save session data
   * @param aWindow
   *        Window reference
   */
  onTabSelect: function ssi_onTabSelect(aWindow) {
    if (RunState.isRunning) {
      this._windows[aWindow.__SSi].selected = aWindow.gBrowser.tabContainer.selectedIndex;

      let tab = aWindow.gBrowser.selectedTab;
      let browser = tab.linkedBrowser;

      if (browser.__SS_restoreState &&
          browser.__SS_restoreState == TAB_STATE_NEEDS_RESTORE) {
        // If __SS_restoreState is still on the browser and it is
        // TAB_STATE_NEEDS_RESTORE, then then we haven't restored
        // this tab yet.
        //
        // It's possible that this tab was recently revived, and that
        // we've deferred showing the tab crashed page for it (if the
        // tab crashed in the background). If so, we need to re-enter
        // the crashed state, since we'll be showing the tab crashed
        // page.
        if (TabCrashHandler.willShowCrashedTab(browser)) {
          this.enterCrashedState(browser);
        } else {
          this.restoreTabContent(tab);
        }
      }
    }
  },

  onTabShow: function ssi_onTabShow(aWindow, aTab) {
    // If the tab hasn't been restored yet, move it into the right bucket
    if (aTab.linkedBrowser.__SS_restoreState &&
        aTab.linkedBrowser.__SS_restoreState == TAB_STATE_NEEDS_RESTORE) {
      TabRestoreQueue.hiddenToVisible(aTab);

      // let's kick off tab restoration again to ensure this tab gets restored
      // with "restore_hidden_tabs" == false (now that it has become visible)
      this.restoreNextTab();
    }

    // Default delay of 2 seconds gives enough time to catch multiple TabShow
    // events. This used to be due to changing groups in 'tab groups'. We
    // might be able to get rid of this now?
    this.saveStateDelayed(aWindow);
  },

  onTabHide: function ssi_onTabHide(aWindow, aTab) {
    // If the tab hasn't been restored yet, move it into the right bucket
    if (aTab.linkedBrowser.__SS_restoreState &&
        aTab.linkedBrowser.__SS_restoreState == TAB_STATE_NEEDS_RESTORE) {
      TabRestoreQueue.visibleToHidden(aTab);
    }

    // Default delay of 2 seconds gives enough time to catch multiple TabHide
    // events. This used to be due to changing groups in 'tab groups'. We
    // might be able to get rid of this now?
    this.saveStateDelayed(aWindow);
  },

  /**
   * Handler for the event that is fired when a <xul:browser> crashes.
   *
   * @param aWindow
   *        The window that the crashed browser belongs to.
   * @param aBrowser
   *        The <xul:browser> that is now in the crashed state.
   */
  onBrowserCrashed: function(aBrowser) {
    NS_ASSERT(aBrowser.isRemoteBrowser,
              "Only remote browsers should be able to crash");

    this.enterCrashedState(aBrowser);
    // The browser crashed so we might never receive flush responses.
    // Resolve all pending flush requests for the crashed browser.
    TabStateFlusher.resolveAll(aBrowser);
  },

  /**
   * Called when a browser is showing or is about to show the tab
   * crashed page. This method causes SessionStore to ignore the
   * tab until it's restored.
   *
   * @param browser
   *        The <xul:browser> that is about to show the crashed page.
   */
  enterCrashedState(browser) {
    this._crashedBrowsers.add(browser.permanentKey);

    let win = browser.ownerGlobal;

    // If we hadn't yet restored, or were still in the midst of
    // restoring this browser at the time of the crash, we need
    // to reset its state so that we can try to restore it again
    // when the user revives the tab from the crash.
    if (browser.__SS_restoreState) {
      let tab = win.gBrowser.getTabForBrowser(browser);
      this._resetLocalTabRestoringState(tab);
    }
  },

  // Clean up data that has been closed a long time ago.
  // Do not reschedule a save. This will wait for the next regular
  // save.
  onIdleDaily: function() {
    // Remove old closed windows
    this._cleanupOldData([this._closedWindows]);

    // Remove closed tabs of closed windows
    this._cleanupOldData(this._closedWindows.map((winData) => winData._closedTabs));

    // Remove closed tabs of open windows
    this._cleanupOldData(Object.keys(this._windows).map((key) => this._windows[key]._closedTabs));
  },

  // Remove "old" data from an array
  _cleanupOldData: function(targets) {
    const TIME_TO_LIVE = this._prefBranch.getIntPref("sessionstore.cleanup.forget_closed_after");
    const now = Date.now();

    for (let array of targets) {
      for (let i = array.length - 1; i >= 0; --i)  {
        let data = array[i];
        // Make sure that we have a timestamp to tell us when the target
        // has been closed. If we don't have a timestamp, default to a
        // safe timestamp: just now.
        data.closedAt = data.closedAt || now;
        if (now - data.closedAt > TIME_TO_LIVE) {
          array.splice(i, 1);
        }
      }
    }
  },

  /* ........ nsISessionStore API .............. */

  getBrowserState: function ssi_getBrowserState() {
    let state = this.getCurrentState();

    // Don't include the last session state in getBrowserState().
    delete state.lastSessionState;

    // Don't include any deferred initial state.
    delete state.deferredInitialState;

    return JSON.stringify(state);
  },

  setBrowserState: function ssi_setBrowserState(aState) {
    this._handleClosedWindows();

    try {
      var state = JSON.parse(aState);
    }
    catch (ex) { /* invalid state object - don't restore anything */ }
    if (!state) {
      throw Components.Exception("Invalid state string: not JSON", Cr.NS_ERROR_INVALID_ARG);
    }
    if (!state.windows) {
      throw Components.Exception("No windows", Cr.NS_ERROR_INVALID_ARG);
    }

    this._browserSetState = true;

    // Make sure the priority queue is emptied out
    this._resetRestoringState();

    var window = this._getMostRecentBrowserWindow();
    if (!window) {
      this._restoreCount = 1;
      this._openWindowWithState(state);
      return;
    }

    // close all other browser windows
    this._forEachBrowserWindow(function(aWindow) {
      if (aWindow != window) {
        aWindow.close();
        this.onClose(aWindow);
      }
    });

    // make sure closed window data isn't kept
    this._closedWindows = [];

    // determine how many windows are meant to be restored
    this._restoreCount = state.windows ? state.windows.length : 0;

    // global data must be restored before restoreWindow is called so that
    // it happens before observers are notified
    this._globalState.setFromState(state);

    // restore to the given state
    this.restoreWindows(window, state, {overwriteTabs: true});
  },

  getWindowState: function ssi_getWindowState(aWindow) {
    if ("__SSi" in aWindow) {
      return JSON.stringify(this._getWindowState(aWindow));
    }

    if (DyingWindowCache.has(aWindow)) {
      let data = DyingWindowCache.get(aWindow);
      return JSON.stringify({ windows: [data] });
    }

    throw Components.Exception("Window is not tracked", Cr.NS_ERROR_INVALID_ARG);
  },

  setWindowState: function ssi_setWindowState(aWindow, aState, aOverwrite) {
    if (!aWindow.__SSi) {
      throw Components.Exception("Window is not tracked", Cr.NS_ERROR_INVALID_ARG);
    }

    this.restoreWindows(aWindow, aState, {overwriteTabs: aOverwrite});
  },

  getTabState: function ssi_getTabState(aTab) {
    if (!aTab.ownerGlobal.__SSi) {
      throw Components.Exception("Default view is not tracked", Cr.NS_ERROR_INVALID_ARG);
    }

    let tabState = TabState.collect(aTab);

    return JSON.stringify(tabState);
  },

  setTabState(aTab, aState) {
    // Remove the tab state from the cache.
    // Note that we cannot simply replace the contents of the cache
    // as |aState| can be an incomplete state that will be completed
    // by |restoreTabs|.
    let tabState = JSON.parse(aState);
    if (!tabState) {
      throw Components.Exception("Invalid state string: not JSON", Cr.NS_ERROR_INVALID_ARG);
    }
    if (typeof tabState != "object") {
      throw Components.Exception("Not an object", Cr.NS_ERROR_INVALID_ARG);
    }
    if (!("entries" in tabState)) {
      throw Components.Exception("Invalid state object: no entries", Cr.NS_ERROR_INVALID_ARG);
    }

    let window = aTab.ownerGlobal;
    if (!("__SSi" in window)) {
      throw Components.Exception("Window is not tracked", Cr.NS_ERROR_INVALID_ARG);
    }

    if (aTab.linkedBrowser.__SS_restoreState) {
      this._resetTabRestoringState(aTab);
    }

    this.restoreTab(aTab, tabState);
  },

  duplicateTab: function ssi_duplicateTab(aWindow, aTab, aDelta = 0, aRestoreImmediately = true) {
    if (!aTab.ownerGlobal.__SSi) {
      throw Components.Exception("Default view is not tracked", Cr.NS_ERROR_INVALID_ARG);
    }
    if (!aWindow.gBrowser) {
      throw Components.Exception("Invalid window object: no gBrowser", Cr.NS_ERROR_INVALID_ARG);
    }

    // Create a new tab.
    let userContextId = aTab.getAttribute("usercontextid");
    let newTab = aTab == aWindow.gBrowser.selectedTab ?
      aWindow.gBrowser.addTab(null, {relatedToCurrent: true, ownerTab: aTab, userContextId}) :
      aWindow.gBrowser.addTab(null, {userContextId});

    // Set tab title to "Connecting..." and start the throbber to pretend we're
    // doing something while actually waiting for data from the frame script.
    aWindow.gBrowser.setTabTitleLoading(newTab);
    newTab.setAttribute("busy", "true");

    // Collect state before flushing.
    let tabState = TabState.clone(aTab);

    // Flush to get the latest tab state to duplicate.
    let browser = aTab.linkedBrowser;
    TabStateFlusher.flush(browser).then(() => {
      // The new tab might have been closed in the meantime.
      if (newTab.closing || !newTab.linkedBrowser) {
        return;
      }

      let window = newTab.ownerGlobal;

      // The tab or its window might be gone.
      if (!window || !window.__SSi) {
        return;
      }

      // Update state with flushed data. We can't use TabState.clone() here as
      // the tab to duplicate may have already been closed. In that case we
      // only have access to the <xul:browser>.
      let options = {includePrivateData: true};
      TabState.copyFromCache(browser, tabState, options);

      tabState.index += aDelta;
      tabState.index = Math.max(1, Math.min(tabState.index, tabState.entries.length));
      tabState.pinned = false;

      // Restore the state into the new tab.
      this.restoreTab(newTab, tabState, {
        restoreImmediately: aRestoreImmediately
      });
    });

    return newTab;
  },

  getClosedTabCount: function ssi_getClosedTabCount(aWindow) {
    if ("__SSi" in aWindow) {
      return this._windows[aWindow.__SSi]._closedTabs.length;
    }

    if (!DyingWindowCache.has(aWindow)) {
      throw Components.Exception("Window is not tracked", Cr.NS_ERROR_INVALID_ARG);
    }

    return DyingWindowCache.get(aWindow)._closedTabs.length;
  },

  getClosedTabData: function ssi_getClosedTabData(aWindow, aAsString = true) {
    if ("__SSi" in aWindow) {
      return aAsString ?
        JSON.stringify(this._windows[aWindow.__SSi]._closedTabs) :
        Cu.cloneInto(this._windows[aWindow.__SSi]._closedTabs, {});
    }

    if (!DyingWindowCache.has(aWindow)) {
      throw Components.Exception("Window is not tracked", Cr.NS_ERROR_INVALID_ARG);
    }

    let data = DyingWindowCache.get(aWindow);
    return aAsString ? JSON.stringify(data._closedTabs) : Cu.cloneInto(data._closedTabs, {});
  },

  undoCloseTab: function ssi_undoCloseTab(aWindow, aIndex) {
    if (!aWindow.__SSi) {
      throw Components.Exception("Window is not tracked", Cr.NS_ERROR_INVALID_ARG);
    }

    var closedTabs = this._windows[aWindow.__SSi]._closedTabs;

    // default to the most-recently closed tab
    aIndex = aIndex || 0;
    if (!(aIndex in closedTabs)) {
      throw Components.Exception("Invalid index: not in the closed tabs", Cr.NS_ERROR_INVALID_ARG);
    }

    // fetch the data of closed tab, while removing it from the array
    let {state, pos} = this.removeClosedTabData(closedTabs, aIndex);

    // create a new tab
    let tabbrowser = aWindow.gBrowser;
    let tab = tabbrowser.selectedTab = tabbrowser.addTab(null, state);

    // restore tab content
    this.restoreTab(tab, state);

    // restore the tab's position
    tabbrowser.moveTabTo(tab, pos);

    // focus the tab's content area (bug 342432)
    tab.linkedBrowser.focus();

    return tab;
  },

  forgetClosedTab: function ssi_forgetClosedTab(aWindow, aIndex) {
    if (!aWindow.__SSi) {
      throw Components.Exception("Window is not tracked", Cr.NS_ERROR_INVALID_ARG);
    }

    var closedTabs = this._windows[aWindow.__SSi]._closedTabs;

    // default to the most-recently closed tab
    aIndex = aIndex || 0;
    if (!(aIndex in closedTabs)) {
      throw Components.Exception("Invalid index: not in the closed tabs", Cr.NS_ERROR_INVALID_ARG);
    }

    // remove closed tab from the array
    this.removeClosedTabData(closedTabs, aIndex);
  },

  getClosedWindowCount: function ssi_getClosedWindowCount() {
    return this._closedWindows.length;
  },

  getClosedWindowData: function ssi_getClosedWindowData(aAsString = true) {
    return aAsString ? JSON.stringify(this._closedWindows) : Cu.cloneInto(this._closedWindows, {});
  },

  undoCloseWindow: function ssi_undoCloseWindow(aIndex) {
    if (!(aIndex in this._closedWindows)) {
      throw Components.Exception("Invalid index: not in the closed windows", Cr.NS_ERROR_INVALID_ARG);
    }

    // reopen the window
    let state = { windows: this._closedWindows.splice(aIndex, 1) };
    delete state.windows[0].closedAt; // Window is now open.

    let window = this._openWindowWithState(state);
    this.windowToFocus = window;
    return window;
  },

  forgetClosedWindow: function ssi_forgetClosedWindow(aIndex) {
    // default to the most-recently closed window
    aIndex = aIndex || 0;
    if (!(aIndex in this._closedWindows)) {
      throw Components.Exception("Invalid index: not in the closed windows", Cr.NS_ERROR_INVALID_ARG);
    }

    // remove closed window from the array
    let winData = this._closedWindows[aIndex];
    this._closedWindows.splice(aIndex, 1);
    this._saveableClosedWindowData.delete(winData);
  },

  getWindowValue: function ssi_getWindowValue(aWindow, aKey) {
    if ("__SSi" in aWindow) {
      var data = this._windows[aWindow.__SSi].extData || {};
      return data[aKey] || "";
    }

    if (DyingWindowCache.has(aWindow)) {
      let data = DyingWindowCache.get(aWindow).extData || {};
      return data[aKey] || "";
    }

    throw Components.Exception("Window is not tracked", Cr.NS_ERROR_INVALID_ARG);
  },

  setWindowValue: function ssi_setWindowValue(aWindow, aKey, aStringValue) {
    if (typeof aStringValue != "string") {
      throw new TypeError("setWindowValue only accepts string values");
    }

    if (!("__SSi" in aWindow)) {
      throw Components.Exception("Window is not tracked", Cr.NS_ERROR_INVALID_ARG);
    }
    if (!this._windows[aWindow.__SSi].extData) {
      this._windows[aWindow.__SSi].extData = {};
    }
    this._windows[aWindow.__SSi].extData[aKey] = aStringValue;
    this.saveStateDelayed(aWindow);
  },

  deleteWindowValue: function ssi_deleteWindowValue(aWindow, aKey) {
    if (aWindow.__SSi && this._windows[aWindow.__SSi].extData &&
        this._windows[aWindow.__SSi].extData[aKey])
      delete this._windows[aWindow.__SSi].extData[aKey];
    this.saveStateDelayed(aWindow);
  },

  getTabValue: function ssi_getTabValue(aTab, aKey) {
    return (aTab.__SS_extdata || {})[aKey] || "";
  },

  setTabValue: function ssi_setTabValue(aTab, aKey, aStringValue) {
    if (typeof aStringValue != "string") {
      throw new TypeError("setTabValue only accepts string values");
    }

    // If the tab hasn't been restored, then set the data there, otherwise we
    // could lose newly added data.
    if (!aTab.__SS_extdata) {
      aTab.__SS_extdata = {};
    }

    aTab.__SS_extdata[aKey] = aStringValue;
    this.saveStateDelayed(aTab.ownerGlobal);
  },

  deleteTabValue: function ssi_deleteTabValue(aTab, aKey) {
    if (aTab.__SS_extdata && aKey in aTab.__SS_extdata) {
      delete aTab.__SS_extdata[aKey];
      this.saveStateDelayed(aTab.ownerGlobal);
    }
  },

  getGlobalValue: function ssi_getGlobalValue(aKey) {
    return this._globalState.get(aKey);
  },

  setGlobalValue: function ssi_setGlobalValue(aKey, aStringValue) {
    if (typeof aStringValue != "string") {
      throw new TypeError("setGlobalValue only accepts string values");
    }

    this._globalState.set(aKey, aStringValue);
    this.saveStateDelayed();
  },

  deleteGlobalValue: function ssi_deleteGlobalValue(aKey) {
    this._globalState.delete(aKey);
    this.saveStateDelayed();
  },

  persistTabAttribute: function ssi_persistTabAttribute(aName) {
    if (TabAttributes.persist(aName)) {
      this.saveStateDelayed();
    }
  },


  /**
   * Undoes the closing of a tab or window which corresponds
   * to the closedId passed in.
   *
   * @param aClosedId
   *        The closedId of the tab or window
   *
   * @returns a tab or window object
   */
  undoCloseById(aClosedId) {
    // Check for a window first.
    for (let i = 0, l = this._closedWindows.length; i < l; i++) {
      if (this._closedWindows[i].closedId == aClosedId) {
        return this.undoCloseWindow(i);
      }
    }

    // Check for a tab.
    let windowsEnum = Services.wm.getEnumerator("navigator:browser");
    while (windowsEnum.hasMoreElements()) {
      let window = windowsEnum.getNext();
      let windowState = this._windows[window.__SSi];
      if (windowState) {
        for (let j = 0, l = windowState._closedTabs.length; j < l; j++) {
          if (windowState._closedTabs[j].closedId == aClosedId) {
            return this.undoCloseTab(window, j);
          }
        }
      }
    }

    // Neither a tab nor a window was found, return undefined and let the caller decide what to do about it.
    return undefined;
  },

  /**
   * Restores the session state stored in LastSession. This will attempt
   * to merge data into the current session. If a window was opened at startup
   * with pinned tab(s), then the remaining data from the previous session for
   * that window will be opened into that window. Otherwise new windows will
   * be opened.
   */
  restoreLastSession: function ssi_restoreLastSession() {
    // Use the public getter since it also checks PB mode
    if (!this.canRestoreLastSession) {
      throw Components.Exception("Last session can not be restored");
    }

    Services.obs.notifyObservers(null, NOTIFY_INITIATING_MANUAL_RESTORE, "");

    // First collect each window with its id...
    let windows = {};
    this._forEachBrowserWindow(function(aWindow) {
      if (aWindow.__SS_lastSessionWindowID)
        windows[aWindow.__SS_lastSessionWindowID] = aWindow;
    });

    let lastSessionState = LastSession.getState();

    // This shouldn't ever be the case...
    if (!lastSessionState.windows.length) {
      throw Components.Exception("lastSessionState has no windows", Cr.NS_ERROR_UNEXPECTED);
    }

    // We're technically doing a restore, so set things up so we send the
    // notification when we're done. We want to send "sessionstore-browser-state-restored".
    this._restoreCount = lastSessionState.windows.length;
    this._browserSetState = true;

    // We want to re-use the last opened window instead of opening a new one in
    // the case where it's "empty" and not associated with a window in the session.
    // We will do more processing via _prepWindowToRestoreInto if we need to use
    // the lastWindow.
    let lastWindow = this._getMostRecentBrowserWindow();
    let canUseLastWindow = lastWindow &&
                           !lastWindow.__SS_lastSessionWindowID;

    // global data must be restored before restoreWindow is called so that
    // it happens before observers are notified
    this._globalState.setFromState(lastSessionState);

    // Restore into windows or open new ones as needed.
    for (let i = 0; i < lastSessionState.windows.length; i++) {
      let winState = lastSessionState.windows[i];
      let lastSessionWindowID = winState.__lastSessionWindowID;
      // delete lastSessionWindowID so we don't add that to the window again
      delete winState.__lastSessionWindowID;

      // See if we can use an open window. First try one that is associated with
      // the state we're trying to restore and then fallback to the last selected
      // window.
      let windowToUse = windows[lastSessionWindowID];
      if (!windowToUse && canUseLastWindow) {
        windowToUse = lastWindow;
        canUseLastWindow = false;
      }

      let [canUseWindow, canOverwriteTabs] = this._prepWindowToRestoreInto(windowToUse);

      // If there's a window already open that we can restore into, use that
      if (canUseWindow) {
        // Since we're not overwriting existing tabs, we want to merge _closedTabs,
        // putting existing ones first. Then make sure we're respecting the max pref.
        if (winState._closedTabs && winState._closedTabs.length) {
          let curWinState = this._windows[windowToUse.__SSi];
          curWinState._closedTabs = curWinState._closedTabs.concat(winState._closedTabs);
          curWinState._closedTabs.splice(this._max_tabs_undo, curWinState._closedTabs.length);
        }

        // Restore into that window - pretend it's a followup since we'll already
        // have a focused window.
        //XXXzpao This is going to merge extData together (taking what was in
        //        winState over what is in the window already.
        let options = {overwriteTabs: canOverwriteTabs, isFollowUp: true};
        this.restoreWindow(windowToUse, winState, options);
      }
      else {
        this._openWindowWithState({ windows: [winState] });
      }
    }

    // Merge closed windows from this session with ones from last session
    if (lastSessionState._closedWindows) {
      this._closedWindows = this._closedWindows.concat(lastSessionState._closedWindows);
      this._capClosedWindows();
    }

    if (lastSessionState.scratchpads) {
      ScratchpadManager.restoreSession(lastSessionState.scratchpads);
    }

    // Set data that persists between sessions
    this._recentCrashes = lastSessionState.session &&
                          lastSessionState.session.recentCrashes || 0;

    // Update the session start time using the restored session state.
    this._updateSessionStartTime(lastSessionState);

    LastSession.clear();
  },

  /**
   * Revive a crashed tab and restore its state from before it crashed.
   *
   * @param aTab
   *        A <xul:tab> linked to a crashed browser. This is a no-op if the
   *        browser hasn't actually crashed, or is not associated with a tab.
   *        This function will also throw if the browser happens to be remote.
   */
  reviveCrashedTab(aTab) {
    if (!aTab) {
      throw new Error("SessionStore.reviveCrashedTab expected a tab, but got null.");
    }

    let browser = aTab.linkedBrowser;
    if (!this._crashedBrowsers.has(browser.permanentKey)) {
      return;
    }

    // Sanity check - the browser to be revived should not be remote
    // at this point.
    if (browser.isRemoteBrowser) {
      throw new Error("SessionStore.reviveCrashedTab: " +
                      "Somehow a crashed browser is still remote.")
    }

    // We put the browser at about:blank in case the user is
    // restoring tabs on demand. This way, the user won't see
    // a flash of the about:tabcrashed page after selecting
    // the revived tab.
    aTab.removeAttribute("crashed");
    browser.loadURI("about:blank", null, null);

    let data = TabState.collect(aTab);
    this.restoreTab(aTab, data, {
      forceOnDemand: true,
    });
  },

  /**
   * Revive all crashed tabs and reset the crashed tabs count to 0.
   */
  reviveAllCrashedTabs() {
    let windowsEnum = Services.wm.getEnumerator("navigator:browser");
    while (windowsEnum.hasMoreElements()) {
      let window = windowsEnum.getNext();
      for (let tab of window.gBrowser.tabs) {
        this.reviveCrashedTab(tab);
      }
    }
  },

  /**
   * Navigate the given |tab| by first collecting its current state and then
   * either changing only the index of the currently shown history entry,
   * or restoring the exact same state again and passing the new URL to load
   * in |loadArguments|. Use this method to seamlessly switch between pages
   * loaded in the parent and pages loaded in the child process.
   *
   * This method might be called multiple times before it has finished
   * flushing the browser tab. If that occurs, the loadArguments from
   * the most recent call to navigateAndRestore will be used once the
   * flush has finished.
   */
  navigateAndRestore(tab, loadArguments, historyIndex) {
    let window = tab.ownerGlobal;
    NS_ASSERT(window.__SSi, "tab's window must be tracked");
    let browser = tab.linkedBrowser;

    // Were we already waiting for a flush from a previous call to
    // navigateAndRestore on this tab?
    let alreadyRestoring =
      this._remotenessChangingBrowsers.has(browser.permanentKey);

    // Stash the most recent loadArguments in this WeakMap so that
    // we know to use it when the TabStateFlusher.flush resolves.
    this._remotenessChangingBrowsers.set(browser.permanentKey, loadArguments);

    if (alreadyRestoring) {
      // This tab was already being restored to run in the
      // correct process. We're done here.
      return;
    }

    // Set tab title to "Connecting..." and start the throbber to pretend we're
    // doing something while actually waiting for data from the frame script.
    window.gBrowser.setTabTitleLoading(tab);
    tab.setAttribute("busy", "true");

    // Flush to get the latest tab state.
    TabStateFlusher.flush(browser).then(() => {
      // loadArguments might have been overwritten by multiple calls
      // to navigateAndRestore while we waited for the tab to flush,
      // so we use the most recently stored one.
      let recentLoadArguments =
        this._remotenessChangingBrowsers.get(browser.permanentKey);
      this._remotenessChangingBrowsers.delete(browser.permanentKey);

      // The tab might have been closed/gone in the meantime.
      if (tab.closing || !tab.linkedBrowser) {
        return;
      }

      let window = tab.ownerGlobal;

      // The tab or its window might be gone.
      if (!window || !window.__SSi || window.closed) {
        return;
      }

      let tabState = TabState.clone(tab);
      let options = {
        restoreImmediately: true,
        // We want to make sure that this information is passed to restoreTab
        // whether or not a historyIndex is passed in. Thus, we extract it from
        // the loadArguments.
        reloadInFreshProcess: !!recentLoadArguments.reloadInFreshProcess,
      };

      if (historyIndex >= 0) {
        tabState.index = historyIndex + 1;
        tabState.index = Math.max(1, Math.min(tabState.index, tabState.entries.length));
      } else {
        options.loadArguments = recentLoadArguments;
      }

      // Need to reset restoring tabs.
      if (tab.linkedBrowser.__SS_restoreState) {
        this._resetLocalTabRestoringState(tab);
      }

      // Restore the state into the tab.
      this.restoreTab(tab, tabState, options);
    });

    tab.linkedBrowser.__SS_restoreState = TAB_STATE_WILL_RESTORE;
  },

  /**
   * Retrieves the latest session history information for a tab. The cached data
   * is returned immediately, but a callback may be provided that supplies
   * up-to-date data when or if it is available. The callback is passed a single
   * argument with data in the same format as the return value.
   *
   * @param tab tab to retrieve the session history for
   * @param updatedCallback function to call with updated data as the single argument
   * @returns a object containing 'index' specifying the current index, and an
   * array 'entries' containing an object for each history item.
   */
  getSessionHistory(tab, updatedCallback) {
    if (updatedCallback) {
      TabStateFlusher.flush(tab.linkedBrowser).then(() => {
        let sessionHistory = this.getSessionHistory(tab);
        if (sessionHistory) {
          updatedCallback(sessionHistory);
        }
      });
    }

    // Don't continue if the tab was closed before TabStateFlusher.flush resolves.
    if (tab.linkedBrowser) {
      let tabState = TabState.collect(tab);
      return { index: tabState.index - 1, entries: tabState.entries }
    }
  },

  /**
   * See if aWindow is usable for use when restoring a previous session via
   * restoreLastSession. If usable, prepare it for use.
   *
   * @param aWindow
   *        the window to inspect & prepare
   * @returns [canUseWindow, canOverwriteTabs]
   *          canUseWindow: can the window be used to restore into
   *          canOverwriteTabs: all of the current tabs are home pages and we
   *                            can overwrite them
   */
  _prepWindowToRestoreInto: function ssi_prepWindowToRestoreInto(aWindow) {
    if (!aWindow)
      return [false, false];

    // We might be able to overwrite the existing tabs instead of just adding
    // the previous session's tabs to the end. This will be set if possible.
    let canOverwriteTabs = false;

    // Look at the open tabs in comparison to home pages. If all the tabs are
    // home pages then we'll end up overwriting all of them. Otherwise we'll
    // just close the tabs that match home pages. Tabs with the about:blank
    // URI will always be overwritten.
    let homePages = ["about:blank"];
    let removableTabs = [];
    let tabbrowser = aWindow.gBrowser;
    let normalTabsLen = tabbrowser.tabs.length - tabbrowser._numPinnedTabs;
    let startupPref = this._prefBranch.getIntPref("startup.page");
    if (startupPref == 1)
      homePages = homePages.concat(aWindow.gHomeButton.getHomePage().split("|"));

    for (let i = tabbrowser._numPinnedTabs; i < tabbrowser.tabs.length; i++) {
      let tab = tabbrowser.tabs[i];
      if (homePages.indexOf(tab.linkedBrowser.currentURI.spec) != -1) {
        removableTabs.push(tab);
      }
    }

    if (tabbrowser.tabs.length == removableTabs.length) {
      canOverwriteTabs = true;
    }
    else {
      // If we're not overwriting all of the tabs, then close the home tabs.
      for (let i = removableTabs.length - 1; i >= 0; i--) {
        tabbrowser.removeTab(removableTabs.pop(), { animate: false });
      }
    }

    return [true, canOverwriteTabs];
  },

  /* ........ Saving Functionality .............. */

  /**
   * Store window dimensions, visibility, sidebar
   * @param aWindow
   *        Window reference
   */
  _updateWindowFeatures: function ssi_updateWindowFeatures(aWindow) {
    var winData = this._windows[aWindow.__SSi];

    WINDOW_ATTRIBUTES.forEach(function(aAttr) {
      winData[aAttr] = this._getWindowDimension(aWindow, aAttr);
    }, this);

    var hidden = WINDOW_HIDEABLE_FEATURES.filter(function(aItem) {
      return aWindow[aItem] && !aWindow[aItem].visible;
    });
    if (hidden.length != 0)
      winData.hidden = hidden.join(",");
    else if (winData.hidden)
      delete winData.hidden;

    var sidebar = aWindow.document.getElementById("sidebar-box").getAttribute("sidebarcommand");
    if (sidebar)
      winData.sidebar = sidebar;
    else if (winData.sidebar)
      delete winData.sidebar;
  },

  /**
   * gather session data as object
   * @param aUpdateAll
   *        Bool update all windows
   * @returns object
   */
  getCurrentState: function (aUpdateAll) {
    this._handleClosedWindows();

    var activeWindow = this._getMostRecentBrowserWindow();

    TelemetryStopwatch.start("FX_SESSION_RESTORE_COLLECT_ALL_WINDOWS_DATA_MS");
    if (RunState.isRunning) {
      // update the data for all windows with activities since the last save operation
      this._forEachBrowserWindow(function(aWindow) {
        if (!this._isWindowLoaded(aWindow)) // window data is still in _statesToRestore
          return;
        if (aUpdateAll || DirtyWindows.has(aWindow) || aWindow == activeWindow) {
          this._collectWindowData(aWindow);
        }
        else { // always update the window features (whose change alone never triggers a save operation)
          this._updateWindowFeatures(aWindow);
        }
      });
      DirtyWindows.clear();
    }
    TelemetryStopwatch.finish("FX_SESSION_RESTORE_COLLECT_ALL_WINDOWS_DATA_MS");

    // An array that at the end will hold all current window data.
    var total = [];
    // The ids of all windows contained in 'total' in the same order.
    var ids = [];
    // The number of window that are _not_ popups.
    var nonPopupCount = 0;
    var ix;

    // collect the data for all windows
    for (ix in this._windows) {
      if (this._windows[ix]._restoring) // window data is still in _statesToRestore
        continue;
      total.push(this._windows[ix]);
      ids.push(ix);
      if (!this._windows[ix].isPopup)
        nonPopupCount++;
    }

    TelemetryStopwatch.start("FX_SESSION_RESTORE_COLLECT_COOKIES_MS");
    SessionCookies.update(total);
    TelemetryStopwatch.finish("FX_SESSION_RESTORE_COLLECT_COOKIES_MS");

    // collect the data for all windows yet to be restored
    for (ix in this._statesToRestore) {
      for (let winData of this._statesToRestore[ix].windows) {
        total.push(winData);
        if (!winData.isPopup)
          nonPopupCount++;
      }
    }

    // shallow copy this._closedWindows to preserve current state
    let lastClosedWindowsCopy = this._closedWindows.slice();

    if (AppConstants.platform != "macosx") {
      // If no non-popup browser window remains open, return the state of the last
      // closed window(s). We only want to do this when we're actually "ending"
      // the session.
      //XXXzpao We should do this for _restoreLastWindow == true, but that has
      //        its own check for popups. c.f. bug 597619
      if (nonPopupCount == 0 && lastClosedWindowsCopy.length > 0 &&
          RunState.isQuitting) {
        // prepend the last non-popup browser window, so that if the user loads more tabs
        // at startup we don't accidentally add them to a popup window
        do {
          total.unshift(lastClosedWindowsCopy.shift())
        } while (total[0].isPopup && lastClosedWindowsCopy.length > 0)
      }
    }

    if (activeWindow) {
      this.activeWindowSSiCache = activeWindow.__SSi || "";
    }
    ix = ids.indexOf(this.activeWindowSSiCache);
    // We don't want to restore focus to a minimized window or a window which had all its
    // tabs stripped out (doesn't exist).
    if (ix != -1 && total[ix] && total[ix].sizemode == "minimized")
      ix = -1;

    let session = {
      lastUpdate: Date.now(),
      startTime: this._sessionStartTime,
      recentCrashes: this._recentCrashes
    };

    let state = {
      version: ["sessionrestore", FORMAT_VERSION],
      windows: total,
      selectedWindow: ix + 1,
      _closedWindows: lastClosedWindowsCopy,
      session: session,
      global: this._globalState.getState()
    };

    if (Cu.isModuleLoaded("resource://devtools/client/scratchpad/scratchpad-manager.jsm")) {
      // get open Scratchpad window states too
      let scratchpads = ScratchpadManager.getSessionState();
      if (scratchpads && scratchpads.length) {
        state.scratchpads = scratchpads;
      }
    }

    // Persist the last session if we deferred restoring it
    if (LastSession.canRestore) {
      state.lastSessionState = LastSession.getState();
    }

    // If we were called by the SessionSaver and started with only a private
    // window we want to pass the deferred initial state to not lose the
    // previous session.
    if (this._deferredInitialState) {
      state.deferredInitialState = this._deferredInitialState;
    }

    return state;
  },

  /**
   * serialize session data for a window
   * @param aWindow
   *        Window reference
   * @returns string
   */
  _getWindowState: function ssi_getWindowState(aWindow) {
    if (!this._isWindowLoaded(aWindow))
      return this._statesToRestore[aWindow.__SS_restoreID];

    if (RunState.isRunning) {
      this._collectWindowData(aWindow);
    }

    let windows = [this._windows[aWindow.__SSi]];
    SessionCookies.update(windows);

    return { windows: windows };
  },

  /**
   * Gathers data about a window and its tabs, and updates its
   * entry in this._windows.
   *
   * @param aWindow
   *        Window references.
   * @returns a Map mapping the browser tabs from aWindow to the tab
   *          entry that was put into the window data in this._windows.
   */
  _collectWindowData: function ssi_collectWindowData(aWindow) {
    let tabMap = new Map();

    if (!this._isWindowLoaded(aWindow))
      return tabMap;

    let tabbrowser = aWindow.gBrowser;
    let tabs = tabbrowser.tabs;
    let winData = this._windows[aWindow.__SSi];
    let tabsData = winData.tabs = [];

    // update the internal state data for this window
    for (let tab of tabs) {
      let tabData = TabState.collect(tab);
      tabMap.set(tab, tabData);
      tabsData.push(tabData);
    }
    winData.selected = tabbrowser.mTabBox.selectedIndex + 1;

    this._updateWindowFeatures(aWindow);

    // Make sure we keep __SS_lastSessionWindowID around for cases like entering
    // or leaving PB mode.
    if (aWindow.__SS_lastSessionWindowID)
      this._windows[aWindow.__SSi].__lastSessionWindowID =
        aWindow.__SS_lastSessionWindowID;

    DirtyWindows.remove(aWindow);
    return tabMap;
  },

  /* ........ Restoring Functionality .............. */

  /**
   * restore features to a single window
   * @param aWindow
   *        Window reference to the window to use for restoration
   * @param winData
   *        JS object
   * @param aOptions
   *        {overwriteTabs: true} to overwrite existing tabs w/ new ones
   *        {isFollowUp: true} if this is not the restoration of the 1st window
   *        {firstWindow: true} if this is the first non-private window we're
   *                            restoring in this session, that might open an
   *                            external link as well
   */
  restoreWindow: function ssi_restoreWindow(aWindow, winData, aOptions = {}) {
    let overwriteTabs = aOptions && aOptions.overwriteTabs;
    let isFollowUp = aOptions && aOptions.isFollowUp;
    let firstWindow = aOptions && aOptions.firstWindow;

    if (isFollowUp) {
      this.windowToFocus = aWindow;
    }

    // initialize window if necessary
    if (aWindow && (!aWindow.__SSi || !this._windows[aWindow.__SSi]))
      this.onLoad(aWindow);

    TelemetryStopwatch.start("FX_SESSION_RESTORE_RESTORE_WINDOW_MS");

    // We're not returning from this before we end up calling restoreTabs
    // for this window, so make sure we send the SSWindowStateBusy event.
    this._setWindowStateBusy(aWindow);

    if (!winData.tabs) {
      winData.tabs = [];
    }

    // don't restore a single blank tab when we've had an external
    // URL passed in for loading at startup (cf. bug 357419)
    else if (firstWindow && !overwriteTabs && winData.tabs.length == 1 &&
             (!winData.tabs[0].entries || winData.tabs[0].entries.length == 0)) {
      winData.tabs = [];
    }

    var tabbrowser = aWindow.gBrowser;
    var openTabCount = overwriteTabs ? tabbrowser.browsers.length : -1;
    var newTabCount = winData.tabs.length;
    var tabs = [];

    // disable smooth scrolling while adding, moving, removing and selecting tabs
    var tabstrip = tabbrowser.tabContainer.mTabstrip;
    var smoothScroll = tabstrip.smoothScroll;
    tabstrip.smoothScroll = false;

    // unpin all tabs to ensure they are not reordered in the next loop
    if (overwriteTabs) {
      for (let t = tabbrowser._numPinnedTabs - 1; t > -1; t--)
        tabbrowser.unpinTab(tabbrowser.tabs[t]);
    }

    // We need to keep track of the initially open tabs so that they
    // can be moved to the end of the restored tabs.
    let initialTabs = [];
    if (!overwriteTabs && firstWindow) {
      initialTabs = Array.slice(tabbrowser.tabs);
    }

    // make sure that the selected tab won't be closed in order to
    // prevent unnecessary flickering
    if (overwriteTabs && tabbrowser.selectedTab._tPos >= newTabCount)
      tabbrowser.moveTabTo(tabbrowser.selectedTab, newTabCount - 1);

    let numVisibleTabs = 0;

    for (var t = 0; t < newTabCount; t++) {
      // When trying to restore into existing tab, we also take the userContextId
      // into account if present.
      let userContextId = winData.tabs[t].userContextId;
      let reuseExisting = t < openTabCount &&
                          (tabbrowser.tabs[t].getAttribute("usercontextid") == (userContextId || ""));
      // If the tab is pinned, then we'll be loading it right away, and
      // there's no need to cause a remoteness flip by loading it initially
      // non-remote.
      let forceNotRemote = !winData.tabs[t].pinned;
      let tab = reuseExisting ? tabbrowser.tabs[t] :
                                tabbrowser.addTab("about:blank",
                                                  {skipAnimation: true,
                                                   forceNotRemote,
                                                   userContextId});

      // If we inserted a new tab because the userContextId didn't match with the
      // open tab, even though `t < openTabCount`, we need to remove that open tab
      // and put the newly added tab in its place.
      if (!reuseExisting && t < openTabCount) {
        tabbrowser.removeTab(tabbrowser.tabs[t]);
        tabbrowser.moveTabTo(tab, t);
      }

      tabs.push(tab);

      if (winData.tabs[t].pinned)
        tabbrowser.pinTab(tabs[t]);

      if (winData.tabs[t].hidden) {
        tabbrowser.hideTab(tabs[t]);
      }
      else {
        tabbrowser.showTab(tabs[t]);
        numVisibleTabs++;
      }

      if (!!winData.tabs[t].muted != tabs[t].linkedBrowser.audioMuted) {
        tabs[t].toggleMuteAudio(winData.tabs[t].muteReason);
      }
    }

    if (!overwriteTabs && firstWindow) {
      // Move the originally open tabs to the end
      let endPosition = tabbrowser.tabs.length - 1;
      for (let i = 0; i < initialTabs.length; i++) {
        tabbrowser.moveTabTo(initialTabs[i], endPosition);
      }
    }

    // if all tabs to be restored are hidden, make the first one visible
    if (!numVisibleTabs && winData.tabs.length) {
      winData.tabs[0].hidden = false;
      tabbrowser.showTab(tabs[0]);
    }

    // If overwriting tabs, we want to reset each tab's "restoring" state. Since
    // we're overwriting those tabs, they should no longer be restoring. The
    // tabs will be rebuilt and marked if they need to be restored after loading
    // state (in restoreTabs).
    if (overwriteTabs) {
      for (let i = 0; i < tabbrowser.tabs.length; i++) {
        let tab = tabbrowser.tabs[i];
        if (tabbrowser.browsers[i].__SS_restoreState)
          this._resetTabRestoringState(tab);
      }
    }

    // We want to correlate the window with data from the last session, so
    // assign another id if we have one. Otherwise clear so we don't do
    // anything with it.
    delete aWindow.__SS_lastSessionWindowID;
    if (winData.__lastSessionWindowID)
      aWindow.__SS_lastSessionWindowID = winData.__lastSessionWindowID;

    // when overwriting tabs, remove all superflous ones
    if (overwriteTabs && newTabCount < openTabCount) {
      Array.slice(tabbrowser.tabs, newTabCount, openTabCount)
           .forEach(tabbrowser.removeTab, tabbrowser);
    }

    if (overwriteTabs) {
      this.restoreWindowFeatures(aWindow, winData);
      delete this._windows[aWindow.__SSi].extData;
    }
    if (winData.cookies) {
      SessionCookies.restore(winData.cookies);
    }
    if (winData.extData) {
      if (!this._windows[aWindow.__SSi].extData) {
        this._windows[aWindow.__SSi].extData = {};
      }
      for (var key in winData.extData) {
        this._windows[aWindow.__SSi].extData[key] = winData.extData[key];
      }
    }

    let newClosedTabsData = winData._closedTabs || [];

    if (overwriteTabs || firstWindow) {
      // Overwrite existing closed tabs data when overwriteTabs=true
      // or we're the first window to be restored.
      this._windows[aWindow.__SSi]._closedTabs = newClosedTabsData;
    } else if (this._max_tabs_undo > 0) {
      // If we merge tabs, we also want to merge closed tabs data. We'll assume
      // the restored tabs were closed more recently and append the current list
      // of closed tabs to the new one...
      newClosedTabsData =
        newClosedTabsData.concat(this._windows[aWindow.__SSi]._closedTabs);

      // ... and make sure that we don't exceed the max number of closed tabs
      // we can restore.
      this._windows[aWindow.__SSi]._closedTabs =
        newClosedTabsData.slice(0, this._max_tabs_undo);
    }

    // Restore tabs, if any.
    if (winData.tabs.length) {
      this.restoreTabs(aWindow, tabs, winData.tabs,
        (overwriteTabs ? (parseInt(winData.selected || "1")) : 0));
    }

    // set smoothScroll back to the original value
    tabstrip.smoothScroll = smoothScroll;

    TelemetryStopwatch.finish("FX_SESSION_RESTORE_RESTORE_WINDOW_MS");

    this._setWindowStateReady(aWindow);

    this._sendWindowRestoredNotification(aWindow);

    Services.obs.notifyObservers(aWindow, NOTIFY_SINGLE_WINDOW_RESTORED, "");

    this._sendRestoreCompletedNotifications();
  },

  /**
   * Restore multiple windows using the provided state.
   * @param aWindow
   *        Window reference to the first window to use for restoration.
   *        Additionally required windows will be opened.
   * @param aState
   *        JS object or JSON string
   * @param aOptions
   *        {overwriteTabs: true} to overwrite existing tabs w/ new ones
   *        {isFollowUp: true} if this is not the restoration of the 1st window
   *        {firstWindow: true} if this is the first non-private window we're
   *                            restoring in this session, that might open an
   *                            external link as well
   */
  restoreWindows: function ssi_restoreWindows(aWindow, aState, aOptions = {}) {
    let isFollowUp = aOptions && aOptions.isFollowUp;

    if (isFollowUp) {
      this.windowToFocus = aWindow;
    }

    // initialize window if necessary
    if (aWindow && (!aWindow.__SSi || !this._windows[aWindow.__SSi]))
      this.onLoad(aWindow);

    let root;
    try {
      root = (typeof aState == "string") ? JSON.parse(aState) : aState;
    }
    catch (ex) { // invalid state object - don't restore anything
      debug(ex);
      this._sendRestoreCompletedNotifications();
      return;
    }

    // Restore closed windows if any.
    if (root._closedWindows) {
      this._closedWindows = root._closedWindows;
    }

    // We're done here if there are no windows.
    if (!root.windows || !root.windows.length) {
      this._sendRestoreCompletedNotifications();
      return;
    }

    if (!root.selectedWindow || root.selectedWindow > root.windows.length) {
      root.selectedWindow = 0;
    }

    // open new windows for all further window entries of a multi-window session
    // (unless they don't contain any tab data)
    let winData;
    for (var w = 1; w < root.windows.length; w++) {
      winData = root.windows[w];
      if (winData && winData.tabs && winData.tabs[0]) {
        var window = this._openWindowWithState({ windows: [winData] });
        if (w == root.selectedWindow - 1) {
          this.windowToFocus = window;
        }
      }
    }

    this.restoreWindow(aWindow, root.windows[0], aOptions);

    if (aState.scratchpads) {
      ScratchpadManager.restoreSession(aState.scratchpads);
    }
  },

  /**
   * Manage history restoration for a window
   * @param aWindow
   *        Window to restore the tabs into
   * @param aTabs
   *        Array of tab references
   * @param aTabData
   *        Array of tab data
   * @param aSelectTab
   *        Index of the tab to select. This is a 1-based index where "1"
   *        indicates the first tab should be selected, and "0" indicates that
   *        the currently selected tab will not be changed.
   */
  restoreTabs(aWindow, aTabs, aTabData, aSelectTab) {
    var tabbrowser = aWindow.gBrowser;

    if (!this._isWindowLoaded(aWindow)) {
      // from now on, the data will come from the actual window
      delete this._statesToRestore[aWindow.__SS_restoreID];
      delete aWindow.__SS_restoreID;
      delete this._windows[aWindow.__SSi]._restoring;
    }

    let numTabsToRestore = aTabs.length;
    let numTabsInWindow = tabbrowser.tabs.length;
    let tabsDataArray = this._windows[aWindow.__SSi].tabs;

    // Update the window state in case we shut down without being notified.
    // Individual tab states will be taken care of by restoreTab() below.
    if (numTabsInWindow == numTabsToRestore) {
      // Remove all previous tab data.
      tabsDataArray.length = 0;
    } else {
      // Remove all previous tab data except tabs that should not be overriden.
      tabsDataArray.splice(numTabsInWindow - numTabsToRestore);
    }

    // Let the tab data array have the right number of slots.
    tabsDataArray.length = numTabsInWindow;

    // If provided, set the selected tab.
    if (aSelectTab > 0 && aSelectTab <= aTabs.length) {
      tabbrowser.selectedTab = aTabs[aSelectTab - 1];

      // Update the window state in case we shut down without being notified.
      this._windows[aWindow.__SSi].selected = aSelectTab;
    }

    // Restore all tabs.
    for (let t = 0; t < aTabs.length; t++) {
      this.restoreTab(aTabs[t], aTabData[t]);
    }
  },

  // Restores the given tab state for a given tab.
  restoreTab(tab, tabData, options = {}) {
    NS_ASSERT(!tab.linkedBrowser.__SS_restoreState,
              "must reset tab before calling restoreTab()");

    let restoreImmediately = options.restoreImmediately;
    let loadArguments = options.loadArguments;
    let browser = tab.linkedBrowser;
    let window = tab.ownerGlobal;
    let tabbrowser = window.gBrowser;
    let forceOnDemand = options.forceOnDemand;
    let reloadInFreshProcess = options.reloadInFreshProcess;

    let willRestoreImmediately = restoreImmediately ||
                                 tabbrowser.selectedBrowser == browser ||
                                 loadArguments;

    if (!willRestoreImmediately && !forceOnDemand) {
      TabRestoreQueue.add(tab);
    }

    this._maybeUpdateBrowserRemoteness({ tabbrowser, tab,
                                         willRestoreImmediately });

    // Increase the busy state counter before modifying the tab.
    this._setWindowStateBusy(window);

    // It's important to set the window state to dirty so that
    // we collect their data for the first time when saving state.
    DirtyWindows.add(window);

    // In case we didn't collect/receive data for any tabs yet we'll have to
    // fill the array with at least empty tabData objects until |_tPos| or
    // we'll end up with |null| entries.
    for (let otherTab of Array.slice(tabbrowser.tabs, 0, tab._tPos)) {
      let emptyState = {entries: [], lastAccessed: otherTab.lastAccessed};
      this._windows[window.__SSi].tabs.push(emptyState);
    }

    // Update the tab state in case we shut down without being notified.
    this._windows[window.__SSi].tabs[tab._tPos] = tabData;

    // Prepare the tab so that it can be properly restored. We'll pin/unpin
    // and show/hide tabs as necessary. We'll also attach a copy of the tab's
    // data in case we close it before it's been restored.
    if (tabData.pinned) {
      tabbrowser.pinTab(tab);
    } else {
      tabbrowser.unpinTab(tab);
    }

    if (tabData.hidden) {
      tabbrowser.hideTab(tab);
    } else {
      tabbrowser.showTab(tab);
    }

    if (!!tabData.muted != browser.audioMuted) {
      tab.toggleMuteAudio(tabData.muteReason);
    }

    if (tabData.lastAccessed) {
      tab.updateLastAccessed(tabData.lastAccessed);
    }

    if ("attributes" in tabData) {
      // Ensure that we persist tab attributes restored from previous sessions.
      Object.keys(tabData.attributes).forEach(a => TabAttributes.persist(a));
    }

    if (!tabData.entries) {
      tabData.entries = [];
    }
    if (tabData.extData) {
      tab.__SS_extdata = Cu.cloneInto(tabData.extData, {});
    } else {
      delete tab.__SS_extdata;
    }

    // Tab is now open.
    delete tabData.closedAt;

    // Ensure the index is in bounds.
    let activeIndex = (tabData.index || tabData.entries.length) - 1;
    activeIndex = Math.min(activeIndex, tabData.entries.length - 1);
    activeIndex = Math.max(activeIndex, 0);

    // Save the index in case we updated it above.
    tabData.index = activeIndex + 1;

    // Start a new epoch to discard all frame script messages relating to a
    // previous epoch. All async messages that are still on their way to chrome
    // will be ignored and don't override any tab data set when restoring.
    let epoch = this.startNextEpoch(browser);

    // keep the data around to prevent dataloss in case
    // a tab gets closed before it's been properly restored
    browser.__SS_restoreState = TAB_STATE_NEEDS_RESTORE;
    browser.setAttribute("pending", "true");
    tab.setAttribute("pending", "true");

    // If we're restoring this tab, it certainly shouldn't be in
    // the ignored set anymore.
    this._crashedBrowsers.delete(browser.permanentKey);

    // Update the persistent tab state cache with |tabData| information.
    TabStateCache.update(browser, {
      history: {entries: tabData.entries, index: tabData.index},
      scroll: tabData.scroll || null,
      storage: tabData.storage || null,
      formdata: tabData.formdata || null,
      disallow: tabData.disallow || null,
      pageStyle: tabData.pageStyle || null,

      // This information is only needed until the tab has finished restoring.
      // When that's done it will be removed from the cache and we always
      // collect it in TabState._collectBaseTabData().
      image: tabData.image || "",
      iconLoadingPrincipal: tabData.iconLoadingPrincipal || null,
      userTypedValue: tabData.userTypedValue || "",
      userTypedClear: tabData.userTypedClear || 0
    });

    browser.messageManager.sendAsyncMessage("SessionStore:restoreHistory",
                                            {tabData: tabData, epoch: epoch, loadArguments});

    // Restore tab attributes.
    if ("attributes" in tabData) {
      TabAttributes.set(tab, tabData.attributes);
    }

    // This could cause us to ignore MAX_CONCURRENT_TAB_RESTORES a bit, but
    // it ensures each window will have its selected tab loaded.
    if (willRestoreImmediately) {
      this.restoreTabContent(tab, loadArguments, reloadInFreshProcess);
    } else if (!forceOnDemand) {
      this.restoreNextTab();
    }

    // Decrease the busy state counter after we're done.
    this._setWindowStateReady(window);
  },

  /**
   * Kicks off restoring the given tab.
   *
   * @param aTab
   *        the tab to restore
   * @param aLoadArguments
   *        optional load arguments used for loadURI()
   * @param aReloadInFreshProcess
   *        true if we want to reload into a fresh process
   */
  restoreTabContent: function (aTab, aLoadArguments = null, aReloadInFreshProcess = false) {
    if (aTab.hasAttribute("customizemode") && !aLoadArguments) {
      return;
    }

    let browser = aTab.linkedBrowser;
    let window = aTab.ownerGlobal;
    let tabbrowser = window.gBrowser;
    let tabData = TabState.clone(aTab);
    let activeIndex = tabData.index - 1;
    let activePageData = tabData.entries[activeIndex] || null;
    let uri = activePageData ? activePageData.url || null : null;
    if (aLoadArguments) {
      uri = aLoadArguments.uri;
      if (aLoadArguments.userContextId) {
        browser.setAttribute("usercontextid", aLoadArguments.userContextId);
      }
    }

    // We have to mark this tab as restoring first, otherwise
    // the "pending" attribute will be applied to the linked
    // browser, which removes it from the display list. We cannot
    // flip the remoteness of any browser that is not being displayed.
    this.markTabAsRestoring(aTab);

    let isRemotenessUpdate = false;
    if (aReloadInFreshProcess) {
      isRemotenessUpdate = tabbrowser.switchBrowserIntoFreshProcess(browser);
    } else {
      isRemotenessUpdate = tabbrowser.updateBrowserRemotenessByURL(browser, uri);
    }

    if (isRemotenessUpdate) {
      // We updated the remoteness, so we need to send the history down again.
      //
      // Start a new epoch to discard all frame script messages relating to a
      // previous epoch. All async messages that are still on their way to chrome
      // will be ignored and don't override any tab data set when restoring.
      let epoch = this.startNextEpoch(browser);

      browser.messageManager.sendAsyncMessage("SessionStore:restoreHistory", {
        tabData: tabData,
        epoch: epoch,
        loadArguments: aLoadArguments,
        isRemotenessUpdate,
      });

    }

    // If the restored browser wants to show view source content, start up a
    // view source browser that will load the required frame script.
    if (uri && ViewSourceBrowser.isViewSource(uri)) {
      new ViewSourceBrowser(browser);
    }

    browser.messageManager.sendAsyncMessage("SessionStore:restoreTabContent",
      {loadArguments: aLoadArguments, isRemotenessUpdate});
  },

  /**
   * Marks a given pending tab as restoring.
   *
   * @param aTab
   *        the pending tab to mark as restoring
   */
  markTabAsRestoring(aTab) {
    let browser = aTab.linkedBrowser;
    if (browser.__SS_restoreState != TAB_STATE_NEEDS_RESTORE) {
      throw new Error("Given tab is not pending.");
    }

    // Make sure that this tab is removed from the priority queue.
    TabRestoreQueue.remove(aTab);

    // Increase our internal count.
    this._tabsRestoringCount++;

    // Set this tab's state to restoring
    browser.__SS_restoreState = TAB_STATE_RESTORING;
    browser.removeAttribute("pending");
    aTab.removeAttribute("pending");
  },

  /**
   * This _attempts_ to restore the next available tab. If the restore fails,
   * then we will attempt the next one.
   * There are conditions where this won't do anything:
   *   if we're in the process of quitting
   *   if there are no tabs to restore
   *   if we have already reached the limit for number of tabs to restore
   */
  restoreNextTab: function ssi_restoreNextTab() {
    // If we call in here while quitting, we don't actually want to do anything
    if (RunState.isQuitting)
      return;

    // Don't exceed the maximum number of concurrent tab restores.
    if (this._tabsRestoringCount >= MAX_CONCURRENT_TAB_RESTORES)
      return;

    let tab = TabRestoreQueue.shift();
    if (tab) {
      this.restoreTabContent(tab);
    }
  },

  /**
   * Restore visibility and dimension features to a window
   * @param aWindow
   *        Window reference
   * @param aWinData
   *        Object containing session data for the window
   */
  restoreWindowFeatures: function ssi_restoreWindowFeatures(aWindow, aWinData) {
    var hidden = (aWinData.hidden)?aWinData.hidden.split(","):[];
    WINDOW_HIDEABLE_FEATURES.forEach(function(aItem) {
      aWindow[aItem].visible = hidden.indexOf(aItem) == -1;
    });

    if (aWinData.isPopup) {
      this._windows[aWindow.__SSi].isPopup = true;
      if (aWindow.gURLBar) {
        aWindow.gURLBar.readOnly = true;
        aWindow.gURLBar.setAttribute("enablehistory", "false");
      }
    }
    else {
      delete this._windows[aWindow.__SSi].isPopup;
      if (aWindow.gURLBar) {
        aWindow.gURLBar.readOnly = false;
        aWindow.gURLBar.setAttribute("enablehistory", "true");
      }
    }

    var _this = this;
    aWindow.setTimeout(function() {
      _this.restoreDimensions.apply(_this, [aWindow,
        +(aWinData.width || 0),
        +(aWinData.height || 0),
        "screenX" in aWinData ? +aWinData.screenX : NaN,
        "screenY" in aWinData ? +aWinData.screenY : NaN,
        aWinData.sizemode || "", aWinData.sidebar || ""]);
    }, 0);
  },

  /**
   * Restore a window's dimensions
   * @param aWidth
   *        Window width
   * @param aHeight
   *        Window height
   * @param aLeft
   *        Window left
   * @param aTop
   *        Window top
   * @param aSizeMode
   *        Window size mode (eg: maximized)
   * @param aSidebar
   *        Sidebar command
   */
  restoreDimensions: function ssi_restoreDimensions(aWindow, aWidth, aHeight, aLeft, aTop, aSizeMode, aSidebar) {
    var win = aWindow;
    var _this = this;
    function win_(aName) { return _this._getWindowDimension(win, aName); }

    // find available space on the screen where this window is being placed
    let screen = gScreenManager.screenForRect(aLeft, aTop, aWidth, aHeight);
    if (screen) {
      let screenLeft = {}, screenTop = {}, screenWidth = {}, screenHeight = {};
      screen.GetAvailRectDisplayPix(screenLeft, screenTop, screenWidth, screenHeight);
      // screenX/Y are based on the origin of the screen's desktop-pixel coordinate space
      let screenLeftCss = screenLeft.value;
      let screenTopCss = screenTop.value;
      // convert screen's device pixel dimensions to CSS px dimensions
      screen.GetAvailRect(screenLeft, screenTop, screenWidth, screenHeight);
      let cssToDevScale = screen.defaultCSSScaleFactor;
      let screenRightCss = screenLeftCss + screenWidth.value / cssToDevScale;
      let screenBottomCss = screenTopCss + screenHeight.value / cssToDevScale;

      // Pull the window within the screen's bounds (allowing a little slop
      // for windows that may be deliberately placed with their border off-screen
      // as when Win10 "snaps" a window to the left/right edge -- bug 1276516).
      // First, ensure the left edge is large enough...
      if (aLeft < screenLeftCss - SCREEN_EDGE_SLOP) {
        aLeft = screenLeftCss;
      }
      // Then check the resulting right edge, and reduce it if necessary.
      let right = aLeft + aWidth;
      if (right > screenRightCss + SCREEN_EDGE_SLOP) {
        right = screenRightCss;
        // See if we can move the left edge leftwards to maintain width.
        if (aLeft > screenLeftCss) {
          aLeft = Math.max(right - aWidth, screenLeftCss);
        }
      }
      // Finally, update aWidth to account for the adjusted left and right edges.
      aWidth = right - aLeft;

      // And do the same in the vertical dimension.
      if (aTop < screenTopCss - SCREEN_EDGE_SLOP) {
        aTop = screenTopCss;
      }
      let bottom = aTop + aHeight;
      if (bottom > screenBottomCss + SCREEN_EDGE_SLOP) {
        bottom = screenBottomCss;
        if (aTop > screenTopCss) {
          aTop = Math.max(bottom - aHeight, screenTopCss);
        }
      }
      aHeight = bottom - aTop;
    }

    // only modify those aspects which aren't correct yet
    if (!isNaN(aLeft) && !isNaN(aTop) && (aLeft != win_("screenX") || aTop != win_("screenY"))) {
      aWindow.moveTo(aLeft, aTop);
    }
    if (aWidth && aHeight && (aWidth != win_("width") || aHeight != win_("height"))) {
      // Don't resize the window if it's currently maximized and we would
      // maximize it again shortly after.
      if (aSizeMode != "maximized" || win_("sizemode") != "maximized") {
        aWindow.resizeTo(aWidth, aHeight);
      }
    }
    if (aSizeMode && win_("sizemode") != aSizeMode)
    {
      switch (aSizeMode)
      {
      case "maximized":
        aWindow.maximize();
        break;
      case "minimized":
        aWindow.minimize();
        break;
      case "normal":
        aWindow.restore();
        break;
      }
    }
    var sidebar = aWindow.document.getElementById("sidebar-box");
    if (sidebar.getAttribute("sidebarcommand") != aSidebar) {
      aWindow.SidebarUI.show(aSidebar);
    }
    // since resizing/moving a window brings it to the foreground,
    // we might want to re-focus the last focused window
    if (this.windowToFocus) {
      this.windowToFocus.focus();
    }
  },

  /* ........ Disk Access .............. */

  /**
   * Save the current session state to disk, after a delay.
   *
   * @param aWindow (optional)
   *        Will mark the given window as dirty so that we will recollect its
   *        data before we start writing.
   */
  saveStateDelayed: function (aWindow = null) {
    if (aWindow) {
      DirtyWindows.add(aWindow);
    }

    SessionSaver.runDelayed();
  },

  /* ........ Auxiliary Functions .............. */

  /**
   * Determines whether or not a tab that is being restored needs
   * to have its remoteness flipped first.
   *
   * @param (object) with the following properties:
   *
   *        tabbrowser (<xul:tabbrowser>):
   *          The tabbrowser that the browser belongs to.
   *
   *        tab (<xul:tab>):
   *          The tab being restored
   *
   *        willRestoreImmediately (bool):
   *          true if the tab is going to have its content
   *          restored immediately by the caller.
   *
   */
  _maybeUpdateBrowserRemoteness({ tabbrowser, tab,
                                  willRestoreImmediately }) {
    // If the browser we're attempting to restore happens to be
    // remote, we need to flip it back to non-remote if it's going
    // to go into the pending background tab state. This is to make
    // sure that a background tab can't crash if it hasn't yet
    // been restored.
    //
    // Normally, when a window is restored, the tabs that SessionStore
    // inserts are non-remote - but the initial browser is, by default,
    // remote, so this check and flip covers this case. The other case
    // is when window state is overwriting the state of an existing
    // window with some remote tabs.
    let browser = tab.linkedBrowser;

    // There are two ways that a tab might start restoring its content
    // very soon - either the caller is going to restore the content
    // immediately, or the TabRestoreQueue is set up so that the tab
    // content is going to be restored in the very near future. In
    // either case, we don't want to flip remoteness, since the browser
    // will soon be loading content.
    let willRestore = willRestoreImmediately ||
                      TabRestoreQueue.willRestoreSoon(tab);

    if (browser.isRemoteBrowser && !willRestore) {
      tabbrowser.updateBrowserRemoteness(browser, false);
    }
  },

  /**
   * Update the session start time and send a telemetry measurement
   * for the number of days elapsed since the session was started.
   *
   * @param state
   *        The session state.
   */
  _updateSessionStartTime: function ssi_updateSessionStartTime(state) {
    // Attempt to load the session start time from the session state
    if (state.session && state.session.startTime) {
      this._sessionStartTime = state.session.startTime;
    }
  },

  /**
   * call a callback for all currently opened browser windows
   * (might miss the most recent one)
   * @param aFunc
   *        Callback each window is passed to
   */
  _forEachBrowserWindow: function ssi_forEachBrowserWindow(aFunc) {
    var windowsEnum = Services.wm.getEnumerator("navigator:browser");

    while (windowsEnum.hasMoreElements()) {
      var window = windowsEnum.getNext();
      if (window.__SSi && !window.closed) {
        aFunc.call(this, window);
      }
    }
  },

  /**
   * Returns most recent window
   * @returns Window reference
   */
  _getMostRecentBrowserWindow: function ssi_getMostRecentBrowserWindow() {
    return RecentWindow.getMostRecentBrowserWindow({ allowPopups: true });
  },

  /**
   * Calls onClose for windows that are determined to be closed but aren't
   * destroyed yet, which would otherwise cause getBrowserState and
   * setBrowserState to treat them as open windows.
   */
  _handleClosedWindows: function ssi_handleClosedWindows() {
    var windowsEnum = Services.wm.getEnumerator("navigator:browser");

    while (windowsEnum.hasMoreElements()) {
      var window = windowsEnum.getNext();
      if (window.closed) {
        this.onClose(window);
      }
    }
  },

  /**
   * open a new browser window for a given session state
   * called when restoring a multi-window session
   * @param aState
   *        Object containing session data
   */
  _openWindowWithState: function ssi_openWindowWithState(aState) {
    var argString = Cc["@mozilla.org/supports-string;1"].
                    createInstance(Ci.nsISupportsString);
    argString.data = "";

    // Build feature string
    let features = "chrome,dialog=no,macsuppressanimation,all";
    let winState = aState.windows[0];
    WINDOW_ATTRIBUTES.forEach(function(aFeature) {
      // Use !isNaN as an easy way to ignore sizemode and check for numbers
      if (aFeature in winState && !isNaN(winState[aFeature]))
        features += "," + aFeature + "=" + winState[aFeature];
    });

    if (winState.isPrivate) {
      features += ",private";
    }

    var window =
      Services.ww.openWindow(null, this._prefBranch.getCharPref("chromeURL"),
                             "_blank", features, argString);

    do {
      var ID = "window" + Math.random();
    } while (ID in this._statesToRestore);
    this._statesToRestore[(window.__SS_restoreID = ID)] = aState;

    return window;
  },

  /**
   * Whether or not to resume session, if not recovering from a crash.
   * @returns bool
   */
  _doResumeSession: function ssi_doResumeSession() {
    return this._prefBranch.getIntPref("startup.page") == 3 ||
           this._prefBranch.getBoolPref("sessionstore.resume_session_once");
  },

  /**
   * whether the user wants to load any other page at startup
   * (except the homepage) - needed for determining whether to overwrite the current tabs
   * C.f.: nsBrowserContentHandler's defaultArgs implementation.
   * @returns bool
   */
  _isCmdLineEmpty: function ssi_isCmdLineEmpty(aWindow, aState) {
    var pinnedOnly = aState.windows &&
                     aState.windows.every(win =>
                       win.tabs.every(tab => tab.pinned));

    let hasFirstArgument = aWindow.arguments && aWindow.arguments[0];
    if (!pinnedOnly) {
      let defaultArgs = Cc["@mozilla.org/browser/clh;1"].
                        getService(Ci.nsIBrowserHandler).defaultArgs;
      if (aWindow.arguments &&
          aWindow.arguments[0] &&
          aWindow.arguments[0] == defaultArgs)
        hasFirstArgument = false;
    }

    return !hasFirstArgument;
  },

  /**
   * on popup windows, the XULWindow's attributes seem not to be set correctly
   * we use thus JSDOMWindow attributes for sizemode and normal window attributes
   * (and hope for reasonable values when maximized/minimized - since then
   * outerWidth/outerHeight aren't the dimensions of the restored window)
   * @param aWindow
   *        Window reference
   * @param aAttribute
   *        String sizemode | width | height | other window attribute
   * @returns string
   */
  _getWindowDimension: function ssi_getWindowDimension(aWindow, aAttribute) {
    if (aAttribute == "sizemode") {
      switch (aWindow.windowState) {
      case aWindow.STATE_FULLSCREEN:
      case aWindow.STATE_MAXIMIZED:
        return "maximized";
      case aWindow.STATE_MINIMIZED:
        return "minimized";
      default:
        return "normal";
      }
    }

    var dimension;
    switch (aAttribute) {
    case "width":
      dimension = aWindow.outerWidth;
      break;
    case "height":
      dimension = aWindow.outerHeight;
      break;
    default:
      dimension = aAttribute in aWindow ? aWindow[aAttribute] : "";
      break;
    }

    if (aWindow.windowState == aWindow.STATE_NORMAL) {
      return dimension;
    }
    return aWindow.document.documentElement.getAttribute(aAttribute) || dimension;
  },

  /**
   * @param aState is a session state
   * @param aRecentCrashes is the number of consecutive crashes
   * @returns whether a restore page will be needed for the session state
   */
  _needsRestorePage: function ssi_needsRestorePage(aState, aRecentCrashes) {
    const SIX_HOURS_IN_MS = 6 * 60 * 60 * 1000;

    // don't display the page when there's nothing to restore
    let winData = aState.windows || null;
    if (!winData || winData.length == 0)
      return false;

    // don't wrap a single about:sessionrestore page
    if (this._hasSingleTabWithURL(winData, "about:sessionrestore") ||
        this._hasSingleTabWithURL(winData, "about:welcomeback")) {
      return false;
    }

    // don't automatically restore in Safe Mode
    if (Services.appinfo.inSafeMode)
      return true;

    let max_resumed_crashes =
      this._prefBranch.getIntPref("sessionstore.max_resumed_crashes");
    let sessionAge = aState.session && aState.session.lastUpdate &&
                     (Date.now() - aState.session.lastUpdate);

    return max_resumed_crashes != -1 &&
           (aRecentCrashes > max_resumed_crashes ||
            sessionAge && sessionAge >= SIX_HOURS_IN_MS);
  },

  /**
   * @param aWinData is the set of windows in session state
   * @param aURL is the single URL we're looking for
   * @returns whether the window data contains only the single URL passed
   */
  _hasSingleTabWithURL: function(aWinData, aURL) {
    if (aWinData &&
        aWinData.length == 1 &&
        aWinData[0].tabs &&
        aWinData[0].tabs.length == 1 &&
        aWinData[0].tabs[0].entries &&
        aWinData[0].tabs[0].entries.length == 1) {
      return aURL == aWinData[0].tabs[0].entries[0].url;
    }
    return false;
  },

  /**
   * Determine if the tab state we're passed is something we should save. This
   * is used when closing a tab or closing a window with a single tab
   *
   * @param aTabState
   *        The current tab state
   * @returns boolean
   */
  _shouldSaveTabState: function ssi_shouldSaveTabState(aTabState) {
    // If the tab has only a transient about: history entry, no other
    // session history, and no userTypedValue, then we don't actually want to
    // store this tab's data.
    return aTabState.entries.length &&
           !(aTabState.entries.length == 1 &&
                (aTabState.entries[0].url == "about:blank" ||
                 aTabState.entries[0].url == "about:newtab" ||
                 aTabState.entries[0].url == "about:privatebrowsing") &&
                 !aTabState.userTypedValue);
  },

  /**
   * This is going to take a state as provided at startup (via
   * nsISessionStartup.state) and split it into 2 parts. The first part
   * (defaultState) will be a state that should still be restored at startup,
   * while the second part (state) is a state that should be saved for later.
   * defaultState will be comprised of windows with only pinned tabs, extracted
   * from state. It will contain the cookies that go along with the history
   * entries in those tabs. It will also contain window position information.
   *
   * defaultState will be restored at startup. state will be passed into
   * LastSession and will be kept in case the user explicitly wants
   * to restore the previous session (publicly exposed as restoreLastSession).
   *
   * @param state
   *        The state, presumably from nsISessionStartup.state
   * @returns [defaultState, state]
   */
  _prepDataForDeferredRestore: function ssi_prepDataForDeferredRestore(state) {
    // Make sure that we don't modify the global state as provided by
    // nsSessionStartup.state.
    state = Cu.cloneInto(state, {});

    let defaultState = { windows: [], selectedWindow: 1 };

    state.selectedWindow = state.selectedWindow || 1;

    // Look at each window, remove pinned tabs, adjust selectedindex,
    // remove window if necessary.
    for (let wIndex = 0; wIndex < state.windows.length;) {
      let window = state.windows[wIndex];
      window.selected = window.selected || 1;
      // We're going to put the state of the window into this object
      let pinnedWindowState = { tabs: [], cookies: []};
      for (let tIndex = 0; tIndex < window.tabs.length;) {
        if (window.tabs[tIndex].pinned) {
          // Adjust window.selected
          if (tIndex + 1 < window.selected)
            window.selected -= 1;
          else if (tIndex + 1 == window.selected)
            pinnedWindowState.selected = pinnedWindowState.tabs.length + 2;
            // + 2 because the tab isn't actually in the array yet

          // Now add the pinned tab to our window
          pinnedWindowState.tabs =
            pinnedWindowState.tabs.concat(window.tabs.splice(tIndex, 1));
          // We don't want to increment tIndex here.
          continue;
        }
        tIndex++;
      }

      // At this point the window in the state object has been modified (or not)
      // We want to build the rest of this new window object if we have pinnedTabs.
      if (pinnedWindowState.tabs.length) {
        // First get the other attributes off the window
        WINDOW_ATTRIBUTES.forEach(function(attr) {
          if (attr in window) {
            pinnedWindowState[attr] = window[attr];
            delete window[attr];
          }
        });
        // We're just copying position data into the pinned window.
        // Not copying over:
        // - _closedTabs
        // - extData
        // - isPopup
        // - hidden

        // Assign a unique ID to correlate the window to be opened with the
        // remaining data
        window.__lastSessionWindowID = pinnedWindowState.__lastSessionWindowID
                                     = "" + Date.now() + Math.random();

        // Extract the cookies that belong with each pinned tab
        this._splitCookiesFromWindow(window, pinnedWindowState);

        // Actually add this window to our defaultState
        defaultState.windows.push(pinnedWindowState);
        // Remove the window from the state if it doesn't have any tabs
        if (!window.tabs.length) {
          if (wIndex + 1 <= state.selectedWindow)
            state.selectedWindow -= 1;
          else if (wIndex + 1 == state.selectedWindow)
            defaultState.selectedIndex = defaultState.windows.length + 1;

          state.windows.splice(wIndex, 1);
          // We don't want to increment wIndex here.
          continue;
        }


      }
      wIndex++;
    }

    return [defaultState, state];
  },

  /**
   * Splits out the cookies from aWinState into aTargetWinState based on the
   * tabs that are in aTargetWinState.
   * This alters the state of aWinState and aTargetWinState.
   */
  _splitCookiesFromWindow:
    function ssi_splitCookiesFromWindow(aWinState, aTargetWinState) {
    if (!aWinState.cookies || !aWinState.cookies.length)
      return;

    // Get the hosts for history entries in aTargetWinState
    let cookieHosts = SessionCookies.getHostsForWindow(aTargetWinState);

    // By creating a regex we reduce overhead and there is only one loop pass
    // through either array (cookieHosts and aWinState.cookies).
    let hosts = Object.keys(cookieHosts).join("|").replace(/\./g, "\\.");
    // If we don't actually have any hosts, then we don't want to do anything.
    if (!hosts.length)
      return;
    let cookieRegex = new RegExp(".*(" + hosts + ")");
    for (let cIndex = 0; cIndex < aWinState.cookies.length;) {
      if (cookieRegex.test(aWinState.cookies[cIndex].host)) {
        aTargetWinState.cookies =
          aTargetWinState.cookies.concat(aWinState.cookies.splice(cIndex, 1));
        continue;
      }
      cIndex++;
    }
  },

  _sendRestoreCompletedNotifications: function ssi_sendRestoreCompletedNotifications() {
    // not all windows restored, yet
    if (this._restoreCount > 1) {
      this._restoreCount--;
      return;
    }

    // observers were already notified
    if (this._restoreCount == -1)
      return;

    // This was the last window restored at startup, notify observers.
    Services.obs.notifyObservers(null,
      this._browserSetState ? NOTIFY_BROWSER_STATE_RESTORED : NOTIFY_WINDOWS_RESTORED,
      "");

    this._browserSetState = false;
    this._restoreCount = -1;
  },

   /**
   * Set the given window's busy state
   * @param aWindow the window
   * @param aValue the window's busy state
   */
  _setWindowStateBusyValue:
    function ssi_changeWindowStateBusyValue(aWindow, aValue) {

    this._windows[aWindow.__SSi].busy = aValue;

    // Keep the to-be-restored state in sync because that is returned by
    // getWindowState() as long as the window isn't loaded, yet.
    if (!this._isWindowLoaded(aWindow)) {
      let stateToRestore = this._statesToRestore[aWindow.__SS_restoreID].windows[0];
      stateToRestore.busy = aValue;
    }
  },

  /**
   * Set the given window's state to 'not busy'.
   * @param aWindow the window
   */
  _setWindowStateReady: function ssi_setWindowStateReady(aWindow) {
    let newCount = (this._windowBusyStates.get(aWindow) || 0) - 1;
    if (newCount < 0) {
      throw new Error("Invalid window busy state (less than zero).");
    }
    this._windowBusyStates.set(aWindow, newCount);

    if (newCount == 0) {
      this._setWindowStateBusyValue(aWindow, false);
      this._sendWindowStateEvent(aWindow, "Ready");
    }
  },

  /**
   * Set the given window's state to 'busy'.
   * @param aWindow the window
   */
  _setWindowStateBusy: function ssi_setWindowStateBusy(aWindow) {
    let newCount = (this._windowBusyStates.get(aWindow) || 0) + 1;
    this._windowBusyStates.set(aWindow, newCount);

    if (newCount == 1) {
      this._setWindowStateBusyValue(aWindow, true);
      this._sendWindowStateEvent(aWindow, "Busy");
    }
  },

  /**
   * Dispatch an SSWindowState_____ event for the given window.
   * @param aWindow the window
   * @param aType the type of event, SSWindowState will be prepended to this string
   */
  _sendWindowStateEvent: function ssi_sendWindowStateEvent(aWindow, aType) {
    let event = aWindow.document.createEvent("Events");
    event.initEvent("SSWindowState" + aType, true, false);
    aWindow.dispatchEvent(event);
  },

  /**
   * Dispatch the SSWindowRestored event for the given window.
   * @param aWindow
   *        The window which has been restored
   */
  _sendWindowRestoredNotification(aWindow) {
    let event = aWindow.document.createEvent("Events");
    event.initEvent("SSWindowRestored", true, false);
    aWindow.dispatchEvent(event);
  },

  /**
   * Dispatch the SSTabRestored event for the given tab.
   * @param aTab
   *        The tab which has been restored
   * @param aIsRemotenessUpdate
   *        True if this tab was restored due to flip from running from
   *        out-of-main-process to in-main-process or vice-versa.
   */
  _sendTabRestoredNotification(aTab, aIsRemotenessUpdate) {
    let event = aTab.ownerDocument.createEvent("CustomEvent");
    event.initCustomEvent("SSTabRestored", true, false, {
      isRemotenessUpdate: aIsRemotenessUpdate,
    });
    aTab.dispatchEvent(event);
  },

  /**
   * @param aWindow
   *        Window reference
   * @returns whether this window's data is still cached in _statesToRestore
   *          because it's not fully loaded yet
   */
  _isWindowLoaded: function ssi_isWindowLoaded(aWindow) {
    return !aWindow.__SS_restoreID;
  },

  /**
   * Replace "Loading..." with the tab label (with minimal side-effects)
   * @param aString is the string the title is stored in
   * @param aTabbrowser is a tabbrowser object, containing aTab
   * @param aTab is the tab whose title we're updating & using
   *
   * @returns aString that has been updated with the new title
   */
  _replaceLoadingTitle : function ssi_replaceLoadingTitle(aString, aTabbrowser, aTab) {
    if (aString == aTabbrowser.mStringBundle.getString("tabs.connecting")) {
      aTabbrowser.setTabTitle(aTab);
      [aString, aTab.label] = [aTab.label, aString];
    }
    return aString;
  },

  /**
   * Resize this._closedWindows to the value of the pref, except in the case
   * where we don't have any non-popup windows on Windows and Linux. Then we must
   * resize such that we have at least one non-popup window.
   */
  _capClosedWindows : function ssi_capClosedWindows() {
    if (this._closedWindows.length <= this._max_windows_undo)
      return;
    let spliceTo = this._max_windows_undo;
    if (AppConstants.platform != "macosx") {
      let normalWindowIndex = 0;
      // try to find a non-popup window in this._closedWindows
      while (normalWindowIndex < this._closedWindows.length &&
             !!this._closedWindows[normalWindowIndex].isPopup)
        normalWindowIndex++;
      if (normalWindowIndex >= this._max_windows_undo)
        spliceTo = normalWindowIndex + 1;
    }
    this._closedWindows.splice(spliceTo, this._closedWindows.length);
  },

  /**
   * Clears the set of windows that are "resurrected" before writing to disk to
   * make closing windows one after the other until shutdown work as expected.
   *
   * This function should only be called when we are sure that there has been
   * a user action that indicates the browser is actively being used and all
   * windows that have been closed before are not part of a series of closing
   * windows.
   */
  _clearRestoringWindows: function ssi_clearRestoringWindows() {
    for (let i = 0; i < this._closedWindows.length; i++) {
      delete this._closedWindows[i]._shouldRestore;
    }
  },

  /**
   * Reset state to prepare for a new session state to be restored.
   */
  _resetRestoringState: function ssi_initRestoringState() {
    TabRestoreQueue.reset();
    this._tabsRestoringCount = 0;
  },

  /**
   * Reset the restoring state for a particular tab. This will be called when
   * removing a tab or when a tab needs to be reset (it's being overwritten).
   *
   * @param aTab
   *        The tab that will be "reset"
   */
  _resetLocalTabRestoringState: function (aTab) {
    NS_ASSERT(aTab.linkedBrowser.__SS_restoreState,
              "given tab is not restoring");

    let browser = aTab.linkedBrowser;

    // Keep the tab's previous state for later in this method
    let previousState = browser.__SS_restoreState;

    // The browser is no longer in any sort of restoring state.
    delete browser.__SS_restoreState;

    aTab.removeAttribute("pending");
    browser.removeAttribute("pending");

    if (previousState == TAB_STATE_RESTORING) {
      if (this._tabsRestoringCount)
        this._tabsRestoringCount--;
    } else if (previousState == TAB_STATE_NEEDS_RESTORE) {
      // Make sure that the tab is removed from the list of tabs to restore.
      // Again, this is normally done in restoreTabContent, but that isn't being called
      // for this tab.
      TabRestoreQueue.remove(aTab);
    }
  },

  _resetTabRestoringState: function (tab) {
    NS_ASSERT(tab.linkedBrowser.__SS_restoreState,
              "given tab is not restoring");

    let browser = tab.linkedBrowser;
    browser.messageManager.sendAsyncMessage("SessionStore:resetRestore", {});
    this._resetLocalTabRestoringState(tab);
  },

  /**
   * Each fresh tab starts out with epoch=0. This function can be used to
   * start a next epoch by incrementing the current value. It will enables us
   * to ignore stale messages sent from previous epochs. The function returns
   * the new epoch ID for the given |browser|.
   */
  startNextEpoch(browser) {
    let next = this.getCurrentEpoch(browser) + 1;
    this._browserEpochs.set(browser.permanentKey, next);
    return next;
  },

  /**
   * Returns the current epoch for the given <browser>. If we haven't assigned
   * a new epoch this will default to zero for new tabs.
   */
  getCurrentEpoch(browser) {
    return this._browserEpochs.get(browser.permanentKey) || 0;
  },

  /**
   * Each time a <browser> element is restored, we increment its "epoch". To
   * check if a message from content-sessionStore.js is out of date, we can
   * compare the epoch received with the message to the <browser> element's
   * epoch. This function does that, and returns true if |epoch| is up-to-date
   * with respect to |browser|.
   */
  isCurrentEpoch: function (browser, epoch) {
    return this.getCurrentEpoch(browser) == epoch;
  },

  /**
   * Resets the epoch for a given <browser>. We need to this every time we
   * receive a hint that a new docShell has been loaded into the browser as
   * the frame script starts out with epoch=0.
   */
  resetEpoch(browser) {
    this._browserEpochs.delete(browser.permanentKey);
  },

  /**
   * Handle an error report from a content process.
   */
  reportInternalError(data) {
    // For the moment, we only report errors through Telemetry.
    if (data.telemetry) {
      for (let key of Object.keys(data.telemetry)) {
        let histogram = Telemetry.getHistogramById(key);
        histogram.add(data.telemetry[key]);
      }
    }
  },

  /**
   * Countdown for a given duration, skipping beats if the computer is too busy,
   * sleeping or otherwise unavailable.
   *
   * @param {number} delay An approximate delay to wait in milliseconds (rounded
   * up to the closest second).
   *
   * @return Promise
   */
  looseTimer(delay) {
    let DELAY_BEAT = 1000;
    let timer = Cc["@mozilla.org/timer;1"].createInstance(Ci.nsITimer);
    let beats = Math.ceil(delay / DELAY_BEAT);
    let promise =  new Promise(resolve => {
      timer.initWithCallback(function() {
        if (beats <= 0) {
          resolve();
        }
        --beats;
      }, DELAY_BEAT, Ci.nsITimer.TYPE_REPEATING_PRECISE_CAN_SKIP);
    });
    // Ensure that the timer is both canceled once we are done with it
    // and not garbage-collected until then.
    promise.then(() => timer.cancel(), () => timer.cancel());
    return promise;
  }
};

/**
 * Priority queue that keeps track of a list of tabs to restore and returns
 * the tab we should restore next, based on priority rules. We decide between
 * pinned, visible and hidden tabs in that and FIFO order. Hidden tabs are only
 * restored with restore_hidden_tabs=true.
 */
var TabRestoreQueue = {
  // The separate buckets used to store tabs.
  tabs: {priority: [], visible: [], hidden: []},

  // Preferences used by the TabRestoreQueue to determine which tabs
  // are restored automatically and which tabs will be on-demand.
  prefs: {
    // Lazy getter that returns whether tabs are restored on demand.
    get restoreOnDemand() {
      let updateValue = () => {
        let value = Services.prefs.getBoolPref(PREF);
        let definition = {value: value, configurable: true};
        Object.defineProperty(this, "restoreOnDemand", definition);
        return value;
      }

      const PREF = "browser.sessionstore.restore_on_demand";
      Services.prefs.addObserver(PREF, updateValue, false);
      return updateValue();
    },

    // Lazy getter that returns whether pinned tabs are restored on demand.
    get restorePinnedTabsOnDemand() {
      let updateValue = () => {
        let value = Services.prefs.getBoolPref(PREF);
        let definition = {value: value, configurable: true};
        Object.defineProperty(this, "restorePinnedTabsOnDemand", definition);
        return value;
      }

      const PREF = "browser.sessionstore.restore_pinned_tabs_on_demand";
      Services.prefs.addObserver(PREF, updateValue, false);
      return updateValue();
    },

    // Lazy getter that returns whether we should restore hidden tabs.
    get restoreHiddenTabs() {
      let updateValue = () => {
        let value = Services.prefs.getBoolPref(PREF);
        let definition = {value: value, configurable: true};
        Object.defineProperty(this, "restoreHiddenTabs", definition);
        return value;
      }

      const PREF = "browser.sessionstore.restore_hidden_tabs";
      Services.prefs.addObserver(PREF, updateValue, false);
      return updateValue();
    }
  },

  // Resets the queue and removes all tabs.
  reset: function () {
    this.tabs = {priority: [], visible: [], hidden: []};
  },

  // Adds a tab to the queue and determines its priority bucket.
  add: function (tab) {
    let {priority, hidden, visible} = this.tabs;

    if (tab.pinned) {
      priority.push(tab);
    } else if (tab.hidden) {
      hidden.push(tab);
    } else {
      visible.push(tab);
    }
  },

  // Removes a given tab from the queue, if it's in there.
  remove: function (tab) {
    let {priority, hidden, visible} = this.tabs;

    // We'll always check priority first since we don't
    // have an indicator if a tab will be there or not.
    let set = priority;
    let index = set.indexOf(tab);

    if (index == -1) {
      set = tab.hidden ? hidden : visible;
      index = set.indexOf(tab);
    }

    if (index > -1) {
      set.splice(index, 1);
    }
  },

  // Returns and removes the tab with the highest priority.
  shift: function () {
    let set;
    let {priority, hidden, visible} = this.tabs;

    let {restoreOnDemand, restorePinnedTabsOnDemand} = this.prefs;
    let restorePinned = !(restoreOnDemand && restorePinnedTabsOnDemand);
    if (restorePinned && priority.length) {
      set = priority;
    } else if (!restoreOnDemand) {
      if (visible.length) {
        set = visible;
      } else if (this.prefs.restoreHiddenTabs && hidden.length) {
        set = hidden;
      }
    }

    return set && set.shift();
  },

  // Moves a given tab from the 'hidden' to the 'visible' bucket.
  hiddenToVisible: function (tab) {
    let {hidden, visible} = this.tabs;
    let index = hidden.indexOf(tab);

    if (index > -1) {
      hidden.splice(index, 1);
      visible.push(tab);
    }
  },

  // Moves a given tab from the 'visible' to the 'hidden' bucket.
  visibleToHidden: function (tab) {
    let {visible, hidden} = this.tabs;
    let index = visible.indexOf(tab);

    if (index > -1) {
      visible.splice(index, 1);
      hidden.push(tab);
    }
  },

  /**
   * Returns true if the passed tab is in one of the sets that we're
   * restoring content in automatically.
   *
   * @param tab (<xul:tab>)
   *        The tab to check
   * @returns bool
   */
  willRestoreSoon: function (tab) {
    let { priority, hidden, visible } = this.tabs;
    let { restoreOnDemand, restorePinnedTabsOnDemand,
          restoreHiddenTabs } = this.prefs;
    let restorePinned = !(restoreOnDemand && restorePinnedTabsOnDemand);
    let candidateSet = [];

    if (restorePinned && priority.length)
      candidateSet.push(...priority);

    if (!restoreOnDemand) {
      if (visible.length)
        candidateSet.push(...visible);

      if (restoreHiddenTabs && hidden.length)
        candidateSet.push(...hidden);
    }

    return candidateSet.indexOf(tab) > -1;
  },
};

// A map storing a closed window's state data until it goes aways (is GC'ed).
// This ensures that API clients can still read (but not write) states of
// windows they still hold a reference to but we don't.
var DyingWindowCache = {
  _data: new WeakMap(),

  has: function (window) {
    return this._data.has(window);
  },

  get: function (window) {
    return this._data.get(window);
  },

  set: function (window, data) {
    this._data.set(window, data);
  },

  remove: function (window) {
    this._data.delete(window);
  }
};

// A weak set of dirty windows. We use it to determine which windows we need to
// recollect data for when getCurrentState() is called.
var DirtyWindows = {
  _data: new WeakMap(),

  has: function (window) {
    return this._data.has(window);
  },

  add: function (window) {
    return this._data.set(window, true);
  },

  remove: function (window) {
    this._data.delete(window);
  },

  clear: function (window) {
    this._data = new WeakMap();
  }
};

// The state from the previous session (after restoring pinned tabs). This
// state is persisted and passed through to the next session during an app
// restart to make the third party add-on warning not trash the deferred
// session
var LastSession = {
  _state: null,

  get canRestore() {
    return !!this._state;
  },

  getState: function () {
    return this._state;
  },

  setState: function (state) {
    this._state = state;
  },

  clear: function () {
    if (this._state) {
      this._state = null;
      Services.obs.notifyObservers(null, NOTIFY_LAST_SESSION_CLEARED, null);
    }
  }
};
