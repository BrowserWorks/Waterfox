/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-*/
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef MediaEncoder_h_
#define MediaEncoder_h_

#include "mozilla/DebugOnly.h"
#include "TrackEncoder.h"
#include "ContainerWriter.h"
#include "CubebUtils.h"
#include "MediaStreamGraph.h"
#include "MediaStreamListener.h"
#include "nsAutoPtr.h"
#include "MediaStreamVideoSink.h"
#include "nsIMemoryReporter.h"
#include "mozilla/MemoryReporting.h"
#include "mozilla/Atomics.h"

namespace mozilla {

class MediaStreamVideoRecorderSink : public MediaStreamVideoSink
{
public:
  explicit MediaStreamVideoRecorderSink(VideoTrackEncoder* aEncoder)
    : mVideoEncoder(aEncoder) {}

  // MediaStreamVideoSink methods
  virtual void SetCurrentFrames(const VideoSegment& aSegment) override;
  virtual void ClearFrames() override {}

private:
  virtual ~MediaStreamVideoRecorderSink() {}
  VideoTrackEncoder* mVideoEncoder;
};

/**
 * MediaEncoder is the framework of encoding module, it controls and manages
 * procedures between ContainerWriter and TrackEncoder. ContainerWriter packs
 * the encoded track data with a specific container (e.g. ogg, mp4).
 * AudioTrackEncoder and VideoTrackEncoder are subclasses of TrackEncoder, and
 * are responsible for encoding raw data coming from MediaStreamGraph.
 *
 * Also, MediaEncoder is a type of MediaStreamListener, it starts to receive raw
 * segments after itself is added to the source stream. In the mean time,
 * encoded track data is pulled by its owner periodically on a worker thread. A
 * reentrant monitor is used to protect the push and pull of resource.
 *
 * MediaEncoder is designed to be a passive component, neither it owns nor in
 * charge of managing threads. However, a monitor is used in function
 * TrackEncoder::GetEncodedTrack() for the purpose of thread safety (e.g.
 * between callbacks of MediaStreamListener and others), a call to this function
 * might block. Therefore, MediaEncoder should not run on threads that forbid
 * blocking, such as main thread or I/O thread.
 *
 * For example, an usage from MediaRecorder of this component would be:
 * 1) Create an encoder with a valid MIME type.
 *    => encoder = MediaEncoder::CreateEncoder(aMIMEType);
 *    It then generate a ContainerWriter according to the MIME type, and an
 *    AudioTrackEncoder (or a VideoTrackEncoder too) associated with the media
 *    type.
 *
 * 2) Dispatch the task GetEncodedData() to a worker thread.
 *
 * 3) To start encoding, add this component to its source stream.
 *    => sourceStream->AddListener(encoder);
 *
 * 4) To stop encoding, remove this component from its source stream.
 *    => sourceStream->RemoveListener(encoder);
 */
class MediaEncoder : public DirectMediaStreamListener
{
  friend class MediaStreamVideoRecorderSink;
public :
  enum {
    ENCODE_METADDATA,
    ENCODE_TRACK,
    ENCODE_DONE,
    ENCODE_ERROR,
  };

  MediaEncoder(ContainerWriter* aWriter,
               AudioTrackEncoder* aAudioEncoder,
               VideoTrackEncoder* aVideoEncoder,
               const nsAString& aMIMEType,
               uint32_t aAudioBitrate,
               uint32_t aVideoBitrate,
               uint32_t aBitrate)
    : mWriter(aWriter)
    , mAudioEncoder(aAudioEncoder)
    , mVideoEncoder(aVideoEncoder)
    , mVideoSink(new MediaStreamVideoRecorderSink(mVideoEncoder))
    , mStartTime(TimeStamp::Now())
    , mMIMEType(aMIMEType)
    , mSizeOfBuffer(0)
    , mState(MediaEncoder::ENCODE_METADDATA)
    , mShutdown(false)
    , mDirectConnected(false)
    , mSuspended(false)
{}

  ~MediaEncoder() {};

  enum SuspendState {
    RECORD_NOT_SUSPENDED,
    RECORD_SUSPENDED,
    RECORD_RESUMED
  };

  /* Note - called from control code, not on MSG threads. */
  void Suspend()
  {
    mSuspended = RECORD_SUSPENDED;
  }

  /**
   * Note - called from control code, not on MSG threads.
   * Arm to collect the Duration of the next video frame and give it
   * to the next frame, in order to avoid any possible loss of sync. */
  void Resume()
  {
    if (mSuspended == RECORD_SUSPENDED) {
      mSuspended = RECORD_RESUMED;
    }
  }

  /**
   * Tells us which Notify to pay attention to for media
   */
  void SetDirectConnect(bool aConnected);

