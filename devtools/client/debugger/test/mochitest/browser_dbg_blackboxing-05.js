/* -*- indent-tabs-mode: nil; js-indent-level: 2 -*- */
/* vim: set ft=javascript ts=2 et sw=2 tw=80: */
/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

/**
 * Test that a "this source is blackboxed" message is shown when necessary
 * and can be properly dismissed.
 */

const TAB_URL = EXAMPLE_URL + "doc_binary_search.html";

var gTab, gPanel, gDebugger;
var gDeck;

function test() {
  let options = {
    source: EXAMPLE_URL + "code_binary_search.coffee",
    line: 1
  };
  initDebugger(TAB_URL, options).then(([aTab,, aPanel]) => {
    gTab = aTab;
    gPanel = aPanel;
    gDebugger = gPanel.panelWin;
    gDeck = gDebugger.document.getElementById("editor-deck");

    testSourceEditorShown();
    toggleBlackBoxing(gPanel)
      .then(testBlackBoxMessageShown)
      .then(clickStopBlackBoxingButton)
      .then(testSourceEditorShownAgain)
      .then(() => closeDebuggerAndFinish(gPanel))
      .catch(aError => {
        ok(false, "Got an error: " + aError.message + "\n" + aError.stack);
      });
  });
}

function testSourceEditorShown() {
  is(gDeck.selectedIndex, "0",
    "The first item in the deck should be selected (the source editor).");
}

function testBlackBoxMessageShown() {
  is(gDeck.selectedIndex, "1",
    "The second item in the deck should be selected (the black box message).");
}

function clickStopBlackBoxingButton() {
  // Give the test a chance to finish before triggering the click event.
  executeSoon(() => getEditorBlackboxMessageButton().click());
  return waitForDispatch(gPanel, gDebugger.constants.BLACKBOX);
}

function testSourceEditorShownAgain() {
  // Wait a tick for the final check to make sure the frontend's click handlers
  // have finished.
  return new Promise(resolve => {
    is(gDeck.selectedIndex, "0",
      "The first item in the deck should be selected again (the source editor).");
    resolve();
  });
}

function getEditorBlackboxMessageButton() {
  return gDebugger.document.getElementById("black-boxed-message-button");
}

registerCleanupFunction(function () {
  gTab = null;
  gPanel = null;
  gDebugger = null;
  gDeck = null;
});
