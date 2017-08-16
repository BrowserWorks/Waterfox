// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
info: >
    The [[Prototype]] property of the newly constructed object
    is set to the original Array prototype object, the one that
    is the initial value of Array.prototype
es5id: 15.4.1_A1.1_T1
description: >
    Create new property of Array.prototype. When new Array object has
    this property
---*/

//CHECK#1
Array.prototype.myproperty = 42;
var x = Array();
assert.sameValue(x.myproperty, 42);

assert.sameValue(Object.prototype.hasOwnProperty.call(x, 'myproperty'), false);

reportCompare(0, 0);
