/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

// Test that highlighter handles geometry changes correctly.

const TEST_URI =
  "data:text/html;charset=utf-8," +
  "browser_inspector_invalidate.js\n" +
  '<div style="width: 100px; height: 100px; background:yellow;"></div>';

add_task(async function() {
  const { inspector, testActor } = await openInspectorForURL(TEST_URI);
  const divFront = await getNodeFront("div", inspector);

  info("Waiting for highlighter to activate");
  await inspector.highlighter.showBoxModel(divFront);

  let rect = await testActor.getSimpleBorderRect();
  is(rect.width, 100, "The highlighter has the right width.");

  info(
    "Changing the test element's size and waiting for the highlighter " +
      "to update"
  );
  await testActor.changeHighlightedNodeWaitForUpdate(
    "style",
    "width: 200px; height: 100px; background:yellow;"
  );

  rect = await testActor.getSimpleBorderRect();
  is(rect.width, 200, "The highlighter has the right width after update");

  info("Waiting for highlighter to hide");
  await inspector.highlighter.hideBoxModel();
});
