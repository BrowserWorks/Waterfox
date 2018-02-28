/* vim: set shiftwidth=2 tabstop=8 autoindent cindent expandtab: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
#ifndef CSSCalc_h_
#define CSSCalc_h_

#include "nsCSSValue.h"
#include "nsStyleCoord.h"
#include <math.h>
#include <type_traits>

namespace mozilla {

namespace css {

/**
 * ComputeCalc computes the result of a calc() expression tree.
 *
 * It is templatized over a CalcOps class that is expected to provide:
 *
 *   // input_type and input_array_type have a bunch of very specific
 *   // expectations (which happen to be met by two classes (nsCSSValue
 *   // and nsStyleCoord).  There must be methods (roughly):
 *   //   input_array_type* input_type::GetArrayValue();
 *   //   uint32_t input_array_type::Count() const;
 *   //   input_type& input_array_type::Item(uint32_t);
 *   typedef ... input_type;
 *   typedef ... input_array_type;
 *
 *   typedef ... coeff_type;
 *
 *   typedef ... result_type;
 *
 *   // GetUnit(avalue) must return the correct nsCSSUnit for any
 *   // value that represents a calc tree node (eCSSUnit_Calc*).  For
 *   // other nodes, it may return any non eCSSUnit_Calc* unit.
 *   static nsCSSUnit GetUnit(const input_type& aValue);
 *
 *   result_type
 *   MergeAdditive(nsCSSUnit aCalcFunction,
 *                 result_type aValue1, result_type aValue2);
 *
 *   result_type
 *   MergeMultiplicativeL(nsCSSUnit aCalcFunction,
 *                        coeff_type aValue1, result_type aValue2);
 *
 *   result_type
 *   MergeMultiplicativeR(nsCSSUnit aCalcFunction,
 *                        result_type aValue1, coeff_type aValue2);
 *
 *   bool
 *   ComputeLeafValue(result_type& aResult, const input_type& aValue);
 *
 *   coeff_type
 *   ComputeCoefficient(const coeff_type& aValue);
 *
 * The CalcOps methods might compute the calc() expression down to a
 * number, reduce some parts of it to a number but replicate other
 * parts, or produce a tree with a different data structure (for
 * example, nsCSS* for specified values vs nsStyle* for computed
 * values).
 *
 * For each leaf in the calc() expression, ComputeCalc will call either
 * ComputeCoefficient (when the leaf is the left side of a Times_L or the
 * right side of a Times_R or Divided) or ComputeLeafValue (otherwise).
 * (The CalcOps in the CSS parser that reduces purely numeric
 * expressions in turn calls ComputeCalc on numbers; other ops can
 * presume that expressions in the coefficient positions have already been
 * normalized to a single numeric value and derive from, if their coefficient
 * types are floats, FloatCoeffsAlreadyNormalizedCalcOps.)
 *
 * ComputeCalc will fail and return false if ComputeLeafValue returns false at
 * any point during the computation. ComputeLeafValue shall return false if and
 * only if an unexpected (i.e., inconsistent) unit is encountered.
 *
 * coeff_type will be float most of the time, but it's templatized so that
 * ParseCalc can be used with <integer>s too.
 *
 * For non-leaves, one of the Merge functions will be called:
 *   MergeAdditive for Plus and Minus
 *   MergeMultiplicativeL for Times_L (coeff * value)
 *   MergeMultiplicativeR for Times_R (value * coeff) and Divided
 */
