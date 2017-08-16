/* vim:set ts=2 sw=2 sts=2 et cindent: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsArrayUtils.h"
#include "nsIMutableArray.h"
#include "nsISupportsPrimitives.h"
#include "PaymentRequestData.h"
#include "PaymentRequestUtils.h"

namespace mozilla {
namespace dom {
namespace payments {

/* PaymentMethodData */

NS_IMPL_ISUPPORTS(PaymentMethodData,
                  nsIPaymentMethodData)

PaymentMethodData::PaymentMethodData(nsIArray* aSupportedMethods,
                                     const nsAString& aData)
  : mSupportedMethods(aSupportedMethods)
  , mData(aData)
{
}

nsresult
PaymentMethodData::Create(const IPCPaymentMethodData& aIPCMethodData,
                          nsIPaymentMethodData** aMethodData)
{
  NS_ENSURE_ARG_POINTER(aMethodData);
  nsCOMPtr<nsIArray> supportedMethods;
  nsresult rv = ConvertStringstoISupportsStrings(aIPCMethodData.supportedMethods(),
                                                 getter_AddRefs(supportedMethods));
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }
  nsCOMPtr<nsIPaymentMethodData> methodData =
    new PaymentMethodData(supportedMethods, aIPCMethodData.data());
  methodData.forget(aMethodData);
  return NS_OK;
}

NS_IMETHODIMP
PaymentMethodData::GetSupportedMethods(nsIArray** aSupportedMethods)
{
  NS_ENSURE_ARG_POINTER(aSupportedMethods);
  MOZ_ASSERT(mSupportedMethods);
  nsCOMPtr<nsIArray> supportedMethods = mSupportedMethods;
  supportedMethods.forget(aSupportedMethods);
  return NS_OK;
}

NS_IMETHODIMP
PaymentMethodData::GetData(nsAString& aData)
{
  aData = mData;
  return NS_OK;
}

/* PaymentCurrencyAmount */

NS_IMPL_ISUPPORTS(PaymentCurrencyAmount,
                  nsIPaymentCurrencyAmount)

PaymentCurrencyAmount::PaymentCurrencyAmount(const nsAString& aCurrency,
                                             const nsAString& aValue)
  : mCurrency(aCurrency)
  , mValue(aValue)
{
}

nsresult
PaymentCurrencyAmount::Create(const IPCPaymentCurrencyAmount& aIPCAmount,
                              nsIPaymentCurrencyAmount** aAmount)
{
  NS_ENSURE_ARG_POINTER(aAmount);
  nsCOMPtr<nsIPaymentCurrencyAmount> amount =
    new PaymentCurrencyAmount(aIPCAmount.currency(), aIPCAmount.value());
  amount.forget(aAmount);
  return NS_OK;
}

NS_IMETHODIMP
PaymentCurrencyAmount::GetCurrency(nsAString& aCurrency)
{
  aCurrency = mCurrency;
  return NS_OK;
}

NS_IMETHODIMP
PaymentCurrencyAmount::GetValue(nsAString& aValue)
{
  aValue = mValue;
  return NS_OK;
}

/* PaymentItem */

NS_IMPL_ISUPPORTS(PaymentItem,
                  nsIPaymentItem)

PaymentItem::PaymentItem(const nsAString& aLabel,
                         nsIPaymentCurrencyAmount* aAmount,
                         const bool aPending)
  : mLabel(aLabel)
  , mAmount(aAmount)
  , mPending(aPending)
{
}

nsresult
PaymentItem::Create(const IPCPaymentItem& aIPCItem, nsIPaymentItem** aItem)
{
  NS_ENSURE_ARG_POINTER(aItem);
  nsCOMPtr<nsIPaymentCurrencyAmount> amount;
  nsresult rv = PaymentCurrencyAmount::Create(aIPCItem.amount(),
                                              getter_AddRefs(amount));
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }
  nsCOMPtr<nsIPaymentItem> item =
    new PaymentItem(aIPCItem.label(), amount, aIPCItem.pending());
  item.forget(aItem);
  return NS_OK;
}

NS_IMETHODIMP
PaymentItem::GetLabel(nsAString& aLabel)
{
  aLabel = mLabel;
  return NS_OK;
}

NS_IMETHODIMP
PaymentItem::GetAmount(nsIPaymentCurrencyAmount** aAmount)
{
  NS_ENSURE_ARG_POINTER(aAmount);
  MOZ_ASSERT(mAmount);
  nsCOMPtr<nsIPaymentCurrencyAmount> amount = mAmount;
  amount.forget(aAmount);
  return NS_OK;
}

