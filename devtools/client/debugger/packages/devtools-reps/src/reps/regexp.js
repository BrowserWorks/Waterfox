/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at <http://mozilla.org/MPL/2.0/>. */

// ReactJS
const PropTypes = require("devtools/client/shared/vendor/react-prop-types");
const { span } = require("devtools/client/shared/vendor/react-dom-factories");

// Reps
const { getGripType, isGrip, wrapRender, ELLIPSIS } = require("./rep-utils");

/**
 * Renders a grip object with regular expression.
 */
RegExp.propTypes = {
  object: PropTypes.object.isRequired,
};

function RegExp(props) {
  const { object } = props;

  return span(
    {
      "data-link-actor-id": object.actor,
      className: "objectBox objectBox-regexp regexpSource",
    },
    getSource(object)
  );
}

function getSource(grip) {
  const { displayString } = grip;
  if (displayString?.type === "longString") {
    return `${displayString.initial}${ELLIPSIS}`;
  }

  return displayString;
}

// Registration
function supportsObject(object, noGrip = false) {
  if (noGrip === true || !isGrip(object)) {
    return false;
  }

  return getGripType(object, noGrip) == "RegExp";
}

// Exports from this module
module.exports = {
  rep: wrapRender(RegExp),
  supportsObject,
};
