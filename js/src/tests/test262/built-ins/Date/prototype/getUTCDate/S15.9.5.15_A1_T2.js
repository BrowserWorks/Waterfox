// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
info: The Date.prototype property "getUTCDate" has { DontEnum } attributes
esid: sec-date.prototype.getutcdate
description: Checking absence of DontDelete attribute
---*/

if (delete Date.prototype.getUTCDate === false) {
  $ERROR('#1: The Date.prototype.getUTCDate property has not the attributes DontDelete');
}

if (Date.prototype.hasOwnProperty('getUTCDate')) {
  $ERROR('#2: The Date.prototype.getUTCDate property has not the attributes DontDelete');
}

reportCompare(0, 0);
