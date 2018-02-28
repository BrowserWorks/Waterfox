/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/**
 * SurfaceCache is a service for caching temporary surfaces in imagelib.
 */

#include "SurfaceCache.h"

#include <algorithm>
#include "mozilla/Assertions.h"
#include "mozilla/Attributes.h"
#include "mozilla/DebugOnly.h"
#include "mozilla/Likely.h"
#include "mozilla/Move.h"
#include "mozilla/Pair.h"
#include "mozilla/RefPtr.h"
#include "mozilla/StaticMutex.h"
#include "mozilla/StaticPtr.h"
#include "mozilla/Tuple.h"
#include "nsIMemoryReporter.h"
#include "gfx2DGlue.h"
#include "gfxPlatform.h"
#include "gfxPrefs.h"
#include "imgFrame.h"
#include "Image.h"
#include "ISurfaceProvider.h"
#include "LookupResult.h"
#include "nsExpirationTracker.h"
#include "nsHashKeys.h"
#include "nsRefPtrHashtable.h"
#include "nsSize.h"
#include "nsTArray.h"
#include "prsystem.h"
#include "ShutdownTracker.h"

using std::max;
using std::min;

namespace mozilla {

using namespace gfx;

namespace image {

class CachedSurface;
class SurfaceCacheImpl;

///////////////////////////////////////////////////////////////////////////////
// Static Data
///////////////////////////////////////////////////////////////////////////////

// The single surface cache instance.
static StaticRefPtr<SurfaceCacheImpl> sInstance;

// The mutex protecting the surface cache.
static StaticMutex sInstanceMutex;

///////////////////////////////////////////////////////////////////////////////
// SurfaceCache Implementation
///////////////////////////////////////////////////////////////////////////////

/**
 * Cost models the cost of storing a surface in the cache. Right now, this is
 * simply an estimate of the size of the surface in bytes, but in the future it
 * may be worth taking into account the cost of rematerializing the surface as
 * well.
 */
typedef size_t Cost;

static Cost
ComputeCost(const IntSize& aSize, uint32_t aBytesPerPixel)
{
  MOZ_ASSERT(aBytesPerPixel == 1 || aBytesPerPixel == 4);
  return aSize.width * aSize.height * aBytesPerPixel;
}

/**
 * Since we want to be able to make eviction decisions based on cost, we need to
 * be able to look up the CachedSurface which has a certain cost as well as the
 * cost associated with a certain CachedSurface. To make this possible, in data
 * structures we actually store a CostEntry, which contains a weak pointer to
 * its associated surface.
 *
 * To make usage of the weak pointer safe, SurfaceCacheImpl always calls
 * StartTracking after a surface is stored in the cache and StopTracking before
 * it is removed.
 */
class CostEntry
{
public:
  CostEntry(NotNull<CachedSurface*> aSurface, Cost aCost)
    : mSurface(aSurface)
    , mCost(aCost)
  { }

  NotNull<CachedSurface*> Surface() const { return mSurface; }
  Cost GetCost() const { return mCost; }

  bool operator==(const CostEntry& aOther) const
  {
    return mSurface == aOther.mSurface &&
           mCost == aOther.mCost;
  }

  bool operator<(const CostEntry& aOther) const
  {
    return mCost < aOther.mCost ||
           (mCost == aOther.mCost && mSurface < aOther.mSurface);
  }

private:
  NotNull<CachedSurface*> mSurface;
  Cost                    mCost;
};

/**
 * A CachedSurface associates a surface with a key that uniquely identifies that
 * surface.
 */
class CachedSurface
{
  ~CachedSurface() { }
public:
  MOZ_DECLARE_REFCOUNTED_TYPENAME(CachedSurface)
  NS_INLINE_DECL_THREADSAFE_REFCOUNTING(CachedSurface)

  explicit CachedSurface(NotNull<ISurfaceProvider*> aProvider)
    : mProvider(aProvider)
    , mIsLocked(false)
  { }

  DrawableSurface GetDrawableSurface() const
  {
    if (MOZ_UNLIKELY(IsPlaceholder())) {
      MOZ_ASSERT_UNREACHABLE("Called GetDrawableSurface() on a placeholder");
      return DrawableSurface();
    }

    return mProvider->Surface();
  }

  void SetLocked(bool aLocked)
  {
    if (IsPlaceholder()) {
      return;  // Can't lock a placeholder.
    }

    // Update both our state and our provider's state. Some surface providers
    // are permanently locked; maintaining our own locking state enables us to
    // respect SetLocked() even when it's meaningless from the provider's
    // perspective.
    mIsLocked = aLocked;
    mProvider->SetLocked(aLocked);
  }

  bool IsLocked() const
  {
    return !IsPlaceholder() && mIsLocked && mProvider->IsLocked();
  }

  bool IsPlaceholder() const { return mProvider->Availability().IsPlaceholder(); }
  bool IsDecoded() const { return !IsPlaceholder() && mProvider->IsFinished(); }

  ImageKey GetImageKey() const { return mProvider->GetImageKey(); }
  SurfaceKey GetSurfaceKey() const { return mProvider->GetSurfaceKey(); }
  nsExpirationState* GetExpirationState() { return &mExpirationState; }

  CostEntry GetCostEntry()
  {
    return image::CostEntry(WrapNotNull(this), mProvider->LogicalSizeInBytes());
  }

  // A helper type used by SurfaceCacheImpl::CollectSizeOfSurfaces.
  struct MOZ_STACK_CLASS SurfaceMemoryReport
  {
    SurfaceMemoryReport(nsTArray<SurfaceMemoryCounter>& aCounters,
                        MallocSizeOf                    aMallocSizeOf)
      : mCounters(aCounters)
      , mMallocSizeOf(aMallocSizeOf)
    { }

