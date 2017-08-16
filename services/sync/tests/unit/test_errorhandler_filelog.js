/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

Cu.import("resource://gre/modules/Log.jsm");
Cu.import("resource://services-common/utils.js");
Cu.import("resource://services-sync/service.js");
Cu.import("resource://services-sync/util.js");
Cu.import("resource://gre/modules/FileUtils.jsm");
Cu.import("resource://gre/modules/NetUtil.jsm");
Cu.import("resource://gre/modules/Services.jsm");

const logsdir            = FileUtils.getDir("ProfD", ["weave", "logs"], true);

// Delay to wait before cleanup, to allow files to age.
// This is so large because the file timestamp granularity is per-second, and
// so otherwise we can end up with all of our files -- the ones we want to
// keep, and the ones we want to clean up -- having the same modified time.
const CLEANUP_DELAY      = 2000;
const DELAY_BUFFER       = 500;  // Buffer for timers on different OS platforms.

const PROLONGED_ERROR_DURATION =
  (Svc.Prefs.get("errorhandler.networkFailureReportTimeout") * 2) * 1000;

var errorHandler = Service.errorHandler;

function setLastSync(lastSyncValue) {
  Svc.Prefs.set("lastSync", (new Date(Date.now() - lastSyncValue)).toString());
}

function run_test() {
  initTestLogging("Trace");

  Log.repository.getLogger("Sync.LogManager").level = Log.Level.Trace;
  Log.repository.getLogger("Sync.Service").level = Log.Level.Trace;
  Log.repository.getLogger("Sync.SyncScheduler").level = Log.Level.Trace;
  Log.repository.getLogger("Sync.ErrorHandler").level = Log.Level.Trace;

  validate_all_future_pings();

  run_next_test();
}

add_test(function test_noOutput() {
  // Ensure that the log appender won't print anything.
  errorHandler._logManager._fileAppender.level = Log.Level.Fatal + 1;

  // Clear log output from startup.
  Svc.Prefs.set("log.appender.file.logOnSuccess", false);
  Svc.Obs.notify("weave:service:sync:finish");
  Svc.Obs.add("weave:service:reset-file-log", function onResetFileLogOuter() {
    Svc.Obs.remove("weave:service:reset-file-log", onResetFileLogOuter);
    // Clear again without having issued any output.
    Svc.Prefs.set("log.appender.file.logOnSuccess", true);

    Svc.Obs.add("weave:service:reset-file-log", function onResetFileLogInner() {
      Svc.Obs.remove("weave:service:reset-file-log", onResetFileLogInner);

      errorHandler._logManager._fileAppender.level = Log.Level.Trace;
      Svc.Prefs.resetBranch("");
      run_next_test();
    });

    // Fake a successful sync.
    Svc.Obs.notify("weave:service:sync:finish");
  });
});

add_test(function test_logOnSuccess_false() {
  Svc.Prefs.set("log.appender.file.logOnSuccess", false);

  let log = Log.repository.getLogger("Sync.Test.FileLog");
  log.info("this won't show up");

  Svc.Obs.add("weave:service:reset-file-log", function onResetFileLog() {
    Svc.Obs.remove("weave:service:reset-file-log", onResetFileLog);
    // No log file was written.
    do_check_false(logsdir.directoryEntries.hasMoreElements());

    Svc.Prefs.resetBranch("");
    run_next_test();
  });

  // Fake a successful sync.
  Svc.Obs.notify("weave:service:sync:finish");
});

function readFile(file, callback) {
  NetUtil.asyncFetch({
    uri: NetUtil.newURI(file),
    loadUsingSystemPrincipal: true
  }, function(inputStream, statusCode, request) {
    let data = NetUtil.readInputStreamToString(inputStream,
                                               inputStream.available());
    callback(statusCode, data);
  });
}

