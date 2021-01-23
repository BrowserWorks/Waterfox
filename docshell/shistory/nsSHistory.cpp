/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsSHistory.h"

#include <algorithm>

#include "nsContentUtils.h"
#include "nsCOMArray.h"
#include "nsComponentManagerUtils.h"
#include "nsDocShell.h"
#include "nsIContentViewer.h"
#include "nsIDocShell.h"
#include "nsDocShellLoadState.h"
#include "nsIDocShellTreeItem.h"
#include "nsILayoutHistoryState.h"
#include "nsIObserverService.h"
#include "nsISHEntry.h"
#include "nsISHistoryListener.h"
#include "nsIURI.h"
#include "nsNetUtil.h"
#include "nsSHEntry.h"
#include "nsTArray.h"
#include "prsystem.h"

#include "mozilla/Attributes.h"
#include "mozilla/dom/CanonicalBrowsingContext.h"
#include "mozilla/dom/ContentParent.h"
#include "mozilla/LinkedList.h"
#include "mozilla/MathAlgorithms.h"
#include "mozilla/Preferences.h"
#include "mozilla/Services.h"
#include "mozilla/StaticPrefs_fission.h"
#include "mozilla/StaticPtr.h"
#include "mozilla/dom/CanonicalBrowsingContext.h"
#include "nsIWebNavigation.h"
#include "nsDocShellLoadTypes.h"
#include "base/process.h"

using namespace mozilla;
using namespace mozilla::dom;

#define PREF_SHISTORY_SIZE "browser.sessionhistory.max_entries"
#define PREF_SHISTORY_MAX_TOTAL_VIEWERS \
  "browser.sessionhistory.max_total_viewers"
#define CONTENT_VIEWER_TIMEOUT_SECONDS \
  "browser.sessionhistory.contentViewerTimeout"

// Default this to time out unused content viewers after 30 minutes
#define CONTENT_VIEWER_TIMEOUT_SECONDS_DEFAULT (30 * 60)

static const char* kObservedPrefs[] = {
    PREF_SHISTORY_SIZE, PREF_SHISTORY_MAX_TOTAL_VIEWERS, nullptr};

static int32_t gHistoryMaxSize = 50;
// List of all SHistory objects, used for content viewer cache eviction
static LinkedList<nsSHistory> gSHistoryList;
// Max viewers allowed total, across all SHistory objects - negative default
// means we will calculate how many viewers to cache based on total memory
int32_t nsSHistory::sHistoryMaxTotalViewers = -1;

// A counter that is used to be able to know the order in which
// entries were touched, so that we can evict older entries first.
static uint32_t gTouchCounter = 0;

LazyLogModule gSHistoryLog("nsSHistory");

#define LOG(format) MOZ_LOG(gSHistoryLog, mozilla::LogLevel::Debug, format)

extern mozilla::LazyLogModule gPageCacheLog;

// This macro makes it easier to print a log message which includes a URI's
// spec.  Example use:
//
//  nsIURI *uri = [...];
//  LOG_SPEC(("The URI is %s.", _spec), uri);
//
#define LOG_SPEC(format, uri)                             \
  PR_BEGIN_MACRO                                          \
  if (MOZ_LOG_TEST(gSHistoryLog, LogLevel::Debug)) {      \
    nsAutoCString _specStr(NS_LITERAL_CSTRING("(null)")); \
    if (uri) {                                            \
      _specStr = uri->GetSpecOrDefault();                 \
    }                                                     \
    const char* _spec = _specStr.get();                   \
    LOG(format);                                          \
  }                                                       \
  PR_END_MACRO

// This macro makes it easy to log a message including an SHEntry's URI.
// For example:
//
//  nsCOMPtr<nsISHEntry> shentry = [...];
//  LOG_SHENTRY_SPEC(("shentry %p has uri %s.", shentry.get(), _spec), shentry);
//
#define LOG_SHENTRY_SPEC(format, shentry)            \
  PR_BEGIN_MACRO                                     \
  if (MOZ_LOG_TEST(gSHistoryLog, LogLevel::Debug)) { \
    nsCOMPtr<nsIURI> uri = shentry->GetURI();        \
    LOG_SPEC(format, uri);                           \
  }                                                  \
  PR_END_MACRO

// Iterates over all registered session history listeners.
#define ITERATE_LISTENERS(body)                                              \
  PR_BEGIN_MACRO {                                                           \
    nsAutoTObserverArray<nsWeakPtr, 2>::EndLimitedIterator iter(mListeners); \
    while (iter.HasMore()) {                                                 \
      nsCOMPtr<nsISHistoryListener> listener =                               \
          do_QueryReferent(iter.GetNext());                                  \
      if (listener) {                                                        \
        body                                                                 \
      }                                                                      \
    }                                                                        \
  }                                                                          \
  PR_END_MACRO

// Calls a given method on all registered session history listeners.
#define NOTIFY_LISTENERS(method, args) \
  ITERATE_LISTENERS(listener->method args;);

// Calls a given method on all registered session history listeners.
// Listeners may return 'false' to cancel an action so make sure that we
// set the return value to 'false' if one of the listeners wants to cancel.
#define NOTIFY_LISTENERS_CANCELABLE(method, retval, args) \
  PR_BEGIN_MACRO {                                        \
    bool canceled = false;                                \
    retval = true;                                        \
    ITERATE_LISTENERS(listener->method args;              \
                      if (!retval) { canceled = true; }); \
    if (canceled) {                                       \
      retval = false;                                     \
    }                                                     \
  }                                                       \
  PR_END_MACRO

enum HistCmd { HIST_CMD_GOTOINDEX, HIST_CMD_RELOAD };

class nsSHistoryObserver final : public nsIObserver {
 public:
  NS_DECL_ISUPPORTS
  NS_DECL_NSIOBSERVER

  nsSHistoryObserver() {}

  static void PrefChanged(const char* aPref, void* aSelf);
  void PrefChanged(const char* aPref);

 protected:
  ~nsSHistoryObserver() {}
};

StaticRefPtr<nsSHistoryObserver> gObserver;

NS_IMPL_ISUPPORTS(nsSHistoryObserver, nsIObserver)

// static
void nsSHistoryObserver::PrefChanged(const char* aPref, void* aSelf) {
  static_cast<nsSHistoryObserver*>(aSelf)->PrefChanged(aPref);
}

void nsSHistoryObserver::PrefChanged(const char* aPref) {
  nsSHistory::UpdatePrefs();
  nsSHistory::GloballyEvictContentViewers();
}

NS_IMETHODIMP
nsSHistoryObserver::Observe(nsISupports* aSubject, const char* aTopic,
                            const char16_t* aData) {
  if (!strcmp(aTopic, "cacheservice:empty-cache") ||
      !strcmp(aTopic, "memory-pressure")) {
    nsSHistory::GloballyEvictAllContentViewers();
  }

  return NS_OK;
}

void nsSHistory::EvictContentViewerForEntry(nsISHEntry* aEntry) {
  nsCOMPtr<nsIContentViewer> viewer = aEntry->GetContentViewer();
  if (viewer) {
    LOG_SHENTRY_SPEC(("Evicting content viewer 0x%p for "
                      "owning SHEntry 0x%p at %s.",
                      viewer.get(), aEntry, _spec),
                     aEntry);

    // Drop the presentation state before destroying the viewer, so that
    // document teardown is able to correctly persist the state.
    NotifyListenersContentViewerEvicted(1);
    aEntry->SetContentViewer(nullptr);
    aEntry->SyncPresentationState();
    viewer->Destroy();
  }

  // When dropping bfcache, we have to remove associated dynamic entries as
  // well.
  int32_t index = GetIndexOfEntry(aEntry);
  if (index != -1) {
    RemoveDynEntries(index, aEntry);
  }
}

