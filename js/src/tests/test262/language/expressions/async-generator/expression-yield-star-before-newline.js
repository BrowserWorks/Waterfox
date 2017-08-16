// |reftest| skip-if(release_or_beta) -- async-iteration is not released yet
// Copyright 2017 the V8 project authors. All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
author: Caitlin Potter <caitp@igalia.com>
esid: 14.4
description: >
  The right-hand side of a `yield *` expression may appear on a new line.
flags: [async]
features: [async-iteration]
---*/

var g = async function*() {};

(async function*() {
  yield*
  g();
})().next().then(function(result) {
  assert.sameValue(result.value, undefined);
  assert.sameValue(result.done, true);
}).then($DONE, $DONE);
