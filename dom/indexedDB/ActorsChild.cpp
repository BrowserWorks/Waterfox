/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "ActorsChild.h"

#include "BackgroundChildImpl.h"
#include "FileSnapshot.h"
#include "IDBDatabase.h"
#include "IDBEvents.h"
#include "IDBFactory.h"
#include "IDBFileHandle.h"
#include "IDBIndex.h"
#include "IDBMutableFile.h"
#include "IDBObjectStore.h"
#include "IDBRequest.h"
#include "IDBTransaction.h"
#include "IndexedDatabase.h"
#include "IndexedDatabaseInlines.h"
#include "mozilla/BasicEvents.h"
#include "mozilla/CycleCollectedJSRuntime.h"
#include "mozilla/Maybe.h"
#include "mozilla/TypeTraits.h"
#include "mozilla/dom/Element.h"
#include "mozilla/dom/PermissionMessageUtils.h"
#include "mozilla/dom/TabChild.h"
#include "mozilla/dom/indexedDB/PBackgroundIDBDatabaseFileChild.h"
#include "mozilla/dom/indexedDB/PIndexedDBPermissionRequestChild.h"
#include "mozilla/dom/ipc/PendingIPCBlobChild.h"
#include "mozilla/dom/IPCBlobUtils.h"
#include "mozilla/Encoding.h"
#include "mozilla/ipc/BackgroundUtils.h"
#include "mozilla/TaskQueue.h"
#include "nsCOMPtr.h"
#include "nsContentUtils.h"
#include "nsIAsyncInputStream.h"
#include "nsIBFCacheEntry.h"
#include "nsIDocument.h"
#include "nsIDOMEvent.h"
#include "nsIEventTarget.h"
#include "nsIFileStreams.h"
#include "nsNetCID.h"
#include "nsPIDOMWindow.h"
#include "nsThreadUtils.h"
#include "nsTraceRefcnt.h"
#include "PermissionRequestBase.h"
#include "ProfilerHelpers.h"
#include "ReportInternalError.h"
#include "WorkerPrivate.h"
#include "WorkerRunnable.h"

#ifdef DEBUG
#include "IndexedDatabaseManager.h"
#endif

#define GC_ON_IPC_MESSAGES 0

#if defined(DEBUG) || GC_ON_IPC_MESSAGES

#include "js/GCAPI.h"
#include "nsJSEnvironment.h"

#define BUILD_GC_ON_IPC_MESSAGES

#endif // DEBUG || GC_ON_IPC_MESSAGES

namespace mozilla {

using ipc::PrincipalInfo;

namespace dom {

using namespace workers;

namespace indexedDB {

/*******************************************************************************
 * ThreadLocal
 ******************************************************************************/

ThreadLocal::ThreadLocal(const nsID& aBackgroundChildLoggingId)
  : mLoggingInfo(aBackgroundChildLoggingId, 1, -1, 1)
  , mCurrentTransaction(0)
{
  MOZ_COUNT_CTOR(mozilla::dom::indexedDB::ThreadLocal);

  // NSID_LENGTH counts the null terminator, SetLength() does not.
  mLoggingIdString.SetLength(NSID_LENGTH - 1);

  aBackgroundChildLoggingId.ToProvidedString(
    *reinterpret_cast<char(*)[NSID_LENGTH]>(mLoggingIdString.BeginWriting()));
}

ThreadLocal::~ThreadLocal()
{
  MOZ_COUNT_DTOR(mozilla::dom::indexedDB::ThreadLocal);
}

/*******************************************************************************
 * Helpers
 ******************************************************************************/

namespace {

void
MaybeCollectGarbageOnIPCMessage()
{
#ifdef BUILD_GC_ON_IPC_MESSAGES
  static const bool kCollectGarbageOnIPCMessages =
#if GC_ON_IPC_MESSAGES
    true;
#else
    false;
#endif // GC_ON_IPC_MESSAGES

  if (!kCollectGarbageOnIPCMessages) {
    return;
  }

  static bool haveWarnedAboutGC = false;
  static bool haveWarnedAboutNonMainThread = false;

  if (!haveWarnedAboutGC) {
    haveWarnedAboutGC = true;
    NS_WARNING("IndexedDB child actor GC debugging enabled!");
  }

  if (!NS_IsMainThread()) {
    if (!haveWarnedAboutNonMainThread)  {
      haveWarnedAboutNonMainThread = true;
      NS_WARNING("Don't know how to GC on a non-main thread yet.");
    }
    return;
  }

  nsJSContext::GarbageCollectNow(JS::gcreason::DOM_IPC);
  nsJSContext::CycleCollectNow();
#endif // BUILD_GC_ON_IPC_MESSAGES
}

class MOZ_STACK_CLASS AutoSetCurrentTransaction final
{
  typedef mozilla::ipc::BackgroundChildImpl BackgroundChildImpl;

  IDBTransaction* const mTransaction;
  IDBTransaction* mPreviousTransaction;
  ThreadLocal* mThreadLocal;

public:
  explicit AutoSetCurrentTransaction(IDBTransaction* aTransaction)
    : mTransaction(aTransaction)
    , mPreviousTransaction(nullptr)
    , mThreadLocal(nullptr)
  {
    if (aTransaction) {
      BackgroundChildImpl::ThreadLocal* threadLocal =
        BackgroundChildImpl::GetThreadLocalForCurrentThread();
      MOZ_ASSERT(threadLocal);

      // Hang onto this for resetting later.
      mThreadLocal = threadLocal->mIndexedDBThreadLocal;
      MOZ_ASSERT(mThreadLocal);

      // Save the current value.
      mPreviousTransaction = mThreadLocal->GetCurrentTransaction();

      // Set the new value.
      mThreadLocal->SetCurrentTransaction(aTransaction);
    }
  }

  ~AutoSetCurrentTransaction()
  {
    MOZ_ASSERT_IF(mThreadLocal, mTransaction);
    MOZ_ASSERT_IF(mThreadLocal,
                  mThreadLocal->GetCurrentTransaction() == mTransaction);

    if (mThreadLocal) {
      // Reset old value.
      mThreadLocal->SetCurrentTransaction(mPreviousTransaction);
    }
  }

  IDBTransaction*
  Transaction() const
  {
    return mTransaction;
  }
};

class MOZ_STACK_CLASS ResultHelper final
  : public IDBRequest::ResultCallback
{
  IDBRequest* mRequest;
  AutoSetCurrentTransaction mAutoTransaction;

  union
  {
    IDBDatabase* mDatabase;
    IDBCursor* mCursor;
    IDBMutableFile* mMutableFile;
    StructuredCloneReadInfo* mStructuredClone;
    const nsTArray<StructuredCloneReadInfo>* mStructuredCloneArray;
    const Key* mKey;
    const nsTArray<Key>* mKeyArray;
    const JS::Value* mJSVal;
    const JS::Handle<JS::Value>* mJSValHandle;
  } mResult;

  enum
  {
    ResultTypeDatabase,
    ResultTypeCursor,
    ResultTypeMutableFile,
    ResultTypeStructuredClone,
    ResultTypeStructuredCloneArray,
    ResultTypeKey,
    ResultTypeKeyArray,
    ResultTypeJSVal,
    ResultTypeJSValHandle,
  } mResultType;

public:
  ResultHelper(IDBRequest* aRequest,
               IDBTransaction* aTransaction,
               IDBDatabase* aResult)
    : mRequest(aRequest)
    , mAutoTransaction(aTransaction)
    , mResultType(ResultTypeDatabase)
  {
    MOZ_ASSERT(aRequest);
    MOZ_ASSERT(aResult);

    mResult.mDatabase = aResult;
  }

  ResultHelper(IDBRequest* aRequest,
               IDBTransaction* aTransaction,
               IDBCursor* aResult)
    : mRequest(aRequest)
    , mAutoTransaction(aTransaction)
    , mResultType(ResultTypeCursor)
  {
    MOZ_ASSERT(aRequest);

    mResult.mCursor = aResult;
  }

  ResultHelper(IDBRequest* aRequest,
               IDBTransaction* aTransaction,
               IDBMutableFile* aResult)
    : mRequest(aRequest)
    , mAutoTransaction(aTransaction)
    , mResultType(ResultTypeMutableFile)
  {
    MOZ_ASSERT(aRequest);

    mResult.mMutableFile = aResult;
  }

  ResultHelper(IDBRequest* aRequest,
               IDBTransaction* aTransaction,
               StructuredCloneReadInfo* aResult)
    : mRequest(aRequest)
    , mAutoTransaction(aTransaction)
    , mResultType(ResultTypeStructuredClone)
  {
    MOZ_ASSERT(aRequest);
    MOZ_ASSERT(aResult);

    mResult.mStructuredClone = aResult;
  }

  ResultHelper(IDBRequest* aRequest,
               IDBTransaction* aTransaction,
               const nsTArray<StructuredCloneReadInfo>* aResult)
    : mRequest(aRequest)
    , mAutoTransaction(aTransaction)
    , mResultType(ResultTypeStructuredCloneArray)
  {
    MOZ_ASSERT(aRequest);
    MOZ_ASSERT(aResult);

    mResult.mStructuredCloneArray = aResult;
  }

  ResultHelper(IDBRequest* aRequest,
               IDBTransaction* aTransaction,
               const Key* aResult)
    : mRequest(aRequest)
    , mAutoTransaction(aTransaction)
    , mResultType(ResultTypeKey)
  {
    MOZ_ASSERT(aRequest);
    MOZ_ASSERT(aResult);

    mResult.mKey = aResult;
  }

  ResultHelper(IDBRequest* aRequest,
               IDBTransaction* aTransaction,
               const nsTArray<Key>* aResult)
    : mRequest(aRequest)
    , mAutoTransaction(aTransaction)
    , mResultType(ResultTypeKeyArray)
  {
    MOZ_ASSERT(aRequest);
    MOZ_ASSERT(aResult);

    mResult.mKeyArray = aResult;
  }

  ResultHelper(IDBRequest* aRequest,
               IDBTransaction* aTransaction,
               const JS::Value* aResult)
    : mRequest(aRequest)
    , mAutoTransaction(aTransaction)
    , mResultType(ResultTypeJSVal)
  {
    MOZ_ASSERT(aRequest);
    MOZ_ASSERT(!aResult->isGCThing());

    mResult.mJSVal = aResult;
  }

  ResultHelper(IDBRequest* aRequest,
               IDBTransaction* aTransaction,
               const JS::Handle<JS::Value>* aResult)
    : mRequest(aRequest)
    , mAutoTransaction(aTransaction)
    , mResultType(ResultTypeJSValHandle)
  {
    MOZ_ASSERT(aRequest);

    mResult.mJSValHandle = aResult;
  }

  IDBRequest*
  Request() const
  {
    return mRequest;
  }

  IDBTransaction*
  Transaction() const
  {
    return mAutoTransaction.Transaction();
  }

  virtual nsresult
  GetResult(JSContext* aCx, JS::MutableHandle<JS::Value> aResult) override
  {
    MOZ_ASSERT(aCx);
    MOZ_ASSERT(mRequest);

    switch (mResultType) {
      case ResultTypeDatabase:
        return GetResult(aCx, mResult.mDatabase, aResult);

      case ResultTypeCursor:
        return GetResult(aCx, mResult.mCursor, aResult);

      case ResultTypeMutableFile:
        return GetResult(aCx, mResult.mMutableFile, aResult);

      case ResultTypeStructuredClone:
        return GetResult(aCx, mResult.mStructuredClone, aResult);

      case ResultTypeStructuredCloneArray:
        return GetResult(aCx, mResult.mStructuredCloneArray, aResult);

      case ResultTypeKey:
        return GetResult(aCx, mResult.mKey, aResult);

      case ResultTypeKeyArray:
        return GetResult(aCx, mResult.mKeyArray, aResult);

      case ResultTypeJSVal:
        aResult.set(*mResult.mJSVal);
        return NS_OK;

      case ResultTypeJSValHandle:
        aResult.set(*mResult.mJSValHandle);
        return NS_OK;

      default:
        MOZ_CRASH("Unknown result type!");
    }

    MOZ_CRASH("Should never get here!");
  }

private:
  template <class T>
  typename EnableIf<IsSame<T, IDBDatabase>::value ||
                    IsSame<T, IDBCursor>::value ||
                    IsSame<T, IDBMutableFile>::value,
                    nsresult>::Type
  GetResult(JSContext* aCx,
            T* aDOMObject,
            JS::MutableHandle<JS::Value> aResult)
  {
    if (!aDOMObject) {
      aResult.setNull();
      return NS_OK;
    }

    bool ok = GetOrCreateDOMReflector(aCx, aDOMObject, aResult);
    if (NS_WARN_IF(!ok)) {
      IDB_REPORT_INTERNAL_ERR();
      return NS_ERROR_DOM_INDEXEDDB_UNKNOWN_ERR;
    }

    return NS_OK;
  }

  nsresult
  GetResult(JSContext* aCx,
            StructuredCloneReadInfo* aCloneInfo,
            JS::MutableHandle<JS::Value> aResult)
  {
    bool ok = IDBObjectStore::DeserializeValue(aCx, *aCloneInfo, aResult);

    if (NS_WARN_IF(!ok)) {
      return NS_ERROR_DOM_DATA_CLONE_ERR;
    }

    return NS_OK;
  }

  nsresult
  GetResult(JSContext* aCx,
            const nsTArray<StructuredCloneReadInfo>* aCloneInfos,
            JS::MutableHandle<JS::Value> aResult)
  {
    JS::Rooted<JSObject*> array(aCx, JS_NewArrayObject(aCx, 0));
    if (NS_WARN_IF(!array)) {
      IDB_REPORT_INTERNAL_ERR();
      return NS_ERROR_DOM_INDEXEDDB_UNKNOWN_ERR;
    }

    if (!aCloneInfos->IsEmpty()) {
      const uint32_t count = aCloneInfos->Length();

      if (NS_WARN_IF(!JS_SetArrayLength(aCx, array, count))) {
        IDB_REPORT_INTERNAL_ERR();
        return NS_ERROR_DOM_INDEXEDDB_UNKNOWN_ERR;
      }

      for (uint32_t index = 0; index < count; index++) {
        auto& cloneInfo =
          const_cast<StructuredCloneReadInfo&>(aCloneInfos->ElementAt(index));

        JS::Rooted<JS::Value> value(aCx);

        nsresult rv = GetResult(aCx, &cloneInfo, &value);
        if (NS_WARN_IF(NS_FAILED(rv))) {
          return rv;
        }

        if (NS_WARN_IF(!JS_DefineElement(aCx, array, index, value,
                                         JSPROP_ENUMERATE))) {
          IDB_REPORT_INTERNAL_ERR();
          return NS_ERROR_DOM_INDEXEDDB_UNKNOWN_ERR;
        }
      }
    }

    aResult.setObject(*array);
    return NS_OK;
  }

  nsresult
  GetResult(JSContext* aCx,
            const Key* aKey,
            JS::MutableHandle<JS::Value> aResult)
  {
    nsresult rv = aKey->ToJSVal(aCx, aResult);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return rv;
    }
    return NS_OK;
  }

