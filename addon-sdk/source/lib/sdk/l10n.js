/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
"use strict";

module.metadata = {
  "stability": "stable"
};

lazyRequireModule(this, "./l10n/json/core", "json");
lazyRequire(this, "./l10n/core", {"get": "getKey"});
lazyRequireModule(this, "./l10n/properties/core", "properties");
lazyRequire(this, "./l10n/plural-rules", "getRulesForLocale");

const { XPCOMUtils } = require("resource://gre/modules/XPCOMUtils.jsm");

// Retrieve the plural mapping function
XPCOMUtils.defineLazyGetter(this, "pluralMappingFunction",
                            () => getRulesForLocale(json.language()) ||
                                  getRulesForLocale("en"));

exports.get = function get(k) {
  // For now, we only accept a "string" as first argument
  // TODO: handle plural forms in gettext pattern
  if (typeof k !== "string")
    throw new Error("First argument of localization method should be a string");
  let n = arguments[1];

  // Get translation from big hashmap or default to hard coded string:
  let localized = getKey(k, n) || k;

  // # Simplest usecase:
  //   // String hard coded in source code:
  //   _("Hello world")
  //   // Identifier of a key stored in properties file
  //   _("helloString")
  if (arguments.length <= 1)
    return localized;

  let args = Array.slice(arguments);
  let placeholders = [null, ...args.slice(typeof(n) === "number" ? 2 : 1)];

  if (typeof localized == "object" && "other" in localized) {
    // # Plural form:
    //   // Strings hard coded in source code:
    //   _(["One download", "%d downloads"], 10);
    //   // Identifier of a key stored in properties file
    //   _("downloadNumber", 0);
    let n = arguments[1];

    // First handle simple universal forms that may not be mandatory
    // for each language, (i.e. not different than 'other' form,
    // but still usefull for better phrasing)
    // For example 0 in english is the same form than 'other'
    // but we accept 'zero' form if specified in localization file
    if (n === 0 && "zero" in localized)
      localized = localized["zero"];
    else if (n === 1 && "one" in localized)
      localized = localized["one"];
    else if (n === 2 && "two" in localized)
      localized = localized["two"];
    else {
      let pluralForm = pluralMappingFunction(n);
      if (pluralForm in localized)
        localized = localized[pluralForm];
      else // Fallback in case of error: missing plural form
        localized = localized["other"];
    }

    // Simulate a string with one placeholder:
    args = [null, n];
  }

  // # String with placeholders:
  //   // Strings hard coded in source code:
  //   _("Hello %s", username)
  //   // Identifier of a key stored in properties file
  //   _("helloString", username)
  // * We supports `%1s`, `%2s`, ... pattern in order to change arguments order
  // in translation.
  // * In case of plural form, we has `%d` instead of `%s`.
  let offset = 1;
  if (placeholders.length > 1) {
    args = placeholders;
  }

  localized = localized.replace(/%(\d*)[sd]/g, (v, n) => {
    let rv = args[n != "" ? n : offset];
    offset++;
    return rv;
  });

  return localized;
}
