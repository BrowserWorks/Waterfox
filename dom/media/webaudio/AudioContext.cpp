/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim:set ts=2 sw=2 sts=2 et cindent: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "AudioContext.h"

#include "blink/PeriodicWave.h"

#include "mozilla/ErrorResult.h"
#include "mozilla/OwningNonNull.h"

#include "mozilla/dom/AnalyserNode.h"
#include "mozilla/dom/AudioContextBinding.h"
#include "mozilla/dom/HTMLMediaElement.h"
#include "mozilla/dom/OfflineAudioContextBinding.h"
#include "mozilla/dom/Promise.h"

#include "AudioBuffer.h"
#include "AudioBufferSourceNode.h"
#include "AudioChannelService.h"
#include "AudioDestinationNode.h"
#include "AudioListener.h"
#include "AudioStream.h"
#include "BiquadFilterNode.h"
#include "ChannelMergerNode.h"
#include "ChannelSplitterNode.h"
#include "ConstantSourceNode.h"
#include "ConvolverNode.h"
#include "DelayNode.h"
#include "DynamicsCompressorNode.h"
#include "GainNode.h"
#include "IIRFilterNode.h"
#include "MediaElementAudioSourceNode.h"
#include "MediaStreamAudioDestinationNode.h"
#include "MediaStreamAudioSourceNode.h"
#include "MediaStreamGraph.h"
#include "nsContentUtils.h"
#include "nsNetCID.h"
#include "nsNetUtil.h"
#include "nsPIDOMWindow.h"
#include "nsPrintfCString.h"
#include "OscillatorNode.h"
#include "PannerNode.h"
#include "PeriodicWave.h"
#include "ScriptProcessorNode.h"
#include "StereoPannerNode.h"
#include "WaveShaperNode.h"

namespace mozilla {
namespace dom {

// 0 is a special value that MediaStreams use to denote they are not part of a
// AudioContext.
static dom::AudioContext::AudioContextId gAudioContextId = 1;

NS_IMPL_CYCLE_COLLECTION_CLASS(AudioContext)

NS_IMPL_CYCLE_COLLECTION_UNLINK_BEGIN(AudioContext)
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mDestination)
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mListener)
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mPromiseGripArray)
  if (!tmp->mIsStarted) {
    NS_IMPL_CYCLE_COLLECTION_UNLINK(mActiveNodes)
  }
  // mDecodeJobs owns the WebAudioDecodeJob objects whose lifetime is managed explicitly.
  // mAllNodes is an array of weak pointers, ignore it here.
  // mPannerNodes is an array of weak pointers, ignore it here.
  // mBasicWaveFormCache cannot participate in cycles, ignore it here.

  // Remove weak reference on the global window as the context is not usable
  // without mDestination.
  tmp->DisconnectFromWindow();
NS_IMPL_CYCLE_COLLECTION_UNLINK_END_INHERITED(DOMEventTargetHelper)

NS_IMPL_CYCLE_COLLECTION_TRAVERSE_BEGIN_INHERITED(AudioContext,
                                                  DOMEventTargetHelper)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mDestination)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mListener)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mPromiseGripArray)
  if (!tmp->mIsStarted) {
    MOZ_ASSERT(tmp->mIsOffline,
               "Online AudioContexts should always be started");
    NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mActiveNodes)
  }
  // mDecodeJobs owns the WebAudioDecodeJob objects whose lifetime is managed explicitly.
  // mAllNodes is an array of weak pointers, ignore it here.
  // mPannerNodes is an array of weak pointers, ignore it here.
  // mBasicWaveFormCache cannot participate in cycles, ignore it here.
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_END

NS_IMPL_ADDREF_INHERITED(AudioContext, DOMEventTargetHelper)
NS_IMPL_RELEASE_INHERITED(AudioContext, DOMEventTargetHelper)

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION_INHERITED(AudioContext)
  NS_INTERFACE_MAP_ENTRY(nsIMemoryReporter)
NS_INTERFACE_MAP_END_INHERITING(DOMEventTargetHelper)

static float GetSampleRateForAudioContext(bool aIsOffline, float aSampleRate)
{
  if (aIsOffline) {
    return aSampleRate;
  } else {
    return static_cast<float>(CubebUtils::PreferredSampleRate());
  }
}

AudioContext::AudioContext(nsPIDOMWindowInner* aWindow,
                           bool aIsOffline,
                           AudioChannel aChannel,
                           uint32_t aNumberOfChannels,
                           uint32_t aLength,
                           float aSampleRate)
  : DOMEventTargetHelper(aWindow)
  , mId(gAudioContextId++)
  , mSampleRate(GetSampleRateForAudioContext(aIsOffline, aSampleRate))
  , mAudioContextState(AudioContextState::Suspended)
  , mNumberOfChannels(aNumberOfChannels)
  , mIsOffline(aIsOffline)
  , mIsStarted(!aIsOffline)
  , mIsShutDown(false)
  , mCloseCalled(false)
  , mSuspendCalled(false)
{
  bool mute = aWindow->AddAudioContext(this);

  // Note: AudioDestinationNode needs an AudioContext that must already be
  // bound to the window.
  mDestination = new AudioDestinationNode(this, aIsOffline, aChannel,
                                          aNumberOfChannels, aLength, aSampleRate);

  // The context can't be muted until it has a destination.
  if (mute) {
    Mute();
  }
}

