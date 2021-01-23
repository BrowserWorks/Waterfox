// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
info: |
    The shift function is intentionally generic.
    It does not require that its this value be an Array object
esid: sec-array.prototype.shift
description: >
    The first element of the array is removed from the array and
    returned
---*/

var obj = {};
obj["0"] = 0;
obj["3"] = 3;
obj.shift = Array.prototype.shift;

//CHECK#1
obj.length = 4;
var shift = obj.shift();
if (shift !== 0) {
  $ERROR('#1: var obj = {}; obj["0"] = 0; obj["3"] = 3; obj.length = 4; obj.shift = Array.prototype.shift; obj.shift() === 0. Actual: ' + (shift));
}

//CHECK#2
if (obj.length !== 3) {
  $ERROR('#2: var obj = {}; obj["0"] = 0; obj["3"] = 3; obj.length = 4; obj.shift = Array.prototype.shift; obj.shift(); obj.length === 3. Actual: ' + (obj.length));
}

//CHECK#3
var shift = obj.shift();
if (shift !== undefined) {
  $ERROR('#3: var obj = {}; obj["0"] = 0; obj["3"] = 3; obj.length = 4; obj.shift = Array.prototype.shift; obj.shift(); obj.shift() === undefined. Actual: ' + (shift));
}

//CHECK#4
if (obj.length !== 2) {
  $ERROR('#4: var obj = {}; obj["0"] = 0; obj["3"] = 3; obj.length = 4; obj.shift = Array.prototype.shift; obj.shift(); obj.shift(); obj.length === 2. Actual: ' + (obj.length));
}

//CHECK#5
obj.length = 1;
var shift = obj.shift();
if (shift !== undefined) {
  $ERROR('#5: var obj = {}; obj["0"] = 0; obj["3"] = 3; obj.length = 4; obj.shift = Array.prototype.shift; obj.shift(); obj.shift(); obj.length = 1; obj.shift() === undefined. Actual: ' + (shift));
}

//CHECK#6
if (obj.length !== 0) {
  $ERROR('#6: var obj = {}; obj["0"] = 0; obj["3"] = 3; obj.length = 4; obj.shift = Array.prototype.shift; obj.shift(); obj.shift(); obj.length = 1; obj.shift(); obj.length === 0. Actual: ' + (obj.length));
}

reportCompare(0, 0);
