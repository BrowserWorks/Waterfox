/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

// Tests the bookmark repair requestor and responder end-to-end (ie, without
// many mocks)
const { BookmarkRepairRequestor } = ChromeUtils.import(
  "resource://services-sync/bookmark_repair.js"
);
const { Service } = ChromeUtils.import("resource://services-sync/service.js");
const { ClientEngine } = ChromeUtils.import(
  "resource://services-sync/engines/clients.js"
);
const { BookmarksEngine } = ChromeUtils.import(
  "resource://services-sync/engines/bookmarks.js"
);

const BOOKMARK_REPAIR_STATE_PREFS = [
  "client.GUID",
  "doctor.lastRepairAdvance",
  ...Object.values(BookmarkRepairRequestor.PREF).map(
    name => `repairs.bookmarks.${name}`
  ),
];

let clientsEngine;
let bookmarksEngine;
var recordedEvents = [];

add_task(async function setup() {
  await Service.engineManager.unregister("bookmarks");
  await Service.engineManager.register(BookmarksEngine);

  clientsEngine = Service.clientsEngine;
  clientsEngine.ignoreLastModifiedOnProcessCommands = true;
  bookmarksEngine = Service.engineManager.get("bookmarks");

  await generateNewKeys(Service.collectionKeys);

  Service.recordTelemetryEvent = (object, method, value, extra = undefined) => {
    recordedEvents.push({ object, method, value, extra });
  };
});

function checkRecordedEvents(expected, message) {
  deepEqual(recordedEvents, expected, message);
  // and clear the list so future checks are easier to write.
  recordedEvents = [];
}

// Backs up and resets all preferences to their default values. Returns a
// function that restores the preferences when called.
function backupPrefs(names) {
  let state = new Map();
  for (let name of names) {
    state.set(name, Svc.Prefs.get(name));
    Svc.Prefs.reset(name);
  }
  return () => {
    for (let [name, value] of state) {
      Svc.Prefs.set(name, value);
    }
  };
}

async function promiseValidationDone(expected) {
  // wait for a validation to complete.
  let obs = promiseOneObserver("weave:engine:validate:finish");
  let { subject: validationResult } = await obs;
  // check the results - anything non-zero is checked against |expected|
  let summary = validationResult.problems;
  let actual = summary.filter(({ name, count }) => count);
  actual.sort((a, b) => String(a.name).localeCompare(b.name));
  expected.sort((a, b) => String(a.name).localeCompare(b.name));
  deepEqual(actual, expected);
}

async function cleanup(server) {
  await bookmarksEngine._store.wipe();
  await bookmarksEngine.resetClient();
  await clientsEngine._store.wipe();
  Svc.Prefs.resetBranch("");
  Service.recordManager.clearCache();
  await promiseStopServer(server);
}

