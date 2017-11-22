/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

var {classes: Cc, interfaces: Ci, utils: Cu} = Components;

do_get_profile();

Cu.import("resource://gre/modules/osfile.jsm");
  // OS.File doesn't like to be first imported during shutdown
Cu.import("resource://gre/modules/Sqlite.jsm");
Cu.import("resource://gre/modules/Services.jsm");
Cu.import("resource://gre/modules/AsyncShutdown.jsm");

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

function run_test() {
  run_next_test();
}


//
// -----------  Don't add a test after this one, as it shuts down Sqlite.jsm
//
add_task(async function test_shutdown_clients() {
  do_print("Ensuring that Sqlite.jsm doesn't shutdown before its clients");

  let assertions = [];

  let sleepStarted = false;
  let sleepComplete = false;
  Sqlite.shutdown.addBlocker("test_sqlite.js shutdown blocker (sleep)",
    async function() {
      sleepStarted = true;
      await sleep(100);
      sleepComplete = true;
    });
  assertions.push({name: "sleepStarted", value: () => sleepStarted});
  assertions.push({name: "sleepComplete", value: () => sleepComplete});

  Sqlite.shutdown.addBlocker("test_sqlite.js shutdown blocker (immediate)",
    true);

  let dbOpened = false;
  let dbClosed = false;

  Sqlite.shutdown.addBlocker("test_sqlite.js shutdown blocker (open a connection during shutdown)",
    async function() {
      let db = await getDummyDatabase("opened during shutdown");
      dbOpened = true;
      db.close().then(
        () => dbClosed = true
      ); // Don't wait for this task to complete, Sqlite.jsm must wait automatically
  });

  assertions.push({name: "dbOpened", value: () => dbOpened});
  assertions.push({name: "dbClosed", value: () => dbClosed});

  do_print("Now shutdown Sqlite.jsm synchronously");
  Services.prefs.setBoolPref("toolkit.asyncshutdown.testing", true);
  AsyncShutdown.profileBeforeChange._trigger();
  Services.prefs.clearUserPref("toolkit.asyncshutdown.testing");


  for (let {name, value} of assertions) {
    do_print("Checking: " + name);
    do_check_true(value());
  }

  do_print("Ensure that we cannot open databases anymore");
  let exn;
  try {
    await getDummyDatabase("opened after shutdown");
  } catch (ex) {
    exn = ex;
  }
  do_check_true(!!exn);
  do_check_true(exn.message.indexOf("Sqlite.jsm has been shutdown") != -1);
});
