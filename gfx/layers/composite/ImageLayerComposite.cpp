/* -*- Mode: C++; tab-width: 20; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "ImageLayerComposite.h"
#include "CompositableHost.h"           // for CompositableHost
#include "Layers.h"                     // for WriteSnapshotToDumpFile, etc
#include "gfx2DGlue.h"                  // for ToFilter
#include "gfxEnv.h"                     // for gfxEnv
#include "gfxRect.h"                    // for gfxRect
#include "mozilla/Assertions.h"         // for MOZ_ASSERT, etc
#include "mozilla/gfx/Matrix.h"         // for Matrix4x4
#include "mozilla/gfx/Point.h"          // for IntSize, Point
#include "mozilla/gfx/Rect.h"           // for Rect
#include "mozilla/layers/Compositor.h"  // for Compositor
#include "mozilla/layers/Effects.h"     // for EffectChain
#include "mozilla/layers/ImageHost.h"   // for ImageHost
#include "mozilla/layers/TextureHost.h"  // for TextureHost, etc
#include "mozilla/mozalloc.h"           // for operator delete
#include "nsAString.h"
#include "mozilla/RefPtr.h"                   // for nsRefPtr
#include "nsDebug.h"                    // for NS_ASSERTION
#include "nsISupportsImpl.h"            // for MOZ_COUNT_CTOR, etc
#include "nsString.h"                   // for nsAutoCString

namespace mozilla {
namespace layers {

using namespace mozilla::gfx;

ImageLayerComposite::ImageLayerComposite(LayerManagerComposite* aManager)
  : ImageLayer(aManager, nullptr)
  , LayerComposite(aManager)
  , mImageHost(nullptr)
{
  MOZ_COUNT_CTOR(ImageLayerComposite);
  mImplData = static_cast<LayerComposite*>(this);
}

ImageLayerComposite::~ImageLayerComposite()
{
  MOZ_COUNT_DTOR(ImageLayerComposite);
  MOZ_ASSERT(mDestroyed);

  CleanupResources();
}

bool
ImageLayerComposite::SetCompositableHost(CompositableHost* aHost)
{
  switch (aHost->GetType()) {
    case CompositableType::IMAGE:
      mImageHost = static_cast<ImageHost*>(aHost);
      return true;
    default:
      return false;
  }
}

void
ImageLayerComposite::Disconnect()
{
  Destroy();
}

Layer*
ImageLayerComposite::GetLayer()
{
  return this;
}

void
ImageLayerComposite::SetLayerManager(HostLayerManager* aManager)
{
  LayerComposite::SetLayerManager(aManager);
  mManager = aManager;
  if (mImageHost) {
    mImageHost->SetTextureSourceProvider(mCompositor);
  }
}

void
ImageLayerComposite::RenderLayer(const IntRect& aClipRect,
                                 const Maybe<gfx::Polygon>& aGeometry)
{
  if (!mImageHost || !mImageHost->IsAttached()) {
    return;
  }

#ifdef MOZ_DUMP_PAINTING
  if (gfxEnv::DumpCompositorTextures()) {
    RefPtr<gfx::DataSourceSurface> surf = mImageHost->GetAsSurface();
    if (surf) {
      WriteSnapshotToDumpFile(this, surf);
    }
  }
#endif

  mCompositor->MakeCurrent();

  RenderWithAllMasks(this, mCompositor, aClipRect,
                     [&](EffectChain& effectChain, const IntRect& clipRect) {
    mImageHost->SetTextureSourceProvider(mCompositor);
    mImageHost->Composite(mCompositor, this, effectChain,
                          GetEffectiveOpacity(),
                          GetEffectiveTransformForBuffer(),
                          GetSamplingFilter(),
                          clipRect);
  });
  mImageHost->BumpFlashCounter();
}

void
ImageLayerComposite::ComputeEffectiveTransforms(const gfx::Matrix4x4& aTransformToSurface)
{
  gfx::Matrix4x4 local = GetLocalTransform();

  // Snap image edges to pixel boundaries
  gfxRect sourceRect(0, 0, 0, 0);
  if (mImageHost &&
      mImageHost->IsAttached()) {
    IntSize size = mImageHost->GetImageSize();
    sourceRect.SizeTo(size.width, size.height);
  }
  // Snap our local transform first, and snap the inherited transform as well.
  // This makes our snapping equivalent to what would happen if our content
  // was drawn into a PaintedLayer (gfxContext would snap using the local
  // transform, then we'd snap again when compositing the PaintedLayer).
  mEffectiveTransform =
      SnapTransform(local, sourceRect, nullptr) *
      SnapTransformTranslation(aTransformToSurface, nullptr);

  if (mScaleMode != ScaleMode::SCALE_NONE &&
      sourceRect.width != 0.0 && sourceRect.height != 0.0) {
    NS_ASSERTION(mScaleMode == ScaleMode::STRETCH,
                 "No other scalemodes than stretch and none supported yet.");
    local.PreScale(mScaleToSize.width / sourceRect.width,
                   mScaleToSize.height / sourceRect.height, 1.0);

    mEffectiveTransformForBuffer =
        SnapTransform(local, sourceRect, nullptr) *
        SnapTransformTranslation(aTransformToSurface, nullptr);
  } else {
    mEffectiveTransformForBuffer = mEffectiveTransform;
  }

  ComputeEffectiveTransformForMaskLayers(aTransformToSurface);
}

bool
ImageLayerComposite::IsOpaque()
{
  if (!mImageHost ||
      !mImageHost->IsAttached()) {
    return false;
  }

  if (mScaleMode == ScaleMode::STRETCH) {
    return mImageHost->IsOpaque();
  }
  return false;
}

nsIntRegion
ImageLayerComposite::GetFullyRenderedRegion()
{
  if (!mImageHost ||
      !mImageHost->IsAttached()) {
    return GetShadowVisibleRegion().ToUnknownRegion();
  }

  if (mScaleMode == ScaleMode::STRETCH) {
    nsIntRegion shadowVisibleRegion;
    shadowVisibleRegion.And(GetShadowVisibleRegion().ToUnknownRegion(), nsIntRegion(gfx::IntRect(0, 0, mScaleToSize.width, mScaleToSize.height)));
    return shadowVisibleRegion;
  }

  return GetShadowVisibleRegion().ToUnknownRegion();
}

CompositableHost*
ImageLayerComposite::GetCompositableHost()
{
  if (mImageHost && mImageHost->IsAttached()) {
    return mImageHost.get();
  }

  return nullptr;
}

void
ImageLayerComposite::CleanupResources()
{
  if (mImageHost) {
    mImageHost->CleanupResources();
    mImageHost->Detach(this);
  }
  mImageHost = nullptr;
}

gfx::SamplingFilter
ImageLayerComposite::GetSamplingFilter()
{
  return mSamplingFilter;
}

void
ImageLayerComposite::GenEffectChain(EffectChain& aEffect)
{
  aEffect.mLayerRef = this;
  aEffect.mPrimaryEffect = mImageHost->GenEffect(GetSamplingFilter());
}

void
ImageLayerComposite::PrintInfo(std::stringstream& aStream, const char* aPrefix)
{
  ImageLayer::PrintInfo(aStream, aPrefix);
  if (mImageHost && mImageHost->IsAttached()) {
    aStream << "\n";
    nsAutoCString pfx(aPrefix);
    pfx += "  ";
    mImageHost->PrintInfo(aStream, pfx.get());
  }
}

} // namespace layers
} // namespace mozilla
