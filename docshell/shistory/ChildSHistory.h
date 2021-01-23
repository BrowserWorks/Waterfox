/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/**
 * ChildSHistory represents a view of session history from a child process. It
 * exposes getters for some cached history state, and mutators which are
 * implemented by communicating with the actual history storage.
 *
 * NOTE: Currently session history is in transition, meaning that we're still
 * using the legacy nsSHistory class internally. The API exposed from this class
 * should be only the API which we expect to expose when this transition is
 * complete, and special cases will need to call through the LegacySHistory()
 * getters.
 */

#ifndef mozilla_dom_ChildSHistory_h
#define mozilla_dom_ChildSHistory_h

#include "nsCOMPtr.h"
#include "mozilla/ErrorResult.h"
#include "nsWrapperCache.h"
#include "nsThreadUtils.h"
#include "mozilla/LinkedList.h"

class nsISHEntry;
class nsISHistory;

namespace mozilla {
namespace dom {

class BrowsingContext;

class ChildSHistory : public nsISupports, public nsWrapperCache {
 public:
  NS_DECL_CYCLE_COLLECTING_ISUPPORTS
  NS_DECL_CYCLE_COLLECTION_SCRIPT_HOLDER_CLASS(ChildSHistory)
  nsISupports* GetParentObject() const;
  JSObject* WrapObject(JSContext* cx,
                       JS::Handle<JSObject*> aGivenProto) override;

  explicit ChildSHistory(BrowsingContext* aBrowsingContext);

  // Create or destroy the session history implementation in the child process.
  // This can be removed once session history is stored exclusively in the
  // parent process.
  void SetIsInProcess(bool aIsInProcess);
  bool IsInProcess() { return !!mHistory; }

  int32_t Count();
  int32_t Index();

  /**
   * Reload the current entry in the session history.
   */
  void Reload(uint32_t aReloadFlags, ErrorResult& aRv);

  /**
   * The CanGo and Go methods are called with an offset from the current index.
   * Positive numbers go forward in history, while negative numbers go
   * backwards.
   */
  bool CanGo(int32_t aOffset);
  void Go(int32_t aOffset, ErrorResult& aRv);
  void AsyncGo(int32_t aOffset);

  void RemovePendingHistoryNavigations();

  /**
   * Evicts all content viewers within the current process.
   */
  void EvictLocalContentViewers();

  nsISHistory* LegacySHistory();

  void SetLength(uint32_t aLength) { mLength = aLength; }

 private:
  virtual ~ChildSHistory() = default;

  class PendingAsyncHistoryNavigation
      : public Runnable,
        public mozilla::LinkedListElement<PendingAsyncHistoryNavigation> {
   public:
    PendingAsyncHistoryNavigation(ChildSHistory* aHistory, int32_t aOffset)
        : Runnable("PendingAsyncHistoryNavigation"),
          mHistory(aHistory),
          mOffset(aOffset) {}

    NS_IMETHOD Run() override {
      if (isInList()) {
        remove();
        mHistory->Go(mOffset, IgnoreErrors());
      }
      return NS_OK;
    }

   private:
    RefPtr<ChildSHistory> mHistory;
    int32_t mOffset;
  };

  RefPtr<BrowsingContext> mBrowsingContext;
  nsCOMPtr<nsISHistory> mHistory;
  mozilla::LinkedList<PendingAsyncHistoryNavigation> mPendingNavigations;
  uint32_t mLength = 0;
};

}  // namespace dom
}  // namespace mozilla

#endif /* mozilla_dom_ChildSHistory_h */
