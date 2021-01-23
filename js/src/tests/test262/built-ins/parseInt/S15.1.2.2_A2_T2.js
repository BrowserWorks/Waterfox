// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
info: Operator remove leading StrWhiteSpaceChar
esid: sec-parseint-string-radix
description: "StrWhiteSpaceChar :: SP (U+0020)"
---*/

//CHECK#1
if (parseInt("\u00201") !== parseInt("1")) {
  $ERROR('#1: parseInt("\\u00201") === parseInt("1"). Actual: ' + (parseInt("\u00201")));
}

//CHECK#2
if (parseInt("\u0020\u0020-1") !== parseInt("-1")) {
  $ERROR('#2: parseInt("\\u0020\\u0020-1") === parseInt("-1"). Actual: ' + (parseInt("\u0020\u0020-1")));
}

//CHECK#3
if (parseInt(" 1") !== parseInt("1")) {
  $ERROR('#3: parseInt(" 1") === parseInt("1"). Actual: ' + (parseInt(" 1")));
}

//CHECK#4
if (parseInt("       1") !== parseInt("1")) {
  $ERROR('#4: parseInt("       1") === parseInt("1"). Actual: ' + (parseInt("       1")));
}

//CHECK#5
if (parseInt("       \u0020       \u0020-1") !== parseInt("-1")) {
  $ERROR('#5: parseInt("       \\u0020       \\u0020-1") === parseInt("-1"). Actual: ' + (parseInt("       \u0020       \u0020-1")));
}

//CHECK#6
assert.sameValue(parseInt("\u0020"), NaN);

reportCompare(0, 0);
