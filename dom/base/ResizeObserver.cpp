/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/dom/ResizeObserver.h"

#include "mozilla/dom/DOMRect.h"
#include "nsContentUtils.h"
#include "nsIFrame.h"
#include "nsSVGUtils.h"

namespace mozilla {
namespace dom {

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(ResizeObserver)
  NS_WRAPPERCACHE_INTERFACE_MAP_ENTRY
  NS_INTERFACE_MAP_ENTRY(nsISupports)
NS_INTERFACE_MAP_END

NS_IMPL_CYCLE_COLLECTING_ADDREF(ResizeObserver)
NS_IMPL_CYCLE_COLLECTING_RELEASE(ResizeObserver)

NS_IMPL_CYCLE_COLLECTION_CLASS(ResizeObserver)

NS_IMPL_CYCLE_COLLECTION_TRACE_BEGIN(ResizeObserver)
  NS_IMPL_CYCLE_COLLECTION_TRACE_PRESERVED_WRAPPER
NS_IMPL_CYCLE_COLLECTION_TRACE_END

NS_IMPL_CYCLE_COLLECTION_UNLINK_BEGIN(ResizeObserver)
  NS_IMPL_CYCLE_COLLECTION_UNLINK_PRESERVED_WRAPPER
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mOwner)
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mCallback)
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mObservationMap)
NS_IMPL_CYCLE_COLLECTION_UNLINK_END

NS_IMPL_CYCLE_COLLECTION_TRAVERSE_BEGIN(ResizeObserver)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mOwner)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mCallback)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mObservationMap)
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_END

already_AddRefed<ResizeObserver>
ResizeObserver::Constructor(const GlobalObject& aGlobal,
                            ResizeObserverCallback& aCb,
                            ErrorResult& aRv)
{
  nsCOMPtr<nsPIDOMWindowInner> window =
    do_QueryInterface(aGlobal.GetAsSupports());

  if (!window) {
    aRv.Throw(NS_ERROR_FAILURE);
    return nullptr;
  }

  nsCOMPtr<nsIDocument> document = window->GetExtantDoc();

  if (!document) {
    aRv.Throw(NS_ERROR_FAILURE);
    return nullptr;
  }

  RefPtr<ResizeObserver> observer = new ResizeObserver(window.forget(), aCb);
  document->AddResizeObserver(observer);

  return observer.forget();
}

void
ResizeObserver::Observe(Element* aTarget,
                        ErrorResult& aRv)
{
  if (!aTarget) {
    aRv.Throw(NS_ERROR_DOM_NOT_FOUND_ERR);
    return;
  }

  RefPtr<ResizeObservation> observation;

  if (!mObservationMap.Get(aTarget, getter_AddRefs(observation))) {
    observation = new ResizeObservation(this, aTarget);

    mObservationMap.Put(aTarget, observation);
    mObservationList.insertBack(observation);

    // Per the spec, we need to trigger notification in event loop that
    // contains ResizeObserver observe call even when resize/reflow does
    // not happen.
    aTarget->OwnerDoc()->ScheduleResizeObserversNotification();
  }
}

void
ResizeObserver::Unobserve(Element* aTarget,
                          ErrorResult& aRv)
{
  if (!aTarget) {
    aRv.Throw(NS_ERROR_DOM_NOT_FOUND_ERR);
    return;
  }

  RefPtr<ResizeObservation> observation;

  if (mObservationMap.Get(aTarget, getter_AddRefs(observation))) {
    mObservationMap.Remove(aTarget);

    MOZ_ASSERT(!mObservationList.isEmpty(),
               "If ResizeObservation found for an element, observation list "
               "must be not empty.");

    observation->remove();
  }
}

void
ResizeObserver::Disconnect()
{
  mObservationMap.Clear();
  mObservationList.clear();
  mActiveTargets.Clear();
}

void
ResizeObserver::GatherActiveObservations(uint32_t aDepth)
{
  mActiveTargets.Clear();
  mHasSkippedTargets = false;

  for (auto observation : mObservationList) {
    if (observation->IsActive()) {
      uint32_t targetDepth =
        nsContentUtils::GetNodeDepth(observation->Target());

      if (targetDepth > aDepth) {
        mActiveTargets.AppendElement(observation);
      } else {
        mHasSkippedTargets = true;
      }
    }
  }
}

bool
ResizeObserver::HasActiveObservations() const
{
  return !mActiveTargets.IsEmpty();
}

bool
ResizeObserver::HasSkippedObservations() const
{
  return mHasSkippedTargets;
}

