/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsIAsyncInputStream.h"
#include "nsIAsyncOutputStream.h"
#include "nsIDocShell.h"
#include "nsIInterfaceRequestorUtils.h"
#include "nsIPipe.h"

#include "nsEmbedStream.h"
#include "nsError.h"
#include "nsString.h"

NS_IMPL_ISUPPORTS0(nsEmbedStream)

nsEmbedStream::nsEmbedStream()
{
  mOwner = nullptr;
}

nsEmbedStream::~nsEmbedStream()
{
}

void
nsEmbedStream::InitOwner(nsIWebBrowser* aOwner)
{
  mOwner = aOwner;
}

nsresult
nsEmbedStream::Init(void)
{
  return NS_OK;
}

nsresult
nsEmbedStream::OpenStream(nsIURI* aBaseURI, const nsACString& aContentType)
{
  nsresult rv;
  NS_ENSURE_ARG_POINTER(aBaseURI);
  NS_ENSURE_TRUE(IsASCII(aContentType), NS_ERROR_INVALID_ARG);

  // if we're already doing a stream, return an error
  if (mOutputStream) {
    return NS_ERROR_IN_PROGRESS;
  }

  nsCOMPtr<nsIAsyncInputStream> inputStream;
  nsCOMPtr<nsIAsyncOutputStream> outputStream;
  rv = NS_NewPipe2(getter_AddRefs(inputStream), getter_AddRefs(outputStream),
                   true, false, 0, UINT32_MAX);
  if (NS_FAILED(rv)) {
    return rv;
  }

  nsCOMPtr<nsIDocShell> docShell = do_GetInterface(mOwner);
  rv = docShell->LoadStream(inputStream, aBaseURI, aContentType,
                            EmptyCString(), nullptr);
  if (NS_FAILED(rv)) {
    return rv;
  }

  mOutputStream = outputStream;
  return rv;
}

nsresult
nsEmbedStream::AppendToStream(const uint8_t* aData, uint32_t aLen)
{
  nsresult rv;
  NS_ENSURE_STATE(mOutputStream);

  uint32_t bytesWritten = 0;
  rv = mOutputStream->Write(reinterpret_cast<const char*>(aData),
                            aLen, &bytesWritten);
  if (NS_FAILED(rv)) {
    return rv;
  }

  NS_ASSERTION(bytesWritten == aLen,
               "underlying buffer couldn't handle the write");
  return rv;
}

nsresult
nsEmbedStream::CloseStream(void)
{
  nsresult rv = NS_OK;

  // NS_ENSURE_STATE returns NS_ERROR_UNEXPECTED if the condition isn't
  // satisfied; this is exactly what we want to return.
  NS_ENSURE_STATE(mOutputStream);
  mOutputStream->Close();
  mOutputStream = nullptr;

  return rv;
}
