/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsSHistory.h"
#include <algorithm>

// Helper Classes
#include "mozilla/Preferences.h"
#include "mozilla/StaticPtr.h"

// Interfaces Needed
#include "nsILayoutHistoryState.h"
#include "nsIDocShell.h"
#include "nsIDocShellLoadInfo.h"
#include "nsISHContainer.h"
#include "nsIDocShellTreeItem.h"
#include "nsIURI.h"
#include "nsIContentViewer.h"
#include "nsIObserverService.h"
#include "prclist.h"
#include "mozilla/Services.h"
#include "nsTArray.h"
#include "nsCOMArray.h"
#include "nsDocShell.h"
#include "mozilla/Attributes.h"
#include "nsISHEntry.h"
#include "nsISHTransaction.h"
#include "nsISHistoryListener.h"
#include "nsComponentManagerUtils.h"

// For calculating max history entries and max cachable contentviewers
#include "prsystem.h"
#include "mozilla/MathAlgorithms.h"

using namespace mozilla;

#define PREF_SHISTORY_SIZE "browser.sessionhistory.max_entries"
#define PREF_SHISTORY_MAX_TOTAL_VIEWERS "browser.sessionhistory.max_total_viewers"

static const char* kObservedPrefs[] = {
  PREF_SHISTORY_SIZE,
  PREF_SHISTORY_MAX_TOTAL_VIEWERS,
  nullptr
};

static int32_t gHistoryMaxSize = 50;
// Max viewers allowed per SHistory objects
static const int32_t gHistoryMaxViewers = 3;
// List of all SHistory objects, used for content viewer cache eviction
static PRCList gSHistoryList;
// Max viewers allowed total, across all SHistory objects - negative default
// means we will calculate how many viewers to cache based on total memory
int32_t nsSHistory::sHistoryMaxTotalViewers = -1;

// A counter that is used to be able to know the order in which
// entries were touched, so that we can evict older entries first.
static uint32_t gTouchCounter = 0;

static LazyLogModule gSHistoryLog("nsSHistory");

#define LOG(format) MOZ_LOG(gSHistoryLog, mozilla::LogLevel::Debug, format)

// This macro makes it easier to print a log message which includes a URI's
// spec.  Example use:
//
//  nsIURI *uri = [...];
//  LOG_SPEC(("The URI is %s.", _spec), uri);
//
#define LOG_SPEC(format, uri)                              \
  PR_BEGIN_MACRO                                           \
    if (MOZ_LOG_TEST(gSHistoryLog, LogLevel::Debug)) {     \
      nsAutoCString _specStr(NS_LITERAL_CSTRING("(null)"));\
      if (uri) {                                           \
        _specStr = uri->GetSpecOrDefault();                \
      }                                                    \
      const char* _spec = _specStr.get();                  \
      LOG(format);                                         \
    }                                                      \
  PR_END_MACRO

// This macro makes it easy to log a message including an SHEntry's URI.
// For example:
//
//  nsCOMPtr<nsISHEntry> shentry = [...];
//  LOG_SHENTRY_SPEC(("shentry %p has uri %s.", shentry.get(), _spec), shentry);
//
#define LOG_SHENTRY_SPEC(format, shentry)                  \
  PR_BEGIN_MACRO                                           \
    if (MOZ_LOG_TEST(gSHistoryLog, LogLevel::Debug)) {     \
      nsCOMPtr<nsIURI> uri;                                \
      shentry->GetURI(getter_AddRefs(uri));                \
      LOG_SPEC(format, uri);                               \
    }                                                      \
  PR_END_MACRO

// Iterates over all registered session history listeners.
#define ITERATE_LISTENERS(body)                            \
  PR_BEGIN_MACRO                                           \
  {                                                        \
    nsAutoTObserverArray<nsWeakPtr, 2>::EndLimitedIterator \
      iter(mListeners);                                    \
    while (iter.HasMore()) {                               \
      nsCOMPtr<nsISHistoryListener> listener =             \
        do_QueryReferent(iter.GetNext());                  \
      if (listener) {                                      \
        body                                               \
      }                                                    \
    }                                                      \
  }                                                        \
  PR_END_MACRO

// Calls a given method on all registered session history listeners.
#define NOTIFY_LISTENERS(method, args)                     \
  ITERATE_LISTENERS(                                       \
    listener->method args;                                 \
  );

// Calls a given method on all registered session history listeners.
// Listeners may return 'false' to cancel an action so make sure that we
// set the return value to 'false' if one of the listeners wants to cancel.
#define NOTIFY_LISTENERS_CANCELABLE(method, retval, args)  \
  PR_BEGIN_MACRO                                           \
  {                                                        \
    bool canceled = false;                                 \
    retval = true;                                         \
    ITERATE_LISTENERS(                                     \
      listener->method args;                               \
      if (!retval) {                                       \
        canceled = true;                                   \
      }                                                    \
    );                                                     \
    if (canceled) {                                        \
      retval = false;                                      \
    }                                                      \
  }                                                        \
  PR_END_MACRO

enum HistCmd
{
  HIST_CMD_BACK,
  HIST_CMD_FORWARD,
  HIST_CMD_GOTOINDEX,
  HIST_CMD_RELOAD
};

class nsSHistoryObserver final : public nsIObserver
{
public:
  NS_DECL_ISUPPORTS
  NS_DECL_NSIOBSERVER

  nsSHistoryObserver() {}

protected:
  ~nsSHistoryObserver() {}
};

StaticRefPtr<nsSHistoryObserver> gObserver;

NS_IMPL_ISUPPORTS(nsSHistoryObserver, nsIObserver)

NS_IMETHODIMP
nsSHistoryObserver::Observe(nsISupports* aSubject, const char* aTopic,
                            const char16_t* aData)
{
  if (!strcmp(aTopic, NS_PREFBRANCH_PREFCHANGE_TOPIC_ID)) {
    nsSHistory::UpdatePrefs();
    nsSHistory::GloballyEvictContentViewers();
  } else if (!strcmp(aTopic, "cacheservice:empty-cache") ||
             !strcmp(aTopic, "memory-pressure")) {
    nsSHistory::GloballyEvictAllContentViewers();
  }

  return NS_OK;
}

namespace {

already_AddRefed<nsIContentViewer>
GetContentViewerForTransaction(nsISHTransaction* aTrans)
{
  nsCOMPtr<nsISHEntry> entry;
  aTrans->GetSHEntry(getter_AddRefs(entry));
  if (!entry) {
    return nullptr;
  }

  nsCOMPtr<nsISHEntry> ownerEntry;
  nsCOMPtr<nsIContentViewer> viewer;
  entry->GetAnyContentViewer(getter_AddRefs(ownerEntry),
                             getter_AddRefs(viewer));
  return viewer.forget();
}

void
EvictContentViewerForTransaction(nsISHTransaction* aTrans)
{
  nsCOMPtr<nsISHEntry> entry;
  aTrans->GetSHEntry(getter_AddRefs(entry));
  nsCOMPtr<nsIContentViewer> viewer;
  nsCOMPtr<nsISHEntry> ownerEntry;
  entry->GetAnyContentViewer(getter_AddRefs(ownerEntry),
                             getter_AddRefs(viewer));
  if (viewer) {
    NS_ASSERTION(ownerEntry, "Content viewer exists but its SHEntry is null");

    LOG_SHENTRY_SPEC(("Evicting content viewer 0x%p for "
                      "owning SHEntry 0x%p at %s.",
                      viewer.get(), ownerEntry.get(), _spec),
                     ownerEntry);

    // Drop the presentation state before destroying the viewer, so that
    // document teardown is able to correctly persist the state.
    ownerEntry->SetContentViewer(nullptr);
    ownerEntry->SyncPresentationState();
    viewer->Destroy();
  }
}

} // namespace

nsSHistory::nsSHistory()
  : mIndex(-1)
  , mLength(0)
  , mRequestedIndex(-1)
  , mIsPartial(false)
  , mGlobalIndexOffset(0)
  , mEntriesInFollowingPartialHistories(0)
  , mRootDocShell(nullptr)
{
  // Add this new SHistory object to the list
  PR_APPEND_LINK(this, &gSHistoryList);
}

