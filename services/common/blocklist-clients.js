/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

this.EXPORTED_SYMBOLS = ["AddonBlocklistClient",
                         "GfxBlocklistClient",
                         "OneCRLBlocklistClient",
                         "PluginBlocklistClient",
                         "FILENAME_ADDONS_JSON",
                         "FILENAME_GFX_JSON",
                         "FILENAME_PLUGINS_JSON"];

const { classes: Cc, interfaces: Ci, utils: Cu } = Components;

Cu.import("resource://gre/modules/Services.jsm");
const { Task } = Cu.import("resource://gre/modules/Task.jsm");
const { OS } = Cu.import("resource://gre/modules/osfile.jsm");
Cu.importGlobalProperties(["fetch"]);

const { loadKinto } = Cu.import("resource://services-common/kinto-offline-client.js");
const { KintoHttpClient } = Cu.import("resource://services-common/kinto-http-client.js");
const { CanonicalJSON } = Components.utils.import("resource://gre/modules/CanonicalJSON.jsm");

const PREF_SETTINGS_SERVER                   = "services.settings.server";
const PREF_BLOCKLIST_BUCKET                  = "services.blocklist.bucket";
const PREF_BLOCKLIST_ONECRL_COLLECTION       = "services.blocklist.onecrl.collection";
const PREF_BLOCKLIST_ONECRL_CHECKED_SECONDS  = "services.blocklist.onecrl.checked";
const PREF_BLOCKLIST_ADDONS_COLLECTION       = "services.blocklist.addons.collection";
const PREF_BLOCKLIST_ADDONS_CHECKED_SECONDS  = "services.blocklist.addons.checked";
const PREF_BLOCKLIST_PLUGINS_COLLECTION      = "services.blocklist.plugins.collection";
const PREF_BLOCKLIST_PLUGINS_CHECKED_SECONDS = "services.blocklist.plugins.checked";
const PREF_BLOCKLIST_GFX_COLLECTION          = "services.blocklist.gfx.collection";
const PREF_BLOCKLIST_GFX_CHECKED_SECONDS     = "services.blocklist.gfx.checked";
const PREF_BLOCKLIST_ENFORCE_SIGNING         = "services.blocklist.signing.enforced";

const INVALID_SIGNATURE = "Invalid content/signature";

this.FILENAME_ADDONS_JSON  = "blocklist-addons.json";
this.FILENAME_GFX_JSON     = "blocklist-gfx.json";
this.FILENAME_PLUGINS_JSON = "blocklist-plugins.json";

function mergeChanges(localRecords, changes) {
  // Kinto.js adds attributes to local records that aren't present on server.
  // (e.g. _status)
  const stripPrivateProps = (obj) => {
    return Object.keys(obj).reduce((current, key) => {
      if (!key.startsWith("_")) {
        current[key] = obj[key];
      }
      return current;
    }, {});
  };

  const records = {};
  // Local records by id.
  localRecords.forEach((record) => records[record.id] = stripPrivateProps(record));
  // All existing records are replaced by the version from the server.
  changes.forEach((record) => records[record.id] = record);

  return Object.values(records)
    // Filter out deleted records.
    .filter((record) => record.deleted != true)
    // Sort list by record id.
    .sort((a, b) => a.id < b.id ? -1 : a.id > b.id ? 1 : 0);
}


function fetchCollectionMetadata(collection) {
  const client = new KintoHttpClient(collection.api.remote);
  return client.bucket(collection.bucket).collection(collection.name).getData()
    .then(result => {
      return result.signature;
    });
}

function fetchRemoteCollection(collection) {
  const client = new KintoHttpClient(collection.api.remote);
  return client.bucket(collection.bucket)
           .collection(collection.name)
           .listRecords({sort: "id"});
}

/**
 * Helper to instantiate a Kinto client based on preferences for remote server
 * URL and bucket name. It uses the `FirefoxAdapter` which relies on SQLite to
 * persist the local DB.
 */
function kintoClient() {
  let base = Services.prefs.getCharPref(PREF_SETTINGS_SERVER);
  let bucket = Services.prefs.getCharPref(PREF_BLOCKLIST_BUCKET);

  let Kinto = loadKinto();

  let FirefoxAdapter = Kinto.adapters.FirefoxAdapter;

  let config = {
    remote: base,
    bucket: bucket,
    adapter: FirefoxAdapter,
  };

  return new Kinto(config);
}


class BlocklistClient {

  constructor(collectionName, lastCheckTimePref, processCallback, signerName) {
    this.collectionName = collectionName;
    this.lastCheckTimePref = lastCheckTimePref;
    this.processCallback = processCallback;
    this.signerName = signerName;
  }

  validateCollectionSignature(payload, collection, ignoreLocal) {
    return Task.spawn((function* () {
      // this is a content-signature field from an autograph response.
      const {x5u, signature} = yield fetchCollectionMetadata(collection);
      const certChain = yield fetch(x5u).then((res) => res.text());

      const verifier = Cc["@mozilla.org/security/contentsignatureverifier;1"]
                         .createInstance(Ci.nsIContentSignatureVerifier);

      let toSerialize;
      if (ignoreLocal) {
        toSerialize = {
          last_modified: `${payload.last_modified}`,
          data: payload.data
        };
      } else {
        const localRecords = (yield collection.list()).data;
        const records = mergeChanges(localRecords, payload.changes);
        toSerialize = {
          last_modified: `${payload.lastModified}`,
          data: records
        };
      }

      const serialized = CanonicalJSON.stringify(toSerialize);

      if (verifier.verifyContentSignature(serialized, "p384ecdsa=" + signature,
                                          certChain,
                                          this.signerName)) {
        // In case the hash is valid, apply the changes locally.
        return payload;
      }
      throw new Error(INVALID_SIGNATURE);
    }).bind(this));
  }

