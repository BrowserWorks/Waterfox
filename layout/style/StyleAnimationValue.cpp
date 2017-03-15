/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* Utilities for animation of computed style values */

#include "mozilla/ArrayUtils.h"
#include "mozilla/MathAlgorithms.h"
#include "mozilla/RuleNodeCacheConditions.h"
#include "mozilla/StyleAnimationValue.h"
#include "mozilla/Tuple.h"
#include "mozilla/UniquePtr.h"
#include "nsStyleTransformMatrix.h"
#include "nsAutoPtr.h"
#include "nsCOMArray.h"
#include "nsIStyleRule.h"
#include "mozilla/css/StyleRule.h"
#include "nsString.h"
#include "nsStyleContext.h"
#include "nsStyleSet.h"
#include "nsComputedDOMStyle.h"
#include "nsCSSParser.h"
#include "nsCSSPseudoElements.h"
#include "mozilla/css/Declaration.h"
#include "mozilla/dom/Element.h"
#include "mozilla/FloatingPoint.h"
#include "mozilla/Likely.h"
#include "mozilla/ServoBindings.h" // RawServoDeclarationBlock
#include "gfxMatrix.h"
#include "gfxQuaternion.h"
#include "nsIDocument.h"
#include "nsIFrame.h"
#include "gfx2DGlue.h"

using namespace mozilla;
using namespace mozilla::css;
using namespace mozilla::gfx;
using nsStyleTransformMatrix::Decompose2DMatrix;
using nsStyleTransformMatrix::Decompose3DMatrix;
using nsStyleTransformMatrix::ShearType;

// HELPER METHODS
// --------------
/*
 * Given two units, this method returns a common unit that they can both be
 * converted into, if possible.  This is intended to facilitate
 * interpolation, distance-computation, and addition between "similar" units.
 *
 * The ordering of the arguments should not affect the output of this method.
 *
 * If there's no sensible common unit, this method returns eUnit_Null.
 *
 * @param   aFirstUnit One unit to resolve.
 * @param   aFirstUnit The other unit to resolve.
 * @return  A "common" unit that both source units can be converted into, or
 *          eUnit_Null if that's not possible.
 */
static
StyleAnimationValue::Unit
GetCommonUnit(nsCSSPropertyID aProperty,
              StyleAnimationValue::Unit aFirstUnit,
              StyleAnimationValue::Unit aSecondUnit)
{
  if (aFirstUnit != aSecondUnit) {
    if (nsCSSProps::PropHasFlags(aProperty, CSS_PROPERTY_STORES_CALC) &&
        (aFirstUnit == StyleAnimationValue::eUnit_Coord ||
         aFirstUnit == StyleAnimationValue::eUnit_Percent ||
         aFirstUnit == StyleAnimationValue::eUnit_Calc) &&
        (aSecondUnit == StyleAnimationValue::eUnit_Coord ||
         aSecondUnit == StyleAnimationValue::eUnit_Percent ||
         aSecondUnit == StyleAnimationValue::eUnit_Calc)) {
      // We can use calc() as the common unit.
      return StyleAnimationValue::eUnit_Calc;
    }
    if ((aFirstUnit == StyleAnimationValue::eUnit_Color ||
         aFirstUnit == StyleAnimationValue::eUnit_CurrentColor ||
         aFirstUnit == StyleAnimationValue::eUnit_ComplexColor) &&
        (aSecondUnit == StyleAnimationValue::eUnit_Color ||
         aSecondUnit == StyleAnimationValue::eUnit_CurrentColor ||
         aSecondUnit == StyleAnimationValue::eUnit_ComplexColor)) {
      // We can use complex color as the common unit.
      return StyleAnimationValue::eUnit_ComplexColor;
    }
    return StyleAnimationValue::eUnit_Null;
  }
  return aFirstUnit;
}

static
nsCSSUnit
GetCommonUnit(nsCSSPropertyID aProperty,
              nsCSSUnit aFirstUnit,
              nsCSSUnit aSecondUnit)
{
  if (aFirstUnit != aSecondUnit) {
    if (nsCSSProps::PropHasFlags(aProperty, CSS_PROPERTY_STORES_CALC) &&
        (aFirstUnit == eCSSUnit_Pixel ||
         aFirstUnit == eCSSUnit_Percent ||
         aFirstUnit == eCSSUnit_Calc) &&
        (aSecondUnit == eCSSUnit_Pixel ||
         aSecondUnit == eCSSUnit_Percent ||
         aSecondUnit == eCSSUnit_Calc)) {
      // We can use calc() as the common unit.
      return eCSSUnit_Calc;
    }
    return eCSSUnit_Null;
  }
  return aFirstUnit;
}

static nsCSSKeyword
ToPrimitive(nsCSSKeyword aKeyword)
{
  switch (aKeyword) {
    case eCSSKeyword_translatex:
    case eCSSKeyword_translatey:
    case eCSSKeyword_translatez:
    case eCSSKeyword_translate:
      return eCSSKeyword_translate3d;
    case eCSSKeyword_scalex:
    case eCSSKeyword_scaley:
    case eCSSKeyword_scalez:
    case eCSSKeyword_scale:
      return eCSSKeyword_scale3d;
    default:
      return aKeyword;
  }
}

static bool
TransformFunctionsMatch(nsCSSKeyword func1, nsCSSKeyword func2)
{
  return ToPrimitive(func1) == ToPrimitive(func2);
}

static already_AddRefed<nsCSSValue::Array>
AppendFunction(nsCSSKeyword aTransformFunction)
{
  uint32_t nargs;
  switch (aTransformFunction) {
    case eCSSKeyword_matrix3d:
      nargs = 16;
      break;
    case eCSSKeyword_matrix:
      nargs = 6;
      break;
    case eCSSKeyword_rotate3d:
      nargs = 4;
      break;
    case eCSSKeyword_interpolatematrix:
    case eCSSKeyword_translate3d:
    case eCSSKeyword_scale3d:
      nargs = 3;
      break;
    case eCSSKeyword_translate:
    case eCSSKeyword_skew:
    case eCSSKeyword_scale:
      nargs = 2;
      break;
    default:
      NS_ERROR("must be a transform function");
      MOZ_FALLTHROUGH;
    case eCSSKeyword_translatex:
    case eCSSKeyword_translatey:
    case eCSSKeyword_translatez:
    case eCSSKeyword_scalex:
    case eCSSKeyword_scaley:
    case eCSSKeyword_scalez:
    case eCSSKeyword_skewx:
    case eCSSKeyword_skewy:
    case eCSSKeyword_rotate:
    case eCSSKeyword_rotatex:
    case eCSSKeyword_rotatey:
    case eCSSKeyword_rotatez:
    case eCSSKeyword_perspective:
      nargs = 1;
      break;
  }

  RefPtr<nsCSSValue::Array> arr = nsCSSValue::Array::Create(nargs + 1);
  arr->Item(0).SetIntValue(aTransformFunction, eCSSUnit_Enumerated);

  return arr.forget();
}

static already_AddRefed<nsCSSValue::Array>
ToPrimitive(nsCSSValue::Array* aArray)
{
  nsCSSKeyword tfunc = nsStyleTransformMatrix::TransformFunctionOf(aArray);
  nsCSSKeyword primitive = ToPrimitive(tfunc);
  RefPtr<nsCSSValue::Array> arr = AppendFunction(primitive);

  // FIXME: This would produce fewer calc() expressions if the
  // zero were of compatible type (length vs. percent) when
  // needed.

  nsCSSValue zero(0.0f, eCSSUnit_Pixel);
  nsCSSValue one(1.0f, eCSSUnit_Number);
  switch(tfunc) {
    case eCSSKeyword_translate:
    {
      MOZ_ASSERT(aArray->Count() == 2 || aArray->Count() == 3,
                 "unexpected count");
      arr->Item(1) = aArray->Item(1);
      arr->Item(2) = aArray->Count() == 3 ? aArray->Item(2) : zero;
      arr->Item(3) = zero;
      break;
    }
    case eCSSKeyword_translatex:
    {
      MOZ_ASSERT(aArray->Count() == 2, "unexpected count");
      arr->Item(1) = aArray->Item(1);
      arr->Item(2) = zero;
      arr->Item(3) = zero;
      break;
    }
    case eCSSKeyword_translatey:
    {
      MOZ_ASSERT(aArray->Count() == 2, "unexpected count");
      arr->Item(1) = zero;
      arr->Item(2) = aArray->Item(1);
      arr->Item(3) = zero;
      break;
    }
    case eCSSKeyword_translatez:
    {
      MOZ_ASSERT(aArray->Count() == 2, "unexpected count");
      arr->Item(1) = zero;
      arr->Item(2) = zero;
      arr->Item(3) = aArray->Item(1);
      break;
    }
    case eCSSKeyword_scale:
    {
      MOZ_ASSERT(aArray->Count() == 2 || aArray->Count() == 3,
                 "unexpected count");
      arr->Item(1) = aArray->Item(1);
      arr->Item(2) = aArray->Count() == 3 ? aArray->Item(2) : aArray->Item(1);
      arr->Item(3) = one;
      break;
    }
    case eCSSKeyword_scalex:
    {
      MOZ_ASSERT(aArray->Count() == 2, "unexpected count");
      arr->Item(1) = aArray->Item(1);
      arr->Item(2) = one;
      arr->Item(3) = one;
      break;
    }
    case eCSSKeyword_scaley:
    {
      MOZ_ASSERT(aArray->Count() == 2, "unexpected count");
      arr->Item(1) = one;
      arr->Item(2) = aArray->Item(1);
      arr->Item(3) = one;
      break;
    }
    case eCSSKeyword_scalez:
    {
      MOZ_ASSERT(aArray->Count() == 2, "unexpected count");
      arr->Item(1) = one;
      arr->Item(2) = one;
      arr->Item(3) = aArray->Item(1);
      break;
    }
    default:
      arr = aArray;
  }
  return arr.forget();
}

static void
AppendCSSShadowValue(const nsCSSShadowItem *aShadow,
                     nsCSSValueList **&aResultTail)
{
  MOZ_ASSERT(aShadow, "shadow expected");

  // X, Y, Radius, Spread, Color, Inset
  RefPtr<nsCSSValue::Array> arr = nsCSSValue::Array::Create(6);
  arr->Item(0).SetIntegerCoordValue(aShadow->mXOffset);
  arr->Item(1).SetIntegerCoordValue(aShadow->mYOffset);
  arr->Item(2).SetIntegerCoordValue(aShadow->mRadius);
  // NOTE: This code sometimes stores mSpread: 0 even when
  // the parser would be required to leave it null.
  arr->Item(3).SetIntegerCoordValue(aShadow->mSpread);
  if (aShadow->mHasColor) {
    arr->Item(4).SetColorValue(aShadow->mColor);
  }
  if (aShadow->mInset) {
    arr->Item(5).SetIntValue(uint8_t(StyleBoxShadowType::Inset),
                             eCSSUnit_Enumerated);
  }

  nsCSSValueList *resultItem = new nsCSSValueList;
  resultItem->mValue.SetArrayValue(arr, eCSSUnit_Array);
  *aResultTail = resultItem;
  aResultTail = &resultItem->mNext;
}

// Like nsStyleCoord::CalcValue, but with length in float pixels instead
// of nscoord.
struct PixelCalcValue
{
  float mLength, mPercent;
  bool mHasPercent;
};

// Requires a canonical calc() value that we generated.
static PixelCalcValue
ExtractCalcValueInternal(const nsCSSValue& aValue)
{
  MOZ_ASSERT(aValue.GetUnit() == eCSSUnit_Calc, "unexpected unit");
  nsCSSValue::Array *arr = aValue.GetArrayValue();
  MOZ_ASSERT(arr->Count() == 1, "unexpected length");

  const nsCSSValue &topval = arr->Item(0);
  PixelCalcValue result;
  if (topval.GetUnit() == eCSSUnit_Pixel) {
    result.mLength = topval.GetFloatValue();
    result.mPercent = 0.0f;
    result.mHasPercent = false;
  } else {
    MOZ_ASSERT(topval.GetUnit() == eCSSUnit_Calc_Plus,
               "unexpected unit");
    nsCSSValue::Array *arr2 = topval.GetArrayValue();
    const nsCSSValue &len = arr2->Item(0);
    const nsCSSValue &pct = arr2->Item(1);
    MOZ_ASSERT(len.GetUnit() == eCSSUnit_Pixel, "unexpected unit");
    MOZ_ASSERT(pct.GetUnit() == eCSSUnit_Percent, "unexpected unit");
    result.mLength = len.GetFloatValue();
    result.mPercent = pct.GetPercentValue();
    result.mHasPercent = true;
  }

  return result;
}

// Requires a canonical calc() value that we generated.
static PixelCalcValue
ExtractCalcValue(const StyleAnimationValue& aValue)
{
  PixelCalcValue result;
  if (aValue.GetUnit() == StyleAnimationValue::eUnit_Coord) {
    result.mLength =
      nsPresContext::AppUnitsToFloatCSSPixels(aValue.GetCoordValue());
    result.mPercent = 0.0f;
    result.mHasPercent = false;
    return result;
  }
  if (aValue.GetUnit() == StyleAnimationValue::eUnit_Percent) {
    result.mLength = 0.0f;
    result.mPercent = aValue.GetPercentValue();
    result.mHasPercent = true;
    return result;
  }
  MOZ_ASSERT(aValue.GetUnit() == StyleAnimationValue::eUnit_Calc,
             "unexpected unit");
  nsCSSValue *val = aValue.GetCSSValueValue();
  return ExtractCalcValueInternal(*val);
}

static PixelCalcValue
ExtractCalcValue(const nsCSSValue& aValue)
{
  PixelCalcValue result;
  if (aValue.GetUnit() == eCSSUnit_Pixel) {
    result.mLength = aValue.GetFloatValue();
    result.mPercent = 0.0f;
    result.mHasPercent = false;
    return result;
  }
  if (aValue.GetUnit() == eCSSUnit_Percent) {
    result.mLength = 0.0f;
    result.mPercent = aValue.GetPercentValue();
    result.mHasPercent = true;
    return result;
  }
  return ExtractCalcValueInternal(aValue);
}

static void
CalcValueToCSSValue(const nsStyleCoord::CalcValue* aCalc, nsCSSValue& aValue)
{
  aValue.SetCalcValue(aCalc);
}

static void
CalcValueToCSSValue(const PixelCalcValue& aCalc, nsCSSValue& aValue)
{
  RefPtr<nsCSSValue::Array> arr = nsCSSValue::Array::Create(1);
  if (!aCalc.mHasPercent) {
    arr->Item(0).SetFloatValue(aCalc.mLength, eCSSUnit_Pixel);
  } else {
    nsCSSValue::Array *arr2 = nsCSSValue::Array::Create(2);
    arr->Item(0).SetArrayValue(arr2, eCSSUnit_Calc_Plus);
    arr2->Item(0).SetFloatValue(aCalc.mLength, eCSSUnit_Pixel);
    arr2->Item(1).SetPercentValue(aCalc.mPercent);
  }

  aValue.SetArrayValue(arr, eCSSUnit_Calc);
}

double
CalcPositionSquareDistance(const nsCSSValue& aPos1,
                           const nsCSSValue& aPos2)
{
  NS_ASSERTION(aPos1.GetUnit() == eCSSUnit_Array &&
               aPos2.GetUnit() == eCSSUnit_Array,
               "Expected two arrays");

  PixelCalcValue calcVal[4];

  nsCSSValue::Array* posArray = aPos1.GetArrayValue();
  MOZ_ASSERT(posArray->Count() == 4, "Invalid position value");
  NS_ASSERTION(posArray->Item(0).GetUnit() == eCSSUnit_Null &&
               posArray->Item(2).GetUnit() == eCSSUnit_Null,
               "Invalid list used");
  for (int i = 0; i < 2; ++i) {
    MOZ_ASSERT(posArray->Item(i*2+1).GetUnit() != eCSSUnit_Null,
               "Invalid position value");
    calcVal[i] = ExtractCalcValue(posArray->Item(i*2+1));
  }

  posArray = aPos2.GetArrayValue();
  MOZ_ASSERT(posArray->Count() == 4, "Invalid position value");
  NS_ASSERTION(posArray->Item(0).GetUnit() == eCSSUnit_Null &&
               posArray->Item(2).GetUnit() == eCSSUnit_Null,
               "Invalid list used");
  for (int i = 0; i < 2; ++i) {
    MOZ_ASSERT(posArray->Item(i*2+1).GetUnit() != eCSSUnit_Null,
               "Invalid position value");
    calcVal[i+2] = ExtractCalcValue(posArray->Item(i*2+1));
  }

  double squareDistance = 0.0;
  for (int i = 0; i < 2; ++i) {
    float difflen = calcVal[i+2].mLength - calcVal[i].mLength;
    float diffpct = calcVal[i+2].mPercent - calcVal[i].mPercent;
    squareDistance += difflen * difflen + diffpct * diffpct;
  }

  return squareDistance;
}

static PixelCalcValue
CalcBackgroundCoord(const nsCSSValue& aCoord)
{
  NS_ASSERTION(aCoord.GetUnit() == eCSSUnit_Array,
               "Expected array");

  nsCSSValue::Array* array = aCoord.GetArrayValue();
  MOZ_ASSERT(array->Count() == 2 &&
             array->Item(0).GetUnit() == eCSSUnit_Null &&
             array->Item(1).GetUnit() != eCSSUnit_Null,
             "Invalid position value");
  return ExtractCalcValue(array->Item(1));
}

double
CalcPositionCoordSquareDistance(const nsCSSValue& aPos1,
                                const nsCSSValue& aPos2)
{
  PixelCalcValue calcVal1 = CalcBackgroundCoord(aPos1);
  PixelCalcValue calcVal2 = CalcBackgroundCoord(aPos2);

  float difflen = calcVal2.mLength - calcVal1.mLength;
  float diffpct = calcVal2.mPercent - calcVal1.mPercent;
  return difflen * difflen + diffpct * diffpct;
}

// Ensure that a float/double value isn't NaN by returning zero instead
// (NaN doesn't have a sign) as a general restriction for floating point
// values in RestrictValue.
template<typename T>
MOZ_ALWAYS_INLINE T
EnsureNotNan(T aValue)
{
  return aValue;
}
template<>
MOZ_ALWAYS_INLINE float
EnsureNotNan(float aValue)
{
  // This would benefit from a MOZ_FLOAT_IS_NaN if we had one.
  return MOZ_LIKELY(!mozilla::IsNaN(aValue)) ? aValue : 0;
}
template<>
MOZ_ALWAYS_INLINE double
EnsureNotNan(double aValue)
{
  return MOZ_LIKELY(!mozilla::IsNaN(aValue)) ? aValue : 0;
}

template <typename T>
T
RestrictValue(uint32_t aRestrictions, T aValue)
{
  T result = EnsureNotNan(aValue);
  switch (aRestrictions) {
    case 0:
      break;
    case CSS_PROPERTY_VALUE_NONNEGATIVE:
      if (result < 0) {
        result = 0;
      }
      break;
    case CSS_PROPERTY_VALUE_AT_LEAST_ONE:
      if (result < 1) {
        result = 1;
      }
      break;
    default:
      MOZ_ASSERT(false, "bad value restriction");
      break;
  }
  return result;
}

template <typename T>
T
RestrictValue(nsCSSPropertyID aProperty, T aValue)
{
  return RestrictValue(nsCSSProps::ValueRestrictions(aProperty), aValue);
}

static void
AddCSSValueAngle(double aCoeff1, const nsCSSValue &aValue1,
                 double aCoeff2, const nsCSSValue &aValue2,
                 nsCSSValue &aResult)
{
  if (aValue1.GetUnit() == aValue2.GetUnit()) {
    // To avoid floating point error, if the units match, maintain the unit.
    aResult.SetFloatValue(
      EnsureNotNan(aCoeff1 * aValue1.GetFloatValue() +
                   aCoeff2 * aValue2.GetFloatValue()),
      aValue1.GetUnit());
  } else {
    aResult.SetFloatValue(
      EnsureNotNan(aCoeff1 * aValue1.GetAngleValueInRadians() +
                   aCoeff2 * aValue2.GetAngleValueInRadians()),
      eCSSUnit_Radian);
  }
}

static inline void
AddCSSValuePercent(double aCoeff1, const nsCSSValue &aValue1,
                   double aCoeff2, const nsCSSValue &aValue2,
                   nsCSSValue &aResult, uint32_t aValueRestrictions = 0)
{
  MOZ_ASSERT(aValue1.GetUnit() == eCSSUnit_Percent, "unexpected unit");
  MOZ_ASSERT(aValue2.GetUnit() == eCSSUnit_Percent, "unexpected unit");
  aResult.SetPercentValue(RestrictValue(aValueRestrictions,
                                        aCoeff1 * aValue1.GetPercentValue() +
                                        aCoeff2 * aValue2.GetPercentValue()));
}

// Add two canonical-form calc values (eUnit_Calc) to make another
// canonical-form calc value.
static void
AddCSSValueCanonicalCalc(double aCoeff1, const nsCSSValue &aValue1,
                         double aCoeff2, const nsCSSValue &aValue2,
                         nsCSSValue &aResult)
{
  PixelCalcValue v1 = ExtractCalcValue(aValue1);
  PixelCalcValue v2 = ExtractCalcValue(aValue2);
  PixelCalcValue result;
  result.mLength = aCoeff1 * v1.mLength + aCoeff2 * v2.mLength;
  result.mPercent = aCoeff1 * v1.mPercent + aCoeff2 * v2.mPercent;
  result.mHasPercent = v1.mHasPercent || v2.mHasPercent;
  MOZ_ASSERT(result.mHasPercent || result.mPercent == 0.0f,
             "can't have a nonzero percentage part without having percentages");
  CalcValueToCSSValue(result, aResult);
}

static inline void
AddCSSValuePixel(double aCoeff1, const nsCSSValue &aValue1,
                 double aCoeff2, const nsCSSValue &aValue2,
                 nsCSSValue &aResult, uint32_t aValueRestrictions = 0)
{
  MOZ_ASSERT(aValue1.GetUnit() == eCSSUnit_Pixel, "unexpected unit");
  MOZ_ASSERT(aValue2.GetUnit() == eCSSUnit_Pixel, "unexpected unit");
  aResult.SetFloatValue(RestrictValue(aValueRestrictions,
                                      aCoeff1 * aValue1.GetFloatValue() +
                                      aCoeff2 * aValue2.GetFloatValue()),
                        eCSSUnit_Pixel);
}

static bool
AddCSSValuePixelPercentCalc(const uint32_t aValueRestrictions,
                            const nsCSSUnit aCommonUnit,
                            double aCoeff1, const nsCSSValue &aValue1,
                            double aCoeff2, const nsCSSValue &aValue2,
                            nsCSSValue &aResult)
{
  switch (aCommonUnit) {
    case eCSSUnit_Pixel:
      AddCSSValuePixel(aCoeff1, aValue1,
                       aCoeff2, aValue2,
                       aResult, aValueRestrictions);
      break;
    case eCSSUnit_Percent:
      AddCSSValuePercent(aCoeff1, aValue1,
                         aCoeff2, aValue2,
                         aResult, aValueRestrictions);
      break;
    case eCSSUnit_Calc:
      AddCSSValueCanonicalCalc(aCoeff1, aValue1,
                               aCoeff2, aValue2,
                               aResult);
      break;
    default:
      return false;
  }

  return true;
}

static void
AddTransformTranslate(double aCoeff1, const nsCSSValue &aValue1,
                      double aCoeff2, const nsCSSValue &aValue2,
                      nsCSSValue &aResult)
{
  // Only three possible units: eCSSUnit_Pixel, eCSSUnit_Percent, or
  // eCSSUnit_Calc.
  MOZ_ASSERT(aValue1.GetUnit() == eCSSUnit_Percent ||
             aValue1.GetUnit() == eCSSUnit_Pixel ||
             aValue1.IsCalcUnit(),
             "unexpected unit");
  MOZ_ASSERT(aValue2.GetUnit() == eCSSUnit_Percent ||
             aValue2.GetUnit() == eCSSUnit_Pixel ||
             aValue2.IsCalcUnit(),
             "unexpected unit");
  AddCSSValuePixelPercentCalc(0,
                              (aValue1.GetUnit() != aValue2.GetUnit() ||
                               aValue1.IsCalcUnit())
                                ? eCSSUnit_Calc
                                : aValue1.GetUnit(),
                              aCoeff1, aValue1,
                              aCoeff2, aValue2,
                              aResult);
}

// CLASS METHODS
// -------------

static RGBAColorData
ExtractColor(const nsCSSValue& aValue)
{
  MOZ_ASSERT(aValue.IsNumericColorUnit(), "The unit should be color");
  // PercentageRGBColor and PercentageRGBAColor component value might be
  // greater than 1.0 in case when the color value is accumulated, so we
  // can't use nsCSSValue::GetColorValue() here because that function
  // clamps its values.
  if (aValue.GetUnit() == eCSSUnit_PercentageRGBColor ||
      aValue.GetUnit() == eCSSUnit_PercentageRGBAColor) {
    nsCSSValueFloatColor* floatColor = aValue.GetFloatColorValue();
    return {
      floatColor->Comp1(),
      floatColor->Comp2(),
      floatColor->Comp3(),
      floatColor->Alpha()
    };
  }
  return RGBAColorData(aValue.GetColorValue());
}

