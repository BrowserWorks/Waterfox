/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/
*/
/* This testcase triggers two telemetry pings.
 *
 * Telemetry code keeps histograms of past telemetry pings. The first
 * ping populates these histograms. One of those histograms is then
 * checked in the second request.
 */

Cu.import("resource://gre/modules/ClientID.jsm");
Cu.import("resource://gre/modules/Services.jsm");
Cu.import("resource://gre/modules/XPCOMUtils.jsm", this);
Cu.import("resource://gre/modules/TelemetryController.jsm", this);
Cu.import("resource://gre/modules/TelemetryStorage.jsm", this);
Cu.import("resource://gre/modules/TelemetrySend.jsm", this);
Cu.import("resource://gre/modules/TelemetryArchive.jsm", this);
Cu.import("resource://gre/modules/Task.jsm", this);
Cu.import("resource://gre/modules/Promise.jsm", this);
Cu.import("resource://gre/modules/Preferences.jsm");

const PING_FORMAT_VERSION = 4;
const DELETION_PING_TYPE = "deletion";
const TEST_PING_TYPE = "test-ping-type";

const PLATFORM_VERSION = "1.9.2";
const APP_VERSION = "1";
const APP_NAME = "XPCShell";

const PREF_BRANCH = "toolkit.telemetry.";
const PREF_ENABLED = PREF_BRANCH + "enabled";
const PREF_ARCHIVE_ENABLED = PREF_BRANCH + "archive.enabled";
const PREF_FHR_UPLOAD_ENABLED = "datareporting.healthreport.uploadEnabled";
const PREF_UNIFIED = PREF_BRANCH + "unified";

var gClientID = null;

function sendPing(aSendClientId, aSendEnvironment) {
  if (PingServer.started) {
    TelemetrySend.setServer("http://localhost:" + PingServer.port);
  } else {
    TelemetrySend.setServer("http://doesnotexist");
  }

  let options = {
    addClientId: aSendClientId,
    addEnvironment: aSendEnvironment,
  };
  return TelemetryController.submitExternalPing(TEST_PING_TYPE, {}, options);
}

function checkPingFormat(aPing, aType, aHasClientId, aHasEnvironment) {
  const MANDATORY_PING_FIELDS = [
    "type", "id", "creationDate", "version", "application", "payload"
  ];

  const APPLICATION_TEST_DATA = {
    buildId: gAppInfo.appBuildID,
    name: APP_NAME,
    version: APP_VERSION,
    displayVersion: AppConstants.MOZ_APP_VERSION_DISPLAY,
    vendor: "Mozilla",
    platformVersion: PLATFORM_VERSION,
    xpcomAbi: "noarch-spidermonkey",
  };

  // Check that the ping contains all the mandatory fields.
  for (let f of MANDATORY_PING_FIELDS) {
    Assert.ok(f in aPing, f + " must be available.");
  }

  Assert.equal(aPing.type, aType, "The ping must have the correct type.");
  Assert.equal(aPing.version, PING_FORMAT_VERSION, "The ping must have the correct version.");

  // Test the application section.
  for (let f in APPLICATION_TEST_DATA) {
    Assert.equal(aPing.application[f], APPLICATION_TEST_DATA[f],
                 f + " must have the correct value.");
  }

  // We can't check the values for channel and architecture. Just make
  // sure they are in.
  Assert.ok("architecture" in aPing.application,
            "The application section must have an architecture field.");
  Assert.ok("channel" in aPing.application,
            "The application section must have a channel field.");

  // Check the clientId and environment fields, as needed.
  Assert.equal("clientId" in aPing, aHasClientId);
  Assert.equal("environment" in aPing, aHasEnvironment);
}

add_task(function* test_setup() {
  // Addon manager needs a profile directory
  do_get_profile();
  loadAddonManager("xpcshell@tests.mozilla.org", "XPCShell", "1", "1.9.2");
  // Make sure we don't generate unexpected pings due to pref changes.
  yield setEmptyPrefWatchlist();

  Services.prefs.setBoolPref(PREF_ENABLED, true);
  Services.prefs.setBoolPref(PREF_FHR_UPLOAD_ENABLED, true);

  yield new Promise(resolve =>
    Telemetry.asyncFetchTelemetryData(wrapWithExceptionHandler(resolve)));
});

add_task(function* asyncSetup() {
  yield TelemetryController.testSetup();
});

