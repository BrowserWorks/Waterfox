/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: sw=2 ts=4 et :
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_plugins_functionbrokerparent_h
#define mozilla_plugins_functionbrokerparent_h

#include "mozilla/plugins/PFunctionBrokerParent.h"
#if defined(XP_WIN) && defined(MOZ_SANDBOX)
#  include "sandboxPermissions.h"
#endif

namespace mozilla {
namespace plugins {

class FunctionBrokerThread;

/**
 * Top-level actor run on the process to which we broker calls from sandboxed
 * plugin processes.
 */
class FunctionBrokerParent : public PFunctionBrokerParent {
 public:
  static FunctionBrokerParent* Create(
      Endpoint<PFunctionBrokerParent>&& aParentEnd);
  static void Destroy(FunctionBrokerParent* aInst);

  void ActorDestroy(ActorDestroyReason aWhy) override;

  mozilla::ipc::IPCResult RecvBrokerFunction(const FunctionHookId& aFunctionId,
                                             const IpdlTuple& aInTuple,
                                             IpdlTuple* aOutTuple) override;

#if defined(XP_WIN) && defined(MOZ_SANDBOX)
  static mozilla::SandboxPermissions* GetSandboxPermissions() {
    return &sSandboxPermissions;
  }
#endif  // defined(XP_WIN) && defined(MOZ_SANDBOX)

 private:
  explicit FunctionBrokerParent(FunctionBrokerThread* aThread,
                                Endpoint<PFunctionBrokerParent>&& aParentEnd);
  ~FunctionBrokerParent();
  void ShutdownOnBrokerThread();
  void Bind(Endpoint<PFunctionBrokerParent>&& aEnd);

  static bool RunBrokeredFunction(base::ProcessId aClientId,
                                  const FunctionHookId& aFunctionId,
                                  const IPC::IpdlTuple& aInTuple,
                                  IPC::IpdlTuple* aOutTuple);

#if defined(XP_WIN) && defined(MOZ_SANDBOX)
  static void RemovePermissionsForProcess(base::ProcessId aClientId);
  static mozilla::SandboxPermissions sSandboxPermissions;
#endif  // defined(XP_WIN) && defined(MOZ_SANDBOX)

  UniquePtr<FunctionBrokerThread> mThread;
  Monitor mMonitor;
  bool mShutdownDone;
};

}  // namespace plugins
}  // namespace mozilla

#endif  // mozilla_plugins_functionbrokerparent_hk
