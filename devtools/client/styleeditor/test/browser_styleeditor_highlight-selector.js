/* vim: set ts=2 et sw=2 tw=80: */
/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

// Test that hovering over a simple selector in the style-editor requests the
// highlighting of the corresponding nodes

add_task(function* () {
  let url = TEST_BASE_HTTP + "selector-highlighter.html";
  let { ui } = yield openStyleEditorForURL(url);
  let editor = ui.editors[0];

  // Mock the highlighter so we can locally assert that things happened
  // correctly instead of accessing the highlighter elements
  editor.highlighter = {
    isShown: false,
    options: null,

    show: function (node, options) {
      this.isShown = true;
      this.options = options;
      return promise.resolve();
    },

    hide: function () {
      this.isShown = false;
    }
  };

  info("Expecting a node-highlighted event");
  let onHighlighted = editor.once("node-highlighted");

  info("Simulate a mousemove event on the div selector");
  editor._onMouseMove({clientX: 56, clientY: 10});
  yield onHighlighted;

  ok(editor.highlighter.isShown, "The highlighter is now shown");
  is(editor.highlighter.options.selector, "div", "The selector is correct");

  info("Simulate a mousemove event elsewhere in the editor");
  editor._onMouseMove({clientX: 16, clientY: 0});

  ok(!editor.highlighter.isShown, "The highlighter is now hidden");
});
