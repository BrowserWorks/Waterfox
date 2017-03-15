/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "WebSocket.h"
#include "mozilla/dom/WebSocketBinding.h"
#include "mozilla/net/WebSocketChannel.h"

#include "jsapi.h"
#include "jsfriendapi.h"
#include "mozilla/DOMEventTargetHelper.h"
#include "mozilla/net/WebSocketChannel.h"
#include "mozilla/dom/File.h"
#include "mozilla/dom/MessageEvent.h"
#include "mozilla/dom/MessageEventBinding.h"
#include "mozilla/dom/nsCSPContext.h"
#include "mozilla/dom/nsCSPUtils.h"
#include "mozilla/dom/ScriptSettings.h"
#include "mozilla/dom/WorkerPrivate.h"
#include "mozilla/dom/WorkerRunnable.h"
#include "mozilla/dom/WorkerScope.h"
#include "nsAutoPtr.h"
#include "nsGlobalWindow.h"
#include "nsIScriptGlobalObject.h"
#include "nsIDOMWindow.h"
#include "nsIDocument.h"
#include "nsXPCOM.h"
#include "nsIXPConnect.h"
#include "nsContentUtils.h"
#include "nsError.h"
#include "nsIScriptObjectPrincipal.h"
#include "nsIURL.h"
#include "nsIUnicodeEncoder.h"
#include "nsThreadUtils.h"
#include "nsIPromptFactory.h"
#include "nsIWindowWatcher.h"
#include "nsIPrompt.h"
#include "nsIStringBundle.h"
#include "nsIConsoleService.h"
#include "mozilla/dom/CloseEvent.h"
#include "mozilla/net/WebSocketEventService.h"
#include "nsICryptoHash.h"
#include "nsJSUtils.h"
#include "nsIScriptError.h"
#include "nsNetUtil.h"
#include "nsIAuthPrompt.h"
#include "nsIAuthPrompt2.h"
#include "nsILoadGroup.h"
#include "mozilla/Preferences.h"
#include "xpcpublic.h"
#include "nsContentPolicyUtils.h"
#include "nsWrapperCacheInlines.h"
#include "nsIObserverService.h"
#include "nsIEventTarget.h"
#include "nsIInterfaceRequestor.h"
#include "nsIObserver.h"
#include "nsIRequest.h"
#include "nsIThreadRetargetableRequest.h"
#include "nsIWebSocketChannel.h"
#include "nsIWebSocketListener.h"
#include "nsProxyRelease.h"
#include "nsWeakReference.h"

using namespace mozilla::net;
using namespace mozilla::dom::workers;

namespace mozilla {
namespace dom {

class WebSocketImpl final : public nsIInterfaceRequestor
                          , public nsIWebSocketListener
                          , public nsIObserver
                          , public nsSupportsWeakReference
                          , public nsIRequest
                          , public nsIEventTarget
{
public:
  NS_DECL_NSIINTERFACEREQUESTOR
  NS_DECL_NSIWEBSOCKETLISTENER
  NS_DECL_NSIOBSERVER
  NS_DECL_NSIREQUEST
  NS_DECL_THREADSAFE_ISUPPORTS
  NS_DECL_NSIEVENTTARGET
  using nsIEventTarget::Dispatch;

  explicit WebSocketImpl(WebSocket* aWebSocket)
  : mWebSocket(aWebSocket)
  , mIsServerSide(false)
  , mSecure(false)
  , mOnCloseScheduled(false)
  , mFailed(false)
  , mDisconnectingOrDisconnected(false)
  , mCloseEventWasClean(false)
  , mCloseEventCode(nsIWebSocketChannel::CLOSE_ABNORMAL)
  , mScriptLine(0)
  , mScriptColumn(0)
  , mInnerWindowID(0)
  , mWorkerPrivate(nullptr)
#ifdef DEBUG
  , mHasWorkerHolderRegistered(false)
#endif
  , mIsMainThread(true)
  , mMutex("WebSocketImpl::mMutex")
  , mWorkerShuttingDown(false)
  {
    if (!NS_IsMainThread()) {
      mWorkerPrivate = GetCurrentThreadWorkerPrivate();
      MOZ_ASSERT(mWorkerPrivate);
      mIsMainThread = false;
    }
  }

  void AssertIsOnTargetThread() const
  {
    MOZ_ASSERT(IsTargetThread());
  }

  bool IsTargetThread() const;

  void Init(JSContext* aCx,
            nsIPrincipal* aPrincipal,
            bool aIsServerSide,
            const nsAString& aURL,
            nsTArray<nsString>& aProtocolArray,
            const nsACString& aScriptFile,
            uint32_t aScriptLine,
            uint32_t aScriptColumn,
            ErrorResult& aRv,
            bool* aConnectionFailed);

  void AsyncOpen(nsIPrincipal* aPrincipal, uint64_t aInnerWindowID,
                 nsITransportProvider* aTransportProvider,
                 const nsACString& aNegotiatedExtensions,
                 ErrorResult& aRv);

  nsresult ParseURL(const nsAString& aURL);
  nsresult InitializeConnection(nsIPrincipal* aPrincipal);

  // These methods when called can release the WebSocket object
  void FailConnection(uint16_t reasonCode,
                      const nsACString& aReasonString = EmptyCString());
  nsresult CloseConnection(uint16_t reasonCode,
                           const nsACString& aReasonString = EmptyCString());
  void Disconnect();
  void DisconnectInternal();

  nsresult ConsoleError();
  void PrintErrorOnConsole(const char* aBundleURI,
                           const char16_t* aError,
                           const char16_t** aFormatStrings,
                           uint32_t aFormatStringsLen);

  nsresult DoOnMessageAvailable(const nsACString& aMsg,
                                bool isBinary);

  // ConnectionCloseEvents: 'error' event if needed, then 'close' event.
  nsresult ScheduleConnectionCloseEvents(nsISupports* aContext,
                                         nsresult aStatusCode);
  // 2nd half of ScheduleConnectionCloseEvents, run in its own event.
  void DispatchConnectionCloseEvents();

  nsresult UpdateURI();

  void AddRefObject();
  void ReleaseObject();

  bool RegisterWorkerHolder();
  void UnregisterWorkerHolder();

  nsresult CancelInternal();

  RefPtr<WebSocket> mWebSocket;

  nsCOMPtr<nsIWebSocketChannel> mChannel;

  bool mIsServerSide; // True if we're implementing the server side of a
                      // websocket connection

  bool mSecure; // if true it is using SSL and the wss scheme,
                // otherwise it is using the ws scheme with no SSL

  bool mOnCloseScheduled;
  bool mFailed;
  bool mDisconnectingOrDisconnected;

  // Set attributes of DOM 'onclose' message
  bool      mCloseEventWasClean;
  nsString  mCloseEventReason;
  uint16_t  mCloseEventCode;

  nsCString mAsciiHost;  // hostname
  uint32_t  mPort;
  nsCString mResource; // [filepath[?query]]
  nsString  mUTF16Origin;

  nsCString mURI;
  nsCString mRequestedProtocolList;

  nsWeakPtr mOriginDocument;

  // Web Socket owner information:
  // - the script file name, UTF8 encoded.
  // - source code line number and column number where the Web Socket object
  //   was constructed.
  // - the ID of the inner window where the script lives. Note that this may not
  //   be the same as the Web Socket owner window.
  // These attributes are used for error reporting.
  nsCString mScriptFile;
  uint32_t mScriptLine;
  uint32_t mScriptColumn;
  uint64_t mInnerWindowID;

  WorkerPrivate* mWorkerPrivate;
  nsAutoPtr<WorkerHolder> mWorkerHolder;

#ifdef DEBUG
  // This is protected by mutex.
  bool mHasWorkerHolderRegistered;

  bool HasWorkerHolderRegistered()
  {
    MOZ_ASSERT(mWebSocket);
    MutexAutoLock lock(mWebSocket->mMutex);
    return mHasWorkerHolderRegistered;
  }

  void SetHasWorkerHolderRegistered(bool aValue)
  {
    MOZ_ASSERT(mWebSocket);
    MutexAutoLock lock(mWebSocket->mMutex);
    mHasWorkerHolderRegistered = aValue;
  }
#endif

  nsWeakPtr mWeakLoadGroup;

  bool mIsMainThread;

  // This mutex protects mWorkerShuttingDown.
  mozilla::Mutex mMutex;
  bool mWorkerShuttingDown;

  RefPtr<WebSocketEventService> mService;

private:
  ~WebSocketImpl()
  {
    // If we threw during Init we never called disconnect
    if (!mDisconnectingOrDisconnected) {
      Disconnect();
    }
  }
};

NS_IMPL_ISUPPORTS(WebSocketImpl,
                  nsIInterfaceRequestor,
                  nsIWebSocketListener,
                  nsIObserver,
                  nsISupportsWeakReference,
                  nsIRequest,
                  nsIEventTarget)

class CallDispatchConnectionCloseEvents final : public CancelableRunnable
{
public:
  explicit CallDispatchConnectionCloseEvents(WebSocketImpl* aWebSocketImpl)
    : mWebSocketImpl(aWebSocketImpl)
  {
    aWebSocketImpl->AssertIsOnTargetThread();
  }

  NS_IMETHOD Run() override
  {
    mWebSocketImpl->AssertIsOnTargetThread();
    mWebSocketImpl->DispatchConnectionCloseEvents();
    return NS_OK;
  }

private:
  RefPtr<WebSocketImpl> mWebSocketImpl;
};

//-----------------------------------------------------------------------------
// WebSocketImpl
//-----------------------------------------------------------------------------

namespace {

class PrintErrorOnConsoleRunnable final : public WorkerMainThreadRunnable
{
public:
  PrintErrorOnConsoleRunnable(WebSocketImpl* aImpl,
                              const char* aBundleURI,
                              const char16_t* aError,
                              const char16_t** aFormatStrings,
                              uint32_t aFormatStringsLen)
    : WorkerMainThreadRunnable(aImpl->mWorkerPrivate,
                               NS_LITERAL_CSTRING("WebSocket :: print error on console"))
    , mImpl(aImpl)
    , mBundleURI(aBundleURI)
    , mError(aError)
    , mFormatStrings(aFormatStrings)
    , mFormatStringsLen(aFormatStringsLen)
  { }

  bool MainThreadRun() override
  {
    mImpl->PrintErrorOnConsole(mBundleURI, mError, mFormatStrings,
                               mFormatStringsLen);
    return true;
  }

private:
  // Raw pointer because this runnable is sync.
  WebSocketImpl* mImpl;

