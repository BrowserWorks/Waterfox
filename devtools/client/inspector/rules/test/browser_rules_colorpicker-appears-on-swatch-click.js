/* vim: set ft=javascript ts=2 et sw=2 tw=80: */
/* Any copyright is dedicated to the Public Domain.
 http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

// Tests that color pickers appear when clicking on color swatches.

const TEST_URI = `
  <style type="text/css">
    body {
      color: red;
      background-color: #ededed;
      background-image: url(chrome://global/skin/icons/warning-64.png);
      border: 2em solid rgba(120, 120, 120, .5);
    }
  </style>
  Testing the color picker tooltip!
`;

add_task(function* () {
  yield addTab("data:text/html;charset=utf-8," + encodeURIComponent(TEST_URI));
  let {view} = yield openRuleView();

  let propertiesToTest = ["color", "background-color", "border"];

  for (let property of propertiesToTest) {
    info("Testing that the colorpicker appears on swatch click");
    let value = getRuleViewProperty(view, "body", property).valueSpan;
    let swatch = value.querySelector(".ruleview-colorswatch");
    yield testColorPickerAppearsOnColorSwatchClick(view, swatch);
  }
});

function* testColorPickerAppearsOnColorSwatchClick(view, swatch) {
  let cPicker = view.tooltips.getTooltip("colorPicker");
  ok(cPicker, "The rule-view has the expected colorPicker property");

  let cPickerPanel = cPicker.tooltip.panel;
  ok(cPickerPanel, "The XUL panel for the color picker exists");

  let onColorPickerReady = cPicker.once("ready");
  swatch.click();
  yield onColorPickerReady;

  ok(true, "The color picker was shown on click of the color swatch");
  ok(!inplaceEditor(swatch.parentNode),
    "The inplace editor wasn't shown as a result of the color swatch click");

  yield hideTooltipAndWaitForRuleViewChanged(cPicker, view);
}
