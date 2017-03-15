/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/dom/HTMLMediaElement.h"
#include "mozilla/dom/HTMLMediaElementBinding.h"
#include "mozilla/dom/HTMLSourceElement.h"
#include "mozilla/dom/ElementInlines.h"
#include "mozilla/ArrayUtils.h"
#include "mozilla/MathAlgorithms.h"
#include "mozilla/AsyncEventDispatcher.h"
#include "mozilla/dom/MediaEncryptedEvent.h"

#include "base/basictypes.h"
#include "nsIDOMHTMLMediaElement.h"
#include "nsIDOMHTMLSourceElement.h"
#include "TimeRanges.h"
#include "nsGenericHTMLElement.h"
#include "nsAttrValueInlines.h"
#include "nsPresContext.h"
#include "nsIPresShell.h"
#include "nsGkAtoms.h"
#include "nsSize.h"
#include "nsIFrame.h"
#include "nsIDocument.h"
#include "nsIDOMDocument.h"
#include "nsIDocShell.h"
#include "nsError.h"
#include "nsNodeInfoManager.h"
#include "nsNetUtil.h"
#include "nsXPCOMStrings.h"
#include "xpcpublic.h"
#include "nsThreadUtils.h"
#include "nsIThreadInternal.h"
#include "nsContentUtils.h"
#include "nsIRequest.h"
#include "nsQueryObject.h"
#include "nsIObserverService.h"
#include "nsISupportsPrimitives.h"

#include "nsIScriptSecurityManager.h"
#include "nsIXPConnect.h"
#include "jsapi.h"

#include "nsITimer.h"

#include "MediaError.h"
#include "MediaDecoder.h"
#include "MediaPrefs.h"
#include "MediaResource.h"

#include "nsICategoryManager.h"
#include "nsIContentPolicy.h"
#include "nsContentPolicyUtils.h"
#include "nsCycleCollectionParticipant.h"
#include "nsICachingChannel.h"
#include "nsLayoutUtils.h"
#include "nsVideoFrame.h"
#include "Layers.h"
#include <limits>
#include "nsIAsyncVerifyRedirectCallback.h"
#include "nsMediaFragmentURIParser.h"
#include "nsURIHashKey.h"
#include "nsJSUtils.h"
#include "MediaStreamGraph.h"
#include "nsIScriptError.h"
#include "nsHostObjectProtocolHandler.h"
#include "mozilla/dom/MediaSource.h"
#include "MediaMetadataManager.h"
#include "MediaSourceDecoder.h"
#include "MediaStreamListener.h"
#include "DOMMediaStream.h"
#include "AudioStreamTrack.h"
#include "VideoStreamTrack.h"
#include "MediaTrackList.h"
#include "MediaStreamError.h"
#include "VideoFrameContainer.h"

#include "AudioChannelService.h"

#include "mozilla/dom/power/PowerManagerService.h"
#include "mozilla/dom/WakeLock.h"

#include "mozilla/dom/AudioTrack.h"
#include "mozilla/dom/AudioTrackList.h"
#include "mozilla/dom/MediaErrorBinding.h"
#include "mozilla/dom/VideoTrack.h"
#include "mozilla/dom/VideoTrackList.h"
#include "mozilla/dom/TextTrack.h"
#include "nsIContentPolicy.h"
#include "mozilla/Telemetry.h"
#include "DecoderDoctorDiagnostics.h"
#include "DecoderTraits.h"
#include "MediaContentType.h"

#include "ImageContainer.h"
#include "nsRange.h"
#include <algorithm>
#include <cmath>

static mozilla::LazyLogModule gMediaElementLog("nsMediaElement");
static mozilla::LazyLogModule gMediaElementEventsLog("nsMediaElementEvents");

#define LOG(type, msg) MOZ_LOG(gMediaElementLog, type, msg)
#define LOG_EVENT(type, msg) MOZ_LOG(gMediaElementEventsLog, type, msg)

#include "nsIContentSecurityPolicy.h"

#include "mozilla/Preferences.h"
#include "mozilla/FloatingPoint.h"

#include "nsIPermissionManager.h"
#include "nsDocShell.h"

#include "mozilla/EventStateManager.h"

#include "mozilla/dom/HTMLVideoElement.h"
#include "mozilla/dom/VideoPlaybackQuality.h"

using namespace mozilla::layers;
using mozilla::net::nsMediaFragmentURIParser;

class MOZ_STACK_CLASS AutoNotifyAudioChannelAgent
{
  RefPtr<mozilla::dom::HTMLMediaElement> mElement;
  MOZ_DECL_USE_GUARD_OBJECT_NOTIFIER;
public:
  explicit AutoNotifyAudioChannelAgent(mozilla::dom::HTMLMediaElement* aElement
                                       MOZ_GUARD_OBJECT_NOTIFIER_PARAM)
    : mElement(aElement)
  {
    MOZ_GUARD_OBJECT_NOTIFIER_INIT;
  }

  ~AutoNotifyAudioChannelAgent()
  {
    mElement->UpdateAudioChannelPlayingState();
  }
};

namespace mozilla {
namespace dom {

// Number of milliseconds between progress events as defined by spec
static const uint32_t PROGRESS_MS = 350;

// Number of milliseconds of no data before a stall event is fired as defined by spec
static const uint32_t STALL_MS = 3000;

// Used by AudioChannel for suppresssing the volume to this ratio.
#define FADED_VOLUME_RATIO 0.25

// These constants are arbitrary
// Minimum playbackRate for a media
static const double MIN_PLAYBACKRATE = 0.25;
// Maximum playbackRate for a media
static const double MAX_PLAYBACKRATE = 5.0;
// These are the limits beyonds which SoundTouch does not perform too well and when
// speech is hard to understand anyway.
// Threshold above which audio is muted
static const double THRESHOLD_HIGH_PLAYBACKRATE_AUDIO = 4.0;
// Threshold under which audio is muted
static const double THRESHOLD_LOW_PLAYBACKRATE_AUDIO = 0.5;

// Media error values.  These need to match the ones in MediaError.webidl.
static const unsigned short MEDIA_ERR_ABORTED = 1;
static const unsigned short MEDIA_ERR_NETWORK = 2;
static const unsigned short MEDIA_ERR_DECODE = 3;
static const unsigned short MEDIA_ERR_SRC_NOT_SUPPORTED = 4;

// Under certain conditions there may be no-one holding references to
// a media element from script, DOM parent, etc, but the element may still
// fire meaningful events in the future so we can't destroy it yet:
// 1) If the element is delaying the load event (or would be, if it were
// in a document), then events up to loadeddata or error could be fired,
// so we need to stay alive.
// 2) If the element is not paused and playback has not ended, then
// we will (or might) play, sending timeupdate and ended events and possibly
// audio output, so we need to stay alive.
// 3) if the element is seeking then we will fire seeking events and possibly
// start playing afterward, so we need to stay alive.
// 4) If autoplay could start playback in this element (if we got enough data),
// then we need to stay alive.
// 5) if the element is currently loading, not suspended, and its source is
// not a MediaSource, then script might be waiting for progress events or a
// 'stalled' or 'suspend' event, so we need to stay alive.
// If we're already suspended then (all other conditions being met),
// it's OK to just disappear without firing any more events,
// since we have the freedom to remain suspended indefinitely. Note
// that we could use this 'suspended' loophole to garbage-collect a suspended
// element in case 4 even if it had 'autoplay' set, but we choose not to.
// If someone throws away all references to a loading 'autoplay' element
// sound should still eventually play.
// 6) If the source is a MediaSource, most loading events will not fire unless
// appendBuffer() is called on a SourceBuffer, in which case something is
// already referencing the SourceBuffer, which keeps the associated media
// element alive. Further, a MediaSource will never time out the resource
// fetch, and so should not keep the media element alive if it is
// unreferenced. A pending 'stalled' event keeps the media element alive.
//
// Media elements owned by inactive documents (i.e. documents not contained in any
// document viewer) should never hold a self-reference because none of the
// above conditions are allowed: the element will stop loading and playing
// and never resume loading or playing unless its owner document changes to
// an active document (which can only happen if there is an external reference
// to the element).
// Media elements with no owner doc should be able to hold a self-reference.
// Something native must have created the element and may expect it to
// stay alive to play.

// It's very important that any change in state which could change the value of
// needSelfReference in AddRemoveSelfReference be followed by a call to
// AddRemoveSelfReference before this element could die!
// It's especially important if needSelfReference would change to 'true',
// since if we neglect to add a self-reference, this element might be
// garbage collected while there are still event listeners that should
// receive events. If we neglect to remove the self-reference then the element
// just lives longer than it needs to.

class nsMediaEvent : public Runnable
{
public:

  explicit nsMediaEvent(HTMLMediaElement* aElement) :
    mElement(aElement),
    mLoadID(mElement->GetCurrentLoadID()) {}
  ~nsMediaEvent() {}

  NS_IMETHOD Run() = 0;

protected:
  bool IsCancelled() {
    return mElement->GetCurrentLoadID() != mLoadID;
  }

  RefPtr<HTMLMediaElement> mElement;
  uint32_t mLoadID;
};

class HTMLMediaElement::nsAsyncEventRunner : public nsMediaEvent
{
private:
  nsString mName;

public:
  nsAsyncEventRunner(const nsAString& aName, HTMLMediaElement* aElement) :
    nsMediaEvent(aElement), mName(aName)
  {
  }

  NS_IMETHOD Run() override
  {
    // Silently cancel if our load has been cancelled.
    if (IsCancelled())
      return NS_OK;

    return mElement->DispatchEvent(mName);
  }
};

class nsSourceErrorEventRunner : public nsMediaEvent
{
private:
  nsCOMPtr<nsIContent> mSource;
public:
  nsSourceErrorEventRunner(HTMLMediaElement* aElement,
                           nsIContent* aSource)
    : nsMediaEvent(aElement),
      mSource(aSource)
  {
  }

  NS_IMETHOD Run() override {
    // Silently cancel if our load has been cancelled.
    if (IsCancelled())
      return NS_OK;
    LOG_EVENT(LogLevel::Debug, ("%p Dispatching simple event source error", mElement.get()));
    return nsContentUtils::DispatchTrustedEvent(mElement->OwnerDoc(),
                                                mSource,
                                                NS_LITERAL_STRING("error"),
                                                false,
                                                false);
  }
};

/**
 * This listener observes the first video frame to arrive with a non-empty size,
 * and calls HTMLMediaElement::UpdateInitialMediaSize() with that size.
 */
class HTMLMediaElement::StreamSizeListener : public DirectMediaStreamTrackListener {
public:
  explicit StreamSizeListener(HTMLMediaElement* aElement) :
    mElement(aElement),
    mInitialSizeFound(false)
  {}

  void Forget() { mElement = nullptr; }

  void ReceivedSize(gfx::IntSize aSize)
  {
    MOZ_ASSERT(NS_IsMainThread());

    if (!mElement) {
      return;
    }

    RefPtr<HTMLMediaElement> deathGrip = mElement;
    deathGrip->UpdateInitialMediaSize(aSize);
  }

  void NotifyRealtimeTrackData(MediaStreamGraph* aGraph,
                               StreamTime aTrackOffset,
                               const MediaSegment& aMedia) override
  {
    if (mInitialSizeFound) {
      return;
    }

    if (aMedia.GetType() != MediaSegment::VIDEO) {
      MOZ_ASSERT(false, "Should only lock on to a video track");
      return;
    }

    const VideoSegment& video = static_cast<const VideoSegment&>(aMedia);
    for (VideoSegment::ConstChunkIterator c(video); !c.IsEnded(); c.Next()) {
      if (c->mFrame.GetIntrinsicSize() != gfx::IntSize(0,0)) {
        mInitialSizeFound = true;
        nsCOMPtr<nsIRunnable> event =
          NewRunnableMethod<gfx::IntSize>(this, &StreamSizeListener::ReceivedSize,
                                          c->mFrame.GetIntrinsicSize());
        // This is fine to dispatch straight to main thread (instead of via
        // ...AfterStreamUpdate()) since it reflects state of the element,
        // not the stream. Events reflecting stream or track state should be
        // dispatched so their order is preserved.
        NS_DispatchToMainThread(event.forget());
        return;
      }
    }
  }

private:
  // These fields may only be accessed on the main thread
  HTMLMediaElement* mElement;

  // These fields may only be accessed on the MSG's appending thread.
  // (this is a direct listener so we get called by whoever is producing
  // this track's data)
  bool mInitialSizeFound;
};

/**
 * There is a reference cycle involving this class: MediaLoadListener
 * holds a reference to the HTMLMediaElement, which holds a reference
 * to an nsIChannel, which holds a reference to this listener.
 * We break the reference cycle in OnStartRequest by clearing mElement.
 */
class HTMLMediaElement::MediaLoadListener final : public nsIStreamListener,
                                                  public nsIChannelEventSink,
                                                  public nsIInterfaceRequestor,
                                                  public nsIObserver
{
  ~MediaLoadListener() {}

  NS_DECL_ISUPPORTS
  NS_DECL_NSIREQUESTOBSERVER
  NS_DECL_NSISTREAMLISTENER
  NS_DECL_NSICHANNELEVENTSINK
  NS_DECL_NSIOBSERVER
  NS_DECL_NSIINTERFACEREQUESTOR

public:
  explicit MediaLoadListener(HTMLMediaElement* aElement)
    : mElement(aElement),
      mLoadID(aElement->GetCurrentLoadID())
  {
    MOZ_ASSERT(mElement, "Must pass an element to call back");
  }

private:
  RefPtr<HTMLMediaElement> mElement;
  nsCOMPtr<nsIStreamListener> mNextListener;
  const uint32_t mLoadID;
};

NS_IMPL_ISUPPORTS(HTMLMediaElement::MediaLoadListener, nsIRequestObserver,
                  nsIStreamListener, nsIChannelEventSink,
                  nsIInterfaceRequestor, nsIObserver)

NS_IMETHODIMP
HTMLMediaElement::MediaLoadListener::Observe(nsISupports* aSubject,
                                             const char* aTopic,
                                             const char16_t* aData)
{
  nsContentUtils::UnregisterShutdownObserver(this);

  // Clear mElement to break cycle so we don't leak on shutdown
  mElement = nullptr;
  return NS_OK;
}

NS_IMETHODIMP
HTMLMediaElement::MediaLoadListener::OnStartRequest(nsIRequest* aRequest,
                                                    nsISupports* aContext)
{
  nsContentUtils::UnregisterShutdownObserver(this);

  if (!mElement) {
    // We've been notified by the shutdown observer, and are shutting down.
    return NS_BINDING_ABORTED;
  }

  // The element is only needed until we've had a chance to call
  // InitializeDecoderForChannel. So make sure mElement is cleared here.
  RefPtr<HTMLMediaElement> element;
  element.swap(mElement);

  if (mLoadID != element->GetCurrentLoadID()) {
    // The channel has been cancelled before we had a chance to create
    // a decoder. Abort, don't dispatch an "error" event, as the new load
    // may not be in an error state.
    return NS_BINDING_ABORTED;
  }

  // Don't continue to load if the request failed or has been canceled.
  nsresult status;
  nsresult rv = aRequest->GetStatus(&status);
  NS_ENSURE_SUCCESS(rv, rv);
  if (NS_FAILED(status)) {
    if (element) {
      // Handle media not loading error because source was a tracking URL.
      // We make a note of this media node by including it in a dedicated
      // array of blocked tracking nodes under its parent document.
      if (status == NS_ERROR_TRACKING_URI) {
        nsIDocument* ownerDoc = element->OwnerDoc();
        if (ownerDoc) {
          ownerDoc->AddBlockedTrackingNode(element);
        }
      }
      element->NotifyLoadError();
    }
    return status;
  }

  nsCOMPtr<nsIHttpChannel> hc = do_QueryInterface(aRequest);
  bool succeeded;
  if (hc && NS_SUCCEEDED(hc->GetRequestSucceeded(&succeeded)) && !succeeded) {
    element->NotifyLoadError();
    uint32_t responseStatus = 0;
    hc->GetResponseStatus(&responseStatus);
    nsAutoString code;
    code.AppendInt(responseStatus);
    nsAutoString src;
    element->GetCurrentSrc(src);
    const char16_t* params[] = { code.get(), src.get() };
    element->ReportLoadError("MediaLoadHttpError", params, ArrayLength(params));
    return NS_BINDING_ABORTED;
  }

  nsCOMPtr<nsIChannel> channel = do_QueryInterface(aRequest);
  if (channel &&
      NS_SUCCEEDED(rv = element->InitializeDecoderForChannel(channel, getter_AddRefs(mNextListener))) &&
      mNextListener) {
    rv = mNextListener->OnStartRequest(aRequest, aContext);
  } else {
    // If InitializeDecoderForChannel() returned an error, fire a network error.
    if (NS_FAILED(rv) && !mNextListener) {
      // Load failed, attempt to load the next candidate resource. If there
      // are none, this will trigger a MEDIA_ERR_SRC_NOT_SUPPORTED error.
      element->NotifyLoadError();
    }
    // If InitializeDecoderForChannel did not return a listener (but may
    // have otherwise succeeded), we abort the connection since we aren't
    // interested in keeping the channel alive ourselves.
    rv = NS_BINDING_ABORTED;
  }

  return rv;
}

NS_IMETHODIMP
HTMLMediaElement::MediaLoadListener::OnStopRequest(nsIRequest* aRequest,
                                                   nsISupports* aContext,
                                                   nsresult aStatus)
{
  if (mNextListener) {
    return mNextListener->OnStopRequest(aRequest, aContext, aStatus);
  }
  return NS_OK;
}

NS_IMETHODIMP
HTMLMediaElement::MediaLoadListener::OnDataAvailable(nsIRequest* aRequest,
                                                     nsISupports* aContext,
                                                     nsIInputStream* aStream,
                                                     uint64_t aOffset,
                                                     uint32_t aCount)
{
  if (!mNextListener) {
    NS_ERROR("Must have a chained listener; OnStartRequest should have canceled this request");
    return NS_BINDING_ABORTED;
  }
  return mNextListener->OnDataAvailable(aRequest, aContext, aStream, aOffset, aCount);
}

NS_IMETHODIMP
HTMLMediaElement::MediaLoadListener::AsyncOnChannelRedirect(nsIChannel* aOldChannel,
                                                            nsIChannel* aNewChannel,
                                                            uint32_t aFlags,
                                                            nsIAsyncVerifyRedirectCallback* cb)
{
  // TODO is this really correct?? See bug #579329.
  if (mElement) {
    mElement->OnChannelRedirect(aOldChannel, aNewChannel, aFlags);
  }
  nsCOMPtr<nsIChannelEventSink> sink = do_QueryInterface(mNextListener);
  if (sink) {
    return sink->AsyncOnChannelRedirect(aOldChannel, aNewChannel, aFlags, cb);
  }
  cb->OnRedirectVerifyCallback(NS_OK);
  return NS_OK;
}

NS_IMETHODIMP
HTMLMediaElement::MediaLoadListener::GetInterface(const nsIID& aIID,
                                                  void** aResult)
{
  return QueryInterface(aIID, aResult);
}

void HTMLMediaElement::ReportLoadError(const char* aMsg,
                                       const char16_t** aParams,
                                       uint32_t aParamCount)
{
  nsContentUtils::ReportToConsole(nsIScriptError::warningFlag,
                                  NS_LITERAL_CSTRING("Media"),
                                  OwnerDoc(),
                                  nsContentUtils::eDOM_PROPERTIES,
                                  aMsg,
                                  aParams,
                                  aParamCount);
}

class HTMLMediaElement::ChannelLoader final {
public:
  NS_INLINE_DECL_REFCOUNTING(ChannelLoader);

  void LoadInternal(HTMLMediaElement* aElement)
  {
    if (mCancelled) {
      return;
    }

    // determine what security checks need to be performed in AsyncOpen2().
    nsSecurityFlags securityFlags = aElement->ShouldCheckAllowOrigin()
      ? nsILoadInfo::SEC_REQUIRE_CORS_DATA_INHERITS :
        nsILoadInfo::SEC_ALLOW_CROSS_ORIGIN_DATA_INHERITS;

    if (aElement->GetCORSMode() == CORS_USE_CREDENTIALS) {
      securityFlags |= nsILoadInfo::SEC_COOKIES_INCLUDE;
    }

    MOZ_ASSERT(aElement->IsAnyOfHTMLElements(nsGkAtoms::audio, nsGkAtoms::video));
    nsContentPolicyType contentPolicyType = aElement->IsHTMLElement(nsGkAtoms::audio)
      ? nsIContentPolicy::TYPE_INTERNAL_AUDIO :
        nsIContentPolicy::TYPE_INTERNAL_VIDEO;

    nsCOMPtr<nsILoadGroup> loadGroup = aElement->GetDocumentLoadGroup();
    nsCOMPtr<nsIChannel> channel;
    nsresult rv = NS_NewChannel(getter_AddRefs(channel),
                                aElement->mLoadingSrc,
                                static_cast<Element*>(aElement),
                                securityFlags,
                                contentPolicyType,
                                loadGroup,
                                nullptr,   // aCallbacks
                                nsICachingChannel::LOAD_BYPASS_LOCAL_CACHE_IF_BUSY |
                                nsIChannel::LOAD_MEDIA_SNIFFER_OVERRIDES_CONTENT_TYPE |
                                nsIChannel::LOAD_CLASSIFY_URI |
                                nsIChannel::LOAD_CALL_CONTENT_SNIFFERS);

    if (NS_FAILED(rv)) {
      // Notify load error so the element will try next resource candidate.
      aElement->NotifyLoadError();
      return;
    }

    // The listener holds a strong reference to us.  This creates a
    // reference cycle, once we've set mChannel, which is manually broken
    // in the listener's OnStartRequest method after it is finished with
    // the element. The cycle will also be broken if we get a shutdown
    // notification before OnStartRequest fires.  Necko guarantees that
    // OnStartRequest will eventually fire if we don't shut down first.
    RefPtr<MediaLoadListener> loadListener = new MediaLoadListener(aElement);

    channel->SetNotificationCallbacks(loadListener);

    nsCOMPtr<nsIHttpChannel> hc = do_QueryInterface(channel);
    if (hc) {
      // Use a byte range request from the start of the resource.
      // This enables us to detect if the stream supports byte range
      // requests, and therefore seeking, early.
      hc->SetRequestHeader(NS_LITERAL_CSTRING("Range"),
                           NS_LITERAL_CSTRING("bytes=0-"),
                           false);
      aElement->SetRequestHeaders(hc);
    }

    rv = channel->AsyncOpen2(loadListener);
    if (NS_FAILED(rv)) {
      // Notify load error so the element will try next resource candidate.
      aElement->NotifyLoadError();
      return;
    }

    // Else the channel must be open and starting to download. If it encounters
    // a non-catastrophic failure, it will set a new task to continue loading
    // another candidate.  It's safe to set it as mChannel now.
    mChannel = channel;

    // loadListener will be unregistered either on shutdown or when
    // OnStartRequest for the channel we just opened fires.
    nsContentUtils::RegisterShutdownObserver(loadListener);
  }

  nsresult Load(HTMLMediaElement* aElement)
  {
    // Per bug 1235183 comment 8, we can't spin the event loop from stable
    // state. Defer NS_NewChannel() to a new regular runnable.
    return NS_DispatchToMainThread(NewRunnableMethod<HTMLMediaElement*>(
      this, &ChannelLoader::LoadInternal, aElement));
  }

  void Cancel()
  {
    mCancelled = true;
    if (mChannel) {
      mChannel->Cancel(NS_BINDING_ABORTED);
      mChannel = nullptr;
    }
  }

  void Done() {
    MOZ_ASSERT(mChannel);
    // Decoder successfully created, the decoder now owns the MediaResource
    // which owns the channel.
    mChannel = nullptr;
  }

  nsresult Redirect(nsIChannel* aChannel,
                    nsIChannel* aNewChannel,
                    uint32_t aFlags)
  {
    NS_ASSERTION(aChannel == mChannel, "Channels should match!");
    mChannel = aNewChannel;

    // Handle forwarding of Range header so that the intial detection
    // of seeking support (via result code 206) works across redirects.
    nsCOMPtr<nsIHttpChannel> http = do_QueryInterface(aChannel);
    NS_ENSURE_STATE(http);

    NS_NAMED_LITERAL_CSTRING(rangeHdr, "Range");

    nsAutoCString rangeVal;
    if (NS_SUCCEEDED(http->GetRequestHeader(rangeHdr, rangeVal))) {
      NS_ENSURE_STATE(!rangeVal.IsEmpty());

      http = do_QueryInterface(aNewChannel);
      NS_ENSURE_STATE(http);

      nsresult rv = http->SetRequestHeader(rangeHdr, rangeVal, false);
      NS_ENSURE_SUCCESS(rv, rv);
    }

    return NS_OK;
  }

private:
  ~ChannelLoader()
  {
    MOZ_ASSERT(!mChannel);
  }
  // Holds a reference to the first channel we open to the media resource.
  // Once the decoder is created, control over the channel passes to the
  // decoder, and we null out this reference. We must store this in case
  // we need to cancel the channel before control of it passes to the decoder.
  nsCOMPtr<nsIChannel> mChannel;

  bool mCancelled = false;
};

class HTMLMediaElement::ErrorSink
{
public:
  explicit ErrorSink(HTMLMediaElement* aOwner)
    : mOwner(aOwner)
  {
    MOZ_ASSERT(mOwner);
  }

  void SetError(uint16_t aErrorCode, const nsACString& aErrorDetails)
  {
    // Since we have multiple paths calling into DecodeError, e.g.
    // MediaKeys::Terminated and EMEH264Decoder::Error. We should take the 1st
    // one only in order not to fire multiple 'error' events.
    if (mError) {
      return;
    }

    if (!IsValidErrorCode(aErrorCode)) {
      NS_ASSERTION(false, "Undefined MediaError codes!");
      return;
    }

    mError = new MediaError(mOwner, aErrorCode, aErrorDetails);
    if (CanOwnerPlayUnsupportedTypeMedia()) {
      mOwner->ChangeNetworkState(nsIDOMHTMLMediaElement::NETWORK_NO_SOURCE);
      OpenUnsupportedMediaForOwner();
    } else {
      mOwner->DispatchAsyncEvent(NS_LITERAL_STRING("error"));
      if (mOwner->ReadyState() == HAVE_NOTHING &&
          aErrorCode == MEDIA_ERR_ABORTED) {
        // https://html.spec.whatwg.org/multipage/embedded-content.html#media-data-processing-steps-list
        // "If the media data fetching process is aborted by the user"
        mOwner->DispatchAsyncEvent(NS_LITERAL_STRING("abort"));
        mOwner->ChangeNetworkState(nsIDOMHTMLMediaElement::NETWORK_EMPTY);
        mOwner->DispatchAsyncEvent(NS_LITERAL_STRING("emptied"));
      } else if (aErrorCode == MEDIA_ERR_SRC_NOT_SUPPORTED) {
        mOwner->ChangeNetworkState(nsIDOMHTMLMediaElement::NETWORK_NO_SOURCE);
      } else {
        mOwner->ChangeNetworkState(nsIDOMHTMLMediaElement::NETWORK_IDLE);
      }
    }
  }

  void ResetError()
  {
    mError = nullptr;
  }

  void NotifyPlayStarted()
  {
    if (CanOwnerPlayUnsupportedTypeMedia()) {
      OpenUnsupportedMediaForOwner();
    }
  }

  RefPtr<MediaError> mError;

private:
  bool IsValidErrorCode(const uint16_t& aErrorCode) const
  {
    return (aErrorCode == MEDIA_ERR_DECODE  ||
            aErrorCode == MEDIA_ERR_NETWORK ||
            aErrorCode == MEDIA_ERR_ABORTED ||
            aErrorCode == MEDIA_ERR_SRC_NOT_SUPPORTED);
  }

  bool CanOwnerPlayUnsupportedTypeMedia() const
  {
#if defined(MOZ_WIDGET_ANDROID)
    // On Fennec, we will user an external app to open unsupported media types.
    if (!Preferences::GetBool("media.openUnsupportedTypeWithExternalApp")) {
      return false;
    }

    if (!mError) {
      return false;
    }

    uint16_t errorCode = mError->Code();
    if (errorCode != MEDIA_ERR_SRC_NOT_SUPPORTED) {
      return false;
    }

    // If media doesn't start playing, we don't need to open it.
    if (mOwner->Paused()) {
      return false;
    }

    return true;
#endif
    return false;
  }

  void OpenUnsupportedMediaForOwner() const
  {
    nsContentUtils::DispatchTrustedEvent(mOwner->OwnerDoc(),
                                         static_cast<nsIContent*>(mOwner),
                                         NS_LITERAL_STRING("OpenMediaWithExternalApp"),
                                         true,
                                         true);
  }

  // Media elememt's life cycle would be longer than error sink, so we use the
  // raw pointer and this class would only be referenced by media element.
  HTMLMediaElement* mOwner;
};

NS_IMPL_ADDREF_INHERITED(HTMLMediaElement, nsGenericHTMLElement)
NS_IMPL_RELEASE_INHERITED(HTMLMediaElement, nsGenericHTMLElement)

NS_IMPL_CYCLE_COLLECTION_CLASS(HTMLMediaElement)

NS_IMPL_CYCLE_COLLECTION_TRAVERSE_BEGIN_INHERITED(HTMLMediaElement, nsGenericHTMLElement)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mMediaSource)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mSrcMediaSource)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mSrcStream)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mSrcAttrStream)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mSourcePointer)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mLoadBlockedDoc)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mSourceLoadCandidate)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mAudioChannelAgent)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mErrorSink->mError)
  for (uint32_t i = 0; i < tmp->mOutputStreams.Length(); ++i) {
    NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mOutputStreams[i].mStream);
  }
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mPlayed);
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mTextTrackManager)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mAudioTrackList)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mVideoTrackList)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mMediaKeys)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mSelectedVideoStreamTrack)
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_END

NS_IMPL_CYCLE_COLLECTION_UNLINK_BEGIN_INHERITED(HTMLMediaElement, nsGenericHTMLElement)
  if (tmp->mSrcStream) {
    // Need to EndMediaStreamPlayback to clear mSrcStream and make sure everything
    // gets unhooked correctly.
    tmp->EndSrcMediaStreamPlayback();
  }
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mSrcAttrStream)
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mMediaSource)
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mSrcMediaSource)
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mSourcePointer)
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mLoadBlockedDoc)
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mSourceLoadCandidate)
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mAudioChannelAgent)
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mErrorSink->mError)
  for (uint32_t i = 0; i < tmp->mOutputStreams.Length(); ++i) {
    NS_IMPL_CYCLE_COLLECTION_UNLINK(mOutputStreams[i].mStream)
  }
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mPlayed)
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mTextTrackManager)
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mAudioTrackList)
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mVideoTrackList)
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mMediaKeys)
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mSelectedVideoStreamTrack)
NS_IMPL_CYCLE_COLLECTION_UNLINK_END

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION_INHERITED(HTMLMediaElement)
  NS_INTERFACE_MAP_ENTRY(nsIDOMHTMLMediaElement)
  NS_INTERFACE_MAP_ENTRY(nsIAudioChannelAgentCallback)
