/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "FileInfo.h"

#include "FileManager.h"
#include "IndexedDatabaseManager.h"
#include "mozilla/Assertions.h"
#include "mozilla/Attributes.h"
#include "mozilla/Mutex.h"
#include "mozilla/dom/quota/QuotaManager.h"
#include "nsError.h"
#include "nsThreadUtils.h"

namespace mozilla {
namespace dom {
namespace indexedDB {

using namespace mozilla::dom::quota;

namespace {

template <typename IdType>
class FileInfoImpl final
  : public FileInfo
{
  IdType mFileId;

public:
  FileInfoImpl(FileManager* aFileManager, IdType aFileId)
    : FileInfo(aFileManager)
    , mFileId(aFileId)
  {
    MOZ_ASSERT(aFileManager);
    MOZ_ASSERT(aFileId > 0);
  }

private:
  ~FileInfoImpl()
  { }

  virtual int64_t
  Id() const override
  {
    return int64_t(mFileId);
  }
};

class CleanupFileRunnable final
  : public Runnable
{
  RefPtr<FileManager> mFileManager;
  int64_t mFileId;

public:
  static void
  DoCleanup(FileManager* aFileManager, int64_t aFileId);

  CleanupFileRunnable(FileManager* aFileManager, int64_t aFileId)
    : Runnable("dom::indexedDB::CleanupFileRunnable")
    , mFileManager(aFileManager)
    , mFileId(aFileId)
  {
    MOZ_ASSERT(aFileManager);
    MOZ_ASSERT(aFileId > 0);
  }

  NS_DECL_ISUPPORTS_INHERITED

private:
  ~CleanupFileRunnable()
  { }

  NS_DECL_NSIRUNNABLE
};

} // namespace

FileInfo::FileInfo(FileManager* aFileManager)
  : mFileManager(aFileManager)
{
  MOZ_ASSERT(aFileManager);
}

FileInfo::~FileInfo()
{
}

// static
FileInfo*
FileInfo::Create(FileManager* aFileManager, int64_t aId)
{
  MOZ_ASSERT(aFileManager);
  MOZ_ASSERT(aId > 0);

  if (aId <= INT16_MAX) {
    return new FileInfoImpl<int16_t>(aFileManager, aId);
  }

  if (aId <= INT32_MAX) {
    return new FileInfoImpl<int32_t>(aFileManager, aId);
  }

  return new FileInfoImpl<int64_t>(aFileManager, aId);
}

void
FileInfo::GetReferences(int32_t* aRefCnt,
                        int32_t* aDBRefCnt,
                        int32_t* aSliceRefCnt)
{
  MOZ_ASSERT(!IndexedDatabaseManager::IsClosed());

  MutexAutoLock lock(IndexedDatabaseManager::FileMutex());

  if (aRefCnt) {
    *aRefCnt = mRefCnt;
  }

  if (aDBRefCnt) {
    *aDBRefCnt = mDBRefCnt;
  }

  if (aSliceRefCnt) {
    *aSliceRefCnt = mSliceRefCnt;
  }
}

void
FileInfo::UpdateReferences(ThreadSafeAutoRefCnt& aRefCount,
                           int32_t aDelta,
                           CustomCleanupCallback* aCustomCleanupCallback)
{
  // XXX This can go away once DOM objects no longer hold FileInfo objects...
  //     Looking at you, BlobImplBase...
  //     BlobImplBase is being addressed in bug 1068975.
  if (IndexedDatabaseManager::IsClosed()) {
    MOZ_ASSERT(&aRefCount == &mRefCnt);
    MOZ_ASSERT(aDelta == 1 || aDelta == -1);

    if (aDelta > 0) {
      ++aRefCount;
    } else {
      nsrefcnt count = --aRefCount;
      if (!count) {
        mRefCnt = 1;
        delete this;
      }
    }
    return;
  }

  MOZ_ASSERT(!IndexedDatabaseManager::IsClosed());

  bool needsCleanup;
  {
    MutexAutoLock lock(IndexedDatabaseManager::FileMutex());

    aRefCount = aRefCount + aDelta;

    if (mRefCnt + mDBRefCnt + mSliceRefCnt > 0) {
      return;
    }

    mFileManager->mFileInfos.Remove(Id());

    needsCleanup = !mFileManager->Invalidated();
  }

  if (needsCleanup) {
    if (aCustomCleanupCallback) {
      nsresult rv = aCustomCleanupCallback->Cleanup(mFileManager, Id());
      if (NS_FAILED(rv)) {
        NS_WARNING("Custom cleanup failed!");
      }
    } else {
      Cleanup();
    }
  }

  delete this;
}

bool
FileInfo::LockedClearDBRefs()
{
  MOZ_ASSERT(!IndexedDatabaseManager::IsClosed());

  IndexedDatabaseManager::FileMutex().AssertCurrentThreadOwns();

  mDBRefCnt = 0;

  if (mRefCnt || mSliceRefCnt) {
    return true;
  }

  // In this case, we are not responsible for removing the file info from the
  // hashtable. It's up to FileManager which is the only caller of this method.

  MOZ_ASSERT(mFileManager->Invalidated());

  delete this;

  return false;
}

void
FileInfo::Cleanup()
{
  int64_t id = Id();

  // IndexedDatabaseManager is main-thread only.
  if (!NS_IsMainThread()) {
    RefPtr<CleanupFileRunnable> cleaner =
      new CleanupFileRunnable(mFileManager, id);

    MOZ_ALWAYS_SUCCEEDS(NS_DispatchToMainThread(cleaner));
    return;
  }

  CleanupFileRunnable::DoCleanup(mFileManager, id);
}

// static
void
CleanupFileRunnable::DoCleanup(FileManager* aFileManager, int64_t aFileId)
{
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(aFileManager);
  MOZ_ASSERT(aFileId > 0);

  if (NS_WARN_IF(QuotaManager::IsShuttingDown())) {
    return;
  }

  RefPtr<IndexedDatabaseManager> mgr = IndexedDatabaseManager::Get();
  MOZ_ASSERT(mgr);

  if (NS_FAILED(mgr->AsyncDeleteFile(aFileManager, aFileId))) {
    NS_WARNING("Failed to delete file asynchronously!");
  }
}

NS_IMPL_ISUPPORTS_INHERITED0(CleanupFileRunnable, Runnable)

NS_IMETHODIMP
CleanupFileRunnable::Run()
{
  MOZ_ASSERT(NS_IsMainThread());

  DoCleanup(mFileManager, mFileId);

  return NS_OK;
}

} // namespace indexedDB
} // namespace dom
} // namespace mozilla
