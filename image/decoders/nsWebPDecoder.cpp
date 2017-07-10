/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "ImageLogging.h" // Must appear first
#include "nsWebPDecoder.h"

#include "RasterImage.h"
#include "SurfacePipeFactory.h"

using namespace mozilla::gfx;

namespace mozilla {
namespace image {

static LazyLogModule sWebPLog("WebPDecoder");

nsWebPDecoder::nsWebPDecoder(RasterImage* aImage)
  : Decoder(aImage)
  , mLexer(Transition::ToUnbuffered(State::FINISHED_WEBP_DATA,
                                    State::WEBP_DATA,
                                    SIZE_MAX),
           Transition::TerminateSuccess())
  , mDecoder(nullptr)
  , mBlend(BlendMethod::OVER)
  , mDisposal(DisposalMethod::KEEP)
  , mTimeout(FrameTimeout::Forever())
  , mFormat(SurfaceFormat::B8G8R8X8)
  , mLastRow(0)
  , mCurrentFrame(0)
{
  MOZ_LOG(sWebPLog, LogLevel::Debug,
      ("[this=%p] nsWebPDecoder::nsWebPDecoder", this));
}

nsWebPDecoder::~nsWebPDecoder()
{
  MOZ_LOG(sWebPLog, LogLevel::Debug,
      ("[this=%p] nsWebPDecoder::~nsWebPDecoder", this));
  WebPIDelete(mDecoder);
}

LexerResult
nsWebPDecoder::DoDecode(SourceBufferIterator& aIterator, IResumable* aOnResume)
{
  MOZ_ASSERT(!HasError(), "Shouldn't call DoDecode after error!");

  return mLexer.Lex(aIterator, aOnResume,
                    [=](State aState, const char* aData, size_t aLength) {
    switch (aState) {
      case State::WEBP_DATA:
        if (!HasSize()) {
          return ReadHeader(aData, aLength);
        }
        return ReadPayload(aData, aLength);
      case State::FINISHED_WEBP_DATA:
        return FinishedData();
    }
    MOZ_CRASH("Unknown State");
  });
}

nsresult
nsWebPDecoder::CreateFrame(const nsIntRect& aFrameRect)
{
  MOZ_ASSERT(HasSize());
  MOZ_ASSERT(!mDecoder);

  MOZ_LOG(sWebPLog, LogLevel::Debug,
      ("[this=%p] nsWebPDecoder::CreateFrame -- frame %u, %d x %d\n",
       this, mCurrentFrame, aFrameRect.width, aFrameRect.height));

  // If this is our first frame in an animation and it doesn't cover the
  // full frame, then we are transparent even if there is no alpha
  if (mCurrentFrame == 0 && !aFrameRect.IsEqualEdges(FullFrame())) {
    MOZ_ASSERT(HasAnimation());
    PostHasTransparency();
  }

  WebPInitDecBuffer(&mBuffer);
  mBuffer.colorspace = MODE_RGBA;

  mDecoder = WebPINewDecoder(&mBuffer);
  if (!mDecoder) {
    MOZ_LOG(sWebPLog, LogLevel::Error,
        ("[this=%p] nsWebPDecoder::CreateFrame -- create decoder error\n",
         this));
    return NS_ERROR_FAILURE;
  }

  Maybe<SurfacePipe> pipe = SurfacePipeFactory::CreateSurfacePipe(this,
      mCurrentFrame, Size(), OutputSize(), aFrameRect,
      mFormat, SurfacePipeFlags());
  if (!pipe) {
    MOZ_LOG(sWebPLog, LogLevel::Error,
        ("[this=%p] nsWebPDecoder::CreateFrame -- no pipe\n", this));
    return NS_ERROR_FAILURE;
  }

  mPipe = Move(*pipe);
  return NS_OK;
}

void
nsWebPDecoder::EndFrame()
{
  MOZ_ASSERT(HasSize());
  MOZ_ASSERT(mDecoder);

  auto opacity = mFormat == SurfaceFormat::B8G8R8A8
                 ? Opacity::SOME_TRANSPARENCY : Opacity::FULLY_OPAQUE;

  MOZ_LOG(sWebPLog, LogLevel::Debug,
      ("[this=%p] nsWebPDecoder::EndFrame -- frame %u, opacity %d, "
       "disposal %d, timeout %d, blend %d\n",
       this, mCurrentFrame, (int)opacity, (int)mDisposal,
       mTimeout.AsEncodedValueDeprecated(), (int)mBlend));

  PostFrameStop(opacity, mDisposal, mTimeout, mBlend);
  WebPIDelete(mDecoder);
  mDecoder = nullptr;
  mLastRow = 0;
  ++mCurrentFrame;
}

nsresult
nsWebPDecoder::GetDataBuffer(const uint8_t*& aData, size_t& aLength)
{
  if (!mData.empty() && mData.begin() != aData) {
    if (!mData.append(aData, aLength)) {
      MOZ_LOG(sWebPLog, LogLevel::Error,
          ("[this=%p] nsWebPDecoder::GetDataBuffer -- oom, append %zu on %zu\n",
           this, aLength, mData.length()));
      return NS_ERROR_OUT_OF_MEMORY;
    }
    aData = mData.begin();
    aLength = mData.length();
  }
  return NS_OK;
}

nsresult
nsWebPDecoder::SaveDataBuffer(const uint8_t* aData, size_t aLength)
{
  if (mData.empty() && !mData.append(aData, aLength)) {
    MOZ_LOG(sWebPLog, LogLevel::Error,
        ("[this=%p] nsWebPDecoder::SaveDataBuffer -- oom, append %zu on %zu\n",
         this, aLength, mData.length()));
    return NS_ERROR_OUT_OF_MEMORY;
  }
  return NS_OK;
}

LexerTransition<nsWebPDecoder::State>
nsWebPDecoder::ReadHeader(const char* aData, size_t aLength)
{
  MOZ_LOG(sWebPLog, LogLevel::Debug,
      ("[this=%p] nsWebPDecoder::ReadHeader -- %zu bytes\n", this, aLength));

  // XXX(aosmond): In an ideal world, we could request the lexer to do this
  // buffering for us (and in turn the underlying SourceBuffer). That way we
  // could avoid extra copies during the decode and just do
  // SourceBuffer::Compact on each iteration. For a typical WebP image we
  // can hope that we will get the full header in the first packet, but
  // for animated images we will end up buffering the whole stream if it
  // not already fully received and contiguous.
  auto data = (const uint8_t*)aData;
  size_t length = aLength;
  if (NS_FAILED(GetDataBuffer(data, length))) {
    return Transition::TerminateFailure();
  }

  WebPBitstreamFeatures features;
  VP8StatusCode status = WebPGetFeatures(data, length, &features);
  switch (status) {
    case VP8_STATUS_OK:
      break;
    case VP8_STATUS_NOT_ENOUGH_DATA:
      if (NS_FAILED(SaveDataBuffer(data, length))) {
        return Transition::TerminateFailure();
      }
      return Transition::ContinueUnbuffered(State::WEBP_DATA);
    default:
      MOZ_LOG(sWebPLog, LogLevel::Error,
          ("[this=%p] nsWebPDecoder::ReadHeader -- parse error %d\n",
           this, status));
      return Transition::TerminateFailure();
  }

  if (features.has_animation) {
    // A metadata decode expects to get the correct first frame timeout which
    // sadly is not provided by the normal WebP header parsing.
    WebPDemuxState state;
    WebPData fragment;
    fragment.bytes = data;
    fragment.size = length;
    WebPDemuxer* demuxer = WebPDemuxPartial(&fragment, &state);
    if (!demuxer || state == WEBP_DEMUX_PARSE_ERROR) {
      MOZ_LOG(sWebPLog, LogLevel::Error,
          ("[this=%p] nsWebPDecoder::ReadHeader -- demux parse error\n", this));
      WebPDemuxDelete(demuxer);
      return Transition::TerminateFailure();
    }

    WebPIterator iter;
    if (!WebPDemuxGetFrame(demuxer, 1, &iter)) {
      WebPDemuxDelete(demuxer);
      if (state == WEBP_DEMUX_DONE) {
        MOZ_LOG(sWebPLog, LogLevel::Error,
            ("[this=%p] nsWebPDecoder::ReadHeader -- demux parse error\n",
             this));
        return Transition::TerminateFailure();
      }
      if (NS_FAILED(SaveDataBuffer(data, length))) {
        return Transition::TerminateFailure();
      }
      return Transition::ContinueUnbuffered(State::WEBP_DATA);
    }

    PostIsAnimated(FrameTimeout::FromRawMilliseconds(iter.duration));
    WebPDemuxReleaseIterator(&iter);
    WebPDemuxDelete(demuxer);
  }

  MOZ_LOG(sWebPLog, LogLevel::Debug,
      ("[this=%p] nsWebPDecoder::ReadHeader -- %d x %d, alpha %d, "
       "animation %d, format %d, metadata decode %d, first frame decode %d\n",
       this, features.width, features.height, features.has_alpha,
       features.has_animation, features.format, IsMetadataDecode(),
       IsFirstFrameDecode()));

  PostSize(features.width, features.height);
  if (features.has_alpha) {
    mFormat = SurfaceFormat::B8G8R8A8;
    PostHasTransparency();
  }

  if (IsMetadataDecode()) {
    return Transition::TerminateSuccess();
  }

  auto transition = ReadPayload((const char*)data, length);
  if (!features.has_animation) {
    mData.clearAndFree();
  }
  return transition;
}

LexerTransition<nsWebPDecoder::State>
nsWebPDecoder::ReadPayload(const char* aData, size_t aLength)
{
  auto data = (const uint8_t*)aData;
  if (!HasAnimation()) {
    auto rv = ReadSingle(data, aLength, true, FullFrame());
    if (rv.NextStateIsTerminal() &&
        rv.NextStateAsTerminal() == TerminalState::SUCCESS) {
      PostDecodeDone();
    }
    return rv;
  }
  return ReadMultiple(data, aLength);
}

LexerTransition<nsWebPDecoder::State>
nsWebPDecoder::ReadSingle(const uint8_t* aData, size_t aLength, bool aAppend, const IntRect& aFrameRect)
{
  MOZ_ASSERT(!IsMetadataDecode());
  MOZ_ASSERT(aData);
  MOZ_ASSERT(aLength > 0);

  MOZ_LOG(sWebPLog, LogLevel::Debug,
      ("[this=%p] nsWebPDecoder::ReadSingle -- %zu bytes\n", this, aLength));

  if (!mDecoder && NS_FAILED(CreateFrame(aFrameRect))) {
    return Transition::TerminateFailure();
  }

  // XXX(aosmond): The demux API can be used for single images according to the
  // documentation. If WebPIAppend is not any more efficient in its buffering
  // than what we do for animated images, we should just combine the use cases.
  bool complete;
  VP8StatusCode status;
  if (aAppend) {
    status = WebPIAppend(mDecoder, aData, aLength);
  } else {
    status = WebPIUpdate(mDecoder, aData, aLength);
  }
  switch (status) {
    case VP8_STATUS_OK:
      complete = true;
      break;
    case VP8_STATUS_SUSPENDED:
      complete = false;
      break;
    default:
      MOZ_LOG(sWebPLog, LogLevel::Error,
          ("[this=%p] nsWebPDecoder::ReadSingle -- append error %d\n",
           this, status));
      return Transition::TerminateFailure();
  }

  int lastRow = -1;
  int width = 0;
  int height = 0;
  int stride = 0;
  const uint8_t* rowStart = WebPIDecGetRGB(mDecoder, &lastRow, &width, &height, &stride);
  if (!rowStart || lastRow == -1) {
    return Transition::ContinueUnbuffered(State::WEBP_DATA);
  }

  if (width <= 0 || height <= 0 || stride <= 0) {
    MOZ_LOG(sWebPLog, LogLevel::Error,
        ("[this=%p] nsWebPDecoder::ReadSingle -- bad (w,h,s) = (%d, %d, %d)\n",
         this, width, height, stride));
    return Transition::TerminateFailure();
  }

  for (int row = mLastRow; row < lastRow; row++) {
    const uint8_t* src = rowStart + row * stride;
    auto result = mPipe.WritePixelsToRow<uint32_t>([&]() -> NextPixel<uint32_t> {
      MOZ_ASSERT(mFormat == SurfaceFormat::B8G8R8A8 || src[3] == 0xFF);
      const uint32_t pixel = gfxPackedPixel(src[3], src[0], src[1], src[2]);
      src += 4;
      return AsVariant(pixel);
    });
    MOZ_ASSERT(result != WriteState::FAILURE);
    MOZ_ASSERT_IF(result == WriteState::FINISHED, complete && row == lastRow - 1);

    if (result == WriteState::FAILURE) {
      MOZ_LOG(sWebPLog, LogLevel::Error,
          ("[this=%p] nsWebPDecoder::ReadSingle -- write pixels error\n",
           this));
      return Transition::TerminateFailure();
    }
  }

  if (mLastRow != lastRow) {
    mLastRow = lastRow;

    Maybe<SurfaceInvalidRect> invalidRect = mPipe.TakeInvalidRect();
    if (invalidRect) {
      PostInvalidation(invalidRect->mInputSpaceRect,
          Some(invalidRect->mOutputSpaceRect));
    }
  }

  if (!complete) {
    return Transition::ContinueUnbuffered(State::WEBP_DATA);
  }

  EndFrame();
  return Transition::TerminateSuccess();
}

LexerTransition<nsWebPDecoder::State>
nsWebPDecoder::ReadMultiple(const uint8_t* aData, size_t aLength)
{
  MOZ_ASSERT(!IsMetadataDecode());
  MOZ_ASSERT(aData);

  MOZ_LOG(sWebPLog, LogLevel::Debug,
      ("[this=%p] nsWebPDecoder::ReadMultiple -- %zu bytes\n", this, aLength));

  auto data = aData;
  size_t length = aLength;
  if (NS_FAILED(GetDataBuffer(data, length))) {
    return Transition::TerminateFailure();
  }

  WebPDemuxState state;
  WebPData fragment;
  fragment.bytes = data;
  fragment.size = length;
  WebPDemuxer* demuxer = WebPDemuxPartial(&fragment, &state);
  if (!demuxer) {
    MOZ_LOG(sWebPLog, LogLevel::Error,
        ("[this=%p] nsWebPDecoder::ReadMultiple -- create demuxer error\n",
         this));
    return Transition::TerminateFailure();
  }

  if (state == WEBP_DEMUX_PARSE_ERROR) {
    MOZ_LOG(sWebPLog, LogLevel::Error,
        ("[this=%p] nsWebPDecoder::ReadMultiple -- demuxer parse error\n",
         this));
    WebPDemuxDelete(demuxer);
    return Transition::TerminateFailure();
  }

  bool complete = false;
  WebPIterator iter;
  auto rv = Transition::ContinueUnbuffered(State::WEBP_DATA);
  if (WebPDemuxGetFrame(demuxer, mCurrentFrame + 1, &iter)) {
    switch (iter.blend_method) {
      case WEBP_MUX_BLEND:
        mBlend = BlendMethod::OVER;
        break;
      case WEBP_MUX_NO_BLEND:
        mBlend = BlendMethod::SOURCE;
        break;
      default:
        MOZ_ASSERT_UNREACHABLE("Unhandled blend method");
        break;
    }

    switch (iter.dispose_method) {
      case WEBP_MUX_DISPOSE_NONE:
        mDisposal = DisposalMethod::KEEP;
        break;
      case WEBP_MUX_DISPOSE_BACKGROUND:
        mDisposal = DisposalMethod::CLEAR;
        break;
      default:
        MOZ_ASSERT_UNREACHABLE("Unhandled dispose method");
        break;
    }

    mFormat = iter.has_alpha ? SurfaceFormat::B8G8R8A8 : SurfaceFormat::B8G8R8X8;
    mTimeout = FrameTimeout::FromRawMilliseconds(iter.duration);
    nsIntRect frameRect(iter.x_offset, iter.y_offset, iter.width, iter.height);

    rv = ReadSingle(iter.fragment.bytes, iter.fragment.size, false, frameRect);
    complete = state == WEBP_DEMUX_DONE && !WebPDemuxNextFrame(&iter);
    WebPDemuxReleaseIterator(&iter);
  }

  if (rv.NextStateIsTerminal()) {
    if (rv.NextStateAsTerminal() == TerminalState::SUCCESS) {
      // If we extracted one frame, and it is not the last, we need to yield to
      // the lexer to allow the upper layers to acknowledge the frame.
      if (!complete && !IsFirstFrameDecode()) {
        // The resume point is determined by whether or not we had to buffer.
        // If we have yet to buffer, we want to resume at the same point,
        // otherwise our internal buffer has everything we need and we want
        // to resume having consumed all of the current fragment.
        rv = Transition::ContinueUnbufferedAfterYield(State::WEBP_DATA,
                 mData.empty() ? 0 : aLength);
      } else {
        uint32_t loopCount = WebPDemuxGetI(demuxer, WEBP_FF_LOOP_COUNT);

        MOZ_LOG(sWebPLog, LogLevel::Debug,
          ("[this=%p] nsWebPDecoder::ReadMultiple -- loop count %u\n",
           this, loopCount));
        PostDecodeDone(loopCount - 1);
      }
    }
  } else if (NS_FAILED(SaveDataBuffer(data, length))) {
    rv = Transition::TerminateFailure();
  }

  WebPDemuxDelete(demuxer);
  return rv;
}

LexerTransition<nsWebPDecoder::State>
nsWebPDecoder::FinishedData()
{
  // Since we set up an unbuffered read for SIZE_MAX bytes, if we actually read
  // all that data something is really wrong.
  MOZ_ASSERT_UNREACHABLE("Read the entire address space?");
  return Transition::TerminateFailure();
}

} // namespace image
} // namespace mozilla
