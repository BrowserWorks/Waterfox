/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: set ts=8 sts=2 et sw=2 tw=80:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "util/Text.h"

#include "mozilla/Assertions.h"
#include "vm/Unicode.h"

using namespace JS;
using namespace js;

size_t
js::unicode::CountCodePoints(const char16_t* begin, const char16_t* end)
{
    MOZ_ASSERT(begin <= end);

    size_t count = 0;

    const char16_t* ptr = begin;
    while (ptr < end) {
        count++;

        if (!IsLeadSurrogate(*ptr++)) {
            continue;
        }

        if (ptr < end && IsTrailSurrogate(*ptr)) {
            ptr++;
        }
    }
    MOZ_ASSERT(ptr == end, "should have consumed the full range");

    return count;
}
