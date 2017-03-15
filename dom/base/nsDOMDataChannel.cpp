/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsDOMDataChannel.h"

#include "base/basictypes.h"
#include "mozilla/Logging.h"

#include "nsDOMDataChannelDeclarations.h"
#include "nsDOMDataChannel.h"
#include "nsIDOMDataChannel.h"
#include "mozilla/DOMEventTargetHelper.h"
#include "mozilla/dom/File.h"
#include "mozilla/dom/MessageEvent.h"
#include "mozilla/dom/MessageEventBinding.h"
#include "mozilla/dom/ScriptSettings.h"

#include "nsError.h"
#include "nsContentUtils.h"
#include "nsCycleCollectionParticipant.h"
#include "nsIScriptObjectPrincipal.h"
#include "nsProxyRelease.h"

#include "DataChannel.h"
#include "DataChannelLog.h"

#undef LOG
#define LOG(args) MOZ_LOG(mozilla::gDataChannelLog, mozilla::LogLevel::Debug, args)

// Since we've moved the windows.h include down here, we have to explicitly
// undef GetBinaryType, otherwise we'll get really odd conflicts
#ifdef GetBinaryType
#undef GetBinaryType
#endif

using namespace mozilla;
using namespace mozilla::dom;

nsDOMDataChannel::~nsDOMDataChannel()
{
  // Don't call us anymore!  Likely isn't an issue (or maybe just less of
  // one) once we block GC until all the (appropriate) onXxxx handlers
  // are dropped. (See WebRTC spec)
  LOG(("%p: Close()ing %p", this, mDataChannel.get()));
  mDataChannel->SetListener(nullptr, nullptr);
  mDataChannel->Close();
}

/* virtual */ JSObject*
nsDOMDataChannel::WrapObject(JSContext* aCx, JS::Handle<JSObject*> aGivenProto)
{
  return DataChannelBinding::Wrap(aCx, this, aGivenProto);
}

NS_IMPL_CYCLE_COLLECTION_CLASS(nsDOMDataChannel)

NS_IMPL_CYCLE_COLLECTION_TRAVERSE_BEGIN_INHERITED(nsDOMDataChannel,
                                                  DOMEventTargetHelper)
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_END

NS_IMPL_CYCLE_COLLECTION_UNLINK_BEGIN_INHERITED(nsDOMDataChannel,
                                                DOMEventTargetHelper)
NS_IMPL_CYCLE_COLLECTION_UNLINK_END

NS_IMPL_ADDREF_INHERITED(nsDOMDataChannel, DOMEventTargetHelper)
NS_IMPL_RELEASE_INHERITED(nsDOMDataChannel, DOMEventTargetHelper)

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION_INHERITED(nsDOMDataChannel)
  NS_INTERFACE_MAP_ENTRY(nsIDOMDataChannel)
NS_INTERFACE_MAP_END_INHERITING(DOMEventTargetHelper)

nsDOMDataChannel::nsDOMDataChannel(already_AddRefed<mozilla::DataChannel>& aDataChannel,
                                   nsPIDOMWindowInner* aWindow)
  : DOMEventTargetHelper(aWindow)
  , mDataChannel(aDataChannel)
  , mBinaryType(DC_BINARY_TYPE_BLOB)
  , mCheckMustKeepAlive(true)
  , mSentClose(false)
{
}

nsresult
nsDOMDataChannel::Init(nsPIDOMWindowInner* aDOMWindow)
{
  nsresult rv;
  nsAutoString urlParam;

  MOZ_ASSERT(mDataChannel);
  mDataChannel->SetListener(this, nullptr);

  // Now grovel through the objects to get a usable origin for onMessage
  nsCOMPtr<nsIScriptGlobalObject> sgo = do_QueryInterface(aDOMWindow);
  NS_ENSURE_STATE(sgo);
  nsCOMPtr<nsIScriptContext> scriptContext = sgo->GetContext();
  NS_ENSURE_STATE(scriptContext);

  nsCOMPtr<nsIScriptObjectPrincipal> scriptPrincipal(do_QueryInterface(aDOMWindow));
  NS_ENSURE_STATE(scriptPrincipal);
  nsCOMPtr<nsIPrincipal> principal = scriptPrincipal->GetPrincipal();
  NS_ENSURE_STATE(principal);

  // Attempt to kill "ghost" DataChannel (if one can happen): but usually too early for check to fail
  rv = CheckInnerWindowCorrectness();
  NS_ENSURE_SUCCESS(rv,rv);

  rv = nsContentUtils::GetUTFOrigin(principal,mOrigin);
  LOG(("%s: origin = %s\n",__FUNCTION__,NS_LossyConvertUTF16toASCII(mOrigin).get()));
  return rv;
}

