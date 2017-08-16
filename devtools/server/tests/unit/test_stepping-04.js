/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */
/* eslint-disable no-shadow, max-nested-callbacks */

"use strict";

/**
 * Check that stepping over a function call does not pause inside the function.
 */

var gDebuggee;
var gClient;
var gThreadClient;
var gCallback;

function run_test() {
  run_test_with_server(DebuggerServer, function () {
    run_test_with_server(WorkerDebuggerServer, do_test_finished);
  });
  do_test_pending();
}

function run_test_with_server(server, callback) {
  gCallback = callback;
  initTestDebuggerServer(server);
  gDebuggee = addTestGlobal("test-stack", server);
  gClient = new DebuggerClient(server.connectPipe());
  gClient.connect().then(function () {
    attachTestTabAndResume(gClient, "test-stack",
                           function (response, tabClient, threadClient) {
                             gThreadClient = threadClient;
                             test_simple_stepping();
                           });
  });
}

function test_simple_stepping() {
  gThreadClient.addOneTimeListener("paused", function (event, packet) {
    gThreadClient.addOneTimeListener("paused", function (event, packet) {
      // Check the return value.
      do_check_eq(packet.type, "paused");
      do_check_eq(packet.frame.where.line, gDebuggee.line0 + 5);
      do_check_eq(packet.why.type, "resumeLimit");
      // Check that stepping worked.
      do_check_eq(gDebuggee.a, undefined);
      do_check_eq(gDebuggee.b, undefined);

      gThreadClient.addOneTimeListener("paused", function (event, packet) {
        // Check the return value.
        do_check_eq(packet.type, "paused");
        do_check_eq(packet.frame.where.line, gDebuggee.line0 + 6);
        do_check_eq(packet.why.type, "resumeLimit");
        // Check that stepping worked.
        do_check_eq(gDebuggee.a, 1);
        do_check_eq(gDebuggee.b, undefined);

        gThreadClient.resume(function () {
          gClient.close().then(gCallback);
        });
      });
      gThreadClient.stepOver();
    });
    gThreadClient.stepOver();
  });

  /* eslint-disable */
  gDebuggee.eval("var line0 = Error().lineNumber;\n" +
                 "function f() {\n" + // line0 + 1
                 "  this.a = 1;\n" +  // line0 + 2
                 "}\n" +              // line0 + 3
                 "debugger;\n" +      // line0 + 4
                 "f();\n" +           // line0 + 5
                 "let b = 2;\n");     // line0 + 6
  /* eslint-enable */
}
