/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/mozalloc.h"
#include "nsCOMPtr.h"
#include "nsDebug.h"
#include "nsError.h"
#include "nsID.h"
#include "nsISupportsUtils.h"
#include "nsITransactionManager.h"
#include "nsTransactionItem.h"
#include "nsTransactionList.h"
#include "nsTransactionStack.h"
#include "nscore.h"

NS_IMPL_ISUPPORTS(nsTransactionList, nsITransactionList)

nsTransactionList::nsTransactionList(nsITransactionManager *aTxnMgr, nsTransactionStack *aTxnStack)
  : mTxnStack(aTxnStack)
  , mTxnItem(nullptr)
{
  if (aTxnMgr)
    mTxnMgr = do_GetWeakReference(aTxnMgr);
}

nsTransactionList::nsTransactionList(nsITransactionManager *aTxnMgr, nsTransactionItem *aTxnItem)
  : mTxnStack(0)
  , mTxnItem(aTxnItem)
{
  if (aTxnMgr)
    mTxnMgr = do_GetWeakReference(aTxnMgr);
}

nsTransactionList::~nsTransactionList()
{
  mTxnStack = 0;
  mTxnItem  = nullptr;
}

NS_IMETHODIMP nsTransactionList::GetNumItems(int32_t *aNumItems)
{
  NS_ENSURE_TRUE(aNumItems, NS_ERROR_NULL_POINTER);

  *aNumItems = 0;

  nsCOMPtr<nsITransactionManager> txMgr = do_QueryReferent(mTxnMgr);
  NS_ENSURE_TRUE(txMgr, NS_ERROR_FAILURE);

  if (mTxnStack) {
    *aNumItems = mTxnStack->GetSize();
  } else if (mTxnItem) {
    return mTxnItem->GetNumberOfChildren(aNumItems);
  }

  return NS_OK;
}

NS_IMETHODIMP nsTransactionList::ItemIsBatch(int32_t aIndex, bool *aIsBatch)
{
  NS_ENSURE_TRUE(aIsBatch, NS_ERROR_NULL_POINTER);

  *aIsBatch = false;

  nsCOMPtr<nsITransactionManager> txMgr = do_QueryReferent(mTxnMgr);
  NS_ENSURE_TRUE(txMgr, NS_ERROR_FAILURE);

  RefPtr<nsTransactionItem> item;
  if (mTxnStack) {
    item = mTxnStack->GetItem(aIndex);
  } else if (mTxnItem) {
    nsresult rv = mTxnItem->GetChild(aIndex, getter_AddRefs(item));
    NS_ENSURE_SUCCESS(rv, rv);
  }
  NS_ENSURE_TRUE(item, NS_ERROR_FAILURE);

  return item->GetIsBatch(aIsBatch);
}

NS_IMETHODIMP nsTransactionList::GetData(int32_t aIndex,
                                         uint32_t *aLength,
                                         nsISupports ***aData)
{
  nsCOMPtr<nsITransactionManager> txMgr = do_QueryReferent(mTxnMgr);
  NS_ENSURE_TRUE(txMgr, NS_ERROR_FAILURE);

  RefPtr<nsTransactionItem> item;
  if (mTxnStack) {
    item = mTxnStack->GetItem(aIndex);
  } else if (mTxnItem) {
    nsresult rv = mTxnItem->GetChild(aIndex, getter_AddRefs(item));
    NS_ENSURE_SUCCESS(rv, rv);
  }

  nsCOMArray<nsISupports>& data = item->GetData();
  nsISupports** ret = static_cast<nsISupports**>(moz_xmalloc(data.Count() *
    sizeof(nsISupports*)));

  for (int32_t i = 0; i < data.Count(); i++) {
    NS_ADDREF(ret[i] = data[i]);
  }
  *aLength = data.Count();
  *aData = ret;
  return NS_OK;
}

NS_IMETHODIMP nsTransactionList::GetItem(int32_t aIndex, nsITransaction **aItem)
{
  NS_ENSURE_TRUE(aItem, NS_ERROR_NULL_POINTER);

  *aItem = 0;

  nsCOMPtr<nsITransactionManager> txMgr = do_QueryReferent(mTxnMgr);
  NS_ENSURE_TRUE(txMgr, NS_ERROR_FAILURE);

  RefPtr<nsTransactionItem> item;
  if (mTxnStack) {
    item = mTxnStack->GetItem(aIndex);
  } else if (mTxnItem) {
    nsresult rv = mTxnItem->GetChild(aIndex, getter_AddRefs(item));
    NS_ENSURE_SUCCESS(rv, rv);
  }
  NS_ENSURE_TRUE(item, NS_ERROR_FAILURE);

  *aItem = item->GetTransaction().take();
  return NS_OK;
}

NS_IMETHODIMP nsTransactionList::GetNumChildrenForItem(int32_t aIndex, int32_t *aNumChildren)
{
  NS_ENSURE_TRUE(aNumChildren, NS_ERROR_NULL_POINTER);

  *aNumChildren = 0;

  nsCOMPtr<nsITransactionManager> txMgr = do_QueryReferent(mTxnMgr);
  NS_ENSURE_TRUE(txMgr, NS_ERROR_FAILURE);

  RefPtr<nsTransactionItem> item;
  if (mTxnStack) {
    item = mTxnStack->GetItem(aIndex);
  } else if (mTxnItem) {
    nsresult rv = mTxnItem->GetChild(aIndex, getter_AddRefs(item));
    NS_ENSURE_SUCCESS(rv, rv);
  }
  NS_ENSURE_TRUE(item, NS_ERROR_FAILURE);

  return item->GetNumberOfChildren(aNumChildren);
}

NS_IMETHODIMP nsTransactionList::GetChildListForItem(int32_t aIndex, nsITransactionList **aTxnList)
{
  NS_ENSURE_TRUE(aTxnList, NS_ERROR_NULL_POINTER);

  *aTxnList = 0;

  nsCOMPtr<nsITransactionManager> txMgr = do_QueryReferent(mTxnMgr);
  NS_ENSURE_TRUE(txMgr, NS_ERROR_FAILURE);

  RefPtr<nsTransactionItem> item;
  if (mTxnStack) {
    item = mTxnStack->GetItem(aIndex);
  } else if (mTxnItem) {
    nsresult rv = mTxnItem->GetChild(aIndex, getter_AddRefs(item));
    NS_ENSURE_SUCCESS(rv, rv);
  }
  NS_ENSURE_TRUE(item, NS_ERROR_FAILURE);

  *aTxnList = (nsITransactionList *)new nsTransactionList(txMgr, item);
  NS_ENSURE_TRUE(*aTxnList, NS_ERROR_OUT_OF_MEMORY);

  NS_ADDREF(*aTxnList);
  return NS_OK;
}
