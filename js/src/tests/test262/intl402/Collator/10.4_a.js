// Copyright 2012 Mozilla Corporation. All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
es5id: 10.4_a
description: Tests that Intl.Collator instances have the specified properties.
author: Norbert Lindenberg
---*/

var obj = new Intl.Collator();

var toStringValue = Object.prototype.toString.call(obj);
assert.sameValue(toStringValue, "[object Object]", "Intl.Collator instance produces wrong [[Class]] - toString returns " + toStringValue + ".");

reportCompare(0, 0);
