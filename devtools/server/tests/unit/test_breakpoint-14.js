/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */
/* eslint-disable no-shadow */

"use strict";

/**
 * Check that a breakpoint or a debugger statement cause execution to pause even
 * in a stepped-over function.
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
                             test_simple_breakpoint();
                           });
  });
}

function test_simple_breakpoint() {
  gThreadClient.addOneTimeListener("paused", function (event, packet) {
    let source = gThreadClient.source(packet.frame.where.source);
    let location = { line: gDebuggee.line0 + 2 };

    source.setBreakpoint(location, Task.async(function* (response, bpClient) {
      const testCallbacks = [
        function (packet) {
          // Check that the stepping worked.
          do_check_eq(packet.frame.where.line, gDebuggee.line0 + 5);
          do_check_eq(packet.why.type, "resumeLimit");
        },
        function (packet) {
          // Reached the breakpoint.
          do_check_eq(packet.frame.where.line, location.line);
          do_check_eq(packet.why.type, "breakpoint");
          do_check_neq(packet.why.type, "resumeLimit");
        },
        function (packet) {
          // Stepped to the closing brace of the function.
          do_check_eq(packet.frame.where.line, gDebuggee.line0 + 3);
          do_check_eq(packet.why.type, "resumeLimit");
        },
        function (packet) {
          // The frame is about to be popped while stepping.
          do_check_eq(packet.frame.where.line, gDebuggee.line0 + 3);
          do_check_neq(packet.why.type, "breakpoint");
          do_check_eq(packet.why.type, "resumeLimit");
          do_check_eq(packet.why.frameFinished.return.type, "undefined");
        },
        function (packet) {
          // The foo function call frame was just popped from the stack.
          do_check_eq(gDebuggee.a, 1);
          do_check_eq(gDebuggee.b, undefined);
          do_check_eq(packet.frame.where.line, gDebuggee.line0 + 5);
          do_check_eq(packet.why.type, "resumeLimit");
          do_check_eq(packet.poppedFrames.length, 1);
        },
        function (packet) {
          // Check that the debugger statement wasn't the reason for this pause.
          do_check_eq(packet.frame.where.line, gDebuggee.line0 + 6);
          do_check_neq(packet.why.type, "debuggerStatement");
          do_check_eq(packet.why.type, "resumeLimit");
        },
        function (packet) {
          // Check that the debugger statement wasn't the reason for this pause.
          do_check_eq(packet.frame.where.line, gDebuggee.line0 + 7);
          do_check_neq(packet.why.type, "debuggerStatement");
          do_check_eq(packet.why.type, "resumeLimit");
        },
      ];

      for (let callback of testCallbacks) {
        let waiter = waitForPause(gThreadClient);
        gThreadClient.stepOver();
        let packet = yield waiter;
        callback(packet);
      }

      // Remove the breakpoint and finish.
      let waiter = waitForPause(gThreadClient);
      gThreadClient.stepOver();
      yield waiter;
      bpClient.remove(() => gThreadClient.resume(() => gClient.close().then(gCallback)));
    }));
  });

  /* eslint-disable */
  Cu.evalInSandbox("var line0 = Error().lineNumber;\n" +
                   "function foo() {\n" + // line0 + 1
                   "  this.a = 1;\n" +    // line0 + 2 <-- Breakpoint is set here.
                   "}\n" +                // line0 + 3
                   "debugger;\n" +        // line0 + 4
                   "foo();\n" +           // line0 + 5
                   "debugger;\n" +        // line0 + 6
                   "var b = 2;\n",        // line0 + 7
                   gDebuggee);
  /* eslint-enable */
}
