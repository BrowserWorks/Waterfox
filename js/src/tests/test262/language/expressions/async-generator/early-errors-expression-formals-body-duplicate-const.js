// |reftest| skip-if(release_or_beta) error:SyntaxError -- async-iteration is not released yet
// Copyright 2017 the V8 project authors. All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/*---
author: Caitlin Potter <caitp@igalia.com>
esid: pending
description: >
  It is a SyntaxError if BoundNames of FormalParameters also occurs in the
  LexicallyDeclaredNames of AsyncFunctionBody
negative:
  phase: early
  type: SyntaxError
features: [async-iteration]
---*/

(async function*(a) { const a = 0; });
