/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "DOMSVGLength.h"

#include "DOMSVGLengthList.h"
#include "DOMSVGAnimatedLengthList.h"
#include "mozAutoDocUpdate.h"
#include "nsError.h"
#include "nsMathUtils.h"
#include "SVGAnimatedLength.h"
#include "SVGAnimatedLengthList.h"
#include "SVGAttrTearoffTable.h"
#include "SVGLength.h"
#include "mozilla/dom/SVGElement.h"
#include "mozilla/dom/SVGLengthBinding.h"
#include "mozilla/FloatingPoint.h"

// See the architecture comment in DOMSVGAnimatedLengthList.h.

namespace mozilla {

namespace dom {

static SVGAttrTearoffTable<SVGAnimatedLength, DOMSVGLength>
    sBaseSVGLengthTearOffTable, sAnimSVGLengthTearOffTable;

// We could use NS_IMPL_CYCLE_COLLECTION(, except that in Unlink() we need to
// clear our list's weak ref to us to be safe. (The other option would be to
// not unlink and rely on the breaking of the other edges in the cycle, as
// NS_SVG_VAL_IMPL_CYCLE_COLLECTION does.)
NS_IMPL_CYCLE_COLLECTION_CLASS(DOMSVGLength)

NS_IMPL_CYCLE_COLLECTION_UNLINK_BEGIN(DOMSVGLength)
  tmp->CleanupWeakRefs();
  tmp->mVal = nullptr;  // (owned by mSVGElement, which we drop our ref to here)
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mList)
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mSVGElement)
  NS_IMPL_CYCLE_COLLECTION_UNLINK_PRESERVED_WRAPPER
NS_IMPL_CYCLE_COLLECTION_UNLINK_END

NS_IMPL_CYCLE_COLLECTION_TRAVERSE_BEGIN(DOMSVGLength)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mList)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mSVGElement)
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_END

NS_IMPL_CYCLE_COLLECTION_TRACE_BEGIN(DOMSVGLength)
  NS_IMPL_CYCLE_COLLECTION_TRACE_PRESERVED_WRAPPER
NS_IMPL_CYCLE_COLLECTION_TRACE_END

NS_IMPL_CYCLE_COLLECTING_ADDREF(DOMSVGLength)
NS_IMPL_CYCLE_COLLECTING_RELEASE(DOMSVGLength)

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(DOMSVGLength)
  NS_WRAPPERCACHE_INTERFACE_MAP_ENTRY
  NS_INTERFACE_MAP_ENTRY(DOMSVGLength)  // pseudo-interface
  NS_INTERFACE_MAP_ENTRY(nsISupports)
NS_INTERFACE_MAP_END

//----------------------------------------------------------------------
// Helper class: AutoChangeLengthNotifier
// Stack-based helper class to pair calls to WillChangeLengthList and
// DidChangeLengthList.
class MOZ_RAII AutoChangeLengthNotifier : public mozAutoDocUpdate {
 public:
  explicit AutoChangeLengthNotifier(
      DOMSVGLength* aLength MOZ_GUARD_OBJECT_NOTIFIER_PARAM)
      : mozAutoDocUpdate(aLength->Element()->GetComposedDoc(), true),
        mLength(aLength) {
    MOZ_GUARD_OBJECT_NOTIFIER_INIT;
    MOZ_ASSERT(mLength, "Expecting non-null length");
    MOZ_ASSERT(mLength->HasOwner(),
               "Expecting list to have an owner for notification");
    mEmptyOrOldValue =
        mLength->Element()->WillChangeLengthList(mLength->mAttrEnum, *this);
  }

  ~AutoChangeLengthNotifier() {
    mLength->Element()->DidChangeLengthList(mLength->mAttrEnum,
                                            mEmptyOrOldValue, *this);
    // Null check mLength->mList, since DidChangeLengthList can run script,
    // potentially removing mLength from its list.
    if (mLength->mList && mLength->mList->IsAnimating()) {
      mLength->Element()->AnimationNeedsResample();
    }
  }

 private:
  DOMSVGLength* const mLength;
  nsAttrValue mEmptyOrOldValue;
  MOZ_DECL_USE_GUARD_OBJECT_NOTIFIER
};

