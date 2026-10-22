/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef nsSHEntryShared_h_
#define nsSHEntryShared_h_

#include "nsCOMArray.h"
#include "nsCOMPtr.h"
#include "nsExpirationTracker.h"
#include "nsIBFCacheEntry.h"
#include "nsIPolicyContainer.h"
#include "nsIWeakReferenceUtils.h"
#include "nsRect.h"
#include "nsString.h"
#include "nsStructuredCloneContainer.h"
#include "nsStubMutationObserver.h"

#include "mozilla/UniquePtr.h"

class nsISHEntry;
class nsISHistory;
class nsIDocShellTreeItem;
class nsIDocumentViewer;
class nsILayoutHistoryState;
class nsIPolicyContainer;
class nsIPrincipal;
class nsDocShellEditorData;
class nsFrameLoader;
class nsIMutableArray;
class nsSHistory;

// A document may have multiple SHEntries, either due to hash navigations or
// calls to history.pushState.  SHEntries corresponding to the same document
// share many members; in particular, they share state related to the
// back/forward cache.
//
// The classes defined here are the vehicle for this sharing.
//
// Some of the state can only be stored in the process where we did the actual
// load, because that's where the objects live (eg. the content viewer).

namespace mozilla {
namespace dom {
class Document;

/**
 * SHEntrySharedState holds shared state both in the child process and in the
 * parent process.
 */
struct SHEntrySharedState {
  SHEntrySharedState() : mId(GenerateId()) {}
  SHEntrySharedState(const SHEntrySharedState& aState) = default;
  SHEntrySharedState(nsIPrincipal* aTriggeringPrincipal,
                     nsIPrincipal* aPrincipalToInherit,
                     nsIPrincipal* aPartitionedPrincipalToInherit,
                     nsIPolicyContainer* aPolicyContainer,
                     const nsACString& aContentType)
      : mId(GenerateId()),
        mTriggeringPrincipal(aTriggeringPrincipal),
        mPrincipalToInherit(aPrincipalToInherit),
        mPartitionedPrincipalToInherit(aPartitionedPrincipalToInherit),
        mPolicyContainer(aPolicyContainer),
        mContentType(aContentType) {}

  // These members aren't copied by SHEntrySharedParentState::CopyFrom() because
  // they're specific to a particular content viewer.
  uint64_t mId = 0;

  // These members are copied by SHEntrySharedParentState::CopyFrom(). If you
  // add a member here, be sure to update the CopyFrom() implementation.
  nsCOMPtr<nsIPrincipal> mTriggeringPrincipal;
  nsCOMPtr<nsIPrincipal> mPrincipalToInherit;
  nsCOMPtr<nsIPrincipal> mPartitionedPrincipalToInherit;
  nsCOMPtr<nsIPolicyContainer> mPolicyContainer;
  nsCString mContentType;
  // Child side updates layout history state when page is being unloaded or
  // moved to bfcache.
  nsCOMPtr<nsILayoutHistoryState> mLayoutHistoryState;
  uint32_t mCacheKey = 0;
  bool mIsFrameNavigation = false;
  bool mSaveLayoutState = true;

 protected:
  static uint64_t GenerateId();
};

/**
 * SHEntrySharedParentState holds the shared state that can live in the parent
 * process.
 */
class SHEntrySharedParentState : public SHEntrySharedState {
 public:
  friend class SessionHistoryInfo;

  uint64_t GetId() const { return mId; }
  void ChangeId(uint64_t aId);

  // The inner window of the document this state belongs to, or 0 if the parent
  // can't vouch for any.
  uint64_t InnerWindowId() const { return mInnerWindowId; }
  void SetInnerWindowId(uint64_t aInnerWindowId) {
    mInnerWindowId = aInnerWindowId;
  }

  void SetFrameLoader(nsFrameLoader* aFrameLoader);

  nsFrameLoader* GetFrameLoader();

  void NotifyListenersDocumentViewerEvicted();

  nsExpirationState* GetExpirationState() { return &mExpirationState; }

  SHEntrySharedParentState();
  SHEntrySharedParentState(nsIPrincipal* aTriggeringPrincipal,
                           nsIPrincipal* aPrincipalToInherit,
                           nsIPrincipal* aPartitionedPrincipalToInherit,
                           nsIPolicyContainer* aPolicyContainer,
                           const nsACString& aContentType);

  // This returns the existing SHEntrySharedParentState that was registered for
  // aId, if one exists.
  static SHEntrySharedParentState* Lookup(uint64_t aId);

 protected:
  virtual ~SHEntrySharedParentState();
  NS_INLINE_DECL_VIRTUAL_REFCOUNTING_WITH_DESTROY(SHEntrySharedParentState,
                                                  Destroy())

  virtual void Destroy() { delete this; }

  void CopyFrom(SHEntrySharedParentState* aSource);

  // These members are copied by SHEntrySharedParentState::CopyFrom(). If you
  // add a member here, be sure to update the CopyFrom() implementation.
  nsID mDocShellID{};

  nsIntRect mViewerBounds{0, 0, 0, 0};

  uint32_t mLastTouched = 0;

  // These members aren't copied by SHEntrySharedParentState::CopyFrom() because
  // they're specific to a particular content viewer.
  nsWeakPtr mSHistory;

  RefPtr<nsFrameLoader> mFrameLoader;

  uint64_t mInnerWindowId = 0;

  nsExpirationState mExpirationState;

  bool mSticky = true;
  bool mDynamicallyCreated = false;

  // This flag is about necko cache, not bfcache.
  bool mExpired = false;
};

/**
 * SHEntrySharedChildState holds the shared state that needs to live in the
 * process where the document was loaded.
 */
class SHEntrySharedChildState {
 protected:
  void CopyFrom(SHEntrySharedChildState* aSource);

 public:
  // These members are copied by SHEntrySharedChildState::CopyFrom(). If you
  // add a member here, be sure to update the CopyFrom() implementation.
  nsCOMArray<nsIDocShellTreeItem> mChildShells;

  // These members aren't copied by SHEntrySharedChildState::CopyFrom() because
  // they're specific to a particular content viewer.
  nsCOMPtr<nsIDocumentViewer> mDocumentViewer;
  RefPtr<mozilla::dom::Document> mDocument;
  nsCOMPtr<nsISupports> mWindowState;
  // FIXME Move to parent?
  nsCOMPtr<nsIMutableArray> mRefreshURIList;
  UniquePtr<nsDocShellEditorData> mEditorData;
};

}  // namespace dom
}  // namespace mozilla

#endif
