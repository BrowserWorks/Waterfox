/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
// IWYU pragma: private, include "nsString.h"

#define CharT                               char
#define CharT_is_char                       1
#define nsTAString_IncompatibleCharT        nsAString
#define nsTString_CharT                     nsCString
#define nsTStringRepr_CharT                 nsCStringRepr
#define nsTFixedString_CharT                nsFixedCString
#define nsTAutoString_CharT                 nsAutoCString
#define nsTSubstring_CharT                  nsACString
#define PrintfAppend_CharT                  PrintfAppend_nsACString
#define nsTSubstringTuple_CharT             nsCSubstringTuple
#define nsTStringComparator_CharT           nsCStringComparator
#define nsTDefaultStringComparator_CharT    nsDefaultCStringComparator
#define nsTDependentString_CharT            nsDependentCString
#define nsTDependentSubstring_CharT         nsDependentCSubstring
#define nsTLiteralString_CharT              nsLiteralCString
#define nsTXPIDLString_CharT                nsXPIDLCString
#define nsTGetterCopies_CharT               nsCGetterCopies
#define nsTAdoptingString_CharT             nsAdoptingCString
#define nsTPromiseFlatString_CharT          nsPromiseFlatCString
#define TPromiseFlatString_CharT            PromiseFlatCString
#define nsTSubstringSplitter_CharT          nsCSubstringSplitter
