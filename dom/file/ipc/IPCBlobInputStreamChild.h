/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_dom_IPCBlobInputStreamChild_h
#define mozilla_dom_IPCBlobInputStreamChild_h

#include "mozilla/dom/PIPCBlobInputStreamChild.h"
#include "mozilla/dom/IPCBlobInputStream.h"
#include "mozilla/Mutex.h"
#include "mozilla/UniquePtr.h"
#include "nsTArray.h"

namespace mozilla {
namespace dom {

class IPCBlobInputStream;
class ThreadSafeWorkerRef;

class IPCBlobInputStreamChild final : public PIPCBlobInputStreamChild {
 public:
  enum ActorState {
    // The actor is connected via IPDL to the parent.
    eActive,

    // The actor is disconnected.
    eInactive,

    // The actor is waiting to be disconnected. Once it has been disconnected,
    // it will be reactivated on the DOM-File thread.
    eActiveMigrating,

    // The actor has been disconnected and it's waiting to be connected on the
    // DOM-File thread.
    eInactiveMigrating,
  };

  NS_INLINE_DECL_THREADSAFE_REFCOUNTING(IPCBlobInputStreamChild, final)

  IPCBlobInputStreamChild(const nsID& aID, uint64_t aSize);

  void ActorDestroy(IProtocol::ActorDestroyReason aReason) override;

  ActorState State();

  already_AddRefed<IPCBlobInputStream> CreateStream();

  void ForgetStream(IPCBlobInputStream* aStream);

  const nsID& ID() const { return mID; }

  uint64_t Size() const { return mSize; }

  void StreamNeeded(IPCBlobInputStream* aStream, nsIEventTarget* aEventTarget);

  mozilla::ipc::IPCResult RecvStreamReady(const Maybe<IPCStream>& aStream);

  void LengthNeeded(IPCBlobInputStream* aStream, nsIEventTarget* aEventTarget);

  mozilla::ipc::IPCResult RecvLengthReady(const int64_t& aLength);

  void Shutdown();

  void Migrated();

 private:
  ~IPCBlobInputStreamChild();

  // Raw pointers because these streams keep this actor alive. When the last
  // stream is unregister, the actor will be deleted. This list is protected by
  // mutex.
  nsTArray<IPCBlobInputStream*> mStreams;

  // This mutex protects mStreams because that can be touched in any thread.
  Mutex mMutex;

  const nsID mID;
  const uint64_t mSize;

  ActorState mState;

  // This struct and the array are used for creating streams when needed.
  struct PendingOperation {
    RefPtr<IPCBlobInputStream> mStream;
    nsCOMPtr<nsIEventTarget> mEventTarget;
    enum {
      eStreamNeeded,
      eLengthNeeded,
    } mOp;
  };
  nsTArray<PendingOperation> mPendingOperations;

  nsCOMPtr<nsISerialEventTarget> mOwningEventTarget;

  RefPtr<ThreadSafeWorkerRef> mWorkerRef;
};

}  // namespace dom
}  // namespace mozilla

#endif  // mozilla_dom_IPCBlobInputStreamChild_h
