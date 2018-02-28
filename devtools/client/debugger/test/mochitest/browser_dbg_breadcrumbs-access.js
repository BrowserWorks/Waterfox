/* -*- indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set ft=javascript ts=2 et sw=2 tw=80: */
/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

/**
 * Tests if the stackframe breadcrumbs are keyboard accessible.
 */

const TAB_URL = EXAMPLE_URL + "doc_script-switching-01.html";

function test() {
  let gTab, gPanel, gDebugger;
  let gSources, gFrames;

  let options = {
    source: EXAMPLE_URL + "code_script-switching-01.js",
    line: 1
  };
  initDebugger(TAB_URL, options).then(([aTab,, aPanel]) => {
    gTab = aTab;
    gPanel = aPanel;
    gDebugger = gPanel.panelWin;
    gSources = gDebugger.DebuggerView.Sources;
    gFrames = gDebugger.DebuggerView.StackFrames;

    waitForSourceAndCaretAndScopes(gPanel, "-02.js", 6)
      .then(checkNavigationWhileNotFocused)
      .then(focusCurrentStackFrame)
      .then(checkNavigationWhileFocused)
      .then(() => resumeDebuggerThenCloseAndFinish(gPanel))
      .catch(aError => {
        ok(false, "Got an error: " + aError.message + "\n" + aError.stack);
      });

    callInTab(gTab, "firstCall");
  });

  function checkNavigationWhileNotFocused() {
    checkState({ frame: 1, source: 1, line: 6 });

    return Task.spawn(function* () {
      EventUtils.sendKey("DOWN", gDebugger);
      checkState({ frame: 1, source: 1, line: 7 });

      EventUtils.sendKey("UP", gDebugger);
      checkState({ frame: 1, source: 1, line: 6 });
    });
  }

  function focusCurrentStackFrame() {
    EventUtils.sendMouseEvent({ type: "mousedown" },
      gFrames.selectedItem.target,
      gDebugger);
  }

  function checkNavigationWhileFocused() {
    return Task.spawn(function* () {
      yield promise.all([
        waitForDebuggerEvents(gPanel, gDebugger.EVENTS.FETCHED_SCOPES),
        waitForSourceAndCaret(gPanel, "-01.js", 5),
        EventUtils.sendKey("UP", gDebugger)
      ]);
      checkState({ frame: 0, source: 0, line: 5 });

      // Need to refocus the stack frame due to a focus bug in e10s
      // (See Bug 1205482)
      focusCurrentStackFrame();

      yield promise.all([
        waitForDebuggerEvents(gPanel, gDebugger.EVENTS.FETCHED_SCOPES),
        waitForSourceAndCaret(gPanel, "-02.js", 6),
        EventUtils.sendKey("END", gDebugger)
      ]);
      checkState({ frame: 1, source: 1, line: 6 });

      // Need to refocus the stack frame due to a focus bug in e10s
      // (See Bug 1205482)
      focusCurrentStackFrame();

      yield promise.all([
        waitForDebuggerEvents(gPanel, gDebugger.EVENTS.FETCHED_SCOPES),
        waitForSourceAndCaret(gPanel, "-01.js", 5),
        EventUtils.sendKey("HOME", gDebugger)
      ]);
      checkState({ frame: 0, source: 0, line: 5 });
    });
  }

  function checkState({ frame, source, line, column }) {
    is(gFrames.selectedIndex, frame,
      "The currently selected stackframe is incorrect.");
    is(gSources.selectedIndex, source,
      "The currently selected source is incorrect.");
    ok(isCaretPos(gPanel, line, column),
      "The source editor caret position was incorrect.");
  }
}
