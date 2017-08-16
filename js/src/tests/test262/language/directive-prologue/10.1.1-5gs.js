// |reftest| error:SyntaxError
// Copyright (c) 2012 Ecma International.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
es5id: 10.1.1-5gs
description: >
    Strict Mode - Use Strict Directive Prologue is ''use strict';'
    which appears at the start of the code
negative:
  phase: early
  type: SyntaxError
flags: [raw]
---*/

"use strict";
throw new Error("This code should not execute");
var public = 1;
