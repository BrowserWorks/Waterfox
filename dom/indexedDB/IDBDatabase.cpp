/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "IDBDatabase.h"

#include "FileInfo.h"
#include "IDBEvents.h"
#include "IDBFactory.h"
#include "IDBIndex.h"
#include "IDBMutableFile.h"
#include "IDBObjectStore.h"
#include "IDBRequest.h"
#include "IDBTransaction.h"
#include "IDBFactory.h"
#include "IndexedDatabaseManager.h"
#include "mozilla/ErrorResult.h"
#include "mozilla/EventDispatcher.h"
#include "MainThreadUtils.h"
#include "mozilla/Services.h"
#include "mozilla/storage.h"
#include "mozilla/dom/BindingDeclarations.h"
#include "mozilla/dom/DOMStringList.h"
#include "mozilla/dom/DOMStringListBinding.h"
#include "mozilla/dom/Exceptions.h"
#include "mozilla/dom/File.h"
#include "mozilla/dom/IDBDatabaseBinding.h"
#include "mozilla/dom/IDBObjectStoreBinding.h"
#include "mozilla/dom/indexedDB/PBackgroundIDBDatabaseFileChild.h"
#include "mozilla/dom/indexedDB/PBackgroundIDBSharedTypes.h"
#include "mozilla/dom/IPCBlobUtils.h"
#include "mozilla/dom/quota/QuotaManager.h"
#include "mozilla/ipc/BackgroundChild.h"
#include "mozilla/ipc/BackgroundUtils.h"
#include "mozilla/ipc/FileDescriptor.h"
#include "mozilla/ipc/InputStreamParams.h"
#include "mozilla/ipc/InputStreamUtils.h"
#include "nsAutoPtr.h"
#include "nsCOMPtr.h"
#include "nsIDocument.h"
#include "nsIObserver.h"
#include "nsIObserverService.h"
#include "nsIScriptError.h"
#include "nsISupportsPrimitives.h"
#include "nsThreadUtils.h"
#include "ProfilerHelpers.h"
#include "ReportInternalError.h"
#include "ScriptErrorHelper.h"
#include "nsQueryObject.h"

// Include this last to avoid path problems on Windows.
#include "ActorsChild.h"