nsSHistory::nsSHistory(BrowsingContext* aRootBC)
    : mRootBC(aRootBC),
      mIsRemote(false),
      mIndex(-1),
      mRequestedIndex(-1),
      mRootDocShellID(aRootBC->GetHistoryID()) {
  // Add this new SHistory object to the list
  gSHistoryList.insertBack(this);

  // Init mHistoryTracker on setting mRootBC so we can bind its event
  // target to the tabGroup.
  nsPIDOMWindowOuter* win;
  if (mRootBC && (win = mRootBC->GetDOMWindow())) {
    nsCOMPtr<nsIGlobalObject> global = do_QueryInterface(win);
    mHistoryTracker = mozilla::MakeUnique<HistoryTracker>(
        this,
        mozilla::Preferences::GetUint(CONTENT_VIEWER_TIMEOUT_SECONDS,
                                      CONTENT_VIEWER_TIMEOUT_SECONDS_DEFAULT),
        global->EventTargetFor(mozilla::TaskCategory::Other));
  }
}

nsSHistory::~nsSHistory() {}

NS_IMPL_ADDREF(nsSHistory)
NS_IMPL_RELEASE(nsSHistory)

NS_INTERFACE_MAP_BEGIN(nsSHistory)
  NS_INTERFACE_MAP_ENTRY_AMBIGUOUS(nsISupports, nsISHistory)
  NS_INTERFACE_MAP_ENTRY(nsISHistory)
  NS_INTERFACE_MAP_ENTRY(nsISupportsWeakReference)
NS_INTERFACE_MAP_END

// static
uint32_t nsSHistory::CalcMaxTotalViewers() {
// This value allows tweaking how fast the allowed amount of content viewers
// grows with increasing amounts of memory. Larger values mean slower growth.
#ifdef ANDROID
#  define MAX_TOTAL_VIEWERS_BIAS 15.9
#else
#  define MAX_TOTAL_VIEWERS_BIAS 14
#endif

  // Calculate an estimate of how many ContentViewers we should cache based
  // on RAM.  This assumes that the average ContentViewer is 4MB (conservative)
  // and caps the max at 8 ContentViewers
  //
  // TODO: Should we split the cache memory betw. ContentViewer caching and
  // nsCacheService?
  //
  // RAM    | ContentViewers | on Android
  // -------------------------------------
  // 32   Mb       0                0
  // 64   Mb       1                0
  // 128  Mb       2                0
  // 256  Mb       3                1
  // 512  Mb       5                2
  // 768  Mb       6                2
  // 1024 Mb       8                3
  // 2048 Mb       8                5
  // 3072 Mb       8                7
  // 4096 Mb       8                8
  uint64_t bytes = PR_GetPhysicalMemorySize();

  if (bytes == 0) {
    return 0;
  }

  // Conversion from unsigned int64_t to double doesn't work on all platforms.
  // We need to truncate the value at INT64_MAX to make sure we don't
  // overflow.
  if (bytes > INT64_MAX) {
    bytes = INT64_MAX;
  }

  double kBytesD = (double)(bytes >> 10);

  // This is essentially the same calculation as for nsCacheService,
  // except that we divide the final memory calculation by 4, since
  // we assume each ContentViewer takes on average 4MB
  uint32_t viewers = 0;
  double x = std::log(kBytesD) / std::log(2.0) - MAX_TOTAL_VIEWERS_BIAS;
  if (x > 0) {
    viewers = (uint32_t)(x * x - x + 2.001);  // add .001 for rounding
    viewers /= 4;
  }

  // Cap it off at 8 max
  if (viewers > 8) {
    viewers = 8;
  }
  return viewers;
}

// static
void nsSHistory::UpdatePrefs() {
  Preferences::GetInt(PREF_SHISTORY_SIZE, &gHistoryMaxSize);
  Preferences::GetInt(PREF_SHISTORY_MAX_TOTAL_VIEWERS,
                      &sHistoryMaxTotalViewers);
  // If the pref is negative, that means we calculate how many viewers
  // we think we should cache, based on total memory
  if (sHistoryMaxTotalViewers < 0) {
    sHistoryMaxTotalViewers = CalcMaxTotalViewers();
  }
}

// static
nsresult nsSHistory::Startup() {
  UpdatePrefs();

  // The goal of this is to unbreak users who have inadvertently set their
  // session history size to less than the default value.
  int32_t defaultHistoryMaxSize =
      Preferences::GetInt(PREF_SHISTORY_SIZE, 50, PrefValueKind::Default);
  if (gHistoryMaxSize < defaultHistoryMaxSize) {
    gHistoryMaxSize = defaultHistoryMaxSize;
  }

  // Allow the user to override the max total number of cached viewers,
  // but keep the per SHistory cached viewer limit constant
  if (!gObserver) {
    gObserver = new nsSHistoryObserver();
    Preferences::RegisterCallbacks(nsSHistoryObserver::PrefChanged,
                                   kObservedPrefs, gObserver.get());

    nsCOMPtr<nsIObserverService> obsSvc =
        mozilla::services::GetObserverService();
    if (obsSvc) {
      // Observe empty-cache notifications so tahat clearing the disk/memory
      // cache will also evict all content viewers.
      obsSvc->AddObserver(gObserver, "cacheservice:empty-cache", false);

      // Same for memory-pressure notifications
      obsSvc->AddObserver(gObserver, "memory-pressure", false);
    }
  }

  return NS_OK;
}

// static
void nsSHistory::Shutdown() {
  if (gObserver) {
    Preferences::UnregisterCallbacks(nsSHistoryObserver::PrefChanged,
                                     kObservedPrefs, gObserver.get());

    nsCOMPtr<nsIObserverService> obsSvc =
        mozilla::services::GetObserverService();
    if (obsSvc) {
      obsSvc->RemoveObserver(gObserver, "cacheservice:empty-cache");
      obsSvc->RemoveObserver(gObserver, "memory-pressure");
    }
    gObserver = nullptr;
  }
}

// static
already_AddRefed<nsISHEntry> nsSHistory::GetRootSHEntry(nsISHEntry* aEntry) {
  nsCOMPtr<nsISHEntry> rootEntry = aEntry;
  nsCOMPtr<nsISHEntry> result = nullptr;
  while (rootEntry) {
    result = rootEntry;
    rootEntry = result->GetParent();
  }

  return result.forget();
}

// static
nsresult nsSHistory::WalkHistoryEntries(nsISHEntry* aRootEntry,
                                        BrowsingContext* aBC,
                                        WalkHistoryEntriesFunc aCallback,
                                        void* aData) {
  NS_ENSURE_TRUE(aRootEntry, NS_ERROR_FAILURE);

  int32_t childCount = aRootEntry->GetChildCount();
  for (int32_t i = 0; i < childCount; i++) {
    nsCOMPtr<nsISHEntry> childEntry;
    aRootEntry->GetChildAt(i, getter_AddRefs(childEntry));
    if (!childEntry) {
      // childEntry can be null for valid reasons, for example if the
      // docshell at index i never loaded anything useful.
      // Remember to clone also nulls in the child array (bug 464064).
      aCallback(nullptr, nullptr, i, aData);
      continue;
    }

    BrowsingContext* childBC = nullptr;
    if (aBC) {
      for (BrowsingContext* child : aBC->Children()) {
        // If the SH pref is on, or we are in the parent process, update
        // canonical BC directly
        nsDocShell* docshell = static_cast<nsDocShell*>(child->GetDocShell());
        if (docshell && docshell->HasHistoryEntry(childEntry)) {
          childBC = docshell->GetBrowsingContext();
          break;
        }
      }
    }

    nsresult rv = aCallback(childEntry, childBC, i, aData);
    NS_ENSURE_SUCCESS(rv, rv);
  }

  return NS_OK;
}

// callback data for WalkHistoryEntries
struct MOZ_STACK_CLASS CloneAndReplaceData {
  CloneAndReplaceData(uint32_t aCloneID, nsISHEntry* aReplaceEntry,
                      bool aCloneChildren, nsISHEntry* aDestTreeParent)
      : cloneID(aCloneID),
        cloneChildren(aCloneChildren),
        replaceEntry(aReplaceEntry),
        destTreeParent(aDestTreeParent) {}

  uint32_t cloneID;
  bool cloneChildren;
  nsISHEntry* replaceEntry;
  nsISHEntry* destTreeParent;
  nsCOMPtr<nsISHEntry> resultEntry;
};

