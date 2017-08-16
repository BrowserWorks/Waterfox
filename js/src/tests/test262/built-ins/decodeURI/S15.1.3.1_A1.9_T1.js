// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
info: >
    If B = 11110xxx (n = 4) and string.charAt(k + 3),
    string.charAt(k + 6), string.charAt(k + 9) not equal "%", throw URIError
es5id: 15.1.3.1_A1.9_T1
description: >
    Complex tests. B = [0xF0 - 0x0F7],  string.charAt(k + 3) not equal "%"
includes: [decimalToHexString.js]
---*/

var errorCount = 0;
var count = 0;
var indexP;
var indexO = 0;

for (var index = 0xF0; index <= 0xF7; index++) {
  count++; 
  var hex = decimalToPercentHexString(index);
  try {
    decodeURI(hex + "111%A0%A0");
  } catch (e) { 
    if ((e instanceof URIError) === true) continue;                
  }
  if (indexO === 0) { 
    indexO = index;
  } else {
    if ((index - indexP) !== 1) {             
      if ((indexP - indexO) !== 0) {
        var hexP = decimalToHexString(indexP);
        var hexO = decimalToHexString(indexO);
        $ERROR('#' + hexO + '-' + hexP + ' ');
      } 
      else {
        var hexP = decimalToHexString(indexP);
        $ERROR('#' + hexP + ' ');
      }  
      indexO = index;
    }         
  }
  indexP = index;
  errorCount++;       
}

if (errorCount > 0) {
  if ((indexP - indexO) !== 0) {
    var hexP = decimalToHexString(indexP);
    var hexO = decimalToHexString(indexO);
    $ERROR('#' + hexO + '-' + hexP + ' ');
  } else {
    var hexP = decimalToHexString(indexP);
    $ERROR('#' + hexP + ' ');
  }     
  $ERROR('Total error: ' + errorCount + ' bad Unicode character in ' + count + ' ');
}

reportCompare(0, 0);
