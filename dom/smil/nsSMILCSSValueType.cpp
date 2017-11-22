/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* representation of a value for a SMIL-animated CSS property */

#include "nsSMILCSSValueType.h"

#include "nsComputedDOMStyle.h"
#include "nsString.h"
#include "nsSMILParserUtils.h"
#include "nsSMILValue.h"
#include "nsCSSProps.h"
#include "nsCSSValue.h"
#include "nsColor.h"
#include "nsPresContext.h"
#include "mozilla/ServoBindings.h"
#include "mozilla/StyleAnimationValue.h" // For AnimationValue
#include "mozilla/StyleSetHandleInlines.h"
#include "mozilla/dom/BaseKeyframeTypesBinding.h" // For CompositeOperation
#include "mozilla/dom/Element.h"
#include "nsDebug.h"
#include "nsStyleUtil.h"
#include "nsIDocument.h"

using namespace mozilla::dom;
using mozilla::StyleAnimationValue;

typedef AutoTArray<RefPtr<RawServoAnimationValue>, 1> ServoAnimationValues;

/*static*/ nsSMILCSSValueType nsSMILCSSValueType::sSingleton;

struct ValueWrapper {
  ValueWrapper(nsCSSPropertyID aPropID, const AnimationValue& aValue)
    : mPropID(aPropID)
  {
    if (aValue.mServo) {
      mServoValues.AppendElement(aValue.mServo);
      return;
    }
    mGeckoValue = aValue.mGecko;
  }
  ValueWrapper(nsCSSPropertyID aPropID, const StyleAnimationValue& aValue)
    : mPropID(aPropID), mGeckoValue(aValue) {}
  ValueWrapper(nsCSSPropertyID aPropID,
               const RefPtr<RawServoAnimationValue>& aValue)
    : mPropID(aPropID), mServoValues{(aValue)} {}
  ValueWrapper(nsCSSPropertyID aPropID, ServoAnimationValues&& aValues)
    : mPropID(aPropID), mServoValues{aValues} {}

  bool operator==(const ValueWrapper& aOther) const
  {
    if (mPropID != aOther.mPropID) {
      return false;
    }

    if (!mServoValues.IsEmpty()) {
      size_t len = mServoValues.Length();
      if (len != aOther.mServoValues.Length()) {
        return false;
      }
      for (size_t i = 0; i < len; i++) {
        if (!Servo_AnimationValue_DeepEqual(mServoValues[i],
                                            aOther.mServoValues[i])) {
          return false;
        }
      }
      return true;
    }

    return mGeckoValue == aOther.mGeckoValue;
  }

  bool operator!=(const ValueWrapper& aOther) const
  {
    return !(*this == aOther);
  }

  nsCSSPropertyID mPropID;
  ServoAnimationValues mServoValues;
  StyleAnimationValue mGeckoValue;

};

// Helper Methods
// --------------
static const StyleAnimationValue*
GetZeroValueForUnit(StyleAnimationValue::Unit aUnit)
{
  static const StyleAnimationValue
    sZeroCoord(0, StyleAnimationValue::CoordConstructor);
  static const StyleAnimationValue
    sZeroPercent(0.0f, StyleAnimationValue::PercentConstructor);
  static const StyleAnimationValue
    sZeroFloat(0.0f,  StyleAnimationValue::FloatConstructor);
  static const StyleAnimationValue
    sZeroColor(NS_RGB(0,0,0), StyleAnimationValue::ColorConstructor);

  MOZ_ASSERT(aUnit != StyleAnimationValue::eUnit_Null,
             "Need non-null unit for a zero value");
  switch (aUnit) {
    case StyleAnimationValue::eUnit_Coord:
      return &sZeroCoord;
    case StyleAnimationValue::eUnit_Percent:
      return &sZeroPercent;
    case StyleAnimationValue::eUnit_Float:
      return &sZeroFloat;
    case StyleAnimationValue::eUnit_Color:
      return &sZeroColor;
    default:
      return nullptr;
  }
}

