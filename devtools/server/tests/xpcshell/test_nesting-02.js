/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

// Test that we can nest event loops and then automatically exit nested event
// loops when requested.

add_task(
  threadFrontTest(async ({ threadFront, client }) => {
    // Reach over the protocol connection and get a reference to the thread actor.
    // TODO: rewrite the test so we don't do this..
    const thread = client._transport._serverConnection.getActor(
      threadFront.actorID
    );

    test_nesting(thread);
  })
);

function test_nesting(thread) {
  const { resolve, promise: p } = defer();

  // The following things should happen (in order):
  // 1. In the new event loop (created by unsafeSynchronize)
  // 2. Resolve the promise (shouldn't exit any event loops)
  // 3. Exit the event loop (should also then exit unsafeSynchronize's event loop)
  // 4. Be after the unsafeSynchronize call
  let currentStep = 0;

  executeSoon(function() {
    executeSoon(function() {
      // Should be at step 2
      Assert.equal(++currentStep, 2);
      // Before resolving, should have the unsafeSynchronize event loop and the
      // one just created.
      Assert.equal(thread._nestedEventLoops.size, 2);

      executeSoon(function() {
        // Should be at step 3
        Assert.equal(++currentStep, 3);
        // Before exiting the manually created event loop, should have the
        // unsafeSynchronize event loop and the manual event loop.
        Assert.equal(thread._nestedEventLoops.size, 2);
        // Should have the event loop
        Assert.ok(!!eventLoop);
        eventLoop.resolve();
      });

      resolve(true);
      // Shouldn't exit any event loops because a new one started since the call
      // to unsafeSynchronize
      Assert.equal(thread._nestedEventLoops.size, 2);
    });

    // Should be at step 1
    Assert.equal(++currentStep, 1);
    // Should have only the unsafeSynchronize event loop
    Assert.equal(thread._nestedEventLoops.size, 1);
    const eventLoop = thread._nestedEventLoops.push();
    eventLoop.enter();
  });

  Assert.equal(thread.unsafeSynchronize(p), true);

  // Should be on the fourth step
  Assert.equal(++currentStep, 4);
  // There shouldn't be any nested event loops anymore
  Assert.equal(thread._nestedEventLoops.size, 0);
}