template <class CalcOps>
static bool
ComputeCalc(typename CalcOps::result_type& aResult,
            const typename CalcOps::input_type& aValue, CalcOps &aOps)
{
  switch (CalcOps::GetUnit(aValue)) {
    case eCSSUnit_Calc: {
      typename CalcOps::input_array_type *arr = aValue.GetArrayValue();
      MOZ_ASSERT(arr->Count() == 1, "unexpected length");
      return ComputeCalc(aResult, arr->Item(0), aOps);
    }
    case eCSSUnit_Calc_Plus:
    case eCSSUnit_Calc_Minus: {
      typename CalcOps::input_array_type *arr = aValue.GetArrayValue();
      MOZ_ASSERT(arr->Count() == 2, "unexpected length");
      typename CalcOps::result_type lhs, rhs;
      if (!ComputeCalc(lhs, arr->Item(0), aOps) ||
          !ComputeCalc(rhs, arr->Item(1), aOps)) {
        return false;
      }
      aResult = aOps.MergeAdditive(CalcOps::GetUnit(aValue), lhs, rhs);
      return true;
    }
    case eCSSUnit_Calc_Times_L: {
      typename CalcOps::input_array_type *arr = aValue.GetArrayValue();
      MOZ_ASSERT(arr->Count() == 2, "unexpected length");
      typename CalcOps::coeff_type lhs = aOps.ComputeCoefficient(arr->Item(0));
      typename CalcOps::result_type rhs;
      if (!ComputeCalc(rhs, arr->Item(1), aOps)) {
        return false;
      }
      aResult = aOps.MergeMultiplicativeL(CalcOps::GetUnit(aValue), lhs, rhs);
      return true;
    }
    case eCSSUnit_Calc_Times_R:
    case eCSSUnit_Calc_Divided: {
      typename CalcOps::input_array_type *arr = aValue.GetArrayValue();
      MOZ_ASSERT(arr->Count() == 2, "unexpected length");
      typename CalcOps::result_type lhs;
      if (!ComputeCalc(lhs, arr->Item(0), aOps)) {
        return false;
      }
      typename CalcOps::coeff_type rhs = aOps.ComputeCoefficient(arr->Item(1));
      aResult = aOps.MergeMultiplicativeR(CalcOps::GetUnit(aValue), lhs, rhs);
      return true;
    }
    default: {
      return aOps.ComputeLeafValue(aResult, aValue);
    }
  }
}

/**
 * The input unit operation for input_type being nsCSSValue.
 */
struct CSSValueInputCalcOps
{
  typedef nsCSSValue input_type;
  typedef nsCSSValue::Array input_array_type;

  static nsCSSUnit GetUnit(const nsCSSValue& aValue)
  {
    return aValue.GetUnit();
  }

};

/**
 * Basic*CalcOps provide a partial implementation of the CalcOps
 * template parameter to ComputeCalc, for those callers whose merging
 * just consists of mathematics (rather than tree construction).
 */

struct BasicCoordCalcOps
{
  typedef nscoord result_type;
  typedef float coeff_type;

  result_type
  MergeAdditive(nsCSSUnit aCalcFunction,
                result_type aValue1, result_type aValue2)
  {
    if (aCalcFunction == eCSSUnit_Calc_Plus) {
      return NSCoordSaturatingAdd(aValue1, aValue2);
    }
    MOZ_ASSERT(aCalcFunction == eCSSUnit_Calc_Minus,
               "unexpected unit");
    return NSCoordSaturatingSubtract(aValue1, aValue2, 0);
  }

  result_type
  MergeMultiplicativeL(nsCSSUnit aCalcFunction,
                       coeff_type aValue1, result_type aValue2)
  {
    MOZ_ASSERT(aCalcFunction == eCSSUnit_Calc_Times_L,
               "unexpected unit");
    return NSCoordSaturatingMultiply(aValue2, aValue1);
  }

  result_type
  MergeMultiplicativeR(nsCSSUnit aCalcFunction,
                       result_type aValue1, coeff_type aValue2)
  {
    MOZ_ASSERT(aCalcFunction == eCSSUnit_Calc_Times_R ||
               aCalcFunction == eCSSUnit_Calc_Divided,
               "unexpected unit");
    if (aCalcFunction == eCSSUnit_Calc_Divided) {
      aValue2 = 1.0f / aValue2;
    }
    return NSCoordSaturatingMultiply(aValue1, aValue2);
  }
};

/**
 * A ComputeCoefficient implementation for callers that can assume coefficients
 * are floats and are already normalized (i.e., anything past the parser except
 * pure-integer calcs, whose coefficients are integers).
 */
struct FloatCoeffsAlreadyNormalizedOps : public CSSValueInputCalcOps
{
  typedef float coeff_type;

  coeff_type ComputeCoefficient(const nsCSSValue& aValue)
  {
    MOZ_ASSERT(aValue.GetUnit() == eCSSUnit_Number, "unexpected unit");
    return aValue.GetFloatValue();
  }
};

