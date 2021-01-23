/* -*- Mode: c++; c-basic-offset: 2; tab-width: 20; indent-tabs-mode: nil; -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsExternalURLHandlerService.h"
#include "nsMIMEInfoAndroid.h"

NS_IMPL_ISUPPORTS(nsExternalURLHandlerService, nsIExternalURLHandlerService)

nsExternalURLHandlerService::nsExternalURLHandlerService() {}

nsExternalURLHandlerService::~nsExternalURLHandlerService() {}

NS_IMETHODIMP
nsExternalURLHandlerService::GetURLHandlerInfoFromOS(nsIURI* aURL, bool* found,
                                                     nsIHandlerInfo** info) {
  // We don't want to get protocol handlers from the OS in GV; the app
  // should take care of that in NavigationDelegate.onLoadRequest().
  return NS_ERROR_NOT_IMPLEMENTED;
}
