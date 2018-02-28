/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsUrlClassifierProxies.h"
#include "nsUrlClassifierDBService.h"

#include "mozilla/SyncRunnable.h"

using namespace mozilla::safebrowsing;
using mozilla::NewRunnableMethod;

static nsresult
DispatchToWorkerThread(nsIRunnable* r)
{
  nsIThread* t = nsUrlClassifierDBService::BackgroundThread();
  if (!t)
    return NS_ERROR_FAILURE;

  return t->Dispatch(r, NS_DISPATCH_NORMAL);
}

NS_IMPL_ISUPPORTS(UrlClassifierDBServiceWorkerProxy, nsIUrlClassifierDBService)

NS_IMETHODIMP
UrlClassifierDBServiceWorkerProxy::Lookup(nsIPrincipal* aPrincipal,
                                          const nsACString& aTables,
                                          nsIUrlClassifierCallback* aCB)
{
  nsCOMPtr<nsIRunnable> r = new LookupRunnable(mTarget, aPrincipal, aTables,
                                               aCB);
  return DispatchToWorkerThread(r);
}

NS_IMETHODIMP
UrlClassifierDBServiceWorkerProxy::LookupRunnable::Run()
{
  (void) mTarget->Lookup(mPrincipal, mLookupTables, mCB);
  return NS_OK;
}

NS_IMETHODIMP
UrlClassifierDBServiceWorkerProxy::GetTables(nsIUrlClassifierCallback* aCB)
{
  nsCOMPtr<nsIRunnable> r = new GetTablesRunnable(mTarget, aCB);
  return DispatchToWorkerThread(r);
}

NS_IMETHODIMP
UrlClassifierDBServiceWorkerProxy::GetTablesRunnable::Run()
{
  mTarget->GetTables(mCB);
  return NS_OK;
}

NS_IMETHODIMP
UrlClassifierDBServiceWorkerProxy::SetHashCompleter
  (const nsACString&, nsIUrlClassifierHashCompleter*)
{
  NS_NOTREACHED("This method should not be called!");
  return NS_ERROR_NOT_IMPLEMENTED;
}

NS_IMETHODIMP
UrlClassifierDBServiceWorkerProxy::BeginUpdate
  (nsIUrlClassifierUpdateObserver* aUpdater,
   const nsACString& aTables)
{
  nsCOMPtr<nsIRunnable> r = new BeginUpdateRunnable(mTarget, aUpdater,
                                                    aTables);
  return DispatchToWorkerThread(r);
}

NS_IMETHODIMP
UrlClassifierDBServiceWorkerProxy::BeginUpdateRunnable::Run()
{
  mTarget->BeginUpdate(mUpdater, mTables);
  return NS_OK;
}

NS_IMETHODIMP
UrlClassifierDBServiceWorkerProxy::BeginStream(const nsACString& aTable)
{
  nsCOMPtr<nsIRunnable> r =
    new BeginStreamRunnable(mTarget, aTable);
  return DispatchToWorkerThread(r);
}

NS_IMETHODIMP
UrlClassifierDBServiceWorkerProxy::BeginStreamRunnable::Run()
{
  mTarget->BeginStream(mTable);
  return NS_OK;
}

NS_IMETHODIMP
UrlClassifierDBServiceWorkerProxy::UpdateStream(const nsACString& aUpdateChunk)
{
  nsCOMPtr<nsIRunnable> r =
    new UpdateStreamRunnable(mTarget, aUpdateChunk);
  return DispatchToWorkerThread(r);
}

NS_IMETHODIMP
UrlClassifierDBServiceWorkerProxy::UpdateStreamRunnable::Run()
{
  mTarget->UpdateStream(mUpdateChunk);
  return NS_OK;
}

NS_IMETHODIMP
UrlClassifierDBServiceWorkerProxy::FinishStream()
{
  nsCOMPtr<nsIRunnable> r =
    NewRunnableMethod("nsUrlClassifierDBServiceWorker::FinishStream",
                      mTarget,
                      &nsUrlClassifierDBServiceWorker::FinishStream);
  return DispatchToWorkerThread(r);
}

NS_IMETHODIMP
UrlClassifierDBServiceWorkerProxy::DoLocalLookupRunnable::Run()
{
  mTarget->DoLocalLookup(mSpec, mTables, mResults);
  return NS_OK;
}

