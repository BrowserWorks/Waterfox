/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: sw=2 ts=4 et :
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef dom_plugins_PluginProcessChild_h
#define dom_plugins_PluginProcessChild_h 1

#include "mozilla/ipc/ProcessChild.h"
#include "mozilla/plugins/PluginModuleChild.h"

#if defined(XP_WIN)
#  include "mozilla/mscom/ProcessRuntime.h"
#endif

namespace mozilla {
namespace plugins {
//-----------------------------------------------------------------------------

class PluginProcessChild : public mozilla::ipc::ProcessChild {
 protected:
  typedef mozilla::ipc::ProcessChild ProcessChild;

 public:
  explicit PluginProcessChild(ProcessId aParentPid)
      : ProcessChild(aParentPid), mPlugin(true) {}

  virtual ~PluginProcessChild() = default;

  virtual bool Init(int aArgc, char* aArgv[]) override;
  virtual void CleanUp() override;

 protected:
  static PluginProcessChild* current() {
    return static_cast<PluginProcessChild*>(ProcessChild::current());
  }

 private:
#if defined(XP_WIN)
  /* Drag-and-drop depends on the host initializing COM.
   * This object initializes and configures COM. */
  mozilla::mscom::ProcessRuntime mCOMRuntime;
#endif
  PluginModuleChild mPlugin;

  DISALLOW_EVIL_CONSTRUCTORS(PluginProcessChild);
};

}  // namespace plugins
}  // namespace mozilla

#endif  // ifndef dom_plugins_PluginProcessChild_h