nsresult nsSHistory::CloneAndReplaceChild(nsISHEntry* aEntry,
                                          BrowsingContext* aOwnerBC,
                                          int32_t aChildIndex, void* aData) {
  nsCOMPtr<nsISHEntry> dest;

  CloneAndReplaceData* data = static_cast<CloneAndReplaceData*>(aData);
  uint32_t cloneID = data->cloneID;
  nsISHEntry* replaceEntry = data->replaceEntry;

  if (!aEntry) {
    if (data->destTreeParent) {
      data->destTreeParent->AddChild(nullptr, aChildIndex);
    }
    return NS_OK;
  }

  uint32_t srcID = aEntry->GetID();

  nsresult rv = NS_OK;
  if (srcID == cloneID) {
    // Replace the entry
    dest = replaceEntry;
  } else {
    // Clone the SHEntry...
    rv = aEntry->Clone(getter_AddRefs(dest));
    NS_ENSURE_SUCCESS(rv, rv);
  }
  dest->SetIsSubFrame(true);

  if (srcID != cloneID || data->cloneChildren) {
    // Walk the children
    CloneAndReplaceData childData(cloneID, replaceEntry, data->cloneChildren,
                                  dest);
    rv = nsSHistory::WalkHistoryEntries(aEntry, aOwnerBC, CloneAndReplaceChild,
                                        &childData);
    NS_ENSURE_SUCCESS(rv, rv);
  }

  if (srcID != cloneID && aOwnerBC) {
    nsSHistory::HandleEntriesToSwapInDocShell(aOwnerBC, aEntry, dest);
  }

  if (data->destTreeParent) {
    data->destTreeParent->AddChild(dest, aChildIndex);
  }
  data->resultEntry = dest;
  return rv;
}

// static
nsresult nsSHistory::CloneAndReplace(
    nsISHEntry* aSrcEntry, BrowsingContext* aOwnerBC, uint32_t aCloneID,
    nsISHEntry* aReplaceEntry, bool aCloneChildren, nsISHEntry** aDestEntry) {
  NS_ENSURE_ARG_POINTER(aDestEntry);
  NS_ENSURE_TRUE(aReplaceEntry, NS_ERROR_FAILURE);
  CloneAndReplaceData data(aCloneID, aReplaceEntry, aCloneChildren, nullptr);
  nsresult rv = CloneAndReplaceChild(aSrcEntry, aOwnerBC, 0, &data);
  data.resultEntry.swap(*aDestEntry);
  return rv;
}

NS_IMETHODIMP
nsSHistory::AddChildSHEntryHelper(nsISHEntry* aCloneRef, nsISHEntry* aNewEntry,
                                  BrowsingContext* aBC, bool aCloneChildren) {
  nsCOMPtr<nsISHEntry> child;
  nsresult rv = AddChildSHEntryHelper(aCloneRef, aNewEntry, aBC, aCloneChildren,
                                      getter_AddRefs(child));
  if (NS_SUCCEEDED(rv)) {
    child->SetDocshellID(aBC->GetHistoryID());
  }
  return rv;
}

nsresult nsSHistory::AddChildSHEntryHelper(nsISHEntry* aCloneRef,
                                           nsISHEntry* aNewEntry,
                                           BrowsingContext* aBC,
                                           bool aCloneChildren,
                                           nsISHEntry** aNextEntry) {
  /* You are currently in the rootDocShell.
   * You will get here when a subframe has a new url
   * to load and you have walked up the tree all the
   * way to the top to clone the current SHEntry hierarchy
   * and replace the subframe where a new url was loaded with
   * a new entry.
   */
  nsCOMPtr<nsISHEntry> currentHE;
  int32_t index = mIndex;
  if (index < 0) {
    return NS_ERROR_FAILURE;
  }

  GetEntryAtIndex(index, getter_AddRefs(currentHE));
  NS_ENSURE_TRUE(currentHE, NS_ERROR_FAILURE);

  nsresult rv = NS_OK;
  uint32_t cloneID = aCloneRef->GetID();
  rv = nsSHistory::CloneAndReplace(currentHE, aBC, cloneID, aNewEntry,
                                   aCloneChildren, aNextEntry);
  if (NS_SUCCEEDED(rv)) {
    rv = AddEntry(*aNextEntry, true);
  }
  return rv;
}

nsresult nsSHistory::SetChildHistoryEntry(nsISHEntry* aEntry,
                                          BrowsingContext* aBC,
                                          int32_t aEntryIndex, void* aData) {
  SwapEntriesData* data = static_cast<SwapEntriesData*>(aData);
  if (!aBC || aBC == data->ignoreBC) {
    return NS_OK;
  }

  nsISHEntry* destTreeRoot = data->destTreeRoot;

  nsCOMPtr<nsISHEntry> destEntry;

  if (data->destTreeParent) {
    // aEntry is a clone of some child of destTreeParent, but since the
    // trees aren't necessarily in sync, we'll have to locate it.
    // Note that we could set aShell's entry to null if we don't find a
    // corresponding entry under destTreeParent.

    uint32_t targetID = aEntry->GetID();

    // First look at the given index, since this is the common case.
    nsCOMPtr<nsISHEntry> entry;
    data->destTreeParent->GetChildAt(aEntryIndex, getter_AddRefs(entry));
    if (entry && entry->GetID() == targetID) {
      destEntry.swap(entry);
    } else {
      int32_t childCount;
      data->destTreeParent->GetChildCount(&childCount);
      for (int32_t i = 0; i < childCount; ++i) {
        data->destTreeParent->GetChildAt(i, getter_AddRefs(entry));
        if (!entry) {
          continue;
        }

        if (entry->GetID() == targetID) {
          destEntry.swap(entry);
          break;
        }
      }
    }
  } else {
    destEntry = destTreeRoot;
  }

  nsSHistory::HandleEntriesToSwapInDocShell(aBC, aEntry, destEntry);
  // Now handle the children of aEntry.
  SwapEntriesData childData = {data->ignoreBC, destTreeRoot, destEntry};
  return nsSHistory::WalkHistoryEntries(aEntry, aBC, SetChildHistoryEntry,
                                        &childData);
}

// static
void nsSHistory::HandleEntriesToSwapInDocShell(
    mozilla::dom::BrowsingContext* aBC, nsISHEntry* aOldEntry,
    nsISHEntry* aNewEntry) {
  bool shPref = StaticPrefs::fission_sessionHistoryInParent();
  if (aBC->IsInProcess() || !shPref) {
    nsDocShell* docshell = static_cast<nsDocShell*>(aBC->GetDocShell());
    if (docshell) {
      docshell->SwapHistoryEntries(aOldEntry, aNewEntry);
    }
  } else {
    // FIXME Bug 1633988: Need to update entries?
  }
}

NS_IMETHODIMP
nsSHistory::AddToRootSessionHistory(bool aCloneChildren, nsISHEntry* aOSHE,
                                    BrowsingContext* aBC, nsISHEntry* aEntry,
                                    uint32_t aLoadType, bool aShouldPersist,
                                    Maybe<int32_t>* aPreviousEntryIndex,
                                    Maybe<int32_t>* aLoadedEntryIndex) {
  nsresult rv = NS_OK;

  // If we need to clone our children onto the new session
  // history entry, do so now.
  if (aCloneChildren && aOSHE) {
    uint32_t cloneID = aOSHE->GetID();
    nsCOMPtr<nsISHEntry> newEntry;
    nsSHistory::CloneAndReplace(aOSHE, aBC, cloneID, aEntry, true,
                                getter_AddRefs(newEntry));
    NS_ASSERTION(aEntry == newEntry,
                 "The new session history should be in the new entry");
  }
  // This is the root docshell
  bool addToSHistory = !LOAD_TYPE_HAS_FLAGS(
      aLoadType, nsIWebNavigation::LOAD_FLAGS_REPLACE_HISTORY);
  if (!addToSHistory) {
    // Replace current entry in session history; If the requested index is
    // valid, it indicates the loading was triggered by a history load, and
    // we should replace the entry at requested index instead.
    int32_t index = mRequestedIndex;
    if (index == -1) {
      index = mIndex;
    }

    // Replace the current entry with the new entry
    if (index >= 0) {
      rv = ReplaceEntry(index, aEntry);
    } else {
      // If we're trying to replace an inexistant shistory entry, append.
      addToSHistory = true;
    }
  }
  if (addToSHistory) {
    // Add to session history
    *aPreviousEntryIndex = Some(mIndex);
    rv = AddEntry(aEntry, aShouldPersist);
    *aLoadedEntryIndex = Some(mIndex);
    MOZ_LOG(gPageCacheLog, LogLevel::Verbose,
            ("Previous index: %d, Loaded index: %d",
             aPreviousEntryIndex->value(), aLoadedEntryIndex->value()));
  }
  if (NS_SUCCEEDED(rv)) {
    aEntry->SetDocshellID(aBC->GetHistoryID());
  }
  return rv;
}

