// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
info: Operator remove leading StrWhiteSpaceChar
esid: sec-parseint-string-radix
description: "StrWhiteSpaceChar :: NBSB (U+00A0)"
---*/

//CHECK#1
if (parseInt("\u00A01") !== parseInt("1")) {
  $ERROR('#1: parseInt("\\u00A01") === parseInt("1"). Actual: ' + (parseInt("\u00A01")));
}

//CHECK#2
if (parseInt("\u00A0\u00A0-1") !== parseInt("-1")) {
  $ERROR('#2: parseInt("\\u00A0\\u00A0-1") === parseInt("-1"). Actual: ' + (parseInt("\u00A0\u00A0-1")));
}

//CHECK#3
assert.sameValue(parseInt("\u00A0"), NaN);

reportCompare(0, 0);