// This method requires at least one of its arguments to be non-null.
//
// If one argument is null, this method updates it to point to "zero"
// for the other argument's Unit (if applicable; otherwise, we return false).
//
// If neither argument is null, this method does nothing.
//
// |aZeroValueStorage| should be a reference to a RefPtr<RawServoAnimationValue>.
// This is used where we may need to allocate a new ServoAnimationValue to
// represent the appropriate zero value.
//
// Returns true on success, or otherwise.
static bool
FinalizeServoAnimationValues(const RefPtr<RawServoAnimationValue>*& aValue1,
                             const RefPtr<RawServoAnimationValue>*& aValue2,
                             RefPtr<RawServoAnimationValue>& aZeroValueStorage)
{
  MOZ_ASSERT(aValue1 || aValue2, "expecting at least one non-null value");

  // Are we missing either val? (If so, it's an implied 0 in other val's units)

  if (!aValue1) {
    aZeroValueStorage = Servo_AnimationValues_GetZeroValue(*aValue2).Consume();
    aValue1 = &aZeroValueStorage;
  } else if (!aValue2) {
    aZeroValueStorage = Servo_AnimationValues_GetZeroValue(*aValue1).Consume();
    aValue2 = &aZeroValueStorage;
  }
  return *aValue1 && *aValue2;
}

static bool
FinalizeStyleAnimationValues(const StyleAnimationValue*& aValue1,
                             const StyleAnimationValue*& aValue2)
{
  MOZ_ASSERT(aValue1 || aValue2,
             "expecting at least one non-null value");

  if (!aValue1) {
    aValue1 = GetZeroValueForUnit(aValue2->GetUnit());
    return !!aValue1; // Fail if we have no zero value for this unit.
  }
  if (!aValue2) {
    aValue2 = GetZeroValueForUnit(aValue1->GetUnit());
    return !!aValue2; // Fail if we have no zero value for this unit.
  }

  // Ok, both values were specified.
  // Need to handle a special-case, though: unitless nonzero length (parsed as
  // eUnit_Float) mixed with unitless 0 length (parsed as eUnit_Coord).  These
  // won't interoperate in StyleAnimationValue, since their Units don't match.
  // In this case, we replace the eUnit_Coord 0 value with eUnit_Float 0 value.
  const StyleAnimationValue& zeroCoord =
    *GetZeroValueForUnit(StyleAnimationValue::eUnit_Coord);
  if (*aValue1 == zeroCoord &&
      aValue2->GetUnit() == StyleAnimationValue::eUnit_Float) {
    aValue1 = GetZeroValueForUnit(StyleAnimationValue::eUnit_Float);
  } else if (*aValue2 == zeroCoord &&
             aValue1->GetUnit() == StyleAnimationValue::eUnit_Float) {
    aValue2 = GetZeroValueForUnit(StyleAnimationValue::eUnit_Float);
  }

  return true;
}

static void
InvertSign(StyleAnimationValue& aValue)
{
  switch (aValue.GetUnit()) {
    case StyleAnimationValue::eUnit_Coord:
      aValue.SetCoordValue(-aValue.GetCoordValue());
      break;
    case StyleAnimationValue::eUnit_Percent:
      aValue.SetPercentValue(-aValue.GetPercentValue());
      break;
    case StyleAnimationValue::eUnit_Float:
      aValue.SetFloatValue(-aValue.GetFloatValue());
      break;
    default:
      NS_NOTREACHED("Calling InvertSign with an unsupported unit");
      break;
  }
}

static ValueWrapper*
ExtractValueWrapper(nsSMILValue& aValue)
{
  return static_cast<ValueWrapper*>(aValue.mU.mPtr);
}

static const ValueWrapper*
ExtractValueWrapper(const nsSMILValue& aValue)
{
  return static_cast<const ValueWrapper*>(aValue.mU.mPtr);
}

// Class methods
// -------------
void
nsSMILCSSValueType::Init(nsSMILValue& aValue) const
{
  MOZ_ASSERT(aValue.IsNull(), "Unexpected SMIL value type");

  aValue.mU.mPtr = nullptr;
  aValue.mType = this;
}

