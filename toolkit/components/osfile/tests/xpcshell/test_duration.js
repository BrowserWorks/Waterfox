var {OS} = Components.utils.import("resource://gre/modules/osfile.jsm", {});
var {Services} = Components.utils.import("resource://gre/modules/Services.jsm", {});

/**
 * Test optional duration reporting that can be used for telemetry.
 */
add_task(async function duration() {
  const availableDurations = ["outSerializationDuration", "outExecutionDuration"];
  Services.prefs.setBoolPref("toolkit.osfile.log", true);
  // Options structure passed to a OS.File copy method.
  let copyOptions = {
    // These fields should be overwritten with the actual duration
    // measurements.
    outSerializationDuration: null,
    outExecutionDuration: null
  };
  let currentDir = await OS.File.getCurrentDirectory();
  let pathSource = OS.Path.join(currentDir, "test_duration.js");
  let copyFile = pathSource + ".bak";
  function testOptions(options, name, durations = availableDurations) {
    for (let duration of durations) {
      do_print(`Checking ${duration} for operation: ${name}`);
      do_print(`${name}: Gathered method duration time: ${options[duration]} ms`);
      // Making sure that duration was updated.
      do_check_eq(typeof options[duration], "number");
      do_check_true(options[duration] >= 0);
    }
  }

  function testOptionIncrements(options, name, backupDuration, durations = availableDurations) {
    for (let duration of durations) {
      do_print(`Checking ${duration} increment for operation: ${name}`);
      do_print(`${name}: Gathered method duration time: ${options[duration]} ms`);
      do_print(`${name}: Previous duration: ${backupDuration[duration]} ms`);
      // Making sure that duration was incremented.
      do_check_true(options[duration] >= backupDuration[duration]);
    }
  }

  // Testing duration of OS.File.copy.
  await OS.File.copy(pathSource, copyFile, copyOptions);
  testOptions(copyOptions, "OS.File.copy");
  await OS.File.remove(copyFile);

  // Trying an operation where options are cloned.
  let pathDest = OS.Path.join(OS.Constants.Path.tmpDir,
    "osfile async test read writeAtomic.tmp");
  let tmpPath = pathDest + ".tmp";
  let readOptions = {
    // We do not check for |outSerializationDuration| since |Scheduler.post|
    // may not be called whenever |read| is called.
    outExecutionDuration: null
  };
  let contents = await OS.File.read(pathSource, undefined, readOptions);
  testOptions(readOptions, "OS.File.read", ["outExecutionDuration"]);
  // Options structure passed to a OS.File writeAtomic method.
  let writeAtomicOptions = {
    // This field should be first initialized with the actual
    // duration measurement then progressively incremented.
    outSerializationDuration: null,
    outExecutionDuration: null,
    tmpPath: tmpPath
  };
  await OS.File.writeAtomic(pathDest, contents, writeAtomicOptions);
  testOptions(writeAtomicOptions, "OS.File.writeAtomic");
  await OS.File.remove(pathDest);

  do_print(`Ensuring that we can use ${availableDurations.join(", ")} to accumulate durations`);

  let ARBITRARY_BASE_DURATION = 5;
  copyOptions = {
    // This field should now be incremented with the actual duration
    // measurement.
    outSerializationDuration: ARBITRARY_BASE_DURATION,
    outExecutionDuration: ARBITRARY_BASE_DURATION
  };

  // We need to copy the object, since having a reference would make this pointless.
  let backupDuration = Object.assign({}, copyOptions);

  // Testing duration of OS.File.copy.
  await OS.File.copy(pathSource, copyFile, copyOptions);
  testOptionIncrements(copyOptions, "copy", backupDuration);

  backupDuration = Object.assign({}, copyOptions);
  await OS.File.remove(copyFile, copyOptions);
  testOptionIncrements(copyOptions, "remove", backupDuration);

  // Trying an operation where options are cloned.
  // Options structure passed to a OS.File writeAtomic method.
  writeAtomicOptions = copyOptions;
  writeAtomicOptions.tmpPath = tmpPath;
  backupDuration = Object.assign({}, copyOptions);
  await OS.File.writeAtomic(pathDest, contents, writeAtomicOptions);
  testOptionIncrements(writeAtomicOptions, "writeAtomicOptions", backupDuration);
  OS.File.remove(pathDest);

  // Testing an operation that doesn't take arguments at all
  let file = await OS.File.open(pathSource);
  await file.stat();
  await file.close();
});

function run_test() {
  run_next_test();
}