/* Add an entry to the History list at mIndex and
 * increment the index to point to the new entry
 */
NS_IMETHODIMP
nsSHistory::AddEntry(nsISHEntry* aSHEntry, bool aPersist) {
  NS_ENSURE_ARG(aSHEntry);

  nsCOMPtr<nsISHistory> shistoryOfEntry = aSHEntry->GetShistory();
  if (shistoryOfEntry != this) {
    NS_WARNING(
        "The entry has been associated to another nsISHistory instance. "
        "Try nsISHEntry.clone() and nsISHEntry.abandonBFCacheEntry() "
        "first if you're copying an entry from another nsISHistory.");
    return NS_ERROR_FAILURE;
  }

  // If we have a root docshell, update the docshell id of the root shentry to
  // match the id of that docshell
  if (mRootBC) {
    aSHEntry->SetDocshellID(mRootDocShellID);
  }

  if (mIndex >= 0) {
    MOZ_ASSERT(mIndex < Length(), "Index out of range!");
    if (mIndex >= Length()) {
      return NS_ERROR_FAILURE;
    }

    if (mEntries[mIndex] && !mEntries[mIndex]->GetPersist()) {
      NOTIFY_LISTENERS(OnHistoryReplaceEntry, ());
      aSHEntry->SetPersist(aPersist);
      mEntries[mIndex] = aSHEntry;
      return NS_OK;
    }
  }

  nsCOMPtr<nsIURI> uri = aSHEntry->GetURI();
  NOTIFY_LISTENERS(OnHistoryNewEntry, (uri, mIndex));

  // Remove all entries after the current one, add the new one, and set the new
  // one as the current one.
  MOZ_ASSERT(mIndex >= -1);
  aSHEntry->SetPersist(aPersist);
  mEntries.TruncateLength(mIndex + 1);
  mEntries.AppendElement(aSHEntry);
  mIndex++;

  // Purge History list if it is too long
  if (gHistoryMaxSize >= 0 && Length() > gHistoryMaxSize) {
    PurgeHistory(Length() - gHistoryMaxSize);
  }

  return NS_OK;
}

/* Get size of the history list */
NS_IMETHODIMP
nsSHistory::GetCount(int32_t* aResult) {
  MOZ_ASSERT(aResult, "null out param?");
  *aResult = Length();
  return NS_OK;
}

NS_IMETHODIMP
nsSHistory::GetIndex(int32_t* aResult) {
  MOZ_ASSERT(aResult, "null out param?");
  *aResult = mIndex;
  return NS_OK;
}

NS_IMETHODIMP
nsSHistory::SetIndex(int32_t aIndex) {
  if (aIndex < 0 || aIndex >= Length()) {
    return NS_ERROR_FAILURE;
  }

  mIndex = aIndex;
  return NS_OK;
}

/* Get the requestedIndex */
NS_IMETHODIMP
nsSHistory::GetRequestedIndex(int32_t* aResult) {
  MOZ_ASSERT(aResult, "null out param?");
  *aResult = mRequestedIndex;
  return NS_OK;
}

NS_IMETHODIMP_(void)
nsSHistory::InternalSetRequestedIndex(int32_t aRequestedIndex) {
  MOZ_ASSERT(aRequestedIndex >= -1 && aRequestedIndex < Length());
  mRequestedIndex = aRequestedIndex;
}

NS_IMETHODIMP
nsSHistory::GetEntryAtIndex(int32_t aIndex, nsISHEntry** aResult) {
  NS_ENSURE_ARG_POINTER(aResult);

  if (aIndex < 0 || aIndex >= Length()) {
    return NS_ERROR_FAILURE;
  }

  *aResult = mEntries[aIndex];
  NS_ADDREF(*aResult);
  return NS_OK;
}

NS_IMETHODIMP_(int32_t)
nsSHistory::GetIndexOfEntry(nsISHEntry* aSHEntry) {
  for (int32_t i = 0; i < Length(); i++) {
    if (aSHEntry == mEntries[i]) {
      return i;
    }
  }

  return -1;
}

#ifdef DEBUG
nsresult nsSHistory::PrintHistory() {
  for (int32_t i = 0; i < Length(); i++) {
    nsCOMPtr<nsISHEntry> entry = mEntries[i];
    nsCOMPtr<nsILayoutHistoryState> layoutHistoryState =
        entry->GetLayoutHistoryState();
    nsCOMPtr<nsIURI> uri = entry->GetURI();
    nsString title;
    entry->GetTitle(title);

#  if 0
    nsAutoCString url;
    if (uri) {
      uri->GetSpec(url);
    }

    printf("**** SH Entry #%d: %x\n", i, entry.get());
    printf("\t\t URL = %s\n", url.get());

    printf("\t\t Title = %s\n", NS_LossyConvertUTF16toASCII(title).get());
    printf("\t\t layout History Data = %x\n", layoutHistoryState.get());
#  endif
  }

  return NS_OK;
}
#endif

void nsSHistory::WindowIndices(int32_t aIndex, int32_t* aOutStartIndex,
                               int32_t* aOutEndIndex) {
  *aOutStartIndex = std::max(0, aIndex - nsSHistory::VIEWER_WINDOW);
  *aOutEndIndex = std::min(Length() - 1, aIndex + nsSHistory::VIEWER_WINDOW);
}

NS_IMETHODIMP
nsSHistory::PurgeHistory(int32_t aNumEntries) {
  if (Length() <= 0 || aNumEntries <= 0) {
    return NS_ERROR_FAILURE;
  }

  aNumEntries = std::min(aNumEntries, Length());

  NOTIFY_LISTENERS(OnHistoryPurge, ());

  // Remove the first `aNumEntries` entries.
  mEntries.RemoveElementsAt(0, aNumEntries);

  // Adjust the indices, but don't let them go below -1.
  mIndex -= aNumEntries;
  mIndex = std::max(mIndex, -1);
  mRequestedIndex -= aNumEntries;
  mRequestedIndex = std::max(mRequestedIndex, -1);

  if (mRootBC && mRootBC->GetDocShell()) {
    mRootBC->GetDocShell()->HistoryPurged(aNumEntries);
  }

  return NS_OK;
}

NS_IMETHODIMP
nsSHistory::AddSHistoryListener(nsISHistoryListener* aListener) {
  NS_ENSURE_ARG_POINTER(aListener);

  // Check if the listener supports Weak Reference. This is a must.
  // This listener functionality is used by embedders and we want to
  // have the right ownership with who ever listens to SHistory
  nsWeakPtr listener = do_GetWeakReference(aListener);
  if (!listener) {
    return NS_ERROR_FAILURE;
  }

  mListeners.AppendElementUnlessExists(listener);
  return NS_OK;
}

void nsSHistory::NotifyListenersContentViewerEvicted(uint32_t aNumEvicted) {
  NOTIFY_LISTENERS(OnContentViewerEvicted, (aNumEvicted));
}

NS_IMETHODIMP
nsSHistory::RemoveSHistoryListener(nsISHistoryListener* aListener) {
  // Make sure the listener that wants to be removed is the
  // one we have in store.
  nsWeakPtr listener = do_GetWeakReference(aListener);
  mListeners.RemoveElement(listener);
  return NS_OK;
}

