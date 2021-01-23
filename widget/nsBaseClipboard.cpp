/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsBaseClipboard.h"

#include "nsIClipboardOwner.h"
#include "nsCOMPtr.h"
#include "nsXPCOM.h"

nsBaseClipboard::nsBaseClipboard()
    : mEmptyingForSetData(false), mIgnoreEmptyNotification(false) {}

nsBaseClipboard::~nsBaseClipboard() {
  EmptyClipboard(kSelectionClipboard);
  EmptyClipboard(kGlobalClipboard);
  EmptyClipboard(kFindClipboard);
}

NS_IMPL_ISUPPORTS(nsBaseClipboard, nsIClipboard)

/**
 * Sets the transferable object
 *
 */
NS_IMETHODIMP nsBaseClipboard::SetData(nsITransferable* aTransferable,
                                       nsIClipboardOwner* anOwner,
                                       int32_t aWhichClipboard) {
  NS_ASSERTION(aTransferable, "clipboard given a null transferable");

  if (aTransferable == mTransferable && anOwner == mClipboardOwner)
    return NS_OK;
  bool selectClipPresent;
  SupportsSelectionClipboard(&selectClipPresent);
  bool findClipPresent;
  SupportsFindClipboard(&findClipPresent);
  if (!selectClipPresent && !findClipPresent &&
      aWhichClipboard != kGlobalClipboard)
    return NS_ERROR_FAILURE;

  mEmptyingForSetData = true;
  EmptyClipboard(aWhichClipboard);
  mEmptyingForSetData = false;

  mClipboardOwner = anOwner;
  mTransferable = aTransferable;

  nsresult rv = NS_ERROR_FAILURE;
  if (mTransferable) {
    rv = SetNativeClipboardData(aWhichClipboard);
  }

  return rv;
}

/**
 * Gets the transferable object
 *
 */
NS_IMETHODIMP nsBaseClipboard::GetData(nsITransferable* aTransferable,
                                       int32_t aWhichClipboard) {
  NS_ASSERTION(aTransferable, "clipboard given a null transferable");

  bool selectClipPresent;
  SupportsSelectionClipboard(&selectClipPresent);
  bool findClipPresent;
  SupportsFindClipboard(&findClipPresent);
  if (!selectClipPresent && !findClipPresent &&
      aWhichClipboard != kGlobalClipboard)
    return NS_ERROR_FAILURE;

  if (aTransferable)
    return GetNativeClipboardData(aTransferable, aWhichClipboard);

  return NS_ERROR_FAILURE;
}

NS_IMETHODIMP nsBaseClipboard::EmptyClipboard(int32_t aWhichClipboard) {
  bool selectClipPresent;
  SupportsSelectionClipboard(&selectClipPresent);
  bool findClipPresent;
  SupportsFindClipboard(&findClipPresent);
  if (!selectClipPresent && !findClipPresent &&
      aWhichClipboard != kGlobalClipboard)
    return NS_ERROR_FAILURE;

  if (mIgnoreEmptyNotification) return NS_OK;

  if (mClipboardOwner) {
    mClipboardOwner->LosingOwnership(mTransferable);
    mClipboardOwner = nullptr;
  }

  mTransferable = nullptr;
  return NS_OK;
}

NS_IMETHODIMP
nsBaseClipboard::HasDataMatchingFlavors(const nsTArray<nsCString>& aFlavorList,
                                        int32_t aWhichClipboard,
                                        bool* outResult) {
  *outResult = true;  // say we always do.
  return NS_OK;
}

NS_IMETHODIMP
nsBaseClipboard::SupportsSelectionClipboard(bool* _retval) {
  *_retval = false;  // we don't support the selection clipboard by default.
  return NS_OK;
}

NS_IMETHODIMP
nsBaseClipboard::SupportsFindClipboard(bool* _retval) {
  *_retval = false;  // we don't support the find clipboard by default.
  return NS_OK;
}
