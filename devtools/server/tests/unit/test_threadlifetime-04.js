/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */
/* eslint-disable no-shadow, max-nested-callbacks */

"use strict";

/**
 * Check that requesting a thread-lifetime actor twice for the same
 * value returns the same actor.
 */

var gDebuggee;
var gClient;
var gThreadClient;

function run_test() {
  initTestDebuggerServer();
  gDebuggee = addTestGlobal("test-grips");
  gClient = new DebuggerClient(DebuggerServer.connectPipe());
  gClient.connect().then(function () {
    attachTestTabAndResume(gClient, "test-grips",
                           function (response, tabClient, threadClient) {
                             gThreadClient = threadClient;
                             test_thread_lifetime();
                           });
  });
  do_test_pending();
}

function test_thread_lifetime() {
  gThreadClient.addOneTimeListener("paused", function (event, packet) {
    let pauseGrip = packet.frame.arguments[0];

    gClient.request({ to: pauseGrip.actor, type: "threadGrip" }, function (response) {
      // Successful promotion won't return an error.
      do_check_eq(response.error, undefined);

      let threadGrip1 = response.from;

      gClient.request({ to: pauseGrip.actor, type: "threadGrip" }, function (response) {
        do_check_eq(threadGrip1, response.from);
        gThreadClient.resume(function () {
          finishClient(gClient);
        });
      });
    });
  });

  gDebuggee.eval("(" + function () {
    function stopMe(arg1) {
      debugger;
    }
    stopMe({obj: true});
  } + ")()");
}
