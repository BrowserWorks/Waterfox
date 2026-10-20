/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

#ifndef mozilla_WinDllServices_h
#define mozilla_WinDllServices_h

#include "mozilla/glue/WindowsDllServices.h"
#include "mozilla/Maybe.h"
#include "mozilla/MozPromise.h"
#include "mozilla/RefPtr.h"
#include "nsTArray.h"

namespace mozilla {

class UntrustedModulesData;
class UntrustedModulesProcessor;

using UntrustedModulesPromise =
    MozPromise<Maybe<UntrustedModulesData>, nsresult, true>;

namespace ipc {
class FileDescriptor;
}  // namespace ipc

class ModulesMapResult;

using ModulesTrustPromise = MozPromise<ModulesMapResult, nsresult, true>;

class DllServices final : public glue::DllServices {
 public:
  static DllServices* Get();

  virtual void DisableFull() override;

  static const char* kTopicDllLoadedMainThread;
  static const char* kTopicDllLoadedNonMainThread;

  void StartUntrustedModulesProcessor(bool aIsReadyForBackgroundProcessing);
  bool IsReadyForBackgroundProcessing() const;

  RefPtr<UntrustedModulesPromise> GetUntrustedModulesData();

  RefPtr<ModulesTrustPromise> GetModulesTrust(
      nsTArray<ipc::FileDescriptor>&& aModIdents, bool aRunAtNormalPriority);

 private:
  DllServices() = default;
  ~DllServices();

  void NotifyDllLoad(glue::EnhancedModuleLoadInfo&& aModLoadInfo) override;
  void NotifyModuleLoadBacklog(ModuleLoadInfoVec&& aEvents) override;

  RefPtr<UntrustedModulesProcessor> mUntrustedModulesProcessor;
};

}  // namespace mozilla

#endif  // mozilla_WinDllServices_h
