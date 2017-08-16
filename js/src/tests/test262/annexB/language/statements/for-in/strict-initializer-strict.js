// |reftest| error:SyntaxError
'use strict';
// Copyright (C) 2016 the V8 project authors. All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.
/*---
esid: sec-initializers-in-forin-statement-heads
description: >
    for-in initializers in strict mode are prohibited
negative:
  phase: early
  type: SyntaxError
flags: [onlyStrict]
---*/
throw NotEarlyError;
for (var a = 0 in {});

