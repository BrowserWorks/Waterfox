// Copyright (c) 2011 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include "base/at_exit.h"

#include <stddef.h>
#include <ostream>
#include <utility>

#include "base/bind.h"
#include "base/callback.h"
#include "base/logging.h"

namespace base {

// Keep a stack of registered AtExitManagers.  We always operate on the most
// recent, and we should never have more than one outside of testing (for a
// statically linked version of this library).  Testing may use the shadow
// version of the constructor, and if we are building a dynamic library we may
// end up with multiple AtExitManagers on the same process.  We don't protect
// this for thread-safe access, since it will only be modified in testing.
static AtExitManager* g_top_manager = NULL;

AtExitManager::AtExitManager()
    : processing_callbacks_(false), next_manager_(g_top_manager) {
// If multiple modules instantiate AtExitManagers they'll end up living in this
// module... they have to coexist.
#if !defined(COMPONENT_BUILD)
  DCHECK(!g_top_manager);
#endif
  g_top_manager = this;
}

AtExitManager::~AtExitManager() {
  if (!g_top_manager) {
    NOTREACHED() << "Tried to ~AtExitManager without an AtExitManager";
    return;
  }
  DCHECK_EQ(this, g_top_manager);

  ProcessCallbacksNow();
  g_top_manager = next_manager_;
}

// static
void AtExitManager::RegisterCallback(AtExitCallbackType func, void* param) {
  DCHECK(func);
  RegisterTask(base::Bind(func, param));
}

// static
void AtExitManager::RegisterTask(base::Closure task) {
  if (!g_top_manager) {
    NOTREACHED() << "Tried to RegisterCallback without an AtExitManager";
    return;
  }

  AutoLock lock(g_top_manager->lock_);
  DCHECK(!g_top_manager->processing_callbacks_);
  g_top_manager->stack_.push(std::move(task));
}

// static
void AtExitManager::ProcessCallbacksNow() {
  if (!g_top_manager) {
    NOTREACHED() << "Tried to ProcessCallbacksNow without an AtExitManager";
    return;
  }

  // Callbacks may try to add new callbacks, so run them without holding
  // |lock_|. This is an error and caught by the DCHECK in RegisterTask(), but
  // handle it gracefully in release builds so we don't deadlock.
  std::stack<base::Closure> tasks;
  {
    AutoLock lock(g_top_manager->lock_);
    tasks.swap(g_top_manager->stack_);
    g_top_manager->processing_callbacks_ = true;
  }

  while (!tasks.empty()) {
    base::Closure task = tasks.top();
    task.Run();
    tasks.pop();
  }

  // Expect that all callbacks have been run.
  DCHECK(g_top_manager->stack_.empty());
}

AtExitManager::AtExitManager(bool shadow)
    : processing_callbacks_(false), next_manager_(g_top_manager) {
  DCHECK(shadow || !g_top_manager);
  g_top_manager = this;
}

}  // namespace base