uint32_t
ResizeObserver::BroadcastActiveObservations()
{
  uint32_t shallowestTargetDepth = UINT32_MAX;

  if (HasActiveObservations()) {
    Sequence<OwningNonNull<ResizeObserverEntry>> entries;

    for (auto observation : mActiveTargets) {
      RefPtr<ResizeObserverEntry> entry =
        new ResizeObserverEntry(this, observation->Target());

      nsRect rect = observation->GetTargetRect();
      entry->SetContentRect(rect);

      if (!entries.AppendElement(entry.forget(), fallible)) {
        // Out of memory.
        break;
      }

      // Sync the broadcast size of observation so the next size inspection
      // will be based on the updated size from last delivered observations.
      observation->UpdateBroadcastSize(rect);

      uint32_t targetDepth =
        nsContentUtils::GetNodeDepth(observation->Target());

      if (targetDepth < shallowestTargetDepth) {
        shallowestTargetDepth = targetDepth;
      }
    }

    mCallback->Call(this, entries, *this);
    mActiveTargets.Clear();
    mHasSkippedTargets = false;
  }

  return shallowestTargetDepth;
}

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(ResizeObserverEntry)
  NS_WRAPPERCACHE_INTERFACE_MAP_ENTRY
  NS_INTERFACE_MAP_ENTRY(nsISupports)
NS_INTERFACE_MAP_END

NS_IMPL_CYCLE_COLLECTING_ADDREF(ResizeObserverEntry)
NS_IMPL_CYCLE_COLLECTING_RELEASE(ResizeObserverEntry)

NS_IMPL_CYCLE_COLLECTION_WRAPPERCACHE(ResizeObserverEntry,
                                      mTarget, mContentRect,
                                      mOwner)

already_AddRefed<ResizeObserverEntry>
ResizeObserverEntry::Constructor(const GlobalObject& aGlobal,
                                 Element* aTarget,
                                 ErrorResult& aRv)
{
  RefPtr<ResizeObserverEntry> observerEntry =
    new ResizeObserverEntry(aGlobal.GetAsSupports(), aTarget);
  return observerEntry.forget();
}

void
ResizeObserverEntry::SetContentRect(nsRect aRect)
{
  RefPtr<DOMRect> contentRect = new DOMRect(mTarget);
  nsIFrame* frame = mTarget->GetPrimaryFrame();

  if (frame) {
    nsMargin padding = frame->GetUsedPadding();

    // Per the spec, we need to include padding in contentRect of
    // ResizeObserverEntry.
    aRect.x = padding.left;
    aRect.y = padding.top;
  }

  contentRect->SetLayoutRect(aRect);
  mContentRect = contentRect.forget();
}

ResizeObserverEntry::~ResizeObserverEntry()
{
}

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(ResizeObservation)
  NS_WRAPPERCACHE_INTERFACE_MAP_ENTRY
  NS_INTERFACE_MAP_ENTRY(nsISupports)
NS_INTERFACE_MAP_END

NS_IMPL_CYCLE_COLLECTING_ADDREF(ResizeObservation)
NS_IMPL_CYCLE_COLLECTING_RELEASE(ResizeObservation)

NS_IMPL_CYCLE_COLLECTION_WRAPPERCACHE(ResizeObservation,
                                      mTarget, mOwner)

already_AddRefed<ResizeObservation>
ResizeObservation::Constructor(const GlobalObject& aGlobal,
                               Element* aTarget,
                               ErrorResult& aRv)
{
  RefPtr<ResizeObservation> observation =
    new ResizeObservation(aGlobal.GetAsSupports(), aTarget);
  return observation.forget();
}

bool
ResizeObservation::IsActive() const
{
  nsRect rect = GetTargetRect();
  return (rect.width != mBroadcastWidth || rect.height != mBroadcastHeight);
}

void
ResizeObservation::UpdateBroadcastSize(nsRect aRect)
{
  mBroadcastWidth = aRect.width;
  mBroadcastHeight = aRect.height;
}

nsRect
ResizeObservation::GetTargetRect() const
{
  nsRect rect;
  nsIFrame* frame = mTarget->GetPrimaryFrame();

  if (frame) {
    if (mTarget->IsSVGElement()) {
      gfxRect bbox = nsSVGUtils::GetBBox(frame);
      rect.width = NSFloatPixelsToAppUnits(bbox.width, AppUnitsPerCSSPixel());
      rect.height = NSFloatPixelsToAppUnits(bbox.height, AppUnitsPerCSSPixel());
    } else {
      // Per the spec, non-replaced inline Elements will always have an empty
      // content rect.
      if (frame->IsFrameOfType(nsIFrame::eReplaced) ||
          !frame->IsFrameOfType(nsIFrame::eLineParticipant)) {
        rect = frame->GetContentRectRelativeToSelf();
      }
    }
  }

  return rect;
}

ResizeObservation::~ResizeObservation()
{
}

} // namespace dom
} // namespace mozilla
