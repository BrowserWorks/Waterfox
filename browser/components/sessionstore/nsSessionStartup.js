/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

/**
 * Session Storage and Restoration
 *
 * Overview
 * This service reads user's session file at startup, and makes a determination
 * as to whether the session should be restored. It will restore the session
 * under the circumstances described below.  If the auto-start Private Browsing
 * mode is active, however, the session is never restored.
 *
 * Crash Detection
 * The CrashMonitor is used to check if the final session state was successfully
 * written at shutdown of the last session. If we did not reach
 * 'sessionstore-final-state-write-complete', then it's assumed that the browser
 * has previously crashed and we should restore the session.
 *
 * Forced Restarts
 * In the event that a restart is required due to application update or extension
 * installation, set the browser.sessionstore.resume_session_once pref to true,
 * and the session will be restored the next time the browser starts.
 *
 * Always Resume
 * This service will always resume the session if the integer pref
 * browser.startup.page is set to 3.
 */

/* :::::::: Constants and Helpers ::::::::::::::: */

const Cc = Components.classes;
const Ci = Components.interfaces;
const Cr = Components.results;
const Cu = Components.utils;
Cu.import("resource://gre/modules/XPCOMUtils.jsm");
Cu.import("resource://gre/modules/Services.jsm");
Cu.import("resource://gre/modules/Promise.jsm");

XPCOMUtils.defineLazyModuleGetter(this, "console",
  "resource://gre/modules/Console.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "SessionFile",
  "resource:///modules/sessionstore/SessionFile.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "CrashMonitor",
  "resource://gre/modules/CrashMonitor.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "PrivateBrowsingUtils",
  "resource://gre/modules/PrivateBrowsingUtils.jsm");

const STATE_RUNNING_STR = "running";

// 'browser.startup.page' preference value to resume the previous session.
const BROWSER_STARTUP_RESUME_SESSION = 3;

function debug(aMsg) {
  aMsg = ("SessionStartup: " + aMsg).replace(/\S{80}/g, "$&\n");
  Services.console.logStringMessage(aMsg);
}
function warning(aMsg, aException) {
  let consoleMsg = Cc["@mozilla.org/scripterror;1"].createInstance(Ci.nsIScriptError);
consoleMsg.init(aMsg, aException.fileName, null, aException.lineNumber, 0, Ci.nsIScriptError.warningFlag, "component javascript");
  Services.console.logMessage(consoleMsg);
}

var gOnceInitializedDeferred = (function() {
  let deferred = {};

  deferred.promise = new Promise((resolve, reject) => {
    deferred.resolve = resolve;
    deferred.reject = reject;
  });

  return deferred;
})();

/* :::::::: The Service ::::::::::::::: */

function SessionStartup() {
}

