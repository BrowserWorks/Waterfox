/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_Mutex_h
#define mozilla_Mutex_h

#include "mozilla/BlockingResourceBase.h"
#include "mozilla/GuardObjects.h"
#include "mozilla/PlatformMutex.h"

//
// Provides:
//
//  - Mutex, a non-recursive mutex
//  - MutexAutoLock, an RAII class for ensuring that Mutexes are properly
//    locked and unlocked
//  - MutexAutoUnlock, complementary sibling to MutexAutoLock
//
//  - OffTheBooksMutex, a non-recursive mutex that doesn't do leak checking
//  - OffTheBooksMutexAuto{Lock,Unlock} - Like MutexAuto{Lock,Unlock}, but for
//    an OffTheBooksMutex.
//
// Using MutexAutoLock/MutexAutoUnlock etc. is MUCH preferred to making bare
// calls to Lock and Unlock.
//
namespace mozilla {

/**
 * OffTheBooksMutex is identical to Mutex, except that OffTheBooksMutex doesn't
 * include leak checking.  Sometimes you want to intentionally "leak" a mutex
 * until shutdown; in these cases, OffTheBooksMutex is for you.
 */
class OffTheBooksMutex : public detail::MutexImpl, BlockingResourceBase {
 public:
  /**
   * @param aName A name which can reference this lock
   * @returns If failure, nullptr
   *          If success, a valid Mutex* which must be destroyed
   *          by Mutex::DestroyMutex()
   **/
  explicit OffTheBooksMutex(const char* aName)
      : BlockingResourceBase(aName, eMutex)
#ifdef DEBUG
        ,
        mOwningThread(nullptr)
#endif
  {
  }

  ~OffTheBooksMutex() {
#ifdef DEBUG
    MOZ_ASSERT(!mOwningThread, "destroying a still-owned lock!");
#endif
  }

#ifndef DEBUG
  /**
   * Lock this mutex.
   **/
  void Lock() { this->lock(); }

  /**
   * Try to lock this mutex, returning true if we were successful.
   **/
  bool TryLock() { return this->tryLock(); }

  /**
   * Unlock this mutex.
   **/
  void Unlock() { this->unlock(); }

  /**
   * Assert that the current thread owns this mutex in debug builds.
   *
   * Does nothing in non-debug builds.
   **/
  void AssertCurrentThreadOwns() const {}

  /**
   * Assert that the current thread does not own this mutex.
   *
   * Note that this function is not implemented for debug builds *and*
   * non-debug builds due to difficulties in dealing with memory ordering.
   *
   * It is therefore mostly useful as documentation.
   **/
  void AssertNotCurrentThreadOwns() const {}

#else
  void Lock();
  bool TryLock();
  void Unlock();

  void AssertCurrentThreadOwns() const;

  void AssertNotCurrentThreadOwns() const {
    // FIXME bug 476536
  }

#endif  // ifndef DEBUG

 private:
  OffTheBooksMutex();
  OffTheBooksMutex(const OffTheBooksMutex&);
  OffTheBooksMutex& operator=(const OffTheBooksMutex&);

  friend class OffTheBooksCondVar;

#ifdef DEBUG
  PRThread* mOwningThread;
#endif
};

/**
 * Mutex
 * When possible, use MutexAutoLock/MutexAutoUnlock to lock/unlock this
 * mutex within a scope, instead of calling Lock/Unlock directly.
 */
class Mutex : public OffTheBooksMutex {
 public:
  explicit Mutex(const char* aName) : OffTheBooksMutex(aName) {
    MOZ_COUNT_CTOR(Mutex);
  }

  MOZ_COUNTED_DTOR(Mutex)

