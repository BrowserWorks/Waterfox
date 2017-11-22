/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_dom_idbtransaction_h__
#define mozilla_dom_idbtransaction_h__

#include "mozilla/Attributes.h"
#include "mozilla/dom/IDBTransactionBinding.h"
#include "mozilla/dom/IDBWrapperCache.h"
#include "nsAutoPtr.h"
#include "nsCycleCollectionParticipant.h"
#include "nsIRunnable.h"
#include "nsString.h"
#include "nsTArray.h"

class nsPIDOMWindowInner;

namespace mozilla {

class ErrorResult;
class EventChainPreVisitor;

namespace dom {

class DOMError;
class DOMStringList;
class IDBDatabase;
class IDBObjectStore;
class IDBOpenDBRequest;
class IDBRequest;

namespace indexedDB {
class BackgroundCursorChild;
class BackgroundRequestChild;
class BackgroundTransactionChild;
class BackgroundVersionChangeTransactionChild;
class IndexMetadata;
class ObjectStoreSpec;
class OpenCursorParams;
class RequestParams;
}

class IDBTransaction final
  : public IDBWrapperCache
  , public nsIRunnable
{
  friend class indexedDB::BackgroundCursorChild;
  friend class indexedDB::BackgroundRequestChild;

  class WorkerHolder;
  friend class WorkerHolder;

public:
  enum Mode
  {
    READ_ONLY = 0,
    READ_WRITE,
    READ_WRITE_FLUSH,
    CLEANUP,
    VERSION_CHANGE,

    // Only needed for IPC serialization helper, should never be used in code.
    MODE_INVALID
  };

  enum ReadyState
  {
    INITIAL = 0,
    LOADING,
    COMMITTING,
    DONE
  };

private:
  RefPtr<IDBDatabase> mDatabase;
  RefPtr<DOMError> mError;
  nsTArray<nsString> mObjectStoreNames;
  nsTArray<RefPtr<IDBObjectStore>> mObjectStores;
  nsTArray<RefPtr<IDBObjectStore>> mDeletedObjectStores;
  nsAutoPtr<WorkerHolder> mWorkerHolder;

  // Tagged with mMode. If mMode is VERSION_CHANGE then mBackgroundActor will be
  // a BackgroundVersionChangeTransactionChild. Otherwise it will be a
  // BackgroundTransactionChild.
  union {
    indexedDB::BackgroundTransactionChild* mNormalBackgroundActor;
    indexedDB::BackgroundVersionChangeTransactionChild* mVersionChangeBackgroundActor;
  } mBackgroundActor;

  const int64_t mLoggingSerialNumber;

  // Only used for VERSION_CHANGE transactions.
  int64_t mNextObjectStoreId;
  int64_t mNextIndexId;

  nsresult mAbortCode;
  uint32_t mPendingRequestCount;

  nsString mFilename;
  uint32_t mLineNo;
  uint32_t mColumn;

  ReadyState mReadyState;
  Mode mMode;

  bool mCreating;
  bool mRegistered;
  bool mAbortedByScript;
  bool mNotedActiveTransaction;

#ifdef DEBUG
  bool mSentCommitOrAbort;
  bool mFiredCompleteOrAbort;
#endif

public:
  static already_AddRefed<IDBTransaction>
  CreateVersionChange(IDBDatabase* aDatabase,
                      indexedDB::BackgroundVersionChangeTransactionChild* aActor,
                      IDBOpenDBRequest* aOpenRequest,
                      int64_t aNextObjectStoreId,
                      int64_t aNextIndexId);

  static already_AddRefed<IDBTransaction>
  Create(JSContext* aCx, IDBDatabase* aDatabase,
         const nsTArray<nsString>& aObjectStoreNames,
         Mode aMode);

  static IDBTransaction*
  GetCurrent();

  void
  AssertIsOnOwningThread() const
#ifdef DEBUG
  ;
#else
  { }
#endif

  void
  SetBackgroundActor(indexedDB::BackgroundTransactionChild* aBackgroundActor);

  void
  ClearBackgroundActor()
  {
    AssertIsOnOwningThread();

    if (mMode == VERSION_CHANGE) {
      mBackgroundActor.mVersionChangeBackgroundActor = nullptr;
    } else {
      mBackgroundActor.mNormalBackgroundActor = nullptr;
    }

    // Note inactive transaction here if we didn't receive the Complete message
    // from the parent.
    MaybeNoteInactiveTransaction();
  }

  indexedDB::BackgroundRequestChild*
  StartRequest(IDBRequest* aRequest, const indexedDB::RequestParams& aParams);

  void
  OpenCursor(indexedDB::BackgroundCursorChild* aBackgroundActor,
             const indexedDB::OpenCursorParams& aParams);

  void
  RefreshSpec(bool aMayDelete);

  bool
  IsOpen() const;

  bool
  IsCommittingOrDone() const
  {
    AssertIsOnOwningThread();

    return mReadyState == COMMITTING || mReadyState == DONE;
  }

  bool
  IsDone() const
  {
    AssertIsOnOwningThread();

    return mReadyState == DONE;
  }

  bool
  IsWriteAllowed() const
  {
    AssertIsOnOwningThread();
    return mMode == READ_WRITE ||
           mMode == READ_WRITE_FLUSH ||
           mMode == CLEANUP ||
           mMode == VERSION_CHANGE;
  }

  bool
  IsAborted() const
  {
    AssertIsOnOwningThread();
    return NS_FAILED(mAbortCode);
  }

  nsresult
  AbortCode() const
  {
    AssertIsOnOwningThread();
    return mAbortCode;
  }

  void
  GetCallerLocation(nsAString& aFilename, uint32_t* aLineNo,
                    uint32_t* aColumn) const;

  // 'Get' prefix is to avoid name collisions with the enum
  Mode
  GetMode() const
  {
    AssertIsOnOwningThread();
    return mMode;
  }

  IDBDatabase*
  Database() const
  {
    AssertIsOnOwningThread();
    return mDatabase;
  }

  IDBDatabase*
  Db() const
  {
    return Database();
  }

  const nsTArray<nsString>&
  ObjectStoreNamesInternal() const
  {
    AssertIsOnOwningThread();
    return mObjectStoreNames;
  }

  already_AddRefed<IDBObjectStore>
  CreateObjectStore(const indexedDB::ObjectStoreSpec& aSpec);

  void
  DeleteObjectStore(int64_t aObjectStoreId);

  void
  RenameObjectStore(int64_t aObjectStoreId, const nsAString& aName);

  void
  CreateIndex(IDBObjectStore* aObjectStore, const indexedDB::IndexMetadata& aMetadata);

  void
  DeleteIndex(IDBObjectStore* aObjectStore, int64_t aIndexId);

  void
  RenameIndex(IDBObjectStore* aObjectStore, int64_t aIndexId, const nsAString& aName);

  void
  Abort(IDBRequest* aRequest);

  void
  Abort(nsresult aAbortCode);

  int64_t
  LoggingSerialNumber() const
  {
    AssertIsOnOwningThread();

    return mLoggingSerialNumber;
  }

  nsPIDOMWindowInner*
  GetParentObject() const;

  IDBTransactionMode
  GetMode(ErrorResult& aRv) const;

  DOMError*
  GetError() const;

  already_AddRefed<IDBObjectStore>
  ObjectStore(const nsAString& aName, ErrorResult& aRv);

  void
  Abort(ErrorResult& aRv);

  IMPL_EVENT_HANDLER(abort)
  IMPL_EVENT_HANDLER(complete)
  IMPL_EVENT_HANDLER(error)

  already_AddRefed<DOMStringList>
  ObjectStoreNames() const;

  void
  FireCompleteOrAbortEvents(nsresult aResult);

  // Only for VERSION_CHANGE transactions.
  int64_t
  NextObjectStoreId();

  // Only for VERSION_CHANGE transactions.
  int64_t
  NextIndexId();

  NS_DECL_ISUPPORTS_INHERITED
  NS_DECL_NSIRUNNABLE
  NS_DECL_CYCLE_COLLECTION_CLASS_INHERITED(IDBTransaction, IDBWrapperCache)

  // nsWrapperCache
  virtual JSObject*
  WrapObject(JSContext* aCx, JS::Handle<JSObject*> aGivenProto) override;

  // nsIDOMEventTarget
  virtual nsresult
  GetEventTargetParent(EventChainPreVisitor& aVisitor) override;

private:
  IDBTransaction(IDBDatabase* aDatabase,
                 const nsTArray<nsString>& aObjectStoreNames,
                 Mode aMode);
  ~IDBTransaction();

  void
  AbortInternal(nsresult aAbortCode, already_AddRefed<DOMError> aError);

  void
  SendCommit();

  void
  SendAbort(nsresult aResultCode);

  void
  NoteActiveTransaction();

  void
  MaybeNoteInactiveTransaction();

  void
  OnNewRequest();

  void
  OnRequestFinished(bool aActorDestroyedNormally);
};

} // namespace dom
} // namespace mozilla

#endif // mozilla_dom_idbtransaction_h__
