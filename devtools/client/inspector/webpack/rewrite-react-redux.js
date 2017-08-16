/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

module.exports = function (content) {
  this.cacheable && this.cacheable();

  return content.replace(
    "require(REACT_PATH)",
    "require(\"devtools/client/shared/vendor/react\")"
  ).replace(
    "require(REDUX_PATH)",
    "require(\"devtools/client/shared/vendor/redux\")"
  );
};