    void Add(NotNull<CachedSurface*> aCachedSurface)
    {
      SurfaceMemoryCounter counter(aCachedSurface->GetSurfaceKey(),
                                   aCachedSurface->IsLocked());

      if (aCachedSurface->IsPlaceholder()) {
        return;
      }

      // Record the memory used by the ISurfaceProvider. This may not have a
      // straightforward relationship to the size of the surface that
      // DrawableRef() returns if the surface is generated dynamically. (i.e.,
      // for surfaces with PlaybackType::eAnimated.)
      size_t heap = 0;
      size_t nonHeap = 0;
      size_t handles = 0;
      aCachedSurface->mProvider
        ->AddSizeOfExcludingThis(mMallocSizeOf, heap, nonHeap, handles);
      counter.Values().SetDecodedHeap(heap);
      counter.Values().SetDecodedNonHeap(nonHeap);
      counter.Values().SetSharedHandles(handles);

      mCounters.AppendElement(counter);
    }

  private:
    nsTArray<SurfaceMemoryCounter>& mCounters;
    MallocSizeOf                    mMallocSizeOf;
  };

private:
  nsExpirationState                 mExpirationState;
  NotNull<RefPtr<ISurfaceProvider>> mProvider;
  bool                              mIsLocked;
};

static int64_t
AreaOfIntSize(const IntSize& aSize) {
  return static_cast<int64_t>(aSize.width) * static_cast<int64_t>(aSize.height);
}

/**
 * An ImageSurfaceCache is a per-image surface cache. For correctness we must be
 * able to remove all surfaces associated with an image when the image is
 * destroyed or invalidated. Since this will happen frequently, it makes sense
 * to make it cheap by storing the surfaces for each image separately.
 *
 * ImageSurfaceCache also keeps track of whether its associated image is locked
 * or unlocked.
 */
class ImageSurfaceCache
{
  ~ImageSurfaceCache() { }
public:
  ImageSurfaceCache() : mLocked(false) { }

  MOZ_DECLARE_REFCOUNTED_TYPENAME(ImageSurfaceCache)
  NS_INLINE_DECL_THREADSAFE_REFCOUNTING(ImageSurfaceCache)

  typedef
    nsRefPtrHashtable<nsGenericHashKey<SurfaceKey>, CachedSurface> SurfaceTable;

  bool IsEmpty() const { return mSurfaces.Count() == 0; }

  void Insert(NotNull<CachedSurface*> aSurface)
  {
    MOZ_ASSERT(!mLocked || aSurface->IsPlaceholder() || aSurface->IsLocked(),
               "Inserting an unlocked surface for a locked image");
    mSurfaces.Put(aSurface->GetSurfaceKey(), aSurface);
  }

  void Remove(NotNull<CachedSurface*> aSurface)
  {
    MOZ_ASSERT(mSurfaces.GetWeak(aSurface->GetSurfaceKey()),
        "Should not be removing a surface we don't have");

    mSurfaces.Remove(aSurface->GetSurfaceKey());
  }

  already_AddRefed<CachedSurface> Lookup(const SurfaceKey& aSurfaceKey)
  {
    RefPtr<CachedSurface> surface;
    mSurfaces.Get(aSurfaceKey, getter_AddRefs(surface));
    return surface.forget();
  }

  Pair<already_AddRefed<CachedSurface>, MatchType>
  LookupBestMatch(const SurfaceKey& aIdealKey)
  {
    // Try for an exact match first.
    RefPtr<CachedSurface> exactMatch;
    mSurfaces.Get(aIdealKey, getter_AddRefs(exactMatch));
    if (exactMatch && exactMatch->IsDecoded()) {
      return MakePair(exactMatch.forget(), MatchType::EXACT);
    }

    // There's no perfect match, so find the best match we can.
    RefPtr<CachedSurface> bestMatch;
    for (auto iter = ConstIter(); !iter.Done(); iter.Next()) {
      NotNull<CachedSurface*> current = WrapNotNull(iter.UserData());
      const SurfaceKey& currentKey = current->GetSurfaceKey();

      // We never match a placeholder.
      if (current->IsPlaceholder()) {
        continue;
      }
      // Matching the playback type and SVG context is required.
      if (currentKey.Playback() != aIdealKey.Playback() ||
          currentKey.SVGContext() != aIdealKey.SVGContext()) {
        continue;
      }
      // Matching the flags is required.
      if (currentKey.Flags() != aIdealKey.Flags()) {
        continue;
      }
      // Anything is better than nothing! (Within the constraints we just
      // checked, of course.)
      if (!bestMatch) {
        bestMatch = current;
        continue;
      }

      MOZ_ASSERT(bestMatch, "Should have a current best match");

      // Always prefer completely decoded surfaces.
      bool bestMatchIsDecoded = bestMatch->IsDecoded();
      if (bestMatchIsDecoded && !current->IsDecoded()) {
        continue;
      }
      if (!bestMatchIsDecoded && current->IsDecoded()) {
        bestMatch = current;
        continue;
      }

      SurfaceKey bestMatchKey = bestMatch->GetSurfaceKey();

      // Compare sizes. We use an area-based heuristic here instead of computing a
      // truly optimal answer, since it seems very unlikely to make a difference
      // for realistic sizes.
      int64_t idealArea = AreaOfIntSize(aIdealKey.Size());
      int64_t currentArea = AreaOfIntSize(currentKey.Size());
      int64_t bestMatchArea = AreaOfIntSize(bestMatchKey.Size());

      // If the best match is smaller than the ideal size, prefer bigger sizes.
      if (bestMatchArea < idealArea) {
        if (currentArea > bestMatchArea) {
          bestMatch = current;
        }
        continue;
      }
      // Other, prefer sizes closer to the ideal size, but still not smaller.
      if (idealArea <= currentArea && currentArea < bestMatchArea) {
        bestMatch = current;
        continue;
      }
      // This surface isn't an improvement over the current best match.
    }

    MatchType matchType;
    if (bestMatch) {
      if (!exactMatch) {
        // No exact match, but we found a substitute.
        matchType = MatchType::SUBSTITUTE_BECAUSE_NOT_FOUND;
      } else if (exactMatch != bestMatch) {
        // The exact match is still decoding, but we found a substitute.
        matchType = MatchType::SUBSTITUTE_BECAUSE_PENDING;
      } else {
        // The exact match is still decoding, but it's the best we've got.
        matchType = MatchType::EXACT;
      }
    } else {
      if (exactMatch) {
        // We found an "exact match"; it must have been a placeholder.
        MOZ_ASSERT(exactMatch->IsPlaceholder());
        matchType = MatchType::PENDING;
      } else {
        // We couldn't find an exact match *or* a substitute.
        matchType = MatchType::NOT_FOUND;
      }
    }

    return MakePair(bestMatch.forget(), matchType);
  }

