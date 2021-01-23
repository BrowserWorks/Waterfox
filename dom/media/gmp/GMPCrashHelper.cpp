/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "GMPCrashHelper.h"
#include "runnable_utils.h"
#include "nsThreadUtils.h"
#include "mozilla/SchedulerGroup.h"

namespace mozilla {

void GMPCrashHelper::Destroy() {
  if (NS_IsMainThread()) {
    delete this;
  } else {
    // Don't addref, as then we'd end up releasing after the delete runs!
    SchedulerGroup::Dispatch(
        TaskCategory::Other,
        NewNonOwningRunnableMethod("GMPCrashHelper::Destroy", this,
                                   &GMPCrashHelper::Destroy));
  }
}

}  // namespace mozilla