namespace mozilla {
namespace dom {

using namespace mozilla::dom::indexedDB;
using namespace mozilla::dom::quota;
using namespace mozilla::ipc;
using namespace mozilla::services;

namespace {

const char kCycleCollectionObserverTopic[] = "cycle-collector-end";
const char kMemoryPressureObserverTopic[] = "memory-pressure";
const char kWindowObserverTopic[] = "inner-window-destroyed";

class CancelableRunnableWrapper final
  : public CancelableRunnable
{
  nsCOMPtr<nsIRunnable> mRunnable;

public:
  explicit
  CancelableRunnableWrapper(nsIRunnable* aRunnable)
    : mRunnable(aRunnable)
  {
    MOZ_ASSERT(aRunnable);
  }

private:
  ~CancelableRunnableWrapper()
  { }

  NS_DECL_NSIRUNNABLE
  nsresult Cancel() override;
};

class DatabaseFile final
  : public PBackgroundIDBDatabaseFileChild
{
  IDBDatabase* mDatabase;

public:
  explicit DatabaseFile(IDBDatabase* aDatabase)
    : mDatabase(aDatabase)
  {
    MOZ_ASSERT(aDatabase);
    aDatabase->AssertIsOnOwningThread();

    MOZ_COUNT_CTOR(DatabaseFile);
  }

private:
  ~DatabaseFile()
  {
    MOZ_ASSERT(!mDatabase);

    MOZ_COUNT_DTOR(DatabaseFile);
  }

  virtual void
  ActorDestroy(ActorDestroyReason aWhy) override
  {
    MOZ_ASSERT(mDatabase);
    mDatabase->AssertIsOnOwningThread();

    if (aWhy != Deletion) {
      RefPtr<IDBDatabase> database = mDatabase;
      database->NoteFinishedFileActor(this);
    }

#ifdef DEBUG
    mDatabase = nullptr;
#endif
  }
};

} // namespace

class IDBDatabase::Observer final
  : public nsIObserver
{
  IDBDatabase* mWeakDatabase;
  const uint64_t mWindowId;

public:
  Observer(IDBDatabase* aDatabase, uint64_t aWindowId)
    : mWeakDatabase(aDatabase)
    , mWindowId(aWindowId)
  {
    MOZ_ASSERT(NS_IsMainThread());
    MOZ_ASSERT(aDatabase);
  }

  void
  Revoke()
  {
    MOZ_ASSERT(NS_IsMainThread());

    mWeakDatabase = nullptr;
  }

  NS_DECL_ISUPPORTS

private:
  ~Observer()
  {
    MOZ_ASSERT(NS_IsMainThread());
    MOZ_ASSERT(!mWeakDatabase);
  }

  NS_DECL_NSIOBSERVER
};

IDBDatabase::IDBDatabase(IDBOpenDBRequest* aRequest,
                         IDBFactory* aFactory,
                         BackgroundDatabaseChild* aActor,
                         DatabaseSpec* aSpec)
  : IDBWrapperCache(aRequest)
  , mFactory(aFactory)
  , mSpec(aSpec)
  , mBackgroundActor(aActor)
  , mFileHandleDisabled(aRequest->IsFileHandleDisabled())
  , mClosed(false)
  , mInvalidated(false)
  , mQuotaExceeded(false)
{
  MOZ_ASSERT(aRequest);
  MOZ_ASSERT(aFactory);
  aFactory->AssertIsOnOwningThread();
  MOZ_ASSERT(aActor);
  MOZ_ASSERT(aSpec);
}

IDBDatabase::~IDBDatabase()
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(!mBackgroundActor);
}

// static
already_AddRefed<IDBDatabase>
IDBDatabase::Create(IDBOpenDBRequest* aRequest,
                    IDBFactory* aFactory,
                    BackgroundDatabaseChild* aActor,
                    DatabaseSpec* aSpec)
{
  MOZ_ASSERT(aRequest);
  MOZ_ASSERT(aFactory);
  aFactory->AssertIsOnOwningThread();
  MOZ_ASSERT(aActor);
  MOZ_ASSERT(aSpec);

  RefPtr<IDBDatabase> db =
    new IDBDatabase(aRequest, aFactory, aActor, aSpec);

  db->SetScriptOwner(aRequest->GetScriptOwner());

  if (NS_IsMainThread()) {
    if (nsPIDOMWindowInner* window = aFactory->GetParentObject()) {
      uint64_t windowId = window->WindowID();

      RefPtr<Observer> observer = new Observer(db, windowId);

      nsCOMPtr<nsIObserverService> obsSvc = GetObserverService();
      MOZ_ASSERT(obsSvc);

      // This topic must be successfully registered.
      if (NS_WARN_IF(NS_FAILED(
            obsSvc->AddObserver(observer, kWindowObserverTopic, false)))) {
        observer->Revoke();
        return nullptr;
      }

      // These topics are not crucial.
      if (NS_FAILED(obsSvc->AddObserver(observer,
                                        kCycleCollectionObserverTopic,
                                        false)) ||
          NS_FAILED(obsSvc->AddObserver(observer,
                                        kMemoryPressureObserverTopic,
                                        false))) {
        NS_WARNING("Failed to add additional memory observers!");
      }

      db->mObserver.swap(observer);
    }
  }

  return db.forget();
}

#ifdef DEBUG

void
IDBDatabase::AssertIsOnOwningThread() const
{
  MOZ_ASSERT(mFactory);
  mFactory->AssertIsOnOwningThread();
}

#endif // DEBUG

nsIEventTarget*
IDBDatabase::EventTarget() const
{
  AssertIsOnOwningThread();
  return Factory()->EventTarget();
}

void
IDBDatabase::CloseInternal()
{
  AssertIsOnOwningThread();

  if (!mClosed) {
    mClosed = true;

    ExpireFileActors(/* aExpireAll */ true);

    if (mObserver) {
      mObserver->Revoke();

      nsCOMPtr<nsIObserverService> obsSvc = GetObserverService();
      if (obsSvc) {
        // These might not have been registered.
        obsSvc->RemoveObserver(mObserver, kCycleCollectionObserverTopic);
        obsSvc->RemoveObserver(mObserver, kMemoryPressureObserverTopic);

        MOZ_ALWAYS_SUCCEEDS(
          obsSvc->RemoveObserver(mObserver, kWindowObserverTopic));
      }

      mObserver = nullptr;
    }

    if (mBackgroundActor && !mInvalidated) {
      mBackgroundActor->SendClose();
    }
  }
}

void
IDBDatabase::InvalidateInternal()
{
  AssertIsOnOwningThread();

  InvalidateMutableFiles();
  AbortTransactions(/* aShouldWarn */ true);

  CloseInternal();
}

void
IDBDatabase::EnterSetVersionTransaction(uint64_t aNewVersion)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(aNewVersion);
  MOZ_ASSERT(!RunningVersionChangeTransaction());
  MOZ_ASSERT(mSpec);
  MOZ_ASSERT(!mPreviousSpec);

  mPreviousSpec = new DatabaseSpec(*mSpec);

  mSpec->metadata().version() = aNewVersion;
}

void
IDBDatabase::ExitSetVersionTransaction()
{
  AssertIsOnOwningThread();

  if (mPreviousSpec) {
    mPreviousSpec = nullptr;
  }
}

void
IDBDatabase::RevertToPreviousState()
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(RunningVersionChangeTransaction());
  MOZ_ASSERT(mPreviousSpec);

  // Hold the current spec alive until RefreshTransactionsSpecEnumerator has
  // finished!
  nsAutoPtr<DatabaseSpec> currentSpec(mSpec.forget());

  mSpec = mPreviousSpec.forget();

  RefreshSpec(/* aMayDelete */ true);
}

void
IDBDatabase::RefreshSpec(bool aMayDelete)
{
  AssertIsOnOwningThread();

  for (auto iter = mTransactions.Iter(); !iter.Done(); iter.Next()) {
    RefPtr<IDBTransaction> transaction = iter.Get()->GetKey();
    MOZ_ASSERT(transaction);
    transaction->AssertIsOnOwningThread();
    transaction->RefreshSpec(aMayDelete);
  }
}

nsPIDOMWindowInner*
IDBDatabase::GetParentObject() const
{
  return mFactory->GetParentObject();
}

const nsString&
IDBDatabase::Name() const
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(mSpec);

  return mSpec->metadata().name();
}

uint64_t
IDBDatabase::Version() const
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(mSpec);

  return mSpec->metadata().version();
}

