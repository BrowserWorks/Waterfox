// |reftest| skip-if(release_or_beta) -- async-iteration is not released yet
// Copyright 2017 the V8 project authors. All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
author: Caitlin Potter <caitp@igalia.com>
esid: pending
description: >
  Thrown generator suspended in a yield position resumes execution within
  the associated finally block and throws an error and suspendeds execution
  again
info: |
  AsyncGeneratorResumeNext:
  If completion.[[Type]] is throw, and generator.[[AsyncGeneratorState]] is
  "suspendedYield", and generator is resumed within a try-block with an
  associated finally block, resume execution within finally.
flags: [async]
features: [async-iteration]
---*/

var error = new Error('boop');
var g = async function*() {
  try {
    yield 1;
    throw new Test262Error('Generator must be resumed in finally block.');
  } finally {
    throw error;
    throw new Test262Error('Generator must not be resumed.');
  }
};

var it = g();
it.next().then(function(ret) {
  assert.sameValue(ret.value, 1, 'Initial yield');
  assert.sameValue(ret.done, false, 'Initial yield');

  it.throw(new Error('superceded')).then($DONE, function(err) {
    assert.sameValue(err, error, 'AsyncGeneratorReject(generator, resultValue)');

    it.next().then(function(ret) {
      assert.sameValue(ret.value, undefined, 'Generator is closed');
      assert.sameValue(ret.done, true, 'Generator is closed');
    }).then($DONE, $DONE);

  }).catch($DONE);

}).catch($DONE);
