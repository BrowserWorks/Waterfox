/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: set ts=8 sts=2 et sw=2 tw=80:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef util_Text_h
#define util_Text_h

#include <stddef.h>

namespace js {

namespace unicode {
/**
 * Count the number of code points in [begin, end].
 *
 * Every sequence of 16-bit units is considered valid.  Lone surrogates are
 * treated as if they represented a code point of the same value.
 */
extern size_t
CountCodePoints(const char16_t* begin, const char16_t* end);
} // namespace unicode

} // namespace js

#endif // util_Text_h
