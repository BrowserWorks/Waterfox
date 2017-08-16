/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */
/* eslint-disable no-shadow, max-nested-callbacks */

"use strict";

/**
 * Check that removing a breakpoint works.
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
                             test_remove_breakpoint();
                           });
  });
}

function test_remove_breakpoint() {
  let done = false;
  gThreadClient.addOneTimeListener("paused", function (event, packet) {
    let source = gThreadClient.source(packet.frame.where.source);
    let location = { line: gDebuggee.line0 + 2 };

    source.setBreakpoint(location, function (response, bpClient) {
      gThreadClient.addOneTimeListener("paused", function (event, packet) {
        // Check the return value.
        do_check_eq(packet.type, "paused");
        do_check_eq(packet.frame.where.source.actor, source.actor);
        do_check_eq(packet.frame.where.line, location.line);
        do_check_eq(packet.why.type, "breakpoint");
        do_check_eq(packet.why.actors[0], bpClient.actor);
        // Check that the breakpoint worked.
        do_check_eq(gDebuggee.a, undefined);

        // Remove the breakpoint.
        bpClient.remove(function (response) {
          done = true;
          gThreadClient.addOneTimeListener("paused",
                                           function (event, packet) {
            // The breakpoint should not be hit again.
                                             gThreadClient.resume(function () {
                                               do_check_true(false);
                                             });
                                           });
          gThreadClient.resume();
        });
      });
      // Continue until the breakpoint is hit.
      gThreadClient.resume();
    });
  });

  /* eslint-disable */
  Cu.evalInSandbox("var line0 = Error().lineNumber;\n" +
                   "function foo(stop) {\n" + // line0 + 1
                   "  this.a = 1;\n" +        // line0 + 2
                   "  if (stop) return;\n" +  // line0 + 3
                   "  delete this.a;\n" +     // line0 + 4
                   "  foo(true);\n" +         // line0 + 5
                   "}\n" +                    // line0 + 6
                   "debugger;\n" +            // line1 + 7
                   "foo();\n",                // line1 + 8
                   gDebuggee);
  /* eslint-enable */
  if (!done) {
    do_check_true(false);
  }
  gClient.close().then(gCallback);
}