add_test(function test_logOnSuccess_true() {
  Svc.Prefs.set("log.appender.file.logOnSuccess", true);

  let log = Log.repository.getLogger("Sync.Test.FileLog");
  const MESSAGE = "this WILL show up";
  log.info(MESSAGE);

  Svc.Obs.add("weave:service:reset-file-log", function onResetFileLog() {
    Svc.Obs.remove("weave:service:reset-file-log", onResetFileLog);

    // Exactly one log file was written.
    let entries = logsdir.directoryEntries;
    do_check_true(entries.hasMoreElements());
    let logfile = entries.getNext().QueryInterface(Ci.nsILocalFile);
    do_check_eq(logfile.leafName.slice(-4), ".txt");
    do_check_true(logfile.leafName.startsWith("success-sync-"), logfile.leafName);
    do_check_false(entries.hasMoreElements());

    // Ensure the log message was actually written to file.
    readFile(logfile, function(error, data) {
      do_check_true(Components.isSuccessCode(error));
      do_check_neq(data.indexOf(MESSAGE), -1);

      // Clean up.
      try {
        logfile.remove(false);
      } catch (ex) {
        dump("Couldn't delete file: " + ex + "\n");
        // Stupid Windows box.
      }

      Svc.Prefs.resetBranch("");
      run_next_test();
    });
  });

  // Fake a successful sync.
  Svc.Obs.notify("weave:service:sync:finish");
});

add_test(function test_sync_error_logOnError_false() {
  Svc.Prefs.set("log.appender.file.logOnError", false);

  let log = Log.repository.getLogger("Sync.Test.FileLog");
  log.info("this won't show up");

  Svc.Obs.add("weave:service:reset-file-log", function onResetFileLog() {
    Svc.Obs.remove("weave:service:reset-file-log", onResetFileLog);
    // No log file was written.
    do_check_false(logsdir.directoryEntries.hasMoreElements());

    Svc.Prefs.resetBranch("");
    run_next_test();
  });

  // Fake an unsuccessful sync due to prolonged failure.
  setLastSync(PROLONGED_ERROR_DURATION);
  Svc.Obs.notify("weave:service:sync:error");
});

add_test(function test_sync_error_logOnError_true() {
  Svc.Prefs.set("log.appender.file.logOnError", true);

  let log = Log.repository.getLogger("Sync.Test.FileLog");
  const MESSAGE = "this WILL show up";
  log.info(MESSAGE);

  // We need to wait until the log cleanup started by this test is complete
  // or the next test will fail as it is ongoing.
  Svc.Obs.add("services-tests:common:log-manager:cleanup-logs", function onCleanupLogs() {
    Svc.Obs.remove("services-tests:common:log-manager:cleanup-logs", onCleanupLogs);
    run_next_test();
  });

  Svc.Obs.add("weave:service:reset-file-log", function onResetFileLog() {
    Svc.Obs.remove("weave:service:reset-file-log", onResetFileLog);

    // Exactly one log file was written.
    let entries = logsdir.directoryEntries;
    do_check_true(entries.hasMoreElements());
    let logfile = entries.getNext().QueryInterface(Ci.nsILocalFile);
    do_check_eq(logfile.leafName.slice(-4), ".txt");
    do_check_true(logfile.leafName.startsWith("error-sync-"), logfile.leafName);
    do_check_false(entries.hasMoreElements());

    // Ensure the log message was actually written to file.
    readFile(logfile, function(error, data) {
      do_check_true(Components.isSuccessCode(error));
      do_check_neq(data.indexOf(MESSAGE), -1);

      // Clean up.
      try {
        logfile.remove(false);
      } catch (ex) {
        dump("Couldn't delete file: " + ex + "\n");
        // Stupid Windows box.
      }

      Svc.Prefs.resetBranch("");
    });
  });

  // Fake an unsuccessful sync due to prolonged failure.
  setLastSync(PROLONGED_ERROR_DURATION);
  Svc.Obs.notify("weave:service:sync:error");
});

add_test(function test_login_error_logOnError_false() {
  Svc.Prefs.set("log.appender.file.logOnError", false);

  let log = Log.repository.getLogger("Sync.Test.FileLog");
  log.info("this won't show up");

  Svc.Obs.add("weave:service:reset-file-log", function onResetFileLog() {
    Svc.Obs.remove("weave:service:reset-file-log", onResetFileLog);
    // No log file was written.
    do_check_false(logsdir.directoryEntries.hasMoreElements());

    Svc.Prefs.resetBranch("");
    run_next_test();
  });

  // Fake an unsuccessful login due to prolonged failure.
  setLastSync(PROLONGED_ERROR_DURATION);
  Svc.Obs.notify("weave:service:login:error");
});

