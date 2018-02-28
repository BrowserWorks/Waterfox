/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

this.EXPORTED_SYMBOLS = [
  "EngineManager",
  "Engine",
  "SyncEngine",
  "Tracker",
  "Store",
  "Changeset"
];

var {classes: Cc, interfaces: Ci, results: Cr, utils: Cu} = Components;

Cu.import("resource://gre/modules/XPCOMUtils.jsm");
Cu.import("resource://gre/modules/JSONFile.jsm");
Cu.import("resource://gre/modules/Log.jsm");
Cu.import("resource://services-common/async.js");
Cu.import("resource://services-common/observers.js");
Cu.import("resource://services-sync/constants.js");
Cu.import("resource://services-sync/record.js");
Cu.import("resource://services-sync/resource.js");
Cu.import("resource://services-sync/util.js");

XPCOMUtils.defineLazyModuleGetter(this, "fxAccounts",
  "resource://gre/modules/FxAccounts.jsm");
XPCOMUtils.defineLazyModuleGetter(this, "OS",
                                  "resource://gre/modules/osfile.jsm");

/*
 * Trackers are associated with a single engine and deal with
 * listening for changes to their particular data type.
 *
 * There are two things they keep track of:
 * 1) A score, indicating how urgently the engine wants to sync
 * 2) A list of IDs for all the changed items that need to be synced
 * and updating their 'score', indicating how urgently they
 * want to sync.
 *
 */
this.Tracker = function Tracker(name, engine) {
  if (!engine) {
    throw new Error("Tracker must be associated with an Engine instance.");
  }

  name = name || "Unnamed";
  this.name = this.file = name.toLowerCase();
  this.engine = engine;

  this._log = Log.repository.getLogger("Sync.Tracker." + name);
  let level = Svc.Prefs.get("log.logger.engine." + this.name, "Debug");
  this._log.level = Log.Level[level];

  this._score = 0;
  this._ignored = [];
  this._storage = new JSONFile({
    path: Utils.jsonFilePath("changes/" + this.file),
    // We use arrow functions instead of `.bind(this)` so that tests can
    // easily override these hooks.
    dataPostProcessor: json => this._dataPostProcessor(json),
    beforeSave: () => this._beforeSave(),
  });
  this.ignoreAll = false;

  Svc.Obs.add("weave:engine:start-tracking", this);
  Svc.Obs.add("weave:engine:stop-tracking", this);

  Svc.Prefs.observe("engine." + this.engine.prefName, this);
};

Tracker.prototype = {
  /*
   * Score can be called as often as desired to decide which engines to sync
   *
   * Valid values for score:
   * -1: Do not sync unless the user specifically requests it (almost disabled)
   * 0: Nothing has changed
   * 100: Please sync me ASAP!
   *
   * Setting it to other values should (but doesn't currently) throw an exception
   */
  get score() {
    return this._score;
  },

  // Default to an empty object if the file doesn't exist.
  _dataPostProcessor(json) {
    return typeof json == "object" && json || {};
  },

  // Ensure the Weave storage directory exists before writing the file.
  _beforeSave() {
    let basename = OS.Path.dirname(this._storage.path);
    return OS.File.makeDir(basename, { from: OS.Constants.Path.profileDir });
  },

  get changedIDs() {
    Async.promiseSpinningly(this._storage.load());
    return this._storage.data;
  },

  set score(value) {
    this._score = value;
    Observers.notify("weave:engine:score:updated", this.name);
  },

  // Should be called by service everytime a sync has been done for an engine
  resetScore() {
    this._score = 0;
  },

  persistChangedIDs: true,

  _saveChangedIDs() {
    if (!this.persistChangedIDs) {
      this._log.debug("Not saving changedIDs.");
      return;
    }
    this._storage.saveSoon();
  },

  // ignore/unignore specific IDs.  Useful for ignoring items that are
  // being processed, or that shouldn't be synced.
  // But note: not persisted to disk

  ignoreID(id) {
    this.unignoreID(id);
    this._ignored.push(id);
  },

  unignoreID(id) {
    let index = this._ignored.indexOf(id);
    if (index != -1)
      this._ignored.splice(index, 1);
  },

  _saveChangedID(id, when) {
    this._log.trace(`Adding changed ID: ${id}, ${JSON.stringify(when)}`);
    this.changedIDs[id] = when;
    this._saveChangedIDs();
  },

  addChangedID(id, when) {
    if (!id) {
      this._log.warn("Attempted to add undefined ID to tracker");
      return false;
    }

    if (this.ignoreAll || this._ignored.includes(id)) {
      return false;
    }

    // Default to the current time in seconds if no time is provided.
    if (when == null) {
      when = this._now();
    }

    // Add/update the entry if we have a newer time.
    if ((this.changedIDs[id] || -Infinity) < when) {
      this._saveChangedID(id, when);
    }

    return true;
  },

  removeChangedID(...ids) {
    if (!ids.length || this.ignoreAll) {
      return false;
    }
    for (let id of ids) {
      if (!id) {
        this._log.warn("Attempted to remove undefined ID from tracker");
        continue;
      }
      if (this._ignored.includes(id)) {
        this._log.debug(`Not removing ignored ID ${id} from tracker`);
        continue;
      }
      if (this.changedIDs[id] != null) {
        this._log.trace("Removing changed ID " + id);
        delete this.changedIDs[id];
      }
    }
    this._saveChangedIDs();
    return true;
  },

  clearChangedIDs() {
    this._log.trace("Clearing changed ID list");
    this._storage.data = {};
    this._saveChangedIDs();
  },

  _now() {
    return Date.now() / 1000;
  },

  _isTracking: false,

  // Override these in your subclasses.
  startTracking() {
  },

  stopTracking() {
  },

  engineIsEnabled() {
    if (!this.engine) {
      // Can't tell -- we must be running in a test!
      return true;
    }
    return this.engine.enabled;
  },

  onEngineEnabledChanged(engineEnabled) {
    if (engineEnabled == this._isTracking) {
      return;
    }

    if (engineEnabled) {
      this.startTracking();
      this._isTracking = true;
    } else {
      this.stopTracking();
      this._isTracking = false;
      this.clearChangedIDs();
    }
  },

  observe(subject, topic, data) {
    switch (topic) {
      case "weave:engine:start-tracking":
        if (!this.engineIsEnabled()) {
          return;
        }
        this._log.trace("Got start-tracking.");
        if (!this._isTracking) {
          this.startTracking();
          this._isTracking = true;
        }
        return;
      case "weave:engine:stop-tracking":
        this._log.trace("Got stop-tracking.");
        if (this._isTracking) {
          this.stopTracking();
          this._isTracking = false;
        }
        return;
      case "nsPref:changed":
        if (data == PREFS_BRANCH + "engine." + this.engine.prefName) {
          this.onEngineEnabledChanged(this.engine.enabled);
        }
    }
  },

  async finalize() {
    // Stop listening for tracking and engine enabled change notifications.
    // Important for tests where we unregister the engine during cleanup.
    Svc.Obs.remove("weave:engine:start-tracking", this);
    Svc.Obs.remove("weave:engine:stop-tracking", this);
    Svc.Prefs.ignore("engine." + this.engine.prefName, this);

    // Persist all pending tracked changes to disk, and wait for the final write
    // to finish.
    this._saveChangedIDs();
    await this._storage.finalize();
  },
};



