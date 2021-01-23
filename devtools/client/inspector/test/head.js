/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
/* eslint no-unused-vars: [2, {"vars": "local"}] */
/* import-globals-from ../../shared/test/shared-head.js */
/* import-globals-from ../../inspector/test/shared-head.js */
"use strict";

// Load the shared-head file first.
Services.scriptloader.loadSubScript(
  "chrome://mochitests/content/browser/devtools/client/shared/test/shared-head.js",
  this
);

// Services.prefs.setBoolPref("devtools.debugger.log", true);
// SimpleTest.registerCleanupFunction(() => {
//   Services.prefs.clearUserPref("devtools.debugger.log");
// });

// Import helpers for the inspector that are also shared with others
Services.scriptloader.loadSubScript(
  "chrome://mochitests/content/browser/devtools/client/inspector/test/shared-head.js",
  this
);

const { LocalizationHelper } = require("devtools/shared/l10n");
const INSPECTOR_L10N = new LocalizationHelper(
  "devtools/client/locales/inspector.properties"
);

registerCleanupFunction(() => {
  Services.prefs.clearUserPref("devtools.inspector.activeSidebar");
});

registerCleanupFunction(function() {
  // Move the mouse outside inspector. If the test happened fake a mouse event
  // somewhere over inspector the pointer is considered to be there when the
  // next test begins. This might cause unexpected events to be emitted when
  // another test moves the mouse.
  // Move the mouse at the top-right corner of the browser, to prevent
  // the mouse from triggering the tab tooltip to be shown while the tab is
  // being closed because the test is exiting (See Bug 1378524 for rationale).
  EventUtils.synthesizeMouseAtPoint(
    window.innerWidth,
    1,
    { type: "mousemove" },
    window
  );
});

/**
 * Start the element picker and focus the content window.
 * @param {Toolbox} toolbox
 * @param {Boolean} skipFocus - Allow tests to bypass the focus event.
 */
var startPicker = async function(toolbox, skipFocus) {
  info("Start the element picker");
  toolbox.win.focus();
  await toolbox.nodePicker.start();
  if (!skipFocus) {
    // By default make sure the content window is focused since the picker may not focus
    // the content window by default.
    await SpecialPowers.spawn(gBrowser.selectedBrowser, [], async function() {
      content.focus();
    });
  }
};

/**
 * Start the eye dropper tool.
 * @param {Toolbox} toolbox
 */
var startEyeDropper = async function(toolbox) {
  info("Start the eye dropper tool");
  toolbox.win.focus();
  await toolbox.getPanel("inspector").showEyeDropper();
};

/**
 * Pick an element from the content page using the element picker.
 *
 * @param {Inspector} inspector
 *        Inspector instance
 * @param {TestActor} testActor
 *        TestActor instance
 * @param {String} selector
 *        CSS selector to identify the click target
 * @param {Number} x
 *        X-offset from the top-left corner of the element matching the provided selector
 * @param {Number} y
 *        Y-offset from the top-left corner of the element matching the provided selector
 * @return {Promise} promise that resolves when the selection is updated with the picked
 *         node.
 */
function pickElement(inspector, testActor, selector, x, y) {
  info("Waiting for element " + selector + " to be picked");
  // Use an empty options argument in order trigger the default synthesizeMouse behavior
  // which will trigger mousedown, then mouseup.
  const onNewNodeFront = inspector.selection.once("new-node-front");
  testActor.synthesizeMouse({ selector, x, y, options: {} });
  return onNewNodeFront;
}

/**
 * Hover an element from the content page using the element picker.
 *
 * @param {Inspector} inspector
 *        Inspector instance
 * @param {TestActor} testActor
 *        TestActor instance
 * @param {String} selector
 *        CSS selector to identify the hover target
 * @param {Number} x
 *        X-offset from the top-left corner of the element matching the provided selector
 * @param {Number} y
 *        Y-offset from the top-left corner of the element matching the provided selector
 * @return {Promise} promise that resolves when the "picker-node-hovered" event is
 *         emitted.
 */
