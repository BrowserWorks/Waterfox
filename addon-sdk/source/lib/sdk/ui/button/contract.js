/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
'use strict';

const { contract } = require('../../util/contract');
lazyRequire(this, '../../url', "isLocalURL");
lazyRequire(this, '../../lang/type', "isNil", "isObject", "isString");
const { required, either, string, boolean, object, number } = require('../../deprecated/api-utils');
const { merge } = require('../../util/object');
const { freeze } = Object;

const isIconSet = (icons) =>
  Object.keys(icons).
    every(size => String(size >>> 0) === size && isLocalURL(icons[size]));

var iconSet = {
  is: either(object, string),
  map: v => isObject(v) ? freeze(merge({}, v)) : v,
  ok: v => (isString(v) && isLocalURL(v)) || (isObject(v) && isIconSet(v)),
  msg: 'The option "icon" must be a local URL or an object with ' +
    'numeric keys / local URL values pair.'
}

var id = {
  is: string,
  ok: v => /^[a-z-_][a-z0-9-_]*$/i.test(v),
  msg: 'The option "id" must be a valid alphanumeric id (hyphens and ' +
        'underscores are allowed).'
};

var label = {
  is: string,
  ok: v => isNil(v) || v.trim().length > 0,
  msg: 'The option "label" must be a non empty string'
}

var badge = {
  is: either(string, number),
  msg: 'The option "badge" must be a string or a number'
}

var badgeColor = {
  is: string,
  msg: 'The option "badgeColor" must be a string'
}

var stateContract = contract({
  label: label,
  icon: iconSet,
  disabled: boolean,
  badge: badge,
  badgeColor: badgeColor
});

exports.stateContract = stateContract;

var buttonContract = contract(merge({}, stateContract.rules, {
  id: required(id),
  label: required(label),
  icon: required(iconSet)
}));

exports.buttonContract = buttonContract;

exports.toggleStateContract = contract(merge({
  checked: boolean
}, stateContract.rules));

exports.toggleButtonContract = contract(merge({
  checked: boolean
}, buttonContract.rules));

