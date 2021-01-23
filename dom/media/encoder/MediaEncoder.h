/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-*/
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef MediaEncoder_h_
#define MediaEncoder_h_

#include "ContainerWriter.h"
#include "CubebUtils.h"
#include "MediaQueue.h"
#include "MediaTrackGraph.h"
#include "MediaTrackListener.h"
#include "mozilla/DebugOnly.h"
#include "mozilla/MemoryReporting.h"
#include "mozilla/UniquePtr.h"
#include "nsIMemoryReporter.h"
#include "TrackEncoder.h"

namespace mozilla {

class DriftCompensator;
class Muxer;
class Runnable;
class TaskQueue;

namespace dom {
class AudioNode;
class AudioStreamTrack;
class MediaStreamTrack;
class VideoStreamTrack;
}  // namespace dom

class DriftCompensator;
class MediaEncoder;

class MediaEncoderListener {
 public:
  NS_INLINE_DECL_THREADSAFE_REFCOUNTING(MediaEncoderListener)
  virtual void Initialized() = 0;
  virtual void DataAvailable() = 0;
  virtual void Error() = 0;
  virtual void Shutdown() = 0;

 protected:
  virtual ~MediaEncoderListener() = default;
};

/**
 * MediaEncoder is the framework of encoding module, it controls and manages
 * procedures between ContainerWriter and TrackEncoder. ContainerWriter packs
 * the encoded track data with a specific container (e.g. ogg, webm).
 * AudioTrackEncoder and VideoTrackEncoder are subclasses of TrackEncoder, and
 * are responsible for encoding raw data coming from MediaTrackGraph.
 *
 * MediaEncoder solves threading issues by doing message passing to a TaskQueue
 * (the "encoder thread") as passed in to the constructor. Each
 * MediaStreamTrack to be recorded is set up with a MediaTrackListener.
 * Typically there are a non-direct track listeners for audio, direct listeners
 * for video, and there is always a non-direct listener on each track for
 * time-keeping. The listeners forward data to their corresponding TrackEncoders
 * on the encoder thread.
 *
 * The MediaEncoder listens to events from all TrackEncoders, and in turn
 * signals events to interested parties. Typically a MediaRecorder::Session.
 * The event that there's data available in the TrackEncoders is what typically
 * drives the extraction and muxing of data.
 *
 * MediaEncoder is designed to be a passive component, neither does it own or is
 * in charge of managing threads. Instead this is done by its owner.
 *
 * For example, usage from MediaRecorder of this component would be:
 * 1) Create an encoder with a valid MIME type.
 *    => encoder = MediaEncoder::CreateEncoder(aMIMEType);
 *    It then creates a ContainerWriter according to the MIME type
 *
 * 2) Connect a MediaEncoderListener to be notified when the MediaEncoder has
 *    been initialized and when there's data available.
 *    => encoder->RegisterListener(listener);
 *
 * 3) Connect the sources to be recorded. Either through:
 *    => encoder->ConnectAudioNode(node);
 *    or
 *    => encoder->ConnectMediaStreamTrack(track);
 *    These should not be mixed. When connecting MediaStreamTracks there is
 *    support for at most one of each kind.
 *
 * 4) When the MediaEncoderListener is notified that the MediaEncoder has
 *    data available, we can encode data. This also encodes metadata on its
 *    first invocation.
 *    => encoder->GetEncodedData(...);
 *
 * 5) To stop encoding, there are multiple options:
 *
 *    5.1) Stop() for a graceful stop.
 *         => encoder->Stop();
 *
 *    5.2) Cancel() for an immediate stop, if you don't need the data currently
 *         buffered.
 *         => encoder->Cancel();
 *
 *    5.3) When all input tracks end, the MediaEncoder will automatically stop
 *         and shut down.
 */
class MediaEncoder {
 private:
  class AudioTrackListener;
  class VideoTrackListener;
  class EncoderListener;

 public:
  NS_INLINE_DECL_THREADSAFE_REFCOUNTING(MediaEncoder)

  MediaEncoder(TaskQueue* aEncoderThread,
               RefPtr<DriftCompensator> aDriftCompensator,
               UniquePtr<ContainerWriter> aWriter,
               AudioTrackEncoder* aAudioEncoder,
               VideoTrackEncoder* aVideoEncoder, TrackRate aTrackRate,
               const nsAString& aMIMEType);

  /**
   * Called on main thread from MediaRecorder::Pause.
   */
  void Suspend();

  /**
   * Called on main thread from MediaRecorder::Resume.
   */
  void Resume();

  /**
   * Stops the current encoding, and disconnects the input tracks.
   */
  void Stop();

  /**
   * Connects an AudioNode with the appropriate encoder.
   */
  void ConnectAudioNode(dom::AudioNode* aNode, uint32_t aOutput);

  /**
   * Connects a MediaStreamTrack with the appropriate encoder.
   */
  void ConnectMediaStreamTrack(dom::MediaStreamTrack* aTrack);

  /**
   * Removes a connected MediaStreamTrack.
   */
  void RemoveMediaStreamTrack(dom::MediaStreamTrack* aTrack);

