/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set sw=2 ts=8 et ft=cpp : */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_MediaUtils_h
#define mozilla_MediaUtils_h

#include "mozilla/Assertions.h"
#include "mozilla/Monitor.h"
#include "mozilla/MozPromise.h"
#include "mozilla/RefPtr.h"
#include "mozilla/SharedThreadPool.h"
#include "mozilla/TaskQueue.h"
#include "mozilla/UniquePtr.h"
#include "nsCOMPtr.h"
#include "nsIAsyncShutdown.h"
#include "nsISupportsImpl.h"
#include "nsThreadUtils.h"

class nsIEventTarget;

namespace mozilla {
namespace media {

/* media::NewRunnableFrom() - Create a Runnable from a lambda.
 *
 * Passing variables (closures) to an async function is clunky with Runnable:
 *
 *   void Foo()
 *   {
 *     class FooRunnable : public Runnable
 *     {
 *     public:
 *       FooRunnable(const Bar &aBar) : mBar(aBar) {}
 *       NS_IMETHOD Run() override
 *       {
 *         // Use mBar
 *       }
 *     private:
 *       RefPtr<Bar> mBar;
 *     };
 *
 *     RefPtr<Bar> bar = new Bar();
 *     NS_DispatchToMainThread(new FooRunnable(bar);
 *   }
 *
 * It's worse with more variables. Lambdas have a leg up with variable capture:
 *
 *   void Foo()
 *   {
 *     RefPtr<Bar> bar = new Bar();
 *     NS_DispatchToMainThread(media::NewRunnableFrom([bar]() mutable {
 *       // use bar
 *     }));
 *   }
 *
 * Capture is by-copy by default, so the nsRefPtr 'bar' is safely copied for
 * access on the other thread (threadsafe refcounting in bar is assumed).
 *
 * The 'mutable' keyword is only needed for non-const access to bar.
 */

template <typename OnRunType>
class LambdaRunnable : public Runnable {
 public:
  explicit LambdaRunnable(OnRunType&& aOnRun)
      : Runnable("media::LambdaRunnable"), mOnRun(std::move(aOnRun)) {}

 private:
  NS_IMETHODIMP
  Run() override { return mOnRun(); }
  OnRunType mOnRun;
};

template <typename OnRunType>
already_AddRefed<LambdaRunnable<OnRunType>> NewRunnableFrom(
    OnRunType&& aOnRun) {
  typedef LambdaRunnable<OnRunType> LambdaType;
  RefPtr<LambdaType> lambda = new LambdaType(std::forward<OnRunType>(aOnRun));
  return lambda.forget();
}

/* media::Refcountable - Add threadsafe ref-counting to something that isn't.
 *
 * Often, reference counting is the most practical way to share an object with
 * another thread without imposing lifetime restrictions, even if there's
 * otherwise no concurrent access happening on the object.  For instance, an
 * algorithm on another thread may find it more expedient to modify a passed-in
 * object, rather than pass expensive copies back and forth.
 *
 * Lists in particular often aren't ref-countable, yet are expensive to copy,
 * e.g. nsTArray<RefPtr<Foo>>. Refcountable can be used to make such objects
 * (or owning smart-pointers to such objects) refcountable.
 *
 * Technical limitation: A template specialization is needed for types that take
 * a constructor. Please add below (UniquePtr covers a lot of ground though).
 */

class RefcountableBase {
 public:
  NS_INLINE_DECL_THREADSAFE_REFCOUNTING(RefcountableBase)
 protected:
  virtual ~RefcountableBase() = default;
};

template <typename T>
class Refcountable : public T, public RefcountableBase {
 public:
  NS_METHOD_(MozExternalRefCountType) AddRef() {
    return RefcountableBase::AddRef();
  }

  NS_METHOD_(MozExternalRefCountType) Release() {
    return RefcountableBase::Release();
  }

  Refcountable<T>& operator=(T&& aOther) {
    T::operator=(std::move(aOther));
    return *this;
  }

  Refcountable<T>& operator=(T& aOther) {
    T::operator=(aOther);
    return *this;
  }

 private:
  ~Refcountable<T>() = default;
};

template <typename T>
class Refcountable<UniquePtr<T>> : public UniquePtr<T> {
 public:
  explicit Refcountable<UniquePtr<T>>(T* aPtr) : UniquePtr<T>(aPtr) {}
  NS_INLINE_DECL_THREADSAFE_REFCOUNTING(Refcountable<T>)
 private:
  ~Refcountable<UniquePtr<T>>() = default;
};

/* Async shutdown helpers
 */

RefPtr<nsIAsyncShutdownClient> GetShutdownBarrier();

class ShutdownBlocker : public nsIAsyncShutdownBlocker {
 public:
  ShutdownBlocker(const nsString& aName) : mName(aName) {}

  NS_IMETHOD
  BlockShutdown(nsIAsyncShutdownClient* aProfileBeforeChange) override = 0;

  NS_IMETHOD GetName(nsAString& aName) override {
    aName = mName;
    return NS_OK;
  }

  NS_IMETHOD GetState(nsIPropertyBag**) override { return NS_OK; }

  NS_DECL_ISUPPORTS
 protected:
  virtual ~ShutdownBlocker() = default;

