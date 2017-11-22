/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozEnglishWordUtils_h__
#define mozEnglishWordUtils_h__

#include "nsCOMPtr.h"
#include "mozISpellI18NUtil.h"
#include "nsString.h"

#include "mozITXTToHTMLConv.h"
#include "nsCycleCollectionParticipant.h"

class mozEnglishWordUtils : public mozISpellI18NUtil
{
public:
  NS_DECL_CYCLE_COLLECTING_ISUPPORTS
  NS_DECL_MOZISPELLI18NUTIL
  NS_DECL_CYCLE_COLLECTION_CLASS(mozEnglishWordUtils)

  mozEnglishWordUtils();
  /* additional members */
  enum myspCapitalization
  {
    NoCap,
    InitCap,
    AllCap,
    HuhCap
  };

protected:
  virtual ~mozEnglishWordUtils();

  mozEnglishWordUtils::myspCapitalization captype(const nsString &word);
  bool ucIsAlpha(char16_t aChar);

  nsString mLanguage;
  nsString mCharset;
  nsCOMPtr<mozITXTToHTMLConv> mURLDetector; // used to detect urls so the spell checker can skip them.
};

#endif