function hoverElement(inspector, testActor, selector, x, y) {
  info("Waiting for element " + selector + " to be hovered");
  const onHovered = inspector.toolbox.nodePicker.once("picker-node-hovered");
  testActor.synthesizeMouse({ selector, x, y, options: { type: "mousemove" } });
  return onHovered;
}

/**
 * Highlight a node and set the inspector's current selection to the node or
 * the first match of the given css selector.
 * @param {String|NodeFront} selector
 * @param {InspectorPanel} inspector
 *        The instance of InspectorPanel currently loaded in the toolbox
 * @return a promise that resolves when the inspector is updated with the new
 * node
 */
function selectAndHighlightNode(selector, inspector) {
  info("Highlighting and selecting the node " + selector);
  return selectNode(selector, inspector, "test-highlight");
}

/**
 * Select node for a given selector, make it focusable and set focus in its
 * container element.
 * @param {String|NodeFront} selector
 * @param {InspectorPanel} inspector The current inspector-panel instance.
 * @return {MarkupContainer}
 */
async function focusNode(selector, inspector) {
  getContainerForNodeFront(inspector.walker.rootNode, inspector).elt.focus();
  const nodeFront = await getNodeFront(selector, inspector);
  const container = getContainerForNodeFront(nodeFront, inspector);
  await selectNode(nodeFront, inspector);
  EventUtils.sendKey("return", inspector.panelWin);
  return container;
}

/**
 * Set the inspector's current selection to null so that no node is selected
 *
 * @param {InspectorPanel} inspector
 *        The instance of InspectorPanel currently loaded in the toolbox
 * @return a promise that resolves when the inspector is updated
 */
function clearCurrentNodeSelection(inspector) {
  info("Clearing the current selection");
  const updated = inspector.once("inspector-updated");
  inspector.selection.setNodeFront(null);
  return updated;
}

/**
 * Right click on a node in the test page and click on the inspect menu item.
 * @param {TestActor}
 * @param {String} selector The selector for the node to click on in the page.
 * @return {Promise} Resolves to the inspector when it has opened and is updated
 */
var clickOnInspectMenuItem = async function(testActor, selector) {
  info("Showing the contextual menu on node " + selector);
  const contentAreaContextMenu = document.querySelector(
    "#contentAreaContextMenu"
  );
  const contextOpened = once(contentAreaContextMenu, "popupshown");

  await testActor.synthesizeMouse({
    selector: selector,
    center: true,
    options: { type: "contextmenu", button: 2 },
  });

  await contextOpened;

  info("Triggering the inspect action");
  await gContextMenu.inspectNode();

  info("Hiding the menu");
  const contextClosed = once(contentAreaContextMenu, "popuphidden");
  contentAreaContextMenu.hidePopup();
  await contextClosed;

  return getActiveInspector();
};

/**
 * Get the NodeFront for a node that matches a given css selector inside a
 * given iframe.
 * @param {String|NodeFront} selector
 * @param {String|NodeFront} frameSelector A selector that matches the iframe
 * the node is in
 * @param {InspectorPanel} inspector The instance of InspectorPanel currently
 * loaded in the toolbox
 * @return {Promise} Resolves when the inspector is updated with the new node
 */
var getNodeFrontInFrame = async function(selector, frameSelector, inspector) {
  const iframe = await getNodeFront(frameSelector, inspector);
  const { nodes } = await inspector.walker.children(iframe);
  return inspector.walker.querySelector(nodes[0], selector);
};

/**
 * Get the NodeFront for the shadowRoot of a shadow host.
 *
 * @param {String|NodeFront} hostSelector
 *        Selector or front of the element to which the shadow root is attached.
 * @param {InspectorPanel} inspector
 *        The instance of InspectorPanel currently loaded in the toolbox
 * @return {Promise} Resolves the node front when the inspector is updated with the new
 *         node.
 */
