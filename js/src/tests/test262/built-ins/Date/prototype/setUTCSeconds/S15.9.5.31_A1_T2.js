// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
info: The Date.prototype property "setUTCSeconds" has { DontEnum } attributes
esid: sec-date.prototype.setutcseconds
description: Checking absence of DontDelete attribute
---*/

if (delete Date.prototype.setUTCSeconds === false) {
  $ERROR('#1: The Date.prototype.setUTCSeconds property has not the attributes DontDelete');
}

if (Date.prototype.hasOwnProperty('setUTCSeconds')) {
  $ERROR('#2: The Date.prototype.setUTCSeconds property has not the attributes DontDelete');
}

reportCompare(0, 0);
