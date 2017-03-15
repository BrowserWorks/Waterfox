/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set sw=2 ts=8 et ft=cpp : */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_dom_PresentationIPCService_h
#define mozilla_dom_PresentationIPCService_h

#include "mozilla/dom/PresentationServiceBase.h"
#include "nsIPresentationListener.h"
#include "nsIPresentationSessionTransport.h"
#include "nsIPresentationService.h"

class nsIDocShell;

namespace mozilla {
namespace dom {

class PresentationIPCRequest;
class PresentationContentSessionInfo;
class PresentationResponderLoadingCallback;

class PresentationIPCService final
  : public nsIPresentationAvailabilityListener
  , public nsIPresentationService
  , public PresentationServiceBase<PresentationContentSessionInfo>
{
public:
  NS_DECL_ISUPPORTS
  NS_DECL_NSIPRESENTATIONAVAILABILITYLISTENER
  NS_DECL_NSIPRESENTATIONSERVICE

  PresentationIPCService();

  nsresult NotifySessionStateChange(const nsAString& aSessionId,
                                    uint16_t aState,
                                    nsresult aReason);

  nsresult NotifyMessage(const nsAString& aSessionId,
                         const nsACString& aData,
                         const bool& aIsBinary);

  nsresult NotifySessionConnect(uint64_t aWindowId,
                                const nsAString& aSessionId);

  void NotifyPresentationChildDestroyed();

  nsresult MonitorResponderLoading(const nsAString& aSessionId,
                                   nsIDocShell* aDocShell);

  nsresult NotifySessionTransport(const nsString& aSessionId,
                                  const uint8_t& aRole,
                                  nsIPresentationSessionTransport* transport);

  nsresult CloseContentSessionTransport(const nsString& aSessionId,
                                        uint8_t aRole,
                                        nsresult aReason);

private:
  virtual ~PresentationIPCService();
  nsresult SendRequest(nsIPresentationServiceCallback* aCallback,
                       const PresentationIPCRequest& aRequest);

  nsRefPtrHashtable<nsStringHashKey,
                    nsIPresentationSessionListener> mSessionListeners;
  nsRefPtrHashtable<nsUint64HashKey,
                    nsIPresentationRespondingListener> mRespondingListeners;
  RefPtr<PresentationResponderLoadingCallback> mCallback;
};

} // namespace dom
} // namespace mozilla

#endif // mozilla_dom_PresentationIPCService_h
