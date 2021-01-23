// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
info: Operator use ToInt32
esid: sec-parseint-string-radix
description: ToInt32 use modulo
---*/

//CHECK#1
if (parseInt("11", 4294967298) !== parseInt("11", 2)) {
  $ERROR('#1: parseInt("11", 4294967298) === parseInt("11", 2). Actual: ' + (parseInt("11", 4294967298)));
}

//CHECK#2
if (parseInt("11", 4294967296) !== parseInt("11", 10)) {
  $ERROR('#2: parseInt("11", 4294967296) === parseInt("11", 10). Actual: ' + (parseInt("11", 4294967296)));
}

//CHECK#3
assert.sameValue(parseInt("11", -2147483650), NaN, "-2147483650");

//CHECK#4
if (parseInt("11", -4294967294) !== parseInt("11", 2)) {
  $ERROR('#4: parseInt("11", -4294967294) === parseInt("11", 2). Actual: ' + (parseInt("11", -4294967294)));
}

reportCompare(0, 0);
