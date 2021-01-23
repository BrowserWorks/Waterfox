/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

module.exports = {
  // Extend from the devtools eslintrc.
  extends: "../../../.eslintrc.js",

  rules: {
    // The inspector is being migrated to HTML and cleaned of
    // chrome-privileged code, so this rule disallows requiring chrome
    // code. Some files here disable this rule still. The
    // goal is to enable the rule globally on all files.
    "mozilla/reject-some-requires": [
      "error",
      "^(chrome|chrome:.*|resource:.*|devtools/server/.*|.*\\.jsm)$",
    ],
  },
};
