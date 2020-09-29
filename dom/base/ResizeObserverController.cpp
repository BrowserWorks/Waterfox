/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/dom/ResizeObserverController.h"
#include "mozilla/dom/Element.h"
#include "mozilla/dom/ErrorEvent.h"
#include "nsIPresShell.h"
#include "nsPresContext.h"

namespace mozilla {
namespace dom {

void
ResizeObserverNotificationHelper::WillRefresh(TimeStamp aTime)
{
  MOZ_ASSERT(mOwner, "Why is mOwner already dead when this RefreshObserver is still registered?");
  if (mOwner) {
    mOwner->Notify();
  }
}

nsRefreshDriver*
ResizeObserverNotificationHelper::GetRefreshDriver() const
{
  nsIPresShell* presShell = mOwner->GetShell();
  if (MOZ_UNLIKELY(!presShell)) {
    return nullptr;
  }

  nsPresContext* presContext = presShell->GetPresContext();
  if (MOZ_UNLIKELY(!presContext)) {
    return nullptr;
  }

  return presContext->RefreshDriver();
}

void
ResizeObserverNotificationHelper::Register()
{
  if (mRegistered) {
    return;
  }

  nsRefreshDriver* refreshDriver = GetRefreshDriver();
  if (!refreshDriver) {
    // We maybe navigating away from this page or currently in an iframe with
    // display: none. Just abort the Register(), no need to do notification.
    return;
  }

  refreshDriver->AddRefreshObserver(this, FlushType::Display);
  mRegistered = true;
}

void
ResizeObserverNotificationHelper::Unregister()
{
  if (!mOwner) {
    // We've outlived our owner, so there's nothing registered anymore.
    mRegistered = false;
    return;
  }

  if (!mRegistered) {
    return;
  }

  nsRefreshDriver* refreshDriver = GetRefreshDriver();
  if (!refreshDriver) {
    // We can't access RefreshDriver now. Just abort the Unregister().
    return;
  }

  refreshDriver->RemoveRefreshObserver(this, FlushType::Display);
  mRegistered = false;
}

void
ResizeObserverNotificationHelper::Disconnect()
{
  Unregister();
  // Our owner is dying. Clear our pointer to it, in case we outlive it.
  mOwner = nullptr;
}

ResizeObserverNotificationHelper::~ResizeObserverNotificationHelper()
{
  Unregister();
}

void
ResizeObserverController::Traverse(nsCycleCollectionTraversalCallback& aCb)
{
  ImplCycleCollectionTraverse(aCb, mResizeObservers, "mResizeObservers");
}

void
ResizeObserverController::Unlink()
{
  mResizeObservers.Clear();
}

void
ResizeObserverController::AddResizeObserver(ResizeObserver* aObserver)
{
  MOZ_ASSERT(aObserver, "AddResizeObserver() should never be called with "
                        "a null parameter");
  mResizeObservers.AppendElement(aObserver);
}

void
ResizeObserverController::Notify()
{
  if (mResizeObservers.IsEmpty()) {
    return;
  }

  uint32_t shallowestTargetDepth = 0;

  GatherAllActiveObservations(shallowestTargetDepth);

  while (HasAnyActiveObservations()) {
    DebugOnly<uint32_t> oldShallowestTargetDepth = shallowestTargetDepth;
    shallowestTargetDepth = BroadcastAllActiveObservations();
    NS_ASSERTION(oldShallowestTargetDepth < shallowestTargetDepth,
                 "shallowestTargetDepth should be getting strictly deeper");

    // Flush layout, so that any callback functions' style changes / resizes
    // get a chance to take effect.
    mDocument->FlushPendingNotifications(FlushType::Layout);

    // To avoid infinite resize loop, we only gather all active observations
    // that have the depth of observed target element more than current
    // shallowestTargetDepth.
    GatherAllActiveObservations(shallowestTargetDepth);
  }

  mResizeObserverNotificationHelper->Unregister();

  // Per spec, we deliver an error if the document has any skipped observations.
  if (HasAnySkippedObservations()) {
    RootedDictionary<ErrorEventInit> init(RootingCx());

    init.mMessage.AssignLiteral("ResizeObserver loop completed with undelivered"
                                " notifications.");
    init.mCancelable = true;
    init.mBubbles = true;

    nsEventStatus status = nsEventStatus_eIgnore;

    nsCOMPtr<nsPIDOMWindowInner> window =
      mDocument->GetWindow()->GetCurrentInnerWindow();

    if (window) {
      nsCOMPtr<nsIScriptGlobalObject> sgo = do_QueryInterface(window);
      MOZ_ASSERT(sgo);

      if (NS_WARN_IF(NS_FAILED(sgo->HandleScriptError(init, &status)))) {
        status = nsEventStatus_eIgnore;
      }
    } else {
      // We don't fire error events at any global for non-window JS on the main
      // thread.
    }

    // We need to deliver pending notifications in next cycle.
    ScheduleNotification();
  }
}

void
ResizeObserverController::GatherAllActiveObservations(uint32_t aDepth)
{
  for (auto observer : mResizeObservers) {
    observer->GatherActiveObservations(aDepth);
  }
}

uint32_t
ResizeObserverController::BroadcastAllActiveObservations()
{
  uint32_t shallowestTargetDepth = UINT32_MAX;

  for (auto observer : mResizeObservers) {

    uint32_t targetDepth = observer->BroadcastActiveObservations();

    if (targetDepth < shallowestTargetDepth) {
      shallowestTargetDepth = targetDepth;
    }
  }

  return shallowestTargetDepth;
}

bool
ResizeObserverController::HasAnyActiveObservations() const
{
  for (auto observer : mResizeObservers) {
    if (observer->HasActiveObservations()) {
      return true;
    }
  }
  return false;
}

bool
ResizeObserverController::HasAnySkippedObservations() const
{
  for (auto observer : mResizeObservers) {
    if (observer->HasSkippedObservations()) {
      return true;
    }
  }
  return false;
}

void
ResizeObserverController::ScheduleNotification()
{
  mResizeObserverNotificationHelper->Register();
}

nsIPresShell*
ResizeObserverController::GetShell() const
{
  return mDocument->GetShell();
}

ResizeObserverController::~ResizeObserverController()
{
  mResizeObserverNotificationHelper->Disconnect();
}

} // namespace dom
} // namespace mozilla
