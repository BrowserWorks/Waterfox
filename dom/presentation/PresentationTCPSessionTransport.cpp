/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsArrayUtils.h"
#include "nsIAsyncStreamCopier.h"
#include "nsIMultiplexInputStream.h"
#include "nsIScriptableInputStream.h"
#include "nsISocketTransport.h"
#include "nsISocketTransportService.h"
#include "nsISupportsPrimitives.h"
#include "nsNetUtil.h"
#include "nsQueryObject.h"
#include "nsServiceManagerUtils.h"
#include "nsStreamUtils.h"
#include "nsThreadUtils.h"
#include "PresentationLog.h"
#include "PresentationTCPSessionTransport.h"

#define BUFFER_SIZE 65536

using namespace mozilla;
using namespace mozilla::dom;

class CopierCallbacks final : public nsIRequestObserver {
 public:
  explicit CopierCallbacks(PresentationTCPSessionTransport* aTransport)
      : mOwner(aTransport) {}

  NS_DECL_ISUPPORTS
  NS_DECL_NSIREQUESTOBSERVER
 private:
  ~CopierCallbacks() = default;

  RefPtr<PresentationTCPSessionTransport> mOwner;
};

NS_IMPL_ISUPPORTS(CopierCallbacks, nsIRequestObserver)

NS_IMETHODIMP
CopierCallbacks::OnStartRequest(nsIRequest* aRequest) { return NS_OK; }

NS_IMETHODIMP
CopierCallbacks::OnStopRequest(nsIRequest* aRequest, nsresult aStatus) {
  mOwner->NotifyCopyComplete(aStatus);
  return NS_OK;
}

NS_IMPL_CYCLE_COLLECTION(PresentationTCPSessionTransport, mTransport,
                         mSocketInputStream, mSocketOutputStream,
                         mInputStreamPump, mInputStreamScriptable, mCallback)

NS_IMPL_CYCLE_COLLECTING_ADDREF(PresentationTCPSessionTransport)
NS_IMPL_CYCLE_COLLECTING_RELEASE(PresentationTCPSessionTransport)

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(PresentationTCPSessionTransport)
  NS_INTERFACE_MAP_ENTRY_AMBIGUOUS(nsISupports, nsIPresentationSessionTransport)
  NS_INTERFACE_MAP_ENTRY(nsIInputStreamCallback)
  NS_INTERFACE_MAP_ENTRY(nsIPresentationSessionTransport)
  NS_INTERFACE_MAP_ENTRY(nsIPresentationSessionTransportBuilder)
  NS_INTERFACE_MAP_ENTRY(nsIPresentationTCPSessionTransportBuilder)
  NS_INTERFACE_MAP_ENTRY(nsIRequestObserver)
  NS_INTERFACE_MAP_ENTRY(nsIStreamListener)
  NS_INTERFACE_MAP_ENTRY(nsITransportEventSink)
NS_INTERFACE_MAP_END

PresentationTCPSessionTransport::PresentationTCPSessionTransport()
    : mReadyState(ReadyState::CLOSED),
      mAsyncCopierActive(false),
      mCloseStatus(NS_OK),
      mDataNotificationEnabled(false) {}

PresentationTCPSessionTransport::~PresentationTCPSessionTransport() = default;

NS_IMETHODIMP
PresentationTCPSessionTransport::BuildTCPSenderTransport(
    nsISocketTransport* aTransport,
    nsIPresentationSessionTransportBuilderListener* aListener) {
  if (NS_WARN_IF(!aTransport)) {
    return NS_ERROR_INVALID_ARG;
  }
  mTransport = aTransport;

  if (NS_WARN_IF(!aListener)) {
    return NS_ERROR_INVALID_ARG;
  }
  mListener = aListener;

  nsresult rv = CreateStream();
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  mRole = nsIPresentationService::ROLE_CONTROLLER;

  nsCOMPtr<nsIPresentationSessionTransport> sessionTransport =
      do_QueryObject(this);
  nsCOMPtr<nsIRunnable> onSessionTransportRunnable =
      NewRunnableMethod<nsIPresentationSessionTransport*>(
          "nsIPresentationSessionTransportBuilderListener::OnSessionTransport",
          mListener,
          &nsIPresentationSessionTransportBuilderListener::OnSessionTransport,
          sessionTransport);

  NS_DispatchToCurrentThread(onSessionTransportRunnable.forget());

  nsCOMPtr<nsIRunnable> setReadyStateRunnable = NewRunnableMethod<ReadyState>(
      "dom::PresentationTCPSessionTransport::SetReadyState", this,
      &PresentationTCPSessionTransport::SetReadyState, ReadyState::OPEN);
  return NS_DispatchToCurrentThread(setReadyStateRunnable.forget());
}

