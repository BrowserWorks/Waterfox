/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

Cu.import("resource://gre/modules/PlacesUtils.jsm");
Cu.import("resource://services-common/async.js");
Cu.import("resource://gre/modules/Log.jsm");
Cu.import("resource://services-sync/engines.js");
Cu.import("resource://services-sync/engines/bookmarks.js");
Cu.import("resource://services-sync/service.js");
Cu.import("resource://services-sync/util.js");
Cu.import("resource://testing-common/services/sync/utils.js");
Cu.import("resource://services-sync/bookmark_validator.js");


initTestLogging("Trace");

const bms = PlacesUtils.bookmarks;

Service.engineManager.register(BookmarksEngine);

const engine = new BookmarksEngine(Service);
const store = engine._store;
store._log.level = Log.Level.Trace;
engine._log.level = Log.Level.Trace;

function promiseOneObserver(topic) {
  return new Promise((resolve, reject) => {
    let observer = function(subject, topic, data) {
      Services.obs.removeObserver(observer, topic);
      resolve({ subject: subject, data: data });
    }
    Services.obs.addObserver(observer, topic, false);
  });
}

function setup() {
 let server = serverForUsers({"foo": "password"}, {
    meta: {global: {engines: {bookmarks: {version: engine.version,
                                          syncID: engine.syncID}}}},
    bookmarks: {},
  });

  generateNewKeys(Service.collectionKeys);

  new SyncTestingInfrastructure(server.server);

  let collection = server.user("foo").collection("bookmarks");

  Svc.Obs.notify("weave:engine:start-tracking");   // We skip usual startup...

  return { server, collection };
}

function* cleanup(server) {
  Svc.Obs.notify("weave:engine:stop-tracking");
  Services.prefs.setBoolPref("services.sync-testing.startOverKeepIdentity", true);
  let promiseStartOver = promiseOneObserver("weave:service:start-over:finish");
  Service.startOver();
  yield promiseStartOver;
  yield new Promise(resolve => server.stop(resolve));
  yield bms.eraseEverything();
}

function getFolderChildrenIDs(folderId) {
  let index = 0;
  let result = [];
  while (true) {
    let childId = bms.getIdForItemAt(folderId, index);
    if (childId == -1) {
      break;
    }
    result.push(childId);
    index++;
  }
  return result;
}

function createFolder(parentId, title) {
  let id = bms.createFolder(parentId, title, 0);
  let guid = store.GUIDForId(id);
  return { id, guid };
}

function createBookmark(parentId, url, title, index = bms.DEFAULT_INDEX) {
  let uri = Utils.makeURI(url);
  let id = bms.insertBookmark(parentId, uri, index, title)
  let guid = store.GUIDForId(id);
  return { id, guid };
}

function getServerRecord(collection, id) {
  let wbo = collection.get({ full: true, ids: [id] });
  // Whew - lots of json strings inside strings.
  return JSON.parse(JSON.parse(JSON.parse(wbo).payload).ciphertext);
}

function* promiseNoLocalItem(guid) {
  // Check there's no item with the specified guid.
  let got = yield bms.fetch({ guid });
  ok(!got, `No record remains with GUID ${guid}`);
  // and while we are here ensure the places cache doesn't still have it.
  yield Assert.rejects(PlacesUtils.promiseItemId(guid));
}

function* validate(collection, expectedFailures = []) {
  let validator = new BookmarkValidator();
  let records = collection.payloads();

  let problems = validator.inspectServerRecords(records).problemData;
  // all non-zero problems.
  let summary = problems.getSummary().filter(prob => prob.count != 0);

  // split into 2 arrays - expected and unexpected.
  let isInExpectedFailures = elt =>  {
    for (let i = 0; i < expectedFailures.length; i++) {
      if (elt.name == expectedFailures[i].name && elt.count == expectedFailures[i].count) {
        return true;
      }
    }
    return false;
  }
  let expected = [];
  let unexpected = [];
  for (let elt of summary) {
    (isInExpectedFailures(elt) ? expected : unexpected).push(elt);
  }
  if (unexpected.length || expected.length != expectedFailures.length) {
    do_print("Validation failed:");
    do_print(JSON.stringify(summary));
    // print the entire validator output as it has IDs etc.
    do_print(JSON.stringify(problems, undefined, 2));
    // All server records and the entire bookmark tree.
    do_print("Server records:\n" + JSON.stringify(collection.payloads(), undefined, 2));
    let tree = yield PlacesUtils.promiseBookmarksTree("", { includeItemIds: true });
    do_print("Local bookmark tree:\n" + JSON.stringify(tree, undefined, 2));
    ok(false);
  }
}