nsresult
AudioContext::Init()
{
  if (!mIsOffline) {
    nsresult rv = mDestination->CreateAudioChannelAgent();
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return rv;
    }
  }

  return NS_OK;
}

void
AudioContext::DisconnectFromWindow()
{
  nsPIDOMWindowInner* window = GetOwner();
  if (window) {
    window->RemoveAudioContext(this);
  }
}

AudioContext::~AudioContext()
{
  DisconnectFromWindow();
  UnregisterWeakMemoryReporter(this);
}

JSObject*
AudioContext::WrapObject(JSContext* aCx, JS::Handle<JSObject*> aGivenProto)
{
  if (mIsOffline) {
    return OfflineAudioContextBinding::Wrap(aCx, this, aGivenProto);
  } else {
    return AudioContextBinding::Wrap(aCx, this, aGivenProto);
  }
}

/* static */ already_AddRefed<AudioContext>
AudioContext::Constructor(const GlobalObject& aGlobal,
                          ErrorResult& aRv)
{
  return AudioContext::Constructor(aGlobal,
                                   AudioChannelService::GetDefaultAudioChannel(),
                                   aRv);
}

/* static */ already_AddRefed<AudioContext>
AudioContext::Constructor(const GlobalObject& aGlobal,
                          AudioChannel aChannel,
                          ErrorResult& aRv)
{
  nsCOMPtr<nsPIDOMWindowInner> window = do_QueryInterface(aGlobal.GetAsSupports());
  if (!window) {
    aRv.Throw(NS_ERROR_FAILURE);
    return nullptr;
  }

  RefPtr<AudioContext> object = new AudioContext(window, false, aChannel);
  aRv = object->Init();
  if (NS_WARN_IF(aRv.Failed())) {
     return nullptr;
  }

  RegisterWeakMemoryReporter(object);

  return object.forget();
}

/* static */ already_AddRefed<AudioContext>
AudioContext::Constructor(const GlobalObject& aGlobal,
                          uint32_t aNumberOfChannels,
                          uint32_t aLength,
                          float aSampleRate,
                          ErrorResult& aRv)
{
  nsCOMPtr<nsPIDOMWindowInner> window = do_QueryInterface(aGlobal.GetAsSupports());
  if (!window) {
    aRv.Throw(NS_ERROR_FAILURE);
    return nullptr;
  }

  if (aNumberOfChannels == 0 ||
      aNumberOfChannels > WebAudioUtils::MaxChannelCount ||
      aLength == 0 ||
      aSampleRate < WebAudioUtils::MinSampleRate ||
      aSampleRate > WebAudioUtils::MaxSampleRate) {
    // The DOM binding protects us against infinity and NaN
    aRv.Throw(NS_ERROR_DOM_NOT_SUPPORTED_ERR);
    return nullptr;
  }

  RefPtr<AudioContext> object = new AudioContext(window,
                                                   true,
                                                   AudioChannel::Normal,
                                                   aNumberOfChannels,
                                                   aLength,
                                                   aSampleRate);

  RegisterWeakMemoryReporter(object);

  return object.forget();
}

bool AudioContext::CheckClosed(ErrorResult& aRv)
{
  if (mAudioContextState == AudioContextState::Closed) {
    aRv.Throw(NS_ERROR_DOM_INVALID_STATE_ERR);
    return true;
  }
  return false;
}

already_AddRefed<AudioBufferSourceNode>
AudioContext::CreateBufferSource(ErrorResult& aRv)
{
  if (CheckClosed(aRv)) {
    return nullptr;
  }

  RefPtr<AudioBufferSourceNode> bufferNode =
    new AudioBufferSourceNode(this);
  return bufferNode.forget();
}

already_AddRefed<ConstantSourceNode>
AudioContext::CreateConstantSource(ErrorResult& aRv)
{
  if (CheckClosed(aRv)) {
    return nullptr;
  }

  RefPtr<ConstantSourceNode> constantSourceNode =
    new ConstantSourceNode(this);
  return constantSourceNode.forget();
}

already_AddRefed<AudioBuffer>
AudioContext::CreateBuffer(uint32_t aNumberOfChannels, uint32_t aLength,
                           float aSampleRate,
                           ErrorResult& aRv)
{
  if (!aNumberOfChannels) {
    aRv.Throw(NS_ERROR_DOM_INDEX_SIZE_ERR);
    return nullptr;
  }

  return AudioBuffer::Create(this, aNumberOfChannels, aLength,
                             aSampleRate, aRv);
}

namespace {

bool IsValidBufferSize(uint32_t aBufferSize) {
  switch (aBufferSize) {
  case 0:       // let the implementation choose the buffer size
  case 256:
  case 512:
  case 1024:
  case 2048:
  case 4096:
  case 8192:
  case 16384:
    return true;
  default:
    return false;
  }
}

} // namespace

