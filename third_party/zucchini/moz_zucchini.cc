/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/moz_zucchini.h"

#include "absl/types/optional.h"
#include "base/logging.h"
#include "base/files/file.h"
#include "base/files/file_util.h"
#include "build/build_config.h"
#include "components/zucchini/crc32.h"
#include "components/zucchini/mapped_file.h"
#include "components/zucchini/patch_reader.h"
#include "components/zucchini/zucchini.h"
#include "components/zucchini/zucchini_apply.h"

#include <cstdio>
#include <limits>
#include <new>
#include <string>

#if BUILDFLAG(IS_WIN)
// Get EXCEPTION_* constants defined with DWORD type
#  include <ntstatus.h>

#  include "components/zucchini/exception_filter_helper_win.h"

#  include <io.h>
#endif  // BUILDFLAG(IS_WIN)

namespace zucchini::mozilla {

#ifdef ENABLE_TESTS
// Helpers for crash recovery tests.

static TestOptions gTestOptions;

void SetTestOptions(const TestOptions& aTestOptions) {
  gTestOptions = aTestOptions;
}

// Test-only log to prove stack unwinding reaches local destructors when we
// recover from a fault originating from inside zucchini.
class ScopedDestructorMarker {
 public:
  ScopedDestructorMarker() = default;

  ~ScopedDestructorMarker() {
    if (!gTestOptions.logDestructorMarker) {
      return;
    }

    LOG(ERROR) << "MOZ_TEST_ZUCCHINI_DTOR_MARKER";
  }
};

// Test-only OOM injection used by updater tests to verify that a thrown
// bad_alloc is translated into kStatusOutOfMemory.
static void MaybeTriggerTestBadAlloc() {
  if (!gTestOptions.triggerBadAlloc) {
    return;
  }

  // This allocation is expected to throw std::bad_alloc. volatile prevents
  // the compiler from optimizing it away. If it somehow succeeded, CHECK(false)
  // ensures the test fails visibly rather than silently passing.
  void* volatile allocation = ::operator new(std::numeric_limits<size_t>::max());
  (void)allocation;
  CHECK(false);
}

// Test-only CHECK() injection used by updater tests to verify that deliberate
// crash paths are converted into kStatusFatal.
static void MaybeTriggerTestCheckFailure() {
  if (!gTestOptions.triggerCheckFailure) {
    return;
  }

  CHECK(false);
}
#endif  // ENABLE_TESTS

static LogFunctionPtr gLogFunction = nullptr;

static bool LogMessageHandler(int aSeverity, const char* aFile, int aLine,
                              size_t aMessageStart, const std::string& aStr) {
  if (!gLogFunction) {
    return false;
  }
  gLogFunction(aStr.c_str());
  return true;
}

void SetLogFunction(LogFunctionPtr aLogFunction) {
  gLogFunction = aLogFunction;
  logging::SetLogMessageHandler(LogMessageHandler);
}

uint32_t ComputeCrc32(const uint8_t* aBuf, size_t aBufSize) {
  return CalculateCrc32(aBuf, aBuf + aBufSize);
}

#if BUILDFLAG(IS_WIN)
#  if !defined(HAVE_SEH_EXCEPTIONS) || !HAVE_SEH_EXCEPTIONS
#    error Compiler support for SEH is required to build zucchini on Windows.
#  endif

static constexpr DWORD kMsvcCppExceptionCode = 0xE06D7363;

// SEH filter for exceptions raised within zucchini code. Without this,
// recoverable exceptions would crash the updater before it can write
// update.status, causing SERVICE_STILL_APPLYING_ON_FAILURE errors.
// We wrap the entire body of every entry point reachable from updater.cpp,
// making sure that every possible running zucchini code is covered.
//
// Every entry point into zucchini thus returns a status code. In addition to
// the various status codes a function may already return, running into a C++
// std::bad_alloc exception returns kStatusOutOfMemory, while running into an
// intentional hard-crash such as a CHECK failure returns kStatusFatal.
//
// We only catch exceptions where the process state is known to be sound:
// - EXCEPTION_BREAKPOINT/EXCEPTION_ILLEGAL_INSTRUCTION (deliberate crash from
//   Chromium CHECK via ImmediateCrash, data validation failure)
// - 0xE06D7363 (MSVC C++ exception: std::bad_alloc from non-fallible
//   allocations in zucchini's disassembler. Neither zucchini nor its base shim
//   contain any explicit throw, so bad_alloc is the only possible C++ exception
//   observed here. On Windows, operator new allocation failure still surfaces
//   through SEH with this exception code.)
//
// Exceptions indicating corrupt process state (EXCEPTION_ACCESS_VIOLATION,
// EXCEPTION_STACK_OVERFLOW, etc.) are left unhandled so the process crashes
// as expected.
static int FilterRecoverableException(EXCEPTION_RECORD* aExceptionRecord,
                                      DWORD& aOutExceptionCode) {
  aOutExceptionCode = aExceptionRecord->ExceptionCode;

  if (aOutExceptionCode == EXCEPTION_BREAKPOINT ||
      aOutExceptionCode == EXCEPTION_ILLEGAL_INSTRUCTION ||
      aOutExceptionCode ==
          kMsvcCppExceptionCode /* MSVC C++ exception (std::bad_alloc) */) {
    return EXCEPTION_EXECUTE_HANDLER;
  }

  return EXCEPTION_CONTINUE_SEARCH;
}

#  define BEGIN_ENTRY_POINT()           \
    DWORD mozZucchiniExceptionCode = 0; \
    __try {
#  define END_ENTRY_POINT()                                                    \
    }                                                                          \
    __except (                                                                 \
        FilterRecoverableException(GetExceptionInformation()->ExceptionRecord, \
                                   mozZucchiniExceptionCode)) {                \
      if (mozZucchiniExceptionCode == kMsvcCppExceptionCode) {                 \
        LOG(ERROR) << "std::bad_alloc caught in zucchini.";                    \
        return status::kStatusOutOfMemory;                                     \
      }                                                                        \
      LOG(ERROR) << "hard crash caught in zucchini; this is a bug.";           \
      return status::kStatusFatal;                                             \
    }

// Narrow handler that stays around the code touching the mapped file ranges,
// where EXCEPTION_IN_PAGE_ERROR can be raised. Usable only within member
// functions, as it relies on mImpl. This reflects the exception catching
// present in upstream zucchini::ApplyCommon (zucchini_integration.cc).
#  define BEGIN_PAGE_ERROR_TRY_EXCEPT() __try {
#  define END_PAGE_ERROR_TRY_EXCEPT()                                      \
    }                                                                      \
    __except (mImpl->mExceptionFilterHelper.FilterPageError(               \
        GetExceptionInformation()->ExceptionRecord)) {                     \
      LOG(ERROR) << "EXCEPTION_IN_PAGE_ERROR while "                       \
                 << (mImpl->mExceptionFilterHelper.is_write()              \
                         ? "writing to"                                    \
                         : "reading from")                                 \
                 << " mapped files; NTSTATUS = "                           \
                 << mImpl->mExceptionFilterHelper.nt_status();             \
      return mImpl->mExceptionFilterHelper.nt_status() == STATUS_DISK_FULL \
                 ? status::kStatusDiskFull                                 \
                 : status::kStatusIoError;                                 \
    }