// Ensure that not overwriting an existing file fails silently
add_task(function* test_overwritePing() {
  let ping = {id: "foo"};
  yield TelemetryStorage.savePing(ping, true);
  yield TelemetryStorage.savePing(ping, false);
  yield TelemetryStorage.cleanupPingFile(ping);
});

// Checks that a sent ping is correctly received by a dummy http server.
add_task(function* test_simplePing() {
  PingServer.start();
  // Update the Telemetry Server preference with the address of the local server.
  // Otherwise we might end up sending stuff to a non-existing server after
  // |TelemetryController.testReset| is called.
  Preferences.set(TelemetryController.Constants.PREF_SERVER, "http://localhost:" + PingServer.port);

  yield sendPing(false, false);
  let request = yield PingServer.promiseNextRequest();

  // Check that we have a version query parameter in the URL.
  Assert.notEqual(request.queryString, "");

  // Make sure the version in the query string matches the new ping format version.
  let params = request.queryString.split("&");
  Assert.ok(params.find(p => p == ("v=" + PING_FORMAT_VERSION)));

  let ping = decodeRequestPayload(request);
  checkPingFormat(ping, TEST_PING_TYPE, false, false);
});

add_task(function* test_disableDataUpload() {
  const isUnified = Preferences.get(PREF_UNIFIED, false);
  if (!isUnified) {
    // Skipping the test if unified telemetry is off, as no deletion ping will
    // be generated.
    return;
  }

  // Disable FHR upload: this should trigger a deletion ping.
  Preferences.set(PREF_FHR_UPLOAD_ENABLED, false);

  let ping = yield PingServer.promiseNextPing();
  checkPingFormat(ping, DELETION_PING_TYPE, true, false);
  // Wait on ping activity to settle.
  yield TelemetrySend.testWaitOnOutgoingPings();

  // Restore FHR Upload.
  Preferences.set(PREF_FHR_UPLOAD_ENABLED, true);

  // Simulate a failure in sending the deletion ping by disabling the HTTP server.
  yield PingServer.stop();

  // Try to send a ping. It will be saved as pending  and get deleted when disabling upload.
  TelemetryController.submitExternalPing(TEST_PING_TYPE, {});

  // Disable FHR upload to send a deletion ping again.
  Preferences.set(PREF_FHR_UPLOAD_ENABLED, false);

  // Wait on sending activity to settle, as |TelemetryController.testReset()| doesn't do that.
  yield TelemetrySend.testWaitOnOutgoingPings();
  // Wait for the pending pings to be deleted. Resetting TelemetryController doesn't
  // trigger the shutdown, so we need to call it ourselves.
  yield TelemetryStorage.shutdown();
  // Simulate a restart, and spin the send task.
  yield TelemetryController.testReset();

  // Disabling Telemetry upload must clear out all the pending pings.
  let pendingPings = yield TelemetryStorage.loadPendingPingList();
  Assert.equal(pendingPings.length, 1,
               "All the pending pings but the deletion ping should have been deleted");

  // Enable the ping server again.
  PingServer.start();
  // We set the new server using the pref, otherwise it would get reset with
  // |TelemetryController.testReset|.
  Preferences.set(TelemetryController.Constants.PREF_SERVER, "http://localhost:" + PingServer.port);

  // Stop the sending task and then start it again.
  yield TelemetrySend.shutdown();
  // Reset the controller to spin the ping sending task.
  yield TelemetryController.testReset();
  ping = yield PingServer.promiseNextPing();
  checkPingFormat(ping, DELETION_PING_TYPE, true, false);

  // Wait on ping activity to settle before moving on to the next test. If we were
  // to shut down telemetry, even though the PingServer caught the expected pings,
  // TelemetrySend could still be processing them (clearing pings would happen in
  // a couple of ticks). Shutting down would cancel the request and save them as
  // pending pings.
  yield TelemetrySend.testWaitOnOutgoingPings();
  // Restore FHR Upload.
  Preferences.set(PREF_FHR_UPLOAD_ENABLED, true);
});