NS_INTERFACE_MAP_END_INHERITING(nsGenericHTMLElement)

// nsIDOMHTMLMediaElement
NS_IMPL_URI_ATTR(HTMLMediaElement, Src, src)
NS_IMPL_BOOL_ATTR(HTMLMediaElement, Controls, controls)
NS_IMPL_BOOL_ATTR(HTMLMediaElement, Autoplay, autoplay)
NS_IMPL_BOOL_ATTR(HTMLMediaElement, Loop, loop)
NS_IMPL_BOOL_ATTR(HTMLMediaElement, DefaultMuted, muted)
NS_IMPL_ENUM_ATTR_DEFAULT_VALUE(HTMLMediaElement, Preload, preload, nullptr)

NS_IMETHODIMP
HTMLMediaElement::GetMozAudioChannelType(nsAString& aValue)
{
  nsString defaultValue;
  AudioChannelService::GetDefaultAudioChannelString(defaultValue);

  NS_ConvertUTF16toUTF8 str(defaultValue);
  GetEnumAttr(nsGkAtoms::mozaudiochannel, str.get(), aValue);
  return NS_OK;
}

NS_IMETHODIMP
HTMLMediaElement::SetMozAudioChannelType(const nsAString& aValue)
{
  return SetAttrHelper(nsGkAtoms::mozaudiochannel, aValue);
}

NS_IMETHODIMP_(bool)
HTMLMediaElement::IsVideo()
{
  return false;
}

already_AddRefed<MediaSource>
HTMLMediaElement::GetMozMediaSourceObject() const
{
  RefPtr<MediaSource> source = mMediaSource;
  return source.forget();
}

void
HTMLMediaElement::GetMozDebugReaderData(nsAString& aString)
{
  if (mDecoder && !mSrcStream) {
    mDecoder->GetMozDebugReaderData(aString);
  }
}

void
HTMLMediaElement::MozDumpDebugInfo()
{
  if (mDecoder) {
    mDecoder->DumpDebugInfo();
  }
}

void
HTMLMediaElement::SetVisible(bool aVisible)
{
  if (!mDecoder) {
    return;
  }

  mDecoder->SetForcedHidden(!aVisible);
}

already_AddRefed<DOMMediaStream>
HTMLMediaElement::GetSrcObject() const
{
  NS_ASSERTION(!mSrcAttrStream || mSrcAttrStream->GetPlaybackStream(),
               "MediaStream should have been set up properly");
  RefPtr<DOMMediaStream> stream = mSrcAttrStream;
  return stream.forget();
}

void
HTMLMediaElement::SetSrcObject(DOMMediaStream& aValue)
{
  SetMozSrcObject(&aValue);
}

void
HTMLMediaElement::SetSrcObject(DOMMediaStream* aValue)
{
  mSrcAttrStream = aValue;
  UpdateAudioChannelPlayingState();
  DoLoad();
}

// TODO: Remove prefixed versions soon (1183495)

already_AddRefed<DOMMediaStream>
HTMLMediaElement::GetMozSrcObject() const
{
  NS_ASSERTION(!mSrcAttrStream || mSrcAttrStream->GetPlaybackStream(),
               "MediaStream should have been set up properly");
  RefPtr<DOMMediaStream> stream = mSrcAttrStream;
  return stream.forget();
}

void
HTMLMediaElement::SetMozSrcObject(DOMMediaStream& aValue)
{
  SetMozSrcObject(&aValue);
}

void
HTMLMediaElement::SetMozSrcObject(DOMMediaStream* aValue)
{
  mSrcAttrStream = aValue;
  UpdateAudioChannelPlayingState();
  DoLoad();
}

NS_IMETHODIMP HTMLMediaElement::GetMozAutoplayEnabled(bool *aAutoplayEnabled)
{
  *aAutoplayEnabled = mAutoplayEnabled;

  return NS_OK;
}

bool
HTMLMediaElement::Ended()
{
  return (mDecoder && mDecoder->IsEnded()) ||
         (mSrcStream && !mSrcStream->Active());
}

NS_IMETHODIMP HTMLMediaElement::GetEnded(bool* aEnded)
{
  *aEnded = Ended();
  return NS_OK;
}

NS_IMETHODIMP HTMLMediaElement::GetCurrentSrc(nsAString & aCurrentSrc)
{
  nsAutoCString src;
  GetCurrentSpec(src);
  aCurrentSrc = NS_ConvertUTF8toUTF16(src);
  return NS_OK;
}

NS_IMETHODIMP HTMLMediaElement::GetNetworkState(uint16_t* aNetworkState)
{
  *aNetworkState = NetworkState();
  return NS_OK;
}

nsresult
HTMLMediaElement::OnChannelRedirect(nsIChannel* aChannel,
                                    nsIChannel* aNewChannel,
                                    uint32_t aFlags)
{
  MOZ_ASSERT(mChannelLoader);
  return mChannelLoader->Redirect(aChannel, aNewChannel, aFlags);
}

void HTMLMediaElement::ShutdownDecoder()
{
  RemoveMediaElementFromURITable();
  NS_ASSERTION(mDecoder, "Must have decoder to shut down");
  mWaitingForKeyListener.DisconnectIfExists();
  mDecoder->Shutdown();
  mDecoder = nullptr;
}

void HTMLMediaElement::AbortExistingLoads()
{
  // If there is no existing decoder then we don't have anything to
  // report. This prevents reporting the initial load from an
  // empty video element as a failed EME load.
  if (mDecoder) {
    ReportEMETelemetry();
  }
  // Abort any already-running instance of the resource selection algorithm.
  mLoadWaitStatus = NOT_WAITING;

  // Set a new load ID. This will cause events which were enqueued
  // with a different load ID to silently be cancelled.
  mCurrentLoadID++;

  if (mChannelLoader) {
    mChannelLoader->Cancel();
    mChannelLoader = nullptr;
  }

  bool fireTimeUpdate = false;

  // We need to remove StreamSizeListener before VideoTracks get emptied.
  if (mMediaStreamSizeListener) {
    mSelectedVideoStreamTrack->RemoveDirectListener(mMediaStreamSizeListener);
    mMediaStreamSizeListener->Forget();
    mMediaStreamSizeListener = nullptr;
  }

  // When aborting the existing loads, empty the objects in audio track list and
  // video track list, no events (in particular, no removetrack events) are
  // fired as part of this. Ending MediaStream sends track ended notifications,
  // so we empty the track lists prior.
  AudioTracks()->EmptyTracks();
  VideoTracks()->EmptyTracks();

  if (mDecoder) {
    fireTimeUpdate = mDecoder->GetCurrentTime() != 0.0;
    ShutdownDecoder();
  }
  if (mSrcStream) {
    EndSrcMediaStreamPlayback();
  }

  RemoveMediaElementFromURITable();
  mLoadingSrc = nullptr;
  mMediaSource = nullptr;

  if (mNetworkState == nsIDOMHTMLMediaElement::NETWORK_LOADING ||
      mNetworkState == nsIDOMHTMLMediaElement::NETWORK_IDLE)
  {
    DispatchAsyncEvent(NS_LITERAL_STRING("abort"));
  }

  mErrorSink->ResetError();
  mCurrentPlayRangeStart = -1.0;
  mLoadedDataFired = false;
  mAutoplaying = true;
  mIsLoadingFromSourceChildren = false;
  mSuspendedAfterFirstFrame = false;
  mAllowSuspendAfterFirstFrame = true;
  mHaveQueuedSelectResource = false;
  mSuspendedForPreloadNone = false;
  mDownloadSuspendedByCache = false;
  mMediaInfo = MediaInfo();
  mIsEncrypted = false;
  mPendingEncryptedInitData.mInitDatas.Clear();
  mWaitingForKey = NOT_WAITING_FOR_KEY;
  mSourcePointer = nullptr;

  mTags = nullptr;

  if (mNetworkState != nsIDOMHTMLMediaElement::NETWORK_EMPTY) {
    NS_ASSERTION(!mDecoder && !mSrcStream, "How did someone setup a new stream/decoder already?");
    // ChangeNetworkState() will call UpdateAudioChannelPlayingState()
    // indirectly which depends on mPaused. So we need to update mPaused first.
    mPaused = true;
    ChangeNetworkState(nsIDOMHTMLMediaElement::NETWORK_EMPTY);
    ChangeReadyState(nsIDOMHTMLMediaElement::HAVE_NOTHING);

    //TODO: Apply the rules for text track cue rendering Bug 865407
    if (mTextTrackManager) {
      mTextTrackManager->GetTextTracks()->SetCuesInactive();
    }

    if (fireTimeUpdate) {
      // Since we destroyed the decoder above, the current playback position
      // will now be reported as 0. The playback position was non-zero when
      // we destroyed the decoder, so fire a timeupdate event so that the
      // change will be reflected in the controls.
      FireTimeUpdate(false);
    }
    DispatchAsyncEvent(NS_LITERAL_STRING("emptied"));
    UpdateAudioChannelPlayingState();
  }

  // We may have changed mPaused, mAutoplaying, and other
  // things which can affect AddRemoveSelfReference
  AddRemoveSelfReference();

  mIsRunningSelectResource = false;

  if (mTextTrackManager) {
    mTextTrackManager->NotifyReset();
  }

  mEventDeliveryPaused = false;
  mPendingEvents.Clear();
}

void HTMLMediaElement::NoSupportedMediaSourceError(const nsACString& aErrorDetails)
{
  if (mDecoder) {
    ShutdownDecoder();
  }
  mErrorSink->SetError(MEDIA_ERR_SRC_NOT_SUPPORTED, aErrorDetails);
  ChangeDelayLoadStatus(false);
  UpdateAudioChannelPlayingState();
}

typedef void (HTMLMediaElement::*SyncSectionFn)();

// Runs a "synchronous section", a function that must run once the event loop
// has reached a "stable state". See:
// http://www.whatwg.org/specs/web-apps/current-work/multipage/webappapis.html#synchronous-section
class nsSyncSection : public nsMediaEvent
{
private:
  nsCOMPtr<nsIRunnable> mRunnable;
public:
  nsSyncSection(HTMLMediaElement* aElement,
                nsIRunnable* aRunnable) :
    nsMediaEvent(aElement),
    mRunnable(aRunnable)
  {
  }

  NS_IMETHOD Run() override {
    // Silently cancel if our load has been cancelled.
    if (IsCancelled())
      return NS_OK;
    mRunnable->Run();
    return NS_OK;
  }
};

void HTMLMediaElement::RunInStableState(nsIRunnable* aRunnable)
{
  nsCOMPtr<nsIRunnable> event = new nsSyncSection(this, aRunnable);
  nsContentUtils::RunInStableState(event.forget());
}

void HTMLMediaElement::QueueLoadFromSourceTask()
{
  ChangeDelayLoadStatus(true);
  ChangeNetworkState(nsIDOMHTMLMediaElement::NETWORK_LOADING);
  RefPtr<Runnable> r = NewRunnableMethod(this, &HTMLMediaElement::LoadFromSourceChildren);
  RunInStableState(r);
}

void HTMLMediaElement::QueueSelectResourceTask()
{
  // Don't allow multiple async select resource calls to be queued.
  if (mHaveQueuedSelectResource)
    return;
  mHaveQueuedSelectResource = true;
  ChangeNetworkState(nsIDOMHTMLMediaElement::NETWORK_NO_SOURCE);
  RefPtr<Runnable> r = NewRunnableMethod(this, &HTMLMediaElement::SelectResourceWrapper);
  RunInStableState(r);
}

static bool HasSourceChildren(nsIContent* aElement)
{
  for (nsIContent* child = aElement->GetFirstChild();
       child;
       child = child->GetNextSibling()) {
    if (child->IsHTMLElement(nsGkAtoms::source))
    {
      return true;
    }
  }
  return false;
}

NS_IMETHODIMP HTMLMediaElement::Load()
{
  LOG(LogLevel::Debug,
      ("%p Load() hasSrcAttrStream=%d hasSrcAttr=%d hasSourceChildren=%d "
       "handlingInput=%d",
       this, !!mSrcAttrStream, HasAttr(kNameSpaceID_None, nsGkAtoms::src),
       HasSourceChildren(this), EventStateManager::IsHandlingUserInput()));

  if (mIsRunningLoadMethod) {
    return NS_OK;
  }

  mIsDoingExplicitLoad = true;
  DoLoad();

  return NS_OK;
}

void HTMLMediaElement::DoLoad()
{
  if (mIsRunningLoadMethod) {
    return;
  }

  // Detect if user has interacted with element so that play will not be
  // blocked when initiated by a script. This enables sites to capture user
  // intent to play by calling load() in the click handler of a "catalog
  // view" of a gallery of videos.
  if (EventStateManager::IsHandlingUserInput()) {
    mHasUserInteraction = true;
  }

  SetPlayedOrSeeked(false);
  mIsRunningLoadMethod = true;
  AbortExistingLoads();
  SetPlaybackRate(mDefaultPlaybackRate);
  QueueSelectResourceTask();
  ResetState();
  mIsRunningLoadMethod = false;
}

void HTMLMediaElement::ResetState()
{
  // There might be a pending MediaDecoder::PlaybackPositionChanged() which
  // will overwrite |mMediaInfo.mVideo.mDisplay| in UpdateMediaSize() to give
  // staled videoWidth and videoHeight. We have to call ForgetElement() here
  // such that the staled callbacks won't reach us.
  if (mVideoFrameContainer) {
    mVideoFrameContainer->ForgetElement();
    mVideoFrameContainer = nullptr;
  }
}

void HTMLMediaElement::SelectResourceWrapper()
{
  SelectResource();
  mIsRunningSelectResource = false;
  mHaveQueuedSelectResource = false;
  mIsDoingExplicitLoad = false;
}

void HTMLMediaElement::SelectResource()
{
  if (!mSrcAttrStream && !HasAttr(kNameSpaceID_None, nsGkAtoms::src) &&
      !HasSourceChildren(this)) {
    // The media element has neither a src attribute nor any source
    // element children, abort the load.
    ChangeNetworkState(nsIDOMHTMLMediaElement::NETWORK_EMPTY);
    ChangeDelayLoadStatus(false);
    return;
  }

  ChangeDelayLoadStatus(true);

  ChangeNetworkState(nsIDOMHTMLMediaElement::NETWORK_LOADING);
  DispatchAsyncEvent(NS_LITERAL_STRING("loadstart"));

  // Delay setting mIsRunningSeletResource until after UpdatePreloadAction
  // so that we don't lose our state change by bailing out of the preload
  // state update
  UpdatePreloadAction();
  mIsRunningSelectResource = true;

  // If we have a 'src' attribute, use that exclusively.
  nsAutoString src;
  if (mSrcAttrStream) {
    SetupSrcMediaStreamPlayback(mSrcAttrStream);
  } else if (GetAttr(kNameSpaceID_None, nsGkAtoms::src, src)) {
    nsCOMPtr<nsIURI> uri;
    nsresult rv = NewURIFromString(src, getter_AddRefs(uri));
    if (NS_SUCCEEDED(rv)) {
      LOG(LogLevel::Debug, ("%p Trying load from src=%s", this, NS_ConvertUTF16toUTF8(src).get()));
      NS_ASSERTION(!mIsLoadingFromSourceChildren,
        "Should think we're not loading from source children by default");

      RemoveMediaElementFromURITable();
      mLoadingSrc = uri;
      mMediaSource = mSrcMediaSource;
      UpdatePreloadAction();
      if (mPreloadAction == HTMLMediaElement::PRELOAD_NONE &&
          !IsMediaStreamURI(mLoadingSrc) && !mMediaSource) {
        // preload:none media, suspend the load here before we make any
        // network requests.
        SuspendLoad();
        return;
      }

      rv = LoadResource();
      if (NS_SUCCEEDED(rv)) {
        return;
      }
    } else {
      const char16_t* params[] = { src.get() };
      ReportLoadError("MediaLoadInvalidURI", params, ArrayLength(params));
    }
    NoSupportedMediaSourceError();
  } else {
    // Otherwise, the source elements will be used.
    mIsLoadingFromSourceChildren = true;
    LoadFromSourceChildren();
  }
}

void HTMLMediaElement::NotifyLoadError()
{
  if (!mIsLoadingFromSourceChildren) {
    LOG(LogLevel::Debug, ("NotifyLoadError(), no supported media error"));
    NoSupportedMediaSourceError();
  } else if (mSourceLoadCandidate) {
    DispatchAsyncSourceError(mSourceLoadCandidate);
    QueueLoadFromSourceTask();
  } else {
    NS_WARNING("Should know the source we were loading from!");
  }
}

void HTMLMediaElement::NotifyMediaTrackEnabled(MediaTrack* aTrack)
{
  MOZ_ASSERT(aTrack);
  if (!aTrack) {
    return;
  }
#ifdef DEBUG
  nsString id;
  aTrack->GetId(id);

  LOG(LogLevel::Debug, ("MediaElement %p %sTrack with id %s enabled",
                        this, aTrack->AsAudioTrack() ? "Audio" : "Video",
                        NS_ConvertUTF16toUTF8(id).get()));
#endif

  MOZ_ASSERT((aTrack->AsAudioTrack() && aTrack->AsAudioTrack()->Enabled()) ||
             (aTrack->AsVideoTrack() && aTrack->AsVideoTrack()->Selected()));

  if (aTrack->AsAudioTrack()) {
    SetMutedInternal(mMuted & ~MUTED_BY_AUDIO_TRACK);
  } else if (aTrack->AsVideoTrack()) {
    if (!IsVideo()) {
      MOZ_ASSERT(false);
      return;
    }
    mDisableVideo = false;
  } else {
    MOZ_ASSERT(false, "Unknown track type");
  }

  if (mSrcStream) {
    if (aTrack->AsVideoTrack()) {
      MOZ_ASSERT(!mSelectedVideoStreamTrack);
      MOZ_ASSERT(!mMediaStreamSizeListener);

      mSelectedVideoStreamTrack = aTrack->AsVideoTrack()->GetVideoStreamTrack();
      VideoFrameContainer* container = GetVideoFrameContainer();
      if (mSrcStreamIsPlaying && container) {
        mSelectedVideoStreamTrack->AddVideoOutput(container);
      }
      HTMLVideoElement* self = static_cast<HTMLVideoElement*>(this);
      if (self->VideoWidth() <= 1 && self->VideoHeight() <= 1) {
        // MediaInfo uses dummy values of 1 for width and height to
        // mark video as valid. We need a new stream size listener
        // if size is 0x0 or 1x1.
        mMediaStreamSizeListener = new StreamSizeListener(this);
        mSelectedVideoStreamTrack->AddDirectListener(mMediaStreamSizeListener);
      }
    }

    if (mReadyState == HAVE_NOTHING) {
      // No MediaStreamTracks are captured until we have metadata.
      return;
    }
    for (OutputMediaStream& ms : mOutputStreams) {
      if (aTrack->AsVideoTrack() && ms.mCapturingAudioOnly) {
        // If the output stream is for audio only we ignore video tracks.
        continue;
      }
      AddCaptureMediaTrackToOutputStream(aTrack, ms);
    }
  }
}

void HTMLMediaElement::NotifyMediaTrackDisabled(MediaTrack* aTrack)
{
  MOZ_ASSERT(aTrack);
  if (!aTrack) {
    return;
  }
#ifdef DEBUG
  nsString id;
  aTrack->GetId(id);

  LOG(LogLevel::Debug, ("MediaElement %p %sTrack with id %s disabled",
                        this, aTrack->AsAudioTrack() ? "Audio" : "Video",
                        NS_ConvertUTF16toUTF8(id).get()));
#endif

  MOZ_ASSERT((!aTrack->AsAudioTrack() || !aTrack->AsAudioTrack()->Enabled()) &&
             (!aTrack->AsVideoTrack() || !aTrack->AsVideoTrack()->Selected()));

  if (aTrack->AsAudioTrack()) {
    bool shouldMute = true;
    for (uint32_t i = 0; i < AudioTracks()->Length(); ++i) {
      if ((*AudioTracks())[i]->Enabled()) {
        shouldMute = false;
        break;
      }
    }
    if (shouldMute) {
      SetMutedInternal(mMuted | MUTED_BY_AUDIO_TRACK);
    }
  } else if (aTrack->AsVideoTrack()) {
    if (mSrcStream) {
      MOZ_ASSERT(mSelectedVideoStreamTrack);
      if (mSelectedVideoStreamTrack && mMediaStreamSizeListener) {
        mSelectedVideoStreamTrack->RemoveDirectListener(mMediaStreamSizeListener);
        mMediaStreamSizeListener->Forget();
        mMediaStreamSizeListener = nullptr;
      }
      VideoFrameContainer* container = GetVideoFrameContainer();
      if (mSrcStreamIsPlaying && container) {
        mSelectedVideoStreamTrack->RemoveVideoOutput(container);
      }
      mSelectedVideoStreamTrack = nullptr;
    }
  }

  if (mReadyState == HAVE_NOTHING) {
    // No MediaStreamTracks are captured until we have metadata, and code
    // below doesn't do anything for captured decoders.
    return;
  }

  for (OutputMediaStream& ms : mOutputStreams) {
    if (ms.mCapturingDecoder) {
      MOZ_ASSERT(!ms.mCapturingMediaStream);
      continue;
    }
    MOZ_ASSERT(ms.mCapturingMediaStream);
    for (int32_t i = ms.mTrackPorts.Length() - 1; i >= 0; --i) {
      if (ms.mTrackPorts[i].first() == aTrack->GetId()) {
        // The source of this track just ended. Force-notify that it ended.
        // If we bounce it to the MediaStreamGraph it might not be picked up,
        // for instance if the MediaInputPort was destroyed in the same
        // iteration as it was added.
        MediaStreamTrack* outputTrack = ms.mStream->FindOwnedDOMTrack(
            ms.mTrackPorts[i].second()->GetDestination(),
            ms.mTrackPorts[i].second()->GetDestinationTrackId());
        MOZ_ASSERT(outputTrack);
        if (outputTrack) {
          NS_DispatchToMainThread(
            NewRunnableMethod(outputTrack, &MediaStreamTrack::OverrideEnded));
        }

        ms.mTrackPorts[i].second()->Destroy();
        ms.mTrackPorts.RemoveElementAt(i);
        break;
      }
    }
#ifdef DEBUG
    for (auto pair : ms.mTrackPorts) {
      MOZ_ASSERT(pair.first() != aTrack->GetId(),
                 "The same MediaTrack was forwarded to the output stream more than once. This shouldn't happen.");
    }
#endif
  }
}

void HTMLMediaElement::NotifyMediaStreamTracksAvailable(DOMMediaStream* aStream)
{
  if (!mSrcStream || mSrcStream != aStream) {
    return;
  }

  LOG(LogLevel::Debug, ("MediaElement %p MediaStream tracks available", this));

  mSrcStreamTracksAvailable = true;

  bool videoHasChanged = IsVideo() && HasVideo() != !VideoTracks()->IsEmpty();

  if (videoHasChanged) {
    // We are a video element and HasVideo() changed so update the screen
    // wakelock
    NotifyOwnerDocumentActivityChanged();
  }

  mWatchManager.ManualNotify(&HTMLMediaElement::UpdateReadyStateInternal);
}

void
HTMLMediaElement::NotifyOutputTrackStopped(DOMMediaStream* aOwningStream,
                                           TrackID aDestinationTrackID)
{
  for (OutputMediaStream& ms : mOutputStreams) {
    if (!ms.mCapturingMediaStream) {
      continue;
    }

    if (ms.mStream != aOwningStream) {
      continue;
    }

    for (int32_t i = ms.mTrackPorts.Length() - 1; i >= 0; --i) {
      MediaInputPort* port = ms.mTrackPorts[i].second();
      if (port->GetDestinationTrackId() != aDestinationTrackID) {
        continue;
      }

      port->Destroy();
      ms.mTrackPorts.RemoveElementAt(i);
      return;
    }
  }

  // An output track ended but its port is already gone.
  // It was probably cleared by the removal of the source MediaTrack.
}

void HTMLMediaElement::LoadFromSourceChildren()
{
  NS_ASSERTION(mDelayingLoadEvent,
               "Should delay load event (if in document) during load");
  NS_ASSERTION(mIsLoadingFromSourceChildren,
               "Must remember we're loading from source children");

  nsIDocument* parentDoc = OwnerDoc()->GetParentDocument();
  if (parentDoc) {
    parentDoc->FlushPendingNotifications(Flush_Layout);
  }

  while (true) {
    nsIContent* child = GetNextSource();
    if (!child) {
      // Exhausted candidates, wait for more candidates to be appended to
      // the media element.
      mLoadWaitStatus = WAITING_FOR_SOURCE;
      ChangeNetworkState(nsIDOMHTMLMediaElement::NETWORK_NO_SOURCE);
      ChangeDelayLoadStatus(false);
      ReportLoadError("MediaLoadExhaustedCandidates");
      return;
    }

    // Must have src attribute.
    nsAutoString src;
    if (!child->GetAttr(kNameSpaceID_None, nsGkAtoms::src, src)) {
      ReportLoadError("MediaLoadSourceMissingSrc");
      DispatchAsyncSourceError(child);
      continue;
    }

    // If we have a type attribute, it must be a supported type.
    nsAutoString type;
    if (child->GetAttr(kNameSpaceID_None, nsGkAtoms::type, type)) {
      DecoderDoctorDiagnostics diagnostics;
      CanPlayStatus canPlay = GetCanPlay(type, &diagnostics);
      diagnostics.StoreFormatDiagnostics(
        OwnerDoc(), type, canPlay != CANPLAY_NO, __func__);
      if (canPlay == CANPLAY_NO) {
        DispatchAsyncSourceError(child);
        const char16_t* params[] = { type.get(), src.get() };
        ReportLoadError("MediaLoadUnsupportedTypeAttribute", params, ArrayLength(params));
        continue;
      }
    }
    nsAutoString media;
    HTMLSourceElement *childSrc = HTMLSourceElement::FromContent(child);
    MOZ_ASSERT(childSrc, "Expect child to be HTMLSourceElement");
    if (childSrc && !childSrc->MatchesCurrentMedia()) {
      DispatchAsyncSourceError(child);
      const char16_t* params[] = { media.get(), src.get() };
      ReportLoadError("MediaLoadSourceMediaNotMatched", params, ArrayLength(params));
      continue;
    }
    LOG(LogLevel::Debug, ("%p Trying load from <source>=%s type=%s media=%s", this,
      NS_ConvertUTF16toUTF8(src).get(), NS_ConvertUTF16toUTF8(type).get(),
      NS_ConvertUTF16toUTF8(media).get()));

    nsCOMPtr<nsIURI> uri;
    NewURIFromString(src, getter_AddRefs(uri));
    if (!uri) {
      DispatchAsyncSourceError(child);
      const char16_t* params[] = { src.get() };
      ReportLoadError("MediaLoadInvalidURI", params, ArrayLength(params));
      continue;
    }

    RemoveMediaElementFromURITable();
    mLoadingSrc = uri;
    mMediaSource = childSrc->GetSrcMediaSource();
    NS_ASSERTION(mNetworkState == nsIDOMHTMLMediaElement::NETWORK_LOADING,
                 "Network state should be loading");

    if (mPreloadAction == HTMLMediaElement::PRELOAD_NONE &&
        !IsMediaStreamURI(mLoadingSrc) && !mMediaSource) {
      // preload:none media, suspend the load here before we make any
      // network requests.
      SuspendLoad();
      return;
    }

    if (NS_SUCCEEDED(LoadResource())) {
      return;
    }

    // If we fail to load, loop back and try loading the next resource.
    DispatchAsyncSourceError(child);
  }
  NS_NOTREACHED("Execution should not reach here!");
}

void HTMLMediaElement::SuspendLoad()
{
  mSuspendedForPreloadNone = true;
  ChangeNetworkState(nsIDOMHTMLMediaElement::NETWORK_IDLE);
  ChangeDelayLoadStatus(false);
}

void HTMLMediaElement::ResumeLoad(PreloadAction aAction)
{
  NS_ASSERTION(mSuspendedForPreloadNone,
    "Must be halted for preload:none to resume from preload:none suspended load.");
  mSuspendedForPreloadNone = false;
  mPreloadAction = aAction;
  ChangeDelayLoadStatus(true);
  ChangeNetworkState(nsIDOMHTMLMediaElement::NETWORK_LOADING);
  if (!mIsLoadingFromSourceChildren) {
    // We were loading from the element's src attribute.
    if (NS_FAILED(LoadResource())) {
      NoSupportedMediaSourceError();
    }
  } else {
    // We were loading from a child <source> element. Try to resume the
    // load of that child, and if that fails, try the next child.
    if (NS_FAILED(LoadResource())) {
      LoadFromSourceChildren();
    }
  }
}

static bool IsAutoplayEnabled()
{
  return Preferences::GetBool("media.autoplay.enabled");
}

void HTMLMediaElement::UpdatePreloadAction()
{
  PreloadAction nextAction = PRELOAD_UNDEFINED;
  // If autoplay is set, or we're playing, we should always preload data,
  // as we'll need it to play.
  if ((IsAutoplayEnabled() && HasAttr(kNameSpaceID_None, nsGkAtoms::autoplay)) ||
      !mPaused)
  {
    nextAction = HTMLMediaElement::PRELOAD_ENOUGH;
  } else {
    // Find the appropriate preload action by looking at the attribute.
    const nsAttrValue* val = mAttrsAndChildren.GetAttr(nsGkAtoms::preload,
                                                       kNameSpaceID_None);
    // MSE doesn't work if preload is none, so it ignores the pref when src is
    // from MSE.
    uint32_t preloadDefault = mMediaSource ?
                              HTMLMediaElement::PRELOAD_ATTR_METADATA :
                              Preferences::GetInt("media.preload.default",
                                                  HTMLMediaElement::PRELOAD_ATTR_METADATA);
    uint32_t preloadAuto =
      Preferences::GetInt("media.preload.auto",
                          HTMLMediaElement::PRELOAD_ENOUGH);
    if (!val) {
      // Attribute is not set. Use the preload action specified by the
      // media.preload.default pref, or just preload metadata if not present.
      nextAction = static_cast<PreloadAction>(preloadDefault);
    } else if (val->Type() == nsAttrValue::eEnum) {
      PreloadAttrValue attr = static_cast<PreloadAttrValue>(val->GetEnumValue());
      if (attr == HTMLMediaElement::PRELOAD_ATTR_EMPTY ||
          attr == HTMLMediaElement::PRELOAD_ATTR_AUTO)
      {
        nextAction = static_cast<PreloadAction>(preloadAuto);
      } else if (attr == HTMLMediaElement::PRELOAD_ATTR_METADATA) {
        nextAction = HTMLMediaElement::PRELOAD_METADATA;
      } else if (attr == HTMLMediaElement::PRELOAD_ATTR_NONE) {
        nextAction = HTMLMediaElement::PRELOAD_NONE;
      }
    } else {
      // Use the suggested "missing value default" of "metadata", or the value
      // specified by the media.preload.default, if present.
      nextAction = static_cast<PreloadAction>(preloadDefault);
    }
  }

  if (nextAction == HTMLMediaElement::PRELOAD_NONE && mIsDoingExplicitLoad) {
    nextAction = HTMLMediaElement::PRELOAD_METADATA;
  }

  mPreloadAction = nextAction;

  if (nextAction == HTMLMediaElement::PRELOAD_ENOUGH) {
    if (mSuspendedForPreloadNone) {
      // Our load was previouly suspended due to the media having preload
      // value "none". The preload value has changed to preload:auto, so
      // resume the load.
      ResumeLoad(PRELOAD_ENOUGH);
    } else {
      // Preload as much of the video as we can, i.e. don't suspend after
      // the first frame.
      StopSuspendingAfterFirstFrame();
    }

  } else if (nextAction == HTMLMediaElement::PRELOAD_METADATA) {
    // Ensure that the video can be suspended after first frame.
    mAllowSuspendAfterFirstFrame = true;
    if (mSuspendedForPreloadNone) {
      // Our load was previouly suspended due to the media having preload
      // value "none". The preload value has changed to preload:metadata, so
      // resume the load. We'll pause the load again after we've read the
      // metadata.
      ResumeLoad(PRELOAD_METADATA);
    }
  }
}

