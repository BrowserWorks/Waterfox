const {utils: Cu, interfaces: Ci, classes: Cc} = Components;

Cu.import("resource://gre/modules/Services.jsm");

do_get_profile();
const dirSvc = Cc["@mozilla.org/file/directory_service;1"].
               getService(Ci.nsIProperties);

let dbFile = dirSvc.get("ProfD", Ci.nsIFile);
dbFile.append("cookies.sqlite");

let storage = Cc["@mozilla.org/storage/service;1"].
              getService(Ci.mozIStorageService);
let properties = Cc["@mozilla.org/hash-property-bag;1"].
                 createInstance(Ci.nsIWritablePropertyBag);
properties.setProperty("shared", true);
let conn = storage.openDatabase(dbFile);

// Write the schema v7 to the database.
conn.schemaVersion = 7;
conn.executeSimpleSQL("CREATE TABLE moz_cookies (" +
  "id INTEGER PRIMARY KEY, " +
  "baseDomain TEXT, " +
  "originAttributes TEXT NOT NULL DEFAULT '', " +
  "name TEXT, " +
  "value TEXT, " +
  "host TEXT, " +
  "path TEXT, " +
  "expiry INTEGER, " +
  "lastAccessed INTEGER, " +
  "creationTime INTEGER, " +
  "isSecure INTEGER, " +
  "isHttpOnly INTEGER, " +
  "appId INTEGER DEFAULT 0, " +
  "inBrowserElement INTEGER DEFAULT 0, " +
  "CONSTRAINT moz_uniqueid UNIQUE (name, host, path, originAttributes)" +
")");
conn.executeSimpleSQL("CREATE INDEX moz_basedomain ON moz_cookies (baseDomain, " +
                                                                  "originAttributes)");

conn.executeSimpleSQL("PRAGMA synchronous = OFF");
conn.executeSimpleSQL("PRAGMA journal_mode = WAL");
conn.executeSimpleSQL("PRAGMA wal_autocheckpoint = 16");

let now = Date.now();
conn.executeSimpleSQL("INSERT INTO moz_cookies(" +
  "baseDomain, host, name, value, path, expiry, " +
  "lastAccessed, creationTime, isSecure, isHttpOnly) VALUES (" +
  "'foo.com', '.foo.com', 'foo', 'bar=baz', '/', " +
  now + ", " + now + ", " + now + ", 1, 1)");

// Now start the cookie service, and then check the fields in the table.

const cs = Cc["@mozilla.org/cookieService;1"].
           getService(Ci.nsICookieService);

do_check_true(conn.schemaVersion, 8);
let stmt = conn.createStatement("SELECT sql FROM sqlite_master " +
                                  "WHERE type = 'table' AND " +
                                  "      name = 'moz_cookies'");
try {
  do_check_true(stmt.executeStep());
  let sql = stmt.getString(0);
  do_check_eq(sql.indexOf("appId"), -1);
} finally {
  stmt.finalize();
}

stmt = conn.createStatement("SELECT * FROM moz_cookies " +
                            "WHERE baseDomain = 'foo.com' AND " +
                            "      host = '.foo.com' AND " +
                            "      name = 'foo' AND " +
                            "      value = 'bar=baz' AND " +
                            "      path = '/' AND " +
                            "      expiry = " + now + " AND " +
                            "      lastAccessed = " + now + " AND " +
                            "      creationTime = " + now + " AND " +
                            "      isSecure = 1 AND " +
                            "      isHttpOnly = 1");
try {
  do_check_true(stmt.executeStep());
} finally {
  stmt.finalize();
}
conn.close();
