/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set sw=4 ts=8 et tw=80 : */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_layers_CompositorBridgeParent_h
#define mozilla_layers_CompositorBridgeParent_h

// Enable this pref to turn on compositor performance warning.
// This will print warnings if the compositor isn't meeting
// its responsiveness objectives:
//    1) Compose a frame within 15ms of receiving a ScheduleCompositeCall
//    2) Unless a frame was composited within the throttle threshold in
//       which the deadline will be 15ms + throttle threshold
//#define COMPOSITOR_PERFORMANCE_WARNING

#include <stdint.h>                     // for uint64_t
#include "Layers.h"                     // for Layer
#include "mozilla/Assertions.h"         // for MOZ_ASSERT_HELPER2
#include "mozilla/Attributes.h"         // for override
#include "mozilla/Maybe.h"
#include "mozilla/Monitor.h"            // for Monitor
#include "mozilla/RefPtr.h"             // for RefPtr
#include "mozilla/TimeStamp.h"          // for TimeStamp
#include "mozilla/dom/ipc/IdType.h"
#include "mozilla/gfx/Point.h"          // for IntSize
#include "mozilla/ipc/ProtocolUtils.h"
#include "mozilla/ipc/SharedMemory.h"
#include "mozilla/layers/CompositorController.h"
#include "mozilla/layers/GeckoContentController.h"
#include "mozilla/layers/ISurfaceAllocator.h" // for ShmemAllocator
#include "mozilla/layers/LayersMessages.h"  // for TargetConfig
#include "mozilla/layers/MetricsSharingController.h"
#include "mozilla/layers/PCompositorBridgeParent.h"
#include "mozilla/layers/APZTestData.h"
#include "mozilla/widget/CompositorWidget.h"
#include "nsISupportsImpl.h"
#include "ThreadSafeRefcountingWithMainThreadDestruction.h"
#include "mozilla/VsyncDispatcher.h"

class MessageLoop;
class nsIWidget;

namespace mozilla {

class CancelableRunnable;

namespace gfx {
class DrawTarget;
class GPUProcessManager;
class GPUParent;
} // namespace gfx

namespace ipc {
class Shmem;
} // namespace ipc

namespace layers {

class APZCTreeManager;
class APZCTreeManagerParent;
class AsyncCompositionManager;
class Compositor;
class CompositorBridgeParent;
class LayerManagerComposite;
class LayerTransactionParent;
class PAPZParent;
class CrossProcessCompositorBridgeParent;
class CompositorThreadHolder;
class InProcessCompositorSession;

struct ScopedLayerTreeRegistration
{
  ScopedLayerTreeRegistration(APZCTreeManager* aApzctm,
                              uint64_t aLayersId,
                              Layer* aRoot,
                              GeckoContentController* aController);
  ~ScopedLayerTreeRegistration();

private:
  uint64_t mLayersId;
};

/**
 * Manages the vsync (de)registration and tracking on behalf of the
 * compositor when it need to paint.
 * Turns vsync notifications into scheduled composites.
 **/
class CompositorVsyncScheduler
{
  NS_INLINE_DECL_THREADSAFE_REFCOUNTING(CompositorVsyncScheduler)

public:
  explicit CompositorVsyncScheduler(CompositorBridgeParent* aCompositorBridgeParent,
                                    widget::CompositorWidget* aWidget);

  bool NotifyVsync(TimeStamp aVsyncTimestamp);
  void SetNeedsComposite();
  void OnForceComposeToTarget();

  void ScheduleTask(already_AddRefed<CancelableRunnable>, int);
  void ResumeComposition();
  void ComposeToTarget(gfx::DrawTarget* aTarget, const gfx::IntRect* aRect = nullptr);
  void PostCompositeTask(TimeStamp aCompositeTimestamp);
  void Destroy();
  void ScheduleComposition();
  void CancelCurrentCompositeTask();
  bool NeedsComposite();
  void Composite(TimeStamp aVsyncTimestamp);
  void ForceComposeToTarget(gfx::DrawTarget* aTarget, const gfx::IntRect* aRect);

