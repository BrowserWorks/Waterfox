/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "CacheIOThread.h"
#include "CacheFileIOManager.h"

#include "nsIRunnable.h"
#include "nsISupportsImpl.h"
#include "nsPrintfCString.h"
#include "nsThreadUtils.h"
#include "mozilla/IOInterposer.h"
#include "GeckoProfiler.h"

#ifdef XP_WIN
#include <windows.h>
#endif

#ifdef MOZ_TASK_TRACER
#include "GeckoTaskTracer.h"
#include "TracedTaskCommon.h"
#endif

namespace mozilla {
namespace net {

namespace { // anon

class CacheIOTelemetry
{
public:
  typedef CacheIOThread::EventQueue::size_type size_type;
  static size_type mMinLengthToReport[CacheIOThread::LAST_LEVEL];
  static void Report(uint32_t aLevel, size_type aLength);
};

static CacheIOTelemetry::size_type const kGranularity = 30;

CacheIOTelemetry::size_type 
CacheIOTelemetry::mMinLengthToReport[CacheIOThread::LAST_LEVEL] = {
  kGranularity, kGranularity, kGranularity, kGranularity,
  kGranularity, kGranularity, kGranularity, kGranularity
};

// static
void CacheIOTelemetry::Report(uint32_t aLevel, CacheIOTelemetry::size_type aLength)
{
  if (mMinLengthToReport[aLevel] > aLength) {
    return;
  }

  static Telemetry::HistogramID telemetryID[] = {
    Telemetry::HTTP_CACHE_IO_QUEUE_2_OPEN_PRIORITY,
    Telemetry::HTTP_CACHE_IO_QUEUE_2_READ_PRIORITY,
    Telemetry::HTTP_CACHE_IO_QUEUE_2_MANAGEMENT,
    Telemetry::HTTP_CACHE_IO_QUEUE_2_OPEN,
    Telemetry::HTTP_CACHE_IO_QUEUE_2_READ,
    Telemetry::HTTP_CACHE_IO_QUEUE_2_WRITE_PRIORITY,
    Telemetry::HTTP_CACHE_IO_QUEUE_2_WRITE,
    Telemetry::HTTP_CACHE_IO_QUEUE_2_INDEX,
    Telemetry::HTTP_CACHE_IO_QUEUE_2_EVICT
  };

  // Each bucket is a multiply of kGranularity (30, 60, 90..., 300+)
  aLength = (aLength / kGranularity);
  // Next time report only when over the current length + kGranularity
  mMinLengthToReport[aLevel] = (aLength + 1) * kGranularity;

  // 10 is number of buckets we have in each probe
  aLength = std::min<size_type>(aLength, 10);

  Telemetry::Accumulate(telemetryID[aLevel], aLength - 1); // counted from 0
}

} // anon

namespace detail {

/**
 * Helper class encapsulating platform-specific code to cancel
 * any pending IO operation taking too long.  Solely used during
 * shutdown to prevent any IO shutdown hangs.
 * Mainly designed for using Win32 CancelSynchronousIo function.
 */
class BlockingIOWatcher
{
#ifdef XP_WIN
  typedef BOOL(WINAPI* TCancelSynchronousIo)(HANDLE hThread);
  TCancelSynchronousIo mCancelSynchronousIo;
  // The native handle to the thread
  HANDLE mThread;
  // Event signaling back to the main thread, see NotifyOperationDone.
  HANDLE mEvent;
#endif

public:
  // Created and destroyed on the main thread only
  BlockingIOWatcher();
  ~BlockingIOWatcher();

