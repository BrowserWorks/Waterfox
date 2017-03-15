/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* vim:set ts=4 sw=4 sts=4 et cin: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

// HttpLog.h should generally be included first
#include "HttpLog.h"

#include "nsHttp.h"
#include "nsHttpHandler.h"
#include "nsHttpChannel.h"
#include "nsHttpAuthCache.h"
#include "nsStandardURL.h"
#include "nsIDOMWindow.h"
#include "nsIDOMNavigator.h"
#include "nsIMozNavigatorNetwork.h"
#include "nsINetworkProperties.h"
#include "nsIHttpChannel.h"
#include "nsIStandardURL.h"
#include "LoadContextInfo.h"
#include "nsCategoryManagerUtils.h"
#include "nsIPrefService.h"
#include "nsIPrefBranch.h"
#include "nsIPrefLocalizedString.h"
#include "nsISocketProviderService.h"
#include "nsISocketProvider.h"
#include "nsPrintfCString.h"
#include "nsCOMPtr.h"
#include "nsNetCID.h"
#include "prprf.h"
#include "mozilla/Sprintf.h"
#include "nsAsyncRedirectVerifyHelper.h"
#include "nsSocketTransportService2.h"
#include "nsAlgorithm.h"
#include "ASpdySession.h"
#include "mozIApplicationClearPrivateDataParams.h"
#include "EventTokenBucket.h"
#include "Tickler.h"
#include "nsIXULAppInfo.h"
#include "nsICookieService.h"
#include "nsIObserverService.h"
#include "nsISiteSecurityService.h"
#include "nsIStreamConverterService.h"
#include "nsITimer.h"
#include "nsCRT.h"
#include "nsIMemoryReporter.h"
#include "nsIParentalControlsService.h"
#include "nsPIDOMWindow.h"
#include "nsINetworkLinkService.h"
#include "nsHttpChannelAuthProvider.h"
#include "nsServiceManagerUtils.h"
#include "nsComponentManagerUtils.h"
#include "nsSocketTransportService2.h"
#include "nsIOService.h"
#include "nsIUUIDGenerator.h"

#include "mozilla/net/NeckoChild.h"
#include "mozilla/net/NeckoParent.h"
#include "mozilla/ipc/URIUtils.h"
#include "mozilla/Telemetry.h"
#include "mozilla/Unused.h"
#include "mozilla/BasePrincipal.h"

#include "mozilla/dom/ContentParent.h"

#if defined(XP_UNIX)
#include <sys/utsname.h>
#endif

#if defined(XP_WIN)
#include <windows.h>
#endif

#if defined(XP_MACOSX)
#include <CoreServices/CoreServices.h>
#include "nsCocoaFeatures.h"
#endif

//-----------------------------------------------------------------------------
#include "mozilla/net/HttpChannelChild.h"


#define UA_PREF_PREFIX          "general.useragent."
#ifdef XP_WIN
#define UA_SPARE_PLATFORM
#endif

#define HTTP_PREF_PREFIX        "network.http."
#define INTL_ACCEPT_LANGUAGES   "intl.accept_languages"
#define BROWSER_PREF_PREFIX     "browser.cache."
#define DONOTTRACK_HEADER_ENABLED "privacy.donottrackheader.enabled"
#define H2MANDATORY_SUITE        "security.ssl3.ecdhe_rsa_aes_128_gcm_sha256"
#define TELEMETRY_ENABLED        "toolkit.telemetry.enabled"
#define ALLOW_EXPERIMENTS        "network.allow-experiments"
#define SAFE_HINT_HEADER_VALUE   "safeHint.enabled"
#define SECURITY_PREFIX          "security."
#define NEW_TAB_REMOTE_MODE           "browser.newtabpage.remote.mode"

#define UA_PREF(_pref) UA_PREF_PREFIX _pref
#define HTTP_PREF(_pref) HTTP_PREF_PREFIX _pref
#define BROWSER_PREF(_pref) BROWSER_PREF_PREFIX _pref

#define NS_HTTP_PROTOCOL_FLAGS (URI_STD | ALLOWS_PROXY | ALLOWS_PROXY_HTTP | URI_LOADABLE_BY_ANYONE)

//-----------------------------------------------------------------------------