  const char* mBundleURI;
  const char16_t* mError;
  const char16_t** mFormatStrings;
  uint32_t mFormatStringsLen;
};

} // namespace

void
WebSocketImpl::PrintErrorOnConsole(const char *aBundleURI,
                                   const char16_t *aError,
                                   const char16_t **aFormatStrings,
                                   uint32_t aFormatStringsLen)
{
  // This method must run on the main thread.

  if (!NS_IsMainThread()) {
    MOZ_ASSERT(mWorkerPrivate);

    RefPtr<PrintErrorOnConsoleRunnable> runnable =
      new PrintErrorOnConsoleRunnable(this, aBundleURI, aError, aFormatStrings,
                                      aFormatStringsLen);
    ErrorResult rv;
    runnable->Dispatch(rv);
    // XXXbz this seems totally broken.  We should be propagating this out, but
    // none of our callers really propagate anything usefully.  Come to think of
    // it, why is this a syncrunnable anyway?  Can't this be a fire-and-forget
    // runnable??
    rv.SuppressException();
    return;
  }

  nsresult rv;
  nsCOMPtr<nsIStringBundleService> bundleService =
    do_GetService(NS_STRINGBUNDLE_CONTRACTID, &rv);
  NS_ENSURE_SUCCESS_VOID(rv);

  nsCOMPtr<nsIStringBundle> strBundle;
  rv = bundleService->CreateBundle(aBundleURI, getter_AddRefs(strBundle));
  NS_ENSURE_SUCCESS_VOID(rv);

  nsCOMPtr<nsIConsoleService> console(
    do_GetService(NS_CONSOLESERVICE_CONTRACTID, &rv));
  NS_ENSURE_SUCCESS_VOID(rv);

  nsCOMPtr<nsIScriptError> errorObject(
    do_CreateInstance(NS_SCRIPTERROR_CONTRACTID, &rv));
  NS_ENSURE_SUCCESS_VOID(rv);

  // Localize the error message
  nsXPIDLString message;
  if (aFormatStrings) {
    rv = strBundle->FormatStringFromName(aError, aFormatStrings,
                                         aFormatStringsLen,
                                         getter_Copies(message));
  } else {
    rv = strBundle->GetStringFromName(aError, getter_Copies(message));
  }
  NS_ENSURE_SUCCESS_VOID(rv);

  if (mInnerWindowID) {
    rv = errorObject->InitWithWindowID(message,
                                       NS_ConvertUTF8toUTF16(mScriptFile),
                                       EmptyString(), mScriptLine,
                                       mScriptColumn,
                                       nsIScriptError::errorFlag, "Web Socket",
                                       mInnerWindowID);
  } else {
    rv = errorObject->Init(message,
                           NS_ConvertUTF8toUTF16(mScriptFile),
                           EmptyString(), mScriptLine, mScriptColumn,
                           nsIScriptError::errorFlag, "Web Socket");
  }

  NS_ENSURE_SUCCESS_VOID(rv);

  // print the error message directly to the JS console
  rv = console->LogMessage(errorObject);
  NS_ENSURE_SUCCESS_VOID(rv);
}

namespace {

class CancelWebSocketRunnable final : public Runnable
{
public:
  CancelWebSocketRunnable(nsIWebSocketChannel* aChannel, uint16_t aReasonCode,
                          const nsACString& aReasonString)
    : mChannel(aChannel)
    , mReasonCode(aReasonCode)
    , mReasonString(aReasonString)
  {}

  NS_IMETHOD Run() override
  {
    mChannel->Close(mReasonCode, mReasonString);
    return NS_OK;
  }

private:
  nsCOMPtr<nsIWebSocketChannel> mChannel;
  uint16_t mReasonCode;
  nsCString mReasonString;
};

class MOZ_STACK_CLASS MaybeDisconnect
{
public:
  explicit MaybeDisconnect(WebSocketImpl* aImpl)
    : mImpl(aImpl)
  {
  }

  ~MaybeDisconnect()
  {
    bool toDisconnect = false;

    {
      MutexAutoLock lock(mImpl->mMutex);
      toDisconnect = mImpl->mWorkerShuttingDown;
    }

    if (toDisconnect) {
      mImpl->Disconnect();
    }
  }

private:
  WebSocketImpl* mImpl;
};

class CloseConnectionRunnable final : public Runnable
{
public:
  CloseConnectionRunnable(WebSocketImpl* aImpl,
                          uint16_t aReasonCode,
                          const nsACString& aReasonString)
    : mImpl(aImpl)
    , mReasonCode(aReasonCode)
    , mReasonString(aReasonString)
  {}

  NS_IMETHOD Run() override
  {
    return mImpl->CloseConnection(mReasonCode, mReasonString);
  }

private:
  RefPtr<WebSocketImpl> mImpl;
  uint16_t mReasonCode;
  const nsCString mReasonString;
};

} // namespace

nsresult
WebSocketImpl::CloseConnection(uint16_t aReasonCode,
                               const nsACString& aReasonString)
{
  if (!IsTargetThread()) {
    nsCOMPtr<nsIRunnable> runnable =
      new CloseConnectionRunnable(this, aReasonCode, aReasonString);
    return Dispatch(runnable.forget(), NS_DISPATCH_NORMAL);
  }

  AssertIsOnTargetThread();

  if (mDisconnectingOrDisconnected) {
    return NS_OK;
  }

  // If this method is called because the worker is going away, we will not
  // receive the OnStop() method and we have to disconnect the WebSocket and
  // release the WorkerHolder.
  MaybeDisconnect md(this);

  uint16_t readyState = mWebSocket->ReadyState();
  if (readyState == WebSocket::CLOSING ||
      readyState == WebSocket::CLOSED) {
    return NS_OK;
  }

  // The common case...
  if (mChannel) {
    mWebSocket->SetReadyState(WebSocket::CLOSING);

    // The channel has to be closed on the main-thread.

    if (NS_IsMainThread()) {
      return mChannel->Close(aReasonCode, aReasonString);
    }

    RefPtr<CancelWebSocketRunnable> runnable =
      new CancelWebSocketRunnable(mChannel, aReasonCode, aReasonString);
    return NS_DispatchToMainThread(runnable);
  }

  // No channel, but not disconnected: canceled or failed early
  MOZ_ASSERT(readyState == WebSocket::CONNECTING,
             "Should only get here for early websocket cancel/error");

  // Server won't be sending us a close code, so use what's passed in here.
  mCloseEventCode = aReasonCode;
  CopyUTF8toUTF16(aReasonString, mCloseEventReason);

  mWebSocket->SetReadyState(WebSocket::CLOSING);

  ScheduleConnectionCloseEvents(
                    nullptr,
                    (aReasonCode == nsIWebSocketChannel::CLOSE_NORMAL ||
                     aReasonCode == nsIWebSocketChannel::CLOSE_GOING_AWAY) ?
                     NS_OK : NS_ERROR_FAILURE);

  return NS_OK;
}

nsresult
WebSocketImpl::ConsoleError()
{
  AssertIsOnTargetThread();

  {
    MutexAutoLock lock(mMutex);
    if (mWorkerShuttingDown) {
      // Too late to report anything, bail out.
      return NS_OK;
    }
  }

  NS_ConvertUTF8toUTF16 specUTF16(mURI);
  const char16_t* formatStrings[] = { specUTF16.get() };

  if (mWebSocket->ReadyState() < WebSocket::OPEN) {
    PrintErrorOnConsole("chrome://global/locale/appstrings.properties",
                        u"connectionFailure",
                        formatStrings, ArrayLength(formatStrings));
  } else {
    PrintErrorOnConsole("chrome://global/locale/appstrings.properties",
                        u"netInterrupt",
                        formatStrings, ArrayLength(formatStrings));
  }
  /// todo some specific errors - like for message too large
  return NS_OK;
}

void
WebSocketImpl::FailConnection(uint16_t aReasonCode,
                              const nsACString& aReasonString)
{
  AssertIsOnTargetThread();

  if (mDisconnectingOrDisconnected) {
    return;
  }

  ConsoleError();
  mFailed = true;
  CloseConnection(aReasonCode, aReasonString);
}

namespace {

class DisconnectInternalRunnable final : public WorkerMainThreadRunnable
{
public:
  explicit DisconnectInternalRunnable(WebSocketImpl* aImpl)
    : WorkerMainThreadRunnable(aImpl->mWorkerPrivate,
                               NS_LITERAL_CSTRING("WebSocket :: disconnect"))
    , mImpl(aImpl)
  { }

