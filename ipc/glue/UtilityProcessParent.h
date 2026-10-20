/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
#ifndef _include_ipc_glue_UtilityProcessParent_h_
#define _include_ipc_glue_UtilityProcessParent_h_
#include "mozilla/ipc/PUtilityProcessParent.h"
#include "mozilla/ipc/CrashReporterHelper.h"
#include "mozilla/ipc/UtilityProcessHost.h"
#include "mozilla/dom/MemoryReportRequest.h"

#include "mozilla/RefPtr.h"

namespace mozilla {

namespace ipc {

class UtilityProcessHost;

class UtilityProcessParent final
    : public PUtilityProcessParent,
      public ipc::CrashReporterHelper<UtilityProcessParent> {
  typedef mozilla::dom::MemoryReportRequestHost MemoryReportRequestHost;

 public:
  static constexpr GeckoProcessType PROCESS_TYPE = GeckoProcessType_Utility;

  NS_INLINE_DECL_THREADSAFE_REFCOUNTING(UtilityProcessParent, override);
  friend class UtilityProcessHost;

  explicit UtilityProcessParent(UtilityProcessHost* aHost);

  mozilla::ipc::IPCResult RecvAddMemoryReport(const MemoryReport& aReport);

  bool SendRequestMemoryReport(const uint32_t& aGeneration,
                               const bool& aAnonymize,
                               const bool& aMinimizeMemoryUsage,
                               const Maybe<ipc::FileDescriptor>& aDMDFile);

  mozilla::ipc::IPCResult RecvFOGData(ByteBuf&& aBuf);

  mozilla::ipc::IPCResult RecvGeckoTraceExport(ByteBuf&& aBuf);

#if defined(XP_WIN)
  mozilla::ipc::IPCResult RecvGetModulesTrust(
      ModuleIdentifiers&& aModIdents, bool aRunAtNormalPriority,
      GetModulesTrustResolver&& aResolver);
#endif  // defined(XP_WIN)

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

  mozilla::ipc::IPCResult RecvInitCompleted();

  void ActorDestroy(ActorDestroyReason aWhy) override;

 private:
  UtilityProcessHost* mHost;
  UniquePtr<MemoryReportRequestHost> mMemoryReportRequest{};

  ~UtilityProcessParent();

  static void Destroy(RefPtr<UtilityProcessParent> aParent);
};

}  // namespace ipc

}  // namespace mozilla

#endif  // _include_ipc_glue_UtilityProcessParent_h_
