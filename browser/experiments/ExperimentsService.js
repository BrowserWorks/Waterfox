/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const {interfaces: Ci, utils: Cu} = Components;

Cu.import("resource://gre/modules/XPCOMUtils.jsm");
Cu.import("resource://gre/modules/Services.jsm");

XPCOMUtils.defineLazyModuleGetter(this, "Experiments",
                                  "resource:///modules/experiments/Experiments.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "OS",
                                  "resource://gre/modules/osfile.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "CommonUtils",
                                  "resource://services-common/utils.js");
XPCOMUtils.defineLazyModuleGetter(this, "TelemetryUtils",
                                  "resource://gre/modules/TelemetryUtils.jsm");


const PREF_EXPERIMENTS_ENABLED  = "experiments.enabled";
const PREF_ACTIVE_EXPERIMENT    = "experiments.activeExperiment"; // whether we have an active experiment
const DELAY_INIT_MS             = 30 * 1000;

function ExperimentsService() {
  this._initialized = false;
  this._delayedInitTimer = null;
}

ExperimentsService.prototype = {
  classID: Components.ID("{f7800463-3b97-47f9-9341-b7617e6d8d49}"),
  QueryInterface: XPCOMUtils.generateQI([Ci.nsITimerCallback, Ci.nsIObserver]),

  get _experimentsEnabled() {
    // We can enable experiments if either unified Telemetry or FHR is on, and the user
    // has opted into Telemetry.
    return Services.prefs.getBoolPref(PREF_EXPERIMENTS_ENABLED, false) &&
           TelemetryUtils.isTelemetryEnabled;
  },

  notify(timer) {
    if (!this._experimentsEnabled) {
      return;
    }
    if (OS.Constants.Path.profileDir === undefined) {
      throw Error("Update timer fired before profile was initialized?");
    }
    let instance = Experiments.instance();
    if (instance.isReady) {
      instance.updateManifest().catch(error => {
        // Don't throw, as this breaks tests. In any case the best we can do here
        // is to log the failure.
        Cu.reportError(error);
      });
    }
  },

  _delayedInit() {
    if (!this._initialized) {
      this._initialized = true;
      Experiments.instance(); // for side effects
    }
  },

  observe(subject, topic, data) {
    switch (topic) {
      case "profile-after-change":
        if (this._experimentsEnabled) {
          Services.obs.addObserver(this, "quit-application");
          Services.obs.addObserver(this, "sessionstore-state-finalized");
          Services.obs.addObserver(this, "EM-loaded");

          if (Services.prefs.getBoolPref(PREF_ACTIVE_EXPERIMENT, false)) {
            this._initialized = true;
            Experiments.instance(); // for side effects
          }
        }
        break;
      case "sessionstore-state-finalized":
        if (!this._initialized) {
          CommonUtils.namedTimer(this._delayedInit, DELAY_INIT_MS, this, "_delayedInitTimer");
        }
        break;
      case "EM-loaded":
        if (!this._initialized) {
          Experiments.instance(); // for side effects
          this._initialized = true;

          if (this._delayedInitTimer) {
            this._delayedInitTimer.clear();
          }
        }
        break;
      case "quit-application":
        Services.obs.removeObserver(this, "quit-application");
        Services.obs.removeObserver(this, "sessionstore-state-finalized");
        Services.obs.removeObserver(this, "EM-loaded");
        if (this._delayedInitTimer) {
          this._delayedInitTimer.clear();
        }
        break;
    }
  },
};

this.NSGetFactory = XPCOMUtils.generateNSGetFactory([ExperimentsService]);
