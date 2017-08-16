// Copyright 2012 Mozilla Corporation. All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
es5id: 11.3_b
description: >
    Tests that Intl.NumberFormat.prototype functions throw a
    TypeError if called on a non-object value or an object that hasn't
    been  initialized as a NumberFormat.
author: Norbert Lindenberg
---*/

var functions = {
    "format getter": Object.getOwnPropertyDescriptor(Intl.NumberFormat.prototype, "format").get,
    resolvedOptions: Intl.NumberFormat.prototype.resolvedOptions
};
var invalidTargets = [undefined, null, true, 0, "NumberFormat", [], {}];

Object.getOwnPropertyNames(functions).forEach(function (functionName) {
    var f = functions[functionName];
    invalidTargets.forEach(function (target) {
        assert.throws(TypeError, function() {
            f.call(target);
        }, "Calling " + functionName + " on " + target + " was not rejected.");
    });
});

reportCompare(0, 0);
