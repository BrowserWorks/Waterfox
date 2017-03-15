/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_AnimValuesStyleRule_h
#define mozilla_AnimValuesStyleRule_h

#include "mozilla/StyleAnimationValue.h"
#include "nsCSSPropertyID.h"
#include "nsCSSPropertyIDSet.h"
#include "nsDataHashtable.h"
#include "nsHashKeys.h" // For nsUint32HashKey
#include "nsIStyleRule.h"
#include "nsISupportsImpl.h" // For NS_DECL_ISUPPORTS
#include "nsRuleNode.h" // For nsCachedStyleData
#include "nsTArray.h" // For nsTArray

namespace mozilla {

/**
 * A style rule that maps property-StyleAnimationValue pairs.
 */
class AnimValuesStyleRule final : public nsIStyleRule
{
public:
  AnimValuesStyleRule()
    : mStyleBits(0) {}

  // nsISupports implementation
  NS_DECL_ISUPPORTS

  // nsIStyleRule implementation
  void MapRuleInfoInto(nsRuleData* aRuleData) override;
  bool MightMapInheritedStyleData() override;
  bool GetDiscretelyAnimatedCSSValue(nsCSSPropertyID aProperty,
                                     nsCSSValue* aValue) override;
#ifdef DEBUG
  void List(FILE* out = stdout, int32_t aIndent = 0) const override;
#endif

  // For the following functions, it there is already a value for |aProperty| it
  // will be replaced with |aValue|.
  void AddValue(nsCSSPropertyID aProperty, const StyleAnimationValue &aValue);
  void AddValue(nsCSSPropertyID aProperty, StyleAnimationValue&& aValue);

private:
  ~AnimValuesStyleRule() {}

  nsDataHashtable<nsUint32HashKey, StyleAnimationValue> mAnimationValues;

  uint32_t mStyleBits;
};

} // namespace mozilla

#endif // mozilla_AnimValuesStyleRule_h