/* Replace an entry in the History list at a particular index.
 * Do not update index or count.
 */
NS_IMETHODIMP
nsSHistory::ReplaceEntry(int32_t aIndex, nsISHEntry* aReplaceEntry) {
  NS_ENSURE_ARG(aReplaceEntry);

  if (aIndex < 0 || aIndex >= Length()) {
    return NS_ERROR_FAILURE;
  }

  nsCOMPtr<nsISHistory> shistoryOfEntry = aReplaceEntry->GetShistory();
  if (shistoryOfEntry != this) {
    NS_WARNING(
        "The entry has been associated to another nsISHistory instance. "
        "Try nsISHEntry.clone() and nsISHEntry.abandonBFCacheEntry() "
        "first if you're copying an entry from another nsISHistory.");
    return NS_ERROR_FAILURE;
  }

  NOTIFY_LISTENERS(OnHistoryReplaceEntry, ());

  aReplaceEntry->SetPersist(true);
  mEntries[aIndex] = aReplaceEntry;

  return NS_OK;
}

NS_IMETHODIMP
nsSHistory::NotifyOnHistoryReload(bool* aCanReload) {
  NOTIFY_LISTENERS_CANCELABLE(OnHistoryReload, *aCanReload, (aCanReload));
  return NS_OK;
}

NS_IMETHODIMP
nsSHistory::EvictOutOfRangeContentViewers(int32_t aIndex) {
  // Check our per SHistory object limit in the currently navigated SHistory
  EvictOutOfRangeWindowContentViewers(aIndex);
  // Check our total limit across all SHistory objects
  GloballyEvictContentViewers();
  return NS_OK;
}

NS_IMETHODIMP_(void)
nsSHistory::EvictContentViewersOrReplaceEntry(nsISHEntry* aNewSHEntry,
                                              bool aReplace) {
  if (!aReplace) {
    int32_t curIndex;
    GetIndex(&curIndex);
    if (curIndex > -1) {
      EvictOutOfRangeContentViewers(curIndex);
    }
  } else {
    nsCOMPtr<nsISHEntry> rootSHEntry = nsSHistory::GetRootSHEntry(aNewSHEntry);

    int32_t index = GetIndexOfEntry(rootSHEntry);
    if (index > -1) {
      ReplaceEntry(index, rootSHEntry);
    }
  }
}

NS_IMETHODIMP
nsSHistory::EvictAllContentViewers() {
  // XXXbz we don't actually do a good job of evicting things as we should, so
  // we might have viewers quite far from mIndex.  So just evict everything.
  for (int32_t i = 0; i < Length(); i++) {
    EvictContentViewerForEntry(mEntries[i]);
  }

  return NS_OK;
}

/* static */
void nsSHistory::LoadURIs(nsTArray<LoadEntryResult>& aLoadResults) {
  for (LoadEntryResult& loadEntry : aLoadResults) {
    loadEntry.mBrowsingContext->LoadURI(loadEntry.mLoadState, false);
  }
}

NS_IMETHODIMP
nsSHistory::Reload(uint32_t aReloadFlags) {
  nsTArray<LoadEntryResult> loadResults;
  nsresult rv = Reload(aReloadFlags, loadResults);
  NS_ENSURE_SUCCESS(rv, rv);

  if (loadResults.IsEmpty()) {
    return NS_OK;
  }

  LoadURIs(loadResults);
  return NS_OK;
}

nsresult nsSHistory::Reload(uint32_t aReloadFlags,
                            nsTArray<LoadEntryResult>& aLoadResults) {
  MOZ_ASSERT(aLoadResults.IsEmpty());

  uint32_t loadType;
  if (aReloadFlags & nsIWebNavigation::LOAD_FLAGS_BYPASS_PROXY &&
      aReloadFlags & nsIWebNavigation::LOAD_FLAGS_BYPASS_CACHE) {
    loadType = LOAD_RELOAD_BYPASS_PROXY_AND_CACHE;
  } else if (aReloadFlags & nsIWebNavigation::LOAD_FLAGS_BYPASS_PROXY) {
    loadType = LOAD_RELOAD_BYPASS_PROXY;
  } else if (aReloadFlags & nsIWebNavigation::LOAD_FLAGS_BYPASS_CACHE) {
    loadType = LOAD_RELOAD_BYPASS_CACHE;
  } else if (aReloadFlags & nsIWebNavigation::LOAD_FLAGS_CHARSET_CHANGE) {
    loadType = LOAD_RELOAD_CHARSET_CHANGE;
  } else if (aReloadFlags & nsIWebNavigation::LOAD_FLAGS_ALLOW_MIXED_CONTENT) {
    loadType = LOAD_RELOAD_ALLOW_MIXED_CONTENT;
  } else {
    loadType = LOAD_RELOAD_NORMAL;
  }

  // We are reloading. Send Reload notifications.
  // nsDocShellLoadFlagType is not public, where as nsIWebNavigation
  // is public. So send the reload notifications with the
  // nsIWebNavigation flags.
  bool canNavigate = true;
  NOTIFY_LISTENERS_CANCELABLE(OnHistoryReload, canNavigate, (&canNavigate));
  if (!canNavigate) {
    return NS_OK;
  }

  nsresult rv = LoadEntry(mIndex, loadType, HIST_CMD_RELOAD, aLoadResults);
  if (NS_FAILED(rv)) {
    aLoadResults.Clear();
    return rv;
  }

  return NS_OK;
}

NS_IMETHODIMP
nsSHistory::ReloadCurrentEntry() {
  nsTArray<LoadEntryResult> loadResults;
  nsresult rv = ReloadCurrentEntry(loadResults);
  NS_ENSURE_SUCCESS(rv, rv);

  LoadURIs(loadResults);
  return NS_OK;
}

nsresult nsSHistory::ReloadCurrentEntry(
    nsTArray<LoadEntryResult>& aLoadResults) {
  // Notify listeners
  NOTIFY_LISTENERS(OnHistoryGotoIndex, ());

  return LoadEntry(mIndex, LOAD_HISTORY, HIST_CMD_RELOAD, aLoadResults);
}

void nsSHistory::EvictOutOfRangeWindowContentViewers(int32_t aIndex) {
  // XXX rename method to EvictContentViewersExceptAroundIndex, or something.

  // We need to release all content viewers that are no longer in the range
  //
  //  aIndex - VIEWER_WINDOW to aIndex + VIEWER_WINDOW
  //
  // to ensure that this SHistory object isn't responsible for more than
  // VIEWER_WINDOW content viewers.  But our job is complicated by the
  // fact that two entries which are related by either hash navigations or
  // history.pushState will have the same content viewer.
  //
  // To illustrate the issue, suppose VIEWER_WINDOW = 3 and we have four
  // linked entries in our history.  Suppose we then add a new content
  // viewer and call into this function.  So the history looks like:
  //
  //   A A A A B
  //     +     *
  //
  // where the letters are content viewers and + and * denote the beginning and
  // end of the range aIndex +/- VIEWER_WINDOW.
  //
  // Although one copy of the content viewer A exists outside the range, we
  // don't want to evict A, because it has other copies in range!
  //
  // We therefore adjust our eviction strategy to read:
  //
  //   Evict each content viewer outside the range aIndex -/+
  //   VIEWER_WINDOW, unless that content viewer also appears within the
  //   range.
  //
  // (Note that it's entirely legal to have two copies of one content viewer
  // separated by a different content viewer -- call pushState twice, go back
  // once, and refresh -- so we can't rely on identical viewers only appearing
  // adjacent to one another.)

  if (aIndex < 0) {
    return;
  }
  NS_ENSURE_TRUE_VOID(aIndex < Length());

  // Calculate the range that's safe from eviction.
  int32_t startSafeIndex, endSafeIndex;
  WindowIndices(aIndex, &startSafeIndex, &endSafeIndex);

  LOG(
      ("EvictOutOfRangeWindowContentViewers(index=%d), "
       "Length()=%d. Safe range [%d, %d]",
       aIndex, Length(), startSafeIndex, endSafeIndex));

  // The content viewers in range aIndex -/+ VIEWER_WINDOW will not be
  // evicted.  Collect a set of them so we don't accidentally evict one of them
  // if it appears outside this range.
  nsCOMArray<nsIContentViewer> safeViewers;
  for (int32_t i = startSafeIndex; i <= endSafeIndex; i++) {
    nsCOMPtr<nsIContentViewer> viewer = mEntries[i]->GetContentViewer();
    safeViewers.AppendObject(viewer);
  }

  // Walk the SHistory list and evict any content viewers that aren't safe.
  // (It's important that the condition checks Length(), rather than a cached
  // copy of Length(), because the length might change between iterations.)
  for (int32_t i = 0; i < Length(); i++) {
    nsCOMPtr<nsISHEntry> entry = mEntries[i];
    nsCOMPtr<nsIContentViewer> viewer = entry->GetContentViewer();
    if (safeViewers.IndexOf(viewer) == -1) {
      EvictContentViewerForEntry(entry);
    }
  }
}

