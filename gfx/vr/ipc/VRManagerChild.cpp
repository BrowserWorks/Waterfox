/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: sw=2 ts=8 et :
 */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "VRManagerChild.h"
#include "VRManagerParent.h"
#include "VRDisplayClient.h"
#include "nsGlobalWindow.h"
#include "mozilla/StaticPtr.h"
#include "mozilla/layers/CompositorThread.h" // for CompositorThread
#include "mozilla/dom/Navigator.h"
#include "mozilla/dom/VREventObserver.h"
#include "mozilla/dom/WindowBinding.h" // for FrameRequestCallback
#include "mozilla/dom/ContentChild.h"
#include "mozilla/layers/TextureClient.h"
#include "nsContentUtils.h"
#include "mozilla/dom/GamepadManager.h"
#include "mozilla/dom/VRServiceTest.h"

using layers::TextureClient;

namespace {
const nsTArray<RefPtr<dom::VREventObserver>>::index_type kNoIndex =
  nsTArray<RefPtr<dom::VREventObserver> >::NoIndex;
} // namespace

namespace mozilla {
namespace gfx {

static StaticRefPtr<VRManagerChild> sVRManagerChildSingleton;
static StaticRefPtr<VRManagerParent> sVRManagerParentSingleton;

void ReleaseVRManagerParentSingleton() {
  sVRManagerParentSingleton = nullptr;
}

VRManagerChild::VRManagerChild()
  : TextureForwarder()
  , mDisplaysInitialized(false)
  , mMessageLoop(MessageLoop::current())
  , mFrameRequestCallbackCounter(0)
  , mBackend(layers::LayersBackend::LAYERS_NONE)
  , mPromiseID(0)
  , mVRMockDisplay(nullptr)
{
  MOZ_ASSERT(NS_IsMainThread());

  mStartTimeStamp = TimeStamp::Now();
}

VRManagerChild::~VRManagerChild()
{
  MOZ_ASSERT(NS_IsMainThread());
}

/*static*/ void
VRManagerChild::IdentifyTextureHost(const TextureFactoryIdentifier& aIdentifier)
{
  if (sVRManagerChildSingleton) {
    sVRManagerChildSingleton->mBackend = aIdentifier.mParentBackend;
    sVRManagerChildSingleton->mSyncObject = SyncObject::CreateSyncObject(aIdentifier.mSyncHandle);
  }
}

layers::LayersBackend
VRManagerChild::GetBackendType() const
{
  return mBackend;
}

/*static*/ VRManagerChild*
VRManagerChild::Get()
{
  MOZ_ASSERT(sVRManagerChildSingleton);
  return sVRManagerChildSingleton;
}

/* static */ bool
VRManagerChild::IsCreated()
{
  return !!sVRManagerChildSingleton;
}

/* static */ bool
VRManagerChild::InitForContent(Endpoint<PVRManagerChild>&& aEndpoint)
{
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(!sVRManagerChildSingleton);

  RefPtr<VRManagerChild> child(new VRManagerChild());
  if (!aEndpoint.Bind(child)) {
    NS_RUNTIMEABORT("Couldn't Open() Compositor channel.");
    return false;
  }
  sVRManagerChildSingleton = child;
  return true;
}

/* static */ bool
VRManagerChild::ReinitForContent(Endpoint<PVRManagerChild>&& aEndpoint)
{
  MOZ_ASSERT(NS_IsMainThread());

  ShutDown();

  return InitForContent(Move(aEndpoint));
}

/*static*/ void
VRManagerChild::InitSameProcess()
{
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(!sVRManagerChildSingleton);

  sVRManagerChildSingleton = new VRManagerChild();
  sVRManagerParentSingleton = VRManagerParent::CreateSameProcess();
  sVRManagerChildSingleton->Open(sVRManagerParentSingleton->GetIPCChannel(),
                                 mozilla::layers::CompositorThreadHolder::Loop(),
                                 mozilla::ipc::ChildSide);
}

/* static */ void
VRManagerChild::InitWithGPUProcess(Endpoint<PVRManagerChild>&& aEndpoint)
{
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(!sVRManagerChildSingleton);

  sVRManagerChildSingleton = new VRManagerChild();
  if (!aEndpoint.Bind(sVRManagerChildSingleton)) {
    NS_RUNTIMEABORT("Couldn't Open() Compositor channel.");
    return;
  }
}

/*static*/ void
VRManagerChild::ShutDown()
{
  MOZ_ASSERT(NS_IsMainThread());
  if (sVRManagerChildSingleton) {
    sVRManagerChildSingleton->Destroy();
    sVRManagerChildSingleton = nullptr;
  }
}

/*static*/ void
VRManagerChild::DeferredDestroy(RefPtr<VRManagerChild> aVRManagerChild)
{
  aVRManagerChild->Close();
}

void
VRManagerChild::Destroy()
{
  mTexturesWaitingRecycled.Clear();

  // Keep ourselves alive until everything has been shut down
  RefPtr<VRManagerChild> selfRef = this;

  // The DeferredDestroyVRManager task takes ownership of
  // the VRManagerChild and will release it when it runs.
  MessageLoop::current()->PostTask(
             NewRunnableFunction(DeferredDestroy, selfRef));
}

layers::PTextureChild*
VRManagerChild::AllocPTextureChild(const SurfaceDescriptor&,
                                   const LayersBackend&,
                                   const TextureFlags&,
                                   const uint64_t&)
{
  return TextureClient::CreateIPDLActor();
}

bool
VRManagerChild::DeallocPTextureChild(PTextureChild* actor)
{
  return TextureClient::DestroyIPDLActor(actor);
}

PVRLayerChild*
VRManagerChild::AllocPVRLayerChild(const uint32_t& aDisplayID,
                                   const float& aLeftEyeX,
                                   const float& aLeftEyeY,
                                   const float& aLeftEyeWidth,
                                   const float& aLeftEyeHeight,
                                   const float& aRightEyeX,
                                   const float& aRightEyeY,
                                   const float& aRightEyeWidth,
                                   const float& aRightEyeHeight,
                                   const uint32_t& aGroup)
{
  return VRLayerChild::CreateIPDLActor();
}

bool
VRManagerChild::DeallocPVRLayerChild(PVRLayerChild* actor)
{
  return VRLayerChild::DestroyIPDLActor(actor);
}

void
VRManagerChild::UpdateDisplayInfo(nsTArray<VRDisplayInfo>& aDisplayUpdates)
{
  nsTArray<uint32_t> disconnectedDisplays;
  nsTArray<uint32_t> connectedDisplays;

  // Check if any displays have been disconnected
  for (auto& display : mDisplays) {
    bool found = false;
    for (auto& displayUpdate : aDisplayUpdates) {
      if (display->GetDisplayInfo().GetDisplayID() == displayUpdate.GetDisplayID()) {
        found = true;
        break;
      }
    }
    if (!found) {
      display->NotifyDisconnected();
      disconnectedDisplays.AppendElement(display->GetDisplayInfo().GetDisplayID());
    }
  }

  // mDisplays could be a hashed container for more scalability, but not worth
  // it now as we expect < 10 entries.
  nsTArray<RefPtr<VRDisplayClient>> displays;
  for (VRDisplayInfo& displayUpdate : aDisplayUpdates) {
    bool isNewDisplay = true;
    for (auto& display : mDisplays) {
      const VRDisplayInfo& prevInfo = display->GetDisplayInfo();
      if (prevInfo.GetDisplayID() == displayUpdate.GetDisplayID()) {
        if (displayUpdate.GetIsConnected() && !prevInfo.GetIsConnected()) {
          connectedDisplays.AppendElement(displayUpdate.GetDisplayID());
        }
        if (!displayUpdate.GetIsConnected() && prevInfo.GetIsConnected()) {
          disconnectedDisplays.AppendElement(displayUpdate.GetDisplayID());
        }
        display->UpdateDisplayInfo(displayUpdate);
        displays.AppendElement(display);
        isNewDisplay = false;
        break;
      }
    }
    if (isNewDisplay) {
      displays.AppendElement(new VRDisplayClient(displayUpdate));
      connectedDisplays.AppendElement(displayUpdate.GetDisplayID());
    }
  }

  mDisplays = displays;

  // We wish to fire the events only after mDisplays is updated
  for (uint32_t displayID : disconnectedDisplays) {
    FireDOMVRDisplayDisconnectEvent(displayID);
  }

  for (uint32_t displayID : connectedDisplays) {
    FireDOMVRDisplayConnectEvent(displayID);
  }

  mDisplaysInitialized = true;
}

mozilla::ipc::IPCResult
VRManagerChild::RecvUpdateDisplayInfo(nsTArray<VRDisplayInfo>&& aDisplayUpdates)
{
  UpdateDisplayInfo(aDisplayUpdates);
  for (auto& windowId : mNavigatorCallbacks) {
    /** We must call NotifyVRDisplaysUpdated for every
     * window's Navigator in mNavigatorCallbacks to ensure that
     * the promise returned by Navigator.GetVRDevices
     * can resolve.  This must happen even if no changes
     * to VRDisplays have been detected here.
     */
    nsGlobalWindow* window = nsGlobalWindow::GetInnerWindowWithId(windowId);
    if (!window) {
      continue;
    }
    dom::Navigator* nav = window->Navigator();
    if (!nav) {
      continue;
    }
    nav->NotifyVRDisplaysUpdated();
  }
  mNavigatorCallbacks.Clear();
  return IPC_OK();
}

bool
VRManagerChild::GetVRDisplays(nsTArray<RefPtr<VRDisplayClient>>& aDisplays)
{
  aDisplays = mDisplays;
  return true;
}

bool
VRManagerChild::RefreshVRDisplaysWithCallback(uint64_t aWindowId)
{
  bool success = SendRefreshDisplays();
  if (success) {
    mNavigatorCallbacks.AppendElement(aWindowId);
  }
  return success;
}

void
VRManagerChild::CreateVRServiceTestDisplay(const nsCString& aID, dom::Promise* aPromise)
{
  SendCreateVRServiceTestDisplay(aID, mPromiseID);
  mPromiseList.Put(mPromiseID, aPromise);
  ++mPromiseID;
}

void
VRManagerChild::CreateVRServiceTestController(const nsCString& aID, dom::Promise* aPromise)
{
  SendCreateVRServiceTestController(aID, mPromiseID);
  mPromiseList.Put(mPromiseID, aPromise);
  ++mPromiseID;
}

mozilla::ipc::IPCResult
VRManagerChild::RecvParentAsyncMessages(InfallibleTArray<AsyncParentMessageData>&& aMessages)
{
  for (InfallibleTArray<AsyncParentMessageData>::index_type i = 0; i < aMessages.Length(); ++i) {
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

PTextureChild*
VRManagerChild::CreateTexture(const SurfaceDescriptor& aSharedData,
                              LayersBackend aLayersBackend,
                              TextureFlags aFlags,
                              uint64_t aSerial,
                              wr::MaybeExternalImageId& aExternalImageId,
                              nsIEventTarget* aTarget)
{
  return SendPTextureConstructor(aSharedData, aLayersBackend, aFlags, aSerial);
}

void
VRManagerChild::CancelWaitForRecycle(uint64_t aTextureId)
{
  RefPtr<TextureClient> client = mTexturesWaitingRecycled.Get(aTextureId);
  if (!client) {
    return;
  }
  mTexturesWaitingRecycled.Remove(aTextureId);
}

void
VRManagerChild::NotifyNotUsed(uint64_t aTextureId, uint64_t aFwdTransactionId)
{
  RefPtr<TextureClient> client = mTexturesWaitingRecycled.Get(aTextureId);
  if (!client) {
    return;
  }
  mTexturesWaitingRecycled.Remove(aTextureId);
}

bool
VRManagerChild::AllocShmem(size_t aSize,
                           ipc::SharedMemory::SharedMemoryType aType,
                           ipc::Shmem* aShmem)
{
  return PVRManagerChild::AllocShmem(aSize, aType, aShmem);
}

bool
VRManagerChild::AllocUnsafeShmem(size_t aSize,
                                 ipc::SharedMemory::SharedMemoryType aType,
                                 ipc::Shmem* aShmem)
{
  return PVRManagerChild::AllocUnsafeShmem(aSize, aType, aShmem);
}

bool
VRManagerChild::DeallocShmem(ipc::Shmem& aShmem)
{
  return PVRManagerChild::DeallocShmem(aShmem);
}

PVRLayerChild*
VRManagerChild::CreateVRLayer(uint32_t aDisplayID,
                              const Rect& aLeftEyeRect,
                              const Rect& aRightEyeRect,
                              nsIEventTarget* aTarget,
                              uint32_t aGroup)
{
  PVRLayerChild* vrLayerChild = AllocPVRLayerChild(aDisplayID, aLeftEyeRect.x,
                                                   aLeftEyeRect.y, aLeftEyeRect.width,
                                                   aLeftEyeRect.height, aRightEyeRect.x,
                                                   aRightEyeRect.y, aRightEyeRect.width,
                                                   aRightEyeRect.height,
                                                   aGroup);
  // Do the DOM labeling.
  if (aTarget) {
    SetEventTargetForActor(vrLayerChild, aTarget);
    MOZ_ASSERT(vrLayerChild->GetActorEventTarget());
  }
  return SendPVRLayerConstructor(vrLayerChild, aDisplayID, aLeftEyeRect.x,
                                 aLeftEyeRect.y, aLeftEyeRect.width,
                                 aLeftEyeRect.height, aRightEyeRect.x,
                                 aRightEyeRect.y, aRightEyeRect.width,
                                 aRightEyeRect.height,
                                 aGroup);
}


// XXX TODO - VRManagerChild::FrameRequest is the same as nsIDocument::FrameRequest, should we consolodate these?
struct VRManagerChild::FrameRequest
{
  FrameRequest(mozilla::dom::FrameRequestCallback& aCallback,
    int32_t aHandle) :
    mCallback(&aCallback),
    mHandle(aHandle)
  {}

  // Conversion operator so that we can append these to a
  // FrameRequestCallbackList
  operator const RefPtr<mozilla::dom::FrameRequestCallback>& () const {
    return mCallback;
  }

  // Comparator operators to allow RemoveElementSorted with an
  // integer argument on arrays of FrameRequest
  bool operator==(int32_t aHandle) const {
    return mHandle == aHandle;
  }
  bool operator<(int32_t aHandle) const {
    return mHandle < aHandle;
  }

  RefPtr<mozilla::dom::FrameRequestCallback> mCallback;
  int32_t mHandle;
};

nsresult
VRManagerChild::ScheduleFrameRequestCallback(mozilla::dom::FrameRequestCallback& aCallback,
                                             int32_t *aHandle)
{
  if (mFrameRequestCallbackCounter == INT32_MAX) {
    // Can't increment without overflowing; bail out
    return NS_ERROR_NOT_AVAILABLE;
  }
  int32_t newHandle = ++mFrameRequestCallbackCounter;

  DebugOnly<FrameRequest*> request =
    mFrameRequestCallbacks.AppendElement(FrameRequest(aCallback, newHandle));
  NS_ASSERTION(request, "This is supposed to be infallible!");

  *aHandle = newHandle;
  return NS_OK;
}

void
VRManagerChild::CancelFrameRequestCallback(int32_t aHandle)
{
  // mFrameRequestCallbacks is stored sorted by handle
  mFrameRequestCallbacks.RemoveElementSorted(aHandle);
}

mozilla::ipc::IPCResult
VRManagerChild::RecvGamepadUpdate(const GamepadChangeEvent& aGamepadEvent)
{
  // VRManagerChild could be at other processes, but GamepadManager
  // only exists at the content process or the same process
  // in non-e10s mode.
  MOZ_ASSERT(XRE_IsContentProcess() || IsSameProcess());

  RefPtr<GamepadManager> gamepadManager(GamepadManager::GetService());
  if (gamepadManager) {
    gamepadManager->Update(aGamepadEvent);
  }

  return IPC_OK();
}

mozilla::ipc::IPCResult
VRManagerChild::RecvReplyCreateVRServiceTestDisplay(const nsCString& aID,
                                                    const uint32_t& aPromiseID,
                                                    const uint32_t& aDeviceID)
{
  RefPtr<dom::Promise> p;
  if (!mPromiseList.Get(aPromiseID, getter_AddRefs(p))) {
    MOZ_CRASH("We should always have a promise.");
  }

  // We only allow one VRMockDisplay in VR tests.
  if (!mVRMockDisplay) {
    mVRMockDisplay = new VRMockDisplay(aID, aDeviceID);
  }
  p->MaybeResolve(mVRMockDisplay);
  mPromiseList.Remove(aPromiseID);
  return IPC_OK();
}

mozilla::ipc::IPCResult
VRManagerChild::RecvReplyCreateVRServiceTestController(const nsCString& aID,
                                                       const uint32_t& aPromiseID,
                                                       const uint32_t& aDeviceID)
{
  RefPtr<dom::Promise> p;
  if (!mPromiseList.Get(aPromiseID, getter_AddRefs(p))) {
    MOZ_CRASH("We should always have a promise.");
  }

  p->MaybeResolve(new VRMockController(aID, aDeviceID));
  mPromiseList.Remove(aPromiseID);
  return IPC_OK();
}

void
VRManagerChild::RunFrameRequestCallbacks()
{
  TimeStamp nowTime = TimeStamp::Now();
  mozilla::TimeDuration duration = nowTime - mStartTimeStamp;
  DOMHighResTimeStamp timeStamp = duration.ToMilliseconds();


  nsTArray<FrameRequest> callbacks;
  callbacks.AppendElements(mFrameRequestCallbacks);
  mFrameRequestCallbacks.Clear();
  for (auto& callback : callbacks) {
    callback.mCallback->Call(timeStamp);
  }
}

void
VRManagerChild::FireDOMVRDisplayMountedEvent(uint32_t aDisplayID)
{
  nsContentUtils::AddScriptRunner(NewRunnableMethod<uint32_t>(
    "gfx::VRManagerChild::FireDOMVRDisplayMountedEventInternal",
    this,
    &VRManagerChild::FireDOMVRDisplayMountedEventInternal,
    aDisplayID));
}

void
VRManagerChild::FireDOMVRDisplayUnmountedEvent(uint32_t aDisplayID)
{
  nsContentUtils::AddScriptRunner(NewRunnableMethod<uint32_t>(
    "gfx::VRManagerChild::FireDOMVRDisplayUnmountedEventInternal",
    this,
    &VRManagerChild::FireDOMVRDisplayUnmountedEventInternal,
    aDisplayID));
}

void
VRManagerChild::FireDOMVRDisplayConnectEvent(uint32_t aDisplayID)
{
  nsContentUtils::AddScriptRunner(NewRunnableMethod<uint32_t>(
    "gfx::VRManagerChild::FireDOMVRDisplayConnectEventInternal",
    this,
    &VRManagerChild::FireDOMVRDisplayConnectEventInternal,
    aDisplayID));
}

void
VRManagerChild::FireDOMVRDisplayDisconnectEvent(uint32_t aDisplayID)
{
  nsContentUtils::AddScriptRunner(NewRunnableMethod<uint32_t>(
    "gfx::VRManagerChild::FireDOMVRDisplayDisconnectEventInternal",
    this,
    &VRManagerChild::FireDOMVRDisplayDisconnectEventInternal,
    aDisplayID));
}

void
VRManagerChild::FireDOMVRDisplayPresentChangeEvent(uint32_t aDisplayID)
{
  nsContentUtils::AddScriptRunner(NewRunnableMethod<uint32_t>(
    "gfx::VRManagerChild::FireDOMVRDisplayPresentChangeEventInternal",
    this,
    &VRManagerChild::FireDOMVRDisplayPresentChangeEventInternal,
    aDisplayID));
}

void
VRManagerChild::FireDOMVRDisplayMountedEventInternal(uint32_t aDisplayID)
{
  // Iterate over a copy of mListeners, as dispatched events may modify it.
  nsTArray<RefPtr<dom::VREventObserver>> listeners;
  listeners = mListeners;
  for (auto& listener : listeners) {
    listener->NotifyVRDisplayMounted(aDisplayID);
  }
}

void
VRManagerChild::FireDOMVRDisplayUnmountedEventInternal(uint32_t aDisplayID)
{
  // Iterate over a copy of mListeners, as dispatched events may modify it.
  nsTArray<RefPtr<dom::VREventObserver>> listeners;
  listeners = mListeners;
  for (auto& listener : listeners) {
    listener->NotifyVRDisplayUnmounted(aDisplayID);
  }
}

void
VRManagerChild::FireDOMVRDisplayConnectEventInternal(uint32_t aDisplayID)
{
  // Iterate over a copy of mListeners, as dispatched events may modify it.
  nsTArray<RefPtr<dom::VREventObserver>> listeners;
  listeners = mListeners;
  for (auto& listener : listeners) {
    listener->NotifyVRDisplayConnect(aDisplayID);
  }
}

void
VRManagerChild::FireDOMVRDisplayDisconnectEventInternal(uint32_t aDisplayID)
{
  // Iterate over a copy of mListeners, as dispatched events may modify it.
  nsTArray<RefPtr<dom::VREventObserver>> listeners;
  listeners = mListeners;
  for (auto& listener : listeners) {
    listener->NotifyVRDisplayDisconnect(aDisplayID);
  }
}

void
VRManagerChild::FireDOMVRDisplayPresentChangeEventInternal(uint32_t aDisplayID)
{
  // Iterate over a copy of mListeners, as dispatched events may modify it.
  nsTArray<RefPtr<dom::VREventObserver>> listeners;
  listeners = mListeners;
  for (auto& listener : listeners) {
    listener->NotifyVRDisplayPresentChange(aDisplayID);
  }
}

void
VRManagerChild::AddListener(dom::VREventObserver* aObserver)
{
  MOZ_ASSERT(aObserver);

  if (mListeners.IndexOf(aObserver) != kNoIndex) {
    return; // already exists
  }

  mListeners.AppendElement(aObserver);
  if (mListeners.Length() == 1) {
    Unused << SendSetHaveEventListener(true);
  }
}

void
VRManagerChild::RemoveListener(dom::VREventObserver* aObserver)
{
  MOZ_ASSERT(aObserver);

  mListeners.RemoveElement(aObserver);
  if (mListeners.IsEmpty()) {
    Unused << SendSetHaveEventListener(false);
  }
}

void
VRManagerChild::HandleFatalError(const char* aName, const char* aMsg) const
{
  dom::ContentChild::FatalErrorIfNotUsingGPUProcess(aName, aMsg, OtherPid());
}

void
VRManagerChild::AddPromise(const uint32_t& aID, dom::Promise* aPromise)
{
  MOZ_ASSERT(!mGamepadPromiseList.Get(aID, nullptr));
  mGamepadPromiseList.Put(aID, aPromise);
}

mozilla::ipc::IPCResult
VRManagerChild::RecvReplyGamepadVibrateHaptic(const uint32_t& aPromiseID)
{
  // VRManagerChild could be at other processes, but GamepadManager
  // only exists at the content process or the same process
  // in non-e10s mode.
  MOZ_ASSERT(XRE_IsContentProcess() || IsSameProcess());

  RefPtr<dom::Promise> p;
  if (!mGamepadPromiseList.Get(aPromiseID, getter_AddRefs(p))) {
    MOZ_CRASH("We should always have a promise.");
  }

  p->MaybeResolve(true);
  mGamepadPromiseList.Remove(aPromiseID);
  return IPC_OK();
}

mozilla::ipc::IPCResult
VRManagerChild::RecvDispatchSubmitFrameResult(const uint32_t& aDisplayID,
                                              const VRSubmitFrameResultInfo& aResult)
{
   for (auto& display : mDisplays) {
    if (display->GetDisplayInfo().GetDisplayID() == aDisplayID) {
      display->UpdateSubmitFrameResult(aResult);
    }
  }

  return IPC_OK();
}

} // namespace gfx
} // namespace mozilla