  const TimeStamp& GetLastComposeTime()
  {
    return mLastCompose;
  }

#ifdef COMPOSITOR_PERFORMANCE_WARNING
  const TimeStamp& GetExpectedComposeStartTime()
  {
    return mExpectedComposeStartTime;
  }
#endif

private:
  virtual ~CompositorVsyncScheduler();

  void NotifyCompositeTaskExecuted();
  void ObserveVsync();
  void UnobserveVsync();
  void DispatchTouchEvents(TimeStamp aVsyncTimestamp);
  void DispatchVREvents(TimeStamp aVsyncTimestamp);
  void CancelCurrentSetNeedsCompositeTask();

  class Observer final : public VsyncObserver
  {
  public:
    explicit Observer(CompositorVsyncScheduler* aOwner);
    virtual bool NotifyVsync(TimeStamp aVsyncTimestamp) override;
    void Destroy();
  private:
    virtual ~Observer();

    Mutex mMutex;
    // Hold raw pointer to avoid mutual reference.
    CompositorVsyncScheduler* mOwner;
  };

  CompositorBridgeParent* mCompositorBridgeParent;
  TimeStamp mLastCompose;

#ifdef COMPOSITOR_PERFORMANCE_WARNING
  TimeStamp mExpectedComposeStartTime;
#endif

  bool mAsapScheduling;
  bool mIsObservingVsync;
  uint32_t mNeedsComposite;
  int32_t mVsyncNotificationsSkipped;
  widget::CompositorWidget* mWidget;
  RefPtr<CompositorVsyncScheduler::Observer> mVsyncObserver;

  mozilla::Monitor mCurrentCompositeTaskMonitor;
  RefPtr<CancelableRunnable> mCurrentCompositeTask;

