/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */
/* eslint-disable no-shadow */

"use strict";

/**
 * Test that setting pauseOnExceptions to true and then to false will not cause
 * the debuggee to pause when an exception is thrown.
 */

add_task(
  threadFrontTest(
    async ({ threadFront, client, debuggee }) => {
      let onResume = null;
      let packet = null;

      threadFront.once("paused", function(pkt) {
        packet = pkt;
        onResume = threadFront.resume();
      });

      await threadFront.pauseOnExceptions(true, true);
      try {
        /* eslint-disable */
    Cu.evalInSandbox(
      `                                   // 1
      function stopMe() {                 // 2
        throw 42;                         // 3
      }                                   // 4
      stopMe();                           // 5
      `,                                  // 6
      debuggee,
      "1.8",
      "test_pause_exceptions-04.js",
      1
    );
        /* eslint-enable */
      } catch (e) {}

      await onResume;

      Assert.equal(!!packet, true);
      Assert.equal(packet.why.type, "exception");
      Assert.equal(packet.why.exception, "42");
      packet = null;

      threadFront.once("paused", function(pkt) {
        packet = pkt;
        onResume = threadFront.resume();
      });

      await threadFront.pauseOnExceptions(false, true);
      try {
        /* eslint-disable */
    Cu.evalInSandbox(
      `                                   // 1
      function dontStopMe() {             // 2
        throw 43;                         // 3
      }                                   // 4
      dontStopMe();                       // 5
      `,                                  // 6
      debuggee,
      "1.8",
      "test_pause_exceptions-04.js",
      1
    );
        /* eslint-enable */
      } catch (e) {}

      // Test that the paused listener callback hasn't been called
      // on the thrown error from dontStopMe()
      Assert.equal(!!packet, false);

      await threadFront.pauseOnExceptions(true, true);
      try {
        /* eslint-disable */
    Cu.evalInSandbox(
      `                                   // 1
      function stopMeAgain() {            // 2
        throw 44;                         // 3
      }                                   // 4
      stopMeAgain();                      // 5
      `,                                  // 6
      debuggee,
      "1.8",
      "test_pause_exceptions-04.js",
      1
    );
    /* eslint-enable */
      } catch (e) {}

      await onResume;

      // Test that the paused listener callback has been called
      // on the thrown error from stopMeAgain()
      Assert.equal(!!packet, true);
      Assert.equal(packet.why.type, "exception");
      Assert.equal(packet.why.exception, "44");
    },
    {
      // Bug 1508289, exception tests fails in worker scope
      doNotRunWorker: true,
    }
  )
);