nsresult HTMLMediaElement::LoadResource()
{
  NS_ASSERTION(mDelayingLoadEvent,
               "Should delay load event (if in document) during load");

  if (mChannelLoader) {
    mChannelLoader->Cancel();
    mChannelLoader = nullptr;
  }

  // Check if media is allowed for the docshell.
  nsCOMPtr<nsIDocShell> docShell = OwnerDoc()->GetDocShell();
  if (docShell && !docShell->GetAllowMedia()) {
    return NS_ERROR_FAILURE;
  }

  // Set the media element's CORS mode only when loading a resource
  mCORSMode = AttrValueToCORSMode(GetParsedAttr(nsGkAtoms::crossorigin));

  HTMLMediaElement* other = LookupMediaElementURITable(mLoadingSrc);
  if (other && other->mDecoder) {
    // Clone it.
    nsresult rv = InitializeDecoderAsClone(other->mDecoder);
    if (NS_SUCCEEDED(rv))
      return rv;
  }

  if (IsMediaStreamURI(mLoadingSrc)) {
    RefPtr<DOMMediaStream> stream;
    nsresult rv = NS_GetStreamForMediaStreamURI(mLoadingSrc, getter_AddRefs(stream));
    if (NS_FAILED(rv)) {
      nsAutoString spec;
      GetCurrentSrc(spec);
      const char16_t* params[] = { spec.get() };
      ReportLoadError("MediaLoadInvalidURI", params, ArrayLength(params));
      return rv;
    }
    SetupSrcMediaStreamPlayback(stream);
    return NS_OK;
  }

  if (mMediaSource) {
    RefPtr<MediaSourceDecoder> decoder = new MediaSourceDecoder(this);
    if (!mMediaSource->Attach(decoder)) {
      // TODO: Handle failure: run "If the media data cannot be fetched at
      // all, due to network errors, causing the user agent to give up
      // trying to fetch the resource" section of resource fetch algorithm.
      decoder->Shutdown();
      return NS_ERROR_FAILURE;
    }
    ChangeDelayLoadStatus(false);
    RefPtr<MediaResource> resource =
      MediaSourceDecoder::CreateResource(mMediaSource->GetPrincipal());
    return FinishDecoderSetup(decoder, resource, nullptr);
  }

  RefPtr<ChannelLoader> loader = new ChannelLoader;
  nsresult rv = loader->Load(this);
  if (NS_SUCCEEDED(rv)) {
    mChannelLoader = loader.forget();
  }
  return rv;
}

nsresult HTMLMediaElement::LoadWithChannel(nsIChannel* aChannel,
                                           nsIStreamListener** aListener)
{
  NS_ENSURE_ARG_POINTER(aChannel);
  NS_ENSURE_ARG_POINTER(aListener);

  *aListener = nullptr;

  // Make sure we don't reenter during synchronous abort events.
  if (mIsRunningLoadMethod)
    return NS_OK;
  mIsRunningLoadMethod = true;
  AbortExistingLoads();
  mIsRunningLoadMethod = false;

  nsresult rv = aChannel->GetOriginalURI(getter_AddRefs(mLoadingSrc));
  NS_ENSURE_SUCCESS(rv, rv);

  ChangeDelayLoadStatus(true);
  rv = InitializeDecoderForChannel(aChannel, aListener);
  if (NS_FAILED(rv)) {
    ChangeDelayLoadStatus(false);
    return rv;
  }

  SetPlaybackRate(mDefaultPlaybackRate);
  DispatchAsyncEvent(NS_LITERAL_STRING("loadstart"));

  return NS_OK;
}

NS_IMETHODIMP HTMLMediaElement::GetReadyState(uint16_t* aReadyState)
{
  *aReadyState = ReadyState();

  return NS_OK;
}

bool
HTMLMediaElement::Seeking() const
{
  return mDecoder && mDecoder->IsSeeking();
}

NS_IMETHODIMP HTMLMediaElement::GetSeeking(bool* aSeeking)
{
  *aSeeking = Seeking();
  return NS_OK;
}

double
HTMLMediaElement::CurrentTime() const
{
  if (MediaStream* stream = GetSrcMediaStream()) {
    if (mSrcStreamPausedCurrentTime >= 0) {
      return mSrcStreamPausedCurrentTime;
    }
    return stream->StreamTimeToSeconds(stream->GetCurrentTime());
  }

  if (mDefaultPlaybackStartPosition == 0.0 && mDecoder) {
    return mDecoder->GetCurrentTime();
  }

  return mDefaultPlaybackStartPosition;
}

NS_IMETHODIMP HTMLMediaElement::GetCurrentTime(double* aCurrentTime)
{
  *aCurrentTime = CurrentTime();
  return NS_OK;
}

void
HTMLMediaElement::FastSeek(double aTime, ErrorResult& aRv)
{
  LOG(LogLevel::Debug, ("Reporting telemetry VIDEO_FASTSEEK_USED"));
  Telemetry::Accumulate(Telemetry::VIDEO_FASTSEEK_USED, 1);
  RefPtr<Promise> tobeDropped = Seek(aTime, SeekTarget::PrevSyncPoint, aRv);
}

already_AddRefed<Promise>
HTMLMediaElement::SeekToNextFrame(ErrorResult& aRv)
{
  return Seek(CurrentTime(), SeekTarget::NextFrame, aRv);
}

void
HTMLMediaElement::SetCurrentTime(double aCurrentTime, ErrorResult& aRv)
{
  RefPtr<Promise> tobeDropped = Seek(aCurrentTime, SeekTarget::Accurate, aRv);
}

/**
 * Check if aValue is inside a range of aRanges, and if so sets aIsInRanges
 * to true and put the range index in aIntervalIndex. If aValue is not
 * inside a range, aIsInRanges is set to false, and aIntervalIndex
 * is set to the index of the range which ends immediately before aValue
 * (and can be -1 if aValue is before aRanges.Start(0)). Returns NS_OK
 * on success, and NS_ERROR_FAILURE on failure.
 */
static nsresult
IsInRanges(dom::TimeRanges& aRanges,
           double aValue,
           bool& aIsInRanges,
           int32_t& aIntervalIndex)
{
  aIsInRanges = false;
  uint32_t length;
  nsresult rv = aRanges.GetLength(&length);
  NS_ENSURE_SUCCESS(rv, rv);
  for (uint32_t i = 0; i < length; i++) {
    double start, end;
    rv = aRanges.Start(i, &start);
    NS_ENSURE_SUCCESS(rv, rv);
    if (start > aValue) {
      aIntervalIndex = i - 1;
      return NS_OK;
    }
    rv = aRanges.End(i, &end);
    NS_ENSURE_SUCCESS(rv, rv);
    if (aValue <= end) {
      aIntervalIndex = i;
      aIsInRanges = true;
      return NS_OK;
    }
  }
  aIntervalIndex = length - 1;
  return NS_OK;
}

already_AddRefed<Promise>
HTMLMediaElement::Seek(double aTime,
                       SeekTarget::Type aSeekType,
                       ErrorResult& aRv)
{
  // aTime should be non-NaN.
  MOZ_ASSERT(!mozilla::IsNaN(aTime));

  nsCOMPtr<nsIGlobalObject> global = do_QueryInterface(OwnerDoc()->GetInnerWindow());

  if (!global) {
    aRv.Throw(NS_ERROR_UNEXPECTED);
    return nullptr;
  }

  RefPtr<Promise> promise = Promise::Create(global, aRv);

  if (NS_WARN_IF(aRv.Failed())) {
    return nullptr;
  }

  // Detect if user has interacted with element by seeking so that
  // play will not be blocked when initiated by a script.
  if (EventStateManager::IsHandlingUserInput()) {
    mHasUserInteraction = true;
  }

  StopSuspendingAfterFirstFrame();

  if (mSrcStream) {
    // do nothing since media streams have an empty Seekable range.
    promise->MaybeReject(NS_ERROR_DOM_INVALID_STATE_ERR);
    return promise.forget();
  }

  if (mPlayed && mCurrentPlayRangeStart != -1.0) {
    double rangeEndTime = CurrentTime();
    LOG(LogLevel::Debug, ("%p Adding \'played\' a range : [%f, %f]", this, mCurrentPlayRangeStart, rangeEndTime));
    // Multiple seek without playing, or seek while playing.
    if (mCurrentPlayRangeStart != rangeEndTime) {
      mPlayed->Add(mCurrentPlayRangeStart, rangeEndTime);
    }
    // Reset the current played range start time. We'll re-set it once
    // the seek completes.
    mCurrentPlayRangeStart = -1.0;
  }

  if (mReadyState == nsIDOMHTMLMediaElement::HAVE_NOTHING) {
    mDefaultPlaybackStartPosition = aTime;
    promise->MaybeReject(NS_ERROR_DOM_INVALID_STATE_ERR);
    return promise.forget();
  }

  if (!mDecoder) {
    // mDecoder must always be set in order to reach this point.
    NS_ASSERTION(mDecoder, "SetCurrentTime failed: no decoder");
    promise->MaybeReject(NS_ERROR_DOM_INVALID_STATE_ERR);
    return promise.forget();
  }

  // Clamp the seek target to inside the seekable ranges.
  RefPtr<dom::TimeRanges> seekable = new dom::TimeRanges(ToSupports(OwnerDoc()));
  media::TimeIntervals seekableIntervals = mDecoder->GetSeekable();
  if (seekableIntervals.IsInvalid()) {
    aRv.Throw(NS_ERROR_DOM_INVALID_STATE_ERR); // This will reject the promise.
    return promise.forget();
  }
  seekableIntervals.ToTimeRanges(seekable);
  uint32_t length = 0;
  seekable->GetLength(&length);
  if (!length) {
    promise->MaybeReject(NS_ERROR_DOM_INVALID_STATE_ERR);
    return promise.forget();
  }

  // If the position we want to seek to is not in a seekable range, we seek
  // to the closest position in the seekable ranges instead. If two positions
  // are equally close, we seek to the closest position from the currentTime.
  // See seeking spec, point 7 :
  // http://www.whatwg.org/specs/web-apps/current-work/multipage/the-video-element.html#seeking
  int32_t range = 0;
  bool isInRange = false;
  if (NS_FAILED(IsInRanges(*seekable, aTime, isInRange, range))) {
    aRv.Throw(NS_ERROR_DOM_INVALID_STATE_ERR); // This will reject the promise.
    return promise.forget();
  }
  if (!isInRange) {
    if (range != -1) {
      // |range + 1| can't be negative, because the only possible negative value
      // for |range| is -1.
      if (uint32_t(range + 1) < length) {
        double leftBound, rightBound;
        if (NS_FAILED(seekable->End(range, &leftBound))) {
          aRv.Throw(NS_ERROR_DOM_INVALID_STATE_ERR);
          return promise.forget();
        }
        if (NS_FAILED(seekable->Start(range + 1, &rightBound))) {
          aRv.Throw(NS_ERROR_DOM_INVALID_STATE_ERR);
          return promise.forget();
        }
        double distanceLeft = Abs(leftBound - aTime);
        double distanceRight = Abs(rightBound - aTime);
        if (distanceLeft == distanceRight) {
          double currentTime = CurrentTime();
          distanceLeft = Abs(leftBound - currentTime);
          distanceRight = Abs(rightBound - currentTime);
        }
        aTime = (distanceLeft < distanceRight) ? leftBound : rightBound;
      } else {
        // Seek target is after the end last range in seekable data.
        // Clamp the seek target to the end of the last seekable range.
        if (NS_FAILED(seekable->End(length - 1, &aTime))) {
          aRv.Throw(NS_ERROR_DOM_INVALID_STATE_ERR);
          return promise.forget();
        }
      }
    } else {
      // aTime is before the first range in |seekable|, the closest point we can
      // seek to is the start of the first range.
      seekable->Start(0, &aTime);
    }
  }

  // TODO: The spec requires us to update the current time to reflect the
  //       actual seek target before beginning the synchronous section, but
  //       that requires changing all MediaDecoderReaders to support telling
  //       us the fastSeek target, and it's currently not possible to get
  //       this information as we don't yet control the demuxer for all
  //       MediaDecoderReaders.

  mPlayingBeforeSeek = IsPotentiallyPlaying();
  // Set the Variable if the Seekstarted while active playing
  if (mPlayingThroughTheAudioChannel) {
    mPlayingThroughTheAudioChannelBeforeSeek = true;
  }

  // The media backend is responsible for dispatching the timeupdate
  // event if it changes the playback position as a result of the seek.
  LOG(LogLevel::Debug, ("%p SetCurrentTime(%f) starting seek", this, aTime));
  nsresult rv = mDecoder->Seek(aTime, aSeekType, promise);
  if (NS_FAILED(rv)) {
    aRv.Throw(rv);
  }

  // We changed whether we're seeking so we need to AddRemoveSelfReference.
  AddRemoveSelfReference();

  return promise.forget();
}

NS_IMETHODIMP HTMLMediaElement::SetCurrentTime(double aCurrentTime)
{
  // Detect for a NaN and invalid values.
  if (mozilla::IsNaN(aCurrentTime)) {
    LOG(LogLevel::Debug, ("%p SetCurrentTime(%f) failed: bad time", this, aCurrentTime));
    return NS_ERROR_FAILURE;
  }

  ErrorResult rv;
  SetCurrentTime(aCurrentTime, rv);
  return rv.StealNSResult();
}

double
HTMLMediaElement::Duration() const
{
  if (mSrcStream) {
    return std::numeric_limits<double>::infinity();
  }

  if (mDecoder) {
    return mDecoder->GetDuration();
  }

  return std::numeric_limits<double>::quiet_NaN();
}

NS_IMETHODIMP HTMLMediaElement::GetDuration(double* aDuration)
{
  *aDuration = Duration();
  return NS_OK;
}

already_AddRefed<TimeRanges>
HTMLMediaElement::Seekable() const
{
  RefPtr<TimeRanges> ranges = new TimeRanges(ToSupports(OwnerDoc()));
  if (mDecoder) {
    mDecoder->GetSeekable().ToTimeRanges(ranges);
  }
  return ranges.forget();
}

NS_IMETHODIMP HTMLMediaElement::GetSeekable(nsIDOMTimeRanges** aSeekable)
{
  RefPtr<TimeRanges> ranges = Seekable();
  ranges.forget(aSeekable);
  return NS_OK;
}

NS_IMETHODIMP HTMLMediaElement::GetPaused(bool* aPaused)
{
  *aPaused = Paused();

  return NS_OK;
}

already_AddRefed<TimeRanges>
HTMLMediaElement::Played()
{
  RefPtr<TimeRanges> ranges = new TimeRanges(ToSupports(OwnerDoc()));

  uint32_t timeRangeCount = 0;
  if (mPlayed) {
    mPlayed->GetLength(&timeRangeCount);
  }
  for (uint32_t i = 0; i < timeRangeCount; i++) {
    double begin;
    double end;
    mPlayed->Start(i, &begin);
    mPlayed->End(i, &end);
    ranges->Add(begin, end);
  }

  if (mCurrentPlayRangeStart != -1.0) {
    double now = CurrentTime();
    if (mCurrentPlayRangeStart != now) {
      ranges->Add(mCurrentPlayRangeStart, now);
    }
  }

  ranges->Normalize();
  return ranges.forget();
}

NS_IMETHODIMP HTMLMediaElement::GetPlayed(nsIDOMTimeRanges** aPlayed)
{
  RefPtr<TimeRanges> ranges = Played();
  ranges.forget(aPlayed);
  return NS_OK;
}

void
HTMLMediaElement::Pause(ErrorResult& aRv)
{
  if (mNetworkState == nsIDOMHTMLMediaElement::NETWORK_EMPTY) {
    LOG(LogLevel::Debug, ("Loading due to Pause()"));
    DoLoad();
  } else if (mDecoder) {
    mDecoder->Pause();
  }

  bool oldPaused = mPaused;
  mPaused = true;
  mAutoplaying = false;
  // We changed mPaused and mAutoplaying which can affect AddRemoveSelfReference
  AddRemoveSelfReference();
  UpdateSrcMediaStreamPlaying();
  UpdateAudioChannelPlayingState();

  if (!oldPaused) {
    FireTimeUpdate(false);
    DispatchAsyncEvent(NS_LITERAL_STRING("pause"));
  }
}

NS_IMETHODIMP HTMLMediaElement::Pause()
{
  ErrorResult rv;
  Pause(rv);
  return rv.StealNSResult();
}

NS_IMETHODIMP HTMLMediaElement::GetVolume(double* aVolume)
{
  *aVolume = Volume();
  return NS_OK;
}

void
HTMLMediaElement::SetVolume(double aVolume, ErrorResult& aRv)
{
  if (aVolume < 0.0 || aVolume > 1.0) {
    aRv.Throw(NS_ERROR_DOM_INDEX_SIZE_ERR);
    return;
  }

  if (aVolume == mVolume)
    return;

  mVolume = aVolume;

  // Here we want just to update the volume.
  SetVolumeInternal();

  DispatchAsyncEvent(NS_LITERAL_STRING("volumechange"));
}

NS_IMETHODIMP HTMLMediaElement::SetVolume(double aVolume)
{
  ErrorResult rv;
  SetVolume(aVolume, rv);
  return rv.StealNSResult();
}

void
HTMLMediaElement::MozGetMetadata(JSContext* cx,
                                 JS::MutableHandle<JSObject*> aRetval,
                                 ErrorResult& aRv)
{
  if (mReadyState < nsIDOMHTMLMediaElement::HAVE_METADATA) {
    aRv.Throw(NS_ERROR_DOM_INVALID_STATE_ERR);
    return;
  }

  JS::Rooted<JSObject*> tags(cx, JS_NewPlainObject(cx));
  if (!tags) {
    aRv.Throw(NS_ERROR_FAILURE);
    return;
  }
  if (mTags) {
    for (auto iter = mTags->ConstIter(); !iter.Done(); iter.Next()) {
      nsString wideValue = NS_ConvertUTF8toUTF16(iter.UserData());
      JS::Rooted<JSString*> string(cx,
                                   JS_NewUCStringCopyZ(cx, wideValue.Data()));
      if (!string || !JS_DefineProperty(cx, tags, iter.Key().Data(), string,
                                        JSPROP_ENUMERATE)) {
        NS_WARNING("couldn't create metadata object!");
        aRv.Throw(NS_ERROR_FAILURE);
        return;
      }
    }
  }

  aRetval.set(tags);
}

NS_IMETHODIMP
HTMLMediaElement::MozGetMetadata(JSContext* cx, JS::MutableHandle<JS::Value> aValue)
{
  ErrorResult rv;
  JS::Rooted<JSObject*> obj(cx);
  MozGetMetadata(cx, &obj, rv);
  if (!rv.Failed()) {
    MOZ_ASSERT(obj);
    aValue.setObject(*obj);
  }

  return rv.StealNSResult();
}

NS_IMETHODIMP HTMLMediaElement::GetMuted(bool* aMuted)
{
  *aMuted = Muted();
  return NS_OK;
}

void HTMLMediaElement::SetMutedInternal(uint32_t aMuted)
{
  uint32_t oldMuted = mMuted;
  mMuted = aMuted;

  if (!!aMuted == !!oldMuted) {
    return;
  }

  SetVolumeInternal();
}

void HTMLMediaElement::SetVolumeInternal()
{
  float effectiveVolume = ComputedVolume();

  if (mDecoder) {
    mDecoder->SetVolume(effectiveVolume);
  } else if (MediaStream* stream = GetSrcMediaStream()) {
    if (mSrcStreamIsPlaying) {
      stream->SetAudioOutputVolume(this, effectiveVolume);
    }
  }

  NotifyAudioPlaybackChanged(
    AudioChannelService::AudibleChangedReasons::eVolumeChanged);
}

NS_IMETHODIMP HTMLMediaElement::SetMuted(bool aMuted)
{
  if (aMuted == Muted()) {
    return NS_OK;
  }

  if (aMuted) {
    SetMutedInternal(mMuted | MUTED_BY_CONTENT);
  } else {
    SetMutedInternal(mMuted & ~MUTED_BY_CONTENT);
  }

  DispatchAsyncEvent(NS_LITERAL_STRING("volumechange"));
  return NS_OK;
}

class HTMLMediaElement::StreamCaptureTrackSource :
  public MediaStreamTrackSource,
  public MediaStreamTrackSource::Sink
{
public:
  NS_DECL_ISUPPORTS_INHERITED
  NS_DECL_CYCLE_COLLECTION_CLASS_INHERITED(StreamCaptureTrackSource,
                                           MediaStreamTrackSource)

  StreamCaptureTrackSource(HTMLMediaElement* aElement,
                           MediaStreamTrackSource* aCapturedTrackSource,
                           DOMMediaStream* aOwningStream,
                           TrackID aDestinationTrackID)
    : MediaStreamTrackSource(aCapturedTrackSource->GetPrincipal(),
                             nsString())
    , mElement(aElement)
    , mCapturedTrackSource(aCapturedTrackSource)
    , mOwningStream(aOwningStream)
    , mDestinationTrackID(aDestinationTrackID)
  {
    MOZ_ASSERT(mElement);
    MOZ_ASSERT(mCapturedTrackSource);
    MOZ_ASSERT(mOwningStream);
    MOZ_ASSERT(IsTrackIDExplicit(mDestinationTrackID));
  }

  void Destroy() override
  {
    if (mCapturedTrackSource) {
      mCapturedTrackSource->UnregisterSink(this);
      mCapturedTrackSource = nullptr;
    }
  }

  MediaSourceEnum GetMediaSource() const override
  {
    return MediaSourceEnum::Other;
  }

  CORSMode GetCORSMode() const override
  {
    if (!mCapturedTrackSource) {
      // This could happen during shutdown.
      return CORS_NONE;
    }

    return mCapturedTrackSource->GetCORSMode();
  }

  void Stop() override
  {
    if (mElement && mElement->mSrcStream) {
      // Only notify if we're still playing the source stream. GC might have
      // cleared it before the track sources.
      mElement->NotifyOutputTrackStopped(mOwningStream, mDestinationTrackID);
    }
    mElement = nullptr;
    mOwningStream = nullptr;

    Destroy();
  }

  void PrincipalChanged() override
  {
    if (!mCapturedTrackSource) {
      // This could happen during shutdown.
      return;
    }

    mPrincipal = mCapturedTrackSource->GetPrincipal();
    MediaStreamTrackSource::PrincipalChanged();
  }

private:
  virtual ~StreamCaptureTrackSource() {}

  RefPtr<HTMLMediaElement> mElement;
  RefPtr<MediaStreamTrackSource> mCapturedTrackSource;
  RefPtr<DOMMediaStream> mOwningStream;
  TrackID mDestinationTrackID;
};

NS_IMPL_ADDREF_INHERITED(HTMLMediaElement::StreamCaptureTrackSource,
                         MediaStreamTrackSource)
NS_IMPL_RELEASE_INHERITED(HTMLMediaElement::StreamCaptureTrackSource,
                          MediaStreamTrackSource)
NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION_INHERITED(HTMLMediaElement::StreamCaptureTrackSource)
NS_INTERFACE_MAP_END_INHERITING(MediaStreamTrackSource)
NS_IMPL_CYCLE_COLLECTION_INHERITED(HTMLMediaElement::StreamCaptureTrackSource,
                                   MediaStreamTrackSource,
                                   mElement,
                                   mCapturedTrackSource,
                                   mOwningStream)

class HTMLMediaElement::DecoderCaptureTrackSource :
  public MediaStreamTrackSource,
  public DecoderPrincipalChangeObserver
{
public:
  NS_DECL_ISUPPORTS_INHERITED
  NS_DECL_CYCLE_COLLECTION_CLASS_INHERITED(DecoderCaptureTrackSource,
                                           MediaStreamTrackSource)

  explicit DecoderCaptureTrackSource(HTMLMediaElement* aElement)
    : MediaStreamTrackSource(nsCOMPtr<nsIPrincipal>(aElement->GetCurrentPrincipal()).get(),
                             nsString())
    , mElement(aElement)
  {
    MOZ_ASSERT(mElement);
    mElement->AddDecoderPrincipalChangeObserver(this);
  }

  void Destroy() override
  {
    if (mElement) {
      DebugOnly<bool> res = mElement->RemoveDecoderPrincipalChangeObserver(this);
      NS_ASSERTION(res, "Removing decoder principal changed observer failed. "
                        "Had it already been removed?");
      mElement = nullptr;
    }
  }

  MediaSourceEnum GetMediaSource() const override
  {
    return MediaSourceEnum::Other;
  }

  CORSMode GetCORSMode() const override
  {
    if (!mElement) {
      MOZ_ASSERT(false, "Should always have an element if in use");
      return CORS_NONE;
    }

    return mElement->GetCORSMode();
  }

  void Stop() override
  {
    // We don't notify the source that a track was stopped since it will keep
    // producing tracks until the element ends. The decoder also needs the
    // tracks it created to be live at the source since the decoder's clock is
    // based on MediaStreams during capture.
  }

  void NotifyDecoderPrincipalChanged() override
  {
    nsCOMPtr<nsIPrincipal> newPrincipal = mElement->GetCurrentPrincipal();
    if (nsContentUtils::CombineResourcePrincipals(&mPrincipal, newPrincipal)) {
      PrincipalChanged();
    }
  }

protected:
  virtual ~DecoderCaptureTrackSource()
  {
  }

  RefPtr<HTMLMediaElement> mElement;
};

NS_IMPL_ADDREF_INHERITED(HTMLMediaElement::DecoderCaptureTrackSource,
                         MediaStreamTrackSource)
NS_IMPL_RELEASE_INHERITED(HTMLMediaElement::DecoderCaptureTrackSource,
                          MediaStreamTrackSource)
NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION_INHERITED(HTMLMediaElement::DecoderCaptureTrackSource)
NS_INTERFACE_MAP_END_INHERITING(MediaStreamTrackSource)
NS_IMPL_CYCLE_COLLECTION_INHERITED(HTMLMediaElement::DecoderCaptureTrackSource,
                                   MediaStreamTrackSource,
                                   mElement)

class HTMLMediaElement::CaptureStreamTrackSourceGetter :
  public MediaStreamTrackSourceGetter
{
public:
  NS_DECL_ISUPPORTS_INHERITED
  NS_DECL_CYCLE_COLLECTION_CLASS_INHERITED(CaptureStreamTrackSourceGetter,
                                           MediaStreamTrackSourceGetter)

  explicit CaptureStreamTrackSourceGetter(HTMLMediaElement* aElement)
    : mElement(aElement) {}

  already_AddRefed<dom::MediaStreamTrackSource>
  GetMediaStreamTrackSource(TrackID aInputTrackID) override
  {
    if (mElement && mElement->mSrcStream) {
      NS_ERROR("Captured media element playing a stream adds tracks explicitly on main thread.");
      return nullptr;
    }

    // We can return a new source each time here, even for different streams,
    // since the sources don't keep any internal state and all of them call
    // through to the same HTMLMediaElement.
    // If this changes (after implementing Stop()?) we'll have to ensure we
    // return the same source for all requests to the same TrackID, and only
    // have one getter.
    return do_AddRef(new DecoderCaptureTrackSource(mElement));
  }

protected:
  virtual ~CaptureStreamTrackSourceGetter() {}

  RefPtr<HTMLMediaElement> mElement;
};

NS_IMPL_ADDREF_INHERITED(HTMLMediaElement::CaptureStreamTrackSourceGetter,
                         MediaStreamTrackSourceGetter)
NS_IMPL_RELEASE_INHERITED(HTMLMediaElement::CaptureStreamTrackSourceGetter,
                          MediaStreamTrackSourceGetter)
NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION_INHERITED(HTMLMediaElement::CaptureStreamTrackSourceGetter)
NS_INTERFACE_MAP_END_INHERITING(MediaStreamTrackSourceGetter)
NS_IMPL_CYCLE_COLLECTION_INHERITED(HTMLMediaElement::CaptureStreamTrackSourceGetter,
                                   MediaStreamTrackSourceGetter,
                                   mElement)

void
HTMLMediaElement::SetCapturedOutputStreamsEnabled(bool aEnabled) {
  for (OutputMediaStream& ms : mOutputStreams) {
    if (ms.mCapturingDecoder) {
      MOZ_ASSERT(!ms.mCapturingMediaStream);
      continue;
    }
    for (auto pair : ms.mTrackPorts) {
      MediaStream* outputSource = ms.mStream->GetInputStream();
      if (!outputSource) {
        NS_ERROR("No output source stream");
        return;
      }

      TrackID id = pair.second()->GetDestinationTrackId();
      outputSource->SetTrackEnabled(id, aEnabled ? DisabledTrackMode::ENABLED
                                                 : DisabledTrackMode::SILENCE_FREEZE);

      LOG(LogLevel::Debug,
          ("%s track %d for captured MediaStream %p",
           aEnabled ? "Enabled" : "Disabled", id, ms.mStream.get()));
    }
  }
}

