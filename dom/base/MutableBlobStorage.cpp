/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/dom/MutableBlobStorage.h"
#include "mozilla/CheckedInt.h"
#include "mozilla/dom/File.h"
#include "nsAnonymousTemporaryFile.h"
#include "nsNetCID.h"
#include "WorkerPrivate.h"

#define BLOB_MEMORY_TEMPORARY_FILE 1048576

namespace mozilla {
namespace dom {

namespace {

// This class uses the callback to inform when the Blob is created or when the
// error must be propagated.
class BlobCreationDoneRunnable final : public Runnable
{
public:
  BlobCreationDoneRunnable(MutableBlobStorage* aBlobStorage,
                           MutableBlobStorageCallback* aCallback,
                           Blob* aBlob,
                           nsresult aRv)
    : mBlobStorage(aBlobStorage)
    , mCallback(aCallback)
    , mBlob(aBlob)
    , mRv(aRv)
  {
    MOZ_ASSERT(aBlobStorage);
    MOZ_ASSERT(aCallback);
    MOZ_ASSERT((NS_FAILED(aRv) && !aBlob) ||
               (NS_SUCCEEDED(aRv) && aBlob));
  }

  NS_IMETHOD
  Run() override
  {
    MOZ_ASSERT(NS_IsMainThread());
    mCallback->BlobStoreCompleted(mBlobStorage, mBlob, mRv);
    mCallback = nullptr;
    mBlob = nullptr;
    return NS_OK;
  }

private:
  ~BlobCreationDoneRunnable()
  {
    // If something when wrong, we still have to release these objects in the
    // correct thread.
    NS_ReleaseOnMainThread(mCallback.forget());
    NS_ReleaseOnMainThread(mBlob.forget());
  }

  RefPtr<MutableBlobStorage> mBlobStorage;
  RefPtr<MutableBlobStorageCallback> mCallback;
  RefPtr<Blob> mBlob;
  nsresult mRv;
};

// This runnable goes back to the main-thread and informs the BlobStorage about
// the temporary file.
class FileCreatedRunnable final : public Runnable
{
public:
  FileCreatedRunnable(MutableBlobStorage* aBlobStorage, PRFileDesc* aFD)
    : mBlobStorage(aBlobStorage)
    , mFD(aFD)
  {
    MOZ_ASSERT(!NS_IsMainThread());
    MOZ_ASSERT(aBlobStorage);
    MOZ_ASSERT(aFD);
  }

  NS_IMETHOD
  Run() override
  {
    MOZ_ASSERT(NS_IsMainThread());
    mBlobStorage->TemporaryFileCreated(mFD);
    mFD = nullptr;
    return NS_OK;
  }

private:
  ~FileCreatedRunnable()
  {
    // If something when wrong, we still have to close the FileDescriptor.
    if (mFD) {
      PR_Close(mFD);
    }
  }

  RefPtr<MutableBlobStorage> mBlobStorage;
  PRFileDesc* mFD;
};

// This runnable creates the temporary file. When done, FileCreatedRunnable is
// dispatched back to the main-thread.
class CreateTemporaryFileRunnable final : public Runnable
{
public:
  explicit CreateTemporaryFileRunnable(MutableBlobStorage* aBlobStorage)
    : mBlobStorage(aBlobStorage)
  {
    MOZ_ASSERT(NS_IsMainThread());
    MOZ_ASSERT(aBlobStorage);
  }

  NS_IMETHOD
  Run() override
  {
    MOZ_ASSERT(!NS_IsMainThread());

    PRFileDesc* tempFD = nullptr;
    nsresult rv = NS_OpenAnonymousTemporaryFile(&tempFD);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      // In sandboxed context we are not allowed to create temporary files, but
      // this doesn't mean that BlobStorage should fail. We can continue to
      // store data in memory.  We don't change the storageType so that we don't
      // try to create a temporary file again.
      return NS_OK;
    }

    // The ownership of the tempFD is moved to the FileCreatedRunnable.
    return NS_DispatchToMainThread(new FileCreatedRunnable(mBlobStorage, tempFD));
  }

private:
  RefPtr<MutableBlobStorage> mBlobStorage;
};

// Simple runnable to propagate the error to the BlobStorage.
class ErrorPropagationRunnable final : public Runnable
{
public:
  ErrorPropagationRunnable(MutableBlobStorage* aBlobStorage, nsresult aRv)
    : mBlobStorage(aBlobStorage)
    , mRv(aRv)
  {}