add_task(function* test_dupe_bookmark() {
  _("Ensure that a bookmark we consider a dupe is handled correctly.");

  let { server, collection } = this.setup();

  try {
    // The parent folder and one bookmark in it.
    let {id: folder1_id, guid: folder1_guid } = createFolder(bms.toolbarFolder, "Folder 1");
    let {id: bmk1_id, guid: bmk1_guid} = createBookmark(folder1_id, "http://getfirefox.com/", "Get Firefox!");

    engine.sync();

    // We've added the bookmark, its parent (folder1) plus "menu", "toolbar", "unfiled", and "mobile".
    equal(collection.count(), 6);
    equal(getFolderChildrenIDs(folder1_id).length, 1);

    // Now create a new incoming record that looks alot like a dupe.
    let newGUID = Utils.makeGUID();
    let to_apply = {
      id: newGUID,
      bmkUri: "http://getfirefox.com/",
      type: "bookmark",
      title: "Get Firefox!",
      parentName: "Folder 1",
      parentid: folder1_guid,
    };

    collection.insert(newGUID, encryptPayload(to_apply), Date.now() / 1000 + 10);
    _("Syncing so new dupe record is processed");
    engine.lastSync = engine.lastSync - 0.01;
    engine.sync();

    // We should have logically deleted the dupe record.
    equal(collection.count(), 7);
    ok(getServerRecord(collection, bmk1_guid).deleted);
    // and physically removed from the local store.
    yield promiseNoLocalItem(bmk1_guid);
    // Parent should still only have 1 item.
    equal(getFolderChildrenIDs(folder1_id).length, 1);
    // The parent record on the server should now reference the new GUID and not the old.
    let serverRecord = getServerRecord(collection, folder1_guid);
    ok(!serverRecord.children.includes(bmk1_guid));
    ok(serverRecord.children.includes(newGUID));

    // and a final sanity check - use the validator
    yield validate(collection);
  } finally {
    yield cleanup(server);
  }
});

add_task(function* test_dupe_reparented_bookmark() {
  _("Ensure that a bookmark we consider a dupe from a different parent is handled correctly");

  let { server, collection } = this.setup();

  try {
    // The parent folder and one bookmark in it.
    let {id: folder1_id, guid: folder1_guid } = createFolder(bms.toolbarFolder, "Folder 1");
    let {id: bmk1_id, guid: bmk1_guid} = createBookmark(folder1_id, "http://getfirefox.com/", "Get Firefox!");
    // Another parent folder *with the same name*
    let {id: folder2_id, guid: folder2_guid } = createFolder(bms.toolbarFolder, "Folder 1");

    do_print(`folder1_guid=${folder1_guid}, folder2_guid=${folder2_guid}, bmk1_guid=${bmk1_guid}`);

    engine.sync();

    // We've added the bookmark, 2 folders plus "menu", "toolbar", "unfiled", and "mobile".
    equal(collection.count(), 7);
    equal(getFolderChildrenIDs(folder1_id).length, 1);
    equal(getFolderChildrenIDs(folder2_id).length, 0);

    // Now create a new incoming record that looks alot like a dupe of the
    // item in folder1_guid, but with a record that points to folder2_guid.
    let newGUID = Utils.makeGUID();
    let to_apply = {
      id: newGUID,
      bmkUri: "http://getfirefox.com/",
      type: "bookmark",
      title: "Get Firefox!",
      parentName: "Folder 1",
      parentid: folder2_guid,
    };

    collection.insert(newGUID, encryptPayload(to_apply), Date.now() / 1000 + 10);

    _("Syncing so new dupe record is processed");
    engine.lastSync = engine.lastSync - 0.01;
    engine.sync();

    // We should have logically deleted the dupe record.
    equal(collection.count(), 8);
    ok(getServerRecord(collection, bmk1_guid).deleted);
    // and physically removed from the local store.
    yield promiseNoLocalItem(bmk1_guid);
    // The original folder no longer has the item
    equal(getFolderChildrenIDs(folder1_id).length, 0);
    // But the second dupe folder does.
    equal(getFolderChildrenIDs(folder2_id).length, 1);

    // The record for folder1 on the server should reference neither old or new GUIDs.
    let serverRecord1 = getServerRecord(collection, folder1_guid);
    ok(!serverRecord1.children.includes(bmk1_guid));
    ok(!serverRecord1.children.includes(newGUID));

    // The record for folder2 on the server should only reference the new new GUID.
    let serverRecord2 = getServerRecord(collection, folder2_guid);
    ok(!serverRecord2.children.includes(bmk1_guid));
    ok(serverRecord2.children.includes(newGUID));

    // and a final sanity check - use the validator
    yield validate(collection);
  } finally {
    yield cleanup(server);
  }
});

