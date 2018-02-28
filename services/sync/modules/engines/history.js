/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

this.EXPORTED_SYMBOLS = ["HistoryEngine", "HistoryRec"];

var Cc = Components.classes;
var Ci = Components.interfaces;
var Cu = Components.utils;
var Cr = Components.results;

const HISTORY_TTL = 5184000; // 60 days in milliseconds
const THIRTY_DAYS_IN_MS = 2592000000; // 30 days in milliseconds

Cu.import("resource://gre/modules/XPCOMUtils.jsm");
Cu.import("resource://services-common/async.js");
Cu.import("resource://services-sync/constants.js");
Cu.import("resource://services-sync/engines.js");
Cu.import("resource://services-sync/record.js");
Cu.import("resource://services-sync/util.js");

XPCOMUtils.defineLazyModuleGetter(this, "PlacesUtils",
                                  "resource://gre/modules/PlacesUtils.jsm");

XPCOMUtils.defineLazyModuleGetter(this, "PlacesSyncUtils",
                                  "resource://gre/modules/PlacesSyncUtils.jsm");

this.HistoryRec = function HistoryRec(collection, id) {
  CryptoWrapper.call(this, collection, id);
}
HistoryRec.prototype = {
  __proto__: CryptoWrapper.prototype,
  _logName: "Sync.Record.History",
  ttl: HISTORY_TTL
};

Utils.deferGetSet(HistoryRec, "cleartext", ["histUri", "title", "visits"]);


this.HistoryEngine = function HistoryEngine(service) {
  SyncEngine.call(this, "History", service);
}
HistoryEngine.prototype = {
  __proto__: SyncEngine.prototype,
  _recordObj: HistoryRec,
  _storeObj: HistoryStore,
  _trackerObj: HistoryTracker,
  downloadLimit: MAX_HISTORY_DOWNLOAD,
  applyIncomingBatchSize: HISTORY_STORE_BATCH_SIZE,

  syncPriority: 7,

  async _processIncoming(newitems) {
    // We want to notify history observers that a batch operation is underway
    // so they don't do lots of work for each incoming record.
    let observers = PlacesUtils.history.getObservers();
    function notifyHistoryObservers(notification) {
      for (let observer of observers) {
        try {
          observer[notification]();
        } catch (ex) { }
      }
    }
    notifyHistoryObservers("onBeginUpdateBatch");
    try {
      await SyncEngine.prototype._processIncoming.call(this, newitems);
    } finally {
      notifyHistoryObservers("onEndUpdateBatch");
    }
  },

  async pullNewChanges() {
    let modifiedGUIDs = Object.keys(this._tracker.changedIDs);
    if (!modifiedGUIDs.length) {
      return {};
    }

    let guidsToRemove = await PlacesSyncUtils.history.determineNonSyncableGuids(modifiedGUIDs);
    this._tracker.removeChangedID(...guidsToRemove);
    return this._tracker.changedIDs;
  },
};