add_test(function test_login_error_logOnError_true() {
  Svc.Prefs.set("log.appender.file.logOnError", true);

  let log = Log.repository.getLogger("Sync.Test.FileLog");
  const MESSAGE = "this WILL show up";
  log.info(MESSAGE);

  // We need to wait until the log cleanup started by this test is complete
  // or the next test will fail as it is ongoing.
  Svc.Obs.add("services-tests:common:log-manager:cleanup-logs", function onCleanupLogs() {
    Svc.Obs.remove("services-tests:common:log-manager:cleanup-logs", onCleanupLogs);
    run_next_test();
  });

  Svc.Obs.add("weave:service:reset-file-log", function onResetFileLog() {
    Svc.Obs.remove("weave:service:reset-file-log", onResetFileLog);

    // Exactly one log file was written.
    let entries = logsdir.directoryEntries;
    do_check_true(entries.hasMoreElements());
    let logfile = entries.getNext().QueryInterface(Ci.nsILocalFile);
    do_check_eq(logfile.leafName.slice(-4), ".txt");
    do_check_true(logfile.leafName.startsWith("error-sync-"), logfile.leafName);
    do_check_false(entries.hasMoreElements());

    // Ensure the log message was actually written to file.
    readFile(logfile, function(error, data) {
      do_check_true(Components.isSuccessCode(error));
      do_check_neq(data.indexOf(MESSAGE), -1);

      // Clean up.
      try {
        logfile.remove(false);
      } catch (ex) {
        dump("Couldn't delete file: " + ex + "\n");
        // Stupid Windows box.
      }

      Svc.Prefs.resetBranch("");
    });
  });

  // Fake an unsuccessful login due to prolonged failure.
  setLastSync(PROLONGED_ERROR_DURATION);
  Svc.Obs.notify("weave:service:login:error");
});

add_test(function test_noNewFailed_noErrorLog() {
  Svc.Prefs.set("log.appender.file.logOnError", true);
  Svc.Prefs.set("log.appender.file.logOnSuccess", false);

  Svc.Obs.add("weave:service:reset-file-log", function onResetFileLog() {
    Svc.Obs.remove("weave:service:reset-file-log", onResetFileLog);
    // No log file was written.
    do_check_false(logsdir.directoryEntries.hasMoreElements());

    Svc.Prefs.resetBranch("");
    run_next_test();
  });
  // failed is nonzero and newFailed is zero -- shouldn't write a log.
  let count = {
    applied: 8,
    succeeded: 4,
    failed: 5,
    newFailed: 0,
    reconciled: 4,
  };
  Svc.Obs.notify("weave:engine:sync:applied", count, "foobar-engine");
  Svc.Obs.notify("weave:service:sync:finish");
});

add_test(function test_newFailed_errorLog() {
  Svc.Prefs.set("log.appender.file.logOnError", true);
  Svc.Prefs.set("log.appender.file.logOnSuccess", false);

  let log = Log.repository.getLogger("Sync.Test.FileLog");
  const MESSAGE = "this WILL show up 2";
  log.info(MESSAGE);

  // We need to wait until the log cleanup started by this test is complete
  // or the next test will fail as it is ongoing.
  Svc.Obs.add("services-tests:common:log-manager:cleanup-logs", function onCleanupLogs() {
    Svc.Obs.remove("services-tests:common:log-manager:cleanup-logs", onCleanupLogs);
    run_next_test();
  });

  Svc.Obs.add("weave:service:reset-file-log", function onResetFileLog() {
    Svc.Obs.remove("weave:service:reset-file-log", onResetFileLog);

    // Exactly one log file was written.
    let entries = logsdir.directoryEntries;
    do_check_true(entries.hasMoreElements());
    let logfile = entries.getNext().QueryInterface(Ci.nsILocalFile);
    do_check_eq(logfile.leafName.slice(-4), ".txt");
    do_check_true(logfile.leafName.startsWith("error-sync-"), logfile.leafName);
    do_check_false(entries.hasMoreElements());

    // Ensure the log message was actually written to file.
    readFile(logfile, function(error, data) {
      do_check_true(Components.isSuccessCode(error));
      do_check_neq(data.indexOf(MESSAGE), -1);

      // Clean up.
      try {
        logfile.remove(false);
      } catch (ex) {
        dump("Couldn't delete file: " + ex + "\n");
        // Stupid Windows box.
      }

      Svc.Prefs.resetBranch("");

    });
  });
  // newFailed is nonzero -- should write a log.
  let count = {
    applied: 8,
    succeeded: 4,
    failed: 5,
    newFailed: 4,
    reconciled: 4,
  };

  Svc.Obs.notify("weave:engine:sync:applied", count, "foobar-engine");
  Svc.Obs.notify("weave:service:sync:finish");
});

