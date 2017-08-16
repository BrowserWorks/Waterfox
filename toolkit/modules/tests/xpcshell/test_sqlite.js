"use strict";

var {classes: Cc, interfaces: Ci, utils: Cu} = Components;

do_get_profile();

Cu.import("resource://gre/modules/Promise.jsm");
Cu.import("resource://gre/modules/PromiseUtils.jsm");
Cu.import("resource://gre/modules/osfile.jsm");
Cu.import("resource://gre/modules/FileUtils.jsm");
Cu.import("resource://gre/modules/Services.jsm");
Cu.import("resource://gre/modules/Sqlite.jsm");
Cu.import("resource://gre/modules/XPCOMUtils.jsm");

// To spin the event loop in test.
Cu.import("resource://services-common/async.js");

function sleep(ms) {
  return new Promise(resolve => {

    let timer = Cc["@mozilla.org/timer;1"]
                  .createInstance(Ci.nsITimer);

    timer.initWithCallback({
      notify() {
        resolve();
      },
    }, ms, timer.TYPE_ONE_SHOT);

  });
}

// When testing finalization, use this to tell Sqlite.jsm to not throw
// an uncatchable `Promise.reject`
function failTestsOnAutoClose(enabled) {
  Cu.getGlobalForObject(Sqlite).Debugging.failTestsOnAutoClose = enabled;
}

function getConnection(dbName, extraOptions = {}) {
  let path = dbName + ".sqlite";
  let options = {path};
  for (let [k, v] of Object.entries(extraOptions)) {
    options[k] = v;
  }

  return Sqlite.openConnection(options);
}

async function getDummyDatabase(name, extraOptions = {}) {
  const TABLES = {
    dirs: "id INTEGER PRIMARY KEY AUTOINCREMENT, path TEXT",
    files: "id INTEGER PRIMARY KEY AUTOINCREMENT, dir_id INTEGER, path TEXT",
  };

  let c = await getConnection(name, extraOptions);
  c._initialStatementCount = 0;

  for (let [k, v] of Object.entries(TABLES)) {
    await c.execute("CREATE TABLE " + k + "(" + v + ")");
    c._initialStatementCount++;
  }

  return c;
}

async function getDummyTempDatabase(name, extraOptions = {}) {
  const TABLES = {
    dirs: "id INTEGER PRIMARY KEY AUTOINCREMENT, path TEXT",
    files: "id INTEGER PRIMARY KEY AUTOINCREMENT, dir_id INTEGER, path TEXT",
  };

  let c = await getConnection(name, extraOptions);
  c._initialStatementCount = 0;

  for (let [k, v] of Object.entries(TABLES)) {
    await c.execute("CREATE TEMP TABLE " + k + "(" + v + ")");
    c._initialStatementCount++;
  }

  return c;
}

add_task(async function test_setup() {
  Cu.import("resource://testing-common/services/common/logging.js");
  initTestLogging("Trace");
});

add_task(async function test_open_normal() {
  let c = await Sqlite.openConnection({path: "test_open_normal.sqlite"});
  await c.close();
});

add_task(async function test_open_unshared() {
  let path = OS.Path.join(OS.Constants.Path.profileDir, "test_open_unshared.sqlite");

  let c = await Sqlite.openConnection({path, sharedMemoryCache: false});
  await c.close();
});

add_task(async function test_get_dummy_database() {
  let db = await getDummyDatabase("get_dummy_database");

  do_check_eq(typeof(db), "object");
  await db.close();
});

add_task(async function test_schema_version() {
  let db = await getDummyDatabase("schema_version");

  let version = await db.getSchemaVersion();
  do_check_eq(version, 0);

  db.setSchemaVersion(14);
  version = await db.getSchemaVersion();
  do_check_eq(version, 14);

  for (let v of [0.5, "foobar", NaN]) {
    let success;
    try {
      await db.setSchemaVersion(v);
      do_print("Schema version " + v + " should have been rejected");
      success = false;
    } catch (ex) {
      if (!ex.message.startsWith("Schema version must be an integer."))
        throw ex;
      success = true;
    }
    do_check_true(success);

    version = await db.getSchemaVersion();
    do_check_eq(version, 14);
  }

  await db.close();
});

add_task(async function test_simple_insert() {
  let c = await getDummyDatabase("simple_insert");

  let result = await c.execute("INSERT INTO dirs VALUES (NULL, 'foo')");
  do_check_true(Array.isArray(result));
  do_check_eq(result.length, 0);
  await c.close();
});