function HistoryStore(name, engine) {
  Store.call(this, name, engine);

  // Explicitly nullify our references to our cached services so we don't leak
  Svc.Obs.add("places-shutdown", function() {
    for (let query in this._stmts) {
      let stmt = this._stmts[query];
      stmt.finalize();
    }
    this._stmts = {};
  }, this);
}
HistoryStore.prototype = {
  __proto__: Store.prototype,

  __asyncHistory: null,
  get _asyncHistory() {
    if (!this.__asyncHistory) {
      this.__asyncHistory = Cc["@mozilla.org/browser/history;1"]
                              .getService(Ci.mozIAsyncHistory);
    }
    return this.__asyncHistory;
  },

  _stmts: {},
  _getStmt(query) {
    if (query in this._stmts) {
      return this._stmts[query];
    }

    this._log.trace("Creating SQL statement: " + query);
    let db = PlacesUtils.history.QueryInterface(Ci.nsPIPlacesDatabase)
                        .DBConnection;
    return this._stmts[query] = db.createAsyncStatement(query);
  },

  // Some helper functions to handle GUIDs
  async setGUID(uri, guid) {

    if (!guid) {
      guid = Utils.makeGUID();
    }

    try {
      await PlacesSyncUtils.history.changeGuid(uri, guid);
    } catch (e) {
      this._log.error("Error setting GUID ${guid} for URI ${uri}", guid, uri);
    }

    return guid;
  },

  async GUIDForUri(uri, create) {

    // Use the existing GUID if it exists
    let guid;
    try {
      guid = await PlacesSyncUtils.history.fetchGuidForURL(uri);
    } catch (e) {
      this._log.error("Error fetching GUID for URL ${uri}", uri);
    }

    // If the URI has an existing GUID, return it.
    if (guid) {
      return guid;
    }

    // If the URI doesn't have a GUID and we were indicated to create one.
    if (create) {
      return this.setGUID(uri);
    }

    // If the URI doesn't have a GUID and we didn't create one for it.
    return null;
  },

  async changeItemID(oldID, newID) {
    this.setGUID(await PlacesSyncUtils.history.fetchURLInfoForGuid(oldID).url, newID);
  },

  async getAllIDs() {
    let urls = await PlacesSyncUtils.history.getAllURLs({ since: new Date((Date.now() - THIRTY_DAYS_IN_MS)), limit: MAX_HISTORY_UPLOAD });

    let urlsByGUID = {};
    for (let url of urls) {
      let guid = await this.GUIDForUri(url, true);
      urlsByGUID[guid] = url;
    }
    return urlsByGUID;
  },

  async applyIncomingBatch(records) {
    let failed = [];
    let blockers = [];

    // Convert incoming records to mozIPlaceInfo objects. Some records can be
    // ignored or handled directly, so we're rewriting the array in-place.
    let i, k;
    for (i = 0, k = 0; i < records.length; i++) {
      let record = records[k] = records[i];
      let shouldApply;

      try {
        if (record.deleted) {
          let promise = this.remove(record);
          promise = promise.catch(ex => failed.push(record.id));
          blockers.push(promise);

          // No further processing needed. Remove it from the list.
          shouldApply = false;
        } else {
          shouldApply = await this._recordToPlaceInfo(record);
        }
      } catch (ex) {
        if (Async.isShutdownException(ex)) {
          throw ex;
        }
        failed.push(record.id);
        shouldApply = false;
      }

      if (shouldApply) {
        k += 1;
      }
    }
    records.length = k; // truncate array

    if (records.length) {
      blockers.push(new Promise(resolve => {
        let updatePlacesCallback = {
          handleResult: function handleResult() {},
          handleError: function handleError(resultCode, placeInfo) {
            failed.push(placeInfo.guid);
          },
          handleCompletion: resolve,
        };
        this._asyncHistory.updatePlaces(records, updatePlacesCallback);
      }));
    }

    // failed is updated asynchronously, hence the await on blockers.
    await Promise.all(blockers);
    return failed;
  },

  /**
   * Converts a Sync history record to a mozIPlaceInfo.
   *
   * Throws if an invalid record is encountered (invalid URI, etc.),
   * returns true if the record is to be applied, false otherwise
   * (no visits to add, etc.),
   */
  async _recordToPlaceInfo(record) {
    // Sort out invalid URIs and ones Places just simply doesn't want.
    record.uri = Utils.makeURI(record.histUri);
    if (!record.uri) {
      this._log.warn("Attempted to process invalid URI, skipping.");
      throw new Error("Invalid URI in record");
    }

    if (!Utils.checkGUID(record.id)) {
      this._log.warn("Encountered record with invalid GUID: " + record.id);
      return false;
    }
    record.guid = record.id;

    if (!PlacesUtils.history.canAddURI(record.uri)) {
      this._log.trace("Ignoring record " + record.id + " with URI "
                      + record.uri.spec + ": can't add this URI.");
      return false;
    }

    // We dupe visits by date and type. So an incoming visit that has
    // the same timestamp and type as a local one won't get applied.
    // To avoid creating new objects, we rewrite the query result so we
    // can simply check for containment below.
    let curVisits = [];
    try {
      curVisits = await PlacesSyncUtils.history.fetchVisitsForURL(record.histUri);
    } catch (e) {
      this._log.error("Error while fetching visits for URL ${record.histUri}", record.histUri);
    }

    let i, k;
    for (i = 0; i < curVisits.length; i++) {
      curVisits[i] = curVisits[i].date + "," + curVisits[i].type;
    }

    // Walk through the visits, make sure we have sound data, and eliminate
    // dupes. The latter is done by rewriting the array in-place.
    for (i = 0, k = 0; i < record.visits.length; i++) {
      let visit = record.visits[k] = record.visits[i];

      if (!visit.date || typeof visit.date != "number" || !Number.isInteger(visit.date)) {
        this._log.warn("Encountered record with invalid visit date: "
                       + visit.date);
        continue;
      }

      if (!visit.type ||
          !Object.values(PlacesUtils.history.TRANSITIONS).includes(visit.type)) {
        this._log.warn("Encountered record with invalid visit type: " +
                       visit.type + "; ignoring.");
        continue;
      }

      // Dates need to be integers.
      visit.date = Math.round(visit.date);

      if (curVisits.indexOf(visit.date + "," + visit.type) != -1) {
        // Visit is a dupe, don't increment 'k' so the element will be
        // overwritten.
        continue;
      }

      visit.visitDate = visit.date;
      visit.transitionType = visit.type;
      k += 1;
    }
    record.visits.length = k; // truncate array

    // No update if there aren't any visits to apply.
    // mozIAsyncHistory::updatePlaces() wants at least one visit.
    // In any case, the only thing we could change would be the title
    // and that shouldn't change without a visit.
    if (!record.visits.length) {
      this._log.trace("Ignoring record " + record.id + " with URI "
                      + record.uri.spec + ": no visits to add.");
      return false;
    }

    return true;
  },

  async remove(record) {
    this._log.trace("Removing page: " + record.id);
    let removed = await PlacesUtils.history.remove(record.id);
    if (removed) {
      this._log.trace("Removed page: " + record.id);
    } else {
      this._log.debug("Page already removed: " + record.id);
    }
  },

  async itemExists(id) {
    return !!(await PlacesSyncUtils.history.fetchURLInfoForGuid(id));
  },

  async createRecord(id, collection) {
    let foo = await PlacesSyncUtils.history.fetchURLInfoForGuid(id);
    let record = new HistoryRec(collection, id);
    if (foo) {
      record.histUri = foo.url;
      record.title = foo.title;
      record.sortindex = foo.frecency;
      try {
        record.visits = await PlacesSyncUtils.history.fetchVisitsForURL(record.histUri);
      } catch (e) {
        this._log.error("Error while fetching visits for URL ${record.histUri}", record.histUri);
        record.visits = [];
      }
    } else {
      record.deleted = true;
    }

    return record;
  },

  async wipe() {
    return PlacesUtils.history.clear();
  }
};