void
HTMLMediaElement::AddCaptureMediaTrackToOutputStream(MediaTrack* aTrack,
                                                     OutputMediaStream& aOutputStream,
                                                     bool aAsyncAddtrack)
{
  if (aOutputStream.mCapturingDecoder) {
    MOZ_ASSERT(!aOutputStream.mCapturingMediaStream);
    return;
  }
  aOutputStream.mCapturingMediaStream = true;

  if (aOutputStream.mStream == mSrcStream) {
    // Cycle detected. This can happen since tracks are added async.
    // We avoid forwarding it to the output here or we'd get into an infloop.
    return;
  }

  MediaStream* outputSource = aOutputStream.mStream->GetInputStream();
  if (!outputSource) {
    NS_ERROR("No output source stream");
    return;
  }

  ProcessedMediaStream* processedOutputSource =
    outputSource->AsProcessedStream();
  if (!processedOutputSource) {
    NS_ERROR("Input stream not a ProcessedMediaStream");
    return;
  }

  if (!aTrack) {
    MOZ_ASSERT(false, "Bad MediaTrack");
    return;
  }

  MediaStreamTrack* inputTrack = mSrcStream->GetTrackById(aTrack->GetId());
  MOZ_ASSERT(inputTrack);
  if (!inputTrack) {
    NS_ERROR("Input track not found in source stream");
    return;
  }

#if DEBUG
  for (auto pair : aOutputStream.mTrackPorts) {
    MOZ_ASSERT(pair.first() != aTrack->GetId(),
               "Captured track already captured to output stream");
  }
#endif

  TrackID destinationTrackID = aOutputStream.mNextAvailableTrackID++;
  RefPtr<MediaStreamTrackSource> source =
    new StreamCaptureTrackSource(this,
                                 &inputTrack->GetSource(),
                                 aOutputStream.mStream,
                                 destinationTrackID);

  MediaSegment::Type type = inputTrack->AsAudioStreamTrack()
                          ? MediaSegment::AUDIO
                          : MediaSegment::VIDEO;

  RefPtr<MediaStreamTrack> track =
    aOutputStream.mStream->CreateDOMTrack(destinationTrackID, type, source);

  if (aAsyncAddtrack) {
    NS_DispatchToMainThread(
      NewRunnableMethod<StorensRefPtrPassByPtr<MediaStreamTrack>>(
        aOutputStream.mStream, &DOMMediaStream::AddTrackInternal, track));
  } else {
    aOutputStream.mStream->AddTrackInternal(track);
  }

  // Track is muted initially, so we don't leak data if it's added while paused
  // and an MSG iteration passes before the mute comes into effect.
  processedOutputSource->SetTrackEnabled(destinationTrackID,
                                         DisabledTrackMode::SILENCE_FREEZE);
  RefPtr<MediaInputPort> port =
    inputTrack->ForwardTrackContentsTo(processedOutputSource,
                                       destinationTrackID);

  Pair<nsString, RefPtr<MediaInputPort>> p(aTrack->GetId(), port);
  aOutputStream.mTrackPorts.AppendElement(Move(p));

  if (mSrcStreamIsPlaying) {
    processedOutputSource->SetTrackEnabled(destinationTrackID,
                                           DisabledTrackMode::ENABLED);
  }

  LOG(LogLevel::Debug,
      ("Created %s track %p with id %d from track %p through MediaInputPort %p",
       inputTrack->AsAudioStreamTrack() ? "audio" : "video",
       track.get(), destinationTrackID, inputTrack, port.get()));
}

already_AddRefed<DOMMediaStream>
HTMLMediaElement::CaptureStreamInternal(bool aFinishWhenEnded,
                                        bool aCaptureAudio,
                                        MediaStreamGraph* aGraph)
{
  MOZ_RELEASE_ASSERT(aGraph);

    MarkAsContentSource(CallerAPI::CAPTURE_STREAM);

  nsPIDOMWindowInner* window = OwnerDoc()->GetInnerWindow();
  if (!window) {
    return nullptr;
  }
  if (ContainsRestrictedContent()) {
    return nullptr;
  }

  if (!mOutputStreams.IsEmpty() &&
      aGraph != mOutputStreams[0].mStream->GetInputStream()->Graph()) {
    return nullptr;
  }

  OutputMediaStream* out = mOutputStreams.AppendElement();
  MediaStreamTrackSourceGetter* getter = new CaptureStreamTrackSourceGetter(this);
  out->mStream = DOMMediaStream::CreateTrackUnionStreamAsInput(window, aGraph, getter);
  out->mStream->SetInactiveOnFinish();
  out->mFinishWhenEnded = aFinishWhenEnded;
  out->mCapturingAudioOnly = aCaptureAudio;

  if (aCaptureAudio) {
    if (mSrcStream) {
      // We don't support applying volume and mute to the captured stream, when
      // capturing a MediaStream.
      nsContentUtils::ReportToConsole(nsIScriptError::errorFlag,
                                      NS_LITERAL_CSTRING("Media"),
                                      OwnerDoc(),
                                      nsContentUtils::eDOM_PROPERTIES,
                                      "MediaElementAudioCaptureOfMediaStreamError");
      return nullptr;
    }

    // mAudioCaptured tells the user that the audio played by this media element
    // is being routed to the captureStreams *instead* of being played to
    // speakers.
    mAudioCaptured = true;
  }

  if (mDecoder) {
    out->mCapturingDecoder = true;
    mDecoder->AddOutputStream(out->mStream->GetInputStream()->AsProcessedStream(),
                              aFinishWhenEnded);
  } else if (mSrcStream) {
    out->mCapturingMediaStream = true;
  }

  if (mReadyState == HAVE_NOTHING) {
    // Do not expose the tracks until we have metadata.
    RefPtr<DOMMediaStream> result = out->mStream;
    return result.forget();
  }

  if (mDecoder) {
    if (HasAudio()) {
      TrackID audioTrackId = mMediaInfo.mAudio.mTrackId;
      RefPtr<MediaStreamTrackSource> trackSource =
        getter->GetMediaStreamTrackSource(audioTrackId);
      RefPtr<MediaStreamTrack> track =
        out->mStream->CreateDOMTrack(audioTrackId, MediaSegment::AUDIO,
                                     trackSource);
      out->mStream->AddTrackInternal(track);
      LOG(LogLevel::Debug,
          ("Created audio track %d for captured decoder", audioTrackId));
    }
    if (IsVideo() && HasVideo() && !out->mCapturingAudioOnly) {
      TrackID videoTrackId = mMediaInfo.mVideo.mTrackId;
      RefPtr<MediaStreamTrackSource> trackSource =
        getter->GetMediaStreamTrackSource(videoTrackId);
      RefPtr<MediaStreamTrack> track =
        out->mStream->CreateDOMTrack(videoTrackId, MediaSegment::VIDEO,
                                     trackSource);
      out->mStream->AddTrackInternal(track);
      LOG(LogLevel::Debug,
          ("Created video track %d for captured decoder", videoTrackId));
    }
  }

  if (mSrcStream) {
    for (size_t i = 0; i < AudioTracks()->Length(); ++i) {
      AudioTrack* t = (*AudioTracks())[i];
      if (t->Enabled()) {
        AddCaptureMediaTrackToOutputStream(t, *out, false);
      }
    }
    if (IsVideo() && !out->mCapturingAudioOnly) {
      // Only add video tracks if we're a video element and the output stream
      // wants video.
      for (size_t i = 0; i < VideoTracks()->Length(); ++i) {
        VideoTrack* t = (*VideoTracks())[i];
        if (t->Selected()) {
          AddCaptureMediaTrackToOutputStream(t, *out, false);
        }
      }
    }
  }
  RefPtr<DOMMediaStream> result = out->mStream;
  return result.forget();
}

already_AddRefed<DOMMediaStream>
HTMLMediaElement::CaptureAudio(ErrorResult& aRv,
                               MediaStreamGraph* aGraph)
{
  MOZ_RELEASE_ASSERT(aGraph);

  RefPtr<DOMMediaStream> stream =
    CaptureStreamInternal(false, true, aGraph);
  if (!stream) {
    aRv.Throw(NS_ERROR_FAILURE);
    return nullptr;
  }

  return stream.forget();
}

already_AddRefed<DOMMediaStream>
HTMLMediaElement::MozCaptureStream(ErrorResult& aRv)
{
  MediaStreamGraph::GraphDriverType graphDriverType =
    HasAudio() ? MediaStreamGraph::AUDIO_THREAD_DRIVER
               : MediaStreamGraph::SYSTEM_THREAD_DRIVER;
  MediaStreamGraph* graph =
    MediaStreamGraph::GetInstance(graphDriverType, mAudioChannel);

  RefPtr<DOMMediaStream> stream =
    CaptureStreamInternal(false, false, graph);
  if (!stream) {
    aRv.Throw(NS_ERROR_FAILURE);
    return nullptr;
  }

  return stream.forget();
}

already_AddRefed<DOMMediaStream>
HTMLMediaElement::MozCaptureStreamUntilEnded(ErrorResult& aRv)
{
  MediaStreamGraph::GraphDriverType graphDriverType =
    HasAudio() ? MediaStreamGraph::AUDIO_THREAD_DRIVER
               : MediaStreamGraph::SYSTEM_THREAD_DRIVER;
  MediaStreamGraph* graph =
    MediaStreamGraph::GetInstance(graphDriverType, mAudioChannel);

  RefPtr<DOMMediaStream> stream =
    CaptureStreamInternal(true, false, graph);
  if (!stream) {
    aRv.Throw(NS_ERROR_FAILURE);
    return nullptr;
  }

  return stream.forget();
}

NS_IMETHODIMP HTMLMediaElement::GetMozAudioCaptured(bool* aCaptured)
{
  *aCaptured = MozAudioCaptured();
  return NS_OK;
}

class MediaElementSetForURI : public nsURIHashKey {
public:
  explicit MediaElementSetForURI(const nsIURI* aKey) : nsURIHashKey(aKey) {}
  MediaElementSetForURI(const MediaElementSetForURI& toCopy)
    : nsURIHashKey(toCopy), mElements(toCopy.mElements) {}
  nsTArray<HTMLMediaElement*> mElements;
};

typedef nsTHashtable<MediaElementSetForURI> MediaElementURITable;
// Elements in this table must have non-null mDecoder and mLoadingSrc, and those
// can't change while the element is in the table. The table is keyed by
// the element's mLoadingSrc. Each entry has a list of all elements with the
// same mLoadingSrc.
static MediaElementURITable* gElementTable;

#ifdef DEBUG
static bool
URISafeEquals(nsIURI* a1, nsIURI* a2)
{
  if (!a1 || !a2) {
    // Consider two empty URIs *not* equal!
    return false;
  }
  bool equal = false;
  nsresult rv = a1->Equals(a2, &equal);
  return NS_SUCCEEDED(rv) && equal;
}
// Returns the number of times aElement appears in the media element table
// for aURI. If this returns other than 0 or 1, there's a bug somewhere!
static unsigned
MediaElementTableCount(HTMLMediaElement* aElement, nsIURI* aURI)
{
  if (!gElementTable || !aElement) {
    return 0;
  }
  uint32_t uriCount = 0;
  uint32_t otherCount = 0;
  for (auto it = gElementTable->ConstIter(); !it.Done(); it.Next()) {
    MediaElementSetForURI* entry = it.Get();
    uint32_t count = 0;
    for (const auto& elem : entry->mElements) {
      if (elem == aElement) {
        count++;
      }
    }
    if (URISafeEquals(aURI, entry->GetKey())) {
      uriCount = count;
    } else {
      otherCount += count;
    }
  }
  NS_ASSERTION(otherCount == 0, "Should not have entries for unknown URIs");
  return uriCount;
}
#endif

void
HTMLMediaElement::AddMediaElementToURITable()
{
  NS_ASSERTION(mDecoder && mDecoder->GetResource(), "Call this only with decoder Load called");
  NS_ASSERTION(MediaElementTableCount(this, mLoadingSrc) == 0,
    "Should not have entry for element in element table before addition");
  if (!gElementTable) {
    gElementTable = new MediaElementURITable();
  }
  MediaElementSetForURI* entry = gElementTable->PutEntry(mLoadingSrc);
  entry->mElements.AppendElement(this);
  NS_ASSERTION(MediaElementTableCount(this, mLoadingSrc) == 1,
    "Should have a single entry for element in element table after addition");
}

void
HTMLMediaElement::RemoveMediaElementFromURITable()
{
  if (!mDecoder || !mLoadingSrc || !gElementTable) {
    return;
  }
  MediaElementSetForURI* entry = gElementTable->GetEntry(mLoadingSrc);
  if (!entry) {
    return;
  }
  entry->mElements.RemoveElement(this);
  if (entry->mElements.IsEmpty()) {
    gElementTable->RemoveEntry(entry);
    if (gElementTable->Count() == 0) {
      delete gElementTable;
      gElementTable = nullptr;
    }
  }
  NS_ASSERTION(MediaElementTableCount(this, mLoadingSrc) == 0,
    "After remove, should no longer have an entry in element table");
}

HTMLMediaElement*
HTMLMediaElement::LookupMediaElementURITable(nsIURI* aURI)
{
  if (!gElementTable) {
    return nullptr;
  }
  MediaElementSetForURI* entry = gElementTable->GetEntry(aURI);
  if (!entry) {
    return nullptr;
  }
  for (uint32_t i = 0; i < entry->mElements.Length(); ++i) {
    HTMLMediaElement* elem = entry->mElements[i];
    bool equal;
    // Look for elements that have the same principal and CORS mode.
    // Ditto for anything else that could cause us to send different headers.
    if (NS_SUCCEEDED(elem->NodePrincipal()->Equals(NodePrincipal(), &equal)) && equal &&
        elem->mCORSMode == mCORSMode) {
      NS_ASSERTION(elem->mDecoder && elem->mDecoder->GetResource(), "Decoder gone");
      MediaResource* resource = elem->mDecoder->GetResource();
      if (resource->CanClone()) {
        return elem;
      }
    }
  }
  return nullptr;
}

class HTMLMediaElement::ShutdownObserver : public nsIObserver {
  enum class Phase : int8_t {
    Init,
    Subscribed,
    Unsubscribed
  };
public:
  NS_DECL_ISUPPORTS

  NS_IMETHOD Observe(nsISupports*, const char* aTopic, const char16_t*) override {
    MOZ_DIAGNOSTIC_ASSERT(mPhase == Phase::Subscribed);
    MOZ_DIAGNOSTIC_ASSERT(mWeak);
    if (strcmp(aTopic, NS_XPCOM_SHUTDOWN_OBSERVER_ID) == 0) {
      mWeak->NotifyShutdownEvent();
    }
    return NS_OK;
  }
  void Subscribe(HTMLMediaElement* aPtr) {
    MOZ_DIAGNOSTIC_ASSERT(mPhase == Phase::Init);
    MOZ_DIAGNOSTIC_ASSERT(!mWeak);
    mWeak = aPtr;
    nsContentUtils::RegisterShutdownObserver(this);
    mPhase = Phase::Subscribed;
  }
  void Unsubscribe() {
    MOZ_DIAGNOSTIC_ASSERT(mPhase == Phase::Subscribed);
    MOZ_DIAGNOSTIC_ASSERT(mWeak);
    mWeak = nullptr;
    nsContentUtils::UnregisterShutdownObserver(this);
    mPhase = Phase::Unsubscribed;
  }
  void AddRefMediaElement() {
    mWeak->AddRef();
  }
  void ReleaseMediaElement() {
    mWeak->Release();
  }
private:
  virtual ~ShutdownObserver() {
    MOZ_DIAGNOSTIC_ASSERT(mPhase == Phase::Unsubscribed);
    MOZ_DIAGNOSTIC_ASSERT(!mWeak);
  }
  // Guaranteed to be valid by HTMLMediaElement.
  HTMLMediaElement* mWeak = nullptr;
  Phase mPhase = Phase::Init;
};

NS_IMPL_ISUPPORTS(HTMLMediaElement::ShutdownObserver, nsIObserver)

HTMLMediaElement::HTMLMediaElement(already_AddRefed<mozilla::dom::NodeInfo>& aNodeInfo)
  : nsGenericHTMLElement(aNodeInfo),
    mWatchManager(this, AbstractThread::MainThread()),
    mSrcStreamTracksAvailable(false),
    mSrcStreamPausedCurrentTime(-1),
    mShutdownObserver(new ShutdownObserver),
    mCurrentLoadID(0),
    mNetworkState(nsIDOMHTMLMediaElement::NETWORK_EMPTY),
    mReadyState(nsIDOMHTMLMediaElement::HAVE_NOTHING, "HTMLMediaElement::mReadyState"),
    mLoadWaitStatus(NOT_WAITING),
    mVolume(1.0),
    mPreloadAction(PRELOAD_UNDEFINED),
    mLastCurrentTime(0.0),
    mFragmentStart(-1.0),
    mFragmentEnd(-1.0),
    mDefaultPlaybackRate(1.0),
    mPlaybackRate(1.0),
    mPreservesPitch(true),
    mPlayed(new TimeRanges(ToSupports(OwnerDoc()))),
    mCurrentPlayRangeStart(-1.0),
    mBegun(false),
    mLoadedDataFired(false),
    mAutoplaying(true),
    mAutoplayEnabled(true),
    mPaused(true),
    mMuted(0),
    mAudioChannelSuspended(nsISuspendedTypes::NONE_SUSPENDED),
    mStatsShowing(false),
    mAllowCasting(false),
    mIsCasting(false),
    mAudioCaptured(false),
    mAudioCapturedByWindow(false),
    mPlayingBeforeSeek(false),
    mPlayingThroughTheAudioChannelBeforeSeek(false),
    mPausedForInactiveDocumentOrChannel(false),
    mEventDeliveryPaused(false),
    mIsRunningLoadMethod(false),
    mIsDoingExplicitLoad(false),
    mIsLoadingFromSourceChildren(false),
    mDelayingLoadEvent(false),
    mIsRunningSelectResource(false),
    mHaveQueuedSelectResource(false),
    mSuspendedAfterFirstFrame(false),
    mAllowSuspendAfterFirstFrame(true),
    mHasPlayedOrSeeked(false),
    mHasSelfReference(false),
    mShuttingDown(false),
    mSuspendedForPreloadNone(false),
    mSrcStreamIsPlaying(false),
    mMediaSecurityVerified(false),
    mCORSMode(CORS_NONE),
    mIsEncrypted(false),
    mWaitingForKey(NOT_WAITING_FOR_KEY),
    mDownloadSuspendedByCache(false, "HTMLMediaElement::mDownloadSuspendedByCache"),
    mAudioChannelVolume(1.0),
    mPlayingThroughTheAudioChannel(false),
    mDisableVideo(false),
    mHasUserInteraction(false),
    mFirstFrameLoaded(false),
    mDefaultPlaybackStartPosition(0.0),
    mIsAudioTrackAudible(false),
    mAudible(IsAudible()),
    mVisibilityState(Visibility::APPROXIMATELY_NONVISIBLE),
    mErrorSink(new ErrorSink(this))
{
  ErrorResult rv;

  double defaultVolume = Preferences::GetFloat("media.default_volume", 1.0);
  SetVolume(defaultVolume, rv);

  mAudioChannel = AudioChannelService::GetDefaultAudioChannel();

  mPaused.SetOuter(this);

  RegisterActivityObserver();
  NotifyOwnerDocumentActivityChanged();

  MOZ_ASSERT(NS_IsMainThread());
  mWatchManager.Watch(mDownloadSuspendedByCache, &HTMLMediaElement::UpdateReadyStateInternal);
  // Paradoxically, there is a self-edge whereby UpdateReadyStateInternal refuses
  // to run until mReadyState reaches at least HAVE_METADATA by some other means.
  mWatchManager.Watch(mReadyState, &HTMLMediaElement::UpdateReadyStateInternal);

  mShutdownObserver->Subscribe(this);
  MaybeCreateAudioChannelAgent();
}

HTMLMediaElement::~HTMLMediaElement()
{
  NS_ASSERTION(!mHasSelfReference,
               "How can we be destroyed if we're still holding a self reference?");

  mShutdownObserver->Unsubscribe();

  if (mVideoFrameContainer) {
    mVideoFrameContainer->ForgetElement();
  }
  UnregisterActivityObserver();
  if (mDecoder) {
    ShutdownDecoder();
  }
  if (mProgressTimer) {
    StopProgress();
  }
  if (mVideoDecodeSuspendTimer) {
    mVideoDecodeSuspendTimer->Cancel();
    mVideoDecodeSuspendTimer = nullptr;
  }
  if (mSrcStream) {
    EndSrcMediaStreamPlayback();
  }

  if (mCaptureStreamPort) {
    mCaptureStreamPort->Destroy();
    mCaptureStreamPort = nullptr;
  }

  NS_ASSERTION(MediaElementTableCount(this, mLoadingSrc) == 0,
    "Destroyed media element should no longer be in element table");

  if (mChannelLoader) {
    mChannelLoader->Cancel();
  }

  WakeLockRelease();
  mAudioChannelAgent = nullptr;
}

void HTMLMediaElement::StopSuspendingAfterFirstFrame()
{
  mAllowSuspendAfterFirstFrame = false;
  if (!mSuspendedAfterFirstFrame)
    return;
  mSuspendedAfterFirstFrame = false;
  if (mDecoder) {
    mDecoder->Resume();
  }
}

void HTMLMediaElement::SetPlayedOrSeeked(bool aValue)
{
  if (aValue == mHasPlayedOrSeeked) {
    return;
  }

  mHasPlayedOrSeeked = aValue;

  // Force a reflow so that the poster frame hides or shows immediately.
  nsIFrame* frame = GetPrimaryFrame();
  if (!frame) {
    return;
  }
  frame->PresContext()->PresShell()->FrameNeedsReflow(frame,
                                                      nsIPresShell::eTreeChange,
                                                      NS_FRAME_IS_DIRTY);
}

void
HTMLMediaElement::NotifyXPCOMShutdown()
{
  ShutdownDecoder();
}

void
HTMLMediaElement::Play(ErrorResult& aRv)
{
  if (!IsAllowedToPlay()) {
    MaybeDoLoad();
    return;
  }

  nsresult rv = PlayInternal();
  if (NS_FAILED(rv)) {
    aRv.Throw(rv);
  }

  OpenUnsupportedMediaWithExternalAppIfNeeded();
}

nsresult
HTMLMediaElement::PlayInternal()
{
  // Play was not blocked so assume user interacted with the element.
  mHasUserInteraction = true;

  StopSuspendingAfterFirstFrame();
  SetPlayedOrSeeked(true);

  MaybeDoLoad();
  if (mSuspendedForPreloadNone) {
    ResumeLoad(PRELOAD_ENOUGH);
  }

  // Even if we just did Load() or ResumeLoad(), we could already have a decoder
  // here if we managed to clone an existing decoder.
  if (mDecoder) {
    if (mDecoder->IsEnded()) {
      SetCurrentTime(0);
    }
    if (!mPausedForInactiveDocumentOrChannel) {
      nsresult rv = mDecoder->Play();
      if (NS_FAILED(rv)) {
        return rv;
      }
    }
  }

  if (mCurrentPlayRangeStart == -1.0) {
    mCurrentPlayRangeStart = CurrentTime();
  }

  bool oldPaused = mPaused;
  mPaused = false;
  mAutoplaying = false;
  SetAudioChannelSuspended(nsISuspendedTypes::NONE_SUSPENDED);

  // We changed mPaused and mAutoplaying which can affect AddRemoveSelfReference
  // and our preload status.
  AddRemoveSelfReference();
  UpdatePreloadAction();
  UpdateSrcMediaStreamPlaying();
  UpdateAudioChannelPlayingState();

  // We should check audio channel playing state before dispatching any events,
  // because we don't want to dispatch events for blocked media. For blocked
  // media, the event would be pending until media is resumed.
  // TODO: If the playback has ended, then the user agent must set
  // seek to the effective start.
  if (oldPaused) {
    DispatchAsyncEvent(NS_LITERAL_STRING("play"));
    switch (mReadyState) {
    case nsIDOMHTMLMediaElement::HAVE_NOTHING:
      DispatchAsyncEvent(NS_LITERAL_STRING("waiting"));
      break;
    case nsIDOMHTMLMediaElement::HAVE_METADATA:
    case nsIDOMHTMLMediaElement::HAVE_CURRENT_DATA:
      FireTimeUpdate(false);
      DispatchAsyncEvent(NS_LITERAL_STRING("waiting"));
      break;
    case nsIDOMHTMLMediaElement::HAVE_FUTURE_DATA:
    case nsIDOMHTMLMediaElement::HAVE_ENOUGH_DATA:
      FireTimeUpdate(false);
      DispatchAsyncEvent(NS_LITERAL_STRING("playing"));
      break;
    }
  }

  return NS_OK;
}

void
HTMLMediaElement::MaybeDoLoad()
{
  if (mNetworkState == nsIDOMHTMLMediaElement::NETWORK_EMPTY) {
    DoLoad();
  }
}

NS_IMETHODIMP HTMLMediaElement::Play()
{
  if (!IsAllowedToPlay()) {
    MaybeDoLoad();
    return NS_OK;
  }

  nsresult rv = PlayInternal();
  if (NS_FAILED(rv)) {
    return rv;
  }

  OpenUnsupportedMediaWithExternalAppIfNeeded();
  return NS_OK;
}

HTMLMediaElement::WakeLockBoolWrapper&
HTMLMediaElement::WakeLockBoolWrapper::operator=(bool val)
{
  if (mValue == val) {
    return *this;
  }

  mValue = val;
  UpdateWakeLock();
  return *this;
}

HTMLMediaElement::WakeLockBoolWrapper::~WakeLockBoolWrapper()
{
  if (mTimer) {
    mTimer->Cancel();
  }
}

void
HTMLMediaElement::WakeLockBoolWrapper::SetCanPlay(bool aCanPlay)
{
  mCanPlay = aCanPlay;
  UpdateWakeLock();
}

void
HTMLMediaElement::WakeLockBoolWrapper::UpdateWakeLock()
{
  if (!mOuter) {
    return;
  }

  bool playing = (!mValue && mCanPlay);

  if (playing) {
    if (mTimer) {
      mTimer->Cancel();
      mTimer = nullptr;
    }
    mOuter->WakeLockCreate();
  } else if (!mTimer) {
    // Don't release the wake lock immediately; instead, release it after a
    // grace period.
    int timeout = Preferences::GetInt("media.wakelock_timeout", 2000);
    mTimer = do_CreateInstance("@mozilla.org/timer;1");
    if (mTimer) {
      mTimer->InitWithFuncCallback(TimerCallback, this, timeout,
                                   nsITimer::TYPE_ONE_SHOT);
    }
  }
}

void
HTMLMediaElement::WakeLockBoolWrapper::TimerCallback(nsITimer* aTimer,
                                                     void* aClosure)
{
  WakeLockBoolWrapper* wakeLock = static_cast<WakeLockBoolWrapper*>(aClosure);
  wakeLock->mOuter->WakeLockRelease();
  wakeLock->mTimer = nullptr;
}

void
HTMLMediaElement::WakeLockCreate()
{
  if (!mWakeLock) {
    RefPtr<power::PowerManagerService> pmService =
      power::PowerManagerService::GetInstance();
    NS_ENSURE_TRUE_VOID(pmService);

    ErrorResult rv;
    mWakeLock = pmService->NewWakeLock(NS_LITERAL_STRING("cpu"),
                                       OwnerDoc()->GetInnerWindow(),
                                       rv);
  }
}

void
HTMLMediaElement::WakeLockRelease()
{
  if (mWakeLock) {
    ErrorResult rv;
    mWakeLock->Unlock(rv);
    rv.SuppressException();
    mWakeLock = nullptr;
  }
}

HTMLMediaElement::OutputMediaStream::OutputMediaStream()
  : mFinishWhenEnded(false)
  , mCapturingAudioOnly(false)
  , mCapturingDecoder(false)
  , mCapturingMediaStream(false)
  , mNextAvailableTrackID(1) {}

HTMLMediaElement::OutputMediaStream::~OutputMediaStream()
{
  for (auto pair : mTrackPorts) {
    pair.second()->Destroy();
  }
}

bool HTMLMediaElement::ParseAttribute(int32_t aNamespaceID,
                                      nsIAtom* aAttribute,
                                      const nsAString& aValue,
                                      nsAttrValue& aResult)
{
  // Mappings from 'preload' attribute strings to an enumeration.
  static const nsAttrValue::EnumTable kPreloadTable[] = {
    { "",         HTMLMediaElement::PRELOAD_ATTR_EMPTY },
    { "none",     HTMLMediaElement::PRELOAD_ATTR_NONE },
    { "metadata", HTMLMediaElement::PRELOAD_ATTR_METADATA },
    { "auto",     HTMLMediaElement::PRELOAD_ATTR_AUTO },
    { nullptr,    0 }
  };

  if (aNamespaceID == kNameSpaceID_None) {
    if (ParseImageAttribute(aAttribute, aValue, aResult)) {
      return true;
    }
    if (aAttribute == nsGkAtoms::crossorigin) {
      ParseCORSValue(aValue, aResult);
      return true;
    }
    if (aAttribute == nsGkAtoms::preload) {
      return aResult.ParseEnumValue(aValue, kPreloadTable, false);
    }

    if (aAttribute == nsGkAtoms::mozaudiochannel) {
      const nsAttrValue::EnumTable* table =
        AudioChannelService::GetAudioChannelTable();
      MOZ_ASSERT(table);

      bool parsed = aResult.ParseEnumValue(aValue, table, false, &table[0]);
      if (!parsed) {
        return false;
      }

      AudioChannel audioChannel = static_cast<AudioChannel>(aResult.GetEnumValue());

      if (audioChannel == mAudioChannel ||
          !CheckAudioChannelPermissions(aValue)) {
        return true;
      }

      // We cannot change the AudioChannel of a decoder.
      if (mDecoder) {
        return true;
      }

      mAudioChannel = audioChannel;

      if (mSrcStream) {
        RefPtr<MediaStream> stream = GetSrcMediaStream();
        if (stream) {
          stream->SetAudioChannelType(mAudioChannel);
        }
      }

      return true;
    }
  }

  return nsGenericHTMLElement::ParseAttribute(aNamespaceID, aAttribute, aValue,
                                              aResult);
}

bool HTMLMediaElement::CheckAudioChannelPermissions(const nsAString& aString)
{
  // Only normal channel doesn't need permission.
  if (aString.EqualsASCII("normal")) {
    return true;
  }

  // Maybe this audio channel is equal to the default value from the pref.
  nsString audioChannel;
  AudioChannelService::GetDefaultAudioChannelString(audioChannel);
  if (audioChannel.Equals(aString)) {
    return true;
  }

  nsCOMPtr<nsIPermissionManager> permissionManager =
    services::GetPermissionManager();
  if (!permissionManager) {
    return false;
  }

  uint32_t perm = nsIPermissionManager::UNKNOWN_ACTION;
  permissionManager->TestExactPermissionFromPrincipal(NodePrincipal(),
    nsCString(NS_LITERAL_CSTRING("audio-channel-") + NS_ConvertUTF16toUTF8(aString)).get(), &perm);
  if (perm != nsIPermissionManager::ALLOW_ACTION) {
    return false;
  }

  return true;
}

void HTMLMediaElement::DoneCreatingElement()
{
   if (HasAttr(kNameSpaceID_None, nsGkAtoms::muted)) {
     mMuted |= MUTED_BY_CONTENT;
   }
}