add_task(async function test_simple_bound_array() {
  let c = await getDummyDatabase("simple_bound_array");

  let result = await c.execute("INSERT INTO dirs VALUES (?, ?)", [1, "foo"]);
  do_check_eq(result.length, 0);
  await c.close();
});

add_task(async function test_simple_bound_object() {
  let c = await getDummyDatabase("simple_bound_object");
  let result = await c.execute("INSERT INTO dirs VALUES (:id, :path)",
                               {id: 1, path: "foo"});
  do_check_eq(result.length, 0);
  result = await c.execute("SELECT id, path FROM dirs");
  do_check_eq(result.length, 1);
  do_check_eq(result[0].getResultByName("id"), 1);
  do_check_eq(result[0].getResultByName("path"), "foo");
  await c.close();
});

// This is mostly a sanity test to ensure simple executions work.
add_task(async function test_simple_insert_then_select() {
  let c = await getDummyDatabase("simple_insert_then_select");

  await c.execute("INSERT INTO dirs VALUES (NULL, 'foo')");
  await c.execute("INSERT INTO dirs (path) VALUES (?)", ["bar"]);

  let result = await c.execute("SELECT * FROM dirs");
  do_check_eq(result.length, 2);

  let i = 0;
  for (let row of result) {
    i++;

    do_check_eq(row.numEntries, 2);
    do_check_eq(row.getResultByIndex(0), i);

    let expected = {1: "foo", 2: "bar"}[i];
    do_check_eq(row.getResultByName("path"), expected);
  }

  await c.close();
});

add_task(async function test_repeat_execution() {
  let c = await getDummyDatabase("repeat_execution");

  let sql = "INSERT INTO dirs (path) VALUES (:path)";
  await c.executeCached(sql, {path: "foo"});
  await c.executeCached(sql);

  let result = await c.execute("SELECT * FROM dirs");

  do_check_eq(result.length, 2);

  await c.close();
});

add_task(async function test_table_exists() {
  let c = await getDummyDatabase("table_exists");

  do_check_false(await c.tableExists("does_not_exist"));
  do_check_true(await c.tableExists("dirs"));
  do_check_true(await c.tableExists("files"));

  await c.close();
});

add_task(async function test_index_exists() {
  let c = await getDummyDatabase("index_exists");

  do_check_false(await c.indexExists("does_not_exist"));

  await c.execute("CREATE INDEX my_index ON dirs (path)");
  do_check_true(await c.indexExists("my_index"));

  await c.close();
});

add_task(async function test_temp_table_exists() {
  let c = await getDummyTempDatabase("temp_table_exists");

  do_check_false(await c.tableExists("temp_does_not_exist"));
  do_check_true(await c.tableExists("dirs"));
  do_check_true(await c.tableExists("files"));

  await c.close();
});

add_task(async function test_temp_index_exists() {
  let c = await getDummyTempDatabase("temp_index_exists");

  do_check_false(await c.indexExists("temp_does_not_exist"));

  await c.execute("CREATE INDEX my_index ON dirs (path)");
  do_check_true(await c.indexExists("my_index"));

  await c.close();
});

add_task(async function test_close_cached() {
  let c = await getDummyDatabase("close_cached");

  await c.executeCached("SELECT * FROM dirs");
  await c.executeCached("SELECT * FROM files");

  await c.close();
});

add_task(async function test_execute_invalid_statement() {
  let c = await getDummyDatabase("invalid_statement");

  await new Promise(resolve => {

    do_check_eq(c._connectionData._anonymousStatements.size, 0);

    c.execute("SELECT invalid FROM unknown").then(do_throw, function onError(error) {
      resolve();
    });

  });

  // Ensure we don't leak the statement instance.
  do_check_eq(c._connectionData._anonymousStatements.size, 0);

  await c.close();
});

add_task(async function test_incorrect_like_bindings() {
  let c = await getDummyDatabase("incorrect_like_bindings");

  let sql = "select * from dirs where path LIKE 'non%'";
  Assert.throws(() => c.execute(sql), /Please enter a LIKE clause/);
  Assert.throws(() => c.executeCached(sql), /Please enter a LIKE clause/);

  await c.close();
});
add_task(async function test_on_row_exception_ignored() {
  let c = await getDummyDatabase("on_row_exception_ignored");

  let sql = "INSERT INTO dirs (path) VALUES (?)";
  for (let i = 0; i < 10; i++) {
    await c.executeCached(sql, ["dir" + i]);
  }

  let i = 0;
  let hasResult = await c.execute("SELECT * FROM DIRS", null, function onRow(row) {
    i++;

    throw new Error("Some silly error.");
  });

  do_check_eq(hasResult, true);
  do_check_eq(i, 10);

  await c.close();
});

