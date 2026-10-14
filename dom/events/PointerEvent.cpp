/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *
 * Portions Copyright 2013 Microsoft Open Technologies, Inc. */

#include "PointerEvent.h"

#include "jsfriendapi.h"
#include "mozilla/MouseEvents.h"
#include "mozilla/StaticPrefs_dom.h"
#include "mozilla/dom/MouseEventBinding.h"
#include "mozilla/dom/PointerEventBinding.h"
#include "mozilla/dom/PointerEventHandler.h"
#include "nsContentUtils.h"
#include "prtime.h"

namespace mozilla::dom {

PointerEvent::PointerEvent(EventTarget* aOwner, nsPresContext* aPresContext,
                           WidgetPointerEvent* aEvent)
    : MouseEvent(aOwner, aPresContext,
                 aEvent ? aEvent
                        : new WidgetPointerEvent(false, eVoidEvent, nullptr)) {
  NS_ASSERTION(mEvent->mClass == ePointerEventClass,
               "event type mismatch ePointerEventClass");

  WidgetMouseEvent* mouseEvent = mEvent->AsMouseEvent();
  if (aEvent) {
    mEventIsInternal = false;
    if (aEvent->mTilt) {
      mTiltX.emplace(aEvent->mTilt->mX);
      mTiltY.emplace(aEvent->mTilt->mY);
    }
    // If mAltitudeAngle and mAzimuthAngle are Nothing(), they should be
    // computed by mTiltX and mTiltY when they are requested by JS.
    if (aEvent->mAngle) {
      mAltitudeAngle.emplace(aEvent->mAngle->mAltitude);
      mAzimuthAngle.emplace(aEvent->mAngle->mAzimuth);
    }
  } else {
    mEventIsInternal = true;
    mEvent->mRefPoint = LayoutDeviceIntPoint(0, 0);
    mouseEvent->mInputSource = MouseEvent_Binding::MOZ_SOURCE_UNKNOWN;
  }
  // 5.2 Pointer Event types, for all pointer events, |detail| attribute SHOULD
  // be 0.  However, UI Events defines that it should be click count if the
  // event type is "click".
  mDetail =
      IsPointerEventMessageOriginallyMouseEventMessage(mouseEvent->mMessage)
          ? mouseEvent->mClickCount
          : 0;
}

JSObject* PointerEvent::WrapObjectInternal(JSContext* aCx,
                                           JS::Handle<JSObject*> aGivenProto) {
  return PointerEvent_Binding::Wrap(aCx, this, aGivenProto);
}

static uint16_t ConvertStringToPointerType(const nsAString& aPointerTypeArg,
                                           bool aForTrustedEvent) {
  if (aPointerTypeArg.EqualsLiteral("mouse")) {
    return MouseEvent_Binding::MOZ_SOURCE_MOUSE;
  }
  if (aPointerTypeArg.EqualsLiteral("pen")) {
    return MouseEvent_Binding::MOZ_SOURCE_PEN;
  }
  if (aPointerTypeArg.EqualsLiteral("touch")) {
    return MouseEvent_Binding::MOZ_SOURCE_TOUCH;
  }

  // Some chrome script need to copy the input source of a source event to
  // dispatching new event.  Therefore, we need to allow chrome script to
  // set it to any input sources which we are supporting.  However, these
  // types are not standardized by the specs.  Therefore, we should do this
  // only when the event is a trusted one.
  if (aForTrustedEvent) {
    if (aPointerTypeArg.EqualsLiteral("eraser")) {
      return MouseEvent_Binding::MOZ_SOURCE_ERASER;
    }
    if (aPointerTypeArg.EqualsLiteral("cursor")) {
      return MouseEvent_Binding::MOZ_SOURCE_CURSOR;
    }
    if (aPointerTypeArg.EqualsLiteral("keyboard")) {
      return MouseEvent_Binding::MOZ_SOURCE_KEYBOARD;
    }
  }

  return MouseEvent_Binding::MOZ_SOURCE_UNKNOWN;
}

void ConvertPointerTypeToString(uint16_t aPointerTypeSrc,
                                nsAString& aPointerTypeDest) {
  switch (aPointerTypeSrc) {
    case MouseEvent_Binding::MOZ_SOURCE_MOUSE:
      aPointerTypeDest.AssignLiteral("mouse");
      break;
    case MouseEvent_Binding::MOZ_SOURCE_PEN:
      aPointerTypeDest.AssignLiteral("pen");
      break;
    case MouseEvent_Binding::MOZ_SOURCE_TOUCH:
      aPointerTypeDest.AssignLiteral("touch");
      break;
    // In ConvertStringToPointerType(), we allow chrome script to set the
    // input source from Gecko specific pointerType value.  However, we won't
    // expose them to the web because they are not standardized.
    case MouseEvent_Binding::MOZ_SOURCE_ERASER:
    case MouseEvent_Binding::MOZ_SOURCE_CURSOR:
    case MouseEvent_Binding::MOZ_SOURCE_KEYBOARD:
      aPointerTypeDest.Truncate();
      break;
    default:
      aPointerTypeDest.Truncate();
      break;
  }
}

// static
already_AddRefed<PointerEvent> PointerEvent::Constructor(
    EventTarget* aOwner, const nsAString& aType,
    const PointerEventInit& aParam) {
  RefPtr<PointerEvent> e = new PointerEvent(aOwner, nullptr, nullptr);
  bool trusted = e->Init(aOwner);

  e->InitMouseEventInternal(
      aType, aParam.mBubbles, aParam.mCancelable, aParam.mView, aParam.mDetail,
      aParam.mScreenX, aParam.mScreenY, aParam.mClientX, aParam.mClientY, false,
      false, false, false, aParam.mButton, aParam.mRelatedTarget);
  e->InitializeExtraMouseEventDictionaryMembers(aParam);
  e->mPointerType = Some(aParam.mPointerType);

  WidgetPointerEvent* widgetEvent = e->mEvent->AsPointerEvent();
  widgetEvent->pointerId = aParam.mPointerId;
  widgetEvent->mWidth = aParam.mWidth;
  widgetEvent->mHeight = aParam.mHeight;
  widgetEvent->mPressure = aParam.mPressure;
  widgetEvent->tangentialPressure = aParam.mTangentialPressure;
  widgetEvent->twist = aParam.mTwist;
  widgetEvent->mInputSource =
      ConvertStringToPointerType(aParam.mPointerType, trusted);
  widgetEvent->mIsPrimary = aParam.mIsPrimary;
  widgetEvent->mButtons = aParam.mButtons;

  if (aParam.mTiltX.WasPassed()) {
    e->mTiltX.emplace(aParam.mTiltX.Value());
  }
  if (aParam.mTiltY.WasPassed()) {
    e->mTiltY.emplace(aParam.mTiltY.Value());
  }
  if (aParam.mAltitudeAngle.WasPassed()) {
    e->mAltitudeAngle.emplace(aParam.mAltitudeAngle.Value());
  }
  if (aParam.mAzimuthAngle.WasPassed()) {
    e->mAzimuthAngle.emplace(aParam.mAzimuthAngle.Value());
  }

  e->mPersistentDeviceId.emplace(aParam.mPersistentDeviceId);

  if (!aParam.mCoalescedEvents.IsEmpty()) {
    e->mCoalescedEvents.AppendElements(aParam.mCoalescedEvents);
  }
  if (!aParam.mPredictedEvents.IsEmpty()) {
    e->mPredictedEvents.AppendElements(aParam.mPredictedEvents);
  }

  // If only tiltX and/or tiltY is set, altitudeAngle and azimuthAngle should
  // be computed from them when they are requested by JS.
  if ((e->mTiltX || e->mTiltY) && (!e->mAltitudeAngle && !e->mAzimuthAngle)) {
    if (!e->mTiltX) {
      e->mTiltX.emplace(0);
    }
    if (!e->mTiltY) {
      e->mTiltY.emplace(0);
    }
  }
  // If only altitudeAngle and/or azimuthAngle is set, tiltX and tiltY should be
  // computed from them when they are requested by JS.
  else if ((e->mAltitudeAngle || e->mAzimuthAngle) &&
           (!e->mTiltX && !e->mTiltY)) {
    if (!e->mAltitudeAngle) {
      e->mAltitudeAngle.emplace(WidgetPointerHelper::GetDefaultAltitudeAngle());
    }
    if (!e->mAzimuthAngle) {
      e->mAzimuthAngle.emplace(WidgetPointerHelper::GetDefaultAzimuthAngle());
    }
  }
  // Otherwise, initialize the uninitialized values with their default values
  else {
    if (!e->mTiltX) {
      e->mTiltX.emplace(0);
    }
    if (!e->mTiltY) {
      e->mTiltY.emplace(0);
    }
    if (!e->mAltitudeAngle) {
      e->mAltitudeAngle.emplace(WidgetPointerHelper::GetDefaultAltitudeAngle());
    }
    if (!e->mAzimuthAngle) {
      e->mAzimuthAngle.emplace(WidgetPointerHelper::GetDefaultAzimuthAngle());
    }
  }

  e->SetTrusted(trusted);
  e->SetComposed(aParam.mComposed);
  return e.forget();
}

// static
already_AddRefed<PointerEvent> PointerEvent::Constructor(
    const GlobalObject& aGlobal, const nsAString& aType,
    const PointerEventInit& aParam) {
  nsCOMPtr<EventTarget> owner = do_QueryInterface(aGlobal.GetAsSupports());
  return Constructor(owner, aType, aParam);
}

NS_IMPL_CYCLE_COLLECTION_CLASS(PointerEvent)

NS_IMPL_CYCLE_COLLECTION_UNLINK_BEGIN_INHERITED(PointerEvent, MouseEvent)
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mCoalescedEvents)
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mPredictedEvents)
NS_IMPL_CYCLE_COLLECTION_UNLINK_END

