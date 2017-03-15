/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/dom/AnimationEvent.h"
#include "mozilla/ContentEvents.h"
#include "prtime.h"

namespace mozilla {
namespace dom {

AnimationEvent::AnimationEvent(EventTarget* aOwner,
                               nsPresContext* aPresContext,
                               InternalAnimationEvent* aEvent)
  : Event(aOwner, aPresContext,
          aEvent ? aEvent : new InternalAnimationEvent(false, eVoidEvent))
{
  if (aEvent) {
    mEventIsInternal = false;
  }
  else {
    mEventIsInternal = true;
    mEvent->mTime = PR_Now();
  }
}

NS_INTERFACE_MAP_BEGIN(AnimationEvent)
  NS_INTERFACE_MAP_ENTRY(nsIDOMAnimationEvent)
NS_INTERFACE_MAP_END_INHERITING(Event)

NS_IMPL_ADDREF_INHERITED(AnimationEvent, Event)
NS_IMPL_RELEASE_INHERITED(AnimationEvent, Event)

//static
already_AddRefed<AnimationEvent>
AnimationEvent::Constructor(const GlobalObject& aGlobal,
                            const nsAString& aType,
                            const AnimationEventInit& aParam,
                            ErrorResult& aRv)
{
  nsCOMPtr<EventTarget> t = do_QueryInterface(aGlobal.GetAsSupports());
  RefPtr<AnimationEvent> e = new AnimationEvent(t, nullptr, nullptr);
  bool trusted = e->Init(t);

  e->InitEvent(aType, aParam.mBubbles, aParam.mCancelable);

  InternalAnimationEvent* internalEvent = e->mEvent->AsAnimationEvent();
  internalEvent->mAnimationName = aParam.mAnimationName;
  internalEvent->mElapsedTime = aParam.mElapsedTime;
  internalEvent->mPseudoElement = aParam.mPseudoElement;

  e->SetTrusted(trusted);
  e->SetComposed(aParam.mComposed);
  return e.forget();
}

NS_IMETHODIMP
AnimationEvent::GetAnimationName(nsAString& aAnimationName)
{
  aAnimationName = mEvent->AsAnimationEvent()->mAnimationName;
  return NS_OK;
}

NS_IMETHODIMP
AnimationEvent::GetElapsedTime(float* aElapsedTime)
{
  *aElapsedTime = ElapsedTime();
  return NS_OK;
}

float
AnimationEvent::ElapsedTime()
{
  return mEvent->AsAnimationEvent()->mElapsedTime;
}

NS_IMETHODIMP
AnimationEvent::GetPseudoElement(nsAString& aPseudoElement)
{
  aPseudoElement = mEvent->AsAnimationEvent()->mPseudoElement;
  return NS_OK;
}

} // namespace dom
} // namespace mozilla

using namespace mozilla;
using namespace mozilla::dom;

already_AddRefed<AnimationEvent>
NS_NewDOMAnimationEvent(EventTarget* aOwner,
                        nsPresContext* aPresContext,
                        InternalAnimationEvent* aEvent)
{
  RefPtr<AnimationEvent> it =
    new AnimationEvent(aOwner, aPresContext, aEvent);
  return it.forget();
}
