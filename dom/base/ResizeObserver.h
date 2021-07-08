/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_dom_ResizeObserver_h
#define mozilla_dom_ResizeObserver_h

#include "mozilla/AppUnits.h"
#include "mozilla/WritingModes.h"
#include "mozilla/dom/ResizeObserverBinding.h"
#include "nsCoord.h"

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

  void Observe(Element* aTarget, const ResizeObserverOptions& aOptions, ErrorResult& aRv);

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
   * The active observations' mLastReportedSize fields will be updated, and
   * mActiveTargets will be cleared. It also returns the shallowest depth of
   * elements from active observations or numeric_limits<uint32_t>::max() if
   * there are not any active observations.
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
  // The spec uses a list to store the skipped targets. However, it seems what
  // we want is to check if there are any skipped targets (i.e. existence).
  // Therefore, we use a boolean value to represent the existence of skipped
  // targets.
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

  /**
   * Returns target's logical border-box size and content-box size as
   * ResizeObserverSize.
   */
  ResizeObserverSize* BorderBoxSize() const { 
    return mBorderBoxSize;
  }
  ResizeObserverSize* ContentBoxSize() const { 
    return mContentBoxSize;
  }

  // Set borderBoxSize.
  void SetBorderBoxSize(const nsSize& aSize);
  // Set contentRect and contentBoxSize.
  void SetContentRectAndSize(const nsSize& aSize);

protected:
  ~ResizeObserverEntry();

  nsCOMPtr<nsISupports> mOwner;
  nsCOMPtr<Element> mTarget;

  RefPtr<DOMRectReadOnly> mContentRect;
  RefPtr<ResizeObserverSize> mBorderBoxSize;
  RefPtr<ResizeObserverSize> mContentBoxSize;
};

class ResizeObserverSize final : public nsISupports, public nsWrapperCache {
public:
  NS_DECL_CYCLE_COLLECTING_ISUPPORTS
  NS_DECL_CYCLE_COLLECTION_SCRIPT_HOLDER_CLASS(ResizeObserverSize)

  // Note: the unit of |aSize| is app unit, and we convert it into css pixel in
  // the public JS APIs.
  ResizeObserverSize(nsISupports* aOwner, const nsSize& aSize,
                     const WritingMode aWM)
      : mOwner(aOwner), mSize(aWM, aSize), mWM(aWM) {
    MOZ_ASSERT(mOwner, "Need a non-null owner");
  }

  nsISupports* GetParentObject() const { return mOwner; }

  JSObject* WrapObject(JSContext* aCx,
                       JS::Handle<JSObject*> aGivenProto) override {
    return ResizeObserverSizeBinding::Wrap(aCx, this, aGivenProto);
  }

  double InlineSize() const {
    return NSAppUnitsToDoublePixels(mSize.ISize(mWM), AppUnitsPerCSSPixel());
  }

  double BlockSize() const {
    return NSAppUnitsToDoublePixels(mSize.BSize(mWM), AppUnitsPerCSSPixel());
  }

protected:
  ~ResizeObserverSize() = default;

  nsCOMPtr<nsISupports> mOwner;
  const LogicalSize mSize;
  const WritingMode mWM;
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

  ResizeObservation(nsISupports* aOwner,
                    Element* aTarget,
                    ResizeObserverBoxOptions aBox,
                    const WritingMode aWM)
    : mOwner(aOwner)
    , mTarget(aTarget)
    , mObservedBox(aBox)
    , mLastReportedSize(aWM)
    , mLastReportedWM(aWM)
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

  ResizeObserverBoxOptions BoxOptions() const
  { 
    return mObservedBox;
  }

  /*
   * Returns whether the observed target element size differs from the saved
   * mLastReportedSize.
  */
  bool IsActive() const;

  /*
   * Update current mLastReportedSize with size from aSize.
  */
  void UpdateLastReportedSize(const nsSize& aSize);

protected:
  ~ResizeObservation();

  nsCOMPtr<nsISupports> mOwner;
  nsCOMPtr<Element> mTarget;

  const ResizeObserverBoxOptions mObservedBox;

  // The latest recorded size of observed target.
  // Per the spec, observation.lastReportedSize should be entry.borderBoxSize
  // or entry.contentBoxSize (i.e. logical size), instead of entry.contentRect
  // (i.e. physical rect), so we store this as LogicalSize.
  LogicalSize mLastReportedSize;
  WritingMode mLastReportedWM;
};

} // namespace dom
} // namespace mozilla

#endif // mozilla_dom_ResizeObserver_h

