/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "BufferTexture.h"

#include <utility>

#include "libyuv.h"
#include "mozilla/fallible.h"
#include "mozilla/gfx/2D.h"
#include "mozilla/gfx/Logging.h"
#include "mozilla/layers/CompositableForwarder.h"
#include "mozilla/layers/ISurfaceAllocator.h"
#include "mozilla/layers/ImageDataSerializer.h"
#include "mozilla/layers/TextureForwarder.h"
#include "nsThreadUtils.h"

#include "gfxPlatform.h"

#ifdef MOZ_WIDGET_GTK
#  include "gfxPlatformGtk.h"
#endif

using mozilla::ipc::IShmemAllocator;

namespace mozilla {
namespace layers {

ShmemHolder::ShmemHolder(LayersIPCChannel* aAllocator, ipc::Shmem aShmem)
    : mAllocator(aAllocator),
      mDeallocationTarget(aAllocator->GetThread()),
      mShmem(std::move(aShmem)) {}

ShmemHolder::~ShmemHolder() {
  if (!mDeallocShmem) {
    return;
  }

  // The Image may outlive both its TextureClient and the allocator thread.
  // Only touch the IPC shmem registry on the allocator thread while IPC is
  // open. Otherwise dropping mShmem releases our local mapping; IPC teardown
  // releases the registry's reference independently.
  // Use the target retained at construction rather than querying the
  // allocator after its thread may have been shut down.
  if (!mDeallocationTarget) {
    return;
  }

  RefPtr<Runnable> task = NS_NewRunnableFunction(
      "ShmemHolder::DeallocShmem",
      [allocator = mAllocator, shmem = mShmem]() mutable {
        if (allocator->IPCOpen()) {
          allocator->DeallocShmem(shmem);
        }
      });
  if (mDeallocationTarget->IsOnCurrentThread()) {
    task->Run();
  } else {
    // If dispatch fails, destroying the task still releases its local mapping.
    (void)mDeallocationTarget->Dispatch(task.forget());
  }
}

class MemoryTextureData : public BufferTextureData {
 public:
  static MemoryTextureData* Create(
      gfx::IntSize aSize, gfx::SurfaceFormat aFormat,
      gfx::ColorSpace2 aColorSpace, gfx::TransferFunction aTransferFunction,
      gfx::BackendType aMoz2DBackend, LayersBackend aLayersBackend,
      TextureFlags aFlags, TextureAllocationFlags aAllocFlags,
      IShmemAllocator* aAllocator);

  virtual TextureData* CreateSimilar(
      LayersIPCChannel* aAllocator, LayersBackend aLayersBackend,
      TextureFlags aFlags = TextureFlags::DEFAULT,
      TextureAllocationFlags aAllocFlags = ALLOC_DEFAULT) const override;

  virtual bool Serialize(SurfaceDescriptor& aOutDescriptor) override;

  virtual void Deallocate(LayersIPCChannel*) override;

  MemoryTextureData(const BufferDescriptor& aDesc,
                    gfx::BackendType aMoz2DBackend, uint8_t* aBuffer,
                    size_t aBufferSize, bool aAutoDeallocate = false,
                    bool aIsClear = false)
      : BufferTextureData(aDesc, aMoz2DBackend, aIsClear),
        mBuffer(aBuffer),
        mBufferSize(aBufferSize),
        mAutoDeallocate(aAutoDeallocate) {
    MOZ_ASSERT(aBuffer);
    MOZ_ASSERT(aBufferSize);
  }

  virtual ~MemoryTextureData() override {
    if (mAutoDeallocate) {
      Deallocate(nullptr);
    }
  }

  virtual uint8_t* GetBuffer() override { return mBuffer; }

  virtual size_t GetBufferSize() override { return mBufferSize; }

  TextureType GetTextureType() const override { return TextureType::Unknown; }

 protected:
  uint8_t* mBuffer;
  size_t mBufferSize;
  bool mAutoDeallocate;
};

class ShmemTextureData : public BufferTextureData {
 public:
  static ShmemTextureData* Create(
      gfx::IntSize aSize, gfx::SurfaceFormat aFormat,
      gfx::ColorSpace2 aColorSpace, gfx::TransferFunction aTransferFunction,
      gfx::BackendType aMoz2DBackend, LayersBackend aLayersBackend,
      TextureFlags aFlags, TextureAllocationFlags aAllocFlags,
      LayersIPCChannel* aAllocator);