already_AddRefed<DOMStringList>
IDBDatabase::ObjectStoreNames() const
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(mSpec);

  const nsTArray<ObjectStoreSpec>& objectStores = mSpec->objectStores();

  RefPtr<DOMStringList> list = new DOMStringList();

  if (!objectStores.IsEmpty()) {
    nsTArray<nsString>& listNames = list->StringArray();
    listNames.SetCapacity(objectStores.Length());

    for (uint32_t index = 0; index < objectStores.Length(); index++) {
      listNames.InsertElementSorted(objectStores[index].metadata().name());
    }
  }

  return list.forget();
}

already_AddRefed<nsIDocument>
IDBDatabase::GetOwnerDocument() const
{
  if (nsPIDOMWindowInner* window = GetOwner()) {
    nsCOMPtr<nsIDocument> doc = window->GetExtantDoc();
    return doc.forget();
  }
  return nullptr;
}

already_AddRefed<IDBObjectStore>
IDBDatabase::CreateObjectStore(
                            const nsAString& aName,
                            const IDBObjectStoreParameters& aOptionalParameters,
                            ErrorResult& aRv)
{
  AssertIsOnOwningThread();

  IDBTransaction* transaction = IDBTransaction::GetCurrent();
  if (!transaction ||
      transaction->Database() != this ||
      transaction->GetMode() != IDBTransaction::VERSION_CHANGE) {
    aRv.Throw(NS_ERROR_DOM_INDEXEDDB_NOT_ALLOWED_ERR);
    return nullptr;
  }

  if (!transaction->IsOpen()) {
    aRv.Throw(NS_ERROR_DOM_INDEXEDDB_TRANSACTION_INACTIVE_ERR);
    return nullptr;
  }

  KeyPath keyPath(0);
  if (NS_FAILED(KeyPath::Parse(aOptionalParameters.mKeyPath, &keyPath))) {
    aRv.Throw(NS_ERROR_DOM_SYNTAX_ERR);
    return nullptr;
  }

  nsTArray<ObjectStoreSpec>& objectStores = mSpec->objectStores();
  for (uint32_t count = objectStores.Length(), index = 0;
       index < count;
       index++) {
    if (aName == objectStores[index].metadata().name()) {
      aRv.Throw(NS_ERROR_DOM_INDEXEDDB_CONSTRAINT_ERR);
      return nullptr;
    }
  }

  if (!keyPath.IsAllowedForObjectStore(aOptionalParameters.mAutoIncrement)) {
    aRv.Throw(NS_ERROR_DOM_INVALID_ACCESS_ERR);
    return nullptr;
  }

  const ObjectStoreSpec* oldSpecElements =
    objectStores.IsEmpty() ? nullptr : objectStores.Elements();

  ObjectStoreSpec* newSpec = objectStores.AppendElement();
  newSpec->metadata() =
    ObjectStoreMetadata(transaction->NextObjectStoreId(), nsString(aName),
                        keyPath, aOptionalParameters.mAutoIncrement);

  if (oldSpecElements &&
      oldSpecElements != objectStores.Elements()) {
    MOZ_ASSERT(objectStores.Length() > 1);

    // Array got moved, update the spec pointers for all live objectStores and
    // indexes.
    RefreshSpec(/* aMayDelete */ false);
  }

  RefPtr<IDBObjectStore> objectStore =
    transaction->CreateObjectStore(*newSpec);
  MOZ_ASSERT(objectStore);

  // Don't do this in the macro because we always need to increment the serial
  // number to keep in sync with the parent.
  const uint64_t requestSerialNumber = IDBRequest::NextSerialNumber();

  IDB_LOG_MARK("IndexedDB %s: Child  Transaction[%lld] Request[%llu]: "
                 "database(%s).transaction(%s).createObjectStore(%s)",
               "IndexedDB %s: C T[%lld] R[%llu]: "
                 "IDBDatabase.createObjectStore()",
               IDB_LOG_ID_STRING(),
               transaction->LoggingSerialNumber(),
               requestSerialNumber,
               IDB_LOG_STRINGIFY(this),
               IDB_LOG_STRINGIFY(transaction),
               IDB_LOG_STRINGIFY(objectStore));

  return objectStore.forget();
}

void
IDBDatabase::DeleteObjectStore(const nsAString& aName, ErrorResult& aRv)
{
  AssertIsOnOwningThread();

  IDBTransaction* transaction = IDBTransaction::GetCurrent();
  if (!transaction ||
      transaction->Database() != this ||
      transaction->GetMode() != IDBTransaction::VERSION_CHANGE) {
    aRv.Throw(NS_ERROR_DOM_INDEXEDDB_NOT_ALLOWED_ERR);
    return;
  }

  if (!transaction->IsOpen()) {
    aRv.Throw(NS_ERROR_DOM_INDEXEDDB_TRANSACTION_INACTIVE_ERR);
    return;
  }

  nsTArray<ObjectStoreSpec>& specArray = mSpec->objectStores();

  int64_t objectStoreId = 0;

  for (uint32_t specCount = specArray.Length(), specIndex = 0;
       specIndex < specCount;
       specIndex++) {
    const ObjectStoreMetadata& metadata = specArray[specIndex].metadata();
    MOZ_ASSERT(metadata.id());

    if (aName == metadata.name()) {
      objectStoreId = metadata.id();

      // Must do this before altering the metadata array!
      transaction->DeleteObjectStore(objectStoreId);

      specArray.RemoveElementAt(specIndex);

      RefreshSpec(/* aMayDelete */ false);
      break;
    }
  }

  if (!objectStoreId) {
    aRv.Throw(NS_ERROR_DOM_INDEXEDDB_NOT_FOUND_ERR);
    return;
  }

  // Don't do this in the macro because we always need to increment the serial
  // number to keep in sync with the parent.
  const uint64_t requestSerialNumber = IDBRequest::NextSerialNumber();

  IDB_LOG_MARK("IndexedDB %s: Child  Transaction[%lld] Request[%llu]: "
                 "database(%s).transaction(%s).deleteObjectStore(\"%s\")",
               "IndexedDB %s: C T[%lld] R[%llu]: "
                 "IDBDatabase.deleteObjectStore()",
               IDB_LOG_ID_STRING(),
               transaction->LoggingSerialNumber(),
               requestSerialNumber,
               IDB_LOG_STRINGIFY(this),
               IDB_LOG_STRINGIFY(transaction),
               NS_ConvertUTF16toUTF8(aName).get());
}

