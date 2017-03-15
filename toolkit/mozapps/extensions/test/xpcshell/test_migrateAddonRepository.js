/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
 */

const EXPECTED_SCHEMA_VERSION = 4;
var dbfile;

function run_test() {
  do_test_pending();
  createAppInfo("xpcshell@tests.mozilla.org", "XPCShell", "1", "1.9.2");

  // Write out a minimal database.
  dbfile = gProfD.clone();
  dbfile.append("addons.sqlite");
  let db = AM_Cc["@mozilla.org/storage/service;1"].
           getService(AM_Ci.mozIStorageService).
           openDatabase(dbfile);

  db.createTable("addon",
                 "internal_id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                 "id TEXT UNIQUE, " +
                 "type TEXT, " +
                 "name TEXT, " +
                 "version TEXT, " +
                 "creator TEXT, " +
                 "creatorURL TEXT, " +
                 "description TEXT, " +
                 "fullDescription TEXT, " +
                 "developerComments TEXT, " +
                 "eula TEXT, " +
                 "iconURL TEXT, " +
                 "homepageURL TEXT, " +
                 "supportURL TEXT, " +
                 "contributionURL TEXT, " +
                 "contributionAmount TEXT, " +
                 "averageRating INTEGER, " +
                 "reviewCount INTEGER, " +
                 "reviewURL TEXT, " +
                 "totalDownloads INTEGER, " +
                 "weeklyDownloads INTEGER, " +
                 "dailyUsers INTEGER, " +
                 "sourceURI TEXT, " +
                 "repositoryStatus INTEGER, " +
                 "size INTEGER, " +
                 "updateDate INTEGER");

  db.createTable("developer",
                 "addon_internal_id INTEGER, " +
                 "num INTEGER, " +
                 "name TEXT, " +
                 "url TEXT, " +
                 "PRIMARY KEY (addon_internal_id, num)");

  db.createTable("screenshot",
                 "addon_internal_id INTEGER, " +
                 "num INTEGER, " +
                 "url TEXT, " +
                 "thumbnailURL TEXT, " +
                 "caption TEXT, " +
                 "PRIMARY KEY (addon_internal_id, num)");

  let insertStmt = db.createStatement("INSERT INTO addon (id) VALUES (:id)");
  insertStmt.params.id = "test1@tests.mozilla.org";
  insertStmt.execute();
  insertStmt.finalize();

  insertStmt = db.createStatement("INSERT INTO screenshot VALUES " +
                            "(:addon_internal_id, :num, :url, :thumbnailURL, :caption)");

  insertStmt.params.addon_internal_id = 1;
  insertStmt.params.num = 0;
  insertStmt.params.url = "http://localhost/full1-1.png";
  insertStmt.params.thumbnailURL = "http://localhost/thumbnail1-1.png";
  insertStmt.params.caption = "Caption 1 - 1";
  insertStmt.execute();
  insertStmt.finalize();

  db.schemaVersion = 1;
  db.close();


  Services.prefs.setBoolPref("extensions.getAddons.cache.enabled", true);
  AddonRepository.getCachedAddonByID("test1@tests.mozilla.org", function (aAddon) {
    do_check_neq(aAddon, null);
    do_check_eq(aAddon.screenshots.length, 1);
    do_check_true(aAddon.screenshots[0].width === null);
    do_check_true(aAddon.screenshots[0].height === null);
    do_check_true(aAddon.screenshots[0].thumbnailWidth === null);
    do_check_true(aAddon.screenshots[0].thumbnailHeight === null);
    do_check_eq(aAddon.iconURL, undefined);
    do_check_eq(JSON.stringify(aAddon.icons), "{}");
    AddonRepository.shutdown().then(
      function checkAfterRepoShutdown() {
        // Check the DB schema has changed once AddonRepository has freed it.
        db = AM_Cc["@mozilla.org/storage/service;1"].
             getService(AM_Ci.mozIStorageService).
             openDatabase(dbfile);
        do_check_eq(db.schemaVersion, EXPECTED_SCHEMA_VERSION);
        do_check_true(db.indexExists("developer_idx"));
        do_check_true(db.indexExists("screenshot_idx"));
        do_check_true(db.indexExists("compatibility_override_idx"));
        do_check_true(db.tableExists("compatibility_override"));
        do_check_true(db.indexExists("icon_idx"));
        do_check_true(db.tableExists("icon"));

        // Check the trigger is working
        db.executeSimpleSQL("INSERT INTO addon (id, type, name) VALUES('test_addon', 'extension', 'Test Addon')");
        let internalID = db.lastInsertRowID;
        db.executeSimpleSQL("INSERT INTO compatibility_override (addon_internal_id, num, type) VALUES('" + internalID + "', '1', 'incompatible')");

        let selectStmt = db.createStatement("SELECT COUNT(*) AS count FROM compatibility_override");
        selectStmt.executeStep();
        do_check_eq(selectStmt.row.count, 1);
        selectStmt.reset();

        db.executeSimpleSQL("DELETE FROM addon");
        selectStmt.executeStep();
        do_check_eq(selectStmt.row.count, 0);
        selectStmt.finalize();

        db.close();
        do_test_finished();
      },
      do_report_unexpected_exception
    );
  });
}
