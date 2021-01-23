/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "PoisonIOInterposer.h"

#include <algorithm>
#include <stdio.h>
#include <vector>

#include <io.h>
#include <windows.h>
#include <winternl.h>

#include "mozilla/Assertions.h"
#include "mozilla/FileUtilsWin.h"
#include "mozilla/IOInterposer.h"
#include "mozilla/Mutex.h"
#include "mozilla/TimeStamp.h"
#include "nsTArray.h"
#include "nsWindowsDllInterceptor.h"
#include "plstr.h"

#ifdef MOZ_REPLACE_MALLOC
#  include "replace_malloc_bridge.h"
#endif

namespace {

// Keep track of poisoned state. Notice that there is no reason to lock access
// to this variable as it's only changed in InitPoisonIOInterposer and
// ClearPoisonIOInterposer which may only be called on the main-thread when no
// other threads are running.
static bool sIOPoisoned = false;

/************************ Internal NT API Declarations ************************/

/*
 * Function pointer declaration for internal NT routine to create/open files.
 * For documentation on the NtCreateFile routine, see MSDN.
 */
typedef NTSTATUS(NTAPI* NtCreateFileFn)(
    PHANDLE aFileHandle, ACCESS_MASK aDesiredAccess,
    POBJECT_ATTRIBUTES aObjectAttributes, PIO_STATUS_BLOCK aIoStatusBlock,
    PLARGE_INTEGER aAllocationSize, ULONG aFileAttributes, ULONG aShareAccess,
    ULONG aCreateDisposition, ULONG aCreateOptions, PVOID aEaBuffer,
    ULONG aEaLength);

/**
 * Function pointer declaration for internal NT routine to read data from file.
 * For documentation on the NtReadFile routine, see ZwReadFile on MSDN.
 */
typedef NTSTATUS(NTAPI* NtReadFileFn)(HANDLE aFileHandle, HANDLE aEvent,
                                      PIO_APC_ROUTINE aApc, PVOID aApcCtx,
                                      PIO_STATUS_BLOCK aIoStatus, PVOID aBuffer,
                                      ULONG aLength, PLARGE_INTEGER aOffset,
                                      PULONG aKey);

/**
 * Function pointer declaration for internal NT routine to read data from file.
 * No documentation exists, see wine sources for details.
 */
typedef NTSTATUS(NTAPI* NtReadFileScatterFn)(
    HANDLE aFileHandle, HANDLE aEvent, PIO_APC_ROUTINE aApc, PVOID aApcCtx,
    PIO_STATUS_BLOCK aIoStatus, FILE_SEGMENT_ELEMENT* aSegments, ULONG aLength,
    PLARGE_INTEGER aOffset, PULONG aKey);

/**
 * Function pointer declaration for internal NT routine to write data to file.
 * For documentation on the NtWriteFile routine, see ZwWriteFile on MSDN.
 */
typedef NTSTATUS(NTAPI* NtWriteFileFn)(HANDLE aFileHandle, HANDLE aEvent,
                                       PIO_APC_ROUTINE aApc, PVOID aApcCtx,
                                       PIO_STATUS_BLOCK aIoStatus,
                                       PVOID aBuffer, ULONG aLength,
                                       PLARGE_INTEGER aOffset, PULONG aKey);

/**
 * Function pointer declaration for internal NT routine to write data to file.
 * No documentation exists, see wine sources for details.
 */
typedef NTSTATUS(NTAPI* NtWriteFileGatherFn)(
    HANDLE aFileHandle, HANDLE aEvent, PIO_APC_ROUTINE aApc, PVOID aApcCtx,
    PIO_STATUS_BLOCK aIoStatus, FILE_SEGMENT_ELEMENT* aSegments, ULONG aLength,
    PLARGE_INTEGER aOffset, PULONG aKey);

/**
 * Function pointer declaration for internal NT routine to flush to disk.
 * For documentation on the NtFlushBuffersFile routine, see ZwFlushBuffersFile
 * on MSDN.
 */
typedef NTSTATUS(NTAPI* NtFlushBuffersFileFn)(HANDLE aFileHandle,
                                              PIO_STATUS_BLOCK aIoStatusBlock);

typedef struct _FILE_NETWORK_OPEN_INFORMATION* PFILE_NETWORK_OPEN_INFORMATION;
/**
 * Function pointer delaration for internal NT routine to query file attributes.
 * (equivalent to stat)
 */
typedef NTSTATUS(NTAPI* NtQueryFullAttributesFileFn)(
    POBJECT_ATTRIBUTES aObjectAttributes,
    PFILE_NETWORK_OPEN_INFORMATION aFileInformation);

/*************************** Auxiliary Declarations ***************************/

/**
 * RAII class for timing the duration of an I/O call and reporting the result
 * to the mozilla::IOInterposeObserver API.
 */
class WinIOAutoObservation : public mozilla::IOInterposeObserver::Observation {
 public:
  WinIOAutoObservation(mozilla::IOInterposeObserver::Operation aOp,
                       HANDLE aFileHandle, const LARGE_INTEGER* aOffset)
      : mozilla::IOInterposeObserver::Observation(
            aOp, sReference,
            !mozilla::IsDebugFile(reinterpret_cast<intptr_t>(aFileHandle))),
        mFileHandle(aFileHandle),
        mHasQueriedFilename(false) {
    if (mShouldReport) {
      mOffset.QuadPart = aOffset ? aOffset->QuadPart : 0;
    }
  }

