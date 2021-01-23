/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */
/* eslint-disable no-shadow, max-nested-callbacks */

"use strict";

// Test the xpcshell-test debug support.  Ideally we should have this test
// next to the xpcshell support code, but that's tricky...

// HACK: ServiceWorkerManager requires the "profile-change-teardown" to cleanly
// shutdown, and setting _profileInitialized to `true` will trigger those
// notifications (see /testing/xpcshell/head.js).
// eslint-disable-next-line no-undef
_profileInitialized = true;

add_task(async function() {
  const testFile = do_get_file("xpcshell_debugging_script.js");

  // _setupDevToolsServer is from xpcshell-test's head.js
  /* global _setupDevToolsServer */
  let testResumed = false;
  const { DevToolsServer } = _setupDevToolsServer([testFile.path], () => {
    testResumed = true;
  });
  const transport = DevToolsServer.connectPipe();
  const client = new DevToolsClient(transport);
  await client.connect();

  // Ensure that global actors are available. Just test the device actor.
  const deviceFront = await client.mainRoot.getFront("device");
  const desc = await deviceFront.getDescription();
  equal(
    desc.geckobuildid,
    Services.appinfo.platformBuildID,
    "device actor works"
  );

  // Even though we have no tabs, getMainProcess gives us the chrome debugger.
  const targetDescriptor = await client.mainRoot.getMainProcess();
  const front = await targetDescriptor.getTarget();
  const threadFront = await front.attachThread();

  // tell the thread to do the initial resume. This would cause the
  // xpcshell test harness to resume and load the file under test.
  threadFront.resume().then(() => {
    // should have been told to resume the test itself.
    ok(testResumed);
    // Now load our test script.
    load(testFile.path);
    // and our "paused" listener below should get hit.
  });

  const packet1 = await waitForPause(threadFront);
  equal(
    packet1.why.type,
    "breakpoint",
    "yay - hit the breakpoint at the first line in our script"
  );

  // Resume again - next stop should be our "debugger" statement.
  threadFront.resume();

  const packet2 = await waitForPause(threadFront);
  equal(
    packet2.why.type,
    "debuggerStatement",
    "yay - hit the 'debugger' statement in our script"
  );
  threadFront.resume();

  finishClient(client);
});
