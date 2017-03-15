/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: sw=4 ts=4 et :
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/plugins/PluginModuleParent.h"

#include "base/process_util.h"
#include "mozilla/Attributes.h"
#include "mozilla/dom/ContentParent.h"
#include "mozilla/dom/ContentChild.h"
#include "mozilla/dom/PCrashReporterParent.h"
#include "mozilla/ipc/GeckoChildProcessHost.h"
#include "mozilla/ipc/MessageChannel.h"
#include "mozilla/ipc/ProtocolUtils.h"
#include "mozilla/plugins/BrowserStreamParent.h"
#include "mozilla/plugins/PluginAsyncSurrogate.h"
#include "mozilla/plugins/PluginBridge.h"
#include "mozilla/plugins/PluginInstanceParent.h"
#include "mozilla/Preferences.h"
#ifdef MOZ_ENABLE_PROFILER_SPS
#include "mozilla/ProfileGatherer.h"
#endif
#include "mozilla/ProcessHangMonitor.h"
#include "mozilla/Services.h"
#include "mozilla/Telemetry.h"
#include "mozilla/Unused.h"
#include "nsAutoPtr.h"
#include "nsCRT.h"
#include "nsIFile.h"
#include "nsIObserverService.h"
#include "nsIXULRuntime.h"
#include "nsNPAPIPlugin.h"
#include "nsPrintfCString.h"
#include "prsystem.h"
#include "PluginQuirks.h"
#include "GeckoProfiler.h"
#include "nsPluginTags.h"
#include "nsUnicharUtils.h"
#include "mozilla/layers/TextureClientRecycleAllocator.h"

#ifdef XP_WIN
#include "mozilla/plugins/PluginSurfaceParent.h"
#include "mozilla/widget/AudioSession.h"
#include "PluginHangUIParent.h"
#include "PluginUtilsWin.h"
#endif

#ifdef MOZ_ENABLE_PROFILER_SPS
#include "nsIProfiler.h"
#include "nsIProfileSaveEvent.h"
#endif

#ifdef MOZ_WIDGET_GTK
#include <glib.h>
#elif XP_MACOSX
#include "PluginInterposeOSX.h"
#include "PluginUtilsOSX.h"
#endif

using base::KillProcess;

using mozilla::PluginLibrary;
#ifdef MOZ_ENABLE_PROFILER_SPS
using mozilla::ProfileGatherer;
#endif
using mozilla::ipc::MessageChannel;
using mozilla::ipc::GeckoChildProcessHost;
using mozilla::dom::PCrashReporterParent;
using mozilla::dom::CrashReporterParent;

using namespace mozilla;
using namespace mozilla::plugins;
using namespace mozilla::plugins::parent;

#ifdef MOZ_CRASHREPORTER
#include "mozilla/dom/CrashReporterParent.h"

using namespace CrashReporter;
#endif

static const char kContentTimeoutPref[] = "dom.ipc.plugins.contentTimeoutSecs";
static const char kChildTimeoutPref[] = "dom.ipc.plugins.timeoutSecs";
static const char kParentTimeoutPref[] = "dom.ipc.plugins.parentTimeoutSecs";
static const char kLaunchTimeoutPref[] = "dom.ipc.plugins.processLaunchTimeoutSecs";
static const char kAsyncInitPref[] = "dom.ipc.plugins.asyncInit.enabled";
#ifdef XP_WIN
static const char kHangUITimeoutPref[] = "dom.ipc.plugins.hangUITimeoutSecs";
static const char kHangUIMinDisplayPref[] = "dom.ipc.plugins.hangUIMinDisplaySecs";
#define CHILD_TIMEOUT_PREF kHangUITimeoutPref
#else
#define CHILD_TIMEOUT_PREF kChildTimeoutPref
#endif

bool
mozilla::plugins::SetupBridge(uint32_t aPluginId,
                              dom::ContentParent* aContentParent,
                              bool aForceBridgeNow,
                              nsresult* rv,
                              uint32_t* runID)
{
    PROFILER_LABEL_FUNC(js::ProfileEntry::Category::OTHER);
    if (NS_WARN_IF(!rv) || NS_WARN_IF(!runID)) {
        return false;
    }

    PluginModuleChromeParent::ClearInstantiationFlag();
    RefPtr<nsPluginHost> host = nsPluginHost::GetInst();
    RefPtr<nsNPAPIPlugin> plugin;
    *rv = host->GetPluginForContentProcess(aPluginId, getter_AddRefs(plugin));
    if (NS_FAILED(*rv)) {
        return true;
    }
    PluginModuleChromeParent* chromeParent = static_cast<PluginModuleChromeParent*>(plugin->GetLibrary());
    /*
     *  We can't accumulate BLOCKED_ON_PLUGIN_MODULE_INIT_MS until here because
     *  its histogram key is not available until *after* NP_Initialize.
     */
    chromeParent->AccumulateModuleInitBlockedTime();
    *rv = chromeParent->GetRunID(runID);
    if (NS_FAILED(*rv)) {
        return true;
    }
    if (chromeParent->IsStartingAsync()) {
        chromeParent->SetContentParent(aContentParent);
    }
    if (!aForceBridgeNow && chromeParent->IsStartingAsync() &&
        PluginModuleChromeParent::DidInstantiate()) {
        // We'll handle the bridging asynchronously
        return true;
    }
    *rv = PPluginModule::Bridge(aContentParent, chromeParent);
    return true;
}

#ifdef MOZ_CRASHREPORTER_INJECTOR

/**
 * Use for executing CreateToolhelp32Snapshot off main thread
 */
class mozilla::plugins::FinishInjectorInitTask : public mozilla::CancelableRunnable
{
public:
    FinishInjectorInitTask()
        : mMutex("FlashInjectorInitTask::mMutex")
        , mParent(nullptr)
        , mMainThreadMsgLoop(MessageLoop::current())
    {
        MOZ_ASSERT(NS_IsMainThread());
    }

    void Init(PluginModuleChromeParent* aParent)
    {
        MOZ_ASSERT(aParent);
        mParent = aParent;
    }

    void PostToMainThread()
    {
        RefPtr<Runnable> self = this;
        mSnapshot.own(CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0));
        {   // Scope for lock
            mozilla::MutexAutoLock lock(mMutex);
            if (mMainThreadMsgLoop) {
                mMainThreadMsgLoop->PostTask(self.forget());
            }
        }
    }

    NS_IMETHOD Run() override
    {
        mParent->DoInjection(mSnapshot);
        // We don't need to hold this lock during DoInjection, but we do need
        // to obtain it before returning from Run() to ensure that
        // PostToMainThread has completed before we return.
        mozilla::MutexAutoLock lock(mMutex);
        return NS_OK;
    }

    nsresult Cancel() override
    {
        mozilla::MutexAutoLock lock(mMutex);
        mMainThreadMsgLoop = nullptr;
        return NS_OK;
    }

private:
    mozilla::Mutex            mMutex;
    nsAutoHandle              mSnapshot;
    PluginModuleChromeParent* mParent;
    MessageLoop*              mMainThreadMsgLoop;
};

#endif // MOZ_CRASHREPORTER_INJECTOR

namespace {

/**
 * Objects of this class remain linked until either an error occurs in the
 * plugin initialization sequence, or until
 * PluginModuleContentParent::OnLoadPluginResult has completed executing.
 */
class PluginModuleMapping : public PRCList
{
public:
    explicit PluginModuleMapping(uint32_t aPluginId, bool aAllowAsyncInit)
        : mPluginId(aPluginId)
        , mAllowAsyncInit(aAllowAsyncInit)
        , mProcessIdValid(false)
        , mModule(nullptr)
        , mChannelOpened(false)
    {
        MOZ_COUNT_CTOR(PluginModuleMapping);
        PR_INIT_CLIST(this);
        PR_APPEND_LINK(this, &sModuleListHead);
    }

    ~PluginModuleMapping()
    {
        PR_REMOVE_LINK(this);
        MOZ_COUNT_DTOR(PluginModuleMapping);
    }

    bool
    IsChannelOpened() const
    {
        return mChannelOpened;
    }

    void
    SetChannelOpened()
    {
        mChannelOpened = true;
    }

    PluginModuleContentParent*
    GetModule()
    {
        if (!mModule) {
            mModule = new PluginModuleContentParent(mAllowAsyncInit);
        }
        return mModule;
    }

    static PluginModuleMapping*
    AssociateWithProcessId(uint32_t aPluginId, base::ProcessId aProcessId)
    {
        PluginModuleMapping* mapping =
            static_cast<PluginModuleMapping*>(PR_NEXT_LINK(&sModuleListHead));
        while (mapping != &sModuleListHead) {
            if (mapping->mPluginId == aPluginId) {
                mapping->AssociateWithProcessId(aProcessId);
                return mapping;
            }
            mapping = static_cast<PluginModuleMapping*>(PR_NEXT_LINK(mapping));
        }
        return nullptr;
    }

    static PluginModuleMapping*
    Resolve(base::ProcessId aProcessId)
    {
        PluginModuleMapping* mapping = nullptr;

        if (sIsLoadModuleOnStack) {
            // Special case: If loading synchronously, we just need to access
            // the tail entry of the list.
            mapping =
                static_cast<PluginModuleMapping*>(PR_LIST_TAIL(&sModuleListHead));
            MOZ_ASSERT(mapping);
            return mapping;
        }

        mapping =
            static_cast<PluginModuleMapping*>(PR_NEXT_LINK(&sModuleListHead));
        while (mapping != &sModuleListHead) {
            if (mapping->mProcessIdValid && mapping->mProcessId == aProcessId) {
                return mapping;
            }
            mapping = static_cast<PluginModuleMapping*>(PR_NEXT_LINK(mapping));
        }
        return nullptr;
    }

    static PluginModuleMapping*
    FindModuleByPluginId(uint32_t aPluginId)
    {
        PluginModuleMapping* mapping =
            static_cast<PluginModuleMapping*>(PR_NEXT_LINK(&sModuleListHead));
        while (mapping != &sModuleListHead) {
            if (mapping->mPluginId == aPluginId) {
                return mapping;
            }
            mapping = static_cast<PluginModuleMapping*>(PR_NEXT_LINK(mapping));
        }
        return nullptr;
    }

    static bool
    IsLoadModuleOnStack()
    {
        return sIsLoadModuleOnStack;
    }

    class MOZ_RAII NotifyLoadingModule
    {
    public:
        explicit NotifyLoadingModule(MOZ_GUARD_OBJECT_NOTIFIER_ONLY_PARAM)
        {
            MOZ_GUARD_OBJECT_NOTIFIER_INIT;
            PluginModuleMapping::sIsLoadModuleOnStack = true;
        }

        ~NotifyLoadingModule()
        {
            PluginModuleMapping::sIsLoadModuleOnStack = false;
        }

    private:
        MOZ_DECL_USE_GUARD_OBJECT_NOTIFIER
    };

private:
    void
    AssociateWithProcessId(base::ProcessId aProcessId)
    {
        MOZ_ASSERT(!mProcessIdValid);
        mProcessId = aProcessId;
        mProcessIdValid = true;
    }

    uint32_t mPluginId;
    bool mAllowAsyncInit;
    bool mProcessIdValid;
    base::ProcessId mProcessId;
    PluginModuleContentParent* mModule;
    bool mChannelOpened;

    friend class NotifyLoadingModule;

    static PRCList sModuleListHead;
    static bool sIsLoadModuleOnStack;
};

PRCList PluginModuleMapping::sModuleListHead =
    PR_INIT_STATIC_CLIST(&PluginModuleMapping::sModuleListHead);

bool PluginModuleMapping::sIsLoadModuleOnStack = false;

} // namespace

static PluginModuleChromeParent*
PluginModuleChromeParentForId(const uint32_t aPluginId)
{
  MOZ_ASSERT(XRE_IsParentProcess());

  RefPtr<nsPluginHost> host = nsPluginHost::GetInst();
  nsPluginTag* pluginTag = host->PluginWithId(aPluginId);
  if (!pluginTag || !pluginTag->mPlugin) {
    return nullptr;
  }
  RefPtr<nsNPAPIPlugin> plugin = pluginTag->mPlugin;

  return static_cast<PluginModuleChromeParent*>(plugin->GetLibrary());
}

void
mozilla::plugins::TakeFullMinidump(uint32_t aPluginId,
                                   base::ProcessId aContentProcessId,
                                   const nsAString& aBrowserDumpId,
                                   nsString& aDumpId)
{
  PluginModuleChromeParent* chromeParent =
    PluginModuleChromeParentForId(aPluginId);

  if (chromeParent) {
    chromeParent->TakeFullMinidump(aContentProcessId, aBrowserDumpId, aDumpId);
  }
}

void
mozilla::plugins::TerminatePlugin(uint32_t aPluginId,
                                  base::ProcessId aContentProcessId,
                                  const nsCString& aMonitorDescription,
                                  const nsAString& aDumpId)
{
  PluginModuleChromeParent* chromeParent =
    PluginModuleChromeParentForId(aPluginId);

  if (chromeParent) {
    chromeParent->TerminateChildProcess(MessageLoop::current(),
                                        aContentProcessId,
                                        aMonitorDescription,
                                        aDumpId);
  }
}

/* static */ PluginLibrary*
PluginModuleContentParent::LoadModule(uint32_t aPluginId,
                                      nsPluginTag* aPluginTag)
{
    PluginModuleMapping::NotifyLoadingModule loadingModule;
    nsAutoPtr<PluginModuleMapping> mapping(
            new PluginModuleMapping(aPluginId, aPluginTag->mSupportsAsyncInit));

    MOZ_ASSERT(XRE_IsContentProcess());

    /*
     * We send a LoadPlugin message to the chrome process using an intr
     * message. Before it sends its response, it sends a message to create
     * PluginModuleParent instance. That message is handled by
     * PluginModuleContentParent::Initialize, which saves the instance in
     * its module mapping. We fetch it from there after LoadPlugin finishes.
     */
    dom::ContentChild* cp = dom::ContentChild::GetSingleton();
    nsresult rv;
    uint32_t runID;
    TimeStamp sendLoadPluginStart = TimeStamp::Now();
    if (!cp->SendLoadPlugin(aPluginId, &rv, &runID) ||
        NS_FAILED(rv)) {
        return nullptr;
    }
    TimeStamp sendLoadPluginEnd = TimeStamp::Now();

    PluginModuleContentParent* parent = mapping->GetModule();
    MOZ_ASSERT(parent);
    parent->mTimeBlocked += (sendLoadPluginEnd - sendLoadPluginStart);

    if (!mapping->IsChannelOpened()) {
        // mapping is linked into PluginModuleMapping::sModuleListHead and is
        // needed later, so since this function is returning successfully we
        // forget it here.
        mapping.forget();
    }

    parent->mPluginId = aPluginId;
    parent->mRunID = runID;

    return parent;
}

