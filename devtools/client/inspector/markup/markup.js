/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const promise = require("promise");
const Services = require("Services");
const defer = require("devtools/shared/defer");
const {Task} = require("devtools/shared/task");
const nodeConstants = require("devtools/shared/dom-node-constants");
const nodeFilterConstants = require("devtools/shared/dom-node-filter-constants");
const EventEmitter = require("devtools/shared/event-emitter");
const {LocalizationHelper} = require("devtools/shared/l10n");
const {PluralForm} = require("devtools/shared/plural-form");
const {template} = require("devtools/shared/gcli/templater");
const {AutocompletePopup} = require("devtools/client/shared/autocomplete-popup");
const {KeyShortcuts} = require("devtools/client/shared/key-shortcuts");
const {scrollIntoViewIfNeeded} = require("devtools/client/shared/scroll");
const {UndoStack} = require("devtools/client/shared/undo");
const {HTMLTooltip} = require("devtools/client/shared/widgets/tooltip/HTMLTooltip");
const {PrefObserver} = require("devtools/client/styleeditor/utils");
const HTMLEditor = require("devtools/client/inspector/markup/views/html-editor");
const MarkupElementContainer = require("devtools/client/inspector/markup/views/element-container");
const MarkupReadOnlyContainer = require("devtools/client/inspector/markup/views/read-only-container");
const MarkupTextContainer = require("devtools/client/inspector/markup/views/text-container");
const RootContainer = require("devtools/client/inspector/markup/views/root-container");

const INSPECTOR_L10N =
      new LocalizationHelper("devtools/client/locales/inspector.properties");

// Page size for pageup/pagedown
const PAGE_SIZE = 10;
const DEFAULT_MAX_CHILDREN = 100;
const NEW_SELECTION_HIGHLIGHTER_TIMER = 1000;
const DRAG_DROP_AUTOSCROLL_EDGE_MAX_DISTANCE = 50;
const DRAG_DROP_AUTOSCROLL_EDGE_RATIO = 0.1;
const DRAG_DROP_MIN_AUTOSCROLL_SPEED = 2;
const DRAG_DROP_MAX_AUTOSCROLL_SPEED = 8;
const DRAG_DROP_HEIGHT_TO_SPEED = 500;
const DRAG_DROP_HEIGHT_TO_SPEED_MIN = 0.5;
const DRAG_DROP_HEIGHT_TO_SPEED_MAX = 1;
const ATTR_COLLAPSE_ENABLED_PREF = "devtools.markup.collapseAttributes";
const ATTR_COLLAPSE_LENGTH_PREF = "devtools.markup.collapseAttributeLength";

/**
 * Vocabulary for the purposes of this file:
 *
 * MarkupContainer - the structure that holds an editor and its
 *  immediate children in the markup panel.
 *  - MarkupElementContainer: markup container for element nodes
 *  - MarkupTextContainer: markup container for text / comment nodes
 *  - MarkupReadonlyContainer: markup container for other nodes
 * Node - A content node.
 * object.elt - A UI element in the markup panel.
 */

/**
 * The markup tree.  Manages the mapping of nodes to MarkupContainers,
 * updating based on mutations, and the undo/redo bindings.
 *
 * @param  {Inspector} inspector
 *         The inspector we're watching.
 * @param  {iframe} frame
 *         An iframe in which the caller has kindly loaded markup.xhtml.
 */
function MarkupView(inspector, frame, controllerWindow) {
  this.inspector = inspector;
  this.walker = this.inspector.walker;
  this._frame = frame;
  this.win = this._frame.contentWindow;
  this.doc = this._frame.contentDocument;
  this._elt = this.doc.querySelector("#root");
  this.htmlEditor = new HTMLEditor(this.doc);

  try {
    this.maxChildren = Services.prefs.getIntPref("devtools.markup.pagesize");
  } catch (ex) {
    this.maxChildren = DEFAULT_MAX_CHILDREN;
  }

  this.collapseAttributes =
    Services.prefs.getBoolPref(ATTR_COLLAPSE_ENABLED_PREF);
  this.collapseAttributeLength =
    Services.prefs.getIntPref(ATTR_COLLAPSE_LENGTH_PREF);

  // Creating the popup to be used to show CSS suggestions.
  // The popup will be attached to the toolbox document.
  this.popup = new AutocompletePopup(inspector.toolbox.doc, {
    autoSelect: true,
    theme: "auto",
  });

  this.undo = new UndoStack();
  this.undo.installController(controllerWindow);

  this._containers = new Map();

  // Binding functions that need to be called in scope.
  this._handleRejectionIfNotDestroyed = this._handleRejectionIfNotDestroyed.bind(this);
  this._mutationObserver = this._mutationObserver.bind(this);
  this._onDisplayChange = this._onDisplayChange.bind(this);
  this._onMouseClick = this._onMouseClick.bind(this);
  this._onMouseUp = this._onMouseUp.bind(this);
  this._onNewSelection = this._onNewSelection.bind(this);
  this._onCopy = this._onCopy.bind(this);
  this._onFocus = this._onFocus.bind(this);
  this._onMouseMove = this._onMouseMove.bind(this);
  this._onMouseOut = this._onMouseOut.bind(this);
  this._onToolboxPickerCanceled = this._onToolboxPickerCanceled.bind(this);
  this._onToolboxPickerHover = this._onToolboxPickerHover.bind(this);
  this._onCollapseAttributesPrefChange =
    this._onCollapseAttributesPrefChange.bind(this);
  this._isImagePreviewTarget = this._isImagePreviewTarget.bind(this);
  this._onBlur = this._onBlur.bind(this);

  EventEmitter.decorate(this);

  // Listening to various events.
  this._elt.addEventListener("click", this._onMouseClick, false);
  this._elt.addEventListener("mousemove", this._onMouseMove, false);
  this._elt.addEventListener("mouseout", this._onMouseOut, false);
  this._elt.addEventListener("blur", this._onBlur, true);
  this.win.addEventListener("mouseup", this._onMouseUp);
  this.win.addEventListener("copy", this._onCopy);
  this._frame.addEventListener("focus", this._onFocus, false);
  this.walker.on("mutations", this._mutationObserver);
  this.walker.on("display-change", this._onDisplayChange);
  this.inspector.selection.on("new-node-front", this._onNewSelection);
  this.toolbox.on("picker-canceled", this._onToolboxPickerCanceled);
  this.toolbox.on("picker-node-hovered", this._onToolboxPickerHover);

  this._onNewSelection();
  this._initTooltips();

  this._prefObserver = new PrefObserver("devtools.markup");
  this._prefObserver.on(ATTR_COLLAPSE_ENABLED_PREF,
                        this._onCollapseAttributesPrefChange);
  this._prefObserver.on(ATTR_COLLAPSE_LENGTH_PREF,
                        this._onCollapseAttributesPrefChange);

  this._initShortcuts();
}