namespace {

class EntryAndDistance {
 public:
  EntryAndDistance(nsSHistory* aSHistory, nsISHEntry* aEntry, uint32_t aDist)
      : mSHistory(aSHistory),
        mEntry(aEntry),
        mViewer(aEntry->GetContentViewer()),
        mLastTouched(mEntry->GetLastTouched()),
        mDistance(aDist) {
    NS_ASSERTION(mViewer, "Entry should have a content viewer");
  }

  bool operator<(const EntryAndDistance& aOther) const {
    // Compare distances first, and fall back to last-accessed times.
    if (aOther.mDistance != this->mDistance) {
      return this->mDistance < aOther.mDistance;
    }

    return this->mLastTouched < aOther.mLastTouched;
  }

  bool operator==(const EntryAndDistance& aOther) const {
    // This is a little silly; we need == so the default comaprator can be
    // instantiated, but this function is never actually called when we sort
    // the list of EntryAndDistance objects.
    return aOther.mDistance == this->mDistance &&
           aOther.mLastTouched == this->mLastTouched;
  }

  RefPtr<nsSHistory> mSHistory;
  nsCOMPtr<nsISHEntry> mEntry;
  nsCOMPtr<nsIContentViewer> mViewer;
  uint32_t mLastTouched;
  int32_t mDistance;
};

}  // namespace

// static
void nsSHistory::GloballyEvictContentViewers() {
  // First, collect from each SHistory object the entries which have a cached
  // content viewer. Associate with each entry its distance from its SHistory's
  // current index.

  nsTArray<EntryAndDistance> entries;

  for (auto shist : gSHistoryList) {
    // FIXME Bug 1546348: Make global eviction work for session history in the
    //       parent and remove mIsRemote.
    if (shist->mIsRemote) {
      continue;
    }

    // Maintain a list of the entries which have viewers and belong to
    // this particular shist object.  We'll add this list to the global list,
    // |entries|, eventually.
    nsTArray<EntryAndDistance> shEntries;

    // Content viewers are likely to exist only within shist->mIndex -/+
    // VIEWER_WINDOW, so only search within that range.
    //
    // A content viewer might exist outside that range due to either:
    //
    //   * history.pushState or hash navigations, in which case a copy of the
    //     content viewer should exist within the range, or
    //
    //   * bugs which cause us not to call nsSHistory::EvictContentViewers()
    //     often enough.  Once we do call EvictContentViewers() for the
    //     SHistory object in question, we'll do a full search of its history
    //     and evict the out-of-range content viewers, so we don't bother here.
    //
    int32_t startIndex, endIndex;
    shist->WindowIndices(shist->mIndex, &startIndex, &endIndex);
    for (int32_t i = startIndex; i <= endIndex; i++) {
      nsCOMPtr<nsISHEntry> entry = shist->mEntries[i];
      nsCOMPtr<nsIContentViewer> contentViewer = entry->GetContentViewer();

      if (contentViewer) {
        // Because one content viewer might belong to multiple SHEntries, we
        // have to search through shEntries to see if we already know
        // about this content viewer.  If we find the viewer, update its
        // distance from the SHistory's index and continue.
        bool found = false;
        for (uint32_t j = 0; j < shEntries.Length(); j++) {
          EntryAndDistance& container = shEntries[j];
          if (container.mViewer == contentViewer) {
            container.mDistance =
                std::min(container.mDistance, DeprecatedAbs(i - shist->mIndex));
            found = true;
            break;
          }
        }

        // If we didn't find a EntryAndDistance for this content viewer, make a
        // new one.
        if (!found) {
          EntryAndDistance container(shist, entry,
                                     DeprecatedAbs(i - shist->mIndex));
          shEntries.AppendElement(container);
        }
      }
    }

    // We've found all the entries belonging to shist which have viewers.
    // Add those entries to our global list and move on.
    entries.AppendElements(shEntries);
  }

  // We now have collected all cached content viewers.  First check that we
  // have enough that we actually need to evict some.
  if ((int32_t)entries.Length() <= sHistoryMaxTotalViewers) {
    return;
  }

  // If we need to evict, sort our list of entries and evict the largest
  // ones.  (We could of course get better algorithmic complexity here by using
  // a heap or something more clever.  But sHistoryMaxTotalViewers isn't large,
  // so let's not worry about it.)
  entries.Sort();

  for (int32_t i = entries.Length() - 1; i >= sHistoryMaxTotalViewers; --i) {
    (entries[i].mSHistory)->EvictContentViewerForEntry(entries[i].mEntry);
  }
}

nsresult nsSHistory::FindEntryForBFCache(nsIBFCacheEntry* aBFEntry,
                                         nsISHEntry** aResult,
                                         int32_t* aResultIndex) {
  *aResult = nullptr;
  *aResultIndex = -1;

  int32_t startIndex, endIndex;
  WindowIndices(mIndex, &startIndex, &endIndex);

  for (int32_t i = startIndex; i <= endIndex; ++i) {
    nsCOMPtr<nsISHEntry> shEntry = mEntries[i];

    // Does shEntry have the same BFCacheEntry as the argument to this method?
    if (shEntry->HasBFCacheEntry(aBFEntry)) {
      shEntry.forget(aResult);
      *aResultIndex = i;
      return NS_OK;
    }
  }
  return NS_ERROR_FAILURE;
}

nsresult nsSHistory::EvictExpiredContentViewerForEntry(
    nsIBFCacheEntry* aBFEntry) {
  int32_t index;
  nsCOMPtr<nsISHEntry> shEntry;
  FindEntryForBFCache(aBFEntry, getter_AddRefs(shEntry), &index);

  if (index == mIndex) {
    NS_WARNING("How did the current SHEntry expire?");
    return NS_OK;
  }

  if (shEntry) {
    EvictContentViewerForEntry(shEntry);
  }

  return NS_OK;
}

NS_IMETHODIMP_(void)
nsSHistory::AddToExpirationTracker(nsIBFCacheEntry* aBFEntry) {
  RefPtr<nsSHEntryShared> entry = static_cast<nsSHEntryShared*>(aBFEntry);
  if (!mHistoryTracker || !entry) {
    return;
  }

  mHistoryTracker->AddObject(entry);
  return;
}

NS_IMETHODIMP_(void)
nsSHistory::RemoveFromExpirationTracker(nsIBFCacheEntry* aBFEntry) {
  RefPtr<nsSHEntryShared> entry = static_cast<nsSHEntryShared*>(aBFEntry);
  MOZ_ASSERT(mHistoryTracker && !mHistoryTracker->IsEmpty());
  if (!mHistoryTracker || !entry) {
    return;
  }

  mHistoryTracker->RemoveObject(entry);
}

// Evicts all content viewers in all history objects.  This is very
// inefficient, because it requires a linear search through all SHistory
// objects for each viewer to be evicted.  However, this method is called
// infrequently -- only when the disk or memory cache is cleared.

// static
void nsSHistory::GloballyEvictAllContentViewers() {
  int32_t maxViewers = sHistoryMaxTotalViewers;
  sHistoryMaxTotalViewers = 0;
  GloballyEvictContentViewers();
  sHistoryMaxTotalViewers = maxViewers;
}

