/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set sw=2 ts=2 et tw=80 : */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/layers/CompositorBridgeParent.h"
#include <stdio.h>                      // for fprintf, stdout
#include <stdint.h>                     // for uint64_t
#include <map>                          // for _Rb_tree_iterator, etc
#include <utility>                      // for pair
#include "LayerTransactionParent.h"     // for LayerTransactionParent
#include "RenderTrace.h"                // for RenderTraceLayers
#include "base/message_loop.h"          // for MessageLoop
#include "base/process.h"               // for ProcessId
#include "base/task.h"                  // for CancelableTask, etc
#include "base/thread.h"                // for Thread
#include "gfxContext.h"                 // for gfxContext
#include "gfxPlatform.h"                // for gfxPlatform
#include "TreeTraversal.h"              // for ForEachNode
#ifdef MOZ_WIDGET_GTK
#include "gfxPlatformGtk.h"             // for gfxPlatform
#endif
#include "gfxPrefs.h"                   // for gfxPrefs
#include "mozilla/AutoRestore.h"        // for AutoRestore
#include "mozilla/ClearOnShutdown.h"    // for ClearOnShutdown
#include "mozilla/DebugOnly.h"          // for DebugOnly
#include "mozilla/dom/ContentParent.h"
#include "mozilla/dom/TabParent.h"
#include "mozilla/gfx/2D.h"          // for DrawTarget
#include "mozilla/gfx/Point.h"          // for IntSize
#include "mozilla/gfx/Rect.h"          // for IntSize
#include "VRManager.h"                  // for VRManager
#include "mozilla/ipc/Transport.h"      // for Transport
#include "mozilla/layers/APZCTreeManager.h"  // for APZCTreeManager
#include "mozilla/layers/APZCTreeManagerParent.h"  // for APZCTreeManagerParent
#include "mozilla/layers/APZThreadUtils.h"  // for APZCTreeManager
#include "mozilla/layers/AsyncCompositionManager.h"
#include "mozilla/layers/BasicCompositor.h"  // for BasicCompositor
#include "mozilla/layers/Compositor.h"  // for Compositor
#include "mozilla/layers/CompositorOGL.h"  // for CompositorOGL
#include "mozilla/layers/CompositorThread.h"
#include "mozilla/layers/CompositorTypes.h"
#include "mozilla/layers/CrossProcessCompositorBridgeParent.h"
#include "mozilla/layers/FrameUniformityData.h"
#include "mozilla/layers/ImageBridgeParent.h"
#include "mozilla/layers/LayerManagerComposite.h"
#include "mozilla/layers/LayerTreeOwnerTracker.h"
#include "mozilla/layers/LayersTypes.h"
#include "mozilla/layers/PLayerTransactionParent.h"
#include "mozilla/layers/RemoteContentController.h"
#include "mozilla/layout/RenderFrameParent.h"
#include "mozilla/media/MediaSystemResourceService.h" // for MediaSystemResourceService
#include "mozilla/mozalloc.h"           // for operator new, etc
#include "mozilla/Telemetry.h"
#ifdef MOZ_WIDGET_GTK
#include "basic/X11BasicCompositor.h" // for X11BasicCompositor
#endif
#include "nsCOMPtr.h"                   // for already_AddRefed
#include "nsDebug.h"                    // for NS_ASSERTION, etc
#include "nsISupportsImpl.h"            // for MOZ_COUNT_CTOR, etc
#include "nsIWidget.h"                  // for nsIWidget
#include "nsTArray.h"                   // for nsTArray
#include "nsThreadUtils.h"              // for NS_IsMainThread
#include "nsXULAppAPI.h"                // for XRE_GetIOMessageLoop
#ifdef XP_WIN
#include "mozilla/layers/CompositorD3D11.h"
#include "mozilla/layers/CompositorD3D9.h"
#endif
#include "GeckoProfiler.h"
#include "mozilla/ipc/ProtocolTypes.h"
#include "mozilla/Unused.h"
#include "mozilla/Hal.h"
#include "mozilla/HalTypes.h"
#include "mozilla/StaticPtr.h"
#include "mozilla/Telemetry.h"
#ifdef MOZ_ENABLE_PROFILER_SPS
#include "ProfilerMarkers.h"
#endif
#include "mozilla/VsyncDispatcher.h"
#if defined(XP_WIN) || defined(MOZ_WIDGET_GTK)
#include "VsyncSource.h"
#endif
#include "mozilla/widget/CompositorWidget.h"
#ifdef MOZ_WIDGET_SUPPORTS_OOP_COMPOSITING
# include "mozilla/widget/CompositorWidgetParent.h"
#endif

#include "LayerScope.h"

