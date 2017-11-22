/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set sw=2 ts=2 et tw=80 : */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/layers/CrossProcessCompositorBridgeParent.h"
#include <stdint.h>                     // for uint64_t
#include "LayerTransactionParent.h"     // for LayerTransactionParent
#include "base/message_loop.h"          // for MessageLoop
#include "base/task.h"                  // for CancelableTask, etc
#include "base/thread.h"                // for Thread
#ifdef XP_WIN
#include "mozilla/gfx/DeviceManagerDx.h"// for DeviceManagerDx
#endif
#include "mozilla/ipc/Transport.h"      // for Transport
#include "mozilla/layers/AnimationHelper.h" // for CompositorAnimationStorage
#include "mozilla/layers/APZCTreeManager.h"  // for APZCTreeManager
#include "mozilla/layers/APZCTreeManagerParent.h"  // for APZCTreeManagerParent
#include "mozilla/layers/APZThreadUtils.h"  // for APZCTreeManager
#include "mozilla/layers/AsyncCompositionManager.h"
#include "mozilla/layers/CompositorOptions.h"
#include "mozilla/layers/CompositorThread.h"
#include "mozilla/layers/LayerManagerComposite.h"
#include "mozilla/layers/LayerTreeOwnerTracker.h"
#include "mozilla/layers/PLayerTransactionParent.h"
#include "mozilla/layers/RemoteContentController.h"
#include "mozilla/layers/WebRenderBridgeParent.h"
#include "mozilla/layers/AsyncImagePipelineManager.h"
#include "mozilla/mozalloc.h"           // for operator new, etc
#include "nsDebug.h"                    // for NS_ASSERTION, etc
#include "nsTArray.h"                   // for nsTArray
#include "nsXULAppAPI.h"                // for XRE_GetIOMessageLoop
#include "mozilla/Unused.h"
#include "mozilla/StaticPtr.h"

using namespace std;