/**
 * The Store serves as the interface between Sync and stored data.
 *
 * The name "store" is slightly a misnomer because it doesn't actually "store"
 * anything. Instead, it serves as a gateway to something that actually does
 * the "storing."
 *
 * The store is responsible for record management inside an engine. It tells
 * Sync what items are available for Sync, converts items to and from Sync's
 * record format, and applies records from Sync into changes on the underlying
 * store.
 *
 * Store implementations require a number of functions to be implemented. These
 * are all documented below.
 *
 * For stores that deal with many records or which have expensive store access
 * routines, it is highly recommended to implement a custom applyIncomingBatch
 * and/or applyIncoming function on top of the basic APIs.
 */

this.Store = function Store(name, engine) {
  if (!engine) {
    throw new Error("Store must be associated with an Engine instance.");
  }

  name = name || "Unnamed";
  this.name = name.toLowerCase();
  this.engine = engine;

  this._log = Log.repository.getLogger("Sync.Store." + name);
  let level = Svc.Prefs.get("log.logger.engine." + this.name, "Debug");
  this._log.level = Log.Level[level];

  XPCOMUtils.defineLazyGetter(this, "_timer", function() {
    return Cc["@mozilla.org/timer;1"].createInstance(Ci.nsITimer);
  });
}
Store.prototype = {

  /**
   * Apply multiple incoming records against the store.
   *
   * This is called with a set of incoming records to process. The function
   * should look at each record, reconcile with the current local state, and
   * make the local changes required to bring its state in alignment with the
   * record.
   *
   * The default implementation simply iterates over all records and calls
   * applyIncoming(). Store implementations may overwrite this function
   * if desired.
   *
   * @param  records Array of records to apply
   * @return Array of record IDs which did not apply cleanly
   */
  async applyIncomingBatch(records) {
    let failed = [];
    let maybeYield = Async.jankYielder();
    for (let record of records) {
      await maybeYield();
      try {
        await this.applyIncoming(record);
      } catch (ex) {
        if (ex.code == Engine.prototype.eEngineAbortApplyIncoming) {
          // This kind of exception should have a 'cause' attribute, which is an
          // originating exception.
          // ex.cause will carry its stack with it when rethrown.
          throw ex.cause;
        }
        if (Async.isShutdownException(ex)) {
          throw ex;
        }
        this._log.warn("Failed to apply incoming record " + record.id, ex);
        failed.push(record.id);
      }
    }
    return failed;
  },

  /**
   * Apply a single record against the store.
   *
   * This takes a single record and makes the local changes required so the
   * local state matches what's in the record.
   *
   * The default implementation calls one of remove(), create(), or update()
   * depending on the state obtained from the store itself. Store
   * implementations may overwrite this function if desired.
   *
   * @param record
   *        Record to apply
   */
  async applyIncoming(record) {
    if (record.deleted)
      await this.remove(record);
    else if (!(await this.itemExists(record.id)))
      await this.create(record);
    else
      await this.update(record);
  },

  // override these in derived objects

  /**
   * Create an item in the store from a record.
   *
   * This is called by the default implementation of applyIncoming(). If using
   * applyIncomingBatch(), this won't be called unless your store calls it.
   *
   * @param record
   *        The store record to create an item from
   */
  async create(record) {
    throw new Error("override create in a subclass");
  },

  /**
   * Remove an item in the store from a record.
   *
   * This is called by the default implementation of applyIncoming(). If using
   * applyIncomingBatch(), this won't be called unless your store calls it.
   *
   * @param record
   *        The store record to delete an item from
   */
  async remove(record) {
    throw new Error("override remove in a subclass");
  },

  /**
   * Update an item from a record.
   *
   * This is called by the default implementation of applyIncoming(). If using
   * applyIncomingBatch(), this won't be called unless your store calls it.
   *
   * @param record
   *        The record to use to update an item from
   */
  async update(record) {
    throw new Error("override update in a subclass");
  },

  /**
   * Determine whether a record with the specified ID exists.
   *
   * Takes a string record ID and returns a booleans saying whether the record
   * exists.
   *
   * @param  id
   *         string record ID
   * @return boolean indicating whether record exists locally
   */
  async itemExists(id) {
    throw new Error("override itemExists in a subclass");
  },

  /**
   * Create a record from the specified ID.
   *
   * If the ID is known, the record should be populated with metadata from
   * the store. If the ID is not known, the record should be created with the
   * delete field set to true.
   *
   * @param  id
   *         string record ID
   * @param  collection
   *         Collection to add record to. This is typically passed into the
   *         constructor for the newly-created record.
   * @return record type for this engine
   */
  async createRecord(id, collection) {
    throw new Error("override createRecord in a subclass");
  },

  /**
   * Change the ID of a record.
   *
   * @param  oldID
   *         string old/current record ID
   * @param  newID
   *         string new record ID
   */
  async changeItemID(oldID, newID) {
    throw new Error("override changeItemID in a subclass");
  },

  /**
   * Obtain the set of all known record IDs.
   *
   * @return Object with ID strings as keys and values of true. The values
   *         are ignored.
   */
  async getAllIDs() {
    throw new Error("override getAllIDs in a subclass");
  },

  /**
   * Wipe all data in the store.
   *
   * This function is called during remote wipes or when replacing local data
   * with remote data.
   *
   * This function should delete all local data that the store is managing. It
   * can be thought of as clearing out all state and restoring the "new
   * browser" state.
   */
  async wipe() {
    throw new Error("override wipe in a subclass");
  }
};

