/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

#include "UntrustedModulesProcessor.h"

#include <windows.h>
#include <aclapi.h>

#include "GMPPlatform.h"
#include "GMPServiceParent.h"
#include "mozilla/CmdLineAndEnvUtils.h"
#include "mozilla/DebugOnly.h"
#include "mozilla/dom/ContentChild.h"
#include "mozilla/dom/ContentParent.h"
#include "mozilla/Likely.h"
#include "mozilla/net/SocketProcessChild.h"
#include "mozilla/net/SocketProcessParent.h"
#include "mozilla/ipc/UtilityProcessParent.h"
#include "mozilla/ipc/UtilityProcessChild.h"
#include "mozilla/RDDChild.h"
#include "mozilla/RDDParent.h"
#include "mozilla/RDDProcessManager.h"
#include "mozilla/Services.h"
#include "mozilla/Telemetry.h"
#include "mozilla/UniquePtrExtensions.h"
#include "ModuleEvaluator.h"
#include "nsCOMPtr.h"
#include "nsHashKeys.h"
#include "nsIObserverService.h"
#include "nsTHashtable.h"
#include "nsThreadUtils.h"
#include "nsWindowsHelpers.h"
#include "nsXULAppAPI.h"
#include "private/prpriv.h"  // For PR_GetThreadID

namespace mozilla {

// NT paths are not bounded by MAX_PATH. This is the ceiling we are willing to
// grow a path buffer to while resolving one.
static const uint32_t kMaxNtPathLen = 0x8000;

/**
 * Gets the path of the file that aFile refers to, in the form that aFlags
 * selects (see GetFinalPathNameByHandleW).
 */
static bool GetPathFromHandle(HANDLE aFile, DWORD aFlags, nsAString& aOutPath) {
  aOutPath.Truncate();

  for (uint32_t bufLen = MAX_PATH; bufLen <= kMaxNtPathLen; bufLen *= 2) {
    nsAutoString buf;
    if (!buf.SetLength(bufLen, fallible)) {
      return false;
    }

    DWORD charsWritten = ::GetFinalPathNameByHandleW(
        aFile, reinterpret_cast<wchar_t*>(buf.BeginWriting()), bufLen, aFlags);
    if (!charsWritten) {
      return false;
    }

    if (charsWritten >= bufLen) {
      // Too small; retry with more room.
      continue;
    }

    buf.SetLength(charsWritten);
    aOutPath = buf;
    return true;
  }

  return false;
}

/**
 * Returns true if aFile lives on a remote device.
 */
static bool IsRemoteFile(HANDLE aFile) {
  nsAutoString dosPath;
  if (!GetPathFromHandle(aFile, FILE_NAME_OPENED | VOLUME_NAME_DOS, dosPath)) {
    // Treat errors as remote.
    return true;
  }

  // A UNC path is always remote.
  if (StringBeginsWith(dosPath, u"\\\\?\\UNC\\"_ns,
                       nsCaseInsensitiveStringComparator)) {
    return true;
  }

  if (dosPath.Length() < 7 || !StringBeginsWith(dosPath, u"\\\\?\\"_ns) ||
      dosPath[5] != u':') {
    // Some shape we do not recognise; do not guess.
    return true;
  }

  // GetDriveTypeW also catches a drive letter mapped to a network share.
  const wchar_t root[] = {static_cast<wchar_t>(dosPath[4]), L':', L'\\', L'\0'};
  UINT driveType = ::GetDriveTypeW(root);
  return driveType == DRIVE_REMOTE || driveType == DRIVE_UNKNOWN ||
         driveType == DRIVE_NO_ROOT_DIR;
}

/**
 * Returns true if aFile carries a mandatory integrity label below medium.  A
 * file with no label ACE is medium by default, which is the most common case,
 * and is accepted.
 */
static bool IsBelowMediumIntegrityFile(HANDLE aFile) {
  // aFile grants no access to the file, so reopen it to read its label.
  UniqueFileHandle labelAccess(
      ::ReOpenFile(aFile, READ_CONTROL,
                   FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE, 0));
  if (!labelAccess) {
    // Treat errors as untrustworthy.
    return true;
  }

  PACL sacl = nullptr;
  PSECURITY_DESCRIPTOR rawSd = nullptr;
  if (::GetSecurityInfo(labelAccess.get(), SE_FILE_OBJECT,
                        LABEL_SECURITY_INFORMATION, nullptr, nullptr, nullptr,
                        &sacl, &rawSd) != ERROR_SUCCESS) {
    // Treat errors as untrustworthy.
    return true;
  }

  UniquePtr<void, LocalFreeDeleter> sd(rawSd);

  if (!sacl) {
    // No label: medium by default.
    return false;
  }

  for (WORD i = 0; i < sacl->AceCount; ++i) {
    VOID* rawAce = nullptr;
    if (!::GetAce(sacl, i, &rawAce)) {
      return true;
    }

    auto* header = static_cast<ACE_HEADER*>(rawAce);
    if (header->AceType != SYSTEM_MANDATORY_LABEL_ACE_TYPE) {
      continue;
    }

    auto* labelAce = static_cast<SYSTEM_MANDATORY_LABEL_ACE*>(rawAce);
    auto* sid = reinterpret_cast<PSID>(&labelAce->SidStart);
    PUCHAR subAuthorityCount = ::GetSidSubAuthorityCount(sid);
    if (!subAuthorityCount || !*subAuthorityCount) {
      return true;
    }

    DWORD* rid = ::GetSidSubAuthority(sid, *subAuthorityCount - 1);
    if (!rid) {
      return true;
    }

    return *rid < SECURITY_MANDATORY_MEDIUM_RID;
  }

  // A SACL with no label ACE is also medium by default.
  return false;
}

bool ValidateAndResolveModuleFile(const ipc::FileDescriptor& aFile,
                                  nsAString& aOutNtPath) {
  aOutNtPath.Truncate();

  if (!aFile.IsValid()) {
    return false;
  }

  UniqueFileHandle file(aFile.ClonePlatformHandle());
  if (!file) {
    return false;
  }

  // A module is a file on a disk.  Asking for the path of anything else could
  // block.
  if (::GetFileType(file.get()) != FILE_TYPE_DISK) {
    return false;
  }

  // Reject a file on a remote device, or one carrying a mandatory integrity
  // label below medium.  The label check reopens the file, so it must not be
  // reached for a remote one.
  if (IsRemoteFile(file.get()) || IsBelowMediumIntegrityFile(file.get())) {
    return false;
  }

  // FILE_NAME_OPENED | VOLUME_NAME_NT gives the NT device form
  // (\Device\HarddiskVolumeN\...) of the path the loader opened, which is what
  // the child's loader observer records via
  // NtQueryVirtualMemory(..., MemorySectionName) and what ModuleRecord
  // expects, so the two are directly comparable.
  return GetPathFromHandle(file.get(), FILE_NAME_OPENED | VOLUME_NAME_NT,
                           aOutNtPath);
}

class MOZ_RAII BackgroundPriorityRegion final {
 public:
  BackgroundPriorityRegion()
      : mIsBackground(
            ::SetThreadPriority(::GetCurrentThread(), THREAD_PRIORITY_IDLE)) {}