add_task(async function test_bookmark_repair_integration() {
  enableValidationPrefs();

  _("Ensure that a validation error triggers a repair request.");

  let server = await serverForFoo(bookmarksEngine);
  await SyncTestingInfrastructure(server);

  let user = server.user("foo");

  let initialID = Service.clientsEngine.localID;
  let remoteID = Utils.makeGUID();
  try {
    _("Syncing to initialize crypto etc.");
    await Service.sync();

    _("Create remote client record");
    server.insertWBO(
      "foo",
      "clients",
      new ServerWBO(
        remoteID,
        encryptPayload({
          id: remoteID,
          name: "Remote client",
          type: "desktop",
          commands: [],
          version: "54",
          protocols: ["1.5"],
        }),
        Date.now() / 1000
      )
    );

    _("Create bookmark and folder");
    let folderInfo = await PlacesUtils.bookmarks.insert({
      parentGuid: PlacesUtils.bookmarks.toolbarGuid,
      type: PlacesUtils.bookmarks.TYPE_FOLDER,
      title: "Folder 1",
    });
    let bookmarkInfo = await PlacesUtils.bookmarks.insert({
      parentGuid: folderInfo.guid,
      url: "http://getfirefox.com/",
      title: "Get Firefox!",
    });

    _(`Upload ${folderInfo.guid} and ${bookmarkInfo.guid} to server`);
    let validationPromise = promiseValidationDone([]);
    await Service.sync();
    equal(
      clientsEngine.stats.numClients,
      2,
      "Clients collection should have 2 records"
    );
    await validationPromise;
    checkRecordedEvents([], "Should not start repair after first sync");

    _("Back up last sync timestamps for remote client");
    let lastSync = await PlacesSyncUtils.bookmarks.getLastSync();

    _(`Delete ${bookmarkInfo.guid} locally and on server`);
    // Now we will reach into the server and hard-delete the bookmark
    user.collection("bookmarks").remove(bookmarkInfo.guid);
    // And delete the bookmark, but cheat by telling places that Sync did
    // it, so we don't end up with a tombstone.
    await PlacesUtils.bookmarks.remove(bookmarkInfo.guid, {
      source: PlacesUtils.bookmarks.SOURCE_SYNC,
    });
    deepEqual(
      await PlacesSyncUtils.bookmarks.pullChanges(),
      {},
      `Should not upload tombstone for ${bookmarkInfo.guid}`
    );

    // sync again - we should have a few problems...
    _("Sync again to trigger repair");
    validationPromise = promiseValidationDone([
      { name: "missingChildren", count: 1 },
      { name: "sdiff:childGUIDs", count: 1 },
      { name: "structuralDifferences", count: 1 },
    ]);
    await Service.sync();
    await validationPromise;
    let flowID = Svc.Prefs.get("repairs.bookmarks.flowID");
    checkRecordedEvents(
      [
        {
          object: "repair",
          method: "started",
          value: undefined,
          extra: {
            flowID,
            numIDs: "2",
          },
        },
        {
          object: "sendcommand",
          method: "repairRequest",
          value: undefined,
          extra: {
            flowID,
            deviceID: Service.identity.hashedDeviceID(remoteID),
          },
        },
        {
          object: "repair",
          method: "request",
          value: "upload",
          extra: {
            deviceID: Service.identity.hashedDeviceID(remoteID),
            flowID,
            numIDs: "2",
          },
        },
      ],
      "Should record telemetry events for repair request"
    );

    // We should have started a repair with our second client.
    equal(
      (await clientsEngine.getClientCommands(remoteID)).length,
      1,
      "Should queue repair request for remote client after repair"
    );
    _("Sync to send outgoing repair request");
    await Service.sync();
    equal(
      (await clientsEngine.getClientCommands(remoteID)).length,
      0,
      "Should send repair request to remote client after next sync"
    );
    checkRecordedEvents(
      [],
      "Should not record repair telemetry after sending repair request"
    );

    _("Back up repair state to restore later");
    let restoreInitialRepairState = backupPrefs(BOOKMARK_REPAIR_STATE_PREFS);
    let initialLastSync = await PlacesSyncUtils.bookmarks.getLastSync();

    // so now let's take over the role of that other client!
    _("Create new clients engine pretending to be remote client");
    let remoteClientsEngine = (Service.clientsEngine = new ClientEngine(
      Service
    ));
    remoteClientsEngine.ignoreLastModifiedOnProcessCommands = true;
    await remoteClientsEngine.initialize();
    remoteClientsEngine.localID = remoteID;

    _("Restore missing bookmark");
    // Pretend Sync wrote the bookmark, so that we upload it as part of the
    // repair instead of the sync.
    bookmarkInfo.source = PlacesUtils.bookmarks.SOURCE_SYNC;
    await PlacesUtils.bookmarks.insert(bookmarkInfo);
    await PlacesSyncUtils.bookmarks.setLastSync(lastSync);

    _("Sync as remote client");
    await Service.sync();
    checkRecordedEvents(
      [
        {
          object: "processcommand",
          method: "repairRequest",
          value: undefined,
          extra: {
            flowID,
          },
        },
        {
          object: "repairResponse",
          method: "uploading",
          value: undefined,
          extra: {
            flowID,
            numIDs: "2",
          },
        },
        {
          object: "sendcommand",
          method: "repairResponse",
          value: undefined,
          extra: {
            flowID,
            deviceID: Service.identity.hashedDeviceID(initialID),
          },
        },
        {
          object: "repairResponse",
          method: "finished",
          value: undefined,
          extra: {
            flowID,
            numIDs: "2",
          },
        },
      ],
      "Should record telemetry events for repair response"
    );

    // We should queue the repair response for the initial client.
    equal(
      (await remoteClientsEngine.getClientCommands(initialID)).length,
      1,
      "Should queue repair response for initial client after repair"
    );
    ok(
      user.collection("bookmarks").wbo(bookmarkInfo.guid),
      "Should upload missing bookmark"
    );

    _("Sync to upload bookmark and send outgoing repair response");
    await Service.sync();
    equal(
      (await remoteClientsEngine.getClientCommands(initialID)).length,
      0,
      "Should send repair response to initial client after next sync"
    );
    checkRecordedEvents(
      [],
      "Should not record repair telemetry after sending repair response"
    );
    ok(
      !Services.prefs.prefHasUserValue("services.sync.repairs.bookmarks.state"),
      "Remote client should not be repairing"
    );

    _("Pretend to be initial client again");
    Service.clientsEngine = clientsEngine;

    _("Restore incomplete Places database and prefs");
    await PlacesUtils.bookmarks.remove(bookmarkInfo.guid, {
      source: PlacesUtils.bookmarks.SOURCE_SYNC,
    });
    restoreInitialRepairState();
    await PlacesSyncUtils.bookmarks.setLastSync(initialLastSync);
    ok(
      Services.prefs.prefHasUserValue("services.sync.repairs.bookmarks.state"),
      "Initial client should still be repairing"
    );

    _("Sync as initial client");
    let revalidationPromise = promiseValidationDone([]);
    await Service.sync();
    let restoredBookmarkInfo = await PlacesUtils.bookmarks.fetch(
      bookmarkInfo.guid
    );
    ok(
      restoredBookmarkInfo,
      `Missing bookmark ${bookmarkInfo.guid} should be downloaded to initial client`
    );
    checkRecordedEvents([
      {
        object: "processcommand",
        method: "repairResponse",
        value: undefined,
        extra: {
          flowID,
        },
      },
      {
        object: "repair",
        method: "response",
        value: "upload",
        extra: {
          flowID,
          deviceID: Service.identity.hashedDeviceID(remoteID),
          numIDs: "2",
        },
      },
      {
        object: "repair",
        method: "finished",
        value: undefined,
        extra: {
          flowID,
          numIDs: "0",
        },
      },
    ]);
    await revalidationPromise;
    ok(
      !Services.prefs.prefHasUserValue("services.sync.repairs.bookmarks.state"),
      "Should clear repair pref after successfully completing repair"
    );
  } finally {
    await cleanup(server);
    clientsEngine = Service.clientsEngine = new ClientEngine(Service);
    clientsEngine.ignoreLastModifiedOnProcessCommands = true;
    await clientsEngine.initialize();
  }
});