static RGBAColorData
ExtractColor(const StyleAnimationValue& aValue)
{
  MOZ_ASSERT(aValue.GetUnit() == StyleAnimationValue::eUnit_Color);
  nsCSSValue* value = aValue.GetCSSValueValue();
  MOZ_ASSERT(value, "CSS value must be valid");
  return ExtractColor(*value);
}

static ComplexColorData
ExtractComplexColor(const StyleAnimationValue& aValue)
{
  switch (aValue.GetUnit()) {
    case StyleAnimationValue::eUnit_Color:
      return ComplexColorData(ExtractColor(aValue), 0.0f);
    case StyleAnimationValue::eUnit_CurrentColor:
      return ComplexColorData({0, 0, 0, 0}, 1.0f);
    case StyleAnimationValue::eUnit_ComplexColor:
      return ComplexColorData(aValue.GetComplexColorData());
    default:
      MOZ_ASSERT_UNREACHABLE("Unknown unit");
      return ComplexColorData({0, 0, 0, 0}, 0.0f);
  }
}

double
StyleAnimationValue::ComputeColorDistance(const RGBAColorData& aStartColor,
                                          const RGBAColorData& aEndColor)
{
  // http://www.w3.org/TR/smil-animation/#animateColorElement says
  // that we should use Euclidean RGB cube distance.  However, we
  // have to extend that to RGBA.  For now, we'll just use the
  // Euclidean distance in the (part of the) 4-cube of premultiplied
  // colors.
  double startA = aStartColor.mA;
  double startR = aStartColor.mR * startA;
  double startG = aStartColor.mG * startA;
  double startB = aStartColor.mB * startA;
  double endA = aEndColor.mA;
  double endR = aEndColor.mR * endA;
  double endG = aEndColor.mG * endA;
  double endB = aEndColor.mB * endA;

  double diffA = startA - endA;
  double diffR = startR - endR;
  double diffG = startG - endG;
  double diffB = startB - endB;
  return sqrt(diffA * diffA + diffR * diffR + diffG * diffG + diffB * diffB);
}

enum class Restrictions {
  Enable,
  Disable
};

static already_AddRefed<nsCSSValue::Array>
AddShapeFunction(nsCSSPropertyID aProperty,
                 double aCoeff1, const nsCSSValue::Array* aArray1,
                 double aCoeff2, const nsCSSValue::Array* aArray2,
                 Restrictions aRestriction = Restrictions::Enable);

static double
ComputeShapeDistance(nsCSSPropertyID aProperty,
                     const nsCSSValue::Array* aArray1,
                     const nsCSSValue::Array* aArray2)
{
  // Use AddShapeFunction to get the difference between two shape functions.
  RefPtr<nsCSSValue::Array> diffShape =
    AddShapeFunction(aProperty, 1.0, aArray2, -1.0, aArray1,
                     Restrictions::Disable);
  if (!diffShape) {
    return 0.0;
  }

  // A helper function to convert a calc() diff value into a double distance.
  auto pixelCalcDistance = [](const PixelCalcValue& aValue) {
    MOZ_ASSERT(aValue.mHasPercent || aValue.mPercent == 0.0f,
             "can't have a nonzero percentage part without having percentages");
    return aValue.mLength * aValue.mLength + aValue.mPercent * aValue.mPercent;
  };

  double squareDistance = 0.0;
  const nsCSSValue::Array* func = diffShape->Item(0).GetArrayValue();
  nsCSSKeyword shapeFuncName = func->Item(0).GetKeywordValue();
  switch (shapeFuncName) {
    case eCSSKeyword_ellipse:
    case eCSSKeyword_circle: {
      // Skip the first element which is the function keyword.
      // Also, skip the last element which is an array for <position>
      const size_t len = func->Count();
      for (size_t i = 1; i < len - 1; ++i) {
        squareDistance += pixelCalcDistance(ExtractCalcValue(func->Item(i)));
      }
      // Only iterate over elements 1 and 3. The <position> is 'uncomputed' to
      // only those elements.  See also the comment in SetPositionValue.
      for (size_t i = 1; i < 4; i += 2) {
        const nsCSSValue& value = func->Item(len - 1).GetArrayValue()->Item(i);
        squareDistance += pixelCalcDistance(ExtractCalcValue(value));
      }
      break;
    }
    case eCSSKeyword_polygon: {
      // Don't care about the first element which is the function keyword, and
      // the second element which is the fill rule.
      const nsCSSValuePairList* list = func->Item(2).GetPairListValue();
      do {
        squareDistance += pixelCalcDistance(ExtractCalcValue(list->mXValue)) +
                          pixelCalcDistance(ExtractCalcValue(list->mYValue));
        list = list->mNext;
      } while (list);
      break;
    }
    case eCSSKeyword_inset: {
      // Items 1-4 are respectively the top, right, bottom and left offsets
      // from the reference box.
      for (size_t i = 1; i <= 4; ++i) {
        const nsCSSValue& value = func->Item(i);
        squareDistance += pixelCalcDistance(ExtractCalcValue(value));
      }
      // Item 5 contains the radii of the rounded corners for the inset
      // rectangle.
      const nsCSSValue::Array* array = func->Item(5).GetArrayValue();
      const size_t len = array->Count();
      for (size_t i = 0; i < len; ++i) {
        const nsCSSValuePair& pair = array->Item(i).GetPairValue();
        squareDistance += pixelCalcDistance(ExtractCalcValue(pair.mXValue)) +
                          pixelCalcDistance(ExtractCalcValue(pair.mYValue));
      }
      break;
    }
    default:
      MOZ_ASSERT_UNREACHABLE("Unknown shape type");
  }
  return sqrt(squareDistance);
}

static nsCSSValueList*
AddTransformLists(double aCoeff1, const nsCSSValueList* aList1,
                  double aCoeff2, const nsCSSValueList* aList2);

static double
ComputeTransform2DMatrixDistance(const Matrix& aMatrix1,
                                 const Matrix& aMatrix2)
{
  Point3D scale1(1, 1, 1);
  Point3D translate1;
  gfxQuaternion rotate1;
  nsStyleTransformMatrix::ShearArray shear1{0.0f, 0.0f, 0.0f};
  Decompose2DMatrix(aMatrix1, scale1, shear1, rotate1, translate1);

  Point3D scale2(1, 1, 1);
  Point3D translate2;
  gfxQuaternion rotate2;
  nsStyleTransformMatrix::ShearArray shear2{0.0f, 0.0f, 0.0f};
  Decompose2DMatrix(aMatrix2, scale2, shear2, rotate2, translate2);

  // Note:
  // 1. Shear factor is the tangent value of shear angle, so we need to
  //    call atan() to get the angle. For 2D transform, we only have XYSHEAR.
  // 2. The quaternion vector of the decomposed 2d matrix is got by
  //    "gfxQuaternion(0, 0, sin(rotate/2), cos(rotate/2))"
  //                         ^^^^^^^^^^^^^  ^^^^^^^^^^^^^
  //                               z              w
  //    Therefore, we can get the rotate angle by 2 * atan2f(z, w).
  //
  //    However, we can also get the rotate angle by the inner product of
  //    two quaternion vectors, just as what we do for eCSSKeyword_rotate3d.
  //    e.g.
  //      rotate3d(0, 0, 1, 60deg)  =>  rotate3d(0, 0, 1, 120deg);
  //      quaternion 1: (0, 0, sin(30deg), cos(30deg)) = (0, 0, 1/2, sqrt(3)/2)
  //      quaternion 2: (0, 0, sin(60deg), cos(60deg)) = (0, 0, sqrt(3)/2, 1/2)
  //      inner product:  sqrt(3)/4 + sqrt(3)/4 = sqrt(3)/2
  //      Finally, the rotate angle: 2 * acos(sqrt(3)/2) = 60deg
  //
  //    I think doing atan() may be faster than doing inner product together
  //    with acos(), so let's adopt atan2f().
  const Point3D diffTranslate = translate2 - translate1;
  const Point3D diffScale = scale2 - scale1;
  const double diffShear = atan(shear2[ShearType::XYSHEAR]) -
                           atan(shear1[ShearType::XYSHEAR]);
  const double diffRotate = 2.0 * (atan2f(rotate2.z, rotate2.w) -
                                   atan2f(rotate1.z, rotate1.w));
  // Returns the sum of squares because we will take a square root in
  // ComputeTransformListDistance.
  return diffTranslate.DotProduct(diffTranslate) +
         diffScale.DotProduct(diffScale) +
         diffRotate * diffRotate +
         diffShear * diffShear;
}

static double
ComputeTransform3DMatrixDistance(const Matrix4x4& aMatrix1,
                                 const Matrix4x4& aMatrix2)
{
  Point3D scale1(1, 1, 1);
  Point3D translate1;
  Point4D perspective1(0, 0, 0, 1);
  gfxQuaternion rotate1;
  nsStyleTransformMatrix::ShearArray shear1{0.0f, 0.0f, 0.0f};
  Decompose3DMatrix(aMatrix1, scale1, shear1, rotate1, translate1,
                    perspective1);

  Point3D scale2(1, 1, 1);
  Point3D translate2;
  Point4D perspective2(0, 0, 0, 1);
  gfxQuaternion rotate2;
  nsStyleTransformMatrix::ShearArray shear2{0.0f, 0.0f, 0.0f};
  Decompose3DMatrix(aMatrix2, scale2, shear2, rotate2, translate2,
                    perspective2);

  // Note:
  // 1. Shear factor is the tangent value of shear angle, so we need to
  //    call atan() to get the angle.
  // 2. We use the same way to get the rotate angle of two quaternion vectors as
  //    what we do for rotate3d.
  const Point3D diffTranslate = translate2 - translate1;
  const Point3D diffScale = scale2 - scale1;
  const Point3D diffShear(atan(shear2[ShearType::XYSHEAR]) -
                            atan(shear1[ShearType::XYSHEAR]),
                          atan(shear2[ShearType::XZSHEAR]) -
                            atan(shear1[ShearType::XZSHEAR]),
                          atan(shear2[ShearType::YZSHEAR]) -
                            atan(shear1[ShearType::YZSHEAR]));
  const Point4D diffPerspective = perspective2 - perspective1;
  const double dot = clamped(rotate1.DotProduct(rotate2), -1.0, 1.0);
  const double diffRotate = 2.0 * acos(dot);
  // Returns the sum of squares because we will take a square root in
  // ComputeTransformListDistance.
  return diffTranslate.DotProduct(diffTranslate) +
         diffScale.DotProduct(diffScale) +
         diffPerspective.DotProduct(diffPerspective) +
         diffShear.DotProduct(diffShear) +
         diffRotate * diffRotate;
}

static double
ComputeTransformDistance(nsCSSValue::Array* aArray1,
                         nsCSSValue::Array* aArray2)
{
  MOZ_ASSERT(aArray1, "aArray1 should be non-null.");
  MOZ_ASSERT(aArray2, "aArray2 should be non-null.");

  // Normalize translate and scale functions to equivalent "translate3d" and
  // "scale3d" functions.
  RefPtr<nsCSSValue::Array> a1 = ToPrimitive(aArray1),
                            a2 = ToPrimitive(aArray2);
  nsCSSKeyword tfunc = nsStyleTransformMatrix::TransformFunctionOf(a1);
  MOZ_ASSERT(nsStyleTransformMatrix::TransformFunctionOf(a2) == tfunc);

  double distance = 0.0;
  switch (tfunc) {
    case eCSSKeyword_translate3d: {
      MOZ_ASSERT(a1->Count() == 4, "unexpected count");
      MOZ_ASSERT(a2->Count() == 4, "unexpected count");

      nsCSSValue x, y, z;
      AddTransformTranslate(1.0, a2->Item(1), -1.0, a1->Item(1), x);
      AddTransformTranslate(1.0, a2->Item(2), -1.0, a1->Item(2), y);
      AddTransformTranslate(1.0, a2->Item(3), -1.0, a1->Item(3), z);
      // Drop percent part because we only compute distance by computed values.
      double c1 = ExtractCalcValue(x).mLength;
      double c2 = ExtractCalcValue(y).mLength;
      double c3 = z.GetFloatValue();
      distance = c1 * c1 + c2 * c2 + c3 * c3;
      break;
    }
    case eCSSKeyword_scale3d: {
      MOZ_ASSERT(a1->Count() == 4, "unexpected count");
      MOZ_ASSERT(a2->Count() == 4, "unexpected count");

      auto ComputeScaleDiff = [](const nsCSSValue& aValue1,
                                 const nsCSSValue& aValue2) {
        float v1 = aValue1.GetFloatValue();
        float v2 = aValue2.GetFloatValue();
        return EnsureNotNan(v2 - v1);
      };

      double c1 = ComputeScaleDiff(a1->Item(1), a2->Item(1));
      double c2 = ComputeScaleDiff(a1->Item(2), a2->Item(2));
      double c3 = ComputeScaleDiff(a1->Item(3), a2->Item(3));
      distance = c1 * c1 + c2 * c2 + c3 * c3;
      break;
    }
    case eCSSKeyword_skew: {
      MOZ_ASSERT(a1->Count() == 2 || a1->Count() == 3, "unexpected count");
      MOZ_ASSERT(a2->Count() == 2 || a2->Count() == 3, "unexpected count");

      const nsCSSValue zero(0.0f, eCSSUnit_Radian);
      nsCSSValue x, y;
      AddCSSValueAngle(1.0, a2->Item(1), -1.0, a1->Item(1), x);
      AddCSSValueAngle(1.0, a2->Count() == 3 ? a2->Item(2) : zero,
                      -1.0, a1->Count() == 3 ? a1->Item(2) : zero,
                       y);
      distance = x.GetAngleValueInRadians() * x.GetAngleValueInRadians() +
                 y.GetAngleValueInRadians() * y.GetAngleValueInRadians();
      break;
    }
    case eCSSKeyword_skewx:
    case eCSSKeyword_skewy:
    case eCSSKeyword_rotate:
    case eCSSKeyword_rotatex:
    case eCSSKeyword_rotatey:
    case eCSSKeyword_rotatez: {
      MOZ_ASSERT(a1->Count() == 2, "unexpected count");
      MOZ_ASSERT(a2->Count() == 2, "unexpected count");

      nsCSSValue angle;
      AddCSSValueAngle(1.0, a2->Item(1), -1.0, a1->Item(1), angle);
      distance = angle.GetAngleValueInRadians() *
                 angle.GetAngleValueInRadians();
      break;
    }
    case eCSSKeyword_rotate3d: {
      MOZ_ASSERT(a1->Count() == 5, "unexpected count");
      MOZ_ASSERT(a2->Count() == 5, "unexpected count");

      Point3D vector1(a1->Item(1).GetFloatValue(),
                      a1->Item(2).GetFloatValue(),
                      a1->Item(3).GetFloatValue());
      vector1.Normalize();
      Point3D vector2(a2->Item(1).GetFloatValue(),
                      a2->Item(2).GetFloatValue(),
                      a2->Item(3).GetFloatValue());
      vector2.Normalize();

      if (vector1 == vector2) {
        // Handle rotate3d with matched (normalized) vectors.
        nsCSSValue angle;
        AddCSSValueAngle(1.0, a2->Item(4), -1.0, a1->Item(4), angle);
        distance = angle.GetAngleValueInRadians() *
                   angle.GetAngleValueInRadians();
      } else {
        // Use quaternion vectors to get the angle difference. Both q1 and q2
        // are unit vectors, so we can get their angle difference by
        // cos(theta/2) = (q1 dot q2) / (|q1| * |q2|) = q1 dot q2.
        gfxQuaternion q1(vector1, a1->Item(4).GetAngleValueInRadians());
        gfxQuaternion q2(vector2, a2->Item(4).GetAngleValueInRadians());
        distance = 2.0 * acos(clamped(q1.DotProduct(q2), -1.0, 1.0));
        distance = distance * distance;
      }
      break;
    }
    case eCSSKeyword_perspective: {
      MOZ_ASSERT(a1->Count() == 2, "unexpected count");
      MOZ_ASSERT(a2->Count() == 2, "unexpected count");

      // We convert a perspective function into an equivalent matrix3d, and
      // then do matrix decomposition to get the distance.
      // Why don't we just subtract one perspective depth from the other?
      // I think it's better to follow the logic of our interpolation,
      // which does linear interpolation between two decomposed perspective
      // vectors.
      // e.g.
      // Do interpolation between perspective(100px) and perspective(1000px).
      //   1) Convert them into matrix3d, and then do matrix decomposition:
      //      perspective vector 1: perspective(0, 0, -1/100, 1);
      //      perspective vector 2: perspective(0, 0, -1/1000, 1);
      //   2) Do linear interpolation between these two vectors.
      // Therefore, we use the same rule to get the distance as what we do for
      // matrix3d.

      using nsStyleTransformMatrix::ApplyPerspectiveToMatrix;
      Matrix4x4 m1;
      ApplyPerspectiveToMatrix(m1, a1->Item(1).GetFloatValue());
      Matrix4x4 m2;
      ApplyPerspectiveToMatrix(m2, a2->Item(1).GetFloatValue());

      distance = ComputeTransform3DMatrixDistance(m1, m2);
      break;
    }
    case eCSSKeyword_matrix: {
      MOZ_ASSERT(a1->Count() == 7, "unexpected count");
      MOZ_ASSERT(a2->Count() == 7, "unexpected count");

      distance = ComputeTransform2DMatrixDistance(
        nsStyleTransformMatrix::CSSValueArrayTo2DMatrix(a1),
        nsStyleTransformMatrix::CSSValueArrayTo2DMatrix(a2));
      break;
    }
    case eCSSKeyword_matrix3d: {
      MOZ_ASSERT(a1->Count() == 17, "unexpected count");
      MOZ_ASSERT(a2->Count() == 17, "unexpected count");

      distance = ComputeTransform3DMatrixDistance(
        nsStyleTransformMatrix::CSSValueArrayTo3DMatrix(a1),
        nsStyleTransformMatrix::CSSValueArrayTo3DMatrix(a2));
      break;
    }
    case eCSSKeyword_interpolatematrix:
    default:
      MOZ_ASSERT_UNREACHABLE("Unsupported transform function");
      break;
  }
  return distance;
}

static double
ComputeTransformListDistance(const nsCSSValueList* aList1,
                             const nsCSSValueList* aList2)
{
  MOZ_ASSERT(aList1, "aList1 should be non-null.");
  MOZ_ASSERT(aList2, "aList2 should be non-null.");

  double distance = 0.0;
  do {
    distance += ComputeTransformDistance(aList1->mValue.GetArrayValue(),
                                         aList2->mValue.GetArrayValue());
    aList1 = aList1->mNext;
    aList2 = aList2->mNext;
    MOZ_ASSERT(!aList1 == !aList2,
               "aList1 and aList2 should have the same length.");
  } while (aList1);
  return sqrt(distance);
}

static double
ComputeMismatchedTransfromListDistance(const nsCSSValueList* aList1,
                                       const nsCSSValueList* aList2,
                                       nsStyleContext* aStyleContext)
{
  // We need nsStyleContext and nsPresContext to compute calc() values while
  // processing the translate part of transforms.
  if (!aStyleContext) {
    return 0.0;
  }

  RuleNodeCacheConditions dontCare;
  bool dontCareBool;
  nsStyleTransformMatrix::TransformReferenceBox emptyRefBox;

  Matrix4x4 m1 = nsStyleTransformMatrix::ReadTransforms(
                   aList1,
                   aStyleContext,
                   aStyleContext->PresContext(),
                   dontCare,
                   emptyRefBox,
                   nsPresContext::AppUnitsPerCSSPixel(),
                   &dontCareBool);
  Matrix4x4 m2 = nsStyleTransformMatrix::ReadTransforms(
                   aList2,
                   aStyleContext,
                   aStyleContext->PresContext(),
                   dontCare,
                   emptyRefBox,
                   nsPresContext::AppUnitsPerCSSPixel(),
                   &dontCareBool);
  return sqrt(ComputeTransform3DMatrixDistance(m1, m2));
}

