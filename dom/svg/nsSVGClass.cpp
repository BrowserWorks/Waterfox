/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsSVGClass.h"

#include "mozilla/dom/SVGAnimatedString.h"
#include "mozilla/Move.h"
#include "nsSVGElement.h"
#include "nsSMILValue.h"
#include "SMILStringType.h"

using namespace mozilla;
using namespace mozilla::dom;

struct DOMAnimatedString final : public SVGAnimatedString
{
  NS_DECL_CYCLE_COLLECTING_ISUPPORTS
  NS_DECL_CYCLE_COLLECTION_SCRIPT_HOLDER_CLASS(DOMAnimatedString)

  DOMAnimatedString(nsSVGClass* aVal, nsSVGElement* aSVGElement)
    : SVGAnimatedString(aSVGElement)
    , mVal(aVal)
  {}

  nsSVGClass* mVal; // kept alive because it belongs to content

  void GetBaseVal(nsAString& aResult) override
  {
    mVal->GetBaseValue(aResult, mSVGElement);
  }

  void SetBaseVal(const nsAString& aValue) override
  {
    mVal->SetBaseValue(aValue, mSVGElement, true);
  }

  void GetAnimVal(nsAString& aResult) override;

private:
  ~DOMAnimatedString() {}
};

NS_SVG_VAL_IMPL_CYCLE_COLLECTION_WRAPPERCACHED(DOMAnimatedString, mSVGElement)

NS_IMPL_CYCLE_COLLECTING_ADDREF(DOMAnimatedString)
NS_IMPL_CYCLE_COLLECTING_RELEASE(DOMAnimatedString)


NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(DOMAnimatedString)
  NS_WRAPPERCACHE_INTERFACE_MAP_ENTRY
  NS_INTERFACE_MAP_ENTRY(nsISupports)
NS_INTERFACE_MAP_END

already_AddRefed<SVGAnimatedString>
nsSVGClass::ToDOMAnimatedString(nsSVGElement* aSVGElement)
{
  RefPtr<DOMAnimatedString> result = new DOMAnimatedString(this, aSVGElement);
  return result.forget();
}

/* Implementation */

void
nsSVGClass::SetBaseValue(const nsAString& aValue,
                         nsSVGElement *aSVGElement,
                         bool aDoSetAttr)
{
  NS_ASSERTION(aSVGElement, "Null element passed to SetBaseValue");

  aSVGElement->SetMayHaveClass();
  if (aDoSetAttr) {
    aSVGElement->SetAttr(kNameSpaceID_None, nsGkAtoms::_class, aValue, true);
  }
  if (mAnimVal) {
    aSVGElement->AnimationNeedsResample();
  }
}

void
nsSVGClass::GetBaseValue(nsAString& aValue, const nsSVGElement *aSVGElement) const
{
  aSVGElement->GetAttr(kNameSpaceID_None, nsGkAtoms::_class, aValue);
}

void
nsSVGClass::GetAnimValue(nsAString& aResult, const nsSVGElement *aSVGElement) const
{
  if (mAnimVal) {
    aResult = *mAnimVal;
    return;
  }

  aSVGElement->GetAttr(kNameSpaceID_None, nsGkAtoms::_class, aResult);
}

void
nsSVGClass::SetAnimValue(const nsAString& aValue, nsSVGElement *aSVGElement)
{
  if (mAnimVal && mAnimVal->Equals(aValue)) {
    return;
  }
  if (!mAnimVal) {
    mAnimVal = new nsString();
  }
  *mAnimVal = aValue;
  aSVGElement->SetMayHaveClass();
  aSVGElement->DidAnimateClass();
}

void
DOMAnimatedString::GetAnimVal(nsAString& aResult)
{
  mSVGElement->FlushAnimations();
  mVal->GetAnimValue(aResult, mSVGElement);
}

UniquePtr<nsISMILAttr>
nsSVGClass::ToSMILAttr(nsSVGElement *aSVGElement)
{
  return MakeUnique<SMILString>(this, aSVGElement);
}

nsresult
nsSVGClass::SMILString::ValueFromString(const nsAString& aStr,
                                        const dom::SVGAnimationElement* /*aSrcElement*/,
                                        nsSMILValue& aValue,
                                        bool& aPreventCachingOfSandwich) const
{
  nsSMILValue val(SMILStringType::Singleton());

  *static_cast<nsAString*>(val.mU.mPtr) = aStr;
  aValue = Move(val);
  aPreventCachingOfSandwich = false;
  return NS_OK;
}

nsSMILValue
nsSVGClass::SMILString::GetBaseValue() const
{
  nsSMILValue val(SMILStringType::Singleton());
  mSVGElement->GetAttr(kNameSpaceID_None, nsGkAtoms::_class,
                       *static_cast<nsAString*>(val.mU.mPtr));
  return val;
}

void
nsSVGClass::SMILString::ClearAnimValue()
{
  if (mVal->mAnimVal) {
    mVal->mAnimVal = nullptr;
    mSVGElement->DidAnimateClass();
  }
}

nsresult
nsSVGClass::SMILString::SetAnimValue(const nsSMILValue& aValue)
{
  NS_ASSERTION(aValue.mType == SMILStringType::Singleton(),
               "Unexpected type to assign animated value");
  if (aValue.mType == SMILStringType::Singleton()) {
    mVal->SetAnimValue(*static_cast<nsAString*>(aValue.mU.mPtr), mSVGElement);
  }
  return NS_OK;
}
