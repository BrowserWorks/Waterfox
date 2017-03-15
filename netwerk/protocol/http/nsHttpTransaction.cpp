/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* vim:set ts=4 sw=4 sts=4 et cin: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

// HttpLog.h should generally be included first
#include "HttpLog.h"

#include "base/basictypes.h"

#include "nsHttpHandler.h"
#include "nsHttpTransaction.h"
#include "nsHttpRequestHead.h"
#include "nsHttpResponseHead.h"
#include "nsHttpChunkedDecoder.h"
#include "nsTransportUtils.h"
#include "nsNetCID.h"
#include "nsNetUtil.h"
#include "nsIChannel.h"
#include "nsIPipe.h"
#include "nsCRT.h"
#include "mozilla/Tokenizer.h"

#include "nsISeekableStream.h"
#include "nsMultiplexInputStream.h"
#include "nsStringStream.h"

#include "nsComponentManagerUtils.h" // do_CreateInstance
#include "nsServiceManagerUtils.h"   // do_GetService
#include "nsIHttpActivityObserver.h"
#include "nsSocketTransportService2.h"
#include "nsICancelable.h"
#include "nsIEventTarget.h"
#include "nsIHttpChannelInternal.h"
#include "nsIInputStream.h"
#include "nsIThrottledInputChannel.h"
#include "nsITransport.h"
#include "nsIOService.h"
#include "nsIRequestContext.h"
#include "nsIHttpAuthenticator.h"
#include <algorithm>

#ifdef MOZ_WIDGET_GONK
#include "NetStatistics.h"
#endif

//-----------------------------------------------------------------------------

static NS_DEFINE_CID(kMultiplexInputStream, NS_MULTIPLEXINPUTSTREAM_CID);

// Place a limit on how much non-compliant HTTP can be skipped while
// looking for a response header
#define MAX_INVALID_RESPONSE_BODY_SIZE (1024 * 128)

using namespace mozilla::net;

