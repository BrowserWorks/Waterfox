// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
info: The Date property "parse" has { DontEnum } attributes
esid: sec-date.parse
description: Checking absence of DontDelete attribute
---*/

if (delete Date.parse === false) {
  $ERROR('#1: The Date.parse property has not the attributes DontDelete');
}

if (Date.hasOwnProperty('parse')) {
  $ERROR('#2: The Date.parse property has not the attributes DontDelete');
}

reportCompare(0, 0);