void
nsSMILCSSValueType::Destroy(nsSMILValue& aValue) const
{
  MOZ_ASSERT(aValue.mType == this, "Unexpected SMIL value type");
  delete static_cast<ValueWrapper*>(aValue.mU.mPtr);
  aValue.mType = nsSMILNullType::Singleton();
}

nsresult
nsSMILCSSValueType::Assign(nsSMILValue& aDest, const nsSMILValue& aSrc) const
{
  MOZ_ASSERT(aDest.mType == aSrc.mType, "Incompatible SMIL types");
  MOZ_ASSERT(aDest.mType == this, "Unexpected SMIL value type");
  const ValueWrapper* srcWrapper = ExtractValueWrapper(aSrc);
  ValueWrapper* destWrapper = ExtractValueWrapper(aDest);

  if (srcWrapper) {
    if (!destWrapper) {
      // barely-initialized dest -- need to alloc & copy
      aDest.mU.mPtr = new ValueWrapper(*srcWrapper);
    } else {
      // both already fully-initialized -- just copy straight across
      *destWrapper = *srcWrapper;
    }
  } else if (destWrapper) {
    // fully-initialized dest, barely-initialized src -- clear dest
    delete destWrapper;
    aDest.mU.mPtr = destWrapper = nullptr;
  } // else, both are barely-initialized -- nothing to do.

  return NS_OK;
}

bool
nsSMILCSSValueType::IsEqual(const nsSMILValue& aLeft,
                            const nsSMILValue& aRight) const
{
  MOZ_ASSERT(aLeft.mType == aRight.mType, "Incompatible SMIL types");
  MOZ_ASSERT(aLeft.mType == this, "Unexpected SMIL value");
  const ValueWrapper* leftWrapper = ExtractValueWrapper(aLeft);
  const ValueWrapper* rightWrapper = ExtractValueWrapper(aRight);

  if (leftWrapper) {
    if (rightWrapper) {
      // Both non-null
      NS_WARNING_ASSERTION(leftWrapper != rightWrapper,
                           "Two nsSMILValues with matching ValueWrapper ptr");
      return *leftWrapper == *rightWrapper;
    }
    // Left non-null, right null
    return false;
  }
  if (rightWrapper) {
    // Left null, right non-null
    return false;
  }
  // Both null
  return true;
}

static bool
AddOrAccumulateForServo(nsSMILValue& aDest,
                        const ValueWrapper* aValueToAddWrapper,
                        ValueWrapper* aDestWrapper,
                        CompositeOperation aCompositeOp,
                        uint64_t aCount)
{
  nsCSSPropertyID property = aValueToAddWrapper
                             ? aValueToAddWrapper->mPropID
                             : aDestWrapper->mPropID;
  size_t len = aValueToAddWrapper
               ? aValueToAddWrapper->mServoValues.Length()
               : aDestWrapper->mServoValues.Length();

  MOZ_ASSERT(!aValueToAddWrapper || !aDestWrapper ||
             aValueToAddWrapper->mServoValues.Length() ==
               aDestWrapper->mServoValues.Length(),
             "Both of values'length in the wrappers should be the same if "
             "both of them exist");

  for (size_t i = 0; i < len; i++) {
    const RefPtr<RawServoAnimationValue>* valueToAdd =
      aValueToAddWrapper
      ? &aValueToAddWrapper->mServoValues[i]
      : nullptr;
    const RefPtr<RawServoAnimationValue>* destValue =
      aDestWrapper
      ? &aDestWrapper->mServoValues[i]
      : nullptr;
    RefPtr<RawServoAnimationValue> zeroValueStorage;
    if (!FinalizeServoAnimationValues(valueToAdd, destValue, zeroValueStorage)) {
      return false;
    }

    // FinalizeServoAnimationValues may have updated destValue so we should make
    // sure the aDest and aDestWrapper outparams are up-to-date.
    if (aDestWrapper) {
      aDestWrapper->mServoValues[i] = *destValue;
    } else {
      // aDest may be a barely-initialized "zero" destination.
      aDest.mU.mPtr = aDestWrapper = new ValueWrapper(property, *destValue);
      aDestWrapper->mServoValues.SetLength(len);
    }

    RefPtr<RawServoAnimationValue> result;
    if (aCompositeOp == CompositeOperation::Add) {
      result = Servo_AnimationValues_Add(*destValue, *valueToAdd).Consume();
    } else {
      result = Servo_AnimationValues_Accumulate(*destValue,
                                                *valueToAdd,
                                                aCount).Consume();
    }

    if (!result) {
      return false;
    }
    aDestWrapper->mServoValues[i] = result;
  }

  return true;
}

