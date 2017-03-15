/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsTimerImpl.h"
#include "TimerThread.h"
#include "nsAutoPtr.h"
#include "nsThreadManager.h"
#include "nsThreadUtils.h"
#include "pratom.h"
#include "GeckoProfiler.h"
#include "mozilla/Atomics.h"
#include "mozilla/IntegerPrintfMacros.h"
#include "mozilla/Logging.h"
#ifdef MOZ_TASK_TRACER
#include "GeckoTaskTracerImpl.h"
using namespace mozilla::tasktracer;
#endif

#ifdef XP_WIN
#include <process.h>
#ifndef getpid
#define getpid _getpid
#endif
#else
#include <unistd.h>
#endif

using mozilla::Atomic;
using mozilla::LogLevel;
using mozilla::TimeDuration;
using mozilla::TimeStamp;

static TimerThread*     gThread = nullptr;

// This module prints info about the precision of timers.
static mozilla::LazyLogModule sTimerLog("nsTimerImpl");

mozilla::LogModule*
GetTimerLog()
{
  return sTimerLog;
}

// This module prints info about which timers are firing, which is useful for
// wakeups for the purposes of power profiling. Set the following environment
// variable before starting the browser.
//
//   MOZ_LOG=TimerFirings:4
//
// Then a line will be printed for every timer that fires. The name used for a
// |Callback::Type::Function| timer depends on the circumstances.
//
// - If it was explicitly named (e.g. it was initialized with
//   InitWithNamedFuncCallback()) then that explicit name will be shown.
//
// - Otherwise, if we are on a platform that supports function name lookup
//   (Mac or Linux) then the looked-up name will be shown with a
//   "[from dladdr]" annotation. On Mac the looked-up name will be immediately
//   useful. On Linux it'll need post-processing with
//   tools/rb/fix_linux_stack.py.
//
// - Otherwise, no name will be printed. If many timers hit this case then
//   you'll need to re-run the workload on a Mac to find out which timers they
//   are, and then give them explicit names.
//
// If you redirect this output to a file called "out", you can then
// post-process it with a command something like the following.
//
//   cat out | grep timer | sort | uniq -c | sort -r -n
//
// This will show how often each unique line appears, with the most common ones
// first.
//
// More detailed docs are here:
// https://developer.mozilla.org/en-US/docs/Mozilla/Performance/TimerFirings_logging
//
static mozilla::LazyLogModule sTimerFiringsLog("TimerFirings");

mozilla::LogModule*
GetTimerFiringsLog()
{
  return sTimerFiringsLog;
}

#include <math.h>

double nsTimerImpl::sDeltaSumSquared = 0;
double nsTimerImpl::sDeltaSum = 0;
double nsTimerImpl::sDeltaNum = 0;

static void
myNS_MeanAndStdDev(double n, double sumOfValues, double sumOfSquaredValues,
                   double* meanResult, double* stdDevResult)
{
  double mean = 0.0, var = 0.0, stdDev = 0.0;
  if (n > 0.0 && sumOfValues >= 0) {
    mean = sumOfValues / n;
    double temp = (n * sumOfSquaredValues) - (sumOfValues * sumOfValues);
    if (temp < 0.0 || n <= 1) {
      var = 0.0;
    } else {
      var = temp / (n * (n - 1));
    }
    // for some reason, Windows says sqrt(0.0) is "-1.#J" (?!) so do this:
    stdDev = var != 0.0 ? sqrt(var) : 0.0;
  }
  *meanResult = mean;
  *stdDevResult = stdDev;
}

NS_IMPL_QUERY_INTERFACE(nsTimer, nsITimer)
NS_IMPL_ADDREF(nsTimer)

NS_IMETHODIMP_(MozExternalRefCountType)
nsTimer::Release(void)
{
  nsrefcnt count = --mRefCnt;
  NS_LOG_RELEASE(this, count, "nsTimer");

  if (count == 1) {
    // Last ref, held by nsTimerImpl. Make sure the cycle is broken.
    // If there is a nsTimerEvent in a queue for this timer, the nsTimer will
    // live until that event pops, otherwise the nsTimerImpl will go away and
    // the nsTimer along with it.
    mImpl->Cancel();
    mImpl = nullptr;
  } else if (count == 0) {
    delete this;
  }

  return count;
}

