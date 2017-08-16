// Copyright 2017 Mathias Bynens. All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
author: Mathias Bynens
description: >
  Unicode property escapes must be supported in character classes.
esid: sec-static-semantics-unicodematchproperty-p
features: [regexp-unicode-property-escapes]
---*/

/[\p{Hex}]/u;
assert.throws(
  SyntaxError,
  () => /[\p{Hex}-\uFFFF]/u,
  // See step 1 of https://tc39.github.io/ecma262/#sec-runtime-semantics-characterrange-abstract-operation.
  'property escape at start of character class range should throw if it expands to multiple characters'
);
assert.throws.early(SyntaxError, "/[\\p{}]/u");
assert.throws.early(SyntaxError, "/[\\p{invalid}]/u");
assert.throws.early(SyntaxError, "/[\\p{]/u");
assert.throws.early(SyntaxError, "/[\\p{]}/u");
assert.throws.early(SyntaxError, "/[\\p}]/u");
assert(
  /[\p{Hex}\P{Hex}]/u.test('\u{1D306}'),
  'multiple property escapes in a single character class should be supported'
);

reportCompare(0, 0);
