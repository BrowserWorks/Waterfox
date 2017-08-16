/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

 /* This is a JavaScript module (JSM) to be imported via
  * Components.utils.import() and acts as a singleton. Only the following
  * listed symbols will exposed on import, and only when and where imported.
  */

var EXPORTED_SYMBOLS = ["HistoryEntry", "DumpHistory"];

const {classes: Cc, interfaces: Ci, utils: Cu} = Components;

Cu.import("resource://gre/modules/Services.jsm");
Cu.import("resource://gre/modules/PlacesUtils.jsm");
Cu.import("resource://tps/logger.jsm");
Cu.import("resource://services-common/async.js");

var DumpHistory = function TPS_History__DumpHistory() {
  let query = PlacesUtils.history.getNewQuery();
  let options = PlacesUtils.history.getNewQueryOptions();
  let root = PlacesUtils.history.executeQuery(query, options).root;
  root.containerOpen = true;
  Logger.logInfo("\n\ndumping history\n", true);
  for (var i = 0; i < root.childCount; i++) {
    let node = root.getChild(i);
    let uri = node.uri;
    let curvisits = HistoryEntry._getVisits(uri);
    for (var visit of curvisits) {
      Logger.logInfo("URI: " + uri + ", type=" + visit.type + ", date=" + visit.date, true);
    }
  }
  root.containerOpen = false;
  Logger.logInfo("\nend history dump\n", true);
};

/**
 * HistoryEntry object
 *
 * Contains methods for manipulating browser history entries.
 */
var HistoryEntry = {
  /**
   * _db
   *
   * Returns the DBConnection object for the history service.
   */
  get _db() {
    return PlacesUtils.history.QueryInterface(Ci.nsPIPlacesDatabase).DBConnection;
  },

  /**
   * _visitStm
   *
   * Return the SQL statement for getting history visit information
   * from the moz_historyvisits table.  Borrowed from Weave's
   * history.js.
   */
  get _visitStm() {
    let stm = this._db.createStatement(
      "SELECT visit_type type, visit_date date " +
      "FROM moz_historyvisits " +
      "WHERE place_id = (" +
        "SELECT id " +
        "FROM moz_places " +
        "WHERE url_hash = hash(:url) AND url = :url) " +
      "ORDER BY date DESC LIMIT 20");
    this.__defineGetter__("_visitStm", () => stm);
    return stm;
  },

  /**
   * _getVisits
   *
   * Gets history information about visits to a given uri.
   *
   * @param uri The uri to get visits for
   * @return an array of objects with 'date' and 'type' properties,
   * corresponding to the visits in the history database for the
   * given uri
   */
  _getVisits: function HistStore__getVisits(uri) {
    this._visitStm.params.url = uri;
    return Async.querySpinningly(this._visitStm, ["date", "type"]);
  },

  /**
   * Add
   *
   * Adds visits for a uri to the history database.  Throws on error.
   *
   * @param item An object representing one or more visits to a specific uri
   * @param usSinceEpoch The number of microseconds from Epoch to
   *        the time the current Crossweave run was started
   * @return nothing
   */
  Add(item, usSinceEpoch) {
    Logger.AssertTrue("visits" in item && "uri" in item,
      "History entry in test file must have both 'visits' " +
      "and 'uri' properties");
    let uri = Services.io.newURI(item.uri);
    let place = {
      uri,
      visits: []
    };
    for (let visit of item.visits) {
      place.visits.push({
        visitDate: usSinceEpoch + (visit.date * 60 * 60 * 1000 * 1000),
        transitionType: visit.type
      });
    }
    if ("title" in item) {
      place.title = item.title;
    }
    let cb = Async.makeSpinningCallback();
    PlacesUtils.asyncHistory.updatePlaces(place, {
        handleError: function Add_handleError() {
          cb(new Error("Error adding history entry"));
        },
        handleResult: function Add_handleResult() {
          cb();
        },
        handleCompletion: function Add_handleCompletion() {
          // Nothing to do
        }
    });
    // Spin the event loop to embed this async call in a sync API
    cb.wait();
  },

  /**
   * Find
   *
   * Finds visits for a uri to the history database.  Throws on error.
   *
   * @param item An object representing one or more visits to a specific uri
   * @param usSinceEpoch The number of microseconds from Epoch to
   *        the time the current Crossweave run was started
   * @return true if all the visits for the uri are found, otherwise false
   */
  Find(item, usSinceEpoch) {
    Logger.AssertTrue("visits" in item && "uri" in item,
      "History entry in test file must have both 'visits' " +
      "and 'uri' properties");
    let curvisits = this._getVisits(item.uri);
    for (let visit of curvisits) {
      for (let itemvisit of item.visits) {
        let expectedDate = itemvisit.date * 60 * 60 * 1000 * 1000
            + usSinceEpoch;
        if (visit.type == itemvisit.type && visit.date == expectedDate) {
          itemvisit.found = true;
        }
      }
    }

    let all_items_found = true;
    for (let itemvisit of item.visits) {
      all_items_found = all_items_found && "found" in itemvisit;
      Logger.logInfo("History entry for " + item.uri + ", type:" +
              itemvisit.type + ", date:" + itemvisit.date +
              ("found" in itemvisit ? " is present" : " is not present"));
    }
    return all_items_found;
  },

  /**
   * Delete
   *
   * Removes visits from the history database. Throws on error.
   *
   * @param item An object representing items to delete
   * @param usSinceEpoch The number of microseconds from Epoch to
   *        the time the current Crossweave run was started
   * @return nothing
   */
  Delete(item, usSinceEpoch) {
    if ("uri" in item) {
      Async.promiseSpinningly(PlacesUtils.history.remove(item.uri));
    } else if ("host" in item) {
      PlacesUtils.history.removePagesFromHost(item.host, false);
    } else if ("begin" in item && "end" in item) {
      let cb = Async.makeSpinningCallback();
      let msSinceEpoch = parseInt(usSinceEpoch / 1000);
      let filter = {
        beginDate: new Date(msSinceEpoch + (item.begin * 60 * 60 * 1000)),
        endDate: new Date(msSinceEpoch + (item.end * 60 * 60 * 1000))
      };
      PlacesUtils.history.removeVisitsByFilter(filter)
      .catch(ex => Logger.AssertTrue(false, "An error occurred while deleting history: " + ex))
      .then(result => { cb(null, result) }, err => { cb(err) });
      Async.waitForSyncCallback(cb);
    } else {
      Logger.AssertTrue(false, "invalid entry in delete history");
    }
  },
};
