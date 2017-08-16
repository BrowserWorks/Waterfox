/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_ServoKeyframeRule_h
#define mozilla_ServoKeyframeRule_h

#include "mozilla/dom/CSSKeyframeRule.h"
#include "mozilla/ServoBindingTypes.h"

namespace mozilla {

class ServoDeclarationBlock;
class ServoKeyframeDeclaration;

class ServoKeyframeRule final : public dom::CSSKeyframeRule
{
public:
  explicit ServoKeyframeRule(already_AddRefed<RawServoKeyframe> aRaw)
    : CSSKeyframeRule(0, 0)
    , mRaw(aRaw) {}

  NS_DECL_ISUPPORTS_INHERITED
  NS_DECL_CYCLE_COLLECTION_CLASS_INHERITED(ServoKeyframeRule,
                                           dom::CSSKeyframeRule)

  bool IsCCLeaf() const final;
#ifdef DEBUG
  void List(FILE* out = stdout, int32_t aIndent = 0) const final;
#endif
  already_AddRefed<mozilla::css::Rule> Clone() const final;

  RawServoKeyframe* Raw() const { return mRaw; }

  // nsIDOMCSSKeyframeRule interface
  NS_IMETHOD GetKeyText(nsAString& aKeyText) final;
  NS_IMETHOD SetKeyText(const nsAString& aKeyText) final;

  // WebIDL interface
  void GetCssTextImpl(nsAString& aCssText) const final;
  nsICSSDeclaration* Style() final;

  size_t SizeOfIncludingThis(MallocSizeOf aMallocSizeOf) const final;

private:
  virtual ~ServoKeyframeRule();

  friend class ServoKeyframeDeclaration;

  template<typename Func>
  void UpdateRule(Func aCallback);

  RefPtr<RawServoKeyframe> mRaw;
  // lazily created when needed
  RefPtr<ServoKeyframeDeclaration> mDeclaration;
};

} // namespace mozilla

#endif // mozilla_ServoKeyframeRule_h