add_test(function test_errorLog_dumpAddons() {
  Svc.Prefs.set("log.appender.file.logOnError", true);

  // We need to wait until the log cleanup started by this test is complete
  // or the next test will fail as it is ongoing.
  Svc.Obs.add("services-tests:common:log-manager:cleanup-logs", function onCleanupLogs() {
    Svc.Obs.remove("services-tests:common:log-manager:cleanup-logs", onCleanupLogs);
    run_next_test();
  });

  Svc.Obs.add("weave:service:reset-file-log", function onResetFileLog() {
    Svc.Obs.remove("weave:service:reset-file-log", onResetFileLog);

    let entries = logsdir.directoryEntries;
    do_check_true(entries.hasMoreElements());
    let logfile = entries.getNext().QueryInterface(Ci.nsILocalFile);
    do_check_eq(logfile.leafName.slice(-4), ".txt");
    do_check_true(logfile.leafName.startsWith("error-sync-"), logfile.leafName);
    do_check_false(entries.hasMoreElements());

    // Ensure we logged some addon list (which is probably empty)
    readFile(logfile, function(error, data) {
      do_check_true(Components.isSuccessCode(error));
      do_check_neq(data.indexOf("Addons installed"), -1);

      // Clean up.
      try {
        logfile.remove(false);
      } catch (ex) {
        dump("Couldn't delete file: " + ex + "\n");
        // Stupid Windows box.
      }

      Svc.Prefs.resetBranch("");
    });
  });

  // Fake an unsuccessful sync due to prolonged failure.
  setLastSync(PROLONGED_ERROR_DURATION);
  Svc.Obs.notify("weave:service:sync:error");
});

// Check that error log files are deleted above an age threshold.
add_test(function test_logErrorCleanup_age() {
  _("Beginning test_logErrorCleanup_age.");
  let maxAge = CLEANUP_DELAY / 1000;
  let oldLogs = [];
  let numLogs = 10;
  let errString = "some error log\n";

  Svc.Prefs.set("log.appender.file.logOnError", true);
  Svc.Prefs.set("log.appender.file.maxErrorAge", maxAge);

  _("Making some files.");
  for (let i = 0; i < numLogs; i++) {
    let now = Date.now();
    let filename = "error-sync-" + now + "" + i + ".txt";
    let newLog = FileUtils.getFile("ProfD", ["weave", "logs", filename]);
    let foStream = FileUtils.openFileOutputStream(newLog);
    foStream.write(errString, errString.length);
    foStream.close();
    _("  > Created " + filename);
    oldLogs.push(newLog.leafName);
  }

  Svc.Obs.add("services-tests:common:log-manager:cleanup-logs", function onCleanupLogs() {
    Svc.Obs.remove("services-tests:common:log-manager:cleanup-logs", onCleanupLogs);

    // Only the newest created log file remains.
    let entries = logsdir.directoryEntries;
    do_check_true(entries.hasMoreElements());
    let logfile = entries.getNext().QueryInterface(Ci.nsILocalFile);
    do_check_true(oldLogs.every(function(e) {
      return e != logfile.leafName;
    }));
    do_check_false(entries.hasMoreElements());

    // Clean up.
    try {
      logfile.remove(false);
    } catch (ex) {
      dump("Couldn't delete file: " + ex + "\n");
      // Stupid Windows box.
    }

    Svc.Prefs.resetBranch("");
    run_next_test();
  });

  let delay = CLEANUP_DELAY + DELAY_BUFFER;

  _("Cleaning up logs after " + delay + "msec.");
  CommonUtils.namedTimer(function onTimer() {
    Svc.Obs.notify("weave:service:sync:error");
  }, delay, this, "cleanup-timer");
});
