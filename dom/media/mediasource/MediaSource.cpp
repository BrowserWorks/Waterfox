/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "MediaSource.h"

#include "AsyncEventRunner.h"
#include "DecoderTraits.h"
#include "Benchmark.h"
#include "DecoderDoctorDiagnostics.h"
#include "MediaContainerType.h"
#include "MediaResult.h"
#include "MediaSourceDemuxer.h"
#include "MediaSourceUtils.h"
#include "SourceBuffer.h"
#include "SourceBufferList.h"
#include "mozilla/ErrorResult.h"
#include "mozilla/FloatingPoint.h"
#include "mozilla/Preferences.h"
#include "mozilla/dom/BindingDeclarations.h"
#include "mozilla/dom/HTMLMediaElement.h"
#include "mozilla/mozalloc.h"
#include "nsDebug.h"
#include "nsError.h"
#include "nsIRunnable.h"
#include "nsIScriptObjectPrincipal.h"
#include "nsPIDOMWindow.h"
#include "nsString.h"
#include "nsThreadUtils.h"
#include "mozilla/Logging.h"
#include "nsServiceManagerUtils.h"
#include "mozilla/gfx/gfxVars.h"
#include "mozilla/Sprintf.h"

#ifdef MOZ_WIDGET_ANDROID
#include "AndroidBridge.h"
#endif

struct JSContext;
class JSObject;

mozilla::LogModule* GetMediaSourceLog()
{
  static mozilla::LazyLogModule sLogModule("MediaSource");
  return sLogModule;
}

mozilla::LogModule* GetMediaSourceAPILog()
{
  static mozilla::LazyLogModule sLogModule("MediaSource");
  return sLogModule;
}

#define MSE_DEBUG(arg, ...) MOZ_LOG(GetMediaSourceLog(), mozilla::LogLevel::Debug, ("MediaSource(%p)::%s: " arg, this, __func__, ##__VA_ARGS__))
#define MSE_API(arg, ...) MOZ_LOG(GetMediaSourceAPILog(), mozilla::LogLevel::Debug, ("MediaSource(%p)::%s: " arg, this, __func__, ##__VA_ARGS__))

// Arbitrary limit.
static const unsigned int MAX_SOURCE_BUFFERS = 16;