  WinIOAutoObservation(mozilla::IOInterposeObserver::Operation aOp,
                       nsAString& aFilename)
      : mozilla::IOInterposeObserver::Observation(aOp, sReference),
        mFileHandle(nullptr),
        mHasQueriedFilename(false) {
    if (mShouldReport) {
      nsAutoString dosPath;
      if (mozilla::NtPathToDosPath(aFilename, dosPath)) {
        mFilename = dosPath;
      } else {
        // If we can't get a dosPath, what we have is better than nothing.
        mFilename = aFilename;
      }
      mHasQueriedFilename = true;
      mOffset.QuadPart = 0;
    }
  }

  // Custom implementation of
  // mozilla::IOInterposeObserver::Observation::Filename
  void Filename(nsAString& aFilename) override;

  ~WinIOAutoObservation() { Report(); }

 private:
  HANDLE mFileHandle;
  LARGE_INTEGER mOffset;
  bool mHasQueriedFilename;
  nsString mFilename;
  static const char* sReference;
};

const char* WinIOAutoObservation::sReference = "PoisonIOInterposer";

// Get filename for this observation
void WinIOAutoObservation::Filename(nsAString& aFilename) {
  // If mHasQueriedFilename is true, then filename is already stored in
  // mFilename
  if (mHasQueriedFilename) {
    aFilename = mFilename;
    return;
  }

  nsAutoString filename;
  if (mFileHandle &&
      mozilla::HandleToFilename(mFileHandle, mOffset, filename)) {
    mFilename = filename;
  }
  mHasQueriedFilename = true;

  aFilename = mFilename;
}

/*************************** IO Interposing Methods ***************************/

// Function pointers to original functions
static mozilla::WindowsDllInterceptor::FuncHookType<NtCreateFileFn>
    gOriginalNtCreateFile;
static mozilla::WindowsDllInterceptor::FuncHookType<NtReadFileFn>
    gOriginalNtReadFile;
static mozilla::WindowsDllInterceptor::FuncHookType<NtReadFileScatterFn>
    gOriginalNtReadFileScatter;
static mozilla::WindowsDllInterceptor::FuncHookType<NtWriteFileFn>
    gOriginalNtWriteFile;
static mozilla::WindowsDllInterceptor::FuncHookType<NtWriteFileGatherFn>
    gOriginalNtWriteFileGather;
static mozilla::WindowsDllInterceptor::FuncHookType<NtFlushBuffersFileFn>
    gOriginalNtFlushBuffersFile;
static mozilla::WindowsDllInterceptor::FuncHookType<NtQueryFullAttributesFileFn>
    gOriginalNtQueryFullAttributesFile;

static NTSTATUS NTAPI InterposedNtCreateFile(
    PHANDLE aFileHandle, ACCESS_MASK aDesiredAccess,
    POBJECT_ATTRIBUTES aObjectAttributes, PIO_STATUS_BLOCK aIoStatusBlock,
    PLARGE_INTEGER aAllocationSize, ULONG aFileAttributes, ULONG aShareAccess,
    ULONG aCreateDisposition, ULONG aCreateOptions, PVOID aEaBuffer,
    ULONG aEaLength) {
  // Report IO
  const wchar_t* buf =
      aObjectAttributes ? aObjectAttributes->ObjectName->Buffer : L"";
  uint32_t len = aObjectAttributes
                     ? aObjectAttributes->ObjectName->Length / sizeof(WCHAR)
                     : 0;
  nsDependentSubstring filename(buf, len);
  WinIOAutoObservation timer(mozilla::IOInterposeObserver::OpCreateOrOpen,
                             filename);

  // Something is badly wrong if this function is undefined
  MOZ_ASSERT(gOriginalNtCreateFile);

  // Execute original function
  return gOriginalNtCreateFile(aFileHandle, aDesiredAccess, aObjectAttributes,
                               aIoStatusBlock, aAllocationSize, aFileAttributes,
                               aShareAccess, aCreateDisposition, aCreateOptions,
                               aEaBuffer, aEaLength);
}

static NTSTATUS NTAPI InterposedNtReadFile(HANDLE aFileHandle, HANDLE aEvent,
                                           PIO_APC_ROUTINE aApc, PVOID aApcCtx,
                                           PIO_STATUS_BLOCK aIoStatus,
                                           PVOID aBuffer, ULONG aLength,
                                           PLARGE_INTEGER aOffset,
                                           PULONG aKey) {
  // Report IO
  WinIOAutoObservation timer(mozilla::IOInterposeObserver::OpRead, aFileHandle,
                             aOffset);

  // Something is badly wrong if this function is undefined
  MOZ_ASSERT(gOriginalNtReadFile);

  // Execute original function
  return gOriginalNtReadFile(aFileHandle, aEvent, aApc, aApcCtx, aIoStatus,
                             aBuffer, aLength, aOffset, aKey);
}

static NTSTATUS NTAPI InterposedNtReadFileScatter(
    HANDLE aFileHandle, HANDLE aEvent, PIO_APC_ROUTINE aApc, PVOID aApcCtx,
    PIO_STATUS_BLOCK aIoStatus, FILE_SEGMENT_ELEMENT* aSegments, ULONG aLength,
    PLARGE_INTEGER aOffset, PULONG aKey) {
  // Report IO
  WinIOAutoObservation timer(mozilla::IOInterposeObserver::OpRead, aFileHandle,
                             aOffset);

  // Something is badly wrong if this function is undefined
  MOZ_ASSERT(gOriginalNtReadFileScatter);

  // Execute original function
  return gOriginalNtReadFileScatter(aFileHandle, aEvent, aApc, aApcCtx,
                                    aIoStatus, aSegments, aLength, aOffset,
                                    aKey);
}

// Interposed NtWriteFile function
static NTSTATUS NTAPI InterposedNtWriteFile(HANDLE aFileHandle, HANDLE aEvent,
                                            PIO_APC_ROUTINE aApc, PVOID aApcCtx,
                                            PIO_STATUS_BLOCK aIoStatus,
                                            PVOID aBuffer, ULONG aLength,
                                            PLARGE_INTEGER aOffset,
                                            PULONG aKey) {
  // Report IO
  WinIOAutoObservation timer(mozilla::IOInterposeObserver::OpWrite, aFileHandle,
                             aOffset);

  // Something is badly wrong if this function is undefined
  MOZ_ASSERT(gOriginalNtWriteFile);

  // Execute original function
  return gOriginalNtWriteFile(aFileHandle, aEvent, aApc, aApcCtx, aIoStatus,
                              aBuffer, aLength, aOffset, aKey);
}

// Interposed NtWriteFileGather function
static NTSTATUS NTAPI InterposedNtWriteFileGather(
    HANDLE aFileHandle, HANDLE aEvent, PIO_APC_ROUTINE aApc, PVOID aApcCtx,
    PIO_STATUS_BLOCK aIoStatus, FILE_SEGMENT_ELEMENT* aSegments, ULONG aLength,
    PLARGE_INTEGER aOffset, PULONG aKey) {
  // Report IO
  WinIOAutoObservation timer(mozilla::IOInterposeObserver::OpWrite, aFileHandle,
                             aOffset);

  // Something is badly wrong if this function is undefined
  MOZ_ASSERT(gOriginalNtWriteFileGather);

  // Execute original function
  return gOriginalNtWriteFileGather(aFileHandle, aEvent, aApc, aApcCtx,
                                    aIoStatus, aSegments, aLength, aOffset,
                                    aKey);
}

static NTSTATUS NTAPI InterposedNtFlushBuffersFile(
    HANDLE aFileHandle, PIO_STATUS_BLOCK aIoStatusBlock) {
  // Report IO
  WinIOAutoObservation timer(mozilla::IOInterposeObserver::OpFSync, aFileHandle,
                             nullptr);

  // Something is badly wrong if this function is undefined
  MOZ_ASSERT(gOriginalNtFlushBuffersFile);

  // Execute original function
  return gOriginalNtFlushBuffersFile(aFileHandle, aIoStatusBlock);
}

static NTSTATUS NTAPI InterposedNtQueryFullAttributesFile(
    POBJECT_ATTRIBUTES aObjectAttributes,
    PFILE_NETWORK_OPEN_INFORMATION aFileInformation) {
  // Report IO
  const wchar_t* buf =
      aObjectAttributes ? aObjectAttributes->ObjectName->Buffer : L"";
  uint32_t len = aObjectAttributes
                     ? aObjectAttributes->ObjectName->Length / sizeof(WCHAR)
                     : 0;
  nsDependentSubstring filename(buf, len);
  WinIOAutoObservation timer(mozilla::IOInterposeObserver::OpStat, filename);

  // Something is badly wrong if this function is undefined
  MOZ_ASSERT(gOriginalNtQueryFullAttributesFile);

  // Execute original function
  return gOriginalNtQueryFullAttributesFile(aObjectAttributes,
                                            aFileInformation);
}

}  // namespace

