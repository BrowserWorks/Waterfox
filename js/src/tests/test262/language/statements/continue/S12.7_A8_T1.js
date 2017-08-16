// |reftest| error:SyntaxError
// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
info: Appearing of "continue" within a "try/catch" Block yields SyntaxError
es5id: 12.7_A8_T1
description: >
    Checking if execution of "continue Identifier" within catch Block
    fails
negative:
  phase: early
  type: SyntaxError
---*/

var x=0,y=0;

try{
	LABEL1 : do {
		x++;
		throw "gonna leave it";
		y++;
	} while(0);
	$ERROR('#1: throw "gonna leave it" lead to throwing exception');
} catch(e){
	continue LABEL2;
	LABEL2 : do {
		x++;
		y++;
	} while(0);
};
