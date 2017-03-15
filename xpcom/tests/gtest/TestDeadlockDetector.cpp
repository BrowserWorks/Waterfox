/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: sw=4 ts=4 et :
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/ArrayUtils.h"

#include "prthread.h"

#include "nsTArray.h"
#include "nsMemory.h"

#include "mozilla/CondVar.h"
#include "mozilla/ReentrantMonitor.h"
#include "mozilla/Mutex.h"

#ifdef MOZ_CRASHREPORTER
#include "nsCOMPtr.h"
#include "nsICrashReporter.h"
#include "nsServiceManagerUtils.h"
#endif

#include "gtest/gtest.h"

using namespace mozilla;

static PRThread*
spawn(void (*run)(void*), void* arg)
{
    return PR_CreateThread(PR_SYSTEM_THREAD,
                           run,
                           arg,
                           PR_PRIORITY_NORMAL,
                           PR_GLOBAL_THREAD,
                           PR_JOINABLE_THREAD,
                           0);
}

// This global variable is defined in toolkit/xre/nsSigHandlers.cpp.
extern unsigned int _gdb_sleep_duration;

/**
 * Simple test fixture that makes sure the gdb sleep setup in the
 * ah crap handler is bypassed during the death tests.
 */
class DeadlockDetectorTest : public ::testing::Test
{
protected:
  void SetUp() final {
    mOldSleepDuration = _gdb_sleep_duration;
    _gdb_sleep_duration = 0;
  }

  void TearDown() final {
    _gdb_sleep_duration = mOldSleepDuration;
  }

private:
  unsigned int mOldSleepDuration;
};

void DisableCrashReporter()
{
#ifdef MOZ_CRASHREPORTER
    nsCOMPtr<nsICrashReporter> crashreporter =
        do_GetService("@mozilla.org/toolkit/crash-reporter;1");
    if (crashreporter) {
      crashreporter->SetEnabled(false);
    }
#endif
}

//-----------------------------------------------------------------------------
// Single-threaded sanity tests

// Stupidest possible deadlock.
int
Sanity_Child()
{
    DisableCrashReporter();

    mozilla::Mutex m1("dd.sanity.m1");
    m1.Lock();
    m1.Lock();
    return 0;                  // not reached
}

TEST_F(DeadlockDetectorTest, SanityDeathTest)
{
    const char* const regex =
        "###!!! ERROR: Potential deadlock detected.*"
        "=== Cyclical dependency starts at.*--- Mutex : dd.sanity.m1.*"
        "=== Cycle completed at.*--- Mutex : dd.sanity.m1.*"
        "###!!! Deadlock may happen NOW!.*" // better catch these easy cases...
        "###!!! ASSERTION: Potential deadlock detected.*";

    ASSERT_DEATH_IF_SUPPORTED(Sanity_Child(), regex);
}

// Slightly less stupid deadlock.
int
Sanity2_Child()
{
    DisableCrashReporter();

    mozilla::Mutex m1("dd.sanity2.m1");
    mozilla::Mutex m2("dd.sanity2.m2");
    m1.Lock();
    m2.Lock();
    m1.Lock();
    return 0;                  // not reached
}

TEST_F(DeadlockDetectorTest, Sanity2DeathTest)
{
    const char* const regex =
        "###!!! ERROR: Potential deadlock detected.*"
        "=== Cyclical dependency starts at.*--- Mutex : dd.sanity2.m1.*"
        "--- Next dependency:.*--- Mutex : dd.sanity2.m2.*"
        "=== Cycle completed at.*--- Mutex : dd.sanity2.m1.*"
        "###!!! Deadlock may happen NOW!.*" // better catch these easy cases...
        "###!!! ASSERTION: Potential deadlock detected.*";

    ASSERT_DEATH_IF_SUPPORTED(Sanity2_Child(), regex);
}

int
Sanity3_Child()
{
    DisableCrashReporter();

    mozilla::Mutex m1("dd.sanity3.m1");
    mozilla::Mutex m2("dd.sanity3.m2");
    mozilla::Mutex m3("dd.sanity3.m3");
    mozilla::Mutex m4("dd.sanity3.m4");

    m1.Lock();
    m2.Lock();
    m3.Lock();
    m4.Lock();
    m4.Unlock();
    m3.Unlock();
    m2.Unlock();
    m1.Unlock();

    m4.Lock();
    m1.Lock();
    return 0;
}

TEST_F(DeadlockDetectorTest, Sanity3DeathTest)
{
    const char* const regex =
        "###!!! ERROR: Potential deadlock detected.*"
        "=== Cyclical dependency starts at.*--- Mutex : dd.sanity3.m1.*"
        "--- Next dependency:.*--- Mutex : dd.sanity3.m2.*"
        "--- Next dependency:.*--- Mutex : dd.sanity3.m3.*"
        "--- Next dependency:.*--- Mutex : dd.sanity3.m4.*"
        "=== Cycle completed at.*--- Mutex : dd.sanity3.m1.*"
        "###!!! ASSERTION: Potential deadlock detected.*";

    ASSERT_DEATH_IF_SUPPORTED(Sanity3_Child(), regex);
}