  bool MainThreadRun() override
  {
    mImpl->DisconnectInternal();
    return true;
  }

private:
  // A raw pointer because this runnable is sync.
  WebSocketImpl* mImpl;
};

} // namespace

void
WebSocketImpl::Disconnect()
{
  if (mDisconnectingOrDisconnected) {
    return;
  }

  AssertIsOnTargetThread();

  // Disconnect can be called from some control event (such as Notify() of
  // WorkerHolder). This will be schedulated before any other sync/async
  // runnable. In order to prevent some double Disconnect() calls, we use this
  // boolean.
  mDisconnectingOrDisconnected = true;

  // DisconnectInternal touches observers and nsILoadGroup and it must run on
  // the main thread.

  if (NS_IsMainThread()) {
    DisconnectInternal();
  } else {
    RefPtr<DisconnectInternalRunnable> runnable =
      new DisconnectInternalRunnable(this);
    ErrorResult rv;
    runnable->Dispatch(rv);
    // XXXbz this seems totally broken.  We should be propagating this out, but
    // where to, exactly?
    rv.SuppressException();
  }

  // DontKeepAliveAnyMore() can release the object. So hold a reference to this
  // until the end of the method.
  RefPtr<WebSocketImpl> kungfuDeathGrip = this;

  NS_ReleaseOnMainThread(mChannel.forget());
  NS_ReleaseOnMainThread(mService.forget());

  mWebSocket->DontKeepAliveAnyMore();
  mWebSocket->mImpl = nullptr;

  if (mWorkerPrivate && mWorkerHolder) {
    UnregisterWorkerHolder();
  }

  // We want to release the WebSocket in the correct thread.
  mWebSocket = nullptr;
}

void
WebSocketImpl::DisconnectInternal()
{
  AssertIsOnMainThread();

  nsCOMPtr<nsILoadGroup> loadGroup = do_QueryReferent(mWeakLoadGroup);
  if (loadGroup) {
    loadGroup->RemoveRequest(this, nullptr, NS_OK);
    // mWeakLoadGroup has to be release on main-thread because WeakReferences
    // are not thread-safe.
    mWeakLoadGroup = nullptr;
  }

  if (!mWorkerPrivate) {
    nsCOMPtr<nsIObserverService> os = mozilla::services::GetObserverService();
    if (os) {
      os->RemoveObserver(this, DOM_WINDOW_DESTROYED_TOPIC);
      os->RemoveObserver(this, DOM_WINDOW_FROZEN_TOPIC);
    }
  }
}

//-----------------------------------------------------------------------------
// WebSocketImpl::nsIWebSocketListener methods:
//-----------------------------------------------------------------------------

nsresult
WebSocketImpl::DoOnMessageAvailable(const nsACString& aMsg, bool isBinary)
{
  AssertIsOnTargetThread();

  if (mDisconnectingOrDisconnected) {
    return NS_OK;
  }

  int16_t readyState = mWebSocket->ReadyState();
  if (readyState == WebSocket::CLOSED) {
    NS_ERROR("Received message after CLOSED");
    return NS_ERROR_UNEXPECTED;
  }

  if (readyState == WebSocket::OPEN) {
    // Dispatch New Message
    nsresult rv = mWebSocket->CreateAndDispatchMessageEvent(aMsg, isBinary);
    if (NS_FAILED(rv)) {
      NS_WARNING("Failed to dispatch the message event");
    }

    return NS_OK;
  }

  // CLOSING should be the only other state where it's possible to get msgs
  // from channel: Spec says to drop them.
  MOZ_ASSERT(readyState == WebSocket::CLOSING,
             "Received message while CONNECTING or CLOSED");
  return NS_OK;
}

NS_IMETHODIMP
WebSocketImpl::OnMessageAvailable(nsISupports* aContext,
                                  const nsACString& aMsg)
{
  AssertIsOnTargetThread();

  if (mDisconnectingOrDisconnected) {
    return NS_OK;
  }

  return DoOnMessageAvailable(aMsg, false);
}

NS_IMETHODIMP
WebSocketImpl::OnBinaryMessageAvailable(nsISupports* aContext,
                                        const nsACString& aMsg)
{
  AssertIsOnTargetThread();

  if (mDisconnectingOrDisconnected) {
    return NS_OK;
  }

  return DoOnMessageAvailable(aMsg, true);
}

NS_IMETHODIMP
WebSocketImpl::OnStart(nsISupports* aContext)
{
  AssertIsOnTargetThread();

  if (mDisconnectingOrDisconnected) {
    return NS_OK;
  }

  int16_t readyState = mWebSocket->ReadyState();

  // This is the only function that sets OPEN, and should be called only once
  MOZ_ASSERT(readyState != WebSocket::OPEN,
             "readyState already OPEN! OnStart called twice?");

  // Nothing to do if we've already closed/closing
  if (readyState != WebSocket::CONNECTING) {
    return NS_OK;
  }

  // Attempt to kill "ghost" websocket: but usually too early for check to fail
  nsresult rv = mWebSocket->CheckInnerWindowCorrectness();
  if (NS_FAILED(rv)) {
    CloseConnection(nsIWebSocketChannel::CLOSE_GOING_AWAY);
    return rv;
  }

  if (!mRequestedProtocolList.IsEmpty()) {
    mChannel->GetProtocol(mWebSocket->mEstablishedProtocol);
  }

  mChannel->GetExtensions(mWebSocket->mEstablishedExtensions);
  UpdateURI();

  mWebSocket->SetReadyState(WebSocket::OPEN);

  mService->WebSocketOpened(mChannel->Serial(),mInnerWindowID,
                            mWebSocket->mEffectiveURL,
                            mWebSocket->mEstablishedProtocol,
                            mWebSocket->mEstablishedExtensions);

  // Let's keep the object alive because the webSocket can be CCed in the
  // onopen callback.
  RefPtr<WebSocket> webSocket = mWebSocket;

  // Call 'onopen'
  rv = webSocket->CreateAndDispatchSimpleEvent(NS_LITERAL_STRING("open"));
  if (NS_FAILED(rv)) {
    NS_WARNING("Failed to dispatch the open event");
  }

  webSocket->UpdateMustKeepAlive();
  return NS_OK;
}

NS_IMETHODIMP
WebSocketImpl::OnStop(nsISupports* aContext, nsresult aStatusCode)
{
  AssertIsOnTargetThread();

  if (mDisconnectingOrDisconnected) {
    return NS_OK;
  }

  // We can be CONNECTING here if connection failed.
  // We can be OPEN if we have encountered a fatal protocol error
  // We can be CLOSING if close() was called and/or server initiated close.
  MOZ_ASSERT(mWebSocket->ReadyState() != WebSocket::CLOSED,
             "Shouldn't already be CLOSED when OnStop called");

  return ScheduleConnectionCloseEvents(aContext, aStatusCode);
}

nsresult
WebSocketImpl::ScheduleConnectionCloseEvents(nsISupports* aContext,
                                             nsresult aStatusCode)
{
  AssertIsOnTargetThread();

  // no-op if some other code has already initiated close event
  if (!mOnCloseScheduled) {
    mCloseEventWasClean = NS_SUCCEEDED(aStatusCode);

    if (aStatusCode == NS_BASE_STREAM_CLOSED) {
      // don't generate an error event just because of an unclean close
      aStatusCode = NS_OK;
    }

    if (NS_FAILED(aStatusCode)) {
      ConsoleError();
      mFailed = true;
    }

    mOnCloseScheduled = true;

    NS_DispatchToCurrentThread(new CallDispatchConnectionCloseEvents(this));
  }

  return NS_OK;
}

NS_IMETHODIMP
WebSocketImpl::OnAcknowledge(nsISupports *aContext, uint32_t aSize)
{
  AssertIsOnTargetThread();

  if (mDisconnectingOrDisconnected) {
    return NS_OK;
  }

  if (aSize > mWebSocket->mOutgoingBufferedAmount) {
    return NS_ERROR_UNEXPECTED;
  }

  mWebSocket->mOutgoingBufferedAmount -= aSize;
  return NS_OK;
}

NS_IMETHODIMP
WebSocketImpl::OnServerClose(nsISupports *aContext, uint16_t aCode,
                             const nsACString &aReason)
{
  AssertIsOnTargetThread();

  if (mDisconnectingOrDisconnected) {
    return NS_OK;
  }

  int16_t readyState = mWebSocket->ReadyState();

  MOZ_ASSERT(readyState != WebSocket::CONNECTING,
             "Received server close before connected?");
  MOZ_ASSERT(readyState != WebSocket::CLOSED,
             "Received server close after already closed!");

  // store code/string for onclose DOM event
  mCloseEventCode = aCode;
  CopyUTF8toUTF16(aReason, mCloseEventReason);

  if (readyState == WebSocket::OPEN) {
    // Server initiating close.
    // RFC 6455, 5.5.1: "When sending a Close frame in response, the endpoint
    // typically echos the status code it received".
    // But never send certain codes, per section 7.4.1
    if (aCode == 1005 || aCode == 1006 || aCode == 1015) {
      CloseConnection(0, EmptyCString());
    } else {
      CloseConnection(aCode, aReason);
    }
  } else {
    // We initiated close, and server has replied: OnStop does rest of the work.
    MOZ_ASSERT(readyState == WebSocket::CLOSING, "unknown state");
  }

  return NS_OK;
}

//-----------------------------------------------------------------------------
// WebSocketImpl::nsIInterfaceRequestor
//-----------------------------------------------------------------------------

NS_IMETHODIMP
WebSocketImpl::GetInterface(const nsIID& aIID, void** aResult)
{
  AssertIsOnMainThread();

  if (!mWebSocket || mWebSocket->ReadyState() == WebSocket::CLOSED) {
    return NS_ERROR_FAILURE;
  }

  if (aIID.Equals(NS_GET_IID(nsIAuthPrompt)) ||
      aIID.Equals(NS_GET_IID(nsIAuthPrompt2))) {
    nsCOMPtr<nsPIDOMWindowInner> win = mWebSocket->GetWindowIfCurrent();
    if (!win) {
      return NS_ERROR_NOT_AVAILABLE;
    }

    nsresult rv;
    nsCOMPtr<nsIPromptFactory> wwatch =
      do_GetService(NS_WINDOWWATCHER_CONTRACTID, &rv);
    NS_ENSURE_SUCCESS(rv, rv);

    nsCOMPtr<nsPIDOMWindowOuter> outerWindow = win->GetOuterWindow();
    return wwatch->GetPrompt(outerWindow, aIID, aResult);
  }

  return QueryInterface(aIID, aResult);
}

////////////////////////////////////////////////////////////////////////////////
// WebSocket
////////////////////////////////////////////////////////////////////////////////

WebSocket::WebSocket(nsPIDOMWindowInner* aOwnerWindow)
  : DOMEventTargetHelper(aOwnerWindow)
  , mIsMainThread(true)
  , mKeepingAlive(false)
  , mCheckMustKeepAlive(true)
  , mOutgoingBufferedAmount(0)
  , mBinaryType(dom::BinaryType::Blob)
  , mMutex("WebSocket::mMutex")
  , mReadyState(CONNECTING)
{
  mImpl = new WebSocketImpl(this);
  mIsMainThread = mImpl->mIsMainThread;
}

WebSocket::~WebSocket()
{
}

JSObject*
WebSocket::WrapObject(JSContext* cx, JS::Handle<JSObject*> aGivenProto)
{
  return WebSocketBinding::Wrap(cx, this, aGivenProto);
}

//---------------------------------------------------------------------------
// WebIDL
//---------------------------------------------------------------------------

// Constructor:
already_AddRefed<WebSocket>
WebSocket::Constructor(const GlobalObject& aGlobal,
                       const nsAString& aUrl,
                       ErrorResult& aRv)
{
  Sequence<nsString> protocols;
  return WebSocket::ConstructorCommon(aGlobal, aUrl, protocols, nullptr,
                                      EmptyCString(), aRv);
}

already_AddRefed<WebSocket>
WebSocket::Constructor(const GlobalObject& aGlobal,
                       const nsAString& aUrl,
                       const nsAString& aProtocol,
                       ErrorResult& aRv)
{
  Sequence<nsString> protocols;
  if (!protocols.AppendElement(aProtocol, fallible)) {
    aRv.Throw(NS_ERROR_OUT_OF_MEMORY);
    return nullptr;
  }

  return WebSocket::ConstructorCommon(aGlobal, aUrl, protocols, nullptr,
                                      EmptyCString(), aRv);
}

already_AddRefed<WebSocket>
WebSocket::Constructor(const GlobalObject& aGlobal,
                       const nsAString& aUrl,
                       const Sequence<nsString>& aProtocols,
                       ErrorResult& aRv)
{
  return WebSocket::ConstructorCommon(aGlobal, aUrl, aProtocols, nullptr,
                                      EmptyCString(), aRv);
}

already_AddRefed<WebSocket>
WebSocket::CreateServerWebSocket(const GlobalObject& aGlobal,
                                 const nsAString& aUrl,
                                 const Sequence<nsString>& aProtocols,
                                 nsITransportProvider* aTransportProvider,
                                 const nsAString& aNegotiatedExtensions,
                                 ErrorResult& aRv)
{
  return WebSocket::ConstructorCommon(aGlobal, aUrl, aProtocols, aTransportProvider,
                                      NS_ConvertUTF16toUTF8(aNegotiatedExtensions), aRv);
}

namespace {

// This class is used to clear any exception.
class MOZ_STACK_CLASS ClearException
{
public:
  explicit ClearException(JSContext* aCx)
    : mCx(aCx)
  {
  }

  ~ClearException()
  {
    JS_ClearPendingException(mCx);
  }

private:
  JSContext* mCx;
};

class WebSocketMainThreadRunnable : public WorkerMainThreadRunnable
{
public:
  WebSocketMainThreadRunnable(WorkerPrivate* aWorkerPrivate,
                              const nsACString& aTelemetryKey)
    : WorkerMainThreadRunnable(aWorkerPrivate, aTelemetryKey)
  {
    MOZ_ASSERT(aWorkerPrivate);
    aWorkerPrivate->AssertIsOnWorkerThread();
  }

  bool MainThreadRun() override
  {
    AssertIsOnMainThread();

    // Walk up to our containing page
    WorkerPrivate* wp = mWorkerPrivate;
    while (wp->GetParent()) {
      wp = wp->GetParent();
    }

    nsPIDOMWindowInner* window = wp->GetWindow();
    if (window) {
      return InitWithWindow(window);
    }

    return InitWindowless(wp);
  }

protected:
  virtual bool InitWithWindow(nsPIDOMWindowInner* aWindow) = 0;

  virtual bool InitWindowless(WorkerPrivate* aTopLevelWorkerPrivate) = 0;
};

class InitRunnable final : public WebSocketMainThreadRunnable
{
public:
  InitRunnable(WebSocketImpl* aImpl, bool aIsServerSide,
               const nsAString& aURL,
               nsTArray<nsString>& aProtocolArray,
               const nsACString& aScriptFile, uint32_t aScriptLine,
               uint32_t aScriptColumn,
               ErrorResult& aRv, bool* aConnectionFailed)
    : WebSocketMainThreadRunnable(aImpl->mWorkerPrivate,
                                  NS_LITERAL_CSTRING("WebSocket :: init"))
    , mImpl(aImpl)
    , mIsServerSide(aIsServerSide)
    , mURL(aURL)
    , mProtocolArray(aProtocolArray)
    , mScriptFile(aScriptFile)
    , mScriptLine(aScriptLine)
    , mScriptColumn(aScriptColumn)
    , mRv(aRv)
    , mConnectionFailed(aConnectionFailed)
  {
    MOZ_ASSERT(mWorkerPrivate);
    mWorkerPrivate->AssertIsOnWorkerThread();
  }

protected:
  virtual bool InitWithWindow(nsPIDOMWindowInner* aWindow) override
  {
    AutoJSAPI jsapi;
    if (NS_WARN_IF(!jsapi.Init(aWindow))) {
      mRv.Throw(NS_ERROR_FAILURE);
      return true;
    }

    ClearException ce(jsapi.cx());

    nsIDocument* doc = aWindow->GetExtantDoc();
    if (!doc) {
      mRv.Throw(NS_ERROR_FAILURE);
      return true;
    }

    nsCOMPtr<nsIPrincipal> principal = doc->NodePrincipal();
    if (!principal) {
      mRv.Throw(NS_ERROR_FAILURE);
      return true;
    }

    mImpl->Init(jsapi.cx(), principal, mIsServerSide, mURL, mProtocolArray,
                mScriptFile, mScriptLine, mScriptColumn, mRv,
                mConnectionFailed);
    return true;
  }

