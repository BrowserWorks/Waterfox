/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_layers_WebRenderBridgeParent_h
#define mozilla_layers_WebRenderBridgeParent_h

#include <unordered_map>
#include <unordered_set>

#include "CompositableHost.h"  // for CompositableHost, ImageCompositeNotificationInfo
#include "GLContextProvider.h"
#include "Layers.h"
#include "mozilla/layers/CompositableTransactionParent.h"
#include "mozilla/layers/CompositorTypes.h"
#include "mozilla/layers/CompositorVsyncSchedulerOwner.h"
#include "mozilla/layers/PWebRenderBridgeParent.h"
#include "mozilla/layers/UiCompositorControllerParent.h"
#include "mozilla/layers/WebRenderCompositionRecorder.h"
#include "mozilla/HashTable.h"
#include "mozilla/Maybe.h"
#include "mozilla/Result.h"
#include "mozilla/UniquePtr.h"
#include "mozilla/WeakPtr.h"
#include "mozilla/webrender/WebRenderTypes.h"
#include "mozilla/webrender/WebRenderAPI.h"
#include "mozilla/webrender/RenderThread.h"
#include "nsTArrayForwardDeclare.h"

namespace mozilla {

namespace gl {
class GLContext;
}

namespace widget {
class CompositorWidget;
}

namespace wr {
class WebRenderAPI;
}

namespace layers {

class Compositor;
class CompositorAnimationStorage;
class CompositorBridgeParentBase;
class CompositorVsyncScheduler;
class AsyncImagePipelineManager;
class WebRenderImageHost;

class PipelineIdAndEpochHashEntry : public PLDHashEntryHdr {
 public:
  typedef const std::pair<wr::PipelineId, wr::Epoch>& KeyType;
  typedef const std::pair<wr::PipelineId, wr::Epoch>* KeyTypePointer;
  enum { ALLOW_MEMMOVE = true };

  explicit PipelineIdAndEpochHashEntry(wr::PipelineId aPipelineId,
                                       wr::Epoch aEpoch)
      : mValue(aPipelineId, aEpoch) {}

  PipelineIdAndEpochHashEntry(PipelineIdAndEpochHashEntry&& aOther) = default;

  explicit PipelineIdAndEpochHashEntry(KeyTypePointer aKey)
      : mValue(aKey->first, aKey->second) {}

  ~PipelineIdAndEpochHashEntry() {}

  KeyType GetKey() const { return mValue; }

  bool KeyEquals(KeyTypePointer aKey) const {
    return mValue.first.mHandle == aKey->first.mHandle &&
           mValue.first.mNamespace == aKey->first.mNamespace &&
           mValue.second.mHandle == aKey->second.mHandle;
  };

  static KeyTypePointer KeyToPointer(KeyType aKey) { return &aKey; }

  static PLDHashNumber HashKey(KeyTypePointer aKey) {
    return mozilla::HashGeneric(aKey->first.mHandle, aKey->first.mNamespace,
                                aKey->second.mHandle);
  }

