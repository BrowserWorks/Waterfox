/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_layers_AndroidAPZ_h_
#define mozilla_layers_AndroidAPZ_h_

#include "AsyncPanZoomAnimation.h"
#include "AsyncPanZoomController.h"
#include "mozilla/java/StackScrollerWrappers.h"

namespace mozilla {
namespace layers {

class AndroidSpecificState : public PlatformSpecificStateBase {
 public:
  AndroidSpecificState();

  virtual AndroidSpecificState* AsAndroidSpecificState() override {
    return this;
  }

  virtual AsyncPanZoomAnimation* CreateFlingAnimation(
      AsyncPanZoomController& aApzc, const FlingHandoffState& aHandoffState,
      float aPLPPI) override;
  virtual UniquePtr<VelocityTracker> CreateVelocityTracker(
      Axis* aAxis) override;

  static void InitializeGlobalState();

  java::StackScroller::GlobalRef mOverScroller;
  TimeStamp mLastFling;
};

class StackScrollerFlingAnimation : public AsyncPanZoomAnimation {
 public:
  StackScrollerFlingAnimation(
      AsyncPanZoomController& aApzc,
      PlatformSpecificStateBase* aPlatformSpecificState,
      const RefPtr<const OverscrollHandoffChain>& aOverscrollHandoffChain,
      bool aFlingIsHandoff /* ignored */,
      const RefPtr<const AsyncPanZoomController>& aScrolledApzc);
  virtual bool DoSample(FrameMetrics& aFrameMetrics,
                        const TimeDuration& aDelta) override;

 private:
  void DeferHandleFlingOverscroll(ParentLayerPoint& aVelocity);
  // Returns true if value is on or outside of axis bounds.
  bool CheckBounds(Axis& aAxis, float aValue, float aDirection,
                   float* aClamped);

  AsyncPanZoomController& mApzc;
  java::StackScroller::GlobalRef mOverScroller;
  RefPtr<const OverscrollHandoffChain> mOverscrollHandoffChain;
  RefPtr<const AsyncPanZoomController> mScrolledApzc;
  bool mSentBounceX;
  bool mSentBounceY;
  long mFlingDuration;
  ParentLayerPoint mStartOffset;
  ParentLayerPoint mPreviousOffset;
  // Unit vector in the direction of the fling.
  ParentLayerPoint mFlingDirection;
  ParentLayerPoint mPreviousVelocity;
};

}  // namespace layers
}  // namespace mozilla

#endif  // mozilla_layers_AndroidAPZ_h_