this.EngineManager = function EngineManager(service) {
  this.service = service;

  this._engines = {};

  // This will be populated by Service on startup.
  this._declined = new Set();
  this._log = Log.repository.getLogger("Sync.EngineManager");
  this._log.level = Log.Level[Svc.Prefs.get("log.logger.service.engines", "Debug")];
}
EngineManager.prototype = {
  get(name) {
    // Return an array of engines if we have an array of names
    if (Array.isArray(name)) {
      let engines = [];
      name.forEach(function(name) {
        let engine = this.get(name);
        if (engine) {
          engines.push(engine);
        }
      }, this);
      return engines;
    }

    let engine = this._engines[name];
    if (!engine) {
      this._log.debug("Could not get engine: " + name);
      if (Object.keys) {
        this._log.debug("Engines are: " + JSON.stringify(Object.keys(this._engines)));
      }
    }
    return engine;
  },

  getAll() {
    let engines = [];
    for (let [, engine] of Object.entries(this._engines)) {
      engines.push(engine);
    }
    return engines;
  },

  /**
   * N.B., does not pay attention to the declined list.
   */
  getEnabled() {
    return this.getAll()
               .filter((engine) => engine.enabled)
               .sort((a, b) => a.syncPriority - b.syncPriority);
  },

  get enabledEngineNames() {
    return this.getEnabled().map(e => e.name);
  },

  persistDeclined() {
    Svc.Prefs.set("declinedEngines", [...this._declined].join(","));
  },

  /**
   * Returns an array.
   */
  getDeclined() {
    return [...this._declined];
  },

  setDeclined(engines) {
    this._declined = new Set(engines);
    this.persistDeclined();
  },

  isDeclined(engineName) {
    return this._declined.has(engineName);
  },

  /**
   * Accepts a Set or an array.
   */
  decline(engines) {
    for (let e of engines) {
      this._declined.add(e);
    }
    this.persistDeclined();
  },

  undecline(engines) {
    for (let e of engines) {
      this._declined.delete(e);
    }
    this.persistDeclined();
  },

  /**
   * Mark any non-enabled engines as declined.
   *
   * This is useful after initial customization during setup.
   */
  declineDisabled() {
    for (let e of this.getAll()) {
      if (!e.enabled) {
        this._log.debug("Declining disabled engine " + e.name);
        this._declined.add(e.name);
      }
    }
    this.persistDeclined();
  },

  /**
   * Register an Engine to the service. Alternatively, give an array of engine
   * objects to register.
   *
   * @param engineObject
   *        Engine object used to get an instance of the engine
   * @return The engine object if anything failed
   */
  async register(engineObject) {
    if (Array.isArray(engineObject)) {
      for (const e of engineObject) {
        await this.register(e);
      }
      return;
    }

    try {
      let engine = new engineObject(this.service);
      let name = engine.name;
      if (name in this._engines) {
        this._log.error("Engine '" + name + "' is already registered!");
      } else {
        if (engine.initialize) {
          await engine.initialize();
        }
        this._engines[name] = engine;
      }
    } catch (ex) {
      let name = engineObject || "";
      name = name.prototype || "";
      name = name.name || "";

      this._log.error(`Could not initialize engine ${name}`, ex);
    }
  },

  unregister(val) {
    let name = val;
    if (val instanceof Engine) {
      name = val.name;
    }
    if (name in this._engines) {
      let engine = this._engines[name];
      delete this._engines[name];
      Async.promiseSpinningly(engine.finalize());
    }
  },

  clear() {
    for (let name in this._engines) {
      let engine = this._engines[name];
      delete this._engines[name];
      Async.promiseSpinningly(engine.finalize());
    }
  },
};

this.Engine = function Engine(name, service) {
  if (!service) {
    throw new Error("Engine must be associated with a Service instance.");
  }

  this.Name = name || "Unnamed";
  this.name = name.toLowerCase();
  this.service = service;

  this._notify = Utils.notify("weave:engine:");
  this._log = Log.repository.getLogger("Sync.Engine." + this.Name);
  let level = Svc.Prefs.get("log.logger.engine." + this.name, "Debug");
  this._log.level = Log.Level[level];

  this._modified = this.emptyChangeset();
  this._tracker; // initialize tracker to load previously changed IDs
  this._log.debug("Engine constructed");
}
Engine.prototype = {
  // _storeObj, and _trackerObj should to be overridden in subclasses
  _storeObj: Store,
  _trackerObj: Tracker,

  // Override this method to return a new changeset type.
  emptyChangeset() {
    return new Changeset();
  },

  // Local 'constant'.
  // Signal to the engine that processing further records is pointless.
  eEngineAbortApplyIncoming: "error.engine.abort.applyincoming",

  // Should we keep syncing if we find a record that cannot be uploaded (ever)?
  // If this is false, we'll throw, otherwise, we'll ignore the record and
  // continue. This currently can only happen due to the record being larger
  // than the record upload limit.
  allowSkippedRecord: true,

  get prefName() {
    return this.name;
  },

  get enabled() {
    return Svc.Prefs.get("engine." + this.prefName, false);
  },

  set enabled(val) {
    Svc.Prefs.set("engine." + this.prefName, !!val);
  },

  get score() {
    return this._tracker.score;
  },

  get _store() {
    let store = new this._storeObj(this.Name, this);
    this.__defineGetter__("_store", () => store);
    return store;
  },

  get _tracker() {
    let tracker = new this._trackerObj(this.Name, this);
    this.__defineGetter__("_tracker", () => tracker);
    return tracker;
  },

  async sync() {
    if (!this.enabled) {
      return false;
    }

    if (!this._sync) {
      throw new Error("engine does not implement _sync method");
    }

    return this._notify("sync", this.name, this._sync)();
  },

  /**
   * Get rid of any local meta-data.
   */
  async resetClient() {
    if (!this._resetClient) {
      throw new Error("engine does not implement _resetClient method");
    }

    return this._notify("reset-client", this.name, this._resetClient)();
  },

  async _wipeClient() {
    await this.resetClient();
    this._log.debug("Deleting all local data");
    this._tracker.ignoreAll = true;
    await this._store.wipe();
    this._tracker.ignoreAll = false;
    this._tracker.clearChangedIDs();
  },

  async wipeClient() {
    return this._notify("wipe-client", this.name, this._wipeClient)();
  },

  /**
   * If one exists, initialize and return a validator for this engine (which
   * must have a `validate(engine)` method that returns a promise to an object
   * with a getSummary method). Otherwise return null.
   */
  getValidator() {
    return null;
  },

  async finalize() {
    await this._tracker.finalize();
  },
};

this.SyncEngine = function SyncEngine(name, service) {
  Engine.call(this, name || "SyncEngine", service);

  // Async initializations can be made in the initialize() method.

  // The map of ids => metadata for records needing a weak upload.
  //
  // Currently the "metadata" fields are:
  //
  // - forceTombstone: whether or not we should ignore the local information
  //   about the record, and write a tombstone for it anyway -- e.g. in the case
  //   of records that should exist locally, but should never be uploaded to the
  //   server (note that not all sync engines support tombstones)
  //
  // The difference between this and a "normal" upload is that these records
  // are only tracked in memory, and if the upload attempt fails (shutdown,
  // 412, etc), we abort uploading the "weak" set (by clearing the map).
  //
  // The rationale here is for the cases where we receive a record from the
  // server that we know is wrong in some (small) way. For example, the
  // dateAdded field on bookmarks -- maybe we have a better date, or the server
  // record is entirely missing the date, etc.
  //
  // In these cases, we fix our local copy of the record, and mark it for
  // weak upload. A normal ("strong") upload is problematic here because
  // in the case of a conflict from the server, there's a window where our
  // record would be marked as modified more recently than a change that occurs
  // on another device change, and we lose data from the user.
  //
  // Additionally, we use this as the set of items to upload for bookmark
  // repair reponse, which has similar constraints.
  this._needWeakUpload = new Map();
}

// Enumeration to define approaches to handling bad records.
// Attached to the constructor to allow use as a kind of static enumeration.
SyncEngine.kRecoveryStrategy = {
  ignore: "ignore",
  retry:  "retry",
  error:  "error"
};