namespace mozilla {
namespace net {

//-----------------------------------------------------------------------------
// helpers
//-----------------------------------------------------------------------------

static void
LogHeaders(const char *lineStart)
{
    nsAutoCString buf;
    char *endOfLine;
    while ((endOfLine = PL_strstr(lineStart, "\r\n"))) {
        buf.Assign(lineStart, endOfLine - lineStart);
        if (PL_strcasestr(buf.get(), "authorization: ") ||
            PL_strcasestr(buf.get(), "proxy-authorization: ")) {
            char *p = PL_strchr(PL_strchr(buf.get(), ' ') + 1, ' ');
            while (p && *++p)
                *p = '*';
        }
        LOG3(("  %s\n", buf.get()));
        lineStart = endOfLine + 2;
    }
}

//-----------------------------------------------------------------------------
// nsHttpTransaction <public>
//-----------------------------------------------------------------------------

nsHttpTransaction::nsHttpTransaction()
    : mLock("transaction lock")
    , mRequestSize(0)
    , mRequestHead(nullptr)
    , mResponseHead(nullptr)
    , mReader(nullptr)
    , mWriter(nullptr)
    , mContentLength(-1)
    , mContentRead(0)
    , mTransferSize(0)
    , mInvalidResponseBytesRead(0)
    , mPushedStream(nullptr)
    , mInitialRwin(0)
    , mChunkedDecoder(nullptr)
    , mStatus(NS_OK)
    , mPriority(0)
    , mRestartCount(0)
    , mCaps(0)
    , mClassification(CLASS_GENERAL)
    , mPipelinePosition(0)
    , mHttpVersion(NS_HTTP_VERSION_UNKNOWN)
    , mHttpResponseCode(0)
    , mCurrentHttpResponseHeaderSize(0)
    , mCapsToClear(0)
    , mResponseIsComplete(false)
    , mClosed(false)
    , mConnected(false)
    , mHaveStatusLine(false)
    , mHaveAllHeaders(false)
    , mTransactionDone(false)
    , mDidContentStart(false)
    , mNoContent(false)
    , mSentData(false)
    , mReceivedData(false)
    , mStatusEventPending(false)
    , mHasRequestBody(false)
    , mProxyConnectFailed(false)
    , mHttpResponseMatched(false)
    , mPreserveStream(false)
    , mDispatchedAsBlocking(false)
    , mResponseTimeoutEnabled(true)
    , mForceRestart(false)
    , mReuseOnRestart(false)
    , mContentDecoding(false)
    , mContentDecodingCheck(false)
    , mDeferredSendProgress(false)
    , mWaitingOnPipeOut(false)
    , mReportedStart(false)
    , mReportedResponseHeader(false)
    , mForTakeResponseHead(nullptr)
    , mResponseHeadTaken(false)
    , mSubmittedRatePacing(false)
    , mPassedRatePacing(false)
    , mSynchronousRatePaceRequest(false)
    , mCountRecv(0)
    , mCountSent(0)
    , mAppId(NECKO_NO_APP_ID)
    , mIsInIsolatedMozBrowser(false)
    , mClassOfService(0)
    , m0RTTInProgress(false)
{
    LOG(("Creating nsHttpTransaction @%p\n", this));
    gHttpHandler->GetMaxPipelineObjectSize(&mMaxPipelineObjectSize);

#ifdef MOZ_VALGRIND
    memset(&mSelfAddr, 0, sizeof(NetAddr));
    memset(&mPeerAddr, 0, sizeof(NetAddr));
#endif
    mSelfAddr.raw.family = PR_AF_UNSPEC;
    mPeerAddr.raw.family = PR_AF_UNSPEC;
}

nsHttpTransaction::~nsHttpTransaction()
{
    LOG(("Destroying nsHttpTransaction @%p\n", this));
    if (mTransactionObserver) {
        mTransactionObserver->Complete(this, NS_OK);
    }
    if (mPushedStream) {
        mPushedStream->OnPushFailed();
        mPushedStream = nullptr;
    }

    if (mTokenBucketCancel) {
        mTokenBucketCancel->Cancel(NS_ERROR_ABORT);
        mTokenBucketCancel = nullptr;
    }

    // Force the callbacks and connection to be released right now
    mCallbacks = nullptr;
    mConnection = nullptr;

    delete mResponseHead;
    delete mForTakeResponseHead;
    delete mChunkedDecoder;
    ReleaseBlockingTransaction();
}

nsHttpTransaction::Classifier
nsHttpTransaction::Classify()
{
    if (!(mCaps & NS_HTTP_ALLOW_PIPELINING))
        return (mClassification = CLASS_SOLO);

    if (mRequestHead->HasHeader(nsHttp::If_Modified_Since) ||
        mRequestHead->HasHeader(nsHttp::If_None_Match))
        return (mClassification = CLASS_REVALIDATION);

    nsAutoCString accept;
    bool hasAccept = NS_SUCCEEDED(mRequestHead->GetHeader(nsHttp::Accept, accept));
    if (hasAccept && StringBeginsWith(accept, NS_LITERAL_CSTRING("image/"))) {
        return (mClassification = CLASS_IMAGE);
    }

    if (hasAccept && StringBeginsWith(accept, NS_LITERAL_CSTRING("text/css"))) {
        return (mClassification = CLASS_SCRIPT);
    }

    mClassification = CLASS_GENERAL;

    nsAutoCString requestURI;
    mRequestHead->RequestURI(requestURI);
    int32_t queryPos = requestURI.FindChar('?');
    if (queryPos == kNotFound) {
        if (StringEndsWith(requestURI,
                           NS_LITERAL_CSTRING(".js")))
            mClassification = CLASS_SCRIPT;
    }
    else if (queryPos >= 3 &&
             Substring(requestURI, queryPos - 3, 3).
             EqualsLiteral(".js")) {
        mClassification = CLASS_SCRIPT;
    }

    return mClassification;
}

nsresult
nsHttpTransaction::Init(uint32_t caps,
                        nsHttpConnectionInfo *cinfo,
                        nsHttpRequestHead *requestHead,
                        nsIInputStream *requestBody,
                        bool requestBodyHasHeaders,
                        nsIEventTarget *target,
                        nsIInterfaceRequestor *callbacks,
                        nsITransportEventSink *eventsink,
                        nsIAsyncInputStream **responseBody)
{
    nsresult rv;

    LOG(("nsHttpTransaction::Init [this=%p caps=%x]\n", this, caps));

    MOZ_ASSERT(cinfo);
    MOZ_ASSERT(requestHead);
    MOZ_ASSERT(target);
    MOZ_ASSERT(NS_IsMainThread());

    mActivityDistributor = do_GetService(NS_HTTPACTIVITYDISTRIBUTOR_CONTRACTID, &rv);
    if (NS_FAILED(rv)) return rv;

    bool activityDistributorActive;
    rv = mActivityDistributor->GetIsActive(&activityDistributorActive);
    if (NS_SUCCEEDED(rv) && activityDistributorActive) {
        // there are some observers registered at activity distributor, gather
        // nsISupports for the channel that called Init()
        LOG(("nsHttpTransaction::Init() " \
             "mActivityDistributor is active " \
             "this=%p", this));
    } else {
        // there is no observer, so don't use it
        activityDistributorActive = false;
        mActivityDistributor = nullptr;
    }
    mChannel = do_QueryInterface(eventsink);
    nsCOMPtr<nsIChannel> channel = do_QueryInterface(eventsink);
    if (channel) {
        NS_GetAppInfo(channel, &mAppId, &mIsInIsolatedMozBrowser);
    }

#ifdef MOZ_WIDGET_GONK
    if (mAppId != NECKO_NO_APP_ID) {
        nsCOMPtr<nsINetworkInfo> activeNetworkInfo;
        GetActiveNetworkInfo(activeNetworkInfo);
        mActiveNetworkInfo =
            new nsMainThreadPtrHolder<nsINetworkInfo>(activeNetworkInfo);
    }
#endif

    nsCOMPtr<nsIHttpChannelInternal> httpChannelInternal =
        do_QueryInterface(eventsink);
    if (httpChannelInternal) {
        rv = httpChannelInternal->GetResponseTimeoutEnabled(
            &mResponseTimeoutEnabled);
        if (NS_WARN_IF(NS_FAILED(rv))) {
            return rv;
        }
        httpChannelInternal->GetInitialRwin(&mInitialRwin);
    }

    // create transport event sink proxy. it coalesces consecutive
    // events of the same status type.
    rv = net_NewTransportEventSinkProxy(getter_AddRefs(mTransportSink),
                                        eventsink, target);

    if (NS_FAILED(rv)) return rv;

    mConnInfo = cinfo;
    mCallbacks = callbacks;
    mConsumerTarget = target;
    mCaps = caps;

    if (requestHead->IsHead()) {
        mNoContent = true;
    }

    // Make sure that there is "Content-Length: 0" header in the requestHead
    // in case of POST and PUT methods when there is no requestBody and
    // requestHead doesn't contain "Transfer-Encoding" header.
    //
    // RFC1945 section 7.2.2:
    //   HTTP/1.0 requests containing an entity body must include a valid
    //   Content-Length header field.
    //
    // RFC2616 section 4.4:
    //   For compatibility with HTTP/1.0 applications, HTTP/1.1 requests
    //   containing a message-body MUST include a valid Content-Length header
    //   field unless the server is known to be HTTP/1.1 compliant.
    if ((requestHead->IsPost() || requestHead->IsPut()) &&
        !requestBody && !requestHead->HasHeader(nsHttp::Transfer_Encoding)) {
        requestHead->SetHeader(nsHttp::Content_Length, NS_LITERAL_CSTRING("0"));
    }

    // grab a weak reference to the request head
    mRequestHead = requestHead;

    // make sure we eliminate any proxy specific headers from
    // the request if we are using CONNECT
    bool pruneProxyHeaders = cinfo->UsingConnect();

    mReqHeaderBuf.Truncate();
    requestHead->Flatten(mReqHeaderBuf, pruneProxyHeaders);

    if (LOG3_ENABLED()) {
        LOG3(("http request [\n"));
        LogHeaders(mReqHeaderBuf.get());
        LOG3(("]\n"));
    }

    // If the request body does not include headers or if there is no request
    // body, then we must add the header/body separator manually.
    if (!requestBodyHasHeaders || !requestBody)
        mReqHeaderBuf.AppendLiteral("\r\n");

    // report the request header
    if (mActivityDistributor)
        mActivityDistributor->ObserveActivity(
            mChannel,
            NS_HTTP_ACTIVITY_TYPE_HTTP_TRANSACTION,
            NS_HTTP_ACTIVITY_SUBTYPE_REQUEST_HEADER,
            PR_Now(), 0,
            mReqHeaderBuf);

    // Create a string stream for the request header buf (the stream holds
    // a non-owning reference to the request header data, so we MUST keep
    // mReqHeaderBuf around).
    nsCOMPtr<nsIInputStream> headers;
    rv = NS_NewByteInputStream(getter_AddRefs(headers),
                               mReqHeaderBuf.get(),
                               mReqHeaderBuf.Length());
    if (NS_FAILED(rv)) return rv;

    mHasRequestBody = !!requestBody;
    if (mHasRequestBody) {
        // some non standard methods set a 0 byte content-length for
        // clarity, we can avoid doing the mulitplexed request stream for them
        uint64_t size;
        if (NS_SUCCEEDED(requestBody->Available(&size)) && !size) {
            mHasRequestBody = false;
        }
    }

    if (mHasRequestBody) {
        // wrap the headers and request body in a multiplexed input stream.
        nsCOMPtr<nsIMultiplexInputStream> multi =
            do_CreateInstance(kMultiplexInputStream, &rv);
        if (NS_FAILED(rv)) return rv;

        rv = multi->AppendStream(headers);
        if (NS_FAILED(rv)) return rv;

        rv = multi->AppendStream(requestBody);
        if (NS_FAILED(rv)) return rv;

        // wrap the multiplexed input stream with a buffered input stream, so
        // that we write data in the largest chunks possible.  this is actually
        // necessary to workaround some common server bugs (see bug 137155).
        rv = NS_NewBufferedInputStream(getter_AddRefs(mRequestStream), multi,
                                       nsIOService::gDefaultSegmentSize);
        if (NS_FAILED(rv)) return rv;
    }
    else
        mRequestStream = headers;

    nsCOMPtr<nsIThrottledInputChannel> throttled = do_QueryInterface(mChannel);
    nsIInputChannelThrottleQueue* queue;
    if (throttled) {
        rv = throttled->GetThrottleQueue(&queue);
        // In case of failure, just carry on without throttling.
        if (NS_SUCCEEDED(rv) && queue) {
            nsCOMPtr<nsIAsyncInputStream> wrappedStream;
            rv = queue->WrapStream(mRequestStream, getter_AddRefs(wrappedStream));
            // Failure to throttle isn't sufficient reason to fail
            // initialization
            if (NS_SUCCEEDED(rv)) {
                MOZ_ASSERT(wrappedStream != nullptr);
                LOG(("nsHttpTransaction::Init %p wrapping input stream using throttle queue %p\n",
                     this, queue));
                mRequestStream = do_QueryInterface(wrappedStream);
            }
        }
    }

    uint64_t size_u64;
    rv = mRequestStream->Available(&size_u64);
    if (NS_FAILED(rv)) {
        return rv;
    }

    // make sure it fits within js MAX_SAFE_INTEGER
    mRequestSize = InScriptableRange(size_u64) ? static_cast<int64_t>(size_u64) : -1;

    // create pipe for response stream
    rv = NS_NewPipe2(getter_AddRefs(mPipeIn),
                     getter_AddRefs(mPipeOut),
                     true, true,
                     nsIOService::gDefaultSegmentSize,
                     nsIOService::gDefaultSegmentCount);
    if (NS_FAILED(rv)) return rv;

#ifdef WIN32 // bug 1153929
    MOZ_DIAGNOSTIC_ASSERT(mPipeOut);
    uint32_t * vtable = (uint32_t *) mPipeOut.get();
    MOZ_DIAGNOSTIC_ASSERT(*vtable != 0);
#endif // WIN32

    Classify();

    nsCOMPtr<nsIAsyncInputStream> tmp(mPipeIn);
    tmp.forget(responseBody);
    return NS_OK;
}

// This method should only be used on the socket thread
nsAHttpConnection *
nsHttpTransaction::Connection()
{
    MOZ_ASSERT(PR_GetCurrentThread() == gSocketThread);
    return mConnection.get();
}

already_AddRefed<nsAHttpConnection>
nsHttpTransaction::GetConnectionReference()
{
    MutexAutoLock lock(mLock);
    RefPtr<nsAHttpConnection> connection(mConnection);
    return connection.forget();
}

nsHttpResponseHead *
nsHttpTransaction::TakeResponseHead()
{
    MOZ_ASSERT(!mResponseHeadTaken, "TakeResponseHead called 2x");

    // Lock RestartInProgress() and TakeResponseHead() against main thread
    MutexAutoLock lock(*nsHttp::GetLock());

    mResponseHeadTaken = true;

    // Prefer mForTakeResponseHead over mResponseHead. It is always a complete
    // set of headers.
    nsHttpResponseHead *head;
    if (mForTakeResponseHead) {
        head = mForTakeResponseHead;
        mForTakeResponseHead = nullptr;
        return head;
    }

    // Even in OnStartRequest() the headers won't be available if we were
    // canceled
    if (!mHaveAllHeaders) {
        NS_WARNING("response headers not available or incomplete");
        return nullptr;
    }

    head = mResponseHead;
    mResponseHead = nullptr;
    return head;
}

void
nsHttpTransaction::SetProxyConnectFailed()
{
    mProxyConnectFailed = true;
}

nsHttpRequestHead *
nsHttpTransaction::RequestHead()
{
    return mRequestHead;
}

uint32_t
nsHttpTransaction::Http1xTransactionCount()
{
  return 1;
}

nsresult
nsHttpTransaction::TakeSubTransactions(
    nsTArray<RefPtr<nsAHttpTransaction> > &outTransactions)
{
    return NS_ERROR_NOT_IMPLEMENTED;
}

//----------------------------------------------------------------------------
// nsHttpTransaction::nsAHttpTransaction
//----------------------------------------------------------------------------

void
nsHttpTransaction::SetConnection(nsAHttpConnection *conn)
{
    {
        MutexAutoLock lock(mLock);
        mConnection = conn;
    }
}

void
nsHttpTransaction::GetSecurityCallbacks(nsIInterfaceRequestor **cb)
{
    MutexAutoLock lock(mLock);
    nsCOMPtr<nsIInterfaceRequestor> tmp(mCallbacks);
    tmp.forget(cb);
}

void
nsHttpTransaction::SetSecurityCallbacks(nsIInterfaceRequestor* aCallbacks)
{
    {
        MutexAutoLock lock(mLock);
        mCallbacks = aCallbacks;
    }

    if (gSocketTransportService) {
        RefPtr<UpdateSecurityCallbacks> event = new UpdateSecurityCallbacks(this, aCallbacks);
        gSocketTransportService->Dispatch(event, nsIEventTarget::DISPATCH_NORMAL);
    }
}

void
nsHttpTransaction::OnTransportStatus(nsITransport* transport,
                                     nsresult status, int64_t progress)
{
    LOG(("nsHttpTransaction::OnSocketStatus [this=%p status=%x progress=%lld]\n",
        this, status, progress));

    if (status == NS_NET_STATUS_CONNECTED_TO ||
        status == NS_NET_STATUS_WAITING_FOR) {
        nsISocketTransport *socketTransport =
            mConnection ? mConnection->Transport() : nullptr;
        if (socketTransport) {
            MutexAutoLock lock(mLock);
            socketTransport->GetSelfAddr(&mSelfAddr);
            socketTransport->GetPeerAddr(&mPeerAddr);
        }
    }

    // If the timing is enabled, and we are not using a persistent connection
    // then the requestStart timestamp will be null, so we mark the timestamps
    // for domainLookupStart/End and connectStart/End
    // If we are using a persistent connection they will remain null,
    // and the correct value will be returned in Performance.
    if (TimingEnabled() && GetRequestStart().IsNull()) {
        if (status == NS_NET_STATUS_RESOLVING_HOST) {
            SetDomainLookupStart(TimeStamp::Now(), true);
        } else if (status == NS_NET_STATUS_RESOLVED_HOST) {
            SetDomainLookupEnd(TimeStamp::Now());
        } else if (status == NS_NET_STATUS_CONNECTING_TO) {
            SetConnectStart(TimeStamp::Now());
        } else if (status == NS_NET_STATUS_CONNECTED_TO) {
            SetConnectEnd(TimeStamp::Now());
        }
    }

    if (!mTransportSink)
        return;

    MOZ_ASSERT(PR_GetCurrentThread() == gSocketThread);

    // Need to do this before the STATUS_RECEIVING_FROM check below, to make
    // sure that the activity distributor gets told about all status events.
    if (mActivityDistributor) {
        // upon STATUS_WAITING_FOR; report request body sent
        if ((mHasRequestBody) &&
            (status == NS_NET_STATUS_WAITING_FOR))
            mActivityDistributor->ObserveActivity(
                mChannel,
                NS_HTTP_ACTIVITY_TYPE_HTTP_TRANSACTION,
                NS_HTTP_ACTIVITY_SUBTYPE_REQUEST_BODY_SENT,
                PR_Now(), 0, EmptyCString());

        // report the status and progress
        if (!mRestartInProgressVerifier.IsDiscardingContent())
            mActivityDistributor->ObserveActivity(
                mChannel,
                NS_HTTP_ACTIVITY_TYPE_SOCKET_TRANSPORT,
                static_cast<uint32_t>(status),
                PR_Now(),
                progress,
                EmptyCString());
    }

    // nsHttpChannel synthesizes progress events in OnDataAvailable
    if (status == NS_NET_STATUS_RECEIVING_FROM)
        return;

    int64_t progressMax;

    if (status == NS_NET_STATUS_SENDING_TO) {
        // suppress progress when only writing request headers
        if (!mHasRequestBody) {
            LOG(("nsHttpTransaction::OnTransportStatus %p "
                 "SENDING_TO without request body\n", this));
            return;
        }

        if (mReader) {
            // A mRequestStream method is on the stack - wait.
            LOG(("nsHttpTransaction::OnSocketStatus [this=%p] "
                 "Skipping Re-Entrant NS_NET_STATUS_SENDING_TO\n", this));
            // its ok to coalesce several of these into one deferred event
            mDeferredSendProgress = true;
            return;
        }

        nsCOMPtr<nsISeekableStream> seekable = do_QueryInterface(mRequestStream);
        if (!seekable) {
            LOG(("nsHttpTransaction::OnTransportStatus %p "
                 "SENDING_TO without seekable request stream\n", this));
            progress = 0;
        } else {
            int64_t prog = 0;
            seekable->Tell(&prog);
            progress = prog;
        }

        // when uploading, we include the request headers in the progress
        // notifications.
        progressMax = mRequestSize;
    }
    else {
        progress = 0;
        progressMax = 0;
    }

    mTransportSink->OnTransportStatus(transport, status, progress, progressMax);
}

bool
nsHttpTransaction::IsDone()
{
    return mTransactionDone;
}

nsresult
nsHttpTransaction::Status()
{
    return mStatus;
}

uint32_t
nsHttpTransaction::Caps()
{
    return mCaps & ~mCapsToClear;
}

void
nsHttpTransaction::SetDNSWasRefreshed()
{
    MOZ_ASSERT(NS_IsMainThread(), "SetDNSWasRefreshed on main thread only!");
    mCapsToClear |= NS_HTTP_REFRESH_DNS;
}

uint64_t
nsHttpTransaction::Available()
{
    uint64_t size;
    if (NS_FAILED(mRequestStream->Available(&size)))
        size = 0;
    return size;
}

nsresult
nsHttpTransaction::ReadRequestSegment(nsIInputStream *stream,
                                      void *closure,
                                      const char *buf,
                                      uint32_t offset,
                                      uint32_t count,
                                      uint32_t *countRead)
{
    nsHttpTransaction *trans = (nsHttpTransaction *) closure;
    nsresult rv = trans->mReader->OnReadSegment(buf, count, countRead);
    if (NS_FAILED(rv)) return rv;

    if (trans->TimingEnabled()) {
        // Set the timestamp to Now(), only if it null
        trans->SetRequestStart(TimeStamp::Now(), true);
    }

    trans->CountSentBytes(*countRead);
    trans->mSentData = true;
    return NS_OK;
}

nsresult
nsHttpTransaction::ReadSegments(nsAHttpSegmentReader *reader,
                                uint32_t count, uint32_t *countRead)
{
    MOZ_ASSERT(PR_GetCurrentThread() == gSocketThread);

    if (mTransactionDone) {
        *countRead = 0;
        return mStatus;
    }

    if (!mConnected && !m0RTTInProgress) {
        mConnected = true;
        mConnection->GetSecurityInfo(getter_AddRefs(mSecurityInfo));
    }

    mDeferredSendProgress = false;
    mReader = reader;
    nsresult rv = mRequestStream->ReadSegments(ReadRequestSegment, this, count, countRead);
    mReader = nullptr;

    if (mDeferredSendProgress && mConnection && mConnection->Transport()) {
        // to avoid using mRequestStream concurrently, OnTransportStatus()
        // did not report upload status off the ReadSegments() stack from nsSocketTransport
        // do it now.
        OnTransportStatus(mConnection->Transport(), NS_NET_STATUS_SENDING_TO, 0);
    }
    mDeferredSendProgress = false;

    if (mForceRestart) {
        // The forceRestart condition was dealt with on the stack, but it did not
        // clear the flag because nsPipe in the readsegment stack clears out
        // return codes, so we need to use the flag here as a cue to return ERETARGETED
        if (NS_SUCCEEDED(rv)) {
            rv = NS_BINDING_RETARGETED;
        }
        mForceRestart = false;
    }

    // if read would block then we need to AsyncWait on the request stream.
    // have callback occur on socket thread so we stay synchronized.
    if (rv == NS_BASE_STREAM_WOULD_BLOCK) {
        nsCOMPtr<nsIAsyncInputStream> asyncIn =
                do_QueryInterface(mRequestStream);
        if (asyncIn) {
            nsCOMPtr<nsIEventTarget> target;
            gHttpHandler->GetSocketThreadTarget(getter_AddRefs(target));
            if (target)
                asyncIn->AsyncWait(this, 0, 0, target);
            else {
                NS_ERROR("no socket thread event target");
                rv = NS_ERROR_UNEXPECTED;
            }
        }
    }

    return rv;
}

nsresult
nsHttpTransaction::WritePipeSegment(nsIOutputStream *stream,
                                    void *closure,
                                    char *buf,
                                    uint32_t offset,
                                    uint32_t count,
                                    uint32_t *countWritten)
{
    nsHttpTransaction *trans = (nsHttpTransaction *) closure;

    if (trans->mTransactionDone)
        return NS_BASE_STREAM_CLOSED; // stop iterating

    if (trans->TimingEnabled()) {
        // Set the timestamp to Now(), only if it null
        trans->SetResponseStart(TimeStamp::Now(), true);
    }

    // Bug 1153929 - add checks to fix windows crash
    MOZ_ASSERT(trans->mWriter);
    if (!trans->mWriter) {
        return NS_ERROR_UNEXPECTED;
    }

    nsresult rv;
    //
    // OK, now let the caller fill this segment with data.
    //
    rv = trans->mWriter->OnWriteSegment(buf, count, countWritten);
    if (NS_FAILED(rv)) return rv; // caller didn't want to write anything

    MOZ_ASSERT(*countWritten > 0, "bad writer");
    trans->CountRecvBytes(*countWritten);
    trans->mReceivedData = true;
    trans->mTransferSize += *countWritten;

    // Let the transaction "play" with the buffer.  It is free to modify
    // the contents of the buffer and/or modify countWritten.
    // - Bytes in HTTP headers don't count towards countWritten, so the input
    // side of pipe (aka nsHttpChannel's mTransactionPump) won't hit
    // OnInputStreamReady until all headers have been parsed.
    //
    rv = trans->ProcessData(buf, *countWritten, countWritten);
    if (NS_FAILED(rv))
        trans->Close(rv);

    return rv; // failure code only stops WriteSegments; it is not propagated.
}

nsresult
nsHttpTransaction::WriteSegments(nsAHttpSegmentWriter *writer,
                                 uint32_t count, uint32_t *countWritten)
{
    static bool reentrantFlag = false;
    LOG(("nsHttpTransaction::WriteSegments %p reentrantFlag=%d",
         this, reentrantFlag));
    MOZ_DIAGNOSTIC_ASSERT(!reentrantFlag);
    reentrantFlag = true;
    MOZ_ASSERT(PR_GetCurrentThread() == gSocketThread);

    if (mTransactionDone) {
        reentrantFlag = false;
        return NS_SUCCEEDED(mStatus) ? NS_BASE_STREAM_CLOSED : mStatus;
    }

    mWriter = writer;

#ifdef WIN32 // bug 1153929
    MOZ_DIAGNOSTIC_ASSERT(mPipeOut);
    uint32_t * vtable = (uint32_t *) mPipeOut.get();
    MOZ_DIAGNOSTIC_ASSERT(*vtable != 0);
#endif // WIN32

    if (!mPipeOut) {
        reentrantFlag = false;
        return NS_ERROR_UNEXPECTED;
    }

    nsresult rv = mPipeOut->WriteSegments(WritePipeSegment, this, count, countWritten);

    mWriter = nullptr;

    if (mForceRestart) {
        // The forceRestart condition was dealt with on the stack, but it did not
        // clear the flag because nsPipe in the writesegment stack clears out
        // return codes, so we need to use the flag here as a cue to return ERETARGETED
        if (NS_SUCCEEDED(rv)) {
            rv = NS_BINDING_RETARGETED;
        }
        mForceRestart = false;
    }

    // if pipe would block then we need to AsyncWait on it.  have callback
    // occur on socket thread so we stay synchronized.
    if (rv == NS_BASE_STREAM_WOULD_BLOCK) {
        nsCOMPtr<nsIEventTarget> target;
        gHttpHandler->GetSocketThreadTarget(getter_AddRefs(target));
        if (target) {
            mPipeOut->AsyncWait(this, 0, 0, target);
            mWaitingOnPipeOut = true;
        } else {
            NS_ERROR("no socket thread event target");
            rv = NS_ERROR_UNEXPECTED;
        }
    }

    reentrantFlag = false;
    return rv;
}

nsresult
nsHttpTransaction::SaveNetworkStats(bool enforce)
{
#ifdef MOZ_WIDGET_GONK
    // Check if active network and appid are valid.
    if (!mActiveNetworkInfo || mAppId == NECKO_NO_APP_ID) {
        return NS_OK;
    }

    if (mCountRecv <= 0 && mCountSent <= 0) {
        // There is no traffic, no need to save.
        return NS_OK;
    }

    // If |enforce| is false, the traffic amount is saved
    // only when the total amount exceeds the predefined
    // threshold.
    uint64_t totalBytes = mCountRecv + mCountSent;
    if (!enforce && totalBytes < NETWORK_STATS_THRESHOLD) {
        return NS_OK;
    }

    // Create the event to save the network statistics.
    // the event is then dispatched to the main thread.
    RefPtr<Runnable> event =
        new SaveNetworkStatsEvent(mAppId, mIsInIsolatedMozBrowser, mActiveNetworkInfo,
                                  mCountRecv, mCountSent, false);
    NS_DispatchToMainThread(event);

    // Reset the counters after saving.
    mCountSent = 0;
    mCountRecv = 0;

    return NS_OK;
#else
    return NS_ERROR_NOT_IMPLEMENTED;
#endif
}

void
nsHttpTransaction::Close(nsresult reason)
{
    LOG(("nsHttpTransaction::Close [this=%p reason=%x]\n", this, reason));

    MOZ_ASSERT(PR_GetCurrentThread() == gSocketThread);
    if (reason == NS_BINDING_RETARGETED) {
        LOG(("  close %p skipped due to ERETARGETED\n", this));
        return;
    }

    if (mClosed) {
        LOG(("  already closed\n"));
        return;
    }

    if (mTransactionObserver) {
        mTransactionObserver->Complete(this, reason);
        mTransactionObserver = nullptr;
    }

    if (mTokenBucketCancel) {
        mTokenBucketCancel->Cancel(reason);
        mTokenBucketCancel = nullptr;
    }

    if (mActivityDistributor) {
        // report the reponse is complete if not already reported
        if (!mResponseIsComplete)
            mActivityDistributor->ObserveActivity(
                mChannel,
                NS_HTTP_ACTIVITY_TYPE_HTTP_TRANSACTION,
                NS_HTTP_ACTIVITY_SUBTYPE_RESPONSE_COMPLETE,
                PR_Now(),
                static_cast<uint64_t>(mContentRead),
                EmptyCString());

        // report that this transaction is closing
        mActivityDistributor->ObserveActivity(
            mChannel,
            NS_HTTP_ACTIVITY_TYPE_HTTP_TRANSACTION,
            NS_HTTP_ACTIVITY_SUBTYPE_TRANSACTION_CLOSE,
            PR_Now(), 0, EmptyCString());
    }

    // we must no longer reference the connection!  find out if the
    // connection was being reused before letting it go.
    bool connReused = false;
    if (mConnection) {
        connReused = mConnection->IsReused();
    }
    mConnected = false;
    mTunnelProvider = nullptr;

    //
    // if the connection was reset or closed before we wrote any part of the
    // request or if we wrote the request but didn't receive any part of the
    // response and the connection was being reused, then we can (and really
    // should) assume that we wrote to a stale connection and we must therefore
    // repeat the request over a new connection.
    //
    // We have decided to retry not only in case of the reused connections, but
    // all safe methods(bug 1236277).
    //
    // NOTE: the conditions under which we will automatically retry the HTTP
    // request have to be carefully selected to avoid duplication of the
    // request from the point-of-view of the server.  such duplication could
    // have dire consequences including repeated purchases, etc.
    //
    // NOTE: because of the way SSL proxy CONNECT is implemented, it is
    // possible that the transaction may have received data without having
    // sent any data.  for this reason, mSendData == FALSE does not imply
    // mReceivedData == FALSE.  (see bug 203057 for more info.)
    //
    // Never restart transactions that are marked as sticky to their conenction.
    // We use that capability to identify transactions bound to connection based
    // authentication.  Reissuing them on a different connections will break
    // this bondage.  Major issue may arise when there is an NTLM message auth
    // header on the transaction and we send it to a different NTLM authenticated
    // connection.  It will break that connection and also confuse the channel's
    // auth provider, beliving the cached credentials are wrong and asking for
    // the password mistakenly again from the user.
    if ((reason == NS_ERROR_NET_RESET || reason == NS_OK) &&
        !(mCaps & NS_HTTP_STICKY_CONNECTION)) {

        if (mForceRestart && NS_SUCCEEDED(Restart())) {
            if (mResponseHead) {
                mResponseHead->Reset();
            }
            mContentRead = 0;
            mContentLength = -1;
            delete mChunkedDecoder;
            mChunkedDecoder = nullptr;
            mHaveStatusLine = false;
            mHaveAllHeaders = false;
            mHttpResponseMatched = false;
            mResponseIsComplete = false;
            mDidContentStart = false;
            mNoContent = false;
            mSentData = false;
            mReceivedData = false;
            LOG(("transaction force restarted\n"));
            return;
        }

        // reallySentData is meant to separate the instances where data has
        // been sent by this transaction but buffered at a higher level while
        // a TLS session (perhaps via a tunnel) is setup.
        bool reallySentData =
            mSentData && (!mConnection || mConnection->BytesWritten());

        if (!mReceivedData &&
            ((mRequestHead && mRequestHead->IsSafeMethod()) ||
             !reallySentData || connReused)) {
            // if restarting fails, then we must proceed to close the pipe,
            // which will notify the channel that the transaction failed.

            if (mPipelinePosition) {
                gHttpHandler->ConnMgr()->PipelineFeedbackInfo(
                    mConnInfo, nsHttpConnectionMgr::RedCanceledPipeline,
                    nullptr, 0);
            }
            if (NS_SUCCEEDED(Restart()))
                return;
        }
        else if (!mResponseIsComplete && mPipelinePosition &&
                 reason == NS_ERROR_NET_RESET) {
            // due to unhandled rst on a pipeline - safe to
            // restart as only idempotent is found there

            gHttpHandler->ConnMgr()->PipelineFeedbackInfo(
                mConnInfo, nsHttpConnectionMgr::RedCorruptedContent, nullptr, 0);
            if (NS_SUCCEEDED(RestartInProgress()))
                return;
        }
    }

    if ((mChunkedDecoder || (mContentLength >= int64_t(0))) &&
        (NS_SUCCEEDED(reason) && !mResponseIsComplete)) {

        NS_WARNING("Partial transfer, incomplete HTTP response received");

        if ((mHttpResponseCode / 100 == 2) &&
            (mHttpVersion >= NS_HTTP_VERSION_1_1)) {
            FrameCheckLevel clevel = gHttpHandler->GetEnforceH1Framing();
            if (clevel >= FRAMECHECK_BARELY) {
                if ((clevel == FRAMECHECK_STRICT) ||
                    (mChunkedDecoder && mChunkedDecoder->GetChunkRemaining()) ||
                    (!mChunkedDecoder && !mContentDecoding && mContentDecodingCheck) ) {
                    reason = NS_ERROR_NET_PARTIAL_TRANSFER;
                    LOG(("Partial transfer, incomplete HTTP response received: %s",
                         mChunkedDecoder ? "broken chunk" : "c-l underrun"));
                }
            }
        }

        if (mConnection) {
            // whether or not we generate an error for the transaction
            // bad framing means we don't want a pconn
            mConnection->DontReuse();
        }
    }

    bool relConn = true;
    if (NS_SUCCEEDED(reason)) {
        if (!mResponseIsComplete) {
            // The response has not been delimited with a high-confidence
            // algorithm like Content-Length or Chunked Encoding. We
            // need to use a strong framing mechanism to pipeline.
            gHttpHandler->ConnMgr()->PipelineFeedbackInfo(
                mConnInfo, nsHttpConnectionMgr::BadInsufficientFraming,
                nullptr, mClassification);
        }
        else if (mPipelinePosition) {
            // report this success as feedback
            gHttpHandler->ConnMgr()->PipelineFeedbackInfo(
                mConnInfo, nsHttpConnectionMgr::GoodCompletedOK,
                nullptr, mPipelinePosition);
        }

        // the server has not sent the final \r\n terminating the header
        // section, and there may still be a header line unparsed.  let's make
        // sure we parse the remaining header line, and then hopefully, the
        // response will be usable (see bug 88792).
        if (!mHaveAllHeaders) {
            char data = '\n';
            uint32_t unused;
            ParseHead(&data, 1, &unused);

            if (mResponseHead->Version() == NS_HTTP_VERSION_0_9) {
                // Reject 0 byte HTTP/0.9 Responses - bug 423506
                LOG(("nsHttpTransaction::Close %p 0 Byte 0.9 Response", this));
                reason = NS_ERROR_NET_RESET;
            }
        }

        // honor the sticky connection flag...
        if (mCaps & NS_HTTP_STICKY_CONNECTION)
            relConn = false;
    }

    // mTimings.responseEnd is normally recorded based on the end of a
    // HTTP delimiter such as chunked-encodings or content-length. However,
    // EOF or an error still require an end time be recorded.
    if (TimingEnabled()) {
        const TimingStruct timings = Timings();
        if (timings.responseEnd.IsNull() && !timings.responseStart.IsNull()) {
            SetResponseEnd(TimeStamp::Now());
        }
    }

    if (relConn && mConnection) {
        MutexAutoLock lock(mLock);
        mConnection = nullptr;
    }

    // save network statistics in the end of transaction
    SaveNetworkStats(true);

    mStatus = reason;
    mTransactionDone = true; // forcibly flag the transaction as complete
    mClosed = true;
    ReleaseBlockingTransaction();

    // release some resources that we no longer need
    mRequestStream = nullptr;
    mReqHeaderBuf.Truncate();
    mLineBuf.Truncate();
    if (mChunkedDecoder) {
        delete mChunkedDecoder;
        mChunkedDecoder = nullptr;
    }

    // closing this pipe triggers the channel's OnStopRequest method.
    mPipeOut->CloseWithStatus(reason);

#ifdef WIN32 // bug 1153929
    MOZ_DIAGNOSTIC_ASSERT(mPipeOut);
    uint32_t * vtable = (uint32_t *) mPipeOut.get();
    MOZ_DIAGNOSTIC_ASSERT(*vtable != 0);
    mPipeOut = nullptr; // just in case
#endif // WIN32
}

nsHttpConnectionInfo *
nsHttpTransaction::ConnectionInfo()
{
    return mConnInfo.get();
}

nsresult
nsHttpTransaction::AddTransaction(nsAHttpTransaction *trans)
{
    return NS_ERROR_NOT_IMPLEMENTED;
}

uint32_t
nsHttpTransaction::PipelineDepth()
{
    return IsDone() ? 0 : 1;
}

nsresult
nsHttpTransaction::SetPipelinePosition(int32_t position)
{
    mPipelinePosition = position;
    return NS_OK;
}

int32_t
nsHttpTransaction::PipelinePosition()
{
    return mPipelinePosition;
}

bool // NOTE BASE CLASS
nsAHttpTransaction::ResponseTimeoutEnabled() const
{
    return false;
}

PRIntervalTime // NOTE BASE CLASS
nsAHttpTransaction::ResponseTimeout()
{
    return gHttpHandler->ResponseTimeout();
}

bool
nsHttpTransaction::ResponseTimeoutEnabled() const
{
    return mResponseTimeoutEnabled;
}

//-----------------------------------------------------------------------------
// nsHttpTransaction <private>
//-----------------------------------------------------------------------------

nsresult
nsHttpTransaction::RestartInProgress()
{
    MOZ_ASSERT(PR_GetCurrentThread() == gSocketThread);

    if ((mRestartCount + 1) >= gHttpHandler->MaxRequestAttempts()) {
        LOG(("nsHttpTransaction::RestartInProgress() "
             "reached max request attempts, failing transaction %p\n", this));
        return NS_ERROR_NET_RESET;
    }

    // Lock RestartInProgress() and TakeResponseHead() against main thread
    MutexAutoLock lock(*nsHttp::GetLock());

    // Don't try and RestartInProgress() things that haven't gotten a response
    // header yet. Those should be handled under the normal restart() path if
    // they are eligible.
    if (!mHaveAllHeaders)
        return NS_ERROR_NET_RESET;

    if (mCaps & NS_HTTP_STICKY_CONNECTION) {
        return NS_ERROR_NET_RESET;
    }

    // don't try and restart 0.9 or non 200/Get HTTP/1
    if (!mRestartInProgressVerifier.IsSetup())
        return NS_ERROR_NET_RESET;

    LOG(("Will restart transaction %p and skip first %lld bytes, "
         "old Content-Length %lld",
         this, mContentRead, mContentLength));

    mRestartInProgressVerifier.SetAlreadyProcessed(
        std::max(mRestartInProgressVerifier.AlreadyProcessed(), mContentRead));

    if (!mResponseHeadTaken && !mForTakeResponseHead) {
        // TakeResponseHeader() has not been called yet and this
        // is the first restart. Store the resp headers exclusively
        // for TakeResponseHead() which is called from the main thread and
        // could happen at any time - so we can't continue to modify those
        // headers (which restarting will effectively do)
        mForTakeResponseHead = mResponseHead;
        mResponseHead = nullptr;
    }

    if (mResponseHead) {
        mResponseHead->Reset();
    }

    mContentRead = 0;
    mContentLength = -1;
    delete mChunkedDecoder;
    mChunkedDecoder = nullptr;
    mHaveStatusLine = false;
    mHaveAllHeaders = false;
    mHttpResponseMatched = false;
    mResponseIsComplete = false;
    mDidContentStart = false;
    mNoContent = false;
    mSentData = false;
    mReceivedData = false;

    return Restart();
}

nsresult
nsHttpTransaction::Restart()
{
    MOZ_ASSERT(PR_GetCurrentThread() == gSocketThread);

    // limit the number of restart attempts - bug 92224
    if (++mRestartCount >= gHttpHandler->MaxRequestAttempts()) {
        LOG(("reached max request attempts, failing transaction @%p\n", this));
        return NS_ERROR_NET_RESET;
    }

    LOG(("restarting transaction @%p\n", this));
    mTunnelProvider = nullptr;

    // rewind streams in case we already wrote out the request
    nsCOMPtr<nsISeekableStream> seekable = do_QueryInterface(mRequestStream);
    if (seekable)
        seekable->Seek(nsISeekableStream::NS_SEEK_SET, 0);

    // clear old connection state...
    mSecurityInfo = nullptr;
    if (mConnection) {
        if (!mReuseOnRestart) {
            mConnection->DontReuse();
        }
        MutexAutoLock lock(mLock);
        mConnection = nullptr;
    }

    // Reset this to our default state, since this may change from one restart
    // to the next
    mReuseOnRestart = false;

    // disable pipelining for the next attempt in case pipelining caused the
    // reset.  this is being overly cautious since we don't know if pipelining
    // was the problem here.
    mCaps &= ~NS_HTTP_ALLOW_PIPELINING;
    SetPipelinePosition(0);

    if (!mConnInfo->GetRoutedHost().IsEmpty()) {
        MutexAutoLock lock(*nsHttp::GetLock());
        RefPtr<nsHttpConnectionInfo> ci;
         mConnInfo->CloneAsDirectRoute(getter_AddRefs(ci));
         mConnInfo = ci;
        if (mRequestHead) {
            mRequestHead->SetHeader(nsHttp::Alternate_Service_Used, NS_LITERAL_CSTRING("0"));
        }
    }

    return gHttpHandler->InitiateTransaction(this, mPriority);
}

char *
nsHttpTransaction::LocateHttpStart(char *buf, uint32_t len,
                                   bool aAllowPartialMatch)
{
    MOZ_ASSERT(!aAllowPartialMatch || mLineBuf.IsEmpty());

    static const char HTTPHeader[] = "HTTP/1.";
    static const uint32_t HTTPHeaderLen = sizeof(HTTPHeader) - 1;
    static const char HTTP2Header[] = "HTTP/2.0";
    static const uint32_t HTTP2HeaderLen = sizeof(HTTP2Header) - 1;
    // ShoutCast ICY is treated as HTTP/1.0
    static const char ICYHeader[] = "ICY ";
    static const uint32_t ICYHeaderLen = sizeof(ICYHeader) - 1;

    if (aAllowPartialMatch && (len < HTTPHeaderLen))
        return (PL_strncasecmp(buf, HTTPHeader, len) == 0) ? buf : nullptr;

    // mLineBuf can contain partial match from previous search
    if (!mLineBuf.IsEmpty()) {
        MOZ_ASSERT(mLineBuf.Length() < HTTPHeaderLen);
        int32_t checkChars = std::min(len, HTTPHeaderLen - mLineBuf.Length());
        if (PL_strncasecmp(buf, HTTPHeader + mLineBuf.Length(),
                           checkChars) == 0) {
            mLineBuf.Append(buf, checkChars);
            if (mLineBuf.Length() == HTTPHeaderLen) {
                // We've found whole HTTPHeader sequence. Return pointer at the
                // end of matched sequence since it is stored in mLineBuf.
                return (buf + checkChars);
            }
            // Response matches pattern but is still incomplete.
            return 0;
        }
        // Previous partial match together with new data doesn't match the
        // pattern. Start the search again.
        mLineBuf.Truncate();
    }

    bool firstByte = true;
    while (len > 0) {
        if (PL_strncasecmp(buf, HTTPHeader, std::min<uint32_t>(len, HTTPHeaderLen)) == 0) {
            if (len < HTTPHeaderLen) {
                // partial HTTPHeader sequence found
                // save partial match to mLineBuf
                mLineBuf.Assign(buf, len);
                return 0;
            }

            // whole HTTPHeader sequence found
            return buf;
        }

        // At least "SmarterTools/2.0.3974.16813" generates nonsensical
        // HTTP/2.0 responses to our HTTP/1 requests. Treat the minimal case of
        // it as HTTP/1.1 to be compatible with old versions of ourselves and
        // other browsers

        if (firstByte && !mInvalidResponseBytesRead && len >= HTTP2HeaderLen &&
            (PL_strncasecmp(buf, HTTP2Header, HTTP2HeaderLen) == 0)) {
            LOG(("nsHttpTransaction:: Identified HTTP/2.0 treating as 1.x\n"));
            return buf;
        }

        // Treat ICY (AOL/Nullsoft ShoutCast) non-standard header in same fashion
        // as HTTP/2.0 is treated above. This will allow "ICY " to be interpretted
        // as HTTP/1.0 in nsHttpResponseHead::ParseVersion

        if (firstByte && !mInvalidResponseBytesRead && len >= ICYHeaderLen &&
            (PL_strncasecmp(buf, ICYHeader, ICYHeaderLen) == 0)) {
            LOG(("nsHttpTransaction:: Identified ICY treating as HTTP/1.0\n"));
            return buf;
        }

        if (!nsCRT::IsAsciiSpace(*buf))
            firstByte = false;
        buf++;
        len--;
    }
    return 0;
}

nsresult
nsHttpTransaction::ParseLine(nsACString &line)
{
    LOG(("nsHttpTransaction::ParseLine [%s]\n", PromiseFlatCString(line).get()));
    nsresult rv = NS_OK;

    if (!mHaveStatusLine) {
        mResponseHead->ParseStatusLine(line);
        mHaveStatusLine = true;
        // XXX this should probably never happen
        if (mResponseHead->Version() == NS_HTTP_VERSION_0_9)
            mHaveAllHeaders = true;
    }
    else {
        rv = mResponseHead->ParseHeaderLine(line);
    }
    return rv;
}

nsresult
nsHttpTransaction::ParseLineSegment(char *segment, uint32_t len)
{
    NS_PRECONDITION(!mHaveAllHeaders, "already have all headers");

    if (!mLineBuf.IsEmpty() && mLineBuf.Last() == '\n') {
        // trim off the new line char, and if this segment is
        // not a continuation of the previous or if we haven't
        // parsed the status line yet, then parse the contents
        // of mLineBuf.
        mLineBuf.Truncate(mLineBuf.Length() - 1);
        if (!mHaveStatusLine || (*segment != ' ' && *segment != '\t')) {
            nsresult rv = ParseLine(mLineBuf);
            mLineBuf.Truncate();
            if (NS_FAILED(rv)) {
                gHttpHandler->ConnMgr()->PipelineFeedbackInfo(
                    mConnInfo, nsHttpConnectionMgr::RedCorruptedContent,
                    nullptr, 0);
                return rv;
            }
        }
    }

    // append segment to mLineBuf...
    mLineBuf.Append(segment, len);

    // a line buf with only a new line char signifies the end of headers.
    if (mLineBuf.First() == '\n') {
        mLineBuf.Truncate();
        // discard this response if it is a 100 continue or other 1xx status.
        uint16_t status = mResponseHead->Status();
        if ((status != 101) && (status / 100 == 1)) {
            LOG(("ignoring 1xx response\n"));
            mHaveStatusLine = false;
            mHttpResponseMatched = false;
            mConnection->SetLastTransactionExpectedNoContent(true);
            mResponseHead->Reset();
            return NS_OK;
        }
        mHaveAllHeaders = true;
    }
    return NS_OK;
}

nsresult
nsHttpTransaction::ParseHead(char *buf,
                             uint32_t count,
                             uint32_t *countRead)
{
    nsresult rv;
    uint32_t len;
    char *eol;

    LOG(("nsHttpTransaction::ParseHead [count=%u]\n", count));

    *countRead = 0;

    NS_PRECONDITION(!mHaveAllHeaders, "oops");

    // allocate the response head object if necessary
    if (!mResponseHead) {
        mResponseHead = new nsHttpResponseHead();
        if (!mResponseHead)
            return NS_ERROR_OUT_OF_MEMORY;

        // report that we have a least some of the response
        if (mActivityDistributor && !mReportedStart) {
            mReportedStart = true;
            mActivityDistributor->ObserveActivity(
                mChannel,
                NS_HTTP_ACTIVITY_TYPE_HTTP_TRANSACTION,
                NS_HTTP_ACTIVITY_SUBTYPE_RESPONSE_START,
                PR_Now(), 0, EmptyCString());
        }
    }

    if (!mHttpResponseMatched) {
        // Normally we insist on seeing HTTP/1.x in the first few bytes,
        // but if we are on a persistent connection and the previous transaction
        // was not supposed to have any content then we need to be prepared
        // to skip over a response body that the server may have sent even
        // though it wasn't allowed.
        if (!mConnection || !mConnection->LastTransactionExpectedNoContent()) {
            // tolerate only minor junk before the status line
            mHttpResponseMatched = true;
            char *p = LocateHttpStart(buf, std::min<uint32_t>(count, 11), true);
            if (!p) {
                // Treat any 0.9 style response of a put as a failure.
                if (mRequestHead->IsPut())
                    return NS_ERROR_ABORT;

                mResponseHead->ParseStatusLine(EmptyCString());
                mHaveStatusLine = true;
                mHaveAllHeaders = true;
                return NS_OK;
            }
            if (p > buf) {
                // skip over the junk
                mInvalidResponseBytesRead += p - buf;
                *countRead = p - buf;
                buf = p;
            }
        }
        else {
            char *p = LocateHttpStart(buf, count, false);
            if (p) {
                mInvalidResponseBytesRead += p - buf;
                *countRead = p - buf;
                buf = p;
                mHttpResponseMatched = true;
            } else {
                mInvalidResponseBytesRead += count;
                *countRead = count;
                if (mInvalidResponseBytesRead > MAX_INVALID_RESPONSE_BODY_SIZE) {
                    LOG(("nsHttpTransaction::ParseHead() "
                         "Cannot find Response Header\n"));
                    // cannot go back and call this 0.9 anymore as we
                    // have thrown away a lot of the leading junk
                    return NS_ERROR_ABORT;
                }
                return NS_OK;
            }
        }
    }
    // otherwise we can assume that we don't have a HTTP/0.9 response.

    MOZ_ASSERT (mHttpResponseMatched);
    while ((eol = static_cast<char *>(memchr(buf, '\n', count - *countRead))) != nullptr) {
        // found line in range [buf:eol]
        len = eol - buf + 1;

        *countRead += len;

        // actually, the line is in the range [buf:eol-1]
        if ((eol > buf) && (*(eol-1) == '\r'))
            len--;

        buf[len-1] = '\n';
        rv = ParseLineSegment(buf, len);
        if (NS_FAILED(rv))
            return rv;

        if (mHaveAllHeaders)
            return NS_OK;

        // skip over line
        buf = eol + 1;

        if (!mHttpResponseMatched) {
            // a 100 class response has caused us to throw away that set of
            // response headers and look for the next response
            return NS_ERROR_NET_INTERRUPT;
        }
    }

    // do something about a partial header line
    if (!mHaveAllHeaders && (len = count - *countRead)) {
        *countRead = count;
        // ignore a trailing carriage return, and don't bother calling
        // ParseLineSegment if buf only contains a carriage return.
        if ((buf[len-1] == '\r') && (--len == 0))
            return NS_OK;
        rv = ParseLineSegment(buf, len);
        if (NS_FAILED(rv))
            return rv;
    }
    return NS_OK;
}

nsresult
nsHttpTransaction::HandleContentStart()
{
    LOG(("nsHttpTransaction::HandleContentStart [this=%p]\n", this));
    MOZ_ASSERT(PR_GetCurrentThread() == gSocketThread);

    if (mResponseHead) {
        if (LOG3_ENABLED()) {
            LOG3(("http response [\n"));
            nsAutoCString headers;
            mResponseHead->Flatten(headers, false);
            headers.AppendLiteral("  OriginalHeaders");
            headers.AppendLiteral("\r\n");
            mResponseHead->FlattenNetworkOriginalHeaders(headers);
            LogHeaders(headers.get());
            LOG3(("]\n"));
        }

        CheckForStickyAuthScheme();

        // Save http version, mResponseHead isn't available anymore after
        // TakeResponseHead() is called
        mHttpVersion = mResponseHead->Version();
        mHttpResponseCode = mResponseHead->Status();

        // notify the connection, give it a chance to cause a reset.
        bool reset = false;
        if (!mRestartInProgressVerifier.IsSetup())
            mConnection->OnHeadersAvailable(this, mRequestHead, mResponseHead, &reset);

        // looks like we should ignore this response, resetting...
        if (reset) {
            LOG(("resetting transaction's response head\n"));
            mHaveAllHeaders = false;
            mHaveStatusLine = false;
            mReceivedData = false;
            mSentData = false;
            mHttpResponseMatched = false;
            mResponseHead->Reset();
            // wait to be called again...
            return NS_OK;
        }

        // check if this is a no-content response
        switch (mResponseHead->Status()) {
        case 101:
            mPreserveStream = true;
            MOZ_FALLTHROUGH; // to other no content cases:
        case 204:
        case 205:
        case 304:
            mNoContent = true;
            LOG(("this response should not contain a body.\n"));
            break;
        case 421:
            LOG(("Misdirected Request.\n"));
            gHttpHandler->ConnMgr()->ClearHostMapping(mConnInfo);

            // retry on a new connection - just in case
            if (!mRestartCount) {
                mCaps &= ~NS_HTTP_ALLOW_KEEPALIVE;
                mForceRestart = true; // force restart has built in loop protection
                return NS_ERROR_NET_RESET;
            }
            break;
        }

        if (mResponseHead->Status() == 200 &&
            mConnection->IsProxyConnectInProgress()) {
            // successful CONNECTs do not have response bodies
            mNoContent = true;
        }
        mConnection->SetLastTransactionExpectedNoContent(mNoContent);
        if (mInvalidResponseBytesRead)
            gHttpHandler->ConnMgr()->PipelineFeedbackInfo(
                mConnInfo, nsHttpConnectionMgr::BadInsufficientFraming,
                nullptr, mClassification);

        if (mNoContent)
            mContentLength = 0;
        else {
            // grab the content-length from the response headers
            mContentLength = mResponseHead->ContentLength();

            if ((mClassification != CLASS_SOLO) &&
                (mContentLength > mMaxPipelineObjectSize))
                CancelPipeline(nsHttpConnectionMgr::BadUnexpectedLarge);

            // handle chunked encoding here, so we'll know immediately when
            // we're done with the socket.  please note that _all_ other
            // decoding is done when the channel receives the content data
            // so as not to block the socket transport thread too much.
            if (mResponseHead->Version() >= NS_HTTP_VERSION_1_0 &&
                mResponseHead->HasHeaderValue(nsHttp::Transfer_Encoding, "chunked")) {
                // we only support the "chunked" transfer encoding right now.
                mChunkedDecoder = new nsHttpChunkedDecoder();
                LOG(("nsHttpTransaction %p chunked decoder created\n", this));
                // Ignore server specified Content-Length.
                if (mContentLength != int64_t(-1)) {
                    LOG(("nsHttpTransaction %p chunked with C-L ignores C-L\n", this));
                    mContentLength = -1;
                    if (mConnection) {
                        mConnection->DontReuse();
                    }
                }
            }
            else if (mContentLength == int64_t(-1))
                LOG(("waiting for the server to close the connection.\n"));
        }
        if (mRestartInProgressVerifier.IsSetup() &&
            !mRestartInProgressVerifier.Verify(mContentLength, mResponseHead)) {
            LOG(("Restart in progress subsequent transaction failed to match"));
            return NS_ERROR_ABORT;
        }
    }

    mDidContentStart = true;

    // The verifier only initializes itself once (from the first iteration of
    // a transaction that gets far enough to have response headers)
    if (mRequestHead->IsGet())
        mRestartInProgressVerifier.Set(mContentLength, mResponseHead);

    return NS_OK;
}

// called on the socket thread
nsresult
nsHttpTransaction::HandleContent(char *buf,
                                 uint32_t count,
                                 uint32_t *contentRead,
                                 uint32_t *contentRemaining)
{
    nsresult rv;

    LOG(("nsHttpTransaction::HandleContent [this=%p count=%u]\n", this, count));

    *contentRead = 0;
    *contentRemaining = 0;

    MOZ_ASSERT(mConnection);

    if (!mDidContentStart) {
        rv = HandleContentStart();
        if (NS_FAILED(rv)) return rv;
        // Do not write content to the pipe if we haven't started streaming yet
        if (!mDidContentStart)
            return NS_OK;
    }

    if (mChunkedDecoder) {
        // give the buf over to the chunked decoder so it can reformat the
        // data and tell us how much is really there.
        rv = mChunkedDecoder->HandleChunkedContent(buf, count, contentRead, contentRemaining);
        if (NS_FAILED(rv)) return rv;
    }
    else if (mContentLength >= int64_t(0)) {
        // HTTP/1.0 servers have been known to send erroneous Content-Length
        // headers. So, unless the connection is persistent, we must make
        // allowances for a possibly invalid Content-Length header. Thus, if
        // NOT persistent, we simply accept everything in |buf|.
        if (mConnection->IsPersistent() || mPreserveStream ||
            mHttpVersion >= NS_HTTP_VERSION_1_1) {
            int64_t remaining = mContentLength - mContentRead;
            *contentRead = uint32_t(std::min<int64_t>(count, remaining));
            *contentRemaining = count - *contentRead;
        }
        else {
            *contentRead = count;
            // mContentLength might need to be increased...
            int64_t position = mContentRead + int64_t(count);
            if (position > mContentLength) {
                mContentLength = position;
                //mResponseHead->SetContentLength(mContentLength);
            }
        }
    }
    else {
        // when we are just waiting for the server to close the connection...
        // (no explicit content-length given)
        *contentRead = count;
    }

    int64_t toReadBeforeRestart =
        mRestartInProgressVerifier.ToReadBeforeRestart();

    if (toReadBeforeRestart && *contentRead) {
        uint32_t ignore =
            static_cast<uint32_t>(std::min<int64_t>(toReadBeforeRestart, UINT32_MAX));
        ignore = std::min(*contentRead, ignore);
        LOG(("Due To Restart ignoring %d of remaining %ld",
             ignore, toReadBeforeRestart));
        *contentRead -= ignore;
        mContentRead += ignore;
        mRestartInProgressVerifier.HaveReadBeforeRestart(ignore);
        memmove(buf, buf + ignore, *contentRead + *contentRemaining);
    }

    if (*contentRead) {
        // update count of content bytes read and report progress...
        mContentRead += *contentRead;
    }

    LOG(("nsHttpTransaction::HandleContent [this=%p count=%u read=%u mContentRead=%lld mContentLength=%lld]\n",
        this, count, *contentRead, mContentRead, mContentLength));

    // Check the size of chunked responses. If we exceed the max pipeline size
    // for this response reschedule the pipeline
    if ((mClassification != CLASS_SOLO) &&
        mChunkedDecoder &&
        ((mContentRead + mChunkedDecoder->GetChunkRemaining()) >
         mMaxPipelineObjectSize)) {
        CancelPipeline(nsHttpConnectionMgr::BadUnexpectedLarge);
    }

    // check for end-of-file
    if ((mContentRead == mContentLength) ||
        (mChunkedDecoder && mChunkedDecoder->ReachedEOF())) {
        // the transaction is done with a complete response.
        mTransactionDone = true;
        mResponseIsComplete = true;
        ReleaseBlockingTransaction();

        if (TimingEnabled()) {
            SetResponseEnd(TimeStamp::Now());
        }

        // report the entire response has arrived
        if (mActivityDistributor)
            mActivityDistributor->ObserveActivity(
                mChannel,
                NS_HTTP_ACTIVITY_TYPE_HTTP_TRANSACTION,
                NS_HTTP_ACTIVITY_SUBTYPE_RESPONSE_COMPLETE,
                PR_Now(),
                static_cast<uint64_t>(mContentRead),
                EmptyCString());
    }

    return NS_OK;
}

nsresult
nsHttpTransaction::ProcessData(char *buf, uint32_t count, uint32_t *countRead)
{
    nsresult rv;

    LOG(("nsHttpTransaction::ProcessData [this=%p count=%u]\n", this, count));

    *countRead = 0;

    // we may not have read all of the headers yet...
    if (!mHaveAllHeaders) {
        uint32_t bytesConsumed = 0;

        do {
            uint32_t localBytesConsumed = 0;
            char *localBuf = buf + bytesConsumed;
            uint32_t localCount = count - bytesConsumed;

            rv = ParseHead(localBuf, localCount, &localBytesConsumed);
            if (NS_FAILED(rv) && rv != NS_ERROR_NET_INTERRUPT)
                return rv;
            bytesConsumed += localBytesConsumed;
        } while (rv == NS_ERROR_NET_INTERRUPT);

        mCurrentHttpResponseHeaderSize += bytesConsumed;
        if (mCurrentHttpResponseHeaderSize >
            gHttpHandler->MaxHttpResponseHeaderSize()) {
            LOG(("nsHttpTransaction %p The response header exceeds the limit.\n",
                 this));
            return NS_ERROR_FILE_TOO_BIG;
        }
        count -= bytesConsumed;

        // if buf has some content in it, shift bytes to top of buf.
        if (count && bytesConsumed)
            memmove(buf, buf + bytesConsumed, count);

        // report the completed response header
        if (mActivityDistributor && mResponseHead && mHaveAllHeaders &&
            !mReportedResponseHeader) {
            mReportedResponseHeader = true;
            nsAutoCString completeResponseHeaders;
            mResponseHead->Flatten(completeResponseHeaders, false);
            completeResponseHeaders.AppendLiteral("\r\n");
            mActivityDistributor->ObserveActivity(
                mChannel,
                NS_HTTP_ACTIVITY_TYPE_HTTP_TRANSACTION,
                NS_HTTP_ACTIVITY_SUBTYPE_RESPONSE_HEADER,
                PR_Now(), 0,
                completeResponseHeaders);
        }
    }

    // even though count may be 0, we still want to call HandleContent
    // so it can complete the transaction if this is a "no-content" response.
    if (mHaveAllHeaders) {
        uint32_t countRemaining = 0;
        //
        // buf layout:
        //
        // +--------------------------------------+----------------+-----+
        // |              countRead               | countRemaining |     |
        // +--------------------------------------+----------------+-----+
        //
        // count          : bytes read from the socket
        // countRead      : bytes corresponding to this transaction
        // countRemaining : bytes corresponding to next pipelined transaction
        //
        // NOTE:
        // count > countRead + countRemaining <==> chunked transfer encoding
        //
        rv = HandleContent(buf, count, countRead, &countRemaining);
        if (NS_FAILED(rv)) return rv;
        // we may have read more than our share, in which case we must give
        // the excess bytes back to the connection
        if (mResponseIsComplete && countRemaining) {
            MOZ_ASSERT(mConnection);
            mConnection->PushBack(buf + *countRead, countRemaining);
        }

        if (!mContentDecodingCheck && mResponseHead) {
            mContentDecoding =
                mResponseHead->HasHeader(nsHttp::Content_Encoding);
            mContentDecodingCheck = true;
        }
    }

    return NS_OK;
}

void
nsHttpTransaction::CancelPipeline(uint32_t reason)
{
    // reason is casted through a uint to avoid compiler header deps
    gHttpHandler->ConnMgr()->PipelineFeedbackInfo(
        mConnInfo,
        static_cast<nsHttpConnectionMgr::PipelineFeedbackInfoType>(reason),
        nullptr, mClassification);

    mConnection->CancelPipeline(NS_ERROR_ABORT);

    // Avoid pipelining this transaction on restart by classifying it as solo.
    // This also prevents BadUnexpectedLarge from being reported more
    // than one time per transaction.
    mClassification = CLASS_SOLO;
}


void
nsHttpTransaction::SetRequestContext(nsIRequestContext *aRequestContext)
{
    LOG(("nsHttpTransaction %p SetRequestContext %p\n", this, aRequestContext));
    mRequestContext = aRequestContext;
}

// Called when the transaction marked for blocking is associated with a connection
// (i.e. added to a new h1 conn, an idle http connection, or placed into
// a http pipeline). It is safe to call this multiple times with it only
// having an effect once.
void
nsHttpTransaction::DispatchedAsBlocking()
{
    if (mDispatchedAsBlocking)
        return;

    LOG(("nsHttpTransaction %p dispatched as blocking\n", this));

    if (!mRequestContext)
        return;

    LOG(("nsHttpTransaction adding blocking transaction %p from "
         "request context %p\n", this, mRequestContext.get()));

    mRequestContext->AddBlockingTransaction();
    mDispatchedAsBlocking = true;
}

void
nsHttpTransaction::RemoveDispatchedAsBlocking()
{
    if (!mRequestContext || !mDispatchedAsBlocking)
        return;

    uint32_t blockers = 0;
    nsresult rv = mRequestContext->RemoveBlockingTransaction(&blockers);

    LOG(("nsHttpTransaction removing blocking transaction %p from "
         "request context %p. %d blockers remain.\n", this,
         mRequestContext.get(), blockers));

    if (NS_SUCCEEDED(rv) && !blockers) {
        LOG(("nsHttpTransaction %p triggering release of blocked channels "
             " with request context=%p\n", this, mRequestContext.get()));
        gHttpHandler->ConnMgr()->ProcessPendingQ();
    }

    mDispatchedAsBlocking = false;
}

void
nsHttpTransaction::ReleaseBlockingTransaction()
{
    RemoveDispatchedAsBlocking();
    LOG(("nsHttpTransaction %p request context set to null "
         "in ReleaseBlockingTransaction() - was %p\n", this, mRequestContext.get()));
    mRequestContext = nullptr;
}

void
nsHttpTransaction::DisableSpdy()
{
    mCaps |= NS_HTTP_DISALLOW_SPDY;
    if (mConnInfo) {
        // This is our clone of the connection info, not the persistent one that
        // is owned by the connection manager, so we're safe to change this here
        mConnInfo->SetNoSpdy(true);
    }
}

void
nsHttpTransaction::CheckForStickyAuthScheme()
{
  LOG(("nsHttpTransaction::CheckForStickyAuthScheme this=%p"));

  MOZ_ASSERT(mHaveAllHeaders);
  MOZ_ASSERT(mResponseHead);
  MOZ_ASSERT(PR_GetCurrentThread() == gSocketThread);

  CheckForStickyAuthSchemeAt(nsHttp::WWW_Authenticate);
  CheckForStickyAuthSchemeAt(nsHttp::Proxy_Authenticate);
}

void
nsHttpTransaction::CheckForStickyAuthSchemeAt(nsHttpAtom const& header)
{
  if (mCaps & NS_HTTP_STICKY_CONNECTION) {
      LOG(("  already sticky"));
      return;
  }

  nsAutoCString auth;
  if (NS_FAILED(mResponseHead->GetHeader(header, auth))) {
      return;
  }

  Tokenizer p(auth);
  nsAutoCString schema;
  while (p.ReadWord(schema)) {
      ToLowerCase(schema);

      nsAutoCString contractid;
      contractid.Assign(NS_HTTP_AUTHENTICATOR_CONTRACTID_PREFIX);
      contractid.Append(schema);

      // using a new instance because of thread safety of auth modules refcnt
      nsCOMPtr<nsIHttpAuthenticator> authenticator(do_CreateInstance(contractid.get()));
      if (authenticator) {
          uint32_t flags;
          authenticator->GetAuthFlags(&flags);
          if (flags & nsIHttpAuthenticator::CONNECTION_BASED) {
              LOG(("  connection made sticky, found %s auth shema", schema.get()));
              // This is enough to make this transaction keep it's current connection,
              // prevents the connection from being released back to the pool.
              mCaps |= NS_HTTP_STICKY_CONNECTION;
              break;
          }
      }

      // schemes are separated with LFs, nsHttpHeaderArray::MergeHeader
      p.SkipUntil(Tokenizer::Token::NewLine());
      p.SkipWhites(Tokenizer::INCLUDE_NEW_LINE);
  }
}

const TimingStruct
nsHttpTransaction::Timings()
{
    mozilla::MutexAutoLock lock(mLock);
    TimingStruct timings = mTimings;
    return timings;
}

void
nsHttpTransaction::SetDomainLookupStart(mozilla::TimeStamp timeStamp, bool onlyIfNull)
{
    mozilla::MutexAutoLock lock(mLock);
    if (onlyIfNull && !mTimings.domainLookupStart.IsNull()) {
        return; // We only set the timestamp if it was previously null
    }
    mTimings.domainLookupStart = timeStamp;
}

void
nsHttpTransaction::SetDomainLookupEnd(mozilla::TimeStamp timeStamp, bool onlyIfNull)
{
    mozilla::MutexAutoLock lock(mLock);
    if (onlyIfNull && !mTimings.domainLookupEnd.IsNull()) {
        return; // We only set the timestamp if it was previously null
    }
    mTimings.domainLookupEnd = timeStamp;
}

void
nsHttpTransaction::SetConnectStart(mozilla::TimeStamp timeStamp, bool onlyIfNull)
{
    mozilla::MutexAutoLock lock(mLock);
    if (onlyIfNull && !mTimings.connectStart.IsNull()) {
        return; // We only set the timestamp if it was previously null
    }
    mTimings.connectStart = timeStamp;
}

void
nsHttpTransaction::SetConnectEnd(mozilla::TimeStamp timeStamp, bool onlyIfNull)
{
    mozilla::MutexAutoLock lock(mLock);
    if (onlyIfNull && !mTimings.connectEnd.IsNull()) {
        return; // We only set the timestamp if it was previously null
    }
    mTimings.connectEnd = timeStamp;
}

void
nsHttpTransaction::SetRequestStart(mozilla::TimeStamp timeStamp, bool onlyIfNull)
{
    mozilla::MutexAutoLock lock(mLock);
    if (onlyIfNull && !mTimings.requestStart.IsNull()) {
        return; // We only set the timestamp if it was previously null
    }
    mTimings.requestStart = timeStamp;
}

void
nsHttpTransaction::SetResponseStart(mozilla::TimeStamp timeStamp, bool onlyIfNull)
{
    mozilla::MutexAutoLock lock(mLock);
    if (onlyIfNull && !mTimings.responseStart.IsNull()) {
        return; // We only set the timestamp if it was previously null
    }
    mTimings.responseStart = timeStamp;
}

void
nsHttpTransaction::SetResponseEnd(mozilla::TimeStamp timeStamp, bool onlyIfNull)
{
    mozilla::MutexAutoLock lock(mLock);
    if (onlyIfNull && !mTimings.responseEnd.IsNull()) {
        return; // We only set the timestamp if it was previously null
    }
    mTimings.responseEnd = timeStamp;
}

mozilla::TimeStamp
nsHttpTransaction::GetDomainLookupStart()
{
    mozilla::MutexAutoLock lock(mLock);
    return mTimings.domainLookupStart;
}

mozilla::TimeStamp
nsHttpTransaction::GetDomainLookupEnd()
{
    mozilla::MutexAutoLock lock(mLock);
    return mTimings.domainLookupEnd;
}

mozilla::TimeStamp
nsHttpTransaction::GetConnectStart()
{
    mozilla::MutexAutoLock lock(mLock);
    return mTimings.connectStart;
}

mozilla::TimeStamp
nsHttpTransaction::GetConnectEnd()
{
    mozilla::MutexAutoLock lock(mLock);
    return mTimings.connectEnd;
}

mozilla::TimeStamp
nsHttpTransaction::GetRequestStart()
{
    mozilla::MutexAutoLock lock(mLock);
    return mTimings.requestStart;
}

mozilla::TimeStamp
nsHttpTransaction::GetResponseStart()
{
    mozilla::MutexAutoLock lock(mLock);
    return mTimings.responseStart;
}

mozilla::TimeStamp
nsHttpTransaction::GetResponseEnd()
{
    mozilla::MutexAutoLock lock(mLock);
    return mTimings.responseEnd;
}

//-----------------------------------------------------------------------------
// nsHttpTransaction deletion event
//-----------------------------------------------------------------------------

class DeleteHttpTransaction : public Runnable {
public:
    explicit DeleteHttpTransaction(nsHttpTransaction *trans)
        : mTrans(trans)
    {}