  mozilla::Monitor mSetNeedsCompositeMonitor;
  RefPtr<CancelableRunnable> mSetNeedsCompositeTask;
};

class CompositorBridgeParentBase : public PCompositorBridgeParent,
                                   public HostIPCAllocator,
                                   public ShmemAllocator,
                                   public MetricsSharingController
{
public:
  virtual void ShadowLayersUpdated(LayerTransactionParent* aLayerTree,
                                   const uint64_t& aTransactionId,
                                   const TargetConfig& aTargetConfig,
                                   const InfallibleTArray<PluginWindowData>& aPlugins,
                                   bool aIsFirstPaint,
                                   bool aScheduleComposite,
                                   uint32_t aPaintSequenceNumber,
                                   bool aIsRepeatTransaction,
                                   int32_t aPaintSyncId,
                                   bool aHitTestUpdate) = 0;

  virtual AsyncCompositionManager* GetCompositionManager(LayerTransactionParent* aLayerTree) { return nullptr; }

  virtual void NotifyClearCachedResources(LayerTransactionParent* aLayerTree) { }

  virtual void ForceComposite(LayerTransactionParent* aLayerTree) { }
  virtual bool SetTestSampleTime(LayerTransactionParent* aLayerTree,
                                 const TimeStamp& aTime) { return true; }
  virtual void LeaveTestMode(LayerTransactionParent* aLayerTree) { }
  virtual void ApplyAsyncProperties(LayerTransactionParent* aLayerTree) = 0;
  virtual void FlushApzRepaints(const LayerTransactionParent* aLayerTree) = 0;
  virtual void GetAPZTestData(const LayerTransactionParent* aLayerTree,
                              APZTestData* aOutData) { }
  virtual void SetConfirmedTargetAPZC(const LayerTransactionParent* aLayerTree,
                                      const uint64_t& aInputBlockId,
                                      const nsTArray<ScrollableLayerGuid>& aTargets) = 0;
  virtual void UpdatePaintTime(LayerTransactionParent* aLayerTree, const TimeDuration& aPaintTime) {}

  virtual ShmemAllocator* AsShmemAllocator() override { return this; }

  virtual bool RecvSyncWithCompositor() override { return true; }

  // HostIPCAllocator
  virtual base::ProcessId GetChildProcessId() override;
  virtual void NotifyNotUsed(PTextureParent* aTexture, uint64_t aTransactionId) override;
  virtual void SendAsyncMessage(const InfallibleTArray<AsyncParentMessageData>& aMessage) override;

  // ShmemAllocator
  virtual bool AllocShmem(size_t aSize,
                          mozilla::ipc::SharedMemory::SharedMemoryType aType,
                          mozilla::ipc::Shmem* aShmem) override;
  virtual bool AllocUnsafeShmem(size_t aSize,
                                mozilla::ipc::SharedMemory::SharedMemoryType aType,
                                mozilla::ipc::Shmem* aShmem) override;
  virtual void DeallocShmem(mozilla::ipc::Shmem& aShmem) override;

  // MetricsSharingController
  NS_IMETHOD_(MozExternalRefCountType) AddRef() override { return HostIPCAllocator::AddRef(); }
  NS_IMETHOD_(MozExternalRefCountType) Release() override { return HostIPCAllocator::Release(); }
  base::ProcessId RemotePid() override;
  bool StartSharingMetrics(mozilla::ipc::SharedMemoryBasic::Handle aHandle,
                           CrossProcessMutexHandle aMutexHandle,
                           uint64_t aLayersId,
                           uint32_t aApzcId) override;
  bool StopSharingMetrics(FrameMetrics::ViewID aScrollId,
                          uint32_t aApzcId) override;
};

class CompositorBridgeParent final : public CompositorBridgeParentBase
                                   , public CompositorController
{
  friend class CompositorVsyncScheduler;
  friend class CompositorThreadHolder;
  friend class InProcessCompositorSession;
  friend class gfx::GPUProcessManager;
  friend class gfx::GPUParent;

public:
  NS_IMETHOD_(MozExternalRefCountType) AddRef() override { return CompositorBridgeParentBase::AddRef(); }
  NS_IMETHOD_(MozExternalRefCountType) Release() override { return CompositorBridgeParentBase::Release(); }

  explicit CompositorBridgeParent(CSSToLayoutDeviceScale aScale,
                                  const TimeDuration& aVsyncRate,
                                  bool aUseExternalSurfaceSize,
                                  const gfx::IntSize& aSurfaceSize);

  // Must only be called by CompositorBridgeChild. After invoking this, the
  // IPC channel is active and RecvWillStop/ActorDestroy must be called to
  // free the compositor.
  void InitSameProcess(widget::CompositorWidget* aWidget,
                       const uint64_t& aLayerTreeId,
                       bool aUseAPZ);

  // Must only be called by GPUParent. After invoking this, the IPC channel
  // is active and RecvWillStop/ActorDestroy must be called to free the
  // compositor.
  bool Bind(Endpoint<PCompositorBridgeParent>&& aEndpoint);

  virtual bool RecvInitialize(const uint64_t& aRootLayerTreeId) override;
  virtual bool RecvReset(nsTArray<LayersBackend>&& aBackendHints, bool* aResult, TextureFactoryIdentifier* aOutIdentifier) override;
  virtual bool RecvGetFrameUniformity(FrameUniformityData* aOutData) override;
  virtual bool RecvRequestOverfill() override;
  virtual bool RecvWillClose() override;
  virtual bool RecvPause() override;
  virtual bool RecvResume() override;
  virtual bool RecvNotifyChildCreated(const uint64_t& child) override;
  virtual bool RecvNotifyChildRecreated(const uint64_t& child) override;
  virtual bool RecvAdoptChild(const uint64_t& child) override;
  virtual bool RecvMakeSnapshot(const SurfaceDescriptor& aInSnapshot,
                                const gfx::IntRect& aRect) override;
  virtual bool RecvFlushRendering() override;
  virtual bool RecvForcePresent() override;

  virtual bool RecvAcknowledgeCompositorUpdate(const uint64_t& aLayersId) override {
    MOZ_ASSERT_UNREACHABLE("This message is only sent cross-process");
    return true;
  }

  virtual bool RecvNotifyRegionInvalidated(const nsIntRegion& aRegion) override;
  virtual bool RecvStartFrameTimeRecording(const int32_t& aBufferSize, uint32_t* aOutStartIndex) override;
  virtual bool RecvStopFrameTimeRecording(const uint32_t& aStartIndex, InfallibleTArray<float>* intervals) override;

  // Unused for chrome <-> compositor communication (which this class does).
  // @see CrossProcessCompositorBridgeParent::RecvRequestNotifyAfterRemotePaint
  virtual bool RecvRequestNotifyAfterRemotePaint() override { return true; };

  virtual bool RecvClearApproximatelyVisibleRegions(const uint64_t& aLayersId,
                                                    const uint32_t& aPresShellId) override;
  void ClearApproximatelyVisibleRegions(const uint64_t& aLayersId,
                                        const Maybe<uint32_t>& aPresShellId);
  virtual bool RecvNotifyApproximatelyVisibleRegion(const ScrollableLayerGuid& aGuid,
                                                    const CSSIntRegion& aRegion) override;

  virtual bool RecvAllPluginsCaptured() override;

  virtual void ActorDestroy(ActorDestroyReason why) override;

  virtual void ShadowLayersUpdated(LayerTransactionParent* aLayerTree,
                                   const uint64_t& aTransactionId,
                                   const TargetConfig& aTargetConfig,
                                   const InfallibleTArray<PluginWindowData>& aPlugins,
                                   bool aIsFirstPaint,
                                   bool aScheduleComposite,
                                   uint32_t aPaintSequenceNumber,
                                   bool aIsRepeatTransaction,
                                   int32_t aPaintSyncId,
                                   bool aHitTestUpdate) override;
  virtual void ForceComposite(LayerTransactionParent* aLayerTree) override;
  virtual bool SetTestSampleTime(LayerTransactionParent* aLayerTree,
                                 const TimeStamp& aTime) override;
  virtual void LeaveTestMode(LayerTransactionParent* aLayerTree) override;
  virtual void ApplyAsyncProperties(LayerTransactionParent* aLayerTree)
               override;
  virtual void FlushApzRepaints(const LayerTransactionParent* aLayerTree) override;
  virtual void GetAPZTestData(const LayerTransactionParent* aLayerTree,
                              APZTestData* aOutData) override;
  virtual void SetConfirmedTargetAPZC(const LayerTransactionParent* aLayerTree,
                                      const uint64_t& aInputBlockId,
                                      const nsTArray<ScrollableLayerGuid>& aTargets) override;
  virtual AsyncCompositionManager* GetCompositionManager(LayerTransactionParent* aLayerTree) override { return mCompositionManager; }

  virtual PTextureParent* AllocPTextureParent(const SurfaceDescriptor& aSharedData,
                                              const LayersBackend& aLayersBackend,
                                              const TextureFlags& aFlags,
                                              const uint64_t& aId,
                                              const uint64_t& aSerial) override;
  virtual bool DeallocPTextureParent(PTextureParent* actor) override;

  virtual bool IsSameProcess() const override;


  PCompositorWidgetParent* AllocPCompositorWidgetParent(const CompositorWidgetInitData& aInitData) override;
  bool DeallocPCompositorWidgetParent(PCompositorWidgetParent* aActor) override;

  /**
   * Request that the compositor be recreated due to a shared device reset.
   * This must be called on the main thread, and blocks until a task posted
   * to the compositor thread has completed.
   *
   * Note that this posts a task directly, rather than using synchronous
   * IPDL, and waits on a monitor notification from the compositor thread.
   * We do this as a best-effort attempt to jump any IPDL messages that
   * have not yet been posted (and are sitting around in the IO pipe), to
   * minimize the amount of time the main thread is blocked.
   */
  bool ResetCompositor(const nsTArray<LayersBackend>& aBackendHints,
                       TextureFactoryIdentifier* aOutIdentifier);

  /**
   * This forces the is-first-paint flag to true. This is intended to
   * be called by the widget code when it loses its viewport information
   * (or for whatever reason wants to refresh the viewport information).
   * The information refresh happens because the compositor will call
   * SetFirstPaintViewport on the next frame of composition.
   */
  void ForceIsFirstPaint();

  static void SetShadowProperties(Layer* aLayer);

  void NotifyChildCreated(uint64_t aChild);

  void AsyncRender();

  // Can be called from any thread
  void ScheduleRenderOnCompositorThread() override;
  void SchedulePauseOnCompositorThread();
  void InvalidateOnCompositorThread();
  /**
   * Returns true if a surface was obtained and the resume succeeded; false
   * otherwise.
   */
  bool ScheduleResumeOnCompositorThread();
  bool ScheduleResumeOnCompositorThread(int width, int height);

  virtual void ScheduleComposition();
  void NotifyShadowTreeTransaction(uint64_t aId, bool aIsFirstPaint,
      bool aScheduleComposite, uint32_t aPaintSequenceNumber,
      bool aIsRepeatTransaction, bool aHitTestUpdate);

  void UpdatePaintTime(LayerTransactionParent* aLayerTree,
                       const TimeDuration& aPaintTime) override;

  /**
   * Check rotation info and schedule a rendering task if needed.
   * Only can be called from compositor thread.
   */
  void ScheduleRotationOnCompositorThread(const TargetConfig& aTargetConfig, bool aIsFirstPaint);

  /**
   * Returns the unique layer tree identifier that corresponds to the root
   * tree of this compositor.
   */
  uint64_t RootLayerTreeId();

  /**
   * Notify local and remote layer trees connected to this compositor that
   * the compositor's local device is being reset. All layers must be
   * invalidated to clear any cached TextureSources.
   *
   * This must be called on the compositor thread.
   */
  void InvalidateRemoteLayers();

  /**
   * Returns a pointer to the CompositorBridgeParent corresponding to the given ID.
   */
  static CompositorBridgeParent* GetCompositorBridgeParent(uint64_t id);

  /**
   * Notify the compositor for the given layer tree that vsync has occurred.
   */
  static void NotifyVsync(const TimeStamp& aTimeStamp, const uint64_t& aLayersId);

  /**
   * Set aController as the pan/zoom callback for the subtree referred
   * to by aLayersId.
   *
   * Must run on content main thread.
   */
  static void SetControllerForLayerTree(uint64_t aLayersId,
                                        GeckoContentController* aController);

  /**
   * A new child process has been configured to push transactions
   * directly to us.  Transport is to its thread context.
   */
  static bool
  CreateForContent(Endpoint<PCompositorBridgeParent>&& aEndpoint);

  struct LayerTreeState {
    LayerTreeState();
    ~LayerTreeState();
    RefPtr<Layer> mRoot;
    RefPtr<GeckoContentController> mController;
    APZCTreeManagerParent* mApzcTreeManagerParent;
    CompositorBridgeParent* mParent;
    LayerManagerComposite* mLayerManager;
    // Pointer to the CrossProcessCompositorBridgeParent. Used by APZCs to share
    // their FrameMetrics with the corresponding child process that holds
    // the PCompositorBridgeChild
    CrossProcessCompositorBridgeParent* mCrossProcessParent;
    TargetConfig mTargetConfig;
    APZTestData mApzTestData;
    LayerTransactionParent* mLayerTree;
    nsTArray<PluginWindowData> mPluginData;
    bool mUpdatedPluginDataAvailable;

    // Number of times the compositor has been reset without having been
    // acknowledged by the child.
    uint32_t mPendingCompositorUpdates;

    CompositorController* GetCompositorController() const;
    MetricsSharingController* CrossProcessSharingController() const;
    MetricsSharingController* InProcessSharingController() const;
  };

  /**
   * Lookup the indirect shadow tree for |aId| and return it if it
   * exists.  Otherwise null is returned.  This must only be called on
   * the compositor thread.
   */
  static LayerTreeState* GetIndirectShadowTree(uint64_t aId);

  /**
   * Given the layers id for a content process, get the APZCTreeManagerParent
   * for the corresponding *root* layers id. That is, the APZCTreeManagerParent,
   * if one is found, will always be connected to the parent process rather
   * than a content process. Note that unless the compositor process is
   * separated this is expected to return null, because if the compositor is
   * living in the gecko parent process then there is no APZCTreeManagerParent
   * for the parent process.
   */
  static APZCTreeManagerParent* GetApzcTreeManagerParentForRoot(
        uint64_t aContentLayersId);
  /**
   * Same as the GetApzcTreeManagerParentForRoot function, but returns
   * the GeckoContentController for the parent process.
   */
  static GeckoContentController* GetGeckoContentControllerForRoot(
        uint64_t aContentLayersId);

#if defined(XP_WIN) || defined(MOZ_WIDGET_GTK)
  /**
   * Calculates and requests the main thread update plugin positioning, clip,
   * and visibility via ipc.
   */
  bool UpdatePluginWindowState(uint64_t aId);

  /**
   * Plugin visibility helpers for the apz (main thread) and compositor
   * thread.
   */
  void ScheduleShowAllPluginWindows() override;
  void ScheduleHideAllPluginWindows() override;
  void ShowAllPluginWindows();
  void HideAllPluginWindows();
#else
  void ScheduleShowAllPluginWindows() override {}
  void ScheduleHideAllPluginWindows() override {}
#endif

  /**
   * Main thread response for a plugin visibility request made by the
   * compositor thread.
   */
  virtual bool RecvRemotePluginsReady() override;

  /**
   * Used by the profiler to denote when a vsync occured
   */
  static void PostInsertVsyncProfilerMarker(mozilla::TimeStamp aVsyncTimestamp);

  widget::CompositorWidget* GetWidget() { return mWidget; }

  void ForceComposeToTarget(gfx::DrawTarget* aTarget, const gfx::IntRect* aRect = nullptr);

  PAPZCTreeManagerParent* AllocPAPZCTreeManagerParent(const uint64_t& aLayersId) override;
  bool DeallocPAPZCTreeManagerParent(PAPZCTreeManagerParent* aActor) override;

  PAPZParent* AllocPAPZParent(const uint64_t& aLayersId) override;
  bool DeallocPAPZParent(PAPZParent* aActor) override;

  bool RecvAsyncPanZoomEnabled(const uint64_t& aLayersId, bool* aHasAPZ) override;

  RefPtr<APZCTreeManager> GetAPZCTreeManager();

  bool AsyncPanZoomEnabled() const {
    return !!mApzcTreeManager;
  }

private:

  void Initialize();

  /**
   * Called during destruction in order to release resources as early as possible.
   */
  void StopAndClearResources();

  /**
   * This returns a reference to the APZCTreeManager to which
   * pan/zoom-related events can be sent.
   */
  static already_AddRefed<APZCTreeManager> GetAPZCTreeManager(uint64_t aLayersId);

  /**
   * Release compositor-thread resources referred to by |aID|.
   *
   * Must run on the content main thread.
   */
  static void DeallocateLayerTreeId(uint64_t aId);

protected:
  // Protected destructor, to discourage deletion outside of Release():
  virtual ~CompositorBridgeParent();

  void DeferredDestroy();

  virtual PLayerTransactionParent*
    AllocPLayerTransactionParent(const nsTArray<LayersBackend>& aBackendHints,
                                 const uint64_t& aId,
                                 TextureFactoryIdentifier* aTextureFactoryIdentifier,
                                 bool* aSuccess) override;
  virtual bool DeallocPLayerTransactionParent(PLayerTransactionParent* aLayers) override;
  virtual void ScheduleTask(already_AddRefed<CancelableRunnable>, int);
  void CompositeToTarget(gfx::DrawTarget* aTarget, const gfx::IntRect* aRect = nullptr);

  void SetEGLSurfaceSize(int width, int height);

  void InitializeLayerManager(const nsTArray<LayersBackend>& aBackendHints);
  void PauseComposition();
  void ResumeComposition();
  void ResumeCompositionAndResize(int width, int height);
  void ForceComposition();
  void CancelCurrentCompositeTask();
  void Invalidate();
  bool IsPendingComposite();
  void FinishPendingComposite();

  RefPtr<Compositor> NewCompositor(const nsTArray<LayersBackend>& aBackendHints);
  void ResetCompositorTask(const nsTArray<LayersBackend>& aBackendHints,
                           Maybe<TextureFactoryIdentifier>* aOutNewIdentifier);
  Maybe<TextureFactoryIdentifier> ResetCompositorImpl(const nsTArray<LayersBackend>& aBackendHints);

  /**
   * Add a compositor to the global compositor map.
   */
  static void AddCompositor(CompositorBridgeParent* compositor, uint64_t* id);
  /**
   * Remove a compositor from the global compositor map.
   */
  static CompositorBridgeParent* RemoveCompositor(uint64_t id);

  /**
   * Creates the global compositor map.
   */
  static void Setup();

  /**
   * Destroys the compositor thread and global compositor map.
   */
  static void Shutdown();

  /**
   * Finish the shutdown operation on the compositor thread.
   */
  static void FinishShutdown();

  /**
   * Return true if current state allows compositing, that is
   * finishing a layers transaction.
   */
  bool CanComposite();

  void DidComposite(TimeStamp& aCompositeStart, TimeStamp& aCompositeEnd);

  // The indirect layer tree lock must be held before calling this function.
  // Callback should take (LayerTreeState* aState, const uint64_t& aLayersId)
  template <typename Lambda>
  inline void ForEachIndirectLayerTree(const Lambda& aCallback);

  RefPtr<LayerManagerComposite> mLayerManager;
  RefPtr<Compositor> mCompositor;
  RefPtr<AsyncCompositionManager> mCompositionManager;
  widget::CompositorWidget* mWidget;
  TimeStamp mTestTime;
  CSSToLayoutDeviceScale mScale;
  TimeDuration mVsyncRate;
  bool mIsTesting;

  uint64_t mPendingTransaction;

  bool mPaused;

  bool mUseExternalSurfaceSize;
  gfx::IntSize mEGLSurfaceSize;

  mozilla::Monitor mPauseCompositionMonitor;
  mozilla::Monitor mResumeCompositionMonitor;
  mozilla::Monitor mResetCompositorMonitor;

  uint64_t mCompositorID;
  uint64_t mRootLayerTreeID;

  bool mOverrideComposeReadiness;
  RefPtr<CancelableRunnable> mForceCompositionTask;

  RefPtr<APZCTreeManager> mApzcTreeManager;

  RefPtr<CompositorThreadHolder> mCompositorThreadHolder;
  RefPtr<CompositorVsyncScheduler> mCompositorScheduler;
  // This makes sure the compositorParent is not destroyed before receiving
  // confirmation that the channel is closed.
  // mSelfRef is cleared in DeferredDestroy which is scheduled by ActorDestroy.
  RefPtr<CompositorBridgeParent> mSelfRef;

  TimeDuration mPaintTime;

#if defined(XP_WIN) || defined(MOZ_WIDGET_GTK)
  // cached plugin data used to reduce the number of updates we request.
  uint64_t mLastPluginUpdateLayerTreeId;
  nsIntPoint mPluginsLayerOffset;
  nsIntRegion mPluginsLayerVisibleRegion;
  nsTArray<PluginWindowData> mCachedPluginData;
  // Time until which we will block composition to wait for plugin updates.
  TimeStamp mWaitForPluginsUntil;
  // Indicates that we have actually blocked a composition waiting for plugins.
  bool mHaveBlockedForPlugins = false;
  // indicates if plugin window visibility and metric updates are currently
  // being defered due to a scroll operation.
  bool mDeferPluginWindows;
  // indicates if the plugin windows were hidden, and need to be made
  // visible again even if their geometry has not changed.
  bool mPluginWindowsHidden;
#endif

  DISALLOW_EVIL_CONSTRUCTORS(CompositorBridgeParent);
};

} // namespace layers
} // namespace mozilla

#endif // mozilla_layers_CompositorBridgeParent_h
