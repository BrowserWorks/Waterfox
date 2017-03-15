 /* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const { extend } = require("sdk/core/heritage");
const { AutoRefreshHighlighter } = require("./auto-refresh");
const {
  CanvasFrameAnonymousContentHelper,
  createNode,
  createSVGNode,
  getBindingElementAndPseudo,
  hasPseudoClassLock,
  isNodeValid,
  moveInfobar,
} = require("./utils/markup");
const { setIgnoreLayoutChanges } = require("devtools/shared/layout/utils");
const inspector = require("devtools/server/actors/inspector");
const nodeConstants = require("devtools/shared/dom-node-constants");

// Note that the order of items in this array is important because it is used
// for drawing the BoxModelHighlighter's path elements correctly.
const BOX_MODEL_REGIONS = ["margin", "border", "padding", "content"];
const BOX_MODEL_SIDES = ["top", "right", "bottom", "left"];
// Width of boxmodelhighlighter guides
const GUIDE_STROKE_WIDTH = 1;
// FIXME: add ":visited" and ":link" after bug 713106 is fixed
const PSEUDO_CLASSES = [":hover", ":active", ":focus"];

/**
 * The BoxModelHighlighter draws the box model regions on top of a node.
 * If the node is a block box, then each region will be displayed as 1 polygon.
 * If the node is an inline box though, each region may be represented by 1 or
 * more polygons, depending on how many line boxes the inline element has.
 *
 * Usage example:
 *
 * let h = new BoxModelHighlighter(env);
 * h.show(node, options);
 * h.hide();
 * h.destroy();
 *
 * Available options:
 * - region {String}
 *   "content", "padding", "border" or "margin"
 *   This specifies the region that the guides should outline.
 *   Defaults to "content"
 * - hideGuides {Boolean}
 *   Defaults to false
 * - hideInfoBar {Boolean}
 *   Defaults to false
 * - showOnly {String}
 *   "content", "padding", "border" or "margin"
 *   If set, only this region will be highlighted. Use with onlyRegionArea to
 *   only highlight the area of the region.
 * - onlyRegionArea {Boolean}
 *   This can be set to true to make each region's box only highlight the area
 *   of the corresponding region rather than the area of nested regions too.
 *   This is useful when used with showOnly.
 *
 * Structure:
 * <div class="highlighter-container">
 *   <div class="box-model-root">
 *     <svg class="box-model-elements" hidden="true">
 *       <g class="box-model-regions">
 *         <path class="box-model-margin" points="..." />
 *         <path class="box-model-border" points="..." />
 *         <path class="box-model-padding" points="..." />
 *         <path class="box-model-content" points="..." />
 *       </g>
 *       <line class="box-model-guide-top" x1="..." y1="..." x2="..." y2="..." />
 *       <line class="box-model-guide-right" x1="..." y1="..." x2="..." y2="..." />
 *       <line class="box-model-guide-bottom" x1="..." y1="..." x2="..." y2="..." />
 *       <line class="box-model-guide-left" x1="..." y1="..." x2="..." y2="..." />
 *     </svg>
 *     <div class="box-model-infobar-container">
 *       <div class="box-model-infobar-arrow highlighter-infobar-arrow-top" />
 *       <div class="box-model-infobar">
 *         <div class="box-model-infobar-text" align="center">
 *           <span class="box-model-infobar-tagname">Node name</span>
 *           <span class="box-model-infobar-id">Node id</span>
 *           <span class="box-model-infobar-classes">.someClass</span>
 *           <span class="box-model-infobar-pseudo-classes">:hover</span>
 *         </div>
 *       </div>
 *       <div class="box-model-infobar-arrow box-model-infobar-arrow-bottom"/>
 *     </div>
 *   </div>
 * </div>
 */
function BoxModelHighlighter(highlighterEnv) {
  AutoRefreshHighlighter.call(this, highlighterEnv);

  this.markup = new CanvasFrameAnonymousContentHelper(this.highlighterEnv,
    this._buildMarkup.bind(this));

  /**
   * Optionally customize each region's fill color by adding an entry to the
   * regionFill property: `highlighter.regionFill.margin = "red";
   */
  this.regionFill = {};

  this.onWillNavigate = this.onWillNavigate.bind(this);

  this.highlighterEnv.on("will-navigate", this.onWillNavigate);
}

