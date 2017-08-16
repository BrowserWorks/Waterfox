/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsError.h"
#include "nsSVGAttrTearoffTable.h"
#include "nsSVGBoolean.h"
#include "nsSMILValue.h"
#include "SMILBoolType.h"
#include "SVGAnimatedBoolean.h"

using namespace mozilla;
using namespace mozilla::dom;

/* Implementation */

static inline
nsSVGAttrTearoffTable<nsSVGBoolean, SVGAnimatedBoolean>&
SVGAnimatedBooleanTearoffTable()
{
  static nsSVGAttrTearoffTable<nsSVGBoolean, SVGAnimatedBoolean>
    sSVGAnimatedBooleanTearoffTable;
  return sSVGAnimatedBooleanTearoffTable;
}

static bool
GetValueFromString(const nsAString& aValueAsString,
                   bool& aValue)
{
  if (aValueAsString.EqualsLiteral("true")) {
    aValue = true;
    return true;
  }
  if (aValueAsString.EqualsLiteral("false")) {
    aValue = false;
    return true;
  }
  return false;
}

static nsresult
GetValueFromAtom(const nsIAtom* aValueAsAtom, bool *aValue)
{
  if (aValueAsAtom == nsGkAtoms::_true) {
    *aValue = true;
    return NS_OK;
  }
  if (aValueAsAtom == nsGkAtoms::_false) {
    *aValue = false;
    return NS_OK;
  }
  return NS_ERROR_DOM_SYNTAX_ERR;
}

nsresult
nsSVGBoolean::SetBaseValueAtom(const nsIAtom* aValue, nsSVGElement *aSVGElement)
{
  bool val = false;

  nsresult rv = GetValueFromAtom(aValue, &val);
  if (NS_FAILED(rv)) {
    return rv;
  }

  mBaseVal = val;
  if (!mIsAnimated) {
    mAnimVal = mBaseVal;
  }
  else {
    aSVGElement->AnimationNeedsResample();
  }

  // We don't need to call DidChange* here - we're only called by
  // nsSVGElement::ParseAttribute under Element::SetAttr,
  // which takes care of notifying.
  return NS_OK;
}

nsIAtom*
nsSVGBoolean::GetBaseValueAtom() const
{
  return mBaseVal ? nsGkAtoms::_true : nsGkAtoms::_false;
}

void
nsSVGBoolean::SetBaseValue(bool aValue, nsSVGElement *aSVGElement)
{
  if (aValue == mBaseVal) {
    return;
  }

  mBaseVal = aValue;
  if (!mIsAnimated) {
    mAnimVal = mBaseVal;
  } else {
    aSVGElement->AnimationNeedsResample();
  }
  aSVGElement->DidChangeBoolean(mAttrEnum);
}

void
nsSVGBoolean::SetAnimValue(bool aValue, nsSVGElement *aSVGElement)
{
  if (mIsAnimated && mAnimVal == aValue) {
    return;
  }
  mAnimVal = aValue;
  mIsAnimated = true;
  aSVGElement->DidAnimateBoolean(mAttrEnum);
}

already_AddRefed<SVGAnimatedBoolean>
nsSVGBoolean::ToDOMAnimatedBoolean(nsSVGElement* aSVGElement)
{
  RefPtr<SVGAnimatedBoolean> domAnimatedBoolean =
    SVGAnimatedBooleanTearoffTable().GetTearoff(this);
  if (!domAnimatedBoolean) {
    domAnimatedBoolean = new SVGAnimatedBoolean(this, aSVGElement);
    SVGAnimatedBooleanTearoffTable().AddTearoff(this, domAnimatedBoolean);
  }

  return domAnimatedBoolean.forget();
}

SVGAnimatedBoolean::~SVGAnimatedBoolean()
{
  SVGAnimatedBooleanTearoffTable().RemoveTearoff(mVal);
}

UniquePtr<nsISMILAttr>
nsSVGBoolean::ToSMILAttr(nsSVGElement *aSVGElement)
{
  return MakeUnique<SMILBool>(this, aSVGElement);
}

nsresult
nsSVGBoolean::SMILBool::ValueFromString(const nsAString& aStr,
                                        const SVGAnimationElement* /*aSrcElement*/,
                                        nsSMILValue& aValue,
                                        bool& aPreventCachingOfSandwich) const
{
  bool value;
  if (!GetValueFromString(aStr, value)) {
    return NS_ERROR_DOM_SYNTAX_ERR;
  }

  nsSMILValue val(SMILBoolType::Singleton());
  val.mU.mBool = value;
  aValue = val;
  aPreventCachingOfSandwich = false;

  return NS_OK;
}

nsSMILValue
nsSVGBoolean::SMILBool::GetBaseValue() const
{
  nsSMILValue val(SMILBoolType::Singleton());
  val.mU.mBool = mVal->mBaseVal;
  return val;
}

void
nsSVGBoolean::SMILBool::ClearAnimValue()
{
  if (mVal->mIsAnimated) {
    mVal->mIsAnimated = false;
    mVal->mAnimVal = mVal->mBaseVal;
    mSVGElement->DidAnimateBoolean(mVal->mAttrEnum);
  }
}

nsresult
nsSVGBoolean::SMILBool::SetAnimValue(const nsSMILValue& aValue)
{
  NS_ASSERTION(aValue.mType == SMILBoolType::Singleton(),
               "Unexpected type to assign animated value");
  if (aValue.mType == SMILBoolType::Singleton()) {
    mVal->SetAnimValue(uint16_t(aValue.mU.mBool), mSVGElement);
  }
  return NS_OK;
}