  /**
   * Notified by the AppendToTrack in MediaStreamGraph; aRealtimeMedia is the raw
   * track data in form of MediaSegment.
   */
  void NotifyRealtimeData(MediaStreamGraph* aGraph, TrackID aID,
                          StreamTime aTrackOffset,
                          uint32_t aTrackEvents,
                          const MediaSegment& aRealtimeMedia) override;

  /**
   * Notified by the control loop of MediaStreamGraph; aQueueMedia is the raw
   * track data in form of MediaSegment.
   */
  void NotifyQueuedTrackChanges(MediaStreamGraph* aGraph, TrackID aID,
                                StreamTime aTrackOffset,
                                TrackEventCommand aTrackEvents,
                                const MediaSegment& aQueuedMedia,
                                MediaStream* aInputStream,
                                TrackID aInputTrackID) override;

  /**
   * Notifed by the control loop of MediaStreamGraph; aQueueMedia is the audio
   * data in the form of an AudioSegment.
   */
  void NotifyQueuedAudioData(MediaStreamGraph* aGraph, TrackID aID,
                             StreamTime aTrackOffset,
                             const AudioSegment& aQueuedMedia,
                             MediaStream* aInputStream,
                             TrackID aInputTrackID) override;

  /**
   * * Notified the stream is being removed.
   */
  void NotifyEvent(MediaStreamGraph* aGraph,
                   MediaStreamGraphEvent event) override;

  /**
   * Creates an encoder with a given MIME type. Returns null if we are unable
   * to create the encoder. For now, default aMIMEType to "audio/ogg" and use
   * Ogg+Opus if it is empty.
   */
  static already_AddRefed<MediaEncoder> CreateEncoder(const nsAString& aMIMEType,
                                                      uint32_t aAudioBitrate, uint32_t aVideoBitrate,
                                                      uint32_t aBitrate,
                                                      uint8_t aTrackTypes = ContainerWriter::CREATE_AUDIO_TRACK,
                                                      TrackRate aTrackRate = CubebUtils::PreferredSampleRate());
  /**
   * Encodes the raw track data and returns the final container data. Assuming
   * it is called on a single worker thread. The buffer of container data is
   * allocated in ContainerWriter::GetContainerData(), and is appended to
   * aOutputBufs. aMIMEType is the valid mime-type of this returned container
   * data.
   */
  void GetEncodedData(nsTArray<nsTArray<uint8_t> >* aOutputBufs,
                      nsAString& aMIMEType);

  /**
   * Return true if MediaEncoder has been shutdown. Reasons are encoding
   * complete, encounter an error, or being canceled by its caller.
   */
  bool IsShutdown()
  {
    return mShutdown;
  }

  /**
   * Cancel the encoding, and wakes up the lock of reentrant monitor in encoder.
   */
  void Cancel()
  {
    if (mAudioEncoder) {
      mAudioEncoder->NotifyCancel();
    }
    if (mVideoEncoder) {
      mVideoEncoder->NotifyCancel();
    }
  }

  bool HasError()
  {
    return mState == ENCODE_ERROR;
  }

#ifdef MOZ_WEBM_ENCODER
  static bool IsWebMEncoderEnabled();
#endif

  MOZ_DEFINE_MALLOC_SIZE_OF(MallocSizeOf)
  /*
   * Measure the size of the buffer, and memory occupied by mAudioEncoder
   * and mVideoEncoder
   */
  size_t SizeOfExcludingThis(mozilla::MallocSizeOf aMallocSizeOf) const;

  MediaStreamVideoRecorderSink* GetVideoSink() {
    return mVideoSink.get();
  }

private:
  // Get encoded data from trackEncoder and write to muxer
  nsresult WriteEncodedDataToMuxer(TrackEncoder *aTrackEncoder);
  // Get metadata from trackEncoder and copy to muxer
  nsresult CopyMetadataToMuxer(TrackEncoder* aTrackEncoder);
  nsAutoPtr<ContainerWriter> mWriter;
  nsAutoPtr<AudioTrackEncoder> mAudioEncoder;
  nsAutoPtr<VideoTrackEncoder> mVideoEncoder;
  RefPtr<MediaStreamVideoRecorderSink> mVideoSink;
  TimeStamp mStartTime;
  nsString mMIMEType;
  int64_t mSizeOfBuffer;
  int mState;
  bool mShutdown;
  bool mDirectConnected;
  Atomic<int> mSuspended;
  // Get duration from create encoder, for logging purpose
  double GetEncodeTimeStamp()
  {
    TimeDuration decodeTime;
    decodeTime = TimeStamp::Now() - mStartTime;
    return decodeTime.ToMilliseconds();
  }
};

} // namespace mozilla

#endif
