/* -*- indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set ft=javascript ts=2 et sw=2 tw=80: */
/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

/**
 * Tests that sources aren't selected by default when finding a match.
 */

const TAB_URL = EXAMPLE_URL + "doc_editor-mode.html";

var gTab, gPanel, gDebugger;
var gSearchBox;

function test() {
  let options = {
    source: EXAMPLE_URL + "code_script-switching-01.js?a=b",
    line: 1
  };
  initDebugger(TAB_URL, options).then(([aTab,, aPanel]) => {
    gTab = aTab;
    gPanel = aPanel;
    gDebugger = gPanel.panelWin;
    gSearchBox = gDebugger.DebuggerView.Filtering._searchbox;

    gDebugger.DebuggerView.Filtering.FilteredSources._autoSelectFirstItem = false;
    gDebugger.DebuggerView.Filtering.FilteredFunctions._autoSelectFirstItem = false;

    superGenericFileSearch()
      .then(() => ensureSourceIs(aPanel, "-01.js"))
      .then(() => ensureCaretAt(aPanel, 1))

      .then(superAccurateFileSearch)
      .then(() => ensureSourceIs(aPanel, "-01.js"))
      .then(() => ensureCaretAt(aPanel, 1))
      .then(() => pressKeyToHide("RETURN"))
      .then(() => ensureSourceIs(aPanel, "code_test-editor-mode", true))
      .then(() => ensureCaretAt(aPanel, 1))

      .then(superGenericFileSearch)
      .then(() => ensureSourceIs(aPanel, "code_test-editor-mode"))
      .then(() => ensureCaretAt(aPanel, 1))
      .then(() => {
        const shown = waitForSourceShown(aPanel, "doc_editor-mode");
        pressKey("UP");
        return shown;
      })
      .then(() => ensureCaretAt(aPanel, 1))
      .then(() => pressKeyToHide("RETURN"))
      .then(() => ensureSourceIs(aPanel, "doc_editor-mode"))
      .then(() => ensureCaretAt(aPanel, 1))

      .then(superAccurateFileSearch)
      .then(() => ensureSourceIs(aPanel, "doc_editor-mode"))
      .then(() => ensureCaretAt(aPanel, 1))
      .then(() => {
        const shown = waitForSourceShown(gPanel, "code_test-editor-mode");
        typeText(gSearchBox, ":");
        return shown;
      })
      .then(() => ensureSourceIs(aPanel, "code_test-editor-mode", true))
      .then(() => ensureCaretAt(aPanel, 1))
      .then(() => typeText(gSearchBox, "5"))
      .then(() => ensureSourceIs(aPanel, "code_test-editor-mode"))
      .then(() => ensureCaretAt(aPanel, 5))
      .then(() => pressKey("DOWN"))
      .then(() => ensureSourceIs(aPanel, "code_test-editor-mode"))
      .then(() => ensureCaretAt(aPanel, 6))

      .then(superGenericFunctionSearch)
      .then(() => ensureSourceIs(aPanel, "code_test-editor-mode"))
      .then(() => ensureCaretAt(aPanel, 6))
      .then(() => pressKey("RETURN"))
      .then(() => ensureSourceIs(aPanel, "code_test-editor-mode"))
      .then(() => ensureCaretAt(aPanel, 4, 10))

      .then(() => closeDebuggerAndFinish(gPanel))
      .catch(aError => {
        ok(false, "Got an error: " + aError.message + "\n" + aError.stack);
      });
  });
}

function waitForMatchFoundAndResultsShown(aName) {
  return promise.all([
    once(gDebugger, "popupshown"),
    waitForDebuggerEvents(gPanel, gDebugger.EVENTS[aName])
  ]);
}

function waitForResultsHidden() {
  return once(gDebugger, "popuphidden");
}

function superGenericFunctionSearch() {
  let finished = waitForMatchFoundAndResultsShown("FUNCTION_SEARCH_MATCH_FOUND");
  setText(gSearchBox, "@");
  return finished;
}

function superGenericFileSearch() {
  let finished = waitForMatchFoundAndResultsShown("FILE_SEARCH_MATCH_FOUND");
  setText(gSearchBox, ".");
  return finished;
}

function superAccurateFileSearch() {
  let finished = waitForMatchFoundAndResultsShown("FILE_SEARCH_MATCH_FOUND");
  setText(gSearchBox, "editor");
  return finished;
}

function pressKey(aKey) {
  EventUtils.sendKey(aKey, gDebugger);
}

function pressKeyToHide(aKey) {
  let finished = waitForResultsHidden();
  EventUtils.sendKey(aKey, gDebugger);
  return finished;
}

registerCleanupFunction(function () {
  gTab = null;
  gPanel = null;
  gDebugger = null;
  gSearchBox = null;
});