var getShadowRoot = async function(hostSelector, inspector) {
  const hostFront = await getNodeFront(hostSelector, inspector);
  const { nodes } = await inspector.walker.children(hostFront);

  // Find the shadow root in the children of the host element.
  return nodes.filter(node => node.isShadowRoot)[0];
};

/**
 * Get the NodeFront for a node that matches a given css selector inside a shadow root.
 *
 * @param {String} selector
 *        CSS selector of the node inside the shadow root.
 * @param {String|NodeFront} hostSelector
 *        Selector or front of the element to which the shadow root is attached.
 * @param {InspectorPanel} inspector
 *        The instance of InspectorPanel currently loaded in the toolbox
 * @return {Promise} Resolves the node front when the inspector is updated with the new
 *         node.
 */
var getNodeFrontInShadowDom = async function(
  selector,
  hostSelector,
  inspector
) {
  const shadowRoot = await getShadowRoot(hostSelector, inspector);
  if (!shadowRoot) {
    throw new Error(
      "Could not find a shadow root under selector: " + hostSelector
    );
  }

  return inspector.walker.querySelector(shadowRoot, selector);
};

var focusSearchBoxUsingShortcut = async function(panelWin, callback) {
  info("Focusing search box");
  const searchBox = panelWin.document.getElementById("inspector-searchbox");
  const focused = once(searchBox, "focus");

  panelWin.focus();

  synthesizeKeyShortcut(INSPECTOR_L10N.getStr("inspector.searchHTML.key"));

  await focused;

  if (callback) {
    callback();
  }
};

/**
 * Get the MarkupContainer object instance that corresponds to the given
 * NodeFront
 * @param {NodeFront} nodeFront
 * @param {InspectorPanel} inspector The instance of InspectorPanel currently
 * loaded in the toolbox
 * @return {MarkupContainer}
 */
function getContainerForNodeFront(nodeFront, { markup }) {
  return markup.getContainer(nodeFront);
}

/**
 * Get the MarkupContainer object instance that corresponds to the given
 * selector
 * @param {String|NodeFront} selector
 * @param {InspectorPanel} inspector The instance of InspectorPanel currently
 * loaded in the toolbox
 * @param {Boolean} Set to true in the event that the node shouldn't be found.
 * @return {MarkupContainer}
 */
var getContainerForSelector = async function(
  selector,
  inspector,
  expectFailure = false
) {
  info("Getting the markup-container for node " + selector);
  const nodeFront = await getNodeFront(selector, inspector);
  const container = getContainerForNodeFront(nodeFront, inspector);

  if (expectFailure) {
    ok(!container, "Shouldn't find markup-container for selector: " + selector);
  } else {
    ok(container, "Found markup-container for selector: " + selector);
  }

  return container;
};

/**
 * Simulate a mouse-over on the markup-container (a line in the markup-view)
 * that corresponds to the selector passed.
 * @param {String|NodeFront} selector
 * @param {InspectorPanel} inspector The instance of InspectorPanel currently
 * loaded in the toolbox
 * @return {Promise} Resolves when the container is hovered and the higlighter
 * is shown on the corresponding node
 */
var hoverContainer = async function(selector, inspector) {
  info("Hovering over the markup-container for node " + selector);

  const nodeFront = await getNodeFront(selector, inspector);
  const container = getContainerForNodeFront(nodeFront, inspector);

  const highlit = inspector.highlighter.once("node-highlight");
  EventUtils.synthesizeMouseAtCenter(
    container.tagLine,
    { type: "mousemove" },
    inspector.markup.doc.defaultView
  );
  return highlit;
};

/**
 * Simulate a click on the markup-container (a line in the markup-view)
 * that corresponds to the selector passed.
 * @param {String|NodeFront} selector
 * @param {InspectorPanel} inspector The instance of InspectorPanel currently
 * loaded in the toolbox
 * @return {Promise} Resolves when the node has been selected.
 */
