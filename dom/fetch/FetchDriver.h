/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_dom_FetchDriver_h
#define mozilla_dom_FetchDriver_h

#include "nsIChannelEventSink.h"
#include "nsIInterfaceRequestor.h"
#include "nsIStreamListener.h"
#include "nsIThreadRetargetableStreamListener.h"
#include "mozilla/ConsoleReportCollector.h"
#include "mozilla/dom/SRIMetadata.h"
#include "mozilla/RefPtr.h"

#include "mozilla/DebugOnly.h"
#include "mozilla/net/ReferrerPolicy.h"

class nsIConsoleReportCollector;
class nsIDocument;
class nsIOutputStream;
class nsILoadGroup;
class nsIPrincipal;

namespace mozilla {
namespace dom {

class InternalRequest;
class InternalResponse;

/**
 * Provides callbacks to be called when response is available or on error.
 * Implemenations usually resolve or reject the promise returned from fetch().
 * The callbacks can be called synchronously or asynchronously from FetchDriver::Fetch.
 */
class FetchDriverObserver
{
public:
  FetchDriverObserver() : mReporter(new ConsoleReportCollector())
                        , mGotResponseAvailable(false)
  { }

  NS_INLINE_DECL_THREADSAFE_REFCOUNTING(FetchDriverObserver);
  void OnResponseAvailable(InternalResponse* aResponse)
  {
    MOZ_ASSERT(!mGotResponseAvailable);
    mGotResponseAvailable = true;
    OnResponseAvailableInternal(aResponse);
  }
  virtual void OnResponseEnd()
  { };

  nsIConsoleReportCollector* GetReporter() const
  {
    return mReporter;
  }

  virtual void FlushConsoleReport() = 0;
protected:
  virtual ~FetchDriverObserver()
  { };

  virtual void OnResponseAvailableInternal(InternalResponse* aResponse) = 0;

  nsCOMPtr<nsIConsoleReportCollector> mReporter;
private:
  bool mGotResponseAvailable;
};

class FetchDriver final : public nsIStreamListener,
                          public nsIChannelEventSink,
                          public nsIInterfaceRequestor,
                          public nsIThreadRetargetableStreamListener
{
public:
  NS_DECL_ISUPPORTS
  NS_DECL_NSIREQUESTOBSERVER
  NS_DECL_NSISTREAMLISTENER
  NS_DECL_NSICHANNELEVENTSINK
  NS_DECL_NSIINTERFACEREQUESTOR
  NS_DECL_NSITHREADRETARGETABLESTREAMLISTENER

  explicit FetchDriver(InternalRequest* aRequest, nsIPrincipal* aPrincipal,
                       nsILoadGroup* aLoadGroup);
  NS_IMETHOD Fetch(FetchDriverObserver* aObserver);

  void
  SetDocument(nsIDocument* aDocument);

  void
  SetWorkerScript(const nsACString& aWorkerScirpt)
  {
    MOZ_ASSERT(!aWorkerScirpt.IsEmpty());
    mWorkerScript = aWorkerScirpt;
  }

private:
  nsCOMPtr<nsIPrincipal> mPrincipal;
  nsCOMPtr<nsILoadGroup> mLoadGroup;
  RefPtr<InternalRequest> mRequest;
  RefPtr<InternalResponse> mResponse;
  nsCOMPtr<nsIOutputStream> mPipeOutputStream;
  RefPtr<FetchDriverObserver> mObserver;
  nsCOMPtr<nsIDocument> mDocument;
  nsAutoPtr<SRICheckDataVerifier> mSRIDataVerifier;
  SRIMetadata mSRIMetadata;
  nsCString mWorkerScript;

#ifdef DEBUG
  bool mResponseAvailableCalled;
  bool mFetchCalled;
#endif

  FetchDriver() = delete;
  FetchDriver(const FetchDriver&) = delete;
  FetchDriver& operator=(const FetchDriver&) = delete;
  ~FetchDriver();

  nsresult HttpFetch();
  // Returns the filtered response sent to the observer.
  already_AddRefed<InternalResponse>
  BeginAndGetFilteredResponse(InternalResponse* aResponse,
                              bool aFoundOpaqueRedirect);
  // Utility since not all cases need to do any post processing of the filtered
  // response.
  void FailWithNetworkError();

  void SetRequestHeaders(nsIHttpChannel* aChannel) const;
};

} // namespace dom
} // namespace mozilla

#endif // mozilla_dom_FetchDriver_h
