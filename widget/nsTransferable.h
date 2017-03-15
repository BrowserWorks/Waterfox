/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef nsTransferable_h__
#define nsTransferable_h__

#include "nsIContentPolicyBase.h"
#include "nsIFormatConverter.h"
#include "nsITransferable.h"
#include "nsCOMPtr.h"
#include "nsString.h"
#include "nsTArray.h"
#include "nsIPrincipal.h"

class nsIMutableArray;
class nsString;

//
// DataStruct
//
// Holds a flavor (a mime type) that describes the data and the associated data.
//
struct DataStruct
{
  explicit DataStruct ( const char* aFlavor )
    : mDataLen(0), mFlavor(aFlavor), mCacheFileName(nullptr) { }
  ~DataStruct();
  
  const nsCString& GetFlavor() const { return mFlavor; }
  void SetData( nsISupports* inData, uint32_t inDataLen, bool aIsPrivateData );
  void GetData( nsISupports** outData, uint32_t *outDataLen );
  already_AddRefed<nsIFile> GetFileSpec(const char* aFileName);
  bool IsDataAvailable() const { return (mData && mDataLen > 0) || (!mData && mCacheFileName); }
  
protected:

  enum {
    // The size of data over which we write the data to disk rather than
    // keep it around in memory.
    kLargeDatasetSize = 1000000        // 1 million bytes
  };
  
  nsresult WriteCache(nsISupports* aData, uint32_t aDataLen );
  nsresult ReadCache(nsISupports** aData, uint32_t* aDataLen );
  
  nsCOMPtr<nsISupports> mData;   // OWNER - some varient of primitive wrapper
  uint32_t mDataLen;
  const nsCString mFlavor;
  char *   mCacheFileName;

};

/**
 * XP Transferable wrapper
 */

class nsTransferable : public nsITransferable
{
public:

  nsTransferable();

    // nsISupports
  NS_DECL_ISUPPORTS
  NS_DECL_NSITRANSFERABLE

protected:
  virtual ~nsTransferable();

    // get flavors w/out converter
  already_AddRefed<nsIMutableArray> GetTransferDataFlavors();
 
  nsTArray<DataStruct> mDataArray;
  nsCOMPtr<nsIFormatConverter> mFormatConv;
  bool mPrivateData;
  nsCOMPtr<nsIPrincipal> mRequestingPrincipal;
  nsContentPolicyType mContentPolicyType;
#if DEBUG
  bool mInitialized;
#endif

};

#endif // nsTransferable_h__