NS_IMPL_CYCLE_COLLECTION_TRAVERSE_BEGIN_INHERITED(PointerEvent, MouseEvent)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mCoalescedEvents)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mPredictedEvents)
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_END

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(PointerEvent)
NS_INTERFACE_MAP_END_INHERITING(MouseEvent)

NS_IMPL_ADDREF_INHERITED(PointerEvent, MouseEvent)
NS_IMPL_RELEASE_INHERITED(PointerEvent, MouseEvent)

uint16_t PointerEvent::ResistantInputSource(CallerType aCallerType) const {
  const uint16_t inputSource = mEvent->AsPointerEvent()->mInputSource;
  if (!ShouldResistFingerprinting(aCallerType)) {
    return inputSource;
  }

  MOZ_ASSERT(IsTrusted());

  // Bug 1953665: Pen events are inconsistent between platforms.
  // They might emit touch events on Windows and Android, but only mouse events
  // in other platforms. In particular, touch is always disabled on macOS.
#if defined(XP_WIN)
  if (inputSource == MouseEvent_Binding::MOZ_SOURCE_TOUCH ||
      inputSource == MouseEvent_Binding::MOZ_SOURCE_MOUSE) {
    return inputSource;
  }
  // Similar to nsWindow::DispatchTouchEventFromWMPointer.
  switch (mEvent->mMessage) {
    case ePointerMove:
      return mEvent->AsPointerEvent()->mPressure == 0
                 ? MouseEvent_Binding::MOZ_SOURCE_MOUSE  // hover
                 : MouseEvent_Binding::MOZ_SOURCE_TOUCH;
    case ePointerUp:
    case ePointerDown:
    case ePointerCancel:
      return MouseEvent_Binding::MOZ_SOURCE_TOUCH;
    default:
      return MouseEvent_Binding::MOZ_SOURCE_MOUSE;
  }
#elif defined(MOZ_WIDGET_ANDROID)
  return inputSource == MouseEvent_Binding::MOZ_SOURCE_MOUSE
             ? MouseEvent_Binding::MOZ_SOURCE_MOUSE
             : MouseEvent_Binding::MOZ_SOURCE_TOUCH;
#elif defined(MOZ_WIDGET_GTK)
  return inputSource == MouseEvent_Binding::MOZ_SOURCE_TOUCH
             ? MouseEvent_Binding::MOZ_SOURCE_TOUCH
             : MouseEvent_Binding::MOZ_SOURCE_MOUSE;
#elif defined(MOZ_WIDGET_COCOA)
  return MouseEvent_Binding::MOZ_SOURCE_MOUSE;
#else
  return inputSource;
#endif
}