  nsresult
  GetResult(JSContext* aCx,
            const nsTArray<Key>* aKeys,
            JS::MutableHandle<JS::Value> aResult)
  {
    JS::Rooted<JSObject*> array(aCx, JS_NewArrayObject(aCx, 0));
    if (NS_WARN_IF(!array)) {
      IDB_REPORT_INTERNAL_ERR();
      return NS_ERROR_DOM_INDEXEDDB_UNKNOWN_ERR;
    }

    if (!aKeys->IsEmpty()) {
      const uint32_t count = aKeys->Length();

      if (NS_WARN_IF(!JS_SetArrayLength(aCx, array, count))) {
        IDB_REPORT_INTERNAL_ERR();
        return NS_ERROR_DOM_INDEXEDDB_UNKNOWN_ERR;
      }

      for (uint32_t index = 0; index < count; index++) {
        const Key& key = aKeys->ElementAt(index);
        MOZ_ASSERT(!key.IsUnset());

        JS::Rooted<JS::Value> value(aCx);

        nsresult rv = GetResult(aCx, &key, &value);
        if (NS_WARN_IF(NS_FAILED(rv))) {
          return rv;
        }

        if (NS_WARN_IF(!JS_DefineElement(aCx, array, index, value,
                                         JSPROP_ENUMERATE))) {
          IDB_REPORT_INTERNAL_ERR();
          return NS_ERROR_DOM_INDEXEDDB_UNKNOWN_ERR;
        }
      }
    }

    aResult.setObject(*array);
    return NS_OK;
  }
};

class PermissionRequestMainProcessHelper final
  : public PermissionRequestBase
{
  BackgroundFactoryRequestChild* mActor;
  RefPtr<IDBFactory> mFactory;

public:
  PermissionRequestMainProcessHelper(BackgroundFactoryRequestChild* aActor,
                                     IDBFactory* aFactory,
                                     Element* aOwnerElement,
                                     nsIPrincipal* aPrincipal)
    : PermissionRequestBase(aOwnerElement, aPrincipal)
    , mActor(aActor)
    , mFactory(aFactory)
  {
    MOZ_ASSERT(aActor);
    MOZ_ASSERT(aFactory);
    aActor->AssertIsOnOwningThread();
  }

protected:
  ~PermissionRequestMainProcessHelper()
  { }

private:
  virtual void
  OnPromptComplete(PermissionValue aPermissionValue) override;
};

class PermissionRequestChildProcessActor final
  : public PIndexedDBPermissionRequestChild
{
  BackgroundFactoryRequestChild* mActor;
  RefPtr<IDBFactory> mFactory;

public:
  PermissionRequestChildProcessActor(BackgroundFactoryRequestChild* aActor,
                                     IDBFactory* aFactory)
    : mActor(aActor)
    , mFactory(aFactory)
  {
    MOZ_ASSERT(aActor);
    MOZ_ASSERT(aFactory);
    aActor->AssertIsOnOwningThread();
  }

protected:
  ~PermissionRequestChildProcessActor()
  { }

  virtual mozilla::ipc::IPCResult
  Recv__delete__(const uint32_t& aPermission) override;
};

void
DeserializeStructuredCloneFiles(
                IDBDatabase* aDatabase,
                const nsTArray<SerializedStructuredCloneFile>& aSerializedFiles,
                const nsTArray<RefPtr<JS::WasmModule>>* aModuleSet,
                nsTArray<StructuredCloneFile>& aFiles)
{
  MOZ_ASSERT_IF(aModuleSet, !aModuleSet->IsEmpty());
  MOZ_ASSERT(aFiles.IsEmpty());

  if (!aSerializedFiles.IsEmpty()) {
    uint32_t moduleIndex = 0;

    const uint32_t count = aSerializedFiles.Length();
    aFiles.SetCapacity(count);

    for (uint32_t index = 0; index < count; index++) {
      const SerializedStructuredCloneFile& serializedFile =
        aSerializedFiles[index];

      const BlobOrMutableFile& blobOrMutableFile = serializedFile.file();

      switch (serializedFile.type()) {
        case StructuredCloneFile::eBlob: {
          MOZ_ASSERT(blobOrMutableFile.type() == BlobOrMutableFile::TIPCBlob);

          const IPCBlob& ipcBlob = blobOrMutableFile.get_IPCBlob();

          RefPtr<BlobImpl> blobImpl = IPCBlobUtils::Deserialize(ipcBlob);
          MOZ_ASSERT(blobImpl);

          RefPtr<Blob> blob = Blob::Create(aDatabase->GetOwner(), blobImpl);

          StructuredCloneFile* file = aFiles.AppendElement();
          MOZ_ASSERT(file);

          file->mType = StructuredCloneFile::eBlob;
          file->mBlob.swap(blob);

          break;
        }

        case StructuredCloneFile::eMutableFile: {
          MOZ_ASSERT(blobOrMutableFile.type() == BlobOrMutableFile::Tnull_t ||
                     blobOrMutableFile.type() ==
                       BlobOrMutableFile::TPBackgroundMutableFileChild);

          switch (blobOrMutableFile.type()) {
            case BlobOrMutableFile::Tnull_t: {
              StructuredCloneFile* file = aFiles.AppendElement();
              MOZ_ASSERT(file);

              file->mType = StructuredCloneFile::eMutableFile;

              break;
            }

            case BlobOrMutableFile::TPBackgroundMutableFileChild: {
              auto* actor =
                static_cast<BackgroundMutableFileChild*>(
                  blobOrMutableFile.get_PBackgroundMutableFileChild());
              MOZ_ASSERT(actor);

              actor->EnsureDOMObject();

              auto* mutableFile =
                static_cast<IDBMutableFile*>(actor->GetDOMObject());
              MOZ_ASSERT(mutableFile);

              StructuredCloneFile* file = aFiles.AppendElement();
              MOZ_ASSERT(file);

              file->mType = StructuredCloneFile::eMutableFile;
              file->mMutableFile = mutableFile;

              actor->ReleaseDOMObject();

              break;
            }

            default:
              MOZ_CRASH("Should never get here!");
          }

          break;
        }

        case StructuredCloneFile::eStructuredClone: {
          StructuredCloneFile* file = aFiles.AppendElement();
          MOZ_ASSERT(file);

          file->mType = StructuredCloneFile::eStructuredClone;

          break;
        }

        case StructuredCloneFile::eWasmBytecode:
        case StructuredCloneFile::eWasmCompiled: {
          if (aModuleSet) {
            MOZ_ASSERT(blobOrMutableFile.type() == BlobOrMutableFile::Tnull_t);

            StructuredCloneFile* file = aFiles.AppendElement();
            MOZ_ASSERT(file);

            file->mType = serializedFile.type();

            MOZ_ASSERT(moduleIndex < aModuleSet->Length());
            file->mWasmModule = aModuleSet->ElementAt(moduleIndex);

            if (serializedFile.type() == StructuredCloneFile::eWasmCompiled) {
              moduleIndex++;
            }

            break;
          }

          MOZ_ASSERT(blobOrMutableFile.type() == BlobOrMutableFile::TIPCBlob);

          const IPCBlob& ipcBlob = blobOrMutableFile.get_IPCBlob();

          RefPtr<BlobImpl> blobImpl = IPCBlobUtils::Deserialize(ipcBlob);
          MOZ_ASSERT(blobImpl);

          RefPtr<Blob> blob = Blob::Create(aDatabase->GetOwner(), blobImpl);

          StructuredCloneFile* file = aFiles.AppendElement();
          MOZ_ASSERT(file);

          file->mType = serializedFile.type();
          file->mBlob.swap(blob);

          break;
        }

        default:
          MOZ_CRASH("Should never get here!");
      }
    }
  }
}

void
DispatchErrorEvent(IDBRequest* aRequest,
                   nsresult aErrorCode,
                   IDBTransaction* aTransaction = nullptr,
                   nsIDOMEvent* aEvent = nullptr)
{
  MOZ_ASSERT(aRequest);
  aRequest->AssertIsOnOwningThread();
  MOZ_ASSERT(NS_FAILED(aErrorCode));
  MOZ_ASSERT(NS_ERROR_GET_MODULE(aErrorCode) == NS_ERROR_MODULE_DOM_INDEXEDDB);

  AUTO_PROFILER_LABEL("IndexedDB:DispatchErrorEvent", STORAGE);

  RefPtr<IDBRequest> request = aRequest;
  RefPtr<IDBTransaction> transaction = aTransaction;

  request->SetError(aErrorCode);

  nsCOMPtr<nsIDOMEvent> errorEvent;
  if (!aEvent) {
    // Make an error event and fire it at the target.
    errorEvent = CreateGenericEvent(request,
                                    nsDependentString(kErrorEventType),
                                    eDoesBubble,
                                    eCancelable);
    MOZ_ASSERT(errorEvent);

    aEvent = errorEvent;
  }

  Maybe<AutoSetCurrentTransaction> asct;
  if (aTransaction) {
    asct.emplace(aTransaction);
  }

  if (transaction) {
    IDB_LOG_MARK("IndexedDB %s: Child  Transaction[%lld] Request[%llu]: "
                   "Firing %s event with error 0x%x",
                 "IndexedDB %s: C T[%lld] R[%llu]: %s (0x%x)",
                 IDB_LOG_ID_STRING(),
                 transaction->LoggingSerialNumber(),
                 request->LoggingSerialNumber(),
                 IDB_LOG_STRINGIFY(aEvent, kErrorEventType),
                 aErrorCode);
  } else {
    IDB_LOG_MARK("IndexedDB %s: Child  Request[%llu]: "
                   "Firing %s event with error 0x%x",
                 "IndexedDB %s: C R[%llu]: %s (0x%x)",
                 IDB_LOG_ID_STRING(),
                 request->LoggingSerialNumber(),
                 IDB_LOG_STRINGIFY(aEvent, kErrorEventType),
                 aErrorCode);
  }

  bool doDefault;
  nsresult rv = request->DispatchEvent(aEvent, &doDefault);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return;
  }

  MOZ_ASSERT(!transaction || transaction->IsOpen() || transaction->IsAborted());

  // Do not abort the transaction here if this request is failed due to the
  // abortion of its transaction to ensure that the correct error cause of
  // the abort event be set in IDBTransaction::FireCompleteOrAbortEvents() later.
  if (transaction && transaction->IsOpen() &&
      aErrorCode != NS_ERROR_DOM_INDEXEDDB_ABORT_ERR) {
    WidgetEvent* internalEvent = aEvent->WidgetEventPtr();
    MOZ_ASSERT(internalEvent);

    if (internalEvent->mFlags.mExceptionWasRaised) {
      transaction->Abort(NS_ERROR_DOM_INDEXEDDB_ABORT_ERR);
    } else if (doDefault) {
      transaction->Abort(request);
    }
  }
}

void
DispatchSuccessEvent(ResultHelper* aResultHelper,
                     nsIDOMEvent* aEvent = nullptr)
{
  MOZ_ASSERT(aResultHelper);

  AUTO_PROFILER_LABEL("IndexedDB:DispatchSuccessEvent", STORAGE);

  RefPtr<IDBRequest> request = aResultHelper->Request();
  MOZ_ASSERT(request);
  request->AssertIsOnOwningThread();

  RefPtr<IDBTransaction> transaction = aResultHelper->Transaction();

  if (transaction && transaction->IsAborted()) {
    DispatchErrorEvent(request, transaction->AbortCode(), transaction);
    return;
  }

  nsCOMPtr<nsIDOMEvent> successEvent;
  if (!aEvent) {
    successEvent = CreateGenericEvent(request,
                                      nsDependentString(kSuccessEventType),
                                      eDoesNotBubble,
                                      eNotCancelable);
    MOZ_ASSERT(successEvent);

    aEvent = successEvent;
  }

  request->SetResultCallback(aResultHelper);

  MOZ_ASSERT(aEvent);
  MOZ_ASSERT_IF(transaction, transaction->IsOpen());

  if (transaction) {
    IDB_LOG_MARK("IndexedDB %s: Child  Transaction[%lld] Request[%llu]: "
                   "Firing %s event",
                 "IndexedDB %s: C T[%lld] R[%llu]: %s",
                 IDB_LOG_ID_STRING(),
                 transaction->LoggingSerialNumber(),
                 request->LoggingSerialNumber(),
                 IDB_LOG_STRINGIFY(aEvent, kSuccessEventType));
  } else {
    IDB_LOG_MARK("IndexedDB %s: Child  Request[%llu]: Firing %s event",
                 "IndexedDB %s: C R[%llu]: %s",
                 IDB_LOG_ID_STRING(),
                 request->LoggingSerialNumber(),
                 IDB_LOG_STRINGIFY(aEvent, kSuccessEventType));
  }

  bool dummy;
  nsresult rv = request->DispatchEvent(aEvent, &dummy);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return;
  }

  MOZ_ASSERT_IF(transaction,
                transaction->IsOpen() || transaction->IsAborted());

  WidgetEvent* internalEvent = aEvent->WidgetEventPtr();
  MOZ_ASSERT(internalEvent);

  if (transaction &&
      transaction->IsOpen() &&
      internalEvent->mFlags.mExceptionWasRaised) {
    transaction->Abort(NS_ERROR_DOM_INDEXEDDB_ABORT_ERR);
  }
}

PRFileDesc*
GetFileDescriptorFromStream(nsIInputStream* aStream)
{
  MOZ_ASSERT(aStream);

  nsCOMPtr<nsIFileMetadata> fileMetadata = do_QueryInterface(aStream);
  if (NS_WARN_IF(!fileMetadata)) {
    return nullptr;
  }

  PRFileDesc* fileDesc;
  nsresult rv = fileMetadata->GetFileDescriptor(&fileDesc);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return nullptr;
  }

  MOZ_ASSERT(fileDesc);

  return fileDesc;
}

class WorkerPermissionChallenge;

// This class calles WorkerPermissionChallenge::OperationCompleted() in the
// worker thread.
class WorkerPermissionOperationCompleted final : public WorkerControlRunnable
{
  RefPtr<WorkerPermissionChallenge> mChallenge;

public:
  WorkerPermissionOperationCompleted(WorkerPrivate* aWorkerPrivate,
                                     WorkerPermissionChallenge* aChallenge)
    : WorkerControlRunnable(aWorkerPrivate, WorkerThreadUnchangedBusyCount)
    , mChallenge(aChallenge)
  {
    MOZ_ASSERT(NS_IsMainThread());
  }

  virtual bool
  WorkerRun(JSContext* aCx, WorkerPrivate* aWorkerPrivate) override;
};

// This class used to do prompting in the main thread and main process.
class WorkerPermissionRequest final : public PermissionRequestBase
{
  RefPtr<WorkerPermissionChallenge> mChallenge;

public:
  WorkerPermissionRequest(Element* aElement,
                          nsIPrincipal* aPrincipal,
                          WorkerPermissionChallenge* aChallenge)
    : PermissionRequestBase(aElement, aPrincipal)
    , mChallenge(aChallenge)
  {
    MOZ_ASSERT(XRE_IsParentProcess());
    MOZ_ASSERT(NS_IsMainThread());
    MOZ_ASSERT(aChallenge);
  }

private:
  ~WorkerPermissionRequest()
  {
    MOZ_ASSERT(NS_IsMainThread());
  }

  virtual void
  OnPromptComplete(PermissionValue aPermissionValue) override;
};

// This class is used in the main thread of all child processes.
class WorkerPermissionRequestChildProcessActor final
  : public PIndexedDBPermissionRequestChild
{
  RefPtr<WorkerPermissionChallenge> mChallenge;

public:
  explicit WorkerPermissionRequestChildProcessActor(
                                          WorkerPermissionChallenge* aChallenge)
    : mChallenge(aChallenge)
  {
    MOZ_ASSERT(!XRE_IsParentProcess());
    MOZ_ASSERT(NS_IsMainThread());
    MOZ_ASSERT(aChallenge);
  }

protected:
  ~WorkerPermissionRequestChildProcessActor()
  {}

  virtual mozilla::ipc::IPCResult
  Recv__delete__(const uint32_t& aPermission) override;
};

class WorkerPermissionChallenge final : public Runnable
{
public:
  WorkerPermissionChallenge(WorkerPrivate* aWorkerPrivate,
                            BackgroundFactoryRequestChild* aActor,
                            IDBFactory* aFactory,
                            const PrincipalInfo& aPrincipalInfo)
    : Runnable("indexedDB::WorkerPermissionChallenge")
    , mWorkerPrivate(aWorkerPrivate)
    , mActor(aActor)
    , mFactory(aFactory)
    , mPrincipalInfo(aPrincipalInfo)
  {
    MOZ_ASSERT(mWorkerPrivate);
    MOZ_ASSERT(aActor);
    MOZ_ASSERT(aFactory);
    mWorkerPrivate->AssertIsOnWorkerThread();
  }

  bool
  Dispatch()
  {
    mWorkerPrivate->AssertIsOnWorkerThread();
    if (NS_WARN_IF(!mWorkerPrivate->ModifyBusyCountFromWorker(true))) {
      return false;
    }

    if (NS_WARN_IF(NS_FAILED(mWorkerPrivate->DispatchToMainThread(this)))) {
      mWorkerPrivate->ModifyBusyCountFromWorker(false);
      return false;
    }

    return true;
  }

  NS_IMETHOD
  Run() override
  {
    bool completed = RunInternal();
    if (completed) {
      OperationCompleted();
    }

    return NS_OK;
  }

  void
  OperationCompleted()
  {
    if (NS_IsMainThread()) {
      RefPtr<WorkerPermissionOperationCompleted> runnable =
        new WorkerPermissionOperationCompleted(mWorkerPrivate, this);

      MOZ_ALWAYS_TRUE(runnable->Dispatch());
      return;
    }

    MOZ_ASSERT(mActor);
    mActor->AssertIsOnOwningThread();

    MaybeCollectGarbageOnIPCMessage();

    RefPtr<IDBFactory> factory;
    mFactory.swap(factory);

    mActor->SendPermissionRetry();
    mActor = nullptr;

    mWorkerPrivate->AssertIsOnWorkerThread();
    mWorkerPrivate->ModifyBusyCountFromWorker(false);
  }

private:
  bool
  RunInternal()
  {
    MOZ_ASSERT(NS_IsMainThread());

    // Walk up to our containing page
    WorkerPrivate* wp = mWorkerPrivate;
    while (wp->GetParent()) {
      wp = wp->GetParent();
    }

    nsPIDOMWindowInner* window = wp->GetWindow();
    if (!window) {
      return true;
    }

    nsresult rv;
    nsCOMPtr<nsIPrincipal> principal =
      mozilla::ipc::PrincipalInfoToPrincipal(mPrincipalInfo, &rv);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return true;
    }

