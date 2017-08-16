/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
"use strict";

module.metadata = {
  "stability": "unstable"
};

const { Class } = require('../core/heritage');
lazyRequire(this, './match-pattern', "MatchPattern");
lazyRequire(this, '../event/core', "emit");
const { EventTarget } = require('../event/target');
const { List, addListItem, removeListItem } = require('./list');

// Should deprecate usage of EventEmitter/compose
const Rules = Class({
  implements: [
    EventTarget,
    List
  ],
  add: function(...rules) {
    return [].concat(rules).forEach(function onAdd(rule) {
      addListItem(this, rule);
      emit(this, 'add', rule);
    }, this);
  },
  remove: function(...rules) {
    return [].concat(rules).forEach(function onRemove(rule) {
      removeListItem(this, rule);
      emit(this, 'remove', rule);
    }, this);
  },
  get: function(rule) {
    let found = false;
    for (let i in this) if (this[i] === rule) found = true;
    return found;
  },
  // Returns true if uri matches atleast one stored rule
  matchesAny: function(uri) {
    return !!filterMatches(this, uri).length;
  },
  toString: () => '[object Rules]'
});
exports.Rules = Rules;

function filterMatches(instance, uri) {
  let matches = [];
  for (let i in instance) {
    if (new MatchPattern(instance[i]).test(uri)) matches.push(instance[i]);
  }
  return matches;
}
