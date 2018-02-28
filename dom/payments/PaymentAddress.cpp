/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim:set ts=2 sw=2 sts=2 et cindent: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/dom/PaymentAddress.h"
#include "mozilla/dom/PaymentAddressBinding.h"

namespace mozilla {
namespace dom {

NS_IMPL_CYCLE_COLLECTION_WRAPPERCACHE(PaymentAddress, mOwner)

NS_IMPL_CYCLE_COLLECTING_ADDREF(PaymentAddress)
NS_IMPL_CYCLE_COLLECTING_RELEASE(PaymentAddress)

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(PaymentAddress)
  NS_WRAPPERCACHE_INTERFACE_MAP_ENTRY
  NS_INTERFACE_MAP_ENTRY(nsISupports)
NS_INTERFACE_MAP_END

PaymentAddress::PaymentAddress(nsPIDOMWindowInner* aWindow,
                               const nsAString& aCountry,
                               const nsTArray<nsString>& aAddressLine,
                               const nsAString& aRegion,
                               const nsAString& aCity,
                               const nsAString& aDependentLocality,
                               const nsAString& aPostalCode,
                               const nsAString& aSortingCode,
                               const nsAString& aLanguageCode,
                               const nsAString& aOrganization,
                               const nsAString& aRecipient,
                               const nsAString& aPhone)
  : mCountry(aCountry)
  , mAddressLine(aAddressLine)
  , mRegion(aRegion)
  , mCity(aCity)
  , mDependentLocality(aDependentLocality)
  , mPostalCode(aPostalCode)
  , mSortingCode(aSortingCode)
  , mLanguageCode(aLanguageCode)
  , mOrganization(aOrganization)
  , mRecipient(aRecipient)
  , mPhone(aPhone)
  , mOwner(aWindow)
{
}

void
PaymentAddress::GetCountry(nsAString& aRetVal) const
{
  aRetVal = mCountry;
}

void
PaymentAddress::GetAddressLine(nsTArray<nsString>& aRetVal) const
{
  aRetVal = mAddressLine;
}

void
PaymentAddress::GetRegion(nsAString& aRetVal) const
{
  aRetVal = mRegion;
}

void
PaymentAddress::GetCity(nsAString& aRetVal) const
{
  aRetVal = mCity;
}

void
PaymentAddress::GetDependentLocality(nsAString& aRetVal) const
{
  aRetVal = mDependentLocality;
}

void
PaymentAddress::GetPostalCode(nsAString& aRetVal) const
{
  aRetVal = mPostalCode;
}

void
PaymentAddress::GetSortingCode(nsAString& aRetVal) const
{
  aRetVal = mSortingCode;
}

void
PaymentAddress::GetLanguageCode(nsAString& aRetVal) const
{
  aRetVal = mLanguageCode;
}

void
PaymentAddress::GetOrganization(nsAString& aRetVal) const
{
  aRetVal = mOrganization;
}

void
PaymentAddress::GetRecipient(nsAString& aRetVal) const
{
  aRetVal = mRecipient;
}

void
PaymentAddress::GetPhone(nsAString& aRetVal) const
{
  aRetVal = mPhone;
}

PaymentAddress::~PaymentAddress()
{
}

JSObject*
PaymentAddress::WrapObject(JSContext* aCx, JS::Handle<JSObject*> aGivenProto)
{
  return PaymentAddressBinding::Wrap(aCx, this, aGivenProto);
}


} // namespace dom
} // namespace mozilla
