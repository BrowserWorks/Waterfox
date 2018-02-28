/*
 *  Copyright (c) 2016 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include "webrtc/base/sequenced_task_checker_impl.h"

#if defined(WEBRTC_MAC)
#include <dispatch/dispatch.h>
#endif

#include "webrtc/base/platform_thread.h"
#include "webrtc/base/sequenced_task_checker.h"
#include "webrtc/base/task_queue.h"

namespace rtc {

SequencedTaskCheckerImpl::SequencedTaskCheckerImpl()
    : attached_(true), valid_queue_(TaskQueue::Current()) {}

SequencedTaskCheckerImpl::~SequencedTaskCheckerImpl() {}

bool SequencedTaskCheckerImpl::CalledSequentially() const {
  QueueId current_queue = TaskQueue::Current();
#if defined(WEBRTC_MAC)
  // If we're not running on a TaskQueue, use the system dispatch queue
  // label as an identifier.
  if (current_queue == nullptr) {
#ifdef DISPATCH_CURRENT_QUEUE_LABEL
    // defined in 10.9
    current_queue = dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL);
#else
    // MacOS 10.9 or less; not available >10.9
    dispatch_queue_t currentQueue = dispatch_get_current_queue();
    current_queue = dispatch_queue_get_label(currentQueue);
#endif
  }
#endif
  CritScope scoped_lock(&lock_);
  if (!attached_) {  // true if previously detached.
    valid_queue_ = current_queue;
    attached_ = true;
  }
  if (!valid_queue_)
    return thread_checker_.CalledOnValidThread();
  return valid_queue_ == current_queue;
}

void SequencedTaskCheckerImpl::Detach() {
  CritScope scoped_lock(&lock_);
  attached_ = false;
  valid_queue_ = nullptr;
  thread_checker_.DetachFromThread();
}

namespace internal {

SequencedTaskCheckerScope::SequencedTaskCheckerScope(
    const SequencedTaskChecker* checker) {
  RTC_DCHECK(checker->CalledSequentially());
}

SequencedTaskCheckerScope::~SequencedTaskCheckerScope() {}

}  // namespace internal
}  // namespace rtc