already_AddRefed<IDBTransaction>
IDBDatabase::Transaction(JSContext* aCx,
                         const StringOrStringSequence& aStoreNames,
                         IDBTransactionMode aMode,
                         ErrorResult& aRv)
{
  AssertIsOnOwningThread();

  if ((aMode == IDBTransactionMode::Readwriteflush ||
       aMode == IDBTransactionMode::Cleanup) &&
      !IndexedDatabaseManager::ExperimentalFeaturesEnabled()) {
    // Pretend that this mode doesn't exist. We don't have a way to annotate
    // certain enum values as depending on preferences so we just duplicate the
    // normal exception generation here.
    aRv.ThrowTypeError<MSG_INVALID_ENUM_VALUE>(
      NS_LITERAL_STRING("Argument 2 of IDBDatabase.transaction"),
      NS_LITERAL_STRING("readwriteflush"),
      NS_LITERAL_STRING("IDBTransactionMode"));
    return nullptr;
  }

  RefPtr<IDBTransaction> transaction;
  aRv = Transaction(aCx, aStoreNames, aMode, getter_AddRefs(transaction));
  if (NS_WARN_IF(aRv.Failed())) {
    return nullptr;
  }

  return transaction.forget();
}

nsresult
IDBDatabase::Transaction(JSContext* aCx,
                         const StringOrStringSequence& aStoreNames,
                         IDBTransactionMode aMode,
                         IDBTransaction** aTransaction)
{
  AssertIsOnOwningThread();

  if (NS_WARN_IF((aMode == IDBTransactionMode::Readwriteflush ||
                  aMode == IDBTransactionMode::Cleanup) &&
                 !IndexedDatabaseManager::ExperimentalFeaturesEnabled())) {
    IDB_REPORT_INTERNAL_ERR();
    return NS_ERROR_DOM_INDEXEDDB_UNKNOWN_ERR;
  }

  if (QuotaManager::IsShuttingDown()) {
    IDB_REPORT_INTERNAL_ERR();
    return NS_ERROR_DOM_INDEXEDDB_UNKNOWN_ERR;
  }

  if (mClosed || RunningVersionChangeTransaction()) {
    return NS_ERROR_DOM_INDEXEDDB_NOT_ALLOWED_ERR;
  }

  AutoTArray<nsString, 1> stackSequence;

  if (aStoreNames.IsString()) {
    stackSequence.AppendElement(aStoreNames.GetAsString());
  } else {
    MOZ_ASSERT(aStoreNames.IsStringSequence());
    if (aStoreNames.GetAsStringSequence().IsEmpty()) {
      return NS_ERROR_DOM_INVALID_ACCESS_ERR;
    }
  }

  const nsTArray<nsString>& storeNames =
    aStoreNames.IsString() ?
    stackSequence :
    static_cast<const nsTArray<nsString>&>(aStoreNames.GetAsStringSequence());
  MOZ_ASSERT(!storeNames.IsEmpty());

  const nsTArray<ObjectStoreSpec>& objectStores = mSpec->objectStores();
  const uint32_t nameCount = storeNames.Length();

  nsTArray<nsString> sortedStoreNames;
  sortedStoreNames.SetCapacity(nameCount);

  // Check to make sure the object store names we collected actually exist.
  for (uint32_t nameIndex = 0; nameIndex < nameCount; nameIndex++) {
    const nsString& name = storeNames[nameIndex];

    bool found = false;

    for (uint32_t objCount = objectStores.Length(), objIndex = 0;
         objIndex < objCount;
         objIndex++) {
      if (objectStores[objIndex].metadata().name() == name) {
        found = true;
        break;
      }
    }

    if (!found) {
      return NS_ERROR_DOM_INDEXEDDB_NOT_FOUND_ERR;
    }

    sortedStoreNames.InsertElementSorted(name);
  }

  // Remove any duplicates.
  for (uint32_t nameIndex = nameCount - 1; nameIndex > 0; nameIndex--) {
    if (sortedStoreNames[nameIndex] == sortedStoreNames[nameIndex - 1]) {
      sortedStoreNames.RemoveElementAt(nameIndex);
    }
  }

  IDBTransaction::Mode mode;
  switch (aMode) {
    case IDBTransactionMode::Readonly:
      mode = IDBTransaction::READ_ONLY;
      break;
    case IDBTransactionMode::Readwrite:
      if (mQuotaExceeded) {
        mode = IDBTransaction::CLEANUP;
        mQuotaExceeded = false;
      } else {
        mode = IDBTransaction::READ_WRITE;
      }
      break;
    case IDBTransactionMode::Readwriteflush:
      mode = IDBTransaction::READ_WRITE_FLUSH;
      break;
    case IDBTransactionMode::Cleanup:
      mode = IDBTransaction::CLEANUP;
      mQuotaExceeded = false;
      break;
    case IDBTransactionMode::Versionchange:
      return NS_ERROR_DOM_TYPE_ERR;

    default:
      MOZ_CRASH("Unknown mode!");
  }

  RefPtr<IDBTransaction> transaction =
    IDBTransaction::Create(aCx, this, sortedStoreNames, mode);
  if (NS_WARN_IF(!transaction)) {
    IDB_REPORT_INTERNAL_ERR();
    return NS_ERROR_DOM_INDEXEDDB_UNKNOWN_ERR;
  }

  BackgroundTransactionChild* actor =
    new BackgroundTransactionChild(transaction);

  IDB_LOG_MARK("IndexedDB %s: Child  Transaction[%lld]: "
                 "database(%s).transaction(%s)",
               "IndexedDB %s: C T[%lld]: IDBDatabase.transaction()",
               IDB_LOG_ID_STRING(),
               transaction->LoggingSerialNumber(),
               IDB_LOG_STRINGIFY(this),
               IDB_LOG_STRINGIFY(transaction));

  MOZ_ALWAYS_TRUE(
    mBackgroundActor->SendPBackgroundIDBTransactionConstructor(actor,
                                                               sortedStoreNames,
                                                               mode));
  MOZ_ASSERT(actor->GetActorEventTarget(),
    "The event target shall be inherited from it manager actor.");

  transaction->SetBackgroundActor(actor);

  if (mode == IDBTransaction::CLEANUP) {
    ExpireFileActors(/* aExpireAll */ true);
  }

  transaction.forget(aTransaction);
  return NS_OK;
}

