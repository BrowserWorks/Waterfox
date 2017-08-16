/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

Components.utils.import("resource://gre/modules/Promise.jsm");

var WORKER_SOURCE_URI = "chrome://test_lz4/content/worker_lz4.js";
do_load_manifest("data/chrome.manifest");

function run_test() {
  run_next_test();
}


add_task(function() {
  let worker = new ChromeWorker(WORKER_SOURCE_URI);
  return new Promise((resolve, reject) => {
    worker.onmessage = function(event) {
      let data = event.data;
      switch (data.kind) {
        case "do_check_true":
          try {
            do_check_true(data.args[0]);
          } catch (ex) {
            // Ignore errors
          }
          return;
        case "do_test_complete":
          resolve();
          worker.terminate();
          break;
        case "do_print":
          do_print(data.args[0]);
      }
    };
    worker.onerror = function(event) {
      let error = new Error(event.message, event.filename, event.lineno);
      worker.terminate();
      reject(error);
    };
    worker.postMessage("START");
  });
});

