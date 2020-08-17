/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: set ts=8 sts=2 et sw=2 tw=80:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef js_experimental_CodeCoverage_h
#define js_experimental_CodeCoverage_h

#include "jstypes.h"     // JS_FRIEND_API

struct JS_PUBLIC_API JSContext;

namespace js {

/**
 * Enable the collection of lcov code coverage metrics.
 * Must be called before a runtime is created and before any calls to
 * GetCodeCoverageSummary.
 */
extern JS_FRIEND_API void EnableCodeCoverage();

}  // namespace js

#endif  // js_experimental_CodeCoverage_h