nsTimerImpl::nsTimerImpl(nsITimer* aTimer) :
  mGeneration(0),
  mDelay(0),
  mITimer(aTimer),
  mMutex("nsTimerImpl::mMutex")
{
  // XXXbsmedberg: shouldn't this be in Init()?
  mEventTarget = static_cast<nsIEventTarget*>(NS_GetCurrentThread());
}

//static
nsresult
nsTimerImpl::Startup()
{
  nsresult rv;

  gThread = new TimerThread();

  NS_ADDREF(gThread);
  rv = gThread->InitLocks();

  if (NS_FAILED(rv)) {
    NS_RELEASE(gThread);
  }

  return rv;
}

void
nsTimerImpl::Shutdown()
{
  if (MOZ_LOG_TEST(GetTimerLog(), LogLevel::Debug)) {
    double mean = 0, stddev = 0;
    myNS_MeanAndStdDev(sDeltaNum, sDeltaSum, sDeltaSumSquared, &mean, &stddev);

    MOZ_LOG(GetTimerLog(), LogLevel::Debug,
           ("sDeltaNum = %f, sDeltaSum = %f, sDeltaSumSquared = %f\n",
            sDeltaNum, sDeltaSum, sDeltaSumSquared));
    MOZ_LOG(GetTimerLog(), LogLevel::Debug,
           ("mean: %fms, stddev: %fms\n", mean, stddev));
  }

  if (!gThread) {
    return;
  }

  gThread->Shutdown();
  NS_RELEASE(gThread);
}


nsresult
nsTimerImpl::InitCommon(uint32_t aDelay, uint32_t aType)
{
  mMutex.AssertCurrentThreadOwns();
  nsresult rv;

  if (NS_WARN_IF(!gThread)) {
    return NS_ERROR_NOT_INITIALIZED;
  }
  if (!mEventTarget) {
    NS_ERROR("mEventTarget is NULL");
    return NS_ERROR_NOT_INITIALIZED;
  }

  rv = gThread->Init();
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  gThread->RemoveTimer(this);
  ++mGeneration;

  mType = (uint8_t)aType;
  mDelay = aDelay;
  mTimeout = TimeStamp::Now() + TimeDuration::FromMilliseconds(mDelay);

  return gThread->AddTimer(this);
}

nsresult
nsTimerImpl::InitWithFuncCallbackCommon(nsTimerCallbackFunc aFunc,
                                        void* aClosure,
                                        uint32_t aDelay,
                                        uint32_t aType,
                                        Callback::Name aName)
{
  if (NS_WARN_IF(!aFunc)) {
    return NS_ERROR_INVALID_ARG;
  }

  Callback cb; // Goes out of scope after the unlock, prevents deadlock
  cb.mType = Callback::Type::Function;
  cb.mCallback.c = aFunc;
  cb.mClosure = aClosure;
  cb.mName = aName;

  MutexAutoLock lock(mMutex);
  cb.swap(mCallback);

  return InitCommon(aDelay, aType);
}

NS_IMETHODIMP
nsTimerImpl::InitWithFuncCallback(nsTimerCallbackFunc aFunc,
                                  void* aClosure,
                                  uint32_t aDelay,
                                  uint32_t aType)
{
  Callback::Name name(Callback::Nothing);
  return InitWithFuncCallbackCommon(aFunc, aClosure, aDelay, aType, name);
}

NS_IMETHODIMP
nsTimerImpl::InitWithNamedFuncCallback(nsTimerCallbackFunc aFunc,
                                       void* aClosure,
                                       uint32_t aDelay,
                                       uint32_t aType,
                                       const char* aNameString)
{
  Callback::Name name(aNameString);
  return InitWithFuncCallbackCommon(aFunc, aClosure, aDelay, aType, name);
}

NS_IMETHODIMP
nsTimerImpl::InitWithNameableFuncCallback(nsTimerCallbackFunc aFunc,
                                          void* aClosure,
                                          uint32_t aDelay,
                                          uint32_t aType,
                                          nsTimerNameCallbackFunc aNameFunc)
{
  Callback::Name name(aNameFunc);
  return InitWithFuncCallbackCommon(aFunc, aClosure, aDelay, aType, name);
}

