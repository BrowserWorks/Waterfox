/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

// Test that the highlighter is correctly displayed and picker mode is not stopped after
// a shift-click (preview)

const TEST_URI = `data:text/html;charset=utf-8,
                  <p id="one">one</p><p id="two">two</p><p id="three">three</p>`;

add_task(function* () {
  let {inspector, toolbox, testActor} = yield openInspectorForURL(TEST_URI);

  let body = yield getNodeFront("body", inspector);
  is(inspector.selection.nodeFront, body, "By default the body node is selected");

  info("Start the element picker");
  yield startPicker(toolbox);

  info("Shift-clicking element #one should select it but keep the picker ON");
  yield clickElement("#one", testActor, inspector, true);
  yield checkElementSelected("#one", inspector);
  checkPickerMode(toolbox, true);

  info("Shift-clicking element #two should select it but keep the picker ON");
  yield clickElement("#two", testActor, inspector, true);
  yield checkElementSelected("#two", inspector);
  checkPickerMode(toolbox, true);

  info("Clicking element #three should select it and turn the picker OFF");
  yield clickElement("#three", testActor, inspector, false);
  yield checkElementSelected("#three", inspector);
  checkPickerMode(toolbox, false);
});

function* clickElement(selector, testActor, inspector, isShift) {
  let onSelectionChanged = inspector.once("inspector-updated");
  yield testActor.synthesizeMouse({
    selector: selector,
    center: true,
    options: { shiftKey: isShift }
  });
  yield onSelectionChanged;
}

function* checkElementSelected(selector, inspector) {
  let el = yield getNodeFront(selector, inspector);
  is(inspector.selection.nodeFront, el, `The element ${selector} is now selected`);
}

function checkPickerMode(toolbox, isOn) {
  let pickerButton = toolbox.doc.querySelector("#command-button-pick");
  is(pickerButton.hasAttribute("checked"), isOn, "The picker mode is correct");
}
