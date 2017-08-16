/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const { addons, createClass, createFactory, DOM: dom, PropTypes } =
  require("devtools/client/shared/vendor/react");

const BoxModelInfo = createFactory(require("./BoxModelInfo"));
const BoxModelMain = createFactory(require("./BoxModelMain"));
const BoxModelProperties = createFactory(require("./BoxModelProperties"));

const Types = require("../types");

module.exports = createClass({

  displayName: "BoxModel",

  propTypes: {
    boxModel: PropTypes.shape(Types.boxModel).isRequired,
    setSelectedNode: PropTypes.func.isRequired,
    showBoxModelProperties: PropTypes.bool.isRequired,
    onHideBoxModelHighlighter: PropTypes.func.isRequired,
    onShowBoxModelEditor: PropTypes.func.isRequired,
    onShowBoxModelHighlighter: PropTypes.func.isRequired,
    onShowBoxModelHighlighterForNode: PropTypes.func.isRequired,
    onToggleGeometryEditor: PropTypes.func.isRequired,
  },

  mixins: [ addons.PureRenderMixin ],

  onKeyDown(event) {
    let { target } = event;

    if (target == this.boxModelContainer) {
      this.boxModelMain.onKeyDown(event);
    }
  },

  render() {
    let {
      boxModel,
      setSelectedNode,
      showBoxModelProperties,
      onHideBoxModelHighlighter,
      onShowBoxModelEditor,
      onShowBoxModelHighlighter,
      onShowBoxModelHighlighterForNode,
      onToggleGeometryEditor,
    } = this.props;

    return dom.div(
      {
        className: "boxmodel-container",
        tabIndex: 0,
        ref: div => {
          this.boxModelContainer = div;
        },
        onKeyDown: this.onKeyDown,
      },
      BoxModelMain({
        boxModel,
        boxModelContainer: this.boxModelContainer,
        ref: boxModelMain => {
          this.boxModelMain = boxModelMain;
        },
        onHideBoxModelHighlighter,
        onShowBoxModelEditor,
        onShowBoxModelHighlighter,
      }),
      BoxModelInfo({
        boxModel,
        onToggleGeometryEditor,
      }),
      showBoxModelProperties ?
        BoxModelProperties({
          boxModel,
          setSelectedNode,
          onHideBoxModelHighlighter,
          onShowBoxModelHighlighterForNode,
        })
        :
        null
    );
  },
});
