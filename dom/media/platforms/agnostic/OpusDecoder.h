/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim:set ts=2 sw=2 sts=2 et cindent: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
#if !defined(OpusDecoder_h_)
#define OpusDecoder_h_

#include "PlatformDecoderModule.h"

#include "mozilla/Maybe.h"
#include "nsAutoPtr.h"

struct OpusMSDecoder;

namespace mozilla {

class OpusParser;

class OpusDataDecoder : public MediaDataDecoder
{
public:
  explicit OpusDataDecoder(const CreateDecoderParams& aParams);
  ~OpusDataDecoder();

  RefPtr<InitPromise> Init() override;
  void Input(MediaRawData* aSample) override;
  void Flush() override;
  void Drain() override;
  void Shutdown() override;
  const char* GetDescriptionName() const override
  {
    return "opus audio decoder";
  }

  // Return true if mimetype is Opus
  static bool IsOpus(const nsACString& aMimeType);

  // Pack pre-skip/CodecDelay, given in microseconds, into a
  // MediaByteBuffer. The decoder expects this value to come
  // from the container (if any) and to precede the OpusHead
  // block in the CodecSpecificConfig buffer to verify the
  // values match.
  static void AppendCodecDelay(MediaByteBuffer* config, uint64_t codecDelayUS);

private:
  nsresult DecodeHeader(const unsigned char* aData, size_t aLength);

  void ProcessDecode(MediaRawData* aSample);
  MediaResult DoDecode(MediaRawData* aSample);
  void ProcessDrain();

  const AudioInfo& mInfo;
  const RefPtr<TaskQueue> mTaskQueue;
  MediaDataDecoderCallback* mCallback;

  // Opus decoder state
  nsAutoPtr<OpusParser> mOpusParser;
  OpusMSDecoder* mOpusDecoder;

  uint16_t mSkip;        // Samples left to trim before playback.
  bool mDecodedHeader;

  // Opus padding should only be discarded on the final packet.  Once this
  // is set to true, if the reader attempts to decode any further packets it
  // will raise an error so we can indicate that the file is invalid.
  bool mPaddingDiscarded;
  int64_t mFrames;
  Maybe<int64_t> mLastFrameTime;
  uint8_t mMappingTable[MAX_AUDIO_CHANNELS]; // Channel mapping table.

  Atomic<bool> mIsFlushing;
};

} // namespace mozilla
#endif
