/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: set ts=8 sts=2 et sw=2 tw=80:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "gc/GCParallelTask.h"

#include "mozilla/MathAlgorithms.h"

#include "gc/ParallelWork.h"
#include "vm/HelperThreads.h"
#include "vm/Runtime.h"

using namespace js;
using namespace js::gc;

using mozilla::TimeDuration;
using mozilla::TimeStamp;

js::GCParallelTask::~GCParallelTask() {
  // Only most-derived classes' destructors may do the join: base class
  // destructors run after those for derived classes' members, so a join in a
  // base class can't ensure that the task is done using the members. All we
  // can do now is check that someone has previously stopped the task.
  assertIdle();
}

void js::GCParallelTask::startWithLockHeld(AutoLockHelperThreadState& lock) {
  MOZ_ASSERT(CanUseExtraThreads());
  MOZ_ASSERT(HelperThreadState().threads);
  assertIdle();

  HelperThreadState().gcParallelWorklist(lock).insertBack(this);
  setDispatched(lock);

  HelperThreadState().notifyOne(GlobalHelperThreadState::PRODUCER, lock);
}

void js::GCParallelTask::start() {
  AutoLockHelperThreadState lock;
  startWithLockHeld(lock);
}

void js::GCParallelTask::startOrRunIfIdle(AutoLockHelperThreadState& lock) {
  if (wasStarted(lock)) {
    return;
  }

  // Join the previous invocation of the task. This will return immediately
  // if the thread has never been started.
  joinWithLockHeld(lock);

  if (!CanUseExtraThreads()) {
    AutoUnlockHelperThreadState unlock(lock);
    runFromMainThread();
    return;
  }

  startWithLockHeld(lock);
}

void js::GCParallelTask::join() {
  AutoLockHelperThreadState lock;
  joinWithLockHeld(lock);
}

void js::GCParallelTask::joinWithLockHeld(AutoLockHelperThreadState& lock) {
  // Task has not been started; there's nothing to do.
  if (isIdle(lock)) {
    return;
  }

  // If the task was dispatched but has not yet started then cancel the task and
  // run it from the main thread. This stops us from blocking here when the
  // helper threads are busy with other tasks.
  if (isDispatched(lock)) {
    cancelDispatchedTask(lock);
    AutoUnlockHelperThreadState unlock(lock);
    runFromMainThread();
    return;
  }

  joinRunningOrFinishedTask(lock);
}

void js::GCParallelTask::joinRunningOrFinishedTask(
    AutoLockHelperThreadState& lock) {
  MOZ_ASSERT(isRunning(lock) || isFinishing(lock) || isFinished(lock));

  // Wait for the task to run to completion.
  while (!isFinished(lock)) {
    HelperThreadState().wait(lock, GlobalHelperThreadState::CONSUMER);
  }

  setIdle(lock);
  cancel_ = false;
}

void js::GCParallelTask::cancelDispatchedTask(AutoLockHelperThreadState& lock) {
  MOZ_ASSERT(isDispatched(lock));
  MOZ_ASSERT(isInList());
  remove();
  setIdle(lock);
}

static inline TimeDuration TimeSince(TimeStamp prev) {
  TimeStamp now = ReallyNow();
  // Sadly this happens sometimes.
  MOZ_ASSERT(now >= prev);
  if (now < prev) {
    now = prev;
  }
  return now - prev;
}

void js::GCParallelTask::runFromMainThread() {
  assertIdle();
  MOZ_ASSERT(js::CurrentThreadCanAccessRuntime(gc->rt));
  runTask();
}

void js::GCParallelTask::runFromHelperThread(AutoLockHelperThreadState& lock) {
  setRunning(lock);

  {
    AutoUnlockHelperThreadState parallelSection(lock);
    AutoSetHelperThreadContext usesContext;
    AutoSetContextRuntime ascr(gc->rt);
    gc::AutoSetThreadIsPerformingGC performingGC;
    runTask();
  }

  setFinished(lock);
  HelperThreadState().notifyAll(GlobalHelperThreadState::CONSUMER, lock);
}

void GCParallelTask::runTask() {
  // Run the task from either the main thread or a helper thread.

  // The hazard analysis can't tell what the call to func_ will do but it's not
  // allowed to GC.
  JS::AutoSuppressGCAnalysis nogc;

  TimeStamp timeStart = ReallyNow();
  run();
  duration_ = TimeSince(timeStart);
}

bool js::GCParallelTask::isIdle() const {
  AutoLockHelperThreadState lock;
  return isIdle(lock);
}

bool js::GCParallelTask::wasStarted() const {
  AutoLockHelperThreadState lock;
  return wasStarted(lock);
}

/* static */
size_t js::gc::ParallelWorkerCount() {
  if (!CanUseExtraThreads()) {
    return 1;  // GCRuntime::startTask will run the work on the main thread.
  }

  size_t targetTaskCount = HelperThreadState().cpuCount / 2;
  return mozilla::Clamp(targetTaskCount, size_t(1), MaxParallelWorkers);
}
