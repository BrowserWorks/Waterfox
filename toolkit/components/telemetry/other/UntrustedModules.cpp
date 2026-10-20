/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "UntrustedModules.h"

#include "GMPServiceParent.h"
#include "mozilla/dom/ContentParent.h"
#include "mozilla/glean/GleanPings.h"
#include "mozilla/glean/TelemetryMetrics.h"
#include "mozilla/MozPromise.h"
#include "mozilla/net/SocketProcessParent.h"
#include "mozilla/ipc/UtilityProcessParent.h"
#include "mozilla/ipc/UtilityProcessManager.h"
#include "mozilla/RDDChild.h"
#include "mozilla/RDDProcessManager.h"
#include "mozilla/WinDllServices.h"
#include "nsISupportsImpl.h"
#include "nsProxyRelease.h"
#include "nsXULAppAPI.h"
#include "UntrustedModulesDataSerializer.h"

namespace mozilla {
namespace Telemetry {

static const uint32_t kMaxModulesArrayLen = 100;

using UntrustedModulesIpcPromise =
    MozPromise<Maybe<UntrustedModulesData>, ipc::ResponseRejectReason, true>;

using MultiGetUntrustedModulesPromise =
    MozPromise<bool /*aIgnored*/, nsresult, true>;

class MOZ_HEAP_CLASS MultiGetUntrustedModulesData final {
 public:
  /**
   * @param aFlags [in] Combinations of the flags defined under nsITelemetry.
   *               (See "Flags for getUntrustedModuleLoadEvents"
   *                in nsITelemetry.idl)
   */
  explicit MultiGetUntrustedModulesData(uint32_t aFlags)
      : mFlags(aFlags),
        mBackupSvc(UntrustedModulesBackupService::Get()),
        mPromise(new MultiGetUntrustedModulesPromise::Private(__func__)),
        mNumPending(0) {}

  NS_INLINE_DECL_THREADSAFE_REFCOUNTING(MultiGetUntrustedModulesData)

  RefPtr<MultiGetUntrustedModulesPromise> GetUntrustedModuleLoadEvents();
  void Serialize(RefPtr<dom::Promise>&& aPromise);

  /**
   * Submit a "third-party-modules" ping with any already-gotten data.
   */
  nsresult SubmitToGlean();

  MultiGetUntrustedModulesData(const MultiGetUntrustedModulesData&) = delete;
  MultiGetUntrustedModulesData(MultiGetUntrustedModulesData&&) = delete;
  MultiGetUntrustedModulesData& operator=(const MultiGetUntrustedModulesData&) =
      delete;
  MultiGetUntrustedModulesData& operator=(MultiGetUntrustedModulesData&&) =
      delete;

 private:
  ~MultiGetUntrustedModulesData() = default;

  void AddPending(RefPtr<UntrustedModulesPromise>&& aNewPending) {
    MOZ_ASSERT(NS_IsMainThread());

    ++mNumPending;

    RefPtr<MultiGetUntrustedModulesData> self(this);
    aNewPending->Then(
        GetMainThreadSerialEventTarget(), __func__,
        [self](Maybe<UntrustedModulesData>&& aResult) {
          self->OnCompletion(std::move(aResult));
        },
        [self](nsresult aReason) { self->OnCompletion(); });
  }

  void AddPending(RefPtr<UntrustedModulesIpcPromise>&& aNewPending) {
    MOZ_ASSERT(NS_IsMainThread());

    ++mNumPending;

    RefPtr<MultiGetUntrustedModulesData> self(this);
    aNewPending->Then(
        GetMainThreadSerialEventTarget(), __func__,
        [self](Maybe<UntrustedModulesData>&& aResult) {
          self->OnCompletion(std::move(aResult));
        },
        [self](ipc::ResponseRejectReason&& aReason) { self->OnCompletion(); });
  }

  void OnCompletion() {
    MOZ_ASSERT(NS_IsMainThread() && mNumPending > 0);

    --mNumPending;
    if (mNumPending) {
      return;
    }

    mPromise->Resolve(true, __func__);
  }

  void OnCompletion(Maybe<UntrustedModulesData>&& aResult) {
    MOZ_ASSERT(NS_IsMainThread());

    if (aResult.isSome()) {
      mBackupSvc->Backup(std::move(aResult.ref()));
    }

    OnCompletion();
  }

 private:
  // Combinations of the flags defined under nsITelemetry.
  // (See "Flags for getUntrustedModuleLoadEvents" in nsITelemetry.idl)
  uint32_t mFlags;

