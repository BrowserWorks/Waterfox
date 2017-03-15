/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* vim:set expandtab ts=4 sw=4 sts=4 cin: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

// HttpLog.h should generally be included first
#include "HttpLog.h"

#include <inttypes.h>

#include "mozilla/dom/nsCSPContext.h"
#include "mozilla/Sprintf.h"

#include "nsHttp.h"
#include "nsHttpChannel.h"
#include "nsHttpHandler.h"
#include "nsIApplicationCacheService.h"
#include "nsIApplicationCacheContainer.h"
#include "nsICacheStorageService.h"
#include "nsICacheStorage.h"
#include "nsICacheEntry.h"
#include "nsICaptivePortalService.h"
#include "nsICryptoHash.h"
#include "nsINetworkInterceptController.h"
#include "nsINSSErrorsService.h"
#include "nsISecurityReporter.h"
#include "nsIStringBundle.h"
#include "nsIStreamListenerTee.h"
#include "nsISeekableStream.h"
#include "nsILoadGroupChild.h"
#include "nsIProtocolProxyService2.h"
#include "nsIURIClassifier.h"
#include "nsMimeTypes.h"
#include "nsNetCID.h"
#include "nsNetUtil.h"
#include "nsIURL.h"
#include "nsIStreamTransportService.h"
#include "prnetdb.h"
#include "nsEscape.h"
#include "nsStreamUtils.h"
#include "nsIOService.h"
#include "nsDNSPrefetch.h"
#include "nsChannelClassifier.h"
#include "nsIRedirectResultListener.h"
#include "mozilla/dom/ContentVerifier.h"
#include "mozilla/TimeStamp.h"
#include "nsError.h"
#include "nsPrintfCString.h"
#include "nsAlgorithm.h"
#include "nsQueryObject.h"
#include "GeckoProfiler.h"
#include "nsIConsoleService.h"
#include "mozilla/Attributes.h"
#include "mozilla/DebugOnly.h"
#include "mozilla/Preferences.h"
#include "nsISSLSocketControl.h"
#include "sslt.h"
#include "nsContentUtils.h"
#include "nsContentSecurityManager.h"
#include "nsIClassOfService.h"
#include "nsIPermissionManager.h"
#include "nsIPrincipal.h"
#include "nsIScriptSecurityManager.h"
#include "nsISSLStatus.h"
#include "nsISSLStatusProvider.h"
#include "nsITransportSecurityInfo.h"
#include "nsIWebProgressListener.h"
#include "LoadContextInfo.h"
#include "netCore.h"
#include "nsHttpTransaction.h"
#include "nsICacheEntryDescriptor.h"
#include "nsICancelable.h"
#include "nsIHttpChannelAuthProvider.h"
#include "nsIHttpChannelInternal.h"
#include "nsIHttpEventSink.h"
#include "nsIPrompt.h"
#include "nsInputStreamPump.h"
#include "nsURLHelper.h"
#include "nsISocketTransport.h"
#include "nsIStreamConverterService.h"
#include "nsISiteSecurityService.h"
#include "nsString.h"
#include "nsCRT.h"
#include "CacheObserver.h"
#include "mozilla/dom/Performance.h"
#include "mozilla/Telemetry.h"
#include "AlternateServices.h"
#include "InterceptedChannel.h"
#include "nsIHttpPushListener.h"
#include "nsIX509Cert.h"
#include "ScopedNSSTypes.h"
#include "nsNullPrincipal.h"
#include "nsIDeprecationWarner.h"
#include "nsIDocument.h"
#include "nsIDOMDocument.h"
#include "nsICompressConvStats.h"
#include "nsCORSListenerProxy.h"
#include "nsISocketProvider.h"
#include "mozilla/net/Predictor.h"
#include "CacheControlParser.h"
#include "nsMixedContentBlocker.h"
#include "HSTSPrimerListener.h"
#include "CacheStorageService.h"

