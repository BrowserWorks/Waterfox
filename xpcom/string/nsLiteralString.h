/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef nsLiteralString_h___
#define nsLiteralString_h___

#include "nscore.h"
#include "nsString.h"

#include "nsTLiteralString.h"

#include "mozilla/Char16.h"

#define NS_LITERAL_STRING(s) \
  static_cast<const nsLiteralString&>(nsLiteralString(u"" s))
#define NS_NAMED_LITERAL_STRING(n, s) const nsLiteralString n(u"" s)

#define NS_LITERAL_CSTRING(s) \
  static_cast<const nsLiteralCString&>(nsLiteralCString("" s))
#define NS_NAMED_LITERAL_CSTRING(n, s) const nsLiteralCString n("" s)

constexpr auto operator""_ns(const char* aStr, std::size_t aLen) {
  return nsLiteralCString{aStr, aLen};
}

constexpr auto operator""_ns(const char16_t* aStr, std::size_t aLen) {
  return nsLiteralString{aStr, aLen};
}

#endif /* !defined(nsLiteralString_h___) */