BoxModelHighlighter.prototype = extend(AutoRefreshHighlighter.prototype, {
  typeName: "BoxModelHighlighter",

  ID_CLASS_PREFIX: "box-model-",

  _buildMarkup: function () {
    let doc = this.win.document;

    let highlighterContainer = doc.createElement("div");
    highlighterContainer.className = "highlighter-container box-model";

    // Build the root wrapper, used to adapt to the page zoom.
    let rootWrapper = createNode(this.win, {
      parent: highlighterContainer,
      attributes: {
        "id": "root",
        "class": "root"
      },
      prefix: this.ID_CLASS_PREFIX
    });

    // Building the SVG element with its polygons and lines

    let svg = createSVGNode(this.win, {
      nodeType: "svg",
      parent: rootWrapper,
      attributes: {
        "id": "elements",
        "width": "100%",
        "height": "100%",
        "hidden": "true"
      },
      prefix: this.ID_CLASS_PREFIX
    });

    let regions = createSVGNode(this.win, {
      nodeType: "g",
      parent: svg,
      attributes: {
        "class": "regions"
      },
      prefix: this.ID_CLASS_PREFIX
    });

    for (let region of BOX_MODEL_REGIONS) {
      createSVGNode(this.win, {
        nodeType: "path",
        parent: regions,
        attributes: {
          "class": region,
          "id": region
        },
        prefix: this.ID_CLASS_PREFIX
      });
    }

    for (let side of BOX_MODEL_SIDES) {
      createSVGNode(this.win, {
        nodeType: "line",
        parent: svg,
        attributes: {
          "class": "guide-" + side,
          "id": "guide-" + side,
          "stroke-width": GUIDE_STROKE_WIDTH
        },
        prefix: this.ID_CLASS_PREFIX
      });
    }

    // Building the nodeinfo bar markup

    let infobarContainer = createNode(this.win, {
      parent: rootWrapper,
      attributes: {
        "class": "infobar-container",
        "id": "infobar-container",
        "position": "top",
        "hidden": "true"
      },
      prefix: this.ID_CLASS_PREFIX
    });

    let infobar = createNode(this.win, {
      parent: infobarContainer,
      attributes: {
        "class": "infobar"
      },
      prefix: this.ID_CLASS_PREFIX
    });

    let texthbox = createNode(this.win, {
      parent: infobar,
      attributes: {
        "class": "infobar-text"
      },
      prefix: this.ID_CLASS_PREFIX
    });
    createNode(this.win, {
      nodeType: "span",
      parent: texthbox,
      attributes: {
        "class": "infobar-tagname",
        "id": "infobar-tagname"
      },
      prefix: this.ID_CLASS_PREFIX
    });
    createNode(this.win, {
      nodeType: "span",
      parent: texthbox,
      attributes: {
        "class": "infobar-id",
        "id": "infobar-id"
      },
      prefix: this.ID_CLASS_PREFIX
    });
    createNode(this.win, {
      nodeType: "span",
      parent: texthbox,
      attributes: {
        "class": "infobar-classes",
        "id": "infobar-classes"
      },
      prefix: this.ID_CLASS_PREFIX
    });
    createNode(this.win, {
      nodeType: "span",
      parent: texthbox,
      attributes: {
        "class": "infobar-pseudo-classes",
        "id": "infobar-pseudo-classes"
      },
      prefix: this.ID_CLASS_PREFIX
    });
    createNode(this.win, {
      nodeType: "span",
      parent: texthbox,
      attributes: {
        "class": "infobar-dimensions",
        "id": "infobar-dimensions"
      },
      prefix: this.ID_CLASS_PREFIX
    });

    return highlighterContainer;
  },

  /**
   * Destroy the nodes. Remove listeners.
   */
  destroy: function () {
    this.highlighterEnv.off("will-navigate", this.onWillNavigate);
    this.markup.destroy();
    AutoRefreshHighlighter.prototype.destroy.call(this);
  },

  getElement: function (id) {
    return this.markup.getElement(this.ID_CLASS_PREFIX + id);
  },

  /**
   * Override the AutoRefreshHighlighter's _isNodeValid method to also return true for
   * text nodes since these can also be highlighted.
   * @param {DOMNode} node
   * @return {Boolean}
   */
  _isNodeValid: function (node) {
    return node && (isNodeValid(node) || isNodeValid(node, nodeConstants.TEXT_NODE));
  },

  /**
   * Show the highlighter on a given node
   */
  _show: function () {
    if (BOX_MODEL_REGIONS.indexOf(this.options.region) == -1) {
      this.options.region = "content";
    }

    let shown = this._update();
    this._trackMutations();
    this.emit("ready");
    return shown;
  },

  /**
   * Track the current node markup mutations so that the node info bar can be
   * updated to reflects the node's attributes
   */
  _trackMutations: function () {
    if (isNodeValid(this.currentNode)) {
      let win = this.currentNode.ownerDocument.defaultView;
      this.currentNodeObserver = new win.MutationObserver(this.update);
      this.currentNodeObserver.observe(this.currentNode, {attributes: true});
    }
  },

  _untrackMutations: function () {
    if (isNodeValid(this.currentNode) && this.currentNodeObserver) {
      this.currentNodeObserver.disconnect();
      this.currentNodeObserver = null;
    }
  },

  /**
   * Update the highlighter on the current highlighted node (the one that was
   * passed as an argument to show(node)).
   * Should be called whenever node size or attributes change
   */
  _update: function () {
    let shown = false;
    setIgnoreLayoutChanges(true);

    if (this._updateBoxModel()) {
      // Show the infobar only if configured to do so and the node is an element or a text
      // node.
      if (!this.options.hideInfoBar && (
          this.currentNode.nodeType === this.currentNode.ELEMENT_NODE ||
          this.currentNode.nodeType === this.currentNode.TEXT_NODE)) {
        this._showInfobar();
      } else {
        this._hideInfobar();
      }
      this._showBoxModel();
      shown = true;
    } else {
      // Nothing to highlight (0px rectangle like a <script> tag for instance)
      this._hide();
    }

    setIgnoreLayoutChanges(false, this.highlighterEnv.window.document.documentElement);

    return shown;
  },

  /**
   * Hide the highlighter, the outline and the infobar.
   */
  _hide: function () {
    setIgnoreLayoutChanges(true);

    this._untrackMutations();
    this._hideBoxModel();
    this._hideInfobar();

    setIgnoreLayoutChanges(false, this.highlighterEnv.window.document.documentElement);
  },

  /**
   * Hide the infobar
   */
  _hideInfobar: function () {
    this.getElement("infobar-container").setAttribute("hidden", "true");
  },

  /**
   * Show the infobar
   */
  _showInfobar: function () {
    this.getElement("infobar-container").removeAttribute("hidden");
    this._updateInfobar();
  },

  /**
   * Hide the box model
   */
  _hideBoxModel: function () {
    this.getElement("elements").setAttribute("hidden", "true");
  },

  /**
   * Show the box model
   */
  _showBoxModel: function () {
    this.getElement("elements").removeAttribute("hidden");
  },

  /**
   * Calculate an outer quad based on the quads returned by getAdjustedQuads.
   * The BoxModelHighlighter may highlight more than one boxes, so in this case
   * create a new quad that "contains" all of these quads.
   * This is useful to position the guides and infobar.
   * This may happen if the BoxModelHighlighter is used to highlight an inline
   * element that spans line breaks.
   * @param {String} region The box-model region to get the outer quad for.
   * @return {Object} A quad-like object {p1,p2,p3,p4,bounds}
   */
  _getOuterQuad: function (region) {
    let quads = this.currentQuads[region];
    if (!quads.length) {
      return null;
    }

    let quad = {
      p1: {x: Infinity, y: Infinity},
      p2: {x: -Infinity, y: Infinity},
      p3: {x: -Infinity, y: -Infinity},
      p4: {x: Infinity, y: -Infinity},
      bounds: {
        bottom: -Infinity,
        height: 0,
        left: Infinity,
        right: -Infinity,
        top: Infinity,
        width: 0,
        x: 0,
        y: 0,
      }
    };

    for (let q of quads) {
      quad.p1.x = Math.min(quad.p1.x, q.p1.x);
      quad.p1.y = Math.min(quad.p1.y, q.p1.y);
      quad.p2.x = Math.max(quad.p2.x, q.p2.x);
      quad.p2.y = Math.min(quad.p2.y, q.p2.y);
      quad.p3.x = Math.max(quad.p3.x, q.p3.x);
      quad.p3.y = Math.max(quad.p3.y, q.p3.y);
      quad.p4.x = Math.min(quad.p4.x, q.p4.x);
      quad.p4.y = Math.max(quad.p4.y, q.p4.y);

      quad.bounds.bottom = Math.max(quad.bounds.bottom, q.bounds.bottom);
      quad.bounds.top = Math.min(quad.bounds.top, q.bounds.top);
      quad.bounds.left = Math.min(quad.bounds.left, q.bounds.left);
      quad.bounds.right = Math.max(quad.bounds.right, q.bounds.right);
    }
    quad.bounds.x = quad.bounds.left;
    quad.bounds.y = quad.bounds.top;
    quad.bounds.width = quad.bounds.right - quad.bounds.left;
    quad.bounds.height = quad.bounds.bottom - quad.bounds.top;

    return quad;
  },

  /**
   * Update the box model as per the current node.
   *
   * @return {boolean}
   *         True if the current node has a box model to be highlighted
   */
  _updateBoxModel: function () {
    let options = this.options;
    options.region = options.region || "content";

    if (!this._nodeNeedsHighlighting()) {
      this._hideBoxModel();
      return false;
    }

    for (let i = 0; i < BOX_MODEL_REGIONS.length; i++) {
      let boxType = BOX_MODEL_REGIONS[i];
      let nextBoxType = BOX_MODEL_REGIONS[i + 1];
      let box = this.getElement(boxType);

      if (this.regionFill[boxType]) {
        box.setAttribute("style", "fill:" + this.regionFill[boxType]);
      } else {
        box.setAttribute("style", "");
      }

      // Highlight all quads for this region by setting the "d" attribute of the
      // corresponding <path>.
      let path = [];
      for (let j = 0; j < this.currentQuads[boxType].length; j++) {
        let boxQuad = this.currentQuads[boxType][j];
        let nextBoxQuad = this.currentQuads[nextBoxType]
                          ? this.currentQuads[nextBoxType][j]
                          : null;
        path.push(this._getBoxPathCoordinates(boxQuad, nextBoxQuad));
      }

      box.setAttribute("d", path.join(" "));
      box.removeAttribute("faded");

      // If showOnly is defined, either hide the other regions, or fade them out
      // if onlyRegionArea is set too.
      if (options.showOnly && options.showOnly !== boxType) {
        if (options.onlyRegionArea) {
          box.setAttribute("faded", "true");
        } else {
          box.removeAttribute("d");
        }
      }

      if (boxType === options.region && !options.hideGuides) {
        this._showGuides(boxType);
      } else if (options.hideGuides) {
        this._hideGuides();
      }
    }

    // Un-zoom the root wrapper if the page was zoomed.
    let rootId = this.ID_CLASS_PREFIX + "root";
    this.markup.scaleRootElement(this.currentNode, rootId);

    return true;
  },

  _getBoxPathCoordinates: function (boxQuad, nextBoxQuad) {
    let {p1, p2, p3, p4} = boxQuad;

    let path;
    if (!nextBoxQuad || !this.options.onlyRegionArea) {
      // If this is the content box (inner-most box) or if we're not being asked
      // to highlight only region areas, then draw a simple rectangle.
      path = "M" + p1.x + "," + p1.y + " " +
             "L" + p2.x + "," + p2.y + " " +
             "L" + p3.x + "," + p3.y + " " +
             "L" + p4.x + "," + p4.y;
    } else {
      // Otherwise, just draw the region itself, not a filled rectangle.
      let {p1: np1, p2: np2, p3: np3, p4: np4} = nextBoxQuad;
      path = "M" + p1.x + "," + p1.y + " " +
             "L" + p2.x + "," + p2.y + " " +
             "L" + p3.x + "," + p3.y + " " +
             "L" + p4.x + "," + p4.y + " " +
             "L" + p1.x + "," + p1.y + " " +
             "L" + np1.x + "," + np1.y + " " +
             "L" + np4.x + "," + np4.y + " " +
             "L" + np3.x + "," + np3.y + " " +
             "L" + np2.x + "," + np2.y + " " +
             "L" + np1.x + "," + np1.y;
    }

    return path;
  },

  /**
   * Can the current node be highlighted? Does it have quads.
   * @return {Boolean}
   */
  _nodeNeedsHighlighting: function () {
    return this.currentQuads.margin.length ||
           this.currentQuads.border.length ||
           this.currentQuads.padding.length ||
           this.currentQuads.content.length;
  },

  _getOuterBounds: function () {
    for (let region of ["margin", "border", "padding", "content"]) {
      let quad = this._getOuterQuad(region);

      if (!quad) {
        // Invisible element such as a script tag.
        break;
      }

      let {bottom, height, left, right, top, width, x, y} = quad.bounds;

      if (width > 0 || height > 0) {
        return {bottom, height, left, right, top, width, x, y};
      }
    }

    return {
      bottom: 0,
      height: 0,
      left: 0,
      right: 0,
      top: 0,
      width: 0,
      x: 0,
      y: 0
    };
  },

  /**
   * We only want to show guides for horizontal and vertical edges as this helps
   * to line them up. This method finds these edges and displays a guide there.
   * @param {String} region The region around which the guides should be shown.
   */
  _showGuides: function (region) {
    let {p1, p2, p3, p4} = this._getOuterQuad(region);

    let allX = [p1.x, p2.x, p3.x, p4.x].sort((a, b) => a - b);
    let allY = [p1.y, p2.y, p3.y, p4.y].sort((a, b) => a - b);
    let toShowX = [];
    let toShowY = [];

    for (let arr of [allX, allY]) {
      for (let i = 0; i < arr.length; i++) {
        let val = arr[i];

        if (i !== arr.lastIndexOf(val)) {
          if (arr === allX) {
            toShowX.push(val);
          } else {
            toShowY.push(val);
          }
          arr.splice(arr.lastIndexOf(val), 1);
        }
      }
    }

    // Move guide into place or hide it if no valid co-ordinate was found.
    this._updateGuide("top", toShowY[0]);
    this._updateGuide("right", toShowX[1]);
    this._updateGuide("bottom", toShowY[1]);
    this._updateGuide("left", toShowX[0]);
  },

  _hideGuides: function () {
    for (let side of BOX_MODEL_SIDES) {
      this.getElement("guide-" + side).setAttribute("hidden", "true");
    }
  },

  /**
   * Move a guide to the appropriate position and display it. If no point is
   * passed then the guide is hidden.
   *
   * @param  {String} side
   *         The guide to update
   * @param  {Integer} point
   *         x or y co-ordinate. If this is undefined we hide the guide.
   */
  _updateGuide: function (side, point = -1) {
    let guide = this.getElement("guide-" + side);

    if (point <= 0) {
      guide.setAttribute("hidden", "true");
      return false;
    }

    if (side === "top" || side === "bottom") {
      guide.setAttribute("x1", "0");
      guide.setAttribute("y1", point + "");
      guide.setAttribute("x2", "100%");
      guide.setAttribute("y2", point + "");
    } else {
      guide.setAttribute("x1", point + "");
      guide.setAttribute("y1", "0");
      guide.setAttribute("x2", point + "");
      guide.setAttribute("y2", "100%");
    }

    guide.removeAttribute("hidden");

    return true;
  },

  /**
   * Update node information (displayName#id.class)
   */
  _updateInfobar: function () {
    if (!this.currentNode) {
      return;
    }

    let {bindingElement: node, pseudo} =
        getBindingElementAndPseudo(this.currentNode);

    // Update the tag, id, classes, pseudo-classes and dimensions
    let displayName = inspector.getNodeDisplayName(node);

    let id = node.id ? "#" + node.id : "";

    let classList = (node.classList || []).length
                    ? "." + [...node.classList].join(".")
                    : "";

    let pseudos = this._getPseudoClasses(node).join("");
    if (pseudo) {
      // Display :after as ::after
      pseudos += ":" + pseudo;
    }

    let rect = this._getOuterQuad("border").bounds;
    let dim = parseFloat(rect.width.toPrecision(6)) +
              " \u00D7 " +
              parseFloat(rect.height.toPrecision(6));

    this.getElement("infobar-tagname").setTextContent(displayName);
    this.getElement("infobar-id").setTextContent(id);
    this.getElement("infobar-classes").setTextContent(classList);
    this.getElement("infobar-pseudo-classes").setTextContent(pseudos);
    this.getElement("infobar-dimensions").setTextContent(dim);

    this._moveInfobar();
  },

  _getPseudoClasses: function (node) {
    if (node.nodeType !== nodeConstants.ELEMENT_NODE) {
      // hasPseudoClassLock can only be used on Elements.
      return [];
    }

    return PSEUDO_CLASSES.filter(pseudo => hasPseudoClassLock(node, pseudo));
  },

  /**
   * Move the Infobar to the right place in the highlighter.
   */
  _moveInfobar: function () {
    let bounds = this._getOuterBounds();
    let container = this.getElement("infobar-container");

    moveInfobar(container, bounds, this.win);
  },

  onWillNavigate: function ({ isTopLevel }) {
    if (isTopLevel) {
      this.hide();
    }
  }
});
exports.BoxModelHighlighter = BoxModelHighlighter;
