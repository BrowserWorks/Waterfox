# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

var Cu = Components.utils;
Cu.import("resource://gre/modules/Services.jsm");

// This is the only implementation of nsIUrlListManager.
// A class that manages lists, namely white and black lists for
// phishing or malware protection. The ListManager knows how to fetch,
// update, and store lists.
//
// There is a single listmanager for the whole application.
//
// TODO more comprehensive update tests, for example add unittest check
//      that the listmanagers tables are properly written on updates

// Lower and upper limits on the server-provided polling frequency
const minDelayMs = 5 * 60 * 1000;
const maxDelayMs = 24 * 60 * 60 * 1000;

// Log only if browser.safebrowsing.debug is true
this.log = function log(...stuff) {
  var prefs_ = new G_Preferences();
  var debug = prefs_.getPref("browser.safebrowsing.debug");
  if (!debug) {
    return;
  }

  var d = new Date();
  let msg = "listmanager: " + d.toTimeString() + ": " + stuff.join(" ");
  msg = Services.urlFormatter.trimSensitiveURLs(msg);
  Services.console.logStringMessage(msg);
  dump(msg + "\n");
}

this.QueryAdapter = function QueryAdapter(callback) {
  this.callback_ = callback;
};

QueryAdapter.prototype.handleResponse = function(value) {
  this.callback_.handleEvent(value);
}

/**
 * A ListManager keeps track of black and white lists and knows
 * how to update them.
 *
 * @constructor
 */
this.PROT_ListManager = function PROT_ListManager() {
  log("Initializing list manager");
  this.prefs_ = new G_Preferences();
  this.updateInterval = this.prefs_.getPref("urlclassifier.updateinterval", 30 * 60) * 1000;

  // A map of tableNames to objects of type
  // { updateUrl: <updateUrl>, gethashUrl: <gethashUrl> }
  this.tablesData = {};
  // A map of updateUrls to maps of tables requiring updates, e.g.
  // { safebrowsing-update-url: { goog-phish-shavar: true,
  //                              goog-malware-shavar: true }
  this.needsUpdate_ = {};

  this.observerServiceObserver_ = new G_ObserverServiceObserver(
                                          'quit-application',
                                          BindToObject(this.shutdown_, this),
                                          true /*only once*/);

  // A map of updateUrls to single-use G_Alarms. An entry exists if and only if
  // there is at least one table with updates enabled for that url. G_Alarms
  // are reset when enabling/disabling updates or on update callbacks (update
  // success, update failure, download error).
  this.updateCheckers_ = {};
  this.requestBackoffs_ = {};
  this.dbService_ = Cc["@mozilla.org/url-classifier/dbservice;1"]
                   .getService(Ci.nsIUrlClassifierDBService);


  this.hashCompleter_ = Cc["@mozilla.org/url-classifier/hashcompleter;1"]
                        .getService(Ci.nsIUrlClassifierHashCompleter);
}

/**
 * xpcom-shutdown callback
 * Delete all of our data tables which seem to leak otherwise.
 */
PROT_ListManager.prototype.shutdown_ = function() {
  for (var name in this.tablesData) {
    delete this.tablesData[name];
  }
}

/**
 * Register a new table table
 * @param tableName - the name of the table
 * @param updateUrl - the url for updating the table
 * @param gethashUrl - the url for fetching hash completions
 * @returns true if the table could be created; false otherwise
 */
PROT_ListManager.prototype.registerTable = function(tableName,
                                                    providerName,
                                                    updateUrl,
                                                    gethashUrl) {
  log("registering " + tableName + " with " + updateUrl);
  if (!updateUrl) {
    log("Can't register table " + tableName + " without updateUrl");
    return false;
  }
  this.tablesData[tableName] = {};
  this.tablesData[tableName].updateUrl = updateUrl;
  this.tablesData[tableName].gethashUrl = gethashUrl;
  this.tablesData[tableName].provider = providerName;

  // Keep track of all of our update URLs.
  if (!this.needsUpdate_[updateUrl]) {
    this.needsUpdate_[updateUrl] = {};

    // Using the V4 backoff algorithm for both V2 and V4. See bug 1273398.
    this.requestBackoffs_[updateUrl] = new RequestBackoffV4(
                                            4 /* num requests */,
                                   60*60*1000 /* request time, 60 min */);
  }
  this.needsUpdate_[updateUrl][tableName] = false;

  return true;
}