add_task(function* test_dupe_reparented_locally_changed_bookmark() {
  _("Ensure that a bookmark with local changes we consider a dupe from a different parent is handled correctly");

  let { server, collection } = this.setup();

  try {
    // The parent folder and one bookmark in it.
    let {id: folder1_id, guid: folder1_guid } = createFolder(bms.toolbarFolder, "Folder 1");
    let {id: bmk1_id, guid: bmk1_guid} = createBookmark(folder1_id, "http://getfirefox.com/", "Get Firefox!");
    // Another parent folder *with the same name*
    let {id: folder2_id, guid: folder2_guid } = createFolder(bms.toolbarFolder, "Folder 1");

    do_print(`folder1_guid=${folder1_guid}, folder2_guid=${folder2_guid}, bmk1_guid=${bmk1_guid}`);

    engine.sync();

    // We've added the bookmark, 2 folders plus "menu", "toolbar", "unfiled", and "mobile".
    equal(collection.count(), 7);
    equal(getFolderChildrenIDs(folder1_id).length, 1);
    equal(getFolderChildrenIDs(folder2_id).length, 0);

    // Now create a new incoming record that looks alot like a dupe of the
    // item in folder1_guid, but with a record that points to folder2_guid.
    let newGUID = Utils.makeGUID();
    let to_apply = {
      id: newGUID,
      bmkUri: "http://getfirefox.com/",
      type: "bookmark",
      title: "Get Firefox!",
      parentName: "Folder 1",
      parentid: folder2_guid,
    };

    collection.insert(newGUID, encryptPayload(to_apply), Date.now() / 1000 + 10);

    // Make a change to the bookmark that's a dupe, and set the modification
    // time further in the future than the incoming record. This will cause
    // us to issue the infamous "DATA LOSS" warning in the logs but cause us
    // to *not* apply the incoming record.
    engine._tracker.addChangedID(bmk1_guid, Date.now() / 1000 + 60);

    _("Syncing so new dupe record is processed");
    engine.lastSync = engine.lastSync - 0.01;
    engine.sync();

    // We should have logically deleted the dupe record.
    equal(collection.count(), 8);
    ok(getServerRecord(collection, bmk1_guid).deleted);
    // and physically removed from the local store.
    yield promiseNoLocalItem(bmk1_guid);
    // The original folder still longer has the item
    equal(getFolderChildrenIDs(folder1_id).length, 1);
    // The second folder does not.
    equal(getFolderChildrenIDs(folder2_id).length, 0);

    // The record for folder1 on the server should reference only the GUID.
    let serverRecord1 = getServerRecord(collection, folder1_guid);
    ok(!serverRecord1.children.includes(bmk1_guid));
    ok(serverRecord1.children.includes(newGUID));

    // The record for folder2 on the server should reference nothing.
    let serverRecord2 = getServerRecord(collection, folder2_guid);
    ok(!serverRecord2.children.includes(bmk1_guid));
    ok(!serverRecord2.children.includes(newGUID));

    // and a final sanity check - use the validator
    yield validate(collection);
  } finally {
    yield cleanup(server);
  }
});

