/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */
/* eslint-disable no-shadow */

"use strict";

/**
 * Test that setting pauseOnExceptions to true will cause the debuggee to pause
 * when an exceptions is thrown.
 */

var gDebuggee;
var gClient;
var gThreadClient;

function run_test() {
  initTestDebuggerServer();
  gDebuggee = addTestGlobal("test-stack");
  gClient = new DebuggerClient(DebuggerServer.connectPipe());
  gClient.connect().then(function () {
    attachTestTabAndResume(gClient, "test-stack",
                           function (response, tabClient, threadClient) {
                             gThreadClient = threadClient;
                             test_pause_frame();
                           });
  });
  do_test_pending();
}

function test_pause_frame() {
  gThreadClient.addOneTimeListener("paused", function (event, packet) {
    gThreadClient.addOneTimeListener("paused", function (event, packet) {
      do_check_eq(packet.why.type, "exception");
      do_check_eq(packet.why.exception, 42);
      gThreadClient.resume(function () {
        finishClient(gClient);
      });
    });
    gThreadClient.pauseOnExceptions(true);
    gThreadClient.resume();
  });

  /* eslint-disable */
  gDebuggee.eval("(" + function () {
    function stopMe() {
      debugger;
      throw 42;
    }
    try {
      stopMe();
    } catch (e) {}
  } + ")()");
  /* eslint-enable */
}
