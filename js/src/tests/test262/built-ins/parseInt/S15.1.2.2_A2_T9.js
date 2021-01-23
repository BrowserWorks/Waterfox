// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
info: Operator remove leading StrWhiteSpaceChar
esid: sec-parseint-string-radix
description: "StrWhiteSpaceChar :: PS (U+2029)"
---*/

//CHECK#1
if (parseInt("\u20291") !== parseInt("1")) {
  $ERROR('#1: parseInt("\\u20291") === parseInt("1"). Actual: ' + (parseInt("\u20291")));
}

//CHECK#2
if (parseInt("\u2029\u2029-1") !== parseInt("-1")) {
  $ERROR('#2: parseInt("\\u2029\\u2029-1") === parseInt("-1"). Actual: ' + (parseInt("\u2029\u2029-1")));
}

//CHECK#3
assert.sameValue(parseInt("\u2029"), NaN);

reportCompare(0, 0);