NS_IMETHODIMP
PaymentItem::GetPending(bool* aPending)
{
  NS_ENSURE_ARG_POINTER(aPending);
  *aPending = mPending;
  return NS_OK;
}

/* PaymentDetailsModifier */

NS_IMPL_ISUPPORTS(PaymentDetailsModifier,
                  nsIPaymentDetailsModifier)

PaymentDetailsModifier::PaymentDetailsModifier(nsIArray* aSupportedMethods,
                                               nsIPaymentItem* aTotal,
                                               nsIArray* aAdditionalDisplayItems,
                                               const nsAString& aData)
  : mSupportedMethods(aSupportedMethods)
  , mTotal(aTotal)
  , mAdditionalDisplayItems(aAdditionalDisplayItems)
  , mData(aData)
{
}

nsresult
PaymentDetailsModifier::Create(const IPCPaymentDetailsModifier& aIPCModifier,
                               nsIPaymentDetailsModifier** aModifier)
{
  NS_ENSURE_ARG_POINTER(aModifier);
  nsCOMPtr<nsIPaymentItem> total;
  nsresult rv = PaymentItem::Create(aIPCModifier.total(), getter_AddRefs(total));
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  nsCOMPtr<nsIArray> supportedMethods;
  rv = ConvertStringstoISupportsStrings(aIPCModifier.supportedMethods(),
                                        getter_AddRefs(supportedMethods));
   if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  nsCOMPtr<nsIArray> displayItems;
  if (aIPCModifier.additionalDisplayItemsPassed()) {
    nsCOMPtr<nsIMutableArray> items = do_CreateInstance(NS_ARRAY_CONTRACTID);
    MOZ_ASSERT(items);
    for (const IPCPaymentItem& item : aIPCModifier.additionalDisplayItems()) {
      nsCOMPtr<nsIPaymentItem> additionalItem;
      rv = PaymentItem::Create(item, getter_AddRefs(additionalItem));
      if (NS_WARN_IF(NS_FAILED(rv))) {
        return rv;
      }
      rv = items->AppendElement(additionalItem, false);
      if (NS_WARN_IF(NS_FAILED(rv))) {
        return rv;
      }
    }
    displayItems = items.forget();
  }
  nsCOMPtr<nsIPaymentDetailsModifier> modifier =
    new PaymentDetailsModifier(supportedMethods, total, displayItems, aIPCModifier.data());
  modifier.forget(aModifier);
  return NS_OK;
}

NS_IMETHODIMP
PaymentDetailsModifier::GetSupportedMethods(nsIArray** aSupportedMethods)
{
  NS_ENSURE_ARG_POINTER(aSupportedMethods);
  MOZ_ASSERT(mSupportedMethods);
  nsCOMPtr<nsIArray> supportedMethods = mSupportedMethods;
  supportedMethods.forget(aSupportedMethods);
  return NS_OK;
}

NS_IMETHODIMP
PaymentDetailsModifier::GetTotal(nsIPaymentItem** aTotal)
{
  NS_ENSURE_ARG_POINTER(aTotal);
  MOZ_ASSERT(mTotal);
  nsCOMPtr<nsIPaymentItem> total = mTotal;
  total.forget(aTotal);
  return NS_OK;
}

NS_IMETHODIMP
PaymentDetailsModifier::GetAdditionalDisplayItems(nsIArray** aAdditionalDisplayItems)
{
  NS_ENSURE_ARG_POINTER(aAdditionalDisplayItems);
  nsCOMPtr<nsIArray> additionalItems = mAdditionalDisplayItems;
  additionalItems.forget(aAdditionalDisplayItems);
  return NS_OK;
}

NS_IMETHODIMP
PaymentDetailsModifier::GetData(nsAString& aData)
{
  aData = mData;
  return NS_OK;
}

/* PaymentShippingOption */

NS_IMPL_ISUPPORTS(PaymentShippingOption,
                  nsIPaymentShippingOption)

PaymentShippingOption::PaymentShippingOption(const nsAString& aId,
                                             const nsAString& aLabel,
                                             nsIPaymentCurrencyAmount* aAmount,
                                             const bool aSelected)
  : mId(aId)
  , mLabel(aLabel)
  , mAmount(aAmount)
  , mSelected(aSelected)
{
}

