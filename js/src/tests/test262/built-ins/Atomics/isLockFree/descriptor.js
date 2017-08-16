// Copyright 2015 Microsoft Corporation. All rights reserved.
// Copyright (C) 2017 Mozilla Corporation. All rights reserved.
// This code is governed by the license found in the LICENSE file.

/*---
description: Testing descriptor property of Atomics.add
includes: [propertyHelper.js]
---*/

verifyWritable(Atomics, "add");
verifyNotEnumerable(Atomics, "add");
verifyConfigurable(Atomics, "add");

reportCompare(0, 0);
