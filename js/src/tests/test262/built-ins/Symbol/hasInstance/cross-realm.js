// Copyright (C) 2016 the V8 project authors. All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.
/*---
esid: sec-symbol.hasinstance
es6id: 19.4.2.2
description: Value shared by all realms
info: >
  Unless otherwise specified, well-known symbols values are shared by all
  realms.
features: [Symbol.hasInstance]
---*/

var OSymbol = $262.createRealm().global.Symbol;

assert.sameValue(Symbol.hasInstance, OSymbol.hasInstance);

reportCompare(0, 0);
