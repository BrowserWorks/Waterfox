/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef SHAREDRGBIMAGE_H_
#define SHAREDRGBIMAGE_H_

#include <stddef.h>                     // for size_t
#include <stdint.h>                     // for uint8_t
#include "ImageContainer.h"             // for ISharedImage, Image, etc
#include "gfxTypes.h"
#include "mozilla/Attributes.h"         // for override
#include "mozilla/RefPtr.h"             // for RefPtr
#include "mozilla/gfx/Point.h"          // for IntSize
#include "mozilla/gfx/Types.h"          // for SurfaceFormat
#include "nsCOMPtr.h"                   // for already_AddRefed

namespace mozilla {
namespace layers {

class ImageClient;
class TextureClient;

already_AddRefed<Image> CreateSharedRGBImage(ImageContainer* aImageContainer,
                                             gfx::IntSize aSize,
                                             gfxImageFormat aImageFormat);

/**
 * Stores RGB data in shared memory
 * It is assumed that the image width and stride are equal
 */
class SharedRGBImage : public Image
{
public:
  explicit SharedRGBImage(ImageClient* aCompositable);

protected:
  ~SharedRGBImage();

public:
  virtual TextureClient* GetTextureClient(KnowsCompositor* aForwarder) override;

  virtual uint8_t* GetBuffer() override;

  gfx::IntSize GetSize() override;

  already_AddRefed<gfx::SourceSurface> GetAsSourceSurface() override;

  bool Allocate(gfx::IntSize aSize, gfx::SurfaceFormat aFormat);
private:
  gfx::IntSize mSize;
  RefPtr<ImageClient> mCompositable;
  RefPtr<TextureClient> mTextureClient;
};

} // namespace layers
} // namespace mozilla

#endif
