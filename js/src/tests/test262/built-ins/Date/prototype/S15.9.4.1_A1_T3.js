// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
info: |
    The Date property "prototype" has { DontEnum, DontDelete, ReadOnly }
    attributes
esid: sec-date.prototype
description: Checking DontEnum attribute
---*/

if (Date.propertyIsEnumerable('prototype')) {
  $ERROR('#1: The Date.prototype property has the attribute DontEnum');
}

for (var x in Date) {
  if (x === "prototype") {
    $ERROR('#2: The Date.prototype has the attribute DontEnum');
  }
}

reportCompare(0, 0);