var clickContainer = async function(selector, inspector) {
  info("Clicking on the markup-container for node " + selector);

  const nodeFront = await getNodeFront(selector, inspector);
  const container = getContainerForNodeFront(nodeFront, inspector);

  const updated = inspector.once("inspector-updated");
  EventUtils.synthesizeMouseAtCenter(
    container.tagLine,
    { type: "mousedown" },
    inspector.markup.doc.defaultView
  );
  EventUtils.synthesizeMouseAtCenter(
    container.tagLine,
    { type: "mouseup" },
    inspector.markup.doc.defaultView
  );
  return updated;
};

/**
 * Simulate the mouse leaving the markup-view area
 * @param {InspectorPanel} inspector The instance of InspectorPanel currently
 * loaded in the toolbox
 * @return a promise when done
 */
function mouseLeaveMarkupView(inspector) {
  info("Leaving the markup-view area");

  // Find another element to mouseover over in order to leave the markup-view
  const btn = inspector.toolbox.doc.querySelector("#toolbox-controls");

  EventUtils.synthesizeMouseAtCenter(
    btn,
    { type: "mousemove" },
    inspector.toolbox.win
  );

  return new Promise(resolve => {
    executeSoon(resolve);
  });
}

/**
 * Dispatch the copy event on the given element
 */
function fireCopyEvent(element) {
  const evt = element.ownerDocument.createEvent("Event");
  evt.initEvent("copy", true, true);
  element.dispatchEvent(evt);
}

/**
 * Undo the last markup-view action and wait for the corresponding mutation to
 * occur
 * @param {InspectorPanel} inspector The instance of InspectorPanel currently
 * loaded in the toolbox
 * @return a promise that resolves when the markup-mutation has been treated or
 * rejects if no undo action is possible
 */
function undoChange(inspector) {
  const canUndo = inspector.markup.undo.canUndo();
  ok(canUndo, "The last change in the markup-view can be undone");
  if (!canUndo) {
    return promise.reject();
  }

  const mutated = inspector.once("markupmutation");
  inspector.markup.undo.undo();
  return mutated;
}

/**
 * Redo the last markup-view action and wait for the corresponding mutation to
 * occur
 * @param {InspectorPanel} inspector The instance of InspectorPanel currently
 * loaded in the toolbox
 * @return a promise that resolves when the markup-mutation has been treated or
 * rejects if no redo action is possible
 */
function redoChange(inspector) {
  const canRedo = inspector.markup.undo.canRedo();
  ok(canRedo, "The last change in the markup-view can be redone");
  if (!canRedo) {
    return promise.reject();
  }

  const mutated = inspector.once("markupmutation");
  inspector.markup.undo.redo();
  return mutated;
}

/**
 * A helper that fetches a front for a node that matches the given selector or
 * doctype node if the selector is falsy.
 */
async function getNodeFrontForSelector(selector, inspector) {
  if (selector) {
    info("Retrieving front for selector " + selector);
    return getNodeFront(selector, inspector);
  }

  info("Retrieving front for doctype node");
  const { nodes } = await inspector.walker.children(inspector.walker.rootNode);
  return nodes[0];
}

/**
 * A simple polling helper that executes a given function until it returns true.
 * @param {Function} check A generator function that is expected to return true at some
 * stage.
 * @param {String} desc A text description to be displayed when the polling starts.
 * @param {Number} attemptes Optional number of times we poll. Defaults to 10.
 * @param {Number} timeBetweenAttempts Optional time to wait between each attempt.
 * Defaults to 200ms.
 */
async function poll(check, desc, attempts = 10, timeBetweenAttempts = 200) {
  info(desc);

  for (let i = 0; i < attempts; i++) {
    if (await check()) {
      return;
    }
    await new Promise(resolve => setTimeout(resolve, timeBetweenAttempts));
  }

  throw new Error(`Timeout while: ${desc}`);
}