#else
#  define BEGIN_ENTRY_POINT()
#  define END_ENTRY_POINT()
#  define BEGIN_PAGE_ERROR_TRY_EXCEPT()
#  define END_PAGE_ERROR_TRY_EXCEPT()
#endif  // BUILDFLAG(IS_WIN)

class MappedPatchImpl {
 public:
  MappedPatchImpl() = default;
  ~MappedPatchImpl() = default;
  std::optional<MappedFileReader> mFileReader;
  EnsemblePatchReader mPatchReader;
#if BUILDFLAG(IS_WIN)
  ExceptionFilterHelper mExceptionFilterHelper;
#endif  // BUILDFLAG(IS_WIN)
};

status::Code MappedPatch::Initialize() {
  BEGIN_ENTRY_POINT()
  mImpl = new MappedPatchImpl();
  return status::kStatusSuccess;
  END_ENTRY_POINT()
}

status::Code MappedPatch::Finalize() {
  BEGIN_ENTRY_POINT()
  auto* impl = mImpl;
  mImpl = nullptr;
  delete impl;
  return status::kStatusSuccess;
  END_ENTRY_POINT()
}

// This corresponds to the first half of zucchini::ApplyCommon.
status::Code MappedPatch::LoadImpl(FILE* aPatchFile, uint32_t* aSourceSize,
                                   uint32_t* aDestinationSize,
                                   uint32_t* aSourceCrc32) {
  base::File patchFile = base::FILEToFile(aPatchFile);
  if (!patchFile.IsValid()) {
    LOG(ERROR) << "Invalid patch file.";
    return status::kStatusFileReadError;
  }
  mImpl->mFileReader.emplace(std::move(patchFile));
  auto& fileReader = *mImpl->mFileReader;
  if (fileReader.HasError()) {
    LOG(ERROR) << "Error with patch file: " << fileReader.error();
    if (fileReader.error_is_oom()) {
      return status::kStatusOutOfMemory;
    }
    return status::kStatusFileReadError;
  }
#if BUILDFLAG(IS_WIN)
  mImpl->mExceptionFilterHelper.AddRange(
      {fileReader.data(), fileReader.length()});
#endif
  BEGIN_PAGE_ERROR_TRY_EXCEPT()
#ifdef ENABLE_TESTS
  ScopedDestructorMarker destructorTester;
  MaybeTriggerTestBadAlloc();
  MaybeTriggerTestCheckFailure();
#endif  // ENABLE_TESTS

  BufferSource source(fileReader.region());
  auto& patchReader = mImpl->mPatchReader;
  if (!patchReader.Initialize(&source)) {
    LOG(ERROR) << "Error reading patch header.";
    return status::kStatusPatchReadError;
  }
  auto& header = patchReader.header();
  *aSourceSize = header.old_size;
  *aDestinationSize = header.new_size;
  *aSourceCrc32 = header.old_crc;
  return status::kStatusSuccess;
  END_PAGE_ERROR_TRY_EXCEPT()
}

