/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

/**
 * Check getSources functionality when there are lots of sources.
 */

var gDebuggee;
var gClient;
var gThreadClient;

function run_test() {
  initTestDebuggerServer();
  gDebuggee = addTestGlobal("test-sources");
  gClient = new DebuggerClient(DebuggerServer.connectPipe());
  gClient.connect().then(function () {
    attachTestTabAndResume(gClient, "test-sources",
                           function (response, tabClient, threadClient) {
                             gThreadClient = threadClient;
                             test_simple_listsources();
                           });
  });
  do_test_pending();
}

function test_simple_listsources() {
  gThreadClient.addOneTimeListener("paused", function (event, packet) {
    gThreadClient.getSources(function (response) {
      do_check_true(
        !response.error,
        "There shouldn't be an error fetching large amounts of sources.");

      do_check_true(response.sources.some(function (s) {
        return s.url.match(/foo-999.js$/);
      }));

      gThreadClient.resume(function () {
        finishClient(gClient);
      });
    });
  });

  for (let i = 0; i < 1000; i++) {
    Cu.evalInSandbox("function foo###() {return ###;}".replace(/###/g, i),
                     gDebuggee,
                     "1.8",
                     "http://example.com/foo-" + i + ".js",
                     1);
  }
  gDebuggee.eval("debugger;");
}