SyncEngine.prototype = {
  __proto__: Engine.prototype,
  _recordObj: CryptoWrapper,
  version: 1,

  // Which sortindex to use when retrieving records for this engine.
  _defaultSort: undefined,

  // A relative priority to use when computing an order
  // for engines to be synced. Higher-priority engines
  // (lower numbers) are synced first.
  // It is recommended that a unique value be used for each engine,
  // in order to guarantee a stable sequence.
  syncPriority: 0,

  // How many records to pull in a single sync. This is primarily to avoid very
  // long first syncs against profiles with many history records.
  downloadLimit: null,

  // How many records to pull at one time when specifying IDs. This is to avoid
  // URI length limitations.
  guidFetchBatchSize: DEFAULT_GUID_FETCH_BATCH_SIZE,

  // How many records to process in a single batch.
  applyIncomingBatchSize: DEFAULT_STORE_BATCH_SIZE,

  async initialize() {
    await this.loadToFetch();
    await this.loadPreviousFailed();
    this._log.debug("SyncEngine initialized", this.name);
  },

  get storageURL() {
    return this.service.storageURL;
  },

  get engineURL() {
    return this.storageURL + this.name;
  },

  get cryptoKeysURL() {
    return this.storageURL + "crypto/keys";
  },

  get metaURL() {
    return this.storageURL + "meta/global";
  },

  get syncID() {
    // Generate a random syncID if we don't have one
    let syncID = Svc.Prefs.get(this.name + ".syncID", "");
    return syncID == "" ? this.syncID = Utils.makeGUID() : syncID;
  },
  set syncID(value) {
    Svc.Prefs.set(this.name + ".syncID", value);
  },

  /*
   * lastSync is a timestamp in server time.
   */
  get lastSync() {
    return parseFloat(Svc.Prefs.get(this.name + ".lastSync", "0"));
  },
  set lastSync(value) {
    // Reset the pref in-case it's a number instead of a string
    Svc.Prefs.reset(this.name + ".lastSync");
    // Store the value as a string to keep floating point precision
    Svc.Prefs.set(this.name + ".lastSync", value.toString());
  },
  resetLastSync() {
    this._log.debug("Resetting " + this.name + " last sync time");
    Svc.Prefs.reset(this.name + ".lastSync");
    Svc.Prefs.set(this.name + ".lastSync", "0");
    this.lastSyncLocal = 0;
  },

  get toFetch() {
    return this._toFetch;
  },
  set toFetch(val) {
    // Coerce the array to a string for more efficient comparison.
    if (val + "" == this._toFetch) {
      return;
    }
    this._toFetch = val;
    Utils.namedTimer(function() {
      try {
        Async.promiseSpinningly(Utils.jsonSave("toFetch/" + this.name, this, val));
      } catch (error) {
        this._log.error("Failed to read JSON records to fetch", error);
      }
    }, 0, this, "_toFetchDelay");
  },

  async loadToFetch() {
    // Initialize to empty if there's no file.
    this._toFetch = [];
    let toFetch = await Utils.jsonLoad("toFetch/" + this.name, this);
    if (toFetch) {
      this._toFetch = toFetch;
    }
  },

  get previousFailed() {
    return this._previousFailed;
  },
  set previousFailed(val) {
    // Coerce the array to a string for more efficient comparison.
    if (val + "" == this._previousFailed) {
      return;
    }
    this._previousFailed = val;
    Utils.namedTimer(function() {
      Utils.jsonSave("failed/" + this.name, this, val).then(() => {
        this._log.debug("Successfully wrote previousFailed.");
      })
      .catch((error) => {
        this._log.error("Failed to set previousFailed", error);
      });
    }, 0, this, "_previousFailedDelay");
  },

  async loadPreviousFailed() {
    // Initialize to empty if there's no file
    this._previousFailed = [];
    let previousFailed = await Utils.jsonLoad("failed/" + this.name, this);
    if (previousFailed) {
      this._previousFailed = previousFailed;
    }
  },

  /*
   * lastSyncLocal is a timestamp in local time.
   */
  get lastSyncLocal() {
    return parseInt(Svc.Prefs.get(this.name + ".lastSyncLocal", "0"), 10);
  },
  set lastSyncLocal(value) {
    // Store as a string because pref can only store C longs as numbers.
    Svc.Prefs.set(this.name + ".lastSyncLocal", value.toString());
  },

  get maxRecordPayloadBytes() {
    let serverConfiguration = this.service.serverConfiguration;
    if (serverConfiguration && serverConfiguration.max_record_payload_bytes) {
      return serverConfiguration.max_record_payload_bytes;
    }
    return DEFAULT_MAX_RECORD_PAYLOAD_BYTES;
  },

  /*
   * Returns a changeset for this sync. Engine implementations can override this
   * method to bypass the tracker for certain or all changed items.
   */
  async getChangedIDs() {
    return this._tracker.changedIDs;
  },

  // Create a new record using the store and add in metadata.
  async _createRecord(id) {
    let record = await this._store.createRecord(id, this.name);
    record.id = id;
    record.collection = this.name;
    return record;
  },

  // Creates a tombstone Sync record with additional metadata.
  _createTombstone(id) {
    let tombstone = new this._recordObj(this.name, id);
    tombstone.id = id;
    tombstone.collection = this.name;
    tombstone.deleted = true;
    return tombstone;
  },

  addForWeakUpload(id, { forceTombstone = false } = {}) {
    this._needWeakUpload.set(id, { forceTombstone });
  },

  // Any setup that needs to happen at the beginning of each sync.
  async _syncStartup() {

    // Determine if we need to wipe on outdated versions
    let metaGlobal = await this.service.recordManager.get(this.metaURL);
    let engines = metaGlobal.payload.engines || {};
    let engineData = engines[this.name] || {};

    let needsWipe = false;

    // Assume missing versions are 0 and wipe the server
    if ((engineData.version || 0) < this.version) {
      this._log.debug("Old engine data: " + [engineData.version, this.version]);

      // Prepare to clear the server and upload everything
      needsWipe = true;
      this.syncID = "";

      // Set the newer version and newly generated syncID
      engineData.version = this.version;
      engineData.syncID = this.syncID;

      // Put the new data back into meta/global and mark for upload
      engines[this.name] = engineData;
      metaGlobal.payload.engines = engines;
      metaGlobal.changed = true;
    } else if (engineData.version > this.version) {
      // Don't sync this engine if the server has newer data
      let error = new String("New data: " + [engineData.version, this.version]);
      error.failureCode = VERSION_OUT_OF_DATE;
      throw error;
    } else if (engineData.syncID != this.syncID) {
      // Changes to syncID mean we'll need to upload everything
      this._log.debug("Engine syncIDs: " + [engineData.syncID, this.syncID]);
      this.syncID = engineData.syncID;
      await this._resetClient();
    }

    // Delete any existing data and reupload on bad version or missing meta.
    // No crypto component here...? We could regenerate per-collection keys...
    if (needsWipe) {
      await this.wipeServer();
    }

    // Save objects that need to be uploaded in this._modified. We also save
    // the timestamp of this fetch in this.lastSyncLocal. As we successfully
    // upload objects we remove them from this._modified. If an error occurs
    // or any objects fail to upload, they will remain in this._modified. At
    // the end of a sync, or after an error, we add all objects remaining in
    // this._modified to the tracker.
    this.lastSyncLocal = Date.now();
    let initialChanges;
    if (this.lastSync) {
      initialChanges = await this.pullNewChanges();
    } else {
      this._log.debug("First sync, uploading all items");
      initialChanges = await this.pullAllChanges();
    }
    this._modified.replace(initialChanges);
    // Clear the tracker now. If the sync fails we'll add the ones we failed
    // to upload back.
    this._tracker.clearChangedIDs();

    this._log.info(this._modified.count() +
                   " outgoing items pre-reconciliation");

    // Keep track of what to delete at the end of sync
    this._delete = {};
  },

  /**
   * A tiny abstraction to make it easier to test incoming record
   * application.
   */
  itemSource() {
    return new Collection(this.engineURL, this._recordObj, this.service);
  },

  /**
   * Process incoming records.
   * In the most awful and untestable way possible.
   * This now accepts something that makes testing vaguely less impossible.
   */
  async _processIncoming(newitems) {
    this._log.trace("Downloading & applying server changes");

    // Figure out how many total items to fetch this sync; do less on mobile.
    let batchSize = this.downloadLimit || Infinity;

    if (!newitems) {
      newitems = this.itemSource();
    }

    if (this._defaultSort) {
      newitems.sort = this._defaultSort;
    }

    newitems.newer = this.lastSync;
    newitems.full  = true;
    newitems.limit = batchSize;

    // applied    => number of items that should be applied.
    // failed     => number of items that failed in this sync.
    // newFailed  => number of items that failed for the first time in this sync.
    // reconciled => number of items that were reconciled.
    let count = {applied: 0, failed: 0, newFailed: 0, reconciled: 0};
    let handled = [];
    let applyBatch = [];
    let failed = [];
    let failedInPreviousSync = this.previousFailed;
    let fetchBatch = Utils.arrayUnion(this.toFetch, failedInPreviousSync);
    // Reset previousFailed for each sync since previously failed items may not fail again.
    this.previousFailed = [];

    // Used (via exceptions) to allow the record handler/reconciliation/etc.
    // methods to signal that they would like processing of incoming records to
    // cease.
    let aborting = undefined;

    async function doApplyBatch() {
      this._tracker.ignoreAll = true;
      try {
        failed = failed.concat((await this._store.applyIncomingBatch(applyBatch)));
      } catch (ex) {
        if (Async.isShutdownException(ex)) {
          throw ex;
        }
        // Catch any error that escapes from applyIncomingBatch. At present
        // those will all be abort events.
        this._log.warn("Got exception, aborting processIncoming", ex);
        aborting = ex;
      }
      this._tracker.ignoreAll = false;
      applyBatch = [];
    }

    async function doApplyBatchAndPersistFailed() {
      // Apply remaining batch.
      if (applyBatch.length) {
        await doApplyBatch.call(this);
      }
      // Persist failed items so we refetch them.
      if (failed.length) {
        this.previousFailed = Utils.arrayUnion(failed, this.previousFailed);
        count.failed += failed.length;
        this._log.debug("Records that failed to apply: " + failed);
        failed = [];
      }
    }

    let key = this.service.collectionKeys.keyForCollection(this.name);

    // Not binding this method to 'this' for performance reasons. It gets
    // called for every incoming record.
    let self = this;

    let recordHandler = async function(item) {
      if (aborting) {
        return;
      }

      // Grab a later last modified if possible
      if (self.lastModified == null || item.modified > self.lastModified)
        self.lastModified = item.modified;

      // Track the collection for the WBO.
      item.collection = self.name;

      // Remember which records were processed
      handled.push(item.id);

      try {
        try {
          item.decrypt(key);
        } catch (ex) {
          if (!Utils.isHMACMismatch(ex)) {
            throw ex;
          }
          let strategy = await self.handleHMACMismatch(item, true);
          if (strategy == SyncEngine.kRecoveryStrategy.retry) {
            // You only get one retry.
            try {
              // Try decrypting again, typically because we've got new keys.
              self._log.info("Trying decrypt again...");
              key = self.service.collectionKeys.keyForCollection(self.name);
              item.decrypt(key);
              strategy = null;
            } catch (ex) {
              if (!Utils.isHMACMismatch(ex)) {
                throw ex;
              }
              strategy = await self.handleHMACMismatch(item, false);
            }
          }

          switch (strategy) {
            case null:
              // Retry succeeded! No further handling.
              break;
            case SyncEngine.kRecoveryStrategy.retry:
              self._log.debug("Ignoring second retry suggestion.");
              // Fall through to error case.
            case SyncEngine.kRecoveryStrategy.error:
              self._log.warn("Error decrypting record", ex);
              failed.push(item.id);
              return;
            case SyncEngine.kRecoveryStrategy.ignore:
              self._log.debug("Ignoring record " + item.id +
                              " with bad HMAC: already handled.");
              return;
          }
        }
      } catch (ex) {
        if (Async.isShutdownException(ex)) {
          throw ex;
        }
        self._log.warn("Error decrypting record", ex);
        failed.push(item.id);
        return;
      }

      if (self._shouldDeleteRemotely(item)) {
        self._log.trace("Deleting item from server without applying", item);
        self._deleteId(item.id);
        return;
      }

      let shouldApply;
      try {
        shouldApply = await self._reconcile(item);
      } catch (ex) {
        if (ex.code == Engine.prototype.eEngineAbortApplyIncoming) {
          self._log.warn("Reconciliation failed: aborting incoming processing.");
          failed.push(item.id);
          aborting = ex.cause;
        } else if (!Async.isShutdownException(ex)) {
          self._log.warn("Failed to reconcile incoming record " + item.id, ex);
          failed.push(item.id);
          return;
        } else {
          throw ex;
        }
      }

      if (shouldApply) {
        count.applied++;
        applyBatch.push(item);
      } else {
        count.reconciled++;
        self._log.trace("Skipping reconciled incoming item " + item.id);
      }

      if (applyBatch.length == self.applyIncomingBatchSize) {
        await doApplyBatch.call(self);
      }
    };

    // Only bother getting data from the server if there's new things
    if (this.lastModified == null || this.lastModified > this.lastSync) {
      let { response, records } = await newitems.getBatched();
      if (!response.success) {
        response.failureCode = ENGINE_DOWNLOAD_FAIL;
        throw response;
      }

      let maybeYield = Async.jankYielder();
      for (let record of records) {
        await maybeYield();
        await recordHandler(record);
      }
      await doApplyBatchAndPersistFailed.call(this);

      if (aborting) {
        throw aborting;
      }
    }

    // Mobile: check if we got the maximum that we requested; get the rest if so.
    if (handled.length == newitems.limit) {
      let guidColl = new Collection(this.engineURL, null, this.service);

      // Sort and limit so that on mobile we only get the last X records.
      guidColl.limit = this.downloadLimit;
      guidColl.newer = this.lastSync;

      // index: Orders by the sortindex descending (highest weight first).
      guidColl.sort  = "index";

      let guids = await guidColl.get();
      if (!guids.success)
        throw guids;

      // Figure out which guids weren't just fetched then remove any guids that
      // were already waiting and prepend the new ones
      let extra = Utils.arraySub(guids.obj, handled);
      if (extra.length > 0) {
        fetchBatch = Utils.arrayUnion(extra, fetchBatch);
        this.toFetch = Utils.arrayUnion(extra, this.toFetch);
      }
    }

    // Fast-foward the lastSync timestamp since we have stored the
    // remaining items in toFetch.
    if (this.lastSync < this.lastModified) {
      this.lastSync = this.lastModified;
    }

    // Process any backlog of GUIDs.
    // At this point we impose an upper limit on the number of items to fetch
    // in a single request, even for desktop, to avoid hitting URI limits.
    batchSize = this.guidFetchBatchSize;

    while (fetchBatch.length && !aborting) {
      // Reuse the original query, but get rid of the restricting params
      // and batch remaining records.
      newitems.limit = 0;
      newitems.newer = 0;
      newitems.ids = fetchBatch.slice(0, batchSize);

      let resp = await newitems.get();
      if (!resp.success) {
        resp.failureCode = ENGINE_DOWNLOAD_FAIL;
        throw resp;
      }

      let maybeYield = Async.jankYielder();
      for (let json of resp.obj) {
        await maybeYield();
        let record = new this._recordObj();
        record.deserialize(json);
        await recordHandler(record);
      }

      // This batch was successfully applied. Not using
      // doApplyBatchAndPersistFailed() here to avoid writing toFetch twice.
      fetchBatch = fetchBatch.slice(batchSize);
      this.toFetch = Utils.arraySub(this.toFetch, newitems.ids);
      this.previousFailed = Utils.arrayUnion(this.previousFailed, failed);
      if (failed.length) {
        count.failed += failed.length;
        this._log.debug("Records that failed to apply: " + failed);
      }
      failed = [];

      if (aborting) {
        throw aborting;
      }

      if (this.lastSync < this.lastModified) {
        this.lastSync = this.lastModified;
      }
    }

    // Apply remaining items.
    await doApplyBatchAndPersistFailed.call(this);

    count.newFailed = this.previousFailed.reduce((count, engine) => {
      if (failedInPreviousSync.indexOf(engine) == -1) {
        count++;
      }
      return count;
    }, 0);
    count.succeeded = Math.max(0, count.applied - count.failed);
    this._log.info(["Records:",
                    count.applied, "applied,",
                    count.succeeded, "successfully,",
                    count.failed, "failed to apply,",
                    count.newFailed, "newly failed to apply,",
                    count.reconciled, "reconciled."].join(" "));
    Observers.notify("weave:engine:sync:applied", count, this.name);
  },

  // Indicates whether an incoming item should be deleted from the server at
  // the end of the sync. Engines can override this method to clean up records
  // that shouldn't be on the server.
  _shouldDeleteRemotely(remoteItem) {
    return false;
  },

  /**
   * Find a GUID of an item that is a duplicate of the incoming item but happens
   * to have a different GUID
   *
   * @return GUID of the similar item; falsy otherwise
   */
  async _findDupe(item) {
    // By default, assume there's no dupe items for the engine
  },

  /**
   * Called before a remote record is discarded due to failed reconciliation.
   * Used by bookmark sync to merge folder child orders.
   */
  beforeRecordDiscard(localRecord, remoteRecord, remoteIsNewer) {
  },

  // Called when the server has a record marked as deleted, but locally we've
  // changed it more recently than the deletion. If we return false, the
  // record will be deleted locally. If we return true, we'll reupload the
  // record to the server -- any extra work that's needed as part of this
  // process should be done at this point (such as mark the record's parent
  // for reuploading in the case of bookmarks).
  async _shouldReviveRemotelyDeletedRecord(remoteItem) {
    return true;
  },

  _deleteId(id) {
    this._tracker.removeChangedID(id);
    this._noteDeletedId(id);
  },

  // Marks an ID for deletion at the end of the sync.
  _noteDeletedId(id) {
    if (this._delete.ids == null)
      this._delete.ids = [id];
    else
      this._delete.ids.push(id);
  },

  async _switchItemToDupe(localDupeGUID, incomingItem) {
    // The local, duplicate ID is always deleted on the server.
    this._deleteId(localDupeGUID);

    // We unconditionally change the item's ID in case the engine knows of
    // an item but doesn't expose it through itemExists. If the API
    // contract were stronger, this could be changed.
    this._log.debug("Switching local ID to incoming: " + localDupeGUID + " -> " +
                    incomingItem.id);
    return this._store.changeItemID(localDupeGUID, incomingItem.id);
  },

  /**
   * Reconcile incoming record with local state.
   *
   * This function essentially determines whether to apply an incoming record.
   *
   * @param  item
   *         Record from server to be tested for application.
   * @return boolean
   *         Truthy if incoming record should be applied. False if not.
   */
  async _reconcile(item) {
    if (this._log.level <= Log.Level.Trace) {
      this._log.trace("Incoming: " + item);
    }

    // We start reconciling by collecting a bunch of state. We do this here
    // because some state may change during the course of this function and we
    // need to operate on the original values.
    let existsLocally   = await this._store.itemExists(item.id);
    let locallyModified = this._modified.has(item.id);

    // TODO Handle clock drift better. Tracked in bug 721181.
    let remoteAge = AsyncResource.serverTime - item.modified;
    let localAge  = locallyModified ?
      (Date.now() / 1000 - this._modified.getModifiedTimestamp(item.id)) : null;
    let remoteIsNewer = remoteAge < localAge;

    this._log.trace("Reconciling " + item.id + ". exists=" +
                    existsLocally + "; modified=" + locallyModified +
                    "; local age=" + localAge + "; incoming age=" +
                    remoteAge);

    // We handle deletions first so subsequent logic doesn't have to check
    // deleted flags.
    if (item.deleted) {
      // If the item doesn't exist locally, there is nothing for us to do. We
      // can't check for duplicates because the incoming record has no data
      // which can be used for duplicate detection.
      if (!existsLocally) {
        this._log.trace("Ignoring incoming item because it was deleted and " +
                        "the item does not exist locally.");
        return false;
      }

      // We decide whether to process the deletion by comparing the record
      // ages. If the item is not modified locally, the remote side wins and
      // the deletion is processed. If it is modified locally, we take the
      // newer record.
      if (!locallyModified) {
        this._log.trace("Applying incoming delete because the local item " +
                        "exists and isn't modified.");
        return true;
      }
      this._log.trace("Incoming record is deleted but we had local changes.");

      if (remoteIsNewer) {
        this._log.trace("Remote record is newer -- deleting local record.");
        return true;
      }
      // If the local record is newer, we defer to individual engines for
      // how to handle this. By default, we revive the record.
      let willRevive = await this._shouldReviveRemotelyDeletedRecord(item);
      this._log.trace("Local record is newer -- reviving? " + willRevive);

      return !willRevive;
    }

    // At this point the incoming record is not for a deletion and must have
    // data. If the incoming record does not exist locally, we check for a local
    // duplicate existing under a different ID. The default implementation of
    // _findDupe() is empty, so engines have to opt in to this functionality.
    //
    // If we find a duplicate, we change the local ID to the incoming ID and we
    // refresh the metadata collected above. See bug 710448 for the history
    // of this logic.
    if (!existsLocally) {
      let localDupeGUID = await this._findDupe(item);
      if (localDupeGUID) {
        this._log.trace("Local item " + localDupeGUID + " is a duplicate for " +
                        "incoming item " + item.id);

        // The current API contract does not mandate that the ID returned by
        // _findDupe() actually exists. Therefore, we have to perform this
        // check.
        existsLocally = await this._store.itemExists(localDupeGUID);

        // If the local item was modified, we carry its metadata forward so
        // appropriate reconciling can be performed.
        if (this._modified.has(localDupeGUID)) {
          locallyModified = true;
          localAge = this._tracker._now() - this._modified.getModifiedTimestamp(localDupeGUID);
          remoteIsNewer = remoteAge < localAge;

          this._modified.changeID(localDupeGUID, item.id);
        } else {
          locallyModified = false;
          localAge = null;
        }

        // Tell the engine to do whatever it needs to switch the items.
        await this._switchItemToDupe(localDupeGUID, item);

        this._log.debug("Local item after duplication: age=" + localAge +
                        "; modified=" + locallyModified + "; exists=" +
                        existsLocally);
      } else {
        this._log.trace("No duplicate found for incoming item: " + item.id);
      }
    }

    // At this point we've performed duplicate detection. But, nothing here
    // should depend on duplicate detection as the above should have updated
    // state seamlessly.

    if (!existsLocally) {
      // If the item doesn't exist locally and we have no local modifications
      // to the item (implying that it was not deleted), always apply the remote
      // item.
      if (!locallyModified) {
        this._log.trace("Applying incoming because local item does not exist " +
                        "and was not deleted.");
        return true;
      }

      // If the item was modified locally but isn't present, it must have
      // been deleted. If the incoming record is younger, we restore from
      // that record.
      if (remoteIsNewer) {
        this._log.trace("Applying incoming because local item was deleted " +
                        "before the incoming item was changed.");
        this._modified.delete(item.id);
        return true;
      }

      this._log.trace("Ignoring incoming item because the local item's " +
                      "deletion is newer.");
      return false;
    }

    // If the remote and local records are the same, there is nothing to be
    // done, so we don't do anything. In the ideal world, this logic wouldn't
    // be here and the engine would take a record and apply it. The reason we
    // want to defer this logic is because it would avoid a redundant and
    // possibly expensive dip into the storage layer to query item state.
    // This should get addressed in the async rewrite, so we ignore it for now.
    let localRecord = await this._createRecord(item.id);
    let recordsEqual = Utils.deepEquals(item.cleartext,
                                        localRecord.cleartext);

    // If the records are the same, we don't need to do anything. This does
    // potentially throw away a local modification time. But, if the records
    // are the same, does it matter?
    if (recordsEqual) {
      this._log.trace("Ignoring incoming item because the local item is " +
                      "identical.");

      this._modified.delete(item.id);
      return false;
    }

    // At this point the records are different.

    // If we have no local modifications, always take the server record.
    if (!locallyModified) {
      this._log.trace("Applying incoming record because no local conflicts.");
      return true;
    }

    // At this point, records are different and the local record is modified.
    // We resolve conflicts by record age, where the newest one wins. This does
    // result in data loss and should be handled by giving the engine an
    // opportunity to merge the records. Bug 720592 tracks this feature.
    this._log.warn("DATA LOSS: Both local and remote changes to record: " +
                   item.id);
    if (!remoteIsNewer) {
      this.beforeRecordDiscard(localRecord, item, remoteIsNewer);
    }
    return remoteIsNewer;
  },

  // Upload outgoing records.
  async _uploadOutgoing() {
    this._log.trace("Uploading local changes to server.");

    // collection we'll upload
    let up = new Collection(this.engineURL, null, this.service);
    let modifiedIDs = new Set(this._modified.ids());
    for (let id of this._needWeakUpload.keys()) {
      modifiedIDs.add(id);
    }
    let counts = { failed: 0, sent: 0 };
    if (modifiedIDs.size) {
      this._log.trace("Preparing " + modifiedIDs.size +
                      " outgoing records");

      counts.sent = modifiedIDs.size;

      let failed = [];
      let successful = [];
      let handleResponse = async (resp, batchOngoing = false) => {
        // Note: We don't want to update this.lastSync, or this._modified until
        // the batch is complete, however we want to remember success/failure
        // indicators for when that happens.
        if (!resp.success) {
          this._log.debug("Uploading records failed: " + resp);
          resp.failureCode = resp.status == 412 ? ENGINE_BATCH_INTERRUPTED : ENGINE_UPLOAD_FAIL;
          throw resp;
        }

        // Update server timestamp from the upload.
        failed = failed.concat(Object.keys(resp.obj.failed));
        successful = successful.concat(resp.obj.success);

        if (batchOngoing) {
          // Nothing to do yet
          return;
        }
        // Advance lastSync since we've finished the batch.
        let modified = resp.headers["x-weave-timestamp"];
        if (modified > this.lastSync) {
          this.lastSync = modified;
        }
        if (failed.length && this._log.level <= Log.Level.Debug) {
          this._log.debug("Records that will be uploaded again because "
                          + "the server couldn't store them: "
                          + failed.join(", "));
        }

        counts.failed += failed.length;

        for (let id of successful) {
          this._modified.delete(id);
        }

        await this._onRecordsWritten(successful, failed);

        // clear for next batch
        failed.length = 0;
        successful.length = 0;
      };

      let postQueue = up.newPostQueue(this._log, this.lastSync, handleResponse);

      for (let id of modifiedIDs) {
        let out;
        let ok = false;
        try {
          let { forceTombstone = false } = this._needWeakUpload.get(id) || {};
          if (forceTombstone) {
            out = await this._createTombstone(id);
          } else {
            out = await this._createRecord(id);
          }
          if (this._log.level <= Log.Level.Trace)
            this._log.trace("Outgoing: " + out);

          out.encrypt(this.service.collectionKeys.keyForCollection(this.name));
          let payloadLength = JSON.stringify(out.payload).length;
          if (payloadLength > this.maxRecordPayloadBytes) {
            if (this.allowSkippedRecord) {
              this._modified.delete(id); // Do not attempt to sync that record again
            }
            throw new Error(`Payload too big: ${payloadLength} bytes`);
          }
          ok = true;
        } catch (ex) {
          this._log.warn("Error creating record", ex);
          ++counts.failed;
          if (Async.isShutdownException(ex) || !this.allowSkippedRecord) {
            if (!this.allowSkippedRecord) {
              // Don't bother for shutdown errors
              Observers.notify("weave:engine:sync:uploaded", counts, this.name);
            }
            throw ex;
          }
        }
        if (ok) {
          let { enqueued, error } = await postQueue.enqueue(out);
          if (!enqueued) {
            ++counts.failed;
            if (!this.allowSkippedRecord) {
              Observers.notify("weave:engine:sync:uploaded", counts, this.name);
              throw error;
            }
            this._modified.delete(id);
            this._log.warn(`Failed to enqueue record "${id}" (skipping)`, error);
          }
        }
        await Async.promiseYield();
      }
      await postQueue.flush(true);
    }
    this._needWeakUpload.clear();

    if (counts.sent || counts.failed) {
      Observers.notify("weave:engine:sync:uploaded", counts, this.name);
    }
  },

  async _onRecordsWritten(succeeded, failed) {
    // Implement this method to take specific actions against successfully
    // uploaded records and failed records.
  },

  // Any cleanup necessary.
  // Save the current snapshot so as to calculate changes at next sync
  async _syncFinish() {
    this._log.trace("Finishing up sync");
    this._tracker.resetScore();

    let doDelete = async (key, val) => {
      let coll = new Collection(this.engineURL, this._recordObj, this.service);
      coll[key] = val;
      await coll.delete();
    };

    for (let [key, val] of Object.entries(this._delete)) {
      // Remove the key for future uses
      delete this._delete[key];

      // Send a simple delete for the property
      if (key != "ids" || val.length <= 100)
        await doDelete(key, val);
      else {
        // For many ids, split into chunks of at most 100
        while (val.length > 0) {
          await doDelete(key, val.slice(0, 100));
          val = val.slice(100);
        }
      }
    }
  },

  async _syncCleanup() {
    this._needWeakUpload.clear();
    if (!this._modified) {
      return;
    }

    try {
      // Mark failed WBOs as changed again so they are reuploaded next time.
      await this.trackRemainingChanges();
    } finally {
      this._modified.clear();
    }
  },

  async _sync() {
    try {
      await this._syncStartup();
      Observers.notify("weave:engine:sync:status", "process-incoming");
      await this._processIncoming();
      Observers.notify("weave:engine:sync:status", "upload-outgoing");
      await this._uploadOutgoing();
      await this._syncFinish();
    } finally {
      await this._syncCleanup();
    }
  },

  async canDecrypt() {
    // Report failure even if there's nothing to decrypt
    let canDecrypt = false;

    // Fetch the most recently uploaded record and try to decrypt it
    let test = new Collection(this.engineURL, this._recordObj, this.service);
    test.limit = 1;
    test.sort = "newest";
    test.full = true;

    let key = this.service.collectionKeys.keyForCollection(this.name);

    // Any failure fetching/decrypting will just result in false
    try {
      this._log.trace("Trying to decrypt a record from the server..");
      let json = (await test.get()).obj[0];
      let record = new this._recordObj();
      record.deserialize(json);
      record.decrypt(key);
      canDecrypt = true;
    } catch (ex) {
      if (Async.isShutdownException(ex)) {
        throw ex;
      }
      this._log.debug("Failed test decrypt", ex);
    }

    return canDecrypt;
  },

  async _resetClient() {
    this.resetLastSync();
    this.previousFailed = [];
    this.toFetch = [];
    this._needWeakUpload.clear();
  },

  async wipeServer() {
    let response = await this.service.resource(this.engineURL).delete();
    if (response.status != 200 && response.status != 404) {
      throw response;
    }
    await this._resetClient();
  },

  async removeClientData() {
    // Implement this method in engines that store client specific data
    // on the server.
  },

  /*
   * Decide on (and partially effect) an error-handling strategy.
   *
   * Asks the Service to respond to an HMAC error, which might result in keys
   * being downloaded. That call returns true if an action which might allow a
   * retry to occur.
   *
   * If `mayRetry` is truthy, and the Service suggests a retry,
   * handleHMACMismatch returns kRecoveryStrategy.retry. Otherwise, it returns
   * kRecoveryStrategy.error.
   *
   * Subclasses of SyncEngine can override this method to allow for different
   * behavior -- e.g., to delete and ignore erroneous entries.
   *
   * All return values will be part of the kRecoveryStrategy enumeration.
   */
  async handleHMACMismatch(item, mayRetry) {
    // By default we either try again, or bail out noisily.
    return ((await this.service.handleHMACEvent()) && mayRetry) ?
           SyncEngine.kRecoveryStrategy.retry :
           SyncEngine.kRecoveryStrategy.error;
  },

  /**
   * Returns a changeset containing all items in the store. The default
   * implementation returns a changeset with timestamps from long ago, to
   * ensure we always use the remote version if one exists.
   *
   * This function is only called for the first sync. Subsequent syncs call
   * `pullNewChanges`.
   *
   * @return A `Changeset` object.
   */
  async pullAllChanges() {
    let changes = {};
    let ids = await this._store.getAllIDs();
    for (let id in ids) {
      changes[id] = 0;
    }
    return changes;
  },

  /*
   * Returns a changeset containing entries for all currently tracked items.
   * The default implementation returns a changeset with timestamps indicating
   * when the item was added to the tracker.
   *
   * @return A `Changeset` object.
   */
  async pullNewChanges() {
    return this.getChangedIDs();
  },

  /**
   * Adds all remaining changeset entries back to the tracker, typically for
   * items that failed to upload. This method is called at the end of each sync.
   *
   */
  async trackRemainingChanges() {
    for (let [id, change] of this._modified.entries()) {
      this._tracker.addChangedID(id, change);
    }
  },
};