  virtual TextureData* CreateSimilar(
      LayersIPCChannel* aAllocator, LayersBackend aLayersBackend,
      TextureFlags aFlags = TextureFlags::DEFAULT,
      TextureAllocationFlags aAllocFlags = ALLOC_DEFAULT) const override;

  virtual bool Serialize(SurfaceDescriptor& aOutDescriptor) override;

  virtual void Deallocate(LayersIPCChannel* aAllocator) override;

  ShmemTextureData(const BufferDescriptor& aDesc,
                   gfx::BackendType aMoz2DBackend,
                   RefPtr<ShmemHolder>& aShmemHolder, bool aIsClear = false)
      : BufferTextureData(aDesc, aMoz2DBackend, aIsClear),
        mShmemHolder(aShmemHolder) {
    MOZ_ASSERT(mShmemHolder);
    MOZ_ASSERT(mShmemHolder->GetShmem().Size<uint8_t>());
  }

  virtual uint8_t* GetBuffer() override {
    return mShmemHolder->GetShmem().get<uint8_t>();
  }

  virtual size_t GetBufferSize() override {
    return mShmemHolder->GetShmem().Size<uint8_t>();
  }

  virtual void OnBorrowDrawTarget(gfx::DrawTarget* aDrawTarget) override;

  ShmemHolder* GetShmemHolder() override { return mShmemHolder; }