NS_IMETHODIMP
nsTimerImpl::InitWithCallback(nsITimerCallback* aCallback,
                              uint32_t aDelay,
                              uint32_t aType)
{
  if (NS_WARN_IF(!aCallback)) {
    return NS_ERROR_INVALID_ARG;
  }

  Callback cb; // Goes out of scope after the unlock, prevents deadlock
  cb.mType = Callback::Type::Interface;
  cb.mCallback.i = aCallback;
  NS_ADDREF(cb.mCallback.i);

  MutexAutoLock lock(mMutex);
  cb.swap(mCallback);

  return InitCommon(aDelay, aType);
}

NS_IMETHODIMP
nsTimerImpl::Init(nsIObserver* aObserver, uint32_t aDelay, uint32_t aType)
{
  if (NS_WARN_IF(!aObserver)) {
    return NS_ERROR_INVALID_ARG;
  }

  Callback cb; // Goes out of scope after the unlock, prevents deadlock
  cb.mType = Callback::Type::Observer;
  cb.mCallback.o = aObserver;
  NS_ADDREF(cb.mCallback.o);

  MutexAutoLock lock(mMutex);
  cb.swap(mCallback);

  return InitCommon(aDelay, aType);
}

NS_IMETHODIMP
nsTimerImpl::Cancel()
{
  Callback cb;

  MutexAutoLock lock(mMutex);

  if (gThread) {
    gThread->RemoveTimer(this);
  }

  cb.swap(mCallback);
  ++mGeneration;

  return NS_OK;
}

NS_IMETHODIMP
nsTimerImpl::SetDelay(uint32_t aDelay)
{
  MutexAutoLock lock(mMutex);
  if (GetCallback().mType == Callback::Type::Unknown && !IsRepeating()) {
    // This may happen if someone tries to re-use a one-shot timer
    // by re-setting delay instead of reinitializing the timer.
    NS_ERROR("nsITimer->SetDelay() called when the "
             "one-shot timer is not set up.");
    return NS_ERROR_NOT_INITIALIZED;
  }

  bool reAdd = false;
  if (gThread) {
    reAdd = NS_SUCCEEDED(gThread->RemoveTimer(this));
  }

  mDelay = aDelay;
  mTimeout = TimeStamp::Now() + TimeDuration::FromMilliseconds(mDelay);

  if (reAdd) {
    gThread->AddTimer(this);
  }

  return NS_OK;
}

NS_IMETHODIMP
nsTimerImpl::GetDelay(uint32_t* aDelay)
{
  MutexAutoLock lock(mMutex);
  *aDelay = mDelay;
  return NS_OK;
}

NS_IMETHODIMP
nsTimerImpl::SetType(uint32_t aType)
{
  MutexAutoLock lock(mMutex);
  mType = (uint8_t)aType;
  // XXX if this is called, we should change the actual type.. this could effect
  // repeating timers.  we need to ensure in Fire() that if mType has changed
  // during the callback that we don't end up with the timer in the queue twice.
  return NS_OK;
}

NS_IMETHODIMP
nsTimerImpl::GetType(uint32_t* aType)
{
  MutexAutoLock lock(mMutex);
  *aType = mType;
  return NS_OK;
}


NS_IMETHODIMP
nsTimerImpl::GetClosure(void** aClosure)
{
  MutexAutoLock lock(mMutex);
  *aClosure = GetCallback().mClosure;
  return NS_OK;
}


NS_IMETHODIMP
nsTimerImpl::GetCallback(nsITimerCallback** aCallback)
{
  MutexAutoLock lock(mMutex);
  if (GetCallback().mType == Callback::Type::Interface) {
    NS_IF_ADDREF(*aCallback = GetCallback().mCallback.i);
  } else {
    *aCallback = nullptr;
  }

  return NS_OK;
}


NS_IMETHODIMP
nsTimerImpl::GetTarget(nsIEventTarget** aTarget)
{
  MutexAutoLock lock(mMutex);
  NS_IF_ADDREF(*aTarget = mEventTarget);
  return NS_OK;
}


