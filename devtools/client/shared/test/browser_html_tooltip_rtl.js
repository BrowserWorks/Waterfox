/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */
/* import-globals-from helper_html_tooltip.js */
"use strict";

/**
 * Test the HTMLTooltip anchor alignment changes with the anchor direction.
 * - should be aligned to the right of RTL anchors
 * - should be aligned to the left of LTR anchors
 */

const HTML_NS = "http://www.w3.org/1999/xhtml";
const TEST_URI = `data:text/xml;charset=UTF-8,<?xml version="1.0"?>
  <?xml-stylesheet href="chrome://global/skin/global.css"?>
  <?xml-stylesheet href="chrome://devtools/skin/tooltips.css"?>
  <window
    xmlns="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul"
    htmlns="http://www.w3.org/1999/xhtml"
    title="Tooltip test">
    <hbox style="padding: 90px 0;" flex="1">
      <hbox id="box1" flex="1" style="background:red; direction: rtl;">test1</hbox>
      <hbox id="box2" flex="1" style="background:blue; direction: rtl;">test2</hbox>
      <hbox id="box3" flex="1" style="background:red; direction: ltr;">test3</hbox>
      <hbox id="box4" flex="1" style="background:blue; direction: ltr;">test4</hbox>
    </hbox>
  </window>`;

const {HTMLTooltip} = require("devtools/client/shared/widgets/tooltip/HTMLTooltip");
loadHelperScript("helper_html_tooltip.js");

const TOOLBOX_WIDTH = 500;
const TOOLTIP_WIDTH = 150;
const TOOLTIP_HEIGHT = 30;

add_task(function* () {
  // Force the toolbox to be 500px wide (min width is 465px);
  yield pushPref("devtools.toolbox.sidebar.width", TOOLBOX_WIDTH);

  let [,, doc] = yield createHost("side", TEST_URI);

  info("Test a tooltip is not closed when clicking inside itself");

  let tooltip = new HTMLTooltip(doc, {useXulWrapper: false});
  let div = doc.createElementNS(HTML_NS, "div");
  div.textContent = "tooltip";
  div.style.cssText = "box-sizing: border-box; border: 1px solid black";
  tooltip.setContent(div, {width: TOOLTIP_WIDTH, height: TOOLTIP_HEIGHT});

  yield testRtlAnchors(doc, tooltip);
  yield testLtrAnchors(doc, tooltip);
  yield hideTooltip(tooltip);

  tooltip.destroy();
});

function* testRtlAnchors(doc, tooltip) {
  /*
   * The layout of the test page is as follows:
   *   _______________________________
   *  | toolbox                       |
   *  | _____   _____   _____   _____ |
   *  ||     | |     | |     | |     ||
   *  || box1| | box2| | box3| | box4||
   *  ||_____| |_____| |_____| |_____||
   *  |_______________________________|
   *
   * - box1 is aligned with the left edge of the toolbox
   * - box2 is displayed right after box1
   * - total toolbox width is 500px so each box is 125px wide
  */

  let box1 = doc.getElementById("box1");
  let box2 = doc.getElementById("box2");

  info("Display the tooltip on box1.");
  yield showTooltip(tooltip, box1, {position: "bottom"});

  let panelRect = tooltip.container.getBoundingClientRect();
  let anchorRect = box1.getBoundingClientRect();

  // box1 uses RTL direction, so the tooltip should be aligned with the right edge of the
  // anchor, but it is shifted to the right to fit in the toolbox.
  is(panelRect.left, 0, "Tooltip is aligned with left edge of the toolbox");
  is(panelRect.top, anchorRect.bottom, "Tooltip aligned with the anchor bottom edge");
  is(panelRect.height, TOOLTIP_HEIGHT, "Tooltip height is at 100px as expected");

  info("Display the tooltip on box2.");
  yield showTooltip(tooltip, box2, {position: "bottom"});

  panelRect = tooltip.container.getBoundingClientRect();
  anchorRect = box2.getBoundingClientRect();

  // box2 uses RTL direction, so the tooltip is aligned with the right edge of the anchor
  is(panelRect.right, anchorRect.right, "Tooltip is aligned with right edge of anchor");
  is(panelRect.top, anchorRect.bottom, "Tooltip aligned with the anchor bottom edge");
  is(panelRect.height, TOOLTIP_HEIGHT, "Tooltip height is at 100px as expected");
}

function* testLtrAnchors(doc, tooltip) {
    /*
   * The layout of the test page is as follows:
   *   _______________________________
   *  | toolbox                       |
   *  | _____   _____   _____   _____ |
   *  ||     | |     | |     | |     ||
   *  || box1| | box2| | box3| | box4||
   *  ||_____| |_____| |_____| |_____||
   *  |_______________________________|
   *
   * - box3 is is displayed right after box2
   * - box4 is aligned with the right edge of the toolbox
   * - total toolbox width is 500px so each box is 125px wide
  */

  let box3 = doc.getElementById("box3");
  let box4 = doc.getElementById("box4");

  info("Display the tooltip on box3.");
  yield showTooltip(tooltip, box3, {position: "bottom"});

  let panelRect = tooltip.container.getBoundingClientRect();
  let anchorRect = box3.getBoundingClientRect();

  // box3 uses LTR direction, so the tooltip is aligned with the left edge of the anchor.
  is(panelRect.left, anchorRect.left, "Tooltip is aligned with left edge of anchor");
  is(panelRect.top, anchorRect.bottom, "Tooltip aligned with the anchor bottom edge");
  is(panelRect.height, TOOLTIP_HEIGHT, "Tooltip height is at 100px as expected");

  info("Display the tooltip on box4.");
  yield showTooltip(tooltip, box4, {position: "bottom"});

  panelRect = tooltip.container.getBoundingClientRect();
  anchorRect = box4.getBoundingClientRect();

  // box4 uses LTR direction, so the tooltip should be aligned with the left edge of the
  // anchor, but it is shifted to the left to fit in the toolbox.
  is(panelRect.right, TOOLBOX_WIDTH, "Tooltip is aligned with right edge of toolbox");
  is(panelRect.top, anchorRect.bottom, "Tooltip aligned with the anchor bottom edge");
  is(panelRect.height, TOOLTIP_HEIGHT, "Tooltip height is at 100px as expected");
}
