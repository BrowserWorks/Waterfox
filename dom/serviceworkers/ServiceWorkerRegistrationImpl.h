/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_dom_serviceworkerregistrationimpl_h
#define mozilla_dom_serviceworkerregistrationimpl_h

#include "mozilla/dom/WorkerPrivate.h"
#include "mozilla/Unused.h"
#include "nsCycleCollectionParticipant.h"
#include "mozilla/dom/Document.h"
#include "nsPIDOMWindow.h"
#include "ServiceWorkerManager.h"
#include "ServiceWorkerRegistration.h"
#include "ServiceWorkerRegistrationListener.h"

namespace mozilla {
namespace dom {

class Promise;
class PushManager;
class ServiceWorker;
class WeakWorkerRef;

////////////////////////////////////////////////////
// Main Thread implementation

class ServiceWorkerRegistrationMainThread final
    : public ServiceWorkerRegistration::Inner,
      public ServiceWorkerRegistrationListener {
 public:
  NS_INLINE_DECL_REFCOUNTING(ServiceWorkerRegistrationMainThread, override)

  explicit ServiceWorkerRegistrationMainThread(
      const ServiceWorkerRegistrationDescriptor& aDescriptor);

  // ServiceWorkerRegistration::Inner
  void SetServiceWorkerRegistration(ServiceWorkerRegistration* aReg) override;

  void ClearServiceWorkerRegistration(ServiceWorkerRegistration* aReg) override;

  void Update(const nsCString& aNewestWorkerScriptUrl,
              ServiceWorkerRegistrationCallback&& aSuccessCB,
              ServiceWorkerFailureCallback&& aFailureCB) override;

  void Unregister(ServiceWorkerBoolCallback&& aSuccessCB,
                  ServiceWorkerFailureCallback&& aFailureCB) override;

  // ServiceWorkerRegistrationListener
  void UpdateState(
      const ServiceWorkerRegistrationDescriptor& aDescriptor) override;

  void FireUpdateFound() override;

  void RegistrationCleared() override;

  void GetScope(nsAString& aScope) const override { aScope = mScope; }

  bool MatchesDescriptor(
      const ServiceWorkerRegistrationDescriptor& aDescriptor) override;

 private:
  ~ServiceWorkerRegistrationMainThread();

  void StartListeningForEvents();

  void StopListeningForEvents();

  void RegistrationClearedInternal();

  ServiceWorkerRegistration* mOuter;
  ServiceWorkerRegistrationDescriptor mDescriptor;
  RefPtr<ServiceWorkerRegistrationInfo> mInfo;
  const nsString mScope;
  bool mListeningForEvents;
};

////////////////////////////////////////////////////
// Worker Thread implementation

class WorkerListener;

class ServiceWorkerRegistrationWorkerThread final
    : public ServiceWorkerRegistration::Inner {
  friend class WorkerListener;

 public:
  NS_INLINE_DECL_REFCOUNTING(ServiceWorkerRegistrationWorkerThread, override)

  explicit ServiceWorkerRegistrationWorkerThread(
      const ServiceWorkerRegistrationDescriptor& aDescriptor);

  void RegistrationCleared();

  // ServiceWorkerRegistration::Inner
  void SetServiceWorkerRegistration(ServiceWorkerRegistration* aReg) override;

  void ClearServiceWorkerRegistration(ServiceWorkerRegistration* aReg) override;

  void Update(const nsCString& aNewestWorkerScriptUrl,
              ServiceWorkerRegistrationCallback&& aSuccessCB,
              ServiceWorkerFailureCallback&& aFailureCB) override;

  void Unregister(ServiceWorkerBoolCallback&& aSuccessCB,
                  ServiceWorkerFailureCallback&& aFailureCB) override;

 private:
  ~ServiceWorkerRegistrationWorkerThread();

  void InitListener();

  void ReleaseListener();

  void UpdateState(const ServiceWorkerRegistrationDescriptor& aDescriptor);

  void FireUpdateFound();

  // This can be called only by WorkerListener.
  WorkerPrivate* GetWorkerPrivate(const MutexAutoLock& aProofOfLock);

  ServiceWorkerRegistration* mOuter;
  const ServiceWorkerRegistrationDescriptor mDescriptor;
  const nsString mScope;
  RefPtr<WorkerListener> mListener;
  RefPtr<WeakWorkerRef> mWorkerRef;
};

}  // namespace dom
}  // namespace mozilla

#endif  // mozilla_dom_serviceworkerregistrationimpl_h
