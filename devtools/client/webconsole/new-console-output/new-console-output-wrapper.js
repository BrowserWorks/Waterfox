/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
"use strict";

// React & Redux
const React = require("devtools/client/shared/vendor/react");
const ReactDOM = require("devtools/client/shared/vendor/react-dom");
const { Provider } = require("devtools/client/shared/vendor/react-redux");

const actions = require("devtools/client/webconsole/new-console-output/actions/index");
const { configureStore } = require("devtools/client/webconsole/new-console-output/store");

const ConsoleOutput = React.createFactory(require("devtools/client/webconsole/new-console-output/components/console-output"));
const FilterBar = React.createFactory(require("devtools/client/webconsole/new-console-output/components/filter-bar"));

const store = configureStore();
let queuedActions = [];
let throttledDispatchTimeout = false;

function NewConsoleOutputWrapper(parentNode, jsterm, toolbox, owner, document) {
  this.parentNode = parentNode;
  this.jsterm = jsterm;
  this.toolbox = toolbox;
  this.owner = owner;
  this.document = document;

  this.init = this.init.bind(this);
}

NewConsoleOutputWrapper.prototype = {
  init: function () {
    const attachRefToHud = (id, node) => {
      this.jsterm.hud[id] = node;
    };

    let childComponent = ConsoleOutput({
      serviceContainer: {
        attachRefToHud,
        emitNewMessage: (node, messageId) => {
          this.jsterm.hud.emit("new-messages", new Set([{
            node,
            messageId,
          }]));
        },
        hudProxyClient: this.jsterm.hud.proxy.client,
        onViewSourceInDebugger: frame => this.toolbox.viewSourceInDebugger.call(
          this.toolbox,
          frame.url,
          frame.line
        ),
        openNetworkPanel: (requestId) => {
          return this.toolbox.selectTool("netmonitor").then(panel => {
            return panel.panelWin.NetMonitorController.inspectRequest(requestId);
          });
        },
        sourceMapService: this.toolbox ? this.toolbox._sourceMapService : null,
        openLink: url => this.jsterm.hud.owner.openLink.call(this.jsterm.hud.owner, url),
        createElement: nodename => {
          return this.document.createElementNS("http://www.w3.org/1999/xhtml", nodename);
        }
      }
    });
    let filterBar = FilterBar({
      serviceContainer: {
        attachRefToHud
      }
    });
    let provider = React.createElement(
      Provider,
      { store },
      React.DOM.div(
        {className: "webconsole-output-wrapper"},
        filterBar,
        childComponent
    ));

    this.body = ReactDOM.render(provider, this.parentNode);
  },

  dispatchMessageAdd: function (message, waitForResponse) {
    let action = actions.messageAdd(message);
    batchedMessageAdd(action);

    // Wait for the message to render to resolve with the DOM node.
    // This is just for backwards compatibility with old tests, and should
    // be removed once it's not needed anymore.
    // Can only wait for response if the action contains a valid message.
    if (waitForResponse && action.message) {
      let messageId = action.message.get("id");
      return new Promise(resolve => {
        let jsterm = this.jsterm;
        jsterm.hud.on("new-messages", function onThisMessage(e, messages) {
          for (let m of messages) {
            if (m.messageId == messageId) {
              resolve(m.node);
              jsterm.hud.off("new-messages", onThisMessage);
              return;
            }
          }
        });
      });
    }

    return Promise.resolve();
  },

  dispatchMessagesAdd: function (messages) {
    const batchedActions = messages.map(message => actions.messageAdd(message));
    store.dispatch(actions.batchActions(batchedActions));
  },

  dispatchMessagesClear: function () {
    store.dispatch(actions.messagesClear());
  },
  // Should be used for test purpose only.
  getStore: function () {
    return store;
  }
};

function batchedMessageAdd(action) {
  queuedActions.push(action);
  if (!throttledDispatchTimeout) {
    throttledDispatchTimeout = setTimeout(() => {
      store.dispatch(actions.batchActions(queuedActions));
      queuedActions = [];
      throttledDispatchTimeout = null;
    }, 50);
  }
}

// Exports from this module
module.exports = NewConsoleOutputWrapper;