PROT_ListManager.prototype.getGethashUrl = function(tableName) {
  if (this.tablesData[tableName] && this.tablesData[tableName].gethashUrl) {
    return this.tablesData[tableName].gethashUrl;
  }
  return "";
}

/**
 * Enable updates for some tables
 * @param tables - an array of table names that need updating
 */
PROT_ListManager.prototype.enableUpdate = function(tableName) {
  var table = this.tablesData[tableName];
  if (table) {
    log("Enabling table updates for " + tableName);
    this.needsUpdate_[table.updateUrl][tableName] = true;
  }
}

/**
 * Returns true if any table associated with the updateUrl requires updates.
 * @param updateUrl - the updateUrl
 */
PROT_ListManager.prototype.updatesNeeded_ = function(updateUrl) {
  let updatesNeeded = false;
  for (var tableName in this.needsUpdate_[updateUrl]) {
    if (this.needsUpdate_[updateUrl][tableName]) {
      updatesNeeded = true;
    }
  }
  return updatesNeeded;
}

/**
 * Disables updates for some tables
 * @param tables - an array of table names that no longer need updating
 */
PROT_ListManager.prototype.disableUpdate = function(tableName) {
  var table = this.tablesData[tableName];
  if (table) {
    log("Disabling table updates for " + tableName);
    this.needsUpdate_[table.updateUrl][tableName] = false;
    if (!this.updatesNeeded_(table.updateUrl) &&
        this.updateCheckers_[table.updateUrl]) {
      this.updateCheckers_[table.updateUrl].cancel();
      this.updateCheckers_[table.updateUrl] = null;
    }
  }
}

/**
 * Determine if we have some tables that need updating.
 */
PROT_ListManager.prototype.requireTableUpdates = function() {
  for (var name in this.tablesData) {
    // Tables that need updating even if other tables don't require it
    if (this.needsUpdate_[this.tablesData[name].updateUrl][name]) {
      return true;
    }
  }

  return false;
}

/**
 * Acts as a nsIUrlClassifierCallback for getTables.
 */
PROT_ListManager.prototype.kickoffUpdate_ = function (onDiskTableData)
{
  this.startingUpdate_ = false;
  var initialUpdateDelay = 3000;
  // Add a fuzz of 0-1 minutes for both v2 and v4 according to Bug 1305478.
  initialUpdateDelay += Math.floor(Math.random() * (1 * 60 * 1000));

  // If the user has never downloaded tables, do the check now.
  log("needsUpdate: " + JSON.stringify(this.needsUpdate_, undefined, 2));
  for (var updateUrl in this.needsUpdate_) {
    // If we haven't already kicked off updates for this updateUrl, set a
    // non-repeating timer for it. The timer delay will be reset either on
    // updateSuccess to this.updateInterval, or backed off on downloadError.
    // Don't set the updateChecker unless at least one table has updates
    // enabled.
    if (this.updatesNeeded_(updateUrl) && !this.updateCheckers_[updateUrl]) {
      let provider = null;
      Object.keys(this.tablesData).forEach(function(table) {
        if (this.tablesData[table].updateUrl === updateUrl) {
          let newProvider = this.tablesData[table].provider;
          if (provider) {
            if (newProvider !== provider) {
              log("Multiple tables for the same updateURL have a different provider?!");
            }
          } else {
            provider = newProvider;
          }
        }
      }, this);
      log("Initializing update checker for " + updateUrl
          + " provided by " + provider);

      // Use the initialUpdateDelay + fuzz unless we had previous updates
      // and the server told us when to try again.
      let updateDelay = initialUpdateDelay;
      let targetPref = "browser.safebrowsing.provider." + provider + ".nextupdatetime";
      let nextUpdate = this.prefs_.getPref(targetPref);
      if (nextUpdate) {
        updateDelay = Math.min(maxDelayMs, Math.max(0, nextUpdate - Date.now()));
        log("Next update at " + nextUpdate);
      }
      log("Next update " + updateDelay + "ms from now");

      // Set the last update time to verify if data is still valid.
      let freshnessPref = "browser.safebrowsing.provider." + provider + ".lastupdatetime";
      let freshness = this.prefs_.getPref(freshnessPref);
      if (freshness) {
        Object.keys(this.tablesData).forEach(function(table) {
        if (this.tablesData[table].provider === provider) {
          this.dbService_.setLastUpdateTime(table, freshness);
        }}, this);
      }

      this.updateCheckers_[updateUrl] =
        new G_Alarm(BindToObject(this.checkForUpdates, this, updateUrl),
                    updateDelay, false /* repeating */);
    } else {
      log("No updates needed or already initialized for " + updateUrl);
    }
  }
}