bool
StyleAnimationValue::ComputeDistance(nsCSSPropertyID aProperty,
                                     const StyleAnimationValue& aStartValue,
                                     const StyleAnimationValue& aEndValue,
                                     nsStyleContext* aStyleContext,
                                     double& aDistance)
{
  Unit commonUnit =
    GetCommonUnit(aProperty, aStartValue.GetUnit(), aEndValue.GetUnit());

  switch (commonUnit) {
    case eUnit_Null:
    case eUnit_Auto:
    case eUnit_None:
    case eUnit_Normal:
    case eUnit_UnparsedString:
    case eUnit_URL:
    case eUnit_DiscreteCSSValue:
      return false;

    case eUnit_Enumerated:
      switch (aProperty) {
        case eCSSProperty_font_stretch: {
          // just like eUnit_Integer.
          int32_t startInt = aStartValue.GetIntValue();
          int32_t endInt = aEndValue.GetIntValue();
          aDistance = Abs(endInt - startInt);
          return true;
        }
        default:
          return false;
      }
   case eUnit_Visibility: {
      int32_t startEnum = aStartValue.GetIntValue();
      int32_t endEnum = aEndValue.GetIntValue();
      if (startEnum == endEnum) {
        aDistance = 0;
        return true;
      }
      if ((startEnum == NS_STYLE_VISIBILITY_VISIBLE) ==
          (endEnum == NS_STYLE_VISIBILITY_VISIBLE)) {
        return false;
      }
      aDistance = 1;
      return true;
    }
    case eUnit_Integer: {
      int32_t startInt = aStartValue.GetIntValue();
      int32_t endInt = aEndValue.GetIntValue();
      aDistance = Abs(double(endInt) - double(startInt));
      return true;
    }
    case eUnit_Coord: {
      nscoord startCoord = aStartValue.GetCoordValue();
      nscoord endCoord = aEndValue.GetCoordValue();
      aDistance = Abs(double(endCoord) - double(startCoord));
      return true;
    }
    case eUnit_Percent: {
      float startPct = aStartValue.GetPercentValue();
      float endPct = aEndValue.GetPercentValue();
      aDistance = Abs(double(endPct) - double(startPct));
      return true;
    }
    case eUnit_Float: {
      float startFloat = aStartValue.GetFloatValue();
      float endFloat = aEndValue.GetFloatValue();
      aDistance = Abs(double(endFloat) - double(startFloat));
      return true;
    }
    case eUnit_Color: {
      aDistance = ComputeColorDistance(ExtractColor(aStartValue),
                                       ExtractColor(aEndValue));
      return true;
    }
    case eUnit_CurrentColor: {
      aDistance = 0;
      return true;
    }
    case eUnit_ComplexColor: {
      ComplexColorData color1 = ExtractComplexColor(aStartValue);
      ComplexColorData color2 = ExtractComplexColor(aEndValue);
      // Common case is interpolating between a color and a currentcolor
      if (color1.IsNumericColor() && color2.IsCurrentColor()) {
        double dist = ComputeColorDistance(color1.mColor, NS_RGBA(0, 0, 0, 0));
        aDistance = sqrt(dist * dist + 1);
        return true;
      }
      if (color1.IsCurrentColor() && color2.IsNumericColor()) {
        double dist = ComputeColorDistance(NS_RGBA(0, 0, 0, 0), color2.mColor);
        aDistance = sqrt(dist * dist + 1);
        return true;
      }
      // If we ever reach here, we may want to use the code in
      // bug 1299741 comment 79 to compute it.
      MOZ_ASSERT_UNREACHABLE("We shouldn't get here as we only call "
                             "ComputeDistance on pre-interpolation values");
      aDistance = 0.0;
      return true;
    }
    case eUnit_Calc: {
      PixelCalcValue v1 = ExtractCalcValue(aStartValue);
      PixelCalcValue v2 = ExtractCalcValue(aEndValue);
      float difflen = v2.mLength - v1.mLength;
      float diffpct = v2.mPercent - v1.mPercent;
      aDistance = sqrt(difflen * difflen + diffpct * diffpct);
      return true;
    }
    case eUnit_ObjectPosition: {
      const nsCSSValue* position1 = aStartValue.GetCSSValueValue();
      const nsCSSValue* position2 = aEndValue.GetCSSValueValue();
      double squareDistance =
        CalcPositionSquareDistance(*position1,
                                   *position2);
      aDistance = sqrt(squareDistance);
      return true;
    }
    case eUnit_CSSValuePair: {
      const nsCSSValuePair *pair1 = aStartValue.GetCSSValuePairValue();
      const nsCSSValuePair *pair2 = aEndValue.GetCSSValuePairValue();
      nsCSSUnit unit[2];
      unit[0] = GetCommonUnit(aProperty, pair1->mXValue.GetUnit(),
                              pair2->mXValue.GetUnit());
      unit[1] = GetCommonUnit(aProperty, pair1->mYValue.GetUnit(),
                              pair2->mYValue.GetUnit());
      if (unit[0] == eCSSUnit_Null || unit[1] == eCSSUnit_Null ||
          unit[0] == eCSSUnit_URL || unit[0] == eCSSUnit_Enumerated) {
        return false;
      }

      double squareDistance = 0.0;
      static nsCSSValue nsCSSValuePair::* const pairValues[2] = {
        &nsCSSValuePair::mXValue, &nsCSSValuePair::mYValue
      };
      for (uint32_t i = 0; i < 2; ++i) {
        nsCSSValue nsCSSValuePair::*member = pairValues[i];
        double diffsquared;
        switch (unit[i]) {
          case eCSSUnit_Pixel: {
            float diff = (pair1->*member).GetFloatValue() -
                         (pair2->*member).GetFloatValue();
            diffsquared = diff * diff;
            break;
          }
          case eCSSUnit_Percent: {
            float diff = (pair1->*member).GetPercentValue() -
                         (pair2->*member).GetPercentValue();
            diffsquared = diff * diff;
            break;
          }
          case eCSSUnit_Calc: {
            PixelCalcValue v1 = ExtractCalcValue(pair1->*member);
            PixelCalcValue v2 = ExtractCalcValue(pair2->*member);
            float difflen = v2.mLength - v1.mLength;
            float diffpct = v2.mPercent - v1.mPercent;
            diffsquared = difflen * difflen + diffpct * diffpct;
            break;
          }
          default:
            MOZ_ASSERT(false, "unexpected unit");
            return false;
        }
        squareDistance += diffsquared;
      }

      aDistance = sqrt(squareDistance);
      return true;
    }
    case eUnit_CSSValueTriplet: {
      const nsCSSValueTriplet *triplet1 = aStartValue.GetCSSValueTripletValue();
      const nsCSSValueTriplet *triplet2 = aEndValue.GetCSSValueTripletValue();
      nsCSSUnit unit[3];
      unit[0] = GetCommonUnit(aProperty, triplet1->mXValue.GetUnit(),
                              triplet2->mXValue.GetUnit());
      unit[1] = GetCommonUnit(aProperty, triplet1->mYValue.GetUnit(),
                              triplet2->mYValue.GetUnit());
      unit[2] = GetCommonUnit(aProperty, triplet1->mZValue.GetUnit(),
                              triplet2->mZValue.GetUnit());
      if (unit[0] == eCSSUnit_Null || unit[1] == eCSSUnit_Null ||
          unit[2] == eCSSUnit_Null) {
        return false;
      }

      double squareDistance = 0.0;
      static nsCSSValue nsCSSValueTriplet::* const pairValues[3] = {
        &nsCSSValueTriplet::mXValue, &nsCSSValueTriplet::mYValue, &nsCSSValueTriplet::mZValue
      };
      for (uint32_t i = 0; i < 3; ++i) {
        nsCSSValue nsCSSValueTriplet::*member = pairValues[i];
        double diffsquared;
        switch (unit[i]) {
          case eCSSUnit_Pixel: {
            float diff = (triplet1->*member).GetFloatValue() -
                         (triplet2->*member).GetFloatValue();
            diffsquared = diff * diff;
            break;
          }
          case eCSSUnit_Percent: {
            float diff = (triplet1->*member).GetPercentValue() -
                         (triplet2->*member).GetPercentValue();
             diffsquared = diff * diff;
             break;
          }
          case eCSSUnit_Calc: {
            PixelCalcValue v1 = ExtractCalcValue(triplet1->*member);
            PixelCalcValue v2 = ExtractCalcValue(triplet2->*member);
            float difflen = v2.mLength - v1.mLength;
            float diffpct = v2.mPercent - v1.mPercent;
            diffsquared = difflen * difflen + diffpct * diffpct;
            break;
          }
          case eCSSUnit_Null:
            diffsquared = 0;
            break;
          default:
            MOZ_ASSERT(false, "unexpected unit");
            return false;
        }
        squareDistance += diffsquared;
      }

      aDistance = sqrt(squareDistance);
      return true;
    }
    case eUnit_CSSRect: {
      const nsCSSRect *rect1 = aStartValue.GetCSSRectValue();
      const nsCSSRect *rect2 = aEndValue.GetCSSRectValue();
      if (rect1->mTop.GetUnit() != rect2->mTop.GetUnit() ||
          rect1->mRight.GetUnit() != rect2->mRight.GetUnit() ||
          rect1->mBottom.GetUnit() != rect2->mBottom.GetUnit() ||
          rect1->mLeft.GetUnit() != rect2->mLeft.GetUnit()) {
        // At least until we have calc()
        return false;
      }

      double squareDistance = 0.0;
      for (uint32_t i = 0; i < ArrayLength(nsCSSRect::sides); ++i) {
        nsCSSValue nsCSSRect::*member = nsCSSRect::sides[i];
        MOZ_ASSERT((rect1->*member).GetUnit() == (rect2->*member).GetUnit(),
                   "should have returned above");
        double diff;
        switch ((rect1->*member).GetUnit()) {
          case eCSSUnit_Pixel:
            diff = (rect1->*member).GetFloatValue() -
                   (rect2->*member).GetFloatValue();
            break;
          case eCSSUnit_Auto:
            diff = 0;
            break;
          default:
            MOZ_ASSERT(false, "unexpected unit");
            return false;
        }
        squareDistance += diff * diff;
      }

      aDistance = sqrt(squareDistance);
      return true;
    }
    case eUnit_Dasharray: {
      // NOTE: This produces results on substantially different scales
      // for length values and percentage values, which might even be
      // mixed in the same property value.  This means the result isn't
      // particularly useful for paced animation.

      // Call AddWeighted to make us lists of the same length.
      StyleAnimationValue normValue1, normValue2;
      if (!AddWeighted(aProperty, 1.0, aStartValue, 0.0, aEndValue,
                       normValue1) ||
          !AddWeighted(aProperty, 0.0, aStartValue, 1.0, aEndValue,
                       normValue2)) {
        return false;
      }

      double squareDistance = 0.0;
      const nsCSSValueList *list1 = normValue1.GetCSSValueListValue();
      const nsCSSValueList *list2 = normValue2.GetCSSValueListValue();

      MOZ_ASSERT(!list1 == !list2, "lists should be same length");
      while (list1) {
        const nsCSSValue &val1 = list1->mValue;
        const nsCSSValue &val2 = list2->mValue;

        MOZ_ASSERT(val1.GetUnit() == val2.GetUnit(),
                   "unit match should be assured by AddWeighted");
        double diff;
        switch (val1.GetUnit()) {
          case eCSSUnit_Percent:
            diff = val1.GetPercentValue() - val2.GetPercentValue();
            break;
          case eCSSUnit_Number:
            diff = val1.GetFloatValue() - val2.GetFloatValue();
            break;
          default:
            MOZ_ASSERT(false, "unexpected unit");
            return false;
        }
        squareDistance += diff * diff;

        list1 = list1->mNext;
        list2 = list2->mNext;
        MOZ_ASSERT(!list1 == !list2, "lists should be same length");
      }

      aDistance = sqrt(squareDistance);
      return true;
    }
    case eUnit_Shadow: {
      // Call AddWeighted to make us lists of the same length.
      StyleAnimationValue normValue1, normValue2;
      if (!AddWeighted(aProperty, 1.0, aStartValue, 0.0, aEndValue,
                       normValue1) ||
          !AddWeighted(aProperty, 0.0, aStartValue, 1.0, aEndValue,
                       normValue2)) {
        return false;
      }

      const nsCSSValueList *shadow1 = normValue1.GetCSSValueListValue();
      const nsCSSValueList *shadow2 = normValue2.GetCSSValueListValue();

      double squareDistance = 0.0;
      MOZ_ASSERT(!shadow1 == !shadow2, "lists should be same length");
      while (shadow1) {
        nsCSSValue::Array *array1 = shadow1->mValue.GetArrayValue();
        nsCSSValue::Array *array2 = shadow2->mValue.GetArrayValue();
        for (size_t i = 0; i < 4; ++i) {
          MOZ_ASSERT(array1->Item(i).GetUnit() == eCSSUnit_Pixel,
                     "unexpected unit");
          MOZ_ASSERT(array2->Item(i).GetUnit() == eCSSUnit_Pixel,
                     "unexpected unit");
          double diff = array1->Item(i).GetFloatValue() -
                        array2->Item(i).GetFloatValue();
          squareDistance += diff * diff;
        }

        const nsCSSValue &color1 = array1->Item(4);
        const nsCSSValue &color2 = array2->Item(4);
#ifdef DEBUG
        {
          const nsCSSValue &inset1 = array1->Item(5);
          const nsCSSValue &inset2 = array2->Item(5);
          // There are only two possible states of the inset value:
          //  (1) GetUnit() == eCSSUnit_Null
          //  (2) GetUnit() == eCSSUnit_Enumerated &&
          //      GetIntValue() == NS_STYLE_BOX_SHADOW_INSET
          MOZ_ASSERT(((color1.IsNumericColorUnit() &&
                       color2.IsNumericColorUnit()) ||
                      (color1.GetUnit() == color2.GetUnit())) &&
                     inset1 == inset2,
                     "AddWeighted should have failed");
        }
#endif

        if (color1.GetUnit() != eCSSUnit_Null) {
          double colorDistance = ComputeColorDistance(color1.GetColorValue(),
                                                      color2.GetColorValue());
          squareDistance += colorDistance * colorDistance;
        }

        shadow1 = shadow1->mNext;
        shadow2 = shadow2->mNext;
        MOZ_ASSERT(!shadow1 == !shadow2, "lists should be same length");
      }
      aDistance = sqrt(squareDistance);
      return true;
    }
    case eUnit_Shape:
      aDistance = ComputeShapeDistance(aProperty,
                                       aStartValue.GetCSSValueArrayValue(),
                                       aEndValue.GetCSSValueArrayValue());
      return true;

    case eUnit_Filter:
      // Bug 1286151: Support paced animations for filter function
      // interpolation.
      return false;

    case eUnit_Transform: {
      // FIXME: We don't have an official spec to define the distance of
      // two transform lists, but paced spacing (defined in Web Animations API)
      // needs this, so we implement this according to the concept of the
      // interpolation of two transform lists.
      // Issue: https://www.w3.org/TR/web-animations-1/#issue-789f9fd1

      const nsCSSValueList* list1 =
        aStartValue.GetCSSValueSharedListValue()->mHead;
      const nsCSSValueList* list2 =
        aEndValue.GetCSSValueSharedListValue()->mHead;
      MOZ_ASSERT(list1);
      MOZ_ASSERT(list2);

      if (list1->mValue.GetUnit() == eCSSUnit_None &&
          list2->mValue.GetUnit() == eCSSUnit_None) {
        // Both none, nothing happens.
        aDistance = 0.0;
      } else if (list1->mValue.GetUnit() == eCSSUnit_None) {
        nsAutoPtr<nsCSSValueList> none(AddTransformLists(0, list2, 0, list2));
        aDistance = ComputeTransformListDistance(none, list2);
      } else if (list2->mValue.GetUnit() == eCSSUnit_None) {
        nsAutoPtr<nsCSSValueList> none(AddTransformLists(0, list1, 0, list1));
        aDistance = ComputeTransformListDistance(list1, none);
      } else {
        const nsCSSValueList *item1 = list1, *item2 = list2;
        do {
          nsCSSKeyword func1 = nsStyleTransformMatrix::TransformFunctionOf(
            item1->mValue.GetArrayValue());
          nsCSSKeyword func2 = nsStyleTransformMatrix::TransformFunctionOf(
            item2->mValue.GetArrayValue());
          if (!TransformFunctionsMatch(func1, func2)) {
            break;
          }

          item1 = item1->mNext;
          item2 = item2->mNext;
        } while (item1 && item2);

        if (item1 || item2) {
          // Either the transform function types don't match or
          // the lengths don't match.
          aDistance =
            ComputeMismatchedTransfromListDistance(list1, list2, aStyleContext);
        } else {
          aDistance = ComputeTransformListDistance(list1, list2);
        }
      }
      return true;
    }
    case eUnit_BackgroundPositionCoord: {
      const nsCSSValueList *position1 = aStartValue.GetCSSValueListValue();
      const nsCSSValueList *position2 = aEndValue.GetCSSValueListValue();

      double squareDistance = 0.0;
      MOZ_ASSERT(!position1 == !position2, "lists should be same length");

      while (position1 && position2) {
        squareDistance += CalcPositionCoordSquareDistance(position1->mValue,
                                                          position2->mValue);
        position1 = position1->mNext;
        position2 = position2->mNext;
      }
      // fail if lists differ in length.
      if (position1 || position2) {
        return false;
      }

      aDistance = sqrt(squareDistance);
      return true;
    }
    case eUnit_CSSValuePairList: {
      const nsCSSValuePairList *list1 = aStartValue.GetCSSValuePairListValue();
      const nsCSSValuePairList *list2 = aEndValue.GetCSSValuePairListValue();
      double squareDistance = 0.0;
      do {
        static nsCSSValue nsCSSValuePairList::* const pairListValues[] = {
          &nsCSSValuePairList::mXValue,
          &nsCSSValuePairList::mYValue,
        };
        for (uint32_t i = 0; i < ArrayLength(pairListValues); ++i) {
          const nsCSSValue &v1 = list1->*(pairListValues[i]);
          const nsCSSValue &v2 = list2->*(pairListValues[i]);
          nsCSSUnit unit =
            GetCommonUnit(aProperty, v1.GetUnit(), v2.GetUnit());
          if (unit == eCSSUnit_Null) {
            return false;
          }
          double diffsquared = 0.0;
          switch (unit) {
            case eCSSUnit_Pixel: {
              float diff = v1.GetFloatValue() - v2.GetFloatValue();
              diffsquared = diff * diff;
              break;
            }
            case eCSSUnit_Percent: {
              float diff = v1.GetPercentValue() - v2.GetPercentValue();
              diffsquared = diff * diff;
              break;
            }
            case eCSSUnit_Calc: {
              PixelCalcValue val1 = ExtractCalcValue(v1);
              PixelCalcValue val2 = ExtractCalcValue(v2);
              float difflen = val2.mLength - val1.mLength;
              float diffpct = val2.mPercent - val1.mPercent;
              diffsquared = difflen * difflen + diffpct * diffpct;
              break;
            }
            default:
              if (v1 != v2) {
                return false;
              }
              break;
          }
          squareDistance += diffsquared;
        }
        list1 = list1->mNext;
        list2 = list2->mNext;
      } while (list1 && list2);
      if (list1 || list2) {
        // We can't interpolate lists of different lengths.
        return false;
      }
      aDistance = sqrt(squareDistance);
      return true;
    }
  }

  MOZ_ASSERT(false, "Can't compute distance using the given common unit");
  return false;
}

static inline void
AddCSSValueNumber(double aCoeff1, const nsCSSValue &aValue1,
                  double aCoeff2, const nsCSSValue &aValue2,
                  nsCSSValue &aResult, uint32_t aValueRestrictions = 0)
{
  MOZ_ASSERT(aValue1.GetUnit() == eCSSUnit_Number, "unexpected unit");
  MOZ_ASSERT(aValue2.GetUnit() == eCSSUnit_Number, "unexpected unit");
  aResult.SetFloatValue(RestrictValue(aValueRestrictions,
                                      aCoeff1 * aValue1.GetFloatValue() +
                                      aCoeff2 * aValue2.GetFloatValue()),
                        eCSSUnit_Number);
}

static inline float
GetNumberOrPercent(const nsCSSValue &aValue)
{
  nsCSSUnit unit = aValue.GetUnit();
  MOZ_ASSERT(unit == eCSSUnit_Number || unit == eCSSUnit_Percent,
             "unexpected unit");
  return (unit == eCSSUnit_Number) ?
    aValue.GetFloatValue() : aValue.GetPercentValue();
}

static inline void
AddCSSValuePercentNumber(const uint32_t aValueRestrictions,
                         double aCoeff1, const nsCSSValue &aValue1,
                         double aCoeff2, const nsCSSValue &aValue2,
                         nsCSSValue &aResult, float aInitialVal)
{
  float n1 = GetNumberOrPercent(aValue1);
  float n2 = GetNumberOrPercent(aValue2);

  // Rather than interpolating aValue1 and aValue2 directly, we
  // interpolate their *distances from aInitialVal* (the initial value,
  // which is either 1 or 0 for "filter" functions).  This matters in
  // cases where aInitialVal is nonzero and the coefficients don't add
  // up to 1.  For example, if initialVal is 1, aCoeff1 is 0.5, and
  // aCoeff2 is 0, then we'll return the value halfway between 1 and
  // aValue1, rather than the value halfway between 0 and aValue1.
  // Note that we do something similar in AddTransformScale().
  float result = (n1 - aInitialVal) * aCoeff1 + (n2 - aInitialVal) * aCoeff2;
  aResult.SetFloatValue(RestrictValue(aValueRestrictions, result + aInitialVal),
                        eCSSUnit_Number);
}

enum class ColorAdditionType {
  Clamped, // Clamp each color channel after adding.
  Unclamped // Do not clamp color channels after adding.
};

// Unclamped AddWeightedColors.
static RGBAColorData
AddWeightedColors(double aCoeff1, const RGBAColorData& aValue1,
                  double aCoeff2, const RGBAColorData& aValue2)
{
  float factor1 = aValue1.mA * aCoeff1;
  float factor2 = aValue2.mA * aCoeff2;
  float resultA = factor1 + factor2;
  if (resultA <= 0.0) {
    return {0, 0, 0, 0};
  }

  if (resultA > 1.0) {
    resultA = 1.0;
  }

  float resultFactor = 1.0f / resultA;
  return RGBAColorData(
    (aValue1.mR * factor1 + aValue2.mR * factor2) * resultFactor,
    (aValue1.mG * factor1 + aValue2.mG * factor2) * resultFactor,
    (aValue1.mB * factor1 + aValue2.mB * factor2) * resultFactor,
    resultA);
}

// Multiplies |aValue| color by |aDilutionRation|.
static nscolor
DiluteColor(const RGBAColorData& aValue, double aDilutionRatio)
{
  MOZ_ASSERT(aDilutionRatio >= 0.0 && aDilutionRatio <= 1.0,
             "Dilution ratio should be in [0, 1]");
  float resultA = aValue.mA * aDilutionRatio;
  return resultA <= 0.0 ? NS_RGBA(0, 0, 0, 0)
                        : aValue.WithAlpha(resultA).ToColor();
}

// Clamped AddWeightedColors.
static nscolor
AddWeightedColorsAndClamp(double aCoeff1, const RGBAColorData& aValue1,
                          double aCoeff2, const RGBAColorData& aValue2)
{
  // We are using AddWeighted() with a zero aCoeff2 for colors to
  // pretend AddWeighted() against transparent color, i.e. rgba(0, 0, 0, 0).
  // But unpremultiplication in AddWeightedColors() does not work well
  // for such cases, so we use another function named DiluteColor() which
  // has a similar logic to AddWeightedColors().
  return aCoeff2 == 0.0
    ? DiluteColor(aValue1, aCoeff1)
    : AddWeightedColors(aCoeff1, aValue1, aCoeff2, aValue2).ToColor();
}

void
AppendToCSSValueList(UniquePtr<nsCSSValueList>& aHead,
                     UniquePtr<nsCSSValueList>&& aValueToAppend,
                     nsCSSValueList** aTail)
{
  MOZ_ASSERT(!aHead == !*aTail,
             "Can't have head w/o tail, & vice versa");

  if (!aHead) {
    aHead = Move(aValueToAppend);
    *aTail = aHead.get();
  } else {
    (*aTail) = (*aTail)->mNext = aValueToAppend.release();
  }
}

static UniquePtr<nsCSSValueList>
AddWeightedShadowItems(double aCoeff1, const nsCSSValue &aValue1,
                       double aCoeff2, const nsCSSValue &aValue2,
                       ColorAdditionType aColorAdditionType)
{
  // X, Y, Radius, Spread, Color, Inset
  MOZ_ASSERT(aValue1.GetUnit() == eCSSUnit_Array,
             "wrong unit");
  MOZ_ASSERT(aValue2.GetUnit() == eCSSUnit_Array,
             "wrong unit");
  nsCSSValue::Array *array1 = aValue1.GetArrayValue();
  nsCSSValue::Array *array2 = aValue2.GetArrayValue();
  RefPtr<nsCSSValue::Array> resultArray = nsCSSValue::Array::Create(6);

  for (size_t i = 0; i < 4; ++i) {
    AddCSSValuePixel(aCoeff1, array1->Item(i), aCoeff2, array2->Item(i),
                     resultArray->Item(i),
                     // blur radius must be nonnegative
                     (i == 2) ? CSS_PROPERTY_VALUE_NONNEGATIVE : 0);
  }

  const nsCSSValue& colorValue1 = array1->Item(4);
  const nsCSSValue& colorValue2 = array2->Item(4);
  const nsCSSValue& inset1 = array1->Item(5);
  const nsCSSValue& inset2 = array2->Item(5);
  if ((colorValue1.GetUnit() != colorValue2.GetUnit() &&
       (!colorValue1.IsNumericColorUnit() ||
        !colorValue2.IsNumericColorUnit())) ||
      inset1.GetUnit() != inset2.GetUnit()) {
    // We don't know how to animate between color and no-color, or
    // between inset and not-inset.
    // NOTE: In case when both colors' units are eCSSUnit_Null, that means
    // neither color value was specified, so we can interpolate.
    return nullptr;
  }

  if (colorValue1.GetUnit() != eCSSUnit_Null) {
    RGBAColorData color1 = ExtractColor(colorValue1);
    RGBAColorData color2 = ExtractColor(colorValue2);
    if (aColorAdditionType == ColorAdditionType::Clamped) {
      resultArray->Item(4).SetColorValue(
        AddWeightedColorsAndClamp(aCoeff1, color1, aCoeff2, color2));
    } else {
      resultArray->Item(4).SetRGBAColorValue(
        AddWeightedColors(aCoeff1, color1, aCoeff2, color2));
    }
  }

  MOZ_ASSERT(inset1 == inset2, "should match");
  resultArray->Item(5) = inset1;

  auto resultItem = MakeUnique<nsCSSValueList>();
  resultItem->mValue.SetArrayValue(resultArray, eCSSUnit_Array);
  return resultItem;
}

static void
AddTransformScale(double aCoeff1, const nsCSSValue &aValue1,
                  double aCoeff2, const nsCSSValue &aValue2,
                  nsCSSValue &aResult)
{
  // Handle scale, and the two matrix components where identity is 1, by
  // subtracting 1, multiplying by the coefficients, and then adding 1
  // back.  This gets the right AddWeighted behavior and gets us the
  // interpolation-against-identity behavior for free.
  MOZ_ASSERT(aValue1.GetUnit() == eCSSUnit_Number, "unexpected unit");
  MOZ_ASSERT(aValue2.GetUnit() == eCSSUnit_Number, "unexpected unit");

  float v1 = aValue1.GetFloatValue() - 1.0f,
        v2 = aValue2.GetFloatValue() - 1.0f;
  float result = v1 * aCoeff1 + v2 * aCoeff2;
  aResult.SetFloatValue(EnsureNotNan(result + 1.0f), eCSSUnit_Number);
}

/* static */ already_AddRefed<nsCSSValue::Array>
StyleAnimationValue::AppendTransformFunction(nsCSSKeyword aTransformFunction,
                                             nsCSSValueList**& aListTail)
{
  RefPtr<nsCSSValue::Array> arr = AppendFunction(aTransformFunction);
  nsCSSValueList *item = new nsCSSValueList;
  item->mValue.SetArrayValue(arr, eCSSUnit_Function);

  *aListTail = item;
  aListTail = &item->mNext;

  return arr.forget();
}

template<typename T>
T InterpolateNumerically(const T& aOne, const T& aTwo, double aCoeff)
{
  return aOne + (aTwo - aOne) * aCoeff;
}


