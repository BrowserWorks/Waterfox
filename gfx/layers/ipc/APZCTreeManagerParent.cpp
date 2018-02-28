/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=99: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/layers/APZCTreeManagerParent.h"

#include "mozilla/layers/APZCTreeManager.h"
#include "mozilla/layers/APZThreadUtils.h"

namespace mozilla {
namespace layers {

APZCTreeManagerParent::APZCTreeManagerParent(uint64_t aLayersId, RefPtr<APZCTreeManager> aAPZCTreeManager)
  : mLayersId(aLayersId)
  , mTreeManager(aAPZCTreeManager)
{
  MOZ_ASSERT(aAPZCTreeManager != nullptr);
}

APZCTreeManagerParent::~APZCTreeManagerParent()
{
}

void
APZCTreeManagerParent::ChildAdopted(RefPtr<APZCTreeManager> aAPZCTreeManager)
{
  MOZ_ASSERT(aAPZCTreeManager != nullptr);
  mTreeManager = aAPZCTreeManager;
}

mozilla::ipc::IPCResult
APZCTreeManagerParent::RecvReceiveMultiTouchInputEvent(
    const MultiTouchInput& aEvent,
    nsEventStatus* aOutStatus,
    MultiTouchInput* aOutEvent,
    ScrollableLayerGuid* aOutTargetGuid,
    uint64_t* aOutInputBlockId)
{
  MultiTouchInput event = aEvent;

  *aOutStatus = mTreeManager->ReceiveInputEvent(
    event,
    aOutTargetGuid,
    aOutInputBlockId);
  *aOutEvent = event;

  return IPC_OK();
}

mozilla::ipc::IPCResult
APZCTreeManagerParent::RecvReceiveMouseInputEvent(
    const MouseInput& aEvent,
    nsEventStatus* aOutStatus,
    MouseInput* aOutEvent,
    ScrollableLayerGuid* aOutTargetGuid,
    uint64_t* aOutInputBlockId)
{
  MouseInput event = aEvent;

  *aOutStatus = mTreeManager->ReceiveInputEvent(
    event,
    aOutTargetGuid,
    aOutInputBlockId);
  *aOutEvent = event;

  return IPC_OK();
}

mozilla::ipc::IPCResult
APZCTreeManagerParent::RecvReceivePanGestureInputEvent(
    const PanGestureInput& aEvent,
    nsEventStatus* aOutStatus,
    PanGestureInput* aOutEvent,
    ScrollableLayerGuid* aOutTargetGuid,
    uint64_t* aOutInputBlockId)
{
  PanGestureInput event = aEvent;

  *aOutStatus = mTreeManager->ReceiveInputEvent(
    event,
    aOutTargetGuid,
    aOutInputBlockId);
  *aOutEvent = event;

  return IPC_OK();
}

mozilla::ipc::IPCResult
APZCTreeManagerParent::RecvReceivePinchGestureInputEvent(
    const PinchGestureInput& aEvent,
    nsEventStatus* aOutStatus,
    PinchGestureInput* aOutEvent,
    ScrollableLayerGuid* aOutTargetGuid,
    uint64_t* aOutInputBlockId)
{
  PinchGestureInput event = aEvent;

  *aOutStatus = mTreeManager->ReceiveInputEvent(
    event,
    aOutTargetGuid,
    aOutInputBlockId);
  *aOutEvent = event;

  return IPC_OK();
}

mozilla::ipc::IPCResult
APZCTreeManagerParent::RecvReceiveTapGestureInputEvent(
    const TapGestureInput& aEvent,
    nsEventStatus* aOutStatus,
    TapGestureInput* aOutEvent,
    ScrollableLayerGuid* aOutTargetGuid,
    uint64_t* aOutInputBlockId)
{
  TapGestureInput event = aEvent;

  *aOutStatus = mTreeManager->ReceiveInputEvent(
    event,
    aOutTargetGuid,
    aOutInputBlockId);
  *aOutEvent = event;

  return IPC_OK();
}

mozilla::ipc::IPCResult
APZCTreeManagerParent::RecvReceiveScrollWheelInputEvent(
    const ScrollWheelInput& aEvent,
    nsEventStatus* aOutStatus,
    ScrollWheelInput* aOutEvent,
    ScrollableLayerGuid* aOutTargetGuid,
    uint64_t* aOutInputBlockId)
{
  ScrollWheelInput event = aEvent;

  *aOutStatus = mTreeManager->ReceiveInputEvent(
    event,
    aOutTargetGuid,
    aOutInputBlockId);
  *aOutEvent = event;

  return IPC_OK();
}

mozilla::ipc::IPCResult
APZCTreeManagerParent::RecvReceiveKeyboardInputEvent(
        const KeyboardInput& aEvent,
        nsEventStatus* aOutStatus,
        KeyboardInput* aOutEvent,
        ScrollableLayerGuid* aOutTargetGuid,
        uint64_t* aOutInputBlockId)
{
  KeyboardInput event = aEvent;

  *aOutStatus = mTreeManager->ReceiveInputEvent(
    event,
    aOutTargetGuid,
    aOutInputBlockId);
  *aOutEvent = event;

  return IPC_OK();
}

mozilla::ipc::IPCResult
APZCTreeManagerParent::RecvSetKeyboardMap(const KeyboardMap& aKeyboardMap)
{
  mTreeManager->SetKeyboardMap(aKeyboardMap);

  return IPC_OK();
}

mozilla::ipc::IPCResult
APZCTreeManagerParent::RecvZoomToRect(
    const ScrollableLayerGuid& aGuid,
    const CSSRect& aRect,
    const uint32_t& aFlags)
{
  if (aGuid.mLayersId != mLayersId) {
    // Guard against bad data from hijacked child processes
    NS_ERROR("Unexpected layers id in RecvZoomToRect; dropping message...");
    return IPC_FAIL_NO_REASON(this);
  }

  mTreeManager->ZoomToRect(aGuid, aRect, aFlags);
  return IPC_OK();
}

mozilla::ipc::IPCResult
APZCTreeManagerParent::RecvContentReceivedInputBlock(
    const uint64_t& aInputBlockId,
    const bool& aPreventDefault)
{
  APZThreadUtils::RunOnControllerThread(NewRunnableMethod<uint64_t, bool>(
    "layers::IAPZCTreeManager::ContentReceivedInputBlock",
    mTreeManager,
    &IAPZCTreeManager::ContentReceivedInputBlock,
    aInputBlockId,
    aPreventDefault));

  return IPC_OK();
}

mozilla::ipc::IPCResult
APZCTreeManagerParent::RecvSetTargetAPZC(
    const uint64_t& aInputBlockId,
    nsTArray<ScrollableLayerGuid>&& aTargets)
{
  for (size_t i = 0; i < aTargets.Length(); i++) {
    if (aTargets[i].mLayersId != mLayersId) {
      // Guard against bad data from hijacked child processes
      NS_ERROR("Unexpected layers id in RecvSetTargetAPZC; dropping message...");
      return IPC_FAIL_NO_REASON(this);
    }
  }
  APZThreadUtils::RunOnControllerThread(
    NewRunnableMethod<uint64_t,
                      StoreCopyPassByRRef<nsTArray<ScrollableLayerGuid>>>(
      "layers::IAPZCTreeManager::SetTargetAPZC",
      mTreeManager,
      &IAPZCTreeManager::SetTargetAPZC,
      aInputBlockId,
      aTargets));

  return IPC_OK();
}

mozilla::ipc::IPCResult
APZCTreeManagerParent::RecvUpdateZoomConstraints(
    const ScrollableLayerGuid& aGuid,
    const MaybeZoomConstraints& aConstraints)
{
  if (aGuid.mLayersId != mLayersId) {
    // Guard against bad data from hijacked child processes
    NS_ERROR("Unexpected layers id in RecvUpdateZoomConstraints; dropping message...");
    return IPC_FAIL_NO_REASON(this);
  }

  mTreeManager->UpdateZoomConstraints(aGuid, aConstraints);
  return IPC_OK();
}

mozilla::ipc::IPCResult
APZCTreeManagerParent::RecvCancelAnimation(const ScrollableLayerGuid& aGuid)
{
  if (aGuid.mLayersId != mLayersId) {
    // Guard against bad data from hijacked child processes
    NS_ERROR("Unexpected layers id in RecvCancelAnimation; dropping message...");
    return IPC_FAIL_NO_REASON(this);
  }

  mTreeManager->CancelAnimation(aGuid);
  return IPC_OK();
}

mozilla::ipc::IPCResult
APZCTreeManagerParent::RecvSetDPI(const float& aDpiValue)
{
  mTreeManager->SetDPI(aDpiValue);
  return IPC_OK();
}

mozilla::ipc::IPCResult
APZCTreeManagerParent::RecvSetAllowedTouchBehavior(
    const uint64_t& aInputBlockId,
    nsTArray<TouchBehaviorFlags>&& aValues)
{
  APZThreadUtils::RunOnControllerThread(
    NewRunnableMethod<uint64_t,
                      StoreCopyPassByRRef<nsTArray<TouchBehaviorFlags>>>(
      "layers::IAPZCTreeManager::SetAllowedTouchBehavior",
      mTreeManager,
      &IAPZCTreeManager::SetAllowedTouchBehavior,
      aInputBlockId,
      Move(aValues)));

  return IPC_OK();
}

mozilla::ipc::IPCResult
APZCTreeManagerParent::RecvStartScrollbarDrag(
    const ScrollableLayerGuid& aGuid,
    const AsyncDragMetrics& aDragMetrics)
{
  if (aGuid.mLayersId != mLayersId) {
    // Guard against bad data from hijacked child processes
    NS_ERROR("Unexpected layers id in RecvStartScrollbarDrag; dropping message...");
    return IPC_FAIL_NO_REASON(this);
  }

  APZThreadUtils::RunOnControllerThread(
    NewRunnableMethod<ScrollableLayerGuid, AsyncDragMetrics>(
      "layers::IAPZCTreeManager::StartScrollbarDrag",
      mTreeManager,
      &IAPZCTreeManager::StartScrollbarDrag,
      aGuid,
      aDragMetrics));

  return IPC_OK();
}

mozilla::ipc::IPCResult
APZCTreeManagerParent::RecvStartAutoscroll(
    const ScrollableLayerGuid& aGuid,
    const ScreenPoint& aAnchorLocation)
{
  // Unlike RecvStartScrollbarDrag(), this message comes from the parent
  // process (via nsBaseWidget::mAPZC) rather than from the child process
  // (via TabChild::mApzcTreeManager), so there is no need to check the
  // layers id against mLayersId (and in any case, it wouldn't match, because
  // mLayersId stores the parent process's layers id, while nsBaseWidget is
  // sending the child process's layers id).

  APZThreadUtils::RunOnControllerThread(
      NewRunnableMethod<ScrollableLayerGuid, ScreenPoint>(
        "layers::IAPZCTreeManager::StartAutoscroll",
        mTreeManager,
        &IAPZCTreeManager::StartAutoscroll,
        aGuid, aAnchorLocation));

  return IPC_OK();
}

mozilla::ipc::IPCResult
APZCTreeManagerParent::RecvStopAutoscroll(const ScrollableLayerGuid& aGuid)
{
  // See RecvStartAutoscroll() for why we don't check the layers id.

  APZThreadUtils::RunOnControllerThread(
      NewRunnableMethod<ScrollableLayerGuid>(
        "layers::IAPZCTreeManager::StopAutoscroll",
        mTreeManager,
        &IAPZCTreeManager::StopAutoscroll,
        aGuid));

  return IPC_OK();
}

mozilla::ipc::IPCResult
APZCTreeManagerParent::RecvSetLongTapEnabled(const bool& aTapGestureEnabled)
{
  mTreeManager->SetLongTapEnabled(aTapGestureEnabled);
  return IPC_OK();
}

mozilla::ipc::IPCResult
APZCTreeManagerParent::RecvProcessTouchVelocity(
  const uint32_t& aTimestampMs,
  const float& aSpeedY)
{
  mTreeManager->ProcessTouchVelocity(aTimestampMs, aSpeedY);
  return IPC_OK();
}

mozilla::ipc::IPCResult
APZCTreeManagerParent::RecvUpdateWheelTransaction(
        const LayoutDeviceIntPoint& aRefPoint,
        const EventMessage& aEventMessage)
{
  mTreeManager->UpdateWheelTransaction(aRefPoint, aEventMessage);
  return IPC_OK();
}

mozilla::ipc::IPCResult
APZCTreeManagerParent::RecvProcessUnhandledEvent(
        const LayoutDeviceIntPoint& aRefPoint,
        LayoutDeviceIntPoint* aOutRefPoint,
        ScrollableLayerGuid*  aOutTargetGuid,
        uint64_t*             aOutFocusSequenceNumber)
{
  LayoutDeviceIntPoint refPoint = aRefPoint;
  mTreeManager->ProcessUnhandledEvent(&refPoint, aOutTargetGuid, aOutFocusSequenceNumber);
  *aOutRefPoint = refPoint;

  return IPC_OK();
}

} // namespace layers
} // namespace mozilla