already_AddRefed<MediaStreamAudioDestinationNode>
AudioContext::CreateMediaStreamDestination(ErrorResult& aRv)
{
  if (mIsOffline) {
    aRv.Throw(NS_ERROR_DOM_NOT_SUPPORTED_ERR);
    return nullptr;
  }

  if (CheckClosed(aRv)) {
    return nullptr;
  }

  RefPtr<MediaStreamAudioDestinationNode> node =
      new MediaStreamAudioDestinationNode(this);
  return node.forget();
}

already_AddRefed<ScriptProcessorNode>
AudioContext::CreateScriptProcessor(uint32_t aBufferSize,
                                    uint32_t aNumberOfInputChannels,
                                    uint32_t aNumberOfOutputChannels,
                                    ErrorResult& aRv)
{
  if ((aNumberOfInputChannels == 0 && aNumberOfOutputChannels == 0) ||
      aNumberOfInputChannels > WebAudioUtils::MaxChannelCount ||
      aNumberOfOutputChannels > WebAudioUtils::MaxChannelCount ||
      !IsValidBufferSize(aBufferSize)) {
    aRv.Throw(NS_ERROR_DOM_INDEX_SIZE_ERR);
    return nullptr;
  }

  if (CheckClosed(aRv)) {
    return nullptr;
  }

  RefPtr<ScriptProcessorNode> scriptProcessor =
    new ScriptProcessorNode(this, aBufferSize, aNumberOfInputChannels,
                            aNumberOfOutputChannels);
  return scriptProcessor.forget();
}

already_AddRefed<AnalyserNode>
AudioContext::CreateAnalyser(ErrorResult& aRv)
{
  if (CheckClosed(aRv)) {
    return nullptr;
  }

  RefPtr<AnalyserNode> analyserNode = new AnalyserNode(this);
  return analyserNode.forget();
}

already_AddRefed<StereoPannerNode>
AudioContext::CreateStereoPanner(ErrorResult& aRv)
{
  if (CheckClosed(aRv)) {
    return nullptr;
  }

  RefPtr<StereoPannerNode> stereoPannerNode = new StereoPannerNode(this);
  return stereoPannerNode.forget();
}

already_AddRefed<MediaElementAudioSourceNode>
AudioContext::CreateMediaElementSource(HTMLMediaElement& aMediaElement,
                                       ErrorResult& aRv)
{
  if (mIsOffline) {
    aRv.Throw(NS_ERROR_DOM_NOT_SUPPORTED_ERR);
    return nullptr;
  }

  if (aMediaElement.ContainsRestrictedContent()) {
    aRv.Throw(NS_ERROR_DOM_NOT_SUPPORTED_ERR);
    return nullptr;
  }

  if (CheckClosed(aRv)) {
    return nullptr;
  }

  RefPtr<DOMMediaStream> stream =
    aMediaElement.CaptureAudio(aRv, mDestination->Stream()->Graph());
  if (aRv.Failed()) {
    return nullptr;
  }
  return MediaElementAudioSourceNode::Create(this, stream, aRv);
}

already_AddRefed<MediaStreamAudioSourceNode>
AudioContext::CreateMediaStreamSource(DOMMediaStream& aMediaStream,
                                      ErrorResult& aRv)
{
  if (mIsOffline) {
    aRv.Throw(NS_ERROR_DOM_NOT_SUPPORTED_ERR);
    return nullptr;
  }

  if (CheckClosed(aRv)) {
    return nullptr;
  }

  return MediaStreamAudioSourceNode::Create(this, &aMediaStream, aRv);
}

already_AddRefed<GainNode>
AudioContext::CreateGain(ErrorResult& aRv)
{
  if (CheckClosed(aRv)) {
    return nullptr;
  }

  RefPtr<GainNode> gainNode = new GainNode(this);
  return gainNode.forget();
}

already_AddRefed<WaveShaperNode>
AudioContext::CreateWaveShaper(ErrorResult& aRv)
{
  if (CheckClosed(aRv)) {
    return nullptr;
  }

  RefPtr<WaveShaperNode> waveShaperNode = new WaveShaperNode(this);
  return waveShaperNode.forget();
}

already_AddRefed<DelayNode>
AudioContext::CreateDelay(double aMaxDelayTime, ErrorResult& aRv)
{
  if (CheckClosed(aRv)) {
    return nullptr;
  }

  if (aMaxDelayTime > 0. && aMaxDelayTime < 180.) {
    RefPtr<DelayNode> delayNode = new DelayNode(this, aMaxDelayTime);
    return delayNode.forget();
  }

  aRv.Throw(NS_ERROR_DOM_NOT_SUPPORTED_ERR);
  return nullptr;
}

already_AddRefed<PannerNode>
AudioContext::CreatePanner(ErrorResult& aRv)
{
  if (CheckClosed(aRv)) {
    return nullptr;
  }

  RefPtr<PannerNode> pannerNode = new PannerNode(this);
  mPannerNodes.PutEntry(pannerNode);
  return pannerNode.forget();
}