/**
 * SerializeCalc appends the serialization of aValue to a string.
 *
 * It is templatized over a CalcOps class that is expected to provide:
 *
 *   // input_type and input_array_type have a bunch of very specific
 *   // expectations (which happen to be met by two classes (nsCSSValue
 *   // and nsStyleCoord).  There must be methods (roughly):
 *   //   input_array_type* input_type::GetArrayValue();
 *   //   uint32_t input_array_type::Count() const;
 *   //   input_type& input_array_type::Item(uint32_t);
 *   typedef ... input_type;
 *   typedef ... input_array_type;
 *
 *   static nsCSSUnit GetUnit(const input_type& aValue);
 *
 *   void Append(const char* aString);
 *   void AppendLeafValue(const input_type& aValue);
 *
 *   // AppendCoefficient accepts an input_type value, which represents a
 *   // value in the coefficient position, not a value of coeff_type,
 *   // because we're serializing the calc() expression itself.
 *   void AppendCoefficient(const input_type& aValue);
 *
 * Data structures given may or may not have a toplevel eCSSUnit_Calc
 * node representing a calc whose toplevel is not min() or max().
 */

template <class CalcOps>
static void
SerializeCalcInternal(const typename CalcOps::input_type& aValue, CalcOps &aOps);

// Serialize the toplevel value in a calc() tree.  See big comment
// above.
template <class CalcOps>
static void
SerializeCalc(const typename CalcOps::input_type& aValue, CalcOps &aOps)
{
  aOps.Append("calc(");
  nsCSSUnit unit = CalcOps::GetUnit(aValue);
  if (unit == eCSSUnit_Calc) {
    const typename CalcOps::input_array_type *array = aValue.GetArrayValue();
    MOZ_ASSERT(array->Count() == 1, "unexpected length");
    SerializeCalcInternal(array->Item(0), aOps);
  } else {
    SerializeCalcInternal(aValue, aOps);
  }
  aOps.Append(")");
}

static inline bool
IsCalcAdditiveUnit(nsCSSUnit aUnit)
{
  return aUnit == eCSSUnit_Calc_Plus ||
         aUnit == eCSSUnit_Calc_Minus;
}

static inline bool
IsCalcMultiplicativeUnit(nsCSSUnit aUnit)
{
  return aUnit == eCSSUnit_Calc_Times_L ||
         aUnit == eCSSUnit_Calc_Times_R ||
         aUnit == eCSSUnit_Calc_Divided;
}

// Serialize a non-toplevel value in a calc() tree.  See big comment
// above.
template <class CalcOps>
/* static */ void
SerializeCalcInternal(const typename CalcOps::input_type& aValue, CalcOps &aOps)
{
  nsCSSUnit unit = CalcOps::GetUnit(aValue);
  if (IsCalcAdditiveUnit(unit)) {
    const typename CalcOps::input_array_type *array = aValue.GetArrayValue();
    MOZ_ASSERT(array->Count() == 2, "unexpected length");

    SerializeCalcInternal(array->Item(0), aOps);

    if (eCSSUnit_Calc_Plus == unit) {
      aOps.Append(" + ");
    } else {
      MOZ_ASSERT(eCSSUnit_Calc_Minus == unit, "unexpected unit");
      aOps.Append(" - ");
    }

    bool needParens = IsCalcAdditiveUnit(CalcOps::GetUnit(array->Item(1)));
    if (needParens) {
      aOps.Append("(");
    }
    SerializeCalcInternal(array->Item(1), aOps);
    if (needParens) {
      aOps.Append(")");
    }
  } else if (IsCalcMultiplicativeUnit(unit)) {
    const typename CalcOps::input_array_type *array = aValue.GetArrayValue();
    MOZ_ASSERT(array->Count() == 2, "unexpected length");

    bool needParens = IsCalcAdditiveUnit(CalcOps::GetUnit(array->Item(0)));
    if (needParens) {
      aOps.Append("(");
    }
    if (unit == eCSSUnit_Calc_Times_L) {
      aOps.AppendCoefficient(array->Item(0));
    } else {
      SerializeCalcInternal(array->Item(0), aOps);
    }
    if (needParens) {
      aOps.Append(")");
    }

    if (eCSSUnit_Calc_Times_L == unit || eCSSUnit_Calc_Times_R == unit) {
      aOps.Append(" * ");
    } else {
      MOZ_ASSERT(eCSSUnit_Calc_Divided == unit, "unexpected unit");
      aOps.Append(" / ");
    }

    nsCSSUnit subUnit = CalcOps::GetUnit(array->Item(1));
    needParens = IsCalcAdditiveUnit(subUnit) ||
                 IsCalcMultiplicativeUnit(subUnit);
    if (needParens) {
      aOps.Append("(");
    }
    if (unit == eCSSUnit_Calc_Times_L) {
      SerializeCalcInternal(array->Item(1), aOps);
    } else {
      aOps.AppendCoefficient(array->Item(1));
    }
    if (needParens) {
      aOps.Append(")");
    }
  } else {
    aOps.AppendLeafValue(aValue);
  }
}

