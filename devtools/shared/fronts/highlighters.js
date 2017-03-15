/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
"use strict";

const { FrontClassWithSpec, custom } = require("devtools/shared/protocol");
const {
  customHighlighterSpec,
  highlighterSpec
} = require("devtools/shared/specs/highlighters");

const HighlighterFront = FrontClassWithSpec(highlighterSpec, {
  // Update the object given a form representation off the wire.
  form: function (json) {
    this.actorID = json.actor;
    // FF42+ HighlighterActors starts exposing custom form, with traits object
    this.traits = json.traits || {};
  },

  pick: custom(function (doFocus) {
    if (doFocus && this.pickAndFocus) {
      return this.pickAndFocus();
    }
    return this._pick();
  }, {
    impl: "_pick"
  })
});

exports.HighlighterFront = HighlighterFront;

const CustomHighlighterFront = FrontClassWithSpec(customHighlighterSpec, {});

exports.CustomHighlighterFront = CustomHighlighterFront;
