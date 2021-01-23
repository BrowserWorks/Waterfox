// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
info: The Date.prototype property "getMonth" has { DontEnum } attributes
esid: sec-date.prototype.getmonth
description: Checking DontEnum attribute
---*/

if (Date.prototype.propertyIsEnumerable('getMonth')) {
  $ERROR('#1: The Date.prototype.getMonth property has the attribute DontEnum');
}

for (var x in Date.prototype) {
  if (x === "getMonth") {
    $ERROR('#2: The Date.prototype.getMonth has the attribute DontEnum');
  }
}

reportCompare(0, 0);