PROT_ListManager.prototype.stopUpdateCheckers = function() {
  log("Stopping updates");
  for (var updateUrl in this.updateCheckers_) {
    if (this.updateCheckers_[updateUrl]) {
      this.updateCheckers_[updateUrl].cancel();
      this.updateCheckers_[updateUrl] = null;
    }
  }
}

/**
 * Determine if we have any tables that require updating.  Different
 * Wardens may call us with new tables that need to be updated.
 */
PROT_ListManager.prototype.maybeToggleUpdateChecking = function() {
  // We update tables if we have some tables that want updates.  If there
  // are no tables that want to be updated - we dont need to check anything.
  if (this.requireTableUpdates()) {
    log("Starting managing lists");

    // Get the list of existing tables from the DBService before making any
    // update requests.
    if (!this.startingUpdate_) {
      this.startingUpdate_ = true;
      // check the current state of tables in the database
      this.dbService_.getTables(BindToObject(this.kickoffUpdate_, this));
    }
  } else {
    log("Stopping managing lists (if currently active)");
    this.stopUpdateCheckers();                    // Cancel pending updates
  }
}

/**
 * Provides an exception free way to look up the data in a table. We
 * use this because at certain points our tables might not be loaded,
 * and querying them could throw.
 *
 * @param table String Name of the table that we want to consult
 * @param key Principal being used to lookup the database
 * @param callback nsIUrlListManagerCallback (ie., Function) given false or the
 *        value in the table corresponding to key.  If the table name does not
 *        exist, we return false, too.
 */
PROT_ListManager.prototype.safeLookup = function(key, callback) {
  try {
    log("safeLookup: " + key);
    var cb = new QueryAdapter(callback);
    this.dbService_.lookup(key,
                           BindToObject(cb.handleResponse, cb),
                           true);
  } catch(e) {
    log("safeLookup masked failure for key " + key + ": " + e);
    callback.handleEvent("");
  }
}

/**
 * Updates our internal tables from the update server
 *
 * @param updateUrl: request updates for tables associated with that url, or
 * for all tables if the url is empty.
 */
PROT_ListManager.prototype.checkForUpdates = function(updateUrl) {
  log("checkForUpdates with " + updateUrl);
  // See if we've triggered the request backoff logic.
  if (!updateUrl) {
    return false;
  }
  if (!this.requestBackoffs_[updateUrl] ||
      !this.requestBackoffs_[updateUrl].canMakeRequest()) {
    log("Can't make update request");
    return false;
  }
  // Grab the current state of the tables from the database
  this.dbService_.getTables(BindToObject(this.makeUpdateRequest_, this,
                            updateUrl));
  return true;
}

/**
 * Method that fires the actual HTTP update request.
 * First we reset any tables that have disappeared.
 * @param tableData List of table data already in the database, in the form
 *        tablename;<chunk ranges>\n
 */