nsresult
UrlClassifierDBServiceWorkerProxy::DoLocalLookup(const nsACString& spec,
                                                 const nsACString& tables,
                                                 LookupResultArray* results)

{
  // Run synchronously on background thread. NS_DISPATCH_SYNC does *not* do
  // what we want -- it continues processing events on the main thread loop
  // before the Dispatch returns.
  nsCOMPtr<nsIRunnable> r = new DoLocalLookupRunnable(mTarget, spec, tables, results);
  nsIThread* t = nsUrlClassifierDBService::BackgroundThread();
  if (!t)
    return NS_ERROR_FAILURE;

  mozilla::SyncRunnable::DispatchToThread(t, r);
  return NS_OK;
}

NS_IMETHODIMP
UrlClassifierDBServiceWorkerProxy::FinishUpdate()
{
  nsCOMPtr<nsIRunnable> r =
    NewRunnableMethod("nsUrlClassifierDBServiceWorker::FinishUpdate",
                      mTarget,
                      &nsUrlClassifierDBServiceWorker::FinishUpdate);
  return DispatchToWorkerThread(r);
}

NS_IMETHODIMP
UrlClassifierDBServiceWorkerProxy::CancelUpdate()
{
  nsCOMPtr<nsIRunnable> r =
    NewRunnableMethod("nsUrlClassifierDBServiceWorker::CancelUpdate",
                      mTarget,
                      &nsUrlClassifierDBServiceWorker::CancelUpdate);
  return DispatchToWorkerThread(r);
}

NS_IMETHODIMP
UrlClassifierDBServiceWorkerProxy::ResetDatabase()
{
  nsCOMPtr<nsIRunnable> r =
    NewRunnableMethod("nsUrlClassifierDBServiceWorker::ResetDatabase",
                      mTarget,
                      &nsUrlClassifierDBServiceWorker::ResetDatabase);
  return DispatchToWorkerThread(r);
}

NS_IMETHODIMP
UrlClassifierDBServiceWorkerProxy::ReloadDatabase()
{
  nsCOMPtr<nsIRunnable> r =
    NewRunnableMethod("nsUrlClassifierDBServiceWorker::ReloadDatabase",
                      mTarget,
                      &nsUrlClassifierDBServiceWorker::ReloadDatabase);
  return DispatchToWorkerThread(r);
}

NS_IMETHODIMP
UrlClassifierDBServiceWorkerProxy::ClearCache()
{
  nsCOMPtr<nsIRunnable> r =
    NewRunnableMethod("nsUrlClassifierDBServiceWorker::ClearCache",
                      mTarget,
                      &nsUrlClassifierDBServiceWorker::ClearCache);
  return DispatchToWorkerThread(r);
}

nsresult
UrlClassifierDBServiceWorkerProxy::OpenDb()
{
  nsCOMPtr<nsIRunnable> r =
    NewRunnableMethod("nsUrlClassifierDBServiceWorker::OpenDb",
                      mTarget,
                      &nsUrlClassifierDBServiceWorker::OpenDb);
  return DispatchToWorkerThread(r);
}

nsresult
UrlClassifierDBServiceWorkerProxy::CloseDb()
{
  nsCOMPtr<nsIRunnable> r =
    NewRunnableMethod("nsUrlClassifierDBServiceWorker::CloseDb",
                      mTarget,
                      &nsUrlClassifierDBServiceWorker::CloseDb);
  return DispatchToWorkerThread(r);
}

nsresult
UrlClassifierDBServiceWorkerProxy::CacheCompletions(CacheResultArray * aEntries)
{
  nsCOMPtr<nsIRunnable> r = new CacheCompletionsRunnable(mTarget, aEntries);
  return DispatchToWorkerThread(r);
}

NS_IMETHODIMP
UrlClassifierDBServiceWorkerProxy::CacheCompletionsRunnable::Run()
{
  mTarget->CacheCompletions(mEntries);
  return NS_OK;
}

NS_IMETHODIMP
UrlClassifierDBServiceWorkerProxy::ClearLastResults()
{
  nsCOMPtr<nsIRunnable> r = new ClearLastResultsRunnable(mTarget);
  return DispatchToWorkerThread(r);
}

NS_IMETHODIMP
UrlClassifierDBServiceWorkerProxy::ClearLastResultsRunnable::Run()
{
  return mTarget->ClearLastResults();
}

