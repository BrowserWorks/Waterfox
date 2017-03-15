/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef nsTimerImpl_h___
#define nsTimerImpl_h___

#include "nsITimer.h"
#include "nsIEventTarget.h"
#include "nsIObserver.h"

#include "nsCOMPtr.h"

#include "mozilla/Attributes.h"
#include "mozilla/Logging.h"
#include "mozilla/Mutex.h"
#include "mozilla/TimeStamp.h"
#include "mozilla/Variant.h"

#ifdef MOZ_TASK_TRACER
#include "TracedTaskCommon.h"
#endif

extern mozilla::LogModule* GetTimerLog();

#define NS_TIMER_CID \
{ /* 5ff24248-1dd2-11b2-8427-fbab44f29bc8 */         \
     0x5ff24248,                                     \
     0x1dd2,                                         \
     0x11b2,                                         \
    {0x84, 0x27, 0xfb, 0xab, 0x44, 0xf2, 0x9b, 0xc8} \
}

// TimerThread, nsTimerEvent, and nsTimer have references to these. nsTimer has
// a separate lifecycle so we can Cancel() the underlying timer when the user of
// the nsTimer has let go of its last reference.
class nsTimerImpl
{
  ~nsTimerImpl() {}
public:
  typedef mozilla::TimeStamp TimeStamp;

  explicit nsTimerImpl(nsITimer* aTimer);
  NS_INLINE_DECL_THREADSAFE_REFCOUNTING(nsTimerImpl)
  NS_DECL_NON_VIRTUAL_NSITIMER

  static nsresult Startup();
  static void Shutdown();

  void Fire(int32_t aGeneration);

#ifdef MOZ_TASK_TRACER
  void GetTLSTraceInfo();
  mozilla::tasktracer::TracedTaskCommon GetTracedTask();
#endif

  int32_t GetGeneration()
  {
    return mGeneration;
  }

  nsresult InitCommon(uint32_t aDelay, uint32_t aType);

  struct Callback {
    Callback() :
      mType(Type::Unknown),
      mName(Nothing),
      mClosure(nullptr)
    {
      mCallback.c = nullptr;
    }

    Callback(const Callback& other) = delete;
    Callback& operator=(const Callback& other) = delete;

    ~Callback()
    {
      if (mType == Type::Interface) {
        NS_RELEASE(mCallback.i);
      } else if (mType == Type::Observer) {
        NS_RELEASE(mCallback.o);
      }
    }

    void swap(Callback& other)
    {
      std::swap(mType, other.mType);
      std::swap(mCallback, other.mCallback);
      std::swap(mName, other.mName);
      std::swap(mClosure, other.mClosure);
    }

    enum class Type : uint8_t {
      Unknown = 0,
      Interface = 1,
      Function = 2,
      Observer = 3,
    };
    Type mType;

    union CallbackUnion
    {
      nsTimerCallbackFunc c;
      // These refcounted references are managed manually, as they are in a union
      nsITimerCallback* MOZ_OWNING_REF i;
      nsIObserver* MOZ_OWNING_REF o;
    } mCallback;

    // |Name| is a tagged union type representing one of (a) nothing, (b) a
    // string, or (c) a function. mozilla::Variant doesn't naturally handle the
    // "nothing" case, so we define a dummy type and value (which is unused and
    // so the exact value doesn't matter) for it.
    typedef const int NameNothing;
    typedef const char* NameString;
    typedef nsTimerNameCallbackFunc NameFunc;
    typedef mozilla::Variant<NameNothing, NameString, NameFunc> Name;
    static const NameNothing Nothing;
    Name mName;

    void*                 mClosure;
  };

  Callback& GetCallback()
  {
    mMutex.AssertCurrentThreadOwns();
    if (mCallback.mType == Callback::Type::Unknown) {
      return mCallbackDuringFire;
    }

    return mCallback;
  }

  bool IsRepeating() const
  {
    static_assert(nsITimer::TYPE_ONE_SHOT < nsITimer::TYPE_REPEATING_SLACK,
                  "invalid ordering of timer types!");
    static_assert(
        nsITimer::TYPE_REPEATING_SLACK < nsITimer::TYPE_REPEATING_PRECISE,
        "invalid ordering of timer types!");
    static_assert(
        nsITimer::TYPE_REPEATING_PRECISE <
          nsITimer::TYPE_REPEATING_PRECISE_CAN_SKIP,
        "invalid ordering of timer types!");
    return mType >= nsITimer::TYPE_REPEATING_SLACK;
  }

  nsCOMPtr<nsIEventTarget> mEventTarget;

  void LogFiring(const Callback& aCallback, uint8_t aType, uint32_t aDelay);

  nsresult InitWithFuncCallbackCommon(nsTimerCallbackFunc aFunc,
                                      void* aClosure,
                                      uint32_t aDelay,
                                      uint32_t aType,
                                      Callback::Name aName);

  // These members are set by the initiating thread, when the timer's type is
  // changed and during the period where it fires on that thread.
  uint8_t               mType;

  // The generation number of this timer, re-generated each time the timer is
  // initialized so one-shot timers can be canceled and re-initialized by the
  // arming thread without any bad race conditions.
  // Updated only after this timer has been removed from the timer thread.
  int32_t               mGeneration;

  uint32_t              mDelay;
  // Updated only after this timer has been removed from the timer thread.
  TimeStamp             mTimeout;

#ifdef MOZ_TASK_TRACER
  mozilla::tasktracer::TracedTaskCommon mTracedTask;
#endif

  static double         sDeltaSum;
  static double         sDeltaSumSquared;
  static double         sDeltaNum;
  const RefPtr<nsITimer>      mITimer;
  mozilla::Mutex mMutex;
  Callback              mCallback;
  Callback              mCallbackDuringFire;
};

class nsTimer final : public nsITimer
{
  virtual ~nsTimer();
public:
  nsTimer() : mImpl(new nsTimerImpl(this)) {}

  friend class TimerThread;
  friend class nsTimerEvent;
  friend struct TimerAdditionComparator;

  NS_DECL_THREADSAFE_ISUPPORTS
  NS_FORWARD_SAFE_NSITIMER(mImpl);

  virtual size_t SizeOfIncludingThis(mozilla::MallocSizeOf aMallocSizeOf) const override;

private:
  // nsTimerImpl holds a strong ref to us. When our refcount goes to 1, we will
  // null this to break the cycle.
  RefPtr<nsTimerImpl> mImpl;
};

#endif /* nsTimerImpl_h___ */
