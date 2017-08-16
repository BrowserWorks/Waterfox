/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */
/* eslint-disable no-shadow, max-nested-callbacks */

"use strict";

/**
 * Check that setting a breakpoint in a line without code in the second child
 * script will skip forward.
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
                             test_second_child_skip_breakpoint();
                           });
  });
}

function test_second_child_skip_breakpoint() {
  gThreadClient.addOneTimeListener("paused", function (event, packet) {
    let source = gThreadClient.source(packet.frame.where.source);
    let location = { line: gDebuggee.line0 + 6 };

    source.setBreakpoint(location, function (response, bpClient) {
      // Check that the breakpoint has properly skipped forward one line.
      do_check_eq(response.actualLocation.source.actor, source.actor);
      do_check_eq(response.actualLocation.line, location.line + 1);

      gThreadClient.addOneTimeListener("paused", function (event, packet) {
        // Check the return value.
        do_check_eq(packet.type, "paused");
        do_check_eq(packet.frame.where.source.actor, source.actor);
        do_check_eq(packet.frame.where.line, location.line + 1);
        do_check_eq(packet.why.type, "breakpoint");
        do_check_eq(packet.why.actors[0], bpClient.actor);
        // Check that the breakpoint worked.
        do_check_eq(gDebuggee.a, 1);
        do_check_eq(gDebuggee.b, undefined);

        // Remove the breakpoint.
        bpClient.remove(function (response) {
          gThreadClient.resume(function () {
            gClient.close().then(gCallback);
          });
        });
      });

      // Continue until the breakpoint is hit.
      gThreadClient.resume();
    });
  });

  /* eslint-disable */
  Cu.evalInSandbox(
    "var line0 = Error().lineNumber;\n" +
    "function foo() {\n" + // line0 + 1
    "  bar();\n" +         // line0 + 2
    "}\n" +                // line0 + 3
    "function bar() {\n" + // line0 + 4
    "  this.a = 1;\n" +    // line0 + 5
    "  // A comment.\n" +  // line0 + 6
    "  this.b = 2;\n" +    // line0 + 7
    "}\n" +                // line0 + 8
    "debugger;\n" +        // line0 + 9
    "foo();\n",           // line0 + 10
    gDebuggee
  );
  /* eslint-enable */
}