add_task(function* test_dupe_reparented_to_earlier_appearing_parent_bookmark() {
  _("Ensure that a bookmark we consider a dupe from a different parent that " +
    "appears in the same sync before the dupe item");

  let { server, collection } = this.setup();

  try {
    // The parent folder and one bookmark in it.
    let {id: folder1_id, guid: folder1_guid } = createFolder(bms.toolbarFolder, "Folder 1");
    let {id: bmk1_id, guid: bmk1_guid} = createBookmark(folder1_id, "http://getfirefox.com/", "Get Firefox!");
    // One more folder we'll use later.
    let {id: folder2_id, guid: folder2_guid} = createFolder(bms.toolbarFolder, "A second folder");

    do_print(`folder1=${folder1_guid}, bmk1=${bmk1_guid} folder2=${folder2_guid}`);

    engine.sync();

    // We've added the bookmark, 2 folders plus "menu", "toolbar", "unfiled", and "mobile".
    equal(collection.count(), 7);
    equal(getFolderChildrenIDs(folder1_id).length, 1);

    let newGUID = Utils.makeGUID();
    let newParentGUID = Utils.makeGUID();

    // Have the new parent appear before the dupe item.
    collection.insert(newParentGUID, encryptPayload({
      id: newParentGUID,
      type: "folder",
      title: "Folder 1",
      parentName: "A second folder",
      parentid: folder2_guid,
      children: [newGUID],
      tags: [],
    }), Date.now() / 1000 + 10);

    // And also the update to "folder 2" that references the new parent.
    collection.insert(folder2_guid, encryptPayload({
      id: folder2_guid,
      type: "folder",
      title: "A second folder",
      parentName: "Bookmarks Toolbar",
      parentid: "toolbar",
      children: [newParentGUID],
      tags: [],
    }), Date.now() / 1000 + 10);

    // Now create a new incoming record that looks alot like a dupe of the
    // item in folder1_guid, with a record that points to a parent with the
    // same name which appeared earlier in this sync.
    collection.insert(newGUID, encryptPayload({
      id: newGUID,
      bmkUri: "http://getfirefox.com/",
      type: "bookmark",
      title: "Get Firefox!",
      parentName: "Folder 1",
      parentid: newParentGUID,
      tags: [],
    }), Date.now() / 1000 + 10);


    _("Syncing so new records are processed.");
    engine.lastSync = engine.lastSync - 0.01;
    engine.sync();

    // Everything should be parented correctly.
    equal(getFolderChildrenIDs(folder1_id).length, 0);
    let newParentID = store.idForGUID(newParentGUID);
    let newID = store.idForGUID(newGUID);
    deepEqual(getFolderChildrenIDs(newParentID), [newID]);

    // Make sure the validator thinks everything is hunky-dory.
    yield validate(collection);
  } finally {
    yield cleanup(server);
  }
});