    if (XRE_IsParentProcess()) {
      nsCOMPtr<Element> ownerElement =
        do_QueryInterface(window->GetChromeEventHandler());
      if (NS_WARN_IF(!ownerElement)) {
        return true;
      }

      RefPtr<WorkerPermissionRequest> helper =
        new WorkerPermissionRequest(ownerElement, principal, this);

      PermissionRequestBase::PermissionValue permission;
      if (NS_WARN_IF(NS_FAILED(helper->PromptIfNeeded(&permission)))) {
        return true;
      }

      MOZ_ASSERT(permission == PermissionRequestBase::kPermissionAllowed ||
                 permission == PermissionRequestBase::kPermissionDenied ||
                 permission == PermissionRequestBase::kPermissionPrompt);

      return permission != PermissionRequestBase::kPermissionPrompt;
    }

    TabChild* tabChild = TabChild::GetFrom(window);
    MOZ_ASSERT(tabChild);

    IPC::Principal ipcPrincipal(principal);

    auto* actor = new WorkerPermissionRequestChildProcessActor(this);
    tabChild->SetEventTargetForActor(actor, wp->MainThreadEventTarget());
    MOZ_ASSERT(actor->GetActorEventTarget());
    tabChild->SendPIndexedDBPermissionRequestConstructor(actor, ipcPrincipal);
    return false;
  }

private:
  WorkerPrivate* mWorkerPrivate;
  BackgroundFactoryRequestChild* mActor;
  RefPtr<IDBFactory> mFactory;
  PrincipalInfo mPrincipalInfo;
};

void
WorkerPermissionRequest::OnPromptComplete(PermissionValue aPermissionValue)
{
  MOZ_ASSERT(NS_IsMainThread());
  mChallenge->OperationCompleted();
}

bool
WorkerPermissionOperationCompleted::WorkerRun(JSContext* aCx,
                                              WorkerPrivate* aWorkerPrivate)
{
  aWorkerPrivate->AssertIsOnWorkerThread();
  mChallenge->OperationCompleted();
  return true;
}

mozilla::ipc::IPCResult
WorkerPermissionRequestChildProcessActor::Recv__delete__(
                                              const uint32_t& /* aPermission */)
{
  MOZ_ASSERT(NS_IsMainThread());
  mChallenge->OperationCompleted();
  return IPC_OK();
}

class MOZ_STACK_CLASS AutoSetCurrentFileHandle final
{
  typedef mozilla::ipc::BackgroundChildImpl BackgroundChildImpl;

  IDBFileHandle* const mFileHandle;
  IDBFileHandle* mPreviousFileHandle;
  IDBFileHandle** mThreadLocalSlot;

public:
  explicit AutoSetCurrentFileHandle(IDBFileHandle* aFileHandle)
    : mFileHandle(aFileHandle)
    , mPreviousFileHandle(nullptr)
    , mThreadLocalSlot(nullptr)
  {
    if (aFileHandle) {
      BackgroundChildImpl::ThreadLocal* threadLocal =
        BackgroundChildImpl::GetThreadLocalForCurrentThread();
      MOZ_ASSERT(threadLocal);

      // Hang onto this location for resetting later.
      mThreadLocalSlot = &threadLocal->mCurrentFileHandle;

      // Save the current value.
      mPreviousFileHandle = *mThreadLocalSlot;

      // Set the new value.
      *mThreadLocalSlot = aFileHandle;
    }
  }

  ~AutoSetCurrentFileHandle()
  {
    MOZ_ASSERT_IF(mThreadLocalSlot, mFileHandle);
    MOZ_ASSERT_IF(mThreadLocalSlot, *mThreadLocalSlot == mFileHandle);

    if (mThreadLocalSlot) {
      // Reset old value.
      *mThreadLocalSlot = mPreviousFileHandle;
    }
  }

  IDBFileHandle*
  FileHandle() const
  {
    return mFileHandle;
  }
};

class MOZ_STACK_CLASS FileHandleResultHelper final
  : public IDBFileRequest::ResultCallback
{
  IDBFileRequest* mFileRequest;
  AutoSetCurrentFileHandle mAutoFileHandle;

  union
  {
    File* mFile;
    const nsCString* mString;
    const FileRequestMetadata* mMetadata;
    const JS::Handle<JS::Value>* mJSValHandle;
  } mResult;

  enum
  {
    ResultTypeFile,
    ResultTypeString,
    ResultTypeMetadata,
    ResultTypeJSValHandle,
  } mResultType;

public:
  FileHandleResultHelper(IDBFileRequest* aFileRequest,
                         IDBFileHandle* aFileHandle,
                         File* aResult)
    : mFileRequest(aFileRequest)
    , mAutoFileHandle(aFileHandle)
    , mResultType(ResultTypeFile)
  {
    MOZ_ASSERT(aFileRequest);
    MOZ_ASSERT(aFileHandle);
    MOZ_ASSERT(aResult);

    mResult.mFile = aResult;
  }

  FileHandleResultHelper(IDBFileRequest* aFileRequest,
                         IDBFileHandle* aFileHandle,
                         const nsCString* aResult)
    : mFileRequest(aFileRequest)
    , mAutoFileHandle(aFileHandle)
    , mResultType(ResultTypeString)
  {
    MOZ_ASSERT(aFileRequest);
    MOZ_ASSERT(aFileHandle);
    MOZ_ASSERT(aResult);

    mResult.mString = aResult;
  }

  FileHandleResultHelper(IDBFileRequest* aFileRequest,
                         IDBFileHandle* aFileHandle,
                         const FileRequestMetadata* aResult)
    : mFileRequest(aFileRequest)
    , mAutoFileHandle(aFileHandle)
    , mResultType(ResultTypeMetadata)
  {
    MOZ_ASSERT(aFileRequest);
    MOZ_ASSERT(aFileHandle);
    MOZ_ASSERT(aResult);

    mResult.mMetadata = aResult;
  }


  FileHandleResultHelper(IDBFileRequest* aFileRequest,
                         IDBFileHandle* aFileHandle,
                         const JS::Handle<JS::Value>* aResult)
    : mFileRequest(aFileRequest)
    , mAutoFileHandle(aFileHandle)
    , mResultType(ResultTypeJSValHandle)
  {
    MOZ_ASSERT(aFileRequest);
    MOZ_ASSERT(aFileHandle);
    MOZ_ASSERT(aResult);

    mResult.mJSValHandle = aResult;
  }

  IDBFileRequest*
  FileRequest() const
  {
    return mFileRequest;
  }

  IDBFileHandle*
  FileHandle() const
  {
    return mAutoFileHandle.FileHandle();
  }

  virtual nsresult
  GetResult(JSContext* aCx, JS::MutableHandle<JS::Value> aResult) override
  {
    MOZ_ASSERT(aCx);
    MOZ_ASSERT(mFileRequest);

    switch (mResultType) {
      case ResultTypeFile:
        return GetResult(aCx, mResult.mFile, aResult);

      case ResultTypeString:
        return GetResult(aCx, mResult.mString, aResult);

      case ResultTypeMetadata:
        return GetResult(aCx, mResult.mMetadata, aResult);

      case ResultTypeJSValHandle:
        aResult.set(*mResult.mJSValHandle);
        return NS_OK;

      default:
        MOZ_CRASH("Unknown result type!");
    }

    MOZ_CRASH("Should never get here!");
  }

private:
  nsresult
  GetResult(JSContext* aCx,
            File* aFile,
            JS::MutableHandle<JS::Value> aResult)
  {
    bool ok = GetOrCreateDOMReflector(aCx, aFile, aResult);
    if (NS_WARN_IF(!ok)) {
      return NS_ERROR_DOM_FILEHANDLE_UNKNOWN_ERR;
    }

    return NS_OK;
  }

  nsresult
  GetResult(JSContext* aCx,
            const nsCString* aString,
            JS::MutableHandle<JS::Value> aResult)
  {
    const nsCString& data = *aString;

    nsresult rv;

    if (!mFileRequest->HasEncoding()) {
      JS::Rooted<JSObject*> arrayBuffer(aCx);
      rv = nsContentUtils::CreateArrayBuffer(aCx, data, arrayBuffer.address());
      if (NS_WARN_IF(NS_FAILED(rv))) {
        return NS_ERROR_DOM_FILEHANDLE_UNKNOWN_ERR;
      }

      aResult.setObject(*arrayBuffer);
      return NS_OK;
    }

    // Try the API argument.
    const Encoding* encoding =
      Encoding::ForLabel(mFileRequest->GetEncoding());
    if (!encoding) {
      // API argument failed. Since we are dealing with a file system file,
      // we don't have a meaningful type attribute for the blob available,
      // so proceeding to the next step, which is defaulting to UTF-8.
      encoding = UTF_8_ENCODING;
    }

    nsString tmpString;
    Tie(rv, encoding) = encoding->Decode(data, tmpString);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return NS_ERROR_DOM_FILEHANDLE_UNKNOWN_ERR;
    }
    rv = NS_OK;

    if (NS_WARN_IF(!xpc::StringToJsval(aCx, tmpString, aResult))) {
      return NS_ERROR_DOM_FILEHANDLE_UNKNOWN_ERR;
    }

    return NS_OK;
  }

  nsresult
  GetResult(JSContext* aCx,
            const FileRequestMetadata* aMetadata,
            JS::MutableHandle<JS::Value> aResult)
  {
    JS::Rooted<JSObject*> obj(aCx, JS_NewPlainObject(aCx));
    if (NS_WARN_IF(!obj)) {
      return NS_ERROR_DOM_FILEHANDLE_UNKNOWN_ERR;
    }

    const FileRequestSize& size = aMetadata->size();
    if (size.type() != FileRequestSize::Tvoid_t) {
      MOZ_ASSERT(size.type() == FileRequestSize::Tuint64_t);

      JS::Rooted<JS::Value> number(aCx, JS_NumberValue(size.get_uint64_t()));

      if (NS_WARN_IF(!JS_DefineProperty(aCx, obj, "size", number, 0))) {
        return NS_ERROR_DOM_FILEHANDLE_UNKNOWN_ERR;
      }
    }

    const FileRequestLastModified& lastModified = aMetadata->lastModified();
    if (lastModified.type() != FileRequestLastModified::Tvoid_t) {
      MOZ_ASSERT(lastModified.type() == FileRequestLastModified::Tint64_t);

      JS::Rooted<JSObject*> date(aCx,
        JS::NewDateObject(aCx, JS::TimeClip(lastModified.get_int64_t())));
      if (NS_WARN_IF(!date)) {
        return NS_ERROR_DOM_FILEHANDLE_UNKNOWN_ERR;
      }

      if (NS_WARN_IF(!JS_DefineProperty(aCx, obj, "lastModified", date, 0))) {
        return NS_ERROR_DOM_FILEHANDLE_UNKNOWN_ERR;
      }
    }

    aResult.setObject(*obj);
    return NS_OK;
  }
};

already_AddRefed<File>
ConvertActorToFile(IDBFileHandle* aFileHandle,
                   const FileRequestGetFileResponse& aResponse)
{
  auto* actor = static_cast<PendingIPCBlobChild*>(aResponse.fileChild());

  IDBMutableFile* mutableFile = aFileHandle->GetMutableFile();
  MOZ_ASSERT(mutableFile);

  const FileRequestMetadata& metadata = aResponse.metadata();

  const FileRequestSize& size = metadata.size();
  MOZ_ASSERT(size.type() == FileRequestSize::Tuint64_t);

  const FileRequestLastModified& lastModified = metadata.lastModified();
  MOZ_ASSERT(lastModified.type() == FileRequestLastModified::Tint64_t);

  RefPtr<BlobImpl> blobImpl =
    actor->SetPendingInfoAndDeleteActor(mutableFile->Name(),
                                        mutableFile->Type(),
                                        size.get_uint64_t(),
                                        lastModified.get_int64_t());
  MOZ_ASSERT(blobImpl);

  RefPtr<BlobImpl> blobImplSnapshot =
    new BlobImplSnapshot(blobImpl, static_cast<IDBFileHandle*>(aFileHandle));

  RefPtr<File> file = File::Create(mutableFile->GetOwner(), blobImplSnapshot);
  return file.forget();
}

void
DispatchFileHandleErrorEvent(IDBFileRequest* aFileRequest,
                             nsresult aErrorCode,
                             IDBFileHandle* aFileHandle)
{
  MOZ_ASSERT(aFileRequest);
  aFileRequest->AssertIsOnOwningThread();
  MOZ_ASSERT(NS_FAILED(aErrorCode));
  MOZ_ASSERT(NS_ERROR_GET_MODULE(aErrorCode) == NS_ERROR_MODULE_DOM_FILEHANDLE);
  MOZ_ASSERT(aFileHandle);

  RefPtr<IDBFileRequest> fileRequest = aFileRequest;
  RefPtr<IDBFileHandle> fileHandle = aFileHandle;

  AutoSetCurrentFileHandle ascfh(aFileHandle);

  fileRequest->FireError(aErrorCode);

  MOZ_ASSERT(fileHandle->IsOpen() || fileHandle->IsAborted());
}

void
DispatchFileHandleSuccessEvent(FileHandleResultHelper* aResultHelper)
{
  MOZ_ASSERT(aResultHelper);

  RefPtr<IDBFileRequest> fileRequest = aResultHelper->FileRequest();
  MOZ_ASSERT(fileRequest);
  fileRequest->AssertIsOnOwningThread();

  RefPtr<IDBFileHandle> fileHandle = aResultHelper->FileHandle();
  MOZ_ASSERT(fileHandle);

  if (fileHandle->IsAborted()) {
    fileRequest->FireError(NS_ERROR_DOM_FILEHANDLE_ABORT_ERR);
    return;
  }

  MOZ_ASSERT(fileHandle->IsOpen());

  fileRequest->SetResultCallback(aResultHelper);

  MOZ_ASSERT(fileHandle->IsOpen() || fileHandle->IsAborted());
}

} // namespace

/*******************************************************************************
 * Actor class declarations
 ******************************************************************************/

// CancelableRunnable is used to make workers happy.
class BackgroundRequestChild::PreprocessHelper final
  : public CancelableRunnable
  , public nsIInputStreamCallback
{
  typedef std::pair<nsCOMPtr<nsIInputStream>,
                    nsCOMPtr<nsIInputStream>> StreamPair;

  nsCOMPtr<nsIEventTarget> mOwningEventTarget;
  nsTArray<StreamPair> mStreamPairs;
  nsTArray<RefPtr<JS::WasmModule>> mModuleSet;
  BackgroundRequestChild* mActor;

  // These 2 are populated when the processing of the stream pairs runs.
  PRFileDesc* mCurrentBytecodeFileDesc;
  PRFileDesc* mCurrentCompiledFileDesc;

  RefPtr<TaskQueue> mTaskQueue;
  nsCOMPtr<nsIEventTarget> mTaskQueueEventTarget;

  uint32_t mModuleSetIndex;
  nsresult mResultCode;

public:
  PreprocessHelper(uint32_t aModuleSetIndex, BackgroundRequestChild* aActor)
    : CancelableRunnable("indexedDB::BackgroundRequestChild::PreprocessHelper")
    , mOwningEventTarget(aActor->GetActorEventTarget())
    , mActor(aActor)
    , mCurrentBytecodeFileDesc(nullptr)
    , mCurrentCompiledFileDesc(nullptr)
    , mModuleSetIndex(aModuleSetIndex)
    , mResultCode(NS_OK)
  {
    AssertIsOnOwningThread();
    MOZ_ASSERT(aActor);
    aActor->AssertIsOnOwningThread();
  }

  bool
  IsOnOwningThread() const
  {
    MOZ_ASSERT(mOwningEventTarget);

    bool current;
    return NS_SUCCEEDED(mOwningEventTarget->IsOnCurrentThread(&current)) && current;
  }

  void
  AssertIsOnOwningThread() const
  {
    MOZ_ASSERT(IsOnOwningThread());
  }

  void
  ClearActor()
  {
    AssertIsOnOwningThread();

    mActor = nullptr;
  }

  nsresult
  Init(const nsTArray<StructuredCloneFile>& aFiles);

  nsresult
  Dispatch();

private:
  ~PreprocessHelper()
  {
    if (mTaskQueue) {
      mTaskQueue->BeginShutdown();
    }
  }

  void
  RunOnOwningThread();

  void
  ProcessCurrentStreamPair();

  nsresult
  WaitForStreamReady(nsIInputStream* aInputStream);

  void
  ContinueWithStatus(nsresult aStatus);

  NS_DECL_ISUPPORTS_INHERITED
  NS_DECL_NSIRUNNABLE
  NS_DECL_NSIINPUTSTREAMCALLBACK

  virtual nsresult
  Cancel() override;
};

