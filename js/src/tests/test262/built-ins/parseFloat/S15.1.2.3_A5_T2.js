// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
info: Return the number value for the MV of Result(4)
esid: sec-parsefloat-string
description: Checking DecimalDigits . DecimalDigits_opt ExponentPart_opt
---*/

//CHECK#1
if (parseFloat("-11.") !== -11) {
  $ERROR('#1: parseFloat("-11.") === -11. Actual: ' + (parseFloat("-11.")));
}

//CHECK#2
if (parseFloat("01.") !== 1) {
  $ERROR('#2: parseFloat("01.") === 1. Actual: ' + (parseFloat("01.")));
}

//CHECK#3
if (parseFloat("+11.1") !== 11.1) {
  $ERROR('#3: parseFloat("+11.1") === 11.1. Actual: ' + (parseFloat("+11.1")));
}

//CHECK#4
if (parseFloat("01.1") !== 1.1) {
  $ERROR('#4: parseFloat("01.1") === 1.1. Actual: ' + (parseFloat("01.1")));
}

//CHECK#5
if (parseFloat("-11.e-1") !== -1.1) {
  $ERROR('#5: parseFloat("-11.e-1") === -1.1. Actual: ' + (parseFloat("-11.e-1")));
}

//CHECK#6
if (parseFloat("01.e1") !== 10) {
  $ERROR('#6: parseFloat("01.e1") === 10. Actual: ' + (parseFloat("01.e1")));
}

//CHECK#7
if (parseFloat("+11.22e-1") !== 1.122) {
  $ERROR('#7: parseFloat("+11.22e-1") === 1.122. Actual: ' + (parseFloat("+11.22e-1")));
}

//CHECK#8
if (parseFloat("01.01e1") !== 10.1) {
  $ERROR('#8: parseFloat("01.01e1") === 10.1. Actual: ' + (parseFloat("01.01e1")));
}

//CHECK#9
if (parseFloat("001.") !== 1) {
  $ERROR('#9: parseFloat("001.") === 1. Actual: ' + (parseFloat("001.")));
}

//CHECK#10
if (parseFloat("010.") !== 10) {
  $ERROR('#10: parseFloat("010.") === 10. Actual: ' + (parseFloat("010.")));
}

reportCompare(0, 0);