 private:
  std::pair<wr::PipelineId, wr::Epoch> mValue;
};

class WebRenderBridgeParent final
    : public PWebRenderBridgeParent,
      public CompositorVsyncSchedulerOwner,
      public CompositableParentManager,
      public layers::FrameRecorder,
      public SupportsWeakPtr<WebRenderBridgeParent> {
 public:
  MOZ_DECLARE_WEAKREFERENCE_TYPENAME(WebRenderBridgeParent)
  WebRenderBridgeParent(CompositorBridgeParentBase* aCompositorBridge,
                        const wr::PipelineId& aPipelineId,
                        widget::CompositorWidget* aWidget,
                        CompositorVsyncScheduler* aScheduler,
                        RefPtr<wr::WebRenderAPI>&& aApi,
                        RefPtr<AsyncImagePipelineManager>&& aImageMgr,
                        RefPtr<CompositorAnimationStorage>&& aAnimStorage,
                        TimeDuration aVsyncRate);

  static WebRenderBridgeParent* CreateDestroyed(
      const wr::PipelineId& aPipelineId);

  wr::PipelineId PipelineId() { return mPipelineId; }
  already_AddRefed<wr::WebRenderAPI> GetWebRenderAPI() {
    return do_AddRef(mApi);
  }
  AsyncImagePipelineManager* AsyncImageManager() { return mAsyncImageManager; }
  CompositorVsyncScheduler* CompositorScheduler() {
    return mCompositorScheduler.get();
  }
  CompositorBridgeParentBase* GetCompositorBridge() {
    return mCompositorBridge;
  }

  void UpdateQualitySettings();
  void UpdateDebugFlags();
  void UpdateMultithreading();
  void UpdateBatchingParameters();

  mozilla::ipc::IPCResult RecvEnsureConnected(
      TextureFactoryIdentifier* aTextureFactoryIdentifier,
      MaybeIdNamespace* aMaybeIdNamespace) override;

  mozilla::ipc::IPCResult RecvNewCompositable(
      const CompositableHandle& aHandle, const TextureInfo& aInfo) override;
  mozilla::ipc::IPCResult RecvReleaseCompositable(
      const CompositableHandle& aHandle) override;

  mozilla::ipc::IPCResult RecvShutdown() override;
  mozilla::ipc::IPCResult RecvShutdownSync() override;
  mozilla::ipc::IPCResult RecvDeleteCompositorAnimations(
      nsTArray<uint64_t>&& aIds) override;
  mozilla::ipc::IPCResult RecvUpdateResources(
      nsTArray<OpUpdateResource>&& aUpdates,
      nsTArray<RefCountedShmem>&& aSmallShmems,
      nsTArray<ipc::Shmem>&& aLargeShmems) override;
  mozilla::ipc::IPCResult RecvSetDisplayList(
      DisplayListData&& aDisplayList, nsTArray<OpDestroy>&& aToDestroy,
      const uint64_t& aFwdTransactionId, const TransactionId& aTransactionId,
      const bool& aContainsSVGGroup, const VsyncId& aVsyncId,
      const TimeStamp& aVsyncStartTime, const TimeStamp& aRefreshStartTime,
      const TimeStamp& aTxnStartTime, const nsCString& aTxnURL,
      const TimeStamp& aFwdTime,
      nsTArray<CompositionPayload>&& aPayloads) override;
  mozilla::ipc::IPCResult RecvEmptyTransaction(
      const FocusTarget& aFocusTarget,
      Maybe<TransactionData>&& aTransactionData,
      nsTArray<OpDestroy>&& aToDestroy, const uint64_t& aFwdTransactionId,
      const TransactionId& aTransactionId, const VsyncId& aVsyncId,
      const TimeStamp& aVsyncStartTime, const TimeStamp& aRefreshStartTime,
      const TimeStamp& aTxnStartTime, const nsCString& aTxnURL,
      const TimeStamp& aFwdTime,
      nsTArray<CompositionPayload>&& aPayloads) override;
  mozilla::ipc::IPCResult RecvSetFocusTarget(
      const FocusTarget& aFocusTarget) override;
  mozilla::ipc::IPCResult RecvParentCommands(
      nsTArray<WebRenderParentCommand>&& commands) override;
  mozilla::ipc::IPCResult RecvGetSnapshot(PTextureParent* aTexture) override;

  mozilla::ipc::IPCResult RecvSetLayersObserverEpoch(
      const LayersObserverEpoch& aChildEpoch) override;

  mozilla::ipc::IPCResult RecvClearCachedResources() override;
  mozilla::ipc::IPCResult RecvInvalidateRenderedFrame() override;
  mozilla::ipc::IPCResult RecvScheduleComposite() override;
  mozilla::ipc::IPCResult RecvCapture() override;
  mozilla::ipc::IPCResult RecvToggleCaptureSequence() override;
  mozilla::ipc::IPCResult RecvSyncWithCompositor() override;

  mozilla::ipc::IPCResult RecvSetConfirmedTargetAPZC(
      const uint64_t& aBlockId,
      nsTArray<ScrollableLayerGuid>&& aTargets) override;

  mozilla::ipc::IPCResult RecvSetTestSampleTime(
      const TimeStamp& aTime) override;
  mozilla::ipc::IPCResult RecvLeaveTestMode() override;
  mozilla::ipc::IPCResult RecvGetAnimationValue(
      const uint64_t& aCompositorAnimationsId, OMTAValue* aValue) override;
  mozilla::ipc::IPCResult RecvSetAsyncScrollOffset(
      const ScrollableLayerGuid::ViewID& aScrollId, const float& aX,
      const float& aY) override;
  mozilla::ipc::IPCResult RecvSetAsyncZoom(
      const ScrollableLayerGuid::ViewID& aScrollId,
      const float& aZoom) override;
  mozilla::ipc::IPCResult RecvFlushApzRepaints() override;
  mozilla::ipc::IPCResult RecvGetAPZTestData(APZTestData* data) override;

  void ActorDestroy(ActorDestroyReason aWhy) override;

  void Pause();
  bool Resume();

  void Destroy();

  // CompositorVsyncSchedulerOwner
  bool IsPendingComposite() override { return false; }
  void FinishPendingComposite() override {}
  void CompositeToTarget(VsyncId aId, gfx::DrawTarget* aTarget,
                         const gfx::IntRect* aRect = nullptr) override;
  TimeDuration GetVsyncInterval() const override;

  // CompositableParentManager
  bool IsSameProcess() const override;
  base::ProcessId GetChildProcessId() override;
  void NotifyNotUsed(PTextureParent* aTexture,
                     uint64_t aTransactionId) override;
  void SendAsyncMessage(
      const nsTArray<AsyncParentMessageData>& aMessage) override;
  void SendPendingAsyncMessages() override;
  void SetAboutToSendAsyncMessages() override;

  void HoldPendingTransactionId(
      const wr::Epoch& aWrEpoch, TransactionId aTransactionId,
      bool aContainsSVGGroup, const VsyncId& aVsyncId,
      const TimeStamp& aVsyncStartTime, const TimeStamp& aRefreshStartTime,
      const TimeStamp& aTxnStartTime, const nsCString& aTxnURL,
      const TimeStamp& aFwdTime, const bool aIsFirstPaint,
      nsTArray<CompositionPayload>&& aPayloads,
      const bool aUseForTelemetry = true);
  TransactionId LastPendingTransactionId();
  TransactionId FlushTransactionIdsForEpoch(
      const wr::Epoch& aEpoch, const VsyncId& aCompositeStartId,
      const TimeStamp& aCompositeStartTime, const TimeStamp& aRenderStartTime,
      const TimeStamp& aEndTime, UiCompositorControllerParent* aUiController,
      wr::RendererStats* aStats = nullptr,
      nsTArray<FrameStats>* aOutputStats = nullptr);
  void NotifySceneBuiltForEpoch(const wr::Epoch& aEpoch,
                                const TimeStamp& aEndTime);

  void CompositeIfNeeded();

  TextureFactoryIdentifier GetTextureFactoryIdentifier();

  void ExtractImageCompositeNotifications(
      nsTArray<ImageCompositeNotificationInfo>* aNotifications);

  wr::Epoch GetCurrentEpoch() const { return mWrEpoch; }
  wr::IdNamespace GetIdNamespace() { return mIdNamespace; }

  void FlushRendering(bool aWaitForPresent = true);

  /**
   * Schedule generating WebRender frame definitely at next composite timing.
   *
   * WebRenderBridgeParent uses composite timing to check if there is an update
   * to AsyncImagePipelines. If there is no update, WebRenderBridgeParent skips
   * to generate frame. If we need to generate new frame at next composite
   * timing, call this method.
   *
   * Call CompositorVsyncScheduler::ScheduleComposition() directly, if we just
   * want to trigger AsyncImagePipelines update checks.
   */
  void ScheduleGenerateFrame();

  /**
   * Invalidate rendered frame.
   *
   * WebRender could skip frame rendering if there is no update.
   * This function is used to force invalidating even when there is no update.
   */
  void InvalidateRenderedFrame();

  /**
   * Schedule forced frame rendering at next composite timing.
   *
   * WebRender could skip frame rendering if there is no update.
   * This function is used to force rendering even when there is no update.
   */
  void ScheduleForcedGenerateFrame();

  void NotifyDidSceneBuild(RefPtr<const wr::WebRenderPipelineInfo> aInfo);

  wr::Epoch UpdateWebRender(
      CompositorVsyncScheduler* aScheduler, RefPtr<wr::WebRenderAPI>&& aApi,
      AsyncImagePipelineManager* aImageMgr,
      CompositorAnimationStorage* aAnimStorage,
      const TextureFactoryIdentifier& aTextureFactoryIdentifier);

  void RemoveEpochDataPriorTo(const wr::Epoch& aRenderedEpoch);

  bool IsRootWebRenderBridgeParent() const;
  LayersId GetLayersId() const;

  void SetCompositionRecorder(
      UniquePtr<layers::WebRenderCompositionRecorder> aRecorder);

  /**
   * Write the frames collected by the |WebRenderCompositionRecorder| to disk.
   *
   * If there is not currently a recorder, this is a no-op.
   */
  RefPtr<wr::WebRenderAPI::WriteCollectedFramesPromise> WriteCollectedFrames();

#if defined(MOZ_WIDGET_ANDROID)
  /**
   * Request a screengrab for android
   */
  void RequestScreenPixels(UiCompositorControllerParent* aController);
  void MaybeCaptureScreenPixels();
#endif
  /**
   * Return the frames collected by the |WebRenderCompositionRecorder| encoded
   * as data URIs.
   *
   * If there is not currently a recorder, this is a no-op and the promise will
   * be rejected.
   */
  RefPtr<wr::WebRenderAPI::GetCollectedFramesPromise> GetCollectedFrames();

  void DisableNativeCompositor();
  void AddPendingScrollPayload(
      CompositionPayload& aPayload,
      const std::pair<wr::PipelineId, wr::Epoch>& aKey);

  nsTArray<CompositionPayload> TakePendingScrollPayload(
      const std::pair<wr::PipelineId, wr::Epoch>& aKey);

 private:
  class ScheduleSharedSurfaceRelease;

  explicit WebRenderBridgeParent(const wr::PipelineId& aPipelineId);
  virtual ~WebRenderBridgeParent();

  bool ProcessEmptyTransactionUpdates(TransactionData& aData,
                                      bool* aScheduleComposite);

  bool ProcessDisplayListData(DisplayListData& aDisplayList, wr::Epoch aWrEpoch,
                              const TimeStamp& aTxnStartTime,
                              bool aValidTransaction,
                              bool aObserveLayersUpdate);

  bool SetDisplayList(const LayoutDeviceRect& aRect,
                      const wr::LayoutSize& aContentSize, ipc::ByteBuf&& aDL,
                      const wr::BuiltDisplayListDescriptor& aDLDesc,
                      const nsTArray<OpUpdateResource>& aResourceUpdates,
                      const nsTArray<RefCountedShmem>& aSmallShmems,
                      const nsTArray<ipc::Shmem>& aLargeShmems,
                      const TimeStamp& aTxnStartTime,
                      wr::TransactionBuilder& aTxn, wr::Epoch aWrEpoch,
                      bool aValidTransaction, bool aObserveLayersUpdate);

  void UpdateAPZFocusState(const FocusTarget& aFocus);
  void UpdateAPZScrollData(const wr::Epoch& aEpoch,
                           WebRenderScrollData&& aData);
  void UpdateAPZScrollOffsets(ScrollUpdatesMap&& aUpdates,
                              uint32_t aPaintSequenceNumber);

  bool UpdateResources(const nsTArray<OpUpdateResource>& aResourceUpdates,
                       const nsTArray<RefCountedShmem>& aSmallShmems,
                       const nsTArray<ipc::Shmem>& aLargeShmems,
                       wr::TransactionBuilder& aUpdates);
  bool AddPrivateExternalImage(wr::ExternalImageId aExtId, wr::ImageKey aKey,
                               wr::ImageDescriptor aDesc,
                               wr::TransactionBuilder& aResources);
  bool UpdatePrivateExternalImage(wr::ExternalImageId aExtId, wr::ImageKey aKey,
                                  const wr::ImageDescriptor& aDesc,
                                  const ImageIntRect& aDirtyRect,
                                  wr::TransactionBuilder& aResources);
  bool AddSharedExternalImage(wr::ExternalImageId aExtId, wr::ImageKey aKey,
                              wr::TransactionBuilder& aResources);
  bool UpdateSharedExternalImage(
      wr::ExternalImageId aExtId, wr::ImageKey aKey,
      const ImageIntRect& aDirtyRect, wr::TransactionBuilder& aResources,
      UniquePtr<ScheduleSharedSurfaceRelease>& aScheduleRelease);
  void ObserveSharedSurfaceRelease(
      const nsTArray<wr::ExternalImageKeyPair>& aPairs);

  bool PushExternalImageForTexture(wr::ExternalImageId aExtId,
                                   wr::ImageKey aKey, TextureHost* aTexture,
                                   bool aIsUpdate,
                                   wr::TransactionBuilder& aResources);

  void AddPipelineIdForCompositable(const wr::PipelineId& aPipelineIds,
                                    const CompositableHandle& aHandle,
                                    const bool& aAsync,
                                    wr::TransactionBuilder& aTxn,
                                    wr::TransactionBuilder& aTxnForImageBridge);
  void RemovePipelineIdForCompositable(const wr::PipelineId& aPipelineId,
                                       wr::TransactionBuilder& aTxn);

  void DeleteImage(const wr::ImageKey& aKey, wr::TransactionBuilder& aUpdates);
  void ReleaseTextureOfImage(const wr::ImageKey& aKey);

  bool ProcessWebRenderParentCommands(
      const nsTArray<WebRenderParentCommand>& aCommands,
      wr::TransactionBuilder& aTxn);

  void ClearResources();
  bool ShouldParentObserveEpoch();
  mozilla::ipc::IPCResult HandleShutdown();

  // Returns true if there is any animation (including animations in delay
  // phase).
  bool AdvanceAnimations();

  struct WrAnimations {
    nsTArray<wr::WrOpacityProperty> mOpacityArrays;
    nsTArray<wr::WrTransformProperty> mTransformArrays;
    nsTArray<wr::WrColorProperty> mColorArrays;
  };
  bool SampleAnimations(WrAnimations& aAnimations);

  CompositorBridgeParent* GetRootCompositorBridgeParent() const;

  RefPtr<WebRenderBridgeParent> GetRootWebRenderBridgeParent() const;

  // Tell APZ what the subsequent sampling's timestamp should be.
  void SetAPZSampleTime();

  wr::Epoch GetNextWrEpoch();
  // This function is expected to be used when GetNextWrEpoch() is called,
  // but TransactionBuilder does not have resource updates nor display list.
  // In this case, ScheduleGenerateFrame is not triggered via SceneBuilder.
  // Then we want to rollback WrEpoch. See Bug 1490117.
  void RollbackWrEpoch();

  void FlushSceneBuilds();
  void FlushFrameGeneration();
  void FlushFramePresentation();

  void MaybeGenerateFrame(VsyncId aId, bool aForceGenerateFrame);

  VsyncId GetVsyncIdForEpoch(const wr::Epoch& aEpoch) {
    for (auto& id : mPendingTransactionIds) {
      if (id.mEpoch.mHandle == aEpoch.mHandle) {
        return id.mVsyncId;
      }
    }
    return VsyncId();
  }

 private:
  struct PendingTransactionId {
    PendingTransactionId(const wr::Epoch& aEpoch, TransactionId aId,
                         bool aContainsSVGGroup, const VsyncId& aVsyncId,
                         const TimeStamp& aVsyncStartTime,
                         const TimeStamp& aRefreshStartTime,
                         const TimeStamp& aTxnStartTime,
                         const nsCString& aTxnURL, const TimeStamp& aFwdTime,
                         const bool aIsFirstPaint, const bool aUseForTelemetry,
                         nsTArray<CompositionPayload>&& aPayloads)
        : mEpoch(aEpoch),
          mId(aId),
          mVsyncId(aVsyncId),
          mVsyncStartTime(aVsyncStartTime),
          mRefreshStartTime(aRefreshStartTime),
          mTxnStartTime(aTxnStartTime),
          mTxnURL(aTxnURL),
          mFwdTime(aFwdTime),
          mSkippedComposites(0),
          mContainsSVGGroup(aContainsSVGGroup),
          mIsFirstPaint(aIsFirstPaint),
          mUseForTelemetry(aUseForTelemetry),
          mPayloads(std::move(aPayloads)) {}
    wr::Epoch mEpoch;
    TransactionId mId;
    VsyncId mVsyncId;
    TimeStamp mVsyncStartTime;
    TimeStamp mRefreshStartTime;
    TimeStamp mTxnStartTime;
    nsCString mTxnURL;
    TimeStamp mFwdTime;
    TimeStamp mSceneBuiltTime;
    uint32_t mSkippedComposites;
    bool mContainsSVGGroup;
    bool mIsFirstPaint;
    bool mUseForTelemetry;
    nsTArray<CompositionPayload> mPayloads;
  };

  struct CompositorAnimationIdsForEpoch {
    CompositorAnimationIdsForEpoch(const wr::Epoch& aEpoch,
                                   nsTArray<uint64_t>&& aIds)
        : mEpoch(aEpoch), mIds(std::move(aIds)) {}

    wr::Epoch mEpoch;
    nsTArray<uint64_t> mIds;
  };

  CompositorBridgeParentBase* MOZ_NON_OWNING_REF mCompositorBridge;
  wr::PipelineId mPipelineId;
  RefPtr<widget::CompositorWidget> mWidget;
  RefPtr<wr::WebRenderAPI> mApi;
  RefPtr<AsyncImagePipelineManager> mAsyncImageManager;
  RefPtr<CompositorVsyncScheduler> mCompositorScheduler;
  RefPtr<CompositorAnimationStorage> mAnimStorage;
  // mActiveAnimations is used to avoid leaking animations when
  // WebRenderBridgeParent is destroyed abnormally and Tab move between
  // different windows.
  std::unordered_map<uint64_t, wr::Epoch> mActiveAnimations;
  std::unordered_map<uint64_t, RefPtr<WebRenderImageHost>> mAsyncCompositables;
  std::unordered_map<uint64_t, CompositableTextureHostRef> mTextureHosts;
  std::unordered_map<uint64_t, wr::ExternalImageId> mSharedSurfaceIds;

  TimeDuration mVsyncRate;
  TimeStamp mPreviousFrameTimeStamp;
  // These fields keep track of the latest layer observer epoch values in the
  // child and the parent. mChildLayersObserverEpoch is the latest epoch value
  // received from the child. mParentLayersObserverEpoch is the latest epoch
  // value that we have told BrowserParent about (via ObserveLayerUpdate).
  LayersObserverEpoch mChildLayersObserverEpoch;
  LayersObserverEpoch mParentLayersObserverEpoch;

  std::deque<PendingTransactionId> mPendingTransactionIds;
  std::queue<CompositorAnimationIdsForEpoch> mCompositorAnimationsToDelete;
  wr::Epoch mWrEpoch;
  wr::IdNamespace mIdNamespace;

  VsyncId mSkippedCompositeId;
  TimeStamp mMostRecentComposite;

#if defined(MOZ_WIDGET_ANDROID)
  UiCompositorControllerParent* mScreenPixelsTarget;
#endif
  bool mPaused;
  bool mDestroyed;
  bool mReceivedDisplayList;
  bool mIsFirstPaint;
  bool mSkippedComposite;
  bool mDisablingNativeCompositor;
  // These payloads are being used for SCROLL_PRESENT_LATENCY telemetry
  DataMutex<nsClassHashtable<PipelineIdAndEpochHashEntry,
                             nsTArray<CompositionPayload>>>
      mPendingScrollPayloads;
};

}  // namespace layers
}  // namespace mozilla

#endif  // mozilla_layers_WebRenderBridgeParent_h