already_AddRefed<ConvolverNode>
AudioContext::CreateConvolver(ErrorResult& aRv)
{
  if (CheckClosed(aRv)) {
    return nullptr;
  }

  RefPtr<ConvolverNode> convolverNode = new ConvolverNode(this);
  return convolverNode.forget();
}

already_AddRefed<ChannelSplitterNode>
AudioContext::CreateChannelSplitter(uint32_t aNumberOfOutputs, ErrorResult& aRv)
{
  if (aNumberOfOutputs == 0 ||
      aNumberOfOutputs > WebAudioUtils::MaxChannelCount) {
    aRv.Throw(NS_ERROR_DOM_INDEX_SIZE_ERR);
    return nullptr;
  }

  if (CheckClosed(aRv)) {
    return nullptr;
  }

  RefPtr<ChannelSplitterNode> splitterNode =
    new ChannelSplitterNode(this, aNumberOfOutputs);
  return splitterNode.forget();
}

already_AddRefed<ChannelMergerNode>
AudioContext::CreateChannelMerger(uint32_t aNumberOfInputs, ErrorResult& aRv)
{
  if (aNumberOfInputs == 0 ||
      aNumberOfInputs > WebAudioUtils::MaxChannelCount) {
    aRv.Throw(NS_ERROR_DOM_INDEX_SIZE_ERR);
    return nullptr;
  }

  if (CheckClosed(aRv)) {
    return nullptr;
  }

  RefPtr<ChannelMergerNode> mergerNode =
    new ChannelMergerNode(this, aNumberOfInputs);
  return mergerNode.forget();
}

already_AddRefed<DynamicsCompressorNode>
AudioContext::CreateDynamicsCompressor(ErrorResult& aRv)
{
  if (CheckClosed(aRv)) {
    return nullptr;
  }

  RefPtr<DynamicsCompressorNode> compressorNode =
    new DynamicsCompressorNode(this);
  return compressorNode.forget();
}

already_AddRefed<BiquadFilterNode>
AudioContext::CreateBiquadFilter(ErrorResult& aRv)
{
  if (CheckClosed(aRv)) {
    return nullptr;
  }

  RefPtr<BiquadFilterNode> filterNode =
    new BiquadFilterNode(this);
  return filterNode.forget();
}

already_AddRefed<IIRFilterNode>
AudioContext::CreateIIRFilter(const mozilla::dom::binding_detail::AutoSequence<double>& aFeedforward,
                              const mozilla::dom::binding_detail::AutoSequence<double>& aFeedback,
                              mozilla::ErrorResult& aRv)
{
  if (CheckClosed(aRv)) {
    return nullptr;
  }

  if (aFeedforward.Length() == 0 || aFeedforward.Length() > 20) {
    aRv.Throw(NS_ERROR_DOM_NOT_SUPPORTED_ERR);
    return nullptr;
  }

  if (aFeedback.Length() == 0 || aFeedback.Length() > 20) {
    aRv.Throw(NS_ERROR_DOM_NOT_SUPPORTED_ERR);
    return nullptr;
  }

  bool feedforwardAllZeros = true;
  for (size_t i = 0; i < aFeedforward.Length(); ++i) {
    if (aFeedforward.Elements()[i] != 0.0) {
      feedforwardAllZeros = false;
    }
  }

  if (feedforwardAllZeros || aFeedback.Elements()[0] == 0.0) {
    aRv.Throw(NS_ERROR_DOM_INVALID_STATE_ERR);
    return nullptr;
  }

  RefPtr<IIRFilterNode> filterNode =
    new IIRFilterNode(this, aFeedforward, aFeedback);
  return filterNode.forget();
}

already_AddRefed<OscillatorNode>
AudioContext::CreateOscillator(ErrorResult& aRv)
{
  if (CheckClosed(aRv)) {
    return nullptr;
  }

  RefPtr<OscillatorNode> oscillatorNode =
    new OscillatorNode(this);
  return oscillatorNode.forget();
}

already_AddRefed<PeriodicWave>
AudioContext::CreatePeriodicWave(const Float32Array& aRealData,
                                 const Float32Array& aImagData,
                                 const PeriodicWaveConstraints& aConstraints,
                                 ErrorResult& aRv)
{
  aRealData.ComputeLengthAndData();
  aImagData.ComputeLengthAndData();

  if (aRealData.Length() != aImagData.Length() ||
      aRealData.Length() == 0) {
    aRv.Throw(NS_ERROR_DOM_NOT_SUPPORTED_ERR);
    return nullptr;
  }

  RefPtr<PeriodicWave> periodicWave =
    new PeriodicWave(this, aRealData.Data(), aImagData.Data(),
                     aImagData.Length(), aConstraints.mDisableNormalization,
                     aRv);
  if (aRv.Failed()) {
    return nullptr;
  }
  return periodicWave.forget();
}

AudioListener*
AudioContext::Listener()
{
  if (!mListener) {
    mListener = new AudioListener(this);
  }
  return mListener;
}