  NS_IMETHOD
  Run() override
  {
    mBlobStorage->ErrorPropagated(mRv);
    return NS_OK;
  }

private:
  RefPtr<MutableBlobStorage> mBlobStorage;
  nsresult mRv;
};

// This runnable moves a buffer to the IO thread and there, it writes it into
// the temporary file.
class WriteRunnable final : public Runnable
{
public:
  static WriteRunnable*
  CopyBuffer(MutableBlobStorage* aBlobStorage, PRFileDesc* aFD,
             const void* aData, uint32_t aLength)
  {
    MOZ_ASSERT(NS_IsMainThread());
    MOZ_ASSERT(aBlobStorage);
    MOZ_ASSERT(aFD);
    MOZ_ASSERT(aData);

    // We have to take a copy of this buffer.
    void* data = malloc(aLength);
    if (!data) {
      return nullptr;
    }

    memcpy((char*)data, aData, aLength);
    return new WriteRunnable(aBlobStorage, aFD, data, aLength);
  }

  static WriteRunnable*
  AdoptBuffer(MutableBlobStorage* aBlobStorage, PRFileDesc* aFD,
              void* aData, uint32_t aLength)
  {
    MOZ_ASSERT(NS_IsMainThread());
    MOZ_ASSERT(aBlobStorage);
    MOZ_ASSERT(aFD);
    MOZ_ASSERT(aData);

    return new WriteRunnable(aBlobStorage, aFD, aData, aLength);
  }

  NS_IMETHOD
  Run() override
  {
    MOZ_ASSERT(!NS_IsMainThread());

    int32_t written = PR_Write(mFD, mData, mLength);
    if (NS_WARN_IF(written < 0 || uint32_t(written) != mLength)) {
      return NS_DispatchToMainThread(
        new ErrorPropagationRunnable(mBlobStorage, NS_ERROR_FAILURE));
    }

    return NS_OK;
  }

private:
  WriteRunnable(MutableBlobStorage* aBlobStorage, PRFileDesc* aFD,
                void* aData, uint32_t aLength)
    : mBlobStorage(aBlobStorage)
    , mFD(aFD)
    , mData(aData)
    , mLength(aLength)
  {
    MOZ_ASSERT(NS_IsMainThread());
    MOZ_ASSERT(mBlobStorage);
    MOZ_ASSERT(aFD);
    MOZ_ASSERT(aData);
  }

  ~WriteRunnable()
  {
    free(mData);
  }

  RefPtr<MutableBlobStorage> mBlobStorage;
  PRFileDesc* mFD;
  void* mData;
  uint32_t mLength;
};

// This runnable closes the FD in case something goes wrong or the temporary
// file is not needed anymore.
class CloseFileRunnable final : public Runnable
{
public:
  explicit CloseFileRunnable(PRFileDesc* aFD)
    : mFD(aFD)
  {}

  NS_IMETHOD
  Run() override
  {
    MOZ_ASSERT(!NS_IsMainThread());
    PR_Close(mFD);
    mFD = nullptr;
    return NS_OK;
  }

private:
  ~CloseFileRunnable()
  {
    if (mFD) {
      PR_Close(mFD);
    }
  }

  PRFileDesc* mFD;
};

// This runnable is dispatched to the main-thread from the IO thread and its
// task is to create the blob and inform the callback.
class CreateBlobRunnable final : public Runnable
{
public:
  CreateBlobRunnable(MutableBlobStorage* aBlobStorage,
                     already_AddRefed<nsISupports> aParent,
                     const nsACString& aContentType,
                     already_AddRefed<MutableBlobStorageCallback> aCallback)
    : mBlobStorage(aBlobStorage)
    , mParent(aParent)
    , mContentType(aContentType)
    , mCallback(aCallback)
  {
    MOZ_ASSERT(!NS_IsMainThread());
  }

  NS_IMETHOD
  Run() override
  {
    MOZ_ASSERT(NS_IsMainThread());
    mBlobStorage->CreateBlobAndRespond(mParent.forget(), mContentType,
                                       mCallback.forget());
    return NS_OK;
  }

private:
  ~CreateBlobRunnable()
  {
    // If something when wrong, we still have to release data in the correct
    // thread.
    NS_ReleaseOnMainThread(mParent.forget());
    NS_ReleaseOnMainThread(mCallback.forget());
  }

