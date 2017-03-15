/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

"use strict";

// Tests that the localization utils work properly.

const { LocalizationHelper } = require("devtools/shared/l10n");

function test() {
  let l10n = new LocalizationHelper();

  is(l10n.numberWithDecimals(1234.56789, 2), "1,234.57",
    "The first number was properly localized.");
  is(l10n.numberWithDecimals(0.0001, 2), "0",
    "The second number was properly localized.");
  is(l10n.numberWithDecimals(1.0001, 2), "1",
    "The third number was properly localized.");
  is(l10n.numberWithDecimals(NaN, 2), "0",
    "NaN was properly localized.");
  is(l10n.numberWithDecimals(null, 2), "0",
    "`null` was properly localized.");
  is(l10n.numberWithDecimals(undefined, 2), "0",
    "`undefined` was properly localized.");

  finish();
}