add_task(function* test_dupe_reparented_to_later_appearing_parent_bookmark() {
  _("Ensure that a bookmark we consider a dupe from a different parent that " +
    "doesn't exist locally as we process the child, but does appear in the same sync");

  let { server, collection } = this.setup();

  try {
    // The parent folder and one bookmark in it.
    let {id: folder1_id, guid: folder1_guid } = createFolder(bms.toolbarFolder, "Folder 1");
    let {id: bmk1_id, guid: bmk1_guid} = createBookmark(folder1_id, "http://getfirefox.com/", "Get Firefox!");
    // One more folder we'll use later.
    let {id: folder2_id, guid: folder2_guid} = createFolder(bms.toolbarFolder, "A second folder");

    do_print(`folder1=${folder1_guid}, bmk1=${bmk1_guid} folder2=${folder2_guid}`);

    engine.sync();

    // We've added the bookmark, 2 folders plus "menu", "toolbar", "unfiled", and "mobile".
    equal(collection.count(), 7);
    equal(getFolderChildrenIDs(folder1_id).length, 1);

    // Now create a new incoming record that looks alot like a dupe of the
    // item in folder1_guid, but with a record that points to a parent with the
    // same name, but a non-existing local ID.
    let newGUID = Utils.makeGUID();
    let newParentGUID = Utils.makeGUID();

    collection.insert(newGUID, encryptPayload({
      id: newGUID,
      bmkUri: "http://getfirefox.com/",
      type: "bookmark",
      title: "Get Firefox!",
      parentName: "Folder 1",
      parentid: newParentGUID,
      tags: [],
    }), Date.now() / 1000 + 10);

    // Now have the parent appear after (so when the record above is processed
    // this is still unknown.)
    collection.insert(newParentGUID, encryptPayload({
      id: newParentGUID,
      type: "folder",
      title: "Folder 1",
      parentName: "A second folder",
      parentid: folder2_guid,
      children: [newGUID],
      tags: [],
    }), Date.now() / 1000 + 10);
    // And also the update to "folder 2" that references the new parent.
    collection.insert(folder2_guid, encryptPayload({
      id: folder2_guid,
      type: "folder",
      title: "A second folder",
      parentName: "Bookmarks Toolbar",
      parentid: "toolbar",
      children: [newParentGUID],
      tags: [],
    }), Date.now() / 1000 + 10);

    _("Syncing so out-of-order records are processed.");
    engine.lastSync = engine.lastSync - 0.01;
    engine.sync();

    // The intended parent did end up existing, so it should be parented
    // correctly after de-duplication.
    equal(getFolderChildrenIDs(folder1_id).length, 0);
    let newParentID = store.idForGUID(newParentGUID);
    let newID = store.idForGUID(newGUID);
    deepEqual(getFolderChildrenIDs(newParentID), [newID]);

    // Make sure the validator thinks everything is hunky-dory.
    yield validate(collection);
  } finally {
    yield cleanup(server);
  }
});