bool HTMLMediaElement::IsHTMLFocusable(bool aWithMouse,
                                       bool* aIsFocusable,
                                       int32_t* aTabIndex)
{
  if (nsGenericHTMLElement::IsHTMLFocusable(aWithMouse, aIsFocusable, aTabIndex)) {
    return true;
  }

  *aIsFocusable = true;
  return false;
}

int32_t HTMLMediaElement::TabIndexDefault()
{
  return 0;
}

nsresult HTMLMediaElement::SetAttr(int32_t aNameSpaceID, nsIAtom* aName,
                                   nsIAtom* aPrefix, const nsAString& aValue,
                                   bool aNotify)
{
  nsresult rv =
    nsGenericHTMLElement::SetAttr(aNameSpaceID, aName, aPrefix, aValue,
                                  aNotify);
  if (NS_FAILED(rv))
    return rv;
  if (aNameSpaceID == kNameSpaceID_None && aName == nsGkAtoms::src) {
    DoLoad();
  }
  if (aNotify && aNameSpaceID == kNameSpaceID_None) {
    if (aName == nsGkAtoms::autoplay) {
      StopSuspendingAfterFirstFrame();
      CheckAutoplayDataReady();
      // This attribute can affect AddRemoveSelfReference
      AddRemoveSelfReference();
      UpdatePreloadAction();
    } else if (aName == nsGkAtoms::preload) {
      UpdatePreloadAction();
    }
  }

  return rv;
}

nsresult HTMLMediaElement::UnsetAttr(int32_t aNameSpaceID, nsIAtom* aAttr,
                                     bool aNotify)
{
  nsresult rv = nsGenericHTMLElement::UnsetAttr(aNameSpaceID, aAttr, aNotify);
  if (NS_FAILED(rv))
    return rv;
  if (aNotify && aNameSpaceID == kNameSpaceID_None) {
    if (aAttr == nsGkAtoms::autoplay) {
      // This attribute can affect AddRemoveSelfReference
      AddRemoveSelfReference();
      UpdatePreloadAction();
    } else if (aAttr == nsGkAtoms::preload) {
      UpdatePreloadAction();
    }
  }

  return rv;
}

nsresult
HTMLMediaElement::AfterSetAttr(int32_t aNameSpaceID, nsIAtom* aName,
                                const nsAttrValue* aValue, bool aNotify)
{
  if (aNameSpaceID == kNameSpaceID_None && aName == nsGkAtoms::src) {
    mSrcMediaSource = nullptr;
    if (aValue) {
      nsString srcStr = aValue->GetStringValue();
      nsCOMPtr<nsIURI> uri;
      NewURIFromString(srcStr, getter_AddRefs(uri));
      if (uri && IsMediaSourceURI(uri)) {
        nsresult rv =
          NS_GetSourceForMediaSourceURI(uri, getter_AddRefs(mSrcMediaSource));
        if (NS_FAILED(rv)) {
          nsAutoString spec;
          GetCurrentSrc(spec);
          const char16_t* params[] = { spec.get() };
          ReportLoadError("MediaLoadInvalidURI", params, ArrayLength(params));
        }
      }
    }
  }

  return nsGenericHTMLElement::AfterSetAttr(aNameSpaceID, aName,
                                            aValue, aNotify);
}

nsresult HTMLMediaElement::BindToTree(nsIDocument* aDocument, nsIContent* aParent,
                                      nsIContent* aBindingParent,
                                      bool aCompileEventHandlers)
{
  nsresult rv = nsGenericHTMLElement::BindToTree(aDocument,
                                                 aParent,
                                                 aBindingParent,
                                                 aCompileEventHandlers);

  mUnboundFromTree = false;

  if (aDocument) {
    mAutoplayEnabled =
      IsAutoplayEnabled() && (!aDocument || !aDocument->IsStaticDocument()) &&
      !IsEditable();
    // The preload action depends on the value of the autoplay attribute.
    // It's value may have changed, so update it.
    UpdatePreloadAction();
  }

  if (mDecoder) {
    // When the MediaElement is binding to tree, the dormant status is
    // aligned to document's hidden status.
    mDecoder->NotifyOwnerActivityChanged(!IsHidden());
  }

  return rv;
}

/* static */
void HTMLMediaElement::VideoDecodeSuspendTimerCallback(nsITimer* aTimer, void* aClosure)
{
  MOZ_ASSERT(NS_IsMainThread());
  auto element = static_cast<HTMLMediaElement*>(aClosure);
  element->mVideoDecodeSuspendTime.Start();
  element->mVideoDecodeSuspendTimer = nullptr;
}

void HTMLMediaElement::HiddenVideoStart()
{
  MOZ_ASSERT(NS_IsMainThread());
  mHiddenPlayTime.Start();
  if (mVideoDecodeSuspendTimer) {
    // Already started, just keep it running.
    return;
  }
  mVideoDecodeSuspendTimer = do_CreateInstance("@mozilla.org/timer;1");
  mVideoDecodeSuspendTimer->InitWithNamedFuncCallback(
    VideoDecodeSuspendTimerCallback, this,
    MediaPrefs::MDSMSuspendBackgroundVideoDelay(), nsITimer::TYPE_ONE_SHOT,
    "HTMLMediaElement::VideoDecodeSuspendTimerCallback");
}

void HTMLMediaElement::HiddenVideoStop()
{
  MOZ_ASSERT(NS_IsMainThread());
  mHiddenPlayTime.Pause();
  mVideoDecodeSuspendTime.Pause();
  if (!mVideoDecodeSuspendTimer) {
    return;
  }
  mVideoDecodeSuspendTimer->Cancel();
  mVideoDecodeSuspendTimer = nullptr;
}

void
HTMLMediaElement::ReportEMETelemetry()
{
  // Report telemetry for EME videos when a page is unloaded.
  NS_ASSERTION(NS_IsMainThread(), "Should be on main thread.");
  if (mIsEncrypted && Preferences::GetBool("media.eme.enabled")) {
    Telemetry::Accumulate(Telemetry::VIDEO_EME_PLAY_SUCCESS, mLoadedDataFired);
    LOG(LogLevel::Debug, ("%p VIDEO_EME_PLAY_SUCCESS = %s",
                       this, mLoadedDataFired ? "true" : "false"));
  }
}

void
HTMLMediaElement::ReportTelemetry()
{
  // Report telemetry for videos when a page is unloaded. We
  // want to know data on what state the video is at when
  // the user has exited.
  enum UnloadedState {
    ENDED = 0,
    PAUSED = 1,
    STALLED = 2,
    SEEKING = 3,
    OTHER = 4
  };

  UnloadedState state = OTHER;
  if (Seeking()) {
    state = SEEKING;
  }
  else if (Ended()) {
    state = ENDED;
  }
  else if (Paused()) {
    state = PAUSED;
  }
  else {
    // For buffering we check if the current playback position is at the end
    // of a buffered range, within a margin of error. We also consider to be
    // buffering if the last frame status was buffering and the ready state is
    // HAVE_CURRENT_DATA to account for times where we are in a buffering state
    // regardless of what actual data we have buffered.
    bool stalled = false;
    RefPtr<TimeRanges> ranges = Buffered();
    const double errorMargin = 0.05;
    double t = CurrentTime();
    TimeRanges::index_type index = ranges->Find(t, errorMargin);
    ErrorResult ignore;
    stalled = index != TimeRanges::NoIndex &&
              (ranges->End(index, ignore) - t) < errorMargin;
    stalled |= mDecoder && NextFrameStatus() == MediaDecoderOwner::NEXT_FRAME_UNAVAILABLE_BUFFERING &&
               mReadyState == HTMLMediaElement::HAVE_CURRENT_DATA;
    if (stalled) {
      state = STALLED;
    }
  }

  Telemetry::Accumulate(Telemetry::VIDEO_UNLOAD_STATE, state);
  LOG(LogLevel::Debug, ("%p VIDEO_UNLOAD_STATE = %d", this, state));

  FrameStatisticsData data;

  if (HTMLVideoElement* vid = HTMLVideoElement::FromContentOrNull(this)) {
    FrameStatistics* stats = vid->GetFrameStatistics();
    if (stats) {
      data = stats->GetFrameStatisticsData();
      if (data.mParsedFrames) {
        MOZ_ASSERT(data.mDroppedFrames <= data.mParsedFrames);
        // Dropped frames <= total frames, so 'percentage' cannot be higher than
        // 100 and therefore can fit in a uint32_t (that Telemetry takes).
        uint32_t percentage = 100 * data.mDroppedFrames / data.mParsedFrames;
        LOG(LogLevel::Debug,
            ("Reporting telemetry DROPPED_FRAMES_IN_VIDEO_PLAYBACK"));
        Telemetry::Accumulate(Telemetry::VIDEO_DROPPED_FRAMES_PROPORTION,
                              percentage);
      }
    }
  }

  if (mMediaInfo.HasVideo() &&
      mMediaInfo.mVideo.mImage.height > 0) {
    // We have a valid video.
    double playTime = mPlayTime.Total();
    double hiddenPlayTime = mHiddenPlayTime.Total();
    double videoDecodeSuspendTime = mVideoDecodeSuspendTime.Total();

    Telemetry::Accumulate(Telemetry::VIDEO_PLAY_TIME_MS, SECONDS_TO_MS(playTime));
    LOG(LogLevel::Debug, ("%p VIDEO_PLAY_TIME_MS = %f", this, playTime));

    Telemetry::Accumulate(Telemetry::VIDEO_HIDDEN_PLAY_TIME_MS, SECONDS_TO_MS(hiddenPlayTime));
    LOG(LogLevel::Debug, ("%p VIDEO_HIDDEN_PLAY_TIME_MS = %f", this, hiddenPlayTime));

    if (playTime > 0.0) {
      // We have actually played something -> Report some valid-video telemetry.

      // Keyed by audio+video or video alone, and by a resolution range.
      nsCString key(mMediaInfo.HasAudio() ? "AV," : "V,");
      static const struct { int32_t mH; const char* mRes; } sResolutions[] = {
        {  240, "0<h<=240" },
        {  480, "240<h<=480" },
        {  576, "480<h<=576" },
        {  720, "576<h<=720" },
        { 1080, "720<h<=1080" },
        { 2160, "1080<h<=2160" }
      };
      const char* resolution = "h>2160";
      int32_t height = mMediaInfo.mVideo.mImage.height;
      for (const auto& res : sResolutions) {
        if (height <= res.mH) {
          resolution = res.mRes;
          break;
        }
      }
      key.AppendASCII(resolution);

      uint32_t hiddenPercentage = uint32_t(hiddenPlayTime / playTime * 100.0 + 0.5);
      Telemetry::Accumulate(Telemetry::VIDEO_HIDDEN_PLAY_TIME_PERCENTAGE,
                            key,
                            hiddenPercentage);
      // Also accumulate all percentages in an "All" key.
      Telemetry::Accumulate(Telemetry::VIDEO_HIDDEN_PLAY_TIME_PERCENTAGE,
                            NS_LITERAL_CSTRING("All"),
                            hiddenPercentage);
      LOG(LogLevel::Debug, ("%p VIDEO_HIDDEN_PLAY_TIME_PERCENTAGE = %u, keys: '%s' and 'All'",
                            this, hiddenPercentage, key.get()));

      uint32_t videoDecodeSuspendPercentage =
        uint32_t(videoDecodeSuspendTime / playTime * 100.0 + 0.5);
      Telemetry::Accumulate(Telemetry::VIDEO_INFERRED_DECODE_SUSPEND_PERCENTAGE,
                            key,
                            videoDecodeSuspendPercentage);
      Telemetry::Accumulate(Telemetry::VIDEO_INFERRED_DECODE_SUSPEND_PERCENTAGE,
                            NS_LITERAL_CSTRING("All"),
                            videoDecodeSuspendPercentage);
      LOG(LogLevel::Debug, ("%p VIDEO_INFERRED_DECODE_SUSPEND_PERCENTAGE = %u, keys: '%s' and 'All'",
                            this, videoDecodeSuspendPercentage, key.get()));

      if (data.mInterKeyframeCount != 0) {
        uint32_t average_ms =
          uint32_t(std::min<uint64_t>(double(data.mInterKeyframeSum_us)
                                      / double(data.mInterKeyframeCount)
                                      / 1000.0
                                      + 0.5,
                                      UINT32_MAX));
        Telemetry::Accumulate(Telemetry::VIDEO_INTER_KEYFRAME_AVERAGE_MS,
                              key,
                              average_ms);
        Telemetry::Accumulate(Telemetry::VIDEO_INTER_KEYFRAME_AVERAGE_MS,
                              NS_LITERAL_CSTRING("All"),
                              average_ms);
        LOG(LogLevel::Debug, ("%p VIDEO_INTER_KEYFRAME_AVERAGE_MS = %u, keys: '%s' and 'All'",
                              this, average_ms, key.get()));

        uint32_t max_ms =
          uint32_t(std::min<uint64_t>((data.mInterKeyFrameMax_us + 500) / 1000,
                                      UINT32_MAX));
        Telemetry::Accumulate(Telemetry::VIDEO_INTER_KEYFRAME_MAX_MS,
                              key,
                              max_ms);
        Telemetry::Accumulate(Telemetry::VIDEO_INTER_KEYFRAME_MAX_MS,
                              NS_LITERAL_CSTRING("All"),
                              max_ms);
        LOG(LogLevel::Debug, ("%p VIDEO_INTER_KEYFRAME_MAX_MS = %u, keys: '%s' and 'All'",
                              this, max_ms, key.get()));
      } else {
        // Here, we have played *some* of the video, but didn't get more than 1
        // keyframe. Report '0' if we have played for longer than the video-
        // decode-suspend delay (showing recovery would be difficult).
        uint32_t suspendDelay_ms = MediaPrefs::MDSMSuspendBackgroundVideoDelay();
        if (uint32_t(playTime * 1000.0) > suspendDelay_ms) {
          Telemetry::Accumulate(Telemetry::VIDEO_INTER_KEYFRAME_MAX_MS,
                                key,
                                0);
          Telemetry::Accumulate(Telemetry::VIDEO_INTER_KEYFRAME_MAX_MS,
                                NS_LITERAL_CSTRING("All"),
                                0);
          LOG(LogLevel::Debug, ("%p VIDEO_INTER_KEYFRAME_MAX_MS = 0 (only 1 keyframe), keys: '%s' and 'All'",
                                this, key.get()));
        }
      }
    }
  }
}

void HTMLMediaElement::UnbindFromTree(bool aDeep,
                                      bool aNullParent)
{
  mUnboundFromTree = true;

  nsGenericHTMLElement::UnbindFromTree(aDeep, aNullParent);

  if (mDecoder) {
    MOZ_ASSERT(IsHidden());
    mDecoder->NotifyOwnerActivityChanged(false);
  }

  RefPtr<HTMLMediaElement> self(this);
  nsCOMPtr<nsIRunnable> task = NS_NewRunnableFunction([self] () {
    if (self->mUnboundFromTree &&
        self->mNetworkState != nsIDOMHTMLMediaElement::NETWORK_EMPTY) {
      self->Pause();
    }
  });
  RunInStableState(task);
}

/* static */
CanPlayStatus
HTMLMediaElement::GetCanPlay(const nsAString& aType,
                             DecoderDoctorDiagnostics* aDiagnostics)
{
  MediaContentType contentType{aType};
  return DecoderTraits::CanHandleContentType(contentType, aDiagnostics);
}

NS_IMETHODIMP
HTMLMediaElement::CanPlayType(const nsAString& aType, nsAString& aResult)
{
  DecoderDoctorDiagnostics diagnostics;
  CanPlayStatus canPlay = GetCanPlay(aType, &diagnostics);
  diagnostics.StoreFormatDiagnostics(
    OwnerDoc(), aType, canPlay != CANPLAY_NO, __func__);
  switch (canPlay) {
  case CANPLAY_NO:
    aResult.Truncate();
    break;
  case CANPLAY_YES:
    aResult.AssignLiteral("probably");
    break;
  default:
  case CANPLAY_MAYBE:
    aResult.AssignLiteral("maybe");
    break;
  }

  LOG(LogLevel::Debug, ("%p CanPlayType(%s) = \"%s\"", this,
                     NS_ConvertUTF16toUTF8(aType).get(),
                     NS_ConvertUTF16toUTF8(aResult).get()));

  return NS_OK;
}

nsresult HTMLMediaElement::InitializeDecoderAsClone(MediaDecoder* aOriginal)
{
  NS_ASSERTION(mLoadingSrc, "mLoadingSrc must already be set");
  NS_ASSERTION(mDecoder == nullptr, "Shouldn't have a decoder");

  MediaResource* originalResource = aOriginal->GetResource();
  if (!originalResource)
    return NS_ERROR_FAILURE;
  RefPtr<MediaDecoder> decoder = aOriginal->Clone(this);
  if (!decoder)
    return NS_ERROR_FAILURE;

  LOG(LogLevel::Debug, ("%p Cloned decoder %p from %p", this, decoder.get(), aOriginal));

  RefPtr<MediaResource> resource =
    originalResource->CloneData(decoder->GetResourceCallback());

  if (!resource) {
    decoder->Shutdown();
    LOG(LogLevel::Debug, ("%p Failed to cloned stream for decoder %p", this, decoder.get()));
    return NS_ERROR_FAILURE;
  }

  return FinishDecoderSetup(decoder, resource, nullptr);
}

nsresult HTMLMediaElement::InitializeDecoderForChannel(nsIChannel* aChannel,
                                                       nsIStreamListener** aListener)
{
  NS_ASSERTION(mLoadingSrc, "mLoadingSrc must already be set");
  NS_ASSERTION(mDecoder == nullptr, "Shouldn't have a decoder");

  nsAutoCString mimeType;

  aChannel->GetContentType(mimeType);
  NS_ASSERTION(!mimeType.IsEmpty(), "We should have the Content-Type.");

  DecoderDoctorDiagnostics diagnostics;
  RefPtr<MediaDecoder> decoder =
    DecoderTraits::CreateDecoder(mimeType, this, &diagnostics);
  diagnostics.StoreFormatDiagnostics(OwnerDoc(),
                                     NS_ConvertASCIItoUTF16(mimeType),
                                     decoder != nullptr,
                                     __func__);
  if (!decoder) {
    nsAutoString src;
    GetCurrentSrc(src);
    NS_ConvertUTF8toUTF16 mimeUTF16(mimeType);
    const char16_t* params[] = { mimeUTF16.get(), src.get() };
    ReportLoadError("MediaLoadUnsupportedMimeType", params, ArrayLength(params));
    return NS_ERROR_FAILURE;
  }

  LOG(LogLevel::Debug, ("%p Created decoder %p for type %s", this, decoder.get(), mimeType.get()));

  RefPtr<MediaResource> resource =
    MediaResource::Create(decoder->GetResourceCallback(), aChannel);

  if (!resource) {
    decoder->Shutdown();
    return NS_ERROR_OUT_OF_MEMORY;
  }

  if (mChannelLoader) {
    mChannelLoader->Done();
    mChannelLoader = nullptr;
  }

  return FinishDecoderSetup(decoder, resource, aListener);
}

nsresult HTMLMediaElement::FinishDecoderSetup(MediaDecoder* aDecoder,
                                              MediaResource* aStream,
                                              nsIStreamListener** aListener)
{
  ChangeNetworkState(nsIDOMHTMLMediaElement::NETWORK_LOADING);

  // Force a same-origin check before allowing events for this media resource.
  mMediaSecurityVerified = false;

  // Set mDecoder now so if methods like GetCurrentSrc get called between
  // here and Load(), they work.
  SetDecoder(aDecoder);

  // Tell the decoder about its MediaResource now so things like principals are
  // available immediately.
  mDecoder->SetResource(aStream);
  mDecoder->SetAudioChannel(mAudioChannel);
  mDecoder->SetVolume(mMuted ? 0.0 : mVolume);
  mDecoder->SetPreservesPitch(mPreservesPitch);
  mDecoder->SetPlaybackRate(mPlaybackRate);
  if (mPreloadAction == HTMLMediaElement::PRELOAD_METADATA) {
    mDecoder->SetMinimizePrerollUntilPlaybackStarts();
  }

  // Update decoder principal before we start decoding, since it
  // can affect how we feed data to MediaStreams
  NotifyDecoderPrincipalChanged();

  nsresult rv = aDecoder->Load(aListener);
  if (NS_FAILED(rv)) {
    ShutdownDecoder();
    LOG(LogLevel::Debug, ("%p Failed to load for decoder %p", this, aDecoder));
    return rv;
  }

  for (OutputMediaStream& ms : mOutputStreams) {
    if (ms.mCapturingMediaStream) {
      MOZ_ASSERT(!ms.mCapturingDecoder);
      continue;
    }

    ms.mCapturingDecoder = true;
    aDecoder->AddOutputStream(ms.mStream->GetInputStream()->AsProcessedStream(),
                              ms.mFinishWhenEnded);
  }

  if (mMediaKeys) {
    if (mMediaKeys->GetCDMProxy()) {
      mDecoder->SetCDMProxy(mMediaKeys->GetCDMProxy());
    } else {
      // CDM must have crashed.
      ShutdownDecoder();
      return NS_ERROR_FAILURE;
    }
  }

  MediaEventSource<void>* waitingForKeyProducer = mDecoder->WaitingForKeyEvent();
  // Not every decoder will produce waitingForKey events, only add ones that can
  if (waitingForKeyProducer) {
    mWaitingForKeyListener = waitingForKeyProducer->Connect(
      AbstractThread::MainThread(), this, &HTMLMediaElement::CannotDecryptWaitingForKey);
  }

  if (mChannelLoader) {
    mChannelLoader->Done();
    mChannelLoader = nullptr;
  }

  AddMediaElementToURITable();

  // We may want to suspend the new stream now.
  // This will also do an AddRemoveSelfReference.
  NotifyOwnerDocumentActivityChanged();
  UpdateAudioChannelPlayingState();

  if (!mPaused) {
    SetPlayedOrSeeked(true);
    if (!mPausedForInactiveDocumentOrChannel) {
      rv = mDecoder->Play();
    }
  }

  if (NS_FAILED(rv)) {
    ShutdownDecoder();
  }

  NS_ASSERTION(NS_SUCCEEDED(rv) == (MediaElementTableCount(this, mLoadingSrc) == 1),
    "Media element should have single table entry if decode initialized");

  return rv;
}

class HTMLMediaElement::StreamListener : public MediaStreamListener,
                                         public WatchTarget
{
public:
  explicit StreamListener(HTMLMediaElement* aElement, const char* aName) :
    WatchTarget(aName),
    mElement(aElement),
    mHaveCurrentData(false),
    mBlocked(false),
    mFinished(false),
    mMutex(aName),
    mPendingNotifyOutput(false)
  {}
  void Forget()
  {
    mElement = nullptr;
    NotifyWatchers();
  }

  // Main thread

  MediaDecoderOwner::NextFrameStatus NextFrameStatus()
  {
    if (!mElement || !mHaveCurrentData || mFinished) {
      return MediaDecoderOwner::NEXT_FRAME_UNAVAILABLE;
    }
    return mBlocked
        ? MediaDecoderOwner::NEXT_FRAME_UNAVAILABLE_BUFFERING
        : MediaDecoderOwner::NEXT_FRAME_AVAILABLE;
  }

  void DoNotifyBlocked()
  {
    mBlocked = true;
    NotifyWatchers();
  }
  void DoNotifyUnblocked()
  {
    mBlocked = false;
    NotifyWatchers();
  }
  void DoNotifyOutput()
  {
    {
      MutexAutoLock lock(mMutex);
      mPendingNotifyOutput = false;
    }
    if (mElement && mHaveCurrentData) {
      RefPtr<HTMLMediaElement> kungFuDeathGrip = mElement;
      kungFuDeathGrip->FireTimeUpdate(true);
    }
  }
  void DoNotifyHaveCurrentData()
  {
    mHaveCurrentData = true;
    if (mElement) {
      RefPtr<HTMLMediaElement> kungFuDeathGrip = mElement;
      kungFuDeathGrip->FirstFrameLoaded();
    }
    NotifyWatchers();
    DoNotifyOutput();
  }

  // These notifications run on the media graph thread so we need to
  // dispatch events to the main thread.
  virtual void NotifyBlockingChanged(MediaStreamGraph* aGraph, Blocking aBlocked) override
  {
    nsCOMPtr<nsIRunnable> event;
    if (aBlocked == BLOCKED) {
      event = NewRunnableMethod(this, &StreamListener::DoNotifyBlocked);
    } else {
      event = NewRunnableMethod(this, &StreamListener::DoNotifyUnblocked);
    }
    aGraph->DispatchToMainThreadAfterStreamStateUpdate(event.forget());
  }
  virtual void NotifyHasCurrentData(MediaStreamGraph* aGraph) override
  {
    MutexAutoLock lock(mMutex);
    nsCOMPtr<nsIRunnable> event =
      NewRunnableMethod(this, &StreamListener::DoNotifyHaveCurrentData);
    aGraph->DispatchToMainThreadAfterStreamStateUpdate(event.forget());
  }
  virtual void NotifyOutput(MediaStreamGraph* aGraph,
                            GraphTime aCurrentTime) override
  {
    MutexAutoLock lock(mMutex);
    if (mPendingNotifyOutput)
      return;
    mPendingNotifyOutput = true;
    nsCOMPtr<nsIRunnable> event =
      NewRunnableMethod(this, &StreamListener::DoNotifyOutput);
    aGraph->DispatchToMainThreadAfterStreamStateUpdate(event.forget());
  }

private:
  // These fields may only be accessed on the main thread
  HTMLMediaElement* mElement;
  bool mHaveCurrentData;
  bool mBlocked;
  bool mFinished;

  // mMutex protects the fields below; they can be accessed on any thread
  Mutex mMutex;
  bool mPendingNotifyOutput;
};

class HTMLMediaElement::MediaStreamTracksAvailableCallback:
  public OnTracksAvailableCallback
{
public:
  explicit MediaStreamTracksAvailableCallback(HTMLMediaElement* aElement):
      OnTracksAvailableCallback(), mElement(aElement)
    {}
  virtual void NotifyTracksAvailable(DOMMediaStream* aStream)
  {
    NS_ASSERTION(NS_IsMainThread(), "Should be on main thread.");

    mElement->NotifyMediaStreamTracksAvailable(aStream);
  }

private:
  HTMLMediaElement* mElement;
};

class HTMLMediaElement::MediaStreamTrackListener :
  public DOMMediaStream::TrackListener
{
public:
  explicit MediaStreamTrackListener(HTMLMediaElement* aElement):
      mElement(aElement) {}

  void NotifyTrackAdded(const RefPtr<MediaStreamTrack>& aTrack) override
  {
    mElement->NotifyMediaStreamTrackAdded(aTrack);
  }

  void NotifyTrackRemoved(const RefPtr<MediaStreamTrack>& aTrack) override
  {
    mElement->NotifyMediaStreamTrackRemoved(aTrack);
  }

  void NotifyActive() override
  {
    LOG(LogLevel::Debug, ("%p, mSrcStream %p became active",
                          mElement, mElement->mSrcStream.get()));
    mElement->CheckAutoplayDataReady();
  }

  void NotifyInactive() override
  {
    LOG(LogLevel::Debug, ("%p, mSrcStream %p became inactive",
                          mElement, mElement->mSrcStream.get()));
    MOZ_ASSERT(!mElement->mSrcStream->Active());
    if (mElement->mMediaStreamListener) {
      mElement->mMediaStreamListener->Forget();
    }
    mElement->PlaybackEnded();
  }

protected:
  HTMLMediaElement* const mElement;
};

void HTMLMediaElement::UpdateSrcMediaStreamPlaying(uint32_t aFlags)
{
  if (!mSrcStream) {
    return;
  }
  // We might be in cycle collection with mSrcStream->GetPlaybackStream() already
  // returning null due to unlinking.

  MediaStream* stream = GetSrcMediaStream();
  bool shouldPlay = !(aFlags & REMOVING_SRC_STREAM) && !mPaused &&
      !mPausedForInactiveDocumentOrChannel && stream;
  if (shouldPlay == mSrcStreamIsPlaying) {
    return;
  }
  mSrcStreamIsPlaying = shouldPlay;

  LOG(LogLevel::Debug, ("MediaElement %p %s playback of DOMMediaStream %p",
                        this, shouldPlay ? "Setting up" : "Removing",
                        mSrcStream.get()));

  if (shouldPlay) {
    mSrcStreamPausedCurrentTime = -1;

    mMediaStreamListener = new StreamListener(this,
        "HTMLMediaElement::mMediaStreamListener");
    stream->AddListener(mMediaStreamListener);

    mWatchManager.Watch(*mMediaStreamListener,
        &HTMLMediaElement::UpdateReadyStateInternal);

    stream->AddAudioOutput(this);
    SetVolumeInternal();

    VideoFrameContainer* container = GetVideoFrameContainer();
    if (mSelectedVideoStreamTrack && container) {
      mSelectedVideoStreamTrack->AddVideoOutput(container);
    }

    SetCapturedOutputStreamsEnabled(true); // Unmute
  } else {
    if (stream) {
      mSrcStreamPausedCurrentTime = CurrentTime();

      stream->RemoveListener(mMediaStreamListener);

      stream->RemoveAudioOutput(this);
      VideoFrameContainer* container = GetVideoFrameContainer();
      if (mSelectedVideoStreamTrack && container) {
        mSelectedVideoStreamTrack->RemoveVideoOutput(container);
      }

      SetCapturedOutputStreamsEnabled(false); // Mute
    }
    // If stream is null, then DOMMediaStream::Destroy must have been
    // called and that will remove all listeners/outputs.

    mWatchManager.Unwatch(*mMediaStreamListener,
        &HTMLMediaElement::UpdateReadyStateInternal);

    mMediaStreamListener->Forget();
    mMediaStreamListener = nullptr;
  }

  // If the input is a media stream, we don't check its data and always regard
  // it as audible when it's playing.
  SetAudibleState(shouldPlay);
}

void HTMLMediaElement::SetupSrcMediaStreamPlayback(DOMMediaStream* aStream)
{
  NS_ASSERTION(!mSrcStream && !mMediaStreamListener && !mMediaStreamSizeListener,
               "Should have been ended already");

  mSrcStream = aStream;

  nsPIDOMWindowInner* window = OwnerDoc()->GetInnerWindow();
  if (!window) {
    return;
  }

  RefPtr<MediaStream> stream = GetSrcMediaStream();
  if (stream) {
    stream->SetAudioChannelType(mAudioChannel);
  }

  UpdateSrcMediaStreamPlaying();

  // If we pause this media element, track changes in the underlying stream
  // will continue to fire events at this element and alter its track list.
  // That's simpler than delaying the events, but probably confusing...
  nsTArray<RefPtr<MediaStreamTrack>> tracks;
  mSrcStream->GetTracks(tracks);
  for (const RefPtr<MediaStreamTrack>& track : tracks) {
    NotifyMediaStreamTrackAdded(track);
  }

  mSrcStream->OnTracksAvailable(new MediaStreamTracksAvailableCallback(this));
  mMediaStreamTrackListener = new MediaStreamTrackListener(this);
  mSrcStream->RegisterTrackListener(mMediaStreamTrackListener);

  mSrcStream->AddPrincipalChangeObserver(this);
  mSrcStreamVideoPrincipal = mSrcStream->GetVideoPrincipal();

  ChangeNetworkState(nsIDOMHTMLMediaElement::NETWORK_IDLE);
  ChangeDelayLoadStatus(false);
  CheckAutoplayDataReady();

  // FirstFrameLoaded() will be called when the stream has current data.
}

