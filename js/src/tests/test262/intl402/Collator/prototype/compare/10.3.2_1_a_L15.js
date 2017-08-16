// Copyright 2012 Mozilla Corporation. All rights reserved.
// This code is governed by the license found in the LICENSE file.

/*---
es5id: 10.3.2_1_a_L15
description: >
    Tests that the function returned by
    Intl.Collator.prototype.compare meets the requirements for
    built-in objects defined by the introduction of chapter 17 of the
    ECMAScript Language Specification.
author: Norbert Lindenberg
includes: [testBuiltInObject.js]
---*/

testBuiltInObject(new Intl.Collator().compare, true, false, [], 2);

reportCompare(0, 0);