/*******************************************************************************
 * Local class implementations
 ******************************************************************************/

void
PermissionRequestMainProcessHelper::OnPromptComplete(
                                               PermissionValue aPermissionValue)
{
  MOZ_ASSERT(mActor);
  mActor->AssertIsOnOwningThread();

  MaybeCollectGarbageOnIPCMessage();

  mActor->SendPermissionRetry();

  mActor = nullptr;
  mFactory = nullptr;
}

mozilla::ipc::IPCResult
PermissionRequestChildProcessActor::Recv__delete__(
                                              const uint32_t& /* aPermission */)
{
  MOZ_ASSERT(mActor);
  mActor->AssertIsOnOwningThread();
  MOZ_ASSERT(mFactory);

  MaybeCollectGarbageOnIPCMessage();

  RefPtr<IDBFactory> factory;
  mFactory.swap(factory);

  mActor->SendPermissionRetry();
  mActor = nullptr;

  return IPC_OK();
}

/*******************************************************************************
 * BackgroundRequestChildBase
 ******************************************************************************/

BackgroundRequestChildBase::BackgroundRequestChildBase(IDBRequest* aRequest)
  : mRequest(aRequest)
{
  MOZ_ASSERT(aRequest);
  aRequest->AssertIsOnOwningThread();

  MOZ_COUNT_CTOR(indexedDB::BackgroundRequestChildBase);
}

BackgroundRequestChildBase::~BackgroundRequestChildBase()
{
  AssertIsOnOwningThread();

  MOZ_COUNT_DTOR(indexedDB::BackgroundRequestChildBase);
}

#ifdef DEBUG

void
BackgroundRequestChildBase::AssertIsOnOwningThread() const
{
  MOZ_ASSERT(mRequest);
  mRequest->AssertIsOnOwningThread();
}

#endif // DEBUG

/*******************************************************************************
 * BackgroundFactoryChild
 ******************************************************************************/

BackgroundFactoryChild::BackgroundFactoryChild(IDBFactory* aFactory)
  : mFactory(aFactory)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(aFactory);
  aFactory->AssertIsOnOwningThread();

  MOZ_COUNT_CTOR(indexedDB::BackgroundFactoryChild);
}

BackgroundFactoryChild::~BackgroundFactoryChild()
{
  MOZ_COUNT_DTOR(indexedDB::BackgroundFactoryChild);
}

void
BackgroundFactoryChild::SendDeleteMeInternal()
{
  AssertIsOnOwningThread();

  if (mFactory) {
    mFactory->ClearBackgroundActor();
    mFactory = nullptr;

    MOZ_ALWAYS_TRUE(PBackgroundIDBFactoryChild::SendDeleteMe());
  }
}

void
BackgroundFactoryChild::ActorDestroy(ActorDestroyReason aWhy)
{
  AssertIsOnOwningThread();

  MaybeCollectGarbageOnIPCMessage();

  if (mFactory) {
    mFactory->ClearBackgroundActor();
#ifdef DEBUG
    mFactory = nullptr;
#endif
  }
}

PBackgroundIDBFactoryRequestChild*
BackgroundFactoryChild::AllocPBackgroundIDBFactoryRequestChild(
                                            const FactoryRequestParams& aParams)
{
  MOZ_CRASH("PBackgroundIDBFactoryRequestChild actors should be manually "
            "constructed!");
}

bool
BackgroundFactoryChild::DeallocPBackgroundIDBFactoryRequestChild(
                                      PBackgroundIDBFactoryRequestChild* aActor)
{
  MOZ_ASSERT(aActor);

  delete static_cast<BackgroundFactoryRequestChild*>(aActor);
  return true;
}

PBackgroundIDBDatabaseChild*
BackgroundFactoryChild::AllocPBackgroundIDBDatabaseChild(
                                    const DatabaseSpec& aSpec,
                                    PBackgroundIDBFactoryRequestChild* aRequest)
{
  AssertIsOnOwningThread();

  auto request = static_cast<BackgroundFactoryRequestChild*>(aRequest);
  MOZ_ASSERT(request);

  return new BackgroundDatabaseChild(aSpec, request);
}

bool
BackgroundFactoryChild::DeallocPBackgroundIDBDatabaseChild(
                                            PBackgroundIDBDatabaseChild* aActor)
{
  MOZ_ASSERT(aActor);

  delete static_cast<BackgroundDatabaseChild*>(aActor);
  return true;
}

mozilla::ipc::IPCResult
BackgroundFactoryChild::RecvPBackgroundIDBDatabaseConstructor(
                                    PBackgroundIDBDatabaseChild* aActor,
                                    const DatabaseSpec& aSpec,
                                    PBackgroundIDBFactoryRequestChild* aRequest)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(aActor);
  MOZ_ASSERT(aActor->GetActorEventTarget(),
    "The event target shall be inherited from its manager actor.");

  return IPC_OK();
}

/*******************************************************************************
 * BackgroundFactoryRequestChild
 ******************************************************************************/

BackgroundFactoryRequestChild::BackgroundFactoryRequestChild(
                                               IDBFactory* aFactory,
                                               IDBOpenDBRequest* aOpenRequest,
                                               bool aIsDeleteOp,
                                               uint64_t aRequestedVersion)
  : BackgroundRequestChildBase(aOpenRequest)
  , mFactory(aFactory)
  , mRequestedVersion(aRequestedVersion)
  , mIsDeleteOp(aIsDeleteOp)
{
  // Can't assert owning thread here because IPDL has not yet set our manager!
  MOZ_ASSERT(aFactory);
  aFactory->AssertIsOnOwningThread();
  MOZ_ASSERT(aOpenRequest);

  MOZ_COUNT_CTOR(indexedDB::BackgroundFactoryRequestChild);
}

BackgroundFactoryRequestChild::~BackgroundFactoryRequestChild()
{
  MOZ_COUNT_DTOR(indexedDB::BackgroundFactoryRequestChild);
}

IDBOpenDBRequest*
BackgroundFactoryRequestChild::GetOpenDBRequest() const
{
  AssertIsOnOwningThread();

  return static_cast<IDBOpenDBRequest*>(mRequest.get());
}

bool
BackgroundFactoryRequestChild::HandleResponse(nsresult aResponse)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(NS_FAILED(aResponse));
  MOZ_ASSERT(NS_ERROR_GET_MODULE(aResponse) == NS_ERROR_MODULE_DOM_INDEXEDDB);

  mRequest->Reset();

  DispatchErrorEvent(mRequest, aResponse);

  return true;
}

bool
BackgroundFactoryRequestChild::HandleResponse(
                                   const OpenDatabaseRequestResponse& aResponse)
{
  AssertIsOnOwningThread();

  mRequest->Reset();

  auto databaseActor =
    static_cast<BackgroundDatabaseChild*>(aResponse.databaseChild());
  MOZ_ASSERT(databaseActor);

  IDBDatabase* database = databaseActor->GetDOMObject();
  if (!database) {
    databaseActor->EnsureDOMObject();

    database = databaseActor->GetDOMObject();
    MOZ_ASSERT(database);

    MOZ_ASSERT(!database->IsClosed());
  }

  if (database->IsClosed()) {
    // If the database was closed already, which is only possible if we fired an
    // "upgradeneeded" event, then we shouldn't fire a "success" event here.
    // Instead we fire an error event with AbortErr.
    DispatchErrorEvent(mRequest, NS_ERROR_DOM_INDEXEDDB_ABORT_ERR);
  } else {
    ResultHelper helper(mRequest, nullptr, database);

    DispatchSuccessEvent(&helper);
  }

  databaseActor->ReleaseDOMObject();

  return true;
}

bool
BackgroundFactoryRequestChild::HandleResponse(
                                 const DeleteDatabaseRequestResponse& aResponse)
{
  AssertIsOnOwningThread();

  ResultHelper helper(mRequest, nullptr, &JS::UndefinedHandleValue);

  nsCOMPtr<nsIDOMEvent> successEvent =
    IDBVersionChangeEvent::Create(mRequest,
                                  nsDependentString(kSuccessEventType),
                                  aResponse.previousVersion());
  MOZ_ASSERT(successEvent);

  DispatchSuccessEvent(&helper, successEvent);

  return true;
}

void
BackgroundFactoryRequestChild::ActorDestroy(ActorDestroyReason aWhy)
{
  AssertIsOnOwningThread();

  MaybeCollectGarbageOnIPCMessage();

  if (aWhy != Deletion) {
    IDBOpenDBRequest* openRequest = GetOpenDBRequest();
    if (openRequest) {
      openRequest->NoteComplete();
    }
  }
}

mozilla::ipc::IPCResult
BackgroundFactoryRequestChild::Recv__delete__(
                                        const FactoryRequestResponse& aResponse)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(mRequest);

  MaybeCollectGarbageOnIPCMessage();

  bool result;

  switch (aResponse.type()) {
    case FactoryRequestResponse::Tnsresult:
      result = HandleResponse(aResponse.get_nsresult());
      break;

    case FactoryRequestResponse::TOpenDatabaseRequestResponse:
      result = HandleResponse(aResponse.get_OpenDatabaseRequestResponse());
      break;

    case FactoryRequestResponse::TDeleteDatabaseRequestResponse:
      result = HandleResponse(aResponse.get_DeleteDatabaseRequestResponse());
      break;

    default:
      MOZ_CRASH("Unknown response type!");
  }

  IDBOpenDBRequest* request = GetOpenDBRequest();
  MOZ_ASSERT(request);

  request->NoteComplete();

  if (NS_WARN_IF(!result)) {
    return IPC_FAIL_NO_REASON(this);
  }

  return IPC_OK();
}

mozilla::ipc::IPCResult
BackgroundFactoryRequestChild::RecvPermissionChallenge(
                                            const PrincipalInfo& aPrincipalInfo)
{
  AssertIsOnOwningThread();

  MaybeCollectGarbageOnIPCMessage();

  if (!NS_IsMainThread()) {
    WorkerPrivate* workerPrivate = GetCurrentThreadWorkerPrivate();
    MOZ_ASSERT(workerPrivate);
    workerPrivate->AssertIsOnWorkerThread();

    RefPtr<WorkerPermissionChallenge> challenge =
      new WorkerPermissionChallenge(workerPrivate, this, mFactory,
                                    aPrincipalInfo);
    if (!challenge->Dispatch()) {
      return IPC_FAIL_NO_REASON(this);
    }
    return IPC_OK();
  }

  nsresult rv;
  nsCOMPtr<nsIPrincipal> principal =
    mozilla::ipc::PrincipalInfoToPrincipal(aPrincipalInfo, &rv);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return IPC_FAIL_NO_REASON(this);
  }

  if (XRE_IsParentProcess()) {
    nsCOMPtr<nsPIDOMWindowInner> window = mFactory->GetParentObject();
    MOZ_ASSERT(window);

    nsCOMPtr<Element> ownerElement =
      do_QueryInterface(window->GetChromeEventHandler());
    if (NS_WARN_IF(!ownerElement)) {
      // If this fails, the page was navigated. Fail the permission check by
      // forcing an immediate retry.
      if (!SendPermissionRetry()) {
        return IPC_FAIL_NO_REASON(this);
      }
      return IPC_OK();
    }

    RefPtr<PermissionRequestMainProcessHelper> helper =
      new PermissionRequestMainProcessHelper(this, mFactory, ownerElement, principal);

    PermissionRequestBase::PermissionValue permission;
    if (NS_WARN_IF(NS_FAILED(helper->PromptIfNeeded(&permission)))) {
      return IPC_FAIL_NO_REASON(this);
    }

    MOZ_ASSERT(permission == PermissionRequestBase::kPermissionAllowed ||
               permission == PermissionRequestBase::kPermissionDenied ||
               permission == PermissionRequestBase::kPermissionPrompt);

    if (permission != PermissionRequestBase::kPermissionPrompt) {
      SendPermissionRetry();
    }
    return IPC_OK();
  }

  RefPtr<TabChild> tabChild = mFactory->GetTabChild();
  MOZ_ASSERT(tabChild);

  IPC::Principal ipcPrincipal(principal);

  auto* actor = new PermissionRequestChildProcessActor(this, mFactory);

  tabChild->SetEventTargetForActor(actor, this->GetActorEventTarget());
  MOZ_ASSERT(actor->GetActorEventTarget());
  tabChild->SendPIndexedDBPermissionRequestConstructor(actor, ipcPrincipal);

  return IPC_OK();
}

mozilla::ipc::IPCResult
BackgroundFactoryRequestChild::RecvBlocked(const uint64_t& aCurrentVersion)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(mRequest);

  MaybeCollectGarbageOnIPCMessage();

  const nsDependentString type(kBlockedEventType);

  nsCOMPtr<nsIDOMEvent> blockedEvent;
  if (mIsDeleteOp) {
    blockedEvent =
      IDBVersionChangeEvent::Create(mRequest, type, aCurrentVersion);
    MOZ_ASSERT(blockedEvent);
  } else {
    blockedEvent =
      IDBVersionChangeEvent::Create(mRequest,
                                    type,
                                    aCurrentVersion,
                                    mRequestedVersion);
    MOZ_ASSERT(blockedEvent);
  }

  RefPtr<IDBRequest> kungFuDeathGrip = mRequest;

  IDB_LOG_MARK("IndexedDB %s: Child  Request[%llu]: Firing \"blocked\" event",
               "IndexedDB %s: C R[%llu]: \"blocked\"",
               IDB_LOG_ID_STRING(),
               kungFuDeathGrip->LoggingSerialNumber());

  bool dummy;
  if (NS_FAILED(kungFuDeathGrip->DispatchEvent(blockedEvent, &dummy))) {
    NS_WARNING("Failed to dispatch event!");
  }

  return IPC_OK();
}

/*******************************************************************************
 * BackgroundDatabaseChild
 ******************************************************************************/

BackgroundDatabaseChild::BackgroundDatabaseChild(
                               const DatabaseSpec& aSpec,
                               BackgroundFactoryRequestChild* aOpenRequestActor)
  : mSpec(new DatabaseSpec(aSpec))
  , mOpenRequestActor(aOpenRequestActor)
  , mDatabase(nullptr)
{
  // Can't assert owning thread here because IPDL has not yet set our manager!
  MOZ_ASSERT(aOpenRequestActor);

  MOZ_COUNT_CTOR(indexedDB::BackgroundDatabaseChild);
}

BackgroundDatabaseChild::~BackgroundDatabaseChild()
{
  MOZ_COUNT_DTOR(indexedDB::BackgroundDatabaseChild);
}

#ifdef DEBUG

void
BackgroundDatabaseChild::AssertIsOnOwningThread() const
{
  static_cast<BackgroundFactoryChild*>(Manager())->AssertIsOnOwningThread();
}

#endif // DEBUG

void
BackgroundDatabaseChild::SendDeleteMeInternal()
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(!mTemporaryStrongDatabase);
  MOZ_ASSERT(!mOpenRequestActor);

  if (mDatabase) {
    mDatabase->ClearBackgroundActor();
    mDatabase = nullptr;

    MOZ_ALWAYS_TRUE(PBackgroundIDBDatabaseChild::SendDeleteMe());
  }
}

void
BackgroundDatabaseChild::EnsureDOMObject()
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(mOpenRequestActor);

  if (mTemporaryStrongDatabase) {
    MOZ_ASSERT(!mSpec);
    return;
  }

  MOZ_ASSERT(mSpec);

  auto request = mOpenRequestActor->GetOpenDBRequest();
  MOZ_ASSERT(request);

  auto factory =
    static_cast<BackgroundFactoryChild*>(Manager())->GetDOMObject();
  MOZ_ASSERT(factory);

  mTemporaryStrongDatabase =
    IDBDatabase::Create(request, factory, this, mSpec);

  MOZ_ASSERT(mTemporaryStrongDatabase);
  mTemporaryStrongDatabase->AssertIsOnOwningThread();

  mDatabase = mTemporaryStrongDatabase;
  mSpec.forget();
}

void
BackgroundDatabaseChild::ReleaseDOMObject()
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(mTemporaryStrongDatabase);
  mTemporaryStrongDatabase->AssertIsOnOwningThread();
  MOZ_ASSERT(mOpenRequestActor);
  MOZ_ASSERT(mDatabase == mTemporaryStrongDatabase);

  mOpenRequestActor = nullptr;

  // This may be the final reference to the IDBDatabase object so we may end up
  // calling SendDeleteMeInternal() here. Make sure everything is cleaned up
  // properly before proceeding.
  mTemporaryStrongDatabase = nullptr;
}

