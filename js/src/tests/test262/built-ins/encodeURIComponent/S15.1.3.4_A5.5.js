// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
info: The encodeURIComponent property has the attribute DontEnum
esid: sec-encodeuricomponent-uricomponent
description: Checking use propertyIsEnumerable, for-in
---*/

//CHECK#1
if (this.propertyIsEnumerable('encodeURIComponent') !== false) {
  $ERROR('#1: this.propertyIsEnumerable(\'encodeURIComponent\') === false. Actual: ' + (this.propertyIsEnumerable('encodeURIComponent')));
}

//CHECK#2
var result = true;
for (var p in this) {
  if (p === "encodeURIComponent") {
    result = false;
  }
}

if (result !== true) {
  $ERROR('#2: result = true; for (p in this) { if (p === "encodeURIComponent") result = false; }  result === true;');
}

reportCompare(0, 0);