/* static */ void
PluginModuleContentParent::AssociatePluginId(uint32_t aPluginId,
                                             base::ProcessId aOtherPid)
{
    DebugOnly<PluginModuleMapping*> mapping =
        PluginModuleMapping::AssociateWithProcessId(aPluginId, aOtherPid);
    MOZ_ASSERT(mapping);
}

/* static */ PluginModuleContentParent*
PluginModuleContentParent::Initialize(mozilla::ipc::Transport* aTransport,
                                      base::ProcessId aOtherPid)
{
    nsAutoPtr<PluginModuleMapping> moduleMapping(
        PluginModuleMapping::Resolve(aOtherPid));
    MOZ_ASSERT(moduleMapping);
    PluginModuleContentParent* parent = moduleMapping->GetModule();
    MOZ_ASSERT(parent);

    DebugOnly<bool> ok = parent->Open(aTransport, aOtherPid,
                                      XRE_GetIOMessageLoop(),
                                      mozilla::ipc::ParentSide);
    MOZ_ASSERT(ok);

    moduleMapping->SetChannelOpened();

    // Request Windows message deferral behavior on our channel. This
    // applies to the top level and all sub plugin protocols since they
    // all share the same channel.
    parent->GetIPCChannel()->SetChannelFlags(MessageChannel::REQUIRE_DEFERRED_MESSAGE_PROTECTION);

    TimeoutChanged(kContentTimeoutPref, parent);

    // moduleMapping is linked into PluginModuleMapping::sModuleListHead and is
    // needed later, so since this function is returning successfully we
    // forget it here.
    moduleMapping.forget();
    return parent;
}

/* static */ void
PluginModuleContentParent::OnLoadPluginResult(const uint32_t& aPluginId,
                                              const bool& aResult)
{
    nsAutoPtr<PluginModuleMapping> moduleMapping(
        PluginModuleMapping::FindModuleByPluginId(aPluginId));
    MOZ_ASSERT(moduleMapping);
    PluginModuleContentParent* parent = moduleMapping->GetModule();
    MOZ_ASSERT(parent);
    parent->RecvNP_InitializeResult(aResult ? NPERR_NO_ERROR
                                            : NPERR_GENERIC_ERROR);
}

void
PluginModuleChromeParent::SetContentParent(dom::ContentParent* aContentParent)
{
    // mContentParent is to be used ONLY during async plugin init!
    MOZ_ASSERT(aContentParent && mIsStartingAsync);
    mContentParent = aContentParent;
}

bool
PluginModuleChromeParent::SendAssociatePluginId()
{
    MOZ_ASSERT(mContentParent);
    return mContentParent->SendAssociatePluginId(mPluginId, OtherPid());
}

// static
PluginLibrary*
PluginModuleChromeParent::LoadModule(const char* aFilePath, uint32_t aPluginId,
                                     nsPluginTag* aPluginTag)
{
    PLUGIN_LOG_DEBUG_FUNCTION;

    nsAutoPtr<PluginModuleChromeParent> parent(
            new PluginModuleChromeParent(aFilePath, aPluginId,
                                         aPluginTag->mSandboxLevel,
                                         aPluginTag->mSupportsAsyncInit));
    UniquePtr<LaunchCompleteTask> onLaunchedRunnable(new LaunchedTask(parent));
    parent->mSubprocess->SetCallRunnableImmediately(!parent->mIsStartingAsync);
    TimeStamp launchStart = TimeStamp::Now();
    bool launched = parent->mSubprocess->Launch(Move(onLaunchedRunnable),
                                                aPluginTag->mSandboxLevel);
    if (!launched) {
        // We never reached open
        parent->mShutdown = true;
        return nullptr;
    }
    parent->mIsFlashPlugin = aPluginTag->mIsFlashPlugin;
    uint32_t blocklistState;
    nsresult rv = aPluginTag->GetBlocklistState(&blocklistState);
    parent->mIsBlocklisted = NS_FAILED(rv) || blocklistState != 0;
    if (!parent->mIsStartingAsync) {
        int32_t launchTimeoutSecs = Preferences::GetInt(kLaunchTimeoutPref, 0);
        if (!parent->mSubprocess->WaitUntilConnected(launchTimeoutSecs * 1000)) {
            parent->mShutdown = true;
            return nullptr;
        }
    }
    TimeStamp launchEnd = TimeStamp::Now();
    parent->mTimeBlocked = (launchEnd - launchStart);
    return parent.forget();
}

void
PluginModuleChromeParent::OnProcessLaunched(const bool aSucceeded)
{
    if (!aSucceeded) {
        mShutdown = true;
        OnInitFailure();
        return;
    }
    // We may have already been initialized by another call that was waiting
    // for process connect. If so, this function doesn't need to run.
    if (mAsyncInitRv != NS_ERROR_NOT_INITIALIZED || mShutdown) {
        return;
    }

    Open(mSubprocess->GetChannel(),
         base::GetProcId(mSubprocess->GetChildProcessHandle()));

    // Request Windows message deferral behavior on our channel. This
    // applies to the top level and all sub plugin protocols since they
    // all share the same channel.
    GetIPCChannel()->SetChannelFlags(MessageChannel::REQUIRE_DEFERRED_MESSAGE_PROTECTION);

    TimeoutChanged(CHILD_TIMEOUT_PREF, this);

    Preferences::RegisterCallback(TimeoutChanged, kChildTimeoutPref, this);
    Preferences::RegisterCallback(TimeoutChanged, kParentTimeoutPref, this);
#ifdef XP_WIN
    Preferences::RegisterCallback(TimeoutChanged, kHangUITimeoutPref, this);
    Preferences::RegisterCallback(TimeoutChanged, kHangUIMinDisplayPref, this);
#endif

    RegisterSettingsCallbacks();

#ifdef MOZ_CRASHREPORTER
    // If this fails, we're having IPC troubles, and we're doomed anyways.
    if (!CrashReporterParent::CreateCrashReporter(this)) {
        mShutdown = true;
        Close();
        OnInitFailure();
        return;
    }
    CrashReporterParent* crashReporter = CrashReporter();
    if (crashReporter) {
        crashReporter->AnnotateCrashReport(NS_LITERAL_CSTRING("AsyncPluginInit"),
                                           mIsStartingAsync ?
                                               NS_LITERAL_CSTRING("1") :
                                               NS_LITERAL_CSTRING("0"));
    }
#ifdef XP_WIN
    { // Scope for lock
        mozilla::MutexAutoLock lock(mCrashReporterMutex);
        mCrashReporter = CrashReporter();
    }
#endif
#endif

#if defined(XP_WIN) && defined(_X86_)
    // Protected mode only applies to Windows and only to x86.
    if (!mIsBlocklisted && mIsFlashPlugin &&
        (Preferences::GetBool("dom.ipc.plugins.flash.disable-protected-mode", false) ||
         mSandboxLevel >= 2)) {
        SendDisableFlashProtectedMode();
    }
#endif

    if (mInitOnAsyncConnect) {
        mInitOnAsyncConnect = false;
#if defined(XP_WIN)
        mAsyncInitRv = NP_GetEntryPoints(mNPPIface,
                                         &mAsyncInitError);
        if (NS_SUCCEEDED(mAsyncInitRv))
#endif
        {
#if defined(XP_UNIX) && !defined(XP_MACOSX) && !defined(MOZ_WIDGET_GONK)
            mAsyncInitRv = NP_Initialize(mNPNIface,
                                         mNPPIface,
                                         &mAsyncInitError);
#else
            mAsyncInitRv = NP_Initialize(mNPNIface,
                                         &mAsyncInitError);
#endif
        }

#if defined(XP_MACOSX)
        if (NS_SUCCEEDED(mAsyncInitRv)) {
            mAsyncInitRv = NP_GetEntryPoints(mNPPIface,
                                             &mAsyncInitError);
        }
#endif
    }

#ifdef MOZ_ENABLE_PROFILER_SPS
    nsCOMPtr<nsIProfiler> profiler(do_GetService("@mozilla.org/tools/profiler;1"));
    bool profilerActive = false;
    DebugOnly<nsresult> rv = profiler->IsActive(&profilerActive);
    MOZ_ASSERT(NS_SUCCEEDED(rv));
    if (profilerActive) {
        nsCOMPtr<nsIProfilerStartParams> currentProfilerParams;
        rv = profiler->GetStartParams(getter_AddRefs(currentProfilerParams));
        MOZ_ASSERT(NS_SUCCEEDED(rv));

        nsCOMPtr<nsISupports> gatherer;
        rv = profiler->GetProfileGatherer(getter_AddRefs(gatherer));
        MOZ_ASSERT(NS_SUCCEEDED(rv));
        mGatherer = static_cast<ProfileGatherer*>(gatherer.get());

        StartProfiler(currentProfilerParams);
    }
#endif
}

bool
PluginModuleChromeParent::WaitForIPCConnection()
{
    PluginProcessParent* process = Process();
    MOZ_ASSERT(process);
    process->SetCallRunnableImmediately(true);
    if (!process->WaitUntilConnected()) {
        return false;
    }
    return true;
}

PluginModuleParent::PluginModuleParent(bool aIsChrome, bool aAllowAsyncInit)
    : mQuirks(QUIRKS_NOT_INITIALIZED)
    , mIsChrome(aIsChrome)
    , mShutdown(false)
    , mHadLocalInstance(false)
    , mClearSiteDataSupported(false)
    , mGetSitesWithDataSupported(false)
    , mNPNIface(nullptr)
    , mNPPIface(nullptr)
    , mPlugin(nullptr)
    , mTaskFactory(this)
    , mSandboxLevel(0)
    , mIsFlashPlugin(false)
    , mIsStartingAsync(false)
    , mNPInitialized(false)
    , mIsNPShutdownPending(false)
    , mAsyncNewRv(NS_ERROR_NOT_INITIALIZED)
{
#if defined(MOZ_CRASHREPORTER)
    CrashReporter::AnnotateCrashReport(NS_LITERAL_CSTRING("AsyncPluginInit"),
                                       mIsStartingAsync ?
                                           NS_LITERAL_CSTRING("1") :
                                           NS_LITERAL_CSTRING("0"));
#endif
}

PluginModuleParent::~PluginModuleParent()
{
    if (!OkToCleanup()) {
        NS_RUNTIMEABORT("unsafe destruction");
    }

    if (!mShutdown) {
        NS_WARNING("Plugin host deleted the module without shutting down.");
        NPError err;
        NP_Shutdown(&err);
    }
}

PluginModuleContentParent::PluginModuleContentParent(bool aAllowAsyncInit)
    : PluginModuleParent(false, aAllowAsyncInit)
{
    Preferences::RegisterCallback(TimeoutChanged, kContentTimeoutPref, this);
}

PluginModuleContentParent::~PluginModuleContentParent()
{
    Preferences::UnregisterCallback(TimeoutChanged, kContentTimeoutPref, this);
}

bool PluginModuleChromeParent::sInstantiated = false;

PluginModuleChromeParent::PluginModuleChromeParent(const char* aFilePath,
                                                   uint32_t aPluginId,
                                                   int32_t aSandboxLevel,
                                                   bool aAllowAsyncInit)
    : PluginModuleParent(true, aAllowAsyncInit)
    , mSubprocess(new PluginProcessParent(aFilePath))
    , mPluginId(aPluginId)
    , mChromeTaskFactory(this)
    , mHangAnnotationFlags(0)
#ifdef XP_WIN
    , mPluginCpuUsageOnHang()
    , mHangUIParent(nullptr)
    , mHangUIEnabled(true)
    , mIsTimerReset(true)
#ifdef MOZ_CRASHREPORTER
    , mCrashReporterMutex("PluginModuleChromeParent::mCrashReporterMutex")
    , mCrashReporter(nullptr)
#endif
#endif
#ifdef MOZ_CRASHREPORTER_INJECTOR
    , mFlashProcess1(0)
    , mFlashProcess2(0)
    , mFinishInitTask(nullptr)
#endif
    , mInitOnAsyncConnect(false)
    , mAsyncInitRv(NS_ERROR_NOT_INITIALIZED)
    , mAsyncInitError(NPERR_NO_ERROR)
    , mContentParent(nullptr)
{
    NS_ASSERTION(mSubprocess, "Out of memory!");
    sInstantiated = true;
    mSandboxLevel = aSandboxLevel;
    mRunID = GeckoChildProcessHost::GetUniqueID();

#ifdef MOZ_ENABLE_PROFILER_SPS
    InitPluginProfiling();
#endif

    mozilla::HangMonitor::RegisterAnnotator(*this);
}

PluginModuleChromeParent::~PluginModuleChromeParent()
{
    if (!OkToCleanup()) {
        NS_RUNTIMEABORT("unsafe destruction");
    }

#ifdef MOZ_ENABLE_PROFILER_SPS
    ShutdownPluginProfiling();
#endif

#ifdef XP_WIN
    // If we registered for audio notifications, stop.
    mozilla::plugins::PluginUtilsWin::RegisterForAudioDeviceChanges(this,
                                                                    false);
#endif

    if (!mShutdown) {
        NS_WARNING("Plugin host deleted the module without shutting down.");
        NPError err;
        NP_Shutdown(&err);
    }

    NS_ASSERTION(mShutdown, "NP_Shutdown didn't");

    if (mSubprocess) {
        mSubprocess->Delete();
        mSubprocess = nullptr;
    }

#ifdef MOZ_CRASHREPORTER_INJECTOR
    if (mFlashProcess1)
        UnregisterInjectorCallback(mFlashProcess1);
    if (mFlashProcess2)
        UnregisterInjectorCallback(mFlashProcess2);
    if (mFinishInitTask) {
        // mFinishInitTask will be deleted by the main thread message_loop
        mFinishInitTask->Cancel();
    }
#endif

    UnregisterSettingsCallbacks();

    Preferences::UnregisterCallback(TimeoutChanged, kChildTimeoutPref, this);
    Preferences::UnregisterCallback(TimeoutChanged, kParentTimeoutPref, this);
#ifdef XP_WIN
    Preferences::UnregisterCallback(TimeoutChanged, kHangUITimeoutPref, this);
    Preferences::UnregisterCallback(TimeoutChanged, kHangUIMinDisplayPref, this);

    if (mHangUIParent) {
        delete mHangUIParent;
        mHangUIParent = nullptr;
    }
#endif

    mozilla::HangMonitor::UnregisterAnnotator(*this);
}

