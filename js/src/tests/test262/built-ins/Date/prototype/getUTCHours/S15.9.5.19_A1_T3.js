// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
info: The Date.prototype property "getUTCHours" has { DontEnum } attributes
esid: sec-date.prototype.getutchours
description: Checking DontEnum attribute
---*/

if (Date.prototype.propertyIsEnumerable('getUTCHours')) {
  $ERROR('#1: The Date.prototype.getUTCHours property has the attribute DontEnum');
}

for (var x in Date.prototype) {
  if (x === "getUTCHours") {
    $ERROR('#2: The Date.prototype.getUTCHours has the attribute DontEnum');
  }
}

reportCompare(0, 0);