/* static */ Matrix4x4
StyleAnimationValue::InterpolateTransformMatrix(const Matrix4x4 &aMatrix1,
                                                const Matrix4x4 &aMatrix2,
                                                double aProgress)
{
  // Decompose both matrices

  // TODO: What do we do if one of these returns false (singular matrix)
  Point3D scale1(1, 1, 1), translate1;
  Point4D perspective1(0, 0, 0, 1);
  gfxQuaternion rotate1;
  nsStyleTransformMatrix::ShearArray shear1{0.0f, 0.0f, 0.0f};

  Point3D scale2(1, 1, 1), translate2;
  Point4D perspective2(0, 0, 0, 1);
  gfxQuaternion rotate2;
  nsStyleTransformMatrix::ShearArray shear2{0.0f, 0.0f, 0.0f};

  Matrix matrix2d1, matrix2d2;
  if (aMatrix1.Is2D(&matrix2d1) && aMatrix2.Is2D(&matrix2d2)) {
    Decompose2DMatrix(matrix2d1, scale1, shear1, rotate1, translate1);
    Decompose2DMatrix(matrix2d2, scale2, shear2, rotate2, translate2);
  } else {
    Decompose3DMatrix(aMatrix1, scale1, shear1,
                      rotate1, translate1, perspective1);
    Decompose3DMatrix(aMatrix2, scale2, shear2,
                      rotate2, translate2, perspective2);
  }

  // Interpolate each of the pieces
  Matrix4x4 result;

  Point4D perspective =
    InterpolateNumerically(perspective1, perspective2, aProgress);
  result.SetTransposedVector(3, perspective);

  Point3D translate =
    InterpolateNumerically(translate1, translate2, aProgress);
  result.PreTranslate(translate.x, translate.y, translate.z);

  gfxQuaternion q3 = rotate1.Slerp(rotate2, aProgress);
  Matrix4x4 rotate = q3.ToMatrix();
  if (!rotate.IsIdentity()) {
      result = rotate * result;
  }

  // TODO: Would it be better to interpolate these as angles?
  //       How do we convert back to angles?
  float yzshear =
    InterpolateNumerically(shear1[ShearType::YZSHEAR],
                           shear2[ShearType::YZSHEAR],
                           aProgress);
  if (yzshear != 0.0) {
    result.SkewYZ(yzshear);
  }

  float xzshear =
    InterpolateNumerically(shear1[ShearType::XZSHEAR],
                           shear2[ShearType::XZSHEAR],
                           aProgress);
  if (xzshear != 0.0) {
    result.SkewXZ(xzshear);
  }

  float xyshear =
    InterpolateNumerically(shear1[ShearType::XYSHEAR],
                           shear2[ShearType::XYSHEAR],
                           aProgress);
  if (xyshear != 0.0) {
    result.SkewXY(xyshear);
  }

  Point3D scale =
    InterpolateNumerically(scale1, scale2, aProgress);
  if (scale != Point3D(1.0, 1.0, 1.0)) {
    result.PreScale(scale.x, scale.y, scale.z);
  }

  return result;
}

static nsCSSValueList*
AddDifferentTransformLists(double aCoeff1, const nsCSSValueList* aList1,
                           double aCoeff2, const nsCSSValueList* aList2)
{
  nsAutoPtr<nsCSSValueList> result;
  nsCSSValueList **resultTail = getter_Transfers(result);

  RefPtr<nsCSSValue::Array> arr;
  arr =
    StyleAnimationValue::AppendTransformFunction(eCSSKeyword_interpolatematrix,
                                                 resultTail);

  // FIXME: We should change the other transform code to also only
  // take a single progress value, as having values that don't
  // sum to 1 doesn't make sense for these.
  if (aList1 == aList2) {
    arr->Item(1).Reset();
  } else {
    aList1->CloneInto(arr->Item(1).SetListValue());
  }

  aList2->CloneInto(arr->Item(2).SetListValue());
  arr->Item(3).SetPercentValue(aCoeff2);

  return result.forget();
}

static UniquePtr<nsCSSValueList>
AddWeightedFilterFunctionImpl(double aCoeff1, const nsCSSValueList* aList1,
                              double aCoeff2, const nsCSSValueList* aList2,
                              ColorAdditionType aColorAdditionType)
{
  // AddWeightedFilterFunction should be our only caller, and it should ensure
  // that both args are non-null.
  MOZ_ASSERT(aList1, "expected filter list");
  MOZ_ASSERT(aList2, "expected filter list");
  MOZ_ASSERT(aList1->mValue.GetUnit() == eCSSUnit_Function,
             "expected function");
  MOZ_ASSERT(aList2->mValue.GetUnit() == eCSSUnit_Function,
             "expected function");
  RefPtr<nsCSSValue::Array> a1 = aList1->mValue.GetArrayValue(),
                              a2 = aList2->mValue.GetArrayValue();
  nsCSSKeyword filterFunction = a1->Item(0).GetKeywordValue();
  if (filterFunction != a2->Item(0).GetKeywordValue()) {
    return nullptr; // Can't add two filters of different types.
  }

  auto resultList = MakeUnique<nsCSSValueList>();
  nsCSSValue::Array* result =
    resultList->mValue.InitFunction(filterFunction, 1);

  // "hue-rotate" is the only filter-function that accepts negative values, and
  // we don't use this "restrictions" variable in its clause below.
  const uint32_t restrictions = CSS_PROPERTY_VALUE_NONNEGATIVE;
  const nsCSSValue& funcArg1 = a1->Item(1);
  const nsCSSValue& funcArg2 = a2->Item(1);
  nsCSSValue& resultArg = result->Item(1);
  float initialVal = 1.0f;
  switch (filterFunction) {
    case eCSSKeyword_blur: {
      nsCSSUnit unit;
      if (funcArg1.GetUnit() == funcArg2.GetUnit()) {
        unit = funcArg1.GetUnit();
      } else {
        // If units differ, we'll just combine them with calc().
        unit = eCSSUnit_Calc;
      }
      if (!AddCSSValuePixelPercentCalc(restrictions,
                                       unit,
                                       aCoeff1, funcArg1,
                                       aCoeff2, funcArg2,
                                       resultArg)) {
        return nullptr;
      }
      break;
    }
    case eCSSKeyword_grayscale:
    case eCSSKeyword_invert:
    case eCSSKeyword_sepia:
      initialVal = 0.0f;
      MOZ_FALLTHROUGH;
    case eCSSKeyword_brightness:
    case eCSSKeyword_contrast:
    case eCSSKeyword_opacity:
    case eCSSKeyword_saturate:
      AddCSSValuePercentNumber(restrictions,
                               aCoeff1, funcArg1,
                               aCoeff2, funcArg2,
                               resultArg,
                               initialVal);
      break;
    case eCSSKeyword_hue_rotate:
      AddCSSValueAngle(aCoeff1, funcArg1,
                       aCoeff2, funcArg2,
                       resultArg);
      break;
    case eCSSKeyword_drop_shadow: {
      MOZ_ASSERT(!funcArg1.GetListValue()->mNext &&
                 !funcArg2.GetListValue()->mNext,
                 "drop-shadow filter func doesn't support lists");
      UniquePtr<nsCSSValueList> shadowValue =
        AddWeightedShadowItems(aCoeff1,
                               funcArg1.GetListValue()->mValue,
                               aCoeff2,
                               funcArg2.GetListValue()->mValue,
                               aColorAdditionType);
      if (!shadowValue) {
        return nullptr;
      }
      resultArg.AdoptListValue(Move(shadowValue));
      break;
    }
    default:
      MOZ_ASSERT(false, "unknown filter function");
      return nullptr;
  }

  return resultList;
}

static UniquePtr<nsCSSValueList>
AddWeightedFilterFunction(double aCoeff1, const nsCSSValueList* aList1,
                          double aCoeff2, const nsCSSValueList* aList2,
                          ColorAdditionType aColorAdditionType)
{
  MOZ_ASSERT(aList1 || aList2,
             "one function list item must not be null");
  // Note that one of our arguments could be null, indicating that
  // it's the initial value. Rather than adding special null-handling
  // logic, we just check for null values and replace them with
  // 0 * the other value. That way, AddWeightedFilterFunctionImpl can assume
  // its args are non-null.
  if (!aList1) {
    return AddWeightedFilterFunctionImpl(aCoeff2, aList2, 0, aList2,
                                         aColorAdditionType);
  }
  if (!aList2) {
    return AddWeightedFilterFunctionImpl(aCoeff1, aList1, 0, aList1,
                                         aColorAdditionType);
  }

  return AddWeightedFilterFunctionImpl(aCoeff1, aList1, aCoeff2, aList2,
                                       aColorAdditionType);
}

static inline uint32_t
ShapeArgumentCount(nsCSSKeyword aShapeFunction)
{
  switch (aShapeFunction) {
    case eCSSKeyword_circle:
      return 2; // radius and center point
    case eCSSKeyword_polygon:
      return 2; // fill rule and a list of points
    case eCSSKeyword_ellipse:
      return 3; // two radii and center point
    case eCSSKeyword_inset:
      return 5; // four edge offsets and a list of corner radii
    default:
      MOZ_ASSERT_UNREACHABLE("Unknown shape type");
      return 0;
  }
}

static void
AddPositions(double aCoeff1, const nsCSSValue& aPos1,
             double aCoeff2, const nsCSSValue& aPos2,
             nsCSSValue& aResultPos)
{
  MOZ_ASSERT(aPos1.GetUnit() == eCSSUnit_Array &&
             aPos2.GetUnit() == eCSSUnit_Array,
             "Args should be CSS <position>s, encoded as arrays");

  const nsCSSValue::Array* posArray1 = aPos1.GetArrayValue();
  const nsCSSValue::Array* posArray2 = aPos2.GetArrayValue();
  MOZ_ASSERT(posArray1->Count() == 4 && posArray2->Count() == 4,
             "CSSParserImpl::ParsePositionValue creates an array of length "
             "4 - how did we get here?");

  nsCSSValue::Array* resultPosArray = nsCSSValue::Array::Create(4);
  aResultPos.SetArrayValue(resultPosArray, eCSSUnit_Array);

  // Only iterate over elements 1 and 3.  The <position> is 'uncomputed' to
  // only those elements.  See also the comment in SetPositionValue.
  for (size_t i = 1; i < 4; i += 2) {
    const nsCSSValue& v1 = posArray1->Item(i);
    const nsCSSValue& v2 = posArray2->Item(i);
    nsCSSValue& vr = resultPosArray->Item(i);
    AddCSSValueCanonicalCalc(aCoeff1, v1,
                             aCoeff2, v2, vr);
  }
}

static Maybe<nsCSSValuePair>
AddCSSValuePair(nsCSSPropertyID aProperty, uint32_t aRestrictions,
                double aCoeff1, const nsCSSValuePair* aPair1,
                double aCoeff2, const nsCSSValuePair* aPair2)
{
  MOZ_ASSERT(aPair1, "expected pair");
  MOZ_ASSERT(aPair2, "expected pair");

  Maybe<nsCSSValuePair> result;
  nsCSSUnit unit[2];
  unit[0] = GetCommonUnit(aProperty, aPair1->mXValue.GetUnit(),
                          aPair2->mXValue.GetUnit());
  unit[1] = GetCommonUnit(aProperty, aPair1->mYValue.GetUnit(),
                          aPair2->mYValue.GetUnit());
  if (unit[0] == eCSSUnit_Null || unit[1] == eCSSUnit_Null ||
      unit[0] == eCSSUnit_URL || unit[0] == eCSSUnit_Enumerated) {
    return result; // Nothing() (returning |result| for RVO)
  }

  result.emplace();

  static nsCSSValue nsCSSValuePair::* const pairValues[2] = {
    &nsCSSValuePair::mXValue, &nsCSSValuePair::mYValue
  };
  for (uint32_t i = 0; i < 2; ++i) {
    nsCSSValue nsCSSValuePair::*member = pairValues[i];
    if (!AddCSSValuePixelPercentCalc(aRestrictions, unit[i],
                                     aCoeff1, aPair1->*member,
                                     aCoeff2, aPair2->*member,
                                     result.ref().*member) ) {
      MOZ_ASSERT(false, "unexpected unit");
      result.reset();
      return result; // Nothing() (returning |result| for RVO)
    }
  }

  return result;
}

static UniquePtr<nsCSSValuePairList>
AddCSSValuePairList(nsCSSPropertyID aProperty,
                    double aCoeff1, const nsCSSValuePairList* aList1,
                    double aCoeff2, const nsCSSValuePairList* aList2)
{
  MOZ_ASSERT(aList1, "Can't add a null list");
  MOZ_ASSERT(aList2, "Can't add a null list");

  auto result = MakeUnique<nsCSSValuePairList>();
  nsCSSValuePairList* resultPtr = result.get();

  do {
    static nsCSSValue nsCSSValuePairList::* const pairListValues[] = {
      &nsCSSValuePairList::mXValue,
      &nsCSSValuePairList::mYValue,
    };
    uint32_t restrictions = nsCSSProps::ValueRestrictions(aProperty);
    for (uint32_t i = 0; i < ArrayLength(pairListValues); ++i) {
      const nsCSSValue& v1 = aList1->*(pairListValues[i]);
      const nsCSSValue& v2 = aList2->*(pairListValues[i]);

      nsCSSValue& vr = resultPtr->*(pairListValues[i]);
      nsCSSUnit unit =
        GetCommonUnit(aProperty, v1.GetUnit(), v2.GetUnit());
      if (unit == eCSSUnit_Null) {
        return nullptr;
      }
      if (!AddCSSValuePixelPercentCalc(restrictions, unit,
                                       aCoeff1, v1,
                                       aCoeff2, v2, vr)) {
        if (v1 != v2) {
          return nullptr;
        }
        vr = v1;
      }
    }
    aList1 = aList1->mNext;
    aList2 = aList2->mNext;
    if (!aList1 || !aList2) {
      break;
    }
    resultPtr->mNext = new nsCSSValuePairList;
    resultPtr = resultPtr->mNext;
  } while (aList1 && aList2);

  if (aList1 || aList2) {
    return nullptr; // We can't interpolate lists of different lengths
  }

  return result;
}

static already_AddRefed<nsCSSValue::Array>
AddShapeFunction(nsCSSPropertyID aProperty,
                 double aCoeff1, const nsCSSValue::Array* aArray1,
                 double aCoeff2, const nsCSSValue::Array* aArray2,
                 Restrictions aRestriction)
{
  MOZ_ASSERT(aArray1 && aArray1->Count() == 2, "expected shape function");
  MOZ_ASSERT(aArray2 && aArray2->Count() == 2, "expected shape function");
  MOZ_ASSERT(aArray1->Item(0).GetUnit() == eCSSUnit_Function,
             "expected function");
  MOZ_ASSERT(aArray2->Item(0).GetUnit() == eCSSUnit_Function,
             "expected function");
  MOZ_ASSERT(aArray1->Item(1).GetUnit() == eCSSUnit_Enumerated,
             "expected geometry-box");
  MOZ_ASSERT(aArray2->Item(1).GetUnit() == eCSSUnit_Enumerated,
             "expected geometry-box");

  if (aArray1->Item(1).GetIntValue() != aArray2->Item(1).GetIntValue()) {
    return nullptr; // Both shapes must use the same reference box.
  }

  const nsCSSValue::Array* func1 = aArray1->Item(0).GetArrayValue();
  const nsCSSValue::Array* func2 = aArray2->Item(0).GetArrayValue();
  nsCSSKeyword shapeFuncName = func1->Item(0).GetKeywordValue();
  if (shapeFuncName != func2->Item(0).GetKeywordValue()) {
    return nullptr; // Can't add two shapes of different types.
  }

  RefPtr<nsCSSValue::Array> result = nsCSSValue::Array::Create(2);

  nsCSSValue::Array* resultFuncArgs =
    result->Item(0).InitFunction(shapeFuncName,
                                 ShapeArgumentCount(shapeFuncName));
  switch (shapeFuncName) {
    case eCSSKeyword_ellipse:
      // Add ellipses' |ry| values (but fail if we encounter an enum):
      if (!AddCSSValuePixelPercentCalc(aRestriction == Restrictions::Enable
                                         ? CSS_PROPERTY_VALUE_NONNEGATIVE
                                         : 0,
                                       GetCommonUnit(aProperty,
                                                     func1->Item(2).GetUnit(),
                                                     func2->Item(2).GetUnit()),
                                       aCoeff1, func1->Item(2),
                                       aCoeff2, func2->Item(2),
                                       resultFuncArgs->Item(2))) {
        return nullptr;
      }
      MOZ_FALLTHROUGH;  // to handle rx and center point
    case eCSSKeyword_circle: {
      // Add circles' |r| (or ellipses' |rx|) values:
      if (!AddCSSValuePixelPercentCalc(aRestriction == Restrictions::Enable
                                         ? CSS_PROPERTY_VALUE_NONNEGATIVE
                                         : 0,
                                       GetCommonUnit(aProperty,
                                                     func1->Item(1).GetUnit(),
                                                     func2->Item(1).GetUnit()),
                                       aCoeff1, func1->Item(1),
                                       aCoeff2, func2->Item(1),
                                       resultFuncArgs->Item(1))) {
        return nullptr;
      }
      // Add center points (defined as a <position>).
      size_t posIndex = shapeFuncName == eCSSKeyword_circle ? 2 : 3;
      AddPositions(aCoeff1, func1->Item(posIndex),
                   aCoeff2, func2->Item(posIndex),
                   resultFuncArgs->Item(posIndex));
      break;
    }
    case eCSSKeyword_polygon: {
      // Add polygons' corresponding points (if the fill rule matches):
      int32_t fillRule = func1->Item(1).GetIntValue();
      if (fillRule != func2->Item(1).GetIntValue()) {
        return nullptr; // can't interpolate between different fill rules
      }
      resultFuncArgs->Item(1).SetIntValue(fillRule, eCSSUnit_Enumerated);

      const nsCSSValuePairList* points1 = func1->Item(2).GetPairListValue();
      const nsCSSValuePairList* points2 = func2->Item(2).GetPairListValue();
      UniquePtr<nsCSSValuePairList> resultPoints =
        AddCSSValuePairList(aProperty, aCoeff1, points1, aCoeff2, points2);
      if (!resultPoints) {
        return nullptr;
      }
      resultFuncArgs->Item(2).AdoptPairListValue(Move(resultPoints));
      break;
    }
    case eCSSKeyword_inset: {
      MOZ_ASSERT(func1->Count() == 6 && func2->Count() == 6,
                 "Update for CSSParserImpl::ParseInsetFunction changes");
      // Items 1-4 are respectively the top, right, bottom and left offsets
      // from the reference box.
      for (size_t i = 1; i <= 4; ++i) {
        if (!AddCSSValuePixelPercentCalc(aRestriction == Restrictions::Enable
                                           ? CSS_PROPERTY_VALUE_NONNEGATIVE
                                           : 0,
                                         GetCommonUnit(aProperty,
                                                       func1->Item(i).GetUnit(),
                                                       func2->Item(i).GetUnit()),
                                         aCoeff1, func1->Item(i),
                                         aCoeff2, func2->Item(i),
                                         resultFuncArgs->Item(i))) {
          return nullptr;
        }
      }
      // Item 5 contains the radii of the rounded corners for the inset
      // rectangle.
      MOZ_ASSERT(func1->Item(5).GetUnit() == eCSSUnit_Array &&
                 func2->Item(5).GetUnit() == eCSSUnit_Array,
                 "Expected two arrays");
      const nsCSSValue::Array* radii1 = func1->Item(5).GetArrayValue();
      const nsCSSValue::Array* radii2 = func2->Item(5).GetArrayValue();
      MOZ_ASSERT(radii1->Count() == 4 && radii2->Count() == 4);
      nsCSSValue::Array* resultRadii = nsCSSValue::Array::Create(4);
      resultFuncArgs->Item(5).SetArrayValue(resultRadii, eCSSUnit_Array);
      // We use an arbitrary border-radius property here to get the appropriate
      // restrictions for radii since this is a <border-radius> value.
      uint32_t restrictions =
        aRestriction == Restrictions::Enable
          ? nsCSSProps::ValueRestrictions(eCSSProperty_border_top_left_radius)
          : 0;
      for (size_t i = 0; i < 4; ++i) {
        const nsCSSValuePair& pair1 = radii1->Item(i).GetPairValue();
        const nsCSSValuePair& pair2 = radii2->Item(i).GetPairValue();
        const Maybe<nsCSSValuePair> pairResult =
          AddCSSValuePair(aProperty, restrictions,
                          aCoeff1, &pair1,
                          aCoeff2, &pair2);
        if (!pairResult) {
          return nullptr;
        }
        resultRadii->Item(i).SetPairValue(pairResult.ptr());
      }
      break;
    }
    default:
      MOZ_ASSERT_UNREACHABLE("Unknown shape type");
      return nullptr;
  }

  // set the geometry-box value
  result->Item(1).SetIntValue(aArray1->Item(1).GetIntValue(),
                              eCSSUnit_Enumerated);

  return result.forget();
}

static nsCSSValueList*
AddTransformLists(double aCoeff1, const nsCSSValueList* aList1,
                  double aCoeff2, const nsCSSValueList* aList2)
{
  nsAutoPtr<nsCSSValueList> result;
  nsCSSValueList **resultTail = getter_Transfers(result);

  do {
    RefPtr<nsCSSValue::Array> a1 = ToPrimitive(aList1->mValue.GetArrayValue()),
                                a2 = ToPrimitive(aList2->mValue.GetArrayValue());
    MOZ_ASSERT(
      TransformFunctionsMatch(nsStyleTransformMatrix::TransformFunctionOf(a1),
                              nsStyleTransformMatrix::TransformFunctionOf(a2)),
      "transform function mismatch");
    MOZ_ASSERT(!*resultTail,
               "resultTail isn't pointing to the tail (may leak)");

    nsCSSKeyword tfunc = nsStyleTransformMatrix::TransformFunctionOf(a1);
    RefPtr<nsCSSValue::Array> arr;
    if (tfunc != eCSSKeyword_matrix &&
        tfunc != eCSSKeyword_matrix3d &&
        tfunc != eCSSKeyword_interpolatematrix &&
        tfunc != eCSSKeyword_rotate3d &&
        tfunc != eCSSKeyword_perspective) {
      arr = StyleAnimationValue::AppendTransformFunction(tfunc, resultTail);
    }

    switch (tfunc) {
      case eCSSKeyword_translate3d: {
          MOZ_ASSERT(a1->Count() == 4, "unexpected count");
          MOZ_ASSERT(a2->Count() == 4, "unexpected count");
          AddTransformTranslate(aCoeff1, a1->Item(1), aCoeff2, a2->Item(1),
                                arr->Item(1));
          AddTransformTranslate(aCoeff1, a1->Item(2), aCoeff2, a2->Item(2),
                                arr->Item(2));
          AddTransformTranslate(aCoeff1, a1->Item(3), aCoeff2, a2->Item(3),
                                arr->Item(3));
          break;
      }
      case eCSSKeyword_scale3d: {
          MOZ_ASSERT(a1->Count() == 4, "unexpected count");
          MOZ_ASSERT(a2->Count() == 4, "unexpected count");

          AddTransformScale(aCoeff1, a1->Item(1), aCoeff2, a2->Item(1),
                            arr->Item(1));
          AddTransformScale(aCoeff1, a1->Item(2), aCoeff2, a2->Item(2),
                            arr->Item(2));
          AddTransformScale(aCoeff1, a1->Item(3), aCoeff2, a2->Item(3),
                            arr->Item(3));

          break;
      }
      // It would probably be nicer to animate skew in tangent space
      // rather than angle space.  However, it's easy to specify
      // skews with infinite tangents, and behavior changes pretty
      // drastically when crossing such skews (since the direction of
      // animation flips), so interop is probably more important here.
      case eCSSKeyword_skew: {
        MOZ_ASSERT(a1->Count() == 2 || a1->Count() == 3,
                   "unexpected count");
        MOZ_ASSERT(a2->Count() == 2 || a2->Count() == 3,
                   "unexpected count");

        nsCSSValue zero(0.0f, eCSSUnit_Radian);
        // Add Y component of skew.
        AddCSSValueAngle(aCoeff1,
                         a1->Count() == 3 ? a1->Item(2) : zero,
                         aCoeff2,
                         a2->Count() == 3 ? a2->Item(2) : zero,
                         arr->Item(2));

        // Add X component of skew (which can be merged with case below
        // in non-DEBUG).
        AddCSSValueAngle(aCoeff1, a1->Item(1), aCoeff2, a2->Item(1),
                         arr->Item(1));

        break;
      }
      case eCSSKeyword_skewx:
      case eCSSKeyword_skewy:
      case eCSSKeyword_rotate:
      case eCSSKeyword_rotatex:
      case eCSSKeyword_rotatey:
      case eCSSKeyword_rotatez: {
        MOZ_ASSERT(a1->Count() == 2, "unexpected count");
        MOZ_ASSERT(a2->Count() == 2, "unexpected count");

        AddCSSValueAngle(aCoeff1, a1->Item(1), aCoeff2, a2->Item(1),
                         arr->Item(1));

        break;
      }
      case eCSSKeyword_rotate3d: {
        Point3D vector1(a1->Item(1).GetFloatValue(),
                        a1->Item(2).GetFloatValue(),
                        a1->Item(3).GetFloatValue());
        vector1.Normalize();
        Point3D vector2(a2->Item(1).GetFloatValue(),
                        a2->Item(2).GetFloatValue(),
                        a2->Item(3).GetFloatValue());
        vector2.Normalize();

        // Handle rotate3d with matched (normalized) vectors,
        // otherwise fallthrough to the next switch statement
        // and do matrix decomposition.
        if (vector1 == vector2) {
          // We skipped appending a transform function above for rotate3d,
          // so do it now.
          arr = StyleAnimationValue::AppendTransformFunction(tfunc, resultTail);
          arr->Item(1).SetFloatValue(vector1.x, eCSSUnit_Number);
          arr->Item(2).SetFloatValue(vector1.y, eCSSUnit_Number);
          arr->Item(3).SetFloatValue(vector1.z, eCSSUnit_Number);

          AddCSSValueAngle(aCoeff1, a1->Item(4), aCoeff2, a2->Item(4),
                           arr->Item(4));
          break;
        }
        MOZ_FALLTHROUGH;
      }
      case eCSSKeyword_matrix:
      case eCSSKeyword_matrix3d:
      case eCSSKeyword_perspective:
        if (aCoeff1 == 0.0 && aCoeff2 == 0.0) {
          // Special case. If both coefficients are 0.0, we should apply an
          // identity transform function.
          arr = StyleAnimationValue::AppendTransformFunction(tfunc, resultTail);

          if (tfunc == eCSSKeyword_rotate3d) {
            arr->Item(1).SetFloatValue(0.0, eCSSUnit_Number);
            arr->Item(2).SetFloatValue(0.0, eCSSUnit_Number);
            arr->Item(3).SetFloatValue(1.0, eCSSUnit_Number);
            arr->Item(4).SetFloatValue(0.0, eCSSUnit_Radian);
          } else if (tfunc == eCSSKeyword_perspective) {
            // The parameter of the identity perspective function is
            // positive infinite.
            arr->Item(1).SetFloatValue(std::numeric_limits<float>::infinity(),
                                       eCSSUnit_Pixel);
          } else {
            nsStyleTransformMatrix::SetIdentityMatrix(arr);
          }
          break;
        }
        MOZ_FALLTHROUGH;
      case eCSSKeyword_interpolatematrix: {
        // FIXME: If the matrix contains only numbers then we could decompose
        // here.

        // Construct temporary lists with only this item in them.
        nsCSSValueList tempList1, tempList2;
        tempList1.mValue = aList1->mValue;
        tempList2.mValue = aList2->mValue;

        if (aList1 == aList2) {
          *resultTail =
            AddDifferentTransformLists(aCoeff1, &tempList1, aCoeff2, &tempList1);
        } else {
          *resultTail =
            AddDifferentTransformLists(aCoeff1, &tempList1, aCoeff2, &tempList2);
        }

        // Now advance resultTail to point to the new tail slot.
        while (*resultTail) {
          resultTail = &(*resultTail)->mNext;
        }

        break;
      }
      default:
        MOZ_ASSERT(false, "unknown transform function");
    }

    aList1 = aList1->mNext;
    aList2 = aList2->mNext;
  } while (aList1);
  MOZ_ASSERT(!aList2, "list length mismatch");
  MOZ_ASSERT(!*resultTail,
             "resultTail isn't pointing to the tail");

  return result.forget();
}