#ifdef MOZ_CRASHREPORTER
void
PluginModuleChromeParent::WriteExtraDataForMinidump(AnnotationTable& notes)
{
#ifdef XP_WIN
    // mCrashReporterMutex is already held by the caller
    mCrashReporterMutex.AssertCurrentThreadOwns();
#endif
    typedef nsDependentCString CS;

    // Get the plugin filename, try to get just the file leafname
    const std::string& pluginFile = mSubprocess->GetPluginFilePath();
    size_t filePos = pluginFile.rfind(FILE_PATH_SEPARATOR);
    if (filePos == std::string::npos)
        filePos = 0;
    else
        filePos++;
    notes.Put(NS_LITERAL_CSTRING("PluginFilename"), CS(pluginFile.substr(filePos).c_str()));

    notes.Put(NS_LITERAL_CSTRING("PluginName"), mPluginName);
    notes.Put(NS_LITERAL_CSTRING("PluginVersion"), mPluginVersion);

    CrashReporterParent* crashReporter = CrashReporter();
    if (crashReporter) {
#ifdef XP_WIN
        if (mPluginCpuUsageOnHang.Length() > 0) {
            notes.Put(NS_LITERAL_CSTRING("NumberOfProcessors"),
                      nsPrintfCString("%d", PR_GetNumberOfProcessors()));

            nsCString cpuUsageStr;
            cpuUsageStr.AppendFloat(std::ceil(mPluginCpuUsageOnHang[0] * 100) / 100);
            notes.Put(NS_LITERAL_CSTRING("PluginCpuUsage"), cpuUsageStr);

#ifdef MOZ_CRASHREPORTER_INJECTOR
            for (uint32_t i=1; i<mPluginCpuUsageOnHang.Length(); ++i) {
                nsCString tempStr;
                tempStr.AppendFloat(std::ceil(mPluginCpuUsageOnHang[i] * 100) / 100);
                notes.Put(nsPrintfCString("CpuUsageFlashProcess%d", i), tempStr);
            }
#endif
        }
#endif
    }
}
#endif  // MOZ_CRASHREPORTER

void
PluginModuleParent::SetChildTimeout(const int32_t aChildTimeout)
{
    int32_t timeoutMs = (aChildTimeout > 0) ? (1000 * aChildTimeout) :
                      MessageChannel::kNoTimeout;
    SetReplyTimeoutMs(timeoutMs);
}

