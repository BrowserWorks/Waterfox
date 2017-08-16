/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */
/* eslint-disable no-shadow, max-nested-callbacks */

"use strict";

/**
 * Make sure that stepping in the last statement of the last frame doesn't
 * cause an unexpected pause, when another JS frame is pushed on the stack
 * (bug 785689).
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
                             test_stepping_last();
                           });
  });
}

function test_stepping_last() {
  gThreadClient.addOneTimeListener("paused", function (event, packet) {
    gThreadClient.addOneTimeListener("paused", function (event, packet) {
      // Check the return value.
      do_check_eq(packet.type, "paused");
      do_check_eq(packet.frame.where.line, gDebuggee.line0 + 2);
      do_check_eq(packet.why.type, "resumeLimit");
      // Check that stepping worked.
      do_check_eq(gDebuggee.a, undefined);
      do_check_eq(gDebuggee.b, undefined);

      gThreadClient.addOneTimeListener("paused", function (event, packet) {
        // Check the return value.
        do_check_eq(packet.type, "paused");
        do_check_eq(packet.frame.where.line, gDebuggee.line0 + 3);
        do_check_eq(packet.why.type, "resumeLimit");
        // Check that stepping worked.
        do_check_eq(gDebuggee.a, 1);
        do_check_eq(gDebuggee.b, undefined);

        gThreadClient.addOneTimeListener("paused", function (event, packet) {
          // Check the return value.
          do_check_eq(packet.type, "paused");
          // When leaving a stack frame the line number doesn't change.
          do_check_eq(packet.frame.where.line, gDebuggee.line0 + 3);
          do_check_eq(packet.why.type, "resumeLimit");
          // Check that stepping worked.
          do_check_eq(gDebuggee.a, 1);
          do_check_eq(gDebuggee.b, 2);

          gThreadClient.stepIn(function () {
            test_next_pause();
          });
        });
        gThreadClient.stepIn();
      });
      gThreadClient.stepIn();
    });
    gThreadClient.stepIn();
  });

  /* eslint-disable */
  gDebuggee.eval("var line0 = Error().lineNumber;\n" +
                 "debugger;\n" +   // line0 + 1
                 "var a = 1;\n" +  // line0 + 2
                 "var b = 2;\n");  // line0 + 3
  /* eslint-enable */
}

function test_next_pause() {
  gThreadClient.addOneTimeListener("paused", function (event, packet) {
    // Check the return value.
    do_check_eq(packet.type, "paused");
    // Before fixing bug 785689, the type was resumeLimit.
    do_check_eq(packet.why.type, "debuggerStatement");

    gThreadClient.resume(function () {
      gClient.close().then(gCallback);
    });
  });

  gDebuggee.eval("debugger;");
}