void HTMLMediaElement::EndSrcMediaStreamPlayback()
{
  MOZ_ASSERT(mSrcStream);

  UpdateSrcMediaStreamPlaying(REMOVING_SRC_STREAM);

  if (mMediaStreamSizeListener) {
    MOZ_ASSERT(mSelectedVideoStreamTrack);
    if (mSelectedVideoStreamTrack) {
      mSelectedVideoStreamTrack->RemoveDirectListener(mMediaStreamSizeListener);
    }
    mMediaStreamSizeListener->Forget();
  }
  mSelectedVideoStreamTrack = nullptr;
  mMediaStreamSizeListener = nullptr;

  mSrcStream->UnregisterTrackListener(mMediaStreamTrackListener);
  mMediaStreamTrackListener = nullptr;
  mSrcStreamTracksAvailable = false;

  mSrcStream->RemovePrincipalChangeObserver(this);
  mSrcStreamVideoPrincipal = nullptr;

  for (OutputMediaStream& ms : mOutputStreams) {
    for (auto pair : ms.mTrackPorts) {
      pair.second()->Destroy();
    }
    ms.mTrackPorts.Clear();
  }

  mSrcStream = nullptr;
}

static already_AddRefed<AudioTrack>
CreateAudioTrack(AudioStreamTrack* aStreamTrack)
{
  nsAutoString id;
  nsAutoString label;
  aStreamTrack->GetId(id);
  aStreamTrack->GetLabel(label);

  return MediaTrackList::CreateAudioTrack(id, NS_LITERAL_STRING("main"),
                                          label, EmptyString(), true);
}

static already_AddRefed<VideoTrack>
CreateVideoTrack(VideoStreamTrack* aStreamTrack)
{
  nsAutoString id;
  nsAutoString label;
  aStreamTrack->GetId(id);
  aStreamTrack->GetLabel(label);

  return MediaTrackList::CreateVideoTrack(id, NS_LITERAL_STRING("main"),
                                          label, EmptyString(),
                                          aStreamTrack);
}

void
HTMLMediaElement::NotifyMediaStreamTrackAdded(const RefPtr<MediaStreamTrack>& aTrack)
{
  MOZ_ASSERT(aTrack);

  if (aTrack->Ended()) {
    return;
  }

#ifdef DEBUG
  nsString id;
  aTrack->GetId(id);

  LOG(LogLevel::Debug, ("%p, Adding %sTrack with id %s",
                        this, aTrack->AsAudioStreamTrack() ? "Audio" : "Video",
                        NS_ConvertUTF16toUTF8(id).get()));
#endif

  if (AudioStreamTrack* t = aTrack->AsAudioStreamTrack()) {
    RefPtr<AudioTrack> audioTrack = CreateAudioTrack(t);
    AudioTracks()->AddTrack(audioTrack);
  } else if (VideoStreamTrack* t = aTrack->AsVideoStreamTrack()) {
    // TODO: Fix this per the spec on bug 1273443.
    if (!IsVideo()) {
      return;
    }
    RefPtr<VideoTrack> videoTrack = CreateVideoTrack(t);
    VideoTracks()->AddTrack(videoTrack);
    // New MediaStreamTrack added, set the new added video track as selected
    // video track when there is no selected track.
    if (VideoTracks()->SelectedIndex() == -1) {
      MOZ_ASSERT(!mSelectedVideoStreamTrack);
      videoTrack->SetEnabledInternal(true, MediaTrack::FIRE_NO_EVENTS);
    }
  }

  mWatchManager.ManualNotify(&HTMLMediaElement::UpdateReadyStateInternal);
}

void
HTMLMediaElement::NotifyMediaStreamTrackRemoved(const RefPtr<MediaStreamTrack>& aTrack)
{
  MOZ_ASSERT(aTrack);

  nsAutoString id;
  aTrack->GetId(id);

  LOG(LogLevel::Debug, ("%p, Removing %sTrack with id %s",
                        this, aTrack->AsAudioStreamTrack() ? "Audio" : "Video",
                        NS_ConvertUTF16toUTF8(id).get()));

  if (MediaTrack* t = AudioTracks()->GetTrackById(id)) {
    AudioTracks()->RemoveTrack(t);
  } else if (MediaTrack* t = VideoTracks()->GetTrackById(id)) {
    VideoTracks()->RemoveTrack(t);
  } else {
    NS_ASSERTION(aTrack->AsVideoStreamTrack() && !IsVideo(),
                 "MediaStreamTrack ended but did not exist in track lists. "
                 "This is only allowed if a video element ends and we are an "
                 "audio element.");
    return;
  }
}


void HTMLMediaElement::ProcessMediaFragmentURI()
{
  nsMediaFragmentURIParser parser(mLoadingSrc);

  if (mDecoder && parser.HasEndTime()) {
    mFragmentEnd = parser.GetEndTime();
  }

  if (parser.HasStartTime()) {
    SetCurrentTime(parser.GetStartTime());
    mFragmentStart = parser.GetStartTime();
  }
}

void HTMLMediaElement::MetadataLoaded(const MediaInfo* aInfo,
                                      nsAutoPtr<const MetadataTags> aTags)
{
  MOZ_ASSERT(NS_IsMainThread());

  // If the element is gaining or losing an audio track, we need to notify
  // the audio channel agent so that the correct audio-playback events will
  // get dispatched.
  AutoNotifyAudioChannelAgent autoNotify(this);

  SetMediaInfo(*aInfo);

  mIsEncrypted = aInfo->IsEncrypted() || mPendingEncryptedInitData.IsEncrypted();
  mTags = aTags.forget();
  mLoadedDataFired = false;
  ChangeReadyState(nsIDOMHTMLMediaElement::HAVE_METADATA);

  DispatchAsyncEvent(NS_LITERAL_STRING("durationchange"));
  if (IsVideo() && HasVideo()) {
    DispatchAsyncEvent(NS_LITERAL_STRING("resize"));
  }
  NS_ASSERTION(!HasVideo() ||
               (mMediaInfo.mVideo.mDisplay.width > 0 &&
                mMediaInfo.mVideo.mDisplay.height > 0),
               "Video resolution must be known on 'loadedmetadata'");
  DispatchAsyncEvent(NS_LITERAL_STRING("loadedmetadata"));
  if (mDecoder && mDecoder->IsTransportSeekable() && mDecoder->IsMediaSeekable()) {
    ProcessMediaFragmentURI();
    mDecoder->SetFragmentEndTime(mFragmentEnd);
  }
  if (mIsEncrypted) {
    // We only support playback of encrypted content via MSE by default.
    if (!mMediaSource && Preferences::GetBool("media.eme.mse-only", true)) {
      DecodeError(MediaResult(NS_ERROR_DOM_MEDIA_FATAL_ERR,
                              "Encrypted content not supported outside of MSE"));
      return;
    }

    // Dispatch a distinct 'encrypted' event for each initData we have.
    for (const auto& initData : mPendingEncryptedInitData.mInitDatas) {
      DispatchEncrypted(initData.mInitData, initData.mType);
    }
    mPendingEncryptedInitData.mInitDatas.Clear();
  }

  mWatchManager.ManualNotify(&HTMLMediaElement::UpdateReadyStateInternal);

  if (IsVideo() && aInfo->HasVideo()) {
    // We are a video element playing video so update the screen wakelock
    NotifyOwnerDocumentActivityChanged();
  }

  if (mDefaultPlaybackStartPosition != 0.0) {
    SetCurrentTime(mDefaultPlaybackStartPosition);
    mDefaultPlaybackStartPosition = 0.0;
  }

  if (!mSrcStream) {
    return;
  }
  for (OutputMediaStream& ms : mOutputStreams) {
    for (size_t i = 0; i < AudioTracks()->Length(); ++i) {
      AudioTrack* t = (*AudioTracks())[i];
      if (t->Enabled()) {
        AddCaptureMediaTrackToOutputStream(t, ms);
      }
    }
    if (IsVideo() && !ms.mCapturingAudioOnly) {
      // Only add video tracks if we're a video element and the output stream
      // wants video.
      for (size_t i = 0; i < VideoTracks()->Length(); ++i) {
        VideoTrack* t = (*VideoTracks())[i];
        if (t->Selected()) {
          AddCaptureMediaTrackToOutputStream(t, ms);
        }
      }
    }
  }
}

void HTMLMediaElement::FirstFrameLoaded()
{
  LOG(LogLevel::Debug, ("%p, FirstFrameLoaded() mFirstFrameLoaded=%d mWaitingForKey=%d",
      this, mFirstFrameLoaded, mWaitingForKey));

  NS_ASSERTION(!mSuspendedAfterFirstFrame, "Should not have already suspended");

  if (!mFirstFrameLoaded) {
    mFirstFrameLoaded = true;
    UpdateReadyStateInternal();
  }

  ChangeDelayLoadStatus(false);

  if (mDecoder && mAllowSuspendAfterFirstFrame && mPaused &&
      !HasAttr(kNameSpaceID_None, nsGkAtoms::autoplay) &&
      mPreloadAction == HTMLMediaElement::PRELOAD_METADATA) {
    mSuspendedAfterFirstFrame = true;
    mDecoder->Suspend();
  }
}

void HTMLMediaElement::NetworkError()
{
  if (mReadyState == nsIDOMHTMLMediaElement::HAVE_NOTHING) {
    NoSupportedMediaSourceError();
  } else {
    Error(MEDIA_ERR_NETWORK);
  }
}

void HTMLMediaElement::DecodeError(const MediaResult& aError)
{
  nsAutoString src;
  GetCurrentSrc(src);
  const char16_t* params[] = { src.get() };
  ReportLoadError("MediaLoadDecodeError", params, ArrayLength(params));

  AudioTracks()->EmptyTracks();
  VideoTracks()->EmptyTracks();
  if (mIsLoadingFromSourceChildren) {
    mErrorSink->ResetError();
    if (mSourceLoadCandidate) {
      DispatchAsyncSourceError(mSourceLoadCandidate);
      QueueLoadFromSourceTask();
    } else {
      NS_WARNING("Should know the source we were loading from!");
    }
  } else if (mReadyState == nsIDOMHTMLMediaElement::HAVE_NOTHING) {
    NoSupportedMediaSourceError(aError.Description());
  } else {
    Error(MEDIA_ERR_DECODE, aError.Description());
  }
}

bool HTMLMediaElement::HasError() const
{
  return GetError();
}

void HTMLMediaElement::LoadAborted()
{
  Error(MEDIA_ERR_ABORTED);
}

void HTMLMediaElement::Error(uint16_t aErrorCode,
                             const nsACString& aErrorDetails)
{
  mErrorSink->SetError(aErrorCode, aErrorDetails);
  ChangeDelayLoadStatus(false);
  UpdateAudioChannelPlayingState();
}

void HTMLMediaElement::PlaybackEnded()
{
  // We changed state which can affect AddRemoveSelfReference
  AddRemoveSelfReference();

  NS_ASSERTION(!mDecoder || mDecoder->IsEnded(),
               "Decoder fired ended, but not in ended state");

  // Discard all output streams that have finished now.
  for (int32_t i = mOutputStreams.Length() - 1; i >= 0; --i) {
    if (mOutputStreams[i].mFinishWhenEnded) {
      LOG(LogLevel::Debug, ("Playback ended. Removing output stream %p",
                            mOutputStreams[i].mStream.get()));
      mOutputStreams.RemoveElementAt(i);
    }
  }

  if (mSrcStream || (mDecoder && mDecoder->IsInfinite())) {
    LOG(LogLevel::Debug, ("%p, got duration by reaching the end of the resource", this));
    DispatchAsyncEvent(NS_LITERAL_STRING("durationchange"));
  }

  if (HasAttr(kNameSpaceID_None, nsGkAtoms::loop)) {
    SetCurrentTime(0);
    return;
  }

  Pause();

  if (mSrcStream) {
    // A MediaStream that goes from inactive to active shall be eligible for
    // autoplay again according to the mediacapture-main spec.
    mAutoplaying = true;
  }

  FireTimeUpdate(false);
  DispatchAsyncEvent(NS_LITERAL_STRING("ended"));
}

void HTMLMediaElement::SeekStarted()
{
  DispatchAsyncEvent(NS_LITERAL_STRING("seeking"));
}

void HTMLMediaElement::SeekCompleted()
{
  mPlayingBeforeSeek = false;
  SetPlayedOrSeeked(true);
  if (mTextTrackManager) {
    mTextTrackManager->DidSeek();
  }
  FireTimeUpdate(false);
  DispatchAsyncEvent(NS_LITERAL_STRING("seeked"));
  // We changed whether we're seeking so we need to AddRemoveSelfReference
  AddRemoveSelfReference();
  if (mCurrentPlayRangeStart == -1.0) {
    mCurrentPlayRangeStart = CurrentTime();
  }
  // Unset the variable on seekend
  mPlayingThroughTheAudioChannelBeforeSeek = false;
}

void HTMLMediaElement::NotifySuspendedByCache(bool aIsSuspended)
{
  mDownloadSuspendedByCache = aIsSuspended;
}

void HTMLMediaElement::DownloadSuspended()
{
  if (mNetworkState == nsIDOMHTMLMediaElement::NETWORK_LOADING) {
    DispatchAsyncEvent(NS_LITERAL_STRING("progress"));
  }
  if (mBegun) {
    ChangeNetworkState(nsIDOMHTMLMediaElement::NETWORK_IDLE);
  }
}

void HTMLMediaElement::DownloadResumed(bool aForceNetworkLoading)
{
  if (mBegun || aForceNetworkLoading) {
    ChangeNetworkState(nsIDOMHTMLMediaElement::NETWORK_LOADING);
  }
}

void HTMLMediaElement::CheckProgress(bool aHaveNewProgress)
{
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(mNetworkState == nsIDOMHTMLMediaElement::NETWORK_LOADING);

  TimeStamp now = TimeStamp::NowLoRes();

  if (aHaveNewProgress) {
    mDataTime = now;
  }

  // If this is the first progress, or PROGRESS_MS has passed since the last
  // progress event fired and more data has arrived since then, fire a
  // progress event.
  NS_ASSERTION((mProgressTime.IsNull() && !aHaveNewProgress) ||
               !mDataTime.IsNull(),
               "null TimeStamp mDataTime should not be used in comparison");
  if (mProgressTime.IsNull() ? aHaveNewProgress
      : (now - mProgressTime >= TimeDuration::FromMilliseconds(PROGRESS_MS) &&
         mDataTime > mProgressTime)) {
    DispatchAsyncEvent(NS_LITERAL_STRING("progress"));
    // Resolution() ensures that future data will have now > mProgressTime,
    // and so will trigger another event.  mDataTime is not reset because it
    // is still required to detect stalled; it is similarly offset by
    // resolution to indicate the new data has not yet arrived.
    mProgressTime = now - TimeDuration::Resolution();
    if (mDataTime > mProgressTime) {
      mDataTime = mProgressTime;
    }
    if (!mProgressTimer) {
      NS_ASSERTION(aHaveNewProgress,
                   "timer dispatched when there was no timer");
      // Were stalled.  Restart timer.
      StartProgressTimer();
      if (!mLoadedDataFired) {
        ChangeDelayLoadStatus(true);
      }
    }
    // Download statistics may have been updated, force a recheck of the readyState.
    UpdateReadyStateInternal();
  }

  if (now - mDataTime >= TimeDuration::FromMilliseconds(STALL_MS)) {
    DispatchAsyncEvent(NS_LITERAL_STRING("stalled"));

    if (mMediaSource) {
      ChangeDelayLoadStatus(false);
    }

    NS_ASSERTION(mProgressTimer, "detected stalled without timer");
    // Stop timer events, which prevents repeated stalled events until there
    // is more progress.
    StopProgress();
  }

  AddRemoveSelfReference();
}

/* static */
void HTMLMediaElement::ProgressTimerCallback(nsITimer* aTimer, void* aClosure)
{
  auto decoder = static_cast<HTMLMediaElement*>(aClosure);
  decoder->CheckProgress(false);
}

void HTMLMediaElement::StartProgressTimer()
{
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(mNetworkState == nsIDOMHTMLMediaElement::NETWORK_LOADING);
  NS_ASSERTION(!mProgressTimer, "Already started progress timer.");

  mProgressTimer = do_CreateInstance("@mozilla.org/timer;1");
  mProgressTimer->InitWithNamedFuncCallback(
    ProgressTimerCallback, this, PROGRESS_MS, nsITimer::TYPE_REPEATING_SLACK,
    "HTMLMediaElement::ProgressTimerCallback");
}

void HTMLMediaElement::StartProgress()
{
  // Record the time now for detecting stalled.
  mDataTime = TimeStamp::NowLoRes();
  // Reset mProgressTime so that mDataTime is not indicating bytes received
  // after the last progress event.
  mProgressTime = TimeStamp();
  StartProgressTimer();
}

void HTMLMediaElement::StopProgress()
{
  MOZ_ASSERT(NS_IsMainThread());
  if (!mProgressTimer) {
    return;
  }

  mProgressTimer->Cancel();
  mProgressTimer = nullptr;
}

void HTMLMediaElement::DownloadProgressed()
{
  if (mNetworkState != nsIDOMHTMLMediaElement::NETWORK_LOADING) {
    return;
  }
  CheckProgress(true);
}

bool HTMLMediaElement::ShouldCheckAllowOrigin()
{
  return mCORSMode != CORS_NONE;
}

bool HTMLMediaElement::IsCORSSameOrigin()
{
  bool subsumes;
  RefPtr<nsIPrincipal> principal = GetCurrentPrincipal();
  return
    (NS_SUCCEEDED(NodePrincipal()->Subsumes(principal, &subsumes)) && subsumes) ||
    ShouldCheckAllowOrigin();
}

void
HTMLMediaElement::UpdateReadyStateInternal()
{
  if (!mDecoder && !mSrcStream) {
    // Not initialized - bail out.
    LOG(LogLevel::Debug, ("MediaElement %p UpdateReadyStateInternal() "
                          "Not initialized", this));
    return;
  }

  if (mDecoder && mReadyState < nsIDOMHTMLMediaElement::HAVE_METADATA) {
    // aNextFrame might have a next frame because the decoder can advance
    // on its own thread before MetadataLoaded gets a chance to run.
    // The arrival of more data can't change us out of this readyState.
    LOG(LogLevel::Debug, ("MediaElement %p UpdateReadyStateInternal() "
                          "Decoder ready state < HAVE_METADATA", this));
    return;
  }

  if (mSrcStream && mReadyState < nsIDOMHTMLMediaElement::HAVE_METADATA) {
    if (!mSrcStreamTracksAvailable) {
      LOG(LogLevel::Debug, ("MediaElement %p UpdateReadyStateInternal() "
                            "MediaStreamTracks not available yet", this));
      return;
    }

    bool hasAudioTracks = !AudioTracks()->IsEmpty();
    bool hasVideoTracks = !VideoTracks()->IsEmpty();
    if (!hasAudioTracks && !hasVideoTracks) {
      LOG(LogLevel::Debug, ("MediaElement %p UpdateReadyStateInternal() "
                            "Stream with no tracks", this));
      return;
    }

    if (IsVideo() && hasVideoTracks && !HasVideo()) {
      LOG(LogLevel::Debug, ("MediaElement %p UpdateReadyStateInternal() "
                            "Stream waiting for video", this));
      return;
    }

    LOG(LogLevel::Debug, ("MediaElement %p UpdateReadyStateInternal() Stream has "
                          "metadata; audioTracks=%d, videoTracks=%d, "
                          "hasVideoFrame=%d", this, AudioTracks()->Length(),
                          VideoTracks()->Length(), HasVideo()));

    // We are playing a stream that has video and a video frame is now set.
    // This means we have all metadata needed to change ready state.
    MediaInfo mediaInfo = mMediaInfo;
    if (hasAudioTracks) {
      mediaInfo.EnableAudio();
    }
    if (hasVideoTracks) {
      mediaInfo.EnableVideo();
    }
    MetadataLoaded(&mediaInfo, nsAutoPtr<const MetadataTags>(nullptr));
  }

  enum NextFrameStatus nextFrameStatus = NextFrameStatus();
  if (nextFrameStatus == NEXT_FRAME_UNAVAILABLE ||
      (nextFrameStatus == NEXT_FRAME_UNAVAILABLE_BUFFERING &&
       mWaitingForKey == WAITING_FOR_KEY)) {
    if (mWaitingForKey != NOT_WAITING_FOR_KEY) {
      // http://w3c.github.io/encrypted-media/#wait-for-key
      // Continuing 7.3.4 Queue a "waitingforkey" Event
      // 4. Queue a task to fire a simple event named waitingforkey
      // at the media element.
      if (mWaitingForKey == WAITING_FOR_KEY) {
        mWaitingForKey = WAITING_FOR_KEY_DISPATCHED;
        DispatchAsyncEvent(NS_LITERAL_STRING("waitingforkey"));
      }
      // 5. Set the readyState of media element to HAVE_METADATA.
      // NOTE: We'll change to HAVE_CURRENT_DATA or HAVE_METADATA
      // depending on whether we've loaded the first frame or not
      // below.
      // 6. Suspend playback.
      // Note: Playback will already be stalled, as the next frame is
      // unavailable.
    } else if (mDecoder) {
      nextFrameStatus = mDecoder->NextFrameBufferedStatus();
    }
  }

  if (nextFrameStatus == MediaDecoderOwner::NEXT_FRAME_UNAVAILABLE_SEEKING) {
    LOG(LogLevel::Debug, ("MediaElement %p UpdateReadyStateInternal() "
                          "NEXT_FRAME_UNAVAILABLE_SEEKING; Forcing HAVE_METADATA", this));
    ChangeReadyState(nsIDOMHTMLMediaElement::HAVE_METADATA);
    return;
  }

  if (IsVideo() && HasVideo() && !IsPlaybackEnded() &&
        GetImageContainer() && !GetImageContainer()->HasCurrentImage()) {
    // Don't advance if we are playing video, but don't have a video frame.
    // Also, if video became available after advancing to HAVE_CURRENT_DATA
    // while we are still playing, we need to revert to HAVE_METADATA until
    // a video frame is available.
    LOG(LogLevel::Debug, ("MediaElement %p UpdateReadyStateInternal() "
                          "Playing video but no video frame; Forcing HAVE_METADATA", this));
    ChangeReadyState(nsIDOMHTMLMediaElement::HAVE_METADATA);
    return;
  }

  if (!mFirstFrameLoaded) {
    // We haven't yet loaded the first frame, making us unable to determine
    // if we have enough valid data at the present stage.
    return;
  }

  if (nextFrameStatus == NEXT_FRAME_UNAVAILABLE_BUFFERING) {
    // Force HAVE_CURRENT_DATA when buffering.
    ChangeReadyState(nsIDOMHTMLMediaElement::HAVE_CURRENT_DATA);
    return;
  }

  if (mDownloadSuspendedByCache && mDecoder && !mDecoder->IsEnded()) {
    // The decoder has signaled that the download has been suspended by the
    // media cache. So move readyState into HAVE_ENOUGH_DATA, in case there's
    // script waiting for a "canplaythrough" event; without this forced
    // transition, we will never fire the "canplaythrough" event if the
    // media cache is too small, and scripts are bound to fail. Don't force
    // this transition if the decoder is in ended state; the readyState
    // should remain at HAVE_CURRENT_DATA in this case.
    // Note that this state transition includes the case where we finished
    // downloaded the whole data stream.
    LOG(LogLevel::Debug, ("MediaElement %p UpdateReadyStateInternal() "
                          "Decoder download suspended by cache", this));
    ChangeReadyState(nsIDOMHTMLMediaElement::HAVE_ENOUGH_DATA);
    return;
  }

  if (mDecoder && !mDecoder->IsEnded() &&
      !mDecoder->GetResource()->IsExpectingMoreData()) {
    LOG(LogLevel::Debug, ("MediaElement %p UpdateReadyStateInternal() "
                          "Decoder fetched all data for media resource", this));
    ChangeReadyState(nsIDOMHTMLMediaElement::HAVE_ENOUGH_DATA);
    return;
  }

  if (nextFrameStatus != MediaDecoderOwner::NEXT_FRAME_AVAILABLE) {
    LOG(LogLevel::Debug, ("MediaElement %p UpdateReadyStateInternal() "
                          "Next frame not available", this));
    ChangeReadyState(nsIDOMHTMLMediaElement::HAVE_CURRENT_DATA);
    return;
  }

  if (mSrcStream) {
    LOG(LogLevel::Debug, ("MediaElement %p UpdateReadyStateInternal() "
                          "Stream HAVE_ENOUGH_DATA", this));
    ChangeReadyState(nsIDOMHTMLMediaElement::HAVE_ENOUGH_DATA);
    return;
  }

  // Now see if we should set HAVE_ENOUGH_DATA.
  // If it's something we don't know the size of, then we can't
  // make a real estimate, so we go straight to HAVE_ENOUGH_DATA once
  // we've downloaded enough data that our download rate is considered
  // reliable. We have to move to HAVE_ENOUGH_DATA at some point or
  // autoplay elements for live streams will never play. Otherwise we
  // move to HAVE_ENOUGH_DATA if we can play through the entire media
  // without stopping to buffer.
  if (mWaitingForKey == NOT_WAITING_FOR_KEY && mDecoder->CanPlayThrough()) {
    LOG(LogLevel::Debug, ("MediaElement %p UpdateReadyStateInternal() "
                          "Decoder can play through", this));
    ChangeReadyState(nsIDOMHTMLMediaElement::HAVE_ENOUGH_DATA);
    return;
  }
  LOG(LogLevel::Debug, ("MediaElement %p UpdateReadyStateInternal() "
                        "Default; Decoder has future data", this));
  ChangeReadyState(nsIDOMHTMLMediaElement::HAVE_FUTURE_DATA);
}

static const char* const gReadyStateToString[] = {
  "HAVE_NOTHING",
  "HAVE_METADATA",
  "HAVE_CURRENT_DATA",
  "HAVE_FUTURE_DATA",
  "HAVE_ENOUGH_DATA"
};

void HTMLMediaElement::ChangeReadyState(nsMediaReadyState aState)
{
  nsMediaReadyState oldState = mReadyState;
  mReadyState = aState;

  if (mNetworkState == nsIDOMHTMLMediaElement::NETWORK_EMPTY ||
      oldState == mReadyState) {
    return;
  }

  LOG(LogLevel::Debug, ("%p Ready state changed to %s", this, gReadyStateToString[aState]));

  UpdateAudioChannelPlayingState();

  // Handle raising of "waiting" event during seek (see 4.8.10.9)
  // or
  // 4.8.12.7 Ready states:
  // "If the previous ready state was HAVE_FUTURE_DATA or more, and the new
  // ready state is HAVE_CURRENT_DATA or less
  // If the media element was potentially playing before its readyState
  // attribute changed to a value lower than HAVE_FUTURE_DATA, and the element
  // has not ended playback, and playback has not stopped due to errors,
  // paused for user interaction, or paused for in-band content, the user agent
  // must queue a task to fire a simple event named timeupdate at the element,
  // and queue a task to fire a simple event named waiting at the element."
  if (mPlayingBeforeSeek &&
      mReadyState < nsIDOMHTMLMediaElement::HAVE_FUTURE_DATA) {
    DispatchAsyncEvent(NS_LITERAL_STRING("waiting"));
  } else if (oldState >= nsIDOMHTMLMediaElement::HAVE_FUTURE_DATA &&
             mReadyState < nsIDOMHTMLMediaElement::HAVE_FUTURE_DATA &&
             !Paused() && !Ended() && !mErrorSink->mError) {
    FireTimeUpdate(false);
    DispatchAsyncEvent(NS_LITERAL_STRING("waiting"));
  }

  if (oldState < nsIDOMHTMLMediaElement::HAVE_CURRENT_DATA &&
      mReadyState >= nsIDOMHTMLMediaElement::HAVE_CURRENT_DATA &&
      !mLoadedDataFired) {
    DispatchAsyncEvent(NS_LITERAL_STRING("loadeddata"));
    mLoadedDataFired = true;
  }

  if (oldState < nsIDOMHTMLMediaElement::HAVE_FUTURE_DATA &&
      mReadyState >= nsIDOMHTMLMediaElement::HAVE_FUTURE_DATA) {
    DispatchAsyncEvent(NS_LITERAL_STRING("canplay"));
    if (!mPaused) {
      mWaitingForKey = NOT_WAITING_FOR_KEY;
      DispatchAsyncEvent(NS_LITERAL_STRING("playing"));
    }
  }

  CheckAutoplayDataReady();

  if (oldState < nsIDOMHTMLMediaElement::HAVE_ENOUGH_DATA &&
      mReadyState >= nsIDOMHTMLMediaElement::HAVE_ENOUGH_DATA) {
    DispatchAsyncEvent(NS_LITERAL_STRING("canplaythrough"));
  }
}

static const char* const gNetworkStateToString[] = {
  "EMPTY",
  "IDLE",
  "LOADING",
  "NO_SOURCE"
 };

void HTMLMediaElement::ChangeNetworkState(nsMediaNetworkState aState)
{
  if (mNetworkState == aState) {
    return;
  }

  nsMediaNetworkState oldState = mNetworkState;
  mNetworkState = aState;
  LOG(LogLevel::Debug, ("%p Network state changed to %s", this, gNetworkStateToString[aState]));

  // TODO: |mBegun| reflects the download status. We should be able to remove
  // it and check |mNetworkState| only.

  if (oldState == nsIDOMHTMLMediaElement::NETWORK_LOADING) {
    // Reset |mBegun| since we're not downloading anymore.
    mBegun = false;
    // Stop progress notification when exiting NETWORK_LOADING.
    StopProgress();
  }

  if (mNetworkState == nsIDOMHTMLMediaElement::NETWORK_LOADING) {
    // Download is begun.
    mBegun = true;
    // Start progress notification when entering NETWORK_LOADING.
    StartProgress();
  } else if (mNetworkState == nsIDOMHTMLMediaElement::NETWORK_IDLE &&
             !mErrorSink->mError) {
    // Fire 'suspend' event when entering NETWORK_IDLE and no error presented.
    DispatchAsyncEvent(NS_LITERAL_STRING("suspend"));
  }

  // Changing mNetworkState affects AddRemoveSelfReference().
  AddRemoveSelfReference();
}