NS_IMETHODIMP
nsTimerImpl::SetTarget(nsIEventTarget* aTarget)
{
  MutexAutoLock lock(mMutex);
  if (NS_WARN_IF(mCallback.mType != Callback::Type::Unknown)) {
    return NS_ERROR_ALREADY_INITIALIZED;
  }

  if (aTarget) {
    mEventTarget = aTarget;
  } else {
    mEventTarget = static_cast<nsIEventTarget*>(NS_GetCurrentThread());
  }
  return NS_OK;
}


void
nsTimerImpl::Fire(int32_t aGeneration)
{
  uint8_t oldType;
  uint32_t oldDelay;
  TimeStamp oldTimeout;

  {
    // Don't fire callbacks or fiddle with refcounts when the mutex is locked.
    // If some other thread Cancels/Inits after this, they're just too late.
    MutexAutoLock lock(mMutex);
    if (aGeneration != mGeneration) {
      return;
    }

    mCallbackDuringFire.swap(mCallback);
    oldType = mType;
    oldDelay = mDelay;
    oldTimeout = mTimeout;
  }

  PROFILER_LABEL("Timer", "Fire",
                 js::ProfileEntry::Category::OTHER);

  TimeStamp now = TimeStamp::Now();
  if (MOZ_LOG_TEST(GetTimerLog(), LogLevel::Debug)) {
    TimeDuration   delta = now - oldTimeout;
    int32_t       d = delta.ToMilliseconds(); // delta in ms
    sDeltaSum += abs(d);
    sDeltaSumSquared += double(d) * double(d);
    sDeltaNum++;

    MOZ_LOG(GetTimerLog(), LogLevel::Debug,
           ("[this=%p] expected delay time %4ums\n", this, oldDelay));
    MOZ_LOG(GetTimerLog(), LogLevel::Debug,
           ("[this=%p] actual delay time   %4dms\n", this, oldDelay + d));
    MOZ_LOG(GetTimerLog(), LogLevel::Debug,
           ("[this=%p] (mType is %d)       -------\n", this, oldType));
    MOZ_LOG(GetTimerLog(), LogLevel::Debug,
           ("[this=%p]     delta           %4dms\n", this, d));
  }

  if (MOZ_LOG_TEST(GetTimerFiringsLog(), LogLevel::Debug)) {
    LogFiring(mCallbackDuringFire, oldType, oldDelay);
  }

  switch (mCallbackDuringFire.mType) {
    case Callback::Type::Function:
      mCallbackDuringFire.mCallback.c(mITimer, mCallbackDuringFire.mClosure);
      break;
    case Callback::Type::Interface:
      mCallbackDuringFire.mCallback.i->Notify(mITimer);
      break;
    case Callback::Type::Observer:
      mCallbackDuringFire.mCallback.o->Observe(mITimer, NS_TIMER_CALLBACK_TOPIC,
                                               nullptr);
      break;
    default:
      ;
  }

  Callback trash; // Swap into here to dispose of callback after the unlock
  MutexAutoLock lock(mMutex);
  if (aGeneration == mGeneration && IsRepeating()) {
    // Repeating timer has not been re-init or canceled; reschedule
    mCallbackDuringFire.swap(mCallback);
    TimeDuration delay = TimeDuration::FromMilliseconds(mDelay);
    if (mType == nsITimer::TYPE_REPEATING_SLACK) {
      mTimeout = TimeStamp::Now() + delay;
    } else {
      mTimeout = mTimeout + delay;
    }
    if (gThread) {
      gThread->AddTimer(this);
    }
  }

  mCallbackDuringFire.swap(trash);

  MOZ_LOG(GetTimerLog(), LogLevel::Debug,
         ("[this=%p] Took %fms to fire timer callback\n",
          this, (TimeStamp::Now() - now).ToMilliseconds()));
}

#if defined(HAVE_DLADDR) && defined(HAVE___CXA_DEMANGLE)
#define USE_DLADDR 1
#endif

#ifdef USE_DLADDR
#include <cxxabi.h>
#include <dlfcn.h>
#endif