nsSHistory::~nsSHistory()
{
  // Remove this SHistory object from the list
  PR_REMOVE_LINK(this);
}

NS_IMPL_ADDREF(nsSHistory)
NS_IMPL_RELEASE(nsSHistory)

NS_INTERFACE_MAP_BEGIN(nsSHistory)
  NS_INTERFACE_MAP_ENTRY_AMBIGUOUS(nsISupports, nsISHistory)
  NS_INTERFACE_MAP_ENTRY(nsISHistory)
  NS_INTERFACE_MAP_ENTRY(nsIWebNavigation)
  NS_INTERFACE_MAP_ENTRY(nsISHistoryInternal)
NS_INTERFACE_MAP_END

// static
uint32_t
nsSHistory::CalcMaxTotalViewers()
{
  // Calculate an estimate of how many ContentViewers we should cache based
  // on RAM.  This assumes that the average ContentViewer is 4MB (conservative)
  // and caps the max at 8 ContentViewers
  //
  // TODO: Should we split the cache memory betw. ContentViewer caching and
  // nsCacheService?
  //
  // RAM      ContentViewers
  // -----------------------
  // 32   Mb       0
  // 64   Mb       1
  // 128  Mb       2
  // 256  Mb       3
  // 512  Mb       5
  // 1024 Mb       8
  // 2048 Mb       8
  // 4096 Mb       8
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
  double x = std::log(kBytesD) / std::log(2.0) - 14;
  if (x > 0) {
    viewers = (uint32_t)(x * x - x + 2.001); // add .001 for rounding
    viewers /= 4;
  }

  // Cap it off at 8 max
  if (viewers > 8) {
    viewers = 8;
  }
  return viewers;
}

