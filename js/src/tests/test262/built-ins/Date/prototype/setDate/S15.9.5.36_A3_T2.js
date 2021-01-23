// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
info: |
    The Date.prototype.setDate property "length" has { ReadOnly, !
    DontDelete, DontEnum } attributes
esid: sec-date.prototype.setdate
description: Checking DontDelete attribute
---*/

if (delete Date.prototype.setDate.length !== true) {
  $ERROR('#1: The Date.prototype.setDate.length property does not have the attributes DontDelete');
}

if (Date.prototype.setDate.hasOwnProperty('length')) {
  $ERROR('#2: The Date.prototype.setDate.length property does not have the attributes DontDelete');
}

reportCompare(0, 0);
