/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef MOZILLA_LAYERS_BUFFERETEXTURE
#define MOZILLA_LAYERS_BUFFERETEXTURE

#include "mozilla/gfx/2D.h"
#include "mozilla/gfx/Types.h"
#include "mozilla/layers/TextureClient.h"
#include "nsCOMPtr.h"
#include "nsISerialEventTarget.h"

namespace mozilla {
namespace layers {

// Keeps a shmem mapping alive independently of TextureClient and IPC teardown.
class ShmemHolder final {
 public:
  NS_INLINE_DECL_THREADSAFE_REFCOUNTING(ShmemHolder)

  ShmemHolder(LayersIPCChannel* aAllocator, ipc::Shmem aShmem);
  ipc::Shmem& GetShmem() { return mShmem; }
  void SetDeallocShmem() { mDeallocShmem = true; }

  const RefPtr<LayersIPCChannel> mAllocator;

 private:
  ~ShmemHolder();

  // Capture while the allocator is usable. GetThread() need not be safe to
  // call from an arbitrary thread during allocator shutdown.
  const nsCOMPtr<nsISerialEventTarget> mDeallocationTarget;
  ipc::Shmem mShmem;
  Atomic<bool> mDeallocShmem{false};
};

class BufferTextureData : public TextureData {
 public:
  // ShmemAllocator needs to implement IShmemAllocator and IsSameProcess,
  // as done in LayersIPCChannel and ISurfaceAllocator.
  template <typename ShmemAllocator>
  static BufferTextureData* Create(
      gfx::IntSize aSize, gfx::SurfaceFormat aFormat,
      gfx::ColorSpace2 aColorSpace, gfx::TransferFunction aTransferFunction,
      gfx::BackendType aMoz2DBackend, LayersBackend aLayersBackend,
      TextureFlags aFlags, TextureAllocationFlags aAllocFlags,
      ShmemAllocator aAllocator);

  static BufferTextureData* CreateForYCbCr(
      KnowsCompositor* aAllocator, const gfx::IntRect& aDisplay,
      const gfx::IntSize& aYSize, uint32_t aYStride,
      const gfx::IntSize& aCbCrSize, uint32_t aCbCrStride,
      StereoMode aStereoMode, gfx::ColorDepth aColorDepth,
      gfx::YUVColorSpace aYUVColorSpace, gfx::ColorRange aColorRange,
      gfx::TransferFunction aTransferFunction,
      gfx::ChromaSubsampling aSubsampling, TextureFlags aTextureFlags,
      const Maybe<gfx::HDRMetadata>& aHDRMetadata = Nothing());

  bool Lock(OpenMode aMode) override { return true; }

  void Unlock() override { mIsClear = false; }

  void FillInfo(TextureData::Info& aInfo) const override;

  already_AddRefed<gfx::DrawTarget> BorrowDrawTarget() override;

  bool BorrowMappedData(MappedTextureData& aMap) override;

  bool BorrowMappedYCbCrData(MappedYCbCrTextureData& aMap) override;

  // use TextureClient's default implementation
  bool UpdateFromSurface(gfx::SourceSurface* aSurface) override;

  BufferTextureData* AsBufferTextureData() override { return this; }

  Maybe<gfx::IntSize> GetYSize() const;

  Maybe<gfx::IntSize> GetCbCrSize() const;

  Maybe<int32_t> GetYStride() const;

  Maybe<int32_t> GetCbCrStride() const;

  Maybe<gfx::ColorSpace2> GetColorSpace2() const;

  Maybe<gfx::YUVColorSpace> GetYUVColorSpace() const;

  Maybe<gfx::ColorDepth> GetColorDepth() const;

  Maybe<gfx::TransferFunction> GetTransferFunction() const;

  Maybe<StereoMode> GetStereoMode() const;

  Maybe<gfx::ChromaSubsampling> GetChromaSubsampling() const;

  gfx::IntRect GetPictureRect() const;

  gfx::IntSize GetSize() const;

  gfx::SurfaceFormat GetFormat() const;

  virtual size_t GetBufferSize() = 0;

  virtual ShmemHolder* GetShmemHolder() { return nullptr; }

  virtual void OnBorrowDrawTarget(gfx::DrawTarget* aDrawTarget) {}

 protected:
  static BufferTextureData* Create(
      gfx::IntSize aSize, gfx::SurfaceFormat aFormat,
      gfx::ColorSpace2 aColorSpace, gfx::TransferFunction aTransferFunction,
      gfx::BackendType aMoz2DBackend, LayersBackend aLayersBackend,
      TextureFlags aFlags, TextureAllocationFlags aAllocFlags,
      LayersIPCChannel* aAllocator, bool aIsSameProcess);

  static BufferTextureData* CreateInternal(LayersIPCChannel* aAllocator,
                                           const BufferDescriptor& aDesc,
                                           gfx::BackendType aMoz2DBackend,
                                           int32_t aBufferSize,
                                           TextureFlags aTextureFlags);

  virtual uint8_t* GetBuffer() = 0;

  BufferTextureData(const BufferDescriptor& aDescriptor,
                    gfx::BackendType aMoz2DBackend, bool aIsClear = false)
      : mDescriptor(aDescriptor),
        mMoz2DBackend(aMoz2DBackend),
        mIsClear(aIsClear) {}

  ~BufferTextureData() override = default;

  BufferDescriptor mDescriptor;
  gfx::BackendType mMoz2DBackend;
  bool mIsClear = false;
};

template <typename ShmemAllocator>
inline BufferTextureData* BufferTextureData::Create(
    gfx::IntSize aSize, gfx::SurfaceFormat aFormat,
    gfx::ColorSpace2 aColorSpace, gfx::TransferFunction aTransferFunction,
    gfx::BackendType aMoz2DBackend, LayersBackend aLayersBackend,
    TextureFlags aFlags, TextureAllocationFlags aAllocFlags,
    ShmemAllocator aAllocator) {
  return Create(aSize, aFormat, aColorSpace, aTransferFunction, aMoz2DBackend,
                aLayersBackend, aFlags, aAllocFlags, aAllocator,
                aAllocator->IsSameProcess());
}

// nullptr allocator specialization
template <>
inline BufferTextureData* BufferTextureData::Create(
    gfx::IntSize aSize, gfx::SurfaceFormat aFormat,
    gfx::ColorSpace2 aColorSpace, gfx::TransferFunction aTransferFunction,
    gfx::BackendType aMoz2DBackend, LayersBackend aLayersBackend,
    TextureFlags aFlags, TextureAllocationFlags aAllocFlags, std::nullptr_t) {
  return Create(aSize, aFormat, aColorSpace, aTransferFunction, aMoz2DBackend,
                aLayersBackend, aFlags, aAllocFlags, nullptr, true);
}

}  // namespace layers
}  // namespace mozilla

#endif