 protected:
  const RefPtr<ShmemHolder> mShmemHolder;
};

BufferTextureData* BufferTextureData::Create(
    gfx::IntSize aSize, gfx::SurfaceFormat aFormat,
    gfx::ColorSpace2 aColorSpace, gfx::TransferFunction aTransferFunction,
    gfx::BackendType aMoz2DBackend, LayersBackend aLayersBackend,
    TextureFlags aFlags, TextureAllocationFlags aAllocFlags,
    LayersIPCChannel* aAllocator, bool aIsSameProcess) {
  if (!aAllocator || aIsSameProcess) {
    return MemoryTextureData::Create(
        aSize, aFormat, aColorSpace, aTransferFunction, aMoz2DBackend,
        aLayersBackend, aFlags, aAllocFlags, aAllocator);
  } else {
    return ShmemTextureData::Create(
        aSize, aFormat, aColorSpace, aTransferFunction, aMoz2DBackend,
        aLayersBackend, aFlags, aAllocFlags, aAllocator);
  }
}

BufferTextureData* BufferTextureData::CreateInternal(
    LayersIPCChannel* aAllocator, const BufferDescriptor& aDesc,
    gfx::BackendType aMoz2DBackend, int32_t aBufferSize,
    TextureFlags aTextureFlags) {
  if (!aAllocator || aAllocator->IsSameProcess()) {
    uint8_t* buffer = new (fallible) uint8_t[aBufferSize];
    if (!buffer) {
      return nullptr;
    }

    GfxMemoryImageReporter::DidAlloc(buffer);

    return new MemoryTextureData(aDesc, aMoz2DBackend, buffer, aBufferSize);
  } else {
    ipc::Shmem shm;
    if (!aAllocator->AllocUnsafeShmem(aBufferSize, &shm)) {
      return nullptr;
    }

    bool isClear = aDesc.type() == BufferDescriptor::TRGBDescriptor &&
                   !IsOpaque(aDesc.get_RGBDescriptor().format());
    RefPtr shmemHolder = MakeRefPtr<ShmemHolder>(aAllocator, shm);
    return new ShmemTextureData(aDesc, aMoz2DBackend, shmemHolder, isClear);
  }
}

BufferTextureData* BufferTextureData::CreateForYCbCr(
    KnowsCompositor* aAllocator, const gfx::IntRect& aDisplay,
    const gfx::IntSize& aYSize, uint32_t aYStride,
    const gfx::IntSize& aCbCrSize, uint32_t aCbCrStride, StereoMode aStereoMode,
    gfx::ColorDepth aColorDepth, gfx::YUVColorSpace aYUVColorSpace,
    gfx::ColorRange aColorRange, gfx::TransferFunction aTransferFunction,
    gfx::ChromaSubsampling aSubsampling, TextureFlags aTextureFlags,
    const Maybe<gfx::HDRMetadata>& aHDRMetadata) {
  Maybe<uint32_t> bufSize = ImageDataSerializer::ComputeYCbCrBufferSize(
      aDisplay, aYSize, aYStride, aCbCrSize, aCbCrStride, aColorDepth,
      aSubsampling);
  if (bufSize.isNothing()) {
    return nullptr;
  }

  uint32_t yOffset;
  uint32_t cbOffset;
  uint32_t crOffset;
  ImageDataSerializer::ComputeYCbCrOffsets(aYStride, aYSize.height, aCbCrStride,
                                           aCbCrSize.height, yOffset, cbOffset,
                                           crOffset);

  YCbCrDescriptor descriptor = YCbCrDescriptor(
      aDisplay, aYSize, aYStride, aCbCrSize, aCbCrStride, yOffset, cbOffset,
      crOffset, aStereoMode, aColorDepth, aYUVColorSpace, aColorRange,
      aTransferFunction, aSubsampling, aHDRMetadata);

  return CreateInternal(
      aAllocator ? aAllocator->GetTextureForwarder().get() : nullptr,
      descriptor, gfx::BackendType::NONE, bufSize.value(), aTextureFlags);
}

void BufferTextureData::FillInfo(TextureData::Info& aInfo) const {
  aInfo.size = GetSize();
  aInfo.format = GetFormat();
  aInfo.hasSynchronization = false;
  aInfo.canExposeMappedData = true;

  switch (aInfo.format) {
    case gfx::SurfaceFormat::YUV420:
    case gfx::SurfaceFormat::UNKNOWN:
      aInfo.supportsMoz2D = false;
      break;
    default:
      aInfo.supportsMoz2D = true;
  }
}

gfx::IntSize BufferTextureData::GetSize() const {
  return ImageDataSerializer::SizeFromBufferDescriptor(mDescriptor);
}

gfx::IntRect BufferTextureData::GetPictureRect() const {
  return ImageDataSerializer::RectFromBufferDescriptor(mDescriptor);
}

Maybe<gfx::IntSize> BufferTextureData::GetYSize() const {
  return ImageDataSerializer::YSizeFromBufferDescriptor(mDescriptor);
}

Maybe<gfx::IntSize> BufferTextureData::GetCbCrSize() const {
  return ImageDataSerializer::CbCrSizeFromBufferDescriptor(mDescriptor);
}

Maybe<int32_t> BufferTextureData::GetYStride() const {
  return ImageDataSerializer::YStrideFromBufferDescriptor(mDescriptor);
}

Maybe<int32_t> BufferTextureData::GetCbCrStride() const {
  return ImageDataSerializer::CbCrStrideFromBufferDescriptor(mDescriptor);
}

Maybe<gfx::ColorSpace2> BufferTextureData::GetColorSpace2() const {
  return ImageDataSerializer::ColorSpace2FromBufferDescriptor(mDescriptor);
}

Maybe<gfx::YUVColorSpace> BufferTextureData::GetYUVColorSpace() const {
  return ImageDataSerializer::YUVColorSpaceFromBufferDescriptor(mDescriptor);
}

Maybe<gfx::ColorDepth> BufferTextureData::GetColorDepth() const {
  return ImageDataSerializer::ColorDepthFromBufferDescriptor(mDescriptor);
}

Maybe<StereoMode> BufferTextureData::GetStereoMode() const {
  return ImageDataSerializer::StereoModeFromBufferDescriptor(mDescriptor);
}

Maybe<gfx::ChromaSubsampling> BufferTextureData::GetChromaSubsampling() const {
  return ImageDataSerializer::ChromaSubsamplingFromBufferDescriptor(
      mDescriptor);
}

Maybe<gfx::TransferFunction> BufferTextureData::GetTransferFunction() const {
  return ImageDataSerializer::TransferFunctionFromBufferDescriptor(mDescriptor);
}

gfx::SurfaceFormat BufferTextureData::GetFormat() const {
  return ImageDataSerializer::FormatFromBufferDescriptor(mDescriptor);
}

struct ShmemHolderUserData {
  explicit ShmemHolderUserData(ShmemHolder* aShmemHolder)
      : mShmemHolder(aShmemHolder) {}
  ~ShmemHolderUserData() = default;
  RefPtr<ShmemHolder> mShmemHolder;
};

void DeleteShmemHolderUserData(void* aClosure) {
  ShmemHolderUserData* data = reinterpret_cast<ShmemHolderUserData*>(aClosure);
  delete data;
}

static gfx::UserDataKey sShmemHolderKey = {0};

void ShmemTextureData::OnBorrowDrawTarget(gfx::DrawTarget* aDrawTarget) {
  if (!aDrawTarget) {
    return;
  }
  auto* data = new ShmemHolderUserData(mShmemHolder);
  aDrawTarget->AddUserData(&sShmemHolderKey, data, DeleteShmemHolderUserData);
}

already_AddRefed<gfx::DrawTarget> BufferTextureData::BorrowDrawTarget() {
  if (mDescriptor.type() != BufferDescriptor::TRGBDescriptor) {
    return nullptr;
  }

  const RGBDescriptor& rgb = mDescriptor.get_RGBDescriptor();

  auto stride = ImageDataSerializer::GetRGBStride(rgb);
  if (stride.isNothing()) {
    return nullptr;
  }

  RefPtr<gfx::DrawTarget> dt;
  if (gfx::Factory::DoesBackendSupportDataDrawtarget(mMoz2DBackend)) {
    dt = gfx::Factory::CreateDrawTargetForData(mMoz2DBackend, GetBuffer(),
                                               rgb.size(), stride.value(),
                                               rgb.format(), true, mIsClear);
  }
  if (!dt) {
    // Fall back to supported platform backend.  Note that mMoz2DBackend
    // does not match the draw target type.
    dt = gfxPlatform::CreateDrawTargetForData(
        GetBuffer(), rgb.size(), stride.value(), rgb.format(), true, mIsClear);
  }

  if (!dt) {
    gfxCriticalNote << "BorrowDrawTarget failure, original backend "
                    << (int)mMoz2DBackend;
  }

  OnBorrowDrawTarget(dt);
  return dt.forget();
}

bool BufferTextureData::BorrowMappedData(MappedTextureData& aData) {
  if (GetFormat() == gfx::SurfaceFormat::YUV420) {
    return false;
  }

  gfx::IntSize size = GetSize();

  auto stride = ImageDataSerializer::ComputeRGBStride(GetFormat(), size.width);
  if (stride.isNothing()) {
    return false;
  }

  aData.data = GetBuffer();
  aData.size = size;
  aData.format = GetFormat();
  aData.stride = stride.value();
  mIsClear = false;

  return true;
}

bool BufferTextureData::BorrowMappedYCbCrData(MappedYCbCrTextureData& aMap) {
  if (mDescriptor.type() != BufferDescriptor::TYCbCrDescriptor) {
    return false;
  }

  const YCbCrDescriptor& desc = mDescriptor.get_YCbCrDescriptor();

  uint8_t* data = GetBuffer();
  auto ySize = desc.ySize();
  auto cbCrSize = desc.cbCrSize();

  aMap.stereoMode = desc.stereoMode();
  aMap.metadata = nullptr;
  uint32_t bytesPerPixel =
      BytesPerPixel(SurfaceFormatForColorDepth(desc.colorDepth()));

  aMap.y.data = data + desc.yOffset();
  aMap.y.size = ySize;
  aMap.y.stride = desc.yStride();
  aMap.y.skip = 0;
  aMap.y.bytesPerPixel = bytesPerPixel;

  aMap.cb.data = data + desc.cbOffset();
  aMap.cb.size = cbCrSize;
  aMap.cb.stride = desc.cbCrStride();
  aMap.cb.skip = 0;
  aMap.cb.bytesPerPixel = bytesPerPixel;

  aMap.cr.data = data + desc.crOffset();
  aMap.cr.size = cbCrSize;
  aMap.cr.stride = desc.cbCrStride();
  aMap.cr.skip = 0;
  aMap.cr.bytesPerPixel = bytesPerPixel;

  return true;
}

bool BufferTextureData::UpdateFromSurface(gfx::SourceSurface* aSurface) {
  if (mDescriptor.type() != BufferDescriptor::TRGBDescriptor) {
    return false;
  }
  const RGBDescriptor& rgb = mDescriptor.get_RGBDescriptor();

  auto stride = ImageDataSerializer::GetRGBStride(rgb);
  if (stride.isNothing()) {
    gfxCriticalError() << "Invalid stride!";
    return false;
  }

  RefPtr<gfx::DataSourceSurface> surface =
      gfx::Factory::CreateWrappingDataSourceSurface(GetBuffer(), stride.value(),
                                                    rgb.size(), rgb.format());

  if (!surface) {
    gfxCriticalError() << "Failed to get serializer as surface!";
    return false;
  }

  RefPtr<gfx::DataSourceSurface> srcSurf = aSurface->GetDataSurface();

  if (!srcSurf) {
    gfxCriticalError() << "Failed to GetDataSurface in UpdateFromSurface (BT).";
    return false;
  }

  if (surface->GetSize() != srcSurf->GetSize() ||
      surface->GetFormat() != srcSurf->GetFormat()) {
    gfxCriticalError() << "Attempt to update texture client from a surface "
                          "with a different size or format (BT)! This: "
                       << surface->GetSize() << " " << surface->GetFormat()
                       << " Other: " << aSurface->GetSize() << " "
                       << aSurface->GetFormat();
    return false;
  }

  gfx::DataSourceSurface::MappedSurface sourceMap;
  gfx::DataSourceSurface::MappedSurface destMap;
  if (!srcSurf->Map(gfx::DataSourceSurface::READ, &sourceMap)) {
    gfxCriticalError()
        << "Failed to map source surface for UpdateFromSurface (BT).";
    return false;
  }

  if (!surface->Map(gfx::DataSourceSurface::WRITE, &destMap)) {
    srcSurf->Unmap();
    gfxCriticalError()
        << "Failed to map destination surface for UpdateFromSurface.";
    return false;
  }

  for (int y = 0; y < srcSurf->GetSize().height; y++) {
    memcpy(destMap.mData + destMap.mStride * y,
           sourceMap.mData + sourceMap.mStride * y,
           srcSurf->GetSize().width * BytesPerPixel(srcSurf->GetFormat()));
  }

  srcSurf->Unmap();
  surface->Unmap();

  mIsClear = false;

  return true;
}

bool MemoryTextureData::Serialize(SurfaceDescriptor& aOutDescriptor) {
  MOZ_ASSERT(GetFormat() != gfx::SurfaceFormat::UNKNOWN);
  if (GetFormat() == gfx::SurfaceFormat::UNKNOWN) {
    return false;
  }

  uintptr_t ptr = reinterpret_cast<uintptr_t>(mBuffer);
  aOutDescriptor = SurfaceDescriptorBuffer(mDescriptor, MemoryOrShmem(ptr));

  return true;
}

static bool InitBuffer(uint8_t* buf, size_t bufSize, gfx::SurfaceFormat aFormat,
                       TextureAllocationFlags aAllocFlags, bool aAlreadyZero) {
  if (!buf) {
    gfxDebug() << "BufferTextureData: Failed to allocate " << bufSize
               << " bytes";
    return false;
  }

  if (aAllocFlags & ALLOC_CLEAR_BUFFER) {
    if (aFormat == gfx::SurfaceFormat::B8G8R8X8) {
      // Even though BGRX was requested, XRGB_UINT32 is what is meant,
      // so use 0xFF000000 to put alpha in the right place.
      libyuv::ARGBRect(buf, bufSize, 0, 0, bufSize / sizeof(uint32_t), 1,
                       0xFF000000);
    } else if (!aAlreadyZero) {
      memset(buf, 0, bufSize);
    }
  }

  return true;
}

MemoryTextureData* MemoryTextureData::Create(
    gfx::IntSize aSize, gfx::SurfaceFormat aFormat,
    gfx::ColorSpace2 aColorSpace, gfx::TransferFunction aTransferFunction,
    gfx::BackendType aMoz2DBackend, LayersBackend aLayersBackend,
    TextureFlags aFlags, TextureAllocationFlags aAllocFlags,
    IShmemAllocator* aAllocator) {
  // Should have used CreateForYCbCr.
  MOZ_ASSERT(aFormat != gfx::SurfaceFormat::YUV420);

  if (aSize.width <= 0 || aSize.height <= 0) {
    gfxDebug() << "Asking for buffer of invalid size " << aSize.width << "x"
               << aSize.height;
    return nullptr;
  }

  Maybe<uint32_t> bufSize =
      ImageDataSerializer::ComputeRGBBufferSize(aSize, aFormat);
  if (bufSize.isNothing()) {
    return nullptr;
  }

  uint8_t* buf = new (fallible) uint8_t[bufSize.value()];
  if (!InitBuffer(buf, bufSize.value(), aFormat, aAllocFlags, false)) {
    return nullptr;
  }

  GfxMemoryImageReporter::DidAlloc(buf);

  BufferDescriptor descriptor =
      RGBDescriptor(aSize, aFormat, aColorSpace, aTransferFunction);

  // Remote textures are not managed by a texture client, so we need to ensure
  // that memory is freed when the owning MemoryTextureData goes away.
  bool autoDeallocate = !!(aFlags & TextureFlags::REMOTE_TEXTURE);
  bool isClear = (aAllocFlags & ALLOC_CLEAR_BUFFER) != 0;
  return new MemoryTextureData(descriptor, aMoz2DBackend, buf, bufSize.value(),
                               autoDeallocate, isClear);
}

void MemoryTextureData::Deallocate(LayersIPCChannel*) {
  MOZ_ASSERT(mBuffer);
  GfxMemoryImageReporter::WillFree(mBuffer);
  delete[] mBuffer;
  mBuffer = nullptr;
}

TextureData* MemoryTextureData::CreateSimilar(
    LayersIPCChannel* aAllocator, LayersBackend aLayersBackend,
    TextureFlags aFlags, TextureAllocationFlags aAllocFlags) const {
  const auto colorSpace = GetColorSpace2().valueOr(gfx::ColorSpace2::SRGB);
  const auto transferFunction =
      GetTransferFunction().valueOr(gfx::TransferFunction::SRGB);
  return MemoryTextureData::Create(
      GetSize(), GetFormat(), colorSpace, transferFunction, mMoz2DBackend,
      aLayersBackend, aFlags, aAllocFlags, aAllocator);
}

bool ShmemTextureData::Serialize(SurfaceDescriptor& aOutDescriptor) {
  MOZ_ASSERT(GetFormat() != gfx::SurfaceFormat::UNKNOWN);
  if (GetFormat() == gfx::SurfaceFormat::UNKNOWN) {
    return false;
  }

  aOutDescriptor = SurfaceDescriptorBuffer(
      mDescriptor, MemoryOrShmem(mShmemHolder->GetShmem()));

  return true;
}

ShmemTextureData* ShmemTextureData::Create(
    gfx::IntSize aSize, gfx::SurfaceFormat aFormat,
    gfx::ColorSpace2 aColorSpace, gfx::TransferFunction aTransferFunction,
    gfx::BackendType aMoz2DBackend, LayersBackend aLayersBackend,
    TextureFlags aFlags, TextureAllocationFlags aAllocFlags,
    LayersIPCChannel* aAllocator) {
  MOZ_ASSERT(aAllocator);
  // Should have used CreateForYCbCr.
  MOZ_ASSERT(aFormat != gfx::SurfaceFormat::YUV420);
  MOZ_ASSERT(!(aFlags & TextureFlags::DEALLOCATE_CLIENT));

  if (!aAllocator) {
    return nullptr;
  }

  if (aSize.width <= 0 || aSize.height <= 0) {
    gfxDebug() << "Asking for buffer of invalid size " << aSize.width << "x"
               << aSize.height;
    return nullptr;
  }

  Maybe<uint32_t> bufSize =
      ImageDataSerializer::ComputeRGBBufferSize(aSize, aFormat);
  if (bufSize.isNothing()) {
    return nullptr;
  }

  mozilla::ipc::Shmem shm;
  if (!aAllocator->AllocUnsafeShmem(bufSize.value(), &shm)) {
    return nullptr;
  }

  uint8_t* buf = shm.get<uint8_t>();
  if (!InitBuffer(buf, bufSize.value(), aFormat, aAllocFlags, true)) {
    return nullptr;
  }

  BufferDescriptor descriptor =
      RGBDescriptor(aSize, aFormat, aColorSpace, aTransferFunction);
  bool isClear = (aAllocFlags & ALLOC_CLEAR_BUFFER) || !IsOpaque(aFormat);
  RefPtr shmemHolder = MakeRefPtr<ShmemHolder>(aAllocator, shm);
  return new ShmemTextureData(descriptor, aMoz2DBackend, shmemHolder, isClear);
}

TextureData* ShmemTextureData::CreateSimilar(
    LayersIPCChannel* aAllocator, LayersBackend aLayersBackend,
    TextureFlags aFlags, TextureAllocationFlags aAllocFlags) const {
  const auto colorSpace = GetColorSpace2().valueOr(gfx::ColorSpace2::SRGB);
  const auto transferFunction =
      GetTransferFunction().valueOr(gfx::TransferFunction::SRGB);
  return ShmemTextureData::Create(
      GetSize(), GetFormat(), colorSpace, transferFunction, mMoz2DBackend,
      aLayersBackend, aFlags, aAllocFlags, aAllocator);
}

void ShmemTextureData::Deallocate(LayersIPCChannel* aAllocator) {
  if (!aAllocator) {
    gfxCriticalNote << "No allocator in ShmemTextureData::Deallocate";
    return;
  }
  MOZ_ASSERT(aAllocator == mShmemHolder->mAllocator);
  mShmemHolder->SetDeallocShmem();
}

}  // namespace layers
}  // namespace mozilla
