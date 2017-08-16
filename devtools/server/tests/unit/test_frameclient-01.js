/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */
/* eslint-disable max-nested-callbacks */

"use strict";

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
    gThreadClient.addOneTimeListener("framesadded", function () {
      do_check_eq(gThreadClient.cachedFrames.length, 3);
      do_check_true(gThreadClient.moreFrames);
      do_check_false(gThreadClient.fillFrames(3));

      do_check_true(gThreadClient.fillFrames(30));
      gThreadClient.addOneTimeListener("framesadded", function () {
        do_check_false(gThreadClient.moreFrames);
        do_check_eq(gThreadClient.cachedFrames.length, 7);
        gThreadClient.resume(function () {
          finishClient(gClient);
        });
      });
    });
    do_check_true(gThreadClient.fillFrames(3));
  });

  /* eslint-disable */
  gDebuggee.eval("(" + function () {
    var recurseLeft = 5;
    function recurse() {
      if (--recurseLeft == 0) {
        debugger;
        return;
      }
      recurse();
    }
    recurse();
  } + ")()");
  /* eslint-enable */
}