/**
 * Encapsulate some common operations for highlighter's tests, to have
 * the tests cleaner, without exposing directly `inspector`, `highlighter`, and
 * `testActor` if not needed.
 *
 * @param  {String}
 *    The highlighter's type
 * @return
 *    A generator function that takes an object with `inspector` and `testActor`
 *    properties. (see `openInspector`)
 */
const getHighlighterHelperFor = type =>
  async function({ inspector, testActor }) {
    const front = inspector.inspectorFront;
    const highlighter = await front.getHighlighterByType(type);

    let prefix = "";

    // Internals for mouse events
    let prevX, prevY;

    // Highlighted node
    let highlightedNode = null;

    return {
      set prefix(value) {
        prefix = value;
      },

      get highlightedNode() {
        if (!highlightedNode) {
          return null;
        }

        return {
          getComputedStyle: async function(options = {}) {
            const pageStyle = highlightedNode.inspectorFront.pageStyle;
            return pageStyle.getComputed(highlightedNode, options);
          },
        };
      },

      get actorID() {
        if (!highlighter) {
          return null;
        }

        return highlighter.actorID;
      },

      show: async function(selector = ":root", options, frameSelector = null) {
        if (frameSelector) {
          highlightedNode = await getNodeFrontInFrame(
            selector,
            frameSelector,
            inspector
          );
        } else {
          highlightedNode = await getNodeFront(selector, inspector);
        }
        return highlighter.show(highlightedNode, options);
      },

      hide: async function() {
        await highlighter.hide();
      },

      isElementHidden: async function(id) {
        return (
          (await testActor.getHighlighterNodeAttribute(
            prefix + id,
            "hidden",
            highlighter
          )) === "true"
        );
      },

      getElementTextContent: async function(id) {
        return testActor.getHighlighterNodeTextContent(
          prefix + id,
          highlighter
        );
      },

      getElementAttribute: async function(id, name) {
        return testActor.getHighlighterNodeAttribute(
          prefix + id,
          name,
          highlighter
        );
      },

      waitForElementAttributeSet: async function(id, name) {
        await poll(async function() {
          const value = await testActor.getHighlighterNodeAttribute(
            prefix + id,
            name,
            highlighter
          );
          return !!value;
        }, `Waiting for element ${id} to have attribute ${name} set`);
      },

      waitForElementAttributeRemoved: async function(id, name) {
        await poll(async function() {
          const value = await testActor.getHighlighterNodeAttribute(
            prefix + id,
            name,
            highlighter
          );
          return !value;
        }, `Waiting for element ${id} to have attribute ${name} removed`);
      },

      synthesizeMouse: async function(options) {
        options = Object.assign({ selector: ":root" }, options);
        await testActor.synthesizeMouse(options);
      },

      // This object will synthesize any "mouse" prefixed event to the
      // `testActor`, using the name of method called as suffix for the
      // event's name.
      // If no x, y coords are given, the previous ones are used.
      //
      // For example:
      //   mouse.down(10, 20); // synthesize "mousedown" at 10,20
      //   mouse.move(20, 30); // synthesize "mousemove" at 20,30
      //   mouse.up();         // synthesize "mouseup" at 20,30
      mouse: new Proxy(
        {},
        {
          get: (target, name) =>
            async function(x = prevX, y = prevY, selector = ":root") {
              prevX = x;
              prevY = y;
              await testActor.synthesizeMouse({
                selector,
                x,
                y,
                options: { type: "mouse" + name },
              });
            },
        }
      ),

      reflow: async function() {
        await testActor.reflow();
      },

      finalize: async function() {
        highlightedNode = null;
        await highlighter.finalize();
      },
    };
  };