// Ensure StopIteration during onRow causes processing to stop.
add_task(async function test_on_row_stop_iteration() {
  let c = await getDummyDatabase("on_row_stop_iteration");

  let sql = "INSERT INTO dirs (path) VALUES (?)";
  for (let i = 0; i < 10; i++) {
    await c.executeCached(sql, ["dir" + i]);
  }

  let i = 0;
  let hasResult = await c.execute("SELECT * FROM dirs", null, function onRow(row) {
    i++;

    if (i == 5) {
      throw StopIteration;
    }
  });

  do_check_eq(hasResult, true);
  do_check_eq(i, 5);

  await c.close();
});

// Ensure execute resolves to false when no rows are selected.
add_task(async function test_on_row_stop_iteration() {
  let c = await getDummyDatabase("no_on_row");

  let i = 0;
  let hasResult = await c.execute(`SELECT * FROM dirs WHERE path="nonexistent"`, null, function onRow(row) {
    i++;
  });

  do_check_eq(hasResult, false);
  do_check_eq(i, 0);

  await c.close();
});

add_task(async function test_invalid_transaction_type() {
  let c = await getDummyDatabase("invalid_transaction_type");

  Assert.throws(() => c.executeTransaction(function() {}, "foobar"),
                /Unknown transaction type/,
                "Unknown transaction type should throw");

  await c.close();
});

add_task(async function test_execute_transaction_success() {
  let c = await getDummyDatabase("execute_transaction_success");

  do_check_false(c.transactionInProgress);

  await c.executeTransaction(async function transaction(conn) {
    do_check_eq(c, conn);
    do_check_true(conn.transactionInProgress);

    await conn.execute("INSERT INTO dirs (path) VALUES ('foo')");
  });

  do_check_false(c.transactionInProgress);
  let rows = await c.execute("SELECT * FROM dirs");
  do_check_true(Array.isArray(rows));
  do_check_eq(rows.length, 1);

  await c.close();
});

add_task(async function test_execute_transaction_rollback() {
  let c = await getDummyDatabase("execute_transaction_rollback");

  let deferred = Promise.defer();

  c.executeTransaction(async function transaction(conn) {
    await conn.execute("INSERT INTO dirs (path) VALUES ('foo')");
    print("Expecting error with next statement.");
    await conn.execute("INSERT INTO invalid VALUES ('foo')");

    // We should never get here.
    do_throw();
  }).then(do_throw, function onError(error) {
    deferred.resolve();
  });

  await deferred.promise;

  let rows = await c.execute("SELECT * FROM dirs");
  do_check_eq(rows.length, 0);

  await c.close();
});

add_task(async function test_close_during_transaction() {
  let c = await getDummyDatabase("close_during_transaction");

  await c.execute("INSERT INTO dirs (path) VALUES ('foo')");

  let promise = c.executeTransaction(async function transaction(conn) {
    await c.execute("INSERT INTO dirs (path) VALUES ('bar')");
  });
  await c.close();

  await Assert.rejects(promise,
                       /Transaction canceled due to a closed connection/,
                       "closing a connection in the middle of a transaction should reject it");

  let c2 = await getConnection("close_during_transaction");
  let rows = await c2.execute("SELECT * FROM dirs");
  do_check_eq(rows.length, 1);

  await c2.close();
});

// Verify that we support concurrent transactions.
add_task(async function test_multiple_transactions() {
  let c = await getDummyDatabase("detect_multiple_transactions");

  for (let i = 0; i < 10; ++i) {
    // We don't wait for these transactions.
    c.executeTransaction(async function() {
      await c.execute("INSERT INTO dirs (path) VALUES (:path)",
                      { path: `foo${i}` });
      await c.execute("SELECT * FROM dirs");
    });
  }
  for (let i = 0; i < 10; ++i) {
    await c.executeTransaction(async function() {
      await c.execute("INSERT INTO dirs (path) VALUES (:path)",
                      { path: `bar${i}` });
      await c.execute("SELECT * FROM dirs");
    });
  }

  let rows = await c.execute("SELECT * FROM dirs");
  do_check_eq(rows.length, 20);

  await c.close();
});