void GetDynamicChildren(nsISHEntry* aEntry, nsTArray<nsID>& aDocshellIDs) {
  int32_t count = aEntry->GetChildCount();
  for (int32_t i = 0; i < count; ++i) {
    nsCOMPtr<nsISHEntry> child;
    aEntry->GetChildAt(i, getter_AddRefs(child));
    if (child) {
      if (child->IsDynamicallyAdded()) {
        child->GetDocshellID(*aDocshellIDs.AppendElement());
      } else {
        GetDynamicChildren(child, aDocshellIDs);
      }
    }
  }
}

bool RemoveFromSessionHistoryEntry(nsISHEntry* aRoot,
                                   nsTArray<nsID>& aDocshellIDs) {
  bool didRemove = false;
  int32_t childCount = aRoot->GetChildCount();
  for (int32_t i = childCount - 1; i >= 0; --i) {
    nsCOMPtr<nsISHEntry> child;
    aRoot->GetChildAt(i, getter_AddRefs(child));
    if (child) {
      nsID docshelldID;
      child->GetDocshellID(docshelldID);
      if (aDocshellIDs.Contains(docshelldID)) {
        didRemove = true;
        aRoot->RemoveChild(child);
      } else if (RemoveFromSessionHistoryEntry(child, aDocshellIDs)) {
        didRemove = true;
      }
    }
  }
  return didRemove;
}

bool RemoveChildEntries(nsISHistory* aHistory, int32_t aIndex,
                        nsTArray<nsID>& aEntryIDs) {
  nsCOMPtr<nsISHEntry> root;
  aHistory->GetEntryAtIndex(aIndex, getter_AddRefs(root));
  return root ? RemoveFromSessionHistoryEntry(root, aEntryIDs) : false;
}

bool IsSameTree(nsISHEntry* aEntry1, nsISHEntry* aEntry2) {
  if (!aEntry1 && !aEntry2) {
    return true;
  }
  if ((!aEntry1 && aEntry2) || (aEntry1 && !aEntry2)) {
    return false;
  }
  uint32_t id1 = aEntry1->GetID();
  uint32_t id2 = aEntry2->GetID();
  if (id1 != id2) {
    return false;
  }

  int32_t count1 = aEntry1->GetChildCount();
  int32_t count2 = aEntry2->GetChildCount();
  // We allow null entries in the end of the child list.
  int32_t count = std::max(count1, count2);
  for (int32_t i = 0; i < count; ++i) {
    nsCOMPtr<nsISHEntry> child1, child2;
    aEntry1->GetChildAt(i, getter_AddRefs(child1));
    aEntry2->GetChildAt(i, getter_AddRefs(child2));
    if (!IsSameTree(child1, child2)) {
      return false;
    }
  }

  return true;
}

bool nsSHistory::RemoveDuplicate(int32_t aIndex, bool aKeepNext) {
  NS_ASSERTION(aIndex >= 0, "aIndex must be >= 0!");
  NS_ASSERTION(aIndex != 0 || aKeepNext,
               "If we're removing index 0 we must be keeping the next");
  NS_ASSERTION(aIndex != mIndex, "Shouldn't remove mIndex!");

  int32_t compareIndex = aKeepNext ? aIndex + 1 : aIndex - 1;

  nsresult rv;
  nsCOMPtr<nsISHEntry> root1, root2;
  rv = GetEntryAtIndex(aIndex, getter_AddRefs(root1));
  if (NS_FAILED(rv)) {
    return false;
  }
  rv = GetEntryAtIndex(compareIndex, getter_AddRefs(root2));
  if (NS_FAILED(rv)) {
    return false;
  }

  if (IsSameTree(root1, root2)) {
    mEntries.RemoveElementAt(aIndex);

    // FIXME Bug 1546350: Reimplement history listeners.
    // if (mRootBC && mRootBC->GetDocShell()) {
    //  static_cast<nsDocShell*>(mRootBC->GetDocShell())
    //      ->HistoryEntryRemoved(aIndex);
    //}

    // Adjust our indices to reflect the removed entry.
    if (mIndex > aIndex) {
      mIndex = mIndex - 1;
    }

    // NB: If the entry we are removing is the entry currently
    // being navigated to (mRequestedIndex) then we adjust the index
    // only if we're not keeping the next entry (because if we are keeping
    // the next entry (because the current is a duplicate of the next), then
    // that entry slides into the spot that we're currently pointing to.
    // We don't do this adjustment for mIndex because mIndex cannot equal
    // aIndex.

    // NB: We don't need to guard on mRequestedIndex being nonzero here,
    // because either they're strictly greater than aIndex which is at least
    // zero, or they are equal to aIndex in which case aKeepNext must be true
    // if aIndex is zero.
    if (mRequestedIndex > aIndex || (mRequestedIndex == aIndex && !aKeepNext)) {
      mRequestedIndex = mRequestedIndex - 1;
    }
    return true;
  }
  return false;
}

NS_IMETHODIMP_(void)
nsSHistory::RemoveEntries(nsTArray<nsID>& aIDs, int32_t aStartIndex) {
  bool didRemove;
  RemoveEntries(aIDs, aStartIndex, &didRemove);
  if (didRemove && mRootBC && mRootBC->GetDocShell()) {
    mRootBC->GetDocShell()->DispatchLocationChangeEvent();
  }
}

void nsSHistory::RemoveEntries(nsTArray<nsID>& aIDs, int32_t aStartIndex,
                               bool* aDidRemove) {
  int32_t index = aStartIndex;
  while (index >= 0 && RemoveChildEntries(this, --index, aIDs)) {
  }
  int32_t minIndex = index;
  index = aStartIndex;
  while (index >= 0 && RemoveChildEntries(this, index++, aIDs)) {
  }

  // We need to remove duplicate nsSHEntry trees.
  *aDidRemove = false;
  while (index > minIndex) {
    if (index != mIndex && RemoveDuplicate(index, index < mIndex)) {
      *aDidRemove = true;
    }
    --index;
  }
}

void nsSHistory::RemoveFrameEntries(nsISHEntry* aEntry) {
  int32_t count = aEntry->GetChildCount();
  AutoTArray<nsID, 16> ids;
  for (int32_t i = 0; i < count; ++i) {
    nsCOMPtr<nsISHEntry> child;
    aEntry->GetChildAt(i, getter_AddRefs(child));
    if (child) {
      child->GetDocshellID(*ids.AppendElement());
    }
  }
  RemoveEntries(ids, mIndex);
}

void nsSHistory::RemoveDynEntries(int32_t aIndex, nsISHEntry* aEntry) {
  // Remove dynamic entries which are at the index and belongs to the container.
  nsCOMPtr<nsISHEntry> entry(aEntry);
  if (!entry) {
    GetEntryAtIndex(aIndex, getter_AddRefs(entry));
  }

  if (entry) {
    AutoTArray<nsID, 16> toBeRemovedEntries;
    GetDynamicChildren(entry, toBeRemovedEntries);
    if (toBeRemovedEntries.Length()) {
      RemoveEntries(toBeRemovedEntries, aIndex);
    }
  }
}

void nsSHistory::RemoveDynEntriesForBFCacheEntry(nsIBFCacheEntry* aBFEntry) {
  int32_t index;
  nsCOMPtr<nsISHEntry> shEntry;
  FindEntryForBFCache(aBFEntry, getter_AddRefs(shEntry), &index);
  if (shEntry) {
    RemoveDynEntries(index, shEntry);
  }
}

NS_IMETHODIMP
nsSHistory::UpdateIndex() {
  // Update the actual index with the right value.
  if (mIndex != mRequestedIndex && mRequestedIndex != -1) {
    mIndex = mRequestedIndex;
  }

  mRequestedIndex = -1;
  return NS_OK;
}

NS_IMETHODIMP
nsSHistory::GotoIndex(int32_t aIndex) {
  nsTArray<LoadEntryResult> loadResults;
  nsresult rv = GotoIndex(aIndex, loadResults);
  NS_ENSURE_SUCCESS(rv, rv);

  LoadURIs(loadResults);
  return NS_OK;
}