// The expand all operation of the markup-view calls itself recursively and
// there's not one event we can wait for to know when it's done so use this
// helper function to wait until all recursive children updates are done.
async function waitForMultipleChildrenUpdates(inspector) {
  // As long as child updates are queued up while we wait for an update already
  // wait again
  if (
    inspector.markup._queuedChildUpdates &&
    inspector.markup._queuedChildUpdates.size
  ) {
    await waitForChildrenUpdated(inspector);
    return waitForMultipleChildrenUpdates(inspector);
  }
  return null;
}

/**
 * Using the markupview's _waitForChildren function, wait for all queued
 * children updates to be handled.
 * @param {InspectorPanel} inspector The instance of InspectorPanel currently
 * loaded in the toolbox
 * @return a promise that resolves when all queued children updates have been
 * handled
 */
function waitForChildrenUpdated({ markup }) {
  info("Waiting for queued children updates to be handled");
  return new Promise(resolve => {
    markup._waitForChildren().then(() => {
      executeSoon(resolve);
    });
  });
}

/**
 * Wait for the toolbox to emit the styleeditor-selected event and when done
 * wait for the stylesheet identified by href to be loaded in the stylesheet
 * editor
 *
 * @param {Toolbox} toolbox
 * @param {String} href
 *        Optional, if not provided, wait for the first editor to be ready
 * @return a promise that resolves to the editor when the stylesheet editor is
 * ready
 */
function waitForStyleEditor(toolbox, href) {
  info("Waiting for the toolbox to switch to the styleeditor");

  return new Promise(resolve => {
    toolbox.once("styleeditor-selected").then(() => {
      const panel = toolbox.getCurrentPanel();
      ok(panel && panel.UI, "Styleeditor panel switched to front");

      // A helper that resolves the promise once it receives an editor that
      // matches the expected href. Returns false if the editor was not correct.
      const gotEditor = editor => {
        const currentHref = editor.styleSheet.href;
        if (!href || (href && currentHref.endsWith(href))) {
          info("Stylesheet editor selected");
          panel.UI.off("editor-selected", gotEditor);

          editor.getSourceEditor().then(sourceEditor => {
            info("Stylesheet editor fully loaded");
            resolve(sourceEditor);
          });

          return true;
        }

        info("The editor was incorrect. Waiting for editor-selected event.");
        return false;
      };

      // The expected editor may already be selected. Check the if the currently
      // selected editor is the expected one and if not wait for an
      // editor-selected event.
      if (!gotEditor(panel.UI.selectedEditor)) {
        // The expected editor is not selected (yet). Wait for it.
        panel.UI.on("editor-selected", gotEditor);
      }
    });
  });
}

/**
 * Checks if document's active element is within the given element.
 * @param  {HTMLDocument}  doc document with active element in question
 * @param  {DOMNode}       container element tested on focus containment
 * @return {Boolean}
 */
function containsFocus(doc, container) {
  let elm = doc.activeElement;
  while (elm) {
    if (elm === container) {
      return true;
    }
    elm = elm.parentNode;
  }
  return false;
}

/**
 * Listen for a new tab to open and return a promise that resolves when one
 * does and completes the load event.
 *
 * @return a promise that resolves to the tab object
 */
var waitForTab = async function() {
  info("Waiting for a tab to open");
  await once(gBrowser.tabContainer, "TabOpen");
  const tab = gBrowser.selectedTab;
  await BrowserTestUtils.browserLoaded(tab.linkedBrowser);
  info("The tab load completed");
  return tab;
};

/**
 * Wait for a predicate to return a result.
 *
 * @param {Function} condition
 *        Invoked once in a while until it returns a truthy value. This should be an
 *        idempotent function, since we have to run it a second time after it returns
 *        true in order to return the value.
 * @param {String} message [optional]
 *        A message to output if the condition fails.
 * @param {Number} interval [optional]
 *        How often the predicate is invoked, in milliseconds.
 * @return {Object}
 *         A promise that is resolved with the result of the condition.
 */
