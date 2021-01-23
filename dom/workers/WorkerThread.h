/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_dom_workers_WorkerThread_h__
#define mozilla_dom_workers_WorkerThread_h__

#include "mozilla/Attributes.h"
#include "mozilla/CondVar.h"
#include "mozilla/DebugOnly.h"
#include "nsISupportsImpl.h"
#include "mozilla/RefPtr.h"
#include "nsThread.h"

class nsIRunnable;

namespace mozilla {
class AbstractThread;
namespace dom {

class WorkerRunnable;
class WorkerPrivate;
template <class>
class WorkerPrivateParent;

namespace workerinternals {
class RuntimeService;
}

// This class lets us restrict the public methods that can be called on
// WorkerThread to RuntimeService and WorkerPrivate without letting them gain
// full access to private methods (as would happen if they were simply friends).
class WorkerThreadFriendKey {
  friend class workerinternals::RuntimeService;
  friend class WorkerPrivate;
  friend class WorkerPrivateParent<WorkerPrivate>;

  WorkerThreadFriendKey();
  ~WorkerThreadFriendKey();
};

class WorkerThread final : public nsThread {
  class Observer;

  Mutex mLock;
  CondVar mWorkerPrivateCondVar;

  // Protected by nsThread::mLock.
  WorkerPrivate* mWorkerPrivate;

  // Only touched on the target thread.
  RefPtr<Observer> mObserver;

  // Protected by nsThread::mLock and waited on with mWorkerPrivateCondVar.
  uint32_t mOtherThreadsDispatchingViaEventTarget;

  // We create an AbstractThread for this current nsThread instance in order to
  // support direct task dispatching. Direct tasks work in a similar fashion to
  // microtasks and allow an IPDL MozPromise to behave like JS promise.
  // An AbstractThread only need to exist on the current thread for Direct Task
  // dispatch to be available.
  RefPtr<AbstractThread> mAbstractThread;
#ifdef DEBUG
  // Protected by nsThread::mLock.
  bool mAcceptingNonWorkerRunnables;
#endif

 public:
  static already_AddRefed<WorkerThread> Create(
      const WorkerThreadFriendKey& aKey);

  void SetWorker(const WorkerThreadFriendKey& aKey,
                 WorkerPrivate* aWorkerPrivate);

  nsresult DispatchPrimaryRunnable(const WorkerThreadFriendKey& aKey,
                                   already_AddRefed<nsIRunnable> aRunnable);

  nsresult DispatchAnyThread(const WorkerThreadFriendKey& aKey,
                             already_AddRefed<WorkerRunnable> aWorkerRunnable);

  uint32_t RecursionDepth(const WorkerThreadFriendKey& aKey) const;

  PerformanceCounter* GetPerformanceCounter(nsIRunnable* aEvent) const override;

  NS_IMETHODIMP Shutdown() override;

  NS_INLINE_DECL_REFCOUNTING_INHERITED(WorkerThread, nsThread)

 private:
  WorkerThread();
  ~WorkerThread();

  // This should only be called by consumers that have an
  // nsIEventTarget/nsIThread pointer.
  NS_IMETHOD
  Dispatch(already_AddRefed<nsIRunnable> aRunnable, uint32_t aFlags) override;

  NS_IMETHOD
  DispatchFromScript(nsIRunnable* aRunnable, uint32_t aFlags) override;

  NS_IMETHOD
  DelayedDispatch(already_AddRefed<nsIRunnable>, uint32_t) override;

  void IncrementDispatchCounter();
};

}  // namespace dom
}  // namespace mozilla

#endif  // mozilla_dom_workers_WorkerThread_h__
