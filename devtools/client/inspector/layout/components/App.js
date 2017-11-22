/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const Services = require("Services");
const { addons, createClass, createFactory, DOM: dom, PropTypes } =
  require("devtools/client/shared/vendor/react");
const { connect } = require("devtools/client/shared/vendor/react-redux");

const { LocalizationHelper } = require("devtools/shared/l10n");

const BoxModel = createFactory(require("devtools/client/inspector/boxmodel/components/BoxModel"));
const Grid = createFactory(require("devtools/client/inspector/grids/components/Grid"));

const BoxModelTypes = require("devtools/client/inspector/boxmodel/types");
const GridTypes = require("devtools/client/inspector/grids/types");

const Accordion = createFactory(require("./Accordion"));
const LayoutPromoteBar = createFactory(require("./LayoutPromoteBar"));

const BOXMODEL_STRINGS_URI = "devtools/client/locales/boxmodel.properties";
const BOXMODEL_L10N = new LocalizationHelper(BOXMODEL_STRINGS_URI);

const LAYOUT_STRINGS_URI = "devtools/client/locales/layout.properties";
const LAYOUT_L10N = new LocalizationHelper(LAYOUT_STRINGS_URI);

const BOXMODEL_OPENED_PREF = "devtools.layout.boxmodel.opened";
const GRID_OPENED_PREF = "devtools.layout.grid.opened";

const App = createClass({

  displayName: "App",

  propTypes: {
    boxModel: PropTypes.shape(BoxModelTypes.boxModel).isRequired,
    getSwatchColorPickerTooltip: PropTypes.func.isRequired,
    grids: PropTypes.arrayOf(PropTypes.shape(GridTypes.grid)).isRequired,
    highlighterSettings: PropTypes.shape(GridTypes.highlighterSettings).isRequired,
    setSelectedNode: PropTypes.func.isRequired,
    showBoxModelProperties: PropTypes.bool.isRequired,
    onHideBoxModelHighlighter: PropTypes.func.isRequired,
    onPromoteLearnMoreClick: PropTypes.func.isRequired,
    onSetGridOverlayColor: PropTypes.func.isRequired,
    onShowBoxModelEditor: PropTypes.func.isRequired,
    onShowBoxModelHighlighter: PropTypes.func.isRequired,
    onShowBoxModelHighlighterForNode: PropTypes.func.isRequired,
    onToggleGridHighlighter: PropTypes.func.isRequired,
    onToggleShowGridLineNumbers: PropTypes.func.isRequired,
    onToggleShowInfiniteLines: PropTypes.func.isRequired,
  },

  mixins: [ addons.PureRenderMixin ],

  render() {
    let { onPromoteLearnMoreClick } = this.props;

    return dom.div(
      {
        id: "layout-container",
        className: "devtools-monospace",
      },
      LayoutPromoteBar({
        onPromoteLearnMoreClick,
      }),
      Accordion({
        items: [
          {
            header: LAYOUT_L10N.getStr("layout.header"),
            component: Grid,
            componentProps: this.props,
            opened: Services.prefs.getBoolPref(GRID_OPENED_PREF),
            onToggled: () => {
              let opened = Services.prefs.getBoolPref(GRID_OPENED_PREF);
              Services.prefs.setBoolPref(GRID_OPENED_PREF, !opened);
            }
          },
          {
            header: BOXMODEL_L10N.getStr("boxmodel.title"),
            component: BoxModel,
            componentProps: this.props,
            opened: Services.prefs.getBoolPref(BOXMODEL_OPENED_PREF),
            onToggled: () => {
              let opened = Services.prefs.getBoolPref(BOXMODEL_OPENED_PREF);
              Services.prefs.setBoolPref(BOXMODEL_OPENED_PREF, !opened);
            }
          },
        ]
      })
    );
  },

});

module.exports = connect(state => state)(App);
