// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
info: Operator remove leading StrWhiteSpaceChar
esid: sec-parseint-string-radix
description: "StrWhiteSpaceChar :: USP"
---*/

//CHECK#
var n;
var count = 0;
var errorCount = 0;
var uspU = ["\u1680", "\u2000", "\u2001", "\u2002", "\u2003", "\u2004", "\u2005", "\u2006", "\u2007", "\u2008", "\u2009", "\u200A", "\u202F", "\u205F", "\u3000"];
var uspS = ["1680", "2000", "2001", "2002", "2003", "2004", "2005", "2006", "2007", "2008", "2009", "200A", "202F", "205F", "3000"];

for (var index = 0; index < uspU.length; index++) {
  var result = true;
  n = false;
  if (parseInt(uspU[index] + "1") !== parseInt("1")) {
    $ERROR('#1.' + uspS[index] + ' ');
    result = false;
  }
  if (parseInt(uspU[index] + uspU[index] + uspU[index] + "1") !== parseInt("1")) {
    $ERROR('#2.' + uspS[index] + ' ');
    result = false;
  }
  n = parseInt(uspU[index]);
  if (!(n !== n)) {
    $ERROR('#3.' + uspS[index] + ' ');
    result = false;
  }
  if (result !== true) {
    errorCount++;
  }
  count++;
}

if (errorCount > 0) {
  $ERROR('Total error: ' + errorCount + ' bad Unicode character in ' + count);
}

reportCompare(0, 0);