async function waitFor(
  condition,
  message = "waitFor",
  interval = 10,
  maxTries = 500
) {
  await BrowserTestUtils.waitForCondition(
    condition,
    message,
    interval,
    maxTries
  );
  return condition();
}

/**
 * Simulate the key input for the given input in the window.
 *
 * @param {String} input
 *        The string value to input
 * @param {Window} win
 *        The window containing the panel
 */
function synthesizeKeys(input, win) {
  for (const key of input.split("")) {
    EventUtils.synthesizeKey(key, {}, win);
  }
}

/**
 * Make sure window is properly focused before sending a key event.
 *
 * @param {Window} win
 *        The window containing the panel
 * @param {String} key
 *        The string value to input
 */
function focusAndSendKey(win, key) {
  win.document.documentElement.focus();
  EventUtils.sendKey(key, win);
}

/**
 * Given a Tooltip instance, fake a mouse event on the `target` DOM Element
 * and assert that the `tooltip` is correctly displayed.
 *
 * @param {Tooltip} tooltip
 *        The tooltip instance
 * @param {DOMElement} target
 *        The DOM Element on which a tooltip should appear
 *
 * @return a promise that resolves with the tooltip object
 */
async function assertTooltipShownOnHover(tooltip, target) {
  const mouseEvent = new target.ownerDocument.defaultView.MouseEvent(
    "mousemove",
    {
      bubbles: true,
    }
  );
  target.dispatchEvent(mouseEvent);

  if (!tooltip.isVisible()) {
    info("Waiting for tooltip to be shown");
    await tooltip.once("shown");
  }

  ok(tooltip.isVisible(), `The tooltip is visible`);

  return tooltip;
}

/**
 * Given an inspector `view` object, fake a mouse event on the `target` DOM
 * Element and assert that the preview tooltip  is correctly displayed.
 *
 * @param {CssRuleView|ComputedView|...} view
 *        The instance of an inspector panel
 * @param {DOMElement} target
 *        The DOM Element on which a tooltip should appear
 *
 * @return a promise that resolves with the tooltip object
 */
async function assertShowPreviewTooltip(view, target) {
  const name = "previewTooltip";

  // Get the tooltip. If it does not exist one will be created.
  const tooltip = view.tooltips.getTooltip(name);
  ok(tooltip, `Tooltip '${name}' has been instantiated`);

  const shown = tooltip.once("shown");
  const mouseEvent = new target.ownerDocument.defaultView.MouseEvent(
    "mousemove",
    {
      bubbles: true,
    }
  );
  target.dispatchEvent(mouseEvent);

  info("Waiting for tooltip to be shown");
  await shown;

  ok(tooltip.isVisible(), `The tooltip '${name}' is visible`);

  return tooltip;
}

/**
 * Given a `tooltip` instance, fake a mouse event on `target` DOM element
 * and check that the tooltip correctly disappear.
 *
 * @param {Tooltip} tooltip
 *        The tooltip instance
 * @param {DOMElement} target
 *        The DOM Element on which a tooltip should appear
 */
async function assertTooltipHiddenOnMouseOut(tooltip, target) {
  // The tooltip actually relies on mousemove events to check if it sould be hidden.
  const mouseEvent = new target.ownerDocument.defaultView.MouseEvent(
    "mousemove",
    {
      bubbles: true,
      relatedTarget: target,
    }
  );
  target.parentNode.dispatchEvent(mouseEvent);

  await tooltip.once("hidden");

  ok(!tooltip.isVisible(), "The tooltip is hidden on mouseout");
}

/**
 * Get the rule editor from the rule-view given its index
 *
 * @param {CssRuleView} view
 *        The instance of the rule-view panel
 * @param {Number} childrenIndex
 *        The children index of the element to get
 * @param {Number} nodeIndex
 *        The child node index of the element to get
 * @return {DOMNode} The rule editor if any at this index
 */