// Verify that wrapped transactions ignore a BEGIN TRANSACTION failure, when
// an externally opened transaction exists.
add_task(async function test_wrapped_connection_transaction() {
  let file = new FileUtils.File(OS.Path.join(OS.Constants.Path.profileDir,
                                             "test_wrapStorageConnection.sqlite"));
  let c = await new Promise((resolve, reject) => {
    Services.storage.openAsyncDatabase(file, null, (status, db) => {
      if (Components.isSuccessCode(status)) {
        resolve(db.QueryInterface(Ci.mozIStorageAsyncConnection));
      } else {
        reject(new Error(status));
      }
    });
  });

  let wrapper = await Sqlite.wrapStorageConnection({ connection: c });
  // Start a transaction on the raw connection.
  await c.executeSimpleSQLAsync("BEGIN");
  // Now use executeTransaction, it will be executed, but not in a transaction.
  await wrapper.executeTransaction(async function() {
    await wrapper.execute("CREATE TABLE test (id INTEGER PRIMARY KEY AUTOINCREMENT)");
  });
  // This should not fail cause the internal transaction has not been created.
  await c.executeSimpleSQLAsync("COMMIT");

  await wrapper.execute("SELECT * FROM test");

  // Closing the wrapper should just finalize statements but not close the
  // database.
  await wrapper.close();
  await c.asyncClose();
});

add_task(async function test_shrink_memory() {
  let c = await getDummyDatabase("shrink_memory");

  // It's just a simple sanity test. We have no way of measuring whether this
  // actually does anything.

  await c.shrinkMemory();
  await c.close();
});

add_task(async function test_no_shrink_on_init() {
  let c = await getConnection("no_shrink_on_init",
                              {shrinkMemoryOnConnectionIdleMS: 200});

  let count = 0;
  Object.defineProperty(c._connectionData, "shrinkMemory", {
    value() {
      count++;
    },
  });

  // We should not shrink until a statement has been executed.
  await sleep(220);
  do_check_eq(count, 0);

  await c.execute("SELECT 1");
  await sleep(220);
  do_check_eq(count, 1);

  await c.close();
});

add_task(async function test_idle_shrink_fires() {
  let c = await getDummyDatabase("idle_shrink_fires",
                                 {shrinkMemoryOnConnectionIdleMS: 200});
  c._connectionData._clearIdleShrinkTimer();

  let oldShrink = c._connectionData.shrinkMemory;
  let shrinkPromises = [];

  let count = 0;
  Object.defineProperty(c._connectionData, "shrinkMemory", {
    value() {
      count++;
      let promise = oldShrink.call(c._connectionData);
      shrinkPromises.push(promise);
      return promise;
    },
  });

  // We reset the idle shrink timer after monkeypatching because otherwise the
  // installed timer callback will reference the non-monkeypatched function.
  c._connectionData._startIdleShrinkTimer();

  await sleep(220);
  do_check_eq(count, 1);
  do_check_eq(shrinkPromises.length, 1);
  await shrinkPromises[0];
  shrinkPromises.shift();

  // We shouldn't shrink again unless a statement was executed.
  await sleep(300);
  do_check_eq(count, 1);

  await c.execute("SELECT 1");
  await sleep(300);

  do_check_eq(count, 2);
  do_check_eq(shrinkPromises.length, 1);
  await shrinkPromises[0];

  await c.close();
});

add_task(async function test_idle_shrink_reset_on_operation() {
  const INTERVAL = 500;
  let c = await getDummyDatabase("idle_shrink_reset_on_operation",
                                 {shrinkMemoryOnConnectionIdleMS: INTERVAL});

  c._connectionData._clearIdleShrinkTimer();

  let oldShrink = c._connectionData.shrinkMemory;
  let shrinkPromises = [];
  let count = 0;

  Object.defineProperty(c._connectionData, "shrinkMemory", {
    value() {
      count++;
      let promise = oldShrink.call(c._connectionData);
      shrinkPromises.push(promise);
      return promise;
    },
  });

  let now = new Date();
  c._connectionData._startIdleShrinkTimer();

  let initialIdle = new Date(now.getTime() + INTERVAL);

  // Perform database operations until initial scheduled time has been passed.
  let i = 0;
  while (new Date() < initialIdle) {
    await c.execute("INSERT INTO dirs (path) VALUES (?)", ["" + i]);
    i++;
  }

  do_check_true(i > 0);

  // We should not have performed an idle while doing operations.
  do_check_eq(count, 0);

  // Wait for idle timer.
  await sleep(INTERVAL);

  // Ensure we fired.
  do_check_eq(count, 1);
  do_check_eq(shrinkPromises.length, 1);
  await shrinkPromises[0];

  await c.close();
});

