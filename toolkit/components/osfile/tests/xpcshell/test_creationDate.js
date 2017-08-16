"use strict";

function run_test() {
  do_test_pending();
  run_next_test();
}

/**
 * Test to ensure that deprecation warning is issued on use
 * of creationDate.
 */
add_task(async function test_deprecatedCreationDate () {
  let deferred = Promise.defer();
  let consoleListener = {
    observe: function (aMessage) {
      if(aMessage.message.indexOf("Field 'creationDate' is deprecated.") > -1) {
        do_print("Deprecation message printed");
        do_check_true(true);
        Services.console.unregisterListener(consoleListener);
        deferred.resolve();
      }
    }
  };
  let currentDir = await OS.File.getCurrentDirectory();
  let path = OS.Path.join(currentDir, "test_creationDate.js");

  Services.console.registerListener(consoleListener);
  (await OS.File.stat(path)).creationDate;
});

add_task(do_test_finished);
