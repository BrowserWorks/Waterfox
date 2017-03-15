Cu.importGlobalProperties(["URL", "crypto"]);

const { TYPE_BOOKMARK, TYPE_FOLDER } = Ci.nsINavBookmarksService;
const { EXPIRE_NEVER, TYPE_INT32 } = Ci.nsIAnnotationService;

function makeGuid() {
  return ChromeUtils.base64URLEncode(crypto.getRandomValues(new Uint8Array(9)), {
    pad: false,
  });
}

// These queries are more or less copied directly from Bookmarks.jsm, but
// operate on the old, pre-migration DB. We can't use any of the Places SQL
// functions yet, because those are only registered for the main connection.
function* insertItem(db, info) {
  let [parentInfo] = yield db.execute(`
    SELECT b.id, (SELECT count(*) FROM moz_bookmarks
                  WHERE parent = b.id) AS childCount
    FROM moz_bookmarks b
    WHERE b.guid = :parentGuid`,
    { parentGuid: info.parentGuid });

  let guid = makeGuid();
  yield db.execute(`
    INSERT INTO moz_bookmarks (fk, type, parent, position, guid)
    VALUES ((SELECT id FROM moz_places WHERE url = :url),
            :type, :parent, :position, :guid)`,
    { url: info.url || "nonexistent", type: info.type, guid,
      // Just append items.
      position: parentInfo.getResultByName("childCount"),
      parent: parentInfo.getResultByName("id") });

  let id = (yield db.execute(`
    SELECT id FROM moz_bookmarks WHERE guid = :guid LIMIT 1`,
    { guid }))[0].getResultByName("id");

  return { id, guid };
}

function insertBookmark(db, info) {
  return db.executeTransaction(function* () {
    if (info.type == TYPE_BOOKMARK) {
      // We don't have access to the hash function here, so we omit the
      // `url_hash` column. These will be fixed up automatically during
      // migration.
      let url = new URL(info.url);
      let placeGuid = makeGuid();
      yield db.execute(`
        INSERT INTO moz_places (url, rev_host, hidden, frecency, guid)
        VALUES (:url, :rev_host, 0, -1, :guid)`,
        { url: url.href, guid: placeGuid,
          rev_host: PlacesUtils.getReversedHost(url) });
    }
    return yield* insertItem(db, info);
  });
}

function* insertAnno(db, itemId, name, value) {
  yield db.execute(`INSERT OR IGNORE INTO moz_anno_attributes (name)
                    VALUES (:name)`, { name });
  yield db.execute(`
    INSERT INTO moz_items_annos
           (item_id, anno_attribute_id, content, flags,
            expiration, type, dateAdded, lastModified)
    VALUES (:itemId,
      (SELECT id FROM moz_anno_attributes
       WHERE name = :name),
      1, 0, :expiration, :type, 0, 0)
    `, { itemId, name, expiration: EXPIRE_NEVER, type: TYPE_INT32 });
}

function insertMobileFolder(db) {
  return db.executeTransaction(function* () {
    let item = yield* insertItem(db, {
      type: TYPE_FOLDER,
      parentGuid: "root________",
    });
    yield* insertAnno(db, item.id, "mobile/bookmarksRoot", 1);
    return item;
  });
}

var mobileId, mobileGuid, fxGuid;
var dupeMobileId, dupeMobileGuid, tbGuid;

add_task(function* setup() {
  yield setupPlacesDatabase("places_v34.sqlite");
  // Setup database contents to be migrated.
  let path = OS.Path.join(OS.Constants.Path.profileDir, DB_FILENAME);
  let db = yield Sqlite.openConnection({ path });

  do_print("Create mobile folder with bookmarks");
  ({ id: mobileId, guid: mobileGuid } = yield insertMobileFolder(db));
  ({ guid: fxGuid } = yield insertBookmark(db, {
    type: TYPE_BOOKMARK,
    url: "http://getfirefox.com",
    parentGuid: mobileGuid,
  }));

  // We should only have one mobile folder, but, in case an old version of Sync
  // did the wrong thing and created multiple mobile folders, we should merge
  // their contents into the new mobile root.
  do_print("Create second mobile folder with different bookmarks");
  ({ id: dupeMobileId, guid: dupeMobileGuid } = yield insertMobileFolder(db));
  ({ guid: tbGuid } = yield insertBookmark(db, {
    type: TYPE_BOOKMARK,
    url: "http://getthunderbird.com",
    parentGuid: dupeMobileGuid,
  }));

  yield db.close();
});

add_task(function* database_is_valid() {
  // Accessing the database for the first time triggers migration.
  Assert.equal(PlacesUtils.history.databaseStatus,
               PlacesUtils.history.DATABASE_STATUS_UPGRADED);

  let db = yield PlacesUtils.promiseDBConnection();
  Assert.equal((yield db.getSchemaVersion()), CURRENT_SCHEMA_VERSION);
});

add_task(function* test_mobile_root() {
  let fxBmk = yield PlacesUtils.bookmarks.fetch(fxGuid);
  equal(fxBmk.parentGuid, PlacesUtils.bookmarks.mobileGuid,
    "Firefox bookmark should be moved to new mobile root");
  equal(fxBmk.index, 0, "Firefox bookmark should be first child of new root");

  let tbBmk = yield PlacesUtils.bookmarks.fetch(tbGuid);
  equal(tbBmk.parentGuid, PlacesUtils.bookmarks.mobileGuid,
    "Thunderbird bookmark should be moved to new mobile root");
  equal(tbBmk.index, 1,
    "Thunderbird bookmark should be second child of new root");

  let mobileRootId = PlacesUtils.promiseItemId(
    PlacesUtils.bookmarks.mobileGuid);
  let annoItemIds = PlacesUtils.annotations.getItemsWithAnnotation(
    PlacesUtils.MOBILE_ROOT_ANNO, {});
  deepEqual(annoItemIds, [mobileRootId],
    "Only mobile root should have mobile anno");
});
