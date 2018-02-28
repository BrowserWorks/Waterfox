/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/TimingParams.h"

#include "mozilla/AnimationUtils.h"
#include "mozilla/dom/AnimatableBinding.h"
#include "mozilla/dom/KeyframeAnimationOptionsBinding.h"
#include "mozilla/dom/KeyframeEffectBinding.h"
#include "mozilla/ServoBindings.h"
#include "nsCSSParser.h" // For nsCSSParser
#include "nsIDocument.h"
#include "nsRuleNode.h"

namespace mozilla {

template <class OptionsType>
static const dom::AnimationEffectTimingProperties&
GetTimingProperties(const OptionsType& aOptions);

template <>
/* static */ const dom::AnimationEffectTimingProperties&
GetTimingProperties(
  const dom::UnrestrictedDoubleOrKeyframeEffectOptions& aOptions)
{
  MOZ_ASSERT(aOptions.IsKeyframeEffectOptions());
  return aOptions.GetAsKeyframeEffectOptions();
}

template <>
/* static */ const dom::AnimationEffectTimingProperties&
GetTimingProperties(
  const dom::UnrestrictedDoubleOrKeyframeAnimationOptions& aOptions)
{
  MOZ_ASSERT(aOptions.IsKeyframeAnimationOptions());
  return aOptions.GetAsKeyframeAnimationOptions();
}

template <class OptionsType>
/* static */ TimingParams
TimingParams::FromOptionsType(const OptionsType& aOptions,
                              nsIDocument* aDocument,
                              ErrorResult& aRv)
{
  TimingParams result;
  if (aOptions.IsUnrestrictedDouble()) {
    double durationInMs = aOptions.GetAsUnrestrictedDouble();
    if (durationInMs >= 0) {
      result.mDuration.emplace(
        StickyTimeDuration::FromMilliseconds(durationInMs));
    } else {
      aRv.Throw(NS_ERROR_DOM_TYPE_ERR);
      return result;
    }
  } else {
    const dom::AnimationEffectTimingProperties& timing =
      GetTimingProperties(aOptions);

    Maybe<StickyTimeDuration> duration =
      TimingParams::ParseDuration(timing.mDuration, aRv);
    if (aRv.Failed()) {
      return result;
    }
    TimingParams::ValidateIterationStart(timing.mIterationStart, aRv);
    if (aRv.Failed()) {
      return result;
    }
    TimingParams::ValidateIterations(timing.mIterations, aRv);
    if (aRv.Failed()) {
      return result;
    }
    Maybe<ComputedTimingFunction> easing =
      TimingParams::ParseEasing(timing.mEasing, aDocument, aRv);
    if (aRv.Failed()) {
      return result;
    }

    result.mDuration = duration;
    result.mDelay = TimeDuration::FromMilliseconds(timing.mDelay);
    result.mEndDelay = TimeDuration::FromMilliseconds(timing.mEndDelay);
    result.mIterations = timing.mIterations;
    result.mIterationStart = timing.mIterationStart;
    result.mDirection = timing.mDirection;
    result.mFill = timing.mFill;
    result.mFunction = easing;
  }
  result.Update();

  return result;
}

/* static */ TimingParams
TimingParams::FromOptionsUnion(
  const dom::UnrestrictedDoubleOrKeyframeEffectOptions& aOptions,
  nsIDocument* aDocument,
  ErrorResult& aRv)
{
  return FromOptionsType(aOptions, aDocument, aRv);
}

/* static */ TimingParams
TimingParams::FromOptionsUnion(
  const dom::UnrestrictedDoubleOrKeyframeAnimationOptions& aOptions,
  nsIDocument* aDocument,
  ErrorResult& aRv)
{
  return FromOptionsType(aOptions, aDocument, aRv);
}

/* static */ Maybe<ComputedTimingFunction>
TimingParams::ParseEasing(const nsAString& aEasing,
                          nsIDocument* aDocument,
                          ErrorResult& aRv)
{
  MOZ_ASSERT(aDocument);

  if (aDocument->IsStyledByServo()) {
    nsTimingFunction timingFunction;
    // FIXME this is using the wrong base uri (bug 1343919)
    RefPtr<URLExtraData> data = new URLExtraData(aDocument->GetDocumentURI(),
                                                 aDocument->GetDocumentURI(),
                                                 aDocument->NodePrincipal());
    if (!Servo_ParseEasing(&aEasing, data, &timingFunction)) {
      aRv.ThrowTypeError<dom::MSG_INVALID_EASING_ERROR>(aEasing);
      return Nothing();
    }

    if (timingFunction.mType == nsTimingFunction::Type::Linear) {
      return Nothing();
    }

    return Some(ComputedTimingFunction(timingFunction));
  }

  nsCSSValue value;
  nsCSSParser parser;
  parser.ParseLonghandProperty(eCSSProperty_animation_timing_function,
                               aEasing,
                               aDocument->GetDocumentURI(),
                               aDocument->GetDocumentURI(),
                               aDocument->NodePrincipal(),
                               value);

  switch (value.GetUnit()) {
    case eCSSUnit_List: {
      const nsCSSValueList* list = value.GetListValue();
      if (list->mNext) {
        // don't support a list of timing functions
        break;
      }
      switch (list->mValue.GetUnit()) {
        case eCSSUnit_Enumerated:
          // Return Nothing() if "linear" is passed in.
          if (list->mValue.GetIntValue() ==
              NS_STYLE_TRANSITION_TIMING_FUNCTION_LINEAR) {
            return Nothing();
          }
          MOZ_FALLTHROUGH;
        case eCSSUnit_Cubic_Bezier:
        case eCSSUnit_Function:
        case eCSSUnit_Steps: {
          nsTimingFunction timingFunction;
          nsRuleNode::ComputeTimingFunction(list->mValue, timingFunction);
          return Some(ComputedTimingFunction(timingFunction));
        }
        default:
          MOZ_ASSERT_UNREACHABLE("unexpected animation-timing-function list "
                                 "item unit");
        break;
      }
      break;
    }
    case eCSSUnit_Inherit:
    case eCSSUnit_Initial:
    case eCSSUnit_Unset:
    case eCSSUnit_TokenStream:
    case eCSSUnit_Null:
      break;
    default:
      MOZ_ASSERT_UNREACHABLE("unexpected animation-timing-function unit");
      break;
  }

  aRv.ThrowTypeError<dom::MSG_INVALID_EASING_ERROR>(aEasing);
  return Nothing();
}

bool
TimingParams::operator==(const TimingParams& aOther) const
{
  // We don't compare mActiveDuration and mEndTime because they are calculated
  // from other timing parameters.
  return mDuration == aOther.mDuration &&
         mDelay == aOther.mDelay &&
         mIterations == aOther.mIterations &&
         mIterationStart == aOther.mIterationStart &&
         mDirection == aOther.mDirection &&
         mFill == aOther.mFill &&
         mFunction == aOther.mFunction;
}

} // namespace mozilla
