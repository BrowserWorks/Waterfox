/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/layers/APZUtils.h"

#include "AsyncPanZoomController.h"

namespace mozilla {
namespace layers {
namespace apz {

/*static*/ void InitializeGlobalState() {
  MOZ_ASSERT(NS_IsMainThread());
  AsyncPanZoomController::InitializeGlobalState();
}

/*static*/ const ScreenMargin CalculatePendingDisplayPort(
    const FrameMetrics& aFrameMetrics, const ParentLayerPoint& aVelocity) {
  return AsyncPanZoomController::CalculatePendingDisplayPort(aFrameMetrics,
                                                             aVelocity);
}

/*static*/ bool IsCloseToHorizontal(float aAngle, float aThreshold) {
  return (aAngle < aThreshold || aAngle > (M_PI - aThreshold));
}

/*static*/ bool IsCloseToVertical(float aAngle, float aThreshold) {
  return (fabs(aAngle - (M_PI / 2)) < aThreshold);
}

/*static*/ gfxFloat IntervalOverlap(gfxFloat aTranslation, gfxFloat aMin,
                                    gfxFloat aMax) {
  if (aTranslation > 0) {
    return std::max(0.0, std::min(aMax, aTranslation) - std::max(aMin, 0.0));
  }

  return std::min(0.0, std::max(aMin, aTranslation) - std::min(aMax, 0.0));
}

/*static*/ bool IsStuckAtBottom(gfxFloat aTranslation,
                                const LayerRectAbsolute& aInnerRange,
                                const LayerRectAbsolute& aOuterRange) {
  // The item will be stuck at the bottom if the async scroll delta is in
  // the range [aOuterRange.Y(), aInnerRange.Y()]. Since the translation
  // is negated with repect to the async scroll delta (i.e. scrolling down
  // produces a positive scroll delta and negative translation), we invert it
  // and check to see if it falls in the specified range.
  return aOuterRange.Y() <= -aTranslation && -aTranslation <= aInnerRange.Y();
}

/*static*/ bool IsStuckAtTop(gfxFloat aTranslation,
                             const LayerRectAbsolute& aInnerRange,
                             const LayerRectAbsolute& aOuterRange) {
  // Same as IsStuckAtBottom, except we want to check for the range
  // [aInnerRange.YMost(), aOuterRange.YMost()].
  return aInnerRange.YMost() <= -aTranslation &&
         -aTranslation <= aOuterRange.YMost();
}

}  // namespace apz
}  // namespace layers
}  // namespace mozilla