void
PluginModuleParent::TimeoutChanged(const char* aPref, void* aModule)
{
    PluginModuleParent* module = static_cast<PluginModuleParent*>(aModule);

    NS_ASSERTION(NS_IsMainThread(), "Wrong thread!");
#ifndef XP_WIN
    if (!strcmp(aPref, kChildTimeoutPref)) {
      MOZ_ASSERT(module->IsChrome());
      // The timeout value used by the parent for children
      int32_t timeoutSecs = Preferences::GetInt(kChildTimeoutPref, 0);
      module->SetChildTimeout(timeoutSecs);
#else
    if (!strcmp(aPref, kChildTimeoutPref) ||
        !strcmp(aPref, kHangUIMinDisplayPref) ||
        !strcmp(aPref, kHangUITimeoutPref)) {
      MOZ_ASSERT(module->IsChrome());
      static_cast<PluginModuleChromeParent*>(module)->EvaluateHangUIState(true);
#endif // XP_WIN
    } else if (!strcmp(aPref, kParentTimeoutPref)) {
      // The timeout value used by the child for its parent
      MOZ_ASSERT(module->IsChrome());
      int32_t timeoutSecs = Preferences::GetInt(kParentTimeoutPref, 0);
      Unused << static_cast<PluginModuleChromeParent*>(module)->SendSetParentHangTimeout(timeoutSecs);
    } else if (!strcmp(aPref, kContentTimeoutPref)) {
      MOZ_ASSERT(!module->IsChrome());
      int32_t timeoutSecs = Preferences::GetInt(kContentTimeoutPref, 0);
      module->SetChildTimeout(timeoutSecs);
    }
}

void
PluginModuleChromeParent::CleanupFromTimeout(const bool aFromHangUI)
{
    if (mShutdown) {
      return;
    }

    if (!OkToCleanup()) {
        // there's still plugin code on the C++ stack, try again
        MessageLoop::current()->PostDelayedTask(
            mChromeTaskFactory.NewRunnableMethod(
                &PluginModuleChromeParent::CleanupFromTimeout, aFromHangUI), 10);
        return;
    }

    /* If the plugin container was terminated by the Plugin Hang UI, 
       then either the I/O thread detects a channel error, or the 
       main thread must set the error (whomever gets there first).
       OTOH, if we terminate and return false from 
       ShouldContinueFromReplyTimeout, then the channel state has 
       already been set to ChannelTimeout and we should call the 
       regular Close function. */
    if (aFromHangUI) {
        GetIPCChannel()->CloseWithError();
    } else {
        Close();
    }
}

#ifdef XP_WIN
namespace {

uint64_t
FileTimeToUTC(const FILETIME& ftime) 
{
  ULARGE_INTEGER li;
  li.LowPart = ftime.dwLowDateTime;
  li.HighPart = ftime.dwHighDateTime;
  return li.QuadPart;
}

struct CpuUsageSamples
{
  uint64_t sampleTimes[2];
  uint64_t cpuTimes[2];
};

bool 
GetProcessCpuUsage(const InfallibleTArray<base::ProcessHandle>& processHandles, InfallibleTArray<float>& cpuUsage)
{
  InfallibleTArray<CpuUsageSamples> samples(processHandles.Length());
  FILETIME creationTime, exitTime, kernelTime, userTime, currentTime;
  BOOL res;

  for (uint32_t i = 0; i < processHandles.Length(); ++i) {
    ::GetSystemTimeAsFileTime(&currentTime);
    res = ::GetProcessTimes(processHandles[i], &creationTime, &exitTime, &kernelTime, &userTime);
    if (!res) {
      NS_WARNING("failed to get process times");
      return false;
    }
  
    CpuUsageSamples s;
    s.sampleTimes[0] = FileTimeToUTC(currentTime);
    s.cpuTimes[0]    = FileTimeToUTC(kernelTime) + FileTimeToUTC(userTime);
    samples.AppendElement(s);
  }

  // we already hung for a while, a little bit longer won't matter
  ::Sleep(50);

  const int32_t numberOfProcessors = PR_GetNumberOfProcessors();

  for (uint32_t i = 0; i < processHandles.Length(); ++i) {
    ::GetSystemTimeAsFileTime(&currentTime);
    res = ::GetProcessTimes(processHandles[i], &creationTime, &exitTime, &kernelTime, &userTime);
    if (!res) {
      NS_WARNING("failed to get process times");
      return false;
    }

    samples[i].sampleTimes[1] = FileTimeToUTC(currentTime);
    samples[i].cpuTimes[1]    = FileTimeToUTC(kernelTime) + FileTimeToUTC(userTime);    

    const uint64_t deltaSampleTime = samples[i].sampleTimes[1] - samples[i].sampleTimes[0];
    const uint64_t deltaCpuTime    = samples[i].cpuTimes[1]    - samples[i].cpuTimes[0];
    const float usage = 100.f * (float(deltaCpuTime) / deltaSampleTime) / numberOfProcessors;
    cpuUsage.AppendElement(usage);
  }

  return true;
}

} // namespace

#endif // #ifdef XP_WIN

/**
 * This function converts the topmost routing id on the call stack (as recorded
 * by the MessageChannel) into a pointer to a IProtocol object.
 */
mozilla::ipc::IProtocol*
PluginModuleChromeParent::GetInvokingProtocol()
{
    int32_t routingId = GetIPCChannel()->GetTopmostMessageRoutingId();
    // Nothing being routed. No protocol. Just return nullptr.
    if (routingId == MSG_ROUTING_NONE) {
        return nullptr;
    }
    // If routingId is MSG_ROUTING_CONTROL then we're dealing with control
    // messages that were initiated by the topmost managing protocol, ie. this.
    if (routingId == MSG_ROUTING_CONTROL) {
        return this;
    }
    // Otherwise we can look up the protocol object by the routing id.
    mozilla::ipc::IProtocol* protocol = Lookup(routingId);
    return protocol;
}

/**
 * This function examines the IProtocol object parameter and converts it into
 * the PluginInstanceParent object that is associated with that protocol, if
 * any. Since PluginInstanceParent manages subprotocols, this function needs
 * to determine whether |aProtocol| is a subprotocol, and if so it needs to
 * obtain the protocol's manager.
 *
 * This function needs to be updated if the subprotocols are modified in
 * PPluginInstance.ipdl.
 */
PluginInstanceParent*
PluginModuleChromeParent::GetManagingInstance(mozilla::ipc::IProtocol* aProtocol)
{
    MOZ_ASSERT(aProtocol);
    mozilla::ipc::IProtocol* listener = aProtocol;
    switch (listener->GetProtocolTypeId()) {
        case PPluginInstanceMsgStart:
            // In this case, aProtocol is the instance itself. Just cast it.
            return static_cast<PluginInstanceParent*>(aProtocol);
        case PPluginBackgroundDestroyerMsgStart: {
            PPluginBackgroundDestroyerParent* actor =
                static_cast<PPluginBackgroundDestroyerParent*>(aProtocol);
            return static_cast<PluginInstanceParent*>(actor->Manager());
        }
        case PPluginScriptableObjectMsgStart: {
            PPluginScriptableObjectParent* actor =
                static_cast<PPluginScriptableObjectParent*>(aProtocol);
            return static_cast<PluginInstanceParent*>(actor->Manager());
        }
        case PBrowserStreamMsgStart: {
            PBrowserStreamParent* actor =
                static_cast<PBrowserStreamParent*>(aProtocol);
            return static_cast<PluginInstanceParent*>(actor->Manager());
        }
        case PPluginStreamMsgStart: {
            PPluginStreamParent* actor =
                static_cast<PPluginStreamParent*>(aProtocol);
            return static_cast<PluginInstanceParent*>(actor->Manager());
        }
        case PStreamNotifyMsgStart: {
            PStreamNotifyParent* actor =
                static_cast<PStreamNotifyParent*>(aProtocol);
            return static_cast<PluginInstanceParent*>(actor->Manager());
        }
#ifdef XP_WIN
        case PPluginSurfaceMsgStart: {
            PPluginSurfaceParent* actor =
                static_cast<PPluginSurfaceParent*>(aProtocol);
            return static_cast<PluginInstanceParent*>(actor->Manager());
        }
#endif
        default:
            return nullptr;
    }
}

void
PluginModuleChromeParent::EnteredCxxStack()
{
    mHangAnnotationFlags |= kInPluginCall;
}

void
PluginModuleChromeParent::ExitedCxxStack()
{
    mHangAnnotationFlags = 0;
#ifdef XP_WIN
    FinishHangUI();
#endif
}

/**
 * This function is always called by the HangMonitor thread.
 */
void
PluginModuleChromeParent::AnnotateHang(mozilla::HangMonitor::HangAnnotations& aAnnotations)
{
    uint32_t flags = mHangAnnotationFlags;
    if (flags) {
        /* We don't actually annotate anything specifically for kInPluginCall;
           we use it to determine whether to annotate other things. It will
           be pretty obvious from the ChromeHang stack that we're in a plugin
           call when the hang occurred. */
        if (flags & kHangUIShown) {
            aAnnotations.AddAnnotation(NS_LITERAL_STRING("HangUIShown"),
                                       true);
        }
        if (flags & kHangUIContinued) {
            aAnnotations.AddAnnotation(NS_LITERAL_STRING("HangUIContinued"),
                                       true);
        }
        if (flags & kHangUIDontShow) {
            aAnnotations.AddAnnotation(NS_LITERAL_STRING("HangUIDontShow"),
                                       true);
        }
        aAnnotations.AddAnnotation(NS_LITERAL_STRING("pluginName"), mPluginName);
        aAnnotations.AddAnnotation(NS_LITERAL_STRING("pluginVersion"),
                                   mPluginVersion);
    }
}

#ifdef MOZ_CRASHREPORTER
static bool
CreatePluginMinidump(base::ProcessId processId, ThreadId childThread,
                     nsIFile* parentMinidump, const nsACString& name)
{
  mozilla::ipc::ScopedProcessHandle handle;
  if (processId == 0 ||
      !base::OpenPrivilegedProcessHandle(processId, &handle.rwget())) {
    return false;
  }
  return CreateAdditionalChildMinidump(handle, 0, parentMinidump, name);
}
#endif

bool
PluginModuleChromeParent::ShouldContinueFromReplyTimeout()
{
    if (mIsFlashPlugin) {
        MessageLoop::current()->PostTask(
            mTaskFactory.NewRunnableMethod(
                &PluginModuleChromeParent::NotifyFlashHang));
    }

#ifdef XP_WIN
    if (LaunchHangUI()) {
        return true;
    }
    // If LaunchHangUI returned false then we should proceed with the 
    // original plugin hang behaviour and kill the plugin container.
    FinishHangUI();
#endif // XP_WIN
    TerminateChildProcess(MessageLoop::current(),
                          mozilla::ipc::kInvalidProcessId,
                          NS_LITERAL_CSTRING("ModalHangUI"),
                          EmptyString());
    GetIPCChannel()->CloseWithTimeout();
    return false;
}

bool
PluginModuleContentParent::ShouldContinueFromReplyTimeout()
{
    RefPtr<ProcessHangMonitor> monitor = ProcessHangMonitor::Get();
    if (!monitor) {
        return true;
    }
    monitor->NotifyPluginHang(mPluginId);
    return true;
}

void
PluginModuleContentParent::OnExitedSyncSend()
{
    ProcessHangMonitor::ClearHang();
}

void
PluginModuleChromeParent::TakeFullMinidump(base::ProcessId aContentPid,
                                           const nsAString& aBrowserDumpId,
                                           nsString& aDumpId)
{
#ifdef MOZ_CRASHREPORTER
#ifdef XP_WIN
    mozilla::MutexAutoLock lock(mCrashReporterMutex);
#endif // XP_WIN

    CrashReporterParent* crashReporter = CrashReporter();
    if (!crashReporter) {
        return;
    }

    bool reportsReady = false;

    // Check to see if we already have a browser dump id - with e10s plugin
    // hangs we take this earlier (see ProcessHangMonitor) from a background
    // thread. We do this before we message the main thread about the hang
    // since the posted message will trash our browser stack state.
    bool exists;
    nsCOMPtr<nsIFile> browserDumpFile;
    if (!aBrowserDumpId.IsEmpty() &&
        CrashReporter::GetMinidumpForID(aBrowserDumpId, getter_AddRefs(browserDumpFile)) &&
        browserDumpFile &&
        NS_SUCCEEDED(browserDumpFile->Exists(&exists)) && exists)
    {
        // We have a single browser report, generate a new plugin process parent
        // report and pair it up with the browser report handed in.
        reportsReady = crashReporter->GenerateMinidumpAndPair(this, browserDumpFile,
                                                              NS_LITERAL_CSTRING("browser"));
        if (!reportsReady) {
          browserDumpFile = nullptr;
          CrashReporter::DeleteMinidumpFilesForID(aBrowserDumpId);
        }
    }

    // Generate crash report including plugin and browser process minidumps.
    // The plugin process is the parent report with additional dumps including
    // the browser process, content process when running under e10s, and
    // various flash subprocesses if we're the flash module.
    if (!reportsReady) {
        reportsReady = crashReporter->GeneratePairedMinidump(this);
    }

    if (reportsReady) {
        // Important to set this here, it tells the ActorDestroy handler
        // that we have an existing crash report that needs to be finalized.
        mPluginDumpID = crashReporter->ChildDumpID();
        aDumpId = mPluginDumpID;
        PLUGIN_LOG_DEBUG(
                ("generated paired browser/plugin minidumps: %s)",
                 NS_ConvertUTF16toUTF8(mPluginDumpID).get()));
        nsAutoCString additionalDumps("browser");
        nsCOMPtr<nsIFile> pluginDumpFile;
        if (GetMinidumpForID(mPluginDumpID, getter_AddRefs(pluginDumpFile)) &&
            pluginDumpFile) {
#ifdef MOZ_CRASHREPORTER_INJECTOR
            // If we have handles to the flash sandbox processes on Windows,
            // include those minidumps as well.
            if (CreatePluginMinidump(mFlashProcess1, 0, pluginDumpFile,
                                     NS_LITERAL_CSTRING("flash1"))) {
                additionalDumps.AppendLiteral(",flash1");
            }
            if (CreatePluginMinidump(mFlashProcess2, 0, pluginDumpFile,
                                     NS_LITERAL_CSTRING("flash2"))) {
                additionalDumps.AppendLiteral(",flash2");
            }
#endif // MOZ_CRASHREPORTER_INJECTOR
            if (aContentPid != mozilla::ipc::kInvalidProcessId) {
                // Include the content process minidump
                if (CreatePluginMinidump(aContentPid, 0,
                                         pluginDumpFile,
                                         NS_LITERAL_CSTRING("content"))) {
                    additionalDumps.AppendLiteral(",content");
                }
            }
        }
        crashReporter->AnnotateCrashReport(
            NS_LITERAL_CSTRING("additional_minidumps"),
            additionalDumps);
    } else {
        NS_WARNING("failed to capture paired minidumps from hang");
    }
#endif // MOZ_CRASHREPORTER
}

void
PluginModuleChromeParent::TerminateChildProcess(MessageLoop* aMsgLoop,
                                                base::ProcessId aContentPid,
                                                const nsCString& aMonitorDescription,
                                                const nsAString& aDumpId)
{
#ifdef MOZ_CRASHREPORTER
    // Start by taking a full minidump if necessary, this is done early
    // because it also needs to lock the mCrashReporterMutex and Mutex doesn't
    // support recrusive locking.
    nsAutoString dumpId;
    if (aDumpId.IsEmpty()) {
        TakeFullMinidump(aContentPid, EmptyString(), dumpId);
    }

#ifdef XP_WIN
    mozilla::MutexAutoLock lock(mCrashReporterMutex);
    CrashReporterParent* crashReporter = mCrashReporter;
    if (!crashReporter) {
        // If mCrashReporter is null then the hang has ended, the plugin module
        // is shutting down. There's nothing to do here.
        return;
    }
#else
    CrashReporterParent* crashReporter = CrashReporter();
#endif // XP_WIN
    crashReporter->AnnotateCrashReport(NS_LITERAL_CSTRING("PluginHang"),
                                       NS_LITERAL_CSTRING("1"));
    crashReporter->AnnotateCrashReport(NS_LITERAL_CSTRING("HangMonitorDescription"),
                                       aMonitorDescription);
#ifdef XP_WIN
    if (mHangUIParent) {
        unsigned int hangUIDuration = mHangUIParent->LastShowDurationMs();
        if (hangUIDuration) {
            nsPrintfCString strHangUIDuration("%u", hangUIDuration);
            crashReporter->AnnotateCrashReport(
                    NS_LITERAL_CSTRING("PluginHangUIDuration"),
                    strHangUIDuration);
        }
    }
#endif // XP_WIN
#endif // MOZ_CRASHREPORTER

    mozilla::ipc::ScopedProcessHandle geckoChildProcess;
    bool childOpened = base::OpenProcessHandle(OtherPid(),
                                               &geckoChildProcess.rwget());

#ifdef XP_WIN
    // collect cpu usage for plugin processes

    InfallibleTArray<base::ProcessHandle> processHandles;

    if (childOpened) {
        processHandles.AppendElement(geckoChildProcess);
    }

#ifdef MOZ_CRASHREPORTER_INJECTOR
    mozilla::ipc::ScopedProcessHandle flashBrokerProcess;
    if (mFlashProcess1 &&
        base::OpenProcessHandle(mFlashProcess1, &flashBrokerProcess.rwget())) {
        processHandles.AppendElement(flashBrokerProcess);
    }
    mozilla::ipc::ScopedProcessHandle flashSandboxProcess;
    if (mFlashProcess2 &&
        base::OpenProcessHandle(mFlashProcess2, &flashSandboxProcess.rwget())) {
        processHandles.AppendElement(flashSandboxProcess);
    }
#endif

    if (!GetProcessCpuUsage(processHandles, mPluginCpuUsageOnHang)) {
      mPluginCpuUsageOnHang.Clear();
    }
#endif

    // this must run before the error notification from the channel,
    // or not at all
    bool isFromHangUI = aMsgLoop != MessageLoop::current();
    aMsgLoop->PostTask(
        mChromeTaskFactory.NewRunnableMethod(
            &PluginModuleChromeParent::CleanupFromTimeout, isFromHangUI));

    if (!childOpened || !KillProcess(geckoChildProcess, 1, false)) {
        NS_WARNING("failed to kill subprocess!");
    }
}

bool
PluginModuleParent::GetPluginDetails()
{
    RefPtr<nsPluginHost> host = nsPluginHost::GetInst();
    if (!host) {
        return false;
    }
    nsPluginTag* pluginTag = host->TagForPlugin(mPlugin);
    if (!pluginTag) {
        return false;
    }
    mPluginName = pluginTag->Name();
    mPluginVersion = pluginTag->Version();
    mPluginFilename = pluginTag->FileName();
    mIsFlashPlugin = pluginTag->mIsFlashPlugin;
    mSandboxLevel = pluginTag->mSandboxLevel;
    return true;
}

void
PluginModuleParent::InitQuirksModes(const nsCString& aMimeType)
{
    if (mQuirks != QUIRKS_NOT_INITIALIZED) {
      return;
    }

    mQuirks = GetQuirksFromMimeTypeAndFilename(aMimeType, mPluginFilename);
}

#ifdef XP_WIN
void
PluginModuleChromeParent::EvaluateHangUIState(const bool aReset)
{
    int32_t minDispSecs = Preferences::GetInt(kHangUIMinDisplayPref, 10);
    int32_t autoStopSecs = Preferences::GetInt(kChildTimeoutPref, 0);
    int32_t timeoutSecs = 0;
    if (autoStopSecs > 0 && autoStopSecs < minDispSecs) {
        /* If we're going to automatically terminate the plugin within a 
           time frame shorter than minDispSecs, there's no point in 
           showing the hang UI; it would just flash briefly on the screen. */
        mHangUIEnabled = false;
    } else {
        timeoutSecs = Preferences::GetInt(kHangUITimeoutPref, 0);
        mHangUIEnabled = timeoutSecs > 0;
    }
    if (mHangUIEnabled) {
        if (aReset) {
            mIsTimerReset = true;
            SetChildTimeout(timeoutSecs);
            return;
        } else if (mIsTimerReset) {
            /* The Hang UI is being shown, so now we're setting the 
               timeout to kChildTimeoutPref while we wait for a user 
               response. ShouldContinueFromReplyTimeout will fire 
               after (reply timeout / 2) seconds, which is not what 
               we want. Doubling the timeout value here so that we get 
               the right result. */
            autoStopSecs *= 2;
        }
    }
    mIsTimerReset = false;
    SetChildTimeout(autoStopSecs);
}

bool
PluginModuleChromeParent::LaunchHangUI()
{
    if (!mHangUIEnabled) {
        return false;
    }
    if (mHangUIParent) {
        if (mHangUIParent->IsShowing()) {
            // We've already shown the UI but the timeout has expired again.
            return false;
        }
        if (mHangUIParent->DontShowAgain()) {
            mHangAnnotationFlags |= kHangUIDontShow;
            bool wasLastHangStopped = mHangUIParent->WasLastHangStopped();
            if (!wasLastHangStopped) {
                mHangAnnotationFlags |= kHangUIContinued;
            }
            return !wasLastHangStopped;
        }
        delete mHangUIParent;
        mHangUIParent = nullptr;
    }
    mHangUIParent = new PluginHangUIParent(this, 
            Preferences::GetInt(kHangUITimeoutPref, 0),
            Preferences::GetInt(kChildTimeoutPref, 0));
    bool retval = mHangUIParent->Init(NS_ConvertUTF8toUTF16(mPluginName));
    if (retval) {
        mHangAnnotationFlags |= kHangUIShown;
        /* Once the UI is shown we switch the timeout over to use 
           kChildTimeoutPref, allowing us to terminate a hung plugin 
           after kChildTimeoutPref seconds if the user doesn't respond to 
           the hang UI. */
        EvaluateHangUIState(false);
    }
    return retval;
}

void
PluginModuleChromeParent::FinishHangUI()
{
    if (mHangUIEnabled && mHangUIParent) {
        bool needsCancel = mHangUIParent->IsShowing();
        // If we're still showing, send a Cancel notification
        if (needsCancel) {
            mHangUIParent->Cancel();
        }
        /* If we cancelled the UI or if the user issued a response,
           we need to reset the child process timeout. */
        if (needsCancel ||
            (!mIsTimerReset && mHangUIParent->WasShown())) {
            /* We changed the timeout to kChildTimeoutPref when the plugin hang
               UI was displayed. Now that we're finishing the UI, we need to 
               switch it back to kHangUITimeoutPref. */
            EvaluateHangUIState(true);
        }
    }
}

void
PluginModuleChromeParent::OnHangUIContinue()
{
    mHangAnnotationFlags |= kHangUIContinued;
}
#endif // XP_WIN

#ifdef MOZ_CRASHREPORTER
CrashReporterParent*
PluginModuleChromeParent::CrashReporter()
{
    return static_cast<CrashReporterParent*>(LoneManagedOrNullAsserts(ManagedPCrashReporterParent()));
}

#ifdef MOZ_CRASHREPORTER_INJECTOR
static void
RemoveMinidump(nsIFile* minidump)
{
    if (!minidump)
        return;

    minidump->Remove(false);
    nsCOMPtr<nsIFile> extraFile;
    if (GetExtraFileForMinidump(minidump,
                                getter_AddRefs(extraFile))) {
        extraFile->Remove(true);
    }
}
#endif // MOZ_CRASHREPORTER_INJECTOR

void
PluginModuleChromeParent::ProcessFirstMinidump()
{
#ifdef XP_WIN
    mozilla::MutexAutoLock lock(mCrashReporterMutex);
#endif
    CrashReporterParent* crashReporter = CrashReporter();
    if (!crashReporter)
        return;

    AnnotationTable notes(4);
    WriteExtraDataForMinidump(notes);

    if (!mPluginDumpID.IsEmpty()) {
        // mPluginDumpID may be set in TerminateChildProcess, which means the
        // process hang monitor has already collected a 3-way browser, plugin,
        // content crash report. If so, update the existing report with our
        // annotations and finalize it. If not, fall through for standard
        // plugin crash report handling.
        crashReporter->GenerateChildData(&notes);
        crashReporter->FinalizeChildData();
        return;
    }

    uint32_t sequence = UINT32_MAX;
    nsCOMPtr<nsIFile> dumpFile;
    nsAutoCString flashProcessType;
    TakeMinidump(getter_AddRefs(dumpFile), &sequence);

#ifdef MOZ_CRASHREPORTER_INJECTOR
    nsCOMPtr<nsIFile> childDumpFile;
    uint32_t childSequence;

    if (mFlashProcess1 &&
        TakeMinidumpForChild(mFlashProcess1,
                             getter_AddRefs(childDumpFile),
                             &childSequence)) {
        if (childSequence < sequence) {
            RemoveMinidump(dumpFile);
            dumpFile = childDumpFile;
            sequence = childSequence;
            flashProcessType.AssignLiteral("Broker");
        }
        else {
            RemoveMinidump(childDumpFile);
        }
    }
    if (mFlashProcess2 &&
        TakeMinidumpForChild(mFlashProcess2,
                             getter_AddRefs(childDumpFile),
                             &childSequence)) {
        if (childSequence < sequence) {
            RemoveMinidump(dumpFile);
            dumpFile = childDumpFile;
            sequence = childSequence;
            flashProcessType.AssignLiteral("Sandbox");
        }
        else {
            RemoveMinidump(childDumpFile);
        }
    }
#endif

    if (!dumpFile) {
        NS_WARNING("[PluginModuleParent::ActorDestroy] abnormal shutdown without minidump!");
        return;
    }

    PLUGIN_LOG_DEBUG(("got child minidump: %s",
                      NS_ConvertUTF16toUTF8(mPluginDumpID).get()));

    GetIDFromMinidump(dumpFile, mPluginDumpID);
    if (!flashProcessType.IsEmpty()) {
        notes.Put(NS_LITERAL_CSTRING("FlashProcessDump"), flashProcessType);
    }
    crashReporter->GenerateCrashReportForMinidump(dumpFile, &notes);
}
#endif

void
PluginModuleParent::ActorDestroy(ActorDestroyReason why)
{
    switch (why) {
    case AbnormalShutdown: {
        mShutdown = true;
        // Defer the PluginCrashed method so that we don't re-enter
        // and potentially modify the actor child list while enumerating it.
        if (mPlugin)
            MessageLoop::current()->PostTask(
                mTaskFactory.NewRunnableMethod(
                    &PluginModuleParent::NotifyPluginCrashed));
        break;
    }
    case NormalShutdown:
        mShutdown = true;
        break;

    default:
        NS_RUNTIMEABORT("Unexpected shutdown reason for toplevel actor.");
    }
}

nsresult
PluginModuleParent::GetRunID(uint32_t* aRunID)
{
    if (NS_WARN_IF(!aRunID)) {
      return NS_ERROR_INVALID_POINTER;
    }
    *aRunID = mRunID;
    return NS_OK;
}

void
PluginModuleChromeParent::ActorDestroy(ActorDestroyReason why)
{
    if (why == AbnormalShutdown) {
#ifdef MOZ_CRASHREPORTER
        ProcessFirstMinidump();
#endif
        Telemetry::Accumulate(Telemetry::SUBPROCESS_ABNORMAL_ABORT,
                              NS_LITERAL_CSTRING("plugin"), 1);
    }

    // We can't broadcast settings changes anymore.
    UnregisterSettingsCallbacks();

    PluginModuleParent::ActorDestroy(why);
}

void
PluginModuleParent::NotifyFlashHang()
{
    nsCOMPtr<nsIObserverService> obs = services::GetObserverService();
    if (obs) {
        obs->NotifyObservers(nullptr, "flash-plugin-hang", nullptr);
    }
}

void
PluginModuleParent::NotifyPluginCrashed()
{
    if (!OkToCleanup()) {
        // there's still plugin code on the C++ stack.  try again
        MessageLoop::current()->PostDelayedTask(
            mTaskFactory.NewRunnableMethod(
                &PluginModuleParent::NotifyPluginCrashed), 10);
        return;
    }

    if (mPlugin)
        mPlugin->PluginCrashed(mPluginDumpID, mBrowserDumpID);
}

PPluginInstanceParent*
PluginModuleParent::AllocPPluginInstanceParent(const nsCString& aMimeType,
                                               const uint16_t& aMode,
                                               const InfallibleTArray<nsCString>& aNames,
                                               const InfallibleTArray<nsCString>& aValues)
{
    NS_ERROR("Not reachable!");
    return nullptr;
}

bool
PluginModuleParent::DeallocPPluginInstanceParent(PPluginInstanceParent* aActor)
{
    PLUGIN_LOG_DEBUG_METHOD;
    delete aActor;
    return true;
}

void
PluginModuleParent::SetPluginFuncs(NPPluginFuncs* aFuncs)
{
    MOZ_ASSERT(aFuncs);

    aFuncs->version = (NP_VERSION_MAJOR << 8) | NP_VERSION_MINOR;
    aFuncs->javaClass = nullptr;

    // Gecko should always call these functions through a PluginLibrary object.
    aFuncs->newp = nullptr;
    aFuncs->clearsitedata = nullptr;
    aFuncs->getsiteswithdata = nullptr;

    aFuncs->destroy = NPP_Destroy;
    aFuncs->setwindow = NPP_SetWindow;
    aFuncs->newstream = NPP_NewStream;
    aFuncs->destroystream = NPP_DestroyStream;
    aFuncs->asfile = NPP_StreamAsFile;
    aFuncs->writeready = NPP_WriteReady;
    aFuncs->write = NPP_Write;
    aFuncs->print = NPP_Print;
    aFuncs->event = NPP_HandleEvent;
    aFuncs->urlnotify = NPP_URLNotify;
    aFuncs->getvalue = NPP_GetValue;
    aFuncs->setvalue = NPP_SetValue;
    aFuncs->gotfocus = nullptr;
    aFuncs->lostfocus = nullptr;
    aFuncs->urlredirectnotify = nullptr;

    // Provide 'NPP_URLRedirectNotify', 'NPP_ClearSiteData', and
    // 'NPP_GetSitesWithData' functionality if it is supported by the plugin.
    bool urlRedirectSupported = false;
    Unused << CallOptionalFunctionsSupported(&urlRedirectSupported,
                                             &mClearSiteDataSupported,
                                             &mGetSitesWithDataSupported);
    if (urlRedirectSupported) {
      aFuncs->urlredirectnotify = NPP_URLRedirectNotify;
    }
}

#define RESOLVE_AND_CALL(instance, func)                                       \
NP_BEGIN_MACRO                                                                 \
    PluginAsyncSurrogate* surrogate = nullptr;                                 \
    PluginInstanceParent* i = PluginInstanceParent::Cast(instance, &surrogate);\
    if (surrogate && (!i || i->UseSurrogate())) {                              \
        return surrogate->func;                                                \
    }                                                                          \
    if (!i) {                                                                  \
        return NPERR_GENERIC_ERROR;                                            \
    }                                                                          \
    return i->func;                                                            \
NP_END_MACRO

NPError
PluginModuleParent::NPP_Destroy(NPP instance,
                                NPSavedData** saved)
{
    // FIXME/cjones:
    //  (1) send a "destroy" message to the child
    //  (2) the child shuts down its instance
    //  (3) remove both parent and child IDs from map
    //  (4) free parent

    PLUGIN_LOG_DEBUG_FUNCTION;
    PluginAsyncSurrogate* surrogate = nullptr;
    PluginInstanceParent* parentInstance =
        PluginInstanceParent::Cast(instance, &surrogate);
    if (surrogate && (!parentInstance || parentInstance->UseSurrogate())) {
        return surrogate->NPP_Destroy(saved);
    }

    if (!parentInstance)
        return NPERR_NO_ERROR;

    NPError retval = parentInstance->Destroy();
    instance->pdata = nullptr;

    Unused << PluginInstanceParent::Call__delete__(parentInstance);
    return retval;
}

NPError
PluginModuleParent::NPP_NewStream(NPP instance, NPMIMEType type,
                                  NPStream* stream, NPBool seekable,
                                  uint16_t* stype)
{
    PROFILER_LABEL("PluginModuleParent", "NPP_NewStream",
      js::ProfileEntry::Category::OTHER);
    RESOLVE_AND_CALL(instance, NPP_NewStream(type, stream, seekable, stype));
}

NPError
PluginModuleParent::NPP_SetWindow(NPP instance, NPWindow* window)
{
    RESOLVE_AND_CALL(instance, NPP_SetWindow(window));
}

NPError
PluginModuleParent::NPP_DestroyStream(NPP instance,
                                      NPStream* stream,
                                      NPReason reason)
{
    RESOLVE_AND_CALL(instance, NPP_DestroyStream(stream, reason));
}

int32_t
PluginModuleParent::NPP_WriteReady(NPP instance,
                                   NPStream* stream)
{
    PluginAsyncSurrogate* surrogate = nullptr;
    BrowserStreamParent* s = StreamCast(instance, stream, &surrogate);
    if (!s) {
        if (surrogate) {
            return surrogate->NPP_WriteReady(stream);
        }
        return -1;
    }

    return s->WriteReady();
}

int32_t
PluginModuleParent::NPP_Write(NPP instance,
                              NPStream* stream,
                              int32_t offset,
                              int32_t len,
                              void* buffer)
{
    BrowserStreamParent* s = StreamCast(instance, stream);
    if (!s)
        return -1;

    return s->Write(offset, len, buffer);
}

void
PluginModuleParent::NPP_StreamAsFile(NPP instance,
                                     NPStream* stream,
                                     const char* fname)
{
    BrowserStreamParent* s = StreamCast(instance, stream);
    if (!s)
        return;

    s->StreamAsFile(fname);
}

void
PluginModuleParent::NPP_Print(NPP instance, NPPrint* platformPrint)
{

    PluginInstanceParent* i = PluginInstanceParent::Cast(instance);
    i->NPP_Print(platformPrint);
}

int16_t
PluginModuleParent::NPP_HandleEvent(NPP instance, void* event)
{
    RESOLVE_AND_CALL(instance, NPP_HandleEvent(event));
}

void
PluginModuleParent::NPP_URLNotify(NPP instance, const char* url,
                                  NPReason reason, void* notifyData)
{
    PluginInstanceParent* i = PluginInstanceParent::Cast(instance);
    if (!i)
        return;

    i->NPP_URLNotify(url, reason, notifyData);
}

NPError
PluginModuleParent::NPP_GetValue(NPP instance,
                                 NPPVariable variable, void *ret_value)
{
    // The rules are slightly different for this function.
    // If there is a surrogate, we *always* use it.
    PluginAsyncSurrogate* surrogate = nullptr;
    PluginInstanceParent* i = PluginInstanceParent::Cast(instance, &surrogate);
    if (surrogate) {
        return surrogate->NPP_GetValue(variable, ret_value);
    }
    if (!i) {
        return NPERR_GENERIC_ERROR;
    }
    return i->NPP_GetValue(variable, ret_value);
}

NPError
PluginModuleParent::NPP_SetValue(NPP instance, NPNVariable variable,
                                 void *value)
{
    RESOLVE_AND_CALL(instance, NPP_SetValue(variable, value));
}

bool
PluginModuleChromeParent::AnswerNPN_SetValue_NPPVpluginRequiresAudioDeviceChanges(
    const bool& shouldRegister, NPError* result)
{
#ifdef XP_WIN
    *result = NPERR_NO_ERROR;
    nsresult err =
      mozilla::plugins::PluginUtilsWin::RegisterForAudioDeviceChanges(this,
                                                               shouldRegister);
    if (err != NS_OK) {
      *result = NPERR_GENERIC_ERROR;
    }
    return true;
#else
    NS_RUNTIMEABORT("NPPVpluginRequiresAudioDeviceChanges is not valid on this platform.");
    *result = NPERR_GENERIC_ERROR;
    return true;
#endif
}

bool
PluginModuleParent::RecvBackUpXResources(const FileDescriptor& aXSocketFd)
{
#ifndef MOZ_X11
    NS_RUNTIMEABORT("This message only makes sense on X11 platforms");
#else
    MOZ_ASSERT(0 > mPluginXSocketFdDup.get(),
               "Already backed up X resources??");
    if (aXSocketFd.IsValid()) {
      auto rawFD = aXSocketFd.ClonePlatformHandle();
      mPluginXSocketFdDup.reset(rawFD.release());
    }
#endif
    return true;
}

void
PluginModuleParent::NPP_URLRedirectNotify(NPP instance, const char* url,
                                          int32_t status, void* notifyData)
{
  PluginInstanceParent* i = PluginInstanceParent::Cast(instance);
  if (!i)
    return;

  i->NPP_URLRedirectNotify(url, status, notifyData);
}

BrowserStreamParent*
PluginModuleParent::StreamCast(NPP instance, NPStream* s,
                               PluginAsyncSurrogate** aSurrogate)
{
    PluginInstanceParent* ip = PluginInstanceParent::Cast(instance, aSurrogate);
    if (!ip || (aSurrogate && *aSurrogate && ip->UseSurrogate())) {
        return nullptr;
    }

    BrowserStreamParent* sp =
        static_cast<BrowserStreamParent*>(static_cast<AStream*>(s->pdata));
    if (sp && (sp->mNPP != ip || s != sp->mStream)) {
        NS_RUNTIMEABORT("Corrupted plugin stream data.");
    }
    return sp;
}

bool
PluginModuleParent::HasRequiredFunctions()
{
    return true;
}

nsresult
PluginModuleParent::AsyncSetWindow(NPP instance, NPWindow* window)
{
    PluginAsyncSurrogate* surrogate = nullptr;
    PluginInstanceParent* i = PluginInstanceParent::Cast(instance, &surrogate);
    if (surrogate && (!i || i->UseSurrogate())) {
        return surrogate->AsyncSetWindow(window);
    } else if (!i) {
        return NS_ERROR_FAILURE;
    }
    return i->AsyncSetWindow(window);
}

nsresult
PluginModuleParent::GetImageContainer(NPP instance,
                             mozilla::layers::ImageContainer** aContainer)
{
    PluginInstanceParent* i = PluginInstanceParent::Cast(instance);
    return !i ? NS_ERROR_FAILURE : i->GetImageContainer(aContainer);
}

nsresult
PluginModuleParent::GetImageSize(NPP instance,
                                 nsIntSize* aSize)
{
    PluginInstanceParent* i = PluginInstanceParent::Cast(instance);
    return !i ? NS_ERROR_FAILURE : i->GetImageSize(aSize);
}

void
PluginModuleParent::DidComposite(NPP aInstance)
{
    if (PluginInstanceParent* i = PluginInstanceParent::Cast(aInstance)) {
        i->DidComposite();
    }
}

nsresult
PluginModuleParent::SetBackgroundUnknown(NPP instance)
{
    PluginInstanceParent* i = PluginInstanceParent::Cast(instance);
    if (!i)
        return NS_ERROR_FAILURE;

    return i->SetBackgroundUnknown();
}

nsresult
PluginModuleParent::BeginUpdateBackground(NPP instance,
                                          const nsIntRect& aRect,
                                          DrawTarget** aDrawTarget)
{
    PluginInstanceParent* i = PluginInstanceParent::Cast(instance);
    if (!i)
        return NS_ERROR_FAILURE;

    return i->BeginUpdateBackground(aRect, aDrawTarget);
}

nsresult
PluginModuleParent::EndUpdateBackground(NPP instance, const nsIntRect& aRect)
{
    PluginInstanceParent* i = PluginInstanceParent::Cast(instance);
    if (!i)
        return NS_ERROR_FAILURE;

    return i->EndUpdateBackground(aRect);
}

#if defined(XP_WIN)
nsresult
PluginModuleParent::GetScrollCaptureContainer(NPP aInstance,
                                              mozilla::layers::ImageContainer** aContainer)
{
    PluginInstanceParent* inst = PluginInstanceParent::Cast(aInstance);
    return !inst ? NS_ERROR_FAILURE : inst->GetScrollCaptureContainer(aContainer);
}
#endif

nsresult
PluginModuleParent::HandledWindowedPluginKeyEvent(
                        NPP aInstance,
                        const NativeEventData& aNativeKeyData,
                        bool aIsConsumed)
{
    PluginInstanceParent* parent = PluginInstanceParent::Cast(aInstance);
    if (NS_WARN_IF(!parent)) {
        return NS_ERROR_FAILURE;
    }
    return parent->HandledWindowedPluginKeyEvent(aNativeKeyData, aIsConsumed);
}

void
PluginModuleParent::OnInitFailure()
{
    if (GetIPCChannel()->CanSend()) {
        Close();
    }

    mShutdown = true;

    if (mIsStartingAsync) {
        /* If we've failed then we need to enumerate any pending NPP_New calls
           and clean them up. */
        uint32_t len = mSurrogateInstances.Length();
        for (uint32_t i = 0; i < len; ++i) {
            mSurrogateInstances[i]->NotifyAsyncInitFailed();
        }
        mSurrogateInstances.Clear();
    }
}

class PluginOfflineObserver final : public nsIObserver
{
public:
    NS_DECL_ISUPPORTS
    NS_DECL_NSIOBSERVER

    explicit PluginOfflineObserver(PluginModuleChromeParent* pmp)
      : mPmp(pmp)
    {}

private:
    ~PluginOfflineObserver() {}
    PluginModuleChromeParent* mPmp;
};

NS_IMPL_ISUPPORTS(PluginOfflineObserver, nsIObserver)

NS_IMETHODIMP
PluginOfflineObserver::Observe(nsISupports *aSubject,
                               const char *aTopic,
                               const char16_t *aData)
{
    MOZ_ASSERT(!strcmp(aTopic, "ipc:network:set-offline"));
    mPmp->CachedSettingChanged();
    return NS_OK;
}

static const char* kSettingsPrefs[] =
    {"javascript.enabled",
     "dom.ipc.plugins.nativeCursorSupport"};

void
PluginModuleChromeParent::RegisterSettingsCallbacks()
{
    for (size_t i = 0; i < ArrayLength(kSettingsPrefs); i++) {
        Preferences::RegisterCallback(CachedSettingChanged, kSettingsPrefs[i], this);
    }

    nsCOMPtr<nsIObserverService> observerService = mozilla::services::GetObserverService();
    if (observerService) {
        mPluginOfflineObserver = new PluginOfflineObserver(this);
        observerService->AddObserver(mPluginOfflineObserver, "ipc:network:set-offline", false);
    }
}

void
PluginModuleChromeParent::UnregisterSettingsCallbacks()
{
    for (size_t i = 0; i < ArrayLength(kSettingsPrefs); i++) {
        Preferences::UnregisterCallback(CachedSettingChanged, kSettingsPrefs[i], this);
    }

    nsCOMPtr<nsIObserverService> observerService = mozilla::services::GetObserverService();
    if (observerService) {
        observerService->RemoveObserver(mPluginOfflineObserver, "ipc:network:set-offline");
        mPluginOfflineObserver = nullptr;
    }
}

bool
PluginModuleParent::GetSetting(NPNVariable aVariable)
{
    NPBool boolVal = false;
    mozilla::plugins::parent::_getvalue(nullptr, aVariable, &boolVal);
    return boolVal;
}

void
PluginModuleParent::GetSettings(PluginSettings* aSettings)
{
    aSettings->javascriptEnabled() = GetSetting(NPNVjavascriptEnabledBool);
    aSettings->asdEnabled() = GetSetting(NPNVasdEnabledBool);
    aSettings->isOffline() = GetSetting(NPNVisOfflineBool);
    aSettings->supportsXembed() = GetSetting(NPNVSupportsXEmbedBool);
    aSettings->supportsWindowless() = GetSetting(NPNVSupportsWindowless);
    aSettings->userAgent() = NullableString(mNPNIface->uagent(nullptr));

#if defined(XP_MACOSX)
    aSettings->nativeCursorsSupported() =
      Preferences::GetBool("dom.ipc.plugins.nativeCursorSupport", false);
#else
    // Need to initialize this to satisfy IPDL.
    aSettings->nativeCursorsSupported() = false;
#endif
}

void
PluginModuleChromeParent::CachedSettingChanged()
{
    PluginSettings settings;
    GetSettings(&settings);
    Unused << SendSettingChanged(settings);
}

/* static */ void
PluginModuleChromeParent::CachedSettingChanged(const char* aPref, void* aModule)
{
    PluginModuleChromeParent *module = static_cast<PluginModuleChromeParent*>(aModule);
    module->CachedSettingChanged();
}

#if defined(XP_UNIX) && !defined(XP_MACOSX) && !defined(MOZ_WIDGET_GONK)
nsresult
PluginModuleParent::NP_Initialize(NPNetscapeFuncs* bFuncs, NPPluginFuncs* pFuncs, NPError* error)
{
    PLUGIN_LOG_DEBUG_METHOD;

    mNPNIface = bFuncs;
    mNPPIface = pFuncs;

    if (mShutdown) {
        *error = NPERR_GENERIC_ERROR;
        return NS_ERROR_FAILURE;
    }

    *error = NPERR_NO_ERROR;
    if (mIsStartingAsync) {
        if (GetIPCChannel()->CanSend()) {
            // We're already connected, so we may call this immediately.
            RecvNP_InitializeResult(*error);
        } else {
            PluginAsyncSurrogate::NP_GetEntryPoints(pFuncs);
        }
    } else {
        SetPluginFuncs(pFuncs);
    }

    return NS_OK;
}

nsresult
PluginModuleChromeParent::NP_Initialize(NPNetscapeFuncs* bFuncs, NPPluginFuncs* pFuncs, NPError* error)
{
    PLUGIN_LOG_DEBUG_METHOD;

    if (mShutdown) {
        *error = NPERR_GENERIC_ERROR;
        return NS_ERROR_FAILURE;
    }

    *error = NPERR_NO_ERROR;

    mNPNIface = bFuncs;
    mNPPIface = pFuncs;

    // NB: This *MUST* be set prior to checking whether the subprocess has
    // been connected!
    if (mIsStartingAsync) {
        PluginAsyncSurrogate::NP_GetEntryPoints(pFuncs);
    }

    if (!mSubprocess->IsConnected()) {
        // The subprocess isn't connected yet. Defer NP_Initialize until
        // OnProcessLaunched is invoked.
        mInitOnAsyncConnect = true;
        return NS_OK;
    }

    PluginSettings settings;
    GetSettings(&settings);

    TimeStamp callNpInitStart = TimeStamp::Now();
    // Asynchronous case
    if (mIsStartingAsync) {
        if (!SendAsyncNP_Initialize(settings)) {
            Close();
            return NS_ERROR_FAILURE;
        }
        TimeStamp callNpInitEnd = TimeStamp::Now();
        mTimeBlocked += (callNpInitEnd - callNpInitStart);
        return NS_OK;
    }

    // Synchronous case
    if (!CallNP_Initialize(settings, error)) {
        Close();
        return NS_ERROR_FAILURE;
    }
    else if (*error != NPERR_NO_ERROR) {
        Close();
        return NS_ERROR_FAILURE;
    }
    TimeStamp callNpInitEnd = TimeStamp::Now();
    mTimeBlocked += (callNpInitEnd - callNpInitStart);

    RecvNP_InitializeResult(*error);

    return NS_OK;
}

bool
PluginModuleParent::RecvNP_InitializeResult(const NPError& aError)
{
    if (aError != NPERR_NO_ERROR) {
        OnInitFailure();
        return true;
    }

    SetPluginFuncs(mNPPIface);
    if (mIsStartingAsync) {
        InitAsyncSurrogates();
    }

    mNPInitialized = true;
    return true;
}

bool
PluginModuleChromeParent::RecvNP_InitializeResult(const NPError& aError)
{
    if (!mContentParent) {
        return PluginModuleParent::RecvNP_InitializeResult(aError);
    }
    bool initOk = aError == NPERR_NO_ERROR;
    if (initOk) {
        SetPluginFuncs(mNPPIface);
        if (mIsStartingAsync && !SendAssociatePluginId()) {
            initOk = false;
        }
    }
    mNPInitialized = initOk;
    bool result = mContentParent->SendLoadPluginResult(mPluginId, initOk);
    mContentParent = nullptr;
    return result;
}

#else

nsresult
PluginModuleParent::NP_Initialize(NPNetscapeFuncs* bFuncs, NPError* error)
{
    PLUGIN_LOG_DEBUG_METHOD;

    mNPNIface = bFuncs;

    if (mShutdown) {
        *error = NPERR_GENERIC_ERROR;
        return NS_ERROR_FAILURE;
    }

    *error = NPERR_NO_ERROR;
    return NS_OK;
}

#if defined(XP_WIN) || defined(XP_MACOSX)

nsresult
PluginModuleContentParent::NP_Initialize(NPNetscapeFuncs* bFuncs, NPError* error)
{
    PLUGIN_LOG_DEBUG_METHOD;
    nsresult rv = PluginModuleParent::NP_Initialize(bFuncs, error);
    if (mIsStartingAsync && GetIPCChannel()->CanSend()) {
        // We're already connected, so we may call this immediately.
        RecvNP_InitializeResult(*error);
    }
    return rv;
}

#endif

nsresult
PluginModuleChromeParent::NP_Initialize(NPNetscapeFuncs* bFuncs, NPError* error)
{
    nsresult rv = PluginModuleParent::NP_Initialize(bFuncs, error);
    if (NS_FAILED(rv))
        return rv;

#if defined(XP_MACOSX)
    if (!mSubprocess->IsConnected()) {
        // The subprocess isn't connected yet. Defer NP_Initialize until
        // OnProcessLaunched is invoked.
        mInitOnAsyncConnect = true;
        *error = NPERR_NO_ERROR;
        return NS_OK;
    }
#else
    if (mInitOnAsyncConnect) {
        *error = NPERR_NO_ERROR;
        return NS_OK;
    }
#endif

    PluginSettings settings;
    GetSettings(&settings);

    TimeStamp callNpInitStart = TimeStamp::Now();
    if (mIsStartingAsync) {
        if (!SendAsyncNP_Initialize(settings)) {
            return NS_ERROR_FAILURE;
        }
        TimeStamp callNpInitEnd = TimeStamp::Now();
        mTimeBlocked += (callNpInitEnd - callNpInitStart);
        return NS_OK;
    }

    if (!CallNP_Initialize(settings, error)) {
        Close();
        return NS_ERROR_FAILURE;
    }
    TimeStamp callNpInitEnd = TimeStamp::Now();
    mTimeBlocked += (callNpInitEnd - callNpInitStart);
    RecvNP_InitializeResult(*error);
    return NS_OK;
}

bool
PluginModuleParent::RecvNP_InitializeResult(const NPError& aError)
{
    if (aError != NPERR_NO_ERROR) {
        OnInitFailure();
        return true;
    }

    if (mIsStartingAsync && mNPPIface) {
        SetPluginFuncs(mNPPIface);
        InitAsyncSurrogates();
    }

    mNPInitialized = true;
    return true;
}

bool
PluginModuleChromeParent::RecvNP_InitializeResult(const NPError& aError)
{
    bool ok = true;
    if (mContentParent) {
        if ((ok = SendAssociatePluginId())) {
            ok = mContentParent->SendLoadPluginResult(mPluginId,
                                                      aError == NPERR_NO_ERROR);
            mContentParent = nullptr;
        }
    } else if (aError == NPERR_NO_ERROR) {
        // Initialization steps for (e10s && !asyncInit) || !e10s
#if defined XP_WIN
        if (mIsStartingAsync) {
            SetPluginFuncs(mNPPIface);
        }

        // Send the info needed to join the browser process's audio session to the
        // plugin process.
        nsID id;
        nsString sessionName;
        nsString iconPath;

        if (NS_SUCCEEDED(mozilla::widget::GetAudioSessionData(id, sessionName,
                                                              iconPath))) {
            Unused << SendSetAudioSessionData(id, sessionName, iconPath);
        }
#endif

#ifdef MOZ_CRASHREPORTER_INJECTOR
        InitializeInjector();
#endif
    }

    return PluginModuleParent::RecvNP_InitializeResult(aError) && ok;
}

#endif

void
PluginModuleParent::InitAsyncSurrogates()
{
    if (MaybeRunDeferredShutdown()) {
        // We've shut down, so the surrogates are no longer valid. Clear
        // mSurrogateInstances to ensure that these aren't used.
        mSurrogateInstances.Clear();
        return;
    }

    uint32_t len = mSurrogateInstances.Length();
    for (uint32_t i = 0; i < len; ++i) {
        NPError err;
        mAsyncNewRv = mSurrogateInstances[i]->NPP_New(&err);
        if (NS_FAILED(mAsyncNewRv)) {
            mSurrogateInstances[i]->NotifyAsyncInitFailed();
            continue;
        }
    }
    mSurrogateInstances.Clear();
}

bool
PluginModuleParent::RemovePendingSurrogate(
                            const RefPtr<PluginAsyncSurrogate>& aSurrogate)
{
    return mSurrogateInstances.RemoveElement(aSurrogate);
}

bool
PluginModuleParent::MaybeRunDeferredShutdown()
{
    if (!mIsStartingAsync || !mIsNPShutdownPending) {
        return false;
    }
    MOZ_ASSERT(!mShutdown);
    NPError error;
    if (!DoShutdown(&error)) {
        return false;
    }
    mIsNPShutdownPending = false;
    return true;
}

nsresult
PluginModuleParent::NP_Shutdown(NPError* error)
{
    PLUGIN_LOG_DEBUG_METHOD;

    if (mShutdown) {
        *error = NPERR_GENERIC_ERROR;
        return NS_ERROR_FAILURE;
    }

    /* If we're still running an async NP_Initialize then we need to defer
       shutdown until we've received the result of the NP_Initialize call. */
    if (mIsStartingAsync && !mNPInitialized) {
        mIsNPShutdownPending = true;
        *error = NPERR_NO_ERROR;
        return NS_OK;
    }

    if (!DoShutdown(error)) {
        return NS_ERROR_FAILURE;
    }

    return NS_OK;
}

bool
PluginModuleParent::DoShutdown(NPError* error)
{
    bool ok = true;
    if (IsChrome() && mHadLocalInstance) {
        // We synchronously call NP_Shutdown if the chrome process was using
        // plugins itself. That way we can service any requests the plugin
        // makes. If we're in e10s, though, the content processes will have
        // already shut down and there's no one to talk to. So we shut down
        // asynchronously in PluginModuleChild::ActorDestroy.
        ok = CallNP_Shutdown(error);
    }

    // if NP_Shutdown() is nested within another interrupt call, this will
    // break things.  but lord help us if we're doing that anyway; the
    // plugin dso will have been unloaded on the other side by the
    // CallNP_Shutdown() message
    Close();

    // mShutdown should either be initialized to false, or be transitiong from
    // false to true. It is never ok to go from true to false. Using OR for
    // the following assignment to ensure this.
    mShutdown |= ok;
    if (!ok) {
        *error = NPERR_GENERIC_ERROR;
    }
    return ok;
}

nsresult
PluginModuleParent::NP_GetMIMEDescription(const char** mimeDesc)
{
    PLUGIN_LOG_DEBUG_METHOD;

    *mimeDesc = "application/x-foobar";
    return NS_OK;
}

nsresult
PluginModuleParent::NP_GetValue(void *future, NPPVariable aVariable,
                                   void *aValue, NPError* error)
{
    MOZ_LOG(GetPluginLog(), LogLevel::Warning, ("%s Not implemented, requested variable %i", __FUNCTION__,
                                        (int) aVariable));

    //TODO: implement this correctly
    *error = NPERR_GENERIC_ERROR;
    return NS_OK;
}

#if defined(XP_WIN) || defined(XP_MACOSX)
nsresult
PluginModuleParent::NP_GetEntryPoints(NPPluginFuncs* pFuncs, NPError* error)
{
    NS_ASSERTION(pFuncs, "Null pointer!");

    *error = NPERR_NO_ERROR;
    if (mIsStartingAsync && !IsChrome()) {
        mNPPIface = pFuncs;
#if defined(XP_MACOSX)
        if (mNPInitialized) {
            SetPluginFuncs(pFuncs);
            InitAsyncSurrogates();
        } else {
            PluginAsyncSurrogate::NP_GetEntryPoints(pFuncs);
        }
#else
        PluginAsyncSurrogate::NP_GetEntryPoints(pFuncs);
#endif
    } else {
        SetPluginFuncs(pFuncs);
    }

    return NS_OK;
}

nsresult
PluginModuleChromeParent::NP_GetEntryPoints(NPPluginFuncs* pFuncs, NPError* error)
{
#if defined(XP_MACOSX)
    if (mInitOnAsyncConnect) {
        PluginAsyncSurrogate::NP_GetEntryPoints(pFuncs);
        mNPPIface = pFuncs;
        *error = NPERR_NO_ERROR;
        return NS_OK;
    }
#else
    if (mIsStartingAsync) {
        PluginAsyncSurrogate::NP_GetEntryPoints(pFuncs);
    }
    if (!mSubprocess->IsConnected()) {
        mNPPIface = pFuncs;
        mInitOnAsyncConnect = true;
        *error = NPERR_NO_ERROR;
        return NS_OK;
    }
#endif

    // We need to have the plugin process update its function table here by
    // actually calling NP_GetEntryPoints. The parent's function table will
    // reflect nullptr entries in the child's table once SetPluginFuncs is
    // called.

    if (!CallNP_GetEntryPoints(error)) {
        return NS_ERROR_FAILURE;
    }
    else if (*error != NPERR_NO_ERROR) {
        return NS_OK;
    }

    return PluginModuleParent::NP_GetEntryPoints(pFuncs, error);
}

#endif

nsresult
PluginModuleParent::NPP_New(NPMIMEType pluginType, NPP instance,
                            uint16_t mode, int16_t argc, char* argn[],
                            char* argv[], NPSavedData* saved,
                            NPError* error)
{
    PLUGIN_LOG_DEBUG_METHOD;

    if (mShutdown) {
        *error = NPERR_GENERIC_ERROR;
        return NS_ERROR_FAILURE;
    }

    if (mIsStartingAsync) {
        if (!PluginAsyncSurrogate::Create(this, pluginType, instance, mode,
                                          argc, argn, argv)) {
            *error = NPERR_GENERIC_ERROR;
            return NS_ERROR_FAILURE;
        }

        if (!mNPInitialized) {
            RefPtr<PluginAsyncSurrogate> surrogate =
                PluginAsyncSurrogate::Cast(instance);
            mSurrogateInstances.AppendElement(surrogate);
            *error = NPERR_NO_ERROR;
            return NS_PLUGIN_INIT_PENDING;
        }
    }

    // create the instance on the other side
    InfallibleTArray<nsCString> names;
    InfallibleTArray<nsCString> values;

    for (int i = 0; i < argc; ++i) {
        names.AppendElement(NullableString(argn[i]));
        values.AppendElement(NullableString(argv[i]));
    }

    nsresult rv = NPP_NewInternal(pluginType, instance, mode, names, values,
                                  saved, error);
    if (NS_FAILED(rv) || !mIsStartingAsync) {
        return rv;
    }
    return NS_PLUGIN_INIT_PENDING;
}

class nsCaseInsensitiveUTF8StringArrayComparator
{
public:
  template<class A, class B>
  bool Equals(const A& a, const B& b) const {
    return a.Equals(b.get(), nsCaseInsensitiveUTF8StringComparator());
  }
};

void
PluginModuleParent::AccumulateModuleInitBlockedTime()
{
    if (mPluginName.IsEmpty()) {
        GetPluginDetails();
    }
    Telemetry::Accumulate(Telemetry::BLOCKED_ON_PLUGIN_MODULE_INIT_MS,
                          GetHistogramKey(),
                          static_cast<uint32_t>(mTimeBlocked.ToMilliseconds()));
    mTimeBlocked = TimeDuration();
}

nsresult
PluginModuleParent::NPP_NewInternal(NPMIMEType pluginType, NPP instance,
                                    uint16_t mode,
                                    InfallibleTArray<nsCString>& names,
                                    InfallibleTArray<nsCString>& values,
                                    NPSavedData* saved, NPError* error)
{
    MOZ_ASSERT(names.Length() == values.Length());
    if (mPluginName.IsEmpty()) {
        GetPluginDetails();
        InitQuirksModes(nsDependentCString(pluginType));
        /** mTimeBlocked measures the time that the main thread has been blocked
         *  on plugin module initialization. As implemented, this is the sum of
         *  plugin-container launch + toolhelp32 snapshot + NP_Initialize.
         *  We don't accumulate its value until here because the plugin info
         *  for its histogram key is not available until *after* NP_Initialize.
         */
        AccumulateModuleInitBlockedTime();
    }

    nsCaseInsensitiveUTF8StringArrayComparator comparator;
    NS_NAMED_LITERAL_CSTRING(srcAttributeName, "src");
    auto srcAttributeIndex = names.IndexOf(srcAttributeName, 0, comparator);
    nsAutoCString srcAttribute;
    if (srcAttributeIndex != names.NoIndex) {
        srcAttribute = values[srcAttributeIndex];
    }

    nsDependentCString strPluginType(pluginType);
    PluginInstanceParent* parentInstance =
        new PluginInstanceParent(this, instance, strPluginType, mNPNIface);

    if (mIsFlashPlugin) {
        parentInstance->InitMetadata(strPluginType, srcAttribute);
#ifdef XP_WIN
        bool supportsAsyncRender =
          Preferences::GetBool("dom.ipc.plugins.asyncdrawing.enabled", false);
        if (supportsAsyncRender) {
          // Prefs indicates we want async plugin rendering, make sure
          // the flash module has support.
          CallModuleSupportsAsyncRender(&supportsAsyncRender);
        }
#ifdef _WIN64
        // For 64-bit builds force windowless if the flash library doesn't support
        // async rendering regardless of sandbox level.
        if (!supportsAsyncRender) {
#else
        // For 32-bit builds force windowless if the flash library doesn't support
        // async rendering and the sandbox level is 2 or greater.
        if (!supportsAsyncRender && mSandboxLevel >= 2) {
#endif
           NS_NAMED_LITERAL_CSTRING(wmodeAttributeName, "wmode");
           NS_NAMED_LITERAL_CSTRING(opaqueAttributeValue, "opaque");
           auto wmodeAttributeIndex =
               names.IndexOf(wmodeAttributeName, 0, comparator);
           if (wmodeAttributeIndex != names.NoIndex) {
               if (!values[wmodeAttributeIndex].EqualsLiteral("transparent")) {
                   values[wmodeAttributeIndex].Assign(opaqueAttributeValue);
               }
           } else {
               names.AppendElement(wmodeAttributeName);
               values.AppendElement(opaqueAttributeValue);
           }
        }
#endif
    }

    // Release the surrogate reference that was in pdata
    RefPtr<PluginAsyncSurrogate> surrogate(
        dont_AddRef(PluginAsyncSurrogate::Cast(instance)));
    // Now replace it with the instance
    instance->pdata = static_cast<PluginDataResolver*>(parentInstance);

    if (!SendPPluginInstanceConstructor(parentInstance,
                                        nsDependentCString(pluginType), mode,
                                        names, values)) {
        // |parentInstance| is automatically deleted.
        instance->pdata = nullptr;
        *error = NPERR_GENERIC_ERROR;
        return NS_ERROR_FAILURE;
    }

    {   // Scope for timer
        Telemetry::AutoTimer<Telemetry::BLOCKED_ON_PLUGIN_INSTANCE_INIT_MS>
            timer(GetHistogramKey());
        if (mIsStartingAsync) {
            MOZ_ASSERT(surrogate);
            surrogate->AsyncCallDeparting();
            if (!SendAsyncNPP_New(parentInstance)) {
                *error = NPERR_GENERIC_ERROR;
                return NS_ERROR_FAILURE;
            }
            *error = NPERR_NO_ERROR;
        } else {
            if (!CallSyncNPP_New(parentInstance, error)) {
                // if IPC is down, we'll get an immediate "failed" return, but
                // without *error being set.  So make sure that the error
                // condition is signaled to nsNPAPIPluginInstance
                if (NPERR_NO_ERROR == *error) {
                    *error = NPERR_GENERIC_ERROR;
                }
                return NS_ERROR_FAILURE;
            }
        }
    }

    if (*error != NPERR_NO_ERROR) {
        if (!mIsStartingAsync) {
            NPP_Destroy(instance, 0);
        }
        return NS_ERROR_FAILURE;
    }

    UpdatePluginTimeout();

    return NS_OK;
}

void
PluginModuleChromeParent::UpdatePluginTimeout()
{
    TimeoutChanged(kParentTimeoutPref, this);
}

nsresult
PluginModuleParent::NPP_ClearSiteData(const char* site, uint64_t flags, uint64_t maxAge,
                                      nsCOMPtr<nsIClearSiteDataCallback> callback)
{
    if (!mClearSiteDataSupported)
        return NS_ERROR_NOT_AVAILABLE;

    static uint64_t callbackId = 0;
    callbackId++;
    mClearSiteDataCallbacks[callbackId] = callback;

    if (!SendNPP_ClearSiteData(NullableString(site), flags, maxAge, callbackId)) {
        return NS_ERROR_FAILURE;
    }
    return NS_OK;
}


nsresult
PluginModuleParent::NPP_GetSitesWithData(nsCOMPtr<nsIGetSitesWithDataCallback> callback)
{
    if (!mGetSitesWithDataSupported)
        return NS_ERROR_NOT_AVAILABLE;

    static uint64_t callbackId = 0;
    callbackId++;
    mSitesWithDataCallbacks[callbackId] = callback;

    if (!SendNPP_GetSitesWithData(callbackId))
        return NS_ERROR_FAILURE;

    return NS_OK;
}

#if defined(XP_MACOSX)
nsresult
PluginModuleParent::IsRemoteDrawingCoreAnimation(NPP instance, bool *aDrawing)
{
    PluginInstanceParent* i = PluginInstanceParent::Cast(instance);
    if (!i)
        return NS_ERROR_FAILURE;

    return i->IsRemoteDrawingCoreAnimation(aDrawing);
}
#endif
#if defined(XP_MACOSX) || defined(XP_WIN)
nsresult
PluginModuleParent::ContentsScaleFactorChanged(NPP instance, double aContentsScaleFactor)
{
    PluginInstanceParent* i = PluginInstanceParent::Cast(instance);
    if (!i)
        return NS_ERROR_FAILURE;

    return i->ContentsScaleFactorChanged(aContentsScaleFactor);
}
#endif // #if defined(XP_MACOSX)

#if defined(XP_MACOSX)
bool
PluginModuleParent::AnswerProcessSomeEvents()
{
    mozilla::plugins::PluginUtilsOSX::InvokeNativeEventLoop();
    return true;
}

#elif !defined(MOZ_WIDGET_GTK)
bool
PluginModuleParent::AnswerProcessSomeEvents()
{
    NS_RUNTIMEABORT("unreached");
    return false;
}

#else
static const int kMaxChancesToProcessEvents = 20;

bool
PluginModuleParent::AnswerProcessSomeEvents()
{
    PLUGIN_LOG_DEBUG(("Spinning mini nested loop ..."));

    int i = 0;
    for (; i < kMaxChancesToProcessEvents; ++i)
        if (!g_main_context_iteration(nullptr, FALSE))
            break;

    PLUGIN_LOG_DEBUG(("... quitting mini nested loop; processed %i tasks", i));

    return true;
}
#endif

bool
PluginModuleParent::RecvProcessNativeEventsInInterruptCall()
{
    PLUGIN_LOG_DEBUG(("%s", FULLFUNCTION));
#if defined(OS_WIN)
    ProcessNativeEventsInInterruptCall();
    return true;
#else
    NS_NOTREACHED(
        "PluginModuleParent::RecvProcessNativeEventsInInterruptCall not implemented!");
    return false;
#endif
}

void
PluginModuleParent::ProcessRemoteNativeEventsInInterruptCall()
{
#if defined(OS_WIN)
    Unused << SendProcessNativeEventsInInterruptCall();
    return;
#endif
    NS_NOTREACHED(
        "PluginModuleParent::ProcessRemoteNativeEventsInInterruptCall not implemented!");
}

bool
PluginModuleParent::RecvPluginShowWindow(const uint32_t& aWindowId, const bool& aModal,
                                         const int32_t& aX, const int32_t& aY,
                                         const size_t& aWidth, const size_t& aHeight)
{
    PLUGIN_LOG_DEBUG(("%s", FULLFUNCTION));
#if defined(XP_MACOSX)
    CGRect windowBound = ::CGRectMake(aX, aY, aWidth, aHeight);
    mac_plugin_interposing::parent::OnPluginShowWindow(aWindowId, windowBound, aModal);
    return true;
#else
    NS_NOTREACHED(
        "PluginInstanceParent::RecvPluginShowWindow not implemented!");
    return false;
#endif
}

bool
PluginModuleParent::RecvPluginHideWindow(const uint32_t& aWindowId)
{
    PLUGIN_LOG_DEBUG(("%s", FULLFUNCTION));
#if defined(XP_MACOSX)
    mac_plugin_interposing::parent::OnPluginHideWindow(aWindowId, OtherPid());
    return true;
#else
    NS_NOTREACHED(
        "PluginInstanceParent::RecvPluginHideWindow not implemented!");
    return false;
#endif
}

PCrashReporterParent*
PluginModuleParent::AllocPCrashReporterParent(mozilla::dom::NativeThreadId* id,
                                              uint32_t* processType)
{
    MOZ_CRASH("unreachable");
}

bool
PluginModuleParent::DeallocPCrashReporterParent(PCrashReporterParent* actor)
{
    MOZ_CRASH("unreachable");
}

PCrashReporterParent*
PluginModuleChromeParent::AllocPCrashReporterParent(mozilla::dom::NativeThreadId* id,
                                                    uint32_t* processType)
{
#ifdef MOZ_CRASHREPORTER
    return new CrashReporterParent();
#else
    return nullptr;
#endif
}

bool
PluginModuleChromeParent::DeallocPCrashReporterParent(PCrashReporterParent* actor)
{
#ifdef MOZ_CRASHREPORTER
#ifdef XP_WIN
    mozilla::MutexAutoLock lock(mCrashReporterMutex);
    if (actor == static_cast<PCrashReporterParent*>(mCrashReporter)) {
        mCrashReporter = nullptr;
    }
#endif
#endif
    delete actor;
    return true;
}

bool
PluginModuleParent::RecvSetCursor(const NSCursorInfo& aCursorInfo)
{
    PLUGIN_LOG_DEBUG(("%s", FULLFUNCTION));
#if defined(XP_MACOSX)
    mac_plugin_interposing::parent::OnSetCursor(aCursorInfo);
    return true;
#else
    NS_NOTREACHED(
        "PluginInstanceParent::RecvSetCursor not implemented!");
    return false;
#endif
}

bool
PluginModuleParent::RecvShowCursor(const bool& aShow)
{
    PLUGIN_LOG_DEBUG(("%s", FULLFUNCTION));
#if defined(XP_MACOSX)
    mac_plugin_interposing::parent::OnShowCursor(aShow);
    return true;
#else
    NS_NOTREACHED(
        "PluginInstanceParent::RecvShowCursor not implemented!");
    return false;
#endif
}

bool
PluginModuleParent::RecvPushCursor(const NSCursorInfo& aCursorInfo)
{
    PLUGIN_LOG_DEBUG(("%s", FULLFUNCTION));
#if defined(XP_MACOSX)
    mac_plugin_interposing::parent::OnPushCursor(aCursorInfo);
    return true;
#else
    NS_NOTREACHED(
        "PluginInstanceParent::RecvPushCursor not implemented!");
    return false;
#endif
}

bool
PluginModuleParent::RecvPopCursor()
{
    PLUGIN_LOG_DEBUG(("%s", FULLFUNCTION));
#if defined(XP_MACOSX)
    mac_plugin_interposing::parent::OnPopCursor();
    return true;
#else
    NS_NOTREACHED(
        "PluginInstanceParent::RecvPopCursor not implemented!");
    return false;
#endif
}

bool
PluginModuleParent::RecvNPN_SetException(const nsCString& aMessage)
{
    PLUGIN_LOG_DEBUG(("%s", FULLFUNCTION));

    // This function ignores its first argument.
    mozilla::plugins::parent::_setexception(nullptr, NullableStringGet(aMessage));
    return true;
}

bool
PluginModuleParent::RecvNPN_ReloadPlugins(const bool& aReloadPages)
{
    PLUGIN_LOG_DEBUG(("%s", FULLFUNCTION));

    mozilla::plugins::parent::_reloadplugins(aReloadPages);
    return true;
}

bool
PluginModuleChromeParent::RecvNotifyContentModuleDestroyed()
{
    RefPtr<nsPluginHost> host = nsPluginHost::GetInst();
    if (host) {
        host->NotifyContentModuleDestroyed(mPluginId);
    }
    return true;
}

bool
PluginModuleParent::RecvReturnClearSiteData(const NPError& aRv,
                                            const uint64_t& aCallbackId)
{
    if (mClearSiteDataCallbacks.find(aCallbackId) == mClearSiteDataCallbacks.end()) {
        return true;
    }
    if (!!mClearSiteDataCallbacks[aCallbackId]) {
        nsresult rv;
        switch (aRv) {
        case NPERR_NO_ERROR:
            rv = NS_OK;
            break;
        case NPERR_TIME_RANGE_NOT_SUPPORTED:
            rv = NS_ERROR_PLUGIN_TIME_RANGE_NOT_SUPPORTED;
            break;
        case NPERR_MALFORMED_SITE:
            rv = NS_ERROR_INVALID_ARG;
            break;
        default:
            rv = NS_ERROR_FAILURE;
        }
        mClearSiteDataCallbacks[aCallbackId]->Callback(rv);
    }
    mClearSiteDataCallbacks.erase(aCallbackId);
    return true;
}

bool
PluginModuleParent::RecvReturnSitesWithData(nsTArray<nsCString>&& aSites,
                                            const uint64_t& aCallbackId)
{
    if (mSitesWithDataCallbacks.find(aCallbackId) == mSitesWithDataCallbacks.end()) {
        return true;
    }

    if (!!mSitesWithDataCallbacks[aCallbackId]) {
        mSitesWithDataCallbacks[aCallbackId]->SitesWithData(aSites);
    }
    mSitesWithDataCallbacks.erase(aCallbackId);
    return true;
}

layers::TextureClientRecycleAllocator*
PluginModuleParent::EnsureTextureAllocatorForDirectBitmap()
{
    if (!mTextureAllocatorForDirectBitmap) {
        mTextureAllocatorForDirectBitmap = new TextureClientRecycleAllocator(ImageBridgeChild::GetSingleton().get());
    }
    return mTextureAllocatorForDirectBitmap;
}

layers::TextureClientRecycleAllocator*
PluginModuleParent::EnsureTextureAllocatorForDXGISurface()
{
    if (!mTextureAllocatorForDXGISurface) {
        mTextureAllocatorForDXGISurface = new TextureClientRecycleAllocator(ImageBridgeChild::GetSingleton().get());
    }
    return mTextureAllocatorForDXGISurface;
}


bool
PluginModuleParent::AnswerNPN_SetValue_NPPVpluginRequiresAudioDeviceChanges(
                                        const bool& shouldRegister,
                                        NPError* result) {
    NS_RUNTIMEABORT("SetValue_NPPVpluginRequiresAudioDeviceChanges is only valid "
      "with PluginModuleChromeParent");
    *result = NPERR_GENERIC_ERROR;
    return true;
}

#ifdef MOZ_CRASHREPORTER_INJECTOR

// We only add the crash reporter to subprocess which have the filename
// FlashPlayerPlugin*
#define FLASH_PROCESS_PREFIX "FLASHPLAYERPLUGIN"

static DWORD
GetFlashChildOfPID(DWORD pid, HANDLE snapshot)
{
    PROCESSENTRY32 entry = {
        sizeof(entry)
    };
    for (BOOL ok = Process32First(snapshot, &entry);
         ok;
         ok = Process32Next(snapshot, &entry)) {
        if (entry.th32ParentProcessID == pid) {
            nsString name(entry.szExeFile);
            ToUpperCase(name);
            if (StringBeginsWith(name, NS_LITERAL_STRING(FLASH_PROCESS_PREFIX))) {
                return entry.th32ProcessID;
            }
        }
    }
    return 0;
}

// We only look for child processes of the Flash plugin, NPSWF*
#define FLASH_PLUGIN_PREFIX "NPSWF"

void
PluginModuleChromeParent::InitializeInjector()
{
    if (!Preferences::GetBool("dom.ipc.plugins.flash.subprocess.crashreporter.enabled", false))
        return;

    nsCString path(Process()->GetPluginFilePath().c_str());
    ToUpperCase(path);
    int32_t lastSlash = path.RFindCharInSet("\\/");
    if (kNotFound == lastSlash)
        return;

    if (!StringBeginsWith(Substring(path, lastSlash + 1),
                          NS_LITERAL_CSTRING(FLASH_PLUGIN_PREFIX)))
        return;

    TimeStamp th32Start = TimeStamp::Now();
    mFinishInitTask = mChromeTaskFactory.NewTask<FinishInjectorInitTask>();
    mFinishInitTask->Init(this);
    if (!::QueueUserWorkItem(&PluginModuleChromeParent::GetToolhelpSnapshot,
                             mFinishInitTask, WT_EXECUTEDEFAULT)) {
        mFinishInitTask = nullptr;
        return;
    }
    TimeStamp th32End = TimeStamp::Now();
    mTimeBlocked += (th32End - th32Start);
}

void
PluginModuleChromeParent::DoInjection(const nsAutoHandle& aSnapshot)
{
    DWORD pluginProcessPID = GetProcessId(Process()->GetChildProcessHandle());
    mFlashProcess1 = GetFlashChildOfPID(pluginProcessPID, aSnapshot);
    if (mFlashProcess1) {
        InjectCrashReporterIntoProcess(mFlashProcess1, this);

        mFlashProcess2 = GetFlashChildOfPID(mFlashProcess1, aSnapshot);
        if (mFlashProcess2) {
            InjectCrashReporterIntoProcess(mFlashProcess2, this);
        }
    }
    mFinishInitTask = nullptr;
}

DWORD WINAPI
PluginModuleChromeParent::GetToolhelpSnapshot(LPVOID aContext)
{
    FinishInjectorInitTask* task = static_cast<FinishInjectorInitTask*>(aContext);
    MOZ_ASSERT(task);
    task->PostToMainThread();
    return 0;
}

void
PluginModuleChromeParent::OnCrash(DWORD processID)
{
    if (!mShutdown) {
        GetIPCChannel()->CloseWithError();
        mozilla::ipc::ScopedProcessHandle geckoPluginChild;
        if (base::OpenProcessHandle(OtherPid(), &geckoPluginChild.rwget())) {
            if (!base::KillProcess(geckoPluginChild,
                                   base::PROCESS_END_KILLED_BY_USER, false)) {
                NS_ERROR("May have failed to kill child process.");
            }
        } else {
            NS_ERROR("Failed to open child process when attempting kill.");
        }
    }
}

#endif // MOZ_CRASHREPORTER_INJECTOR

#ifdef MOZ_ENABLE_PROFILER_SPS
class PluginProfilerObserver final : public nsIObserver,
                                     public nsSupportsWeakReference
{
public:
    NS_DECL_ISUPPORTS
    NS_DECL_NSIOBSERVER

    explicit PluginProfilerObserver(PluginModuleChromeParent* pmp)
      : mPmp(pmp)
    {}

private:
    ~PluginProfilerObserver() {}
    PluginModuleChromeParent* mPmp;
};

NS_IMPL_ISUPPORTS(PluginProfilerObserver, nsIObserver, nsISupportsWeakReference)

NS_IMETHODIMP
PluginProfilerObserver::Observe(nsISupports *aSubject,
                                const char *aTopic,
                                const char16_t *aData)
{
    if (!strcmp(aTopic, "profiler-started")) {
        nsCOMPtr<nsIProfilerStartParams> params(do_QueryInterface(aSubject));
        mPmp->StartProfiler(params);
    } else if (!strcmp(aTopic, "profiler-stopped")) {
        mPmp->StopProfiler();
    } else if (!strcmp(aTopic, "profiler-subprocess-gather")) {
        mPmp->GatherAsyncProfile();
    } else if (!strcmp(aTopic, "profiler-subprocess")) {
        nsCOMPtr<nsIProfileSaveEvent> pse = do_QueryInterface(aSubject);
        mPmp->GatheredAsyncProfile(pse);
    }
    return NS_OK;
}

void
PluginModuleChromeParent::InitPluginProfiling()
{
    nsCOMPtr<nsIObserverService> observerService = mozilla::services::GetObserverService();
    if (observerService) {
        mProfilerObserver = new PluginProfilerObserver(this);
        observerService->AddObserver(mProfilerObserver, "profiler-started", false);
        observerService->AddObserver(mProfilerObserver, "profiler-stopped", false);
        observerService->AddObserver(mProfilerObserver, "profiler-subprocess-gather", false);
        observerService->AddObserver(mProfilerObserver, "profiler-subprocess", false);
    }
}

void
PluginModuleChromeParent::ShutdownPluginProfiling()
{
    nsCOMPtr<nsIObserverService> observerService = mozilla::services::GetObserverService();
    if (observerService) {
        observerService->RemoveObserver(mProfilerObserver, "profiler-started");
        observerService->RemoveObserver(mProfilerObserver, "profiler-stopped");
        observerService->RemoveObserver(mProfilerObserver, "profiler-subprocess-gather");
        observerService->RemoveObserver(mProfilerObserver, "profiler-subprocess");
    }
}

void
PluginModuleChromeParent::StartProfiler(nsIProfilerStartParams* aParams)
{
    if (NS_WARN_IF(!aParams)) {
        return;
    }

    ProfilerInitParams ipcParams;

    ipcParams.enabled() = true;
    aParams->GetEntries(&ipcParams.entries());
    aParams->GetInterval(&ipcParams.interval());
    ipcParams.features() = aParams->GetFeatures();
    ipcParams.threadFilters() = aParams->GetThreadFilterNames();

    Unused << SendStartProfiler(ipcParams);

    nsCOMPtr<nsIProfiler> profiler(do_GetService("@mozilla.org/tools/profiler;1"));
    if (NS_WARN_IF(!profiler)) {
        return;
    }
    nsCOMPtr<nsISupports> gatherer;
    profiler->GetProfileGatherer(getter_AddRefs(gatherer));
    mGatherer = static_cast<ProfileGatherer*>(gatherer.get());
}

void
PluginModuleChromeParent::StopProfiler()
{
    mGatherer = nullptr;
    Unused << SendStopProfiler();
}

void
PluginModuleChromeParent::GatherAsyncProfile()
{
    if (NS_WARN_IF(!mGatherer)) {
        return;
    }
    mGatherer->WillGatherOOPProfile();
    Unused << SendGatherProfile();
}

void
PluginModuleChromeParent::GatheredAsyncProfile(nsIProfileSaveEvent* aSaveEvent)
{
    if (aSaveEvent && !mProfile.IsEmpty()) {
        aSaveEvent->AddSubProfile(mProfile.get());
        mProfile.Truncate();
    }
}
#endif // MOZ_ENABLE_PROFILER_SPS

bool
PluginModuleChromeParent::RecvProfile(const nsCString& aProfile)
{
#ifdef MOZ_ENABLE_PROFILER_SPS
    if (NS_WARN_IF(!mGatherer)) {
        return true;
    }

    mProfile = aProfile;
    mGatherer->GatheredOOPProfile();
#endif
    return true;
}

bool
PluginModuleParent::AnswerGetKeyState(const int32_t& aVirtKey, int16_t* aRet)
{
    return false;
}

bool
PluginModuleChromeParent::AnswerGetKeyState(const int32_t& aVirtKey,
                                            int16_t* aRet)
{
#if defined(XP_WIN)
    *aRet = ::GetKeyState(aVirtKey);
    return true;
#else
    return PluginModuleParent::AnswerGetKeyState(aVirtKey, aRet);
#endif
}
