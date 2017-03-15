/* vim: set ts=2 et sw=2 tw=80: */
/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */
/* import-globals-from helper_inplace_editor.js */

"use strict";

const { InplaceEditor } = require("devtools/client/shared/inplace-editor");
const { AutocompletePopup } = require("devtools/client/shared/autocomplete-popup");
loadHelperScript("helper_inplace_editor.js");

const TEST_URI = `data:text/xml;charset=UTF-8,<?xml version="1.0"?>
  <?xml-stylesheet href="chrome://global/skin/global.css"?>
  <?xml-stylesheet href="resource://devtools/client/themes/common.css"?>
  <?xml-stylesheet href="chrome://devtools/skin/tooltips.css"?>
  <window xmlns="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul"
   title="Tooltip test">
  </window>`;

// Test the inplace-editor autocomplete popup is aligned with the completed query.
// Which means when completing "style=display:flex; color:" the popup will aim to be
// aligned with the ":" next to "color".

// format :
//  [
//    what key to press,
//    expected input box value after keypress,
//    selected suggestion index (-1 if popup is hidden),
//    number of suggestions in the popup (0 if popup is hidden),
//  ]
// or
//  ["checkPopupOffset"]
// to measure and test the autocomplete popup left offset.
const testData = [
  ["VK_RIGHT", "style=", -1, 0],
  ["d", "style=display", 1, 2],
  ["checkPopupOffset"],
  ["VK_RIGHT", "style=display", -1, 0],
  [":", "style=display:block", 0, 3],
  ["checkPopupOffset"],
  ["f", "style=display:flex", -1, 0],
  ["VK_RIGHT", "style=display:flex", -1, 0],
  [";", "style=display:flex;", -1, 0],
  ["c", "style=display:flex;color", 1, 2],
  ["checkPopupOffset"],
  ["VK_RIGHT", "style=display:flex;color", -1, 0],
  [":", "style=display:flex;color:blue", 0, 2],
  ["checkPopupOffset"],
];

const mockGetCSSPropertyList = function () {
  return [
    "clear",
    "color",
    "direction",
    "display",
  ];
};

const mockGetCSSValuesForPropertyName = function (propertyName) {
  let values = {
    "color": ["blue", "red"],
    "display": ["block", "flex", "none"]
  };
  return values[propertyName] || [];
};

add_task(function* () {
  yield addTab("data:text/html;charset=utf-8,inplace editor CSS value autocomplete");
  let [host,, doc] = yield createHost("bottom", TEST_URI);

  let popup = new AutocompletePopup(doc, { autoSelect: true });

  info("Create a CSS_MIXED type autocomplete");
  yield new Promise(resolve => {
    createInplaceEditorAndClick({
      initial: "style=",
      start: runAutocompletionTest,
      contentType: InplaceEditor.CONTENT_TYPES.CSS_MIXED,
      done: resolve,
      popup: popup
    }, doc);
  });

  popup.destroy();
  host.destroy();
  gBrowser.removeCurrentTab();
});

let runAutocompletionTest = Task.async(function* (editor) {
  info("Starting autocomplete test for inplace-editor popup offset");
  editor._getCSSPropertyList = mockGetCSSPropertyList;
  editor._getCSSValuesForPropertyName = mockGetCSSValuesForPropertyName;

  let previousOffset = -1;
  for (let data of testData) {
    if (data[0] === "checkPopupOffset") {
      info("Check the popup offset has been modified");
      // We are not testing hard coded offset values here, which could be fragile. We only
      // want to ensure the popup tries to match the position of the query in the editor
      // input.
      let offset = getPopupOffset(editor);
      ok(offset > previousOffset, "New popup offset is greater than the previous one");
      previousOffset = offset;
    } else {
      yield testCompletion(data, editor);
    }
  }

  EventUtils.synthesizeKey("VK_RETURN", {}, editor.input.defaultView);
});

/**
 * Get the autocomplete panel left offset, relative to the provided input's left offset.
 */
function getPopupOffset({popup, input}) {
  let popupQuads = popup._panel.getBoxQuads({relativeTo: input});
  return popupQuads[0].bounds.left;
}
