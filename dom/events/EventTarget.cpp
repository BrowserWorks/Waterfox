/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/EventListenerManager.h"
#include "mozilla/dom/EventTarget.h"
#include "mozilla/dom/EventTargetBinding.h"
#include "mozilla/dom/ConstructibleEventTarget.h"
#include "nsIGlobalObject.h"
#include "nsThreadUtils.h"

namespace mozilla {
namespace dom {

/* static */
already_AddRefed<EventTarget>
EventTarget::Constructor(const GlobalObject& aGlobal, ErrorResult& aRv)
{
  nsCOMPtr<nsIGlobalObject> global = do_QueryInterface(aGlobal.GetAsSupports());
  if (!global) {
    aRv.Throw(NS_ERROR_UNEXPECTED);
    return nullptr;
  }
  RefPtr<EventTarget> target = new ConstructibleEventTarget(global);
  return target.forget();
}

void
EventTarget::RemoveEventListener(const nsAString& aType,
                                 EventListener* aListener,
                                 const EventListenerOptionsOrBoolean& aOptions,
                                 ErrorResult& aRv)
{
  EventListenerManager* elm = GetExistingListenerManager();
  if (elm) {
    elm->RemoveEventListener(aType, aListener, aOptions);
  }
}

EventHandlerNonNull*
EventTarget::GetEventHandler(nsIAtom* aType, const nsAString& aTypeString)
{
  EventListenerManager* elm = GetExistingListenerManager();
  return elm ? elm->GetEventHandler(aType, aTypeString) : nullptr;
}

void
EventTarget::SetEventHandler(const nsAString& aType,
                             EventHandlerNonNull* aHandler,
                             ErrorResult& aRv)
{
  if (!StringBeginsWith(aType, NS_LITERAL_STRING("on"))) {
    aRv.Throw(NS_ERROR_INVALID_ARG);
    return;
  }
  if (NS_IsMainThread()) {
    nsCOMPtr<nsIAtom> type = NS_Atomize(aType);
    SetEventHandler(type, EmptyString(), aHandler);
    return;
  }
  SetEventHandler(nullptr,
                  Substring(aType, 2), // Remove "on"
                  aHandler);
}

void
EventTarget::SetEventHandler(nsIAtom* aType, const nsAString& aTypeString,
                             EventHandlerNonNull* aHandler)
{
  GetOrCreateListenerManager()->SetEventHandler(aType, aTypeString, aHandler);
}

bool
EventTarget::HasUntrustedOrNonSystemGroupKeyEventListeners() const
{
  EventListenerManager* elm = GetExistingListenerManager();
  return elm && elm->HasUntrustedOrNonSystemGroupKeyEventListeners();
}

bool
EventTarget::IsApzAware() const
{
  EventListenerManager* elm = GetExistingListenerManager();
  return elm && elm->HasApzAwareListeners();
}

bool
EventTarget::DispatchEvent(Event& aEvent,
                           CallerType aCallerType,
                           ErrorResult& aRv)
{
  bool result = false;
  aRv = DispatchEvent(&aEvent, &result);
  return !aEvent.DefaultPrevented(aCallerType);
}

} // namespace dom
} // namespace mozilla
