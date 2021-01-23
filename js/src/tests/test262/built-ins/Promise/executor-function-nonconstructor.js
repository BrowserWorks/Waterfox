// Copyright (C) 2015 André Bargull. All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
esid: sec-getcapabilitiesexecutor-functions
description: GetCapabilitiesExecutor function is not constructor
info: |
  17 ECMAScript Standard Built-in Objects:
    Built-in function objects that are not identified as constructors do not
    implement the [[Construct]] internal method unless otherwise specified
    in the description of a particular function.
includes: [isConstructor.js]
features: [Reflect.construct]
---*/

var executorFunction;

function NotPromise(executor) {
  executorFunction = executor;
  executor(function() {}, function() {});
}
Promise.resolve.call(NotPromise);

assert.sameValue(Object.prototype.hasOwnProperty.call(executorFunction, "prototype"), false);
assert.sameValue(isConstructor(executorFunction), false);

reportCompare(0, 0);