/**
 * ReduceCalcOps is a CalcOps implementation for pure-number, pure-percent, and
 * pure-integer calc() (sub-)expressions, input as nsCSSValues.
 *
 * Instantiate with the appropriate coeff/result type and unit, for example:
 *   ReduceCalcOps<float, eCSSUnit_Percent>
 *   ReduceCalcOps<int, eCSSUnit_Integer>
 *   ReduceCalcOps<float, eCSSUnit_Number>
 *
 * For example, nsCSSParser::ParseCalcMultiplicativeExpression uses it to
 * simplify numeric sub-expressions in order to check for division-by-zero.
 */
template<typename type, nsCSSUnit unit>
struct ReduceCalcOps : public mozilla::css::CSSValueInputCalcOps
{
  static_assert((std::is_same<type, int>::value && unit == eCSSUnit_Integer) ||
                (std::is_same<type, float>::value &&
                 (unit == eCSSUnit_Number || unit == eCSSUnit_Percent)),
                "ReduceCalcOps: Invalid template arguments: must use "
                "int coefficient with eCSSUnit_Integer, or "
                "float coefficient with (eCSSUnit_Number or eCSSUnit_Percent)");

  typedef type result_type;
  typedef type coeff_type;

  result_type
  MergeAdditive(nsCSSUnit aCalcFunction,
                result_type aValue1, result_type aValue2)
  {
    if (aCalcFunction == eCSSUnit_Calc_Plus) {
      return aValue1 + aValue2;
    }
    MOZ_ASSERT(aCalcFunction == eCSSUnit_Calc_Minus, "unexpected unit");
    return aValue1 - aValue2;
  }

  result_type
  MergeMultiplicativeL(nsCSSUnit aCalcFunction,
                       coeff_type aValue1, result_type aValue2)
  {
    MOZ_ASSERT(aCalcFunction == eCSSUnit_Calc_Times_L, "unexpected unit");
    return aValue1 * aValue2;
  }

  result_type
  MergeMultiplicativeR(nsCSSUnit aCalcFunction,
                       result_type aValue1, coeff_type aValue2)
  {
    if (aCalcFunction == eCSSUnit_Calc_Times_R) {
      return aValue1 * aValue2;
    }
    MOZ_ASSERT(aCalcFunction == eCSSUnit_Calc_Divided, "unexpected unit");
    MOZ_ASSERT(unit != eCSSUnit_Integer,
               "We should catch and prevent divisions in integer "
               "calc()s in the parser");
    return aValue1 / aValue2;
  }

  bool ComputeLeafValue(result_type& aResult, const nsCSSValue& aValue)
  {
    if (aValue.GetUnit() != unit) {
      return false;
    }
    aResult = unit == eCSSUnit_Percent ? aValue.GetPercentValue() :
              unit == eCSSUnit_Integer ? aValue.GetIntValue() :
                                         aValue.GetFloatValue();
    return true;
  }

  coeff_type ComputeCoefficient(const nsCSSValue& aValue)
  {
    coeff_type coeff;
    if (!mozilla::css::ComputeCalc(coeff, aValue, *this)) {
      // Something's wrong; parser should enforce that calc() coefficients are
      // unitless, but failure in ComputeCalc means there was a unit mismatch.
      MOZ_ASSERT_UNREACHABLE("unexpected unit");
    }
    return coeff;
  }
};

} // namespace css

} // namespace mozilla

#endif /* !defined(CSSCalc_h_) */
