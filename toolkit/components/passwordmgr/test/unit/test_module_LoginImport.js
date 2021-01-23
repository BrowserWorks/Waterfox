/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

/**
 * Tests the LoginImport object.
 */

"use strict";

// Globals

ChromeUtils.defineModuleGetter(
  this,
  "LoginImport",
  "resource://gre/modules/LoginImport.jsm"
);
ChromeUtils.defineModuleGetter(
  this,
  "LoginStore",
  "resource://gre/modules/LoginStore.jsm"
);
ChromeUtils.defineModuleGetter(
  this,
  "Sqlite",
  "resource://gre/modules/Sqlite.jsm"
);

XPCOMUtils.defineLazyServiceGetter(
  this,
  "gLoginManagerCrypto",
  "@mozilla.org/login-manager/crypto/SDR;1",
  "nsILoginManagerCrypto"
);
XPCOMUtils.defineLazyServiceGetter(
  this,
  "gUUIDGenerator",
  "@mozilla.org/uuid-generator;1",
  "nsIUUIDGenerator"
);

/**
 * Creates empty login data tables in the given SQLite connection, resembling
 * the most recent schema version (excluding indices).
 */
function promiseCreateDatabaseSchema(aConnection) {
  return (async function() {
    await aConnection.setSchemaVersion(5);
    await aConnection.execute(
      "CREATE TABLE moz_logins (" +
        "id                  INTEGER PRIMARY KEY," +
        "hostname            TEXT NOT NULL," +
        "httpRealm           TEXT," +
        "formSubmitURL       TEXT," +
        "usernameField       TEXT NOT NULL," +
        "passwordField       TEXT NOT NULL," +
        "encryptedUsername   TEXT NOT NULL," +
        "encryptedPassword   TEXT NOT NULL," +
        "guid                TEXT," +
        "encType             INTEGER," +
        "timeCreated         INTEGER," +
        "timeLastUsed        INTEGER," +
        "timePasswordChanged INTEGER," +
        "timesUsed           INTEGER)"
    );
    await aConnection.execute(
      "CREATE TABLE moz_disabledHosts (" +
        "id                  INTEGER PRIMARY KEY," +
        "hostname            TEXT UNIQUE)"
    );
    await aConnection.execute(
      "CREATE TABLE moz_deleted_logins (" +
        "id                  INTEGER PRIMARY KEY," +
        "guid                TEXT," +
        "timeDeleted         INTEGER)"
    );
  })();
}

/**
 * Inserts a new entry in the database resembling the given nsILoginInfo object.
 */
function promiseInsertLoginInfo(aConnection, aLoginInfo) {
  aLoginInfo.QueryInterface(Ci.nsILoginMetaInfo);

  // We can't use the aLoginInfo object directly in the execute statement
  // because the bind code in Sqlite.jsm doesn't allow objects with extra
  // properties beyond those being binded. So we might as well use an array as
  // it is simpler.
  let values = [
    aLoginInfo.origin,
    aLoginInfo.httpRealm,
    aLoginInfo.formActionOrigin,
    aLoginInfo.usernameField,
    aLoginInfo.passwordField,
    gLoginManagerCrypto.encrypt(aLoginInfo.username),
    gLoginManagerCrypto.encrypt(aLoginInfo.password),
    aLoginInfo.guid,
    aLoginInfo.encType,
    aLoginInfo.timeCreated,
    aLoginInfo.timeLastUsed,
    aLoginInfo.timePasswordChanged,
    aLoginInfo.timesUsed,
  ];

  return aConnection.execute(
    "INSERT INTO moz_logins (hostname, " +
      "httpRealm, formSubmitURL, usernameField, " +
      "passwordField, encryptedUsername, " +
      "encryptedPassword, guid, encType, timeCreated, " +
      "timeLastUsed, timePasswordChanged, timesUsed) " +
      "VALUES (?" +
      ",?".repeat(12) +
      ")",
    values
  );
}

/**
 * Inserts a new disabled host entry in the database.
 */
function promiseInsertDisabledHost(aConnection, aOrigin) {
  return aConnection.execute(
    "INSERT INTO moz_disabledHosts (hostname) VALUES (?)",
    [aOrigin]
  );
}

// Tests

/**
 * Imports login data from a SQLite file constructed using the test data.
 */