add_task(function* test_pingHasClientId() {
  const PREF_CACHED_CLIENTID = "toolkit.telemetry.cachedClientID";

  // Make sure we have no cached client ID for this test: we'll try to send
  // a ping with it while Telemetry is being initialized.
  Preferences.reset(PREF_CACHED_CLIENTID);
  yield TelemetryController.testShutdown();
  yield ClientID._reset();
  yield TelemetryStorage.testClearPendingPings();
  // And also clear the counter histogram since we're here.
  let h = Telemetry.getHistogramById("TELEMETRY_PING_SUBMISSION_WAITING_CLIENTID");
  h.clear();

  // Init telemetry and try to send a ping with a client ID.
  let promisePingSetup = TelemetryController.testReset();
  yield sendPing(true, false);
  Assert.equal(h.snapshot().sum, 1,
               "We must have a ping waiting for the clientId early during startup.");
  // Wait until we are fully initialized. Pings will be assembled but won't get
  // sent before then.
  yield promisePingSetup;

  let ping = yield PingServer.promiseNextPing();
  // Fetch the client ID after initializing and fetching the the ping, so we
  // don't unintentionally trigger its loading. We'll still need the client ID
  // to see if the ping looks sane.
  gClientID = yield ClientID.getClientID();

  checkPingFormat(ping, TEST_PING_TYPE, true, false);
  Assert.equal(ping.clientId, gClientID, "The correct clientId must be reported.");

  // Shutdown Telemetry so we can safely restart it.
  yield TelemetryController.testShutdown();
  yield TelemetryStorage.testClearPendingPings();

  // We should have cached the client ID now. Lets confirm that by checking it before
  // the async ping setup is finished.
  h.clear();
  promisePingSetup = TelemetryController.testReset();
  yield sendPing(true, false);
  yield promisePingSetup;

  // Check that we received the cached client id.
  Assert.equal(h.snapshot().sum, 0, "We must have used the cached clientId.");
  ping = yield PingServer.promiseNextPing();
  checkPingFormat(ping, TEST_PING_TYPE, true, false);
  Assert.equal(ping.clientId, gClientID,
               "Telemetry should report the correct cached clientId.");

  // Check that sending a ping without relying on the cache, after the
  // initialization, still works.
  Preferences.reset(PREF_CACHED_CLIENTID);
  yield TelemetryController.testShutdown();
  yield TelemetryStorage.testClearPendingPings();
  yield TelemetryController.testReset();
  yield sendPing(true, false);
  ping = yield PingServer.promiseNextPing();
  checkPingFormat(ping, TEST_PING_TYPE, true, false);
  Assert.equal(ping.clientId, gClientID, "The correct clientId must be reported.");
  Assert.equal(h.snapshot().sum, 0, "No ping should have been waiting for a clientId.");
});

add_task(function* test_pingHasEnvironment() {
  // Send a ping with the environment data.
  yield sendPing(false, true);
  let ping = yield PingServer.promiseNextPing();
  checkPingFormat(ping, TEST_PING_TYPE, false, true);

  // Test a field in the environment build section.
  Assert.equal(ping.application.buildId, ping.environment.build.buildId);
});

add_task(function* test_pingHasEnvironmentAndClientId() {
  // Send a ping with the environment data and client id.
  yield sendPing(true, true);
  let ping = yield PingServer.promiseNextPing();
  checkPingFormat(ping, TEST_PING_TYPE, true, true);

  // Test a field in the environment build section.
  Assert.equal(ping.application.buildId, ping.environment.build.buildId);
  // Test that we have the correct clientId.
  Assert.equal(ping.clientId, gClientID, "The correct clientId must be reported.");
});

