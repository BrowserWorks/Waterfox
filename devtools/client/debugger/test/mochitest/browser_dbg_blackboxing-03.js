/* -*- indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set ft=javascript ts=2 et sw=2 tw=80: */
/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

/**
 * Test that black boxed frames are compressed into a single frame on the stack
 * view when we are already paused.
 */

const TAB_URL = EXAMPLE_URL + "doc_blackboxing.html";
const BLACKBOXME_URL = EXAMPLE_URL + "code_blackboxing_blackboxme.js";

var gTab, gPanel, gDebugger;
var gFrames, gSources;

function test() {
  let options = {
    source: BLACKBOXME_URL,
    line: 1
  };
  initDebugger(TAB_URL, options).then(([aTab,, aPanel]) => {
    gTab = aTab;
    gPanel = aPanel;
    gDebugger = gPanel.panelWin;
    gFrames = gDebugger.DebuggerView.StackFrames;
    gSources = gDebugger.DebuggerView.Sources;

    waitForSourceAndCaretAndScopes(gPanel, ".html", 21)
      .then(testBlackBoxStack)
      .then(testBlackBoxSource)
      .then(() => resumeDebuggerThenCloseAndFinish(gPanel))
      .catch(aError => {
        ok(false, "Got an error: " + aError.message + "\n" + aError.stack);
      });

    callInTab(gTab, "runTest");
  });
}

function testBlackBoxStack() {
  is(gFrames.itemCount, 6,
    "Should get 6 frames.");
  is(gDebugger.document.querySelectorAll(".dbg-stackframe-black-boxed").length, 0,
    "And none of them are black boxed.");
}

function testBlackBoxSource() {
  return toggleBlackBoxing(gPanel, getSourceActor(gSources, BLACKBOXME_URL)).then(aSource => {
    ok(aSource.isBlackBoxed, "The source should be black boxed now.");

    is(gFrames.itemCount, 3,
      "Should only get 3 frames.");
    is(gDebugger.document.querySelectorAll(".dbg-stackframe-black-boxed").length, 1,
      "And one of them should be the combined black boxed frames.");
  });
}

registerCleanupFunction(function () {
  gTab = null;
  gPanel = null;
  gDebugger = null;
  gFrames = null;
  gSources = null;
});