bool HTMLMediaElement::CanActivateAutoplay()
{
  // For stream inputs, we activate autoplay on HAVE_NOTHING because
  // this element itself might be blocking the stream from making progress by
  // being paused. We only check that it has data by checking its active state.
  // We also activate autoplay when playing a media source since the data
  // download is controlled by the script and there is no way to evaluate
  // MediaDecoder::CanPlayThrough().

  if (!HasAttr(kNameSpaceID_None, nsGkAtoms::autoplay) || !mAutoplayEnabled) {
    return false;
  }

  if (!mAutoplaying) {
    return false;
  }

  if (IsEditable()) {
    return false;
  }

  if (!mPaused) {
    return false;
  }

  if (mPausedForInactiveDocumentOrChannel) {
    return false;
  }

  if (!IsAllowedToPlayByAudioChannel()) {
    return false;
  }

  bool hasData =
    (mDecoder && mReadyState >= nsIDOMHTMLMediaElement::HAVE_ENOUGH_DATA) ||
    (mSrcStream && mSrcStream->Active()) ||
    mMediaSource;

  return hasData;
}

void HTMLMediaElement::CheckAutoplayDataReady()
{
  if (!CanActivateAutoplay()) {
    return;
  }

  mPaused = false;
  // We changed mPaused which can affect AddRemoveSelfReference
  AddRemoveSelfReference();
  UpdateSrcMediaStreamPlaying();
  UpdateAudioChannelPlayingState();

  if (mDecoder) {
    SetPlayedOrSeeked(true);
    if (mCurrentPlayRangeStart == -1.0) {
      mCurrentPlayRangeStart = CurrentTime();
    }
    mDecoder->Play();
  } else if (mSrcStream) {
    SetPlayedOrSeeked(true);
  }

  // For blocked media, the event would be pending until it is resumed.
  DispatchAsyncEvent(NS_LITERAL_STRING("play"));

  DispatchAsyncEvent(NS_LITERAL_STRING("playing"));
}

bool HTMLMediaElement::IsActive() const
{
  nsIDocument* ownerDoc = OwnerDoc();
  return ownerDoc && ownerDoc->IsActive() && ownerDoc->IsVisible();
}

bool HTMLMediaElement::IsHidden() const
{
  nsIDocument* ownerDoc;
  return mUnboundFromTree || !(ownerDoc = OwnerDoc()) || ownerDoc->Hidden();
}

VideoFrameContainer* HTMLMediaElement::GetVideoFrameContainer()
{
  if (mShuttingDown) {
    return nullptr;
  }

  if (mVideoFrameContainer)
    return mVideoFrameContainer;

  // Only video frames need an image container.
  if (!IsVideo()) {
    return nullptr;
  }

  mVideoFrameContainer =
    new VideoFrameContainer(this, LayerManager::CreateImageContainer(ImageContainer::ASYNCHRONOUS));

  return mVideoFrameContainer;
}

void
HTMLMediaElement::PrincipalChanged(DOMMediaStream* aStream)
{
  LOG(LogLevel::Info, ("HTMLMediaElement %p Stream principal changed.", this));
  nsContentUtils::CombineResourcePrincipals(&mSrcStreamVideoPrincipal,
                                            aStream->GetVideoPrincipal());

  LOG(LogLevel::Debug, ("HTMLMediaElement %p Stream video principal changed to "
                        "%p. Waiting for it to reach VideoFrameContainer before "
                        "setting.", this, aStream->GetVideoPrincipal()));
  if (mVideoFrameContainer) {
    UpdateSrcStreamVideoPrincipal(mVideoFrameContainer->GetLastPrincipalHandle());
  }
}

void
HTMLMediaElement::UpdateSrcStreamVideoPrincipal(const PrincipalHandle& aPrincipalHandle)
{
  nsTArray<RefPtr<VideoStreamTrack>> videoTracks;
  mSrcStream->GetVideoTracks(videoTracks);

  PrincipalHandle handle(aPrincipalHandle);
  bool matchesTrackPrincipal = false;
  for (const RefPtr<VideoStreamTrack>& track : videoTracks) {
    if (PrincipalHandleMatches(handle,
                               track->GetPrincipal()) &&
        !track->Ended()) {
      // When the PrincipalHandle for the VideoFrameContainer changes to that of
      // a track in mSrcStream we know that a removed track was displayed but
      // is no longer so.
      matchesTrackPrincipal = true;
      LOG(LogLevel::Debug, ("HTMLMediaElement %p VideoFrameContainer's "
                            "PrincipalHandle matches track %p. That's all we "
                            "need.", this, track.get()));
      break;
    }
  }

  if (matchesTrackPrincipal) {
    mSrcStreamVideoPrincipal = mSrcStream->GetVideoPrincipal();
  }
}

void
HTMLMediaElement::PrincipalHandleChangedForVideoFrameContainer(VideoFrameContainer* aContainer,
                                                               const PrincipalHandle& aNewPrincipalHandle)
{
  MOZ_ASSERT(NS_IsMainThread());

  if (!mSrcStream) {
    return;
  }

  LOG(LogLevel::Debug, ("HTMLMediaElement %p PrincipalHandle changed in "
                        "VideoFrameContainer.",
                        this));

  UpdateSrcStreamVideoPrincipal(aNewPrincipalHandle);
}

nsresult HTMLMediaElement::DispatchEvent(const nsAString& aName)
{
  LOG_EVENT(LogLevel::Debug, ("%p Dispatching event %s", this,
                          NS_ConvertUTF16toUTF8(aName).get()));

  // Save events that occur while in the bfcache. These will be dispatched
  // if the page comes out of the bfcache.
  if (mEventDeliveryPaused) {
    mPendingEvents.AppendElement(aName);
    return NS_OK;
  }

  return nsContentUtils::DispatchTrustedEvent(OwnerDoc(),
                                              static_cast<nsIContent*>(this),
                                              aName,
                                              false,
                                              false);
}

nsresult HTMLMediaElement::DispatchAsyncEvent(const nsAString& aName)
{
  LOG_EVENT(LogLevel::Debug, ("%p Queuing event %s", this,
            NS_ConvertUTF16toUTF8(aName).get()));

  // Save events that occur while in the bfcache. These will be dispatched
  // if the page comes out of the bfcache.
  if (mEventDeliveryPaused) {
    mPendingEvents.AppendElement(aName);
    return NS_OK;
  }

  nsCOMPtr<nsIRunnable> event = new nsAsyncEventRunner(aName, this);
  NS_DispatchToMainThread(event);

  if ((aName.EqualsLiteral("play") || aName.EqualsLiteral("playing"))) {
    mPlayTime.Start();
    if (IsHidden()) {
      HiddenVideoStart();
    }
  } else if (aName.EqualsLiteral("waiting")) {
    mPlayTime.Pause();
    HiddenVideoStop();
  } else if (aName.EqualsLiteral("pause")) {
    mPlayTime.Pause();
    HiddenVideoStop();
  }

  return NS_OK;
}

nsresult HTMLMediaElement::DispatchPendingMediaEvents()
{
  NS_ASSERTION(!mEventDeliveryPaused,
               "Must not be in bfcache when dispatching pending media events");

  uint32_t count = mPendingEvents.Length();
  for (uint32_t i = 0; i < count; ++i) {
    DispatchAsyncEvent(mPendingEvents[i]);
  }
  mPendingEvents.Clear();

  return NS_OK;
}

bool HTMLMediaElement::IsPotentiallyPlaying() const
{
  // TODO:
  //   playback has not stopped due to errors,
  //   and the element has not paused for user interaction
  return
    !mPaused &&
    (mReadyState == nsIDOMHTMLMediaElement::HAVE_ENOUGH_DATA ||
    mReadyState == nsIDOMHTMLMediaElement::HAVE_FUTURE_DATA) &&
    !IsPlaybackEnded();
}

bool HTMLMediaElement::IsPlaybackEnded() const
{
  // TODO:
  //   the current playback position is equal to the effective end of the media resource.
  //   See bug 449157.
  return mReadyState >= nsIDOMHTMLMediaElement::HAVE_METADATA &&
         mDecoder && mDecoder->IsEnded();
}

already_AddRefed<nsIPrincipal> HTMLMediaElement::GetCurrentPrincipal()
{
  if (mDecoder) {
    return mDecoder->GetCurrentPrincipal();
  }
  if (mSrcStream) {
    nsCOMPtr<nsIPrincipal> principal = mSrcStream->GetPrincipal();
    return principal.forget();
  }
  return nullptr;
}

already_AddRefed<nsIPrincipal> HTMLMediaElement::GetCurrentVideoPrincipal()
{
  if (mDecoder) {
    return mDecoder->GetCurrentPrincipal();
  }
  if (mSrcStream) {
    nsCOMPtr<nsIPrincipal> principal = mSrcStreamVideoPrincipal;
    return principal.forget();
  }
  return nullptr;
}

void HTMLMediaElement::NotifyDecoderPrincipalChanged()
{
  RefPtr<nsIPrincipal> principal = GetCurrentPrincipal();

  mDecoder->UpdateSameOriginStatus(!principal || IsCORSSameOrigin());

  for (DecoderPrincipalChangeObserver* observer :
         mDecoderPrincipalChangeObservers) {
    observer->NotifyDecoderPrincipalChanged();
  }
}

void HTMLMediaElement::AddDecoderPrincipalChangeObserver(DecoderPrincipalChangeObserver* aObserver)
{
  mDecoderPrincipalChangeObservers.AppendElement(aObserver);
}

bool HTMLMediaElement::RemoveDecoderPrincipalChangeObserver(DecoderPrincipalChangeObserver* aObserver)
{
  return mDecoderPrincipalChangeObservers.RemoveElement(aObserver);
}

void HTMLMediaElement::UpdateMediaSize(const nsIntSize& aSize)
{
  if (IsVideo() && mReadyState != HAVE_NOTHING &&
      mMediaInfo.mVideo.mDisplay != aSize) {
    DispatchAsyncEvent(NS_LITERAL_STRING("resize"));
  }

  mMediaInfo.mVideo.mDisplay = aSize;
  mWatchManager.ManualNotify(&HTMLMediaElement::UpdateReadyStateInternal);
}

void HTMLMediaElement::UpdateInitialMediaSize(const nsIntSize& aSize)
{
  if (!mMediaInfo.HasVideo()) {
    UpdateMediaSize(aSize);
  }

  if (!mMediaStreamSizeListener) {
    return;
  }

  if (!mSelectedVideoStreamTrack) {
    MOZ_ASSERT(false);
    return;
  }

  mSelectedVideoStreamTrack->RemoveDirectListener(mMediaStreamSizeListener);
  mMediaStreamSizeListener->Forget();
  mMediaStreamSizeListener = nullptr;
}

void HTMLMediaElement::SuspendOrResumeElement(bool aPauseElement, bool aSuspendEvents)
{
  LOG(LogLevel::Debug, ("%p SuspendOrResumeElement(pause=%d, suspendEvents=%d) hidden=%d",
      this, aPauseElement, aSuspendEvents, OwnerDoc()->Hidden()));

  if (aPauseElement != mPausedForInactiveDocumentOrChannel) {
    mPausedForInactiveDocumentOrChannel = aPauseElement;
    UpdateSrcMediaStreamPlaying();
    UpdateAudioChannelPlayingState();
    if (aPauseElement) {
      ReportTelemetry();
      ReportEMETelemetry();

      // For EME content, force destruction of the CDM client (and CDM
      // instance if this is the last client for that CDM instance) and
      // the CDM's decoder. This ensures the CDM gets reliable and prompt
      // shutdown notifications, as it may have book-keeping it needs
      // to do on shutdown.
      if (mMediaKeys) {
        mMediaKeys->Shutdown();
        mMediaKeys = nullptr;
        if (mDecoder) {
          ShutdownDecoder();
        }
      }
      if (mDecoder) {
        mDecoder->Pause();
        mDecoder->Suspend();
      }
      mEventDeliveryPaused = aSuspendEvents;
    } else {
      MOZ_ASSERT(!mMediaKeys);
      if (mDecoder) {
        mDecoder->Resume();
        if (!mPaused && !mDecoder->IsEnded()) {
          mDecoder->Play();
        }
      }
      if (mEventDeliveryPaused) {
        mEventDeliveryPaused = false;
        DispatchPendingMediaEvents();
      }
    }
  }
}

bool HTMLMediaElement::IsBeingDestroyed()
{
  nsIDocument* ownerDoc = OwnerDoc();
  nsIDocShell* docShell = ownerDoc ? ownerDoc->GetDocShell() : nullptr;
  bool isBeingDestroyed = false;
  if (docShell) {
    docShell->IsBeingDestroyed(&isBeingDestroyed);
  }
  return isBeingDestroyed;
}

void HTMLMediaElement::NotifyOwnerDocumentActivityChanged()
{
  bool visible = !IsHidden();
  if (visible) {
    // Visible -> Just pause hidden play time (no-op if already paused).
    HiddenVideoStop();
  } else if (mPlayTime.IsStarted()) {
    // Not visible, play time is running -> Start hidden play time if needed.
    HiddenVideoStart();
  }

  if (mDecoder && !IsBeingDestroyed()) {
    mDecoder->NotifyOwnerActivityChanged(visible);
  }

  bool pauseElement = ShouldElementBePaused();
  SuspendOrResumeElement(pauseElement, !IsActive());

  AddRemoveSelfReference();
}

void HTMLMediaElement::AddRemoveSelfReference()
{
  // XXX we could release earlier here in many situations if we examined
  // which event listeners are attached. Right now we assume there is a
  // potential listener for every event. We would also have to keep the
  // element alive if it was playing and producing audio output --- right now
  // that's covered by the !mPaused check.
  nsIDocument* ownerDoc = OwnerDoc();

  // See the comment at the top of this file for the explanation of this
  // boolean expression.
  bool needSelfReference = !mShuttingDown &&
    ownerDoc->IsActive() &&
    (mDelayingLoadEvent ||
     (!mPaused && mDecoder && !mDecoder->IsEnded()) ||
     (!mPaused && mSrcStream && !mSrcStream->IsFinished()) ||
     (mDecoder && mDecoder->IsSeeking()) ||
     CanActivateAutoplay() ||
     (mMediaSource ? mProgressTimer :
      mNetworkState == nsIDOMHTMLMediaElement::NETWORK_LOADING));

  if (needSelfReference != mHasSelfReference) {
    mHasSelfReference = needSelfReference;
    if (needSelfReference) {
      // The shutdown observer will hold a strong reference to us. This
      // will do to keep us alive. We need to know about shutdown so that
      // we can release our self-reference.
      mShutdownObserver->AddRefMediaElement();
    } else {
      // Dispatch Release asynchronously so that we don't destroy this object
      // inside a call stack of method calls on this object
      nsCOMPtr<nsIRunnable> event =
        NewRunnableMethod(this, &HTMLMediaElement::DoRemoveSelfReference);
      NS_DispatchToMainThread(event);
    }
  }

  UpdateAudioChannelPlayingState();
}

void HTMLMediaElement::DoRemoveSelfReference()
{
  mShutdownObserver->ReleaseMediaElement();
}

void HTMLMediaElement::NotifyShutdownEvent()
{
  mShuttingDown = true;
  ResetState();
  AddRemoveSelfReference();
}

bool
HTMLMediaElement::IsNodeOfType(uint32_t aFlags) const
{
  return !(aFlags & ~(eCONTENT | eMEDIA));
}

void HTMLMediaElement::DispatchAsyncSourceError(nsIContent* aSourceElement)
{
  LOG_EVENT(LogLevel::Debug, ("%p Queuing simple source error event", this));

  nsCOMPtr<nsIRunnable> event = new nsSourceErrorEventRunner(this, aSourceElement);
  NS_DispatchToMainThread(event);
}

void HTMLMediaElement::NotifyAddedSource()
{
  // If a source element is inserted as a child of a media element
  // that has no src attribute and whose networkState has the value
  // NETWORK_EMPTY, the user agent must invoke the media element's
  // resource selection algorithm.
  if (!HasAttr(kNameSpaceID_None, nsGkAtoms::src) &&
      mNetworkState == nsIDOMHTMLMediaElement::NETWORK_EMPTY)
  {
    QueueSelectResourceTask();
  }

  // A load was paused in the resource selection algorithm, waiting for
  // a new source child to be added, resume the resource selection algorithm.
  if (mLoadWaitStatus == WAITING_FOR_SOURCE) {
    // Rest the flag so we don't queue multiple LoadFromSourceTask() when
    // multiple <source> are attached in an event loop.
    mLoadWaitStatus = NOT_WAITING;
    QueueLoadFromSourceTask();
  }
}

nsIContent* HTMLMediaElement::GetNextSource()
{
  nsCOMPtr<nsIDOMNode> thisDomNode = do_QueryObject(this);

  mSourceLoadCandidate = nullptr;

  nsresult rv = NS_OK;
  if (!mSourcePointer) {
    // First time this has been run, create a selection to cover children.
    mSourcePointer = new nsRange(this);
    // If this media element is removed from the DOM, don't gravitate the
    // range up to its ancestor, leave it attached to the media element.
    mSourcePointer->SetEnableGravitationOnElementRemoval(false);

    rv = mSourcePointer->SelectNodeContents(thisDomNode);
    if (NS_FAILED(rv)) return nullptr;

    rv = mSourcePointer->Collapse(true);
    if (NS_FAILED(rv)) return nullptr;
  }

  while (true) {
#ifdef DEBUG
    nsCOMPtr<nsIDOMNode> startContainer;
    rv = mSourcePointer->GetStartContainer(getter_AddRefs(startContainer));
    if (NS_FAILED(rv)) return nullptr;
    NS_ASSERTION(startContainer == thisDomNode,
                "Should only iterate over direct children");
#endif

    int32_t startOffset = 0;
    rv = mSourcePointer->GetStartOffset(&startOffset);
    NS_ENSURE_SUCCESS(rv, nullptr);

    if (uint32_t(startOffset) == GetChildCount())
      return nullptr; // No more children.

    // Advance the range to the next child.
    rv = mSourcePointer->SetStart(thisDomNode, startOffset + 1);
    NS_ENSURE_SUCCESS(rv, nullptr);

    nsIContent* child = GetChildAt(startOffset);

    // If child is a <source> element, it is the next candidate.
    if (child && child->IsHTMLElement(nsGkAtoms::source)) {
      mSourceLoadCandidate = child;
      return child;
    }
  }
  NS_NOTREACHED("Execution should not reach here!");
  return nullptr;
}

void HTMLMediaElement::ChangeDelayLoadStatus(bool aDelay)
{
  if (mDelayingLoadEvent == aDelay)
    return;

  mDelayingLoadEvent = aDelay;

  LOG(LogLevel::Debug, ("%p ChangeDelayLoadStatus(%d) doc=0x%p", this, aDelay, mLoadBlockedDoc.get()));
  if (mDecoder) {
    mDecoder->SetLoadInBackground(!aDelay);
  }
  if (aDelay) {
    mLoadBlockedDoc = OwnerDoc();
    mLoadBlockedDoc->BlockOnload();
  } else {
    // mLoadBlockedDoc might be null due to GC unlinking
    if (mLoadBlockedDoc) {
      mLoadBlockedDoc->UnblockOnload(false);
      mLoadBlockedDoc = nullptr;
    }
  }

  // We changed mDelayingLoadEvent which can affect AddRemoveSelfReference
  AddRemoveSelfReference();
}

already_AddRefed<nsILoadGroup> HTMLMediaElement::GetDocumentLoadGroup()
{
  if (!OwnerDoc()->IsActive()) {
    NS_WARNING("Load group requested for media element in inactive document.");
  }
  return OwnerDoc()->GetDocumentLoadGroup();
}

nsresult
HTMLMediaElement::CopyInnerTo(Element* aDest)
{
  nsresult rv = nsGenericHTMLElement::CopyInnerTo(aDest);
  NS_ENSURE_SUCCESS(rv, rv);
  if (aDest->OwnerDoc()->IsStaticDocument()) {
    HTMLMediaElement* dest = static_cast<HTMLMediaElement*>(aDest);
    dest->SetMediaInfo(mMediaInfo);
  }
  return rv;
}

already_AddRefed<TimeRanges>
HTMLMediaElement::Buffered() const
{
  RefPtr<TimeRanges> ranges = new TimeRanges(ToSupports(OwnerDoc()));
  if (mDecoder) {
    media::TimeIntervals buffered = mDecoder->GetBuffered();
    if (!buffered.IsInvalid()) {
      buffered.ToTimeRanges(ranges);
    }
  }
  return ranges.forget();
}

nsresult HTMLMediaElement::GetBuffered(nsIDOMTimeRanges** aBuffered)
{
  RefPtr<TimeRanges> ranges = Buffered();
  ranges.forget(aBuffered);
  return NS_OK;
}

void HTMLMediaElement::SetRequestHeaders(nsIHttpChannel* aChannel)
{
  // Send Accept header for video and audio types only (Bug 489071)
  SetAcceptHeader(aChannel);

  // Media elements are likely candidates for HTTP Pipeline head of line
  // blocking problems, so disable pipelines.
  nsLoadFlags loadflags;
  aChannel->GetLoadFlags(&loadflags);
  loadflags |= nsIRequest::INHIBIT_PIPELINE;
  aChannel->SetLoadFlags(loadflags);

  // Apache doesn't send Content-Length when gzip transfer encoding is used,
  // which prevents us from estimating the video length (if explicit Content-Duration
  // and a length spec in the container are not present either) and from seeking.
  // So, disable the standard "Accept-Encoding: gzip,deflate" that we usually send.
  // See bug 614760.
  aChannel->SetRequestHeader(NS_LITERAL_CSTRING("Accept-Encoding"),
                             EmptyCString(), false);

  // Set the Referer header
  aChannel->SetReferrerWithPolicy(OwnerDoc()->GetDocumentURI(),
                                  OwnerDoc()->GetReferrerPolicy());
}

void HTMLMediaElement::FireTimeUpdate(bool aPeriodic)
{
  NS_ASSERTION(NS_IsMainThread(), "Should be on main thread.");

  TimeStamp now = TimeStamp::Now();
  double time = CurrentTime();

  // Fire a timeupdate event if this is not a periodic update (i.e. it's a
  // timeupdate event mandated by the spec), or if it's a periodic update
  // and TIMEUPDATE_MS has passed since the last timeupdate event fired and
  // the time has changed.
  if (!aPeriodic ||
      (mLastCurrentTime != time &&
       (mTimeUpdateTime.IsNull() ||
        now - mTimeUpdateTime >= TimeDuration::FromMilliseconds(TIMEUPDATE_MS)))) {
    DispatchAsyncEvent(NS_LITERAL_STRING("timeupdate"));
    mTimeUpdateTime = now;
    mLastCurrentTime = time;
  }
  if (mFragmentEnd >= 0.0 && time >= mFragmentEnd) {
    Pause();
    mFragmentEnd = -1.0;
    mFragmentStart = -1.0;
    mDecoder->SetFragmentEndTime(mFragmentEnd);
  }

  // Update the cues displaying on the video.
  // Here mTextTrackManager can be null if the cycle collector has unlinked
  // us before our parent. In that case UnbindFromTree will call us
  // when our parent is unlinked.
  if (mTextTrackManager) {
    mTextTrackManager->TimeMarchesOn();
  }
}

MediaStream* HTMLMediaElement::GetSrcMediaStream() const
{
  if (!mSrcStream) {
    return nullptr;
  }
  return mSrcStream->GetPlaybackStream();
}

MediaError*
HTMLMediaElement::GetError() const
{
  return mErrorSink->mError;
}

void
HTMLMediaElement::OpenUnsupportedMediaWithExternalAppIfNeeded() const
{
  // Error sink would check the error state and other conditions to decide
  // whether we can open unsupported type media with an external app.
  mErrorSink->NotifyPlayStarted();
}

void HTMLMediaElement::GetCurrentSpec(nsCString& aString)
{
  if (mLoadingSrc) {
    mLoadingSrc->GetSpec(aString);
  } else {
    aString.Truncate();
  }
}

double
HTMLMediaElement::MozFragmentEnd()
{
  double duration = Duration();

  // If there is no end fragment, or the fragment end is greater than the
  // duration, return the duration.
  return (mFragmentEnd < 0.0 || mFragmentEnd > duration) ? duration : mFragmentEnd;
}

NS_IMETHODIMP HTMLMediaElement::GetMozFragmentEnd(double* aTime)
{
  *aTime = MozFragmentEnd();
  return NS_OK;
}

static double ClampPlaybackRate(double aPlaybackRate)
{
  if (aPlaybackRate == 0.0) {
    return aPlaybackRate;
  }
  if (Abs(aPlaybackRate) < MIN_PLAYBACKRATE) {
    return aPlaybackRate < 0 ? -MIN_PLAYBACKRATE : MIN_PLAYBACKRATE;
  }
  if (Abs(aPlaybackRate) > MAX_PLAYBACKRATE) {
    return aPlaybackRate < 0 ? -MAX_PLAYBACKRATE : MAX_PLAYBACKRATE;
  }
  return aPlaybackRate;
}

NS_IMETHODIMP HTMLMediaElement::GetDefaultPlaybackRate(double* aDefaultPlaybackRate)
{
  *aDefaultPlaybackRate = DefaultPlaybackRate();
  return NS_OK;
}

void
HTMLMediaElement::SetDefaultPlaybackRate(double aDefaultPlaybackRate, ErrorResult& aRv)
{
  if (aDefaultPlaybackRate < 0) {
    aRv.Throw(NS_ERROR_NOT_IMPLEMENTED);
    return;
  }

  mDefaultPlaybackRate = ClampPlaybackRate(aDefaultPlaybackRate);
  DispatchAsyncEvent(NS_LITERAL_STRING("ratechange"));
}

NS_IMETHODIMP HTMLMediaElement::SetDefaultPlaybackRate(double aDefaultPlaybackRate)
{
  ErrorResult rv;
  SetDefaultPlaybackRate(aDefaultPlaybackRate, rv);
  return rv.StealNSResult();
}

NS_IMETHODIMP HTMLMediaElement::GetPlaybackRate(double* aPlaybackRate)
{
  *aPlaybackRate = PlaybackRate();
  return NS_OK;
}

void
HTMLMediaElement::SetPlaybackRate(double aPlaybackRate, ErrorResult& aRv)
{
  // Changing the playback rate of a media that has more than two channels is
  // not supported.
  if (aPlaybackRate < 0) {
    aRv.Throw(NS_ERROR_NOT_IMPLEMENTED);
    return;
  }

  mPlaybackRate = ClampPlaybackRate(aPlaybackRate);

  if (mPlaybackRate != 0.0 &&
      (mPlaybackRate < 0 || mPlaybackRate > THRESHOLD_HIGH_PLAYBACKRATE_AUDIO ||
       mPlaybackRate < THRESHOLD_LOW_PLAYBACKRATE_AUDIO)) {
    SetMutedInternal(mMuted | MUTED_BY_INVALID_PLAYBACK_RATE);
  } else {
    SetMutedInternal(mMuted & ~MUTED_BY_INVALID_PLAYBACK_RATE);
  }

  if (mDecoder) {
    mDecoder->SetPlaybackRate(mPlaybackRate);
  }
  DispatchAsyncEvent(NS_LITERAL_STRING("ratechange"));
}

NS_IMETHODIMP HTMLMediaElement::SetPlaybackRate(double aPlaybackRate)
{
  ErrorResult rv;
  SetPlaybackRate(aPlaybackRate, rv);
  return rv.StealNSResult();
}

NS_IMETHODIMP HTMLMediaElement::GetMozPreservesPitch(bool* aPreservesPitch)
{
  *aPreservesPitch = MozPreservesPitch();
  return NS_OK;
}

NS_IMETHODIMP HTMLMediaElement::SetMozPreservesPitch(bool aPreservesPitch)
{
  mPreservesPitch = aPreservesPitch;
  if (mDecoder) {
    mDecoder->SetPreservesPitch(mPreservesPitch);
  }
  return NS_OK;
}

ImageContainer* HTMLMediaElement::GetImageContainer()
{
  VideoFrameContainer* container = GetVideoFrameContainer();
  return container ? container->GetImageContainer() : nullptr;
}

bool
HTMLMediaElement::MaybeCreateAudioChannelAgent()
{
  if (mAudioChannelAgent) {
    return true;
  }

  mAudioChannelAgent = new AudioChannelAgent();
  nsresult rv = mAudioChannelAgent->InitWithWeakCallback(OwnerDoc()->GetInnerWindow(),
                                           static_cast<int32_t>(mAudioChannel),
                                           this);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    mAudioChannelAgent = nullptr;
    MOZ_LOG(AudioChannelService::GetAudioChannelLog(), LogLevel::Debug,
           ("HTMLMediaElement, Fail to initialize the audio channel agent,"
            " this = %p\n", this));
    return false;
  }

  return true;
}

bool
HTMLMediaElement::IsPlayingThroughTheAudioChannel() const
{
  // If we have an error, we are not playing.
  if (mErrorSink->mError) {
    return false;
  }

  // It might be resumed from remote, we should keep the audio channel agent.
  if (IsSuspendedByAudioChannel()) {
    return true;
  }

  // Are we paused
  if (mPaused) {
    return false;
  }

  // We should consider any bfcached page or inactive document as non-playing.
  if (!IsActive()) {
    return false;
  }

  // A loop always is playing
  if (HasAttr(kNameSpaceID_None, nsGkAtoms::loop)) {
    return true;
  }

  // If we are actually playing...
  if (IsCurrentlyPlaying()) {
    return true;
  }

  // If we are seeking, we consider it as playing
  if (mPlayingThroughTheAudioChannelBeforeSeek) {
    return true;
  }

  // If we are playing an external stream.
  if (mSrcAttrStream) {
    return true;
  }

  return false;
}

void
HTMLMediaElement::UpdateAudioChannelPlayingState(bool aForcePlaying)
{
  bool playingThroughTheAudioChannel =
    aForcePlaying || IsPlayingThroughTheAudioChannel();

  if (playingThroughTheAudioChannel != mPlayingThroughTheAudioChannel) {
    if (!MaybeCreateAudioChannelAgent()) {
      return;
    }

    mPlayingThroughTheAudioChannel = playingThroughTheAudioChannel;
    NotifyAudioChannelAgent(mPlayingThroughTheAudioChannel);
  }
}

void
HTMLMediaElement::NotifyAudioChannelAgent(bool aPlaying)
{
  if (aPlaying) {
    // The reason we don't call NotifyStartedPlaying after the media element
    // really becomes audible is because there is another case needs to block
    // element as early as we can, we would hear sound leaking if we block it
    // too late. In that case (block autoplay in non-visited-tab), we need to
    // create a connection before decoding, because we don't want user hearing
    // any sound.
    AudioPlaybackConfig config;
    nsresult rv = mAudioChannelAgent->NotifyStartedPlaying(&config,
                                                           IsAudible());
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return;
    }

    WindowVolumeChanged(config.mVolume, config.mMuted);
    WindowSuspendChanged(config.mSuspend);
  } else {
    mAudioChannelAgent->NotifyStoppedPlaying();
  }
}

