/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */
/* eslint-disable no-shadow, max-nested-callbacks */

"use strict";

/**
 * Check that we can set breakpoints in columns, not just lines.
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
  gDebuggee = addTestGlobal("test-breakpoints", server);
  gClient = new DebuggerClient(server.connectPipe());
  gClient.connect().then(function () {
    attachTestTabAndResume(gClient,
                           "test-breakpoints",
                           function (response, tabClient, threadClient) {
                             gThreadClient = threadClient;
                             test_column_breakpoint();
                           });
  });
}

function test_column_breakpoint() {
  // Debugger statement
  gClient.addOneTimeListener("paused", function (event, packet) {
    let source = gThreadClient.source(packet.frame.where.source);
    let location = {
      line: gDebuggee.line0 + 1,
      column: 55
    };
    let timesBreakpointHit = 0;

    source.setBreakpoint(location, function (response, bpClient) {
      gThreadClient.addListener("paused", function onPaused(event, packet) {
        do_check_eq(packet.type, "paused");
        do_check_eq(packet.why.type, "breakpoint");
        do_check_eq(packet.why.actors[0], bpClient.actor);
        do_check_eq(packet.frame.where.source.actor, source.actor);
        do_check_eq(packet.frame.where.line, location.line);
        do_check_eq(packet.frame.where.column, location.column);

        do_check_eq(gDebuggee.acc, timesBreakpointHit);
        do_check_eq(packet.frame.environment.bindings.variables.i.value,
                    timesBreakpointHit);

        if (++timesBreakpointHit === 3) {
          gThreadClient.removeListener("paused", onPaused);
          bpClient.remove(function (response) {
            gThreadClient.resume(() => gClient.close().then(gCallback));
          });
        } else {
          gThreadClient.resume();
        }
      });

      // Continue until the breakpoint is hit.
      gThreadClient.resume();
    });
  });

  /* eslint-disable */
  Components.utils.evalInSandbox(
    "var line0 = Error().lineNumber;\n" +
    "(function () { debugger; this.acc = 0; for (var i = 0; i < 3; i++) this.acc++; }());",
    gDebuggee
  );
  /* eslint-enable */
}
