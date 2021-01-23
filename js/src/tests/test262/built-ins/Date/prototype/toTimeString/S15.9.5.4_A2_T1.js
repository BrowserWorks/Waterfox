// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
info: The "length" property of the "toTimeString" is 0
esid: sec-date.prototype.totimestring
description: The "length" property of the "toTimeString" is 0
---*/

if (Date.prototype.toTimeString.hasOwnProperty("length") !== true) {
  $ERROR('#1: The toTimeString has a "length" property');
}

if (Date.prototype.toTimeString.length !== 0) {
  $ERROR('#2: The "length" property of the toTimeString is 0');
}

reportCompare(0, 0);
