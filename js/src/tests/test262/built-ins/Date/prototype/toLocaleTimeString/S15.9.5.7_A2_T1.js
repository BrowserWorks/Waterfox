// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
info: The "length" property of the "toLocaleTimeString" is 0
esid: sec-date.prototype.tolocaletimestring
description: The "length" property of the "toLocaleTimeString" is 0
---*/

if (Date.prototype.toLocaleTimeString.hasOwnProperty("length") !== true) {
  $ERROR('#1: The toLocaleTimeString has a "length" property');
}

if (Date.prototype.toLocaleTimeString.length !== 0) {
  $ERROR('#2: The "length" property of the toLocaleTimeString is 0');
}

reportCompare(0, 0);