void
BackgroundDatabaseChild::ActorDestroy(ActorDestroyReason aWhy)
{
  AssertIsOnOwningThread();

  MaybeCollectGarbageOnIPCMessage();

  if (mDatabase) {
    mDatabase->ClearBackgroundActor();
#ifdef DEBUG
    mDatabase = nullptr;
#endif
  }
}

PBackgroundIDBDatabaseFileChild*
BackgroundDatabaseChild::AllocPBackgroundIDBDatabaseFileChild(
                                                        const IPCBlob& aIPCBlob)
{
  MOZ_CRASH("PBackgroundIDBFileChild actors should be manually constructed!");
}

bool
BackgroundDatabaseChild::DeallocPBackgroundIDBDatabaseFileChild(
                                        PBackgroundIDBDatabaseFileChild* aActor)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(aActor);

  delete aActor;
  return true;
}

PBackgroundIDBDatabaseRequestChild*
BackgroundDatabaseChild::AllocPBackgroundIDBDatabaseRequestChild(
                                           const DatabaseRequestParams& aParams)
{
  MOZ_CRASH("PBackgroundIDBDatabaseRequestChild actors should be manually "
            "constructed!");
}

bool
BackgroundDatabaseChild::DeallocPBackgroundIDBDatabaseRequestChild(
                                     PBackgroundIDBDatabaseRequestChild* aActor)
{
  MOZ_ASSERT(aActor);

  delete static_cast<BackgroundDatabaseRequestChild*>(aActor);
  return true;
}

PBackgroundIDBTransactionChild*
BackgroundDatabaseChild::AllocPBackgroundIDBTransactionChild(
                                    const nsTArray<nsString>& aObjectStoreNames,
                                    const Mode& aMode)
{
  MOZ_CRASH("PBackgroundIDBTransactionChild actors should be manually "
            "constructed!");
}

bool
BackgroundDatabaseChild::DeallocPBackgroundIDBTransactionChild(
                                         PBackgroundIDBTransactionChild* aActor)
{
  MOZ_ASSERT(aActor);

  delete static_cast<BackgroundTransactionChild*>(aActor);
  return true;
}

PBackgroundIDBVersionChangeTransactionChild*
BackgroundDatabaseChild::AllocPBackgroundIDBVersionChangeTransactionChild(
                                              const uint64_t& aCurrentVersion,
                                              const uint64_t& aRequestedVersion,
                                              const int64_t& aNextObjectStoreId,
                                              const int64_t& aNextIndexId)
{
  AssertIsOnOwningThread();

  IDBOpenDBRequest* request = mOpenRequestActor->GetOpenDBRequest();
  MOZ_ASSERT(request);

  return new BackgroundVersionChangeTransactionChild(request);
}

mozilla::ipc::IPCResult
BackgroundDatabaseChild::RecvPBackgroundIDBVersionChangeTransactionConstructor(
                            PBackgroundIDBVersionChangeTransactionChild* aActor,
                            const uint64_t& aCurrentVersion,
                            const uint64_t& aRequestedVersion,
                            const int64_t& aNextObjectStoreId,
                            const int64_t& aNextIndexId)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(aActor);
  MOZ_ASSERT(aActor->GetActorEventTarget(),
    "The event target shall be inherited from its manager actor.");
  MOZ_ASSERT(mOpenRequestActor);

  MaybeCollectGarbageOnIPCMessage();

  EnsureDOMObject();

  auto* actor = static_cast<BackgroundVersionChangeTransactionChild*>(aActor);

  RefPtr<IDBOpenDBRequest> request = mOpenRequestActor->GetOpenDBRequest();
  MOZ_ASSERT(request);

  RefPtr<IDBTransaction> transaction =
    IDBTransaction::CreateVersionChange(mDatabase,
                                        actor,
                                        request,
                                        aNextObjectStoreId,
                                        aNextIndexId);
  MOZ_ASSERT(transaction);

  transaction->AssertIsOnOwningThread();

  actor->SetDOMTransaction(transaction);

  mDatabase->EnterSetVersionTransaction(aRequestedVersion);

  request->SetTransaction(transaction);

  nsCOMPtr<nsIDOMEvent> upgradeNeededEvent =
    IDBVersionChangeEvent::Create(request,
                                  nsDependentString(kUpgradeNeededEventType),
                                  aCurrentVersion,
                                  aRequestedVersion);
  MOZ_ASSERT(upgradeNeededEvent);

  ResultHelper helper(request, transaction, mDatabase);

  DispatchSuccessEvent(&helper, upgradeNeededEvent);

  return IPC_OK();
}

bool
BackgroundDatabaseChild::DeallocPBackgroundIDBVersionChangeTransactionChild(
                            PBackgroundIDBVersionChangeTransactionChild* aActor)
{
  MOZ_ASSERT(aActor);

  delete static_cast<BackgroundVersionChangeTransactionChild*>(aActor);
  return true;
}

PBackgroundMutableFileChild*
BackgroundDatabaseChild::AllocPBackgroundMutableFileChild(const nsString& aName,
                                                          const nsString& aType)
{
  AssertIsOnOwningThread();

  return new BackgroundMutableFileChild(aName, aType);
}

bool
BackgroundDatabaseChild::DeallocPBackgroundMutableFileChild(
                                            PBackgroundMutableFileChild* aActor)
{
  MOZ_ASSERT(aActor);

  delete static_cast<BackgroundMutableFileChild*>(aActor);
  return true;
}

mozilla::ipc::IPCResult
BackgroundDatabaseChild::RecvVersionChange(const uint64_t& aOldVersion,
                                           const NullableVersion& aNewVersion)
{
  AssertIsOnOwningThread();

  MaybeCollectGarbageOnIPCMessage();

  if (!mDatabase || mDatabase->IsClosed()) {
    return IPC_OK();
  }

  RefPtr<IDBDatabase> kungFuDeathGrip = mDatabase;

  // Handle bfcache'd windows.
  if (nsPIDOMWindowInner* owner = kungFuDeathGrip->GetOwner()) {
    // The database must be closed if the window is already frozen.
    bool shouldAbortAndClose = owner->IsFrozen();

    // Anything in the bfcache has to be evicted and then we have to close the
    // database also.
    if (nsCOMPtr<nsIDocument> doc = owner->GetExtantDoc()) {
      if (nsCOMPtr<nsIBFCacheEntry> bfCacheEntry = doc->GetBFCacheEntry()) {
        bfCacheEntry->RemoveFromBFCacheSync();
        shouldAbortAndClose = true;
      }
    }

    if (shouldAbortAndClose) {
      // Invalidate() doesn't close the database in the parent, so we have
      // to call Close() and AbortTransactions() manually.
      kungFuDeathGrip->AbortTransactions(/* aShouldWarn */ false);
      kungFuDeathGrip->Close();
      return IPC_OK();
    }
  }

  // Otherwise fire a versionchange event.
  const nsDependentString type(kVersionChangeEventType);

  nsCOMPtr<nsIDOMEvent> versionChangeEvent;

  switch (aNewVersion.type()) {
    case NullableVersion::Tnull_t:
      versionChangeEvent =
        IDBVersionChangeEvent::Create(kungFuDeathGrip, type, aOldVersion);
      MOZ_ASSERT(versionChangeEvent);
      break;

    case NullableVersion::Tuint64_t:
      versionChangeEvent =
        IDBVersionChangeEvent::Create(kungFuDeathGrip,
                                      type,
                                      aOldVersion,
                                      aNewVersion.get_uint64_t());
      MOZ_ASSERT(versionChangeEvent);
      break;

    default:
      MOZ_CRASH("Should never get here!");
  }

  IDB_LOG_MARK("IndexedDB %s: Child : Firing \"versionchange\" event",
               "IndexedDB %s: C: IDBDatabase \"versionchange\" event",
               IDB_LOG_ID_STRING());

  bool dummy;
  if (NS_FAILED(kungFuDeathGrip->DispatchEvent(versionChangeEvent, &dummy))) {
    NS_WARNING("Failed to dispatch event!");
  }

  if (!kungFuDeathGrip->IsClosed()) {
    SendBlocked();
  }

  return IPC_OK();
}

mozilla::ipc::IPCResult
BackgroundDatabaseChild::RecvInvalidate()
{
  AssertIsOnOwningThread();

  MaybeCollectGarbageOnIPCMessage();

  if (mDatabase) {
    mDatabase->Invalidate();
  }

  return IPC_OK();
}

mozilla::ipc::IPCResult
BackgroundDatabaseChild::RecvCloseAfterInvalidationComplete()
{
  AssertIsOnOwningThread();

  MaybeCollectGarbageOnIPCMessage();

  if (mDatabase) {
    mDatabase->DispatchTrustedEvent(nsDependentString(kCloseEventType));
  }

  return IPC_OK();
}

/*******************************************************************************
 * BackgroundDatabaseRequestChild
 ******************************************************************************/

BackgroundDatabaseRequestChild::BackgroundDatabaseRequestChild(
                                                         IDBDatabase* aDatabase,
                                                         IDBRequest* aRequest)
  : BackgroundRequestChildBase(aRequest)
  , mDatabase(aDatabase)
{
  // Can't assert owning thread here because IPDL has not yet set our manager!
  MOZ_ASSERT(aDatabase);
  aDatabase->AssertIsOnOwningThread();
  MOZ_ASSERT(aRequest);

  MOZ_COUNT_CTOR(indexedDB::BackgroundDatabaseRequestChild);
}

BackgroundDatabaseRequestChild::~BackgroundDatabaseRequestChild()
{
  MOZ_COUNT_DTOR(indexedDB::BackgroundDatabaseRequestChild);
}

bool
BackgroundDatabaseRequestChild::HandleResponse(nsresult aResponse)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(NS_FAILED(aResponse));
  MOZ_ASSERT(NS_ERROR_GET_MODULE(aResponse) == NS_ERROR_MODULE_DOM_INDEXEDDB);

  mRequest->Reset();

  DispatchErrorEvent(mRequest, aResponse);

  return true;
}

bool
BackgroundDatabaseRequestChild::HandleResponse(
                                     const CreateFileRequestResponse& aResponse)
{
  AssertIsOnOwningThread();

  mRequest->Reset();

  auto mutableFileActor =
    static_cast<BackgroundMutableFileChild*>(aResponse.mutableFileChild());
  MOZ_ASSERT(mutableFileActor);

  mutableFileActor->EnsureDOMObject();

  auto mutableFile =
    static_cast<IDBMutableFile*>(mutableFileActor->GetDOMObject());
  MOZ_ASSERT(mutableFile);

  ResultHelper helper(mRequest, nullptr, mutableFile);

  DispatchSuccessEvent(&helper);

  mutableFileActor->ReleaseDOMObject();

  return true;
}

mozilla::ipc::IPCResult
BackgroundDatabaseRequestChild::Recv__delete__(
                                       const DatabaseRequestResponse& aResponse)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(mRequest);

  switch (aResponse.type()) {
    case DatabaseRequestResponse::Tnsresult:
      if (!HandleResponse(aResponse.get_nsresult())) {
        return IPC_FAIL_NO_REASON(this);
      }
      return IPC_OK();

    case DatabaseRequestResponse::TCreateFileRequestResponse:
      if (!HandleResponse(aResponse.get_CreateFileRequestResponse())) {
        return IPC_FAIL_NO_REASON(this);
      }
      return IPC_OK();

    default:
      MOZ_CRASH("Unknown response type!");
  }

  MOZ_CRASH("Should never get here!");
}

/*******************************************************************************
 * BackgroundTransactionBase
 ******************************************************************************/

BackgroundTransactionBase::BackgroundTransactionBase()
: mTransaction(nullptr)
{
  MOZ_COUNT_CTOR(indexedDB::BackgroundTransactionBase);
}

BackgroundTransactionBase::BackgroundTransactionBase(
                                                   IDBTransaction* aTransaction)
  : mTemporaryStrongTransaction(aTransaction)
  , mTransaction(aTransaction)
{
  MOZ_ASSERT(aTransaction);
  aTransaction->AssertIsOnOwningThread();

  MOZ_COUNT_CTOR(indexedDB::BackgroundTransactionBase);
}

BackgroundTransactionBase::~BackgroundTransactionBase()
{
  MOZ_COUNT_DTOR(indexedDB::BackgroundTransactionBase);
}

#ifdef DEBUG

void
BackgroundTransactionBase::AssertIsOnOwningThread() const
{
  MOZ_ASSERT(mTransaction);
  mTransaction->AssertIsOnOwningThread();
}

#endif // DEBUG

void
BackgroundTransactionBase::NoteActorDestroyed()
{
  AssertIsOnOwningThread();
  MOZ_ASSERT_IF(mTemporaryStrongTransaction, mTransaction);

  if (mTransaction) {
    mTransaction->ClearBackgroundActor();

    // Normally this would be DEBUG-only but NoteActorDestroyed is also called
    // from SendDeleteMeInternal. In that case we're going to receive an actual
    // ActorDestroy call later and we don't want to touch a dead object.
    mTemporaryStrongTransaction = nullptr;
    mTransaction = nullptr;
  }
}

void
BackgroundTransactionBase::SetDOMTransaction(IDBTransaction* aTransaction)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(aTransaction);
  aTransaction->AssertIsOnOwningThread();
  MOZ_ASSERT(!mTemporaryStrongTransaction);
  MOZ_ASSERT(!mTransaction);

  mTemporaryStrongTransaction = aTransaction;
  mTransaction = aTransaction;
}

void
BackgroundTransactionBase::NoteComplete()
{
  AssertIsOnOwningThread();
  MOZ_ASSERT_IF(mTransaction, mTemporaryStrongTransaction);

  mTemporaryStrongTransaction = nullptr;
}

/*******************************************************************************
 * BackgroundTransactionChild
 ******************************************************************************/

BackgroundTransactionChild::BackgroundTransactionChild(
                                                   IDBTransaction* aTransaction)
  : BackgroundTransactionBase(aTransaction)
{
  MOZ_ASSERT(aTransaction);
  aTransaction->AssertIsOnOwningThread();

  MOZ_COUNT_CTOR(indexedDB::BackgroundTransactionChild);
}

BackgroundTransactionChild::~BackgroundTransactionChild()
{
  MOZ_COUNT_DTOR(indexedDB::BackgroundTransactionChild);
}

#ifdef DEBUG

void
BackgroundTransactionChild::AssertIsOnOwningThread() const
{
  static_cast<BackgroundDatabaseChild*>(Manager())->AssertIsOnOwningThread();
}

#endif // DEBUG

void
BackgroundTransactionChild::SendDeleteMeInternal()
{
  AssertIsOnOwningThread();

  if (mTransaction) {
    NoteActorDestroyed();

    MOZ_ALWAYS_TRUE(PBackgroundIDBTransactionChild::SendDeleteMe());
  }
}

void
BackgroundTransactionChild::ActorDestroy(ActorDestroyReason aWhy)
{
  AssertIsOnOwningThread();

  MaybeCollectGarbageOnIPCMessage();

  NoteActorDestroyed();
}

mozilla::ipc::IPCResult
BackgroundTransactionChild::RecvComplete(const nsresult& aResult)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(mTransaction);

  MaybeCollectGarbageOnIPCMessage();

  mTransaction->FireCompleteOrAbortEvents(aResult);

  NoteComplete();
  return IPC_OK();
}

PBackgroundIDBRequestChild*
BackgroundTransactionChild::AllocPBackgroundIDBRequestChild(
                                                   const RequestParams& aParams)
{
  MOZ_CRASH("PBackgroundIDBRequestChild actors should be manually "
            "constructed!");
}

bool
BackgroundTransactionChild::DeallocPBackgroundIDBRequestChild(
                                             PBackgroundIDBRequestChild* aActor)
{
  MOZ_ASSERT(aActor);

  delete static_cast<BackgroundRequestChild*>(aActor);
  return true;
}

PBackgroundIDBCursorChild*
BackgroundTransactionChild::AllocPBackgroundIDBCursorChild(
                                                const OpenCursorParams& aParams)
{
  AssertIsOnOwningThread();

  MOZ_CRASH("PBackgroundIDBCursorChild actors should be manually constructed!");
}

bool
BackgroundTransactionChild::DeallocPBackgroundIDBCursorChild(
                                              PBackgroundIDBCursorChild* aActor)
{
  MOZ_ASSERT(aActor);

  delete static_cast<BackgroundCursorChild*>(aActor);
  return true;
}

/*******************************************************************************
 * BackgroundVersionChangeTransactionChild
 ******************************************************************************/

BackgroundVersionChangeTransactionChild::
BackgroundVersionChangeTransactionChild(IDBOpenDBRequest* aOpenDBRequest)
  : mOpenDBRequest(aOpenDBRequest)
{
  MOZ_ASSERT(aOpenDBRequest);
  aOpenDBRequest->AssertIsOnOwningThread();

  MOZ_COUNT_CTOR(indexedDB::BackgroundVersionChangeTransactionChild);
}