    NS_IMETHOD Run() override
    {
        delete mTrans;
        return NS_OK;
    }
private:
    nsHttpTransaction *mTrans;
};

void
nsHttpTransaction::DeleteSelfOnConsumerThread()
{
    LOG(("nsHttpTransaction::DeleteSelfOnConsumerThread [this=%p]\n", this));

    bool val;
    if (!mConsumerTarget ||
        (NS_SUCCEEDED(mConsumerTarget->IsOnCurrentThread(&val)) && val)) {
        delete this;
    } else {
        LOG(("proxying delete to consumer thread...\n"));
        nsCOMPtr<nsIRunnable> event = new DeleteHttpTransaction(this);
        if (NS_FAILED(mConsumerTarget->Dispatch(event, NS_DISPATCH_NORMAL)))
            NS_WARNING("failed to dispatch nsHttpDeleteTransaction event");
    }
}

bool
nsHttpTransaction::TryToRunPacedRequest()
{
    if (mSubmittedRatePacing)
        return mPassedRatePacing;

    mSubmittedRatePacing = true;
    mSynchronousRatePaceRequest = true;
    gHttpHandler->SubmitPacedRequest(this, getter_AddRefs(mTokenBucketCancel));
    mSynchronousRatePaceRequest = false;
    return mPassedRatePacing;
}

void
nsHttpTransaction::OnTokenBucketAdmitted()
{
    mPassedRatePacing = true;
    mTokenBucketCancel = nullptr;

    if (!mSynchronousRatePaceRequest)
        gHttpHandler->ConnMgr()->ProcessPendingQ(mConnInfo);
}

void
nsHttpTransaction::CancelPacing(nsresult reason)
{
    if (mTokenBucketCancel) {
        mTokenBucketCancel->Cancel(reason);
        mTokenBucketCancel = nullptr;
    }
}

//-----------------------------------------------------------------------------
// nsHttpTransaction::nsISupports
//-----------------------------------------------------------------------------

NS_IMPL_ADDREF(nsHttpTransaction)

NS_IMETHODIMP_(MozExternalRefCountType)
nsHttpTransaction::Release()
{
    nsrefcnt count;
    NS_PRECONDITION(0 != mRefCnt, "dup release");
    count = --mRefCnt;
    NS_LOG_RELEASE(this, count, "nsHttpTransaction");
    if (0 == count) {
        mRefCnt = 1; /* stablize */
        // it is essential that the transaction be destroyed on the consumer
        // thread (we could be holding the last reference to our consumer).
        DeleteSelfOnConsumerThread();
        return 0;
    }
    return count;
}

NS_IMPL_QUERY_INTERFACE(nsHttpTransaction,
                        nsIInputStreamCallback,
                        nsIOutputStreamCallback)

//-----------------------------------------------------------------------------
// nsHttpTransaction::nsIInputStreamCallback
//-----------------------------------------------------------------------------

// called on the socket thread
NS_IMETHODIMP
nsHttpTransaction::OnInputStreamReady(nsIAsyncInputStream *out)
{
    MOZ_ASSERT(PR_GetCurrentThread() == gSocketThread);
    if (mConnection) {
        mConnection->TransactionHasDataToWrite(this);
        nsresult rv = mConnection->ResumeSend();
        if (NS_FAILED(rv))
            NS_ERROR("ResumeSend failed");
    }
    return NS_OK;
}

//-----------------------------------------------------------------------------
// nsHttpTransaction::nsIOutputStreamCallback
//-----------------------------------------------------------------------------

// called on the socket thread
NS_IMETHODIMP
nsHttpTransaction::OnOutputStreamReady(nsIAsyncOutputStream *out)
{
    MOZ_ASSERT(PR_GetCurrentThread() == gSocketThread);
    mWaitingOnPipeOut = false;
    if (mConnection) {
        mConnection->TransactionHasDataToRecv(this);
        nsresult rv = mConnection->ResumeRecv();
        if (NS_FAILED(rv))
            NS_ERROR("ResumeRecv failed");
    }
    return NS_OK;
}

// nsHttpTransaction::RestartVerifier

static bool
matchOld(nsHttpResponseHead *newHead, nsCString &old,
         nsHttpAtom headerAtom)
{
    nsAutoCString val;

    newHead->GetHeader(headerAtom, val);
    if (!val.IsEmpty() && old.IsEmpty())
        return false;
    if (val.IsEmpty() && !old.IsEmpty())
        return false;
    if (!val.IsEmpty() && !old.Equals(val))
        return false;
    return true;
}

bool
nsHttpTransaction::RestartVerifier::Verify(int64_t contentLength,
                                           nsHttpResponseHead *newHead)
{
    if (mContentLength != contentLength)
        return false;

    if (newHead->Status() != 200)
        return false;

    if (!matchOld(newHead, mContentRange, nsHttp::Content_Range))
        return false;

    if (!matchOld(newHead, mLastModified, nsHttp::Last_Modified))
        return false;

    if (!matchOld(newHead, mETag, nsHttp::ETag))
        return false;

    if (!matchOld(newHead, mContentEncoding, nsHttp::Content_Encoding))
        return false;

    if (!matchOld(newHead, mTransferEncoding, nsHttp::Transfer_Encoding))
        return false;

    return true;
}

void
nsHttpTransaction::RestartVerifier::Set(int64_t contentLength,
                                        nsHttpResponseHead *head)
{
    if (mSetup)
        return;

    // If mSetup does not transition to true RestartInPogress() is later
    // forbidden

    // Only RestartInProgress with 200 response code
    if (!head || (head->Status() != 200)) {
        return;
    }

    mContentLength = contentLength;

    nsAutoCString val;
    if (NS_SUCCEEDED(head->GetHeader(nsHttp::ETag, val))) {
        mETag = val;
    }
    if (NS_SUCCEEDED(head->GetHeader(nsHttp::Last_Modified, val))) {
        mLastModified = val;
    }
    if (NS_SUCCEEDED(head->GetHeader(nsHttp::Content_Range, val))) {
        mContentRange = val;
    }
    if (NS_SUCCEEDED(head->GetHeader(nsHttp::Content_Encoding, val))) {
        mContentEncoding = val;
    }
    if (NS_SUCCEEDED(head->GetHeader(nsHttp::Transfer_Encoding, val))) {
        mTransferEncoding = val;
    }

    // We can only restart with any confidence if we have a stored etag or
    // last-modified header
    if (mETag.IsEmpty() && mLastModified.IsEmpty()) {
        return;
    }

    mSetup = true;
}

void
nsHttpTransaction::GetNetworkAddresses(NetAddr &self, NetAddr &peer)
{
    MutexAutoLock lock(mLock);
    self = mSelfAddr;
    peer = mPeerAddr;
}

bool
nsHttpTransaction::Do0RTT()
{
   if (mRequestHead->IsSafeMethod() &&
       !mConnection->IsProxyConnectInProgress()) {
     m0RTTInProgress = true;
   }
   return m0RTTInProgress;
}

nsresult
nsHttpTransaction::Finish0RTT(bool aRestart)
{
    MOZ_ASSERT(m0RTTInProgress);
    m0RTTInProgress = false;
    if (aRestart) {
        // Reset request headers to be sent again.
        nsCOMPtr<nsISeekableStream> seekable =
            do_QueryInterface(mRequestStream);
        if (seekable) {
            seekable->Seek(nsISeekableStream::NS_SEEK_SET, 0);
        } else {
            return NS_ERROR_FAILURE;
        }
    }
    return NS_OK;
}

} // namespace net
} // namespace mozilla
