/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "SharedRGBImage.h"
#include "ImageTypes.h"         // for ImageFormat::SHARED_RGB, etc
#include "mozilla/ipc/Shmem.h"  // for Shmem
#include "gfx2DGlue.h"          // for ImageFormatToSurfaceFormat, etc
#include "gfxPlatform.h"        // for gfxPlatform, gfxImageFormat
#include "mozilla/gfx/Point.h"  // for IntSIze
#include "mozilla/layers/BufferTexture.h"
#include "mozilla/layers/ISurfaceAllocator.h"  // for ISurfaceAllocator, etc
#include "mozilla/layers/ImageClient.h"        // for ImageClient
#include "mozilla/layers/LayersSurfaces.h"     // for SurfaceDescriptor, etc
#include "mozilla/layers/TextureClient.h"      // for BufferTextureClient, etc
#include "mozilla/layers/TextureClientRecycleAllocator.h"  // for ITextureClientAllocationHelper
#include "mozilla/layers/ImageBridgeChild.h"  // for ImageBridgeChild
#include "mozilla/mozalloc.h"                 // for operator delete, etc
#include "nsDebug.h"                          // for NS_WARNING, NS_ASSERTION
#include "nsISupportsImpl.h"                  // for Image::AddRef, etc
#include "nsProxyRelease.h"
#include "nsRect.h"  // for mozilla::gfx::IntRect

// Just big enough for a 1080p RGBA32 frame
#define MAX_FRAME_SIZE (16 * 1024 * 1024)

namespace mozilla {
namespace layers {

class TextureClientForRawBufferAccessAllocationHelper
    : public ITextureClientAllocationHelper {
 public:
  TextureClientForRawBufferAccessAllocationHelper(gfx::SurfaceFormat aFormat,
                                                  gfx::IntSize aSize,
                                                  TextureFlags aTextureFlags)
      : ITextureClientAllocationHelper(aFormat, aSize, BackendSelector::Content,
                                       aTextureFlags, ALLOC_DEFAULT) {}

  bool IsCompatible(TextureClient* aTextureClient) override {
    bool ret = aTextureClient->GetFormat() == mFormat &&
               aTextureClient->GetSize() == mSize;
    return ret;
  }

  already_AddRefed<TextureClient> Allocate(
      KnowsCompositor* aAllocator) override {
    return TextureClient::CreateForRawBufferAccess(
        aAllocator, mFormat, mSize, gfx::BackendType::NONE, mTextureFlags);
  }
};

SharedRGBImage::SharedRGBImage(ImageClient* aCompositable)
    : Image(nullptr, ImageFormat::SHARED_RGB),
      mCompositable(aCompositable),
      mSourceSurface("SharedRGBImage::mSourceSurface") {
  MOZ_COUNT_CTOR(SharedRGBImage);
}

SharedRGBImage::SharedRGBImage(TextureClientRecycleAllocator* aRecycleAllocator)
    : Image(nullptr, ImageFormat::SHARED_RGB),
      mRecycleAllocator(aRecycleAllocator),
      mSourceSurface("SharedRGBImage::mSourceSurface") {
  MOZ_COUNT_CTOR(SharedRGBImage);
}

SharedRGBImage::~SharedRGBImage() {
  MOZ_COUNT_DTOR(SharedRGBImage);
  RefPtr<gfx::SourceSurface> surface;
  {
    auto guard = mSourceSurface.Lock();
    surface = guard->forget();
  }
  NS_ReleaseOnMainThread("SharedRGBImage::mSourceSurface", surface.forget());
}

TextureClientRecycleAllocator* SharedRGBImage::RecycleAllocator() {
  static const uint32_t MAX_POOLED_VIDEO_COUNT = 5;

  if (!mRecycleAllocator && mCompositable) {
    if (!mCompositable->HasTextureClientRecycler()) {
      // Initialize TextureClientRecycler
      mCompositable->GetTextureClientRecycler()->SetMaxPoolSize(
          MAX_POOLED_VIDEO_COUNT);
    }
    mRecycleAllocator = mCompositable->GetTextureClientRecycler();
  }
  return mRecycleAllocator;
}

bool SharedRGBImage::Allocate(gfx::IntSize aSize, gfx::SurfaceFormat aFormat) {
  mSize = aSize;

  TextureFlags flags =
      mCompositable ? mCompositable->GetTextureFlags() : TextureFlags::DEFAULT;
  {
    TextureClientForRawBufferAccessAllocationHelper helper(aFormat, aSize,
                                                           flags);
    mTextureClient =
        RecycleAllocator()->CreateOrRecycle(helper).unwrapOr(nullptr);
  }

  return !!mTextureClient;
}

gfx::IntSize SharedRGBImage::GetSize() const { return mSize; }

TextureClient* SharedRGBImage::GetTextureClient(
    KnowsCompositor* aKnowsCompositor) {
  return mTextureClient.get();
}

static void ReleaseTextureClient(void* aData) {
  RELEASE_MANUALLY(static_cast<TextureClient*>(aData));
}

static gfx::UserDataKey sTextureClientKey;

already_AddRefed<gfx::SourceSurface> SharedRGBImage::GetAsSourceSurface() {
  auto guard = mSourceSurface.Lock();

  if (*guard) {
    RefPtr<gfx::SourceSurface> surface(*guard);
    return surface.forget();
  }

  RefPtr<gfx::SourceSurface> surface;
  {
    if (!mTextureClient) {
      return nullptr;
    }

    surface = mTextureClient->GetBufferSnapshot();
    if (!surface) {
      return nullptr;
    }

    // The surface may outlive the owning TextureClient. So, we need to ensure
    // that the surface keeps the TextureClient alive via a reference held in
    // user data. The TextureClient's DrawTarget only has a weak reference to
    // the surface, so we won't create any cycles by just referencing the
    // TextureClient.
    if (!surface->GetUserData(&sTextureClientKey)) {
      surface->AddUserData(&sTextureClientKey, mTextureClient,
                           ReleaseTextureClient);
      ADDREF_MANUALLY(mTextureClient);
    }
  }

  *guard = surface;
  return surface.forget();
}

}  // namespace layers
}  // namespace mozilla
