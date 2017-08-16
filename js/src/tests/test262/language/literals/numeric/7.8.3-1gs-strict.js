// |reftest| error:SyntaxError
'use strict';
// Copyright (c) 2012 Ecma International.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
es5id: 7.8.3-1gs
description: Strict Mode - octal extension(010) is forbidden in strict mode
negative:
  phase: early
  type: SyntaxError
flags: [onlyStrict]
---*/

var y = 010;
