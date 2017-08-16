/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

this.EXPORTED_SYMBOLS = ["checkVersions", "addTestBlocklistClient"];

const { classes: Cc, Constructor: CC, interfaces: Ci, utils: Cu } = Components;

Cu.import("resource://gre/modules/XPCOMUtils.jsm");
Cu.import("resource://gre/modules/Services.jsm");
Cu.importGlobalProperties(["fetch"]);
XPCOMUtils.defineLazyModuleGetter(this, "UptakeTelemetry",
                                  "resource://services-common/uptake-telemetry.js");

const PREF_SETTINGS_SERVER              = "services.settings.server";
const PREF_SETTINGS_SERVER_BACKOFF      = "services.settings.server.backoff";
const PREF_BLOCKLIST_CHANGES_PATH       = "services.blocklist.changes.path";
const PREF_BLOCKLIST_LAST_UPDATE        = "services.blocklist.last_update_seconds";
const PREF_BLOCKLIST_LAST_ETAG          = "services.blocklist.last_etag";
const PREF_BLOCKLIST_CLOCK_SKEW_SECONDS = "services.blocklist.clock_skew_seconds";

// Telemetry update source identifier.
const TELEMETRY_HISTOGRAM_KEY = "settings-changes-monitoring";


XPCOMUtils.defineLazyGetter(this, "gBlocklistClients", function() {
  const BlocklistClients = Cu.import("resource://services-common/blocklist-clients.js", {});
  return {
    [BlocklistClients.OneCRLBlocklistClient.collectionName]: BlocklistClients.OneCRLBlocklistClient,
    [BlocklistClients.AddonBlocklistClient.collectionName]: BlocklistClients.AddonBlocklistClient,
    [BlocklistClients.GfxBlocklistClient.collectionName]: BlocklistClients.GfxBlocklistClient,
    [BlocklistClients.PluginBlocklistClient.collectionName]: BlocklistClients.PluginBlocklistClient,
    [BlocklistClients.PinningPreloadClient.collectionName]: BlocklistClients.PinningPreloadClient,
  };
});

// Add a blocklist client for testing purposes. Do not use for any other purpose
this.addTestBlocklistClient = (name, client) => { gBlocklistClients[name] = client; }


async function pollChanges(url, lastEtag) {
  //
  // Fetch a versionInfo object from the server that looks like:
  // {"data":[
  //   {
  //     "host":"kinto-ota.dev.mozaws.net",
  //     "last_modified":1450717104423,
  //     "bucket":"blocklists",
  //     "collection":"certificates"
  //    }]}

  // Use ETag to obtain a `304 Not modified` when no change occurred.
  const headers = {};
  if (lastEtag) {
    headers["If-None-Match"] = lastEtag;
  }
  const response = await fetch(url, {headers});

  let versionInfo = [];
  // If no changes since last time, go on with empty list of changes.
  if (response.status != 304) {
    let payload;
    try {
      payload = await response.json();
    } catch (e) {}
    if (!payload.hasOwnProperty("data")) {
      // If the server is failing, the JSON response might not contain the
      // expected data (e.g. error response - Bug 1259145)
      throw new Error(`Server error response ${JSON.stringify(payload)}`);
    }
    versionInfo = payload.data;
  }
  // The server should always return ETag. But we've had situations where the CDN
  // was interfering.
  const currentEtag = response.headers.has("ETag") ? response.headers.get("ETag") : undefined;
  const serverTimeMillis = Date.parse(response.headers.get("Date"));

  // Check if the server asked the clients to back off.
  let backoffSeconds;
  if (response.headers.has("Backoff")) {
    const value = parseInt(response.headers.get("Backoff"), 10);
    if (!isNaN(value)) {
      backoffSeconds = value;
    }
  }

  return {versionInfo, currentEtag, serverTimeMillis, backoffSeconds};
}