nsresult
PaymentShippingOption::Create(const IPCPaymentShippingOption& aIPCOption,
                              nsIPaymentShippingOption** aOption)
{
  NS_ENSURE_ARG_POINTER(aOption);
  nsCOMPtr<nsIPaymentCurrencyAmount> amount;
  nsresult rv = PaymentCurrencyAmount::Create(aIPCOption.amount(), getter_AddRefs(amount));
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }
  nsCOMPtr<nsIPaymentShippingOption> option =
    new PaymentShippingOption(aIPCOption.id(), aIPCOption.label(), amount, aIPCOption.selected());
  option.forget(aOption);
  return NS_OK;
}

NS_IMETHODIMP
PaymentShippingOption::GetId(nsAString& aId)
{
  aId = mId;
  return NS_OK;
}

NS_IMETHODIMP
PaymentShippingOption::GetLabel(nsAString& aLabel)
{
  aLabel = mLabel;
  return NS_OK;
}

NS_IMETHODIMP
PaymentShippingOption::GetAmount(nsIPaymentCurrencyAmount** aAmount)
{
  NS_ENSURE_ARG_POINTER(aAmount);
  MOZ_ASSERT(mAmount);
  nsCOMPtr<nsIPaymentCurrencyAmount> amount = mAmount;
  amount.forget(aAmount);
  return NS_OK;
}

NS_IMETHODIMP
PaymentShippingOption::GetSelected(bool* aSelected)
{
  NS_ENSURE_ARG_POINTER(aSelected);
  *aSelected = mSelected;
  return NS_OK;
}

NS_IMETHODIMP
PaymentShippingOption::SetSelected(bool aSelected)
{
  mSelected = aSelected;
  return NS_OK;
}

/* PaymentDetails */

NS_IMPL_ISUPPORTS(PaymentDetails,
                  nsIPaymentDetails)

PaymentDetails::PaymentDetails(const nsAString& aId,
                               nsIPaymentItem* aTotalItem,
                               nsIArray* aDisplayItems,
                               nsIArray* aShippingOptions,
                               nsIArray* aModifiers,
                               const nsAString& aError)
  : mId(aId)
  , mTotalItem(aTotalItem)
  , mDisplayItems(aDisplayItems)
  , mShippingOptions(aShippingOptions)
  , mModifiers(aModifiers)
  , mError(aError)
{
}

nsresult
PaymentDetails::Create(const IPCPaymentDetails& aIPCDetails,
                       nsIPaymentDetails** aDetails)
{
  NS_ENSURE_ARG_POINTER(aDetails);

  nsCOMPtr<nsIPaymentItem> total;
  nsresult rv = PaymentItem::Create(aIPCDetails.total(), getter_AddRefs(total));
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  nsCOMPtr<nsIArray> displayItems;
  if (aIPCDetails.displayItemsPassed()) {
    nsCOMPtr<nsIMutableArray> items = do_CreateInstance(NS_ARRAY_CONTRACTID);
    MOZ_ASSERT(items);
    for (const IPCPaymentItem& displayItem : aIPCDetails.displayItems()) {
      nsCOMPtr<nsIPaymentItem> item;
      rv = PaymentItem::Create(displayItem, getter_AddRefs(item));
      if (NS_WARN_IF(NS_FAILED(rv))) {
        return rv;
      }
      rv = items->AppendElement(item, false);
      if (NS_WARN_IF(NS_FAILED(rv))) {
        return rv;
      }
    }
    displayItems = items.forget();
  }

  nsCOMPtr<nsIArray> shippingOptions;
  if (aIPCDetails.shippingOptionsPassed()) {
    nsCOMPtr<nsIMutableArray> options = do_CreateInstance(NS_ARRAY_CONTRACTID);
    MOZ_ASSERT(options);
    for (const IPCPaymentShippingOption& shippingOption : aIPCDetails.shippingOptions()) {
      nsCOMPtr<nsIPaymentShippingOption> option;
      rv = PaymentShippingOption::Create(shippingOption, getter_AddRefs(option));
      if (NS_WARN_IF(NS_FAILED(rv))) {
        return rv;
      }
      rv = options->AppendElement(option, false);
      if (NS_WARN_IF(NS_FAILED(rv))) {
        return rv;
      }
    }
    shippingOptions = options.forget();
  }

  nsCOMPtr<nsIArray> modifiers;
  if (aIPCDetails.modifiersPassed()) {
    nsCOMPtr<nsIMutableArray> detailsModifiers = do_CreateInstance(NS_ARRAY_CONTRACTID);
    MOZ_ASSERT(detailsModifiers);
    for (const IPCPaymentDetailsModifier& modifier : aIPCDetails.modifiers()) {
      nsCOMPtr<nsIPaymentDetailsModifier> detailsModifier;
      rv = PaymentDetailsModifier::Create(modifier, getter_AddRefs(detailsModifier));
      if (NS_WARN_IF(NS_FAILED(rv))) {
        return rv;
      }
      rv = detailsModifiers->AppendElement(detailsModifier, false);
      if (NS_WARN_IF(NS_FAILED(rv))) {
        return rv;
      }
    }
    modifiers = detailsModifiers.forget();
  }

  nsCOMPtr<nsIPaymentDetails> details =
    new PaymentDetails(aIPCDetails.id(), total, displayItems, shippingOptions,
                       modifiers, aIPCDetails.error());

  details.forget(aDetails);
  return NS_OK;
}