namespace mozilla {
namespace net {

LazyLogModule gHttpLog("nsHttp");

static nsresult
NewURI(const nsACString &aSpec,
       const char *aCharset,
       nsIURI *aBaseURI,
       int32_t aDefaultPort,
       nsIURI **aURI)
{
    RefPtr<nsStandardURL> url = new nsStandardURL();

    nsresult rv = url->Init(nsIStandardURL::URLTYPE_AUTHORITY,
                            aDefaultPort, aSpec, aCharset, aBaseURI);
    if (NS_FAILED(rv)) {
        return rv;
    }

    url.forget(aURI);
    return NS_OK;
}

#ifdef ANDROID
static nsCString
GetDeviceModelId() {
    // Assumed to be running on the main thread
    // We need the device property in either case
    nsAutoCString deviceModelId;
    nsCOMPtr<nsIPropertyBag2> infoService = do_GetService("@mozilla.org/system-info;1");
    MOZ_ASSERT(infoService, "Could not find a system info service");
    nsAutoString androidDevice;
    nsresult rv = infoService->GetPropertyAsAString(NS_LITERAL_STRING("device"), androidDevice);
    if (NS_SUCCEEDED(rv)) {
        deviceModelId = NS_LossyConvertUTF16toASCII(androidDevice);
    }
    nsAutoCString deviceString;
    rv = Preferences::GetCString(UA_PREF("device_string"), &deviceString);
    if (NS_SUCCEEDED(rv)) {
        deviceString.Trim(" ", true, true);
        deviceString.ReplaceSubstring(NS_LITERAL_CSTRING("%DEVICEID%"), deviceModelId);
        return deviceString;
    }
    return deviceModelId;
}
#endif

//-----------------------------------------------------------------------------
// nsHttpHandler <public>
//-----------------------------------------------------------------------------

nsHttpHandler *gHttpHandler = nullptr;

nsHttpHandler::nsHttpHandler()
    : mHttpVersion(NS_HTTP_VERSION_1_1)
    , mProxyHttpVersion(NS_HTTP_VERSION_1_1)
    , mCapabilities(NS_HTTP_ALLOW_KEEPALIVE)
    , mReferrerLevel(0xff) // by default we always send a referrer
    , mSpoofReferrerSource(false)
    , mReferrerTrimmingPolicy(0)
    , mReferrerXOriginTrimmingPolicy(0)
    , mReferrerXOriginPolicy(0)
    , mFastFallbackToIPv4(false)
    , mProxyPipelining(true)
    , mIdleTimeout(PR_SecondsToInterval(10))
    , mSpdyTimeout(PR_SecondsToInterval(180))
    , mResponseTimeout(PR_SecondsToInterval(300))
    , mResponseTimeoutEnabled(false)
    , mNetworkChangedTimeout(5000)
    , mMaxRequestAttempts(6)
    , mMaxRequestDelay(10)
    , mIdleSynTimeout(250)
    , mH2MandatorySuiteEnabled(false)
    , mPipeliningEnabled(false)
    , mMaxConnections(24)
    , mMaxPersistentConnectionsPerServer(2)
    , mMaxPersistentConnectionsPerProxy(4)
    , mMaxPipelinedRequests(32)
    , mMaxOptimisticPipelinedRequests(4)
    , mPipelineAggressive(false)
    , mMaxPipelineObjectSize(300000)
    , mPipelineRescheduleOnTimeout(true)
    , mPipelineRescheduleTimeout(PR_MillisecondsToInterval(1500))
    , mPipelineReadTimeout(PR_MillisecondsToInterval(30000))
    , mRedirectionLimit(10)
    , mPhishyUserPassLength(1)
    , mQoSBits(0x00)
    , mPipeliningOverSSL(false)
    , mEnforceAssocReq(false)
    , mLastUniqueID(NowInSeconds())
    , mSessionStartTime(0)
    , mLegacyAppName("Mozilla")
    , mLegacyAppVersion("5.0")
    , mProduct("Gecko")
    , mCompatFirefoxEnabled(false)
    , mUserAgentIsDirty(true)
    , mPromptTempRedirect(true)
    , mEnablePersistentHttpsCaching(false)
    , mDoNotTrackEnabled(false)
    , mSafeHintEnabled(false)
    , mParentalControlEnabled(false)
    , mHandlerActive(false)
    , mTelemetryEnabled(false)
    , mAllowExperiments(true)
    , mDebugObservations(false)
    , mEnableSpdy(false)
    , mHttp2Enabled(true)
    , mUseH2Deps(true)
    , mEnforceHttp2TlsProfile(true)
    , mCoalesceSpdy(true)
    , mSpdyPersistentSettings(false)
    , mAllowPush(true)
    , mEnableAltSvc(false)
    , mEnableAltSvcOE(false)
    , mSpdySendingChunkSize(ASpdySession::kSendingChunkSize)
    , mSpdySendBufferSize(ASpdySession::kTCPSendBufferSize)
    , mSpdyPushAllowance(32768)
    , mSpdyPullAllowance(ASpdySession::kInitialRwin)
    , mDefaultSpdyConcurrent(ASpdySession::kDefaultMaxConcurrent)
    , mSpdyPingThreshold(PR_SecondsToInterval(58))
    , mSpdyPingTimeout(PR_SecondsToInterval(8))
    , mConnectTimeout(90000)
    , mParallelSpeculativeConnectLimit(6)
    , mRequestTokenBucketEnabled(true)
    , mRequestTokenBucketMinParallelism(6)
    , mRequestTokenBucketHz(100)
    , mRequestTokenBucketBurst(32)
    , mCriticalRequestPrioritization(true)
    , mTCPKeepaliveShortLivedEnabled(false)
    , mTCPKeepaliveShortLivedTimeS(60)
    , mTCPKeepaliveShortLivedIdleTimeS(10)
    , mTCPKeepaliveLongLivedEnabled(false)
    , mTCPKeepaliveLongLivedIdleTimeS(600)
    , mEnforceH1Framing(FRAMECHECK_BARELY)
    , mKeepEmptyResponseHeadersAsEmtpyString(false)
    , mDefaultHpackBuffer(4096)
    , mMaxHttpResponseHeaderSize(393216)
{
    LOG(("Creating nsHttpHandler [this=%p].\n", this));

    MOZ_ASSERT(!gHttpHandler, "HTTP handler already created!");
    gHttpHandler = this;
}

nsHttpHandler::~nsHttpHandler()
{
    LOG(("Deleting nsHttpHandler [this=%p]\n", this));

    // make sure the connection manager is shutdown
    if (mConnMgr) {
        mConnMgr->Shutdown();
        mConnMgr = nullptr;
    }

    // Note: don't call NeckoChild::DestroyNeckoChild() here, as it's too late
    // and it'll segfault.  NeckoChild will get cleaned up by process exit.

    nsHttp::DestroyAtomTable();
    if (mPipelineTestTimer) {
        mPipelineTestTimer->Cancel();
        mPipelineTestTimer = nullptr;
    }

    gHttpHandler = nullptr;
}

nsresult
nsHttpHandler::Init()
{
    nsresult rv;

    LOG(("nsHttpHandler::Init\n"));
    MOZ_ASSERT(NS_IsMainThread());

    rv = nsHttp::CreateAtomTable();
    if (NS_FAILED(rv))
        return rv;

    nsCOMPtr<nsIIOService> service = do_GetService(NS_IOSERVICE_CONTRACTID, &rv);
    if (NS_FAILED(rv)) {
        NS_WARNING("unable to continue without io service");
        return rv;
    }
    mIOService = new nsMainThreadPtrHolder<nsIIOService>(service);

    if (IsNeckoChild())
        NeckoChild::InitNeckoChild();

    InitUserAgentComponents();

    // monitor some preference changes
    nsCOMPtr<nsIPrefBranch> prefBranch = do_GetService(NS_PREFSERVICE_CONTRACTID);
    if (prefBranch) {
        prefBranch->AddObserver(HTTP_PREF_PREFIX, this, true);
        prefBranch->AddObserver(UA_PREF_PREFIX, this, true);
        prefBranch->AddObserver(INTL_ACCEPT_LANGUAGES, this, true);
        prefBranch->AddObserver(BROWSER_PREF("disk_cache_ssl"), this, true);
        prefBranch->AddObserver(DONOTTRACK_HEADER_ENABLED, this, true);
        prefBranch->AddObserver(TELEMETRY_ENABLED, this, true);
        prefBranch->AddObserver(H2MANDATORY_SUITE, this, true);
        prefBranch->AddObserver(HTTP_PREF("tcp_keepalive.short_lived_connections"), this, true);
        prefBranch->AddObserver(HTTP_PREF("tcp_keepalive.long_lived_connections"), this, true);
        prefBranch->AddObserver(SAFE_HINT_HEADER_VALUE, this, true);
        prefBranch->AddObserver(SECURITY_PREFIX, this, true);
        prefBranch->AddObserver(NEW_TAB_REMOTE_MODE, this, true);
        PrefsChanged(prefBranch, nullptr);
    }

    nsHttpChannelAuthProvider::InitializePrefs();

    mMisc.AssignLiteral("rv:" MOZILLA_UAVERSION);

    mCompatFirefox.AssignLiteral("Waterfox/" MOZ_APP_UA_VERSION);

    nsCOMPtr<nsIXULAppInfo> appInfo =
        do_GetService("@mozilla.org/xre/app-info;1");

    mAppName.AssignLiteral(MOZ_APP_UA_NAME);
    if (mAppName.Length() == 0 && appInfo) {
        // Try to get the UA name from appInfo, falling back to the name
        appInfo->GetUAName(mAppName);
        if (mAppName.Length() == 0) {
          appInfo->GetName(mAppName);
        }
        appInfo->GetVersion(mAppVersion);
        mAppName.StripChars(R"( ()<>@,;:\"/[]?={})");
    } else {
        mAppVersion.AssignLiteral(MOZ_APP_UA_VERSION);
    }

    mSessionStartTime = NowInSeconds();
    mHandlerActive = true;

    rv = mAuthCache.Init();
    if (NS_FAILED(rv)) return rv;

    rv = mPrivateAuthCache.Init();
    if (NS_FAILED(rv)) return rv;

    rv = InitConnectionMgr();
    if (NS_FAILED(rv)) return rv;

    mRequestContextService =
        do_GetService("@mozilla.org/network/request-context-service;1");

#if defined(ANDROID) || defined(MOZ_MULET)
    mProductSub.AssignLiteral(MOZILLA_UAVERSION);
#else
    mProductSub.AssignLiteral("20100101");
#endif

#if DEBUG
    // dump user agent prefs
    LOG(("> legacy-app-name = %s\n", mLegacyAppName.get()));
    LOG(("> legacy-app-version = %s\n", mLegacyAppVersion.get()));
    LOG(("> platform = %s\n", mPlatform.get()));
    LOG(("> oscpu = %s\n", mOscpu.get()));
    LOG(("> misc = %s\n", mMisc.get()));
    LOG(("> product = %s\n", mProduct.get()));
    LOG(("> product-sub = %s\n", mProductSub.get()));
    LOG(("> app-name = %s\n", mAppName.get()));
    LOG(("> app-version = %s\n", mAppVersion.get()));
    LOG(("> compat-firefox = %s\n", mCompatFirefox.get()));
    LOG(("> user-agent = %s\n", UserAgent().get()));
#endif

    // Startup the http category
    // Bring alive the objects in the http-protocol-startup category
    NS_CreateServicesFromCategory(NS_HTTP_STARTUP_CATEGORY,
                                  static_cast<nsISupports*>(static_cast<void*>(this)),
                                  NS_HTTP_STARTUP_TOPIC);

    nsCOMPtr<nsIObserverService> obsService = services::GetObserverService();
    if (obsService) {
        // register the handler object as a weak callback as we don't need to worry
        // about shutdown ordering.
        obsService->AddObserver(this, "profile-change-net-teardown", true);
        obsService->AddObserver(this, "profile-change-net-restore", true);
        obsService->AddObserver(this, NS_XPCOM_SHUTDOWN_OBSERVER_ID, true);
        obsService->AddObserver(this, "net:clear-active-logins", true);
        obsService->AddObserver(this, "net:prune-dead-connections", true);
        // Sent by the TorButton add-on in the Tor Browser
        obsService->AddObserver(this, "net:prune-all-connections", true);
        obsService->AddObserver(this, "net:failed-to-process-uri-content", true);
        obsService->AddObserver(this, "last-pb-context-exited", true);
        obsService->AddObserver(this, "webapps-clear-data", true);
        obsService->AddObserver(this, "browser:purge-session-history", true);
        obsService->AddObserver(this, NS_NETWORK_LINK_TOPIC, true);
        obsService->AddObserver(this, "application-background", true);
    }

    MakeNewRequestTokenBucket();
    mWifiTickler = new Tickler();
    if (NS_FAILED(mWifiTickler->Init()))
        mWifiTickler = nullptr;

    nsCOMPtr<nsIParentalControlsService> pc = do_CreateInstance("@mozilla.org/parental-controls-service;1");
    if (pc) {
        pc->GetParentalControlsEnabled(&mParentalControlEnabled);
    }
    return NS_OK;
}

void
nsHttpHandler::MakeNewRequestTokenBucket()
{
    LOG(("nsHttpHandler::MakeNewRequestTokenBucket this=%p child=%d\n",
         this, IsNeckoChild()));
    if (!mConnMgr || IsNeckoChild()) {
        return;
    }
    RefPtr<EventTokenBucket> tokenBucket =
        new EventTokenBucket(RequestTokenBucketHz(), RequestTokenBucketBurst());
    mConnMgr->UpdateRequestTokenBucket(tokenBucket);
}

nsresult
nsHttpHandler::InitConnectionMgr()
{
    // Init ConnectionManager only on parent!
    if (IsNeckoChild()) {
        return NS_OK;
    }

    nsresult rv;

    if (!mConnMgr) {
        mConnMgr = new nsHttpConnectionMgr();
    }

    rv = mConnMgr->Init(mMaxConnections,
                        mMaxPersistentConnectionsPerServer,
                        mMaxPersistentConnectionsPerProxy,
                        mMaxRequestDelay,
                        mMaxPipelinedRequests,
                        mMaxOptimisticPipelinedRequests);
    return rv;
}

nsresult
nsHttpHandler::AddStandardRequestHeaders(nsHttpRequestHead *request, bool isSecure)
{
    nsresult rv;

    // Add the "User-Agent" header
    rv = request->SetHeader(nsHttp::User_Agent, UserAgent(),
                            false, nsHttpHeaderArray::eVarietyRequestDefault);
    if (NS_FAILED(rv)) return rv;

    // MIME based content negotiation lives!
    // Add the "Accept" header.  Note, this is set as an override because the
    // service worker expects to see it.  The other "default" headers are
    // hidden from service worker interception.
    rv = request->SetHeader(nsHttp::Accept, mAccept,
                            false, nsHttpHeaderArray::eVarietyRequestOverride);
    if (NS_FAILED(rv)) return rv;

    // Add the "Accept-Language" header.  This header is also exposed to the
    // service worker.
    if (!mAcceptLanguages.IsEmpty()) {
        // Add the "Accept-Language" header
        rv = request->SetHeader(nsHttp::Accept_Language, mAcceptLanguages,
                                false,
                                nsHttpHeaderArray::eVarietyRequestOverride);
        if (NS_FAILED(rv)) return rv;
    }

    // Add the "Accept-Encoding" header
    if (isSecure) {
        rv = request->SetHeader(nsHttp::Accept_Encoding, mHttpsAcceptEncodings,
                                false,
                                nsHttpHeaderArray::eVarietyRequestDefault);
    } else {
        rv = request->SetHeader(nsHttp::Accept_Encoding, mHttpAcceptEncodings,
                                false,
                                nsHttpHeaderArray::eVarietyRequestDefault);
    }
    if (NS_FAILED(rv)) return rv;

    // add the "Send Hint" header
    if (mSafeHintEnabled || mParentalControlEnabled) {
      rv = request->SetHeader(nsHttp::Prefer, NS_LITERAL_CSTRING("safe"),
                              false,
                              nsHttpHeaderArray::eVarietyRequestDefault);
      if (NS_FAILED(rv)) return rv;
    }
    return NS_OK;
}

nsresult
nsHttpHandler::AddConnectionHeader(nsHttpRequestHead *request,
                                   uint32_t caps)
{
    // RFC2616 section 19.6.2 states that the "Connection: keep-alive"
    // and "Keep-alive" request headers should not be sent by HTTP/1.1
    // user-agents.  But this is not a problem in practice, and the
    // alternative proxy-connection is worse. see 570283

    NS_NAMED_LITERAL_CSTRING(close, "close");
    NS_NAMED_LITERAL_CSTRING(keepAlive, "keep-alive");

    const nsACString *connectionType = &close;
    if (caps & NS_HTTP_ALLOW_KEEPALIVE) {
        connectionType = &keepAlive;
    }

    return request->SetHeader(nsHttp::Connection, *connectionType);
}

bool
nsHttpHandler::IsAcceptableEncoding(const char *enc, bool isSecure)
{
    if (!enc)
        return false;

    // we used to accept x-foo anytime foo was acceptable, but that's just
    // continuing bad behavior.. so limit it to known x-* patterns
    bool rv;
    if (isSecure) {
        rv = nsHttp::FindToken(mHttpsAcceptEncodings.get(), enc, HTTP_LWS ",") != nullptr;
    } else {
        rv = nsHttp::FindToken(mHttpAcceptEncodings.get(), enc, HTTP_LWS ",") != nullptr;
    }
    // gzip and deflate are inherently acceptable in modern HTTP - always
    // process them if a stream converter can also be found.
    if (!rv &&
        (!PL_strcasecmp(enc, "gzip") || !PL_strcasecmp(enc, "deflate") ||
         !PL_strcasecmp(enc, "x-gzip") || !PL_strcasecmp(enc, "x-deflate"))) {
        rv = true;
    }
    LOG(("nsHttpHandler::IsAceptableEncoding %s https=%d %d\n",
         enc, isSecure, rv));
    return rv;
}

nsresult
nsHttpHandler::GetStreamConverterService(nsIStreamConverterService **result)
{
    if (!mStreamConvSvc) {
        nsresult rv;
        nsCOMPtr<nsIStreamConverterService> service =
            do_GetService(NS_STREAMCONVERTERSERVICE_CONTRACTID, &rv);
        if (NS_FAILED(rv))
            return rv;
        mStreamConvSvc = new nsMainThreadPtrHolder<nsIStreamConverterService>(service);
    }
    *result = mStreamConvSvc;
    NS_ADDREF(*result);
    return NS_OK;
}

nsISiteSecurityService*
nsHttpHandler::GetSSService()
{
    if (!mSSService) {
        nsCOMPtr<nsISiteSecurityService> service = do_GetService(NS_SSSERVICE_CONTRACTID);
        mSSService = new nsMainThreadPtrHolder<nsISiteSecurityService>(service);
    }
    return mSSService;
}

nsICookieService *
nsHttpHandler::GetCookieService()
{
    if (!mCookieService) {
        nsCOMPtr<nsICookieService> service = do_GetService(NS_COOKIESERVICE_CONTRACTID);
        mCookieService = new nsMainThreadPtrHolder<nsICookieService>(service);
    }
    return mCookieService;
}

nsresult
nsHttpHandler::GetIOService(nsIIOService** result)
{
    NS_ENSURE_ARG_POINTER(result);

    NS_ADDREF(*result = mIOService);
    return NS_OK;
}

uint32_t
nsHttpHandler::Get32BitsOfPseudoRandom()
{
    // only confirm rand seeding on socket thread
    MOZ_ASSERT(PR_GetCurrentThread() == gSocketThread);

    // rand() provides different amounts of PRNG on different platforms.
    // 15 or 31 bits are common amounts.

    static_assert(RAND_MAX >= 0xfff, "RAND_MAX should be >= 12 bits");

#if RAND_MAX < 0xffffU
    return ((uint16_t) rand() << 20) |
            (((uint16_t) rand() & 0xfff) << 8) |
            ((uint16_t) rand() & 0xff);
#elif RAND_MAX < 0xffffffffU
    return ((uint16_t) rand() << 16) | ((uint16_t) rand() & 0xffff);
#else
    return (uint32_t) rand();
#endif
}

void
nsHttpHandler::NotifyObservers(nsIHttpChannel *chan, const char *event)
{
    LOG(("nsHttpHandler::NotifyObservers [chan=%x event=\"%s\"]\n", chan, event));
    nsCOMPtr<nsIObserverService> obsService = services::GetObserverService();
    if (obsService)
        obsService->NotifyObservers(chan, event, nullptr);
}

nsresult
nsHttpHandler::AsyncOnChannelRedirect(nsIChannel* oldChan, nsIChannel* newChan,
                                 uint32_t flags)
{
    // TODO E10S This helper has to be initialized on the other process
    RefPtr<nsAsyncRedirectVerifyHelper> redirectCallbackHelper =
        new nsAsyncRedirectVerifyHelper();

    return redirectCallbackHelper->Init(oldChan, newChan, flags);
}

/* static */ nsresult
nsHttpHandler::GenerateHostPort(const nsCString& host, int32_t port,
                                nsACString& hostLine)
{
    return NS_GenerateHostPort(host, port, hostLine);
}

//-----------------------------------------------------------------------------
// nsHttpHandler <private>
//-----------------------------------------------------------------------------

const nsAFlatCString &
nsHttpHandler::UserAgent()
{
    if (mUserAgentOverride) {
        LOG(("using general.useragent.override : %s\n", mUserAgentOverride.get()));
        return mUserAgentOverride;
    }

    if (mUserAgentIsDirty) {
        BuildUserAgent();
        mUserAgentIsDirty = false;
    }

    return mUserAgent;
}

void
nsHttpHandler::BuildUserAgent()
{
    LOG(("nsHttpHandler::BuildUserAgent\n"));

    MOZ_ASSERT(!mLegacyAppName.IsEmpty() &&
               !mLegacyAppVersion.IsEmpty(),
               "HTTP cannot send practical requests without this much");

    // preallocate to worst-case size, which should always be better
    // than if we didn't preallocate at all.
    mUserAgent.SetCapacity(mLegacyAppName.Length() +
                           mLegacyAppVersion.Length() +
#ifndef UA_SPARE_PLATFORM
                           mPlatform.Length() +
#endif
                           mOscpu.Length() +
                           mMisc.Length() +
                           mProduct.Length() +
                           mProductSub.Length() +
                           mAppName.Length() +
                           mAppVersion.Length() +
                           mCompatFirefox.Length() +
                           mCompatDevice.Length() +
                           mDeviceModelId.Length() +
                           13);

    // Application portion
    mUserAgent.Assign(mLegacyAppName);
    mUserAgent += '/';
    mUserAgent += mLegacyAppVersion;
    mUserAgent += ' ';

    // Application comment
    mUserAgent += '(';
#ifndef UA_SPARE_PLATFORM
    if (!mPlatform.IsEmpty()) {
      mUserAgent += mPlatform;
      mUserAgent.AppendLiteral("; ");
    }
#endif
    if (!mCompatDevice.IsEmpty()) {
        mUserAgent += mCompatDevice;
        mUserAgent.AppendLiteral("; ");
    }
    else if (!mOscpu.IsEmpty()) {
      mUserAgent += mOscpu;
      mUserAgent.AppendLiteral("; ");
    }
    if (!mDeviceModelId.IsEmpty()) {
        mUserAgent += mDeviceModelId;
        mUserAgent.AppendLiteral("; ");
    }
    mUserAgent += mMisc;
    mUserAgent += ')';

    // Product portion
    mUserAgent += ' ';
    mUserAgent += mProduct;
    mUserAgent += '/';
    mUserAgent += mProductSub;

    bool isFirefox = mAppName.EqualsLiteral("Firefox");
    if (isFirefox || mCompatFirefoxEnabled) {
        mUserAgent += ' ';
        mUserAgent += "Firefox";
        mUserAgent += '/';
        mUserAgent += mAppVersion;
        mUserAgent += ' ';
        mUserAgent += mCompatFirefox;
    }
}

#ifdef XP_WIN
#define WNT_BASE "Windows NT %ld.%ld"
#define W64_PREFIX "; Win64"
#endif

void
nsHttpHandler::InitUserAgentComponents()
{
#ifndef MOZ_UA_OS_AGNOSTIC
    // Gather platform.
    mPlatform.AssignLiteral(
#if defined(ANDROID)
    "Android"
#elif defined(XP_WIN)
    "Windows"
#elif defined(XP_MACOSX)
    "Macintosh"
#elif defined(XP_UNIX)
    // We historically have always had X11 here,
    // and there seems little a webpage can sensibly do
    // based on it being something else, so use X11 for
    // backwards compatibility in all cases.
    "X11"
#endif
    );
#endif


#ifdef ANDROID
    nsCOMPtr<nsIPropertyBag2> infoService = do_GetService("@mozilla.org/system-info;1");
    MOZ_ASSERT(infoService, "Could not find a system info service");
    nsresult rv;
    // Add the Android version number to the Fennec platform identifier.
#if defined MOZ_WIDGET_ANDROID
#ifndef MOZ_UA_OS_AGNOSTIC // Don't add anything to mPlatform since it's empty.
    nsAutoString androidVersion;
    rv = infoService->GetPropertyAsAString(
        NS_LITERAL_STRING("release_version"), androidVersion);
    if (NS_SUCCEEDED(rv)) {
      mPlatform += " ";
      // If the 2nd character is a ".", we know the major version is a single
      // digit. If we're running on a version below 4 we pretend to be on
      // Android KitKat (4.4) to work around scripts sniffing for low versions.
      if (androidVersion[1] == 46 && androidVersion[0] < 52) {
        mPlatform += "4.4";
      } else {
        mPlatform += NS_LossyConvertUTF16toASCII(androidVersion);
      }
    }
#endif
#endif
    // Add the `Mobile` or `Tablet` or `TV` token when running on device.
    bool isTablet;
    rv = infoService->GetPropertyAsBool(NS_LITERAL_STRING("tablet"), &isTablet);
    if (NS_SUCCEEDED(rv) && isTablet) {
        mCompatDevice.AssignLiteral("Tablet");
    } else {
        bool isTV;
        rv = infoService->GetPropertyAsBool(NS_LITERAL_STRING("tv"), &isTV);
        if (NS_SUCCEEDED(rv) && isTV) {
            mCompatDevice.AssignLiteral("TV");
        } else {
            mCompatDevice.AssignLiteral("Mobile");
        }
    }

    if (Preferences::GetBool(UA_PREF("use_device"), false)) {
        mDeviceModelId = mozilla::net::GetDeviceModelId();
    }
#endif // ANDROID

#ifdef MOZ_MULET
    {
        // Add the `Mobile` or `Tablet` or `TV` token when running in the b2g
        // desktop simulator via preference.
        nsCString deviceType;
        nsresult rv = Preferences::GetCString("devtools.useragent.device_type", &deviceType);
        if (NS_SUCCEEDED(rv)) {
            mCompatDevice.Assign(deviceType);
        } else {
            mCompatDevice.AssignLiteral("Mobile");
        }
    }
#endif // MOZ_MULET

#if defined(MOZ_WIDGET_GONK)
    // Device model identifier should be a simple token, which can be composed
    // of letters, numbers, hyphen ("-") and dot (".").
    // Any other characters means the identifier is invalid and ignored.
    nsCString deviceId;
    rv = Preferences::GetCString("general.useragent.device_id", &deviceId);
    if (NS_SUCCEEDED(rv)) {
        bool valid = true;
        deviceId.Trim(" ", true, true);
        for (size_t i = 0; i < deviceId.Length(); i++) {
            char c = deviceId.CharAt(i);
            if (!(isalnum(c) || c == '-' || c == '.')) {
                valid = false;
                break;
            }
        }
        if (valid) {
            mDeviceModelId = deviceId;
        } else {
            LOG(("nsHttpHandler: Ignore invalid device ID: [%s]\n",
                  deviceId.get()));
        }
    }
#endif

#ifndef MOZ_UA_OS_AGNOSTIC
    // Gather OS/CPU.
#if defined(XP_WIN)
    OSVERSIONINFO info = { sizeof(OSVERSIONINFO) };
#pragma warning(push)
#pragma warning(disable:4996)
    if (GetVersionEx(&info)) {
#pragma warning(pop)
        const char *format;
#if defined _M_IA64
        format = WNT_BASE W64_PREFIX "; IA64";
#elif defined _M_X64 || defined _M_AMD64
        format = WNT_BASE W64_PREFIX "; x64";
#else
        BOOL isWow64 = FALSE;
        if (!IsWow64Process(GetCurrentProcess(), &isWow64)) {
            isWow64 = FALSE;
        }
        format = isWow64
          ? WNT_BASE "; WOW64"
          : WNT_BASE;
#endif
        char *buf = PR_smprintf(format,
                                info.dwMajorVersion,
                                info.dwMinorVersion);
        if (buf) {
            mOscpu = buf;
            PR_smprintf_free(buf);
        }
    }
#elif defined (XP_MACOSX)
#if defined(__ppc__)
    mOscpu.AssignLiteral("PPC Mac OS X");
#elif defined(__i386__) || defined(__x86_64__)
    mOscpu.AssignLiteral("Intel Mac OS X");
#endif
    SInt32 majorVersion = nsCocoaFeatures::OSXVersionMajor();
    SInt32 minorVersion = nsCocoaFeatures::OSXVersionMinor();
    mOscpu += nsPrintfCString(" %d.%d", majorVersion, minorVersion);
#elif defined (XP_UNIX)
    struct utsname name;

    int ret = uname(&name);
    if (ret >= 0) {
        nsAutoCString buf;
        buf =  (char*)name.sysname;

        if (strcmp(name.machine, "x86_64") == 0 &&
            sizeof(void *) == sizeof(int32_t)) {
            // We're running 32-bit code on x86_64. Make this browser
            // look like it's running on i686 hardware, but append "
            // (x86_64)" to the end of the oscpu identifier to be able
            // to differentiate this from someone running 64-bit code
            // on x86_64..

            buf += " i686 on x86_64";
        } else {
            buf += ' ';

#ifdef AIX
            // AIX uname returns machine specific info in the uname.machine
            // field and does not return the cpu type like other platforms.
            // We use the AIX version and release numbers instead.
            buf += (char*)name.version;
            buf += '.';
            buf += (char*)name.release;
#else
            buf += (char*)name.machine;
#endif
        }

        mOscpu.Assign(buf);
    }
#endif
#endif

    mUserAgentIsDirty = true;
}

uint32_t
nsHttpHandler::MaxSocketCount()
{
    PR_CallOnce(&nsSocketTransportService::gMaxCountInitOnce,
                nsSocketTransportService::DiscoverMaxCount);
    // Don't use the full max count because sockets can be held in
    // the persistent connection pool for a long time and that could
    // starve other users.

    uint32_t maxCount = nsSocketTransportService::gMaxCount;
    if (maxCount <= 8)
        maxCount = 1;
    else
        maxCount -= 8;

    return maxCount;
}

void
nsHttpHandler::PrefsChanged(nsIPrefBranch *prefs, const char *pref)
{
    nsresult rv = NS_OK;
    int32_t val;

    LOG(("nsHttpHandler::PrefsChanged [pref=%s]\n", pref));

#define PREF_CHANGED(p) ((pref == nullptr) || !PL_strcmp(pref, p))
#define MULTI_PREF_CHANGED(p) \
  ((pref == nullptr) || !PL_strncmp(pref, p, sizeof(p) - 1))

    // If a security pref changed, lets clear our connection pool reuse
    if (MULTI_PREF_CHANGED(SECURITY_PREFIX)) {
        LOG(("nsHttpHandler::PrefsChanged Security Pref Changed %s\n", pref));
        if (mConnMgr) {
            mConnMgr->DoShiftReloadConnectionCleanup(nullptr);
            mConnMgr->PruneDeadConnections();
        }
    }

    //
    // UA components
    //

    bool cVar = false;

    if (PREF_CHANGED(UA_PREF("compatMode.firefox"))) {
        rv = prefs->GetBoolPref(UA_PREF("compatMode.firefox"), &cVar);
        mCompatFirefoxEnabled = (NS_SUCCEEDED(rv) && cVar);
        mUserAgentIsDirty = true;
    }

    // general.useragent.override
    if (PREF_CHANGED(UA_PREF("override"))) {
        prefs->GetCharPref(UA_PREF("override"),
                            getter_Copies(mUserAgentOverride));
        mUserAgentIsDirty = true;
    }

#ifdef ANDROID
    // general.useragent.use_device
    if (PREF_CHANGED(UA_PREF("use_device"))) {
        if (Preferences::GetBool(UA_PREF("use_device"), false)) {
            mDeviceModelId = mozilla::net::GetDeviceModelId();
        } else {
            mDeviceModelId = EmptyCString();
        }
        mUserAgentIsDirty = true;
    }
#endif

    //
    // HTTP options
    //

    if (PREF_CHANGED(HTTP_PREF("keep-alive.timeout"))) {
        rv = prefs->GetIntPref(HTTP_PREF("keep-alive.timeout"), &val);
        if (NS_SUCCEEDED(rv))
            mIdleTimeout = PR_SecondsToInterval(clamped(val, 1, 0xffff));
    }

    if (PREF_CHANGED(HTTP_PREF("request.max-attempts"))) {
        rv = prefs->GetIntPref(HTTP_PREF("request.max-attempts"), &val);
        if (NS_SUCCEEDED(rv))
            mMaxRequestAttempts = (uint16_t) clamped(val, 1, 0xffff);
    }

    if (PREF_CHANGED(HTTP_PREF("request.max-start-delay"))) {
        rv = prefs->GetIntPref(HTTP_PREF("request.max-start-delay"), &val);
        if (NS_SUCCEEDED(rv)) {
            mMaxRequestDelay = (uint16_t) clamped(val, 0, 0xffff);
            if (mConnMgr)
                mConnMgr->UpdateParam(nsHttpConnectionMgr::MAX_REQUEST_DELAY,
                                      mMaxRequestDelay);
        }
    }

    if (PREF_CHANGED(HTTP_PREF("response.timeout"))) {
        rv = prefs->GetIntPref(HTTP_PREF("response.timeout"), &val);
        if (NS_SUCCEEDED(rv))
            mResponseTimeout = PR_SecondsToInterval(clamped(val, 0, 0xffff));
    }

    if (PREF_CHANGED(HTTP_PREF("network-changed.timeout"))) {
        rv = prefs->GetIntPref(HTTP_PREF("network-changed.timeout"), &val);
        if (NS_SUCCEEDED(rv))
            mNetworkChangedTimeout = clamped(val, 1, 600) * 1000;
    }

    if (PREF_CHANGED(HTTP_PREF("max-connections"))) {
        rv = prefs->GetIntPref(HTTP_PREF("max-connections"), &val);
        if (NS_SUCCEEDED(rv)) {

            mMaxConnections = (uint16_t) clamped((uint32_t)val,
                                                 (uint32_t)1, MaxSocketCount());

            if (mConnMgr)
                mConnMgr->UpdateParam(nsHttpConnectionMgr::MAX_CONNECTIONS,
                                      mMaxConnections);
        }
    }

    if (PREF_CHANGED(HTTP_PREF("max-persistent-connections-per-server"))) {
        rv = prefs->GetIntPref(HTTP_PREF("max-persistent-connections-per-server"), &val);
        if (NS_SUCCEEDED(rv)) {
            mMaxPersistentConnectionsPerServer = (uint8_t) clamped(val, 1, 0xff);
            if (mConnMgr)
                mConnMgr->UpdateParam(nsHttpConnectionMgr::MAX_PERSISTENT_CONNECTIONS_PER_HOST,
                                      mMaxPersistentConnectionsPerServer);
        }
    }

    if (PREF_CHANGED(HTTP_PREF("max-persistent-connections-per-proxy"))) {
        rv = prefs->GetIntPref(HTTP_PREF("max-persistent-connections-per-proxy"), &val);
        if (NS_SUCCEEDED(rv)) {
            mMaxPersistentConnectionsPerProxy = (uint8_t) clamped(val, 1, 0xff);
            if (mConnMgr)
                mConnMgr->UpdateParam(nsHttpConnectionMgr::MAX_PERSISTENT_CONNECTIONS_PER_PROXY,
                                      mMaxPersistentConnectionsPerProxy);
        }
    }

    if (PREF_CHANGED(HTTP_PREF("sendRefererHeader"))) {
        rv = prefs->GetIntPref(HTTP_PREF("sendRefererHeader"), &val);
        if (NS_SUCCEEDED(rv))
            mReferrerLevel = (uint8_t) clamped(val, 0, 0xff);
    }

    if (PREF_CHANGED(HTTP_PREF("referer.spoofSource"))) {
        rv = prefs->GetBoolPref(HTTP_PREF("referer.spoofSource"), &cVar);
        if (NS_SUCCEEDED(rv))
            mSpoofReferrerSource = cVar;
    }

    if (PREF_CHANGED(HTTP_PREF("referer.trimmingPolicy"))) {
        rv = prefs->GetIntPref(HTTP_PREF("referer.trimmingPolicy"), &val);
        if (NS_SUCCEEDED(rv))
            mReferrerTrimmingPolicy = (uint8_t) clamped(val, 0, 2);
    }

    if (PREF_CHANGED(HTTP_PREF("referer.XOriginTrimmingPolicy"))) {
        rv = prefs->GetIntPref(HTTP_PREF("referer.XOriginTrimmingPolicy"), &val);
        if (NS_SUCCEEDED(rv))
            mReferrerXOriginTrimmingPolicy = (uint8_t) clamped(val, 0, 2);
    }

    if (PREF_CHANGED(HTTP_PREF("referer.XOriginPolicy"))) {
        rv = prefs->GetIntPref(HTTP_PREF("referer.XOriginPolicy"), &val);
        if (NS_SUCCEEDED(rv))
            mReferrerXOriginPolicy = (uint8_t) clamped(val, 0, 0xff);
    }

    if (PREF_CHANGED(HTTP_PREF("redirection-limit"))) {
        rv = prefs->GetIntPref(HTTP_PREF("redirection-limit"), &val);
        if (NS_SUCCEEDED(rv))
            mRedirectionLimit = (uint8_t) clamped(val, 0, 0xff);
    }

    if (PREF_CHANGED(HTTP_PREF("connection-retry-timeout"))) {
        rv = prefs->GetIntPref(HTTP_PREF("connection-retry-timeout"), &val);
        if (NS_SUCCEEDED(rv))
            mIdleSynTimeout = (uint16_t) clamped(val, 0, 3000);
    }

    if (PREF_CHANGED(HTTP_PREF("fast-fallback-to-IPv4"))) {
        rv = prefs->GetBoolPref(HTTP_PREF("fast-fallback-to-IPv4"), &cVar);
        if (NS_SUCCEEDED(rv))
            mFastFallbackToIPv4 = cVar;
    }

    if (PREF_CHANGED(HTTP_PREF("version"))) {
        nsXPIDLCString httpVersion;
        prefs->GetCharPref(HTTP_PREF("version"), getter_Copies(httpVersion));
        if (httpVersion) {
            if (!PL_strcmp(httpVersion, "1.1"))
                mHttpVersion = NS_HTTP_VERSION_1_1;
            else if (!PL_strcmp(httpVersion, "0.9"))
                mHttpVersion = NS_HTTP_VERSION_0_9;
            else
                mHttpVersion = NS_HTTP_VERSION_1_0;
        }
    }

    if (PREF_CHANGED(HTTP_PREF("proxy.version"))) {
        nsXPIDLCString httpVersion;
        prefs->GetCharPref(HTTP_PREF("proxy.version"), getter_Copies(httpVersion));
        if (httpVersion) {
            if (!PL_strcmp(httpVersion, "1.1"))
                mProxyHttpVersion = NS_HTTP_VERSION_1_1;
            else
                mProxyHttpVersion = NS_HTTP_VERSION_1_0;
            // it does not make sense to issue a HTTP/0.9 request to a proxy server
        }
    }

    if (PREF_CHANGED(HTTP_PREF("pipelining"))) {
        rv = prefs->GetBoolPref(HTTP_PREF("pipelining"), &cVar);
        if (NS_SUCCEEDED(rv)) {
            if (cVar)
                mCapabilities |=  NS_HTTP_ALLOW_PIPELINING;
            else
                mCapabilities &= ~NS_HTTP_ALLOW_PIPELINING;
            mPipeliningEnabled = cVar;
        }
    }

    if (PREF_CHANGED(HTTP_PREF("pipelining.maxrequests"))) {
        rv = prefs->GetIntPref(HTTP_PREF("pipelining.maxrequests"), &val);
        if (NS_SUCCEEDED(rv)) {
            mMaxPipelinedRequests = clamped(val, 1, 0xffff);
            if (mConnMgr)
                mConnMgr->UpdateParam(nsHttpConnectionMgr::MAX_PIPELINED_REQUESTS,
                                      mMaxPipelinedRequests);
        }
    }

    if (PREF_CHANGED(HTTP_PREF("pipelining.max-optimistic-requests"))) {
        rv = prefs->
            GetIntPref(HTTP_PREF("pipelining.max-optimistic-requests"), &val);
        if (NS_SUCCEEDED(rv)) {
            mMaxOptimisticPipelinedRequests = clamped(val, 1, 0xffff);
            if (mConnMgr)
                mConnMgr->UpdateParam
                    (nsHttpConnectionMgr::MAX_OPTIMISTIC_PIPELINED_REQUESTS,
                     mMaxOptimisticPipelinedRequests);
        }
    }

    if (PREF_CHANGED(HTTP_PREF("pipelining.aggressive"))) {
        rv = prefs->GetBoolPref(HTTP_PREF("pipelining.aggressive"), &cVar);
        if (NS_SUCCEEDED(rv))
            mPipelineAggressive = cVar;
    }

    if (PREF_CHANGED(HTTP_PREF("pipelining.maxsize"))) {
        rv = prefs->GetIntPref(HTTP_PREF("pipelining.maxsize"), &val);
        if (NS_SUCCEEDED(rv)) {
            mMaxPipelineObjectSize =
                static_cast<int64_t>(clamped(val, 1000, 100000000));
        }
    }

    // Determines whether or not to actually reschedule after the
    // reschedule-timeout has expired
    if (PREF_CHANGED(HTTP_PREF("pipelining.reschedule-on-timeout"))) {
        rv = prefs->GetBoolPref(HTTP_PREF("pipelining.reschedule-on-timeout"),
                                &cVar);
        if (NS_SUCCEEDED(rv))
            mPipelineRescheduleOnTimeout = cVar;
    }

    // The amount of time head of line blocking is allowed (in ms)
    // before the blocked transactions are moved to another pipeline
    if (PREF_CHANGED(HTTP_PREF("pipelining.reschedule-timeout"))) {
        rv = prefs->GetIntPref(HTTP_PREF("pipelining.reschedule-timeout"),
                               &val);
        if (NS_SUCCEEDED(rv)) {
            mPipelineRescheduleTimeout =
                PR_MillisecondsToInterval((uint16_t) clamped(val, 500, 0xffff));
        }
    }

    // The amount of time a pipelined transaction is allowed to wait before
    // being canceled and retried in a non-pipeline connection
    if (PREF_CHANGED(HTTP_PREF("pipelining.read-timeout"))) {
        rv = prefs->GetIntPref(HTTP_PREF("pipelining.read-timeout"), &val);
        if (NS_SUCCEEDED(rv)) {
            mPipelineReadTimeout =
                PR_MillisecondsToInterval((uint16_t) clamped(val, 5000,
                                                             0xffff));
        }
    }

    if (PREF_CHANGED(HTTP_PREF("pipelining.ssl"))) {
        rv = prefs->GetBoolPref(HTTP_PREF("pipelining.ssl"), &cVar);
        if (NS_SUCCEEDED(rv))
            mPipeliningOverSSL = cVar;
    }

    if (PREF_CHANGED(HTTP_PREF("proxy.pipelining"))) {
        rv = prefs->GetBoolPref(HTTP_PREF("proxy.pipelining"), &cVar);
        if (NS_SUCCEEDED(rv))
            mProxyPipelining = cVar;
    }

    if (PREF_CHANGED(HTTP_PREF("qos"))) {
        rv = prefs->GetIntPref(HTTP_PREF("qos"), &val);
        if (NS_SUCCEEDED(rv))
            mQoSBits = (uint8_t) clamped(val, 0, 0xff);
    }

    if (PREF_CHANGED(HTTP_PREF("accept.default"))) {
        nsXPIDLCString accept;
        rv = prefs->GetCharPref(HTTP_PREF("accept.default"),
                                  getter_Copies(accept));
        if (NS_SUCCEEDED(rv))
            SetAccept(accept);
    }

    if (PREF_CHANGED(HTTP_PREF("accept-encoding"))) {
        nsXPIDLCString acceptEncodings;
        rv = prefs->GetCharPref(HTTP_PREF("accept-encoding"),
                                  getter_Copies(acceptEncodings));
        if (NS_SUCCEEDED(rv)) {
            SetAcceptEncodings(acceptEncodings, false);
        }
    }

    if (PREF_CHANGED(HTTP_PREF("accept-encoding.secure"))) {
        nsXPIDLCString acceptEncodings;
        rv = prefs->GetCharPref(HTTP_PREF("accept-encoding.secure"),
                                  getter_Copies(acceptEncodings));
        if (NS_SUCCEEDED(rv)) {
            SetAcceptEncodings(acceptEncodings, true);
        }
    }

    if (PREF_CHANGED(HTTP_PREF("default-socket-type"))) {
        nsXPIDLCString sval;
        rv = prefs->GetCharPref(HTTP_PREF("default-socket-type"),
                                getter_Copies(sval));
        if (NS_SUCCEEDED(rv)) {
            if (sval.IsEmpty())
                mDefaultSocketType.Adopt(0);
            else {
                // verify that this socket type is actually valid
                nsCOMPtr<nsISocketProviderService> sps(
                        do_GetService(NS_SOCKETPROVIDERSERVICE_CONTRACTID));
                if (sps) {
                    nsCOMPtr<nsISocketProvider> sp;
                    rv = sps->GetSocketProvider(sval, getter_AddRefs(sp));
                    if (NS_SUCCEEDED(rv)) {
                        // OK, this looks like a valid socket provider.
                        mDefaultSocketType.Assign(sval);
                    }
                }
            }
        }
    }

    if (PREF_CHANGED(HTTP_PREF("prompt-temp-redirect"))) {
        rv = prefs->GetBoolPref(HTTP_PREF("prompt-temp-redirect"), &cVar);
        if (NS_SUCCEEDED(rv)) {
            mPromptTempRedirect = cVar;
        }
    }

    if (PREF_CHANGED(HTTP_PREF("assoc-req.enforce"))) {
        cVar = false;
        rv = prefs->GetBoolPref(HTTP_PREF("assoc-req.enforce"), &cVar);
        if (NS_SUCCEEDED(rv))
            mEnforceAssocReq = cVar;
    }

    // enable Persistent caching for HTTPS - bug#205921
    if (PREF_CHANGED(BROWSER_PREF("disk_cache_ssl"))) {
        cVar = false;
        rv = prefs->GetBoolPref(BROWSER_PREF("disk_cache_ssl"), &cVar);
        if (NS_SUCCEEDED(rv))
            mEnablePersistentHttpsCaching = cVar;
    }

    if (PREF_CHANGED(HTTP_PREF("phishy-userpass-length"))) {
        rv = prefs->GetIntPref(HTTP_PREF("phishy-userpass-length"), &val);
        if (NS_SUCCEEDED(rv))
            mPhishyUserPassLength = (uint8_t) clamped(val, 0, 0xff);
    }

    if (PREF_CHANGED(HTTP_PREF("spdy.enabled"))) {
        rv = prefs->GetBoolPref(HTTP_PREF("spdy.enabled"), &cVar);
        if (NS_SUCCEEDED(rv))
            mEnableSpdy = cVar;
    }

    if (PREF_CHANGED(HTTP_PREF("spdy.enabled.http2"))) {
        rv = prefs->GetBoolPref(HTTP_PREF("spdy.enabled.http2"), &cVar);
        if (NS_SUCCEEDED(rv))
            mHttp2Enabled = cVar;
    }

    if (PREF_CHANGED(HTTP_PREF("spdy.enabled.deps"))) {
        rv = prefs->GetBoolPref(HTTP_PREF("spdy.enabled.deps"), &cVar);
        if (NS_SUCCEEDED(rv))
            mUseH2Deps = cVar;
    }

    if (PREF_CHANGED(HTTP_PREF("spdy.enforce-tls-profile"))) {
        rv = prefs->GetBoolPref(HTTP_PREF("spdy.enforce-tls-profile"), &cVar);
        if (NS_SUCCEEDED(rv))
            mEnforceHttp2TlsProfile = cVar;
    }

    if (PREF_CHANGED(HTTP_PREF("spdy.coalesce-hostnames"))) {
        rv = prefs->GetBoolPref(HTTP_PREF("spdy.coalesce-hostnames"), &cVar);
        if (NS_SUCCEEDED(rv))
            mCoalesceSpdy = cVar;
    }

    if (PREF_CHANGED(HTTP_PREF("spdy.persistent-settings"))) {
        rv = prefs->GetBoolPref(HTTP_PREF("spdy.persistent-settings"),
                                &cVar);
        if (NS_SUCCEEDED(rv))
            mSpdyPersistentSettings = cVar;
    }

    if (PREF_CHANGED(HTTP_PREF("spdy.timeout"))) {
        rv = prefs->GetIntPref(HTTP_PREF("spdy.timeout"), &val);
        if (NS_SUCCEEDED(rv))
            mSpdyTimeout = PR_SecondsToInterval(clamped(val, 1, 0xffff));
    }

    if (PREF_CHANGED(HTTP_PREF("spdy.chunk-size"))) {
        // keep this within http/2 ranges of 1 to 2^14-1
        rv = prefs->GetIntPref(HTTP_PREF("spdy.chunk-size"), &val);
        if (NS_SUCCEEDED(rv))
            mSpdySendingChunkSize = (uint32_t) clamped(val, 1, 0x3fff);
    }

    // The amount of idle seconds on a spdy connection before initiating a
    // server ping. 0 will disable.
    if (PREF_CHANGED(HTTP_PREF("spdy.ping-threshold"))) {
        rv = prefs->GetIntPref(HTTP_PREF("spdy.ping-threshold"), &val);
        if (NS_SUCCEEDED(rv))
            mSpdyPingThreshold =
                PR_SecondsToInterval((uint16_t) clamped(val, 0, 0x7fffffff));
    }

    // The amount of seconds to wait for a spdy ping response before
    // closing the session.
    if (PREF_CHANGED(HTTP_PREF("spdy.ping-timeout"))) {
        rv = prefs->GetIntPref(HTTP_PREF("spdy.ping-timeout"), &val);
        if (NS_SUCCEEDED(rv))
            mSpdyPingTimeout =
                PR_SecondsToInterval((uint16_t) clamped(val, 0, 0x7fffffff));
    }

    if (PREF_CHANGED(HTTP_PREF("spdy.allow-push"))) {
        rv = prefs->GetBoolPref(HTTP_PREF("spdy.allow-push"),
                                &cVar);
        if (NS_SUCCEEDED(rv))
            mAllowPush = cVar;
    }

    if (PREF_CHANGED(HTTP_PREF("altsvc.enabled"))) {
        rv = prefs->GetBoolPref(HTTP_PREF("altsvc.enabled"),
                                &cVar);
        if (NS_SUCCEEDED(rv))
            mEnableAltSvc = cVar;
    }


    if (PREF_CHANGED(HTTP_PREF("altsvc.oe"))) {
        rv = prefs->GetBoolPref(HTTP_PREF("altsvc.oe"),
                                &cVar);
        if (NS_SUCCEEDED(rv))
            mEnableAltSvcOE = cVar;
    }

    if (PREF_CHANGED(HTTP_PREF("spdy.push-allowance"))) {
        rv = prefs->GetIntPref(HTTP_PREF("spdy.push-allowance"), &val);
        if (NS_SUCCEEDED(rv)) {
            mSpdyPushAllowance =
                static_cast<uint32_t>
                (clamped(val, 1024, static_cast<int32_t>(ASpdySession::kInitialRwin)));
        }
    }

    if (PREF_CHANGED(HTTP_PREF("spdy.pull-allowance"))) {
        rv = prefs->GetIntPref(HTTP_PREF("spdy.pull-allowance"), &val);
        if (NS_SUCCEEDED(rv)) {
            mSpdyPullAllowance =
                static_cast<uint32_t>(clamped(val, 1024, 0x7fffffff));
        }
    }

    if (PREF_CHANGED(HTTP_PREF("spdy.default-concurrent"))) {
        rv = prefs->GetIntPref(HTTP_PREF("spdy.default-concurrent"), &val);
        if (NS_SUCCEEDED(rv)) {
            mDefaultSpdyConcurrent =
                static_cast<uint32_t>(std::max<int32_t>(std::min<int32_t>(val, 9999), 1));
        }
    }

    // The amount of seconds to wait for a spdy ping response before
    // closing the session.
    if (PREF_CHANGED(HTTP_PREF("spdy.send-buffer-size"))) {
        rv = prefs->GetIntPref(HTTP_PREF("spdy.send-buffer-size"), &val);
        if (NS_SUCCEEDED(rv))
            mSpdySendBufferSize = (uint32_t) clamped(val, 1500, 0x7fffffff);
    }

    // The maximum amount of time to wait for socket transport to be
    // established
    if (PREF_CHANGED(HTTP_PREF("connection-timeout"))) {
        rv = prefs->GetIntPref(HTTP_PREF("connection-timeout"), &val);
        if (NS_SUCCEEDED(rv))
            // the pref is in seconds, but the variable is in milliseconds
            mConnectTimeout = clamped(val, 1, 0xffff) * PR_MSEC_PER_SEC;
    }

    // The maximum number of current global half open sockets allowable
    // for starting a new speculative connection.
    if (PREF_CHANGED(HTTP_PREF("speculative-parallel-limit"))) {
        rv = prefs->GetIntPref(HTTP_PREF("speculative-parallel-limit"), &val);
        if (NS_SUCCEEDED(rv))
            mParallelSpeculativeConnectLimit = (uint32_t) clamped(val, 0, 1024);
    }

    // Whether or not to block requests for non head js/css items (e.g. media)
    // while those elements load.
    if (PREF_CHANGED(HTTP_PREF("rendering-critical-requests-prioritization"))) {
        rv = prefs->GetBoolPref(HTTP_PREF("rendering-critical-requests-prioritization"), &cVar);
        if (NS_SUCCEEDED(rv))
            mCriticalRequestPrioritization = cVar;
    }

    // on transition of network.http.diagnostics to true print
    // a bunch of information to the console
    if (pref && PREF_CHANGED(HTTP_PREF("diagnostics"))) {
        rv = prefs->GetBoolPref(HTTP_PREF("diagnostics"), &cVar);
        if (NS_SUCCEEDED(rv) && cVar) {
            if (mConnMgr)
                mConnMgr->PrintDiagnostics();
        }
    }

    if (PREF_CHANGED(HTTP_PREF("max_response_header_size"))) {
        rv = prefs->GetIntPref(HTTP_PREF("max_response_header_size"), &val);
        if (NS_SUCCEEDED(rv)) {
            mMaxHttpResponseHeaderSize = val;
        }
    }
    //
    // INTL options
    //

    if (PREF_CHANGED(INTL_ACCEPT_LANGUAGES)) {
        nsCOMPtr<nsIPrefLocalizedString> pls;
        prefs->GetComplexValue(INTL_ACCEPT_LANGUAGES,
                                NS_GET_IID(nsIPrefLocalizedString),
                                getter_AddRefs(pls));
        if (pls) {
            nsXPIDLString uval;
            pls->ToString(getter_Copies(uval));
            if (uval)
                SetAcceptLanguages(NS_ConvertUTF16toUTF8(uval).get());
        }
    }

    //
    // Tracking options
    //

    if (PREF_CHANGED(DONOTTRACK_HEADER_ENABLED)) {
        cVar = false;
        rv = prefs->GetBoolPref(DONOTTRACK_HEADER_ENABLED, &cVar);
        if (NS_SUCCEEDED(rv)) {
            mDoNotTrackEnabled = cVar;
        }
    }
    // Hint option
    if (PREF_CHANGED(SAFE_HINT_HEADER_VALUE)) {
        cVar = false;
        rv = prefs->GetBoolPref(SAFE_HINT_HEADER_VALUE, &cVar);
        if (NS_SUCCEEDED(rv)) {
            mSafeHintEnabled = cVar;
        }
    }

    // toggle to true anytime a token bucket related pref is changed.. that
    // includes telemetry and allow-experiments because of the abtest profile
    bool requestTokenBucketUpdated = false;

    //
    // Telemetry
    //

    if (PREF_CHANGED(TELEMETRY_ENABLED)) {
        cVar = false;
        requestTokenBucketUpdated = true;
        rv = prefs->GetBoolPref(TELEMETRY_ENABLED, &cVar);
        if (NS_SUCCEEDED(rv)) {
            mTelemetryEnabled = cVar;
        }
    }

    // "security.ssl3.ecdhe_rsa_aes_128_gcm_sha256" is the required h2 interop
    // suite.

    if (PREF_CHANGED(H2MANDATORY_SUITE)) {
        cVar = false;
        rv = prefs->GetBoolPref(H2MANDATORY_SUITE, &cVar);
        if (NS_SUCCEEDED(rv)) {
            mH2MandatorySuiteEnabled = cVar;
        }
    }

    //
    // network.allow-experiments
    //
    if (PREF_CHANGED(ALLOW_EXPERIMENTS)) {
        cVar = true;
        requestTokenBucketUpdated = true;
        rv = prefs->GetBoolPref(ALLOW_EXPERIMENTS, &cVar);
        if (NS_SUCCEEDED(rv)) {
            mAllowExperiments = cVar;
        }
    }

    // network.http.debug-observations
    if (PREF_CHANGED("network.http.debug-observations")) {
        cVar = false;
        rv = prefs->GetBoolPref("network.http.debug-observations", &cVar);
        if (NS_SUCCEEDED(rv)) {
            mDebugObservations = cVar;
        }
    }

    //
    // Test HTTP Pipelining (bug796192)
    // If experiments are allowed and pipelining is Off,
    // turn it On for just 10 minutes
    //
    if (mAllowExperiments && !mPipeliningEnabled &&
        PREF_CHANGED(HTTP_PREF("pipelining.abtest"))) {
        rv = prefs->GetBoolPref(HTTP_PREF("pipelining.abtest"), &cVar);
        if (NS_SUCCEEDED(rv)) {
            // If option is enabled, only test for ~1% of sessions
            if (cVar && !(rand() % 128)) {
                mCapabilities |=  NS_HTTP_ALLOW_PIPELINING;
                if (mPipelineTestTimer)
                    mPipelineTestTimer->Cancel();
                mPipelineTestTimer =
                    do_CreateInstance("@mozilla.org/timer;1", &rv);
                if (NS_SUCCEEDED(rv)) {
                    rv = mPipelineTestTimer->InitWithFuncCallback(
                        TimerCallback, this, 10*60*1000, // 10 minutes
                        nsITimer::TYPE_ONE_SHOT);
                }
            } else {
                mCapabilities &= ~NS_HTTP_ALLOW_PIPELINING;
                if (mPipelineTestTimer) {
                    mPipelineTestTimer->Cancel();
                    mPipelineTestTimer = nullptr;
                }
            }
        }
    }

    if (PREF_CHANGED(HTTP_PREF("pacing.requests.enabled"))) {
        rv = prefs->GetBoolPref(HTTP_PREF("pacing.requests.enabled"), &cVar);
        if (NS_SUCCEEDED(rv)) {
            mRequestTokenBucketEnabled = cVar;
            requestTokenBucketUpdated = true;
        }
    }
    if (PREF_CHANGED(HTTP_PREF("pacing.requests.min-parallelism"))) {
        rv = prefs->GetIntPref(HTTP_PREF("pacing.requests.min-parallelism"), &val);
        if (NS_SUCCEEDED(rv)) {
            mRequestTokenBucketMinParallelism = static_cast<uint16_t>(clamped(val, 1, 1024));
            requestTokenBucketUpdated = true;
        }
    }
    if (PREF_CHANGED(HTTP_PREF("pacing.requests.hz"))) {
        rv = prefs->GetIntPref(HTTP_PREF("pacing.requests.hz"), &val);
        if (NS_SUCCEEDED(rv)) {
            mRequestTokenBucketHz = static_cast<uint32_t>(clamped(val, 1, 10000));
            requestTokenBucketUpdated = true;
        }
    }
    if (PREF_CHANGED(HTTP_PREF("pacing.requests.burst"))) {
        rv = prefs->GetIntPref(HTTP_PREF("pacing.requests.burst"), &val);
        if (NS_SUCCEEDED(rv)) {
            mRequestTokenBucketBurst = val ? val : 1;
            requestTokenBucketUpdated = true;
        }
    }
    if (requestTokenBucketUpdated) {
        MakeNewRequestTokenBucket();
    }

    // Keepalive values for initial and idle connections.
    if (PREF_CHANGED(HTTP_PREF("tcp_keepalive.short_lived_connections"))) {
        rv = prefs->GetBoolPref(
            HTTP_PREF("tcp_keepalive.short_lived_connections"), &cVar);
        if (NS_SUCCEEDED(rv) && cVar != mTCPKeepaliveShortLivedEnabled) {
            mTCPKeepaliveShortLivedEnabled = cVar;
        }
    }

    if (PREF_CHANGED(HTTP_PREF("tcp_keepalive.short_lived_time"))) {
        rv = prefs->GetIntPref(
            HTTP_PREF("tcp_keepalive.short_lived_time"), &val);
        if (NS_SUCCEEDED(rv) && val > 0)
            mTCPKeepaliveShortLivedTimeS = clamped(val, 1, 300); // Max 5 mins.
    }

    if (PREF_CHANGED(HTTP_PREF("tcp_keepalive.short_lived_idle_time"))) {
        rv = prefs->GetIntPref(
            HTTP_PREF("tcp_keepalive.short_lived_idle_time"), &val);
        if (NS_SUCCEEDED(rv) && val > 0)
            mTCPKeepaliveShortLivedIdleTimeS = clamped(val,
                                                       1, kMaxTCPKeepIdle);
    }

    // Keepalive values for Long-lived Connections.
    if (PREF_CHANGED(HTTP_PREF("tcp_keepalive.long_lived_connections"))) {
        rv = prefs->GetBoolPref(
            HTTP_PREF("tcp_keepalive.long_lived_connections"), &cVar);
        if (NS_SUCCEEDED(rv) && cVar != mTCPKeepaliveLongLivedEnabled) {
            mTCPKeepaliveLongLivedEnabled = cVar;
        }
    }

    if (PREF_CHANGED(HTTP_PREF("tcp_keepalive.long_lived_idle_time"))) {
        rv = prefs->GetIntPref(
            HTTP_PREF("tcp_keepalive.long_lived_idle_time"), &val);
        if (NS_SUCCEEDED(rv) && val > 0)
            mTCPKeepaliveLongLivedIdleTimeS = clamped(val,
                                                      1, kMaxTCPKeepIdle);
    }

    if (PREF_CHANGED(HTTP_PREF("enforce-framing.http1")) ||
        PREF_CHANGED(HTTP_PREF("enforce-framing.soft")) ) {
        rv = prefs->GetBoolPref(HTTP_PREF("enforce-framing.http1"), &cVar);
        if (NS_SUCCEEDED(rv) && cVar) {
            mEnforceH1Framing = FRAMECHECK_STRICT;
        } else {
            rv = prefs->GetBoolPref(HTTP_PREF("enforce-framing.soft"), &cVar);
            if (NS_SUCCEEDED(rv) && cVar) {
                mEnforceH1Framing = FRAMECHECK_BARELY;
            } else {
                mEnforceH1Framing = FRAMECHECK_LAX;
            }
        }
    }

    // remote content-signature testing option
    if (PREF_CHANGED(NEW_TAB_REMOTE_MODE)) {
        nsAutoCString channel;
        prefs->GetCharPref(NEW_TAB_REMOTE_MODE, getter_Copies(channel));
        if (channel.EqualsLiteral("test") ||
            channel.EqualsLiteral("test2") ||
            channel.EqualsLiteral("dev")) {
            mNewTabContentSignaturesDisabled = true;
        } else {
            mNewTabContentSignaturesDisabled = false;
        }
    }

    if (PREF_CHANGED(HTTP_PREF("keep_empty_response_headers_as_empty_string"))) {
        rv = prefs->GetBoolPref(HTTP_PREF("keep_empty_response_headers_as_empty_string"),
                                &cVar);
        if (NS_SUCCEEDED(rv)) {
            mKeepEmptyResponseHeadersAsEmtpyString = cVar;
        }
    }

    if (PREF_CHANGED(HTTP_PREF("spdy.hpack-default-buffer"))) {
        rv = prefs->GetIntPref(HTTP_PREF("spdy.default-hpack-buffer"), &val);
        if (NS_SUCCEEDED(rv)) {
            mDefaultHpackBuffer = val;
        }
    }

    // Enable HTTP response timeout if TCP Keepalives are disabled.
    mResponseTimeoutEnabled = !mTCPKeepaliveShortLivedEnabled &&
                              !mTCPKeepaliveLongLivedEnabled;

#undef PREF_CHANGED
#undef MULTI_PREF_CHANGED
}


/**
 * Static method called by mPipelineTestTimer when it expires.
 */
void
nsHttpHandler::TimerCallback(nsITimer * aTimer, void * aClosure)
{
    RefPtr<nsHttpHandler> thisObject = static_cast<nsHttpHandler*>(aClosure);
    if (!thisObject->mPipeliningEnabled)
        thisObject->mCapabilities &= ~NS_HTTP_ALLOW_PIPELINING;
}

/**
 * Currently, only regularizes the case of subtags.
 */
static void
CanonicalizeLanguageTag(char *languageTag)
{
    char *s = languageTag;
    while (*s != '\0') {
        *s = nsCRT::ToLower(*s);
        s++;
    }

    s = languageTag;
    bool isFirst = true;
    bool seenSingleton = false;
    while (*s != '\0') {
        char *subTagEnd = strchr(s, '-');
        if (subTagEnd == nullptr) {
            subTagEnd = strchr(s, '\0');
        }

        if (isFirst) {
            isFirst = false;
        } else if (seenSingleton) {
            // Do nothing
        } else {
            size_t subTagLength = subTagEnd - s;
            if (subTagLength == 1) {
                seenSingleton = true;
            } else if (subTagLength == 2) {
                *s = nsCRT::ToUpper(*s);
                *(s + 1) = nsCRT::ToUpper(*(s + 1));
            } else if (subTagLength == 4) {
                *s = nsCRT::ToUpper(*s);
            }
        }

        s = subTagEnd;
        if (*s != '\0') {
            s++;
        }
    }
}

/**
 *  Allocates a C string into that contains a ISO 639 language list
 *  notated with HTTP "q" values for output with a HTTP Accept-Language
 *  header. Previous q values will be stripped because the order of
 *  the langs imply the q value. The q values are calculated by dividing
 *  1.0 amongst the number of languages present.
 *
 *  Ex: passing: "en, ja"
 *      returns: "en,ja;q=0.5"
 *
 *      passing: "en, ja, fr_CA"
 *      returns: "en,ja;q=0.7,fr_CA;q=0.3"
 */
static nsresult
PrepareAcceptLanguages(const char *i_AcceptLanguages, nsACString &o_AcceptLanguages)
{
    if (!i_AcceptLanguages)
        return NS_OK;

    uint32_t n, count_n, size, wrote;
    double q, dec;
    char *p, *p2, *token, *q_Accept, *o_Accept;
    const char *comma;
    int32_t available;

    o_Accept = strdup(i_AcceptLanguages);
    if (!o_Accept)
        return NS_ERROR_OUT_OF_MEMORY;
    for (p = o_Accept, n = size = 0; '\0' != *p; p++) {
        if (*p == ',') n++;
            size++;
    }

    available = size + ++n * 11 + 1;
    q_Accept = new char[available];
    if (!q_Accept) {
        free(o_Accept);
        return NS_ERROR_OUT_OF_MEMORY;
    }
    *q_Accept = '\0';
    q = 1.0;
    dec = q / (double) n;
    count_n = 0;
    p2 = q_Accept;
    for (token = nsCRT::strtok(o_Accept, ",", &p);
         token != (char *) 0;
         token = nsCRT::strtok(p, ",", &p))
    {
        token = net_FindCharNotInSet(token, HTTP_LWS);
        char* trim;
        trim = net_FindCharInSet(token, ";" HTTP_LWS);
        if (trim != (char*)0)  // remove "; q=..." if present
            *trim = '\0';

        if (*token != '\0') {
            CanonicalizeLanguageTag(token);

            comma = count_n++ != 0 ? "," : ""; // delimiter if not first item
            uint32_t u = QVAL_TO_UINT(q);

            // Only display q-value if less than 1.00.
            if (u < 100) {
                const char *qval_str;

                // With a small number of languages, one decimal place is enough to prevent duplicate q-values.
                // Also, trailing zeroes do not add any information, so they can be removed.
                if ((n < 10) || ((u % 10) == 0)) {
                    u = (u + 5) / 10;
                    qval_str = "%s%s;q=0.%u";
                } else {
                    // Values below 10 require zero padding.
                    qval_str = "%s%s;q=0.%02u";
                }

                wrote = snprintf(p2, available, qval_str, comma, token, u);
            } else {
                wrote = snprintf(p2, available, "%s%s", comma, token);
            }

            q -= dec;
            p2 += wrote;
            available -= wrote;
            MOZ_ASSERT(available > 0, "allocated string not long enough");
        }
    }
    free(o_Accept);

    o_AcceptLanguages.Assign((const char *) q_Accept);
    delete [] q_Accept;

    return NS_OK;
}

nsresult
nsHttpHandler::SetAcceptLanguages(const char *aAcceptLanguages)
{
    nsAutoCString buf;
    nsresult rv = PrepareAcceptLanguages(aAcceptLanguages, buf);
    if (NS_SUCCEEDED(rv))
        mAcceptLanguages.Assign(buf);
    return rv;
}

nsresult
nsHttpHandler::SetAccept(const char *aAccept)
{
    mAccept = aAccept;
    return NS_OK;
}

nsresult
nsHttpHandler::SetAcceptEncodings(const char *aAcceptEncodings, bool isSecure)
{
    if (isSecure) {
        mHttpsAcceptEncodings = aAcceptEncodings;
    } else {
        // use legacy list if a secure override is not specified
        mHttpAcceptEncodings = aAcceptEncodings;
        if (mHttpsAcceptEncodings.IsEmpty()) {
            mHttpsAcceptEncodings = aAcceptEncodings;
        }
    }

    return NS_OK;
}

//-----------------------------------------------------------------------------
// nsHttpHandler::nsISupports
//-----------------------------------------------------------------------------

NS_IMPL_ISUPPORTS(nsHttpHandler,
                  nsIHttpProtocolHandler,
                  nsIProxiedProtocolHandler,
                  nsIProtocolHandler,
                  nsIObserver,
                  nsISupportsWeakReference,
                  nsISpeculativeConnect)

//-----------------------------------------------------------------------------
// nsHttpHandler::nsIProtocolHandler
//-----------------------------------------------------------------------------

NS_IMETHODIMP
nsHttpHandler::GetScheme(nsACString &aScheme)
{
    aScheme.AssignLiteral("http");
    return NS_OK;
}

NS_IMETHODIMP
nsHttpHandler::GetDefaultPort(int32_t *result)
{
    *result = NS_HTTP_DEFAULT_PORT;
    return NS_OK;
}

NS_IMETHODIMP
nsHttpHandler::GetProtocolFlags(uint32_t *result)
{
    *result = NS_HTTP_PROTOCOL_FLAGS;
    return NS_OK;
}

NS_IMETHODIMP
nsHttpHandler::NewURI(const nsACString &aSpec,
                      const char *aCharset,
                      nsIURI *aBaseURI,
                      nsIURI **aURI)
{
    return mozilla::net::NewURI(aSpec, aCharset, aBaseURI, NS_HTTP_DEFAULT_PORT, aURI);
}

NS_IMETHODIMP
nsHttpHandler::NewChannel2(nsIURI* uri,
                           nsILoadInfo* aLoadInfo,
                           nsIChannel** result)
{
    LOG(("nsHttpHandler::NewChannel\n"));

    NS_ENSURE_ARG_POINTER(uri);
    NS_ENSURE_ARG_POINTER(result);

    bool isHttp = false, isHttps = false;

    // Verify that we have been given a valid scheme
    nsresult rv = uri->SchemeIs("http", &isHttp);
    if (NS_FAILED(rv)) return rv;
    if (!isHttp) {
        rv = uri->SchemeIs("https", &isHttps);
        if (NS_FAILED(rv)) return rv;
        if (!isHttps) {
            NS_WARNING("Invalid URI scheme");
            return NS_ERROR_UNEXPECTED;
        }
    }

    return NewProxiedChannel2(uri, nullptr, 0, nullptr, aLoadInfo, result);
}

NS_IMETHODIMP
nsHttpHandler::NewChannel(nsIURI *uri, nsIChannel **result)
{
    return NewChannel2(uri, nullptr, result);
}

NS_IMETHODIMP
nsHttpHandler::AllowPort(int32_t port, const char *scheme, bool *_retval)
{
    // don't override anything.
    *_retval = false;
    return NS_OK;
}

//-----------------------------------------------------------------------------
// nsHttpHandler::nsIProxiedProtocolHandler
//-----------------------------------------------------------------------------

NS_IMETHODIMP
nsHttpHandler::NewProxiedChannel2(nsIURI *uri,
                                  nsIProxyInfo* givenProxyInfo,
                                  uint32_t proxyResolveFlags,
                                  nsIURI *proxyURI,
                                  nsILoadInfo* aLoadInfo,
                                  nsIChannel** result)
{
    RefPtr<HttpBaseChannel> httpChannel;

    LOG(("nsHttpHandler::NewProxiedChannel [proxyInfo=%p]\n",
        givenProxyInfo));

    nsCOMPtr<nsProxyInfo> proxyInfo;
    if (givenProxyInfo) {
        proxyInfo = do_QueryInterface(givenProxyInfo);
        NS_ENSURE_ARG(proxyInfo);
    }

    bool https;
    nsresult rv = uri->SchemeIs("https", &https);
    if (NS_FAILED(rv))
        return rv;

    if (IsNeckoChild()) {
        httpChannel = new HttpChannelChild();
    } else {
        httpChannel = new nsHttpChannel();
    }

    uint32_t caps = mCapabilities;

    if (https) {
        // enable pipelining over SSL if requested
        if (mPipeliningOverSSL)
            caps |= NS_HTTP_ALLOW_PIPELINING;
    }

    if (!IsNeckoChild()) {
        // HACK: make sure PSM gets initialized on the main thread.
        net_EnsurePSMInit();
    }

    nsID channelId;
    rv = NewChannelId(&channelId);
    NS_ENSURE_SUCCESS(rv, rv);

    rv = httpChannel->Init(uri, caps, proxyInfo, proxyResolveFlags, proxyURI, channelId);
    if (NS_FAILED(rv))
        return rv;

    // set the loadInfo on the new channel
    rv = httpChannel->SetLoadInfo(aLoadInfo);
    if (NS_FAILED(rv)) {
        return rv;
    }

    httpChannel.forget(result);
    return NS_OK;
}

NS_IMETHODIMP
nsHttpHandler::NewProxiedChannel(nsIURI *uri,
                                 nsIProxyInfo* givenProxyInfo,
                                 uint32_t proxyResolveFlags,
                                 nsIURI *proxyURI,
                                 nsIChannel **result)
{
    return NewProxiedChannel2(uri, givenProxyInfo,
                              proxyResolveFlags, proxyURI,
                              nullptr, result);
}

//-----------------------------------------------------------------------------
// nsHttpHandler::nsIHttpProtocolHandler
//-----------------------------------------------------------------------------

NS_IMETHODIMP
nsHttpHandler::GetUserAgent(nsACString &value)
{
    value = UserAgent();
    return NS_OK;
}

NS_IMETHODIMP
nsHttpHandler::GetAppName(nsACString &value)
{
    value = mLegacyAppName;
    return NS_OK;
}

NS_IMETHODIMP
nsHttpHandler::GetAppVersion(nsACString &value)
{
    value = mLegacyAppVersion;
    return NS_OK;
}

NS_IMETHODIMP
nsHttpHandler::GetPlatform(nsACString &value)
{
    value = mPlatform;
    return NS_OK;
}

NS_IMETHODIMP
nsHttpHandler::GetOscpu(nsACString &value)
{
    value = mOscpu;
    return NS_OK;
}

NS_IMETHODIMP
nsHttpHandler::GetMisc(nsACString &value)
{
    value = mMisc;
    return NS_OK;
}

//-----------------------------------------------------------------------------
// nsHttpHandler::nsIObserver
//-----------------------------------------------------------------------------

NS_IMETHODIMP
nsHttpHandler::Observe(nsISupports *subject,
                       const char *topic,
                       const char16_t *data)
{
    MOZ_ASSERT(NS_IsMainThread());
    LOG(("nsHttpHandler::Observe [topic=\"%s\"]\n", topic));

    if (!strcmp(topic, NS_PREFBRANCH_PREFCHANGE_TOPIC_ID)) {
        nsCOMPtr<nsIPrefBranch> prefBranch = do_QueryInterface(subject);
        if (prefBranch)
            PrefsChanged(prefBranch, NS_ConvertUTF16toUTF8(data).get());
    } else if (!strcmp(topic, "profile-change-net-teardown") ||
               !strcmp(topic, NS_XPCOM_SHUTDOWN_OBSERVER_ID) ) {

        mHandlerActive = false;

        // clear cache of all authentication credentials.
        mAuthCache.ClearAll();
        mPrivateAuthCache.ClearAll();
        if (mWifiTickler)
            mWifiTickler->Cancel();

        // Inform nsIOService that network is tearing down.
        gIOService->SetHttpHandlerAlreadyShutingDown();

        ShutdownConnectionManager();

        // need to reset the session start time since cache validation may
        // depend on this value.
        mSessionStartTime = NowInSeconds();

        if (!mDoNotTrackEnabled) {
            Telemetry::Accumulate(Telemetry::DNT_USAGE, 2);
        } else {
            Telemetry::Accumulate(Telemetry::DNT_USAGE, 1);
        }
    } else if (!strcmp(topic, "profile-change-net-restore")) {
        // initialize connection manager
        InitConnectionMgr();
    } else if (!strcmp(topic, "net:clear-active-logins")) {
        mAuthCache.ClearAll();
        mPrivateAuthCache.ClearAll();
    } else if (!strcmp(topic, "net:prune-dead-connections")) {
        if (mConnMgr) {
            mConnMgr->PruneDeadConnections();
        }
    } else if (!strcmp(topic, "net:prune-all-connections")) {
        if (mConnMgr) {
            mConnMgr->DoShiftReloadConnectionCleanup(nullptr);
            mConnMgr->PruneDeadConnections();
        }
    } else if (!strcmp(topic, "net:failed-to-process-uri-content")) {
        nsCOMPtr<nsIURI> uri = do_QueryInterface(subject);
        if (uri && mConnMgr) {
            mConnMgr->ReportFailedToProcess(uri);
        }
    } else if (!strcmp(topic, "last-pb-context-exited")) {
        mPrivateAuthCache.ClearAll();
        if (mConnMgr) {
            mConnMgr->ClearAltServiceMappings();
        }
    } else if (!strcmp(topic, "webapps-clear-data")) {
        if (mConnMgr) {
            mConnMgr->ClearAltServiceMappings();
        }
    } else if (!strcmp(topic, "browser:purge-session-history")) {
        if (mConnMgr) {
            if (gSocketTransportService) {
                nsCOMPtr<nsIRunnable> event =
                    NewRunnableMethod(mConnMgr,
                                      &nsHttpConnectionMgr::ClearConnectionHistory);
                gSocketTransportService->Dispatch(event, NS_DISPATCH_NORMAL);
            }
            mConnMgr->ClearAltServiceMappings();
        }
    } else if (!strcmp(topic, NS_NETWORK_LINK_TOPIC)) {
        nsAutoCString converted = NS_ConvertUTF16toUTF8(data);
        if (!strcmp(converted.get(), NS_NETWORK_LINK_DATA_CHANGED)) {
            if (mConnMgr) {
                mConnMgr->PruneDeadConnections();
                mConnMgr->VerifyTraffic();
            }
        }
    } else if (!strcmp(topic, "application-background")) {
        // going to the background on android means we should close
        // down idle connections for power conservation
        if (mConnMgr) {
            mConnMgr->DoShiftReloadConnectionCleanup(nullptr);
        }
    }

    return NS_OK;
}

// nsISpeculativeConnect

nsresult
nsHttpHandler::SpeculativeConnectInternal(nsIURI *aURI,
                                          nsIPrincipal *aPrincipal,
                                          nsIInterfaceRequestor *aCallbacks,
                                          bool anonymous)
{
    if (IsNeckoChild()) {
        ipc::URIParams params;
        SerializeURI(aURI, params);
        gNeckoChild->SendSpeculativeConnect(params,
                                            IPC::Principal(aPrincipal),
                                            anonymous);
        return NS_OK;
    }

    if (!mHandlerActive)
        return NS_OK;

    MOZ_ASSERT(NS_IsMainThread());
    nsCOMPtr<nsIObserverService> obsService = services::GetObserverService();
    if (mDebugObservations && obsService) {
        // this is basically used for test coverage of an otherwise 'hintable'
        // feature
        obsService->NotifyObservers(nullptr, "speculative-connect-request",
                                    nullptr);
        if (!IsNeckoChild()) {
            for (auto* cp : dom::ContentParent::AllProcesses(dom::ContentParent::eLive)) {
                PNeckoParent* neckoParent = SingleManagedOrNull(cp->ManagedPNeckoParent());
                if (!neckoParent) {
                    continue;
                }
                Unused << neckoParent->SendSpeculativeConnectRequest();
            }
        }
    }

    nsISiteSecurityService* sss = gHttpHandler->GetSSService();
    bool isStsHost = false;
    if (!sss)
        return NS_OK;

    nsCOMPtr<nsILoadContext> loadContext = do_GetInterface(aCallbacks);
    uint32_t flags = 0;
    if (loadContext && loadContext->UsePrivateBrowsing())
        flags |= nsISocketProvider::NO_PERMANENT_STORAGE;
    nsCOMPtr<nsIURI> clone;
    if (NS_SUCCEEDED(sss->IsSecureURI(nsISiteSecurityService::HEADER_HSTS,
                                      aURI, flags, nullptr, &isStsHost)) &&
                                      isStsHost) {
        if (NS_SUCCEEDED(NS_GetSecureUpgradedURI(aURI,
                                                 getter_AddRefs(clone)))) {
            aURI = clone.get();
            // (NOTE: We better make sure |clone| stays alive until the end
            // of the function now, since our aURI arg now points to it!)
        }
    }

    nsAutoCString scheme;
    nsresult rv = aURI->GetScheme(scheme);
    if (NS_FAILED(rv))
        return rv;

    // If this is HTTPS, make sure PSM is initialized as the channel
    // creation path may have been bypassed
    if (scheme.EqualsLiteral("https")) {
        if (!IsNeckoChild()) {
            // make sure PSM gets initialized on the main thread.
            net_EnsurePSMInit();
        }
    }
    // Ensure that this is HTTP or HTTPS, otherwise we don't do preconnect here
    else if (!scheme.EqualsLiteral("http"))
        return NS_ERROR_UNEXPECTED;

    // Construct connection info object
    bool usingSSL = false;
    rv = aURI->SchemeIs("https", &usingSSL);
    if (NS_FAILED(rv))
        return rv;

    nsAutoCString host;
    rv = aURI->GetAsciiHost(host);
    if (NS_FAILED(rv))
        return rv;

    int32_t port = -1;
    rv = aURI->GetPort(&port);
    if (NS_FAILED(rv))
        return rv;

    nsAutoCString username;
    aURI->GetUsername(username);

    NeckoOriginAttributes neckoOriginAttributes;
    // If the principal is given, we use the originAttributes from this
    // principal. Otherwise, we use the originAttributes from the
    // loadContext.
    if (aPrincipal) {
        neckoOriginAttributes.InheritFromDocToNecko(
            BasePrincipal::Cast(aPrincipal)->OriginAttributesRef());
    } else if (loadContext) {
        DocShellOriginAttributes docshellOriginAttributes;
        loadContext->GetOriginAttributes(docshellOriginAttributes);
        neckoOriginAttributes.InheritFromDocShellToNecko(docshellOriginAttributes);
    }

    auto *ci =
        new nsHttpConnectionInfo(host, port, EmptyCString(), username, nullptr,
                                 neckoOriginAttributes, usingSSL);
    ci->SetAnonymous(anonymous);

    return SpeculativeConnect(ci, aCallbacks);
}

NS_IMETHODIMP
nsHttpHandler::SpeculativeConnect(nsIURI *aURI,
                                  nsIInterfaceRequestor *aCallbacks)
{
    return SpeculativeConnectInternal(aURI, nullptr, aCallbacks, false);
}

NS_IMETHODIMP
nsHttpHandler::SpeculativeConnect2(nsIURI *aURI,
                                   nsIPrincipal *aPrincipal,
                                   nsIInterfaceRequestor *aCallbacks)
{
    return SpeculativeConnectInternal(aURI, aPrincipal, aCallbacks, false);
}

NS_IMETHODIMP
nsHttpHandler::SpeculativeAnonymousConnect(nsIURI *aURI,
                                           nsIInterfaceRequestor *aCallbacks)
{
    return SpeculativeConnectInternal(aURI, nullptr, aCallbacks, true);
}

NS_IMETHODIMP
nsHttpHandler::SpeculativeAnonymousConnect2(nsIURI *aURI,
                                            nsIPrincipal *aPrincipal,
                                            nsIInterfaceRequestor *aCallbacks)
{
    return SpeculativeConnectInternal(aURI, aPrincipal, aCallbacks, true);
}

void
nsHttpHandler::TickleWifi(nsIInterfaceRequestor *cb)
{
    if (!cb || !mWifiTickler)
        return;

    // If B2G requires a similar mechanism nsINetworkManager, currently only avail
    // on B2G, contains the necessary information on wifi and gateway

    nsCOMPtr<nsIDOMWindow> domWindow = do_GetInterface(cb);
    nsCOMPtr<nsPIDOMWindowOuter> piWindow = do_QueryInterface(domWindow);
    if (!piWindow)
        return;

    nsCOMPtr<nsIDOMNavigator> domNavigator = piWindow->GetNavigator();
    nsCOMPtr<nsIMozNavigatorNetwork> networkNavigator =
        do_QueryInterface(domNavigator);
    if (!networkNavigator)
        return;

    nsCOMPtr<nsINetworkProperties> networkProperties;
    networkNavigator->GetProperties(getter_AddRefs(networkProperties));
    if (!networkProperties)
        return;

    uint32_t gwAddress;
    bool isWifi;
    nsresult rv;

    rv = networkProperties->GetDhcpGateway(&gwAddress);
    if (NS_SUCCEEDED(rv))
        rv = networkProperties->GetIsWifi(&isWifi);
    if (NS_FAILED(rv))
        return;

    if (!gwAddress || !isWifi)
        return;

    mWifiTickler->SetIPV4Address(gwAddress);
    mWifiTickler->Tickle();
}

//-----------------------------------------------------------------------------
// nsHttpsHandler implementation
//-----------------------------------------------------------------------------

NS_IMPL_ISUPPORTS(nsHttpsHandler,
                  nsIHttpProtocolHandler,
                  nsIProxiedProtocolHandler,
                  nsIProtocolHandler,
                  nsISupportsWeakReference,
                  nsISpeculativeConnect)

nsresult
nsHttpsHandler::Init()
{
    nsCOMPtr<nsIProtocolHandler> httpHandler(
            do_GetService(NS_NETWORK_PROTOCOL_CONTRACTID_PREFIX "http"));
    MOZ_ASSERT(httpHandler.get() != nullptr);
    return NS_OK;
}

NS_IMETHODIMP
nsHttpsHandler::GetScheme(nsACString &aScheme)
{
    aScheme.AssignLiteral("https");
    return NS_OK;
}

NS_IMETHODIMP
nsHttpsHandler::GetDefaultPort(int32_t *aPort)
{
    *aPort = NS_HTTPS_DEFAULT_PORT;
    return NS_OK;
}

NS_IMETHODIMP
nsHttpsHandler::GetProtocolFlags(uint32_t *aProtocolFlags)
{
    *aProtocolFlags = NS_HTTP_PROTOCOL_FLAGS | URI_SAFE_TO_LOAD_IN_SECURE_CONTEXT;
    return NS_OK;
}

NS_IMETHODIMP
nsHttpsHandler::NewURI(const nsACString &aSpec,
                       const char *aOriginCharset,
                       nsIURI *aBaseURI,
                       nsIURI **_retval)
{
    return mozilla::net::NewURI(aSpec, aOriginCharset, aBaseURI, NS_HTTPS_DEFAULT_PORT, _retval);
}

NS_IMETHODIMP
nsHttpsHandler::NewChannel2(nsIURI* aURI,
                            nsILoadInfo* aLoadInfo,
                            nsIChannel** _retval)
{
    MOZ_ASSERT(gHttpHandler);
    if (!gHttpHandler)
      return NS_ERROR_UNEXPECTED;
    return gHttpHandler->NewChannel2(aURI, aLoadInfo, _retval);
}

NS_IMETHODIMP
nsHttpsHandler::NewChannel(nsIURI *aURI, nsIChannel **_retval)
{
    return NewChannel2(aURI, nullptr, _retval);
}

NS_IMETHODIMP
nsHttpsHandler::AllowPort(int32_t aPort, const char *aScheme, bool *_retval)
{
    // don't override anything.
    *_retval = false;
    return NS_OK;
}

void
nsHttpHandler::ShutdownConnectionManager()
{
    // ensure connection manager is shutdown
    if (mConnMgr) {
        mConnMgr->Shutdown();
    }
}

nsresult
nsHttpHandler::NewChannelId(nsID *channelId)
{
  MOZ_ASSERT(NS_IsMainThread());
  if (!mUUIDGen) {
    nsresult rv;
    mUUIDGen = do_GetService("@mozilla.org/uuid-generator;1", &rv);
    NS_ENSURE_SUCCESS(rv, rv);
  }

  return mUUIDGen->GenerateUUIDInPlace(channelId);
}

} // namespace net
} // namespace mozilla