add_task(async function test_in_progress_counts() {
  let c = await getDummyDatabase("in_progress_counts");
  do_check_eq(c._connectionData._statementCounter, c._initialStatementCount);
  do_check_eq(c._connectionData._pendingStatements.size, 0);
  await c.executeCached("INSERT INTO dirs (path) VALUES ('foo')");
  do_check_eq(c._connectionData._statementCounter, c._initialStatementCount + 1);
  do_check_eq(c._connectionData._pendingStatements.size, 0);

  let expectOne;
  let expectTwo;

  // Please forgive me.
  let inner = Async.makeSpinningCallback();
  let outer = Async.makeSpinningCallback();

  // We want to make sure that two queries executing simultaneously
  // result in `_pendingStatements.size` reaching 2, then dropping back to 0.
  //
  // To do so, we kick off a second statement within the row handler
  // of the first, then wait for both to finish.

  await c.executeCached("SELECT * from dirs", null, function onRow() {
    // In the onRow handler, we're still an outstanding query.
    // Expect a single in-progress entry.
    expectOne = c._connectionData._pendingStatements.size;

    // Start another query, checking that after its statement has been created
    // there are two statements in progress.
    let p = c.executeCached("SELECT 10, path from dirs");
    expectTwo = c._connectionData._pendingStatements.size;

    // Now wait for it to be done before we return from the row handler …
    p.then(function onInner() {
      inner();
    });
  }).then(function onOuter() {
    // … and wait for the inner to be done before we finish …
    inner.wait();
    outer();
  });

  // … and wait for both queries to have finished before we go on and
  // test postconditions.
  outer.wait();

  do_check_eq(expectOne, 1);
  do_check_eq(expectTwo, 2);
  do_check_eq(c._connectionData._statementCounter, c._initialStatementCount + 3);
  do_check_eq(c._connectionData._pendingStatements.size, 0);

  await c.close();
});

add_task(async function test_discard_while_active() {
  let c = await getDummyDatabase("discard_while_active");

  await c.executeCached("INSERT INTO dirs (path) VALUES ('foo')");
  await c.executeCached("INSERT INTO dirs (path) VALUES ('bar')");

  let discarded = -1;
  let first = true;
  let sql = "SELECT * FROM dirs";
  await c.executeCached(sql, null, function onRow(row) {
    if (!first) {
      return;
    }
    first = false;
    discarded = c.discardCachedStatements();
  });

  // We discarded everything, because the SELECT had already started to run.
  do_check_eq(3, discarded);

  // And again is safe.
  do_check_eq(0, c.discardCachedStatements());

  await c.close();
});

add_task(async function test_discard_cached() {
  let c = await getDummyDatabase("discard_cached");

  await c.executeCached("SELECT * from dirs");
  do_check_eq(1, c._connectionData._cachedStatements.size);

  await c.executeCached("SELECT * from files");
  do_check_eq(2, c._connectionData._cachedStatements.size);

  await c.executeCached("SELECT * from dirs");
  do_check_eq(2, c._connectionData._cachedStatements.size);

  c.discardCachedStatements();
  do_check_eq(0, c._connectionData._cachedStatements.size);

  await c.close();
});

add_task(async function test_programmatic_binding() {
  let c = await getDummyDatabase("programmatic_binding");

  let bindings = [
    {id: 1,    path: "foobar"},
    {id: null, path: "baznoo"},
    {id: 5,    path: "toofoo"},
  ];

  let sql = "INSERT INTO dirs VALUES (:id, :path)";
  let result = await c.execute(sql, bindings);
  do_check_eq(result.length, 0);

  let rows = await c.executeCached("SELECT * from dirs");
  do_check_eq(rows.length, 3);
  await c.close();
});