/**
 * A changeset is created for each sync in `Engine::get{Changed, All}IDs`,
 * and stores opaque change data for tracked IDs. The default implementation
 * only records timestamps, though engines can extend this to store additional
 * data for each entry.
 */
class Changeset {
  // Creates an empty changeset.
  constructor() {
    this.changes = {};
  }

  // Returns the last modified time, in seconds, for an entry in the changeset.
  // `id` is guaranteed to be in the set.
  getModifiedTimestamp(id) {
    return this.changes[id];
  }

  // Adds a change for a tracked ID to the changeset.
  set(id, change) {
    this.changes[id] = change;
  }

  // Adds multiple entries to the changeset, preserving existing entries.
  insert(changes) {
    Object.assign(this.changes, changes);
  }

  // Overwrites the existing set of tracked changes with new entries.
  replace(changes) {
    this.changes = changes;
  }

  // Indicates whether an entry is in the changeset.
  has(id) {
    return id in this.changes;
  }

  // Deletes an entry from the changeset. Used to clean up entries for
  // reconciled and successfully uploaded records.
  delete(id) {
    delete this.changes[id];
  }

  // Changes the ID of an entry in the changeset. Used when reconciling
  // duplicates that have local changes.
  changeID(oldID, newID) {
    this.changes[newID] = this.changes[oldID];
    delete this.changes[oldID];
  }

  // Returns an array of all tracked IDs in this changeset.
  ids() {
    return Object.keys(this.changes);
  }

  // Returns an array of `[id, change]` tuples. Used to repopulate the tracker
  // with entries for failed uploads at the end of a sync.
  entries() {
    return Object.entries(this.changes);
  }

  // Returns the number of entries in this changeset.
  count() {
    return this.ids().length;
  }

  // Clears the changeset.
  clear() {
    this.changes = {};
  }
}
