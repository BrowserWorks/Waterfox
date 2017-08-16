/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: sw=2 ts=8 et :
 */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef MOZILLA_GFX_VR_VRMANAGERPARENT_H
#define MOZILLA_GFX_VR_VRMANAGERPARENT_H

#include "mozilla/layers/CompositableTransactionParent.h"
#include "mozilla/layers/CompositorThread.h" // for CompositorThreadHolder
#include "mozilla/gfx/PVRManagerParent.h" // for PVRManagerParent
#include "mozilla/gfx/PVRLayerParent.h"   // for PVRLayerParent
#include "mozilla/ipc/ProtocolUtils.h"    // for IToplevelProtocol
#include "mozilla/TimeStamp.h"            // for TimeStamp
#include "gfxVR.h"                        // for VRFieldOfView

namespace mozilla {
using namespace layers;
namespace gfx {

class VRManager;

namespace impl {
class VRDisplayPuppet;
class VRControllerPuppet;
} // namespace impl

class VRManagerParent final : public PVRManagerParent
                            , public HostIPCAllocator
                            , public ShmemAllocator
{
public:
  explicit VRManagerParent(ProcessId aChildProcessId, bool aIsContentChild);

  static VRManagerParent* CreateSameProcess();
  static bool CreateForGPUProcess(Endpoint<PVRManagerParent>&& aEndpoint);
  static bool CreateForContent(Endpoint<PVRManagerParent>&& aEndpoint);

  virtual base::ProcessId GetChildProcessId() override;

  // ShmemAllocator

  virtual ShmemAllocator* AsShmemAllocator() override { return this; }

  virtual bool AllocShmem(size_t aSize,
    ipc::SharedMemory::SharedMemoryType aType,
    ipc::Shmem* aShmem) override;

  virtual bool AllocUnsafeShmem(size_t aSize,
    ipc::SharedMemory::SharedMemoryType aType,
    ipc::Shmem* aShmem) override;

  virtual void DeallocShmem(ipc::Shmem& aShmem) override;

  virtual bool IsSameProcess() const override;
  bool HaveEventListener();
  bool HaveControllerListener();

  virtual void NotifyNotUsed(PTextureParent* aTexture, uint64_t aTransactionId) override;
  virtual void SendAsyncMessage(const InfallibleTArray<AsyncParentMessageData>& aMessage) override;
  bool SendGamepadUpdate(const GamepadChangeEvent& aGamepadEvent);
  bool SendReplyGamepadVibrateHaptic(const uint32_t& aPromiseID);

protected:
  ~VRManagerParent();

  virtual PTextureParent* AllocPTextureParent(const SurfaceDescriptor& aSharedData,
                                              const LayersBackend& aLayersBackend,
                                              const TextureFlags& aFlags,
                                              const uint64_t& aSerial) override;
  virtual bool DeallocPTextureParent(PTextureParent* actor) override;

  virtual PVRLayerParent* AllocPVRLayerParent(const uint32_t& aDisplayID,
                                              const float& aLeftEyeX,
                                              const float& aLeftEyeY,
                                              const float& aLeftEyeWidth,
                                              const float& aLeftEyeHeight,
                                              const float& aRightEyeX,
                                              const float& aRightEyeY,
                                              const float& aRightEyeWidth,
                                              const float& aRightEyeHeight,
                                              const uint32_t& aGroup) override;
  virtual bool DeallocPVRLayerParent(PVRLayerParent* actor) override;

  virtual void ActorDestroy(ActorDestroyReason why) override;
  void OnChannelConnected(int32_t pid) override;

  virtual mozilla::ipc::IPCResult RecvRefreshDisplays() override;
  virtual mozilla::ipc::IPCResult RecvResetSensor(const uint32_t& aDisplayID) override;
  virtual mozilla::ipc::IPCResult RecvSetGroupMask(const uint32_t& aDisplayID, const uint32_t& aGroupMask) override;
  virtual mozilla::ipc::IPCResult RecvSetHaveEventListener(const bool& aHaveEventListener) override;
  virtual mozilla::ipc::IPCResult RecvControllerListenerAdded() override;
  virtual mozilla::ipc::IPCResult RecvControllerListenerRemoved() override;
  virtual mozilla::ipc::IPCResult RecvVibrateHaptic(const uint32_t& aControllerIdx, const uint32_t& aHapticIndex,
                                                    const double& aIntensity, const double& aDuration, const uint32_t& aPromiseID) override;
  virtual mozilla::ipc::IPCResult RecvStopVibrateHaptic(const uint32_t& aControllerIdx) override;
  virtual mozilla::ipc::IPCResult RecvCreateVRTestSystem() override;
  virtual mozilla::ipc::IPCResult RecvCreateVRServiceTestDisplay(const nsCString& aID, const uint32_t& aPromiseID) override;
  virtual mozilla::ipc::IPCResult RecvCreateVRServiceTestController(const nsCString& aID, const uint32_t& aPromiseID) override;
  virtual mozilla::ipc::IPCResult RecvSetDisplayInfoToMockDisplay(const uint32_t& aDeviceID,
                                                                  const VRDisplayInfo& aDisplayInfo) override;
  virtual mozilla::ipc::IPCResult RecvSetSensorStateToMockDisplay(const uint32_t& aDeviceID,
                                                                  const VRHMDSensorState& aSensorState) override;
  virtual mozilla::ipc::IPCResult RecvNewButtonEventToMockController(const uint32_t& aDeviceID, const long& aButton,
                                                                     const bool& aPressed) override;
  virtual mozilla::ipc::IPCResult RecvNewAxisMoveEventToMockController(const uint32_t& aDeviceID, const long& aAxis,
                                                                       const double& aValue) override;
  virtual mozilla::ipc::IPCResult RecvNewPoseMoveToMockController(const uint32_t& aDeviceID, const GamepadPoseState& pose) override;

private:
  void RegisterWithManager();
  void UnregisterFromManager();

  void Bind(Endpoint<PVRManagerParent>&& aEndpoint);

  static void RegisterVRManagerInCompositorThread(VRManagerParent* aVRManager);

  void DeferredDestroy();

  // This keeps us alive until ActorDestroy(), at which point we do a
  // deferred destruction of ourselves.
  RefPtr<VRManagerParent> mSelfRef;

  // Keep the compositor thread alive, until we have destroyed ourselves.
  RefPtr<layers::CompositorThreadHolder> mCompositorThreadHolder;

  // Keep the VRManager alive, until we have destroyed ourselves.
  RefPtr<VRManager> mVRManagerHolder;
  nsRefPtrHashtable<nsUint32HashKey, impl::VRDisplayPuppet> mVRDisplayTests;
  nsRefPtrHashtable<nsUint32HashKey, impl::VRControllerPuppet> mVRControllerTests;
  uint32_t mDisplayTestID;
  uint32_t mControllerTestID;
  bool mHaveEventListener;
  bool mHaveControllerListener;
  bool mIsContentChild;
};

} // namespace mozilla
} // namespace gfx

#endif // MOZILLA_GFX_VR_VRMANAGERPARENT_H