  virtual bool InitWindowless(WorkerPrivate* aTopLevelWorkerPrivate) override
  {
    MOZ_ASSERT(NS_IsMainThread());
    MOZ_ASSERT(aTopLevelWorkerPrivate && !aTopLevelWorkerPrivate->GetWindow());

    mImpl->Init(nullptr, aTopLevelWorkerPrivate->GetPrincipal(), mIsServerSide,
                mURL, mProtocolArray, mScriptFile, mScriptLine, mScriptColumn,
                mRv, mConnectionFailed);
    return true;
  }

  // Raw pointer. This worker runs synchronously.
  WebSocketImpl* mImpl;

  bool mIsServerSide;
  const nsAString& mURL;
  nsTArray<nsString>& mProtocolArray;
  nsCString mScriptFile;
  uint32_t mScriptLine;
  uint32_t mScriptColumn;
  ErrorResult& mRv;
  bool* mConnectionFailed;
};

class AsyncOpenRunnable final : public WebSocketMainThreadRunnable
{
public:
  AsyncOpenRunnable(WebSocketImpl* aImpl, ErrorResult& aRv)
    : WebSocketMainThreadRunnable(aImpl->mWorkerPrivate,
                                  NS_LITERAL_CSTRING("WebSocket :: AsyncOpen"))
    , mImpl(aImpl)
    , mRv(aRv)
  {
    MOZ_ASSERT(mWorkerPrivate);
    mWorkerPrivate->AssertIsOnWorkerThread();
  }

protected:
  virtual bool InitWithWindow(nsPIDOMWindowInner* aWindow) override
  {
    AssertIsOnMainThread();
    MOZ_ASSERT(aWindow);

    nsIDocument* doc = aWindow->GetExtantDoc();
    if (!doc) {
      mRv.Throw(NS_ERROR_FAILURE);
      return true;
    }

    nsCOMPtr<nsIPrincipal> principal = doc->NodePrincipal();
    if (!principal) {
      mRv.Throw(NS_ERROR_FAILURE);
      return true;
    }

    uint64_t windowID = 0;
    nsCOMPtr<nsPIDOMWindowOuter> topWindow = aWindow->GetScriptableTop();
    nsCOMPtr<nsPIDOMWindowInner> topInner;
    if (topWindow) {
      topInner = topWindow->GetCurrentInnerWindow();
    }

    if (topInner) {
      windowID = topInner->WindowID();
    }

    mImpl->AsyncOpen(principal, windowID, nullptr, EmptyCString(), mRv);
    return true;
  }

  virtual bool InitWindowless(WorkerPrivate* aTopLevelWorkerPrivate) override
  {
    MOZ_ASSERT(NS_IsMainThread());
    MOZ_ASSERT(aTopLevelWorkerPrivate && !aTopLevelWorkerPrivate->GetWindow());

    mImpl->AsyncOpen(aTopLevelWorkerPrivate->GetPrincipal(), 0, nullptr,
                     EmptyCString(), mRv);
    return true;
  }

private:
  // Raw pointer. This worker runs synchronously.
  WebSocketImpl* mImpl;