already_AddRefed<Promise>
AudioContext::DecodeAudioData(const ArrayBuffer& aBuffer,
                              const Optional<OwningNonNull<DecodeSuccessCallback> >& aSuccessCallback,
                              const Optional<OwningNonNull<DecodeErrorCallback> >& aFailureCallback,
                              ErrorResult& aRv)
{
  nsCOMPtr<nsIGlobalObject> parentObject = do_QueryInterface(GetParentObject());
  RefPtr<Promise> promise;
  AutoJSAPI jsapi;
  jsapi.Init();
  JSContext* cx = jsapi.cx();
  JSAutoCompartment ac(cx, aBuffer.Obj());

  promise = Promise::Create(parentObject, aRv);
  if (aRv.Failed()) {
    return nullptr;
  }

  aBuffer.ComputeLengthAndData();

  if (aBuffer.IsShared()) {
    // Throw if the object is mapping shared memory (must opt in).
    aRv.ThrowTypeError<MSG_TYPEDARRAY_IS_SHARED>(NS_LITERAL_STRING("Argument of AudioContext.decodeAudioData"));
    return nullptr;
  }

  // Detach the array buffer
  size_t length = aBuffer.Length();
  JS::RootedObject obj(cx, aBuffer.Obj());

  uint8_t* data = static_cast<uint8_t*>(JS_StealArrayBufferContents(cx, obj));

  // Sniff the content of the media.
  // Failed type sniffing will be handled by AsyncDecodeWebAudio.
  nsAutoCString contentType;
  NS_SniffContent(NS_DATA_SNIFFER_CATEGORY, nullptr, data, length, contentType);

  RefPtr<DecodeErrorCallback> failureCallback;
  RefPtr<DecodeSuccessCallback> successCallback;
  if (aFailureCallback.WasPassed()) {
    failureCallback = &aFailureCallback.Value();
  }
  if (aSuccessCallback.WasPassed()) {
    successCallback = &aSuccessCallback.Value();
  }
  RefPtr<WebAudioDecodeJob> job(
    new WebAudioDecodeJob(contentType, this,
                          promise, successCallback, failureCallback));
  AsyncDecodeWebAudio(contentType.get(), data, length, *job);
  // Transfer the ownership to mDecodeJobs
  mDecodeJobs.AppendElement(job.forget());

  return promise.forget();
}

void
AudioContext::RemoveFromDecodeQueue(WebAudioDecodeJob* aDecodeJob)
{
  mDecodeJobs.RemoveElement(aDecodeJob);
}

void
AudioContext::RegisterActiveNode(AudioNode* aNode)
{
  if (!mIsShutDown) {
    mActiveNodes.PutEntry(aNode);
  }
}

void
AudioContext::UnregisterActiveNode(AudioNode* aNode)
{
  mActiveNodes.RemoveEntry(aNode);
}

void
AudioContext::UnregisterAudioBufferSourceNode(AudioBufferSourceNode* aNode)
{
  UpdatePannerSource();
}

void
AudioContext::UnregisterPannerNode(PannerNode* aNode)
{
  mPannerNodes.RemoveEntry(aNode);
  if (mListener) {
    mListener->UnregisterPannerNode(aNode);
  }
}

void
AudioContext::UpdatePannerSource()
{
  for (auto iter = mPannerNodes.Iter(); !iter.Done(); iter.Next()) {
    iter.Get()->GetKey()->FindConnectedSources();
  }
}

uint32_t
AudioContext::MaxChannelCount() const
{
  return mIsOffline ? mNumberOfChannels : CubebUtils::MaxNumberOfChannels();
}

uint32_t
AudioContext::ActiveNodeCount() const
{
  return mActiveNodes.Count();
}

MediaStreamGraph*
AudioContext::Graph() const
{
  return Destination()->Stream()->Graph();
}

MediaStream*
AudioContext::DestinationStream() const
{
  if (Destination()) {
    return Destination()->Stream();
  }
  return nullptr;
}

double
AudioContext::CurrentTime() const
{
  MediaStream* stream = Destination()->Stream();
  return stream->StreamTimeToSeconds(stream->GetCurrentTime());
}

void
AudioContext::Shutdown()
{
  mIsShutDown = true;

  if (!mIsOffline) {
    ErrorResult dummy;
    RefPtr<Promise> ignored = Close(dummy);
  }

  for (auto p : mPromiseGripArray) {
    p->MaybeReject(NS_ERROR_DOM_INVALID_STATE_ERR);
  }

  mPromiseGripArray.Clear();

  // Release references to active nodes.
  // Active AudioNodes don't unregister in destructors, at which point the
  // Node is already unregistered.
  mActiveNodes.Clear();

  // For offline contexts, we can destroy the MediaStreamGraph at this point.
  if (mIsOffline && mDestination) {
    mDestination->OfflineShutdown();
  }
}

StateChangeTask::StateChangeTask(AudioContext* aAudioContext,
                                 void* aPromise,
                                 AudioContextState aNewState)
  : mAudioContext(aAudioContext)
  , mPromise(aPromise)
  , mAudioNodeStream(nullptr)
  , mNewState(aNewState)
{
  MOZ_ASSERT(NS_IsMainThread(),
             "This constructor should be used from the main thread.");
}

