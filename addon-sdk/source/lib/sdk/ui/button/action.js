/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
'use strict';

module.metadata = {
  'stability': 'experimental',
  'engines': {
    'Firefox': '> 28'
  }
};

const { Class } = require('../../core/heritage');
const { merge } = require('../../util/object');
const { Disposable } = require('../../core/disposable');
lazyRequire(this, '../../event/core', "on", "off", "emit", "setListeners");
const { EventTarget } = require('../../event/target');
lazyRequire(this, '../../view/core', "getNodeView");

lazyRequireModule(this, './view', "view");
const { buttonContract, stateContract } = require('./contract');
lazyRequire(this, '../state', "properties", "render", "state", "register",
            "unregister", "getDerivedStateFor");
lazyRequire(this, '../state/events', { "events": "stateEvents" });
lazyRequire(this, './view/events', { "events": "viewEvents" });
lazyRequireModule(this, '../../event/utils', "events");

lazyRequire(this, '../../tabs/utils', "getActiveTab");

lazyRequire(this, '../../self', { "id": "addonID" });
lazyRequire(this, '../id', "identify");

const buttons = new Map();

const toWidgetId = id =>
  ('action-button--' + addonID.toLowerCase()+ '-' + id).
    replace(/[^a-z0-9_-]/g, '');

const ActionButton = Class({
  extends: EventTarget,
  implements: [
    properties(stateContract),
    state(stateContract),
    Disposable
  ],
  setup: function setup(options) {
    let state = merge({
      disabled: false
    }, buttonContract(options));

    let id = toWidgetId(options.id);

    register(this, state);

    // Setup listeners.
    setListeners(this, options);

    buttons.set(id, this);

    view.create(merge({}, state, { id: id }));
  },

  dispose: function dispose() {
    let id = toWidgetId(this.id);
    buttons.delete(id);

    off(this);

    view.dispose(id);

    unregister(this);
  },

  get id() {
    return this.state().id;
  },

  click: function click() { view.click(toWidgetId(this.id)) }
});
exports.ActionButton = ActionButton;

identify.define(ActionButton, ({id}) => toWidgetId(id));

getNodeView.define(ActionButton, button =>
  view.nodeFor(toWidgetId(button.id))
);

var actionButtonStateEvents = events.filter(stateEvents,
  e => e.target instanceof ActionButton);

var actionButtonViewEvents = events.filter(viewEvents,
  e => buttons.has(e.target));

var clickEvents = events.filter(actionButtonViewEvents, e => e.type === 'click');
var updateEvents = events.filter(actionButtonViewEvents, e => e.type === 'update');

on(clickEvents, 'data', ({target: id, window}) => {
  let button = buttons.get(id);
  let state = getDerivedStateFor(button, getActiveTab(window));

  emit(button, 'click', state);
});

on(updateEvents, 'data', ({target: id, window}) => {
  render(buttons.get(id), window);
});

on(actionButtonStateEvents, 'data', ({target, window, state}) => {
  let id = toWidgetId(target.id);
  view.setIcon(id, window, state.icon);
  view.setLabel(id, window, state.label);
  view.setDisabled(id, window, state.disabled);
  view.setBadge(id, window, state.badge, state.badgeColor);
});
