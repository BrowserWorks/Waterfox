/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "ScrollbarActivity.h"

#include "PresShell.h"
#include "mozilla/LookAndFeel.h"
#include "mozilla/ScrollContainerFrame.h"
#include "mozilla/dom/Document.h"
#include "mozilla/dom/Element.h"
#include "mozilla/dom/Event.h"
#include "nsContentUtils.h"
#include "nsIContent.h"
#include "nsIFrame.h"
#include "nsIScrollbarMediator.h"
#include "nsITimer.h"
#include "nsLayoutUtils.h"
#include "nsQueryFrame.h"
#include "nsRefreshDriver.h"
#include "nsScrollbarFrame.h"

namespace mozilla::layout {

using mozilla::dom::Element;

NS_IMPL_ISUPPORTS(ScrollbarActivity, nsIDOMEventListener)

static bool DisplayOnMouseMove() {
  return LookAndFeel::GetInt(LookAndFeel::IntID::ScrollbarDisplayOnMouseMove);
}

void ScrollbarActivity::Destroy() {
  StopListeningForScrollAreaEvents();
  CancelFadeTimer();
}

void ScrollbarActivity::ActivityOccurred() {
  nsAutoScriptBlocker scriptBlocker;
  ActivityStarted();
  ActivityStopped();
}

static void SetScrollbarActive(Element* aScrollbar, bool aIsActive) {
  if (!aScrollbar) {
    return;
  }
  if (aIsActive) {
    if (nsScrollbarFrame* sf = do_QueryFrame(aScrollbar->GetPrimaryFrame())) {
      sf->WillBecomeActive();
    }
  }
  aScrollbar->SetBoolAttr(nsGkAtoms::active, aIsActive);
}

void ScrollbarActivity::ActivityStarted() {
  const bool wasActive = IsActive();
  mNestedActivityCounter++;
  if (wasActive) {
    return;
  }
  CancelFadeTimer();
  if (mScrollbarEffectivelyVisible) {
    return;
  }
  StartListeningForScrollAreaEvents();
  SetScrollbarActive(GetHorizontalScrollbar(), true);
  SetScrollbarActive(GetVerticalScrollbar(), true);
  mScrollbarEffectivelyVisible = true;
}

void ScrollbarActivity::ActivityStopped() {
  if (!IsActive()) {
    // This can happen if there was a frame reconstruction while the activity
    // was ongoing. In this case we just do nothing. We should probably handle
    // this case better.
    return;
  }
  mNestedActivityCounter--;
  if (IsActive()) {
    return;
  }
  StartFadeTimer();
}

NS_IMETHODIMP
ScrollbarActivity::HandleEvent(dom::Event* aEvent) {
  if (!mScrollbarEffectivelyVisible && !DisplayOnMouseMove()) {
    return NS_OK;
  }

  nsAutoString type;
  aEvent->GetType(type);

  auto* targetContent =
      nsIContent::FromEventTargetOrNull(aEvent->GetOriginalTarget());
  if (type.EqualsLiteral("mousemove")) {
    // Mouse motions anywhere in the scrollable frame should keep the
    // scrollbars visible, but we have to be careful as content descendants of
    // our scrollable content aren't necessarily scrolled by our scroll frame
    // (if they are out of flow and their containing block is not a descendant
    // of our scroll frame) and we don't want those to activate us.
    nsIFrame* scrollFrame = do_QueryFrame(mScrollableFrame);
    MOZ_ASSERT(scrollFrame);
    ScrollContainerFrame* scrollContainerFrame = do_QueryFrame(scrollFrame);
    nsIFrame* targetFrame =
        targetContent ? targetContent->GetPrimaryFrame() : nullptr;
    if ((scrollContainerFrame &&
         scrollContainerFrame->IsRootScrollFrameOfDocument()) ||
        !targetFrame ||
        nsLayoutUtils::IsAncestorFrameCrossDocInProcess(
            scrollFrame, targetFrame,
            scrollFrame->PresShell()->GetRootFrame())) {
      ActivityOccurred();
    }
    return NS_OK;
  }

  return NS_OK;
}

void ScrollbarActivity::StartListeningForScrollAreaEvents() {
  if (mListeningForScrollAreaEvents) {
    return;
  }
  nsIFrame* scrollArea = do_QueryFrame(mScrollableFrame);
  scrollArea->GetContent()->AddEventListener(u"mousemove"_ns, this, true);
  mListeningForScrollAreaEvents = true;
}

void ScrollbarActivity::StopListeningForScrollAreaEvents() {
  if (!mListeningForScrollAreaEvents) {
    return;
  }
  nsIFrame* scrollArea = do_QueryFrame(mScrollableFrame);
  scrollArea->GetContent()->RemoveEventListener(u"mousemove"_ns, this, true);
  mListeningForScrollAreaEvents = false;
}

void ScrollbarActivity::CancelFadeTimer() {
  if (mFadeTimer) {
    mFadeTimer->Cancel();
  }
}

void ScrollbarActivity::StartFadeTimer() {
  CancelFadeTimer();
  if (StaticPrefs::layout_testing_overlay_scrollbars_always_visible()) {
    return;
  }
  if (!mFadeTimer) {
    mFadeTimer = NS_NewTimer();
  }
  mFadeTimer->InitWithNamedFuncCallback(
      [](nsITimer*, void* aClosure) {
        RefPtr<ScrollbarActivity> activity =
            static_cast<ScrollbarActivity*>(aClosure);
        activity->BeginFade();
      },
      this, LookAndFeel::GetInt(LookAndFeel::IntID::ScrollbarFadeBeginDelay),
      nsITimer::TYPE_ONE_SHOT, "ScrollbarActivity::FadeBeginTimerFired"_ns);
}

void ScrollbarActivity::BeginFade() {
  nsAutoScriptBlocker scriptBlocker;
  MOZ_ASSERT(!IsActive());
  mScrollbarEffectivelyVisible = false;
  SetScrollbarActive(GetHorizontalScrollbar(), false);
  SetScrollbarActive(GetVerticalScrollbar(), false);
}

Element* ScrollbarActivity::GetScrollbarContent(bool aVertical) {
  nsIFrame* box = mScrollableFrame->GetScrollbarBox(aVertical);
  return box ? box->GetContent()->AsElement() : nullptr;
}

}  // namespace mozilla::layout