nsresult
UrlClassifierDBServiceWorkerProxy::GetCacheInfo(const nsACString& aTable,
                                                nsIUrlClassifierCacheInfo** aCache)
{
  nsCOMPtr<nsIRunnable> r = new GetCacheInfoRunnable(mTarget, aTable, aCache);

  nsIThread* t = nsUrlClassifierDBService::BackgroundThread();
  if (!t) {
    return NS_ERROR_FAILURE;
  }

  // This blocks main thread but since 'GetCacheInfo' is only used by
  // about:url-classifier so it should be fine.
  mozilla::SyncRunnable::DispatchToThread(t, r);
  return NS_OK;
}

NS_IMETHODIMP
UrlClassifierDBServiceWorkerProxy::GetCacheInfoRunnable::Run()
{
  return mTarget->GetCacheInfo(mTable, mCache);
}

NS_IMPL_ISUPPORTS(UrlClassifierLookupCallbackProxy,
                  nsIUrlClassifierLookupCallback)

NS_IMETHODIMP
UrlClassifierLookupCallbackProxy::LookupComplete
  (LookupResultArray * aResults)
{
  nsCOMPtr<nsIRunnable> r = new LookupCompleteRunnable(mTarget, aResults);
  return NS_DispatchToMainThread(r);
}

NS_IMETHODIMP
UrlClassifierLookupCallbackProxy::LookupCompleteRunnable::Run()
{
  mTarget->LookupComplete(mResults);
  return NS_OK;
}

NS_IMPL_ISUPPORTS(UrlClassifierCallbackProxy,
                  nsIUrlClassifierCallback)

NS_IMETHODIMP
UrlClassifierCallbackProxy::HandleEvent(const nsACString& aValue)
{
  nsCOMPtr<nsIRunnable> r = new HandleEventRunnable(mTarget, aValue);
  return NS_DispatchToMainThread(r);
}

NS_IMETHODIMP
UrlClassifierCallbackProxy::HandleEventRunnable::Run()
{
  mTarget->HandleEvent(mValue);
  return NS_OK;
}

NS_IMPL_ISUPPORTS(UrlClassifierUpdateObserverProxy,
                  nsIUrlClassifierUpdateObserver)

NS_IMETHODIMP
UrlClassifierUpdateObserverProxy::UpdateUrlRequested
  (const nsACString& aURL,
   const nsACString& aTable)
{
  nsCOMPtr<nsIRunnable> r =
    new UpdateUrlRequestedRunnable(mTarget, aURL, aTable);
  return NS_DispatchToMainThread(r);
}

NS_IMETHODIMP
UrlClassifierUpdateObserverProxy::UpdateUrlRequestedRunnable::Run()
{
  mTarget->UpdateUrlRequested(mURL, mTable);
  return NS_OK;
}

NS_IMETHODIMP
UrlClassifierUpdateObserverProxy::StreamFinished(nsresult aStatus,
                                                 uint32_t aDelay)
{
  nsCOMPtr<nsIRunnable> r =
    new StreamFinishedRunnable(mTarget, aStatus, aDelay);
  return NS_DispatchToMainThread(r);
}

NS_IMETHODIMP
UrlClassifierUpdateObserverProxy::StreamFinishedRunnable::Run()
{
  mTarget->StreamFinished(mStatus, mDelay);
  return NS_OK;
}

NS_IMETHODIMP
UrlClassifierUpdateObserverProxy::UpdateError(nsresult aError)
{
  nsCOMPtr<nsIRunnable> r =
    new UpdateErrorRunnable(mTarget, aError);
  return NS_DispatchToMainThread(r);
}

NS_IMETHODIMP
UrlClassifierUpdateObserverProxy::UpdateErrorRunnable::Run()
{
  mTarget->UpdateError(mError);
  return NS_OK;
}

NS_IMETHODIMP
UrlClassifierUpdateObserverProxy::UpdateSuccess(uint32_t aRequestedTimeout)
{
  nsCOMPtr<nsIRunnable> r =
    new UpdateSuccessRunnable(mTarget, aRequestedTimeout);
  return NS_DispatchToMainThread(r);
}

NS_IMETHODIMP
UrlClassifierUpdateObserverProxy::UpdateSuccessRunnable::Run()
{
  mTarget->UpdateSuccess(mRequestedTimeout);
  return NS_OK;
}
