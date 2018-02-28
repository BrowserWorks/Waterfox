/* Any copyright is dedicated to the Public Domain.
 http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

// Tests toggling ON/OFF the grid highlighter from the grid ispector panel.

const TEST_URI = `
  <style type='text/css'>
    #grid {
      display: grid;
    }
  </style>
  <div id="grid">
    <div id="cell1">cell1</div>
    <div id="cell2">cell2</div>
  </div>
`;

add_task(function* () {
  yield addTab("data:text/html;charset=utf-8," + encodeURIComponent(TEST_URI));
  let { gridInspector, inspector } = yield openLayoutView();
  let { document: doc } = gridInspector;
  let { highlighters, store } = inspector;

  yield selectNode("#grid", inspector);
  let gridList = doc.getElementById("grid-list");
  let checkbox = gridList.children[0].querySelector("input");

  info("Checking the initial state of the Grid Inspector.");
  is(gridList.childNodes.length, 1, "One grid container is listed.");
  ok(!checkbox.checked, `Grid item ${checkbox.value} is unchecked in the grid list.`);
  ok(!highlighters.highlighters[HIGHLIGHTER_TYPE],
    "No CSS grid highlighter exists in the highlighters overlay.");
  ok(!highlighters.gridHighlighterShown, "No CSS grid highlighter is shown.");

  info("Toggling ON the CSS grid highlighter from the layout panel.");
  let onHighlighterShown = highlighters.once("grid-highlighter-shown");
  let onCheckboxChange = waitUntilState(store, state =>
    state.grids.length == 1 &&
    state.grids[0].highlighted);
  checkbox.click();
  yield onHighlighterShown;
  yield onCheckboxChange;

  info("Checking the CSS grid highlighter is created.");
  ok(highlighters.highlighters[HIGHLIGHTER_TYPE],
    "CSS grid highlighter is created in the highlighters overlay.");
  ok(highlighters.gridHighlighterShown, "CSS grid highlighter is shown.");

  info("Toggling OFF the CSS grid highlighter from the layout panel.");
  let onHighlighterHidden = highlighters.once("grid-highlighter-hidden");
  onCheckboxChange = waitUntilState(store, state =>
    state.grids.length == 1 &&
    !state.grids[0].highlighted);
  checkbox.click();
  yield onHighlighterHidden;
  yield onCheckboxChange;

  info("Checking the CSS grid highlighter is not shown.");
  ok(!highlighters.gridHighlighterShown, "No CSS grid highlighter is shown.");
});