StateChangeTask::StateChangeTask(AudioNodeStream* aStream,
                                 void* aPromise,
                                 AudioContextState aNewState)
  : mAudioContext(nullptr)
  , mPromise(aPromise)
  , mAudioNodeStream(aStream)
  , mNewState(aNewState)
{
  MOZ_ASSERT(!NS_IsMainThread(),
             "This constructor should be used from the graph thread.");
}

NS_IMETHODIMP
StateChangeTask::Run()
{
  MOZ_ASSERT(NS_IsMainThread());

  if (!mAudioContext && !mAudioNodeStream) {
    return NS_OK;
  }
  if (mAudioNodeStream) {
    AudioNode* node = mAudioNodeStream->Engine()->NodeMainThread();
    if (!node) {
      return NS_OK;
    }
    mAudioContext = node->Context();
    if (!mAudioContext) {
      return NS_OK;
    }
  }

  mAudioContext->OnStateChanged(mPromise, mNewState);
  // We have can't call Release() on the AudioContext on the MSG thread, so we
  // unref it here, on the main thread.
  mAudioContext = nullptr;

  return NS_OK;
}

/* This runnable allows to fire the "statechange" event */
class OnStateChangeTask final : public Runnable
{
public:
  explicit OnStateChangeTask(AudioContext* aAudioContext)
    : mAudioContext(aAudioContext)
  {}

  NS_IMETHODIMP
  Run() override
  {
    nsPIDOMWindowInner* parent = mAudioContext->GetParentObject();
    if (!parent) {
      return NS_ERROR_FAILURE;
    }

    nsIDocument* doc = parent->GetExtantDoc();
    if (!doc) {
      return NS_ERROR_FAILURE;
    }

    return nsContentUtils::DispatchTrustedEvent(doc,
                                static_cast<DOMEventTargetHelper*>(mAudioContext),
                                NS_LITERAL_STRING("statechange"),
                                false, false);
  }

private:
  RefPtr<AudioContext> mAudioContext;
};

void
AudioContext::OnStateChanged(void* aPromise, AudioContextState aNewState)
{
  MOZ_ASSERT(NS_IsMainThread());

  // This can happen if close() was called right after creating the
  // AudioContext, before the context has switched to "running".
  if (mAudioContextState == AudioContextState::Closed &&
      aNewState == AudioContextState::Running &&
      !aPromise) {
    return;
  }

  // This can happen if this is called in reaction to a
  // MediaStreamGraph shutdown, and a AudioContext was being
  // suspended at the same time, for example if a page was being
  // closed.
  if (mAudioContextState == AudioContextState::Closed &&
      aNewState == AudioContextState::Suspended) {
    return;
  }

#ifndef WIN32 // Bug 1170547
#ifndef XP_MACOSX
#ifdef DEBUG

  if (!((mAudioContextState == AudioContextState::Suspended &&
       aNewState == AudioContextState::Running)   ||
      (mAudioContextState == AudioContextState::Running   &&
       aNewState == AudioContextState::Suspended) ||
      (mAudioContextState == AudioContextState::Running   &&
       aNewState == AudioContextState::Closed)    ||
      (mAudioContextState == AudioContextState::Suspended &&
       aNewState == AudioContextState::Closed)    ||
      (mAudioContextState == aNewState))) {
    fprintf(stderr,
            "Invalid transition: mAudioContextState: %d -> aNewState %d\n",
            static_cast<int>(mAudioContextState), static_cast<int>(aNewState));
    MOZ_ASSERT(false);
  }

#endif // DEBUG
#endif // XP_MACOSX
#endif // WIN32

  MOZ_ASSERT(
    mIsOffline || aPromise || aNewState == AudioContextState::Running,
    "We should have a promise here if this is a real-time AudioContext."
    "Or this is the first time we switch to \"running\".");

  if (aPromise) {
    Promise* promise = reinterpret_cast<Promise*>(aPromise);
    // It is possible for the promise to have been removed from
    // mPromiseGripArray if the cycle collector has severed our connections. DO
    // NOT dereference the promise pointer in that case since it may point to
    // already freed memory.
    if (mPromiseGripArray.Contains(promise)) {
      promise->MaybeResolveWithUndefined();
      DebugOnly<bool> rv = mPromiseGripArray.RemoveElement(promise);
      MOZ_ASSERT(rv, "Promise wasn't in the grip array?");
    }
  }

  if (mAudioContextState != aNewState) {
    RefPtr<OnStateChangeTask> onStateChangeTask =
      new OnStateChangeTask(this);
    NS_DispatchToMainThread(onStateChangeTask);
  }

  mAudioContextState = aNewState;
}

nsTArray<MediaStream*>
AudioContext::GetAllStreams() const
{
  nsTArray<MediaStream*> streams;
  for (auto iter = mAllNodes.ConstIter(); !iter.Done(); iter.Next()) {
    MediaStream* s = iter.Get()->GetKey()->GetStream();
    if (s) {
      streams.AppendElement(s);
    }
  }
  return streams;
}

