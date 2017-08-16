// Copyright 2012 Mozilla Corporation. All rights reserved.
// This code is governed by the license found in the LICENSE file.

/*---
es5id: 13.3.1_L15
description: >
    Tests that Date.prototype.toLocaleString meets the requirements
    for built-in objects defined by the introduction of chapter 17 of
    the ECMAScript Language Specification.
author: Norbert Lindenberg
includes: [testBuiltInObject.js]
---*/

testBuiltInObject(Date.prototype.toLocaleString, true, false, [], 0);

reportCompare(0, 0);
