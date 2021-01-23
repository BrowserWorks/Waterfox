// Copyright (c) 2012 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include "base/threading/platform_thread_win.h"

#include <stddef.h>

#include "base/debug/activity_tracker.h"
#include "base/debug/alias.h"
#include "base/debug/profiler.h"
#include "base/logging.h"
#include "base/metrics/histogram_macros.h"
#include "base/strings/utf_string_conversions.h"
#include "base/threading/scoped_blocking_call.h"
#include "base/threading/thread_id_name_manager.h"
#include "base/threading/thread_restrictions.h"
#include "base/win/scoped_handle.h"
#include "base/win/windows_version.h"

#include <windows.h>

namespace base {

namespace {

// The value returned by ::GetThreadPriority() after background thread mode is
// enabled on Windows 8+.
constexpr int kWin8AboveBackgroundThreadModePriority = -4;

// The information on how to set the thread name comes from
// a MSDN article: http://msdn2.microsoft.com/en-us/library/xcb2z8hs.aspx
const DWORD kVCThreadNameException = 0x406D1388;

typedef struct tagTHREADNAME_INFO {
  DWORD dwType;  // Must be 0x1000.
  LPCSTR szName;  // Pointer to name (in user addr space).
  DWORD dwThreadID;  // Thread ID (-1=caller thread).
  DWORD dwFlags;  // Reserved for future use, must be zero.
} THREADNAME_INFO;

// The SetThreadDescription API was brought in version 1607 of Windows 10.
typedef HRESULT(WINAPI* SetThreadDescription)(HANDLE hThread,
                                              PCWSTR lpThreadDescription);

// This function has try handling, so it is separated out of its caller.
void SetNameInternal(PlatformThreadId thread_id, const char* name) {
  //This function is only used for debugging purposes, as you can find by its caller
#ifndef __MINGW32__
  THREADNAME_INFO info;
  info.dwType = 0x1000;
  info.szName = name;
  info.dwThreadID = thread_id;
  info.dwFlags = 0;

  __try {
    RaiseException(kVCThreadNameException, 0, sizeof(info)/sizeof(DWORD),
                   reinterpret_cast<DWORD_PTR*>(&info));
  } __except(EXCEPTION_CONTINUE_EXECUTION) {
  }
#endif
}

struct ThreadParams {
  PlatformThread::Delegate* delegate;
  bool joinable;
  ThreadPriority priority;
};

DWORD __stdcall ThreadFunc(void* params) {
  ThreadParams* thread_params = static_cast<ThreadParams*>(params);
  PlatformThread::Delegate* delegate = thread_params->delegate;
  if (!thread_params->joinable)
    base::ThreadRestrictions::SetSingletonAllowed(false);

  if (thread_params->priority != ThreadPriority::NORMAL)
    PlatformThread::SetCurrentThreadPriority(thread_params->priority);

  // Retrieve a copy of the thread handle to use as the key in the
  // thread name mapping.
  PlatformThreadHandle::Handle platform_handle;
  BOOL did_dup = DuplicateHandle(GetCurrentProcess(),
                                GetCurrentThread(),
                                GetCurrentProcess(),
                                &platform_handle,
                                0,
                                FALSE,
                                DUPLICATE_SAME_ACCESS);

  win::ScopedHandle scoped_platform_handle;

  if (did_dup) {
    scoped_platform_handle.Set(platform_handle);
    ThreadIdNameManager::GetInstance()->RegisterThread(
        scoped_platform_handle.Get(),
        PlatformThread::CurrentId());
  }

  delete thread_params;
  delegate->ThreadMain();

  if (did_dup) {
    ThreadIdNameManager::GetInstance()->RemoveName(
        scoped_platform_handle.Get(),
        PlatformThread::CurrentId());
  }

  return 0;
}

// CreateThreadInternal() matches PlatformThread::CreateWithPriority(), except
// that |out_thread_handle| may be nullptr, in which case a non-joinable thread
// is created.
bool CreateThreadInternal(size_t stack_size,
                          PlatformThread::Delegate* delegate,
                          PlatformThreadHandle* out_thread_handle,
                          ThreadPriority priority) {
  unsigned int flags = 0;
  if (stack_size > 0) {
    flags = STACK_SIZE_PARAM_IS_A_RESERVATION;
  }

  ThreadParams* params = new ThreadParams;
  params->delegate = delegate;
  params->joinable = out_thread_handle != nullptr;
  params->priority = priority;

  void* thread_handle;
  {
    SCOPED_UMA_HISTOGRAM_TIMER("Windows.CreateThreadTime");

    // Using CreateThread here vs _beginthreadex makes thread creation a bit
    // faster and doesn't require the loader lock to be available.  Our code
    // will  have to work running on CreateThread() threads anyway, since we run
    // code on the Windows thread pool, etc.  For some background on the
    // difference:
    //   http://www.microsoft.com/msj/1099/win32/win321099.aspx
    thread_handle =
        ::CreateThread(nullptr, stack_size, ThreadFunc, params, flags, nullptr);
  }

  if (!thread_handle) {
    delete params;
    return false;
  }

  if (out_thread_handle)
    *out_thread_handle = PlatformThreadHandle(thread_handle);
  else
    CloseHandle(thread_handle);
  return true;
}

}  // namespace

namespace features {
const Feature kWindowsThreadModeBackground{"WindowsThreadModeBackground",
                                           FEATURE_DISABLED_BY_DEFAULT};
}  // namespace features

namespace internal {

void AssertMemoryPriority(HANDLE thread, int memory_priority) {
#if DCHECK_IS_ON()
  static const auto get_thread_information_fn =
      reinterpret_cast<decltype(&::GetThreadInformation)>(::GetProcAddress(
          ::GetModuleHandle(L"Kernel32.dll"), "GetThreadInformation"));

  if (!get_thread_information_fn) {
    DCHECK_EQ(win::GetVersion(), win::VERSION_WIN7);
    return;
  }

  MEMORY_PRIORITY_INFORMATION memory_priority_information = {};
  DCHECK(get_thread_information_fn(thread, ::ThreadMemoryPriority,
                                   &memory_priority_information,
                                   sizeof(memory_priority_information)));

  DCHECK_EQ(memory_priority,
            static_cast<int>(memory_priority_information.MemoryPriority));
#endif
}

}  // namespace internal

// static
PlatformThreadId PlatformThread::CurrentId() {
  return ::GetCurrentThreadId();
}

// static
PlatformThreadRef PlatformThread::CurrentRef() {
  return PlatformThreadRef(::GetCurrentThreadId());
}

// static
PlatformThreadHandle PlatformThread::CurrentHandle() {
  return PlatformThreadHandle(::GetCurrentThread());
}

// static
void PlatformThread::YieldCurrentThread() {
  ::Sleep(0);
}

// static
void PlatformThread::Sleep(TimeDelta duration) {
  // When measured with a high resolution clock, Sleep() sometimes returns much
  // too early. We may need to call it repeatedly to get the desired duration.
  TimeTicks end = TimeTicks::Now() + duration;
  for (TimeTicks now = TimeTicks::Now(); now < end; now = TimeTicks::Now())
    ::Sleep(static_cast<DWORD>((end - now).InMillisecondsRoundedUp()));
}

// static
void PlatformThread::SetName(const std::string& name) {
  ThreadIdNameManager::GetInstance()->SetName(name);

  // The SetThreadDescription API works even if no debugger is attached.
  auto set_thread_description_func =
      reinterpret_cast<SetThreadDescription>(::GetProcAddress(
          ::GetModuleHandle(L"Kernel32.dll"), "SetThreadDescription"));
  if (set_thread_description_func) {
    set_thread_description_func(::GetCurrentThread(),
                                base::UTF8ToWide(name).c_str());
  }

  // The debugger needs to be around to catch the name in the exception.  If
  // there isn't a debugger, we are just needlessly throwing an exception.
  if (!::IsDebuggerPresent())
    return;

  SetNameInternal(CurrentId(), name.c_str());
}

// static
const char* PlatformThread::GetName() {
  return ThreadIdNameManager::GetInstance()->GetName(CurrentId());
}

// static
bool PlatformThread::CreateWithPriority(size_t stack_size, Delegate* delegate,
                                        PlatformThreadHandle* thread_handle,
                                        ThreadPriority priority) {
  DCHECK(thread_handle);
  return CreateThreadInternal(stack_size, delegate, thread_handle, priority);
}

// static
bool PlatformThread::CreateNonJoinable(size_t stack_size, Delegate* delegate) {
  return CreateNonJoinableWithPriority(stack_size, delegate,
                                       ThreadPriority::NORMAL);
}

// static
bool PlatformThread::CreateNonJoinableWithPriority(size_t stack_size,
                                                   Delegate* delegate,
                                                   ThreadPriority priority) {
  return CreateThreadInternal(stack_size, delegate, nullptr /* non-joinable */,
                              priority);
}

// static
void PlatformThread::Join(PlatformThreadHandle thread_handle) {
  DCHECK(thread_handle.platform_handle());

  DWORD thread_id = 0;
  thread_id = ::GetThreadId(thread_handle.platform_handle());
  DWORD last_error = 0;
  if (!thread_id)
    last_error = ::GetLastError();

  // Record information about the exiting thread in case joining hangs.
  base::debug::Alias(&thread_id);
  base::debug::Alias(&last_error);

  // Record the event that this thread is blocking upon (for hang diagnosis).
  base::debug::ScopedThreadJoinActivity thread_activity(&thread_handle);

  base::internal::ScopedBlockingCallWithBaseSyncPrimitives scoped_blocking_call(
      base::BlockingType::MAY_BLOCK);

  // Wait for the thread to exit.  It should already have terminated but make
  // sure this assumption is valid.
  CHECK_EQ(WAIT_OBJECT_0,
           WaitForSingleObject(thread_handle.platform_handle(), INFINITE));
  CloseHandle(thread_handle.platform_handle());
}

// static
void PlatformThread::Detach(PlatformThreadHandle thread_handle) {
  CloseHandle(thread_handle.platform_handle());
}

// static
bool PlatformThread::CanIncreaseThreadPriority(ThreadPriority priority) {
  return true;
}

// static
void PlatformThread::SetCurrentThreadPriorityImpl(ThreadPriority priority) {
  // A DCHECK is triggered on FeatureList initialization if the state of a
  // feature has been checked before. We only want to trigger that DCHECK if the
  // priority has been set to BACKGROUND before, so we are careful not to access
  // the state of the feature needlessly. We don't DCHECK here because it is ok
  // if the FeatureList is never initialized in the process (e.g. in tests).
  //
  // TODO(fdoray): Remove experiment code. https://crbug.com/872820
  const bool use_thread_mode_background =
      (priority == ThreadPriority::BACKGROUND
           ? FeatureList::IsEnabled(features::kWindowsThreadModeBackground)
           : (FeatureList::GetInstance() &&
              FeatureList::IsEnabled(features::kWindowsThreadModeBackground)));

  PlatformThreadHandle::Handle thread_handle =
      PlatformThread::CurrentHandle().platform_handle();

  if (use_thread_mode_background && priority != ThreadPriority::BACKGROUND) {
    // Exit background mode if the new priority is not BACKGROUND. This is a
    // no-op if not in background mode.
    ::SetThreadPriority(thread_handle, THREAD_MODE_BACKGROUND_END);
    internal::AssertMemoryPriority(thread_handle, MEMORY_PRIORITY_NORMAL);
  }

  int desired_priority = THREAD_PRIORITY_ERROR_RETURN;
  switch (priority) {
    case ThreadPriority::BACKGROUND:
      desired_priority = use_thread_mode_background
                             ? THREAD_MODE_BACKGROUND_BEGIN
                             : THREAD_PRIORITY_LOWEST;
      break;
    case ThreadPriority::NORMAL:
      desired_priority = THREAD_PRIORITY_NORMAL;
      break;
    case ThreadPriority::DISPLAY:
      desired_priority = THREAD_PRIORITY_ABOVE_NORMAL;
      break;
    case ThreadPriority::REALTIME_AUDIO:
      desired_priority = THREAD_PRIORITY_TIME_CRITICAL;
      break;
    default:
      NOTREACHED() << "Unknown priority.";
      break;
  }
  DCHECK_NE(desired_priority, THREAD_PRIORITY_ERROR_RETURN);

#if DCHECK_IS_ON()
  const BOOL success =
#endif
      ::SetThreadPriority(thread_handle, desired_priority);
  DPLOG_IF(ERROR, !success) << "Failed to set thread priority to "
                            << desired_priority;

  if (use_thread_mode_background && priority == ThreadPriority::BACKGROUND) {
    // In a background process, THREAD_MODE_BACKGROUND_BEGIN lowers the memory
    // and I/O priorities but not the CPU priority (kernel bug?). Use
    // THREAD_PRIORITY_LOWEST to also lower the CPU priority.
    // https://crbug.com/901483
    if (GetCurrentThreadPriority() != ThreadPriority::BACKGROUND) {
      ::SetThreadPriority(thread_handle, THREAD_PRIORITY_LOWEST);
      // Make sure that using THREAD_PRIORITY_LOWEST didn't affect the memory
      // priority set by THREAD_MODE_BACKGROUND_BEGIN. There is no practical
      // way to verify the I/O priority.
      internal::AssertMemoryPriority(thread_handle, MEMORY_PRIORITY_VERY_LOW);
    }
  }

  DCHECK_EQ(GetCurrentThreadPriority(), priority);
}

// static
ThreadPriority PlatformThread::GetCurrentThreadPriority() {
  const int priority =
      ::GetThreadPriority(PlatformThread::CurrentHandle().platform_handle());

  switch (priority) {
    case THREAD_PRIORITY_IDLE:
    case internal::kWin7BackgroundThreadModePriority:
      DCHECK_EQ(win::GetVersion(), win::VERSION_WIN7);
      FALLTHROUGH;
    case kWin8AboveBackgroundThreadModePriority:
    case THREAD_PRIORITY_LOWEST:
      return ThreadPriority::BACKGROUND;
    case THREAD_PRIORITY_NORMAL:
      return ThreadPriority::NORMAL;
    case THREAD_PRIORITY_ABOVE_NORMAL:
      return ThreadPriority::DISPLAY;
    case THREAD_PRIORITY_TIME_CRITICAL:
      return ThreadPriority::REALTIME_AUDIO;
    case THREAD_PRIORITY_ERROR_RETURN:
      DPCHECK(false) << "GetThreadPriority error";
  }

  NOTREACHED() << "GetCurrentThreadPriority returned " << priority << ".";
  return ThreadPriority::NORMAL;
}

// static
size_t PlatformThread::GetDefaultThreadStackSize() {
  return 0;
}

}  // namespace base