  RefPtr<UntrustedModulesBackupService> mBackupSvc;
  RefPtr<MultiGetUntrustedModulesPromise::Private> mPromise;
  size_t mNumPending;
};

RefPtr<MultiGetUntrustedModulesPromise>
MultiGetUntrustedModulesData::GetUntrustedModuleLoadEvents() {
  MOZ_ASSERT(XRE_IsParentProcess() && NS_IsMainThread());

  // Parent process
  RefPtr<DllServices> dllSvc(DllServices::Get());
  AddPending(dllSvc->GetUntrustedModulesData());

  // Child processes
  nsTArray<dom::ContentParent*> contentParents;
  dom::ContentParent::GetAll(contentParents);
  for (auto&& contentParent : contentParents) {
    AddPending(contentParent->SendGetUntrustedModulesData());
  }

  if (RefPtr<net::SocketProcessParent> socketActor =
          net::SocketProcessParent::GetSingleton()) {
    AddPending(socketActor->SendGetUntrustedModulesData());
  }

  if (RDDProcessManager* rddMgr = RDDProcessManager::Get()) {
    if (RDDChild* rddChild = rddMgr->GetRDDChild()) {
      AddPending(rddChild->SendGetUntrustedModulesData());
    }
  }

  if (RefPtr<ipc::UtilityProcessManager> utilityManager =
          ipc::UtilityProcessManager::GetIfExists()) {
    for (RefPtr<ipc::UtilityProcessParent>& parent :
         utilityManager->GetAllProcessesProcessParent()) {
      AddPending(parent->SendGetUntrustedModulesData());
    }
  }

  if (RefPtr<gmp::GeckoMediaPluginServiceParent> gmps =
          gmp::GeckoMediaPluginServiceParent::GetSingleton()) {
    nsTArray<RefPtr<
        gmp::GeckoMediaPluginServiceParent::GetUntrustedModulesDataPromise>>
        promises;
    gmps->SendGetUntrustedModulesData(promises);
    for (auto& promise : promises) {
      AddPending(std::move(promise));
    }
  }

  return mPromise;
}

#if defined(XP_WIN)
nsTArray<nsDependentSubstring> GetBlockedModules() {
  nsTArray<nsDependentSubstring> blockedModules;
  RefPtr<DllServices> dllSvc(DllServices::Get());
  nt::SharedSection* sharedSection = dllSvc->GetSharedSection();
  if (!sharedSection) {
    return blockedModules;
  }

  auto dynamicBlocklist = sharedSection->GetDynamicBlocklist();
  for (const auto& blockedEntry : dynamicBlocklist) {
    if (!blockedEntry.IsValidDynamicBlocklistEntry()) {
      break;
    }
    blockedModules.AppendElement(
        nsDependentSubstring(blockedEntry.mName.Buffer,
                             blockedEntry.mName.Length / sizeof(wchar_t)));
  }
  return blockedModules;
}
#endif

nsresult MultiGetUntrustedModulesData::SubmitToGlean() {
  MOZ_ASSERT(mFlags == 0,
             "The Glean 'third-party-modules' ping doesn't know how to handle "
             "nsITelemetry's flags for getUntrustedModuleLoadEvents.");

  const UntrustedModulesBackupData& stagingRef = mBackupSvc->Staging();
  if (stagingRef.IsEmpty()) {
    return NS_OK;
  }
  glean::third_party_modules::ModulesObject modules;
  glean::third_party_modules::ProcessesObject processes;
  uint32_t modulesArrayIdx = 0;
  for (const auto& container : stagingRef.Values()) {
    if (!container) {
      continue;
    }
    const auto& data = container->mData;
    // We are duplicating the module mapping that
    // UntrustedModulesDataSerializer::AddSingleData does because
    // 1) Accessing its mIndexMap at the correct time would be fragile.
    // 2) Decoupling data submission from JS serialization is arguably good.
    nsTHashMap<nsStringHashKey, uint32_t> indexMap;
    for (const auto& entry : data.mModules) {
      nsresult rv = NS_OK;
      (void)indexMap.LookupOrInsertWith(entry.GetKey(), [&]() -> uint32_t {
        const auto record = entry.GetData();
        if (!record) {
          rv = NS_ERROR_FAILURE;
          return 0;
        }
        glean::third_party_modules::ModulesObjectItem item;
        item.resolvedDllName =
            Some(NS_ConvertUTF16toUTF8(record->mSanitizedDllName));
        if (record->mVersion.isSome()) {
          auto [major, minor, patch, build] = record->mVersion->AsTuple();
          nsCString version;
          version.AppendPrintf("%" PRIu16 ".%" PRIu16 ".%" PRIu16 ".%" PRIu16,
                               major, minor, patch, build);
          item.fileVersion = Some(version);
        }
        if (record->mVendorInfo.isSome()) {
          MOZ_ASSERT(!record->mVendorInfo->mVendor.IsEmpty());
          if (record->mVendorInfo->mVendor.IsEmpty()) {
            // Per `SerializeModule`, this is an error condition severe enough
            // to cease further processing.
            rv = NS_ERROR_FAILURE;
            return 0;
          }
          switch (record->mVendorInfo->mSource) {
            case VendorInfo::Source::Signature:
              item.signedBy =
                  Some(NS_ConvertUTF16toUTF8(record->mVendorInfo->mVendor));
              break;
            case VendorInfo::Source::VersionInfo:
              item.companyName =
                  Some(NS_ConvertUTF16toUTF8(record->mVendorInfo->mVendor));
              break;
            default:
              MOZ_ASSERT_UNREACHABLE("Unknown VendorInfo Source!");
              rv = NS_ERROR_FAILURE;
              return 0;
          }
        }
        item.trustFlags = Some(static_cast<int64_t>(record->mTrustFlags));
        modules.EmplaceBack(item);
        return modulesArrayIdx++;
      });

      if (modulesArrayIdx > kMaxModulesArrayLen) {
        rv = NS_ERROR_CANNOT_CONVERT_DATA;
      }

      if (NS_WARN_IF(NS_FAILED(rv))) {
        return rv;
      }
    }

    nsDependentCString processType;
    if (data.mProcessType == GeckoProcessType_Default) {
      processType.Rebind("browser"_ns, 0);
    } else {
      processType.Rebind(XRE_GeckoProcessTypeToString(data.mProcessType));
    }

    // UntrusteModulesDataSerializer::Add allows for multiple containers' data
    // to be for the same process (type and pid).
    // When that happens, the latest containers' data would take precedence.
    // By intuition, I don't think that happens so we don't need to worry.
    // And if it does, we'll get two items in the `processes` array:
    // analyses may merely take the latest one.
    glean::third_party_modules::ProcessesObjectItem process{
        .processType = Some(processType),
        .sanitizationFailures = Some(data.mSanitizationFailures),
        .trustTestFailures = Some(data.mTrustTestFailures),
        .rejectedFiles = Some(data.mRejectedFiles),
    };

    nsCString strPid(processType);
    strPid.AppendLiteral(".0x");
    strPid.AppendInt(static_cast<uint32_t>(data.mPid), 16);
    process.processName = Some(strPid);

    nsCString elapsed;
    elapsed.AppendFloat(data.mElapsed.ToSeconds());
    process.elapsed = Some(elapsed);

    if (data.mXULLoadDurationMS.isSome()) {
      nsCString xulLoadDuration;
      xulLoadDuration.AppendFloat(*(data.mXULLoadDurationMS));
      process.xulLoadDurationMS = Some(xulLoadDuration);
    }

    glean::third_party_modules::ProcessesObjectItemEvents eventsArray;
    for (const auto& eventContainer : data.mEvents) {
      const ProcessedModuleLoadEvent& event = eventContainer->mEvent;
      if (!event) {
        // Event has no module.
        continue;
      }
      glean::third_party_modules::ProcessesObjectItemEventsItem eventItem{
          .processUptimeMS = Some(static_cast<int64_t>(event.mProcessUptimeMS)),
          // TODO: Document the narrowing conversion (2^64ms is ~584MY)
          .threadID = Some(event.mThreadId),
          .requestedDllName =
              Some(NS_ConvertUTF16toUTF8(event.mRequestedDllName)),
          .isDependent = Some(event.mIsDependent),
          .loadStatus = Some(event.mLoadStatus),
      };

      if (event.mLoadDurationMS.isSome()) {
        nsCString loadDuration;
        loadDuration.AppendFloat(*(event.mLoadDurationMS));
        eventItem.loadDurationMS = Some(loadDuration);
      }

      nsDependentCString effectiveThreadName;
      if (event.mThreadId == ::GetCurrentThreadId()) {
        effectiveThreadName.Rebind("Main Thread"_ns, 0);
      } else {
        effectiveThreadName.Rebind(event.mThreadName, 0);
      }
      if (!effectiveThreadName.IsEmpty()) {
        eventItem.threadName = Some(event.mThreadName);
      }

      if (!event.mRequestedDllName.IsEmpty() &&
          !event.mRequestedDllName.Equals(event.mModule->mSanitizedDllName,
                                          nsCaseInsensitiveStringComparator)) {
        // TODO: Truncate to MAX_PATH - 3 + "..."
        eventItem.requestedDllName =
            Some(NS_ConvertUTF16toUTF8(event.mRequestedDllName));
      }

      nsAutoCString baseAddress("0x");
      baseAddress.AppendInt(event.mBaseAddress, 16);
      eventItem.baseAddress = Some(baseAddress);

      uint32_t moduleIndex;
      if (!indexMap.Get(event.mModule->mResolvedNtName, &moduleIndex)) {
        // TODO: Should we instrument this somehow?
        continue;
      }
      eventItem.moduleIndex = Some(moduleIndex);

      eventsArray.AppendElement(eventItem);
    }
    if (eventsArray.Length()) {
      process.events = Some(std::move(eventsArray));
    }

    glean::third_party_modules::ProcessesObjectItemCombinedstacks
        combinedStacks;
    glean::third_party_modules::ProcessesObjectItemCombinedstacksMemorymap
        memoryMap;
    const size_t moduleCount = data.mStacks.GetModuleCount();
    for (size_t moduleIndex = 0; moduleIndex < moduleCount; ++moduleIndex) {
      const auto& module = data.mStacks.GetModule(moduleIndex);
      memoryMap.EmplaceBack(nsTArray<nsCString>{
          NS_ConvertUTF16toUTF8(module.mName),
          module.mBreakpadId,
      });
    }
    combinedStacks.memoryMap = Some(std::move(memoryMap));

    const size_t stackCount = data.mStacks.GetStackCount();
    glean::third_party_modules::ProcessesObjectItemCombinedstacksStacks
        stackArray;
    for (size_t stackIndex = 0; stackIndex < stackCount; ++stackIndex) {
      nsTArray<nsTArray<int64_t>> pcArray;
      const CombinedStacks::Stack& stack = data.mStacks.GetStack(stackIndex);
      const uint32_t pcCount = stack.size();
      for (size_t pcIndex = 0; pcIndex < pcCount; ++pcIndex) {
        const ProcessedStack::Frame& frame = stack[pcIndex];
        const int64_t modIndex =
            (std::numeric_limits<uint16_t>::max() == frame.mModIndex)
                ? -1
                : frame.mModIndex;
        pcArray.EmplaceBack(nsTArray<int64_t>{
            modIndex,
            static_cast<int64_t>(frame.mOffset),
        });
      }
      stackArray.AppendElement(std::move(pcArray));
    }
    combinedStacks.stacks = Some(std::move(stackArray));

    process.combinedStacks = Some(std::move(combinedStacks));
    processes.AppendElement(std::move(process));
  }
  glean::third_party_modules::modules.Set(std::move(modules));
  glean::third_party_modules::processes.Set(std::move(processes));

#if defined(XP_WIN)
  nsTArray<nsDependentSubstring> uBlockedModules = GetBlockedModules();
  nsTArray<nsCString> blockedModules;
  for (const auto& blockedModule : uBlockedModules) {
    blockedModules.EmplaceBack(NS_ConvertUTF16toUTF8(blockedModule));
  }
  glean::third_party_modules::blocked_modules.Set(blockedModules);
#endif
  glean_pings::ThirdPartyModules.Submit();
  return NS_OK;
}

void MultiGetUntrustedModulesData::Serialize(RefPtr<dom::Promise>&& aPromise) {
  MOZ_ASSERT(NS_IsMainThread());

  dom::AutoJSAPI jsapi;
  if (NS_WARN_IF(!jsapi.Init(aPromise->GetGlobalObject()))) {
    aPromise->MaybeReject(NS_ERROR_FAILURE);
    return;
  }

  JSContext* cx = jsapi.cx();
  UntrustedModulesDataSerializer serializer(cx, kMaxModulesArrayLen, mFlags);
  if (!serializer) {
    aPromise->MaybeReject(NS_ERROR_FAILURE);
    return;
  }

  nsresult rv;
  if (mFlags & nsITelemetry::INCLUDE_OLD_LOADEVENTS) {
    // When INCLUDE_OLD_LOADEVENTS is set, we need to return instances
    // from both "Staging" and "Settled" backup.
    if (mFlags & nsITelemetry::KEEP_LOADEVENTS_NEW) {
      // When INCLUDE_OLD_LOADEVENTS and KEEP_LOADEVENTS_NEW are set, we need to
      // return a JS object consisting of all instances from both "Staging" and
      // "Settled" backups, keeping instances in those backups as is.
      if (mFlags & nsITelemetry::EXCLUDE_STACKINFO_FROM_LOADEVENTS) {
        // Without the stack info, we can add multiple UntrustedModulesData to
        // the serializer directly.
        rv = serializer.Add(mBackupSvc->Staging());
        if (NS_WARN_IF(NS_FAILED(rv))) {
          aPromise->MaybeReject(rv);
          return;
        }
        rv = serializer.Add(mBackupSvc->Settled());
        if (NS_WARN_IF(NS_FAILED(rv))) {
          aPromise->MaybeReject(rv);
          return;
        }
      } else {
        // Currently we don't have a method to merge UntrustedModulesData into
        // a serialized JS object because merging CombinedStack will be tricky.
        // Thus we return an error on this flag combination.
        aPromise->MaybeReject(NS_ERROR_INVALID_ARG);
        return;
      }
    } else {
      // When KEEP_LOADEVENTS_NEW is not set, we can move data from "Staging"
      // to "Settled" first, then add "Settled" to the serializer.
      mBackupSvc->SettleAllStagingData();

      const UntrustedModulesBackupData& settledRef = mBackupSvc->Settled();
      if (settledRef.IsEmpty()) {
        aPromise->MaybeReject(NS_ERROR_NOT_AVAILABLE);
        return;
      }

      rv = serializer.Add(settledRef);
      if (NS_WARN_IF(NS_FAILED(rv))) {
        aPromise->MaybeReject(rv);
        return;
      }
    }
  } else {
    // When INCLUDE_OLD_LOADEVENTS is not set, we serialize only the "Staging"
    // into a JS object.
    const UntrustedModulesBackupData& stagingRef = mBackupSvc->Staging();

    if (stagingRef.IsEmpty()) {
      aPromise->MaybeReject(NS_ERROR_NOT_AVAILABLE);
      return;
    }

    rv = serializer.Add(stagingRef);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      aPromise->MaybeReject(rv);
      return;
    }

    // When KEEP_LOADEVENTS_NEW is not set, we move all "Staging" instances
    // to the "Settled".
    if (!(mFlags & nsITelemetry::KEEP_LOADEVENTS_NEW)) {
      mBackupSvc->SettleAllStagingData();
    }
  }

#if defined(XP_WIN)
  nsTArray<nsDependentSubstring> blockedModules = GetBlockedModules();
  if (!blockedModules.IsEmpty()) {
    rv = serializer.AddBlockedModules(blockedModules);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      aPromise->MaybeReject(rv);
      return;
    }
  }
#endif