 private:
  const nsString mName;
};

class ShutdownTicket final {
 public:
  explicit ShutdownTicket(nsIAsyncShutdownBlocker* aBlocker)
      : mBlocker(aBlocker) {}
  NS_INLINE_DECL_REFCOUNTING(ShutdownTicket)
 private:
  ~ShutdownTicket() { GetShutdownBarrier()->RemoveBlocker(mBlocker); }

  nsCOMPtr<nsIAsyncShutdownBlocker> mBlocker;
};

/**
 * Await convenience methods to block until the promise has been resolved or
 * rejected. The Resolve/Reject functions, while called on a different thread,
 * would be running just as on the current thread thanks to the memory barrier
 * provided by the monitor.
 * For now Await can only be used with an exclusive MozPromise if passed a
 * Resolve/Reject function.
 * Await() can *NOT* be called from a task queue/nsISerialEventTarget used for
 * resolving/rejecting aPromise, otherwise things will deadlock.
 */
template <typename ResolveValueType, typename RejectValueType,
          typename ResolveFunction, typename RejectFunction>
void Await(already_AddRefed<nsIEventTarget> aPool,
           RefPtr<MozPromise<ResolveValueType, RejectValueType, true>> aPromise,
           ResolveFunction&& aResolveFunction,
           RejectFunction&& aRejectFunction) {
  RefPtr<TaskQueue> taskQueue =
      new TaskQueue(std::move(aPool), "MozPromiseAwait");
  Monitor mon(__func__);
  bool done = false;

  aPromise->Then(
      taskQueue, __func__,
      [&](ResolveValueType&& aResolveValue) {
        MonitorAutoLock lock(mon);
        aResolveFunction(std::forward<ResolveValueType>(aResolveValue));
        done = true;
        mon.Notify();
      },
      [&](RejectValueType&& aRejectValue) {
        MonitorAutoLock lock(mon);
        aRejectFunction(std::forward<RejectValueType>(aRejectValue));
        done = true;
        mon.Notify();
      });

  MonitorAutoLock lock(mon);
  while (!done) {
    mon.Wait();
  }
}

template <typename ResolveValueType, typename RejectValueType, bool Excl>
typename MozPromise<ResolveValueType, RejectValueType,
                    Excl>::ResolveOrRejectValue
Await(already_AddRefed<nsIEventTarget> aPool,
      RefPtr<MozPromise<ResolveValueType, RejectValueType, Excl>> aPromise) {
  RefPtr<TaskQueue> taskQueue =
      new TaskQueue(std::move(aPool), "MozPromiseAwait");
  Monitor mon(__func__);
  bool done = false;

  typename MozPromise<ResolveValueType, RejectValueType,
                      Excl>::ResolveOrRejectValue val;
  aPromise->Then(
      taskQueue, __func__,
      [&](ResolveValueType aResolveValue) {
        val.SetResolve(std::move(aResolveValue));
        MonitorAutoLock lock(mon);
        done = true;
        mon.Notify();
      },
      [&](RejectValueType aRejectValue) {
        val.SetReject(std::move(aRejectValue));
        MonitorAutoLock lock(mon);
        done = true;
        mon.Notify();
      });

  MonitorAutoLock lock(mon);
  while (!done) {
    mon.Wait();
  }

  return val;
}

/**
 * Similar to Await, takes an array of promises of the same type.
 * MozPromise::All is used to handle the resolution/rejection of the promises.
 */
template <typename ResolveValueType, typename RejectValueType,
          typename ResolveFunction, typename RejectFunction>
void AwaitAll(
    already_AddRefed<nsIEventTarget> aPool,
    nsTArray<RefPtr<MozPromise<ResolveValueType, RejectValueType, true>>>&
        aPromises,
    ResolveFunction&& aResolveFunction, RejectFunction&& aRejectFunction) {
  typedef MozPromise<ResolveValueType, RejectValueType, true> Promise;
  RefPtr<nsIEventTarget> pool = aPool;
  RefPtr<TaskQueue> taskQueue =
      new TaskQueue(do_AddRef(pool), "MozPromiseAwaitAll");
  RefPtr<typename Promise::AllPromiseType> p =
      Promise::All(taskQueue, aPromises);
  Await(pool.forget(), p, std::move(aResolveFunction),
        std::move(aRejectFunction));
}

// Note: only works with exclusive MozPromise, as Promise::All would attempt
// to perform copy of nsTArrays which are disallowed.
template <typename ResolveValueType, typename RejectValueType>
typename MozPromise<ResolveValueType, RejectValueType,
                    true>::AllPromiseType::ResolveOrRejectValue
AwaitAll(already_AddRefed<nsIEventTarget> aPool,
         nsTArray<RefPtr<MozPromise<ResolveValueType, RejectValueType, true>>>&
             aPromises) {
  typedef MozPromise<ResolveValueType, RejectValueType, true> Promise;
  RefPtr<nsIEventTarget> pool = aPool;
  RefPtr<TaskQueue> taskQueue =
      new TaskQueue(do_AddRef(pool), "MozPromiseAwaitAll");
  RefPtr<typename Promise::AllPromiseType> p =
      Promise::All(taskQueue, aPromises);
  return Await(pool.forget(), p);
}

}  // namespace media
}  // namespace mozilla

#endif  // mozilla_MediaUtils_h