  ErrorResult& mRv;
};

} // namespace

already_AddRefed<WebSocket>
WebSocket::ConstructorCommon(const GlobalObject& aGlobal,
                             const nsAString& aUrl,
                             const Sequence<nsString>& aProtocols,
                             nsITransportProvider* aTransportProvider,
                             const nsACString& aNegotiatedExtensions,
                             ErrorResult& aRv)
{
  MOZ_ASSERT_IF(!aTransportProvider, aNegotiatedExtensions.IsEmpty());
  nsCOMPtr<nsIPrincipal> principal;
  nsCOMPtr<nsPIDOMWindowInner> ownerWindow;

  if (NS_IsMainThread()) {
    nsCOMPtr<nsIScriptObjectPrincipal> scriptPrincipal =
      do_QueryInterface(aGlobal.GetAsSupports());
    if (!scriptPrincipal) {
      aRv.Throw(NS_ERROR_FAILURE);
      return nullptr;
    }

    principal = scriptPrincipal->GetPrincipal();
    if (!principal) {
      aRv.Throw(NS_ERROR_FAILURE);
      return nullptr;
    }

    nsCOMPtr<nsIScriptGlobalObject> sgo =
      do_QueryInterface(aGlobal.GetAsSupports());
    if (!sgo) {
      aRv.Throw(NS_ERROR_FAILURE);
      return nullptr;
    }

    ownerWindow = do_QueryInterface(aGlobal.GetAsSupports());
    if (!ownerWindow) {
      aRv.Throw(NS_ERROR_FAILURE);
      return nullptr;
    }
  }

  MOZ_ASSERT_IF(ownerWindow, ownerWindow->IsInnerWindow());

  nsTArray<nsString> protocolArray;

  for (uint32_t index = 0, len = aProtocols.Length(); index < len; ++index) {

    const nsString& protocolElement = aProtocols[index];

    if (protocolElement.IsEmpty()) {
      aRv.Throw(NS_ERROR_DOM_SYNTAX_ERR);
      return nullptr;
    }
    if (protocolArray.Contains(protocolElement)) {
      aRv.Throw(NS_ERROR_DOM_SYNTAX_ERR);
      return nullptr;
    }
    if (protocolElement.FindChar(',') != -1)  /* interferes w/list */ {
      aRv.Throw(NS_ERROR_DOM_SYNTAX_ERR);
      return nullptr;
    }

    protocolArray.AppendElement(protocolElement);
  }

  RefPtr<WebSocket> webSocket = new WebSocket(ownerWindow);
  RefPtr<WebSocketImpl> webSocketImpl = webSocket->mImpl;

  bool connectionFailed = true;

  if (NS_IsMainThread()) {
    webSocketImpl->Init(aGlobal.Context(), principal, !!aTransportProvider,
                        aUrl, protocolArray, EmptyCString(),
                        0, 0, aRv, &connectionFailed);
  } else {
    // In workers we have to keep the worker alive using a workerHolder in order
    // to dispatch messages correctly.
    if (!webSocketImpl->RegisterWorkerHolder()) {
      aRv.Throw(NS_ERROR_FAILURE);
      return nullptr;
    }

    unsigned lineno, column;
    JS::AutoFilename file;
    if (!JS::DescribeScriptedCaller(aGlobal.Context(), &file, &lineno,
                                    &column)) {
      NS_WARNING("Failed to get line number and filename in workers.");
    }

    RefPtr<InitRunnable> runnable =
      new InitRunnable(webSocketImpl, !!aTransportProvider, aUrl,
                       protocolArray, nsDependentCString(file.get()), lineno,
                       column, aRv, &connectionFailed);
    runnable->Dispatch(aRv);
  }

  if (NS_WARN_IF(aRv.Failed())) {
    return nullptr;
  }

  // It can be that we have been already disconnected because the WebSocket is
  // gone away while we where initializing the webSocket.
  if (!webSocket->mImpl) {
    aRv.Throw(NS_ERROR_FAILURE);
    return nullptr;
  }

  // We don't return an error if the connection just failed. Instead we dispatch
  // an event.
  if (connectionFailed) {
    webSocket->mImpl->FailConnection(nsIWebSocketChannel::CLOSE_ABNORMAL);
  }

  // If we don't have a channel, the connection is failed and onerror() will be
  // called asynchrounsly.
  if (!webSocket->mImpl->mChannel) {
    return webSocket.forget();
  }

  class MOZ_STACK_CLASS ClearWebSocket
  {
  public:
    explicit ClearWebSocket(WebSocketImpl* aWebSocketImpl)
      : mWebSocketImpl(aWebSocketImpl)
      , mDone(false)
    {
    }

    void Done()
    {
       mDone = true;
    }

    ~ClearWebSocket()
    {
      if (!mDone) {
        mWebSocketImpl->mChannel = nullptr;
        mWebSocketImpl->FailConnection(nsIWebSocketChannel::CLOSE_ABNORMAL);
      }
    }

    WebSocketImpl* mWebSocketImpl;
    bool mDone;
  };

  ClearWebSocket cws(webSocket->mImpl);

  // This operation must be done on the correct thread. The rest must run on the
  // main-thread.
  aRv = webSocket->mImpl->mChannel->SetNotificationCallbacks(webSocket->mImpl);
  if (NS_WARN_IF(aRv.Failed())) {
    return nullptr;
  }

  if (NS_IsMainThread()) {
    MOZ_ASSERT(principal);

    nsPIDOMWindowOuter* outerWindow = ownerWindow->GetOuterWindow();

    uint64_t windowID = 0;
    nsCOMPtr<nsPIDOMWindowOuter> topWindow = outerWindow->GetScriptableTop();
    nsCOMPtr<nsPIDOMWindowInner> topInner;
    if (topWindow) {
      topInner = topWindow->GetCurrentInnerWindow();
    }

    if (topInner) {
      windowID = topInner->WindowID();
    }

    webSocket->mImpl->AsyncOpen(principal, windowID, aTransportProvider,
                                aNegotiatedExtensions, aRv);
  } else {
    MOZ_ASSERT(!aTransportProvider && aNegotiatedExtensions.IsEmpty(),
               "not yet implemented");
    RefPtr<AsyncOpenRunnable> runnable =
      new AsyncOpenRunnable(webSocket->mImpl, aRv);
    runnable->Dispatch(aRv);
  }

  if (NS_WARN_IF(aRv.Failed())) {
    return nullptr;
  }

  // It can be that we have been already disconnected because the WebSocket is
  // gone away while we where initializing the webSocket.
  if (!webSocket->mImpl) {
    aRv.Throw(NS_ERROR_FAILURE);
    return nullptr;
  }

  // Let's inform devtools about this new active WebSocket.
  webSocket->mImpl->mService->WebSocketCreated(webSocket->mImpl->mChannel->Serial(),
                                               webSocket->mImpl->mInnerWindowID,
                                               webSocket->mURI,
                                               webSocket->mImpl->mRequestedProtocolList);

  cws.Done();
  return webSocket.forget();
}

NS_IMPL_CYCLE_COLLECTION_CLASS(WebSocket)

NS_IMPL_CYCLE_COLLECTION_CAN_SKIP_BEGIN(WebSocket)
  bool isBlack = tmp->IsBlack();
  if (isBlack || tmp->mKeepingAlive) {
    if (tmp->mListenerManager) {
      tmp->mListenerManager->MarkForCC();
    }
    if (!isBlack && tmp->PreservingWrapper()) {
      // This marks the wrapper black.
      tmp->GetWrapper();
    }
    return true;
  }
NS_IMPL_CYCLE_COLLECTION_CAN_SKIP_END

NS_IMPL_CYCLE_COLLECTION_CAN_SKIP_IN_CC_BEGIN(WebSocket)
  return tmp->IsBlack();
NS_IMPL_CYCLE_COLLECTION_CAN_SKIP_IN_CC_END

NS_IMPL_CYCLE_COLLECTION_CAN_SKIP_THIS_BEGIN(WebSocket)
  return tmp->IsBlack();
NS_IMPL_CYCLE_COLLECTION_CAN_SKIP_THIS_END

NS_IMPL_CYCLE_COLLECTION_TRACE_BEGIN_INHERITED(WebSocket,
                                               DOMEventTargetHelper)
NS_IMPL_CYCLE_COLLECTION_TRACE_END

NS_IMPL_CYCLE_COLLECTION_TRAVERSE_BEGIN_INHERITED(WebSocket,
                                                  DOMEventTargetHelper)
  if (tmp->mImpl) {
    NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mImpl->mChannel)
  }
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_END

NS_IMPL_CYCLE_COLLECTION_UNLINK_BEGIN_INHERITED(WebSocket,
                                                DOMEventTargetHelper)
  if (tmp->mImpl) {
    NS_IMPL_CYCLE_COLLECTION_UNLINK(mImpl->mChannel)
    tmp->mImpl->Disconnect();
    MOZ_ASSERT(!tmp->mImpl);
  }
NS_IMPL_CYCLE_COLLECTION_UNLINK_END

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION_INHERITED(WebSocket)
NS_INTERFACE_MAP_END_INHERITING(DOMEventTargetHelper)

NS_IMPL_ADDREF_INHERITED(WebSocket, DOMEventTargetHelper)
NS_IMPL_RELEASE_INHERITED(WebSocket, DOMEventTargetHelper)

void
WebSocket::DisconnectFromOwner()
{
  AssertIsOnMainThread();
  DOMEventTargetHelper::DisconnectFromOwner();

  if (mImpl) {
    mImpl->CloseConnection(nsIWebSocketChannel::CLOSE_GOING_AWAY);
  }

  DontKeepAliveAnyMore();
}

//-----------------------------------------------------------------------------
// WebSocketImpl:: initialization
//-----------------------------------------------------------------------------

void
WebSocketImpl::Init(JSContext* aCx,
                    nsIPrincipal* aPrincipal,
                    bool aIsServerSide,
                    const nsAString& aURL,
                    nsTArray<nsString>& aProtocolArray,
                    const nsACString& aScriptFile,
                    uint32_t aScriptLine,
                    uint32_t aScriptColumn,
                    ErrorResult& aRv,
                    bool* aConnectionFailed)
{
  AssertIsOnMainThread();
  MOZ_ASSERT(aPrincipal);

  mService = WebSocketEventService::GetOrCreate();

  // We need to keep the implementation alive in case the init disconnects it
  // because of some error.
  RefPtr<WebSocketImpl> kungfuDeathGrip = this;

  // Attempt to kill "ghost" websocket: but usually too early for check to fail
  aRv = mWebSocket->CheckInnerWindowCorrectness();
  if (NS_WARN_IF(aRv.Failed())) {
    return;
  }

  // Shut down websocket if window is frozen or destroyed (only needed for
  // "ghost" websockets--see bug 696085)
  if (!mWorkerPrivate) {
    nsCOMPtr<nsIObserverService> os = mozilla::services::GetObserverService();
    if (NS_WARN_IF(!os)) {
      aRv.Throw(NS_ERROR_FAILURE);
      return;
    }

    aRv = os->AddObserver(this, DOM_WINDOW_DESTROYED_TOPIC, true);
    if (NS_WARN_IF(aRv.Failed())) {
      return;
    }

    aRv = os->AddObserver(this, DOM_WINDOW_FROZEN_TOPIC, true);
    if (NS_WARN_IF(aRv.Failed())) {
      return;
    }
  }

  if (mWorkerPrivate) {
    mScriptFile = aScriptFile;
    mScriptLine = aScriptLine;
    mScriptColumn = aScriptColumn;
  } else {
    MOZ_ASSERT(aCx);

    unsigned lineno, column;
    JS::AutoFilename file;
    if (JS::DescribeScriptedCaller(aCx, &file, &lineno, &column)) {
      mScriptFile = file.get();
      mScriptLine = lineno;
      mScriptColumn = column;
    }
  }

  mIsServerSide = aIsServerSide;

  // If we don't have aCx, we are window-less, so we don't have a
  // inner-windowID. This can happen in sharedWorkers and ServiceWorkers or in
  // DedicateWorkers created by JSM.
  if (aCx) {
    mInnerWindowID = nsJSUtils::GetCurrentlyRunningCodeInnerWindowID(aCx);
  }

  // parses the url
  aRv = ParseURL(PromiseFlatString(aURL));
  if (NS_WARN_IF(aRv.Failed())) {
    return;
  }

  nsCOMPtr<nsIDocument> originDoc = mWebSocket->GetDocumentIfCurrent();
  if (!originDoc) {
    nsresult rv = mWebSocket->CheckInnerWindowCorrectness();
    if (NS_WARN_IF(NS_FAILED(rv))) {
      aRv.Throw(rv);
      return;
    }
  }
  mOriginDocument = do_GetWeakReference(originDoc);

  if (!mIsServerSide) {
    nsCOMPtr<nsIURI> uri;
    {
      nsresult rv = NS_NewURI(getter_AddRefs(uri), mURI);

      // We crash here because we are sure that mURI is a valid URI, so either we
      // are OOM'ing or something else bad is happening.
      if (NS_WARN_IF(NS_FAILED(rv))) {
        MOZ_CRASH();
      }
    }

    // The 'real' nsHttpChannel of the websocket gets opened in the parent.
    // Since we don't serialize the CSP within child and parent and also not
    // the context, we have to perform content policy checks here instead of
    // AsyncOpen2().
    // Please note that websockets can't follow redirects, hence there is no
    // need to perform a CSP check after redirects.
    int16_t shouldLoad = nsIContentPolicy::ACCEPT;
    aRv = NS_CheckContentLoadPolicy(nsIContentPolicy::TYPE_WEBSOCKET,
                                    uri,
                                    aPrincipal,
                                    originDoc,
                                    EmptyCString(),
                                    nullptr,
                                    &shouldLoad,
                                    nsContentUtils::GetContentPolicy(),
                                    nsContentUtils::GetSecurityManager());

    if (NS_WARN_IF(aRv.Failed())) {
      return;
    }

    if (NS_CP_REJECTED(shouldLoad)) {
      // Disallowed by content policy
      aRv.Throw(NS_ERROR_CONTENT_BLOCKED);
      return;
    }
  }

  // Potentially the page uses the CSP directive 'upgrade-insecure-requests'.
  // In such a case we have to upgrade ws: to wss: and also update mSecure
  // to reflect that upgrade. Please note that we can not upgrade from ws:
  // to wss: before performing content policy checks because CSP needs to
  // send reports in case the scheme is about to be upgraded.
  if (!mIsServerSide && !mSecure && originDoc &&
      originDoc->GetUpgradeInsecureRequests(false)) {
    // let's use the old specification before the upgrade for logging
    NS_ConvertUTF8toUTF16 reportSpec(mURI);

    // upgrade the request from ws:// to wss:// and mark as secure
    mURI.ReplaceSubstring("ws://", "wss://");
    if (NS_WARN_IF(mURI.Find("wss://") != 0)) {
      return;
    }
    mSecure = true;

    const char16_t* params[] = { reportSpec.get(), u"wss" };
    CSP_LogLocalizedStr(u"upgradeInsecureRequest",
                        params, ArrayLength(params),
                        EmptyString(), // aSourceFile
                        EmptyString(), // aScriptSample
                        0, // aLineNumber
                        0, // aColumnNumber
                        nsIScriptError::warningFlag, "CSP",
                        mInnerWindowID);
  }

  // Don't allow https:// to open ws://
  if (!mIsServerSide && !mSecure &&
      !Preferences::GetBool("network.websocket.allowInsecureFromHTTPS",
                            false)) {
    // Confirmed we are opening plain ws:// and want to prevent this from a
    // secure context (e.g. https).
    nsCOMPtr<nsIPrincipal> principal;
    nsCOMPtr<nsIURI> originURI;
    if (mWorkerPrivate) {
      // For workers, retrieve the URI from the WorkerPrivate
      principal = mWorkerPrivate->GetPrincipal();
    } else {
      // Check the principal's uri to determine if we were loaded from https.
      nsCOMPtr<nsIGlobalObject> globalObject(GetEntryGlobal());
      if (globalObject) {
        principal = globalObject->PrincipalOrNull();
      }

      nsCOMPtr<nsPIDOMWindowInner> innerWindow;

      while (true) {
        bool isNullPrincipal = true;
        if (principal) {
          isNullPrincipal = principal->GetIsNullPrincipal();
        }

        if (!isNullPrincipal) {
          break;
        }

        if (!innerWindow) {
          innerWindow = do_QueryInterface(globalObject);
          if (NS_WARN_IF(!innerWindow)) {
            aRv.Throw(NS_ERROR_DOM_SECURITY_ERR);
            return;
          }
        }

        nsCOMPtr<nsPIDOMWindowOuter> parentWindow =
          innerWindow->GetScriptableParent();
        if (NS_WARN_IF(!parentWindow)) {
          aRv.Throw(NS_ERROR_DOM_SECURITY_ERR);
          return;
        }

        nsCOMPtr<nsPIDOMWindowInner> currentInnerWindow =
          parentWindow->GetCurrentInnerWindow();
        if (NS_WARN_IF(!currentInnerWindow)) {
          aRv.Throw(NS_ERROR_DOM_SECURITY_ERR);
          return;
        }

        // We are at the top. Let's see if we have an opener window.
        if (innerWindow == currentInnerWindow) {
          ErrorResult error;
          parentWindow =
            nsGlobalWindow::Cast(innerWindow)->GetOpenerWindow(error);
          if (NS_WARN_IF(error.Failed())) {
            error.SuppressException();
            aRv.Throw(NS_ERROR_DOM_SECURITY_ERR);
            return;
          }

          if (!parentWindow) {
            break;
          }

          currentInnerWindow = parentWindow->GetCurrentInnerWindow();
          if (NS_WARN_IF(!currentInnerWindow)) {
            aRv.Throw(NS_ERROR_DOM_SECURITY_ERR);
            return;
          }

          MOZ_ASSERT(currentInnerWindow != innerWindow);
        }

        innerWindow = currentInnerWindow;

        nsCOMPtr<nsIDocument> document = innerWindow->GetExtantDoc();
        if (NS_WARN_IF(!document)) {
          aRv.Throw(NS_ERROR_DOM_SECURITY_ERR);
          return;
        }

        principal = document->NodePrincipal();
      }
    }

    if (principal) {
      principal->GetURI(getter_AddRefs(originURI));
    }

    if (originURI) {
      bool originIsHttps = false;
      aRv = originURI->SchemeIs("https", &originIsHttps);
      if (NS_WARN_IF(aRv.Failed())) {
        return;
      }
      if (originIsHttps) {
        aRv.Throw(NS_ERROR_DOM_SECURITY_ERR);
        return;
      }
    }
  }

  // Assign the sub protocol list and scan it for illegal values
  for (uint32_t index = 0; index < aProtocolArray.Length(); ++index) {
    for (uint32_t i = 0; i < aProtocolArray[index].Length(); ++i) {
      if (aProtocolArray[index][i] < static_cast<char16_t>(0x0021) ||
          aProtocolArray[index][i] > static_cast<char16_t>(0x007E)) {
        aRv.Throw(NS_ERROR_DOM_SYNTAX_ERR);
        return;
      }
    }

    if (!mRequestedProtocolList.IsEmpty()) {
      mRequestedProtocolList.AppendLiteral(", ");
    }

    AppendUTF16toUTF8(aProtocolArray[index], mRequestedProtocolList);
  }

  // the constructor should throw a SYNTAX_ERROR only if it fails to parse the
  // url parameter, so don't throw if InitializeConnection fails, and call
  // onerror/onclose asynchronously
  if (NS_FAILED(InitializeConnection(aPrincipal))) {
    *aConnectionFailed = true;
  } else {
    *aConnectionFailed = false;
  }
}

void
WebSocketImpl::AsyncOpen(nsIPrincipal* aPrincipal, uint64_t aInnerWindowID,
                         nsITransportProvider* aTransportProvider,
                         const nsACString& aNegotiatedExtensions,
                         ErrorResult& aRv)
{
  MOZ_ASSERT(NS_IsMainThread(), "Not running on main thread");
  MOZ_ASSERT_IF(!aTransportProvider, aNegotiatedExtensions.IsEmpty());

  nsCString asciiOrigin;
  aRv = nsContentUtils::GetASCIIOrigin(aPrincipal, asciiOrigin);
  if (NS_WARN_IF(aRv.Failed())) {
    return;
  }

  if (aTransportProvider) {
    aRv = mChannel->SetServerParameters(aTransportProvider, aNegotiatedExtensions);
    if (NS_WARN_IF(aRv.Failed())) {
      return;
    }
  }

  ToLowerCase(asciiOrigin);

  nsCOMPtr<nsIURI> uri;
  if (!aTransportProvider) {
    aRv = NS_NewURI(getter_AddRefs(uri), mURI);
    MOZ_ASSERT(!aRv.Failed());
  }

  aRv = mChannel->AsyncOpen(uri, asciiOrigin, aInnerWindowID, this, nullptr);
  if (NS_WARN_IF(aRv.Failed())) {
    aRv.Throw(NS_ERROR_CONTENT_BLOCKED);
    return;
  }

  mInnerWindowID = aInnerWindowID;
}

//-----------------------------------------------------------------------------
// WebSocketImpl methods:
//-----------------------------------------------------------------------------

class nsAutoCloseWS final
{
public:
  explicit nsAutoCloseWS(WebSocketImpl* aWebSocketImpl)
    : mWebSocketImpl(aWebSocketImpl)
  {}