add_task(function* test_dupe_reparented_to_future_arriving_parent_bookmark() {
  _("Ensure that a bookmark we consider a dupe from a different parent that " +
    "doesn't exist locally and doesn't appear in this Sync is handled correctly");

  let { server, collection } = this.setup();

  try {
    // The parent folder and one bookmark in it.
    let {id: folder1_id, guid: folder1_guid } = createFolder(bms.toolbarFolder, "Folder 1");
    let {id: bmk1_id, guid: bmk1_guid} = createBookmark(folder1_id, "http://getfirefox.com/", "Get Firefox!");
    // One more folder we'll use later.
    let {id: folder2_id, guid: folder2_guid} = createFolder(bms.toolbarFolder, "A second folder");

    do_print(`folder1=${folder1_guid}, bmk1=${bmk1_guid} folder2=${folder2_guid}`);

    engine.sync();

    // We've added the bookmark, 2 folders plus "menu", "toolbar", "unfiled", and "mobile".
    equal(collection.count(), 7);
    equal(getFolderChildrenIDs(folder1_id).length, 1);

    // Now create a new incoming record that looks alot like a dupe of the
    // item in folder1_guid, but with a record that points to a parent with the
    // same name, but a non-existing local ID.
    let newGUID = Utils.makeGUID();
    let newParentGUID = Utils.makeGUID();

    collection.insert(newGUID, encryptPayload({
      id: newGUID,
      bmkUri: "http://getfirefox.com/",
      type: "bookmark",
      title: "Get Firefox!",
      parentName: "Folder 1",
      parentid: newParentGUID,
      tags: [],
    }), Date.now() / 1000 + 10);

    _("Syncing so new dupe record is processed");
    engine.lastSync = engine.lastSync - 0.01;
    engine.sync();

    // We should have logically deleted the dupe record.
    equal(collection.count(), 8);
    ok(getServerRecord(collection, bmk1_guid).deleted);
    // and physically removed from the local store.
    yield promiseNoLocalItem(bmk1_guid);
    // The intended parent doesn't exist, so it remains in the original folder
    equal(getFolderChildrenIDs(folder1_id).length, 1);

    // The record for folder1 on the server should reference the new GUID.
    let serverRecord1 = getServerRecord(collection, folder1_guid);
    ok(!serverRecord1.children.includes(bmk1_guid));
    ok(serverRecord1.children.includes(newGUID));

    // As the incoming parent is missing the item should have been annotated
    // with that missing parent.
    equal(PlacesUtils.annotations.getItemAnnotation(store.idForGUID(newGUID), "sync/parent"),
          newParentGUID);

    // Check the validator. Sadly, this is known to cause a mismatch between
    // the server and client views of the tree.
    let expected = [
      // We haven't fixed the incoming record that referenced the missing parent.
      { name: "orphans", count: 1 },
    ];
    yield validate(collection, expected);

    // Now have the parent magically appear in a later sync - but
    // it appears as being in a different parent from our existing "Folder 1",
    // so the folder itself isn't duped.
    collection.insert(newParentGUID, encryptPayload({
      id: newParentGUID,
      type: "folder",
      title: "Folder 1",
      parentName: "A second folder",
      parentid: folder2_guid,
      children: [newGUID],
      tags: [],
    }), Date.now() / 1000 + 10);
    // We also queue an update to "folder 2" that references the new parent.
    collection.insert(folder2_guid, encryptPayload({
      id: folder2_guid,
      type: "folder",
      title: "A second folder",
      parentName: "Bookmarks Toolbar",
      parentid: "toolbar",
      children: [newParentGUID],
      tags: [],
    }), Date.now() / 1000 + 10);

    _("Syncing so missing parent appears");
    engine.lastSync = engine.lastSync - 0.01;
    engine.sync();

    // The intended parent now does exist, so it should have been reparented.
    equal(getFolderChildrenIDs(folder1_id).length, 0);
    let newParentID = store.idForGUID(newParentGUID);
    let newID = store.idForGUID(newGUID);
    deepEqual(getFolderChildrenIDs(newParentID), [newID]);

    // validation now has different errors :(
    expected = [
      // The validator reports multipleParents because:
      // * The incoming record newParentGUID still (and correctly) references
      //   newGUID as a child.
      // * Our original Folder1 was updated to include newGUID when it
      //   originally de-deuped and couldn't find the parent.
      // * When the parent *did* eventually arrive we used the parent annotation
      //   to correctly reparent - but that reparenting process does not change
      //   the server record.
      // Hence, newGUID is a child of both those server records :(
      { name: "multipleParents", count: 1 },
    ];
    yield validate(collection, expected);

  } finally {
    yield cleanup(server);
  }
});

add_task(function* test_dupe_empty_folder() {
  _("Ensure that an empty folder we consider a dupe is handled correctly.");
  // Empty folders aren't particularly interesting in practice (as that seems
  // an edge-case) but duping folders with items is broken - bug 1293163.
  let { server, collection } = this.setup();

  try {
    // The folder we will end up duping away.
    let {id: folder1_id, guid: folder1_guid } = createFolder(bms.toolbarFolder, "Folder 1");

    engine.sync();

    // We've added 1 folder, "menu", "toolbar", "unfiled", and "mobile".
    equal(collection.count(), 5);

    // Now create new incoming records that looks alot like a dupe of "Folder 1".
    let newFolderGUID = Utils.makeGUID();
    collection.insert(newFolderGUID, encryptPayload({
      id: newFolderGUID,
      type: "folder",
      title: "Folder 1",
      parentName: "Bookmarks Toolbar",
      parentid: "toolbar",
      children: [],
    }), Date.now() / 1000 + 10);

    _("Syncing so new dupe records are processed");
    engine.lastSync = engine.lastSync - 0.01;
    engine.sync();

    yield validate(collection);

    // Collection now has one additional record - the logically deleted dupe.
    equal(collection.count(), 6);
    // original folder should be logically deleted.
    ok(getServerRecord(collection, folder1_guid).deleted);
    yield promiseNoLocalItem(folder1_guid);
  } finally {
    yield cleanup(server);
  }
});
// XXX - TODO - folders with children. Bug 1293163
