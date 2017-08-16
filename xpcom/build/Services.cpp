/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/Likely.h"
#include "mozilla/Services.h"
#include "nsComponentManager.h"
#include "nsIObserverService.h"
#include "nsNetCID.h"
#include "nsObserverService.h"
#include "nsXPCOMPrivate.h"
#include "nsIIOService.h"
#include "nsIDirectoryService.h"
#include "nsIChromeRegistry.h"
#include "nsIStringBundle.h"
#include "nsIToolkitChromeRegistry.h"
#include "nsIXULOverlayProvider.h"
#include "IHistory.h"
#include "nsIXPConnect.h"
#include "inIDOMUtils.h"
#include "nsIPermissionManager.h"
#include "nsIServiceWorkerManager.h"
#include "nsICacheStorageService.h"
#include "nsIStreamTransportService.h"
#include "nsISocketTransportService.h"
#include "nsIURIClassifier.h"
#include "nsIHttpActivityObserver.h"
#include "nsIAsyncShutdown.h"
#include "nsIUUIDGenerator.h"
#include "nsIGfxInfo.h"

using namespace mozilla;
using namespace mozilla::services;

/*
 * Define a global variable and a getter for every service in ServiceList.
 * eg. gIOService and GetIOService()
 */
#define MOZ_SERVICE(NAME, TYPE, CONTRACT_ID)                            \
  static TYPE* g##NAME = nullptr;                                       \
                                                                        \
  already_AddRefed<TYPE>                                                \
  mozilla::services::Get##NAME()                                        \
  {                                                                     \
    if (MOZ_UNLIKELY(gXPCOMShuttingDown)) {                             \
      return nullptr;                                                   \
    }                                                                   \
    if (!g##NAME) {                                                     \
      nsCOMPtr<TYPE> os = do_GetService(CONTRACT_ID);                   \
      os.swap(g##NAME);                                                 \
    }                                                                   \
    nsCOMPtr<TYPE> ret = g##NAME;                                       \
    return ret.forget();                                                \
  }

#include "ServiceList.h"
#undef MOZ_SERVICE

/**
 * Clears service cache, sets gXPCOMShuttingDown
 */
void
mozilla::services::Shutdown()
{
  gXPCOMShuttingDown = true;
#define MOZ_SERVICE(NAME, TYPE, CONTRACT_ID) NS_IF_RELEASE(g##NAME);
#include "ServiceList.h"
#undef MOZ_SERVICE
}