static bool
AddOrAccumulate(nsSMILValue& aDest, const nsSMILValue& aValueToAdd,
                CompositeOperation aCompositeOp, uint64_t aCount)
{
  MOZ_ASSERT(aValueToAdd.mType == aDest.mType,
             "Trying to add mismatching types");
  MOZ_ASSERT(aValueToAdd.mType == &nsSMILCSSValueType::sSingleton,
             "Unexpected SMIL value type");
  MOZ_ASSERT(aCompositeOp == CompositeOperation::Add ||
             aCompositeOp == CompositeOperation::Accumulate,
             "Composite operation should be add or accumulate");
  MOZ_ASSERT(aCompositeOp != CompositeOperation::Add || aCount == 1,
             "Count should be 1 if composite operation is add");

  ValueWrapper* destWrapper = ExtractValueWrapper(aDest);
  const ValueWrapper* valueToAddWrapper = ExtractValueWrapper(aValueToAdd);
  MOZ_ASSERT(destWrapper || valueToAddWrapper,
             "need at least one fully-initialized value");

  nsCSSPropertyID property = valueToAddWrapper
                             ? valueToAddWrapper->mPropID
                             : destWrapper->mPropID;
  // Special case: font-size-adjust and stroke-dasharray are explicitly
  // non-additive (even though StyleAnimationValue *could* support adding them)
  if (property == eCSSProperty_font_size_adjust ||
      property == eCSSProperty_stroke_dasharray) {
    return false;
  }
  // Skip font shorthand since it includes font-size-adjust.
  if (property == eCSSProperty_font) {
    return false;
  }

  bool isServo = valueToAddWrapper
                 ? !valueToAddWrapper->mServoValues.IsEmpty()
                 : !destWrapper->mServoValues.IsEmpty();
  if (isServo) {
    return AddOrAccumulateForServo(aDest,
                                   valueToAddWrapper,
                                   destWrapper,
                                   aCompositeOp,
                                   aCount);
  }

  const StyleAnimationValue* valueToAdd = valueToAddWrapper ?
    &valueToAddWrapper->mGeckoValue : nullptr;
  const StyleAnimationValue* destValue = destWrapper ?
    &destWrapper->mGeckoValue : nullptr;
  if (!FinalizeStyleAnimationValues(valueToAdd, destValue)) {
    return false;
  }
  // Did FinalizeStyleAnimationValues change destValue?
  // If so, update outparam to use the new value.
  if (destWrapper && &destWrapper->mGeckoValue != destValue) {
    destWrapper->mGeckoValue = *destValue;
  }

  // Handle barely-initialized "zero" destination.
  if (!destWrapper) {
    aDest.mU.mPtr = destWrapper = new ValueWrapper(property, *destValue);
  }

  // For Gecko, we currently call Add for either composite mode.
  //
  // This is not ideal, but it doesn't make any difference for the set of
  // properties we currently allow adding in SMIL and this code path will
  // hopefully become obsolete before we expand that set.
  return StyleAnimationValue::Add(property,
                                  destWrapper->mGeckoValue,
                                  *valueToAdd, aCount);
}

nsresult
nsSMILCSSValueType::SandwichAdd(nsSMILValue& aDest,
                                const nsSMILValue& aValueToAdd) const
{
  return AddOrAccumulate(aDest, aValueToAdd, CompositeOperation::Add, 1)
         ? NS_OK
         : NS_ERROR_FAILURE;
}

