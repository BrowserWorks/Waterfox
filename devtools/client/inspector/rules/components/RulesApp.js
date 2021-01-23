/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

const Services = require("Services");
const {
  createElement,
  createFactory,
  Fragment,
  PureComponent,
} = require("devtools/client/shared/vendor/react");
const dom = require("devtools/client/shared/vendor/react-dom-factories");
const PropTypes = require("devtools/client/shared/vendor/react-prop-types");
const { connect } = require("devtools/client/shared/vendor/react-redux");

const Accordion = createFactory(
  require("devtools/client/shared/components/Accordion")
);
const Rule = createFactory(
  require("devtools/client/inspector/rules/components/Rule")
);
const Rules = createFactory(
  require("devtools/client/inspector/rules/components/Rules")
);
const Toolbar = createFactory(
  require("devtools/client/inspector/rules/components/Toolbar")
);

const { getStr } = require("devtools/client/inspector/rules/utils/l10n");
const Types = require("devtools/client/inspector/rules/types");

const SHOW_PSEUDO_ELEMENTS_PREF = "devtools.inspector.show_pseudo_elements";

class RulesApp extends PureComponent {
  static get propTypes() {
    return {
      onAddClass: PropTypes.func.isRequired,
      onAddRule: PropTypes.func.isRequired,
      onOpenSourceLink: PropTypes.func.isRequired,
      onSetClassState: PropTypes.func.isRequired,
      onToggleClassPanelExpanded: PropTypes.func.isRequired,
      onToggleDeclaration: PropTypes.func.isRequired,
      onTogglePrintSimulation: PropTypes.func.isRequired,
      onToggleColorSchemeSimulation: PropTypes.func.isRequired,
      onTogglePseudoClass: PropTypes.func.isRequired,
      onToggleSelectorHighlighter: PropTypes.func.isRequired,
      rules: PropTypes.arrayOf(PropTypes.shape(Types.rule)).isRequired,
      showContextMenu: PropTypes.func.isRequired,
      showDeclarationNameEditor: PropTypes.func.isRequired,
      showDeclarationValueEditor: PropTypes.func.isRequired,
      showNewDeclarationEditor: PropTypes.func.isRequired,
      showSelectorEditor: PropTypes.func.isRequired,
    };
  }

  constructor(props) {
    super(props);
    this.onContextMenu = this.onContextMenu.bind(this);
  }

  getRuleProps() {
    return {
      onOpenSourceLink: this.props.onOpenSourceLink,
      onToggleDeclaration: this.props.onToggleDeclaration,
      onToggleSelectorHighlighter: this.props.onToggleSelectorHighlighter,
      showDeclarationNameEditor: this.props.showDeclarationNameEditor,
      showDeclarationValueEditor: this.props.showDeclarationValueEditor,
      showNewDeclarationEditor: this.props.showNewDeclarationEditor,
      showSelectorEditor: this.props.showSelectorEditor,
    };
  }

  onContextMenu(event) {
    if (
      event.target.closest("input[type=text]") ||
      event.target.closest("input:not([type])") ||
      event.target.closest("textarea")
    ) {
      return;
    }

    event.stopPropagation();
    event.preventDefault();

    this.props.showContextMenu(event);
  }

  renderInheritedRules(rules) {
    if (!rules.length) {
      return null;
    }

    const output = [];
    let lastInherited;

    for (const rule of rules) {
      if (rule.inheritance.inherited !== lastInherited) {
        lastInherited = rule.inheritance.inherited;

        output.push(
          dom.div(
            { className: "ruleview-header" },
            rule.inheritance.inheritedSource
          )
        );
      }

      output.push(
        Rule({
          ...this.getRuleProps(),
          rule,
        })
      );
    }

    return output;
  }

  renderKeyframesRules(rules) {
    if (!rules.length) {
      return null;
    }

    const output = [];
    let lastKeyframes;

    for (const rule of rules) {
      if (rule.keyframesRule.id === lastKeyframes) {
        continue;
      }

      lastKeyframes = rule.keyframesRule.id;

      const items = [
        {
          component: Rules,
          componentProps: {
            ...this.getRuleProps(),
            rules: rules.filter(r => r.keyframesRule.id === lastKeyframes),
          },
          header: rule.keyframesRule.keyframesName,
          id: "rules-section-keyframes",
          opened: true,
        },
      ];

      output.push(Accordion({ items }));
    }

    return output;
  }

  renderStyleRules(rules) {
    if (!rules.length) {
      return null;
    }

    return Rules({
      ...this.getRuleProps(),
      rules,
    });
  }

  renderPseudoElementRules(rules) {
    if (!rules.length) {
      return null;
    }

    const items = [
      {
        component: Rules,
        componentProps: {
          ...this.getRuleProps(),
          rules,
        },
        header: getStr("rule.pseudoElement"),
        id: "rules-section-pseudoelement",
        opened: Services.prefs.getBoolPref(SHOW_PSEUDO_ELEMENTS_PREF),
        onToggle: opened => {
          Services.prefs.setBoolPref(SHOW_PSEUDO_ELEMENTS_PREF, opened);
        },
      },
    ];

    return createElement(
      Fragment,
      null,
      Accordion({ items }),
      dom.div({ className: "ruleview-header" }, getStr("rule.selectedElement"))
    );
  }

  render() {
    const { rules } = this.props.rules;
    const inheritedRules = [];
    const keyframesRules = [];
    const pseudoElementRules = [];
    const styleRules = [];

    for (const rule of rules) {
      if (rule.inheritance) {
        inheritedRules.push(rule);
      } else if (rule.keyframesRule) {
        keyframesRules.push(rule);
      } else if (rule.pseudoElement) {
        pseudoElementRules.push(rule);
      } else {
        styleRules.push(rule);
      }
    }

    return dom.div(
      {
        id: "sidebar-panel-ruleview",
        className: "theme-sidebar inspector-tabpanel",
      },
      Toolbar({
        onAddClass: this.props.onAddClass,
        onAddRule: this.props.onAddRule,
        onSetClassState: this.props.onSetClassState,
        onToggleClassPanelExpanded: this.props.onToggleClassPanelExpanded,
        onTogglePrintSimulation: this.props.onTogglePrintSimulation,
        onToggleColorSchemeSimulation: this.props.onToggleColorSchemeSimulation,
        onTogglePseudoClass: this.props.onTogglePseudoClass,
      }),
      dom.div(
        {
          id: "ruleview-container",
          className: "ruleview",
        },
        dom.div(
          {
            id: "ruleview-container-focusable",
            onContextMenu: this.onContextMenu,
            tabIndex: -1,
          },
          rules.length > 0
            ? createElement(
                Fragment,
                null,
                this.renderPseudoElementRules(pseudoElementRules),
                this.renderStyleRules(styleRules),
                this.renderInheritedRules(inheritedRules),
                this.renderKeyframesRules(keyframesRules)
              )
            : dom.div(
                { className: "devtools-sidepanel-no-result" },
                getStr("rule.empty")
              )
        )
      )
    );
  }
}

module.exports = connect(state => state)(RulesApp);