DOMSVGLength::DOMSVGLength(DOMSVGLengthList* aList, uint8_t aAttrEnum,
                           uint32_t aListIndex, bool aIsAnimValItem)
    : mList(aList),
      mListIndex(aListIndex),
      mAttrEnum(aAttrEnum),
      mIsAnimValItem(aIsAnimValItem),
      mUnit(SVGLength_Binding::SVG_LENGTHTYPE_NUMBER),
      mValue(0.0f),
      mVal(nullptr) {
  // These shifts are in sync with the members in the header.
  MOZ_ASSERT(aList && aAttrEnum < (1 << 4) && aListIndex <= MaxListIndex(),
             "bad arg");

  MOZ_ASSERT(IndexIsValid(), "Bad index for DOMSVGNumber!");
}

DOMSVGLength::DOMSVGLength()
    : mList(nullptr),
      mListIndex(0),
      mAttrEnum(0),
      mIsAnimValItem(false),
      mUnit(SVGLength_Binding::SVG_LENGTHTYPE_NUMBER),
      mValue(0.0f),
      mVal(nullptr) {}

DOMSVGLength::DOMSVGLength(SVGAnimatedLength* aVal, SVGElement* aSVGElement,
                           bool aAnimVal)
    : mList(nullptr),
      mListIndex(0),
      mAttrEnum(0),
      mIsAnimValItem(aAnimVal),
      mUnit(SVGLength_Binding::SVG_LENGTHTYPE_NUMBER),
      mValue(0.0f),
      mVal(aVal),
      mSVGElement(aSVGElement) {}

void DOMSVGLength::CleanupWeakRefs() {
  // Our mList's weak ref to us must be nulled out when we die (or when we're
  // cycle collected), so we that don't leave behind a pointer to
  // free / soon-to-be-free memory.
  if (mList) {
    MOZ_ASSERT(mList->mItems[mListIndex] == this,
               "Clearing out the wrong list index...?");
    mList->mItems[mListIndex] = nullptr;
  }

  // Similarly, we must update the tearoff table to remove its (non-owning)
  // pointer to mVal.
  if (mVal) {
    auto& table = mIsAnimValItem ? sAnimSVGLengthTearOffTable
                                 : sBaseSVGLengthTearOffTable;
    table.RemoveTearoff(mVal);
  }
}

DOMSVGLength::~DOMSVGLength() { CleanupWeakRefs(); }

already_AddRefed<DOMSVGLength> DOMSVGLength::GetTearOff(SVGAnimatedLength* aVal,
                                                        SVGElement* aSVGElement,
                                                        bool aAnimVal) {
  auto& table =
      aAnimVal ? sAnimSVGLengthTearOffTable : sBaseSVGLengthTearOffTable;
  RefPtr<DOMSVGLength> domLength = table.GetTearoff(aVal);
  if (!domLength) {
    domLength = new DOMSVGLength(aVal, aSVGElement, aAnimVal);
    table.AddTearoff(aVal, domLength);
  }

  return domLength.forget();
}

DOMSVGLength* DOMSVGLength::Copy() {
  NS_ASSERTION(HasOwner() || IsReflectingAttribute(), "unexpected caller");
  DOMSVGLength* copy = new DOMSVGLength();
  uint16_t unit;
  float value;
  if (mVal) {
    unit = mVal->mSpecifiedUnitType;
    value = mIsAnimValItem ? mVal->mAnimVal : mVal->mBaseVal;
  } else {
    SVGLength& length = InternalItem();
    unit = length.GetUnit();
    value = length.GetValueInCurrentUnits();
  }
  copy->NewValueSpecifiedUnits(unit, value, IgnoreErrors());
  return copy;
}

uint16_t DOMSVGLength::UnitType() {
  if (mVal) {
    if (mIsAnimValItem) {
      mSVGElement->FlushAnimations();
    }
    return mVal->mSpecifiedUnitType;
  }

  if (mIsAnimValItem && HasOwner()) {
    Element()->FlushAnimations();  // May make HasOwner() == false
  }
  return HasOwner() ? InternalItem().GetUnit() : mUnit;
}

float DOMSVGLength::GetValue(ErrorResult& aRv) {
  if (mVal) {
    if (mIsAnimValItem) {
      mSVGElement->FlushAnimations();
      return mVal->GetAnimValue(mSVGElement);
    }
    return mVal->GetBaseValue(mSVGElement);
  }

  if (mIsAnimValItem && HasOwner()) {
    Element()->FlushAnimations();  // May make HasOwner() == false
  }
  if (HasOwner()) {
    float value = InternalItem().GetValueInUserUnits(Element(), Axis());
    if (!IsFinite(value)) {
      aRv.Throw(NS_ERROR_FAILURE);
    }
    return value;
  }

  float unitToPx;
  if (UserSpaceMetrics::ResolveAbsoluteUnit(mUnit, unitToPx)) {
    return mValue * unitToPx;
  }

  // else [SVGWG issue] Can't convert this length's value to user units
  // ReportToConsole
  aRv.Throw(NS_ERROR_FAILURE);
  return 0.0f;
}