nsresult
nsSMILCSSValueType::Add(nsSMILValue& aDest, const nsSMILValue& aValueToAdd,
                        uint32_t aCount) const
{
  return AddOrAccumulate(aDest, aValueToAdd, CompositeOperation::Accumulate,
                         aCount)
         ? NS_OK
         : NS_ERROR_FAILURE;
}

static nsresult
ComputeDistanceForServo(const ValueWrapper* aFromWrapper,
                        const ValueWrapper& aToWrapper,
                        double& aDistance)
{
  size_t len = aToWrapper.mServoValues.Length();
  MOZ_ASSERT(!aFromWrapper || aFromWrapper->mServoValues.Length() == len,
             "From and to values length should be the same if "
             "The start value exists");

  double squareDistance = 0;

  for (size_t i = 0; i < len; i++) {
    const RefPtr<RawServoAnimationValue>* fromValue =
      aFromWrapper ? &aFromWrapper->mServoValues[0] : nullptr;
    const RefPtr<RawServoAnimationValue>* toValue = &aToWrapper.mServoValues[0];
    RefPtr<RawServoAnimationValue> zeroValueStorage;
    if (!FinalizeServoAnimationValues(fromValue, toValue, zeroValueStorage)) {
      return NS_ERROR_FAILURE;
    }

    double distance = Servo_AnimationValues_ComputeDistance(*fromValue, *toValue);
    if (len == 1) {
      aDistance = distance;
      return NS_OK;
    }
    squareDistance += distance * distance;
  }

  aDistance = sqrt(squareDistance);

  return NS_OK;
}

nsresult
nsSMILCSSValueType::ComputeDistance(const nsSMILValue& aFrom,
                                    const nsSMILValue& aTo,
                                    double& aDistance) const
{
  MOZ_ASSERT(aFrom.mType == aTo.mType,
             "Trying to compare different types");
  MOZ_ASSERT(aFrom.mType == this, "Unexpected source type");

  const ValueWrapper* fromWrapper = ExtractValueWrapper(aFrom);
  const ValueWrapper* toWrapper = ExtractValueWrapper(aTo);
  MOZ_ASSERT(toWrapper, "expecting non-null endpoint");

  if (!toWrapper->mServoValues.IsEmpty()) {
    return ComputeDistanceForServo(fromWrapper, *toWrapper, aDistance);
  }

  const StyleAnimationValue* fromCSSValue = fromWrapper ?
    &fromWrapper->mGeckoValue : nullptr;
  const StyleAnimationValue* toCSSValue = &toWrapper->mGeckoValue;
  if (!FinalizeStyleAnimationValues(fromCSSValue, toCSSValue)) {
    return NS_ERROR_FAILURE;
  }

  return StyleAnimationValue::ComputeDistance(toWrapper->mPropID,
                                              fromWrapper->mGeckoValue,
                                              toWrapper->mGeckoValue,
                                              nullptr,
                                              aDistance)
         ? NS_OK
         : NS_ERROR_FAILURE;
}

static nsresult
InterpolateForGecko(const ValueWrapper* aStartWrapper,
                    const ValueWrapper& aEndWrapper,
                    double aUnitDistance,
                    nsSMILValue& aResult)
{
  const StyleAnimationValue* startCSSValue = aStartWrapper
                                             ? &aStartWrapper->mGeckoValue
                                             : nullptr;
  const StyleAnimationValue* endCSSValue = &aEndWrapper.mGeckoValue;
  if (!FinalizeStyleAnimationValues(startCSSValue, endCSSValue)) {
    return NS_ERROR_FAILURE;
  }

  StyleAnimationValue resultValue;
  if (StyleAnimationValue::Interpolate(aEndWrapper.mPropID,
                                       *startCSSValue,
                                       *endCSSValue,
                                       aUnitDistance, resultValue)) {
    aResult.mU.mPtr = new ValueWrapper(aEndWrapper.mPropID, resultValue);
    return NS_OK;
  }
  return NS_ERROR_FAILURE;
}

