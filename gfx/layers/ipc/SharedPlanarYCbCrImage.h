/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef GFX_LAYERS_IPC_SHAREDPLANARYCBCRIMAGE_H_
#define GFX_LAYERS_IPC_SHAREDPLANARYCBCRIMAGE_H_

#include <stdint.h>             // for uint8_t, uint32_t
#include "ImageContainer.h"     // for PlanarYCbCrImage, etc
#include "mozilla/RefPtr.h"     // for RefPtr
#include "mozilla/ipc/Shmem.h"  // for Shmem
#include "nsCOMPtr.h"           // for already_AddRefed
#include "nsDebug.h"            // for NS_WARNING
#include "nsISupportsImpl.h"    // for MOZ_COUNT_CTOR

#ifndef MOZILLA_LAYERS_SHAREDPLANARYCBCRIMAGE_H
#  define MOZILLA_LAYERS_SHAREDPLANARYCBCRIMAGE_H

namespace mozilla {
namespace layers {

class ImageClient;
class ShmemHolder;
class TextureClient;
class TextureClientRecycleAllocator;

class SharedPlanarYCbCrImage : public PlanarYCbCrImage {
 public:
  explicit SharedPlanarYCbCrImage(ImageClient* aCompositable);
  explicit SharedPlanarYCbCrImage(
      TextureClientRecycleAllocator* aRecycleAllocator);

 protected:
  virtual ~SharedPlanarYCbCrImage();

 public:
  TextureClient* GetTextureClient(KnowsCompositor* aKnowsCompositor) override;

  already_AddRefed<gfx::SourceSurface> GetAsSourceSurface() override;
  nsresult CopyData(const PlanarYCbCrData& aData) override;
  nsresult AdoptData(const Data& aData) override;
  nsresult CreateEmptyBuffer(const Data& aData, const gfx::IntSize& aYSize,
                             const gfx::IntSize& aCbCrSize) override;

  void SetIsDRM(bool aIsDRM) override;
  bool IsValid() const override;

  size_t SizeOfIncludingThis(MallocSizeOf aMallocSizeOf) const override {
    return aMallocSizeOf(this) + SizeOfExcludingThis(aMallocSizeOf);
  }

  size_t SizeOfExcludingThis(MallocSizeOf aMallocSizeOf) const override;

  TextureClientRecycleAllocator* RecycleAllocator();

 private:
  // Outlives mTextureClient so cached plane pointers retain their mapping even
  // when ImageBridge shutdown destroys the TextureClient explicitly.
  RefPtr<ShmemHolder> mShmemHolder;
  RefPtr<TextureClient> mTextureClient;
  RefPtr<ImageClient> mCompositable;
  RefPtr<TextureClientRecycleAllocator> mRecycleAllocator;
};

}  // namespace layers
}  // namespace mozilla

#endif

#endif  // GFX_LAYERS_IPC_SHAREDPLANARYCBCRIMAGE_H_