static void
AddPositionCoords(double aCoeff1, const nsCSSValue& aPos1,
                  double aCoeff2, const nsCSSValue& aPos2,
                  nsCSSValue& aResultPos)
{
  const nsCSSValue::Array* posArray1 = aPos1.GetArrayValue();
  const nsCSSValue::Array* posArray2 = aPos2.GetArrayValue();
  nsCSSValue::Array* resultPosArray = nsCSSValue::Array::Create(2);
  aResultPos.SetArrayValue(resultPosArray, eCSSUnit_Array);

  /* Only compute element 1. The <position-coord> is
   * 'uncomputed' to only that element.
   */
  const nsCSSValue& v1 = posArray1->Item(1);
  const nsCSSValue& v2 = posArray2->Item(1);
  nsCSSValue& vr = resultPosArray->Item(1);
  AddCSSValueCanonicalCalc(aCoeff1, v1,
                           aCoeff2, v2, vr);
}

static UniquePtr<nsCSSValueList>
AddWeightedShadowList(double aCoeff1,
                      const nsCSSValueList* aShadow1,
                      double aCoeff2,
                      const nsCSSValueList* aShadow2,
                      ColorAdditionType aColorAdditionType)
{
  // This is implemented according to:
  // http://dev.w3.org/csswg/css3-transitions/#animation-of-property-types-
  // and the third item in the summary of:
  // http://lists.w3.org/Archives/Public/www-style/2009Jul/0050.html
  UniquePtr<nsCSSValueList> result;
  nsCSSValueList* tail = nullptr;
  while (aShadow1 && aShadow2) {
    UniquePtr<nsCSSValueList> shadowValue =
      AddWeightedShadowItems(aCoeff1, aShadow1->mValue,
                             aCoeff2, aShadow2->mValue,
                             aColorAdditionType);
    if (!shadowValue) {
      return nullptr;
    }
    aShadow1 = aShadow1->mNext;
    aShadow2 = aShadow2->mNext;
    AppendToCSSValueList(result, Move(shadowValue), &tail);
  }
  if (aShadow1 || aShadow2) {
    const nsCSSValueList *longShadow;
    double longCoeff;
    if (aShadow1) {
      longShadow = aShadow1;
      longCoeff = aCoeff1;
    } else {
      longShadow = aShadow2;
      longCoeff = aCoeff2;
    }

    while (longShadow) {
      // Passing coefficients that add to less than 1 produces the
      // desired result of interpolating "0 0 0 transparent" with
      // the current shadow.
      UniquePtr<nsCSSValueList> shadowValue =
        AddWeightedShadowItems(longCoeff, longShadow->mValue,
                               0.0, longShadow->mValue,
                               aColorAdditionType);
      if (!shadowValue) {
        return nullptr;
      }

      longShadow = longShadow->mNext;
      AppendToCSSValueList(result, Move(shadowValue), &tail);
    }
  }
  return result;
}

static UniquePtr<nsCSSValueList>
AddWeightedFilterList(double aCoeff1, const nsCSSValueList* aList1,
                      double aCoeff2, const nsCSSValueList* aList2,
                      ColorAdditionType aColorAdditionType)
{
  UniquePtr<nsCSSValueList> result;
  nsCSSValueList* tail = nullptr;
  while (aList1 || aList2) {
    if ((aList1 && aList1->mValue.GetUnit() != eCSSUnit_Function) ||
        (aList2 && aList2->mValue.GetUnit() != eCSSUnit_Function)) {
      // If we don't have filter-functions, we must have filter-URLs, which
      // we can't add or interpolate.
      return nullptr;
    }

    UniquePtr<nsCSSValueList> resultFunction =
      AddWeightedFilterFunction(aCoeff1, aList1, aCoeff2, aList2,
                                aColorAdditionType);
    if (!resultFunction) {
      // filter function mismatch
      return nullptr;
    }

    AppendToCSSValueList(result, Move(resultFunction), &tail);

    // move to next aList items
    if (aList1) {
      aList1 = aList1->mNext;
    }
    if (aList2) {
      aList2 = aList2->mNext;
    }
  }

  return result;
}

bool
StyleAnimationValue::AddWeighted(nsCSSPropertyID aProperty,
                                 double aCoeff1,
                                 const StyleAnimationValue& aValue1,
                                 double aCoeff2,
                                 const StyleAnimationValue& aValue2,
                                 StyleAnimationValue& aResultValue)
{
  Unit commonUnit =
    GetCommonUnit(aProperty, aValue1.GetUnit(), aValue2.GetUnit());
  // Maybe need a followup method to convert the inputs into the common
  // unit-type, if they don't already match it. (Or would it make sense to do
  // that in GetCommonUnit? in which case maybe ConvertToCommonUnit would be
  // better.)

  switch (commonUnit) {
    case eUnit_Null:
    case eUnit_Auto:
    case eUnit_None:
    case eUnit_Normal:
    case eUnit_UnparsedString:
    case eUnit_URL:
    case eUnit_DiscreteCSSValue:
      return false;

    case eUnit_Enumerated:
      switch (aProperty) {
        case eCSSProperty_font_stretch: {
          // Animate just like eUnit_Integer.
          int32_t result = floor(aCoeff1 * double(aValue1.GetIntValue()) +
                                 aCoeff2 * double(aValue2.GetIntValue()));
          if (result < NS_STYLE_FONT_STRETCH_ULTRA_CONDENSED) {
            result = NS_STYLE_FONT_STRETCH_ULTRA_CONDENSED;
          } else if (result > NS_STYLE_FONT_STRETCH_ULTRA_EXPANDED) {
            result = NS_STYLE_FONT_STRETCH_ULTRA_EXPANDED;
          }
          aResultValue.SetIntValue(result, eUnit_Enumerated);
          return true;
        }
        default:
          return false;
      }
    case eUnit_Visibility: {
      int32_t enum1 = aValue1.GetIntValue();
      int32_t enum2 = aValue2.GetIntValue();
      if (enum1 == enum2) {
        aResultValue.SetIntValue(enum1, eUnit_Visibility);
        return true;
      }
      if ((enum1 == NS_STYLE_VISIBILITY_VISIBLE) ==
          (enum2 == NS_STYLE_VISIBILITY_VISIBLE)) {
        return false;
      }
      int32_t val1 = enum1 == NS_STYLE_VISIBILITY_VISIBLE;
      int32_t val2 = enum2 == NS_STYLE_VISIBILITY_VISIBLE;
      double interp = aCoeff1 * val1 + aCoeff2 * val2;
      int32_t result = interp > 0.0 ? NS_STYLE_VISIBILITY_VISIBLE
                                    : (val1 ? enum2 : enum1);
      aResultValue.SetIntValue(result, eUnit_Visibility);
      return true;
    }
    case eUnit_Integer: {
      // http://dev.w3.org/csswg/css3-transitions/#animation-of-property-types-
      // says we should use floor
      int32_t result = floor(aCoeff1 * double(aValue1.GetIntValue()) +
                             aCoeff2 * double(aValue2.GetIntValue()));
      if (aProperty == eCSSProperty_font_weight) {
        if (result < 100) {
          result = 100;
        } else if (result > 900) {
          result = 900;
        }
        result -= result % 100;
      } else {
        result = RestrictValue(aProperty, result);
      }
      aResultValue.SetIntValue(result, eUnit_Integer);
      return true;
    }
    case eUnit_Coord: {
      aResultValue.SetCoordValue(RestrictValue(aProperty, NSToCoordRound(
        aCoeff1 * aValue1.GetCoordValue() +
        aCoeff2 * aValue2.GetCoordValue())));
      return true;
    }
    case eUnit_Percent: {
      aResultValue.SetPercentValue(RestrictValue(aProperty,
        aCoeff1 * aValue1.GetPercentValue() +
        aCoeff2 * aValue2.GetPercentValue()));
      return true;
    }
    case eUnit_Float: {
      aResultValue.SetFloatValue(RestrictValue(aProperty,
        aCoeff1 * aValue1.GetFloatValue() +
        aCoeff2 * aValue2.GetFloatValue()));
      return true;
    }
    case eUnit_Color: {
      RGBAColorData color1 = ExtractColor(aValue1);
      RGBAColorData color2 = ExtractColor(aValue2);
      auto resultColor = MakeUnique<nsCSSValue>();
      resultColor->SetColorValue(
        AddWeightedColorsAndClamp(aCoeff1, color1, aCoeff2, color2));
      aResultValue.SetAndAdoptCSSValueValue(resultColor.release(), eUnit_Color);
      return true;
    }
    case eUnit_CurrentColor: {
      aResultValue.SetCurrentColorValue();
      return true;
    }
    case eUnit_ComplexColor: {
      ComplexColorData color1 = ExtractComplexColor(aValue1);
      ComplexColorData color2 = ExtractComplexColor(aValue2);
      RefPtr<ComplexColorValue> result = new ComplexColorValue;
      // Common case is interpolating between a color and a currentcolor.
      if (color1.IsNumericColor() && color2.IsCurrentColor()) {
        result->mColor = color1.mColor;
        result->mForegroundRatio = aCoeff2;
      } else if (color1.IsCurrentColor() && color2.IsNumericColor()) {
        result->mColor = color2.mColor;
        result->mForegroundRatio = aCoeff1;
      } else {
        float ratio1 = 1.0f - color1.mForegroundRatio;
        float ratio2 = 1.0f - color2.mForegroundRatio;
        float alpha1 = color1.mColor.mA * ratio1;
        float alpha2 = color2.mColor.mA * ratio2;
        RGBAColorData resultColor =
          AddWeightedColors(aCoeff1, color1.mColor.WithAlpha(alpha1),
                            aCoeff2, color2.mColor.WithAlpha(alpha2));
        float resultRatio = color1.mForegroundRatio * aCoeff1 +
                            color2.mForegroundRatio * aCoeff2;
        float resultAlpha = resultColor.mA / (1.0f - resultRatio);
        result->mColor = resultColor.WithAlpha(resultAlpha);
        result->mForegroundRatio = resultRatio;
      }
      aResultValue.SetComplexColorValue(result.forget());
      return true;
    }
    case eUnit_Calc: {
      PixelCalcValue v1 = ExtractCalcValue(aValue1);
      PixelCalcValue v2 = ExtractCalcValue(aValue2);
      double len = aCoeff1 * v1.mLength + aCoeff2 * v2.mLength;
      double pct = aCoeff1 * v1.mPercent + aCoeff2 * v2.mPercent;
      bool hasPct = (aCoeff1 != 0.0 && v1.mHasPercent) ||
                      (aCoeff2 != 0.0 && v2.mHasPercent);
      nsCSSValue *val = new nsCSSValue();
      nsCSSValue::Array *arr = nsCSSValue::Array::Create(1);
      val->SetArrayValue(arr, eCSSUnit_Calc);
      if (hasPct) {
        nsCSSValue::Array *arr2 = nsCSSValue::Array::Create(2);
        arr2->Item(0).SetFloatValue(len, eCSSUnit_Pixel);
        arr2->Item(1).SetPercentValue(pct);
        arr->Item(0).SetArrayValue(arr2, eCSSUnit_Calc_Plus);
      } else {
        arr->Item(0).SetFloatValue(len, eCSSUnit_Pixel);
      }
      aResultValue.SetAndAdoptCSSValueValue(val, eUnit_Calc);
      return true;
    }
    case eUnit_ObjectPosition: {
      const nsCSSValue* position1 = aValue1.GetCSSValueValue();
      const nsCSSValue* position2 = aValue2.GetCSSValueValue();

      nsAutoPtr<nsCSSValue> result(new nsCSSValue);
      AddPositions(aCoeff1, *position1,
                   aCoeff2, *position2, *result);

      aResultValue.SetAndAdoptCSSValueValue(result.forget(),
                                            eUnit_ObjectPosition);
      return true;
    }
    case eUnit_CSSValuePair: {
      uint32_t restrictions = nsCSSProps::ValueRestrictions(aProperty);
      Maybe<nsCSSValuePair> result =
        AddCSSValuePair(aProperty, restrictions,
                        aCoeff1, aValue1.GetCSSValuePairValue(),
                        aCoeff2, aValue2.GetCSSValuePairValue());
      if (!result) {
        return false;
      }

      // We need a heap allocated object to adopt here:
      auto heapResult = MakeUnique<nsCSSValuePair>(*result);
      aResultValue.SetAndAdoptCSSValuePairValue(heapResult.release(),
                                                eUnit_CSSValuePair);
      return true;
    }
    case eUnit_CSSValueTriplet: {
      nsCSSValueTriplet triplet1(*aValue1.GetCSSValueTripletValue());
      nsCSSValueTriplet triplet2(*aValue2.GetCSSValueTripletValue());

      nsCSSUnit unit[3];
      unit[0] = GetCommonUnit(aProperty, triplet1.mXValue.GetUnit(),
                              triplet2.mXValue.GetUnit());
      unit[1] = GetCommonUnit(aProperty, triplet1.mYValue.GetUnit(),
                               triplet2.mYValue.GetUnit());
      unit[2] = GetCommonUnit(aProperty, triplet1.mZValue.GetUnit(),
                              triplet2.mZValue.GetUnit());
      if (unit[0] == eCSSUnit_Null || unit[1] == eCSSUnit_Null ||
          unit[2] == eCSSUnit_Null) {
        return false;
      }

      nsAutoPtr<nsCSSValueTriplet> result(new nsCSSValueTriplet);
      static nsCSSValue nsCSSValueTriplet::* const tripletValues[3] = {
        &nsCSSValueTriplet::mXValue, &nsCSSValueTriplet::mYValue, &nsCSSValueTriplet::mZValue
      };
      uint32_t restrictions = nsCSSProps::ValueRestrictions(aProperty);
      for (uint32_t i = 0; i < 3; ++i) {
        nsCSSValue nsCSSValueTriplet::*member = tripletValues[i];
        if (!AddCSSValuePixelPercentCalc(restrictions, unit[i],
                                         aCoeff1, &triplet1->*member,
                                         aCoeff2, &triplet2->*member,
                                         result->*member) ) {
          MOZ_ASSERT(false, "unexpected unit");
          return false;
        }
      }

      aResultValue.SetAndAdoptCSSValueTripletValue(result.forget(),
                                                   eUnit_CSSValueTriplet);
      return true;
    }
    case eUnit_CSSRect: {
      MOZ_ASSERT(nsCSSProps::ValueRestrictions(aProperty) == 0,
                 "must add code for handling value restrictions");
      const nsCSSRect *rect1 = aValue1.GetCSSRectValue();
      const nsCSSRect *rect2 = aValue2.GetCSSRectValue();
      if (rect1->mTop.GetUnit() != rect2->mTop.GetUnit() ||
          rect1->mRight.GetUnit() != rect2->mRight.GetUnit() ||
          rect1->mBottom.GetUnit() != rect2->mBottom.GetUnit() ||
          rect1->mLeft.GetUnit() != rect2->mLeft.GetUnit()) {
        // At least until we have calc()
        return false;
      }

      nsAutoPtr<nsCSSRect> result(new nsCSSRect);
      for (uint32_t i = 0; i < ArrayLength(nsCSSRect::sides); ++i) {
        nsCSSValue nsCSSRect::*member = nsCSSRect::sides[i];
        MOZ_ASSERT((rect1->*member).GetUnit() == (rect2->*member).GetUnit(),
                   "should have returned above");
        switch ((rect1->*member).GetUnit()) {
          case eCSSUnit_Pixel:
            AddCSSValuePixel(aCoeff1, rect1->*member, aCoeff2, rect2->*member,
                             result->*member);
            break;
          case eCSSUnit_Auto:
            if (float(aCoeff1 + aCoeff2) != 1.0f) {
              // Interpolating between two auto values makes sense;
              // adding in other ratios does not.
              return false;
            }
            (result->*member).SetAutoValue();
            break;
          default:
            MOZ_ASSERT(false, "unexpected unit");
            return false;
        }
      }

      aResultValue.SetAndAdoptCSSRectValue(result.forget(), eUnit_CSSRect);
      return true;
    }
    case eUnit_Dasharray: {
      const nsCSSValueList *list1 = aValue1.GetCSSValueListValue();
      const nsCSSValueList *list2 = aValue2.GetCSSValueListValue();

      uint32_t len1 = 0, len2 = 0;
      for (const nsCSSValueList *v = list1; v; v = v->mNext) {
        ++len1;
      }
      for (const nsCSSValueList *v = list2; v; v = v->mNext) {
        ++len2;
      }
      MOZ_ASSERT(len1 > 0 && len2 > 0, "unexpected length");

      nsAutoPtr<nsCSSValueList> result;
      nsCSSValueList **resultTail = getter_Transfers(result);
      for (uint32_t i = 0, i_end = EuclidLCM<uint32_t>(len1, len2); i != i_end; ++i) {
        const nsCSSValue &v1 = list1->mValue;
        const nsCSSValue &v2 = list2->mValue;
        MOZ_ASSERT(v1.GetUnit() == eCSSUnit_Number ||
                   v1.GetUnit() == eCSSUnit_Percent, "unexpected");
        MOZ_ASSERT(v2.GetUnit() == eCSSUnit_Number ||
                   v2.GetUnit() == eCSSUnit_Percent, "unexpected");
        if (v1.GetUnit() != v2.GetUnit()) {
          // Can't animate between lengths and percentages (until calc()).
          return false;
        }

        nsCSSValueList *item = new nsCSSValueList;
        *resultTail = item;
        resultTail = &item->mNext;

        if (v1.GetUnit() == eCSSUnit_Number) {
          AddCSSValueNumber(aCoeff1, v1, aCoeff2, v2, item->mValue,
                            CSS_PROPERTY_VALUE_NONNEGATIVE);
        } else {
          AddCSSValuePercent(aCoeff1, v1, aCoeff2, v2, item->mValue,
                             CSS_PROPERTY_VALUE_NONNEGATIVE);
        }

        list1 = list1->mNext;
        if (!list1) {
          list1 = aValue1.GetCSSValueListValue();
        }
        list2 = list2->mNext;
        if (!list2) {
          list2 = aValue2.GetCSSValueListValue();
        }
      }

      aResultValue.SetAndAdoptCSSValueListValue(result.forget(),
                                                eUnit_Dasharray);
      return true;
    }
    case eUnit_Shadow: {
      UniquePtr<nsCSSValueList> result =
        AddWeightedShadowList(aCoeff1,
                              aValue1.GetCSSValueListValue(),
                              aCoeff2,
                              aValue2.GetCSSValueListValue(),
                              ColorAdditionType::Clamped);
      if (!result) {
        return false;
      }
      aResultValue.SetAndAdoptCSSValueListValue(result.release(), eUnit_Shadow);
      return true;
    }
    case eUnit_Shape: {
      RefPtr<nsCSSValue::Array> result =
        AddShapeFunction(aProperty,
                         aCoeff1, aValue1.GetCSSValueArrayValue(),
                         aCoeff2, aValue2.GetCSSValueArrayValue());
      if (!result) {
        return false;
      }
      aResultValue.SetCSSValueArrayValue(result, eUnit_Shape);
      return true;
    }
    case eUnit_Filter: {
      UniquePtr<nsCSSValueList> result =
        AddWeightedFilterList(aCoeff1, aValue1.GetCSSValueListValue(),
                              aCoeff2, aValue2.GetCSSValueListValue(),
                              ColorAdditionType::Clamped);
      if (!result) {
        return false;
      }

      aResultValue.SetAndAdoptCSSValueListValue(result.release(),
                                                eUnit_Filter);
      return true;
    }

    case eUnit_Transform: {
      const nsCSSValueList* list1 = aValue1.GetCSSValueSharedListValue()->mHead;
      const nsCSSValueList* list2 = aValue2.GetCSSValueSharedListValue()->mHead;

      MOZ_ASSERT(list1);
      MOZ_ASSERT(list2);

      // We want to avoid the matrix decomposition when we can, since
      // avoiding it can produce better results both for compound
      // transforms and for skew and skewY (see below).  We can do this
      // in two cases:
      //   (1) if one of the transforms is 'none'
      //   (2) if the lists have the same length and the transform
      //       functions match
      nsAutoPtr<nsCSSValueList> result;
      if (list1->mValue.GetUnit() == eCSSUnit_None) {
        if (list2->mValue.GetUnit() == eCSSUnit_None) {
          result = new nsCSSValueList;
          if (result) {
            result->mValue.SetNoneValue();
          }
        } else {
          result = AddTransformLists(0, list2, aCoeff2, list2);
        }
      } else {
        if (list2->mValue.GetUnit() == eCSSUnit_None) {
          result = AddTransformLists(0, list1, aCoeff1, list1);
        } else {
          bool match = true;

          {
            const nsCSSValueList *item1 = list1, *item2 = list2;
            do {
              nsCSSKeyword func1 = nsStyleTransformMatrix::TransformFunctionOf(
                                     item1->mValue.GetArrayValue());
              nsCSSKeyword func2 = nsStyleTransformMatrix::TransformFunctionOf(
                                     item2->mValue.GetArrayValue());

              if (!TransformFunctionsMatch(func1, func2)) {
                break;
              }

              item1 = item1->mNext;
              item2 = item2->mNext;
            } while (item1 && item2);
            if (item1 || item2) {
              // Either |break| above or length mismatch.
              match = false;
            }
          }

          if (match) {
            result = AddTransformLists(aCoeff1, list1, aCoeff2, list2);
          } else {
            result = AddDifferentTransformLists(aCoeff1, list1, aCoeff2, list2);
          }
        }
      }

      aResultValue.SetTransformValue(new nsCSSValueSharedList(result.forget()));
      return true;
    }
    case eUnit_BackgroundPositionCoord: {
      const nsCSSValueList *position1 = aValue1.GetCSSValueListValue();
      const nsCSSValueList *position2 = aValue2.GetCSSValueListValue();
      nsAutoPtr<nsCSSValueList> result;
      nsCSSValueList **resultTail = getter_Transfers(result);
      while (position1 && position2) {
        nsCSSValueList *item = new nsCSSValueList;
        *resultTail = item;
        resultTail = &item->mNext;

        AddPositionCoords(aCoeff1, position1->mValue,
                          aCoeff2, position2->mValue, item->mValue);

        position1 = position1->mNext;
        position2 = position2->mNext;
      }

      // Check for different lengths
      if (position1 || position2) {
        return false;
      }

      aResultValue.SetAndAdoptCSSValueListValue(result.forget(),
                                                eUnit_BackgroundPositionCoord);
      return true;
    }
    case eUnit_CSSValuePairList: {
      const nsCSSValuePairList *list1 = aValue1.GetCSSValuePairListValue();
      const nsCSSValuePairList *list2 = aValue2.GetCSSValuePairListValue();
      UniquePtr<nsCSSValuePairList> result =
        AddCSSValuePairList(aProperty, aCoeff1, list1, aCoeff2, list2);
      if (!result) {
        return false;
      }
      aResultValue.SetAndAdoptCSSValuePairListValue(result.release());
      return true;
    }
  }

  MOZ_ASSERT(false, "Can't interpolate using the given common unit");
  return false;
}

