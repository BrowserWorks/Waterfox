/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "IPCBlobInputStreamChild.h"
#include "IPCBlobInputStreamThread.h"

#include "mozilla/ipc/IPCStreamUtils.h"
#include "WorkerHolder.h"
#include "WorkerPrivate.h"
#include "WorkerRunnable.h"

namespace mozilla {
namespace dom {

using namespace workers;

namespace {

// This runnable is used in case the last stream is forgotten on the 'wrong'
// thread.
class ShutdownRunnable final : public CancelableRunnable
{
public:
  explicit ShutdownRunnable(IPCBlobInputStreamChild* aActor)
    : mActor(aActor)
  {}

  NS_IMETHOD
  Run() override
  {
    mActor->Shutdown();
    return NS_OK;
  }

private:
  RefPtr<IPCBlobInputStreamChild> mActor;
};

// This runnable is used in case StreamNeeded() has been called on a non-owning
// thread.
class StreamNeededRunnable final : public CancelableRunnable
{
public:
  explicit StreamNeededRunnable(IPCBlobInputStreamChild* aActor)
    : mActor(aActor)
  {}

  NS_IMETHOD
  Run() override
  {
    MOZ_ASSERT(mActor->State() != IPCBlobInputStreamChild::eActiveMigrating &&
               mActor->State() != IPCBlobInputStreamChild::eInactiveMigrating);
    if (mActor->State() == IPCBlobInputStreamChild::eActive) {
      mActor->SendStreamNeeded();
    }
    return NS_OK;
  }

private:
  RefPtr<IPCBlobInputStreamChild> mActor;
};

// When the stream has been received from the parent, we inform the
// IPCBlobInputStream.
class StreamReadyRunnable final : public CancelableRunnable
{
public:
  StreamReadyRunnable(IPCBlobInputStream* aDestinationStream,
                      nsIInputStream* aCreatedStream)
    : mDestinationStream(aDestinationStream)
    , mCreatedStream(aCreatedStream)
  {
    MOZ_ASSERT(mDestinationStream);
    // mCreatedStream can be null.
  }

  NS_IMETHOD
  Run() override
  {
    mDestinationStream->StreamReady(mCreatedStream);
    return NS_OK;
  }

private:
  RefPtr<IPCBlobInputStream> mDestinationStream;
  nsCOMPtr<nsIInputStream> mCreatedStream;
};

class IPCBlobInputStreamWorkerHolder final : public WorkerHolder
{
public:
  bool Notify(Status aStatus) override
  {
    // We must keep the worker alive until the migration is completed.
    return true;
  }
};

class ReleaseWorkerHolderRunnable final : public CancelableRunnable
{
public:
  explicit ReleaseWorkerHolderRunnable(UniquePtr<workers::WorkerHolder>&& aWorkerHolder)
    : mWorkerHolder(Move(aWorkerHolder))
  {}

  NS_IMETHOD
  Run() override
  {
    mWorkerHolder = nullptr;
    return NS_OK;
  }