StorageType
IDBDatabase::Storage() const
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(mSpec);

  return PersistenceTypeToStorage(mSpec->metadata().persistenceType());
}

already_AddRefed<IDBRequest>
IDBDatabase::CreateMutableFile(JSContext* aCx,
                               const nsAString& aName,
                               const Optional<nsAString>& aType,
                               ErrorResult& aRv)
{
  AssertIsOnOwningThread();

  if (QuotaManager::IsShuttingDown()) {
    IDB_REPORT_INTERNAL_ERR();
    aRv.Throw(NS_ERROR_DOM_INDEXEDDB_UNKNOWN_ERR);
    return nullptr;
  }

  if (mClosed || mFileHandleDisabled) {
    aRv.Throw(NS_ERROR_DOM_INDEXEDDB_NOT_ALLOWED_ERR);
    return nullptr;
  }

  nsString type;
  if (aType.WasPassed()) {
    type = aType.Value();
  }

  CreateFileParams params(nsString(aName), type);

  RefPtr<IDBRequest> request = IDBRequest::Create(aCx, this, nullptr);
  MOZ_ASSERT(request);

  BackgroundDatabaseRequestChild* actor =
    new BackgroundDatabaseRequestChild(this, request);

  IDB_LOG_MARK("IndexedDB %s: Child  Request[%llu]: "
                 "database(%s).createMutableFile(%s)",
               "IndexedDB %s: C R[%llu]: IDBDatabase.createMutableFile()",
               IDB_LOG_ID_STRING(),
               request->LoggingSerialNumber(),
               IDB_LOG_STRINGIFY(this),
               NS_ConvertUTF16toUTF8(aName).get());

  mBackgroundActor->SendPBackgroundIDBDatabaseRequestConstructor(actor, params);

  MOZ_ASSERT(actor->GetActorEventTarget(),
    "The event target shall be inherited from its manager actor.");

  return request.forget();
}

void
IDBDatabase::RegisterTransaction(IDBTransaction* aTransaction)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(aTransaction);
  aTransaction->AssertIsOnOwningThread();
  MOZ_ASSERT(!mTransactions.Contains(aTransaction));

  mTransactions.PutEntry(aTransaction);
}

void
IDBDatabase::UnregisterTransaction(IDBTransaction* aTransaction)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(aTransaction);
  aTransaction->AssertIsOnOwningThread();
  MOZ_ASSERT(mTransactions.Contains(aTransaction));

  mTransactions.RemoveEntry(aTransaction);
}