  ~nsAutoCloseWS()
  {
    if (!mWebSocketImpl->mChannel) {
      mWebSocketImpl->CloseConnection(nsIWebSocketChannel::CLOSE_INTERNAL_ERROR);
    }
  }
private:
  RefPtr<WebSocketImpl> mWebSocketImpl;
};

nsresult
WebSocketImpl::InitializeConnection(nsIPrincipal* aPrincipal)
{
  AssertIsOnMainThread();
  MOZ_ASSERT(!mChannel, "mChannel should be null");

  nsCOMPtr<nsIWebSocketChannel> wsChannel;
  nsAutoCloseWS autoClose(this);
  nsresult rv;

  if (mSecure) {
    wsChannel =
      do_CreateInstance("@mozilla.org/network/protocol;1?name=wss", &rv);
  } else {
    wsChannel =
      do_CreateInstance("@mozilla.org/network/protocol;1?name=ws", &rv);
  }
  NS_ENSURE_SUCCESS(rv, rv);

  // add ourselves to the document's load group and
  // provide the http stack the loadgroup info too
  nsCOMPtr<nsILoadGroup> loadGroup;
  rv = GetLoadGroup(getter_AddRefs(loadGroup));
  if (loadGroup) {
    rv = wsChannel->SetLoadGroup(loadGroup);
    NS_ENSURE_SUCCESS(rv, rv);
    rv = loadGroup->AddRequest(this, nullptr);
    NS_ENSURE_SUCCESS(rv, rv);

    mWeakLoadGroup = do_GetWeakReference(loadGroup);
  }

  // manually adding loadinfo to the channel since it
  // was not set during channel creation.
  nsCOMPtr<nsIDocument> doc = do_QueryReferent(mOriginDocument);

  // mOriginDocument has to be release on main-thread because WeakReferences
  // are not thread-safe.
  mOriginDocument = nullptr;


  // The TriggeringPrincipal for websockets must always be a script.
  // Let's make sure that the doc's principal (if a doc exists)
  // and aPrincipal are same origin.
  MOZ_ASSERT(!doc || doc->NodePrincipal()->Equals(aPrincipal));

  wsChannel->InitLoadInfo(doc ? doc->AsDOMNode() : nullptr,
                          doc ? doc->NodePrincipal() : aPrincipal,
                          aPrincipal,
                          nsILoadInfo::SEC_ALLOW_CROSS_ORIGIN_DATA_IS_NULL,
                          nsIContentPolicy::TYPE_WEBSOCKET);

  if (!mRequestedProtocolList.IsEmpty()) {
    rv = wsChannel->SetProtocol(mRequestedProtocolList);
    NS_ENSURE_SUCCESS(rv, rv);
  }

  nsCOMPtr<nsIThreadRetargetableRequest> rr = do_QueryInterface(wsChannel);
  NS_ENSURE_TRUE(rr, NS_ERROR_FAILURE);

  rv = rr->RetargetDeliveryTo(this);
  NS_ENSURE_SUCCESS(rv, rv);

  mChannel = wsChannel;

  return NS_OK;
}

void
WebSocketImpl::DispatchConnectionCloseEvents()
{
  AssertIsOnTargetThread();

  if (mDisconnectingOrDisconnected) {
    return;
  }

  mWebSocket->SetReadyState(WebSocket::CLOSED);

  // Let's keep the object alive because the webSocket can be CCed in the
  // onerror or in the onclose callback.
  RefPtr<WebSocket> webSocket = mWebSocket;

  // Call 'onerror' if needed
  if (mFailed) {
    nsresult rv =
      webSocket->CreateAndDispatchSimpleEvent(NS_LITERAL_STRING("error"));
    if (NS_FAILED(rv)) {
      NS_WARNING("Failed to dispatch the error event");
    }
  }

  nsresult rv = webSocket->CreateAndDispatchCloseEvent(mCloseEventWasClean,
                                                       mCloseEventCode,
                                                       mCloseEventReason);
  if (NS_FAILED(rv)) {
    NS_WARNING("Failed to dispatch the close event");
  }

  webSocket->UpdateMustKeepAlive();
  Disconnect();
}

nsresult
WebSocket::CreateAndDispatchSimpleEvent(const nsAString& aName)
{
  MOZ_ASSERT(mImpl);
  AssertIsOnTargetThread();

  nsresult rv = CheckInnerWindowCorrectness();
  if (NS_FAILED(rv)) {
    return NS_OK;
  }

  RefPtr<Event> event = NS_NewDOMEvent(this, nullptr, nullptr);

  // it doesn't bubble, and it isn't cancelable
  event->InitEvent(aName, false, false);
  event->SetTrusted(true);

  return DispatchDOMEvent(nullptr, event, nullptr, nullptr);
}

nsresult
WebSocket::CreateAndDispatchMessageEvent(const nsACString& aData,
                                         bool aIsBinary)
{
  MOZ_ASSERT(mImpl);
  AssertIsOnTargetThread();

  AutoJSAPI jsapi;

  if (NS_IsMainThread()) {
    if (NS_WARN_IF(!jsapi.Init(GetOwner()))) {
      return NS_ERROR_FAILURE;
    }
  } else {
    MOZ_ASSERT(!mIsMainThread);
    MOZ_ASSERT(mImpl->mWorkerPrivate);
    if (NS_WARN_IF(!jsapi.Init(mImpl->mWorkerPrivate->GlobalScope()))) {
      return NS_ERROR_FAILURE;
    }
  }

  JSContext* cx = jsapi.cx();

  nsresult rv = CheckInnerWindowCorrectness();
  if (NS_FAILED(rv)) {
    return NS_OK;
  }

  uint16_t messageType = nsIWebSocketEventListener::TYPE_STRING;

  // Create appropriate JS object for message
  JS::Rooted<JS::Value> jsData(cx);
  if (aIsBinary) {
    if (mBinaryType == dom::BinaryType::Blob) {
      messageType = nsIWebSocketEventListener::TYPE_BLOB;

      RefPtr<Blob> blob =
        Blob::CreateStringBlob(GetOwner(), aData, EmptyString());
      MOZ_ASSERT(blob);

      if (!ToJSValue(cx, blob, &jsData)) {
        return NS_ERROR_FAILURE;
      }

    } else if (mBinaryType == dom::BinaryType::Arraybuffer) {
      messageType = nsIWebSocketEventListener::TYPE_ARRAYBUFFER;

      JS::Rooted<JSObject*> arrayBuf(cx);
      nsresult rv = nsContentUtils::CreateArrayBuffer(cx, aData,
                                                      arrayBuf.address());
      NS_ENSURE_SUCCESS(rv, rv);
      jsData.setObject(*arrayBuf);
    } else {
      NS_RUNTIMEABORT("Unknown binary type!");
      return NS_ERROR_UNEXPECTED;
    }
  } else {
    // JS string
    NS_ConvertUTF8toUTF16 utf16Data(aData);
    JSString* jsString;
    jsString = JS_NewUCStringCopyN(cx, utf16Data.get(), utf16Data.Length());
    NS_ENSURE_TRUE(jsString, NS_ERROR_FAILURE);

    jsData.setString(jsString);
  }

  mImpl->mService->WebSocketMessageAvailable(mImpl->mChannel->Serial(),
                                             mImpl->mInnerWindowID,
                                             aData, messageType);

  // create an event that uses the MessageEvent interface,
  // which does not bubble, is not cancelable, and has no default action

  RefPtr<MessageEvent> event = new MessageEvent(this, nullptr, nullptr);

  event->InitMessageEvent(nullptr, NS_LITERAL_STRING("message"), false, false,
                          jsData, mImpl->mUTF16Origin, EmptyString(), nullptr,
                          Sequence<OwningNonNull<MessagePort>>());
  event->SetTrusted(true);

  return DispatchDOMEvent(nullptr, static_cast<Event*>(event), nullptr,
                          nullptr);
}

nsresult
WebSocket::CreateAndDispatchCloseEvent(bool aWasClean,
                                       uint16_t aCode,
                                       const nsAString& aReason)
{
  AssertIsOnTargetThread();

  // This method is called by a runnable and it can happen that, in the
  // meantime, GC unlinked this object, so mImpl could be null.
  if (mImpl && mImpl->mChannel) {
    mImpl->mService->WebSocketClosed(mImpl->mChannel->Serial(),
                                     mImpl->mInnerWindowID,
                                     aWasClean, aCode, aReason);
  }

  nsresult rv = CheckInnerWindowCorrectness();
  if (NS_FAILED(rv)) {
    return NS_OK;
  }

  CloseEventInit init;
  init.mBubbles = false;
  init.mCancelable = false;
  init.mWasClean = aWasClean;
  init.mCode = aCode;
  init.mReason = aReason;

  RefPtr<CloseEvent> event =
    CloseEvent::Constructor(this, NS_LITERAL_STRING("close"), init);
  event->SetTrusted(true);

  return DispatchDOMEvent(nullptr, event, nullptr, nullptr);
}

nsresult
WebSocketImpl::ParseURL(const nsAString& aURL)
{
  AssertIsOnMainThread();
  NS_ENSURE_TRUE(!aURL.IsEmpty(), NS_ERROR_DOM_SYNTAX_ERR);

  if (mIsServerSide) {
    mWebSocket->mURI = aURL;
    CopyUTF16toUTF8(mWebSocket->mURI, mURI);

    return NS_OK;
  }

  nsCOMPtr<nsIURI> uri;
  nsresult rv = NS_NewURI(getter_AddRefs(uri), aURL);
  NS_ENSURE_SUCCESS(rv, NS_ERROR_DOM_SYNTAX_ERR);

  nsCOMPtr<nsIURL> parsedURL = do_QueryInterface(uri, &rv);
  NS_ENSURE_SUCCESS(rv, NS_ERROR_DOM_SYNTAX_ERR);

  bool hasRef;
  rv = parsedURL->GetHasRef(&hasRef);
  NS_ENSURE_TRUE(NS_SUCCEEDED(rv) && !hasRef,
                 NS_ERROR_DOM_SYNTAX_ERR);

  nsAutoCString scheme;
  rv = parsedURL->GetScheme(scheme);
  NS_ENSURE_TRUE(NS_SUCCEEDED(rv) && !scheme.IsEmpty(),
                 NS_ERROR_DOM_SYNTAX_ERR);

  nsAutoCString host;
  rv = parsedURL->GetAsciiHost(host);
  NS_ENSURE_TRUE(NS_SUCCEEDED(rv) && !host.IsEmpty(), NS_ERROR_DOM_SYNTAX_ERR);

  int32_t port;
  rv = parsedURL->GetPort(&port);
  NS_ENSURE_SUCCESS(rv, NS_ERROR_DOM_SYNTAX_ERR);

  rv = NS_CheckPortSafety(port, scheme.get());
  NS_ENSURE_SUCCESS(rv, NS_ERROR_DOM_SECURITY_ERR);

  nsAutoCString filePath;
  rv = parsedURL->GetFilePath(filePath);
  if (filePath.IsEmpty()) {
    filePath.Assign('/');
  }
  NS_ENSURE_SUCCESS(rv, NS_ERROR_DOM_SYNTAX_ERR);

  nsAutoCString query;
  rv = parsedURL->GetQuery(query);
  NS_ENSURE_SUCCESS(rv, NS_ERROR_DOM_SYNTAX_ERR);

  if (scheme.LowerCaseEqualsLiteral("ws")) {
     mSecure = false;
     mPort = (port == -1) ? DEFAULT_WS_SCHEME_PORT : port;
  } else if (scheme.LowerCaseEqualsLiteral("wss")) {
    mSecure = true;
    mPort = (port == -1) ? DEFAULT_WSS_SCHEME_PORT : port;
  } else {
    return NS_ERROR_DOM_SYNTAX_ERR;
  }

  rv = nsContentUtils::GetUTFOrigin(parsedURL, mUTF16Origin);
  NS_ENSURE_SUCCESS(rv, NS_ERROR_DOM_SYNTAX_ERR);

  mAsciiHost = host;
  ToLowerCase(mAsciiHost);

  mResource = filePath;
  if (!query.IsEmpty()) {
    mResource.Append('?');
    mResource.Append(query);
  }
  uint32_t length = mResource.Length();
  uint32_t i;
  for (i = 0; i < length; ++i) {
    if (mResource[i] < static_cast<char16_t>(0x0021) ||
        mResource[i] > static_cast<char16_t>(0x007E)) {
      return NS_ERROR_DOM_SYNTAX_ERR;
    }
  }

  rv = parsedURL->GetSpec(mURI);
  MOZ_ASSERT(NS_SUCCEEDED(rv));

  CopyUTF8toUTF16(mURI, mWebSocket->mURI);
  return NS_OK;
}

//-----------------------------------------------------------------------------
// Methods that keep alive the WebSocket object when:
//   1. the object has registered event listeners that can be triggered
//      ("strong event listeners");
//   2. there are outgoing not sent messages.
//-----------------------------------------------------------------------------

void
WebSocket::UpdateMustKeepAlive()
{
  // Here we could not have mImpl.
  MOZ_ASSERT(NS_IsMainThread() == mIsMainThread);

  if (!mCheckMustKeepAlive || !mImpl) {
    return;
  }

  bool shouldKeepAlive = false;
  uint16_t readyState = ReadyState();

  if (mListenerManager) {
    switch (readyState)
    {
      case CONNECTING:
      {
        if (mListenerManager->HasListenersFor(nsGkAtoms::onopen) ||
            mListenerManager->HasListenersFor(nsGkAtoms::onmessage) ||
            mListenerManager->HasListenersFor(nsGkAtoms::onerror) ||
            mListenerManager->HasListenersFor(nsGkAtoms::onclose)) {
          shouldKeepAlive = true;
        }
      }
      break;

      case OPEN:
      case CLOSING:
      {
        if (mListenerManager->HasListenersFor(nsGkAtoms::onmessage) ||
            mListenerManager->HasListenersFor(nsGkAtoms::onerror) ||
            mListenerManager->HasListenersFor(nsGkAtoms::onclose) ||
            mOutgoingBufferedAmount != 0) {
          shouldKeepAlive = true;
        }
      }
      break;

      case CLOSED:
      {
        shouldKeepAlive = false;
      }
    }
  }

  if (mKeepingAlive && !shouldKeepAlive) {
    mKeepingAlive = false;
    mImpl->ReleaseObject();
  } else if (!mKeepingAlive && shouldKeepAlive) {
    mKeepingAlive = true;
    mImpl->AddRefObject();
  }
}

void
WebSocket::DontKeepAliveAnyMore()
{
  // Here we could not have mImpl.
  MOZ_ASSERT(NS_IsMainThread() == mIsMainThread);

  if (mKeepingAlive) {
    MOZ_ASSERT(mImpl);

    mKeepingAlive = false;
    mImpl->ReleaseObject();
  }

  mCheckMustKeepAlive = false;
}

namespace {

class WebSocketWorkerHolder final : public WorkerHolder
{
public:
  explicit WebSocketWorkerHolder(WebSocketImpl* aWebSocketImpl)
    : mWebSocketImpl(aWebSocketImpl)
  {
  }