static nsresult
InterpolateForServo(const ValueWrapper* aStartWrapper,
                    const ValueWrapper& aEndWrapper,
                    double aUnitDistance,
                    nsSMILValue& aResult)
{
  ServoAnimationValues results;
  size_t len = aEndWrapper.mServoValues.Length();
  results.SetCapacity(len);
  MOZ_ASSERT(!aStartWrapper || aStartWrapper->mServoValues.Length() == len,
             "Start and end values length should be the same if "
             "The start value exists");
  for (size_t i = 0; i < len; i++) {
    const RefPtr<RawServoAnimationValue>*
      startValue = aStartWrapper
                   ? &aStartWrapper->mServoValues[i]
                   : nullptr;
    const RefPtr<RawServoAnimationValue>* endValue = &aEndWrapper.mServoValues[i];
    RefPtr<RawServoAnimationValue> zeroValueStorage;
    if (!FinalizeServoAnimationValues(startValue, endValue, zeroValueStorage)) {
      return NS_ERROR_FAILURE;
    }

    RefPtr<RawServoAnimationValue> result =
      Servo_AnimationValues_Interpolate(*startValue,
                                        *endValue,
                                        aUnitDistance).Consume();
    if (!result) {
      return NS_ERROR_FAILURE;
    }
    results.AppendElement(result);
  }
  aResult.mU.mPtr = new ValueWrapper(aEndWrapper.mPropID, Move(results));

  return NS_OK;
}

nsresult
nsSMILCSSValueType::Interpolate(const nsSMILValue& aStartVal,
                                const nsSMILValue& aEndVal,
                                double aUnitDistance,
                                nsSMILValue& aResult) const
{
  MOZ_ASSERT(aStartVal.mType == aEndVal.mType,
             "Trying to interpolate different types");
  MOZ_ASSERT(aStartVal.mType == this,
             "Unexpected types for interpolation");
  MOZ_ASSERT(aResult.mType == this, "Unexpected result type");
  MOZ_ASSERT(aUnitDistance >= 0.0 && aUnitDistance <= 1.0,
             "unit distance value out of bounds");
  MOZ_ASSERT(!aResult.mU.mPtr, "expecting barely-initialized outparam");

  const ValueWrapper* startWrapper = ExtractValueWrapper(aStartVal);
  const ValueWrapper* endWrapper = ExtractValueWrapper(aEndVal);
  MOZ_ASSERT(endWrapper, "expecting non-null endpoint");

  if (!endWrapper->mServoValues.IsEmpty()) {
    return InterpolateForServo(startWrapper,
                               *endWrapper,
                               aUnitDistance,
                               aResult);
  }

  return InterpolateForGecko(startWrapper,
                             *endWrapper,
                             aUnitDistance,
                             aResult);
}

// Helper function to extract presContext
static nsPresContext*
GetPresContextForElement(Element* aElem)
{
  nsIDocument* doc = aElem->GetUncomposedDoc();
  if (!doc) {
    // This can happen if we process certain types of restyles mid-sample
    // and remove anonymous animated content from the document as a result.
    // See bug 534975.
    return nullptr;
  }
  nsIPresShell* shell = doc->GetShell();
  return shell ? shell->GetPresContext() : nullptr;
}

static const nsDependentSubstring
GetNonNegativePropValue(const nsAString& aString, nsCSSPropertyID aPropID,
                        bool& aIsNegative)
{
  // If value is negative, we'll strip off the "-" so the CSS parser won't
  // barf, and then manually make the parsed value negative.
  // (This is a partial solution to let us accept some otherwise out-of-bounds
  // CSS values. Bug 501188 will provide a more complete fix.)
  aIsNegative = false;
  uint32_t subStringBegin = 0;

  // NOTE: We need to opt-out 'stroke-dasharray' from the negative-number
  // check.  Its values might look negative (e.g. by starting with "-1"), but
  // they're more complicated than our simple negation logic here can handle.
  if (aPropID != eCSSProperty_stroke_dasharray) {
    int32_t absValuePos = nsSMILParserUtils::CheckForNegativeNumber(aString);
    if (absValuePos > 0) {
      aIsNegative = true;
      subStringBegin = (uint32_t)absValuePos; // Start parsing after '-' sign
    }
  }

  return Substring(aString, subStringBegin);
}