  SurfaceTable::Iterator ConstIter() const
  {
    return mSurfaces.ConstIter();
  }

  void SetLocked(bool aLocked) { mLocked = aLocked; }
  bool IsLocked() const { return mLocked; }

private:
  SurfaceTable mSurfaces;
  bool         mLocked;
};

/**
 * SurfaceCacheImpl is responsible for determining which surfaces will be cached
 * and managing the surface cache data structures. Rather than interact with
 * SurfaceCacheImpl directly, client code interacts with SurfaceCache, which
 * maintains high-level invariants and encapsulates the details of the surface
 * cache's implementation.
 */
class SurfaceCacheImpl final : public nsIMemoryReporter
{
public:
  NS_DECL_ISUPPORTS

  SurfaceCacheImpl(uint32_t aSurfaceCacheExpirationTimeMS,
                   uint32_t aSurfaceCacheDiscardFactor,
                   uint32_t aSurfaceCacheSize)
    : mExpirationTracker(aSurfaceCacheExpirationTimeMS)
    , mMemoryPressureObserver(new MemoryPressureObserver)
    , mDiscardFactor(aSurfaceCacheDiscardFactor)
    , mMaxCost(aSurfaceCacheSize)
    , mAvailableCost(aSurfaceCacheSize)
    , mLockedCost(0)
    , mOverflowCount(0)
  {
    nsCOMPtr<nsIObserverService> os = services::GetObserverService();
    if (os) {
      os->AddObserver(mMemoryPressureObserver, "memory-pressure", false);
    }
  }

private:
  virtual ~SurfaceCacheImpl()
  {
    nsCOMPtr<nsIObserverService> os = services::GetObserverService();
    if (os) {
      os->RemoveObserver(mMemoryPressureObserver, "memory-pressure");
    }

    UnregisterWeakMemoryReporter(this);
  }

public:
  void InitMemoryReporter() { RegisterWeakMemoryReporter(this); }

  InsertOutcome Insert(NotNull<ISurfaceProvider*> aProvider,
                       bool                       aSetAvailable,
                       const StaticMutexAutoLock& aAutoLock)
  {
    // If this is a duplicate surface, refuse to replace the original.
    // XXX(seth): Calling Lookup() and then RemoveEntry() does the lookup
    // twice. We'll make this more efficient in bug 1185137.
    LookupResult result = Lookup(aProvider->GetImageKey(),
                                 aProvider->GetSurfaceKey(),
                                 aAutoLock,
                                 /* aMarkUsed = */ false);
    if (MOZ_UNLIKELY(result)) {
      return InsertOutcome::FAILURE_ALREADY_PRESENT;
    }

    if (result.Type() == MatchType::PENDING) {
      RemoveEntry(aProvider->GetImageKey(), aProvider->GetSurfaceKey(), aAutoLock);
    }

    MOZ_ASSERT(result.Type() == MatchType::NOT_FOUND ||
               result.Type() == MatchType::PENDING,
               "A LookupResult with no surface should be NOT_FOUND or PENDING");

    // If this is bigger than we can hold after discarding everything we can,
    // refuse to cache it.
    Cost cost = aProvider->LogicalSizeInBytes();
    if (MOZ_UNLIKELY(!CanHoldAfterDiscarding(cost))) {
      mOverflowCount++;
      return InsertOutcome::FAILURE;
    }

    // Remove elements in order of cost until we can fit this in the cache. Note
    // that locked surfaces aren't in mCosts, so we never remove them here.
    while (cost > mAvailableCost) {
      MOZ_ASSERT(!mCosts.IsEmpty(),
                 "Removed everything and it still won't fit");
      Remove(mCosts.LastElement().Surface(), /* aStopTracking */ true, aAutoLock);
    }

    // Locate the appropriate per-image cache. If there's not an existing cache
    // for this image, create it.
    RefPtr<ImageSurfaceCache> cache = GetImageCache(aProvider->GetImageKey());
    if (!cache) {
      cache = new ImageSurfaceCache;
      mImageCaches.Put(aProvider->GetImageKey(), cache);
    }

    // If we were asked to mark the cache entry available, do so.
    if (aSetAvailable) {
      aProvider->Availability().SetAvailable();
    }

    NotNull<RefPtr<CachedSurface>> surface =
      WrapNotNull(new CachedSurface(aProvider));

    // We require that locking succeed if the image is locked and we're not
    // inserting a placeholder; the caller may need to know this to handle
    // errors correctly.
    bool mustLock = cache->IsLocked() && !surface->IsPlaceholder();
    if (mustLock) {
      surface->SetLocked(true);
      if (!surface->IsLocked()) {
        return InsertOutcome::FAILURE;
      }
    }

    // Insert.
    MOZ_ASSERT(cost <= mAvailableCost, "Inserting despite too large a cost");
    cache->Insert(surface);
    if (MOZ_UNLIKELY(!StartTracking(surface, aAutoLock))) {
      MOZ_ASSERT(!mustLock);
      Remove(surface, /* aStopTracking */ false, aAutoLock);
      return InsertOutcome::FAILURE;
    }

    return InsertOutcome::SUCCESS;
  }

