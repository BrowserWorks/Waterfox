// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
info: The "length" property of the "toLocaleString" is 0
esid: sec-date.prototype.tolocalestring
description: The "length" property of the "toLocaleString" is 0
---*/

if (Date.prototype.toLocaleString.hasOwnProperty("length") !== true) {
  $ERROR('#1: The toLocaleString has a "length" property');
}

if (Date.prototype.toLocaleString.length !== 0) {
  $ERROR('#2: The "length" property of the toLocaleString is 0');
}

reportCompare(0, 0);