status::Code MappedPatch::Load(FILE* aPatchFile, uint32_t* aSourceSize,
                               uint32_t* aDestinationSize,
                               uint32_t* aSourceCrc32) {
  if (!mImpl) {
    return mInitStatus;
  }
  BEGIN_ENTRY_POINT()
  return LoadImpl(aPatchFile, aSourceSize, aDestinationSize, aSourceCrc32);
  END_ENTRY_POINT()
}

// This is zucchini::ApplyBuffer, except that we *assume* that aCheckedOldImage
// has the correct size and crc32 instead of checking it.
static status::Code ApplyBufferUnsafe(ConstBufferView aCheckedOldImage,
                                      const EnsemblePatchReader& aPatchReader,
                                      MutableBufferView aNewImage) {
  for (const auto& elementPatch : aPatchReader.elements()) {
    ElementMatch match = elementPatch.element_match();
    if (!ApplyElement(match.exe_type(),
                      aCheckedOldImage[match.old_element.region()],
                      elementPatch, aNewImage[match.new_element.region()]))
      return status::kStatusFatal;
  }

  if (!aPatchReader.CheckNewFile(ConstBufferView(aNewImage))) {
    LOG(ERROR) << "Invalid aNewImage.";
    return status::kStatusInvalidNewImage;
  }

  return status::kStatusSuccess;
}

// This corresponds to the second half of zucchini::ApplyCommon.
status::Code MappedPatch::ApplyUnsafeImpl(const uint8_t* aCheckedOldImage,
                                          size_t aCheckedOldImageSize,
                                          FILE* aNewFile) {
  ConstBufferView oldImageView(aCheckedOldImage, aCheckedOldImageSize);

  base::File newFile = base::FILEToFile(aNewFile);
  if (!newFile.IsValid()) {
    LOG(ERROR) << "Invalid new file.";
    return status::kStatusFileWriteError;
  }

  BEGIN_PAGE_ERROR_TRY_EXCEPT()
  PatchHeader header = mImpl->mPatchReader.header();
  base::FilePath name;
  name = name.AppendASCII("old_name");
  MappedFileWriter mappedNew(name, std::move(newFile), header.new_size,
                             /*keep*/ true);
  if (mappedNew.HasError()) {
    LOG(ERROR) << "Error with new file: " << mappedNew.error();
    if (mappedNew.error_is_oom()) {
      return status::kStatusOutOfMemory;
    }
    return status::kStatusFileWriteError;
  }

#if BUILDFLAG(IS_WIN)
  mImpl->mExceptionFilterHelper.AddRange(
      {mappedNew.data(), mappedNew.length()});
#endif

  status::Code result =
      ApplyBufferUnsafe(oldImageView, mImpl->mPatchReader, mappedNew.region());
  if (result != status::kStatusSuccess) {
    LOG(ERROR) << "Fatal error encountered while applying patch.";
    return result;
  }

  if (!mappedNew.Flush()) {
    LOG(ERROR) << "Error flushing changes to disk: " << mappedNew.error();
    return status::kStatusFileWriteError;
  }

  return status::kStatusSuccess;
  END_PAGE_ERROR_TRY_EXCEPT()
}

status::Code MappedPatch::ApplyUnsafe(const uint8_t* aCheckedOldImage,
                                      size_t aCheckedOldImageSize,
                                      FILE* aNewFile) {
  if (!mImpl) {
    return mInitStatus;
  }
  BEGIN_ENTRY_POINT()
  return ApplyUnsafeImpl(aCheckedOldImage, aCheckedOldImageSize, aNewFile);
  END_ENTRY_POINT()
}

}  // namespace zucchini::mozilla
