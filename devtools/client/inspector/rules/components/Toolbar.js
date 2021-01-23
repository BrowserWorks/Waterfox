/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const {
  createFactory,
  PureComponent,
} = require("devtools/client/shared/vendor/react");
const dom = require("devtools/client/shared/vendor/react-dom-factories");
const PropTypes = require("devtools/client/shared/vendor/react-prop-types");
const { connect } = require("devtools/client/shared/vendor/react-redux");
const { COLOR_SCHEMES } = require("devtools/client/inspector/rules/constants");

const SearchBox = createFactory(
  require("devtools/client/inspector/rules/components/SearchBox")
);

loader.lazyGetter(this, "ClassListPanel", function() {
  return createFactory(
    require("devtools/client/inspector/rules/components/ClassListPanel")
  );
});
loader.lazyGetter(this, "PseudoClassPanel", function() {
  return createFactory(
    require("devtools/client/inspector/rules/components/PseudoClassPanel")
  );
});

const { getStr } = require("devtools/client/inspector/rules/utils/l10n");

class Toolbar extends PureComponent {
  static get propTypes() {
    return {
      isAddRuleEnabled: PropTypes.bool.isRequired,
      isClassPanelExpanded: PropTypes.bool.isRequired,
      isColorSchemeSimulationHidden: PropTypes.bool.isRequired,
      isPrintSimulationHidden: PropTypes.bool.isRequired,
      onAddClass: PropTypes.func.isRequired,
      onAddRule: PropTypes.func.isRequired,
      onSetClassState: PropTypes.func.isRequired,
      onToggleClassPanelExpanded: PropTypes.func.isRequired,
      onToggleColorSchemeSimulation: PropTypes.func.isRequired,
      onTogglePrintSimulation: PropTypes.func.isRequired,
      onTogglePseudoClass: PropTypes.func.isRequired,
    };
  }

  constructor(props) {
    super(props);

    this.state = {
      // Which of the color schemes is simulated, if any.
      currentColorScheme: 0,
      // Whether or not the print simulation button is enabled.
      isPrintSimulationEnabled: false,
      // Whether or not the pseudo class panel is expanded.
      isPseudoClassPanelExpanded: false,
    };

    this.onAddRuleClick = this.onAddRuleClick.bind(this);
    this.onClassPanelToggle = this.onClassPanelToggle.bind(this);
    this.onColorSchemeSimulationClick = this.onColorSchemeSimulationClick.bind(
      this
    );
    this.onPrintSimulationToggle = this.onPrintSimulationToggle.bind(this);
    this.onPseudoClassPanelToggle = this.onPseudoClassPanelToggle.bind(this);
  }

  onAddRuleClick(event) {
    event.stopPropagation();
    this.props.onAddRule();
  }

  onClassPanelToggle(event) {
    event.stopPropagation();

    const isClassPanelExpanded = !this.props.isClassPanelExpanded;
    this.props.onToggleClassPanelExpanded(isClassPanelExpanded);
    this.setState(prevState => {
      return {
        isPseudoClassPanelExpanded: isClassPanelExpanded
          ? false
          : prevState.isPseudoClassPanelExpanded,
      };
    });
  }

  onColorSchemeSimulationClick(event) {
    event.stopPropagation();

    this.props.onToggleColorSchemeSimulation();
    this.setState(prevState => ({
      currentColorScheme:
        (prevState.currentColorScheme + 1) % COLOR_SCHEMES.length,
    }));
  }

  onPrintSimulationToggle(event) {
    event.stopPropagation();
    this.props.onTogglePrintSimulation();
    this.setState(prevState => ({
      isPrintSimulationEnabled: !prevState.isPrintSimulationEnabled,
    }));
  }

  onPseudoClassPanelToggle(event) {
    event.stopPropagation();

    const isPseudoClassPanelExpanded = !this.state.isPseudoClassPanelExpanded;

    if (isPseudoClassPanelExpanded) {
      this.props.onToggleClassPanelExpanded(false);
    }

    this.setState({ isPseudoClassPanelExpanded });
  }

  render() {
    const {
      isAddRuleEnabled,
      isClassPanelExpanded,
      isColorSchemeSimulationHidden,
      isPrintSimulationHidden,
    } = this.props;
    const { isPrintSimulationEnabled, isPseudoClassPanelExpanded } = this.state;

    return dom.div(
      {
        id: "ruleview-toolbar-container",
      },
      dom.div(
        {
          id: "ruleview-toolbar",
          className: "devtools-toolbar devtools-input-toolbar",
        },
        SearchBox({}),
        dom.div({ className: "devtools-separator" }),
        dom.div(
          { id: "ruleview-command-toolbar" },
          dom.button({
            id: "pseudo-class-panel-toggle",
            className:
              "devtools-button" +
              (isPseudoClassPanelExpanded ? " checked" : ""),
            onClick: this.onPseudoClassPanelToggle,
            title: getStr("rule.togglePseudo.tooltip"),
          }),
          dom.button({
            id: "class-panel-toggle",
            className:
              "devtools-button" + (isClassPanelExpanded ? " checked" : ""),
            onClick: this.onClassPanelToggle,
            title: getStr("rule.classPanel.toggleClass.tooltip"),
          }),
          dom.button({
            id: "ruleview-add-rule-button",
            className: "devtools-button",
            disabled: !isAddRuleEnabled,
            onClick: this.onAddRuleClick,
            title: getStr("rule.addRule.tooltip"),
          }),
          isColorSchemeSimulationHidden
            ? dom.button({
                id: "color-scheme-simulation-toggle",
                className: "devtools-button",
                onClick: this.onColorSchemeSimulationClick,
                state: COLOR_SCHEMES[this.state.currentColorScheme],
                title: getStr("rule.colorSchemeSimulation.tooltip"),
              })
            : null,
          !isPrintSimulationHidden
            ? dom.button({
                id: "print-simulation-toggle",
                className:
                  "devtools-button" +
                  (isPrintSimulationEnabled ? " checked" : ""),
                onClick: this.onPrintSimulationToggle,
                title: getStr("rule.printSimulation.tooltip"),
              })
            : null
        )
      ),
      isClassPanelExpanded
        ? ClassListPanel({
            onAddClass: this.props.onAddClass,
            onSetClassState: this.props.onSetClassState,
          })
        : null,
      isPseudoClassPanelExpanded
        ? PseudoClassPanel({
            onTogglePseudoClass: this.props.onTogglePseudoClass,
          })
        : null
    );
  }
}

const mapStateToProps = state => {
  return {
    isAddRuleEnabled: state.rules.isAddRuleEnabled,
    isClassPanelExpanded: state.classList.isClassPanelExpanded,
    isColorSchemeSimulationHidden: state.rules.isColorSchemeSimulationHidden,
    isPrintSimulationHidden: state.rules.isPrintSimulationHidden,
  };
};

module.exports = connect(mapStateToProps)(Toolbar);
