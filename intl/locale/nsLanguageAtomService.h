/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/*
 * The nsILanguageAtomService provides a mapping from languages or charsets
 * to language groups, and access to the system locale language.
 */

#ifndef nsLanguageAtomService_h_
#define nsLanguageAtomService_h_

#include "nsCOMPtr.h"
#include "nsIAtom.h"
#include "nsInterfaceHashtable.h"

class nsLanguageAtomService
{
public:
  static nsLanguageAtomService* GetService();

  nsIAtom* LookupLanguage(const nsACString &aLanguage);
  already_AddRefed<nsIAtom> LookupCharSet(const nsACString& aCharSet);
  nsIAtom* GetLocaleLanguage();

  // Returns the language group that the specified language is a part of.
  //
  // aNeedsToCache is used for two things.  If null, it indicates that
  // the nsLanguageAtomService is safe to cache the result of the
  // language group lookup, either because we're on the main thread,
  // or because we're on a style worker thread but the font lock has
  // been acquired.  If non-null, it indicates that it's not safe to
  // cache the result of the language group lookup (because we're on
  // a style worker thread without the lock acquired).  In this case,
  // GetLanguageGroup will store true in *aNeedsToCache true if we
  // would have cached the result of a new lookup, and false if we
  // were able to use an existing cached result.  Thus, callers that
  // get a true *aNeedsToCache outparam value should make an effort
  // to re-call GetLanguageGroup when it is safe to cache, to avoid
  // recomputing the language group again later.
  nsIAtom* GetLanguageGroup(nsIAtom* aLanguage, bool* aNeedsToCache = nullptr);
  already_AddRefed<nsIAtom> GetUncachedLanguageGroup(nsIAtom* aLanguage) const;

private:
  nsInterfaceHashtable<nsISupportsHashKey, nsIAtom> mLangToGroup;
  nsCOMPtr<nsIAtom> mLocaleLanguage;
};

#endif
