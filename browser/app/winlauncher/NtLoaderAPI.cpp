/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

#include "mozilla/Attributes.h"
#include "mozilla/LoaderAPIInterfaces.h"

#include "freestanding/CheckForCaller.h"
#include "freestanding/LoaderPrivateAPI.h"

namespace mozilla {

// No-op LoaderObserver, used by buggy installs where mozglue.dll is an
// unexpected version, since mozglue's structures may not be binary compatible.
class MOZ_ONLY_USED_TO_AVOID_STATIC_CONSTRUCTORS NullLoaderObserver final
    : public nt::LoaderObserver {
 public:
  constexpr NullLoaderObserver() = default;

  void OnBeginDllLoad(void** aContext,
                      PCUNICODE_STRING aRequestedDllName) final {}
  bool SubstituteForLSP(PCUNICODE_STRING aLSPLeafName,
                        PHANDLE aOutHandle) final {
    return false;
  }
  void OnEndDllLoad(void* aContext, NTSTATUS aNtStatus,
                    ModuleLoadInfo&& aModuleLoadInfo) final {}
  void Forward(nt::LoaderObserver* aNext) final {}
  void OnForward(ModuleLoadInfoVec&& aInfo) final {}
};

static NullLoaderObserver gNullLoaderObserver;

extern "C" MOZ_EXPORT uint32_t ModuleLoadInfoLayoutVersion() {
  return ModuleLoadInfo::kVersion;
}

extern "C" MOZ_EXPORT nt::LoaderAPI* GetNtLoaderAPI(
    nt::LoaderObserver* aNewObserver) {
  // Make sure the caller is inside mozglue.dll - we don't want to allow
  // external access to this function, as it contains details about
  // the SharedSection which is used to sandbox future child processes.
  const bool isCallerMozglue =
      CheckForAddress(RETURN_ADDRESS(), L"mozglue.dll");
  MOZ_ASSERT(isCallerMozglue);
  if (!isCallerMozglue) {
    return nullptr;
  }

  freestanding::EnsureInitialized();
  freestanding::LoaderPrivateAPI& api = freestanding::gLoaderPrivateAPI;
  if (ModuleLoadInfo::IsLayoutCompatible(::GetModuleHandleW(L"mozglue.dll"))) {
    api.SetObserver(aNewObserver);
  } else {
    api.SetObserver(&gNullLoaderObserver);
  }

  return &api;
}

}  // namespace mozilla
