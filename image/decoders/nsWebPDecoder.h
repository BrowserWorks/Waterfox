/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_image_decoders_nsWebPDecoder_h
#define mozilla_image_decoders_nsWebPDecoder_h

#include "Decoder.h"
#include "webp/demux.h"
#include "StreamingLexer.h"
#include "SurfacePipe.h"

namespace mozilla {
namespace image {
class RasterImage;

class nsWebPDecoder : public Decoder
{
public:
  virtual ~nsWebPDecoder();

protected:
  LexerResult DoDecode(SourceBufferIterator& aIterator,
                       IResumable* aOnResume) override;

private:
  friend class DecoderFactory;

  // Decoders should only be instantiated via DecoderFactory.
  explicit nsWebPDecoder(RasterImage* aImage);

  enum class State
  {
    WEBP_DATA,
    FINISHED_WEBP_DATA
  };

  LexerTransition<State> ReadHeader(const char* aData, size_t aLength);
  LexerTransition<State> ReadPayload(const char* aData, size_t aLength);
  LexerTransition<State> FinishedData();

  nsresult CreateFrame(const nsIntRect& aFrameRect);
  void EndFrame();

  nsresult GetDataBuffer(const uint8_t*& aData, size_t& aLength);
  nsresult SaveDataBuffer(const uint8_t* aData, size_t aLength);

  LexerTransition<State> ReadSingle(const uint8_t* aData, size_t aLength,
                                    bool aAppend, const IntRect& aFrameRect);

  LexerTransition<State> ReadMultiple(const uint8_t* aData, size_t aLength);

  StreamingLexer<State> mLexer;

  /// The SurfacePipe used to write to the output surface.
  SurfacePipe mPipe;

  /// The buffer used to accumulate data until the complete WebP header is received.
  Vector<uint8_t> mData;

  /// The libwebp output buffer descriptor pointing to the decoded data.
  WebPDecBuffer mBuffer;

  /// The libwebp incremental decoder descriptor, wraps mBuffer.
  WebPIDecoder* mDecoder;

  /// Blend method for the current frame.
  BlendMethod mBlend;

  /// Disposal method for the current frame.
  DisposalMethod mDisposal;

  /// Frame timeout for the current frame;
  FrameTimeout mTimeout;

  /// Surface format for the current frame.
  gfx::SurfaceFormat mFormat;

  /// The last row of decoded pixels written to mPipe.
  int mLastRow;

  /// Number of decoded frames.
  uint32_t mCurrentFrame;
};

} // namespace image
} // namespace mozilla

#endif // mozilla_image_decoders_nsWebPDecoder_h
