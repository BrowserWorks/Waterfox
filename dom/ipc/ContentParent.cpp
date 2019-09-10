/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/DebugOnly.h"

#include "base/basictypes.h"
#include "base/shared_memory.h"

#include "ContentParent.h"
#include "ProcessUtils.h"
#include "BrowserParent.h"

#if defined(ANDROID) || defined(LINUX)
#  include <sys/time.h>
#  include <sys/resource.h>
#endif

#include "chrome/common/process_watcher.h"

#include "mozilla/a11y/PDocAccessible.h"
#include "GeckoProfiler.h"
#include "GMPServiceParent.h"
#include "HandlerServiceParent.h"
#include "IHistory.h"
#include "imgIContainer.h"
#if defined(XP_WIN) && defined(ACCESSIBILITY)
#  include "mozilla/a11y/AccessibleWrap.h"
#  include "mozilla/a11y/Compatibility.h"
#endif
#include "mozilla/AntiTrackingCommon.h"
#include "mozilla/BasePrincipal.h"
#include "mozilla/ClearOnShutdown.h"
#include "mozilla/Components.h"
#include "mozilla/StyleSheetInlines.h"
#include "mozilla/DataStorage.h"
#include "mozilla/devtools/HeapSnapshotTempFileHelperParent.h"
#include "mozilla/docshell/OfflineCacheUpdateParent.h"
#include "mozilla/dom/BrowsingContext.h"
#include "mozilla/dom/BrowsingContextGroup.h"
#include "mozilla/dom/CancelContentJSOptionsBinding.h"
#include "mozilla/dom/CanonicalBrowsingContext.h"
#include "mozilla/dom/ClientManager.h"
#include "mozilla/dom/ClientOpenWindowOpActors.h"
#include "mozilla/dom/ContentChild.h"
#include "mozilla/dom/DataTransfer.h"
#include "mozilla/dom/Element.h"
#include "mozilla/dom/File.h"
#include "mozilla/dom/FileSystemSecurity.h"
#include "mozilla/dom/IPCBlobInputStreamParent.h"
#include "mozilla/dom/IPCBlobUtils.h"
#include "mozilla/dom/ExternalHelperAppParent.h"
#include "mozilla/dom/GetFilesHelper.h"
#include "mozilla/dom/GeolocationBinding.h"
#include "mozilla/dom/JSWindowActorService.h"
#include "mozilla/dom/LocalStorageCommon.h"
#include "mozilla/dom/MemoryReportRequest.h"
#include "mozilla/dom/Notification.h"
#include "mozilla/dom/PContentPermissionRequestParent.h"
#include "mozilla/dom/PCycleCollectWithLogsParent.h"
#include "mozilla/dom/PositionError.h"
#include "mozilla/dom/ServiceWorkerRegistrar.h"
#include "mozilla/dom/power/PowerManagerService.h"
#include "mozilla/dom/Permissions.h"
#include "mozilla/dom/PresentationParent.h"
#include "mozilla/dom/PPresentationParent.h"
#include "mozilla/dom/PushNotifier.h"
#include "mozilla/dom/quota/QuotaManagerService.h"
#include "mozilla/dom/ServiceWorkerUtils.h"
#include "mozilla/dom/URLClassifierParent.h"
#include "mozilla/dom/ipc/SharedMap.h"
#include "mozilla/embedding/printingui/PrintingParent.h"
#include "mozilla/extensions/StreamFilterParent.h"
#include "mozilla/gfx/gfxVars.h"
#include "mozilla/gfx/GPUProcessManager.h"
#include "mozilla/hal_sandbox/PHalParent.h"
#include "mozilla/ipc/BackgroundChild.h"
#include "mozilla/ipc/BackgroundParent.h"
#include "mozilla/ipc/CrashReporterHost.h"
#include "mozilla/ipc/FileDescriptorSetParent.h"
#include "mozilla/ipc/FileDescriptorUtils.h"
#include "mozilla/ipc/PChildToParentStreamParent.h"
#include "mozilla/ipc/TestShellParent.h"
#include "mozilla/ipc/IPCStreamUtils.h"
#include "mozilla/ipc/IPCStreamAlloc.h"
#include "mozilla/ipc/IPCStreamDestination.h"
#include "mozilla/ipc/IPCStreamSource.h"
#include "mozilla/intl/LocaleService.h"
#include "mozilla/jsipc/CrossProcessObjectWrappers.h"
#include "mozilla/layers/PAPZParent.h"
#include "mozilla/layers/CompositorThread.h"
#include "mozilla/layers/ImageBridgeParent.h"
#include "mozilla/layers/LayerTreeOwnerTracker.h"
#include "mozilla/loader/ScriptCacheActors.h"
#include "mozilla/LoginReputationIPC.h"
#include "mozilla/dom/StorageIPC.h"
#include "mozilla/LookAndFeel.h"
#include "mozilla/media/MediaParent.h"
#include "mozilla/Move.h"
#include "mozilla/net/NeckoParent.h"
#include "mozilla/net/CookieServiceParent.h"
#include "mozilla/net/PCookieServiceParent.h"
#include "mozilla/plugins/PluginBridge.h"
#include "mozilla/Preferences.h"
#include "mozilla/PresShell.h"
#include "mozilla/ProcessHangMonitor.h"
#include "mozilla/ProcessHangMonitorIPC.h"
#include "mozilla/RDDProcessManager.h"
#include "mozilla/recordreplay/ParentIPC.h"
#include "mozilla/ScopeExit.h"
#include "mozilla/ScriptPreloader.h"
#include "mozilla/Services.h"
#include "mozilla/StaticPtr.h"
#include "mozilla/StaticPrefs.h"
#include "mozilla/Telemetry.h"
#include "mozilla/TelemetryIPC.h"
#include "mozilla/WebBrowserPersistDocumentParent.h"
#include "mozilla/widget/ScreenManager.h"
#include "mozilla/Unused.h"
#include "mozilla/HangDetails.h"
#include "nsAnonymousTemporaryFile.h"
#include "nsAppRunner.h"
#include "nsCExternalHandlerService.h"
#include "nsCOMPtr.h"
#include "nsChromeRegistryChrome.h"
#include "nsConsoleMessage.h"
#include "nsConsoleService.h"
#include "nsContentUtils.h"
#include "nsDebugImpl.h"
#include "nsDirectoryServiceDefs.h"
#include "nsEmbedCID.h"
#include "nsFrameLoader.h"
#include "nsFrameMessageManager.h"
#include "nsHashPropertyBag.h"
#include "nsIAlertsService.h"
#include "nsIAppStartup.h"
#include "nsIClipboard.h"
#include "nsICookie.h"
#include "nsContentPermissionHelper.h"
#include "nsIContentSecurityPolicy.h"
#include "nsIContentProcess.h"
#include "nsICycleCollectorListener.h"
#include "nsIDocShellTreeOwner.h"
#include "mozilla/dom/Document.h"
#include "nsGeolocation.h"
#include "nsIDragService.h"
#include "mozilla/dom/WakeLock.h"
#include "nsIDOMWindow.h"
#include "nsIExternalProtocolService.h"
#include "nsIFormProcessor.h"
#include "nsIGfxInfo.h"
#include "nsIIdleService.h"
#include "nsIInterfaceRequestorUtils.h"
#include "nsILocalStorageManager.h"
#include "nsIMemoryInfoDumper.h"
#include "nsIMemoryReporter.h"
#include "nsIMozBrowserFrame.h"
#include "nsIMutable.h"
#include "nsINetworkLinkService.h"
#include "nsIObserverService.h"
#include "nsIParentChannel.h"
#include "nsIRemoteWindowContext.h"
#include "nsIScriptError.h"
#include "nsIScriptSecurityManager.h"
#include "nsISearchService.h"
#include "nsIServiceWorkerManager.h"
#include "nsISiteSecurityService.h"
#include "nsISound.h"
#include "mozilla/mozSpellChecker.h"
#include "nsIStringBundle.h"
#include "nsISupportsPrimitives.h"
#include "nsITimer.h"
#include "nsIURIFixup.h"
#include "nsIURL.h"
#include "nsIDocShellTreeOwner.h"
#include "nsIXULWindow.h"
#include "nsIDOMChromeWindow.h"
#include "nsIWindowWatcher.h"
#include "nsPIWindowWatcher.h"
#include "nsThread.h"
#include "nsWindowWatcher.h"
#include "nsIXULRuntime.h"
#include "mozilla/dom/ParentProcessMessageManager.h"
#include "mozilla/dom/ProcessMessageManager.h"
#include "mozilla/dom/nsMixedContentBlocker.h"
#include "nsMemoryInfoDumper.h"
#include "nsMemoryReporterManager.h"
#include "nsQueryObject.h"
#include "nsScriptError.h"
#include "nsServiceManagerUtils.h"
#include "nsStyleSheetService.h"
#include "nsThreadUtils.h"
#include "nsWidgetsCID.h"
#include "PreallocatedProcessManager.h"
#include "ProcessPriorityManager.h"
#include "SandboxHal.h"
#include "SourceSurfaceRawData.h"
#include "BrowserParent.h"
#include "URIUtils.h"
#include "nsIWebBrowserChrome.h"
#include "nsIDocShell.h"
#include "nsDocShell.h"
#include "nsOpenURIInFrameParams.h"
#include "mozilla/net/NeckoMessageUtils.h"
#include "gfxPlatform.h"
#include "gfxPlatformFontList.h"
#include "gfxPrefs.h"
#include "prio.h"
#include "private/pprio.h"
#include "ContentProcessManager.h"
#include "mozilla/dom/BlobURLProtocolHandler.h"
#include "mozilla/dom/ipc/StructuredCloneData.h"
#include "mozilla/PerformanceMetricsCollector.h"
#include "mozilla/psm/PSMContentListener.h"
#include "nsPluginHost.h"
#include "nsPluginTags.h"
#include "nsIBlocklistService.h"
#include "mozilla/StyleSheet.h"
#include "mozilla/StyleSheetInlines.h"
#include "nsICaptivePortalService.h"
#include "nsIObjectLoadingContent.h"
#include "nsIBidiKeyboard.h"
#include "nsLayoutStylesheetCache.h"
#include "MMPrinter.h"

#include "mozilla/Sprintf.h"

#ifdef MOZ_WEBRTC
#  include "signaling/src/peerconnection/WebrtcGlobalParent.h"
#endif

#if defined(XP_MACOSX)
#  include "nsMacUtilsImpl.h"
#endif

#if defined(ANDROID) || defined(LINUX)
#  include "nsSystemInfo.h"
#endif

#if defined(XP_LINUX)
#  include "mozilla/Hal.h"
#endif

#ifdef ANDROID
#  include "gfxAndroidPlatform.h"
#endif

#include "nsPermissionManager.h"

#ifdef MOZ_WIDGET_ANDROID
#  include "AndroidBridge.h"
#endif

#ifdef MOZ_WIDGET_GTK
#  include <gdk/gdk.h>
#endif

#include "mozilla/RemoteSpellCheckEngineParent.h"

#include "Crypto.h"

#ifdef MOZ_WEBSPEECH
#  include "mozilla/dom/SpeechSynthesisParent.h"
#endif

#if defined(MOZ_SANDBOX)
#  include "mozilla/SandboxSettings.h"
#  if defined(XP_LINUX)
#    include "mozilla/SandboxInfo.h"
#    include "mozilla/SandboxBroker.h"
#    include "mozilla/SandboxBrokerPolicyFactory.h"
#  endif
#  if defined(XP_MACOSX)
#    include "mozilla/Sandbox.h"
#  endif
#endif

#ifdef XP_WIN
#  include "mozilla/audio/AudioNotificationSender.h"
#  include "mozilla/widget/AudioSession.h"
#endif

#ifdef ACCESSIBILITY
#  include "nsAccessibilityService.h"
#endif

#ifdef MOZ_GECKO_PROFILER
#  include "nsIProfiler.h"
#  include "ProfilerParent.h"
#endif

#ifdef MOZ_CODE_COVERAGE
#  include "mozilla/CodeCoverageHandler.h"
#endif

// For VP9Benchmark::sBenchmarkFpsPref
#include "Benchmark.h"

// XXX need another bug to move this to a common header.
#ifdef DISABLE_ASSERTS_FOR_FUZZING
#  define ASSERT_UNLESS_FUZZING(...) \
    do {                             \
    } while (0)
#else
#  define ASSERT_UNLESS_FUZZING(...) MOZ_ASSERT(false, __VA_ARGS__)
#endif

static NS_DEFINE_CID(kCClipboardCID, NS_CLIPBOARD_CID);

using base::KillProcess;

using namespace CrashReporter;
using namespace mozilla::dom::power;
using namespace mozilla::media;
using namespace mozilla::embedding;
using namespace mozilla::gfx;
using namespace mozilla::gmp;
using namespace mozilla::hal;
using namespace mozilla::ipc;
using namespace mozilla::intl;
using namespace mozilla::layers;
using namespace mozilla::layout;
using namespace mozilla::net;
using namespace mozilla::jsipc;
using namespace mozilla::psm;
using namespace mozilla::widget;
using mozilla::loader::PScriptCacheParent;
using mozilla::Telemetry::ProcessID;

// XXX Workaround for bug 986973 to maintain the existing broken semantics
template <>
struct nsIConsoleService::COMTypeInfo<nsConsoleService, void> {
  static const nsIID kIID;
};
const nsIID nsIConsoleService::COMTypeInfo<nsConsoleService, void>::kIID =
    NS_ICONSOLESERVICE_IID;

namespace mozilla {
namespace CubebUtils {
extern FileDescriptor CreateAudioIPCConnection();
}

namespace dom {

#define NS_IPC_IOSERVICE_SET_OFFLINE_TOPIC "ipc:network:set-offline"
#define NS_IPC_IOSERVICE_SET_CONNECTIVITY_TOPIC "ipc:network:set-connectivity"

// IPC receiver for remote GC/CC logging.
class CycleCollectWithLogsParent final : public PCycleCollectWithLogsParent {
 public:
  ~CycleCollectWithLogsParent() { MOZ_COUNT_DTOR(CycleCollectWithLogsParent); }

  static bool AllocAndSendConstructor(ContentParent* aManager,
                                      bool aDumpAllTraces,
                                      nsICycleCollectorLogSink* aSink,
                                      nsIDumpGCAndCCLogsCallback* aCallback) {
    CycleCollectWithLogsParent* actor;
    FILE* gcLog;
    FILE* ccLog;
    nsresult rv;

    actor = new CycleCollectWithLogsParent(aSink, aCallback);
    rv = actor->mSink->Open(&gcLog, &ccLog);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      delete actor;
      return false;
    }

    return aManager->SendPCycleCollectWithLogsConstructor(
        actor, aDumpAllTraces, FILEToFileDescriptor(gcLog),
        FILEToFileDescriptor(ccLog));
  }

 private:
  virtual mozilla::ipc::IPCResult RecvCloseGCLog() override {
    Unused << mSink->CloseGCLog();
    return IPC_OK();
  }

  virtual mozilla::ipc::IPCResult RecvCloseCCLog() override {
    Unused << mSink->CloseCCLog();
    return IPC_OK();
  }

  virtual mozilla::ipc::IPCResult Recv__delete__() override {
    // Report completion to mCallback only on successful
    // completion of the protocol.
    nsCOMPtr<nsIFile> gcLog, ccLog;
    mSink->GetGcLog(getter_AddRefs(gcLog));
    mSink->GetCcLog(getter_AddRefs(ccLog));
    Unused << mCallback->OnDump(gcLog, ccLog, /* parent = */ false);
    return IPC_OK();
  }

  virtual void ActorDestroy(ActorDestroyReason aReason) override {
    // If the actor is unexpectedly destroyed, we deliberately
    // don't call Close[GC]CLog on the sink, because the logs may
    // be incomplete.  See also the nsCycleCollectorLogSinkToFile
    // implementaiton of those methods, and its destructor.
  }

  CycleCollectWithLogsParent(nsICycleCollectorLogSink* aSink,
                             nsIDumpGCAndCCLogsCallback* aCallback)
      : mSink(aSink), mCallback(aCallback) {
    MOZ_COUNT_CTOR(CycleCollectWithLogsParent);
  }

  nsCOMPtr<nsICycleCollectorLogSink> mSink;
  nsCOMPtr<nsIDumpGCAndCCLogsCallback> mCallback;
};

// A memory reporter for ContentParent objects themselves.
class ContentParentsMemoryReporter final : public nsIMemoryReporter {
  ~ContentParentsMemoryReporter() {}

 public:
  NS_DECL_ISUPPORTS
  NS_DECL_NSIMEMORYREPORTER
};

NS_IMPL_ISUPPORTS(ContentParentsMemoryReporter, nsIMemoryReporter)

NS_IMETHODIMP
ContentParentsMemoryReporter::CollectReports(
    nsIHandleReportCallback* aHandleReport, nsISupports* aData,
    bool aAnonymize) {
  AutoTArray<ContentParent*, 16> cps;
  ContentParent::GetAllEvenIfDead(cps);

  for (uint32_t i = 0; i < cps.Length(); i++) {
    ContentParent* cp = cps[i];
    MessageChannel* channel = cp->GetIPCChannel();

    nsString friendlyName;
    cp->FriendlyName(friendlyName, aAnonymize);

    cp->AddRef();
    nsrefcnt refcnt = cp->Release();

    const char* channelStr = "no channel";
    uint32_t numQueuedMessages = 0;
    if (channel) {
      if (channel->Unsound_IsClosed()) {
        channelStr = "closed channel";
      } else {
        channelStr = "open channel";
      }
      numQueuedMessages = channel->Unsound_NumQueuedMessages();
    }

    nsPrintfCString path(
        "queued-ipc-messages/content-parent"
        "(%s, pid=%d, %s, 0x%p, refcnt=%" PRIuPTR ")",
        NS_ConvertUTF16toUTF8(friendlyName).get(), cp->Pid(), channelStr,
        static_cast<nsIObserver*>(cp), refcnt);

    NS_NAMED_LITERAL_CSTRING(
        desc,
        "The number of unset IPC messages held in this ContentParent's "
        "channel.  A large value here might indicate that we're leaking "
        "messages.  Similarly, a ContentParent object for a process that's no "
        "longer running could indicate that we're leaking ContentParents.");

    aHandleReport->Callback(/* process */ EmptyCString(), path, KIND_OTHER,
                            UNITS_COUNT, numQueuedMessages, desc, aData);
  }

  return NS_OK;
}

nsClassHashtable<nsStringHashKey, nsTArray<ContentParent*>>*
    ContentParent::sBrowserContentParents;

namespace {

class ScriptableCPInfo final : public nsIContentProcessInfo {
 public:
  explicit ScriptableCPInfo(ContentParent* aParent) : mContentParent(aParent) {
    MOZ_ASSERT(mContentParent);
  }

  NS_DECL_ISUPPORTS
  NS_DECL_NSICONTENTPROCESSINFO

  void ProcessDied() { mContentParent = nullptr; }

 private:
  ~ScriptableCPInfo() { MOZ_ASSERT(!mContentParent, "must call ProcessDied"); }

