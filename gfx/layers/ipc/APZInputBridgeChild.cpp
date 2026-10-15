/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/layers/APZInputBridgeChild.h"

#include "InputData.h"  // for InputData, etc
#include "mozilla/Assertions.h"
#include "mozilla/dom/BrowserParent.h"  // for BrowserParent
#include "mozilla/gfx/GPUProcessManager.h"
#include "mozilla/ipc/Endpoint.h"
#include "mozilla/layers/APZCCallbackHelper.h"
#include "mozilla/layers/APZThreadUtils.h"
#include "mozilla/layers/DoubleTapToZoom.h"  // for DoubleTapToZoomMetrics
#include "mozilla/layers/GeckoContentController.h"  // for GeckoContentController
#include "mozilla/layers/KeyboardMap.h"             // for KeyboardMap
#include "mozilla/layers/RemoteCompositorSession.h"  // for RemoteCompositorSession
#include "mozilla/layers/SynchronousTask.h"
#include "nsThreadUtils.h"
#ifdef MOZ_WIDGET_ANDROID
#  include "mozilla/jni/Utils.h"  // for DispatchToGeckoPriorityQueue
#endif

namespace mozilla {
namespace layers {

/* static */
RefPtr<APZInputBridgeChild> APZInputBridgeChild::Create(
    const uint64_t& aProcessToken, Endpoint<PAPZInputBridgeChild>&& aEndpoint) {
  RefPtr<APZInputBridgeChild> child = new APZInputBridgeChild(aProcessToken);

  MOZ_ASSERT(APZThreadUtils::IsControllerThreadAlive());

  APZThreadUtils::RunOnControllerThread(
      NewRunnableMethod<Endpoint<PAPZInputBridgeChild>&&>(
          "layers::APZInputBridgeChild::Open", child,
          &APZInputBridgeChild::Open, std::move(aEndpoint)));

  return child;
}

APZInputBridgeChild::APZInputBridgeChild(const uint64_t& aProcessToken)
    : mIsOpen(false),
      mProcessToken(aProcessToken),
      mCompositorSession(nullptr) {
  MOZ_ASSERT(XRE_IsParentProcess());
  MOZ_ASSERT(NS_IsMainThread());
}

APZInputBridgeChild::~APZInputBridgeChild() = default;

void APZInputBridgeChild::SetCompositorSession(
    RemoteCompositorSession* aSession) {
  mCompositorSession = aSession;
}

void APZInputBridgeChild::Open(Endpoint<PAPZInputBridgeChild>&& aEndpoint) {
  APZThreadUtils::AssertOnControllerThread();

  mIsOpen = aEndpoint.Bind(this);

  if (!mIsOpen) {
    // The GPU Process Manager might be gone if we receive ActorDestroy very
    // late in shutdown.
    if (gfx::GPUProcessManager* gpm = gfx::GPUProcessManager::Get()) {
      gpm->NotifyRemoteActorDestroyed(mProcessToken);
    }
    return;
  }
}

void APZInputBridgeChild::Destroy() {
  MOZ_ASSERT(XRE_IsParentProcess());
  MOZ_ASSERT(NS_IsMainThread());

  // Destroy will get called from the main thread, so we must synchronously
  // dispatch to the controller thread to close the bridge.
  layers::SynchronousTask task("layers::APZInputBridgeChild::Destroy");
  APZThreadUtils::RunOnControllerThread(
      NS_NewRunnableFunction("layers::APZInputBridgeChild::Destroy", [&]() {
        APZThreadUtils::AssertOnControllerThread();
        AutoCompleteTask complete(&task);

        // Clear the process token so that we don't notify the GPUProcessManager
        // about an abnormal shutdown, thereby tearing down the GPU process.
        mProcessToken = 0;

        if (mIsOpen) {
          PAPZInputBridgeChild::Close();
          mIsOpen = false;
        }
      }));

  task.Wait();
}

void APZInputBridgeChild::ActorDestroy(ActorDestroyReason aWhy) {
  mIsOpen = false;

  if (mProcessToken) {
    gfx::GPUProcessManager::Get()->NotifyRemoteActorDestroyed(mProcessToken);
    mProcessToken = 0;
  }
}

APZEventResult APZInputBridgeChild::ReceiveInputEvent(
    InputData& aEvent, InputBlockCallback&& aCallback) {
  APZThreadUtils::AssertOnControllerThread();

  APZEventResult res;
  if (!mIsOpen) {
    return res;
  }
  switch (aEvent.mInputType) {
    case MULTITOUCH_INPUT: {
      MultiTouchInput& event = aEvent.AsMultiTouchInput();
      MultiTouchInput processedEvent;

      if (!SendReceiveMultiTouchInputEvent(event, !!aCallback, &res,
                                           &processedEvent)) {
        return APZEventResult();
      }

      event = std::move(processedEvent);
      break;
    }
    case MOUSE_INPUT: {
      MouseInput& event = aEvent.AsMouseInput();
      MouseInput processedEvent;

      if (!SendReceiveMouseInputEvent(event, !!aCallback, &res,
                                      &processedEvent)) {
        return APZEventResult();
      }

      event = std::move(processedEvent);
      break;
    }
    case PANGESTURE_INPUT: {
      PanGestureInput& event = aEvent.AsPanGestureInput();
      PanGestureInput processedEvent;

      if (!SendReceivePanGestureInputEvent(event, !!aCallback, &res,
                                           &processedEvent)) {
        return APZEventResult();
      }

      event = std::move(processedEvent);
      break;
    }
    case PINCHGESTURE_INPUT: {
      PinchGestureInput& event = aEvent.AsPinchGestureInput();
      PinchGestureInput processedEvent;

      if (!SendReceivePinchGestureInputEvent(event, !!aCallback, &res,
                                             &processedEvent)) {
        return APZEventResult();
      }

      event = std::move(processedEvent);
      break;
    }
    case TAPGESTURE_INPUT: {
      TapGestureInput& event = aEvent.AsTapGestureInput();
      TapGestureInput processedEvent;

      if (!SendReceiveTapGestureInputEvent(event, !!aCallback, &res,
                                           &processedEvent)) {
        return APZEventResult();
      }

      event = std::move(processedEvent);
      break;
    }
    case SCROLLWHEEL_INPUT: {
      ScrollWheelInput& event = aEvent.AsScrollWheelInput();
      ScrollWheelInput processedEvent;

      if (!SendReceiveScrollWheelInputEvent(event, !!aCallback, &res,
                                            &processedEvent)) {
        return APZEventResult();
      }

      event = std::move(processedEvent);
      break;
    }
    case KEYBOARD_INPUT: {
      KeyboardInput& event = aEvent.AsKeyboardInput();
      KeyboardInput processedEvent;

      if (!SendReceiveKeyboardInputEvent(event, !!aCallback, &res,
                                         &processedEvent)) {
        return APZEventResult();
      }

      event = std::move(processedEvent);
      break;
    }
    default: {
      MOZ_ASSERT_UNREACHABLE("Invalid InputData type.");
      res.SetStatusAsConsumeNoDefault();
      break;
    }
  }

  if (mIsOpen && aCallback && res.WillHaveDelayedResult()) {
    mInputBlockCallbacks.emplace(res.mInputBlockId, std::move(aCallback));
  }

  return res;
}

void APZInputBridgeChild::HandleTapOnMainThread(
    const TapType& aType, const LayoutDevicePoint& aPoint,
    const Modifiers& aModifiers, const ScrollableLayerGuid& aGuid,
    const uint64_t& aInputBlockId,
    const Maybe<DoubleTapToZoomMetrics>& aDoubleTapToZoomMetrics) {
  if (mCompositorSession &&
      mCompositorSession->RootLayerTreeId() == aGuid.mLayersId &&
      GetContentController()) {
    RefPtr<GeckoContentController> controller = GetContentController();
    controller->HandleTap(aType, aPoint, aModifiers, aGuid, aInputBlockId,
                          aDoubleTapToZoomMetrics);
    return;
  }
  // Hold strong reference to BrowserParent because SendHandleTap
  // can run script via SetFocus.
  RefPtr<dom::BrowserParent> tab =
      dom::BrowserParent::GetBrowserParentFromLayersId(aGuid.mLayersId);
  if (tab) {
#ifdef MOZ_WIDGET_ANDROID
    // On Android, touch events are dispatched from the UI thread to the main
    // thread using the Android priority queue. It is possible that this tap has
    // made it to the GPU process and back before they have been processed. We
    // must therefore dispatch this message to the same queue, otherwise the tab
    // may receive the tap event before the touch events that synthesized it.
    mozilla::jni::DispatchToGeckoPriorityQueue(
        NewRunnableMethod<TapType, LayoutDevicePoint, Modifiers,
                          ScrollableLayerGuid, uint64_t,
                          Maybe<DoubleTapToZoomMetrics>>(
            "dom::BrowserParent::SendHandleTap", tab,
            &dom::BrowserParent::SendHandleTap, aType, aPoint, aModifiers,
            aGuid, aInputBlockId, aDoubleTapToZoomMetrics));
#else
    tab->SendHandleTap(aType, aPoint, aModifiers, aGuid, aInputBlockId,
                       aDoubleTapToZoomMetrics);
#endif
  }
}

mozilla::ipc::IPCResult APZInputBridgeChild::RecvHandleTap(
    const TapType& aType, const LayoutDevicePoint& aPoint,
    const Modifiers& aModifiers, const ScrollableLayerGuid& aGuid,
    const uint64_t& aInputBlockId,
    const Maybe<DoubleTapToZoomMetrics>& aDoubleTapToZoomMetrics) {
  if (NS_IsMainThread()) {
    HandleTapOnMainThread(aType, aPoint, aModifiers, aGuid, aInputBlockId,
                          aDoubleTapToZoomMetrics);
  } else {
    NS_DispatchToMainThread(
        NewRunnableMethod<TapType, LayoutDevicePoint, Modifiers,
                          ScrollableLayerGuid, uint64_t,
                          Maybe<DoubleTapToZoomMetrics>>(
            "layers::APZInputBridgeChild::HandleTapOnMainThread", this,
            &APZInputBridgeChild::HandleTapOnMainThread, aType, aPoint,
            aModifiers, aGuid, aInputBlockId, aDoubleTapToZoomMetrics));
  }
  return IPC_OK();
}

mozilla::ipc::IPCResult APZInputBridgeChild::RecvCallInputBlockCallback(
    uint64_t aInputBlockId, const APZHandledResult& aHandledResult) {
  auto it = mInputBlockCallbacks.find(aInputBlockId);
  if (it != mInputBlockCallbacks.end()) {
    it->second(aInputBlockId, aHandledResult);
    // The callback is one-shot; discard it after calling it.
    mInputBlockCallbacks.erase(it);
  }

  return IPC_OK();
}

// Note mCompositorSession is currently used by the main thread.
void APZInputBridgeChild::NotifyPinchGestureOnMainThread(
    const PinchGestureType& aType, const LayoutDevicePoint& aFocusPoint,
    const LayoutDeviceCoord& aSpanChange, const Modifiers& aModifiers) {
  MOZ_ASSERT(NS_IsMainThread());

  if (mCompositorSession && mCompositorSession->GetWidget()) {
    APZCCallbackHelper::NotifyPinchGesture(aType, aFocusPoint, aSpanChange,
                                           aModifiers,
                                           mCompositorSession->GetWidget());
  }
}

mozilla::ipc::IPCResult APZInputBridgeChild::RecvNotifyPinchGesture(
    const PinchGestureType& aType, const ScrollableLayerGuid& aGuid,
    const LayoutDevicePoint& aFocusPoint, const LayoutDeviceCoord& aSpanChange,
    const Modifiers& aModifiers) {
  // We want to handle it in this process regardless of what the target guid
  // of the pinch is. This may change in the future.
  if (NS_IsMainThread()) {
    NotifyPinchGestureOnMainThread(aType, aFocusPoint, aSpanChange, aModifiers);
  } else {
    NS_DispatchToMainThread(
        NewRunnableMethod<PinchGestureType, LayoutDevicePoint,
                          LayoutDeviceCoord, Modifiers>(
            "layers::APZInputBridgeChild::NotifyPinchGestureOnMainThread", this,
            &APZInputBridgeChild::NotifyPinchGestureOnMainThread, aType,
            aFocusPoint, aSpanChange, aModifiers));
  }
  return IPC_OK();
}

// Note APZCCallbackHelper::CancelAutoscroll() must be called on the main
// thread.
mozilla::ipc::IPCResult APZInputBridgeChild::RecvCancelAutoscroll(
    const ScrollableLayerGuid::ViewID& aScrollId) {
  if (NS_IsMainThread()) {
    APZCCallbackHelper::CancelAutoscroll(aScrollId);
  } else {
    NS_DispatchToMainThread(
        NewRunnableFunction("layers::APZCCallbackHelper::CancelAutoscroll",
                            &APZCCallbackHelper::CancelAutoscroll, aScrollId));
  }
  return IPC_OK();
}

// Note APZCCallbackHelper::NotifyScaleGestureComplete() must be called on the
// main thread.
void APZInputBridgeChild::NotifyScaleGestureCompleteOnMainThread(float aScale) {
  MOZ_ASSERT(NS_IsMainThread());

  if (mCompositorSession && mCompositorSession->GetWidget()) {
    APZCCallbackHelper::NotifyScaleGestureComplete(
        mCompositorSession->GetWidget(), aScale);
  }
}

mozilla::ipc::IPCResult APZInputBridgeChild::RecvNotifyScaleGestureComplete(
    const ScrollableLayerGuid::ViewID& aScrollId, float aScale) {
  if (NS_IsMainThread()) {
    NotifyScaleGestureCompleteOnMainThread(aScale);
  } else {
    NS_DispatchToMainThread(NewRunnableMethod<float>(
        "layers::APZInputBridgeChild::NotifyScaleGestureCompleteOnMainThread",
        this, &APZInputBridgeChild::NotifyScaleGestureCompleteOnMainThread,
        aScale));
  }
  return IPC_OK();
}

void APZInputBridgeChild::ProcessUnhandledEvent(
    LayoutDeviceIntPoint* aRefPoint, ScrollableLayerGuid* aOutTargetGuid,
    uint64_t* aOutFocusSequenceNumber, LayersId* aOutLayersId) {
  APZThreadUtils::AssertOnControllerThread();

  if (!mIsOpen) {
    return;
  }

  SendProcessUnhandledEvent(*aRefPoint, aRefPoint, aOutTargetGuid,
                            aOutFocusSequenceNumber, aOutLayersId);
}

void APZInputBridgeChild::UpdateWheelTransaction(
    LayoutDeviceIntPoint aRefPoint, EventMessage aEventMessage,
    const Maybe<ScrollableLayerGuid>& aTargetGuid) {
  APZThreadUtils::AssertOnControllerThread();

  if (!mIsOpen) {
    return;
  }

  SendUpdateWheelTransaction(aRefPoint, aEventMessage, aTargetGuid);
}

// This actor is bound to the controller thread (see
// APZInputBridgeChild::Open()), so they must hop to it before sending.
void APZInputBridgeChild::SetKeyboardMap(const KeyboardMap& aKeyboardMap) {
  if (!APZThreadUtils::IsControllerThread()) {
    APZThreadUtils::RunOnControllerThread(NewRunnableMethod<KeyboardMap>(
        "layers::APZInputBridgeChild::SetKeyboardMap", this,
        &APZInputBridgeChild::SetKeyboardMap, aKeyboardMap));
    return;
  }

  if (!mIsOpen) {
    return;
  }

  SendSetKeyboardMap(aKeyboardMap);
}

// This actor is bound to the controller thread (see
// APZInputBridgeChild::Open()), so they must hop to it before sending.
void APZInputBridgeChild::SetDPI(float aDpiValue) {
  if (!APZThreadUtils::IsControllerThread()) {
    APZThreadUtils::RunOnControllerThread(
        NewRunnableMethod<float>("layers::APZInputBridgeChild::SetDPI", this,
                                 &APZInputBridgeChild::SetDPI, aDpiValue));
    return;
  }

  if (!mIsOpen) {
    return;
  }

  SendSetDPI(aDpiValue);
}

// This actor is bound to the controller thread (see
// APZInputBridgeChild::Open()), so they must hop to it before sending.
void APZInputBridgeChild::SetBrowserGestureResponse(
    uint64_t aInputBlockId, BrowserGestureResponse aResponse) {
  if (!APZThreadUtils::IsControllerThread()) {
    APZThreadUtils::RunOnControllerThread(
        NewRunnableMethod<uint64_t, BrowserGestureResponse>(
            "layers::APZInputBridgeChild::SetBrowserGestureResponse", this,
            &APZInputBridgeChild::SetBrowserGestureResponse, aInputBlockId,
            aResponse));
    return;
  }

  if (!mIsOpen) {
    return;
  }

  SendSetBrowserGestureResponse(aInputBlockId, aResponse);
}

// This actor is bound to the controller thread (see
// APZInputBridgeChild::Open()), so they must hop to it before sending.
void APZInputBridgeChild::StartAutoscroll(const ScrollableLayerGuid& aGuid,
                                          const ScreenPoint& aAnchorLocation) {
  if (!APZThreadUtils::IsControllerThread()) {
    APZThreadUtils::RunOnControllerThread(
        NewRunnableMethod<ScrollableLayerGuid, ScreenPoint>(
            "layers::APZInputBridgeChild::StartAutoscroll", this,
            &APZInputBridgeChild::StartAutoscroll, aGuid, aAnchorLocation));
    return;
  }

  if (!mIsOpen) {
    return;
  }

  SendStartAutoscroll(aGuid, aAnchorLocation);
}

// This actor is bound to the controller thread (see
// APZInputBridgeChild::Open()), so they must hop to it before sending.
void APZInputBridgeChild::StopAutoscroll(const ScrollableLayerGuid& aGuid) {
  if (!APZThreadUtils::IsControllerThread()) {
    APZThreadUtils::RunOnControllerThread(
        NewRunnableMethod<ScrollableLayerGuid>(
            "layers::APZInputBridgeChild::StopAutoscroll", this,
            &APZInputBridgeChild::StopAutoscroll, aGuid));
    return;
  }

  if (!mIsOpen) {
    return;
  }

  SendStopAutoscroll(aGuid);
}

// This actor is bound to the controller thread (see
// APZInputBridgeChild::Open()), so they must hop to it before sending.
void APZInputBridgeChild::SetLongTapEnabled(bool aTapGestureEnabled) {
  if (!APZThreadUtils::IsControllerThread()) {
    APZThreadUtils::RunOnControllerThread(NewRunnableMethod<bool>(
        "layers::APZInputBridgeChild::SetLongTapEnabled", this,
        &APZInputBridgeChild::SetLongTapEnabled, aTapGestureEnabled));
    return;
  }

  if (!mIsOpen) {
    return;
  }

  SendSetLongTapEnabled(aTapGestureEnabled);
}

// Note mCompositorSession is currently used by the main thread.
GeckoContentController* APZInputBridgeChild::GetContentController() {
  MOZ_ASSERT(NS_IsMainThread());

  if (!mCompositorSession) {
    return nullptr;
  }
  return mCompositorSession->GetContentController();
}

void APZInputBridgeChild::NotifyLayerTransformsOnMainThread(
    nsTArray<MatrixMessage>&& aTransforms) {
  MOZ_ASSERT(NS_IsMainThread());

  if (RefPtr<GeckoContentController> controller = GetContentController()) {
    controller->NotifyLayerTransforms(std::move(aTransforms));
  }
}

mozilla::ipc::IPCResult APZInputBridgeChild::RecvLayerTransforms(
    nsTArray<MatrixMessage>&& aTransforms) {
  if (NS_IsMainThread()) {
    NotifyLayerTransformsOnMainThread(std::move(aTransforms));
  } else {
    NS_DispatchToMainThread(
        NewRunnableMethod<StoreCopyPassByRRef<nsTArray<MatrixMessage>>>(
            "layers::APZInputBridgeChild::NotifyLayerTransformsOnMainThread",
            this, &APZInputBridgeChild::NotifyLayerTransformsOnMainThread,
            std::move(aTransforms)));
  }
  return IPC_OK();
}

void APZInputBridgeChild::UpdateOverscrollVelocityOnMainThread(
    const ScrollableLayerGuid& aGuid, float aX, float aY, bool aIsRootContent) {
  MOZ_ASSERT(NS_IsMainThread());

  if (RefPtr<GeckoContentController> controller = GetContentController()) {
    controller->UpdateOverscrollVelocity(aGuid, aX, aY, aIsRootContent);
  }
}

mozilla::ipc::IPCResult APZInputBridgeChild::RecvUpdateOverscrollVelocity(
    const ScrollableLayerGuid& aGuid, const float& aX, const float& aY,
    const bool& aIsRootContent) {
  if (NS_IsMainThread()) {
    UpdateOverscrollVelocityOnMainThread(aGuid, aX, aY, aIsRootContent);
  } else {
    NS_DispatchToMainThread(
        NewRunnableMethod<ScrollableLayerGuid, float, float, bool>(
            "layers::APZInputBridgeChild::UpdateOverscrollVelocityOnMainThread",
            this, &APZInputBridgeChild::UpdateOverscrollVelocityOnMainThread,
            aGuid, aX, aY, aIsRootContent));
  }
  return IPC_OK();
}

void APZInputBridgeChild::UpdateOverscrollOffsetOnMainThread(
    const ScrollableLayerGuid& aGuid, float aX, float aY, bool aIsRootContent) {
  MOZ_ASSERT(NS_IsMainThread());

  if (RefPtr<GeckoContentController> controller = GetContentController()) {
    controller->UpdateOverscrollOffset(aGuid, aX, aY, aIsRootContent);
  }
}

mozilla::ipc::IPCResult APZInputBridgeChild::RecvUpdateOverscrollOffset(
    const ScrollableLayerGuid& aGuid, const float& aX, const float& aY,
    const bool& aIsRootContent) {
  if (NS_IsMainThread()) {
    UpdateOverscrollOffsetOnMainThread(aGuid, aX, aY, aIsRootContent);
  } else {
    NS_DispatchToMainThread(
        NewRunnableMethod<ScrollableLayerGuid, float, float, bool>(
            "layers::APZInputBridgeChild::UpdateOverscrollOffsetOnMainThread",
            this, &APZInputBridgeChild::UpdateOverscrollOffsetOnMainThread,
            aGuid, aX, aY, aIsRootContent));
  }
  return IPC_OK();
}

void APZInputBridgeChild::HideDynamicToolbarOnMainThread() {
  MOZ_ASSERT(NS_IsMainThread());

  if (RefPtr<GeckoContentController> controller = GetContentController()) {
    // Only the RemoteContentController implementation uses the
    // ScrollableLayerGuid parameter, and the controller here is never a
    // RemoteContentController, so it's fine to invent a value here.
    controller->HideDynamicToolbar(ScrollableLayerGuid{});
  }
}

mozilla::ipc::IPCResult APZInputBridgeChild::RecvHideDynamicToolbar() {
  if (NS_IsMainThread()) {
    HideDynamicToolbarOnMainThread();
  } else {
    NS_DispatchToMainThread(NewRunnableMethod(
        "layers::APZInputBridgeChild::HideDynamicToolbarOnMainThread", this,
        &APZInputBridgeChild::HideDynamicToolbarOnMainThread));
  }
  return IPC_OK();
}

}  // namespace layers
}  // namespace mozilla
