/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */
/* eslint-disable no-shadow, max-nested-callbacks */

"use strict";

/**
 * Check syntax errors in an eval.
 */

var gDebuggee;
var gClient;
var gThreadClient;

function run_test() {
  initTestDebuggerServer();
  gDebuggee = addTestGlobal("test-stack");
  gClient = new DebuggerClient(DebuggerServer.connectPipe());
  gClient.connect().then().then(function () {
    attachTestTabAndResume(gClient, "test-stack",
                           function (response, tabClient, threadClient) {
                             gThreadClient = threadClient;
                             test_syntax_error_eval();
                           });
  });
  do_test_pending();
}

function test_syntax_error_eval() {
  gThreadClient.addOneTimeListener("paused", function (event, packet) {
    gThreadClient.eval(null, "%$@!@#", function (response) {
      do_check_eq(response.type, "resumed");
      // Expect a pause notification immediately.
      gThreadClient.addOneTimeListener("paused", function (event, packet) {
        // Check the return value...
        do_check_eq(packet.type, "paused");
        do_check_eq(packet.why.type, "clientEvaluated");
        do_check_eq(packet.why.frameFinished.throw.type, "object");
        do_check_eq(packet.why.frameFinished.throw.class, "Error");

        gThreadClient.resume(function () {
          finishClient(gClient);
        });
      });
    });
  });

  /* eslint-disable */
  gDebuggee.eval("(" + function () {
    function stopMe(arg1) { debugger; }
    stopMe({obj: true});
  } + ")()");
  /* eslint-enable */
}