  bool Notify(Status aStatus) override
  {
    MOZ_ASSERT(aStatus > workers::Running);

    if (aStatus >= Canceling) {
      {
        MutexAutoLock lock(mWebSocketImpl->mMutex);
        mWebSocketImpl->mWorkerShuttingDown = true;
      }

      mWebSocketImpl->CloseConnection(nsIWebSocketChannel::CLOSE_GOING_AWAY,
                                      EmptyCString());
    }

    return true;
  }

private:
  WebSocketImpl* mWebSocketImpl;
};

} // namespace

void
WebSocketImpl::AddRefObject()
{
  AssertIsOnTargetThread();
  AddRef();
}

void
WebSocketImpl::ReleaseObject()
{
  AssertIsOnTargetThread();
  Release();
}

bool
WebSocketImpl::RegisterWorkerHolder()
{
  mWorkerPrivate->AssertIsOnWorkerThread();
  MOZ_ASSERT(!mWorkerHolder);
  mWorkerHolder = new WebSocketWorkerHolder(this);

  if (NS_WARN_IF(!mWorkerHolder->HoldWorker(mWorkerPrivate, Canceling))) {
    mWorkerHolder = nullptr;
    return false;
  }

#ifdef DEBUG
  SetHasWorkerHolderRegistered(true);
#endif

  return true;
}

void
WebSocketImpl::UnregisterWorkerHolder()
{
  MOZ_ASSERT(mDisconnectingOrDisconnected);
  MOZ_ASSERT(mWorkerPrivate);
  mWorkerPrivate->AssertIsOnWorkerThread();
  MOZ_ASSERT(mWorkerHolder);

  {
    MutexAutoLock lock(mMutex);
    mWorkerShuttingDown = true;
  }

  // The DTOR of this WorkerHolder will release the worker for us.
  mWorkerHolder = nullptr;

  mWorkerPrivate = nullptr;

#ifdef DEBUG
  SetHasWorkerHolderRegistered(false);
#endif
}

nsresult
WebSocketImpl::UpdateURI()
{
  AssertIsOnTargetThread();

  // Check for Redirections
  RefPtr<BaseWebSocketChannel> channel;
  channel = static_cast<BaseWebSocketChannel*>(mChannel.get());
  MOZ_ASSERT(channel);

  channel->GetEffectiveURL(mWebSocket->mEffectiveURL);
  mSecure = channel->IsEncrypted();

  return NS_OK;
}

void
WebSocket::EventListenerAdded(nsIAtom* aType)
{
  AssertIsOnMainThread();
  UpdateMustKeepAlive();
}

void
WebSocket::EventListenerRemoved(nsIAtom* aType)
{
  AssertIsOnMainThread();
  UpdateMustKeepAlive();
}

//-----------------------------------------------------------------------------
// WebSocket - methods
//-----------------------------------------------------------------------------

// webIDL: readonly attribute unsigned short readyState;
uint16_t
WebSocket::ReadyState()
{
  MutexAutoLock lock(mMutex);
  return mReadyState;
}

void
WebSocket::SetReadyState(uint16_t aReadyState)
{
  MutexAutoLock lock(mMutex);
  mReadyState = aReadyState;
}

// webIDL: readonly attribute unsigned long bufferedAmount;
uint32_t
WebSocket::BufferedAmount() const
{
  AssertIsOnTargetThread();
  return mOutgoingBufferedAmount;
}

// webIDL: attribute BinaryType binaryType;
dom::BinaryType
WebSocket::BinaryType() const
{
  AssertIsOnTargetThread();
  return mBinaryType;
}

// webIDL: attribute BinaryType binaryType;
void
WebSocket::SetBinaryType(dom::BinaryType aData)
{
  AssertIsOnTargetThread();
  mBinaryType = aData;
}

// webIDL: readonly attribute DOMString url
void
WebSocket::GetUrl(nsAString& aURL)
{
  AssertIsOnTargetThread();

  if (mEffectiveURL.IsEmpty()) {
    aURL = mURI;
  } else {
    aURL = mEffectiveURL;
  }
}

// webIDL: readonly attribute DOMString extensions;
void
WebSocket::GetExtensions(nsAString& aExtensions)
{
  AssertIsOnTargetThread();
  CopyUTF8toUTF16(mEstablishedExtensions, aExtensions);
}

// webIDL: readonly attribute DOMString protocol;
void
WebSocket::GetProtocol(nsAString& aProtocol)
{
  AssertIsOnTargetThread();
  CopyUTF8toUTF16(mEstablishedProtocol, aProtocol);
}

// webIDL: void send(DOMString data);
void
WebSocket::Send(const nsAString& aData,
                ErrorResult& aRv)
{
  AssertIsOnTargetThread();

  NS_ConvertUTF16toUTF8 msgString(aData);
  Send(nullptr, msgString, msgString.Length(), false, aRv);
}

void
WebSocket::Send(Blob& aData, ErrorResult& aRv)
{
  AssertIsOnTargetThread();

  nsCOMPtr<nsIInputStream> msgStream;
  aData.GetInternalStream(getter_AddRefs(msgStream), aRv);
  if (NS_WARN_IF(aRv.Failed())){
    return;
  }

  uint64_t msgLength = aData.GetSize(aRv);
  if (NS_WARN_IF(aRv.Failed())){
    return;
  }

  if (msgLength > UINT32_MAX) {
    aRv.Throw(NS_ERROR_FILE_TOO_BIG);
    return;
  }

  Send(msgStream, EmptyCString(), msgLength, true, aRv);
}

void
WebSocket::Send(const ArrayBuffer& aData,
                ErrorResult& aRv)
{
  AssertIsOnTargetThread();

  aData.ComputeLengthAndData();

  static_assert(sizeof(*aData.Data()) == 1, "byte-sized data required");

  uint32_t len = aData.Length();
  char* data = reinterpret_cast<char*>(aData.Data());

  nsDependentCSubstring msgString(data, len);
  Send(nullptr, msgString, len, true, aRv);
}

void
WebSocket::Send(const ArrayBufferView& aData,
                ErrorResult& aRv)
{
  AssertIsOnTargetThread();

  aData.ComputeLengthAndData();

  static_assert(sizeof(*aData.Data()) == 1, "byte-sized data required");

  uint32_t len = aData.Length();
  char* data = reinterpret_cast<char*>(aData.Data());

  nsDependentCSubstring msgString(data, len);
  Send(nullptr, msgString, len, true, aRv);
}

void
WebSocket::Send(nsIInputStream* aMsgStream,
                const nsACString& aMsgString,
                uint32_t aMsgLength,
                bool aIsBinary,
                ErrorResult& aRv)
{
  AssertIsOnTargetThread();

  int64_t readyState = ReadyState();
  if (readyState == CONNECTING) {
    aRv.Throw(NS_ERROR_DOM_INVALID_STATE_ERR);
    return;
  }

  // Always increment outgoing buffer len, even if closed
  mOutgoingBufferedAmount += aMsgLength;

  if (readyState == CLOSING ||
      readyState == CLOSED) {
    return;
  }

  // We must have mImpl when connected.
  MOZ_ASSERT(mImpl);
  MOZ_ASSERT(readyState == OPEN, "Unknown state in WebSocket::Send");

  nsresult rv;
  if (aMsgStream) {
    rv = mImpl->mChannel->SendBinaryStream(aMsgStream, aMsgLength);
  } else {
    if (aIsBinary) {
      rv = mImpl->mChannel->SendBinaryMsg(aMsgString);
    } else {
      rv = mImpl->mChannel->SendMsg(aMsgString);
    }
  }

  if (NS_FAILED(rv)) {
    aRv.Throw(rv);
    return;
  }

  UpdateMustKeepAlive();
}

// webIDL: void close(optional unsigned short code, optional DOMString reason):
void
WebSocket::Close(const Optional<uint16_t>& aCode,
                 const Optional<nsAString>& aReason,
                 ErrorResult& aRv)
{
  AssertIsOnTargetThread();

  // the reason code is optional, but if provided it must be in a specific range
  uint16_t closeCode = 0;
  if (aCode.WasPassed()) {
    if (aCode.Value() != 1000 && (aCode.Value() < 3000 || aCode.Value() > 4999)) {
      aRv.Throw(NS_ERROR_DOM_INVALID_ACCESS_ERR);
      return;
    }
    closeCode = aCode.Value();
  }

  nsCString closeReason;
  if (aReason.WasPassed()) {
    CopyUTF16toUTF8(aReason.Value(), closeReason);

    // The API requires the UTF-8 string to be 123 or less bytes
    if (closeReason.Length() > 123) {
      aRv.Throw(NS_ERROR_DOM_SYNTAX_ERR);
      return;
    }
  }

  int64_t readyState = ReadyState();
  if (readyState == CLOSING ||
      readyState == CLOSED) {
    return;
  }

  // If the webSocket is not closed we MUST have a mImpl.
  MOZ_ASSERT(mImpl);

  if (readyState == CONNECTING) {
    mImpl->FailConnection(closeCode, closeReason);
    return;
  }

  MOZ_ASSERT(readyState == OPEN);
  mImpl->CloseConnection(closeCode, closeReason);
}

//-----------------------------------------------------------------------------
// WebSocketImpl::nsIObserver
//-----------------------------------------------------------------------------

NS_IMETHODIMP
WebSocketImpl::Observe(nsISupports* aSubject,
                       const char* aTopic,
                       const char16_t* aData)
{
  AssertIsOnMainThread();

  int64_t readyState = mWebSocket->ReadyState();
  if ((readyState == WebSocket::CLOSING) ||
      (readyState == WebSocket::CLOSED)) {
    return NS_OK;
  }

  nsCOMPtr<nsPIDOMWindowInner> window = do_QueryInterface(aSubject);
  if (!mWebSocket->GetOwner() || window != mWebSocket->GetOwner()) {
    return NS_OK;
  }

  if ((strcmp(aTopic, DOM_WINDOW_FROZEN_TOPIC) == 0) ||
      (strcmp(aTopic, DOM_WINDOW_DESTROYED_TOPIC) == 0))
  {
    CloseConnection(nsIWebSocketChannel::CLOSE_GOING_AWAY);
  }

  return NS_OK;
}

//-----------------------------------------------------------------------------
// WebSocketImpl::nsIRequest
//-----------------------------------------------------------------------------

NS_IMETHODIMP
WebSocketImpl::GetName(nsACString& aName)
{
  AssertIsOnMainThread();

  CopyUTF16toUTF8(mWebSocket->mURI, aName);
  return NS_OK;
}

NS_IMETHODIMP
WebSocketImpl::IsPending(bool* aValue)
{
  AssertIsOnTargetThread();

  int64_t readyState = mWebSocket->ReadyState();
  *aValue = (readyState != WebSocket::CLOSED);
  return NS_OK;
}

NS_IMETHODIMP
WebSocketImpl::GetStatus(nsresult* aStatus)
{
  AssertIsOnTargetThread();

  *aStatus = NS_OK;
  return NS_OK;
}

namespace {

class CancelRunnable final : public MainThreadWorkerRunnable
{
public:
  CancelRunnable(WorkerPrivate* aWorkerPrivate, WebSocketImpl* aImpl)
    : MainThreadWorkerRunnable(aWorkerPrivate)
    , mImpl(aImpl)
  {
  }