  /**
   * Synchronize from Kinto server, if necessary.
   *
   * @param {int}  lastModified the lastModified date (on the server) for
                                the remote collection.
   * @param {Date} serverTime   the current date return by the server.
   * @return {Promise}          which rejects on sync or process failure.
   */
  maybeSync(lastModified, serverTime) {
    let db = kintoClient();
    let opts = {};
    let enforceCollectionSigning =
      Services.prefs.getBoolPref(PREF_BLOCKLIST_ENFORCE_SIGNING);

    // if there is a signerName and collection signing is enforced, add a
    // hook for incoming changes that validates the signature
    if (this.signerName && enforceCollectionSigning) {
      opts.hooks = {
        "incoming-changes": [this.validateCollectionSignature.bind(this)]
      }
    }

    let collection = db.collection(this.collectionName, opts);

    return Task.spawn((function* syncCollection() {
      try {
        yield collection.db.open();

        let collectionLastModified = yield collection.db.getLastModified();
        // If the data is up to date, there's no need to sync. We still need
        // to record the fact that a check happened.
        if (lastModified <= collectionLastModified) {
          this.updateLastCheck(serverTime);
          return;
        }
        // Fetch changes from server.
        try {
          let syncResult = yield collection.sync();
          if (!syncResult.ok) {
            throw new Error("Sync failed");
          }
        } catch (e) {
          if (e.message == INVALID_SIGNATURE) {
            // if sync fails with a signature error, it's likely that our
            // local data has been modified in some way.
            // We will attempt to fix this by retrieving the whole
            // remote collection.
            let payload = yield fetchRemoteCollection(collection);
            yield this.validateCollectionSignature(payload, collection, true);
            // if the signature is good (we haven't thrown), and the remote
            // last_modified is newer than the local last_modified, replace the
            // local data
            const localLastModified = yield collection.db.getLastModified();
            if (payload.last_modified >= localLastModified) {
              yield collection.clear();
              yield collection.loadDump(payload.data);
            }
          } else {
            throw e;
          }
        }
        // Read local collection of records.
        let list = yield collection.list();

        yield this.processCallback(list.data);

        // Track last update.
        this.updateLastCheck(serverTime);
      } finally {
        collection.db.close();
      }
    }).bind(this));
  }

  /**
   * Save last time server was checked in users prefs.
   *
   * @param {Date} serverTime   the current date return by server.
   */
  updateLastCheck(serverTime) {
    let checkedServerTimeInSeconds = Math.round(serverTime / 1000);
    Services.prefs.setIntPref(this.lastCheckTimePref, checkedServerTimeInSeconds);
  }
}

/**
 * Revoke the appropriate certificates based on the records from the blocklist.
 *
 * @param {Object} records   current records in the local db.
 */
function* updateCertBlocklist(records) {
  let certList = Cc["@mozilla.org/security/certblocklist;1"]
                   .getService(Ci.nsICertBlocklist);
  for (let item of records) {
    try {
      if (item.issuerName && item.serialNumber) {
        certList.revokeCertByIssuerAndSerial(item.issuerName,
                                            item.serialNumber);
      } else if (item.subject && item.pubKeyHash) {
        certList.revokeCertBySubjectAndPubKey(item.subject,
                                              item.pubKeyHash);
      }
    } catch (e) {
      // prevent errors relating to individual blocklist entries from
      // causing sync to fail. At some point in the future, we may want to
      // accumulate telemetry on these failures.
      Cu.reportError(e);
    }
  }
  certList.saveEntries();
}

/**
 * Write list of records into JSON file, and notify nsBlocklistService.
 *
 * @param {String} filename  path relative to profile dir.
 * @param {Object} records   current records in the local db.
 */
function* updateJSONBlocklist(filename, records) {
  // Write JSON dump for synchronous load at startup.
  const path = OS.Path.join(OS.Constants.Path.profileDir, filename);
  const serialized = JSON.stringify({data: records}, null, 2);
  try {
    yield OS.File.writeAtomic(path, serialized, {tmpPath: path + ".tmp"});

    // Notify change to `nsBlocklistService`
    const eventData = {filename: filename};
    Services.cpmm.sendAsyncMessage("Blocklist:reload-from-disk", eventData);
  } catch(e) {
    Cu.reportError(e);
  }
}


this.OneCRLBlocklistClient = new BlocklistClient(
  Services.prefs.getCharPref(PREF_BLOCKLIST_ONECRL_COLLECTION),
  PREF_BLOCKLIST_ONECRL_CHECKED_SECONDS,
  updateCertBlocklist,
  "onecrl.content-signature.mozilla.org"
);

this.AddonBlocklistClient = new BlocklistClient(
  Services.prefs.getCharPref(PREF_BLOCKLIST_ADDONS_COLLECTION),
  PREF_BLOCKLIST_ADDONS_CHECKED_SECONDS,
  updateJSONBlocklist.bind(undefined, FILENAME_ADDONS_JSON)
);

this.GfxBlocklistClient = new BlocklistClient(
  Services.prefs.getCharPref(PREF_BLOCKLIST_GFX_COLLECTION),
  PREF_BLOCKLIST_GFX_CHECKED_SECONDS,
  updateJSONBlocklist.bind(undefined, FILENAME_GFX_JSON)
);

this.PluginBlocklistClient = new BlocklistClient(
  Services.prefs.getCharPref(PREF_BLOCKLIST_PLUGINS_COLLECTION),
  PREF_BLOCKLIST_PLUGINS_CHECKED_SECONDS,
  updateJSONBlocklist.bind(undefined, FILENAME_PLUGINS_JSON)
);
