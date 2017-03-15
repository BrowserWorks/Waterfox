/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const EventEmitter = require("devtools/shared/event-emitter");
const {KeyShortcuts} = require("devtools/client/shared/key-shortcuts");
const {HTMLTooltip} = require("devtools/client/shared/widgets/tooltip/HTMLTooltip");

/**
 * Base class for all (color, gradient, ...)-swatch based value editors inside
 * tooltips
 *
 * @param {Document} document
 *        The document to attach the SwatchBasedEditorTooltip. This is either the toolbox
 *        document if the tooltip is a popup tooltip or the panel's document if it is an
 *        inline editor.
 */
function SwatchBasedEditorTooltip(document, stylesheet) {
  EventEmitter.decorate(this);
  // Creating a tooltip instance
  // This one will consume outside clicks as it makes more sense to let the user
  // close the tooltip by clicking out
  // It will also close on <escape> and <enter>
  this.tooltip = new HTMLTooltip(document, {
    type: "arrow",
    consumeOutsideClicks: true,
    useXulWrapper: true,
    stylesheet
  });

  // By default, swatch-based editor tooltips revert value change on <esc> and
  // commit value change on <enter>
  this.shortcuts = new KeyShortcuts({
    window: this.tooltip.topWindow
  });
  this.shortcuts.on("Escape", (name, event) => {
    if (!this.tooltip.isVisible()) {
      return;
    }
    this.revert();
    this.hide();
    event.stopPropagation();
    event.preventDefault();
  });
  this.shortcuts.on("Return", (name, event) => {
    if (!this.tooltip.isVisible()) {
      return;
    }
    this.commit();
    this.hide();
    event.stopPropagation();
    event.preventDefault();
  });

  // All target swatches are kept in a map, indexed by swatch DOM elements
  this.swatches = new Map();

  // When a swatch is clicked, and for as long as the tooltip is shown, the
  // activeSwatch property will hold the reference to the swatch DOM element
  // that was clicked
  this.activeSwatch = null;

  this._onSwatchClick = this._onSwatchClick.bind(this);
}

SwatchBasedEditorTooltip.prototype = {
  /**
   * Show the editor tooltip for the currently active swatch.
   *
   * @return {Promise} a promise that resolves once the editor tooltip is displayed, or
   *         immediately if there is no currently active swatch.
   */
  show: function () {
    if (this.activeSwatch) {
      let onShown = this.tooltip.once("shown");
      this.tooltip.show(this.activeSwatch, "topcenter bottomleft");

      // When the tooltip is closed by clicking outside the panel we want to
      // commit any changes.
      this.tooltip.once("hidden", () => {
        if (!this._reverted && !this.eyedropperOpen) {
          this.commit();
        }
        this._reverted = false;

        // Once the tooltip is hidden we need to clean up any remaining objects.
        if (!this.eyedropperOpen) {
          this.activeSwatch = null;
        }
      });

      return onShown;
    }

    return Promise.resolve();
  },

  hide: function () {
    this.tooltip.hide();
  },

  /**
   * Add a new swatch DOM element to the list of swatch elements this editor
   * tooltip knows about. That means from now on, clicking on that swatch will
   * toggle the editor.
   *
   * @param {node} swatchEl
   *        The element to add
   * @param {object} callbacks
   *        Callbacks that will be executed when the editor wants to preview a
   *        value change, or revert a change, or commit a change.
   *        - onShow: will be called when one of the swatch tooltip is shown
   *        - onPreview: will be called when one of the sub-classes calls
   *        preview
   *        - onRevert: will be called when the user ESCapes out of the tooltip
   *        - onCommit: will be called when the user presses ENTER or clicks
   *        outside the tooltip.
   */
  addSwatch: function (swatchEl, callbacks = {}) {
    if (!callbacks.onShow) {
      callbacks.onShow = function () {};
    }
    if (!callbacks.onPreview) {
      callbacks.onPreview = function () {};
    }
    if (!callbacks.onRevert) {
      callbacks.onRevert = function () {};
    }
    if (!callbacks.onCommit) {
      callbacks.onCommit = function () {};
    }

    this.swatches.set(swatchEl, {
      callbacks: callbacks
    });
    swatchEl.addEventListener("click", this._onSwatchClick, false);
  },

  removeSwatch: function (swatchEl) {
    if (this.swatches.has(swatchEl)) {
      if (this.activeSwatch === swatchEl) {
        this.hide();
        this.activeSwatch = null;
      }
      swatchEl.removeEventListener("click", this._onSwatchClick, false);
      this.swatches.delete(swatchEl);
    }
  },

  _onSwatchClick: function (event) {
    let swatch = this.swatches.get(event.target);

    if (event.shiftKey) {
      event.stopPropagation();
      return;
    }
    if (swatch) {
      this.activeSwatch = event.target;
      this.show();
      swatch.callbacks.onShow();
      event.stopPropagation();
    }
  },

  /**
   * Not called by this parent class, needs to be taken care of by sub-classes
   */
  preview: function (value) {
    if (this.activeSwatch) {
      let swatch = this.swatches.get(this.activeSwatch);
      swatch.callbacks.onPreview(value);
    }
  },

  /**
   * This parent class only calls this on <esc> keypress
   */
  revert: function () {
    if (this.activeSwatch) {
      this._reverted = true;
      let swatch = this.swatches.get(this.activeSwatch);
      this.tooltip.once("hidden", () => {
        swatch.callbacks.onRevert();
      });
    }
  },

  /**
   * This parent class only calls this on <enter> keypress
   */
  commit: function () {
    if (this.activeSwatch) {
      let swatch = this.swatches.get(this.activeSwatch);
      swatch.callbacks.onCommit();
    }
  },

  destroy: function () {
    this.swatches.clear();
    this.activeSwatch = null;
    this.tooltip.off("keypress", this._onTooltipKeypress);
    this.tooltip.destroy();
    this.shortcuts.destroy();
  }
};

module.exports = SwatchBasedEditorTooltip;
