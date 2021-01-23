// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
info: Operator use ToInteger from deleteCount
esid: sec-array.prototype.splice
description: ToInteger use ToNumber
---*/

var x = [0, 1, 2, 3];
var arr = x.splice(0, {
  valueOf: function() {
    return 3
  },
  toString: function() {
    return 0
  }
});

//CHECK#1
arr.getClass = Object.prototype.toString;
if (arr.getClass() !== "[object " + "Array" + "]") {
  $ERROR('#1: var x = [0,1,2,3]; var arr = x.splice(0,{valueOf: function() {return 3}, toString: function() {return 0}}); arr is Array object. Actual: ' + (arr.getClass()));
}

//CHECK#2
if (arr.length !== 3) {
  $ERROR('#2: var x = [0,1,2,3]; var arr = x.splice(0,{valueOf: function() {return 3}, toString: function() {return 0}}); arr.length === 3. Actual: ' + (arr.length));
}

//CHECK#3
if (arr[0] !== 0) {
  $ERROR('#3: var x = [0,1,2,3]; var arr = x.splice(0,{valueOf: function() {return 3}, toString: function() {return 0}}); arr[0] === 0. Actual: ' + (arr[0]));
}

//CHECK#4
if (arr[1] !== 1) {
  $ERROR('#4: var x = [0,1,2,3]; var arr = x.splice(0,{valueOf: function() {return 3}, toString: function() {return 0}}); arr[1] === 1. Actual: ' + (arr[1]));
}

//CHECK#5
if (arr[2] !== 2) {
  $ERROR('#5: var x = [0,1,2,3]; var arr = x.splice(0,{valueOf: function() {return 3}, toString: function() {return 0}}); arr[2] === 2. Actual: ' + (arr[2]));
}

//CHECK#6
if (x.length !== 1) {
  $ERROR('#6: var x = [0,1,2,3]; var arr = x.splice(0,{valueOf: function() {return 3}, toString: function() {return 0}}); x.length === 1. Actual: ' + (x.length));
}

//CHECK#7
if (x[0] !== 3) {
  $ERROR('#7: var x = [0,1,2,3]; var arr = x.splice(0,{valueOf: function() {return 3}, toString: function() {return 0}}); x[0] === 3. Actual: ' + (x[0]));
}

reportCompare(0, 0);
