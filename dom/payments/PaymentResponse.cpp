/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim:set ts=2 sw=2 sts=2 et cindent: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/dom/PaymentResponse.h"
#include "mozilla/dom/BasicCardPaymentBinding.h"
#include "BasicCardPayment.h"
#include "PaymentAddress.h"
#include "PaymentRequestUtils.h"

namespace mozilla {
namespace dom {

NS_IMPL_CYCLE_COLLECTION_WRAPPERCACHE(PaymentResponse, mOwner,
                                      mShippingAddress, mPromise)

NS_IMPL_CYCLE_COLLECTING_ADDREF(PaymentResponse)
NS_IMPL_CYCLE_COLLECTING_RELEASE(PaymentResponse)

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(PaymentResponse)
  NS_WRAPPERCACHE_INTERFACE_MAP_ENTRY
  NS_INTERFACE_MAP_ENTRY(nsISupports)
NS_INTERFACE_MAP_END

PaymentResponse::PaymentResponse(nsPIDOMWindowInner* aWindow,
                                 const nsAString& aInternalId,
                                 const nsAString& aRequestId,
                                 const nsAString& aMethodName,
                                 const nsAString& aShippingOption,
                                 RefPtr<PaymentAddress> aShippingAddress,
                                 const nsAString& aDetails,
                                 const nsAString& aPayerName,
                                 const nsAString& aPayerEmail,
                                 const nsAString& aPayerPhone)
  : mOwner(aWindow)
  , mCompleteCalled(false)
  , mInternalId(aInternalId)
  , mRequestId(aRequestId)
  , mMethodName(aMethodName)
  , mDetails(aDetails)
  , mShippingOption(aShippingOption)
  , mPayerName(aPayerName)
  , mPayerEmail(aPayerEmail)
  , mPayerPhone(aPayerPhone)
  , mShippingAddress(aShippingAddress)
{

  // TODO: from https://github.com/w3c/browser-payment-api/issues/480
  // Add payerGivenName + payerFamilyName to PaymentAddress
}

PaymentResponse::~PaymentResponse()
{
}

JSObject*
PaymentResponse::WrapObject(JSContext* aCx, JS::Handle<JSObject*> aGivenProto)
{
  return PaymentResponseBinding::Wrap(aCx, this, aGivenProto);
}

void
PaymentResponse::GetRequestId(nsString& aRetVal) const
{
  aRetVal = mRequestId;
}

void
PaymentResponse::GetMethodName(nsString& aRetVal) const
{
  aRetVal = mMethodName;
}

void
PaymentResponse::GetDetails(JSContext* aCx, JS::MutableHandle<JSObject*> aRetVal) const
{
  RefPtr<BasicCardService> service = BasicCardService::GetService();
  MOZ_ASSERT(service);
  if (!service->IsBasicCardPayment(mMethodName)) {
    DeserializeToJSObject(mDetails, aCx, aRetVal);
  } else {
    BasicCardResponse response;
    nsresult rv = service->DecodeBasicCardData(mDetails, mOwner, response);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return;
    }

    MOZ_ASSERT(aCx);
    JS::RootedValue value(aCx);
    JS::MutableHandleValue handleValue(&value);
    if (NS_WARN_IF(!response.ToObjectInternal(aCx, handleValue))) {
      return;
    }
    aRetVal.set(&handleValue.toObject());
  }
}

void
PaymentResponse::GetShippingOption(nsString& aRetVal) const
{
  aRetVal = mShippingOption;
}

void
PaymentResponse::GetPayerName(nsString& aRetVal) const
{
  aRetVal = mPayerName;
}

void PaymentResponse::GetPayerEmail(nsString& aRetVal) const
{
  aRetVal = mPayerEmail;
}

void PaymentResponse::GetPayerPhone(nsString& aRetVal) const
{
  aRetVal = mPayerPhone;
}

// TODO:
// Return a raw pointer here to avoid refcounting, but make sure it's safe
// (the object should be kept alive by the callee).
already_AddRefed<PaymentAddress>
PaymentResponse::GetShippingAddress() const
{
  RefPtr<PaymentAddress> address = mShippingAddress;
  return address.forget();
}

already_AddRefed<Promise>
PaymentResponse::Complete(PaymentComplete result, ErrorResult& aRv)
{
  if (mCompleteCalled) {
    aRv.Throw(NS_ERROR_DOM_INVALID_STATE_ERR);
    return nullptr;
  }

  nsCOMPtr<nsIGlobalObject> global = do_QueryInterface(mOwner);
  ErrorResult errResult;
  RefPtr<Promise> promise = Promise::Create(global, errResult);
  if (errResult.Failed()) {
    aRv.Throw(NS_ERROR_FAILURE);
    return nullptr;
  }

  mCompleteCalled = true;

  RefPtr<PaymentRequestManager> manager = PaymentRequestManager::GetSingleton();
  if (NS_WARN_IF(!manager)) {
    aRv.Throw(NS_ERROR_FAILURE);
    return nullptr;
  }
  nsresult rv = manager->CompletePayment(mInternalId, result);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    promise->MaybeReject(NS_ERROR_FAILURE);
    return promise.forget();
  }

  mPromise = promise;
  return promise.forget();
}

void
PaymentResponse::RespondComplete()
{
  MOZ_ASSERT(mPromise);

  mPromise->MaybeResolve(JS::UndefinedHandleValue);
  mPromise = nullptr;
}

} // namespace dom
} // namespace mozilla
