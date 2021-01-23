/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "APZEventState.h"

#include <utility>

#include "APZCCallbackHelper.h"
#include "ActiveElementManager.h"
#include "LayersLogging.h"
#include "TouchManager.h"
#include "mozilla/BasicEvents.h"
#include "mozilla/IntegerPrintfMacros.h"
#include "mozilla/PositionedEventTargeting.h"
#include "mozilla/Preferences.h"
#include "mozilla/PresShell.h"
#include "mozilla/StaticPrefs_dom.h"
#include "mozilla/StaticPrefs_ui.h"
#include "mozilla/TouchEvents.h"
#include "mozilla/ViewportUtils.h"
#include "mozilla/dom/BrowserChild.h"
#include "mozilla/dom/MouseEventBinding.h"
#include "mozilla/layers/APZCCallbackHelper.h"
#include "mozilla/widget/nsAutoRollup.h"
#include "nsCOMPtr.h"
#include "nsDocShell.h"
#include "nsIDOMWindowUtils.h"
#include "nsINamed.h"
#include "nsIScrollableFrame.h"
#include "nsIScrollbarMediator.h"
#include "nsITimer.h"
#include "nsIWeakReferenceUtils.h"
#include "nsIWidget.h"
#include "nsLayoutUtils.h"
#include "nsQueryFrame.h"

static mozilla::LazyLogModule sApzEvtLog("apz.eventstate");
#define APZES_LOG(...) MOZ_LOG(sApzEvtLog, LogLevel::Debug, (__VA_ARGS__))

// Static helper functions
namespace {

int32_t WidgetModifiersToDOMModifiers(mozilla::Modifiers aModifiers) {
  int32_t result = 0;
  if (aModifiers & mozilla::MODIFIER_SHIFT) {
    result |= nsIDOMWindowUtils::MODIFIER_SHIFT;
  }
  if (aModifiers & mozilla::MODIFIER_CONTROL) {
    result |= nsIDOMWindowUtils::MODIFIER_CONTROL;
  }
  if (aModifiers & mozilla::MODIFIER_ALT) {
    result |= nsIDOMWindowUtils::MODIFIER_ALT;
  }
  if (aModifiers & mozilla::MODIFIER_META) {
    result |= nsIDOMWindowUtils::MODIFIER_META;
  }
  if (aModifiers & mozilla::MODIFIER_ALTGRAPH) {
    result |= nsIDOMWindowUtils::MODIFIER_ALTGRAPH;
  }
  if (aModifiers & mozilla::MODIFIER_CAPSLOCK) {
    result |= nsIDOMWindowUtils::MODIFIER_CAPSLOCK;
  }
  if (aModifiers & mozilla::MODIFIER_FN) {
    result |= nsIDOMWindowUtils::MODIFIER_FN;
  }
  if (aModifiers & mozilla::MODIFIER_FNLOCK) {
    result |= nsIDOMWindowUtils::MODIFIER_FNLOCK;
  }
  if (aModifiers & mozilla::MODIFIER_NUMLOCK) {
    result |= nsIDOMWindowUtils::MODIFIER_NUMLOCK;
  }
  if (aModifiers & mozilla::MODIFIER_SCROLLLOCK) {
    result |= nsIDOMWindowUtils::MODIFIER_SCROLLLOCK;
  }
  if (aModifiers & mozilla::MODIFIER_SYMBOL) {
    result |= nsIDOMWindowUtils::MODIFIER_SYMBOL;
  }
  if (aModifiers & mozilla::MODIFIER_SYMBOLLOCK) {
    result |= nsIDOMWindowUtils::MODIFIER_SYMBOLLOCK;
  }
  if (aModifiers & mozilla::MODIFIER_OS) {
    result |= nsIDOMWindowUtils::MODIFIER_OS;
  }
  return result;
}

}  // namespace

