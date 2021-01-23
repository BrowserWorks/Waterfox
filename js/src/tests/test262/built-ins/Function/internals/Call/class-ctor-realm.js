// Copyright (C) 2016 the V8 project authors. All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.
/*---
esid: sec-ecmascript-function-objects-call-thisargument-argumentslist
description: >
  Error when invoking a class constructor (honoring the Realm of the current
  execution context)
info: |
  [...]
  2. If F's [[FunctionKind]] internal slot is "classConstructor", throw a
     TypeError exception.
features: [cross-realm, class]
---*/

var C = $262.createRealm().global.eval('0, class {}');

assert.throws(TypeError, function() {
  C();
});

reportCompare(0, 0);