namespace mozilla {

// Returns true if we should enable MSE webm regardless of preferences.
// 1. If MP4/H264 isn't supported:
//   * Windows XP
//   * Windows Vista and Server 2008 without the optional "Platform Update Supplement"
//   * N/KN editions (Europe and Korea) of Windows 7/8/8.1/10 without the
//     optional "Windows Media Feature Pack"
// 2. If H264 hardware acceleration is not available.
// 3. The CPU is considered to be fast enough
static bool
IsWebMForced(DecoderDoctorDiagnostics* aDiagnostics)
{
  bool mp4supported =
    DecoderTraits::IsMP4SupportedType(MediaContainerType(MEDIAMIMETYPE("video/mp4")),
                                      aDiagnostics);
  bool hwsupported = gfx::gfxVars::CanUseHardwareVideoDecoding();
#ifdef MOZ_WIDGET_ANDROID
  return !mp4supported || !hwsupported || VP9Benchmark::IsVP9DecodeFast() ||
         java::HardwareCodecCapabilityUtils::HasHWVP9();
#else
  return !mp4supported || !hwsupported || VP9Benchmark::IsVP9DecodeFast();
#endif
}

namespace dom {

/* static */
nsresult
MediaSource::IsTypeSupported(const nsAString& aType, DecoderDoctorDiagnostics* aDiagnostics)
{
  if (aType.IsEmpty()) {
    return NS_ERROR_DOM_TYPE_ERR;
  }

  Maybe<MediaContainerType> containerType = MakeMediaContainerType(aType);
  if (!containerType) {
    return NS_ERROR_DOM_NOT_SUPPORTED_ERR;
  }

  if (DecoderTraits::CanHandleContainerType(*containerType, aDiagnostics)
      == CANPLAY_NO) {
    return NS_ERROR_DOM_NOT_SUPPORTED_ERR;
  }

  // Now we know that this media type could be played.
  // MediaSource imposes extra restrictions, and some prefs.
  const MediaMIMEType& mimeType = containerType->Type();
  if (mimeType == MEDIAMIMETYPE("video/mp4") ||
      mimeType == MEDIAMIMETYPE("audio/mp4")) {
    if (!Preferences::GetBool("media.mediasource.mp4.enabled", false)) {
      return NS_ERROR_DOM_NOT_SUPPORTED_ERR;
    }
    return NS_OK;
  }
  if (mimeType == MEDIAMIMETYPE("video/webm")) {
    if (!(Preferences::GetBool("media.mediasource.webm.enabled", false) ||
          containerType->ExtendedType().Codecs().Contains(
            NS_LITERAL_STRING("vp8")) ||
          IsWebMForced(aDiagnostics))) {
      return NS_ERROR_DOM_NOT_SUPPORTED_ERR;
    }
    return NS_OK;
  }
  if (mimeType == MEDIAMIMETYPE("audio/webm")) {
    if (!(Preferences::GetBool("media.mediasource.webm.enabled", false) ||
          Preferences::GetBool("media.mediasource.webm.audio.enabled", true))) {
      return NS_ERROR_DOM_NOT_SUPPORTED_ERR;
    }
    return NS_OK;
  }

  return NS_ERROR_DOM_NOT_SUPPORTED_ERR;
}

/* static */ already_AddRefed<MediaSource>
MediaSource::Constructor(const GlobalObject& aGlobal,
                         ErrorResult& aRv)
{
  nsCOMPtr<nsPIDOMWindowInner> window = do_QueryInterface(aGlobal.GetAsSupports());
  if (!window) {
    aRv.Throw(NS_ERROR_UNEXPECTED);
    return nullptr;
  }

  RefPtr<MediaSource> mediaSource = new MediaSource(window);
  return mediaSource.forget();
}

MediaSource::~MediaSource()
{
  MOZ_ASSERT(NS_IsMainThread());
  MSE_API("");
  if (mDecoder) {
    mDecoder->DetachMediaSource();
  }
}

SourceBufferList*
MediaSource::SourceBuffers()
{
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT_IF(mReadyState == MediaSourceReadyState::Closed, mSourceBuffers->IsEmpty());
  return mSourceBuffers;
}

SourceBufferList*
MediaSource::ActiveSourceBuffers()
{
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT_IF(mReadyState == MediaSourceReadyState::Closed, mActiveSourceBuffers->IsEmpty());
  return mActiveSourceBuffers;
}

MediaSourceReadyState
MediaSource::ReadyState()
{
  MOZ_ASSERT(NS_IsMainThread());
  return mReadyState;
}

double
MediaSource::Duration()
{
  MOZ_ASSERT(NS_IsMainThread());
  if (mReadyState == MediaSourceReadyState::Closed) {
    return UnspecifiedNaN<double>();
  }
  MOZ_ASSERT(mDecoder);
  return mDecoder->GetDuration();
}

void
MediaSource::SetDuration(double aDuration, ErrorResult& aRv)
{
  MOZ_ASSERT(NS_IsMainThread());
  MSE_API("SetDuration(aDuration=%f, ErrorResult)", aDuration);
  if (aDuration < 0 || IsNaN(aDuration)) {
    aRv.Throw(NS_ERROR_DOM_TYPE_ERR);
    return;
  }
  if (mReadyState != MediaSourceReadyState::Open ||
      mSourceBuffers->AnyUpdating()) {
    aRv.Throw(NS_ERROR_DOM_INVALID_STATE_ERR);
    return;
  }
  DurationChange(aDuration, aRv);
}

void
MediaSource::SetDuration(double aDuration)
{
  MOZ_ASSERT(NS_IsMainThread());
  MSE_API("SetDuration(aDuration=%f)", aDuration);
  mDecoder->SetMediaSourceDuration(aDuration);
}

already_AddRefed<SourceBuffer>
MediaSource::AddSourceBuffer(const nsAString& aType, ErrorResult& aRv)
{
  MOZ_ASSERT(NS_IsMainThread());
  DecoderDoctorDiagnostics diagnostics;
  nsresult rv = IsTypeSupported(aType, &diagnostics);
  diagnostics.StoreFormatDiagnostics(GetOwner()
                                     ? GetOwner()->GetExtantDoc()
                                     : nullptr,
                                     aType, NS_SUCCEEDED(rv), __func__);
  MSE_API("AddSourceBuffer(aType=%s)%s",
          NS_ConvertUTF16toUTF8(aType).get(),
          rv == NS_OK ? "" : " [not supported]");
  if (NS_FAILED(rv)) {
    aRv.Throw(rv);
    return nullptr;
  }
  if (mSourceBuffers->Length() >= MAX_SOURCE_BUFFERS) {
    aRv.Throw(NS_ERROR_DOM_QUOTA_EXCEEDED_ERR);
    return nullptr;
  }
  if (mReadyState != MediaSourceReadyState::Open) {
    aRv.Throw(NS_ERROR_DOM_INVALID_STATE_ERR);
    return nullptr;
  }
  Maybe<MediaContainerType> containerType = MakeMediaContainerType(aType);
  if (!containerType) {
    aRv.Throw(NS_ERROR_DOM_NOT_SUPPORTED_ERR);
    return nullptr;
  }
  RefPtr<SourceBuffer> sourceBuffer = new SourceBuffer(this, *containerType);
  if (!sourceBuffer) {
    aRv.Throw(NS_ERROR_FAILURE); // XXX need a better error here
    return nullptr;
  }
  mSourceBuffers->Append(sourceBuffer);
  MSE_DEBUG("sourceBuffer=%p", sourceBuffer.get());
  return sourceBuffer.forget();
}

RefPtr<MediaSource::ActiveCompletionPromise>
MediaSource::SourceBufferIsActive(SourceBuffer* aSourceBuffer)
{
  MOZ_ASSERT(NS_IsMainThread());
  mActiveSourceBuffers->ClearSimple();
  bool initMissing = false;
  bool found = false;
  for (uint32_t i = 0; i < mSourceBuffers->Length(); i++) {
    SourceBuffer* sourceBuffer = mSourceBuffers->IndexedGetter(i, found);
    MOZ_ALWAYS_TRUE(found);
    if (sourceBuffer == aSourceBuffer) {
      mActiveSourceBuffers->Append(aSourceBuffer);
    } else if (sourceBuffer->IsActive()) {
      mActiveSourceBuffers->AppendSimple(sourceBuffer);
    } else {
      // Some source buffers haven't yet received an init segment.
      // There's nothing more we can do at this stage.
      initMissing = true;
    }
  }
  if (initMissing || !mDecoder) {
    return ActiveCompletionPromise::CreateAndResolve(true, __func__);
  }

  mDecoder->NotifyInitDataArrived();

  // Add our promise to the queue.
  // It will be resolved once the HTMLMediaElement modifies its readyState.
  MozPromiseHolder<ActiveCompletionPromise> holder;
  RefPtr<ActiveCompletionPromise> promise = holder.Ensure(__func__);
  mCompletionPromises.AppendElement(Move(holder));
  return promise;
}

void
MediaSource::CompletePendingTransactions()
{
  MOZ_ASSERT(NS_IsMainThread());
  MSE_DEBUG("Resolving %u promises", unsigned(mCompletionPromises.Length()));
  for (auto& promise : mCompletionPromises) {
    promise.Resolve(true, __func__);
  }
  mCompletionPromises.Clear();
}

void
MediaSource::RemoveSourceBuffer(SourceBuffer& aSourceBuffer, ErrorResult& aRv)
{
  MOZ_ASSERT(NS_IsMainThread());
  SourceBuffer* sourceBuffer = &aSourceBuffer;
  MSE_API("RemoveSourceBuffer(aSourceBuffer=%p)", sourceBuffer);
  if (!mSourceBuffers->Contains(sourceBuffer)) {
    aRv.Throw(NS_ERROR_DOM_NOT_FOUND_ERR);
    return;
  }

  sourceBuffer->AbortBufferAppend();
  // TODO:
  // abort stream append loop (if running)

  // TODO:
  // For all sourceBuffer audioTracks, videoTracks, textTracks:
  //     set sourceBuffer to null
  //     remove sourceBuffer video, audio, text Tracks from MediaElement tracks
  //     remove sourceBuffer video, audio, text Tracks and fire "removetrack" at affected lists
  //     fire "removetrack" at modified MediaElement track lists
  // If removed enabled/selected, fire "change" at affected MediaElement list.
  if (mActiveSourceBuffers->Contains(sourceBuffer)) {
    mActiveSourceBuffers->Remove(sourceBuffer);
  }
  mSourceBuffers->Remove(sourceBuffer);
  // TODO: Free all resources associated with sourceBuffer
}

void
MediaSource::EndOfStream(const Optional<MediaSourceEndOfStreamError>& aError, ErrorResult& aRv)
{
  MOZ_ASSERT(NS_IsMainThread());
  MSE_API("EndOfStream(aError=%d)",
          aError.WasPassed() ? uint32_t(aError.Value()) : 0);
  if (mReadyState != MediaSourceReadyState::Open ||
      mSourceBuffers->AnyUpdating()) {
    aRv.Throw(NS_ERROR_DOM_INVALID_STATE_ERR);
    return;
  }

  SetReadyState(MediaSourceReadyState::Ended);
  mSourceBuffers->Ended();
  if (!aError.WasPassed()) {
    DurationChange(mSourceBuffers->GetHighestBufferedEndTime(), aRv);
    // Notify reader that all data is now available.
    mDecoder->Ended(true);
    return;
  }
  switch (aError.Value()) {
  case MediaSourceEndOfStreamError::Network:
    mDecoder->NetworkError();
    break;
  case MediaSourceEndOfStreamError::Decode:
    mDecoder->DecodeError(NS_ERROR_DOM_MEDIA_FATAL_ERR);
    break;
  default:
    aRv.Throw(NS_ERROR_DOM_TYPE_ERR);
  }
}

void
MediaSource::EndOfStream(const MediaResult& aError)
{
  MOZ_ASSERT(NS_IsMainThread());
  MSE_API("EndOfStream(aError=%" PRId32")", static_cast<uint32_t>(aError.Code()));

  SetReadyState(MediaSourceReadyState::Ended);
  mSourceBuffers->Ended();
  mDecoder->DecodeError(aError);
}

/* static */ bool
MediaSource::IsTypeSupported(const GlobalObject& aOwner, const nsAString& aType)
{
  MOZ_ASSERT(NS_IsMainThread());
  DecoderDoctorDiagnostics diagnostics;
  nsresult rv = IsTypeSupported(aType, &diagnostics);
  nsCOMPtr<nsPIDOMWindowInner> window = do_QueryInterface(aOwner.GetAsSupports());
  diagnostics.StoreFormatDiagnostics(window ? window->GetExtantDoc() : nullptr,
                                     aType, NS_SUCCEEDED(rv), __func__);
#define this nullptr
  MSE_API("IsTypeSupported(aType=%s)%s ",
          NS_ConvertUTF16toUTF8(aType).get(), rv == NS_OK ? "OK" : "[not supported]");
#undef this // don't ever remove this line !
  return NS_SUCCEEDED(rv);
}

/* static */ bool
MediaSource::Enabled(JSContext* cx, JSObject* aGlobal)
{
  return Preferences::GetBool("media.mediasource.enabled");
}

void
MediaSource::SetLiveSeekableRange(double aStart, double aEnd, ErrorResult& aRv)
{
  MOZ_ASSERT(NS_IsMainThread());

  // 1. If the readyState attribute is not "open" then throw an InvalidStateError
  // exception and abort these steps.
  if (mReadyState != MediaSourceReadyState::Open) {
    aRv.Throw(NS_ERROR_DOM_INVALID_STATE_ERR);
    return;
  }

  // 2. If start is negative or greater than end, then throw a TypeError
  // exception and abort these steps.
  if (aStart < 0 || aStart > aEnd) {
    aRv.Throw(NS_ERROR_DOM_TYPE_ERR);
    return;
  }

  // 3. Set live seekable range to be a new normalized TimeRanges object
  // containing a single range whose start position is start and end position is
  // end.
  mLiveSeekableRange =
    Some(media::TimeInterval(media::TimeUnit::FromSeconds(aStart),
                             media::TimeUnit::FromSeconds(aEnd)));
}

void
MediaSource::ClearLiveSeekableRange(ErrorResult& aRv)
{
  MOZ_ASSERT(NS_IsMainThread());

  // 1. If the readyState attribute is not "open" then throw an InvalidStateError
  // exception and abort these steps.
  if (mReadyState != MediaSourceReadyState::Open) {
    aRv.Throw(NS_ERROR_DOM_INVALID_STATE_ERR);
    return;
  }

  // 2. If live seekable range contains a range, then set live seekable range to
  // be a new empty TimeRanges object.
  mLiveSeekableRange.reset();
}

bool
MediaSource::Attach(MediaSourceDecoder* aDecoder)
{
  MOZ_ASSERT(NS_IsMainThread());
  MSE_DEBUG("Attach(aDecoder=%p) owner=%p", aDecoder, aDecoder->GetOwner());
  MOZ_ASSERT(aDecoder);
  MOZ_ASSERT(aDecoder->GetOwner());
  if (mReadyState != MediaSourceReadyState::Closed) {
    return false;
  }
  MOZ_ASSERT(!mMediaElement);
  mMediaElement = aDecoder->GetOwner()->GetMediaElement();
  MOZ_ASSERT(!mDecoder);
  mDecoder = aDecoder;
  mDecoder->AttachMediaSource(this);
  SetReadyState(MediaSourceReadyState::Open);
  return true;
}

void
MediaSource::Detach()
{
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_RELEASE_ASSERT(mCompletionPromises.IsEmpty());
  MSE_DEBUG("mDecoder=%p owner=%p",
            mDecoder.get(), mDecoder ? mDecoder->GetOwner() : nullptr);
  if (!mDecoder) {
    MOZ_ASSERT(mReadyState == MediaSourceReadyState::Closed);
    MOZ_ASSERT(mActiveSourceBuffers->IsEmpty() && mSourceBuffers->IsEmpty());
    return;
  }
  mMediaElement = nullptr;
  SetReadyState(MediaSourceReadyState::Closed);
  if (mActiveSourceBuffers) {
    mActiveSourceBuffers->Clear();
  }
  if (mSourceBuffers) {
    mSourceBuffers->Clear();
  }
  mDecoder->DetachMediaSource();
  mDecoder = nullptr;
}

MediaSource::MediaSource(nsPIDOMWindowInner* aWindow)
  : DOMEventTargetHelper(aWindow)
  , mDecoder(nullptr)
  , mPrincipal(nullptr)
  , mAbstractMainThread(GetOwnerGlobal()->AbstractMainThreadFor(TaskCategory::Other))
  , mReadyState(MediaSourceReadyState::Closed)
{
  MOZ_ASSERT(NS_IsMainThread());
  mSourceBuffers = new SourceBufferList(this);
  mActiveSourceBuffers = new SourceBufferList(this);

  nsCOMPtr<nsIScriptObjectPrincipal> sop = do_QueryInterface(aWindow);
  if (sop) {
    mPrincipal = sop->GetPrincipal();
  }

  MSE_API("MediaSource(aWindow=%p) mSourceBuffers=%p mActiveSourceBuffers=%p",
          aWindow, mSourceBuffers.get(), mActiveSourceBuffers.get());
}

void
MediaSource::SetReadyState(MediaSourceReadyState aState)
{
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(aState != mReadyState);
  MSE_DEBUG("SetReadyState(aState=%" PRIu32 ") mReadyState=%" PRIu32,
            static_cast<uint32_t>(aState), static_cast<uint32_t>(mReadyState));

  MediaSourceReadyState oldState = mReadyState;
  mReadyState = aState;

  if (mReadyState == MediaSourceReadyState::Open &&
      (oldState == MediaSourceReadyState::Closed ||
       oldState == MediaSourceReadyState::Ended)) {
    QueueAsyncSimpleEvent("sourceopen");
    if (oldState == MediaSourceReadyState::Ended) {
      // Notify reader that more data may come.
      mDecoder->Ended(false);
    }
    return;
  }

  if (mReadyState == MediaSourceReadyState::Ended &&
      oldState == MediaSourceReadyState::Open) {
    QueueAsyncSimpleEvent("sourceended");
    return;
  }

  if (mReadyState == MediaSourceReadyState::Closed &&
      (oldState == MediaSourceReadyState::Open ||
       oldState == MediaSourceReadyState::Ended)) {
    QueueAsyncSimpleEvent("sourceclose");
    return;
  }

  NS_WARNING("Invalid MediaSource readyState transition");
}

void
MediaSource::DispatchSimpleEvent(const char* aName)
{
  MOZ_ASSERT(NS_IsMainThread());
  MSE_API("Dispatch event '%s'", aName);
  DispatchTrustedEvent(NS_ConvertUTF8toUTF16(aName));
}

void
MediaSource::QueueAsyncSimpleEvent(const char* aName)
{
  MSE_DEBUG("Queuing event '%s'", aName);
  nsCOMPtr<nsIRunnable> event = new AsyncEventRunner<MediaSource>(this, aName);
  mAbstractMainThread->Dispatch(event.forget());
}

void
MediaSource::DurationChange(double aNewDuration, ErrorResult& aRv)
{
  MOZ_ASSERT(NS_IsMainThread());
  MSE_DEBUG("DurationChange(aNewDuration=%f)", aNewDuration);

  // 1. If the current value of duration is equal to new duration, then return.
  if (mDecoder->GetDuration() == aNewDuration) {
    return;
  }

  // 2. If new duration is less than the highest starting presentation timestamp
  // of any buffered coded frames for all SourceBuffer objects in sourceBuffers,
  // then throw an InvalidStateError exception and abort these steps.
  if (aNewDuration < mSourceBuffers->HighestStartTime()) {
    aRv.Throw(NS_ERROR_DOM_INVALID_STATE_ERR);
    return;
  }

  // 3. Let highest end time be the largest track buffer ranges end time across
  // all the track buffers across all SourceBuffer objects in sourceBuffers.
  double highestEndTime = mSourceBuffers->HighestEndTime();
  // 4. If new duration is less than highest end time, then
  //    4.1 Update new duration to equal highest end time.
  aNewDuration =
    std::max(aNewDuration, highestEndTime);

  // 5. Update the media duration to new duration and run the HTMLMediaElement
  // duration change algorithm.
  mDecoder->SetMediaSourceDuration(aNewDuration);
}

void
MediaSource::GetMozDebugReaderData(nsAString& aString)
{
  nsAutoCString result;
  mDecoder->GetMozDebugReaderData(result);
  aString = NS_ConvertUTF8toUTF16(result);
}

nsPIDOMWindowInner*
MediaSource::GetParentObject() const
{
  return GetOwner();
}

JSObject*
MediaSource::WrapObject(JSContext* aCx, JS::Handle<JSObject*> aGivenProto)
{
  return MediaSourceBinding::Wrap(aCx, this, aGivenProto);
}

NS_IMPL_CYCLE_COLLECTION_INHERITED(MediaSource, DOMEventTargetHelper,
                                   mMediaElement,
                                   mSourceBuffers, mActiveSourceBuffers)

NS_IMPL_ADDREF_INHERITED(MediaSource, DOMEventTargetHelper)
NS_IMPL_RELEASE_INHERITED(MediaSource, DOMEventTargetHelper)

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION_INHERITED(MediaSource)
  NS_INTERFACE_MAP_ENTRY(mozilla::dom::MediaSource)
NS_INTERFACE_MAP_END_INHERITING(DOMEventTargetHelper)

#undef MSE_DEBUG
#undef MSE_API

} // namespace dom

} // namespace mozilla