  RefPtr<MutableBlobStorage> mBlobStorage;
  nsCOMPtr<nsISupports> mParent;
  nsCString mContentType;
  RefPtr<MutableBlobStorageCallback> mCallback;
};

// This task is used to know when the writing is completed. From the IO thread
// it dispatches a CreateBlobRunnable to the main-thread.
class LastRunnable final : public Runnable
{
public:
  LastRunnable(MutableBlobStorage* aBlobStorage,
               nsISupports* aParent,
               const nsACString& aContentType,
               MutableBlobStorageCallback* aCallback)
    : mBlobStorage(aBlobStorage)
    , mParent(aParent)
    , mContentType(aContentType)
    , mCallback(aCallback)
  {
    MOZ_ASSERT(NS_IsMainThread());
    MOZ_ASSERT(mBlobStorage);
    MOZ_ASSERT(aCallback);
  }

  NS_IMETHOD
  Run() override
  {
    MOZ_ASSERT(!NS_IsMainThread());
    RefPtr<Runnable> runnable =
      new CreateBlobRunnable(mBlobStorage, mParent.forget(),
                             mContentType, mCallback.forget());
    return NS_DispatchToMainThread(runnable);
  }

private:
  ~LastRunnable()
  {
    // If something when wrong, we still have to release data in the correct
    // thread.
    NS_ReleaseOnMainThread(mParent.forget());
    NS_ReleaseOnMainThread(mCallback.forget());
  }

  RefPtr<MutableBlobStorage> mBlobStorage;
  nsCOMPtr<nsISupports> mParent;
  nsCString mContentType;
  RefPtr<MutableBlobStorageCallback> mCallback;
};

} // anonymous namespace

MutableBlobStorage::MutableBlobStorage(MutableBlobStorageType aType)
  : mData(nullptr)
  , mDataLen(0)
  , mDataBufferLen(0)
  , mStorageState(aType == eOnlyInMemory ? eKeepInMemory : eInMemory)
  , mFD(nullptr)
  , mErrorResult(NS_OK)
{
  MOZ_ASSERT(NS_IsMainThread());
}

MutableBlobStorage::~MutableBlobStorage()
{
  free(mData);

  if (mFD) {
    DispatchToIOThread(new CloseFileRunnable(mFD));
  }
}

uint64_t
MutableBlobStorage::GetBlobWhenReady(nsISupports* aParent,
                                     const nsACString& aContentType,
                                     MutableBlobStorageCallback* aCallback)
{
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(aCallback);

  // GetBlob can be called just once.
  MOZ_ASSERT(mStorageState != eClosed);
  StorageState previousState = mStorageState;
  mStorageState = eClosed;

  if (previousState == eInTemporaryFile) {
    MOZ_ASSERT(mFD);

    if (NS_FAILED(mErrorResult)) {
      NS_DispatchToMainThread(
        new BlobCreationDoneRunnable(this, aCallback, nullptr, mErrorResult));
      return 0;
    }

    // We want to wait until all the WriteRunnable are completed. The way we do
    // this is to go to the I/O thread and then we come back: the runnables are
    // executed in order and this LastRunnable will be... the last one.
    nsresult rv = DispatchToIOThread(new LastRunnable(this, aParent,
                                                      aContentType, aCallback));
    if (NS_WARN_IF(NS_FAILED(rv))) {
      NS_DispatchToMainThread(
        new BlobCreationDoneRunnable(this, aCallback, nullptr, rv));
      return 0;
    }

    return mDataLen;
  }

  RefPtr<BlobImpl> blobImpl;

  if (mData) {
    blobImpl = new BlobImplMemory(mData, mDataLen,
                                  NS_ConvertUTF8toUTF16(aContentType));

    mData = nullptr; // The BlobImplMemory takes ownership of the buffer
    mDataLen = 0;
    mDataBufferLen = 0;
  } else {
    blobImpl = new EmptyBlobImpl(NS_ConvertUTF8toUTF16(aContentType));
  }

  RefPtr<Blob> blob = Blob::Create(aParent, blobImpl);
  RefPtr<BlobCreationDoneRunnable> runnable =
    new BlobCreationDoneRunnable(this, aCallback, blob, NS_OK);

  nsresult error = NS_DispatchToMainThread(runnable);
  if (NS_WARN_IF(NS_FAILED(error))) {
    return 0;
  }

  return mDataLen;
}

nsresult
MutableBlobStorage::Append(const void* aData, uint32_t aLength)
{
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(mStorageState != eClosed);
  NS_ENSURE_ARG_POINTER(aData);

  if (!aLength) {
    return NS_OK;
  }

  // If eInMemory is the current Storage state, we could maybe migrate to
  // a temporary file.
  if (mStorageState == eInMemory && ShouldBeTemporaryStorage(aLength)) {
    nsresult rv = MaybeCreateTemporaryFile();
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return rv;
    }
  }