void DOMSVGLength::SetValue(float aUserUnitValue, ErrorResult& aRv) {
  if (mIsAnimValItem) {
    aRv.Throw(NS_ERROR_DOM_NO_MODIFICATION_ALLOWED_ERR);
    return;
  }

  if (mVal) {
    aRv = mVal->SetBaseValue(aUserUnitValue, mSVGElement, true);
    return;
  }

  // Although the value passed in is in user units, this method does not turn
  // this length into a user unit length. Instead it converts the user unit
  // value to this length's current unit and sets that, leaving this length's
  // unit as it is.

  if (HasOwner()) {
    if (InternalItem().GetValueInUserUnits(Element(), Axis()) ==
        aUserUnitValue) {
      return;
    }
    float uuPerUnit = InternalItem().GetUserUnitsPerUnit(Element(), Axis());
    if (uuPerUnit > 0) {
      float newValue = aUserUnitValue / uuPerUnit;
      if (IsFinite(newValue)) {
        AutoChangeLengthNotifier notifier(this);
        InternalItem().SetValueAndUnit(newValue, InternalItem().GetUnit());
        return;
      }
    }
  } else if (mUnit == SVGLength_Binding::SVG_LENGTHTYPE_NUMBER ||
             mUnit == SVGLength_Binding::SVG_LENGTHTYPE_PX) {
    mValue = aUserUnitValue;
    return;
  }
  // else [SVGWG issue] Can't convert user unit value to this length's unit
  // ReportToConsole
  aRv.Throw(NS_ERROR_FAILURE);
}

float DOMSVGLength::ValueInSpecifiedUnits() {
  if (mVal) {
    if (mIsAnimValItem) {
      mSVGElement->FlushAnimations();
      return mVal->mAnimVal;
    }
    return mVal->mBaseVal;
  }

  if (mIsAnimValItem && HasOwner()) {
    Element()->FlushAnimations();  // May make HasOwner() == false
  }
  return HasOwner() ? InternalItem().GetValueInCurrentUnits() : mValue;
}

void DOMSVGLength::SetValueInSpecifiedUnits(float aValue, ErrorResult& aRv) {
  if (mIsAnimValItem) {
    aRv.Throw(NS_ERROR_DOM_NO_MODIFICATION_ALLOWED_ERR);
    return;
  }

  if (mVal) {
    MOZ_ASSERT(mSVGElement);
    mozAutoDocUpdate updateBatch(mSVGElement->GetComposedDoc(), true);
    mVal->SetBaseValueInSpecifiedUnits(aValue, mSVGElement, true, updateBatch);
    return;
  }

  if (HasOwner()) {
    if (InternalItem().GetValueInCurrentUnits() == aValue) {
      return;
    }
    AutoChangeLengthNotifier notifier(this);
    InternalItem().SetValueInCurrentUnits(aValue);
    return;
  }
  mValue = aValue;
}

void DOMSVGLength::SetValueAsString(const nsAString& aValue, ErrorResult& aRv) {
  if (mIsAnimValItem) {
    aRv.Throw(NS_ERROR_DOM_NO_MODIFICATION_ALLOWED_ERR);
    return;
  }

  if (mVal) {
    aRv = mVal->SetBaseValueString(aValue, mSVGElement, true);
    return;
  }

  SVGLength value;
  if (!value.SetValueFromString(aValue)) {
    aRv.Throw(NS_ERROR_DOM_SYNTAX_ERR);
    return;
  }
  if (HasOwner()) {
    if (InternalItem() == value) {
      return;
    }
    AutoChangeLengthNotifier notifier(this);
    InternalItem() = value;
    return;
  }
  mValue = value.GetValueInCurrentUnits();
  mUnit = value.GetUnit();
}

void DOMSVGLength::GetValueAsString(nsAString& aValue) {
  if (mVal) {
    if (mIsAnimValItem) {
      mSVGElement->FlushAnimations();
      mVal->GetAnimValueString(aValue);
    } else {
      mVal->GetBaseValueString(aValue);
    }
    return;
  }

  if (mIsAnimValItem && HasOwner()) {
    Element()->FlushAnimations();  // May make HasOwner() == false
  }
  if (HasOwner()) {
    InternalItem().GetValueAsString(aValue);
    return;
  }
  SVGLength(mValue, mUnit).GetValueAsString(aValue);
}