// Helper function to parse a string into a StyleAnimationValue
static bool
ValueFromStringHelper(nsCSSPropertyID aPropID,
                      Element* aTargetElement,
                      nsPresContext* aPresContext,
                      mozilla::GeckoStyleContext* aStyleContext,
                      const nsAString& aString,
                      StyleAnimationValue& aStyleAnimValue,
                      bool* aIsContextSensitive)
{
  bool isNegative = false;
  const nsDependentSubstring subString =
    GetNonNegativePropValue(aString, aPropID, isNegative);

  if (!StyleAnimationValue::ComputeValue(aPropID, aTargetElement, aStyleContext,
                                         subString, true, aStyleAnimValue,
                                         aIsContextSensitive)) {
    return false;
  }
  if (isNegative) {
    InvertSign(aStyleAnimValue);
  }

  if (aPropID == eCSSProperty_font_size) {
    // Divide out text-zoom, since SVG is supposed to ignore it
    MOZ_ASSERT(aStyleAnimValue.GetUnit() == StyleAnimationValue::eUnit_Coord,
               "'font-size' value with unexpected style unit");
    aStyleAnimValue.SetCoordValue(aStyleAnimValue.GetCoordValue() /
                                  aPresContext->EffectiveTextZoom());
  }
  return true;
}

static ServoAnimationValues
ValueFromStringHelper(nsCSSPropertyID aPropID,
                      Element* aTargetElement,
                      nsPresContext* aPresContext,
                      nsStyleContext* aStyleContext,
                      const nsAString& aString)
{
  ServoAnimationValues result;

  nsIDocument* doc = aTargetElement->GetUncomposedDoc();
  if (!doc) {
    return result;
  }

  // Parse property
  // FIXME this is using the wrong base uri (bug 1343919)
  RefPtr<URLExtraData> data = new URLExtraData(doc->GetDocumentURI(),
                                               doc->GetDocumentURI(),
                                               doc->NodePrincipal());
  NS_ConvertUTF16toUTF8 value(aString);
  RefPtr<RawServoDeclarationBlock> servoDeclarationBlock =
    Servo_ParseProperty(aPropID,
                        &value,
                        data,
                        ParsingMode::AllowUnitlessLength |
                        ParsingMode::AllowAllNumericValues,
                        doc->GetCompatibilityMode(),
                        doc->CSSLoader()).Consume();
  if (!servoDeclarationBlock) {
    return result;
  }

  // Compute value
  aPresContext->StyleSet()->AsServo()->GetAnimationValues(servoDeclarationBlock,
                                                          aTargetElement,
                                                          aStyleContext->AsServo(),
                                                          result);
  if (result.IsEmpty()) {
    return result;
  }

  if (aPropID == eCSSProperty_font_size) {
    // FIXME (bug 1357296): Divide out text-zoom, since SVG is supposed to
    // ignore it.
    if (aPresContext->EffectiveTextZoom() != 1.0) {
      NS_WARNING("stylo: Dividing out text-zoom not yet supported"
                 " (bug 1357296)");
    }
  }

  return result;
}

