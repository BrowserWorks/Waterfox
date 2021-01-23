/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */
/* eslint-disable no-shadow, max-nested-callbacks */

"use strict";

/**
 * Check that logpoints generate console messages.
 */

add_task(
  threadFrontTest(async ({ threadActor, threadFront, debuggee, client }) => {
    let lastMessage, lastExpression;
    threadActor._parent._consoleActor = {
      onConsoleAPICall(message) {
        lastMessage = message;
      },
      evaluateJS(expression) {
        lastExpression = expression;
      },
    };

    const packet = await executeOnNextTickAndWaitForPause(
      () => evalCode(debuggee),
      threadFront
    );

    const source = await getSourceById(threadFront, packet.frame.where.actor);

    // Set a logpoint which should invoke console.log.
    threadFront.setBreakpoint(
      {
        sourceUrl: source.url,
        line: 3,
      },
      { logValue: "a" }
    );
    await client.waitForRequestsToSettle();

    // Execute the rest of the code.
    await threadFront.resume();

    // NOTE: logpoints evaluated in a worker have a lastExpression
    if (lastMessage) {
      Assert.equal(lastMessage.level, "logPoint");
      Assert.equal(lastMessage.arguments[0], "three");
    } else {
      Assert.equal(lastExpression.text, "console.log(...[a])");
      Assert.equal(lastExpression.lineNumber, 3);
    }
  })
);

function evalCode(debuggee) {
  /* eslint-disable */
  Cu.evalInSandbox(
    "debugger;\n" + // 1
    "var a = 'three';\n" + // 2
      "var b = 2;\n", // 3
    debuggee,
    "1.8",
    "test.js",
    1
  );
  /* eslint-enable */
}