NS_IMETHODIMP_(void)
nsSHistory::EnsureCorrectEntryAtCurrIndex(nsISHEntry* aEntry) {
  int index = mRequestedIndex == -1 ? mIndex : mRequestedIndex;
  if (index > -1 && (mEntries[index] != aEntry)) {
    ReplaceEntry(index, aEntry);
  }
}

nsresult nsSHistory::GotoIndex(int32_t aIndex,
                               nsTArray<LoadEntryResult>& aLoadResults) {
  return LoadEntry(aIndex, LOAD_HISTORY, HIST_CMD_GOTOINDEX, aLoadResults);
}

nsresult nsSHistory::LoadNextPossibleEntry(
    int32_t aNewIndex, long aLoadType, uint32_t aHistCmd,
    nsTArray<LoadEntryResult>& aLoadResults) {
  mRequestedIndex = -1;
  if (aNewIndex < mIndex) {
    return LoadEntry(aNewIndex - 1, aLoadType, aHistCmd, aLoadResults);
  }
  if (aNewIndex > mIndex) {
    return LoadEntry(aNewIndex + 1, aLoadType, aHistCmd, aLoadResults);
  }
  return NS_ERROR_FAILURE;
}

nsresult nsSHistory::LoadEntry(int32_t aIndex, long aLoadType,
                               uint32_t aHistCmd,
                               nsTArray<LoadEntryResult>& aLoadResults) {
  if (!mRootBC) {
    return NS_ERROR_FAILURE;
  }

  if (aIndex < 0 || aIndex >= Length()) {
    // The index is out of range
    return NS_ERROR_FAILURE;
  }

  // This is a normal local history navigation.
  // Keep note of requested history index in mRequestedIndex.
  mRequestedIndex = aIndex;

  nsCOMPtr<nsISHEntry> prevEntry;
  nsCOMPtr<nsISHEntry> nextEntry;
  GetEntryAtIndex(mIndex, getter_AddRefs(prevEntry));
  GetEntryAtIndex(mRequestedIndex, getter_AddRefs(nextEntry));
  if (!nextEntry || !prevEntry) {
    mRequestedIndex = -1;
    return NS_ERROR_FAILURE;
  }

  // Remember that this entry is getting loaded at this point in the sequence

  nextEntry->SetLastTouched(++gTouchCounter);

  // Get the uri for the entry we are about to visit
  nsCOMPtr<nsIURI> nextURI = nextEntry->GetURI();

  MOZ_ASSERT((prevEntry && nextEntry && nextURI),
             "prevEntry, nextEntry and nextURI can't be null");

  // Send appropriate listener notifications.
  if (aHistCmd == HIST_CMD_GOTOINDEX) {
    // We are going somewhere else. This is not reload either
    NOTIFY_LISTENERS(OnHistoryGotoIndex, ());
  }

  if (mRequestedIndex == mIndex) {
    // Possibly a reload case
    return InitiateLoad(nextEntry, mRootBC, aLoadType, aLoadResults);
  }

  // Going back or forward.
  bool differenceFound = false;
  nsresult rv = LoadDifferingEntries(prevEntry, nextEntry, mRootBC, aLoadType,
                                     differenceFound, aLoadResults);
  if (!differenceFound) {
    // We did not find any differences. Go further in the history.
    return LoadNextPossibleEntry(aIndex, aLoadType, aHistCmd, aLoadResults);
  }

  return rv;
}

nsresult nsSHistory::LoadDifferingEntries(
    nsISHEntry* aPrevEntry, nsISHEntry* aNextEntry, BrowsingContext* aParent,
    long aLoadType, bool& aDifferenceFound,
    nsTArray<LoadEntryResult>& aLoadResults) {
  if (!aPrevEntry || !aNextEntry || !aParent) {
    return NS_ERROR_FAILURE;
  }

  nsresult result = NS_OK;
  uint32_t prevID = aPrevEntry->GetID();
  uint32_t nextID = aNextEntry->GetID();

  // Check the IDs to verify if the pages are different.
  if (prevID != nextID) {
    aDifferenceFound = true;

    // Set the Subframe flag if not navigating the root docshell.
    aNextEntry->SetIsSubFrame(aParent != mRootBC);
    return InitiateLoad(aNextEntry, aParent, aLoadType, aLoadResults);
  }

  // The entries are the same, so compare any child frames
  int32_t pcnt = aPrevEntry->GetChildCount();
  int32_t ncnt = aNextEntry->GetChildCount();

  // Create an array for child browsing contexts.
  nsTArray<RefPtr<BrowsingContext>> browsingContexts;
  aParent->GetChildren(browsingContexts);

  // Search for something to load next.
  for (int32_t i = 0; i < ncnt; ++i) {
    // First get an entry which may cause a new page to be loaded.
    nsCOMPtr<nsISHEntry> nChild;
    aNextEntry->GetChildAt(i, getter_AddRefs(nChild));
    if (!nChild) {
      continue;
    }
    nsID docshellID;
    nChild->GetDocshellID(docshellID);

    // Then find the associated docshell.
    RefPtr<BrowsingContext> bcChild;
    for (const RefPtr<BrowsingContext>& bc : browsingContexts) {
      if (bc->GetHistoryID() == docshellID) {
        bcChild = bc;
        break;
      }
    }
    if (!bcChild) {
      continue;
    }

    // Then look at the previous entries to see if there was
    // an entry for the docshell.
    nsCOMPtr<nsISHEntry> pChild;
    for (int32_t k = 0; k < pcnt; ++k) {
      nsCOMPtr<nsISHEntry> child;
      aPrevEntry->GetChildAt(k, getter_AddRefs(child));
      if (child) {
        nsID dID;
        child->GetDocshellID(dID);
        if (dID == docshellID) {
          pChild = child;
          break;
        }
      }
    }

    // Finally recursively call this method.
    // This will either load a new page to shell or some subshell or
    // do nothing.
    LoadDifferingEntries(pChild, nChild, bcChild, aLoadType, aDifferenceFound,
                         aLoadResults);
  }
  return result;
}

nsresult nsSHistory::InitiateLoad(nsISHEntry* aFrameEntry,
                                  BrowsingContext* aFrameBC, long aLoadType,
                                  nsTArray<LoadEntryResult>& aLoadResults) {
  NS_ENSURE_STATE(aFrameBC && aFrameEntry);

  LoadEntryResult* loadResult = aLoadResults.AppendElement();
  loadResult->mBrowsingContext = aFrameBC;

  nsCOMPtr<nsIURI> newURI = aFrameEntry->GetURI();
  RefPtr<nsDocShellLoadState> loadState = new nsDocShellLoadState(newURI);

  /* Set the loadType in the SHEntry too to  what was passed on.
   * This will be passed on to child subframes later in nsDocShell,
   * so that proper loadType is maintained through out a frameset
   */
  aFrameEntry->SetLoadType(aLoadType);

  loadState->SetLoadType(aLoadType);
  loadState->SetSHEntry(aFrameEntry);

  nsCOMPtr<nsIURI> originalURI = aFrameEntry->GetOriginalURI();
  loadState->SetOriginalURI(originalURI);

  loadState->SetLoadReplace(aFrameEntry->GetLoadReplace());

  loadState->SetLoadFlags(nsIWebNavigation::LOAD_FLAGS_NONE);
  nsCOMPtr<nsIPrincipal> triggeringPrincipal =
      aFrameEntry->GetTriggeringPrincipal();
  loadState->SetTriggeringPrincipal(triggeringPrincipal);
  loadState->SetFirstParty(false);
  nsCOMPtr<nsIContentSecurityPolicy> csp = aFrameEntry->GetCsp();
  loadState->SetCsp(csp);

  loadResult->mLoadState = std::move(loadState);

  return NS_OK;
}

NS_IMETHODIMP
nsSHistory::CreateEntry(nsISHEntry** aEntry) {
  nsCOMPtr<nsISHEntry> entry = new nsSHEntry(this);
  entry.forget(aEntry);
  return NS_OK;
}