namespace mozilla {
namespace layers {

APZEventState::APZEventState(nsIWidget* aWidget,
                             ContentReceivedInputBlockCallback&& aCallback)
    : mWidget(nullptr)  // initialized in constructor body
      ,
      mActiveElementManager(new ActiveElementManager()),
      mContentReceivedInputBlockCallback(std::move(aCallback)),
      mPendingTouchPreventedResponse(false),
      mPendingTouchPreventedBlockId(0),
      mEndTouchIsClick(false),
      mFirstTouchCancelled(false),
      mTouchEndCancelled(false),
      mLastTouchIdentifier(0) {
  nsresult rv;
  mWidget = do_GetWeakReference(aWidget, &rv);
  MOZ_ASSERT(NS_SUCCEEDED(rv),
             "APZEventState constructed with a widget that"
             " does not support weak references. APZ will NOT work!");
}

APZEventState::~APZEventState() = default;

class DelayedFireSingleTapEvent final : public nsITimerCallback,
                                        public nsINamed {
 public:
  NS_DECL_ISUPPORTS

  DelayedFireSingleTapEvent(nsWeakPtr aWidget, LayoutDevicePoint& aPoint,
                            Modifiers aModifiers, int32_t aClickCount,
                            nsITimer* aTimer, RefPtr<nsIContent>& aTouchRollup)
      : mWidget(aWidget),
        mPoint(aPoint),
        mModifiers(aModifiers),
        mClickCount(aClickCount)
        // Hold the reference count until we are called back.
        ,
        mTimer(aTimer),
        mTouchRollup(aTouchRollup) {}

  NS_IMETHOD Notify(nsITimer*) override {
    if (nsCOMPtr<nsIWidget> widget = do_QueryReferent(mWidget)) {
      widget::nsAutoRollup rollup(mTouchRollup.get());
      APZCCallbackHelper::FireSingleTapEvent(mPoint, mModifiers, mClickCount,
                                             widget);
    }
    mTimer = nullptr;
    return NS_OK;
  }

  NS_IMETHOD
  GetName(nsACString& aName) override {
    aName.AssignLiteral("DelayedFireSingleTapEvent");
    return NS_OK;
  }

  void ClearTimer() { mTimer = nullptr; }

 private:
  ~DelayedFireSingleTapEvent() = default;

  nsWeakPtr mWidget;
  LayoutDevicePoint mPoint;
  Modifiers mModifiers;
  int32_t mClickCount;
  nsCOMPtr<nsITimer> mTimer;
  RefPtr<nsIContent> mTouchRollup;
};

NS_IMPL_ISUPPORTS(DelayedFireSingleTapEvent, nsITimerCallback, nsINamed)

void APZEventState::ProcessSingleTap(const CSSPoint& aPoint,
                                     const CSSToLayoutDeviceScale& aScale,
                                     Modifiers aModifiers,
                                     int32_t aClickCount) {
  APZES_LOG("Handling single tap at %s with %d\n", Stringify(aPoint).c_str(),
            mTouchEndCancelled);

  RefPtr<nsIContent> touchRollup = GetTouchRollup();
  mTouchRollup = nullptr;

  nsCOMPtr<nsIWidget> widget = GetWidget();
  if (!widget) {
    return;
  }

  if (mTouchEndCancelled) {
    return;
  }

  LayoutDevicePoint ldPoint = aPoint * aScale;

  APZES_LOG("Scheduling timer for click event\n");
  nsCOMPtr<nsITimer> timer = NS_NewTimer();
  RefPtr<DelayedFireSingleTapEvent> callback = new DelayedFireSingleTapEvent(
      mWidget, ldPoint, aModifiers, aClickCount, timer, touchRollup);
  nsresult rv = timer->InitWithCallback(
      callback, StaticPrefs::ui_touch_activation_duration_ms(),
      nsITimer::TYPE_ONE_SHOT);
  if (NS_FAILED(rv)) {
    // Make |callback| not hold the timer, so they will both be destructed when
    // we leave the scope of this function.
    callback->ClearTimer();
  }
}

bool APZEventState::FireContextmenuEvents(PresShell* aPresShell,
                                          const CSSPoint& aPoint,
                                          const CSSToLayoutDeviceScale& aScale,
                                          Modifiers aModifiers,
                                          const nsCOMPtr<nsIWidget>& aWidget) {
  // Suppress retargeting for mouse events generated by a long-press
  EventRetargetSuppression suppression;

  // Synthesize mousemove event for allowing users to emulate to move mouse
  // cursor over the element.  As a result, users can open submenu UI which
  // is opened when mouse cursor is moved over a link (i.e., it's a case that
  // users cannot stay in the page after tapping it).  So, this improves
  // accessibility in websites which are designed for desktop.
  // Note that we don't need to check whether mousemove event is consumed or
  // not because Chrome also ignores the result.
  APZCCallbackHelper::DispatchSynthesizedMouseEvent(
      eMouseMove, 0 /* time */, aPoint * aScale, aModifiers, 0 /* clickCount */,
      aWidget);

  // Converting the modifiers to DOM format for the DispatchMouseEvent call
  // is the most useless thing ever because nsDOMWindowUtils::SendMouseEvent
  // just converts them back to widget format, but that API has many callers,
  // including in JS code, so it's not trivial to change.
  CSSPoint point = CSSPoint::FromAppUnits(
      ViewportUtils::VisualToLayout(CSSPoint::ToAppUnits(aPoint), aPresShell));
  bool eventHandled = APZCCallbackHelper::DispatchMouseEvent(
      aPresShell, NS_LITERAL_STRING("contextmenu"), point, 2, 1,
      WidgetModifiersToDOMModifiers(aModifiers),
      dom::MouseEvent_Binding::MOZ_SOURCE_TOUCH,
      0 /* Use the default value here. */);

  APZES_LOG("Contextmenu event handled: %d\n", eventHandled);
  if (eventHandled) {
    // If the contextmenu event was handled then we're showing a contextmenu,
    // and so we should remove any activation
    mActiveElementManager->ClearActivation();
#ifndef XP_WIN
  } else {
    // If the contextmenu wasn't consumed, fire the eMouseLongTap event.
    nsEventStatus status = APZCCallbackHelper::DispatchSynthesizedMouseEvent(
        eMouseLongTap, /*time*/ 0, aPoint * aScale, aModifiers,
        /*clickCount*/ 1, aWidget);
    eventHandled = (status == nsEventStatus_eConsumeNoDefault);
    APZES_LOG("eMouseLongTap event handled: %d\n", eventHandled);
#endif
  }

  return eventHandled;
}

void APZEventState::ProcessLongTap(PresShell* aPresShell,
                                   const CSSPoint& aPoint,
                                   const CSSToLayoutDeviceScale& aScale,
                                   Modifiers aModifiers,
                                   uint64_t aInputBlockId) {
  APZES_LOG("Handling long tap at %s\n", Stringify(aPoint).c_str());

  nsCOMPtr<nsIWidget> widget = GetWidget();
  if (!widget) {
    return;
  }

  SendPendingTouchPreventedResponse(false);

#ifdef XP_WIN
  // On Windows, we fire the contextmenu events when the user lifts their
  // finger, in keeping with the platform convention. This happens in the
  // ProcessLongTapUp function. However, we still fire the eMouseLongTap event
  // at this time, because things like text selection or dragging may want
  // to know about it.
  nsEventStatus status = APZCCallbackHelper::DispatchSynthesizedMouseEvent(
      eMouseLongTap, /*time*/ 0, aPoint * aScale, aModifiers, /*clickCount*/ 1,
      widget);

  bool eventHandled = (status == nsEventStatus_eConsumeNoDefault);
#else
  bool eventHandled =
      FireContextmenuEvents(aPresShell, aPoint, aScale, aModifiers, widget);
#endif
  mContentReceivedInputBlockCallback(aInputBlockId, eventHandled);

  if (eventHandled) {
    // Also send a touchcancel to content, so that listeners that might be
    // waiting for a touchend don't trigger.
    WidgetTouchEvent cancelTouchEvent(true, eTouchCancel, widget.get());
    cancelTouchEvent.mModifiers = aModifiers;
    auto ldPoint = LayoutDeviceIntPoint::Round(aPoint * aScale);
    cancelTouchEvent.mTouches.AppendElement(new mozilla::dom::Touch(
        mLastTouchIdentifier, ldPoint, LayoutDeviceIntPoint(), 0, 0));
    APZCCallbackHelper::DispatchWidgetEvent(cancelTouchEvent);
  }
}

void APZEventState::ProcessLongTapUp(PresShell* aPresShell,
                                     const CSSPoint& aPoint,
                                     const CSSToLayoutDeviceScale& aScale,
                                     Modifiers aModifiers) {
#ifdef XP_WIN
  nsCOMPtr<nsIWidget> widget = GetWidget();
  if (widget) {
    FireContextmenuEvents(aPresShell, aPoint, aScale, aModifiers, widget);
  }
#endif
}

void APZEventState::ProcessTouchEvent(const WidgetTouchEvent& aEvent,
                                      const ScrollableLayerGuid& aGuid,
                                      uint64_t aInputBlockId,
                                      nsEventStatus aApzResponse,
                                      nsEventStatus aContentResponse) {
  if (aEvent.mMessage == eTouchStart && aEvent.mTouches.Length() > 0) {
    mActiveElementManager->SetTargetElement(aEvent.mTouches[0]->GetTarget());
    mLastTouchIdentifier = aEvent.mTouches[0]->Identifier();
  }

  bool isTouchPrevented = aContentResponse == nsEventStatus_eConsumeNoDefault;
  bool sentContentResponse = false;
  APZES_LOG("Handling event type %d\n", aEvent.mMessage);
  switch (aEvent.mMessage) {
    case eTouchStart: {
      mTouchEndCancelled = false;
      mTouchRollup = do_GetWeakReference(widget::nsAutoRollup::GetLastRollup());

      sentContentResponse = SendPendingTouchPreventedResponse(false);
      // sentContentResponse can be true here if we get two TOUCH_STARTs in a
      // row and just responded to the first one.

      // We're about to send a response back to APZ, but we should only do it
      // for events that went through APZ (which should be all of them).
      MOZ_ASSERT(aEvent.mFlags.mHandledByAPZ);

      // If the first touchstart event was preventDefaulted, ensure that any
      // subsequent additional touchstart events also get preventDefaulted. This
      // ensures that e.g. pinch zooming is prevented even if just the first
      // touchstart was prevented by content.
      if (mTouchCounter.GetActiveTouchCount() == 0) {
        mFirstTouchCancelled = isTouchPrevented;
      } else {
        if (mFirstTouchCancelled && !isTouchPrevented) {
          APZES_LOG(
              "Propagating prevent-default from first-touch for block %" PRIu64
              "\n",
              aInputBlockId);
        }
        isTouchPrevented |= mFirstTouchCancelled;
      }

      if (isTouchPrevented) {
        mContentReceivedInputBlockCallback(aInputBlockId, isTouchPrevented);
        sentContentResponse = true;
      } else {
        APZES_LOG("Event not prevented; pending response for %" PRIu64 " %s\n",
                  aInputBlockId, Stringify(aGuid).c_str());
        mPendingTouchPreventedResponse = true;
        mPendingTouchPreventedGuid = aGuid;
        mPendingTouchPreventedBlockId = aInputBlockId;
      }
      break;
    }

    case eTouchEnd:
      if (isTouchPrevented) {
        mTouchEndCancelled = true;
        mEndTouchIsClick = false;
      }
      [[fallthrough]];
    case eTouchCancel:
      mActiveElementManager->HandleTouchEndEvent(mEndTouchIsClick);
      [[fallthrough]];
    case eTouchMove: {
      if (mPendingTouchPreventedResponse) {
        MOZ_ASSERT(aGuid == mPendingTouchPreventedGuid);
      }
      sentContentResponse = SendPendingTouchPreventedResponse(isTouchPrevented);
      break;
    }

    default:
      MOZ_ASSERT_UNREACHABLE("Unknown touch event type");
      break;
  }

  mTouchCounter.Update(aEvent);
  if (mTouchCounter.GetActiveTouchCount() == 0) {
    mFirstTouchCancelled = false;
  }

  if (sentContentResponse && !isTouchPrevented &&
      aApzResponse == nsEventStatus_eConsumeDoDefault &&
      StaticPrefs::dom_w3c_pointer_events_enabled()) {
    WidgetTouchEvent cancelEvent(aEvent);
    cancelEvent.mMessage = eTouchPointerCancel;
    cancelEvent.mFlags.mCancelable = false;  // mMessage != eTouchCancel;
    for (uint32_t i = 0; i < cancelEvent.mTouches.Length(); ++i) {
      if (mozilla::dom::Touch* touch = cancelEvent.mTouches[i]) {
        touch->convertToPointer = true;
      }
    }
    nsEventStatus status;
    cancelEvent.mWidget->DispatchEvent(&cancelEvent, status);
  }
}

void APZEventState::ProcessWheelEvent(const WidgetWheelEvent& aEvent,
                                      uint64_t aInputBlockId) {
  // If this event starts a swipe, indicate that it shouldn't result in a
  // scroll by setting defaultPrevented to true.
  bool defaultPrevented = aEvent.DefaultPrevented() || aEvent.TriggersSwipe();
  mContentReceivedInputBlockCallback(aInputBlockId, defaultPrevented);
}

void APZEventState::ProcessMouseEvent(const WidgetMouseEvent& aEvent,
                                      uint64_t aInputBlockId) {
  bool defaultPrevented = false;
  mContentReceivedInputBlockCallback(aInputBlockId, defaultPrevented);
}

void APZEventState::ProcessAPZStateChange(ViewID aViewId,
                                          APZStateChange aChange, int aArg) {
  switch (aChange) {
    case APZStateChange::eTransformBegin: {
      nsIScrollableFrame* sf = nsLayoutUtils::FindScrollableFrameFor(aViewId);
      if (sf) {
        sf->SetTransformingByAPZ(true);
      }
      nsIScrollbarMediator* scrollbarMediator = do_QueryFrame(sf);
      if (scrollbarMediator) {
        scrollbarMediator->ScrollbarActivityStarted();
      }

      nsIContent* content = nsLayoutUtils::FindContentFor(aViewId);
      dom::Document* doc = content ? content->GetComposedDoc() : nullptr;
      nsCOMPtr<nsIDocShell> docshell(doc ? doc->GetDocShell() : nullptr);
      if (docshell && sf) {
        nsDocShell* nsdocshell = static_cast<nsDocShell*>(docshell.get());
        nsdocshell->NotifyAsyncPanZoomStarted();
      }
      break;
    }
    case APZStateChange::eTransformEnd: {
      nsIScrollableFrame* sf = nsLayoutUtils::FindScrollableFrameFor(aViewId);
      if (sf) {
        sf->SetTransformingByAPZ(false);
      }
      nsIScrollbarMediator* scrollbarMediator = do_QueryFrame(sf);
      if (scrollbarMediator) {
        scrollbarMediator->ScrollbarActivityStopped();
      }

      nsIContent* content = nsLayoutUtils::FindContentFor(aViewId);
      dom::Document* doc = content ? content->GetComposedDoc() : nullptr;
      nsCOMPtr<nsIDocShell> docshell(doc ? doc->GetDocShell() : nullptr);
      if (docshell && sf) {
        nsDocShell* nsdocshell = static_cast<nsDocShell*>(docshell.get());
        nsdocshell->NotifyAsyncPanZoomStopped();
      }
      break;
    }
    case APZStateChange::eStartTouch: {
      mActiveElementManager->HandleTouchStart(aArg);
      break;
    }
    case APZStateChange::eStartPanning: {
      // The user started to pan, so we don't want anything to be :active.
      mActiveElementManager->ClearActivation();
      break;
    }
    case APZStateChange::eEndTouch: {
      mEndTouchIsClick = aArg;
      mActiveElementManager->HandleTouchEnd();
      break;
    }
  }
}

bool APZEventState::SendPendingTouchPreventedResponse(bool aPreventDefault) {
  if (mPendingTouchPreventedResponse) {
    APZES_LOG("Sending response %d for pending guid: %s\n", aPreventDefault,
              Stringify(mPendingTouchPreventedGuid).c_str());
    mContentReceivedInputBlockCallback(mPendingTouchPreventedBlockId,
                                       aPreventDefault);
    mPendingTouchPreventedResponse = false;
    return true;
  }
  return false;
}

already_AddRefed<nsIWidget> APZEventState::GetWidget() const {
  nsCOMPtr<nsIWidget> result = do_QueryReferent(mWidget);
  return result.forget();
}

already_AddRefed<nsIContent> APZEventState::GetTouchRollup() const {
  nsCOMPtr<nsIContent> result = do_QueryReferent(mTouchRollup);
  return result.forget();
}

}  // namespace layers
}  // namespace mozilla