  void Remove(NotNull<CachedSurface*> aSurface,
              bool aStopTracking,
              const StaticMutexAutoLock& aAutoLock)
  {
    ImageKey imageKey = aSurface->GetImageKey();

    RefPtr<ImageSurfaceCache> cache = GetImageCache(imageKey);
    MOZ_ASSERT(cache, "Shouldn't try to remove a surface with no image cache");

    // If the surface was not a placeholder, tell its image that we discarded it.
    if (!aSurface->IsPlaceholder()) {
      static_cast<Image*>(imageKey)->OnSurfaceDiscarded(aSurface->GetSurfaceKey());
    }

    // If we failed during StartTracking, we can skip this step.
    if (aStopTracking) {
      StopTracking(aSurface, /* aIsTracked */ true, aAutoLock);
    }
    cache->Remove(aSurface);

    // Remove the per-image cache if it's unneeded now. (Keep it if the image is
    // locked, since the per-image cache is where we store that state.)
    if (cache->IsEmpty() && !cache->IsLocked()) {
      mImageCaches.Remove(imageKey);
    }
  }

  bool StartTracking(NotNull<CachedSurface*> aSurface,
                     const StaticMutexAutoLock& aAutoLock)
  {
    CostEntry costEntry = aSurface->GetCostEntry();
    MOZ_ASSERT(costEntry.GetCost() <= mAvailableCost,
               "Cost too large and the caller didn't catch it");

    if (aSurface->IsLocked()) {
      mLockedCost += costEntry.GetCost();
      MOZ_ASSERT(mLockedCost <= mMaxCost, "Locked more than we can hold?");
    } else {
      if (NS_WARN_IF(!mCosts.InsertElementSorted(costEntry, fallible))) {
        return false;
      }

      // This may fail during XPCOM shutdown, so we need to ensure the object is
      // tracked before calling RemoveObject in StopTracking.
      nsresult rv = mExpirationTracker.AddObjectLocked(aSurface, aAutoLock);
      if (NS_WARN_IF(NS_FAILED(rv))) {
        DebugOnly<bool> foundInCosts = mCosts.RemoveElementSorted(costEntry);
        MOZ_ASSERT(foundInCosts, "Lost track of costs for this surface");
        return false;
      }
    }

    mAvailableCost -= costEntry.GetCost();
    return true;
  }

  void StopTracking(NotNull<CachedSurface*> aSurface,
                    bool aIsTracked,
                    const StaticMutexAutoLock& aAutoLock)
  {
    CostEntry costEntry = aSurface->GetCostEntry();

    if (aSurface->IsLocked()) {
      MOZ_ASSERT(mLockedCost >= costEntry.GetCost(), "Costs don't balance");
      mLockedCost -= costEntry.GetCost();
      // XXX(seth): It'd be nice to use an O(log n) lookup here. This is O(n).
      MOZ_ASSERT(!mCosts.Contains(costEntry),
                 "Shouldn't have a cost entry for a locked surface");
    } else {
      if (MOZ_LIKELY(aSurface->GetExpirationState()->IsTracked())) {
        MOZ_ASSERT(aIsTracked, "Expiration-tracking a surface unexpectedly!");
        mExpirationTracker.RemoveObjectLocked(aSurface, aAutoLock);
      } else {
        // Our call to AddObject must have failed in StartTracking; most likely
        // we're in XPCOM shutdown right now.
        MOZ_ASSERT(!aIsTracked, "Not expiration-tracking an unlocked surface!");
      }

      DebugOnly<bool> foundInCosts = mCosts.RemoveElementSorted(costEntry);
      MOZ_ASSERT(foundInCosts, "Lost track of costs for this surface");
    }

    mAvailableCost += costEntry.GetCost();
    MOZ_ASSERT(mAvailableCost <= mMaxCost,
               "More available cost than we started with");
  }

  LookupResult Lookup(const ImageKey    aImageKey,
                      const SurfaceKey& aSurfaceKey,
                      const StaticMutexAutoLock& aAutoLock,
                      bool aMarkUsed = true)
  {
    RefPtr<ImageSurfaceCache> cache = GetImageCache(aImageKey);
    if (!cache) {
      // No cached surfaces for this image.
      return LookupResult(MatchType::NOT_FOUND);
    }

    RefPtr<CachedSurface> surface = cache->Lookup(aSurfaceKey);
    if (!surface) {
      // Lookup in the per-image cache missed.
      return LookupResult(MatchType::NOT_FOUND);
    }

    if (surface->IsPlaceholder()) {
      return LookupResult(MatchType::PENDING);
    }

    DrawableSurface drawableSurface = surface->GetDrawableSurface();
    if (!drawableSurface) {
      // The surface was released by the operating system. Remove the cache
      // entry as well.
      Remove(WrapNotNull(surface), /* aStopTracking */ true, aAutoLock);
      return LookupResult(MatchType::NOT_FOUND);
    }

    if (aMarkUsed &&
        !MarkUsed(WrapNotNull(surface), WrapNotNull(cache), aAutoLock)) {
      Remove(WrapNotNull(surface), /* aStopTracking */ false, aAutoLock);
      return LookupResult(MatchType::NOT_FOUND);
    }

    MOZ_ASSERT(surface->GetSurfaceKey() == aSurfaceKey,
               "Lookup() not returning an exact match?");
    return LookupResult(Move(drawableSurface), MatchType::EXACT);
  }