namespace mozilla { namespace net {

namespace {

// Monotonically increasing ID for generating unique cache entries per
// intercepted channel.
static uint64_t gNumIntercepted = 0;

// True if the local cache should be bypassed when processing a request.
#define BYPASS_LOCAL_CACHE(loadFlags) \
        (loadFlags & (nsIRequest::LOAD_BYPASS_CACHE | \
                      nsICachingChannel::LOAD_BYPASS_LOCAL_CACHE))

#define RECOVER_FROM_CACHE_FILE_ERROR(result) \
        ((result) == NS_ERROR_FILE_NOT_FOUND || \
         (result) == NS_ERROR_FILE_CORRUPTED || \
         (result) == NS_ERROR_OUT_OF_MEMORY)

static NS_DEFINE_CID(kStreamListenerTeeCID, NS_STREAMLISTENERTEE_CID);
static NS_DEFINE_CID(kStreamTransportServiceCID,
                     NS_STREAMTRANSPORTSERVICE_CID);

enum CacheDisposition {
    kCacheHit = 1,
    kCacheHitViaReval = 2,
    kCacheMissedViaReval = 3,
    kCacheMissed = 4
};

void
AccumulateCacheHitTelemetry(CacheDisposition hitOrMiss)
{
    if (!CacheObserver::UseNewCache()) {
        Telemetry::Accumulate(Telemetry::HTTP_CACHE_DISPOSITION_2, hitOrMiss);
    }
    else {
        Telemetry::Accumulate(Telemetry::HTTP_CACHE_DISPOSITION_2_V2, hitOrMiss);

        int32_t experiment = CacheObserver::HalfLifeExperiment();
        if (experiment > 0 && hitOrMiss == kCacheMissed) {
            Telemetry::Accumulate(Telemetry::HTTP_CACHE_MISS_HALFLIFE_EXPERIMENT_2,
                                  experiment - 1);
        }
    }
}

// Computes and returns a SHA1 hash of the input buffer. The input buffer
// must be a null-terminated string.
nsresult
Hash(const char *buf, nsACString &hash)
{
    nsresult rv;

    nsCOMPtr<nsICryptoHash> hasher
      = do_CreateInstance(NS_CRYPTO_HASH_CONTRACTID, &rv);
    NS_ENSURE_SUCCESS(rv, rv);

    rv = hasher->Init(nsICryptoHash::SHA1);
    NS_ENSURE_SUCCESS(rv, rv);

    rv = hasher->Update(reinterpret_cast<unsigned const char*>(buf),
                         strlen(buf));
    NS_ENSURE_SUCCESS(rv, rv);

    rv = hasher->Finish(true, hash);
    NS_ENSURE_SUCCESS(rv, rv);

    return NS_OK;
}

} // unnamed namespace

// We only treat 3xx responses as redirects if they have a Location header and
// the status code is in a whitelist.
bool
WillRedirect(nsHttpResponseHead * response)
{
    return nsHttpChannel::IsRedirectStatus(response->Status()) &&
           response->HasHeader(nsHttp::Location);
}

nsresult
StoreAuthorizationMetaData(nsICacheEntry *entry, nsHttpRequestHead *requestHead);

class AutoRedirectVetoNotifier
{
public:
    explicit AutoRedirectVetoNotifier(nsHttpChannel* channel) : mChannel(channel)
    {
      if (mChannel->mHasAutoRedirectVetoNotifier) {
        MOZ_CRASH("Nested AutoRedirectVetoNotifier on the stack");
        mChannel = nullptr;
        return;
      }

      mChannel->mHasAutoRedirectVetoNotifier = true;
    }
    ~AutoRedirectVetoNotifier() {ReportRedirectResult(false);}
    void RedirectSucceeded() {ReportRedirectResult(true);}

private:
    nsHttpChannel* mChannel;
    void ReportRedirectResult(bool succeeded);
};

void
AutoRedirectVetoNotifier::ReportRedirectResult(bool succeeded)
{
    if (!mChannel)
        return;

    mChannel->mRedirectChannel = nullptr;

    nsCOMPtr<nsIRedirectResultListener> vetoHook;
    NS_QueryNotificationCallbacks(mChannel,
                                  NS_GET_IID(nsIRedirectResultListener),
                                  getter_AddRefs(vetoHook));

    nsHttpChannel* channel = mChannel;
    mChannel = nullptr;

    if (vetoHook)
        vetoHook->OnRedirectResult(succeeded);

    // Drop after the notification
    channel->mHasAutoRedirectVetoNotifier = false;
}

//-----------------------------------------------------------------------------
// nsHttpChannel <public>
//-----------------------------------------------------------------------------

nsHttpChannel::nsHttpChannel()
    : HttpAsyncAborter<nsHttpChannel>(this)
    , mLogicalOffset(0)
    , mPostID(0)
    , mRequestTime(0)
    , mOfflineCacheLastModifiedTime(0)
    , mInterceptCache(DO_NOT_INTERCEPT)
    , mInterceptionID(gNumIntercepted++)
    , mCacheOpenWithPriority(false)
    , mCacheQueueSizeWhenOpen(0)
    , mCachedContentIsValid(false)
    , mCachedContentIsPartial(false)
    , mCacheOnlyMetadata(false)
    , mTransactionReplaced(false)
    , mAuthRetryPending(false)
    , mProxyAuthPending(false)
    , mCustomAuthHeader(false)
    , mResuming(false)
    , mInitedCacheEntry(false)
    , mFallbackChannel(false)
    , mCustomConditionalRequest(false)
    , mFallingBack(false)
    , mWaitingForRedirectCallback(false)
    , mRequestTimeInitialized(false)
    , mCacheEntryIsReadOnly(false)
    , mCacheEntryIsWriteOnly(false)
    , mCacheEntriesToWaitFor(0)
    , mHasQueryString(0)
    , mConcurrentCacheAccess(0)
    , mIsPartialRequest(0)
    , mHasAutoRedirectVetoNotifier(0)
    , mPinCacheContent(0)
    , mIsCorsPreflightDone(0)
    , mStronglyFramed(false)
    , mUsedNetwork(0)
    , mPushedStream(nullptr)
    , mLocalBlocklist(false)
    , mWarningReporter(nullptr)
    , mDidReval(false)
{
    LOG(("Creating nsHttpChannel [this=%p]\n", this));
    mChannelCreationTime = PR_Now();
    mChannelCreationTimestamp = TimeStamp::Now();
}

nsHttpChannel::~nsHttpChannel()
{
    LOG(("Destroying nsHttpChannel [this=%p]\n", this));

    if (mAuthProvider)
        mAuthProvider->Disconnect(NS_ERROR_ABORT);
}

nsresult
nsHttpChannel::Init(nsIURI *uri,
                    uint32_t caps,
                    nsProxyInfo *proxyInfo,
                    uint32_t proxyResolveFlags,
                    nsIURI *proxyURI,
                    const nsID& channelId)
{
    nsresult rv = HttpBaseChannel::Init(uri, caps, proxyInfo,
                                        proxyResolveFlags, proxyURI, channelId);
    if (NS_FAILED(rv))
        return rv;

    LOG(("nsHttpChannel::Init [this=%p]\n", this));

    return rv;
}

nsresult
nsHttpChannel::AddSecurityMessage(const nsAString& aMessageTag,
                                  const nsAString& aMessageCategory)
{
    if (mWarningReporter) {
        return mWarningReporter->ReportSecurityMessage(aMessageTag,
                                                       aMessageCategory);
    }
    return HttpBaseChannel::AddSecurityMessage(aMessageTag,
                                               aMessageCategory);
}

//-----------------------------------------------------------------------------
// nsHttpChannel <private>
//-----------------------------------------------------------------------------

nsresult
nsHttpChannel::Connect()
{
    nsresult rv;

    LOG(("nsHttpChannel::Connect [this=%p]\n", this));

    // Note that we are only setting the "Upgrade-Insecure-Requests" request
    // header for *all* navigational requests instead of all requests as
    // defined in the spec, see:
    // https://www.w3.org/TR/upgrade-insecure-requests/#preference
    nsContentPolicyType type = mLoadInfo ?
                               mLoadInfo->GetExternalContentPolicyType() :
                               nsIContentPolicy::TYPE_OTHER;

    if (type == nsIContentPolicy::TYPE_DOCUMENT ||
        type == nsIContentPolicy::TYPE_SUBDOCUMENT) {
        rv = SetRequestHeader(NS_LITERAL_CSTRING("Upgrade-Insecure-Requests"),
                              NS_LITERAL_CSTRING("1"), false);
        NS_ENSURE_SUCCESS(rv, rv);
    }

    bool isHttps = false;
    rv = mURI->SchemeIs("https", &isHttps);
    NS_ENSURE_SUCCESS(rv,rv);
    nsCOMPtr<nsIPrincipal> resultPrincipal;
    if (!isHttps && mLoadInfo) {
        nsContentUtils::GetSecurityManager()->
          GetChannelResultPrincipal(this, getter_AddRefs(resultPrincipal));
    }
    bool shouldUpgrade = false;
    rv = NS_ShouldSecureUpgrade(mURI,
                                mLoadInfo,
                                resultPrincipal,
                                mPrivateBrowsing,
                                mAllowSTS,
                                shouldUpgrade);
    NS_ENSURE_SUCCESS(rv, rv);
    if (shouldUpgrade) {
        return AsyncCall(&nsHttpChannel::HandleAsyncRedirectChannelToHttps);
    }

    // ensure that we are using a valid hostname
    if (!net_IsValidHostName(nsDependentCString(mConnectionInfo->Origin())))
        return NS_ERROR_UNKNOWN_HOST;

    if (mUpgradeProtocolCallback) {
        mCaps |=  NS_HTTP_DISALLOW_SPDY;
    }

    // Finalize ConnectionInfo flags before SpeculativeConnect
    mConnectionInfo->SetAnonymous((mLoadFlags & LOAD_ANONYMOUS) != 0);
    mConnectionInfo->SetPrivate(mPrivateBrowsing);
    mConnectionInfo->SetNoSpdy(mCaps & NS_HTTP_DISALLOW_SPDY);
    mConnectionInfo->SetBeConservative((mCaps & NS_HTTP_BE_CONSERVATIVE) || mBeConservative);

    // Consider opening a TCP connection right away.
    SpeculativeConnect();

    // Don't allow resuming when cache must be used
    if (mResuming && (mLoadFlags & LOAD_ONLY_FROM_CACHE)) {
        LOG(("Resuming from cache is not supported yet"));
        return NS_ERROR_DOCUMENT_NOT_CACHED;
    }

    // open a cache entry for this channel...
    rv = OpenCacheEntry(isHttps);

    // do not continue if asyncOpenCacheEntry is in progress
    if (AwaitingCacheCallbacks()) {
        LOG(("nsHttpChannel::Connect %p AwaitingCacheCallbacks forces async\n", this));
        MOZ_ASSERT(NS_SUCCEEDED(rv), "Unexpected state");
        return NS_OK;
    }

    if (NS_FAILED(rv)) {
        LOG(("OpenCacheEntry failed [rv=%x]\n", rv));
        // if this channel is only allowed to pull from the cache, then
        // we must fail if we were unable to open a cache entry.
        if (mLoadFlags & LOAD_ONLY_FROM_CACHE) {
            // If we have a fallback URI (and we're not already
            // falling back), process the fallback asynchronously.
            if (!mFallbackChannel && !mFallbackKey.IsEmpty()) {
                return AsyncCall(&nsHttpChannel::HandleAsyncFallback);
            }
            return NS_ERROR_DOCUMENT_NOT_CACHED;
        }
        // otherwise, let's just proceed without using the cache.
    }

    return TryHSTSPriming();
}

nsresult
nsHttpChannel::TryHSTSPriming()
{
    if (mLoadInfo) {
        // HSTS priming requires the LoadInfo provided with AsyncOpen2
        bool requireHSTSPriming =
            mLoadInfo->GetForceHSTSPriming();

        if (requireHSTSPriming &&
                nsMixedContentBlocker::sSendHSTSPriming &&
                mInterceptCache == DO_NOT_INTERCEPT) {
            bool isHttpsScheme;
            nsresult rv = mURI->SchemeIs("https", &isHttpsScheme);
            NS_ENSURE_SUCCESS(rv, rv);
            if (!isHttpsScheme) {
                rv = HSTSPrimingListener::StartHSTSPriming(this, this);

                if (NS_FAILED(rv)) {
                    CloseCacheEntry(false);
                    return rv;
                }

                return NS_OK;
            }

            // The request was already upgraded, for example by
            // upgrade-insecure-requests or a prior successful priming request
            Telemetry::Accumulate(Telemetry::MIXED_CONTENT_HSTS_PRIMING_RESULT,
                    HSTSPrimingResult::eHSTS_PRIMING_ALREADY_UPGRADED);
            mLoadInfo->ClearHSTSPriming();
        }
    }

    return ContinueConnect();
}

nsresult
nsHttpChannel::ContinueConnect()
{
    // If we have had HSTS priming, we need to reevaluate whether we need
    // a CORS preflight. Bug: 1272440
    // If we need to start a CORS preflight, do it now!
    // Note that it is important to do this before the early returns below.
    if (!mIsCorsPreflightDone && mRequireCORSPreflight &&
        mInterceptCache != INTERCEPTED) {
        MOZ_ASSERT(!mPreflightChannel);
        nsresult rv =
            nsCORSListenerProxy::StartCORSPreflight(this, this,
                                                    mUnsafeHeaders,
                                                    getter_AddRefs(mPreflightChannel));
        return rv;
    }

    MOZ_RELEASE_ASSERT(!(mRequireCORSPreflight &&
                         mInterceptCache != INTERCEPTED) ||
                       mIsCorsPreflightDone,
                       "CORS preflight must have been finished by the time we "
                       "do the rest of ContinueConnect");

    // we may or may not have a cache entry at this point
    if (mCacheEntry) {
        // read straight from the cache if possible...
        if (mCachedContentIsValid) {
            nsRunnableMethod<nsHttpChannel> *event = nullptr;
            if (!mCachedContentIsPartial) {
                AsyncCall(&nsHttpChannel::AsyncOnExamineCachedResponse, &event);
            }
            nsresult rv = ReadFromCache(true);
            if (NS_FAILED(rv) && event) {
                event->Revoke();
            }

            // Don't accumulate the cache hit telemetry for intercepted channels.
            if (mInterceptCache != INTERCEPTED) {
                AccumulateCacheHitTelemetry(kCacheHit);
            }

            return rv;
        }
        else if (mLoadFlags & LOAD_ONLY_FROM_CACHE) {
            // the cache contains the requested resource, but it must be
            // validated before we can reuse it.  since we are not allowed
            // to hit the net, there's nothing more to do.  the document
            // is effectively not in the cache.
            LOG(("  !mCachedContentIsValid && mLoadFlags & LOAD_ONLY_FROM_CACHE"));
            return NS_ERROR_DOCUMENT_NOT_CACHED;
        }
    }
    else if (mLoadFlags & LOAD_ONLY_FROM_CACHE) {
        // If we have a fallback URI (and we're not already
        // falling back), process the fallback asynchronously.
        if (!mFallbackChannel && !mFallbackKey.IsEmpty()) {
            return AsyncCall(&nsHttpChannel::HandleAsyncFallback);
        }
        LOG(("  !mCacheEntry && mLoadFlags & LOAD_ONLY_FROM_CACHE"));
        return NS_ERROR_DOCUMENT_NOT_CACHED;
    }

    if (mLoadFlags & LOAD_NO_NETWORK_IO) {
        LOG(("  mLoadFlags & LOAD_NO_NETWORK_IO"));
        return NS_ERROR_DOCUMENT_NOT_CACHED;
    }

    // hit the net...
    nsresult rv = SetupTransaction();
    if (NS_FAILED(rv)) return rv;

    rv = gHttpHandler->InitiateTransaction(mTransaction, mPriority);
    if (NS_FAILED(rv)) return rv;

    rv = mTransactionPump->AsyncRead(this, nullptr);
    if (NS_FAILED(rv)) return rv;

    uint32_t suspendCount = mSuspendCount;
    while (suspendCount--)
        mTransactionPump->Suspend();

    return NS_OK;
}

void
nsHttpChannel::SpeculativeConnect()
{
    // Before we take the latency hit of dealing with the cache, try and
    // get the TCP (and SSL) handshakes going so they can overlap.

    // don't speculate if we are on a local blocklist, on uses of the offline
    // application cache, if we are offline, when doing http upgrade (i.e.
    // websockets bootstrap), or if we can't do keep-alive (because then we
    // couldn't reuse the speculative connection anyhow).
    if (mLocalBlocklist || mApplicationCache || gIOService->IsOffline() ||
        mUpgradeProtocolCallback || !(mCaps & NS_HTTP_ALLOW_KEEPALIVE))
        return;

    // LOAD_ONLY_FROM_CACHE and LOAD_NO_NETWORK_IO must not hit network.
    // LOAD_FROM_CACHE and LOAD_CHECK_OFFLINE_CACHE are unlikely to hit network,
    // so skip preconnects for them.
    if (mLoadFlags & (LOAD_ONLY_FROM_CACHE | LOAD_FROM_CACHE |
                      LOAD_NO_NETWORK_IO | LOAD_CHECK_OFFLINE_CACHE))
        return;

    if (mAllowStaleCacheContent) {
        return;
    }

    nsCOMPtr<nsIInterfaceRequestor> callbacks;
    NS_NewNotificationCallbacksAggregation(mCallbacks, mLoadGroup,
                                           getter_AddRefs(callbacks));
    if (!callbacks)
        return;

    gHttpHandler->SpeculativeConnect(
        mConnectionInfo, callbacks, mCaps & NS_HTTP_DISALLOW_SPDY);
}

void
nsHttpChannel::DoNotifyListenerCleanup()
{
    // We don't need this info anymore
    CleanRedirectCacheChainIfNecessary();
}

void
nsHttpChannel::HandleAsyncRedirect()
{
    NS_PRECONDITION(!mCallOnResume, "How did that happen?");

    if (mSuspendCount) {
        LOG(("Waiting until resume to do async redirect [this=%p]\n", this));
        mCallOnResume = &nsHttpChannel::HandleAsyncRedirect;
        return;
    }

    nsresult rv = NS_OK;

    LOG(("nsHttpChannel::HandleAsyncRedirect [this=%p]\n", this));

    // since this event is handled asynchronously, it is possible that this
    // channel could have been canceled, in which case there would be no point
    // in processing the redirect.
    if (NS_SUCCEEDED(mStatus)) {
        PushRedirectAsyncFunc(&nsHttpChannel::ContinueHandleAsyncRedirect);
        rv = AsyncProcessRedirection(mResponseHead->Status());
        if (NS_FAILED(rv)) {
            PopRedirectAsyncFunc(&nsHttpChannel::ContinueHandleAsyncRedirect);
            // TODO: if !DoNotRender3xxBody(), render redirect body instead.
            // But first we need to cache 3xx bodies (bug 748510)
            ContinueHandleAsyncRedirect(rv);
        }
    }
    else {
        ContinueHandleAsyncRedirect(mStatus);
    }
}

nsresult
nsHttpChannel::ContinueHandleAsyncRedirect(nsresult rv)
{
    if (NS_FAILED(rv)) {
        // If AsyncProcessRedirection fails, then we have to send out the
        // OnStart/OnStop notifications.
        LOG(("ContinueHandleAsyncRedirect got failure result [rv=%x]\n", rv));

        bool redirectsEnabled =
            !mLoadInfo || !mLoadInfo->GetDontFollowRedirects();

        if (redirectsEnabled) {
            // TODO: stop failing original channel if redirect vetoed?
            mStatus = rv;

            DoNotifyListener();

            // Blow away cache entry if we couldn't process the redirect
            // for some reason (the cache entry might be corrupt).
            if (mCacheEntry) {
                mCacheEntry->AsyncDoom(nullptr);
            }
        }
        else {
            DoNotifyListener();
        }
    }

    CloseCacheEntry(true);

    mIsPending = false;

    if (mLoadGroup)
        mLoadGroup->RemoveRequest(this, nullptr, mStatus);

    return NS_OK;
}

void
nsHttpChannel::HandleAsyncNotModified()
{
    NS_PRECONDITION(!mCallOnResume, "How did that happen?");

    if (mSuspendCount) {
        LOG(("Waiting until resume to do async not-modified [this=%p]\n",
             this));
        mCallOnResume = &nsHttpChannel::HandleAsyncNotModified;
        return;
    }

    LOG(("nsHttpChannel::HandleAsyncNotModified [this=%p]\n", this));

    DoNotifyListener();

    CloseCacheEntry(false);

    mIsPending = false;

    if (mLoadGroup)
        mLoadGroup->RemoveRequest(this, nullptr, mStatus);
}

void
nsHttpChannel::HandleAsyncFallback()
{
    NS_PRECONDITION(!mCallOnResume, "How did that happen?");

    if (mSuspendCount) {
        LOG(("Waiting until resume to do async fallback [this=%p]\n", this));
        mCallOnResume = &nsHttpChannel::HandleAsyncFallback;
        return;
    }

    nsresult rv = NS_OK;

    LOG(("nsHttpChannel::HandleAsyncFallback [this=%p]\n", this));

    // since this event is handled asynchronously, it is possible that this
    // channel could have been canceled, in which case there would be no point
    // in processing the fallback.
    if (!mCanceled) {
        PushRedirectAsyncFunc(&nsHttpChannel::ContinueHandleAsyncFallback);
        bool waitingForRedirectCallback;
        rv = ProcessFallback(&waitingForRedirectCallback);
        if (waitingForRedirectCallback)
            return;
        PopRedirectAsyncFunc(&nsHttpChannel::ContinueHandleAsyncFallback);
    }

    ContinueHandleAsyncFallback(rv);
}

nsresult
nsHttpChannel::ContinueHandleAsyncFallback(nsresult rv)
{
    if (!mCanceled && (NS_FAILED(rv) || !mFallingBack)) {
        // If ProcessFallback fails, then we have to send out the
        // OnStart/OnStop notifications.
        LOG(("ProcessFallback failed [rv=%x, %d]\n", rv, mFallingBack));
        mStatus = NS_FAILED(rv) ? rv : NS_ERROR_DOCUMENT_NOT_CACHED;
        DoNotifyListener();
    }

    mIsPending = false;

    if (mLoadGroup)
        mLoadGroup->RemoveRequest(this, nullptr, mStatus);

    return rv;
}

void
nsHttpChannel::SetupTransactionRequestContext()
{
    if (!EnsureRequestContextID()) {
        return;
    }

    nsIRequestContextService *rcsvc =
        gHttpHandler->GetRequestContextService();
    if (!rcsvc) {
        return;
    }

    nsCOMPtr<nsIRequestContext> rc;
    nsresult rv = rcsvc->GetRequestContext(mRequestContextID,
                                           getter_AddRefs(rc));

    if (NS_FAILED(rv)) {
        return;
    }

    mTransaction->SetRequestContext(rc);
}

static bool
SafeForPipelining(nsHttpRequestHead::ParsedMethodType method,
                  const nsCString &methodString)
{
    if (method == nsHttpRequestHead::kMethod_Get ||
        method == nsHttpRequestHead::kMethod_Head ||
        method == nsHttpRequestHead::kMethod_Options) {
        return true;
    }

    if (method != nsHttpRequestHead::kMethod_Custom) {
        return false;
    }

    return (!strcmp(methodString.get(), "PROPFIND") ||
            !strcmp(methodString.get(), "PROPPATCH"));
}

nsresult
nsHttpChannel::SetupTransaction()
{
    LOG(("nsHttpChannel::SetupTransaction [this=%p]\n", this));

    NS_ENSURE_TRUE(!mTransaction, NS_ERROR_ALREADY_INITIALIZED);

    nsresult rv;

    mUsedNetwork = 1;
    if (mCaps & NS_HTTP_ALLOW_PIPELINING) {
        //
        // disable pipelining if:
        //   (1) pipelining has been disabled by config
        //   (2) pipelining has been disabled by connection mgr info
        //   (3) request corresponds to a top-level document load (link click)
        //   (4) request method is non-idempotent
        //   (5) request is marked slow (e.g XHR)
        //
        nsAutoCString method;
        mRequestHead.Method(method);
        if (!mAllowPipelining ||
           (mLoadFlags & (LOAD_INITIAL_DOCUMENT_URI | INHIBIT_PIPELINE)) ||
            !SafeForPipelining(mRequestHead.ParsedMethod(), method)) {
            LOG(("  pipelining disallowed\n"));
            mCaps &= ~NS_HTTP_ALLOW_PIPELINING;
        }
    }

    if (!mAllowSpdy) {
        mCaps |= NS_HTTP_DISALLOW_SPDY;
    }
    if (mBeConservative) {
        mCaps |= NS_HTTP_BE_CONSERVATIVE;
    }

    // Use the URI path if not proxying (transparent proxying such as proxy
    // CONNECT does not count here). Also figure out what HTTP version to use.
    nsAutoCString buf, path;
    nsCString* requestURI;

    // This is the normal e2e H1 path syntax "/index.html"
    rv = mURI->GetPath(path);
    if (NS_FAILED(rv)) {
        return rv;
    }

    // path may contain UTF-8 characters, so ensure that they're escaped.
    if (NS_EscapeURL(path.get(), path.Length(), esc_OnlyNonASCII, buf)) {
        requestURI = &buf;
    } else {
        requestURI = &path;
    }

    // trim off the #ref portion if any...
    int32_t ref1 = requestURI->FindChar('#');
    if (ref1 != kNotFound) {
        requestURI->SetLength(ref1);
    }

    if (mConnectionInfo->UsingConnect() || !mConnectionInfo->UsingHttpProxy()) {
        mRequestHead.SetVersion(gHttpHandler->HttpVersion());
    }
    else {
        mRequestHead.SetPath(*requestURI);

        // RequestURI should be the absolute uri H1 proxy syntax "http://foo/index.html"
        // so we will overwrite the relative version in requestURI
        rv = mURI->GetUserPass(buf);
        if (NS_FAILED(rv)) return rv;
        if (!buf.IsEmpty() && ((strncmp(mSpec.get(), "http:", 5) == 0) ||
                                strncmp(mSpec.get(), "https:", 6) == 0)) {
            nsCOMPtr<nsIURI> tempURI;
            rv = mURI->Clone(getter_AddRefs(tempURI));
            if (NS_FAILED(rv)) return rv;
            rv = tempURI->SetUserPass(EmptyCString());
            if (NS_FAILED(rv)) return rv;
            rv = tempURI->GetAsciiSpec(path);
            if (NS_FAILED(rv)) return rv;
            requestURI = &path;
        } else {
            requestURI = &mSpec;
        }

        // trim off the #ref portion if any...
        int32_t ref2 = requestURI->FindChar('#');
        if (ref2 != kNotFound) {
            requestURI->SetLength(ref2);
        }

        mRequestHead.SetVersion(gHttpHandler->ProxyHttpVersion());
    }

    mRequestHead.SetRequestURI(*requestURI);

    // set the request time for cache expiration calculations
    mRequestTime = NowInSeconds();
    mRequestTimeInitialized = true;

    // if doing a reload, force end-to-end
    if (mLoadFlags & LOAD_BYPASS_CACHE) {
        // We need to send 'Pragma:no-cache' to inhibit proxy caching even if
        // no proxy is configured since we might be talking with a transparent
        // proxy, i.e. one that operates at the network level.  See bug #14772.
        mRequestHead.SetHeaderOnce(nsHttp::Pragma, "no-cache", true);
        // If we're configured to speak HTTP/1.1 then also send 'Cache-control:
        // no-cache'
        if (mRequestHead.Version() >= NS_HTTP_VERSION_1_1)
            mRequestHead.SetHeaderOnce(nsHttp::Cache_Control, "no-cache", true);
    }
    else if ((mLoadFlags & VALIDATE_ALWAYS) && !mCacheEntryIsWriteOnly) {
        // We need to send 'Cache-Control: max-age=0' to force each cache along
        // the path to the origin server to revalidate its own entry, if any,
        // with the next cache or server.  See bug #84847.
        //
        // If we're configured to speak HTTP/1.0 then just send 'Pragma: no-cache'
        if (mRequestHead.Version() >= NS_HTTP_VERSION_1_1)
            mRequestHead.SetHeaderOnce(nsHttp::Cache_Control, "max-age=0", true);
        else
            mRequestHead.SetHeaderOnce(nsHttp::Pragma, "no-cache", true);
    }

    if (mResuming) {
        char byteRange[32];
        SprintfLiteral(byteRange, "bytes=%" PRIu64 "-", mStartPos);
        mRequestHead.SetHeader(nsHttp::Range, nsDependentCString(byteRange));

        if (!mEntityID.IsEmpty()) {
            // Also, we want an error if this resource changed in the meantime
            // Format of the entity id is: escaped_etag/size/lastmod
            nsCString::const_iterator start, end, slash;
            mEntityID.BeginReading(start);
            mEntityID.EndReading(end);
            mEntityID.BeginReading(slash);

            if (FindCharInReadable('/', slash, end)) {
                nsAutoCString ifMatch;
                mRequestHead.SetHeader(nsHttp::If_Match,
                        NS_UnescapeURL(Substring(start, slash), 0, ifMatch));

                ++slash; // Incrementing, so that searching for '/' won't find
                         // the same slash again
            }

            if (FindCharInReadable('/', slash, end)) {
                mRequestHead.SetHeader(nsHttp::If_Unmodified_Since,
                        Substring(++slash, end));
            }
        }
    }

    // create wrapper for this channel's notification callbacks
    nsCOMPtr<nsIInterfaceRequestor> callbacks;
    NS_NewNotificationCallbacksAggregation(mCallbacks, mLoadGroup,
                                           getter_AddRefs(callbacks));

    // create the transaction object
    mTransaction = new nsHttpTransaction();
    LOG(("nsHttpChannel %p created nsHttpTransaction %p\n", this, mTransaction.get()));
    mTransaction->SetTransactionObserver(mTransactionObserver);
    mTransactionObserver = nullptr;

    // See bug #466080. Transfer LOAD_ANONYMOUS flag to socket-layer.
    if (mLoadFlags & LOAD_ANONYMOUS)
        mCaps |= NS_HTTP_LOAD_ANONYMOUS;

    if (mTimingEnabled)
        mCaps |= NS_HTTP_TIMING_ENABLED;

    if (mUpgradeProtocolCallback) {
        mRequestHead.SetHeader(nsHttp::Upgrade, mUpgradeProtocol, false);
        mRequestHead.SetHeaderOnce(nsHttp::Connection,
                                   nsHttp::Upgrade.get(),
                                   true);
        mCaps |=  NS_HTTP_STICKY_CONNECTION;
        mCaps &= ~NS_HTTP_ALLOW_PIPELINING;
        mCaps &= ~NS_HTTP_ALLOW_KEEPALIVE;
    }

    if (mPushedStream) {
        mTransaction->SetPushedStream(mPushedStream);
        mPushedStream = nullptr;
    }

    nsCOMPtr<nsIHttpPushListener> pushListener;
    NS_QueryNotificationCallbacks(mCallbacks,
                                  mLoadGroup,
                                  NS_GET_IID(nsIHttpPushListener),
                                  getter_AddRefs(pushListener));
    if (pushListener) {
        mCaps |= NS_HTTP_ONPUSH_LISTENER;
    }

    nsCOMPtr<nsIAsyncInputStream> responseStream;
    rv = mTransaction->Init(mCaps, mConnectionInfo, &mRequestHead,
                            mUploadStream, mUploadStreamHasHeaders,
                            NS_GetCurrentThread(), callbacks, this,
                            getter_AddRefs(responseStream));
    if (NS_FAILED(rv)) {
        mTransaction = nullptr;
        return rv;
    }

    mTransaction->SetClassOfService(mClassOfService);
    SetupTransactionRequestContext();

    rv = nsInputStreamPump::Create(getter_AddRefs(mTransactionPump),
                                   responseStream);
    return rv;
}

// NOTE: This function duplicates code from nsBaseChannel. This will go away
// once HTTP uses nsBaseChannel (part of bug 312760)
static void
CallTypeSniffers(void *aClosure, const uint8_t *aData, uint32_t aCount)
{
  nsIChannel *chan = static_cast<nsIChannel*>(aClosure);

  nsAutoCString newType;
  NS_SniffContent(NS_CONTENT_SNIFFER_CATEGORY, chan, aData, aCount, newType);
  if (!newType.IsEmpty()) {
    chan->SetContentType(newType);
  }
}

// Helper Function to report messages to the console when loading
// a resource was blocked due to a MIME type mismatch.
void
ReportTypeBlocking(nsIURI* aURI,
                   nsILoadInfo* aLoadInfo,
                   const char* aMessageName)
{
    NS_ConvertUTF8toUTF16 specUTF16(aURI->GetSpecOrDefault());
    const char16_t* params[] = { specUTF16.get() };
    nsCOMPtr<nsIDocument> doc;
    if (aLoadInfo) {
        nsCOMPtr<nsIDOMDocument> domDoc;
        aLoadInfo->GetLoadingDocument(getter_AddRefs(domDoc));
        if (domDoc) {
            doc = do_QueryInterface(domDoc);
        }
    }
    nsContentUtils::ReportToConsole(nsIScriptError::errorFlag,
                                    NS_LITERAL_CSTRING("MIMEMISMATCH"),
                                    doc,
                                    nsContentUtils::eSECURITY_PROPERTIES,
                                    aMessageName,
                                    params, ArrayLength(params));
}

// Check and potentially enforce X-Content-Type-Options: nosniff
nsresult
ProcessXCTO(nsIURI* aURI, nsHttpResponseHead* aResponseHead, nsILoadInfo* aLoadInfo)
{
    if (!aURI || !aResponseHead || !aLoadInfo) {
        // if there is no uri, no response head or no loadInfo, then there is nothing to do
        return NS_OK;
    }

    // 1) Query the XCTO header and check if 'nosniff' is the first value.
    nsAutoCString contentTypeOptionsHeader;
    aResponseHead->GetHeader(nsHttp::X_Content_Type_Options, contentTypeOptionsHeader);
    if (contentTypeOptionsHeader.IsEmpty()) {
        // if there is no XCTO header, then there is nothing to do.
        return NS_OK;
    }
    // XCTO header might contain multiple values which are comma separated, so:
    // a) let's skip all subsequent values
    //     e.g. "   NoSniFF   , foo " will be "   NoSniFF   "
    int32_t idx = contentTypeOptionsHeader.Find(",");
    if (idx > 0) {
      contentTypeOptionsHeader = Substring(contentTypeOptionsHeader, 0, idx);
    }
    // b) let's trim all surrounding whitespace
    //    e.g. "   NoSniFF   " -> "NoSniFF"
    contentTypeOptionsHeader.StripWhitespace();
    // c) let's compare the header (ignoring case)
    //    e.g. "NoSniFF" -> "nosniff"
    //    if it's not 'nosniff' then there is nothing to do here
    if (!contentTypeOptionsHeader.EqualsIgnoreCase("nosniff")) {
        // since we are getting here, the XCTO header was sent;
        // a non matching value most likely means a mistake happenend;
        // e.g. sending 'nosnif' instead of 'nosniff', let's log a warning.
        NS_ConvertUTF8toUTF16 char16_header(contentTypeOptionsHeader);
        const char16_t* params[] = { char16_header.get() };
        nsCOMPtr<nsIDocument> doc;
        nsCOMPtr<nsIDOMDocument> domDoc;
        aLoadInfo->GetLoadingDocument(getter_AddRefs(domDoc));
        if (domDoc) {
          doc = do_QueryInterface(domDoc);
        }
        nsContentUtils::ReportToConsole(nsIScriptError::warningFlag,
                                        NS_LITERAL_CSTRING("XCTO"),
                                        doc,
                                        nsContentUtils::eSECURITY_PROPERTIES,
                                        "XCTOHeaderValueMissing",
                                        params, ArrayLength(params));
        return NS_OK;
    }

    // 2) Query the content type from the channel
    nsAutoCString contentType;
    aResponseHead->ContentType(contentType);

    // 3) Compare the expected MIME type with the actual type
    if (aLoadInfo->GetExternalContentPolicyType() == nsIContentPolicy::TYPE_STYLESHEET) {
        if (contentType.EqualsLiteral(TEXT_CSS)) {
            return NS_OK;
        }
        ReportTypeBlocking(aURI, aLoadInfo, "MimeTypeMismatch");
        return NS_ERROR_CORRUPTED_CONTENT;
    }

    if (aLoadInfo->GetExternalContentPolicyType() == nsIContentPolicy::TYPE_IMAGE) {
        if (StringBeginsWith(contentType, NS_LITERAL_CSTRING("image/"))) {
            Accumulate(Telemetry::XCTO_NOSNIFF_BLOCK_IMAGE, 0);
            return NS_OK;
        }
        Accumulate(Telemetry::XCTO_NOSNIFF_BLOCK_IMAGE, 1);
        // Instead of consulting Preferences::GetBool() all the time we
        // can cache the result to speed things up.
        static bool sXCTONosniffBlockImages = false;
        static bool sIsInited = false;
        if (!sIsInited) {
            sIsInited = true;
            Preferences::AddBoolVarCache(&sXCTONosniffBlockImages,
            "security.xcto_nosniff_block_images");
        }
        if (!sXCTONosniffBlockImages) {
            return NS_OK;
        }
        ReportTypeBlocking(aURI, aLoadInfo, "MimeTypeMismatch");
        return NS_ERROR_CORRUPTED_CONTENT;
    }

    if (aLoadInfo->GetExternalContentPolicyType() == nsIContentPolicy::TYPE_SCRIPT) {
        if (nsContentUtils::IsScriptType(contentType)) {
            return NS_OK;
        }
        ReportTypeBlocking(aURI, aLoadInfo, "MimeTypeMismatch");
        return NS_ERROR_CORRUPTED_CONTENT;
    }
    return NS_OK;
}

// Ensure that a load of type script has correct MIME type
nsresult
EnsureMIMEOfScript(nsIURI* aURI, nsHttpResponseHead* aResponseHead, nsILoadInfo* aLoadInfo)
{
    if (!aURI || !aResponseHead || !aLoadInfo) {
        // if there is no uri, no response head or no loadInfo, then there is nothing to do
        return NS_OK;
    }

    if (aLoadInfo->GetExternalContentPolicyType() != nsIContentPolicy::TYPE_SCRIPT) {
        // if this is not a script load, then there is nothing to do
        return NS_OK;
    }

    nsAutoCString contentType;
    aResponseHead->ContentType(contentType);
    NS_ConvertUTF8toUTF16 typeString(contentType);

    if (nsContentUtils::IsJavascriptMIMEType(typeString)) {
        // script load has type script
        Telemetry::Accumulate(Telemetry::SCRIPT_BLOCK_INCORRECT_MIME, 1);
        return NS_OK;
    }

    bool block = false;
    if (StringBeginsWith(contentType, NS_LITERAL_CSTRING("image/"))) {
        // script load has type image
        Telemetry::Accumulate(Telemetry::SCRIPT_BLOCK_INCORRECT_MIME, 2);
        block = true;
    } else if (StringBeginsWith(contentType, NS_LITERAL_CSTRING("audio/"))) {
        // script load has type audio
        Telemetry::Accumulate(Telemetry::SCRIPT_BLOCK_INCORRECT_MIME, 3);
        block = true;
    } else if (StringBeginsWith(contentType, NS_LITERAL_CSTRING("video/"))) {
        // script load has type video
        Telemetry::Accumulate(Telemetry::SCRIPT_BLOCK_INCORRECT_MIME, 4);
        block = true;
    } else if (StringBeginsWith(contentType, NS_LITERAL_CSTRING("text/csv"))) {
        // script load has type text/csv
        Telemetry::Accumulate(Telemetry::SCRIPT_BLOCK_INCORRECT_MIME, 6);
        block = true;
    }

    if (block) {
        // Instead of consulting Preferences::GetBool() all the time we
        // can cache the result to speed things up.
        static bool sCachedBlockScriptWithWrongMime = false;
        static bool sIsInited = false;
        if (!sIsInited) {
            sIsInited = true;
            Preferences::AddBoolVarCache(&sCachedBlockScriptWithWrongMime,
            "security.block_script_with_wrong_mime");
        }

        // Do not block the load if the feature is not enabled.
        if (!sCachedBlockScriptWithWrongMime) {
            return NS_OK;
        }

        ReportTypeBlocking(aURI, aLoadInfo, "BlockScriptWithWrongMimeType");
        return NS_ERROR_CORRUPTED_CONTENT;
    }

    if (StringBeginsWith(contentType, NS_LITERAL_CSTRING("text/plain"))) {
        // script load has type text/plain
        Telemetry::Accumulate(Telemetry::SCRIPT_BLOCK_INCORRECT_MIME, 5);
        return NS_OK;
    }

    if (StringBeginsWith(contentType, NS_LITERAL_CSTRING("text/xml"))) {
        // script load has type text/xml
        Telemetry::Accumulate(Telemetry::SCRIPT_BLOCK_INCORRECT_MIME, 7);
        return NS_OK;
    }

    if (StringBeginsWith(contentType, NS_LITERAL_CSTRING("application/octet-stream"))) {
        // script load has type application/octet-stream
        Telemetry::Accumulate(Telemetry::SCRIPT_BLOCK_INCORRECT_MIME, 8);
        return NS_OK;
    }

    if (StringBeginsWith(contentType, NS_LITERAL_CSTRING("application/xml"))) {
        // script load has type application/xml
        Telemetry::Accumulate(Telemetry::SCRIPT_BLOCK_INCORRECT_MIME, 9);
        return NS_OK;
    }

    if (StringBeginsWith(contentType, NS_LITERAL_CSTRING("text/html"))) {
        // script load has type text/html
        Telemetry::Accumulate(Telemetry::SCRIPT_BLOCK_INCORRECT_MIME, 10);
        return NS_OK;
    }

    if (contentType.IsEmpty()) {
        // script load has no type
        Telemetry::Accumulate(Telemetry::SCRIPT_BLOCK_INCORRECT_MIME, 11);
        return NS_OK;
    }

    // script load has unknown type
    Telemetry::Accumulate(Telemetry::SCRIPT_BLOCK_INCORRECT_MIME, 0);
    return NS_OK;
}


nsresult
nsHttpChannel::CallOnStartRequest()
{
    MOZ_RELEASE_ASSERT(!(mRequireCORSPreflight &&
                         mInterceptCache != INTERCEPTED) ||
                       mIsCorsPreflightDone,
                       "CORS preflight must have been finished by the time we "
                       "call OnStartRequest");

    nsresult rv = EnsureMIMEOfScript(mURI, mResponseHead, mLoadInfo);
    NS_ENSURE_SUCCESS(rv, rv);

    rv = ProcessXCTO(mURI, mResponseHead, mLoadInfo);
    NS_ENSURE_SUCCESS(rv, rv);

    if (mOnStartRequestCalled) {
        // This can only happen when a range request loading rest of the data
        // after interrupted concurrent cache read asynchronously failed, e.g.
        // the response range bytes are not as expected or this channel has
        // been externally canceled.
        //
        // It's legal to bypass CallOnStartRequest for that case since we've
        // already called OnStartRequest on our listener and also added all
        // content converters before.
        MOZ_ASSERT(mConcurrentCacheAccess);
        LOG(("CallOnStartRequest already invoked before"));
        return mStatus;
    }

    mTracingEnabled = false;

    // Allow consumers to override our content type
    if (mLoadFlags & LOAD_CALL_CONTENT_SNIFFERS) {
        // NOTE: We can have both a txn pump and a cache pump when the cache
        // content is partial. In that case, we need to read from the cache,
        // because that's the one that has the initial contents. If that fails
        // then give the transaction pump a shot.

        nsIChannel* thisChannel = static_cast<nsIChannel*>(this);

        bool typeSniffersCalled = false;
        if (mCachePump) {
          typeSniffersCalled =
            NS_SUCCEEDED(mCachePump->PeekStream(CallTypeSniffers, thisChannel));
        }

        if (!typeSniffersCalled && mTransactionPump) {
          mTransactionPump->PeekStream(CallTypeSniffers, thisChannel);
        }
    }

    bool unknownDecoderStarted = false;
    if (mResponseHead && !mResponseHead->HasContentType()) {
        MOZ_ASSERT(mConnectionInfo, "Should have connection info here");
        if (!mContentTypeHint.IsEmpty())
            mResponseHead->SetContentType(mContentTypeHint);
        else if (mResponseHead->Version() == NS_HTTP_VERSION_0_9 &&
                 mConnectionInfo->OriginPort() != mConnectionInfo->DefaultPort())
            mResponseHead->SetContentType(NS_LITERAL_CSTRING(TEXT_PLAIN));
        else {
            // Uh-oh.  We had better find out what type we are!
            nsCOMPtr<nsIStreamConverterService> serv;
            rv = gHttpHandler->
                GetStreamConverterService(getter_AddRefs(serv));
            // If we failed, we just fall through to the "normal" case
            if (NS_SUCCEEDED(rv)) {
                nsCOMPtr<nsIStreamListener> converter;
                rv = serv->AsyncConvertData(UNKNOWN_CONTENT_TYPE,
                                            "*/*",
                                            mListener,
                                            mListenerContext,
                                            getter_AddRefs(converter));
                if (NS_SUCCEEDED(rv)) {
                    mListener = converter;
                    unknownDecoderStarted = true;
                }
            }
        }
    }

    if (mResponseHead && !mResponseHead->HasContentCharset())
        mResponseHead->SetContentCharset(mContentCharsetHint);

    if (mResponseHead && mCacheEntry) {
        // If we have a cache entry, set its predicted size to TotalEntitySize to
        // avoid caching an entry that will exceed the max size limit.
        rv = mCacheEntry->SetPredictedDataSize(
            mResponseHead->TotalEntitySize());
        if (NS_ERROR_FILE_TOO_BIG == rv) {
          // Don't throw the entry away, we will need it later.
          LOG(("  entry too big"));
        } else {
          NS_ENSURE_SUCCESS(rv, rv);
        }
    }

    LOG(("  calling mListener->OnStartRequest\n"));
    if (mListener) {
        MOZ_ASSERT(!mOnStartRequestCalled,
                   "We should not call OsStartRequest twice");
        nsCOMPtr<nsIStreamListener> deleteProtector(mListener);
        rv = deleteProtector->OnStartRequest(this, mListenerContext);
        mOnStartRequestCalled = true;
        if (NS_FAILED(rv))
            return rv;
    } else {
        NS_WARNING("OnStartRequest skipped because of null listener");
        mOnStartRequestCalled = true;
    }

    // Install stream converter if required.
    // If we use unknownDecoder, stream converters will be installed later (in
    // nsUnknownDecoder) after OnStartRequest is called for the real listener.
    if (!unknownDecoderStarted) {
      nsCOMPtr<nsIStreamListener> listener;
      nsISupports *ctxt = mListenerContext;
      rv = DoApplyContentConversions(mListener, getter_AddRefs(listener), ctxt);
      if (NS_FAILED(rv)) {
        return rv;
      }
      if (listener) {
        mListener = listener;
        mCompressListener = listener;
      }
    }

    rv = EnsureAssocReq();
    if (NS_FAILED(rv))
        return rv;

    // if this channel is for a download, close off access to the cache.
    if (mCacheEntry && mChannelIsForDownload) {
        mCacheEntry->AsyncDoom(nullptr);

        // We must keep the cache entry in case of partial request.
        // Concurrent access is the same, we need the entry in
        // OnStopRequest.
        if (!mCachedContentIsPartial && !mConcurrentCacheAccess)
            CloseCacheEntry(false);
    }

    if (!mCanceled) {
        // create offline cache entry if offline caching was requested
        if (ShouldUpdateOfflineCacheEntry()) {
            LOG(("writing to the offline cache"));
            rv = InitOfflineCacheEntry();
            if (NS_FAILED(rv)) return rv;

            // InitOfflineCacheEntry may have closed mOfflineCacheEntry
            if (mOfflineCacheEntry) {
                rv = InstallOfflineCacheListener();
                if (NS_FAILED(rv)) return rv;
            }
        } else if (mApplicationCacheForWrite) {
            LOG(("offline cache is up to date, not updating"));
            CloseOfflineCacheEntry();
        }
    }

    // Check for a Content-Signature header and inject mediator if the header is
    // requested and available.
    // If requested (mLoadInfo->GetVerifySignedContent), but not present, or
    // present but not valid, fail this channel and return
    // NS_ERROR_INVALID_SIGNATURE to indicate a signature error and trigger a
    // fallback load in nsDocShell.
    // Note that OnStartRequest has already been called on the target stream
    // listener at this point. We have to add the listener here that late to
    // ensure that it's the last listener and can thus block the load in
    // OnStopRequest.
    if (!mCanceled) {
        rv = ProcessContentSignatureHeader(mResponseHead);
        if (NS_FAILED(rv)) {
            LOG(("Content-signature verification failed.\n"));
            return rv;
        }
    }

    return NS_OK;
}

nsresult
nsHttpChannel::ProcessFailedProxyConnect(uint32_t httpStatus)
{
    // Failure to set up a proxy tunnel via CONNECT means one of the following:
    // 1) Proxy wants authorization, or forbids.
    // 2) DNS at proxy couldn't resolve target URL.
    // 3) Proxy connection to target failed or timed out.
    // 4) Eve intercepted our CONNECT, and is replying with malicious HTML.
    //
    // Our current architecture would parse the proxy's response content with
    // the permission of the target URL.  Given #4, we must avoid rendering the
    // body of the reply, and instead give the user a (hopefully helpful)
    // boilerplate error page, based on just the HTTP status of the reply.

    MOZ_ASSERT(mConnectionInfo->UsingConnect(),
               "proxy connect failed but not using CONNECT?");
    nsresult rv;
    switch (httpStatus)
    {
    case 300: case 301: case 302: case 303: case 307: case 308:
        // Bad redirect: not top-level, or it's a POST, bad/missing Location,
        // or ProcessRedirect() failed for some other reason.  Legal
        // redirects that fail because site not available, etc., are handled
        // elsewhere, in the regular codepath.
        rv = NS_ERROR_CONNECTION_REFUSED;
        break;
    case 403: // HTTP/1.1: "Forbidden"
    case 407: // ProcessAuthentication() failed
    case 501: // HTTP/1.1: "Not Implemented"
        // user sees boilerplate Mozilla "Proxy Refused Connection" page.
        rv = NS_ERROR_PROXY_CONNECTION_REFUSED;
        break;
    // Squid sends 404 if DNS fails (regular 404 from target is tunneled)
    case 404: // HTTP/1.1: "Not Found"
    // RFC 2616: "some deployed proxies are known to return 400 or 500 when
    // DNS lookups time out."  (Squid uses 500 if it runs out of sockets: so
    // we have a conflict here).
    case 400: // HTTP/1.1 "Bad Request"
    case 500: // HTTP/1.1: "Internal Server Error"
        /* User sees: "Address Not Found: Firefox can't find the server at
         * www.foo.com."
         */
        rv = NS_ERROR_UNKNOWN_HOST;
        break;
    case 502: // HTTP/1.1: "Bad Gateway" (invalid resp from target server)
    // Squid returns 503 if target request fails for anything but DNS.
    case 503: // HTTP/1.1: "Service Unavailable"
        /* User sees: "Failed to Connect:
         *  Firefox can't establish a connection to the server at
         *  www.foo.com.  Though the site seems valid, the browser
         *  was unable to establish a connection."
         */
        rv = NS_ERROR_CONNECTION_REFUSED;
        break;
    // RFC 2616 uses 504 for both DNS and target timeout, so not clear what to
    // do here: picking target timeout, as DNS covered by 400/404/500
    case 504: // HTTP/1.1: "Gateway Timeout"
        // user sees: "Network Timeout: The server at www.foo.com
        //              is taking too long to respond."
        rv = NS_ERROR_NET_TIMEOUT;
        break;
    // Confused proxy server or malicious response
    default:
        rv = NS_ERROR_PROXY_CONNECTION_REFUSED;
        break;
    }
    LOG(("Cancelling failed proxy CONNECT [this=%p httpStatus=%u]\n",
         this, httpStatus));
    Cancel(rv);
    CallOnStartRequest();
    return rv;
}

static void
GetSTSConsoleErrorTag(uint32_t failureResult, nsAString& consoleErrorTag)
{
    switch (failureResult) {
        case nsISiteSecurityService::ERROR_UNTRUSTWORTHY_CONNECTION:
            consoleErrorTag = NS_LITERAL_STRING("STSUntrustworthyConnection");
            break;
        case nsISiteSecurityService::ERROR_COULD_NOT_PARSE_HEADER:
            consoleErrorTag = NS_LITERAL_STRING("STSCouldNotParseHeader");
            break;
        case nsISiteSecurityService::ERROR_NO_MAX_AGE:
            consoleErrorTag = NS_LITERAL_STRING("STSNoMaxAge");
            break;
        case nsISiteSecurityService::ERROR_MULTIPLE_MAX_AGES:
            consoleErrorTag = NS_LITERAL_STRING("STSMultipleMaxAges");
            break;
        case nsISiteSecurityService::ERROR_INVALID_MAX_AGE:
            consoleErrorTag = NS_LITERAL_STRING("STSInvalidMaxAge");
            break;
        case nsISiteSecurityService::ERROR_MULTIPLE_INCLUDE_SUBDOMAINS:
            consoleErrorTag = NS_LITERAL_STRING("STSMultipleIncludeSubdomains");
            break;
        case nsISiteSecurityService::ERROR_INVALID_INCLUDE_SUBDOMAINS:
            consoleErrorTag = NS_LITERAL_STRING("STSInvalidIncludeSubdomains");
            break;
        case nsISiteSecurityService::ERROR_COULD_NOT_SAVE_STATE:
            consoleErrorTag = NS_LITERAL_STRING("STSCouldNotSaveState");
            break;
        default:
            consoleErrorTag = NS_LITERAL_STRING("STSUnknownError");
            break;
    }
}

static void
GetPKPConsoleErrorTag(uint32_t failureResult, nsAString& consoleErrorTag)
{
    switch (failureResult) {
        case nsISiteSecurityService::ERROR_UNTRUSTWORTHY_CONNECTION:
            consoleErrorTag = NS_LITERAL_STRING("PKPUntrustworthyConnection");
            break;
        case nsISiteSecurityService::ERROR_COULD_NOT_PARSE_HEADER:
            consoleErrorTag = NS_LITERAL_STRING("PKPCouldNotParseHeader");
            break;
        case nsISiteSecurityService::ERROR_NO_MAX_AGE:
            consoleErrorTag = NS_LITERAL_STRING("PKPNoMaxAge");
            break;
        case nsISiteSecurityService::ERROR_MULTIPLE_MAX_AGES:
            consoleErrorTag = NS_LITERAL_STRING("PKPMultipleMaxAges");
            break;
        case nsISiteSecurityService::ERROR_INVALID_MAX_AGE:
            consoleErrorTag = NS_LITERAL_STRING("PKPInvalidMaxAge");
            break;
        case nsISiteSecurityService::ERROR_MULTIPLE_INCLUDE_SUBDOMAINS:
            consoleErrorTag = NS_LITERAL_STRING("PKPMultipleIncludeSubdomains");
            break;
        case nsISiteSecurityService::ERROR_INVALID_INCLUDE_SUBDOMAINS:
            consoleErrorTag = NS_LITERAL_STRING("PKPInvalidIncludeSubdomains");
            break;
        case nsISiteSecurityService::ERROR_INVALID_PIN:
            consoleErrorTag = NS_LITERAL_STRING("PKPInvalidPin");
            break;
        case nsISiteSecurityService::ERROR_MULTIPLE_REPORT_URIS:
            consoleErrorTag = NS_LITERAL_STRING("PKPMultipleReportURIs");
            break;
        case nsISiteSecurityService::ERROR_PINSET_DOES_NOT_MATCH_CHAIN:
            consoleErrorTag = NS_LITERAL_STRING("PKPPinsetDoesNotMatch");
            break;
        case nsISiteSecurityService::ERROR_NO_BACKUP_PIN:
            consoleErrorTag = NS_LITERAL_STRING("PKPNoBackupPin");
            break;
        case nsISiteSecurityService::ERROR_COULD_NOT_SAVE_STATE:
            consoleErrorTag = NS_LITERAL_STRING("PKPCouldNotSaveState");
            break;
        case nsISiteSecurityService::ERROR_ROOT_NOT_BUILT_IN:
            consoleErrorTag = NS_LITERAL_STRING("PKPRootNotBuiltIn");
            break;
        default:
            consoleErrorTag = NS_LITERAL_STRING("PKPUnknownError");
            break;
    }
}

/**
 * Process a single security header. Only two types are supported: HSTS and HPKP.
 */
nsresult
nsHttpChannel::ProcessSingleSecurityHeader(uint32_t aType,
                                           nsISSLStatus *aSSLStatus,
                                           uint32_t aFlags)
{
    nsHttpAtom atom;
    switch (aType) {
        case nsISiteSecurityService::HEADER_HSTS:
            atom = nsHttp::ResolveAtom("Strict-Transport-Security");
            break;
        case nsISiteSecurityService::HEADER_HPKP:
            atom = nsHttp::ResolveAtom("Public-Key-Pins");
            break;
        default:
            NS_NOTREACHED("Invalid security header type");
            return NS_ERROR_FAILURE;
    }

    nsAutoCString securityHeader;
    nsresult rv = mResponseHead->GetHeader(atom, securityHeader);
    if (NS_SUCCEEDED(rv)) {
        nsISiteSecurityService* sss = gHttpHandler->GetSSService();
        NS_ENSURE_TRUE(sss, NS_ERROR_OUT_OF_MEMORY);
        // Process header will now discard the headers itself if the channel
        // wasn't secure (whereas before it had to be checked manually)
        uint32_t failureResult;
        rv = sss->ProcessHeader(aType, mURI, securityHeader.get(), aSSLStatus,
                                aFlags, nullptr, nullptr, &failureResult);
        if (NS_FAILED(rv)) {
            nsAutoString consoleErrorCategory;
            nsAutoString consoleErrorTag;
            switch (aType) {
                case nsISiteSecurityService::HEADER_HSTS:
                    GetSTSConsoleErrorTag(failureResult, consoleErrorTag);
                    consoleErrorCategory = NS_LITERAL_STRING("Invalid HSTS Headers");
                    break;
                case nsISiteSecurityService::HEADER_HPKP:
                    GetPKPConsoleErrorTag(failureResult, consoleErrorTag);
                    consoleErrorCategory = NS_LITERAL_STRING("Invalid HPKP Headers");
                    break;
                default:
                    return NS_ERROR_FAILURE;
            }
            AddSecurityMessage(consoleErrorTag, consoleErrorCategory);
            LOG(("nsHttpChannel: Failed to parse %s header, continuing load.\n",
                 atom.get()));
        }
    } else {
        if (rv != NS_ERROR_NOT_AVAILABLE) {
            // All other errors are fatal
            NS_ENSURE_SUCCESS(rv, rv);
        }
        LOG(("nsHttpChannel: No %s header, continuing load.\n",
             atom.get()));
    }
    return NS_OK;
}

/**
 * Decide whether or not to remember Strict-Transport-Security, and whether
 * or not to enforce channel integrity.
 *
 * @return NS_ERROR_FAILURE if there's security information missing even though
 *             it's an HTTPS connection.
 */
nsresult
nsHttpChannel::ProcessSecurityHeaders()
{
    nsresult rv;
    bool isHttps = false;
    rv = mURI->SchemeIs("https", &isHttps);
    NS_ENSURE_SUCCESS(rv, rv);

    // If this channel is not loading securely, STS or PKP doesn't do anything.
    // In the case of HSTS, the upgrade to HTTPS takes place earlier in the
    // channel load process.
    if (!isHttps)
        return NS_OK;

    nsAutoCString asciiHost;
    rv = mURI->GetAsciiHost(asciiHost);
    NS_ENSURE_SUCCESS(rv, NS_OK);

    // If the channel is not a hostname, but rather an IP, do not process STS
    // or PKP headers
    PRNetAddr hostAddr;
    if (PR_SUCCESS == PR_StringToNetAddr(asciiHost.get(), &hostAddr))
        return NS_OK;

    // mSecurityInfo may not always be present, and if it's not then it is okay
    // to just disregard any security headers since we know nothing about the
    // security of the connection.
    NS_ENSURE_TRUE(mSecurityInfo, NS_OK);

    uint32_t flags =
      NS_UsePrivateBrowsing(this) ? nsISocketProvider::NO_PERMANENT_STORAGE : 0;

    // Get the SSLStatus
    nsCOMPtr<nsISSLStatusProvider> sslprov = do_QueryInterface(mSecurityInfo);
    NS_ENSURE_TRUE(sslprov, NS_ERROR_FAILURE);
    nsCOMPtr<nsISSLStatus> sslStatus;
    rv = sslprov->GetSSLStatus(getter_AddRefs(sslStatus));
    NS_ENSURE_SUCCESS(rv, rv);
    NS_ENSURE_TRUE(sslStatus, NS_ERROR_FAILURE);

    rv = ProcessSingleSecurityHeader(nsISiteSecurityService::HEADER_HSTS,
                                     sslStatus, flags);
    NS_ENSURE_SUCCESS(rv, rv);

    rv = ProcessSingleSecurityHeader(nsISiteSecurityService::HEADER_HPKP,
                                     sslStatus, flags);
    NS_ENSURE_SUCCESS(rv, rv);

    return NS_OK;
}

nsresult
nsHttpChannel::ProcessContentSignatureHeader(nsHttpResponseHead *aResponseHead)
{
    nsresult rv = NS_OK;

    // we only do this if we require it in loadInfo
    if (!mLoadInfo || !mLoadInfo->GetVerifySignedContent()) {
        return NS_OK;
    }

    // check if we verify content signatures on this newtab channel
    if (gHttpHandler->NewTabContentSignaturesDisabled()) {
        return NS_OK;
    }

    NS_ENSURE_TRUE(aResponseHead, NS_ERROR_ABORT);
    nsAutoCString contentSignatureHeader;
    nsHttpAtom atom = nsHttp::ResolveAtom("Content-Signature");
    rv = aResponseHead->GetHeader(atom, contentSignatureHeader);
    if (NS_FAILED(rv)) {
        LOG(("Content-Signature header is missing but expected."));
        DoInvalidateCacheEntry(mURI);
        return NS_ERROR_INVALID_SIGNATURE;
    }

    // if we require a signature but it is empty, fail
    if (contentSignatureHeader.IsEmpty()) {
      DoInvalidateCacheEntry(mURI);
      LOG(("An expected content-signature header is missing.\n"));
      return NS_ERROR_INVALID_SIGNATURE;
    }

    // we ensure a content type here to avoid running into problems with
    // content sniffing, which might sniff parts of the content before we can
    // verify the signature
    if (!aResponseHead->HasContentType()) {
        NS_WARNING("Empty content type can get us in trouble when verifying "
                   "content signatures");
        return NS_ERROR_INVALID_SIGNATURE;
    }
    // create a new listener that meadiates the content
    RefPtr<ContentVerifier> contentVerifyingMediator =
      new ContentVerifier(mListener, mListenerContext);
    rv = contentVerifyingMediator->Init(contentSignatureHeader, this,
                                        mListenerContext);
    NS_ENSURE_SUCCESS(rv, NS_ERROR_INVALID_SIGNATURE);
    mListener = contentVerifyingMediator;

    return NS_OK;
}

/**
 * Decide whether or not to send a security report and, if so, give the
 * SecurityReporter the information required to send such a report.
 */
void
nsHttpChannel::ProcessSecurityReport(nsresult status) {
    uint32_t errorClass;
    nsCOMPtr<nsINSSErrorsService> errSvc =
            do_GetService("@mozilla.org/nss_errors_service;1");
    // getErrorClass will throw a generic NS_ERROR_FAILURE if the error code is
    // not in the set of errors covered by the NSS errors service.
    nsresult rv = errSvc->GetErrorClass(status, &errorClass);
    if (!NS_SUCCEEDED(rv)) {
        return;
    }

    // if the content was not loaded succesfully and we have security info,
    // send a TLS error report - we must do this early as other parts of
    // OnStopRequest can return early
    bool reportingEnabled =
            Preferences::GetBool("security.ssl.errorReporting.enabled");
    bool reportingAutomatic =
            Preferences::GetBool("security.ssl.errorReporting.automatic");
    if (!mSecurityInfo || !reportingEnabled || !reportingAutomatic) {
        return;
    }

    nsCOMPtr<nsITransportSecurityInfo> secInfo =
            do_QueryInterface(mSecurityInfo);
    nsCOMPtr<nsISecurityReporter> errorReporter =
            do_GetService("@mozilla.org/securityreporter;1");

    if (!secInfo || !mURI) {
        return;
    }

    nsAutoCString hostStr;
    int32_t port;
    rv = mURI->GetHost(hostStr);
    if (!NS_SUCCEEDED(rv)) {
        return;
    }

    rv = mURI->GetPort(&port);

    if (NS_SUCCEEDED(rv)) {
        errorReporter->ReportTLSError(secInfo, hostStr, port);
    }
}

bool
nsHttpChannel::IsHTTPS()
{
    bool isHttps;
    if (NS_FAILED(mURI->SchemeIs("https", &isHttps)) || !isHttps)
        return false;
    return true;
}

void
nsHttpChannel::ProcessSSLInformation()
{
    // If this is HTTPS, record any use of RSA so that Key Exchange Algorithm
    // can be whitelisted for TLS False Start in future sessions. We could
    // do the same for DH but its rarity doesn't justify the lookup.

    if (mCanceled || NS_FAILED(mStatus) || !mSecurityInfo ||
        !IsHTTPS() || mPrivateBrowsing)
        return;

    nsCOMPtr<nsISSLStatusProvider> statusProvider =
        do_QueryInterface(mSecurityInfo);
    if (!statusProvider)
        return;
    nsCOMPtr<nsISSLStatus> sslstat;
    statusProvider->GetSSLStatus(getter_AddRefs(sslstat));
    if (!sslstat)
        return;

    nsCOMPtr<nsITransportSecurityInfo> securityInfo =
        do_QueryInterface(mSecurityInfo);
    uint32_t state;
    if (securityInfo &&
        NS_SUCCEEDED(securityInfo->GetSecurityState(&state)) &&
        (state & nsIWebProgressListener::STATE_IS_BROKEN)) {
        // Send weak crypto warnings to the web console
        if (state & nsIWebProgressListener::STATE_USES_WEAK_CRYPTO) {
            nsString consoleErrorTag = NS_LITERAL_STRING("WeakCipherSuiteWarning");
            nsString consoleErrorCategory = NS_LITERAL_STRING("SSL");
            AddSecurityMessage(consoleErrorTag, consoleErrorCategory);
        }
    }

    // Send (SHA-1) signature algorithm errors to the web console
    nsCOMPtr<nsIX509Cert> cert;
    sslstat->GetServerCert(getter_AddRefs(cert));
    if (cert) {
        UniqueCERTCertificate nssCert(cert->GetCert());
        if (nssCert) {
            SECOidTag tag = SECOID_GetAlgorithmTag(&nssCert->signature);
            LOG(("Checking certificate signature: The OID tag is %i [this=%p]\n", tag, this));
            // Check to see if the signature is sha-1 based.
            // Not including checks for SEC_OID_ISO_SHA1_WITH_RSA_SIGNATURE
            // from http://tools.ietf.org/html/rfc2437#section-8 since I
            // can't see reference to it outside this spec
            if (tag == SEC_OID_PKCS1_SHA1_WITH_RSA_ENCRYPTION ||
                tag == SEC_OID_ANSIX9_DSA_SIGNATURE_WITH_SHA1_DIGEST ||
                tag == SEC_OID_ANSIX962_ECDSA_SHA1_SIGNATURE) {
                nsString consoleErrorTag = NS_LITERAL_STRING("SHA1Sig");
                nsString consoleErrorMessage
                        = NS_LITERAL_STRING("SHA-1 Signature");
                AddSecurityMessage(consoleErrorTag, consoleErrorMessage);
            }
        }
    }
}

void
nsHttpChannel::ProcessAltService()
{
    // e.g. Alt-Svc: h2=":443"; ma=60
    // e.g. Alt-Svc: h2="otherhost:443"
    // Alt-Svc       = 1#( alternative *( OWS ";" OWS parameter ) )
    // alternative   = protocol-id "=" alt-authority
    // protocol-id   = token ; percent-encoded ALPN protocol identifier
    // alt-authority = quoted-string ;  containing [ uri-host ] ":" port

    if (!mAllowAltSvc) { // per channel opt out
        return;
    }

    if (!gHttpHandler->AllowAltSvc() || (mCaps & NS_HTTP_DISALLOW_SPDY)) {
        return;
    }

    nsAutoCString scheme;
    mURI->GetScheme(scheme);
    bool isHttp = scheme.Equals(NS_LITERAL_CSTRING("http"));
    if (!isHttp && !scheme.Equals(NS_LITERAL_CSTRING("https"))) {
        return;
    }

    nsAutoCString altSvc;
    mResponseHead->GetHeader(nsHttp::Alternate_Service, altSvc);
    if (altSvc.IsEmpty()) {
        return;
    }

    if (!nsHttp::IsReasonableHeaderValue(altSvc)) {
        LOG(("Alt-Svc Response Header seems unreasonable - skipping\n"));
        return;
    }

    nsAutoCString originHost;
    int32_t originPort = 80;
    mURI->GetPort(&originPort);
    if (NS_FAILED(mURI->GetHost(originHost))) {
        return;
    }

    nsCOMPtr<nsIInterfaceRequestor> callbacks;
    nsCOMPtr<nsProxyInfo> proxyInfo;
    NS_NewNotificationCallbacksAggregation(mCallbacks, mLoadGroup,
                                           getter_AddRefs(callbacks));
    if (mProxyInfo) {
        proxyInfo = do_QueryInterface(mProxyInfo);
    }

    NeckoOriginAttributes originAttributes;
    NS_GetOriginAttributes(this, originAttributes);

    AltSvcMapping::ProcessHeader(altSvc, scheme, originHost, originPort,
                                 mUsername, mPrivateBrowsing, callbacks, proxyInfo,
                                 mCaps & NS_HTTP_DISALLOW_SPDY,
                                 originAttributes);
}

nsresult
nsHttpChannel::ProcessResponse()
{
    uint32_t httpStatus = mResponseHead->Status();

    LOG(("nsHttpChannel::ProcessResponse [this=%p httpStatus=%u]\n",
        this, httpStatus));

    // do some telemetry
    if (gHttpHandler->IsTelemetryEnabled()) {
        // Gather data on whether the transaction and page (if this is
        // the initial page load) is being loaded with SSL.
        Telemetry::Accumulate(Telemetry::HTTP_TRANSACTION_IS_SSL,
                              mConnectionInfo->EndToEndSSL());
        if (mLoadFlags & LOAD_INITIAL_DOCUMENT_URI) {
            Telemetry::Accumulate(Telemetry::HTTP_PAGELOAD_IS_SSL,
                                  mConnectionInfo->EndToEndSSL());
        }

        // how often do we see something like Alternate-Protocol: "443:quic,p=1"
        nsAutoCString alt_protocol;
        mResponseHead->GetHeader(nsHttp::Alternate_Protocol, alt_protocol);
        bool saw_quic = (!alt_protocol.IsEmpty() &&
                         PL_strstr(alt_protocol.get(), "quic")) ? 1 : 0;
        Telemetry::Accumulate(Telemetry::HTTP_SAW_QUIC_ALT_PROTOCOL, saw_quic);

        // Gather data on how many URLS get redirected
        switch (httpStatus) {
            case 200:
                Telemetry::Accumulate(Telemetry::HTTP_RESPONSE_STATUS_CODE, 0);
                break;
            case 301:
                Telemetry::Accumulate(Telemetry::HTTP_RESPONSE_STATUS_CODE, 1);
                break;
            case 302:
                Telemetry::Accumulate(Telemetry::HTTP_RESPONSE_STATUS_CODE, 2);
                break;
            case 304:
                Telemetry::Accumulate(Telemetry::HTTP_RESPONSE_STATUS_CODE, 3);
                break;
            case 307:
                Telemetry::Accumulate(Telemetry::HTTP_RESPONSE_STATUS_CODE, 4);
                break;
            case 308:
                Telemetry::Accumulate(Telemetry::HTTP_RESPONSE_STATUS_CODE, 5);
                break;
            case 400:
                Telemetry::Accumulate(Telemetry::HTTP_RESPONSE_STATUS_CODE, 6);
                break;
            case 401:
                Telemetry::Accumulate(Telemetry::HTTP_RESPONSE_STATUS_CODE, 7);
                break;
            case 403:
                Telemetry::Accumulate(Telemetry::HTTP_RESPONSE_STATUS_CODE, 8);
                break;
            case 404:
                Telemetry::Accumulate(Telemetry::HTTP_RESPONSE_STATUS_CODE, 9);
                break;
            case 500:
                Telemetry::Accumulate(Telemetry::HTTP_RESPONSE_STATUS_CODE, 10);
                break;
            default:
                Telemetry::Accumulate(Telemetry::HTTP_RESPONSE_STATUS_CODE, 11);
                break;
        }
    }

    // Let the predictor know whether this was a cacheable response or not so
    // that it knows whether or not to possibly prefetch this resource in the
    // future.
    // We use GetReferringPage because mReferrer may not be set at all, or may
    // not be a full URI (HttpBaseChannel::SetReferrer has the gorey details).
    // If that's null, though, we'll fall back to mReferrer just in case (this
    // is especially useful in xpcshell tests, where we don't have an actual
    // pageload to get a referrer from).
    nsCOMPtr<nsIURI> referrer = GetReferringPage();
    if (!referrer) {
        referrer = mReferrer;
    }
    if (referrer) {
        nsCOMPtr<nsILoadContextInfo> lci = GetLoadContextInfo(this);
        mozilla::net::Predictor::UpdateCacheability(referrer, mURI, httpStatus,
                                                    mRequestHead, mResponseHead,
                                                    lci);
    }

    if (mTransaction->ProxyConnectFailed()) {
        // Only allow 407 (authentication required) to continue
        if (httpStatus != 407)
            return ProcessFailedProxyConnect(httpStatus);
        // If proxy CONNECT response needs to complete, wait to process connection
        // for Strict-Transport-Security.
    } else {
        // Given a successful connection, process any STS or PKP data that's
        // relevant.
        DebugOnly<nsresult> rv = ProcessSecurityHeaders();
        MOZ_ASSERT(NS_SUCCEEDED(rv), "ProcessSTSHeader failed, continuing load.");
    }

    MOZ_ASSERT(!mCachedContentIsValid);

    ProcessSSLInformation();

    // notify "http-on-examine-response" observers
    gHttpHandler->OnExamineResponse(this);

    return ContinueProcessResponse1();
}

void
nsHttpChannel::AsyncContinueProcessResponse()
{
    nsresult rv;
    rv = ContinueProcessResponse1();
    if (NS_FAILED(rv)) {
        // A synchronous failure here would normally be passed as the return
        // value from OnStartRequest, which would in turn cancel the request.
        // If we're continuing asynchronously, we need to cancel the request
        // ourselves.
        Unused << Cancel(rv);
    }
}

nsresult
nsHttpChannel::ContinueProcessResponse1()
{
    NS_PRECONDITION(!mCallOnResume, "How did that happen?");
    nsresult rv;

    if (mSuspendCount) {
        LOG(("Waiting until resume to finish processing response [this=%p]\n", this));
        mCallOnResume = &nsHttpChannel::AsyncContinueProcessResponse;
        return NS_OK;
    }

    uint32_t httpStatus = mResponseHead->Status();

    // Cookies and Alt-Service should not be handled on proxy failure either.
    // This would be consolidated with ProcessSecurityHeaders but it should
    // happen after OnExamineResponse.
    if (!mTransaction->ProxyConnectFailed() && (httpStatus != 407)) {
        nsAutoCString cookie;
        if (NS_SUCCEEDED(mResponseHead->GetHeader(nsHttp::Set_Cookie, cookie))) {
            SetCookie(cookie.get());
        }
        if ((httpStatus < 500) && (httpStatus != 421)) {
            ProcessAltService();
        }
    }

    if (mConcurrentCacheAccess && mCachedContentIsPartial && httpStatus != 206) {
        LOG(("  only expecting 206 when doing partial request during "
             "interrupted cache concurrent read"));
        return NS_ERROR_CORRUPTED_CONTENT;
    }

    // handle unused username and password in url (see bug 232567)
    if (httpStatus != 401 && httpStatus != 407) {
        if (!mAuthRetryPending)
            mAuthProvider->CheckForSuperfluousAuth();
        if (mCanceled)
            return CallOnStartRequest();

        // reset the authentication's current continuation state because our
        // last authentication attempt has been completed successfully
        mAuthProvider->Disconnect(NS_ERROR_ABORT);
        mAuthProvider = nullptr;
        LOG(("  continuation state has been reset"));
    }

    if (mAPIRedirectToURI && !mCanceled) {
        MOZ_ASSERT(!mOnStartRequestCalled);
        nsCOMPtr<nsIURI> redirectTo;
        mAPIRedirectToURI.swap(redirectTo);

        PushRedirectAsyncFunc(&nsHttpChannel::ContinueProcessResponse2);
        rv = StartRedirectChannelToURI(redirectTo, nsIChannelEventSink::REDIRECT_TEMPORARY);
        if (NS_SUCCEEDED(rv)) {
            return NS_OK;
        }
        PopRedirectAsyncFunc(&nsHttpChannel::ContinueProcessResponse2);
    }

    // Hack: ContinueProcessResponse2 uses NS_OK to detect successful
    // redirects, so we distinguish this codepath (a non-redirect that's
    // processing normally) by passing in a bogus error code.
    return ContinueProcessResponse2(NS_BINDING_FAILED);
}

nsresult
nsHttpChannel::ContinueProcessResponse2(nsresult rv)
{
    if (NS_SUCCEEDED(rv)) {
        // redirectTo() has passed through, we don't want to go on with
        // this channel.  It will now be canceled by the redirect handling
        // code that called this function.
        return NS_OK;
    }

    rv = NS_OK;

    uint32_t httpStatus = mResponseHead->Status();

    bool successfulReval = false;

    // handle different server response categories.  Note that we handle
    // caching or not caching of error pages in
    // nsHttpResponseHead::MustValidate; if you change this switch, update that
    // one
    switch (httpStatus) {
    case 200:
    case 203:
        // Per RFC 2616, 14.35.2, "A server MAY ignore the Range header".
        // So if a server does that and sends 200 instead of 206 that we
        // expect, notify our caller.
        // However, if we wanted to start from the beginning, let it go through
        if (mResuming && mStartPos != 0) {
            LOG(("Server ignored our Range header, cancelling [this=%p]\n", this));
            Cancel(NS_ERROR_NOT_RESUMABLE);
            rv = CallOnStartRequest();
            break;
        }
        // these can normally be cached
        rv = ProcessNormal();
        MaybeInvalidateCacheEntryForSubsequentGet();
        break;
    case 206:
        if (mCachedContentIsPartial) // an internal byte range request...
            rv = ProcessPartialContent();
        else {
            mCacheInputStream.CloseAndRelease();
            rv = ProcessNormal();
        }
        break;
    case 300:
    case 301:
    case 302:
    case 307:
    case 308:
    case 303:
#if 0
    case 305: // disabled as a security measure (see bug 187996).
#endif
        // don't store the response body for redirects
        MaybeInvalidateCacheEntryForSubsequentGet();
        PushRedirectAsyncFunc(&nsHttpChannel::ContinueProcessResponse3);
        rv = AsyncProcessRedirection(httpStatus);
        if (NS_FAILED(rv)) {
            PopRedirectAsyncFunc(&nsHttpChannel::ContinueProcessResponse3);
            LOG(("AsyncProcessRedirection failed [rv=%x]\n", rv));
            // don't cache failed redirect responses.
            if (mCacheEntry)
                mCacheEntry->AsyncDoom(nullptr);
            if (DoNotRender3xxBody(rv)) {
                mStatus = rv;
                DoNotifyListener();
            } else {
                rv = ContinueProcessResponse3(rv);
            }
        }
        break;
    case 304:
        if (!ShouldBypassProcessNotModified()) {
            rv = ProcessNotModified();
            if (NS_SUCCEEDED(rv)) {
                successfulReval = true;
                break;
            }

            LOG(("ProcessNotModified failed [rv=%x]\n", rv));

            // We cannot read from the cache entry, it might be in an
            // incosistent state.  Doom it and redirect the channel
            // to the same URI to reload from the network.
            mCacheInputStream.CloseAndRelease();
            if (mCacheEntry) {
                mCacheEntry->AsyncDoom(nullptr);
                mCacheEntry = nullptr;
            }

            rv = StartRedirectChannelToURI(mURI, nsIChannelEventSink::REDIRECT_INTERNAL);
            if (NS_SUCCEEDED(rv)) {
                return NS_OK;
            }
        }

        if (ShouldBypassProcessNotModified() || NS_FAILED(rv)) {
            rv = ProcessNormal();
        }
        break;
    case 401:
    case 407:
        if (MOZ_UNLIKELY(mCustomAuthHeader) && httpStatus == 401) {
            // When a custom auth header fails, we don't want to try
            // any cached credentials, nor we want to ask the user.
            // It's up to the consumer to re-try w/o setting a custom
            // auth header if cached credentials should be attempted.
            rv = NS_ERROR_FAILURE;
        } else {
            rv = mAuthProvider->ProcessAuthentication(
                httpStatus,
                mConnectionInfo->EndToEndSSL() && mTransaction->ProxyConnectFailed());
        }
        if (rv == NS_ERROR_IN_PROGRESS)  {
            // authentication prompt has been invoked and result
            // is expected asynchronously
            mAuthRetryPending = true;
            if (httpStatus == 407 || mTransaction->ProxyConnectFailed())
                mProxyAuthPending = true;

            // suspend the transaction pump to stop receiving the
            // unauthenticated content data. We will throw that data
            // away when user provides credentials or resume the pump
            // when user refuses to authenticate.
            LOG(("Suspending the transaction, asynchronously prompting for credentials"));
            mTransactionPump->Suspend();
            rv = NS_OK;
        } else if (NS_FAILED(rv)) {
            LOG(("ProcessAuthentication failed [rv=%x]\n", rv));
            if (mTransaction->ProxyConnectFailed())
                return ProcessFailedProxyConnect(httpStatus);
            if (!mAuthRetryPending)
                mAuthProvider->CheckForSuperfluousAuth();
            rv = ProcessNormal();
        } else {
            mAuthRetryPending = true; // see DoAuthRetry
        }
        break;
    default:
        rv = ProcessNormal();
        MaybeInvalidateCacheEntryForSubsequentGet();
        break;
    }

    if (gHttpHandler->IsTelemetryEnabled()) {
        CacheDisposition cacheDisposition;
        if (!mDidReval) {
            cacheDisposition = kCacheMissed;
        } else if (successfulReval) {
            cacheDisposition = kCacheHitViaReval;
        } else {
            cacheDisposition = kCacheMissedViaReval;
        }
        AccumulateCacheHitTelemetry(cacheDisposition);

        Telemetry::Accumulate(Telemetry::HTTP_RESPONSE_VERSION,
                              mResponseHead->Version());

        if (mResponseHead->Version() == NS_HTTP_VERSION_0_9) {
            // DefaultPortTopLevel = 0, DefaultPortSubResource = 1,
            // NonDefaultPortTopLevel = 2, NonDefaultPortSubResource = 3
            uint32_t v09Info = 0;
            if (!(mLoadFlags & LOAD_INITIAL_DOCUMENT_URI)) {
                v09Info += 1;
            }
            if (mConnectionInfo->OriginPort() != mConnectionInfo->DefaultPort()) {
                v09Info += 2;
            }
            Telemetry::Accumulate(Telemetry::HTTP_09_INFO, v09Info);
        }
    }
    return rv;
}

nsresult
nsHttpChannel::ContinueProcessResponse3(nsresult rv)
{
    bool doNotRender = DoNotRender3xxBody(rv);

    if (rv == NS_ERROR_DOM_BAD_URI && mRedirectURI) {
        bool isHTTP = false;
        if (NS_FAILED(mRedirectURI->SchemeIs("http", &isHTTP)))
            isHTTP = false;
        if (!isHTTP && NS_FAILED(mRedirectURI->SchemeIs("https", &isHTTP)))
            isHTTP = false;

        if (!isHTTP) {
            // This was a blocked attempt to redirect and subvert the system by
            // redirecting to another protocol (perhaps javascript:)
            // In that case we want to throw an error instead of displaying the
            // non-redirected response body.
            LOG(("ContinueProcessResponse3 detected rejected Non-HTTP Redirection"));
            doNotRender = true;
            rv = NS_ERROR_CORRUPTED_CONTENT;
        }
    }

    if (doNotRender) {
        Cancel(rv);
        DoNotifyListener();
        return rv;
    }

    if (NS_SUCCEEDED(rv)) {
        UpdateInhibitPersistentCachingFlag();

        InitCacheEntry();
        CloseCacheEntry(false);

        if (mApplicationCacheForWrite) {
            // Store response in the offline cache
            InitOfflineCacheEntry();
            CloseOfflineCacheEntry();
        }
        return NS_OK;
    }

    LOG(("ContinueProcessResponse3 got failure result [rv=%x]\n", rv));
    if (mTransaction->ProxyConnectFailed()) {
        return ProcessFailedProxyConnect(mRedirectType);
    }
    return ProcessNormal();
}

nsresult
nsHttpChannel::ProcessNormal()
{
    nsresult rv;

    LOG(("nsHttpChannel::ProcessNormal [this=%p]\n", this));

    bool succeeded;
    rv = GetRequestSucceeded(&succeeded);
    if (NS_SUCCEEDED(rv) && !succeeded) {
        PushRedirectAsyncFunc(&nsHttpChannel::ContinueProcessNormal);
        bool waitingForRedirectCallback;
        (void)ProcessFallback(&waitingForRedirectCallback);
        if (waitingForRedirectCallback) {
            // The transaction has been suspended by ProcessFallback.
            return NS_OK;
        }
        PopRedirectAsyncFunc(&nsHttpChannel::ContinueProcessNormal);
    }

    return ContinueProcessNormal(NS_OK);
}

nsresult
nsHttpChannel::ContinueProcessNormal(nsresult rv)
{
    if (NS_FAILED(rv)) {
        // Fill the failure status here, we have failed to fall back, thus we
        // have to report our status as failed.
        mStatus = rv;
        DoNotifyListener();
        return rv;
    }

    if (mFallingBack) {
        // Do not continue with normal processing, fallback is in
        // progress now.
        return NS_OK;
    }

    // if we're here, then any byte-range requests failed to result in a partial
    // response.  we must clear this flag to prevent BufferPartialContent from
    // being called inside our OnDataAvailable (see bug 136678).
    mCachedContentIsPartial = false;

    ClearBogusContentEncodingIfNeeded();

    UpdateInhibitPersistentCachingFlag();

    // this must be called before firing OnStartRequest, since http clients,
    // such as imagelib, expect our cache entry to already have the correct
    // expiration time (bug 87710).
    if (mCacheEntry) {
        rv = InitCacheEntry();
        if (NS_FAILED(rv))
            CloseCacheEntry(true);
    }

    // Check that the server sent us what we were asking for
    if (mResuming) {
        // Create an entity id from the response
        nsAutoCString id;
        rv = GetEntityID(id);
        if (NS_FAILED(rv)) {
            // If creating an entity id is not possible -> error
            Cancel(NS_ERROR_NOT_RESUMABLE);
        }
        else if (mResponseHead->Status() != 206 &&
                 mResponseHead->Status() != 200) {
            // Probably 404 Not Found, 412 Precondition Failed or
            // 416 Invalid Range -> error
            LOG(("Unexpected response status while resuming, aborting [this=%p]\n",
                 this));
            Cancel(NS_ERROR_ENTITY_CHANGED);
        }
        // If we were passed an entity id, verify it's equal to the server's
        else if (!mEntityID.IsEmpty()) {
            if (!mEntityID.Equals(id)) {
                LOG(("Entity mismatch, expected '%s', got '%s', aborting [this=%p]",
                     mEntityID.get(), id.get(), this));
                Cancel(NS_ERROR_ENTITY_CHANGED);
            }
        }
    }

    rv = CallOnStartRequest();
    if (NS_FAILED(rv)) return rv;

    // install cache listener if we still have a cache entry open
    if (mCacheEntry && !mCacheEntryIsReadOnly) {
        rv = InstallCacheListener();
        if (NS_FAILED(rv)) return rv;
    }

    return NS_OK;
}

nsresult
nsHttpChannel::PromptTempRedirect()
{
    if (!gHttpHandler->PromptTempRedirect()) {
        return NS_OK;
    }
    nsresult rv;
    nsCOMPtr<nsIStringBundleService> bundleService =
            do_GetService(NS_STRINGBUNDLE_CONTRACTID, &rv);
    if (NS_FAILED(rv)) return rv;

    nsCOMPtr<nsIStringBundle> stringBundle;
    rv = bundleService->CreateBundle(NECKO_MSGS_URL, getter_AddRefs(stringBundle));
    if (NS_FAILED(rv)) return rv;

    nsXPIDLString messageString;
    rv = stringBundle->GetStringFromName(u"RepostFormData", getter_Copies(messageString));
    // GetStringFromName can return NS_OK and nullptr messageString.
    if (NS_SUCCEEDED(rv) && messageString) {
        bool repost = false;

        nsCOMPtr<nsIPrompt> prompt;
        GetCallback(prompt);
        if (!prompt)
            return NS_ERROR_NO_INTERFACE;

        prompt->Confirm(nullptr, messageString, &repost);
        if (!repost)
            return NS_ERROR_FAILURE;
    }

    return rv;
}

nsresult
nsHttpChannel::ProxyFailover()
{
    LOG(("nsHttpChannel::ProxyFailover [this=%p]\n", this));

    nsresult rv;

    nsCOMPtr<nsIProtocolProxyService> pps =
            do_GetService(NS_PROTOCOLPROXYSERVICE_CONTRACTID, &rv);
    if (NS_FAILED(rv))
        return rv;

    nsCOMPtr<nsIProxyInfo> pi;
    rv = pps->GetFailoverForProxy(mConnectionInfo->ProxyInfo(), mURI, mStatus,
                                  getter_AddRefs(pi));
    if (NS_FAILED(rv))
        return rv;

    // XXXbz so where does this codepath remove us from the loadgroup,
    // exactly?
    return AsyncDoReplaceWithProxy(pi);
}

void
nsHttpChannel::HandleAsyncRedirectChannelToHttps()
{
    NS_PRECONDITION(!mCallOnResume, "How did that happen?");

    if (mSuspendCount) {
        LOG(("Waiting until resume to do async redirect to https [this=%p]\n", this));
        mCallOnResume = &nsHttpChannel::HandleAsyncRedirectChannelToHttps;
        return;
    }

    nsresult rv = StartRedirectChannelToHttps();
    if (NS_FAILED(rv))
        ContinueAsyncRedirectChannelToURI(rv);
}

nsresult
nsHttpChannel::StartRedirectChannelToHttps()
{
    LOG(("nsHttpChannel::HandleAsyncRedirectChannelToHttps() [STS]\n"));

    nsCOMPtr<nsIURI> upgradedURI;
    nsresult rv = NS_GetSecureUpgradedURI(mURI, getter_AddRefs(upgradedURI));
    NS_ENSURE_SUCCESS(rv,rv);

    return StartRedirectChannelToURI(upgradedURI,
                                     nsIChannelEventSink::REDIRECT_PERMANENT |
                                     nsIChannelEventSink::REDIRECT_STS_UPGRADE);
}

void
nsHttpChannel::HandleAsyncAPIRedirect()
{
    NS_PRECONDITION(!mCallOnResume, "How did that happen?");
    NS_PRECONDITION(mAPIRedirectToURI, "How did that happen?");

    if (mSuspendCount) {
        LOG(("Waiting until resume to do async API redirect [this=%p]\n", this));
        mCallOnResume = &nsHttpChannel::HandleAsyncAPIRedirect;
        return;
    }

    nsresult rv = StartRedirectChannelToURI(mAPIRedirectToURI,
                                            nsIChannelEventSink::REDIRECT_PERMANENT);
    if (NS_FAILED(rv))
        ContinueAsyncRedirectChannelToURI(rv);

    return;
}

nsresult
nsHttpChannel::StartRedirectChannelToURI(nsIURI *upgradedURI, uint32_t flags)
{
    nsresult rv = NS_OK;
    LOG(("nsHttpChannel::StartRedirectChannelToURI()\n"));

    nsCOMPtr<nsIChannel> newChannel;

    nsCOMPtr<nsIIOService> ioService;
    rv = gHttpHandler->GetIOService(getter_AddRefs(ioService));
    NS_ENSURE_SUCCESS(rv, rv);

    rv = NS_NewChannelInternal(getter_AddRefs(newChannel),
                               upgradedURI,
                               mLoadInfo,
                               nullptr, // aLoadGroup
                               nullptr, // aCallbacks
                               nsIRequest::LOAD_NORMAL,
                               ioService);
    NS_ENSURE_SUCCESS(rv, rv);

    rv = SetupReplacementChannel(upgradedURI, newChannel, true, flags);
    NS_ENSURE_SUCCESS(rv, rv);

    // Inform consumers about this fake redirect
    mRedirectChannel = newChannel;

    if (!(flags & nsIChannelEventSink::REDIRECT_STS_UPGRADE) &&
        mInterceptCache == INTERCEPTED) {
        // Mark the channel as intercepted in order to propagate the response URL.
        nsCOMPtr<nsIHttpChannelInternal> httpRedirect = do_QueryInterface(mRedirectChannel);
        if (httpRedirect) {
            httpRedirect->ForceIntercepted(mInterceptionID);
        }
    }

    PushRedirectAsyncFunc(
        &nsHttpChannel::ContinueAsyncRedirectChannelToURI);
    rv = gHttpHandler->AsyncOnChannelRedirect(this, newChannel, flags);

    if (NS_SUCCEEDED(rv))
        rv = WaitForRedirectCallback();

    if (NS_FAILED(rv)) {
        AutoRedirectVetoNotifier notifier(this);

        /* Remove the async call to ContinueAsyncRedirectChannelToURI().
         * It is called directly by our callers upon return (to clean up
         * the failed redirect). */
        PopRedirectAsyncFunc(
            &nsHttpChannel::ContinueAsyncRedirectChannelToURI);
    }

    return rv;
}

nsresult
nsHttpChannel::ContinueAsyncRedirectChannelToURI(nsresult rv)
{
    // Since we handle mAPIRedirectToURI also after on-examine-response handler
    // rather drop it here to avoid any redirect loops, even just hypothetical.
    mAPIRedirectToURI = nullptr;

    if (NS_SUCCEEDED(rv)) {
        rv = OpenRedirectChannel(rv);
    }

    if (NS_FAILED(rv)) {
        // Fill the failure status here, the update to https had been vetoed
        // but from the security reasons we have to discard the whole channel
        // load.
        mStatus = rv;
    }

    if (mLoadGroup) {
        mLoadGroup->RemoveRequest(this, nullptr, mStatus);
    }

    if (NS_FAILED(rv)) {
        // We have to manually notify the listener because there is not any pump
        // that would call our OnStart/StopRequest after resume from waiting for
        // the redirect callback.
        DoNotifyListener();
    }

    return rv;
}

nsresult
nsHttpChannel::OpenRedirectChannel(nsresult rv)
{
    AutoRedirectVetoNotifier notifier(this);

    // Make sure to do this after we received redirect veto answer,
    // i.e. after all sinks had been notified
    mRedirectChannel->SetOriginalURI(mOriginalURI);

    // And now, notify observers the deprecated way
    nsCOMPtr<nsIHttpEventSink> httpEventSink;
    GetCallback(httpEventSink);
    if (httpEventSink) {
        // NOTE: nsIHttpEventSink is only used for compatibility with pre-1.8
        // versions.
        rv = httpEventSink->OnRedirect(this, mRedirectChannel);
        if (NS_FAILED(rv)) {
            return rv;
        }
    }

    // open new channel
    if (mLoadInfo && mLoadInfo->GetEnforceSecurity()) {
        MOZ_ASSERT(!mListenerContext, "mListenerContext should be null!");
        rv = mRedirectChannel->AsyncOpen2(mListener);
    }
    else {
        rv = mRedirectChannel->AsyncOpen(mListener, mListenerContext);
    }
    NS_ENSURE_SUCCESS(rv, rv);

    mStatus = NS_BINDING_REDIRECTED;

    notifier.RedirectSucceeded();

    ReleaseListeners();

    return NS_OK;
}

nsresult
nsHttpChannel::AsyncDoReplaceWithProxy(nsIProxyInfo* pi)
{
    LOG(("nsHttpChannel::AsyncDoReplaceWithProxy [this=%p pi=%p]", this, pi));
    nsresult rv;

    nsCOMPtr<nsIChannel> newChannel;
    rv = gHttpHandler->NewProxiedChannel2(mURI, pi, mProxyResolveFlags,
                                          mProxyURI, mLoadInfo,
                                          getter_AddRefs(newChannel));
    if (NS_FAILED(rv))
        return rv;

    uint32_t flags = nsIChannelEventSink::REDIRECT_INTERNAL;

    rv = SetupReplacementChannel(mURI, newChannel, true, flags);
    if (NS_FAILED(rv))
        return rv;

    // Inform consumers about this fake redirect
    mRedirectChannel = newChannel;

    PushRedirectAsyncFunc(&nsHttpChannel::ContinueDoReplaceWithProxy);
    rv = gHttpHandler->AsyncOnChannelRedirect(this, newChannel, flags);

    if (NS_SUCCEEDED(rv))
        rv = WaitForRedirectCallback();

    if (NS_FAILED(rv)) {
        AutoRedirectVetoNotifier notifier(this);
        PopRedirectAsyncFunc(&nsHttpChannel::ContinueDoReplaceWithProxy);
    }

    return rv;
}

nsresult
nsHttpChannel::ContinueDoReplaceWithProxy(nsresult rv)
{
    AutoRedirectVetoNotifier notifier(this);

    if (NS_FAILED(rv))
        return rv;

    NS_PRECONDITION(mRedirectChannel, "No redirect channel?");

    // Make sure to do this after we received redirect veto answer,
    // i.e. after all sinks had been notified
    mRedirectChannel->SetOriginalURI(mOriginalURI);

    // open new channel
    if (mLoadInfo && mLoadInfo->GetEnforceSecurity()) {
        MOZ_ASSERT(!mListenerContext, "mListenerContext should be null!");
        rv = mRedirectChannel->AsyncOpen2(mListener);
    }
    else {
        rv = mRedirectChannel->AsyncOpen(mListener, mListenerContext);
    }
    NS_ENSURE_SUCCESS(rv, rv);

    mStatus = NS_BINDING_REDIRECTED;

    notifier.RedirectSucceeded();

    ReleaseListeners();

    return rv;
}

nsresult
nsHttpChannel::ResolveProxy()
{
    LOG(("nsHttpChannel::ResolveProxy [this=%p]\n", this));

    nsresult rv;

    nsCOMPtr<nsIProtocolProxyService> pps =
            do_GetService(NS_PROTOCOLPROXYSERVICE_CONTRACTID, &rv);
    if (NS_FAILED(rv))
        return rv;

    // using the nsIProtocolProxyService2 allows a minor performance
    // optimization, but if an add-on has only provided the original interface
    // then it is ok to use that version.
    nsCOMPtr<nsIProtocolProxyService2> pps2 = do_QueryInterface(pps);
    if (pps2) {
        rv = pps2->AsyncResolve2(this, mProxyResolveFlags,
                                 this, getter_AddRefs(mProxyRequest));
    } else {
        rv = pps->AsyncResolve(static_cast<nsIChannel*>(this), mProxyResolveFlags,
                               this, getter_AddRefs(mProxyRequest));
    }

    return rv;
}

bool
nsHttpChannel::ResponseWouldVary(nsICacheEntry* entry)
{
    nsresult rv;
    nsAutoCString buf, metaKey;
    mCachedResponseHead->GetHeader(nsHttp::Vary, buf);
    if (!buf.IsEmpty()) {
        NS_NAMED_LITERAL_CSTRING(prefix, "request-");

        // enumerate the elements of the Vary header...
        char *val = buf.BeginWriting(); // going to munge buf
        char *token = nsCRT::strtok(val, NS_HTTP_HEADER_SEPS, &val);
        while (token) {
            LOG(("nsHttpChannel::ResponseWouldVary [channel=%p] " \
                 "processing %s\n",
                 this, token));
            //
            // if "*", then assume response would vary.  technically speaking,
            // "Vary: header, *" is not permitted, but we allow it anyways.
            //
            // We hash values of cookie-headers for the following reasons:
            //
            //   1- cookies can be very large in size
            //
            //   2- cookies may contain sensitive information.  (for parity with
            //      out policy of not storing Set-cookie headers in the cache
            //      meta data, we likewise do not want to store cookie headers
            //      here.)
            //
            if (*token == '*')
                return true; // if we encounter this, just get out of here

            // build cache meta data key...
            metaKey = prefix + nsDependentCString(token);

            // check the last value of the given request header to see if it has
            // since changed.  if so, then indeed the cached response is invalid.
            nsXPIDLCString lastVal;
            entry->GetMetaDataElement(metaKey.get(), getter_Copies(lastVal));
            LOG(("nsHttpChannel::ResponseWouldVary [channel=%p] "
                     "stored value = \"%s\"\n",
                 this, lastVal.get()));

            // Look for value of "Cookie" in the request headers
            nsHttpAtom atom = nsHttp::ResolveAtom(token);
            nsAutoCString newVal;
            bool hasHeader = NS_SUCCEEDED(mRequestHead.GetHeader(atom,
                                                                 newVal));
            if (!lastVal.IsEmpty()) {
                // value for this header in cache, but no value in request
                if (!hasHeader) {
                    return true; // yes - response would vary
                }

                // If this is a cookie-header, stored metadata is not
                // the value itself but the hash. So we also hash the
                // outgoing value here in order to compare the hashes
                nsAutoCString hash;
                if (atom == nsHttp::Cookie) {
                    rv = Hash(newVal.get(), hash);
                    // If hash failed, be conservative (the cached hash
                    // exists at this point) and claim response would vary
                    if (NS_FAILED(rv))
                        return true;
                    newVal = hash;

                    LOG(("nsHttpChannel::ResponseWouldVary [this=%p] " \
                            "set-cookie value hashed to %s\n",
                         this, newVal.get()));
                }

                if (!newVal.Equals(lastVal)) {
                    return true; // yes, response would vary
                }

            } else if (hasHeader) { // old value is empty, but newVal is set
                return true;
            }

            // next token...
            token = nsCRT::strtok(val, NS_HTTP_HEADER_SEPS, &val);
        }
    }
    return false;
}

// We need to have an implementation of this function just so that we can keep
// all references to mCallOnResume of type nsHttpChannel:  it's not OK in C++
// to set a member function ptr to  a base class function.
void
nsHttpChannel::HandleAsyncAbort()
{
    HttpAsyncAborter<nsHttpChannel>::HandleAsyncAbort();
}


nsresult
nsHttpChannel::EnsureAssocReq()
{
    // Confirm Assoc-Req response header on pipelined transactions
    // per draft-nottingham-http-pipeline-01.txt
    // of the form: GET http://blah.com/foo/bar?qv
    // return NS_OK as long as we don't find a violation
    // (i.e. no header is ok, as are malformed headers, as are
    // transactions that have not been pipelined (unless those have been
    // opted in via pragma))

    if (!mResponseHead)
        return NS_OK;

    nsAutoCString assoc_val;
    if (NS_FAILED(mResponseHead->GetHeader(nsHttp::Assoc_Req, assoc_val))) {
        return NS_OK;
    }

    if (!mTransaction || !mURI)
        return NS_OK;

    if (!mTransaction->PipelinePosition()) {
        // "Pragma: X-Verify-Assoc-Req" can be used to verify even non pipelined
        // transactions. It is used by test harness.

        nsAutoCString pragma_val;
        mResponseHead->GetHeader(nsHttp::Pragma, pragma_val);
        if (pragma_val.IsEmpty() ||
            !nsHttp::FindToken(pragma_val.get(), "X-Verify-Assoc-Req",
                               HTTP_HEADER_VALUE_SEPS))
            return NS_OK;
    }

    char *method = net_FindCharNotInSet(assoc_val.get(), HTTP_LWS);
    if (!method)
        return NS_OK;

    bool equals;
    char *endofmethod;

    char * assoc_valChar = nullptr;
    endofmethod = net_FindCharInSet(method, HTTP_LWS);
    if (endofmethod)
        assoc_valChar = net_FindCharNotInSet(endofmethod, HTTP_LWS);
    if (!assoc_valChar)
        return NS_OK;

    // check the method
    nsAutoCString methodHead;
    mRequestHead.Method(methodHead);
    if ((((int32_t)methodHead.Length()) != (endofmethod - method)) ||
        PL_strncmp(method,
                   methodHead.get(),
                   endofmethod - method)) {
        LOG(("  Assoc-Req failure Method %s", method));
        if (mConnectionInfo)
            gHttpHandler->ConnMgr()->
                PipelineFeedbackInfo(mConnectionInfo,
                                     nsHttpConnectionMgr::RedCorruptedContent,
                                     nullptr, 0);

        nsCOMPtr<nsIConsoleService> consoleService =
            do_GetService(NS_CONSOLESERVICE_CONTRACTID);
        if (consoleService) {
            nsAutoString message
                (NS_LITERAL_STRING("Failed Assoc-Req. Received "));
            nsAutoCString assoc_req;
            mResponseHead->GetHeader(nsHttp::Assoc_Req, assoc_req);
            AppendASCIItoUTF16(assoc_req, message);
            message += NS_LITERAL_STRING(" expected method ");
            AppendASCIItoUTF16(methodHead, message);
            consoleService->LogStringMessage(message.get());
        }

        if (gHttpHandler->EnforceAssocReq())
            return NS_ERROR_CORRUPTED_CONTENT;
        return NS_OK;
    }

    // check the URL
    nsCOMPtr<nsIURI> assoc_url;
    if (NS_FAILED(NS_NewURI(getter_AddRefs(assoc_url), assoc_valChar)) ||
        !assoc_url)
        return NS_OK;

    mURI->Equals(assoc_url, &equals);
    if (!equals) {
        LOG(("  Assoc-Req failure URL %s", assoc_valChar));
        if (mConnectionInfo)
            gHttpHandler->ConnMgr()->
                PipelineFeedbackInfo(mConnectionInfo,
                                     nsHttpConnectionMgr::RedCorruptedContent,
                                     nullptr, 0);

        nsCOMPtr<nsIConsoleService> consoleService =
            do_GetService(NS_CONSOLESERVICE_CONTRACTID);
        if (consoleService) {
            nsAutoString message
                (NS_LITERAL_STRING("Failed Assoc-Req. Received "));
            nsAutoCString assoc_req;
            mResponseHead->GetHeader(nsHttp::Assoc_Req, assoc_req);
            AppendASCIItoUTF16(assoc_req, message);
            message += NS_LITERAL_STRING(" expected URL ");
            AppendASCIItoUTF16(mSpec.get(), message);
            consoleService->LogStringMessage(message.get());
        }

        if (gHttpHandler->EnforceAssocReq())
            return NS_ERROR_CORRUPTED_CONTENT;
    }
    return NS_OK;
}

//-----------------------------------------------------------------------------
// nsHttpChannel <byte-range>
//-----------------------------------------------------------------------------

bool
nsHttpChannel::IsResumable(int64_t partialLen, int64_t contentLength,
                           bool ignoreMissingPartialLen) const
{
    bool hasContentEncoding =
        mCachedResponseHead->HasHeader(nsHttp::Content_Encoding);

    nsAutoCString etag; 
    mCachedResponseHead->GetHeader(nsHttp::ETag, etag);
    bool hasWeakEtag = !etag.IsEmpty() &&
                       StringBeginsWith(etag, NS_LITERAL_CSTRING("W/"));

    return (partialLen < contentLength) &&
           (partialLen > 0 || ignoreMissingPartialLen) &&
           !hasContentEncoding && !hasWeakEtag &&
           mCachedResponseHead->IsResumable() &&
           !mCustomConditionalRequest &&
           !mCachedResponseHead->NoStore();
}

nsresult
nsHttpChannel::MaybeSetupByteRangeRequest(int64_t partialLen, int64_t contentLength,
                                          bool ignoreMissingPartialLen)
{
    // Be pesimistic
    mIsPartialRequest = false;

    if (!IsResumable(partialLen, contentLength, ignoreMissingPartialLen))
      return NS_ERROR_NOT_RESUMABLE;

    // looks like a partial entry we can reuse; add If-Range
    // and Range headers.
    nsresult rv = SetupByteRangeRequest(partialLen);
    if (NS_FAILED(rv)) {
        // Make the request unconditional again.
        UntieByteRangeRequest();
    }

    return rv;
}

nsresult
nsHttpChannel::SetupByteRangeRequest(int64_t partialLen)
{
    // cached content has been found to be partial, add necessary request
    // headers to complete cache entry.

    // use strongest validator available...
    nsAutoCString val;
    mCachedResponseHead->GetHeader(nsHttp::ETag, val);
    if (val.IsEmpty())
        mCachedResponseHead->GetHeader(nsHttp::Last_Modified, val);
    if (val.IsEmpty()) {
        // if we hit this code it means mCachedResponseHead->IsResumable() is
        // either broken or not being called.
        NS_NOTREACHED("no cache validator");
        mIsPartialRequest = false;
        return NS_ERROR_FAILURE;
    }

    char buf[64];
    SprintfLiteral(buf, "bytes=%" PRId64 "-", partialLen);

    mRequestHead.SetHeader(nsHttp::Range, nsDependentCString(buf));
    mRequestHead.SetHeader(nsHttp::If_Range, val);
    mIsPartialRequest = true;

    return NS_OK;
}

void
nsHttpChannel::UntieByteRangeRequest()
{
    mRequestHead.ClearHeader(nsHttp::Range);
    mRequestHead.ClearHeader(nsHttp::If_Range);
}

nsresult
nsHttpChannel::ProcessPartialContent()
{
    // ok, we've just received a 206
    //
    // we need to stream whatever data is in the cache out first, and then
    // pick up whatever data is on the wire, writing it into the cache.

    LOG(("nsHttpChannel::ProcessPartialContent [this=%p]\n", this));

    NS_ENSURE_TRUE(mCachedResponseHead, NS_ERROR_NOT_INITIALIZED);
    NS_ENSURE_TRUE(mCacheEntry, NS_ERROR_NOT_INITIALIZED);

    // Make sure to clear bogus content-encodings before looking at the header
    ClearBogusContentEncodingIfNeeded();

    // Check if the content-encoding we now got is different from the one we
    // got before
    nsAutoCString contentEncoding, cachedContentEncoding;
    mResponseHead->GetHeader(nsHttp::Content_Encoding, contentEncoding);
    mCachedResponseHead->GetHeader(nsHttp::Content_Encoding,
                                   cachedContentEncoding);
    if (PL_strcasecmp(contentEncoding.get(), cachedContentEncoding.get())
        != 0) {
        Cancel(NS_ERROR_INVALID_CONTENT_ENCODING);
        return CallOnStartRequest();
    }

    nsresult rv;

    int64_t cachedContentLength = mCachedResponseHead->ContentLength();
    int64_t entitySize = mResponseHead->TotalEntitySize();

    nsAutoCString contentRange;
    mResponseHead->GetHeader(nsHttp::Content_Range, contentRange);
    LOG(("nsHttpChannel::ProcessPartialContent [this=%p trans=%p] "
         "original content-length %lld, entity-size %lld, content-range %s\n",
         this, mTransaction.get(), cachedContentLength, entitySize,
         contentRange.get()));

    if ((entitySize >= 0) && (cachedContentLength >= 0) &&
        (entitySize != cachedContentLength)) {
        LOG(("nsHttpChannel::ProcessPartialContent [this=%p] "
             "206 has different total entity size than the content length "
             "of the original partially cached entity.\n", this));

        mCacheEntry->AsyncDoom(nullptr);
        Cancel(NS_ERROR_CORRUPTED_CONTENT);
        return CallOnStartRequest();
    }

    if (mConcurrentCacheAccess) {
        // We started to read cached data sooner than its write has been done.
        // But the concurrent write has not finished completely, so we had to
        // do a range request.  Now let the content coming from the network
        // be presented to consumers and also stored to the cache entry.

        rv = InstallCacheListener(mLogicalOffset);
        if (NS_FAILED(rv)) return rv;

        if (mOfflineCacheEntry) {
            rv = InstallOfflineCacheListener(mLogicalOffset);
            if (NS_FAILED(rv)) return rv;
        }
    } else {
        // suspend the current transaction
        rv = mTransactionPump->Suspend();
        if (NS_FAILED(rv)) return rv;
    }

    // merge any new headers with the cached response headers
    rv = mCachedResponseHead->UpdateHeaders(mResponseHead);
    if (NS_FAILED(rv)) return rv;

    // update the cached response head
    nsAutoCString head;
    mCachedResponseHead->Flatten(head, true);
    rv = mCacheEntry->SetMetaDataElement("response-head", head.get());
    if (NS_FAILED(rv)) return rv;

    // make the cached response be the current response
    mResponseHead = Move(mCachedResponseHead);

    UpdateInhibitPersistentCachingFlag();

    rv = UpdateExpirationTime();
    if (NS_FAILED(rv)) return rv;

    // notify observers interested in looking at a response that has been
    // merged with any cached headers (http-on-examine-merged-response).
    gHttpHandler->OnExamineMergedResponse(this);

    if (mConcurrentCacheAccess) {
        mCachedContentIsPartial = false;
        // Leave the mConcurrentCacheAccess flag set, we want to use it
        // to prevent duplicate OnStartRequest call on the target listener
        // in case this channel is canceled before it gets its OnStartRequest
        // from the http transaction.

        // Now we continue reading the network response.
    } else {
        // the cached content is valid, although incomplete.
        mCachedContentIsValid = true;
        rv = ReadFromCache(false);
    }

    return rv;
}

nsresult
nsHttpChannel::OnDoneReadingPartialCacheEntry(bool *streamDone)
{
    nsresult rv;

    LOG(("nsHttpChannel::OnDoneReadingPartialCacheEntry [this=%p]", this));

    // by default, assume we would have streamed all data or failed...
    *streamDone = true;

    // setup cache listener to append to cache entry
    int64_t size;
    rv = mCacheEntry->GetDataSize(&size);
    if (NS_FAILED(rv)) return rv;

    rv = InstallCacheListener(size);
    if (NS_FAILED(rv)) return rv;

    // Entry is valid, do it now, after the output stream has been opened,
    // otherwise when done earlier, pending readers would consider the cache
    // entry still as partial (CacheEntry::GetDataSize would return the partial
    // data size) and consumers would do the conditional request again.
    rv = mCacheEntry->SetValid();
    if (NS_FAILED(rv)) return rv;

    // need to track the logical offset of the data being sent to our listener
    mLogicalOffset = size;

    // we're now completing the cached content, so we can clear this flag.
    // this puts us in the state of a regular download.
    mCachedContentIsPartial = false;
    // The cache input stream pump is finished, we do not need it any more.
    // (see bug 1313923)
    mCachePump = nullptr;

    // resume the transaction if it exists, otherwise the pipe contained the
    // remaining part of the document and we've now streamed all of the data.
    if (mTransactionPump) {
        rv = mTransactionPump->Resume();
        if (NS_SUCCEEDED(rv))
            *streamDone = false;
    }
    else
        NS_NOTREACHED("no transaction");
    return rv;
}

//-----------------------------------------------------------------------------
// nsHttpChannel <cache>
//-----------------------------------------------------------------------------

bool
nsHttpChannel::ShouldBypassProcessNotModified()
{
    if (mCustomConditionalRequest) {
        LOG(("Bypassing ProcessNotModified due to custom conditional headers"));
        return true;
    }

    if (!mDidReval) {
        LOG(("Server returned a 304 response even though we did not send a "
             "conditional request"));
        return true;
    }

    return false;
}

nsresult
nsHttpChannel::ProcessNotModified()
{
    nsresult rv;

    LOG(("nsHttpChannel::ProcessNotModified [this=%p]\n", this));

    // Assert ShouldBypassProcessNotModified() has been checked before call to
    // ProcessNotModified().
    MOZ_ASSERT(!ShouldBypassProcessNotModified());

    MOZ_ASSERT(mCachedResponseHead);
    MOZ_ASSERT(mCacheEntry);
    NS_ENSURE_TRUE(mCachedResponseHead && mCacheEntry, NS_ERROR_UNEXPECTED);

    // If the 304 response contains a Last-Modified different than the
    // one in our cache that is pretty suspicious and is, in at least the
    // case of bug 716840, a sign of the server having previously corrupted
    // our cache with a bad response. Take the minor step here of just dooming
    // that cache entry so there is a fighting chance of getting things on the
    // right track as well as disabling pipelining for that host.

    nsAutoCString lastModifiedCached;
    nsAutoCString lastModified304;

    rv = mCachedResponseHead->GetHeader(nsHttp::Last_Modified,
                                        lastModifiedCached);
    if (NS_SUCCEEDED(rv)) {
        rv = mResponseHead->GetHeader(nsHttp::Last_Modified,
                                      lastModified304);
    }

    if (NS_SUCCEEDED(rv) && !lastModified304.Equals(lastModifiedCached)) {
        LOG(("Cache Entry and 304 Last-Modified Headers Do Not Match "
             "[%s] and [%s]\n",
             lastModifiedCached.get(), lastModified304.get()));

        mCacheEntry->AsyncDoom(nullptr);
        if (mConnectionInfo)
            gHttpHandler->ConnMgr()->
                PipelineFeedbackInfo(mConnectionInfo,
                                     nsHttpConnectionMgr::RedCorruptedContent,
                                     nullptr, 0);
        Telemetry::Accumulate(Telemetry::CACHE_LM_INCONSISTENT, true);
    }

    // merge any new headers with the cached response headers
    rv = mCachedResponseHead->UpdateHeaders(mResponseHead);
    if (NS_FAILED(rv)) return rv;

    // update the cached response head
    nsAutoCString head;
    mCachedResponseHead->Flatten(head, true);
    rv = mCacheEntry->SetMetaDataElement("response-head", head.get());
    if (NS_FAILED(rv)) return rv;

    // make the cached response be the current response
    mResponseHead = Move(mCachedResponseHead);

    UpdateInhibitPersistentCachingFlag();

    rv = UpdateExpirationTime();
    if (NS_FAILED(rv)) return rv;

    rv = AddCacheEntryHeaders(mCacheEntry);
    if (NS_FAILED(rv)) return rv;

    // notify observers interested in looking at a reponse that has been
    // merged with any cached headers
    gHttpHandler->OnExamineMergedResponse(this);

    mCachedContentIsValid = true;

    // Tell other consumers the entry is OK to use
    rv = mCacheEntry->SetValid();
    if (NS_FAILED(rv)) return rv;

    rv = ReadFromCache(false);
    if (NS_FAILED(rv)) return rv;

    mTransactionReplaced = true;
    return NS_OK;
}

nsresult
nsHttpChannel::ProcessFallback(bool *waitingForRedirectCallback)
{
    LOG(("nsHttpChannel::ProcessFallback [this=%p]\n", this));
    nsresult rv;

    *waitingForRedirectCallback = false;
    mFallingBack = false;

    // At this point a load has failed (either due to network problems
    // or an error returned on the server).  Perform an application
    // cache fallback if we have a URI to fall back to.
    if (!mApplicationCache || mFallbackKey.IsEmpty() || mFallbackChannel) {
        LOG(("  choosing not to fallback [%p,%s,%d]",
             mApplicationCache.get(), mFallbackKey.get(), mFallbackChannel));
        return NS_OK;
    }

    // Make sure the fallback entry hasn't been marked as a foreign
    // entry.
    uint32_t fallbackEntryType;
    rv = mApplicationCache->GetTypes(mFallbackKey, &fallbackEntryType);
    NS_ENSURE_SUCCESS(rv, rv);

    if (fallbackEntryType & nsIApplicationCache::ITEM_FOREIGN) {
        // This cache points to a fallback that refers to a different
        // manifest.  Refuse to fall back.
        return NS_OK;
    }

    MOZ_ASSERT(fallbackEntryType & nsIApplicationCache::ITEM_FALLBACK,
               "Fallback entry not marked correctly!");

    // Kill any offline cache entry, and disable offline caching for the
    // fallback.
    if (mOfflineCacheEntry) {
        mOfflineCacheEntry->AsyncDoom(nullptr);
        mOfflineCacheEntry = nullptr;
    }

    mApplicationCacheForWrite = nullptr;
    mOfflineCacheEntry = nullptr;

    // Close the current cache entry.
    CloseCacheEntry(true);

    // Create a new channel to load the fallback entry.
    RefPtr<nsIChannel> newChannel;
    rv = gHttpHandler->NewChannel2(mURI,
                                   mLoadInfo,
                                   getter_AddRefs(newChannel));
    NS_ENSURE_SUCCESS(rv, rv);

    uint32_t redirectFlags = nsIChannelEventSink::REDIRECT_INTERNAL;
    rv = SetupReplacementChannel(mURI, newChannel, true, redirectFlags);
    NS_ENSURE_SUCCESS(rv, rv);

    // Make sure the new channel loads from the fallback key.
    nsCOMPtr<nsIHttpChannelInternal> httpInternal =
        do_QueryInterface(newChannel, &rv);
    NS_ENSURE_SUCCESS(rv, rv);

    rv = httpInternal->SetupFallbackChannel(mFallbackKey.get());
    NS_ENSURE_SUCCESS(rv, rv);

    // ... and fallbacks should only load from the cache.
    uint32_t newLoadFlags = mLoadFlags | LOAD_REPLACE | LOAD_ONLY_FROM_CACHE;
    rv = newChannel->SetLoadFlags(newLoadFlags);

    // Inform consumers about this fake redirect
    mRedirectChannel = newChannel;

    PushRedirectAsyncFunc(&nsHttpChannel::ContinueProcessFallback);
    rv = gHttpHandler->AsyncOnChannelRedirect(this, newChannel, redirectFlags);

    if (NS_SUCCEEDED(rv))
        rv = WaitForRedirectCallback();

    if (NS_FAILED(rv)) {
        AutoRedirectVetoNotifier notifier(this);
        PopRedirectAsyncFunc(&nsHttpChannel::ContinueProcessFallback);
        return rv;
    }

    // Indicate we are now waiting for the asynchronous redirect callback
    // if all went OK.
    *waitingForRedirectCallback = true;
    return NS_OK;
}

nsresult
nsHttpChannel::ContinueProcessFallback(nsresult rv)
{
    AutoRedirectVetoNotifier notifier(this);

    if (NS_FAILED(rv))
        return rv;

    NS_PRECONDITION(mRedirectChannel, "No redirect channel?");

    // Make sure to do this after we received redirect veto answer,
    // i.e. after all sinks had been notified
    mRedirectChannel->SetOriginalURI(mOriginalURI);

    if (mLoadInfo && mLoadInfo->GetEnforceSecurity()) {
        MOZ_ASSERT(!mListenerContext, "mListenerContext should be null!");
        rv = mRedirectChannel->AsyncOpen2(mListener);
    }
    else {
        rv = mRedirectChannel->AsyncOpen(mListener, mListenerContext);
    }
    NS_ENSURE_SUCCESS(rv, rv);

    if (mLoadFlags & LOAD_INITIAL_DOCUMENT_URI) {
        MaybeWarnAboutAppCache();
    }

    // close down this channel
    Cancel(NS_BINDING_REDIRECTED);

    notifier.RedirectSucceeded();

    ReleaseListeners();

    mFallingBack = true;

    return NS_OK;
}

// Determines if a request is a byte range request for a subrange,
// i.e. is a byte range request, but not a 0- byte range request.
static bool
IsSubRangeRequest(nsHttpRequestHead &aRequestHead)
{
    nsAutoCString byteRange;
    if (NS_FAILED(aRequestHead.GetHeader(nsHttp::Range, byteRange))) {
        return false;
    }
    return !byteRange.EqualsLiteral("bytes=0-");
}

nsresult
nsHttpChannel::OpenCacheEntry(bool isHttps)
{
    // Handle correctly mCacheEntriesToWaitFor
    AutoCacheWaitFlags waitFlags(this);

    // Drop this flag here
    mConcurrentCacheAccess = 0;

    nsresult rv;

    mLoadedFromApplicationCache = false;
    mHasQueryString = HasQueryString(mRequestHead.ParsedMethod(), mURI);

    LOG(("nsHttpChannel::OpenCacheEntry [this=%p]", this));

    // make sure we're not abusing this function
    NS_PRECONDITION(!mCacheEntry, "cache entry already open");

    nsAutoCString cacheKey;
    nsAutoCString extension;

    if (mRequestHead.IsPost()) {
        // If the post id is already set then this is an attempt to replay
        // a post transaction via the cache.  Otherwise, we need a unique
        // post id for this transaction.
        if (mPostID == 0)
            mPostID = gHttpHandler->GenerateUniqueID();
    }
    else if (!PossiblyIntercepted() && !mRequestHead.IsGet() && !mRequestHead.IsHead()) {
        // don't use the cache for other types of requests
        return NS_OK;
    }

    if (mResuming) {
        // We don't support caching for requests initiated
        // via nsIResumableChannel.
        return NS_OK;
    }

    // Don't cache byte range requests which are subranges, only cache 0-
    // byte range requests.
    if (IsSubRangeRequest(mRequestHead))
        return NS_OK;

    // Pick up an application cache from the notification
    // callbacks if available and if we are not an intercepted channel.
    if (!PossiblyIntercepted() && !mApplicationCache &&
        mInheritApplicationCache) {
        nsCOMPtr<nsIApplicationCacheContainer> appCacheContainer;
        GetCallback(appCacheContainer);

        if (appCacheContainer) {
            appCacheContainer->GetApplicationCache(getter_AddRefs(mApplicationCache));
        }
    }

    nsCOMPtr<nsICacheStorageService> cacheStorageService =
        do_GetService("@mozilla.org/netwerk/cache-storage-service;1", &rv);
    NS_ENSURE_SUCCESS(rv, rv);

    nsCOMPtr<nsICacheStorage> cacheStorage;
    nsCOMPtr<nsIURI> openURI;
    if (!mFallbackKey.IsEmpty() && mFallbackChannel) {
        // This is a fallback channel, open fallback URI instead
        rv = NS_NewURI(getter_AddRefs(openURI), mFallbackKey);
        NS_ENSURE_SUCCESS(rv, rv);
    }
    else {
        // In the case of intercepted channels, we need to construct the cache
        // entry key based on the original URI, so that in case the intercepted
        // channel is redirected, the cache entry key before and after the
        // redirect is the same.
        if (PossiblyIntercepted()) {
            openURI = mOriginalURI;
        } else {
            openURI = mURI;
        }
    }

    RefPtr<LoadContextInfo> info = GetLoadContextInfo(this);
    if (!info) {
        return NS_ERROR_FAILURE;
    }

    uint32_t cacheEntryOpenFlags;
    bool offline = gIOService->IsOffline();

    nsAutoCString cacheControlRequestHeader;
    mRequestHead.GetHeader(nsHttp::Cache_Control, cacheControlRequestHeader);
    CacheControlParser cacheControlRequest(cacheControlRequestHeader);
    if (cacheControlRequest.NoStore() && !PossiblyIntercepted()) {
        goto bypassCacheEntryOpen;
    }

    if (offline || (mLoadFlags & INHIBIT_CACHING)) {
        if (BYPASS_LOCAL_CACHE(mLoadFlags) && !offline && !PossiblyIntercepted()) {
            goto bypassCacheEntryOpen;
        }
        cacheEntryOpenFlags = nsICacheStorage::OPEN_READONLY;
        mCacheEntryIsReadOnly = true;
    }
    else if (BYPASS_LOCAL_CACHE(mLoadFlags) && !mApplicationCache) {
        cacheEntryOpenFlags = nsICacheStorage::OPEN_TRUNCATE;
    }
    else {
        cacheEntryOpenFlags = nsICacheStorage::OPEN_NORMALLY
                            | nsICacheStorage::CHECK_MULTITHREADED;
    }

    if (!mPostID && mApplicationCache) {
        rv = cacheStorageService->AppCacheStorage(info,
            mApplicationCache,
            getter_AddRefs(cacheStorage));
    } else if (PossiblyIntercepted()) {
        // The synthesized cache has less restrictions on file size and so on.
        rv = cacheStorageService->SynthesizedCacheStorage(info,
            getter_AddRefs(cacheStorage));
    } else if (mLoadFlags & INHIBIT_PERSISTENT_CACHING) {
        rv = cacheStorageService->MemoryCacheStorage(info, // ? choose app cache as well...
            getter_AddRefs(cacheStorage));
    }
    else if (mPinCacheContent) {
        rv = cacheStorageService->PinningCacheStorage(info,
            getter_AddRefs(cacheStorage));
    }
    else {
        rv = cacheStorageService->DiskCacheStorage(info,
            !mPostID && (mChooseApplicationCache || (mLoadFlags & LOAD_CHECK_OFFLINE_CACHE)),
            getter_AddRefs(cacheStorage));
    }
    NS_ENSURE_SUCCESS(rv, rv);

    if ((mClassOfService & nsIClassOfService::Leader) ||
        (mLoadFlags & LOAD_INITIAL_DOCUMENT_URI))
        cacheEntryOpenFlags |= nsICacheStorage::OPEN_PRIORITY;

    // Only for backward compatibility with the old cache back end.
    // When removed, remove the flags and related code snippets.
    if (mLoadFlags & LOAD_BYPASS_LOCAL_CACHE_IF_BUSY)
        cacheEntryOpenFlags |= nsICacheStorage::OPEN_BYPASS_IF_BUSY;

    if (PossiblyIntercepted()) {
        extension.Append(nsPrintfCString("u%lld", mInterceptionID));
    } else if (mPostID) {
        extension.Append(nsPrintfCString("%d", mPostID));
    }

    // If this channel should be intercepted, we do not open a cache entry for this channel
    // until the interception process is complete and the consumer decides what to do with it.
    if (mInterceptCache == MAYBE_INTERCEPT) {
        DebugOnly<bool> exists;
        MOZ_ASSERT(NS_FAILED(cacheStorage->Exists(openURI, extension, &exists)) || !exists,
                   "The entry must not exist in the cache before we create it here");

        nsCOMPtr<nsICacheEntry> entry;
        rv = cacheStorage->OpenTruncate(openURI, extension, getter_AddRefs(entry));
        NS_ENSURE_SUCCESS(rv, rv);

        nsCOMPtr<nsINetworkInterceptController> controller;
        GetCallback(controller);

        RefPtr<InterceptedChannelChrome> intercepted =
                new InterceptedChannelChrome(this, controller, entry);
        intercepted->NotifyController();
    } else {
        if (mInterceptCache == INTERCEPTED) {
            cacheEntryOpenFlags |= nsICacheStorage::OPEN_INTERCEPTED;
            // Clear OPEN_TRUNCATE for the fake cache entry, since otherwise
            // cache storage will close the current entry which breaks the
            // response synthesis.
            cacheEntryOpenFlags &= ~nsICacheStorage::OPEN_TRUNCATE;
            DebugOnly<bool> exists;
            MOZ_ASSERT(NS_SUCCEEDED(cacheStorage->Exists(openURI, extension, &exists)) && exists,
                       "The entry must exist in the cache after we create it here");
        }

        mCacheOpenWithPriority = cacheEntryOpenFlags & nsICacheStorage::OPEN_PRIORITY;
        mCacheQueueSizeWhenOpen = CacheStorageService::CacheQueueSize(mCacheOpenWithPriority);

        rv = cacheStorage->AsyncOpenURI(openURI, extension, cacheEntryOpenFlags, this);
        NS_ENSURE_SUCCESS(rv, rv);
    }

    waitFlags.Keep(WAIT_FOR_CACHE_ENTRY);

bypassCacheEntryOpen:
    if (!mApplicationCacheForWrite)
        return NS_OK;

    // If there is an app cache to write to, open the entry right now in parallel.

    // make sure we're not abusing this function
    NS_PRECONDITION(!mOfflineCacheEntry, "cache entry already open");

    if (offline) {
        // only put things in the offline cache while online
        return NS_OK;
    }

    if (mLoadFlags & INHIBIT_CACHING) {
        // respect demand not to cache
        return NS_OK;
    }

    if (!mRequestHead.IsGet()) {
        // only cache complete documents offline
        return NS_OK;
    }

    rv = cacheStorageService->AppCacheStorage(info, mApplicationCacheForWrite,
                                              getter_AddRefs(cacheStorage));
    NS_ENSURE_SUCCESS(rv, rv);

    rv = cacheStorage->AsyncOpenURI(
      mURI, EmptyCString(), nsICacheStorage::OPEN_TRUNCATE, this);
    NS_ENSURE_SUCCESS(rv, rv);

    waitFlags.Keep(WAIT_FOR_OFFLINE_CACHE_ENTRY);

    return NS_OK;
}

nsresult
nsHttpChannel::CheckPartial(nsICacheEntry* aEntry, int64_t *aSize, int64_t *aContentLength)
{
    nsresult rv;

    rv = aEntry->GetDataSize(aSize);

    if (NS_ERROR_IN_PROGRESS == rv) {
        *aSize = -1;
        rv = NS_OK;
    }

    NS_ENSURE_SUCCESS(rv, rv);

    nsHttpResponseHead* responseHead = mCachedResponseHead
        ? mCachedResponseHead
        : mResponseHead;

    if (!responseHead)
        return NS_ERROR_UNEXPECTED;

    *aContentLength = responseHead->ContentLength();

    return NS_OK;
}

void
nsHttpChannel::UntieValidationRequest()
{
    // Make the request unconditional again.
    mRequestHead.ClearHeader(nsHttp::If_Modified_Since);
    mRequestHead.ClearHeader(nsHttp::If_None_Match);
    mRequestHead.ClearHeader(nsHttp::ETag);
}

NS_IMETHODIMP
nsHttpChannel::OnCacheEntryCheck(nsICacheEntry* entry, nsIApplicationCache* appCache,
                                 uint32_t* aResult)
{
    nsresult rv = NS_OK;

    LOG(("nsHttpChannel::OnCacheEntryCheck enter [channel=%p entry=%p]",
        this, entry));

    nsAutoCString cacheControlRequestHeader;
    mRequestHead.GetHeader(nsHttp::Cache_Control, cacheControlRequestHeader);
    CacheControlParser cacheControlRequest(cacheControlRequestHeader);

    if (cacheControlRequest.NoStore()) {
        LOG(("Not using cached response based on no-store request cache directive\n"));
        *aResult = ENTRY_NOT_WANTED;
        return NS_OK;
    }

    // Remember the request is a custom conditional request so that we can
    // process any 304 response correctly.
    mCustomConditionalRequest =
        mRequestHead.HasHeader(nsHttp::If_Modified_Since) ||
        mRequestHead.HasHeader(nsHttp::If_None_Match) ||
        mRequestHead.HasHeader(nsHttp::If_Unmodified_Since) ||
        mRequestHead.HasHeader(nsHttp::If_Match) ||
        mRequestHead.HasHeader(nsHttp::If_Range);

    // Be pessimistic: assume the cache entry has no useful data.
    *aResult = ENTRY_WANTED;
    mCachedContentIsValid = false;

    nsXPIDLCString buf;

    // Get the method that was used to generate the cached response
    rv = entry->GetMetaDataElement("request-method", getter_Copies(buf));
    NS_ENSURE_SUCCESS(rv, rv);

    bool methodWasHead = buf.EqualsLiteral("HEAD");
    bool methodWasGet = buf.EqualsLiteral("GET");

    if (methodWasHead) {
        // The cached response does not contain an entity.  We can only reuse
        // the response if the current request is also HEAD.
        if (!mRequestHead.IsHead()) {
            return NS_OK;
        }
    }
    buf.Adopt(0);

    // We'll need this value in later computations...
    uint32_t lastModifiedTime;
    rv = entry->GetLastModified(&lastModifiedTime);
    NS_ENSURE_SUCCESS(rv, rv);

    // Determine if this is the first time that this cache entry
    // has been accessed during this session.
    bool fromPreviousSession =
            (gHttpHandler->SessionStartTime() > lastModifiedTime);

    // Get the cached HTTP response headers
    mCachedResponseHead = new nsHttpResponseHead();

    // A "original-response-headers" metadata element holds network original headers,
    // i.e. the headers in the form as they arrieved from the network.
    // We need to get the network original headers first, because we need to keep them
    // in order.
    rv = entry->GetMetaDataElement("original-response-headers", getter_Copies(buf));
    if (NS_SUCCEEDED(rv)) {
        mCachedResponseHead->ParseCachedOriginalHeaders((char *) buf.get());
    }

    buf.Adopt(0);
    // A "response-head" metadata element holds response head, e.g. response status
    // line and headers in the form Firefox uses them internally (no dupicate
    // headers, etc.).
    rv = entry->GetMetaDataElement("response-head", getter_Copies(buf));
    NS_ENSURE_SUCCESS(rv, rv);

    // Parse string stored in a "response-head" metadata element.
    // These response headers will be merged with the orignal headers (i.e. the
    // headers stored in a "original-response-headers" metadata element).
    rv = mCachedResponseHead->ParseCachedHead(buf.get());
    NS_ENSURE_SUCCESS(rv, rv);
    buf.Adopt(0);

    bool isCachedRedirect = WillRedirect(mCachedResponseHead);

    // Do not return 304 responses from the cache, and also do not return
    // any other non-redirect 3xx responses from the cache (see bug 759043).
    NS_ENSURE_TRUE((mCachedResponseHead->Status() / 100 != 3) ||
                   isCachedRedirect, NS_ERROR_ABORT);

    if (mCachedResponseHead->NoStore() && mCacheEntryIsReadOnly) {
        // This prevents loading no-store responses when navigating back
        // while the browser is set to work offline.
        LOG(("  entry loading as read-only but is no-store, set INHIBIT_CACHING"));
        mLoadFlags |= nsIRequest::INHIBIT_CACHING;
    }

    // Don't bother to validate items that are read-only,
    // unless they are read-only because of INHIBIT_CACHING or because
    // we're updating the offline cache.
    // Don't bother to validate if this is a fallback entry.
    if (!mApplicationCacheForWrite &&
        (appCache ||
         (mCacheEntryIsReadOnly && !(mLoadFlags & nsIRequest::INHIBIT_CACHING)) ||
         mFallbackChannel)) {
        rv = OpenCacheInputStream(entry, true, !!appCache);
        if (NS_SUCCEEDED(rv)) {
            mCachedContentIsValid = true;
            entry->MaybeMarkValid();
        }
        return rv;
    }

    bool wantCompleteEntry = false;

    if (!methodWasHead && !isCachedRedirect) {
        // If the cached content-length is set and it does not match the data
        // size of the cached content, then the cached response is partial...
        // either we need to issue a byte range request or we need to refetch
        // the entire document.
        //
        // We exclude redirects from this check because we (usually) strip the
        // entity when we store the cache entry, and even if we didn't, we
        // always ignore a cached redirect's entity anyway. See bug 759043.
        int64_t size, contentLength;
        rv = CheckPartial(entry, &size, &contentLength);
        NS_ENSURE_SUCCESS(rv,rv);

        if (size == int64_t(-1)) {
            LOG(("  write is in progress"));
            if (mLoadFlags & LOAD_BYPASS_LOCAL_CACHE_IF_BUSY) {
                LOG(("  not interested in the entry, "
                     "LOAD_BYPASS_LOCAL_CACHE_IF_BUSY specified"));

                *aResult = ENTRY_NOT_WANTED;
                return NS_OK;
            }

            // Ignore !(size > 0) from the resumability condition
            if (!IsResumable(size, contentLength, true)) {
                LOG(("  wait for entry completion, "
                     "response is not resumable"));

                wantCompleteEntry = true;
            }
            else {
                mConcurrentCacheAccess = 1;
            }
        }
        else if (contentLength != int64_t(-1) && contentLength != size) {
            LOG(("Cached data size does not match the Content-Length header "
                 "[content-length=%lld size=%lld]\n", contentLength, size));

            rv = MaybeSetupByteRangeRequest(size, contentLength);
            mCachedContentIsPartial = NS_SUCCEEDED(rv) && mIsPartialRequest;
            if (mCachedContentIsPartial) {
                rv = OpenCacheInputStream(entry, false, !!appCache);
                if (NS_FAILED(rv)) {
                    UntieByteRangeRequest();
                    return rv;
                }

                *aResult = ENTRY_NEEDS_REVALIDATION;
                return NS_OK;
            }

            if (size == 0 && mCacheOnlyMetadata) {
                // Don't break cache entry load when the entry's data size
                // is 0 and mCacheOnlyMetadata flag is set. In that case we
                // want to proceed since the LOAD_ONLY_IF_MODIFIED flag is
                // also set.
                MOZ_ASSERT(mLoadFlags & LOAD_ONLY_IF_MODIFIED);
            } else if (mInterceptCache != INTERCEPTED) {
                return rv;
            }
        }
    }

    bool isHttps = false;
    rv = mURI->SchemeIs("https", &isHttps);
    NS_ENSURE_SUCCESS(rv,rv);

    bool doValidation = false;
    bool canAddImsHeader = true;

    bool isForcedValid = false;
    entry->GetIsForcedValid(&isForcedValid);

    nsXPIDLCString framedBuf;
    rv = entry->GetMetaDataElement("strongly-framed", getter_Copies(framedBuf));
    // describe this in terms of explicitly weakly framed so as to be backwards
    // compatible with old cache contents which dont have strongly-framed makers
    bool weaklyFramed = NS_SUCCEEDED(rv) && framedBuf.EqualsLiteral("0");
    bool isImmutable = !weaklyFramed && isHttps && mCachedResponseHead->Immutable();

    // Cached entry is not the entity we request (see bug #633743)
    if (ResponseWouldVary(entry)) {
        LOG(("Validating based on Vary headers returning TRUE\n"));
        canAddImsHeader = false;
        doValidation = true;
    }
    // Check isForcedValid to see if it is possible to skip validation.
    // Don't skip validation if we have serious reason to believe that this
    // content is invalid (it's expired).
    // See netwerk/cache2/nsICacheEntry.idl for details
    else if (isForcedValid &&
             (!mCachedResponseHead->ExpiresInPast() ||
              !mCachedResponseHead->MustValidateIfExpired())) {
        LOG(("NOT validating based on isForcedValid being true.\n"));
        Telemetry::AutoCounter<Telemetry::PREDICTOR_TOTAL_PREFETCHES_USED> used;
        ++used;
        doValidation = false;
    }
    // If the LOAD_FROM_CACHE flag is set, any cached data can simply be used
    else if (mLoadFlags & nsIRequest::LOAD_FROM_CACHE || mAllowStaleCacheContent) {
        LOG(("NOT validating based on LOAD_FROM_CACHE load flag\n"));
        doValidation = false;
    }
    // If the VALIDATE_ALWAYS flag is set, any cached data won't be used until
    // it's revalidated with the server.
    else if ((mLoadFlags & nsIRequest::VALIDATE_ALWAYS) && !isImmutable) {
        LOG(("Validating based on VALIDATE_ALWAYS load flag\n"));
        doValidation = true;
    }
    // Even if the VALIDATE_NEVER flag is set, there are still some cases in
    // which we must validate the cached response with the server.
    else if (mLoadFlags & nsIRequest::VALIDATE_NEVER) {
        LOG(("VALIDATE_NEVER set\n"));
        // if no-store validate cached response (see bug 112564)
        if (mCachedResponseHead->NoStore()) {
            LOG(("Validating based on no-store logic\n"));
            doValidation = true;
        }
        else {
            LOG(("NOT validating based on VALIDATE_NEVER load flag\n"));
            doValidation = false;
        }
    }
    // check if validation is strictly required...
    else if (mCachedResponseHead->MustValidate()) {
        LOG(("Validating based on MustValidate() returning TRUE\n"));
        doValidation = true;
    } else {
        // previously we also checked for a query-url w/out expiration
        // and didn't do heuristic on it. but defacto that is allowed now.
        //
        // Check if the cache entry has expired...

        uint32_t now = NowInSeconds();

        uint32_t age = 0;
        rv = mCachedResponseHead->ComputeCurrentAge(now, now, &age);
        NS_ENSURE_SUCCESS(rv, rv);

        uint32_t freshness = 0;
        rv = mCachedResponseHead->ComputeFreshnessLifetime(&freshness);
        NS_ENSURE_SUCCESS(rv, rv);

        uint32_t expiration = 0;
        rv = entry->GetExpirationTime(&expiration);
        NS_ENSURE_SUCCESS(rv, rv);

        uint32_t maxAgeRequest, maxStaleRequest, minFreshRequest;

        LOG(("  NowInSeconds()=%u, expiration time=%u, freshness lifetime=%u, age=%u",
             now, expiration, freshness, age));

        if (cacheControlRequest.NoCache()) {
            LOG(("  validating, no-cache request"));
            doValidation = true;
        } else if (cacheControlRequest.MaxStale(&maxStaleRequest)) {
            uint32_t staleTime = age > freshness ? age - freshness : 0;
            doValidation = staleTime > maxStaleRequest;
            LOG(("  validating=%d, max-stale=%u requested", doValidation, maxStaleRequest));
        } else if (cacheControlRequest.MaxAge(&maxAgeRequest)) {
            doValidation = age > maxAgeRequest;
            LOG(("  validating=%d, max-age=%u requested", doValidation, maxAgeRequest));
        } else if (cacheControlRequest.MinFresh(&minFreshRequest)) {
            uint32_t freshTime = freshness > age ? freshness - age : 0;
            doValidation = freshTime < minFreshRequest;
            LOG(("  validating=%d, min-fresh=%u requested", doValidation, minFreshRequest));
        } else if (now <= expiration) {
            doValidation = false;
            LOG(("  not validating, expire time not in the past"));
        } else if (mCachedResponseHead->MustValidateIfExpired()) {
            doValidation = true;
        } else if (mLoadFlags & nsIRequest::VALIDATE_ONCE_PER_SESSION) {
            // If the cached response does not include expiration infor-
            // mation, then we must validate the response, despite whether
            // or not this is the first access this session.  This behavior
            // is consistent with existing browsers and is generally expected
            // by web authors.
            if (freshness == 0)
                doValidation = true;
            else
                doValidation = fromPreviousSession;
        }
        else
            doValidation = true;

        LOG(("%salidating based on expiration time\n", doValidation ? "V" : "Not v"));
    }


    // If a content signature is expected to be valid in this load,
    // set doValidation to force a signature check.
    if (!doValidation &&
        mLoadInfo && mLoadInfo->GetVerifySignedContent()) {
        doValidation = true;
    }

    nsAutoCString requestedETag;
    if (!doValidation &&
        NS_SUCCEEDED(mRequestHead.GetHeader(nsHttp::If_Match, requestedETag)) &&
        (methodWasGet || methodWasHead)) {
        nsAutoCString cachedETag;
        mCachedResponseHead->GetHeader(nsHttp::ETag, cachedETag);
        if (!cachedETag.IsEmpty() &&
            (StringBeginsWith(cachedETag, NS_LITERAL_CSTRING("W/")) ||
             !requestedETag.Equals(cachedETag))) {
            // User has defined If-Match header, if the cached entry is not
            // matching the provided header value or the cached ETag is weak,
            // force validation.
            doValidation = true;
        }
    }

    if (!doValidation) {
        //
        // Check the authorization headers used to generate the cache entry.
        // We must validate the cache entry if:
        //
        // 1) the cache entry was generated prior to this session w/
        //    credentials (see bug 103402).
        // 2) the cache entry was generated w/o credentials, but would now
        //    require credentials (see bug 96705).
        //
        // NOTE: this does not apply to proxy authentication.
        //
        entry->GetMetaDataElement("auth", getter_Copies(buf));
        doValidation =
            (fromPreviousSession && !buf.IsEmpty()) ||
            (buf.IsEmpty() && mRequestHead.HasHeader(nsHttp::Authorization));
    }

    // Bug #561276: We maintain a chain of cache-keys which returns cached
    // 3xx-responses (redirects) in order to detect cycles. If a cycle is
    // found, ignore the cached response and hit the net. Otherwise, use
    // the cached response and add the cache-key to the chain. Note that
    // a limited number of redirects (cached or not) is allowed and is
    // enforced independently of this mechanism
    if (!doValidation && isCachedRedirect) {
        nsAutoCString cacheKey;
        GenerateCacheKey(mPostID, cacheKey);

        if (!mRedirectedCachekeys)
            mRedirectedCachekeys = new nsTArray<nsCString>();
        else if (mRedirectedCachekeys->Contains(cacheKey))
            doValidation = true;

        LOG(("Redirection-chain %s key %s\n",
             doValidation ? "contains" : "does not contain", cacheKey.get()));

        // Append cacheKey if not in the chain already
        if (!doValidation)
            mRedirectedCachekeys->AppendElement(cacheKey);
    }

    if (doValidation && mInterceptCache == INTERCEPTED) {
        doValidation = false;
    }

    mCachedContentIsValid = !doValidation;

    if (doValidation) {
        //
        // now, we are definitely going to issue a HTTP request to the server.
        // make it conditional if possible.
        //
        // do not attempt to validate no-store content, since servers will not
        // expect it to be cached.  (we only keep it in our cache for the
        // purposes of back/forward, etc.)
        //
        // the request method MUST be either GET or HEAD (see bug 175641) and
        // the cached response code must be < 400
        //
        // the cached content must not be weakly framed or marked immutable
        //
        // do not override conditional headers when consumer has defined its own
        if (!mCachedResponseHead->NoStore() &&
            (mRequestHead.IsGet() || mRequestHead.IsHead()) &&
            !mCustomConditionalRequest && !weaklyFramed && !isImmutable &&
            (mCachedResponseHead->Status() < 400)) {

            if (mConcurrentCacheAccess) {
                // In case of concurrent read and also validation request we
                // must wait for the current writer to close the output stream
                // first.  Otherwise, when the writer's job would have been interrupted
                // before all the data were downloaded, we'd have to do a range request
                // which would be a second request in line during this channel's
                // life-time.  nsHttpChannel is not designed to do that, so rather
                // turn off concurrent read and wait for entry's completion.
                // Then only re-validation or range-re-validation request will go out.
                mConcurrentCacheAccess = 0;
                // This will cause that OnCacheEntryCheck is called again with the same
                // entry after the writer is done.
                wantCompleteEntry = true;
            } else {
                nsAutoCString val;
                // Add If-Modified-Since header if a Last-Modified was given
                // and we are allowed to do this (see bugs 510359 and 269303)
                if (canAddImsHeader) {
                    mCachedResponseHead->GetHeader(nsHttp::Last_Modified, val);
                    if (!val.IsEmpty())
                        mRequestHead.SetHeader(nsHttp::If_Modified_Since, val);
                }
                // Add If-None-Match header if an ETag was given in the response
                mCachedResponseHead->GetHeader(nsHttp::ETag, val);
                if (!val.IsEmpty())
                    mRequestHead.SetHeader(nsHttp::If_None_Match, val);
                mDidReval = true;
            }
        }
    }

    if (mCachedContentIsValid || mDidReval) {
        rv = OpenCacheInputStream(entry, mCachedContentIsValid, !!appCache);
        if (NS_FAILED(rv)) {
            // If we can't get the entity then we have to act as though we
            // don't have the cache entry.
            if (mDidReval) {
                UntieValidationRequest();
                mDidReval = false;
            }
            mCachedContentIsValid = false;
        }
    }

    if (mDidReval)
        *aResult = ENTRY_NEEDS_REVALIDATION;
    else if (wantCompleteEntry)
        *aResult = RECHECK_AFTER_WRITE_FINISHED;
    else
        *aResult = ENTRY_WANTED;

    if (mCachedContentIsValid) {
        entry->MaybeMarkValid();
    }

    LOG(("nsHTTPChannel::OnCacheEntryCheck exit [this=%p doValidation=%d result=%d]\n",
         this, doValidation, *aResult));
    return rv;
}

NS_IMETHODIMP
nsHttpChannel::OnCacheEntryAvailable(nsICacheEntry *entry,
                                     bool aNew,
                                     nsIApplicationCache* aAppCache,
                                     nsresult status)
{
    MOZ_ASSERT(NS_IsMainThread());

    nsresult rv;

    LOG(("nsHttpChannel::OnCacheEntryAvailable [this=%p entry=%p "
         "new=%d appcache=%p status=%x mAppCache=%p mAppCacheForWrite=%p]\n",
         this, entry, aNew, aAppCache, status,
         mApplicationCache.get(), mApplicationCacheForWrite.get()));

    // if the channel's already fired onStopRequest, then we should ignore
    // this event.
    if (!mIsPending) {
        mCacheInputStream.CloseAndRelease();
        return NS_OK;
    }

    rv = OnCacheEntryAvailableInternal(entry, aNew, aAppCache, status);
    if (NS_FAILED(rv)) {
        CloseCacheEntry(false);
        AsyncAbort(rv);
    }

    return NS_OK;
}

nsresult
nsHttpChannel::OnCacheEntryAvailableInternal(nsICacheEntry *entry,
                                             bool aNew,
                                             nsIApplicationCache* aAppCache,
                                             nsresult status)
{
    nsresult rv;

    if (mCanceled) {
        LOG(("channel was canceled [this=%p status=%x]\n", this, mStatus));
        return mStatus;
    }

    if (aAppCache) {
        if (mApplicationCache == aAppCache && !mCacheEntry) {
            rv = OnOfflineCacheEntryAvailable(entry, aNew, aAppCache, status);
        }
        else if (mApplicationCacheForWrite == aAppCache && aNew && !mOfflineCacheEntry) {
            rv = OnOfflineCacheEntryForWritingAvailable(entry, aAppCache, status);
        }
        else {
            rv = OnOfflineCacheEntryAvailable(entry, aNew, aAppCache, status);
        }
    }
    else {
        rv = OnNormalCacheEntryAvailable(entry, aNew, status);
    }

    if (NS_FAILED(rv) && (mLoadFlags & LOAD_ONLY_FROM_CACHE)) {
        // If we have a fallback URI (and we're not already
        // falling back), process the fallback asynchronously.
        if (!mFallbackChannel && !mFallbackKey.IsEmpty()) {
            return AsyncCall(&nsHttpChannel::HandleAsyncFallback);
        }

        return NS_ERROR_DOCUMENT_NOT_CACHED;
    }

    if (NS_FAILED(rv)) {
        return rv;
    }

    // We may be waiting for more callbacks...
    if (AwaitingCacheCallbacks()) {
        return NS_OK;
    }

    return TryHSTSPriming();
}

nsresult
nsHttpChannel::OnNormalCacheEntryAvailable(nsICacheEntry *aEntry,
                                           bool aNew,
                                           nsresult aEntryStatus)
{
    mCacheEntriesToWaitFor &= ~WAIT_FOR_CACHE_ENTRY;

    if (NS_FAILED(aEntryStatus) || aNew) {
        // Make sure this flag is dropped.  It may happen the entry is doomed
        // between OnCacheEntryCheck and OnCacheEntryAvailable.
        mCachedContentIsValid = false;

        // From the same reason remove any conditional headers added
        // in OnCacheEntryCheck.
        if (mDidReval) {
            LOG(("  Removing conditional request headers"));
            UntieValidationRequest();
            mDidReval = false;
        }

        if (mLoadFlags & LOAD_ONLY_FROM_CACHE) {
            // if this channel is only allowed to pull from the cache, then
            // we must fail if we were unable to open a cache entry for read.
            return NS_ERROR_DOCUMENT_NOT_CACHED;
        }
    }

    if (NS_SUCCEEDED(aEntryStatus)) {
        mCacheEntry = aEntry;
        mCacheEntryIsWriteOnly = aNew;

        if (mLoadFlags & LOAD_INITIAL_DOCUMENT_URI) {
            Telemetry::Accumulate(Telemetry::HTTP_OFFLINE_CACHE_DOCUMENT_LOAD,
                                  false);
        }
    }

    return NS_OK;
}

nsresult
nsHttpChannel::OnOfflineCacheEntryAvailable(nsICacheEntry *aEntry,
                                            bool aNew,
                                            nsIApplicationCache* aAppCache,
                                            nsresult aEntryStatus)
{
    MOZ_ASSERT(!mApplicationCache || aAppCache == mApplicationCache);
    MOZ_ASSERT(!aNew || !aEntry || mApplicationCacheForWrite);

    mCacheEntriesToWaitFor &= ~WAIT_FOR_CACHE_ENTRY;

    nsresult rv;

    if (NS_SUCCEEDED(aEntryStatus)) {
        if (!mApplicationCache) {
            mApplicationCache = aAppCache;
        }

        // We successfully opened an offline cache session and the entry,
        // so indicate we will load from the offline cache.
        mLoadedFromApplicationCache = true;
        mCacheEntryIsReadOnly = true;
        mCacheEntry = aEntry;
        mCacheEntryIsWriteOnly = false;

        if (mLoadFlags & LOAD_INITIAL_DOCUMENT_URI && !mApplicationCacheForWrite) {
            MaybeWarnAboutAppCache();
        }

        return NS_OK;
    }

    if (!mApplicationCacheForWrite && !mFallbackChannel) {
        if (!mApplicationCache) {
            mApplicationCache = aAppCache;
        }

        // Check for namespace match.
        nsCOMPtr<nsIApplicationCacheNamespace> namespaceEntry;
        rv = mApplicationCache->GetMatchingNamespace(mSpec,
            getter_AddRefs(namespaceEntry));
        NS_ENSURE_SUCCESS(rv, rv);

        uint32_t namespaceType = 0;
        if (!namespaceEntry ||
            NS_FAILED(namespaceEntry->GetItemType(&namespaceType)) ||
            (namespaceType &
             (nsIApplicationCacheNamespace::NAMESPACE_FALLBACK |
              nsIApplicationCacheNamespace::NAMESPACE_BYPASS)) == 0) {
            // When loading from an application cache, only items
            // on the whitelist or matching a
            // fallback namespace should hit the network...
            mLoadFlags |= LOAD_ONLY_FROM_CACHE;

            // ... and if there were an application cache entry,
            // we would have found it earlier.
            return NS_ERROR_CACHE_KEY_NOT_FOUND;
        }

        if (namespaceType &
            nsIApplicationCacheNamespace::NAMESPACE_FALLBACK) {
            rv = namespaceEntry->GetData(mFallbackKey);
            NS_ENSURE_SUCCESS(rv, rv);
        }
    }

    return NS_OK;
}

nsresult
nsHttpChannel::OnOfflineCacheEntryForWritingAvailable(nsICacheEntry *aEntry,
                                                      nsIApplicationCache* aAppCache,
                                                      nsresult aEntryStatus)
{
    MOZ_ASSERT(mApplicationCacheForWrite && aAppCache == mApplicationCacheForWrite);

    mCacheEntriesToWaitFor &= ~WAIT_FOR_OFFLINE_CACHE_ENTRY;

    if (NS_SUCCEEDED(aEntryStatus)) {
        mOfflineCacheEntry = aEntry;
        if (NS_FAILED(aEntry->GetLastModified(&mOfflineCacheLastModifiedTime))) {
            mOfflineCacheLastModifiedTime = 0;
        }
    }

    return aEntryStatus;
}

// Generates the proper cache-key for this instance of nsHttpChannel
nsresult
nsHttpChannel::GenerateCacheKey(uint32_t postID, nsACString &cacheKey)
{
    AssembleCacheKey(mFallbackChannel ? mFallbackKey.get() : mSpec.get(),
                     postID, cacheKey);
    return NS_OK;
}

// Assembles a cache-key from the given pieces of information and |mLoadFlags|
void
nsHttpChannel::AssembleCacheKey(const char *spec, uint32_t postID,
                                nsACString &cacheKey)
{
    cacheKey.Truncate();

    if (mLoadFlags & LOAD_ANONYMOUS) {
        cacheKey.AssignLiteral("anon&");
    }

    if (postID) {
        char buf[32];
        SprintfLiteral(buf, "id=%x&", postID);
        cacheKey.Append(buf);
    }

    if (!cacheKey.IsEmpty()) {
        cacheKey.AppendLiteral("uri=");
    }

    // Strip any trailing #ref from the URL before using it as the key
    const char *p = strchr(spec, '#');
    if (p)
        cacheKey.Append(spec, p - spec);
    else
        cacheKey.Append(spec);
}

nsresult
DoUpdateExpirationTime(nsHttpChannel* aSelf,
                       nsICacheEntry* aCacheEntry,
                       nsHttpResponseHead* aResponseHead,
                       uint32_t& aExpirationTime)
{
    MOZ_ASSERT(aExpirationTime == 0);
    NS_ENSURE_TRUE(aResponseHead, NS_ERROR_FAILURE);

    nsresult rv;

    if (!aResponseHead->MustValidate()) {
        uint32_t freshnessLifetime = 0;

        rv = aResponseHead->ComputeFreshnessLifetime(&freshnessLifetime);
        if (NS_FAILED(rv)) return rv;

        if (freshnessLifetime > 0) {
            uint32_t now = NowInSeconds(), currentAge = 0;

            rv = aResponseHead->ComputeCurrentAge(now, aSelf->GetRequestTime(), &currentAge);
            if (NS_FAILED(rv)) return rv;

            LOG(("freshnessLifetime = %u, currentAge = %u\n",
                freshnessLifetime, currentAge));

            if (freshnessLifetime > currentAge) {
                uint32_t timeRemaining = freshnessLifetime - currentAge;
                // be careful... now + timeRemaining may overflow
                if (now + timeRemaining < now)
                    aExpirationTime = uint32_t(-1);
                else
                    aExpirationTime = now + timeRemaining;
            }
            else
                aExpirationTime = now;
        }
    }

    rv = aCacheEntry->SetExpirationTime(aExpirationTime);
    NS_ENSURE_SUCCESS(rv, rv);

    return rv;
}

// UpdateExpirationTime is called when a new response comes in from the server.
// It updates the stored response-time and sets the expiration time on the
// cache entry.
//
// From section 13.2.4 of RFC2616, we compute expiration time as follows:
//
//    timeRemaining = freshnessLifetime - currentAge
//    expirationTime = now + timeRemaining
//
nsresult
nsHttpChannel::UpdateExpirationTime()
{
    uint32_t expirationTime = 0;
    nsresult rv = DoUpdateExpirationTime(this, mCacheEntry, mResponseHead, expirationTime);
    NS_ENSURE_SUCCESS(rv, rv);

    if (mOfflineCacheEntry) {
        rv = mOfflineCacheEntry->SetExpirationTime(expirationTime);
        NS_ENSURE_SUCCESS(rv, rv);
    }

    return NS_OK;
}

/*static*/ inline bool
nsHttpChannel::HasQueryString(nsHttpRequestHead::ParsedMethodType method, nsIURI * uri)
{
    // Must be called on the main thread because nsIURI does not implement
    // thread-safe QueryInterface.
    MOZ_ASSERT(NS_IsMainThread());

    if (method != nsHttpRequestHead::kMethod_Get &&
        method != nsHttpRequestHead::kMethod_Head)
        return false;

    nsAutoCString query;
    nsCOMPtr<nsIURL> url = do_QueryInterface(uri);
    nsresult rv = url->GetQuery(query);
    return NS_SUCCEEDED(rv) && !query.IsEmpty();
}

bool
nsHttpChannel::ShouldUpdateOfflineCacheEntry()
{
    if (!mApplicationCacheForWrite || !mOfflineCacheEntry) {
        return false;
    }

    // if we're updating the cache entry, update the offline cache entry too
    if (mCacheEntry && mCacheEntryIsWriteOnly) {
        return true;
    }

    // if there's nothing in the offline cache, add it
    if (mOfflineCacheEntry) {
        return true;
    }

    // if the document is newer than the offline entry, update it
    uint32_t docLastModifiedTime;
    nsresult rv = mResponseHead->GetLastModifiedValue(&docLastModifiedTime);
    if (NS_FAILED(rv)) {
        return true;
    }

    if (mOfflineCacheLastModifiedTime == 0) {
        return false;
    }

    if (docLastModifiedTime > mOfflineCacheLastModifiedTime) {
        return true;
    }

    return false;
}

nsresult
nsHttpChannel::OpenCacheInputStream(nsICacheEntry* cacheEntry, bool startBuffering,
                                    bool checkingAppCacheEntry)
{
    nsresult rv;

    bool isHttps = false;
    rv = mURI->SchemeIs("https", &isHttps);
    NS_ENSURE_SUCCESS(rv,rv);

    if (isHttps) {
        rv = cacheEntry->GetSecurityInfo(
                                      getter_AddRefs(mCachedSecurityInfo));
        if (NS_FAILED(rv)) {
            LOG(("failed to parse security-info [channel=%p, entry=%p]",
                 this, cacheEntry));
            NS_WARNING("failed to parse security-info");
            cacheEntry->AsyncDoom(nullptr);
            return rv;
        }

        // XXX: We should not be skilling this check in the offline cache
        // case, but we have to do so now to work around bug 794507.
        bool mustHaveSecurityInfo = !mLoadedFromApplicationCache && !checkingAppCacheEntry;
        MOZ_ASSERT(mCachedSecurityInfo || !mustHaveSecurityInfo);
        if (!mCachedSecurityInfo && mustHaveSecurityInfo) {
            LOG(("mCacheEntry->GetSecurityInfo returned success but did not "
                 "return the security info [channel=%p, entry=%p]",
                 this, cacheEntry));
            cacheEntry->AsyncDoom(nullptr);
            return NS_ERROR_UNEXPECTED; // XXX error code
        }
    }

    // Keep the conditions below in sync with the conditions in ReadFromCache.

    rv = NS_OK;

    if (WillRedirect(mCachedResponseHead)) {
        // Do not even try to read the entity for a redirect because we do not
        // return an entity to the application when we process redirects.
        LOG(("Will skip read of cached redirect entity\n"));
        return NS_OK;
    }

    if ((mLoadFlags & nsICachingChannel::LOAD_ONLY_IF_MODIFIED) &&
        !mCachedContentIsPartial) {
        // For LOAD_ONLY_IF_MODIFIED, we usually don't have to deal with the
        // cached entity.
        if (!mApplicationCacheForWrite) {
            LOG(("Will skip read from cache based on LOAD_ONLY_IF_MODIFIED "
                 "load flag\n"));
            return NS_OK;
        }

        // If offline caching has been requested and the offline cache needs
        // updating, we must complete the call even if the main cache entry
        // is up to date. We don't know yet for sure whether the offline
        // cache needs updating because at this point we haven't opened it
        // for writing yet, so we have to start reading the cached entity now
        // just in case.
        LOG(("May skip read from cache based on LOAD_ONLY_IF_MODIFIED "
              "load flag\n"));
    }

    // Open an input stream for the entity, so that the call to OpenInputStream
    // happens off the main thread.
    nsCOMPtr<nsIInputStream> stream;

    // If an alternate representation was requested, try to open the alt
    // input stream.
    if (!mPreferredCachedAltDataType.IsEmpty()) {
        rv = cacheEntry->OpenAlternativeInputStream(mPreferredCachedAltDataType,
                                                    getter_AddRefs(stream));
        if (NS_SUCCEEDED(rv)) {
            // We have succeeded.
            mAvailableCachedAltDataType = mPreferredCachedAltDataType;
            // Clear the header.
            mCachedResponseHead->SetContentLength(-1);
            // Set the correct data size on the channel.
            int64_t altDataSize;
            if (NS_SUCCEEDED(cacheEntry->GetAltDataSize(&altDataSize))) {
                mCachedResponseHead->SetContentLength(altDataSize);
            }
        }
    }

    if (!stream) {
        rv = cacheEntry->OpenInputStream(0, getter_AddRefs(stream));
    }

    if (NS_FAILED(rv)) {
        LOG(("Failed to open cache input stream [channel=%p, "
             "mCacheEntry=%p]", this, cacheEntry));
        return rv;
    }

    if (startBuffering) {
        bool nonBlocking;
        rv = stream->IsNonBlocking(&nonBlocking);
        if (NS_SUCCEEDED(rv) && nonBlocking)
            startBuffering = false;
    }

    if (!startBuffering) {
        // Bypass wrapping the input stream for the new cache back-end since
        // nsIStreamTransportService expects a blocking stream.  Preloading of
        // the data must be done on the level of the cache backend, internally.
        //
        // We do not connect the stream to the stream transport service if we
        // have to validate the entry with the server. If we did, we would get
        // into a race condition between the stream transport service reading
        // the existing contents and the opening of the cache entry's output
        // stream to write the new contents in the case where we get a non-304
        // response.
        LOG(("Opened cache input stream without buffering [channel=%p, "
              "mCacheEntry=%p, stream=%p]", this,
              cacheEntry, stream.get()));
        mCacheInputStream.takeOver(stream);
        return rv;
    }

    // Have the stream transport service start reading the entity on one of its
    // background threads.

    nsCOMPtr<nsITransport> transport;
    nsCOMPtr<nsIInputStream> wrapper;

    nsCOMPtr<nsIStreamTransportService> sts =
        do_GetService(kStreamTransportServiceCID, &rv);
    if (NS_SUCCEEDED(rv)) {
        rv = sts->CreateInputTransport(stream, int64_t(-1), int64_t(-1),
                                        true, getter_AddRefs(transport));
    }
    if (NS_SUCCEEDED(rv)) {
        rv = transport->OpenInputStream(0, 0, 0, getter_AddRefs(wrapper));
    }
    if (NS_SUCCEEDED(rv)) {
        LOG(("Opened cache input stream [channel=%p, wrapper=%p, "
              "transport=%p, stream=%p]", this, wrapper.get(),
              transport.get(), stream.get()));
    } else {
        LOG(("Failed to open cache input stream [channel=%p, "
              "wrapper=%p, transport=%p, stream=%p]", this,
              wrapper.get(), transport.get(), stream.get()));

        stream->Close();
        return rv;
    }

    mCacheInputStream.takeOver(wrapper);

    return NS_OK;
}

// Actually process the cached response that we started to handle in CheckCache
// and/or StartBufferingCachedEntity.
nsresult
nsHttpChannel::ReadFromCache(bool alreadyMarkedValid)
{
    NS_ENSURE_TRUE(mCacheEntry, NS_ERROR_FAILURE);
    NS_ENSURE_TRUE(mCachedContentIsValid, NS_ERROR_FAILURE);

    LOG(("nsHttpChannel::ReadFromCache [this=%p] "
         "Using cached copy of: %s\n", this, mSpec.get()));

    if (mCachedResponseHead)
        mResponseHead = Move(mCachedResponseHead);

    UpdateInhibitPersistentCachingFlag();

    // if we don't already have security info, try to get it from the cache
    // entry. there are two cases to consider here: 1) we are just reading
    // from the cache, or 2) this may be due to a 304 not modified response,
    // in which case we could have security info from a socket transport.
    if (!mSecurityInfo)
        mSecurityInfo = mCachedSecurityInfo;

    if (!alreadyMarkedValid && !mCachedContentIsPartial) {
        // We validated the entry, and we have write access to the cache, so
        // mark the cache entry as valid in order to allow others access to
        // this cache entry.
        //
        // TODO: This should be done asynchronously so we don't take the cache
        // service lock on the main thread.
        mCacheEntry->MaybeMarkValid();
    }

    nsresult rv;

    // Keep the conditions below in sync with the conditions in
    // StartBufferingCachedEntity.

    if (WillRedirect(mResponseHead)) {
        // TODO: Bug 759040 - We should call HandleAsyncRedirect directly here,
        // to avoid event dispatching latency.
        MOZ_ASSERT(!mCacheInputStream);
        LOG(("Skipping skip read of cached redirect entity\n"));
        return AsyncCall(&nsHttpChannel::HandleAsyncRedirect);
    }

    if ((mLoadFlags & LOAD_ONLY_IF_MODIFIED) && !mCachedContentIsPartial) {
        if (!mApplicationCacheForWrite) {
            LOG(("Skipping read from cache based on LOAD_ONLY_IF_MODIFIED "
                 "load flag\n"));
            MOZ_ASSERT(!mCacheInputStream);
            // TODO: Bug 759040 - We should call HandleAsyncNotModified directly
            // here, to avoid event dispatching latency.
            return AsyncCall(&nsHttpChannel::HandleAsyncNotModified);
        }

        if (!ShouldUpdateOfflineCacheEntry()) {
            LOG(("Skipping read from cache based on LOAD_ONLY_IF_MODIFIED "
                 "load flag (mApplicationCacheForWrite not null case)\n"));
            mCacheInputStream.CloseAndRelease();
            // TODO: Bug 759040 - We should call HandleAsyncNotModified directly
            // here, to avoid event dispatching latency.
            return AsyncCall(&nsHttpChannel::HandleAsyncNotModified);
        }
    }

    MOZ_ASSERT(mCacheInputStream);
    if (!mCacheInputStream) {
        NS_ERROR("mCacheInputStream is null but we're expecting to "
                        "be able to read from it.");
        return NS_ERROR_UNEXPECTED;
    }


    nsCOMPtr<nsIInputStream> inputStream = mCacheInputStream.forget();

    rv = nsInputStreamPump::Create(getter_AddRefs(mCachePump), inputStream,
                                   int64_t(-1), int64_t(-1), 0, 0, true);
    if (NS_FAILED(rv)) {
        inputStream->Close();
        return rv;
    }

    rv = mCachePump->AsyncRead(this, mListenerContext);
    if (NS_FAILED(rv)) return rv;

    if (mTimingEnabled)
        mCacheReadStart = TimeStamp::Now();

    uint32_t suspendCount = mSuspendCount;
    while (suspendCount--)
        mCachePump->Suspend();

    return NS_OK;
}

void
nsHttpChannel::CloseCacheEntry(bool doomOnFailure)
{
    mCacheInputStream.CloseAndRelease();

    if (!mCacheEntry)
        return;

    LOG(("nsHttpChannel::CloseCacheEntry [this=%p] mStatus=%x mCacheEntryIsWriteOnly=%x",
         this, mStatus, mCacheEntryIsWriteOnly));

    // If we have begun to create or replace a cache entry, and that cache
    // entry is not complete and not resumable, then it needs to be doomed.
    // Otherwise, CheckCache will make the mistake of thinking that the
    // partial cache entry is complete.

    bool doom = false;
    if (mInitedCacheEntry) {
        MOZ_ASSERT(mResponseHead, "oops");
        if (NS_FAILED(mStatus) && doomOnFailure &&
            mCacheEntryIsWriteOnly && !mResponseHead->IsResumable())
            doom = true;
    }
    else if (mCacheEntryIsWriteOnly)
        doom = true;

    if (doom) {
        LOG(("  dooming cache entry!!"));
        mCacheEntry->AsyncDoom(nullptr);
    } else {
      // Store updated security info, makes cached EV status race less likely
      // (see bug 1040086)
      if (mSecurityInfo)
          mCacheEntry->SetSecurityInfo(mSecurityInfo);
    }

    mCachedResponseHead = nullptr;

    mCachePump = nullptr;
    mCacheEntry = nullptr;
    mCacheEntryIsWriteOnly = false;
    mInitedCacheEntry = false;
}


void
nsHttpChannel::CloseOfflineCacheEntry()
{
    if (!mOfflineCacheEntry)
        return;

    LOG(("nsHttpChannel::CloseOfflineCacheEntry [this=%p]", this));

    if (NS_FAILED(mStatus)) {
        mOfflineCacheEntry->AsyncDoom(nullptr);
    }
    else {
        bool succeeded;
        if (NS_SUCCEEDED(GetRequestSucceeded(&succeeded)) && !succeeded)
            mOfflineCacheEntry->AsyncDoom(nullptr);
    }

    mOfflineCacheEntry = nullptr;
}


// Initialize the cache entry for writing.
//  - finalize storage policy
//  - store security info
//  - update expiration time
//  - store headers and other meta data
nsresult
nsHttpChannel::InitCacheEntry()
{
    nsresult rv;

    NS_ENSURE_TRUE(mCacheEntry, NS_ERROR_UNEXPECTED);
    // if only reading, nothing to be done here.
    if (mCacheEntryIsReadOnly)
        return NS_OK;

    // Don't cache the response again if already cached...
    if (mCachedContentIsValid)
        return NS_OK;

    LOG(("nsHttpChannel::InitCacheEntry [this=%p entry=%p]\n",
        this, mCacheEntry.get()));

    bool recreate = !mCacheEntryIsWriteOnly;
    bool dontPersist = mLoadFlags & INHIBIT_PERSISTENT_CACHING;

    if (!recreate && dontPersist) {
        // If the current entry is persistent but we inhibit peristence
        // then force recreation of the entry as memory/only.
        rv = mCacheEntry->GetPersistent(&recreate);
        if (NS_FAILED(rv))
            return rv;
    }

    if (recreate) {
        LOG(("  we have a ready entry, but reading it again from the server -> recreating cache entry\n"));
        nsCOMPtr<nsICacheEntry> currentEntry;
        currentEntry.swap(mCacheEntry);
        rv = currentEntry->Recreate(dontPersist, getter_AddRefs(mCacheEntry));
        if (NS_FAILED(rv)) {
          LOG(("  recreation failed, the response will not be cached"));
          return NS_OK;
        }

        mCacheEntryIsWriteOnly = true;
    }

    // Set the expiration time for this cache entry
    rv = UpdateExpirationTime();
    if (NS_FAILED(rv)) return rv;

    // mark this weakly framed until a response body is seen
    mCacheEntry->SetMetaDataElement("strongly-framed", "0");

    rv = AddCacheEntryHeaders(mCacheEntry);
    if (NS_FAILED(rv)) return rv;

    mInitedCacheEntry = true;

    // Don't perform the check when writing (doesn't make sense)
    mConcurrentCacheAccess = 0;

    return NS_OK;
}

void
nsHttpChannel::UpdateInhibitPersistentCachingFlag()
{
    // The no-store directive within the 'Cache-Control:' header indicates
    // that we must not store the response in a persistent cache.
    if (mResponseHead->NoStore())
        mLoadFlags |= INHIBIT_PERSISTENT_CACHING;

    // Only cache SSL content on disk if the pref is set
    bool isHttps;
    if (!gHttpHandler->IsPersistentHttpsCachingEnabled() &&
        NS_SUCCEEDED(mURI->SchemeIs("https", &isHttps)) && isHttps) {
        mLoadFlags |= INHIBIT_PERSISTENT_CACHING;
    }
}

nsresult
nsHttpChannel::InitOfflineCacheEntry()
{
    // This function can be called even when we fail to connect (bug 551990)

    if (!mOfflineCacheEntry) {
        return NS_OK;
    }

    if (!mResponseHead || mResponseHead->NoStore()) {
        if (mResponseHead && mResponseHead->NoStore()) {
            mOfflineCacheEntry->AsyncDoom(nullptr);
        }

        CloseOfflineCacheEntry();

        if (mResponseHead && mResponseHead->NoStore()) {
            return NS_ERROR_NOT_AVAILABLE;
        }

        return NS_OK;
    }

    // This entry's expiration time should match the main entry's expiration
    // time.  UpdateExpirationTime() will keep it in sync once the offline
    // cache entry has been created.
    if (mCacheEntry) {
        uint32_t expirationTime;
        nsresult rv = mCacheEntry->GetExpirationTime(&expirationTime);
        NS_ENSURE_SUCCESS(rv, rv);

        mOfflineCacheEntry->SetExpirationTime(expirationTime);
    }

    return AddCacheEntryHeaders(mOfflineCacheEntry);
}


nsresult
DoAddCacheEntryHeaders(nsHttpChannel *self,
                       nsICacheEntry *entry,
                       nsHttpRequestHead *requestHead,
                       nsHttpResponseHead *responseHead,
                       nsISupports *securityInfo)
{
    nsresult rv;

    LOG(("nsHttpChannel::AddCacheEntryHeaders [this=%p] begin", self));
    // Store secure data in memory only
    if (securityInfo)
        entry->SetSecurityInfo(securityInfo);

    // Store the HTTP request method with the cache entry so we can distinguish
    // for example GET and HEAD responses.
    nsAutoCString method;
    requestHead->Method(method);
    rv = entry->SetMetaDataElement("request-method", method.get());
    if (NS_FAILED(rv)) return rv;

    // Store the HTTP authorization scheme used if any...
    rv = StoreAuthorizationMetaData(entry, requestHead);
    if (NS_FAILED(rv)) return rv;

    // Iterate over the headers listed in the Vary response header, and
    // store the value of the corresponding request header so we can verify
    // that it has not varied when we try to re-use the cached response at
    // a later time.  Take care to store "Cookie" headers only as hashes
    // due to security considerations and the fact that they can be pretty
    // large (bug 468426). We take care of "Vary: cookie" in ResponseWouldVary.
    //
    // NOTE: if "Vary: accept, cookie", then we will store the "accept" header
    // in the cache.  we could try to avoid needlessly storing the "accept"
    // header in this case, but it doesn't seem worth the extra code to perform
    // the check.
    {
        nsAutoCString buf, metaKey;
        responseHead->GetHeader(nsHttp::Vary, buf);
        if (!buf.IsEmpty()) {
            NS_NAMED_LITERAL_CSTRING(prefix, "request-");

            char *bufData = buf.BeginWriting(); // going to munge buf
            char *token = nsCRT::strtok(bufData, NS_HTTP_HEADER_SEPS, &bufData);
            while (token) {
                LOG(("nsHttpChannel::AddCacheEntryHeaders [this=%p] " \
                        "processing %s", self, token));
                if (*token != '*') {
                    nsHttpAtom atom = nsHttp::ResolveAtom(token);
                    nsAutoCString val;
                    nsAutoCString hash;
                    if (NS_SUCCEEDED(requestHead->GetHeader(atom, val))) {
                        // If cookie-header, store a hash of the value
                        if (atom == nsHttp::Cookie) {
                            LOG(("nsHttpChannel::AddCacheEntryHeaders [this=%p] " \
                                    "cookie-value %s", self, val.get()));
                            rv = Hash(val.get(), hash);
                            // If hash failed, store a string not very likely
                            // to be the result of subsequent hashes
                            if (NS_FAILED(rv)) {
                                val = NS_LITERAL_CSTRING("<hash failed>");
                            } else {
                                val = hash;
                            }

                            LOG(("   hashed to %s\n", val.get()));
                        }

                        // build cache meta data key and set meta data element...
                        metaKey = prefix + nsDependentCString(token);
                        entry->SetMetaDataElement(metaKey.get(), val.get());
                    } else {
                        LOG(("nsHttpChannel::AddCacheEntryHeaders [this=%p] " \
                                "clearing metadata for %s", self, token));
                        metaKey = prefix + nsDependentCString(token);
                        entry->SetMetaDataElement(metaKey.get(), nullptr);
                    }
                }
                token = nsCRT::strtok(bufData, NS_HTTP_HEADER_SEPS, &bufData);
            }
        }
    }

    // Store the received HTTP head with the cache entry as an element of
    // the meta data.
    nsAutoCString head;
    responseHead->Flatten(head, true);
    rv = entry->SetMetaDataElement("response-head", head.get());
    if (NS_FAILED(rv)) return rv;
    head.Truncate();
    responseHead->FlattenNetworkOriginalHeaders(head);
    rv = entry->SetMetaDataElement("original-response-headers", head.get());
    if (NS_FAILED(rv)) return rv;

    // Indicate we have successfully finished setting metadata on the cache entry.
    rv = entry->MetaDataReady();

    return rv;
}

nsresult
nsHttpChannel::AddCacheEntryHeaders(nsICacheEntry *entry)
{
    return DoAddCacheEntryHeaders(this, entry, &mRequestHead, mResponseHead, mSecurityInfo);
}

inline void
GetAuthType(const char *challenge, nsCString &authType)
{
    const char *p;

    // get the challenge type
    if ((p = strchr(challenge, ' ')) != nullptr)
        authType.Assign(challenge, p - challenge);
    else
        authType.Assign(challenge);
}

nsresult
StoreAuthorizationMetaData(nsICacheEntry *entry, nsHttpRequestHead *requestHead)
{
    // Not applicable to proxy authorization...
    nsAutoCString val;
    if (NS_FAILED(requestHead->GetHeader(nsHttp::Authorization, val))) {
        return NS_OK;
    }

    // eg. [Basic realm="wally world"]
    nsAutoCString buf;
    GetAuthType(val.get(), buf);
    return entry->SetMetaDataElement("auth", buf.get());
}

// Finalize the cache entry
//  - may need to rewrite response headers if any headers changed
//  - may need to recalculate the expiration time if any headers changed
//  - called only for freshly written cache entries
nsresult
nsHttpChannel::FinalizeCacheEntry()
{
    LOG(("nsHttpChannel::FinalizeCacheEntry [this=%p]\n", this));

    // Don't update this meta-data on 304
    if (mStronglyFramed && !mCachedContentIsValid && mCacheEntry) {
        LOG(("nsHttpChannel::FinalizeCacheEntry [this=%p] Is Strongly Framed\n", this));
        mCacheEntry->SetMetaDataElement("strongly-framed", "1");
    }

    if (mResponseHead && mResponseHeadersModified) {
        // Set the expiration time for this cache entry
        nsresult rv = UpdateExpirationTime();
        if (NS_FAILED(rv)) return rv;
    }
    return NS_OK;
}

// Open an output stream to the cache entry and insert a listener tee into
// the chain of response listeners.
nsresult
nsHttpChannel::InstallCacheListener(int64_t offset)
{
    nsresult rv;

    LOG(("Preparing to write data into the cache [uri=%s]\n", mSpec.get()));

    MOZ_ASSERT(mCacheEntry);
    MOZ_ASSERT(mCacheEntryIsWriteOnly || mCachedContentIsPartial);
    MOZ_ASSERT(mListener);

    nsAutoCString contentEncoding, contentType;
    mResponseHead->GetHeader(nsHttp::Content_Encoding, contentEncoding);
    mResponseHead->ContentType(contentType);
    // If the content is compressible and the server has not compressed it,
    // mark the cache entry for compression.
    if (contentEncoding.IsEmpty() &&
        (contentType.EqualsLiteral(TEXT_HTML) ||
         contentType.EqualsLiteral(TEXT_PLAIN) ||
         contentType.EqualsLiteral(TEXT_CSS) ||
         contentType.EqualsLiteral(TEXT_JAVASCRIPT) ||
         contentType.EqualsLiteral(TEXT_ECMASCRIPT) ||
         contentType.EqualsLiteral(TEXT_XML) ||
         contentType.EqualsLiteral(APPLICATION_JAVASCRIPT) ||
         contentType.EqualsLiteral(APPLICATION_ECMASCRIPT) ||
         contentType.EqualsLiteral(APPLICATION_XJAVASCRIPT) ||
         contentType.EqualsLiteral(APPLICATION_XHTML_XML))) {
        rv = mCacheEntry->SetMetaDataElement("uncompressed-len", "0");
        if (NS_FAILED(rv)) {
            LOG(("unable to mark cache entry for compression"));
        }
    }

    LOG(("Trading cache input stream for output stream [channel=%p]", this));

    // We must close the input stream first because cache entries do not
    // correctly handle having an output stream and input streams open at
    // the same time.
    mCacheInputStream.CloseAndRelease();

    nsCOMPtr<nsIOutputStream> out;
    rv = mCacheEntry->OpenOutputStream(offset, getter_AddRefs(out));
    if (rv == NS_ERROR_NOT_AVAILABLE) {
        LOG(("  entry doomed, not writing it [channel=%p]", this));
        // Entry is already doomed.
        // This may happen when expiration time is set to past and the entry
        // has been removed by the background eviction logic.
        return NS_OK;
    }
    if (NS_FAILED(rv)) return rv;

    if (mCacheOnlyMetadata) {
        LOG(("Not storing content, cacheOnlyMetadata set"));
        // We must open and then close the output stream of the cache entry.
        // This way we indicate the content has been written (despite with zero
        // length) and the entry is now in the ready state with "having data".

        out->Close();
        return NS_OK;
    }

    // XXX disk cache does not support overlapped i/o yet
#if 0
    // Mark entry valid inorder to allow simultaneous reading...
    rv = mCacheEntry->MarkValid();
    if (NS_FAILED(rv)) return rv;
#endif

    nsCOMPtr<nsIStreamListenerTee> tee =
        do_CreateInstance(kStreamListenerTeeCID, &rv);
    if (NS_FAILED(rv)) return rv;

    nsCOMPtr<nsIEventTarget> cacheIOTarget;
    if (!CacheObserver::UseNewCache()) {
        nsCOMPtr<nsICacheStorageService> serv =
            do_GetService("@mozilla.org/netwerk/cache-storage-service;1", &rv);
        NS_ENSURE_SUCCESS(rv, rv);

        serv->GetIoTarget(getter_AddRefs(cacheIOTarget));
    }

    if (!cacheIOTarget) {
        LOG(("nsHttpChannel::InstallCacheListener sync tee %p rv=%x "
             "cacheIOTarget=%p", tee.get(), rv, cacheIOTarget.get()));
        rv = tee->Init(mListener, out, nullptr);
    } else {
        LOG(("nsHttpChannel::InstallCacheListener async tee %p", tee.get()));
        rv = tee->InitAsync(mListener, cacheIOTarget, out, nullptr);
    }

    if (NS_FAILED(rv)) return rv;
    mListener = tee;
    return NS_OK;
}

nsresult
nsHttpChannel::InstallOfflineCacheListener(int64_t offset)
{
    nsresult rv;

    LOG(("Preparing to write data into the offline cache [uri=%s]\n",
         mSpec.get()));

    MOZ_ASSERT(mOfflineCacheEntry);
    MOZ_ASSERT(mListener);

    nsCOMPtr<nsIOutputStream> out;
    rv = mOfflineCacheEntry->OpenOutputStream(offset, getter_AddRefs(out));
    if (NS_FAILED(rv)) return rv;

    nsCOMPtr<nsIStreamListenerTee> tee =
        do_CreateInstance(kStreamListenerTeeCID, &rv);
    if (NS_FAILED(rv)) return rv;

    rv = tee->Init(mListener, out, nullptr);
    if (NS_FAILED(rv)) return rv;

    mListener = tee;

    return NS_OK;
}

void
nsHttpChannel::ClearBogusContentEncodingIfNeeded()
{
    // For .gz files, apache sends both a Content-Type: application/x-gzip
    // as well as Content-Encoding: gzip, which is completely wrong.  In
    // this case, we choose to ignore the rogue Content-Encoding header. We
    // must do this early on so as to prevent it from being seen up stream.
    // The same problem exists for Content-Encoding: compress in default
    // Apache installs.
    nsAutoCString contentType;
    mResponseHead->ContentType(contentType);
    if (mResponseHead->HasHeaderValue(nsHttp::Content_Encoding, "gzip") && (
        contentType.EqualsLiteral(APPLICATION_GZIP) ||
        contentType.EqualsLiteral(APPLICATION_GZIP2) ||
        contentType.EqualsLiteral(APPLICATION_GZIP3))) {
        // clear the Content-Encoding header
        mResponseHead->ClearHeader(nsHttp::Content_Encoding);
    }
    else if (mResponseHead->HasHeaderValue(nsHttp::Content_Encoding, "compress") && (
             contentType.EqualsLiteral(APPLICATION_COMPRESS) ||
             contentType.EqualsLiteral(APPLICATION_COMPRESS2))) {
        // clear the Content-Encoding header
        mResponseHead->ClearHeader(nsHttp::Content_Encoding);
    }
}

//-----------------------------------------------------------------------------
// nsHttpChannel <redirect>
//-----------------------------------------------------------------------------

nsresult
nsHttpChannel::SetupReplacementChannel(nsIURI       *newURI,
                                       nsIChannel   *newChannel,
                                       bool          preserveMethod,
                                       uint32_t      redirectFlags)
{
    LOG(("nsHttpChannel::SetupReplacementChannel "
         "[this=%p newChannel=%p preserveMethod=%d]",
         this, newChannel, preserveMethod));

    nsresult rv =
      HttpBaseChannel::SetupReplacementChannel(newURI, newChannel,
                                               preserveMethod, redirectFlags);
    if (NS_FAILED(rv))
        return rv;

    nsCOMPtr<nsIHttpChannel> httpChannel = do_QueryInterface(newChannel);
    if (!httpChannel)
        return NS_OK; // no other options to set

    // convey the mApplyConversion flag (bug 91862)
    nsCOMPtr<nsIEncodedChannel> encodedChannel = do_QueryInterface(httpChannel);
    if (encodedChannel)
        encodedChannel->SetApplyConversion(mApplyConversion);

    // transfer the resume information
    if (mResuming) {
        nsCOMPtr<nsIResumableChannel> resumableChannel(do_QueryInterface(newChannel));
        if (!resumableChannel) {
            NS_WARNING("Got asked to resume, but redirected to non-resumable channel!");
            return NS_ERROR_NOT_RESUMABLE;
        }
        resumableChannel->ResumeAt(mStartPos, mEntityID);
    }

    if (!(redirectFlags & nsIChannelEventSink::REDIRECT_STS_UPGRADE) &&
        mInterceptCache != INTERCEPTED) {
        // Ensure that internally-redirected channels, or loads with manual
        // redirect mode cannot be intercepted, which would look like two
        // separate requests to the nsINetworkInterceptController.
        if (mRedirectMode != nsIHttpChannelInternal::REDIRECT_MODE_MANUAL ||
            (redirectFlags & (nsIChannelEventSink::REDIRECT_TEMPORARY |
                              nsIChannelEventSink::REDIRECT_PERMANENT)) == 0) {
            nsLoadFlags loadFlags = nsIRequest::LOAD_NORMAL;
            rv = newChannel->GetLoadFlags(&loadFlags);
            NS_ENSURE_SUCCESS(rv, rv);
            loadFlags |= nsIChannel::LOAD_BYPASS_SERVICE_WORKER;
            rv = newChannel->SetLoadFlags(loadFlags);
            NS_ENSURE_SUCCESS(rv, rv);
        }
    }

    return NS_OK;
}

nsresult
nsHttpChannel::AsyncProcessRedirection(uint32_t redirectType)
{
    LOG(("nsHttpChannel::AsyncProcessRedirection [this=%p type=%u]\n",
        this, redirectType));

    nsAutoCString location;

    // if a location header was not given, then we can't perform the redirect,
    // so just carry on as though this were a normal response.
    if (NS_FAILED(mResponseHead->GetHeader(nsHttp::Location, location)))
        return NS_ERROR_FAILURE;

    // make sure non-ASCII characters in the location header are escaped.
    nsAutoCString locationBuf;
    if (NS_EscapeURL(location.get(), -1, esc_OnlyNonASCII, locationBuf))
        location = locationBuf;

    if (mRedirectionLimit == 0) {
        LOG(("redirection limit reached!\n"));
        return NS_ERROR_REDIRECT_LOOP;
    }

    mRedirectType = redirectType;

    LOG(("redirecting to: %s [redirection-limit=%u]\n",
        location.get(), uint32_t(mRedirectionLimit)));

    nsresult rv = CreateNewURI(location.get(), getter_AddRefs(mRedirectURI));

    if (NS_FAILED(rv)) {
        LOG(("Invalid URI for redirect: Location: %s\n", location.get()));
        return NS_ERROR_CORRUPTED_CONTENT;
    }

    if (mApplicationCache) {
        // if we are redirected to a different origin check if there is a fallback
        // cache entry to fall back to. we don't care about file strict
        // checking, at least mURI is not a file URI.
        if (!NS_SecurityCompareURIs(mURI, mRedirectURI, false)) {
            PushRedirectAsyncFunc(&nsHttpChannel::ContinueProcessRedirectionAfterFallback);
            bool waitingForRedirectCallback;
            (void)ProcessFallback(&waitingForRedirectCallback);
            if (waitingForRedirectCallback)
                return NS_OK;
            PopRedirectAsyncFunc(&nsHttpChannel::ContinueProcessRedirectionAfterFallback);
        }
    }

    return ContinueProcessRedirectionAfterFallback(NS_OK);
}

nsresult
nsHttpChannel::ContinueProcessRedirectionAfterFallback(nsresult rv)
{
    if (NS_SUCCEEDED(rv) && mFallingBack) {
        // do not continue with redirect processing, fallback is in
        // progress now.
        return NS_OK;
    }

    // Kill the current cache entry if we are redirecting
    // back to ourself.
    bool redirectingBackToSameURI = false;
    if (mCacheEntry && mCacheEntryIsWriteOnly &&
        NS_SUCCEEDED(mURI->Equals(mRedirectURI, &redirectingBackToSameURI)) &&
        redirectingBackToSameURI)
            mCacheEntry->AsyncDoom(nullptr);

    bool hasRef = false;
    rv = mRedirectURI->GetHasRef(&hasRef);

    // move the reference of the old location to the new one if the new
    // one has none.
    if (NS_SUCCEEDED(rv) && !hasRef) {
        nsAutoCString ref;
        mURI->GetRef(ref);
        if (!ref.IsEmpty()) {
            // NOTE: SetRef will fail if mRedirectURI is immutable
            // (e.g. an about: URI)... Oh well.
            mRedirectURI->SetRef(ref);
        }
    }

    bool rewriteToGET = ShouldRewriteRedirectToGET(mRedirectType,
                                                   mRequestHead.ParsedMethod());

    // prompt if the method is not safe (such as POST, PUT, DELETE, ...)
    if (!rewriteToGET && !mRequestHead.IsSafeMethod()) {
        rv = PromptTempRedirect();
        if (NS_FAILED(rv)) return rv;
    }

    nsCOMPtr<nsIIOService> ioService;
    rv = gHttpHandler->GetIOService(getter_AddRefs(ioService));
    if (NS_FAILED(rv)) return rv;

    nsCOMPtr<nsIChannel> newChannel;
    rv = NS_NewChannelInternal(getter_AddRefs(newChannel),
                               mRedirectURI,
                               mLoadInfo,
                               nullptr, // aLoadGroup
                               nullptr, // aCallbacks
                               nsIRequest::LOAD_NORMAL,
                               ioService);
    NS_ENSURE_SUCCESS(rv, rv);

    uint32_t redirectFlags;
    if (nsHttp::IsPermanentRedirect(mRedirectType))
        redirectFlags = nsIChannelEventSink::REDIRECT_PERMANENT;
    else
        redirectFlags = nsIChannelEventSink::REDIRECT_TEMPORARY;

    rv = SetupReplacementChannel(mRedirectURI, newChannel,
                                 !rewriteToGET, redirectFlags);
    if (NS_FAILED(rv)) return rv;

    // verify that this is a legal redirect
    mRedirectChannel = newChannel;

    PushRedirectAsyncFunc(&nsHttpChannel::ContinueProcessRedirection);
    rv = gHttpHandler->AsyncOnChannelRedirect(this, newChannel, redirectFlags);

    if (NS_SUCCEEDED(rv))
        rv = WaitForRedirectCallback();

    if (NS_FAILED(rv)) {
        AutoRedirectVetoNotifier notifier(this);
        PopRedirectAsyncFunc(&nsHttpChannel::ContinueProcessRedirection);
    }

    return rv;
}

nsresult
nsHttpChannel::ContinueProcessRedirection(nsresult rv)
{
    AutoRedirectVetoNotifier notifier(this);

    LOG(("nsHttpChannel::ContinueProcessRedirection [rv=%x,this=%p]\n", rv,
         this));
    if (NS_FAILED(rv))
        return rv;

    NS_PRECONDITION(mRedirectChannel, "No redirect channel?");

    // Make sure to do this after we received redirect veto answer,
    // i.e. after all sinks had been notified
    mRedirectChannel->SetOriginalURI(mOriginalURI);

    // And now, the deprecated way
    nsCOMPtr<nsIHttpEventSink> httpEventSink;
    GetCallback(httpEventSink);
    if (httpEventSink) {
        // NOTE: nsIHttpEventSink is only used for compatibility with pre-1.8
        // versions.
        rv = httpEventSink->OnRedirect(this, mRedirectChannel);
        if (NS_FAILED(rv))
            return rv;
    }
    // XXX we used to talk directly with the script security manager, but that
    // should really be handled by the event sink implementation.

    // begin loading the new channel
    if (mLoadInfo && mLoadInfo->GetEnforceSecurity()) {
        MOZ_ASSERT(!mListenerContext, "mListenerContext should be null!");
        rv = mRedirectChannel->AsyncOpen2(mListener);
    }
    else {
        rv = mRedirectChannel->AsyncOpen(mListener, mListenerContext);
    }
    NS_ENSURE_SUCCESS(rv, rv);

    // close down this channel
    Cancel(NS_BINDING_REDIRECTED);

    notifier.RedirectSucceeded();

    ReleaseListeners();

    return NS_OK;
}

//-----------------------------------------------------------------------------
// nsHttpChannel <auth>
//-----------------------------------------------------------------------------

NS_IMETHODIMP nsHttpChannel::OnAuthAvailable()
{
    LOG(("nsHttpChannel::OnAuthAvailable [this=%p]", this));

    // setting mAuthRetryPending flag and resuming the transaction
    // triggers process of throwing away the unauthenticated data already
    // coming from the network
    mAuthRetryPending = true;
    mProxyAuthPending = false;
    LOG(("Resuming the transaction, we got credentials from user"));
    mTransactionPump->Resume();

    return NS_OK;
}

NS_IMETHODIMP nsHttpChannel::OnAuthCancelled(bool userCancel)
{
    LOG(("nsHttpChannel::OnAuthCancelled [this=%p]", this));

    if (mTransactionPump) {
        // If the channel is trying to authenticate to a proxy and
        // that was canceled we cannot show the http response body
        // from the 40x as that might mislead the user into thinking
        // it was a end host response instead of a proxy reponse.
        // This must check explicitly whether a proxy auth was being done
        // because we do want to show the content if this is an error from
        // the origin server.
        if (mProxyAuthPending)
            Cancel(NS_ERROR_PROXY_CONNECTION_REFUSED);

        // ensure call of OnStartRequest of the current listener here,
        // it would not be called otherwise at all
        nsresult rv = CallOnStartRequest();

        // drop mAuthRetryPending flag and resume the transaction
        // this resumes load of the unauthenticated content data (which
        // may have been canceled if we don't want to show it)
        mAuthRetryPending = false;
        LOG(("Resuming the transaction, user cancelled the auth dialog"));
        mTransactionPump->Resume();

        if (NS_FAILED(rv))
            mTransactionPump->Cancel(rv);
    }

    mProxyAuthPending = false;
    return NS_OK;
}

//-----------------------------------------------------------------------------
// nsHttpChannel::nsISupports
//-----------------------------------------------------------------------------

NS_IMPL_ADDREF_INHERITED(nsHttpChannel, HttpBaseChannel)
NS_IMPL_RELEASE_INHERITED(nsHttpChannel, HttpBaseChannel)

NS_INTERFACE_MAP_BEGIN(nsHttpChannel)
    NS_INTERFACE_MAP_ENTRY(nsIRequest)
    NS_INTERFACE_MAP_ENTRY(nsIChannel)
    NS_INTERFACE_MAP_ENTRY(nsIRequestObserver)
    NS_INTERFACE_MAP_ENTRY(nsIStreamListener)
    NS_INTERFACE_MAP_ENTRY(nsIHttpChannel)
    NS_INTERFACE_MAP_ENTRY(nsICacheInfoChannel)
    NS_INTERFACE_MAP_ENTRY(nsICachingChannel)
    NS_INTERFACE_MAP_ENTRY(nsIClassOfService)
    NS_INTERFACE_MAP_ENTRY(nsIUploadChannel)
    NS_INTERFACE_MAP_ENTRY(nsIFormPOSTActionChannel)
    NS_INTERFACE_MAP_ENTRY(nsIUploadChannel2)
    NS_INTERFACE_MAP_ENTRY(nsICacheEntryOpenCallback)
    NS_INTERFACE_MAP_ENTRY(nsIHttpChannelInternal)
    NS_INTERFACE_MAP_ENTRY(nsIResumableChannel)
    NS_INTERFACE_MAP_ENTRY(nsITransportEventSink)
    NS_INTERFACE_MAP_ENTRY(nsISupportsPriority)
    NS_INTERFACE_MAP_ENTRY(nsIProtocolProxyCallback)
    NS_INTERFACE_MAP_ENTRY(nsIProxiedChannel)
    NS_INTERFACE_MAP_ENTRY(nsIHttpAuthenticableChannel)
    NS_INTERFACE_MAP_ENTRY(nsIApplicationCacheContainer)
    NS_INTERFACE_MAP_ENTRY(nsIApplicationCacheChannel)
    NS_INTERFACE_MAP_ENTRY(nsIAsyncVerifyRedirectCallback)
    NS_INTERFACE_MAP_ENTRY(nsIThreadRetargetableRequest)
    NS_INTERFACE_MAP_ENTRY(nsIThreadRetargetableStreamListener)
    NS_INTERFACE_MAP_ENTRY(nsIDNSListener)
    NS_INTERFACE_MAP_ENTRY(nsISupportsWeakReference)
    NS_INTERFACE_MAP_ENTRY(nsICorsPreflightCallback)
    NS_INTERFACE_MAP_ENTRY(nsIHstsPrimingCallback)
    NS_INTERFACE_MAP_ENTRY(nsIChannelWithDivertableParentListener)
    // we have no macro that covers this case.
    if (aIID.Equals(NS_GET_IID(nsHttpChannel)) ) {
        AddRef();
        *aInstancePtr = this;
        return NS_OK;
    } else
NS_INTERFACE_MAP_END_INHERITING(HttpBaseChannel)

//-----------------------------------------------------------------------------
// nsHttpChannel::nsIRequest
//-----------------------------------------------------------------------------

NS_IMETHODIMP
nsHttpChannel::Cancel(nsresult status)
{
    MOZ_ASSERT(NS_IsMainThread());
    // We should never have a pump open while a CORS preflight is in progress.
    MOZ_ASSERT_IF(mPreflightChannel, !mCachePump);

    LOG(("nsHttpChannel::Cancel [this=%p status=%x]\n", this, status));
    if (mCanceled) {
        LOG(("  ignoring; already canceled\n"));
        return NS_OK;
    }
    if (mWaitingForRedirectCallback) {
        LOG(("channel canceled during wait for redirect callback"));
    }
    mCanceled = true;
    mStatus = status;
    if (mProxyRequest)
        mProxyRequest->Cancel(status);
    if (mTransaction)
        gHttpHandler->CancelTransaction(mTransaction, status);
    if (mTransactionPump)
        mTransactionPump->Cancel(status);
    mCacheInputStream.CloseAndRelease();
    if (mCachePump)
        mCachePump->Cancel(status);
    if (mAuthProvider)
        mAuthProvider->Cancel(status);
    if (mPreflightChannel)
        mPreflightChannel->Cancel(status);
    return NS_OK;
}

NS_IMETHODIMP
nsHttpChannel::Suspend()
{
    nsresult rv = SuspendInternal();

    nsresult rvParentChannel = NS_OK;
    if (mParentChannel) {
      rvParentChannel = mParentChannel->SuspendMessageDiversion();
    }

    return NS_FAILED(rv) ? rv : rvParentChannel;
}

NS_IMETHODIMP
nsHttpChannel::Resume()
{
    nsresult rv = ResumeInternal();

    nsresult rvParentChannel = NS_OK;
    if (mParentChannel) {
      rvParentChannel = mParentChannel->ResumeMessageDiversion();
    }

    return NS_FAILED(rv) ? rv : rvParentChannel;
}

//-----------------------------------------------------------------------------
// nsHttpChannel::nsIChannel
//-----------------------------------------------------------------------------

NS_IMETHODIMP
nsHttpChannel::GetSecurityInfo(nsISupports **securityInfo)
{
    NS_ENSURE_ARG_POINTER(securityInfo);
    *securityInfo = mSecurityInfo;
    NS_IF_ADDREF(*securityInfo);
    return NS_OK;
}

// If any of the functions that AsyncOpen calls returns immediately an error
// AsyncAbort(which calls onStart/onStopRequest) does not need to be call.
// To be sure that they are not call ReleaseListeners() is called.
// If AsyncOpen returns NS_OK, after that point AsyncAbort must be called on
// any error.
NS_IMETHODIMP
nsHttpChannel::AsyncOpen(nsIStreamListener *listener, nsISupports *context)
{
    MOZ_ASSERT(!mLoadInfo ||
               mLoadInfo->GetSecurityMode() == 0 ||
               mLoadInfo->GetInitialSecurityCheckDone() ||
               (mLoadInfo->GetSecurityMode() == nsILoadInfo::SEC_ALLOW_CROSS_ORIGIN_DATA_IS_NULL &&
                nsContentUtils::IsSystemPrincipal(mLoadInfo->LoadingPrincipal())),
               "security flags in loadInfo but asyncOpen2() not called");

    LOG(("nsHttpChannel::AsyncOpen [this=%p]\n", this));

    NS_CompareLoadInfoAndLoadContext(this);

#ifdef DEBUG
    AssertPrivateBrowsingId();
#endif

    NS_ENSURE_ARG_POINTER(listener);
    NS_ENSURE_TRUE(!mIsPending, NS_ERROR_IN_PROGRESS);
    NS_ENSURE_TRUE(!mWasOpened, NS_ERROR_ALREADY_OPENED);

    nsresult rv;

    MOZ_ASSERT(NS_IsMainThread());

    if (!gHttpHandler->Active()) {
        LOG(("  after HTTP shutdown..."));
        ReleaseListeners();
        return NS_ERROR_NOT_AVAILABLE;
    }

    rv = NS_CheckPortSafety(mURI);
    if (NS_FAILED(rv)) {
        ReleaseListeners();
        return rv;
    }

    if (mInterceptCache != INTERCEPTED && ShouldIntercept()) {
        mInterceptCache = MAYBE_INTERCEPT;
        SetCouldBeSynthesized();
    }

    // Remember the cookie header that was set, if any
    nsAutoCString cookieHeader;
    if (NS_SUCCEEDED(mRequestHead.GetHeader(nsHttp::Cookie, cookieHeader))) {
        mUserSetCookieHeader = cookieHeader;
    }

    AddCookiesToRequest();

    // After we notify any observers (on-opening-request, loadGroup, etc) we
    // must return NS_OK and return any errors asynchronously via
    // OnStart/OnStopRequest.  Observers may add a reference to the channel
    // and expect to get OnStopRequest so they know when to drop the reference,
    // etc.

    // notify "http-on-opening-request" observers, but not if this is a redirect
    if (!(mLoadFlags & LOAD_REPLACE)) {
        gHttpHandler->OnOpeningRequest(this);
    }

    // Set user agent override
    HttpBaseChannel::SetDocshellUserAgentOverride();

    mIsPending = true;
    mWasOpened = true;

    mListener = listener;
    mListenerContext = context;

    if (mLoadGroup)
        mLoadGroup->AddRequest(this, nullptr);

    // record asyncopen time unconditionally and clear it if we
    // don't want it after OnModifyRequest() weighs in. But waiting for
    // that to complete would mean we don't include proxy resolution in the
    // timing.
    mAsyncOpenTime = TimeStamp::Now();

    // Remember we have Authorization header set here.  We need to check on it
    // just once and early, AsyncOpen is the best place.
    mCustomAuthHeader = mRequestHead.HasHeader(nsHttp::Authorization);

    // The common case for HTTP channels is to begin proxy resolution and return
    // at this point. The only time we know mProxyInfo already is if we're
    // proxying a non-http protocol like ftp.
    if (!mProxyInfo && NS_SUCCEEDED(ResolveProxy())) {
        return NS_OK;
    }

    rv = BeginConnect();
    if (NS_FAILED(rv)) {
        CloseCacheEntry(false);
        AsyncAbort(rv);
    }

    return NS_OK;
}

NS_IMETHODIMP
nsHttpChannel::AsyncOpen2(nsIStreamListener *aListener)
{
  nsCOMPtr<nsIStreamListener> listener = aListener;
  nsresult rv = nsContentSecurityManager::doContentSecurityCheck(this, listener);
  if (NS_WARN_IF(NS_FAILED(rv))) {
      ReleaseListeners();
      return rv;
  }
  return AsyncOpen(listener, nullptr);
}

// BeginConnect() SHOULD NOT call AsyncAbort(). AsyncAbort will be called by
// functions that called BeginConnect if needed. Only AsyncOpen and
// OnProxyAvailable ever call BeginConnect.
nsresult
nsHttpChannel::BeginConnect()
{
    LOG(("nsHttpChannel::BeginConnect [this=%p]\n", this));
    nsresult rv;

    // Construct connection info object
    nsAutoCString host;
    nsAutoCString scheme;
    int32_t port = -1;
    bool isHttps = false;

    rv = mURI->GetScheme(scheme);
    if (NS_SUCCEEDED(rv))
        rv = mURI->SchemeIs("https", &isHttps);
    if (NS_SUCCEEDED(rv))
        rv = mURI->GetAsciiHost(host);
    if (NS_SUCCEEDED(rv))
        rv = mURI->GetPort(&port);
    if (NS_SUCCEEDED(rv))
        mURI->GetUsername(mUsername);
    if (NS_SUCCEEDED(rv))
        rv = mURI->GetAsciiSpec(mSpec);
    if (NS_FAILED(rv)) {
        return rv;
    }

    // Reject the URL if it doesn't specify a host
    if (host.IsEmpty()) {
        rv = NS_ERROR_MALFORMED_URI;
        return rv;
    }
    LOG(("host=%s port=%d\n", host.get(), port));
    LOG(("uri=%s\n", mSpec.get()));

    nsCOMPtr<nsProxyInfo> proxyInfo;
    if (mProxyInfo)
        proxyInfo = do_QueryInterface(mProxyInfo);

    mRequestHead.SetHTTPS(isHttps);
    mRequestHead.SetOrigin(scheme, host, port);

    SetDoNotTrack();

    NeckoOriginAttributes originAttributes;
    NS_GetOriginAttributes(this, originAttributes);

    RefPtr<AltSvcMapping> mapping;
    if (!mConnectionInfo && mAllowAltSvc && // per channel
        !(mLoadFlags & LOAD_FRESH_CONNECTION) &&
        (scheme.Equals(NS_LITERAL_CSTRING("http")) ||
         scheme.Equals(NS_LITERAL_CSTRING("https"))) &&
        (!proxyInfo || proxyInfo->IsDirect()) &&
        (mapping = gHttpHandler->GetAltServiceMapping(scheme,
                                                      host, port,
                                                      mPrivateBrowsing))) {
        LOG(("nsHttpChannel %p Alt Service Mapping Found %s://%s:%d [%s]\n",
             this, scheme.get(), mapping->AlternateHost().get(),
             mapping->AlternatePort(), mapping->HashKey().get()));

        if (!(mLoadFlags & LOAD_ANONYMOUS) && !mPrivateBrowsing) {
            nsAutoCString altUsedLine(mapping->AlternateHost());
            bool defaultPort = mapping->AlternatePort() ==
                (isHttps ? NS_HTTPS_DEFAULT_PORT : NS_HTTP_DEFAULT_PORT);
            if (!defaultPort) {
                altUsedLine.AppendLiteral(":");
                altUsedLine.AppendInt(mapping->AlternatePort());
            }
            mRequestHead.SetHeader(nsHttp::Alternate_Service_Used, altUsedLine);
        }

        nsCOMPtr<nsIConsoleService> consoleService =
            do_GetService(NS_CONSOLESERVICE_CONTRACTID);
        if (consoleService) {
            nsAutoString message(NS_LITERAL_STRING("Alternate Service Mapping found: "));
            AppendASCIItoUTF16(scheme.get(), message);
            message.Append(NS_LITERAL_STRING("://"));
            AppendASCIItoUTF16(host.get(), message);
            message.Append(NS_LITERAL_STRING(":"));
            message.AppendInt(port);
            message.Append(NS_LITERAL_STRING(" to "));
            AppendASCIItoUTF16(scheme.get(), message);
            message.Append(NS_LITERAL_STRING("://"));
            AppendASCIItoUTF16(mapping->AlternateHost().get(), message);
            message.Append(NS_LITERAL_STRING(":"));
            message.AppendInt(mapping->AlternatePort());
            consoleService->LogStringMessage(message.get());
        }

        LOG(("nsHttpChannel %p Using connection info from altsvc mapping", this));
        mapping->GetConnectionInfo(getter_AddRefs(mConnectionInfo), proxyInfo, originAttributes);
        Telemetry::Accumulate(Telemetry::HTTP_TRANSACTION_USE_ALTSVC, true);
        Telemetry::Accumulate(Telemetry::HTTP_TRANSACTION_USE_ALTSVC_OE, !isHttps);
    } else if (mConnectionInfo) {
        LOG(("nsHttpChannel %p Using channel supplied connection info", this));
        Telemetry::Accumulate(Telemetry::HTTP_TRANSACTION_USE_ALTSVC, false);
    } else {
        LOG(("nsHttpChannel %p Using default connection info", this));

        mConnectionInfo = new nsHttpConnectionInfo(host, port, EmptyCString(), mUsername, proxyInfo,
                                                   originAttributes, isHttps);
        Telemetry::Accumulate(Telemetry::HTTP_TRANSACTION_USE_ALTSVC, false);
    }

    // Set network interface id only when it's not empty to avoid
    // rebuilding hash key.
    if (!mNetworkInterfaceId.IsEmpty()) {
        mConnectionInfo->SetNetworkInterfaceId(mNetworkInterfaceId);
    }

    mAuthProvider =
        do_CreateInstance("@mozilla.org/network/http-channel-auth-provider;1",
                          &rv);
    if (NS_SUCCEEDED(rv))
        rv = mAuthProvider->Init(this);
    if (NS_FAILED(rv)) {
        return rv;
    }

    // check to see if authorization headers should be included
    // mCustomAuthHeader is set in AsyncOpen if we find Authorization header
    mAuthProvider->AddAuthorizationHeaders(mCustomAuthHeader);

    // notify "http-on-modify-request" observers
    CallOnModifyRequestObservers();

    SetLoadGroupUserAgentOverride();

    // Check to see if we should redirect this channel elsewhere by
    // nsIHttpChannel.redirectTo API request
    if (mAPIRedirectToURI) {
        return AsyncCall(&nsHttpChannel::HandleAsyncAPIRedirect);
    }
    // Check to see if this principal exists on local blocklists.
    RefPtr<nsChannelClassifier> channelClassifier = new nsChannelClassifier();
    if (mLoadFlags & LOAD_CLASSIFY_URI) {
        nsCOMPtr<nsIURIClassifier> classifier = do_GetService(NS_URICLASSIFIERSERVICE_CONTRACTID);
        bool tpEnabled = false;
        channelClassifier->ShouldEnableTrackingProtection(this, &tpEnabled);
        if (classifier && tpEnabled) {
            // We skip speculative connections by setting mLocalBlocklist only
            // when tracking protection is enabled. Though we could do this for
            // both phishing and malware, it is not necessary for correctness,
            // since no network events will be received while the
            // nsChannelClassifier is in progress. See bug 1122691.
            nsCOMPtr<nsIURI> uri;
            rv = GetURI(getter_AddRefs(uri));
            if (NS_SUCCEEDED(rv) && uri) {
                nsAutoCString tables;
                Preferences::GetCString("urlclassifier.trackingTable", &tables);
                nsAutoCString results;
                rv = classifier->ClassifyLocalWithTables(uri, tables, results);
                if (NS_SUCCEEDED(rv) && !results.IsEmpty()) {
                    LOG(("nsHttpChannel::ClassifyLocalWithTables found "
                         "uri on local tracking blocklist [this=%p]",
                         this));
                    mLocalBlocklist = true;
                } else {
                    LOG(("nsHttpChannel::ClassifyLocalWithTables no result "
                         "found [this=%p]", this));
                }
            }
        }
    }

    // If mTimingEnabled flag is not set after OnModifyRequest() then
    // clear the already recorded AsyncOpen value for consistency.
    if (!mTimingEnabled)
        mAsyncOpenTime = TimeStamp();

    // when proxying only use the pipeline bit if ProxyPipelining() allows it.
    if (!mConnectionInfo->UsingConnect() && mConnectionInfo->UsingHttpProxy()) {
        mCaps &= ~NS_HTTP_ALLOW_PIPELINING;
        if (gHttpHandler->ProxyPipelining())
            mCaps |= NS_HTTP_ALLOW_PIPELINING;
    }

    // if this somehow fails we can go on without it
    gHttpHandler->AddConnectionHeader(&mRequestHead, mCaps);

    if (mLoadFlags & VALIDATE_ALWAYS || BYPASS_LOCAL_CACHE(mLoadFlags))
        mCaps |= NS_HTTP_REFRESH_DNS;

    if (!mLocalBlocklist && !mConnectionInfo->UsingHttpProxy() &&
        !(mLoadFlags & (LOAD_NO_NETWORK_IO | LOAD_ONLY_FROM_CACHE))) {
        // Start a DNS lookup very early in case the real open is queued the DNS can
        // happen in parallel. Do not do so in the presence of an HTTP proxy as
        // all lookups other than for the proxy itself are done by the proxy.
        // Also we don't do a lookup if the LOAD_NO_NETWORK_IO or
        // LOAD_ONLY_FROM_CACHE flags are set.
        //
        // We keep the DNS prefetch object around so that we can retrieve
        // timing information from it. There is no guarantee that we actually
        // use the DNS prefetch data for the real connection, but as we keep
        // this data around for 3 minutes by default, this should almost always
        // be correct, and even when it isn't, the timing still represents _a_
        // valid DNS lookup timing for the site, even if it is not _the_
        // timing we used.
        LOG(("nsHttpChannel::BeginConnect [this=%p] prefetching%s\n",
             this, mCaps & NS_HTTP_REFRESH_DNS ? ", refresh requested" : ""));
        mDNSPrefetch = new nsDNSPrefetch(mURI, this, mTimingEnabled);
        mDNSPrefetch->PrefetchHigh(mCaps & NS_HTTP_REFRESH_DNS);
    }

    // Adjust mCaps according to our request headers:
    //  - If "Connection: close" is set as a request header, then do not bother
    //    trying to establish a keep-alive connection.
    if (mRequestHead.HasHeaderValue(nsHttp::Connection, "close"))
        mCaps &= ~(NS_HTTP_ALLOW_KEEPALIVE | NS_HTTP_ALLOW_PIPELINING);

    if (gHttpHandler->CriticalRequestPrioritization()) {
        if (mClassOfService & nsIClassOfService::Leader) {
            mCaps |= NS_HTTP_LOAD_AS_BLOCKING;
        }
        if (mClassOfService & nsIClassOfService::Unblocked) {
            mCaps |= NS_HTTP_LOAD_UNBLOCKED;
        }
    }

    // Force-Reload should reset the persistent connection pool for this host
    if (mLoadFlags & LOAD_FRESH_CONNECTION) {
        // just the initial document resets the whole pool
        if (mLoadFlags & LOAD_INITIAL_DOCUMENT_URI) {
            gHttpHandler->ConnMgr()->ClearAltServiceMappings();
            gHttpHandler->ConnMgr()->DoShiftReloadConnectionCleanup(mConnectionInfo);
        }
        mCaps &= ~NS_HTTP_ALLOW_PIPELINING;
    }

    // We may have been cancelled already, either by on-modify-request
    // listeners or load group observers; in that case, we should not send the
    // request to the server
    if (mCanceled) {
        return mStatus;
    }

    if (!(mLoadFlags & LOAD_CLASSIFY_URI)) {
        return ContinueBeginConnectWithResult();
    }

    // mLocalBlocklist is true only if tracking protection is enabled and the
    // URI is a tracking domain, it makes no guarantees about phishing or
    // malware, so if LOAD_CLASSIFY_URI is true we must call
    // nsChannelClassifier to catch phishing and malware URIs.
    bool callContinueBeginConnect = true;
    if (!mLocalBlocklist) {
        // Here we call ContinueBeginConnectWithResult and not
        // ContinueBeginConnect so that in the case of an error we do not start
        // channelClassifier.
        rv = ContinueBeginConnectWithResult();
        if (NS_FAILED(rv)) {
            return rv;
        }
        callContinueBeginConnect = false;
    }
    // nsChannelClassifier calls ContinueBeginConnect if it has not already
    // been called, after optionally cancelling the channel once we have a
    // remote verdict. We call a concrete class instead of an nsI* that might
    // be overridden.
    LOG(("nsHttpChannel::Starting nsChannelClassifier %p [this=%p]",
         channelClassifier.get(), this));
    channelClassifier->Start(this);
    if (callContinueBeginConnect) {
        return ContinueBeginConnectWithResult();
    }
    return NS_OK;
}

NS_IMETHODIMP
nsHttpChannel::GetEncodedBodySize(uint64_t *aEncodedBodySize)
{
    if (mCacheEntry && !mCacheEntryIsWriteOnly) {
        int64_t dataSize = 0;
        mCacheEntry->GetDataSize(&dataSize);
        *aEncodedBodySize = dataSize;
    } else {
        *aEncodedBodySize = mLogicalOffset;
    }
    return NS_OK;
}

//-----------------------------------------------------------------------------
// nsHttpChannel::nsIHttpChannelInternal
//-----------------------------------------------------------------------------

NS_IMETHODIMP
nsHttpChannel::SetupFallbackChannel(const char *aFallbackKey)
{
    ENSURE_CALLED_BEFORE_CONNECT();

    LOG(("nsHttpChannel::SetupFallbackChannel [this=%p, key=%s]\n",
         this, aFallbackKey));
    mFallbackChannel = true;
    mFallbackKey = aFallbackKey;

    return NS_OK;
}

NS_IMETHODIMP
nsHttpChannel::ForceIntercepted(uint64_t aInterceptionID)
{
    ENSURE_CALLED_BEFORE_ASYNC_OPEN();

    if (NS_WARN_IF(mLoadFlags & LOAD_BYPASS_SERVICE_WORKER)) {
        return NS_ERROR_NOT_AVAILABLE;
    }

    MarkIntercepted();
    mResponseCouldBeSynthesized = true;
    mInterceptionID = aInterceptionID;
    return NS_OK;
}

mozilla::net::nsHttpChannel*
nsHttpChannel::QueryHttpChannelImpl(void)
{
  return this;
}

//-----------------------------------------------------------------------------
// nsHttpChannel::nsISupportsPriority
//-----------------------------------------------------------------------------

NS_IMETHODIMP
nsHttpChannel::SetPriority(int32_t value)
{
    int16_t newValue = clamped<int32_t>(value, INT16_MIN, INT16_MAX);
    if (mPriority == newValue)
        return NS_OK;
    mPriority = newValue;
    if (mTransaction)
        gHttpHandler->RescheduleTransaction(mTransaction, mPriority);
    return NS_OK;
}

nsresult
nsHttpChannel::ContinueBeginConnectWithResult()
{
    LOG(("nsHttpChannel::ContinueBeginConnectWithResult [this=%p]", this));
    NS_PRECONDITION(!mCallOnResume, "How did that happen?");

    nsresult rv;

    if (mSuspendCount) {
        LOG(("Waiting until resume to do async connect [this=%p]\n", this));
        mCallOnResume = &nsHttpChannel::ContinueBeginConnect;
        rv = NS_OK;
    } else if (mCanceled) {
        // We may have been cancelled already, by nsChannelClassifier in that
        // case, we should not send the request to the server
        rv = mStatus;
    } else {
        rv = Connect();
    }

    LOG(("nsHttpChannel::ContinueBeginConnectWithResult result [this=%p rv=%x "
         "mCanceled=%i]\n", this, rv, mCanceled));
    return rv;
}

void
nsHttpChannel::ContinueBeginConnect()
{
    nsresult rv = ContinueBeginConnectWithResult();
    if (NS_FAILED(rv)) {
        CloseCacheEntry(false);
        AsyncAbort(rv);
    }
}

//-----------------------------------------------------------------------------
// HttpChannel::nsIClassOfService
//-----------------------------------------------------------------------------
NS_IMETHODIMP
nsHttpChannel::SetClassFlags(uint32_t inFlags)
{
    mClassOfService = inFlags;
    return NS_OK;
}

NS_IMETHODIMP
nsHttpChannel::AddClassFlags(uint32_t inFlags)
{
    mClassOfService |= inFlags;
    return NS_OK;
}

NS_IMETHODIMP
nsHttpChannel::ClearClassFlags(uint32_t inFlags)
{
    mClassOfService &= ~inFlags;
    return NS_OK;
}

//-----------------------------------------------------------------------------
// nsHttpChannel::nsIProtocolProxyCallback
//-----------------------------------------------------------------------------

NS_IMETHODIMP
nsHttpChannel::OnProxyAvailable(nsICancelable *request, nsIChannel *channel,
                                nsIProxyInfo *pi, nsresult status)
{
    LOG(("nsHttpChannel::OnProxyAvailable [this=%p pi=%p status=%x mStatus=%x]\n",
         this, pi, status, mStatus));
    mProxyRequest = nullptr;

    nsresult rv;

    // If status is a failure code, then it means that we failed to resolve
    // proxy info.  That is a non-fatal error assuming it wasn't because the
    // request was canceled.  We just failover to DIRECT when proxy resolution
    // fails (failure can mean that the PAC URL could not be loaded).

    if (NS_SUCCEEDED(status))
        mProxyInfo = pi;

    if (!gHttpHandler->Active()) {
        LOG(("nsHttpChannel::OnProxyAvailable [this=%p] "
             "Handler no longer active.\n", this));
        rv = NS_ERROR_NOT_AVAILABLE;
    }
    else {
        rv = BeginConnect();
    }

    if (NS_FAILED(rv)) {
        CloseCacheEntry(false);
        AsyncAbort(rv);
    }
    return rv;
}

//-----------------------------------------------------------------------------
// nsHttpChannel::nsIProxiedChannel
//-----------------------------------------------------------------------------

NS_IMETHODIMP
nsHttpChannel::GetProxyInfo(nsIProxyInfo **result)
{
    if (!mConnectionInfo)
        *result = mProxyInfo;
    else
        *result = mConnectionInfo->ProxyInfo();
    NS_IF_ADDREF(*result);
    return NS_OK;
}

//-----------------------------------------------------------------------------
// nsHttpChannel::nsITimedChannel
//-----------------------------------------------------------------------------

NS_IMETHODIMP
nsHttpChannel::GetDomainLookupStart(TimeStamp* _retval) {
    if (mTransaction)
        *_retval = mTransaction->GetDomainLookupStart();
    else
        *_retval = mTransactionTimings.domainLookupStart;
    return NS_OK;
}

NS_IMETHODIMP
nsHttpChannel::GetDomainLookupEnd(TimeStamp* _retval) {
    if (mTransaction)
        *_retval = mTransaction->GetDomainLookupEnd();
    else
        *_retval = mTransactionTimings.domainLookupEnd;
    return NS_OK;
}

NS_IMETHODIMP
nsHttpChannel::GetConnectStart(TimeStamp* _retval) {
    if (mTransaction)
        *_retval = mTransaction->GetConnectStart();
    else
        *_retval = mTransactionTimings.connectStart;
    return NS_OK;
}

NS_IMETHODIMP
nsHttpChannel::GetConnectEnd(TimeStamp* _retval) {
    if (mTransaction)
        *_retval = mTransaction->GetConnectEnd();
    else
        *_retval = mTransactionTimings.connectEnd;
    return NS_OK;
}

NS_IMETHODIMP
nsHttpChannel::GetRequestStart(TimeStamp* _retval) {
    if (mTransaction)
        *_retval = mTransaction->GetRequestStart();
    else
        *_retval = mTransactionTimings.requestStart;
    return NS_OK;
}

NS_IMETHODIMP
nsHttpChannel::GetResponseStart(TimeStamp* _retval) {
    if (mTransaction)
        *_retval = mTransaction->GetResponseStart();
    else
        *_retval = mTransactionTimings.responseStart;
    return NS_OK;
}

NS_IMETHODIMP
nsHttpChannel::GetResponseEnd(TimeStamp* _retval) {
    if (mTransaction)
        *_retval = mTransaction->GetResponseEnd();
    else
        *_retval = mTransactionTimings.responseEnd;
    return NS_OK;
}

//-----------------------------------------------------------------------------
// nsHttpChannel::nsIHttpAuthenticableChannel
//-----------------------------------------------------------------------------

NS_IMETHODIMP
nsHttpChannel::GetIsSSL(bool *aIsSSL)
{
    // this attribute is really misnamed - it wants to know if
    // https:// is being used. SSL might be used to cover http://
    // in some circumstances (proxies, http/2, etc..)
    return mURI->SchemeIs("https", aIsSSL);
}

NS_IMETHODIMP
nsHttpChannel::GetProxyMethodIsConnect(bool *aProxyMethodIsConnect)
{
    *aProxyMethodIsConnect = mConnectionInfo->UsingConnect();
    return NS_OK;
}

NS_IMETHODIMP
nsHttpChannel::GetServerResponseHeader(nsACString &value)
{
    if (!mResponseHead)
        return NS_ERROR_NOT_AVAILABLE;
    return mResponseHead->GetHeader(nsHttp::Server, value);
}

NS_IMETHODIMP
nsHttpChannel::GetProxyChallenges(nsACString &value)
{
    if (!mResponseHead)
        return NS_ERROR_UNEXPECTED;
    return mResponseHead->GetHeader(nsHttp::Proxy_Authenticate, value);
}

NS_IMETHODIMP
nsHttpChannel::GetWWWChallenges(nsACString &value)
{
    if (!mResponseHead)
        return NS_ERROR_UNEXPECTED;
    return mResponseHead->GetHeader(nsHttp::WWW_Authenticate, value);
}

NS_IMETHODIMP
nsHttpChannel::SetProxyCredentials(const nsACString &value)
{
    return mRequestHead.SetHeader(nsHttp::Proxy_Authorization, value);
}

NS_IMETHODIMP
nsHttpChannel::SetWWWCredentials(const nsACString &value)
{
    return mRequestHead.SetHeader(nsHttp::Authorization, value);
}

//-----------------------------------------------------------------------------
// Methods that nsIHttpAuthenticableChannel dupes from other IDLs, which we
// get from HttpBaseChannel, must be explicitly forwarded, because C++ sucks.
//

NS_IMETHODIMP
nsHttpChannel::GetLoadFlags(nsLoadFlags *aLoadFlags)
{
    return HttpBaseChannel::GetLoadFlags(aLoadFlags);
}

NS_IMETHODIMP
nsHttpChannel::GetURI(nsIURI **aURI)
{
    return HttpBaseChannel::GetURI(aURI);
}

NS_IMETHODIMP
nsHttpChannel::GetNotificationCallbacks(nsIInterfaceRequestor **aCallbacks)
{
    return HttpBaseChannel::GetNotificationCallbacks(aCallbacks);
}

NS_IMETHODIMP
nsHttpChannel::GetLoadGroup(nsILoadGroup **aLoadGroup)
{
    return HttpBaseChannel::GetLoadGroup(aLoadGroup);
}

NS_IMETHODIMP
nsHttpChannel::GetRequestMethod(nsACString& aMethod)
{
    return HttpBaseChannel::GetRequestMethod(aMethod);
}

//-----------------------------------------------------------------------------
// nsHttpChannel::nsIRequestObserver
//-----------------------------------------------------------------------------

NS_IMETHODIMP
nsHttpChannel::OnStartRequest(nsIRequest *request, nsISupports *ctxt)
{
    nsresult rv;

    PROFILER_LABEL("nsHttpChannel", "OnStartRequest",
        js::ProfileEntry::Category::NETWORK);

    if (!(mCanceled || NS_FAILED(mStatus))) {
        // capture the request's status, so our consumers will know ASAP of any
        // connection failures, etc - bug 93581
        request->GetStatus(&mStatus);
    }

    LOG(("nsHttpChannel::OnStartRequest [this=%p request=%p status=%x]\n",
        this, request, mStatus));

    // Make sure things are what we expect them to be...
    MOZ_ASSERT(request == mCachePump || request == mTransactionPump,
               "Unexpected request");
    MOZ_ASSERT(!(mTransactionPump && mCachePump) || mCachedContentIsPartial,
               "If we have both pumps, the cache content must be partial");

    mAfterOnStartRequestBegun = true;
    mOnStartRequestTimestamp = TimeStamp::Now();

    if (!mSecurityInfo && !mCachePump && mTransaction) {
        // grab the security info from the connection object; the transaction
        // is guaranteed to own a reference to the connection.
        mSecurityInfo = mTransaction->SecurityInfo();
    }

    // don't enter this block if we're reading from the cache...
    if (NS_SUCCEEDED(mStatus) && !mCachePump && mTransaction) {
        // mTransactionPump doesn't hit OnInputStreamReady and call this until
        // all of the response headers have been acquired, so we can take ownership
        // of them from the transaction.
        mResponseHead = mTransaction->TakeResponseHead();
        // the response head may be null if the transaction was cancelled.  in
        // which case we just need to call OnStartRequest/OnStopRequest.
        if (mResponseHead)
            return ProcessResponse();

        NS_WARNING("No response head in OnStartRequest");
    }

    // cache file could be deleted on our behalf, it could contain errors or
    // it failed to allocate memory, reload from network here.
    if (mCacheEntry && mCachePump && RECOVER_FROM_CACHE_FILE_ERROR(mStatus)) {
        LOG(("  cache file error, reloading from server"));
        mCacheEntry->AsyncDoom(nullptr);
        rv = StartRedirectChannelToURI(mURI, nsIChannelEventSink::REDIRECT_INTERNAL);
        if (NS_SUCCEEDED(rv))
            return NS_OK;
    }

    // avoid crashing if mListener happens to be null...
    if (!mListener) {
        NS_NOTREACHED("mListener is null");
        return NS_OK;
    }

    // before we start any content load, check for redirectTo being called
    // this code is executed mainly before we start load from the cache
    if (mAPIRedirectToURI && !mCanceled) {
        nsAutoCString redirectToSpec;
        mAPIRedirectToURI->GetAsciiSpec(redirectToSpec);
        LOG(("  redirectTo called with uri=%s", redirectToSpec.BeginReading()));

        MOZ_ASSERT(!mOnStartRequestCalled);

        nsCOMPtr<nsIURI> redirectTo;
        mAPIRedirectToURI.swap(redirectTo);

        PushRedirectAsyncFunc(&nsHttpChannel::ContinueOnStartRequest1);
        rv = StartRedirectChannelToURI(redirectTo, nsIChannelEventSink::REDIRECT_TEMPORARY);
        if (NS_SUCCEEDED(rv)) {
            return NS_OK;
        }
        PopRedirectAsyncFunc(&nsHttpChannel::ContinueOnStartRequest1);
    }

    // Hack: ContinueOnStartRequest1 uses NS_OK to detect successful redirects,
    // so we distinguish this codepath (a non-redirect that's processing
    // normally) by passing in a bogus error code.
    return ContinueOnStartRequest1(NS_BINDING_FAILED);
}

nsresult
nsHttpChannel::ContinueOnStartRequest1(nsresult result)
{
    if (NS_SUCCEEDED(result)) {
        // Redirect has passed through, we don't want to go on with this
        // channel.  It will now be canceled by the redirect handling code
        // that called this function.
        return NS_OK;
    }

    // on proxy errors, try to failover
    if (mConnectionInfo->ProxyInfo() &&
       (mStatus == NS_ERROR_PROXY_CONNECTION_REFUSED ||
        mStatus == NS_ERROR_UNKNOWN_PROXY_HOST ||
        mStatus == NS_ERROR_NET_TIMEOUT)) {

        PushRedirectAsyncFunc(&nsHttpChannel::ContinueOnStartRequest2);
        if (NS_SUCCEEDED(ProxyFailover()))
            return NS_OK;
        PopRedirectAsyncFunc(&nsHttpChannel::ContinueOnStartRequest2);
    }

    // Hack: ContinueOnStartRequest2 uses NS_OK to detect successful redirects,
    // so we distinguish this codepath (a non-redirect that's processing
    // normally) by passing in a bogus error code.
    return ContinueOnStartRequest2(NS_BINDING_FAILED);
}

nsresult
nsHttpChannel::ContinueOnStartRequest2(nsresult result)
{
    if (NS_SUCCEEDED(result)) {
        // Redirect has passed through, we don't want to go on with this
        // channel.  It will now be canceled by the redirect handling code
        // that called this function.
        return NS_OK;
    }

    // on other request errors, try to fall back
    if (NS_FAILED(mStatus)) {
        PushRedirectAsyncFunc(&nsHttpChannel::ContinueOnStartRequest3);
        bool waitingForRedirectCallback;
        ProcessFallback(&waitingForRedirectCallback);
        if (waitingForRedirectCallback)
            return NS_OK;
        PopRedirectAsyncFunc(&nsHttpChannel::ContinueOnStartRequest3);
    }

    return ContinueOnStartRequest3(NS_OK);
}

nsresult
nsHttpChannel::ContinueOnStartRequest3(nsresult result)
{
    if (mFallingBack)
        return NS_OK;

    return CallOnStartRequest();
}

NS_IMETHODIMP
nsHttpChannel::OnStopRequest(nsIRequest *request, nsISupports *ctxt, nsresult status)
{
    PROFILER_LABEL("nsHttpChannel", "OnStopRequest",
        js::ProfileEntry::Category::NETWORK);

    LOG(("nsHttpChannel::OnStopRequest [this=%p request=%p status=%x]\n",
        this, request, status));

    MOZ_ASSERT(NS_IsMainThread(),
               "OnStopRequest should only be called from the main thread");

    if (NS_FAILED(status)) {
        ProcessSecurityReport(status);
    }

    // If this load failed because of a security error, it may be because we
    // are in a captive portal - trigger an async check to make sure.
    int32_t nsprError = -1 * NS_ERROR_GET_CODE(status);
    if (mozilla::psm::IsNSSErrorCode(nsprError)) {
        gIOService->RecheckCaptivePortal();
    }

    if (mTimingEnabled && request == mCachePump) {
        mCacheReadEnd = TimeStamp::Now();

        ReportNetVSCacheTelemetry();
    }

    // allow content to be cached if it was loaded successfully (bug #482935)
    bool contentComplete = NS_SUCCEEDED(status);

    // honor the cancelation status even if the underlying transaction completed.
    if (mCanceled || NS_FAILED(mStatus))
        status = mStatus;

    if (mCachedContentIsPartial) {
        if (NS_SUCCEEDED(status)) {
            // mTransactionPump should be suspended
            MOZ_ASSERT(request != mTransactionPump,
                       "byte-range transaction finished prematurely");

            if (request == mCachePump) {
                bool streamDone;
                status = OnDoneReadingPartialCacheEntry(&streamDone);
                if (NS_SUCCEEDED(status) && !streamDone)
                    return status;
                // otherwise, fall through and fire OnStopRequest...
            }
            else if (request == mTransactionPump) {
                MOZ_ASSERT(mConcurrentCacheAccess);
            }
            else
                NS_NOTREACHED("unexpected request");
        }
        // Do not to leave the transaction in a suspended state in error cases.
        if (NS_FAILED(status) && mTransaction)
            gHttpHandler->CancelTransaction(mTransaction, status);
    }

    nsCOMPtr<nsICompressConvStats> conv = do_QueryInterface(mCompressListener);
    if (conv) {
        conv->GetDecodedDataLength(&mDecodedBodySize);
    }

    if (mTransaction) {
        // determine if we should call DoAuthRetry
        bool authRetry = mAuthRetryPending && NS_SUCCEEDED(status);
        mStronglyFramed = mTransaction->ResponseIsComplete();
        LOG(("nsHttpChannel %p has a strongly framed transaction: %d",
             this, mStronglyFramed));

        //
        // grab references to connection in case we need to retry an
        // authentication request over it or use it for an upgrade
        // to another protocol.
        //
        // this code relies on the code in nsHttpTransaction::Close, which
        // tests for NS_HTTP_STICKY_CONNECTION to determine whether or not to
        // keep the connection around after the transaction is finished.
        //
        RefPtr<nsAHttpConnection> conn;
        LOG(("  authRetry=%d, sticky conn cap=%d", authRetry, mCaps & NS_HTTP_STICKY_CONNECTION));
        // We must check caps for stickinness also on the transaction because it
        // might have been updated by the transaction itself during inspection of
        // the reposnse headers yet on the socket thread (found connection based
        // auth schema).
        if (authRetry && (mCaps & NS_HTTP_STICKY_CONNECTION ||
                          mTransaction->Caps() & NS_HTTP_STICKY_CONNECTION)) {
            conn = mTransaction->GetConnectionReference();
            LOG(("  transaction %p provides connection %p", mTransaction.get(), conn.get()));
            // This is so far a workaround to fix leak when reusing unpersistent
            // connection for authentication retry. See bug 459620 comment 4
            // for details.
            if (conn && !conn->IsPersistent()) {
                LOG(("  connection is not persistent, not reusing it"));
                conn = nullptr;
            }
            // We do not use a sticky connection in case of a nsHttpPipeline as
            // well (see bug 1337826). This is a quick fix, because
            // nsHttpPipeline is turned off by default.
            RefPtr<nsAHttpTransaction> tranConn = do_QueryObject(conn);
            if (tranConn && tranConn->QueryPipeline()) {
                LOG(("Do not use this connection, it is a nsHttpPipeline."));
                conn = nullptr;
            }
        }

        RefPtr<nsAHttpConnection> stickyConn;
        if (mCaps & NS_HTTP_STICKY_CONNECTION) {
            stickyConn = mTransaction->GetConnectionReference();
        }

        mTransferSize = mTransaction->GetTransferSize();

        // If we are using the transaction to serve content, we also save the
        // time since async open in the cache entry so we can compare telemetry
        // between cache and net response.
        if (request == mTransactionPump && mCacheEntry &&
            !mAsyncOpenTime.IsNull() && !mOnStartRequestTimestamp.IsNull()) {
            nsAutoCString onStartTime;
            onStartTime.AppendInt( (uint64_t) (mOnStartRequestTimestamp - mAsyncOpenTime).ToMilliseconds());
            mCacheEntry->SetMetaDataElement("net-response-time-onstart", onStartTime.get());

            nsAutoCString responseTime;
            responseTime.AppendInt( (uint64_t) (TimeStamp::Now() - mAsyncOpenTime).ToMilliseconds());
            mCacheEntry->SetMetaDataElement("net-response-time-onstop", responseTime.get());
        }

        // at this point, we're done with the transaction
        mTransactionTimings = mTransaction->Timings();
        mTransaction = nullptr;
        mTransactionPump = nullptr;

        // We no longer need the dns prefetch object
        if (mDNSPrefetch && mDNSPrefetch->TimingsValid()
            && !mTransactionTimings.requestStart.IsNull()
            && !mTransactionTimings.connectStart.IsNull()
            && mDNSPrefetch->EndTimestamp() <= mTransactionTimings.connectStart) {
            // We only need the domainLookup timestamps when not using a
            // persistent connection, meaning if the endTimestamp < connectStart
            mTransactionTimings.domainLookupStart =
                mDNSPrefetch->StartTimestamp();
            mTransactionTimings.domainLookupEnd =
                mDNSPrefetch->EndTimestamp();
        }
        mDNSPrefetch = nullptr;

        // handle auth retry...
        if (authRetry) {
            mAuthRetryPending = false;
            status = DoAuthRetry(conn);
            if (NS_SUCCEEDED(status))
                return NS_OK;
        }

        // If DoAuthRetry failed, or if we have been cancelled since showing
        // the auth. dialog, then we need to send OnStartRequest now
        if (authRetry || (mAuthRetryPending && NS_FAILED(status))) {
            MOZ_ASSERT(NS_FAILED(status), "should have a failure code here");
            // NOTE: since we have a failure status, we can ignore the return
            // value from onStartRequest.
            if (mListener) {
                MOZ_ASSERT(!mOnStartRequestCalled,
                           "We should not call OnStartRequest twice.");
                mListener->OnStartRequest(this, mListenerContext);
                mOnStartRequestCalled = true;
            } else {
                NS_WARNING("OnStartRequest skipped because of null listener");
            }
        }

        // if this transaction has been replaced, then bail.
        if (mTransactionReplaced)
            return NS_OK;

        if (mUpgradeProtocolCallback && stickyConn &&
            mResponseHead && mResponseHead->Status() == 101) {
            gHttpHandler->ConnMgr()->CompleteUpgrade(stickyConn,
                                                     mUpgradeProtocolCallback);
        }
    }

    // HTTP_CHANNEL_DISPOSITION TELEMETRY
    enum ChannelDisposition
    {
        kHttpCanceled = 0,
        kHttpDisk = 1,
        kHttpNetOK = 2,
        kHttpNetEarlyFail = 3,
        kHttpNetLateFail = 4,
        kHttpsCanceled = 8,
        kHttpsDisk = 9,
        kHttpsNetOK = 10,
        kHttpsNetEarlyFail = 11,
        kHttpsNetLateFail = 12
    } chanDisposition = kHttpCanceled;

    // HTTP 0.9 is more likely to be an error than really 0.9, so count it that way
    if (mCanceled) {
        chanDisposition  = kHttpCanceled;
    } else if (!mUsedNetwork) {
        chanDisposition = kHttpDisk;
    } else if (NS_SUCCEEDED(status) &&
               mResponseHead &&
               mResponseHead->Version() != NS_HTTP_VERSION_0_9) {
        chanDisposition = kHttpNetOK;
    } else if (!mTransferSize) {
        chanDisposition = kHttpNetEarlyFail;
    } else {
        chanDisposition = kHttpNetLateFail;
    }
    if (IsHTTPS()) {
        // shift http to https disposition enums
        chanDisposition = static_cast<ChannelDisposition>(chanDisposition + kHttpsCanceled);
    }
    LOG(("  nsHttpChannel::OnStopRequest ChannelDisposition %d\n", chanDisposition));
    Telemetry::Accumulate(Telemetry::HTTP_CHANNEL_DISPOSITION, chanDisposition);

    // if needed, check cache entry has all data we expect
    if (mCacheEntry && mCachePump &&
        mConcurrentCacheAccess && contentComplete) {
        int64_t size, contentLength;
        nsresult rv = CheckPartial(mCacheEntry, &size, &contentLength);
        if (NS_SUCCEEDED(rv)) {
            if (size == int64_t(-1)) {
                // mayhemer TODO - we have to restart read from cache here at the size offset
                MOZ_ASSERT(false);
                LOG(("  cache entry write is still in progress, but we just "
                     "finished reading the cache entry"));
            }
            else if (contentLength != int64_t(-1) && contentLength != size) {
                LOG(("  concurrent cache entry write has been interrupted"));
                mCachedResponseHead = Move(mResponseHead);
                // Ignore zero partial length because we also want to resume when
                // no data at all has been read from the cache.
                rv = MaybeSetupByteRangeRequest(size, contentLength, true);
                if (NS_SUCCEEDED(rv) && mIsPartialRequest) {
                    // Prevent read from cache again
                    mCachedContentIsValid = 0;
                    mCachedContentIsPartial = 1;

                    // Perform the range request
                    rv = ContinueConnect();
                    if (NS_SUCCEEDED(rv)) {
                        LOG(("  performing range request"));
                        mCachePump = nullptr;
                        return NS_OK;
                    } else {
                        LOG(("  but range request perform failed 0x%08x", rv));
                        status = NS_ERROR_NET_INTERRUPT;
                    }
                }
                else {
                    LOG(("  but range request setup failed rv=0x%08x, failing load", rv));
                }
            }
        }
    }

    mIsPending = false;
    mStatus = status;

    // perform any final cache operations before we close the cache entry.
    if (mCacheEntry && mRequestTimeInitialized) {
        bool writeAccess;
        // New implementation just returns value of the !mCacheEntryIsReadOnly flag passed in.
        // Old implementation checks on nsICache::ACCESS_WRITE flag.
        mCacheEntry->HasWriteAccess(!mCacheEntryIsReadOnly, &writeAccess);
        if (writeAccess) {
            FinalizeCacheEntry();
        }
    }

    // Register entry to the Performance resource timing
    mozilla::dom::Performance* documentPerformance = GetPerformance();
    if (documentPerformance) {
        documentPerformance->AddEntry(this, this);
    }

    if (mListener) {
        LOG(("  calling OnStopRequest\n"));
        MOZ_ASSERT(!mOnStopRequestCalled,
                   "We should not call OnStopRequest twice");
        mListener->OnStopRequest(this, mListenerContext, status);
        mOnStopRequestCalled = true;
    }

    // If a preferred alt-data type was set, this signals the consumer is
    // interested in reading and/or writing the alt-data representation.
    // We need to hold a reference to the cache entry in case the listener calls
    // openAlternativeOutputStream() after CloseCacheEntry() clears mCacheEntry.
    if (!mPreferredCachedAltDataType.IsEmpty()) {
        mAltDataCacheEntry = mCacheEntry;
    }

    CloseCacheEntry(!contentComplete);

    if (mOfflineCacheEntry)
        CloseOfflineCacheEntry();

    if (mLoadGroup)
        mLoadGroup->RemoveRequest(this, nullptr, status);

    // We don't need this info anymore
    CleanRedirectCacheChainIfNecessary();

    ReleaseListeners();

    return NS_OK;
}

//-----------------------------------------------------------------------------
// nsHttpChannel::nsIStreamListener
//-----------------------------------------------------------------------------

class OnTransportStatusAsyncEvent : public Runnable
{
public:
    OnTransportStatusAsyncEvent(nsITransportEventSink* aEventSink,
                                nsresult aTransportStatus,
                                int64_t aProgress,
                                int64_t aProgressMax)
    : mEventSink(aEventSink)
    , mTransportStatus(aTransportStatus)
    , mProgress(aProgress)
    , mProgressMax(aProgressMax)
    {
        MOZ_ASSERT(!NS_IsMainThread(), "Shouldn't be created on main thread");
    }

