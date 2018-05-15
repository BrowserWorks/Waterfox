/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/Attributes.h"

#include "nsArrayEnumerator.h"

#include "nsIArray.h"
#include "nsISimpleEnumerator.h"

#include "nsCOMArray.h"
#include "nsCOMPtr.h"
#include "mozilla/OperatorNewExtensions.h"
#include "mozilla/RefPtr.h"

class nsSimpleArrayEnumerator final : public nsISimpleEnumerator
{
public:
  // nsISupports interface
  NS_DECL_ISUPPORTS

  // nsISimpleEnumerator interface
  NS_DECL_NSISIMPLEENUMERATOR

  // nsSimpleArrayEnumerator methods
  explicit nsSimpleArrayEnumerator(nsIArray* aValueArray)
    : mValueArray(aValueArray)
    , mIndex(0)
  {
  }

private:
  ~nsSimpleArrayEnumerator() = default;

protected:
  nsCOMPtr<nsIArray> mValueArray;
  uint32_t mIndex;
};

NS_IMPL_ISUPPORTS(nsSimpleArrayEnumerator, nsISimpleEnumerator)

NS_IMETHODIMP
nsSimpleArrayEnumerator::HasMoreElements(bool* aResult)
{
  NS_PRECONDITION(aResult != 0, "null ptr");
  if (!aResult) {
    return NS_ERROR_NULL_POINTER;
  }

  if (!mValueArray) {
    *aResult = false;
    return NS_OK;
  }

  uint32_t cnt;
  nsresult rv = mValueArray->GetLength(&cnt);
  if (NS_FAILED(rv)) {
    return rv;
  }
  *aResult = (mIndex < cnt);
  return NS_OK;
}

NS_IMETHODIMP
nsSimpleArrayEnumerator::GetNext(nsISupports** aResult)
{
  NS_PRECONDITION(aResult != 0, "null ptr");
  if (!aResult) {
    return NS_ERROR_NULL_POINTER;
  }

  if (!mValueArray) {
    *aResult = nullptr;
    return NS_OK;
  }

  uint32_t cnt;
  nsresult rv = mValueArray->GetLength(&cnt);
  if (NS_FAILED(rv)) {
    return rv;
  }
  if (mIndex >= cnt) {
    return NS_ERROR_UNEXPECTED;
  }

  return mValueArray->QueryElementAt(mIndex++, NS_GET_IID(nsISupports),
                                     (void**)aResult);
}

nsresult
NS_NewArrayEnumerator(nsISimpleEnumerator** aResult, nsIArray* aArray)
{
  RefPtr<nsSimpleArrayEnumerator> enumer = new nsSimpleArrayEnumerator(aArray);
  enumer.forget(aResult);
  return NS_OK;
}

////////////////////////////////////////////////////////////////////////////////

// enumerator implementation for nsCOMArray
// creates a snapshot of the array in question
// you MUST use NS_NewArrayEnumerator to create this, so that
// allocation is done correctly
class nsCOMArrayEnumerator final : public nsISimpleEnumerator
{
public:
  // nsISupports interface
  NS_DECL_ISUPPORTS

  // nsISimpleEnumerator interface
  NS_DECL_NSISIMPLEENUMERATOR

  // Use this instead of `new`.
  static nsCOMArrayEnumerator* Allocate(const nsCOMArray_base& aArray);

  // specialized operator to make sure we make room for mValues
  void operator delete(void* aPtr) { free(aPtr); }

private:
  // nsSimpleArrayEnumerator methods
  nsCOMArrayEnumerator()
    : mIndex(0)
    , mArraySize(0)
  {
    mValueArray[0] = nullptr;
  }

  ~nsCOMArrayEnumerator(void);

protected:
  uint32_t mIndex;            // current position
  uint32_t mArraySize;        // size of the array

  // this is actually bigger
  nsISupports* mValueArray[1];
};

NS_IMPL_ISUPPORTS(nsCOMArrayEnumerator, nsISimpleEnumerator)

nsCOMArrayEnumerator::~nsCOMArrayEnumerator()
{
  // only release the entries that we haven't visited yet
  for (; mIndex < mArraySize; ++mIndex) {
    NS_IF_RELEASE(mValueArray[mIndex]);
  }
}

NS_IMETHODIMP
nsCOMArrayEnumerator::HasMoreElements(bool* aResult)
{
  NS_PRECONDITION(aResult != 0, "null ptr");
  if (!aResult) {
    return NS_ERROR_NULL_POINTER;
  }

  *aResult = (mIndex < mArraySize);
  return NS_OK;
}

NS_IMETHODIMP
nsCOMArrayEnumerator::GetNext(nsISupports** aResult)
{
  NS_PRECONDITION(aResult != 0, "null ptr");
  if (!aResult) {
    return NS_ERROR_NULL_POINTER;
  }

  if (mIndex >= mArraySize) {
    return NS_ERROR_UNEXPECTED;
  }

  // pass the ownership of the reference to the caller. Since
  // we AddRef'ed during creation of |this|, there is no need
  // to AddRef here
  *aResult = mValueArray[mIndex++];

  // this really isn't necessary. just pretend this happens, since
  // we'll never visit this value again!
  // mValueArray[(mIndex-1)] = nullptr;

  return NS_OK;
}

nsCOMArrayEnumerator*
nsCOMArrayEnumerator::Allocate(const nsCOMArray_base& aArray)
{
  // create enough space such that mValueArray points to a large
  // enough value. Note that the initial value of aSize gives us
  // space for mValueArray[0], so we must subtract
  size_t size = sizeof(nsCOMArrayEnumerator);
  uint32_t count;
  if (aArray.Count() > 0) {
    count = static_cast<uint32_t>(aArray.Count());
    size += (count - 1) * sizeof(aArray[0]);
  } else {
    count = 0;
  }

  // Allocate a buffer large enough to contain our object and its array.
  void* mem = moz_xmalloc(size);
  auto result = new (mozilla::KnownNotNull, mem) nsCOMArrayEnumerator();

  result->mArraySize = count;

  // now need to copy over the values, and addref each one
  // now this might seem like a lot of work, but we're actually just
  // doing all our AddRef's ahead of time since GetNext() doesn't
  // need to AddRef() on the way out
  for (uint32_t i = 0; i < count; ++i) {
    result->mValueArray[i] = aArray[i];
    NS_IF_ADDREF(result->mValueArray[i]);
  }

  return result;
}

nsresult
NS_NewArrayEnumerator(nsISimpleEnumerator** aResult,
                      const nsCOMArray_base& aArray)
{
  RefPtr<nsCOMArrayEnumerator> enumerator = nsCOMArrayEnumerator::Allocate(aArray);
  enumerator.forget(aResult);
  return NS_OK;
}
