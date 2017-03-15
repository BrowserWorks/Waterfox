/* vim: set ft=javascript ts=2 et sw=2 tw=80: */
/* Any copyright is dedicated to the Public Domain.
 http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

// Regression test for bug 1293616: make sure that editing a selector
// keeps the rule in the proper position.

const TEST_URI = `
  <style type="text/css">
    #testid span, #testid p {
      background: aqua;
    }
    span {
      background: fuchsia;
    }
  </style>
  <div id="testid">
    <span class="pickme">
      Styled Node
    </span>
  </div>
`;

add_task(function* () {
  yield addTab("data:text/html;charset=utf-8," + encodeURIComponent(TEST_URI));
  let {inspector, view} = yield openRuleView();
  yield selectNode(".pickme", inspector);
  yield testEditSelector(view);
});

function* testEditSelector(view) {
  let ruleEditor = getRuleViewRuleEditor(view, 1);
  let editor = yield focusEditableField(view, ruleEditor.selectorText);

  editor.input.value = "#testid span";
  let onRuleViewChanged = once(view, "ruleview-changed");
  EventUtils.synthesizeKey("VK_RETURN", {});
  yield onRuleViewChanged;

  // Escape the new property editor after editing the selector
  let onBlur = once(view.styleDocument.activeElement, "blur");
  EventUtils.synthesizeKey("VK_ESCAPE", {}, view.styleWindow);
  yield onBlur;

  // Get the new rule editor that replaced the original
  ruleEditor = getRuleViewRuleEditor(view, 1);

  info("Check that the correct rules are visible");
  is(view._elementStyle.rules.length, 3, "Should have 3 rules.");
  is(ruleEditor.element.getAttribute("unmatched"), "false", "Rule editor is matched.");

  let props = ruleEditor.rule.textProps;
  is(props.length, 1, "Rule has correct number of properties");
  is(props[0].name, "background", "Found background property");
  ok(!props[0].overridden, "Background property is not overridden");

  ruleEditor = getRuleViewRuleEditor(view, 2);
  props = ruleEditor.rule.textProps;
  is(props.length, 1, "Rule has correct number of properties");
  is(props[0].name, "background", "Found background property");
  ok(props[0].overridden, "Background property is overridden");
}