void PointerEvent::GetPointerType(nsAString& aPointerType,
                                  CallerType aCallerType) const {
  if (mPointerType.isSome()) {
    aPointerType = mPointerType.value();
    return;
  }
  ConvertPointerTypeToString(ResistantInputSource(aCallerType), aPointerType);
}

int32_t PointerEvent::PointerId(CallerType aCallerType) const {
#ifdef MOZ_WIDGET_COCOA
  if (ShouldResistFingerprinting(aCallerType)) {
    return PointerEventHandler::GetSpoofedPointerIdForRFP();
  }
#endif
  return mEvent->AsPointerEvent()->pointerId;
}

double PointerEvent::Width(CallerType aCallerType) const {
  return ShouldResistFingerprinting(aCallerType)
             ? 1.0
             : mEvent->AsPointerEvent()->mWidth;
}

double PointerEvent::Height(CallerType aCallerType) const {
  return ShouldResistFingerprinting(aCallerType)
             ? 1.0
             : mEvent->AsPointerEvent()->mHeight;
}

float PointerEvent::Pressure(CallerType aCallerType) const {
  if (mEvent->mMessage == ePointerUp ||
      !ShouldResistFingerprinting(aCallerType)) {
    return mEvent->AsPointerEvent()->mPressure;
  }

  // According to [1], we should use 0.5 when it is in active buttons state and
  // 0 otherwise for devices that don't support pressure. And a pointerup event
  // always reports 0, so we don't need to spoof that.
  //
  // [1] https://www.w3.org/TR/pointerevents/#dom-pointerevent-pressure
  float spoofedPressure = 0.0;
  if (mEvent->AsPointerEvent()->mButtons) {
    spoofedPressure = 0.5;
  }

  return spoofedPressure;
}