add_task(async function test_programmatic_binding_transaction() {
  let c = await getDummyDatabase("programmatic_binding_transaction");

  let bindings = [
    {id: 1,    path: "foobar"},
    {id: null, path: "baznoo"},
    {id: 5,    path: "toofoo"},
  ];

  let sql = "INSERT INTO dirs VALUES (:id, :path)";
  await c.executeTransaction(async function transaction() {
    let result = await c.execute(sql, bindings);
    do_check_eq(result.length, 0);

    let rows = await c.executeCached("SELECT * from dirs");
    do_check_eq(rows.length, 3);
  });

  // Transaction committed.
  let rows = await c.executeCached("SELECT * from dirs");
  do_check_eq(rows.length, 3);
  await c.close();
});

add_task(async function test_programmatic_binding_transaction_partial_rollback() {
  let c = await getDummyDatabase("programmatic_binding_transaction_partial_rollback");

  let bindings = [
    {id: 2, path: "foobar"},
    {id: 3, path: "toofoo"},
  ];

  let sql = "INSERT INTO dirs VALUES (:id, :path)";

  // Add some data in an implicit transaction before beginning the batch insert.
  await c.execute(sql, {id: 1, path: "works"});

  let secondSucceeded = false;
  try {
    await c.executeTransaction(async function transaction() {
      // Insert one row. This won't implicitly start a transaction.
      await c.execute(sql, bindings[0]);

      // Insert multiple rows. mozStorage will want to start a transaction.
      // One of the inserts will fail, so the transaction should be rolled back.
      await c.execute(sql, bindings);
      secondSucceeded = true;
    });
  } catch (ex) {
    print("Caught expected exception: " + ex);
  }

  // We did not get to the end of our in-transaction block.
  do_check_false(secondSucceeded);

  // Everything that happened in *our* transaction, not mozStorage's, got
  // rolled back, but the first row still exists.
  let rows = await c.executeCached("SELECT * from dirs");
  do_check_eq(rows.length, 1);
  do_check_eq(rows[0].getResultByName("path"), "works");
  await c.close();
});

// Just like the previous test, but relying on the implicit
// transaction established by mozStorage.
add_task(async function test_programmatic_binding_implicit_transaction() {
  let c = await getDummyDatabase("programmatic_binding_implicit_transaction");

  let bindings = [
    {id: 2, path: "foobar"},
    {id: 1, path: "toofoo"},
  ];

  let sql = "INSERT INTO dirs VALUES (:id, :path)";
  let secondSucceeded = false;
  await c.execute(sql, {id: 1, path: "works"});
  try {
    await c.execute(sql, bindings);
    secondSucceeded = true;
  } catch (ex) {
    print("Caught expected exception: " + ex);
  }

  do_check_false(secondSucceeded);

  // The entire batch failed.
  let rows = await c.executeCached("SELECT * from dirs");
  do_check_eq(rows.length, 1);
  do_check_eq(rows[0].getResultByName("path"), "works");
  await c.close();
});

// Test that direct binding of params and execution through mozStorage doesn't
// error when we manually create a transaction. See Bug 856925.
add_task(async function test_direct() {
  let file = FileUtils.getFile("TmpD", ["test_direct.sqlite"]);
  file.createUnique(Ci.nsIFile.NORMAL_FILE_TYPE, FileUtils.PERMS_FILE);
  print("Opening " + file.path);

  let db = Services.storage.openDatabase(file);
  print("Opened " + db);

  db.executeSimpleSQL("CREATE TABLE types (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, UNIQUE (name))");
  print("Executed setup.");

  let statement = db.createAsyncStatement("INSERT INTO types (name) VALUES (:name)");
  let params = statement.newBindingParamsArray();
  let one = params.newBindingParams();
  one.bindByName("name", null);
  params.addParams(one);
  let two = params.newBindingParams();
  two.bindByName("name", "bar");
  params.addParams(two);

  print("Beginning transaction.");
  let begin = db.createAsyncStatement("BEGIN DEFERRED TRANSACTION");
  let end = db.createAsyncStatement("COMMIT TRANSACTION");

  let deferred = Promise.defer();
  begin.executeAsync({
    handleCompletion(reason) {
      deferred.resolve();
    }
  });
  await deferred.promise;

  statement.bindParameters(params);

  deferred = Promise.defer();
  print("Executing async.");
  statement.executeAsync({
    handleResult(resultSet) {
    },

    handleError(error) {
      print("Error when executing SQL (" + error.result + "): " +
            error.message);
      print("Original error: " + error.error);
      deferred.reject();
    },

    handleCompletion(reason) {
      print("Completed.");
      deferred.resolve();
    }
  });

  await deferred.promise;

  deferred = Promise.defer();
  end.executeAsync({
    handleCompletion(reason) {
      deferred.resolve();
    }
  });
  await deferred.promise;

  statement.finalize();
  begin.finalize();
  end.finalize();

  deferred = Promise.defer();
  db.asyncClose(function() {
    deferred.resolve()
  });
  await deferred.promise;
});

