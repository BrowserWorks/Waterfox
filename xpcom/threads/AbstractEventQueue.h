/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_AbstractEventQueue_h
#define mozilla_AbstractEventQueue_h

#include "mozilla/AlreadyAddRefed.h"
#include "mozilla/MemoryReporting.h"
#include "mozilla/TimeStamp.h"
#include "mozilla/Mutex.h"

class nsIRunnable;

namespace mozilla {

enum class EventQueuePriority {
  High,
  Input,
  MediumHigh,
  Normal,
  DeferredTimers,
  Idle,

  Count
};

// AbstractEventQueue is an abstract base class for all our unsynchronized event
// queue implementations:
// - EventQueue: A queue of runnables. Used for non-main threads.
// - PrioritizedEventQueue: Contains a queue for each priority level.
//       Has heuristics to decide which queue to pop from. Events are
//       pushed into the queue corresponding to their priority.
//       Used for the main thread.
//
// Since AbstractEventQueue implementations are unsynchronized, they should be
// wrapped in an outer SynchronizedEventQueue implementation (like
// ThreadEventQueue).
//
// Subclasses should also define a `static const bool SupportsPrioritization`
// member to indicate whether the subclass cares about runnable priorities
// implemented through nsIRunnablePriority.
class AbstractEventQueue {
 public:
  // Add an event to the end of the queue. Implementors are free to use
  // aPriority however they wish.  If the runnable supports
  // nsIRunnablePriority and the implementing class supports
  // prioritization, aPriority represents the result of calling
  // nsIRunnablePriority::GetPriority().  *aDelay is time the event has
  // already been delayed (used when moving an event from one queue to
  // another)
  virtual void PutEvent(already_AddRefed<nsIRunnable>&& aEvent,
                        EventQueuePriority aPriority,
                        const MutexAutoLock& aProofOfLock,
                        mozilla::TimeDuration* aDelay = nullptr) = 0;

  // Get an event from the front of the queue. aPriority is an out param. If the
  // implementation supports priorities, then this should be the same priority
  // that the event was pushed with. aPriority may be null. This should return
  // null if the queue is non-empty but the event in front is not ready to run.
  // *aLastEventDelay is the time the event spent in queues before being
  // retrieved.
  virtual already_AddRefed<nsIRunnable> GetEvent(
      EventQueuePriority* aPriority, const MutexAutoLock& aProofOfLock,
      mozilla::TimeDuration* aLastEventDelay = nullptr) = 0;

  // Returns true if the queue is empty. Implies !HasReadyEvent().
  virtual bool IsEmpty(const MutexAutoLock& aProofOfLock) = 0;

  // Returns true if the queue is non-empty and if the event in front is ready
  // to run. Implies !IsEmpty(). This should return true iff GetEvent returns a
  // non-null value.
  virtual bool HasReadyEvent(const MutexAutoLock& aProofOfLock) = 0;

  virtual bool HasPendingHighPriorityEvents(
      const MutexAutoLock& aProofOfLock) = 0;

  // Returns the number of events in the queue.
  virtual size_t Count(const MutexAutoLock& aProofOfLock) const = 0;

  virtual void EnableInputEventPrioritization(
      const MutexAutoLock& aProofOfLock) = 0;
  virtual void FlushInputEventPrioritization(
      const MutexAutoLock& aProofOfLock) = 0;
  virtual void SuspendInputEventPrioritization(
      const MutexAutoLock& aProofOfLock) = 0;
  virtual void ResumeInputEventPrioritization(
      const MutexAutoLock& aProofOfLock) = 0;

  size_t SizeOfIncludingThis(mozilla::MallocSizeOf aMallocSizeOf) const {
    return aMallocSizeOf(this) + SizeOfExcludingThis(aMallocSizeOf);
  }

  virtual size_t SizeOfExcludingThis(
      mozilla::MallocSizeOf aMallocSizeOf) const = 0;

  virtual ~AbstractEventQueue() = default;
};

}  // namespace mozilla

#endif  // mozilla_AbstractEventQueue_h