add_task(function* test_archivePings() {
  let now = new Date(2009, 10, 18, 12, 0, 0);
  fakeNow(now);

  // Disable ping upload so that pings don't get sent.
  // With unified telemetry the FHR upload pref controls this,
  // with non-unified telemetry the Telemetry enabled pref.
  const isUnified = Preferences.get(PREF_UNIFIED, false);
  const uploadPref = isUnified ? PREF_FHR_UPLOAD_ENABLED : PREF_ENABLED;
  Preferences.set(uploadPref, false);

  // If we're using unified telemetry, disabling ping upload will generate a "deletion"
  // ping. Catch it.
  if (isUnified) {
    let ping = yield PingServer.promiseNextPing();
    checkPingFormat(ping, DELETION_PING_TYPE, true, false);
  }

  // Register a new Ping Handler that asserts if a ping is received, then send a ping.
  PingServer.registerPingHandler(() => Assert.ok(false, "Telemetry must not send pings if not allowed to."));
  let pingId = yield sendPing(true, true);

  // Check that the ping was archived, even with upload disabled.
  let ping = yield TelemetryArchive.promiseArchivedPingById(pingId);
  Assert.equal(ping.id, pingId, "TelemetryController should still archive pings.");

  // Check that pings don't get archived if not allowed to.
  now = new Date(2010, 10, 18, 12, 0, 0);
  fakeNow(now);
  Preferences.set(PREF_ARCHIVE_ENABLED, false);
  pingId = yield sendPing(true, true);
  let promise = TelemetryArchive.promiseArchivedPingById(pingId);
  Assert.ok((yield promiseRejects(promise)),
    "TelemetryController should not archive pings if the archive pref is disabled.");

  // Enable archiving and the upload so that pings get sent and archived again.
  Preferences.set(uploadPref, true);
  Preferences.set(PREF_ARCHIVE_ENABLED, true);

  now = new Date(2014, 6, 18, 22, 0, 0);
  fakeNow(now);
  // Restore the non asserting ping handler.
  PingServer.resetPingHandler();
  pingId = yield sendPing(true, true);

  // Check that we archive pings when successfully sending them.
  yield PingServer.promiseNextPing();
  ping = yield TelemetryArchive.promiseArchivedPingById(pingId);
  Assert.equal(ping.id, pingId,
    "TelemetryController should still archive pings if ping upload is enabled.");
});

// Test that we fuzz the submission time around midnight properly
// to avoid overloading the telemetry servers.
add_task(function* test_midnightPingSendFuzzing() {
  const fuzzingDelay = 60 * 60 * 1000;
  fakeMidnightPingFuzzingDelay(fuzzingDelay);
  let now = new Date(2030, 5, 1, 11, 0, 0);
  fakeNow(now);

  let waitForTimer = () => new Promise(resolve => {
    fakePingSendTimer((callback, timeout) => {
      resolve([callback, timeout]);
    }, () => {});
  });

  PingServer.clearRequests();
  yield TelemetryController.testReset();

  // A ping after midnight within the fuzzing delay should not get sent.
  now = new Date(2030, 5, 2, 0, 40, 0);
  fakeNow(now);
  PingServer.registerPingHandler((req, res) => {
    Assert.ok(false, "No ping should be received yet.");
  });
  let timerPromise = waitForTimer();
  yield sendPing(true, true);
  let [timerCallback, timerTimeout] = yield timerPromise;
  Assert.ok(!!timerCallback);
  Assert.deepEqual(futureDate(now, timerTimeout), new Date(2030, 5, 2, 1, 0, 0));

  // A ping just before the end of the fuzzing delay should not get sent.
  now = new Date(2030, 5, 2, 0, 59, 59);
  fakeNow(now);
  timerPromise = waitForTimer();
  yield sendPing(true, true);
  [timerCallback, timerTimeout] = yield timerPromise;
  Assert.deepEqual(timerTimeout, 1 * 1000);

  // Restore the previous ping handler.
  PingServer.resetPingHandler();

  // Setting the clock to after the fuzzing delay, we should trigger the two ping sends
  // with the timer callback.
  now = futureDate(now, timerTimeout);
  fakeNow(now);
  yield timerCallback();
  const pings = yield PingServer.promiseNextPings(2);
  for (let ping of pings) {
    checkPingFormat(ping, TEST_PING_TYPE, true, true);
  }
  yield TelemetrySend.testWaitOnOutgoingPings();

  // Moving the clock further we should still send pings immediately.
  now = futureDate(now, 5 * 60 * 1000);
  yield sendPing(true, true);
  let ping = yield PingServer.promiseNextPing();
  checkPingFormat(ping, TEST_PING_TYPE, true, true);
  yield TelemetrySend.testWaitOnOutgoingPings();

  // Check that pings shortly before midnight are immediately sent.
  now = fakeNow(2030, 5, 3, 23, 59, 0);
  yield sendPing(true, true);
  ping = yield PingServer.promiseNextPing();
  checkPingFormat(ping, TEST_PING_TYPE, true, true);
  yield TelemetrySend.testWaitOnOutgoingPings();

  // Clean-up.
  fakeMidnightPingFuzzingDelay(0);
  fakePingSendTimer(() => {}, () => {});
});

