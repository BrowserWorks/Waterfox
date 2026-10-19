/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/dom/FileSystemManager.h"

#include "FileSystemBackgroundRequestHandler.h"
#include "fs/FileSystemRequestHandler.h"
#include "mozilla/ErrorResult.h"
#include "mozilla/dom/FileSystemManagerChild.h"
#include "mozilla/dom/Promise.h"
#include "mozilla/dom/StorageManager.h"
#include "mozilla/dom/fs/ManagedMozPromiseRequestHolder.h"
#include "mozilla/dom/quota/QuotaCommon.h"
#include "mozilla/dom/quota/ResultExtensions.h"

namespace mozilla::dom {

FileSystemManager::FileSystemManager(
    nsIGlobalObject* aGlobal, RefPtr<StorageManager> aStorageManager,
    RefPtr<FileSystemBackgroundRequestHandler> aBackgroundRequestHandler)
    : mGlobal(aGlobal),
      mStorageManager(std::move(aStorageManager)),
      mBackgroundRequestHandler(std::move(aBackgroundRequestHandler)),
      mRequestHandler(new fs::FileSystemRequestHandler()) {}

FileSystemManager::FileSystemManager(nsIGlobalObject* aGlobal,
                                     RefPtr<StorageManager> aStorageManager)
    : FileSystemManager(aGlobal, std::move(aStorageManager),
                        MakeRefPtr<FileSystemBackgroundRequestHandler>()) {}

FileSystemManager::~FileSystemManager() { MOZ_ASSERT(mShutdown); }

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(FileSystemManager)
  NS_INTERFACE_MAP_ENTRY(nsISupports)
NS_INTERFACE_MAP_END
NS_IMPL_CYCLE_COLLECTING_ADDREF(FileSystemManager);
NS_IMPL_CYCLE_COLLECTING_RELEASE(FileSystemManager);
NS_IMPL_CYCLE_COLLECTION(FileSystemManager, mGlobal, mStorageManager);

void FileSystemManager::Shutdown() {
  mShutdown.Flip();

  auto shutdownAndDisconnect = [self = RefPtr(this)]() {
    for (RefPtr<PromiseRequestHolder<FileSystemManagerChild::ActorPromise>>
             holder : self->mPromiseRequestHolders.ForwardRange()) {
      holder->DisconnectIfExists();
    }

    self->mBackgroundRequestHandler->Shutdown();
  };

  if (NS_IsMainThread()) {
    if (mBackgroundRequestHandler->FileSystemManagerChildStrongRef()) {
      mBackgroundRequestHandler->FileSystemManagerChildStrongRef()
          ->CloseAllWritables(
              [shutdownAndDisconnect = std::move(shutdownAndDisconnect)]() {
                shutdownAndDisconnect();
              });
    } else {
      shutdownAndDisconnect();
    }
  } else {
    if (mBackgroundRequestHandler->FileSystemManagerChildStrongRef()) {
      // FileSystemAccessHandles and FileSystemWritableFileStreams prevent
      // shutdown until they are full closed, so at this point, they all should
      // be closed.
      MOZ_ASSERT(mBackgroundRequestHandler->FileSystemManagerChildStrongRef()
                     ->AllSyncAccessHandlesClosed());
      MOZ_ASSERT(mBackgroundRequestHandler->FileSystemManagerChildStrongRef()
                     ->AllWritableFileStreamsClosed());
    }

    shutdownAndDisconnect();
  }
}

const RefPtr<FileSystemManagerChild>& FileSystemManager::ActorStrongRef()
    const {
  return mBackgroundRequestHandler->FileSystemManagerChildStrongRef();
}

void FileSystemManager::RegisterPromiseRequestHolder(
    PromiseRequestHolder<FileSystemManagerChild::ActorPromise>* aHolder) {
  mPromiseRequestHolders.AppendElement(aHolder);
}

void FileSystemManager::UnregisterPromiseRequestHolder(
    PromiseRequestHolder<FileSystemManagerChild::ActorPromise>* aHolder) {
  mPromiseRequestHolders.RemoveElement(aHolder);
}

void FileSystemManager::BeginRequest(
    MoveOnlyFunction<void(RefPtr<FileSystemManagerChild>)>&& aSuccess,
    MoveOnlyFunction<void(nsresult)>&& aFailure) {
  MOZ_ASSERT(!mShutdown);

  MOZ_ASSERT(mGlobal);

  nsICookieJarSettings* cookieJarSettings = mGlobal->GetCookieJarSettings();
  nsIPrincipal* unpartitionedPrincipal = mGlobal->PrincipalOrNull();
  if (NS_WARN_IF(!cookieJarSettings) || NS_WARN_IF(!unpartitionedPrincipal) ||
      NS_WARN_IF(unpartitionedPrincipal->GetIsInPrivateBrowsing())) {
    // ePartition values can be returned for Private Browsing Mode
    // for third-party iframes, so we also need to check the private browsing
    // in that case which means we need to check the principal.
    aFailure(NS_ERROR_DOM_SECURITY_ERR);
    return;
  }

  // Check if we're allowed to use storage.
  StorageAccess access = mGlobal->GetStorageAccess();

  // Use allow list to decide the permission.
  const bool allowed = access == StorageAccess::eAllow ||
                       StoragePartitioningEnabled(access, cookieJarSettings);
  if (NS_WARN_IF(!allowed)) {
    aFailure(NS_ERROR_DOM_SECURITY_ERR);
    return;
  }

  if (mBackgroundRequestHandler->FileSystemManagerChildStrongRef()) {
    aSuccess(mBackgroundRequestHandler->FileSystemManagerChildStrongRef());
    return;
  }

  auto holder =
      MakeRefPtr<PromiseRequestHolder<FileSystemManagerChild::ActorPromise>>(
          this);

  QM_TRY_INSPECT(const auto& principalInfo, mGlobal->GetStorageKey(), QM_VOID,
                 [&aFailure](nsresult rv) { aFailure(rv); });

  mBackgroundRequestHandler->CreateFileSystemManagerChild(principalInfo)
      ->Then(
          GetCurrentSerialEventTarget(), __func__,
          [self = RefPtr<FileSystemManager>(this), holder,
           success = std::move(aSuccess), failure = std::move(aFailure)](
              const FileSystemManagerChild::ActorPromise::ResolveOrRejectValue&
                  aValue) mutable {
            holder->Complete();

            if (aValue.IsResolve()) {
              success(aValue.ResolveValue());
            } else {
              failure(aValue.RejectValue());
            }
          })
      ->Track(*holder);
}

already_AddRefed<Promise> FileSystemManager::GetDirectory(ErrorResult& aError) {
  MOZ_ASSERT(mGlobal);

  RefPtr<Promise> promise = Promise::Create(mGlobal, aError);
  if (NS_WARN_IF(aError.Failed())) {
    return nullptr;
  }

  MOZ_ASSERT(promise);

  mRequestHandler->GetRootHandle(this, promise, aError);
  if (NS_WARN_IF(aError.Failed())) {
    return nullptr;
  }

  return promise.forget();
}

}  // namespace mozilla::dom
