// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
info: The "length" property of the "getUTCMonth" is 0
esid: sec-date.prototype.getutcmonth
description: The "length" property of the "getUTCMonth" is 0
---*/

if (Date.prototype.getUTCMonth.hasOwnProperty("length") !== true) {
  $ERROR('#1: The getUTCMonth has a "length" property');
}

if (Date.prototype.getUTCMonth.length !== 0) {
  $ERROR('#2: The "length" property of the getUTCMonth is 0');
}

reportCompare(0, 0);