add_task(async function test_import() {
  let store = new LoginStore(getTempFile("test-import.json").path);
  let loginsSqlite = getTempFile("test-logins.sqlite").path;

  // Prepare the logins to be imported, including the nsILoginMetaInfo data.
  let loginList = TestData.loginList();
  for (let loginInfo of loginList) {
    loginInfo.QueryInterface(Ci.nsILoginMetaInfo);
    loginInfo.guid = gUUIDGenerator.generateUUID().toString();
    loginInfo.timeCreated = Date.now();
    loginInfo.timeLastUsed = Date.now();
    loginInfo.timePasswordChanged = Date.now();
    loginInfo.timesUsed = 1;
  }

  // Create and populate the SQLite database first.
  let connection = await Sqlite.openConnection({ path: loginsSqlite });
  try {
    await promiseCreateDatabaseSchema(connection);
    for (let loginInfo of loginList) {
      await promiseInsertLoginInfo(connection, loginInfo);
    }
    await promiseInsertDisabledHost(connection, "http://www.example.com");
    await promiseInsertDisabledHost(connection, "https://www.example.org");
  } finally {
    await connection.close();
  }

  // The "load" method must be called before importing data.
  await store.load();
  await new LoginImport(store, loginsSqlite).import();

  // Verify that every login in the test data has a matching imported row.
  Assert.equal(loginList.length, store.data.logins.length);
  Assert.ok(
    loginList.every(function(loginInfo) {
      return store.data.logins.some(function(loginDataItem) {
        let username = gLoginManagerCrypto.decrypt(
          loginDataItem.encryptedUsername
        );
        let password = gLoginManagerCrypto.decrypt(
          loginDataItem.encryptedPassword
        );
        return (
          loginDataItem.hostname == loginInfo.origin &&
          loginDataItem.httpRealm == loginInfo.httpRealm &&
          loginDataItem.formSubmitURL == loginInfo.formActionOrigin &&
          loginDataItem.usernameField == loginInfo.usernameField &&
          loginDataItem.passwordField == loginInfo.passwordField &&
          username == loginInfo.username &&
          password == loginInfo.password &&
          loginDataItem.guid == loginInfo.guid &&
          loginDataItem.encType == loginInfo.encType &&
          loginDataItem.timeCreated == loginInfo.timeCreated &&
          loginDataItem.timeLastUsed == loginInfo.timeLastUsed &&
          loginDataItem.timePasswordChanged == loginInfo.timePasswordChanged &&
          loginDataItem.timesUsed == loginInfo.timesUsed
        );
      });
    })
  );
});

/**
 * Tests imports of NULL values due to a downgraded database.
 */
add_task(async function test_import_downgraded() {
  let store = new LoginStore(getTempFile("test-import-downgraded.json").path);
  let loginsSqlite = getTempFile("test-logins-downgraded.sqlite").path;

  // Create and populate the SQLite database first.
  let connection = await Sqlite.openConnection({ path: loginsSqlite });
  try {
    await promiseCreateDatabaseSchema(connection);
    await connection.setSchemaVersion(3);
    await promiseInsertLoginInfo(
      connection,
      TestData.formLogin({
        guid: gUUIDGenerator.generateUUID().toString(),
        timeCreated: null,
        timeLastUsed: null,
        timePasswordChanged: null,
        timesUsed: 0,
      })
    );
  } finally {
    await connection.close();
  }

  // The "load" method must be called before importing data.
  await store.load();
  await new LoginImport(store, loginsSqlite).import();

  // Verify that the missing metadata was generated correctly.
  let loginItem = store.data.logins[0];
  let creationTime = loginItem.timeCreated;
  LoginTestUtils.assertTimeIsAboutNow(creationTime);
  Assert.equal(loginItem.timeLastUsed, creationTime);
  Assert.equal(loginItem.timePasswordChanged, creationTime);
  Assert.equal(loginItem.timesUsed, 1);
});

/**
 * Verifies that importing from a SQLite file with database version 2 fails.
 */
add_task(async function test_import_v2() {
  let store = new LoginStore(getTempFile("test-import-v2.json").path);
  let loginsSqlite = do_get_file("data/signons-v2.sqlite").path;

  // The "load" method must be called before importing data.
  await store.load();
  try {
    await new LoginImport(store, loginsSqlite).import();
    do_throw("The operation should have failed.");
  } catch (ex) {}
});

/**
 * Imports login data from a SQLite file, with database version 3.
 */
add_task(async function test_import_v3() {
  let store = new LoginStore(getTempFile("test-import-v3.json").path);
  let loginsSqlite = do_get_file("data/signons-v3.sqlite").path;

  // The "load" method must be called before importing data.
  await store.load();
  await new LoginImport(store, loginsSqlite).import();

  // We only execute basic integrity checks.
  Assert.equal(store.data.logins[0].usernameField, "u1");
});
