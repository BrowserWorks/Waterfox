/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef nsSHistory_h
#define nsSHistory_h

#include "nsCOMPtr.h"
#include "nsDocShellLoadState.h"
#include "nsExpirationTracker.h"
#include "nsISHistory.h"
#include "nsSHEntryShared.h"
#include "nsSimpleEnumerator.h"
#include "nsTObserverArray.h"
#include "nsWeakReference.h"

#include "mozilla/LinkedList.h"
#include "mozilla/UniquePtr.h"

class nsIDocShell;
class nsDocShell;
class nsSHistoryObserver;
class nsISHEntry;

namespace mozilla {
namespace dom {
class LoadSHEntryResult;
}
}  // namespace mozilla

class nsSHistory : public mozilla::LinkedListElement<nsSHistory>,
                   public nsISHistory,
                   public nsSupportsWeakReference {
 public:
  // The timer based history tracker is used to evict bfcache on expiration.
  class HistoryTracker final : public nsExpirationTracker<nsSHEntryShared, 3> {
   public:
    explicit HistoryTracker(nsSHistory* aSHistory, uint32_t aTimeout,
                            nsIEventTarget* aEventTarget)
        : nsExpirationTracker(1000 * aTimeout / 2, "HistoryTracker",
                              aEventTarget) {
      MOZ_ASSERT(aSHistory);
      mSHistory = aSHistory;
    }

   protected:
    virtual void NotifyExpired(nsSHEntryShared* aObj) override {
      RemoveObject(aObj);
      mSHistory->EvictExpiredContentViewerForEntry(aObj);
    }

   private:
    // HistoryTracker is owned by nsSHistory; it always outlives HistoryTracker
    // so it's safe to use raw pointer here.
    nsSHistory* mSHistory;
  };

  // Structure used in SetChildHistoryEntry
  struct SwapEntriesData {
    mozilla::dom::BrowsingContext*
        ignoreBC;                // constant; the browsing context to ignore
    nsISHEntry* destTreeRoot;    // constant; the root of the dest tree
    nsISHEntry* destTreeParent;  // constant; the node under destTreeRoot
                                 // whose children will correspond to aEntry
  };

  explicit nsSHistory(mozilla::dom::BrowsingContext* aRootBC);
  NS_DECL_ISUPPORTS
  NS_DECL_NSISHISTORY

  // One time initialization method called upon docshell module construction
  static nsresult Startup();
  static void Shutdown();
  static void UpdatePrefs();

  // Max number of total cached content viewers.  If the pref
  // browser.sessionhistory.max_total_viewers is negative, then
  // this value is calculated based on the total amount of memory.
  // Otherwise, it comes straight from the pref.
  static uint32_t GetMaxTotalViewers() { return sHistoryMaxTotalViewers; }

  // Get the root SHEntry from a given entry.
  static already_AddRefed<nsISHEntry> GetRootSHEntry(nsISHEntry* aEntry);

  // Callback prototype for WalkHistoryEntries.
  // `aEntry` is the child history entry, `aBC` is its corresponding browsing
  // context, `aChildIndex` is the child's index in its parent entry, and
  // `aData` is the opaque pointer passed to WalkHistoryEntries. Both structs
  // that are passed as `aData` to this function have a field
  // `aEntriesToUpdate`, which is an array of entries we need to update in
  // docshell, if the 'SH in parent' pref is on (which implies that this method
  // is executed in the parent)
  typedef nsresult (*WalkHistoryEntriesFunc)(nsISHEntry* aEntry,
                                             mozilla::dom::BrowsingContext* aBC,
                                             int32_t aChildIndex, void* aData);

  // Clone a session history tree for subframe navigation.
  // The tree rooted at |aSrcEntry| will be cloned into |aDestEntry|, except
  // for the entry with id |aCloneID|, which will be replaced with
  // |aReplaceEntry|. |aSrcShell| is a (possibly null) docshell which
  // corresponds to |aSrcEntry| via its mLSHE or mOHE pointers, and will
  // have that pointer updated to point to the cloned history entry.
  // If aCloneChildren is true then the children of the entry with id
  // |aCloneID| will be cloned into |aReplaceEntry|.
  static nsresult CloneAndReplace(nsISHEntry* aSrcEntry,
                                  mozilla::dom::BrowsingContext* aOwnerBC,
                                  uint32_t aCloneID, nsISHEntry* aReplaceEntry,
                                  bool aCloneChildren, nsISHEntry** aDestEntry);

  // Child-walking callback for CloneAndReplace
  static nsresult CloneAndReplaceChild(nsISHEntry* aEntry,
                                       mozilla::dom::BrowsingContext* aOwnerBC,
                                       int32_t aChildIndex, void* aData);

  // Child-walking callback for SetHistoryEntry
  static nsresult SetChildHistoryEntry(nsISHEntry* aEntry,
                                       mozilla::dom::BrowsingContext* aBC,
                                       int32_t aEntryIndex, void* aData);

  // For each child of aRootEntry, find the corresponding shell which is
  // a child of aBC, and call aCallback. The opaque pointer aData
  // is passed to the callback.
  static nsresult WalkHistoryEntries(nsISHEntry* aRootEntry,
                                     mozilla::dom::BrowsingContext* aBC,
                                     WalkHistoryEntriesFunc aCallback,
                                     void* aData);

  nsresult AddChildSHEntryHelper(nsISHEntry* aCloneRef, nsISHEntry* aNewEntry,
                                 mozilla::dom::BrowsingContext* aBC,
                                 bool aCloneChildren, nsISHEntry** aNextEntry);

  nsTArray<nsCOMPtr<nsISHEntry>>& Entries() { return mEntries; }

  void RemoveEntries(nsTArray<nsID>& aIDs, int32_t aStartIndex,
                     bool* aDidRemove);

  // The size of the window of SHEntries which can have alive viewers in the
  // bfcache around the currently active SHEntry.
  //
  // We try to keep viewers for SHEntries between index - VIEWER_WINDOW and
  // index + VIEWER_WINDOW alive.
  static const int32_t VIEWER_WINDOW = 3;

  struct LoadEntryResult {
    RefPtr<mozilla::dom::BrowsingContext> mBrowsingContext;
    RefPtr<nsDocShellLoadState> mLoadState;
  };

  static void LoadURIs(nsTArray<LoadEntryResult>& aLoadResults);

  // If this doesn't return an error then either aLoadResult is set to nothing,
  // in which case the caller should ignore the load, or it returns a valid
  // LoadEntryResult in aLoadResult which the caller should use to do the load.
  nsresult Reload(uint32_t aReloadFlags,
                  nsTArray<LoadEntryResult>& aLoadResults);
  nsresult ReloadCurrentEntry(nsTArray<LoadEntryResult>& aLoadResults);
  nsresult GotoIndex(int32_t aIndex, nsTArray<LoadEntryResult>& aLoadResults);

  void WindowIndices(int32_t aIndex, int32_t* aOutStartIndex,
                     int32_t* aOutEndIndex);
  void NotifyListenersContentViewerEvicted(uint32_t aNumEvicted);

 protected:
  virtual ~nsSHistory();

  // Weak reference. Do not refcount this.
  mozilla::dom::BrowsingContext* mRootBC;

 private:
  friend class nsSHistoryObserver;

  nsresult LoadDifferingEntries(nsISHEntry* aPrevEntry, nsISHEntry* aNextEntry,
                                mozilla::dom::BrowsingContext* aRootBC,
                                long aLoadType, bool& aDifferenceFound,
                                nsTArray<LoadEntryResult>& aLoadResults);
  nsresult InitiateLoad(nsISHEntry* aFrameEntry,
                        mozilla::dom::BrowsingContext* aFrameBC, long aLoadType,
                        nsTArray<LoadEntryResult>& aLoadResult);

  nsresult LoadEntry(int32_t aIndex, long aLoadType, uint32_t aHistCmd,
                     nsTArray<LoadEntryResult>& aLoadResults);

#ifdef DEBUG
  nsresult PrintHistory();
#endif

  // Find the history entry for a given bfcache entry. It only looks up between
  // the range where alive viewers may exist (i.e nsSHistory::VIEWER_WINDOW).
  nsresult FindEntryForBFCache(nsIBFCacheEntry* aBFEntry, nsISHEntry** aResult,
                               int32_t* aResultIndex);

  // Evict content viewers in this window which don't lie in the "safe" range
  // around aIndex.
  virtual void EvictOutOfRangeWindowContentViewers(int32_t aIndex);
  void EvictContentViewerForEntry(nsISHEntry* aEntry);
  static void GloballyEvictContentViewers();
  static void GloballyEvictAllContentViewers();

  // Calculates a max number of total
  // content viewers to cache, based on amount of total memory
  static uint32_t CalcMaxTotalViewers();

  nsresult LoadNextPossibleEntry(int32_t aNewIndex, long aLoadType,
                                 uint32_t aHistCmd,
                                 nsTArray<LoadEntryResult>& aLoadResults);

  // aIndex is the index of the entry which may be removed.
  // If aKeepNext is true, aIndex is compared to aIndex + 1,
  // otherwise comparison is done to aIndex - 1.
  bool RemoveDuplicate(int32_t aIndex, bool aKeepNext);

  // We need to update entries in docshell and browsing context.
  // If our docshell is located in parent or 'SH in parent' pref is off we can
  // update it directly, Otherwise, we have two choices. If the browsing context
  // that owns the docshell is in the same process as the process who called us
  // over IPC, then we save entries that need to be updated in a list, and once
  // we have returned from the IPC call, we update the docshell in the child
  // process. Otherwise, if the browsing context is in a different process, we
  // do a nested IPC call to that process to update the docshell in that
  // process.
  static void HandleEntriesToSwapInDocShell(mozilla::dom::BrowsingContext* aBC,
                                            nsISHEntry* aOldEntry,
                                            nsISHEntry* aNewEntry);

 protected:
  // Length of mEntries.
  int32_t Length() { return int32_t(mEntries.Length()); }

  bool mIsRemote;
  nsTArray<nsCOMPtr<nsISHEntry>> mEntries;  // entries are never null
 private:
  // Track all bfcache entries and evict on expiration.
  mozilla::UniquePtr<HistoryTracker> mHistoryTracker;

  int32_t mIndex;           // -1 means "no index"
  int32_t mRequestedIndex;  // -1 means "no requested index"

  // Session History listeners
  nsAutoTObserverArray<nsWeakPtr, 2> mListeners;

  nsID mRootDocShellID;

  // Max viewers allowed total, across all SHistory objects
  static int32_t sHistoryMaxTotalViewers;
};

inline nsISupports* ToSupports(nsSHistory* aObj) {
  return static_cast<nsISHistory*>(aObj);
}

#endif /* nsSHistory */
