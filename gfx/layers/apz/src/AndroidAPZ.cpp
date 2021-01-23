/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "AndroidAPZ.h"

#include "AndroidFlingPhysics.h"
#include "AndroidVelocityTracker.h"
#include "AsyncPanZoomController.h"
#include "GenericFlingAnimation.h"
#include "OverscrollHandoffState.h"
#include "SimpleVelocityTracker.h"
#include "ViewConfiguration.h"
#include "mozilla/java/GeckoAppShellWrappers.h"
#include "mozilla/StaticPrefs_apz.h"

static mozilla::LazyLogModule sApzAndLog("apz.android");
#define ANDROID_APZ_LOG(...) MOZ_LOG(sApzAndLog, LogLevel::Debug, (__VA_ARGS__))

static float sMaxFlingSpeed = 0.0f;

namespace mozilla {
namespace layers {

AndroidSpecificState::AndroidSpecificState() {
  java::sdk::ViewConfiguration::LocalRef config;
  if (java::sdk::ViewConfiguration::Get(
          java::GeckoAppShell::GetApplicationContext(), &config) == NS_OK) {
    int32_t speed = 0;
    if (config->GetScaledMaximumFlingVelocity(&speed) == NS_OK) {
      sMaxFlingSpeed = (float)speed * 0.001f;
    } else {
      ANDROID_APZ_LOG(
          "%p Failed to query ViewConfiguration for scaled maximum fling "
          "velocity\n",
          this);
    }
  } else {
    ANDROID_APZ_LOG("%p Failed to get ViewConfiguration\n", this);
  }

  java::StackScroller::LocalRef scroller;
  if (java::StackScroller::New(java::GeckoAppShell::GetApplicationContext(),
                               &scroller) != NS_OK) {
    ANDROID_APZ_LOG("%p Failed to create Android StackScroller\n", this);
    return;
  }
  mOverScroller = scroller;
}

AsyncPanZoomAnimation* AndroidSpecificState::CreateFlingAnimation(
    AsyncPanZoomController& aApzc, const FlingHandoffState& aHandoffState,
    float aPLPPI) {
  if (StaticPrefs::apz_android_chrome_fling_physics_enabled()) {
    return new GenericFlingAnimation<AndroidFlingPhysics>(
        aApzc, aHandoffState.mChain, aHandoffState.mIsHandoff,
        aHandoffState.mScrolledApzc, aPLPPI);
  } else {
    return new StackScrollerFlingAnimation(aApzc, this, aHandoffState.mChain,
                                           aHandoffState.mIsHandoff,
                                           aHandoffState.mScrolledApzc);
  }
}

UniquePtr<VelocityTracker> AndroidSpecificState::CreateVelocityTracker(
    Axis* aAxis) {
  if (StaticPrefs::apz_android_chrome_fling_physics_enabled()) {
    return MakeUnique<AndroidVelocityTracker>();
  }
  return MakeUnique<SimpleVelocityTracker>(aAxis);
}

/* static */
void AndroidSpecificState::InitializeGlobalState() {
  // Not conditioned on
  // StaticPrefs::apz_android_chrome_fling_physics_enabled() because the pref
  // is live.
  AndroidFlingPhysics::InitializeGlobalState();
}

const float BOUNDS_EPSILON = 1.0f;

// This function is used to convert the scroll offset from a float to an integer
// suitable for using with the Android OverScroller Class.
// The Android OverScroller class (unfortunately) operates in integers instead
// of floats. When casting a float value such as 1.5 to an integer, the value is
// converted to 1. If this value represents the max scroll offset, the
// OverScroller class will never scroll to the end of the page as it will always
// be 0.5 pixels short. To work around this issue, the min and max scroll
// extents are floor/ceil to convert them to the nearest integer just outside of
// the actual scroll extents. This means, the starting scroll offset must be
// converted the same way so that if the frame has already been scrolled 1.5
// pixels, it won't be snapped back when converted to an integer. This integer
// rounding error was one of several causes of Bug 1276463.
static int32_t ClampStart(float aOrigin, float aMin, float aMax) {
  if (aOrigin <= aMin) {
    return (int32_t)floor(aMin);
  } else if (aOrigin >= aMax) {
    return (int32_t)ceil(aMax);
  }
  return (int32_t)aOrigin;
}

StackScrollerFlingAnimation::StackScrollerFlingAnimation(
    AsyncPanZoomController& aApzc,
    PlatformSpecificStateBase* aPlatformSpecificState,
    const RefPtr<const OverscrollHandoffChain>& aOverscrollHandoffChain,
    bool aFlingIsHandoff,
    const RefPtr<const AsyncPanZoomController>& aScrolledApzc)
    : mApzc(aApzc),
      mOverscrollHandoffChain(aOverscrollHandoffChain),
      mScrolledApzc(aScrolledApzc),
      mSentBounceX(false),
      mSentBounceY(false),
      mFlingDuration(0) {
  MOZ_ASSERT(mOverscrollHandoffChain);
  AndroidSpecificState* state =
      aPlatformSpecificState->AsAndroidSpecificState();
  MOZ_ASSERT(state);
  mOverScroller = state->mOverScroller;
  MOZ_ASSERT(mOverScroller);

  // Drop any velocity on axes where we don't have room to scroll anyways
  // (in this APZC, or an APZC further in the handoff chain).
  // This ensures that we don't take the 'overscroll' path in Sample()
  // on account of one axis which can't scroll having a velocity.
  if (!mOverscrollHandoffChain->CanScrollInDirection(
          &mApzc, ScrollDirection::eHorizontal)) {
    RecursiveMutexAutoLock lock(mApzc.mRecursiveMutex);
    mApzc.mX.SetVelocity(0);
  }
  if (!mOverscrollHandoffChain->CanScrollInDirection(
          &mApzc, ScrollDirection::eVertical)) {
    RecursiveMutexAutoLock lock(mApzc.mRecursiveMutex);
    mApzc.mY.SetVelocity(0);
  }

  ParentLayerPoint velocity = mApzc.GetVelocityVector();

  float scrollRangeStartX = mApzc.mX.GetPageStart().value;
  float scrollRangeEndX = mApzc.mX.GetScrollRangeEnd().value;
  float scrollRangeStartY = mApzc.mY.GetPageStart().value;
  float scrollRangeEndY = mApzc.mY.GetScrollRangeEnd().value;
  mStartOffset.x = mPreviousOffset.x = mApzc.mX.GetOrigin().value;
  mStartOffset.y = mPreviousOffset.y = mApzc.mY.GetOrigin().value;
  float length = velocity.Length();
  if (length > 0.0f) {
    mFlingDirection = velocity / length;

    if ((sMaxFlingSpeed > 0.0f) && (length > sMaxFlingSpeed)) {
      velocity = mFlingDirection * sMaxFlingSpeed;
    }
  }

  mPreviousVelocity = velocity;

  int32_t originX =
      ClampStart(mStartOffset.x, scrollRangeStartX, scrollRangeEndX);
  int32_t originY =
      ClampStart(mStartOffset.y, scrollRangeStartY, scrollRangeEndY);
  if (!state->mLastFling.IsNull()) {
    // If it's been too long since the previous fling, or if the new fling's
    // velocity is too low, don't allow flywheel to kick in. If we do allow
    // flywheel to kick in, then we need to update the timestamp on the
    // StackScroller because otherwise it might use a stale velocity.
    TimeDuration flingDuration = TimeStamp::Now() - state->mLastFling;
    if (flingDuration.ToMilliseconds() <
            StaticPrefs::apz_fling_accel_interval_ms() &&
        velocity.Length() >= StaticPrefs::apz_fling_accel_interval_ms()) {
      bool unused = false;
      mOverScroller->ComputeScrollOffset(flingDuration.ToMilliseconds(),
                                         &unused);
    } else {
      mOverScroller->ForceFinished(true);
    }
  }
  mOverScroller->Fling(
      originX, originY,
      // Android needs the velocity in pixels per second and it is in pixels per
      // ms.
      (int32_t)(velocity.x * 1000.0f), (int32_t)(velocity.y * 1000.0f),
      (int32_t)floor(scrollRangeStartX), (int32_t)ceil(scrollRangeEndX),
      (int32_t)floor(scrollRangeStartY), (int32_t)ceil(scrollRangeEndY), 0, 0,
      0);
  state->mLastFling = TimeStamp::Now();
}

/**
 * Advances a fling by an interpolated amount based on the Android OverScroller.
 * This should be called whenever sampling the content transform for this
 * frame. Returns true if the fling animation should be advanced by one frame,
 * or false if there is no fling or the fling has ended.
 */
bool StackScrollerFlingAnimation::DoSample(FrameMetrics& aFrameMetrics,
                                           const TimeDuration& aDelta) {
  bool shouldContinueFling = true;

  mFlingDuration += aDelta.ToMilliseconds();
  mOverScroller->ComputeScrollOffset(mFlingDuration, &shouldContinueFling);

  int32_t currentX = 0;
  int32_t currentY = 0;
  mOverScroller->GetCurrX(&currentX);
  mOverScroller->GetCurrY(&currentY);
  ParentLayerPoint offset((float)currentX, (float)currentY);
  ParentLayerPoint preCheckedOffset(offset);

  bool hitBoundX =
      CheckBounds(mApzc.mX, offset.x, mFlingDirection.x, &(offset.x));
  bool hitBoundY =
      CheckBounds(mApzc.mY, offset.y, mFlingDirection.y, &(offset.y));

  ParentLayerPoint velocity = mPreviousVelocity;

  // Sometimes the OverScroller fails to update the offset for a frame.
  // If the frame can still scroll we just use the velocity from the previous
  // frame. However, if the frame can no longer scroll in the direction
  // of the fling, then end the animation.
  if (offset != mPreviousOffset) {
    if (aDelta.ToMilliseconds() > 0) {
      mOverScroller->GetCurrSpeedX(&velocity.x);
      mOverScroller->GetCurrSpeedY(&velocity.y);

      velocity.x /= 1000;
      velocity.y /= 1000;

      mPreviousVelocity = velocity;
    }
  } else if ((fabsf(offset.x - preCheckedOffset.x) > BOUNDS_EPSILON) ||
             (fabsf(offset.y - preCheckedOffset.y) > BOUNDS_EPSILON)) {
    // The page is no longer scrolling but the fling animation is still
    // animating beyond the page bounds. If it goes beyond the BOUNDS_EPSILON
    // then it has overflowed and will never stop. In that case, stop the fling
    // animation.
    shouldContinueFling = false;
  } else if (hitBoundX && hitBoundY) {
    // We can't scroll any farther along either axis.
    shouldContinueFling = false;
  }

  float speed = velocity.Length();

  // StaticPrefs::apz_fling_stopped_threshold is only used in tests.
  if (!shouldContinueFling ||
      (speed < StaticPrefs::apz_fling_stopped_threshold())) {
    if (shouldContinueFling) {
      // The OverScroller thinks it should continue but the speed is below
      // the stopping threshold so abort the animation.
      mOverScroller->AbortAnimation();
    }
    // This animation is going to end. If DeferHandleFlingOverscroll
    // has not been called and there is still some velocity left,
    // call it so that fling hand off may occur if applicable.
    if (!mSentBounceX && !mSentBounceY && (speed > 0.0f)) {
      DeferHandleFlingOverscroll(velocity);
    }
    return false;
  }

  mPreviousOffset = offset;

  mApzc.SetVelocityVector(velocity);
  mApzc.SetScrollOffset(offset / aFrameMetrics.GetZoom());

  // If we hit a bounds while flinging, send the velocity so that the bounce
  // animation can play.
  if (hitBoundX || hitBoundY) {
    ParentLayerPoint bounceVelocity = velocity;

    if (!mSentBounceX && hitBoundX &&
        fabsf(offset.x - mStartOffset.x) > BOUNDS_EPSILON) {
      mSentBounceX = true;
    } else {
      bounceVelocity.x = 0.0f;
    }

    if (!mSentBounceY && hitBoundY &&
        fabsf(offset.y - mStartOffset.y) > BOUNDS_EPSILON) {
      mSentBounceY = true;
    } else {
      bounceVelocity.y = 0.0f;
    }
    if (!IsZero(bounceVelocity)) {
      DeferHandleFlingOverscroll(bounceVelocity);
    }
  }

  return true;
}

void StackScrollerFlingAnimation::DeferHandleFlingOverscroll(
    ParentLayerPoint& aVelocity) {
  mDeferredTasks.AppendElement(
      NewRunnableMethod<ParentLayerPoint, RefPtr<const OverscrollHandoffChain>,
                        RefPtr<const AsyncPanZoomController>>(
          "layers::AsyncPanZoomController::HandleFlingOverscroll", &mApzc,
          &AsyncPanZoomController::HandleFlingOverscroll, aVelocity,
          mOverscrollHandoffChain, mScrolledApzc));
}

bool StackScrollerFlingAnimation::CheckBounds(Axis& aAxis, float aValue,
                                              float aDirection,
                                              float* aClamped) {
  if ((aDirection < 0.0f) && (aValue <= aAxis.GetPageStart().value)) {
    if (aClamped) {
      *aClamped = aAxis.GetPageStart().value;
    }
    return true;
  } else if ((aDirection > 0.0f) &&
             (aValue >= aAxis.GetScrollRangeEnd().value)) {
    if (aClamped) {
      *aClamped = aAxis.GetScrollRangeEnd().value;
    }
    return true;
  }
  return false;
}

}  // namespace layers
}  // namespace mozilla