// static
void
nsSMILCSSValueType::ValueFromString(nsCSSPropertyID aPropID,
                                    Element* aTargetElement,
                                    const nsAString& aString,
                                    nsSMILValue& aValue,
                                    bool* aIsContextSensitive)
{
  MOZ_ASSERT(aValue.IsNull(), "Outparam should be null-typed");
  nsPresContext* presContext = GetPresContextForElement(aTargetElement);
  if (!presContext) {
    NS_WARNING("Not parsing animation value; unable to get PresContext");
    return;
  }

  nsIDocument* doc = aTargetElement->GetUncomposedDoc();
  if (doc && !nsStyleUtil::CSPAllowsInlineStyle(nullptr,
                                                doc->NodePrincipal(),
                                                doc->GetDocumentURI(),
                                                0, aString, nullptr)) {
    return;
  }

  RefPtr<nsStyleContext> styleContext =
    nsComputedDOMStyle::GetStyleContext(aTargetElement, nullptr,
                                        presContext->PresShell());
  if (!styleContext) {
    return;
  }

  if (styleContext->IsServo()) {
    ServoAnimationValues parsedValues =
      ValueFromStringHelper(aPropID, aTargetElement, presContext,
                            styleContext, aString);
    if (aIsContextSensitive) {
      // FIXME: Bug 1358955 - detect context-sensitive values and set this value
      // appropriately.
      *aIsContextSensitive = false;
    }

    if (!parsedValues.IsEmpty()) {
      sSingleton.Init(aValue);
      aValue.mU.mPtr = new ValueWrapper(aPropID, Move(parsedValues));
    }
    return;
  }

  StyleAnimationValue parsedValue;
  if (ValueFromStringHelper(aPropID, aTargetElement, presContext,
                            styleContext->AsGecko(), aString, parsedValue,
                            aIsContextSensitive)) {
    sSingleton.Init(aValue);
    aValue.mU.mPtr = new ValueWrapper(aPropID, parsedValue);
  }
}

// static
nsSMILValue
nsSMILCSSValueType::ValueFromAnimationValue(nsCSSPropertyID aPropID,
                                            Element* aTargetElement,
                                            const AnimationValue& aValue)
{
  nsSMILValue result;

  nsIDocument* doc = aTargetElement->GetUncomposedDoc();
  // We'd like to avoid serializing |aValue| if possible, and since the
  // string passed to CSPAllowsInlineStyle is only used for reporting violations
  // and an intermediate CSS value is not likely to be particularly useful
  // in that case, we just use a generic placeholder string instead.
  static const nsLiteralString kPlaceholderText =
    NS_LITERAL_STRING("[SVG animation of CSS]");
  if (doc && !nsStyleUtil::CSPAllowsInlineStyle(nullptr,
                                                doc->NodePrincipal(),
                                                doc->GetDocumentURI(),
                                                0, kPlaceholderText, nullptr)) {
    return result;
  }

  sSingleton.Init(result);
  result.mU.mPtr = new ValueWrapper(aPropID, aValue);

  return result;
}

// static
void
nsSMILCSSValueType::ValueToString(const nsSMILValue& aValue,
                                  nsAString& aString)
{
  MOZ_ASSERT(aValue.mType == &nsSMILCSSValueType::sSingleton,
             "Unexpected SMIL value type");
  const ValueWrapper* wrapper = ExtractValueWrapper(aValue);
  if (!wrapper) {
    return;
  }

  if (wrapper->mServoValues.IsEmpty()) {
    DebugOnly<bool> uncomputeResult =
      StyleAnimationValue::UncomputeValue(wrapper->mPropID,
                                          wrapper->mGeckoValue,
                                          aString);
    return;
  }

  if (nsCSSProps::IsShorthand(wrapper->mPropID)) {
    // In case of shorthand on servo, we iterate over all mServoValues array
    // since we have multiple AnimationValues in the array for each longhand
    // component.
    Servo_Shorthand_AnimationValues_Serialize(wrapper->mPropID,
                                              &wrapper->mServoValues,
                                              &aString);
    return;
  }

  Servo_AnimationValue_Serialize(wrapper->mServoValues[0],
                                 wrapper->mPropID,
                                 &aString);
}

// static
nsCSSPropertyID
nsSMILCSSValueType::PropertyFromValue(const nsSMILValue& aValue)
{
  if (aValue.mType != &nsSMILCSSValueType::sSingleton) {
    return eCSSProperty_UNKNOWN;
  }

  const ValueWrapper* wrapper = ExtractValueWrapper(aValue);
  if (!wrapper) {
    return eCSSProperty_UNKNOWN;
  }

  return wrapper->mPropID;
}
