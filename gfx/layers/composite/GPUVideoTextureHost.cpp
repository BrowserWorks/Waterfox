/* -*- Mode: C++; tab-width: 20; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "GPUVideoTextureHost.h"
#include "mozilla/dom/VideoDecoderManagerParent.h"
#include "ImageContainer.h"
#include "mozilla/layers/VideoBridgeParent.h"

namespace mozilla {
namespace layers {

GPUVideoTextureHost::GPUVideoTextureHost(TextureFlags aFlags,
                                         const SurfaceDescriptorGPUVideo& aDescriptor)
  : TextureHost(aFlags)
{
  MOZ_COUNT_CTOR(GPUVideoTextureHost);
  mWrappedTextureHost = VideoBridgeParent::GetSingleton()->LookupTexture(aDescriptor.handle());
}

GPUVideoTextureHost::~GPUVideoTextureHost()
{
  MOZ_COUNT_DTOR(GPUVideoTextureHost);
}

bool
GPUVideoTextureHost::Lock()
{
  if (!mWrappedTextureHost) {
    return false;
  }
  return mWrappedTextureHost->Lock();
}

void
GPUVideoTextureHost::Unlock()
{
  if (!mWrappedTextureHost) {
    return;
  }
  mWrappedTextureHost->Unlock();
}

bool
GPUVideoTextureHost::BindTextureSource(CompositableTextureSourceRef& aTexture)
{
  if (!mWrappedTextureHost) {
    return false;
  }
  return mWrappedTextureHost->BindTextureSource(aTexture);
}

void
GPUVideoTextureHost::SetTextureSourceProvider(TextureSourceProvider* aProvider)
{
  if (mWrappedTextureHost) {
    mWrappedTextureHost->SetTextureSourceProvider(aProvider);
  }
}

YUVColorSpace
GPUVideoTextureHost::GetYUVColorSpace() const
{
  if (mWrappedTextureHost) {
    return mWrappedTextureHost->GetYUVColorSpace();
  }
  return YUVColorSpace::UNKNOWN;
}

gfx::IntSize
GPUVideoTextureHost::GetSize() const
{
  if (!mWrappedTextureHost) {
    return gfx::IntSize();
  }
  return mWrappedTextureHost->GetSize();
}

gfx::SurfaceFormat
GPUVideoTextureHost::GetFormat() const
{
  if (!mWrappedTextureHost) {
    return gfx::SurfaceFormat::UNKNOWN;
  }
  return mWrappedTextureHost->GetFormat();
}

} // namespace layers
} // namespace mozilla
