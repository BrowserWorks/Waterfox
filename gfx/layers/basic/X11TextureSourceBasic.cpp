/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "X11TextureSourceBasic.h"
#include "gfxXlibSurface.h"
#include "gfx2DGlue.h"

namespace mozilla::layers {

using namespace mozilla::gfx;

X11TextureSourceBasic::X11TextureSourceBasic(BasicCompositor* aCompositor,
                                             gfxXlibSurface* aSurface)
    : mSurface(aSurface) {}

IntSize X11TextureSourceBasic::GetSize() const { return mSurface->GetSize(); }

SurfaceFormat X11TextureSourceBasic::GetFormat() const {
  gfxContentType type = mSurface->GetContentType();
  return X11TextureSourceBasic::ContentTypeToSurfaceFormat(type);
}

SourceSurface* X11TextureSourceBasic::GetSurface(DrawTarget* aTarget) {
  if (!mSourceSurface) {
    mSourceSurface = Factory::CreateSourceSurfaceForCairoSurface(
        mSurface->CairoSurface(), GetSize(), GetFormat());
  }
  return mSourceSurface;
}

SurfaceFormat X11TextureSourceBasic::ContentTypeToSurfaceFormat(
    gfxContentType aType) {
  switch (aType) {
    case gfxContentType::COLOR:
      return SurfaceFormat::B8G8R8X8;
    case gfxContentType::ALPHA:
      return SurfaceFormat::A8;
    case gfxContentType::COLOR_ALPHA:
      return SurfaceFormat::B8G8R8A8;
    default:
      return SurfaceFormat::UNKNOWN;
  }
}

}  // namespace mozilla::layers
