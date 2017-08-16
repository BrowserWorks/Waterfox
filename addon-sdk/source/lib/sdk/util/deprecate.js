/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

"use strict";

module.metadata = {
  "stability": "experimental"
};

lazyRequire(this, "../console/traceback", "get", "format");
lazyRequire(this, "../preferences/service", {"get": "getPref"});
const PREFERENCE = "devtools.errorconsole.deprecation_warnings";

function deprecateUsage(msg) {
  // Print caller stacktrace in order to help figuring out which code
  // does use deprecated thing
  let stack = get().slice(2);

  if (getPref(PREFERENCE)) 
    console.error("DEPRECATED: " + msg + "\n" + format(stack));
}
exports.deprecateUsage = deprecateUsage;

function deprecateFunction(fun, msg) {
  return function deprecated() {
    deprecateUsage(msg);
    return fun.apply(this, arguments);
  };
}
exports.deprecateFunction = deprecateFunction;

function deprecateEvent(fun, msg, evtTypes) {
  return function deprecateEvent(evtType) {
  	if (evtTypes.indexOf(evtType) >= 0)
      deprecateUsage(msg);
    return fun.apply(this, arguments);
  };
}
exports.deprecateEvent = deprecateEvent;