  LookupResult LookupBestMatch(const ImageKey         aImageKey,
                               const SurfaceKey&      aSurfaceKey,
                               const StaticMutexAutoLock& aAutoLock)
  {
    RefPtr<ImageSurfaceCache> cache = GetImageCache(aImageKey);
    if (!cache) {
      // No cached surfaces for this image.
      return LookupResult(MatchType::NOT_FOUND);
    }

    // Repeatedly look up the best match, trying again if the resulting surface
    // has been freed by the operating system, until we can either lock a
    // surface for drawing or there are no matching surfaces left.
    // XXX(seth): This is O(N^2), but N is expected to be very small. If we
    // encounter a performance problem here we can revisit this.

    RefPtr<CachedSurface> surface;
    DrawableSurface drawableSurface;
    MatchType matchType = MatchType::NOT_FOUND;
    while (true) {
      Tie(surface, matchType) = cache->LookupBestMatch(aSurfaceKey);

      if (!surface) {
        return LookupResult(matchType);  // Lookup in the per-image cache missed.
      }

      drawableSurface = surface->GetDrawableSurface();
      if (drawableSurface) {
        break;
      }

      // The surface was released by the operating system. Remove the cache
      // entry as well.
      Remove(WrapNotNull(surface), /* aStopTracking */ true, aAutoLock);
    }

    MOZ_ASSERT_IF(matchType == MatchType::EXACT,
                  surface->GetSurfaceKey() == aSurfaceKey);
    MOZ_ASSERT_IF(matchType == MatchType::SUBSTITUTE_BECAUSE_NOT_FOUND ||
                  matchType == MatchType::SUBSTITUTE_BECAUSE_PENDING,
      surface->GetSurfaceKey().SVGContext() == aSurfaceKey.SVGContext() &&
      surface->GetSurfaceKey().Playback() == aSurfaceKey.Playback() &&
      surface->GetSurfaceKey().Flags() == aSurfaceKey.Flags());

    if (matchType == MatchType::EXACT) {
      if (!MarkUsed(WrapNotNull(surface), WrapNotNull(cache), aAutoLock)) {
        Remove(WrapNotNull(surface), /* aStopTracking */ false, aAutoLock);
      }
    }

    return LookupResult(Move(drawableSurface), matchType);
  }

  bool CanHold(const Cost aCost) const
  {
    return aCost <= mMaxCost;
  }

  size_t MaximumCapacity() const
  {
    return size_t(mMaxCost);
  }

  void SurfaceAvailable(NotNull<ISurfaceProvider*> aProvider,
                        const StaticMutexAutoLock& aAutoLock)
  {
    if (!aProvider->Availability().IsPlaceholder()) {
      MOZ_ASSERT_UNREACHABLE("Calling SurfaceAvailable on non-placeholder");
      return;
    }

    // Reinsert the provider, requesting that Insert() mark it available. This
    // may or may not succeed, depending on whether some other decoder has
    // beaten us to the punch and inserted a non-placeholder version of this
    // surface first, but it's fine either way.
    // XXX(seth): This could be implemented more efficiently; we should be able
    // to just update our data structures without reinserting.
    Insert(aProvider, /* aSetAvailable = */ true, aAutoLock);
  }

  void LockImage(const ImageKey aImageKey)
  {
    RefPtr<ImageSurfaceCache> cache = GetImageCache(aImageKey);
    if (!cache) {
      cache = new ImageSurfaceCache;
      mImageCaches.Put(aImageKey, cache);
    }

    cache->SetLocked(true);

    // We don't relock this image's existing surfaces right away; instead, the
    // image should arrange for Lookup() to touch them if they are still useful.
  }

  void UnlockImage(const ImageKey aImageKey, const StaticMutexAutoLock& aAutoLock)
  {
    RefPtr<ImageSurfaceCache> cache = GetImageCache(aImageKey);
    if (!cache || !cache->IsLocked()) {
      return;  // Already unlocked.
    }

    cache->SetLocked(false);
    DoUnlockSurfaces(WrapNotNull(cache), /* aStaticOnly = */ false, aAutoLock);
  }

  void UnlockEntries(const ImageKey aImageKey, const StaticMutexAutoLock& aAutoLock)
  {
    RefPtr<ImageSurfaceCache> cache = GetImageCache(aImageKey);
    if (!cache || !cache->IsLocked()) {
      return;  // Already unlocked.
    }

    // (Note that we *don't* unlock the per-image cache here; that's the
    // difference between this and UnlockImage.)
    DoUnlockSurfaces(WrapNotNull(cache),
      /* aStaticOnly = */ !gfxPrefs::ImageMemAnimatedDiscardable(), aAutoLock);
  }

