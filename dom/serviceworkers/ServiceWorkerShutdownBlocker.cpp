/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "ServiceWorkerShutdownBlocker.h"

#include <chrono>
#include <utility>

#include "MainThreadUtils.h"
#include "nsDebug.h"
#include "nsError.h"
#include "nsIWritablePropertyBag2.h"
#include "nsThreadUtils.h"

#include "mozilla/Assertions.h"
#include "mozilla/RefPtr.h"

namespace mozilla {
namespace dom {

NS_IMPL_ISUPPORTS(ServiceWorkerShutdownBlocker, nsIAsyncShutdownBlocker)

NS_IMETHODIMP ServiceWorkerShutdownBlocker::GetName(nsAString& aNameOut) {
  aNameOut = NS_LITERAL_STRING(
      "ServiceWorkerShutdownBlocker: shutting down Service Workers");
  return NS_OK;
}

NS_IMETHODIMP
ServiceWorkerShutdownBlocker::BlockShutdown(nsIAsyncShutdownClient* aClient) {
  AssertIsOnMainThread();
  MOZ_ASSERT(!mShutdownClient);

  mShutdownClient = aClient;

  MaybeUnblockShutdown();
  MaybeInitUnblockShutdownTimer();

  return NS_OK;
}

NS_IMETHODIMP ServiceWorkerShutdownBlocker::GetState(nsIPropertyBag** aBagOut) {
  AssertIsOnMainThread();
  MOZ_ASSERT(aBagOut);

  nsCOMPtr<nsIWritablePropertyBag2> propertyBag =
      do_CreateInstance("@mozilla.org/hash-property-bag;1");

  if (NS_WARN_IF(!propertyBag)) {
    return NS_ERROR_OUT_OF_MEMORY;
  }

  nsresult rv = propertyBag->SetPropertyAsBool(
      NS_LITERAL_STRING("acceptingPromises"), IsAcceptingPromises());

  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  rv = propertyBag->SetPropertyAsUint32(NS_LITERAL_STRING("pendingPromises"),
                                        GetPendingPromises());

  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  nsAutoCString shutdownStates;

  for (auto iter = mShutdownStates.iter(); !iter.done(); iter.next()) {
    shutdownStates.Append(iter.get().value().GetProgressString());
    shutdownStates.Append(", ");
  }

  rv = propertyBag->SetPropertyAsACString(NS_LITERAL_STRING("shutdownStates"),
                                          shutdownStates);

  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  propertyBag.forget(aBagOut);

  return NS_OK;
}

/* static */ already_AddRefed<ServiceWorkerShutdownBlocker>
ServiceWorkerShutdownBlocker::CreateAndRegisterOn(
    nsIAsyncShutdownClient* aShutdownBarrier) {
  AssertIsOnMainThread();
  MOZ_ASSERT(aShutdownBarrier);

  RefPtr<ServiceWorkerShutdownBlocker> blocker =
      new ServiceWorkerShutdownBlocker();

  nsresult rv = aShutdownBarrier->AddBlocker(
      blocker.get(), NS_LITERAL_STRING(__FILE__), __LINE__,
      NS_LITERAL_STRING("Service Workers shutdown"));

  if (NS_WARN_IF(NS_FAILED(rv))) {
    return nullptr;
  }

  return blocker.forget();
}

void ServiceWorkerShutdownBlocker::WaitOnPromise(
    GenericNonExclusivePromise* aPromise, uint32_t aShutdownStateId) {
  AssertIsOnMainThread();
  MOZ_DIAGNOSTIC_ASSERT(IsAcceptingPromises());
  MOZ_ASSERT(aPromise);
  MOZ_ASSERT(mShutdownStates.has(aShutdownStateId));

  ++mState.as<AcceptingPromises>().mPendingPromises;

  RefPtr<ServiceWorkerShutdownBlocker> self = this;

  aPromise->Then(GetCurrentThreadSerialEventTarget(), __func__,
                 [self = std::move(self), shutdownStateId = aShutdownStateId](
                     const GenericNonExclusivePromise::ResolveOrRejectValue&) {
                   // Progress reporting might race with aPromise settling.
                   self->mShutdownStates.remove(shutdownStateId);

                   if (!self->PromiseSettled()) {
                     self->MaybeUnblockShutdown();
                   }
                 });
}

void ServiceWorkerShutdownBlocker::StopAcceptingPromises() {
  AssertIsOnMainThread();
  MOZ_ASSERT(IsAcceptingPromises());

  mState = AsVariant(NotAcceptingPromises(mState.as<AcceptingPromises>()));

  MaybeUnblockShutdown();
  MaybeInitUnblockShutdownTimer();
}

uint32_t ServiceWorkerShutdownBlocker::CreateShutdownState() {
  AssertIsOnMainThread();

  static uint32_t nextShutdownStateId = 1;

  MOZ_ALWAYS_TRUE(mShutdownStates.putNew(nextShutdownStateId,
                                         ServiceWorkerShutdownState()));

  return nextShutdownStateId++;
}

void ServiceWorkerShutdownBlocker::ReportShutdownProgress(
    uint32_t aShutdownStateId, Progress aProgress) {
  AssertIsOnMainThread();
  MOZ_RELEASE_ASSERT(aShutdownStateId != kInvalidShutdownStateId);

  auto lookup = mShutdownStates.lookup(aShutdownStateId);

  // Progress reporting might race with the promise that WaitOnPromise is called
  // with settling.
  if (!lookup) {
    return;
  }

  // This will check for a valid progress transition with assertions.
  lookup->value().SetProgress(aProgress);

  if (aProgress == Progress::ShutdownCompleted) {
    mShutdownStates.remove(lookup);
  }
}

ServiceWorkerShutdownBlocker::ServiceWorkerShutdownBlocker()
    : mState(VariantType<AcceptingPromises>()) {
  AssertIsOnMainThread();
}

ServiceWorkerShutdownBlocker::~ServiceWorkerShutdownBlocker() {
  MOZ_ASSERT(!IsAcceptingPromises());
  MOZ_ASSERT(!GetPendingPromises());
  MOZ_ASSERT(!mShutdownClient);
}

void ServiceWorkerShutdownBlocker::MaybeUnblockShutdown() {
  AssertIsOnMainThread();

  if (!mShutdownClient || IsAcceptingPromises() || GetPendingPromises()) {
    return;
  }

  UnblockShutdown();
}

void ServiceWorkerShutdownBlocker::UnblockShutdown() {
  MOZ_ASSERT(mShutdownClient);

  mShutdownClient->RemoveBlocker(this);
  mShutdownClient = nullptr;

  if (mTimer) {
    mTimer->Cancel();
  }
}

uint32_t ServiceWorkerShutdownBlocker::PromiseSettled() {
  AssertIsOnMainThread();
  MOZ_ASSERT(GetPendingPromises());

  if (IsAcceptingPromises()) {
    return --mState.as<AcceptingPromises>().mPendingPromises;
  }

  return --mState.as<NotAcceptingPromises>().mPendingPromises;
}

bool ServiceWorkerShutdownBlocker::IsAcceptingPromises() const {
  AssertIsOnMainThread();

  return mState.is<AcceptingPromises>();
}

uint32_t ServiceWorkerShutdownBlocker::GetPendingPromises() const {
  AssertIsOnMainThread();

  if (IsAcceptingPromises()) {
    return mState.as<AcceptingPromises>().mPendingPromises;
  }

  return mState.as<NotAcceptingPromises>().mPendingPromises;
}

ServiceWorkerShutdownBlocker::NotAcceptingPromises::NotAcceptingPromises(
    AcceptingPromises aPreviousState)
    : mPendingPromises(aPreviousState.mPendingPromises) {
  AssertIsOnMainThread();
}

NS_IMETHODIMP ServiceWorkerShutdownBlocker::Notify(nsITimer*) {
  // TODO: this method being called indicates that there are ServiceWorkers
  // that did not complete shutdown before the timer expired - there should be
  // a telemetry ping or some other way of recording the state of when this
  // happens (e.g. what's returned by GetState()).
  UnblockShutdown();
  return NS_OK;
}

void ServiceWorkerShutdownBlocker::MaybeInitUnblockShutdownTimer() {
#ifdef RELEASE_OR_BETA
  AssertIsOnMainThread();
  MOZ_ASSERT(!mTimer);

  if (!mShutdownClient || IsAcceptingPromises()) {
    return;
  }

  MOZ_ASSERT(GetPendingPromises(),
             "Shouldn't be blocking shutdown with zero pending promises.");

  using namespace std::chrono_literals;

  static constexpr auto delay =
      std::chrono::duration_cast<std::chrono::milliseconds>(10s);

  mTimer = NS_NewTimer();

  mTimer->InitWithCallback(this, delay.count(), nsITimer::TYPE_ONE_SHOT);
#endif
}

}  // namespace dom
}  // namespace mozilla