add_task(async function test_repair_client_missing() {
  enableValidationPrefs();

  _(
    "Ensure that a record missing from the client only will get re-downloaded from the server"
  );

  let server = await serverForFoo(bookmarksEngine);
  await SyncTestingInfrastructure(server);

  let remoteID = Utils.makeGUID();
  try {
    _("Syncing to initialize crypto etc.");
    await Service.sync();

    _("Create remote client record");
    server.insertWBO(
      "foo",
      "clients",
      new ServerWBO(
        remoteID,
        encryptPayload({
          id: remoteID,
          name: "Remote client",
          type: "desktop",
          commands: [],
          version: "54",
          protocols: ["1.5"],
        }),
        Date.now() / 1000
      )
    );

    let bookmarkInfo = await PlacesUtils.bookmarks.insert({
      parentGuid: PlacesUtils.bookmarks.toolbarGuid,
      url: "http://getfirefox.com/",
      title: "Get Firefox!",
    });

    let validationPromise = promiseValidationDone([]);
    _("Syncing.");
    await Service.sync();
    // should have 2 clients
    equal(clientsEngine.stats.numClients, 2);
    await validationPromise;

    // Delete the bookmark localy, but cheat by telling places that Sync did
    // it, so Sync still thinks we have it.
    await PlacesUtils.bookmarks.remove(bookmarkInfo.guid, {
      source: PlacesUtils.bookmarks.SOURCE_SYNC,
    });

    // Ensure we won't upload a tombstone for the removed bookmark.
    Assert.deepEqual(await PlacesSyncUtils.bookmarks.pullChanges(), {});
    // Ensure the bookmark no longer exists in Places.
    Assert.equal(null, await PlacesUtils.bookmarks.fetch(bookmarkInfo.guid));

    // sync again - we should have a few problems...
    _("Syncing again.");
    validationPromise = promiseValidationDone([
      { name: "clientMissing", count: 1 },
      { name: "sdiff:childGUIDs", count: 1 },
      { name: "structuralDifferences", count: 1 },
    ]);
    await Service.sync();
    await validationPromise;

    // We shouldn't have started a repair with our second client.
    equal((await clientsEngine.getClientCommands(remoteID)).length, 0);

    // Trigger a sync (will request the missing item)
    await Service.sync();

    // And we got our bookmark back
    Assert.ok(await PlacesUtils.bookmarks.fetch(bookmarkInfo.guid));
  } finally {
    await cleanup(server);
  }
});