float PointerEvent::TangentialPressure(CallerType aCallerType) const {
  return ShouldResistFingerprinting(aCallerType)
             ? 0
             : mEvent->AsPointerEvent()->tangentialPressure;
}

int32_t PointerEvent::TiltX(CallerType aCallerType) {
  if (ShouldResistFingerprinting(aCallerType)) {
    return WidgetPointerHelper::GetDefaultTiltX();
  }
  if (mTiltX.isSome()) {
    return *mTiltX;
  }
  if (mAltitudeAngle.isSome() && mAzimuthAngle.isSome()) {
    mTiltX.emplace(
        WidgetPointerHelper::ComputeTiltX(*mAltitudeAngle, *mAzimuthAngle));
    return *mTiltX;
  }
  mTiltX.emplace(WidgetPointerHelper::GetDefaultTiltX());
  return *mTiltX;
}

int32_t PointerEvent::TiltY(CallerType aCallerType) {
  if (ShouldResistFingerprinting(aCallerType)) {
    return WidgetPointerHelper::GetDefaultTiltY();
  }
  if (mTiltY.isSome()) {
    return *mTiltY;
  }
  if (mAltitudeAngle.isSome() && mAzimuthAngle.isSome()) {
    mTiltY.emplace(
        WidgetPointerHelper::ComputeTiltY(*mAltitudeAngle, *mAzimuthAngle));
    return *mTiltY;
  }
  mTiltY.emplace(WidgetPointerHelper::GetDefaultTiltY());
  return *mTiltY;
}

int32_t PointerEvent::Twist(CallerType aCallerType) const {
  return ShouldResistFingerprinting(aCallerType)
             ? 0
             : mEvent->AsPointerEvent()->twist;
}

