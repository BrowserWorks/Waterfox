/* Any copyright is dedicated to the Public Domain.
 http://creativecommons.org/publicdomain/zero/1.0/ */
/* eslint-disable mozilla/no-arbitrary-setTimeout */

"use strict";

// Tests that selecting an element with the 'Inspect Element' context
// menu during a page reload doesn't cause the markup view to become empty.
// See https://bugzilla.mozilla.org/show_bug.cgi?id=1036324

const server = createTestHTTPServer();

// Register a slow image handler so we can simulate a long time between
// a reload and the load event firing.
server.registerContentType("gif", "image/gif");
server.registerPathHandler("/slow.gif", function(metadata, response) {
  info("Image has been requested");
  response.processAsync();
  setTimeout(() => {
    info("Image is responding");
    response.finish();
  }, 500);
});

// Test page load events.
const TEST_URL =
  "data:text/html," +
  "<!DOCTYPE html>" +
  "<head><meta charset='utf-8' /></head>" +
  "<body>" +
  "<p>Slow script</p>" +
  "<img src='http://localhost:" +
  server.identity.primaryPort +
  "/slow.gif' />" +
  "</body>" +
  "</html>";

add_task(async function() {
  const { inspector, testActor, tab } = await openInspectorForURL(TEST_URL);

  const domContentLoaded = waitForLinkedBrowserEvent(tab, "DOMContentLoaded");
  const pageLoaded = waitForLinkedBrowserEvent(tab, "load");

  ok(inspector.markup, "There is a markup view");

  // Select an element while the tab is in the middle of a slow reload.
  testActor.eval("location.reload()");

  info("Wait for DOMContentLoaded");
  await domContentLoaded;

  info("Inspect element via context menu");
  const markupLoaded = inspector.once("markuploaded");
  await chooseWithInspectElementContextMenu("img", tab);

  info("Wait for load");
  await pageLoaded;

  info("Wait for markup-loaded after element inspection");
  await markupLoaded;
  info("Wait for multiple children updates after element inspection");
  await waitForMultipleChildrenUpdates(inspector);

  ok(inspector.markup, "There is a markup view");
  is(inspector.markup._elt.children.length, 1, "The markup view is rendering");
});

async function chooseWithInspectElementContextMenu(selector, tab) {
  await BrowserTestUtils.synthesizeMouseAtCenter(
    selector,
    {
      type: "contextmenu",
      button: 2,
    },
    tab.linkedBrowser
  );

  await EventUtils.sendString("Q");
}

function waitForLinkedBrowserEvent(tab, event) {
  return BrowserTestUtils.waitForContentEvent(tab.linkedBrowser, event, true);
}
