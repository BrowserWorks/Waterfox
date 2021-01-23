/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim:set et cin ts=4 sw=2 sts=2: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef nsHttpChannel_h__
#define nsHttpChannel_h__

#include "DelayHttpChannelQueue.h"
#include "HttpBaseChannel.h"
#include "nsTArray.h"
#include "nsICachingChannel.h"
#include "nsICacheEntry.h"
#include "nsICacheEntryOpenCallback.h"
#include "nsIDNSListener.h"
#include "nsIApplicationCacheChannel.h"
#include "nsIChannelWithDivertableParentListener.h"
#include "nsIProtocolProxyCallback.h"
#include "nsIHttpAuthenticableChannel.h"
#include "nsIAsyncVerifyRedirectCallback.h"
#include "nsIThreadRetargetableRequest.h"
#include "nsIThreadRetargetableStreamListener.h"
#include "nsWeakReference.h"
#include "TimingStruct.h"
#include "ADivertableParentChannel.h"
#include "AutoClose.h"
#include "nsIStreamListener.h"
#include "nsICorsPreflightCallback.h"
#include "AlternateServices.h"
#include "nsIRaceCacheWithNetwork.h"
#include "mozilla/Atomics.h"
#include "mozilla/extensions/PStreamFilterParent.h"
#include "mozilla/Mutex.h"

class nsDNSPrefetch;
class nsICancelable;
class nsIDNSRecord;
class nsIHttpChannelAuthProvider;
class nsInputStreamPump;
class nsITransportSecurityInfo;

