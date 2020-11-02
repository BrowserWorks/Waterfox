/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_dom_ResizeObserver_h
#define mozilla_dom_ResizeObserver_h

#include "mozilla/dom/ResizeObserverBinding.h"

namespace mozilla {
namespace dom {

/**
 * ResizeObserver interfaces and algorithms are based on
 * https://wicg.github.io/ResizeObserver/#api
 */
class ResizeObserver final
  : public nsISupports
  , public nsWrapperCache
{
public:
  NS_DECL_CYCLE_COLLECTING_ISUPPORTS
  NS_DECL_CYCLE_COLLECTION_SCRIPT_HOLDER_CLASS(ResizeObserver)

  ResizeObserver(already_AddRefed<nsPIDOMWindowInner>&& aOwner,
                 ResizeObserverCallback& aCb)
    : mOwner(aOwner)
    , mCallback(&aCb)
  {
    MOZ_ASSERT(mOwner, "Need a non-null owner window");
  }

  static already_AddRefed<ResizeObserver>
  Constructor(const GlobalObject& aGlobal,
              ResizeObserverCallback& aCb,
              ErrorResult& aRv);

  JSObject* WrapObject(JSContext* aCx,
                       JS::Handle<JSObject*> aGivenProto) override
  {
    return ResizeObserverBinding::Wrap(aCx, this, aGivenProto);
  }

  nsISupports* GetParentObject() const
  {
    return mOwner;
  }

  void Observe(Element* aTarget, ErrorResult& aRv);

  void Unobserve(Element* aTarget, ErrorResult& aRv);

  void Disconnect();

  /*
   * Gather all observations which have an observed target with size changed
   * since last BroadcastActiveObservations() in this ResizeObserver.
   * An observation will be skipped if the depth of its observed target is less
   * or equal than aDepth. All gathered observations will be added to
   * mActiveTargets.
  */
  void GatherActiveObservations(uint32_t aDepth);

  /*
   * Returns whether this ResizeObserver has any active observations
   * since last GatherActiveObservations().
  */
  bool HasActiveObservations() const;

  /*
   * Returns whether this ResizeObserver has any skipped observations
   * since last GatherActiveObservations().
  */
  bool HasSkippedObservations() const;

  /*
   * Deliver the callback function in JavaScript for all active observations
   * and pass the sequence of ResizeObserverEntry so JavaScript can access them.
   * The broadcast size of observations will be updated and mActiveTargets will
   * be cleared. It also returns the shallowest depth of elements from active
   * observations or UINT32_MAX if there is no any active observations.
  */
  uint32_t BroadcastActiveObservations();

protected:
  ~ResizeObserver()
  {
    mObservationList.clear();
  }

  nsCOMPtr<nsPIDOMWindowInner> mOwner;
  RefPtr<ResizeObserverCallback> mCallback;
  nsTArray<RefPtr<ResizeObservation>> mActiveTargets;
  bool mHasSkippedTargets;

  // Combination of HashTable and LinkedList so we can iterate through
  // the elements of HashTable in order of insertion time.
  // Will be nice if we have our own data structure for this in the future.
  nsRefPtrHashtable<nsPtrHashKey<Element>, ResizeObservation> mObservationMap;
  LinkedList<ResizeObservation> mObservationList;
};

/**
 * ResizeObserverEntry is the entry that contains the information for observed
 * elements. This object is the one that visible to JavaScript in callback
 * function that is fired by ResizeObserver.
 */
class ResizeObserverEntry final
  : public nsISupports
  , public nsWrapperCache
{
public:
  NS_DECL_CYCLE_COLLECTING_ISUPPORTS
  NS_DECL_CYCLE_COLLECTION_SCRIPT_HOLDER_CLASS(ResizeObserverEntry)

  ResizeObserverEntry(nsISupports* aOwner, Element* aTarget)
    : mOwner(aOwner)
    , mTarget(aTarget)
  {
    MOZ_ASSERT(mOwner, "Need a non-null owner");
    MOZ_ASSERT(mTarget, "Need a non-null target element");
  }

  static already_AddRefed<ResizeObserverEntry>
  Constructor(const GlobalObject& aGlobal,
              Element* aTarget,
              ErrorResult& aRv);

  JSObject* WrapObject(JSContext* aCx,
                       JS::Handle<JSObject*> aGivenProto) override
  {
    return ResizeObserverEntryBinding::Wrap(aCx, this,
                                            aGivenProto);
  }

  nsISupports* GetParentObject() const
  {
    return mOwner;
  }

  Element* Target() const
  {
    return mTarget;
  }

  /*
   * Returns the DOMRectReadOnly of target's content rect so it can be
   * accessed from JavaScript in callback function of ResizeObserver.
  */
  DOMRectReadOnly* GetContentRect() const
  {
    return mContentRect;
  }

  void SetContentRect(nsRect aRect);

protected:
  ~ResizeObserverEntry();

  nsCOMPtr<nsISupports> mOwner;
  nsCOMPtr<Element> mTarget;
  RefPtr<DOMRectReadOnly> mContentRect;
};

/**
 * We use ResizeObservation to store and sync the size information of one
 * observed element so we can decide whether an observation should be fired
 * or not.
 */
class ResizeObservation final
  : public nsISupports
  , public nsWrapperCache
  , public LinkedListElement<ResizeObservation>
{
public:
  NS_DECL_CYCLE_COLLECTING_ISUPPORTS
  NS_DECL_CYCLE_COLLECTION_SCRIPT_HOLDER_CLASS(ResizeObservation)

  ResizeObservation(nsISupports* aOwner, Element* aTarget)
    : mOwner(aOwner)
    , mTarget(aTarget)
    , mBroadcastWidth(0)
    , mBroadcastHeight(0)
  {
    MOZ_ASSERT(mOwner, "Need a non-null owner");
    MOZ_ASSERT(mTarget, "Need a non-null target element");
  }

  static already_AddRefed<ResizeObservation>
  Constructor(const GlobalObject& aGlobal,
              Element* aTarget,
              ErrorResult& aRv);

  JSObject* WrapObject(JSContext* aCx,
                       JS::Handle<JSObject*> aGivenProto) override
  {
    return ResizeObservationBinding::Wrap(aCx, this, aGivenProto);
  }

  nsISupports* GetParentObject() const
  {
    return mOwner;
  }

  Element* Target() const
  {
    return mTarget;
  }

  nscoord BroadcastWidth() const
  {
    return mBroadcastWidth;
  }

  nscoord BroadcastHeight() const
  {
    return mBroadcastHeight;
  }

  /*
   * Returns whether the observed target element size differs from current
   * BroadcastWidth and BroadcastHeight
  */
  bool IsActive() const;

  /*
   * Update current BroadcastWidth and BroadcastHeight with size from aRect.
  */
  void UpdateBroadcastSize(nsRect aRect);

  /*
   * Returns the target's rect in the form of nsRect.
   * If the target is SVG, width and height are determined from bounding box.
  */
  nsRect GetTargetRect() const;

protected:
  ~ResizeObservation();

  nsCOMPtr<nsISupports> mOwner;
  nsCOMPtr<Element> mTarget;

  // Broadcast width and broadcast height are the latest recorded size
  // of observed target.
  nscoord mBroadcastWidth;
  nscoord mBroadcastHeight;
};

} // namespace dom
} // namespace mozilla

#endif // mozilla_dom_ResizeObserver_h

