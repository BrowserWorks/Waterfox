/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "VREventObserver.h"

#include "nsContentUtils.h"
#include "nsGlobalWindow.h"
#include "VRManagerChild.h"

#include "mozilla/Telemetry.h"

namespace mozilla {
namespace dom {

using namespace gfx;

/**
 * This class is used by nsGlobalWindow to implement window.onvrdisplayactivate,
 * window.onvrdisplaydeactivate, window.onvrdisplayconnected,
 * window.onvrdisplaydisconnected, and window.onvrdisplaypresentchange.
 */
VREventObserver::VREventObserver(nsGlobalWindow* aGlobalWindow)
  : mWindow(aGlobalWindow)
  , mIs2DView(true)
{
  MOZ_ASSERT(aGlobalWindow && aGlobalWindow->IsInnerWindow());

  mSpendTimeIn2DView = TimeStamp::Now();
  VRManagerChild* vmc = VRManagerChild::Get();
  if (vmc) {
    vmc->AddListener(this);
  }
}

VREventObserver::~VREventObserver()
{
  DisconnectFromOwner();
}

void
VREventObserver::DisconnectFromOwner()
{
  // In the event that nsGlobalWindow is deallocated, VREventObserver may
  // still be AddRef'ed elsewhere.  Ensure that we don't UAF by
  // dereferencing mWindow.
  if (mWindow && mIs2DView) {
    // The WebVR content is closed, and we will collect the telemetry info
    // for the users who view it in 2D view only.
    Telemetry::Accumulate(Telemetry::WEBVR_USERS_VIEW_IN, 0);
    Telemetry::AccumulateTimeDelta(Telemetry::WEBVR_TIME_SPENT_VIEWING_IN_2D,
                                   mSpendTimeIn2DView);
  }
  mWindow = nullptr;

  // Unregister from VRManagerChild
  if (VRManagerChild::IsCreated()) {
    VRManagerChild* vmc = VRManagerChild::Get();
    vmc->RemoveListener(this);
  }
}

void
VREventObserver::NotifyVRDisplayMounted(uint32_t aDisplayID)
{
  if (mWindow && mWindow->AsInner()->IsCurrentInnerWindow()) {
    MOZ_ASSERT(nsContentUtils::IsSafeToRunScript());
    mWindow->DispatchVRDisplayActivate(aDisplayID,
                                       VRDisplayEventReason::Mounted);
  }
}

void
VREventObserver::NotifyVRDisplayNavigation(uint32_t aDisplayID)
{
  if (mWindow && mWindow->AsInner()->IsCurrentInnerWindow()) {
    MOZ_ASSERT(nsContentUtils::IsSafeToRunScript());
    mWindow->DispatchVRDisplayActivate(aDisplayID,
                                       VRDisplayEventReason::Navigation);
  }
}

void
VREventObserver::NotifyVRDisplayRequested(uint32_t aDisplayID)
{
  if (mWindow && mWindow->AsInner()->IsCurrentInnerWindow()) {
    MOZ_ASSERT(nsContentUtils::IsSafeToRunScript());
    mWindow->DispatchVRDisplayActivate(aDisplayID,
                                       VRDisplayEventReason::Requested);
  }
}

void
VREventObserver::NotifyVRDisplayUnmounted(uint32_t aDisplayID)
{
  if (mWindow && mWindow->AsInner()->IsCurrentInnerWindow()) {
    MOZ_ASSERT(nsContentUtils::IsSafeToRunScript());
    mWindow->DispatchVRDisplayDeactivate(aDisplayID,
                                         VRDisplayEventReason::Unmounted);
  }
}

void
VREventObserver::NotifyVRDisplayConnect(uint32_t aDisplayID)
{
  /**
   * We do not call nsGlobalWindow::NotifyActiveVRDisplaysChanged here, as we
   * can assume that a newly enumerated display is not presenting WebVR
   * content.
   */
  if (mWindow && mWindow->AsInner()->IsCurrentInnerWindow()) {
    MOZ_ASSERT(nsContentUtils::IsSafeToRunScript());
    mWindow->DispatchVRDisplayConnect(aDisplayID);
  }
}

void
VREventObserver::NotifyVRDisplayDisconnect(uint32_t aDisplayID)
{
  if (mWindow && mWindow->AsInner()->IsCurrentInnerWindow()) {
    mWindow->NotifyActiveVRDisplaysChanged();
    MOZ_ASSERT(nsContentUtils::IsSafeToRunScript());
    mWindow->DispatchVRDisplayDisconnect(aDisplayID);
  }
}

void
VREventObserver::NotifyVRDisplayPresentChange(uint32_t aDisplayID)
{
  // When switching to HMD present mode, it is no longer
  // to be a 2D view.
  mIs2DView = false;

  if (mWindow && mWindow->AsInner()->IsCurrentInnerWindow()) {
    mWindow->NotifyActiveVRDisplaysChanged();
    MOZ_ASSERT(nsContentUtils::IsSafeToRunScript());
    mWindow->DispatchVRDisplayPresentChange(aDisplayID);
  }
}

} // namespace dom
} // namespace mozilla