BackgroundVersionChangeTransactionChild::
~BackgroundVersionChangeTransactionChild()
{
  AssertIsOnOwningThread();

  MOZ_COUNT_DTOR(indexedDB::BackgroundVersionChangeTransactionChild);
}

#ifdef DEBUG

void
BackgroundVersionChangeTransactionChild::AssertIsOnOwningThread() const
{
  static_cast<BackgroundDatabaseChild*>(Manager())->AssertIsOnOwningThread();
}

#endif // DEBUG

void
BackgroundVersionChangeTransactionChild::SendDeleteMeInternal(
                                                        bool aFailedConstructor)
{
  AssertIsOnOwningThread();

  if (mTransaction || aFailedConstructor) {
    NoteActorDestroyed();

    MOZ_ALWAYS_TRUE(PBackgroundIDBVersionChangeTransactionChild::
                      SendDeleteMe());
  }
}

void
BackgroundVersionChangeTransactionChild::ActorDestroy(ActorDestroyReason aWhy)
{
  AssertIsOnOwningThread();

  MaybeCollectGarbageOnIPCMessage();

  mOpenDBRequest = nullptr;

  NoteActorDestroyed();
}

mozilla::ipc::IPCResult
BackgroundVersionChangeTransactionChild::RecvComplete(const nsresult& aResult)
{
  AssertIsOnOwningThread();

  MaybeCollectGarbageOnIPCMessage();

  if (!mTransaction) {
    return IPC_OK();
  }

  MOZ_ASSERT(mOpenDBRequest);

  IDBDatabase* database = mTransaction->Database();
  MOZ_ASSERT(database);

  database->ExitSetVersionTransaction();

  if (NS_FAILED(aResult)) {
    database->Close();
  }

  mTransaction->FireCompleteOrAbortEvents(aResult);

  mOpenDBRequest->SetTransaction(nullptr);
  mOpenDBRequest = nullptr;

  NoteComplete();
  return IPC_OK();
}

PBackgroundIDBRequestChild*
BackgroundVersionChangeTransactionChild::AllocPBackgroundIDBRequestChild(
                                                   const RequestParams& aParams)
{
  MOZ_CRASH("PBackgroundIDBRequestChild actors should be manually "
            "constructed!");
}

bool
BackgroundVersionChangeTransactionChild::DeallocPBackgroundIDBRequestChild(
                                             PBackgroundIDBRequestChild* aActor)
{
  MOZ_ASSERT(aActor);

  delete static_cast<BackgroundRequestChild*>(aActor);
  return true;
}

PBackgroundIDBCursorChild*
BackgroundVersionChangeTransactionChild::AllocPBackgroundIDBCursorChild(
                                                const OpenCursorParams& aParams)
{
  AssertIsOnOwningThread();

  MOZ_CRASH("PBackgroundIDBCursorChild actors should be manually constructed!");
}

bool
BackgroundVersionChangeTransactionChild::DeallocPBackgroundIDBCursorChild(
                                              PBackgroundIDBCursorChild* aActor)
{
  MOZ_ASSERT(aActor);

  delete static_cast<BackgroundCursorChild*>(aActor);
  return true;
}

/*******************************************************************************
 * BackgroundMutableFileChild
 ******************************************************************************/

BackgroundMutableFileChild::BackgroundMutableFileChild(const nsAString& aName,
                                                       const nsAString& aType)
  : mMutableFile(nullptr)
  , mName(aName)
  , mType(aType)
{
  // Can't assert owning thread here because IPDL has not yet set our manager!
  MOZ_COUNT_CTOR(indexedDB::BackgroundMutableFileChild);
}

BackgroundMutableFileChild::~BackgroundMutableFileChild()
{
  MOZ_COUNT_DTOR(indexedDB::BackgroundMutableFileChild);
}

#ifdef DEBUG

void
BackgroundMutableFileChild::AssertIsOnOwningThread() const
{
  static_cast<BackgroundDatabaseChild*>(Manager())->AssertIsOnOwningThread();
}

#endif // DEBUG

void
BackgroundMutableFileChild::EnsureDOMObject()
{
  AssertIsOnOwningThread();

  if (mTemporaryStrongMutableFile) {
    return;
  }

  auto database =
    static_cast<BackgroundDatabaseChild*>(Manager())->GetDOMObject();
  MOZ_ASSERT(database);

  mTemporaryStrongMutableFile =
    new IDBMutableFile(database, this, mName, mType);

  MOZ_ASSERT(mTemporaryStrongMutableFile);
  mTemporaryStrongMutableFile->AssertIsOnOwningThread();

  mMutableFile = mTemporaryStrongMutableFile;
}

void
BackgroundMutableFileChild::ReleaseDOMObject()
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(mTemporaryStrongMutableFile);
  mTemporaryStrongMutableFile->AssertIsOnOwningThread();
  MOZ_ASSERT(mMutableFile == mTemporaryStrongMutableFile);

  mTemporaryStrongMutableFile = nullptr;
}

void
BackgroundMutableFileChild::SendDeleteMeInternal()
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(!mTemporaryStrongMutableFile);

  if (mMutableFile) {
    mMutableFile->ClearBackgroundActor();
    mMutableFile = nullptr;

    MOZ_ALWAYS_TRUE(PBackgroundMutableFileChild::SendDeleteMe());
  }
}

void
BackgroundMutableFileChild::ActorDestroy(ActorDestroyReason aWhy)
{
  AssertIsOnOwningThread();

  if (mMutableFile) {
    mMutableFile->ClearBackgroundActor();
#ifdef DEBUG
    mMutableFile = nullptr;
#endif
  }
}

PBackgroundFileHandleChild*
BackgroundMutableFileChild::AllocPBackgroundFileHandleChild(
                                                          const FileMode& aMode)
{
  MOZ_CRASH("PBackgroundFileHandleChild actors should be manually "
            "constructed!");
}

bool
BackgroundMutableFileChild::DeallocPBackgroundFileHandleChild(
                                             PBackgroundFileHandleChild* aActor)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(aActor);

  delete static_cast<BackgroundFileHandleChild*>(aActor);
  return true;
}

/*******************************************************************************
 * BackgroundRequestChild
 ******************************************************************************/

BackgroundRequestChild::BackgroundRequestChild(IDBRequest* aRequest)
  : BackgroundRequestChildBase(aRequest)
  , mTransaction(aRequest->GetTransaction())
  , mRunningPreprocessHelpers(0)
  , mCurrentModuleSetIndex(0)
  , mPreprocessResultCode(NS_OK)
  , mGetAll(false)
{
  MOZ_ASSERT(mTransaction);
  mTransaction->AssertIsOnOwningThread();

  MOZ_COUNT_CTOR(indexedDB::BackgroundRequestChild);
}

BackgroundRequestChild::~BackgroundRequestChild()
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(!mTransaction);

  MOZ_COUNT_DTOR(indexedDB::BackgroundRequestChild);
}

void
BackgroundRequestChild::MaybeSendContinue()
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(mRunningPreprocessHelpers > 0);

  if (--mRunningPreprocessHelpers == 0) {
    PreprocessResponse response;

    if (NS_SUCCEEDED(mPreprocessResultCode)) {
      if (mGetAll) {
        response = ObjectStoreGetAllPreprocessResponse();
      } else {
        response = ObjectStoreGetPreprocessResponse();
      }
    } else {
      response = mPreprocessResultCode;
    }

    MOZ_ALWAYS_TRUE(SendContinue(response));
  }
}

void
BackgroundRequestChild::OnPreprocessFinished(
                                   uint32_t aModuleSetIndex,
                                   nsTArray<RefPtr<JS::WasmModule>>& aModuleSet)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(aModuleSetIndex < mPreprocessHelpers.Length());
  MOZ_ASSERT(!aModuleSet.IsEmpty());
  MOZ_ASSERT(mPreprocessHelpers[aModuleSetIndex]);
  MOZ_ASSERT(mModuleSets[aModuleSetIndex].IsEmpty());

  mModuleSets[aModuleSetIndex].SwapElements(aModuleSet);

  MaybeSendContinue();

  mPreprocessHelpers[aModuleSetIndex] = nullptr;
}

void
BackgroundRequestChild::OnPreprocessFailed(uint32_t aModuleSetIndex,
                                           nsresult aErrorCode)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(aModuleSetIndex < mPreprocessHelpers.Length());
  MOZ_ASSERT(NS_FAILED(aErrorCode));
  MOZ_ASSERT(mPreprocessHelpers[aModuleSetIndex]);
  MOZ_ASSERT(mModuleSets[aModuleSetIndex].IsEmpty());

  if (NS_SUCCEEDED(mPreprocessResultCode)) {
    mPreprocessResultCode = aErrorCode;
  }

  MaybeSendContinue();

  mPreprocessHelpers[aModuleSetIndex] = nullptr;
}

const nsTArray<RefPtr<JS::WasmModule>>*
BackgroundRequestChild::GetNextModuleSet(const StructuredCloneReadInfo& aInfo)
{
  if (!aInfo.mHasPreprocessInfo) {
    return nullptr;
  }

  MOZ_ASSERT(mCurrentModuleSetIndex < mModuleSets.Length());
  MOZ_ASSERT(!mModuleSets[mCurrentModuleSetIndex].IsEmpty());
  return &mModuleSets[mCurrentModuleSetIndex++];
}

void
BackgroundRequestChild::HandleResponse(nsresult aResponse)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(NS_FAILED(aResponse));
  MOZ_ASSERT(NS_ERROR_GET_MODULE(aResponse) == NS_ERROR_MODULE_DOM_INDEXEDDB);
  MOZ_ASSERT(mTransaction);

  DispatchErrorEvent(mRequest, aResponse, mTransaction);
}

void
BackgroundRequestChild::HandleResponse(const Key& aResponse)
{
  AssertIsOnOwningThread();

  ResultHelper helper(mRequest, mTransaction, &aResponse);

  DispatchSuccessEvent(&helper);
}

void
BackgroundRequestChild::HandleResponse(const nsTArray<Key>& aResponse)
{
  AssertIsOnOwningThread();

  ResultHelper helper(mRequest, mTransaction, &aResponse);

  DispatchSuccessEvent(&helper);
}

void
BackgroundRequestChild::HandleResponse(
                             const SerializedStructuredCloneReadInfo& aResponse)
{
  AssertIsOnOwningThread();

  // XXX Fix this somehow...
  auto& serializedCloneInfo =
    const_cast<SerializedStructuredCloneReadInfo&>(aResponse);

  StructuredCloneReadInfo cloneReadInfo(Move(serializedCloneInfo));

  DeserializeStructuredCloneFiles(mTransaction->Database(),
                                  aResponse.files(),
                                  GetNextModuleSet(cloneReadInfo),
                                  cloneReadInfo.mFiles);

  ResultHelper helper(mRequest, mTransaction, &cloneReadInfo);

  DispatchSuccessEvent(&helper);
}

void
BackgroundRequestChild::HandleResponse(
                   const nsTArray<SerializedStructuredCloneReadInfo>& aResponse)
{
  AssertIsOnOwningThread();

  nsTArray<StructuredCloneReadInfo> cloneReadInfos;

  if (!aResponse.IsEmpty()) {
    const uint32_t count = aResponse.Length();

    cloneReadInfos.SetCapacity(count);

    IDBDatabase* database = mTransaction->Database();

    for (uint32_t index = 0; index < count; index++) {
      // XXX Fix this somehow...
      auto& serializedCloneInfo =
        const_cast<SerializedStructuredCloneReadInfo&>(aResponse[index]);

      StructuredCloneReadInfo* cloneReadInfo = cloneReadInfos.AppendElement();

      // Move relevant data into the cloneReadInfo
      *cloneReadInfo = Move(serializedCloneInfo);

      // Get the files
      nsTArray<StructuredCloneFile> files;
      DeserializeStructuredCloneFiles(database,
                                      serializedCloneInfo.files(),
                                      GetNextModuleSet(*cloneReadInfo),
                                      files);

      cloneReadInfo->mFiles = Move(files);
    }
  }

  ResultHelper helper(mRequest, mTransaction, &cloneReadInfos);

  DispatchSuccessEvent(&helper);
}

void
BackgroundRequestChild::HandleResponse(JS::Handle<JS::Value> aResponse)
{
  AssertIsOnOwningThread();

  ResultHelper helper(mRequest, mTransaction, &aResponse);

  DispatchSuccessEvent(&helper);
}

void
BackgroundRequestChild::HandleResponse(uint64_t aResponse)
{
  AssertIsOnOwningThread();

  JS::Value response(JS::NumberValue(aResponse));

  ResultHelper helper(mRequest, mTransaction, &response);

  DispatchSuccessEvent(&helper);
}

nsresult
BackgroundRequestChild::HandlePreprocess(
                                const WasmModulePreprocessInfo& aPreprocessInfo)
{
  AssertIsOnOwningThread();

  IDBDatabase* database = mTransaction->Database();

  mPreprocessHelpers.SetLength(1);

  nsTArray<StructuredCloneFile> files;
  DeserializeStructuredCloneFiles(database,
                                  aPreprocessInfo.files(),
                                  nullptr,
                                  files);


  RefPtr<PreprocessHelper>& preprocessHelper = mPreprocessHelpers[0];
  preprocessHelper = new PreprocessHelper(0, this);

  nsresult rv = preprocessHelper->Init(files);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  rv = preprocessHelper->Dispatch();
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  mRunningPreprocessHelpers++;

  mModuleSets.SetLength(1);

  return NS_OK;
}

nsresult
BackgroundRequestChild::HandlePreprocess(
                     const nsTArray<WasmModulePreprocessInfo>& aPreprocessInfos)
{
  AssertIsOnOwningThread();

  IDBDatabase* database = mTransaction->Database();

  uint32_t count = aPreprocessInfos.Length();

  mPreprocessHelpers.SetLength(count);

  // TODO: Since we use the stream transport service, this can spawn 25 threads
  //       and has the potential to cause some annoying browser hiccups.
  //       Consider using a single thread or a very small threadpool.
  for (uint32_t index = 0; index < count; index++) {
    const WasmModulePreprocessInfo& preprocessInfo = aPreprocessInfos[index];

    nsTArray<StructuredCloneFile> files;
    DeserializeStructuredCloneFiles(database,
                                    preprocessInfo.files(),
                                    nullptr,
                                    files);


    RefPtr<PreprocessHelper>& preprocessHelper = mPreprocessHelpers[index];
    preprocessHelper = new PreprocessHelper(index, this);

    nsresult rv = preprocessHelper->Init(files);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return rv;
    }

    rv = preprocessHelper->Dispatch();
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return rv;
    }

    mRunningPreprocessHelpers++;
  }

  mModuleSets.SetLength(count);

  mGetAll = true;

  return NS_OK;
}

void
BackgroundRequestChild::ActorDestroy(ActorDestroyReason aWhy)
{
  AssertIsOnOwningThread();

  MaybeCollectGarbageOnIPCMessage();

  for (uint32_t count = mPreprocessHelpers.Length(), index = 0;
       index < count;
       index++) {
    RefPtr<PreprocessHelper>& preprocessHelper = mPreprocessHelpers[index];

    if (preprocessHelper) {
      preprocessHelper->ClearActor();

      preprocessHelper = nullptr;
    }
  }

  if (mTransaction) {
    mTransaction->AssertIsOnOwningThread();

    mTransaction->OnRequestFinished(/* aActorDestroyedNormally */
                                    aWhy == Deletion);
#ifdef DEBUG
    mTransaction = nullptr;
#endif
  }
}