namespace mozilla {

namespace layers {

using namespace mozilla::ipc;
using namespace mozilla::gfx;
using namespace std;

using base::ProcessId;
using base::Thread;

ProcessId
CompositorBridgeParentBase::GetChildProcessId()
{
  return OtherPid();
}

void
CompositorBridgeParentBase::NotifyNotUsed(PTextureParent* aTexture, uint64_t aTransactionId)
{
  RefPtr<TextureHost> texture = TextureHost::AsTextureHost(aTexture);
  if (!texture) {
    return;
  }

  if (!(texture->GetFlags() & TextureFlags::RECYCLE)) {
    return;
  }

  uint64_t textureId = TextureHost::GetTextureSerial(aTexture);
  mPendingAsyncMessage.push_back(
    OpNotifyNotUsed(textureId, aTransactionId));
}

void
CompositorBridgeParentBase::SendAsyncMessage(const InfallibleTArray<AsyncParentMessageData>& aMessage)
{
  Unused << SendParentAsyncMessages(aMessage);
}

bool
CompositorBridgeParentBase::AllocShmem(size_t aSize,
                                   ipc::SharedMemory::SharedMemoryType aType,
                                   ipc::Shmem* aShmem)
{
  return PCompositorBridgeParent::AllocShmem(aSize, aType, aShmem);
}

bool
CompositorBridgeParentBase::AllocUnsafeShmem(size_t aSize,
                                         ipc::SharedMemory::SharedMemoryType aType,
                                         ipc::Shmem* aShmem)
{
  return PCompositorBridgeParent::AllocUnsafeShmem(aSize, aType, aShmem);
}

void
CompositorBridgeParentBase::DeallocShmem(ipc::Shmem& aShmem)
{
  PCompositorBridgeParent::DeallocShmem(aShmem);
}

base::ProcessId
CompositorBridgeParentBase::RemotePid()
{
  return OtherPid();
}

bool
CompositorBridgeParentBase::StartSharingMetrics(ipc::SharedMemoryBasic::Handle aHandle,
                                                CrossProcessMutexHandle aMutexHandle,
                                                uint64_t aLayersId,
                                                uint32_t aApzcId)
{
  return PCompositorBridgeParent::SendSharedCompositorFrameMetrics(
    aHandle, aMutexHandle, aLayersId, aApzcId);
}

bool
CompositorBridgeParentBase::StopSharingMetrics(FrameMetrics::ViewID aScrollId,
                                               uint32_t aApzcId)
{
  return PCompositorBridgeParent::SendReleaseSharedCompositorFrameMetrics(
    aScrollId, aApzcId);
}

CompositorBridgeParent::LayerTreeState::LayerTreeState()
  : mApzcTreeManagerParent(nullptr)
  , mParent(nullptr)
  , mLayerManager(nullptr)
  , mCrossProcessParent(nullptr)
  , mLayerTree(nullptr)
  , mUpdatedPluginDataAvailable(false)
  , mPendingCompositorUpdates(0)
{
}

CompositorBridgeParent::LayerTreeState::~LayerTreeState()
{
  if (mController) {
    mController->Destroy();
  }
}

typedef map<uint64_t, CompositorBridgeParent::LayerTreeState> LayerTreeMap;
static LayerTreeMap sIndirectLayerTrees;
static StaticAutoPtr<mozilla::Monitor> sIndirectLayerTreesLock;

static void EnsureLayerTreeMapReady()
{
  MOZ_ASSERT(NS_IsMainThread());
  if (!sIndirectLayerTreesLock) {
    sIndirectLayerTreesLock = new Monitor("IndirectLayerTree");
    mozilla::ClearOnShutdown(&sIndirectLayerTreesLock);
  }
}

template <typename Lambda>
inline void
CompositorBridgeParent::ForEachIndirectLayerTree(const Lambda& aCallback)
{
  sIndirectLayerTreesLock->AssertCurrentThreadOwns();
  for (auto it = sIndirectLayerTrees.begin(); it != sIndirectLayerTrees.end(); it++) {
    LayerTreeState* state = &it->second;
    if (state->mParent == this) {
      aCallback(state, it->first);
    }
  }
}

/**
  * A global map referencing each compositor by ID.
  *
  * This map is used by the ImageBridge protocol to trigger
  * compositions without having to keep references to the
  * compositor
  */
typedef map<uint64_t,CompositorBridgeParent*> CompositorMap;
static StaticAutoPtr<CompositorMap> sCompositorMap;

void
CompositorBridgeParent::Setup()
{
  EnsureLayerTreeMapReady();

  MOZ_ASSERT(!sCompositorMap);
  sCompositorMap = new CompositorMap;
}

void
CompositorBridgeParent::Shutdown()
{
  MOZ_ASSERT(sCompositorMap);
  MOZ_ASSERT(sCompositorMap->empty());
  sCompositorMap = nullptr;
}

void
CompositorBridgeParent::FinishShutdown()
{
  // TODO: this should be empty by now...
  sIndirectLayerTrees.clear();
}

static void SetThreadPriority()
{
  hal::SetCurrentThreadPriority(hal::THREAD_PRIORITY_COMPOSITOR);
}

#ifdef COMPOSITOR_PERFORMANCE_WARNING
static int32_t
CalculateCompositionFrameRate()
{
  // Used when layout.frame_rate is -1. Needs to be kept in sync with
  // DEFAULT_FRAME_RATE in nsRefreshDriver.cpp.
  // TODO: This should actually return the vsync rate.
  const int32_t defaultFrameRate = 60;
  int32_t compositionFrameRatePref = gfxPrefs::LayersCompositionFrameRate();
  if (compositionFrameRatePref < 0) {
    // Use the same frame rate for composition as for layout.
    int32_t layoutFrameRatePref = gfxPrefs::LayoutFrameRate();
    if (layoutFrameRatePref < 0) {
      // TODO: The main thread frame scheduling code consults the actual
      // monitor refresh rate in this case. We should do the same.
      return defaultFrameRate;
    }
    return layoutFrameRatePref;
  }
  return compositionFrameRatePref;
}
#endif

CompositorVsyncScheduler::Observer::Observer(CompositorVsyncScheduler* aOwner)
  : mMutex("CompositorVsyncScheduler.Observer.Mutex")
  , mOwner(aOwner)
{
}

CompositorVsyncScheduler::Observer::~Observer()
{
  MOZ_ASSERT(!mOwner);
}

bool
CompositorVsyncScheduler::Observer::NotifyVsync(TimeStamp aVsyncTimestamp)
{
  MutexAutoLock lock(mMutex);
  if (!mOwner) {
    return false;
  }
  return mOwner->NotifyVsync(aVsyncTimestamp);
}

void
CompositorVsyncScheduler::Observer::Destroy()
{
  MutexAutoLock lock(mMutex);
  mOwner = nullptr;
}

CompositorVsyncScheduler::CompositorVsyncScheduler(CompositorBridgeParent* aCompositorBridgeParent,
                                                   widget::CompositorWidget* aWidget)
  : mCompositorBridgeParent(aCompositorBridgeParent)
  , mLastCompose(TimeStamp::Now())
  , mIsObservingVsync(false)
  , mNeedsComposite(0)
  , mVsyncNotificationsSkipped(0)
  , mWidget(aWidget)
  , mCurrentCompositeTaskMonitor("CurrentCompositeTaskMonitor")
  , mCurrentCompositeTask(nullptr)
  , mSetNeedsCompositeMonitor("SetNeedsCompositeMonitor")
  , mSetNeedsCompositeTask(nullptr)
{
  MOZ_ASSERT(NS_IsMainThread() || XRE_GetProcessType() == GeckoProcessType_GPU);
  mVsyncObserver = new Observer(this);

  // mAsapScheduling is set on the main thread during init,
  // but is only accessed after on the compositor thread.
  mAsapScheduling = gfxPrefs::LayersCompositionFrameRate() == 0 ||
                    gfxPlatform::IsInLayoutAsapMode();
}

CompositorVsyncScheduler::~CompositorVsyncScheduler()
{
  MOZ_ASSERT(!mIsObservingVsync);
  MOZ_ASSERT(!mVsyncObserver);
  // The CompositorVsyncDispatcher is cleaned up before this in the nsBaseWidget, which stops vsync listeners
  mCompositorBridgeParent = nullptr;
}

void
CompositorVsyncScheduler::Destroy()
{
  if (!mVsyncObserver) {
    // Destroy was already called on this object.
    return;
  }
  MOZ_ASSERT(CompositorThreadHolder::IsInCompositorThread());
  UnobserveVsync();
  mVsyncObserver->Destroy();
  mVsyncObserver = nullptr;

  CancelCurrentSetNeedsCompositeTask();
  CancelCurrentCompositeTask();
}

void
CompositorVsyncScheduler::PostCompositeTask(TimeStamp aCompositeTimestamp)
{
  // can be called from the compositor or vsync thread
  MonitorAutoLock lock(mCurrentCompositeTaskMonitor);
  if (mCurrentCompositeTask == nullptr && CompositorThreadHolder::Loop()) {
    RefPtr<CancelableRunnable> task =
      NewCancelableRunnableMethod<TimeStamp>(this, &CompositorVsyncScheduler::Composite,
                                             aCompositeTimestamp);
    mCurrentCompositeTask = task;
    ScheduleTask(task.forget(), 0);
  }
}

void
CompositorVsyncScheduler::ScheduleComposition()
{
  MOZ_ASSERT(CompositorThreadHolder::IsInCompositorThread());
  if (mAsapScheduling) {
    // Used only for performance testing purposes
    PostCompositeTask(TimeStamp::Now());
#ifdef MOZ_WIDGET_ANDROID
  } else if (mNeedsComposite >= 2 && mIsObservingVsync) {
    // uh-oh, we already requested a composite at least twice so far, and a
    // composite hasn't happened yet. It is possible that the vsync observation
    // is blocked on the main thread, so let's just composite ASAP and not
    // wait for the vsync. Note that this should only ever happen on Fennec
    // because there content runs in the same process as the compositor, and so
    // content can actually block the main thread in this process.
    PostCompositeTask(TimeStamp::Now());
#endif
  } else {
    SetNeedsComposite();
  }
}

void
CompositorVsyncScheduler::CancelCurrentSetNeedsCompositeTask()
{
  MOZ_ASSERT(CompositorThreadHolder::IsInCompositorThread());
  MonitorAutoLock lock(mSetNeedsCompositeMonitor);
  if (mSetNeedsCompositeTask) {
    mSetNeedsCompositeTask->Cancel();
    mSetNeedsCompositeTask = nullptr;
  }
  mNeedsComposite = 0;
}

/**
 * TODO Potential performance heuristics:
 * If a composite takes 17 ms, do we composite ASAP or wait until next vsync?
 * If a layer transaction comes after vsync, do we composite ASAP or wait until
 * next vsync?
 * How many skipped vsync events until we stop listening to vsync events?
 */
void
CompositorVsyncScheduler::SetNeedsComposite()
{
  if (!CompositorThreadHolder::IsInCompositorThread()) {
    MonitorAutoLock lock(mSetNeedsCompositeMonitor);
    RefPtr<CancelableRunnable> task =
      NewCancelableRunnableMethod(this, &CompositorVsyncScheduler::SetNeedsComposite);
    mSetNeedsCompositeTask = task;
    ScheduleTask(task.forget(), 0);
    return;
  } else {
    MonitorAutoLock lock(mSetNeedsCompositeMonitor);
    mSetNeedsCompositeTask = nullptr;
  }

  mNeedsComposite++;
  if (!mIsObservingVsync && mNeedsComposite) {
    ObserveVsync();
  }
}

bool
CompositorVsyncScheduler::NotifyVsync(TimeStamp aVsyncTimestamp)
{
  // Called from the vsync dispatch thread. When in the GPU Process, that's
  // the same as the compositor thread.
  MOZ_ASSERT_IF(XRE_IsParentProcess(), !CompositorThreadHolder::IsInCompositorThread());
  MOZ_ASSERT_IF(XRE_GetProcessType() == GeckoProcessType_GPU, CompositorThreadHolder::IsInCompositorThread());
  MOZ_ASSERT(!NS_IsMainThread());
  PostCompositeTask(aVsyncTimestamp);
  return true;
}

void
CompositorVsyncScheduler::CancelCurrentCompositeTask()
{
  MOZ_ASSERT(CompositorThreadHolder::IsInCompositorThread() || NS_IsMainThread());
  MonitorAutoLock lock(mCurrentCompositeTaskMonitor);
  if (mCurrentCompositeTask) {
    mCurrentCompositeTask->Cancel();
    mCurrentCompositeTask = nullptr;
  }
}

void
CompositorVsyncScheduler::Composite(TimeStamp aVsyncTimestamp)
{
  MOZ_ASSERT(CompositorThreadHolder::IsInCompositorThread());
  {
    MonitorAutoLock lock(mCurrentCompositeTaskMonitor);
    mCurrentCompositeTask = nullptr;
  }

  if ((aVsyncTimestamp < mLastCompose) && !mAsapScheduling) {
    // We can sometimes get vsync timestamps that are in the past
    // compared to the last compose with force composites.
    // In those cases, wait until the next vsync;
    return;
  }

  MOZ_ASSERT(mCompositorBridgeParent);
  if (!mAsapScheduling && mCompositorBridgeParent->IsPendingComposite()) {
    // If previous composite is still on going, finish it and does a next
    // composite in a next vsync.
    mCompositorBridgeParent->FinishPendingComposite();
    return;
  }

  DispatchTouchEvents(aVsyncTimestamp);
  DispatchVREvents(aVsyncTimestamp);

  if (mNeedsComposite || mAsapScheduling) {
    mNeedsComposite = 0;
    mLastCompose = aVsyncTimestamp;
    ComposeToTarget(nullptr);
    mVsyncNotificationsSkipped = 0;

    TimeDuration compositeFrameTotal = TimeStamp::Now() - aVsyncTimestamp;
    mozilla::Telemetry::Accumulate(mozilla::Telemetry::COMPOSITE_FRAME_ROUNDTRIP_TIME,
                                   compositeFrameTotal.ToMilliseconds());
  } else if (mVsyncNotificationsSkipped++ > gfxPrefs::CompositorUnobserveCount()) {
    UnobserveVsync();
  }
}

void
CompositorVsyncScheduler::OnForceComposeToTarget()
{
  /**
   * bug 1138502 - There are cases such as during long-running window resizing events
   * where we receive many sync RecvFlushComposites. We also get vsync notifications which
   * will increment mVsyncNotificationsSkipped because a composite just occurred. After
   * enough vsyncs and RecvFlushComposites occurred, we will disable vsync. Then at the next
   * ScheduleComposite, we will enable vsync, then get a RecvFlushComposite, which will
   * force us to unobserve vsync again. On some platforms, enabling/disabling vsync is not
   * free and this oscillating behavior causes a performance hit. In order to avoid this problem,
   * we reset the mVsyncNotificationsSkipped counter to keep vsync enabled.
   */
  MOZ_ASSERT(CompositorThreadHolder::IsInCompositorThread());
  mVsyncNotificationsSkipped = 0;
}

void
CompositorVsyncScheduler::ForceComposeToTarget(gfx::DrawTarget* aTarget, const IntRect* aRect)
{
  MOZ_ASSERT(CompositorThreadHolder::IsInCompositorThread());
  OnForceComposeToTarget();
  mLastCompose = TimeStamp::Now();
  ComposeToTarget(aTarget, aRect);
}

bool
CompositorVsyncScheduler::NeedsComposite()
{
  MOZ_ASSERT(CompositorThreadHolder::IsInCompositorThread());
  return mNeedsComposite;
}

void
CompositorVsyncScheduler::ObserveVsync()
{
  MOZ_ASSERT(CompositorThreadHolder::IsInCompositorThread());
  mWidget->ObserveVsync(mVsyncObserver);
  mIsObservingVsync = true;
}

void
CompositorVsyncScheduler::UnobserveVsync()
{
  MOZ_ASSERT(CompositorThreadHolder::IsInCompositorThread());
  mWidget->ObserveVsync(nullptr);
  mIsObservingVsync = false;
}

void
CompositorVsyncScheduler::DispatchTouchEvents(TimeStamp aVsyncTimestamp)
{
}

void
CompositorVsyncScheduler::DispatchVREvents(TimeStamp aVsyncTimestamp)
{
  MOZ_ASSERT(CompositorThreadHolder::IsInCompositorThread());

  VRManager* vm = VRManager::Get();
  vm->NotifyVsync(aVsyncTimestamp);
}

void
CompositorVsyncScheduler::ScheduleTask(already_AddRefed<CancelableRunnable> aTask,
                                       int aTime)
{
  MOZ_ASSERT(CompositorThreadHolder::Loop());
  MOZ_ASSERT(aTime >= 0);
  CompositorThreadHolder::Loop()->PostDelayedTask(Move(aTask), aTime);
}

void
CompositorVsyncScheduler::ResumeComposition()
{
  MOZ_ASSERT(CompositorThreadHolder::IsInCompositorThread());
  mLastCompose = TimeStamp::Now();
  ComposeToTarget(nullptr);
}

void
CompositorVsyncScheduler::ComposeToTarget(gfx::DrawTarget* aTarget, const IntRect* aRect)
{
  MOZ_ASSERT(CompositorThreadHolder::IsInCompositorThread());
  MOZ_ASSERT(mCompositorBridgeParent);
  mCompositorBridgeParent->CompositeToTarget(aTarget, aRect);
}

static inline MessageLoop*
CompositorLoop()
{
  return CompositorThreadHolder::Loop();
}

CompositorBridgeParent::CompositorBridgeParent(CSSToLayoutDeviceScale aScale,
                                               const TimeDuration& aVsyncRate,
                                               bool aUseExternalSurfaceSize,
                                               const gfx::IntSize& aSurfaceSize)
  : mWidget(nullptr)
  , mScale(aScale)
  , mVsyncRate(aVsyncRate)
  , mIsTesting(false)
  , mPendingTransaction(0)
  , mPaused(false)
  , mUseExternalSurfaceSize(aUseExternalSurfaceSize)
  , mEGLSurfaceSize(aSurfaceSize)
  , mPauseCompositionMonitor("PauseCompositionMonitor")
  , mResumeCompositionMonitor("ResumeCompositionMonitor")
  , mResetCompositorMonitor("ResetCompositorMonitor")
  , mRootLayerTreeID(0)
  , mOverrideComposeReadiness(false)
  , mForceCompositionTask(nullptr)
  , mCompositorThreadHolder(CompositorThreadHolder::GetSingleton())
  , mCompositorScheduler(nullptr)
  , mPaintTime(TimeDuration::Forever())
#if defined(XP_WIN) || defined(MOZ_WIDGET_GTK)
  , mLastPluginUpdateLayerTreeId(0)
  , mDeferPluginWindows(false)
  , mPluginWindowsHidden(false)
#endif
{
  // Always run destructor on the main thread
  MOZ_ASSERT(NS_IsMainThread());
}

void
CompositorBridgeParent::InitSameProcess(widget::CompositorWidget* aWidget,
                                        const uint64_t& aLayerTreeId,
                                        bool aUseAPZ)
{
  mWidget = aWidget;
  mRootLayerTreeID = aLayerTreeId;
  if (aUseAPZ) {
    mApzcTreeManager = new APZCTreeManager();
  }

  // IPDL initialization. mSelfRef is cleared in DeferredDestroy.
  SetOtherProcessId(base::GetCurrentProcId());
  mSelfRef = this;

  Initialize();
}

bool
CompositorBridgeParent::Bind(Endpoint<PCompositorBridgeParent>&& aEndpoint)
{
  if (!aEndpoint.Bind(this)) {
    return false;
  }
  mSelfRef = this;
  return true;
}

bool
CompositorBridgeParent::RecvInitialize(const uint64_t& aRootLayerTreeId)
{
  mRootLayerTreeID = aRootLayerTreeId;

  Initialize();
  return true;
}

void
CompositorBridgeParent::Initialize()
{
  MOZ_ASSERT(CompositorThread(),
             "The compositor thread must be Initialized before instanciating a CompositorBridgeParent.");

  mCompositorID = 0;
  // FIXME: This holds on the the fact that right now the only thing that
  // can destroy this instance is initialized on the compositor thread after
  // this task has been processed.
  MOZ_ASSERT(CompositorLoop());
  CompositorLoop()->PostTask(NewRunnableFunction(&AddCompositor,
                                                 this, &mCompositorID));

  CompositorLoop()->PostTask(NewRunnableFunction(SetThreadPriority));


  { // scope lock
    MonitorAutoLock lock(*sIndirectLayerTreesLock);
    sIndirectLayerTrees[mRootLayerTreeID].mParent = this;
  }

  LayerScope::SetPixelScale(mScale.scale);

  mCompositorScheduler = new CompositorVsyncScheduler(this, mWidget);
}

bool
CompositorBridgeParent::RecvReset(nsTArray<LayersBackend>&& aBackendHints, bool* aResult, TextureFactoryIdentifier* aOutIdentifier)
{
  Maybe<TextureFactoryIdentifier> newIdentifier;
  ResetCompositorTask(aBackendHints, &newIdentifier);
  
  if (newIdentifier) {
    *aResult = true;
    *aOutIdentifier = newIdentifier.value();
  } else {
    *aResult = false;
  }

  return true;
}

uint64_t
CompositorBridgeParent::RootLayerTreeId()
{
  MOZ_ASSERT(mRootLayerTreeID);
  return mRootLayerTreeID;
}

CompositorBridgeParent::~CompositorBridgeParent()
{
  InfallibleTArray<PTextureParent*> textures;
  ManagedPTextureParent(textures);
  // We expect all textures to be destroyed by now.
  MOZ_DIAGNOSTIC_ASSERT(textures.Length() == 0);
  for (unsigned int i = 0; i < textures.Length(); ++i) {
    RefPtr<TextureHost> tex = TextureHost::AsTextureHost(textures[i]);
    tex->DeallocateDeviceData();
  }
}

void
CompositorBridgeParent::ForceIsFirstPaint()
{
  mCompositionManager->ForceIsFirstPaint();
}

void
CompositorBridgeParent::StopAndClearResources()
{
  if (mForceCompositionTask) {
    mForceCompositionTask->Cancel();
    mForceCompositionTask = nullptr;
  }

  mPaused = true;

  // Ensure that the layer manager is destroyed before CompositorBridgeChild.
  if (mLayerManager) {
    MonitorAutoLock lock(*sIndirectLayerTreesLock);
    ForEachIndirectLayerTree([this] (LayerTreeState* lts, uint64_t) -> void {
      mLayerManager->ClearCachedResources(lts->mRoot);
      lts->mLayerManager = nullptr;
      lts->mParent = nullptr;
    });
    mLayerManager->Destroy();
    mLayerManager = nullptr;
    mCompositionManager = nullptr;
  }

  if (mCompositor) {
    mCompositor->DetachWidget();
    mCompositor->Destroy();
    mCompositor = nullptr;
  }

  // This must be destroyed now since it accesses the widget.
  if (mCompositorScheduler) {
    mCompositorScheduler->Destroy();
    mCompositorScheduler = nullptr;
  }

  // After this point, it is no longer legal to access the widget.
  mWidget = nullptr;
}

bool
CompositorBridgeParent::RecvWillClose()
{
  StopAndClearResources();
  return true;
}

void CompositorBridgeParent::DeferredDestroy()
{
  MOZ_ASSERT(!NS_IsMainThread());
  MOZ_ASSERT(mCompositorThreadHolder);
  mCompositorThreadHolder = nullptr;
  mSelfRef = nullptr;
}

bool
CompositorBridgeParent::RecvPause()
{
  PauseComposition();
  return true;
}

bool
CompositorBridgeParent::RecvResume()
{
  ResumeComposition();
  return true;
}

bool
CompositorBridgeParent::RecvMakeSnapshot(const SurfaceDescriptor& aInSnapshot,
                                         const gfx::IntRect& aRect)
{
  RefPtr<DrawTarget> target = GetDrawTargetForDescriptor(aInSnapshot, gfx::BackendType::CAIRO);
  MOZ_ASSERT(target);
  if (!target) {
    // We kill the content process rather than have it continue with an invalid
    // snapshot, that may be too harsh and we could decide to return some sort
    // of error to the child process and let it deal with it...
    return false;
  }
  ForceComposeToTarget(target, &aRect);
  return true;
}

bool
CompositorBridgeParent::RecvFlushRendering()
{
  if (mCompositorScheduler->NeedsComposite())
  {
    CancelCurrentCompositeTask();
    ForceComposeToTarget(nullptr);
  }
  return true;
}

bool
CompositorBridgeParent::RecvForcePresent()
{
  // During the shutdown sequence mLayerManager may be null
  if (mLayerManager) {
    mLayerManager->ForcePresent();
  }
  return true;
}

bool
CompositorBridgeParent::RecvNotifyRegionInvalidated(const nsIntRegion& aRegion)
{
  if (mLayerManager) {
    mLayerManager->AddInvalidRegion(aRegion);
  }
  return true;
}

void
CompositorBridgeParent::Invalidate()
{
  if (mLayerManager && mLayerManager->GetRoot()) {
    mLayerManager->AddInvalidRegion(
                                    mLayerManager->GetRoot()->GetLocalVisibleRegion().ToUnknownRegion().GetBounds());
  }
}

bool
CompositorBridgeParent::RecvStartFrameTimeRecording(const int32_t& aBufferSize, uint32_t* aOutStartIndex)
{
  if (mLayerManager) {
    *aOutStartIndex = mLayerManager->StartFrameTimeRecording(aBufferSize);
  } else {
    *aOutStartIndex = 0;
  }
  return true;
}

bool
CompositorBridgeParent::RecvStopFrameTimeRecording(const uint32_t& aStartIndex,
                                                   InfallibleTArray<float>* intervals)
{
  if (mLayerManager) {
    mLayerManager->StopFrameTimeRecording(aStartIndex, *intervals);
  }
  return true;
}

bool
CompositorBridgeParent::RecvClearApproximatelyVisibleRegions(const uint64_t& aLayersId,
                                                            const uint32_t& aPresShellId)
{
  ClearApproximatelyVisibleRegions(aLayersId, Some(aPresShellId));
  return true;
}

void
CompositorBridgeParent::ClearApproximatelyVisibleRegions(const uint64_t& aLayersId,
                                                         const Maybe<uint32_t>& aPresShellId)
{
  if (mLayerManager) {
    mLayerManager->ClearApproximatelyVisibleRegions(aLayersId, aPresShellId);

    // We need to recomposite to update the minimap.
    ScheduleComposition();
  }
}

bool
CompositorBridgeParent::RecvNotifyApproximatelyVisibleRegion(const ScrollableLayerGuid& aGuid,
                                                             const CSSIntRegion& aRegion)
{
  if (mLayerManager) {
    mLayerManager->UpdateApproximatelyVisibleRegion(aGuid, aRegion);

    // We need to recomposite to update the minimap.
    ScheduleComposition();
  }
  return true;
}

void
CompositorBridgeParent::ActorDestroy(ActorDestroyReason why)
{
  StopAndClearResources();

  RemoveCompositor(mCompositorID);

  mCompositionManager = nullptr;

  if (mApzcTreeManager) {
    mApzcTreeManager->ClearTree();
    mApzcTreeManager = nullptr;
  }

  { // scope lock
    MonitorAutoLock lock(*sIndirectLayerTreesLock);
    sIndirectLayerTrees.erase(mRootLayerTreeID);
  }

  // There are chances that the ref count reaches zero on the main thread shortly
  // after this function returns while some ipdl code still needs to run on
  // this thread.
  // We must keep the compositor parent alive untill the code handling message
  // reception is finished on this thread.
  mSelfRef = this;
  MessageLoop::current()->PostTask(NewRunnableMethod(this, &CompositorBridgeParent::DeferredDestroy));
}

void
CompositorBridgeParent::ScheduleRenderOnCompositorThread()
{
  MOZ_ASSERT(CompositorLoop());
  CompositorLoop()->PostTask(NewRunnableMethod(this, &CompositorBridgeParent::ScheduleComposition));
}

void
CompositorBridgeParent::InvalidateOnCompositorThread()
{
  MOZ_ASSERT(CompositorLoop());
  CompositorLoop()->PostTask(NewRunnableMethod(this, &CompositorBridgeParent::Invalidate));
}

void
CompositorBridgeParent::PauseComposition()
{
  MOZ_ASSERT(CompositorThreadHolder::IsInCompositorThread(),
             "PauseComposition() can only be called on the compositor thread");

  MonitorAutoLock lock(mPauseCompositionMonitor);

  if (!mPaused) {
    mPaused = true;

    mCompositor->Pause();

    TimeStamp now = TimeStamp::Now();
    DidComposite(now, now);
  }

  // if anyone's waiting to make sure that composition really got paused, tell them
  lock.NotifyAll();
}

void
CompositorBridgeParent::ResumeComposition()
{
  MOZ_ASSERT(CompositorThreadHolder::IsInCompositorThread(),
             "ResumeComposition() can only be called on the compositor thread");

  MonitorAutoLock lock(mResumeCompositionMonitor);

  if (!mCompositor->Resume()) {
#ifdef MOZ_WIDGET_ANDROID
    // We can't get a surface. This could be because the activity changed between
    // the time resume was scheduled and now.
    __android_log_print(ANDROID_LOG_INFO, "CompositorBridgeParent", "Unable to renew compositor surface; remaining in paused state");
#endif
    lock.NotifyAll();
    return;
  }

  mPaused = false;

  Invalidate();
  mCompositorScheduler->ResumeComposition();

  // if anyone's waiting to make sure that composition really got resumed, tell them
  lock.NotifyAll();
}

void
CompositorBridgeParent::ForceComposition()
{
  // Cancel the orientation changed state to force composition
  mForceCompositionTask = nullptr;
  ScheduleRenderOnCompositorThread();
}

void
CompositorBridgeParent::CancelCurrentCompositeTask()
{
  mCompositorScheduler->CancelCurrentCompositeTask();
}

void
CompositorBridgeParent::SetEGLSurfaceSize(int width, int height)
{
  NS_ASSERTION(mUseExternalSurfaceSize, "Compositor created without UseExternalSurfaceSize provided");
  mEGLSurfaceSize.SizeTo(width, height);
  if (mCompositor) {
    mCompositor->SetDestinationSurfaceSize(gfx::IntSize(mEGLSurfaceSize.width, mEGLSurfaceSize.height));
  }
}

void
CompositorBridgeParent::ResumeCompositionAndResize(int width, int height)
{
  SetEGLSurfaceSize(width, height);
  ResumeComposition();
}

/*
 * This will execute a pause synchronously, waiting to make sure that the compositor
 * really is paused.
 */
void
CompositorBridgeParent::SchedulePauseOnCompositorThread()
{
  MonitorAutoLock lock(mPauseCompositionMonitor);

  MOZ_ASSERT(CompositorLoop());
  CompositorLoop()->PostTask(NewRunnableMethod(this, &CompositorBridgeParent::PauseComposition));

  // Wait until the pause has actually been processed by the compositor thread
  lock.Wait();
}

bool
CompositorBridgeParent::ScheduleResumeOnCompositorThread()
{
  MonitorAutoLock lock(mResumeCompositionMonitor);

  MOZ_ASSERT(CompositorLoop());
  CompositorLoop()->PostTask(NewRunnableMethod(this, &CompositorBridgeParent::ResumeComposition));

  // Wait until the resume has actually been processed by the compositor thread
  lock.Wait();

  return !mPaused;
}

bool
CompositorBridgeParent::ScheduleResumeOnCompositorThread(int width, int height)
{
  MonitorAutoLock lock(mResumeCompositionMonitor);

  MOZ_ASSERT(CompositorLoop());
  CompositorLoop()->PostTask(NewRunnableMethod
                             <int, int>(this,
                                        &CompositorBridgeParent::ResumeCompositionAndResize,
                                        width, height));

  // Wait until the resume has actually been processed by the compositor thread
  lock.Wait();

  return !mPaused;
}

void
CompositorBridgeParent::ScheduleTask(already_AddRefed<CancelableRunnable> task, int time)
{
  if (time == 0) {
    MessageLoop::current()->PostTask(Move(task));
  } else {
    MessageLoop::current()->PostDelayedTask(Move(task), time);
  }
}

void
CompositorBridgeParent::UpdatePaintTime(LayerTransactionParent* aLayerTree,
                                        const TimeDuration& aPaintTime)
{
  // We get a lot of paint timings for things with empty transactions.
  if (!mLayerManager || aPaintTime.ToMilliseconds() < 1.0) {
    return;
  }

  mLayerManager->SetPaintTime(aPaintTime);
}

void
CompositorBridgeParent::NotifyShadowTreeTransaction(uint64_t aId, bool aIsFirstPaint,
    bool aScheduleComposite, uint32_t aPaintSequenceNumber,
    bool aIsRepeatTransaction, bool aHitTestUpdate)
{
  if (!aIsRepeatTransaction &&
      mLayerManager &&
      mLayerManager->GetRoot()) {
    // Process plugin data here to give time for them to update before the next
    // composition.
    bool pluginsUpdatedFlag = true;
    AutoResolveRefLayers resolve(mCompositionManager, this, nullptr,
                                 &pluginsUpdatedFlag);

#if defined(XP_WIN) || defined(MOZ_WIDGET_GTK)
    // If plugins haven't been updated, stop waiting.
    if (!pluginsUpdatedFlag) {
      mWaitForPluginsUntil = TimeStamp();
      mHaveBlockedForPlugins = false;
    }
#endif

    if (mApzcTreeManager && aHitTestUpdate) {
      mApzcTreeManager->UpdateHitTestingTree(mRootLayerTreeID,
          mLayerManager->GetRoot(), aIsFirstPaint, aId, aPaintSequenceNumber);
    }

    mLayerManager->NotifyShadowTreeTransaction();
  }
  if (aScheduleComposite) {
    ScheduleComposition();
  }
}

void
CompositorBridgeParent::ScheduleComposition()
{
  MOZ_ASSERT(CompositorThreadHolder::IsInCompositorThread());
  if (mPaused) {
    return;
  }

  mCompositorScheduler->ScheduleComposition();
}

// Go down the composite layer tree, setting properties to match their
// content-side counterparts.
/* static */ void
CompositorBridgeParent::SetShadowProperties(Layer* aLayer)
{
  ForEachNode<ForwardIterator>(
      aLayer,
      [] (Layer *layer)
      {
        if (Layer* maskLayer = layer->GetMaskLayer()) {
          SetShadowProperties(maskLayer);
        }
        for (size_t i = 0; i < layer->GetAncestorMaskLayerCount(); i++) {
          SetShadowProperties(layer->GetAncestorMaskLayerAt(i));
        }

        // FIXME: Bug 717688 -- Do these updates in LayerTransactionParent::RecvUpdate.
        LayerComposite* layerComposite = layer->AsLayerComposite();
        // Set the layerComposite's base transform to the layer's base transform.
        layerComposite->SetShadowBaseTransform(layer->GetBaseTransform());
        layerComposite->SetShadowTransformSetByAnimation(false);
        layerComposite->SetShadowVisibleRegion(layer->GetVisibleRegion());
        layerComposite->SetShadowClipRect(layer->GetClipRect());
        layerComposite->SetShadowOpacity(layer->GetOpacity());
        layerComposite->SetShadowOpacitySetByAnimation(false);
      }
    );
}

void
CompositorBridgeParent::CompositeToTarget(DrawTarget* aTarget, const gfx::IntRect* aRect)
{
  profiler_tracing("Paint", "Composite", TRACING_INTERVAL_START);
  PROFILER_LABEL("CompositorBridgeParent", "Composite",
    js::ProfileEntry::Category::GRAPHICS);

  MOZ_ASSERT(CompositorThreadHolder::IsInCompositorThread(),
             "Composite can only be called on the compositor thread");
  TimeStamp start = TimeStamp::Now();

#ifdef COMPOSITOR_PERFORMANCE_WARNING
  TimeDuration scheduleDelta = TimeStamp::Now() - mCompositorScheduler->GetExpectedComposeStartTime();
  if (scheduleDelta > TimeDuration::FromMilliseconds(2) ||
      scheduleDelta < TimeDuration::FromMilliseconds(-2)) {
    printf_stderr("Compositor: Compose starting off schedule by %4.1f ms\n",
                  scheduleDelta.ToMilliseconds());
  }
#endif

  if (!CanComposite()) {
    TimeStamp end = TimeStamp::Now();
    DidComposite(start, end);
    return;
  }

#if defined(XP_WIN) || defined(MOZ_WIDGET_GTK)
  if (!mWaitForPluginsUntil.IsNull() &&
      mWaitForPluginsUntil > start) {
    mHaveBlockedForPlugins = true;
    ScheduleComposition();
    return;
  }
#endif

  /*
   * AutoResolveRefLayers handles two tasks related to Windows and Linux
   * plugin window management:
   * 1) calculating if we have remote content in the view. If we do not have
   * remote content, all plugin windows for this CompositorBridgeParent (window)
   * can be hidden since we do not support plugins in chrome when running
   * under e10s.
   * 2) Updating plugin position, size, and clip. We do this here while the
   * remote layer tree is hooked up to to chrome layer tree. This is needed
   * since plugin clipping can depend on chrome (for example, due to tab modal
   * prompts). Updates in step 2 are applied via an async ipc message sent
   * to the main thread.
   */
  bool hasRemoteContent = false;
  bool updatePluginsFlag = true;
  AutoResolveRefLayers resolve(mCompositionManager, this,
                               &hasRemoteContent,
                               &updatePluginsFlag);

#if defined(XP_WIN) || defined(MOZ_WIDGET_GTK)
  // We do not support plugins in local content. When switching tabs
  // to local pages, hide every plugin associated with the window.
  if (!hasRemoteContent && gfxVars::BrowserTabsRemoteAutostart() &&
      mCachedPluginData.Length()) {
    Unused << SendHideAllPlugins(GetWidget()->GetWidgetKey());
    mCachedPluginData.Clear();
  }
#endif

  if (aTarget) {
    mLayerManager->BeginTransactionWithDrawTarget(aTarget, *aRect);
  } else {
    mLayerManager->BeginTransaction();
  }

  SetShadowProperties(mLayerManager->GetRoot());

  if (mForceCompositionTask && !mOverrideComposeReadiness) {
    if (mCompositionManager->ReadyForCompose()) {
      mForceCompositionTask->Cancel();
      mForceCompositionTask = nullptr;
    } else {
      return;
    }
  }

  mCompositionManager->ComputeRotation();

  TimeStamp time = mIsTesting ? mTestTime : mCompositorScheduler->GetLastComposeTime();
  bool requestNextFrame = mCompositionManager->TransformShadowTree(time, mVsyncRate);
  if (requestNextFrame) {
    ScheduleComposition();
#if defined(XP_WIN) || defined(MOZ_WIDGET_GTK)
    // If we have visible windowed plugins then we need to wait for content (and
    // then the plugins) to have been updated by the active animation.
    if (!mPluginWindowsHidden && mCachedPluginData.Length()) {
      mWaitForPluginsUntil = mCompositorScheduler->GetLastComposeTime() + (mVsyncRate * 2);
    }
#endif
  }

  RenderTraceLayers(mLayerManager->GetRoot(), "0000");

#ifdef MOZ_DUMP_PAINTING
  if (gfxPrefs::DumpHostLayers()) {
    printf_stderr("Painting --- compositing layer tree:\n");
    mLayerManager->Dump(/* aSorted = */ true);
  }
#endif
  mLayerManager->SetDebugOverlayWantsNextFrame(false);
  mLayerManager->EndTransaction(time);

  if (!aTarget) {
    TimeStamp end = TimeStamp::Now();
    DidComposite(start, end);
  }

  // We're not really taking advantage of the stored composite-again-time here.
  // We might be able to skip the next few composites altogether. However,
  // that's a bit complex to implement and we'll get most of the advantage
  // by skipping compositing when we detect there's nothing invalid. This is why
  // we do "composite until" rather than "composite again at".
  if (!mCompositor->GetCompositeUntilTime().IsNull() ||
      mLayerManager->DebugOverlayWantsNextFrame()) {
    ScheduleComposition();
  }

#ifdef COMPOSITOR_PERFORMANCE_WARNING
  TimeDuration executionTime = TimeStamp::Now() - mCompositorScheduler->GetLastComposeTime();
  TimeDuration frameBudget = TimeDuration::FromMilliseconds(15);
  int32_t frameRate = CalculateCompositionFrameRate();
  if (frameRate > 0) {
    frameBudget = TimeDuration::FromSeconds(1.0 / frameRate);
  }
  if (executionTime > frameBudget) {
    printf_stderr("Compositor: Composite execution took %4.1f ms\n",
                  executionTime.ToMilliseconds());
  }
#endif

  // 0 -> Full-tilt composite
  if (gfxPrefs::LayersCompositionFrameRate() == 0
    || mLayerManager->GetCompositor()->GetDiagnosticTypes() & DiagnosticTypes::FLASH_BORDERS) {
    // Special full-tilt composite mode for performance testing
    ScheduleComposition();
  }
  mCompositor->SetCompositionTime(TimeStamp());

  mozilla::Telemetry::AccumulateTimeDelta(mozilla::Telemetry::COMPOSITE_TIME, start);
  profiler_tracing("Paint", "Composite", TRACING_INTERVAL_END);
}

bool
CompositorBridgeParent::RecvRemotePluginsReady()
{
#if defined(XP_WIN) || defined(MOZ_WIDGET_GTK)
  mWaitForPluginsUntil = TimeStamp();
  if (mHaveBlockedForPlugins) {
    mHaveBlockedForPlugins = false;
    ForceComposeToTarget(nullptr);
  } else {
    ScheduleComposition();
  }
  return true;
#else
  NS_NOTREACHED("CompositorBridgeParent::RecvRemotePluginsReady calls "
                "unexpected on this platform.");
  return false;
#endif
}

void
CompositorBridgeParent::ForceComposeToTarget(DrawTarget* aTarget, const gfx::IntRect* aRect)
{
  PROFILER_LABEL("CompositorBridgeParent", "ForceComposeToTarget",
    js::ProfileEntry::Category::GRAPHICS);

  AutoRestore<bool> override(mOverrideComposeReadiness);
  mOverrideComposeReadiness = true;
  mCompositorScheduler->ForceComposeToTarget(aTarget, aRect);
}

PAPZCTreeManagerParent*
CompositorBridgeParent::AllocPAPZCTreeManagerParent(const uint64_t& aLayersId)
{
  // The main process should pass in 0 because we assume mRootLayerTreeID
  MOZ_ASSERT(aLayersId == 0);

  // This message doubles as initialization
  MOZ_ASSERT(!mApzcTreeManager);
  mApzcTreeManager = new APZCTreeManager();

  MonitorAutoLock lock(*sIndirectLayerTreesLock);
  CompositorBridgeParent::LayerTreeState& state = sIndirectLayerTrees[mRootLayerTreeID];
  MOZ_ASSERT(state.mParent);
  MOZ_ASSERT(!state.mApzcTreeManagerParent);
  state.mApzcTreeManagerParent = new APZCTreeManagerParent(mRootLayerTreeID, state.mParent->GetAPZCTreeManager());

  return state.mApzcTreeManagerParent;
}

bool
CompositorBridgeParent::DeallocPAPZCTreeManagerParent(PAPZCTreeManagerParent* aActor)
{
  delete aActor;
  return true;
}

PAPZParent*
CompositorBridgeParent::AllocPAPZParent(const uint64_t& aLayersId)
{
  // The main process should pass in 0 because we assume mRootLayerTreeID
  MOZ_ASSERT(aLayersId == 0);

  RemoteContentController* controller = new RemoteContentController();

  // Increment the controller's refcount before we return it. This will keep the
  // controller alive until it is released by IPDL in DeallocPAPZParent.
  controller->AddRef();

  MonitorAutoLock lock(*sIndirectLayerTreesLock);
  CompositorBridgeParent::LayerTreeState& state = sIndirectLayerTrees[mRootLayerTreeID];
  MOZ_ASSERT(!state.mController);
  state.mController = controller;

  return controller;
}

bool
CompositorBridgeParent::DeallocPAPZParent(PAPZParent* aActor)
{
  RemoteContentController* controller = static_cast<RemoteContentController*>(aActor);
  controller->Release();
  return true;
}

bool
CompositorBridgeParent::RecvAsyncPanZoomEnabled(const uint64_t& aLayersId, bool* aHasAPZ)
{
  // The main process should pass in 0 because we assume mRootLayerTreeID
  MOZ_ASSERT(aLayersId == 0);
  *aHasAPZ = AsyncPanZoomEnabled();
  return true;
}

RefPtr<APZCTreeManager>
CompositorBridgeParent::GetAPZCTreeManager()
{
  return mApzcTreeManager;
}

bool
CompositorBridgeParent::CanComposite()
{
  return mLayerManager &&
         mLayerManager->GetRoot() &&
         !mPaused;
}

void
CompositorBridgeParent::ScheduleRotationOnCompositorThread(const TargetConfig& aTargetConfig,
                                                     bool aIsFirstPaint)
{
  MOZ_ASSERT(CompositorThreadHolder::IsInCompositorThread());

  if (!aIsFirstPaint &&
      !mCompositionManager->IsFirstPaint() &&
      mCompositionManager->RequiresReorientation(aTargetConfig.orientation())) {
    if (mForceCompositionTask != nullptr) {
      mForceCompositionTask->Cancel();
    }
    RefPtr<CancelableRunnable> task =
      NewCancelableRunnableMethod(this, &CompositorBridgeParent::ForceComposition);
    mForceCompositionTask = task;
    ScheduleTask(task.forget(), gfxPrefs::OrientationSyncMillis());
  }
}

void
CompositorBridgeParent::ShadowLayersUpdated(LayerTransactionParent* aLayerTree,
                                            const uint64_t& aTransactionId,
                                            const TargetConfig& aTargetConfig,
                                            const InfallibleTArray<PluginWindowData>& aUnused,
                                            bool aIsFirstPaint,
                                            bool aScheduleComposite,
                                            uint32_t aPaintSequenceNumber,
                                            bool aIsRepeatTransaction,
                                            int32_t aPaintSyncId,
                                            bool aHitTestUpdate)
{
  ScheduleRotationOnCompositorThread(aTargetConfig, aIsFirstPaint);

  // Instruct the LayerManager to update its render bounds now. Since all the orientation
  // change, dimension change would be done at the stage, update the size here is free of
  // race condition.
  mLayerManager->UpdateRenderBounds(aTargetConfig.naturalBounds());
  mLayerManager->SetRegionToClear(aTargetConfig.clearRegion());
  mLayerManager->GetCompositor()->SetScreenRotation(aTargetConfig.rotation());

  mCompositionManager->Updated(aIsFirstPaint, aTargetConfig, aPaintSyncId);
  Layer* root = aLayerTree->GetRoot();
  mLayerManager->SetRoot(root);

  if (mApzcTreeManager && !aIsRepeatTransaction && aHitTestUpdate) {
    AutoResolveRefLayers resolve(mCompositionManager);

    mApzcTreeManager->UpdateHitTestingTree(mRootLayerTreeID, root, aIsFirstPaint,
        mRootLayerTreeID, aPaintSequenceNumber);
  }

  // The transaction ID might get reset to 1 if the page gets reloaded, see
  // https://bugzilla.mozilla.org/show_bug.cgi?id=1145295#c41
  // Otherwise, it should be continually increasing.
  MOZ_ASSERT(aTransactionId == 1 || aTransactionId > mPendingTransaction);
  mPendingTransaction = aTransactionId;

  if (root) {
    SetShadowProperties(root);
  }
  if (aScheduleComposite) {
    ScheduleComposition();
    if (mPaused) {
      TimeStamp now = TimeStamp::Now();
      DidComposite(now, now);
    }
  }
  mLayerManager->NotifyShadowTreeTransaction();
}

void
CompositorBridgeParent::ForceComposite(LayerTransactionParent* aLayerTree)
{
  ScheduleComposition();
}

bool
CompositorBridgeParent::SetTestSampleTime(LayerTransactionParent* aLayerTree,
                                          const TimeStamp& aTime)
{
  if (aTime.IsNull()) {
    return false;
  }

  mIsTesting = true;
  mTestTime = aTime;

  bool testComposite = mCompositionManager &&
                       mCompositorScheduler->NeedsComposite();

  // Update but only if we were already scheduled to animate
  if (testComposite) {
    AutoResolveRefLayers resolve(mCompositionManager);
    bool requestNextFrame = mCompositionManager->TransformShadowTree(aTime, mVsyncRate);
    if (!requestNextFrame) {
      CancelCurrentCompositeTask();
      // Pretend we composited in case someone is wating for this event.
      TimeStamp now = TimeStamp::Now();
      DidComposite(now, now);
    }
  }

  return true;
}

void
CompositorBridgeParent::LeaveTestMode(LayerTransactionParent* aLayerTree)
{
  mIsTesting = false;
}

void
CompositorBridgeParent::ApplyAsyncProperties(LayerTransactionParent* aLayerTree)
{
  // NOTE: This should only be used for testing. For example, when mIsTesting is
  // true or when called from test-only methods like
  // LayerTransactionParent::RecvGetAnimationTransform.

  // Synchronously update the layer tree
  if (aLayerTree->GetRoot()) {
    AutoResolveRefLayers resolve(mCompositionManager);
    SetShadowProperties(mLayerManager->GetRoot());

    TimeStamp time = mIsTesting ? mTestTime : mCompositorScheduler->GetLastComposeTime();
    bool requestNextFrame =
      mCompositionManager->TransformShadowTree(time, mVsyncRate,
        AsyncCompositionManager::TransformsToSkip::APZ);
    if (!requestNextFrame) {
      CancelCurrentCompositeTask();
      // Pretend we composited in case someone is waiting for this event.
      TimeStamp now = TimeStamp::Now();
      DidComposite(now, now);
    }
  }
}

bool
CompositorBridgeParent::RecvGetFrameUniformity(FrameUniformityData* aOutData)
{
  mCompositionManager->GetFrameUniformity(aOutData);
  return true;
}

bool
CompositorBridgeParent::RecvRequestOverfill()
{
  uint32_t overfillRatio = mCompositor->GetFillRatio();
  Unused << SendOverfill(overfillRatio);
  return true;
}

void
CompositorBridgeParent::FlushApzRepaints(const LayerTransactionParent* aLayerTree)
{
  MOZ_ASSERT(mApzcTreeManager);
  uint64_t layersId = aLayerTree->GetId();
  if (layersId == 0) {
    // The request is coming from the parent-process layer tree, so we should
    // use the compositor's root layer tree id.
    layersId = mRootLayerTreeID;
  }
  RefPtr<CompositorBridgeParent> self = this;
  APZThreadUtils::RunOnControllerThread(NS_NewRunnableFunction([=] () {
    self->mApzcTreeManager->FlushApzRepaints(layersId);
  }));
}

void
CompositorBridgeParent::GetAPZTestData(const LayerTransactionParent* aLayerTree,
                                       APZTestData* aOutData)
{
  MonitorAutoLock lock(*sIndirectLayerTreesLock);
  *aOutData = sIndirectLayerTrees[mRootLayerTreeID].mApzTestData;
}

void
CompositorBridgeParent::SetConfirmedTargetAPZC(const LayerTransactionParent* aLayerTree,
                                         const uint64_t& aInputBlockId,
                                         const nsTArray<ScrollableLayerGuid>& aTargets)
{
  if (!mApzcTreeManager) {
    return;
  }
  // Need to specifically bind this since it's overloaded.
  void (APZCTreeManager::*setTargetApzcFunc)
        (uint64_t, const nsTArray<ScrollableLayerGuid>&) =
        &APZCTreeManager::SetTargetAPZC;
  RefPtr<Runnable> task = NewRunnableMethod
        <uint64_t, StoreCopyPassByConstLRef<nsTArray<ScrollableLayerGuid>>>
        (mApzcTreeManager.get(), setTargetApzcFunc, aInputBlockId, aTargets);
  APZThreadUtils::RunOnControllerThread(task.forget());

}

void
CompositorBridgeParent::InitializeLayerManager(const nsTArray<LayersBackend>& aBackendHints)
{
  NS_ASSERTION(!mLayerManager, "Already initialised mLayerManager");
  NS_ASSERTION(!mCompositor,   "Already initialised mCompositor");

  mCompositor = NewCompositor(aBackendHints);
  if (!mCompositor) {
    return;
  }

  mLayerManager = new LayerManagerComposite(mCompositor);

  MonitorAutoLock lock(*sIndirectLayerTreesLock);
  sIndirectLayerTrees[mRootLayerTreeID].mLayerManager = mLayerManager;
}

RefPtr<Compositor>
CompositorBridgeParent::NewCompositor(const nsTArray<LayersBackend>& aBackendHints)
{
  for (size_t i = 0; i < aBackendHints.Length(); ++i) {
    RefPtr<Compositor> compositor;
    if (aBackendHints[i] == LayersBackend::LAYERS_OPENGL) {
      compositor = new CompositorOGL(this,
                                     mWidget,
                                     mEGLSurfaceSize.width,
                                     mEGLSurfaceSize.height,
                                     mUseExternalSurfaceSize);
    } else if (aBackendHints[i] == LayersBackend::LAYERS_BASIC) {
#ifdef MOZ_WIDGET_GTK
      if (gfxVars::UseXRender()) {
        compositor = new X11BasicCompositor(this, mWidget);
      } else
#endif
      {
        compositor = new BasicCompositor(this, mWidget);
      }
#ifdef XP_WIN
    } else if (aBackendHints[i] == LayersBackend::LAYERS_D3D11) {
      compositor = new CompositorD3D11(this, mWidget);
    } else if (aBackendHints[i] == LayersBackend::LAYERS_D3D9) {
      compositor = new CompositorD3D9(this, mWidget);
#endif
    }
    nsCString failureReason;
    if (compositor && compositor->Initialize(&failureReason)) {
      if (failureReason.IsEmpty()){
        failureReason = "SUCCESS";
      }

      // should only report success here
      if (aBackendHints[i] == LayersBackend::LAYERS_OPENGL){
        Telemetry::Accumulate(Telemetry::OPENGL_COMPOSITING_FAILURE_ID, failureReason);
      }
#ifdef XP_WIN
      else if (aBackendHints[i] == LayersBackend::LAYERS_D3D9){
        Telemetry::Accumulate(Telemetry::D3D9_COMPOSITING_FAILURE_ID, failureReason);
      }
      else if (aBackendHints[i] == LayersBackend::LAYERS_D3D11){
        Telemetry::Accumulate(Telemetry::D3D11_COMPOSITING_FAILURE_ID, failureReason);
      }
#endif

      compositor->SetCompositorID(mCompositorID);
      return compositor;
    }

    // report any failure reasons here
    if (aBackendHints[i] == LayersBackend::LAYERS_OPENGL){
      gfxCriticalNote << "[OPENGL] Failed to init compositor with reason: "
                      << failureReason.get();
      Telemetry::Accumulate(Telemetry::OPENGL_COMPOSITING_FAILURE_ID, failureReason);
    }
#ifdef XP_WIN
    else if (aBackendHints[i] == LayersBackend::LAYERS_D3D9){
      gfxCriticalNote << "[D3D9] Failed to init compositor with reason: "
                      << failureReason.get();
      Telemetry::Accumulate(Telemetry::D3D9_COMPOSITING_FAILURE_ID, failureReason);
    }
    else if (aBackendHints[i] == LayersBackend::LAYERS_D3D11){
      gfxCriticalNote << "[D3D11] Failed to init compositor with reason: "
                      << failureReason.get();
      Telemetry::Accumulate(Telemetry::D3D11_COMPOSITING_FAILURE_ID, failureReason);
    }
#endif
  }

  return nullptr;
}

PLayerTransactionParent*
CompositorBridgeParent::AllocPLayerTransactionParent(const nsTArray<LayersBackend>& aBackendHints,
                                                     const uint64_t& aId,
                                                     TextureFactoryIdentifier* aTextureFactoryIdentifier,
                                               bool *aSuccess)
{
  MOZ_ASSERT(aId == 0);

  InitializeLayerManager(aBackendHints);

  if (!mLayerManager) {
    NS_WARNING("Failed to initialise Compositor");
    *aSuccess = false;
    LayerTransactionParent* p = new LayerTransactionParent(nullptr, this, 0);
    p->AddIPDLReference();
    return p;
  }

  mCompositionManager = new AsyncCompositionManager(mLayerManager);
  *aSuccess = true;

  *aTextureFactoryIdentifier = mCompositor->GetTextureFactoryIdentifier();
  LayerTransactionParent* p = new LayerTransactionParent(mLayerManager, this, 0);
  p->AddIPDLReference();
  return p;
}

bool
CompositorBridgeParent::DeallocPLayerTransactionParent(PLayerTransactionParent* actor)
{
  static_cast<LayerTransactionParent*>(actor)->ReleaseIPDLReference();
  return true;
}

CompositorBridgeParent* CompositorBridgeParent::GetCompositorBridgeParent(uint64_t id)
{
  CompositorMap::iterator it = sCompositorMap->find(id);
  return it != sCompositorMap->end() ? it->second : nullptr;
}

void CompositorBridgeParent::AddCompositor(CompositorBridgeParent* compositor, uint64_t* outID)
{
  static uint64_t sNextID = 1;

  ++sNextID;
  (*sCompositorMap)[sNextID] = compositor;
  *outID = sNextID;
}

CompositorBridgeParent* CompositorBridgeParent::RemoveCompositor(uint64_t id)
{
  CompositorMap::iterator it = sCompositorMap->find(id);
  if (it == sCompositorMap->end()) {
    return nullptr;
  }
  CompositorBridgeParent *retval = it->second;
  sCompositorMap->erase(it);
  return retval;
}

void
CompositorBridgeParent::NotifyVsync(const TimeStamp& aTimeStamp, const uint64_t& aLayersId)
{
  MOZ_ASSERT(XRE_GetProcessType() == GeckoProcessType_GPU);
  MOZ_ASSERT(CompositorThreadHolder::IsInCompositorThread());

  MonitorAutoLock lock(*sIndirectLayerTreesLock);
  auto it = sIndirectLayerTrees.find(aLayersId);
  if (it == sIndirectLayerTrees.end())
    return;

  CompositorBridgeParent* cbp = it->second.mParent;
  if (!cbp || !cbp->mWidget)
    return;

  RefPtr<VsyncObserver> obs = cbp->mWidget->GetVsyncObserver();
  if (!obs)
    return;

  obs->NotifyVsync(aTimeStamp);
}

bool
CompositorBridgeParent::RecvNotifyChildCreated(const uint64_t& child)
{
  MonitorAutoLock lock(*sIndirectLayerTreesLock);
  NotifyChildCreated(child);
  return true;
}

bool
CompositorBridgeParent::RecvNotifyChildRecreated(const uint64_t& aChild)
{
  MonitorAutoLock lock(*sIndirectLayerTreesLock);

  if (sIndirectLayerTrees.find(aChild) != sIndirectLayerTrees.end()) {
    // Invalid to register the same layer tree twice.
    return false;
  }

  NotifyChildCreated(aChild);
  return true;
}

void
CompositorBridgeParent::NotifyChildCreated(uint64_t aChild)
{
  sIndirectLayerTreesLock->AssertCurrentThreadOwns();
  sIndirectLayerTrees[aChild].mParent = this;
  sIndirectLayerTrees[aChild].mLayerManager = mLayerManager;
}

bool
CompositorBridgeParent::RecvAdoptChild(const uint64_t& child)
{
  APZCTreeManagerParent* parent;
  {
    MonitorAutoLock lock(*sIndirectLayerTreesLock);
    NotifyChildCreated(child);
    if (sIndirectLayerTrees[child].mLayerTree) {
      sIndirectLayerTrees[child].mLayerTree->SetLayerManager(mLayerManager);
    }
    parent = sIndirectLayerTrees[child].mApzcTreeManagerParent;
  }

  if (mApzcTreeManager && parent) {
    parent->ChildAdopted(mApzcTreeManager);
  }
  return true;
}

static void
EraseLayerState(uint64_t aId)
{
  MonitorAutoLock lock(*sIndirectLayerTreesLock);

  auto iter = sIndirectLayerTrees.find(aId);
  if (iter != sIndirectLayerTrees.end()) {
    CompositorBridgeParent* parent = iter->second.mParent;
    if (parent) {
      parent->ClearApproximatelyVisibleRegions(aId, Nothing());
    }

    sIndirectLayerTrees.erase(iter);
  }
}

/*static*/ void
CompositorBridgeParent::DeallocateLayerTreeId(uint64_t aId)
{
  MOZ_ASSERT(NS_IsMainThread());
  // Here main thread notifies compositor to remove an element from
  // sIndirectLayerTrees. This removed element might be queried soon.
  // Checking the elements of sIndirectLayerTrees exist or not before using.
  if (!CompositorLoop()) {
    gfxCriticalError() << "Attempting to post to a invalid Compositor Loop";
    return;
  }
  CompositorLoop()->PostTask(NewRunnableFunction(&EraseLayerState, aId));
}

static void
UpdateControllerForLayersId(uint64_t aLayersId,
                            GeckoContentController* aController)
{
  // Adopt ref given to us by SetControllerForLayerTree()
  MonitorAutoLock lock(*sIndirectLayerTreesLock);
  sIndirectLayerTrees[aLayersId].mController =
    already_AddRefed<GeckoContentController>(aController);
}

ScopedLayerTreeRegistration::ScopedLayerTreeRegistration(APZCTreeManager* aApzctm,
                                                         uint64_t aLayersId,
                                                         Layer* aRoot,
                                                         GeckoContentController* aController)
    : mLayersId(aLayersId)
{
  EnsureLayerTreeMapReady();
  MonitorAutoLock lock(*sIndirectLayerTreesLock);
  sIndirectLayerTrees[aLayersId].mRoot = aRoot;
  sIndirectLayerTrees[aLayersId].mController = aController;
}

ScopedLayerTreeRegistration::~ScopedLayerTreeRegistration()
{
  MonitorAutoLock lock(*sIndirectLayerTreesLock);
  sIndirectLayerTrees.erase(mLayersId);
}

/*static*/ void
CompositorBridgeParent::SetControllerForLayerTree(uint64_t aLayersId,
                                                  GeckoContentController* aController)
{
  // This ref is adopted by UpdateControllerForLayersId().
  aController->AddRef();
  CompositorLoop()->PostTask(NewRunnableFunction(&UpdateControllerForLayersId,
                                                 aLayersId,
                                                 aController));
}

/*static*/ already_AddRefed<APZCTreeManager>
CompositorBridgeParent::GetAPZCTreeManager(uint64_t aLayersId)
{
  EnsureLayerTreeMapReady();
  MonitorAutoLock lock(*sIndirectLayerTreesLock);
  LayerTreeMap::iterator cit = sIndirectLayerTrees.find(aLayersId);
  if (sIndirectLayerTrees.end() == cit) {
    return nullptr;
  }
  LayerTreeState* lts = &cit->second;

  RefPtr<APZCTreeManager> apzctm = lts->mParent
                                   ? lts->mParent->mApzcTreeManager.get()
                                   : nullptr;
  return apzctm.forget();
}

static void
InsertVsyncProfilerMarker(TimeStamp aVsyncTimestamp)
{
#ifdef MOZ_ENABLE_PROFILER_SPS
  MOZ_ASSERT(CompositorThreadHolder::IsInCompositorThread());
  VsyncPayload* payload = new VsyncPayload(aVsyncTimestamp);
  PROFILER_MARKER_PAYLOAD("VsyncTimestamp", payload);
#endif
}

/*static */ void
CompositorBridgeParent::PostInsertVsyncProfilerMarker(TimeStamp aVsyncTimestamp)
{
  // Called in the vsync thread
  if (profiler_is_active() && CompositorThreadHolder::IsActive()) {
    CompositorLoop()->PostTask(
      NewRunnableFunction(InsertVsyncProfilerMarker, aVsyncTimestamp));
  }
}

widget::PCompositorWidgetParent*
CompositorBridgeParent::AllocPCompositorWidgetParent(const CompositorWidgetInitData& aInitData)
{
#if defined(MOZ_WIDGET_SUPPORTS_OOP_COMPOSITING)
  if (mWidget) {
    // Should not create two widgets on the same compositor.
    return nullptr;
  }

  widget::CompositorWidgetParent* widget =
    new widget::CompositorWidgetParent(aInitData);
  widget->AddRef();

  // Sending the constructor acts as initialization as well.
  mWidget = widget;
  return widget;
#else
  return nullptr;
#endif
}

bool
CompositorBridgeParent::DeallocPCompositorWidgetParent(PCompositorWidgetParent* aActor)
{
#if defined(MOZ_WIDGET_SUPPORTS_OOP_COMPOSITING)
  static_cast<widget::CompositorWidgetParent*>(aActor)->Release();
  return true;
#else
  return false;
#endif
}

bool
CompositorBridgeParent::IsPendingComposite()
{
  MOZ_ASSERT(CompositorThreadHolder::IsInCompositorThread());
  if (!mCompositor) {
    return false;
  }
  return mCompositor->IsPendingComposite();
}

void
CompositorBridgeParent::FinishPendingComposite()
{
  MOZ_ASSERT(CompositorThreadHolder::IsInCompositorThread());
  if (!mCompositor) {
    return;
  }
  return mCompositor->FinishPendingComposite();
}

CompositorController*
CompositorBridgeParent::LayerTreeState::GetCompositorController() const
{
  return mParent;
}

MetricsSharingController*
CompositorBridgeParent::LayerTreeState::CrossProcessSharingController() const
{
  return mCrossProcessParent;
}

MetricsSharingController*
CompositorBridgeParent::LayerTreeState::InProcessSharingController() const
{
  return mParent;
}

void
CompositorBridgeParent::DidComposite(TimeStamp& aCompositeStart,
                                     TimeStamp& aCompositeEnd)
{
  Unused << SendDidComposite(0, mPendingTransaction, aCompositeStart, aCompositeEnd);
  mPendingTransaction = 0;

  if (mLayerManager) {
    nsTArray<ImageCompositeNotification> notifications;
    mLayerManager->ExtractImageCompositeNotifications(&notifications);
    if (!notifications.IsEmpty()) {
      Unused << ImageBridgeParent::NotifyImageComposites(notifications);
    }
  }

  MonitorAutoLock lock(*sIndirectLayerTreesLock);
  ForEachIndirectLayerTree([&] (LayerTreeState* lts, const uint64_t& aLayersId) -> void {
    if (lts->mCrossProcessParent) {
      CrossProcessCompositorBridgeParent* cpcp = lts->mCrossProcessParent;
      cpcp->DidComposite(aLayersId, aCompositeStart, aCompositeEnd);
    }
  });
}

void
CompositorBridgeParent::InvalidateRemoteLayers()
{
  MOZ_ASSERT(CompositorLoop() == MessageLoop::current());

  Unused << PCompositorBridgeParent::SendInvalidateLayers(0);

  MonitorAutoLock lock(*sIndirectLayerTreesLock);
  ForEachIndirectLayerTree([] (LayerTreeState* lts, const uint64_t& aLayersId) -> void {
    if (lts->mCrossProcessParent) {
      CrossProcessCompositorBridgeParent* cpcp = lts->mCrossProcessParent;
      Unused << cpcp->SendInvalidateLayers(aLayersId);
    }
  });
}

bool
CompositorBridgeParent::ResetCompositor(const nsTArray<LayersBackend>& aBackendHints,
                                        TextureFactoryIdentifier* aOutIdentifier)
{
  Maybe<TextureFactoryIdentifier> newIdentifier;
  {
    MonitorAutoLock lock(mResetCompositorMonitor);

    CompositorLoop()->PostTask(NewRunnableMethod
                               <StoreCopyPassByConstLRef<nsTArray<LayersBackend>>,
                                Maybe<TextureFactoryIdentifier>*>(this,
                                                                  &CompositorBridgeParent::ResetCompositorTask,
                                                                  aBackendHints,
                                                                  &newIdentifier));

    mResetCompositorMonitor.Wait();
  }

  if (!newIdentifier) {
    return false;
  }

  *aOutIdentifier = newIdentifier.value();
  return true;
}

// Invoked on the compositor thread. The main thread is waiting on the given
// monitor.
void
CompositorBridgeParent::ResetCompositorTask(const nsTArray<LayersBackend>& aBackendHints,
                                            Maybe<TextureFactoryIdentifier>* aOutNewIdentifier)
{
  // Perform the reset inside a lock, so the main thread can wake up as soon as
  // possible. We notify child processes (if necessary) outside the lock.
  Maybe<TextureFactoryIdentifier> newIdentifier;
  {
    MonitorAutoLock lock(mResetCompositorMonitor);

    newIdentifier = ResetCompositorImpl(aBackendHints);
    *aOutNewIdentifier = newIdentifier;

    mResetCompositorMonitor.NotifyAll();
  }

  // NOTE: |aBackendHints|, and |aOutNewIdentifier| are now all invalid since
  // they are allocated on ResetCompositor's stack on the main thread, which
  // is no longer waiting on the lock.

  if (!newIdentifier) {
    // No compositor change; nothing to do.
    return;
  }

  MonitorAutoLock lock(*sIndirectLayerTreesLock);
  ForEachIndirectLayerTree([&] (LayerTreeState* lts, uint64_t layersId) -> void {
    if (CrossProcessCompositorBridgeParent* cpcp = lts->mCrossProcessParent) {
      Unused << cpcp->SendCompositorUpdated(layersId, newIdentifier.value());

      if (LayerTransactionParent* ltp = lts->mLayerTree) {
        ltp->AddPendingCompositorUpdate();
      }
      lts->mPendingCompositorUpdates++;
    }
  });
}

Maybe<TextureFactoryIdentifier>
CompositorBridgeParent::ResetCompositorImpl(const nsTArray<LayersBackend>& aBackendHints)
{
  if (!mLayerManager) {
    return Nothing();
  }

  RefPtr<Compositor> compositor = NewCompositor(aBackendHints);
  if (!compositor) {
    MOZ_RELEASE_ASSERT(compositor, "Failed to reset compositor.");
  }

  // Don't bother changing from basic->basic.
  if (mCompositor &&
      mCompositor->GetBackendType() == LayersBackend::LAYERS_BASIC &&
      compositor->GetBackendType() == LayersBackend::LAYERS_BASIC)
  {
    return Nothing();
  }

  if (mCompositor) {
    mCompositor->SetInvalid();
  }
  mCompositor = compositor;
  mLayerManager->ChangeCompositor(compositor);

  return Some(compositor->GetTextureFactoryIdentifier());
}

static void
OpenCompositor(RefPtr<CrossProcessCompositorBridgeParent> aCompositor,
               Endpoint<PCompositorBridgeParent>&& aEndpoint)
{
  aCompositor->Bind(Move(aEndpoint));
}

/* static */ bool
CompositorBridgeParent::CreateForContent(Endpoint<PCompositorBridgeParent>&& aEndpoint)
{
  gfxPlatform::InitLayersIPC();

  RefPtr<CrossProcessCompositorBridgeParent> cpcp =
    new CrossProcessCompositorBridgeParent();

  CompositorLoop()->PostTask(NewRunnableFunction(OpenCompositor, cpcp, Move(aEndpoint)));
  return true;
}

static void
UpdateIndirectTree(uint64_t aId, Layer* aRoot, const TargetConfig& aTargetConfig)
{
  MonitorAutoLock lock(*sIndirectLayerTreesLock);
  sIndirectLayerTrees[aId].mRoot = aRoot;
  sIndirectLayerTrees[aId].mTargetConfig = aTargetConfig;
}

/* static */ CompositorBridgeParent::LayerTreeState*
CompositorBridgeParent::GetIndirectShadowTree(uint64_t aId)
{
  MonitorAutoLock lock(*sIndirectLayerTreesLock);
  LayerTreeMap::iterator cit = sIndirectLayerTrees.find(aId);
  if (sIndirectLayerTrees.end() == cit) {
    return nullptr;
  }
  return &cit->second;
}

static CompositorBridgeParent::LayerTreeState*
GetStateForRoot(uint64_t aContentLayersId, const MonitorAutoLock& aProofOfLock)
{
  CompositorBridgeParent::LayerTreeState* state = nullptr;
  LayerTreeMap::iterator itr = sIndirectLayerTrees.find(aContentLayersId);
  if (sIndirectLayerTrees.end() != itr) {
    state = &itr->second;
  }

  // |state| is the state for the content process, but we want the APZCTMParent
  // for the parent process owning that content process. So we have to jump to
  // the LayerTreeState for the root layer tree id for that layer tree, and use
  // the mApzcTreeManagerParent from that. This should also work with nested
  // content processes, because RootLayerTreeId() will bypass any intermediate
  // processes' ids and go straight to the root.
  if (state) {
    uint64_t rootLayersId = state->mParent->RootLayerTreeId();
    itr = sIndirectLayerTrees.find(rootLayersId);
    state = (sIndirectLayerTrees.end() != itr) ? &itr->second : nullptr;
  }

  return state;
}

/* static */ APZCTreeManagerParent*
CompositorBridgeParent::GetApzcTreeManagerParentForRoot(uint64_t aContentLayersId)
{
  MonitorAutoLock lock(*sIndirectLayerTreesLock);
  CompositorBridgeParent::LayerTreeState* state =
      GetStateForRoot(aContentLayersId, lock);
  return state ? state->mApzcTreeManagerParent : nullptr;
}

/* static */ GeckoContentController*
CompositorBridgeParent::GetGeckoContentControllerForRoot(uint64_t aContentLayersId)
{
  MonitorAutoLock lock(*sIndirectLayerTreesLock);
  CompositorBridgeParent::LayerTreeState* state =
      GetStateForRoot(aContentLayersId, lock);
  return state ? state->mController.get() : nullptr;
}

PTextureParent*
CompositorBridgeParent::AllocPTextureParent(const SurfaceDescriptor& aSharedData,
                                            const LayersBackend& aLayersBackend,
                                            const TextureFlags& aFlags,
                                            const uint64_t& aId,
                                            const uint64_t& aSerial)
{
  return TextureHost::CreateIPDLActor(this, aSharedData, aLayersBackend, aFlags, aSerial);
}

bool
CompositorBridgeParent::DeallocPTextureParent(PTextureParent* actor)
{
  return TextureHost::DestroyIPDLActor(actor);
}

bool
CompositorBridgeParent::IsSameProcess() const
{
  return OtherPid() == base::GetCurrentProcId();
}

#if defined(XP_WIN) || defined(MOZ_WIDGET_GTK)
//#define PLUGINS_LOG(...) printf_stderr("CP [%s]: ", __FUNCTION__);
//                         printf_stderr(__VA_ARGS__);
//                         printf_stderr("\n");
#define PLUGINS_LOG(...)

bool
CompositorBridgeParent::UpdatePluginWindowState(uint64_t aId)
{
  MonitorAutoLock lock(*sIndirectLayerTreesLock);
  CompositorBridgeParent::LayerTreeState& lts = sIndirectLayerTrees[aId];
  if (!lts.mParent) {
    PLUGINS_LOG("[%" PRIu64 "] layer tree compositor parent pointer is null", aId);
    return false;
  }

  // Check if this layer tree has received any shadow layer updates
  if (!lts.mUpdatedPluginDataAvailable) {
    PLUGINS_LOG("[%" PRIu64 "] no plugin data", aId);
    return false;
  }

  // pluginMetricsChanged tracks whether we need to send plugin update
  // data to the main thread. If we do we'll have to block composition,
  // which we want to avoid if at all possible.
  bool pluginMetricsChanged = false;

  // Same layer tree checks
  if (mLastPluginUpdateLayerTreeId == aId) {
    // no plugin data and nothing has changed, bail.
    if (!mCachedPluginData.Length() && !lts.mPluginData.Length()) {
      PLUGINS_LOG("[%" PRIu64 "] no data, no changes", aId);
      return false;
    }

    if (mCachedPluginData.Length() == lts.mPluginData.Length()) {
      // check for plugin data changes
      for (uint32_t idx = 0; idx < lts.mPluginData.Length(); idx++) {
        if (!(mCachedPluginData[idx] == lts.mPluginData[idx])) {
          pluginMetricsChanged = true;
          break;
        }
      }
    } else {
      // array lengths don't match, need to update
      pluginMetricsChanged = true;
    }
  } else {
    // exchanging layer trees, we need to update
    pluginMetricsChanged = true;
  }

  // Check if plugin windows are currently hidden due to scrolling
  if (mDeferPluginWindows) {
    PLUGINS_LOG("[%" PRIu64 "] suppressing", aId);
    return false;
  }

  // If the plugin windows were hidden but now are not, we need to force
  // update the metrics to make sure they are visible again.
  if (mPluginWindowsHidden) {
    PLUGINS_LOG("[%" PRIu64 "] re-showing", aId);
    mPluginWindowsHidden = false;
    pluginMetricsChanged = true;
  }

  if (!lts.mPluginData.Length()) {
    // Don't hide plugins if the previous remote layer tree didn't contain any.
    if (!mCachedPluginData.Length()) {
      PLUGINS_LOG("[%" PRIu64 "] nothing to hide", aId);
      return false;
    }

    uintptr_t parentWidget = GetWidget()->GetWidgetKey();

    // We will pass through here in cases where the previous shadow layer
    // tree contained visible plugins and the new tree does not. All we need
    // to do here is hide the plugins for the old tree, so don't waste time
    // calculating clipping.
    mPluginsLayerOffset = nsIntPoint(0,0);
    mPluginsLayerVisibleRegion.SetEmpty();
    Unused << lts.mParent->SendHideAllPlugins(parentWidget);
    lts.mUpdatedPluginDataAvailable = false;
    PLUGINS_LOG("[%" PRIu64 "] hide all", aId);
  } else {
    // Retrieve the offset and visible region of the layer that hosts
    // the plugins, CompositorBridgeChild needs these in calculating proper
    // plugin clipping.
    LayerTransactionParent* layerTree = lts.mLayerTree;
    Layer* contentRoot = layerTree->GetRoot();
    if (contentRoot) {
      nsIntPoint offset;
      nsIntRegion visibleRegion;
      if (contentRoot->GetVisibleRegionRelativeToRootLayer(visibleRegion,
                                                            &offset)) {
        // Check to see if these values have changed, if so we need to
        // update plugin window position within the window.
        if (!pluginMetricsChanged &&
            mPluginsLayerVisibleRegion == visibleRegion &&
            mPluginsLayerOffset == offset) {
          PLUGINS_LOG("[%" PRIu64 "] no change", aId);
          return false;
        }
        mPluginsLayerOffset = offset;
        mPluginsLayerVisibleRegion = visibleRegion;
        Unused << lts.mParent->SendUpdatePluginConfigurations(
          LayoutDeviceIntPoint::FromUnknownPoint(offset),
          LayoutDeviceIntRegion::FromUnknownRegion(visibleRegion),
          lts.mPluginData);
        lts.mUpdatedPluginDataAvailable = false;
        PLUGINS_LOG("[%" PRIu64 "] updated", aId);
      } else {
        PLUGINS_LOG("[%" PRIu64 "] no visibility data", aId);
        return false;
      }
    } else {
      PLUGINS_LOG("[%" PRIu64 "] no content root", aId);
      return false;
    }
  }

  mLastPluginUpdateLayerTreeId = aId;
  mCachedPluginData = lts.mPluginData;
  return true;
}

void
CompositorBridgeParent::ScheduleShowAllPluginWindows()
{
  MOZ_ASSERT(CompositorLoop());
  CompositorLoop()->PostTask(NewRunnableMethod(this, &CompositorBridgeParent::ShowAllPluginWindows));
}

void
CompositorBridgeParent::ShowAllPluginWindows()
{
  MOZ_ASSERT(!NS_IsMainThread());
  mDeferPluginWindows = false;
  ScheduleComposition();
}

void
CompositorBridgeParent::ScheduleHideAllPluginWindows()
{
  MOZ_ASSERT(CompositorLoop());
  CompositorLoop()->PostTask(NewRunnableMethod(this, &CompositorBridgeParent::HideAllPluginWindows));
}

void
CompositorBridgeParent::HideAllPluginWindows()
{
  MOZ_ASSERT(!NS_IsMainThread());
  // No plugins in the cache implies no plugins to manage
  // in this content.
  if (!mCachedPluginData.Length() || mDeferPluginWindows) {
    return;
  }

  uintptr_t parentWidget = GetWidget()->GetWidgetKey();

  mDeferPluginWindows = true;
  mPluginWindowsHidden = true;

#if defined(XP_WIN)
  // We will get an async reply that this has happened and then send hide.
  mWaitForPluginsUntil = TimeStamp::Now() + mVsyncRate;
  Unused << SendCaptureAllPlugins(parentWidget);
#else
  Unused << SendHideAllPlugins(parentWidget);
  ScheduleComposition();
#endif
}
#endif // #if defined(XP_WIN) || defined(MOZ_WIDGET_GTK)

bool
CompositorBridgeParent::RecvAllPluginsCaptured()
{
#if defined(XP_WIN)
  mWaitForPluginsUntil = TimeStamp();
  mHaveBlockedForPlugins = false;
  ForceComposeToTarget(nullptr);
  Unused << SendHideAllPlugins(GetWidget()->GetWidgetKey());
  return true;
#else
  MOZ_ASSERT_UNREACHABLE(
    "CompositorBridgeParent::RecvAllPluginsCaptured calls unexpected.");
  return false;
#endif
}

} // namespace layers
} // namespace mozilla