int
Sanity4_Child()
{
    DisableCrashReporter();

    mozilla::ReentrantMonitor m1("dd.sanity4.m1");
    mozilla::Mutex m2("dd.sanity4.m2");
    m1.Enter();
    m2.Lock();
    m1.Enter();
    return 0;
}

TEST_F(DeadlockDetectorTest, Sanity4DeathTest)
{
    const char* const regex =
        "Re-entering ReentrantMonitor after acquiring other resources.*"
        "###!!! ERROR: Potential deadlock detected.*"
        "=== Cyclical dependency starts at.*--- ReentrantMonitor : dd.sanity4.m1.*"
        "--- Next dependency:.*--- Mutex : dd.sanity4.m2.*"
        "=== Cycle completed at.*--- ReentrantMonitor : dd.sanity4.m1.*"
        "###!!! ASSERTION: Potential deadlock detected.*";
    ASSERT_DEATH_IF_SUPPORTED(Sanity4_Child(), regex);
}

//-----------------------------------------------------------------------------
// Multithreaded tests

/**
 * Helper for passing state to threads in the multithread tests.
 */
struct ThreadState
{
  /**
   * Locks to use during the test. This is just a reference and is owned by
   * the main test thread.
   */
  const nsTArray<mozilla::Mutex*>& locks;

  /**
   * Integer argument used to identify each thread.
   */
  int id;
};

static void
TwoThreads_thread(void* arg)
{
    ThreadState* state = static_cast<ThreadState*>(arg);

    mozilla::Mutex* ttM1 = state->locks[0];
    mozilla::Mutex* ttM2 = state->locks[1];

    if (state->id) {
        ttM1->Lock();
        ttM2->Lock();
        ttM2->Unlock();
        ttM1->Unlock();
    }
    else {
        ttM2->Lock();
        ttM1->Lock();
        ttM1->Unlock();
        ttM2->Unlock();
    }
}

int
TwoThreads_Child()
{
    DisableCrashReporter();

    nsTArray<mozilla::Mutex*> locks = {
      new mozilla::Mutex("dd.twothreads.m1"),
      new mozilla::Mutex("dd.twothreads.m2")
    };

    ThreadState state_1 {locks, 0};
    PRThread* t1 = spawn(TwoThreads_thread, &state_1);
    PR_JoinThread(t1);

    ThreadState state_2 {locks, 1};
    PRThread* t2 = spawn(TwoThreads_thread, &state_2);
    PR_JoinThread(t2);

    for (auto& lock : locks) {
      delete lock;
    }

    return 0;
}

TEST_F(DeadlockDetectorTest, TwoThreadsDeathTest)
{
    const char* const regex =
        "###!!! ERROR: Potential deadlock detected.*"
        "=== Cyclical dependency starts at.*--- Mutex : dd.twothreads.m2.*"
        "--- Next dependency:.*--- Mutex : dd.twothreads.m1.*"
        "=== Cycle completed at.*--- Mutex : dd.twothreads.m2.*"
        "###!!! ASSERTION: Potential deadlock detected.*";

    ASSERT_DEATH_IF_SUPPORTED(TwoThreads_Child(), regex);
}

static void
ContentionNoDeadlock_thread(void* arg)
{
    const uint32_t K = 100000;

    ThreadState* state = static_cast<ThreadState*>(arg);
    int32_t starti = static_cast<int32_t>(state->id);
    auto& cndMs = state->locks;

    for (uint32_t k = 0; k < K; ++k) {
        for (int32_t i = starti; i < (int32_t)cndMs.Length(); ++i)
            cndMs[i]->Lock();
        // comment out the next two lines for deadlocking fun!
        for (int32_t i = cndMs.Length() - 1; i >= starti; --i)
            cndMs[i]->Unlock();

        starti = (starti + 1) % 3;
    }
}

int
ContentionNoDeadlock_Child()
{
    const size_t kMutexCount = 4;

    PRThread* threads[3];
    nsTArray<mozilla::Mutex*> locks;
    ThreadState states[] = {
      { locks, 0 },
      { locks, 1 },
      { locks, 2 }
    };

    for (uint32_t i = 0; i < kMutexCount; ++i)
        locks.AppendElement(new mozilla::Mutex("dd.cnd.ms"));

    for (int32_t i = 0; i < (int32_t) ArrayLength(threads); ++i)
        threads[i] = spawn(ContentionNoDeadlock_thread, states + i);

    for (uint32_t i = 0; i < ArrayLength(threads); ++i)
        PR_JoinThread(threads[i]);

    for (uint32_t i = 0; i < locks.Length(); ++i)
        delete locks[i];

    return 0;
}

TEST_F(DeadlockDetectorTest, ContentionNoDeadlock)
{
  // Just check that this test runs to completion.
  ASSERT_EQ(ContentionNoDeadlock_Child(), 0);
}