  // Called on the IO thread to grab the platform specific
  // reference to it.
  void InitThread();
  // If there is a blocking operation being handled on the IO
  // thread, this is called on the main thread during shutdown.
  // Waits for notification from the IO thread for up to two seconds.
  // If that times out, it attempts to cancel the IO operation.
  void WatchAndCancel(Monitor& aMonitor);
  // Called by the IO thread after each operation has been
  // finished (after each Run() call).  This wakes the main
  // thread up and makes WatchAndCancel() early exit and become
  // a no-op.
  void NotifyOperationDone();
};

#ifdef XP_WIN

BlockingIOWatcher::BlockingIOWatcher()
  : mCancelSynchronousIo(NULL)
  , mThread(NULL)
  , mEvent(NULL)
{
  HMODULE kernel32_dll = GetModuleHandle("kernel32.dll");
  if (!kernel32_dll) {
    return;
  }

  FARPROC ptr = GetProcAddress(kernel32_dll, "CancelSynchronousIo");
  if (!ptr) {
    return;
  }

  mCancelSynchronousIo = reinterpret_cast<TCancelSynchronousIo>(ptr);

  mEvent = ::CreateEvent(NULL, TRUE, FALSE, NULL);
}

BlockingIOWatcher::~BlockingIOWatcher()
{
  if (mEvent) {
    CloseHandle(mEvent);
  }
  if (mThread) {
    CloseHandle(mThread);
  }
}

void BlockingIOWatcher::InitThread()
{
  // GetCurrentThread() only returns a pseudo handle, hence DuplicateHandle
  BOOL result = ::DuplicateHandle(
    GetCurrentProcess(),
    GetCurrentThread(),
    GetCurrentProcess(),
    &mThread,
    0,
    FALSE,
    DUPLICATE_SAME_ACCESS);
}

void BlockingIOWatcher::WatchAndCancel(Monitor& aMonitor)
{
  if (!mEvent) {
    return;
  }

  // Reset before we enter the monitor to raise the chance we catch
  // the currently pending IO op completion.
  ::ResetEvent(mEvent);

  HANDLE thread;
  {
    MonitorAutoLock lock(aMonitor);
    thread = mThread;

    if (!thread) {
      return;
    }
  }

  LOG(("Blocking IO operation pending on IO thread, waiting..."));

  // It seems wise to use the I/O lag time as a maximum time to wait
  // for an operation to finish.  When that times out and cancelation
  // succeeds, there will be no other IO operation permitted.  By default
  // this is two seconds.
  uint32_t maxLag = std::min<uint32_t>(5, CacheObserver::MaxShutdownIOLag()) * 1000;

  DWORD result = ::WaitForSingleObject(mEvent, maxLag);
  if (result == WAIT_TIMEOUT) {
    LOG(("CacheIOThread: Attempting to cancel a long blocking IO operation"));
    BOOL result = mCancelSynchronousIo(thread);
    if (result) {
      LOG(("  cancelation signal succeeded"));
    } else {
      DWORD error = GetLastError();
      LOG(("  cancelation signal failed with GetLastError=%u", error));
    }
  }
}

void BlockingIOWatcher::NotifyOperationDone()
{
  if (mEvent) {
    ::SetEvent(mEvent);
  }
}

#else // WIN

// Stub code only (we don't implement IO cancelation for this platform)

BlockingIOWatcher::BlockingIOWatcher() { }
BlockingIOWatcher::~BlockingIOWatcher() { }
void BlockingIOWatcher::InitThread() { }
void BlockingIOWatcher::WatchAndCancel(Monitor&) { }
void BlockingIOWatcher::NotifyOperationDone() { }

#endif

} // detail

CacheIOThread* CacheIOThread::sSelf = nullptr;

NS_IMPL_ISUPPORTS(CacheIOThread, nsIThreadObserver)

CacheIOThread::CacheIOThread()
: mMonitor("CacheIOThread")
, mThread(nullptr)
, mXPCOMThread(nullptr)
, mLowestLevelWaiting(LAST_LEVEL)
, mCurrentlyExecutingLevel(0)
, mHasXPCOMEvents(false)
, mRerunCurrentEvent(false)
, mShutdown(false)
, mIOCancelableEvents(0)
#ifdef DEBUG
, mInsideLoop(true)
#endif
{
  for (uint32_t i = 0; i < LAST_LEVEL; ++i) {
    mQueueLength[i] = 0;
  }

  sSelf = this;
}

CacheIOThread::~CacheIOThread()
{
  if (mXPCOMThread) {
    nsIThread *thread = mXPCOMThread;
    thread->Release();
  }

  sSelf = nullptr;
#ifdef DEBUG
  for (uint32_t level = 0; level < LAST_LEVEL; ++level) {
    MOZ_ASSERT(!mEventQueue[level].Length());
  }
#endif
}

nsresult CacheIOThread::Init()
{
  {
    MonitorAutoLock lock(mMonitor);
    // Yeah, there is not a thread yet, but we want to make sure
    // the sequencing is correct.
    mBlockingIOWatcher = MakeUnique<detail::BlockingIOWatcher>();
  }

  mThread = PR_CreateThread(PR_USER_THREAD, ThreadFunc, this,
                            PR_PRIORITY_NORMAL, PR_GLOBAL_THREAD,
                            PR_JOINABLE_THREAD, 128 * 1024);
  if (!mThread) {
    return NS_ERROR_FAILURE;
  }

  return NS_OK;
}

nsresult CacheIOThread::Dispatch(nsIRunnable* aRunnable, uint32_t aLevel)
{
  return Dispatch(do_AddRef(aRunnable), aLevel);
}

nsresult CacheIOThread::Dispatch(already_AddRefed<nsIRunnable> aRunnable,
				 uint32_t aLevel)
{
  NS_ENSURE_ARG(aLevel < LAST_LEVEL);

  nsCOMPtr<nsIRunnable> runnable(aRunnable);

  // Runnable is always expected to be non-null, hard null-check bellow.
  MOZ_ASSERT(runnable);

  MonitorAutoLock lock(mMonitor);

  if (mShutdown && (PR_GetCurrentThread() != mThread))
    return NS_ERROR_UNEXPECTED;

  return DispatchInternal(runnable.forget(), aLevel);
}

nsresult CacheIOThread::DispatchAfterPendingOpens(nsIRunnable* aRunnable)
{
  // Runnable is always expected to be non-null, hard null-check bellow.
  MOZ_ASSERT(aRunnable);

  MonitorAutoLock lock(mMonitor);

  if (mShutdown && (PR_GetCurrentThread() != mThread))
    return NS_ERROR_UNEXPECTED;

  // Move everything from later executed OPEN level to the OPEN_PRIORITY level
  // where we post the (eviction) runnable.
  mQueueLength[OPEN_PRIORITY] += mEventQueue[OPEN].Length();
  mQueueLength[OPEN] -= mEventQueue[OPEN].Length();
  mEventQueue[OPEN_PRIORITY].AppendElements(mEventQueue[OPEN]);
  mEventQueue[OPEN].Clear();

  return DispatchInternal(do_AddRef(aRunnable), OPEN_PRIORITY);
}

nsresult CacheIOThread::DispatchInternal(already_AddRefed<nsIRunnable> aRunnable,
					 uint32_t aLevel)
{
  nsCOMPtr<nsIRunnable> runnable(aRunnable);
#ifdef MOZ_TASK_TRACER
  if (tasktracer::IsStartLogging()) {
      runnable = tasktracer::CreateTracedRunnable(runnable.forget());
      (static_cast<tasktracer::TracedRunnable*>(runnable.get()))->DispatchTask();
  }
#endif

  if (NS_WARN_IF(!runnable))
    return NS_ERROR_NULL_POINTER;

  mMonitor.AssertCurrentThreadOwns();

  ++mQueueLength[aLevel];
  mEventQueue[aLevel].AppendElement(runnable.forget());
  if (mLowestLevelWaiting > aLevel)
    mLowestLevelWaiting = aLevel;

  mMonitor.NotifyAll();

  return NS_OK;
}

bool CacheIOThread::IsCurrentThread()
{
  return mThread == PR_GetCurrentThread();
}

uint32_t CacheIOThread::QueueSize(bool highPriority)
{
  MonitorAutoLock lock(mMonitor);
  if (highPriority) {
    return mQueueLength[OPEN_PRIORITY] + mQueueLength[READ_PRIORITY];
  }

  return mQueueLength[OPEN_PRIORITY] + mQueueLength[READ_PRIORITY] +
         mQueueLength[MANAGEMENT] + mQueueLength[OPEN] + mQueueLength[READ];
}

bool CacheIOThread::YieldInternal()
{
  if (!IsCurrentThread()) {
    NS_WARNING("Trying to yield to priority events on non-cache2 I/O thread? "
               "You probably do something wrong.");
    return false;
  }

  if (mCurrentlyExecutingLevel == XPCOM_LEVEL) {
    // Doesn't make any sense, since this handler is the one
    // that would be executed as the next one.
    return false;
  }

  if (!EventsPending(mCurrentlyExecutingLevel))
    return false;

  mRerunCurrentEvent = true;
  return true;
}

void CacheIOThread::Shutdown()
{
  if (!mThread) {
    return;
  }

  {
    MonitorAutoLock lock(mMonitor);
    mShutdown = true;
    mMonitor.NotifyAll();
  }

  PR_JoinThread(mThread);
  mThread = nullptr;
}

void CacheIOThread::CancelBlockingIO()
{
  // This is an attempt to cancel any blocking I/O operation taking
  // too long time.
  if (!mBlockingIOWatcher) {
    return;
  }

  if (!mIOCancelableEvents) {
    LOG(("CacheIOThread::CancelBlockingIO, no blocking operation to cancel"));
    return;
  }

  // OK, when we are here, we are processing an IO on the thread that
  // can be cancelled.
  mBlockingIOWatcher->WatchAndCancel(mMonitor);
}

already_AddRefed<nsIEventTarget> CacheIOThread::Target()
{
  nsCOMPtr<nsIEventTarget> target;

  target = mXPCOMThread;
  if (!target && mThread)
  {
    MonitorAutoLock lock(mMonitor);
    while (!mXPCOMThread) {
      lock.Wait();
    }

    target = mXPCOMThread;
  }

  return target.forget();
}

// static
void CacheIOThread::ThreadFunc(void* aClosure)
{
  // XXXmstange We'd like to register this thread with the profiler, but doing
  // so causes leaks, see bug 1323100.
  NS_SetCurrentThreadName("Cache2 I/O");

  mozilla::IOInterposer::RegisterCurrentThread();
  CacheIOThread* thread = static_cast<CacheIOThread*>(aClosure);
  thread->ThreadFunc();
  mozilla::IOInterposer::UnregisterCurrentThread();
}

void CacheIOThread::ThreadFunc()
{
  nsCOMPtr<nsIThreadInternal> threadInternal;

  {
    MonitorAutoLock lock(mMonitor);

    MOZ_ASSERT(mBlockingIOWatcher);
    mBlockingIOWatcher->InitThread();

    // This creates nsThread for this PRThread
    nsCOMPtr<nsIThread> xpcomThread = NS_GetCurrentThread();

    threadInternal = do_QueryInterface(xpcomThread);
    if (threadInternal)
      threadInternal->SetObserver(this);

    mXPCOMThread = xpcomThread.forget().take();

    lock.NotifyAll();

    do {
loopStart:
      // Reset the lowest level now, so that we can detect a new event on
      // a lower level (i.e. higher priority) has been scheduled while
      // executing any previously scheduled event.
      mLowestLevelWaiting = LAST_LEVEL;

      // Process xpcom events first
      while (mHasXPCOMEvents) {
        mHasXPCOMEvents = false;
        mCurrentlyExecutingLevel = XPCOM_LEVEL;

        MonitorAutoUnlock unlock(mMonitor);

        bool processedEvent;
        nsresult rv;
        do {
          nsIThread *thread = mXPCOMThread;
          rv = thread->ProcessNextEvent(false, &processedEvent);

          MOZ_ASSERT(mBlockingIOWatcher);
          mBlockingIOWatcher->NotifyOperationDone();
        } while (NS_SUCCEEDED(rv) && processedEvent);
      }

      uint32_t level;
      for (level = 0; level < LAST_LEVEL; ++level) {
        if (!mEventQueue[level].Length()) {
          // no events on this level, go to the next level
          continue;
        }

        LoopOneLevel(level);

        // Go to the first (lowest) level again
        goto loopStart;
      }

      if (EventsPending()) {
        continue;
      }

      if (mShutdown) {
        break;
      }

      lock.Wait(PR_INTERVAL_NO_TIMEOUT);

    } while (true);

    MOZ_ASSERT(!EventsPending());

#ifdef DEBUG
    // This is for correct assertion on XPCOM events dispatch.
    mInsideLoop = false;
#endif
  } // lock

  if (threadInternal)
    threadInternal->SetObserver(nullptr);
}

void CacheIOThread::LoopOneLevel(uint32_t aLevel)
{
  EventQueue events;
  events.SwapElements(mEventQueue[aLevel]);
  EventQueue::size_type length = events.Length();

  mCurrentlyExecutingLevel = aLevel;

  bool returnEvents = false;
  bool reportTelemetry = true;

  EventQueue::size_type index;
  {
    MonitorAutoUnlock unlock(mMonitor);

    for (index = 0; index < length; ++index) {
      if (EventsPending(aLevel)) {
        // Somebody scheduled a new event on a lower level, break and harry
        // to execute it!  Don't forget to return what we haven't exec.
        returnEvents = true;
        break;
      }

      if (reportTelemetry) {
        reportTelemetry = false;
        CacheIOTelemetry::Report(aLevel, length);
      }

      // Drop any previous flagging, only an event on the current level may set
      // this flag.
      mRerunCurrentEvent = false;

      events[index]->Run();

      MOZ_ASSERT(mBlockingIOWatcher);
      mBlockingIOWatcher->NotifyOperationDone();

      if (mRerunCurrentEvent) {
        // The event handler yields to higher priority events and wants to rerun.
        returnEvents = true;
        break;
      }

      --mQueueLength[aLevel];

      // Release outside the lock.
      events[index] = nullptr;
    }
  }

  if (returnEvents)
    mEventQueue[aLevel].InsertElementsAt(0, events.Elements() + index, length - index);
}

bool CacheIOThread::EventsPending(uint32_t aLastLevel)
{
  return mLowestLevelWaiting < aLastLevel || mHasXPCOMEvents;
}

NS_IMETHODIMP CacheIOThread::OnDispatchedEvent(nsIThreadInternal *thread)
{
  MonitorAutoLock lock(mMonitor);
  mHasXPCOMEvents = true;
  MOZ_ASSERT(mInsideLoop);
  lock.Notify();
  return NS_OK;
}

NS_IMETHODIMP CacheIOThread::OnProcessNextEvent(nsIThreadInternal *thread, bool mayWait)
{
  return NS_OK;
}

NS_IMETHODIMP CacheIOThread::AfterProcessNextEvent(nsIThreadInternal *thread,
                                                   bool eventWasProcessed)
{
  return NS_OK;
}

// Memory reporting

size_t CacheIOThread::SizeOfExcludingThis(mozilla::MallocSizeOf mallocSizeOf) const
{
  MonitorAutoLock lock(const_cast<CacheIOThread*>(this)->mMonitor);

  size_t n = 0;
  n += mallocSizeOf(mThread);
  for (uint32_t level = 0; level < LAST_LEVEL; ++level) {
    n += mEventQueue[level].ShallowSizeOfExcludingThis(mallocSizeOf);
    // Events referenced by the queues are arbitrary objects we cannot be sure
    // are reported elsewhere as well as probably not implementing nsISizeOf
    // interface.  Deliberatly omitting them from reporting here.
  }

  return n;
}

size_t CacheIOThread::SizeOfIncludingThis(mozilla::MallocSizeOf mallocSizeOf) const
{
  return mallocSizeOf(this) + SizeOfExcludingThis(mallocSizeOf);
}

CacheIOThread::Cancelable::Cancelable(bool aCancelable)
  : mCancelable(aCancelable)
{
  // This will only ever be used on the I/O thread,
  // which is expected to be alive longer than this class.
  MOZ_ASSERT(CacheIOThread::sSelf);
  MOZ_ASSERT(CacheIOThread::sSelf->IsCurrentThread());

  if (mCancelable) {
    ++CacheIOThread::sSelf->mIOCancelableEvents;
  }
}

CacheIOThread::Cancelable::~Cancelable()
{
  MOZ_ASSERT(CacheIOThread::sSelf);

  if (mCancelable) {
    --CacheIOThread::sSelf->mIOCancelableEvents;
  }
}

} // namespace net
} // namespace mozilla
