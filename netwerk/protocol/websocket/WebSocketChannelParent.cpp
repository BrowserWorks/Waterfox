/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set sw=2 ts=8 et tw=80 : */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "WebSocketLog.h"
#include "WebSocketChannelParent.h"
#include "nsIAuthPromptProvider.h"
#include "mozilla/ipc/InputStreamUtils.h"
#include "mozilla/ipc/URIUtils.h"
#include "mozilla/ipc/BackgroundUtils.h"
#include "SerializedLoadContext.h"
#include "mozilla/net/NeckoCommon.h"
#include "mozilla/net/WebSocketChannel.h"

using namespace mozilla::ipc;

namespace mozilla {
namespace net {

NS_IMPL_ISUPPORTS(WebSocketChannelParent,
                  nsIWebSocketListener,
                  nsIInterfaceRequestor)

WebSocketChannelParent::WebSocketChannelParent(nsIAuthPromptProvider* aAuthProvider,
                                               nsILoadContext* aLoadContext,
                                               PBOverrideStatus aOverrideStatus,
                                               uint32_t aSerial)
  : mAuthProvider(aAuthProvider)
  , mLoadContext(aLoadContext)
  , mIPCOpen(true)
  , mSerial(aSerial)
{
  // Websocket channels can't have a private browsing override
  MOZ_ASSERT_IF(!aLoadContext, aOverrideStatus == kPBOverride_Unset);
}

WebSocketChannelParent::~WebSocketChannelParent()
{
}
//-----------------------------------------------------------------------------
// WebSocketChannelParent::PWebSocketChannelParent
//-----------------------------------------------------------------------------

bool
WebSocketChannelParent::RecvDeleteSelf()
{
  LOG(("WebSocketChannelParent::RecvDeleteSelf() %p\n", this));
  mChannel = nullptr;
  mAuthProvider = nullptr;
  return mIPCOpen ? Send__delete__(this) : true;
}

bool
WebSocketChannelParent::RecvAsyncOpen(const OptionalURIParams& aURI,
                                      const nsCString& aOrigin,
                                      const uint64_t& aInnerWindowID,
                                      const nsCString& aProtocol,
                                      const bool& aSecure,
                                      const uint32_t& aPingInterval,
                                      const bool& aClientSetPingInterval,
                                      const uint32_t& aPingTimeout,
                                      const bool& aClientSetPingTimeout,
                                      const OptionalLoadInfoArgs& aLoadInfoArgs,
                                      const OptionalTransportProvider& aTransportProvider,
                                      const nsCString& aNegotiatedExtensions)
{
  LOG(("WebSocketChannelParent::RecvAsyncOpen() %p\n", this));

  nsresult rv;
  nsCOMPtr<nsIURI> uri;
  nsCOMPtr<nsILoadInfo> loadInfo;

  rv = LoadInfoArgsToLoadInfo(aLoadInfoArgs, getter_AddRefs(loadInfo));
  if (NS_FAILED(rv)) {
    goto fail;
  }

  if (aSecure) {
    mChannel =
      do_CreateInstance("@mozilla.org/network/protocol;1?name=wss", &rv);
  } else {
    mChannel =
      do_CreateInstance("@mozilla.org/network/protocol;1?name=ws", &rv);
  }
  if (NS_FAILED(rv))
    goto fail;

  rv = mChannel->SetSerial(mSerial);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    goto fail;
  }

  rv = mChannel->SetLoadInfo(loadInfo);
  if (NS_FAILED(rv)) {
    goto fail;
  }

  rv = mChannel->SetNotificationCallbacks(this);
  if (NS_FAILED(rv))
    goto fail;

  rv = mChannel->SetProtocol(aProtocol);
  if (NS_FAILED(rv))
    goto fail;

  if (aTransportProvider.type() != OptionalTransportProvider::Tvoid_t) {
    RefPtr<TransportProviderParent> provider =
      static_cast<TransportProviderParent*>(
        aTransportProvider.get_PTransportProviderParent());
    rv = mChannel->SetServerParameters(provider, aNegotiatedExtensions);
    if (NS_FAILED(rv)) {
      goto fail;
    }
  } else {
    uri = DeserializeURI(aURI);
    if (!uri) {
      rv = NS_ERROR_FAILURE;
      goto fail;
    }
  }

  // only use ping values from child if they were overridden by client code.
  if (aClientSetPingInterval) {
    // IDL allows setting in seconds, so must be multiple of 1000 ms
    MOZ_ASSERT(aPingInterval >= 1000 && !(aPingInterval % 1000));
    mChannel->SetPingInterval(aPingInterval / 1000);
  }
  if (aClientSetPingTimeout) {
    MOZ_ASSERT(aPingTimeout >= 1000 && !(aPingTimeout % 1000));
    mChannel->SetPingTimeout(aPingTimeout / 1000);
  }

  rv = mChannel->AsyncOpen(uri, aOrigin, aInnerWindowID, this, nullptr);
  if (NS_FAILED(rv))
    goto fail;