bool
StyleAnimationValue::Accumulate(nsCSSPropertyID aProperty,
                                StyleAnimationValue& aDest,
                                const StyleAnimationValue& aValueToAccumulate,
                                uint64_t aCount)
{
  Unit commonUnit =
    GetCommonUnit(aProperty, aDest.GetUnit(), aValueToAccumulate.GetUnit());
  switch (commonUnit) {
    case eUnit_Filter: {
      UniquePtr<nsCSSValueList> result =
        AddWeightedFilterList(1.0, aDest.GetCSSValueListValue(),
                              aCount, aValueToAccumulate.GetCSSValueListValue(),
                              ColorAdditionType::Unclamped);
      if (!result) {
        return false;
      }

      aDest.SetAndAdoptCSSValueListValue(result.release(), eUnit_Filter);
      return true;
    }
    case eUnit_Shadow: {
      UniquePtr<nsCSSValueList> result =
        AddWeightedShadowList(1.0, aDest.GetCSSValueListValue(),
                              aCount, aValueToAccumulate.GetCSSValueListValue(),
                              ColorAdditionType::Unclamped);
      if (!result) {
        return false;
      }
      aDest.SetAndAdoptCSSValueListValue(result.release(), eUnit_Shadow);
      return true;
    }
    case eUnit_Color: {
      RGBAColorData color1 = ExtractColor(aDest);
      RGBAColorData color2 = ExtractColor(aValueToAccumulate);
      auto resultColor = MakeUnique<nsCSSValue>();
      resultColor->SetRGBAColorValue(
        AddWeightedColors(1.0, color1, aCount, color2));
      aDest.SetAndAdoptCSSValueValue(resultColor.release(), eUnit_Color);
      return true;
    }
    default:
      return Add(aProperty, aDest, aValueToAccumulate, aCount);
  }
  MOZ_ASSERT_UNREACHABLE("Can't accumulate using the given common unit");
  return false;
}

already_AddRefed<css::StyleRule>
BuildStyleRule(nsCSSPropertyID aProperty,
               dom::Element* aTargetElement,
               const nsAString& aSpecifiedValue,
               bool aUseSVGMode)
{
  // Set up an empty CSS Declaration
  RefPtr<css::Declaration> declaration(new css::Declaration());
  declaration->InitializeEmpty();

  bool changed; // ignored, but needed as outparam for ParseProperty
  nsIDocument* doc = aTargetElement->OwnerDoc();
  nsCOMPtr<nsIURI> baseURI = aTargetElement->GetBaseURI();
  nsCSSParser parser(doc->CSSLoader());

  nsCSSPropertyID propertyToCheck = nsCSSProps::IsShorthand(aProperty) ?
    nsCSSProps::SubpropertyEntryFor(aProperty)[0] : aProperty;

  // Get a parser, parse the property, and check for CSS parsing errors.
  // If this fails, we bail out and delete the declaration.
  parser.ParseProperty(aProperty, aSpecifiedValue, doc->GetDocumentURI(),
                       baseURI, aTargetElement->NodePrincipal(), declaration,
                       &changed, false, aUseSVGMode);

  // check whether property parsed without CSS parsing errors
  if (!declaration->HasNonImportantValueFor(propertyToCheck)) {
    return nullptr;
  }

  RefPtr<css::StyleRule> rule = new css::StyleRule(nullptr,
                                                     declaration,
                                                     0, 0);
  return rule.forget();
}

already_AddRefed<css::StyleRule>
BuildStyleRule(nsCSSPropertyID aProperty,
               dom::Element* aTargetElement,
               const nsCSSValue& aSpecifiedValue,
               bool aUseSVGMode)
{
  MOZ_ASSERT(!nsCSSProps::IsShorthand(aProperty),
             "Should be a longhand property");

  // Check if longhand failed to parse correctly.
  if (aSpecifiedValue.GetUnit() == eCSSUnit_Null) {
    return nullptr;
  }

  // Set up an empty CSS Declaration
  RefPtr<css::Declaration> declaration(new css::Declaration());
  declaration->InitializeEmpty();

  // Add our longhand value
  nsCSSExpandedDataBlock block;
  declaration->ExpandTo(&block);
  block.AddLonghandProperty(aProperty, aSpecifiedValue);
  declaration->ValueAppended(aProperty);
  declaration->CompressFrom(&block);

  RefPtr<css::StyleRule> rule = new css::StyleRule(nullptr, declaration, 0, 0);
  return rule.forget();
}

static bool
ComputeValuesFromStyleContext(
  nsCSSPropertyID aProperty,
  CSSEnabledState aEnabledState,
  nsStyleContext* aStyleContext,
  nsTArray<PropertyStyleAnimationValuePair>& aValues)
{
  // Extract computed value of our property (or all longhand components, if
  // aProperty is a shorthand) from the temporary style context
  if (nsCSSProps::IsShorthand(aProperty)) {
    CSSPROPS_FOR_SHORTHAND_SUBPROPERTIES(p, aProperty, aEnabledState) {
      if (nsCSSProps::kAnimTypeTable[*p] == eStyleAnimType_None) {
        // Skip non-animatable component longhands.
        continue;
      }
      PropertyStyleAnimationValuePair* pair = aValues.AppendElement();
      pair->mProperty = *p;
      if (!StyleAnimationValue::ExtractComputedValue(*p, aStyleContext,
                                                     pair->mValue)) {
        return false;
      }
    }
    return true;
  }

  PropertyStyleAnimationValuePair* pair = aValues.AppendElement();
  pair->mProperty = aProperty;
  return StyleAnimationValue::ExtractComputedValue(aProperty, aStyleContext,
                                                   pair->mValue);
}

static bool
ComputeValuesFromStyleRule(nsCSSPropertyID aProperty,
                           CSSEnabledState aEnabledState,
                           nsStyleContext* aStyleContext,
                           css::StyleRule* aStyleRule,
                           nsTArray<PropertyStyleAnimationValuePair>& aValues,
                           bool* aIsContextSensitive)
{
  MOZ_ASSERT(aStyleContext);
  if (!nsCSSProps::IsEnabled(aProperty, aEnabledState)) {
    return false;
  }

  MOZ_ASSERT(aStyleContext->PresContext()->StyleSet()->IsGecko(),
             "ServoStyleSet should not use StyleAnimationValue for animations");
  nsStyleSet* styleSet = aStyleContext->PresContext()->StyleSet()->AsGecko();

  RefPtr<nsStyleContext> tmpStyleContext;
  if (aIsContextSensitive) {
    MOZ_ASSERT(!nsCSSProps::IsShorthand(aProperty),
               "to correctly set aIsContextSensitive for shorthand properties, "
               "this code must be adjusted");

    nsCOMArray<nsIStyleRule> ruleArray;
    ruleArray.AppendObject(styleSet->InitialStyleRule());
    css::Declaration* declaration = aStyleRule->GetDeclaration();
    ruleArray.AppendObject(declaration);
    declaration->SetImmutable();
    tmpStyleContext =
      styleSet->ResolveStyleByAddingRules(aStyleContext, ruleArray);
    if (!tmpStyleContext) {
      return false;
    }

    // Force walk of rule tree
    nsStyleStructID sid = nsCSSProps::kSIDTable[aProperty];
    tmpStyleContext->StyleData(sid);

    // The rule node will have unconditional cached style data if the value is
    // not context-sensitive.  So if there's nothing cached, it's not context
    // sensitive.
    *aIsContextSensitive =
      !tmpStyleContext->RuleNode()->NodeHasCachedUnconditionalData(sid);
  }

  // If we're not concerned whether the property is context sensitive then just
  // add the rule to a new temporary style context alongside the target
  // element's style context.
  // Also, if we previously discovered that this property IS context-sensitive
  // then we need to throw the temporary style context out since the property's
  // value may have been biased by the 'initial' values supplied.
  if (!aIsContextSensitive || *aIsContextSensitive) {
    nsCOMArray<nsIStyleRule> ruleArray;
    css::Declaration* declaration = aStyleRule->GetDeclaration();
    ruleArray.AppendObject(declaration);
    declaration->SetImmutable();
    tmpStyleContext =
      styleSet->ResolveStyleByAddingRules(aStyleContext, ruleArray);
    if (!tmpStyleContext) {
      return false;
    }
  }

  return ComputeValuesFromStyleContext(aProperty, aEnabledState,
                                       tmpStyleContext, aValues);
}

/* static */ bool
StyleAnimationValue::ComputeValue(nsCSSPropertyID aProperty,
                                  dom::Element* aTargetElement,
                                  nsStyleContext* aStyleContext,
                                  const nsAString& aSpecifiedValue,
                                  bool aUseSVGMode,
                                  StyleAnimationValue& aComputedValue,
                                  bool* aIsContextSensitive)
{
  MOZ_ASSERT(aTargetElement, "null target element");

  // Parse specified value into a temporary css::StyleRule
  // Note: BuildStyleRule needs an element's OwnerDoc, BaseURI, and Principal.
  // If it is a pseudo element, use its parent element's OwnerDoc, BaseURI,
  // and Principal.
  RefPtr<css::StyleRule> styleRule =
    BuildStyleRule(aProperty, aTargetElement, aSpecifiedValue, aUseSVGMode);
  if (!styleRule) {
    return false;
  }

  if (nsCSSProps::IsShorthand(aProperty) ||
      nsCSSProps::kAnimTypeTable[aProperty] == eStyleAnimType_None) {
    // Just capture the specified value
    aComputedValue.SetUnparsedStringValue(nsString(aSpecifiedValue));
    if (aIsContextSensitive) {
      // Since we're just returning the string as-is, aComputedValue isn't going
      // to change depending on the context
      *aIsContextSensitive = false;
    }
    return true;
  }

  AutoTArray<PropertyStyleAnimationValuePair,1> values;
  bool ok = ComputeValuesFromStyleRule(aProperty,
                                       CSSEnabledState::eIgnoreEnabledState,
                                       aStyleContext, styleRule,
                                       values, aIsContextSensitive);
  if (!ok) {
    return false;
  }

  MOZ_ASSERT(values.Length() == 1);
  MOZ_ASSERT(values[0].mProperty == aProperty);

  aComputedValue = values[0].mValue;
  return true;
}

template <class T>
bool
ComputeValuesFromSpecifiedValue(
    nsCSSPropertyID aProperty,
    CSSEnabledState aEnabledState,
    dom::Element* aTargetElement,
    nsStyleContext* aStyleContext,
    T& aSpecifiedValue,
    bool aUseSVGMode,
    nsTArray<PropertyStyleAnimationValuePair>& aResult)
{
  MOZ_ASSERT(aTargetElement, "null target element");

  // Parse specified value into a temporary css::StyleRule
  // Note: BuildStyleRule needs an element's OwnerDoc, BaseURI, and Principal.
  // If it is a pseudo element, use its parent element's OwnerDoc, BaseURI,
  // and Principal.
  RefPtr<css::StyleRule> styleRule =
    BuildStyleRule(aProperty, aTargetElement, aSpecifiedValue, aUseSVGMode);
  if (!styleRule) {
    return false;
  }

  aResult.Clear();
  return ComputeValuesFromStyleRule(aProperty, aEnabledState,
                                    aStyleContext, styleRule, aResult,
                                    /* aIsContextSensitive */ nullptr);
}

/* static */ bool
StyleAnimationValue::ComputeValues(
    nsCSSPropertyID aProperty,
    CSSEnabledState aEnabledState,
    dom::Element* aTargetElement,
    nsStyleContext* aStyleContext,
    const nsAString& aSpecifiedValue,
    bool aUseSVGMode,
    nsTArray<PropertyStyleAnimationValuePair>& aResult)
{
  return ComputeValuesFromSpecifiedValue(aProperty, aEnabledState,
                                         aTargetElement, aStyleContext,
                                         aSpecifiedValue, aUseSVGMode,
                                         aResult);
}

/* static */ bool
StyleAnimationValue::ComputeValues(
    nsCSSPropertyID aProperty,
    CSSEnabledState aEnabledState,
    dom::Element* aTargetElement,
    nsStyleContext* aStyleContext,
    const nsCSSValue& aSpecifiedValue,
    bool aUseSVGMode,
    nsTArray<PropertyStyleAnimationValuePair>& aResult)
{
  return ComputeValuesFromSpecifiedValue(aProperty, aEnabledState,
                                         aTargetElement, aStyleContext,
                                         aSpecifiedValue, aUseSVGMode,
                                         aResult);
}

/* static */ bool
StyleAnimationValue::ComputeValues(
  nsCSSPropertyID aProperty,
  CSSEnabledState aEnabledState,
  nsStyleContext* aStyleContext,
  const RawServoDeclarationBlock& aDeclarations,
  nsTArray<PropertyStyleAnimationValuePair>& aValues)
{
  MOZ_ASSERT(aStyleContext->PresContext()->StyleSet()->IsServo(),
             "Should be using ServoStyleSet if we have a"
             " RawServoDeclarationBlock");

  if (!nsCSSProps::IsEnabled(aProperty, aEnabledState)) {
    return false;
  }

  const ServoComputedValues* previousStyle =
    aStyleContext->StyleSource().AsServoComputedValues();

  // FIXME: Servo bindings don't yet represent const-ness so we just
  // cast it away for now.
  auto declarations = const_cast<RawServoDeclarationBlock*>(&aDeclarations);
  RefPtr<ServoComputedValues> computedValues =
    Servo_RestyleWithAddedDeclaration(declarations, previousStyle).Consume();
  if (!computedValues) {
    return false;
  }

  RefPtr<nsStyleContext> tmpStyleContext =
    NS_NewStyleContext(aStyleContext, aStyleContext->PresContext(),
                       aStyleContext->GetPseudo(),
                       aStyleContext->GetPseudoType(),
                       computedValues.forget(),
                       false /* skipFixup */);

  return ComputeValuesFromStyleContext(aProperty, aEnabledState,
                                       tmpStyleContext, aValues);
}

bool
StyleAnimationValue::UncomputeValue(nsCSSPropertyID aProperty,
                                    const StyleAnimationValue& aComputedValue,
                                    nsCSSValue& aSpecifiedValue)
{
  Unit unit = aComputedValue.GetUnit();
  switch (unit) {
    case eUnit_Normal:
      aSpecifiedValue.SetNormalValue();
      break;
    case eUnit_Auto:
      aSpecifiedValue.SetAutoValue();
      break;
    case eUnit_None:
      aSpecifiedValue.SetNoneValue();
      break;
    case eUnit_Enumerated:
    case eUnit_Visibility:
      aSpecifiedValue.
        SetIntValue(aComputedValue.GetIntValue(), eCSSUnit_Enumerated);
      break;
    case eUnit_Integer:
      aSpecifiedValue.
        SetIntValue(aComputedValue.GetIntValue(), eCSSUnit_Integer);
      break;
    case eUnit_Coord:
      aSpecifiedValue.SetIntegerCoordValue(aComputedValue.GetCoordValue());
      break;
    case eUnit_Percent:
      aSpecifiedValue.SetPercentValue(aComputedValue.GetPercentValue());
      break;
    case eUnit_Float:
      aSpecifiedValue.
        SetFloatValue(aComputedValue.GetFloatValue(), eCSSUnit_Number);
      break;
    case eUnit_CurrentColor:
      aSpecifiedValue.SetIntValue(NS_COLOR_CURRENTCOLOR, eCSSUnit_EnumColor);
      break;
    case eUnit_Calc:
    case eUnit_Color:
    case eUnit_ObjectPosition:
    case eUnit_URL:
    case eUnit_DiscreteCSSValue: {
      nsCSSValue* val = aComputedValue.GetCSSValueValue();
      // Sanity-check that the underlying unit in the nsCSSValue is what we
      // expect for our StyleAnimationValue::Unit:
      MOZ_ASSERT((unit == eUnit_Calc && val->GetUnit() == eCSSUnit_Calc) ||
                 (unit == eUnit_Color &&
                  nsCSSValue::IsNumericColorUnit(val->GetUnit())) ||
                 (unit == eUnit_ObjectPosition &&
                  val->GetUnit() == eCSSUnit_Array) ||
                 (unit == eUnit_URL && val->GetUnit() == eCSSUnit_URL) ||
                 unit == eUnit_DiscreteCSSValue,
                 "unexpected unit");
      aSpecifiedValue = *val;
      break;
    }
    case eUnit_ComplexColor: {
      aSpecifiedValue.SetComplexColorValue(
        do_AddRef(aComputedValue.mValue.mComplexColor));
      break;
    }
    case eUnit_CSSValuePair: {
      // Rule node processing expects pair values to be collapsed to a
      // single value if both halves would be equal, for most but not
      // all properties.  At present, all animatable properties that
      // use pairs do expect collapsing.
      const nsCSSValuePair* pair = aComputedValue.GetCSSValuePairValue();
      if (pair->mXValue == pair->mYValue) {
        aSpecifiedValue = pair->mXValue;
      } else {
        aSpecifiedValue.SetPairValue(pair);
      }
    } break;
    case eUnit_CSSValueTriplet: {
      // Rule node processing expects triplet values to be collapsed to a
      // single value if both halves would be equal, for most but not
      // all properties.  At present, all animatable properties that
      // use pairs do expect collapsing.
      const nsCSSValueTriplet* triplet = aComputedValue.GetCSSValueTripletValue();
      if (triplet->mXValue == triplet->mYValue && triplet->mYValue == triplet->mZValue) {
        aSpecifiedValue = triplet->mXValue;
      } else {
        aSpecifiedValue.SetTripletValue(triplet);
      }
    } break;
    case eUnit_CSSRect: {
      nsCSSRect& rect = aSpecifiedValue.SetRectValue();
      rect = *aComputedValue.GetCSSRectValue();
    } break;
    case eUnit_Dasharray:
    case eUnit_Shadow:
    case eUnit_Filter:
    case eUnit_BackgroundPositionCoord:
      {
        nsCSSValueList* computedList = aComputedValue.GetCSSValueListValue();
        if (computedList) {
          aSpecifiedValue.SetDependentListValue(computedList);
        } else {
          aSpecifiedValue.SetNoneValue();
        }
      }
      break;
    case eUnit_Shape: {
      nsCSSValue::Array* computedArray = aComputedValue.GetCSSValueArrayValue();
      aSpecifiedValue.SetArrayValue(computedArray, eCSSUnit_Array);
      break;
    }
    case eUnit_Transform:
      aSpecifiedValue.
        SetSharedListValue(aComputedValue.GetCSSValueSharedListValue());
      break;
    case eUnit_CSSValuePairList:
      aSpecifiedValue.
        SetDependentPairListValue(aComputedValue.GetCSSValuePairListValue());
      break;
    default:
      return false;
  }
  return true;
}

bool
StyleAnimationValue::UncomputeValue(nsCSSPropertyID aProperty,
                                    StyleAnimationValue&& aComputedValue,
                                    nsCSSValue& aSpecifiedValue)
{
  Unit unit = aComputedValue.GetUnit();
  switch (unit) {
    case eUnit_Dasharray:
    case eUnit_Shadow:
    case eUnit_Filter:
    case eUnit_BackgroundPositionCoord:
      {
        UniquePtr<nsCSSValueList> computedList =
          aComputedValue.TakeCSSValueListValue();
        if (computedList) {
          aSpecifiedValue.AdoptListValue(Move(computedList));
        } else {
          aSpecifiedValue.SetNoneValue();
        }
      }
      break;
    case eUnit_CSSValuePairList:
      {
        UniquePtr<nsCSSValuePairList> computedList =
          aComputedValue.TakeCSSValuePairListValue();
        MOZ_ASSERT(computedList, "Pair list should never be null");
        aSpecifiedValue.AdoptPairListValue(Move(computedList));
      }
      break;
    default:
      return UncomputeValue(aProperty, aComputedValue, aSpecifiedValue);
  }
  return true;
}

bool
StyleAnimationValue::UncomputeValue(nsCSSPropertyID aProperty,
                                    const StyleAnimationValue& aComputedValue,
                                    nsAString& aSpecifiedValue)
{
  aSpecifiedValue.Truncate(); // Clear outparam, if it's not already empty

  if (aComputedValue.GetUnit() == eUnit_UnparsedString) {
    aComputedValue.GetStringValue(aSpecifiedValue);
    return true;
  }
  nsCSSValue val;
  if (!StyleAnimationValue::UncomputeValue(aProperty, aComputedValue, val)) {
    return false;
  }

  val.AppendToString(aProperty, aSpecifiedValue, nsCSSValue::eNormalized);
  return true;
}

template<typename T>
inline const T&
StyleDataAtOffset(const void* aStyleStruct, ptrdiff_t aOffset)
{
  return *reinterpret_cast<const T*>(
    reinterpret_cast<const uint8_t*>(aStyleStruct) + aOffset);
}

static bool
StyleCoordToValue(const nsStyleCoord& aCoord, StyleAnimationValue& aValue)
{
  switch (aCoord.GetUnit()) {
    case eStyleUnit_Normal:
      aValue.SetNormalValue();
      break;
    case eStyleUnit_Auto:
      aValue.SetAutoValue();
      break;
    case eStyleUnit_None:
      aValue.SetNoneValue();
      break;
    case eStyleUnit_Percent:
      aValue.SetPercentValue(aCoord.GetPercentValue());
      break;
    case eStyleUnit_Factor:
      aValue.SetFloatValue(aCoord.GetFactorValue());
      break;
    case eStyleUnit_Coord:
      aValue.SetCoordValue(aCoord.GetCoordValue());
      break;
    case eStyleUnit_Enumerated:
      aValue.SetIntValue(aCoord.GetIntValue(),
                         StyleAnimationValue::eUnit_Enumerated);
      break;
    case eStyleUnit_Integer:
      aValue.SetIntValue(aCoord.GetIntValue(),
                         StyleAnimationValue::eUnit_Integer);
      break;
    case eStyleUnit_Calc: {
      nsAutoPtr<nsCSSValue> val(new nsCSSValue);
      CalcValueToCSSValue(aCoord.GetCalcValue(), *val);
      aValue.SetAndAdoptCSSValueValue(val.forget(),
                                      StyleAnimationValue::eUnit_Calc);
      break;
    }
    default:
      return false;
  }
  return true;
}

static bool
StyleCoordToCSSValue(const nsStyleCoord& aCoord, nsCSSValue& aCSSValue)
{
  switch (aCoord.GetUnit()) {
    case eStyleUnit_Coord:
      aCSSValue.SetIntegerCoordValue(aCoord.GetCoordValue());
      break;
    case eStyleUnit_Factor:
      aCSSValue.SetFloatValue(aCoord.GetFactorValue(), eCSSUnit_Number);
      break;
    case eStyleUnit_Percent:
      aCSSValue.SetPercentValue(aCoord.GetPercentValue());
      break;
    case eStyleUnit_Calc:
      CalcValueToCSSValue(aCoord.GetCalcValue(), aCSSValue);
      break;
    case eStyleUnit_Degree:
      aCSSValue.SetFloatValue(aCoord.GetAngleValue(), eCSSUnit_Degree);
      break;
    case eStyleUnit_Grad:
      aCSSValue.SetFloatValue(aCoord.GetAngleValue(), eCSSUnit_Grad);
      break;
    case eStyleUnit_Radian:
      aCSSValue.SetFloatValue(aCoord.GetAngleValue(), eCSSUnit_Radian);
      break;
    case eStyleUnit_Turn:
      aCSSValue.SetFloatValue(aCoord.GetAngleValue(), eCSSUnit_Turn);
      break;
    default:
      MOZ_ASSERT(false, "unexpected unit");
      return false;
  }
  return true;
}

static void
SetPositionValue(const Position& aPos, nsCSSValue& aCSSValue)
{
  RefPtr<nsCSSValue::Array> posArray = nsCSSValue::Array::Create(4);
  aCSSValue.SetArrayValue(posArray.get(), eCSSUnit_Array);

  // NOTE: Array entries #0 and #2 here are intentionally left untouched, with
  // eCSSUnit_Null.  The purpose of these entries in our specified-style
  // <position> representation is to store edge names.  But for values
  // extracted from computed style (which is what we're dealing with here),
  // we'll just have a normalized "x,y" position, with no edge names needed.
  nsCSSValue& xValue = posArray->Item(1);
  nsCSSValue& yValue = posArray->Item(3);

  CalcValueToCSSValue(&aPos.mXPosition, xValue);
  CalcValueToCSSValue(&aPos.mYPosition, yValue);
}

static void
SetPositionCoordValue(const Position::Coord& aPosCoord,
                      nsCSSValue& aCSSValue)
{
  RefPtr<nsCSSValue::Array> posArray = nsCSSValue::Array::Create(2);
  aCSSValue.SetArrayValue(posArray.get(), eCSSUnit_Array);

  // NOTE: Array entry #0 here is intentionally left untouched, with
  // eCSSUnit_Null.  The purpose of this entry in our specified-style
  // <position-coord> representation is to store edge names.  But for values
  // extracted from computed style (which is what we're dealing with here),
  // we'll just have a normalized "x"/"y" position, with no edge names needed.
  nsCSSValue& value = posArray->Item(1);

  CalcValueToCSSValue(&aPosCoord, value);
}