  /**
   * Creates an encoder with a given MIME type. Returns null if we are unable
   * to create the encoder. For now, default aMIMEType to "audio/ogg" and use
   * Ogg+Opus if it is empty.
   */
  static already_AddRefed<MediaEncoder> CreateEncoder(
      TaskQueue* aEncoderThread, const nsAString& aMIMEType,
      uint32_t aAudioBitrate, uint32_t aVideoBitrate, uint8_t aTrackTypes,
      TrackRate aTrackRate);

  /**
   * Encodes raw data for all tracks to aOutputBufs. The buffer of container
   * data is allocated in ContainerWriter::GetContainerData().
   *
   * On its first call, metadata is also encoded. TrackEncoders must have been
   * initialized before this is called.
   */
  nsresult GetEncodedData(nsTArray<nsTArray<uint8_t>>* aOutputBufs);

  /**
   * Asserts that Shutdown() has been called. Reasons are encoding
   * complete, encounter an error, or being canceled by its caller.
   */
  void AssertShutdownCalled() { MOZ_ASSERT(mShutdownPromise); }

  /**
   * Cancels the encoding and shuts down the encoder using Shutdown().
   */
  RefPtr<GenericNonExclusivePromise::AllPromiseType> Cancel();

  bool HasError();

  static bool IsWebMEncoderEnabled();

  const nsString& MimeType() const;

  /**
   * Notifies listeners that this MediaEncoder has been initialized.
   */
  void NotifyInitialized();

  /**
   * Notifies listeners that this MediaEncoder has data available in some
   * TrackEncoders.
   */
  void NotifyDataAvailable();

  /**
   * Registers a listener to events from this MediaEncoder.
   * We hold a strong reference to the listener.
   */
  void RegisterListener(MediaEncoderListener* aListener);

  /**
   * Unregisters a listener from events from this MediaEncoder.
   * The listener will stop receiving events synchronously.
   */
  bool UnregisterListener(MediaEncoderListener* aListener);

  MOZ_DEFINE_MALLOC_SIZE_OF(MallocSizeOf)
  /*
   * Measure the size of the buffer, and heap memory in bytes occupied by
   * mAudioEncoder and mVideoEncoder.
   */
  size_t SizeOfExcludingThis(mozilla::MallocSizeOf aMallocSizeOf);

  /**
   * Set desired video keyframe interval defined in milliseconds.
   */
  void SetVideoKeyFrameInterval(uint32_t aVideoKeyFrameInterval);

 protected:
  ~MediaEncoder();

 private:
  /**
   * Sets mGraphTrack if not already set, using a new stream from aTrack's
   * graph.
   */
  void EnsureGraphTrackFrom(MediaTrack* aTrack);

  /**
   * Takes a regular runnable and dispatches it to the graph wrapped in a
   * ControlMessage.
   */
  void RunOnGraph(already_AddRefed<Runnable> aRunnable);

  /**
   * Shuts down the MediaEncoder and cleans up track encoders.
   * Listeners will be notified of the shutdown unless we were Cancel()ed first.
   */
  RefPtr<GenericNonExclusivePromise::AllPromiseType> Shutdown();

  /**
   * Sets mError to true, notifies listeners of the error if mError changed,
   * and stops encoding.
   */
  void SetError();

  const RefPtr<TaskQueue> mEncoderThread;
  const RefPtr<DriftCompensator> mDriftCompensator;

  UniquePtr<Muxer> mMuxer;
  RefPtr<AudioTrackEncoder> mAudioEncoder;
  RefPtr<AudioTrackListener> mAudioListener;
  RefPtr<VideoTrackEncoder> mVideoEncoder;
  RefPtr<VideoTrackListener> mVideoListener;
  RefPtr<EncoderListener> mEncoderListener;
  nsTArray<RefPtr<MediaEncoderListener>> mListeners;

  // The AudioNode we are encoding.
  // Will be null when input is media stream or destination node.
  RefPtr<dom::AudioNode> mAudioNode;
  // Pipe-track for allowing a track listener on a non-destination AudioNode.
  // Will be null when input is media stream or destination node.
  RefPtr<AudioNodeTrack> mPipeTrack;
  // Input port that connect mAudioNode to mPipeTrack.
  // Will be null when input is media stream or destination node.
  RefPtr<MediaInputPort> mInputPort;
  // An audio track that we are encoding. Will be null if the input stream
  // doesn't contain audio on start() or if the input is an AudioNode.
  RefPtr<dom::AudioStreamTrack> mAudioTrack;
  // A video track that we are encoding. Will be null if the input stream
  // doesn't contain video on start() or if the input is an AudioNode.
  RefPtr<dom::VideoStreamTrack> mVideoTrack;

  // A stream to keep the MediaTrackGraph alive while we're recording.
  RefPtr<SharedDummyTrack> mGraphTrack;

  TimeStamp mStartTime;
  const nsString mMIMEType;
  bool mInitialized;
  bool mCompleted;
  bool mError;
  // Set when shutdown starts.
  RefPtr<GenericNonExclusivePromise::AllPromiseType> mShutdownPromise;
  // Get duration from create encoder, for logging purpose
  double GetEncodeTimeStamp() {
    TimeDuration decodeTime;
    decodeTime = TimeStamp::Now() - mStartTime;
    return decodeTime.ToMilliseconds();
  }
};

}  // namespace mozilla

#endif