  return true;

fail:
  mChannel = nullptr;
  return SendOnStop(rv);
}

bool
WebSocketChannelParent::RecvClose(const uint16_t& code, const nsCString& reason)
{
  LOG(("WebSocketChannelParent::RecvClose() %p\n", this));
  if (mChannel) {
    nsresult rv = mChannel->Close(code, reason);
    NS_ENSURE_SUCCESS(rv, true);
  }

  return true;
}

bool
WebSocketChannelParent::RecvSendMsg(const nsCString& aMsg)
{
  LOG(("WebSocketChannelParent::RecvSendMsg() %p\n", this));
  if (mChannel) {
    nsresult rv = mChannel->SendMsg(aMsg);
    NS_ENSURE_SUCCESS(rv, true);
  }
  return true;
}

bool
WebSocketChannelParent::RecvSendBinaryMsg(const nsCString& aMsg)
{
  LOG(("WebSocketChannelParent::RecvSendBinaryMsg() %p\n", this));
  if (mChannel) {
    nsresult rv = mChannel->SendBinaryMsg(aMsg);
    NS_ENSURE_SUCCESS(rv, true);
  }
  return true;
}

bool
WebSocketChannelParent::RecvSendBinaryStream(const InputStreamParams& aStream,
                                             const uint32_t& aLength)
{
  LOG(("WebSocketChannelParent::RecvSendBinaryStream() %p\n", this));
  if (mChannel) {
    nsTArray<mozilla::ipc::FileDescriptor> fds;
    nsCOMPtr<nsIInputStream> stream = DeserializeInputStream(aStream, fds);
    if (!stream) {
      return false;
    }
    nsresult rv = mChannel->SendBinaryStream(stream, aLength);
    NS_ENSURE_SUCCESS(rv, true);
  }
  return true;
}

//-----------------------------------------------------------------------------
// WebSocketChannelParent::nsIRequestObserver
//-----------------------------------------------------------------------------

NS_IMETHODIMP
WebSocketChannelParent::OnStart(nsISupports *aContext)
{
  LOG(("WebSocketChannelParent::OnStart() %p\n", this));
  nsAutoCString protocol, extensions;
  nsString effectiveURL;
  bool encrypted = false;
  if (mChannel) {
    mChannel->GetProtocol(protocol);
    mChannel->GetExtensions(extensions);

    RefPtr<WebSocketChannel> channel;
    channel = static_cast<WebSocketChannel*>(mChannel.get());
    MOZ_ASSERT(channel);

    channel->GetEffectiveURL(effectiveURL);
    encrypted = channel->IsEncrypted();
  }
  if (!mIPCOpen || !SendOnStart(protocol, extensions, effectiveURL, encrypted)) {
    return NS_ERROR_FAILURE;
  }
  return NS_OK;
}

NS_IMETHODIMP
WebSocketChannelParent::OnStop(nsISupports *aContext, nsresult aStatusCode)
{
  LOG(("WebSocketChannelParent::OnStop() %p\n", this));
  if (!mIPCOpen || !SendOnStop(aStatusCode)) {
    return NS_ERROR_FAILURE;
  }
  return NS_OK;
}

NS_IMETHODIMP
WebSocketChannelParent::OnMessageAvailable(nsISupports *aContext, const nsACString& aMsg)
{
  LOG(("WebSocketChannelParent::OnMessageAvailable() %p\n", this));
  if (!mIPCOpen || !SendOnMessageAvailable(nsCString(aMsg))) {
    return NS_ERROR_FAILURE;
  }
  return NS_OK;
}

NS_IMETHODIMP
WebSocketChannelParent::OnBinaryMessageAvailable(nsISupports *aContext, const nsACString& aMsg)
{
  LOG(("WebSocketChannelParent::OnBinaryMessageAvailable() %p\n", this));
  if (!mIPCOpen || !SendOnBinaryMessageAvailable(nsCString(aMsg))) {
    return NS_ERROR_FAILURE;
  }
  return NS_OK;
}

NS_IMETHODIMP
WebSocketChannelParent::OnAcknowledge(nsISupports *aContext, uint32_t aSize)
{
  LOG(("WebSocketChannelParent::OnAcknowledge() %p\n", this));
  if (!mIPCOpen || !SendOnAcknowledge(aSize)) {
    return NS_ERROR_FAILURE;
  }
  return NS_OK;
}

NS_IMETHODIMP
WebSocketChannelParent::OnServerClose(nsISupports *aContext,
                                      uint16_t code, const nsACString & reason)
{
  LOG(("WebSocketChannelParent::OnServerClose() %p\n", this));
  if (!mIPCOpen || !SendOnServerClose(code, nsCString(reason))) {
    return NS_ERROR_FAILURE;
  }
  return NS_OK;
}

void
WebSocketChannelParent::ActorDestroy(ActorDestroyReason why)
{
  LOG(("WebSocketChannelParent::ActorDestroy() %p\n", this));
  mIPCOpen = false;
}

//-----------------------------------------------------------------------------
// WebSocketChannelParent::nsIInterfaceRequestor
//-----------------------------------------------------------------------------

NS_IMETHODIMP
WebSocketChannelParent::GetInterface(const nsIID & iid, void **result)
{
  LOG(("WebSocketChannelParent::GetInterface() %p\n", this));
  if (mAuthProvider && iid.Equals(NS_GET_IID(nsIAuthPromptProvider)))
    return mAuthProvider->GetAuthPrompt(nsIAuthPromptProvider::PROMPT_NORMAL,
                                        iid, result);

  // Only support nsILoadContext if child channel's callbacks did too
  if (iid.Equals(NS_GET_IID(nsILoadContext)) && mLoadContext) {
    nsCOMPtr<nsILoadContext> copy = mLoadContext;
    copy.forget(result);
    return NS_OK;
  }

  return QueryInterface(iid, result);
}

} // namespace net
} // namespace mozilla