double PointerEvent::AltitudeAngle(CallerType aCallerType) {
  if (ShouldResistFingerprinting(aCallerType)) {
    return WidgetPointerHelper::GetDefaultAltitudeAngle();
  }
  if (mAltitudeAngle.isSome()) {
    return *mAltitudeAngle;
  }
  if (mTiltX.isSome() && mTiltY.isSome()) {
    mAltitudeAngle.emplace(
        WidgetPointerHelper::ComputeAltitudeAngle(*mTiltX, *mTiltY));
    return *mAltitudeAngle;
  }
  mAltitudeAngle.emplace(WidgetPointerHelper::GetDefaultAltitudeAngle());
  return *mAltitudeAngle;
}

double PointerEvent::AzimuthAngle(CallerType aCallerType) {
  if (ShouldResistFingerprinting(aCallerType)) {
    return WidgetPointerHelper::GetDefaultAzimuthAngle();
  }
  if (mAzimuthAngle.isSome()) {
    return *mAzimuthAngle;
  }
  if (mTiltX.isSome() && mTiltY.isSome()) {
    mAzimuthAngle.emplace(
        WidgetPointerHelper::ComputeAzimuthAngle(*mTiltX, *mTiltY));
    return *mAzimuthAngle;
  }
  mAzimuthAngle.emplace(WidgetPointerHelper::GetDefaultAzimuthAngle());
  return *mAzimuthAngle;
}

bool PointerEvent::IsPrimary() const {
  return mEvent->AsPointerEvent()->mIsPrimary;
}

int32_t PointerEvent::PersistentDeviceId(CallerType aCallerType) {
  const auto MaybeNonZero = [&]() {
    return mEvent->IsTrusted() && IsPointerEventMessage(mEvent->mMessage) &&
           !IsPointerEventMessageOriginallyMouseEventMessage(mEvent->mMessage);
  };

  if (ShouldResistFingerprinting(aCallerType)) {
    return MaybeNonZero() && ResistantInputSource(aCallerType) ==
                                 MouseEvent_Binding::MOZ_SOURCE_MOUSE
               ? 1
               : 0;
  }

  if (mPersistentDeviceId.isNothing()) {
    if (MaybeNonZero() && mEvent->AsPointerEvent()->mInputSource ==
                              MouseEvent_Binding::MOZ_SOURCE_MOUSE) {
      // Follow the behavior which Chrome has for mouse.
      mPersistentDeviceId.emplace(1);
    } else {
      // For now the default value is reported for non-mouse based events.
      mPersistentDeviceId.emplace(0);
    }
  }

  return mPersistentDeviceId.value();
}

void PointerEvent::GetCoalescedEvents(
    nsTArray<RefPtr<PointerEvent>>& aPointerEvents) {
  WidgetPointerEvent* widgetEvent = mEvent->AsPointerEvent();
  MOZ_ASSERT(widgetEvent);
  EnsureFillingCoalescedEvents(*widgetEvent);
  if (mCoalescedEvents.IsEmpty() && widgetEvent &&
      widgetEvent->mCoalescedWidgetEvents &&
      !widgetEvent->mCoalescedWidgetEvents->mEvents.IsEmpty()) {
    nsCOMPtr<EventTarget> owner = do_QueryInterface(mGlobal);
    for (WidgetPointerEvent& event :
         widgetEvent->mCoalescedWidgetEvents->mEvents) {
      RefPtr<PointerEvent> domEvent =
          NS_NewDOMPointerEvent(owner, nullptr, &event);
      domEvent->mCoalescedOrPredictedEvent = true;

      // The dom event is derived from an OS generated widget event. Setup
      // mWidget and mPresContext since they are necessary to calculate
      // offsetX / offsetY.
      domEvent->mEvent->AsGUIEvent()->mWidget = widgetEvent->mWidget;
      domEvent->mPresContext = mPresContext;

      // The coalesced widget mouse events shouldn't have been dispatched.
      MOZ_ASSERT(!domEvent->mEvent->mTarget);

      // JS could hold reference to dom events. We have to ask dom event to
      // duplicate its private data to avoid the widget event is destroyed.
      domEvent->DuplicatePrivateData();

      // The event target should be the same as the dispatched event's target.
      // This must be set after DuplicatePrivateData(): before it, mEvent still
      // aliases the WidgetPointerEvent stored in the shared, ref-counted
      // WidgetPointerEventHolder, which the cycle collector does not traverse.
      // A strong reference to the target stored there would keep the target,
      // and its whole document, alive as long as any event referencing the
      // holder is retained by script.
      domEvent->mEvent->mTarget = mEvent->mTarget;

      mCoalescedEvents.AppendElement(domEvent);
    }
  }
  if (mEvent->IsTrusted() && mEvent->mTarget) {
    for (RefPtr<PointerEvent>& pointerEvent : mCoalescedEvents) {
      // Only set event target when it's null.
      if (!pointerEvent->mEvent->mTarget) {
        pointerEvent->mEvent->mTarget = mEvent->mTarget;
      }
    }
  }
  aPointerEvents.AppendElements(mCoalescedEvents);
}

