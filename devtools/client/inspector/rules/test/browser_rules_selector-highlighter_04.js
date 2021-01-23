/* Any copyright is dedicated to the Public Domain.
http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

// Test that the selector highlighter is shown when clicking on a selector icon
// for the 'element {}' rule

// Note that in this test, we mock the highlighter front, merely testing the
// behavior of the style-inspector UI for now

const TEST_URI = `
<p>Testing the selector highlighter for the 'element {}' rule</p>
`;

add_task(async function() {
  await addTab("data:text/html;charset=utf-8," + encodeURIComponent(TEST_URI));
  const { inspector, view } = await openRuleView();

  // Mock the highlighter front to get the reference of the NodeFront
  const HighlighterFront = {
    isShown: false,
    nodeFront: null,
    options: null,
    show: function(nodeFront, options) {
      this.nodeFront = nodeFront;
      this.options = options;
      this.isShown = true;
    },
    hide: function() {
      this.nodeFront = null;
      this.options = null;
      this.isShown = false;
    },
  };
  // Inject the mock highlighter in the rule-view
  view.selectorHighlighter = HighlighterFront;

  info("Checking that the right NodeFront reference and options are passed");
  await selectNode("p", inspector);
  const icon = await getRuleViewSelectorHighlighterIcon(view, "element");

  await clickSelectorIcon(icon, view);
  is(
    HighlighterFront.nodeFront.tagName,
    "P",
    "The right NodeFront is passed to the highlighter (1)"
  );
  is(
    HighlighterFront.options.selector,
    "body > p:nth-child(1)",
    "The right selector option is passed to the highlighter (1)"
  );
  ok(
    HighlighterFront.isShown,
    "The toggle event says the highlighter is visible"
  );

  await clickSelectorIcon(icon, view);
  ok(
    !HighlighterFront.isShown,
    "The toggle event says the highlighter is not visible"
  );
});