// This is called by the ping mechanism.
// returns a promise that rejects if something goes wrong
this.checkVersions = async function() {
  // Check if the server backoff time is elapsed.
  if (Services.prefs.prefHasUserValue(PREF_SETTINGS_SERVER_BACKOFF)) {
    const backoffReleaseTime = Services.prefs.getCharPref(PREF_SETTINGS_SERVER_BACKOFF);
    const remainingMilliseconds = parseInt(backoffReleaseTime, 10) - Date.now();
    if (remainingMilliseconds > 0) {
      // Backoff time has not elapsed yet.
      UptakeTelemetry.report(TELEMETRY_HISTOGRAM_KEY,
                             UptakeTelemetry.STATUS.BACKOFF);
      throw new Error(`Server is asking clients to back off; retry in ${Math.ceil(remainingMilliseconds / 1000)}s.`);
    } else {
      Services.prefs.clearUserPref(PREF_SETTINGS_SERVER_BACKOFF);
    }
  }

  // Right now, we only use the collection name and the last modified info
  const kintoBase = Services.prefs.getCharPref(PREF_SETTINGS_SERVER);
  const changesEndpoint = kintoBase + Services.prefs.getCharPref(PREF_BLOCKLIST_CHANGES_PATH);

  let lastEtag;
  if (Services.prefs.prefHasUserValue(PREF_BLOCKLIST_LAST_ETAG)) {
    lastEtag = Services.prefs.getCharPref(PREF_BLOCKLIST_LAST_ETAG);
  }

  let pollResult;
  try {
    pollResult = await pollChanges(changesEndpoint, lastEtag);
  } catch (e) {
    // Report polling error to Uptake Telemetry.
    let report;
    if (/Server/.test(e.message)) {
      report = UptakeTelemetry.STATUS.SERVER_ERROR;
    } else if (/NetworkError/.test(e.message)) {
      report = UptakeTelemetry.STATUS.NETWORK_ERROR;
    } else {
      report = UptakeTelemetry.STATUS.UNKNOWN_ERROR;
    }
    UptakeTelemetry.report(TELEMETRY_HISTOGRAM_KEY, report);
    // No need to go further.
    throw new Error(`Polling for changes failed: ${e.message}.`);
  }

  const {serverTimeMillis, versionInfo, currentEtag, backoffSeconds} = pollResult;

  // Report polling success to Uptake Telemetry.
  const report = versionInfo.length == 0 ? UptakeTelemetry.STATUS.UP_TO_DATE
                                         : UptakeTelemetry.STATUS.SUCCESS;
  UptakeTelemetry.report(TELEMETRY_HISTOGRAM_KEY, report);

  // Check if the server asked the clients to back off (for next poll).
  if (backoffSeconds) {
    const backoffReleaseTime = Date.now() + backoffSeconds * 1000;
    Services.prefs.setCharPref(PREF_SETTINGS_SERVER_BACKOFF, backoffReleaseTime);
  }

  // Record new update time and the difference between local and server time.
  // Negative clockDifference means local time is behind server time
  // by the absolute of that value in seconds (positive means it's ahead)
  const clockDifference = Math.floor((Date.now() - serverTimeMillis) / 1000);
  Services.prefs.setIntPref(PREF_BLOCKLIST_CLOCK_SKEW_SECONDS, clockDifference);
  Services.prefs.setIntPref(PREF_BLOCKLIST_LAST_UPDATE, serverTimeMillis / 1000);

  // Iterate through the collections version info and initiate a synchronization
  // on the related blocklist client.
  let firstError;
  for (const collectionInfo of versionInfo) {
    const {bucket, collection, last_modified: lastModified} = collectionInfo;
    const client = gBlocklistClients[collection];
    if (client && client.bucketName == bucket) {
      try {
        await client.maybeSync(lastModified, serverTimeMillis);
      } catch (e) {
        if (!firstError) {
          firstError = e;
        }
      }
    }
  }
  if (firstError) {
    // cause the promise to reject by throwing the first observed error
    throw firstError;
  }

  // Save current Etag for next poll.
  if (currentEtag) {
    Services.prefs.setCharPref(PREF_BLOCKLIST_LAST_ETAG, currentEtag);
  }
};