  JS::Rooted<JS::Value> jsval(cx);
  serializer.GetObject(&jsval);
  aPromise->MaybeResolve(jsval);
}

nsresult MaybeSubmitAndGetUntrustedModulePayload(JSContext* aCx,
                                                 dom::Promise** aPromise,
                                                 uint32_t aFlags,
                                                 bool aSubmitGleanPing) {
  // Create a promise using global context.
  nsIGlobalObject* global = xpc::CurrentNativeGlobal(aCx);
  if (NS_WARN_IF(!global)) {
    return NS_ERROR_FAILURE;
  }

  ErrorResult result;
  RefPtr<dom::Promise> promise(dom::Promise::Create(global, result));
  if (NS_WARN_IF(result.Failed())) {
    return result.StealNSResult();
  }

  auto multi = MakeRefPtr<MultiGetUntrustedModulesData>(aFlags);
  multi->GetUntrustedModuleLoadEvents()->Then(
      GetMainThreadSerialEventTarget(), __func__,
      [promise, multi, aSubmitGleanPing](bool) mutable {
        if (aSubmitGleanPing) {
          nsresult rv = multi->SubmitToGlean();
          if (NS_FAILED(rv)) {
            promise->MaybeReject(rv);
            return;
          }
        }
        multi->Serialize(std::move(promise));
      },
      [promise](nsresult aRv) { promise->MaybeReject(aRv); });

  promise.forget(aPromise);
  return NS_OK;
}

nsresult SubmitAndGetUntrustedModulePayload(JSContext* aCx,
                                            dom::Promise** aPromise) {
  return MaybeSubmitAndGetUntrustedModulePayload(aCx, aPromise, 0, true);
}

nsresult GetUntrustedModuleLoadEvents(uint32_t aFlags, JSContext* aCx,
                                      dom::Promise** aPromise) {
  return MaybeSubmitAndGetUntrustedModulePayload(aCx, aPromise, aFlags, false);
}

}  // namespace Telemetry
}  // namespace mozilla