NS_IMETHODIMP
PresentationTCPSessionTransport::BuildTCPReceiverTransport(
    nsIPresentationChannelDescription* aDescription,
    nsIPresentationSessionTransportBuilderListener* aListener) {
  if (NS_WARN_IF(!aDescription)) {
    return NS_ERROR_INVALID_ARG;
  }

  if (NS_WARN_IF(!aListener)) {
    return NS_ERROR_INVALID_ARG;
  }
  mListener = aListener;

  uint16_t serverPort;
  nsresult rv = aDescription->GetTcpPort(&serverPort);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  nsCOMPtr<nsIArray> serverHosts;
  rv = aDescription->GetTcpAddress(getter_AddRefs(serverHosts));
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  // TODO bug 1228504 Take all IP addresses in PresentationChannelDescription
  // into account. And at the first stage Presentation API is only exposed on
  // Firefox OS where the first IP appears enough for most scenarios.
  nsCOMPtr<nsISupportsCString> supportStr = do_QueryElementAt(serverHosts, 0);
  if (NS_WARN_IF(!supportStr)) {
    return NS_ERROR_INVALID_ARG;
  }

  nsAutoCString serverHost;
  supportStr->GetData(serverHost);
  if (serverHost.IsEmpty()) {
    return NS_ERROR_INVALID_ARG;
  }

  PRES_DEBUG("%s:ServerHost[%s],ServerPort[%d]\n", __func__, serverHost.get(),
             serverPort);

  SetReadyState(ReadyState::CONNECTING);

  nsCOMPtr<nsISocketTransportService> sts =
      do_GetService(NS_SOCKETTRANSPORTSERVICE_CONTRACTID);
  if (NS_WARN_IF(!sts)) {
    return NS_ERROR_NOT_AVAILABLE;
  }
  rv = sts->CreateTransport(nsTArray<nsCString>(), serverHost, serverPort,
                            nullptr, getter_AddRefs(mTransport));
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  nsCOMPtr<nsIEventTarget> mainTarget = GetMainThreadEventTarget();
  mTransport->SetEventSink(this, mainTarget);

  rv = CreateStream();
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  mRole = nsIPresentationService::ROLE_RECEIVER;

  nsCOMPtr<nsIPresentationSessionTransport> sessionTransport =
      do_QueryObject(this);
  nsCOMPtr<nsIRunnable> runnable =
      NewRunnableMethod<nsIPresentationSessionTransport*>(
          "nsIPresentationSessionTransportBuilderListener::OnSessionTransport",
          mListener,
          &nsIPresentationSessionTransportBuilderListener::OnSessionTransport,
          sessionTransport);
  return NS_DispatchToCurrentThread(runnable.forget());
}

nsresult PresentationTCPSessionTransport::CreateStream() {
  nsresult rv =
      mTransport->OpenInputStream(0, 0, 0, getter_AddRefs(mSocketInputStream));
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }
  rv = mTransport->OpenOutputStream(nsITransport::OPEN_UNBUFFERED, 0, 0,
                                    getter_AddRefs(mSocketOutputStream));
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  // If the other side is not listening, we will get an |onInputStreamReady|
  // callback where |available| raises to indicate the connection was refused.
  nsCOMPtr<nsIAsyncInputStream> asyncStream =
      do_QueryInterface(mSocketInputStream);
  if (NS_WARN_IF(!asyncStream)) {
    return NS_ERROR_NOT_AVAILABLE;
  }

  nsCOMPtr<nsIEventTarget> mainTarget = GetMainThreadEventTarget();
  rv = asyncStream->AsyncWait(this, nsIAsyncInputStream::WAIT_CLOSURE_ONLY, 0,
                              mainTarget);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  mInputStreamScriptable =
      do_CreateInstance("@mozilla.org/scriptableinputstream;1", &rv);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }
  rv = mInputStreamScriptable->Init(mSocketInputStream);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  return NS_OK;
}

nsresult PresentationTCPSessionTransport::CreateInputStreamPump() {
  if (NS_WARN_IF(mInputStreamPump)) {
    return NS_OK;
  }

  nsresult rv;
  mInputStreamPump = do_CreateInstance(NS_INPUTSTREAMPUMP_CONTRACTID, &rv);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  rv = mInputStreamPump->Init(mSocketInputStream, 0, 0, false, nullptr);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  rv = mInputStreamPump->AsyncRead(this, nullptr);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  return NS_OK;
}

NS_IMETHODIMP
PresentationTCPSessionTransport::EnableDataNotification() {
  if (NS_WARN_IF(!mCallback)) {
    return NS_ERROR_DOM_INVALID_STATE_ERR;
  }

  if (mDataNotificationEnabled) {
    return NS_OK;
  }

  mDataNotificationEnabled = true;

  if (IsReadyToNotifyData()) {
    return CreateInputStreamPump();
  }

  return NS_OK;
}