  void RemoveImage(const ImageKey aImageKey, const StaticMutexAutoLock& aAutoLock)
  {
    RefPtr<ImageSurfaceCache> cache = GetImageCache(aImageKey);
    if (!cache) {
      return;  // No cached surfaces for this image, so nothing to do.
    }

    // Discard all of the cached surfaces for this image.
    // XXX(seth): This is O(n^2) since for each item in the cache we are
    // removing an element from the costs array. Since n is expected to be
    // small, performance should be good, but if usage patterns change we should
    // change the data structure used for mCosts.
    for (auto iter = cache->ConstIter(); !iter.Done(); iter.Next()) {
      StopTracking(WrapNotNull(iter.UserData()),
                   /* aIsTracked */ true, aAutoLock);
    }

    // The per-image cache isn't needed anymore, so remove it as well.
    // This implicitly unlocks the image if it was locked.
    mImageCaches.Remove(aImageKey);
  }

  void DiscardAll(const StaticMutexAutoLock& aAutoLock)
  {
    // Remove in order of cost because mCosts is an array and the other data
    // structures are all hash tables. Note that locked surfaces are not
    // removed, since they aren't present in mCosts.
    while (!mCosts.IsEmpty()) {
      Remove(mCosts.LastElement().Surface(), /* aStopTracking */ true, aAutoLock);
    }
  }

  void DiscardForMemoryPressure(const StaticMutexAutoLock& aAutoLock)
  {
    // Compute our discardable cost. Since locked surfaces aren't discardable,
    // we exclude them.
    const Cost discardableCost = (mMaxCost - mAvailableCost) - mLockedCost;
    MOZ_ASSERT(discardableCost <= mMaxCost, "Discardable cost doesn't add up");

    // Our target is to raise our available cost by (1 / mDiscardFactor) of our
    // discardable cost - in other words, we want to end up with about
    // (discardableCost / mDiscardFactor) fewer bytes stored in the surface
    // cache after we're done.
    const Cost targetCost = mAvailableCost + (discardableCost / mDiscardFactor);

    if (targetCost > mMaxCost - mLockedCost) {
      MOZ_ASSERT_UNREACHABLE("Target cost is more than we can discard");
      DiscardAll(aAutoLock);
      return;
    }

    // Discard surfaces until we've reduced our cost to our target cost.
    while (mAvailableCost < targetCost) {
      MOZ_ASSERT(!mCosts.IsEmpty(), "Removed everything and still not done");
      Remove(mCosts.LastElement().Surface(), /* aStopTracking */ true, aAutoLock);
    }
  }

  void LockSurface(NotNull<CachedSurface*> aSurface,
                   const StaticMutexAutoLock& aAutoLock)
  {
    if (aSurface->IsPlaceholder() || aSurface->IsLocked()) {
      return;
    }

    StopTracking(aSurface, /* aIsTracked */ true, aAutoLock);

    // Lock the surface. This can fail.
    aSurface->SetLocked(true);
    DebugOnly<bool> tracking = StartTracking(aSurface, aAutoLock);
    MOZ_ASSERT(tracking);
  }

  NS_IMETHOD
  CollectReports(nsIHandleReportCallback* aHandleReport,
                 nsISupports*             aData,
                 bool                     aAnonymize) override
  {
    StaticMutexAutoLock lock(sInstanceMutex);

    // We have explicit memory reporting for the surface cache which is more
    // accurate than the cost metrics we report here, but these metrics are
    // still useful to report, since they control the cache's behavior.
    MOZ_COLLECT_REPORT(
      "imagelib-surface-cache-estimated-total",
      KIND_OTHER, UNITS_BYTES, (mMaxCost - mAvailableCost),
"Estimated total memory used by the imagelib surface cache.");

    MOZ_COLLECT_REPORT(
      "imagelib-surface-cache-estimated-locked",
      KIND_OTHER, UNITS_BYTES, mLockedCost,
"Estimated memory used by locked surfaces in the imagelib surface cache.");

    MOZ_COLLECT_REPORT(
      "imagelib-surface-cache-overflow-count",
      KIND_OTHER, UNITS_COUNT, mOverflowCount,
"Count of how many times the surface cache has hit its capacity and been "
"unable to insert a new surface.");

    return NS_OK;
  }

  void CollectSizeOfSurfaces(const ImageKey                  aImageKey,
                             nsTArray<SurfaceMemoryCounter>& aCounters,
                             MallocSizeOf                    aMallocSizeOf)
  {
    RefPtr<ImageSurfaceCache> cache = GetImageCache(aImageKey);
    if (!cache) {
      return;  // No surfaces for this image.
    }

    // Report all surfaces in the per-image cache.
    CachedSurface::SurfaceMemoryReport report(aCounters, aMallocSizeOf);
    for (auto iter = cache->ConstIter(); !iter.Done(); iter.Next()) {
      report.Add(WrapNotNull(iter.UserData()));
    }
  }

private:
  already_AddRefed<ImageSurfaceCache> GetImageCache(const ImageKey aImageKey)
  {
    RefPtr<ImageSurfaceCache> imageCache;
    mImageCaches.Get(aImageKey, getter_AddRefs(imageCache));
    return imageCache.forget();
  }

  // This is similar to CanHold() except that it takes into account the costs of
  // locked surfaces. It's used internally in Insert(), but it's not exposed
  // publicly because we permit multithreaded access to the surface cache, which
  // means that the result would be meaningless: another thread could insert a
  // surface or lock an image at any time.
  bool CanHoldAfterDiscarding(const Cost aCost) const
  {
    return aCost <= mMaxCost - mLockedCost;
  }

  bool MarkUsed(NotNull<CachedSurface*> aSurface,
                NotNull<ImageSurfaceCache*> aCache,
                const StaticMutexAutoLock& aAutoLock)
  {
    if (aCache->IsLocked()) {
      LockSurface(aSurface, aAutoLock);
      return true;
    }

    nsresult rv = mExpirationTracker.MarkUsedLocked(aSurface, aAutoLock);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      // If mark used fails, it is because it failed to reinsert the surface
      // after removing it from the tracker. Thus we need to update our
      // own accounting but otherwise expect it to be untracked.
      StopTracking(aSurface, /* aIsTracked */ false, aAutoLock);
      return false;
    }
    return true;
  }

