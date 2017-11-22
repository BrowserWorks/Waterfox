/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

XPCOMUtils.defineLazyModuleGetter(this, "PlacesTestUtils",
                                  "resource://testing-common/PlacesTestUtils.jsm");

var PERMISSIONS_FILE_NAME = "permissions.sqlite";

function GetPermissionsFile(profile)
{
  let file = profile.clone();
  file.append(PERMISSIONS_FILE_NAME);
  return file;
}

add_task(function test() {
  /* Create and set up the permissions database */
  let profile = do_get_profile();

  let db = Services.storage.openDatabase(GetPermissionsFile(profile));
  db.schemaVersion = 5;

  /*
   * V5 table
   */
  db.executeSimpleSQL(
    "CREATE TABLE moz_hosts (" +
      " id INTEGER PRIMARY KEY" +
      ",origin TEXT" +
      ",type TEXT" +
      ",permission INTEGER" +
      ",expireType INTEGER" +
      ",expireTime INTEGER" +
      ",modificationTime INTEGER" +
    ")");

  let stmt5Insert = db.createStatement(
    "INSERT INTO moz_hosts (" +
      "id, origin, type, permission, expireType, expireTime, modificationTime" +
    ") VALUES (" +
      ":id, :origin, :type, :permission, :expireType, :expireTime, :modificationTime" +
    ")");

  let id = 0;

  function insertOrigin(origin, type, permission, expireType, expireTime, modificationTime) {
    let thisId = id++;

    stmt5Insert.bindByName("id", thisId);
    stmt5Insert.bindByName("origin", origin);
    stmt5Insert.bindByName("type", type);
    stmt5Insert.bindByName("permission", permission);
    stmt5Insert.bindByName("expireType", expireType);
    stmt5Insert.bindByName("expireTime", expireTime);
    stmt5Insert.bindByName("modificationTime", modificationTime);

    try {
      stmt5Insert.execute();
    } finally {
      stmt5Insert.reset();
    }

    return {
      id: thisId,
      host: origin,
      type: type,
      permission: permission,
      expireType: expireType,
      expireTime: expireTime,
      modificationTime: modificationTime
    };
  }

  let created5 = [
    insertOrigin("https://foo.com", "A", 2, 0, 0, 0),
    insertOrigin("http://foo.com", "A", 2, 0, 0, 0),
    insertOrigin("http://foo.com^appId=1000&inBrowser=1", "A", 2, 0, 0, 0),

    insertOrigin("http://127.0.0.1", "B", 2, 0, 0, 0),
    insertOrigin("http://localhost", "B", 2, 0, 0, 0),
  ];

  let created4 = []; // Didn't create any v4 entries, so the DB should be empty

  // CLose the db connection
  stmt5Insert.finalize();
  db.close();
  stmt5Insert = null;
  db = null;

  let expected = [
    ["https://foo.com", "A", 2, 0, 0, 0],
    ["http://foo.com", "A", 2, 0, 0, 0],
    ["http://foo.com^appId=1000&inBrowser=1", "A", 2, 0, 0, 0],

    ["http://127.0.0.1", "B", 2, 0, 0, 0],
    ["http://localhost", "B", 2, 0, 0, 0],
  ];

  let found = expected.map((it) => 0);

  // Force initialization of the nsPermissionManager
  let enumerator = Services.perms.enumerator;
  while (enumerator.hasMoreElements()) {
    let permission = enumerator.getNext().QueryInterface(Ci.nsIPermission);
    let isExpected = false;

    expected.forEach((it, i) => {
      if (permission.principal.origin == it[0] &&
          permission.type == it[1] &&
          permission.capability == it[2] &&
          permission.expireType == it[3] &&
          permission.expireTime == it[4]) {
        isExpected = true;
        found[i]++;
      }
    });

    do_check_true(isExpected,
                  "Permission " + (isExpected ? "should" : "shouldn't") +
                  " be in permission database: " +
                  permission.principal.origin + ", " +
                  permission.type + ", " +
                  permission.capability + ", " +
                  permission.expireType + ", " +
                  permission.expireTime);
  }

  found.forEach((count, i) => {
    do_check_true(count == 1, "Expected count = 1, got count = " + count + " for permission " + expected[i]);
  });

  // Check to make sure that all of the tables which we care about are present
  {
    let db = Services.storage.openDatabase(GetPermissionsFile(profile));
    do_check_true(db.tableExists("moz_perms"));
    do_check_true(db.tableExists("moz_hosts"));
    do_check_false(db.tableExists("moz_hosts_is_backup"));
    do_check_false(db.tableExists("moz_perms_v6"));

    let mozHostsStmt = db.createStatement("SELECT " +
                                          "host, type, permission, expireType, expireTime, " +
                                          "modificationTime, appId, isInBrowserElement " +
                                          "FROM moz_hosts WHERE id = :id");
    try {
      // Check that the moz_hosts table still contains the correct values.
      created4.forEach((it) => {
        mozHostsStmt.reset();
        mozHostsStmt.bindByName("id", it.id);
        mozHostsStmt.executeStep();
        do_check_eq(mozHostsStmt.getUTF8String(0), it.host);
        do_check_eq(mozHostsStmt.getUTF8String(1), it.type);
        do_check_eq(mozHostsStmt.getInt64(2), it.permission);
        do_check_eq(mozHostsStmt.getInt64(3), it.expireType);
        do_check_eq(mozHostsStmt.getInt64(4), it.expireTime);
        do_check_eq(mozHostsStmt.getInt64(5), it.modificationTime);
        do_check_eq(mozHostsStmt.getInt64(6), it.appId);
        do_check_eq(mozHostsStmt.getInt64(7), it.isInBrowserElement);
      });
    } finally {
      mozHostsStmt.finalize();
    }

    // Check that there are the right number of values
    let mozHostsCount = db.createStatement("SELECT count(*) FROM moz_hosts");
    try {
      mozHostsCount.executeStep();
      do_check_eq(mozHostsCount.getInt64(0), created4.length);
    } finally {
      mozHostsCount.finalize();
    }

    db.close();
  }
});
