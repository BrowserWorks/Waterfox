/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */
/* eslint-disable no-shadow */

"use strict";

/**
 * Verify that a frame actor is properly expired when the frame goes away.
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
  gThreadClient.addOneTimeListener("paused", function (event, packet1) {
    gThreadClient.addOneTimeListener("paused", function (event, packet2) {
      let poppedFrames = packet2.poppedFrames;
      do_check_eq(typeof (poppedFrames), typeof ([]));
      do_check_true(poppedFrames.indexOf(packet1.frame.actor) >= 0);
      gThreadClient.resume(function () {
        finishClient(gClient);
      });
    });
    gThreadClient.resume();
  });

  gDebuggee.eval("(" + function () {
    function stopMe() {
      debugger;
    }
    stopMe();
    debugger;
  } + ")()");
}
