/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_dom_PresentationChild_h
#define mozilla_dom_PresentationChild_h

#include "mozilla/dom/PPresentationBuilderChild.h"
#include "mozilla/dom/PPresentationChild.h"
#include "mozilla/dom/PPresentationRequestChild.h"

class nsIPresentationServiceCallback;

namespace mozilla {
namespace dom {

class PresentationIPCService;

class PresentationChild final : public PPresentationChild {
 public:
  explicit PresentationChild(PresentationIPCService* aService);

  virtual void ActorDestroy(ActorDestroyReason aWhy) override;

  PPresentationRequestChild* AllocPPresentationRequestChild(
      const PresentationIPCRequest& aRequest);

  bool DeallocPPresentationRequestChild(PPresentationRequestChild* aActor);

  mozilla::ipc::IPCResult RecvPPresentationBuilderConstructor(
      PPresentationBuilderChild* aActor, const nsString& aSessionId,
      const uint8_t& aRole) override;

  PPresentationBuilderChild* AllocPPresentationBuilderChild(
      const nsString& aSessionId, const uint8_t& aRole);

  bool DeallocPPresentationBuilderChild(PPresentationBuilderChild* aActor);

  mozilla::ipc::IPCResult RecvNotifyAvailableChange(
      nsTArray<nsString>&& aAvailabilityUrls, const bool& aAvailable);

  mozilla::ipc::IPCResult RecvNotifySessionStateChange(
      const nsString& aSessionId, const uint16_t& aState,
      const nsresult& aReason);

  mozilla::ipc::IPCResult RecvNotifyMessage(const nsString& aSessionId,
                                            const nsCString& aData,
                                            const bool& aIsBinary);

  mozilla::ipc::IPCResult RecvNotifySessionConnect(const uint64_t& aWindowId,
                                                   const nsString& aSessionId);

  mozilla::ipc::IPCResult RecvNotifyCloseSessionTransport(
      const nsString& aSessionId, const uint8_t& aRole,
      const nsresult& aReason);

 private:
  virtual ~PresentationChild();

  bool mActorDestroyed = false;
  RefPtr<PresentationIPCService> mService;
};

class PresentationRequestChild final : public PPresentationRequestChild {
  friend class PresentationChild;

 public:
  explicit PresentationRequestChild(nsIPresentationServiceCallback* aCallback);

  virtual void ActorDestroy(ActorDestroyReason aWhy) override;

  mozilla::ipc::IPCResult Recv__delete__(const nsresult& aResult);

  mozilla::ipc::IPCResult RecvNotifyRequestUrlSelected(const nsString& aUrl);

 private:
  virtual ~PresentationRequestChild();

  bool mActorDestroyed = false;
  nsCOMPtr<nsIPresentationServiceCallback> mCallback;
};

}  // namespace dom
}  // namespace mozilla

#endif  // mozilla_dom_PresentationChild_h
