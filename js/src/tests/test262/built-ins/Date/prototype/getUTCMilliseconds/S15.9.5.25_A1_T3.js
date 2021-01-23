// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
info: |
    The Date.prototype property "getUTCMilliseconds" has { DontEnum }
    attributes
esid: sec-date.prototype.getutcmilliseconds
description: Checking DontEnum attribute
---*/

if (Date.prototype.propertyIsEnumerable('getUTCMilliseconds')) {
  $ERROR('#1: The Date.prototype.getUTCMilliseconds property has the attribute DontEnum');
}

for (var x in Date.prototype) {
  if (x === "getUTCMilliseconds") {
    $ERROR('#2: The Date.prototype.getUTCMilliseconds has the attribute DontEnum');
  }
}

reportCompare(0, 0);