/*
 * Assign |aOutput = aInput|, except with any non-pixel lengths
 * replaced with the equivalent in pixels, and any non-canonical calc()
 * expressions replaced with canonical ones.
 */
static void
SubstitutePixelValues(nsStyleContext* aStyleContext,
                      const nsCSSValue& aInput, nsCSSValue& aOutput)
{
  if (aInput.IsCalcUnit()) {
    RuleNodeCacheConditions conditions;
    nsRuleNode::ComputedCalc c =
      nsRuleNode::SpecifiedCalcToComputedCalc(aInput, aStyleContext,
                                              aStyleContext->PresContext(),
                                              conditions);
    nsStyleCoord::CalcValue c2;
    c2.mLength = c.mLength;
    c2.mPercent = c.mPercent;
    c2.mHasPercent = true; // doesn't matter for transform translate
    CalcValueToCSSValue(&c2, aOutput);
  } else if (aInput.UnitHasArrayValue()) {
    const nsCSSValue::Array *inputArray = aInput.GetArrayValue();
    RefPtr<nsCSSValue::Array> outputArray =
      nsCSSValue::Array::Create(inputArray->Count());
    for (size_t i = 0, i_end = inputArray->Count(); i < i_end; ++i) {
      SubstitutePixelValues(aStyleContext,
                            inputArray->Item(i), outputArray->Item(i));
    }
    aOutput.SetArrayValue(outputArray, aInput.GetUnit());
  } else if (aInput.IsLengthUnit() &&
             aInput.GetUnit() != eCSSUnit_Pixel) {
    RuleNodeCacheConditions conditions;
    nscoord len = nsRuleNode::CalcLength(aInput, aStyleContext,
                                         aStyleContext->PresContext(),
                                         conditions);
    aOutput.SetFloatValue(nsPresContext::AppUnitsToFloatCSSPixels(len),
                          eCSSUnit_Pixel);
  } else {
    aOutput = aInput;
  }
}

static void
ExtractImageLayerPositionXList(const nsStyleImageLayers& aLayer,
                               StyleAnimationValue& aComputedValue)
{
  MOZ_ASSERT(aLayer.mPositionXCount > 0, "unexpected count");

  nsAutoPtr<nsCSSValueList> result;
  nsCSSValueList **resultTail = getter_Transfers(result);
  for (uint32_t i = 0, i_end = aLayer.mPositionXCount; i != i_end; ++i) {
    nsCSSValueList *item = new nsCSSValueList;
    *resultTail = item;
    resultTail = &item->mNext;
    SetPositionCoordValue(aLayer.mLayers[i].mPosition.mXPosition,
                          item->mValue);
  }

  aComputedValue.SetAndAdoptCSSValueListValue(result.forget(),
    StyleAnimationValue::eUnit_BackgroundPositionCoord);
}

static void
ExtractImageLayerPositionYList(const nsStyleImageLayers& aLayer,
                               StyleAnimationValue& aComputedValue)
{
  MOZ_ASSERT(aLayer.mPositionYCount > 0, "unexpected count");

  nsAutoPtr<nsCSSValueList> result;
  nsCSSValueList **resultTail = getter_Transfers(result);
  for (uint32_t i = 0, i_end = aLayer.mPositionYCount; i != i_end; ++i) {
    nsCSSValueList *item = new nsCSSValueList;
    *resultTail = item;
    resultTail = &item->mNext;
    SetPositionCoordValue(aLayer.mLayers[i].mPosition.mYPosition,
                          item->mValue);
  }

  aComputedValue.SetAndAdoptCSSValueListValue(result.forget(),
    StyleAnimationValue::eUnit_BackgroundPositionCoord);
}

static void
ExtractImageLayerSizePairList(const nsStyleImageLayers& aLayer,
                              StyleAnimationValue& aComputedValue)
{
  MOZ_ASSERT(aLayer.mSizeCount > 0, "unexpected count");

  nsAutoPtr<nsCSSValuePairList> result;
  nsCSSValuePairList **resultTail = getter_Transfers(result);
  for (uint32_t i = 0, i_end = aLayer.mSizeCount; i != i_end; ++i) {
    nsCSSValuePairList *item = new nsCSSValuePairList;
    *resultTail = item;
    resultTail = &item->mNext;

    const nsStyleImageLayers::Size &size = aLayer.mLayers[i].mSize;
    switch (size.mWidthType) {
      case nsStyleImageLayers::Size::eContain:
      case nsStyleImageLayers::Size::eCover:
        item->mXValue.SetIntValue(size.mWidthType,
                                  eCSSUnit_Enumerated);
        break;
      case nsStyleImageLayers::Size::eAuto:
        item->mXValue.SetAutoValue();
        break;
      case nsStyleImageLayers::Size::eLengthPercentage:
        // XXXbz is there a good reason we can't just
        // CalcValueToCSSValue(&size.mWidth, item->mXValue) here?
        if (!size.mWidth.mHasPercent &&
            // negative values must have come from calc()
            size.mWidth.mLength >= 0) {
          MOZ_ASSERT(size.mWidth.mPercent == 0.0f,
                     "Shouldn't have mPercent");
          item->mXValue.SetIntegerCoordValue(size.mWidth.mLength);
        } else if (size.mWidth.mLength == 0 &&
                   // negative values must have come from calc()
                   size.mWidth.mPercent >= 0.0f) {
          item->mXValue.SetPercentValue(size.mWidth.mPercent);
        } else {
          CalcValueToCSSValue(&size.mWidth, item->mXValue);
        }
        break;
    }

    switch (size.mHeightType) {
      case nsStyleImageLayers::Size::eContain:
      case nsStyleImageLayers::Size::eCover:
        // leave it null
        break;
      case nsStyleImageLayers::Size::eAuto:
        item->mYValue.SetAutoValue();
        break;
      case nsStyleImageLayers::Size::eLengthPercentage:
        // XXXbz is there a good reason we can't just
        // CalcValueToCSSValue(&size.mHeight, item->mYValue) here?
        if (!size.mHeight.mHasPercent &&
            // negative values must have come from calc()
            size.mHeight.mLength >= 0) {
          MOZ_ASSERT(size.mHeight.mPercent == 0.0f,
                     "Shouldn't have mPercent");
          item->mYValue.SetIntegerCoordValue(size.mHeight.mLength);
        } else if (size.mHeight.mLength == 0 &&
                   // negative values must have come from calc()
                   size.mHeight.mPercent >= 0.0f) {
          item->mYValue.SetPercentValue(size.mHeight.mPercent);
        } else {
          CalcValueToCSSValue(&size.mHeight, item->mYValue);
        }
        break;
    }
  }

  aComputedValue.SetAndAdoptCSSValuePairListValue(result.forget());
}

static bool
StyleClipBasicShapeToCSSArray(const StyleClipPath& aClipPath,
                              nsCSSValue::Array* aResult)
{
  MOZ_ASSERT(aResult->Count() == 2,
             "Expected array to be presized for a function and the sizing-box");

  const StyleBasicShape* shape = aClipPath.GetBasicShape();
  nsCSSKeyword functionName = shape->GetShapeTypeName();
  RefPtr<nsCSSValue::Array> functionArray;
  switch (shape->GetShapeType()) {
    case StyleBasicShapeType::Circle:
    case StyleBasicShapeType::Ellipse: {
      const nsTArray<nsStyleCoord>& coords = shape->Coordinates();
      MOZ_ASSERT(coords.Length() == ShapeArgumentCount(functionName) - 1,
                 "Unexpected radii count");
      // The "+1" is for the center point:
      functionArray = aResult->Item(0).InitFunction(functionName,
                                                    coords.Length() + 1);
      for (size_t i = 0; i < coords.Length(); ++i) {
        if (coords[i].GetUnit() == eStyleUnit_Enumerated) {
          functionArray->Item(i + 1).SetIntValue(coords[i].GetIntValue(),
                                                 eCSSUnit_Enumerated);
        } else if (!StyleCoordToCSSValue(coords[i],
                                         functionArray->Item(i + 1))) {
          return false;
        }
      }
      // Set functionArray's last item to the circle or ellipse's center point:
      SetPositionValue(shape->GetPosition(),
                       functionArray->Item(functionArray->Count() - 1));
      break;
    }
    case StyleBasicShapeType::Polygon: {
      functionArray =
        aResult->Item(0).InitFunction(functionName,
                                      ShapeArgumentCount(functionName));
      functionArray->Item(1).SetIntValue(shape->GetFillRule(),
                                         eCSSUnit_Enumerated);
      nsCSSValuePairList* list = functionArray->Item(2).SetPairListValue();
      const nsTArray<nsStyleCoord>& coords = shape->Coordinates();
      MOZ_ASSERT((coords.Length() % 2) == 0);
      for (size_t i = 0; i < coords.Length(); i += 2) {
        if (i > 0) {
          list->mNext = new nsCSSValuePairList;
          list = list->mNext;
        }
        if (!StyleCoordToCSSValue(coords[i], list->mXValue) ||
            !StyleCoordToCSSValue(coords[i + 1], list->mYValue)) {
          return false;
        }
      }
      break;
    }
    case StyleBasicShapeType::Inset: {
      const nsTArray<nsStyleCoord>& coords = shape->Coordinates();
      MOZ_ASSERT(coords.Length() == ShapeArgumentCount(functionName) - 1,
                 "Unexpected offset count");
      functionArray =
        aResult->Item(0).InitFunction(functionName, coords.Length() + 1);
      for (size_t i = 0; i < coords.Length(); ++i) {
        if (!StyleCoordToCSSValue(coords[i], functionArray->Item(i + 1))) {
          return false;
        }
      }
      RefPtr<nsCSSValue::Array> radiusArray = nsCSSValue::Array::Create(4);
      const nsStyleCorners& radii = shape->GetRadius();
      NS_FOR_CSS_FULL_CORNERS(corner) {
        auto pair = MakeUnique<nsCSSValuePair>();
        if (!StyleCoordToCSSValue(radii.Get(NS_FULL_TO_HALF_CORNER(corner, false)),
                                  pair->mXValue) ||
            !StyleCoordToCSSValue(radii.Get(NS_FULL_TO_HALF_CORNER(corner, true)),
                                  pair->mYValue)) {
          return false;
        }
        radiusArray->Item(corner).SetPairValue(pair.get());
      }
      // Set the last item in functionArray to the radius array:
      functionArray->Item(functionArray->Count() - 1).
                       SetArrayValue(radiusArray, eCSSUnit_Array);
      break;
    }
    default:
      MOZ_ASSERT_UNREACHABLE("Unknown shape type");
      return false;
  }
  aResult->Item(1).SetIntValue(aClipPath.GetReferenceBox(),
                               eCSSUnit_Enumerated);
  return true;
}

bool
StyleAnimationValue::ExtractComputedValue(nsCSSPropertyID aProperty,
                                          nsStyleContext* aStyleContext,
                                          StyleAnimationValue& aComputedValue)
{
  MOZ_ASSERT(0 <= aProperty && aProperty < eCSSProperty_COUNT_no_shorthands,
             "bad property");
  const void* styleStruct =
    aStyleContext->StyleData(nsCSSProps::kSIDTable[aProperty]);
  ptrdiff_t ssOffset = nsCSSProps::kStyleStructOffsetTable[aProperty];
  nsStyleAnimType animType = nsCSSProps::kAnimTypeTable[aProperty];
  MOZ_ASSERT(0 <= ssOffset ||
             animType == eStyleAnimType_Custom ||
             animType == eStyleAnimType_Discrete,
             "all animation types other than Custom and Discrete must " \
             "specify a style struct offset to extract values from");
  switch (animType) {
    case eStyleAnimType_Custom:
      switch (aProperty) {
        // For border-width, ignore the border-image business (which
        // only exists until we update our implementation to the current
        // spec) and use GetComputedBorder

        #define BORDER_WIDTH_CASE(prop_, side_)                               \
        case prop_:                                                           \
          aComputedValue.SetCoordValue(                                       \
            static_cast<const nsStyleBorder*>(styleStruct)->                  \
              GetComputedBorder().side_);                                     \
          break;
        BORDER_WIDTH_CASE(eCSSProperty_border_bottom_width, bottom)
        BORDER_WIDTH_CASE(eCSSProperty_border_left_width, left)
        BORDER_WIDTH_CASE(eCSSProperty_border_right_width, right)
        BORDER_WIDTH_CASE(eCSSProperty_border_top_width, top)
        #undef BORDER_WIDTH_CASE

        case eCSSProperty_column_rule_width:
          aComputedValue.SetCoordValue(
            static_cast<const nsStyleColumn*>(styleStruct)->
              GetComputedColumnRuleWidth());
          break;

        case eCSSProperty_column_count: {
          const nsStyleColumn *styleColumn =
            static_cast<const nsStyleColumn*>(styleStruct);
          if (styleColumn->mColumnCount == NS_STYLE_COLUMN_COUNT_AUTO) {
            aComputedValue.SetAutoValue();
          } else {
            aComputedValue.SetIntValue(styleColumn->mColumnCount,
                                       eUnit_Integer);
          }
          break;
        }

        case eCSSProperty_order: {
          const nsStylePosition *stylePosition =
            static_cast<const nsStylePosition*>(styleStruct);
          aComputedValue.SetIntValue(stylePosition->mOrder,
                                     eUnit_Integer);
          break;
        }

        case eCSSProperty_border_spacing: {
          const nsStyleTableBorder *styleTableBorder =
            static_cast<const nsStyleTableBorder*>(styleStruct);
          nsAutoPtr<nsCSSValuePair> pair(new nsCSSValuePair);
          pair->mXValue.SetIntegerCoordValue(styleTableBorder->mBorderSpacingCol);
          pair->mYValue.SetIntegerCoordValue(styleTableBorder->mBorderSpacingRow);
          aComputedValue.SetAndAdoptCSSValuePairValue(pair.forget(),
                                                      eUnit_CSSValuePair);
          break;
        }

        case eCSSProperty_transform_origin: {
          const nsStyleDisplay *styleDisplay =
            static_cast<const nsStyleDisplay*>(styleStruct);
          nsAutoPtr<nsCSSValueTriplet> triplet(new nsCSSValueTriplet);
          if (!StyleCoordToCSSValue(styleDisplay->mTransformOrigin[0],
                                    triplet->mXValue) ||
              !StyleCoordToCSSValue(styleDisplay->mTransformOrigin[1],
                                    triplet->mYValue) ||
              !StyleCoordToCSSValue(styleDisplay->mTransformOrigin[2],
                                    triplet->mZValue)) {
            return false;
          }
          aComputedValue.SetAndAdoptCSSValueTripletValue(triplet.forget(),
                                                         eUnit_CSSValueTriplet);
          break;
        }

        case eCSSProperty_perspective_origin: {
          const nsStyleDisplay *styleDisplay =
            static_cast<const nsStyleDisplay*>(styleStruct);
          nsAutoPtr<nsCSSValuePair> pair(new nsCSSValuePair);
          if (!StyleCoordToCSSValue(styleDisplay->mPerspectiveOrigin[0],
                                    pair->mXValue) ||
              !StyleCoordToCSSValue(styleDisplay->mPerspectiveOrigin[1],
                                    pair->mYValue)) {
            return false;
          }
          aComputedValue.SetAndAdoptCSSValuePairValue(pair.forget(),
                                                      eUnit_CSSValuePair);
          break;
        }

        case eCSSProperty_stroke_dasharray: {
          const nsStyleSVG *svg = static_cast<const nsStyleSVG*>(styleStruct);
          if (!svg->mStrokeDasharray.IsEmpty()) {
            nsAutoPtr<nsCSSValueList> result;
            nsCSSValueList **resultTail = getter_Transfers(result);
            for (uint32_t i = 0, i_end = svg->mStrokeDasharray.Length();
                 i != i_end; ++i) {
              nsCSSValueList *item = new nsCSSValueList;
              *resultTail = item;
              resultTail = &item->mNext;

              const nsStyleCoord &coord = svg->mStrokeDasharray[i];
              nsCSSValue &value = item->mValue;
              switch (coord.GetUnit()) {
                case eStyleUnit_Coord:
                  // Number means the same thing as length; we want to
                  // animate them the same way.  Normalize both to number
                  // since it has more accuracy (float vs nscoord).
                  value.SetFloatValue(nsPresContext::
                    AppUnitsToFloatCSSPixels(coord.GetCoordValue()),
                    eCSSUnit_Number);
                  break;
                case eStyleUnit_Factor:
                  value.SetFloatValue(coord.GetFactorValue(),
                                      eCSSUnit_Number);
                  break;
                case eStyleUnit_Percent:
                  value.SetPercentValue(coord.GetPercentValue());
                  break;
                default:
                  MOZ_ASSERT(false, "unexpected unit");
                  return false;
              }
            }
            aComputedValue.SetAndAdoptCSSValueListValue(result.forget(),
                                                        eUnit_Dasharray);
          } else if (svg->StrokeDasharrayFromObject()) {
            // An empty dasharray with StrokeDasharrayFromObject() == true
            // corresponds to the "context-value" keyword.
            aComputedValue.SetIntValue(NS_STYLE_STROKE_PROP_CONTEXT_VALUE,
                                       eUnit_Enumerated);
          } else {
            // Otherwise, an empty dasharray corresponds to the "none" keyword.
            aComputedValue.SetNoneValue();
          }
          break;
        }

        case eCSSProperty_font_stretch: {
          int16_t stretch =
            static_cast<const nsStyleFont*>(styleStruct)->mFont.stretch;
          static_assert(NS_STYLE_FONT_STRETCH_ULTRA_CONDENSED == -4 &&
                        NS_STYLE_FONT_STRETCH_ULTRA_EXPANDED == 4,
                        "font stretch constants not as expected");
          if (stretch < NS_STYLE_FONT_STRETCH_ULTRA_CONDENSED ||
              stretch > NS_STYLE_FONT_STRETCH_ULTRA_EXPANDED) {
            return false;
          }
          aComputedValue.SetIntValue(stretch, eUnit_Enumerated);
          return true;
        }

        case eCSSProperty_font_weight: {
          uint16_t weight =
            static_cast<const nsStyleFont*>(styleStruct)->mFont.weight;
          if (weight % 100 != 0) {
            return false;
          }
          aComputedValue.SetIntValue(weight, eUnit_Integer);
          return true;
        }

        case eCSSProperty_image_region: {
          const nsStyleList *list =
            static_cast<const nsStyleList*>(styleStruct);
          const nsRect &srect = list->mImageRegion;
          if (srect.IsEmpty()) {
            aComputedValue.SetAutoValue();
            break;
          }

          nsCSSRect *vrect = new nsCSSRect;
          vrect->mLeft.SetIntegerCoordValue(srect.x);
          vrect->mTop.SetIntegerCoordValue(srect.y);
          vrect->mRight.SetIntegerCoordValue(srect.XMost());
          vrect->mBottom.SetIntegerCoordValue(srect.YMost());
          aComputedValue.SetAndAdoptCSSRectValue(vrect, eUnit_CSSRect);
          break;
        }

        case eCSSProperty_clip: {
          const nsStyleEffects* effects =
            static_cast<const nsStyleEffects*>(styleStruct);
          if (!(effects->mClipFlags & NS_STYLE_CLIP_RECT)) {
            aComputedValue.SetAutoValue();
          } else {
            nsCSSRect *vrect = new nsCSSRect;
            const nsRect &srect = effects->mClip;
            if (effects->mClipFlags & NS_STYLE_CLIP_TOP_AUTO) {
              vrect->mTop.SetAutoValue();
            } else {
              vrect->mTop.SetIntegerCoordValue(srect.y);
            }
            if (effects->mClipFlags & NS_STYLE_CLIP_RIGHT_AUTO) {
              vrect->mRight.SetAutoValue();
            } else {
              vrect->mRight.SetIntegerCoordValue(srect.XMost());
            }
            if (effects->mClipFlags & NS_STYLE_CLIP_BOTTOM_AUTO) {
              vrect->mBottom.SetAutoValue();
            } else {
              vrect->mBottom.SetIntegerCoordValue(srect.YMost());
            }
            if (effects->mClipFlags & NS_STYLE_CLIP_LEFT_AUTO) {
              vrect->mLeft.SetAutoValue();
            } else {
              vrect->mLeft.SetIntegerCoordValue(srect.x);
            }
            aComputedValue.SetAndAdoptCSSRectValue(vrect, eUnit_CSSRect);
          }
          break;
        }

        case eCSSProperty_object_position: {
          const nsStylePosition* stylePos =
            static_cast<const nsStylePosition*>(styleStruct);

          nsAutoPtr<nsCSSValue> val(new nsCSSValue);
          SetPositionValue(stylePos->mObjectPosition, *val);

          aComputedValue.SetAndAdoptCSSValueValue(val.forget(),
                                                  eUnit_ObjectPosition);
          break;
        }

        case eCSSProperty_background_position_x: {
          const nsStyleImageLayers& layers =
            static_cast<const nsStyleBackground*>(styleStruct)->mImage;
          ExtractImageLayerPositionXList(layers, aComputedValue);
          break;
        }
        case eCSSProperty_background_position_y: {
          const nsStyleImageLayers& layers =
            static_cast<const nsStyleBackground*>(styleStruct)->mImage;
          ExtractImageLayerPositionYList(layers, aComputedValue);
          break;




        }
#ifdef MOZ_ENABLE_MASK_AS_SHORTHAND
        case eCSSProperty_mask_position_x: {
          const nsStyleImageLayers& layers =
            static_cast<const nsStyleSVGReset*>(styleStruct)->mMask;
          ExtractImageLayerPositionXList(layers, aComputedValue);
          break;
        }
        case eCSSProperty_mask_position_y: {
          const nsStyleImageLayers& layers =
            static_cast<const nsStyleSVGReset*>(styleStruct)->mMask;
          ExtractImageLayerPositionYList(layers, aComputedValue);

          break;
        }
#endif
        case eCSSProperty_background_size: {
          const nsStyleImageLayers& layers =
            static_cast<const nsStyleBackground*>(styleStruct)->mImage;
          ExtractImageLayerSizePairList(layers, aComputedValue);
          break;
        }
#ifdef MOZ_ENABLE_MASK_AS_SHORTHAND
        case eCSSProperty_mask_size: {
          const nsStyleImageLayers& layers =
            static_cast<const nsStyleSVGReset*>(styleStruct)->mMask;
          ExtractImageLayerSizePairList(layers, aComputedValue);
          break;
        }
#endif

        case eCSSProperty_clip_path: {
          const nsStyleSVGReset* svgReset =
            static_cast<const nsStyleSVGReset*>(styleStruct);
          const StyleClipPath& clipPath = svgReset->mClipPath;
          const StyleShapeSourceType type = clipPath.GetType();

          if (type == StyleShapeSourceType::URL) {
            auto result = MakeUnique<nsCSSValue>();
            result->SetURLValue(clipPath.GetURL());
            aComputedValue.SetAndAdoptCSSValueValue(result.release(), eUnit_URL);
          } else if (type == StyleShapeSourceType::Box) {
            aComputedValue.SetIntValue(clipPath.GetReferenceBox(),
                                       eUnit_Enumerated);
          } else if (type == StyleShapeSourceType::Shape) {
            RefPtr<nsCSSValue::Array> result = nsCSSValue::Array::Create(2);
            if (!StyleClipBasicShapeToCSSArray(clipPath, result)) {
              return false;
            }
            aComputedValue.SetCSSValueArrayValue(result, eUnit_Shape);

          } else {
            MOZ_ASSERT(type == StyleShapeSourceType::None, "unknown type");
            aComputedValue.SetNoneValue();
          }
          break;
        }

        case eCSSProperty_filter: {
          const nsStyleEffects* effects =
            static_cast<const nsStyleEffects*>(styleStruct);
          const nsTArray<nsStyleFilter>& filters = effects->mFilters;
          nsAutoPtr<nsCSSValueList> result;
          nsCSSValueList **resultTail = getter_Transfers(result);
          for (uint32_t i = 0; i < filters.Length(); ++i) {
            nsCSSValueList *item = new nsCSSValueList;
            *resultTail = item;
            resultTail = &item->mNext;
            const nsStyleFilter& filter = filters[i];
            int32_t type = filter.GetType();
            if (type == NS_STYLE_FILTER_URL) {
              item->mValue.SetURLValue(filter.GetURL());
            } else {
              nsCSSKeyword functionName =
                nsCSSProps::ValueToKeywordEnum(type,
                  nsCSSProps::kFilterFunctionKTable);
              nsCSSValue::Array* filterArray =
                item->mValue.InitFunction(functionName, 1);
              if (type >= NS_STYLE_FILTER_BLUR && type <= NS_STYLE_FILTER_HUE_ROTATE) {
                if (!StyleCoordToCSSValue(
                      filter.GetFilterParameter(),
                      filterArray->Item(1))) {
                  return false;
                }
              } else if (type == NS_STYLE_FILTER_DROP_SHADOW) {
                nsCSSValueList* shadowResult = filterArray->Item(1).SetListValue();
                nsAutoPtr<nsCSSValueList> tmpShadowValue;
                nsCSSValueList **tmpShadowResultTail = getter_Transfers(tmpShadowValue);
                nsCSSShadowArray* shadowArray = filter.GetDropShadow();
                MOZ_ASSERT(shadowArray->Length() == 1,
                           "expected exactly one shadow");
                AppendCSSShadowValue(shadowArray->ShadowAt(0), tmpShadowResultTail);
                *shadowResult = *tmpShadowValue;
              } else {
                // We checked all possible nsStyleFilter types but
                // NS_STYLE_FILTER_NULL before. We should never enter this path.
                NS_NOTREACHED("no other filter functions defined");
                return false;
              }
            }
          }

          aComputedValue.SetAndAdoptCSSValueListValue(result.forget(),
                                                      eUnit_Filter);
          break;
        }

        case eCSSProperty_transform: {
          const nsStyleDisplay *display =
            static_cast<const nsStyleDisplay*>(styleStruct);
          nsAutoPtr<nsCSSValueList> result;
          if (display->mSpecifiedTransform) {
            // Clone, and convert all lengths (not percents) to pixels.
            nsCSSValueList **resultTail = getter_Transfers(result);
            for (const nsCSSValueList *l = display->mSpecifiedTransform->mHead;
                 l; l = l->mNext) {
              nsCSSValueList *clone = new nsCSSValueList;
              *resultTail = clone;
              resultTail = &clone->mNext;

              SubstitutePixelValues(aStyleContext, l->mValue, clone->mValue);
            }
          } else {
            result = new nsCSSValueList();
            result->mValue.SetNoneValue();
          }

          aComputedValue.SetTransformValue(
              new nsCSSValueSharedList(result.forget()));
          break;
        }

        default:
          MOZ_ASSERT(false, "missing property implementation");
          return false;
      };
      return true;
    case eStyleAnimType_Coord: {
      const nsStyleCoord& coord =
        StyleDataAtOffset<nsStyleCoord>(styleStruct, ssOffset);
      if (nsCSSProps::PropHasFlags(aProperty, CSS_PROPERTY_NUMBERS_ARE_PIXELS) &&
          coord.GetUnit() == eStyleUnit_Coord) {
        // For SVG properties where number means the same thing as length,
        // we want to animate them the same way.  Normalize both to number
        // since it has more accuracy (float vs nscoord).
        aComputedValue.SetFloatValue(nsPresContext::
          AppUnitsToFloatCSSPixels(coord.GetCoordValue()));
        return true;
      }
      return StyleCoordToValue(coord, aComputedValue);
    }
    case eStyleAnimType_Sides_Top:
    case eStyleAnimType_Sides_Right:
    case eStyleAnimType_Sides_Bottom:
    case eStyleAnimType_Sides_Left: {
      static_assert(
       NS_SIDE_TOP    == eStyleAnimType_Sides_Top   -eStyleAnimType_Sides_Top &&
       NS_SIDE_RIGHT  == eStyleAnimType_Sides_Right -eStyleAnimType_Sides_Top &&
       NS_SIDE_BOTTOM == eStyleAnimType_Sides_Bottom-eStyleAnimType_Sides_Top &&
       NS_SIDE_LEFT   == eStyleAnimType_Sides_Left  -eStyleAnimType_Sides_Top,
       "box side constants out of sync with animation side constants");

      const nsStyleCoord &coord =
        StyleDataAtOffset<nsStyleSides>(styleStruct, ssOffset).
          Get(mozilla::css::Side(animType - eStyleAnimType_Sides_Top));
      return StyleCoordToValue(coord, aComputedValue);
    }
    case eStyleAnimType_Corner_TopLeft:
    case eStyleAnimType_Corner_TopRight:
    case eStyleAnimType_Corner_BottomRight:
    case eStyleAnimType_Corner_BottomLeft: {
      static_assert(
       NS_CORNER_TOP_LEFT     == eStyleAnimType_Corner_TopLeft -
                                 eStyleAnimType_Corner_TopLeft        &&
       NS_CORNER_TOP_RIGHT    == eStyleAnimType_Corner_TopRight -
                                 eStyleAnimType_Corner_TopLeft        &&
       NS_CORNER_BOTTOM_RIGHT == eStyleAnimType_Corner_BottomRight -
                                 eStyleAnimType_Corner_TopLeft        &&
       NS_CORNER_BOTTOM_LEFT  == eStyleAnimType_Corner_BottomLeft -
                                 eStyleAnimType_Corner_TopLeft,
       "box corner constants out of sync with animation corner constants");

      const nsStyleCorners& corners =
        StyleDataAtOffset<nsStyleCorners>(styleStruct, ssOffset);
      uint8_t fullCorner = animType - eStyleAnimType_Corner_TopLeft;
      const nsStyleCoord &horiz =
        corners.Get(NS_FULL_TO_HALF_CORNER(fullCorner, false));
      const nsStyleCoord &vert =
        corners.Get(NS_FULL_TO_HALF_CORNER(fullCorner, true));
      nsAutoPtr<nsCSSValuePair> pair(new nsCSSValuePair);
      if (!StyleCoordToCSSValue(horiz, pair->mXValue) ||
          !StyleCoordToCSSValue(vert, pair->mYValue)) {
        return false;
      }
      aComputedValue.SetAndAdoptCSSValuePairValue(pair.forget(),
                                                  eUnit_CSSValuePair);
      return true;
    }
    case eStyleAnimType_nscoord:
      aComputedValue.SetCoordValue(
        StyleDataAtOffset<nscoord>(styleStruct, ssOffset));
      return true;
    case eStyleAnimType_float:
      aComputedValue.SetFloatValue(
        StyleDataAtOffset<float>(styleStruct, ssOffset));
      if (aProperty == eCSSProperty_font_size_adjust &&
          aComputedValue.GetFloatValue() == -1.0f) {
        // In nsStyleFont, we set mFont.sizeAdjust to -1.0 to represent
        // font-size-adjust: none.  Here, we have to treat this as a keyword
        // instead of a float value, to make sure we don't end up doing
        // interpolation with it.
        aComputedValue.SetNoneValue();
      }
      return true;
    case eStyleAnimType_Color:
      aComputedValue.SetColorValue(
        StyleDataAtOffset<nscolor>(styleStruct, ssOffset));
      return true;
    case eStyleAnimType_ComplexColor: {
      aComputedValue.SetComplexColorValue(
        StyleDataAtOffset<StyleComplexColor>(styleStruct, ssOffset));
      return true;
    }
    case eStyleAnimType_PaintServer: {
      const nsStyleSVGPaint& paint =
        StyleDataAtOffset<nsStyleSVGPaint>(styleStruct, ssOffset);
      switch (paint.Type()) {
        case eStyleSVGPaintType_Color:
          aComputedValue.SetColorValue(paint.GetColor());
          return true;
        case eStyleSVGPaintType_Server: {
          css::URLValue* url = paint.GetPaintServer();
          if (!url) {
            NS_WARNING("Null paint server");
            return false;
          }
          nsAutoPtr<nsCSSValuePair> pair(new nsCSSValuePair);
          pair->mXValue.SetURLValue(url);
          pair->mYValue.SetColorValue(paint.GetFallbackColor());
          aComputedValue.SetAndAdoptCSSValuePairValue(pair.forget(),
                                                      eUnit_CSSValuePair);
          return true;
        }
        case eStyleSVGPaintType_ContextFill:
        case eStyleSVGPaintType_ContextStroke: {
          nsAutoPtr<nsCSSValuePair> pair(new nsCSSValuePair);
          pair->mXValue.SetIntValue(paint.Type() == eStyleSVGPaintType_ContextFill ?
                                    NS_COLOR_CONTEXT_FILL : NS_COLOR_CONTEXT_STROKE,
                                    eCSSUnit_Enumerated);
          pair->mYValue.SetColorValue(paint.GetFallbackColor());
          aComputedValue.SetAndAdoptCSSValuePairValue(pair.forget(),
                                                      eUnit_CSSValuePair);
          return true;
        }
        default:
          MOZ_ASSERT(paint.Type() == eStyleSVGPaintType_None,
                     "Unexpected SVG paint type");
          aComputedValue.SetNoneValue();
          return true;
      }
    }
    case eStyleAnimType_Shadow: {
      const nsCSSShadowArray* shadowArray =
        StyleDataAtOffset<RefPtr<nsCSSShadowArray>>(styleStruct, ssOffset);
      if (!shadowArray) {
        aComputedValue.SetAndAdoptCSSValueListValue(nullptr, eUnit_Shadow);
        return true;
      }
      nsAutoPtr<nsCSSValueList> result;
      nsCSSValueList **resultTail = getter_Transfers(result);
      for (uint32_t i = 0, i_end = shadowArray->Length(); i < i_end; ++i) {
        AppendCSSShadowValue(shadowArray->ShadowAt(i), resultTail);
      }
      aComputedValue.SetAndAdoptCSSValueListValue(result.forget(),
                                                  eUnit_Shadow);
      return true;
    }
    case eStyleAnimType_Discrete: {
      if (aProperty == eCSSProperty_visibility) {
        aComputedValue.SetIntValue(
          static_cast<const nsStyleVisibility*>(styleStruct)->mVisible,
          eUnit_Visibility);
        return true;
      }
      auto cssValue = MakeUnique<nsCSSValue>(eCSSUnit_Unset);
      aStyleContext->RuleNode()->GetDiscretelyAnimatedCSSValue(aProperty,
                                                               cssValue.get());
      aComputedValue.SetAndAdoptCSSValueValue(cssValue.release(),
                                              eUnit_DiscreteCSSValue);
      return true;
    }
    case eStyleAnimType_None:
      NS_NOTREACHED("shouldn't use on non-animatable properties");
  }
  return false;
}