// nsIPresentationSessionTransportBuilderListener
NS_IMETHODIMP
PresentationTCPSessionTransport::GetCallback(
    nsIPresentationSessionTransportCallback** aCallback) {
  nsCOMPtr<nsIPresentationSessionTransportCallback> callback = mCallback;
  callback.forget(aCallback);
  return NS_OK;
}

NS_IMETHODIMP
PresentationTCPSessionTransport::SetCallback(
    nsIPresentationSessionTransportCallback* aCallback) {
  mCallback = aCallback;

  if (!!mCallback && ReadyState::OPEN == mReadyState) {
    // Notify the transport channel is ready.
    Unused << NS_WARN_IF(NS_FAILED(mCallback->NotifyTransportReady()));
  }

  return NS_OK;
}

NS_IMETHODIMP
PresentationTCPSessionTransport::GetSelfAddress(nsINetAddr** aSelfAddress) {
  if (NS_WARN_IF(!mTransport)) {
    return NS_ERROR_DOM_INVALID_STATE_ERR;
  }

  return mTransport->GetScriptableSelfAddr(aSelfAddress);
}

nsresult PresentationTCPSessionTransport::EnsureCopying() {
  if (mAsyncCopierActive) {
    return NS_OK;
  }

  mAsyncCopierActive = true;

  nsresult rv;

  nsCOMPtr<nsIMultiplexInputStream> multiplexStream =
      do_CreateInstance("@mozilla.org/io/multiplex-input-stream;1", &rv);
  NS_ENSURE_SUCCESS(rv, rv);

  nsCOMPtr<nsIInputStream> stream = do_QueryInterface(multiplexStream);

  while (!mPendingData.IsEmpty()) {
    nsCOMPtr<nsIInputStream> stream = mPendingData[0];
    multiplexStream->AppendStream(stream);
    mPendingData.RemoveElementAt(0);
  }

  nsCOMPtr<nsIAsyncStreamCopier> copier =
      do_CreateInstance("@mozilla.org/network/async-stream-copier;1", &rv);
  NS_ENSURE_SUCCESS(rv, rv);

  nsCOMPtr<nsISocketTransportService> sts =
      do_GetService("@mozilla.org/network/socket-transport-service;1");

  nsCOMPtr<nsIEventTarget> target = do_QueryInterface(sts);
  rv = copier->Init(stream, mSocketOutputStream, target,
                    true,               /* source buffered */
                    false,              /* sink buffered */
                    BUFFER_SIZE, false, /* close source */
                    false);             /* close sink */
  NS_ENSURE_SUCCESS(rv, rv);

  RefPtr<CopierCallbacks> callbacks = new CopierCallbacks(this);
  rv = copier->AsyncCopy(callbacks, nullptr);
  NS_ENSURE_SUCCESS(rv, rv);

  return NS_OK;
}

void PresentationTCPSessionTransport::NotifyCopyComplete(nsresult aStatus) {
  mAsyncCopierActive = false;

  if (NS_WARN_IF(NS_FAILED(aStatus))) {
    if (mReadyState != ReadyState::CLOSED) {
      mCloseStatus = aStatus;
      SetReadyState(ReadyState::CLOSED);
    }
    return;
  }

  if (!mPendingData.IsEmpty()) {
    EnsureCopying();
    return;
  }

  if (mReadyState == ReadyState::CLOSING) {
    mSocketOutputStream->Close();
    mCloseStatus = NS_OK;
    SetReadyState(ReadyState::CLOSED);
  }
}

NS_IMETHODIMP
PresentationTCPSessionTransport::Send(const nsAString& aData) {
  if (NS_WARN_IF(mReadyState != ReadyState::OPEN)) {
    return NS_ERROR_DOM_INVALID_STATE_ERR;
  }

  nsresult rv;
  nsCOMPtr<nsIStringInputStream> stream =
      do_CreateInstance(NS_STRINGINPUTSTREAM_CONTRACTID, &rv);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return NS_ERROR_DOM_INVALID_STATE_ERR;
  }

  NS_ConvertUTF16toUTF8 msgString(aData);
  rv = stream->SetData(msgString.BeginReading(), msgString.Length());
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return NS_ERROR_DOM_INVALID_STATE_ERR;
  }

  mPendingData.AppendElement(stream);

  EnsureCopying();

  return NS_OK;
}

NS_IMETHODIMP
PresentationTCPSessionTransport::SendBinaryMsg(const nsACString& aData) {
  return NS_ERROR_DOM_NOT_SUPPORTED_ERR;
}

