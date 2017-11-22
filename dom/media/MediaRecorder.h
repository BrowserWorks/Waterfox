/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim:set ts=2 sw=2 sts=2 et cindent: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef MediaRecorder_h
#define MediaRecorder_h

#include "mozilla/dom/MediaRecorderBinding.h"
#include "mozilla/DOMEventTargetHelper.h"
#include "mozilla/MemoryReporting.h"
#include "nsIDocumentActivity.h"

// Max size for allowing queue encoded data in memory
#define MAX_ALLOW_MEMORY_BUFFER 1024000
namespace mozilla {

class AbstractThread;
class AudioNodeStream;
class DOMMediaStream;
class ErrorResult;
class MediaInputPort;
struct MediaRecorderOptions;
class MediaStream;
class GlobalObject;

namespace dom {

class AudioNode;

/**
 * Implementation of https://dvcs.w3.org/hg/dap/raw-file/default/media-stream-capture/MediaRecorder.html
 * The MediaRecorder accepts a mediaStream as input source passed from UA. When recorder starts,
 * a MediaEncoder will be created and accept the mediaStream as input source.
 * Encoder will get the raw data by track data changes, encode it by selected MIME Type, then store the encoded in EncodedBufferCache object.
 * The encoded data will be extracted on every timeslice passed from Start function call or by RequestData function.
 * Thread model:
 * When the recorder starts, it creates a "Media Encoder" thread to read data from MediaEncoder object and store buffer in EncodedBufferCache object.
 * Also extract the encoded data and create blobs on every timeslice passed from start function or RequestData function called by UA.
 */

class MediaRecorder final : public DOMEventTargetHelper,
                            public nsIDocumentActivity
{
  class Session;

public:
  MediaRecorder(DOMMediaStream& aSourceMediaStream,
                nsPIDOMWindowInner* aOwnerWindow);
  MediaRecorder(AudioNode& aSrcAudioNode, uint32_t aSrcOutput,
                nsPIDOMWindowInner* aOwnerWindow);

  // nsWrapperCache
  JSObject* WrapObject(JSContext* aCx, JS::Handle<JSObject*> aGivenProto) override;

  nsPIDOMWindowInner* GetParentObject() { return GetOwner(); }

  NS_DECL_ISUPPORTS_INHERITED
  NS_DECL_CYCLE_COLLECTION_CLASS_INHERITED(MediaRecorder,
                                           DOMEventTargetHelper)

  // WebIDL
  // Start recording. If timeSlice has been provided, mediaRecorder will
  // raise a dataavailable event containing the Blob of collected data on every timeSlice milliseconds.
  // If timeSlice isn't provided, UA should call the RequestData to obtain the Blob data, also set the mTimeSlice to zero.
  void Start(const Optional<int32_t>& timeSlice, ErrorResult & aResult);
  // Stop the recording activiy. Including stop the Media Encoder thread, un-hook the mediaStreamListener to encoder.
  void Stop(ErrorResult& aResult);
  // Pause the mTrackUnionStream
  void Pause(ErrorResult& aResult);

  void Resume(ErrorResult& aResult);
  // Extract encoded data Blob from EncodedBufferCache.
  void RequestData(ErrorResult& aResult);
  // Return the The DOMMediaStream passed from UA.
  DOMMediaStream* Stream() const { return mDOMStream; }
  // The current state of the MediaRecorder object.
  RecordingState State() const { return mState; }
  // Return the current encoding MIME type selected by the MediaEncoder.
  void GetMimeType(nsString &aMimeType);

  static bool IsTypeSupported(GlobalObject& aGlobal, const nsAString& aType);
  static bool IsTypeSupported(const nsAString& aType);

  // Construct a recorder with a DOM media stream object as its source.
  static already_AddRefed<MediaRecorder>
  Constructor(const GlobalObject& aGlobal,
              DOMMediaStream& aStream,
              const MediaRecorderOptions& aInitDict,
              ErrorResult& aRv);
  // Construct a recorder with a Web Audio destination node as its source.
  static already_AddRefed<MediaRecorder>
  Constructor(const GlobalObject& aGlobal,
              AudioNode& aSrcAudioNode,
              uint32_t aSrcOutput,
              const MediaRecorderOptions& aInitDict,
              ErrorResult& aRv);

  /*
   * Measure the size of the buffer, and memory occupied by mAudioEncoder
   * and mVideoEncoder
   */
  size_t SizeOfExcludingThis(mozilla::MallocSizeOf aMallocSizeOf) const;
  // EventHandler
  IMPL_EVENT_HANDLER(dataavailable)
  IMPL_EVENT_HANDLER(error)
  IMPL_EVENT_HANDLER(start)
  IMPL_EVENT_HANDLER(stop)
  IMPL_EVENT_HANDLER(warning)

  NS_DECL_NSIDOCUMENTACTIVITY

  uint32_t GetAudioBitrate() { return mAudioBitsPerSecond; }
  uint32_t GetVideoBitrate() { return mVideoBitsPerSecond; }
  uint32_t GetBitrate() { return mBitsPerSecond; }
protected:
  virtual ~MediaRecorder();

  MediaRecorder& operator = (const MediaRecorder& x) = delete;
  // Create dataavailable event with Blob data and it runs in main thread
  nsresult CreateAndDispatchBlobEvent(already_AddRefed<nsIDOMBlob>&& aBlob);
  // Creating a simple event to notify UA simple event.
  void DispatchSimpleEvent(const nsAString & aStr);
  // Creating a error event with message.
  void NotifyError(nsresult aRv);
  // Set encoded MIME type.
  void SetMimeType(const nsString &aMimeType);
  void SetOptions(const MediaRecorderOptions& aInitDict);

  MediaRecorder(const MediaRecorder& x) = delete; // prevent bad usage
  // Remove session pointer.
  void RemoveSession(Session* aSession);
  // Functions for Session to query input source info.
  MediaStream* GetSourceMediaStream();
  // DOM wrapper for source media stream. Will be null when input is audio node.
  RefPtr<DOMMediaStream> mDOMStream;
  // Source audio node. Will be null when input is a media stream.
  RefPtr<AudioNode> mAudioNode;
  // Pipe stream connecting non-destination source node and session track union
  // stream of recorder. Will be null when input is media stream or destination
  // node.
  RefPtr<AudioNodeStream> mPipeStream;
  // Connect source node to the pipe stream.
  RefPtr<MediaInputPort> mInputPort;

  // The current state of the MediaRecorder object.
  RecordingState mState;
  // Hold the sessions reference and clean it when the DestroyRunnable for a
  // session is running.
  nsTArray<RefPtr<Session> > mSessions;

  nsCOMPtr<nsIDocument> mDocument;

  // It specifies the container format as well as the audio and video capture formats.
  nsString mMimeType;

  uint32_t mAudioBitsPerSecond;
  uint32_t mVideoBitsPerSecond;
  uint32_t mBitsPerSecond;

private:
  // Register MediaRecorder into Document to listen the activity changes.
  void RegisterActivityObserver();
  void UnRegisterActivityObserver();

  bool CheckPermission(const nsString &aType);
};

} // namespace dom
} // namespace mozilla

#endif