function getRuleViewRuleEditor(view, childrenIndex, nodeIndex) {
  return nodeIndex !== undefined
    ? view.element.children[childrenIndex].childNodes[nodeIndex]._ruleEditor
    : view.element.children[childrenIndex]._ruleEditor;
}

/**
 * Get the text displayed for a given DOM Element's textContent within the
 * markup view.
 *
 * @param {String} selector
 * @param {InspectorPanel} inspector
 * @return {String} The text displayed in the markup view
 */
async function getDisplayedNodeTextContent(selector, inspector) {
  // We have to ensure that the textContent is displayed, for that the DOM
  // Element has to be selected in the markup view and to be expanded.
  await selectNode(selector, inspector);

  const container = await getContainerForSelector(selector, inspector);
  await inspector.markup.expandNode(container.node);
  await waitForMultipleChildrenUpdates(inspector);
  if (container) {
    const textContainer = container.elt.querySelector("pre");
    return textContainer.textContent;
  }
  return null;
}

/**
 * Toggle the shapes highlighter by simulating a click on the toggle
 * in the rules view with the given selector and property
 *
 * @param {CssRuleView} view
 *        The instance of the rule-view panel
 * @param {String} selector
 *        The selector in the rule-view to look for the property in
 * @param {String} property
 *        The name of the property
 * @param {Boolean} show
 *        If true, the shapes highlighter is being shown. If false, it is being hidden
 * @param {Options} options
 *        Config option for the shapes highlighter. Contains:
 *        - {Boolean} transformMode: whether to show the highlighter in transforms mode
 */
async function toggleShapesHighlighter(
  view,
  selector,
  property,
  show,
  options = {}
) {
  info(
    `Toggle shapes highlighter ${
      show ? "on" : "off"
    } for ${property} on ${selector}`
  );
  const highlighters = view.highlighters;
  const container = getRuleViewProperty(view, selector, property).valueSpan;
  const shapesToggle = container.querySelector(".ruleview-shapeswatch");

  const metaKey = options.transformMode;
  const ctrlKey = options.transformMode;

  if (show) {
    const onHighlighterShown = highlighters.once("shapes-highlighter-shown");
    EventUtils.sendMouseEvent(
      { type: "click", metaKey, ctrlKey },
      shapesToggle,
      view.styleWindow
    );
    await onHighlighterShown;
  } else {
    const onHighlighterHidden = highlighters.once("shapes-highlighter-hidden");
    EventUtils.sendMouseEvent(
      { type: "click", metaKey, ctrlKey },
      shapesToggle,
      view.styleWindow
    );
    await onHighlighterHidden;
  }
}

/**
 * Expand the provided markup container programatically and  wait for all children to
 * update.
 */
async function expandContainer(inspector, container) {
  await inspector.markup.expandNode(container.node);
  await waitForMultipleChildrenUpdates(inspector);
}

/**
 * Expand the provided markup container by clicking on the expand arrow and waiting for
 * inspector and children to update. Similar to expandContainer helper, but this method
 * uses a click rather than programatically calling expandNode().
 */
async function expandContainerByClick(inspector, container) {
  const onChildren = waitForChildrenUpdated(inspector);
  const onUpdated = inspector.once("inspector-updated");
  EventUtils.synthesizeMouseAtCenter(
    container.expander,
    {},
    inspector.markup.doc.defaultView
  );
  await onChildren;
  await onUpdated;
}

/**
 * Simulate a color change in a given color picker tooltip.
 *
 * @param  {Spectrum} colorPicker
 *         The color picker widget.
 * @param  {Array} newRgba
 *         Array of the new rgba values to be set in the color widget.
 */
async function simulateColorPickerChange(colorPicker, newRgba) {
  info("Getting the spectrum colorpicker object");
  const spectrum = await colorPicker.spectrum;
  info("Setting the new color");
  spectrum.rgb = newRgba;
  info("Applying the change");
  spectrum.updateUI();
  spectrum.onChange();
}