  void DoUnlockSurfaces(NotNull<ImageSurfaceCache*> aCache, bool aStaticOnly,
                        const StaticMutexAutoLock& aAutoLock)
  {
    AutoTArray<NotNull<CachedSurface*>, 8> discard;

    // Unlock all the surfaces the per-image cache is holding.
    for (auto iter = aCache->ConstIter(); !iter.Done(); iter.Next()) {
      NotNull<CachedSurface*> surface = WrapNotNull(iter.UserData());
      if (surface->IsPlaceholder() || !surface->IsLocked()) {
        continue;
      }
      if (aStaticOnly && surface->GetSurfaceKey().Playback() != PlaybackType::eStatic) {
        continue;
      }
      StopTracking(surface, /* aIsTracked */ true, aAutoLock);
      surface->SetLocked(false);
      if (MOZ_UNLIKELY(!StartTracking(surface, aAutoLock))) {
        discard.AppendElement(surface);
      }
    }

    // Discard any that we failed to track.
    for (auto iter = discard.begin(); iter != discard.end(); ++iter) {
      Remove(*iter, /* aStopTracking */ false, aAutoLock);
    }
  }

  void RemoveEntry(const ImageKey    aImageKey,
                   const SurfaceKey& aSurfaceKey,
                   const StaticMutexAutoLock& aAutoLock)
  {
    RefPtr<ImageSurfaceCache> cache = GetImageCache(aImageKey);
    if (!cache) {
      return;  // No cached surfaces for this image.
    }

    RefPtr<CachedSurface> surface = cache->Lookup(aSurfaceKey);
    if (!surface) {
      return;  // Lookup in the per-image cache missed.
    }

    Remove(WrapNotNull(surface), /* aStopTracking */ true, aAutoLock);
  }

  struct SurfaceTracker : public ExpirationTrackerImpl<CachedSurface, 2,
                                                       StaticMutex,
                                                       StaticMutexAutoLock>
  {
    explicit SurfaceTracker(uint32_t aSurfaceCacheExpirationTimeMS)
      : ExpirationTrackerImpl<CachedSurface, 2,
                              StaticMutex, StaticMutexAutoLock>(
          aSurfaceCacheExpirationTimeMS, "SurfaceTracker")
    { }

  protected:
    void NotifyExpiredLocked(CachedSurface* aSurface,
                             const StaticMutexAutoLock& aAutoLock) override
    {
      sInstance->Remove(WrapNotNull(aSurface), /* aStopTracking */ true, aAutoLock);
    }

    StaticMutex& GetMutex() override
    {
      return sInstanceMutex;
    }
  };

  struct MemoryPressureObserver : public nsIObserver
  {
    NS_DECL_ISUPPORTS

    NS_IMETHOD Observe(nsISupports*,
                       const char* aTopic,
                       const char16_t*) override
    {
      StaticMutexAutoLock lock(sInstanceMutex);
      if (sInstance && strcmp(aTopic, "memory-pressure") == 0) {
        sInstance->DiscardForMemoryPressure(lock);
      }
      return NS_OK;
    }

  private:
    virtual ~MemoryPressureObserver() { }
  };