  ContentParent* mContentParent;
};

NS_IMPL_ISUPPORTS(ScriptableCPInfo, nsIContentProcessInfo)

NS_IMETHODIMP
ScriptableCPInfo::GetIsAlive(bool* aIsAlive) {
  *aIsAlive = mContentParent != nullptr;
  return NS_OK;
}

NS_IMETHODIMP
ScriptableCPInfo::GetProcessId(int32_t* aPID) {
  if (!mContentParent) {
    *aPID = -1;
    return NS_ERROR_NOT_INITIALIZED;
  }

  *aPID = mContentParent->Pid();
  if (*aPID == -1) {
    return NS_ERROR_FAILURE;
  }

  return NS_OK;
}

NS_IMETHODIMP
ScriptableCPInfo::GetOpener(nsIContentProcessInfo** aInfo) {
  *aInfo = nullptr;
  if (!mContentParent) {
    return NS_ERROR_NOT_INITIALIZED;
  }

  if (ContentParent* opener = mContentParent->Opener()) {
    nsCOMPtr<nsIContentProcessInfo> info = opener->ScriptableHelper();
    info.forget(aInfo);
  }
  return NS_OK;
}

NS_IMETHODIMP
ScriptableCPInfo::GetTabCount(int32_t* aTabCount) {
  if (!mContentParent) {
    return NS_ERROR_NOT_INITIALIZED;
  }

  ContentProcessManager* cpm = ContentProcessManager::GetSingleton();
  *aTabCount = cpm->GetBrowserParentCountByProcessId(mContentParent->ChildID());

  return NS_OK;
}

NS_IMETHODIMP
ScriptableCPInfo::GetMessageManager(nsISupports** aMessenger) {
  *aMessenger = nullptr;
  if (!mContentParent) {
    return NS_ERROR_NOT_INITIALIZED;
  }

  RefPtr<ProcessMessageManager> manager = mContentParent->GetMessageManager();
  manager.forget(aMessenger);
  return NS_OK;
}

ProcessID GetTelemetryProcessID(const nsAString& remoteType) {
  // OOP WebExtensions run in a content process.
  // For Telemetry though we want to break out collected data from the
  // WebExtensions process into a separate bucket, to make sure we can analyze
  // it separately and avoid skewing normal content process metrics.
  return remoteType.EqualsLiteral(EXTENSION_REMOTE_TYPE) ? ProcessID::Extension
                                                         : ProcessID::Content;
}

}  // anonymous namespace

nsDataHashtable<nsUint32HashKey, ContentParent*>*
    ContentParent::sJSPluginContentParents;
nsTArray<ContentParent*>* ContentParent::sPrivateContent;
StaticAutoPtr<LinkedList<ContentParent>> ContentParent::sContentParents;
#if defined(XP_LINUX) && defined(MOZ_SANDBOX)
UniquePtr<SandboxBrokerPolicyFactory>
    ContentParent::sSandboxBrokerPolicyFactory;
#endif
uint64_t ContentParent::sNextRemoteTabId = 0;
nsDataHashtable<nsUint64HashKey, BrowserParent*>
    ContentParent::sNextBrowserParents;
#if defined(XP_MACOSX) && defined(MOZ_SANDBOX)
StaticAutoPtr<std::vector<std::string>> ContentParent::sMacSandboxParams;
#endif

// Whether a private docshell has been seen before.
static bool sHasSeenPrivateDocShell = false;

// This is true when subprocess launching is enabled.  This is the
// case between StartUp() and ShutDown().
static bool sCanLaunchSubprocesses;

// Set to true if the DISABLE_UNSAFE_CPOW_WARNINGS environment variable is
// set.
static bool sDisableUnsafeCPOWWarnings = false;

// The first content child has ID 1, so the chrome process can have ID 0.
static uint64_t gContentChildID = 1;

static const char* sObserverTopics[] = {
    "xpcom-shutdown",
    "profile-before-change",
    NS_IPC_IOSERVICE_SET_OFFLINE_TOPIC,
    NS_IPC_IOSERVICE_SET_CONNECTIVITY_TOPIC,
    NS_IPC_CAPTIVE_PORTAL_SET_STATE,
    "memory-pressure",
    "child-gc-request",
    "child-cc-request",
    "child-mmu-request",
    "child-ghost-request",
    "last-pb-context-exited",
    "file-watcher-update",
#ifdef ACCESSIBILITY
    "a11y-init-or-shutdown",
#endif
    "cacheservice:empty-cache",
    "intl:app-locales-changed",
    "intl:requested-locales-changed",
    "cookie-changed",
    "private-cookie-changed",
    NS_NETWORK_LINK_TYPE_TOPIC,
};

#if defined(XP_MACOSX) && defined(MOZ_SANDBOX)
bool ContentParent::sEarlySandboxInit = false;
#endif

// PreallocateProcess is called by the PreallocatedProcessManager.
// ContentParent then takes this process back within GetNewOrUsedBrowserProcess.
/*static*/ RefPtr<ContentParent::LaunchPromise>
ContentParent::PreallocateProcess() {
  RefPtr<ContentParent> process = new ContentParent(
      /* aOpener = */ nullptr, NS_LITERAL_STRING(DEFAULT_REMOTE_TYPE),
      eNotRecordingOrReplaying,
      /* aRecordingFile = */ EmptyString());

  return process->LaunchSubprocessAsync(PROCESS_PRIORITY_PREALLOC);
}

/*static*/
void ContentParent::StartUp() {
  // We could launch sub processes from content process
  // FIXME Bug 1023701 - Stop using ContentParent static methods in
  // child process
  sCanLaunchSubprocesses = true;

  if (!XRE_IsParentProcess()) {
    return;
  }

  // Note: This reporter measures all ContentParents.
  RegisterStrongMemoryReporter(new ContentParentsMemoryReporter());

  BackgroundChild::Startup();
  ClientManager::Startup();

  sDisableUnsafeCPOWWarnings = PR_GetEnv("DISABLE_UNSAFE_CPOW_WARNINGS");

#if defined(XP_LINUX) && defined(MOZ_SANDBOX)
  sSandboxBrokerPolicyFactory = MakeUnique<SandboxBrokerPolicyFactory>();
#endif

#if defined(XP_MACOSX) && defined(MOZ_SANDBOX)
  sMacSandboxParams = new std::vector<std::string>;
#endif
}

/*static*/
void ContentParent::ShutDown() {
  // No-op for now.  We rely on normal process shutdown and
  // ClearOnShutdown() to clean up our state.
  sCanLaunchSubprocesses = false;

#if defined(XP_LINUX) && defined(MOZ_SANDBOX)
  sSandboxBrokerPolicyFactory = nullptr;
#endif

#if defined(XP_MACOSX) && defined(MOZ_SANDBOX)
  sMacSandboxParams = nullptr;
#endif
}

/*static*/
uint32_t ContentParent::GetPoolSize(const nsAString& aContentProcessType) {
  if (!sBrowserContentParents) {
    return 0;
  }

  nsTArray<ContentParent*>* parents =
      sBrowserContentParents->Get(aContentProcessType);

  return parents ? parents->Length() : 0;
}

/*static*/ nsTArray<ContentParent*>& ContentParent::GetOrCreatePool(
    const nsAString& aContentProcessType) {
  if (!sBrowserContentParents) {
    sBrowserContentParents =
        new nsClassHashtable<nsStringHashKey, nsTArray<ContentParent*>>;
  }

  return *sBrowserContentParents->LookupOrAdd(aContentProcessType);
}

/*static*/
uint32_t ContentParent::GetMaxProcessCount(
    const nsAString& aContentProcessType) {
  if (aContentProcessType.EqualsLiteral("web")) {
    return GetMaxWebProcessCount();
  }

  nsAutoCString processCountPref("dom.ipc.processCount.");
  processCountPref.Append(NS_ConvertUTF16toUTF8(aContentProcessType));

  int32_t maxContentParents;
  if (NS_FAILED(
          Preferences::GetInt(processCountPref.get(), &maxContentParents))) {
    maxContentParents = Preferences::GetInt("dom.ipc.processCount", 1);
  }

  if (maxContentParents < 1) {
    maxContentParents = 1;
  }

  return static_cast<uint32_t>(maxContentParents);
}

/*static*/
bool ContentParent::IsMaxProcessCountReached(
    const nsAString& aContentProcessType) {
  return GetPoolSize(aContentProcessType) >=
         GetMaxProcessCount(aContentProcessType);
}

/*static*/
void ContentParent::ReleaseCachedProcesses() {
  if (!GetPoolSize(NS_LITERAL_STRING(DEFAULT_REMOTE_TYPE))) {
    return;
  }

  // We might want to extend this for other process types as well in the
  // future...
  nsTArray<ContentParent*>& contentParents =
      GetOrCreatePool(NS_LITERAL_STRING(DEFAULT_REMOTE_TYPE));
  ContentProcessManager* cpm = ContentProcessManager::GetSingleton();
  nsTArray<ContentParent*> toRelease;

  // Shuting down these processes will change the array so let's use another
  // array for the removal.
  for (auto* cp : contentParents) {
    nsTArray<TabId> tabIds = cpm->GetBrowserParentsByProcessId(cp->mChildID);
    if (!tabIds.Length()) {
      toRelease.AppendElement(cp);
    }
  }

  for (auto* cp : toRelease) {
    // Start a soft shutdown.
    cp->ShutDownProcess(SEND_SHUTDOWN_MESSAGE);
    // Make sure we don't select this process for new tabs.
    cp->MarkAsDead();
    // Make sure that this process is no longer accessible from JS by its
    // message manager.
    cp->ShutDownMessageManager();
  }
}

/*static*/
already_AddRefed<ContentParent> ContentParent::MinTabSelect(
    const nsTArray<ContentParent*>& aContentParents, ContentParent* aOpener,
    int32_t aMaxContentParents) {
  uint32_t maxSelectable =
      std::min(static_cast<uint32_t>(aContentParents.Length()),
               static_cast<uint32_t>(aMaxContentParents));
  uint32_t min = INT_MAX;
  RefPtr<ContentParent> candidate;
  ContentProcessManager* cpm = ContentProcessManager::GetSingleton();

  for (uint32_t i = 0; i < maxSelectable; i++) {
    ContentParent* p = aContentParents[i];
    NS_ASSERTION(p->IsAlive(),
                 "Non-alive contentparent in sBrowserContentParents?");
    if (p->mOpener == aOpener) {
      uint32_t tabCount = cpm->GetBrowserParentCountByProcessId(p->ChildID());
      if (tabCount < min) {
        candidate = p;
        min = tabCount;
      }
    }
  }

  return candidate.forget();
}

static bool CreateTemporaryRecordingFile(nsAString& aResult) {
  static int sNumTemporaryRecordings;
  nsCOMPtr<nsIFile> file;
  return !NS_FAILED(
             NS_GetSpecialDirectory(NS_OS_TEMP_DIR, getter_AddRefs(file))) &&
         !NS_FAILED(file->AppendNative(
             nsPrintfCString("TempRecording.%d.%d", base::GetCurrentProcId(),
                             ++sNumTemporaryRecordings))) &&
         !NS_FAILED(file->GetPath(aResult));
}

/*static*/
already_AddRefed<ContentParent> ContentParent::GetNewOrUsedBrowserProcess(
    Element* aFrameElement, const nsAString& aRemoteType,
    ProcessPriority aPriority, ContentParent* aOpener, bool aPreferUsed) {
  // Figure out if this process will be recording or replaying, and which file
  // to use for the recording.
  RecordReplayState recordReplayState = eNotRecordingOrReplaying;
  nsAutoString recordingFile;
  if (aFrameElement) {
    aFrameElement->GetAttr(kNameSpaceID_None, nsGkAtoms::ReplayExecution,
                           recordingFile);
    if (!recordingFile.IsEmpty()) {
      recordReplayState = eReplaying;
    } else {
      aFrameElement->GetAttr(kNameSpaceID_None, nsGkAtoms::RecordExecution,
                             recordingFile);
      if (recordingFile.IsEmpty() &&
          recordreplay::parent::SaveAllRecordingsDirectory()) {
        recordingFile.AssignLiteral("*");
      }
      if (!recordingFile.IsEmpty()) {
        if (recordingFile.EqualsLiteral("*") &&
            !CreateTemporaryRecordingFile(recordingFile)) {
          return nullptr;
        }
        recordReplayState = eRecording;
      }
    }
  }

  nsTArray<ContentParent*>& contentParents = GetOrCreatePool(aRemoteType);
  uint32_t maxContentParents = GetMaxProcessCount(aRemoteType);
  if (recordReplayState != eNotRecordingOrReplaying) {
    // Fall through and always create a new process when recording or replaying.
  } else if (aRemoteType.EqualsLiteral(LARGE_ALLOCATION_REMOTE_TYPE)) {
    // We never want to re-use Large-Allocation processes.
    if (contentParents.Length() >= maxContentParents) {
      return GetNewOrUsedBrowserProcess(aFrameElement,
                                        NS_LITERAL_STRING(DEFAULT_REMOTE_TYPE),
                                        aPriority, aOpener);
    }
  } else {
    uint32_t numberOfParents = contentParents.Length();
    nsTArray<RefPtr<nsIContentProcessInfo>> infos(numberOfParents);
    for (auto* cp : contentParents) {
      infos.AppendElement(cp->mScriptableHelper);
    }

    if (aPreferUsed && numberOfParents) {
      // For the preloaded browser we don't want to create a new process but
      // reuse an existing one.
      maxContentParents = numberOfParents;
    }

    nsCOMPtr<nsIContentProcessProvider> cpp =
        do_GetService("@mozilla.org/ipc/processselector;1");
    nsIContentProcessInfo* openerInfo =
        aOpener ? aOpener->mScriptableHelper.get() : nullptr;
    int32_t index;
    if (cpp && NS_SUCCEEDED(cpp->ProvideProcess(aRemoteType, openerInfo, infos,
                                                maxContentParents, &index))) {
      // If the provider returned an existing ContentParent, use that one.
      if (0 <= index && static_cast<uint32_t>(index) <= maxContentParents) {
        RefPtr<ContentParent> retval = contentParents[index];
        return retval.forget();
      }
    } else {
      // If there was a problem with the JS chooser, fall back to a random
      // selection.
      NS_WARNING("nsIContentProcessProvider failed to return a process");
      RefPtr<ContentParent> random;
      if (contentParents.Length() >= maxContentParents &&
          (random = MinTabSelect(contentParents, aOpener, maxContentParents))) {
        return random.forget();
      }
    }

    // Try to take the preallocated process only for the default process type.
    // The preallocated process manager might not had the chance yet to release
    // the process after a very recent ShutDownProcess, let's make sure we don't
    // try to reuse a process that is being shut down.
    RefPtr<ContentParent> p;
    if (aRemoteType.EqualsLiteral(DEFAULT_REMOTE_TYPE) &&
        (p = PreallocatedProcessManager::Take()) && !p->mShutdownPending) {
      // For pre-allocated process we have not set the opener yet.
      p->mOpener = aOpener;
      contentParents.AppendElement(p);
      p->mActivateTS = TimeStamp::Now();
      return p.forget();
    }
  }

  // Create a new process from scratch.
  RefPtr<ContentParent> p =
      new ContentParent(aOpener, aRemoteType, recordReplayState, recordingFile);

  if (!p->LaunchSubprocessSync(aPriority)) {
    return nullptr;
  }

  // Until the new process is ready let's not allow to start up any preallocated
  // processes.
  PreallocatedProcessManager::AddBlocker(p);

  if (recordReplayState == eNotRecordingOrReplaying) {
    contentParents.AppendElement(p);
  }

  p->mActivateTS = TimeStamp::Now();
  return p.forget();
}

/*static*/
already_AddRefed<ContentParent> ContentParent::GetNewOrUsedJSPluginProcess(
    uint32_t aPluginID, const hal::ProcessPriority& aPriority) {
  RefPtr<ContentParent> p;
  if (sJSPluginContentParents) {
    p = sJSPluginContentParents->Get(aPluginID);
  } else {
    sJSPluginContentParents =
        new nsDataHashtable<nsUint32HashKey, ContentParent*>();
  }

  if (p) {
    return p.forget();
  }

  p = new ContentParent(aPluginID);

  if (!p->LaunchSubprocessSync(aPriority)) {
    return nullptr;
  }

  sJSPluginContentParents->Put(aPluginID, p);

  return p.forget();
}

/*static*/
ProcessPriority ContentParent::GetInitialProcessPriority(
    Element* aFrameElement) {
  // Frames with mozapptype == critical which are expecting a system message
  // get FOREGROUND_HIGH priority.

  if (!aFrameElement) {
    return PROCESS_PRIORITY_FOREGROUND;
  }

  nsCOMPtr<nsIMozBrowserFrame> browserFrame = do_QueryInterface(aFrameElement);
  if (!browserFrame) {
    return PROCESS_PRIORITY_FOREGROUND;
  }

  return PROCESS_PRIORITY_FOREGROUND;
}

#if defined(XP_WIN)
extern const wchar_t* kPluginWidgetContentParentProperty;

/*static*/
void ContentParent::SendAsyncUpdate(nsIWidget* aWidget) {
  if (!aWidget || aWidget->Destroyed()) {
    return;
  }
  // Fire off an async request to the plugin to paint its window
  HWND hwnd = (HWND)aWidget->GetNativeData(NS_NATIVE_WINDOW);
  NS_ASSERTION(hwnd, "Expected valid hwnd value.");
  ContentParent* cp = reinterpret_cast<ContentParent*>(
      ::GetPropW(hwnd, kPluginWidgetContentParentProperty));
  if (cp && !cp->IsDestroyed()) {
    Unused << cp->SendUpdateWindow((uintptr_t)hwnd);
  }
}
#endif  // defined(XP_WIN)

static nsIDocShell* GetOpenerDocShellHelper(Element* aFrameElement) {
  // Propagate the private-browsing status of the element's parent
  // docshell to the remote docshell, via the chrome flags.
  MOZ_ASSERT(aFrameElement);
  nsPIDOMWindowOuter* win = aFrameElement->OwnerDoc()->GetWindow();
  if (!win) {
    NS_WARNING("Remote frame has no window");
    return nullptr;
  }
  nsIDocShell* docShell = win->GetDocShell();
  if (!docShell) {
    NS_WARNING("Remote frame has no docshell");
    return nullptr;
  }

  return docShell;
}

mozilla::ipc::IPCResult ContentParent::RecvCreateGMPService() {
  Endpoint<PGMPServiceParent> parent;
  Endpoint<PGMPServiceChild> child;

  nsresult rv;
  rv = PGMPService::CreateEndpoints(base::GetCurrentProcId(), OtherPid(),
                                    &parent, &child);
  if (NS_FAILED(rv)) {
    MOZ_ASSERT(false, "CreateEndpoints failed");
    return IPC_FAIL_NO_REASON(this);
  }

  if (!GMPServiceParent::Create(std::move(parent))) {
    MOZ_ASSERT(false, "GMPServiceParent::Create failed");
    return IPC_FAIL_NO_REASON(this);
  }

  if (!SendInitGMPService(std::move(child))) {
    MOZ_ASSERT(false, "SendInitGMPService failed");
    return IPC_FAIL_NO_REASON(this);
  }

  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvLoadPlugin(
    const uint32_t& aPluginId, nsresult* aRv, uint32_t* aRunID,
    Endpoint<PPluginModuleParent>* aEndpoint) {
  *aRv = NS_OK;
  if (!mozilla::plugins::SetupBridge(aPluginId, this, aRv, aRunID, aEndpoint)) {
    return IPC_FAIL_NO_REASON(this);
  }
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvUngrabPointer(
    const uint32_t& aTime) {
#if !defined(MOZ_WIDGET_GTK)
  MOZ_CRASH("This message only makes sense on GTK platforms");
#else
  gdk_pointer_ungrab(aTime);
  return IPC_OK();
#endif
}

mozilla::ipc::IPCResult ContentParent::RecvRemovePermission(
    const IPC::Principal& aPrincipal, const nsCString& aPermissionType,
    nsresult* aRv) {
  *aRv = Permissions::RemovePermission(aPrincipal, aPermissionType);
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvConnectPluginBridge(
    const uint32_t& aPluginId, nsresult* aRv,
    Endpoint<PPluginModuleParent>* aEndpoint) {
  *aRv = NS_OK;
  // We don't need to get the run ID for the plugin, since we already got it
  // in the first call to SetupBridge in RecvLoadPlugin, so we pass in a dummy
  // pointer and just throw it away.
  uint32_t dummy = 0;
  if (!mozilla::plugins::SetupBridge(aPluginId, this, aRv, &dummy, aEndpoint)) {
    return IPC_FAIL(this, "SetupBridge failed");
  }
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvLaunchRDDProcess(
    nsresult* aRv, Endpoint<PRemoteDecoderManagerChild>* aEndpoint) {
  *aRv = NS_OK;

  if (XRE_IsParentProcess() &&
      BrowserTabsRemoteAutostart() &&  // only do rdd process if e10s on
      Preferences::GetBool("media.rdd-process.enabled", false)) {
    RDDProcessManager* rdd = RDDProcessManager::Get();
    if (rdd) {
      rdd->LaunchRDDProcess();

      bool rddOpened = rdd->CreateContentBridge(OtherPid(), aEndpoint);

      if (NS_WARN_IF(!rddOpened)) {
        *aRv = NS_ERROR_NOT_AVAILABLE;
      }
    } else {
      *aRv = NS_ERROR_NOT_AVAILABLE;
    }
  }

  return IPC_OK();
}

/*static*/
BrowserParent* ContentParent::CreateBrowser(const TabContext& aContext,
                                            Element* aFrameElement,
                                            BrowsingContext* aBrowsingContext,
                                            ContentParent* aOpenerContentParent,
                                            BrowserParent* aSameTabGroupAs,
                                            uint64_t aNextRemoteTabId) {
  AUTO_PROFILER_LABEL("ContentParent::CreateBrowser", OTHER);

  if (!sCanLaunchSubprocesses) {
    return nullptr;
  }

  nsAutoString remoteType;
  if (!aFrameElement->GetAttr(kNameSpaceID_None, nsGkAtoms::RemoteType,
                              remoteType)) {
    remoteType.AssignLiteral(DEFAULT_REMOTE_TYPE);
  }

  if (aNextRemoteTabId) {
    if (BrowserParent* parent =
            sNextBrowserParents.GetAndRemove(aNextRemoteTabId)
                .valueOr(nullptr)) {
      MOZ_ASSERT(!parent->GetOwnerElement(),
                 "Shouldn't have an owner elemnt before");
      parent->SetOwnerElement(aFrameElement);
      return parent;
    }
  }

  ProcessPriority initialPriority = GetInitialProcessPriority(aFrameElement);
  TabId tabId(nsContentUtils::GenerateTabId());

  nsIDocShell* docShell = GetOpenerDocShellHelper(aFrameElement);
  TabId openerTabId;
  if (docShell) {
    openerTabId = BrowserParent::GetTabIdFrom(docShell);
  }

  bool isPreloadBrowser = false;
  nsAutoString isPreloadBrowserStr;
  if (aFrameElement->GetAttr(kNameSpaceID_None, nsGkAtoms::preloadedState,
                             isPreloadBrowserStr)) {
    isPreloadBrowser = isPreloadBrowserStr.EqualsLiteral("preloaded");
  }

  RefPtr<ContentParent> constructorSender;
  MOZ_RELEASE_ASSERT(XRE_IsParentProcess(),
                     "Cannot allocate BrowserParent in content process");
  if (aOpenerContentParent) {
    constructorSender = aOpenerContentParent;
  } else {
    if (aContext.IsJSPlugin()) {
      constructorSender =
          GetNewOrUsedJSPluginProcess(aContext.JSPluginId(), initialPriority);
    } else {
      constructorSender =
          GetNewOrUsedBrowserProcess(aFrameElement, remoteType, initialPriority,
                                     nullptr, isPreloadBrowser);
    }
    if (!constructorSender) {
      return nullptr;
    }
  }

  aBrowsingContext->SetEmbedderElement(aFrameElement);

  // Ensure that our content process is subscribed to our newly created
  // BrowsingContextGroup.
  aBrowsingContext->Group()->EnsureSubscribed(constructorSender);

  ContentProcessManager* cpm = ContentProcessManager::GetSingleton();
  cpm->RegisterRemoteFrame(tabId, ContentParentId(0), openerTabId,
                           aContext.AsIPCTabContext(),
                           constructorSender->ChildID());

  if (constructorSender) {
    nsCOMPtr<nsIDocShellTreeOwner> treeOwner;
    docShell->GetTreeOwner(getter_AddRefs(treeOwner));
    if (!treeOwner) {
      return nullptr;
    }

    nsCOMPtr<nsIWebBrowserChrome> wbc = do_GetInterface(treeOwner);
    if (!wbc) {
      return nullptr;
    }
    uint32_t chromeFlags = 0;
    wbc->GetChromeFlags(&chromeFlags);

    nsCOMPtr<nsILoadContext> loadContext = do_QueryInterface(docShell);
    if (loadContext && loadContext->UsePrivateBrowsing()) {
      chromeFlags |= nsIWebBrowserChrome::CHROME_PRIVATE_WINDOW;
    }
    if (docShell->GetAffectPrivateSessionLifetime()) {
      chromeFlags |= nsIWebBrowserChrome::CHROME_PRIVATE_LIFETIME;
    }

    if (tabId == 0) {
      return nullptr;
    }

    aBrowsingContext->Canonical()->SetOwnerProcessId(
        constructorSender->ChildID());

    RefPtr<BrowserParent> browserParent =
        new BrowserParent(constructorSender, tabId, aContext,
                          aBrowsingContext->Canonical(), chromeFlags);

    // Open a remote endpoint for our PBrowser actor. DeallocPBrowserParent
    // releases the ref taken.
    ManagedEndpoint<PBrowserChild> childEp =
        constructorSender->OpenPBrowserEndpoint(
            do_AddRef(browserParent).take());
    if (NS_WARN_IF(!childEp.IsValid())) {
      return nullptr;
    }

    // Tell the content process to set up its PBrowserChild.
    bool ok = constructorSender->SendConstructBrowser(
        std::move(childEp), tabId,
        aSameTabGroupAs ? aSameTabGroupAs->GetTabId() : TabId(0),
        aContext.AsIPCTabContext(), aBrowsingContext, chromeFlags,
        constructorSender->ChildID(), constructorSender->IsForBrowser());
    if (NS_WARN_IF(!ok)) {
      return nullptr;
    }

    if (remoteType.EqualsLiteral(LARGE_ALLOCATION_REMOTE_TYPE)) {
      // Tell the BrowserChild object that it was created due to a
      // Large-Allocation request.
      Unused << browserParent->SendAwaitLargeAlloc();
    }

    browserParent->SetOwnerElement(aFrameElement);
    return browserParent;
  }
  return nullptr;
}

void ContentParent::GetAll(nsTArray<ContentParent*>& aArray) {
  aArray.Clear();

  for (auto* cp : AllProcesses(eLive)) {
    aArray.AppendElement(cp);
  }
}

void ContentParent::GetAllEvenIfDead(nsTArray<ContentParent*>& aArray) {
  aArray.Clear();

  for (auto* cp : AllProcesses(eAll)) {
    aArray.AppendElement(cp);
  }
}

void ContentParent::BroadcastStringBundle(
    const StringBundleDescriptor& aBundle) {
  AutoTArray<StringBundleDescriptor, 1> array;
  array.AppendElement(aBundle);

  for (auto* cp : AllProcesses(eLive)) {
    Unused << cp->SendRegisterStringBundles(array);
  }
}

void ContentParent::BroadcastFontListChanged() {
  for (auto* cp : AllProcesses(eLive)) {
    Unused << cp->SendFontListChanged();
  }
}

const nsAString& ContentParent::GetRemoteType() const { return mRemoteType; }

void ContentParent::Init() {
  nsCOMPtr<nsIObserverService> obs = mozilla::services::GetObserverService();
  if (obs) {
    size_t length = ArrayLength(sObserverTopics);
    for (size_t i = 0; i < length; ++i) {
      obs->AddObserver(this, sObserverTopics[i], false);
    }
  }

  // Flush any pref updates that happened during launch and weren't
  // included in the blobs set up in LaunchSubprocessInternal.
  for (const Pref& pref : mQueuedPrefs) {
    Unused << NS_WARN_IF(!SendPreferenceUpdate(pref));
  }
  mQueuedPrefs.Clear();

  if (obs) {
    nsAutoString cpId;
    cpId.AppendInt(static_cast<uint64_t>(this->ChildID()));
    obs->NotifyObservers(static_cast<nsIObserver*>(this), "ipc:content-created",
                         cpId.get());
  }

#ifdef ACCESSIBILITY
  // If accessibility is running in chrome process then start it in content
  // process.
  if (PresShell::IsAccessibilityActive()) {
#  if defined(XP_WIN)
    // Don't init content a11y if we detect an incompat version of JAWS in use.
    if (!mozilla::a11y::Compatibility::IsOldJAWS()) {
      Unused << SendActivateA11y(
          ::GetCurrentThreadId(),
          a11y::AccessibleWrap::GetContentProcessIdFor(ChildID()));
    }
#  else
    Unused << SendActivateA11y(0, 0);
#  endif
  }
#endif  // #ifdef ACCESSIBILITY

#ifdef MOZ_GECKO_PROFILER
  Unused << SendInitProfiler(ProfilerParent::CreateForProcess(OtherPid()));
#endif

  // Ensure that the default set of permissions are avaliable in the content
  // process before we try to load any URIs in it.
  EnsurePermissionsByKey(EmptyCString());

  RefPtr<GeckoMediaPluginServiceParent> gmps(
      GeckoMediaPluginServiceParent::GetSingleton());
  gmps->UpdateContentProcessGMPCapabilities();

  mScriptableHelper = new ScriptableCPInfo(this);
}

namespace {

class RemoteWindowContext final : public nsIRemoteWindowContext,
                                  public nsIInterfaceRequestor {
 public:
  explicit RemoteWindowContext(BrowserParent* aBrowserParent)
      : mBrowserParent(aBrowserParent) {}

  NS_DECL_ISUPPORTS
  NS_DECL_NSIINTERFACEREQUESTOR
  NS_DECL_NSIREMOTEWINDOWCONTEXT

 private:
  ~RemoteWindowContext();
  RefPtr<BrowserParent> mBrowserParent;
};

NS_IMPL_ISUPPORTS(RemoteWindowContext, nsIRemoteWindowContext,
                  nsIInterfaceRequestor)

RemoteWindowContext::~RemoteWindowContext() {}

NS_IMETHODIMP
RemoteWindowContext::GetInterface(const nsIID& aIID, void** aSink) {
  return QueryInterface(aIID, aSink);
}

NS_IMETHODIMP
RemoteWindowContext::OpenURI(nsIURI* aURI) {
  mBrowserParent->LoadURL(aURI);
  return NS_OK;
}

NS_IMETHODIMP
RemoteWindowContext::GetUsePrivateBrowsing(bool* aUsePrivateBrowsing) {
  nsCOMPtr<nsILoadContext> loadContext = mBrowserParent->GetLoadContext();
  *aUsePrivateBrowsing = loadContext && loadContext->UsePrivateBrowsing();
  return NS_OK;
}

}  // namespace

void ContentParent::ShutDownProcess(ShutDownMethod aMethod) {
  if (mScriptableHelper) {
    static_cast<ScriptableCPInfo*>(mScriptableHelper.get())->ProcessDied();
    mScriptableHelper = nullptr;
  }

  // Shutting down by sending a shutdown message works differently than the
  // other methods. We first call Shutdown() in the child. After the child is
  // ready, it calls FinishShutdown() on us. Then we close the channel.
  if (aMethod == SEND_SHUTDOWN_MESSAGE) {
    if (const char* directory =
            recordreplay::parent::SaveAllRecordingsDirectory()) {
      // Save a recording for the child process before it shuts down.
      static int sNumSavedRecordings;
      nsCOMPtr<nsIFile> file;
      if (!NS_FAILED(NS_NewNativeLocalFile(nsDependentCString(directory), false,
                                           getter_AddRefs(file))) &&
          !NS_FAILED(file->AppendNative(
              nsPrintfCString("Recording.%d.%d", base::GetCurrentProcId(),
                              ++sNumSavedRecordings)))) {
        bool unused;
        SaveRecording(file, &unused);
      }
    }

    if (mIPCOpen && !mShutdownPending) {
      // Stop sending input events with input priority when shutting down.
      SetInputPriorityEventEnabled(false);
      if (SendShutdown()) {
        mShutdownPending = true;
        // Start the force-kill timer if we haven't already.
        StartForceKillTimer();
      }
    }
    // If call was not successful, the channel must have been broken
    // somehow, and we will clean up the error in ActorDestroy.
    return;
  }

  using mozilla::dom::quota::QuotaManagerService;

  if (QuotaManagerService* qms = QuotaManagerService::GetOrCreate()) {
    qms->AbortOperationsForProcess(mChildID);
  }

  // If Close() fails with an error, we'll end up back in this function, but
  // with aMethod = CLOSE_CHANNEL_WITH_ERROR.

  if (aMethod == CLOSE_CHANNEL && !mCalledClose) {
    // Close() can only be called once: It kicks off the destruction
    // sequence.
    mCalledClose = true;
    Close();
  }

  const ManagedContainer<POfflineCacheUpdateParent>& ocuParents =
      ManagedPOfflineCacheUpdateParent();
  for (auto iter = ocuParents.ConstIter(); !iter.Done(); iter.Next()) {
    RefPtr<mozilla::docshell::OfflineCacheUpdateParent> ocuParent =
        static_cast<mozilla::docshell::OfflineCacheUpdateParent*>(
            iter.Get()->GetKey());
    ocuParent->StopSendingMessagesToChild();
  }

  // NB: must MarkAsDead() here so that this isn't accidentally
  // returned from Get*() while in the midst of shutdown.
  MarkAsDead();

  // A ContentParent object might not get freed until after XPCOM shutdown has
  // shut down the cycle collector.  But by then it's too late to release any
  // CC'ed objects, so we need to null them out here, while we still can.  See
  // bug 899761.
  ShutDownMessageManager();
}

mozilla::ipc::IPCResult ContentParent::RecvFinishShutdown() {
  // At this point, we already called ShutDownProcess once with
  // SEND_SHUTDOWN_MESSAGE. To actually close the channel, we call
  // ShutDownProcess again with CLOSE_CHANNEL.
  MOZ_ASSERT(mShutdownPending);
  ShutDownProcess(CLOSE_CHANNEL);
  return IPC_OK();
}

void ContentParent::ShutDownMessageManager() {
  if (!mMessageManager) {
    return;
  }

  mMessageManager->ReceiveMessage(
      mMessageManager, nullptr, CHILD_PROCESS_SHUTDOWN_MESSAGE, false, nullptr,
      nullptr, nullptr, nullptr, IgnoreErrors());

  mMessageManager->Disconnect();
  mMessageManager = nullptr;
}

void ContentParent::RemoveFromList() {
  if (IsForJSPlugin()) {
    if (sJSPluginContentParents) {
      sJSPluginContentParents->Remove(mJSPluginID);
      if (!sJSPluginContentParents->Count()) {
        delete sJSPluginContentParents;
        sJSPluginContentParents = nullptr;
      }
    }
  } else if (sBrowserContentParents) {
    if (auto entry = sBrowserContentParents->Lookup(mRemoteType)) {
      nsTArray<ContentParent*>* contentParents = entry.Data();
      contentParents->RemoveElement(this);
      if (contentParents->IsEmpty()) {
        entry.Remove();
      }
    }
    if (sBrowserContentParents->IsEmpty()) {
      delete sBrowserContentParents;
      sBrowserContentParents = nullptr;
    }
  }

  if (sPrivateContent) {
    sPrivateContent->RemoveElement(this);
    if (!sPrivateContent->Length()) {
      delete sPrivateContent;
      sPrivateContent = nullptr;
    }
  }
}

void ContentParent::MarkAsDead() {
  RemoveFromList();
  mLifecycleState = LifecycleState::DEAD;
}

void ContentParent::OnChannelError() {
  RefPtr<ContentParent> kungFuDeathGrip(this);
  PContentParent::OnChannelError();
}

void ContentParent::OnChannelConnected(int32_t pid) {
  MOZ_ASSERT(NS_IsMainThread());

  SetOtherProcessId(pid);

#if defined(ANDROID) || defined(LINUX)
  // Check nice preference
  int32_t nice = Preferences::GetInt("dom.ipc.content.nice", 0);

  // Environment variable overrides preference
  char* relativeNicenessStr = getenv("MOZ_CHILD_PROCESS_RELATIVE_NICENESS");
  if (relativeNicenessStr) {
    nice = atoi(relativeNicenessStr);
  }

  /* make the GUI thread have higher priority on single-cpu devices */
  nsCOMPtr<nsIPropertyBag2> infoService =
      do_GetService(NS_SYSTEMINFO_CONTRACTID);
  if (infoService) {
    int32_t cpus;
    nsresult rv =
        infoService->GetPropertyAsInt32(NS_LITERAL_STRING("cpucount"), &cpus);
    if (NS_FAILED(rv)) {
      cpus = 1;
    }
    if (nice != 0 && cpus == 1) {
      setpriority(PRIO_PROCESS, pid, getpriority(PRIO_PROCESS, pid) + nice);
    }
  }
#endif
}

void ContentParent::ProcessingError(Result aCode, const char* aReason) {
  if (MsgDropped == aCode) {
    return;
  }
#ifndef FUZZING
  // Other errors are big deals.
  KillHard(aReason);
#endif
}

void ContentParent::ActorDestroy(ActorDestroyReason why) {
  RefPtr<ContentParent> kungFuDeathGrip(mSelfRef.forget());
  MOZ_RELEASE_ASSERT(kungFuDeathGrip);

  if (mForceKillTimer) {
    mForceKillTimer->Cancel();
    mForceKillTimer = nullptr;
  }

  // Signal shutdown completion regardless of error state, so we can
  // finish waiting in the xpcom-shutdown/profile-before-change observer.
  mIPCOpen = false;

  if (mHangMonitorActor) {
    ProcessHangMonitor::RemoveProcess(mHangMonitorActor);
    mHangMonitorActor = nullptr;
  }

  RefPtr<FileSystemSecurity> fss = FileSystemSecurity::Get();
  if (fss) {
    fss->Forget(ChildID());
  }

  if (why == NormalShutdown && !mCalledClose) {
    // If we shut down normally but haven't called Close, assume somebody
    // else called Close on us. In that case, we still need to call
    // ShutDownProcess below to perform other necessary clean up.
    mCalledClose = true;
  }

  // Make sure we always clean up.
  ShutDownProcess(why == NormalShutdown ? CLOSE_CHANNEL
                                        : CLOSE_CHANNEL_WITH_ERROR);

  nsCOMPtr<nsIObserverService> obs = mozilla::services::GetObserverService();
  if (obs) {
    size_t length = ArrayLength(sObserverTopics);
    for (size_t i = 0; i < length; ++i) {
      obs->RemoveObserver(static_cast<nsIObserver*>(this), sObserverTopics[i]);
    }
  }

  // remove the global remote preferences observers
  Preferences::RemoveObserver(this, "");
  gfxVars::RemoveReceiver(this);

  if (GPUProcessManager* gpu = GPUProcessManager::Get()) {
    // Note: the manager could have shutdown already.
    gpu->RemoveListener(this);
  }

  RecvRemoveGeolocationListener();

  mConsoleService = nullptr;

  if (obs) {
    RefPtr<nsHashPropertyBag> props = new nsHashPropertyBag();

    props->SetPropertyAsUint64(NS_LITERAL_STRING("childID"), mChildID);

    if (AbnormalShutdown == why) {
      Telemetry::Accumulate(Telemetry::SUBPROCESS_ABNORMAL_ABORT,
                            NS_LITERAL_CSTRING("content"), 1);

      props->SetPropertyAsBool(NS_LITERAL_STRING("abnormal"), true);

      // There's a window in which child processes can crash
      // after IPC is established, but before a crash reporter
      // is created.
      if (mCrashReporter) {
        // if mCreatedPairedMinidumps is true, we've already generated
        // parent/child dumps for desktop crashes.
        if (!mCreatedPairedMinidumps) {
          mCrashReporter->GenerateCrashReport(OtherPid());
        }

        nsAutoString dumpID;
        if (mCrashReporter->HasMinidump()) {
          dumpID = mCrashReporter->MinidumpID();
        }
        props->SetPropertyAsAString(NS_LITERAL_STRING("dumpID"), dumpID);
      } else {
        CrashReporter::FinalizeOrphanedMinidump(OtherPid(),
                                                GeckoProcessType_Content);
      }
    }
    nsAutoString cpId;
    cpId.AppendInt(static_cast<uint64_t>(this->ChildID()));
    obs->NotifyObservers((nsIPropertyBag2*)props, "ipc:content-shutdown",
                         cpId.get());
  }

  // Remove any and all idle listeners.
  nsCOMPtr<nsIIdleService> idleService =
      do_GetService("@mozilla.org/widget/idleservice;1");
  MOZ_ASSERT(idleService);
  RefPtr<ParentIdleListener> listener;
  for (int32_t i = mIdleListeners.Length() - 1; i >= 0; --i) {
    listener = static_cast<ParentIdleListener*>(mIdleListeners[i].get());
    idleService->RemoveIdleObserver(listener, listener->mTime);
  }
  mIdleListeners.Clear();

  // FIXME (bug 1520997): does this really need an additional dispatch?
  MessageLoop::current()->PostTask(NS_NewRunnableFunction(
      "DelayedDeleteSubprocessRunnable",
      [subprocess = mSubprocess] { subprocess->Destroy(); }));
  mSubprocess = nullptr;

  // Delete any remaining replaying children.
  for (auto& replayingProcess : mReplayingChildren) {
    if (replayingProcess) {
      replayingProcess->Destroy();
      replayingProcess = nullptr;
    }
  }

  // IPDL rules require actors to live on past ActorDestroy, but it
  // may be that the kungFuDeathGrip above is the last reference to
  // |this|.  If so, when we go out of scope here, we're deleted and
  // all hell breaks loose.
  //
  // This runnable ensures that a reference to |this| lives on at
  // least until after the current task finishes running.
  NS_DispatchToCurrentThread(NS_NewRunnableFunction(
      "DelayedReleaseContentParent", [kungFuDeathGrip] {}));

  ContentProcessManager* cpm = ContentProcessManager::GetSingleton();
  nsTArray<ContentParentId> childIDArray =
      cpm->GetAllChildProcessById(this->ChildID());

  // Destroy any processes created by this ContentParent
  for (uint32_t i = 0; i < childIDArray.Length(); i++) {
    ContentParent* cp = cpm->GetContentProcessById(childIDArray[i]);
    MessageLoop::current()->PostTask(NewRunnableMethod<ShutDownMethod>(
        "dom::ContentParent::ShutDownProcess", cp,
        &ContentParent::ShutDownProcess, SEND_SHUTDOWN_MESSAGE));
  }
  cpm->RemoveContentProcess(this->ChildID());

  if (mDriverCrashGuard) {
    mDriverCrashGuard->NotifyCrashed();
  }

  // Unregister all the BlobURLs registered by the ContentChild.
  for (uint32_t i = 0; i < mBlobURLs.Length(); ++i) {
    BlobURLProtocolHandler::RemoveDataEntry(mBlobURLs[i]);
  }

  mBlobURLs.Clear();

#if defined(XP_WIN) && defined(ACCESSIBILITY)
  a11y::AccessibleWrap::ReleaseContentProcessIdFor(ChildID());
#endif

  nsTHashtable<nsRefPtrHashKey<BrowsingContextGroup>> groups;
  mGroups.SwapElements(groups);

  for (auto iter = groups.Iter(); !iter.Done(); iter.Next()) {
    iter.Get()->GetKey()->Unsubscribe(this);
  }

  MOZ_DIAGNOSTIC_ASSERT(mGroups.IsEmpty());
}

bool ContentParent::TryToRecycle() {
  // This life time check should be replaced by a memory health check (memory
  // usage + fragmentation).
  const double kMaxLifeSpan = 5;
  if (mShutdownPending || mCalledKillHard || !IsAlive() ||
      !mRemoteType.EqualsLiteral(DEFAULT_REMOTE_TYPE) ||
      (TimeStamp::Now() - mActivateTS).ToSeconds() > kMaxLifeSpan ||
      !PreallocatedProcessManager::Provide(this)) {
    return false;
  }

  // The PreallocatedProcessManager took over the ownership let's not keep a
  // reference to it, until we don't take it back.
  RemoveFromList();
  return true;
}

bool ContentParent::ShouldKeepProcessAlive() const {
  if (IsForJSPlugin()) {
    return true;
  }

  // If we have active workers, we need to stay alive.
  if (mRemoteWorkerActors) {
    return true;
  }

  if (!sBrowserContentParents) {
    return false;
  }

  // If we have already been marked as dead, don't prevent shutdown.
  if (!IsAlive()) {
    return false;
  }

  // Recording/replaying content parents cannot be reused and should not be
  // kept alive.
  if (this->IsRecordingOrReplaying()) {
    return false;
  }

  auto contentParents = sBrowserContentParents->Get(mRemoteType);
  if (!contentParents) {
    return false;
  }

  // We might want to keep some content processes alive for performance reasons.
  // e.g. test runs and privileged content process for some about: pages.
  // We don't want to alter behavior if the pref is not set, so default to 0.
  int32_t processesToKeepAlive = 0;

  nsAutoCString keepAlivePref("dom.ipc.keepProcessesAlive.");
  keepAlivePref.Append(NS_ConvertUTF16toUTF8(mRemoteType));
  if (NS_FAILED(
          Preferences::GetInt(keepAlivePref.get(), &processesToKeepAlive))) {
    return false;
  }

  int32_t numberOfAliveProcesses = contentParents->Length();

  return numberOfAliveProcesses <= processesToKeepAlive;
}

void ContentParent::NotifyTabDestroying(const TabId& aTabId,
                                        const ContentParentId& aCpId) {
  if (XRE_IsParentProcess()) {
    // There can be more than one PBrowser for a given app process
    // because of popup windows.  PBrowsers can also destroy
    // concurrently.  When all the PBrowsers are destroying, kick off
    // another task to ensure the child process *really* shuts down,
    // even if the PBrowsers themselves never finish destroying.
    ContentProcessManager* cpm = ContentProcessManager::GetSingleton();
    ContentParent* cp = cpm->GetContentProcessById(aCpId);
    if (!cp) {
      return;
    }
    ++cp->mNumDestroyingTabs;
    nsTArray<TabId> tabIds = cpm->GetBrowserParentsByProcessId(aCpId);
    if (static_cast<size_t>(cp->mNumDestroyingTabs) != tabIds.Length()) {
      return;
    }

    if (cp->ShouldKeepProcessAlive()) {
      return;
    }

    if (cp->TryToRecycle()) {
      return;
    }

    // We're dying now, so prevent this content process from being
    // recycled during its shutdown procedure.
    cp->MarkAsDead();
    cp->StartForceKillTimer();
  } else {
    ContentChild::GetSingleton()->SendNotifyTabDestroying(aTabId, aCpId);
  }
}

void ContentParent::StartForceKillTimer() {
  if (mForceKillTimer || !mIPCOpen) {
    return;
  }

  int32_t timeoutSecs = StaticPrefs::dom_ipc_tabs_shutdownTimeoutSecs();
  if (timeoutSecs > 0) {
    NS_NewTimerWithFuncCallback(getter_AddRefs(mForceKillTimer),
                                ContentParent::ForceKillTimerCallback, this,
                                timeoutSecs * 1000, nsITimer::TYPE_ONE_SHOT,
                                "dom::ContentParent::StartForceKillTimer");
    MOZ_ASSERT(mForceKillTimer);
  }
}

void ContentParent::NotifyTabDestroyed(const TabId& aTabId,
                                       bool aNotifiedDestroying) {
  if (aNotifiedDestroying) {
    --mNumDestroyingTabs;
  }

  nsTArray<PContentPermissionRequestParent*> parentArray =
      nsContentPermissionUtils::GetContentPermissionRequestParentById(aTabId);

  // Need to close undeleted ContentPermissionRequestParents before tab is
  // closed.
  for (auto& permissionRequestParent : parentArray) {
    Unused << PContentPermissionRequestParent::Send__delete__(
        permissionRequestParent);
  }

  // There can be more than one PBrowser for a given app process
  // because of popup windows.  When the last one closes, shut
  // us down.
  ContentProcessManager* cpm = ContentProcessManager::GetSingleton();
  nsTArray<TabId> tabIds = cpm->GetBrowserParentsByProcessId(this->ChildID());

  if (tabIds.Length() == 1 && !ShouldKeepProcessAlive() && !TryToRecycle()) {
    // In the case of normal shutdown, send a shutdown message to child to
    // allow it to perform shutdown tasks.
    MessageLoop::current()->PostTask(NewRunnableMethod<ShutDownMethod>(
        "dom::ContentParent::ShutDownProcess", this,
        &ContentParent::ShutDownProcess, SEND_SHUTDOWN_MESSAGE));
  }
}

mozilla::ipc::IPCResult ContentParent::RecvOpenRecordReplayChannel(
    const uint32_t& aChannelId, FileDescriptor* aConnection) {
  // We should only get this message from the child if it is recording or
  // replaying.
  if (!this->IsRecordingOrReplaying()) {
    return IPC_FAIL_NO_REASON(this);
  }

  recordreplay::parent::OpenChannel(Pid(), aChannelId, aConnection);
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvCreateReplayingProcess(
    const uint32_t& aChannelId) {
  // We should only get this message from the child if it is recording or
  // replaying.
  if (!this->IsRecordingOrReplaying()) {
    return IPC_FAIL_NO_REASON(this);
  }

  while (aChannelId >= mReplayingChildren.length()) {
    if (!mReplayingChildren.append(nullptr)) {
      return IPC_FAIL_NO_REASON(this);
    }
  }
  if (mReplayingChildren[aChannelId]) {
    return IPC_FAIL_NO_REASON(this);
  }

  std::vector<std::string> extraArgs;
  recordreplay::parent::GetArgumentsForChildProcess(
      Pid(), aChannelId, NS_ConvertUTF16toUTF8(mRecordingFile).get(),
      /* aRecording = */ false, extraArgs);

  mReplayingChildren[aChannelId] =
      new GeckoChildProcessHost(GeckoProcessType_Content);
  if (!mReplayingChildren[aChannelId]->LaunchAndWaitForProcessHandle(
          extraArgs)) {
    return IPC_FAIL_NO_REASON(this);
  }

  return IPC_OK();
}

jsipc::CPOWManager* ContentParent::GetCPOWManager() {
  if (PJavaScriptParent* p =
          LoneManagedOrNullAsserts(ManagedPJavaScriptParent())) {
    return CPOWManagerFor(p);
  }
  return nullptr;
}

TestShellParent* ContentParent::CreateTestShell() {
  return static_cast<TestShellParent*>(SendPTestShellConstructor());
}

bool ContentParent::DestroyTestShell(TestShellParent* aTestShell) {
  return PTestShellParent::Send__delete__(aTestShell);
}

TestShellParent* ContentParent::GetTestShellSingleton() {
  PTestShellParent* p = LoneManagedOrNullAsserts(ManagedPTestShellParent());
  return static_cast<TestShellParent*>(p);
}

#if defined(XP_MACOSX) && defined(MOZ_SANDBOX)
// Append the sandbox command line parameters that are not static. i.e.,
// parameters that can be different for different child processes.
void ContentParent::AppendDynamicSandboxParams(
    std::vector<std::string>& aArgs) {
  // For file content processes
  if (GetRemoteType().EqualsLiteral(FILE_REMOTE_TYPE)) {
    MacSandboxInfo::AppendFileAccessParam(aArgs, true);
  }
}

// Generate the static sandbox command line parameters and store
// them in the provided params vector to be used each time a new
// content process is launched.
static void CacheSandboxParams(std::vector<std::string>& aCachedParams) {
  // This must only be called once and we should
  // be starting with an empty list of parameters.
  MOZ_ASSERT(aCachedParams.empty());

  MacSandboxInfo info;
  info.type = MacSandboxType_Content;
  info.level = GetEffectiveContentSandboxLevel();

  // Sandbox logging
  if (Preferences::GetBool("security.sandbox.logging.enabled") ||
      PR_GetEnv("MOZ_SANDBOX_LOGGING")) {
    info.shouldLog = true;
  }

  // Audio access
  if (!Preferences::GetBool("media.cubeb.sandbox")) {
    info.hasAudio = true;
  }

  // Windowserver access
  if (!Preferences::GetBool(
          "security.sandbox.content.mac.disconnect-windowserver")) {
    info.hasWindowServer = true;
  }

  // .app path (normalized)
  nsAutoCString appPath;
  if (!nsMacUtilsImpl::GetAppPath(appPath)) {
    MOZ_CRASH("Failed to get app dir paths");
  }
  info.appPath = appPath.get();

  // TESTING_READ_PATH1
  nsAutoCString testingReadPath1;
  Preferences::GetCString("security.sandbox.content.mac.testing_read_path1",
                          testingReadPath1);
  if (!testingReadPath1.IsEmpty()) {
    info.testingReadPath1 = testingReadPath1.get();
  }

  // TESTING_READ_PATH2
  nsAutoCString testingReadPath2;
  Preferences::GetCString("security.sandbox.content.mac.testing_read_path2",
                          testingReadPath2);
  if (!testingReadPath2.IsEmpty()) {
    info.testingReadPath2 = testingReadPath2.get();
  }

  // TESTING_READ_PATH3, TESTING_READ_PATH4. In development builds,
  // these are used to whitelist the repo dir and object dir respectively.
  nsresult rv;
  if (mozilla::IsDevelopmentBuild()) {
    // Repo dir
    nsCOMPtr<nsIFile> repoDir;
    rv = mozilla::GetRepoDir(getter_AddRefs(repoDir));
    if (NS_FAILED(rv)) {
      MOZ_CRASH("Failed to get path to repo dir");
    }
    nsCString repoDirPath;
    Unused << repoDir->GetNativePath(repoDirPath);
    info.testingReadPath3 = repoDirPath.get();

    // Object dir
    nsCOMPtr<nsIFile> objDir;
    rv = mozilla::GetObjDir(getter_AddRefs(objDir));
    if (NS_FAILED(rv)) {
      MOZ_CRASH("Failed to get path to build object dir");
    }
    nsCString objDirPath;
    Unused << objDir->GetNativePath(objDirPath);
    info.testingReadPath4 = objDirPath.get();
  }

  // DEBUG_WRITE_DIR
#  ifdef DEBUG
  // For bloat/leak logging or when a content process dies intentionally
  // (|NoteIntentionalCrash|) for tests, it wants to log that it did this.
  // Allow writing to this location.
  nsAutoCString bloatLogDirPath;
  if (NS_SUCCEEDED(nsMacUtilsImpl::GetBloatLogDir(bloatLogDirPath))) {
    info.debugWriteDir = bloatLogDirPath.get();
  }
#  endif  // DEBUG

  info.AppendAsParams(aCachedParams);
}

// Append sandboxing command line parameters.
void ContentParent::AppendSandboxParams(std::vector<std::string>& aArgs) {
  MOZ_ASSERT(sMacSandboxParams != nullptr);

  // An empty sMacSandboxParams indicates this is the
  // first invocation and we don't have cached params yet.
  if (sMacSandboxParams->empty()) {
    CacheSandboxParams(*sMacSandboxParams);
    MOZ_ASSERT(!sMacSandboxParams->empty());
  }

  // Append cached arguments.
  aArgs.insert(aArgs.end(), sMacSandboxParams->begin(),
               sMacSandboxParams->end());

  // Append remaining arguments.
  AppendDynamicSandboxParams(aArgs);
}
#endif  // XP_MACOSX && MOZ_SANDBOX

void ContentParent::LaunchSubprocessInternal(
    ProcessPriority aInitialPriority,
    mozilla::Variant<bool*, RefPtr<LaunchPromise>*>&& aRetval) {
  AUTO_PROFILER_LABEL("ContentParent::LaunchSubprocess", OTHER);
  const bool isSync = aRetval.is<bool*>();

  Telemetry::Accumulate(Telemetry::CONTENT_PROCESS_LAUNCH_IS_SYNC,
                        static_cast<uint32_t>(isSync));

  auto earlyReject = [aRetval, isSync]() {
    if (isSync) {
      *aRetval.as<bool*>() = false;
    } else {
      *aRetval.as<RefPtr<LaunchPromise>*>() = LaunchPromise::CreateAndReject(
          GeckoChildProcessHost::LaunchError(), __func__);
    }
  };

  if (!ContentProcessManager::GetSingleton()) {
    // Shutdown has begun, we shouldn't spawn any more child processes.
    earlyReject();
    return;
  }

  std::vector<std::string> extraArgs;
  extraArgs.push_back("-childID");
  char idStr[21];
  SprintfLiteral(idStr, "%" PRId64, static_cast<uint64_t>(mChildID));
  extraArgs.push_back(idStr);
  extraArgs.push_back(IsForBrowser() ? "-isForBrowser" : "-notForBrowser");

  // Prefs information is passed via anonymous shared memory to avoid bloating
  // the command line.

  SharedPreferenceSerializer prefSerializer;
  if (!prefSerializer.SerializeToSharedMemory()) {
    MarkAsDead();
    earlyReject();
    return;
  }
  prefSerializer.AddSharedPrefCmdLineArgs(*mSubprocess, extraArgs);

  // Register ContentParent as an observer for changes to any pref
  // whose prefix matches the empty string, i.e. all of them.  The
  // observation starts here in order to capture pref updates that
  // happen during async launch.
  Preferences::AddStrongObserver(this, "");

  if (gSafeMode) {
    extraArgs.push_back("-safeMode");
  }

#if defined(XP_MACOSX) && defined(MOZ_SANDBOX)
  // If we're launching a middleman process for a
  // recording or replay, start the sandbox later.
  if (sEarlySandboxInit && IsContentSandboxEnabled() &&
      !IsRecordingOrReplaying()) {
    AppendSandboxParams(extraArgs);
  }
#endif

  nsCString parentBuildID(mozilla::PlatformBuildID());
  extraArgs.push_back("-parentBuildID");
  extraArgs.push_back(parentBuildID.get());

  // Specify whether the process is recording or replaying an execution.
  if (mRecordReplayState != eNotRecordingOrReplaying) {
    nsPrintfCString buf(
        "%d", mRecordReplayState == eRecording
                  ? (int)recordreplay::ProcessKind::MiddlemanRecording
                  : (int)recordreplay::ProcessKind::MiddlemanReplaying);
    extraArgs.push_back(recordreplay::gProcessKindOption);
    extraArgs.push_back(buf.get());

    extraArgs.push_back(recordreplay::gRecordingFileOption);
    extraArgs.push_back(NS_ConvertUTF16toUTF8(mRecordingFile).get());
  }

  RefPtr<ContentParent> self(this);

  auto reject = [self, this](GeckoChildProcessHost::LaunchError err) {
    NS_ERROR("failed to launch child in the parent");
    MarkAsDead();
    return LaunchPromise::CreateAndReject(err, __func__);
  };

  // See also ActorDestroy.
  mSelfRef = this;

  // Lifetime note: the GeckoChildProcessHost holds a strong reference
  // to the launch promise, which takes ownership of these closures,
  // which hold strong references to this ContentParent; the
  // ContentParent then owns the GeckoChildProcessHost (and that
  // ownership is not exposed to the cycle collector).  Therefore,
  // this all stays alive until the promise is resolved or rejected.

  auto resolve = [self, this, aInitialPriority, isSync,
                  // Transfer ownership of RAII file descriptor/handle
                  // holders so that they won't be closed before the
                  // child can inherit them.
                  prefSerializer =
                      std::move(prefSerializer)](base::ProcessHandle handle) {
    AUTO_PROFILER_LABEL("ContentParent::LaunchSubprocess::resolve", OTHER);
    const auto launchResumeTS = TimeStamp::Now();

    base::ProcessId procId = base::GetProcId(handle);
    Open(mSubprocess->GetChannel(), procId);
#ifdef MOZ_CODE_COVERAGE
    Unused << SendShareCodeCoverageMutex(
        CodeCoverageHandler::Get()->GetMutexHandle(procId));
#endif

    mLifecycleState = LifecycleState::ALIVE;
    InitInternal(aInitialPriority);

    ContentProcessManager::GetSingleton()->AddContentProcess(this);

    mHangMonitorActor = ProcessHangMonitor::AddProcess(this);

    // Set a reply timeout for CPOWs.
    SetReplyTimeoutMs(Preferences::GetInt("dom.ipc.cpow.timeout", 0));

    nsCOMPtr<nsIObserverService> obs = mozilla::services::GetObserverService();
    if (obs) {
      nsAutoString cpId;
      cpId.AppendInt(static_cast<uint64_t>(this->ChildID()));
      obs->NotifyObservers(static_cast<nsIObserver*>(this),
                           "ipc:content-initializing", cpId.get());
    }

    Init();

    if (isSync) {
      Telemetry::AccumulateTimeDelta(Telemetry::CONTENT_PROCESS_SYNC_LAUNCH_MS,
                                     mLaunchTS);
    } else {
      Telemetry::AccumulateTimeDelta(Telemetry::CONTENT_PROCESS_LAUNCH_TOTAL_MS,
                                     mLaunchTS);

      Telemetry::Accumulate(
          Telemetry::CONTENT_PROCESS_LAUNCH_MAINTHREAD_MS,
          static_cast<uint32_t>(((mLaunchYieldTS - mLaunchTS) +
                                 (TimeStamp::Now() - launchResumeTS))
                                    .ToMilliseconds()));
    }

    return LaunchPromise::CreateAndResolve(self, __func__);
  };

  if (isSync) {
    bool ok = mSubprocess->LaunchAndWaitForProcessHandle(std::move(extraArgs));
    if (ok) {
      Unused << resolve(mSubprocess->GetChildProcessHandle());
    } else {
      Unused << reject(GeckoChildProcessHost::LaunchError{});
    }
    *aRetval.as<bool*>() = ok;
  } else {
    auto* retptr = aRetval.as<RefPtr<LaunchPromise>*>();
    if (mSubprocess->AsyncLaunch(std::move(extraArgs))) {
      RefPtr<GeckoChildProcessHost::HandlePromise> ready =
          mSubprocess->WhenProcessHandleReady();
      mLaunchYieldTS = TimeStamp::Now();
      *retptr = ready->Then(GetCurrentThreadSerialEventTarget(), __func__,
                            std::move(resolve), std::move(reject));
    } else {
      *retptr = reject(GeckoChildProcessHost::LaunchError{});
    }
  }
}

/* static */
bool ContentParent::LaunchSubprocessSync(
    hal::ProcessPriority aInitialPriority) {
  bool retval;
  LaunchSubprocessInternal(aInitialPriority, mozilla::AsVariant(&retval));
  return retval;
}

/* static */ RefPtr<ContentParent::LaunchPromise>
ContentParent::LaunchSubprocessAsync(hal::ProcessPriority aInitialPriority) {
  RefPtr<LaunchPromise> retval;
  LaunchSubprocessInternal(aInitialPriority, mozilla::AsVariant(&retval));
  return retval;
}

ContentParent::ContentParent(ContentParent* aOpener,
                             const nsAString& aRemoteType,
                             RecordReplayState aRecordReplayState,
                             const nsAString& aRecordingFile,
                             int32_t aJSPluginID)
    : mSelfRef(nullptr),
      mSubprocess(nullptr),
      mLaunchTS(TimeStamp::Now()),
      mLaunchYieldTS(mLaunchTS),
      mActivateTS(mLaunchTS),
      mOpener(aOpener),
      mRemoteType(aRemoteType),
      mChildID(gContentChildID++),
      mGeolocationWatchID(-1),
      mJSPluginID(aJSPluginID),
      mRemoteWorkerActors(0),
      mNumDestroyingTabs(0),
      mLifecycleState(LifecycleState::LAUNCHING),
      mIsForBrowser(!mRemoteType.IsEmpty()),
      mRecordReplayState(aRecordReplayState),
      mRecordingFile(aRecordingFile),
      mCalledClose(false),
      mCalledKillHard(false),
      mCreatedPairedMinidumps(false),
      mShutdownPending(false),
      mIPCOpen(true),
      mIsRemoteInputEventQueueEnabled(false),
      mIsInputPriorityEventEnabled(false),
      mHangMonitorActor(nullptr) {
  // Insert ourselves into the global linked list of ContentParent objects.
  if (!sContentParents) {
    sContentParents = new LinkedList<ContentParent>();
  }
  sContentParents->insertBack(this);

  mMessageManager = nsFrameMessageManager::NewProcessMessageManager(true);

  // From this point on, NS_WARNING, NS_ASSERTION, etc. should print out the
  // PID along with the warning.
  nsDebugImpl::SetMultiprocessMode("Parent");

#if defined(XP_WIN)
  if (XRE_IsParentProcess()) {
    audio::AudioNotificationSender::Init();
  }
  // Request Windows message deferral behavior on our side of the PContent
  // channel. Generally only applies to the situation where we get caught in
  // a deadlock with the plugin process when sending CPOWs.
  GetIPCChannel()->SetChannelFlags(
      MessageChannel::REQUIRE_DEFERRED_MESSAGE_PROTECTION);
#endif

  NS_ASSERTION(NS_IsMainThread(), "Wrong thread!");
  bool isFile = mRemoteType.EqualsLiteral(FILE_REMOTE_TYPE);
  mSubprocess = new GeckoChildProcessHost(GeckoProcessType_Content, isFile);

#if defined(XP_MACOSX) && defined(MOZ_SANDBOX)
  // sEarlySandboxInit is statically initialized to false.
  // Once we've set it to true due to the pref, avoid checking the
  // pref on subsequent calls. As a result, changing the earlyinit
  // pref requires restarting the browser to take effect.
  if (!ContentParent::sEarlySandboxInit) {
    ContentParent::sEarlySandboxInit =
        Preferences::GetBool("security.sandbox.content.mac.earlyinit");
  }
#endif
}

ContentParent::~ContentParent() {
  if (mForceKillTimer) {
    mForceKillTimer->Cancel();
  }

  NS_ASSERTION(NS_IsMainThread(), "Wrong thread!");

  // We should be removed from all these lists in ActorDestroy.
  MOZ_ASSERT(!sPrivateContent || !sPrivateContent->Contains(this));
  if (IsForJSPlugin()) {
    MOZ_ASSERT(!sJSPluginContentParents ||
               !sJSPluginContentParents->Get(mJSPluginID));
  } else {
    MOZ_ASSERT(!sBrowserContentParents ||
               !sBrowserContentParents->Contains(mRemoteType) ||
               !sBrowserContentParents->Get(mRemoteType)->Contains(this));
  }

  // Normally mSubprocess is destroyed in ActorDestroy, but that won't
  // happen if the process wasn't launched or if it failed to launch.
  if (mSubprocess) {
    mSubprocess->Destroy();
  }
}

void ContentParent::InitInternal(ProcessPriority aInitialPriority) {
  XPCOMInitData xpcomInit;

  nsCOMPtr<nsIIOService> io(do_GetIOService());
  MOZ_ASSERT(io, "No IO service?");
  DebugOnly<nsresult> rv = io->GetOffline(&xpcomInit.isOffline());
  MOZ_ASSERT(NS_SUCCEEDED(rv), "Failed getting offline?");

  rv = io->GetConnectivity(&xpcomInit.isConnected());
  MOZ_ASSERT(NS_SUCCEEDED(rv), "Failed getting connectivity?");

  xpcomInit.captivePortalState() = nsICaptivePortalService::UNKNOWN;
  nsCOMPtr<nsICaptivePortalService> cps =
      do_GetService(NS_CAPTIVEPORTAL_CONTRACTID);
  if (cps) {
    cps->GetState(&xpcomInit.captivePortalState());
  }

  nsIBidiKeyboard* bidi = nsContentUtils::GetBidiKeyboard();

  xpcomInit.isLangRTL() = false;
  xpcomInit.haveBidiKeyboards() = false;
  if (bidi) {
    bidi->IsLangRTL(&xpcomInit.isLangRTL());
    bidi->GetHaveBidiKeyboards(&xpcomInit.haveBidiKeyboards());
  }

  RefPtr<mozSpellChecker> spellChecker(mozSpellChecker::Create());
  MOZ_ASSERT(spellChecker, "No spell checker?");

  spellChecker->GetDictionaryList(&xpcomInit.dictionaries());

  LocaleService::GetInstance()->GetAppLocalesAsLangTags(xpcomInit.appLocales());
  LocaleService::GetInstance()->GetRequestedLocales(
      xpcomInit.requestedLocales());

  nsCOMPtr<nsIClipboard> clipboard(
      do_GetService("@mozilla.org/widget/clipboard;1"));
  MOZ_ASSERT(clipboard, "No clipboard?");

  rv = clipboard->SupportsSelectionClipboard(
      &xpcomInit.clipboardCaps().supportsSelectionClipboard());
  MOZ_ASSERT(NS_SUCCEEDED(rv));

  rv = clipboard->SupportsFindClipboard(
      &xpcomInit.clipboardCaps().supportsFindClipboard());
  MOZ_ASSERT(NS_SUCCEEDED(rv));

  // Let's copy the domain policy from the parent to the child (if it's active).
  StructuredCloneData initialData;
  nsIScriptSecurityManager* ssm = nsContentUtils::GetSecurityManager();
  if (ssm) {
    ssm->CloneDomainPolicy(&xpcomInit.domainPolicy());

    if (ParentProcessMessageManager* mm =
            nsFrameMessageManager::sParentProcessManager) {
      AutoJSAPI jsapi;
      if (NS_WARN_IF(!jsapi.Init(xpc::PrivilegedJunkScope()))) {
        MOZ_CRASH();
      }
      JS::RootedValue init(jsapi.cx());
      // We'll crash on failure, so use a IgnoredErrorResult (which also
      // auto-suppresses exceptions).
      IgnoredErrorResult rv;
      mm->GetInitialProcessData(jsapi.cx(), &init, rv);
      if (NS_WARN_IF(rv.Failed())) {
        MOZ_CRASH();
      }

      initialData.Write(jsapi.cx(), init, rv);
      if (NS_WARN_IF(rv.Failed())) {
        MOZ_CRASH();
      }
    }
  }
  // This is only implemented (returns a non-empty list) by MacOSX and Linux
  // at present.
  nsTArray<SystemFontListEntry> fontList;
  gfxPlatform::GetPlatform()->ReadSystemFontList(&fontList);
  nsTArray<LookAndFeelInt> lnfCache = LookAndFeel::GetIntCache();

  // Content processes have no permission to access profile directory, so we
  // send the file URL instead.
  StyleSheet* ucs = nsLayoutStylesheetCache::Singleton()->GetUserContentSheet();
  if (ucs) {
    SerializeURI(ucs->GetSheetURI(), xpcomInit.userContentSheetURL());
  } else {
    SerializeURI(nullptr, xpcomInit.userContentSheetURL());
  }

  // 1. Build ContentDeviceData first, as it may affect some gfxVars.
  gfxPlatform::GetPlatform()->BuildContentDeviceData(
      &xpcomInit.contentDeviceData());
  // 2. Gather non-default gfxVars.
  xpcomInit.gfxNonDefaultVarUpdates() = gfxVars::FetchNonDefaultVars();
  // 3. Start listening for gfxVars updates, to notify content process later on.
  gfxVars::AddReceiver(this);

  nsCOMPtr<nsIGfxInfo> gfxInfo = services::GetGfxInfo();
  if (gfxInfo) {
    for (int32_t i = 1; i <= nsIGfxInfo::FEATURE_MAX_VALUE; ++i) {
      int32_t status = 0;
      nsAutoCString failureId;
      gfxInfo->GetFeatureStatus(i, failureId, &status);
      dom::GfxInfoFeatureStatus gfxFeatureStatus;
      gfxFeatureStatus.feature() = i;
      gfxFeatureStatus.status() = status;
      gfxFeatureStatus.failureId() = failureId;
      xpcomInit.gfxFeatureStatus().AppendElement(gfxFeatureStatus);
    }
  }

  DataStorage::GetAllChildProcessData(xpcomInit.dataStorage());

  // Send the dynamic scalar definitions to the new process.
  TelemetryIPC::GetDynamicScalarDefinitions(xpcomInit.dynamicScalarDefs());

  // Must send screen info before send initialData
  ScreenManager& screenManager = ScreenManager::GetSingleton();
  screenManager.CopyScreensToRemote(this);

  // Send the UA sheet shared memory buffer and the address it is mapped at.
  auto cache = nsLayoutStylesheetCache::Singleton();
  Maybe<SharedMemoryHandle> sharedUASheetHandle;
  uintptr_t sharedUASheetAddress = cache->GetSharedMemoryAddress();

  SharedMemoryHandle handle;
  if (cache->ShareToProcess(OtherPid(), &handle)) {
    sharedUASheetHandle.emplace(handle);
  } else {
    sharedUASheetAddress = 0;
  }

  Unused << SendSetXPCOMProcessAttributes(xpcomInit, initialData, lnfCache,
                                          fontList, sharedUASheetHandle,
                                          sharedUASheetAddress);

  ipc::WritableSharedMap* sharedData =
      nsFrameMessageManager::sParentProcessManager->SharedData();
  sharedData->Flush();
  sharedData->SendTo(this);

  nsCOMPtr<nsIChromeRegistry> registrySvc = nsChromeRegistry::GetService();
  nsChromeRegistryChrome* chromeRegistry =
      static_cast<nsChromeRegistryChrome*>(registrySvc.get());
  chromeRegistry->SendRegisteredChrome(this);

  nsCOMPtr<nsIStringBundleService> stringBundleService =
      services::GetStringBundleService();
  stringBundleService->SendContentBundles(this);

  if (gAppData) {
    nsCString version(gAppData->version);
    nsCString buildID(gAppData->buildID);
    nsCString name(gAppData->name);
    nsCString UAName(gAppData->UAName);
    nsCString ID(gAppData->ID);
    nsCString vendor(gAppData->vendor);
    nsCString sourceURL(gAppData->sourceURL);

    // Sending all information to content process.
    Unused << SendAppInfo(version, buildID, name, UAName, ID, vendor,
                          sourceURL);
  }

  // Send the child its remote type. On Mac, this needs to be sent prior
  // to the message we send to enable the Sandbox (SendStartProcessSandbox)
  // because different remote types require different sandbox privileges.
  Unused << SendRemoteType(mRemoteType);

  ScriptPreloader::InitContentChild(*this);

  // Initialize the message manager (and load delayed scripts) now that we
  // have established communications with the child.
  mMessageManager->InitWithCallback(this);

  // Set the subprocess's priority.  We do this early on because we're likely
  // /lowering/ the process's CPU and memory priority, which it has inherited
  // from this process.
  //
  // This call can cause us to send IPC messages to the child process, so it
  // must come after the Open() call above.
  ProcessPriorityManager::SetProcessPriority(this, aInitialPriority);

  // NB: internally, this will send an IPC message to the child
  // process to get it to create the CompositorBridgeChild.  This
  // message goes through the regular IPC queue for this
  // channel, so delivery will happen-before any other messages
  // we send.  The CompositorBridgeChild must be created before any
  // PBrowsers are created, because they rely on the Compositor
  // already being around.  (Creation is async, so can't happen
  // on demand.)
  GPUProcessManager* gpm = GPUProcessManager::Get();

  Endpoint<PCompositorManagerChild> compositor;
  Endpoint<PImageBridgeChild> imageBridge;
  Endpoint<PVRManagerChild> vrBridge;
  Endpoint<PVideoDecoderManagerChild> videoManager;
  AutoTArray<uint32_t, 3> namespaces;

  DebugOnly<bool> opened =
      gpm->CreateContentBridges(OtherPid(), &compositor, &imageBridge,
                                &vrBridge, &videoManager, &namespaces);
  MOZ_ASSERT(opened);

  Unused << SendInitRendering(std::move(compositor), std::move(imageBridge),
                              std::move(vrBridge), std::move(videoManager),
                              namespaces);

  gpm->AddListener(this);

  nsStyleSheetService* sheetService = nsStyleSheetService::GetInstance();
  if (sheetService) {
    // This looks like a lot of work, but in a normal browser session we just
    // send two loads.
    //
    // The URIs of the Gecko and Servo sheets should be the same, so it
    // shouldn't matter which we look at.

    for (StyleSheet* sheet : *sheetService->AgentStyleSheets()) {
      URIParams uri;
      SerializeURI(sheet->GetSheetURI(), uri);
      Unused << SendLoadAndRegisterSheet(uri,
                                         nsIStyleSheetService::AGENT_SHEET);
    }

    for (StyleSheet* sheet : *sheetService->UserStyleSheets()) {
      URIParams uri;
      SerializeURI(sheet->GetSheetURI(), uri);
      Unused << SendLoadAndRegisterSheet(uri, nsIStyleSheetService::USER_SHEET);
    }

    for (StyleSheet* sheet : *sheetService->AuthorStyleSheets()) {
      URIParams uri;
      SerializeURI(sheet->GetSheetURI(), uri);
      Unused << SendLoadAndRegisterSheet(uri,
                                         nsIStyleSheetService::AUTHOR_SHEET);
    }
  }

#if defined(XP_WIN)
  // Send the info needed to join the browser process's audio session.
  nsID id;
  nsString sessionName;
  nsString iconPath;
  if (NS_SUCCEEDED(
          mozilla::widget::GetAudioSessionData(id, sessionName, iconPath))) {
    Unused << SendSetAudioSessionData(id, sessionName, iconPath);
  }
#endif

#ifdef MOZ_SANDBOX
  bool shouldSandbox = true;
  Maybe<FileDescriptor> brokerFd;
  // XXX: Checking the pref here makes it possible to enable/disable sandboxing
  // during an active session. Currently the pref is only used for testing
  // purpose. If the decision is made to permanently rely on the pref, this
  // should be changed so that it is required to restart firefox for the change
  // of value to take effect. Always send SetProcessSandbox message on macOS.
#  if !defined(XP_MACOSX)
  shouldSandbox = IsContentSandboxEnabled();
#  endif

#  ifdef XP_LINUX
  if (shouldSandbox) {
    MOZ_ASSERT(!mSandboxBroker);
    bool isFileProcess = mRemoteType.EqualsLiteral(FILE_REMOTE_TYPE);
    UniquePtr<SandboxBroker::Policy> policy =
        sSandboxBrokerPolicyFactory->GetContentPolicy(Pid(), isFileProcess);
    if (policy) {
      brokerFd = Some(FileDescriptor());
      mSandboxBroker =
          SandboxBroker::Create(std::move(policy), Pid(), brokerFd.ref());
      if (!mSandboxBroker) {
        KillHard("SandboxBroker::Create failed");
        return;
      }
      MOZ_ASSERT(brokerFd.ref().IsValid());
    }
  }
#  endif
  if (shouldSandbox && !SendSetProcessSandbox(brokerFd)) {
    KillHard("SandboxInitFailed");
  }
#endif

  if (!ServiceWorkerParentInterceptEnabled()) {
    RefPtr<ServiceWorkerRegistrar> swr = ServiceWorkerRegistrar::Get();
    MOZ_ASSERT(swr);

    nsTArray<ServiceWorkerRegistrationData> registrations;
    swr->GetRegistrations(registrations);

    // Send down to the content process the permissions for each of the
    // registered service worker scopes.
    for (auto& registration : registrations) {
      nsCOMPtr<nsIPrincipal> principal =
          PrincipalInfoToPrincipal(registration.principal());
      if (principal) {
        TransmitPermissionsForPrincipal(principal);
      }
    }

    Unused << SendInitServiceWorkers(ServiceWorkerConfiguration(registrations));
  }

  {
    nsTArray<BlobURLRegistrationData> registrations;
    if (BlobURLProtocolHandler::GetAllBlobURLEntries(registrations, this)) {
      for (const BlobURLRegistrationData& registration : registrations) {
        nsresult rv = TransmitPermissionsForPrincipal(registration.principal());
        Unused << NS_WARN_IF(NS_FAILED(rv));
      }

      Unused << SendInitBlobURLs(registrations);
    }
  }

  // Send down WindowActorOptions at startup to content process.
  RefPtr<JSWindowActorService> actorSvc = JSWindowActorService::GetSingleton();
  if (actorSvc) {
    nsTArray<JSWindowActorInfo> infos;
    actorSvc->GetJSWindowActorInfos(infos);
    Unused << SendInitJSWindowActorInfos(infos);
  }

  // Start up nsPluginHost and run FindPlugins to cache the plugin list.
  // If this isn't our first content process, just send over cached list.
  RefPtr<nsPluginHost> pluginHost = nsPluginHost::GetInst();
  pluginHost->SendPluginsToContent();
  MaybeEnableRemoteInputEventQueue();
}

bool ContentParent::IsAlive() const {
  return mLifecycleState == LifecycleState::ALIVE;
}

int32_t ContentParent::Pid() const {
  if (!mSubprocess || !mSubprocess->GetChildProcessHandle()) {
    return -1;
  }
  return base::GetProcId(mSubprocess->GetChildProcessHandle());
}

mozilla::ipc::IPCResult ContentParent::RecvGetGfxVars(
    InfallibleTArray<GfxVarUpdate>* aVars) {
  // Ensure gfxVars is initialized (for xpcshell tests).
  gfxVars::Initialize();

  *aVars = gfxVars::FetchNonDefaultVars();

  // Now that content has initialized gfxVars, we can start listening for
  // updates.
  gfxVars::AddReceiver(this);
  return IPC_OK();
}

void ContentParent::OnCompositorUnexpectedShutdown() {
  GPUProcessManager* gpm = GPUProcessManager::Get();

  Endpoint<PCompositorManagerChild> compositor;
  Endpoint<PImageBridgeChild> imageBridge;
  Endpoint<PVRManagerChild> vrBridge;
  Endpoint<PVideoDecoderManagerChild> videoManager;
  AutoTArray<uint32_t, 3> namespaces;

  DebugOnly<bool> opened =
      gpm->CreateContentBridges(OtherPid(), &compositor, &imageBridge,
                                &vrBridge, &videoManager, &namespaces);
  MOZ_ASSERT(opened);

  Unused << SendReinitRendering(std::move(compositor), std::move(imageBridge),
                                std::move(vrBridge), std::move(videoManager),
                                namespaces);
}

void ContentParent::OnCompositorDeviceReset() {
  Unused << SendReinitRenderingForDeviceReset();
}

PClientOpenWindowOpParent* ContentParent::AllocPClientOpenWindowOpParent(
    const ClientOpenWindowArgs& aArgs) {
  return AllocClientOpenWindowOpParent(aArgs);
}

bool ContentParent::DeallocPClientOpenWindowOpParent(
    PClientOpenWindowOpParent* aActor) {
  return DeallocClientOpenWindowOpParent(aActor);
}

void ContentParent::MaybeEnableRemoteInputEventQueue() {
  MOZ_ASSERT(!mIsRemoteInputEventQueueEnabled);
  if (!IsInputEventQueueSupported()) {
    return;
  }
  mIsRemoteInputEventQueueEnabled = true;
  Unused << SendSetInputEventQueueEnabled();
  SetInputPriorityEventEnabled(true);
}

void ContentParent::SetInputPriorityEventEnabled(bool aEnabled) {
  if (!IsInputEventQueueSupported() || !mIsRemoteInputEventQueueEnabled ||
      mIsInputPriorityEventEnabled == aEnabled) {
    return;
  }
  mIsInputPriorityEventEnabled = aEnabled;
  // Send IPC messages to flush the pending events in the input event queue and
  // the normal event queue. See PContent.ipdl for more details.
  Unused << SendSuspendInputEventQueue();
  Unused << SendFlushInputEventQueue();
  Unused << SendResumeInputEventQueue();
}

/*static*/
bool ContentParent::IsInputEventQueueSupported() {
  static bool sSupported = false;
  static bool sInitialized = false;
  if (!sInitialized) {
    MOZ_ASSERT(Preferences::IsServiceAvailable());
    sSupported = Preferences::GetBool("input_event_queue.supported", false);
    sInitialized = true;
  }
  return sSupported;
}

void ContentParent::OnVarChanged(const GfxVarUpdate& aVar) {
  if (!mIPCOpen) {
    return;
  }
  Unused << SendVarUpdate(aVar);
}

mozilla::ipc::IPCResult ContentParent::RecvReadFontList(
    InfallibleTArray<FontListEntry>* retValue) {
#ifdef ANDROID
  gfxAndroidPlatform::GetPlatform()->GetSystemFontList(retValue);
#endif
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvSetClipboard(
    const IPCDataTransfer& aDataTransfer, const bool& aIsPrivateData,
    const IPC::Principal& aRequestingPrincipal,
    const uint32_t& aContentPolicyType, const int32_t& aWhichClipboard) {
  nsresult rv;
  nsCOMPtr<nsIClipboard> clipboard(do_GetService(kCClipboardCID, &rv));
  NS_ENSURE_SUCCESS(rv, IPC_OK());

  nsCOMPtr<nsITransferable> trans =
      do_CreateInstance("@mozilla.org/widget/transferable;1", &rv);
  NS_ENSURE_SUCCESS(rv, IPC_OK());
  trans->Init(nullptr);

  rv = nsContentUtils::IPCTransferableToTransferable(
      aDataTransfer, aIsPrivateData, aRequestingPrincipal, aContentPolicyType,
      trans, this, nullptr);
  NS_ENSURE_SUCCESS(rv, IPC_OK());

  clipboard->SetData(trans, nullptr, aWhichClipboard);
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvGetClipboard(
    nsTArray<nsCString>&& aTypes, const int32_t& aWhichClipboard,
    IPCDataTransfer* aDataTransfer) {
  nsresult rv;
  nsCOMPtr<nsIClipboard> clipboard(do_GetService(kCClipboardCID, &rv));
  NS_ENSURE_SUCCESS(rv, IPC_OK());

  nsCOMPtr<nsITransferable> trans =
      do_CreateInstance("@mozilla.org/widget/transferable;1", &rv);
  NS_ENSURE_SUCCESS(rv, IPC_OK());
  trans->Init(nullptr);

  for (uint32_t t = 0; t < aTypes.Length(); t++) {
    trans->AddDataFlavor(aTypes[t].get());
  }

  clipboard->GetData(trans, aWhichClipboard);
  nsContentUtils::TransferableToIPCTransferable(trans, aDataTransfer, true,
                                                nullptr, this);
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvEmptyClipboard(
    const int32_t& aWhichClipboard) {
  nsresult rv;
  nsCOMPtr<nsIClipboard> clipboard(do_GetService(kCClipboardCID, &rv));
  NS_ENSURE_SUCCESS(rv, IPC_OK());

  clipboard->EmptyClipboard(aWhichClipboard);

  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvClipboardHasType(
    nsTArray<nsCString>&& aTypes, const int32_t& aWhichClipboard,
    bool* aHasType) {
  nsresult rv;
  nsCOMPtr<nsIClipboard> clipboard(do_GetService(kCClipboardCID, &rv));
  NS_ENSURE_SUCCESS(rv, IPC_OK());

  const char** typesChrs = new const char*[aTypes.Length()];
  for (uint32_t t = 0; t < aTypes.Length(); t++) {
    typesChrs[t] = aTypes[t].get();
  }

  clipboard->HasDataMatchingFlavors(typesChrs, aTypes.Length(), aWhichClipboard,
                                    aHasType);

  delete[] typesChrs;
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvGetExternalClipboardFormats(
    const int32_t& aWhichClipboard, const bool& aPlainTextOnly,
    nsTArray<nsCString>* aTypes) {
  MOZ_ASSERT(aTypes);
  DataTransfer::GetExternalClipboardFormats(aWhichClipboard, aPlainTextOnly,
                                            aTypes);
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvPlaySound(const URIParams& aURI) {
  nsCOMPtr<nsIURI> soundURI = DeserializeURI(aURI);
  bool isChrome = false;
  // If the check here fails, it can only mean that this message was spoofed.
  if (!soundURI || NS_FAILED(soundURI->SchemeIs("chrome", &isChrome)) ||
      !isChrome) {
    // PlaySound only accepts a valid chrome URI.
    return IPC_FAIL_NO_REASON(this);
  }
  nsCOMPtr<nsIURL> soundURL(do_QueryInterface(soundURI));
  if (!soundURL) {
    return IPC_OK();
  }

  nsresult rv;
  nsCOMPtr<nsISound> sound(do_GetService(NS_SOUND_CID, &rv));
  NS_ENSURE_SUCCESS(rv, IPC_OK());

  sound->Play(soundURL);

  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvBeep() {
  nsresult rv;
  nsCOMPtr<nsISound> sound(do_GetService(NS_SOUND_CID, &rv));
  NS_ENSURE_SUCCESS(rv, IPC_OK());

  sound->Beep();

  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvPlayEventSound(
    const uint32_t& aEventId) {
  nsresult rv;
  nsCOMPtr<nsISound> sound(do_GetService(NS_SOUND_CID, &rv));
  NS_ENSURE_SUCCESS(rv, IPC_OK());

  sound->PlayEventSound(aEventId);

  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvGetIconForExtension(
    const nsCString& aFileExt, const uint32_t& aIconSize,
    InfallibleTArray<uint8_t>* bits) {
#ifdef MOZ_WIDGET_ANDROID
  NS_ASSERTION(AndroidBridge::Bridge() != nullptr,
               "AndroidBridge is not available");
  if (AndroidBridge::Bridge() == nullptr) {
    // Do not fail - just no icon will be shown
    return IPC_OK();
  }

  bits->AppendElements(aIconSize * aIconSize * 4);

  AndroidBridge::Bridge()->GetIconForExtension(aFileExt, aIconSize,
                                               bits->Elements());
#endif
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvGetShowPasswordSetting(
    bool* showPassword) {
  // default behavior is to show the last password character
  *showPassword = true;
#ifdef MOZ_WIDGET_ANDROID
  NS_ASSERTION(AndroidBridge::Bridge() != nullptr,
               "AndroidBridge is not available");

  *showPassword = java::GeckoAppShell::GetShowPasswordSetting();
#endif
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvFirstIdle() {
  // When the ContentChild goes idle, it sends us a FirstIdle message
  // which we use as a good time to signal the PreallocatedProcessManager
  // that it can start allocating processes from now on.
  PreallocatedProcessManager::RemoveBlocker(this);
  return IPC_OK();
}

// We want ContentParent to show up in CC logs for debugging purposes, but we
// don't actually cycle collect it.
NS_IMPL_CYCLE_COLLECTION_0(ContentParent)

NS_IMPL_CYCLE_COLLECTING_ADDREF(ContentParent)
NS_IMPL_CYCLE_COLLECTING_RELEASE(ContentParent)

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(ContentParent)
  NS_INTERFACE_MAP_ENTRY_CONCRETE(ContentParent)
  NS_INTERFACE_MAP_ENTRY(nsIObserver)
  NS_INTERFACE_MAP_ENTRY(nsIDOMGeoPositionCallback)
  NS_INTERFACE_MAP_ENTRY(nsIDOMGeoPositionErrorCallback)
  NS_INTERFACE_MAP_ENTRY(nsIInterfaceRequestor)
  NS_INTERFACE_MAP_ENTRY_AMBIGUOUS(nsISupports, nsIObserver)
NS_INTERFACE_MAP_END

NS_IMETHODIMP
ContentParent::Observe(nsISupports* aSubject, const char* aTopic,
                       const char16_t* aData) {
  if (mSubprocess && (!strcmp(aTopic, "profile-before-change") ||
                      !strcmp(aTopic, "xpcom-shutdown"))) {
    // Make sure that our process will get scheduled.
    ProcessPriorityManager::SetProcessPriority(this,
                                               PROCESS_PRIORITY_FOREGROUND);

    // Okay to call ShutDownProcess multiple times.
    ShutDownProcess(SEND_SHUTDOWN_MESSAGE);
    MarkAsDead();

    // Wait for shutdown to complete, so that we receive any shutdown
    // data (e.g. telemetry) from the child before we quit.
    // This loop terminate prematurely based on mForceKillTimer.
    SpinEventLoopUntil([&]() { return !mIPCOpen || mCalledKillHard; });
    NS_ASSERTION(!mSubprocess, "Close should have nulled mSubprocess");
  }

  if (IsDead() || !mSubprocess) {
    return NS_OK;
  }

  if (!strcmp(aTopic, "nsPref:changed")) {
    // A pref changed. If it's not on the blacklist, inform child processes.
#define BLACKLIST_ENTRY(s) \
  { s, (sizeof(s) / sizeof(char16_t)) - 1 }
    struct BlacklistEntry {
      const char16_t* mPrefBranch;
      size_t mLen;
    };
    // These prefs are not useful in child processes.
    static const BlacklistEntry sContentPrefBranchBlacklist[] = {
        BLACKLIST_ENTRY(u"app.update.lastUpdateTime."),
        BLACKLIST_ENTRY(u"datareporting.policy."),
        BLACKLIST_ENTRY(u"browser.safebrowsing.provider."),
        BLACKLIST_ENTRY(u"browser.shell."),
        BLACKLIST_ENTRY(u"browser.slowstartup."),
        BLACKLIST_ENTRY(u"extensions.getAddons.cache."),
        BLACKLIST_ENTRY(u"media.gmp-manager."),
        BLACKLIST_ENTRY(u"media.gmp-gmpopenh264."),
        BLACKLIST_ENTRY(u"privacy.sanitize."),
    };
#undef BLACKLIST_ENTRY

    for (const auto& entry : sContentPrefBranchBlacklist) {
      if (NS_strncmp(entry.mPrefBranch, aData, entry.mLen) == 0) {
        return NS_OK;
      }
    }

    // We know prefs are ASCII here.
    NS_LossyConvertUTF16toASCII strData(aData);

    Pref pref(strData, /* isLocked */ false, Nothing(), Nothing());
    Preferences::GetPreference(&pref);
    if (IsAlive()) {
      MOZ_ASSERT(mQueuedPrefs.IsEmpty());
      if (!SendPreferenceUpdate(pref)) {
        return NS_ERROR_NOT_AVAILABLE;
      }
    } else {
      MOZ_ASSERT(IsLaunching());
      mQueuedPrefs.AppendElement(pref);
    }
  }

  if (!IsAlive()) {
    return NS_OK;
  }

  // listening for memory pressure event
  if (!strcmp(aTopic, "memory-pressure")) {
    Unused << SendFlushMemory(nsDependentString(aData));
  } else if (!strcmp(aTopic, NS_IPC_IOSERVICE_SET_OFFLINE_TOPIC)) {
    NS_ConvertUTF16toUTF8 dataStr(aData);
    const char* offline = dataStr.get();
    if (!SendSetOffline(!strcmp(offline, "true") ? true : false)) {
      return NS_ERROR_NOT_AVAILABLE;
    }
  } else if (!strcmp(aTopic, NS_IPC_IOSERVICE_SET_CONNECTIVITY_TOPIC)) {
    if (!SendSetConnectivity(NS_LITERAL_STRING("true").Equals(aData))) {
      return NS_ERROR_NOT_AVAILABLE;
    }
  } else if (!strcmp(aTopic, NS_IPC_CAPTIVE_PORTAL_SET_STATE)) {
    nsCOMPtr<nsICaptivePortalService> cps = do_QueryInterface(aSubject);
    MOZ_ASSERT(cps, "Should QI to a captive portal service");
    if (!cps) {
      return NS_ERROR_FAILURE;
    }
    int32_t state;
    cps->GetState(&state);
    if (!SendSetCaptivePortalState(state)) {
      return NS_ERROR_NOT_AVAILABLE;
    }
  }
  // listening for alert notifications
  else if (!strcmp(aTopic, "alertfinished") ||
           !strcmp(aTopic, "alertclickcallback") ||
           !strcmp(aTopic, "alertshow") ||
           !strcmp(aTopic, "alertdisablecallback") ||
           !strcmp(aTopic, "alertsettingscallback")) {
    if (!SendNotifyAlertsObserver(nsDependentCString(aTopic),
                                  nsDependentString(aData)))
      return NS_ERROR_NOT_AVAILABLE;
  } else if (!strcmp(aTopic, "child-gc-request")) {
    Unused << SendGarbageCollect();
  } else if (!strcmp(aTopic, "child-cc-request")) {
    Unused << SendCycleCollect();
  } else if (!strcmp(aTopic, "child-mmu-request")) {
    Unused << SendMinimizeMemoryUsage();
  } else if (!strcmp(aTopic, "child-ghost-request")) {
    Unused << SendUnlinkGhosts();
  } else if (!strcmp(aTopic, "last-pb-context-exited")) {
    Unused << SendLastPrivateDocShellDestroyed();
  }
#ifdef ACCESSIBILITY
  else if (aData && !strcmp(aTopic, "a11y-init-or-shutdown")) {
    if (*aData == '1') {
      // Make sure accessibility is running in content process when
      // accessibility gets initiated in chrome process.
#  if defined(XP_WIN)
      // Don't init content a11y if we detect an incompat version of JAWS in
      // use.
      if (!mozilla::a11y::Compatibility::IsOldJAWS()) {
        Unused << SendActivateA11y(
            ::GetCurrentThreadId(),
            a11y::AccessibleWrap::GetContentProcessIdFor(ChildID()));
      }
#  else
      Unused << SendActivateA11y(0, 0);
#  endif
    } else {
      // If possible, shut down accessibility in content process when
      // accessibility gets shutdown in chrome process.
      Unused << SendShutdownA11y();
    }
  }
#endif
  else if (!strcmp(aTopic, "cacheservice:empty-cache")) {
    Unused << SendNotifyEmptyHTTPCache();
  } else if (!strcmp(aTopic, "intl:app-locales-changed")) {
    nsTArray<nsCString> appLocales;
    LocaleService::GetInstance()->GetAppLocalesAsBCP47(appLocales);
    Unused << SendUpdateAppLocales(appLocales);
  } else if (!strcmp(aTopic, "intl:requested-locales-changed")) {
    nsTArray<nsCString> requestedLocales;
    LocaleService::GetInstance()->GetRequestedLocales(requestedLocales);
    Unused << SendUpdateRequestedLocales(requestedLocales);
  } else if (!strcmp(aTopic, "cookie-changed") ||
             !strcmp(aTopic, "private-cookie-changed")) {
    if (!aData) {
      return NS_ERROR_UNEXPECTED;
    }
    PNeckoParent* neckoParent = LoneManagedOrNullAsserts(ManagedPNeckoParent());
    if (!neckoParent) {
      return NS_OK;
    }
    PCookieServiceParent* csParent =
        LoneManagedOrNullAsserts(neckoParent->ManagedPCookieServiceParent());
    if (!csParent) {
      return NS_OK;
    }
    auto* cs = static_cast<CookieServiceParent*>(csParent);
    // Do not push these cookie updates to the same process they originated
    // from.
    if (cs->ProcessingCookie()) {
      return NS_OK;
    }
    if (!nsCRT::strcmp(aData, u"batch-deleted")) {
      nsCOMPtr<nsIArray> cookieList = do_QueryInterface(aSubject);
      NS_ASSERTION(cookieList, "couldn't get cookie list");
      cs->RemoveBatchDeletedCookies(cookieList);
      return NS_OK;
    }

    if (!nsCRT::strcmp(aData, u"cleared")) {
      cs->RemoveAll();
      return NS_OK;
    }

    nsCOMPtr<nsICookie> xpcCookie = do_QueryInterface(aSubject);
    NS_ASSERTION(xpcCookie, "couldn't get cookie");
    if (!nsCRT::strcmp(aData, u"deleted")) {
      cs->RemoveCookie(xpcCookie);
    } else if ((!nsCRT::strcmp(aData, u"added")) ||
               (!nsCRT::strcmp(aData, u"changed"))) {
      cs->AddCookie(xpcCookie);
    }
  } else if (!strcmp(aTopic, NS_NETWORK_LINK_TYPE_TOPIC)) {
    UpdateNetworkLinkType();
  }

  return NS_OK;
}

void ContentParent::UpdateNetworkLinkType() {
  nsresult rv;
  nsCOMPtr<nsINetworkLinkService> nls =
      do_GetService(NS_NETWORK_LINK_SERVICE_CONTRACTID, &rv);
  if (NS_FAILED(rv)) {
    return;
  }

  uint32_t linkType = nsINetworkLinkService::LINK_TYPE_UNKNOWN;
  rv = nls->GetLinkType(&linkType);
  if (NS_FAILED(rv)) {
    return;
  }

  Unused << SendNetworkLinkTypeChange(linkType);
}

NS_IMETHODIMP
ContentParent::GetInterface(const nsIID& aIID, void** aResult) {
  NS_ENSURE_ARG_POINTER(aResult);

  if (aIID.Equals(NS_GET_IID(nsIMessageSender))) {
    nsCOMPtr<nsIMessageSender> mm = GetMessageManager();
    mm.forget(aResult);
    return NS_OK;
  }

  return NS_NOINTERFACE;
}

mozilla::ipc::IPCResult ContentParent::RecvInitBackground(
    Endpoint<PBackgroundParent>&& aEndpoint) {
  if (!BackgroundParent::Alloc(this, std::move(aEndpoint))) {
    return IPC_FAIL(this, "BackgroundParent::Alloc failed");
  }

  return IPC_OK();
}

mozilla::jsipc::PJavaScriptParent* ContentParent::AllocPJavaScriptParent() {
  MOZ_ASSERT(ManagedPJavaScriptParent().IsEmpty());
  return NewJavaScriptParent();
}

bool ContentParent::DeallocPJavaScriptParent(PJavaScriptParent* parent) {
  ReleaseJavaScriptParent(parent);
  return true;
}

bool ContentParent::CanOpenBrowser(const IPCTabContext& aContext) {
  // (PopupIPCTabContext lets the child process prove that it has access to
  // the app it's trying to open.)
  // On e10s we also allow UnsafeTabContext to allow service workers to open
  // windows. This is enforced in MaybeInvalidTabContext.
  if (aContext.type() != IPCTabContext::TPopupIPCTabContext &&
      aContext.type() != IPCTabContext::TUnsafeIPCTabContext) {
    ASSERT_UNLESS_FUZZING(
        "Unexpected IPCTabContext type.  Aborting AllocPBrowserParent.");
    return false;
  }

  if (aContext.type() == IPCTabContext::TPopupIPCTabContext) {
    const PopupIPCTabContext& popupContext = aContext.get_PopupIPCTabContext();
    if (popupContext.opener().type() != PBrowserOrId::TPBrowserParent) {
      ASSERT_UNLESS_FUZZING(
          "Unexpected PopupIPCTabContext type.  Aborting AllocPBrowserParent.");
      return false;
    }

    auto opener =
        BrowserParent::GetFrom(popupContext.opener().get_PBrowserParent());
    if (!opener) {
      ASSERT_UNLESS_FUZZING(
          "Got null opener from child; aborting AllocPBrowserParent.");
      return false;
    }

    // Popup windows of isMozBrowserElement frames must be isMozBrowserElement
    // if the parent isMozBrowserElement.  Allocating a !isMozBrowserElement
    // frame with same app ID would allow the content to access data it's not
    // supposed to.
    if (!popupContext.isMozBrowserElement() && opener->IsMozBrowserElement()) {
      ASSERT_UNLESS_FUZZING(
          "Child trying to escalate privileges!  Aborting "
          "AllocPBrowserParent.");
      return false;
    }
  }

  MaybeInvalidTabContext tc(aContext);
  if (!tc.IsValid()) {
    NS_ERROR(nsPrintfCString("Child passed us an invalid TabContext.  (%s)  "
                             "Aborting AllocPBrowserParent.",
                             tc.GetInvalidReason())
                 .get());
    return false;
  }

  return true;
}

bool ContentParent::DeallocPBrowserParent(PBrowserParent* frame) {
  BrowserParent* parent = BrowserParent::GetFrom(frame);
  NS_RELEASE(parent);
  return true;
}

mozilla::ipc::IPCResult ContentParent::RecvConstructPopupBrowser(
    ManagedEndpoint<PBrowserParent>&& aBrowserEp, const TabId& aTabId,
    const IPCTabContext& aContext, BrowsingContext* aBrowsingContext,
    const uint32_t& aChromeFlags) {
  if (!CanOpenBrowser(aContext)) {
    return IPC_FAIL(this, "CanOpenBrowser Failed");
  }

  uint32_t chromeFlags = aChromeFlags;
  TabId openerTabId(0);
  ContentParentId openerCpId(0);
  if (aContext.type() == IPCTabContext::TPopupIPCTabContext) {
    // CanOpenBrowser has ensured that the IPCTabContext is of
    // type PopupIPCTabContext, and that the opener BrowserParent is
    // reachable.
    const PopupIPCTabContext& popupContext = aContext.get_PopupIPCTabContext();
    auto opener =
        BrowserParent::GetFrom(popupContext.opener().get_PBrowserParent());
    openerTabId = opener->GetTabId();
    openerCpId = opener->Manager()->ChildID();

    // We must ensure that the private browsing and remoteness flags
    // match those of the opener.
    nsCOMPtr<nsILoadContext> loadContext = opener->GetLoadContext();
    if (!loadContext) {
      return IPC_FAIL(this, "Missing Opener LoadContext");
    }

    bool isPrivate;
    loadContext->GetUsePrivateBrowsing(&isPrivate);
    if (isPrivate) {
      chromeFlags |= nsIWebBrowserChrome::CHROME_PRIVATE_WINDOW;
    }
  }

  if (openerTabId > 0 ||
      aContext.type() == IPCTabContext::TUnsafeIPCTabContext) {
    MOZ_ASSERT(XRE_IsParentProcess());
    if (!XRE_IsParentProcess()) {
      return IPC_FAIL(this, "Not in Parent Process");
    }

    // The creation of PBrowser was triggered from content process through
    // either window.open() or service worker's openWindow().
    // We need to register remote frame with the child generated tab id.
    ContentProcessManager* cpm = ContentProcessManager::GetSingleton();
    if (!cpm->RegisterRemoteFrame(aTabId, openerCpId, openerTabId, aContext,
                                  ChildID())) {
      return IPC_FAIL(this, "RegisterRemoteFrame Failed");
    }
  }

  // And because we're allocating a remote browser, of course the
  // window is remote.
  chromeFlags |= nsIWebBrowserChrome::CHROME_REMOTE_WINDOW;

  CanonicalBrowsingContext* browsingContext =
      CanonicalBrowsingContext::Cast(aBrowsingContext);
  if (NS_WARN_IF(!browsingContext->IsOwnedByProcess(ChildID()))) {
    return IPC_FAIL(this, "BrowsingContext Owned by Incorrect Process!");
  }

  MaybeInvalidTabContext tc(aContext);
  MOZ_ASSERT(tc.IsValid());
  RefPtr<BrowserParent> parent = new BrowserParent(
      this, aTabId, tc.GetTabContext(), browsingContext, chromeFlags);

  // Bind the created BrowserParent to IPC to actually link the actor. The ref
  // here is released in DeallocPBrowserParent.
  if (NS_WARN_IF(!BindPBrowserEndpoint(std::move(aBrowserEp),
                                       do_AddRef(parent).take()))) {
    return IPC_FAIL(this, "BindPBrowserEndpoint failed");
  }

  // When enabling input event prioritization, input events may preempt other
  // normal priority IPC messages. To prevent the input events preempt
  // PBrowserConstructor, we use an IPC 'RemoteIsReadyToHandleInputEvents' to
  // notify parent that BrowserChild is created. In this case, PBrowser is
  // initiated from content so that we can set BrowserParent as ready to handle
  // input
  parent->SetReadyToHandleInputEvents();
  return IPC_OK();
}

PIPCBlobInputStreamParent* ContentParent::AllocPIPCBlobInputStreamParent(
    const nsID& aID, const uint64_t& aSize) {
  MOZ_CRASH("PIPCBlobInputStreamParent actors should be manually constructed!");
  return nullptr;
}

bool ContentParent::DeallocPIPCBlobInputStreamParent(
    PIPCBlobInputStreamParent* aActor) {
  RefPtr<IPCBlobInputStreamParent> actor =
      dont_AddRef(static_cast<IPCBlobInputStreamParent*>(aActor));
  return true;
}

mozilla::PRemoteSpellcheckEngineParent*
ContentParent::AllocPRemoteSpellcheckEngineParent() {
  mozilla::RemoteSpellcheckEngineParent* parent =
      new mozilla::RemoteSpellcheckEngineParent();
  return parent;
}

bool ContentParent::DeallocPRemoteSpellcheckEngineParent(
    PRemoteSpellcheckEngineParent* parent) {
  delete parent;
  return true;
}

/* static */
void ContentParent::ForceKillTimerCallback(nsITimer* aTimer, void* aClosure) {
  // We don't want to time out the content process during XPCShell tests. This
  // is the easiest way to ensure that.
  if (PR_GetEnv("XPCSHELL_TEST_PROFILE_DIR")) {
    return;
  }

  auto self = static_cast<ContentParent*>(aClosure);
  self->KillHard("ShutDownKill");
}

void ContentParent::GeneratePairedMinidump(const char* aReason) {
  // We're about to kill the child process associated with this content.
  // Something has gone wrong to get us here, so we generate a minidump
  // of the parent and child for submission to the crash server unless we're
  // already shutting down.
  nsCOMPtr<nsIAppStartup> appStartup = components::AppStartup::Service();
  if (mCrashReporter && !appStartup->GetShuttingDown() &&
      Preferences::GetBool("dom.ipc.tabs.createKillHardCrashReports", false)) {
    // GeneratePairedMinidump creates two minidumps for us - the main
    // one is for the content process we're about to kill, and the other
    // one is for the main browser process. That second one is the extra
    // minidump tagging along, so we have to tell the crash reporter that
    // it exists and is being appended.
    nsAutoCString additionalDumps("browser");
    mCrashReporter->AddAnnotation(
        CrashReporter::Annotation::additional_minidumps, additionalDumps);
    nsDependentCString reason(aReason);
    mCrashReporter->AddAnnotation(CrashReporter::Annotation::ipc_channel_error,
                                  reason);

    // Generate the report and insert into the queue for submittal.
    if (mCrashReporter->GenerateMinidumpAndPair(
            this, nullptr, NS_LITERAL_CSTRING("browser"))) {
      mCreatedPairedMinidumps = mCrashReporter->FinalizeCrashReport();
    }
  }
}

// WARNING: aReason appears in telemetry, so any new value passed in requires
// data review.
void ContentParent::KillHard(const char* aReason) {
  AUTO_PROFILER_LABEL("ContentParent::KillHard", OTHER);

  // On Windows, calling KillHard multiple times causes problems - the
  // process handle becomes invalid on the first call, causing a second call
  // to crash our process - more details in bug 890840.
  if (mCalledKillHard) {
    return;
  }
  mCalledKillHard = true;
  mForceKillTimer = nullptr;

  GeneratePairedMinidump(aReason);

  nsDependentCString reason(aReason);
  Telemetry::Accumulate(Telemetry::SUBPROCESS_KILL_HARD, reason, 1);

  ProcessHandle otherProcessHandle;
  if (!base::OpenProcessHandle(OtherPid(), &otherProcessHandle)) {
    NS_ERROR("Failed to open child process when attempting kill.");
    return;
  }

  if (!KillProcess(otherProcessHandle, base::PROCESS_END_KILLED_BY_USER,
                   false)) {
    NS_WARNING("failed to kill subprocess!");
  }

  if (mSubprocess) {
    mSubprocess->SetAlreadyDead();
  }

  // EnsureProcessTerminated has responsibilty for closing otherProcessHandle.
  XRE_GetIOMessageLoop()->PostTask(
      NewRunnableFunction("EnsureProcessTerminatedRunnable",
                          &ProcessWatcher::EnsureProcessTerminated,
                          otherProcessHandle, /*force=*/true));
}

void ContentParent::FriendlyName(nsAString& aName, bool aAnonymize) {
  aName.Truncate();
  if (mIsForBrowser) {
    aName.AssignLiteral("Browser");
  } else if (aAnonymize) {
    aName.AssignLiteral("<anonymized-name>");
  } else {
    aName.AssignLiteral("???");
  }
}

mozilla::ipc::IPCResult ContentParent::RecvInitCrashReporter(
    Shmem&& aShmem, const NativeThreadId& aThreadId) {
  mCrashReporter = MakeUnique<CrashReporterHost>(GeckoProcessType_Content,
                                                 aShmem, aThreadId);

  return IPC_OK();
}

hal_sandbox::PHalParent* ContentParent::AllocPHalParent() {
  return hal_sandbox::CreateHalParent();
}

bool ContentParent::DeallocPHalParent(hal_sandbox::PHalParent* aHal) {
  delete aHal;
  return true;
}

devtools::PHeapSnapshotTempFileHelperParent*
ContentParent::AllocPHeapSnapshotTempFileHelperParent() {
  return devtools::HeapSnapshotTempFileHelperParent::Create();
}

bool ContentParent::DeallocPHeapSnapshotTempFileHelperParent(
    devtools::PHeapSnapshotTempFileHelperParent* aHeapSnapshotHelper) {
  delete aHeapSnapshotHelper;
  return true;
}

bool ContentParent::SendRequestMemoryReport(
    const uint32_t& aGeneration, const bool& aAnonymize,
    const bool& aMinimizeMemoryUsage, const Maybe<FileDescriptor>& aDMDFile) {
  // This automatically cancels the previous request.
  mMemoryReportRequest = MakeUnique<MemoryReportRequestHost>(aGeneration);
  Unused << PContentParent::SendRequestMemoryReport(
      aGeneration, aAnonymize, aMinimizeMemoryUsage, aDMDFile);
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvAddMemoryReport(
    const MemoryReport& aReport) {
  if (mMemoryReportRequest) {
    mMemoryReportRequest->RecvReport(aReport);
  }
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvFinishMemoryReport(
    const uint32_t& aGeneration) {
  if (mMemoryReportRequest) {
    mMemoryReportRequest->Finish(aGeneration);
    mMemoryReportRequest = nullptr;
  }
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvAddPerformanceMetrics(
    const nsID& aID, nsTArray<PerformanceInfo>&& aMetrics) {
  nsresult rv = PerformanceMetricsCollector::DataReceived(aID, aMetrics);
  Unused << NS_WARN_IF(NS_FAILED(rv));
  return IPC_OK();
}

PCycleCollectWithLogsParent* ContentParent::AllocPCycleCollectWithLogsParent(
    const bool& aDumpAllTraces, const FileDescriptor& aGCLog,
    const FileDescriptor& aCCLog) {
  MOZ_CRASH("Don't call this; use ContentParent::CycleCollectWithLogs");
}

bool ContentParent::DeallocPCycleCollectWithLogsParent(
    PCycleCollectWithLogsParent* aActor) {
  delete aActor;
  return true;
}

bool ContentParent::CycleCollectWithLogs(
    bool aDumpAllTraces, nsICycleCollectorLogSink* aSink,
    nsIDumpGCAndCCLogsCallback* aCallback) {
  return CycleCollectWithLogsParent::AllocAndSendConstructor(
      this, aDumpAllTraces, aSink, aCallback);
}

PTestShellParent* ContentParent::AllocPTestShellParent() {
  return new TestShellParent();
}

bool ContentParent::DeallocPTestShellParent(PTestShellParent* shell) {
  delete shell;
  return true;
}

PScriptCacheParent* ContentParent::AllocPScriptCacheParent(
    const FileDescOrError& cacheFile, const bool& wantCacheData) {
  return new loader::ScriptCacheParent(wantCacheData);
}

bool ContentParent::DeallocPScriptCacheParent(PScriptCacheParent* cache) {
  delete static_cast<loader::ScriptCacheParent*>(cache);
  return true;
}

PNeckoParent* ContentParent::AllocPNeckoParent() { return new NeckoParent(); }

bool ContentParent::DeallocPNeckoParent(PNeckoParent* necko) {
  delete necko;
  return true;
}

PPrintingParent* ContentParent::AllocPPrintingParent() {
#ifdef NS_PRINTING
  if (mPrintingParent) {
    // Only one PrintingParent should be created per process.
    return nullptr;
  }

  // Create the printing singleton for this process.
  mPrintingParent = new PrintingParent();

  // Take another reference for IPDL code.
  mPrintingParent.get()->AddRef();

  return mPrintingParent.get();
#else
  MOZ_ASSERT_UNREACHABLE("Should never be created if no printing.");
  return nullptr;
#endif
}

bool ContentParent::DeallocPPrintingParent(PPrintingParent* printing) {
#ifdef NS_PRINTING
  MOZ_RELEASE_ASSERT(
      mPrintingParent == printing,
      "Only one PrintingParent should have been created per process.");

  // Release reference taken for IPDL code.
  static_cast<PrintingParent*>(printing)->Release();

  mPrintingParent = nullptr;
#else
  MOZ_ASSERT_UNREACHABLE("Should never have been created if no printing.");
#endif
  return true;
}

#ifdef NS_PRINTING
already_AddRefed<embedding::PrintingParent> ContentParent::GetPrintingParent() {
  MOZ_ASSERT(mPrintingParent);

  RefPtr<embedding::PrintingParent> printingParent = mPrintingParent;
  return printingParent.forget();
}
#endif

mozilla::ipc::IPCResult ContentParent::RecvInitStreamFilter(
    const uint64_t& aChannelId, const nsString& aAddonId,
    InitStreamFilterResolver&& aResolver) {
  Endpoint<PStreamFilterChild> endpoint;
  Unused << extensions::StreamFilterParent::Create(this, aChannelId, aAddonId,
                                                   &endpoint);

  aResolver(std::move(endpoint));

  return IPC_OK();
}

PChildToParentStreamParent* ContentParent::AllocPChildToParentStreamParent() {
  return mozilla::ipc::AllocPChildToParentStreamParent();
}

bool ContentParent::DeallocPChildToParentStreamParent(
    PChildToParentStreamParent* aActor) {
  delete aActor;
  return true;
}

PParentToChildStreamParent* ContentParent::AllocPParentToChildStreamParent() {
  MOZ_CRASH(
      "PParentToChildStreamParent actors should be manually constructed!");
}

bool ContentParent::DeallocPParentToChildStreamParent(
    PParentToChildStreamParent* aActor) {
  delete aActor;
  return true;
}

PPSMContentDownloaderParent* ContentParent::AllocPPSMContentDownloaderParent(
    const uint32_t& aCertType) {
  RefPtr<PSMContentDownloaderParent> downloader =
      new PSMContentDownloaderParent(aCertType);
  return downloader.forget().take();
}

bool ContentParent::DeallocPPSMContentDownloaderParent(
    PPSMContentDownloaderParent* aListener) {
  auto* listener = static_cast<PSMContentDownloaderParent*>(aListener);
  RefPtr<PSMContentDownloaderParent> downloader = dont_AddRef(listener);
  return true;
}

PExternalHelperAppParent* ContentParent::AllocPExternalHelperAppParent(
    const Maybe<URIParams>& uri,
    const Maybe<mozilla::net::LoadInfoArgs>& aLoadInfoArgs,
    const nsCString& aMimeContentType, const nsCString& aContentDisposition,
    const uint32_t& aContentDispositionHint,
    const nsString& aContentDispositionFilename, const bool& aForceSave,
    const int64_t& aContentLength, const bool& aWasFileChannel,
    const Maybe<URIParams>& aReferrer, PBrowserParent* aBrowser) {
  ExternalHelperAppParent* parent = new ExternalHelperAppParent(
      uri, aContentLength, aWasFileChannel, aContentDisposition,
      aContentDispositionHint, aContentDispositionFilename);
  parent->AddRef();
  return parent;
}

bool ContentParent::DeallocPExternalHelperAppParent(
    PExternalHelperAppParent* aService) {
  ExternalHelperAppParent* parent =
      static_cast<ExternalHelperAppParent*>(aService);
  parent->Release();
  return true;
}

mozilla::ipc::IPCResult ContentParent::RecvPExternalHelperAppConstructor(
    PExternalHelperAppParent* actor, const Maybe<URIParams>& uri,
    const Maybe<LoadInfoArgs>& loadInfoArgs, const nsCString& aMimeContentType,
    const nsCString& aContentDisposition,
    const uint32_t& aContentDispositionHint,
    const nsString& aContentDispositionFilename, const bool& aForceSave,
    const int64_t& aContentLength, const bool& aWasFileChannel,
    const Maybe<URIParams>& aReferrer, PBrowserParent* aBrowser) {
  static_cast<ExternalHelperAppParent*>(actor)->Init(
      loadInfoArgs, aMimeContentType, aForceSave, aReferrer, aBrowser);
  return IPC_OK();
}

PHandlerServiceParent* ContentParent::AllocPHandlerServiceParent() {
  HandlerServiceParent* actor = new HandlerServiceParent();
  actor->AddRef();
  return actor;
}

bool ContentParent::DeallocPHandlerServiceParent(
    PHandlerServiceParent* aHandlerServiceParent) {
  static_cast<HandlerServiceParent*>(aHandlerServiceParent)->Release();
  return true;
}

media::PMediaParent* ContentParent::AllocPMediaParent() {
  return media::AllocPMediaParent();
}

bool ContentParent::DeallocPMediaParent(media::PMediaParent* aActor) {
  return media::DeallocPMediaParent(aActor);
}

PPresentationParent* ContentParent::AllocPPresentationParent() {
  RefPtr<PresentationParent> actor = new PresentationParent();
  return actor.forget().take();
}

bool ContentParent::DeallocPPresentationParent(PPresentationParent* aActor) {
  RefPtr<PresentationParent> actor =
      dont_AddRef(static_cast<PresentationParent*>(aActor));
  return true;
}

mozilla::ipc::IPCResult ContentParent::RecvPPresentationConstructor(
    PPresentationParent* aActor) {
  if (!static_cast<PresentationParent*>(aActor)->Init(mChildID)) {
    return IPC_FAIL_NO_REASON(this);
  }
  return IPC_OK();
}

PSpeechSynthesisParent* ContentParent::AllocPSpeechSynthesisParent() {
#ifdef MOZ_WEBSPEECH
  return new mozilla::dom::SpeechSynthesisParent();
#else
  return nullptr;
#endif
}

bool ContentParent::DeallocPSpeechSynthesisParent(
    PSpeechSynthesisParent* aActor) {
#ifdef MOZ_WEBSPEECH
  delete aActor;
  return true;
#else
  return false;
#endif
}

mozilla::ipc::IPCResult ContentParent::RecvPSpeechSynthesisConstructor(
    PSpeechSynthesisParent* aActor) {
#ifdef MOZ_WEBSPEECH
  if (!static_cast<SpeechSynthesisParent*>(aActor)->SendInit()) {
    return IPC_FAIL_NO_REASON(this);
  }
  return IPC_OK();
#else
  return IPC_FAIL_NO_REASON(this);
#endif
}

mozilla::ipc::IPCResult ContentParent::RecvStartVisitedQuery(
    const URIParams& aURI) {
  nsCOMPtr<nsIURI> newURI = DeserializeURI(aURI);
  if (!newURI) {
    return IPC_FAIL_NO_REASON(this);
  }
  nsCOMPtr<IHistory> history = services::GetHistoryService();
  if (history) {
    history->RegisterVisitedCallback(newURI, nullptr);
  }
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvSetURITitle(const URIParams& uri,
                                                       const nsString& title) {
  nsCOMPtr<nsIURI> ourURI = DeserializeURI(uri);
  if (!ourURI) {
    return IPC_FAIL_NO_REASON(this);
  }
  nsCOMPtr<IHistory> history = services::GetHistoryService();
  if (history) {
    history->SetURITitle(ourURI, title);
  }
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvIsSecureURI(
    const uint32_t& aType, const URIParams& aURI, const uint32_t& aFlags,
    const OriginAttributes& aOriginAttributes, bool* aIsSecureURI) {
  nsCOMPtr<nsISiteSecurityService> sss(do_GetService(NS_SSSERVICE_CONTRACTID));
  if (!sss) {
    return IPC_FAIL_NO_REASON(this);
  }
  nsCOMPtr<nsIURI> ourURI = DeserializeURI(aURI);
  if (!ourURI) {
    return IPC_FAIL_NO_REASON(this);
  }
  nsresult rv = sss->IsSecureURI(aType, ourURI, aFlags, aOriginAttributes,
                                 nullptr, nullptr, aIsSecureURI);
  if (NS_FAILED(rv)) {
    return IPC_FAIL_NO_REASON(this);
  }
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvAccumulateMixedContentHSTS(
    const URIParams& aURI, const bool& aActive,
    const OriginAttributes& aOriginAttributes) {
  nsCOMPtr<nsIURI> ourURI = DeserializeURI(aURI);
  if (!ourURI) {
    return IPC_FAIL_NO_REASON(this);
  }
  nsMixedContentBlocker::AccumulateMixedContentHSTS(ourURI, aActive,
                                                    aOriginAttributes);
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvLoadURIExternal(
    const URIParams& uri, PBrowserParent* windowContext) {
  nsCOMPtr<nsIExternalProtocolService> extProtService(
      do_GetService(NS_EXTERNALPROTOCOLSERVICE_CONTRACTID));
  if (!extProtService) {
    return IPC_OK();
  }
  nsCOMPtr<nsIURI> ourURI = DeserializeURI(uri);
  if (!ourURI) {
    return IPC_FAIL_NO_REASON(this);
  }

  RefPtr<RemoteWindowContext> context =
      new RemoteWindowContext(static_cast<BrowserParent*>(windowContext));
  extProtService->LoadURI(ourURI, context);
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvExtProtocolChannelConnectParent(
    const uint32_t& registrarId) {
  nsresult rv;

  // First get the real channel created before redirect on the parent.
  nsCOMPtr<nsIChannel> channel;
  rv = NS_LinkRedirectChannels(registrarId, nullptr, getter_AddRefs(channel));
  NS_ENSURE_SUCCESS(rv, IPC_OK());

  nsCOMPtr<nsIParentChannel> parent = do_QueryInterface(channel, &rv);
  NS_ENSURE_SUCCESS(rv, IPC_OK());

  // The channel itself is its own (faked) parent, link it.
  rv = NS_LinkRedirectChannels(registrarId, parent, getter_AddRefs(channel));
  NS_ENSURE_SUCCESS(rv, IPC_OK());

  // Signal the parent channel that it's a redirect-to parent.  This will
  // make AsyncOpen on it do nothing (what we want).
  // Yes, this is a bit of a hack, but I don't think it's necessary to invent
  // a new interface just to set this flag on the channel.
  parent->SetParentListener(nullptr);

  return IPC_OK();
}

bool ContentParent::HasNotificationPermission(
    const IPC::Principal& aPrincipal) {
  return true;
}

mozilla::ipc::IPCResult ContentParent::RecvShowAlert(
    nsIAlertNotification* aAlert) {
  if (!aAlert) {
    return IPC_FAIL_NO_REASON(this);
  }
  nsCOMPtr<nsIPrincipal> principal;
  nsresult rv = aAlert->GetPrincipal(getter_AddRefs(principal));
  if (NS_WARN_IF(NS_FAILED(rv)) ||
      !HasNotificationPermission(IPC::Principal(principal))) {
    return IPC_OK();
  }

  nsCOMPtr<nsIAlertsService> sysAlerts(components::Alerts::Service());
  if (sysAlerts) {
    sysAlerts->ShowAlert(aAlert, this);
  }
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvCloseAlert(
    const nsString& aName, const IPC::Principal& aPrincipal) {
  if (!HasNotificationPermission(aPrincipal)) {
    return IPC_OK();
  }

  nsCOMPtr<nsIAlertsService> sysAlerts(components::Alerts::Service());
  if (sysAlerts) {
    sysAlerts->CloseAlert(aName, aPrincipal);
  }

  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvDisableNotifications(
    const IPC::Principal& aPrincipal) {
  if (HasNotificationPermission(aPrincipal)) {
    Unused << Notification::RemovePermission(aPrincipal);
  }
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvOpenNotificationSettings(
    const IPC::Principal& aPrincipal) {
  if (HasNotificationPermission(aPrincipal)) {
    Unused << Notification::OpenSettings(aPrincipal);
  }
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvNotificationEvent(
    const nsString& aType, const NotificationEventData& aData) {
  nsCOMPtr<nsIServiceWorkerManager> swm =
      mozilla::services::GetServiceWorkerManager();
  if (NS_WARN_IF(!swm)) {
    // Probably shouldn't happen, but no need to crash the child process.
    return IPC_OK();
  }

  if (aType.EqualsLiteral("click")) {
    nsresult rv = swm->SendNotificationClickEvent(
        aData.originSuffix(), aData.scope(), aData.ID(), aData.title(),
        aData.dir(), aData.lang(), aData.body(), aData.tag(), aData.icon(),
        aData.data(), aData.behavior());
    Unused << NS_WARN_IF(NS_FAILED(rv));
  } else {
    MOZ_ASSERT(aType.EqualsLiteral("close"));
    nsresult rv = swm->SendNotificationCloseEvent(
        aData.originSuffix(), aData.scope(), aData.ID(), aData.title(),
        aData.dir(), aData.lang(), aData.body(), aData.tag(), aData.icon(),
        aData.data(), aData.behavior());
    Unused << NS_WARN_IF(NS_FAILED(rv));
  }

  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvSyncMessage(
    const nsString& aMsg, const ClonedMessageData& aData,
    InfallibleTArray<CpowEntry>&& aCpows, const IPC::Principal& aPrincipal,
    nsTArray<StructuredCloneData>* aRetvals) {
  AUTO_PROFILER_LABEL_DYNAMIC_LOSSY_NSSTRING("ContentParent::RecvSyncMessage",
                                             OTHER, aMsg);
  MMPrinter::Print("ContentParent::RecvSyncMessage", aMsg, aData);

  CrossProcessCpowHolder cpows(this, aCpows);
  RefPtr<nsFrameMessageManager> ppm = mMessageManager;
  if (ppm) {
    ipc::StructuredCloneData data;
    ipc::UnpackClonedMessageDataForParent(aData, data);

    ppm->ReceiveMessage(ppm, nullptr, aMsg, true, &data, &cpows, aPrincipal,
                        aRetvals, IgnoreErrors());
  }
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvRpcMessage(
    const nsString& aMsg, const ClonedMessageData& aData,
    InfallibleTArray<CpowEntry>&& aCpows, const IPC::Principal& aPrincipal,
    nsTArray<StructuredCloneData>* aRetvals) {
  AUTO_PROFILER_LABEL_DYNAMIC_LOSSY_NSSTRING("ContentParent::RecvRpcMessage",
                                             OTHER, aMsg);
  MMPrinter::Print("ContentParent::RecvRpcMessage", aMsg, aData);

  CrossProcessCpowHolder cpows(this, aCpows);
  RefPtr<nsFrameMessageManager> ppm = mMessageManager;
  if (ppm) {
    ipc::StructuredCloneData data;
    ipc::UnpackClonedMessageDataForParent(aData, data);

    ppm->ReceiveMessage(ppm, nullptr, aMsg, true, &data, &cpows, aPrincipal,
                        aRetvals, IgnoreErrors());
  }
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvAsyncMessage(
    const nsString& aMsg, InfallibleTArray<CpowEntry>&& aCpows,
    const IPC::Principal& aPrincipal, const ClonedMessageData& aData) {
  AUTO_PROFILER_LABEL_DYNAMIC_LOSSY_NSSTRING("ContentParent::RecvAsyncMessage",
                                             OTHER, aMsg);
  MMPrinter::Print("ContentParent::RecvAsyncMessage", aMsg, aData);

  CrossProcessCpowHolder cpows(this, aCpows);
  RefPtr<nsFrameMessageManager> ppm = mMessageManager;
  if (ppm) {
    ipc::StructuredCloneData data;
    ipc::UnpackClonedMessageDataForParent(aData, data);

    ppm->ReceiveMessage(ppm, nullptr, aMsg, false, &data, &cpows, aPrincipal,
                        nullptr, IgnoreErrors());
  }
  return IPC_OK();
}

MOZ_CAN_RUN_SCRIPT
static int32_t AddGeolocationListener(
    nsIDOMGeoPositionCallback* watcher,
    nsIDOMGeoPositionErrorCallback* errorCallBack, bool highAccuracy) {
  RefPtr<Geolocation> geo = Geolocation::NonWindowSingleton();

  UniquePtr<PositionOptions> options = MakeUnique<PositionOptions>();
  options->mTimeout = 0;
  options->mMaximumAge = 0;
  options->mEnableHighAccuracy = highAccuracy;
  return geo->WatchPosition(watcher, errorCallBack, std::move(options));
}

mozilla::ipc::IPCResult ContentParent::RecvAddGeolocationListener(
    const IPC::Principal& aPrincipal, const bool& aHighAccuracy) {
  // To ensure no geolocation updates are skipped, we always force the
  // creation of a new listener.
  RecvRemoveGeolocationListener();
  mGeolocationWatchID = AddGeolocationListener(this, this, aHighAccuracy);
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvRemoveGeolocationListener() {
  if (mGeolocationWatchID != -1) {
    RefPtr<Geolocation> geo = Geolocation::NonWindowSingleton();
    geo->ClearWatch(mGeolocationWatchID);
    mGeolocationWatchID = -1;
  }
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvSetGeolocationHigherAccuracy(
    const bool& aEnable) {
  // This should never be called without a listener already present,
  // so this check allows us to forgo securing privileges.
  if (mGeolocationWatchID != -1) {
    RecvRemoveGeolocationListener();
    mGeolocationWatchID = AddGeolocationListener(this, this, aEnable);
  }
  return IPC_OK();
}

NS_IMETHODIMP
ContentParent::HandleEvent(nsIDOMGeoPosition* postion) {
  Unused << SendGeolocationUpdate(postion);
  return NS_OK;
}

NS_IMETHODIMP
ContentParent::HandleEvent(PositionError* positionError) {
  Unused << SendGeolocationError(positionError->Code());
  return NS_OK;
}

nsConsoleService* ContentParent::GetConsoleService() {
  if (mConsoleService) {
    return mConsoleService.get();
  }

  // XXXkhuey everything about this is terrible.
  // Get the ConsoleService by CID rather than ContractID, so that we
  // can cast the returned pointer to an nsConsoleService (rather than
  // just an nsIConsoleService). This allows us to call the non-idl function
  // nsConsoleService::LogMessageWithMode.
  NS_DEFINE_CID(consoleServiceCID, NS_CONSOLESERVICE_CID);
  nsCOMPtr<nsIConsoleService> consoleService(do_GetService(consoleServiceCID));
  mConsoleService = static_cast<nsConsoleService*>(consoleService.get());
  return mConsoleService.get();
}

mozilla::ipc::IPCResult ContentParent::RecvConsoleMessage(
    const nsString& aMessage) {
  RefPtr<nsConsoleService> consoleService = GetConsoleService();
  if (!consoleService) {
    return IPC_OK();
  }

  RefPtr<nsConsoleMessage> msg(new nsConsoleMessage(aMessage.get()));
  consoleService->LogMessageWithMode(msg, nsConsoleService::SuppressLog);
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvScriptError(
    const nsString& aMessage, const nsString& aSourceName,
    const nsString& aSourceLine, const uint32_t& aLineNumber,
    const uint32_t& aColNumber, const uint32_t& aFlags,
    const nsCString& aCategory, const bool& aFromPrivateWindow,
    const bool& aFromChromeContext) {
  return RecvScriptErrorInternal(aMessage, aSourceName, aSourceLine,
                                 aLineNumber, aColNumber, aFlags, aCategory,
                                 aFromPrivateWindow, aFromChromeContext);
}

mozilla::ipc::IPCResult ContentParent::RecvScriptErrorWithStack(
    const nsString& aMessage, const nsString& aSourceName,
    const nsString& aSourceLine, const uint32_t& aLineNumber,
    const uint32_t& aColNumber, const uint32_t& aFlags,
    const nsCString& aCategory, const bool& aFromPrivateWindow,
    const bool& aFromChromeContext, const ClonedMessageData& aFrame) {
  return RecvScriptErrorInternal(
      aMessage, aSourceName, aSourceLine, aLineNumber, aColNumber, aFlags,
      aCategory, aFromPrivateWindow, aFromChromeContext, &aFrame);
}

mozilla::ipc::IPCResult ContentParent::RecvScriptErrorInternal(
    const nsString& aMessage, const nsString& aSourceName,
    const nsString& aSourceLine, const uint32_t& aLineNumber,
    const uint32_t& aColNumber, const uint32_t& aFlags,
    const nsCString& aCategory, const bool& aFromPrivateWindow,
    const bool& aFromChromeContext, const ClonedMessageData* aStack) {
  RefPtr<nsConsoleService> consoleService = GetConsoleService();
  if (!consoleService) {
    return IPC_OK();
  }

  nsCOMPtr<nsIScriptError> msg;

  if (aStack) {
    StructuredCloneData data;
    UnpackClonedMessageDataForParent(*aStack, data);

    AutoJSAPI jsapi;
    if (NS_WARN_IF(!jsapi.Init(xpc::PrivilegedJunkScope()))) {
      MOZ_CRASH();
    }
    JSContext* cx = jsapi.cx();

    JS::RootedValue stack(cx);
    ErrorResult rv;
    data.Read(cx, &stack, rv);
    if (rv.Failed() || !stack.isObject()) {
      rv.SuppressException();
      return IPC_OK();
    }

    JS::RootedObject stackObj(cx, &stack.toObject());
    MOZ_ASSERT(JS::IsUnwrappedSavedFrame(stackObj));

    JS::RootedObject stackGlobal(cx, JS::GetNonCCWObjectGlobal(stackObj));
    msg = new nsScriptErrorWithStack(stackObj, stackGlobal);
  } else {
    msg = new nsScriptError();
  }

  nsresult rv = msg->Init(aMessage, aSourceName, aSourceLine, aLineNumber,
                          aColNumber, aFlags, aCategory.get(),
                          aFromPrivateWindow, aFromChromeContext);
  if (NS_FAILED(rv)) return IPC_OK();

  consoleService->LogMessageWithMode(msg, nsConsoleService::SuppressLog);
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvPrivateDocShellsExist(
    const bool& aExist) {
  if (!sPrivateContent) {
    sPrivateContent = new nsTArray<ContentParent*>();
    if (!sHasSeenPrivateDocShell) {
      sHasSeenPrivateDocShell = true;
      Telemetry::ScalarSet(
          Telemetry::ScalarID::DOM_PARENTPROCESS_PRIVATE_WINDOW_USED, true);
    }
  }
  if (aExist) {
    sPrivateContent->AppendElement(this);
  } else {
    sPrivateContent->RemoveElement(this);

    // Only fire the notification if we have private and non-private
    // windows: if privatebrowsing.autostart is true, all windows are
    // private.
    if (!sPrivateContent->Length() &&
        !Preferences::GetBool("browser.privatebrowsing.autostart")) {
      nsCOMPtr<nsIObserverService> obs =
          mozilla::services::GetObserverService();
      obs->NotifyObservers(nullptr, "last-pb-context-exited", nullptr);
      delete sPrivateContent;
      sPrivateContent = nullptr;
    }
  }
  return IPC_OK();
}

bool ContentParent::DoLoadMessageManagerScript(const nsAString& aURL,
                                               bool aRunInGlobalScope) {
  MOZ_ASSERT(!aRunInGlobalScope);
  return SendLoadProcessScript(nsString(aURL));
}

nsresult ContentParent::DoSendAsyncMessage(JSContext* aCx,
                                           const nsAString& aMessage,
                                           StructuredCloneData& aHelper,
                                           JS::Handle<JSObject*> aCpows,
                                           nsIPrincipal* aPrincipal) {
  ClonedMessageData data;
  if (!BuildClonedMessageDataForParent(this, aHelper, data)) {
    return NS_ERROR_DOM_DATA_CLONE_ERR;
  }
  InfallibleTArray<CpowEntry> cpows;
  jsipc::CPOWManager* mgr = GetCPOWManager();
  if (aCpows && (!mgr || !mgr->Wrap(aCx, aCpows, &cpows))) {
    return NS_ERROR_UNEXPECTED;
  }
  if (!SendAsyncMessage(nsString(aMessage), cpows, Principal(aPrincipal),
                        data)) {
    return NS_ERROR_UNEXPECTED;
  }
  return NS_OK;
}

mozilla::ipc::IPCResult ContentParent::RecvKeywordToURI(
    const nsCString& aKeyword, nsString* aProviderName,
    RefPtr<nsIInputStream>* aPostData, Maybe<URIParams>* aURI) {
  *aPostData = nullptr;
  *aURI = Nothing();

  nsCOMPtr<nsIURIFixup> fixup = components::URIFixup::Service();
  if (!fixup) {
    return IPC_OK();
  }

  nsCOMPtr<nsIURIFixupInfo> info;

  if (NS_FAILED(fixup->KeywordToURI(aKeyword, getter_AddRefs(*aPostData),
                                    getter_AddRefs(info)))) {
    return IPC_OK();
  }
  info->GetKeywordProviderName(*aProviderName);

  nsCOMPtr<nsIURI> uri;
  info->GetPreferredURI(getter_AddRefs(uri));
  SerializeURI(uri, *aURI);
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvNotifyKeywordSearchLoading(
    const nsString& aProvider, const nsString& aKeyword) {
  nsCOMPtr<nsISearchService> searchSvc =
      do_GetService("@mozilla.org/browser/search-service;1");
  if (searchSvc) {
    nsCOMPtr<nsISearchEngine> searchEngine;
    searchSvc->GetEngineByName(aProvider, getter_AddRefs(searchEngine));
    if (searchEngine) {
      nsCOMPtr<nsIObserverService> obsSvc =
          mozilla::services::GetObserverService();
      if (obsSvc) {
        // Note that "keyword-search" refers to a search via the url
        // bar, not a bookmarks keyword search.
        obsSvc->NotifyObservers(searchEngine, "keyword-search", aKeyword.get());
      }
    }
  }
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvCopyFavicon(
    const URIParams& aOldURI, const URIParams& aNewURI,
    const IPC::Principal& aLoadingPrincipal, const bool& aInPrivateBrowsing) {
  nsCOMPtr<nsIURI> oldURI = DeserializeURI(aOldURI);
  if (!oldURI) {
    return IPC_OK();
  }
  nsCOMPtr<nsIURI> newURI = DeserializeURI(aNewURI);
  if (!newURI) {
    return IPC_OK();
  }

  nsDocShell::CopyFavicon(oldURI, newURI, aLoadingPrincipal,
                          aInPrivateBrowsing);
  return IPC_OK();
}

bool ContentParent::ShouldContinueFromReplyTimeout() {
  RefPtr<ProcessHangMonitor> monitor = ProcessHangMonitor::Get();
  return !monitor || !monitor->ShouldTimeOutCPOWs();
}

mozilla::ipc::IPCResult ContentParent::RecvRecordingDeviceEvents(
    const nsString& aRecordingStatus, const nsString& aPageURL,
    const bool& aIsAudio, const bool& aIsVideo) {
  nsCOMPtr<nsIObserverService> obs = mozilla::services::GetObserverService();
  if (obs) {
    // recording-device-ipc-events needs to gather more information from content
    // process
    RefPtr<nsHashPropertyBag> props = new nsHashPropertyBag();
    props->SetPropertyAsUint64(NS_LITERAL_STRING("childID"), ChildID());
    props->SetPropertyAsBool(NS_LITERAL_STRING("isAudio"), aIsAudio);
    props->SetPropertyAsBool(NS_LITERAL_STRING("isVideo"), aIsVideo);
    props->SetPropertyAsAString(NS_LITERAL_STRING("requestURL"), aPageURL);

    obs->NotifyObservers((nsIPropertyBag2*)props, "recording-device-ipc-events",
                         aRecordingStatus.get());
  } else {
    NS_WARNING(
        "Could not get the Observer service for "
        "ContentParent::RecvRecordingDeviceEvents.");
  }
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvAddIdleObserver(
    const uint64_t& aObserver, const uint32_t& aIdleTimeInS) {
  nsresult rv;
  nsCOMPtr<nsIIdleService> idleService =
      do_GetService("@mozilla.org/widget/idleservice;1", &rv);
  NS_ENSURE_SUCCESS(rv, IPC_FAIL_NO_REASON(this));

  RefPtr<ParentIdleListener> listener =
      new ParentIdleListener(this, aObserver, aIdleTimeInS);
  rv = idleService->AddIdleObserver(listener, aIdleTimeInS);
  NS_ENSURE_SUCCESS(rv, IPC_FAIL_NO_REASON(this));
  mIdleListeners.AppendElement(listener);
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvRemoveIdleObserver(
    const uint64_t& aObserver, const uint32_t& aIdleTimeInS) {
  RefPtr<ParentIdleListener> listener;
  for (int32_t i = mIdleListeners.Length() - 1; i >= 0; --i) {
    listener = static_cast<ParentIdleListener*>(mIdleListeners[i].get());
    if (listener->mObserver == aObserver && listener->mTime == aIdleTimeInS) {
      nsresult rv;
      nsCOMPtr<nsIIdleService> idleService =
          do_GetService("@mozilla.org/widget/idleservice;1", &rv);
      NS_ENSURE_SUCCESS(rv, IPC_FAIL_NO_REASON(this));
      idleService->RemoveIdleObserver(listener, aIdleTimeInS);
      mIdleListeners.RemoveElementAt(i);
      break;
    }
  }
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvBackUpXResources(
    const FileDescriptor& aXSocketFd) {
#ifndef MOZ_X11
  MOZ_CRASH("This message only makes sense on X11 platforms");
#else
  MOZ_ASSERT(0 > mChildXSocketFdDup.get(), "Already backed up X resources??");
  if (aXSocketFd.IsValid()) {
    auto rawFD = aXSocketFd.ClonePlatformHandle();
    mChildXSocketFdDup.reset(rawFD.release());
  }
#endif
  return IPC_OK();
}

class AnonymousTemporaryFileRequestor final : public Runnable {
 public:
  AnonymousTemporaryFileRequestor(ContentParent* aCP, const uint64_t& aID)
      : Runnable("dom::AnonymousTemporaryFileRequestor"),
        mCP(aCP),
        mID(aID),
        mRv(NS_OK),
        mPRFD(nullptr) {}

  NS_IMETHOD Run() override {
    if (NS_IsMainThread()) {
      FileDescOrError result;
      if (NS_WARN_IF(NS_FAILED(mRv))) {
        // Returning false will kill the child process; instead
        // propagate the error and let the child handle it.
        result = mRv;
      } else {
        result = FileDescriptor(FileDescriptor::PlatformHandleType(
            PR_FileDesc2NativeHandle(mPRFD)));
        // The FileDescriptor object owns a duplicate of the file handle; we
        // must close the original (and clean up the NSPR descriptor).
        PR_Close(mPRFD);
      }
      Unused << mCP->SendProvideAnonymousTemporaryFile(mID, result);
      // It's important to release this reference while wr're on the main
      // thread!
      mCP = nullptr;
    } else {
      mRv = NS_OpenAnonymousTemporaryFile(&mPRFD);
      NS_DispatchToMainThread(this);
    }
    return NS_OK;
  }

 private:
  RefPtr<ContentParent> mCP;
  uint64_t mID;
  nsresult mRv;
  PRFileDesc* mPRFD;
};

mozilla::ipc::IPCResult ContentParent::RecvRequestAnonymousTemporaryFile(
    const uint64_t& aID) {
  // Make sure to send a callback to the child if we bail out early.
  nsresult rv = NS_OK;
  RefPtr<ContentParent> self(this);
  auto autoNotifyChildOnError = MakeScopeExit([&, self]() {
    if (NS_FAILED(rv)) {
      FileDescOrError result(rv);
      Unused << self->SendProvideAnonymousTemporaryFile(aID, result);
    }
  });

  // We use a helper runnable to open the anonymous temporary file on the IO
  // thread.  The same runnable will call us back on the main thread when the
  // file has been opened.
  nsCOMPtr<nsIEventTarget> target =
      do_GetService(NS_STREAMTRANSPORTSERVICE_CONTRACTID, &rv);
  if (!target) {
    return IPC_OK();
  }

  rv = target->Dispatch(new AnonymousTemporaryFileRequestor(this, aID),
                        NS_DISPATCH_NORMAL);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return IPC_OK();
  }

  rv = NS_OK;
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvCreateAudioIPCConnection(
    CreateAudioIPCConnectionResolver&& aResolver) {
  FileDescriptor fd = CubebUtils::CreateAudioIPCConnection();
  if (!fd.IsValid()) {
    return IPC_FAIL(this, "CubebUtils::CreateAudioIPCConnection failed");
  }
  aResolver(std::move(fd));
  return IPC_OK();
}

static NS_DEFINE_CID(kFormProcessorCID, NS_FORMPROCESSOR_CID);

mozilla::ipc::IPCResult ContentParent::RecvKeygenProcessValue(
    const nsString& oldValue, const nsString& challenge,
    const nsString& keytype, const nsString& keyparams, nsString* newValue) {
  nsCOMPtr<nsIFormProcessor> formProcessor = do_GetService(kFormProcessorCID);
  if (!formProcessor) {
    newValue->Truncate();
    return IPC_OK();
  }

  formProcessor->ProcessValueIPC(oldValue, challenge, keytype, keyparams,
                                 *newValue);
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvKeygenProvideContent(
    nsString* aAttribute, nsTArray<nsString>* aContent) {
  nsCOMPtr<nsIFormProcessor> formProcessor = do_GetService(kFormProcessorCID);
  if (!formProcessor) {
    return IPC_OK();
  }

  formProcessor->ProvideContent(NS_LITERAL_STRING("SELECT"), *aContent,
                                *aAttribute);
  return IPC_OK();
}

PFileDescriptorSetParent* ContentParent::AllocPFileDescriptorSetParent(
    const FileDescriptor& aFD) {
  return new FileDescriptorSetParent(aFD);
}

bool ContentParent::DeallocPFileDescriptorSetParent(
    PFileDescriptorSetParent* aActor) {
  delete static_cast<FileDescriptorSetParent*>(aActor);
  return true;
}

bool ContentParent::IgnoreIPCPrincipal() {
  static bool sDidAddVarCache = false;
  static bool sIgnoreIPCPrincipal = false;
  if (!sDidAddVarCache) {
    sDidAddVarCache = true;
    Preferences::AddBoolVarCache(&sIgnoreIPCPrincipal,
                                 "dom.testing.ignore_ipc_principal", false);
  }
  return sIgnoreIPCPrincipal;
}

void ContentParent::NotifyUpdatedDictionaries() {
  RefPtr<mozSpellChecker> spellChecker(mozSpellChecker::Create());
  MOZ_ASSERT(spellChecker, "No spell checker?");

  InfallibleTArray<nsString> dictionaries;
  spellChecker->GetDictionaryList(&dictionaries);

  for (auto* cp : AllProcesses(eLive)) {
    Unused << cp->SendUpdateDictionaryList(dictionaries);
  }
}

void ContentParent::NotifyUpdatedFonts() {
  InfallibleTArray<SystemFontListEntry> fontList;
  gfxPlatform::GetPlatform()->ReadSystemFontList(&fontList);

  for (auto* cp : AllProcesses(eLive)) {
    Unused << cp->SendUpdateFontList(fontList);
  }
}

void ContentParent::NotifyRebuildFontList() {
  for (auto* cp : AllProcesses(eLive)) {
    Unused << cp->SendRebuildFontList();
  }
}

/*static*/
void ContentParent::UnregisterRemoteFrame(const TabId& aTabId,
                                          const ContentParentId& aCpId,
                                          bool aMarkedDestroying) {
  if (XRE_IsParentProcess()) {
    ContentProcessManager* cpm = ContentProcessManager::GetSingleton();
    ContentParent* cp = cpm->GetContentProcessById(aCpId);

    if (!cp) {
      return;
    }

    cp->NotifyTabDestroyed(aTabId, aMarkedDestroying);

    ContentProcessManager::GetSingleton()->UnregisterRemoteFrame(aCpId, aTabId);
  } else {
    ContentChild::GetSingleton()->SendUnregisterRemoteFrame(aTabId, aCpId,
                                                            aMarkedDestroying);
  }
}

mozilla::ipc::IPCResult ContentParent::RecvUnregisterRemoteFrame(
    const TabId& aTabId, const ContentParentId& aCpId,
    const bool& aMarkedDestroying) {
  UnregisterRemoteFrame(aTabId, aCpId, aMarkedDestroying);
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvNotifyTabDestroying(
    const TabId& aTabId, const ContentParentId& aCpId) {
  NotifyTabDestroying(aTabId, aCpId);
  return IPC_OK();
}

nsTArray<TabContext> ContentParent::GetManagedTabContext() {
  return ContentProcessManager::GetSingleton()->GetTabContextByContentProcess(
      this->ChildID());
}

mozilla::docshell::POfflineCacheUpdateParent*
ContentParent::AllocPOfflineCacheUpdateParent(
    const URIParams& aManifestURI, const URIParams& aDocumentURI,
    const PrincipalInfo& aLoadingPrincipalInfo, const bool& aStickDocument) {
  RefPtr<mozilla::docshell::OfflineCacheUpdateParent> update =
      new mozilla::docshell::OfflineCacheUpdateParent();
  // Use this reference as the IPDL reference.
  return update.forget().take();
}

mozilla::ipc::IPCResult ContentParent::RecvPOfflineCacheUpdateConstructor(
    POfflineCacheUpdateParent* aActor, const URIParams& aManifestURI,
    const URIParams& aDocumentURI, const PrincipalInfo& aLoadingPrincipal,
    const bool& aStickDocument) {
  MOZ_ASSERT(aActor);

  RefPtr<mozilla::docshell::OfflineCacheUpdateParent> update =
      static_cast<mozilla::docshell::OfflineCacheUpdateParent*>(aActor);

  nsresult rv = update->Schedule(aManifestURI, aDocumentURI, aLoadingPrincipal,
                                 aStickDocument);
  if (NS_FAILED(rv) && IsAlive()) {
    // Inform the child of failure.
    Unused << update->SendFinish(false, false);
  }

  return IPC_OK();
}

bool ContentParent::DeallocPOfflineCacheUpdateParent(
    POfflineCacheUpdateParent* aActor) {
  // Reclaim the IPDL reference.
  RefPtr<mozilla::docshell::OfflineCacheUpdateParent> update = dont_AddRef(
      static_cast<mozilla::docshell::OfflineCacheUpdateParent*>(aActor));
  return true;
}

PWebrtcGlobalParent* ContentParent::AllocPWebrtcGlobalParent() {
#ifdef MOZ_WEBRTC
  return WebrtcGlobalParent::Alloc();
#else
  return nullptr;
#endif
}

bool ContentParent::DeallocPWebrtcGlobalParent(PWebrtcGlobalParent* aActor) {
#ifdef MOZ_WEBRTC
  WebrtcGlobalParent::Dealloc(static_cast<WebrtcGlobalParent*>(aActor));
  return true;
#else
  return false;
#endif
}

mozilla::ipc::IPCResult ContentParent::RecvSetOfflinePermission(
    const Principal& aPrincipal) {
  nsIPrincipal* principal = aPrincipal;
  nsContentUtils::MaybeAllowOfflineAppByDefault(principal);
  return IPC_OK();
}

void ContentParent::MaybeInvokeDragSession(BrowserParent* aParent) {
  // dnd uses IPCBlob to transfer data to the content process and the IPC
  // message is sent as normal priority. When sending input events with input
  // priority, the message may be preempted by the later dnd events. To make
  // sure the input events and the blob message are processed in time order
  // on the content process, we temporarily send the input events with normal
  // priority when there is an active dnd session.
  SetInputPriorityEventEnabled(false);

  nsCOMPtr<nsIDragService> dragService =
      do_GetService("@mozilla.org/widget/dragservice;1");
  if (dragService && dragService->MaybeAddChildProcess(this)) {
    // We need to send transferable data to child process.
    nsCOMPtr<nsIDragSession> session;
    dragService->GetCurrentSession(getter_AddRefs(session));
    if (session) {
      nsTArray<IPCDataTransfer> dataTransfers;
      RefPtr<DataTransfer> transfer = session->GetDataTransfer();
      if (!transfer) {
        // Pass eDrop to get DataTransfer with external
        // drag formats cached.
        transfer = new DataTransfer(nullptr, eDrop, true, -1);
        session->SetDataTransfer(transfer);
      }
      // Note, even though this fills the DataTransfer object with
      // external data, the data is usually transfered over IPC lazily when
      // needed.
      transfer->FillAllExternalData();
      nsCOMPtr<nsILoadContext> lc =
          aParent ? aParent->GetLoadContext() : nullptr;
      nsCOMPtr<nsIArray> transferables = transfer->GetTransferables(lc);
      nsContentUtils::TransferablesToIPCTransferables(
          transferables, dataTransfers, false, nullptr, this);
      uint32_t action;
      session->GetDragAction(&action);
      mozilla::Unused << SendInvokeDragSession(dataTransfers, action);
    }
  }
}

mozilla::ipc::IPCResult ContentParent::RecvUpdateDropEffect(
    const uint32_t& aDragAction, const uint32_t& aDropEffect) {
  nsCOMPtr<nsIDragSession> dragSession = nsContentUtils::GetDragSession();
  if (dragSession) {
    dragSession->SetDragAction(aDragAction);
    RefPtr<DataTransfer> dt = dragSession->GetDataTransfer();
    if (dt) {
      dt->SetDropEffectInt(aDropEffect);
    }
    dragSession->UpdateDragEffect();
  }
  return IPC_OK();
}

PContentPermissionRequestParent*
ContentParent::AllocPContentPermissionRequestParent(
    const InfallibleTArray<PermissionRequest>& aRequests,
    const IPC::Principal& aPrincipal, const IPC::Principal& aTopLevelPrincipal,
    const bool& aIsHandlingUserInput, const bool& aDocumentHasUserInput,
    const DOMTimeStamp& aPageLoadTimestamp, const TabId& aTabId) {
  ContentProcessManager* cpm = ContentProcessManager::GetSingleton();
  RefPtr<BrowserParent> tp =
      cpm->GetTopLevelBrowserParentByProcessAndTabId(this->ChildID(), aTabId);
  if (!tp) {
    return nullptr;
  }

  return nsContentPermissionUtils::CreateContentPermissionRequestParent(
      aRequests, tp->GetOwnerElement(), aPrincipal, aTopLevelPrincipal,
      aIsHandlingUserInput, aDocumentHasUserInput, aPageLoadTimestamp, aTabId);
}

bool ContentParent::DeallocPContentPermissionRequestParent(
    PContentPermissionRequestParent* actor) {
  nsContentPermissionUtils::NotifyRemoveContentPermissionRequestParent(actor);
  delete actor;
  return true;
}

PWebBrowserPersistDocumentParent*
ContentParent::AllocPWebBrowserPersistDocumentParent(
    PBrowserParent* aBrowser, const uint64_t& aOuterWindowID) {
  return new WebBrowserPersistDocumentParent();
}

bool ContentParent::DeallocPWebBrowserPersistDocumentParent(
    PWebBrowserPersistDocumentParent* aActor) {
  delete aActor;
  return true;
}

mozilla::ipc::IPCResult ContentParent::CommonCreateWindow(
    PBrowserParent* aThisTab, bool aSetOpener, const uint32_t& aChromeFlags,
    const bool& aCalledFromJS, const bool& aPositionSpecified,
    const bool& aSizeSpecified, nsIURI* aURIToLoad, const nsCString& aFeatures,
    const float& aFullZoom, uint64_t aNextRemoteTabId, const nsString& aName,
    nsresult& aResult, nsCOMPtr<nsIRemoteTab>& aNewBrowserParent,
    bool* aWindowIsNew, int32_t& aOpenLocation,
    nsIPrincipal* aTriggeringPrincipal, nsIReferrerInfo* aReferrerInfo,
    bool aLoadURI, nsIContentSecurityPolicy* aCsp)

{
  // The content process should never be in charge of computing whether or
  // not a window should be private or remote - the parent will do that.
  const uint32_t badFlags = nsIWebBrowserChrome::CHROME_PRIVATE_WINDOW |
                            nsIWebBrowserChrome::CHROME_NON_PRIVATE_WINDOW |
                            nsIWebBrowserChrome::CHROME_PRIVATE_LIFETIME |
                            nsIWebBrowserChrome::CHROME_REMOTE_WINDOW;
  if (!!(aChromeFlags & badFlags)) {
    return IPC_FAIL(this, "Forbidden aChromeFlags passed");
  }

  BrowserParent* thisBrowserParent = BrowserParent::GetFrom(aThisTab);
  nsCOMPtr<nsIContent> frame;
  if (thisBrowserParent) {
    frame = thisBrowserParent->GetOwnerElement();

    if (NS_WARN_IF(thisBrowserParent->IsMozBrowser())) {
      return IPC_FAIL(this, "aThisTab is not a MozBrowser");
    }
  }

  nsCOMPtr<nsPIDOMWindowOuter> outerWin;
  if (frame) {
    outerWin = frame->OwnerDoc()->GetWindow();

    // If our chrome window is in the process of closing, don't try to open a
    // new tab in it.
    if (outerWin && outerWin->Closed()) {
      outerWin = nullptr;
    }
  }

  nsCOMPtr<nsIBrowserDOMWindow> browserDOMWin;
  if (thisBrowserParent) {
    browserDOMWin = thisBrowserParent->GetBrowserDOMWindow();
  }

  // If we haven't found a chrome window to open in, just use the most recently
  // opened one.
  if (!outerWin) {
    outerWin = nsContentUtils::GetMostRecentNonPBWindow();
    if (NS_WARN_IF(!outerWin)) {
      aResult = NS_ERROR_FAILURE;
      return IPC_OK();
    }

    nsCOMPtr<nsIDOMChromeWindow> rootChromeWin = do_QueryInterface(outerWin);
    if (rootChromeWin) {
      rootChromeWin->GetBrowserDOMWindow(getter_AddRefs(browserDOMWin));
    }
  }

  aOpenLocation = nsWindowWatcher::GetWindowOpenLocation(
      outerWin, aChromeFlags, aCalledFromJS, aPositionSpecified,
      aSizeSpecified);

  MOZ_ASSERT(aOpenLocation == nsIBrowserDOMWindow::OPEN_NEWTAB ||
             aOpenLocation == nsIBrowserDOMWindow::OPEN_NEWWINDOW);

  // Read the origin attributes for the tab from the opener browserParent.
  OriginAttributes openerOriginAttributes;
  if (thisBrowserParent) {
    nsCOMPtr<nsILoadContext> loadContext = thisBrowserParent->GetLoadContext();
    loadContext->GetOriginAttributes(openerOriginAttributes);
  } else if (Preferences::GetBool("browser.privatebrowsing.autostart")) {
    openerOriginAttributes.mPrivateBrowsingId = 1;
  }

  if (aOpenLocation == nsIBrowserDOMWindow::OPEN_NEWTAB) {
    if (NS_WARN_IF(!browserDOMWin)) {
      aResult = NS_ERROR_ABORT;
      return IPC_OK();
    }

    RefPtr<Element> openerElement = do_QueryObject(frame);

    nsCOMPtr<nsIOpenURIInFrameParams> params =
        new nsOpenURIInFrameParams(openerOriginAttributes, openerElement);
    params->SetReferrerInfo(aReferrerInfo);
    MOZ_ASSERT(aTriggeringPrincipal, "need a valid triggeringPrincipal");
    params->SetTriggeringPrincipal(aTriggeringPrincipal);
    params->SetCsp(aCsp);

    RefPtr<Element> el;

    if (aLoadURI) {
      aResult = browserDOMWin->OpenURIInFrame(
          aURIToLoad, params, aOpenLocation, nsIBrowserDOMWindow::OPEN_NEW,
          aNextRemoteTabId, aName, getter_AddRefs(el));
    } else {
      aResult = browserDOMWin->CreateContentWindowInFrame(
          aURIToLoad, params, aOpenLocation, nsIBrowserDOMWindow::OPEN_NEW,
          aNextRemoteTabId, aName, getter_AddRefs(el));
    }
    RefPtr<nsFrameLoaderOwner> frameLoaderOwner = do_QueryObject(el);
    if (NS_SUCCEEDED(aResult) && frameLoaderOwner) {
      RefPtr<nsFrameLoader> frameLoader = frameLoaderOwner->GetFrameLoader();
      if (frameLoader) {
        aNewBrowserParent = frameLoader->GetRemoteTab();
        // At this point, it's possible the inserted frameloader hasn't gone
        // through layout yet. To ensure that the dimensions that we send down
        // when telling the frameloader to display will be correct (instead of
        // falling back to a 10x10 default), we force layout if necessary to get
        // the most up-to-date dimensions. See bug 1358712 for details.
        frameLoader->ForceLayoutIfNecessary();
      }
    } else if (NS_SUCCEEDED(aResult) && !frameLoaderOwner) {
      // Fall through to the normal window opening code path when there is no
      // window which we can open a new tab in.
      aOpenLocation = nsIBrowserDOMWindow::OPEN_NEWWINDOW;
    } else {
      *aWindowIsNew = false;
    }

    // If we didn't retarget our window open into a new window, we should return
    // now.
    if (aOpenLocation != nsIBrowserDOMWindow::OPEN_NEWWINDOW) {
      return IPC_OK();
    }
  }

  nsCOMPtr<nsPIWindowWatcher> pwwatch =
      do_GetService(NS_WINDOWWATCHER_CONTRACTID, &aResult);
  if (NS_WARN_IF(NS_FAILED(aResult))) {
    return IPC_OK();
  }

  aResult = pwwatch->OpenWindowWithRemoteTab(
      thisBrowserParent, aFeatures, aCalledFromJS, aFullZoom, aNextRemoteTabId,
      !aSetOpener, getter_AddRefs(aNewBrowserParent));
  if (NS_WARN_IF(NS_FAILED(aResult))) {
    return IPC_OK();
  }

  MOZ_ASSERT(aNewBrowserParent);

  // At this point, it's possible the inserted frameloader hasn't gone through
  // layout yet. To ensure that the dimensions that we send down when telling
  // the frameloader to display will be correct (instead of falling back to a
  // 10x10 default), we force layout if necessary to get the most up-to-date
  // dimensions. See bug 1358712 for details.
  //
  // This involves doing a bit of gymnastics in order to get at the FrameLoader,
  // so we scope this to avoid polluting the main function scope.
  {
    nsCOMPtr<Element> frameElement =
        BrowserParent::GetFrom(aNewBrowserParent)->GetOwnerElement();
    MOZ_ASSERT(frameElement);
    RefPtr<nsFrameLoaderOwner> frameLoaderOwner = do_QueryObject(frameElement);
    MOZ_ASSERT(frameLoaderOwner);
    RefPtr<nsFrameLoader> frameLoader = frameLoaderOwner->GetFrameLoader();
    MOZ_ASSERT(frameLoader);
    frameLoader->ForceLayoutIfNecessary();
  }

  // If we were passed a name for the window which would override the default,
  // we should send it down to the new tab.
  if (nsContentUtils::IsOverridingWindowName(aName)) {
    Unused
        << BrowserParent::GetFrom(aNewBrowserParent)->SendSetWindowName(aName);
  }

  // Don't send down the OriginAttributes if the content process is handling
  // setting up the window for us. We only want to send them in the async case.
  //
  // If we send it down in the non-async case, then we might set the
  // OriginAttributes after the document has already navigated.
  if (!aSetOpener) {
    Unused << BrowserParent::GetFrom(aNewBrowserParent)
                  ->SendSetOriginAttributes(openerOriginAttributes);
  }

  if (aURIToLoad && aLoadURI) {
    nsCOMPtr<mozIDOMWindowProxy> openerWindow;
    if (aSetOpener && thisBrowserParent) {
      openerWindow = thisBrowserParent->GetParentWindowOuter();
    }
    nsCOMPtr<nsIBrowserDOMWindow> newBrowserDOMWin =
        BrowserParent::GetFrom(aNewBrowserParent)->GetBrowserDOMWindow();
    if (NS_WARN_IF(!newBrowserDOMWin)) {
      aResult = NS_ERROR_ABORT;
      return IPC_OK();
    }
    nsCOMPtr<mozIDOMWindowProxy> win;
    aResult = newBrowserDOMWin->OpenURI(
        aURIToLoad, openerWindow, nsIBrowserDOMWindow::OPEN_CURRENTWINDOW,
        nsIBrowserDOMWindow::OPEN_NEW, aTriggeringPrincipal, aCsp,
        getter_AddRefs(win));
  }

  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvCreateWindow(
    PBrowserParent* aThisTab, PBrowserParent* aNewTab,
    const uint32_t& aChromeFlags, const bool& aCalledFromJS,
    const bool& aPositionSpecified, const bool& aSizeSpecified,
    const Maybe<URIParams>& aURIToLoad, const nsCString& aFeatures,
    const float& aFullZoom, const IPC::Principal& aTriggeringPrincipal,
    nsIContentSecurityPolicy* aCsp, nsIReferrerInfo* aReferrerInfo,
    CreateWindowResolver&& aResolve) {
  nsresult rv = NS_OK;
  CreatedWindowInfo cwi;

  // We always expect to open a new window here. If we don't, it's an error.
  cwi.windowOpened() = true;
  cwi.maxTouchPoints() = 0;
  cwi.hasSiblings() = false;

  // Make sure to resolve the resolver when this function exits, even if we
  // failed to generate a valid response.
  auto resolveOnExit = MakeScopeExit([&] {
    // Copy over the nsresult, and then resolve.
    cwi.rv() = rv;
    aResolve(cwi);
  });

  BrowserParent* newTab = BrowserParent::GetFrom(aNewTab);
  MOZ_ASSERT(newTab);

  auto destroyNewTabOnError = MakeScopeExit([&] {
    // We always expect to open a new window here. If we don't, it's an error.
    if (!cwi.windowOpened() || NS_FAILED(rv)) {
      if (newTab) {
        newTab->Destroy();
      }
    }
  });

  // Content has requested that we open this new content window, so
  // we must have an opener.
  newTab->SetHasContentOpener(true);

  BrowserParent::AutoUseNewTab aunt(newTab, &cwi.urlToLoad());
  const uint64_t nextRemoteTabId = ++sNextRemoteTabId;
  sNextBrowserParents.Put(nextRemoteTabId, newTab);

  const nsCOMPtr<nsIURI> uriToLoad = DeserializeURI(aURIToLoad);

  nsCOMPtr<nsIRemoteTab> newRemoteTab;
  int32_t openLocation = nsIBrowserDOMWindow::OPEN_NEWWINDOW;
  mozilla::ipc::IPCResult ipcResult = CommonCreateWindow(
      aThisTab, /* aSetOpener = */ true, aChromeFlags, aCalledFromJS,
      aPositionSpecified, aSizeSpecified, uriToLoad, aFeatures, aFullZoom,
      nextRemoteTabId, VoidString(), rv, newRemoteTab, &cwi.windowOpened(),
      openLocation, aTriggeringPrincipal, aReferrerInfo,
      /* aLoadUri = */ false, aCsp);
  if (!ipcResult) {
    return ipcResult;
  }

  if (NS_WARN_IF(NS_FAILED(rv)) || !newRemoteTab) {
    return IPC_OK();
  }

  if (sNextBrowserParents.GetAndRemove(nextRemoteTabId).valueOr(nullptr)) {
    cwi.windowOpened() = false;
  }
  MOZ_ASSERT(BrowserParent::GetFrom(newRemoteTab) == newTab);

  newTab->SwapFrameScriptsFrom(cwi.frameScripts());
  newTab->MaybeShowFrame();

  nsCOMPtr<nsIWidget> widget = newTab->GetWidget();
  if (widget) {
    cwi.maxTouchPoints() = widget->GetMaxTouchPoints();
    cwi.dimensions() = newTab->GetDimensionInfo();
  }

  cwi.hasSiblings() = (openLocation == nsIBrowserDOMWindow::OPEN_NEWTAB);

  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvCreateWindowInDifferentProcess(
    PBrowserParent* aThisTab, const uint32_t& aChromeFlags,
    const bool& aCalledFromJS, const bool& aPositionSpecified,
    const bool& aSizeSpecified, const Maybe<URIParams>& aURIToLoad,
    const nsCString& aFeatures, const float& aFullZoom, const nsString& aName,
    const IPC::Principal& aTriggeringPrincipal, nsIContentSecurityPolicy* aCsp,
    nsIReferrerInfo* aReferrerInfo) {
  MOZ_DIAGNOSTIC_ASSERT(!nsContentUtils::IsSpecialName(aName));

  nsCOMPtr<nsIRemoteTab> newRemoteTab;
  bool windowIsNew;
  nsCOMPtr<nsIURI> uriToLoad = DeserializeURI(aURIToLoad);
  int32_t openLocation = nsIBrowserDOMWindow::OPEN_NEWWINDOW;

  nsresult rv;
  mozilla::ipc::IPCResult ipcResult = CommonCreateWindow(
      aThisTab, /* aSetOpener = */ false, aChromeFlags, aCalledFromJS,
      aPositionSpecified, aSizeSpecified, uriToLoad, aFeatures, aFullZoom,
      /* aNextRemoteTabId = */ 0, aName, rv, newRemoteTab, &windowIsNew,
      openLocation, aTriggeringPrincipal, aReferrerInfo,
      /* aLoadUri = */ true, aCsp);
  if (!ipcResult) {
    return ipcResult;
  }

  if (NS_FAILED(rv)) {
    NS_WARNING("Call to CommonCreateWindow failed.");
  }

  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvShutdownProfile(
    const nsCString& aProfile) {
#ifdef MOZ_GECKO_PROFILER
  nsCOMPtr<nsIProfiler> profiler(
      do_GetService("@mozilla.org/tools/profiler;1"));
  profiler->ReceiveShutdownProfile(aProfile);
#endif
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvGetGraphicsDeviceInitData(
    ContentDeviceData* aOut) {
  gfxPlatform::GetPlatform()->BuildContentDeviceData(aOut);
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvGetFontListShmBlock(
    const uint32_t& aGeneration, const uint32_t& aIndex,
    mozilla::ipc::SharedMemoryBasic::Handle* aOut) {
  gfxPlatformFontList::PlatformFontList()->ShareFontListShmBlockToProcess(
      aGeneration, aIndex, Pid(), aOut);
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvInitializeFamily(
    const uint32_t& aGeneration, const uint32_t& aFamilyIndex) {
  gfxPlatformFontList::PlatformFontList()->InitializeFamily(aGeneration,
                                                            aFamilyIndex);
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvSetCharacterMap(
    const uint32_t& aGeneration, const mozilla::fontlist::Pointer& aFacePtr,
    const gfxSparseBitSet& aMap) {
  gfxPlatformFontList::PlatformFontList()->SetCharacterMap(aGeneration,
                                                           aFacePtr, aMap);
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvInitOtherFamilyNames(
    const uint32_t& aGeneration, const bool& aDefer, bool* aLoaded) {
  gfxPlatformFontList::PlatformFontList()->InitOtherFamilyNames(aGeneration,
                                                                aDefer);
  *aLoaded = true;
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvSetupFamilyCharMap(
    const uint32_t& aGeneration, const mozilla::fontlist::Pointer& aFamilyPtr) {
  gfxPlatformFontList::PlatformFontList()->SetupFamilyCharMap(aGeneration,
                                                              aFamilyPtr);
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvGraphicsError(
    const nsCString& aError) {
  gfx::LogForwarder* lf = gfx::Factory::GetLogForwarder();
  if (lf) {
    std::stringstream message;
    message << "CP+" << aError.get();
    lf->UpdateStringsVector(message.str());
  }
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvBeginDriverCrashGuard(
    const uint32_t& aGuardType, bool* aOutCrashed) {
  // Only one driver crash guard should be active at a time, per-process.
  MOZ_ASSERT(!mDriverCrashGuard);

  UniquePtr<gfx::DriverCrashGuard> guard;
  switch (gfx::CrashGuardType(aGuardType)) {
    case gfx::CrashGuardType::D3D11Layers:
      guard = MakeUnique<gfx::D3D11LayersCrashGuard>(this);
      break;
    case gfx::CrashGuardType::D3D9Video:
      guard = MakeUnique<gfx::D3D9VideoCrashGuard>(this);
      break;
    case gfx::CrashGuardType::GLContext:
      guard = MakeUnique<gfx::GLContextCrashGuard>(this);
      break;
    case gfx::CrashGuardType::D3D11Video:
      guard = MakeUnique<gfx::D3D11VideoCrashGuard>(this);
      break;
    case gfx::CrashGuardType::WMFVPXVideo:
      guard = MakeUnique<gfx::WMFVPXVideoCrashGuard>(this);
      break;
    default:
      MOZ_ASSERT_UNREACHABLE("unknown crash guard type");
      return IPC_FAIL_NO_REASON(this);
  }

  if (guard->Crashed()) {
    *aOutCrashed = true;
    return IPC_OK();
  }

  *aOutCrashed = false;
  mDriverCrashGuard = std::move(guard);
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvEndDriverCrashGuard(
    const uint32_t& aGuardType) {
  mDriverCrashGuard = nullptr;
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvNotifyBenchmarkResult(
    const nsString& aCodecName, const uint32_t& aDecodeFPS)

{
  if (aCodecName.EqualsLiteral("VP9")) {
    Preferences::SetUint(VP9Benchmark::sBenchmarkFpsPref, aDecodeFPS);
    Preferences::SetUint(VP9Benchmark::sBenchmarkFpsVersionCheck,
                         VP9Benchmark::sBenchmarkVersionID);
  }
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvNotifyPushObservers(
    const nsCString& aScope, const IPC::Principal& aPrincipal,
    const nsString& aMessageId) {
  PushMessageDispatcher dispatcher(aScope, aPrincipal, aMessageId, Nothing());
  Unused << NS_WARN_IF(NS_FAILED(dispatcher.NotifyObserversAndWorkers()));
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvNotifyPushObserversWithData(
    const nsCString& aScope, const IPC::Principal& aPrincipal,
    const nsString& aMessageId, InfallibleTArray<uint8_t>&& aData) {
  PushMessageDispatcher dispatcher(aScope, aPrincipal, aMessageId, Some(aData));
  Unused << NS_WARN_IF(NS_FAILED(dispatcher.NotifyObserversAndWorkers()));
  return IPC_OK();
}

mozilla::ipc::IPCResult
ContentParent::RecvNotifyPushSubscriptionChangeObservers(
    const nsCString& aScope, const IPC::Principal& aPrincipal) {
  PushSubscriptionChangeDispatcher dispatcher(aScope, aPrincipal);
  Unused << NS_WARN_IF(NS_FAILED(dispatcher.NotifyObserversAndWorkers()));
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvPushError(
    const nsCString& aScope, const IPC::Principal& aPrincipal,
    const nsString& aMessage, const uint32_t& aFlags) {
  PushErrorDispatcher dispatcher(aScope, aPrincipal, aMessage, aFlags);
  Unused << NS_WARN_IF(NS_FAILED(dispatcher.NotifyObserversAndWorkers()));
  return IPC_OK();
}

mozilla::ipc::IPCResult
ContentParent::RecvNotifyPushSubscriptionModifiedObservers(
    const nsCString& aScope, const IPC::Principal& aPrincipal) {
  PushSubscriptionModifiedDispatcher dispatcher(aScope, aPrincipal);
  Unused << NS_WARN_IF(NS_FAILED(dispatcher.NotifyObservers()));
  return IPC_OK();
}

/* static */
void ContentParent::BroadcastBlobURLRegistration(const nsACString& aURI,
                                                 BlobImpl* aBlobImpl,
                                                 nsIPrincipal* aPrincipal,
                                                 ContentParent* aIgnoreThisCP) {
  nsCString uri(aURI);
  IPC::Principal principal(aPrincipal);

  for (auto* cp : AllProcesses(eLive)) {
    if (cp != aIgnoreThisCP) {
      nsresult rv = cp->TransmitPermissionsForPrincipal(principal);
      if (NS_WARN_IF(NS_FAILED(rv))) {
        break;
      }

      IPCBlob ipcBlob;
      rv = IPCBlobUtils::Serialize(aBlobImpl, cp, ipcBlob);
      if (NS_WARN_IF(NS_FAILED(rv))) {
        break;
      }

      Unused << cp->SendBlobURLRegistration(uri, ipcBlob, principal);
    }
  }
}

/* static */
void ContentParent::BroadcastBlobURLUnregistration(
    const nsACString& aURI, ContentParent* aIgnoreThisCP) {
  nsCString uri(aURI);

  for (auto* cp : AllProcesses(eLive)) {
    if (cp != aIgnoreThisCP) {
      Unused << cp->SendBlobURLUnregistration(uri);
    }
  }
}

mozilla::ipc::IPCResult ContentParent::RecvStoreAndBroadcastBlobURLRegistration(
    const nsCString& aURI, const IPCBlob& aBlob, const Principal& aPrincipal) {
  RefPtr<BlobImpl> blobImpl = IPCBlobUtils::Deserialize(aBlob);
  if (NS_WARN_IF(!blobImpl)) {
    return IPC_FAIL_NO_REASON(this);
  }

  if (NS_SUCCEEDED(
          BlobURLProtocolHandler::AddDataEntry(aURI, aPrincipal, blobImpl))) {
    BroadcastBlobURLRegistration(aURI, blobImpl, aPrincipal, this);

    // We want to store this blobURL, so we can unregister it if the child
    // crashes.
    mBlobURLs.AppendElement(aURI);
  }

  BroadcastBlobURLRegistration(aURI, blobImpl, aPrincipal, this);
  return IPC_OK();
}

mozilla::ipc::IPCResult
ContentParent::RecvUnstoreAndBroadcastBlobURLUnregistration(
    const nsCString& aURI) {
  BlobURLProtocolHandler::RemoveDataEntry(aURI, false /* Don't broadcast */);
  BroadcastBlobURLUnregistration(aURI, this);
  mBlobURLs.RemoveElement(aURI);

  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvGetA11yContentId(
    uint32_t* aContentId) {
#if defined(XP_WIN) && defined(ACCESSIBILITY)
  *aContentId = a11y::AccessibleWrap::GetContentProcessIdFor(ChildID());
  MOZ_ASSERT(*aContentId);
  return IPC_OK();
#else
  return IPC_FAIL_NO_REASON(this);
#endif
}

mozilla::ipc::IPCResult ContentParent::RecvA11yHandlerControl(
    const uint32_t& aPid, const IHandlerControlHolder& aHandlerControl) {
#if defined(XP_WIN) && defined(ACCESSIBILITY)
  MOZ_ASSERT(!aHandlerControl.IsNull());
  RefPtr<IHandlerControl> proxy(aHandlerControl.Get());
  a11y::AccessibleWrap::SetHandlerControl(aPid, std::move(proxy));
  return IPC_OK();
#else
  return IPC_FAIL_NO_REASON(this);
#endif
}

bool ContentParent::HandleWindowsMessages(const Message& aMsg) const {
  MOZ_ASSERT(aMsg.is_sync());

  // a11y messages can be triggered by windows messages, which means if we
  // allow handling windows messages while we wait for the response to a sync
  // a11y message we can reenter the ipc message sending code.
  if (a11y::PDocAccessible::PDocAccessibleStart < aMsg.type() &&
      a11y::PDocAccessible::PDocAccessibleEnd > aMsg.type()) {
    return false;
  }

  return true;
}

mozilla::ipc::IPCResult ContentParent::RecvGetFilesRequest(
    const nsID& aUUID, const nsString& aDirectoryPath,
    const bool& aRecursiveFlag) {
  MOZ_ASSERT(!mGetFilesPendingRequests.GetWeak(aUUID));

  if (!mozilla::Preferences::GetBool("dom.filesystem.pathcheck.disabled",
                                     false)) {
    RefPtr<FileSystemSecurity> fss = FileSystemSecurity::Get();
    if (NS_WARN_IF(!fss || !fss->ContentProcessHasAccessTo(ChildID(),
                                                           aDirectoryPath))) {
      return IPC_FAIL_NO_REASON(this);
    }
  }

  ErrorResult rv;
  RefPtr<GetFilesHelper> helper = GetFilesHelperParent::Create(
      aUUID, aDirectoryPath, aRecursiveFlag, this, rv);

  if (NS_WARN_IF(rv.Failed())) {
    if (!SendGetFilesResponse(aUUID,
                              GetFilesResponseFailure(rv.StealNSResult()))) {
      return IPC_FAIL_NO_REASON(this);
    }
    return IPC_OK();
  }

  mGetFilesPendingRequests.Put(aUUID, helper);
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvDeleteGetFilesRequest(
    const nsID& aUUID) {
  mGetFilesPendingRequests.Remove(aUUID);
  return IPC_OK();
}

void ContentParent::SendGetFilesResponseAndForget(
    const nsID& aUUID, const GetFilesResponseResult& aResult) {
  if (mGetFilesPendingRequests.Remove(aUUID)) {
    Unused << SendGetFilesResponse(aUUID, aResult);
  }
}

void ContentParent::PaintTabWhileInterruptingJS(
    BrowserParent* aBrowserParent, bool aForceRepaint,
    const layers::LayersObserverEpoch& aEpoch) {
  if (!mHangMonitorActor) {
    return;
  }
  ProcessHangMonitor::PaintWhileInterruptingJS(
      mHangMonitorActor, aBrowserParent, aForceRepaint, aEpoch);
}

void ContentParent::CancelContentJSExecutionIfRunning(
    BrowserParent* aBrowserParent, nsIRemoteTab::NavigationType aNavigationType,
    const CancelContentJSOptions& aCancelContentJSOptions) {
  if (!mHangMonitorActor) {
    return;
  }
  ProcessHangMonitor::CancelContentJSExecutionIfRunning(
      mHangMonitorActor, aBrowserParent, aNavigationType,
      aCancelContentJSOptions);
}

void ContentParent::UpdateCookieStatus(nsIChannel* aChannel) {
  PNeckoParent* neckoParent = LoneManagedOrNullAsserts(ManagedPNeckoParent());
  PCookieServiceParent* csParent =
      LoneManagedOrNullAsserts(neckoParent->ManagedPCookieServiceParent());
  if (csParent) {
    auto* cs = static_cast<CookieServiceParent*>(csParent);
    cs->TrackCookieLoad(aChannel);
  }
}

nsresult ContentParent::AboutToLoadHttpFtpDocumentForChild(
    nsIChannel* aChannel) {
  MOZ_ASSERT(aChannel);

  nsresult rv;
  bool isDocument = aChannel->IsDocument();
  if (!isDocument) {
    // We may be looking at a nsIHttpChannel which has isMainDocumentChannel set
    // (e.g. the internal http channel for a view-source: load.).
    nsCOMPtr<nsIHttpChannel> httpChannel = do_QueryInterface(aChannel);
    if (httpChannel) {
      rv = httpChannel->GetIsMainDocumentChannel(&isDocument);
      NS_ENSURE_SUCCESS(rv, rv);
    }
  }
  if (!isDocument) {
    return NS_OK;
  }

  // Get the principal for the channel result, so that we can get the permission
  // key for the document which will be created from this response.
  nsIScriptSecurityManager* ssm = nsContentUtils::GetSecurityManager();
  if (NS_WARN_IF(!ssm)) {
    return NS_ERROR_FAILURE;
  }

  nsCOMPtr<nsIPrincipal> principal;
  rv = ssm->GetChannelResultPrincipal(aChannel, getter_AddRefs(principal));
  NS_ENSURE_SUCCESS(rv, rv);

  rv = TransmitPermissionsForPrincipal(principal);
  NS_ENSURE_SUCCESS(rv, rv);

  nsLoadFlags newLoadFlags;
  aChannel->GetLoadFlags(&newLoadFlags);
  if (newLoadFlags & nsIRequest::LOAD_DOCUMENT_NEEDS_COOKIE) {
    UpdateCookieStatus(aChannel);
  }

  if (!NextGenLocalStorageEnabled()) {
    return NS_OK;
  }

  if (principal->GetIsCodebasePrincipal()) {
    nsCOMPtr<nsILocalStorageManager> lsm =
        do_GetService("@mozilla.org/dom/localStorage-manager;1");
    if (NS_WARN_IF(!lsm)) {
      return NS_ERROR_FAILURE;
    }

    nsCOMPtr<nsISupports> dummy;
    rv = lsm->Preload(principal, nullptr, getter_AddRefs(dummy));
    if (NS_FAILED(rv)) {
      NS_WARNING("Failed to preload local storage!");
    }
  }

  return NS_OK;
}

nsresult ContentParent::TransmitPermissionsForPrincipal(
    nsIPrincipal* aPrincipal) {
  // Create the key, and send it down to the content process.
  nsTArray<nsCString> keys =
      nsPermissionManager::GetAllKeysForPrincipal(aPrincipal);
  MOZ_ASSERT(keys.Length() >= 1);
  for (auto& key : keys) {
    EnsurePermissionsByKey(key);
  }

  return NS_OK;
}

void ContentParent::EnsurePermissionsByKey(const nsCString& aKey) {
  // NOTE: Make sure to initialize the permission manager before updating the
  // mActivePermissionKeys list. If the permission manager is being initialized
  // by this call to GetPermissionManager, and we've added the key to
  // mActivePermissionKeys, then the permission manager will send down a
  // SendAddPermission before receiving the SendSetPermissionsWithKey message.
  nsCOMPtr<nsIPermissionManager> permManager = services::GetPermissionManager();

  if (mActivePermissionKeys.Contains(aKey)) {
    return;
  }
  mActivePermissionKeys.PutEntry(aKey);

  nsTArray<IPC::Permission> perms;
  nsresult rv = permManager->GetPermissionsWithKey(aKey, perms);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return;
  }

  Unused << SendSetPermissionsWithKey(aKey, perms);
}

bool ContentParent::NeedsPermissionsUpdate(
    const nsACString& aPermissionKey) const {
  return mActivePermissionKeys.Contains(aPermissionKey);
}

mozilla::ipc::IPCResult ContentParent::RecvAccumulateChildHistograms(
    InfallibleTArray<HistogramAccumulation>&& aAccumulations) {
  TelemetryIPC::AccumulateChildHistograms(GetTelemetryProcessID(mRemoteType),
                                          aAccumulations);
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvAccumulateChildKeyedHistograms(
    InfallibleTArray<KeyedHistogramAccumulation>&& aAccumulations) {
  TelemetryIPC::AccumulateChildKeyedHistograms(
      GetTelemetryProcessID(mRemoteType), aAccumulations);
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvUpdateChildScalars(
    InfallibleTArray<ScalarAction>&& aScalarActions) {
  TelemetryIPC::UpdateChildScalars(GetTelemetryProcessID(mRemoteType),
                                   aScalarActions);
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvUpdateChildKeyedScalars(
    InfallibleTArray<KeyedScalarAction>&& aScalarActions) {
  TelemetryIPC::UpdateChildKeyedScalars(GetTelemetryProcessID(mRemoteType),
                                        aScalarActions);
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvRecordChildEvents(
    nsTArray<mozilla::Telemetry::ChildEventData>&& aEvents) {
  TelemetryIPC::RecordChildEvents(GetTelemetryProcessID(mRemoteType), aEvents);
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvRecordDiscardedData(
    const mozilla::Telemetry::DiscardedData& aDiscardedData) {
  TelemetryIPC::RecordDiscardedData(GetTelemetryProcessID(mRemoteType),
                                    aDiscardedData);
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvRecordOrigin(
    const uint32_t& aMetricId, const nsCString& aOrigin) {
  Telemetry::RecordOrigin(static_cast<Telemetry::OriginMetricID>(aMetricId),
                          aOrigin);
  return IPC_OK();
}

//////////////////////////////////////////////////////////////////
// PURLClassifierParent

PURLClassifierParent* ContentParent::AllocPURLClassifierParent(
    const Principal& aPrincipal, bool* aSuccess) {
  MOZ_ASSERT(NS_IsMainThread());

  *aSuccess = true;
  RefPtr<URLClassifierParent> actor = new URLClassifierParent();
  return actor.forget().take();
}

mozilla::ipc::IPCResult ContentParent::RecvPURLClassifierConstructor(
    PURLClassifierParent* aActor, const Principal& aPrincipal, bool* aSuccess) {
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(aActor);
  *aSuccess = false;

  auto* actor = static_cast<URLClassifierParent*>(aActor);
  nsCOMPtr<nsIPrincipal> principal(aPrincipal);
  if (!principal) {
    actor->ClassificationFailed();
    return IPC_OK();
  }
  return actor->StartClassify(principal, aSuccess);
}

bool ContentParent::DeallocPURLClassifierParent(PURLClassifierParent* aActor) {
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(aActor);

  RefPtr<URLClassifierParent> actor =
      dont_AddRef(static_cast<URLClassifierParent*>(aActor));
  return true;
}

//////////////////////////////////////////////////////////////////
// PURLClassifierLocalParent

PURLClassifierLocalParent* ContentParent::AllocPURLClassifierLocalParent(
    const URIParams& aURI, const nsTArray<IPCURLClassifierFeature>& aFeatures) {
  MOZ_ASSERT(NS_IsMainThread());

  RefPtr<URLClassifierLocalParent> actor = new URLClassifierLocalParent();
  return actor.forget().take();
}

mozilla::ipc::IPCResult ContentParent::RecvPURLClassifierLocalConstructor(
    PURLClassifierLocalParent* aActor, const URIParams& aURI,
    nsTArray<IPCURLClassifierFeature>&& aFeatures) {
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(aActor);

  nsTArray<IPCURLClassifierFeature> features = std::move(aFeatures);

  nsCOMPtr<nsIURI> uri = DeserializeURI(aURI);
  if (!uri) {
    NS_WARNING("Failed to DeserializeURI");
    return IPC_FAIL_NO_REASON(this);
  }

  auto* actor = static_cast<URLClassifierLocalParent*>(aActor);
  return actor->StartClassify(uri, features);
}

bool ContentParent::DeallocPURLClassifierLocalParent(
    PURLClassifierLocalParent* aActor) {
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(aActor);

  RefPtr<URLClassifierLocalParent> actor =
      dont_AddRef(static_cast<URLClassifierLocalParent*>(aActor));
  return true;
}

PLoginReputationParent* ContentParent::AllocPLoginReputationParent(
    const URIParams& aURI) {
  MOZ_ASSERT(NS_IsMainThread());

  RefPtr<LoginReputationParent> actor = new LoginReputationParent();
  return actor.forget().take();
}

mozilla::ipc::IPCResult ContentParent::RecvPLoginReputationConstructor(
    PLoginReputationParent* aActor, const URIParams& aURI) {
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(aActor);

  nsCOMPtr<nsIURI> uri = DeserializeURI(aURI);
  if (!uri) {
    return IPC_FAIL_NO_REASON(this);
  }

  auto* actor = static_cast<LoginReputationParent*>(aActor);
  return actor->QueryReputation(uri);
}

bool ContentParent::DeallocPLoginReputationParent(
    PLoginReputationParent* aActor) {
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(aActor);

  RefPtr<LoginReputationParent> actor =
      dont_AddRef(static_cast<LoginReputationParent*>(aActor));
  return true;
}

PSessionStorageObserverParent*
ContentParent::AllocPSessionStorageObserverParent() {
  MOZ_ASSERT(NS_IsMainThread());

  return mozilla::dom::AllocPSessionStorageObserverParent();
}

mozilla::ipc::IPCResult ContentParent::RecvPSessionStorageObserverConstructor(
    PSessionStorageObserverParent* aActor) {
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(aActor);

  if (!mozilla::dom::RecvPSessionStorageObserverConstructor(aActor)) {
    return IPC_FAIL_NO_REASON(this);
  }
  return IPC_OK();
}

bool ContentParent::DeallocPSessionStorageObserverParent(
    PSessionStorageObserverParent* aActor) {
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(aActor);

  return mozilla::dom::DeallocPSessionStorageObserverParent(aActor);
}

nsresult ContentParent::SaveRecording(nsIFile* aFile, bool* aRetval) {
  if (mRecordReplayState != eRecording) {
    *aRetval = false;
    return NS_OK;
  }

  PRFileDesc* prfd;
  nsresult rv = aFile->OpenNSPRFileDesc(
      PR_WRONLY | PR_TRUNCATE | PR_CREATE_FILE, 0644, &prfd);
  if (NS_FAILED(rv)) {
    return rv;
  }

  FileDescriptor::PlatformHandleType handle =
      FileDescriptor::PlatformHandleType(PR_FileDesc2NativeHandle(prfd));

  Unused << SendSaveRecording(FileDescriptor(handle));

  PR_Close(prfd);

  *aRetval = true;
  return NS_OK;
}

mozilla::ipc::IPCResult ContentParent::RecvMaybeReloadPlugins() {
  RefPtr<nsPluginHost> pluginHost = nsPluginHost::GetInst();
  pluginHost->ReloadPlugins();
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvDeviceReset() {
  GPUProcessManager* pm = GPUProcessManager::Get();
  if (pm) {
    pm->SimulateDeviceReset();
  }

  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvBHRThreadHang(
    const HangDetails& aDetails) {
  nsCOMPtr<nsIObserverService> obs = mozilla::services::GetObserverService();
  if (obs) {
    // Copy the HangDetails recieved over the network into a nsIHangDetails, and
    // then fire our own observer notification.
    // XXX: We should be able to avoid this potentially expensive copy here by
    // moving our deserialized argument.
    nsCOMPtr<nsIHangDetails> hangDetails =
        new nsHangDetails(HangDetails(aDetails));
    obs->NotifyObservers(hangDetails, "bhr-thread-hang", nullptr);
  }
  return IPC_OK();
}

mozilla::ipc::IPCResult
ContentParent::RecvFirstPartyStorageAccessGrantedForOrigin(
    const Principal& aParentPrincipal, const Principal& aTrackingPrincipal,
    const nsCString& aTrackingOrigin, const nsCString& aGrantedOrigin,
    const int& aAllowMode,
    FirstPartyStorageAccessGrantedForOriginResolver&& aResolver) {
  AntiTrackingCommon::
      SaveFirstPartyStorageAccessGrantedForOriginOnParentProcess(
          aParentPrincipal, aTrackingPrincipal, aTrackingOrigin, aGrantedOrigin,
          aAllowMode)
          ->Then(GetCurrentThreadSerialEventTarget(), __func__,
                 [aResolver = std::move(aResolver)](
                     AntiTrackingCommon::FirstPartyStorageAccessGrantPromise::
                         ResolveOrRejectValue&& aValue) {
                   bool success = aValue.IsResolve() &&
                                  NS_SUCCEEDED(aValue.ResolveValue());
                   aResolver(success);
                 });
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvStoreUserInteractionAsPermission(
    const Principal& aPrincipal) {
  AntiTrackingCommon::StoreUserInteractionFor(aPrincipal);
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvAttachBrowsingContext(
    BrowsingContext::IPCInitializer&& aInit) {
  RefPtr<CanonicalBrowsingContext> parent;
  if (aInit.mParentId != 0) {
    parent = CanonicalBrowsingContext::Get(aInit.mParentId);
    MOZ_RELEASE_ASSERT(parent, "Parent doesn't exist in parent process");
  }

  if (parent && !parent->IsOwnedByProcess(ChildID())) {
    // Where trying attach a child BrowsingContext to a parent
    // BrowsingContext in another process. This is illegal since the
    // only thing that could create that child BrowsingContext is a
    // parent docshell in the same process as that BrowsingContext.
    MOZ_DIAGNOSTIC_ASSERT(false,
                          "Trying to attach to out of process parent context");

    MOZ_LOG(BrowsingContext::GetLog(), LogLevel::Warning,
            ("ParentIPC: Trying to attach to out of process parent context "
             "0x%08" PRIx64,
             aInit.mParentId));
    return IPC_OK();
  }

  RefPtr<BrowsingContext> child = BrowsingContext::Get(aInit.mId);
  if (child && !child->IsCached()) {
    // This is highly suspicious. BrowsingContexts should only be
    // attached at most once, but finding one indicates that someone
    // is doing something they shouldn't.
    MOZ_DIAGNOSTIC_ASSERT(false,
                          "Trying to attach already attached browsing context");

    MOZ_LOG(BrowsingContext::GetLog(), LogLevel::Warning,
            ("ParentIPC: Trying to attach already attached 0x%08" PRIx64
             " to 0x%08" PRIx64,
             aInit.mId, aInit.mParentId));
    return IPC_OK();
  }

  if (!child) {
    RefPtr<BrowsingContextGroup> group =
        BrowsingContextGroup::Select(aInit.mParentId, aInit.mOpenerId);
    child = BrowsingContext::CreateFromIPC(std::move(aInit), group, this);
  }

  child->Attach(/* aFromIPC */ true);

  child->Group()->EachOtherParent(this, [&](ContentParent* aParent) {
    Unused << aParent->SendAttachBrowsingContext(child->GetIPCInitializer());
  });

  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvDetachBrowsingContext(
    BrowsingContext* aContext) {
  if (!aContext) {
    MOZ_LOG(BrowsingContext::GetLog(), LogLevel::Debug,
            ("ParentIPC: Trying to detach already detached"));
    return IPC_OK();
  }

  if (!aContext->Canonical()->IsOwnedByProcess(ChildID())) {
    // Where trying to detach a child BrowsingContext in another child
    // process. This is illegal since the owner of the BrowsingContext
    // is the proccess with the in-process docshell, which is tracked
    // by OwnerProcessId.
    MOZ_DIAGNOSTIC_ASSERT(false, "Trying to detach out of process context");

    MOZ_LOG(BrowsingContext::GetLog(), LogLevel::Warning,
            ("ParentIPC: Trying to detach out of process context 0x%08" PRIx64,
             aContext->Id()));
    return IPC_OK();
  }

  aContext->Detach(/* aFromIPC */ true);

  aContext->Group()->EachOtherParent(this, [&](ContentParent* aParent) {
    Unused << aParent->SendDetachBrowsingContext(aContext);
  });

  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvCacheBrowsingContextChildren(
    BrowsingContext* aContext) {
  if (!aContext) {
    MOZ_LOG(BrowsingContext::GetLog(), LogLevel::Debug,
            ("ParentIPC: Trying to cache already detached"));
    return IPC_OK();
  }

  if (!aContext->Canonical()->IsOwnedByProcess(ChildID())) {
    // Where trying to cache a child BrowsingContext in another child
    // process. This is illegal since the owner of the BrowsingContext
    // is the proccess with the in-process docshell, which is tracked
    // by OwnerProcessId.
    MOZ_DIAGNOSTIC_ASSERT(false, "Trying to cache out of process context");

    MOZ_LOG(BrowsingContext::GetLog(), LogLevel::Warning,
            ("ParentIPC: Trying to cache out of process context 0x%08" PRIx64,
             aContext->Id()));
    return IPC_OK();
  }

  aContext->CacheChildren(/* aFromIPC */ true);

  aContext->Group()->EachOtherParent(this, [&](ContentParent* aParent) {
    Unused << aParent->SendCacheBrowsingContextChildren(aContext);
  });

  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvRestoreBrowsingContextChildren(
    BrowsingContext* aContext, nsTArray<BrowsingContextId>&& aChildren) {
  if (!aContext) {
    MOZ_LOG(BrowsingContext::GetLog(), LogLevel::Debug,
            ("ParentIPC: Trying to restore already detached"));
    return IPC_OK();
  }

  if (!aContext->Canonical()->IsOwnedByProcess(ChildID())) {
    // Where trying to cache a child BrowsingContext in another child
    // process. This is illegal since the owner of the BrowsingContext
    // is the proccess with the in-process docshell, which is tracked
    // by OwnerProcessId.
    MOZ_DIAGNOSTIC_ASSERT(false, "Trying to restore out of process context");

    MOZ_LOG(BrowsingContext::GetLog(), LogLevel::Warning,
            ("ParentIPC: Trying to restore out of process context 0x%08" PRIx64,
             aContext->Id()));
    return IPC_OK();
  }

  BrowsingContext::Children children(aChildren.Length());

  for (auto id : aChildren) {
    RefPtr<BrowsingContext> child = BrowsingContext::Get(id);
    children.AppendElement(child);
  }

  aContext->RestoreChildren(std::move(children), /* aFromIPC */ true);

  aContext->Group()->EachOtherParent(this, [&](ContentParent* aParent) {
    Unused << aParent->SendRestoreBrowsingContextChildren(aContext, aChildren);
  });

  return IPC_OK();
}

void ContentParent::RegisterRemoteWorkerActor() { ++mRemoteWorkerActors; }

void ContentParent::UnregisterRemoveWorkerActor() {
  MOZ_ASSERT(NS_IsMainThread());

  if (--mRemoteWorkerActors) {
    return;
  }

  ContentProcessManager* cpm = ContentProcessManager::GetSingleton();
  if (!cpm->GetBrowserParentCountByProcessId(ChildID()) &&
      !ShouldKeepProcessAlive() && !TryToRecycle()) {
    // In the case of normal shutdown, send a shutdown message to child to
    // allow it to perform shutdown tasks.
    MessageLoop::current()->PostTask(NewRunnableMethod<ShutDownMethod>(
        "dom::ContentParent::ShutDownProcess", this,
        &ContentParent::ShutDownProcess, SEND_SHUTDOWN_MESSAGE));
  }
}

mozilla::ipc::IPCResult ContentParent::RecvWindowClose(
    BrowsingContext* aContext, bool aTrustedCaller) {
  if (!aContext) {
    MOZ_LOG(
        BrowsingContext::GetLog(), LogLevel::Debug,
        ("ParentIPC: Trying to send a message to dead or detached context"));
    return IPC_OK();
  }

  // FIXME Need to check that the sending process has access to the unit of
  // related
  //       browsing contexts of bc.

  ContentProcessManager* cpm = ContentProcessManager::GetSingleton();
  ContentParent* cp = cpm->GetContentProcessById(
      ContentParentId(aContext->Canonical()->OwnerProcessId()));
  Unused << cp->SendWindowClose(aContext, aTrustedCaller);
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvWindowFocus(
    BrowsingContext* aContext) {
  if (!aContext) {
    MOZ_LOG(
        BrowsingContext::GetLog(), LogLevel::Debug,
        ("ParentIPC: Trying to send a message to dead or detached context"));
    return IPC_OK();
  }

  ContentProcessManager* cpm = ContentProcessManager::GetSingleton();
  ContentParent* cp = cpm->GetContentProcessById(
      ContentParentId(aContext->Canonical()->OwnerProcessId()));
  Unused << cp->SendWindowFocus(aContext);
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvWindowBlur(
    BrowsingContext* aContext) {
  if (!aContext) {
    MOZ_LOG(
        BrowsingContext::GetLog(), LogLevel::Debug,
        ("ParentIPC: Trying to send a message to dead or detached context"));
    return IPC_OK();
  }

  ContentProcessManager* cpm = ContentProcessManager::GetSingleton();
  ContentParent* cp = cpm->GetContentProcessById(
      ContentParentId(aContext->Canonical()->OwnerProcessId()));
  Unused << cp->SendWindowBlur(aContext);
  return IPC_OK();
}

mozilla::ipc::IPCResult ContentParent::RecvWindowPostMessage(
    BrowsingContext* aContext, const ClonedMessageData& aMessage,
    const PostMessageData& aData) {
  if (!aContext) {
    MOZ_LOG(
        BrowsingContext::GetLog(), LogLevel::Debug,
        ("ParentIPC: Trying to send a message to dead or detached context"));
    return IPC_OK();
  }

  ContentProcessManager* cpm = ContentProcessManager::GetSingleton();
  ContentParent* cp = cpm->GetContentProcessById(
      ContentParentId(aContext->Canonical()->OwnerProcessId()));
  StructuredCloneData messageFromChild;
  UnpackClonedMessageDataForParent(aMessage, messageFromChild);
  ClonedMessageData message;
  if (!BuildClonedMessageDataForParent(cp, messageFromChild, message)) {
    // FIXME Logging?
    return IPC_OK();
  }
  Unused << cp->SendWindowPostMessage(aContext, message, aData);
  return IPC_OK();
}

void ContentParent::OnBrowsingContextGroupSubscribe(
    BrowsingContextGroup* aGroup) {
  MOZ_DIAGNOSTIC_ASSERT(aGroup);
  mGroups.PutEntry(aGroup);
}

void ContentParent::OnBrowsingContextGroupUnsubscribe(
    BrowsingContextGroup* aGroup) {
  MOZ_DIAGNOSTIC_ASSERT(aGroup);
  mGroups.RemoveEntry(aGroup);
}

mozilla::ipc::IPCResult ContentParent::RecvCommitBrowsingContextTransaction(
    BrowsingContext* aContext, BrowsingContext::Transaction&& aTransaction,
    BrowsingContext::FieldEpochs&& aEpochs) {
  if (!aContext) {
    MOZ_LOG(BrowsingContext::GetLog(), LogLevel::Warning,
            ("ParentIPC: Trying to run transaction on missing context."));
    return IPC_OK();
  }

  // Check if the transaction is valid.
  if (!aContext->Canonical()->ValidateTransaction(aTransaction, this)) {
    MOZ_LOG(BrowsingContext::GetLog(), LogLevel::Error,
            ("ParentIPC: Trying to run invalid transaction."));
    return IPC_FAIL_NO_REASON(this);
  }

  aContext->Group()->EachOtherParent(this, [&](ContentParent* aParent) {
    Unused << aParent->SendCommitBrowsingContextTransaction(
        aContext, aTransaction,
        aContext->Canonical()->GetFieldEpochsForChild(aParent));
  });

  aTransaction.Apply(aContext, this);
  aContext->Canonical()->SetFieldEpochsForChild(this, aEpochs);

  return IPC_OK();
}
}  // namespace dom
}  // namespace mozilla

NS_IMPL_ISUPPORTS(ParentIdleListener, nsIObserver)

NS_IMETHODIMP
ParentIdleListener::Observe(nsISupports*, const char* aTopic,
                            const char16_t* aData) {
  mozilla::Unused << mParent->SendNotifyIdleObserver(
      mObserver, nsDependentCString(aTopic), nsDependentString(aData));
  return NS_OK;
}