// Test Sqlite.cloneStorageConnection.
add_task(async function test_cloneStorageConnection() {
  let file = new FileUtils.File(OS.Path.join(OS.Constants.Path.profileDir,
                                             "test_cloneStorageConnection.sqlite"));
  let c = await new Promise((resolve, reject) => {
    Services.storage.openAsyncDatabase(file, null, (status, db) => {
      if (Components.isSuccessCode(status)) {
        resolve(db.QueryInterface(Ci.mozIStorageAsyncConnection));
      } else {
        reject(new Error(status));
      }
    });
  });

  let clone = await Sqlite.cloneStorageConnection({ connection: c, readOnly: true });
  // Just check that it works.
  await clone.execute("SELECT 1");

  let clone2 = await Sqlite.cloneStorageConnection({ connection: c, readOnly: false });
  // Just check that it works.
  await clone2.execute("CREATE TABLE test (id INTEGER PRIMARY KEY)");

  // Closing order should not matter.
  await c.asyncClose();
  await clone2.close();
  await clone.close();
});

// Test Sqlite.cloneStorageConnection invalid argument.
add_task(async function test_cloneStorageConnection() {
  try {
    await Sqlite.cloneStorageConnection({ connection: null });
    do_throw(new Error("Should throw on invalid connection"));
  } catch (ex) {
    if (ex.name != "TypeError") {
      throw ex;
    }
  }
});

// Test clone() method.
add_task(async function test_clone() {
  let c = await getDummyDatabase("clone");

  let clone = await c.clone();
  // Just check that it works.
  await clone.execute("SELECT 1");
  // Closing order should not matter.
  await c.close();
  await clone.close();
});

// Test clone(readOnly) method.
add_task(async function test_readOnly_clone() {
  let path = OS.Path.join(OS.Constants.Path.profileDir, "test_readOnly_clone.sqlite");
  let c = await Sqlite.openConnection({path, sharedMemoryCache: false});

  let clone = await c.clone(true);
  // Just check that it works.
  await clone.execute("SELECT 1");
  // But should not be able to write.

  await Assert.rejects(clone.execute("CREATE TABLE test (id INTEGER PRIMARY KEY)"),
                       /readonly/);
  // Closing order should not matter.
  await c.close();
  await clone.close();
});

// Test Sqlite.wrapStorageConnection.
add_task(async function test_wrapStorageConnection() {
  let file = new FileUtils.File(OS.Path.join(OS.Constants.Path.profileDir,
                                             "test_wrapStorageConnection.sqlite"));
  let c = await new Promise((resolve, reject) => {
    Services.storage.openAsyncDatabase(file, null, (status, db) => {
      if (Components.isSuccessCode(status)) {
        resolve(db.QueryInterface(Ci.mozIStorageAsyncConnection));
      } else {
        reject(new Error(status));
      }
    });
  });

  let wrapper = await Sqlite.wrapStorageConnection({ connection: c });
  // Just check that it works.
  await wrapper.execute("SELECT 1");
  await wrapper.executeCached("SELECT 1");

  // Closing the wrapper should just finalize statements but not close the
  // database.
  await wrapper.close();
  await c.asyncClose();
});

// Test finalization
add_task(async function test_closed_by_witness() {
  failTestsOnAutoClose(false);
  let c = await getDummyDatabase("closed_by_witness");

  Services.obs.notifyObservers(null, "sqlite-finalization-witness",
                               c._connectionData._identifier);
  // Since we triggered finalization ourselves, tell the witness to
  // forget the connection so it does not trigger a finalization again
  c._witness.forget();
  await c._connectionData._deferredClose.promise;
  do_check_false(c._connectionData._open);
  failTestsOnAutoClose(true);
});

