/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */
/* eslint-disable max-nested-callbacks */

"use strict";

/**
 * Test that the preview in a Promise's grip is correct when the Promise is
 * fulfilled.
 */

function run_test() {
  initTestDebuggerServer();
  const debuggee = addTestGlobal("test-promise-state");
  const client = new DebuggerClient(DebuggerServer.connectPipe());
  client.connect().then(function () {
    attachTestTabAndResume(
      client, "test-promise-state",
      function (response, tabClient, threadClient) {
        Task.spawn(function* () {
          const packet = yield executeOnNextTickAndWaitForPause(
            () => evalCode(debuggee), client);

          const grip = packet.frame.environment.bindings.variables.p;
          ok(grip.value.preview);
          equal(grip.value.class, "Promise");
          equal(grip.value.promiseState.state, "fulfilled");
          equal(grip.value.promiseState.value.actorID, packet.frame.arguments[0].actorID,
                "The promise's fulfilled state value should be the same value passed " +
                "to the then function");

          finishClient(client);
        });
      });
  });
  do_test_pending();
}

function evalCode(debuggee) {
  /* eslint-disable */
  Components.utils.evalInSandbox(
    "doTest();\n" +
    function doTest() {
      var resolved = Promise.resolve({});
      resolved.then(() => {
        var p = resolved;
        debugger;
      });
    },
    debuggee
  );
  /* eslint-enable */
}
