/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "FileSystemBackgroundRequestHandler.h"

#include "fs/FileSystemChildFactory.h"
#include "mozilla/dom/ContentChild.h"
#include "mozilla/dom/FileSystemManagerChild.h"
#include "mozilla/dom/PFileSystemManager.h"
#include "mozilla/ipc/BackgroundChild.h"
#include "mozilla/ipc/Endpoint.h"
#include "mozilla/ipc/PBackgroundChild.h"

namespace mozilla::dom {

FileSystemBackgroundRequestHandler::FileSystemBackgroundRequestHandler(
    fs::FileSystemChildFactory* aChildFactory)
    : mChildFactory(aChildFactory), mCreatingFileSystemManagerChild(false) {}

FileSystemBackgroundRequestHandler::FileSystemBackgroundRequestHandler(
    RefPtr<FileSystemManagerChild> aFileSystemManagerChild)
    : mFileSystemManagerChild(std::move(aFileSystemManagerChild)),
      mCreatingFileSystemManagerChild(false) {}

FileSystemBackgroundRequestHandler::FileSystemBackgroundRequestHandler()
    : FileSystemBackgroundRequestHandler(new fs::FileSystemChildFactory()) {}

FileSystemBackgroundRequestHandler::~FileSystemBackgroundRequestHandler() =
    default;

void FileSystemBackgroundRequestHandler::ClearActor() {
  MOZ_ASSERT(mFileSystemManagerChild);

  mFileSystemManagerChild = nullptr;
}

void FileSystemBackgroundRequestHandler::Shutdown() {
  mShutdown.Flip();

  if (mFileSystemManagerChild) {
    MOZ_ASSERT(!mCreatingFileSystemManagerChild);

    mFileSystemManagerChild->Shutdown();

    mFileSystemManagerChild = nullptr;

    return;
  }

  if (mCreatingFileSystemManagerChild) {
    MOZ_ASSERT(!mFileSystemManagerChild);

    mCreateFileSystemManagerParentPromiseRequestHolder.Disconnect();

    mCreatingFileSystemManagerChild = false;

    // All downstream Then handlers should have been disconnected by
    // FileSystemManager::Shutdown so we expect no dispatches from this
    // rejection.
    mCreateFileSystemManagerChildPromiseHolder.RejectIfExists(NS_ERROR_ABORT,
                                                              __func__);
  }
}

const RefPtr<FileSystemManagerChild>&
FileSystemBackgroundRequestHandler::FileSystemManagerChildStrongRef() const {
  return mFileSystemManagerChild;
}

RefPtr<FileSystemManagerChild::ActorPromise>
FileSystemBackgroundRequestHandler::CreateFileSystemManagerChild(
    const mozilla::ipc::PrincipalInfo& aPrincipalInfo) {
  MOZ_ASSERT(!mFileSystemManagerChild);
  MOZ_ASSERT(!mShutdown);

  using mozilla::ipc::BackgroundChild;
  using mozilla::ipc::Endpoint;
  using mozilla::ipc::PBackgroundChild;

  // Throw if this process wouldn't be allowed to access storage.
  EnumSet<ValidatePrincipalOptions> options;
  if (CurrentRemoteType() == INFERENCE_REMOTE_TYPE) {
    options += ValidatePrincipalOptions::AllowSystem;
  }
  if (!BackgroundChild::ValidatePrincipalInfo(aPrincipalInfo, options)) {
    MOZ_ASSERT_UNREACHABLE(
        "ValidatePrincipalInfo failure in CreateFileSystemManagerChild");
    return FileSystemManagerChild::ActorPromise::CreateAndReject(
        NS_ERROR_FAILURE, __func__);
  }

  if (!mCreatingFileSystemManagerChild) {
    PBackgroundChild* backgroundChild =
        BackgroundChild::GetOrCreateForCurrentThread();
    if (NS_WARN_IF(!backgroundChild)) {
      return FileSystemManagerChild::ActorPromise::CreateAndReject(
          NS_ERROR_FAILURE, __func__);
    }

    // Create a new IPC connection
    Endpoint<PFileSystemManagerParent> parentEndpoint;
    Endpoint<PFileSystemManagerChild> childEndpoint;
    MOZ_ALWAYS_SUCCEEDS(
        PFileSystemManager::CreateEndpoints(&parentEndpoint, &childEndpoint));

    RefPtr<FileSystemManagerChild> child = mChildFactory->Create();
    if (!childEndpoint.Bind(child)) {
      return FileSystemManagerChild::ActorPromise::CreateAndReject(
          NS_ERROR_FAILURE, __func__);
    }

    mCreatingFileSystemManagerChild = true;

    backgroundChild
        ->SendCreateFileSystemManagerParent(aPrincipalInfo,
                                            std::move(parentEndpoint))
        ->Then(
            GetCurrentSerialEventTarget(), __func__,
            [self = RefPtr<FileSystemBackgroundRequestHandler>(this),
             child](nsresult rv) mutable {
              self->mCreateFileSystemManagerParentPromiseRequestHolder
                  .Complete();

              self->mCreatingFileSystemManagerChild = false;

              if (child->CloseAllReceived()) {
                self->mCreateFileSystemManagerChildPromiseHolder.RejectIfExists(
                    NS_ERROR_ABORT, __func__);
                return;
              }

              if (NS_FAILED(rv)) {
                self->mCreateFileSystemManagerChildPromiseHolder.RejectIfExists(
                    rv, __func__);
              } else {
                self->mFileSystemManagerChild = child;

                self->mFileSystemManagerChild->SetBackgroundRequestHandler(
                    self);

                self->mCreateFileSystemManagerChildPromiseHolder
                    .ResolveIfExists(std::move(child), __func__);
              }
            },
            [self = RefPtr<FileSystemBackgroundRequestHandler>(this)](
                const mozilla::ipc::ResponseRejectReason&) {
              self->mCreateFileSystemManagerParentPromiseRequestHolder
                  .Complete();

              self->mCreatingFileSystemManagerChild = false;

              self->mCreateFileSystemManagerChildPromiseHolder.RejectIfExists(
                  NS_ERROR_FAILURE, __func__);
            })
        ->Track(mCreateFileSystemManagerParentPromiseRequestHolder);
  }

  return mCreateFileSystemManagerChildPromiseHolder.Ensure(__func__);
}

}  // namespace mozilla::dom
