/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

/**
 * Makes sure Pie+Table Charts have the right internal structure.
 */

add_task(function* () {
  let { L10N } = require("devtools/client/netmonitor/l10n");

  let { monitor } = yield initNetMonitor(SIMPLE_URL);
  info("Starting test... ");

  let { document, Chart } = monitor.panelWin;

  let chart = Chart.PieTable(document, {
    title: "Table title",
    data: [{
      size: 1,
      label: 11.1
    }, {
      size: 2,
      label: 12.2
    }, {
      size: 3,
      label: 13.3
    }],
    strings: {
      label2: (value, index) => value + ["foo", "bar", "baz"][index]
    },
    totals: {
      size: value => "Hello " + L10N.numberWithDecimals(value, 2),
      label: value => "World " + L10N.numberWithDecimals(value, 2)
    }
  });

  ok(chart.pie, "The pie chart proxy is accessible.");
  ok(chart.table, "The table chart proxy is accessible.");

  let node = chart.node;
  let rows = node.querySelectorAll(".table-chart-row");
  let sums = node.querySelectorAll(".table-chart-summary-label");

  ok(node.classList.contains("pie-table-chart-container"),
    "A pie+table chart container was created successfully.");

  ok(node.querySelector(".table-chart-title"),
    "A title node was created successfully.");
  ok(node.querySelector(".pie-chart-container"),
    "A pie chart was created successfully.");
  ok(node.querySelector(".table-chart-container"),
    "A table chart was created successfully.");

  is(rows.length, 3, "There should be 3 pie chart slices created.");
  is(rows.length, 3, "There should be 3 table chart rows created.");
  is(sums.length, 2, "There should be 2 total summaries created.");

  yield teardown(monitor);
});
