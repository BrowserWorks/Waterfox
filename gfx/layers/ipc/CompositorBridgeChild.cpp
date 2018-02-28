/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set sw=2 ts=2 et tw=80 : */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/layers/CompositorBridgeChild.h"
#include "mozilla/layers/CompositorBridgeParent.h"
#include "mozilla/layers/CompositorThread.h"
#include <stddef.h>                     // for size_t
#include "ClientLayerManager.h"         // for ClientLayerManager
#include "base/message_loop.h"          // for MessageLoop
#include "base/task.h"                  // for NewRunnableMethod, etc
#include "gfxPrefs.h"
#include "mozilla/dom/TabGroup.h"
#include "mozilla/layers/CompositorManagerChild.h"
#include "mozilla/layers/ImageBridgeChild.h"
#include "mozilla/layers/APZChild.h"
#include "mozilla/layers/IAPZCTreeManager.h"
#include "mozilla/layers/APZCTreeManagerChild.h"
#include "mozilla/layers/LayerTransactionChild.h"
#include "mozilla/layers/PaintThread.h"
#include "mozilla/layers/PLayerTransactionChild.h"
#include "mozilla/layers/PTextureChild.h"
#include "mozilla/layers/TextureClient.h"// for TextureClient
#include "mozilla/layers/TextureClientPool.h"// for TextureClientPool
#include "mozilla/layers/WebRenderBridgeChild.h"
#include "mozilla/gfx/gfxVars.h"
#include "mozilla/gfx/GPUProcessManager.h"
#include "mozilla/gfx/Logging.h"
#include "mozilla/mozalloc.h"           // for operator new, etc
#include "nsAutoPtr.h"
#include "nsDebug.h"                    // for NS_RUNTIMEABORT
#include "nsIObserver.h"                // for nsIObserver
#include "nsISupportsImpl.h"            // for MOZ_COUNT_CTOR, etc
#include "nsTArray.h"                   // for nsTArray, nsTArray_Impl
#include "nsXULAppAPI.h"                // for XRE_GetIOMessageLoop, etc
#include "FrameLayerBuilder.h"
#include "mozilla/dom/TabChild.h"
#include "mozilla/dom/TabParent.h"
#include "mozilla/dom/ContentChild.h"
#include "mozilla/Unused.h"
#include "mozilla/DebugOnly.h"
#if defined(XP_WIN)
#include "WinUtils.h"
#endif
#include "mozilla/widget/CompositorWidget.h"
#ifdef MOZ_WIDGET_SUPPORTS_OOP_COMPOSITING
# include "mozilla/widget/CompositorWidgetChild.h"
#endif
#include "VsyncSource.h"

using mozilla::layers::LayerTransactionChild;
using mozilla::dom::TabChildBase;
using mozilla::Unused;
using mozilla::gfx::GPUProcessManager;

