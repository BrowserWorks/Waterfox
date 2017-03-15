/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

// Tests that bar graph create a legend as expected.

const BarGraphWidget = require("devtools/client/shared/widgets/BarGraphWidget");

const CATEGORIES = [
  { color: "#46afe3", label: "Foo" },
  { color: "#eb5368", label: "Bar" },
  { color: "#70bf53", label: "Baz" }
];

add_task(function* () {
  yield addTab("about:blank");
  yield performTest();
  gBrowser.removeCurrentTab();
});

function* performTest() {
  let [host,, doc] = yield createHost();
  let graph = new BarGraphWidget(doc.body);
  yield graph.once("ready");

  testGraph(graph);

  yield graph.destroy();
  host.destroy();
}

function testGraph(graph) {
  graph.format = CATEGORIES;
  graph.setData([{ delta: 0, values: [] }]);

  let legendContainer = graph._document.querySelector(".bar-graph-widget-legend");
  ok(legendContainer,
    "A legend container should be available.");
  is(legendContainer.childNodes.length, 3,
    "Three legend items should have been created.");

  let legendItems = graph._document.querySelectorAll(".bar-graph-widget-legend-item");
  is(legendItems.length, 3,
    "Three legend items should exist in the entire graph.");

  is(legendItems[0].querySelector("[view=color]").style.backgroundColor,
     "rgb(70, 175, 227)", "The first legend item has the correct color.");
  is(legendItems[1].querySelector("[view=color]").style.backgroundColor,
     "rgb(235, 83, 104)", "The second legend item has the correct color.");
  is(legendItems[2].querySelector("[view=color]").style.backgroundColor,
     "rgb(112, 191, 83)", "The third legend item has the correct color.");

  is(legendItems[0].querySelector("[view=label]").textContent, "Foo",
    "The first legend item has the correct label.");
  is(legendItems[1].querySelector("[view=label]").textContent, "Bar",
    "The second legend item has the correct label.");
  is(legendItems[2].querySelector("[view=label]").textContent, "Baz",
    "The third legend item has the correct label.");
}
