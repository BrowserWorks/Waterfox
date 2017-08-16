/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

Cu.import("resource://services-common/kinto-offline-client.js");
Cu.import("resource://services-common/kinto-storage-adapter.js");

// set up what we need to make storage adapters
const kintoFilename = "kinto.sqlite";

function do_get_kinto_connection() {
  return FirefoxAdapter.openConnection({path: kintoFilename});
}

function do_get_kinto_adapter(sqliteHandle) {
  return new FirefoxAdapter("test", {sqliteHandle});
}

function do_get_kinto_db() {
  let profile = do_get_profile();
  let kintoDB = profile.clone();
  kintoDB.append(kintoFilename);
  return kintoDB;
}

function cleanup_kinto() {
  add_test(function cleanup_kinto_files() {
    let kintoDB = do_get_kinto_db();
    // clean up the db
    kintoDB.remove(false);
    run_next_test();
  });
}

function test_collection_operations() {
  add_task(function* test_kinto_clear() {
    let sqliteHandle = yield do_get_kinto_connection();
    let adapter = do_get_kinto_adapter(sqliteHandle);
    yield adapter.clear();
    yield sqliteHandle.close();
  });

  // test creating new records... and getting them again
  add_task(function* test_kinto_create_new_get_existing() {
    let sqliteHandle = yield do_get_kinto_connection();
    let adapter = do_get_kinto_adapter(sqliteHandle);
    let record = {id: "test-id", foo: "bar"};
    yield adapter.execute((transaction) => transaction.create(record));
    let newRecord = yield adapter.get("test-id");
    // ensure the record is the same as when it was added
    deepEqual(record, newRecord);
    yield sqliteHandle.close();
  });

  // test removing records
  add_task(function* test_kinto_can_remove_some_records() {
    let sqliteHandle = yield do_get_kinto_connection();
    let adapter = do_get_kinto_adapter(sqliteHandle);
    // create a second record
    let record = {id: "test-id-2", foo: "baz"};
    yield adapter.execute((transaction) => transaction.create(record));
    let newRecord = yield adapter.get("test-id-2");
    deepEqual(record, newRecord);
    // delete the record
    yield adapter.execute((transaction) => transaction.delete(record.id));
    newRecord = yield adapter.get(record.id);
    // ... and ensure it's no longer there
    do_check_eq(newRecord, undefined);
    // ensure the other record still exists
    newRecord = yield adapter.get("test-id");
    do_check_neq(newRecord, undefined);
    yield sqliteHandle.close();
  });

  // test getting records that don't exist
  add_task(function* test_kinto_get_non_existant() {
    let sqliteHandle = yield do_get_kinto_connection();
    let adapter = do_get_kinto_adapter(sqliteHandle);
    // Kinto expects adapters to either:
    let newRecord = yield adapter.get("missing-test-id");
    // resolve with an undefined record
    do_check_eq(newRecord, undefined);
    yield sqliteHandle.close();
  });

  // test updating records... and getting them again
  add_task(function* test_kinto_update_get_existing() {
    let sqliteHandle = yield do_get_kinto_connection();
    let adapter = do_get_kinto_adapter(sqliteHandle);
    let originalRecord = {id: "test-id", foo: "bar"};
    let updatedRecord = {id: "test-id", foo: "baz"};
    yield adapter.clear();
    yield adapter.execute((transaction) => transaction.create(originalRecord));
    yield adapter.execute((transaction) => transaction.update(updatedRecord));
    // ensure the record exists
    let newRecord = yield adapter.get("test-id");
    // ensure the record is the same as when it was added
    deepEqual(updatedRecord, newRecord);
    yield sqliteHandle.close();
  });

  // test listing records
  add_task(function* test_kinto_list() {
    let sqliteHandle = yield do_get_kinto_connection();
    let adapter = do_get_kinto_adapter(sqliteHandle);
    let originalRecord = {id: "test-id-1", foo: "bar"};
    let records = yield adapter.list();
    do_check_eq(records.length, 1);
    yield adapter.execute((transaction) => transaction.create(originalRecord));
    records = yield adapter.list();
    do_check_eq(records.length, 2);
    yield sqliteHandle.close();
  });

  // test aborting transaction
  add_task(function* test_kinto_aborting_transaction() {
    let sqliteHandle = yield do_get_kinto_connection();
    let adapter = do_get_kinto_adapter(sqliteHandle);
    yield adapter.clear();
    let record = {id: 1, foo: "bar"};
    let error = null;
    try {
      yield adapter.execute((transaction) => {
        transaction.create(record);
        throw new Error("unexpected");
      });
    } catch (e) {
      error = e;
    }
    do_check_neq(error, null);
    let records = yield adapter.list();
    do_check_eq(records.length, 0);
    yield sqliteHandle.close();
  });

  // test save and get last modified
  add_task(function* test_kinto_last_modified() {
    const initialValue = 0;
    const intendedValue = 12345678;

    let sqliteHandle = yield do_get_kinto_connection();
    let adapter = do_get_kinto_adapter(sqliteHandle);
    let lastModified = yield adapter.getLastModified();
    do_check_eq(lastModified, initialValue);
    let result = yield adapter.saveLastModified(intendedValue);
    do_check_eq(result, intendedValue);
    lastModified = yield adapter.getLastModified();
    do_check_eq(lastModified, intendedValue);

    // test saveLastModified parses values correctly
    result = yield adapter.saveLastModified(" " + intendedValue + " blah");
    // should resolve with the parsed int
    do_check_eq(result, intendedValue);
    // and should have saved correctly
    lastModified = yield adapter.getLastModified();
    do_check_eq(lastModified, intendedValue);
    yield sqliteHandle.close();
  });

  // test loadDump(records)
  add_task(function* test_kinto_import_records() {
    let sqliteHandle = yield do_get_kinto_connection();
    let adapter = do_get_kinto_adapter(sqliteHandle);
    let record1 = {id: 1, foo: "bar"};
    let record2 = {id: 2, foo: "baz"};
    let impactedRecords = yield adapter.loadDump([
      record1, record2
    ]);
    do_check_eq(impactedRecords.length, 2);
    let newRecord1 = yield adapter.get("1");
    // ensure the record is the same as when it was added
    deepEqual(record1, newRecord1);
    let newRecord2 = yield adapter.get("2");
    // ensure the record is the same as when it was added
    deepEqual(record2, newRecord2);
    yield sqliteHandle.close();
  });

  add_task(function* test_kinto_import_records_should_override_existing() {
    let sqliteHandle = yield do_get_kinto_connection();
    let adapter = do_get_kinto_adapter(sqliteHandle);
    yield adapter.clear();
    let records = yield adapter.list();
    do_check_eq(records.length, 0);
    let impactedRecords = yield adapter.loadDump([
      {id: 1, foo: "bar"},
      {id: 2, foo: "baz"},
    ]);
    do_check_eq(impactedRecords.length, 2);
    yield adapter.loadDump([
      {id: 1, foo: "baz"},
      {id: 3, foo: "bab"},
    ]);
    records = yield adapter.list();
    do_check_eq(records.length, 3);
    let newRecord1 = yield adapter.get("1");
    deepEqual(newRecord1.foo, "baz");
    yield sqliteHandle.close();
  });

  add_task(function* test_import_updates_lastModified() {
    let sqliteHandle = yield do_get_kinto_connection();
    let adapter = do_get_kinto_adapter(sqliteHandle);
    yield adapter.loadDump([
      {id: 1, foo: "bar", last_modified: 1457896541},
      {id: 2, foo: "baz", last_modified: 1458796542},
    ]);
    let lastModified = yield adapter.getLastModified();
    do_check_eq(lastModified, 1458796542);
    yield sqliteHandle.close();
  });

  add_task(function* test_import_preserves_older_lastModified() {
    let sqliteHandle = yield do_get_kinto_connection();
    let adapter = do_get_kinto_adapter(sqliteHandle);
    yield adapter.saveLastModified(1458796543);

    yield adapter.loadDump([
      {id: 1, foo: "bar", last_modified: 1457896541},
      {id: 2, foo: "baz", last_modified: 1458796542},
    ]);
    let lastModified = yield adapter.getLastModified();
    do_check_eq(lastModified, 1458796543);
    yield sqliteHandle.close();
  });
}

// test kinto db setup and operations in various scenarios
// test from scratch - no current existing database
add_test(function test_db_creation() {
  add_test(function test_create_from_scratch() {
    // ensure the file does not exist in the profile
    let kintoDB = do_get_kinto_db();
    do_check_false(kintoDB.exists());
    run_next_test();
  });

  test_collection_operations();

  cleanup_kinto();
  run_next_test();
});

// this is the closest we can get to a schema version upgrade at v1 - test an
// existing database
add_test(function test_creation_from_empty_db() {
  add_test(function test_create_from_empty_db() {
    // place an empty kinto db file in the profile
    let profile = do_get_profile();

    let emptyDB = do_get_file("test_storage_adapter/empty.sqlite");
    emptyDB.copyTo(profile, kintoFilename);

    run_next_test();
  });

  test_collection_operations();

  cleanup_kinto();
  run_next_test();
});

function run_test() {
  run_next_test();
}