namespace mozilla {
namespace layers {

static int sShmemCreationCounter = 0;

static void ResetShmemCounter()
{
  sShmemCreationCounter = 0;
}

static void ShmemAllocated(CompositorBridgeChild* aProtocol)
{
  sShmemCreationCounter++;
  if (sShmemCreationCounter > 256) {
    aProtocol->SendSyncWithCompositor();
    ResetShmemCounter();
    MOZ_PERFORMANCE_WARNING("gfx", "The number of shmem allocations is too damn high!");
  }
}

static StaticRefPtr<CompositorBridgeChild> sCompositorBridge;

Atomic<int32_t> KnowsCompositor::sSerialCounter(0);

CompositorBridgeChild::CompositorBridgeChild(CompositorManagerChild *aManager)
  : mCompositorManager(aManager)
  , mIdNamespace(0)
  , mResourceId(0)
  , mCanSend(false)
  , mActorDestroyed(false)
  , mFwdTransactionId(0)
  , mDeviceResetSequenceNumber(0)
  , mMessageLoop(MessageLoop::current())
  , mProcessToken(0)
  , mSectionAllocator(nullptr)
  , mPaintLock("CompositorBridgeChild.mPaintLock")
  , mOutstandingAsyncPaints(0)
  , mIsWaitingForPaint(false)
{
  MOZ_ASSERT(NS_IsMainThread());
}

CompositorBridgeChild::~CompositorBridgeChild()
{
  if (mCanSend) {
    gfxCriticalError() << "CompositorBridgeChild was not deinitialized";
  }
}

bool
CompositorBridgeChild::IsSameProcess() const
{
  return OtherPid() == base::GetCurrentProcId();
}

void
CompositorBridgeChild::AfterDestroy()
{
  // Note that we cannot rely upon mCanSend here because we already set that to
  // false to prevent normal IPDL calls from being made after SendWillClose.
  // The only time we should not issue Send__delete__ is if the actor is already
  // destroyed, e.g. the compositor process crashed.
  if (!mActorDestroyed) {
    Send__delete__(this);
    mActorDestroyed = true;
  }

  if (sCompositorBridge == this) {
    sCompositorBridge = nullptr;
  }
}

void
CompositorBridgeChild::Destroy()
{
  // This must not be called from the destructor!
  mTexturesWaitingRecycled.Clear();

  // Destroying the layer manager may cause all sorts of things to happen, so
  // let's make sure there is still a reference to keep this alive whatever
  // happens.
  RefPtr<CompositorBridgeChild> selfRef = this;

  for (size_t i = 0; i < mTexturePools.Length(); i++) {
    mTexturePools[i]->Destroy();
  }

  if (mSectionAllocator) {
    delete mSectionAllocator;
    mSectionAllocator = nullptr;
  }

  if (mLayerManager) {
    mLayerManager->Destroy();
    mLayerManager = nullptr;
  }

  if (!mCanSend) {
    // We may have already called destroy but still have lingering references
    // or CompositorBridgeChild::ActorDestroy was called. Ensure that we do our
    // post destroy clean up no matter what. It is safe to call multiple times.
    MessageLoop::current()->PostTask(NewRunnableMethod(
      "CompositorBridgeChild::AfterDestroy",
      selfRef, &CompositorBridgeChild::AfterDestroy));
    return;
  }

  AutoTArray<PLayerTransactionChild*, 16> transactions;
  ManagedPLayerTransactionChild(transactions);
  for (int i = transactions.Length() - 1; i >= 0; --i) {
    RefPtr<LayerTransactionChild> layers =
      static_cast<LayerTransactionChild*>(transactions[i]);
    layers->Destroy();
  }

  AutoTArray<PWebRenderBridgeChild*, 16> wrBridges;
  ManagedPWebRenderBridgeChild(wrBridges);
  for (int i = wrBridges.Length() - 1; i >= 0; --i) {
    RefPtr<WebRenderBridgeChild> wrBridge =
      static_cast<WebRenderBridgeChild*>(wrBridges[i]);
    wrBridge->Destroy(/* aIsSync */ false);
  }

  const ManagedContainer<PTextureChild>& textures = ManagedPTextureChild();
  for (auto iter = textures.ConstIter(); !iter.Done(); iter.Next()) {
    RefPtr<TextureClient> texture = TextureClient::AsTextureClient(iter.Get()->GetKey());

    if (texture) {
      texture->Destroy();
    }
  }

  SendWillClose();
  mCanSend = false;

  // We no longer care about unexpected shutdowns, in the remote process case.
  mProcessToken = 0;

  // The call just made to SendWillClose can result in IPC from the
  // CompositorBridgeParent to the CompositorBridgeChild (e.g. caused by the destruction
  // of shared memory). We need to ensure this gets processed by the
  // CompositorBridgeChild before it gets destroyed. It suffices to ensure that
  // events already in the MessageLoop get processed before the
  // CompositorBridgeChild is destroyed, so we add a task to the MessageLoop to
  // handle compositor destruction.

  // From now on we can't send any message message.
  MessageLoop::current()->PostTask(NewRunnableMethod(
    "CompositorBridgeChild::AfterDestroy",
    selfRef, &CompositorBridgeChild::AfterDestroy));
}

// static
void
CompositorBridgeChild::ShutDown()
{
  if (sCompositorBridge) {
    sCompositorBridge->Destroy();
    SpinEventLoopUntil([&]() { return !sCompositorBridge; });
  }
}

bool
CompositorBridgeChild::LookupCompositorFrameMetrics(const FrameMetrics::ViewID aId,
                                                    FrameMetrics& aFrame)
{
  SharedFrameMetricsData* data = mFrameMetricsTable.Get(aId);
  if (data) {
    data->CopyFrameMetrics(&aFrame);
    return true;
  }
  return false;
}

void
CompositorBridgeChild::InitForContent(uint32_t aNamespace)
{
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(aNamespace);

  if (RefPtr<CompositorBridgeChild> old = sCompositorBridge.forget()) {
    // Note that at this point, ActorDestroy may not have been called yet,
    // meaning mCanSend is still true. In this case we will try to send a
    // synchronous WillClose message to the parent, and will certainly get
    // a false result and a MsgDropped processing error. This is okay.
    old->Destroy();
  }

  mCanSend = true;
  mIdNamespace = aNamespace;
  sCompositorBridge = this;
}

void
CompositorBridgeChild::InitForWidget(uint64_t aProcessToken,
                                     LayerManager* aLayerManager,
                                     uint32_t aNamespace)
{
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(aProcessToken);
  MOZ_ASSERT(aLayerManager);
  MOZ_ASSERT(aNamespace);

  mCanSend = true;
  mProcessToken = aProcessToken;
  mLayerManager = aLayerManager;
  mIdNamespace = aNamespace;
}

/*static*/ CompositorBridgeChild*
CompositorBridgeChild::Get()
{
  // This is only expected to be used in child processes.
  MOZ_ASSERT(!XRE_IsParentProcess());
  return sCompositorBridge;
}

// static
bool
CompositorBridgeChild::ChildProcessHasCompositorBridge()
{
  return sCompositorBridge != nullptr;
}

/* static */ bool
CompositorBridgeChild::CompositorIsInGPUProcess()
{
  MOZ_ASSERT(NS_IsMainThread());

  if (XRE_IsParentProcess()) {
    return !!GPUProcessManager::Get()->GetGPUChild();
  }

  MOZ_ASSERT(XRE_IsContentProcess());
  CompositorBridgeChild* bridge = CompositorBridgeChild::Get();
  if (!bridge) {
    return false;
  }

  return bridge->OtherPid() != dom::ContentChild::GetSingleton()->OtherPid();
}

PLayerTransactionChild*
CompositorBridgeChild::AllocPLayerTransactionChild(const nsTArray<LayersBackend>& aBackendHints, const uint64_t& aId)
{
  LayerTransactionChild* c = new LayerTransactionChild(aId);
  c->AddIPDLReference();

  TabChild* tabChild = TabChild::GetFrom(c->GetId());

  // Do the DOM Labeling.
  if (tabChild) {
    nsCOMPtr<nsIEventTarget> target =
      tabChild->TabGroup()->EventTargetFor(TaskCategory::Other);
    SetEventTargetForActor(c, target);
    MOZ_ASSERT(c->GetActorEventTarget());
  }

  return c;
}

bool
CompositorBridgeChild::DeallocPLayerTransactionChild(PLayerTransactionChild* actor)
{
  uint64_t childId = static_cast<LayerTransactionChild*>(actor)->GetId();

  for (auto iter = mFrameMetricsTable.Iter(); !iter.Done(); iter.Next()) {
    nsAutoPtr<SharedFrameMetricsData>& data = iter.Data();
    if (data->GetLayersId() == childId) {
      iter.Remove();
    }
  }
  static_cast<LayerTransactionChild*>(actor)->ReleaseIPDLReference();
  return true;
}

mozilla::ipc::IPCResult
CompositorBridgeChild::RecvInvalidateLayers(const uint64_t& aLayersId)
{
  if (mLayerManager) {
    MOZ_ASSERT(aLayersId == 0);
    FrameLayerBuilder::InvalidateAllLayers(mLayerManager);
  } else if (aLayersId != 0) {
    if (dom::TabChild* child = dom::TabChild::GetFrom(aLayersId)) {
      child->InvalidateLayers();
    }
  }
  return IPC_OK();
}

#if defined(XP_WIN) || defined(MOZ_WIDGET_GTK)
static void CalculatePluginClip(const LayoutDeviceIntRect& aBounds,
                                const nsTArray<LayoutDeviceIntRect>& aPluginClipRects,
                                const LayoutDeviceIntPoint& aContentOffset,
                                const LayoutDeviceIntRegion& aParentLayerVisibleRegion,
                                nsTArray<LayoutDeviceIntRect>& aResult,
                                LayoutDeviceIntRect& aVisibleBounds,
                                bool& aPluginIsVisible)
{
  aPluginIsVisible = true;
  LayoutDeviceIntRegion contentVisibleRegion;
  // aPluginClipRects (plugin widget origin) - contains *visible* rects
  for (uint32_t idx = 0; idx < aPluginClipRects.Length(); idx++) {
    LayoutDeviceIntRect rect = aPluginClipRects[idx];
    // shift to content origin
    rect.MoveBy(aBounds.x, aBounds.y);
    // accumulate visible rects
    contentVisibleRegion.OrWith(rect);
  }
  // apply layers clip (window origin)
  LayoutDeviceIntRegion region = aParentLayerVisibleRegion;
  region.MoveBy(-aContentOffset.x, -aContentOffset.y);
  contentVisibleRegion.AndWith(region);
  if (contentVisibleRegion.IsEmpty()) {
    aPluginIsVisible = false;
    return;
  }
  // shift to plugin widget origin
  contentVisibleRegion.MoveBy(-aBounds.x, -aBounds.y);
  for (auto iter = contentVisibleRegion.RectIter(); !iter.Done(); iter.Next()) {
    const LayoutDeviceIntRect& rect = iter.Get();
    aResult.AppendElement(rect);
    aVisibleBounds.UnionRect(aVisibleBounds, rect);
  }
}
#endif

mozilla::ipc::IPCResult
CompositorBridgeChild::RecvUpdatePluginConfigurations(const LayoutDeviceIntPoint& aContentOffset,
                                                      const LayoutDeviceIntRegion& aParentLayerVisibleRegion,
                                                      nsTArray<PluginWindowData>&& aPlugins)
{
#if !defined(XP_WIN) && !defined(MOZ_WIDGET_GTK)
  NS_NOTREACHED("CompositorBridgeChild::RecvUpdatePluginConfigurations calls "
                "unexpected on this platform.");
  return IPC_FAIL_NO_REASON(this);
#else
  // Now that we are on the main thread, update plugin widget config.
  // This should happen a little before we paint to the screen assuming
  // the main thread is running freely.
  DebugOnly<nsresult> rv;
  MOZ_ASSERT(NS_IsMainThread());

  // Tracks visible plugins we update, so we can hide any plugins we don't.
  nsTArray<uintptr_t> visiblePluginIds;
  nsIWidget* parent = nullptr;
  for (uint32_t pluginsIdx = 0; pluginsIdx < aPlugins.Length(); pluginsIdx++) {
    nsIWidget* widget =
      nsIWidget::LookupRegisteredPluginWindow(aPlugins[pluginsIdx].windowId());
    if (!widget) {
      NS_WARNING("Unexpected, plugin id not found!");
      continue;
    }
    if (!parent) {
      parent = widget->GetParent();
    }
    bool isVisible = aPlugins[pluginsIdx].visible();
    if (widget && !widget->Destroyed()) {
      LayoutDeviceIntRect bounds;
      LayoutDeviceIntRect visibleBounds;
      // If the plugin is visible update it's geometry.
      if (isVisible) {
        // Set bounds (content origin)
        bounds = aPlugins[pluginsIdx].bounds();
        nsTArray<LayoutDeviceIntRect> rectsOut;
        // This call may change the value of isVisible
        CalculatePluginClip(bounds, aPlugins[pluginsIdx].clip(),
                            aContentOffset,
                            aParentLayerVisibleRegion,
                            rectsOut, visibleBounds, isVisible);
        // content clipping region (widget origin)
        rv = widget->SetWindowClipRegion(rectsOut, false);
        NS_ASSERTION(NS_SUCCEEDED(rv), "widget call failure");
        // This will trigger a browser window paint event for areas uncovered
        // by a child window move, and will call invalidate on the plugin
        // parent window which the browser owns. The latter gets picked up in
        // our OnPaint handler and forwarded over to the plugin process async.
        widget->Resize(aContentOffset.x + bounds.x,
                       aContentOffset.y + bounds.y,
                       bounds.width, bounds.height, true);
      }

      widget->Enable(isVisible);

      // visible state - updated after clipping, prior to invalidating
      widget->Show(isVisible);

      // Handle invalidation, this can be costly, avoid if it is not needed.
      if (isVisible) {
        // invalidate region (widget origin)
#if defined(XP_WIN)
        // Work around for flash's crummy sandbox. See bug 762948. This call
        // digs down into the window hirearchy, invalidating regions on
        // windows owned by other processes.
        mozilla::widget::WinUtils::InvalidatePluginAsWorkaround(
          widget, visibleBounds);
#else
        widget->Invalidate(visibleBounds);
#endif
        visiblePluginIds.AppendElement(aPlugins[pluginsIdx].windowId());
      }
    }
  }
  // Any plugins we didn't update need to be hidden, as they are
  // not associated with visible content.
  nsIWidget::UpdateRegisteredPluginWindowVisibility((uintptr_t)parent, visiblePluginIds);
  if (!mCanSend) {
    return IPC_OK();
  }
  SendRemotePluginsReady();
  return IPC_OK();
#endif // !defined(XP_WIN) && !defined(MOZ_WIDGET_GTK)
}

#if defined(XP_WIN)
static void
ScheduleSendAllPluginsCaptured(CompositorBridgeChild* aThis, MessageLoop* aLoop)
{
  aLoop->PostTask(NewNonOwningRunnableMethod(
    "CompositorBridgeChild::SendAllPluginsCaptured",
    aThis, &CompositorBridgeChild::SendAllPluginsCaptured));
}
#endif

mozilla::ipc::IPCResult
CompositorBridgeChild::RecvCaptureAllPlugins(const uintptr_t& aParentWidget)
{
#if defined(XP_WIN)
  MOZ_ASSERT(NS_IsMainThread());
  nsIWidget::CaptureRegisteredPlugins(aParentWidget);

  // Bounce the call to SendAllPluginsCaptured off the ImageBridgeChild loop,
  // to make sure that the image updates on that thread have been processed.
  ImageBridgeChild::GetSingleton()->GetMessageLoop()->PostTask(
    NewRunnableFunction(&ScheduleSendAllPluginsCaptured, this,
                        MessageLoop::current()));
  return IPC_OK();
#else
  MOZ_ASSERT_UNREACHABLE(
    "CompositorBridgeChild::RecvCaptureAllPlugins calls unexpected.");
  return IPC_FAIL_NO_REASON(this);
#endif
}

mozilla::ipc::IPCResult
CompositorBridgeChild::RecvHideAllPlugins(const uintptr_t& aParentWidget)
{
#if !defined(XP_WIN) && !defined(MOZ_WIDGET_GTK)
  NS_NOTREACHED("CompositorBridgeChild::RecvHideAllPlugins calls "
                "unexpected on this platform.");
  return IPC_FAIL_NO_REASON(this);
#else
  MOZ_ASSERT(NS_IsMainThread());
  nsTArray<uintptr_t> list;
  nsIWidget::UpdateRegisteredPluginWindowVisibility(aParentWidget, list);
  if (!mCanSend) {
    return IPC_OK();
  }
  SendRemotePluginsReady();
  return IPC_OK();
#endif // !defined(XP_WIN) && !defined(MOZ_WIDGET_GTK)
}

mozilla::ipc::IPCResult
CompositorBridgeChild::RecvDidComposite(const uint64_t& aId,
                                        const uint64_t& aTransactionId,
                                        const TimeStamp& aCompositeStart,
                                        const TimeStamp& aCompositeEnd)
{
  // Hold a reference to keep texture pools alive.  See bug 1387799
  AutoTArray<RefPtr<TextureClientPool>,2> texturePools = mTexturePools;

  if (mLayerManager) {
    MOZ_ASSERT(aId == 0);
    MOZ_ASSERT(mLayerManager->GetBackendType() == LayersBackend::LAYERS_CLIENT ||
               mLayerManager->GetBackendType() == LayersBackend::LAYERS_WR);
    // Hold a reference to keep LayerManager alive. See Bug 1242668.
    RefPtr<LayerManager> m = mLayerManager;
    m->DidComposite(aTransactionId, aCompositeStart, aCompositeEnd);
  } else if (aId != 0) {
    RefPtr<dom::TabChild> child = dom::TabChild::GetFrom(aId);
    if (child) {
      child->DidComposite(aTransactionId, aCompositeStart, aCompositeEnd);
    }
  }

  for (size_t i = 0; i < texturePools.Length(); i++) {
    texturePools[i]->ReturnDeferredClients();
  }

  return IPC_OK();
}


void
CompositorBridgeChild::ActorDestroy(ActorDestroyReason aWhy)
{
  if (aWhy == AbnormalShutdown) {
    // If the parent side runs into a problem then the actor will be destroyed.
    // There is nothing we can do in the child side, here sets mCanSend as false.
    gfxCriticalNote << "Receive IPC close with reason=AbnormalShutdown";
  }

  {
    // We take the lock to update these fields, since they are read from the
    // paint thread. We don't need the lock to init them, since that happens
    // on the main thread before the paint thread can ever grab a reference
    // to the CompositorBridge object.
    //
    // Note that it is useful to take this lock for one other reason: It also
    // tells us whether GetIPCChannel is safe to call. If we access the IPC
    // channel within this lock, when mCanSend is true, then we know it has not
    // been zapped by IPDL.
    MonitorAutoLock lock(mPaintLock);
    mCanSend = false;
    mActorDestroyed = true;
  }

  if (mProcessToken && XRE_IsParentProcess()) {
    GPUProcessManager::Get()->NotifyRemoteActorDestroyed(mProcessToken);
  }
}

mozilla::ipc::IPCResult
CompositorBridgeChild::RecvSharedCompositorFrameMetrics(
    const mozilla::ipc::SharedMemoryBasic::Handle& metrics,
    const CrossProcessMutexHandle& handle,
    const uint64_t& aLayersId,
    const uint32_t& aAPZCId)
{
  SharedFrameMetricsData* data = new SharedFrameMetricsData(
    metrics, handle, aLayersId, aAPZCId);
  mFrameMetricsTable.Put(data->GetViewID(), data);
  return IPC_OK();
}

mozilla::ipc::IPCResult
CompositorBridgeChild::RecvReleaseSharedCompositorFrameMetrics(
    const ViewID& aId,
    const uint32_t& aAPZCId)
{
  if (auto entry = mFrameMetricsTable.Lookup(aId)) {
    // The SharedFrameMetricsData may have been removed previously if
    // a SharedFrameMetricsData with the same ViewID but later APZCId had
    // been store and over wrote it.
    if (entry.Data()->GetAPZCId() == aAPZCId) {
      entry.Remove();
    }
  }
  return IPC_OK();
}

CompositorBridgeChild::SharedFrameMetricsData::SharedFrameMetricsData(
    const ipc::SharedMemoryBasic::Handle& metrics,
    const CrossProcessMutexHandle& handle,
    const uint64_t& aLayersId,
    const uint32_t& aAPZCId)
  : mMutex(nullptr)
  , mLayersId(aLayersId)
  , mAPZCId(aAPZCId)
{
  mBuffer = new ipc::SharedMemoryBasic;
  mBuffer->SetHandle(metrics, ipc::SharedMemory::RightsReadOnly);
  mBuffer->Map(sizeof(FrameMetrics));
  mMutex = new CrossProcessMutex(handle);
  MOZ_COUNT_CTOR(SharedFrameMetricsData);
}

CompositorBridgeChild::SharedFrameMetricsData::~SharedFrameMetricsData()
{
  // When the hash table deletes the class, delete
  // the shared memory and mutex.
  delete mMutex;
  mBuffer = nullptr;
  MOZ_COUNT_DTOR(SharedFrameMetricsData);
}

void
CompositorBridgeChild::SharedFrameMetricsData::CopyFrameMetrics(FrameMetrics* aFrame)
{
  const FrameMetrics* frame =
    static_cast<const FrameMetrics*>(mBuffer->memory());
  MOZ_ASSERT(frame);
  mMutex->Lock();
  *aFrame = *frame;
  mMutex->Unlock();
}

FrameMetrics::ViewID
CompositorBridgeChild::SharedFrameMetricsData::GetViewID()
{
  const FrameMetrics* frame =
    static_cast<const FrameMetrics*>(mBuffer->memory());
  MOZ_ASSERT(frame);
  // Not locking to read of mScrollId since it should not change after being
  // initially set.
  return frame->GetScrollId();
}

uint64_t
CompositorBridgeChild::SharedFrameMetricsData::GetLayersId() const
{
  return mLayersId;
}

uint32_t
CompositorBridgeChild::SharedFrameMetricsData::GetAPZCId()
{
  return mAPZCId;
}


mozilla::ipc::IPCResult
CompositorBridgeChild::RecvRemotePaintIsReady()
{
  // Used on the content thread, this bounces the message to the
  // TabParent (via the TabChild) if the notification was previously requested.
  // XPCOM gives a soup of compiler errors when trying to do_QueryReference
  // so I'm using static_cast<>
  MOZ_LAYERS_LOG(("[RemoteGfx] CompositorBridgeChild received RemotePaintIsReady"));
  RefPtr<nsISupports> iTabChildBase(do_QueryReferent(mWeakTabChild));
  if (!iTabChildBase) {
    MOZ_LAYERS_LOG(("[RemoteGfx] Note: TabChild was released before RemotePaintIsReady. "
        "MozAfterRemotePaint will not be sent to listener."));
    return IPC_OK();
  }
  TabChildBase* tabChildBase = static_cast<TabChildBase*>(iTabChildBase.get());
  TabChild* tabChild = static_cast<TabChild*>(tabChildBase);
  MOZ_ASSERT(tabChild);
  Unused << tabChild->SendRemotePaintIsReady();
  mWeakTabChild = nullptr;
  return IPC_OK();
}


void
CompositorBridgeChild::RequestNotifyAfterRemotePaint(TabChild* aTabChild)
{
  MOZ_ASSERT(aTabChild, "NULL TabChild not allowed in CompositorBridgeChild::RequestNotifyAfterRemotePaint");
  mWeakTabChild = do_GetWeakReference( static_cast<dom::TabChildBase*>(aTabChild) );
  if (!mCanSend) {
    return;
  }
  Unused << SendRequestNotifyAfterRemotePaint();
}

void
CompositorBridgeChild::CancelNotifyAfterRemotePaint(TabChild* aTabChild)
{
  RefPtr<nsISupports> iTabChildBase(do_QueryReferent(mWeakTabChild));
  if (!iTabChildBase) {
    return;
  }
  TabChildBase* tabChildBase = static_cast<TabChildBase*>(iTabChildBase.get());
  TabChild* tabChild = static_cast<TabChild*>(tabChildBase);
  if (tabChild == aTabChild) {
    mWeakTabChild = nullptr;
  }
}

bool
CompositorBridgeChild::SendWillClose()
{
  MOZ_RELEASE_ASSERT(mCanSend);
  return PCompositorBridgeChild::SendWillClose();
}

bool
CompositorBridgeChild::SendPause()
{
  if (!mCanSend) {
    return false;
  }
  return PCompositorBridgeChild::SendPause();
}

bool
CompositorBridgeChild::SendResume()
{
  if (!mCanSend) {
    return false;
  }
  return PCompositorBridgeChild::SendResume();
}

bool
CompositorBridgeChild::SendNotifyChildCreated(const uint64_t& id,
                                              CompositorOptions* aOptions)
{
  if (!mCanSend) {
    return false;
  }
  return PCompositorBridgeChild::SendNotifyChildCreated(id, aOptions);
}

bool
CompositorBridgeChild::SendAdoptChild(const uint64_t& id)
{
  if (!mCanSend) {
    return false;
  }
  return PCompositorBridgeChild::SendAdoptChild(id);
}

bool
CompositorBridgeChild::SendMakeSnapshot(const SurfaceDescriptor& inSnapshot, const gfx::IntRect& dirtyRect)
{
  if (!mCanSend) {
    return false;
  }
  return PCompositorBridgeChild::SendMakeSnapshot(inSnapshot, dirtyRect);
}

bool
CompositorBridgeChild::SendFlushRendering()
{
  if (!mCanSend) {
    return false;
  }
  return PCompositorBridgeChild::SendFlushRendering();
}

bool
CompositorBridgeChild::SendStartFrameTimeRecording(const int32_t& bufferSize, uint32_t* startIndex)
{
  if (!mCanSend) {
    return false;
  }
  return PCompositorBridgeChild::SendStartFrameTimeRecording(bufferSize, startIndex);
}

bool
CompositorBridgeChild::SendStopFrameTimeRecording(const uint32_t& startIndex, nsTArray<float>* intervals)
{
  if (!mCanSend) {
    return false;
  }
  return PCompositorBridgeChild::SendStopFrameTimeRecording(startIndex, intervals);
}

bool
CompositorBridgeChild::SendNotifyRegionInvalidated(const nsIntRegion& region)
{
  if (!mCanSend) {
    return false;
  }
  return PCompositorBridgeChild::SendNotifyRegionInvalidated(region);
}

bool
CompositorBridgeChild::SendRequestNotifyAfterRemotePaint()
{
  if (!mCanSend) {
    return false;
  }
  return PCompositorBridgeChild::SendRequestNotifyAfterRemotePaint();
}

bool
CompositorBridgeChild::SendClearApproximatelyVisibleRegions(uint64_t aLayersId,
                                                            uint32_t aPresShellId)
{
  if (!mCanSend) {
    return false;
  }
  return PCompositorBridgeChild::SendClearApproximatelyVisibleRegions(aLayersId,
                                                                aPresShellId);
}

bool
CompositorBridgeChild::SendNotifyApproximatelyVisibleRegion(const ScrollableLayerGuid& aGuid,
                                                            const CSSIntRegion& aRegion)
{
  if (!mCanSend) {
    return false;
  }
  return PCompositorBridgeChild::SendNotifyApproximatelyVisibleRegion(aGuid, aRegion);
}

bool
CompositorBridgeChild::SendAllPluginsCaptured()
{
  if (!mCanSend) {
    return false;
  }
  return PCompositorBridgeChild::SendAllPluginsCaptured();
}

PTextureChild*
CompositorBridgeChild::AllocPTextureChild(const SurfaceDescriptor&,
                                          const LayersBackend&,
                                          const TextureFlags&,
                                          const uint64_t&,
                                          const uint64_t& aSerial,
                                          const wr::MaybeExternalImageId& aExternalImageId)
{
  return TextureClient::CreateIPDLActor();
}

bool
CompositorBridgeChild::DeallocPTextureChild(PTextureChild* actor)
{
  return TextureClient::DestroyIPDLActor(actor);
}

mozilla::ipc::IPCResult
CompositorBridgeChild::RecvParentAsyncMessages(InfallibleTArray<AsyncParentMessageData>&& aMessages)
{
  for (AsyncParentMessageArray::index_type i = 0; i < aMessages.Length(); ++i) {
    const AsyncParentMessageData& message = aMessages[i];

    switch (message.type()) {
      case AsyncParentMessageData::TOpNotifyNotUsed: {
        const OpNotifyNotUsed& op = message.get_OpNotifyNotUsed();
        NotifyNotUsed(op.TextureId(), op.fwdTransactionId());
        break;
      }
      default:
        NS_ERROR("unknown AsyncParentMessageData type");
        return IPC_FAIL_NO_REASON(this);
    }
  }
  return IPC_OK();
}

mozilla::ipc::IPCResult
CompositorBridgeChild::RecvObserveLayerUpdate(const uint64_t& aLayersId,
                                              const uint64_t& aEpoch,
                                              const bool& aActive)
{
  // This message is sent via the window compositor, not the tab compositor -
  // however it still has a layers id.
  MOZ_ASSERT(aLayersId);
  MOZ_ASSERT(XRE_IsParentProcess());

  if (RefPtr<dom::TabParent> tab = dom::TabParent::GetTabParentFromLayersId(aLayersId)) {
    tab->LayerTreeUpdate(aEpoch, aActive);
  }
  return IPC_OK();
}

void
CompositorBridgeChild::HoldUntilCompositableRefReleasedIfNecessary(TextureClient* aClient)
{
  if (!aClient) {
    return;
  }

  if (!(aClient->GetFlags() & TextureFlags::RECYCLE)) {
    return;
  }

  aClient->SetLastFwdTransactionId(GetFwdTransactionId());
  mTexturesWaitingRecycled.Put(aClient->GetSerial(), aClient);
}

void
CompositorBridgeChild::NotifyNotUsed(uint64_t aTextureId, uint64_t aFwdTransactionId)
{
  if (auto entry = mTexturesWaitingRecycled.Lookup(aTextureId)) {
    if (aFwdTransactionId < entry.Data()->GetLastFwdTransactionId()) {
      // Released on host side, but client already requested newer use texture.
      return;
    }
    entry.Remove();
  }
}

void
CompositorBridgeChild::CancelWaitForRecycle(uint64_t aTextureId)
{
  mTexturesWaitingRecycled.Remove(aTextureId);
}

TextureClientPool*
CompositorBridgeChild::GetTexturePool(KnowsCompositor* aAllocator,
                                      SurfaceFormat aFormat,
                                      TextureFlags aFlags)
{
  for (size_t i = 0; i < mTexturePools.Length(); i++) {
    if (mTexturePools[i]->GetBackend() == aAllocator->GetCompositorBackendType() &&
        mTexturePools[i]->GetMaxTextureSize() == aAllocator->GetMaxTextureSize() &&
        mTexturePools[i]->GetFormat() == aFormat &&
        mTexturePools[i]->GetFlags() == aFlags) {
      return mTexturePools[i];
    }
  }

  mTexturePools.AppendElement(
      new TextureClientPool(aAllocator->GetCompositorBackendType(),
                            aAllocator->GetMaxTextureSize(),
                            aFormat,
                            gfx::gfxVars::TileSize(),
                            aFlags,
                            gfxPrefs::LayersTilePoolShrinkTimeout(),
                            gfxPrefs::LayersTilePoolClearTimeout(),
                            gfxPrefs::LayersTileInitialPoolSize(),
                            gfxPrefs::LayersTilePoolUnusedSize(),
                            this));

  return mTexturePools.LastElement();
}

void
CompositorBridgeChild::HandleMemoryPressure()
{
  for (size_t i = 0; i < mTexturePools.Length(); i++) {
    mTexturePools[i]->Clear();
  }
}

void
CompositorBridgeChild::ClearTexturePool()
{
  for (size_t i = 0; i < mTexturePools.Length(); i++) {
    mTexturePools[i]->Clear();
  }
}

FixedSizeSmallShmemSectionAllocator*
CompositorBridgeChild::GetTileLockAllocator()
{
  if (!IPCOpen()) {
    return nullptr;
  }

  if (!mSectionAllocator) {
    mSectionAllocator = new FixedSizeSmallShmemSectionAllocator(this);
  }
  return mSectionAllocator;
}

PTextureChild*
CompositorBridgeChild::CreateTexture(const SurfaceDescriptor& aSharedData,
                                     LayersBackend aLayersBackend,
                                     TextureFlags aFlags,
                                     uint64_t aSerial,
                                     wr::MaybeExternalImageId& aExternalImageId,
                                     nsIEventTarget* aTarget)
{
  PTextureChild* textureChild = AllocPTextureChild(
    aSharedData, aLayersBackend, aFlags, 0 /* FIXME */, aSerial, aExternalImageId);

  // Do the DOM labeling.
  if (aTarget) {
    SetEventTargetForActor(textureChild, aTarget);
  }

  return SendPTextureConstructor(
    textureChild, aSharedData, aLayersBackend, aFlags, 0 /* FIXME? */, aSerial, aExternalImageId);
}

bool
CompositorBridgeChild::AllocUnsafeShmem(size_t aSize,
                                   ipc::SharedMemory::SharedMemoryType aType,
                                   ipc::Shmem* aShmem)
{
  ShmemAllocated(this);
  return PCompositorBridgeChild::AllocUnsafeShmem(aSize, aType, aShmem);
}

bool
CompositorBridgeChild::AllocShmem(size_t aSize,
                             ipc::SharedMemory::SharedMemoryType aType,
                             ipc::Shmem* aShmem)
{
  ShmemAllocated(this);
  return PCompositorBridgeChild::AllocShmem(aSize, aType, aShmem);
}

bool
CompositorBridgeChild::DeallocShmem(ipc::Shmem& aShmem)
{
  if (!mCanSend) {
    return false;
  }
  return PCompositorBridgeChild::DeallocShmem(aShmem);
}

widget::PCompositorWidgetChild*
CompositorBridgeChild::AllocPCompositorWidgetChild(const CompositorWidgetInitData& aInitData)
{
  // We send the constructor manually.
  MOZ_CRASH("Should not be called");
  return nullptr;
}

bool
CompositorBridgeChild::DeallocPCompositorWidgetChild(PCompositorWidgetChild* aActor)
{
#ifdef MOZ_WIDGET_SUPPORTS_OOP_COMPOSITING
  delete aActor;
  return true;
#else
  return false;
#endif
}

PAPZCTreeManagerChild*
CompositorBridgeChild::AllocPAPZCTreeManagerChild(const uint64_t& aLayersId)
{
  APZCTreeManagerChild* child = new APZCTreeManagerChild();
  child->AddRef();
  if (aLayersId != 0) {
    TabChild* tabChild = TabChild::GetFrom(aLayersId);
    if (tabChild) {
      SetEventTargetForActor(
        child, tabChild->TabGroup()->EventTargetFor(TaskCategory::Other));
      MOZ_ASSERT(child->GetActorEventTarget());
    }
  }

  return child;
}

PAPZChild*
CompositorBridgeChild::AllocPAPZChild(const uint64_t& aLayersId)
{
  // We send the constructor manually.
  MOZ_CRASH("Should not be called");
  return nullptr;
}

bool
CompositorBridgeChild::DeallocPAPZChild(PAPZChild* aActor)
{
  delete aActor;
  return true;
}

bool
CompositorBridgeChild::DeallocPAPZCTreeManagerChild(PAPZCTreeManagerChild* aActor)
{
  APZCTreeManagerChild* parent = static_cast<APZCTreeManagerChild*>(aActor);
  parent->Release();
  return true;
}

void
CompositorBridgeChild::WillEndTransaction()
{
  ResetShmemCounter();
}

PWebRenderBridgeChild*
CompositorBridgeChild::AllocPWebRenderBridgeChild(const wr::PipelineId& aPipelineId,
                                                  const LayoutDeviceIntSize&,
                                                  TextureFactoryIdentifier*,
                                                  wr::IdNamespace *aIdNamespace)
{
  WebRenderBridgeChild* child = new WebRenderBridgeChild(aPipelineId);
  child->AddIPDLReference();
  return child;
}

bool
CompositorBridgeChild::DeallocPWebRenderBridgeChild(PWebRenderBridgeChild* aActor)
{
  WebRenderBridgeChild* child = static_cast<WebRenderBridgeChild*>(aActor);
  child->ReleaseIPDLReference();
  return true;
}

uint64_t
CompositorBridgeChild::GetNextResourceId()
{
  ++mResourceId;
  MOZ_RELEASE_ASSERT(mResourceId != UINT32_MAX);

  uint64_t id = mIdNamespace;
  id = (id << 32) | mResourceId;

  return id;
}

wr::MaybeExternalImageId
CompositorBridgeChild::GetNextExternalImageId()
{
  return Some(wr::ToExternalImageId(GetNextResourceId()));
}

wr::PipelineId
CompositorBridgeChild::GetNextPipelineId()
{
  return wr::AsPipelineId(GetNextResourceId());
}

void
CompositorBridgeChild::NotifyBeginAsyncPaint()
{
  MOZ_ASSERT(NS_IsMainThread());

  MonitorAutoLock lock(mPaintLock);

  // We must not be waiting for paints to complete yet. This would imply we
  // started a new paint without waiting for a previous one, which could lead to
  // incorrect rendering or IPDL deadlocks.
  MOZ_ASSERT(!mIsWaitingForPaint);

  mOutstandingAsyncPaints++;
}

void
CompositorBridgeChild::NotifyFinishedAsyncPaint()
{
  MOZ_ASSERT(PaintThread::IsOnPaintThread());

  MonitorAutoLock lock(mPaintLock);

  mOutstandingAsyncPaints--;

  // It's possible that we painted so fast that the main thread never reached
  // the code that starts delaying messages. If so, mIsWaitingForPaint will be
  // false, and we can safely return.
  if (mIsWaitingForPaint && mOutstandingAsyncPaints == 0) {
    ResumeIPCAfterAsyncPaint();

    // Notify the main thread in case it's blocking. We do this unconditionally
    // to avoid deadlocking.
    lock.Notify();
  }
}

void
CompositorBridgeChild::PostponeMessagesIfAsyncPainting()
{
  MOZ_ASSERT(NS_IsMainThread());

  MonitorAutoLock lock(mPaintLock);

  MOZ_ASSERT(!mIsWaitingForPaint);

  if (mOutstandingAsyncPaints > 0) {
    mIsWaitingForPaint = true;
    GetIPCChannel()->BeginPostponingSends();
  }
}

void
CompositorBridgeChild::ResumeIPCAfterAsyncPaint()
{
  // Note: the caller is responsible for holding the lock.
  mPaintLock.AssertCurrentThreadOwns();
  MOZ_ASSERT(PaintThread::IsOnPaintThread());
  MOZ_ASSERT(mOutstandingAsyncPaints == 0);
  MOZ_ASSERT(mIsWaitingForPaint);

  mIsWaitingForPaint = false;

  // It's also possible that the channel has shut down already.
  if (!mCanSend || mActorDestroyed) {
    return;
  }

  GetIPCChannel()->StopPostponingSends();
}

void
CompositorBridgeChild::FlushAsyncPaints()
{
  MOZ_ASSERT(NS_IsMainThread());

  MonitorAutoLock lock(mPaintLock);
  while (mIsWaitingForPaint) {
    lock.Wait();
  }
}

} // namespace layers
} // namespace mozilla