add_task(async function test_warning_message_on_finalization() {
  failTestsOnAutoClose(false);
  let c = await getDummyDatabase("warning_message_on_finalization");
  let identifier = c._connectionData._identifier;
  let deferred = Promise.defer();

  let listener = {
    observe(msg) {
      let messageText = msg.message;
      // Make sure the message starts with a warning containing the
      // connection identifier
      if (messageText.indexOf("Warning: Sqlite connection '" + identifier + "'") !== -1) {
        deferred.resolve();
      }
    }
  };
  Services.console.registerListener(listener);

  Services.obs.notifyObservers(null, "sqlite-finalization-witness", identifier);
  // Since we triggered finalization ourselves, tell the witness to
  // forget the connection so it does not trigger a finalization again
  c._witness.forget();

  await deferred.promise;
  Services.console.unregisterListener(listener);
  failTestsOnAutoClose(true);
});

add_task(async function test_error_message_on_unknown_finalization() {
  failTestsOnAutoClose(false);
  let deferred = Promise.defer();

  let listener = {
    observe(msg) {
      let messageText = msg.message;
      if (messageText.indexOf("Error: Attempt to finalize unknown " +
                              "Sqlite connection: foo") !== -1) {
        deferred.resolve();
      }
    }
  };
  Services.console.registerListener(listener);
  Services.obs.notifyObservers(null, "sqlite-finalization-witness", "foo");

  await deferred.promise;
  Services.console.unregisterListener(listener);
  failTestsOnAutoClose(true);
});

add_task(async function test_forget_witness_on_close() {
  let c = await getDummyDatabase("forget_witness_on_close");

  let forgetCalled = false;
  let oldWitness = c._witness;
  c._witness = {
    forget() {
      forgetCalled = true;
      oldWitness.forget();
    },
  };

  await c.close();
  // After close, witness should have forgotten the connection
  do_check_true(forgetCalled);
});

add_task(async function test_close_database_on_gc() {
  failTestsOnAutoClose(false);
  let finalPromise;

  {
    let collectedPromises = [];
    for (let i = 0; i < 100; ++i) {
      let deferred = PromiseUtils.defer();
      let c = await getDummyDatabase("gc_" + i);
      c._connectionData._deferredClose.promise.then(deferred.resolve);
      collectedPromises.push(deferred.promise);
    }
    finalPromise = Promise.all(collectedPromises);
  }

  // Call getDummyDatabase once more to clear any remaining
  // references. This is needed at the moment, otherwise
  // garbage-collection takes place after the shutdown barrier and the
  // test will timeout. Once that is fixed, we can remove this line
  // and be fine as long as the connections are garbage-collected.
  let last = await getDummyDatabase("gc_last");
  await last.close();

  Components.utils.forceGC();
  Components.utils.forceCC();
  Components.utils.forceShrinkingGC();

  await finalPromise;
  failTestsOnAutoClose(true);
});

// Test all supported datatypes
add_task(async function test_datatypes() {
  let c = await getConnection("datatypes");
  await c.execute("DROP TABLE IF EXISTS datatypes");
  await c.execute(`CREATE TABLE datatypes (
                     null_col    NULL,
                     integer_col INTEGER NOT NULL,
                     text_col    TEXT    NOT NULL,
                     blob_col    BLOB    NOT NULL,
                     real_col    REAL    NOT NULL,
                     numeric_col NUMERIC NOT NULL
                   )`);
  const bindings = [
    {
      null_col: null,
      integer_col: 12345,
      text_col: "qwerty",
      blob_col: new Uint8Array(256).map( (value, index) => index % 256 ),
      real_col: 3.14159265359,
      numeric_col: true
    },
    {
      null_col: null,
      integer_col: -12345,
      text_col: "",
      blob_col: new Uint8Array(256 * 2).map( (value, index) => index % 256 ),
      real_col: Number.NEGATIVE_INFINITY,
      numeric_col: false
    }
  ];

  await c.execute(`INSERT INTO datatypes VALUES (
                     :null_col,
                     :integer_col,
                     :text_col,
                     :blob_col,
                     :real_col,
                     :numeric_col
                   )`, bindings);

  let rows = await c.execute("SELECT * FROM datatypes");
  Assert.ok(Array.isArray(rows));
  Assert.equal(rows.length, bindings.length);
  for (let i = 0 ; i < bindings.length; ++i) {
    let binding = bindings[i];
    let row = rows[i];
    for (let colName in binding) {
      // In Sqlite bool is stored and then retrieved as numeric.
      let val = typeof binding[colName] == "boolean" ? +binding[colName]
                                                       : binding[colName];
      Assert.deepEqual(val, row.getResultByName(colName));
    }
  }
  await c.close();
});