add_task(async function test_repair_server_missing() {
  enableValidationPrefs();

  _(
    "Ensure that a record missing from the server only will get re-upload from the client"
  );

  let server = await serverForFoo(bookmarksEngine);
  await SyncTestingInfrastructure(server);

  let user = server.user("foo");

  let remoteID = Utils.makeGUID();
  try {
    _("Syncing to initialize crypto etc.");
    await Service.sync();

    _("Create remote client record");
    server.insertWBO(
      "foo",
      "clients",
      new ServerWBO(
        remoteID,
        encryptPayload({
          id: remoteID,
          name: "Remote client",
          type: "desktop",
          commands: [],
          version: "54",
          protocols: ["1.5"],
        }),
        Date.now() / 1000
      )
    );

    let bookmarkInfo = await PlacesUtils.bookmarks.insert({
      parentGuid: PlacesUtils.bookmarks.toolbarGuid,
      url: "http://getfirefox.com/",
      title: "Get Firefox!",
    });

    let validationPromise = promiseValidationDone([]);
    _("Syncing.");
    await Service.sync();
    // should have 2 clients
    equal(clientsEngine.stats.numClients, 2);
    await validationPromise;

    // Now we will reach into the server and hard-delete the bookmark
    user
      .collection("bookmarks")
      .wbo(bookmarkInfo.guid)
      .delete();

    // sync again - we should have a few problems...
    _("Syncing again.");
    validationPromise = promiseValidationDone([
      { name: "serverMissing", count: 1 },
      { name: "missingChildren", count: 1 },
    ]);
    await Service.sync();
    await validationPromise;

    // We shouldn't have started a repair with our second client.
    equal((await clientsEngine.getClientCommands(remoteID)).length, 0);

    // Trigger a sync (will upload the missing item)
    await Service.sync();

    // And the server got our bookmark back
    Assert.ok(user.collection("bookmarks").wbo(bookmarkInfo.guid));
  } finally {
    await cleanup(server);
  }
});

add_task(async function test_repair_server_deleted() {
  enableValidationPrefs();

  _(
    "Ensure that a record marked as deleted on the server but present on the client will get deleted on the client"
  );

  let server = await serverForFoo(bookmarksEngine);
  await SyncTestingInfrastructure(server);

  let remoteID = Utils.makeGUID();
  try {
    _("Syncing to initialize crypto etc.");
    await Service.sync();

    _("Create remote client record");
    server.insertWBO(
      "foo",
      "clients",
      new ServerWBO(
        remoteID,
        encryptPayload({
          id: remoteID,
          name: "Remote client",
          type: "desktop",
          commands: [],
          version: "54",
          protocols: ["1.5"],
        }),
        Date.now() / 1000
      )
    );

    let bookmarkInfo = await PlacesUtils.bookmarks.insert({
      parentGuid: PlacesUtils.bookmarks.toolbarGuid,
      url: "http://getfirefox.com/",
      title: "Get Firefox!",
    });

    let validationPromise = promiseValidationDone([]);
    _("Syncing.");
    await Service.sync();
    // should have 2 clients
    equal(clientsEngine.stats.numClients, 2);
    await validationPromise;

    // Now we will reach into the server and create a tombstone for that bookmark
    // but with a last-modified in the past - this way our sync isn't going to
    // pick up the record.
    _(`Adding server tombstone for ${bookmarkInfo.guid}`);
    server.insertWBO(
      "foo",
      "bookmarks",
      new ServerWBO(
        bookmarkInfo.guid,
        encryptPayload({
          id: bookmarkInfo.guid,
          deleted: true,
        }),
        (Date.now() - 60000) / 1000
      )
    );

    // sync again - we should have a few problems...
    _("Syncing again.");
    validationPromise = promiseValidationDone([
      { name: "serverDeleted", count: 1 },
      { name: "deletedChildren", count: 1 },
    ]);
    await Service.sync();
    await validationPromise;

    // We shouldn't have started a repair with our second client.
    equal((await clientsEngine.getClientCommands(remoteID)).length, 0);

    // Trigger a sync (will upload the missing item)
    await Service.sync();

    // And the client deleted our bookmark
    Assert.ok(!(await PlacesUtils.bookmarks.fetch(bookmarkInfo.guid)));
  } finally {
    await cleanup(server);
  }
});
