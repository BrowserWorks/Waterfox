/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
"use strict";

const general = {
  FREETEXT_FILTER_SEARCH_DELAY: 200,
};

const actionTypes = {
  TOGGLE_FILTER_TYPE: "TOGGLE_FILTER_TYPE",
  ENABLE_FILTER_TYPE_ONLY: "ENABLE_FILTER_TYPE_ONLY",
  TOGGLE_SIDEBAR: "TOGGLE_SIDEBAR",
  SHOW_SIDEBAR: "SHOW_SIDEBAR",
  DISABLE_TOGGLE_BUTTON: "DISABLE_TOGGLE_BUTTON",
  SET_FILTER_TEXT: "SET_FILTER_TEXT",
};

module.exports = Object.assign({}, general, actionTypes);
