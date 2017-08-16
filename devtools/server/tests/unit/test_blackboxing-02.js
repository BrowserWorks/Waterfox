/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */
/* eslint-disable no-shadow */

"use strict";

/**
 * Test that we don't hit breakpoints in black boxed sources, and that when we
 * unblack box the source again, the breakpoint hasn't disappeared and we will
 * hit it again.
 */

var gDebuggee;
var gClient;
var gThreadClient;

function run_test() {
  initTestDebuggerServer();
  gDebuggee = addTestGlobal("test-black-box");
  gClient = new DebuggerClient(DebuggerServer.connectPipe());
  gClient.connect().then(function () {
    attachTestTabAndResume(gClient, "test-black-box",
                           function (response, tabClient, threadClient) {
                             gThreadClient = threadClient;
                             test_black_box();
                           });
  });
  do_test_pending();
}

const BLACK_BOXED_URL = "http://example.com/blackboxme.js";
const SOURCE_URL = "http://example.com/source.js";

function test_black_box() {
  gClient.addOneTimeListener("paused", function (event, packet) {
    gThreadClient.eval(packet.frame.actor, "doStuff", function (response) {
      gThreadClient.addOneTimeListener("paused", function (event, packet) {
        let obj = gThreadClient.pauseGrip(packet.why.frameFinished.return);
        obj.getDefinitionSite(runWithSource);
      });
    });

    function runWithSource(packet) {
      let source = gThreadClient.source(packet.source);
      source.setBreakpoint({
        line: 2
      }, function (response) {
        do_check_true(!response.error, "Should be able to set breakpoint.");
        gThreadClient.resume(test_black_box_breakpoint);
      });
    }
  });

  /* eslint-disable */
  Components.utils.evalInSandbox(
    "" + function doStuff(k) { // line 1
      let arg = 15;            // line 2 - Break here
      k(arg);                  // line 3
    },                         // line 4
    gDebuggee,
    "1.8",
    BLACK_BOXED_URL,
    1
  );

  Components.utils.evalInSandbox(
    "" + function runTest() { // line 1
      doStuff(                // line 2
        function (n) {        // line 3
          debugger;           // line 5
        }                     // line 6
      );                      // line 7
    }                         // line 8
    + "\n debugger;",         // line 9
    gDebuggee,
    "1.8",
    SOURCE_URL,
    1
  );
  /* eslint-enable */
}

function test_black_box_breakpoint() {
  gThreadClient.getSources(function ({error, sources}) {
    do_check_true(!error, "Should not get an error: " + error);
    let sourceClient = gThreadClient.source(
      sources.filter(s => s.url == BLACK_BOXED_URL)[0]
    );
    sourceClient.blackBox(function ({error}) {
      do_check_true(!error, "Should not get an error: " + error);

      gClient.addOneTimeListener("paused", function (event, packet) {
        do_check_eq(
          packet.why.type, "debuggerStatement",
          "We should pass over the breakpoint since the source is black boxed.");
        gThreadClient.resume(test_unblack_box_breakpoint.bind(null, sourceClient));
      });
      gDebuggee.runTest();
    });
  });
}

function test_unblack_box_breakpoint(sourceClient) {
  sourceClient.unblackBox(function ({error}) {
    do_check_true(!error, "Should not get an error: " + error);
    gClient.addOneTimeListener("paused", function (event, packet) {
      do_check_eq(packet.why.type, "breakpoint",
                  "We should hit the breakpoint again");

      // We will hit the debugger statement on resume, so do this
      // nastiness to skip over it.
      gClient.addOneTimeListener(
        "paused",
        gThreadClient.resume.bind(
          gThreadClient,
          finishClient.bind(null, gClient)));
      gThreadClient.resume();
    });
    gDebuggee.runTest();
  });
}
