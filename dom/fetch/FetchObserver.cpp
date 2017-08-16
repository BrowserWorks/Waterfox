/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "FetchObserver.h"
#include "mozilla/dom/Event.h"

namespace mozilla {
namespace dom {

NS_IMPL_CYCLE_COLLECTION_CLASS(FetchObserver)

NS_IMPL_CYCLE_COLLECTION_TRAVERSE_BEGIN_INHERITED(FetchObserver,
                                                  DOMEventTargetHelper)
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_END

NS_IMPL_CYCLE_COLLECTION_UNLINK_BEGIN_INHERITED(FetchObserver,
                                                DOMEventTargetHelper)
NS_IMPL_CYCLE_COLLECTION_UNLINK_END

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION_INHERITED(FetchObserver)
NS_INTERFACE_MAP_END_INHERITING(DOMEventTargetHelper)

NS_IMPL_ADDREF_INHERITED(FetchObserver, DOMEventTargetHelper)
NS_IMPL_RELEASE_INHERITED(FetchObserver, DOMEventTargetHelper)

/* static */ bool
FetchObserver::IsEnabled(JSContext* aCx, JSObject* aGlobal)
{
  if (NS_IsMainThread()) {
    return Preferences::GetBool("dom.fetchObserver.enabled", false);
  }

  using namespace workers;

  // Otherwise, check the pref via the WorkerPrivate
  WorkerPrivate* workerPrivate = GetWorkerPrivateFromContext(aCx);
  if (!workerPrivate) {
    return false;
  }

  return workerPrivate->FetchObserverEnabled();
}

FetchObserver::FetchObserver(nsIGlobalObject* aGlobal,
                             FetchSignal* aSignal)
  : DOMEventTargetHelper(aGlobal)
  , mState(FetchState::Requesting)
{
  if (aSignal) {
    Follow(aSignal);
  }
}

JSObject*
FetchObserver::WrapObject(JSContext* aCx, JS::Handle<JSObject*> aGivenProto)
{
  return FetchObserverBinding::Wrap(aCx, this, aGivenProto);
}

FetchState
FetchObserver::State() const
{
  return mState;
}

void
FetchObserver::Aborted()
{
  SetState(FetchState::Aborted);
}

void
FetchObserver::SetState(FetchState aState)
{
  MOZ_ASSERT(mState < aState);

  if (mState == FetchState::Aborted ||
      mState == FetchState::Errored ||
      mState == FetchState::Complete) {
    // We are already in a final state.
    return;
  }

  // We cannot pass from Requesting to Complete directly.
  if (mState == FetchState::Requesting &&
      aState == FetchState::Complete) {
    SetState(FetchState::Responding);
  }

  mState = aState;

  if (mState == FetchState::Aborted ||
      mState == FetchState::Errored ||
      mState == FetchState::Complete) {
    Unfollow();
  }

  EventInit init;
  init.mBubbles = false;
  init.mCancelable = false;

  // TODO which kind of event should we dispatch here?

  RefPtr<Event> event =
    Event::Constructor(this, NS_LITERAL_STRING("statechange"), init);
  event->SetTrusted(true);

  bool dummy;
  DispatchEvent(event, &dummy);
}

} // dom namespace
} // mozilla namespace