MarkupView.prototype = {
  /**
   * How long does a node flash when it mutates (in ms).
   */
  CONTAINER_FLASHING_DURATION: 500,

  _selectedContainer: null,

  get toolbox() {
    return this.inspector.toolbox;
  },

  /**
   * Handle promise rejections for various asynchronous actions, and only log errors if
   * the markup view still exists.
   * This is useful to silence useless errors that happen when the markup view is
   * destroyed while still initializing (and making protocol requests).
   */
  _handleRejectionIfNotDestroyed: function (e) {
    if (!this._destroyer) {
      console.error(e);
    }
  },

  _initTooltips: function () {
    // The tooltips will be attached to the toolbox document.
    this.eventDetailsTooltip = new HTMLTooltip(this.toolbox.doc,
      {type: "arrow"});
    this.imagePreviewTooltip = new HTMLTooltip(this.toolbox.doc,
      {type: "arrow", useXulWrapper: "true"});
    this._enableImagePreviewTooltip();
  },

  _enableImagePreviewTooltip: function () {
    this.imagePreviewTooltip.startTogglingOnHover(this._elt,
      this._isImagePreviewTarget);
  },

  _disableImagePreviewTooltip: function () {
    this.imagePreviewTooltip.stopTogglingOnHover();
  },

  _onToolboxPickerHover: function (event, nodeFront) {
    this.showNode(nodeFront).then(() => {
      this._showContainerAsHovered(nodeFront);
    }, e => console.error(e));
  },

  /**
   * If the element picker gets canceled, make sure and re-center the view on the
   * current selected element.
   */
  _onToolboxPickerCanceled: function () {
    if (this._selectedContainer) {
      scrollIntoViewIfNeeded(this._selectedContainer.editor.elt);
    }
  },

  isDragging: false,

  _onMouseMove: function (event) {
    let target = event.target;

    // Auto-scroll if we're dragging.
    if (this.isDragging) {
      event.preventDefault();
      this._autoScroll(event);
      return;
    }

    // Show the current container as hovered and highlight it.
    // This requires finding the current MarkupContainer (walking up the DOM).
    while (!target.container) {
      if (target.tagName.toLowerCase() === "body") {
        return;
      }
      target = target.parentNode;
    }

    let container = target.container;
    if (this._hoveredNode !== container.node) {
      this._showBoxModel(container.node);
    }
    this._showContainerAsHovered(container.node);

    this.emit("node-hover");
  },

  /**
   * If focus is moved outside of the markup view document and there is a
   * selected container, make its contents not focusable by a keyboard.
   */
  _onBlur: function (event) {
    if (!this._selectedContainer) {
      return;
    }

    let {relatedTarget} = event;
    if (relatedTarget && relatedTarget.ownerDocument === this.doc) {
      return;
    }

    if (this._selectedContainer) {
      this._selectedContainer.clearFocus();
    }
  },

  /**
   * Executed on each mouse-move while a node is being dragged in the view.
   * Auto-scrolls the view to reveal nodes below the fold to drop the dragged
   * node in.
   */
  _autoScroll: function (event) {
    let docEl = this.doc.documentElement;

    if (this._autoScrollAnimationFrame) {
      this.win.cancelAnimationFrame(this._autoScrollAnimationFrame);
    }

    // Auto-scroll when the mouse approaches top/bottom edge.
    let fromBottom = docEl.clientHeight - event.pageY + this.win.scrollY;
    let fromTop = event.pageY - this.win.scrollY;
    let edgeDistance = Math.min(DRAG_DROP_AUTOSCROLL_EDGE_MAX_DISTANCE,
           docEl.clientHeight * DRAG_DROP_AUTOSCROLL_EDGE_RATIO);

    // The smaller the screen, the slower the movement.
    let heightToSpeedRatio =
      Math.max(DRAG_DROP_HEIGHT_TO_SPEED_MIN,
        Math.min(DRAG_DROP_HEIGHT_TO_SPEED_MAX,
          docEl.clientHeight / DRAG_DROP_HEIGHT_TO_SPEED));

    if (fromBottom <= edgeDistance) {
      // Map our distance range to a speed range so that the speed is not too
      // fast or too slow.
      let speed = map(
        fromBottom,
        0, edgeDistance,
        DRAG_DROP_MIN_AUTOSCROLL_SPEED, DRAG_DROP_MAX_AUTOSCROLL_SPEED);

      this._runUpdateLoop(() => {
        docEl.scrollTop -= heightToSpeedRatio *
          (speed - DRAG_DROP_MAX_AUTOSCROLL_SPEED);
      });
    }

    if (fromTop <= edgeDistance) {
      let speed = map(
        fromTop,
        0, edgeDistance,
        DRAG_DROP_MIN_AUTOSCROLL_SPEED, DRAG_DROP_MAX_AUTOSCROLL_SPEED);

      this._runUpdateLoop(() => {
        docEl.scrollTop += heightToSpeedRatio *
          (speed - DRAG_DROP_MAX_AUTOSCROLL_SPEED);
      });
    }
  },

  /**
   * Run a loop on the requestAnimationFrame.
   */
  _runUpdateLoop: function (update) {
    let loop = () => {
      update();
      this._autoScrollAnimationFrame = this.win.requestAnimationFrame(loop);
    };
    loop();
  },

  _onMouseClick: function (event) {
    // From the target passed here, let's find the parent MarkupContainer
    // and ask it if the tooltip should be shown
    let parentNode = event.target;
    let container;
    while (parentNode !== this.doc.body) {
      if (parentNode.container) {
        container = parentNode.container;
        break;
      }
      parentNode = parentNode.parentNode;
    }

    if (container instanceof MarkupElementContainer) {
      // With the newly found container, delegate the tooltip content creation
      // and decision to show or not the tooltip
      container._buildEventTooltipContent(event.target,
        this.eventDetailsTooltip);
    }
  },

  _onMouseUp: function () {
    this.indicateDropTarget(null);
    this.indicateDragTarget(null);
    if (this._autoScrollAnimationFrame) {
      this.win.cancelAnimationFrame(this._autoScrollAnimationFrame);
    }
  },

  _onCollapseAttributesPrefChange: function () {
    this.collapseAttributes =
      Services.prefs.getBoolPref(ATTR_COLLAPSE_ENABLED_PREF);
    this.collapseAttributeLength =
      Services.prefs.getIntPref(ATTR_COLLAPSE_LENGTH_PREF);
    this.update();
  },

  cancelDragging: function () {
    if (!this.isDragging) {
      return;
    }

    for (let [, container] of this._containers) {
      if (container.isDragging) {
        container.cancelDragging();
        break;
      }
    }

    this.indicateDropTarget(null);
    this.indicateDragTarget(null);
    if (this._autoScrollAnimationFrame) {
      this.win.cancelAnimationFrame(this._autoScrollAnimationFrame);
    }
  },

  _hoveredNode: null,

  /**
   * Show a NodeFront's container as being hovered
   *
   * @param  {NodeFront} nodeFront
   *         The node to show as hovered
   */
  _showContainerAsHovered: function (nodeFront) {
    if (this._hoveredNode === nodeFront) {
      return;
    }

    if (this._hoveredNode) {
      this.getContainer(this._hoveredNode).hovered = false;
    }

    this.getContainer(nodeFront).hovered = true;
    this._hoveredNode = nodeFront;
    // Emit an event that the container view is actually hovered now, as this function
    // can be called by an asynchronous caller.
    this.emit("showcontainerhovered");
  },

  _onMouseOut: function (event) {
    // Emulate mouseleave by skipping any relatedTarget inside the markup-view.
    if (this._elt.contains(event.relatedTarget)) {
      return;
    }

    if (this._autoScrollAnimationFrame) {
      this.win.cancelAnimationFrame(this._autoScrollAnimationFrame);
    }
    if (this.isDragging) {
      return;
    }

    this._hideBoxModel(true);
    if (this._hoveredNode) {
      this.getContainer(this._hoveredNode).hovered = false;
    }
    this._hoveredNode = null;

    this.emit("leave");
  },

  /**
   * Show the box model highlighter on a given node front
   *
   * @param  {NodeFront} nodeFront
   *         The node to show the highlighter for
   * @return {Promise} Resolves when the highlighter for this nodeFront is
   *         shown, taking into account that there could already be highlighter
   *         requests queued up
   */
  _showBoxModel: function (nodeFront) {
    return this.toolbox.highlighterUtils.highlightNodeFront(nodeFront);
  },

  /**
   * Hide the box model highlighter on a given node front
   *
   * @param  {Boolean} forceHide
   *         See toolbox-highlighter-utils/unhighlight
   * @return {Promise} Resolves when the highlighter for this nodeFront is
   *         hidden, taking into account that there could already be highlighter
   *         requests queued up
   */
  _hideBoxModel: function (forceHide) {
    return this.toolbox.highlighterUtils.unhighlight(forceHide);
  },

  _briefBoxModelTimer: null,

  _clearBriefBoxModelTimer: function () {
    if (this._briefBoxModelTimer) {
      clearTimeout(this._briefBoxModelTimer);
      this._briefBoxModelPromise.resolve();
      this._briefBoxModelPromise = null;
      this._briefBoxModelTimer = null;
    }
  },

  _brieflyShowBoxModel: function (nodeFront) {
    this._clearBriefBoxModelTimer();
    let onShown = this._showBoxModel(nodeFront);
    this._briefBoxModelPromise = defer();

    this._briefBoxModelTimer = setTimeout(() => {
      this._hideBoxModel()
          .then(this._briefBoxModelPromise.resolve,
                this._briefBoxModelPromise.resolve);
    }, NEW_SELECTION_HIGHLIGHTER_TIMER);

    return promise.all([onShown, this._briefBoxModelPromise.promise]);
  },

  template: function (name, dest, options = {stack: "markup.xhtml"}) {
    let node = this.doc.getElementById("template-" + name).cloneNode(true);
    node.removeAttribute("id");
    template(node, dest, options);
    return node;
  },

  /**
   * Get the MarkupContainer object for a given node, or undefined if
   * none exists.
   */
  getContainer: function (node) {
    return this._containers.get(node);
  },

  update: function () {
    let updateChildren = (node) => {
      this.getContainer(node).update();
      for (let child of node.treeChildren()) {
        updateChildren(child);
      }
    };

    // Start with the documentElement
    let documentElement;
    for (let node of this._rootNode.treeChildren()) {
      if (node.isDocumentElement === true) {
        documentElement = node;
        break;
      }
    }

    // Recursively update each node starting with documentElement.
    updateChildren(documentElement);
  },

  /**
   * Executed when the mouse hovers over a target in the markup-view and is used
   * to decide whether this target should be used to display an image preview
   * tooltip.
   * Delegates the actual decision to the corresponding MarkupContainer instance
   * if one is found.
   *
   * @return {Promise} the promise returned by
   *         MarkupElementContainer._isImagePreviewTarget
   */
  _isImagePreviewTarget: Task.async(function* (target) {
    // From the target passed here, let's find the parent MarkupContainer
    // and ask it if the tooltip should be shown
    if (this.isDragging) {
      return false;
    }

    let parent = target, container;
    while (parent !== this.doc.body) {
      if (parent.container) {
        container = parent.container;
        break;
      }
      parent = parent.parentNode;
    }

    if (container instanceof MarkupElementContainer) {
      // With the newly found container, delegate the tooltip content creation
      // and decision to show or not the tooltip
      return container.isImagePreviewTarget(target, this.imagePreviewTooltip);
    }

    return false;
  }),

  /**
   * Given the known reason, should the current selection be briefly highlighted
   * In a few cases, we don't want to highlight the node:
   * - If the reason is null (used to reset the selection),
   * - if it's "inspector-open" (when the inspector opens up, let's not
   * highlight the default node)
   * - if it's "navigateaway" (since the page is being navigated away from)
   * - if it's "test" (this is a special case for mochitest. In tests, we often
   * need to select elements but don't necessarily want the highlighter to come
   * and go after a delay as this might break test scenarios)
   * We also do not want to start a brief highlight timeout if the node is
   * already being hovered over, since in that case it will already be
   * highlighted.
   */
  _shouldNewSelectionBeHighlighted: function () {
    let reason = this.inspector.selection.reason;
    let unwantedReasons = [
      "inspector-open",
      "navigateaway",
      "nodeselected",
      "test"
    ];
    let isHighlight = this._hoveredNode === this.inspector.selection.nodeFront;
    return !isHighlight && reason && unwantedReasons.indexOf(reason) === -1;
  },

  /**
   * React to new-node-front selection events.
   * Highlights the node if needed, and make sure it is shown and selected in
   * the view.
   */
  _onNewSelection: function () {
    let selection = this.inspector.selection;

    this.htmlEditor.hide();
    if (this._hoveredNode && this._hoveredNode !== selection.nodeFront) {
      this.getContainer(this._hoveredNode).hovered = false;
      this._hoveredNode = null;
    }

    if (!selection.isNode()) {
      this.unmarkSelectedNode();
      return;
    }

    let done = this.inspector.updating("markup-view");
    let onShowBoxModel, onShow;

    // Highlight the element briefly if needed.
    if (this._shouldNewSelectionBeHighlighted()) {
      onShowBoxModel = this._brieflyShowBoxModel(selection.nodeFront);
    }

    onShow = this.showNode(selection.nodeFront).then(() => {
      // We could be destroyed by now.
      if (this._destroyer) {
        return promise.reject("markupview destroyed");
      }

      // Mark the node as selected.
      this.markNodeAsSelected(selection.nodeFront);

      // Make sure the new selection is navigated to.
      this.maybeNavigateToNewSelection();
      return undefined;
    }).catch(this._handleRejectionIfNotDestroyed);

    promise.all([onShowBoxModel, onShow]).then(done);
  },

  /**
   * Maybe make selected the current node selection's MarkupContainer depending
   * on why the current node got selected.
   */
  maybeNavigateToNewSelection: function () {
    let {reason, nodeFront} = this.inspector.selection;

    // The list of reasons that should lead to navigating to the node.
    let reasonsToNavigate = [
      // If the user picked an element with the element picker.
      "picker-node-picked",
      // If the user shift-clicked (previewed) an element.
      "picker-node-previewed",
      // If the user selected an element with the browser context menu.
      "browser-context-menu",
      // If the user added a new node by clicking in the inspector toolbar.
      "node-inserted"
    ];

    if (reasonsToNavigate.includes(reason)) {
      this.getContainer(this._rootNode).elt.focus();
      this.navigate(this.getContainer(nodeFront));
    }
  },

  /**
   * Create a TreeWalker to find the next/previous
   * node for selection.
   */
  _selectionWalker: function (start) {
    let walker = this.doc.createTreeWalker(
      start || this._elt,
      nodeFilterConstants.SHOW_ELEMENT,
      function (element) {
        if (element.container &&
            element.container.elt === element &&
            element.container.visible) {
          return nodeFilterConstants.FILTER_ACCEPT;
        }
        return nodeFilterConstants.FILTER_SKIP;
      }
    );
    walker.currentNode = this._selectedContainer.elt;
    return walker;
  },

  _onCopy: function (evt) {
    // Ignore copy events from editors
    if (this._isInputOrTextarea(evt.target)) {
      return;
    }

    let selection = this.inspector.selection;
    if (selection.isNode()) {
      this.inspector.copyOuterHTML();
    }
    evt.stopPropagation();
    evt.preventDefault();
  },

  /**
   * Register all key shortcuts.
   */
  _initShortcuts: function () {
    let shortcuts = new KeyShortcuts({
      window: this.win,
    });

    this._onShortcut = this._onShortcut.bind(this);

    // Process localizable keys
    ["markupView.hide.key",
     "markupView.edit.key",
     "markupView.scrollInto.key"].forEach(name => {
       let key = INSPECTOR_L10N.getStr(name);
       shortcuts.on(key, (_, event) => this._onShortcut(name, event));
     });

    // Process generic keys:
    ["Delete", "Backspace", "Home", "Left", "Right", "Up", "Down", "PageUp",
     "PageDown", "Esc", "Enter", "Space"].forEach(key => {
       shortcuts.on(key, this._onShortcut);
     });
  },

  /**
   * Key shortcut listener.
   */
  _onShortcut(name, event) {
    if (this._isInputOrTextarea(event.target)) {
      return;
    }
    switch (name) {
      // Localizable keys
      case "markupView.hide.key": {
        let node = this._selectedContainer.node;
        if (node.hidden) {
          this.walker.unhideNode(node);
        } else {
          this.walker.hideNode(node);
        }
        break;
      }
      case "markupView.edit.key": {
        this.beginEditingOuterHTML(this._selectedContainer.node);
        break;
      }
      case "markupView.scrollInto.key": {
        let selection = this._selectedContainer.node;
        this.inspector.scrollNodeIntoView(selection);
        break;
      }
      // Generic keys
      case "Delete": {
        this.deleteNodeOrAttribute();
        break;
      }
      case "Backspace": {
        this.deleteNodeOrAttribute(true);
        break;
      }
      case "Home": {
        let rootContainer = this.getContainer(this._rootNode);
        this.navigate(rootContainer.children.firstChild.container);
        break;
      }
      case "Left": {
        if (this._selectedContainer.expanded) {
          this.collapseNode(this._selectedContainer.node);
        } else {
          let parent = this._selectionWalker().parentNode();
          if (parent) {
            this.navigate(parent.container);
          }
        }
        break;
      }
      case "Right": {
        if (!this._selectedContainer.expanded &&
            this._selectedContainer.hasChildren) {
          this._expandContainer(this._selectedContainer);
        } else {
          let next = this._selectionWalker().nextNode();
          if (next) {
            this.navigate(next.container);
          }
        }
        break;
      }
      case "Up": {
        let previousNode = this._selectionWalker().previousNode();
        if (previousNode) {
          this.navigate(previousNode.container);
        }
        break;
      }
      case "Down": {
        let nextNode = this._selectionWalker().nextNode();
        if (nextNode) {
          this.navigate(nextNode.container);
        }
        break;
      }
      case "PageUp": {
        let walker = this._selectionWalker();
        let selection = this._selectedContainer;
        for (let i = 0; i < PAGE_SIZE; i++) {
          let previousNode = walker.previousNode();
          if (!previousNode) {
            break;
          }
          selection = previousNode.container;
        }
        this.navigate(selection);
        break;
      }
      case "PageDown": {
        let walker = this._selectionWalker();
        let selection = this._selectedContainer;
        for (let i = 0; i < PAGE_SIZE; i++) {
          let nextNode = walker.nextNode();
          if (!nextNode) {
            break;
          }
          selection = nextNode.container;
        }
        this.navigate(selection);
        break;
      }
      case "Enter":
      case "Space": {
        if (!this._selectedContainer.canFocus) {
          this._selectedContainer.canFocus = true;
          this._selectedContainer.focus();
        } else {
          // Return early to prevent cancelling the event.
          return;
        }
        break;
      }
      case "Esc": {
        if (this.isDragging) {
          this.cancelDragging();
        } else {
          // Return early to prevent cancelling the event when not
          // dragging, to allow the split console to be toggled.
          return;
        }
        break;
      }
      default:
        console.error("Unexpected markup-view key shortcut", name);
        return;
    }
    // Prevent default for this action
    event.stopPropagation();
    event.preventDefault();
  },

  /**
   * Check if a node is an input or textarea
   */
  _isInputOrTextarea: function (element) {
    let name = element.tagName.toLowerCase();
    return name === "input" || name === "textarea";
  },

  /**
   * If there's an attribute on the current node that's currently focused, then
   * delete this attribute, otherwise delete the node itself.
   *
   * @param  {Boolean} moveBackward
   *         If set to true and if we're deleting the node, focus the previous
   *         sibling after deletion, otherwise the next one.
   */
  deleteNodeOrAttribute: function (moveBackward) {
    let focusedAttribute = this.doc.activeElement
                           ? this.doc.activeElement.closest(".attreditor")
                           : null;
    if (focusedAttribute) {
      // The focused attribute might not be in the current selected container.
      let container = focusedAttribute.closest("li.child").container;
      container.removeAttribute(focusedAttribute.dataset.attr);
    } else {
      this.deleteNode(this._selectedContainer.node, moveBackward);
    }
  },

  /**
   * Delete a node from the DOM.
   * This is an undoable action.
   *
   * @param  {NodeFront} node
   *         The node to remove.
   * @param  {Boolean} moveBackward
   *         If set to true, focus the previous sibling, otherwise the next one.
   */
  deleteNode: function (node, moveBackward) {
    if (node.isDocumentElement ||
        node.nodeType == nodeConstants.DOCUMENT_TYPE_NODE ||
        node.isAnonymous) {
      return;
    }

    let container = this.getContainer(node);

    // Retain the node so we can undo this...
    this.walker.retainNode(node).then(() => {
      let parent = node.parentNode();
      let nextSibling = null;
      this.undo.do(() => {
        this.walker.removeNode(node).then(siblings => {
          nextSibling = siblings.nextSibling;
          let prevSibling = siblings.previousSibling;
          let focusNode = moveBackward ? prevSibling : nextSibling;

          // If we can't move as the user wants, we move to the other direction.
          // If there is no sibling elements anymore, move to the parent node.
          if (!focusNode) {
            focusNode = nextSibling || prevSibling || parent;
          }

          let isNextSiblingText = nextSibling ?
            nextSibling.nodeType === nodeConstants.TEXT_NODE : false;
          let isPrevSiblingText = prevSibling ?
            prevSibling.nodeType === nodeConstants.TEXT_NODE : false;

          // If the parent had two children and the next or previous sibling
          // is a text node, then it now has only a single text node, is about
          // to be in-lined; and focus should move to the parent.
          if (parent.numChildren === 2
              && (isNextSiblingText || isPrevSiblingText)) {
            focusNode = parent;
          }

          if (container.selected) {
            this.navigate(this.getContainer(focusNode));
          }
        });
      }, () => {
        let isValidSibling = nextSibling && !nextSibling.isPseudoElement;
        nextSibling = isValidSibling ? nextSibling : null;
        this.walker.insertBefore(node, parent, nextSibling);
      });
    }).then(null, console.error);
  },

  /**
   * If an editable item is focused, select its container.
   */
  _onFocus: function (event) {
    let parent = event.target;
    while (!parent.container) {
      parent = parent.parentNode;
    }
    if (parent) {
      this.navigate(parent.container);
    }
  },

  /**
   * Handle a user-requested navigation to a given MarkupContainer,
   * updating the inspector's currently-selected node.
   *
   * @param  {MarkupContainer} container
   *         The container we're navigating to.
   */
  navigate: function (container) {
    if (!container) {
      return;
    }

    let node = container.node;
    this.markNodeAsSelected(node, "treepanel");
  },

  /**
   * Make sure a node is included in the markup tool.
   *
   * @param  {NodeFront} node
   *         The node in the content document.
   * @param  {Boolean} flashNode
   *         Whether the newly imported node should be flashed
   * @return {MarkupContainer} The MarkupContainer object for this element.
   */
  importNode: function (node, flashNode) {
    if (!node) {
      return null;
    }

    if (this._containers.has(node)) {
      return this.getContainer(node);
    }

    let container;
    let {nodeType, isPseudoElement} = node;
    if (node === this.walker.rootNode) {
      container = new RootContainer(this, node);
      this._elt.appendChild(container.elt);
      this._rootNode = node;
    } else if (nodeType == nodeConstants.ELEMENT_NODE && !isPseudoElement) {
      container = new MarkupElementContainer(this, node, this.inspector);
    } else if (nodeType == nodeConstants.COMMENT_NODE ||
               nodeType == nodeConstants.TEXT_NODE) {
      container = new MarkupTextContainer(this, node, this.inspector);
    } else {
      container = new MarkupReadOnlyContainer(this, node, this.inspector);
    }

    if (flashNode) {
      container.flashMutation();
    }

    this._containers.set(node, container);
    container.childrenDirty = true;

    this._updateChildren(container);

    this.inspector.emit("container-created", container);

    return container;
  },

  /**
   * Mutation observer used for included nodes.
   */
  _mutationObserver: function (mutations) {
    for (let mutation of mutations) {
      let type = mutation.type;
      let target = mutation.target;

      if (mutation.type === "documentUnload") {
        // Treat this as a childList change of the child (maybe the protocol
        // should do this).
        type = "childList";
        target = mutation.targetParent;
        if (!target) {
          continue;
        }
      }

      let container = this.getContainer(target);
      if (!container) {
        // Container might not exist if this came from a load event for a node
        // we're not viewing.
        continue;
      }

      if (type === "attributes" && mutation.attributeName === "class") {
        container.updateIsDisplayed();
      }
      if (type === "attributes" || type === "characterData"
        || type === "events" || type === "pseudoClassLock") {
        container.update();
      } else if (type === "childList" || type === "nativeAnonymousChildList") {
        container.childrenDirty = true;
        // Update the children to take care of changes in the markup view DOM
        // and update container (and its subtree) DOM tree depth level for
        // accessibility where necessary.
        this._updateChildren(container, {flash: true}).then(() =>
          container.updateLevel());
      } else if (type === "inlineTextChild") {
        container.childrenDirty = true;
        this._updateChildren(container, {flash: true});
        container.update();
      }
    }

    this._waitForChildren().then(() => {
      if (this._destroyer) {
        // Could not fully update after markup mutations, the markup-view was destroyed
        // while waiting for children. Bail out silently.
        return;
      }
      this._flashMutatedNodes(mutations);
      this.inspector.emit("markupmutation", mutations);

      // Since the htmlEditor is absolutely positioned, a mutation may change
      // the location in which it should be shown.
      this.htmlEditor.refresh();
    });
  },

  /**
   * React to display-change events from the walker
   *
   * @param  {Array} nodes
   *         An array of nodeFronts
   */
  _onDisplayChange: function (nodes) {
    for (let node of nodes) {
      let container = this.getContainer(node);
      if (container) {
        container.updateIsDisplayed();
      }
    }
  },

  /**
   * Given a list of mutations returned by the mutation observer, flash the
   * corresponding containers to attract attention.
   */
  _flashMutatedNodes: function (mutations) {
    let addedOrEditedContainers = new Set();
    let removedContainers = new Set();

    for (let {type, target, added, removed, newValue} of mutations) {
      let container = this.getContainer(target);

      if (container) {
        if (type === "characterData") {
          addedOrEditedContainers.add(container);
        } else if (type === "attributes" && newValue === null) {
          // Removed attributes should flash the entire node.
          // New or changed attributes will flash the attribute itself
          // in ElementEditor.flashAttribute.
          addedOrEditedContainers.add(container);
        } else if (type === "childList") {
          // If there has been removals, flash the parent
          if (removed.length) {
            removedContainers.add(container);
          }

          // If there has been additions, flash the nodes if their associated
          // container exist (so if their parent is expanded in the inspector).
          added.forEach(node => {
            let addedContainer = this.getContainer(node);
            if (addedContainer) {
              addedOrEditedContainers.add(addedContainer);

              // The node may be added as a result of an append, in which case
              // it will have been removed from another container first, but in
              // these cases we don't want to flash both the removal and the
              // addition
              removedContainers.delete(container);
            }
          });
        }
      }
    }

    for (let container of removedContainers) {
      container.flashMutation();
    }
    for (let container of addedOrEditedContainers) {
      container.flashMutation();
    }
  },

  /**
   * Make sure the given node's parents are expanded and the
   * node is scrolled on to screen.
   */
  showNode: function (node, centered = true) {
    let parent = node;

    this.importNode(node);

    while ((parent = parent.parentNode())) {
      this.importNode(parent);
      this.expandNode(parent);
    }

    return this._waitForChildren().then(() => {
      if (this._destroyer) {
        return promise.reject("markupview destroyed");
      }
      return this._ensureVisible(node);
    }).then(() => {
      scrollIntoViewIfNeeded(this.getContainer(node).editor.elt, centered);
    }, this._handleRejectionIfNotDestroyed);
  },

  /**
   * Expand the container's children.
   */
  _expandContainer: function (container) {
    return this._updateChildren(container, {expand: true}).then(() => {
      if (this._destroyer) {
        // Could not expand the node, the markup-view was destroyed in the meantime. Just
        // silently give up.
        return;
      }
      container.setExpanded(true);
    });
  },

  /**
   * Expand the node's children.
   */
  expandNode: function (node) {
    let container = this.getContainer(node);
    this._expandContainer(container);
  },

  /**
   * Expand the entire tree beneath a container.
   *
   * @param  {MarkupContainer} container
   *         The container to expand.
   */
  _expandAll: function (container) {
    return this._expandContainer(container).then(() => {
      let child = container.children.firstChild;
      let promises = [];
      while (child) {
        promises.push(this._expandAll(child.container));
        child = child.nextSibling;
      }
      return promise.all(promises);
    }).then(null, console.error);
  },

  /**
   * Expand the entire tree beneath a node.
   *
   * @param  {DOMNode} node
   *         The node to expand, or null to start from the top.
   */
  expandAll: function (node) {
    node = node || this._rootNode;
    return this._expandAll(this.getContainer(node));
  },

  /**
   * Collapse the node's children.
   */
  collapseNode: function (node) {
    let container = this.getContainer(node);
    container.setExpanded(false);
  },

  /**
   * Returns either the innerHTML or the outerHTML for a remote node.
   *
   * @param  {NodeFront} node
   *         The NodeFront to get the outerHTML / innerHTML for.
   * @param  {Boolean} isOuter
   *         If true, makes the function return the outerHTML,
   *         otherwise the innerHTML.
   * @return {Promise} that will be resolved with the outerHTML / innerHTML.
   */
  _getNodeHTML: function (node, isOuter) {
    let walkerPromise = null;

    if (isOuter) {
      walkerPromise = this.walker.outerHTML(node);
    } else {
      walkerPromise = this.walker.innerHTML(node);
    }

    return walkerPromise.then(longstr => {
      return longstr.string().then(html => {
        longstr.release().then(null, console.error);
        return html;
      });
    });
  },

  /**
   * Retrieve the outerHTML for a remote node.
   *
   * @param  {NodeFront} node
   *         The NodeFront to get the outerHTML for.
   * @return {Promise} that will be resolved with the outerHTML.
   */
  getNodeOuterHTML: function (node) {
    return this._getNodeHTML(node, true);
  },

  /**
   * Retrieve the innerHTML for a remote node.
   *
   * @param  {NodeFront} node
   *         The NodeFront to get the innerHTML for.
   * @return {Promise} that will be resolved with the innerHTML.
   */
  getNodeInnerHTML: function (node) {
    return this._getNodeHTML(node);
  },

  /**
   * Listen to mutations, expect a given node to be removed and try and select
   * the node that sits at the same place instead.
   * This is useful when changing the outerHTML or the tag name so that the
   * newly inserted node gets selected instead of the one that just got removed.
   */
  reselectOnRemoved: function (removedNode, reason) {
    // Only allow one removed node reselection at a time, so that when there are
    // more than 1 request in parallel, the last one wins.
    this.cancelReselectOnRemoved();

    // Get the removedNode index in its parent node to reselect the right node.
    let isHTMLTag = removedNode.tagName.toLowerCase() === "html";
    let oldContainer = this.getContainer(removedNode);
    let parentContainer = this.getContainer(removedNode.parentNode());
    let childIndex = parentContainer.getChildContainers().indexOf(oldContainer);

    let onMutations = this._removedNodeObserver = (e, mutations) => {
      let isNodeRemovalMutation = false;
      for (let mutation of mutations) {
        let containsRemovedNode = mutation.removed &&
                                  mutation.removed.some(n => n === removedNode);
        if (mutation.type === "childList" &&
            (containsRemovedNode || isHTMLTag)) {
          isNodeRemovalMutation = true;
          break;
        }
      }
      if (!isNodeRemovalMutation) {
        return;
      }

      this.inspector.off("markupmutation", onMutations);
      this._removedNodeObserver = null;

      // Don't select the new node if the user has already changed the current
      // selection.
      if (this.inspector.selection.nodeFront === parentContainer.node ||
          (this.inspector.selection.nodeFront === removedNode && isHTMLTag)) {
        let childContainers = parentContainer.getChildContainers();
        if (childContainers && childContainers[childIndex]) {
          this.markNodeAsSelected(childContainers[childIndex].node, reason);
          if (childContainers[childIndex].hasChildren) {
            this.expandNode(childContainers[childIndex].node);
          }
          this.emit("reselectedonremoved");
        }
      }
    };

    // Start listening for mutations until we find a childList change that has
    // removedNode removed.
    this.inspector.on("markupmutation", onMutations);
  },

  /**
   * Make sure to stop listening for node removal markupmutations and not
   * reselect the corresponding node when that happens.
   * Useful when the outerHTML/tagname edition failed.
   */
  cancelReselectOnRemoved: function () {
    if (this._removedNodeObserver) {
      this.inspector.off("markupmutation", this._removedNodeObserver);
      this._removedNodeObserver = null;
      this.emit("canceledreselectonremoved");
    }
  },

  /**
   * Replace the outerHTML of any node displayed in the inspector with
   * some other HTML code
   *
   * @param  {NodeFront} node
   *         Node which outerHTML will be replaced.
   * @param  {String} newValue
   *         The new outerHTML to set on the node.
   * @param  {String} oldValue
   *         The old outerHTML that will be used if the user undoes the update.
   * @return {Promise} that will resolve when the outer HTML has been updated.
   */
  updateNodeOuterHTML: function (node, newValue) {
    let container = this.getContainer(node);
    if (!container) {
      return promise.reject();
    }

    // Changing the outerHTML removes the node which outerHTML was changed.
    // Listen to this removal to reselect the right node afterwards.
    this.reselectOnRemoved(node, "outerhtml");
    return this.walker.setOuterHTML(node, newValue).then(null, () => {
      this.cancelReselectOnRemoved();
    });
  },

  /**
   * Replace the innerHTML of any node displayed in the inspector with
   * some other HTML code
   * @param  {Node} node
   *         node which innerHTML will be replaced.
   * @param  {String} newValue
   *         The new innerHTML to set on the node.
   * @param  {String} oldValue
   *         The old innerHTML that will be used if the user undoes the update.
   * @return {Promise} that will resolve when the inner HTML has been updated.
   */
  updateNodeInnerHTML: function (node, newValue, oldValue) {
    let container = this.getContainer(node);
    if (!container) {
      return promise.reject();
    }

    let def = defer();

    container.undo.do(() => {
      this.walker.setInnerHTML(node, newValue).then(def.resolve, def.reject);
    }, () => {
      this.walker.setInnerHTML(node, oldValue);
    });

    return def.promise;
  },

  /**
   * Insert adjacent HTML to any node displayed in the inspector.
   *
   * @param  {NodeFront} node
   *         The reference node.
   * @param  {String} position
   *         The position as specified for Element.insertAdjacentHTML
   *         (i.e. "beforeBegin", "afterBegin", "beforeEnd", "afterEnd").
   * @param  {String} newValue
   *         The adjacent HTML.
   * @return {Promise} that will resolve when the adjacent HTML has
   *         been inserted.
   */
  insertAdjacentHTMLToNode: function (node, position, value) {
    let container = this.getContainer(node);
    if (!container) {
      return promise.reject();
    }

    let def = defer();

    let injectedNodes = [];
    container.undo.do(() => {
      this.walker.insertAdjacentHTML(node, position, value).then(nodeArray => {
        injectedNodes = nodeArray.nodes;
        return nodeArray;
      }).then(def.resolve, def.reject);
    }, () => {
      this.walker.removeNodes(injectedNodes);
    });

    return def.promise;
  },

  /**
   * Open an editor in the UI to allow editing of a node's outerHTML.
   *
   * @param  {NodeFront} node
   *         The NodeFront to edit.
   */
  beginEditingOuterHTML: function (node) {
    this.getNodeOuterHTML(node).then(oldValue => {
      let container = this.getContainer(node);
      if (!container) {
        return;
      }
      this.htmlEditor.show(container.tagLine, oldValue);
      this.htmlEditor.once("popuphidden", (e, commit, value) => {
        // Need to focus the <html> element instead of the frame / window
        // in order to give keyboard focus back to doc (from editor).
        this.doc.documentElement.focus();

        if (commit) {
          this.updateNodeOuterHTML(node, value, oldValue);
        }
      });
    });
  },

  /**
   * Mark the given node expanded.
   *
   * @param  {NodeFront} node
   *         The NodeFront to mark as expanded.
   * @param  {Boolean} expanded
   *         Whether the expand or collapse.
   * @param  {Boolean} expandDescendants
   *         Whether to expand all descendants too
   */
  setNodeExpanded: function (node, expanded, expandDescendants) {
    if (expanded) {
      if (expandDescendants) {
        this.expandAll(node);
      } else {
        this.expandNode(node);
      }
    } else {
      this.collapseNode(node);
    }
  },

  /**
   * Mark the given node selected, and update the inspector.selection
   * object's NodeFront to keep consistent state between UI and selection.
   *
   * @param  {NodeFront} aNode
   *         The NodeFront to mark as selected.
   * @param  {String} reason
   *         The reason for marking the node as selected.
   * @return {Boolean} False if the node is already marked as selected, true
   *         otherwise.
   */
  markNodeAsSelected: function (node, reason) {
    let container = this.getContainer(node);

    if (this._selectedContainer === container) {
      return false;
    }

    // Un-select and remove focus from the previous container.
    if (this._selectedContainer) {
      this._selectedContainer.selected = false;
      this._selectedContainer.clearFocus();
    }

    // Select the new container.
    this._selectedContainer = container;
    if (node) {
      this._selectedContainer.selected = true;
    }

    // Change the current selection if needed.
    if (this.inspector.selection.nodeFront !== node) {
      this.inspector.selection.setNodeFront(node, reason || "nodeselected");
    }

    return true;
  },

  /**
   * Make sure that every ancestor of the selection are updated
   * and included in the list of visible children.
   */
  _ensureVisible: function (node) {
    while (node) {
      let container = this.getContainer(node);
      let parent = node.parentNode();
      if (!container.elt.parentNode) {
        let parentContainer = this.getContainer(parent);
        if (parentContainer) {
          parentContainer.childrenDirty = true;
          this._updateChildren(parentContainer, {expand: true});
        }
      }

      node = parent;
    }
    return this._waitForChildren();
  },

  /**
   * Unmark selected node (no node selected).
   */
  unmarkSelectedNode: function () {
    if (this._selectedContainer) {
      this._selectedContainer.selected = false;
      this._selectedContainer = null;
    }
  },

  /**
   * Check if the current selection is a descendent of the container.
   * if so, make sure it's among the visible set for the container,
   * and set the dirty flag if needed.
   *
   * @return The node that should be made visible, if any.
   */
  _checkSelectionVisible: function (container) {
    let centered = null;
    let node = this.inspector.selection.nodeFront;
    while (node) {
      if (node.parentNode() === container.node) {
        centered = node;
        break;
      }
      node = node.parentNode();
    }

    return centered;
  },

  /**
   * Make sure all children of the given container's node are
   * imported and attached to the container in the right order.
   *
   * Children need to be updated only in the following circumstances:
   * a) We just imported this node and have never seen its children.
   *    container.childrenDirty will be set by importNode in this case.
   * b) We received a childList mutation on the node.
   *    container.childrenDirty will be set in that case too.
   * c) We have changed the selection, and the path to that selection
   *    wasn't loaded in a previous children request (because we only
   *    grab a subset).
   *    container.childrenDirty should be set in that case too!
   *
   * @param  {MarkupContainer} container
   *         The markup container whose children need updating
   * @param  {Object} options
   *         Options are {expand:boolean,flash:boolean}
   * @return {Promise} that will be resolved when the children are ready
   *         (which may be immediately).
   */
  _updateChildren: function (container, options) {
    let expand = options && options.expand;
    let flash = options && options.flash;

    container.hasChildren = container.node.hasChildren;
    // Accessibility should either ignore empty children or semantically
    // consider them a group.
    container.setChildrenRole();

    if (!this._queuedChildUpdates) {
      this._queuedChildUpdates = new Map();
    }

    if (this._queuedChildUpdates.has(container)) {
      return this._queuedChildUpdates.get(container);
    }

    if (!container.childrenDirty) {
      return promise.resolve(container);
    }

    if (container.inlineTextChild
        && container.inlineTextChild != container.node.inlineTextChild) {
      // This container was doing double duty as a container for a single
      // text child, back that out.
      this._containers.delete(container.inlineTextChild);
      container.clearInlineTextChild();

      if (container.hasChildren && container.selected) {
        container.setExpanded(true);
      }
    }

    if (container.node.inlineTextChild) {
      container.setExpanded(false);
      // this container will do double duty as the container for the single
      // text child.
      while (container.children.firstChild) {
        container.children.removeChild(container.children.firstChild);
      }

      container.setInlineTextChild(container.node.inlineTextChild);

      this._containers.set(container.node.inlineTextChild, container);
      container.childrenDirty = false;
      return promise.resolve(container);
    }

    if (!container.hasChildren) {
      while (container.children.firstChild) {
        container.children.removeChild(container.children.firstChild);
      }
      container.childrenDirty = false;
      container.setExpanded(false);
      return promise.resolve(container);
    }

    // If we're not expanded (or asked to update anyway), we're done for
    // now.  Note that this will leave the childrenDirty flag set, so when
    // expanded we'll refresh the child list.
    if (!(container.expanded || expand)) {
      return promise.resolve(container);
    }

    // We're going to issue a children request, make sure it includes the
    // centered node.
    let centered = this._checkSelectionVisible(container);

    // Children aren't updated yet, but clear the childrenDirty flag anyway.
    // If the dirty flag is re-set while we're fetching we'll need to fetch
    // again.
    container.childrenDirty = false;
    let updatePromise =
      this._getVisibleChildren(container, centered).then(children => {
        if (!this._containers) {
          return promise.reject("markup view destroyed");
        }
        this._queuedChildUpdates.delete(container);

        // If children are dirty, we got a change notification for this node
        // while the request was in progress, we need to do it again.
        if (container.childrenDirty) {
          return this._updateChildren(container, {expand: centered});
        }

        let fragment = this.doc.createDocumentFragment();

        for (let child of children.nodes) {
          let childContainer = this.importNode(child, flash);
          fragment.appendChild(childContainer.elt);
        }

        while (container.children.firstChild) {
          container.children.removeChild(container.children.firstChild);
        }

        if (!(children.hasFirst && children.hasLast)) {
          let nodesCount = container.node.numChildren;
          let showAllString = PluralForm.get(nodesCount,
            INSPECTOR_L10N.getStr("markupView.more.showAll2"));
          let data = {
            showing: INSPECTOR_L10N.getStr("markupView.more.showing"),
            showAll: showAllString.replace("#1", nodesCount),
            allButtonClick: () => {
              container.maxChildren = -1;
              container.childrenDirty = true;
              this._updateChildren(container);
            }
          };

          if (!children.hasFirst) {
            let span = this.template("more-nodes", data);
            fragment.insertBefore(span, fragment.firstChild);
          }
          if (!children.hasLast) {
            let span = this.template("more-nodes", data);
            fragment.appendChild(span);
          }
        }

        container.children.appendChild(fragment);
        return container;
      }).catch(this._handleRejectionIfNotDestroyed);
    this._queuedChildUpdates.set(container, updatePromise);
    return updatePromise;
  },

  _waitForChildren: function () {
    if (!this._queuedChildUpdates) {
      return promise.resolve(undefined);
    }

    return promise.all([...this._queuedChildUpdates.values()]);
  },

  /**
   * Return a list of the children to display for this container.
   */
  _getVisibleChildren: function (container, centered) {
    let maxChildren = container.maxChildren || this.maxChildren;
    if (maxChildren == -1) {
      maxChildren = undefined;
    }

    return this.walker.children(container.node, {
      maxNodes: maxChildren,
      center: centered
    });
  },

  /**
   * Tear down the markup panel.
   */
  destroy: function () {
    if (this._destroyer) {
      return this._destroyer;
    }

    this._destroyer = promise.resolve();

    this._clearBriefBoxModelTimer();

    this._hoveredNode = null;

    this.htmlEditor.destroy();
    this.htmlEditor = null;

    this.undo.destroy();
    this.undo = null;

    this.popup.destroy();
    this.popup = null;

    this._elt.removeEventListener("click", this._onMouseClick, false);
    this._elt.removeEventListener("mousemove", this._onMouseMove, false);
    this._elt.removeEventListener("mouseout", this._onMouseOut, false);
    this._elt.removeEventListener("blur", this._onBlur, true);
    this.win.removeEventListener("mouseup", this._onMouseUp);
    this.win.removeEventListener("copy", this._onCopy);
    this._frame.removeEventListener("focus", this._onFocus, false);
    this.walker.off("mutations", this._mutationObserver);
    this.walker.off("display-change", this._onDisplayChange);
    this.inspector.selection.off("new-node-front", this._onNewSelection);
    this.toolbox.off("picker-node-hovered",
                                this._onToolboxPickerHover);

    this._prefObserver.off(ATTR_COLLAPSE_ENABLED_PREF,
                           this._onCollapseAttributesPrefChange);
    this._prefObserver.off(ATTR_COLLAPSE_LENGTH_PREF,
                           this._onCollapseAttributesPrefChange);
    this._prefObserver.destroy();

    this._elt = null;

    for (let [, container] of this._containers) {
      container.destroy();
    }
    this._containers = null;

    this.eventDetailsTooltip.destroy();
    this.eventDetailsTooltip = null;

    this.imagePreviewTooltip.destroy();
    this.imagePreviewTooltip = null;

    this.win = null;
    this.doc = null;

    this._lastDropTarget = null;
    this._lastDragTarget = null;

    return this._destroyer;
  },

  /**
   * Find the closest element with class tag-line. These are used to indicate
   * drag and drop targets.
   *
   * @param  {DOMNode} el
   * @return {DOMNode}
   */
  findClosestDragDropTarget: function (el) {
    return el.classList.contains("tag-line")
           ? el
           : el.querySelector(".tag-line") || el.closest(".tag-line");
  },

  /**
   * Takes an element as it's only argument and marks the element
   * as the drop target
   */
  indicateDropTarget: function (el) {
    if (this._lastDropTarget) {
      this._lastDropTarget.classList.remove("drop-target");
    }

    if (!el) {
      return;
    }

    let target = this.findClosestDragDropTarget(el);
    if (target) {
      target.classList.add("drop-target");
      this._lastDropTarget = target;
    }
  },

  /**
   * Takes an element to mark it as indicator of dragging target's initial place
   */
  indicateDragTarget: function (el) {
    if (this._lastDragTarget) {
      this._lastDragTarget.classList.remove("drag-target");
    }

    if (!el) {
      return;
    }

    let target = this.findClosestDragDropTarget(el);
    if (target) {
      target.classList.add("drag-target");
      this._lastDragTarget = target;
    }
  },

  /**
   * Used to get the nodes required to modify the markup after dragging the
   * element (parent/nextSibling).
   */
  get dropTargetNodes() {
    let target = this._lastDropTarget;

    if (!target) {
      return null;
    }

    let parent, nextSibling;

    if (target.previousElementSibling &&
        target.previousElementSibling.nodeName.toLowerCase() === "ul") {
      parent = target.parentNode.container.node;
      nextSibling = null;
    } else {
      parent = target.parentNode.container.node.parentNode();
      nextSibling = target.parentNode.container.node;
    }

    if (nextSibling && nextSibling.isBeforePseudoElement) {
      nextSibling = target.parentNode.parentNode.children[1].container.node;
    }
    if (nextSibling && nextSibling.isAfterPseudoElement) {
      parent = target.parentNode.container.node.parentNode();
      nextSibling = null;
    }

    if (parent.nodeType !== nodeConstants.ELEMENT_NODE) {
      return null;
    }

    return {parent, nextSibling};
  }
};

/**
 * Map a number from one range to another.
 */
function map(value, oldMin, oldMax, newMin, newMax) {
  let ratio = oldMax - oldMin;
  if (ratio == 0) {
    return value;
  }
  return newMin + (newMax - newMin) * ((value - oldMin) / ratio);
}

module.exports = MarkupView;