  nsTArray<CostEntry>                     mCosts;
  nsRefPtrHashtable<nsPtrHashKey<Image>,
    ImageSurfaceCache> mImageCaches;
  SurfaceTracker                          mExpirationTracker;
  RefPtr<MemoryPressureObserver>        mMemoryPressureObserver;
  const uint32_t                          mDiscardFactor;
  const Cost                              mMaxCost;
  Cost                                    mAvailableCost;
  Cost                                    mLockedCost;
  size_t                                  mOverflowCount;
};

NS_IMPL_ISUPPORTS(SurfaceCacheImpl, nsIMemoryReporter)
NS_IMPL_ISUPPORTS(SurfaceCacheImpl::MemoryPressureObserver, nsIObserver)

///////////////////////////////////////////////////////////////////////////////
// Public API
///////////////////////////////////////////////////////////////////////////////

/* static */ void
SurfaceCache::Initialize()
{
  // Initialize preferences.
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(!sInstance, "Shouldn't initialize more than once");

  // See gfxPrefs for the default values of these preferences.

  // Length of time before an unused surface is removed from the cache, in
  // milliseconds.
  uint32_t surfaceCacheExpirationTimeMS =
    gfxPrefs::ImageMemSurfaceCacheMinExpirationMS();

  // What fraction of the memory used by the surface cache we should discard
  // when we get a memory pressure notification. This value is interpreted as
  // 1/N, so 1 means to discard everything, 2 means to discard about half of the
  // memory we're using, and so forth. We clamp it to avoid division by zero.
  uint32_t surfaceCacheDiscardFactor =
    max(gfxPrefs::ImageMemSurfaceCacheDiscardFactor(), 1u);

  // Maximum size of the surface cache, in kilobytes.
  uint64_t surfaceCacheMaxSizeKB = gfxPrefs::ImageMemSurfaceCacheMaxSizeKB();

  // A knob determining the actual size of the surface cache. Currently the
  // cache is (size of main memory) / (surface cache size factor) KB
  // or (surface cache max size) KB, whichever is smaller. The formula
  // may change in the future, though.
  // For example, a value of 4 would yield a 256MB cache on a 1GB machine.
  // The smallest machines we are likely to run this code on have 256MB
  // of memory, which would yield a 64MB cache on this setting.
  // We clamp this value to avoid division by zero.
  uint32_t surfaceCacheSizeFactor =
    max(gfxPrefs::ImageMemSurfaceCacheSizeFactor(), 1u);

  // Compute the size of the surface cache.
  uint64_t memorySize = PR_GetPhysicalMemorySize();
  if (memorySize == 0) {
    MOZ_ASSERT_UNREACHABLE("PR_GetPhysicalMemorySize not implemented here");
    memorySize = 256 * 1024 * 1024;  // Fall back to 256MB.
  }
  uint64_t proposedSize = memorySize / surfaceCacheSizeFactor;
  uint64_t surfaceCacheSizeBytes = min(proposedSize,
                                       surfaceCacheMaxSizeKB * 1024);
  uint32_t finalSurfaceCacheSizeBytes =
    min(surfaceCacheSizeBytes, uint64_t(UINT32_MAX));

  // Create the surface cache singleton with the requested settings.  Note that
  // the size is a limit that the cache may not grow beyond, but we do not
  // actually allocate any storage for surfaces at this time.
  sInstance = new SurfaceCacheImpl(surfaceCacheExpirationTimeMS,
                                   surfaceCacheDiscardFactor,
                                   finalSurfaceCacheSizeBytes);
  sInstance->InitMemoryReporter();
}

/* static */ void
SurfaceCache::Shutdown()
{
  StaticMutexAutoLock lock(sInstanceMutex);
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(sInstance, "No singleton - was Shutdown() called twice?");
  sInstance = nullptr;
}

/* static */ LookupResult
SurfaceCache::Lookup(const ImageKey         aImageKey,
                     const SurfaceKey&      aSurfaceKey)
{
  StaticMutexAutoLock lock(sInstanceMutex);
  if (!sInstance) {
    return LookupResult(MatchType::NOT_FOUND);
  }

  return sInstance->Lookup(aImageKey, aSurfaceKey, lock);
}

/* static */ LookupResult
SurfaceCache::LookupBestMatch(const ImageKey         aImageKey,
                              const SurfaceKey&      aSurfaceKey)
{
  StaticMutexAutoLock lock(sInstanceMutex);
  if (!sInstance) {
    return LookupResult(MatchType::NOT_FOUND);
  }

  return sInstance->LookupBestMatch(aImageKey, aSurfaceKey, lock);
}

/* static */ InsertOutcome
SurfaceCache::Insert(NotNull<ISurfaceProvider*> aProvider)
{
  StaticMutexAutoLock lock(sInstanceMutex);
  if (!sInstance) {
    return InsertOutcome::FAILURE;
  }

  return sInstance->Insert(aProvider, /* aSetAvailable = */ false, lock);
}

/* static */ bool
SurfaceCache::CanHold(const IntSize& aSize, uint32_t aBytesPerPixel /* = 4 */)
{
  StaticMutexAutoLock lock(sInstanceMutex);
  if (!sInstance) {
    return false;
  }

  Cost cost = ComputeCost(aSize, aBytesPerPixel);
  return sInstance->CanHold(cost);
}

/* static */ bool
SurfaceCache::CanHold(size_t aSize)
{
  StaticMutexAutoLock lock(sInstanceMutex);
  if (!sInstance) {
    return false;
  }

  return sInstance->CanHold(aSize);
}

/* static */ void
SurfaceCache::SurfaceAvailable(NotNull<ISurfaceProvider*> aProvider)
{
  StaticMutexAutoLock lock(sInstanceMutex);
  if (!sInstance) {
    return;
  }

  sInstance->SurfaceAvailable(aProvider, lock);
}

/* static */ void
SurfaceCache::LockImage(const ImageKey aImageKey)
{
  StaticMutexAutoLock lock(sInstanceMutex);
  if (sInstance) {
    return sInstance->LockImage(aImageKey);
  }
}

/* static */ void
SurfaceCache::UnlockImage(const ImageKey aImageKey)
{
  StaticMutexAutoLock lock(sInstanceMutex);
  if (sInstance) {
    return sInstance->UnlockImage(aImageKey, lock);
  }
}

/* static */ void
SurfaceCache::UnlockEntries(const ImageKey aImageKey)
{
  StaticMutexAutoLock lock(sInstanceMutex);
  if (sInstance) {
    return sInstance->UnlockEntries(aImageKey, lock);
  }
}

/* static */ void
SurfaceCache::RemoveImage(const ImageKey aImageKey)
{
  StaticMutexAutoLock lock(sInstanceMutex);
  if (sInstance) {
    sInstance->RemoveImage(aImageKey, lock);
  }
}

/* static */ void
SurfaceCache::DiscardAll()
{
  StaticMutexAutoLock lock(sInstanceMutex);
  if (sInstance) {
    sInstance->DiscardAll(lock);
  }
}

/* static */ void
SurfaceCache::CollectSizeOfSurfaces(const ImageKey                  aImageKey,
                                    nsTArray<SurfaceMemoryCounter>& aCounters,
                                    MallocSizeOf                    aMallocSizeOf)
{
  StaticMutexAutoLock lock(sInstanceMutex);
  if (!sInstance) {
    return;
  }

  return sInstance->CollectSizeOfSurfaces(aImageKey, aCounters, aMallocSizeOf);
}

/* static */ size_t
SurfaceCache::MaximumCapacity()
{
  StaticMutexAutoLock lock(sInstanceMutex);
  if (!sInstance) {
    return 0;
  }

  return sInstance->MaximumCapacity();
}

} // namespace image
} // namespace mozilla
