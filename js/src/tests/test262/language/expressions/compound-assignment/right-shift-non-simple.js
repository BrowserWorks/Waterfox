// |reftest| error:ReferenceError
// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
info: >
    It is an early Reference Error if IsValidSimpleAssignmentTarget of
    LeftHandSideExpression is false.
es6id: 12.14.1
description: Compound "right shift" assignment with non-simple target
negative:
  phase: early
  type: ReferenceError
---*/

1 >>= 1;
