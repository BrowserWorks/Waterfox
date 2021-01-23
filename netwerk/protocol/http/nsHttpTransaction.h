/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef nsHttpTransaction_h__
#define nsHttpTransaction_h__

#include "nsHttp.h"
#include "nsAHttpTransaction.h"
#include "HttpTransactionShell.h"
#include "nsAHttpConnection.h"
#include "EventTokenBucket.h"
#include "nsCOMPtr.h"
#include "nsThreadUtils.h"
#include "nsIInterfaceRequestor.h"
#include "TimingStruct.h"
#include "Http2Push.h"
#include "mozilla/net/DNS.h"
#include "mozilla/net/NeckoChannelParams.h"
#include "ARefBase.h"

//-----------------------------------------------------------------------------

class nsIHttpActivityObserver;
class nsIEventTarget;
class nsIInputStream;
class nsIOutputStream;
class nsIRequestContext;

namespace mozilla {
namespace net {

class nsHttpChunkedDecoder;
class nsHttpHeaderArray;
class nsHttpRequestHead;
class nsHttpResponseHead;
class NullHttpTransaction;
class SpdyConnectTransaction;

//-----------------------------------------------------------------------------
// nsHttpTransaction represents a single HTTP transaction.  It is thread-safe,
// intended to run on the socket thread.
//-----------------------------------------------------------------------------

class nsHttpTransaction final : public nsAHttpTransaction,
                                public HttpTransactionShell,
                                public ATokenBucketEvent,
                                public nsIInputStreamCallback,
                                public nsIOutputStreamCallback,
                                public ARefBase {
 public:
  NS_DECL_THREADSAFE_ISUPPORTS
  NS_DECL_NSAHTTPTRANSACTION
  NS_DECL_HTTPTRANSACTIONSHELL
  NS_DECL_NSIINPUTSTREAMCALLBACK
  NS_DECL_NSIOUTPUTSTREAMCALLBACK

  nsHttpTransaction();

  void OnActivated() override;

  // attributes
  nsHttpResponseHead* ResponseHead() {
    return mHaveAllHeaders ? mResponseHead : nullptr;
  }

  nsIEventTarget* ConsumerTarget() { return mConsumerTarget; }

  // Called to set/find out if the transaction generated a complete response.
  void SetResponseIsComplete() { mResponseIsComplete = true; }

  void EnableKeepAlive() { mCaps |= NS_HTTP_ALLOW_KEEPALIVE; }
  void MakeSticky() { mCaps |= NS_HTTP_STICKY_CONNECTION; }
  void MakeNonSticky() override { mCaps &= ~NS_HTTP_STICKY_CONNECTION; }

  // SetPriority() may only be used by the connection manager.
  void SetPriority(int32_t priority) { mPriority = priority; }
  int32_t Priority() { return mPriority; }

  void PrintDiagnostics(nsCString& log);

  // Sets mPendingTime to the current time stamp or to a null time stamp (if now
  // is false)
  void SetPendingTime(bool now = true) {
    mPendingTime = now ? TimeStamp::Now() : TimeStamp();
  }
  const TimeStamp GetPendingTime() { return mPendingTime; }

  // overload of nsAHttpTransaction::RequestContext()
  nsIRequestContext* RequestContext() override { return mRequestContext.get(); }
  void DispatchedAsBlocking();
  void RemoveDispatchedAsBlocking();

  void DisableSpdy() override;

  nsHttpTransaction* QueryHttpTransaction() override { return this; }

  already_AddRefed<Http2PushedStreamWrapper> GetPushedStream() {
    return do_AddRef(mPushedStream);
  }
  already_AddRefed<Http2PushedStreamWrapper> TakePushedStream() {
    return mPushedStream.forget();
  }

  uint32_t InitialRwin() const { return mInitialRwin; };
  bool ChannelPipeFull() { return mWaitingOnPipeOut; }

  // Locked methods to get and set timing info
  void BootstrapTimings(TimingStruct times);
  void SetConnectStart(mozilla::TimeStamp timeStamp, bool onlyIfNull = false);
  void SetConnectEnd(mozilla::TimeStamp timeStamp, bool onlyIfNull = false);
  void SetRequestStart(mozilla::TimeStamp timeStamp, bool onlyIfNull = false);
  void SetResponseStart(mozilla::TimeStamp timeStamp, bool onlyIfNull = false);
  void SetResponseEnd(mozilla::TimeStamp timeStamp, bool onlyIfNull = false);

  [[nodiscard]] bool Do0RTT() override;
  [[nodiscard]] nsresult Finish0RTT(bool aRestart,
                                    bool aAlpnChanged /* ignored */) override;

  // After Finish0RTT early data may have failed but the caller did not request
  // restart - this indicates that state for dev tools
  void Refused0RTT();

  [[nodiscard]] bool CanDo0RTT() override;
  [[nodiscard]] nsresult RestartOnFastOpenError() override;

  uint64_t TopLevelOuterContentWindowId() override {
    return mTopLevelOuterContentWindowId;
  }

  void SetFastOpenStatus(uint8_t aStatus) override;

  void SetHttpTrailers(nsCString& aTrailers);

  bool IsWebsocketUpgrade();
  void SetH2WSTransaction(SpdyConnectTransaction*);

  void OnProxyConnectComplete(int32_t aResponseCode) override;
  void SetFlat407Headers(const nsACString& aHeaders);

  // This is only called by Http2PushedStream::TryOnPush when a new pushed
  // stream is available. The newly added stream will be taken by another
  // transaction.
  void OnPush(Http2PushedStreamWrapper* aStream);

 private:
  friend class DeleteHttpTransaction;
  virtual ~nsHttpTransaction();

  [[nodiscard]] nsresult Restart();
  char* LocateHttpStart(char* buf, uint32_t len, bool aAllowPartialMatch);
  [[nodiscard]] nsresult ParseLine(nsACString& line);
  [[nodiscard]] nsresult ParseLineSegment(char* seg, uint32_t len);
  [[nodiscard]] nsresult ParseHead(char*, uint32_t count, uint32_t* countRead);
  [[nodiscard]] nsresult HandleContentStart();
  [[nodiscard]] nsresult HandleContent(char*, uint32_t count,
                                       uint32_t* contentRead,
                                       uint32_t* contentRemaining);
  [[nodiscard]] nsresult ProcessData(char*, uint32_t, uint32_t*);
  void DeleteSelfOnConsumerThread();
  void ReleaseBlockingTransaction();

  [[nodiscard]] static nsresult ReadRequestSegment(nsIInputStream*, void*,
                                                   const char*, uint32_t,
                                                   uint32_t, uint32_t*);
  [[nodiscard]] static nsresult WritePipeSegment(nsIOutputStream*, void*, char*,
                                                 uint32_t, uint32_t, uint32_t*);

  bool TimingEnabled() const { return mCaps & NS_HTTP_TIMING_ENABLED; }

  bool ResponseTimeoutEnabled() const final;

  void ReuseConnectionOnRestartOK(bool reuseOk) override {
    mReuseOnRestart = reuseOk;
  }

  // Called right after we parsed the response head.  Checks for connection
  // based authentication schemes in reponse headers for WWW and Proxy
  // authentication. If such is found in any of them, NS_HTTP_STICKY_CONNECTION
  // is set in mCaps. We need the sticky flag be set early to keep the
  // connection from very start of the authentication process.
  void CheckForStickyAuthScheme();
  void CheckForStickyAuthSchemeAt(nsHttpAtom const& header);

  // Called from WriteSegments.  Checks for conditions whether to throttle
  // reading the content.  When this returns true, WriteSegments returns
  // WOULD_BLOCK.
  bool ShouldThrottle();

  void NotifyTransactionObserver(nsresult reason);

  already_AddRefed<Http2PushedStreamWrapper> TakePushedStreamById(
      uint32_t aStreamId);

 private:
  class UpdateSecurityCallbacks : public Runnable {
   public:
    UpdateSecurityCallbacks(nsHttpTransaction* aTrans,
                            nsIInterfaceRequestor* aCallbacks)
        : Runnable("net::nsHttpTransaction::UpdateSecurityCallbacks"),
          mTrans(aTrans),
          mCallbacks(aCallbacks) {}

    NS_IMETHOD Run() override {
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
  nsCOMPtr<nsIEventTarget> mConsumerTarget;
  nsCOMPtr<nsISupports> mSecurityInfo;
  nsCOMPtr<nsIAsyncInputStream> mPipeIn;
  nsCOMPtr<nsIAsyncOutputStream> mPipeOut;
  nsCOMPtr<nsIRequestContext> mRequestContext;

  uint64_t mChannelId;
  nsCOMPtr<nsIHttpActivityObserver> mActivityDistributor;

  nsCString mReqHeaderBuf;  // flattened request headers
  nsCOMPtr<nsIInputStream> mRequestStream;
  int64_t mRequestSize;

  RefPtr<nsAHttpConnection> mConnection;
  RefPtr<nsHttpConnectionInfo> mConnInfo;
  nsHttpRequestHead* mRequestHead;    // weak ref
  nsHttpResponseHead* mResponseHead;  // owning pointer

  nsAHttpSegmentReader* mReader;
  nsAHttpSegmentWriter* mWriter;

  nsCString mLineBuf;  // may contain a partial line

  int64_t mContentLength;  // equals -1 if unknown
  int64_t mContentRead;    // count of consumed content bytes
  Atomic<int64_t, ReleaseAcquire> mTransferSize;  // count of received bytes

  // After a 304/204 or other "no-content" style response we will skip over
  // up to MAX_INVALID_RESPONSE_BODY_SZ bytes when looking for the next
  // response header to deal with servers that actually sent a response
  // body where they should not have. This member tracks how many bytes have
  // so far been skipped.
  uint32_t mInvalidResponseBytesRead;

  RefPtr<Http2PushedStreamWrapper> mPushedStream;
  uint32_t mInitialRwin;

  nsHttpChunkedDecoder* mChunkedDecoder;

  TimingStruct mTimings;

  nsresult mStatus;

  int16_t mPriority;

  uint16_t
      mRestartCount;  // the number of times this transaction has been restarted
  uint32_t mCaps;

  HttpVersion mHttpVersion;
  uint16_t mHttpResponseCode;
  nsCString mFlat407Headers;

  uint32_t mCurrentHttpResponseHeaderSize;

  int32_t const THROTTLE_NO_LIMIT = -1;
  // This can have 3 possible values:
  // * THROTTLE_NO_LIMIT - this means the transaction is not in any way limited
  //                       to read the response, this is the default
  // * a positive number - a limit is set because the transaction is obligated
  //                       to throttle the response read, this is decresed with
  //                       every piece of data the transaction receives
  // * zero - when the transaction depletes the limit for reading, this makes it
  //          stop reading and return WOULD_BLOCK from WriteSegments;
  //          transaction then waits for a call of ResumeReading that resets
  //          this member back to THROTTLE_NO_LIMIT
  int32_t mThrottlingReadAllowance;

  // mCapsToClear holds flags that should be cleared in mCaps, e.g. unset
  // NS_HTTP_REFRESH_DNS when DNS refresh request has completed to avoid
  // redundant requests on the network. The member itself is atomic, but
  // access to it from the networking thread may happen either before or
  // after the main thread modifies it. To deal with raciness, only unsetting
  // bitfields should be allowed: 'lost races' will thus err on the
  // conservative side, e.g. by going ahead with a 2nd DNS refresh.
  Atomic<uint32_t> mCapsToClear;
  Atomic<bool, ReleaseAcquire> mResponseIsComplete;

  // True iff WriteSegments was called while this transaction should be
  // throttled (stop reading) Used to resume read on unblock of reading.  Conn
  // manager is responsible for calling back to resume reading.
  bool mReadingStopped;

  // state flags, all logically boolean, but not packed together into a
  // bitfield so as to avoid bitfield-induced races.  See bug 560579.
  bool mClosed;
  bool mConnected;
  bool mActivated;
  bool mHaveStatusLine;
  bool mHaveAllHeaders;
  bool mTransactionDone;
  bool mDidContentStart;
  bool mNoContent;  // expecting an empty entity body
  bool mSentData;
  bool mReceivedData;
  bool mStatusEventPending;
  bool mHasRequestBody;
  bool mProxyConnectFailed;
  bool mHttpResponseMatched;
  bool mPreserveStream;
  bool mDispatchedAsBlocking;
  bool mResponseTimeoutEnabled;
  bool mForceRestart;
  bool mReuseOnRestart;
  bool mContentDecoding;
  bool mContentDecodingCheck;
  bool mDeferredSendProgress;
  bool mWaitingOnPipeOut;

  bool mDoNotRemoveAltSvc;

  // mClosed           := transaction has been explicitly closed
  // mTransactionDone  := transaction ran to completion or was interrupted
  // mResponseComplete := transaction ran to completion

  // For Restart-In-Progress Functionality
  bool mReportedStart;
  bool mReportedResponseHeader;

  // protected by nsHttp::GetLock()
  bool mResponseHeadTaken;
  UniquePtr<nsHttpHeaderArray> mForTakeResponseTrailers;
  bool mResponseTrailersTaken;

  // The time when the transaction was submitted to the Connection Manager
  TimeStamp mPendingTime;

  uint64_t mTopLevelOuterContentWindowId;

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
  void OnTokenBucketAdmitted() override;  // ATokenBucketEvent

  // CancelPacing() can be used to tell the token bucket to remove this
  // transaction from the list of pending transactions. This is used when a
  // transaction is believed to be HTTP/1 (and thus subject to rate pacing)
  // but later can be dispatched via spdy (not subject to rate pacing).
  void CancelPacing(nsresult reason);

  // Called by the connetion manager on the socket thread when reading for this
  // previously throttled transaction has to be resumed.
  void ResumeReading();

  // This examins classification of this transaction whether the Throttleable
  // class has been set while Leader, Unblocked, DontThrottle has not.
  bool EligibleForThrottling() const;

 private:
  bool mSubmittedRatePacing;
  bool mPassedRatePacing;
  bool mSynchronousRatePaceRequest;
  nsCOMPtr<nsICancelable> mTokenBucketCancel;

 public:
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

  void SetTunnelProvider(ASpdySession* provider) { mTunnelProvider = provider; }
  ASpdySession* TunnelProvider() { return mTunnelProvider; }
  nsIInterfaceRequestor* SecurityCallbacks() { return mCallbacks; }

 private:
  RefPtr<ASpdySession> mTunnelProvider;
  TransactionObserverFunc mTransactionObserver;
  NetAddr mSelfAddr;
  NetAddr mPeerAddr;
  bool mResolvedByTRR;

  bool m0RTTInProgress;
  bool mDoNotTryEarlyData;
  enum {
    EARLY_NONE,
    EARLY_SENT,
    EARLY_ACCEPTED,
    EARLY_425
  } mEarlyDataDisposition;

  uint8_t mFastOpenStatus;

  // H2 websocket support
  RefPtr<SpdyConnectTransaction> mH2WSTransaction;

  HttpTrafficCategory mTrafficCategory;
  bool mThroughCaptivePortal;
  Atomic<int32_t> mProxyConnectResponseCode;

  OnPushCallback mOnPushCallback;
  nsDataHashtable<nsUint32HashKey, RefPtr<Http2PushedStreamWrapper>>
      mIDToStreamMap;
};

}  // namespace net
}  // namespace mozilla

#endif  // nsHttpTransaction_h__