  bool WorkerRun(JSContext* aCx, WorkerPrivate* aWorkerPrivate) override
  {
    aWorkerPrivate->AssertIsOnWorkerThread();
    return !NS_FAILED(mImpl->CancelInternal());
  }

private:
  RefPtr<WebSocketImpl> mImpl;
};

} // namespace

// Window closed, stop/reload button pressed, user navigated away from page, etc.
NS_IMETHODIMP
WebSocketImpl::Cancel(nsresult aStatus)
{
  AssertIsOnMainThread();

  if (!mIsMainThread) {
    MOZ_ASSERT(mWorkerPrivate);
    RefPtr<CancelRunnable> runnable =
      new CancelRunnable(mWorkerPrivate, this);
    if (!runnable->Dispatch()) {
      return NS_ERROR_FAILURE;
    }

    return NS_OK;
  }

  return CancelInternal();
}

nsresult
WebSocketImpl::CancelInternal()
{
  AssertIsOnTargetThread();

   // If CancelInternal is called by a runnable, we may already be disconnected
   // by the time it runs.
  if (mDisconnectingOrDisconnected) {
    return NS_OK;
  }

  int64_t readyState = mWebSocket->ReadyState();
  if (readyState == WebSocket::CLOSING || readyState == WebSocket::CLOSED) {
    return NS_OK;
  }

  return CloseConnection(nsIWebSocketChannel::CLOSE_GOING_AWAY);
}

NS_IMETHODIMP
WebSocketImpl::Suspend()
{
  AssertIsOnMainThread();
  return NS_ERROR_NOT_IMPLEMENTED;
}

NS_IMETHODIMP
WebSocketImpl::Resume()
{
  AssertIsOnMainThread();
  return NS_ERROR_NOT_IMPLEMENTED;
}

NS_IMETHODIMP
WebSocketImpl::GetLoadGroup(nsILoadGroup** aLoadGroup)
{
  AssertIsOnMainThread();

  *aLoadGroup = nullptr;

  if (mIsMainThread) {
    nsCOMPtr<nsIDocument> doc = mWebSocket->GetDocumentIfCurrent();
    if (doc) {
      *aLoadGroup = doc->GetDocumentLoadGroup().take();
    }

    return NS_OK;
  }

  MOZ_ASSERT(mWorkerPrivate);

  // Walk up to our containing page
  WorkerPrivate* wp = mWorkerPrivate;
  while (wp->GetParent()) {
    wp = wp->GetParent();
  }

  nsPIDOMWindowInner* window = wp->GetWindow();
  if (!window) {
    return NS_OK;
  }

  nsIDocument* doc = window->GetExtantDoc();
  if (doc) {
    *aLoadGroup = doc->GetDocumentLoadGroup().take();
  }

  return NS_OK;
}

NS_IMETHODIMP
WebSocketImpl::SetLoadGroup(nsILoadGroup* aLoadGroup)
{
  AssertIsOnMainThread();
  return NS_ERROR_UNEXPECTED;
}

NS_IMETHODIMP
WebSocketImpl::GetLoadFlags(nsLoadFlags* aLoadFlags)
{
  AssertIsOnMainThread();

  *aLoadFlags = nsIRequest::LOAD_BACKGROUND;
  return NS_OK;
}

NS_IMETHODIMP
WebSocketImpl::SetLoadFlags(nsLoadFlags aLoadFlags)
{
  AssertIsOnMainThread();

  // we won't change the load flags at all.
  return NS_OK;
}

namespace {

class WorkerRunnableDispatcher final : public WorkerRunnable
{
  RefPtr<WebSocketImpl> mWebSocketImpl;

public:
  WorkerRunnableDispatcher(WebSocketImpl* aImpl, WorkerPrivate* aWorkerPrivate,
                           already_AddRefed<nsIRunnable> aEvent)
    : WorkerRunnable(aWorkerPrivate, WorkerThreadUnchangedBusyCount)
    , mWebSocketImpl(aImpl)
    , mEvent(Move(aEvent))
  {
  }

  bool WorkerRun(JSContext* aCx, WorkerPrivate* aWorkerPrivate) override
  {
    aWorkerPrivate->AssertIsOnWorkerThread();

    // No messages when disconnected.
    if (mWebSocketImpl->mDisconnectingOrDisconnected) {
      NS_WARNING("Dispatching a WebSocket event after the disconnection!");
      return true;
    }

    return !NS_FAILED(mEvent->Run());
  }

  void PostRun(JSContext* aCx, WorkerPrivate* aWorkerPrivate,
               bool aRunResult) override
  {
  }

  bool
  PreDispatch(WorkerPrivate* aWorkerPrivate) override
  {
    // We don't call WorkerRunnable::PreDispatch because it would assert the
    // wrong thing about which thread we're on.  We're on whichever thread the
    // channel implementation is running on (probably the main thread or socket
    // transport thread).
    return true;
  }

  void
  PostDispatch(WorkerPrivate* aWorkerPrivate, bool aDispatchResult) override
  {
    // We don't call WorkerRunnable::PreDispatch because it would assert the
    // wrong thing about which thread we're on.  We're on whichever thread the
    // channel implementation is running on (probably the main thread or socket
    // transport thread).
  }

private:
  nsCOMPtr<nsIRunnable> mEvent;
};

} // namespace

NS_IMETHODIMP
WebSocketImpl::DispatchFromScript(nsIRunnable* aEvent, uint32_t aFlags)
{
  nsCOMPtr<nsIRunnable> event(aEvent);
  return Dispatch(event.forget(), aFlags);
}

NS_IMETHODIMP
WebSocketImpl::Dispatch(already_AddRefed<nsIRunnable> aEvent, uint32_t aFlags)
{
  nsCOMPtr<nsIRunnable> event_ref(aEvent);
  // If the target is the main-thread we can just dispatch the runnable.
  if (mIsMainThread) {
    return NS_DispatchToMainThread(event_ref.forget());
  }

  MutexAutoLock lock(mMutex);
  if (mWorkerShuttingDown) {
    return NS_OK;
  }

  MOZ_DIAGNOSTIC_ASSERT(mWorkerPrivate);

#ifdef DEBUG
  MOZ_ASSERT(HasWorkerHolderRegistered());
#endif

  // If the target is a worker, we have to use a custom WorkerRunnableDispatcher
  // runnable.
  RefPtr<WorkerRunnableDispatcher> event =
    new WorkerRunnableDispatcher(this, mWorkerPrivate, event_ref.forget());

  if (!event->Dispatch()) {
    return NS_ERROR_FAILURE;
  }

  return NS_OK;
}

NS_IMETHODIMP
WebSocketImpl::DelayedDispatch(already_AddRefed<nsIRunnable>, uint32_t)
{
  return NS_ERROR_NOT_IMPLEMENTED;
}

NS_IMETHODIMP
WebSocketImpl::IsOnCurrentThread(bool* aResult)
{
  *aResult = IsTargetThread();
  return NS_OK;
}

bool
WebSocketImpl::IsTargetThread() const
{
  return NS_IsMainThread() == mIsMainThread;
}

void
WebSocket::AssertIsOnTargetThread() const
{
  MOZ_ASSERT(NS_IsMainThread() == mIsMainThread);
}

} // namespace dom
} // namespace mozilla
