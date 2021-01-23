// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
info: |
    If this object does not have a property named by
    ToString(j), return 1. If this object does not have a property
    named by ToString(k), return -1
esid: sec-array.prototype.sort
description: If comparefn is undefined, use SortCompare operator
---*/

var x = new Array(2);
x[1] = 1;
x.sort();

//CHECK#1
if (x.length !== 2) {
  $ERROR('#1: var x = new Array(2); x[1] = 1;  x.sort(); x.length === 2. Actual: ' + (x.length));
}

//CHECK#2
if (x[0] !== 1) {
  $ERROR('#2: var x = new Array(2); x[1] = 1;  x.sort(); x[0] === 1. Actual: ' + (x[0]));
}

//CHECK#3
if (x[1] !== undefined) {
  $ERROR('#3: var x = new Array(2); x[1] = 1;  x.sort(); x[1] === undefined. Actual: ' + (x[1]));
}

var x = new Array(2);
x[0] = 1;
x.sort();

//CHECK#4
if (x.length !== 2) {
  $ERROR('#4: var x = new Array(2); x[0] = 1;  x.sort(); x.length === 2. Actual: ' + (x.length));
}

//CHECK#5
if (x[0] !== 1) {
  $ERROR('#5: var x = new Array(2); x[0] = 1;  x.sort(); x[0] === 1. Actual: ' + (x[0]));
}

//CHECK#6
if (x[1] !== undefined) {
  $ERROR('#6: var x = new Array(2); x[0] = 1;  x.sort(); x[1] === undefined. Actual: ' + (x[1]));
}

reportCompare(0, 0);
