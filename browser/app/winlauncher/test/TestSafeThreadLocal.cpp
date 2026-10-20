/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

#define MOZ_USE_LAUNCHER_ERROR

#include "freestanding/SafeThreadLocal.h"

#include "mozilla/NativeNt.h"
#include "nsWindowsHelpers.h"

#include <process.h>
#include <stdio.h>

// Need a non-inline function to bypass compiler optimization that the thread
// local storage pointer is cached in a register before accessing a thread-local
// variable.
MOZ_NEVER_INLINE PVOID SwapThreadLocalStoragePointer(PVOID aNewValue) {
  auto oldValue = mozilla::nt::RtlGetThreadLocalStoragePointer();
  mozilla::nt::RtlSetThreadLocalStoragePointerForTestingOnly(aNewValue);
  return oldValue;
}

static mozilla::freestanding::SafeThreadLocal<int*> gTheStorage;

// Need non-inline functions to bypass compiler optimization that the thread
// local storage pointer is cached in a register before accessing a thread-local
// variable. See bug 1803322 for a motivating example.
MOZ_NEVER_INLINE int* getTheStorage() { return gTheStorage.get(); }
MOZ_NEVER_INLINE bool setTheStorage(int* p) { return gTheStorage.set(p); }

static unsigned int __stdcall TestNonMainThread(void* aArg) {
  for (int i = 0; i < 100; ++i) {
    setTheStorage(&i);
    if (getTheStorage() != &i) {
      printf(
          "TEST-FAILED | TestSafeThreadLocal | "
          "A value is not correctly stored in the thread-local storage.\n");
      return 1;
    }
  }
  return 0;
}

// Models a thread the loader doesn't initialize, like ones created with
// THREAD_CREATE_FLAGS_SKIP_LOADER_INIT.  The thread will not have
// thread-local storage, so there is nothing to store HANDLEs in and
// nothing to read back.  The set and get operations should fail (return false)
// and return the T's default value respectively.
static unsigned int __stdcall TestThreadWithoutTls(void* aArg) {
  int local = 0;
  auto origHead = SwapThreadLocalStoragePointer(nullptr);
  bool stored = setTheStorage(&local);
  int* value = getTheStorage();
  SwapThreadLocalStoragePointer(origHead);

  if (stored || value) {
    printf(
        "TEST-FAILED | TestSafeThreadLocal | "
        "A thread without TLS must not store or read a value.\n");
    return 1;
  }
  return 0;
}

// A thread that has stored nothing must read nothing, even before any thread
// has used TLS and the main thread holds a value in the global fallback.
static unsigned int __stdcall TestThreadReadsNothing(void* aArg) {
  if (getTheStorage()) {
    printf(
        "TEST-FAILED | TestSafeThreadLocal | "
        "A thread read the main thread's value.\n");
    return 1;
  }
  return 0;
}

static bool RunThread(unsigned int(__stdcall* aRoutine)(void*)) {
  nsAutoHandle handle(reinterpret_cast<HANDLE>(
      ::_beginthreadex(nullptr, 0, aRoutine, nullptr, 0, nullptr)));
  if (!handle) {
    return false;
  }
  ::WaitForSingleObject(handle, INFINITE);

#if defined(MOZ_ASAN)
  // ASAN builds under Windows 11 can have unexpected thread exit codes.
  // See bug 1798796
  return true;
#else
  DWORD exitCode;
  return ::GetExitCodeThread(handle, &exitCode) && !exitCode;
#endif  // defined(MOZ_ASAN)
}

extern "C" int wmain(int argc, wchar_t* argv[]) {
  int dummy = 0x1234;

  auto origHead = SwapThreadLocalStoragePointer(nullptr);
  // Setting gTheStorage when TLS is null.
  setTheStorage(&dummy);
  SwapThreadLocalStoragePointer(origHead);

  // Before any other thread has used TLS, a thread without TLS must not take
  // over the main thread's global slot.
  if (!RunThread(TestThreadWithoutTls) || !RunThread(TestThreadReadsNothing) ||
      getTheStorage() != &dummy) {
    return 1;
  }

  nsAutoHandle handles[8];
  for (auto& handle : handles) {
    handle.own(reinterpret_cast<HANDLE>(
        ::_beginthreadex(nullptr, 0, TestNonMainThread, nullptr, 0, nullptr)));
  }

  for (int i = 0; i < 100; ++i) {
    if (getTheStorage() != &dummy) {
      printf(
          "TEST-FAILED | TestSafeThreadLocal | "
          "A value is not correctly stored in the global scope.\n");
      return 1;
    }
  }

  for (auto& handle : handles) {
    ::WaitForSingleObject(handle, INFINITE);

#if !defined(MOZ_ASAN)
    // ASAN builds under Windows 11 can have unexpected thread exit codes.
    // See bug 1798796
    DWORD exitCode;
    if (!::GetExitCodeThread(handle, &exitCode) || exitCode) {
      return 1;
    }
#endif  // !defined(MOZ_ASAN)
  }

  // Now that other threads have used TLS, a thread without TLS must be
  // tolerated without disturbing the main thread's value.
  if (!RunThread(TestThreadWithoutTls) || getTheStorage() != &dummy) {
    return 1;
  }

  return 0;
}
