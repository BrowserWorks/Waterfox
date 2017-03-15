/* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "gtest/gtest.h"
#include <algorithm>

#include "mozilla/ArrayUtils.h"
#include "VP8TrackEncoder.h"
#include "ImageContainer.h"
#include "MediaStreamGraph.h"
#include "MediaStreamListener.h"
#include "WebMWriter.h" // TODO: it's weird to include muxer header to get the class definition of VP8 METADATA

using ::testing::TestWithParam;
using ::testing::Values;

using namespace mozilla::layers;
using namespace mozilla;

// A helper object to generate of different YUV planes.
class YUVBufferGenerator {
public:
  YUVBufferGenerator() {}

  void Init(const mozilla::gfx::IntSize &aSize)
  {
    mImageSize = aSize;

    int yPlaneLen = aSize.width * aSize.height;
    int cbcrPlaneLen = (yPlaneLen + 1) / 2;
    int frameLen = yPlaneLen + cbcrPlaneLen;

    // Generate source buffer.
    mSourceBuffer.SetLength(frameLen);

    // Fill Y plane.
    memset(mSourceBuffer.Elements(), 0x10, yPlaneLen);

    // Fill Cb/Cr planes.
    memset(mSourceBuffer.Elements() + yPlaneLen, 0x80, cbcrPlaneLen);
  }

  mozilla::gfx::IntSize GetSize() const
  {
    return mImageSize;
  }

  void Generate(nsTArray<RefPtr<Image> > &aImages)
  {
    aImages.AppendElement(CreateI420Image());
    aImages.AppendElement(CreateNV12Image());
    aImages.AppendElement(CreateNV21Image());
  }

private:
  Image *CreateI420Image()
  {
    PlanarYCbCrImage *image = new RecyclingPlanarYCbCrImage(new BufferRecycleBin());
    PlanarYCbCrData data;
    data.mPicSize = mImageSize;

    const uint32_t yPlaneSize = mImageSize.width * mImageSize.height;
    const uint32_t halfWidth = (mImageSize.width + 1) / 2;
    const uint32_t halfHeight = (mImageSize.height + 1) / 2;
    const uint32_t uvPlaneSize = halfWidth * halfHeight;

    // Y plane.
    uint8_t *y = mSourceBuffer.Elements();
    data.mYChannel = y;
    data.mYSize.width = mImageSize.width;
    data.mYSize.height = mImageSize.height;
    data.mYStride = mImageSize.width;
    data.mYSkip = 0;

    // Cr plane.
    uint8_t *cr = y + yPlaneSize + uvPlaneSize;
    data.mCrChannel = cr;
    data.mCrSkip = 0;

    // Cb plane
    uint8_t *cb = y + yPlaneSize;
    data.mCbChannel = cb;
    data.mCbSkip = 0;

    // CrCb plane vectors.
    data.mCbCrStride = halfWidth;
    data.mCbCrSize.width = halfWidth;
    data.mCbCrSize.height = halfHeight;

    image->CopyData(data);
    return image;
  }

  Image *CreateNV12Image()
  {
    PlanarYCbCrImage *image = new RecyclingPlanarYCbCrImage(new BufferRecycleBin());
    PlanarYCbCrData data;
    data.mPicSize = mImageSize;

    const uint32_t yPlaneSize = mImageSize.width * mImageSize.height;
    const uint32_t halfWidth = (mImageSize.width + 1) / 2;
    const uint32_t halfHeight = (mImageSize.height + 1) / 2;

    // Y plane.
    uint8_t *y = mSourceBuffer.Elements();
    data.mYChannel = y;
    data.mYSize.width = mImageSize.width;
    data.mYSize.height = mImageSize.height;
    data.mYStride = mImageSize.width;
    data.mYSkip = 0;

    // Cr plane.
    uint8_t *cr = y + yPlaneSize;
    data.mCrChannel = cr;
    data.mCrSkip = 1;

    // Cb plane
    uint8_t *cb = y + yPlaneSize + 1;
    data.mCbChannel = cb;
    data.mCbSkip = 1;

    // 4:2:0.
    data.mCbCrStride = mImageSize.width;
    data.mCbCrSize.width = halfWidth;
    data.mCbCrSize.height = halfHeight;

    image->CopyData(data);
    return image;
  }

  Image *CreateNV21Image()
  {
    PlanarYCbCrImage *image = new RecyclingPlanarYCbCrImage(new BufferRecycleBin());
    PlanarYCbCrData data;
    data.mPicSize = mImageSize;

    const uint32_t yPlaneSize = mImageSize.width * mImageSize.height;
    const uint32_t halfWidth = (mImageSize.width + 1) / 2;
    const uint32_t halfHeight = (mImageSize.height + 1) / 2;

    // Y plane.
    uint8_t *y = mSourceBuffer.Elements();
    data.mYChannel = y;
    data.mYSize.width = mImageSize.width;
    data.mYSize.height = mImageSize.height;
    data.mYStride = mImageSize.width;
    data.mYSkip = 0;

    // Cr plane.
    uint8_t *cr = y + yPlaneSize + 1;
    data.mCrChannel = cr;
    data.mCrSkip = 1;

    // Cb plane
    uint8_t *cb = y + yPlaneSize;
    data.mCbChannel = cb;
    data.mCbSkip = 1;

    // 4:2:0.
    data.mCbCrStride = mImageSize.width;
    data.mCbCrSize.width = halfWidth;
    data.mCbCrSize.height = halfHeight;

    image->CopyData(data);
    return image;
  }

private:
  mozilla::gfx::IntSize mImageSize;
  nsTArray<uint8_t> mSourceBuffer;
};

struct InitParam {
  bool mShouldSucceed;  // This parameter should cause success or fail result
  int  mWidth;          // frame width
  int  mHeight;         // frame height
};

class TestVP8TrackEncoder: public VP8TrackEncoder
{
public:
  explicit TestVP8TrackEncoder(TrackRate aTrackRate = 90000)
    : VP8TrackEncoder(aTrackRate) {}

  ::testing::AssertionResult TestInit(const InitParam &aParam)
  {
    nsresult result = Init(aParam.mWidth, aParam.mHeight, aParam.mWidth, aParam.mHeight);

    if (((NS_FAILED(result) && aParam.mShouldSucceed)) || (NS_SUCCEEDED(result) && !aParam.mShouldSucceed))
    {
      return ::testing::AssertionFailure()
                << " width = " << aParam.mWidth
                << " height = " << aParam.mHeight;
    }
    else
    {
      return ::testing::AssertionSuccess();
    }
  }
};

// Init test
TEST(VP8VideoTrackEncoder, Initialization)
{
  InitParam params[] = {
    // Failure cases.
    { false, 0, 0},      // Height/ width should be larger than 1.
    { false, 0, 1},      // Height/ width should be larger than 1.
    { false, 1, 0},       // Height/ width should be larger than 1.

    // Success cases
    { true, 640, 480},    // Standard VGA
    { true, 800, 480},    // Standard WVGA
    { true, 960, 540},    // Standard qHD
    { true, 1280, 720}    // Standard HD
  };

  for (size_t i = 0; i < ArrayLength(params); i++)
  {
    TestVP8TrackEncoder encoder;
    EXPECT_TRUE(encoder.TestInit(params[i]));
  }
}

// Get MetaData test
TEST(VP8VideoTrackEncoder, FetchMetaData)
{
  InitParam params[] = {
    // Success cases
    { true, 640, 480},    // Standard VGA
    { true, 800, 480},    // Standard WVGA
    { true, 960, 540},    // Standard qHD
    { true, 1280, 720}    // Standard HD
  };

  for (size_t i = 0; i < ArrayLength(params); i++)
  {
    TestVP8TrackEncoder encoder;
    EXPECT_TRUE(encoder.TestInit(params[i]));

    RefPtr<TrackMetadataBase> meta = encoder.GetMetadata();
    RefPtr<VP8Metadata> vp8Meta(static_cast<VP8Metadata*>(meta.get()));

    // METADATA should be depend on how to initiate encoder.
    EXPECT_TRUE(vp8Meta->mWidth == params[i].mWidth);
    EXPECT_TRUE(vp8Meta->mHeight == params[i].mHeight);
  }
}

// Encode test
TEST(VP8VideoTrackEncoder, FrameEncode)
{
  // Initiate VP8 encoder
  TestVP8TrackEncoder encoder;
  InitParam param = {true, 640, 480};
  encoder.TestInit(param);

  // Create YUV images as source.
  nsTArray<RefPtr<Image>> images;
  YUVBufferGenerator generator;
  generator.Init(mozilla::gfx::IntSize(640, 480));
  generator.Generate(images);

  // Put generated YUV frame into video segment.
  // Duration of each frame is 1 second.
  VideoSegment segment;
  for (nsTArray<RefPtr<Image>>::size_type i = 0; i < images.Length(); i++)
  {
    RefPtr<Image> image = images[i];
    segment.AppendFrame(image.forget(),
                        mozilla::StreamTime(90000),
                        generator.GetSize(),
                        PRINCIPAL_HANDLE_NONE);
  }

  // track change notification.
  encoder.SetCurrentFrames(segment);

  // Pull Encoded Data back from encoder.
  EncodedFrameContainer container;
  EXPECT_TRUE(NS_SUCCEEDED(encoder.GetEncodedTrack(container)));
}

// Test encoding a track that has to skip frames.
TEST(VP8VideoTrackEncoder, SkippedFrames)
{
  // Initiate VP8 encoder
  TestVP8TrackEncoder encoder;
  InitParam param = {true, 640, 480};
  encoder.TestInit(param);
  nsTArray<RefPtr<Image>> images;
  YUVBufferGenerator generator;
  generator.Init(mozilla::gfx::IntSize(640, 480));
  TimeStamp now = TimeStamp::Now();
  VideoSegment segment;

  while (images.Length() < 100) { 
    generator.Generate(images);
  }

  // Pass 100 frames of the shortest possible duration where we don't get
  // rounding errors between input/output rate.
  for (uint32_t i = 0; i < 100; ++i) {
    segment.AppendFrame(images[i].forget(),
                        mozilla::StreamTime(90), // 1ms
                        generator.GetSize(),
                        PRINCIPAL_HANDLE_NONE,
                        false,
                        now + TimeDuration::FromMilliseconds(i));
  }

  encoder.SetCurrentFrames(segment);

  // End the track.
  segment.Clear();
  encoder.NotifyQueuedTrackChanges(nullptr, 0, 0, TrackEventCommand::TRACK_EVENT_ENDED, segment);

  EncodedFrameContainer container;
  ASSERT_TRUE(NS_SUCCEEDED(encoder.GetEncodedTrack(container)));

  EXPECT_TRUE(encoder.IsEncodingComplete());

  // Verify total duration being 100 * 1ms = 100ms in terms of 30fps frame
  // durations (3 * 1/30s).
  uint64_t totalDuration = 0;
  for (auto& frame : container.GetEncodedFrames()) {
    totalDuration += frame->GetDuration();
  }
  const uint64_t threeFrames = (PR_USEC_PER_SEC / 30) * 3;
  EXPECT_EQ(threeFrames, totalDuration);
}

// EOS test
TEST(VP8VideoTrackEncoder, EncodeComplete)
{
  // Initiate VP8 encoder
  TestVP8TrackEncoder encoder;
  InitParam param = {true, 640, 480};
  encoder.TestInit(param);

  // track end notification.
  VideoSegment segment;
  encoder.NotifyQueuedTrackChanges(nullptr, 0, 0, TrackEventCommand::TRACK_EVENT_ENDED, segment);

  // Pull Encoded Data back from encoder. Since we have sent
  // EOS to encoder, encoder.GetEncodedTrack should return
  // NS_OK immidiately.
  EncodedFrameContainer container;
  EXPECT_TRUE(NS_SUCCEEDED(encoder.GetEncodedTrack(container)));
}