  // If we are already in the temporaryFile mode, we have to dispatch a
  // runnable.
  if (mStorageState == eInTemporaryFile) {
    MOZ_ASSERT(mFD);

    RefPtr<WriteRunnable> runnable =
      WriteRunnable::CopyBuffer(this, mFD, aData, aLength);
    if (NS_WARN_IF(!runnable)) {
      return NS_ERROR_OUT_OF_MEMORY;
    }

    nsresult rv = DispatchToIOThread(runnable);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return rv;
    }

    mDataLen += aLength;
    return NS_OK;
  }

  // By default, we store in memory.

  uint64_t offset = mDataLen;

  if (!ExpandBufferSize(aLength)) {
    return NS_ERROR_OUT_OF_MEMORY;
  }

  memcpy((char*)mData + offset, aData, aLength);
  return NS_OK;
}

bool
MutableBlobStorage::ExpandBufferSize(uint64_t aSize)
{
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(mStorageState < eInTemporaryFile);

  if (mDataBufferLen >= mDataLen + aSize) {
    mDataLen += aSize;
    return true;
  }

  // Start at 1 or we'll loop forever.
  CheckedUint32 bufferLen =
    std::max<uint32_t>(static_cast<uint32_t>(mDataBufferLen), 1);
  while (bufferLen.isValid() && bufferLen.value() < mDataLen + aSize) {
    bufferLen *= 2;
  }

  if (!bufferLen.isValid()) {
    return false;
  }

  void* data = realloc(mData, bufferLen.value());
  if (!data) {
    return false;
  }

  mData = data;
  mDataBufferLen = bufferLen.value();
  mDataLen += aSize;
  return true;
}

bool
MutableBlobStorage::ShouldBeTemporaryStorage(uint64_t aSize) const
{
  MOZ_ASSERT(mStorageState == eInMemory);

  CheckedUint32 bufferSize = mDataLen;
  bufferSize += aSize;

  if (!bufferSize.isValid()) {
    return false;
  }

  return bufferSize.value() >= Preferences::GetUint("dom.blob.memoryToTemporaryFile",
                                                    BLOB_MEMORY_TEMPORARY_FILE);
}

nsresult
MutableBlobStorage::MaybeCreateTemporaryFile()
{
  nsresult rv = DispatchToIOThread(new CreateTemporaryFileRunnable(this));
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  mStorageState = eWaitingForTemporaryFile;
  return NS_OK;
}

void
MutableBlobStorage::TemporaryFileCreated(PRFileDesc* aFD)
{
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(mStorageState == eWaitingForTemporaryFile ||
             mStorageState == eClosed);

  if (mStorageState == eClosed) {
    DispatchToIOThread(new CloseFileRunnable(aFD));
    return;
  }

  mStorageState = eInTemporaryFile;
  mFD = aFD;

  RefPtr<WriteRunnable> runnable =
    WriteRunnable::AdoptBuffer(this, mFD, mData, mDataLen);
  MOZ_ASSERT(runnable);

  mData = nullptr;

  nsresult rv = DispatchToIOThread(runnable);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    mErrorResult = rv;
    return;
  }
}

void
MutableBlobStorage::CreateBlobAndRespond(already_AddRefed<nsISupports> aParent,
                                         const nsACString& aContentType,
                                         already_AddRefed<MutableBlobStorageCallback> aCallback)
{
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(mStorageState == eClosed);
  MOZ_ASSERT(mFD);

  nsCOMPtr<nsISupports> parent(aParent);
  RefPtr<MutableBlobStorageCallback> callback(aCallback);

  RefPtr<Blob> blob =
    File::CreateTemporaryBlob(parent, mFD, 0, mDataLen,
                              NS_ConvertUTF8toUTF16(aContentType));
  callback->BlobStoreCompleted(this, blob, NS_OK);

  // ownership of this FD is moved to the BlobImpl.
  mFD = nullptr;
}

void
MutableBlobStorage::ErrorPropagated(nsresult aRv)
{
  MOZ_ASSERT(NS_IsMainThread());
  mErrorResult = aRv;
}

/* static */ nsresult
MutableBlobStorage::DispatchToIOThread(Runnable* aRunnable)
{
  nsCOMPtr<nsIEventTarget> target
    = do_GetService(NS_STREAMTRANSPORTSERVICE_CONTRACTID);
  MOZ_ASSERT(target);

  nsresult rv = target->Dispatch(aRunnable, NS_DISPATCH_NORMAL);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  return NS_OK;
}

} // dom namespace
} // mozilla namespace
