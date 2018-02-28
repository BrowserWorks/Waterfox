/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#include <signal.h>
#include <stdio.h>
#include <unistd.h>
#include "mozilla/CodeCoverageHandler.h"
#include "mozilla/ClearOnShutdown.h"
#include "nsAppRunner.h"

using namespace mozilla;
using namespace mozilla::ipc;

// The __gcov_dump function writes the coverage counters to gcda files.
// The __gcov_reset function resets the coverage counters to zero.
// They are defined at https://github.com/gcc-mirror/gcc/blob/aad93da1a579b9ae23ede6b9cf8523360f0a08b4/libgcc/libgcov-interface.c
// __gcov_flush is protected by a mutex, __gcov_dump and __gcov_reset aren't.
// So we are using a CrossProcessMutex to protect them.

extern "C" void __gcov_dump();
extern "C" void __gcov_reset();

StaticAutoPtr<CodeCoverageHandler> CodeCoverageHandler::instance;

void CodeCoverageHandler::DumpCounters(int)
{
  CrossProcessMutexAutoLock lock(*CodeCoverageHandler::Get()->GetMutex());

  printf_stderr("[CodeCoverage] Requested dump.\n");
  __gcov_dump();
  printf_stderr("[CodeCoverage] Dump completed.\n");
}

void CodeCoverageHandler::ResetCounters(int)
{
  CrossProcessMutexAutoLock lock(*CodeCoverageHandler::Get()->GetMutex());

  printf_stderr("[CodeCoverage] Requested reset.\n");
  __gcov_reset();
  printf_stderr("[CodeCoverage] Reset completed.\n");
}

void CodeCoverageHandler::SetSignalHandlers()
{
  printf_stderr("[CodeCoverage] Setting handlers for process %d.\n", getpid());

  struct sigaction dump_sa;
  dump_sa.sa_handler = CodeCoverageHandler::DumpCounters;
  dump_sa.sa_flags = SA_RESTART;
  sigemptyset(&dump_sa.sa_mask);
  MOZ_ASSERT(sigaction(SIGUSR1, &dump_sa, nullptr) == 0);

  struct sigaction reset_sa;
  reset_sa.sa_handler = CodeCoverageHandler::ResetCounters;
  reset_sa.sa_flags = SA_RESTART;
  sigemptyset(&reset_sa.sa_mask);
  MOZ_ASSERT(sigaction(SIGUSR2, &reset_sa, nullptr) == 0);
}

CodeCoverageHandler::CodeCoverageHandler()
  : mGcovLock("GcovLock")
{
  SetSignalHandlers();
}

CodeCoverageHandler::CodeCoverageHandler(const CrossProcessMutexHandle& aHandle)
  : mGcovLock(aHandle)
{
  SetSignalHandlers();
}

void CodeCoverageHandler::Init()
{
  MOZ_ASSERT(!instance);
  MOZ_ASSERT(XRE_IsParentProcess());
  instance = new CodeCoverageHandler();
  ClearOnShutdown(&instance);
}

void CodeCoverageHandler::Init(const CrossProcessMutexHandle& aHandle)
{
  MOZ_ASSERT(!instance);
  MOZ_ASSERT(!XRE_IsParentProcess());
  instance = new CodeCoverageHandler(aHandle);
  ClearOnShutdown(&instance);
}

CodeCoverageHandler* CodeCoverageHandler::Get()
{
  MOZ_ASSERT(instance);
  return instance;
}

CrossProcessMutex* CodeCoverageHandler::GetMutex()
{
  return &mGcovLock;
}

CrossProcessMutexHandle CodeCoverageHandler::GetMutexHandle(int aProcId)
{
  return mGcovLock.ShareToProcess(aProcId);
}