// See the big comment above GetTimerFiringsLog() to understand this code.
void
nsTimerImpl::LogFiring(const Callback& aCallback, uint8_t aType, uint32_t aDelay)
{
  const char* typeStr;
  switch (aType) {
    case nsITimer::TYPE_ONE_SHOT:                   typeStr = "ONE_SHOT"; break;
    case nsITimer::TYPE_REPEATING_SLACK:            typeStr = "SLACK   "; break;
    case nsITimer::TYPE_REPEATING_PRECISE:          /* fall through */
    case nsITimer::TYPE_REPEATING_PRECISE_CAN_SKIP: typeStr = "PRECISE "; break;
    default:                              MOZ_CRASH("bad type");
  }

  switch (aCallback.mType) {
    case Callback::Type::Function: {
      bool needToFreeName = false;
      const char* annotation = "";
      const char* name;
      static const size_t buflen = 1024;
      char buf[buflen];

      if (aCallback.mName.is<Callback::NameString>()) {
        name = aCallback.mName.as<Callback::NameString>();

      } else if (aCallback.mName.is<Callback::NameFunc>()) {
        aCallback.mName.as<Callback::NameFunc>()(
            mITimer, aCallback.mClosure, buf, buflen);
        name = buf;

      } else {
        MOZ_ASSERT(aCallback.mName.is<Callback::NameNothing>());
#ifdef USE_DLADDR
        annotation = "[from dladdr] ";

        Dl_info info;
        void* addr = reinterpret_cast<void*>(aCallback.mCallback.c);
        if (dladdr(addr, &info) == 0) {
          name = "???[dladdr: failed]";

        } else if (info.dli_sname) {
          int status;
          name = abi::__cxa_demangle(info.dli_sname, nullptr, nullptr, &status);
          if (status == 0) {
            // Success. Because we didn't pass in a buffer to __cxa_demangle it
            // allocates its own one with malloc() which we must free() later.
            MOZ_ASSERT(name);
            needToFreeName = true;
          } else if (status == -1) {
            name = "???[__cxa_demangle: OOM]";
          } else if (status == -2) {
            name = "???[__cxa_demangle: invalid mangled name]";
          } else if (status == -3) {
            name = "???[__cxa_demangle: invalid argument]";
          } else {
            name = "???[__cxa_demangle: unexpected status value]";
          }

        } else if (info.dli_fname) {
          // The "#0: " prefix is necessary for fix_linux_stack.py to interpret
          // this string as something to convert.
          snprintf(buf, buflen, "#0: ???[%s +0x%" PRIxPTR "]\n",
                   info.dli_fname, uintptr_t(addr) - uintptr_t(info.dli_fbase));
          name = buf;

        } else {
          name = "???[dladdr: no symbol or shared object obtained]";
        }
#else
        name = "???[dladdr is unimplemented or doesn't work well on this OS]";
#endif
      }

      MOZ_LOG(GetTimerFiringsLog(), LogLevel::Debug,
              ("[%d]    fn timer (%s %5d ms): %s%s\n",
               getpid(), typeStr, aDelay, annotation, name));

      if (needToFreeName) {
        free(const_cast<char*>(name));
      }

      break;
    }

    case Callback::Type::Interface: {
      MOZ_LOG(GetTimerFiringsLog(), LogLevel::Debug,
              ("[%d] iface timer (%s %5d ms): %p\n",
               getpid(), typeStr, aDelay, aCallback.mCallback.i));
      break;
    }

    case Callback::Type::Observer: {
      MOZ_LOG(GetTimerFiringsLog(), LogLevel::Debug,
              ("[%d]   obs timer (%s %5d ms): %p\n",
               getpid(), typeStr, aDelay, aCallback.mCallback.o));
      break;
    }

    case Callback::Type::Unknown:
    default: {
      MOZ_LOG(GetTimerFiringsLog(), LogLevel::Debug,
              ("[%d]   ??? timer (%s, %5d ms)\n",
               getpid(), typeStr, aDelay));
      break;
    }
  }
}

nsTimer::~nsTimer()
{
}

size_t
nsTimer::SizeOfIncludingThis(mozilla::MallocSizeOf aMallocSizeOf) const
{
  return aMallocSizeOf(this);
}

/* static */
const nsTimerImpl::Callback::NameNothing nsTimerImpl::Callback::Nothing = 0;

#ifdef MOZ_TASK_TRACER
void
nsTimerImpl::GetTLSTraceInfo()
{
  mTracedTask.GetTLSTraceInfo();
}

TracedTaskCommon
nsTimerImpl::GetTracedTask()
{
  return mTracedTask;
}

#endif