gfxSize
StyleAnimationValue::GetScaleValue(const nsIFrame* aForFrame) const
{
  MOZ_ASSERT(aForFrame);
  MOZ_ASSERT(GetUnit() == StyleAnimationValue::eUnit_Transform);

  nsCSSValueSharedList* list = GetCSSValueSharedListValue();
  MOZ_ASSERT(list->mHead);

  RuleNodeCacheConditions dontCare;
  bool dontCareBool;
  nsStyleTransformMatrix::TransformReferenceBox refBox(aForFrame);
  Matrix4x4 transform = nsStyleTransformMatrix::ReadTransforms(
                          list->mHead,
                          aForFrame->StyleContext(),
                          aForFrame->PresContext(), dontCare, refBox,
                          aForFrame->PresContext()->AppUnitsPerDevPixel(),
                          &dontCareBool);

  Matrix transform2d;
  bool canDraw2D = transform.CanDraw2D(&transform2d);
  if (!canDraw2D) {
    return gfxSize();
  }

  return ThebesMatrix(transform2d).ScaleFactors(true);
}

StyleAnimationValue::StyleAnimationValue(int32_t aInt, Unit aUnit,
                                         IntegerConstructorType)
{
  NS_ASSERTION(IsIntUnit(aUnit), "unit must be of integer type");
  mUnit = aUnit;
  mValue.mInt = aInt;
}

StyleAnimationValue::StyleAnimationValue(nscoord aLength, CoordConstructorType)
{
  mUnit = eUnit_Coord;
  mValue.mCoord = aLength;
}

StyleAnimationValue::StyleAnimationValue(float aPercent,
                                         PercentConstructorType)
{
  mUnit = eUnit_Percent;
  mValue.mFloat = aPercent;
  MOZ_ASSERT(!mozilla::IsNaN(mValue.mFloat));
}

StyleAnimationValue::StyleAnimationValue(float aFloat, FloatConstructorType)
{
  mUnit = eUnit_Float;
  mValue.mFloat = aFloat;
  MOZ_ASSERT(!mozilla::IsNaN(mValue.mFloat));
}

StyleAnimationValue::StyleAnimationValue(nscolor aColor, ColorConstructorType)
{
  mUnit = eUnit_Color;
  mValue.mCSSValue = new nsCSSValue();
  mValue.mCSSValue->SetColorValue(aColor);
}

StyleAnimationValue&
StyleAnimationValue::operator=(const StyleAnimationValue& aOther)
{
  if (this == &aOther) {
    return *this;
  }

  FreeValue();

  mUnit = aOther.mUnit;
  switch (mUnit) {
    case eUnit_Null:
    case eUnit_Normal:
    case eUnit_Auto:
    case eUnit_None:
    case eUnit_CurrentColor:
      break;
    case eUnit_Enumerated:
    case eUnit_Visibility:
    case eUnit_Integer:
      mValue.mInt = aOther.mValue.mInt;
      break;
    case eUnit_Coord:
      mValue.mCoord = aOther.mValue.mCoord;
      break;
    case eUnit_Percent:
    case eUnit_Float:
      mValue.mFloat = aOther.mValue.mFloat;
      MOZ_ASSERT(!mozilla::IsNaN(mValue.mFloat));
      break;
    case eUnit_Calc:
    case eUnit_Color:
    case eUnit_ObjectPosition:
    case eUnit_URL:
    case eUnit_DiscreteCSSValue:
      MOZ_ASSERT(IsCSSValueUnit(mUnit),
                 "This clause is for handling nsCSSValue-backed units");
      MOZ_ASSERT(aOther.mValue.mCSSValue, "values may not be null");
      mValue.mCSSValue = new nsCSSValue(*aOther.mValue.mCSSValue);
      break;
    case eUnit_CSSValuePair:
      MOZ_ASSERT(aOther.mValue.mCSSValuePair,
                 "value pairs may not be null");
      mValue.mCSSValuePair = new nsCSSValuePair(*aOther.mValue.mCSSValuePair);
      break;
    case eUnit_CSSValueTriplet:
      MOZ_ASSERT(aOther.mValue.mCSSValueTriplet,
                 "value triplets may not be null");
      mValue.mCSSValueTriplet = new nsCSSValueTriplet(*aOther.mValue.mCSSValueTriplet);
      break;
    case eUnit_CSSRect:
      MOZ_ASSERT(aOther.mValue.mCSSRect, "rects may not be null");
      mValue.mCSSRect = new nsCSSRect(*aOther.mValue.mCSSRect);
      break;
    case eUnit_Dasharray:
    case eUnit_Shadow:
    case eUnit_Filter:
    case eUnit_BackgroundPositionCoord:
      MOZ_ASSERT(mUnit == eUnit_Shadow || mUnit == eUnit_Filter ||
                 aOther.mValue.mCSSValueList,
                 "value lists other than shadows and filters may not be null");
      if (aOther.mValue.mCSSValueList) {
        mValue.mCSSValueList = aOther.mValue.mCSSValueList->Clone();
      } else {
        mValue.mCSSValueList = nullptr;
      }
      break;
    case eUnit_Shape:
      MOZ_ASSERT(aOther.mValue.mCSSValueArray,
                 "value arrays may not be null");
      mValue.mCSSValueArray = aOther.mValue.mCSSValueArray;
      mValue.mCSSValueArray->AddRef();
      break;
    case eUnit_Transform:
      mValue.mCSSValueSharedList = aOther.mValue.mCSSValueSharedList;
      mValue.mCSSValueSharedList->AddRef();
      break;
    case eUnit_CSSValuePairList:
      MOZ_ASSERT(aOther.mValue.mCSSValuePairList,
                 "value pair lists may not be null");
      mValue.mCSSValuePairList = aOther.mValue.mCSSValuePairList->Clone();
      break;
    case eUnit_UnparsedString:
      MOZ_ASSERT(aOther.mValue.mString, "expecting non-null string");
      mValue.mString = aOther.mValue.mString;
      mValue.mString->AddRef();
      break;
    case eUnit_ComplexColor:
      MOZ_ASSERT(aOther.mValue.mComplexColor);
      mValue.mComplexColor = aOther.mValue.mComplexColor;
      mValue.mComplexColor->AddRef();
      break;
  }

  return *this;
}

void
StyleAnimationValue::SetNormalValue()
{
  FreeValue();
  mUnit = eUnit_Normal;
}

void
StyleAnimationValue::SetAutoValue()
{
  FreeValue();
  mUnit = eUnit_Auto;
}

void
StyleAnimationValue::SetNoneValue()
{
  FreeValue();
  mUnit = eUnit_None;
}

void
StyleAnimationValue::SetIntValue(int32_t aInt, Unit aUnit)
{
  NS_ASSERTION(IsIntUnit(aUnit), "unit must be of integer type");
  FreeValue();
  mUnit = aUnit;
  mValue.mInt = aInt;
}

void
StyleAnimationValue::SetCoordValue(nscoord aLength)
{
  FreeValue();
  mUnit = eUnit_Coord;
  mValue.mCoord = aLength;
}

void
StyleAnimationValue::SetPercentValue(float aPercent)
{
  FreeValue();
  mUnit = eUnit_Percent;
  mValue.mFloat = aPercent;
  MOZ_ASSERT(!mozilla::IsNaN(mValue.mFloat));
}

void
StyleAnimationValue::SetFloatValue(float aFloat)
{
  FreeValue();
  mUnit = eUnit_Float;
  mValue.mFloat = aFloat;
  MOZ_ASSERT(!mozilla::IsNaN(mValue.mFloat));
}

void
StyleAnimationValue::SetColorValue(nscolor aColor)
{
  FreeValue();
  mUnit = eUnit_Color;
  mValue.mCSSValue = new nsCSSValue();
  mValue.mCSSValue->SetColorValue(aColor);
}

void
StyleAnimationValue::SetCurrentColorValue()
{
  FreeValue();
  mUnit = eUnit_CurrentColor;
}

void
StyleAnimationValue::SetComplexColorValue(const StyleComplexColor& aColor)
{
  if (aColor.IsCurrentColor()) {
    SetCurrentColorValue();
  } else if (aColor.IsNumericColor()) {
    SetColorValue(aColor.mColor);
  } else {
    SetComplexColorValue(do_AddRef(new ComplexColorValue(aColor)));
  }
}

void
StyleAnimationValue::SetComplexColorValue(
  already_AddRefed<ComplexColorValue> aValue)
{
  FreeValue();
  mUnit = eUnit_ComplexColor;
  mValue.mComplexColor = aValue.take();
}

void
StyleAnimationValue::SetUnparsedStringValue(const nsString& aString)
{
  FreeValue();
  mUnit = eUnit_UnparsedString;
  mValue.mString = nsCSSValue::BufferFromString(aString).take();
}

void
StyleAnimationValue::SetAndAdoptCSSValueValue(nsCSSValue *aValue,
                                              Unit aUnit)
{
  FreeValue();
  MOZ_ASSERT(IsCSSValueUnit(aUnit), "bad unit");
  MOZ_ASSERT(aValue != nullptr, "values may not be null");
  mUnit = aUnit;
  mValue.mCSSValue = aValue; // take ownership
}

void
StyleAnimationValue::SetAndAdoptCSSValuePairValue(nsCSSValuePair *aValuePair,
                                                  Unit aUnit)
{
  FreeValue();
  MOZ_ASSERT(IsCSSValuePairUnit(aUnit), "bad unit");
  MOZ_ASSERT(aValuePair != nullptr, "value pairs may not be null");
  mUnit = aUnit;
  mValue.mCSSValuePair = aValuePair; // take ownership
}

void
StyleAnimationValue::SetAndAdoptCSSValueTripletValue(
                       nsCSSValueTriplet *aValueTriplet, Unit aUnit)
{
  FreeValue();
  MOZ_ASSERT(IsCSSValueTripletUnit(aUnit), "bad unit");
  MOZ_ASSERT(aValueTriplet != nullptr, "value pairs may not be null");
  mUnit = aUnit;
  mValue.mCSSValueTriplet = aValueTriplet; // take ownership
}

void
StyleAnimationValue::SetAndAdoptCSSRectValue(nsCSSRect *aRect, Unit aUnit)
{
  FreeValue();
  MOZ_ASSERT(IsCSSRectUnit(aUnit), "bad unit");
  MOZ_ASSERT(aRect != nullptr, "value pairs may not be null");
  mUnit = aUnit;
  mValue.mCSSRect = aRect; // take ownership
}

void
StyleAnimationValue::SetCSSValueArrayValue(nsCSSValue::Array* aValue,
                                           Unit aUnit)
{
  FreeValue();
  MOZ_ASSERT(IsCSSValueArrayUnit(aUnit), "bad unit");
  MOZ_ASSERT(aValue != nullptr,
             "not currently expecting any arrays to be null");
  mUnit = aUnit;
  mValue.mCSSValueArray = aValue;
  mValue.mCSSValueArray->AddRef();
}

void
StyleAnimationValue::SetAndAdoptCSSValueListValue(nsCSSValueList *aValueList,
                                                  Unit aUnit)
{
  FreeValue();
  MOZ_ASSERT(IsCSSValueListUnit(aUnit), "bad unit");
  MOZ_ASSERT(aUnit == eUnit_Shadow || aUnit == eUnit_Filter ||
             aValueList != nullptr,
             "value lists other than shadows and filters may not be null");
  mUnit = aUnit;
  mValue.mCSSValueList = aValueList; // take ownership
}

void
StyleAnimationValue::SetTransformValue(nsCSSValueSharedList* aList)
{
  FreeValue();
  mUnit = eUnit_Transform;
  mValue.mCSSValueSharedList = aList;
  mValue.mCSSValueSharedList->AddRef();
}

void
StyleAnimationValue::SetAndAdoptCSSValuePairListValue(
                       nsCSSValuePairList *aValuePairList)
{
  FreeValue();
  MOZ_ASSERT(aValuePairList, "may not be null");
  mUnit = eUnit_CSSValuePairList;
  mValue.mCSSValuePairList = aValuePairList; // take ownership
}

void
StyleAnimationValue::FreeValue()
{
  if (IsCSSValueUnit(mUnit)) {
    delete mValue.mCSSValue;
  } else if (IsCSSValueListUnit(mUnit)) {
    delete mValue.mCSSValueList;
  } else if (IsCSSValueSharedListValue(mUnit)) {
    mValue.mCSSValueSharedList->Release();
  } else if (IsCSSValuePairUnit(mUnit)) {
    delete mValue.mCSSValuePair;
  } else if (IsCSSValueTripletUnit(mUnit)) {
    delete mValue.mCSSValueTriplet;
  } else if (IsCSSRectUnit(mUnit)) {
    delete mValue.mCSSRect;
  } else if (IsCSSValuePairListUnit(mUnit)) {
    delete mValue.mCSSValuePairList;
  } else if (IsCSSValueArrayUnit(mUnit)) {
    mValue.mCSSValueArray->Release();
  } else if (IsStringUnit(mUnit)) {
    MOZ_ASSERT(mValue.mString, "expecting non-null string");
    mValue.mString->Release();
  } else if (mUnit == eUnit_ComplexColor) {
    mValue.mComplexColor->Release();
  }
}

bool
StyleAnimationValue::operator==(const StyleAnimationValue& aOther) const
{
  if (mUnit != aOther.mUnit) {
    return false;
  }

  switch (mUnit) {
    case eUnit_Null:
    case eUnit_Normal:
    case eUnit_Auto:
    case eUnit_None:
    case eUnit_CurrentColor:
      return true;
    case eUnit_Enumerated:
    case eUnit_Visibility:
    case eUnit_Integer:
      return mValue.mInt == aOther.mValue.mInt;
    case eUnit_Coord:
      return mValue.mCoord == aOther.mValue.mCoord;
    case eUnit_Percent:
    case eUnit_Float:
      return mValue.mFloat == aOther.mValue.mFloat;
    case eUnit_Calc:
    case eUnit_Color:
    case eUnit_ObjectPosition:
    case eUnit_URL:
    case eUnit_DiscreteCSSValue:
      MOZ_ASSERT(IsCSSValueUnit(mUnit),
                 "This clause is for handling nsCSSValue-backed units");
      return *mValue.mCSSValue == *aOther.mValue.mCSSValue;
    case eUnit_CSSValuePair:
      return *mValue.mCSSValuePair == *aOther.mValue.mCSSValuePair;
    case eUnit_CSSValueTriplet:
      return *mValue.mCSSValueTriplet == *aOther.mValue.mCSSValueTriplet;
    case eUnit_CSSRect:
      return *mValue.mCSSRect == *aOther.mValue.mCSSRect;
    case eUnit_Dasharray:
    case eUnit_Shadow:
    case eUnit_Filter:
    case eUnit_BackgroundPositionCoord:
      return nsCSSValueList::Equal(mValue.mCSSValueList,
                                   aOther.mValue.mCSSValueList);
    case eUnit_Shape:
      return *mValue.mCSSValueArray == *aOther.mValue.mCSSValueArray;
    case eUnit_Transform:
      return *mValue.mCSSValueSharedList == *aOther.mValue.mCSSValueSharedList;
    case eUnit_CSSValuePairList:
      return nsCSSValuePairList::Equal(mValue.mCSSValuePairList,
                                       aOther.mValue.mCSSValuePairList);
    case eUnit_UnparsedString:
      return (NS_strcmp(GetStringBufferValue(),
                        aOther.GetStringBufferValue()) == 0);
    case eUnit_ComplexColor:
      return *mValue.mComplexColor == *aOther.mValue.mComplexColor;
  }

  NS_NOTREACHED("incomplete case");
  return false;
}