/******************************** IO Poisoning ********************************/

// Windows DLL interceptor
static mozilla::WindowsDllInterceptor sNtDllInterceptor;

namespace mozilla {

void InitPoisonIOInterposer() {
  // Don't poison twice... as this function may only be invoked on the main
  // thread when no other threads are running, it safe to allow multiple calls
  // to InitPoisonIOInterposer() without complaining (ie. failing assertions).
  if (sIOPoisoned) {
    return;
  }
  sIOPoisoned = true;

  // Stdout and Stderr are OK.
  MozillaRegisterDebugFD(1);
  MozillaRegisterDebugFD(2);

#ifdef MOZ_REPLACE_MALLOC
  // The contract with InitDebugFd is that the given registry can be used
  // at any moment, so the instance needs to persist longer than the scope
  // of this functions.
  static DebugFdRegistry registry;
  ReplaceMalloc::InitDebugFd(registry);
#endif

  // Initialize dll interceptor and add hooks
  sNtDllInterceptor.Init("ntdll.dll");
  gOriginalNtCreateFile.Set(sNtDllInterceptor, "NtCreateFile",
                            &InterposedNtCreateFile);
  gOriginalNtReadFile.Set(sNtDllInterceptor, "NtReadFile",
                          &InterposedNtReadFile);
  gOriginalNtReadFileScatter.Set(sNtDllInterceptor, "NtReadFileScatter",
                                 &InterposedNtReadFileScatter);
  gOriginalNtWriteFile.Set(sNtDllInterceptor, "NtWriteFile",
                           &InterposedNtWriteFile);
  gOriginalNtWriteFileGather.Set(sNtDllInterceptor, "NtWriteFileGather",
                                 &InterposedNtWriteFileGather);
  gOriginalNtFlushBuffersFile.Set(sNtDllInterceptor, "NtFlushBuffersFile",
                                  &InterposedNtFlushBuffersFile);
  gOriginalNtQueryFullAttributesFile.Set(sNtDllInterceptor,
                                         "NtQueryFullAttributesFile",
                                         &InterposedNtQueryFullAttributesFile);
}

void ClearPoisonIOInterposer() {
  MOZ_ASSERT(false);
  if (sIOPoisoned) {
    // Destroy the DLL interceptor
    sIOPoisoned = false;
    sNtDllInterceptor.Clear();
  }
}

}  // namespace mozilla
