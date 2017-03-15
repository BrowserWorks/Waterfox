/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const Heritage = require("sdk/core/heritage");
const ReadOnlyEditor = require("devtools/client/inspector/markup/views/read-only-editor");
const MarkupContainer = require("devtools/client/inspector/markup/views/markup-container");

/**
 * An implementation of MarkupContainer for Pseudo Elements,
 * Doctype nodes, or any other type generic node that doesn't
 * fit for other editors.
 * Does not allow any editing, just viewing / selecting.
 *
 * @param  {MarkupView} markupView
 *         The markup view that owns this container.
 * @param  {NodeFront} node
 *         The node to display.
 */
function MarkupReadOnlyContainer(markupView, node) {
  MarkupContainer.prototype.initialize.call(this, markupView, node,
    "readonlycontainer");

  this.editor = new ReadOnlyEditor(this, node);
  this.tagLine.appendChild(this.editor.elt);
}

MarkupReadOnlyContainer.prototype =
  Heritage.extend(MarkupContainer.prototype, {});

module.exports = MarkupReadOnlyContainer;