NS_IMPL_EVENT_HANDLER(nsDOMDataChannel, open)
NS_IMPL_EVENT_HANDLER(nsDOMDataChannel, error)
NS_IMPL_EVENT_HANDLER(nsDOMDataChannel, close)
NS_IMPL_EVENT_HANDLER(nsDOMDataChannel, message)

// Most of the GetFoo()/SetFoo()s don't need to touch shared resources and
// are safe after Close()
NS_IMETHODIMP
nsDOMDataChannel::GetLabel(nsAString& aLabel)
{
  mDataChannel->GetLabel(aLabel);
  return NS_OK;
}

NS_IMETHODIMP
nsDOMDataChannel::GetProtocol(nsAString& aProtocol)
{
  mDataChannel->GetProtocol(aProtocol);
  return NS_OK;
}

uint16_t
nsDOMDataChannel::Id() const
{
  return mDataChannel->GetStream();
}

NS_IMETHODIMP
nsDOMDataChannel::GetId(uint16_t *aId)
{
  *aId = Id();
  return NS_OK;
}

// XXX should be GetType()?  Open question for the spec
bool
nsDOMDataChannel::Reliable() const
{
  return mDataChannel->GetType() == mozilla::DataChannelConnection::RELIABLE;
}

NS_IMETHODIMP
nsDOMDataChannel::GetReliable(bool* aReliable)
{
  *aReliable = Reliable();
  return NS_OK;
}

bool
nsDOMDataChannel::Ordered() const
{
  return mDataChannel->GetOrdered();
}

NS_IMETHODIMP
nsDOMDataChannel::GetOrdered(bool* aOrdered)
{
  *aOrdered = Ordered();
  return NS_OK;
}

RTCDataChannelState
nsDOMDataChannel::ReadyState() const
{
  return static_cast<RTCDataChannelState>(mDataChannel->GetReadyState());
}


NS_IMETHODIMP
nsDOMDataChannel::GetReadyState(nsAString& aReadyState)
{
  // mState is handled on multiple threads and needs locking
  uint16_t readyState = mozilla::DataChannel::CLOSED;
  if (!mSentClose) {
    readyState = mDataChannel->GetReadyState();
  }
  // From the WebRTC spec
  const char * stateName[] = {
    "connecting",
    "open",
    "closing",
    "closed"
  };
  MOZ_ASSERT(/*readyState >= mozilla::DataChannel::CONNECTING && */ // Always true due to datatypes
             readyState <= mozilla::DataChannel::CLOSED);
  aReadyState.AssignASCII(stateName[readyState]);

  return NS_OK;
}

uint32_t
nsDOMDataChannel::BufferedAmount() const
{
  if (!mSentClose) {
    return mDataChannel->GetBufferedAmount();
  }
  return 0;
}

uint32_t
nsDOMDataChannel::BufferedAmountLowThreshold() const
{
  return mDataChannel->GetBufferedAmountLowThreshold();
}

NS_IMETHODIMP
nsDOMDataChannel::GetBufferedAmount(uint32_t* aBufferedAmount)
{
  *aBufferedAmount = BufferedAmount();
  return NS_OK;
}

void
nsDOMDataChannel::SetBufferedAmountLowThreshold(uint32_t aThreshold)
{
  mDataChannel->SetBufferedAmountLowThreshold(aThreshold);
}

NS_IMETHODIMP nsDOMDataChannel::GetBinaryType(nsAString & aBinaryType)
{
  switch (mBinaryType) {
  case DC_BINARY_TYPE_ARRAYBUFFER:
    aBinaryType.AssignLiteral("arraybuffer");
    break;
  case DC_BINARY_TYPE_BLOB:
    aBinaryType.AssignLiteral("blob");
    break;
  default:
    NS_ERROR("Should not happen");
  }
  return NS_OK;
}