mozilla::ipc::IPCResult
BackgroundRequestChild::Recv__delete__(const RequestResponse& aResponse)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(mRequest);
  MOZ_ASSERT(mTransaction);

  MaybeCollectGarbageOnIPCMessage();

  if (mTransaction->IsAborted()) {
    // Always fire an "error" event with ABORT_ERR if the transaction was
    // aborted, even if the request succeeded or failed with another error.
    HandleResponse(NS_ERROR_DOM_INDEXEDDB_ABORT_ERR);
  } else {
    switch (aResponse.type()) {
      case RequestResponse::Tnsresult:
        HandleResponse(aResponse.get_nsresult());
        break;

      case RequestResponse::TObjectStoreAddResponse:
        HandleResponse(aResponse.get_ObjectStoreAddResponse().key());
        break;

      case RequestResponse::TObjectStorePutResponse:
        HandleResponse(aResponse.get_ObjectStorePutResponse().key());
        break;

      case RequestResponse::TObjectStoreGetResponse:
        HandleResponse(aResponse.get_ObjectStoreGetResponse().cloneInfo());
        break;

      case RequestResponse::TObjectStoreGetKeyResponse:
        HandleResponse(aResponse.get_ObjectStoreGetKeyResponse().key());
        break;

      case RequestResponse::TObjectStoreGetAllResponse:
        HandleResponse(aResponse.get_ObjectStoreGetAllResponse().cloneInfos());
        break;

      case RequestResponse::TObjectStoreGetAllKeysResponse:
        HandleResponse(aResponse.get_ObjectStoreGetAllKeysResponse().keys());
        break;

      case RequestResponse::TObjectStoreDeleteResponse:
        HandleResponse(JS::UndefinedHandleValue);
        break;

      case RequestResponse::TObjectStoreClearResponse:
        HandleResponse(JS::UndefinedHandleValue);
        break;

      case RequestResponse::TObjectStoreCountResponse:
        HandleResponse(aResponse.get_ObjectStoreCountResponse().count());
        break;

      case RequestResponse::TIndexGetResponse:
        HandleResponse(aResponse.get_IndexGetResponse().cloneInfo());
        break;

      case RequestResponse::TIndexGetKeyResponse:
        HandleResponse(aResponse.get_IndexGetKeyResponse().key());
        break;

      case RequestResponse::TIndexGetAllResponse:
        HandleResponse(aResponse.get_IndexGetAllResponse().cloneInfos());
        break;

      case RequestResponse::TIndexGetAllKeysResponse:
        HandleResponse(aResponse.get_IndexGetAllKeysResponse().keys());
        break;

      case RequestResponse::TIndexCountResponse:
        HandleResponse(aResponse.get_IndexCountResponse().count());
        break;

      default:
        MOZ_CRASH("Unknown response type!");
    }
  }

  mTransaction->OnRequestFinished(/* aActorDestroyedNormally */ true);

  // Null this out so that we don't try to call OnRequestFinished() again in
  // ActorDestroy.
  mTransaction = nullptr;

  return IPC_OK();
}

mozilla::ipc::IPCResult
BackgroundRequestChild::RecvPreprocess(const PreprocessParams& aParams)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(mTransaction);

  MaybeCollectGarbageOnIPCMessage();

  nsresult rv;

  switch (aParams.type()) {
    case PreprocessParams::TObjectStoreGetPreprocessParams: {
      ObjectStoreGetPreprocessParams params =
        aParams.get_ObjectStoreGetPreprocessParams();

      rv = HandlePreprocess(params.preprocessInfo());

      break;
    }

    case PreprocessParams::TObjectStoreGetAllPreprocessParams: {
      ObjectStoreGetAllPreprocessParams params =
        aParams.get_ObjectStoreGetAllPreprocessParams();

      rv = HandlePreprocess(params.preprocessInfos());

      break;
    }

    default:
      MOZ_CRASH("Unknown params type!");
  }

  if (NS_WARN_IF(NS_FAILED(rv))) {
    if (!SendContinue(rv)) {
      return IPC_FAIL_NO_REASON(this);
    }
    return IPC_OK();
  }

  return IPC_OK();
}

nsresult
BackgroundRequestChild::
PreprocessHelper::Init(const nsTArray<StructuredCloneFile>& aFiles)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(!aFiles.IsEmpty());

  uint32_t count = aFiles.Length();

  // We should receive even number of files.
  MOZ_ASSERT(count % 2 == 0);

  // Let's process it as pairs.
  count = count / 2;

  nsTArray<StreamPair> streamPairs;
  for (uint32_t index = 0; index < count; index++) {
    uint32_t bytecodeIndex = index * 2;
    uint32_t compiledIndex = bytecodeIndex + 1;

    const StructuredCloneFile& bytecodeFile = aFiles[bytecodeIndex];
    const StructuredCloneFile& compiledFile = aFiles[compiledIndex];

    MOZ_ASSERT(bytecodeFile.mType == StructuredCloneFile::eWasmBytecode);
    MOZ_ASSERT(bytecodeFile.mBlob);
    MOZ_ASSERT(compiledFile.mType == StructuredCloneFile::eWasmCompiled);
    MOZ_ASSERT(compiledFile.mBlob);

    ErrorResult errorResult;

    nsCOMPtr<nsIInputStream> bytecodeStream;
    bytecodeFile.mBlob->GetInternalStream(getter_AddRefs(bytecodeStream),
                                          errorResult);
    if (NS_WARN_IF(errorResult.Failed())) {
      return errorResult.StealNSResult();
    }

    nsCOMPtr<nsIInputStream> compiledStream;
    compiledFile.mBlob->GetInternalStream(getter_AddRefs(compiledStream),
                                          errorResult);
    if (NS_WARN_IF(errorResult.Failed())) {
      return errorResult.StealNSResult();
    }

    streamPairs.AppendElement(StreamPair(bytecodeStream, compiledStream));
  }

  mStreamPairs = Move(streamPairs);

  return NS_OK;
}

nsresult
BackgroundRequestChild::
PreprocessHelper::Dispatch()
{
  AssertIsOnOwningThread();

  if (!mTaskQueue) {
    // The stream transport service is used for asynchronous processing. It has
    // a threadpool with a high cap of 25 threads. Fortunately, the service can
    // be used on workers too.
    nsCOMPtr<nsIEventTarget> target =
      do_GetService(NS_STREAMTRANSPORTSERVICE_CONTRACTID);
    MOZ_ASSERT(target);

    // We use a TaskQueue here in order to be sure that the events are
    // dispatched in the correct order. This is not guaranteed in case we use
    // the I/O thread directly.
    mTaskQueue = new TaskQueue(target.forget());
    mTaskQueueEventTarget = mTaskQueue->WrapAsEventTarget();
  }

  nsresult rv = mTaskQueueEventTarget->Dispatch(this, NS_DISPATCH_NORMAL);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  return NS_OK;
}

void
BackgroundRequestChild::
PreprocessHelper::RunOnOwningThread()
{
  AssertIsOnOwningThread();

  if (mActor) {
    if (NS_SUCCEEDED(mResultCode)) {
      mActor->OnPreprocessFinished(mModuleSetIndex, mModuleSet);

      MOZ_ASSERT(mModuleSet.IsEmpty());
    } else {
      mActor->OnPreprocessFailed(mModuleSetIndex, mResultCode);
    }
  }
}

void
BackgroundRequestChild::
PreprocessHelper::ProcessCurrentStreamPair()
{
  MOZ_ASSERT(!IsOnOwningThread());
  MOZ_ASSERT(!mStreamPairs.IsEmpty());

  nsresult rv;

  const StreamPair& streamPair = mStreamPairs[0];

  // We still don't have the current bytecode FileDesc.
  if (!mCurrentBytecodeFileDesc) {
    const nsCOMPtr<nsIInputStream>& bytecodeStream = streamPair.first;
    MOZ_ASSERT(bytecodeStream);

    mCurrentBytecodeFileDesc = GetFileDescriptorFromStream(bytecodeStream);
    if (!mCurrentBytecodeFileDesc) {
      rv = WaitForStreamReady(bytecodeStream);
      if (NS_WARN_IF(NS_FAILED(rv))) {
        ContinueWithStatus(rv);
      }
      return;
    }
  }

  if (!mCurrentCompiledFileDesc) {
    const nsCOMPtr<nsIInputStream>& compiledStream = streamPair.second;
    MOZ_ASSERT(compiledStream);

    mCurrentCompiledFileDesc = GetFileDescriptorFromStream(compiledStream);
    if (!mCurrentCompiledFileDesc) {
      rv = WaitForStreamReady(compiledStream);
      if (NS_WARN_IF(NS_FAILED(rv))) {
        ContinueWithStatus(rv);
      }
      return;
    }
  }

  MOZ_ASSERT(mCurrentBytecodeFileDesc && mCurrentCompiledFileDesc);

  JS::BuildIdCharVector buildId;
  bool ok = GetBuildId(&buildId);
  if (NS_WARN_IF(!ok)) {
    ContinueWithStatus(NS_ERROR_FAILURE);
    return;
  }

  RefPtr<JS::WasmModule> module =
    JS::DeserializeWasmModule(mCurrentBytecodeFileDesc,
                              mCurrentCompiledFileDesc,
                              Move(buildId),
                              nullptr,
                              0,
                              0);
  if (NS_WARN_IF(!module)) {
    ContinueWithStatus(NS_ERROR_FAILURE);
    return;
  }

  mModuleSet.AppendElement(module);
  mStreamPairs.RemoveElementAt(0);

  ContinueWithStatus(NS_OK);
}

nsresult
BackgroundRequestChild::
PreprocessHelper::WaitForStreamReady(nsIInputStream* aInputStream)
{
  MOZ_ASSERT(!IsOnOwningThread());
  MOZ_ASSERT(aInputStream);

  nsCOMPtr<nsIAsyncInputStream> asyncStream = do_QueryInterface(aInputStream);
  if (!asyncStream) {
    return NS_ERROR_NO_INTERFACE;
  }

  nsresult rv = asyncStream->AsyncWait(this, 0, 0, mTaskQueueEventTarget);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  return NS_OK;
}

void
BackgroundRequestChild::
PreprocessHelper::ContinueWithStatus(nsresult aStatus)
{
  MOZ_ASSERT(!IsOnOwningThread());

  // Let's reset the value for the next operation.
  mCurrentBytecodeFileDesc = nullptr;
  mCurrentCompiledFileDesc = nullptr;

  nsCOMPtr<nsIEventTarget> eventTarget;

  if (NS_WARN_IF(NS_FAILED(aStatus))) {
    // If the previous operation failed, we don't continue the processing of the
    // other stream pairs.
    MOZ_ASSERT(mResultCode == NS_OK);
    mResultCode = aStatus;

    eventTarget = mOwningEventTarget;
  } else if (mStreamPairs.IsEmpty()) {
    // If all the streams have been processed, we can go back to the owning
    // thread.
    eventTarget = mOwningEventTarget;
  } else {
    // Continue the processing.
    eventTarget = mTaskQueueEventTarget;
  }

  nsresult rv = eventTarget->Dispatch(this, NS_DISPATCH_NORMAL);
  Unused <<  NS_WARN_IF(NS_FAILED(rv));
}

NS_IMPL_ISUPPORTS_INHERITED(BackgroundRequestChild::PreprocessHelper,
                            CancelableRunnable, nsIInputStreamCallback)

NS_IMETHODIMP
BackgroundRequestChild::
PreprocessHelper::Run()
{
  if (IsOnOwningThread()) {
    RunOnOwningThread();
  } else {
    ProcessCurrentStreamPair();
  }

  return NS_OK;
}

NS_IMETHODIMP
BackgroundRequestChild::
PreprocessHelper::OnInputStreamReady(nsIAsyncInputStream* aStream)
{
  MOZ_ASSERT(!IsOnOwningThread());
  MOZ_ASSERT(aStream);
  MOZ_ASSERT(!mStreamPairs.IsEmpty());

  // We still don't have the current bytecode FileDesc.
  if (!mCurrentBytecodeFileDesc) {
    mCurrentBytecodeFileDesc = GetFileDescriptorFromStream(aStream);
    if (!mCurrentBytecodeFileDesc) {
      ContinueWithStatus(NS_ERROR_FAILURE);
      return NS_OK;
    }

    // Let's continue with the processing of the current pair.
    ProcessCurrentStreamPair();
    return NS_OK;
  }

  if (!mCurrentCompiledFileDesc) {
    mCurrentCompiledFileDesc = GetFileDescriptorFromStream(aStream);
    if (!mCurrentCompiledFileDesc) {
      ContinueWithStatus(NS_ERROR_FAILURE);
      return NS_OK;
    }

    // Let's continue with the processing of the current pair.
    ProcessCurrentStreamPair();
    return NS_OK;
  }

  MOZ_CRASH("If we have both fileDescs why are we here?");
}

nsresult
BackgroundRequestChild::
PreprocessHelper::Cancel()
{
  return NS_OK;
}

/*******************************************************************************
 * BackgroundCursorChild
 ******************************************************************************/

// Does not need to be threadsafe since this only runs on one thread, but
// inheriting from CancelableRunnable is easy.
class BackgroundCursorChild::DelayedActionRunnable final
  : public CancelableRunnable
{
  using ActionFunc = void (BackgroundCursorChild::*)();

  BackgroundCursorChild* mActor;
  RefPtr<IDBRequest> mRequest;
  ActionFunc mActionFunc;

public:
  explicit
  DelayedActionRunnable(BackgroundCursorChild* aActor, ActionFunc aActionFunc)
    : CancelableRunnable("indexedDB::BackgroundCursorChild::DelayedActionRunnable")
    , mActor(aActor)
    , mRequest(aActor->mRequest)
    , mActionFunc(aActionFunc)
  {
    MOZ_ASSERT(aActor);
    aActor->AssertIsOnOwningThread();
    MOZ_ASSERT(mRequest);
    MOZ_ASSERT(mActionFunc);
  }

private:
  ~DelayedActionRunnable()
  { }

  NS_DECL_NSIRUNNABLE
  nsresult Cancel() override;
};

BackgroundCursorChild::BackgroundCursorChild(IDBRequest* aRequest,
                                             IDBObjectStore* aObjectStore,
                                             Direction aDirection)
  : mRequest(aRequest)
  , mTransaction(aRequest->GetTransaction())
  , mObjectStore(aObjectStore)
  , mIndex(nullptr)
  , mCursor(nullptr)
  , mStrongRequest(aRequest)
  , mDirection(aDirection)
{
  MOZ_ASSERT(aObjectStore);
  aObjectStore->AssertIsOnOwningThread();
  MOZ_ASSERT(mTransaction);

  MOZ_COUNT_CTOR(indexedDB::BackgroundCursorChild);
}

BackgroundCursorChild::BackgroundCursorChild(IDBRequest* aRequest,
                                             IDBIndex* aIndex,
                                             Direction aDirection)
  : mRequest(aRequest)
  , mTransaction(aRequest->GetTransaction())
  , mObjectStore(nullptr)
  , mIndex(aIndex)
  , mCursor(nullptr)
  , mStrongRequest(aRequest)
  , mDirection(aDirection)
{
  MOZ_ASSERT(aIndex);
  aIndex->AssertIsOnOwningThread();
  MOZ_ASSERT(mTransaction);

  MOZ_COUNT_CTOR(indexedDB::BackgroundCursorChild);
}

BackgroundCursorChild::~BackgroundCursorChild()
{
  MOZ_COUNT_DTOR(indexedDB::BackgroundCursorChild);
}

void
BackgroundCursorChild::SendContinueInternal(const CursorRequestParams& aParams)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(mRequest);
  MOZ_ASSERT(mTransaction);
  MOZ_ASSERT(mCursor);
  MOZ_ASSERT(!mStrongRequest);
  MOZ_ASSERT(!mStrongCursor);

  // Make sure all our DOM objects stay alive.
  mStrongCursor = mCursor;

  MOZ_ASSERT(mRequest->ReadyState() == IDBRequestReadyState::Done);
  mRequest->Reset();

  mTransaction->OnNewRequest();

  MOZ_ALWAYS_TRUE(PBackgroundIDBCursorChild::SendContinue(aParams));
}

void
BackgroundCursorChild::SendDeleteMeInternal()
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(!mStrongRequest);
  MOZ_ASSERT(!mStrongCursor);

  mRequest = nullptr;
  mTransaction = nullptr;
  mObjectStore = nullptr;
  mIndex = nullptr;

  if (mCursor) {
    mCursor->ClearBackgroundActor();
    mCursor = nullptr;

    MOZ_ALWAYS_TRUE(PBackgroundIDBCursorChild::SendDeleteMe());
  }
}

void
BackgroundCursorChild::HandleResponse(nsresult aResponse)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(NS_FAILED(aResponse));
  MOZ_ASSERT(NS_ERROR_GET_MODULE(aResponse) == NS_ERROR_MODULE_DOM_INDEXEDDB);
  MOZ_ASSERT(mRequest);
  MOZ_ASSERT(mTransaction);
  MOZ_ASSERT(!mStrongRequest);
  MOZ_ASSERT(!mStrongCursor);

  DispatchErrorEvent(mRequest, aResponse, mTransaction);
}

void
BackgroundCursorChild::HandleResponse(const void_t& aResponse)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(mRequest);
  MOZ_ASSERT(mTransaction);
  MOZ_ASSERT(!mStrongRequest);
  MOZ_ASSERT(!mStrongCursor);

  if (mCursor) {
    mCursor->Reset();
  }

  ResultHelper helper(mRequest, mTransaction, &JS::NullHandleValue);
  DispatchSuccessEvent(&helper);

  if (!mCursor) {
    nsCOMPtr<nsIRunnable> deleteRunnable = new DelayedActionRunnable(
      this, &BackgroundCursorChild::SendDeleteMeInternal);
      MOZ_ALWAYS_SUCCEEDS(this->GetActorEventTarget()->
        Dispatch(deleteRunnable.forget(), NS_DISPATCH_NORMAL));
  }
}