  nsresult
  Cancel() override
  {
    return Run();
  }

private:
  UniquePtr<workers::WorkerHolder> mWorkerHolder;
};

} // anonymous

IPCBlobInputStreamChild::IPCBlobInputStreamChild(const nsID& aID,
                                                 uint64_t aSize)
  : mMutex("IPCBlobInputStreamChild::mMutex")
  , mID(aID)
  , mSize(aSize)
  , mState(eActive)
  , mOwningThread(NS_GetCurrentThread())
{
  // If we are running in a worker, we need to send a Close() to the parent side
  // before the thread is released.
  if (!NS_IsMainThread()) {
    WorkerPrivate* workerPrivate = GetCurrentThreadWorkerPrivate();
    if (workerPrivate) {
      UniquePtr<WorkerHolder> workerHolder(
        new IPCBlobInputStreamWorkerHolder());
      if (workerHolder->HoldWorker(workerPrivate, Canceling)) {
        mWorkerHolder.swap(workerHolder);
      }
    }
  }
}

IPCBlobInputStreamChild::~IPCBlobInputStreamChild()
{}

void
IPCBlobInputStreamChild::Shutdown()
{
  MutexAutoLock lock(mMutex);

  RefPtr<IPCBlobInputStreamChild> kungFuDeathGrip = this;

  mWorkerHolder = nullptr;
  mPendingOperations.Clear();

  if (mState == eActive) {
    SendClose();
    mState = eInactive;
  }
}

void
IPCBlobInputStreamChild::ActorDestroy(IProtocol::ActorDestroyReason aReason)
{
  bool migrating = false;

  {
    MutexAutoLock lock(mMutex);
    migrating = mState == eActiveMigrating;
    mState = migrating ? eInactiveMigrating : eInactive;
  }

  if (migrating) {
    // We were waiting for this! Now we can migrate the actor in the correct
    // thread.
    RefPtr<IPCBlobInputStreamThread> thread =
      IPCBlobInputStreamThread::GetOrCreate();
    ResetManager();
    thread->MigrateActor(this);
    return;
  }

  // Let's cleanup the workerHolder and the pending operation queue.
  Shutdown();
}

IPCBlobInputStreamChild::ActorState
IPCBlobInputStreamChild::State()
{
  MutexAutoLock lock(mMutex);
  return mState;
}

already_AddRefed<nsIInputStream>
IPCBlobInputStreamChild::CreateStream()
{
  bool shouldMigrate = false;

  RefPtr<IPCBlobInputStream> stream = new IPCBlobInputStream(this);

  {
    MutexAutoLock lock(mMutex);

    if (mState == eInactive) {
      return nullptr;
    }

    // The stream is active but maybe it is not running in the DOM-File thread.
    // We should migrate it there.
    if (mState == eActive &&
        !IPCBlobInputStreamThread::IsOnFileThread(mOwningThread)) {
      MOZ_ASSERT(mStreams.IsEmpty());
      shouldMigrate = true;
      mState = eActiveMigrating;
    }

    mStreams.AppendElement(stream);
  }

  // Send__delete__ will call ActorDestroy(). mMutex cannot be locked at this
  // time.
  if (shouldMigrate) {
    Send__delete__(this);
  }

  return stream.forget();
}

void
IPCBlobInputStreamChild::ForgetStream(IPCBlobInputStream* aStream)
{
  MOZ_ASSERT(aStream);

  RefPtr<IPCBlobInputStreamChild> kungFuDeathGrip = this;

  {
    MutexAutoLock lock(mMutex);
    mStreams.RemoveElement(aStream);

    if (!mStreams.IsEmpty() || mState != eActive) {
      return;
    }
  }

  if (mOwningThread == NS_GetCurrentThread()) {
    Shutdown();
    return;
  }

  RefPtr<ShutdownRunnable> runnable = new ShutdownRunnable(this);
  mOwningThread->Dispatch(runnable, NS_DISPATCH_NORMAL);
}

void
IPCBlobInputStreamChild::StreamNeeded(IPCBlobInputStream* aStream,
                                      nsIEventTarget* aEventTarget)
{
  MutexAutoLock lock(mMutex);

  if (mState == eInactive) {
    return;
  }

  MOZ_ASSERT(mStreams.Contains(aStream));

  PendingOperation* opt = mPendingOperations.AppendElement();
  opt->mStream = aStream;
  opt->mEventTarget = aEventTarget ? aEventTarget : NS_GetCurrentThread();

  if (mState == eActiveMigrating || mState == eInactiveMigrating) {
    // This operation will be continued when the migration is completed.
    return;
  }

  MOZ_ASSERT(mState == eActive);

  if (mOwningThread == NS_GetCurrentThread()) {
    SendStreamNeeded();
    return;
  }

  RefPtr<StreamNeededRunnable> runnable = new StreamNeededRunnable(this);
  mOwningThread->Dispatch(runnable, NS_DISPATCH_NORMAL);
}

mozilla::ipc::IPCResult
IPCBlobInputStreamChild::RecvStreamReady(const OptionalIPCStream& aStream)
{
  nsCOMPtr<nsIInputStream> stream = mozilla::ipc::DeserializeIPCStream(aStream);

  RefPtr<IPCBlobInputStream> pendingStream;
  nsCOMPtr<nsIEventTarget> eventTarget;

  {
    MutexAutoLock lock(mMutex);
    MOZ_ASSERT(!mPendingOperations.IsEmpty());
    MOZ_ASSERT(mState == eActive);

    pendingStream = mPendingOperations[0].mStream;
    eventTarget = mPendingOperations[0].mEventTarget;

    mPendingOperations.RemoveElementAt(0);
  }

  RefPtr<StreamReadyRunnable> runnable =
    new StreamReadyRunnable(pendingStream, stream);
  eventTarget->Dispatch(runnable, NS_DISPATCH_NORMAL);

  return IPC_OK();
}

void
IPCBlobInputStreamChild::Migrated()
{
  MutexAutoLock lock(mMutex);
  MOZ_ASSERT(mState == eInactiveMigrating);

  if (mWorkerHolder) {
    RefPtr<ReleaseWorkerHolderRunnable> runnable =
      new ReleaseWorkerHolderRunnable(Move(mWorkerHolder));
    mOwningThread->Dispatch(runnable, NS_DISPATCH_NORMAL);
  }

  mOwningThread = NS_GetCurrentThread();
  MOZ_ASSERT(IPCBlobInputStreamThread::IsOnFileThread(mOwningThread));

  // Maybe we have no reasons to keep this actor alive.
  if (mStreams.IsEmpty()) {
    mState = eInactive;
    SendClose();
    return;
  }

  mState = eActive;

  // Let's processing the pending operations. We need a stream for each pending
  // operation.
  for (uint32_t i = 0; i < mPendingOperations.Length(); ++i) {
    SendStreamNeeded();
  }
}

} // namespace dom
} // namespace mozilla