void DOMSVGLength::NewValueSpecifiedUnits(uint16_t aUnit, float aValue,
                                          ErrorResult& aRv) {
  if (mIsAnimValItem) {
    aRv.Throw(NS_ERROR_DOM_NO_MODIFICATION_ALLOWED_ERR);
    return;
  }

  if (mVal) {
    mVal->NewValueSpecifiedUnits(aUnit, aValue, mSVGElement);
    return;
  }

  if (!SVGLength::IsValidUnitType(aUnit)) {
    aRv.Throw(NS_ERROR_DOM_NOT_SUPPORTED_ERR);
    return;
  }
  if (HasOwner()) {
    if (InternalItem().GetUnit() == aUnit &&
        InternalItem().GetValueInCurrentUnits() == aValue) {
      return;
    }
    AutoChangeLengthNotifier notifier(this);
    InternalItem().SetValueAndUnit(aValue, uint8_t(aUnit));
    return;
  }
  mUnit = uint8_t(aUnit);
  mValue = aValue;
}

void DOMSVGLength::ConvertToSpecifiedUnits(uint16_t aUnit, ErrorResult& aRv) {
  if (mIsAnimValItem) {
    aRv.Throw(NS_ERROR_DOM_NO_MODIFICATION_ALLOWED_ERR);
    return;
  }

  if (mVal) {
    mVal->ConvertToSpecifiedUnits(aUnit, mSVGElement);
    return;
  }

  if (!SVGLength::IsValidUnitType(aUnit)) {
    aRv.Throw(NS_ERROR_DOM_NOT_SUPPORTED_ERR);
    return;
  }
  if (HasOwner()) {
    if (InternalItem().GetUnit() == aUnit) {
      return;
    }
    float val =
        InternalItem().GetValueInSpecifiedUnit(aUnit, Element(), Axis());
    if (IsFinite(val)) {
      AutoChangeLengthNotifier notifier(this);
      InternalItem().SetValueAndUnit(val, aUnit);
      return;
    }
  } else {
    SVGLength len(mValue, mUnit);
    float val = len.GetValueInSpecifiedUnit(aUnit, nullptr, 0);
    if (IsFinite(val)) {
      mValue = val;
      mUnit = aUnit;
      return;
    }
  }
  // else [SVGWG issue] Can't convert unit
  // ReportToConsole
  aRv.Throw(NS_ERROR_FAILURE);
}

JSObject* DOMSVGLength::WrapObject(JSContext* aCx,
                                   JS::Handle<JSObject*> aGivenProto) {
  return SVGLength_Binding::Wrap(aCx, this, aGivenProto);
}

void DOMSVGLength::InsertingIntoList(DOMSVGLengthList* aList, uint8_t aAttrEnum,
                                     uint32_t aListIndex, bool aIsAnimValItem) {
  NS_ASSERTION(!HasOwner(), "Inserting item that is already in a list");

  mList = aList;
  mAttrEnum = aAttrEnum;
  mListIndex = aListIndex;
  mIsAnimValItem = aIsAnimValItem;

  MOZ_ASSERT(IndexIsValid(), "Bad index for DOMSVGLength!");
}

void DOMSVGLength::RemovingFromList() {
  mValue = InternalItem().GetValueInCurrentUnits();
  mUnit = InternalItem().GetUnit();
  mList = nullptr;
  mIsAnimValItem = false;
}

SVGLength DOMSVGLength::ToSVGLength() {
  if (HasOwner()) {
    return SVGLength(InternalItem().GetValueInCurrentUnits(),
                     InternalItem().GetUnit());
  }
  return SVGLength(mValue, mUnit);
}

SVGLength& DOMSVGLength::InternalItem() {
  SVGAnimatedLengthList* alist = Element()->GetAnimatedLengthList(mAttrEnum);
  return mIsAnimValItem && alist->mAnimVal ? (*alist->mAnimVal)[mListIndex]
                                           : alist->mBaseVal[mListIndex];
}

#ifdef DEBUG
bool DOMSVGLength::IndexIsValid() {
  SVGAnimatedLengthList* alist = Element()->GetAnimatedLengthList(mAttrEnum);
  return (mIsAnimValItem && mListIndex < alist->GetAnimValue().Length()) ||
         (!mIsAnimValItem && mListIndex < alist->GetBaseValue().Length());
}
#endif

}  // namespace dom
}  // namespace mozilla
