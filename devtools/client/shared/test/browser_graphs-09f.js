/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

// Tests the constructor options for `min`, `max` and `avg` on displaying the
// gutter/tooltips and lines.

const TEST_DATA = [{ delta: 100, value: 60 }, { delta: 200, value: 1 }];
const LineGraphWidget = require("devtools/client/shared/widgets/LineGraphWidget");

add_task(function* () {
  yield addTab("about:blank");
  yield performTest();
  gBrowser.removeCurrentTab();
});

function* performTest() {
  let [host,, doc] = yield createHost();

  yield testGraph(doc.body, { avg: false });
  yield testGraph(doc.body, { min: false });
  yield testGraph(doc.body, { max: false });
  yield testGraph(doc.body, { min: false, max: false, avg: false });
  yield testGraph(doc.body, {});

  host.destroy();
}

function* testGraph(parent, options) {
  options.metric = "fps";
  let graph = new LineGraphWidget(parent, options);
  yield graph.setDataWhenReady(TEST_DATA);
  let shouldGutterShow = options.min === false && options.max === false;

  is(graph._gutter.hidden, shouldGutterShow,
    `The gutter should ${shouldGutterShow ? "" : "not "}be shown`);

  is(graph._maxTooltip.hidden, options.max === false,
    `The max tooltip should ${options.max === false ? "not " : ""}be shown`);
  is(graph._maxGutterLine.hidden, options.max === false,
    `The max gutter should ${options.max === false ? "not " : ""}be shown`);
  is(graph._minTooltip.hidden, options.min === false,
    `The min tooltip should ${options.min === false ? "not " : ""}be shown`);
  is(graph._minGutterLine.hidden, options.min === false,
    `The min gutter should ${options.min === false ? "not " : ""}be shown`);
  is(graph._avgTooltip.hidden, options.avg === false,
    `The avg tooltip should ${options.avg === false ? "not " : ""}be shown`);
  is(graph._avgGutterLine.hidden, options.avg === false,
    `The avg gutter should ${options.avg === false ? "not " : ""}be shown`);

  yield graph.destroy();
}