already_AddRefed<Promise>
AudioContext::Suspend(ErrorResult& aRv)
{
  nsCOMPtr<nsIGlobalObject> parentObject = do_QueryInterface(GetParentObject());
  RefPtr<Promise> promise;
  promise = Promise::Create(parentObject, aRv);
  if (aRv.Failed()) {
    return nullptr;
  }
  if (mIsOffline) {
    promise->MaybeReject(NS_ERROR_DOM_NOT_SUPPORTED_ERR);
    return promise.forget();
  }

  if (mAudioContextState == AudioContextState::Closed ||
      mCloseCalled) {
    promise->MaybeReject(NS_ERROR_DOM_INVALID_STATE_ERR);
    return promise.forget();
  }

  Destination()->Suspend();

  mPromiseGripArray.AppendElement(promise);

  nsTArray<MediaStream*> streams;
  // If mSuspendCalled is true then we already suspended all our streams,
  // so don't suspend them again (since suspend(); suspend(); resume(); should
  // cancel both suspends). But we still need to do ApplyAudioContextOperation
  // to ensure our new promise is resolved.
  if (!mSuspendCalled) {
    streams = GetAllStreams();
  }
  Graph()->ApplyAudioContextOperation(DestinationStream()->AsAudioNodeStream(),
                                      streams,
                                      AudioContextOperation::Suspend, promise);

  mSuspendCalled = true;

  return promise.forget();
}

already_AddRefed<Promise>
AudioContext::Resume(ErrorResult& aRv)
{
  nsCOMPtr<nsIGlobalObject> parentObject = do_QueryInterface(GetParentObject());
  RefPtr<Promise> promise;
  promise = Promise::Create(parentObject, aRv);
  if (aRv.Failed()) {
    return nullptr;
  }

  if (mIsOffline) {
    promise->MaybeReject(NS_ERROR_DOM_NOT_SUPPORTED_ERR);
    return promise.forget();
  }

  if (mAudioContextState == AudioContextState::Closed ||
      mCloseCalled) {
    promise->MaybeReject(NS_ERROR_DOM_INVALID_STATE_ERR);
    return promise.forget();
  }

  Destination()->Resume();

  nsTArray<MediaStream*> streams;
  // If mSuspendCalled is false then we already resumed all our streams,
  // so don't resume them again (since suspend(); resume(); resume(); should
  // be OK). But we still need to do ApplyAudioContextOperation
  // to ensure our new promise is resolved.
  if (mSuspendCalled) {
    streams = GetAllStreams();
  }
  mPromiseGripArray.AppendElement(promise);
  Graph()->ApplyAudioContextOperation(DestinationStream()->AsAudioNodeStream(),
                                      streams,
                                      AudioContextOperation::Resume, promise);

  mSuspendCalled = false;

  return promise.forget();
}

already_AddRefed<Promise>
AudioContext::Close(ErrorResult& aRv)
{
  nsCOMPtr<nsIGlobalObject> parentObject = do_QueryInterface(GetParentObject());
  RefPtr<Promise> promise;
  promise = Promise::Create(parentObject, aRv);
  if (aRv.Failed()) {
    return nullptr;
  }

  if (mIsOffline) {
    promise->MaybeReject(NS_ERROR_DOM_NOT_SUPPORTED_ERR);
    return promise.forget();
  }

  if (mAudioContextState == AudioContextState::Closed) {
    promise->MaybeResolve(NS_ERROR_DOM_INVALID_STATE_ERR);
    return promise.forget();
  }

  if (Destination()) {
    Destination()->DestroyAudioChannelAgent();
  }

  mPromiseGripArray.AppendElement(promise);

  // This can be called when freeing a document, and the streams are dead at
  // this point, so we need extra null-checks.
  MediaStream* ds = DestinationStream();
  if (ds) {
    nsTArray<MediaStream*> streams;
    // If mSuspendCalled or mCloseCalled are true then we already suspended
    // all our streams, so don't suspend them again. But we still need to do
    // ApplyAudioContextOperation to ensure our new promise is resolved.
    if (!mSuspendCalled && !mCloseCalled) {
      streams = GetAllStreams();
    }
    Graph()->ApplyAudioContextOperation(ds->AsAudioNodeStream(), streams,
                                        AudioContextOperation::Close, promise);
  }
  mCloseCalled = true;

  return promise.forget();
}

void
AudioContext::RegisterNode(AudioNode* aNode)
{
  MOZ_ASSERT(!mAllNodes.Contains(aNode));
  mAllNodes.PutEntry(aNode);
}

void
AudioContext::UnregisterNode(AudioNode* aNode)
{
  MOZ_ASSERT(mAllNodes.Contains(aNode));
  mAllNodes.RemoveEntry(aNode);
}

JSObject*
AudioContext::GetGlobalJSObject() const
{
  nsCOMPtr<nsIGlobalObject> parentObject = do_QueryInterface(GetParentObject());
  if (!parentObject) {
    return nullptr;
  }

  // This can also return null.
  return parentObject->GetGlobalJSObject();
}

