// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
info: Operator remove leading StrWhiteSpaceChar
esid: sec-parseint-string-radix
description: "StrWhiteSpaceChar :: VT (U+000B)"
---*/

//CHECK#1
if (parseInt("\u000B1") !== parseInt("1")) {
  $ERROR('#1: parseInt("\\u000B1") === parseInt("1"). Actual: ' + (parseInt("\u000B1")));
}

//CHECK#2
if (parseInt("\u000B\u000B-1") !== parseInt("-1")) {
  $ERROR('#2: parseInt("\\u000B\\u000B-1") === parseInt("-1"). Actual: ' + (parseInt("\u000B\u000B-1")));
}

//CHECK#3
assert.sameValue(parseInt("\u000B"), NaN);

reportCompare(0, 0);