NS_IMETHODIMP
PresentationTCPSessionTransport::SendBlob(Blob* aBlob) {
  return NS_ERROR_DOM_NOT_SUPPORTED_ERR;
}

NS_IMETHODIMP
PresentationTCPSessionTransport::Close(nsresult aReason) {
  PRES_DEBUG("%s:reason[%" PRIx32 "]\n", __func__,
             static_cast<uint32_t>(aReason));

  if (mReadyState == ReadyState::CLOSED || mReadyState == ReadyState::CLOSING) {
    return NS_OK;
  }

  mCloseStatus = aReason;
  SetReadyState(ReadyState::CLOSING);

  if (!mAsyncCopierActive) {
    mPendingData.Clear();
    mSocketOutputStream->Close();
  }

  mSocketInputStream->Close();
  mDataNotificationEnabled = false;

  mListener = nullptr;

  return NS_OK;
}

void PresentationTCPSessionTransport::SetReadyState(ReadyState aReadyState) {
  mReadyState = aReadyState;

  if (mReadyState == ReadyState::OPEN) {
    if (IsReadyToNotifyData()) {
      CreateInputStreamPump();
    }

    if (NS_WARN_IF(!mCallback)) {
      return;
    }

    // Notify the transport channel is ready.
    Unused << NS_WARN_IF(NS_FAILED(mCallback->NotifyTransportReady()));
  } else if (mReadyState == ReadyState::CLOSED && mCallback) {
    if (NS_WARN_IF(!mCallback)) {
      return;
    }

    // Notify the transport channel has been shut down.
    Unused << NS_WARN_IF(
        NS_FAILED(mCallback->NotifyTransportClosed(mCloseStatus)));
    mCallback = nullptr;
  }
}

// nsITransportEventSink
NS_IMETHODIMP
PresentationTCPSessionTransport::OnTransportStatus(nsITransport* aTransport,
                                                   nsresult aStatus,
                                                   int64_t aProgress,
                                                   int64_t aProgressMax) {
  PRES_DEBUG("%s:aStatus[%" PRIx32 "]\n", __func__,
             static_cast<uint32_t>(aStatus));

  MOZ_ASSERT(NS_IsMainThread());

  if (aStatus != NS_NET_STATUS_CONNECTED_TO) {
    return NS_OK;
  }

  SetReadyState(ReadyState::OPEN);

  return NS_OK;
}

// nsIInputStreamCallback
NS_IMETHODIMP
PresentationTCPSessionTransport::OnInputStreamReady(
    nsIAsyncInputStream* aStream) {
  MOZ_ASSERT(NS_IsMainThread());

  // Only used for detecting if the connection was refused.
  uint64_t dummy;
  nsresult rv = aStream->Available(&dummy);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    if (mReadyState != ReadyState::CLOSED) {
      mCloseStatus = NS_ERROR_CONNECTION_REFUSED;
      SetReadyState(ReadyState::CLOSED);
    }
  }

  return NS_OK;
}

// nsIRequestObserver
NS_IMETHODIMP
PresentationTCPSessionTransport::OnStartRequest(nsIRequest* aRequest) {
  // Do nothing.
  return NS_OK;
}

NS_IMETHODIMP
PresentationTCPSessionTransport::OnStopRequest(nsIRequest* aRequest,
                                               nsresult aStatusCode) {
  PRES_DEBUG("%s:aStatusCode[%" PRIx32 "]\n", __func__,
             static_cast<uint32_t>(aStatusCode));

  MOZ_ASSERT(NS_IsMainThread());

  mInputStreamPump = nullptr;

  if (mAsyncCopierActive && NS_SUCCEEDED(aStatusCode)) {
    // If we have some buffered output still, and status is not an error, the
    // other side has done a half-close, but we don't want to be in the close
    // state until we are done sending everything that was buffered. We also
    // don't want to call |NotifyTransportClosed| yet.
    return NS_OK;
  }

  // We call this even if there is no error.
  if (mReadyState != ReadyState::CLOSED) {
    mCloseStatus = aStatusCode;
    SetReadyState(ReadyState::CLOSED);
  }
  return NS_OK;
}

// nsIStreamListener
NS_IMETHODIMP
PresentationTCPSessionTransport::OnDataAvailable(nsIRequest* aRequest,
                                                 nsIInputStream* aStream,
                                                 uint64_t aOffset,
                                                 uint32_t aCount) {
  MOZ_ASSERT(NS_IsMainThread());

  if (NS_WARN_IF(!mCallback)) {
    return NS_ERROR_NOT_AVAILABLE;
  }

  nsCString data;
  nsresult rv = mInputStreamScriptable->ReadBytes(aCount, data);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return rv;
  }

  // Pass the incoming data to the listener.
  return mCallback->NotifyData(data, false);
}