already_AddRefed<Promise>
AudioContext::StartRendering(ErrorResult& aRv)
{
  nsCOMPtr<nsIGlobalObject> parentObject = do_QueryInterface(GetParentObject());

  MOZ_ASSERT(mIsOffline, "This should only be called on OfflineAudioContext");
  if (mIsStarted) {
    aRv.Throw(NS_ERROR_DOM_INVALID_STATE_ERR);
    return nullptr;
  }

  mIsStarted = true;
  RefPtr<Promise> promise = Promise::Create(parentObject, aRv);
  if (aRv.Failed()) {
    return nullptr;
  }
  mDestination->StartRendering(promise);

  OnStateChanged(nullptr, AudioContextState::Running);

  return promise.forget();
}

unsigned long
AudioContext::Length()
{
  MOZ_ASSERT(mIsOffline);
  return mDestination->Length();
}

void
AudioContext::Mute() const
{
  MOZ_ASSERT(!mIsOffline);
  if (mDestination) {
    mDestination->Mute();
  }
}

void
AudioContext::Unmute() const
{
  MOZ_ASSERT(!mIsOffline);
  if (mDestination) {
    mDestination->Unmute();
  }
}

AudioChannel
AudioContext::MozAudioChannelType() const
{
  return mDestination->MozAudioChannelType();
}

AudioChannel
AudioContext::TestAudioChannelInAudioNodeStream()
{
  MediaStream* stream = mDestination->Stream();
  MOZ_ASSERT(stream);

  return stream->AudioChannelType();
}

size_t
AudioContext::SizeOfIncludingThis(mozilla::MallocSizeOf aMallocSizeOf) const
{
  // AudioNodes are tracked separately because we do not want the AudioContext
  // to track all of the AudioNodes it creates, so we wouldn't be able to
  // traverse them from here.

  size_t amount = aMallocSizeOf(this);
  if (mListener) {
    amount += mListener->SizeOfIncludingThis(aMallocSizeOf);
  }
  amount += mDecodeJobs.ShallowSizeOfExcludingThis(aMallocSizeOf);
  for (uint32_t i = 0; i < mDecodeJobs.Length(); ++i) {
    amount += mDecodeJobs[i]->SizeOfIncludingThis(aMallocSizeOf);
  }
  amount += mActiveNodes.ShallowSizeOfExcludingThis(aMallocSizeOf);
  amount += mPannerNodes.ShallowSizeOfExcludingThis(aMallocSizeOf);
  return amount;
}

NS_IMETHODIMP
AudioContext::CollectReports(nsIHandleReportCallback* aHandleReport,
                             nsISupports* aData, bool aAnonymize)
{
  const nsLiteralCString
    nodeDescription("Memory used by AudioNode DOM objects (Web Audio).");
  for (auto iter = mAllNodes.ConstIter(); !iter.Done(); iter.Next()) {
    AudioNode* node = iter.Get()->GetKey();
    int64_t amount = node->SizeOfIncludingThis(MallocSizeOf);
    nsPrintfCString domNodePath("explicit/webaudio/audio-node/%s/dom-nodes",
                                node->NodeType());
    aHandleReport->Callback(EmptyCString(), domNodePath, KIND_HEAP, UNITS_BYTES,
                            amount, nodeDescription, aData);
  }

  int64_t amount = SizeOfIncludingThis(MallocSizeOf);
  MOZ_COLLECT_REPORT(
    "explicit/webaudio/audiocontext", KIND_HEAP, UNITS_BYTES, amount,
    "Memory used by AudioContext objects (Web Audio).");

  return NS_OK;
}

BasicWaveFormCache*
AudioContext::GetBasicWaveFormCache()
{
  MOZ_ASSERT(NS_IsMainThread());
  if (!mBasicWaveFormCache) {
    mBasicWaveFormCache = new BasicWaveFormCache(SampleRate());
  }
  return mBasicWaveFormCache;
}

BasicWaveFormCache::BasicWaveFormCache(uint32_t aSampleRate)
  : mSampleRate(aSampleRate)
{
  MOZ_ASSERT(NS_IsMainThread());
}
BasicWaveFormCache::~BasicWaveFormCache()
{ }

WebCore::PeriodicWave*
BasicWaveFormCache::GetBasicWaveForm(OscillatorType aType)
{
  MOZ_ASSERT(!NS_IsMainThread());
  if (aType == OscillatorType::Sawtooth) {
    if (!mSawtooth) {
      mSawtooth = WebCore::PeriodicWave::createSawtooth(mSampleRate);
    }
    return mSawtooth;
  } else if (aType == OscillatorType::Square) {
    if (!mSquare) {
      mSquare = WebCore::PeriodicWave::createSquare(mSampleRate);
    }
    return mSquare;
  } else if (aType == OscillatorType::Triangle) {
    if (!mTriangle) {
      mTriangle = WebCore::PeriodicWave::createTriangle(mSampleRate);
    }
    return mTriangle;
  } else {
    MOZ_ASSERT(false, "Not reached");
    return nullptr;
  }
}

} // namespace dom
} // namespace mozilla
