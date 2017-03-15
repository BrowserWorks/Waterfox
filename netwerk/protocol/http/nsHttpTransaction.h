/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef nsHttpTransaction_h__
#define nsHttpTransaction_h__

#include "nsHttp.h"
#include "nsAHttpTransaction.h"
#include "nsAHttpConnection.h"
#include "EventTokenBucket.h"
#include "nsCOMPtr.h"
#include "nsThreadUtils.h"
#include "nsIInterfaceRequestor.h"
#include "TimingStruct.h"
#include "Http2Push.h"
#include "mozilla/net/DNS.h"
#include "ARefBase.h"
#include "AlternateServices.h"

#ifdef MOZ_WIDGET_GONK
#include "nsINetworkInterface.h"
#include "nsProxyRelease.h"
#endif

//-----------------------------------------------------------------------------

class nsIHttpActivityObserver;
class nsIEventTarget;
class nsIInputStream;
class nsIOutputStream;
class nsIRequestContext;

namespace mozilla { namespace net {

class nsHttpChunkedDecoder;
class nsHttpRequestHead;
class nsHttpResponseHead;

//-----------------------------------------------------------------------------
// nsHttpTransaction represents a single HTTP transaction.  It is thread-safe,
// intended to run on the socket thread.
//-----------------------------------------------------------------------------

class nsHttpTransaction final : public nsAHttpTransaction
                              , public ATokenBucketEvent
                              , public nsIInputStreamCallback
                              , public nsIOutputStreamCallback
                              , public ARefBase
{
public:
    NS_DECL_THREADSAFE_ISUPPORTS
    NS_DECL_NSAHTTPTRANSACTION
    NS_DECL_NSIINPUTSTREAMCALLBACK
    NS_DECL_NSIOUTPUTSTREAMCALLBACK

    nsHttpTransaction();

    //
    // called to initialize the transaction
    //
    // @param caps
    //        the transaction capabilities (see nsHttp.h)
    // @param connInfo
    //        the connection type for this transaction.
    // @param reqHeaders
    //        the request header struct
    // @param reqBody
    //        the request body (POST or PUT data stream)
    // @param reqBodyIncludesHeaders
    //        fun stuff to support NPAPI plugins.
    // @param target
    //        the dispatch target were notifications should be sent.
    // @param callbacks
    //        the notification callbacks to be given to PSM.
    // @param responseBody
    //        the input stream that will contain the response data.  async
    //        wait on this input stream for data.  on first notification,
    //        headers should be available (check transaction status).
    //
    nsresult Init(uint32_t               caps,
                  nsHttpConnectionInfo  *connInfo,
                  nsHttpRequestHead     *reqHeaders,
                  nsIInputStream        *reqBody,
                  bool                   reqBodyIncludesHeaders,
                  nsIEventTarget        *consumerTarget,
                  nsIInterfaceRequestor *callbacks,
                  nsITransportEventSink *eventsink,
                  nsIAsyncInputStream  **responseBody);

    // attributes
    nsHttpResponseHead    *ResponseHead()   { return mHaveAllHeaders ? mResponseHead : nullptr; }
    nsISupports           *SecurityInfo()   { return mSecurityInfo; }

    nsIEventTarget        *ConsumerTarget() { return mConsumerTarget; }
    nsISupports           *HttpChannel()    { return mChannel; }

    void SetSecurityCallbacks(nsIInterfaceRequestor* aCallbacks);

    // Called to take ownership of the response headers; the transaction
    // will drop any reference to the response headers after this call.
    nsHttpResponseHead *TakeResponseHead();

    // Provides a thread safe reference of the connection
    // nsHttpTransaction::Connection should only be used on the socket thread
    already_AddRefed<nsAHttpConnection> GetConnectionReference();

    // Called to set/find out if the transaction generated a complete response.
    bool ResponseIsComplete() { return mResponseIsComplete; }
    void SetResponseIsComplete() { mResponseIsComplete = true; }

    bool      ProxyConnectFailed() { return mProxyConnectFailed; }

    void EnableKeepAlive() { mCaps |= NS_HTTP_ALLOW_KEEPALIVE; }
    void MakeSticky() { mCaps |= NS_HTTP_STICKY_CONNECTION; }

    // SetPriority() may only be used by the connection manager.
    void    SetPriority(int32_t priority) { mPriority = priority; }
    int32_t    Priority()                 { return mPriority; }

    enum Classifier Classification() { return mClassification; }

    void PrintDiagnostics(nsCString &log);

    // Sets mPendingTime to the current time stamp or to a null time stamp (if now is false)
    void SetPendingTime(bool now = true) { mPendingTime = now ? TimeStamp::Now() : TimeStamp(); }
    const TimeStamp GetPendingTime() { return mPendingTime; }
    bool UsesPipelining() const { return mCaps & NS_HTTP_ALLOW_PIPELINING; }

    // overload of nsAHttpTransaction::RequestContext()
    nsIRequestContext *RequestContext() override { return mRequestContext.get(); }
    void SetRequestContext(nsIRequestContext *aRequestContext);
    void DispatchedAsBlocking();
    void RemoveDispatchedAsBlocking();

    nsHttpTransaction *QueryHttpTransaction() override { return this; }

    Http2PushedStream *GetPushedStream() { return mPushedStream; }
    Http2PushedStream *TakePushedStream()
    {
        Http2PushedStream *r = mPushedStream;
        mPushedStream = nullptr;
        return r;
    }
    void SetPushedStream(Http2PushedStream *push) { mPushedStream = push; }
    uint32_t InitialRwin() const { return mInitialRwin; };
    bool ChannelPipeFull() { return mWaitingOnPipeOut; }

    // Locked methods to get and set timing info
    const TimingStruct Timings();
    void SetDomainLookupStart(mozilla::TimeStamp timeStamp, bool onlyIfNull = false);
    void SetDomainLookupEnd(mozilla::TimeStamp timeStamp, bool onlyIfNull = false);
    void SetConnectStart(mozilla::TimeStamp timeStamp, bool onlyIfNull = false);
    void SetConnectEnd(mozilla::TimeStamp timeStamp, bool onlyIfNull = false);
    void SetRequestStart(mozilla::TimeStamp timeStamp, bool onlyIfNull = false);
    void SetResponseStart(mozilla::TimeStamp timeStamp, bool onlyIfNull = false);
    void SetResponseEnd(mozilla::TimeStamp timeStamp, bool onlyIfNull = false);

    mozilla::TimeStamp GetDomainLookupStart();
    mozilla::TimeStamp GetDomainLookupEnd();
    mozilla::TimeStamp GetConnectStart();
    mozilla::TimeStamp GetConnectEnd();
    mozilla::TimeStamp GetRequestStart();
    mozilla::TimeStamp GetResponseStart();
    mozilla::TimeStamp GetResponseEnd();

    int64_t GetTransferSize() { return mTransferSize; }

    bool Do0RTT() override;
    nsresult Finish0RTT(bool aRestart) override;
private:
    friend class DeleteHttpTransaction;
    virtual ~nsHttpTransaction();

    nsresult Restart();
    nsresult RestartInProgress();
    char    *LocateHttpStart(char *buf, uint32_t len,
                             bool aAllowPartialMatch);
    nsresult ParseLine(nsACString &line);
    nsresult ParseLineSegment(char *seg, uint32_t len);
    nsresult ParseHead(char *, uint32_t count, uint32_t *countRead);
    nsresult HandleContentStart();
    nsresult HandleContent(char *, uint32_t count, uint32_t *contentRead, uint32_t *contentRemaining);
    nsresult ProcessData(char *, uint32_t, uint32_t *);
    void     DeleteSelfOnConsumerThread();
    void     ReleaseBlockingTransaction();

    Classifier Classify();
    void       CancelPipeline(uint32_t reason);

    static nsresult ReadRequestSegment(nsIInputStream *, void *, const char *,
                                       uint32_t, uint32_t, uint32_t *);
    static nsresult WritePipeSegment(nsIOutputStream *, void *, char *,
                                     uint32_t, uint32_t, uint32_t *);

    bool TimingEnabled() const { return mCaps & NS_HTTP_TIMING_ENABLED; }

    bool ResponseTimeoutEnabled() const final;

    void DisableSpdy() override;
    void ReuseConnectionOnRestartOK(bool reuseOk) override { mReuseOnRestart = reuseOk; }

    // Called right after we parsed the response head.  Checks for connection based
    // authentication schemes in reponse headers for WWW and Proxy authentication.
    // If such is found in any of them, NS_HTTP_STICKY_CONNECTION is set in mCaps.
    // We need the sticky flag be set early to keep the connection from very start
    // of the authentication process.
    void CheckForStickyAuthScheme();
    void CheckForStickyAuthSchemeAt(nsHttpAtom const& header);

private:
    class UpdateSecurityCallbacks : public Runnable
    {
      public:
        UpdateSecurityCallbacks(nsHttpTransaction* aTrans,
                                nsIInterfaceRequestor* aCallbacks)
        : mTrans(aTrans), mCallbacks(aCallbacks) {}

        NS_IMETHOD Run() override
        {
            if (mTrans->mConnection)
                mTrans->mConnection->SetSecurityCallbacks(mCallbacks);
            return NS_OK;
        }
      private:
        RefPtr<nsHttpTransaction> mTrans;
        nsCOMPtr<nsIInterfaceRequestor> mCallbacks;
    };

    Mutex mLock;

    nsCOMPtr<nsIInterfaceRequestor> mCallbacks;
    nsCOMPtr<nsITransportEventSink> mTransportSink;
    nsCOMPtr<nsIEventTarget>        mConsumerTarget;
    nsCOMPtr<nsISupports>           mSecurityInfo;
    nsCOMPtr<nsIAsyncInputStream>   mPipeIn;
    nsCOMPtr<nsIAsyncOutputStream>  mPipeOut;
    nsCOMPtr<nsIRequestContext>     mRequestContext;

    nsCOMPtr<nsISupports>             mChannel;
    nsCOMPtr<nsIHttpActivityObserver> mActivityDistributor;

    nsCString                       mReqHeaderBuf;    // flattened request headers
    nsCOMPtr<nsIInputStream>        mRequestStream;
    int64_t                         mRequestSize;

    RefPtr<nsAHttpConnection>     mConnection;
    RefPtr<nsHttpConnectionInfo>  mConnInfo;
    nsHttpRequestHead              *mRequestHead;     // weak ref
    nsHttpResponseHead             *mResponseHead;    // owning pointer

    nsAHttpSegmentReader           *mReader;
    nsAHttpSegmentWriter           *mWriter;

    nsCString                       mLineBuf;         // may contain a partial line

    int64_t                         mContentLength;   // equals -1 if unknown
    int64_t                         mContentRead;     // count of consumed content bytes
    Atomic<int64_t, ReleaseAcquire> mTransferSize; // count of received bytes

    // After a 304/204 or other "no-content" style response we will skip over
    // up to MAX_INVALID_RESPONSE_BODY_SZ bytes when looking for the next
    // response header to deal with servers that actually sent a response
    // body where they should not have. This member tracks how many bytes have
    // so far been skipped.
    uint32_t                        mInvalidResponseBytesRead;

    Http2PushedStream               *mPushedStream;
    uint32_t                        mInitialRwin;

    nsHttpChunkedDecoder            *mChunkedDecoder;

    TimingStruct                    mTimings;

    nsresult                        mStatus;

    int16_t                         mPriority;

    uint16_t                        mRestartCount;        // the number of times this transaction has been restarted
    uint32_t                        mCaps;
    enum Classifier                 mClassification;
    int32_t                         mPipelinePosition;
    int64_t                         mMaxPipelineObjectSize;

    nsHttpVersion                   mHttpVersion;
    uint16_t                        mHttpResponseCode;

    uint32_t                        mCurrentHttpResponseHeaderSize;

    // mCapsToClear holds flags that should be cleared in mCaps, e.g. unset
    // NS_HTTP_REFRESH_DNS when DNS refresh request has completed to avoid
    // redundant requests on the network. The member itself is atomic, but
    // access to it from the networking thread may happen either before or
    // after the main thread modifies it. To deal with raciness, only unsetting
    // bitfields should be allowed: 'lost races' will thus err on the
    // conservative side, e.g. by going ahead with a 2nd DNS refresh.
    Atomic<uint32_t>                mCapsToClear;
    Atomic<bool, ReleaseAcquire>    mResponseIsComplete;

    // state flags, all logically boolean, but not packed together into a
    // bitfield so as to avoid bitfield-induced races.  See bug 560579.
    bool                            mClosed;
    bool                            mConnected;
    bool                            mHaveStatusLine;
    bool                            mHaveAllHeaders;
    bool                            mTransactionDone;
    bool                            mDidContentStart;
    bool                            mNoContent; // expecting an empty entity body
    bool                            mSentData;
    bool                            mReceivedData;
    bool                            mStatusEventPending;
    bool                            mHasRequestBody;
    bool                            mProxyConnectFailed;
    bool                            mHttpResponseMatched;
    bool                            mPreserveStream;
    bool                            mDispatchedAsBlocking;
    bool                            mResponseTimeoutEnabled;
    bool                            mForceRestart;
    bool                            mReuseOnRestart;
    bool                            mContentDecoding;
    bool                            mContentDecodingCheck;
    bool                            mDeferredSendProgress;
    bool                            mWaitingOnPipeOut;

    // mClosed           := transaction has been explicitly closed
    // mTransactionDone  := transaction ran to completion or was interrupted
    // mResponseComplete := transaction ran to completion

    // For Restart-In-Progress Functionality
    bool                            mReportedStart;
    bool                            mReportedResponseHeader;

    // protected by nsHttp::GetLock()
    nsHttpResponseHead             *mForTakeResponseHead;
    bool                            mResponseHeadTaken;

    // The time when the transaction was submitted to the Connection Manager
    TimeStamp                       mPendingTime;

    class RestartVerifier
    {

        // When a idemptotent transaction has received part of its response body
        // and incurs an error it can be restarted. To do this we mark the place
        // where we stopped feeding the body to the consumer and start the
        // network call over again. If everything we track (headers, length, etc..)
        // matches up to the place where we left off then the consumer starts being
        // fed data again with the new information. This can be done N times up
        // to the normal restart (i.e. with no response info) limit.

    public:
        RestartVerifier()
            : mContentLength(-1)
            , mAlreadyProcessed(0)
            , mToReadBeforeRestart(0)
            , mSetup(false)
        {}
        ~RestartVerifier() {}

        void Set(int64_t contentLength, nsHttpResponseHead *head);
        bool Verify(int64_t contentLength, nsHttpResponseHead *head);
        bool IsDiscardingContent() { return mToReadBeforeRestart != 0; }
        bool IsSetup() { return mSetup; }
        int64_t AlreadyProcessed() { return mAlreadyProcessed; }
        void SetAlreadyProcessed(int64_t val) {
            mAlreadyProcessed = val;
            mToReadBeforeRestart = val;
        }
        int64_t ToReadBeforeRestart() { return mToReadBeforeRestart; }
        void HaveReadBeforeRestart(uint32_t amt)
        {
            MOZ_ASSERT(amt <= mToReadBeforeRestart,
                       "too large of a HaveReadBeforeRestart deduction");
            mToReadBeforeRestart -= amt;
        }

    private:
        // This is the data from the first complete response header
        // used to make sure that all subsequent response headers match

        int64_t                         mContentLength;
        nsCString                       mETag;
        nsCString                       mLastModified;
        nsCString                       mContentRange;
        nsCString                       mContentEncoding;
        nsCString                       mTransferEncoding;

        // This is the amount of data that has been passed to the channel
        // from previous iterations of the transaction and must therefore
        // be skipped in the new one.
        int64_t                         mAlreadyProcessed;

        // The amount of data that must be discarded in the current iteration
        // (where iteration > 0) to reach the mAlreadyProcessed high water
        // mark.
        int64_t                         mToReadBeforeRestart;

        // true when ::Set has been called with a response header
        bool                            mSetup;
    } mRestartInProgressVerifier;

// For Rate Pacing via an EventTokenBucket
public:
    // called by the connection manager to run this transaction through the
    // token bucket. If the token bucket admits the transaction immediately it
    // returns true. The function is called repeatedly until it returns true.
    bool TryToRunPacedRequest();

    // ATokenBucketEvent pure virtual implementation. Called by the token bucket
    // when the transaction is ready to run. If this happens asynchrounously to
    // token bucket submission the transaction just posts an event that causes
    // the pending transaction queue to be rerun (and TryToRunPacedRequest() to
    // be run again.
    void OnTokenBucketAdmitted() override; // ATokenBucketEvent

    // CancelPacing() can be used to tell the token bucket to remove this
    // transaction from the list of pending transactions. This is used when a
    // transaction is believed to be HTTP/1 (and thus subject to rate pacing)
    // but later can be dispatched via spdy (not subject to rate pacing).
    void CancelPacing(nsresult reason);

private:
    bool mSubmittedRatePacing;
    bool mPassedRatePacing;
    bool mSynchronousRatePaceRequest;
    nsCOMPtr<nsICancelable> mTokenBucketCancel;

// These members are used for network per-app metering (bug 746073)
// Currently, they are only available on gonk.
    uint64_t                           mCountRecv;
    uint64_t                           mCountSent;
    uint32_t                           mAppId;
    bool                               mIsInIsolatedMozBrowser;
#ifdef MOZ_WIDGET_GONK
    nsMainThreadPtrHandle<nsINetworkInfo> mActiveNetworkInfo;
#endif
    nsresult                           SaveNetworkStats(bool);
    void                               CountRecvBytes(uint64_t recvBytes)
    {
        mCountRecv += recvBytes;
        SaveNetworkStats(false);
    }
    void                               CountSentBytes(uint64_t sentBytes)
    {
        mCountSent += sentBytes;
        SaveNetworkStats(false);
    }
public:
    void     SetClassOfService(uint32_t cos) { mClassOfService = cos; }
    uint32_t ClassOfService() { return mClassOfService; }
private:
    uint32_t mClassOfService;

public:
    // setting TunnelProvider to non-null means the transaction should only
    // be dispatched on a specific ConnectionInfo Hash Key (as opposed to a
    // generic wild card one). That means in the specific case of carrying this
    // transaction on an HTTP/2 tunnel it will only be dispatched onto an
    // existing tunnel instead of triggering creation of a new one.
    // The tunnel provider is used for ASpdySession::MaybeReTunnel() checks.

    void SetTunnelProvider(ASpdySession *provider) { mTunnelProvider = provider; }
    ASpdySession *TunnelProvider() { return mTunnelProvider; }
    nsIInterfaceRequestor *SecurityCallbacks() { return mCallbacks; }

private:
    RefPtr<ASpdySession> mTunnelProvider;

public:
    void SetTransactionObserver(TransactionObserver *arg) { mTransactionObserver = arg; }
private:
    RefPtr<TransactionObserver> mTransactionObserver;
public:
    void GetNetworkAddresses(NetAddr &self, NetAddr &peer);

private:
    NetAddr                         mSelfAddr;
    NetAddr                         mPeerAddr;

    bool                            m0RTTInProgress;
};

} // namespace net
} // namespace mozilla

#endif // nsHttpTransaction_h__
