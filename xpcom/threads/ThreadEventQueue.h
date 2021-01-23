/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_ThreadEventQueue_h
#define mozilla_ThreadEventQueue_h

#include "mozilla/AbstractEventQueue.h"
#include "mozilla/CondVar.h"
#include "mozilla/SynchronizedEventQueue.h"
#include "nsCOMPtr.h"
#include "nsTArray.h"

class nsIEventTarget;
class nsISerialEventTarget;
class nsIThreadObserver;

namespace mozilla {

class EventQueue;
class PrioritizedEventQueue;
class ThreadEventTarget;

// A ThreadEventQueue implements normal monitor-style synchronization over the
// InnerQueueT AbstractEventQueue. It also implements PushEventQueue and
// PopEventQueue for workers (see the documentation below for an explanation of
// those). All threads use a ThreadEventQueue as their event queue. InnerQueueT
// is a template parameter to avoid virtual dispatch overhead.
template <class InnerQueueT>
class ThreadEventQueue final : public SynchronizedEventQueue {
 public:
  explicit ThreadEventQueue(UniquePtr<InnerQueueT> aQueue);

  bool PutEvent(already_AddRefed<nsIRunnable>&& aEvent,
                EventQueuePriority aPriority) final;

  already_AddRefed<nsIRunnable> GetEvent(
      bool aMayWait, EventQueuePriority* aPriority,
      mozilla::TimeDuration* aLastEventDelay = nullptr) final;
  void DidRunEvent() final;
  bool HasPendingEvent() final;
  bool HasPendingHighPriorityEvents() final;

  bool ShutdownIfNoPendingEvents() final;

  void Disconnect(const MutexAutoLock& aProofOfLock) final {}

  void EnableInputEventPrioritization() final;
  void FlushInputEventPrioritization() final;
  void SuspendInputEventPrioritization() final;
  void ResumeInputEventPrioritization() final;

  already_AddRefed<nsISerialEventTarget> PushEventQueue() final;
  void PopEventQueue(nsIEventTarget* aTarget) final;

  already_AddRefed<nsIThreadObserver> GetObserver() final;
  already_AddRefed<nsIThreadObserver> GetObserverOnThread() final;
  void SetObserver(nsIThreadObserver* aObserver) final;

  Mutex& MutexRef() { return mLock; }

  size_t SizeOfExcludingThis(
      mozilla::MallocSizeOf aMallocSizeOf) const override;

 private:
  class NestedSink;

  virtual ~ThreadEventQueue();

  bool PutEventInternal(already_AddRefed<nsIRunnable>&& aEvent,
                        EventQueuePriority aPriority, NestedSink* aQueue);

  UniquePtr<InnerQueueT> mBaseQueue;

  struct NestedQueueItem {
    UniquePtr<EventQueue> mQueue;
    RefPtr<ThreadEventTarget> mEventTarget;

    NestedQueueItem(UniquePtr<EventQueue> aQueue,
                    ThreadEventTarget* aEventTarget)
        : mQueue(std::move(aQueue)), mEventTarget(aEventTarget) {}
  };

  nsTArray<NestedQueueItem> mNestedQueues;

  Mutex mLock;
  CondVar mEventsAvailable;

  bool mEventsAreDoomed = false;
  nsCOMPtr<nsIThreadObserver> mObserver;
};

extern template class ThreadEventQueue<EventQueue>;
extern template class ThreadEventQueue<PrioritizedEventQueue>;

};  // namespace mozilla

#endif  // mozilla_ThreadEventQueue_h