// static
void
nsSHistory::UpdatePrefs()
{
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
nsresult
nsSHistory::Startup()
{
  UpdatePrefs();

  // The goal of this is to unbreak users who have inadvertently set their
  // session history size to less than the default value.
  int32_t defaultHistoryMaxSize =
    Preferences::GetDefaultInt(PREF_SHISTORY_SIZE, 50);
  if (gHistoryMaxSize < defaultHistoryMaxSize) {
    gHistoryMaxSize = defaultHistoryMaxSize;
  }

  // Allow the user to override the max total number of cached viewers,
  // but keep the per SHistory cached viewer limit constant
  if (!gObserver) {
    gObserver = new nsSHistoryObserver();
    Preferences::AddStrongObservers(gObserver, kObservedPrefs);

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

  // Initialize the global list of all SHistory objects
  PR_INIT_CLIST(&gSHistoryList);
  return NS_OK;
}

// static
void
nsSHistory::Shutdown()
{
  if (gObserver) {
    Preferences::RemoveObservers(gObserver, kObservedPrefs);
    nsCOMPtr<nsIObserverService> obsSvc =
      mozilla::services::GetObserverService();
    if (obsSvc) {
      obsSvc->RemoveObserver(gObserver, "cacheservice:empty-cache");
      obsSvc->RemoveObserver(gObserver, "memory-pressure");
    }
    gObserver = nullptr;
  }
}

/* Add an entry to the History list at mIndex and
 * increment the index to point to the new entry
 */
NS_IMETHODIMP
nsSHistory::AddEntry(nsISHEntry* aSHEntry, bool aPersist)
{
  NS_ENSURE_ARG(aSHEntry);

  nsCOMPtr<nsISHTransaction> currentTxn;

  if (mListRoot) {
    GetTransactionAtIndex(mIndex, getter_AddRefs(currentTxn));
  }

  bool currentPersist = true;
  if (currentTxn) {
    currentTxn->GetPersist(&currentPersist);
  }

  int32_t currentIndex = mIndex;

  if (!currentPersist) {
    NOTIFY_LISTENERS(OnHistoryReplaceEntry, (currentIndex));
    NS_ENSURE_SUCCESS(currentTxn->SetSHEntry(aSHEntry), NS_ERROR_FAILURE);
    currentTxn->SetPersist(aPersist);
    return NS_OK;
  }

  nsCOMPtr<nsISHTransaction> txn(
    do_CreateInstance(NS_SHTRANSACTION_CONTRACTID));
  NS_ENSURE_TRUE(txn, NS_ERROR_FAILURE);

  nsCOMPtr<nsIURI> uri;
  aSHEntry->GetURI(getter_AddRefs(uri));
  NOTIFY_LISTENERS(OnHistoryNewEntry, (uri, currentIndex));

  // If a listener has changed mIndex, we need to get currentTxn again,
  // otherwise we'll be left at an inconsistent state (see bug 320742)
  if (currentIndex != mIndex) {
    GetTransactionAtIndex(mIndex, getter_AddRefs(currentTxn));
  }

  // Set the ShEntry and parent for the transaction. setting the
  // parent will properly set the parent child relationship
  txn->SetPersist(aPersist);
  NS_ENSURE_SUCCESS(txn->Create(aSHEntry, currentTxn), NS_ERROR_FAILURE);

  // A little tricky math here...  Basically when adding an object regardless of
  // what the length was before, it should always be set back to the current and
  // lop off the forward.
  mLength = (++mIndex + 1);
  NOTIFY_LISTENERS(OnLengthChange, (mLength));

  // Much like how mLength works above, when changing our entries, all following
  // partial histories should be purged, so we just reset the number to zero.
  mEntriesInFollowingPartialHistories = 0;

  // If this is the very first transaction, initialize the list
  if (!mListRoot) {
    mListRoot = txn;
  }

  // Purge History list if it is too long
  if (gHistoryMaxSize >= 0 && mLength > gHistoryMaxSize) {
    PurgeHistory(mLength - gHistoryMaxSize);
  }

  RemoveDynEntries(mIndex - 1, mIndex);
  return NS_OK;
}

NS_IMETHODIMP
nsSHistory::GetIsPartial(bool* aResult)
{
  NS_ENSURE_ARG_POINTER(aResult);
  *aResult = mIsPartial;
  return NS_OK;
}

/* Get size of the history list */
NS_IMETHODIMP
nsSHistory::GetCount(int32_t* aResult)
{
  NS_ENSURE_ARG_POINTER(aResult);
  *aResult = mLength;
  return NS_OK;
}

NS_IMETHODIMP
nsSHistory::GetGlobalCount(int32_t* aResult)
{
  NS_ENSURE_ARG_POINTER(aResult);
  *aResult = mGlobalIndexOffset + mLength + mEntriesInFollowingPartialHistories;
  return NS_OK;
}

NS_IMETHODIMP
nsSHistory::GetGlobalIndexOffset(int32_t* aResult)
{
  NS_ENSURE_ARG_POINTER(aResult);
  *aResult = mGlobalIndexOffset;
  return NS_OK;
}

NS_IMETHODIMP
nsSHistory::OnPartialSessionHistoryActive(int32_t aGlobalLength, int32_t aTargetIndex)
{
  NS_ENSURE_TRUE(mIsPartial, NS_ERROR_UNEXPECTED);

  int32_t extraLength = aGlobalLength - mLength - mGlobalIndexOffset;
  NS_ENSURE_TRUE(extraLength >= 0, NS_ERROR_UNEXPECTED);

  if (extraLength != mEntriesInFollowingPartialHistories) {
    mEntriesInFollowingPartialHistories = extraLength;
  }

  if (mIndex == aTargetIndex) {
    // TODO When we finish OnPartialSessionHistoryDeactive, we'll need to active
    // the suspended document here.

    // Fire location change to update canGoBack / canGoForward.
    NS_DispatchToCurrentThread(NewRunnableMethod(static_cast<nsDocShell*>(mRootDocShell),
                                                 &nsDocShell::FireDummyOnLocationChange));
    return NS_OK;
  }

  return LoadEntry(aTargetIndex, nsIDocShellLoadInfo::loadHistory,
                   HIST_CMD_GOTOINDEX);
}

NS_IMETHODIMP
nsSHistory::OnPartialSessionHistoryDeactive()
{
  NS_ENSURE_TRUE(mIsPartial, NS_ERROR_UNEXPECTED);

  // TODO We need to suspend current document first. Much like what happens when
  // loading a new page. Move the ownership of the document to nsISHEntry or so.
  return NS_OK;
}

/* Get index of the history list */
NS_IMETHODIMP
nsSHistory::GetIndex(int32_t* aResult)
{
  NS_PRECONDITION(aResult, "null out param?");
  *aResult = mIndex;
  return NS_OK;
}

/* Get the requestedIndex */
NS_IMETHODIMP
nsSHistory::GetRequestedIndex(int32_t* aResult)
{
  NS_PRECONDITION(aResult, "null out param?");
  *aResult = mRequestedIndex;
  return NS_OK;
}

/* Get the entry at a given index */
NS_IMETHODIMP
nsSHistory::GetEntryAtIndex(int32_t aIndex, bool aModifyIndex,
                            nsISHEntry** aResult)
{
  nsresult rv;
  nsCOMPtr<nsISHTransaction> txn;

  /* GetTransactionAtIndex ensures aResult is valid and validates aIndex */
  rv = GetTransactionAtIndex(aIndex, getter_AddRefs(txn));
  if (NS_SUCCEEDED(rv) && txn) {
    // Get the Entry from the transaction
    rv = txn->GetSHEntry(aResult);
    if (NS_SUCCEEDED(rv) && (*aResult)) {
      // Set mIndex to the requested index, if asked to do so..
      if (aModifyIndex) {
        mIndex = aIndex;
      }
    }
  }
  return rv;
}

/* Get the transaction at a given index */
NS_IMETHODIMP
nsSHistory::GetTransactionAtIndex(int32_t aIndex, nsISHTransaction** aResult)
{
  nsresult rv;
  NS_ENSURE_ARG_POINTER(aResult);

  if (mLength <= 0 || aIndex < 0 || aIndex >= mLength) {
    return NS_ERROR_FAILURE;
  }

  if (!mListRoot) {
    return NS_ERROR_FAILURE;
  }

  if (aIndex == 0) {
    *aResult = mListRoot;
    NS_ADDREF(*aResult);
    return NS_OK;
  }

  int32_t cnt = 0;
  nsCOMPtr<nsISHTransaction> tempPtr;
  rv = GetRootTransaction(getter_AddRefs(tempPtr));
  if (NS_FAILED(rv) || !tempPtr) {
    return NS_ERROR_FAILURE;
  }

  while (true) {
    nsCOMPtr<nsISHTransaction> ptr;
    rv = tempPtr->GetNext(getter_AddRefs(ptr));
    if (NS_SUCCEEDED(rv) && ptr) {
      cnt++;
      if (cnt == aIndex) {
        ptr.forget(aResult);
        break;
      } else {
        tempPtr = ptr;
        continue;
      }
    } else {
      return NS_ERROR_FAILURE;
    }
  }

  return NS_OK;
}

/* Get the index of a given entry */
NS_IMETHODIMP
nsSHistory::GetIndexOfEntry(nsISHEntry* aSHEntry, int32_t* aResult)
{
  NS_ENSURE_ARG(aSHEntry);
  NS_ENSURE_ARG_POINTER(aResult);
  *aResult = -1;

  if (mLength <= 0) {
    return NS_ERROR_FAILURE;
  }

  nsCOMPtr<nsISHTransaction> currentTxn;
  int32_t cnt = 0;

  nsresult rv = GetRootTransaction(getter_AddRefs(currentTxn));
  if (NS_FAILED(rv) || !currentTxn) {
    return NS_ERROR_FAILURE;
  }

  while (true) {
    nsCOMPtr<nsISHEntry> entry;
    rv = currentTxn->GetSHEntry(getter_AddRefs(entry));
    if (NS_FAILED(rv) || !entry) {
      return NS_ERROR_FAILURE;
    }

    if (aSHEntry == entry) {
      *aResult = cnt;
      break;
    }

    rv = currentTxn->GetNext(getter_AddRefs(currentTxn));
    if (NS_FAILED(rv) || !currentTxn) {
      return NS_ERROR_FAILURE;
    }

    cnt++;
  }

  return NS_OK;
}

#ifdef DEBUG
nsresult
nsSHistory::PrintHistory()
{
  nsCOMPtr<nsISHTransaction> txn;
  int32_t index = 0;
  nsresult rv;

  if (!mListRoot) {
    return NS_ERROR_FAILURE;
  }

  txn = mListRoot;

  while (1) {
    if (!txn) {
      break;
    }
    nsCOMPtr<nsISHEntry> entry;
    rv = txn->GetSHEntry(getter_AddRefs(entry));
    if (NS_FAILED(rv) && !entry) {
      return NS_ERROR_FAILURE;
    }

    nsCOMPtr<nsILayoutHistoryState> layoutHistoryState;
    nsCOMPtr<nsIURI> uri;
    nsXPIDLString title;

    entry->GetLayoutHistoryState(getter_AddRefs(layoutHistoryState));
    entry->GetURI(getter_AddRefs(uri));
    entry->GetTitle(getter_Copies(title));

#if 0
    nsAutoCString url;
    if (uri) {
      uri->GetSpec(url);
    }

    printf("**** SH Transaction #%d, Entry = %x\n", index, entry.get());
    printf("\t\t URL = %s\n", url.get());

    printf("\t\t Title = %s\n", NS_LossyConvertUTF16toASCII(title).get());
    printf("\t\t layout History Data = %x\n", layoutHistoryState.get());
#endif

    nsCOMPtr<nsISHTransaction> next;
    rv = txn->GetNext(getter_AddRefs(next));
    if (NS_SUCCEEDED(rv) && next) {
      txn = next;
      index++;
      continue;
    } else {
      break;
    }
  }

  return NS_OK;
}
#endif

NS_IMETHODIMP
nsSHistory::GetRootTransaction(nsISHTransaction** aResult)
{
  NS_ENSURE_ARG_POINTER(aResult);
  *aResult = mListRoot;
  NS_IF_ADDREF(*aResult);
  return NS_OK;
}

/* Get the max size of the history list */
NS_IMETHODIMP
nsSHistory::GetMaxLength(int32_t* aResult)
{
  NS_ENSURE_ARG_POINTER(aResult);
  *aResult = gHistoryMaxSize;
  return NS_OK;
}

/* Set the max size of the history list */
NS_IMETHODIMP
nsSHistory::SetMaxLength(int32_t aMaxSize)
{
  if (aMaxSize < 0) {
    return NS_ERROR_ILLEGAL_VALUE;
  }

  gHistoryMaxSize = aMaxSize;
  if (mLength > aMaxSize) {
    PurgeHistory(mLength - aMaxSize);
  }
  return NS_OK;
}

NS_IMETHODIMP
nsSHistory::PurgeHistory(int32_t aEntries)
{
  if (mLength <= 0 || aEntries <= 0) {
    return NS_ERROR_FAILURE;
  }

  aEntries = std::min(aEntries, mLength);

  bool purgeHistory = true;
  NOTIFY_LISTENERS_CANCELABLE(OnHistoryPurge, purgeHistory,
                              (aEntries, &purgeHistory));

  if (!purgeHistory) {
    // Listener asked us not to purge
    return NS_SUCCESS_LOSS_OF_INSIGNIFICANT_DATA;
  }

  int32_t cnt = 0;
  while (cnt < aEntries) {
    nsCOMPtr<nsISHTransaction> nextTxn;
    if (mListRoot) {
      mListRoot->GetNext(getter_AddRefs(nextTxn));
      mListRoot->SetNext(nullptr);
    }
    mListRoot = nextTxn;
    if (mListRoot) {
      mListRoot->SetPrev(nullptr);
    }
    cnt++;
  }
  mLength -= cnt;
  mIndex -= cnt;
  NOTIFY_LISTENERS(OnLengthChange, (mLength));

  // All following partial histories will be deleted in this case.
  mEntriesInFollowingPartialHistories = 0;

  // Now if we were not at the end of the history, mIndex could have
  // become far too negative.  If so, just set it to -1.
  if (mIndex < -1) {
    mIndex = -1;
  }

  if (mRootDocShell) {
    mRootDocShell->HistoryPurged(cnt);
  }

  return NS_OK;
}

NS_IMETHODIMP
nsSHistory::AddSHistoryListener(nsISHistoryListener* aListener)
{
  NS_ENSURE_ARG_POINTER(aListener);

  // Check if the listener supports Weak Reference. This is a must.
  // This listener functionality is used by embedders and we want to
  // have the right ownership with who ever listens to SHistory
  nsWeakPtr listener = do_GetWeakReference(aListener);
  if (!listener) {
    return NS_ERROR_FAILURE;
  }

  return mListeners.AppendElementUnlessExists(listener) ?
    NS_OK : NS_ERROR_OUT_OF_MEMORY;
}

NS_IMETHODIMP
nsSHistory::RemoveSHistoryListener(nsISHistoryListener* aListener)
{
  // Make sure the listener that wants to be removed is the
  // one we have in store.
  nsWeakPtr listener = do_GetWeakReference(aListener);
  mListeners.RemoveElement(listener);
  return NS_OK;
}

NS_IMETHODIMP
nsSHistory::SetPartialSHistoryListener(nsIPartialSHistoryListener* aListener)
{
  mPartialHistoryListener = do_GetWeakReference(aListener);
  return NS_OK;
}

/* Replace an entry in the History list at a particular index.
 * Do not update index or count.
 */
NS_IMETHODIMP
nsSHistory::ReplaceEntry(int32_t aIndex, nsISHEntry* aReplaceEntry)
{
  NS_ENSURE_ARG(aReplaceEntry);
  nsresult rv;
  nsCOMPtr<nsISHTransaction> currentTxn;

  if (!mListRoot) {
    // Session History is not initialised.
    return NS_ERROR_FAILURE;
  }

  rv = GetTransactionAtIndex(aIndex, getter_AddRefs(currentTxn));

  if (currentTxn) {
    NOTIFY_LISTENERS(OnHistoryReplaceEntry, (aIndex));

    // Set the replacement entry in the transaction
    rv = currentTxn->SetSHEntry(aReplaceEntry);
    rv = currentTxn->SetPersist(true);
  }
  return rv;
}

NS_IMETHODIMP
nsSHistory::NotifyOnHistoryReload(nsIURI* aReloadURI, uint32_t aReloadFlags,
                                  bool* aCanReload)
{
  NOTIFY_LISTENERS_CANCELABLE(OnHistoryReload, *aCanReload,
                              (aReloadURI, aReloadFlags, aCanReload));
  return NS_OK;
}

NS_IMETHODIMP
nsSHistory::EvictOutOfRangeContentViewers(int32_t aIndex)
{
  // Check our per SHistory object limit in the currently navigated SHistory
  EvictOutOfRangeWindowContentViewers(aIndex);
  // Check our total limit across all SHistory objects
  GloballyEvictContentViewers();
  return NS_OK;
}

NS_IMETHODIMP
nsSHistory::EvictAllContentViewers()
{
  // XXXbz we don't actually do a good job of evicting things as we should, so
  // we might have viewers quite far from mIndex.  So just evict everything.
  nsCOMPtr<nsISHTransaction> trans = mListRoot;
  while (trans) {
    EvictContentViewerForTransaction(trans);

    nsCOMPtr<nsISHTransaction> temp = trans;
    temp->GetNext(getter_AddRefs(trans));
  }

  return NS_OK;
}

NS_IMETHODIMP
nsSHistory::GetCanGoBack(bool* aCanGoBack)
{
  NS_ENSURE_ARG_POINTER(aCanGoBack);

  if (mGlobalIndexOffset) {
    *aCanGoBack = true;
    return NS_OK;
  }

  int32_t index = -1;
  NS_ENSURE_SUCCESS(GetIndex(&index), NS_ERROR_FAILURE);
  if (index > 0) {
    *aCanGoBack = true;
    return NS_OK;
  }

  *aCanGoBack = false;
  return NS_OK;
}

NS_IMETHODIMP
nsSHistory::GetCanGoForward(bool* aCanGoForward)
{
  NS_ENSURE_ARG_POINTER(aCanGoForward);

  if (mEntriesInFollowingPartialHistories) {
    *aCanGoForward = true;
    return NS_OK;
  }

  int32_t index = -1;
  int32_t count = -1;
  NS_ENSURE_SUCCESS(GetIndex(&index), NS_ERROR_FAILURE);
  NS_ENSURE_SUCCESS(GetCount(&count), NS_ERROR_FAILURE);
  if (index >= 0 && index < (count - 1)) {
    *aCanGoForward = true;
    return NS_OK;
  }

  *aCanGoForward = false;
  return NS_OK;
}

NS_IMETHODIMP
nsSHistory::GoBack()
{
  bool canGoBack = false;

  GetCanGoBack(&canGoBack);
  if (!canGoBack) {
    return NS_ERROR_UNEXPECTED;
  }
  return LoadEntry(mIndex - 1, nsIDocShellLoadInfo::loadHistory, HIST_CMD_BACK);
}

NS_IMETHODIMP
nsSHistory::GoForward()
{
  bool canGoForward = false;

  GetCanGoForward(&canGoForward);
  if (!canGoForward) {
    return NS_ERROR_UNEXPECTED;
  }
  return LoadEntry(mIndex + 1, nsIDocShellLoadInfo::loadHistory,
                   HIST_CMD_FORWARD);
}

NS_IMETHODIMP
nsSHistory::Reload(uint32_t aReloadFlags)
{
  nsDocShellInfoLoadType loadType;
  if (aReloadFlags & nsIWebNavigation::LOAD_FLAGS_BYPASS_PROXY &&
      aReloadFlags & nsIWebNavigation::LOAD_FLAGS_BYPASS_CACHE) {
    loadType = nsIDocShellLoadInfo::loadReloadBypassProxyAndCache;
  } else if (aReloadFlags & nsIWebNavigation::LOAD_FLAGS_BYPASS_PROXY) {
    loadType = nsIDocShellLoadInfo::loadReloadBypassProxy;
  } else if (aReloadFlags & nsIWebNavigation::LOAD_FLAGS_BYPASS_CACHE) {
    loadType = nsIDocShellLoadInfo::loadReloadBypassCache;
  } else if (aReloadFlags & nsIWebNavigation::LOAD_FLAGS_CHARSET_CHANGE) {
    loadType = nsIDocShellLoadInfo::loadReloadCharsetChange;
  } else if (aReloadFlags & nsIWebNavigation::LOAD_FLAGS_ALLOW_MIXED_CONTENT) {
    loadType = nsIDocShellLoadInfo::loadReloadMixedContent;
  } else {
    loadType = nsIDocShellLoadInfo::loadReloadNormal;
  }

  // We are reloading. Send Reload notifications.
  // nsDocShellLoadFlagType is not public, where as nsIWebNavigation
  // is public. So send the reload notifications with the
  // nsIWebNavigation flags.
  bool canNavigate = true;
  nsCOMPtr<nsIURI> currentURI;
  GetCurrentURI(getter_AddRefs(currentURI));
  NOTIFY_LISTENERS_CANCELABLE(OnHistoryReload, canNavigate,
                              (currentURI, aReloadFlags, &canNavigate));
  if (!canNavigate) {
    return NS_OK;
  }

  return LoadEntry(mIndex, loadType, HIST_CMD_RELOAD);
}

NS_IMETHODIMP
nsSHistory::ReloadCurrentEntry()
{
  // Notify listeners
  bool canNavigate = true;
  nsCOMPtr<nsIURI> currentURI;
  GetCurrentURI(getter_AddRefs(currentURI));
  NOTIFY_LISTENERS_CANCELABLE(OnHistoryGotoIndex, canNavigate,
                              (mIndex, currentURI, &canNavigate));
  if (!canNavigate) {
    return NS_OK;
  }

  return LoadEntry(mIndex, nsIDocShellLoadInfo::loadHistory, HIST_CMD_RELOAD);
}

void
nsSHistory::EvictOutOfRangeWindowContentViewers(int32_t aIndex)
{
  // XXX rename method to EvictContentViewersExceptAroundIndex, or something.

  // We need to release all content viewers that are no longer in the range
  //
  //  aIndex - gHistoryMaxViewers to aIndex + gHistoryMaxViewers
  //
  // to ensure that this SHistory object isn't responsible for more than
  // gHistoryMaxViewers content viewers.  But our job is complicated by the
  // fact that two transactions which are related by either hash navigations or
  // history.pushState will have the same content viewer.
  //
  // To illustrate the issue, suppose gHistoryMaxViewers = 3 and we have four
  // linked transactions in our history.  Suppose we then add a new content
  // viewer and call into this function.  So the history looks like:
  //
  //   A A A A B
  //     +     *
  //
  // where the letters are content viewers and + and * denote the beginning and
  // end of the range aIndex +/- gHistoryMaxViewers.
  //
  // Although one copy of the content viewer A exists outside the range, we
  // don't want to evict A, because it has other copies in range!
  //
  // We therefore adjust our eviction strategy to read:
  //
  //   Evict each content viewer outside the range aIndex -/+
  //   gHistoryMaxViewers, unless that content viewer also appears within the
  //   range.
  //
  // (Note that it's entirely legal to have two copies of one content viewer
  // separated by a different content viewer -- call pushState twice, go back
  // once, and refresh -- so we can't rely on identical viewers only appearing
  // adjacent to one another.)

  if (aIndex < 0) {
    return;
  }
  NS_ENSURE_TRUE_VOID(aIndex < mLength);

  // Calculate the range that's safe from eviction.
  int32_t startSafeIndex = std::max(0, aIndex - gHistoryMaxViewers);
  int32_t endSafeIndex = std::min(mLength, aIndex + gHistoryMaxViewers);

  LOG(("EvictOutOfRangeWindowContentViewers(index=%d), "
       "mLength=%d. Safe range [%d, %d]",
       aIndex, mLength, startSafeIndex, endSafeIndex));

  // The content viewers in range aIndex -/+ gHistoryMaxViewers will not be
  // evicted.  Collect a set of them so we don't accidentally evict one of them
  // if it appears outside this range.
  nsCOMArray<nsIContentViewer> safeViewers;
  nsCOMPtr<nsISHTransaction> trans;
  GetTransactionAtIndex(startSafeIndex, getter_AddRefs(trans));
  for (int32_t i = startSafeIndex; trans && i <= endSafeIndex; i++) {
    nsCOMPtr<nsIContentViewer> viewer = GetContentViewerForTransaction(trans);
    safeViewers.AppendObject(viewer);
    nsCOMPtr<nsISHTransaction> temp = trans;
    temp->GetNext(getter_AddRefs(trans));
  }

  // Walk the SHistory list and evict any content viewers that aren't safe.
  GetTransactionAtIndex(0, getter_AddRefs(trans));
  while (trans) {
    nsCOMPtr<nsIContentViewer> viewer = GetContentViewerForTransaction(trans);
    if (safeViewers.IndexOf(viewer) == -1) {
      EvictContentViewerForTransaction(trans);
    }

    nsCOMPtr<nsISHTransaction> temp = trans;
    temp->GetNext(getter_AddRefs(trans));
  }
}

namespace {

class TransactionAndDistance
{
public:
  TransactionAndDistance(nsISHTransaction* aTrans, uint32_t aDist)
    : mTransaction(aTrans)
    , mLastTouched(0)
    , mDistance(aDist)
  {
    mViewer = GetContentViewerForTransaction(aTrans);
    NS_ASSERTION(mViewer, "Transaction should have a content viewer");

    nsCOMPtr<nsISHEntry> shentry;
    mTransaction->GetSHEntry(getter_AddRefs(shentry));

    nsCOMPtr<nsISHEntryInternal> shentryInternal = do_QueryInterface(shentry);
    if (shentryInternal) {
      shentryInternal->GetLastTouched(&mLastTouched);
    } else {
      NS_WARNING("Can't cast to nsISHEntryInternal?");
    }
  }

  bool operator<(const TransactionAndDistance& aOther) const
  {
    // Compare distances first, and fall back to last-accessed times.
    if (aOther.mDistance != this->mDistance) {
      return this->mDistance < aOther.mDistance;
    }

    return this->mLastTouched < aOther.mLastTouched;
  }

  bool operator==(const TransactionAndDistance& aOther) const
  {
    // This is a little silly; we need == so the default comaprator can be
    // instantiated, but this function is never actually called when we sort
    // the list of TransactionAndDistance objects.
    return aOther.mDistance == this->mDistance &&
           aOther.mLastTouched == this->mLastTouched;
  }

  nsCOMPtr<nsISHTransaction> mTransaction;
  nsCOMPtr<nsIContentViewer> mViewer;
  uint32_t mLastTouched;
  int32_t mDistance;
};

} // namespace

// static
void
nsSHistory::GloballyEvictContentViewers()
{
  // First, collect from each SHistory object the transactions which have a
  // cached content viewer.  Associate with each transaction its distance from
  // its SHistory's current index.

  nsTArray<TransactionAndDistance> transactions;

  PRCList* listEntry = PR_LIST_HEAD(&gSHistoryList);
  while (listEntry != &gSHistoryList) {
    nsSHistory* shist = static_cast<nsSHistory*>(listEntry);

    // Maintain a list of the transactions which have viewers and belong to
    // this particular shist object.  We'll add this list to the global list,
    // |transactions|, eventually.
    nsTArray<TransactionAndDistance> shTransactions;

    // Content viewers are likely to exist only within shist->mIndex -/+
    // gHistoryMaxViewers, so only search within that range.
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
    int32_t startIndex = std::max(0, shist->mIndex - gHistoryMaxViewers);
    int32_t endIndex = std::min(shist->mLength - 1,
                                shist->mIndex + gHistoryMaxViewers);
    nsCOMPtr<nsISHTransaction> trans;
    shist->GetTransactionAtIndex(startIndex, getter_AddRefs(trans));
    for (int32_t i = startIndex; trans && i <= endIndex; i++) {
      nsCOMPtr<nsIContentViewer> contentViewer =
        GetContentViewerForTransaction(trans);

      if (contentViewer) {
        // Because one content viewer might belong to multiple SHEntries, we
        // have to search through shTransactions to see if we already know
        // about this content viewer.  If we find the viewer, update its
        // distance from the SHistory's index and continue.
        bool found = false;
        for (uint32_t j = 0; j < shTransactions.Length(); j++) {
          TransactionAndDistance& container = shTransactions[j];
          if (container.mViewer == contentViewer) {
            container.mDistance = std::min(container.mDistance,
                                           DeprecatedAbs(i - shist->mIndex));
            found = true;
            break;
          }
        }

        // If we didn't find a TransactionAndDistance for this content viewer,
        // make a new one.
        if (!found) {
          TransactionAndDistance container(trans,
                                           DeprecatedAbs(i - shist->mIndex));
          shTransactions.AppendElement(container);
        }
      }

      nsCOMPtr<nsISHTransaction> temp = trans;
      temp->GetNext(getter_AddRefs(trans));
    }

    // We've found all the transactions belonging to shist which have viewers.
    // Add those transactions to our global list and move on.
    transactions.AppendElements(shTransactions);
    listEntry = PR_NEXT_LINK(shist);
  }

  // We now have collected all cached content viewers.  First check that we
  // have enough that we actually need to evict some.
  if ((int32_t)transactions.Length() <= sHistoryMaxTotalViewers) {
    return;
  }

  // If we need to evict, sort our list of transactions and evict the largest
  // ones.  (We could of course get better algorithmic complexity here by using
  // a heap or something more clever.  But sHistoryMaxTotalViewers isn't large,
  // so let's not worry about it.)
  transactions.Sort();

  for (int32_t i = transactions.Length() - 1; i >= sHistoryMaxTotalViewers;
       --i) {
    EvictContentViewerForTransaction(transactions[i].mTransaction);
  }
}

nsresult
nsSHistory::EvictExpiredContentViewerForEntry(nsIBFCacheEntry* aEntry)
{
  int32_t startIndex = std::max(0, mIndex - gHistoryMaxViewers);
  int32_t endIndex = std::min(mLength - 1, mIndex + gHistoryMaxViewers);
  nsCOMPtr<nsISHTransaction> trans;
  GetTransactionAtIndex(startIndex, getter_AddRefs(trans));

  int32_t i;
  for (i = startIndex; trans && i <= endIndex; ++i) {
    nsCOMPtr<nsISHEntry> entry;
    trans->GetSHEntry(getter_AddRefs(entry));

    // Does entry have the same BFCacheEntry as the argument to this method?
    if (entry->HasBFCacheEntry(aEntry)) {
      break;
    }

    nsCOMPtr<nsISHTransaction> temp = trans;
    temp->GetNext(getter_AddRefs(trans));
  }
  if (i > endIndex) {
    return NS_OK;
  }

  if (i == mIndex) {
    NS_WARNING("How did the current SHEntry expire?");
    return NS_OK;
  }

  EvictContentViewerForTransaction(trans);

  return NS_OK;
}

// Evicts all content viewers in all history objects.  This is very
// inefficient, because it requires a linear search through all SHistory
// objects for each viewer to be evicted.  However, this method is called
// infrequently -- only when the disk or memory cache is cleared.

// static
void
nsSHistory::GloballyEvictAllContentViewers()
{
  int32_t maxViewers = sHistoryMaxTotalViewers;
  sHistoryMaxTotalViewers = 0;
  GloballyEvictContentViewers();
  sHistoryMaxTotalViewers = maxViewers;
}

void
GetDynamicChildren(nsISHContainer* aContainer,
                   nsTArray<uint64_t>& aDocshellIDs,
                   bool aOnlyTopLevelDynamic)
{
  int32_t count = 0;
  aContainer->GetChildCount(&count);
  for (int32_t i = 0; i < count; ++i) {
    nsCOMPtr<nsISHEntry> child;
    aContainer->GetChildAt(i, getter_AddRefs(child));
    if (child) {
      bool dynAdded = false;
      child->IsDynamicallyAdded(&dynAdded);
      if (dynAdded) {
        uint64_t docshellID = 0;
        child->GetDocshellID(&docshellID);
        aDocshellIDs.AppendElement(docshellID);
      }
      if (!dynAdded || !aOnlyTopLevelDynamic) {
        nsCOMPtr<nsISHContainer> childAsContainer = do_QueryInterface(child);
        if (childAsContainer) {
          GetDynamicChildren(childAsContainer, aDocshellIDs,
                             aOnlyTopLevelDynamic);
        }
      }
    }
  }
}

bool
RemoveFromSessionHistoryContainer(nsISHContainer* aContainer,
                                  nsTArray<uint64_t>& aDocshellIDs)
{
  nsCOMPtr<nsISHEntry> root = do_QueryInterface(aContainer);
  NS_ENSURE_TRUE(root, false);

  bool didRemove = false;
  int32_t childCount = 0;
  aContainer->GetChildCount(&childCount);
  for (int32_t i = childCount - 1; i >= 0; --i) {
    nsCOMPtr<nsISHEntry> child;
    aContainer->GetChildAt(i, getter_AddRefs(child));
    if (child) {
      uint64_t docshelldID = 0;
      child->GetDocshellID(&docshelldID);
      if (aDocshellIDs.Contains(docshelldID)) {
        didRemove = true;
        aContainer->RemoveChild(child);
      } else {
        nsCOMPtr<nsISHContainer> container = do_QueryInterface(child);
        if (container) {
          bool childRemoved =
            RemoveFromSessionHistoryContainer(container, aDocshellIDs);
          if (childRemoved) {
            didRemove = true;
          }
        }
      }
    }
  }
  return didRemove;
}

bool
RemoveChildEntries(nsISHistory* aHistory, int32_t aIndex,
                   nsTArray<uint64_t>& aEntryIDs)
{
  nsCOMPtr<nsISHEntry> rootHE;
  aHistory->GetEntryAtIndex(aIndex, false, getter_AddRefs(rootHE));
  nsCOMPtr<nsISHContainer> root = do_QueryInterface(rootHE);
  return root ? RemoveFromSessionHistoryContainer(root, aEntryIDs) : false;
}

bool
IsSameTree(nsISHEntry* aEntry1, nsISHEntry* aEntry2)
{
  if (!aEntry1 && !aEntry2) {
    return true;
  }
  if ((!aEntry1 && aEntry2) || (aEntry1 && !aEntry2)) {
    return false;
  }
  uint32_t id1, id2;
  aEntry1->GetID(&id1);
  aEntry2->GetID(&id2);
  if (id1 != id2) {
    return false;
  }

  nsCOMPtr<nsISHContainer> container1 = do_QueryInterface(aEntry1);
  nsCOMPtr<nsISHContainer> container2 = do_QueryInterface(aEntry2);
  int32_t count1, count2;
  container1->GetChildCount(&count1);
  container2->GetChildCount(&count2);
  // We allow null entries in the end of the child list.
  int32_t count = std::max(count1, count2);
  for (int32_t i = 0; i < count; ++i) {
    nsCOMPtr<nsISHEntry> child1, child2;
    container1->GetChildAt(i, getter_AddRefs(child1));
    container2->GetChildAt(i, getter_AddRefs(child2));
    if (!IsSameTree(child1, child2)) {
      return false;
    }
  }

  return true;
}

bool
nsSHistory::RemoveDuplicate(int32_t aIndex, bool aKeepNext)
{
  NS_ASSERTION(aIndex >= 0, "aIndex must be >= 0!");
  NS_ASSERTION(aIndex != 0 || aKeepNext,
               "If we're removing index 0 we must be keeping the next");
  NS_ASSERTION(aIndex != mIndex, "Shouldn't remove mIndex!");
  int32_t compareIndex = aKeepNext ? aIndex + 1 : aIndex - 1;
  nsCOMPtr<nsISHEntry> root1, root2;
  GetEntryAtIndex(aIndex, false, getter_AddRefs(root1));
  GetEntryAtIndex(compareIndex, false, getter_AddRefs(root2));
  if (IsSameTree(root1, root2)) {
    nsCOMPtr<nsISHTransaction> txToRemove, txToKeep, txNext, txPrev;
    GetTransactionAtIndex(aIndex, getter_AddRefs(txToRemove));
    GetTransactionAtIndex(compareIndex, getter_AddRefs(txToKeep));
    if (!txToRemove) {
      return false;
    }
    NS_ENSURE_TRUE(txToKeep, false);
    txToRemove->GetNext(getter_AddRefs(txNext));
    txToRemove->GetPrev(getter_AddRefs(txPrev));
    txToRemove->SetNext(nullptr);
    txToRemove->SetPrev(nullptr);
    if (aKeepNext) {
      if (txPrev) {
        txPrev->SetNext(txToKeep);
      } else {
        txToKeep->SetPrev(nullptr);
      }
    } else {
      txToKeep->SetNext(txNext);
    }

    if (aIndex == 0 && aKeepNext) {
      NS_ASSERTION(txToRemove == mListRoot,
                   "Transaction at index 0 should be mListRoot!");
      // We're removing the very first session history transaction!
      mListRoot = txToKeep;
    }
    if (mRootDocShell) {
      static_cast<nsDocShell*>(mRootDocShell)->HistoryTransactionRemoved(aIndex);
    }

    // Adjust our indices to reflect the removed transaction
    if (mIndex > aIndex) {
      mIndex = mIndex - 1;
    }

    // NB: If the transaction we are removing is the transaction currently
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
    --mLength;
    mEntriesInFollowingPartialHistories = 0;
    NOTIFY_LISTENERS(OnLengthChange, (mLength));
    return true;
  }
  return false;
}

NS_IMETHODIMP_(void)
nsSHistory::RemoveEntries(nsTArray<uint64_t>& aIDs, int32_t aStartIndex)
{
  int32_t index = aStartIndex;
  while (index >= 0 && RemoveChildEntries(this, --index, aIDs)) {
  }
  int32_t minIndex = index;
  index = aStartIndex;
  while (index >= 0 && RemoveChildEntries(this, index++, aIDs)) {
  }

  // We need to remove duplicate nsSHEntry trees.
  bool didRemove = false;
  while (index > minIndex) {
    if (index != mIndex) {
      didRemove = RemoveDuplicate(index, index < mIndex) || didRemove;
    }
    --index;
  }
  if (didRemove && mRootDocShell) {
    NS_DispatchToCurrentThread(NewRunnableMethod(static_cast<nsDocShell*>(mRootDocShell),
                                                 &nsDocShell::FireDummyOnLocationChange));
  }
}

void
nsSHistory::RemoveDynEntries(int32_t aOldIndex, int32_t aNewIndex)
{
  // Search for the entries which are in the current index,
  // but not in the new one.
  nsCOMPtr<nsISHEntry> originalSH;
  GetEntryAtIndex(aOldIndex, false, getter_AddRefs(originalSH));
  nsCOMPtr<nsISHContainer> originalContainer = do_QueryInterface(originalSH);
  AutoTArray<uint64_t, 16> toBeRemovedEntries;
  if (originalContainer) {
    nsTArray<uint64_t> originalDynDocShellIDs;
    GetDynamicChildren(originalContainer, originalDynDocShellIDs, true);
    if (originalDynDocShellIDs.Length()) {
      nsCOMPtr<nsISHEntry> currentSH;
      GetEntryAtIndex(aNewIndex, false, getter_AddRefs(currentSH));
      nsCOMPtr<nsISHContainer> newContainer = do_QueryInterface(currentSH);
      if (newContainer) {
        nsTArray<uint64_t> newDynDocShellIDs;
        GetDynamicChildren(newContainer, newDynDocShellIDs, false);
        for (uint32_t i = 0; i < originalDynDocShellIDs.Length(); ++i) {
          if (!newDynDocShellIDs.Contains(originalDynDocShellIDs[i])) {
            toBeRemovedEntries.AppendElement(originalDynDocShellIDs[i]);
          }
        }
      }
    }
  }
  if (toBeRemovedEntries.Length()) {
    RemoveEntries(toBeRemovedEntries, aOldIndex);
  }
}

NS_IMETHODIMP
nsSHistory::UpdateIndex()
{
  // Update the actual index with the right value.
  if (mIndex != mRequestedIndex && mRequestedIndex != -1) {
    RemoveDynEntries(mIndex, mRequestedIndex);
    mIndex = mRequestedIndex;
  }

  mRequestedIndex = -1;
  return NS_OK;
}

NS_IMETHODIMP
nsSHistory::Stop(uint32_t aStopFlags)
{
  // Not implemented
  return NS_OK;
}

NS_IMETHODIMP
nsSHistory::GetDocument(nsIDOMDocument** aDocument)
{
  // Not implemented
  return NS_OK;
}

NS_IMETHODIMP
nsSHistory::GetCurrentURI(nsIURI** aResultURI)
{
  NS_ENSURE_ARG_POINTER(aResultURI);
  nsresult rv;

  nsCOMPtr<nsISHEntry> currentEntry;
  rv = GetEntryAtIndex(mIndex, false, getter_AddRefs(currentEntry));
  if (NS_FAILED(rv) && !currentEntry) {
    return rv;
  }
  rv = currentEntry->GetURI(aResultURI);
  return rv;
}

NS_IMETHODIMP
nsSHistory::GetReferringURI(nsIURI** aURI)
{
  *aURI = nullptr;
  // Not implemented
  return NS_OK;
}

NS_IMETHODIMP
nsSHistory::SetSessionHistory(nsISHistory* aSessionHistory)
{
  // Not implemented
  return NS_OK;
}

NS_IMETHODIMP
nsSHistory::GetSessionHistory(nsISHistory** aSessionHistory)
{
  // Not implemented
  return NS_OK;
}

NS_IMETHODIMP
nsSHistory::LoadURIWithOptions(const char16_t* aURI,
                               uint32_t aLoadFlags,
                               nsIURI* aReferringURI,
                               uint32_t aReferrerPolicy,
                               nsIInputStream* aPostStream,
                               nsIInputStream* aExtraHeaderStream,
                               nsIURI* aBaseURI)
{
  return NS_OK;
}

NS_IMETHODIMP
nsSHistory::SetOriginAttributesBeforeLoading(JS::HandleValue aOriginAttributes)
{
  return NS_OK;
}

NS_IMETHODIMP
nsSHistory::LoadURI(const char16_t* aURI,
                    uint32_t aLoadFlags,
                    nsIURI* aReferringURI,
                    nsIInputStream* aPostStream,
                    nsIInputStream* aExtraHeaderStream)
{
  return NS_OK;
}

NS_IMETHODIMP
nsSHistory::GotoIndex(int32_t aGlobalIndex)
{
  // We provide abstraction of grouped session history for nsIWebNavigation
  // functions, so the index passed in here is global index.
  return LoadEntry(aGlobalIndex - mGlobalIndexOffset, nsIDocShellLoadInfo::loadHistory,
                   HIST_CMD_GOTOINDEX);
}

nsresult
nsSHistory::LoadNextPossibleEntry(int32_t aNewIndex, long aLoadType,
                                  uint32_t aHistCmd)
{
  mRequestedIndex = -1;
  if (aNewIndex < mIndex) {
    return LoadEntry(aNewIndex - 1, aLoadType, aHistCmd);
  }
  if (aNewIndex > mIndex) {
    return LoadEntry(aNewIndex + 1, aLoadType, aHistCmd);
  }
  return NS_ERROR_FAILURE;
}

NS_IMETHODIMP
nsSHistory::LoadEntry(int32_t aIndex, long aLoadType, uint32_t aHistCmd)
{
  if (!mRootDocShell) {
    return NS_ERROR_FAILURE;
  }

  if (aIndex < 0 || aIndex >= mLength) {
    if (aIndex + mGlobalIndexOffset < 0) {
      // The global index is negative.
      return NS_ERROR_FAILURE;
    }

    if (aIndex - mLength >= mEntriesInFollowingPartialHistories) {
      // The global index exceeds max possible value.
      return NS_ERROR_FAILURE;
    }

    // The global index is valid. trigger cross browser navigation.
    nsCOMPtr<nsIPartialSHistoryListener> listener =
      do_QueryReferent(mPartialHistoryListener);
    if (!listener) {
      return NS_ERROR_FAILURE;
    }
    return listener->OnRequestCrossBrowserNavigation(aIndex + mGlobalIndexOffset);
  }

  // Keep note of requested history index in mRequestedIndex.
  mRequestedIndex = aIndex;

  nsCOMPtr<nsISHEntry> prevEntry;
  GetEntryAtIndex(mIndex, false, getter_AddRefs(prevEntry));

  nsCOMPtr<nsISHEntry> nextEntry;
  GetEntryAtIndex(mRequestedIndex, false, getter_AddRefs(nextEntry));
  if (!nextEntry || !prevEntry) {
    mRequestedIndex = -1;
    return NS_ERROR_FAILURE;
  }

  // Remember that this entry is getting loaded at this point in the sequence
  nsCOMPtr<nsISHEntryInternal> entryInternal = do_QueryInterface(nextEntry);

  if (entryInternal) {
    entryInternal->SetLastTouched(++gTouchCounter);
  }

  // Send appropriate listener notifications
  bool canNavigate = true;
  // Get the uri for the entry we are about to visit
  nsCOMPtr<nsIURI> nextURI;
  nextEntry->GetURI(getter_AddRefs(nextURI));

  if (aHistCmd == HIST_CMD_BACK) {
    // We are going back one entry. Send GoBack notifications
    NOTIFY_LISTENERS_CANCELABLE(OnHistoryGoBack, canNavigate,
                                (nextURI, &canNavigate));
  } else if (aHistCmd == HIST_CMD_FORWARD) {
    // We are going forward. Send GoForward notification
    NOTIFY_LISTENERS_CANCELABLE(OnHistoryGoForward, canNavigate,
                                (nextURI, &canNavigate));
  } else if (aHistCmd == HIST_CMD_GOTOINDEX) {
    // We are going somewhere else. This is not reload either
    NOTIFY_LISTENERS_CANCELABLE(OnHistoryGotoIndex, canNavigate,
                                (aIndex, nextURI, &canNavigate));
  }

  if (!canNavigate) {
    // If the listener asked us not to proceed with
    // the operation, simply return.
    mRequestedIndex = -1;
    return NS_OK;  // XXX Maybe I can return some other error code?
  }

  if (mRequestedIndex == mIndex) {
    // Possibly a reload case
    return InitiateLoad(nextEntry, mRootDocShell, aLoadType);
  }

  // Going back or forward.
  bool differenceFound = false;
  nsresult rv = LoadDifferingEntries(prevEntry, nextEntry, mRootDocShell,
                                     aLoadType, differenceFound);
  if (!differenceFound) {
    // We did not find any differences. Go further in the history.
    return LoadNextPossibleEntry(aIndex, aLoadType, aHistCmd);
  }

  return rv;
}

nsresult
nsSHistory::LoadDifferingEntries(nsISHEntry* aPrevEntry, nsISHEntry* aNextEntry,
                                 nsIDocShell* aParent, long aLoadType,
                                 bool& aDifferenceFound)
{
  if (!aPrevEntry || !aNextEntry || !aParent) {
    return NS_ERROR_FAILURE;
  }

  nsresult result = NS_OK;
  uint32_t prevID, nextID;

  aPrevEntry->GetID(&prevID);
  aNextEntry->GetID(&nextID);

  // Check the IDs to verify if the pages are different.
  if (prevID != nextID) {
    aDifferenceFound = true;

    // Set the Subframe flag if not navigating the root docshell.
    aNextEntry->SetIsSubFrame(aParent != mRootDocShell);
    return InitiateLoad(aNextEntry, aParent, aLoadType);
  }

  // The entries are the same, so compare any child frames
  int32_t pcnt = 0;
  int32_t ncnt = 0;
  int32_t dsCount = 0;
  nsCOMPtr<nsISHContainer> prevContainer(do_QueryInterface(aPrevEntry));
  nsCOMPtr<nsISHContainer> nextContainer(do_QueryInterface(aNextEntry));

  if (!prevContainer || !nextContainer) {
    return NS_ERROR_FAILURE;
  }

  prevContainer->GetChildCount(&pcnt);
  nextContainer->GetChildCount(&ncnt);
  aParent->GetChildCount(&dsCount);

  // Create an array for child docshells.
  nsCOMArray<nsIDocShell> docshells;
  for (int32_t i = 0; i < dsCount; ++i) {
    nsCOMPtr<nsIDocShellTreeItem> treeItem;
    aParent->GetChildAt(i, getter_AddRefs(treeItem));
    nsCOMPtr<nsIDocShell> shell = do_QueryInterface(treeItem);
    if (shell) {
      docshells.AppendElement(shell.forget());
    }
  }

  // Search for something to load next.
  for (int32_t i = 0; i < ncnt; ++i) {
    // First get an entry which may cause a new page to be loaded.
    nsCOMPtr<nsISHEntry> nChild;
    nextContainer->GetChildAt(i, getter_AddRefs(nChild));
    if (!nChild) {
      continue;
    }
    uint64_t docshellID = 0;
    nChild->GetDocshellID(&docshellID);

    // Then find the associated docshell.
    nsIDocShell* dsChild = nullptr;
    int32_t count = docshells.Count();
    for (int32_t j = 0; j < count; ++j) {
      uint64_t shellID = 0;
      nsIDocShell* shell = docshells[j];
      shell->GetHistoryID(&shellID);
      if (shellID == docshellID) {
        dsChild = shell;
        break;
      }
    }
    if (!dsChild) {
      continue;
    }

    // Then look at the previous entries to see if there was
    // an entry for the docshell.
    nsCOMPtr<nsISHEntry> pChild;
    for (int32_t k = 0; k < pcnt; ++k) {
      nsCOMPtr<nsISHEntry> child;
      prevContainer->GetChildAt(k, getter_AddRefs(child));
      if (child) {
        uint64_t dID = 0;
        child->GetDocshellID(&dID);
        if (dID == docshellID) {
          pChild = child;
          break;
        }
      }
    }

    // Finally recursively call this method.
    // This will either load a new page to shell or some subshell or
    // do nothing.
    LoadDifferingEntries(pChild, nChild, dsChild, aLoadType, aDifferenceFound);
  }
  return result;
}

nsresult
nsSHistory::InitiateLoad(nsISHEntry* aFrameEntry, nsIDocShell* aFrameDS,
                         long aLoadType)
{
  NS_ENSURE_STATE(aFrameDS && aFrameEntry);

  nsCOMPtr<nsIDocShellLoadInfo> loadInfo;

  /* Set the loadType in the SHEntry too to  what was passed on.
   * This will be passed on to child subframes later in nsDocShell,
   * so that proper loadType is maintained through out a frameset
   */
  aFrameEntry->SetLoadType(aLoadType);
  aFrameDS->CreateLoadInfo(getter_AddRefs(loadInfo));

  loadInfo->SetLoadType(aLoadType);
  loadInfo->SetSHEntry(aFrameEntry);

  nsCOMPtr<nsIURI> originalURI;
  aFrameEntry->GetOriginalURI(getter_AddRefs(originalURI));
  loadInfo->SetOriginalURI(originalURI);

  bool loadReplace;
  aFrameEntry->GetLoadReplace(&loadReplace);
  loadInfo->SetLoadReplace(loadReplace);

  nsCOMPtr<nsIURI> nextURI;
  aFrameEntry->GetURI(getter_AddRefs(nextURI));
  // Time   to initiate a document load
  return aFrameDS->LoadURI(nextURI, loadInfo,
                           nsIWebNavigation::LOAD_FLAGS_NONE, false);

}

NS_IMETHODIMP
nsSHistory::SetRootDocShell(nsIDocShell* aDocShell)
{
  mRootDocShell = aDocShell;
  return NS_OK;
}

NS_IMETHODIMP
nsSHistory::GetSHistoryEnumerator(nsISimpleEnumerator** aEnumerator)
{
  NS_ENSURE_ARG_POINTER(aEnumerator);
  RefPtr<nsSHEnumerator> iterator = new nsSHEnumerator(this);
  iterator.forget(aEnumerator);
  return NS_OK;
}

NS_IMETHODIMP
nsSHistory::OnAttachGroupedSessionHistory(int32_t aOffset)
{
  NS_ENSURE_TRUE(!mIsPartial, NS_ERROR_UNEXPECTED);
  NS_ENSURE_TRUE(aOffset >= 0, NS_ERROR_ILLEGAL_VALUE);

  mIsPartial = true;
  mGlobalIndexOffset = aOffset;

  // The last attached history is always at the end of the group.
  mEntriesInFollowingPartialHistories = 0;

  // Setting grouped history info may change canGoBack / canGoForward.
  // Send a location change to update these values.
  NS_DispatchToCurrentThread(NewRunnableMethod(static_cast<nsDocShell*>(mRootDocShell),
                                               &nsDocShell::FireDummyOnLocationChange));
  return NS_OK;

}

nsSHEnumerator::nsSHEnumerator(nsSHistory* aSHistory) : mIndex(-1)
{
  mSHistory = aSHistory;
}

nsSHEnumerator::~nsSHEnumerator()
{
  mSHistory = nullptr;
}

NS_IMPL_ISUPPORTS(nsSHEnumerator, nsISimpleEnumerator)

NS_IMETHODIMP
nsSHEnumerator::HasMoreElements(bool* aReturn)
{
  int32_t cnt;
  *aReturn = false;
  mSHistory->GetCount(&cnt);
  if (mIndex >= -1 && mIndex < (cnt - 1)) {
    *aReturn = true;
  }
  return NS_OK;
}

NS_IMETHODIMP
nsSHEnumerator::GetNext(nsISupports** aItem)
{
  NS_ENSURE_ARG_POINTER(aItem);
  int32_t cnt = 0;

  nsresult result = NS_ERROR_FAILURE;
  mSHistory->GetCount(&cnt);
  if (mIndex < (cnt - 1)) {
    mIndex++;
    nsCOMPtr<nsISHEntry> hEntry;
    result = mSHistory->GetEntryAtIndex(mIndex, false, getter_AddRefs(hEntry));
    if (hEntry) {
      result = CallQueryInterface(hEntry, aItem);
    }
  }
  return result;
}