void
IDBDatabase::AbortTransactions(bool aShouldWarn)
{
  AssertIsOnOwningThread();

  class MOZ_STACK_CLASS Helper final
  {
    typedef AutoTArray<RefPtr<IDBTransaction>, 20> StrongTransactionArray;
    typedef AutoTArray<IDBTransaction*, 20> WeakTransactionArray;

  public:
    static void
    AbortTransactions(IDBDatabase* aDatabase, const bool aShouldWarn)
    {
      MOZ_ASSERT(aDatabase);
      aDatabase->AssertIsOnOwningThread();

      nsTHashtable<nsPtrHashKey<IDBTransaction>>& transactionTable =
        aDatabase->mTransactions;

      if (!transactionTable.Count()) {
        return;
      }

      StrongTransactionArray transactionsToAbort;
      transactionsToAbort.SetCapacity(transactionTable.Count());

      for (auto iter = transactionTable.Iter(); !iter.Done(); iter.Next()) {
        IDBTransaction* transaction = iter.Get()->GetKey();
        MOZ_ASSERT(transaction);

        transaction->AssertIsOnOwningThread();

        // Transactions that are already done can simply be ignored. Otherwise
        // there is a race here and it's possible that the transaction has not
        // been successfully committed yet so we will warn the user.
        if (!transaction->IsDone()) {
          transactionsToAbort.AppendElement(transaction);
        }
      }
      MOZ_ASSERT(transactionsToAbort.Length() <= transactionTable.Count());

      if (transactionsToAbort.IsEmpty()) {
        return;
      }

      // We want to abort transactions as soon as possible so we iterate the
      // transactions once and abort them all first, collecting the transactions
      // that need to have a warning issued along the way. Those that need a
      // warning will be a subset of those that are aborted, so we don't need
      // additional strong references here.
      WeakTransactionArray transactionsThatNeedWarning;

      for (RefPtr<IDBTransaction>& transaction : transactionsToAbort) {
        MOZ_ASSERT(transaction);
        MOZ_ASSERT(!transaction->IsDone());

        if (aShouldWarn) {
          switch (transaction->GetMode()) {
            // We ignore transactions that could not have written any data.
            case IDBTransaction::READ_ONLY:
              break;

            // We warn for any transactions that could have written data.
            case IDBTransaction::READ_WRITE:
            case IDBTransaction::READ_WRITE_FLUSH:
            case IDBTransaction::CLEANUP:
            case IDBTransaction::VERSION_CHANGE:
              transactionsThatNeedWarning.AppendElement(transaction);
              break;

            default:
              MOZ_CRASH("Unknown mode!");
          }
        }

        transaction->Abort(NS_ERROR_DOM_INDEXEDDB_ABORT_ERR);
      }

      static const char kWarningMessage[] =
        "IndexedDBTransactionAbortNavigation";

      for (IDBTransaction* transaction : transactionsThatNeedWarning) {
        MOZ_ASSERT(transaction);

        nsString filename;
        uint32_t lineNo, column;
        transaction->GetCallerLocation(filename, &lineNo, &column);

        aDatabase->LogWarning(kWarningMessage, filename, lineNo, column);
      }
    }
  };

  Helper::AbortTransactions(this, aShouldWarn);
}

PBackgroundIDBDatabaseFileChild*
IDBDatabase::GetOrCreateFileActorForBlob(Blob* aBlob)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(aBlob);
  MOZ_ASSERT(mBackgroundActor);

  // We use the File's nsIWeakReference as the key to the table because
  // a) it is unique per blob, b) it is reference-counted so that we can
  // guarantee that it stays alive, and c) it doesn't hold the actual File
  // alive.
  nsCOMPtr<nsIDOMBlob> blob = aBlob;
  nsCOMPtr<nsIWeakReference> weakRef = do_GetWeakReference(blob);
  MOZ_ASSERT(weakRef);

  PBackgroundIDBDatabaseFileChild* actor = nullptr;

  if (!mFileActors.Get(weakRef, &actor)) {
    BlobImpl* blobImpl = aBlob->Impl();
    MOZ_ASSERT(blobImpl);

    PBackgroundChild* backgroundManager =
      mBackgroundActor->Manager()->Manager();
    MOZ_ASSERT(backgroundManager);

    IPCBlob ipcBlob;
    nsresult rv = IPCBlobUtils::Serialize(blobImpl, backgroundManager, ipcBlob);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return nullptr;
    }

    auto* dbFile = new DatabaseFile(this);

    actor =
      mBackgroundActor->SendPBackgroundIDBDatabaseFileConstructor(dbFile,
                                                                  ipcBlob);
    if (NS_WARN_IF(!actor)) {
      return nullptr;
    }

    MOZ_ASSERT(actor->GetActorEventTarget(),
     "The event target shall be inherited from its manager actor.");
    mFileActors.Put(weakRef, actor);
  }

  MOZ_ASSERT(actor);

  return actor;
}

void
IDBDatabase::NoteFinishedFileActor(PBackgroundIDBDatabaseFileChild* aFileActor)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(aFileActor);

  for (auto iter = mFileActors.Iter(); !iter.Done(); iter.Next()) {
    MOZ_ASSERT(iter.Key());
    PBackgroundIDBDatabaseFileChild* actor = iter.Data();
    MOZ_ASSERT(actor);

    if (actor == aFileActor) {
      iter.Remove();
    }
  }
}

void
IDBDatabase::DelayedMaybeExpireFileActors()
{
  AssertIsOnOwningThread();

  if (!mBackgroundActor || !mFileActors.Count()) {
    return;
  }

  RefPtr<Runnable> runnable =
    NewRunnableMethod<bool>("IDBDatabase::ExpireFileActors",
                            this,
                            &IDBDatabase::ExpireFileActors,
                            /* aExpireAll */ false);
  MOZ_ASSERT(runnable);

  if (!NS_IsMainThread()) {
    // Wrap as a nsICancelableRunnable to make workers happy.
    RefPtr<Runnable> cancelable = new CancelableRunnableWrapper(runnable);
    cancelable.swap(runnable);
  }

  MOZ_ALWAYS_SUCCEEDS(
    EventTarget()->Dispatch(runnable.forget(), NS_DISPATCH_NORMAL));
}