PROT_ListManager.prototype.makeUpdateRequest_ = function(updateUrl, tableData) {
  log("this.tablesData: " + JSON.stringify(this.tablesData, undefined, 2));
  log("existing chunks: " + tableData + "\n");
  // Disallow blank updateUrls
  if (!updateUrl) {
    return;
  }
  // An object of the form
  // { tableList: comma-separated list of tables to request,
  //   tableNames: map of tables that need updating,
  //   request: list of tables and existing chunk ranges from tableData
  // }
  var streamerMap = { tableList: null,
                      tableNames: {},
                      requestPayload: "",
                      isPostRequest: true };

  let useProtobuf = false;
  let onceThru = false;
  for (var tableName in this.tablesData) {
    // Skip tables not matching this update url
    if (this.tablesData[tableName].updateUrl != updateUrl) {
      continue;
    }

    // Check if |updateURL| is for 'proto'. (only v4 uses protobuf for now.)
    // We use the table name 'goog-*-proto' and an additional provider "google4"
    // to describe the v4 settings.
    let isCurTableProto = tableName.endsWith('-proto');
    if (!onceThru) {
      useProtobuf = isCurTableProto;
      onceThru = true;
    } else if (useProtobuf !== isCurTableProto) {
      log('ERROR: Cannot mix "proto" tables with other types ' +
          'within the same provider.');
    }

    if (this.needsUpdate_[this.tablesData[tableName].updateUrl][tableName]) {
      streamerMap.tableNames[tableName] = true;
    }
    if (!streamerMap.tableList) {
      streamerMap.tableList = tableName;
    } else {
      streamerMap.tableList += "," + tableName;
    }
  }

  if (useProtobuf) {
    let tableArray = [];
    Object.keys(streamerMap.tableNames).forEach(aTableName => {
      if (streamerMap.tableNames[aTableName]) {
        tableArray.push(aTableName);
      }
    });

    // Build the <tablename, stateBase64> mapping.
    let tableState = {};
    tableData.split("\n").forEach(line => {
      let p = line.indexOf(";");
      if (-1 === p) {
        return;
      }
      let tableName = line.substring(0, p);
      let metadata = line.substring(p + 1).split(":");
      let stateBase64 = metadata[0];
      log(tableName + " ==> " + stateBase64);
      tableState[tableName] = stateBase64;
    });

    // The state is a byte stream which server told us from the
    // last table update. The state would be used to do the partial
    // update and the empty string means the table has
    // never been downloaded. See Bug 1287058 for supporting
    // partial update.
    let stateArray = [];
    tableArray.forEach(listName => {
      stateArray.push(tableState[listName] || "");
    });

    log("stateArray: " + stateArray);

    let urlUtils = Cc["@mozilla.org/url-classifier/utils;1"]
                     .getService(Ci.nsIUrlClassifierUtils);

    streamerMap.requestPayload = urlUtils.makeUpdateRequestV4(tableArray,
                                                              stateArray,
                                                              tableArray.length);
    streamerMap.isPostRequest = false;
  } else {
    // Build the request. For each table already in the database, include the
    // chunk data from the database
    var lines = tableData.split("\n");
    for (var i = 0; i < lines.length; i++) {
      var fields = lines[i].split(";");
      var name = fields[0];
      if (streamerMap.tableNames[name]) {
        streamerMap.requestPayload += lines[i] + "\n";
        delete streamerMap.tableNames[name];
      }
    }
    // For each requested table that didn't have chunk data in the database,
    // request it fresh
    for (let tableName in streamerMap.tableNames) {
      streamerMap.requestPayload += tableName + ";\n";
    }

    streamerMap.isPostRequest = true;
  }

  log("update request: " + JSON.stringify(streamerMap, undefined, 2) + "\n");

  // Don't send an empty request.
  if (streamerMap.requestPayload.length > 0) {
    this.makeUpdateRequestForEntry_(updateUrl, streamerMap.tableList,
                                    streamerMap.requestPayload,
                                    streamerMap.isPostRequest);
  } else {
    // We were disabled between kicking off getTables and now.
    log("Not sending empty request");
  }
}

PROT_ListManager.prototype.makeUpdateRequestForEntry_ = function(updateUrl,
                                                                 tableList,
                                                                 requestPayload,
                                                                 isPostRequest) {
  log("makeUpdateRequestForEntry_: requestPayload " + requestPayload +
      " update: " + updateUrl + " tablelist: " + tableList + "\n");
  var streamer = Cc["@mozilla.org/url-classifier/streamupdater;1"]
                 .getService(Ci.nsIUrlClassifierStreamUpdater);

  this.requestBackoffs_[updateUrl].noteRequest();

  if (!streamer.downloadUpdates(
        tableList,
        requestPayload,
        isPostRequest,
        updateUrl,
        BindToObject(this.updateSuccess_, this, tableList, updateUrl),
        BindToObject(this.updateError_, this, tableList, updateUrl),
        BindToObject(this.downloadError_, this, tableList, updateUrl))) {
    // Our alarm gets reset in one of the 3 callbacks.
    log("pending update, queued request until later");
  }
}

