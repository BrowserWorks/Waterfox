/* -*- Mode: C++; tab-width: 20; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "ImageDataSerializer.h"
#include "gfx2DGlue.h"                  // for SurfaceFormatToImageFormat
#include "mozilla/gfx/Point.h"          // for IntSize
#include "mozilla/Assertions.h"         // for MOZ_ASSERT, etc
#include "mozilla/gfx/2D.h"             // for DataSourceSurface, Factory
#include "mozilla/gfx/Logging.h"        // for gfxDebug
#include "mozilla/gfx/Tools.h"          // for GetAlignedStride, etc
#include "mozilla/gfx/Types.h"
#include "mozilla/mozalloc.h"           // for operator delete, etc
#include "YCbCrUtils.h"                 // for YCbCr conversions

namespace mozilla {
namespace layers {
namespace ImageDataSerializer {

using namespace gfx;

int32_t
ComputeRGBStride(SurfaceFormat aFormat, int32_t aWidth)
{
  return GetAlignedStride<4>(aWidth, BytesPerPixel(aFormat));
}

int32_t
GetRGBStride(const RGBDescriptor& aDescriptor)
{
  return ComputeRGBStride(aDescriptor.format(), aDescriptor.size().width);
}

uint32_t
ComputeRGBBufferSize(IntSize aSize, SurfaceFormat aFormat)
{
  MOZ_ASSERT(aSize.height >= 0 && aSize.width >= 0);

  // This takes care of checking whether there could be overflow
  // with enough margin for the metadata.
  if (!gfx::Factory::AllowedSurfaceSize(aSize)) {
    return 0;
  }

  // Note we're passing height instad of the bpp parameter, but the end
  // result is the same - and the bpp was already taken care of in the
  // ComputeRGBStride function.
  int32_t bufsize = GetAlignedStride<16>(ComputeRGBStride(aFormat, aSize.width),
                                         aSize.height);

  if (bufsize < 0) {
    // This should not be possible thanks to Factory::AllowedSurfaceSize
    return 0;
  }

  return bufsize;
}



// Minimum required shmem size in bytes
uint32_t
ComputeYCbCrBufferSize(const gfx::IntSize& aYSize, int32_t aYStride,
                       const gfx::IntSize& aCbCrSize, int32_t aCbCrStride)
{
  MOZ_ASSERT(aYSize.height >= 0 && aYSize.width >= 0);

  if (aYSize.height < 0 || aYSize.width < 0 || aCbCrSize.height < 0 || aCbCrSize.width < 0 ||
      !gfx::Factory::AllowedSurfaceSize(IntSize(aYStride, aYSize.height)) ||
      !gfx::Factory::AllowedSurfaceSize(IntSize(aCbCrStride, aCbCrSize.height))) {
    return 0;
  }
  // Overflow checks are performed in AllowedSurfaceSize
  return GetAlignedStride<4>(aYSize.height, aYStride) +
         2 * GetAlignedStride<4>(aCbCrSize.height, aCbCrStride);
}

// Minimum required shmem size in bytes
uint32_t
ComputeYCbCrBufferSize(const gfx::IntSize& aYSize, const gfx::IntSize& aCbCrSize)
{
  return ComputeYCbCrBufferSize(aYSize, aYSize.width, aCbCrSize, aCbCrSize.width);
}

uint32_t
ComputeYCbCrBufferSize(uint32_t aBufferSize)
{
  return GetAlignedStride<4>(aBufferSize, 1);
}

void ComputeYCbCrOffsets(int32_t yStride, int32_t yHeight,
                         int32_t cbCrStride, int32_t cbCrHeight,
                         uint32_t& outYOffset, uint32_t& outCbOffset,
                         uint32_t& outCrOffset)
{
  outYOffset = 0;
  outCbOffset = outYOffset + GetAlignedStride<4>(yStride, yHeight);
  outCrOffset = outCbOffset + GetAlignedStride<4>(cbCrStride, cbCrHeight);
}

gfx::SurfaceFormat FormatFromBufferDescriptor(const BufferDescriptor& aDescriptor)
{
  switch (aDescriptor.type()) {
    case BufferDescriptor::TRGBDescriptor:
      return aDescriptor.get_RGBDescriptor().format();
    case BufferDescriptor::TYCbCrDescriptor:
      return gfx::SurfaceFormat::YUV;
    default:
      MOZ_CRASH("GFX: FormatFromBufferDescriptor");
  }
}

gfx::IntSize SizeFromBufferDescriptor(const BufferDescriptor& aDescriptor)
{
  switch (aDescriptor.type()) {
    case BufferDescriptor::TRGBDescriptor:
      return aDescriptor.get_RGBDescriptor().size();
    case BufferDescriptor::TYCbCrDescriptor:
      return aDescriptor.get_YCbCrDescriptor().ySize();
    default:
      MOZ_CRASH("GFX: SizeFromBufferDescriptor");
  }
}

Maybe<gfx::IntSize> CbCrSizeFromBufferDescriptor(const BufferDescriptor& aDescriptor)
{
  switch (aDescriptor.type()) {
    case BufferDescriptor::TRGBDescriptor:
      return Nothing();
    case BufferDescriptor::TYCbCrDescriptor:
      return Some(aDescriptor.get_YCbCrDescriptor().cbCrSize());
    default:
      MOZ_CRASH("GFX:  CbCrSizeFromBufferDescriptor");
  }
}

Maybe<YUVColorSpace> YUVColorSpaceFromBufferDescriptor(const BufferDescriptor& aDescriptor)
{
{
  switch (aDescriptor.type()) {
    case BufferDescriptor::TRGBDescriptor:
      return Nothing();
    case BufferDescriptor::TYCbCrDescriptor:
      return Some(aDescriptor.get_YCbCrDescriptor().yUVColorSpace());
    default:
      MOZ_CRASH("GFX:  CbCrSizeFromBufferDescriptor");
  }
}
}

Maybe<StereoMode> StereoModeFromBufferDescriptor(const BufferDescriptor& aDescriptor)
{
  switch (aDescriptor.type()) {
    case BufferDescriptor::TRGBDescriptor:
      return Nothing();
    case BufferDescriptor::TYCbCrDescriptor:
      return Some(aDescriptor.get_YCbCrDescriptor().stereoMode());
    default:
      MOZ_CRASH("GFX:  CbCrSizeFromBufferDescriptor");
  }
}

uint8_t* GetYChannel(uint8_t* aBuffer, const YCbCrDescriptor& aDescriptor)
{
  return aBuffer + aDescriptor.yOffset();
}

uint8_t* GetCbChannel(uint8_t* aBuffer, const YCbCrDescriptor& aDescriptor)
{
  return aBuffer + aDescriptor.cbOffset();
}

uint8_t* GetCrChannel(uint8_t* aBuffer, const YCbCrDescriptor& aDescriptor)
{
  return aBuffer + aDescriptor.crOffset();
}

already_AddRefed<DataSourceSurface>
DataSourceSurfaceFromYCbCrDescriptor(uint8_t* aBuffer, const YCbCrDescriptor& aDescriptor, gfx::DataSourceSurface* aSurface)
{
  gfx::IntSize ySize = aDescriptor.ySize();
  gfx::IntSize cbCrSize = aDescriptor.cbCrSize();
  int32_t yStride = ySize.width;
  int32_t cbCrStride = cbCrSize.width;

  RefPtr<DataSourceSurface> result;
  if (aSurface) {
    MOZ_ASSERT(aSurface->GetSize() == ySize);
    MOZ_ASSERT(aSurface->GetFormat() == gfx::SurfaceFormat::B8G8R8X8);
    if (aSurface->GetSize() == ySize &&
        aSurface->GetFormat() == gfx::SurfaceFormat::B8G8R8X8) {
      result = aSurface;
    }
  }

  if (!result) {
    result =
      Factory::CreateDataSourceSurface(ySize, gfx::SurfaceFormat::B8G8R8X8);
  }
  if (NS_WARN_IF(!result)) {
    return nullptr;
  }

  DataSourceSurface::MappedSurface map;
  if (NS_WARN_IF(!result->Map(DataSourceSurface::MapType::WRITE, &map))) {
    return nullptr;
  }

  layers::PlanarYCbCrData ycbcrData;
  ycbcrData.mYChannel     = GetYChannel(aBuffer, aDescriptor);
  ycbcrData.mYStride      = yStride;
  ycbcrData.mYSize        = ySize;
  ycbcrData.mCbChannel    = GetCbChannel(aBuffer, aDescriptor);
  ycbcrData.mCrChannel    = GetCrChannel(aBuffer, aDescriptor);
  ycbcrData.mCbCrStride   = cbCrStride;
  ycbcrData.mCbCrSize     = cbCrSize;
  ycbcrData.mPicSize      = ySize;
  ycbcrData.mYUVColorSpace = aDescriptor.yUVColorSpace();

  gfx::ConvertYCbCrToRGB(ycbcrData,
                         gfx::SurfaceFormat::B8G8R8X8,
                         ySize,
                         map.mData,
                         map.mStride);

  result->Unmap();
  return result.forget();
}

void
ConvertAndScaleFromYCbCrDescriptor(uint8_t* aBuffer,
                                   const YCbCrDescriptor& aDescriptor,
                                   const gfx::SurfaceFormat& aDestFormat,
                                   const gfx::IntSize& aDestSize,
                                   unsigned char* aDestBuffer,
                                   int32_t aStride)
{
  MOZ_ASSERT(aBuffer);
  gfx::IntSize ySize = aDescriptor.ySize();
  gfx::IntSize cbCrSize = aDescriptor.cbCrSize();
  int32_t yStride = ySize.width;
  int32_t cbCrStride = cbCrSize.width;

  layers::PlanarYCbCrData ycbcrData;
  ycbcrData.mYChannel     = GetYChannel(aBuffer, aDescriptor);
  ycbcrData.mYStride      = yStride;
  ycbcrData.mYSize        = ySize;
  ycbcrData.mCbChannel    = GetCbChannel(aBuffer, aDescriptor);
  ycbcrData.mCrChannel    = GetCrChannel(aBuffer, aDescriptor);
  ycbcrData.mCbCrStride   = cbCrStride;
  ycbcrData.mCbCrSize     = cbCrSize;
  ycbcrData.mPicSize      = ySize;
  ycbcrData.mYUVColorSpace = aDescriptor.yUVColorSpace();

  gfx::ConvertYCbCrToRGB(ycbcrData, aDestFormat, aDestSize, aDestBuffer, aStride);
}

} // namespace ImageDataSerializer
} // namespace layers
} // namespace mozilla
