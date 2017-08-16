/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */
/* eslint-disable no-shadow */

"use strict";

/**
 * Test behavior of blackboxing sources we are currently paused in.
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
        test_black_box_paused();
      });
    }
  });

  /* eslint-disable */
  Components.utils.evalInSandbox(
    "" + function doStuff(k) { // line 1
      debugger;                // line 2
      k(100);                  // line 3
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
          return n;           // line 4
        }                     // line 5
      );                      // line 6
    }                         // line 7
    + "\n runTest();",        // line 8
    gDebuggee,
    "1.8",
    SOURCE_URL,
    1
  );
  /* eslint-enable */
}

function test_black_box_paused() {
  gThreadClient.getSources(function ({error, sources}) {
    do_check_true(!error, "Should not get an error: " + error);
    let sourceClient = gThreadClient.source(
      sources.filter(s => s.url == BLACK_BOXED_URL)[0]
    );

    sourceClient.blackBox(function ({error, pausedInSource}) {
      do_check_true(!error, "Should not get an error: " + error);
      do_check_true(pausedInSource,
                    "We should be notified that we are currently paused in this source");
      finishClient(gClient);
    });
  });
}