  ~BackgroundPriorityRegion() {
    if (!mIsBackground) {
      return;
    }

    Clear(::GetCurrentThread());
  }

  static void Clear(const nsAutoHandle& aThread) {
    if (!aThread) {
      return;
    }

    Clear(aThread.get());
  }

  BackgroundPriorityRegion(const BackgroundPriorityRegion&) = delete;
  BackgroundPriorityRegion(BackgroundPriorityRegion&&) = delete;
  BackgroundPriorityRegion& operator=(const BackgroundPriorityRegion&) = delete;
  BackgroundPriorityRegion& operator=(BackgroundPriorityRegion&&) = delete;

 private:
  static void Clear(HANDLE aThread) {
    DebugOnly<BOOL> ok = ::SetThreadPriority(aThread, THREAD_PRIORITY_NORMAL);
    MOZ_ASSERT(ok);
  }

 private:
  const BOOL mIsBackground;
};

/* static */
bool UntrustedModulesProcessor::IsSupportedProcessType() {
  switch (XRE_GetProcessType()) {
    case GeckoProcessType_Default:
    case GeckoProcessType_Content:
    case GeckoProcessType_Socket:
      return Telemetry::CanRecordReleaseData();
    case GeckoProcessType_RDD:
    case GeckoProcessType_Utility:
    case GeckoProcessType_GMPlugin:
      // For GMPlugin, RDD and Utility process, we check the telemetry settings
      // in RDDChild::Init() / UtilityProcessChild::Init() / GMPChild::Init()
      // running in the browser process because CanRecordReleaseData() always
      // returns false here.
      return true;
    default:
      return false;
  }
}

/* static */
RefPtr<UntrustedModulesProcessor> UntrustedModulesProcessor::Create(
    bool aIsReadyForBackgroundProcessing) {
  if (!IsSupportedProcessType()) {
    return nullptr;
  }

  RefPtr<UntrustedModulesProcessor> result(
      new UntrustedModulesProcessor(aIsReadyForBackgroundProcessing));
  return result.forget();
}

NS_IMPL_ISUPPORTS(UntrustedModulesProcessor, nsIObserver, nsIThreadPoolListener)

static const uint32_t kThreadTimeoutMS = 120000;  // 2 minutes

UntrustedModulesProcessor::UntrustedModulesProcessor(
    bool aIsReadyForBackgroundProcessing)
    : mThread(new LazyIdleThread(kThreadTimeoutMS, "Untrusted Modules",
                                 LazyIdleThread::ManualShutdown)),
      mThreadHandleMutex(
          "mozilla::UntrustedModulesProcessor::mThreadHandleMutex"),
      mUnprocessedMutex(
          "mozilla::UntrustedModulesProcessor::mUnprocessedMutex"),
      mModuleCacheMutex(
          "mozilla::UntrustedModulesProcessor::mModuleCacheMutex"),
      mStatus(aIsReadyForBackgroundProcessing ? Status::Allowed
                                              : Status::StartingUp) {
  AddObservers();
}

void UntrustedModulesProcessor::AddObservers() {
  nsCOMPtr<nsIObserverService> obsServ(services::GetObserverService());
  obsServ->AddObserver(this, NS_XPCOM_WILL_SHUTDOWN_OBSERVER_ID, false);
  obsServ->AddObserver(this, "xpcom-shutdown-threads", false);
  obsServ->AddObserver(this, "unblock-untrusted-modules-thread", false);
  if (XRE_IsContentProcess()) {
    obsServ->AddObserver(this, "content-child-will-shutdown", false);
  }
  mThread->SetListener(this);
}

bool UntrustedModulesProcessor::IsReadyForBackgroundProcessing() const {
  return mStatus == Status::Allowed;
}

void UntrustedModulesProcessor::Disable() {
  // Ensure that mThread cannot run at low priority anymore
  {
    MutexAutoLock lock(mThreadHandleMutex);
    BackgroundPriorityRegion::Clear(mThreadHandle);
  }

  // No more background processing allowed beyond this point
  if (mStatus.exchange(Status::ShuttingDown) != Status::Allowed) {
    return;
  }

  MutexAutoLock lock(mUnprocessedMutex);
  CancelScheduledProcessing(lock);
}

NS_IMETHODIMP UntrustedModulesProcessor::Observe(nsISupports* aSubject,
                                                 const char* aTopic,
                                                 const char16_t* aData) {
  if (!strcmp(aTopic, NS_XPCOM_WILL_SHUTDOWN_OBSERVER_ID) ||
      !strcmp(aTopic, "content-child-will-shutdown")) {
    Disable();
    return NS_OK;
  }

  if (!strcmp(aTopic, "xpcom-shutdown-threads")) {
    Disable();
    mThread->Shutdown();

    RemoveObservers();

    mThread = nullptr;
    return NS_OK;
  }

  if (!strcmp(aTopic, "unblock-untrusted-modules-thread")) {
    nsCOMPtr<nsIObserverService> obs(services::GetObserverService());
    obs->RemoveObserver(this, "unblock-untrusted-modules-thread");

    mStatus.compareExchange(Status::StartingUp, Status::Allowed);

    if (!IsReadyForBackgroundProcessing()) {
      // If we're shutting down, stop here.
      return NS_OK;
    }

    if (XRE_IsParentProcess()) {
      // Propagate notification to child processes
      nsTArray<dom::ContentParent*> contentProcesses;
      dom::ContentParent::GetAll(contentProcesses);
      for (auto* proc : contentProcesses) {
        (void)proc->SendUnblockUntrustedModulesThread();
      }
      if (RefPtr<net::SocketProcessParent> proc =
              net::SocketProcessParent::GetSingleton()) {
        (void)proc->SendUnblockUntrustedModulesThread();
      }
      if (auto* rddMgr = RDDProcessManager::Get()) {
        if (auto* proc = rddMgr->GetRDDChild()) {
          (void)proc->SendUnblockUntrustedModulesThread();
        }
      }
      if (RefPtr<gmp::GeckoMediaPluginServiceParent> gmps =
              gmp::GeckoMediaPluginServiceParent::GetSingleton()) {
        gmps->SendUnblockUntrustedModulesThread();
      }
    }

    return NS_OK;
  }

  MOZ_ASSERT_UNREACHABLE("Not reachable");

  return NS_OK;
}

NS_IMETHODIMP UntrustedModulesProcessor::OnThreadCreated() {
  // Whenever a backing lazy thread is created, record a thread handle to it.
  HANDLE threadHandle;
  if (!::DuplicateHandle(
          ::GetCurrentProcess(), ::GetCurrentThread(), ::GetCurrentProcess(),
          &threadHandle,
          THREAD_QUERY_LIMITED_INFORMATION | THREAD_SET_LIMITED_INFORMATION,
          FALSE, 0)) {
    MOZ_ASSERT_UNREACHABLE("DuplicateHandle failed on GetCurrentThread()?");
    threadHandle = nullptr;
  }
  MutexAutoLock lock(mThreadHandleMutex);
  mThreadHandle.own(threadHandle);
  return NS_OK;
}

NS_IMETHODIMP UntrustedModulesProcessor::OnThreadShuttingDown() {
  // When a lazy thread shuts down, clean up the thread handle reference unless
  // it's already been replaced.
  MutexAutoLock lock(mThreadHandleMutex);
  if (mThreadHandle && ::GetCurrentThreadId() == ::GetThreadId(mThreadHandle)) {
    mThreadHandle.reset();
  }
  return NS_OK;
}

void UntrustedModulesProcessor::RemoveObservers() {
  nsCOMPtr<nsIObserverService> obsServ(services::GetObserverService());
  obsServ->RemoveObserver(this, NS_XPCOM_WILL_SHUTDOWN_OBSERVER_ID);
  obsServ->RemoveObserver(this, "xpcom-shutdown-threads");
  obsServ->RemoveObserver(this, "unblock-untrusted-modules-thread");
  if (XRE_IsContentProcess()) {
    obsServ->RemoveObserver(this, "content-child-will-shutdown");
  }
  mThread->SetListener(nullptr);
}

void UntrustedModulesProcessor::ScheduleNonEmptyQueueProcessing(
    const MutexAutoLock& aProofOfLock) {
  // In case something tried to load a DLL during shutdown
  if (!mThread) {
    return;
  }

#if defined(ENABLE_TESTS)
  // Don't bother scheduling background processing in short-lived xpcshell
  // processes; it makes the test suites take too long.
  if (MOZ_UNLIKELY(mozilla::EnvHasValue("XPCSHELL_TEST_PROFILE_DIR"))) {
    return;
  }
#endif  // defined(ENABLE_TESTS)

  if (mIdleRunnable) {
    return;
  }

  if (!IsReadyForBackgroundProcessing()) {
    return;
  }

  // Schedule a runnable to trigger background processing once the main thread
  // has gone idle. We do it this way to ensure that we don't start doing a
  // bunch of processing during periods of heavy main thread activity.
  nsCOMPtr<nsIRunnable> idleRunnable(NewCancelableRunnableMethod(
      "UntrustedModulesProcessor::DispatchBackgroundProcessing", this,
      &UntrustedModulesProcessor::DispatchBackgroundProcessing));

  if (NS_FAILED(NS_DispatchToMainThreadQueue(do_AddRef(idleRunnable),
                                             EventQueuePriority::Idle))) {
    return;
  }

  mIdleRunnable = std::move(idleRunnable);
}

void UntrustedModulesProcessor::CancelScheduledProcessing(
    const MutexAutoLock& aProofOfLock) {
  if (!mIdleRunnable) {
    return;
  }

  nsCOMPtr<nsICancelableRunnable> cancelable(do_QueryInterface(mIdleRunnable));
  if (cancelable) {
    // Stop the pending idle runnable from doing anything
    cancelable->Cancel();
  }

  mIdleRunnable = nullptr;
}

void UntrustedModulesProcessor::DispatchBackgroundProcessing() {
  MOZ_ASSERT(NS_IsMainThread());

  if (!IsReadyForBackgroundProcessing()) {
    return;
  }

  nsCOMPtr<nsIRunnable> runnable(NewRunnableMethod(
      "UntrustedModulesProcessor::BackgroundProcessModuleLoadQueue", this,
      &UntrustedModulesProcessor::BackgroundProcessModuleLoadQueue));

  mThread->Dispatch(runnable.forget(), NS_DISPATCH_NORMAL);
}

void UntrustedModulesProcessor::Enqueue(
    glue::EnhancedModuleLoadInfo&& aModLoadInfo) {
  if (mStatus == Status::ShuttingDown) {
    return;
  }

  {
    MutexAutoLock lock(mThreadHandleMutex);
    DWORD bgThreadId = ::GetThreadId(mThreadHandle);
    if (aModLoadInfo.mNtLoadInfo.mThreadId == bgThreadId) {
      // Exclude loads that were caused by our own background thread
      return;
    }
  }

  MutexAutoLock lock(mUnprocessedMutex);

  mUnprocessedModuleLoads.insertBack(
      new UnprocessedModuleLoadInfoContainer(std::move(aModLoadInfo)));

  ScheduleNonEmptyQueueProcessing(lock);
}

void UntrustedModulesProcessor::Enqueue(ModuleLoadInfoVec&& aEvents) {
  if (mStatus == Status::ShuttingDown) {
    return;
  }

  // We do not need to attempt to exclude our background thread in this case
  // because |aEvents| was accumulated prior to |mThread|'s existence.

  MutexAutoLock lock(mUnprocessedMutex);

  for (auto& event : aEvents) {
    mUnprocessedModuleLoads.insertBack(
        new UnprocessedModuleLoadInfoContainer(std::move(event)));
  }

  ScheduleNonEmptyQueueProcessing(lock);
}

void UntrustedModulesProcessor::AssertRunningOnLazyIdleThread() {
#if defined(DEBUG)
  MOZ_ASSERT(mThread->IsOnCurrentThread());
#endif  // defined(DEBUG)
}

RefPtr<UntrustedModulesPromise> UntrustedModulesProcessor::GetProcessedData() {
  MOZ_ASSERT(NS_IsMainThread());

  // Clear any background priority in case background processing is running.
  {
    MutexAutoLock lock(mThreadHandleMutex);
    BackgroundPriorityRegion::Clear(mThreadHandle);
  }

  RefPtr<UntrustedModulesProcessor> self(this);
  return InvokeAsync(mThread, __func__, [self = std::move(self)]() {
    return self->GetProcessedDataInternal();
  });
}

RefPtr<ModulesTrustPromise> UntrustedModulesProcessor::GetModulesTrust(
    ModuleIdentifiers&& aModIdents, bool aRunAtNormalPriority) {
  MOZ_ASSERT(XRE_IsParentProcess() && NS_IsMainThread());

  if (!IsReadyForBackgroundProcessing()) {
    return ModulesTrustPromise::CreateAndReject(
        NS_ERROR_ILLEGAL_DURING_SHUTDOWN, __func__);
  }

  RefPtr<UntrustedModulesProcessor> self(this);
  auto run = [self = std::move(self), modIdents = std::move(aModIdents),
              runNormal = aRunAtNormalPriority]() mutable {
    return self->GetModulesTrustInternal(std::move(modIdents), runNormal);
  };

  if (aRunAtNormalPriority) {
    // Clear any background priority in case background processing is running.
    {
      MutexAutoLock lock(mThreadHandleMutex);
      BackgroundPriorityRegion::Clear(mThreadHandle);
    }

    return InvokeAsync(mThread, __func__, std::move(run));
  }

  RefPtr<ModulesTrustPromise::Private> p(
      new ModulesTrustPromise::Private(__func__));
  nsCOMPtr<nsISerialEventTarget> evtTarget(mThread);
  StaticString source = __func__;

  auto runWrap = [evtTarget = std::move(evtTarget), p, source,
                  run = std::move(run)]() mutable -> void {
    InvokeAsync(evtTarget, source, std::move(run))->ChainTo(p.forget(), source);
  };

  nsCOMPtr<nsIRunnable> idleRunnable(
      NS_NewRunnableFunction(source, std::move(runWrap)));

  nsresult rv = NS_DispatchToMainThreadQueue(idleRunnable.forget(),
                                             EventQueuePriority::Idle);
  if (NS_FAILED(rv)) {
    p->Reject(rv, source);
  }

  return p;
}

RefPtr<UntrustedModulesPromise>
UntrustedModulesProcessor::GetProcessedDataInternal() {
  AssertRunningOnLazyIdleThread();
  if (!XRE_IsParentProcess()) {
    return GetProcessedDataInternalChildProcess();
  }

  ProcessModuleLoadQueue();

  return GetAllProcessedData(__func__);
}

RefPtr<UntrustedModulesPromise> UntrustedModulesProcessor::GetAllProcessedData(
    StaticString aSource) {
  AssertRunningOnLazyIdleThread();

  UntrustedModulesData result;

  if (!mProcessedModuleLoads) {
    return UntrustedModulesPromise::CreateAndResolve(Nothing(), aSource);
  }

  result.Swap(mProcessedModuleLoads);

  result.mElapsed = TimeStamp::Now() - TimeStamp::ProcessCreation();

  return UntrustedModulesPromise::CreateAndResolve(
      Some(UntrustedModulesData(std::move(result))), aSource);
}

RefPtr<UntrustedModulesPromise>
UntrustedModulesProcessor::GetProcessedDataInternalChildProcess() {
  AssertRunningOnLazyIdleThread();
  MOZ_ASSERT(!XRE_IsParentProcess());

  RefPtr<GetModulesTrustPromise> whenProcessed(
      ProcessModuleLoadQueueChildProcess(Priority::Default));

  RefPtr<UntrustedModulesProcessor> self(this);
  RefPtr<UntrustedModulesPromise::Private> p(
      new UntrustedModulesPromise::Private(__func__));
  nsCOMPtr<nsISerialEventTarget> evtTarget(mThread);

  StaticString source = __func__;
  auto completionRoutine = [evtTarget = std::move(evtTarget), p,
                            self = std::move(self), source,
                            whenProcessed = std::move(whenProcessed)]() {
    MOZ_ASSERT(NS_IsMainThread());
    if (!self->IsReadyForBackgroundProcessing()) {
      // We can't do any more work, just reject all the things
      whenProcessed->Then(
          GetMainThreadSerialEventTarget(), source,
          [p, source](Maybe<ModulesMapResultWithLoads>&& aResult) {
            p->Reject(NS_ERROR_ILLEGAL_DURING_SHUTDOWN, source);
          },
          [p, source](nsresult aRv) { p->Reject(aRv, source); });
      return;
    }

    whenProcessed->Then(
        evtTarget, source,
        [p, self = std::move(self),
         source](Maybe<ModulesMapResultWithLoads>&& aResult) mutable {
          if (aResult.isSome()) {
            self->CompleteProcessing(std::move(aResult.ref()));
          }
          self->GetAllProcessedData(source)->ChainTo(p.forget(), source);
        },
        [p, source](nsresult aRv) { p->Reject(aRv, source); });
  };

  // We always send |completionRoutine| on a trip through the main thread
  // due to some subtlety with |mThread| being a LazyIdleThread: we can only
  // Dispatch or Then to |mThread| from its creating thread, which is the
  // main thread. Hopefully we can get rid of this in the future and just
  // invoke whenProcessed->Then() directly.
  nsresult rv = NS_DispatchToMainThread(
      NS_NewRunnableFunction(__func__, std::move(completionRoutine)));
  MOZ_ASSERT(NS_SUCCEEDED(rv));
  if (NS_FAILED(rv)) {
    p->Reject(rv, __func__);
  }

  return p;
}

void UntrustedModulesProcessor::BackgroundProcessModuleLoadQueue() {
  if (!IsReadyForBackgroundProcessing()) {
    return;
  }

  BackgroundPriorityRegion bgRgn;

  if (!IsReadyForBackgroundProcessing()) {
    return;
  }

  ProcessModuleLoadQueue();
}

RefPtr<ModuleRecord> UntrustedModulesProcessor::GetOrAddModuleRecord(
    const ModuleEvaluator& aModEval, const nsAString& aResolvedNtPath) {
  MOZ_ASSERT(XRE_IsParentProcess());

  MutexAutoLock lock(mModuleCacheMutex);
  return mGlobalModuleCache.WithEntryHandle(
      aResolvedNtPath, [&](auto&& addPtr) -> RefPtr<ModuleRecord> {
        if (addPtr) {
          return addPtr.Data();
        }

        RefPtr<ModuleRecord> newMod(new ModuleRecord(aResolvedNtPath));
        if (!(*newMod)) {
          return nullptr;
        }

        Maybe<ModuleTrustFlags> maybeTrust = aModEval.GetTrust(*newMod);
        if (maybeTrust.isNothing()) {
          return nullptr;
        }

        newMod->mTrustFlags = maybeTrust.value();

        return addPtr.Insert(std::move(newMod));
      });
}

RefPtr<ModuleRecord> UntrustedModulesProcessor::GetModuleRecord(
    const ModulesMap& aModules,
    const glue::EnhancedModuleLoadInfo& aModuleLoadInfo) {
  MOZ_ASSERT(!XRE_IsParentProcess());

  // aModules is keyed by the path the parent derived with
  // GetFinalPathNameByHandleW, while mSectionName comes from
  // NtQueryVirtualMemory(..., MemorySectionName).  Both name the module's file
  // in NT device form.
  return aModules.Get(aModuleLoadInfo.mNtLoadInfo.mSectionName.AsString());
}

void UntrustedModulesProcessor::BackgroundProcessModuleLoadQueueChildProcess() {
  RefPtr<GetModulesTrustPromise> whenProcessed(
      ProcessModuleLoadQueueChildProcess(Priority::Background));

  RefPtr<UntrustedModulesProcessor> self(this);
  nsCOMPtr<nsISerialEventTarget> evtTarget(mThread);

  constexpr StaticString const source = __func__;
  auto completionRoutine = [evtTarget = std::move(evtTarget),
                            self = std::move(self), source,
                            whenProcessed = std::move(whenProcessed)]() {
    MOZ_ASSERT(NS_IsMainThread());
    if (!self->IsReadyForBackgroundProcessing()) {
      // We can't do any more work, just no-op
      whenProcessed->Then(
          GetMainThreadSerialEventTarget(), source,
          [](Maybe<ModulesMapResultWithLoads>&& aResult) {},
          [](nsresult aRv) {});
      return;
    }

    whenProcessed->Then(
        evtTarget, source,
        [self = std::move(self)](Maybe<ModulesMapResultWithLoads>&& aResult) {
          if (aResult.isNothing() || !self->IsReadyForBackgroundProcessing()) {
            // Nothing to do
            return;
          }

          BackgroundPriorityRegion bgRgn;
          self->CompleteProcessing(std::move(aResult.ref()));
        },
        [](nsresult aRv) {});
  };

  // We always send |completionRoutine| on a trip through the main thread
  // due to some subtlety with |mThread| being a LazyIdleThread: we can only
  // Dispatch or Then to |mThread| from its creating thread, which is the
  // main thread. Hopefully we can get rid of this in the future and just
  // invoke whenProcessed->Then() directly.
  DebugOnly<nsresult> rv = NS_DispatchToMainThread(
      NS_NewRunnableFunction(__func__, std::move(completionRoutine)));
  MOZ_ASSERT(NS_SUCCEEDED(rv));
}

UnprocessedModuleLoads UntrustedModulesProcessor::ExtractLoadingEventsToProcess(
    size_t aMaxLength) {
  UnprocessedModuleLoads loadsToProcess;

  MutexAutoLock lock(mUnprocessedMutex);
  CancelScheduledProcessing(lock);

  loadsToProcess.splice(0, mUnprocessedModuleLoads, 0, aMaxLength);
  return loadsToProcess;
}

// This function contains multiple IsReadyForBackgroundProcessing() checks so
// that we can quickly bail out at the first sign of shutdown. This may be
// important when the current thread is running under background priority.
void UntrustedModulesProcessor::ProcessModuleLoadQueue() {
  AssertRunningOnLazyIdleThread();
  if (!XRE_IsParentProcess()) {
    BackgroundProcessModuleLoadQueueChildProcess();
    return;
  }

  UnprocessedModuleLoads loadsToProcess =
      ExtractLoadingEventsToProcess(UntrustedModulesData::kMaxEvents);
  if (!IsReadyForBackgroundProcessing() || loadsToProcess.isEmpty()) {
    return;
  }

  ModuleEvaluator modEval;
  MOZ_ASSERT(!!modEval);
  if (!modEval) {
    return;
  }

  Telemetry::BatchProcessedStackGenerator stackProcessor;
  Maybe<double> maybeXulLoadDuration;
  Vector<Telemetry::ProcessedStack> processedStacks;
  UntrustedModuleLoadingEvents processedEvents;
  uint32_t sanitizationFailures = 0;
  uint32_t trustTestFailures = 0;

  for (UnprocessedModuleLoadInfoContainer* container : loadsToProcess) {
    glue::EnhancedModuleLoadInfo& entry = container->mInfo;

    if (!IsReadyForBackgroundProcessing()) {
      return;
    }

    RefPtr<ModuleRecord> module(GetOrAddModuleRecord(
        modEval, entry.mNtLoadInfo.mSectionName.AsString()));
    if (!module) {
      // We failed to obtain trust information about the module.
      // Don't include test failures in the ping to avoid flooding it.
      ++trustTestFailures;
      continue;
    }

    if (!IsReadyForBackgroundProcessing()) {
      return;
    }

    glue::EnhancedModuleLoadInfo::BacktraceType backtrace =
        std::move(entry.mNtLoadInfo.mBacktrace);
    ProcessedModuleLoadEvent event(std::move(entry), std::move(module));

    if (!event) {
      // We don't have a sanitized DLL path, so we cannot include this event
      // for privacy reasons.
      ++sanitizationFailures;
      continue;
    }

    if (!IsReadyForBackgroundProcessing()) {
      return;
    }

    if (event.IsTrusted()) {
      if (event.IsXULLoad()) {
        maybeXulLoadDuration = event.mLoadDurationMS;
      }

      // Trusted modules are not included in the ping
      continue;
    }

    mProcessedModuleLoads.mModules.LookupOrInsert(
        event.mModule->mResolvedNtName, event.mModule);

    if (!IsReadyForBackgroundProcessing()) {
      return;
    }

    Telemetry::ProcessedStack processedStack =
        stackProcessor.GetStackAndModules(backtrace);

    if (!IsReadyForBackgroundProcessing()) {
      return;
    }

    (void)processedStacks.emplaceBack(std::move(processedStack));
    processedEvents.insertBack(
        new ProcessedModuleLoadEventContainer(std::move(event)));
  }

  if (processedStacks.empty() && processedEvents.isEmpty() &&
      !sanitizationFailures && !trustTestFailures) {
    // Nothing to save
    return;
  }

  if (!IsReadyForBackgroundProcessing()) {
    return;
  }

  // Modules have been added to mProcessedModuleLoads.mModules
  // in the loop above.  Passing an empty ModulesMap to AddNewLoads.
  mProcessedModuleLoads.AddNewLoads(ModulesMap{}, std::move(processedEvents),
                                    std::move(processedStacks));
  if (maybeXulLoadDuration) {
    MOZ_ASSERT(!mProcessedModuleLoads.mXULLoadDurationMS);
    mProcessedModuleLoads.mXULLoadDurationMS = maybeXulLoadDuration;
  }

  mProcessedModuleLoads.mSanitizationFailures += sanitizationFailures;
  mProcessedModuleLoads.mTrustTestFailures += trustTestFailures;
}

template <typename ActorT>
static RefPtr<GetModulesTrustIpcPromise> SendGetModulesTrust(
    ActorT* aActor, ModuleIdentifiers&& aModIdents, bool aRunAtNormalPriority) {
  MOZ_ASSERT(NS_IsMainThread());
  return aActor->SendGetModulesTrust(std::move(aModIdents),
                                     aRunAtNormalPriority);
}

RefPtr<GetModulesTrustIpcPromise>
UntrustedModulesProcessor::SendGetModulesTrust(ModuleIdentifiers&& aModules,
                                               Priority aPriority) {
  MOZ_ASSERT(NS_IsMainThread());
  bool runNormal = aPriority == Priority::Default;

  switch (XRE_GetProcessType()) {
    case GeckoProcessType_Content: {
      return ::mozilla::SendGetModulesTrust(dom::ContentChild::GetSingleton(),
                                            std::move(aModules), runNormal);
    }
    case GeckoProcessType_RDD: {
      return ::mozilla::SendGetModulesTrust(RDDParent::GetSingleton(),
                                            std::move(aModules), runNormal);
    }
    case GeckoProcessType_Socket: {
      return ::mozilla::SendGetModulesTrust(
          net::SocketProcessChild::GetSingleton(), std::move(aModules),
          runNormal);
    }
    case GeckoProcessType_Utility: {
      return ::mozilla::SendGetModulesTrust(
          ipc::UtilityProcessChild::GetSingleton().get(), std::move(aModules),
          runNormal);
    }
    case GeckoProcessType_GMPlugin: {
      return ::mozilla::gmp::SendGetModulesTrust(std::move(aModules),
                                                 runNormal);
    }
    default: {
      MOZ_ASSERT_UNREACHABLE("Unsupported process type");
      return GetModulesTrustIpcPromise::CreateAndReject(
          ipc::ResponseRejectReason::SendError, __func__);
    }
  }
}

/**
 * This method works very similarly to ProcessModuleLoadQueue, with the
 * exception that a sandboxed child process does not have sufficient rights to
 * be able to evaluate a module's trustworthiness. Instead, we accumulate the
 * resolved paths for all of the modules in this batch and send them to the
 * parent to determine trustworthiness.
 *
 * The parent process returns a list of untrusted modules and invokes
 * CompleteProcessing to handle the remainder of the process.
 *
 * By doing it this way, we minimize the amount of data that needs to be sent
 * over IPC and avoid the need to process every load's metadata only
 * to throw most of it away (since most modules will be trusted).
 */
RefPtr<UntrustedModulesProcessor::GetModulesTrustPromise>
UntrustedModulesProcessor::ProcessModuleLoadQueueChildProcess(
    UntrustedModulesProcessor::Priority aPriority) {
  AssertRunningOnLazyIdleThread();
  MOZ_ASSERT(!XRE_IsParentProcess());

  UnprocessedModuleLoads loadsToProcess =
      ExtractLoadingEventsToProcess(UntrustedModulesData::kMaxEvents);
  if (loadsToProcess.isEmpty()) {
    // Nothing to process
    return GetModulesTrustPromise::CreateAndResolve(Nothing(), __func__);
  }

  if (!IsReadyForBackgroundProcessing()) {
    return GetModulesTrustPromise::CreateAndReject(
        NS_ERROR_ILLEGAL_DURING_SHUTDOWN, __func__);
  }

  nsTHashtable<nsStringCaseInsensitiveHashKey> alreadyAdded;
  ModuleIdentifiers moduleIdents;

  // Build the set of modules to be processed by the parent.
  for (UnprocessedModuleLoadInfoContainer* container : loadsToProcess) {
    glue::EnhancedModuleLoadInfo& entry = container->mInfo;

    if (!IsReadyForBackgroundProcessing()) {
      return GetModulesTrustPromise::CreateAndReject(
          NS_ERROR_ILLEGAL_DURING_SHUTDOWN, __func__);
    }

    if (!entry.mNtLoadInfo.mFileHandle) {
      // No file handle, so nothing the parent can verify.
      continue;
    }

    nsDependentString sectionName(entry.mNtLoadInfo.mSectionName.AsString());
    if (!alreadyAdded.EnsureInserted(sectionName)) {
      continue;
    }

    ipc::FileDescriptor file(entry.mNtLoadInfo.mFileHandle.get());
    if (!file.IsValid()) {
      continue;
    }

    moduleIdents.AppendElement(std::move(file));
  }

  if (!IsReadyForBackgroundProcessing()) {
    return GetModulesTrustPromise::CreateAndReject(
        NS_ERROR_ILLEGAL_DURING_SHUTDOWN, __func__);
  }

  if (moduleIdents.IsEmpty()) {
    // Nothing to process
    return GetModulesTrustPromise::CreateAndResolve(Nothing(), __func__);
  }

  if (!IsReadyForBackgroundProcessing()) {
    return GetModulesTrustPromise::CreateAndReject(
        NS_ERROR_ILLEGAL_DURING_SHUTDOWN, __func__);
  }

  RefPtr<UntrustedModulesProcessor> self(this);

  auto invoker = [self = std::move(self),
                  moduleIdentifiers = std::move(moduleIdents),
                  priority = aPriority]() mutable {
    return self->SendGetModulesTrust(std::move(moduleIdentifiers), priority);
  };

  RefPtr<GetModulesTrustPromise::Private> p(
      new GetModulesTrustPromise::Private(__func__));

  if (!IsReadyForBackgroundProcessing()) {
    p->Reject(NS_ERROR_ILLEGAL_DURING_SHUTDOWN, __func__);
    return p;
  }

  // Send the IPC request via the main thread
  InvokeAsync(GetMainThreadSerialEventTarget(), __func__, std::move(invoker))
      ->Then(
          GetMainThreadSerialEventTarget(), __func__,
          [p, loads = std::move(loadsToProcess)](
              Maybe<ModulesMapResult>&& aResult) mutable {
            ModulesMapResultWithLoads result(std::move(aResult),
                                             std::move(loads));
            p->Resolve(Some(ModulesMapResultWithLoads(std::move(result))),
                       __func__);
          },
          [p](ipc::ResponseRejectReason aReason) {
            p->Reject(NS_ERROR_FAILURE, __func__);
          });

  return p;
}

void UntrustedModulesProcessor::CompleteProcessing(
    UntrustedModulesProcessor::ModulesMapResultWithLoads&& aModulesAndLoads) {
  MOZ_ASSERT(!XRE_IsParentProcess());
  AssertRunningOnLazyIdleThread();

  if (!IsReadyForBackgroundProcessing()) {
    return;
  }

  if (aModulesAndLoads.mModMapResult.isNothing()) {
    // No untrusted modules in this batch, nothing to save.
    return;
  }

  // This map only contains information about modules deemed to be untrusted,
  // plus xul.dll. Any module referenced by load requests that is *not* in the
  // map is deemed to be trusted.
  ModulesMap& modules = aModulesAndLoads.mModMapResult.ref().mModules;
  const uint32_t& trustTestFailures =
      aModulesAndLoads.mModMapResult.ref().mTrustTestFailures;
  UnprocessedModuleLoads& loads = aModulesAndLoads.mLoads;

  if (modules.IsEmpty() && !trustTestFailures) {
    // No data, nothing to save.
    return;
  }

  if (!IsReadyForBackgroundProcessing()) {
    return;
  }

  Telemetry::BatchProcessedStackGenerator stackProcessor;

  Maybe<double> maybeXulLoadDuration;
  Vector<Telemetry::ProcessedStack> processedStacks;
  UntrustedModuleLoadingEvents processedEvents;
  uint32_t sanitizationFailures = 0;

  if (!modules.IsEmpty()) {
    for (UnprocessedModuleLoadInfoContainer* container : loads) {
      glue::EnhancedModuleLoadInfo& item = container->mInfo;
      if (!IsReadyForBackgroundProcessing()) {
        return;
      }

      RefPtr<ModuleRecord> module(GetModuleRecord(modules, item));
      if (!module) {
        // If module is null then |item| is trusted
        continue;
      }

      if (!IsReadyForBackgroundProcessing()) {
        return;
      }

      glue::EnhancedModuleLoadInfo::BacktraceType backtrace =
          std::move(item.mNtLoadInfo.mBacktrace);
      ProcessedModuleLoadEvent event(std::move(item), std::move(module));

      if (!IsReadyForBackgroundProcessing()) {
        return;
      }

      if (!event) {
        // We don't have a sanitized DLL path, so we cannot include this event
        // for privacy reasons.
        ++sanitizationFailures;
        continue;
      }

      if (!IsReadyForBackgroundProcessing()) {
        return;
      }

      if (event.IsXULLoad()) {
        maybeXulLoadDuration = event.mLoadDurationMS;
        // We saved the XUL load duration, but it is still trusted, so we
        // continue.
        continue;
      }

      if (!IsReadyForBackgroundProcessing()) {
        return;
      }

      Telemetry::ProcessedStack processedStack =
          stackProcessor.GetStackAndModules(backtrace);

      (void)processedStacks.emplaceBack(std::move(processedStack));
      processedEvents.insertBack(
          new ProcessedModuleLoadEventContainer(std::move(event)));
    }
  }

  if (processedStacks.empty() && processedEvents.isEmpty() &&
      !sanitizationFailures && !trustTestFailures) {
    // Nothing to save
    return;
  }

  if (!IsReadyForBackgroundProcessing()) {
    return;
  }

  mProcessedModuleLoads.AddNewLoads(modules, std::move(processedEvents),
                                    std::move(processedStacks));
  if (maybeXulLoadDuration) {
    MOZ_ASSERT(!mProcessedModuleLoads.mXULLoadDurationMS);
    mProcessedModuleLoads.mXULLoadDurationMS = maybeXulLoadDuration;
  }

  mProcessedModuleLoads.mSanitizationFailures += sanitizationFailures;
  mProcessedModuleLoads.mTrustTestFailures += trustTestFailures;
}

// The thread priority of this job should match the priority that the child
// process is running with, as specified by |aRunAtNormalPriority|.
RefPtr<ModulesTrustPromise> UntrustedModulesProcessor::GetModulesTrustInternal(
    ModuleIdentifiers&& aModIdents, bool aRunAtNormalPriority) {
  MOZ_ASSERT(XRE_IsParentProcess());
  AssertRunningOnLazyIdleThread();

  if (!IsReadyForBackgroundProcessing()) {
    return ModulesTrustPromise::CreateAndReject(
        NS_ERROR_ILLEGAL_DURING_SHUTDOWN, __func__);
  }

  if (aRunAtNormalPriority) {
    return GetModulesTrustInternal(std::move(aModIdents));
  }

  BackgroundPriorityRegion bgRgn;
  return GetModulesTrustInternal(std::move(aModIdents));
}

// For each module in aModIdents, evaluate its trustworthiness and only send
// ModuleRecords for untrusted modules back to the child process. We also save
// XUL's ModuleRecord so that the child process may report XUL's load time.
RefPtr<ModulesTrustPromise> UntrustedModulesProcessor::GetModulesTrustInternal(
    ModuleIdentifiers&& aModIdents) {
  MOZ_ASSERT(XRE_IsParentProcess());
  AssertRunningOnLazyIdleThread();

  ModulesMapResult result;

  ModulesMap& modMap = result.mModules;
  uint32_t& trustTestFailures = result.mTrustTestFailures;

  ModuleEvaluator modEval;
  MOZ_ASSERT(!!modEval);
  if (!modEval) {
    return ModulesTrustPromise::CreateAndReject(NS_ERROR_FAILURE, __func__);
  }

  for (auto& file : aModIdents) {
    if (!IsReadyForBackgroundProcessing()) {
      return ModulesTrustPromise::CreateAndReject(
          NS_ERROR_ILLEGAL_DURING_SHUTDOWN, __func__);
    }

    // The path, derived from the handle.
    nsAutoString resolvedNtPath;
    if (!ValidateAndResolveModuleFile(file, resolvedNtPath) ||
        resolvedNtPath.IsEmpty()) {
      continue;
    }

    if (!IsReadyForBackgroundProcessing()) {
      return ModulesTrustPromise::CreateAndReject(
          NS_ERROR_ILLEGAL_DURING_SHUTDOWN, __func__);
    }

    RefPtr<ModuleRecord> module(GetOrAddModuleRecord(modEval, resolvedNtPath));
    if (!module) {
      // We failed to obtain trust information.
      ++trustTestFailures;
      continue;
    }

    if (!IsReadyForBackgroundProcessing()) {
      return ModulesTrustPromise::CreateAndReject(
          NS_ERROR_ILLEGAL_DURING_SHUTDOWN, __func__);
    }

    if (module->IsTrusted() && !module->IsXUL()) {
      // If the module is trusted we exclude it from results, unless it's XUL.
      // (We save XUL so that the child process may report XUL's load time)
      continue;
    }

    if (!IsReadyForBackgroundProcessing()) {
      return ModulesTrustPromise::CreateAndReject(
          NS_ERROR_ILLEGAL_DURING_SHUTDOWN, __func__);
    }

    modMap.InsertOrUpdate(resolvedNtPath, std::move(module));
  }

  return ModulesTrustPromise::CreateAndResolve(std::move(result), __func__);
}

}  // namespace mozilla