nsresult
IDBDatabase::GetQuotaInfo(nsACString& aOrigin,
                          PersistenceType* aPersistenceType)
{
  using mozilla::dom::quota::QuotaManager;

  MOZ_ASSERT(NS_IsMainThread(), "This can't work off the main thread!");

  if (aPersistenceType) {
    *aPersistenceType = mSpec->metadata().persistenceType();
    MOZ_ASSERT(*aPersistenceType != PERSISTENCE_TYPE_INVALID);
  }

  PrincipalInfo* principalInfo = mFactory->GetPrincipalInfo();
  MOZ_ASSERT(principalInfo);

  switch (principalInfo->type()) {
    case PrincipalInfo::TNullPrincipalInfo:
      MOZ_CRASH("Is this needed?!");

    case PrincipalInfo::TSystemPrincipalInfo:
      QuotaManager::GetInfoForChrome(nullptr, nullptr, &aOrigin);
      return NS_OK;

    case PrincipalInfo::TContentPrincipalInfo: {
      nsresult rv;
      nsCOMPtr<nsIPrincipal> principal =
        PrincipalInfoToPrincipal(*principalInfo, &rv);
      if (NS_WARN_IF(NS_FAILED(rv))) {
        return rv;
      }

      rv = QuotaManager::GetInfoFromPrincipal(principal,
                                              nullptr,
                                              nullptr,
                                              &aOrigin);
      if (NS_WARN_IF(NS_FAILED(rv))) {
        return rv;
      }

      return NS_OK;
    }

    default:
      MOZ_CRASH("Unknown PrincipalInfo type!");
  }

  MOZ_CRASH("Should never get here!");
}

void
IDBDatabase::ExpireFileActors(bool aExpireAll)
{
  AssertIsOnOwningThread();

  if (mBackgroundActor && mFileActors.Count()) {
    for (auto iter = mFileActors.Iter(); !iter.Done(); iter.Next()) {
      nsISupports* key = iter.Key();
      PBackgroundIDBDatabaseFileChild* actor = iter.Data();
      MOZ_ASSERT(key);
      MOZ_ASSERT(actor);

      bool shouldExpire = aExpireAll;
      if (!shouldExpire) {
        nsCOMPtr<nsIWeakReference> weakRef = do_QueryInterface(key);
        MOZ_ASSERT(weakRef);

        nsCOMPtr<nsISupports> referent = do_QueryReferent(weakRef);
        shouldExpire = !referent;
      }

      if (shouldExpire) {
        PBackgroundIDBDatabaseFileChild::Send__delete__(actor);

        if (!aExpireAll) {
          iter.Remove();
        }
      }
    }
    if (aExpireAll) {
      mFileActors.Clear();
    }
  } else {
    MOZ_ASSERT(!mFileActors.Count());
  }
}

void
IDBDatabase::NoteLiveMutableFile(IDBMutableFile* aMutableFile)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(aMutableFile);
  aMutableFile->AssertIsOnOwningThread();
  MOZ_ASSERT(!mLiveMutableFiles.Contains(aMutableFile));

  mLiveMutableFiles.AppendElement(aMutableFile);
}

void
IDBDatabase::NoteFinishedMutableFile(IDBMutableFile* aMutableFile)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(aMutableFile);
  aMutableFile->AssertIsOnOwningThread();

  // It's ok if this is called after we cleared the array, so don't assert that
  // aMutableFile is in the list.

  mLiveMutableFiles.RemoveElement(aMutableFile);
}

void
IDBDatabase::InvalidateMutableFiles()
{
  AssertIsOnOwningThread();

  if (!mLiveMutableFiles.IsEmpty()) {
    for (uint32_t count = mLiveMutableFiles.Length(), index = 0;
         index < count;
         index++) {
      mLiveMutableFiles[index]->Invalidate();
    }

    mLiveMutableFiles.Clear();
  }
}

void
IDBDatabase::Invalidate()
{
  AssertIsOnOwningThread();

  if (!mInvalidated) {
    mInvalidated = true;

    InvalidateInternal();
  }
}

void
IDBDatabase::LogWarning(const char* aMessageName,
                        const nsAString& aFilename,
                        uint32_t aLineNumber,
                        uint32_t aColumnNumber)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(aMessageName);

  ScriptErrorHelper::DumpLocalizedMessage(nsDependentCString(aMessageName),
                                          aFilename,
                                          aLineNumber,
                                          aColumnNumber,
                                          nsIScriptError::warningFlag,
                                          mFactory->IsChrome(),
                                          mFactory->InnerWindowID());
}

NS_IMPL_ADDREF_INHERITED(IDBDatabase, IDBWrapperCache)
NS_IMPL_RELEASE_INHERITED(IDBDatabase, IDBWrapperCache)

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION_INHERITED(IDBDatabase)
NS_INTERFACE_MAP_END_INHERITING(IDBWrapperCache)

NS_IMPL_CYCLE_COLLECTION_CLASS(IDBDatabase)

NS_IMPL_CYCLE_COLLECTION_TRAVERSE_BEGIN_INHERITED(IDBDatabase, IDBWrapperCache)
  tmp->AssertIsOnOwningThread();
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mFactory)
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_END

NS_IMPL_CYCLE_COLLECTION_UNLINK_BEGIN_INHERITED(IDBDatabase, IDBWrapperCache)
  tmp->AssertIsOnOwningThread();

  // Don't unlink mFactory!

  // We've been unlinked, at the very least we should be able to prevent further
  // transactions from starting and unblock any other SetVersion callers.
  tmp->CloseInternal();
NS_IMPL_CYCLE_COLLECTION_UNLINK_END

