/* vim: set ts=2 et sw=2 tw=80: */
/* Any copyright is dedicated to the Public Domain.
 http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

// Bug 1327683 - Tests that an editable attribute is not refocused
// when the focus has been moved to an other element than the editor.

const TEST_URL = 'data:text/html,<body class="abcd"></body>';

add_task(function* () {
  let {inspector} = yield openInspectorForURL(TEST_URL);

  yield selectNode(".abcd", inspector);
  yield clickContainer(".abcd", inspector);

  let container = yield focusNode(".abcd", inspector);
  ok(container && container.editor, "The markup-container was found");

  info("Listening for the markupmutation event");
  let nodeMutated = inspector.once("markupmutation");
  let attr = container.editor.attrElements.get("class").querySelector(".editable");

  attr.focus();
  EventUtils.sendKey("return", inspector.panelWin);
  let input = inplaceEditor(attr).input;
  ok(input, "Found editable field for class attribute");

  input.value = "class=\"wxyz\"";

  let onFocus = once(inspector.searchBox, "focus");
  EventUtils.synthesizeMouseAtCenter(inspector.searchBox, {}, inspector.panelWin);

  info("Wait for the focus event on search box");
  yield onFocus;

  info("Wait for the markup-mutation event");
  yield nodeMutated;

  is(inspector.panelDoc.activeElement, inspector.searchBox,
     "The currently focused element is the search box");
});