    NS_IMETHOD Run() override
    {
        MOZ_ASSERT(NS_IsMainThread(), "Should run on main thread");
        if (mEventSink) {
            mEventSink->OnTransportStatus(nullptr, mTransportStatus,
                                          mProgress, mProgressMax);
        }
        return NS_OK;
    }
private:
    nsCOMPtr<nsITransportEventSink> mEventSink;
    nsresult mTransportStatus;
    int64_t mProgress;
    int64_t mProgressMax;
};

NS_IMETHODIMP
nsHttpChannel::OnDataAvailable(nsIRequest *request, nsISupports *ctxt,
                               nsIInputStream *input,
                               uint64_t offset, uint32_t count)
{
    PROFILER_LABEL("nsHttpChannel", "OnDataAvailable",
        js::ProfileEntry::Category::NETWORK);

    LOG(("nsHttpChannel::OnDataAvailable [this=%p request=%p offset=%llu count=%u]\n",
        this, request, offset, count));

    // don't send out OnDataAvailable notifications if we've been canceled.
    if (mCanceled)
        return mStatus;

    MOZ_ASSERT(mResponseHead, "No response head in ODA!!");

    MOZ_ASSERT(!(mCachedContentIsPartial && (request == mTransactionPump)),
               "transaction pump not suspended");

    if (mAuthRetryPending || (request == mTransactionPump && mTransactionReplaced)) {
        uint32_t n;
        return input->ReadSegments(NS_DiscardSegment, nullptr, count, &n);
    }

    if (mListener) {
        //
        // synthesize transport progress event.  we do this here since we want
        // to delay OnProgress events until we start streaming data.  this is
        // crucially important since it impacts the lock icon (see bug 240053).
        //
        nsresult transportStatus;
        if (request == mCachePump)
            transportStatus = NS_NET_STATUS_READING;
        else
            transportStatus = NS_NET_STATUS_RECEIVING_FROM;

        // mResponseHead may reference new or cached headers, but either way it
        // holds our best estimate of the total content length.  Even in the case
        // of a byte range request, the content length stored in the cached
        // response headers is what we want to use here.

        int64_t progressMax(mResponseHead->ContentLength());
        int64_t progress = mLogicalOffset + count;

        if ((progress > progressMax) && (progressMax != -1)) {
            NS_WARNING("unexpected progress values - "
                       "is server exceeding content length?");
        }

        // make sure params are in range for js
        if (!InScriptableRange(progressMax)) {
            progressMax = -1;
        }

        if (!InScriptableRange(progress)) {
            progress = -1;
        }

        if (NS_IsMainThread()) {
            OnTransportStatus(nullptr, transportStatus, progress, progressMax);
        } else {
            nsresult rv = NS_DispatchToMainThread(
                new OnTransportStatusAsyncEvent(this, transportStatus,
                                                progress, progressMax));
            NS_ENSURE_SUCCESS(rv, rv);
        }

        //
        // we have to manually keep the logical offset of the stream up-to-date.
        // we cannot depend solely on the offset provided, since we may have
        // already streamed some data from another source (see, for example,
        // OnDoneReadingPartialCacheEntry).
        //
        int64_t offsetBefore = 0;
        nsCOMPtr<nsISeekableStream> seekable = do_QueryInterface(input);
        if (seekable && NS_FAILED(seekable->Tell(&offsetBefore))) {
            seekable = nullptr;
        }

        nsresult rv =  mListener->OnDataAvailable(this,
                                                  mListenerContext,
                                                  input,
                                                  mLogicalOffset,
                                                  count);
        if (NS_SUCCEEDED(rv)) {
            // by contract mListener must read all of "count" bytes, but
            // nsInputStreamPump is tolerant to seekable streams that violate that
            // and it will redeliver incompletely read data. So we need to do
            // the same thing when updating the progress counter to stay in sync.
            int64_t offsetAfter, delta;
            if (seekable && NS_SUCCEEDED(seekable->Tell(&offsetAfter))) {
                delta = offsetAfter - offsetBefore;
                if (delta != count) {
                    count = delta;

                    NS_WARNING("Listener OnDataAvailable contract violation");
                    nsCOMPtr<nsIConsoleService> consoleService =
                        do_GetService(NS_CONSOLESERVICE_CONTRACTID);
                    nsAutoString message
                        (NS_LITERAL_STRING(
                        "http channel Listener OnDataAvailable contract violation"));
                    if (consoleService) {
                        consoleService->LogStringMessage(message.get());
                    }
                }
            }
            mLogicalOffset += count;
        }

        return rv;
    }

    return NS_ERROR_ABORT;
}

//-----------------------------------------------------------------------------
// nsHttpChannel::nsIThreadRetargetableRequest
//-----------------------------------------------------------------------------

NS_IMETHODIMP
nsHttpChannel::RetargetDeliveryTo(nsIEventTarget* aNewTarget)
{
    MOZ_ASSERT(NS_IsMainThread(), "Should be called on main thread only");

    NS_ENSURE_ARG(aNewTarget);
    if (aNewTarget == NS_GetCurrentThread()) {
        NS_WARNING("Retargeting delivery to same thread");
        return NS_OK;
    }
    if (!mTransactionPump && !mCachePump) {
        LOG(("nsHttpChannel::RetargetDeliveryTo %p %p no pump available\n",
             this, aNewTarget));
        return NS_ERROR_NOT_AVAILABLE;
    }

    nsresult rv = NS_OK;
    // If both cache pump and transaction pump exist, we're probably dealing
    // with partially cached content. So, we must be able to retarget both.
    nsCOMPtr<nsIThreadRetargetableRequest> retargetableCachePump;
    nsCOMPtr<nsIThreadRetargetableRequest> retargetableTransactionPump;
    if (mCachePump) {
        retargetableCachePump = do_QueryObject(mCachePump);
        // nsInputStreamPump should implement this interface.
        MOZ_ASSERT(retargetableCachePump);
        rv = retargetableCachePump->RetargetDeliveryTo(aNewTarget);
    }
    if (NS_SUCCEEDED(rv) && mTransactionPump) {
        retargetableTransactionPump = do_QueryObject(mTransactionPump);
        // nsInputStreamPump should implement this interface.
        MOZ_ASSERT(retargetableTransactionPump);
        rv = retargetableTransactionPump->RetargetDeliveryTo(aNewTarget);

        // If retarget fails for transaction pump, we must restore mCachePump.
        if (NS_FAILED(rv) && retargetableCachePump) {
            nsCOMPtr<nsIThread> mainThread;
            rv = NS_GetMainThread(getter_AddRefs(mainThread));
            NS_ENSURE_SUCCESS(rv, rv);
            rv = retargetableCachePump->RetargetDeliveryTo(mainThread);
        }
    }
    return rv;
}

//-----------------------------------------------------------------------------
// nsHttpChannel::nsThreadRetargetableStreamListener
//-----------------------------------------------------------------------------

NS_IMETHODIMP
nsHttpChannel::CheckListenerChain()
{
    NS_ASSERTION(NS_IsMainThread(), "Should be on main thread!");
    nsresult rv = NS_OK;
    nsCOMPtr<nsIThreadRetargetableStreamListener> retargetableListener =
        do_QueryInterface(mListener, &rv);
    if (retargetableListener) {
        rv = retargetableListener->CheckListenerChain();
    }
    return rv;
}

//-----------------------------------------------------------------------------
// nsHttpChannel::nsITransportEventSink
//-----------------------------------------------------------------------------

NS_IMETHODIMP
nsHttpChannel::OnTransportStatus(nsITransport *trans, nsresult status,
                                 int64_t progress, int64_t progressMax)
{
    MOZ_ASSERT(NS_IsMainThread(), "Should be on main thread only");
    // cache the progress sink so we don't have to query for it each time.
    if (!mProgressSink)
        GetCallback(mProgressSink);

    if (status == NS_NET_STATUS_CONNECTED_TO ||
        status == NS_NET_STATUS_WAITING_FOR) {
        if (mTransaction) {
            mTransaction->GetNetworkAddresses(mSelfAddr, mPeerAddr);
        } else {
            nsCOMPtr<nsISocketTransport> socketTransport =
                do_QueryInterface(trans);
            if (socketTransport) {
                socketTransport->GetSelfAddr(&mSelfAddr);
                socketTransport->GetPeerAddr(&mPeerAddr);
            }
        }
    }

    // block socket status event after Cancel or OnStopRequest has been called.
    if (mProgressSink && NS_SUCCEEDED(mStatus) && mIsPending) {
        LOG(("sending progress%s notification [this=%p status=%x"
             " progress=%lld/%lld]\n",
            (mLoadFlags & LOAD_BACKGROUND)? "" : " and status",
            this, status, progress, progressMax));

        if (!(mLoadFlags & LOAD_BACKGROUND)) {
            nsAutoCString host;
            mURI->GetHost(host);
            mProgressSink->OnStatus(this, nullptr, status,
                                    NS_ConvertUTF8toUTF16(host).get());
        }

        if (progress > 0) {
            if ((progress > progressMax) && (progressMax != -1)) {
                NS_WARNING("unexpected progress values");
            }

            // Try to get mProgressSink if it was nulled out during OnStatus.
            if (!mProgressSink) {
                GetCallback(mProgressSink);
            }
            if (mProgressSink) {
                mProgressSink->OnProgress(this, nullptr, progress, progressMax);
            }
        }
    }

    return NS_OK;
}

//-----------------------------------------------------------------------------
// nsHttpChannel::nsICacheInfoChannel
//-----------------------------------------------------------------------------

NS_IMETHODIMP
nsHttpChannel::IsFromCache(bool *value)
{
    if (!mIsPending)
        return NS_ERROR_NOT_AVAILABLE;

    // return false if reading a partial cache entry; the data isn't entirely
    // from the cache!

    *value = (mCachePump || (mLoadFlags & LOAD_ONLY_IF_MODIFIED)) &&
              mCachedContentIsValid && !mCachedContentIsPartial;

    return NS_OK;
}

NS_IMETHODIMP
nsHttpChannel::GetCacheTokenExpirationTime(uint32_t *_retval)
{
    NS_ENSURE_ARG_POINTER(_retval);
    if (!mCacheEntry)
        return NS_ERROR_NOT_AVAILABLE;

    return mCacheEntry->GetExpirationTime(_retval);
}

NS_IMETHODIMP
nsHttpChannel::GetCacheTokenCachedCharset(nsACString &_retval)
{
    nsresult rv;

    if (!mCacheEntry)
        return NS_ERROR_NOT_AVAILABLE;

    nsXPIDLCString cachedCharset;
    rv = mCacheEntry->GetMetaDataElement("charset",
                                         getter_Copies(cachedCharset));
    if (NS_SUCCEEDED(rv))
        _retval = cachedCharset;

    return rv;
}

NS_IMETHODIMP
nsHttpChannel::SetCacheTokenCachedCharset(const nsACString &aCharset)
{
    if (!mCacheEntry)
        return NS_ERROR_NOT_AVAILABLE;

    return mCacheEntry->SetMetaDataElement("charset",
                                           PromiseFlatCString(aCharset).get());
}

NS_IMETHODIMP
nsHttpChannel::SetAllowStaleCacheContent(bool aAllowStaleCacheContent)
{
    LOG(("nsHttpChannel::SetAllowStaleCacheContent [this=%p, allow=%d]",
         this, aAllowStaleCacheContent));
    mAllowStaleCacheContent = aAllowStaleCacheContent;
    return NS_OK;
}
NS_IMETHODIMP
nsHttpChannel::GetAllowStaleCacheContent(bool *aAllowStaleCacheContent)
{
    NS_ENSURE_ARG(aAllowStaleCacheContent);
    *aAllowStaleCacheContent = mAllowStaleCacheContent;
    return NS_OK;
}

NS_IMETHODIMP
nsHttpChannel::PreferAlternativeDataType(const nsACString & aType)
{
    ENSURE_CALLED_BEFORE_ASYNC_OPEN();
    mPreferredCachedAltDataType = aType;
    return NS_OK;
}

NS_IMETHODIMP
nsHttpChannel::GetAlternativeDataType(nsACString & aType)
{
    // must be called during or after OnStartRequest
    if (!mAfterOnStartRequestBegun) {
        return NS_ERROR_NOT_AVAILABLE;
    }
    aType = mAvailableCachedAltDataType;
    return NS_OK;
}

NS_IMETHODIMP
nsHttpChannel::OpenAlternativeOutputStream(const nsACString & type, nsIOutputStream * *_retval)
{
    // OnStopRequest will clear mCacheEntry, but we may use mAltDataCacheEntry
    // if the consumer called PreferAlternativeDataType()
    nsCOMPtr<nsICacheEntry> cacheEntry = mCacheEntry ? mCacheEntry : mAltDataCacheEntry;
    if (!cacheEntry) {
        return NS_ERROR_NOT_AVAILABLE;
    }
    return cacheEntry->OpenAlternativeOutputStream(type, _retval);
}

//-----------------------------------------------------------------------------
// nsHttpChannel::nsICachingChannel
//-----------------------------------------------------------------------------

NS_IMETHODIMP
nsHttpChannel::GetCacheToken(nsISupports **token)
{
    NS_ENSURE_ARG_POINTER(token);
    if (!mCacheEntry)
        return NS_ERROR_NOT_AVAILABLE;
    return CallQueryInterface(mCacheEntry, token);
}

NS_IMETHODIMP
nsHttpChannel::SetCacheToken(nsISupports *token)
{
    return NS_ERROR_NOT_IMPLEMENTED;
}

NS_IMETHODIMP
nsHttpChannel::GetOfflineCacheToken(nsISupports **token)
{
    NS_ENSURE_ARG_POINTER(token);
    if (!mOfflineCacheEntry)
        return NS_ERROR_NOT_AVAILABLE;
    return CallQueryInterface(mOfflineCacheEntry, token);
}

NS_IMETHODIMP
nsHttpChannel::SetOfflineCacheToken(nsISupports *token)
{
    return NS_ERROR_NOT_IMPLEMENTED;
}

NS_IMETHODIMP
nsHttpChannel::GetCacheKey(nsISupports **key)
{
    nsresult rv;
    NS_ENSURE_ARG_POINTER(key);

    LOG(("nsHttpChannel::GetCacheKey [this=%p]\n", this));

    *key = nullptr;

    nsCOMPtr<nsISupportsPRUint32> container =
        do_CreateInstance(NS_SUPPORTS_PRUINT32_CONTRACTID, &rv);

    if (!container)
        return NS_ERROR_OUT_OF_MEMORY;

    rv = container->SetData(mPostID);
    if (NS_FAILED(rv)) return rv;

    return CallQueryInterface(container.get(), key);
}

NS_IMETHODIMP
nsHttpChannel::SetCacheKey(nsISupports *key)
{
    nsresult rv;

    LOG(("nsHttpChannel::SetCacheKey [this=%p key=%p]\n", this, key));

    ENSURE_CALLED_BEFORE_CONNECT();

    if (!key)
        mPostID = 0;
    else {
        // extract the post id
        nsCOMPtr<nsISupportsPRUint32> container = do_QueryInterface(key, &rv);
        if (NS_FAILED(rv)) return rv;

        rv = container->GetData(&mPostID);
        if (NS_FAILED(rv)) return rv;
    }
    return NS_OK;
}

NS_IMETHODIMP
nsHttpChannel::GetCacheOnlyMetadata(bool *aOnlyMetadata)
{
    NS_ENSURE_ARG(aOnlyMetadata);
    *aOnlyMetadata = mCacheOnlyMetadata;
    return NS_OK;
}

NS_IMETHODIMP
nsHttpChannel::SetCacheOnlyMetadata(bool aOnlyMetadata)
{
    LOG(("nsHttpChannel::SetCacheOnlyMetadata [this=%p only-metadata=%d]\n",
        this, aOnlyMetadata));

    ENSURE_CALLED_BEFORE_ASYNC_OPEN();

    mCacheOnlyMetadata = aOnlyMetadata;
    if (aOnlyMetadata) {
        mLoadFlags |= LOAD_ONLY_IF_MODIFIED;
    }

    return NS_OK;
}

NS_IMETHODIMP
nsHttpChannel::GetPin(bool *aPin)
{
    NS_ENSURE_ARG(aPin);
    *aPin = mPinCacheContent;
    return NS_OK;
}

NS_IMETHODIMP
nsHttpChannel::SetPin(bool aPin)
{
    LOG(("nsHttpChannel::SetPin [this=%p pin=%d]\n",
        this, aPin));

    ENSURE_CALLED_BEFORE_CONNECT();

    mPinCacheContent = aPin;
    return NS_OK;
}

NS_IMETHODIMP
nsHttpChannel::ForceCacheEntryValidFor(uint32_t aSecondsToTheFuture)
{
    if (!mCacheEntry) {
        LOG(("nsHttpChannel::ForceCacheEntryValidFor found no cache entry "
             "for this channel [this=%p].", this));
    } else {
        mCacheEntry->ForceValidFor(aSecondsToTheFuture);

        nsAutoCString key;
        mCacheEntry->GetKey(key);

        LOG(("nsHttpChannel::ForceCacheEntryValidFor successfully forced valid "
             "entry with key %s for %d seconds. [this=%p]", key.get(),
             aSecondsToTheFuture, this));
    }

    return NS_OK;
}

//-----------------------------------------------------------------------------
// nsHttpChannel::nsIResumableChannel
//-----------------------------------------------------------------------------

NS_IMETHODIMP
nsHttpChannel::ResumeAt(uint64_t aStartPos,
                        const nsACString& aEntityID)
{
    LOG(("nsHttpChannel::ResumeAt [this=%p startPos=%llu id='%s']\n",
         this, aStartPos, PromiseFlatCString(aEntityID).get()));
    mEntityID = aEntityID;
    mStartPos = aStartPos;
    mResuming = true;
    return NS_OK;
}

nsresult
nsHttpChannel::DoAuthRetry(nsAHttpConnection *conn)
{
    LOG(("nsHttpChannel::DoAuthRetry [this=%p]\n", this));

    MOZ_ASSERT(!mTransaction, "should not have a transaction");
    nsresult rv;

    // toggle mIsPending to allow nsIObserver implementations to modify
    // the request headers (bug 95044).
    mIsPending = false;

    // fetch cookies, and add them to the request header.
    // the server response could have included cookies that must be sent with
    // this authentication attempt (bug 84794).
    // TODO: save cookies from auth response and send them here (bug 572151).
    AddCookiesToRequest();

    // notify "http-on-modify-request" observers
    CallOnModifyRequestObservers();

    mIsPending = true;

    // get rid of the old response headers
    mResponseHead = nullptr;

    // rewind the upload stream
    if (mUploadStream) {
        nsCOMPtr<nsISeekableStream> seekable = do_QueryInterface(mUploadStream);
        if (seekable)
            seekable->Seek(nsISeekableStream::NS_SEEK_SET, 0);
    }

    // set sticky connection flag and disable pipelining.
    mCaps |=  NS_HTTP_STICKY_CONNECTION;
    mCaps &= ~NS_HTTP_ALLOW_PIPELINING;

    // and create a new one...
    rv = SetupTransaction();
    if (NS_FAILED(rv)) return rv;

    // transfer ownership of connection to transaction
    if (conn)
        mTransaction->SetConnection(conn);

    rv = gHttpHandler->InitiateTransaction(mTransaction, mPriority);
    if (NS_FAILED(rv)) return rv;

    rv = mTransactionPump->AsyncRead(this, nullptr);
    if (NS_FAILED(rv)) return rv;

    uint32_t suspendCount = mSuspendCount;
    while (suspendCount--)
        mTransactionPump->Suspend();

    return NS_OK;
}

//-----------------------------------------------------------------------------
// nsHttpChannel::nsIApplicationCacheChannel
//-----------------------------------------------------------------------------

NS_IMETHODIMP
nsHttpChannel::GetApplicationCache(nsIApplicationCache **out)
{
    NS_IF_ADDREF(*out = mApplicationCache);
    return NS_OK;
}

NS_IMETHODIMP
nsHttpChannel::SetApplicationCache(nsIApplicationCache *appCache)
{
    ENSURE_CALLED_BEFORE_CONNECT();

    mApplicationCache = appCache;
    return NS_OK;
}

NS_IMETHODIMP
nsHttpChannel::GetApplicationCacheForWrite(nsIApplicationCache **out)
{
    NS_IF_ADDREF(*out = mApplicationCacheForWrite);
    return NS_OK;
}

NS_IMETHODIMP
nsHttpChannel::SetApplicationCacheForWrite(nsIApplicationCache *appCache)
{
    ENSURE_CALLED_BEFORE_CONNECT();

    mApplicationCacheForWrite = appCache;
    return NS_OK;
}

NS_IMETHODIMP
nsHttpChannel::GetLoadedFromApplicationCache(bool *aLoadedFromApplicationCache)
{
    *aLoadedFromApplicationCache = mLoadedFromApplicationCache;
    return NS_OK;
}

NS_IMETHODIMP
nsHttpChannel::GetInheritApplicationCache(bool *aInherit)
{
    *aInherit = mInheritApplicationCache;
    return NS_OK;
}

NS_IMETHODIMP
nsHttpChannel::SetInheritApplicationCache(bool aInherit)
{
    ENSURE_CALLED_BEFORE_CONNECT();

    mInheritApplicationCache = aInherit;
    return NS_OK;
}

NS_IMETHODIMP
nsHttpChannel::GetChooseApplicationCache(bool *aChoose)
{
    *aChoose = mChooseApplicationCache;
    return NS_OK;
}

NS_IMETHODIMP
nsHttpChannel::SetChooseApplicationCache(bool aChoose)
{
    ENSURE_CALLED_BEFORE_CONNECT();

    mChooseApplicationCache = aChoose;
    return NS_OK;
}

nsHttpChannel::OfflineCacheEntryAsForeignMarker*
nsHttpChannel::GetOfflineCacheEntryAsForeignMarker()
{
    if (!mApplicationCache)
        return nullptr;

    return new OfflineCacheEntryAsForeignMarker(mApplicationCache, mURI);
}

nsresult
nsHttpChannel::OfflineCacheEntryAsForeignMarker::MarkAsForeign()
{
    nsresult rv;

    nsCOMPtr<nsIURI> noRefURI;
    rv = mCacheURI->CloneIgnoringRef(getter_AddRefs(noRefURI));
    NS_ENSURE_SUCCESS(rv, rv);

    nsAutoCString spec;
    rv = noRefURI->GetAsciiSpec(spec);
    NS_ENSURE_SUCCESS(rv, rv);

    return mApplicationCache->MarkEntry(spec,
                                        nsIApplicationCache::ITEM_FOREIGN);
}

NS_IMETHODIMP
nsHttpChannel::MarkOfflineCacheEntryAsForeign()
{
    nsresult rv;

    nsAutoPtr<OfflineCacheEntryAsForeignMarker> marker(
        GetOfflineCacheEntryAsForeignMarker());

    if (!marker)
        return NS_ERROR_NOT_AVAILABLE;

    rv = marker->MarkAsForeign();
    NS_ENSURE_SUCCESS(rv, rv);

    return NS_OK;
}

//-----------------------------------------------------------------------------
// nsHttpChannel::nsIAsyncVerifyRedirectCallback
//-----------------------------------------------------------------------------

nsresult
nsHttpChannel::WaitForRedirectCallback()
{
    nsresult rv;
    LOG(("nsHttpChannel::WaitForRedirectCallback [this=%p]\n", this));

    if (mTransactionPump) {
        rv = mTransactionPump->Suspend();
        NS_ENSURE_SUCCESS(rv, rv);
    }
    if (mCachePump) {
        rv = mCachePump->Suspend();
        if (NS_FAILED(rv) && mTransactionPump) {
#ifdef DEBUG
            nsresult resume =
#endif
            mTransactionPump->Resume();
            MOZ_ASSERT(NS_SUCCEEDED(resume),
                       "Failed to resume transaction pump");
        }
        NS_ENSURE_SUCCESS(rv, rv);
    }

    mWaitingForRedirectCallback = true;
    return NS_OK;
}

NS_IMETHODIMP
nsHttpChannel::OnRedirectVerifyCallback(nsresult result)
{
    LOG(("nsHttpChannel::OnRedirectVerifyCallback [this=%p] "
         "result=%x stack=%d mWaitingForRedirectCallback=%u\n",
         this, result, mRedirectFuncStack.Length(), mWaitingForRedirectCallback));
    MOZ_ASSERT(mWaitingForRedirectCallback,
               "Someone forgot to call WaitForRedirectCallback() ?!");
    mWaitingForRedirectCallback = false;

    if (mCanceled && NS_SUCCEEDED(result))
        result = NS_BINDING_ABORTED;

    for (uint32_t i = mRedirectFuncStack.Length(); i > 0;) {
        --i;
        // Pop the last function pushed to the stack
        nsContinueRedirectionFunc func = mRedirectFuncStack[i];
        mRedirectFuncStack.RemoveElementAt(mRedirectFuncStack.Length() - 1);

        // Call it with the result we got from the callback or the deeper
        // function call.
        result = (this->*func)(result);

        // If a new function has been pushed to the stack and placed us in the
        // waiting state, we need to break the chain and wait for the callback
        // again.
        if (mWaitingForRedirectCallback)
            break;
    }

    if (NS_FAILED(result) && !mCanceled) {
        // First, cancel this channel if we are in failure state to set mStatus
        // and let it be propagated to pumps.
        Cancel(result);
    }

    if (!mWaitingForRedirectCallback) {
        // We are not waiting for the callback. At this moment we must release
        // reference to the redirect target channel, otherwise we may leak.
        mRedirectChannel = nullptr;
    }

    // We always resume the pumps here. If all functions on stack have been
    // called we need OnStopRequest to be triggered, and if we broke out of the
    // loop above (and are thus waiting for a new callback) the suspension
    // count must be balanced in the pumps.
    if (mTransactionPump)
        mTransactionPump->Resume();
    if (mCachePump)
        mCachePump->Resume();

    return result;
}

void
nsHttpChannel::PushRedirectAsyncFunc(nsContinueRedirectionFunc func)
{
    mRedirectFuncStack.AppendElement(func);
}

void
nsHttpChannel::PopRedirectAsyncFunc(nsContinueRedirectionFunc func)
{
    MOZ_ASSERT(func == mRedirectFuncStack[mRedirectFuncStack.Length() - 1],
               "Trying to pop wrong method from redirect async stack!");

    mRedirectFuncStack.TruncateLength(mRedirectFuncStack.Length() - 1);
}

//-----------------------------------------------------------------------------
// nsIDNSListener functions
//-----------------------------------------------------------------------------

NS_IMETHODIMP
nsHttpChannel::OnLookupComplete(nsICancelable *request,
                                nsIDNSRecord  *rec,
                                nsresult       status)
{
    MOZ_ASSERT(NS_IsMainThread(), "Expecting DNS callback on main thread.");

    LOG(("nsHttpChannel::OnLookupComplete [this=%p] prefetch complete%s: "
         "%s status[0x%x]\n",
         this, mCaps & NS_HTTP_REFRESH_DNS ? ", refresh requested" : "",
         NS_SUCCEEDED(status) ? "success" : "failure", status));

    // We no longer need the dns prefetch object. Note: mDNSPrefetch could be
    // validly null if OnStopRequest has already been called.
    // We only need the domainLookup timestamps when not loading from cache
    if (mDNSPrefetch && mDNSPrefetch->TimingsValid() && mTransaction) {
        TimeStamp connectStart = mTransaction->GetConnectStart();
        TimeStamp requestStart = mTransaction->GetRequestStart();
        // We only set the domainLookup timestamps if we're not using a
        // persistent connection.
        if (requestStart.IsNull() && connectStart.IsNull()) {
            mTransaction->SetDomainLookupStart(mDNSPrefetch->StartTimestamp());
            mTransaction->SetDomainLookupEnd(mDNSPrefetch->EndTimestamp());
        }
    }
    mDNSPrefetch = nullptr;

    // Unset DNS cache refresh if it was requested,
    if (mCaps & NS_HTTP_REFRESH_DNS) {
        mCaps &= ~NS_HTTP_REFRESH_DNS;
        if (mTransaction) {
            mTransaction->SetDNSWasRefreshed();
        }
    }

    return NS_OK;
}

//-----------------------------------------------------------------------------
// nsHttpChannel internal functions
//-----------------------------------------------------------------------------

// Creates an URI to the given location using current URI for base and charset
nsresult
nsHttpChannel::CreateNewURI(const char *loc, nsIURI **newURI)
{
    nsCOMPtr<nsIIOService> ioService;
    nsresult rv = gHttpHandler->GetIOService(getter_AddRefs(ioService));
    if (NS_FAILED(rv)) return rv;

    // the new uri should inherit the origin charset of the current uri
    nsAutoCString originCharset;
    rv = mURI->GetOriginCharset(originCharset);
    if (NS_FAILED(rv))
        originCharset.Truncate();

    return ioService->NewURI(nsDependentCString(loc),
                             originCharset.get(),
                             mURI,
                             newURI);
}

void
nsHttpChannel::MaybeInvalidateCacheEntryForSubsequentGet()
{
    // See RFC 2616 section 5.1.1. These are considered valid
    // methods which DO NOT invalidate cache-entries for the
    // referred resource. POST, PUT and DELETE as well as any
    // other method not listed here will potentially invalidate
    // any cached copy of the resource
    if (mRequestHead.IsGet() || mRequestHead.IsOptions() ||
        mRequestHead.IsHead() || mRequestHead.IsTrace() ||
        mRequestHead.IsConnect()) {
        return;
    }

    // Invalidate the request-uri.
    if (LOG_ENABLED()) {
      nsAutoCString key;
      mURI->GetAsciiSpec(key);
      LOG(("MaybeInvalidateCacheEntryForSubsequentGet [this=%p uri=%s]\n",
          this, key.get()));
    }

    DoInvalidateCacheEntry(mURI);

    // Invalidate Location-header if set
    nsAutoCString location;
    mResponseHead->GetHeader(nsHttp::Location, location);
    if (!location.IsEmpty()) {
        LOG(("  Location-header=%s\n", location.get()));
        InvalidateCacheEntryForLocation(location.get());
    }

    // Invalidate Content-Location-header if set
    mResponseHead->GetHeader(nsHttp::Content_Location, location);
    if (!location.IsEmpty()) {
        LOG(("  Content-Location-header=%s\n", location.get()));
        InvalidateCacheEntryForLocation(location.get());
    }
}

void
nsHttpChannel::InvalidateCacheEntryForLocation(const char *location)
{
    nsAutoCString tmpCacheKey, tmpSpec;
    nsCOMPtr<nsIURI> resultingURI;
    nsresult rv = CreateNewURI(location, getter_AddRefs(resultingURI));
    if (NS_SUCCEEDED(rv) && HostPartIsTheSame(resultingURI)) {
        DoInvalidateCacheEntry(resultingURI);
    } else {
        LOG(("  hosts not matching\n"));
    }
}

void
nsHttpChannel::DoInvalidateCacheEntry(nsIURI* aURI)
{
    // NOTE:
    // Following comments 24,32 and 33 in bug #327765, we only care about
    // the cache in the protocol-handler, not the application cache.
    // The logic below deviates from the original logic in OpenCacheEntry on
    // one point by using only READ_ONLY access-policy. I think this is safe.

    nsresult rv;

    nsAutoCString key;
    if (LOG_ENABLED()) {
      aURI->GetAsciiSpec(key);
    }

    LOG(("DoInvalidateCacheEntry [channel=%p key=%s]", this, key.get()));

    nsCOMPtr<nsICacheStorageService> cacheStorageService =
        do_GetService("@mozilla.org/netwerk/cache-storage-service;1", &rv);

    nsCOMPtr<nsICacheStorage> cacheStorage;
    if (NS_SUCCEEDED(rv)) {
        RefPtr<LoadContextInfo> info = GetLoadContextInfo(this);
        rv = cacheStorageService->DiskCacheStorage(info, false, getter_AddRefs(cacheStorage));
    }

    if (NS_SUCCEEDED(rv)) {
        rv = cacheStorage->AsyncDoomURI(aURI, EmptyCString(), nullptr);
    }

    LOG(("DoInvalidateCacheEntry [channel=%p key=%s rv=%d]", this, key.get(), int(rv)));
}

void
nsHttpChannel::AsyncOnExamineCachedResponse()
{
    gHttpHandler->OnExamineCachedResponse(this);

}

void
nsHttpChannel::UpdateAggregateCallbacks()
{
    if (!mTransaction) {
        return;
    }
    nsCOMPtr<nsIInterfaceRequestor> callbacks;
    NS_NewNotificationCallbacksAggregation(mCallbacks, mLoadGroup,
                                           NS_GetCurrentThread(),
                                           getter_AddRefs(callbacks));
    mTransaction->SetSecurityCallbacks(callbacks);
}

NS_IMETHODIMP
nsHttpChannel::SetLoadGroup(nsILoadGroup *aLoadGroup)
{
    MOZ_ASSERT(NS_IsMainThread(), "Wrong thread.");

    nsresult rv = HttpBaseChannel::SetLoadGroup(aLoadGroup);
    if (NS_SUCCEEDED(rv)) {
        UpdateAggregateCallbacks();
    }
    return rv;
}

NS_IMETHODIMP
nsHttpChannel::SetNotificationCallbacks(nsIInterfaceRequestor *aCallbacks)
{
    MOZ_ASSERT(NS_IsMainThread(), "Wrong thread.");

    nsresult rv = HttpBaseChannel::SetNotificationCallbacks(aCallbacks);
    if (NS_SUCCEEDED(rv)) {
        UpdateAggregateCallbacks();
    }
    return rv;
}

void
nsHttpChannel::MarkIntercepted()
{
    mInterceptCache = INTERCEPTED;
}

NS_IMETHODIMP
nsHttpChannel::GetResponseSynthesized(bool* aSynthesized)
{
    NS_ENSURE_ARG_POINTER(aSynthesized);
    *aSynthesized = (mInterceptCache == INTERCEPTED);
    return NS_OK;
}

bool
nsHttpChannel::AwaitingCacheCallbacks()
{
    return mCacheEntriesToWaitFor != 0;
}

void
nsHttpChannel::SetPushedStream(Http2PushedStream *stream)
{
    MOZ_ASSERT(stream);
    MOZ_ASSERT(!mPushedStream);
    mPushedStream = stream;
}

nsresult
nsHttpChannel::OnPush(const nsACString &url, Http2PushedStream *pushedStream)
{
    MOZ_ASSERT(NS_IsMainThread());
    LOG(("nsHttpChannel::OnPush [this=%p]\n", this));

    MOZ_ASSERT(mCaps & NS_HTTP_ONPUSH_LISTENER);
    nsCOMPtr<nsIHttpPushListener> pushListener;
    NS_QueryNotificationCallbacks(mCallbacks,
                                  mLoadGroup,
                                  NS_GET_IID(nsIHttpPushListener),
                                  getter_AddRefs(pushListener));

    MOZ_ASSERT(pushListener);
    if (!pushListener) {
        LOG(("nsHttpChannel::OnPush [this=%p] notification callbacks do not "
             "implement nsIHttpPushListener\n", this));
        return NS_ERROR_UNEXPECTED;
    }

    nsCOMPtr<nsIURI> pushResource;
    nsresult rv;

    // Create a Channel for the Push Resource
    rv = NS_NewURI(getter_AddRefs(pushResource), url);
    if (NS_FAILED(rv)) {
        return NS_ERROR_FAILURE;
    }

    nsCOMPtr<nsIIOService> ioService;
    rv = gHttpHandler->GetIOService(getter_AddRefs(ioService));
    NS_ENSURE_SUCCESS(rv, rv);

    nsCOMPtr<nsIChannel> pushChannel;
    rv = NS_NewChannelInternal(getter_AddRefs(pushChannel),
                               pushResource,
                               mLoadInfo,
                               nullptr, // aLoadGroup
                               nullptr, // aCallbacks
                               nsIRequest::LOAD_NORMAL,
                               ioService);
    NS_ENSURE_SUCCESS(rv, rv);

    nsCOMPtr<nsIHttpChannel> pushHttpChannel = do_QueryInterface(pushChannel);
    MOZ_ASSERT(pushHttpChannel);
    if (!pushHttpChannel) {
        return NS_ERROR_UNEXPECTED;
    }

    RefPtr<nsHttpChannel> channel;
    CallQueryInterface(pushHttpChannel, channel.StartAssignment());
    MOZ_ASSERT(channel);
    if (!channel) {
        return NS_ERROR_UNEXPECTED;
    }

    // new channel needs mrqeuesthead and headers from pushedStream
    channel->mRequestHead.ParseHeaderSet(
        pushedStream->GetRequestString().BeginWriting());

    channel->mLoadGroup = mLoadGroup;
    channel->mLoadInfo = mLoadInfo;
    channel->mCallbacks = mCallbacks;

    // Link the pushed stream with the new channel and call listener
    channel->SetPushedStream(pushedStream);
    rv = pushListener->OnPush(this, pushHttpChannel);
    return rv;
}

// static
bool nsHttpChannel::IsRedirectStatus(uint32_t status)
{
    // 305 disabled as a security measure (see bug 187996).
    return status == 300 || status == 301 || status == 302 || status == 303 ||
           status == 307 || status == 308;
}

void
nsHttpChannel::SetCouldBeSynthesized()
{
  MOZ_ASSERT(!BypassServiceWorker());
  mResponseCouldBeSynthesized = true;
}

void
nsHttpChannel::SetConnectionInfo(nsHttpConnectionInfo *aCI)
{
    mConnectionInfo = aCI ? aCI->Clone() : nullptr;
}

NS_IMETHODIMP
nsHttpChannel::OnPreflightSucceeded()
{
    MOZ_ASSERT(mRequireCORSPreflight, "Why did a preflight happen?");
    mIsCorsPreflightDone = 1;
    mPreflightChannel = nullptr;

    return ContinueConnect();
}

NS_IMETHODIMP
nsHttpChannel::OnPreflightFailed(nsresult aError)
{
    MOZ_ASSERT(mRequireCORSPreflight, "Why did a preflight happen?");
    mIsCorsPreflightDone = 1;
    mPreflightChannel = nullptr;

    CloseCacheEntry(false);
    AsyncAbort(aError);
    return NS_OK;
}

//-----------------------------------------------------------------------------
// nsIHstsPrimingCallback functions
//-----------------------------------------------------------------------------

/*
 * May be invoked synchronously if HSTS priming has already been performed
 * for the host.
 */
nsresult
nsHttpChannel::OnHSTSPrimingSucceeded(bool aCached)
{
    if (nsMixedContentBlocker::sUseHSTS) {
        // redirect the channel to HTTPS if the pref
        // "security.mixed_content.use_hsts" is true
        LOG(("HSTS Priming succeeded, redirecting to HTTPS [this=%p]", this));
        Telemetry::Accumulate(Telemetry::MIXED_CONTENT_HSTS_PRIMING_RESULT,
                (aCached) ? HSTSPrimingResult::eHSTS_PRIMING_CACHED_DO_UPGRADE :
                            HSTSPrimingResult::eHSTS_PRIMING_SUCCEEDED);
        return AsyncCall(&nsHttpChannel::HandleAsyncRedirectChannelToHttps);
    }

    // If "security.mixed_content.use_hsts" is false, record the result of
    // HSTS priming and block or proceed with the load as required by
    // mixed-content blocking
    bool wouldBlock = mLoadInfo->GetMixedContentWouldBlock();

    // preserve the mixed-content-before-hsts order and block if required
    if (wouldBlock) {
        LOG(("HSTS Priming succeeded, blocking for mixed-content [this=%p]",
                    this));
        Telemetry::Accumulate(Telemetry::MIXED_CONTENT_HSTS_PRIMING_RESULT,
                              HSTSPrimingResult::eHSTS_PRIMING_SUCCEEDED_BLOCK);
        CloseCacheEntry(false);
        return AsyncAbort(NS_ERROR_CONTENT_BLOCKED);
    }

    LOG(("HSTS Priming succeeded, loading insecure: [this=%p]", this));
    Telemetry::Accumulate(Telemetry::MIXED_CONTENT_HSTS_PRIMING_RESULT,
                          HSTSPrimingResult::eHSTS_PRIMING_SUCCEEDED_HTTP);

    nsresult rv = ContinueConnect();
    if (NS_FAILED(rv)) {
        CloseCacheEntry(false);
        return AsyncAbort(rv);
    }

    return NS_OK;
}

/*
 * May be invoked synchronously if HSTS priming has already been performed
 * for the host.
 */
nsresult
nsHttpChannel::OnHSTSPrimingFailed(nsresult aError, bool aCached)
{
    bool wouldBlock = mLoadInfo->GetMixedContentWouldBlock();

    LOG(("HSTS Priming Failed [this=%p], %s the load", this,
                (wouldBlock) ? "blocking" : "allowing"));
    if (aCached) {
        // Between the time we marked for priming and started the priming request,
        // the host was found to not allow the upgrade, probably from another
        // priming request.
        Telemetry::Accumulate(Telemetry::MIXED_CONTENT_HSTS_PRIMING_RESULT,
                (wouldBlock) ?  HSTSPrimingResult::eHSTS_PRIMING_CACHED_BLOCK :
                                HSTSPrimingResult::eHSTS_PRIMING_CACHED_NO_UPGRADE);
    } else {
        // A priming request was sent, and no HSTS header was found that allows
        // the upgrade.
        Telemetry::Accumulate(Telemetry::MIXED_CONTENT_HSTS_PRIMING_RESULT,
                (wouldBlock) ?  HSTSPrimingResult::eHSTS_PRIMING_FAILED_BLOCK :
                                HSTSPrimingResult::eHSTS_PRIMING_FAILED_ACCEPT);
    }

    // Don't visit again for at least
    // security.mixed_content.hsts_priming_cache_timeout seconds.
    nsISiteSecurityService* sss = gHttpHandler->GetSSService();
    NS_ENSURE_TRUE(sss, NS_ERROR_OUT_OF_MEMORY);
    nsresult rv = sss->CacheNegativeHSTSResult(mURI,
            nsMixedContentBlocker::sHSTSPrimingCacheTimeout);
    if (NS_FAILED(rv)) {
        NS_ERROR("nsISiteSecurityService::CacheNegativeHSTSResult failed");
    }

    // If we would block, go ahead and abort with the error provided
    if (wouldBlock) {
        CloseCacheEntry(false);
        return AsyncAbort(aError);
    }

    // we can continue the load and the UI has been updated as mixed content
    rv = ContinueConnect();
    if (NS_FAILED(rv)) {
        CloseCacheEntry(false);
        return AsyncAbort(rv);
    }

    return NS_OK;
}

//-----------------------------------------------------------------------------
// AChannelHasDivertableParentChannelAsListener internal functions
//-----------------------------------------------------------------------------

NS_IMETHODIMP
nsHttpChannel::MessageDiversionStarted(ADivertableParentChannel *aParentChannel)
{
  LOG(("nsHttpChannel::MessageDiversionStarted [this=%p]", this));
  MOZ_ASSERT(!mParentChannel);
  mParentChannel = aParentChannel;
  // If the channel is suspended, propagate that info to the parent's mEventQ.
  uint32_t suspendCount = mSuspendCount;
  while (suspendCount--) {
    mParentChannel->SuspendMessageDiversion();
  }
  return NS_OK;
}

NS_IMETHODIMP
nsHttpChannel::MessageDiversionStop()
{
  LOG(("nsHttpChannel::MessageDiversionStop [this=%p]", this));
  MOZ_ASSERT(mParentChannel);
  mParentChannel = nullptr;
  return NS_OK;
}

NS_IMETHODIMP
nsHttpChannel::SuspendInternal()
{
    NS_ENSURE_TRUE(mIsPending, NS_ERROR_NOT_AVAILABLE);

    LOG(("nsHttpChannel::SuspendInternal [this=%p]\n", this));

    ++mSuspendCount;

    nsresult rvTransaction = NS_OK;
    if (mTransactionPump) {
        rvTransaction = mTransactionPump->Suspend();
    }
    nsresult rvCache = NS_OK;
    if (mCachePump) {
        rvCache = mCachePump->Suspend();
    }

    return NS_FAILED(rvTransaction) ? rvTransaction : rvCache;
}

NS_IMETHODIMP
nsHttpChannel::ResumeInternal()
{
    NS_ENSURE_TRUE(mSuspendCount > 0, NS_ERROR_UNEXPECTED);

    LOG(("nsHttpChannel::ResumeInternal [this=%p]\n", this));

    if (--mSuspendCount == 0 && mCallOnResume) {
        nsresult rv = AsyncCall(mCallOnResume);
        mCallOnResume = nullptr;
        NS_ENSURE_SUCCESS(rv, rv);
    }

    nsresult rvTransaction = NS_OK;
    if (mTransactionPump) {
        rvTransaction = mTransactionPump->Resume();
    }

    nsresult rvCache = NS_OK;
    if (mCachePump) {
        rvCache = mCachePump->Resume();
    }

    return NS_FAILED(rvTransaction) ? rvTransaction : rvCache;
}

void
nsHttpChannel::MaybeWarnAboutAppCache()
{
    // First, accumulate a telemetry ping about appcache usage.
    Telemetry::Accumulate(Telemetry::HTTP_OFFLINE_CACHE_DOCUMENT_LOAD,
                          true);

    // Then, issue a deprecation warning.
    nsCOMPtr<nsIDeprecationWarner> warner;
    GetCallback(warner);
    if (warner) {
        warner->IssueWarning(nsIDocument::eAppCache, false);
    }
}

void
nsHttpChannel::SetLoadGroupUserAgentOverride()
{
    nsCOMPtr<nsIURI> uri;
    GetURI(getter_AddRefs(uri));
    nsAutoCString uriScheme;
    if (uri) {
        uri->GetScheme(uriScheme);
    }

    // We don't need a UA for file: protocols.
    if (uriScheme.EqualsLiteral("file")) {
        gHttpHandler->OnUserAgentRequest(this);
        return;
    }

    nsIRequestContextService* rcsvc = gHttpHandler->GetRequestContextService();
    nsCOMPtr<nsIRequestContext> rc;
    if (rcsvc) {
        rcsvc->GetRequestContext(mRequestContextID,
                                    getter_AddRefs(rc));
    }

    nsAutoCString ua;
    if (nsContentUtils::IsNonSubresourceRequest(this)) {
        gHttpHandler->OnUserAgentRequest(this);
        if (rc) {
            GetRequestHeader(NS_LITERAL_CSTRING("User-Agent"), ua);
            rc->SetUserAgentOverride(ua);
        }
    } else {
        GetRequestHeader(NS_LITERAL_CSTRING("User-Agent"), ua);
        // Don't overwrite the UA if it is already set (eg by an XHR with explicit UA).
        if (ua.IsEmpty()) {
            if (rc) {
                rc->GetUserAgentOverride(ua);
                SetRequestHeader(NS_LITERAL_CSTRING("User-Agent"), ua, false);
            } else {
                gHttpHandler->OnUserAgentRequest(this);
            }
        }
    }
}

void
nsHttpChannel::SetDoNotTrack()
{
  /**
   * 'DoNotTrack' header should be added if 'privacy.donottrackheader.enabled'
   * is true or tracking protection is enabled. See bug 1258033.
   */
  nsCOMPtr<nsILoadContext> loadContext;
  NS_QueryNotificationCallbacks(this, loadContext);

  if ((loadContext && loadContext->UseTrackingProtection()) ||
      nsContentUtils::DoNotTrackEnabled()) {
    mRequestHead.SetHeader(nsHttp::DoNotTrack,
                           NS_LITERAL_CSTRING("1"),
                           false);
  }
}


void
nsHttpChannel::ReportNetVSCacheTelemetry()
{
    nsresult rv;
    if (!mCacheEntry) {
        return;
    }

    // We only report telemetry if the entry is persistent (on disk)
    bool persistent;
    rv = mCacheEntry->GetPersistent(&persistent);
    if (NS_FAILED(rv) || !persistent) {
        return;
    }

    nsXPIDLCString tmpStr;
    rv = mCacheEntry->GetMetaDataElement("net-response-time-onstart",
                                         getter_Copies(tmpStr));
    if (NS_FAILED(rv)) {
        return;
    }
    uint64_t onStartNetTime = tmpStr.ToInteger64(&rv);
    if (NS_FAILED(rv)) {
        return;
    }

    tmpStr.Truncate();
    rv = mCacheEntry->GetMetaDataElement("net-response-time-onstop",
                                         getter_Copies(tmpStr));
    if (NS_FAILED(rv)) {
        return;
    }
    uint64_t onStopNetTime = tmpStr.ToInteger64(&rv);
    if (NS_FAILED(rv)) {
        return;
    }

    uint64_t onStartCacheTime = (mOnStartRequestTimestamp - mAsyncOpenTime).ToMilliseconds();
    int64_t onStartDiff = onStartNetTime - onStartCacheTime;
    onStartDiff += 500; // We offset the difference by 500 ms to report positive values in telemetry

    uint64_t onStopCacheTime = (mCacheReadEnd - mAsyncOpenTime).ToMilliseconds();
    int64_t onStopDiff = onStopNetTime - onStopCacheTime;
    onStopDiff += 500; // We offset the difference by 500 ms

    if (mDidReval) {
        Telemetry::Accumulate(Telemetry::HTTP_NET_VS_CACHE_ONSTART_REVALIDATED, onStartDiff);
        Telemetry::Accumulate(Telemetry::HTTP_NET_VS_CACHE_ONSTOP_REVALIDATED, onStopDiff);
    } else {
        Telemetry::Accumulate(Telemetry::HTTP_NET_VS_CACHE_ONSTART_NOTREVALIDATED, onStartDiff);
        Telemetry::Accumulate(Telemetry::HTTP_NET_VS_CACHE_ONSTOP_NOTREVALIDATED, onStopDiff);
    }

    if (mDidReval) {
        // We don't report revalidated probes as the data would be skewed.
        return;
    }

    uint32_t diskStorageSizeK = 0;
    rv = mCacheEntry->GetDiskStorageSizeInKB(&diskStorageSizeK);
    if (NS_FAILED(rv)) {
        return;
    }

    nsAutoCString contentType;
    if (mResponseHead && mResponseHead->HasContentType()) {
        mResponseHead->ContentType(contentType);
    }
    bool isImage = StringBeginsWith(contentType, NS_LITERAL_CSTRING("image/"));
    if (isImage) {
        Telemetry::Accumulate(Telemetry::HTTP_NET_VS_CACHE_ONSTART_ISIMG, onStartDiff);
        Telemetry::Accumulate(Telemetry::HTTP_NET_VS_CACHE_ONSTOP_ISIMG, onStopDiff);
    } else {
        Telemetry::Accumulate(Telemetry::HTTP_NET_VS_CACHE_ONSTART_NOTIMG, onStartDiff);
        Telemetry::Accumulate(Telemetry::HTTP_NET_VS_CACHE_ONSTOP_NOTIMG, onStopDiff);
    }

    if (mCacheOpenWithPriority) {
        if (mCacheQueueSizeWhenOpen < 5) {
            Telemetry::Accumulate(Telemetry::HTTP_NET_VS_CACHE_ONSTART_QSMALL_HIGHPRI, onStartDiff);
            Telemetry::Accumulate(Telemetry::HTTP_NET_VS_CACHE_ONSTOP_QSMALL_HIGHPRI, onStopDiff);
        } else if (mCacheQueueSizeWhenOpen < 10) {
            Telemetry::Accumulate(Telemetry::HTTP_NET_VS_CACHE_ONSTART_QMED_HIGHPRI, onStartDiff);
            Telemetry::Accumulate(Telemetry::HTTP_NET_VS_CACHE_ONSTOP_QMED_HIGHPRI, onStopDiff);
        } else {
            Telemetry::Accumulate(Telemetry::HTTP_NET_VS_CACHE_ONSTART_QBIG_HIGHPRI, onStartDiff);
            Telemetry::Accumulate(Telemetry::HTTP_NET_VS_CACHE_ONSTOP_QBIG_HIGHPRI, onStopDiff);
        }
    } else { // The limits are higher for normal priority cache queues
        if (mCacheQueueSizeWhenOpen < 10) {
            Telemetry::Accumulate(Telemetry::HTTP_NET_VS_CACHE_ONSTART_QSMALL_NORMALPRI, onStartDiff);
            Telemetry::Accumulate(Telemetry::HTTP_NET_VS_CACHE_ONSTOP_QSMALL_NORMALPRI, onStopDiff);
        } else if (mCacheQueueSizeWhenOpen < 50) {
            Telemetry::Accumulate(Telemetry::HTTP_NET_VS_CACHE_ONSTART_QMED_NORMALPRI, onStartDiff);
            Telemetry::Accumulate(Telemetry::HTTP_NET_VS_CACHE_ONSTOP_QMED_NORMALPRI, onStopDiff);
        } else {
            Telemetry::Accumulate(Telemetry::HTTP_NET_VS_CACHE_ONSTART_QBIG_NORMALPRI, onStartDiff);
            Telemetry::Accumulate(Telemetry::HTTP_NET_VS_CACHE_ONSTOP_QBIG_NORMALPRI, onStopDiff);
        }
    }

    if (diskStorageSizeK < 32) {
        if (mCacheOpenWithPriority) {
            Telemetry::Accumulate(Telemetry::HTTP_NET_VS_CACHE_ONSTART_SMALL_HIGHPRI, onStartDiff);
            Telemetry::Accumulate(Telemetry::HTTP_NET_VS_CACHE_ONSTOP_SMALL_HIGHPRI, onStopDiff);
        } else {
            Telemetry::Accumulate(Telemetry::HTTP_NET_VS_CACHE_ONSTART_SMALL_NORMALPRI, onStartDiff);
            Telemetry::Accumulate(Telemetry::HTTP_NET_VS_CACHE_ONSTOP_SMALL_NORMALPRI, onStopDiff);
        }
    } else if (diskStorageSizeK < 256) {
        if (mCacheOpenWithPriority) {
            Telemetry::Accumulate(Telemetry::HTTP_NET_VS_CACHE_ONSTART_MED_HIGHPRI, onStartDiff);
            Telemetry::Accumulate(Telemetry::HTTP_NET_VS_CACHE_ONSTOP_MED_HIGHPRI, onStopDiff);
        } else {
            Telemetry::Accumulate(Telemetry::HTTP_NET_VS_CACHE_ONSTART_MED_NORMALPRI, onStartDiff);
            Telemetry::Accumulate(Telemetry::HTTP_NET_VS_CACHE_ONSTOP_MED_NORMALPRI, onStopDiff);
        }
    } else {
        if (mCacheOpenWithPriority) {
            Telemetry::Accumulate(Telemetry::HTTP_NET_VS_CACHE_ONSTART_LARGE_HIGHPRI, onStartDiff);
            Telemetry::Accumulate(Telemetry::HTTP_NET_VS_CACHE_ONSTOP_LARGE_HIGHPRI, onStopDiff);
        } else {
            Telemetry::Accumulate(Telemetry::HTTP_NET_VS_CACHE_ONSTART_LARGE_NORMALPRI, onStartDiff);
            Telemetry::Accumulate(Telemetry::HTTP_NET_VS_CACHE_ONSTOP_LARGE_NORMALPRI, onStopDiff);
        }
    }
}

} // namespace net
} // namespace mozilla