void PointerEvent::EnsureFillingCoalescedEvents(
    WidgetPointerEvent& aWidgetEvent) {
  if (!aWidgetEvent.IsTrusted() ||
      (aWidgetEvent.mMessage != ePointerMove &&
       aWidgetEvent.mMessage != ePointerRawUpdate) ||
      !mCoalescedEvents.IsEmpty() ||
      (aWidgetEvent.mCoalescedWidgetEvents &&
       !aWidgetEvent.mCoalescedWidgetEvents->mEvents.IsEmpty()) ||
      mCoalescedOrPredictedEvent) {
    return;
  }
  if (!aWidgetEvent.mCoalescedWidgetEvents) {
    aWidgetEvent.mCoalescedWidgetEvents = new WidgetPointerEventHolder();
  }
  WidgetPointerEvent* const coalescedEvent =
      aWidgetEvent.mCoalescedWidgetEvents->mEvents.AppendElement(
          WidgetPointerEvent(true, aWidgetEvent.mMessage,
                             aWidgetEvent.mWidget));
  MOZ_ASSERT(coalescedEvent);
  PointerEventHandler::InitCoalescedEventFromPointerEvent(*coalescedEvent,
                                                          aWidgetEvent);
}

void PointerEvent::GetPredictedEvents(
    nsTArray<RefPtr<PointerEvent>>& aPointerEvents) {
  // XXX Add support for native predicted events, bug 1550461
  // And when doing so, update mCoalescedOrPredictedEvent here.
  if (mEvent->IsTrusted() && mEvent->mTarget) {
    for (RefPtr<PointerEvent>& pointerEvent : mPredictedEvents) {
      // Only set event target when it's null.
      if (!pointerEvent->mEvent->mTarget) {
        pointerEvent->mEvent->mTarget = mEvent->mTarget;
      }
    }
  }
  aPointerEvents.AppendElements(mPredictedEvents);
}

bool PointerEvent::ShouldResistFingerprinting(CallerType aCallerType) const {
  // There are a few simple situations we don't need to spoof this pointer
  // event.
  //   * We are being called by a System caller
  //   * The pref privcy.resistFingerprinting' is false, we fast return here
  //     since we don't need to do any QI of following codes.
  //   * This event is generated by scripts.
  //   * This event is a mouse pointer event.
  //  We don't need to check for the system group since pointer events won't be
  //  dispatched to the system group.
  RFPTarget target = RFPTarget::PointerEvents;
  if (aCallerType == CallerType::System ||
      !nsContentUtils::ShouldResistFingerprinting("Efficiency Check", target) ||
      !mEvent->IsTrusted() ||
      mEvent->AsPointerEvent()->mInputSource ==
          MouseEvent_Binding::MOZ_SOURCE_MOUSE) {
    return false;
  }

  // Pref is checked above, so use true as fallback.
  nsCOMPtr<Document> doc = GetDocument();
  return doc ? doc->ShouldResistFingerprinting(target) : true;
}

}  // namespace mozilla::dom

using namespace mozilla;
using namespace mozilla::dom;

already_AddRefed<PointerEvent> NS_NewDOMPointerEvent(
    EventTarget* aOwner, nsPresContext* aPresContext,
    WidgetPointerEvent* aEvent) {
  RefPtr<PointerEvent> it = new PointerEvent(aOwner, aPresContext, aEvent);
  return it.forget();
}