NS_IMETHODIMP
nsDOMDataChannel::SetBinaryType(const nsAString& aBinaryType)
{
  if (aBinaryType.EqualsLiteral("arraybuffer")) {
    mBinaryType = DC_BINARY_TYPE_ARRAYBUFFER;
  } else if (aBinaryType.EqualsLiteral("blob")) {
    mBinaryType = DC_BINARY_TYPE_BLOB;
  } else  {
    return NS_ERROR_INVALID_ARG;
  }
  return NS_OK;
}

NS_IMETHODIMP
nsDOMDataChannel::Close()
{
  mDataChannel->Close();
  UpdateMustKeepAlive();
  return NS_OK;
}

// All of the following is copy/pasted from WebSocket.cpp.
void
nsDOMDataChannel::Send(const nsAString& aData, ErrorResult& aRv)
{
  NS_ConvertUTF16toUTF8 msgString(aData);
  Send(nullptr, msgString, msgString.Length(), false, aRv);
}

void
nsDOMDataChannel::Send(Blob& aData, ErrorResult& aRv)
{
  MOZ_ASSERT(NS_IsMainThread(), "Not running on main thread");

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
nsDOMDataChannel::Send(const ArrayBuffer& aData, ErrorResult& aRv)
{
  MOZ_ASSERT(NS_IsMainThread(), "Not running on main thread");

  aData.ComputeLengthAndData();

  static_assert(sizeof(*aData.Data()) == 1, "byte-sized data required");

  uint32_t len = aData.Length();
  char* data = reinterpret_cast<char*>(aData.Data());

  nsDependentCSubstring msgString(data, len);
  Send(nullptr, msgString, len, true, aRv);
}

void
nsDOMDataChannel::Send(const ArrayBufferView& aData, ErrorResult& aRv)
{
  MOZ_ASSERT(NS_IsMainThread(), "Not running on main thread");

  aData.ComputeLengthAndData();

  static_assert(sizeof(*aData.Data()) == 1, "byte-sized data required");

  uint32_t len = aData.Length();
  char* data = reinterpret_cast<char*>(aData.Data());

  nsDependentCSubstring msgString(data, len);
  Send(nullptr, msgString, len, true, aRv);
}

void
nsDOMDataChannel::Send(nsIInputStream* aMsgStream,
                       const nsACString& aMsgString,
                       uint32_t aMsgLength,
                       bool aIsBinary,
                       ErrorResult& aRv)
{
  MOZ_ASSERT(NS_IsMainThread());
  uint16_t state = mozilla::DataChannel::CLOSED;
  if (!mSentClose) {
    state = mDataChannel->GetReadyState();
  }

  // In reality, the DataChannel protocol allows this, but we want it to
  // look like WebSockets
  if (state == mozilla::DataChannel::CONNECTING) {
    aRv.Throw(NS_ERROR_DOM_INVALID_STATE_ERR);
    return;
  }

  if (state == mozilla::DataChannel::CLOSING ||
      state == mozilla::DataChannel::CLOSED) {
    return;
  }

  MOZ_ASSERT(state == mozilla::DataChannel::OPEN,
             "Unknown state in nsDOMDataChannel::Send");

  bool sent;
  if (aMsgStream) {
    sent = mDataChannel->SendBinaryStream(aMsgStream, aMsgLength);
  } else {
    if (aIsBinary) {
      sent = mDataChannel->SendBinaryMsg(aMsgString);
    } else {
      sent = mDataChannel->SendMsg(aMsgString);
    }
  }
  if (!sent) {
    aRv.Throw(NS_ERROR_FAILURE);
  }
}

nsresult
nsDOMDataChannel::DoOnMessageAvailable(const nsACString& aData,
                                       bool aBinary)
{
  MOZ_ASSERT(NS_IsMainThread());

  LOG(("DoOnMessageAvailable%s\n",aBinary ? ((mBinaryType == DC_BINARY_TYPE_BLOB) ? " (blob)" : " (binary)") : ""));

  nsresult rv = CheckInnerWindowCorrectness();
  if (NS_FAILED(rv)) {
    return NS_OK;
  }

  AutoJSAPI jsapi;
  if (NS_WARN_IF(!jsapi.Init(GetOwner()))) {
    return NS_ERROR_FAILURE;
  }
  JSContext* cx = jsapi.cx();

  JS::Rooted<JS::Value> jsData(cx);

  if (aBinary) {
    if (mBinaryType == DC_BINARY_TYPE_BLOB) {
      RefPtr<Blob> blob =
        Blob::CreateStringBlob(GetOwner(), aData, EmptyString());
      MOZ_ASSERT(blob);

      if (!ToJSValue(cx, blob, &jsData)) {
        return NS_ERROR_FAILURE;
      }
    } else if (mBinaryType == DC_BINARY_TYPE_ARRAYBUFFER) {
      JS::Rooted<JSObject*> arrayBuf(cx);
      rv = nsContentUtils::CreateArrayBuffer(cx, aData, arrayBuf.address());
      NS_ENSURE_SUCCESS(rv, rv);
      jsData.setObject(*arrayBuf);
    } else {
      NS_RUNTIMEABORT("Unknown binary type!");
      return NS_ERROR_UNEXPECTED;
    }
  } else {
    NS_ConvertUTF8toUTF16 utf16data(aData);
    JSString* jsString = JS_NewUCStringCopyN(cx, utf16data.get(), utf16data.Length());
    NS_ENSURE_TRUE(jsString, NS_ERROR_FAILURE);

    jsData.setString(jsString);
  }

  RefPtr<MessageEvent> event = new MessageEvent(this, nullptr, nullptr);

  event->InitMessageEvent(nullptr, NS_LITERAL_STRING("message"), false, false,
                          jsData, mOrigin, EmptyString(), nullptr,
                          Sequence<OwningNonNull<MessagePort>>());
  event->SetTrusted(true);

  LOG(("%p(%p): %s - Dispatching\n",this,(void*)mDataChannel,__FUNCTION__));
  rv = DispatchDOMEvent(nullptr, static_cast<Event*>(event), nullptr, nullptr);
  if (NS_FAILED(rv)) {
    NS_WARNING("Failed to dispatch the message event!!!");
  }
  return rv;
}

nsresult
nsDOMDataChannel::OnMessageAvailable(nsISupports* aContext,
                                     const nsACString& aMessage)
{
  MOZ_ASSERT(NS_IsMainThread());
  return DoOnMessageAvailable(aMessage, false);
}

nsresult
nsDOMDataChannel::OnBinaryMessageAvailable(nsISupports* aContext,
                                           const nsACString& aMessage)
{
  MOZ_ASSERT(NS_IsMainThread());
  return DoOnMessageAvailable(aMessage, true);
}

nsresult
nsDOMDataChannel::OnSimpleEvent(nsISupports* aContext, const nsAString& aName)
{
  MOZ_ASSERT(NS_IsMainThread());

  nsresult rv = CheckInnerWindowCorrectness();
  if (NS_FAILED(rv)) {
    return NS_OK;
  }

  RefPtr<Event> event = NS_NewDOMEvent(this, nullptr, nullptr);

  event->InitEvent(aName, false, false);
  event->SetTrusted(true);

  return DispatchDOMEvent(nullptr, event, nullptr, nullptr);
}

nsresult
nsDOMDataChannel::OnChannelConnected(nsISupports* aContext)
{
  LOG(("%p(%p): %s - Dispatching\n",this,(void*)mDataChannel,__FUNCTION__));

  return OnSimpleEvent(aContext, NS_LITERAL_STRING("open"));
}

nsresult
nsDOMDataChannel::OnChannelClosed(nsISupports* aContext)
{
  nsresult rv;
  // so we don't have to worry if we're notified from different paths in
  // the underlying code
  if (!mSentClose) {
    // Ok, we're done with it.
    mDataChannel->ReleaseConnection();
    LOG(("%p(%p): %s - Dispatching\n",this,(void*)mDataChannel,__FUNCTION__));

    rv = OnSimpleEvent(aContext, NS_LITERAL_STRING("close"));
    // no more events can happen
    mSentClose = true;
  } else {
    rv = NS_OK;
  }
  DontKeepAliveAnyMore();
  return rv;
}

nsresult
nsDOMDataChannel::OnBufferLow(nsISupports* aContext)
{
  LOG(("%p(%p): %s - Dispatching\n",this,(void*)mDataChannel,__FUNCTION__));

  return OnSimpleEvent(aContext, NS_LITERAL_STRING("bufferedamountlow"));
}

nsresult
nsDOMDataChannel::NotBuffered(nsISupports* aContext)
{
  // In the rare case that we held off GC to let the buffer drain
  UpdateMustKeepAlive();
  return NS_OK;
}

void
nsDOMDataChannel::AppReady()
{
  if (!mSentClose) { // may not be possible, simpler to just test anyways
    mDataChannel->AppReady();
  }
}

//-----------------------------------------------------------------------------
// Methods that keep alive the DataChannel object when:
//   1. the object has registered event listeners that can be triggered
//      ("strong event listeners");
//   2. there are outgoing not sent messages.
//-----------------------------------------------------------------------------

void
nsDOMDataChannel::UpdateMustKeepAlive()
{
  MOZ_ASSERT(NS_IsMainThread());

  if (!mCheckMustKeepAlive) {
    return;
  }

  bool shouldKeepAlive = false;
  uint16_t readyState = mDataChannel->GetReadyState();

  switch (readyState)
  {
    case DataChannel::CONNECTING:
    case DataChannel::WAITING_TO_OPEN:
    {
      if (mListenerManager &&
          (mListenerManager->HasListenersFor(nsGkAtoms::onopen) ||
           mListenerManager->HasListenersFor(nsGkAtoms::onmessage) ||
           mListenerManager->HasListenersFor(nsGkAtoms::onerror) ||
           mListenerManager->HasListenersFor(nsGkAtoms::onbufferedamountlow) ||
           mListenerManager->HasListenersFor(nsGkAtoms::onclose))) {
        shouldKeepAlive = true;
      }
    }
    break;

    case DataChannel::OPEN:
    case DataChannel::CLOSING:
    {
      if (mDataChannel->GetBufferedAmount() != 0 ||
          (mListenerManager &&
           (mListenerManager->HasListenersFor(nsGkAtoms::onmessage) ||
            mListenerManager->HasListenersFor(nsGkAtoms::onerror) ||
            mListenerManager->HasListenersFor(nsGkAtoms::onbufferedamountlow) ||
            mListenerManager->HasListenersFor(nsGkAtoms::onclose)))) {
        shouldKeepAlive = true;
      }
    }
    break;

    case DataChannel::CLOSED:
    {
      shouldKeepAlive = false;
    }
  }

  if (mSelfRef && !shouldKeepAlive) {
    // release our self-reference (safely) by putting it in an event (always)
    NS_ReleaseOnMainThread(mSelfRef.forget(), true);
  } else if (!mSelfRef && shouldKeepAlive) {
    mSelfRef = this;
  }
}

void
nsDOMDataChannel::DontKeepAliveAnyMore()
{
  MOZ_ASSERT(NS_IsMainThread());

  if (mSelfRef) {
    // Since we're on MainThread, force an eventloop trip to avoid deleting ourselves.
    NS_ReleaseOnMainThread(mSelfRef.forget(), true);
  }

  mCheckMustKeepAlive = false;
}

void
nsDOMDataChannel::EventListenerAdded(nsIAtom* aType)
{
  MOZ_ASSERT(NS_IsMainThread());
  UpdateMustKeepAlive();
}

void
nsDOMDataChannel::EventListenerRemoved(nsIAtom* aType)
{
  MOZ_ASSERT(NS_IsMainThread());
  UpdateMustKeepAlive();
}


/* static */
nsresult
NS_NewDOMDataChannel(already_AddRefed<mozilla::DataChannel>&& aDataChannel,
                     nsPIDOMWindowInner* aWindow,
                     nsIDOMDataChannel** aDomDataChannel)
{
  RefPtr<nsDOMDataChannel> domdc =
    new nsDOMDataChannel(aDataChannel, aWindow);

  nsresult rv = domdc->Init(aWindow);
  NS_ENSURE_SUCCESS(rv,rv);

  return CallQueryInterface(domdc, aDomDataChannel);
}

/* static */
void
NS_DataChannelAppReady(nsIDOMDataChannel* aDomDataChannel)
{
  ((nsDOMDataChannel *)aDomDataChannel)->AppReady();
}