NS_IMETHODIMP
PaymentDetails::GetId(nsAString& aId)
{
  aId = mId;
  return NS_OK;
}

NS_IMETHODIMP
PaymentDetails::GetTotalItem(nsIPaymentItem** aTotalItem)
{
  NS_ENSURE_ARG_POINTER(aTotalItem);
  MOZ_ASSERT(mTotalItem);
  nsCOMPtr<nsIPaymentItem> total = mTotalItem;
  total.forget(aTotalItem);
  return NS_OK;
}

NS_IMETHODIMP
PaymentDetails::GetDisplayItems(nsIArray** aDisplayItems)
{
  NS_ENSURE_ARG_POINTER(aDisplayItems);
  nsCOMPtr<nsIArray> displayItems = mDisplayItems;
  displayItems.forget(aDisplayItems);
  return NS_OK;
}

NS_IMETHODIMP
PaymentDetails::GetShippingOptions(nsIArray** aShippingOptions)
{
  NS_ENSURE_ARG_POINTER(aShippingOptions);
  nsCOMPtr<nsIArray> options = mShippingOptions;
  options.forget(aShippingOptions);
  return NS_OK;
}

NS_IMETHODIMP
PaymentDetails::GetModifiers(nsIArray** aModifiers)
{
  NS_ENSURE_ARG_POINTER(aModifiers);
  nsCOMPtr<nsIArray> modifiers = mModifiers;
  modifiers.forget(aModifiers);
  return NS_OK;
}

NS_IMETHODIMP
PaymentDetails::GetError(nsAString& aError)
{
  aError = mError;
  return NS_OK;
}

NS_IMETHODIMP
PaymentDetails::Update(nsIPaymentDetails* aDetails)
{
  MOZ_ASSERT(aDetails);
  /*
   * According to the spec [1], update the attributes if they present in new
   * details (i.e., PaymentDetailsUpdate); otherwise, keep original value.
   * Note |id| comes only from initial details (i.e., PaymentDetailsInit) and
   * |error| only from new details.
   *
   *   [1] https://www.w3.org/TR/payment-request/#updatewith-method
   */

  nsresult rv = aDetails->GetTotalItem(getter_AddRefs(mTotalItem));
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  nsCOMPtr<nsIArray> displayItems;
  rv = aDetails->GetDisplayItems(getter_AddRefs(displayItems));
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }
  if (displayItems) {
    mDisplayItems = displayItems;
  }

  nsCOMPtr<nsIArray> shippingOptions;
  rv = aDetails->GetShippingOptions(getter_AddRefs(shippingOptions));
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }
  if (shippingOptions) {
    mShippingOptions = shippingOptions;
  }

  nsCOMPtr<nsIArray> modifiers;
  rv = aDetails->GetModifiers(getter_AddRefs(modifiers));
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }
  if (modifiers) {
    mModifiers = modifiers;
  }

  rv = aDetails->GetError(mError);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }
  return NS_OK;

}
/* PaymentOptions */

NS_IMPL_ISUPPORTS(PaymentOptions,
                  nsIPaymentOptions)

PaymentOptions::PaymentOptions(const bool aRequestPayerName,
                               const bool aRequestPayerEmail,
                               const bool aRequestPayerPhone,
                               const bool aRequestShipping,
                               const nsAString& aShippingType)
  : mRequestPayerName(aRequestPayerName)
  , mRequestPayerEmail(aRequestPayerEmail)
  , mRequestPayerPhone(aRequestPayerPhone)
  , mRequestShipping(aRequestShipping)
  , mShippingType(aShippingType)
{
}