void
BackgroundCursorChild::HandleResponse(
    const nsTArray<ObjectStoreCursorResponse>& aResponses)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(mRequest);
  MOZ_ASSERT(mTransaction);
  MOZ_ASSERT(mObjectStore);
  MOZ_ASSERT(!mStrongRequest);
  MOZ_ASSERT(!mStrongCursor);

  MOZ_ASSERT(aResponses.Length() == 1);

  // XXX Fix this somehow...
  auto& responses =
    const_cast<nsTArray<ObjectStoreCursorResponse>&>(aResponses);

  for (ObjectStoreCursorResponse& response : responses) {
    StructuredCloneReadInfo cloneReadInfo(Move(response.cloneInfo()));
    cloneReadInfo.mDatabase = mTransaction->Database();

    DeserializeStructuredCloneFiles(mTransaction->Database(),
                                    response.cloneInfo().files(),
                                    nullptr,
                                    cloneReadInfo.mFiles);

    RefPtr<IDBCursor> newCursor;

    if (mCursor) {
      mCursor->Reset(Move(response.key()), Move(cloneReadInfo));
    } else {
      newCursor = IDBCursor::Create(this,
                                    Move(response.key()),
                                    Move(cloneReadInfo));
      mCursor = newCursor;
    }
  }

  ResultHelper helper(mRequest, mTransaction, mCursor);
  DispatchSuccessEvent(&helper);
}

void
BackgroundCursorChild::HandleResponse(
                                  const ObjectStoreKeyCursorResponse& aResponse)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(mRequest);
  MOZ_ASSERT(mTransaction);
  MOZ_ASSERT(mObjectStore);
  MOZ_ASSERT(!mStrongRequest);
  MOZ_ASSERT(!mStrongCursor);

  // XXX Fix this somehow...
  auto& response = const_cast<ObjectStoreKeyCursorResponse&>(aResponse);

  RefPtr<IDBCursor> newCursor;

  if (mCursor) {
    mCursor->Reset(Move(response.key()));
  } else {
    newCursor = IDBCursor::Create(this, Move(response.key()));
    mCursor = newCursor;
  }

  ResultHelper helper(mRequest, mTransaction, mCursor);
  DispatchSuccessEvent(&helper);
}

void
BackgroundCursorChild::HandleResponse(const IndexCursorResponse& aResponse)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(mRequest);
  MOZ_ASSERT(mTransaction);
  MOZ_ASSERT(mIndex);
  MOZ_ASSERT(!mStrongRequest);
  MOZ_ASSERT(!mStrongCursor);

  // XXX Fix this somehow...
  auto& response = const_cast<IndexCursorResponse&>(aResponse);

  StructuredCloneReadInfo cloneReadInfo(Move(response.cloneInfo()));
  cloneReadInfo.mDatabase = mTransaction->Database();

  DeserializeStructuredCloneFiles(mTransaction->Database(),
                                  aResponse.cloneInfo().files(),
                                  nullptr,
                                  cloneReadInfo.mFiles);

  RefPtr<IDBCursor> newCursor;

  if (mCursor) {
    mCursor->Reset(Move(response.key()),
                   Move(response.sortKey()),
                   Move(response.objectKey()),
                   Move(cloneReadInfo));
  } else {
    newCursor = IDBCursor::Create(this,
                                  Move(response.key()),
                                  Move(response.sortKey()),
                                  Move(response.objectKey()),
                                  Move(cloneReadInfo));
    mCursor = newCursor;
  }

  ResultHelper helper(mRequest, mTransaction, mCursor);
  DispatchSuccessEvent(&helper);
}

void
BackgroundCursorChild::HandleResponse(const IndexKeyCursorResponse& aResponse)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(mRequest);
  MOZ_ASSERT(mTransaction);
  MOZ_ASSERT(mIndex);
  MOZ_ASSERT(!mStrongRequest);
  MOZ_ASSERT(!mStrongCursor);

  // XXX Fix this somehow...
  auto& response = const_cast<IndexKeyCursorResponse&>(aResponse);

  RefPtr<IDBCursor> newCursor;

  if (mCursor) {
    mCursor->Reset(Move(response.key()),
                   Move(response.sortKey()),
                   Move(response.objectKey()));
  } else {
    newCursor = IDBCursor::Create(this,
                                  Move(response.key()),
                                  Move(response.sortKey()),
                                  Move(response.objectKey()));
    mCursor = newCursor;
  }

  ResultHelper helper(mRequest, mTransaction, mCursor);
  DispatchSuccessEvent(&helper);
}

void
BackgroundCursorChild::ActorDestroy(ActorDestroyReason aWhy)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT_IF(aWhy == Deletion, !mStrongRequest);
  MOZ_ASSERT_IF(aWhy == Deletion, !mStrongCursor);

  MaybeCollectGarbageOnIPCMessage();

  if (mStrongRequest && !mStrongCursor && mTransaction) {
    mTransaction->OnRequestFinished(/* aActorDestroyedNormally */
                                    aWhy == Deletion);
  }

  if (mCursor) {
    mCursor->ClearBackgroundActor();
#ifdef DEBUG
    mCursor = nullptr;
#endif
  }

#ifdef DEBUG
  mRequest = nullptr;
  mTransaction = nullptr;
  mObjectStore = nullptr;
  mIndex = nullptr;
#endif
}

mozilla::ipc::IPCResult
BackgroundCursorChild::RecvResponse(const CursorResponse& aResponse)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(aResponse.type() != CursorResponse::T__None);
  MOZ_ASSERT(mRequest);
  MOZ_ASSERT(mTransaction);
  MOZ_ASSERT_IF(mCursor, mStrongCursor);
  MOZ_ASSERT_IF(!mCursor, mStrongRequest);

  MaybeCollectGarbageOnIPCMessage();

  RefPtr<IDBRequest> request;
  mStrongRequest.swap(request);

  RefPtr<IDBCursor> cursor;
  mStrongCursor.swap(cursor);

  switch (aResponse.type()) {
    case CursorResponse::Tnsresult:
      HandleResponse(aResponse.get_nsresult());
      break;

    case CursorResponse::Tvoid_t:
      HandleResponse(aResponse.get_void_t());
      break;

    case CursorResponse::TArrayOfObjectStoreCursorResponse:
      HandleResponse(aResponse.get_ArrayOfObjectStoreCursorResponse());
      break;

    case CursorResponse::TObjectStoreKeyCursorResponse:
      HandleResponse(aResponse.get_ObjectStoreKeyCursorResponse());
      break;

    case CursorResponse::TIndexCursorResponse:
      HandleResponse(aResponse.get_IndexCursorResponse());
      break;

    case CursorResponse::TIndexKeyCursorResponse:
      HandleResponse(aResponse.get_IndexKeyCursorResponse());
      break;

    default:
      MOZ_CRASH("Should never get here!");
  }

  mTransaction->OnRequestFinished(/* aActorDestroyedNormally */ true);

  return IPC_OK();
}

NS_IMETHODIMP
BackgroundCursorChild::
DelayedActionRunnable::Run()
{
  MOZ_ASSERT(mActor);
  mActor->AssertIsOnOwningThread();
  MOZ_ASSERT(mRequest);
  MOZ_ASSERT(mActionFunc);

  (mActor->*mActionFunc)();

  mActor = nullptr;
  mRequest = nullptr;

  return NS_OK;
}

nsresult
BackgroundCursorChild::
DelayedActionRunnable::Cancel()
{
  if (NS_WARN_IF(!mActor)) {
    return NS_ERROR_UNEXPECTED;
  }

  // This must always run to clean up our state.
  Run();

  return NS_OK;
}

/*******************************************************************************
 * BackgroundFileHandleChild
 ******************************************************************************/

BackgroundFileHandleChild::BackgroundFileHandleChild(IDBFileHandle* aFileHandle)
  : mTemporaryStrongFileHandle(aFileHandle)
  , mFileHandle(aFileHandle)
{
  MOZ_ASSERT(aFileHandle);
  aFileHandle->AssertIsOnOwningThread();

  MOZ_COUNT_CTOR(BackgroundFileHandleChild);
}

BackgroundFileHandleChild::~BackgroundFileHandleChild()
{
  AssertIsOnOwningThread();

  MOZ_COUNT_DTOR(BackgroundFileHandleChild);
}

#ifdef DEBUG

void
BackgroundFileHandleChild::AssertIsOnOwningThread() const
{
  static_cast<BackgroundMutableFileChild*>(Manager())->AssertIsOnOwningThread();
}

#endif // DEBUG

void
BackgroundFileHandleChild::SendDeleteMeInternal()
{
  AssertIsOnOwningThread();

  if (mFileHandle) {
    NoteActorDestroyed();

    MOZ_ALWAYS_TRUE(PBackgroundFileHandleChild::SendDeleteMe());
  }
}

void
BackgroundFileHandleChild::NoteActorDestroyed()
{
  AssertIsOnOwningThread();
  MOZ_ASSERT_IF(mTemporaryStrongFileHandle, mFileHandle);

  if (mFileHandle) {
    mFileHandle->ClearBackgroundActor();

    // Normally this would be DEBUG-only but NoteActorDestroyed is also called
    // from SendDeleteMeInternal. In that case we're going to receive an actual
    // ActorDestroy call later and we don't want to touch a dead object.
    mTemporaryStrongFileHandle = nullptr;
    mFileHandle = nullptr;
  }
}

void
BackgroundFileHandleChild::NoteComplete()
{
  AssertIsOnOwningThread();
  MOZ_ASSERT_IF(mFileHandle, mTemporaryStrongFileHandle);

  mTemporaryStrongFileHandle = nullptr;
}

void
BackgroundFileHandleChild::ActorDestroy(ActorDestroyReason aWhy)
{
  AssertIsOnOwningThread();

  NoteActorDestroyed();
}

mozilla::ipc::IPCResult
BackgroundFileHandleChild::RecvComplete(const bool& aAborted)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(mFileHandle);

  mFileHandle->FireCompleteOrAbortEvents(aAborted);

  NoteComplete();
  return IPC_OK();
}

PBackgroundFileRequestChild*
BackgroundFileHandleChild::AllocPBackgroundFileRequestChild(
                                               const FileRequestParams& aParams)
{
  MOZ_CRASH("PBackgroundFileRequestChild actors should be manually "
            "constructed!");
}

bool
BackgroundFileHandleChild::DeallocPBackgroundFileRequestChild(
                                            PBackgroundFileRequestChild* aActor)
{
  MOZ_ASSERT(aActor);

  delete static_cast<BackgroundFileRequestChild*>(aActor);
  return true;
}

/*******************************************************************************
 * BackgroundFileRequestChild
 ******************************************************************************/

BackgroundFileRequestChild::BackgroundFileRequestChild(
                                                   IDBFileRequest* aFileRequest)
  : mFileRequest(aFileRequest)
  , mFileHandle(aFileRequest->GetFileHandle())
  , mActorDestroyed(false)
{
  MOZ_ASSERT(aFileRequest);
  aFileRequest->AssertIsOnOwningThread();
  MOZ_ASSERT(mFileHandle);
  mFileHandle->AssertIsOnOwningThread();

  MOZ_COUNT_CTOR(BackgroundFileRequestChild);
}

BackgroundFileRequestChild::~BackgroundFileRequestChild()
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(!mFileHandle);

  MOZ_COUNT_DTOR(BackgroundFileRequestChild);
}

#ifdef DEBUG

void
BackgroundFileRequestChild::AssertIsOnOwningThread() const
{
  MOZ_ASSERT(mFileRequest);
  mFileRequest->AssertIsOnOwningThread();
}

#endif // DEBUG

void
BackgroundFileRequestChild::HandleResponse(nsresult aResponse)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(NS_FAILED(aResponse));
  MOZ_ASSERT(NS_ERROR_GET_MODULE(aResponse) == NS_ERROR_MODULE_DOM_FILEHANDLE);
  MOZ_ASSERT(mFileHandle);

  DispatchFileHandleErrorEvent(mFileRequest, aResponse, mFileHandle);
}

void
BackgroundFileRequestChild::HandleResponse(
                                    const FileRequestGetFileResponse& aResponse)
{
  AssertIsOnOwningThread();

  RefPtr<File> file = ConvertActorToFile(mFileHandle, aResponse);

  FileHandleResultHelper helper(mFileRequest, mFileHandle, file);

  DispatchFileHandleSuccessEvent(&helper);
}

void
BackgroundFileRequestChild::HandleResponse(const nsCString& aResponse)
{
  AssertIsOnOwningThread();

  FileHandleResultHelper helper(mFileRequest, mFileHandle, &aResponse);

  DispatchFileHandleSuccessEvent(&helper);
}

void
BackgroundFileRequestChild::HandleResponse(const FileRequestMetadata& aResponse)
{
  AssertIsOnOwningThread();

  FileHandleResultHelper helper(mFileRequest, mFileHandle, &aResponse);

  DispatchFileHandleSuccessEvent(&helper);
}

void
BackgroundFileRequestChild::HandleResponse(JS::Handle<JS::Value> aResponse)
{
  AssertIsOnOwningThread();

  FileHandleResultHelper helper(mFileRequest, mFileHandle, &aResponse);

  DispatchFileHandleSuccessEvent(&helper);
}

void
BackgroundFileRequestChild::ActorDestroy(ActorDestroyReason aWhy)
{
  AssertIsOnOwningThread();

  MOZ_ASSERT(!mActorDestroyed);

  mActorDestroyed = true;

  if (mFileHandle) {
    mFileHandle->AssertIsOnOwningThread();

    mFileHandle->OnRequestFinished(/* aActorDestroyedNormally */
                                   aWhy == Deletion);

#ifdef DEBUG
    mFileHandle = nullptr;
#endif
  }
}

mozilla::ipc::IPCResult
BackgroundFileRequestChild::Recv__delete__(const FileRequestResponse& aResponse)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(mFileRequest);
  MOZ_ASSERT(mFileHandle);

  if (mFileHandle->IsAborted()) {
    // Always handle an "error" with ABORT_ERR if the file handle was aborted,
    // even if the request succeeded or failed with another error.
    HandleResponse(NS_ERROR_DOM_FILEHANDLE_ABORT_ERR);
  } else {
    switch (aResponse.type()) {
      case FileRequestResponse::Tnsresult:
        HandleResponse(aResponse.get_nsresult());
        break;

      case FileRequestResponse::TFileRequestGetFileResponse:
        HandleResponse(aResponse.get_FileRequestGetFileResponse());
        break;

      case FileRequestResponse::TFileRequestReadResponse:
        HandleResponse(aResponse.get_FileRequestReadResponse().data());
        break;

      case FileRequestResponse::TFileRequestWriteResponse:
        HandleResponse(JS::UndefinedHandleValue);
        break;

      case FileRequestResponse::TFileRequestTruncateResponse:
        HandleResponse(JS::UndefinedHandleValue);
        break;

      case FileRequestResponse::TFileRequestFlushResponse:
        HandleResponse(JS::UndefinedHandleValue);
        break;

      case FileRequestResponse::TFileRequestGetMetadataResponse:
        HandleResponse(aResponse.get_FileRequestGetMetadataResponse()
                                .metadata());
        break;

      default:
        MOZ_CRASH("Unknown response type!");
    }
  }

  mFileHandle->OnRequestFinished(/* aActorDestroyedNormally */ true);

  // Null this out so that we don't try to call OnRequestFinished() again in
  // ActorDestroy.
  mFileHandle = nullptr;

  return IPC_OK();
}

mozilla::ipc::IPCResult
BackgroundFileRequestChild::RecvProgress(const uint64_t& aProgress,
                                         const uint64_t& aProgressMax)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(mFileRequest);

  mFileRequest->FireProgressEvent(aProgress, aProgressMax);

  return IPC_OK();
}

/*******************************************************************************
 * BackgroundUtilsChild
 ******************************************************************************/

BackgroundUtilsChild::BackgroundUtilsChild(IndexedDatabaseManager* aManager)
  : mManager(aManager)
{
  AssertIsOnOwningThread();
  MOZ_ASSERT(aManager);

  MOZ_COUNT_CTOR(indexedDB::BackgroundUtilsChild);
}

BackgroundUtilsChild::~BackgroundUtilsChild()
{
  MOZ_COUNT_DTOR(indexedDB::BackgroundUtilsChild);
}

void
BackgroundUtilsChild::SendDeleteMeInternal()
{
  AssertIsOnOwningThread();

  if (mManager) {
    mManager->ClearBackgroundActor();
    mManager = nullptr;

    MOZ_ALWAYS_TRUE(PBackgroundIndexedDBUtilsChild::SendDeleteMe());
  }
}

void
BackgroundUtilsChild::ActorDestroy(ActorDestroyReason aWhy)
{
  AssertIsOnOwningThread();

  if (mManager) {
    mManager->ClearBackgroundActor();
#ifdef DEBUG
    mManager = nullptr;
#endif
  }
}

} // namespace indexedDB
} // namespace dom
} // namespace mozilla
