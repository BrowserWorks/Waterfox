// |reftest| error:SyntaxError
// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
info: >
    RegularExpressionFirstChar :: BackslashSequence :: \LineTerminator is
    incorrect
es5id: 7.8.5_A1.5_T3
description: Carriage Return, without eval
negative:
  phase: early
  type: SyntaxError
---*/

//CHECK#1
/\
/