nsresult
PaymentOptions::Create(const IPCPaymentOptions& aIPCOptions,
                       nsIPaymentOptions** aOptions)
{
  NS_ENSURE_ARG_POINTER(aOptions);

  nsCOMPtr<nsIPaymentOptions> options =
    new PaymentOptions(aIPCOptions.requestPayerName(),
                       aIPCOptions.requestPayerEmail(),
                       aIPCOptions.requestPayerPhone(),
                       aIPCOptions.requestShipping(),
                       aIPCOptions.shippingType());
  options.forget(aOptions);
  return NS_OK;
}

NS_IMETHODIMP
PaymentOptions::GetRequestPayerName(bool* aRequestPayerName)
{
  NS_ENSURE_ARG_POINTER(aRequestPayerName);
  *aRequestPayerName = mRequestPayerName;
  return NS_OK;
}

NS_IMETHODIMP
PaymentOptions::GetRequestPayerEmail(bool* aRequestPayerEmail)
{
  NS_ENSURE_ARG_POINTER(aRequestPayerEmail);
  *aRequestPayerEmail = mRequestPayerEmail;
  return NS_OK;
}

NS_IMETHODIMP
PaymentOptions::GetRequestPayerPhone(bool* aRequestPayerPhone)
{
  NS_ENSURE_ARG_POINTER(aRequestPayerPhone);
  *aRequestPayerPhone = mRequestPayerPhone;
  return NS_OK;
}

NS_IMETHODIMP
PaymentOptions::GetRequestShipping(bool* aRequestShipping)
{
  NS_ENSURE_ARG_POINTER(aRequestShipping);
  *aRequestShipping = mRequestShipping;
  return NS_OK;
}

NS_IMETHODIMP
PaymentOptions::GetShippingType(nsAString& aShippingType)
{
  aShippingType = mShippingType;
  return NS_OK;
}

/* PaymentReqeust */

NS_IMPL_ISUPPORTS(PaymentRequest,
                  nsIPaymentRequest)

PaymentRequest::PaymentRequest(const uint64_t aTabId,
                               const nsAString& aRequestId,
                               nsIArray* aPaymentMethods,
                               nsIPaymentDetails* aPaymentDetails,
                               nsIPaymentOptions* aPaymentOptions)
  : mTabId(aTabId)
  , mRequestId(aRequestId)
  , mPaymentMethods(aPaymentMethods)
  , mPaymentDetails(aPaymentDetails)
  , mPaymentOptions(aPaymentOptions)
{
}

NS_IMETHODIMP
PaymentRequest::GetTabId(uint64_t* aTabId)
{
  NS_ENSURE_ARG_POINTER(aTabId);
  *aTabId = mTabId;
  return NS_OK;
}

NS_IMETHODIMP
PaymentRequest::GetRequestId(nsAString& aRequestId)
{
  aRequestId = mRequestId;
  return NS_OK;
}

NS_IMETHODIMP
PaymentRequest::GetPaymentMethods(nsIArray** aPaymentMethods)
{
  NS_ENSURE_ARG_POINTER(aPaymentMethods);
  MOZ_ASSERT(mPaymentMethods);
  nsCOMPtr<nsIArray> methods = mPaymentMethods;
  methods.forget(aPaymentMethods);
  return NS_OK;
}

NS_IMETHODIMP
PaymentRequest::GetPaymentDetails(nsIPaymentDetails** aPaymentDetails)
{
  NS_ENSURE_ARG_POINTER(aPaymentDetails);
  MOZ_ASSERT(mPaymentDetails);
  nsCOMPtr<nsIPaymentDetails> details = mPaymentDetails;
  details.forget(aPaymentDetails);
  return NS_OK;
}

NS_IMETHODIMP
PaymentRequest::GetPaymentOptions(nsIPaymentOptions** aPaymentOptions)
{
  NS_ENSURE_ARG_POINTER(aPaymentOptions);
  MOZ_ASSERT(mPaymentOptions);
  nsCOMPtr<nsIPaymentOptions> options = mPaymentOptions;
  options.forget(aPaymentOptions);
  return NS_OK;
}

NS_IMETHODIMP
PaymentRequest::UpdatePaymentDetails(nsIPaymentDetails* aPaymentDetails)
{
  MOZ_ASSERT(aPaymentDetails);
  return mPaymentDetails->Update(aPaymentDetails);
}

} // end of namespace payment
} // end of namespace dom
} // end of namespace mozilla
