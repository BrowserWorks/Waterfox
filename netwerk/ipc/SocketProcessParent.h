/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_net_SocketProcessParent_h
#define mozilla_net_SocketProcessParent_h

#include "mozilla/UniquePtr.h"
#include "mozilla/ipc/CrashReporterHelper.h"
#include "mozilla/ipc/InputStreamUtils.h"
#include "mozilla/net/PSocketProcessParent.h"

namespace mozilla {

namespace dom {
class MemoryReport;
class MemoryReportRequestHost;
}  // namespace dom

namespace net {

class SocketProcessHost;

// IPC actor of socket process in parent process. This is allocated and managed
// by SocketProcessHost.
class SocketProcessParent final
    : public PSocketProcessParent,
      public ipc::CrashReporterHelper<SocketProcessParent> {
 public:
  static constexpr GeckoProcessType PROCESS_TYPE = GeckoProcessType_Socket;

  friend class SocketProcessHost;

  NS_INLINE_DECL_THREADSAFE_REFCOUNTING(SocketProcessParent, final)

  explicit SocketProcessParent(SocketProcessHost* aHost);

  static already_AddRefed<SocketProcessParent> GetSingleton();

  mozilla::ipc::IPCResult RecvAddMemoryReport(const MemoryReport& aReport);
  mozilla::ipc::IPCResult RecvAccumulateChildHistograms(
      nsTArray<HistogramAccumulation>&& aAccumulations);
  mozilla::ipc::IPCResult RecvAccumulateChildKeyedHistograms(
      nsTArray<KeyedHistogramAccumulation>&& aAccumulations);
  mozilla::ipc::IPCResult RecvUpdateChildScalars(
      nsTArray<ScalarAction>&& aScalarActions);
  mozilla::ipc::IPCResult RecvUpdateChildKeyedScalars(
      nsTArray<KeyedScalarAction>&& aScalarActions);
  mozilla::ipc::IPCResult RecvRecordChildEvents(
      nsTArray<ChildEventData>&& events);
  mozilla::ipc::IPCResult RecvRecordDiscardedData(
      const DiscardedData& aDiscardedData);

  already_AddRefed<PWebrtcTCPSocketParent> AllocPWebrtcTCPSocketParent(
      const Maybe<TabId>& aTabId);
  already_AddRefed<PDNSRequestParent> AllocPDNSRequestParent(
      const nsACString& aHost, const nsACString& aTrrServer,
      const int32_t& port, const uint16_t& aType,
      const OriginAttributes& aOriginAttributes,
      const nsIDNSService::DNSFlags& aFlags);
  virtual mozilla::ipc::IPCResult RecvPDNSRequestConstructor(
      PDNSRequestParent* actor, const nsACString& aHost,
      const nsACString& trrServer, const int32_t& port, const uint16_t& type,
      const OriginAttributes& aOriginAttributes,
      const nsIDNSService::DNSFlags& flags) override;

  void ActorDestroy(ActorDestroyReason aWhy) override;
  bool SendRequestMemoryReport(const uint32_t& aGeneration,
                               const bool& aAnonymize,
                               const bool& aMinimizeMemoryUsage,
                               const Maybe<ipc::FileDescriptor>& aDMDFile);

  mozilla::ipc::IPCResult RecvObserveHttpActivity(
      const HttpActivityArgs& aArgs, const uint32_t& aActivityType,
      const uint32_t& aActivitySubtype, const PRTime& aTimestamp,
      const uint64_t& aExtraSizeData, const nsACString& aExtraStringData);

  mozilla::ipc::IPCResult RecvInitSocketBackground(
      Endpoint<PSocketProcessBackgroundParent>&& aEndpoint);

  already_AddRefed<PAltServiceParent> AllocPAltServiceParent();

  already_AddRefed<PProxyConfigLookupParent> AllocPProxyConfigLookupParent(
      nsIURI* aURI, const uint32_t& aProxyResolveFlags,
      const bool& aIsTRRServiceChannel);
  mozilla::ipc::IPCResult RecvPProxyConfigLookupConstructor(
      PProxyConfigLookupParent* aActor, nsIURI* aURI,
      const uint32_t& aProxyResolveFlags,
      const bool& aIsTRRServiceChannel) override;

  mozilla::ipc::IPCResult RecvExcludeHttp2OrHttp3(
      const HttpConnectionInfoCloneArgs& aArgs);
  mozilla::ipc::IPCResult RecvOnConsoleMessage(const nsString& aMessage);

  mozilla::ipc::IPCResult RecvFOGData(ByteBuf&& aBuf);

  mozilla::ipc::IPCResult RecvGeckoTraceExport(ByteBuf&& aBuf);

  mozilla::ipc::IPCResult RecvSSLTokensCacheData(ByteBuf&& aBuf);

#if defined(XP_MACOSX) || defined(XP_IOS)
  mozilla::ipc::IPCResult RecvAppleFastDatapathProbeResult(
      const bool& aAvailable);
#endif
#if defined(XP_WIN)
  mozilla::ipc::IPCResult RecvGetModulesTrust(
      ModuleIdentifiers&& aModIdents, bool aRunAtNormalPriority,
      GetModulesTrustResolver&& aResolver);
#endif  // defined(XP_WIN)

 private:
  ~SocketProcessParent();

  SocketProcessHost* mHost;
  UniquePtr<dom::MemoryReportRequestHost> mMemoryReportRequest;

  static void Destroy(RefPtr<SocketProcessParent>&& aParent);
};

}  // namespace net
}  // namespace mozilla

#endif  // mozilla_net_SocketProcessParent_h