SessionStartup.prototype = {

  // the state to restore at startup
  _initialState: null,
  _sessionType: Ci.nsISessionStartup.NO_SESSION,
  _initialized: false,

  // Stores whether the previous session crashed.
  _previousSessionCrashed: null,

/* ........ Global Event Handlers .............. */

  /**
   * Initialize the component
   */
  init: function sss_init() {
    Services.obs.notifyObservers(null, "sessionstore-init-started");

    // do not need to initialize anything in auto-started private browsing sessions
    if (PrivateBrowsingUtils.permanentPrivateBrowsing) {
      this._initialized = true;
      gOnceInitializedDeferred.resolve();
      return;
    }

    SessionFile.read().then(
      this._onSessionFileRead.bind(this),
      console.error
    );
  },

  // Wrap a string as a nsISupports
  _createSupportsString: function ssfi_createSupportsString(aData) {
    let string = Cc["@mozilla.org/supports-string;1"]
                   .createInstance(Ci.nsISupportsString);
    string.data = aData;
    return string;
  },

  /**
   * Complete initialization once the Session File has been read
   *
   * @param source The Session State string read from disk.
   * @param parsed The object obtained by parsing |source| as JSON.
   */
  _onSessionFileRead({source, parsed, noFilesFound}) {
    this._initialized = true;

    // Let observers modify the state before it is used
    let supportsStateString = this._createSupportsString(source);
    Services.obs.notifyObservers(supportsStateString, "sessionstore-state-read");
    let stateString = supportsStateString.data;

    if (stateString != source) {
      // The session has been modified by an add-on, reparse.
      try {
        this._initialState = JSON.parse(stateString);
      } catch (ex) {
        // That's not very good, an add-on has rewritten the initial
        // state to something that won't parse.
        warning("Observer rewrote the state to something that won't parse", ex);
      }
    } else {
      // No need to reparse
      this._initialState = parsed;
    }

    if (this._initialState == null) {
      // No valid session found.
      this._sessionType = Ci.nsISessionStartup.NO_SESSION;
      Services.obs.notifyObservers(null, "sessionstore-state-finalized");
      gOnceInitializedDeferred.resolve();
      return;
    }

    let shouldResumeSessionOnce = Services.prefs.getBoolPref("browser.sessionstore.resume_session_once");
    let shouldResumeSession = shouldResumeSessionOnce ||
          Services.prefs.getIntPref("browser.startup.page") == BROWSER_STARTUP_RESUME_SESSION;

    // If this is a normal restore then throw away any previous session
    if (!shouldResumeSessionOnce && this._initialState) {
      delete this._initialState.lastSessionState;
    }

    let resumeFromCrash = Services.prefs.getBoolPref("browser.sessionstore.resume_from_crash");

    CrashMonitor.previousCheckpoints.then(checkpoints => {
      if (checkpoints) {
        // If the previous session finished writing the final state, we'll
        // assume there was no crash.
        this._previousSessionCrashed = !checkpoints["sessionstore-final-state-write-complete"];
      } else if (noFilesFound) {
        // If the Crash Monitor could not load a checkpoints file it will
        // provide null. This could occur on the first run after updating to
        // a version including the Crash Monitor, or if the checkpoints file
        // was removed, or on first startup with this profile, or after Firefox Reset.

        // There was no checkpoints file and no sessionstore.js or its backups
        // so we will assume that this was a fresh profile.
        this._previousSessionCrashed = false;
      } else {
        // If this is the first run after an update, sessionstore.js should
        // still contain the session.state flag to indicate if the session
        // crashed. If it is not present, we will assume this was not the first
        // run after update and the checkpoints file was somehow corrupted or
        // removed by a crash.
        //
        // If the session.state flag is present, we will fallback to using it
        // for crash detection - If the last write of sessionstore.js had it
        // set to "running", we crashed.
        let stateFlagPresent = (this._initialState.session &&
                                this._initialState.session.state);

        this._previousSessionCrashed = !stateFlagPresent ||
          (this._initialState.session.state == STATE_RUNNING_STR);
      }

      // Report shutdown success via telemetry. Shortcoming here are
      // being-killed-by-OS-shutdown-logic, shutdown freezing after
      // session restore was written, etc.
      Services.telemetry.getHistogramById("SHUTDOWN_OK").add(!this._previousSessionCrashed);

      // set the startup type
      if (this._previousSessionCrashed && resumeFromCrash)
        this._sessionType = Ci.nsISessionStartup.RECOVER_SESSION;
      else if (!this._previousSessionCrashed && shouldResumeSession)
        this._sessionType = Ci.nsISessionStartup.RESUME_SESSION;
      else if (this._initialState)
        this._sessionType = Ci.nsISessionStartup.DEFER_SESSION;
      else
        this._initialState = null; // reset the state

      Services.obs.addObserver(this, "sessionstore-windows-restored", true);

      if (this._sessionType != Ci.nsISessionStartup.NO_SESSION)
        Services.obs.addObserver(this, "browser:purge-session-history", true);

      // We're ready. Notify everyone else.
      Services.obs.notifyObservers(null, "sessionstore-state-finalized");
      gOnceInitializedDeferred.resolve();
    });
  },

  /**
   * Handle notifications
   */
  observe: function sss_observe(aSubject, aTopic, aData) {
    switch (aTopic) {
    case "app-startup":
      Services.obs.addObserver(this, "final-ui-startup", true);
      Services.obs.addObserver(this, "quit-application", true);
      break;
    case "final-ui-startup":
      Services.obs.removeObserver(this, "final-ui-startup");
      Services.obs.removeObserver(this, "quit-application");
      this.init();
      break;
    case "quit-application":
      // no reason for initializing at this point (cf. bug 409115)
      Services.obs.removeObserver(this, "final-ui-startup");
      Services.obs.removeObserver(this, "quit-application");
      if (this._sessionType != Ci.nsISessionStartup.NO_SESSION)
        Services.obs.removeObserver(this, "browser:purge-session-history");
      break;
    case "sessionstore-windows-restored":
      Services.obs.removeObserver(this, "sessionstore-windows-restored");
      // free _initialState after nsSessionStore is done with it
      this._initialState = null;
      break;
    case "browser:purge-session-history":
      Services.obs.removeObserver(this, "browser:purge-session-history");
      // reset all state on sanitization
      this._sessionType = Ci.nsISessionStartup.NO_SESSION;
      break;
    }
  },

/* ........ Public API ................*/

  get onceInitialized() {
    return gOnceInitializedDeferred.promise;
  },

  /**
   * Get the session state as a jsval
   */
  get state() {
    return this._initialState;
  },

  /**
   * Determines whether there is a pending session restore. Should only be
   * called after initialization has completed.
   * @returns bool
   */
  doRestore: function sss_doRestore() {
    return this._willRestore();
  },

  /**
   * Determines whether automatic session restoration is enabled for this
   * launch of the browser. This does not include crash restoration. In
   * particular, if session restore is configured to restore only in case of
   * crash, this method returns false.
   * @returns bool
   */
  isAutomaticRestoreEnabled() {
    return Services.prefs.getBoolPref("browser.sessionstore.resume_session_once") ||
           Services.prefs.getIntPref("browser.startup.page") == BROWSER_STARTUP_RESUME_SESSION;
  },

  /**
   * Determines whether there is a pending session restore.
   * @returns bool
   */
  _willRestore() {
    return this._sessionType == Ci.nsISessionStartup.RECOVER_SESSION ||
           this._sessionType == Ci.nsISessionStartup.RESUME_SESSION;
  },

  /**
   * Returns whether we will restore a session that ends up replacing the
   * homepage. The browser uses this to not start loading the homepage if
   * we're going to stop its load anyway shortly after.
   *
   * This is meant to be an optimization for the average case that loading the
   * session file finishes before we may want to start loading the default
   * homepage. Should this be called before the session file has been read it
   * will just return false.
   *
   * @returns bool
   */
  get willOverrideHomepage() {
    if (this._initialState && this._willRestore()) {
      let windows = this._initialState.windows || null;
      // If there are valid windows with not only pinned tabs, signal that we
      // will override the default homepage by restoring a session.
      return windows && windows.some(w => w.tabs.some(t => !t.pinned));
    }
    return false;
  },

  /**
   * Get the type of pending session store, if any.
   */
  get sessionType() {
    return this._sessionType;
  },

  /**
   * Get whether the previous session crashed.
   */
  get previousSessionCrashed() {
    return this._previousSessionCrashed;
  },

  /* ........ QueryInterface .............. */
  QueryInterface: XPCOMUtils.generateQI([Ci.nsIObserver,
                                         Ci.nsISupportsWeakReference,
                                         Ci.nsISessionStartup]),
  classID: Components.ID("{ec7a6c20-e081-11da-8ad9-0800200c9a66}")
};

this.NSGetFactory = XPCOMUtils.generateNSGetFactory([SessionStartup]);