add_task(function* test_changePingAfterSubmission() {
  // Submit a ping with a custom payload.
  let payload = { canary: "test" };
  let pingPromise = TelemetryController.submitExternalPing(TEST_PING_TYPE, payload, options);

  // Change the payload with a predefined value.
  payload.canary = "changed";

  // Wait for the ping to be archived.
  const pingId = yield pingPromise;

  // Make sure our changes didn't affect the submitted payload.
  let archivedCopy = yield TelemetryArchive.promiseArchivedPingById(pingId);
  Assert.equal(archivedCopy.payload.canary, "test",
               "The payload must not be changed after being submitted.");
});

add_task(function* test_telemetryEnabledUnexpectedValue() {
  // Remove the default value for toolkit.telemetry.enabled from the default prefs.
  // Otherwise, we wouldn't be able to set the pref to a string.
  let defaultPrefBranch = Services.prefs.getDefaultBranch(null);
  defaultPrefBranch.deleteBranch(PREF_ENABLED);

  // Set the preferences controlling the Telemetry status to a string.
  Preferences.set(PREF_ENABLED, "false");
  // Check that Telemetry is not enabled.
  yield TelemetryController.testReset();
  Assert.equal(Telemetry.canRecordExtended, false,
               "Invalid values must not enable Telemetry recording.");

  // Delete the pref again.
  defaultPrefBranch.deleteBranch(PREF_ENABLED);

  // Make sure that flipping it to true works.
  Preferences.set(PREF_ENABLED, true);
  yield TelemetryController.testReset();
  Assert.equal(Telemetry.canRecordExtended, true,
               "True must enable Telemetry recording.");

  // Also check that the false works as well.
  Preferences.set(PREF_ENABLED, false);
  yield TelemetryController.testReset();
  Assert.equal(Telemetry.canRecordExtended, false,
               "False must disable Telemetry recording.");
});

add_task(function* test_telemetryCleanFHRDatabase() {
  const FHR_DBNAME_PREF = "datareporting.healthreport.dbName";
  const CUSTOM_DB_NAME = "unlikely.to.be.used.sqlite";
  const DEFAULT_DB_NAME = "healthreport.sqlite";

  // Check that we're able to remove a FHR DB with a custom name.
  const CUSTOM_DB_PATHS = [
    OS.Path.join(OS.Constants.Path.profileDir, CUSTOM_DB_NAME),
    OS.Path.join(OS.Constants.Path.profileDir, CUSTOM_DB_NAME + "-wal"),
    OS.Path.join(OS.Constants.Path.profileDir, CUSTOM_DB_NAME + "-shm"),
  ];
  Preferences.set(FHR_DBNAME_PREF, CUSTOM_DB_NAME);

  // Write fake DB files to the profile directory.
  for (let dbFilePath of CUSTOM_DB_PATHS) {
    yield OS.File.writeAtomic(dbFilePath, "some data");
  }

  // Trigger the cleanup and check that the files were removed.
  yield TelemetryStorage.removeFHRDatabase();
  for (let dbFilePath of CUSTOM_DB_PATHS) {
    Assert.ok(!(yield OS.File.exists(dbFilePath)), "The DB must not be on the disk anymore: " + dbFilePath);
  }

  // We should not break anything if there's no DB file.
  yield TelemetryStorage.removeFHRDatabase();

  // Check that we're able to remove a FHR DB with the default name.
  Preferences.reset(FHR_DBNAME_PREF);

  const DEFAULT_DB_PATHS = [
    OS.Path.join(OS.Constants.Path.profileDir, DEFAULT_DB_NAME),
    OS.Path.join(OS.Constants.Path.profileDir, DEFAULT_DB_NAME + "-wal"),
    OS.Path.join(OS.Constants.Path.profileDir, DEFAULT_DB_NAME + "-shm"),
  ];

  // Write fake DB files to the profile directory.
  for (let dbFilePath of DEFAULT_DB_PATHS) {
    yield OS.File.writeAtomic(dbFilePath, "some data");
  }

  // Trigger the cleanup and check that the files were removed.
  yield TelemetryStorage.removeFHRDatabase();
  for (let dbFilePath of DEFAULT_DB_PATHS) {
    Assert.ok(!(yield OS.File.exists(dbFilePath)), "The DB must not be on the disk anymore: " + dbFilePath);
  }
});

add_task(function* stopServer() {
  yield PingServer.stop();
});