namespace mozilla {
namespace net {

class nsChannelClassifier;
class HttpChannelSecurityWarningReporter;

using DNSPromise = MozPromise<nsCOMPtr<nsIDNSRecord>, nsresult, false>;

//-----------------------------------------------------------------------------
// nsHttpChannel
//-----------------------------------------------------------------------------

// Use to support QI nsIChannel to nsHttpChannel
#define NS_HTTPCHANNEL_IID                           \
  {                                                  \
    0x301bf95b, 0x7bb3, 0x4ae1, {                    \
      0xa9, 0x71, 0x40, 0xbc, 0xfa, 0x81, 0xde, 0x12 \
    }                                                \
  }

class nsHttpChannel final : public HttpBaseChannel,
                            public HttpAsyncAborter<nsHttpChannel>,
                            public nsIStreamListener,
                            public nsICachingChannel,
                            public nsICacheEntryOpenCallback,
                            public nsITransportEventSink,
                            public nsIProtocolProxyCallback,
                            public nsIHttpAuthenticableChannel,
                            public nsIApplicationCacheChannel,
                            public nsIAsyncVerifyRedirectCallback,
                            public nsIThreadRetargetableRequest,
                            public nsIThreadRetargetableStreamListener,
                            public nsIDNSListener,
                            public nsSupportsWeakReference,
                            public nsICorsPreflightCallback,
                            public nsIChannelWithDivertableParentListener,
                            public nsIRaceCacheWithNetwork,
                            public nsIRequestTailUnblockCallback,
                            public nsITimerCallback {
 public:
  NS_DECL_ISUPPORTS_INHERITED
  NS_DECL_NSIREQUESTOBSERVER
  NS_DECL_NSISTREAMLISTENER
  NS_DECL_NSITHREADRETARGETABLESTREAMLISTENER
  NS_DECL_NSICACHEINFOCHANNEL
  NS_DECL_NSICACHINGCHANNEL
  NS_DECL_NSICACHEENTRYOPENCALLBACK
  NS_DECL_NSITRANSPORTEVENTSINK
  NS_DECL_NSIPROTOCOLPROXYCALLBACK
  NS_DECL_NSIPROXIEDCHANNEL
  NS_DECL_NSIAPPLICATIONCACHECONTAINER
  NS_DECL_NSIAPPLICATIONCACHECHANNEL
  NS_DECL_NSIASYNCVERIFYREDIRECTCALLBACK
  NS_DECL_NSITHREADRETARGETABLEREQUEST
  NS_DECL_NSIDNSLISTENER
  NS_DECL_NSICHANNELWITHDIVERTABLEPARENTLISTENER
  NS_DECLARE_STATIC_IID_ACCESSOR(NS_HTTPCHANNEL_IID)
  NS_DECL_NSIRACECACHEWITHNETWORK
  NS_DECL_NSITIMERCALLBACK
  NS_DECL_NSIREQUESTTAILUNBLOCKCALLBACK

  // nsIHttpAuthenticableChannel. We can't use
  // NS_DECL_NSIHTTPAUTHENTICABLECHANNEL because it duplicates cancel() and
  // others.
  NS_IMETHOD GetIsSSL(bool* aIsSSL) override;
  NS_IMETHOD GetProxyMethodIsConnect(bool* aProxyMethodIsConnect) override;
  NS_IMETHOD GetServerResponseHeader(
      nsACString& aServerResponseHeader) override;
  NS_IMETHOD GetProxyChallenges(nsACString& aChallenges) override;
  NS_IMETHOD GetWWWChallenges(nsACString& aChallenges) override;
  NS_IMETHOD SetProxyCredentials(const nsACString& aCredentials) override;
  NS_IMETHOD SetWWWCredentials(const nsACString& aCredentials) override;
  NS_IMETHOD OnAuthAvailable() override;
  NS_IMETHOD OnAuthCancelled(bool userCancel) override;
  NS_IMETHOD CloseStickyConnection() override;
  NS_IMETHOD ConnectionRestartable(bool) override;
  // Functions we implement from nsIHttpAuthenticableChannel but are
  // declared in HttpBaseChannel must be implemented in this class. We
  // just call the HttpBaseChannel:: impls.
  NS_IMETHOD GetLoadFlags(nsLoadFlags* aLoadFlags) override;
  NS_IMETHOD GetURI(nsIURI** aURI) override;
  NS_IMETHOD GetNotificationCallbacks(
      nsIInterfaceRequestor** aCallbacks) override;
  NS_IMETHOD GetLoadGroup(nsILoadGroup** aLoadGroup) override;
  NS_IMETHOD GetRequestMethod(nsACString& aMethod) override;

  nsHttpChannel();

  [[nodiscard]] virtual nsresult Init(
      nsIURI* aURI, uint32_t aCaps, nsProxyInfo* aProxyInfo,
      uint32_t aProxyResolveFlags, nsIURI* aProxyURI, uint64_t aChannelId,
      nsContentPolicyType aContentPolicyType) override;

  [[nodiscard]] nsresult OnPush(uint32_t aPushedStreamId,
                                const nsACString& aUrl,
                                const nsACString& aRequestString,
                                HttpTransactionShell* aTransaction);

  static bool IsRedirectStatus(uint32_t status);
  static bool WillRedirect(const nsHttpResponseHead& response);

  // Methods HttpBaseChannel didn't implement for us or that we override.
  //
  // nsIRequest
  NS_IMETHOD Cancel(nsresult status) override;
  NS_IMETHOD Suspend() override;
  NS_IMETHOD Resume() override;
  // nsIChannel
  NS_IMETHOD GetSecurityInfo(nsISupports** aSecurityInfo) override;
  NS_IMETHOD AsyncOpen(nsIStreamListener* aListener) override;
  // nsIHttpChannel
  NS_IMETHOD GetEncodedBodySize(uint64_t* aEncodedBodySize) override;
  // nsIHttpChannelInternal
  NS_IMETHOD SetupFallbackChannel(const char* aFallbackKey) override;
  NS_IMETHOD SetChannelIsForDownload(bool aChannelIsForDownload) override;
  NS_IMETHOD GetNavigationStartTimeStamp(TimeStamp* aTimeStamp) override;
  NS_IMETHOD SetNavigationStartTimeStamp(TimeStamp aTimeStamp) override;
  NS_IMETHOD CancelByURLClassifier(nsresult aErrorCode) override;
  // nsISupportsPriority
  NS_IMETHOD SetPriority(int32_t value) override;
  // nsIClassOfService
  NS_IMETHOD SetClassFlags(uint32_t inFlags) override;
  NS_IMETHOD AddClassFlags(uint32_t inFlags) override;
  NS_IMETHOD ClearClassFlags(uint32_t inFlags) override;

  // nsIResumableChannel
  NS_IMETHOD ResumeAt(uint64_t startPos, const nsACString& entityID) override;

  NS_IMETHOD SetNotificationCallbacks(
      nsIInterfaceRequestor* aCallbacks) override;
  NS_IMETHOD SetLoadGroup(nsILoadGroup* aLoadGroup) override;
  // nsITimedChannel
  NS_IMETHOD GetDomainLookupStart(
      mozilla::TimeStamp* aDomainLookupStart) override;
  NS_IMETHOD GetDomainLookupEnd(mozilla::TimeStamp* aDomainLookupEnd) override;
  NS_IMETHOD GetConnectStart(mozilla::TimeStamp* aConnectStart) override;
  NS_IMETHOD GetTcpConnectEnd(mozilla::TimeStamp* aTcpConnectEnd) override;
  NS_IMETHOD GetSecureConnectionStart(
      mozilla::TimeStamp* aSecureConnectionStart) override;
  NS_IMETHOD GetConnectEnd(mozilla::TimeStamp* aConnectEnd) override;
  NS_IMETHOD GetRequestStart(mozilla::TimeStamp* aRequestStart) override;
  NS_IMETHOD GetResponseStart(mozilla::TimeStamp* aResponseStart) override;
  NS_IMETHOD GetResponseEnd(mozilla::TimeStamp* aResponseEnd) override;
  // nsICorsPreflightCallback
  NS_IMETHOD OnPreflightSucceeded() override;
  NS_IMETHOD OnPreflightFailed(nsresult aError) override;

  [[nodiscard]] nsresult AddSecurityMessage(
      const nsAString& aMessageTag, const nsAString& aMessageCategory) override;
  NS_IMETHOD LogBlockedCORSRequest(const nsAString& aMessage,
                                   const nsACString& aCategory) override;
  NS_IMETHOD LogMimeTypeMismatch(const nsACString& aMessageName, bool aWarning,
                                 const nsAString& aURL,
                                 const nsAString& aContentType) override;

  void SetWarningReporter(HttpChannelSecurityWarningReporter* aReporter);
  HttpChannelSecurityWarningReporter* GetWarningReporter();

  bool OnDataAlreadySent() { return mDataAlreadySent; }

 public: /* internal necko use only */
  uint32_t GetRequestTime() const { return mRequestTime; }

  nsresult AsyncOpenFinal(TimeStamp aTimeStamp);

  [[nodiscard]] nsresult OpenCacheEntry(bool usingSSL);
  [[nodiscard]] nsresult OpenCacheEntryInternal(
      bool isHttps, nsIApplicationCache* applicationCache, bool noAppCache);
  [[nodiscard]] nsresult ContinueConnect();

  [[nodiscard]] nsresult StartRedirectChannelToURI(nsIURI*, uint32_t);

  // This allows cache entry to be marked as foreign even after channel itself
  // is gone.  Needed for e10s (see
  // HttpChannelParent::RecvDocumentChannelCleanup)
  class OfflineCacheEntryAsForeignMarker {
    nsCOMPtr<nsIApplicationCache> mApplicationCache;
    nsCOMPtr<nsIURI> mCacheURI;

   public:
    OfflineCacheEntryAsForeignMarker(nsIApplicationCache* appCache,
                                     nsIURI* aURI)
        : mApplicationCache(appCache), mCacheURI(aURI) {}

    nsresult MarkAsForeign();
  };

  OfflineCacheEntryAsForeignMarker* GetOfflineCacheEntryAsForeignMarker();

  // Helper to keep cache callbacks wait flags consistent
  class AutoCacheWaitFlags {
   public:
    explicit AutoCacheWaitFlags(nsHttpChannel* channel)
        : mChannel(channel), mKeep(0) {
      // Flags must be set before entering any AsyncOpenCacheEntry call.
      mChannel->mCacheEntriesToWaitFor =
          nsHttpChannel::WAIT_FOR_CACHE_ENTRY |
          nsHttpChannel::WAIT_FOR_OFFLINE_CACHE_ENTRY;
    }

    void Keep(uint32_t flags) {
      // Called after successful call to appropriate AsyncOpenCacheEntry call.
      mKeep |= flags;
    }

    ~AutoCacheWaitFlags() {
      // Keep only flags those are left to be wait for.
      mChannel->mCacheEntriesToWaitFor &= mKeep;
    }

   private:
    nsHttpChannel* mChannel;
    uint32_t mKeep : 2;
  };

  bool AwaitingCacheCallbacks();
  void SetCouldBeSynthesized();

  // Return true if the latest ODA is invoked by mCachePump.
  // Should only be called on the same thread as ODA.
  bool IsReadingFromCache() const { return mIsReadingFromCache; }

  base::ProcessId ProcessId();

  using ChildEndpointPromise =
      MozPromise<ipc::Endpoint<extensions::PStreamFilterChild>, bool, true>;
  [[nodiscard]] RefPtr<ChildEndpointPromise> AttachStreamFilter(
      base::ProcessId aChildProcessId);

 private:  // used for alternate service validation
  RefPtr<TransactionObserver> mTransactionObserver;

 public:
  void SetConnectionInfo(nsHttpConnectionInfo*);  // clones the argument
  void SetTransactionObserver(TransactionObserver* arg) {
    mTransactionObserver = arg;
  }
  TransactionObserver* GetTransactionObserver() { return mTransactionObserver; }

  CacheDisposition mCacheDisposition;

 protected:
  virtual ~nsHttpChannel();

 private:
  typedef nsresult (nsHttpChannel::*nsContinueRedirectionFunc)(nsresult result);

  // Directly call |aFunc| if the channel is not canceled and not suspended.
  // Otherwise, set |aFunc| to |mCallOnResume| and wait until the channel
  // resumes.
  nsresult CallOrWaitForResume(
      const std::function<nsresult(nsHttpChannel*)>& aFunc);

  bool RequestIsConditional();
  void HandleContinueCancellingByURLClassifier(nsresult aErrorCode);
  nsresult CancelInternal(nsresult status);
  void ContinueCancellingByURLClassifier(nsresult aErrorCode);

  // Connections will only be established in this function.
  // (including DNS prefetch and speculative connection.)
  nsresult MaybeResolveProxyAndBeginConnect();
  nsresult MaybeStartDNSPrefetch();

  // Tells the channel to resolve the origin of the end server we are connecting
  // to.
  static uint16_t const DNS_PREFETCH_ORIGIN = 1 << 0;
  // Tells the channel to resolve the host name of the proxy.
  static uint16_t const DNS_PREFETCH_PROXY = 1 << 1;
  // Will be set if the current channel uses an HTTP/HTTPS proxy.
  static uint16_t const DNS_PROXY_IS_HTTP = 1 << 2;
  // Tells the channel to wait for the result of the origin server resolution
  // before any connection attempts are made.
  static uint16_t const DNS_BLOCK_ON_ORIGIN_RESOLVE = 1 << 3;

  // Based on the proxy configuration determine the strategy for resolving the
  // end server host name.
  // Returns a combination of the above flags.
  uint16_t GetProxyDNSStrategy();

  // We might synchronously or asynchronously call BeginConnect,
  // which includes DNS prefetch and speculative connection, according to
  // whether an async tracker lookup is required. If the tracker lookup
  // is required, this funciton will just return NS_OK and BeginConnect()
  // will be called when callback. See Bug 1325054 for more information.
  nsresult BeginConnect();
  [[nodiscard]] nsresult ContinueBeginConnectWithResult();
  void ContinueBeginConnect();
  [[nodiscard]] nsresult PrepareToConnect();
  void HandleOnBeforeConnect();
  [[nodiscard]] nsresult OnBeforeConnect();
  [[nodiscard]] nsresult ContinueOnBeforeConnect(bool aShouldUpgrade,
                                                 nsresult aStatus);
  void OnBeforeConnectContinue();
  [[nodiscard]] nsresult Connect();
  void SpeculativeConnect();
  [[nodiscard]] nsresult SetupTransaction();
  [[nodiscard]] nsresult CallOnStartRequest();
  [[nodiscard]] nsresult ProcessResponse();
  void AsyncContinueProcessResponse();
  [[nodiscard]] nsresult ContinueProcessResponse1();
  [[nodiscard]] nsresult ContinueProcessResponse2(nsresult);

 public:
  void UpdateCacheDisposition(bool aSuccessfulReval, bool aPartialContentUsed);
  [[nodiscard]] nsresult ContinueProcessResponse3(nsresult);
  [[nodiscard]] nsresult ContinueProcessResponse4(nsresult);
  [[nodiscard]] nsresult ProcessNormal();
  [[nodiscard]] nsresult ContinueProcessNormal(nsresult);
  void ProcessAltService();
  bool ShouldBypassProcessNotModified();
  [[nodiscard]] nsresult ProcessNotModified(
      const std::function<nsresult(nsHttpChannel*, nsresult)>&
          aContinueProcessResponseFunc);
  [[nodiscard]] nsresult ContinueProcessResponseAfterNotModified(nsresult aRv);

  [[nodiscard]] nsresult AsyncProcessRedirection(uint32_t httpStatus);
  [[nodiscard]] nsresult ContinueProcessRedirection(nsresult);
  [[nodiscard]] nsresult ContinueProcessRedirectionAfterFallback(nsresult);
  [[nodiscard]] nsresult ProcessFailedProxyConnect(uint32_t httpStatus);
  [[nodiscard]] nsresult ProcessFallback(bool* waitingForRedirectCallback);
  [[nodiscard]] nsresult ContinueProcessFallback(nsresult);
  void HandleAsyncAbort();
  [[nodiscard]] nsresult EnsureAssocReq();
  void ProcessSSLInformation();
  bool IsHTTPS();

  [[nodiscard]] nsresult ContinueOnStartRequest1(nsresult);
  [[nodiscard]] nsresult ContinueOnStartRequest2(nsresult);
  [[nodiscard]] nsresult ContinueOnStartRequest3(nsresult);
  [[nodiscard]] nsresult ContinueOnStartRequest4(nsresult);

  void OnClassOfServiceUpdated();

  // redirection specific methods
  void HandleAsyncRedirect();
  void HandleAsyncAPIRedirect();
  [[nodiscard]] nsresult ContinueHandleAsyncRedirect(nsresult);
  void HandleAsyncNotModified();
  void HandleAsyncFallback();
  [[nodiscard]] nsresult ContinueHandleAsyncFallback(nsresult);
  [[nodiscard]] nsresult PromptTempRedirect();
  [[nodiscard]] virtual nsresult SetupReplacementChannel(
      nsIURI*, nsIChannel*, bool preserveMethod,
      uint32_t redirectFlags) override;

  // proxy specific methods
  [[nodiscard]] nsresult ProxyFailover();
  [[nodiscard]] nsresult AsyncDoReplaceWithProxy(nsIProxyInfo*);
  [[nodiscard]] nsresult ContinueDoReplaceWithProxy(nsresult);
  [[nodiscard]] nsresult ResolveProxy();

  // cache specific methods
  [[nodiscard]] nsresult OnOfflineCacheEntryAvailable(
      nsICacheEntry* aEntry, bool aNew, nsIApplicationCache* aAppCache,
      nsresult aResult);
  [[nodiscard]] nsresult OnNormalCacheEntryAvailable(nsICacheEntry* aEntry,
                                                     bool aNew,
                                                     nsresult aResult);
  [[nodiscard]] nsresult OpenOfflineCacheEntryForWriting();
  [[nodiscard]] nsresult OnOfflineCacheEntryForWritingAvailable(
      nsICacheEntry* aEntry, nsIApplicationCache* aAppCache, nsresult aResult);
  [[nodiscard]] nsresult OnCacheEntryAvailableInternal(
      nsICacheEntry* entry, bool aNew, nsIApplicationCache* aAppCache,
      nsresult status);
  [[nodiscard]] nsresult GenerateCacheKey(uint32_t postID, nsACString& key);
  [[nodiscard]] nsresult UpdateExpirationTime();
  [[nodiscard]] nsresult CheckPartial(nsICacheEntry* aEntry, int64_t* aSize,
                                      int64_t* aContentLength);
  bool ShouldUpdateOfflineCacheEntry();
  [[nodiscard]] nsresult ReadFromCache(bool alreadyMarkedValid);
  void CloseCacheEntry(bool doomOnFailure);
  void CloseOfflineCacheEntry();
  [[nodiscard]] nsresult InitCacheEntry();
  void UpdateInhibitPersistentCachingFlag();
  [[nodiscard]] nsresult InitOfflineCacheEntry();
  [[nodiscard]] nsresult AddCacheEntryHeaders(nsICacheEntry* entry);
  [[nodiscard]] nsresult FinalizeCacheEntry();
  [[nodiscard]] nsresult InstallCacheListener(int64_t offset = 0);
  [[nodiscard]] nsresult InstallOfflineCacheListener(int64_t offset = 0);
  void MaybeInvalidateCacheEntryForSubsequentGet();
  void AsyncOnExamineCachedResponse();

  // Handle the bogus Content-Encoding Apache sometimes sends
  void ClearBogusContentEncodingIfNeeded();

  // byte range request specific methods
  [[nodiscard]] nsresult ProcessPartialContent(
      const std::function<nsresult(nsHttpChannel*, nsresult)>&
          aContinueProcessResponseFunc);
  [[nodiscard]] nsresult ContinueProcessResponseAfterPartialContent(
      nsresult aRv);
  [[nodiscard]] nsresult OnDoneReadingPartialCacheEntry(bool* streamDone);

  [[nodiscard]] nsresult DoAuthRetry(
      HttpTransactionShell* aTransWithStickyConn,
      const std::function<nsresult(nsHttpChannel*, nsresult)>&
          aContinueOnStopRequestFunc);
  [[nodiscard]] nsresult ContinueDoAuthRetry(
      HttpTransactionShell* aTransWithStickyConn,
      const std::function<nsresult(nsHttpChannel*, nsresult)>&
          aContinueOnStopRequestFunc);
  [[nodiscard]] nsresult DoConnect(
      HttpTransactionShell* aTransWithStickyConn = nullptr);
  [[nodiscard]] nsresult DoConnectActual(
      HttpTransactionShell* aTransWithStickyConn);
  [[nodiscard]] nsresult ContinueOnStopRequestAfterAuthRetry(
      nsresult aStatus, bool aAuthRetry, bool aIsFromNet, bool aContentComplete,
      HttpTransactionShell* aTransWithStickyConn);
  [[nodiscard]] nsresult ContinueOnStopRequest(nsresult status, bool aIsFromNet,
                                               bool aContentComplete);

  void HandleAsyncRedirectChannelToHttps();
  [[nodiscard]] nsresult StartRedirectChannelToHttps();
  [[nodiscard]] nsresult ContinueAsyncRedirectChannelToURI(nsresult rv);
  [[nodiscard]] nsresult OpenRedirectChannel(nsresult rv);

  HttpTrafficCategory CreateTrafficCategory();

  /**
   * A function that takes care of reading STS and PKP headers and enforcing
   * STS and PKP load rules. After a secure channel is erected, STS and PKP
   * requires the channel to be trusted or any STS or PKP header data on
   * the channel is ignored. This is called from ProcessResponse.
   */
  [[nodiscard]] nsresult ProcessSecurityHeaders();

  /**
   * Taking care of the Content-Signature header and fail the channel if
   * the signature verification fails or is required but the header is not
   * present.
   * This sets mListener to ContentVerifier, which buffers the entire response
   * before verifying the Content-Signature header. If the verification is
   * successful, the load proceeds as usual. If the verification fails, a
   * NS_ERROR_INVALID_SIGNATURE is thrown and a fallback loaded in nsDocShell
   */
  [[nodiscard]] nsresult ProcessContentSignatureHeader(
      nsHttpResponseHead* aResponseHead);

  /**
   * A function that will, if the feature is enabled, send security reports.
   */
  void ProcessSecurityReport(nsresult status);

  /**
   * A function to process a single security header (STS or PKP), assumes
   * some basic sanity checks have been applied to the channel. Called
   * from ProcessSecurityHeaders.
   */
  [[nodiscard]] nsresult ProcessSingleSecurityHeader(
      uint32_t aType, nsITransportSecurityInfo* aSecInfo, uint32_t aFlags);

  void InvalidateCacheEntryForLocation(const char* location);
  void AssembleCacheKey(const char* spec, uint32_t postID, nsACString& key);
  [[nodiscard]] nsresult CreateNewURI(const char* loc, nsIURI** newURI);
  void DoInvalidateCacheEntry(nsIURI* aURI);

  // Ref RFC2616 13.10: "invalidation... MUST only be performed if
  // the host part is the same as in the Request-URI"
  inline bool HostPartIsTheSame(nsIURI* uri) {
    nsAutoCString tmpHost1, tmpHost2;
    return (NS_SUCCEEDED(mURI->GetAsciiHost(tmpHost1)) &&
            NS_SUCCEEDED(uri->GetAsciiHost(tmpHost2)) &&
            (tmpHost1 == tmpHost2));
  }

  inline static bool DoNotRender3xxBody(nsresult rv) {
    return rv == NS_ERROR_REDIRECT_LOOP || rv == NS_ERROR_CORRUPTED_CONTENT ||
           rv == NS_ERROR_UNKNOWN_PROTOCOL || rv == NS_ERROR_MALFORMED_URI ||
           rv == NS_ERROR_PORT_ACCESS_NOT_ALLOWED;
  }

  // Report net vs cache time telemetry
  void ReportNetVSCacheTelemetry();
  int64_t ComputeTelemetryBucketNumber(int64_t difftime_ms);

  // Report telemetry and stats to about:networking
  void ReportRcwnStats(bool isFromNet);

  // Create a aggregate set of the current notification callbacks
  // and ensure the transaction is updated to use it.
  void UpdateAggregateCallbacks();

  static bool HasQueryString(nsHttpRequestHead::ParsedMethodType method,
                             nsIURI* uri);
  bool ResponseWouldVary(nsICacheEntry* entry);
  bool IsResumable(int64_t partialLen, int64_t contentLength,
                   bool ignoreMissingPartialLen = false) const;
  [[nodiscard]] nsresult MaybeSetupByteRangeRequest(
      int64_t partialLen, int64_t contentLength,
      bool ignoreMissingPartialLen = false);
  [[nodiscard]] nsresult SetupByteRangeRequest(int64_t partialLen);
  void UntieByteRangeRequest();
  void UntieValidationRequest();
  [[nodiscard]] nsresult OpenCacheInputStream(nsICacheEntry* cacheEntry,
                                              bool startBuffering,
                                              bool checkingAppCacheEntry);

  void SetPushedStreamTransactionAndId(
      HttpTransactionShell* aTransWithPushedStream, uint32_t aPushedStreamId);

  void MaybeWarnAboutAppCache();

  void SetOriginHeader();
  void SetDoNotTrack();

  bool IsIsolated();

  const nsCString& GetTopWindowOrigin();

  already_AddRefed<nsChannelClassifier> GetOrCreateChannelClassifier();

  // Start an internal redirect to a new InterceptedHttpChannel which will
  // resolve in firing a ServiceWorker FetchEvent.
  [[nodiscard]] nsresult RedirectToInterceptedChannel();

  // Determines and sets content type in the cache entry. It's called when
  // writing a new entry. The content type is used in cache internally only.
  void SetCachedContentType();

  // This function updates all the fields used by anti-tracking when a channel
  // is opened. We have to do this in the parent to access cross-origin info
  // that is not exposed to child processes.
  void UpdateAntiTrackingInfo();

 private:
  // this section is for main-thread-only object
  // all the references need to be proxy released on main thread.
  nsCOMPtr<nsIApplicationCache> mApplicationCacheForWrite;
  // auth specific data
  nsCOMPtr<nsIHttpChannelAuthProvider> mAuthProvider;
  nsCOMPtr<nsIURI> mRedirectURI;
  nsCOMPtr<nsIChannel> mRedirectChannel;
  nsCOMPtr<nsIChannel> mPreflightChannel;

  // nsChannelClassifier checks this channel's URI against
  // the URI classifier service.
  // nsChannelClassifier will be invoked twice in InitLocalBlockList() and
  // BeginConnect(), so save the nsChannelClassifier here to keep the
  // state of whether tracking protection is enabled or not.
  RefPtr<nsChannelClassifier> mChannelClassifier;

  // Proxy release all members above on main thread.
  void ReleaseMainThreadOnlyReferences();

  // Called after the channel is made aware of its tracking status in order
  // to readjust the referrer if needed according to the referrer default
  // policy preferences.
  void ReEvaluateReferrerAfterTrackingStatusIsKnown();

  // Create a dummy channel for the same principal, out of the load group
  // just to revalidate the cache entry.  We don't care if this fails.
  // This method can be called on any thread, and creates an idle task
  // to perform the revalidation with delay.
  void PerformBackgroundCacheRevalidation();
  // This method can only be called on the main thread.
  void PerformBackgroundCacheRevalidationNow();

 private:
  nsCOMPtr<nsICancelable> mProxyRequest;

  nsCOMPtr<nsIRequest> mTransactionPump;
  RefPtr<HttpTransactionShell> mTransaction;

  uint64_t mLogicalOffset;

  // cache specific data
  nsCOMPtr<nsICacheEntry> mCacheEntry;
  // This will be set during OnStopRequest() before calling CloseCacheEntry(),
  // but only if the listener wants to use alt-data (signaled by
  // HttpBaseChannel::mPreferredCachedAltDataType being not empty)
  // Needed because calling openAlternativeOutputStream needs a reference
  // to the cache entry.
  nsCOMPtr<nsICacheEntry> mAltDataCacheEntry;

  nsCOMPtr<nsIURI> mCacheEntryURI;
  nsCString mCacheIdExtension;

  // We must close mCacheInputStream explicitly to avoid leaks.
  AutoClose<nsIInputStream> mCacheInputStream;
  RefPtr<nsInputStreamPump> mCachePump;
  UniquePtr<nsHttpResponseHead> mCachedResponseHead;
  nsCOMPtr<nsISupports> mCachedSecurityInfo;
  uint32_t mPostID;
  uint32_t mRequestTime;

  nsCOMPtr<nsICacheEntry> mOfflineCacheEntry;
  uint32_t mOfflineCacheLastModifiedTime;

  mozilla::TimeStamp mOnStartRequestTimestamp;
  // Timestamp of the time the channel was suspended.
  mozilla::TimeStamp mSuspendTimestamp;
  mozilla::TimeStamp mOnCacheEntryCheckTimestamp;
#ifdef MOZ_GECKO_PROFILER
  // For the profiler markers
  mozilla::TimeStamp mLastStatusReported;
#endif
  // Total time the channel spent suspended. This value is reported to
  // telemetry in nsHttpChannel::OnStartRequest().
  uint32_t mSuspendTotalTime;

  // If the channel is associated with a cache, and the URI matched
  // a fallback namespace, this will hold the key for the fallback
  // cache entry.
  nsCString mFallbackKey;

  friend class AutoRedirectVetoNotifier;
  friend class HttpAsyncAborter<nsHttpChannel>;

  uint32_t mRedirectType;

  static const uint32_t WAIT_FOR_CACHE_ENTRY = 1;
  static const uint32_t WAIT_FOR_OFFLINE_CACHE_ENTRY = 2;

  bool mCacheOpenWithPriority;
  uint32_t mCacheQueueSizeWhenOpen;

  Atomic<bool, Relaxed> mCachedContentIsValid;

  // state flags
  uint32_t mCachedContentIsPartial : 1;
  uint32_t mCacheOnlyMetadata : 1;
  uint32_t mTransactionReplaced : 1;
  uint32_t mAuthRetryPending : 1;
  uint32_t mProxyAuthPending : 1;
  // Set if before the first authentication attempt a custom authorization
  // header has been set on the channel.  This will make that custom header
  // go to the server instead of any cached credentials.
  uint32_t mCustomAuthHeader : 1;
  uint32_t mResuming : 1;
  uint32_t mInitedCacheEntry : 1;
  // True if we are loading a fallback cache entry from the
  // application cache.
  uint32_t mFallbackChannel : 1;
  // True if consumer added its own If-None-Match or If-Modified-Since
  // headers. In such a case we must not override them in the cache code
  // and also we want to pass possible 304 code response through.
  uint32_t mCustomConditionalRequest : 1;
  uint32_t mFallingBack : 1;
  uint32_t mWaitingForRedirectCallback : 1;
  // True if mRequestTime has been set. In such a case it is safe to update
  // the cache entry's expiration time. Otherwise, it is not(see bug 567360).
  uint32_t mRequestTimeInitialized : 1;
  uint32_t mCacheEntryIsReadOnly : 1;
  uint32_t mCacheEntryIsWriteOnly : 1;
  // see WAIT_FOR_* constants above
  uint32_t mCacheEntriesToWaitFor : 2;
  // whether cache entry data write was in progress during cache entry check
  // when true, after we finish read from cache we must check all data
  // had been loaded from cache. If not, then an error has to be propagated
  // to the consumer.
  uint32_t mConcurrentCacheAccess : 1;
  // whether the request is setup be byte-range
  uint32_t mIsPartialRequest : 1;
  // true iff there is AutoRedirectVetoNotifier on the stack
  uint32_t mHasAutoRedirectVetoNotifier : 1;
  // consumers set this to true to use cache pinning, this has effect
  // only when the channel is in an app context
  uint32_t mPinCacheContent : 1;
  // True if CORS preflight has been performed
  uint32_t mIsCorsPreflightDone : 1;

  // if the http transaction was performed (i.e. not cached) and
  // the result in OnStopRequest was known to be correctly delimited
  // by chunking, content-length, or h2 end-stream framing
  uint32_t mStronglyFramed : 1;

  // true if an HTTP transaction is created for the socket thread
  uint32_t mUsedNetwork : 1;

  // the next authentication request can be sent on a whole new connection
  uint32_t mAuthConnectionRestartable : 1;

  // True if the channel classifier has marked the channel to be cancelled due
  // to the safe-browsing classifier rules, but the asynchronous cancellation
  // process hasn't finished yet.
  uint32_t mChannelClassifierCancellationPending : 1;

  // True only when we are between Resume and async fire of mCallOnResume.
  // Used to suspend any newly created pumps in mCallOnResume handler.
  uint32_t mAsyncResumePending : 1;

  // True only when we have checked whether this channel has been isolated for
  // anti-tracking purposes.
  uint32_t mHasBeenIsolatedChecked : 1;
  // True only when we have determined this channel should be isolated for
  // anti-tracking purposes.  Can never ben true unless mHasBeenIsolatedChecked
  // is true.
  uint32_t mIsIsolated : 1;

  // True only when we have computed the value of the top window origin.
  uint32_t mTopWindowOriginComputed : 1;

  // True if the data has already been sent from the socket process to the
  // content process.
  uint32_t mDataAlreadySent : 1;

  // The origin of the top window, only valid when mTopWindowOriginComputed is
  // true.
  nsCString mTopWindowOrigin;

  nsTArray<nsContinueRedirectionFunc> mRedirectFuncStack;

  // Needed for accurate DNS timing
  RefPtr<nsDNSPrefetch> mDNSPrefetch;

  uint32_t mPushedStreamId;
  RefPtr<HttpTransactionShell> mTransWithPushedStream;

  // True if the channel's principal was found on a phishing, malware, or
  // tracking (if tracking protection is enabled) blocklist
  bool mLocalBlocklist;

  [[nodiscard]] nsresult WaitForRedirectCallback();
  void PushRedirectAsyncFunc(nsContinueRedirectionFunc func);
  void PopRedirectAsyncFunc(nsContinueRedirectionFunc func);

  // If this resource is eligible for tailing based on class-of-service flags
  // and load flags.  We don't tail Leaders/Unblocked/UrgentStart and top-level
  // loads.
  bool EligibleForTailing();

  // Called exclusively only from AsyncOpen or after all classification
  // callbacks. If this channel is 1) Tail, 2) assigned a request context, 3)
  // the context is still in the tail-blocked phase, then the method will queue
  // this channel. OnTailUnblock will be called after the context is
  // tail-unblocked or canceled.
  bool WaitingForTailUnblock();

  // A function we trigger when untail callback is triggered by our request
  // context in case this channel was tail-blocked.
  nsresult (nsHttpChannel::*mOnTailUnblock)();
  // Called on untail when tailed during AsyncOpen execution.
  nsresult AsyncOpenOnTailUnblock();
  // Called on untail when tailed because of being a tracking resource.
  nsresult ConnectOnTailUnblock();

  nsCString mUsername;

  // If non-null, warnings should be reported to this object.
  RefPtr<HttpChannelSecurityWarningReporter> mWarningReporter;

  RefPtr<ADivertableParentChannel> mParentChannel;

  // True if the channel is reading from cache.
  Atomic<bool> mIsReadingFromCache;

  // These next members are only used in unit tests to delay the call to
  // cache->AsyncOpenURI in order to race the cache with the network.
  nsCOMPtr<nsITimer> mCacheOpenTimer;
  std::function<void(nsHttpChannel*)> mCacheOpenFunc;
  uint32_t mCacheOpenDelay = 0;

  // We need to remember which is the source of the response we are using.
  enum ResponseSource {
    RESPONSE_PENDING = 0,      // response is pending
    RESPONSE_FROM_CACHE = 1,   // response coming from cache. no network.
    RESPONSE_FROM_NETWORK = 2  // response coming from the network
  };
  Atomic<ResponseSource, Relaxed> mFirstResponseSource;

  // Determines if it's possible and advisable to race the network request
  // with the cache fetch, and proceeds to do so.
  nsresult MaybeRaceCacheWithNetwork();

  // Creates a new cache entry when network wins the race to ensure we have
  // the latest version of the resource in the cache. Otherwise we might return
  // an old content when navigating back in history.
  void MaybeCreateCacheEntryWhenRCWN();

  nsresult TriggerNetworkWithDelay(uint32_t aDelay);
  nsresult TriggerNetwork();
  void CancelNetworkRequest(nsresult aStatus);
  // Timer used to delay the network request, or to trigger the network
  // request if retrieving the cache entry takes too long.
  nsCOMPtr<nsITimer> mNetworkTriggerTimer;
  // Is true if the network request has been triggered.
  bool mNetworkTriggered = false;
  bool mWaitingForProxy = false;
  bool mStaleRevalidation = false;
  // Will be true if the onCacheEntryAvailable callback is not called by the
  // time we send the network request
  Atomic<bool> mRaceCacheWithNetwork;
  uint32_t mRaceDelay;
  // If true then OnCacheEntryAvailable should ignore the entry, because
  // SetupTransaction removed conditional headers and decisions made in
  // OnCacheEntryCheck are no longer valid.
  bool mIgnoreCacheEntry;
  // Lock preventing SetupTransaction/MaybeCreateCacheEntryWhenRCWN and
  // OnCacheEntryCheck being called at the same time.
  mozilla::Mutex mRCWNLock;

  TimeStamp mNavigationStartTimeStamp;

  // Promise that blocks connection creation when we want to resolve the origin
  // host name to be able to give the configured proxy only the resolved IP
  // to not leak names.
  MozPromiseHolder<DNSPromise> mDNSBlockingPromise;
  // When we hit DoConnect before the resolution is done, Then() will be set
  // here to resume DoConnect.
  RefPtr<DNSPromise> mDNSBlockingThenable;

  // We update the value of mProxyConnectResponseCode when OnStartRequest is
  // called and reset the value when we switch to another failover proxy.
  int32_t mProxyConnectResponseCode;

 protected:
  virtual void DoNotifyListenerCleanup() override;

  // Override ReleaseListeners() because mChannelClassifier only exists
  // in nsHttpChannel and it will be released in ReleaseListeners().
  virtual void ReleaseListeners() override;

  virtual void DoAsyncAbort(nsresult aStatus) override;

 private:  // cache telemetry
  bool mDidReval;
};

NS_DEFINE_STATIC_IID_ACCESSOR(nsHttpChannel, NS_HTTPCHANNEL_IID)
}  // namespace net
}  // namespace mozilla

inline nsISupports* ToSupports(mozilla::net::nsHttpChannel* aChannel) {
  return static_cast<nsIHttpChannel*>(aChannel);
}

#endif  // nsHttpChannel_h__
