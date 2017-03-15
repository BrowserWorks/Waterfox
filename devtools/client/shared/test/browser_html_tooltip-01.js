/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */
/* import-globals-from helper_html_tooltip.js */

"use strict";

/**
 * Test the HTMLTooltip show & hide methods.
 */

const HTML_NS = "http://www.w3.org/1999/xhtml";
const TEST_URI = `data:text/xml;charset=UTF-8,<?xml version="1.0"?>
  <?xml-stylesheet href="chrome://global/skin/global.css"?>
  <?xml-stylesheet href="chrome://devtools/skin/tooltips.css"?>
  <window xmlns="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul"
   title="Tooltip test">
    <vbox flex="1">
      <hbox id="box1" flex="1">test1</hbox>
      <hbox id="box2" flex="1">test2</hbox>
      <hbox id="box3" flex="1">test3</hbox>
      <hbox id="box4" flex="1">test4</hbox>
    </vbox>
  </window>`;

const {HTMLTooltip} = require("devtools/client/shared/widgets/tooltip/HTMLTooltip");
loadHelperScript("helper_html_tooltip.js");

let useXulWrapper;

function getTooltipContent(doc) {
  let div = doc.createElementNS(HTML_NS, "div");
  div.style.height = "50px";
  div.style.boxSizing = "border-box";
  div.textContent = "tooltip";
  return div;
}

add_task(function* () {
  let [,, doc] = yield createHost("bottom", TEST_URI);

  info("Run tests for a Tooltip without using a XUL panel");
  useXulWrapper = false;
  yield runTests(doc);

  info("Run tests for a Tooltip with a XUL panel");
  useXulWrapper = true;
  yield runTests(doc);
});

function* runTests(doc) {
  yield addTab("about:blank");
  let tooltip = new HTMLTooltip(doc, {useXulWrapper});

  info("Set tooltip content");
  tooltip.setContent(getTooltipContent(doc), {width: 100, height: 50});

  is(tooltip.isVisible(), false, "Tooltip is not visible");

  info("Show the tooltip and check the expected events are fired.");

  let shown = 0;
  tooltip.on("shown", () => shown++);

  let onShown = tooltip.once("shown");
  tooltip.show(doc.getElementById("box1"));

  yield onShown;
  is(shown, 1, "Event shown was fired once");

  yield waitForReflow(tooltip);
  is(tooltip.isVisible(), true, "Tooltip is visible");

  info("Hide the tooltip and check the expected events are fired.");

  let hidden = 0;
  tooltip.on("hidden", () => hidden++);

  let onPopupHidden = tooltip.once("hidden");
  tooltip.hide();

  yield onPopupHidden;
  is(hidden, 1, "Event hidden was fired once");

  yield waitForReflow(tooltip);
  is(tooltip.isVisible(), false, "Tooltip is not visible");

  tooltip.destroy();
}