NS_IMETHODIMP
HTMLMediaElement::WindowVolumeChanged(float aVolume, bool aMuted)
{
  MOZ_LOG(AudioChannelService::GetAudioChannelLog(), LogLevel::Debug,
         ("HTMLMediaElement, WindowVolumeChanged, this = %p, "
          "aVolume = %f, aMuted = %d\n", this, aVolume, aMuted));

  if (mAudioChannelVolume != aVolume) {
    mAudioChannelVolume = aVolume;
    SetVolumeInternal();
  }

  if (aMuted && !ComputedMuted()) {
    SetMutedInternal(mMuted | MUTED_BY_AUDIO_CHANNEL);
  } else if (!aMuted && ComputedMuted()) {
    SetMutedInternal(mMuted & ~MUTED_BY_AUDIO_CHANNEL);
  }

  return NS_OK;
}

NS_IMETHODIMP
HTMLMediaElement::WindowSuspendChanged(SuspendTypes aSuspend)
{
  MOZ_LOG(AudioChannelService::GetAudioChannelLog(), LogLevel::Debug,
         ("HTMLMediaElement, WindowSuspendChanged, this = %p, "
          "aSuspend = %d\n", this, aSuspend));

  switch (aSuspend) {
    case nsISuspendedTypes::NONE_SUSPENDED:
      ResumeFromAudioChannel();
      break;
    case nsISuspendedTypes::SUSPENDED_PAUSE:
    case nsISuspendedTypes::SUSPENDED_PAUSE_DISPOSABLE:
      PauseByAudioChannel(aSuspend);
      break;
    case nsISuspendedTypes::SUSPENDED_BLOCK:
      BlockByAudioChannel();
      break;
    case nsISuspendedTypes::SUSPENDED_STOP_DISPOSABLE:
      SetAudioChannelSuspended(nsISuspendedTypes::NONE_SUSPENDED);
      Pause();
      break;
    default:
      MOZ_LOG(AudioChannelService::GetAudioChannelLog(), LogLevel::Debug,
             ("HTMLMediaElement, WindowSuspendChanged, this = %p, "
              "Error : unknown suspended type!\n", this));
  }

  return NS_OK;
}

void
HTMLMediaElement::ResumeFromAudioChannel()
{
  if (!IsSuspendedByAudioChannel()) {
    return;
  }

  switch (mAudioChannelSuspended) {
    case nsISuspendedTypes::SUSPENDED_PAUSE:
    case nsISuspendedTypes::SUSPENDED_PAUSE_DISPOSABLE:
      ResumeFromAudioChannelPaused(mAudioChannelSuspended);
      break;
    case nsISuspendedTypes::SUSPENDED_BLOCK:
      ResumeFromAudioChannelBlocked();
      break;
    default:
      MOZ_LOG(AudioChannelService::GetAudioChannelLog(), LogLevel::Debug,
             ("HTMLMediaElement, ResumeFromAudioChannel, this = %p, "
              "Error : resume without suspended!\n", this));
  }
}

void
HTMLMediaElement::ResumeFromAudioChannelPaused(SuspendTypes aSuspend)
{
  MOZ_ASSERT(mAudioChannelSuspended == nsISuspendedTypes::SUSPENDED_PAUSE ||
             mAudioChannelSuspended == nsISuspendedTypes::SUSPENDED_PAUSE_DISPOSABLE);

  SetAudioChannelSuspended(nsISuspendedTypes::NONE_SUSPENDED);
  nsresult rv = Play();
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return;
  }
  DispatchAsyncEvent(NS_LITERAL_STRING("mozinterruptend"));
}

void
HTMLMediaElement::ResumeFromAudioChannelBlocked()
{
  MOZ_ASSERT(mAudioChannelSuspended == nsISuspendedTypes::SUSPENDED_BLOCK);

  SetAudioChannelSuspended(nsISuspendedTypes::NONE_SUSPENDED);
  nsresult rv = Play();
  if (NS_WARN_IF(NS_FAILED(rv))) {
    return;
  }
}

void
HTMLMediaElement::PauseByAudioChannel(SuspendTypes aSuspend)
{
  if (IsSuspendedByAudioChannel()) {
    return;
  }

  SetAudioChannelSuspended(aSuspend);
  Pause();
  DispatchAsyncEvent(NS_LITERAL_STRING("mozinterruptbegin"));
}

void
HTMLMediaElement::BlockByAudioChannel()
{
  if (IsSuspendedByAudioChannel()) {
    return;
  }

  SetAudioChannelSuspended(nsISuspendedTypes::SUSPENDED_BLOCK);
}

void
HTMLMediaElement::SetAudioChannelSuspended(SuspendTypes aSuspend)
{
  if (mAudioChannelSuspended == aSuspend) {
    return;
  }

  MaybeNotifyMediaResumed(aSuspend);
  mAudioChannelSuspended = aSuspend;
  MOZ_LOG(AudioChannelService::GetAudioChannelLog(), LogLevel::Debug,
         ("HTMLMediaElement, SetAudioChannelSuspended, this = %p, "
          "aSuspend = %d\n", this, aSuspend));

  NotifyAudioPlaybackChanged(
    AudioChannelService::AudibleChangedReasons::ePauseStateChanged);
}

bool
HTMLMediaElement::IsSuspendedByAudioChannel() const
{
  return (mAudioChannelSuspended == nsISuspendedTypes::SUSPENDED_PAUSE ||
          mAudioChannelSuspended == nsISuspendedTypes::SUSPENDED_PAUSE_DISPOSABLE ||
          mAudioChannelSuspended == nsISuspendedTypes::SUSPENDED_BLOCK);
}

bool
HTMLMediaElement::IsAllowedToPlay()
{
  // Prevent media element from being auto-started by a script when
  // media.autoplay.enabled=false
  if (!mHasUserInteraction &&
      !IsAutoplayEnabled() &&
      !EventStateManager::IsHandlingUserInput()) {
#if defined(MOZ_WIDGET_ANDROID)
    nsContentUtils::DispatchTrustedEvent(OwnerDoc(),
                                         static_cast<nsIContent*>(this),
                                         NS_LITERAL_STRING("MozAutoplayMediaBlocked"),
                                         false,
                                         false);
#endif
    return false;
  }

  return IsAllowedToPlayByAudioChannel();
}

bool
HTMLMediaElement::IsAllowedToPlayByAudioChannel()
{
  // The media element has already been paused or blocked, so it can't start
  // playback again by script or user's intend until resuming by audio channel.
  if (mAudioChannelSuspended == nsISuspendedTypes::SUSPENDED_PAUSE ||
      mAudioChannelSuspended == nsISuspendedTypes::SUSPENDED_BLOCK) {
    return false;
  }

  // If the tab hasn't been activated yet, the media element in that tab can't
  // be playback now until the tab goes to foreground first time or user clicks
  // the unblocking tab icon.
  if (MaybeCreateAudioChannelAgent() && !IsTabActivated()) {
    // Even we haven't start playing yet, we still need to notify the audio
    // channe system because we need to receive the resume notification later.
    UpdateAudioChannelPlayingState(true /* force to start */);
    return false;
  }

  return true;
}

bool
HTMLMediaElement::IsTabActivated() const
{
  MOZ_ASSERT(mAudioChannelAgent);
  return !mAudioChannelAgent->ShouldBlockMedia();
}

static const char* VisibilityString(Visibility aVisibility) {
  switch(aVisibility) {
    case Visibility::UNTRACKED: {
      return "UNTRACKED";
    }
    case Visibility::APPROXIMATELY_NONVISIBLE: {
      return "APPROXIMATELY_NONVISIBLE";
    }
    case Visibility::APPROXIMATELY_VISIBLE: {
      return "APPROXIMATELY_VISIBLE";
    }
  }

  return "NAN";
}

void
HTMLMediaElement::OnVisibilityChange(Visibility aNewVisibility)
{
  LOG(LogLevel::Debug, ("OnVisibilityChange(): %s\n",
      VisibilityString(aNewVisibility)));

  mVisibilityState = aNewVisibility;

  if (!mDecoder) {
    return;
  }

  switch (aNewVisibility) {
    case Visibility::UNTRACKED: {
        MOZ_ASSERT_UNREACHABLE("Shouldn't notify for untracked visibility");
        break;
    }
    case Visibility::APPROXIMATELY_NONVISIBLE: {
      if (mPlayTime.IsStarted()) {
        // Not visible, play time is running -> Start hidden play time if needed.
        HiddenVideoStart();
      }

      mDecoder->NotifyOwnerActivityChanged(false);
      break;
    }
    case Visibility::APPROXIMATELY_VISIBLE: {
      // Visible -> Just pause hidden play time (no-op if already paused).
      HiddenVideoStop();

      mDecoder->NotifyOwnerActivityChanged(true);
      break;
    }
  }

}

MediaKeys*
HTMLMediaElement::GetMediaKeys() const
{
  return mMediaKeys;
}

bool
HTMLMediaElement::ContainsRestrictedContent()
{
  return GetMediaKeys() != nullptr;
}

already_AddRefed<Promise>
HTMLMediaElement::SetMediaKeys(mozilla::dom::MediaKeys* aMediaKeys,
                               ErrorResult& aRv)
{
  LOG(LogLevel::Debug, ("%p SetMediaKeys(%p) mMediaKeys=%p mDecoder=%p",
    this, aMediaKeys, mMediaKeys.get(), mDecoder.get()));

  if (MozAudioCaptured()) {
    aRv.Throw(NS_ERROR_DOM_NOT_SUPPORTED_ERR);
    return nullptr;
  }

  nsCOMPtr<nsIGlobalObject> global =
    do_QueryInterface(OwnerDoc()->GetInnerWindow());
  if (!global) {
    aRv.Throw(NS_ERROR_UNEXPECTED);
    return nullptr;
  }
  RefPtr<DetailedPromise> promise = DetailedPromise::Create(global, aRv,
    NS_LITERAL_CSTRING("HTMLMediaElement.setMediaKeys"));
  if (aRv.Failed()) {
    return nullptr;
  }

  // 1. If mediaKeys and the mediaKeys attribute are the same object,
  // return a resolved promise.
  if (mMediaKeys == aMediaKeys) {
    promise->MaybeResolveWithUndefined();
    return promise.forget();
  }

  // Note: Our attaching code is synchronous, so we can skip the following steps.

  // 2. If this object's attaching media keys value is true, return a
  // promise rejected with a new DOMException whose name is InvalidStateError.
  // 3. Let this object's attaching media keys value be true.
  // 4. Let promise be a new promise.
  // 5. Run the following steps in parallel:

  // 5.1 If mediaKeys is not null, CDM instance represented by mediaKeys is
  // already in use by another media element, and the user agent is unable
  // to use it with this element, let this object's attaching media keys
  // value be false and reject promise with a new DOMException whose name
  // is QuotaExceededError.
  if (aMediaKeys && aMediaKeys->IsBoundToMediaElement()) {
    promise->MaybeReject(NS_ERROR_DOM_QUOTA_EXCEEDED_ERR,
      NS_LITERAL_CSTRING("MediaKeys object is already bound to another HTMLMediaElement"));
    return promise.forget();
  }

  // 5.2 If the mediaKeys attribute is not null, run the following steps:
  if (mMediaKeys) {
    // 5.2.1 If the user agent or CDM do not support removing the association,
    // let this object's attaching media keys value be false and reject promise
    // with a new DOMException whose name is NotSupportedError.

    // 5.2.2 If the association cannot currently be removed, let this object's
    // attaching media keys value be false and reject promise with a new
    // DOMException whose name is InvalidStateError.
    if (mDecoder) {
      // We don't support swapping out the MediaKeys once we've started to
      // setup the playback pipeline. Note this also means we don't need to worry
      // about handling disassociating the MediaKeys from the MediaDecoder.
      promise->MaybeReject(NS_ERROR_DOM_INVALID_STATE_ERR,
        NS_LITERAL_CSTRING("Can't change MediaKeys on HTMLMediaElement after load has started"));
      return promise.forget();
    }

    // 5.2.3 Stop using the CDM instance represented by the mediaKeys attribute
    // to decrypt media data and remove the association with the media element.
    mMediaKeys->Unbind();
    mMediaKeys = nullptr;

    // 5.2.4 If the preceding step failed, let this object's attaching media
    // keys value be false and reject promise with a new DOMException whose
    // name is the appropriate error name.
  }

  // 5.3. If mediaKeys is not null, run the following steps:
  if (aMediaKeys) {
    if (!aMediaKeys->GetCDMProxy()) {
      promise->MaybeReject(NS_ERROR_DOM_INVALID_STATE_ERR,
        NS_LITERAL_CSTRING("CDM crashed before binding MediaKeys object to HTMLMediaElement"));
      return promise.forget();
    }

    // 5.3.1 Associate the CDM instance represented by mediaKeys with the
    // media element for decrypting media data.
    if (NS_FAILED(aMediaKeys->Bind(this))) {
      // 5.3.2 If the preceding step failed, run the following steps:
      // 5.3.2.1 Set the mediaKeys attribute to null.
      mMediaKeys = nullptr;
      // 5.3.2.2 Let this object's attaching media keys value be false.
      // 5.3.2.3 Reject promise with a new DOMException whose name is
      // the appropriate error name.
      promise->MaybeReject(NS_ERROR_DOM_INVALID_STATE_ERR,
                           NS_LITERAL_CSTRING("Failed to bind MediaKeys object to HTMLMediaElement"));
      return promise.forget();
    }
    // 5.3.3 Queue a task to run the "Attempt to Resume Playback If Necessary"
    // algorithm on the media element.
    // Note: Setting the CDMProxy on the MediaDecoder will unblock playback.
    if (mDecoder) {
      mDecoder->SetCDMProxy(aMediaKeys->GetCDMProxy());
    }
  }

  // 5.4 Set the mediaKeys attribute to mediaKeys.
  mMediaKeys = aMediaKeys;

  // 5.5 Let this object's attaching media keys value be false.

  // 5.6 Resolve promise.
  promise->MaybeResolveWithUndefined();

  // 6. Return promise.
  return promise.forget();
}

EventHandlerNonNull*
HTMLMediaElement::GetOnencrypted()
{
  return EventTarget::GetEventHandler(nsGkAtoms::onencrypted, EmptyString());
}

void
HTMLMediaElement::SetOnencrypted(EventHandlerNonNull* aCallback)
{
  EventTarget::SetEventHandler(nsGkAtoms::onencrypted, EmptyString(), aCallback);
}

EventHandlerNonNull*
HTMLMediaElement::GetOnwaitingforkey()
{
  return EventTarget::GetEventHandler(nsGkAtoms::onwaitingforkey, EmptyString());
}

void
HTMLMediaElement::SetOnwaitingforkey(EventHandlerNonNull* aCallback)
{
  EventTarget::SetEventHandler(nsGkAtoms::onwaitingforkey, EmptyString(), aCallback);
}

void
HTMLMediaElement::DispatchEncrypted(const nsTArray<uint8_t>& aInitData,
                                    const nsAString& aInitDataType)
{
  LOG(LogLevel::Debug,
      ("%p DispatchEncrypted initDataType='%s'",
      this, NS_ConvertUTF16toUTF8(aInitDataType).get()));

  if (mReadyState == nsIDOMHTMLMediaElement::HAVE_NOTHING) {
    // Ready state not HAVE_METADATA (yet), don't dispatch encrypted now.
    // Queueing for later dispatch in MetadataLoaded.
    mPendingEncryptedInitData.AddInitData(aInitDataType, aInitData);
    return;
  }

  RefPtr<MediaEncryptedEvent> event;
  if (IsCORSSameOrigin()) {
    event = MediaEncryptedEvent::Constructor(this, aInitDataType, aInitData);
  } else {
    event = MediaEncryptedEvent::Constructor(this);
  }

  RefPtr<AsyncEventDispatcher> asyncDispatcher =
    new AsyncEventDispatcher(this, event);
  asyncDispatcher->PostDOMEvent();
}

bool
HTMLMediaElement::IsEventAttributeName(nsIAtom* aName)
{
  return aName == nsGkAtoms::onencrypted ||
         nsGenericHTMLElement::IsEventAttributeName(aName);
}

already_AddRefed<nsIPrincipal>
HTMLMediaElement::GetTopLevelPrincipal()
{
  RefPtr<nsIPrincipal> principal;
  nsCOMPtr<nsPIDOMWindowInner> window = OwnerDoc()->GetInnerWindow();
  if (!window) {
    return nullptr;
  }
  // XXXkhuey better hope we always have an outer ...
  nsCOMPtr<nsPIDOMWindowOuter> top = window->GetOuterWindow()->GetTop();
  if (!top) {
    return nullptr;
  }
  nsIDocument* doc = top->GetExtantDoc();
  if (!doc) {
    return nullptr;
  }
  principal = doc->NodePrincipal();
  return principal.forget();
}

void
HTMLMediaElement::CannotDecryptWaitingForKey()
{
  LOG(LogLevel::Debug, ("%p, CannotDecryptWaitingForKey()", this));

  // http://w3c.github.io/encrypted-media/#wait-for-key
  // 7.3.4 Queue a "waitingforkey" Event
  // 1. Let the media element be the specified HTMLMediaElement object.
  // 2. If the media element's waiting for key value is true, abort these steps.
  if (mWaitingForKey == NOT_WAITING_FOR_KEY) {
    // 3. Set the media element's waiting for key value to true.
    // Note: algorithm continues in UpdateReadyStateInternal() when all decoded
    // data enqueued in the MDSM is consumed.
    mWaitingForKey = WAITING_FOR_KEY;
    UpdateReadyStateInternal();
  }
}

NS_IMETHODIMP HTMLMediaElement::WindowAudioCaptureChanged(bool aCapture)
{
  MOZ_ASSERT(mAudioChannelAgent);

  if (mAudioCapturedByWindow != aCapture) {
    mAudioCapturedByWindow = aCapture;
    AudioCaptureStreamChangeIfNeeded();
  }
  return NS_OK;
}

AudioTrackList*
HTMLMediaElement::AudioTracks()
{
  if (!mAudioTrackList) {
    nsCOMPtr<nsPIDOMWindowInner> window = do_QueryInterface(OwnerDoc()->GetParentObject());
    mAudioTrackList = new AudioTrackList(window, this);
  }
  return mAudioTrackList;
}

VideoTrackList*
HTMLMediaElement::VideoTracks()
{
  if (!mVideoTrackList) {
    nsCOMPtr<nsPIDOMWindowInner> window = do_QueryInterface(OwnerDoc()->GetParentObject());
    mVideoTrackList = new VideoTrackList(window, this);
  }
  return mVideoTrackList;
}

TextTrackList*
HTMLMediaElement::GetTextTracks()
{
  return GetOrCreateTextTrackManager()->GetTextTracks();
}

already_AddRefed<TextTrack>
HTMLMediaElement::AddTextTrack(TextTrackKind aKind,
                               const nsAString& aLabel,
                               const nsAString& aLanguage)
{
  return
    GetOrCreateTextTrackManager()->AddTextTrack(aKind, aLabel, aLanguage,
                                                TextTrackMode::Hidden,
                                                TextTrackReadyState::Loaded,
                                                TextTrackSource::AddTextTrack);
}

void
HTMLMediaElement::PopulatePendingTextTrackList()
{
  if (mTextTrackManager) {
    mTextTrackManager->PopulatePendingList();
  }
}

TextTrackManager*
HTMLMediaElement::GetOrCreateTextTrackManager()
{
  if (!mTextTrackManager) {
    mTextTrackManager = new TextTrackManager(this);
    mTextTrackManager->AddListeners();
  }
  return mTextTrackManager;
}

void
HTMLMediaElement::SetMozAudioChannelType(AudioChannel aValue, ErrorResult& aRv)
{
  nsString channel;
  channel.AssignASCII(AudioChannelValues::strings[uint32_t(aValue)].value,
                      AudioChannelValues::strings[uint32_t(aValue)].length);
  SetHTMLAttr(nsGkAtoms::mozaudiochannel, channel, aRv);
}

MediaDecoderOwner::NextFrameStatus
HTMLMediaElement::NextFrameStatus()
{
  if (mDecoder) {
    return mDecoder->NextFrameStatus();
  } else if (mMediaStreamListener) {
    return mMediaStreamListener->NextFrameStatus();
  }
  return NEXT_FRAME_UNINITIALIZED;
}

float
HTMLMediaElement::ComputedVolume() const
{
  return mMuted ? 0.0f : float(mVolume * mAudioChannelVolume);
}

bool
HTMLMediaElement::ComputedMuted() const
{
  return (mMuted & MUTED_BY_AUDIO_CHANNEL);
}

nsSuspendedTypes
HTMLMediaElement::ComputedSuspended() const
{
  return mAudioChannelSuspended;
}

bool
HTMLMediaElement::IsCurrentlyPlaying() const
{
  // We have playable data, but we still need to check whether data is "real"
  // current data.
  return mReadyState >= nsIDOMHTMLMediaElement::HAVE_CURRENT_DATA &&
         !IsPlaybackEnded();
}

void
HTMLMediaElement::SetAudibleState(bool aAudible)
{
  if (mIsAudioTrackAudible != aAudible) {
    mIsAudioTrackAudible = aAudible;
    NotifyAudioPlaybackChanged(
      AudioChannelService::AudibleChangedReasons::eDataAudibleChanged);
  }
}

void
HTMLMediaElement::NotifyAudioPlaybackChanged(AudibleChangedReasons aReason)
{
  if (mAudible == IsAudible()) {
    return;
  }

  mAudible = IsAudible();

  if (mAudioChannelAgent && mAudioChannelAgent->IsPlayingStarted()) {
    mAudioChannelAgent->NotifyStartedAudible(mAudible, aReason);
  }
}

AudibleState
HTMLMediaElement::IsAudible() const
{
  // Muted or the volume should not be ~0
  if (Muted() || (std::fabs(Volume()) <= 1e-7)) {
    return AudioChannelService::AudibleState::eNotAudible;
  }

  // No audio track.
  if (!HasAudio()) {
    return AudioChannelService::AudibleState::eNotAudible;
  }

  // Might be audible but not yet.
  if (HasAudio() && !mIsAudioTrackAudible) {
    return AudioChannelService::AudibleState::eMaybeAudible;
  }

  // Media is suspended.
  if (mAudioChannelSuspended != nsISuspendedTypes::NONE_SUSPENDED) {
    return AudioChannelService::AudibleState::eNotAudible;
  }

  return AudioChannelService::AudibleState::eAudible;
}

void
HTMLMediaElement::MaybeNotifyMediaResumed(SuspendTypes aSuspend)
{
  // In fennec, we should send the notification when media is resumed from the
  // pause-disposable which was called by media control.
  if (mAudioChannelSuspended != nsISuspendedTypes::SUSPENDED_PAUSE_DISPOSABLE &&
      aSuspend != nsISuspendedTypes::NONE_SUSPENDED) {
    return;
  }

  MOZ_ASSERT(mAudioChannelAgent);
  uint64_t windowID = mAudioChannelAgent->WindowID();
  NS_DispatchToMainThread(NS_NewRunnableFunction([windowID]() -> void {
    nsCOMPtr<nsIObserverService> observerService =
      services::GetObserverService();
    if (NS_WARN_IF(!observerService)) {
      return;
    }

    nsCOMPtr<nsISupportsPRUint64> wrapper =
      do_CreateInstance(NS_SUPPORTS_PRUINT64_CONTRACTID);
    if (NS_WARN_IF(!wrapper)) {
       return;
    }

    wrapper->SetData(windowID);
    observerService->NotifyObservers(wrapper,
                                     "media-playback-resumed",
                                     u"active");
  }));
}

bool
HTMLMediaElement::ShouldElementBePaused()
{
  // Bfcached page or inactive document.
  if (!IsActive()) {
    return true;
  }

  return false;
}

void
HTMLMediaElement::SetMediaInfo(const MediaInfo& aInfo)
{
  const bool oldHasAudio = mMediaInfo.HasAudio();
  mMediaInfo = aInfo;
  if (aInfo.HasAudio() != oldHasAudio) {
    NotifyAudioPlaybackChanged(
      AudioChannelService::AudibleChangedReasons::eDataAudibleChanged);
  }
  AudioCaptureStreamChangeIfNeeded();
}

void
HTMLMediaElement::AudioCaptureStreamChangeIfNeeded()
{
  // No need to capture a silence media element.
  if (!HasAudio()) {
    return;
  }

  if (MaybeCreateAudioChannelAgent() &&
      !mAudioChannelAgent->IsPlayingStarted()) {
    return;
  }

  if (mAudioCapturedByWindow && !mCaptureStreamPort) {
    nsCOMPtr<nsPIDOMWindowInner> window = OwnerDoc()->GetInnerWindow();
    if (!OwnerDoc()->GetInnerWindow()) {
      return;
    }

    uint64_t id = window->WindowID();
    MediaStreamGraph* msg =
      MediaStreamGraph::GetInstance(MediaStreamGraph::AUDIO_THREAD_DRIVER,
                                    mAudioChannel);

    if (GetSrcMediaStream()) {
      mCaptureStreamPort = msg->ConnectToCaptureStream(id, GetSrcMediaStream());
    } else {
      RefPtr<DOMMediaStream> stream =
        CaptureStreamInternal(false, false, msg);
      mCaptureStreamPort = msg->ConnectToCaptureStream(id, stream->GetPlaybackStream());
    }
  } else if (!mAudioCapturedByWindow && mCaptureStreamPort) {
    if (mDecoder) {
      ProcessedMediaStream* ps =
        mCaptureStreamPort->GetSource()->AsProcessedStream();
      MOZ_ASSERT(ps);

      for (uint32_t i = 0; i < mOutputStreams.Length(); i++) {
        if (mOutputStreams[i].mStream->GetPlaybackStream() == ps) {
          mOutputStreams.RemoveElementAt(i);
          break;
        }
      }
      mDecoder->RemoveOutputStream(ps);
    }
    mCaptureStreamPort->Destroy();
    mCaptureStreamPort = nullptr;
  }
}

void
HTMLMediaElement::NotifyCueDisplayStatesChanged()
{
  if (!mTextTrackManager) {
    return;
  }

  mTextTrackManager->DispatchUpdateCueDisplay();
}

void
HTMLMediaElement::MarkAsContentSource(CallerAPI aAPI)
{
  const bool isVisible = mVisibilityState != Visibility::APPROXIMATELY_NONVISIBLE;

  if (isVisible) {
    // 0 = ALL_VISIBLE
    Telemetry::Accumulate(Telemetry::VIDEO_AS_CONTENT_SOURCE, 0);
  } else {
    // 1 = ALL_INVISIBLE
    Telemetry::Accumulate(Telemetry::VIDEO_AS_CONTENT_SOURCE, 1);

    if (IsInUncomposedDoc()) {
      // 0 = ALL_IN_TREE
      Telemetry::Accumulate(Telemetry::VIDEO_AS_CONTENT_SOURCE_IN_TREE_OR_NOT, 0);
    } else {
      // 1 = ALL_NOT_IN_TREE
      Telemetry::Accumulate(Telemetry::VIDEO_AS_CONTENT_SOURCE_IN_TREE_OR_NOT, 1);
    }
  }

  switch (aAPI) {
    case CallerAPI::DRAW_IMAGE: {
      if (isVisible) {
        // 2 = drawImage_VISIBLE
        Telemetry::Accumulate(Telemetry::VIDEO_AS_CONTENT_SOURCE, 2);
      } else {
        // 3 = drawImage_INVISIBLE
        Telemetry::Accumulate(Telemetry::VIDEO_AS_CONTENT_SOURCE, 3);

        if (IsInUncomposedDoc()) {
          // 2 = drawImage_IN_TREE
          Telemetry::Accumulate(Telemetry::VIDEO_AS_CONTENT_SOURCE_IN_TREE_OR_NOT, 2);
        } else {
          // 3 = drawImage_NOT_IN_TREE
          Telemetry::Accumulate(Telemetry::VIDEO_AS_CONTENT_SOURCE_IN_TREE_OR_NOT, 3);
        }
      }
      break;
    }
    case CallerAPI::CREATE_PATTERN: {
      if (isVisible) {
        // 4 = createPattern_VISIBLE
        Telemetry::Accumulate(Telemetry::VIDEO_AS_CONTENT_SOURCE, 4);
      } else {
        // 5 = createPattern_INVISIBLE
        Telemetry::Accumulate(Telemetry::VIDEO_AS_CONTENT_SOURCE, 5);

        if (IsInUncomposedDoc()) {
          // 4 = createPattern_IN_TREE
          Telemetry::Accumulate(Telemetry::VIDEO_AS_CONTENT_SOURCE_IN_TREE_OR_NOT, 4);
        } else {
          // 5 = createPattern_NOT_IN_TREE
          Telemetry::Accumulate(Telemetry::VIDEO_AS_CONTENT_SOURCE_IN_TREE_OR_NOT, 5);
        }
      }
      break;
    }
    case CallerAPI::CREATE_IMAGEBITMAP: {
      if (isVisible) {
        // 6 = createImageBitmap_VISIBLE
        Telemetry::Accumulate(Telemetry::VIDEO_AS_CONTENT_SOURCE, 6);
      } else {
        // 7 = createImageBitmap_INVISIBLE
        Telemetry::Accumulate(Telemetry::VIDEO_AS_CONTENT_SOURCE, 7);

        if (IsInUncomposedDoc()) {
          // 6 = createImageBitmap_IN_TREE
          Telemetry::Accumulate(Telemetry::VIDEO_AS_CONTENT_SOURCE_IN_TREE_OR_NOT, 6);
        } else {
          // 7 = createImageBitmap_NOT_IN_TREE
          Telemetry::Accumulate(Telemetry::VIDEO_AS_CONTENT_SOURCE_IN_TREE_OR_NOT, 7);
        }
      }
      break;
    }
    case CallerAPI::CAPTURE_STREAM: {
      if (isVisible) {
        // 8 = captureStream_VISIBLE
        Telemetry::Accumulate(Telemetry::VIDEO_AS_CONTENT_SOURCE, 8);
      } else {
        // 9 = captureStream_INVISIBLE
        Telemetry::Accumulate(Telemetry::VIDEO_AS_CONTENT_SOURCE, 9);

        if (IsInUncomposedDoc()) {
          // 8 = captureStream_IN_TREE
          Telemetry::Accumulate(Telemetry::VIDEO_AS_CONTENT_SOURCE_IN_TREE_OR_NOT, 8);
        } else {
          // 9 = captureStream_NOT_IN_TREE
          Telemetry::Accumulate(Telemetry::VIDEO_AS_CONTENT_SOURCE_IN_TREE_OR_NOT, 9);
        }
      }
      break;
    }
  }

  LOG(LogLevel::Debug,
      ("%p Log VIDEO_AS_CONTENT_SOURCE: visibility = %u, API: '%d' and 'All'",
       this, isVisible, aAPI));

  if (!isVisible) {
    LOG(LogLevel::Debug,
        ("%p Log VIDEO_AS_CONTENT_SOURCE_IN_TREE_OR_NOT: inTree = %u, API: '%d' and 'All'",
         this, IsInUncomposedDoc(), aAPI));
  }
}

} // namespace dom
} // namespace mozilla
