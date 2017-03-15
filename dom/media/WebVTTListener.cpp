/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "WebVTTListener.h"
#include "mozilla/dom/TextTrackCue.h"
#include "mozilla/dom/TextTrackRegion.h"
#include "mozilla/dom/VTTRegionBinding.h"
#include "mozilla/dom/HTMLTrackElement.h"
#include "nsIInputStream.h"
#include "nsIWebVTTParserWrapper.h"
#include "nsComponentManagerUtils.h"
#include "nsIAsyncVerifyRedirectCallback.h"

namespace mozilla {
namespace dom {

NS_IMPL_CYCLE_COLLECTION(WebVTTListener, mElement, mParserWrapper)

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(WebVTTListener)
  NS_INTERFACE_MAP_ENTRY(nsIWebVTTListener)
  NS_INTERFACE_MAP_ENTRY(nsIStreamListener)
  NS_INTERFACE_MAP_ENTRY(nsIChannelEventSink)
  NS_INTERFACE_MAP_ENTRY(nsIInterfaceRequestor)
  NS_INTERFACE_MAP_ENTRY_AMBIGUOUS(nsISupports, nsIWebVTTListener)
NS_INTERFACE_MAP_END

NS_IMPL_CYCLE_COLLECTING_ADDREF(WebVTTListener)
NS_IMPL_CYCLE_COLLECTING_RELEASE(WebVTTListener)

LazyLogModule gTextTrackLog("TextTrack");
# define VTT_LOG(...) MOZ_LOG(gTextTrackLog, LogLevel::Debug, (__VA_ARGS__))

WebVTTListener::WebVTTListener(HTMLTrackElement* aElement)
  : mElement(aElement)
{
  MOZ_ASSERT(mElement, "Must pass an element to the callback");
  VTT_LOG("WebVTTListener created.");
}

WebVTTListener::~WebVTTListener()
{
  VTT_LOG("WebVTTListener destroyed.");
}

NS_IMETHODIMP
WebVTTListener::GetInterface(const nsIID &aIID,
                             void** aResult)
{
  return QueryInterface(aIID, aResult);
}

nsresult
WebVTTListener::LoadResource()
{
  nsresult rv;
  mParserWrapper = do_CreateInstance(NS_WEBVTTPARSERWRAPPER_CONTRACTID, &rv);
  NS_ENSURE_SUCCESS(rv, rv);

  nsPIDOMWindowInner* window = mElement->OwnerDoc()->GetInnerWindow();
  rv = mParserWrapper->LoadParser(window);
  NS_ENSURE_SUCCESS(rv, rv);

  rv = mParserWrapper->Watch(this);
  NS_ENSURE_SUCCESS(rv, rv);

  mElement->SetReadyState(TextTrackReadyState::Loading);
  return NS_OK;
}

NS_IMETHODIMP
WebVTTListener::AsyncOnChannelRedirect(nsIChannel* aOldChannel,
                                       nsIChannel* aNewChannel,
                                       uint32_t aFlags,
                                       nsIAsyncVerifyRedirectCallback* cb)
{
  if (mElement) {
    mElement->OnChannelRedirect(aOldChannel, aNewChannel, aFlags);
  }
  cb->OnRedirectVerifyCallback(NS_OK);
  return NS_OK;
}

NS_IMETHODIMP
WebVTTListener::OnStartRequest(nsIRequest* aRequest,
                               nsISupports* aContext)
{
  VTT_LOG("WebVTTListener::OnStartRequest\n");
  return NS_OK;
}

NS_IMETHODIMP
WebVTTListener::OnStopRequest(nsIRequest* aRequest,
                              nsISupports* aContext,
                              nsresult aStatus)
{
  VTT_LOG("WebVTTListener::OnStopRequest\n");
  if (NS_FAILED(aStatus)) {
    mElement->SetReadyState(TextTrackReadyState::FailedToLoad);
  }
  // Attempt to parse any final data the parser might still have.
  mParserWrapper->Flush();
  if (mElement->ReadyState() != TextTrackReadyState::FailedToLoad) {
    mElement->SetReadyState(TextTrackReadyState::Loaded);
  }

  mElement->DropChannel();

  return aStatus;
}

nsresult
WebVTTListener::ParseChunk(nsIInputStream* aInStream, void* aClosure,
                           const char* aFromSegment, uint32_t aToOffset,
                           uint32_t aCount, uint32_t* aWriteCount)
{
  nsCString buffer(aFromSegment, aCount);
  WebVTTListener* listener = static_cast<WebVTTListener*>(aClosure);

  if (NS_FAILED(listener->mParserWrapper->Parse(buffer))) {
    VTT_LOG("Unable to parse chunk of WEBVTT text. Aborting.");
    *aWriteCount = 0;
    return NS_ERROR_FAILURE;
  }

  *aWriteCount = aCount;
  return NS_OK;
}

NS_IMETHODIMP
WebVTTListener::OnDataAvailable(nsIRequest* aRequest,
                                nsISupports* aContext,
                                nsIInputStream* aStream,
                                uint64_t aOffset,
                                uint32_t aCount)
{
  VTT_LOG("WebVTTListener::OnDataAvailable\n");
  uint32_t count = aCount;
  while (count > 0) {
    uint32_t read;
    nsresult rv = aStream->ReadSegments(ParseChunk, this, count, &read);
    NS_ENSURE_SUCCESS(rv, rv);
    if (!read) {
      return NS_ERROR_FAILURE;
    }
    count -= read;
  }

  return NS_OK;
}

NS_IMETHODIMP
WebVTTListener::OnCue(JS::Handle<JS::Value> aCue, JSContext* aCx)
{
  if (!aCue.isObject()) {
    return NS_ERROR_FAILURE;
  }

  TextTrackCue* cue = nullptr;
  nsresult rv = UNWRAP_OBJECT(VTTCue, &aCue.toObject(), cue);
  NS_ENSURE_SUCCESS(rv, rv);

  cue->SetTrackElement(mElement);
  mElement->mTrack->AddCue(*cue);

  return NS_OK;
}


NS_IMETHODIMP
WebVTTListener::OnRegion(JS::Handle<JS::Value> aRegion, JSContext* aCx)
{
  // Nothing for this callback to do.
  return NS_OK;
}

NS_IMETHODIMP
WebVTTListener::OnParsingError(int32_t errorCode, JSContext* cx)
{
  // We only care about files that have a bad WebVTT file signature right now
  // as that means the file failed to load.
  if (errorCode == ErrorCodes::BadSignature) {
    mElement->SetReadyState(TextTrackReadyState::FailedToLoad);
  }
  return NS_OK;
}

} // namespace dom
} // namespace mozilla