 private:
  Mutex();
  Mutex(const Mutex&);
  Mutex& operator=(const Mutex&);
};

namespace detail {
template <typename T>
class MOZ_RAII BaseAutoUnlock;

/**
 * MutexAutoLock
 * Acquires the Mutex when it enters scope, and releases it when it leaves
 * scope.
 *
 * MUCH PREFERRED to bare calls to Mutex.Lock and Unlock.
 */
template <typename T>
class MOZ_RAII BaseAutoLock {
 public:
  /**
   * Constructor
   * The constructor aquires the given lock.  The destructor
   * releases the lock.
   *
   * @param aLock A valid mozilla::Mutex* returned by
   *              mozilla::Mutex::NewMutex.
   **/
  explicit BaseAutoLock(T aLock MOZ_GUARD_OBJECT_NOTIFIER_PARAM)
      : mLock(aLock) {
    MOZ_GUARD_OBJECT_NOTIFIER_INIT;
    mLock.Lock();
  }

  ~BaseAutoLock(void) { mLock.Unlock(); }

  // Assert that aLock is the mutex passed to the constructor and that the
  // current thread owns the mutex.  In coding patterns such as:
  //
  // void LockedMethod(const BaseAutoLock<T>& aProofOfLock)
  // {
  //   aProofOfLock.AssertOwns(mMutex);
  //   ...
  // }
  //
  // Without this assertion, it could be that mMutex is not actually
  // locked. It's possible to have code like:
  //
  // BaseAutoLock lock(someMutex);
  // ...
  // BaseAutoUnlock unlock(someMutex);
  // ...
  // LockedMethod(lock);
  //
  // and in such a case, simply asserting that the mutex pointers match is not
  // sufficient; mutex ownership must be asserted as well.
  //
  // Note that if you are going to use the coding pattern presented above, you
  // should use this method in preference to using AssertCurrentThreadOwns on
  // the mutex you expected to be held, since this method provides stronger
  // guarantees.
  void AssertOwns(const T& aMutex) const {
    MOZ_ASSERT(&aMutex == &aMutex);
    mLock.AssertCurrentThreadOwns();
  }

 private:
  BaseAutoLock();
  BaseAutoLock(BaseAutoLock&);
  BaseAutoLock& operator=(BaseAutoLock&);
  static void* operator new(size_t) noexcept(true);

  friend class BaseAutoUnlock<T>;

  T mLock;
  MOZ_DECL_USE_GUARD_OBJECT_NOTIFIER
};

template <typename MutexType>
BaseAutoLock(MutexType&) -> BaseAutoLock<MutexType&>;
}  // namespace detail

typedef detail::BaseAutoLock<Mutex&> MutexAutoLock;
typedef detail::BaseAutoLock<OffTheBooksMutex&> OffTheBooksMutexAutoLock;

namespace detail {
/**
 * BaseAutoUnlock
 * Releases the Mutex when it enters scope, and re-acquires it when it leaves
 * scope.
 *
 * MUCH PREFERRED to bare calls to Mutex.Unlock and Lock.
 */
template <typename T>
class MOZ_RAII BaseAutoUnlock {
 public:
  explicit BaseAutoUnlock(T aLock MOZ_GUARD_OBJECT_NOTIFIER_PARAM)
      : mLock(aLock) {
    MOZ_GUARD_OBJECT_NOTIFIER_INIT;
    mLock.Unlock();
  }

  explicit BaseAutoUnlock(
      BaseAutoLock<T>& aAutoLock MOZ_GUARD_OBJECT_NOTIFIER_PARAM)
      : mLock(aAutoLock.mLock) {
    MOZ_GUARD_OBJECT_NOTIFIER_INIT;
    NS_ASSERTION(mLock, "null lock");
    mLock->Unlock();
  }

  ~BaseAutoUnlock() { mLock.Lock(); }

 private:
  BaseAutoUnlock();
  BaseAutoUnlock(BaseAutoUnlock&);
  BaseAutoUnlock& operator=(BaseAutoUnlock&);
  static void* operator new(size_t) noexcept(true);

  T mLock;
  MOZ_DECL_USE_GUARD_OBJECT_NOTIFIER
};

template <typename MutexType>
BaseAutoUnlock(MutexType&) -> BaseAutoUnlock<MutexType&>;
}  // namespace detail

typedef detail::BaseAutoUnlock<Mutex&> MutexAutoUnlock;
typedef detail::BaseAutoUnlock<OffTheBooksMutex&> OffTheBooksMutexAutoUnlock;

}  // namespace mozilla

#endif  // ifndef mozilla_Mutex_h
