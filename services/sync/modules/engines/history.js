/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

this.EXPORTED_SYMBOLS = ["HistoryEngine", "HistoryRec"];

var Cc = Components.classes;
var Ci = Components.interfaces;
var Cu = Components.utils;
var Cr = Components.results;

const HISTORY_TTL = 5184000; // 60 days

Cu.import("resource://gre/modules/XPCOMUtils.jsm");
Cu.import("resource://services-common/async.js");
Cu.import("resource://services-sync/constants.js");
Cu.import("resource://services-sync/engines.js");
Cu.import("resource://services-sync/record.js");
Cu.import("resource://services-sync/util.js");

XPCOMUtils.defineLazyModuleGetter(this, "PlacesUtils",
                                  "resource://gre/modules/PlacesUtils.jsm");

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

  _processIncoming(newitems) {
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
      return SyncEngine.prototype._processIncoming.call(this, newitems);
    } finally {
      notifyHistoryObservers("onEndUpdateBatch");
    }
  },

  pullNewChanges() {
    let modifiedGUIDs = Object.keys(this._tracker.changedIDs);
    if (!modifiedGUIDs.length) {
      return {};
    }

    let db = PlacesUtils.history.QueryInterface(Ci.nsPIPlacesDatabase)
                        .DBConnection;

    // Filter out hidden pages and `TRANSITION_FRAMED_LINK` visits. These are
    // excluded when rendering the history menu, so we use the same constraints
    // for Sync. We also don't want to sync `TRANSITION_EMBED` visits, but those
    // aren't stored in the database.
    for (let startIndex = 0;
         startIndex < modifiedGUIDs.length;
         startIndex += SQLITE_MAX_VARIABLE_NUMBER) {

      let chunkLength = Math.min(SQLITE_MAX_VARIABLE_NUMBER,
                                 modifiedGUIDs.length - startIndex);

      let query = `
        SELECT DISTINCT p.guid FROM moz_places p
        JOIN moz_historyvisits v ON p.id = v.place_id
        WHERE p.guid IN (${new Array(chunkLength).fill("?").join(",")}) AND
              (p.hidden = 1 OR v.visit_type IN (0,
                ${PlacesUtils.history.TRANSITION_FRAMED_LINK}))
      `;

      let statement = db.createAsyncStatement(query);
      try {
        for (let i = 0; i < chunkLength; i++) {
          statement.bindByIndex(i, modifiedGUIDs[startIndex + i]);
        }
        let results = Async.querySpinningly(statement, ["guid"]);
        let guids = results.map(result => result.guid);
        this._tracker.removeChangedID(...guids);
      } finally {
        statement.finalize();
      }
    }

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

  get _setGUIDStm() {
    return this._getStmt(
      "UPDATE moz_places " +
      "SET guid = :guid " +
      "WHERE url_hash = hash(:page_url) AND url = :page_url");
  },

  // Some helper functions to handle GUIDs
  setGUID: function setGUID(uri, guid) {
    uri = uri.spec ? uri.spec : uri;

    if (!guid) {
      guid = Utils.makeGUID();
    }

    let stmt = this._setGUIDStm;
    stmt.params.guid = guid;
    stmt.params.page_url = uri;
    Async.querySpinningly(stmt);
    return guid;
  },

  get _guidStm() {
    return this._getStmt(
      "SELECT guid " +
      "FROM moz_places " +
      "WHERE url_hash = hash(:page_url) AND url = :page_url");
  },
  _guidCols: ["guid"],

  GUIDForUri: function GUIDForUri(uri, create) {
    let stm = this._guidStm;
    stm.params.page_url = uri.spec ? uri.spec : uri;

    // Use the existing GUID if it exists
    let result = Async.querySpinningly(stm, this._guidCols)[0];
    if (result && result.guid)
      return result.guid;

    // Give the uri a GUID if it doesn't have one
    if (create)
      return this.setGUID(uri);
  },

  get _visitStm() {
    return this._getStmt(`/* do not warn (bug 599936) */
      SELECT visit_type type, visit_date date
      FROM moz_historyvisits
      JOIN moz_places h ON h.id = place_id
      WHERE url_hash = hash(:url) AND url = :url
      ORDER BY date DESC LIMIT 20`);
  },
  _visitCols: ["date", "type"],

  get _urlStm() {
    return this._getStmt(
      "SELECT url, title, frecency " +
      "FROM moz_places " +
      "WHERE guid = :guid");
  },
  _urlCols: ["url", "title", "frecency"],

  get _allUrlStm() {
    // Filter out hidden pages and framed link visits. See `pullNewChanges`
    // for more info.
    return this._getStmt(`
      SELECT DISTINCT p.url
      FROM moz_places p
      JOIN moz_historyvisits v ON p.id = v.place_id
      WHERE p.last_visit_date > :cutoff_date AND
            p.hidden = 0 AND
            v.visit_type NOT IN (0,
              ${PlacesUtils.history.TRANSITION_FRAMED_LINK})
      ORDER BY frecency DESC
      LIMIT :max_results`);
  },
  _allUrlCols: ["url"],

  // See bug 320831 for why we use SQL here
  _getVisits: function HistStore__getVisits(uri) {
    this._visitStm.params.url = uri;
    return Async.querySpinningly(this._visitStm, this._visitCols);
  },

  // See bug 468732 for why we use SQL here
  _findURLByGUID: function HistStore__findURLByGUID(guid) {
    this._urlStm.params.guid = guid;
    return Async.querySpinningly(this._urlStm, this._urlCols)[0];
  },

  changeItemID: function HStore_changeItemID(oldID, newID) {
    this.setGUID(this._findURLByGUID(oldID).url, newID);
  },


  getAllIDs: function HistStore_getAllIDs() {
    // Only get places visited within the last 30 days (30*24*60*60*1000ms)
    this._allUrlStm.params.cutoff_date = (Date.now() - 2592000000) * 1000;
    this._allUrlStm.params.max_results = MAX_HISTORY_UPLOAD;

    let urls = Async.querySpinningly(this._allUrlStm, this._allUrlCols);
    let self = this;
    return urls.reduce(function(ids, item) {
      ids[self.GUIDForUri(item.url, true)] = item.url;
      return ids;
    }, {});
  },

  applyIncomingBatch: function applyIncomingBatch(records) {
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
          promise = promise.then(null, ex => failed.push(record.id));
          blockers.push(promise);

          // No further processing needed. Remove it from the list.
          shouldApply = false;
        } else {
          shouldApply = this._recordToPlaceInfo(record);
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

    let handleAsyncOperationsComplete = Async.makeSyncCallback();

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

    // Since `failed` is updated asynchronously and this function is
    // synchronous, we need to spin-wait until we are sure that all
    // updates to `fail` have completed.
    Promise.all(blockers).then(
      handleAsyncOperationsComplete,
      ex => {
        // In case of error, terminate wait, but make sure that the
        // error is reported nevertheless and still causes test
        // failures.
        handleAsyncOperationsComplete();
        throw ex;
      });
    Async.waitForSyncCallback(handleAsyncOperationsComplete);
      return failed;
  },

  /**
   * Converts a Sync history record to a mozIPlaceInfo.
   *
   * Throws if an invalid record is encountered (invalid URI, etc.),
   * returns true if the record is to be applied, false otherwise
   * (no visits to add, etc.),
   */
  _recordToPlaceInfo: function _recordToPlaceInfo(record) {
    // Sort out invalid URIs and ones Places just simply doesn't want.
    record.uri = Utils.makeURI(record.histUri);
    if (!record.uri) {
      this._log.warn("Attempted to process invalid URI, skipping.");
      throw "Invalid URI in record";
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
    let curVisits = this._getVisits(record.histUri);
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

  remove: function HistStore_remove(record) {
    this._log.trace("Removing page: " + record.id);
    return PlacesUtils.history.remove(record.id).then(
      (removed) => {
        if (removed) {
          this._log.trace("Removed page: " + record.id);
        } else {
          this._log.debug("Page already removed: " + record.id);
        }
    });
  },

  itemExists: function HistStore_itemExists(id) {
    return !!this._findURLByGUID(id);
  },

  createRecord: function createRecord(id, collection) {
    let foo = this._findURLByGUID(id);
    let record = new HistoryRec(collection, id);
    if (foo) {
      record.histUri = foo.url;
      record.title = foo.title;
      record.sortindex = foo.frecency;
      record.visits = this._getVisits(record.histUri);
    } else {
      record.deleted = true;
    }

    return record;
  },

  wipe: function HistStore_wipe() {
    let cb = Async.makeSyncCallback();
    PlacesUtils.history.clear().then(result => { cb(null, result) }, err => { cb(err) });
    return Async.waitForSyncCallback(cb);
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