void
IDBDatabase::LastRelease()
{
  AssertIsOnOwningThread();

  CloseInternal();

  if (mBackgroundActor) {
    mBackgroundActor->SendDeleteMeInternal();
    MOZ_ASSERT(!mBackgroundActor, "SendDeleteMeInternal should have cleared!");
  }
}

nsresult
IDBDatabase::PostHandleEvent(EventChainPostVisitor& aVisitor)
{
  nsresult rv =
    IndexedDatabaseManager::CommonPostHandleEvent(aVisitor, mFactory);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  return NS_OK;
}

JSObject*
IDBDatabase::WrapObject(JSContext* aCx, JS::Handle<JSObject*> aGivenProto)
{
  return IDBDatabaseBinding::Wrap(aCx, this, aGivenProto);
}

NS_IMETHODIMP
CancelableRunnableWrapper::Run()
{
  nsCOMPtr<nsIRunnable> runnable;
  mRunnable.swap(runnable);

  if (runnable) {
    return runnable->Run();
  }

  return NS_OK;
}

nsresult
CancelableRunnableWrapper::Cancel()
{
  if (mRunnable) {
    mRunnable = nullptr;
    return NS_OK;
  }

  return NS_ERROR_UNEXPECTED;
}

NS_IMPL_ISUPPORTS(IDBDatabase::Observer, nsIObserver)

NS_IMETHODIMP
IDBDatabase::
Observer::Observe(nsISupports* aSubject,
                  const char* aTopic,
                  const char16_t* aData)
{
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(aTopic);

  if (!strcmp(aTopic, kWindowObserverTopic)) {
    if (mWeakDatabase) {
      nsCOMPtr<nsISupportsPRUint64> supportsInt = do_QueryInterface(aSubject);
      MOZ_ASSERT(supportsInt);

      uint64_t windowId;
      MOZ_ALWAYS_SUCCEEDS(supportsInt->GetData(&windowId));

      if (windowId == mWindowId) {
        RefPtr<IDBDatabase> database = mWeakDatabase;
        mWeakDatabase = nullptr;

        database->InvalidateInternal();
      }
    }

    return NS_OK;
  }

  if (!strcmp(aTopic, kCycleCollectionObserverTopic) ||
      !strcmp(aTopic, kMemoryPressureObserverTopic)) {
    if (mWeakDatabase) {
      RefPtr<IDBDatabase> database = mWeakDatabase;

      database->ExpireFileActors(/* aExpireAll */ false);
    }

    return NS_OK;
  }

  NS_WARNING("Unknown observer topic!");
  return NS_OK;
}

nsresult
IDBDatabase::RenameObjectStore(int64_t aObjectStoreId, const nsAString& aName)
{
  MOZ_ASSERT(mSpec);

  nsTArray<ObjectStoreSpec>& objectStores = mSpec->objectStores();

  ObjectStoreSpec* foundObjectStoreSpec = nullptr;
  // Find the matched object store spec and check if 'aName' is already used by
  // another object store.
  for (uint32_t objCount = objectStores.Length(), objIndex = 0;
       objIndex < objCount;
       objIndex++) {
    const ObjectStoreSpec& objSpec = objectStores[objIndex];
    if (objSpec.metadata().id() == aObjectStoreId) {
      MOZ_ASSERT(!foundObjectStoreSpec);
      foundObjectStoreSpec = &objectStores[objIndex];
      continue;
    }
    if (aName == objSpec.metadata().name()) {
      return NS_ERROR_DOM_INDEXEDDB_CONSTRAINT_ERR;
    }
  }

  MOZ_ASSERT(foundObjectStoreSpec);

  // Update the name of the matched object store.
  foundObjectStoreSpec->metadata().name() = nsString(aName);

  return NS_OK;
}

nsresult
IDBDatabase::RenameIndex(int64_t aObjectStoreId,
                         int64_t aIndexId,
                         const nsAString& aName)
{
  MOZ_ASSERT(mSpec);

  nsTArray<ObjectStoreSpec>& objectStores = mSpec->objectStores();

  ObjectStoreSpec* foundObjectStoreSpec = nullptr;
  // Find the matched index metadata and check if 'aName' is already used by
  // another index.
  for (uint32_t objCount = objectStores.Length(), objIndex = 0;
       objIndex < objCount;
       objIndex++) {
    const ObjectStoreSpec& objSpec = objectStores[objIndex];
    if (objSpec.metadata().id() == aObjectStoreId) {
      foundObjectStoreSpec = &objectStores[objIndex];
      break;
    }
  }

  MOZ_ASSERT(foundObjectStoreSpec);

  nsTArray<IndexMetadata>& indexes = foundObjectStoreSpec->indexes();
  IndexMetadata* foundIndexMetadata = nullptr;
  for (uint32_t idxCount = indexes.Length(), idxIndex = 0;
       idxIndex < idxCount;
       idxIndex++) {
    const IndexMetadata& metadata = indexes[idxIndex];
    if (metadata.id() == aIndexId) {
      MOZ_ASSERT(!foundIndexMetadata);
      foundIndexMetadata = &indexes[idxIndex];
      continue;
    }
    if (aName == metadata.name()) {
      return NS_ERROR_DOM_INDEXEDDB_CONSTRAINT_ERR;
    }
  }

  MOZ_ASSERT(foundIndexMetadata);

  // Update the name of the matched object store.
  foundIndexMetadata->name() = nsString(aName);

  return NS_OK;
}

} // namespace dom
} // namespace mozilla