function HistoryTracker(name, engine) {
  Tracker.call(this, name, engine);
}
HistoryTracker.prototype = {
  __proto__: Tracker.prototype,

  startTracking() {
    this._log.info("Adding Places observer.");
    PlacesUtils.history.addObserver(this, true);
  },

  stopTracking() {
    this._log.info("Removing Places observer.");
    PlacesUtils.history.removeObserver(this);
  },

  QueryInterface: XPCOMUtils.generateQI([
    Ci.nsINavHistoryObserver,
    Ci.nsISupportsWeakReference
  ]),

  onDeleteAffectsGUID(uri, guid, reason, source, increment) {
    if (this.ignoreAll || reason == Ci.nsINavHistoryObserver.REASON_EXPIRED) {
      return;
    }
    this._log.trace(source + ": " + uri.spec + ", reason " + reason);
    if (this.addChangedID(guid)) {
      this.score += increment;
    }
  },

  onDeleteVisits(uri, visitTime, guid, reason) {
    this.onDeleteAffectsGUID(uri, guid, reason, "onDeleteVisits", SCORE_INCREMENT_SMALL);
  },

  onDeleteURI(uri, guid, reason) {
    this.onDeleteAffectsGUID(uri, guid, reason, "onDeleteURI", SCORE_INCREMENT_XLARGE);
  },

  onVisit(uri, vid, time, session, referrer, trans, guid) {
    if (this.ignoreAll) {
      this._log.trace("ignoreAll: ignoring visit for " + guid);
      return;
    }

    this._log.trace("onVisit: " + uri.spec);
    if (this.addChangedID(guid)) {
      this.score += SCORE_INCREMENT_SMALL;
    }
  },

  onClearHistory() {
    this._log.trace("onClearHistory");
    // Note that we're going to trigger a sync, but none of the cleared
    // pages are tracked, so the deletions will not be propagated.
    // See Bug 578694.
    this.score += SCORE_INCREMENT_XLARGE;
  },

  onBeginUpdateBatch() {},
  onEndUpdateBatch() {},
  onPageChanged() {},
  onTitleChanged() {},
  onBeforeDeleteURI() {},
};
