// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
info: |
    The Date.prototype.toTimeString property "length" has { ReadOnly, !
    DontDelete, DontEnum } attributes
esid: sec-date.prototype.totimestring
description: Checking DontDelete attribute
---*/

if (delete Date.prototype.toTimeString.length !== true) {
  $ERROR('#1: The Date.prototype.toTimeString.length property does not have the attributes DontDelete');
}

if (Date.prototype.toTimeString.hasOwnProperty('length')) {
  $ERROR('#2: The Date.prototype.toTimeString.length property does not have the attributes DontDelete');
}

reportCompare(0, 0);