/**
 * Callback function if the update request succeeded.
 * @param waitForUpdate String The number of seconds that the client should
 *        wait before requesting again.
 */
PROT_ListManager.prototype.updateSuccess_ = function(tableList, updateUrl,
                                                     waitForUpdateSec) {
  log("update success for " + tableList + " from " + updateUrl + ": " +
      waitForUpdateSec + "\n");

  // The time unit below are all milliseconds if not specified.

  var delay = 0;
  if (waitForUpdateSec) {
    delay = parseInt(waitForUpdateSec, 10) * 1000;
  }
  // As long as the delay is something sane (5 min to 1 day), update
  // our delay time for requesting updates. We always use a non-repeating
  // timer since the delay is set differently at every callback.
  if (delay > maxDelayMs) {
    log("Ignoring delay from server (too long), waiting " +
        maxDelayMs + "ms");
    delay = maxDelayMs;
  } else if (delay < minDelayMs) {
    log("Ignoring delay from server (too short), waiting " +
        this.updateInterval + "ms");
    delay = this.updateInterval;
  } else {
    log("Waiting " + delay + "ms");
  }
  this.updateCheckers_[updateUrl] =
    new G_Alarm(BindToObject(this.checkForUpdates, this, updateUrl),
                delay, false);

  // Let the backoff object know that we completed successfully.
  this.requestBackoffs_[updateUrl].noteServerResponse(200);

  // Set last update time for provider
  // Get the provider for these tables, check for consistency
  let tables = tableList.split(",");
  let provider = null;
  for (let table of tables) {
    let newProvider = this.tablesData[table].provider;
    if (provider) {
      if (newProvider !== provider) {
        log("Multiple tables for the same updateURL have a different provider?!");
      }
    } else {
      provider = newProvider;
    }
  }

  // Store the last update time (needed to know if the table is "fresh")
  // and the next update time (to know when to update next).
  let lastUpdatePref = "browser.safebrowsing.provider." + provider + ".lastupdatetime";
  let now = Date.now();
  log("Setting last update of " + provider + " to " + now);
  this.prefs_.setPref(lastUpdatePref, now.toString());

  let nextUpdatePref = "browser.safebrowsing.provider." + provider + ".nextupdatetime";
  let targetTime = now + delay;
  log("Setting next update of " + provider + " to " + targetTime
      + " (" + delay + "ms from now)");
  this.prefs_.setPref(nextUpdatePref, targetTime.toString());
}

/**
 * Callback function if the update request succeeded.
 * @param result String The error code of the failure
 */
PROT_ListManager.prototype.updateError_ = function(table, updateUrl, result) {
  log("update error for " + table + " from " + updateUrl + ": " + result + "\n");
  // There was some trouble applying the updates. Don't try again for at least
  // updateInterval milliseconds.
  this.updateCheckers_[updateUrl] =
    new G_Alarm(BindToObject(this.checkForUpdates, this, updateUrl),
                this.updateInterval, false);
}

/**
 * Callback function when the download failed
 * @param status String http status or an empty string if connection refused.
 */
PROT_ListManager.prototype.downloadError_ = function(table, updateUrl, status) {
  log("download error for " + table + ": " + status + "\n");
  // If status is empty, then we assume that we got an NS_CONNECTION_REFUSED
  // error.  In this case, we treat this is a http 500 error.
  if (!status) {
    status = 500;
  }
  status = parseInt(status, 10);
  this.requestBackoffs_[updateUrl].noteServerResponse(status);
  var delay = this.updateInterval;
  if (this.requestBackoffs_[updateUrl].isErrorStatus(status)) {
    // Schedule an update for when our backoff is complete
    delay = this.requestBackoffs_[updateUrl].nextRequestDelay();
  } else {
    log("Got non error status for error callback?!");
  }
  this.updateCheckers_[updateUrl] =
    new G_Alarm(BindToObject(this.checkForUpdates, this, updateUrl),
                delay, false);

}

PROT_ListManager.prototype.QueryInterface = function(iid) {
  if (iid.equals(Ci.nsISupports) ||
      iid.equals(Ci.nsIUrlListManager) ||
      iid.equals(Ci.nsITimerCallback))
    return this;

  throw Components.results.NS_ERROR_NO_INTERFACE;
}
