// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
info: If R < 2 or R > 36, then return NaN
esid: sec-parseint-string-radix
description: R = 37
---*/

assert.sameValue(parseInt("0", 37), NaN, "0");
assert.sameValue(parseInt("1", 37), NaN, "1");
assert.sameValue(parseInt("2", 37), NaN, "2");
assert.sameValue(parseInt("3", 37), NaN, "3");
assert.sameValue(parseInt("4", 37), NaN, "4");
assert.sameValue(parseInt("5", 37), NaN, "5");
assert.sameValue(parseInt("6", 37), NaN, "6");
assert.sameValue(parseInt("7", 37), NaN, "7");
assert.sameValue(parseInt("8", 37), NaN, "8");
assert.sameValue(parseInt("9", 37), NaN, "9");
assert.sameValue(parseInt("10", 37), NaN, "10");
assert.sameValue(parseInt("11", 37), NaN, "11");

reportCompare(0, 0);
