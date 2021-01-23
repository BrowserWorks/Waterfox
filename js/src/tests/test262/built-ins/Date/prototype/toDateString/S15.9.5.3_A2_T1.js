// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
info: The "length" property of the "toDateString" is 0
esid: sec-date.prototype.todatestring
description: The "length" property of the "toDateString" is 0
---*/

if (Date.prototype.toDateString.hasOwnProperty("length") !== true) {
  $ERROR('#1: The toDateString has a "length" property');
}

if (Date.prototype.toDateString.length !== 0) {
  $ERROR('#2: The "length" property of the toDateString is 0');
}

reportCompare(0, 0);
