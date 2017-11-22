/*
 *  Copyright (c) 2012 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include "webrtc/modules/utility/source/process_thread_impl.h"

#include "webrtc/base/checks.h"
#include "webrtc/base/task_queue.h"
#include "webrtc/base/timeutils.h"
#include "webrtc/modules/include/module.h"
#include "webrtc/system_wrappers/include/logging.h"

namespace webrtc {
namespace {

// We use this constant internally to signal that a module has requested
// a callback right away.  When this is set, no call to TimeUntilNextProcess
// should be made, but Process() should be called directly.
const int64_t kCallProcessImmediately = -1;

int64_t GetNextCallbackTime(Module* module, int64_t time_now) {
  int64_t interval = module->TimeUntilNextProcess();
  if (interval < 0) {
    // Falling behind, we should call the callback now.
    return time_now;
  }
  return time_now + interval;
}
}

ProcessThread::~ProcessThread() {}

// static
std::unique_ptr<ProcessThread> ProcessThread::Create(
    const char* thread_name) {
  return std::unique_ptr<ProcessThread>(new ProcessThreadImpl(thread_name));
}

ProcessThreadImpl::ProcessThreadImpl(const char* thread_name)
    : wake_up_(EventWrapper::Create()),
      stop_(false),
      thread_name_(thread_name) {}

ProcessThreadImpl::~ProcessThreadImpl() {
  RTC_DCHECK(thread_checker_.CalledOnValidThread());
  RTC_DCHECK(!thread_.get());
  RTC_DCHECK(!stop_);

  while (!queue_.empty()) {
    delete queue_.front();
    queue_.pop();
  }
}

void ProcessThreadImpl::Start() {
  RTC_DCHECK(thread_checker_.CalledOnValidThread());
  RTC_DCHECK(!thread_.get());
  if (thread_.get())
    return;

  RTC_DCHECK(!stop_);

  {
    // TODO(tommi): Since DeRegisterModule is currently being called from
    // different threads in some cases (ChannelOwner), we need to lock access to
    // the modules_ collection even on the controller thread.
    // Once we've cleaned up those places, we can remove this lock.
    rtc::CritScope lock(&lock_);
    for (ModuleCallback& m : modules_)
      m.module->ProcessThreadAttached(this);
  }

  thread_.reset(
      new rtc::PlatformThread(&ProcessThreadImpl::Run, this, thread_name_));
  thread_->Start();
}

void ProcessThreadImpl::Stop() {
  RTC_DCHECK(thread_checker_.CalledOnValidThread());
  if(!thread_.get())
    return;

  {
    rtc::CritScope lock(&lock_);
    stop_ = true;
  }

  wake_up_->Set();

  thread_->Stop();
  stop_ = false;

  // TODO(tommi): Since DeRegisterModule is currently being called from
  // different threads in some cases (ChannelOwner), we need to lock access to
  // the modules_ collection even on the controller thread.
  // Since DeRegisterModule also checks thread_, we also need to hold the
  // lock for the .reset() operation.
  // Once we've cleaned up those places, we can remove this lock.
  rtc::CritScope lock(&lock_);
  thread_.reset();
  for (ModuleCallback& m : modules_)
    m.module->ProcessThreadAttached(nullptr);
}

void ProcessThreadImpl::WakeUp(Module* module) {
  // Allowed to be called on any thread.
  {
    rtc::CritScope lock(&lock_);
    for (ModuleCallback& m : modules_) {
      if (m.module == module)
        m.next_callback = kCallProcessImmediately;
    }
  }
  wake_up_->Set();
}

void ProcessThreadImpl::PostTask(std::unique_ptr<rtc::QueuedTask> task) {
  // Allowed to be called on any thread.
  {
    rtc::CritScope lock(&lock_);
    queue_.push(task.release());
  }
  wake_up_->Set();
}

void ProcessThreadImpl::RegisterModule(Module* module) {
  // RTC_DCHECK(thread_checker_.CalledOnValidThread());  Not really needed
  RTC_DCHECK(module);

#if RTC_DCHECK_IS_ON
  {
    // Catch programmer error.
    rtc::CritScope lock(&lock_);
    for (const ModuleCallback& mc : modules_)
      RTC_DCHECK(mc.module != module);
  }
#endif

  // Now that we know the module isn't in the list, we'll call out to notify
  // the module that it's attached to the worker thread.  We don't hold
  // the lock while we make this call.
  if (thread_.get())
    module->ProcessThreadAttached(this);

  {
    rtc::CritScope lock(&lock_);
    modules_.push_back(ModuleCallback(module));
  }

  // Wake the thread calling ProcessThreadImpl::Process() to update the
  // waiting time. The waiting time for the just registered module may be
  // shorter than all other registered modules.
  wake_up_->Set();
}

void ProcessThreadImpl::DeRegisterModule(Module* module) {
  // Allowed to be called on any thread.
  // TODO(tommi): Disallow this ^^^
  RTC_DCHECK(module);

  {
    rtc::CritScope lock(&lock_);
    modules_.remove_if([&module](const ModuleCallback& m) {
        return m.module == module;
      });

    // TODO(tommi): we currently need to hold the lock while calling out to
    // ProcessThreadAttached.  This is to make sure that the thread hasn't been
    // destroyed while we attach the module.  Once we can make sure
    // DeRegisterModule isn't being called on arbitrary threads, we can move the
    // |if (thread_.get())| check and ProcessThreadAttached() call outside the
    // lock scope.

    // Notify the module that it's been detached.
    if (thread_.get())
      module->ProcessThreadAttached(nullptr);
  }
}

// static
bool ProcessThreadImpl::Run(void* obj) {
  return static_cast<ProcessThreadImpl*>(obj)->Process();
}

bool ProcessThreadImpl::Process() {
  int64_t now = rtc::TimeMillis();
  int64_t next_checkpoint = now + (1000 * 60);

  {
    rtc::CritScope lock(&lock_);
    if (stop_)
      return false;
    for (ModuleCallback& m : modules_) {
      // TODO(tommi): Would be good to measure the time TimeUntilNextProcess
      // takes and dcheck if it takes too long (e.g. >=10ms).  Ideally this
      // operation should not require taking a lock, so querying all modules
      // should run in a matter of nanoseconds.
      if (m.next_callback == 0)
        m.next_callback = GetNextCallbackTime(m.module, now);

      if (m.next_callback <= now ||
          m.next_callback == kCallProcessImmediately) {
        m.module->Process();
        // Use a new 'now' reference to calculate when the next callback
        // should occur.  We'll continue to use 'now' above for the baseline
        // of calculating how long we should wait, to reduce variance.
        int64_t new_now = rtc::TimeMillis();
        m.next_callback = GetNextCallbackTime(m.module, new_now);
      }

      if (m.next_callback < next_checkpoint)
        next_checkpoint = m.next_callback;
    }

    while (!queue_.empty()) {
      rtc::QueuedTask* task = queue_.front();
      queue_.pop();
      lock_.Leave();
      task->Run();
      delete task;
      lock_.Enter();
    }
  }

  int64_t time_to_wait = next_checkpoint - rtc::TimeMillis();
  if (time_to_wait > 0)
    wake_up_->Wait(static_cast<unsigned long>(time_to_wait));

  return true;
}
}  // namespace webrtc
