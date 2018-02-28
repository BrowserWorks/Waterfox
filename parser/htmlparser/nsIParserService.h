/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef nsIParserService_h__
#define nsIParserService_h__

#include "nsISupports.h"
#include "nsString.h"
#include "nsHTMLTags.h"

class nsIParser;

#define NS_PARSERSERVICE_CONTRACTID "@mozilla.org/parser/parser-service;1"

// {90a92e37-abd6-441b-9b39-4064d98e1ede}
#define NS_IPARSERSERVICE_IID \
{ 0x90a92e37, 0xabd6, 0x441b, { 0x9b, 0x39, 0x40, 0x64, 0xd9, 0x8e, 0x1e, 0xde } }

class nsIParserService : public nsISupports {
 public:
  NS_DECLARE_STATIC_IID_ACCESSOR(NS_IPARSERSERVICE_IID)

  /**
   * Looks up the nsHTMLTag enum value corresponding to the tag in aAtom. The
   * lookup happens case insensitively.
   *
   * @param aAtom The tag to look up.
   *
   * @return int32_t The nsHTMLTag enum value corresponding to the tag in aAtom
   *                 or eHTMLTag_userdefined if the tag does not correspond to
   *                 any of the tag nsHTMLTag enum values.
   */
  virtual int32_t HTMLAtomTagToId(nsIAtom* aAtom) const = 0;

  /**
   * Looks up the nsHTMLTag enum value corresponding to the tag in aAtom.
   *
   * @param aAtom The tag to look up.
   *
   * @return int32_t The nsHTMLTag enum value corresponding to the tag in aAtom
   *                 or eHTMLTag_userdefined if the tag does not correspond to
   *                 any of the tag nsHTMLTag enum values.
   */
  virtual int32_t HTMLCaseSensitiveAtomTagToId(nsIAtom* aAtom) const = 0;

  /**
   * Looks up the nsHTMLTag enum value corresponding to the tag in aTag. The
   * lookup happens case insensitively.
   *
   * @param aTag The tag to look up.
   *
   * @return int32_t The nsHTMLTag enum value corresponding to the tag in aTag
   *                 or eHTMLTag_userdefined if the tag does not correspond to
   *                 any of the tag nsHTMLTag enum values.
   */
  virtual int32_t HTMLStringTagToId(const nsAString& aTag) const = 0;

  /**
   * Gets the tag corresponding to the nsHTMLTag enum value in aId. The
   * returned tag will be in lowercase.
   *
   * @param aId The nsHTMLTag enum value to get the tag for.
   *
   * @return const char16_t* The tag corresponding to the nsHTMLTag enum
   *                          value, or nullptr if the enum value doesn't
   *                          correspond to a tag (eHTMLTag_unknown,
   *                          eHTMLTag_userdefined, eHTMLTag_text, ...).
   */
  virtual const char16_t *HTMLIdToStringTag(int32_t aId) const = 0;

  /**
   * Gets the tag corresponding to the nsHTMLTag enum value in aId. The
   * returned tag will be in lowercase.
   *
   * @param aId The nsHTMLTag enum value to get the tag for.
   *
   * @return nsIAtom* The tag corresponding to the nsHTMLTag enum value, or
   *                  nullptr if the enum value doesn't correspond to a tag
   *                  (eHTMLTag_unknown, eHTMLTag_userdefined, eHTMLTag_text,
   *                  ...).
   */
  virtual nsIAtom *HTMLIdToAtomTag(int32_t aId) const = 0;

  NS_IMETHOD HTMLConvertUnicodeToEntity(int32_t aUnicode,
                                        nsCString& aEntity) const = 0;

  NS_IMETHOD IsContainer(int32_t aId, bool& aIsContainer) const = 0;
  NS_IMETHOD IsBlock(int32_t aId, bool& aIsBlock) const = 0;
};

NS_DEFINE_STATIC_IID_ACCESSOR(nsIParserService, NS_IPARSERSERVICE_IID)

#endif // nsIParserService_h__
