/* -*- indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set ft=javascript ts=2 et sw=2 tw=80: */
/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

// Test that message source links for js errors and console API calls open in
// the jsdebugger when clicked.

"use strict";

const TEST_URI = "http://example.com/browser/devtools/client/webconsole/" +
  "new-console-output/test/mochitest/test-stacktrace-location-debugger-link.html";

add_task(function* () {
  // Force the new debugger UI, in case this gets uplifted with the old
  // debugger still turned on
  Services.prefs.setBoolPref("devtools.debugger.new-debugger-frontend", true);
  Services.prefs.setBoolPref("devtools.webconsole.filter.log", true);
  registerCleanupFunction(function* () {
    Services.prefs.clearUserPref("devtools.debugger.new-debugger-frontend");
    Services.prefs.clearUserPref("devtools.webconsole.filter.log");
  });

  let hud = yield openNewTabAndConsole(TEST_URI);
  let target = TargetFactory.forTab(gBrowser.selectedTab);
  let toolbox = gDevTools.getToolbox(target);

  yield testOpenInDebugger(hud, toolbox, "console.trace()");
});

function* testOpenInDebugger(hud, toolbox, text) {
  info(`Testing message with text "${text}"`);
  let messageNode = yield waitFor(() => findMessage(hud, text));
  let frameLinksNode = messageNode.querySelectorAll(".stack-trace .frame-link");
  is(frameLinksNode.length, 3,
    "The message does have the expected number of frames in the stacktrace");

  for (let frameLinkNode of frameLinksNode) {
    yield checkClickOnNode(hud, toolbox, frameLinkNode);

    info("Selecting the console again");
    yield toolbox.selectTool("webconsole");
  }
}

function* checkClickOnNode(hud, toolbox, frameLinkNode) {
  info("checking click on node location");

  let onSourceInDebuggerOpened = once(hud.ui, "source-in-debugger-opened");

  EventUtils.sendMouseEvent({ type: "click" },
    frameLinkNode.querySelector(".frame-link-source"));

  yield onSourceInDebuggerOpened;

  let url = frameLinkNode.getAttribute("data-url");
  let dbg = toolbox.getPanel("jsdebugger");
  is(
    dbg._selectors.getSelectedSource(dbg._getState()).get("url"),
    url,
    `Debugger is opened at expected source url (${url})`
  );
}