namespace mozilla {

namespace layers {

// defined in CompositorBridgeParent.cpp
typedef map<uint64_t, CompositorBridgeParent::LayerTreeState> LayerTreeMap;
extern LayerTreeMap sIndirectLayerTrees;
extern StaticAutoPtr<mozilla::Monitor> sIndirectLayerTreesLock;
void UpdateIndirectTree(uint64_t aId, Layer* aRoot, const TargetConfig& aTargetConfig);
void EraseLayerState(uint64_t aId);

mozilla::ipc::IPCResult
CrossProcessCompositorBridgeParent::RecvRequestNotifyAfterRemotePaint()
{
  mNotifyAfterRemotePaint = true;
  return IPC_OK();
}

void
CrossProcessCompositorBridgeParent::ActorDestroy(ActorDestroyReason aWhy)
{
  mCanSend = false;

  // We must keep this object alive untill the code handling message
  // reception is finished on this thread.
  MessageLoop::current()->PostTask(NewRunnableMethod(
    "layers::CrossProcessCompositorBridgeParent::DeferredDestroy",
    this,
    &CrossProcessCompositorBridgeParent::DeferredDestroy));
}

PLayerTransactionParent*
CrossProcessCompositorBridgeParent::AllocPLayerTransactionParent(
  const nsTArray<LayersBackend>&,
  const uint64_t& aId)
{
  MOZ_ASSERT(aId != 0);

  // Check to see if this child process has access to this layer tree.
  if (!LayerTreeOwnerTracker::Get()->IsMapped(aId, OtherPid())) {
    NS_ERROR("Unexpected layers id in AllocPLayerTransactionParent; dropping message...");
    return nullptr;
  }

  MonitorAutoLock lock(*sIndirectLayerTreesLock);

  CompositorBridgeParent::LayerTreeState* state = nullptr;
  LayerTreeMap::iterator itr = sIndirectLayerTrees.find(aId);
  if (sIndirectLayerTrees.end() != itr) {
    state = &itr->second;
  }

  if (state && state->mLayerManager) {
    state->mCrossProcessParent = this;
    HostLayerManager* lm = state->mLayerManager;
    CompositorAnimationStorage* animStorage = state->mParent ? state->mParent->GetAnimationStorage() : nullptr;
    LayerTransactionParent* p = new LayerTransactionParent(lm, this, animStorage, aId);
    p->AddIPDLReference();
    sIndirectLayerTrees[aId].mLayerTree = p;
    return p;
  }

  NS_WARNING("Created child without a matching parent?");
  LayerTransactionParent* p = new LayerTransactionParent(/* aManager */ nullptr, this, /* aAnimStorage */ nullptr, aId);
  p->AddIPDLReference();
  return p;
}

bool
CrossProcessCompositorBridgeParent::DeallocPLayerTransactionParent(PLayerTransactionParent* aLayers)
{
  LayerTransactionParent* slp = static_cast<LayerTransactionParent*>(aLayers);
  EraseLayerState(slp->GetId());
  static_cast<LayerTransactionParent*>(aLayers)->ReleaseIPDLReference();
  return true;
}

PAPZCTreeManagerParent*
CrossProcessCompositorBridgeParent::AllocPAPZCTreeManagerParent(const uint64_t& aLayersId)
{
  // Check to see if this child process has access to this layer tree.
  if (!LayerTreeOwnerTracker::Get()->IsMapped(aLayersId, OtherPid())) {
    NS_ERROR("Unexpected layers id in AllocPAPZCTreeManagerParent; dropping message...");
    return nullptr;
  }

  MonitorAutoLock lock(*sIndirectLayerTreesLock);
  CompositorBridgeParent::LayerTreeState& state = sIndirectLayerTrees[aLayersId];

  // If the widget has shutdown its compositor, we may not have had a chance yet
  // to unmap our layers id, and we could get here without a parent compositor.
  // In this case return an empty APZCTM.
  if (!state.mParent) {
    // Note: we immediately call ClearTree since otherwise the APZCTM will
    // retain a reference to itself, through the checkerboard observer.
    RefPtr<APZCTreeManager> temp = new APZCTreeManager();
    temp->ClearTree();
    return new APZCTreeManagerParent(aLayersId, temp);
  }

  MOZ_ASSERT(!state.mApzcTreeManagerParent);
  state.mApzcTreeManagerParent = new APZCTreeManagerParent(aLayersId, state.mParent->GetAPZCTreeManager());

  return state.mApzcTreeManagerParent;
}
bool
CrossProcessCompositorBridgeParent::DeallocPAPZCTreeManagerParent(PAPZCTreeManagerParent* aActor)
{
  APZCTreeManagerParent* parent = static_cast<APZCTreeManagerParent*>(aActor);

  MonitorAutoLock lock(*sIndirectLayerTreesLock);
  auto iter = sIndirectLayerTrees.find(parent->LayersId());
  if (iter != sIndirectLayerTrees.end()) {
    CompositorBridgeParent::LayerTreeState& state = iter->second;
    MOZ_ASSERT(state.mApzcTreeManagerParent == parent);
    state.mApzcTreeManagerParent = nullptr;
  }

  delete parent;

  return true;
}

PAPZParent*
CrossProcessCompositorBridgeParent::AllocPAPZParent(const uint64_t& aLayersId)
{
  // Check to see if this child process has access to this layer tree.
  if (!LayerTreeOwnerTracker::Get()->IsMapped(aLayersId, OtherPid())) {
    NS_ERROR("Unexpected layers id in AllocPAPZParent; dropping message...");
    return nullptr;
  }

  RemoteContentController* controller = new RemoteContentController();

  // Increment the controller's refcount before we return it. This will keep the
  // controller alive until it is released by IPDL in DeallocPAPZParent.
  controller->AddRef();

  MonitorAutoLock lock(*sIndirectLayerTreesLock);
  CompositorBridgeParent::LayerTreeState& state = sIndirectLayerTrees[aLayersId];
  MOZ_ASSERT(!state.mController);
  state.mController = controller;

  return controller;
}

bool
CrossProcessCompositorBridgeParent::DeallocPAPZParent(PAPZParent* aActor)
{
  RemoteContentController* controller = static_cast<RemoteContentController*>(aActor);
  controller->Release();
  return true;
}

PWebRenderBridgeParent*
CrossProcessCompositorBridgeParent::AllocPWebRenderBridgeParent(const wr::PipelineId& aPipelineId,
                                                                const LayoutDeviceIntSize& aSize,
                                                                TextureFactoryIdentifier* aTextureFactoryIdentifier,
                                                                wr::IdNamespace *aIdNamespace)
{
#ifndef MOZ_BUILD_WEBRENDER
  // Extra guard since this in the parent process and we don't want a malicious
  // child process invoking this codepath before it's ready
  MOZ_RELEASE_ASSERT(false);
#endif
  uint64_t layersId = wr::AsUint64(aPipelineId);
  // Check to see if this child process has access to this layer tree.
  if (!LayerTreeOwnerTracker::Get()->IsMapped(layersId, OtherPid())) {
    NS_ERROR("Unexpected layers id in AllocPAPZCTreeManagerParent; dropping message...");
    return nullptr;
  }

  MonitorAutoLock lock(*sIndirectLayerTreesLock);
  MOZ_ASSERT(sIndirectLayerTrees.find(layersId) != sIndirectLayerTrees.end());
  MOZ_ASSERT(sIndirectLayerTrees[layersId].mWrBridge == nullptr);
  WebRenderBridgeParent* parent = nullptr;
  CompositorBridgeParent* cbp = sIndirectLayerTrees[layersId].mParent;
  if (!cbp) {
    // This could happen when this function is called after CompositorBridgeParent destruction.
    // This was observed during Tab move between different windows.
    NS_WARNING("Created child without a matching parent?");
    parent = WebRenderBridgeParent::CreateDestroyed();
    *aIdNamespace = parent->GetIdNamespace();
    *aTextureFactoryIdentifier = TextureFactoryIdentifier(LayersBackend::LAYERS_NONE);
    return parent;
  }
  WebRenderBridgeParent* root = sIndirectLayerTrees[cbp->RootLayerTreeId()].mWrBridge.get();

  RefPtr<wr::WebRenderAPI> api = root->GetWebRenderAPI();
  RefPtr<AsyncImagePipelineManager> holder = root->AsyncImageManager();
  RefPtr<CompositorAnimationStorage> animStorage = cbp->GetAnimationStorage();
  parent = new WebRenderBridgeParent(this, aPipelineId, nullptr, root->CompositorScheduler(), Move(api), Move(holder), Move(animStorage));

  parent->AddRef(); // IPDL reference
  sIndirectLayerTrees[layersId].mCrossProcessParent = this;
  sIndirectLayerTrees[layersId].mWrBridge = parent;
  *aTextureFactoryIdentifier = parent->GetTextureFactoryIdentifier();
  *aIdNamespace = parent->GetIdNamespace();

  return parent;
}

bool
CrossProcessCompositorBridgeParent::DeallocPWebRenderBridgeParent(PWebRenderBridgeParent* aActor)
{
#ifndef MOZ_BUILD_WEBRENDER
  // Extra guard since this in the parent process and we don't want a malicious
  // child process invoking this codepath before it's ready
  MOZ_RELEASE_ASSERT(false);
#endif
  WebRenderBridgeParent* parent = static_cast<WebRenderBridgeParent*>(aActor);
  EraseLayerState(wr::AsUint64(parent->PipelineId()));
  parent->Release(); // IPDL reference
  return true;
}

mozilla::ipc::IPCResult
CrossProcessCompositorBridgeParent::RecvNotifyChildCreated(const uint64_t& child,
                                                           CompositorOptions* aOptions)
{
  MonitorAutoLock lock(*sIndirectLayerTreesLock);
  for (LayerTreeMap::iterator it = sIndirectLayerTrees.begin();
       it != sIndirectLayerTrees.end(); it++) {
    CompositorBridgeParent::LayerTreeState* lts = &it->second;
    if (lts->mParent && lts->mCrossProcessParent == this) {
      lts->mParent->NotifyChildCreated(child);
      *aOptions = lts->mParent->GetOptions();
      return IPC_OK();
    }
  }
  return IPC_FAIL_NO_REASON(this);
}

mozilla::ipc::IPCResult
CrossProcessCompositorBridgeParent::RecvMapAndNotifyChildCreated(const uint64_t& child,
                                                                 const base::ProcessId& pid,
                                                                 CompositorOptions* aOptions)
{
  // This can only be called from the browser process, as the mapping
  // ensures proper window ownership of layer trees.
  return IPC_FAIL_NO_REASON(this);
}


mozilla::ipc::IPCResult
CrossProcessCompositorBridgeParent::RecvCheckContentOnlyTDR(const uint32_t& sequenceNum,
                                                            bool* isContentOnlyTDR)
{
  *isContentOnlyTDR = false;
#ifdef XP_WIN
  ContentDeviceData compositor;

  DeviceManagerDx* dm = DeviceManagerDx::Get();

  // Check that the D3D11 device sequence numbers match.
  D3D11DeviceStatus status;
  dm->ExportDeviceInfo(&status);

  if (sequenceNum == status.sequenceNumber() && !dm->HasDeviceReset()) {
    *isContentOnlyTDR = true;
  }

#endif
  return IPC_OK();
};

void
CrossProcessCompositorBridgeParent::ShadowLayersUpdated(
  LayerTransactionParent* aLayerTree,
  const TransactionInfo& aInfo,
  bool aHitTestUpdate)
{
  uint64_t id = aLayerTree->GetId();

  MOZ_ASSERT(id != 0);

  CompositorBridgeParent::LayerTreeState* state =
    CompositorBridgeParent::GetIndirectShadowTree(id);
  if (!state) {
    return;
  }
  MOZ_ASSERT(state->mParent);
  state->mParent->ScheduleRotationOnCompositorThread(
    aInfo.targetConfig(),
    aInfo.isFirstPaint());

  Layer* shadowRoot = aLayerTree->GetRoot();
  if (shadowRoot) {
    CompositorBridgeParent::SetShadowProperties(shadowRoot);
  }
  UpdateIndirectTree(id, shadowRoot, aInfo.targetConfig());

  // Cache the plugin data for this remote layer tree
  state->mPluginData = aInfo.plugins();
  state->mUpdatedPluginDataAvailable = true;

  state->mParent->NotifyShadowTreeTransaction(
    id,
    aInfo.isFirstPaint(),
    aInfo.focusTarget(),
    aInfo.scheduleComposite(),
    aInfo.paintSequenceNumber(),
    aInfo.isRepeatTransaction(),
    aHitTestUpdate);

  // Send the 'remote paint ready' message to the content thread if it has already asked.
  if(mNotifyAfterRemotePaint)  {
    Unused << SendRemotePaintIsReady();
    mNotifyAfterRemotePaint = false;
  }

  if (aLayerTree->ShouldParentObserveEpoch()) {
    // Note that we send this through the window compositor, since this needs
    // to reach the widget owning the tab.
    Unused << state->mParent->SendObserveLayerUpdate(id, aLayerTree->GetChildEpoch(), true);
  }

  aLayerTree->SetPendingTransactionId(aInfo.id());
}

void
CrossProcessCompositorBridgeParent::DidComposite(
  uint64_t aId,
  TimeStamp& aCompositeStart,
  TimeStamp& aCompositeEnd)
{
  MonitorAutoLock lock(*sIndirectLayerTreesLock);
  DidCompositeLocked(aId, aCompositeStart, aCompositeEnd);
}

void
CrossProcessCompositorBridgeParent::DidCompositeLocked(
  uint64_t aId,
  TimeStamp& aCompositeStart,
  TimeStamp& aCompositeEnd)
{
  sIndirectLayerTreesLock->AssertCurrentThreadOwns();
  if (LayerTransactionParent *layerTree = sIndirectLayerTrees[aId].mLayerTree) {
    uint64_t transactionId = layerTree->GetPendingTransactionId();
    if (transactionId) {
      Unused << SendDidComposite(aId, transactionId, aCompositeStart, aCompositeEnd);
      layerTree->SetPendingTransactionId(0);
    }
  } else if (WebRenderBridgeParent* wrbridge = sIndirectLayerTrees[aId].mWrBridge) {
    uint64_t transactionId = wrbridge->FlushPendingTransactionIds();
    if (transactionId) {
      Unused << SendDidComposite(aId, transactionId, aCompositeStart, aCompositeEnd);
    }
  }
}

void
CrossProcessCompositorBridgeParent::ForceComposite(LayerTransactionParent* aLayerTree)
{
  uint64_t id = aLayerTree->GetId();
  MOZ_ASSERT(id != 0);
  CompositorBridgeParent* parent;
  { // scope lock
    MonitorAutoLock lock(*sIndirectLayerTreesLock);
    parent = sIndirectLayerTrees[id].mParent;
  }
  if (parent) {
    parent->ForceComposite(aLayerTree);
  }
}

void
CrossProcessCompositorBridgeParent::NotifyClearCachedResources(LayerTransactionParent* aLayerTree)
{
  uint64_t id = aLayerTree->GetId();
  MOZ_ASSERT(id != 0);

  const CompositorBridgeParent::LayerTreeState* state =
    CompositorBridgeParent::GetIndirectShadowTree(id);
  if (state && state->mParent) {
    // Note that we send this through the window compositor, since this needs
    // to reach the widget owning the tab.
    Unused << state->mParent->SendObserveLayerUpdate(id, aLayerTree->GetChildEpoch(), false);
  }
}

bool
CrossProcessCompositorBridgeParent::SetTestSampleTime(const uint64_t& aId,
                                                      const TimeStamp& aTime)
{
  MOZ_ASSERT(aId != 0);
  const CompositorBridgeParent::LayerTreeState* state =
    CompositorBridgeParent::GetIndirectShadowTree(aId);
  if (!state) {
    return false;
  }

  MOZ_ASSERT(state->mParent);
  return state->mParent->SetTestSampleTime(aId, aTime);
}

void
CrossProcessCompositorBridgeParent::LeaveTestMode(const uint64_t& aId)
{
  MOZ_ASSERT(aId != 0);
  const CompositorBridgeParent::LayerTreeState* state =
    CompositorBridgeParent::GetIndirectShadowTree(aId);
  if (!state) {
    return;
  }

  MOZ_ASSERT(state->mParent);
  state->mParent->LeaveTestMode(aId);
}

void
CrossProcessCompositorBridgeParent::ApplyAsyncProperties(
    LayerTransactionParent* aLayerTree)
{
  uint64_t id = aLayerTree->GetId();
  MOZ_ASSERT(id != 0);
  const CompositorBridgeParent::LayerTreeState* state =
    CompositorBridgeParent::GetIndirectShadowTree(id);
  if (!state) {
    return;
  }

  MOZ_ASSERT(state->mParent);
  state->mParent->ApplyAsyncProperties(aLayerTree);
}

void
CrossProcessCompositorBridgeParent::FlushApzRepaints(const uint64_t& aLayersId)
{
  MOZ_ASSERT(aLayersId != 0);
  const CompositorBridgeParent::LayerTreeState* state =
    CompositorBridgeParent::GetIndirectShadowTree(aLayersId);
  if (!state) {
    return;
  }

  MOZ_ASSERT(state->mParent);
  state->mParent->FlushApzRepaints(aLayersId);
}

void
CrossProcessCompositorBridgeParent::GetAPZTestData(
  const uint64_t& aLayersId,
  APZTestData* aOutData)
{
  MOZ_ASSERT(aLayersId != 0);
  MonitorAutoLock lock(*sIndirectLayerTreesLock);
  *aOutData = sIndirectLayerTrees[aLayersId].mApzTestData;
}

void
CrossProcessCompositorBridgeParent::SetConfirmedTargetAPZC(
  const uint64_t& aLayersId,
  const uint64_t& aInputBlockId,
  const nsTArray<ScrollableLayerGuid>& aTargets)
{
  MOZ_ASSERT(aLayersId != 0);
  const CompositorBridgeParent::LayerTreeState* state =
    CompositorBridgeParent::GetIndirectShadowTree(aLayersId);
  if (!state || !state->mParent) {
    return;
  }

  state->mParent->SetConfirmedTargetAPZC(aLayersId, aInputBlockId, aTargets);
}

AsyncCompositionManager*
CrossProcessCompositorBridgeParent::GetCompositionManager(LayerTransactionParent* aLayerTree)
{
  uint64_t id = aLayerTree->GetId();
  const CompositorBridgeParent::LayerTreeState* state =
    CompositorBridgeParent::GetIndirectShadowTree(id);
  if (!state) {
    return nullptr;
  }

  MOZ_ASSERT(state->mParent);
  return state->mParent->GetCompositionManager(aLayerTree);
}

void
CrossProcessCompositorBridgeParent::DeferredDestroy()
{
  mSelfRef = nullptr;
}

CrossProcessCompositorBridgeParent::~CrossProcessCompositorBridgeParent()
{
  MOZ_ASSERT(XRE_GetIOMessageLoop());
}

PTextureParent*
CrossProcessCompositorBridgeParent::AllocPTextureParent(const SurfaceDescriptor& aSharedData,
                                                        const LayersBackend& aLayersBackend,
                                                        const TextureFlags& aFlags,
                                                        const uint64_t& aId,
                                                        const uint64_t& aSerial,
                                                        const wr::MaybeExternalImageId& aExternalImageId)
{
  CompositorBridgeParent::LayerTreeState* state = nullptr;

  LayerTreeMap::iterator itr = sIndirectLayerTrees.find(aId);
  if (sIndirectLayerTrees.end() != itr) {
    state = &itr->second;
  }

  TextureFlags flags = aFlags;

  LayersBackend actualBackend = LayersBackend::LAYERS_NONE;
  if (state && state->mLayerManager) {
    actualBackend = state->mLayerManager->GetBackendType();
  }

  if (!state) {
    // The compositor was recreated, and we're receiving layers updates for a
    // a layer manager that will soon be discarded or invalidated. We can't
    // return null because this will mess up deserialization later and we'll
    // kill the content process. Instead, we signal that the underlying
    // TextureHost should not attempt to access the compositor.
    flags |= TextureFlags::INVALID_COMPOSITOR;
  } else if (actualBackend != LayersBackend::LAYERS_NONE && aLayersBackend != actualBackend) {
    gfxDevCrash(gfx::LogReason::PAllocTextureBackendMismatch) << "Texture backend is wrong";
  }

  return TextureHost::CreateIPDLActor(this, aSharedData, aLayersBackend, aFlags, aSerial, aExternalImageId);
}

bool
CrossProcessCompositorBridgeParent::DeallocPTextureParent(PTextureParent* actor)
{
  return TextureHost::DestroyIPDLActor(actor);
}

bool
CrossProcessCompositorBridgeParent::IsSameProcess() const
{
  return OtherPid() == base::GetCurrentProcId();
}

mozilla::ipc::IPCResult
CrossProcessCompositorBridgeParent::RecvClearApproximatelyVisibleRegions(const uint64_t& aLayersId,
                                                                         const uint32_t& aPresShellId)
{
  CompositorBridgeParent* parent;
  { // scope lock
    MonitorAutoLock lock(*sIndirectLayerTreesLock);
    parent = sIndirectLayerTrees[aLayersId].mParent;
  }
  if (parent) {
    parent->ClearApproximatelyVisibleRegions(aLayersId, Some(aPresShellId));
  }
  return IPC_OK();
}

mozilla::ipc::IPCResult
CrossProcessCompositorBridgeParent::RecvNotifyApproximatelyVisibleRegion(const ScrollableLayerGuid& aGuid,
                                                                         const CSSIntRegion& aRegion)
{
  CompositorBridgeParent* parent;
  { // scope lock
    MonitorAutoLock lock(*sIndirectLayerTreesLock);
    parent = sIndirectLayerTrees[aGuid.mLayersId].mParent;
  }
  if (parent) {
    if (!parent->RecvNotifyApproximatelyVisibleRegion(aGuid, aRegion)) {
      return IPC_FAIL_NO_REASON(this);
    }
    return IPC_OK();;
  }
  return IPC_OK();
}

void
CrossProcessCompositorBridgeParent::UpdatePaintTime(LayerTransactionParent* aLayerTree, const TimeDuration& aPaintTime)
{
  uint64_t id = aLayerTree->GetId();
  MOZ_ASSERT(id != 0);

  CompositorBridgeParent::LayerTreeState* state =
    CompositorBridgeParent::GetIndirectShadowTree(id);
  if (!state || !state->mParent) {
    return;
  }

  state->mParent->UpdatePaintTime(aLayerTree, aPaintTime);
}

void
CrossProcessCompositorBridgeParent::ObserveLayerUpdate(uint64_t aLayersId, uint64_t aEpoch, bool aActive)
{
  MOZ_ASSERT(aLayersId != 0);

  CompositorBridgeParent::LayerTreeState* state =
    CompositorBridgeParent::GetIndirectShadowTree(aLayersId);
  if (!state || !state->mParent) {
    return;
  }

  Unused << state->mParent->SendObserveLayerUpdate(aLayersId, aEpoch, aActive);
}

} // namespace layers
} // namespace mozilla
