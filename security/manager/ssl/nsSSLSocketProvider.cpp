/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/BasePrincipal.h"
#include "nsSSLSocketProvider.h"
#include "nsNSSIOLayer.h"
#include "nsError.h"

using mozilla::NeckoOriginAttributes;

nsSSLSocketProvider::nsSSLSocketProvider()
{
}

nsSSLSocketProvider::~nsSSLSocketProvider()
{
}

NS_IMPL_ISUPPORTS(nsSSLSocketProvider, nsISocketProvider)

NS_IMETHODIMP
nsSSLSocketProvider::NewSocket(int32_t family,
                               const char *host,
                               int32_t port,
                               nsIProxyInfo *proxy,
                               const NeckoOriginAttributes &originAttributes,
                               uint32_t flags,
                               PRFileDesc **_result,
                               nsISupports **securityInfo)
{
  nsresult rv = nsSSLIOLayerNewSocket(family,
                                      host,
                                      port,
                                      proxy,
                                      originAttributes,
                                      _result,
                                      securityInfo,
                                      false,
                                      flags);
  return (NS_FAILED(rv)) ? NS_ERROR_SOCKET_CREATE_FAILED : NS_OK;
}

// Add the SSL IO layer to an existing socket
NS_IMETHODIMP
nsSSLSocketProvider::AddToSocket(int32_t family,
                                 const char *host,
                                 int32_t port,
                                 nsIProxyInfo *proxy,
                                 const NeckoOriginAttributes &originAttributes,
                                 uint32_t flags,
                                 PRFileDesc *aSocket,
                                 nsISupports **securityInfo)
{
  nsresult rv = nsSSLIOLayerAddToSocket(family,
                                        host,
                                        port,
                                        proxy,
                                        originAttributes,
                                        aSocket,
                                        securityInfo,
                                        false,
                                        flags);
  
  return (NS_FAILED(rv)) ? NS_ERROR_SOCKET_CREATE_FAILED : NS_OK;
}
