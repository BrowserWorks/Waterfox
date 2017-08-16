/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "URLClassifierParent.h"
#include "nsComponentManagerUtils.h"
#include "mozilla/Unused.h"

using namespace mozilla;
using namespace mozilla::dom;

/////////////////////////////////////////////////////////////////////
//URLClassifierParent.

NS_IMPL_ISUPPORTS(URLClassifierParent, nsIURIClassifierCallback)

mozilla::ipc::IPCResult
URLClassifierParent::StartClassify(nsIPrincipal* aPrincipal,
                                   bool aUseTrackingProtection,
                                   bool* aSuccess)
{
  *aSuccess = false;
  nsresult rv = NS_OK;
  // Note that in safe mode, the URL classifier service isn't available, so we
  // should handle the service not being present gracefully.
  nsCOMPtr<nsIURIClassifier> uriClassifier =
    do_GetService(NS_URICLASSIFIERSERVICE_CONTRACTID, &rv);
  if (NS_SUCCEEDED(rv)) {
    rv = uriClassifier->Classify(aPrincipal, nullptr, aUseTrackingProtection,
                                 this, aSuccess);
  }
  if (NS_FAILED(rv) || !*aSuccess) {
    // We treat the case where we fail to classify and the case where the
    // classifier returns successfully but doesn't perform a lookup as the
    // classification not yielding any results, so we just kill the child actor
    // without ever calling out callback in both cases.
    // This means that code using this in the child process will only get a hit
    // on its callback if some classification actually happens.
    *aSuccess = false;
    ClassificationFailed();
  }
  return IPC_OK();
}

void
URLClassifierParent::ActorDestroy(ActorDestroyReason aWhy)
{
  mIPCOpen = false;
}

/////////////////////////////////////////////////////////////////////
//URLClassifierLocalParent.

NS_IMPL_ISUPPORTS(URLClassifierLocalParent, nsIURIClassifierCallback)

mozilla::ipc::IPCResult
URLClassifierLocalParent::StartClassify(nsIURI* aURI, const nsACString& aTables)
{
  nsresult rv = NS_OK;
  // Note that in safe mode, the URL classifier service isn't available, so we
  // should handle the service not being present gracefully.
  nsCOMPtr<nsIURIClassifier> uriClassifier =
    do_GetService(NS_URICLASSIFIERSERVICE_CONTRACTID, &rv);
  if (NS_SUCCEEDED(rv)) {
    MOZ_ASSERT(aURI);
    rv = uriClassifier->AsyncClassifyLocalWithTables(aURI, aTables, this);
  }
  if (NS_FAILED(rv)) {
    // Cannot do ClassificationFailed() because the child side
    // is expecting a callback. Only the second parameter will
    // be used, which is the "matched list". We treat "unable
    // to classify" as "not on any list".
    OnClassifyComplete(NS_OK, EmptyCString(), EmptyCString(), EmptyCString());
  }
  return IPC_OK();
}

void
URLClassifierLocalParent::ActorDestroy(ActorDestroyReason aWhy)
{
  mIPCOpen = false;
}
