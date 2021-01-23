/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "TiledContentHost.h"
#include "PaintedLayerComposite.h"      // for PaintedLayerComposite
#include "mozilla/gfx/BaseSize.h"       // for BaseSize
#include "mozilla/gfx/Matrix.h"         // for Matrix4x4
#include "mozilla/gfx/Point.h"          // for IntSize
#include "mozilla/layers/Compositor.h"  // for Compositor
// clang-format off
//#include "mozilla/layers/CompositorBridgeParent.h"  // for CompositorBridgeParent
// clang-format on
#include "mozilla/layers/Effects.h"  // for TexturedEffect, Effect, etc
#include "mozilla/layers/LayerMetricsWrapper.h"  // for LayerMetricsWrapper
#include "mozilla/layers/PTextureParent.h"
#include "mozilla/layers/TextureHostOGL.h"  // for TextureHostOGL
#ifdef XP_DARWIN
#  include "mozilla/layers/TextureSync.h"  // for TextureSync
#endif
#include "nsAString.h"
#include "nsDebug.h"          // for NS_WARNING
#include "nsPoint.h"          // for IntPoint
#include "nsPrintfCString.h"  // for nsPrintfCString
#include "nsRect.h"           // for IntRect
#include "mozilla/StaticPrefs_layers.h"
#include "mozilla/layers/TextureClient.h"

namespace mozilla {
using namespace gfx;
namespace layers {

class Layer;

float TileHost::GetFadeInOpacity(float aOpacity) {
  TimeStamp now = TimeStamp::Now();
  if (!StaticPrefs::layers_tiles_fade_in_enabled() || mFadeStart.IsNull() ||
      now < mFadeStart) {
    return aOpacity;
  }

  float duration = StaticPrefs::layers_tiles_fade_in_duration_ms();
  float elapsed = (now - mFadeStart).ToMilliseconds();
  if (elapsed > duration) {
    mFadeStart = TimeStamp();
    return aOpacity;
  }
  return aOpacity * (elapsed / duration);
}

RefPtr<TextureSource> TileHost::AcquireTextureSource() const {
  if (!mTextureHost || !mTextureHost->AcquireTextureSource(mTextureSource)) {
    return nullptr;
  }
  return mTextureSource.get();
}

RefPtr<TextureSource> TileHost::AcquireTextureSourceOnWhite() const {
  if (!mTextureHostOnWhite ||
      !mTextureHostOnWhite->AcquireTextureSource(mTextureSourceOnWhite)) {
    return nullptr;
  }
  return mTextureSourceOnWhite.get();
}

TiledLayerBufferComposite::TiledLayerBufferComposite() : mFrameResolution() {}

TiledLayerBufferComposite::~TiledLayerBufferComposite() { Clear(); }

void TiledLayerBufferComposite::SetTextureSourceProvider(
    TextureSourceProvider* aProvider) {
  MOZ_ASSERT(aProvider);
  for (TileHost& tile : mRetainedTiles) {
    if (tile.IsPlaceholderTile()) continue;
    tile.mTextureHost->SetTextureSourceProvider(aProvider);
    if (tile.mTextureHostOnWhite) {
      tile.mTextureHostOnWhite->SetTextureSourceProvider(aProvider);
    }
  }
}

void TiledLayerBufferComposite::AddAnimationInvalidation(nsIntRegion& aRegion) {
  // We need to invalidate rects where we have a tile that is in the
  // process of fading in.
  for (size_t i = 0; i < mRetainedTiles.Length(); i++) {
    if (!mRetainedTiles[i].mFadeStart.IsNull()) {
      TileCoordIntPoint coord = mTiles.TileCoord(i);
      IntPoint offset = GetTileOffset(coord);
      nsIntRegion tileRegion = IntRect(offset, GetScaledTileSize());
      aRegion.OrWith(tileRegion);
    }
  }
}

TiledContentHost::TiledContentHost(const TextureInfo& aTextureInfo)
    : ContentHost(aTextureInfo),
      mTiledBuffer(TiledLayerBufferComposite()),
      mLowPrecisionTiledBuffer(TiledLayerBufferComposite()) {
  MOZ_COUNT_CTOR(TiledContentHost);
}

TiledContentHost::~TiledContentHost() { MOZ_COUNT_DTOR(TiledContentHost); }

already_AddRefed<TexturedEffect> TiledContentHost::GenEffect(
    const gfx::SamplingFilter aSamplingFilter) {
  MOZ_ASSERT(mTiledBuffer.GetTileCount() == 1 &&
             mLowPrecisionTiledBuffer.GetTileCount() == 0);
  MOZ_ASSERT(mTiledBuffer.GetTile(0).mTextureHost);

  TileHost& tile = mTiledBuffer.GetTile(0);
  if (!tile.mTextureHost->BindTextureSource(tile.mTextureSource)) {
    return nullptr;
  }

  return CreateTexturedEffect(tile.mTextureSource, nullptr, aSamplingFilter,
                              true);
}

void TiledContentHost::Attach(Layer* aLayer, TextureSourceProvider* aProvider,
                              AttachFlags aFlags /* = NO_FLAGS */) {
  CompositableHost::Attach(aLayer, aProvider, aFlags);
}

void TiledContentHost::Detach(Layer* aLayer,
                              AttachFlags aFlags /* = NO_FLAGS */) {
  if (!mKeepAttached || aLayer == mLayer || aFlags & FORCE_DETACH) {
    // Clear the TiledLayerBuffers, which will take care of releasing the
    // copy-on-write locks.
    mTiledBuffer.Clear();
    mLowPrecisionTiledBuffer.Clear();
  }
  CompositableHost::Detach(aLayer, aFlags);
}

bool TiledContentHost::UseTiledLayerBuffer(
    ISurfaceAllocator* aAllocator,
    const SurfaceDescriptorTiles& aTiledDescriptor) {
  HostLayerManager* lm = GetLayerManager();
  if (!lm) {
    return false;
  }

  if (aTiledDescriptor.resolution() < 1) {
    if (!mLowPrecisionTiledBuffer.UseTiles(aTiledDescriptor, lm, aAllocator)) {
      return false;
    }
  } else {
    if (!mTiledBuffer.UseTiles(aTiledDescriptor, lm, aAllocator)) {
      return false;
    }
  }
  return true;
}

static void UseTileTexture(CompositableTextureHostRef& aTexture,
                           CompositableTextureSourceRef& aTextureSource,
                           const IntRect& aUpdateRect,
                           TextureSourceProvider* aProvider) {
  MOZ_ASSERT(aTexture);
  if (!aTexture) {
    return;
  }

  if (aProvider) {
    aTexture->SetTextureSourceProvider(aProvider);
  }

  if (!aUpdateRect.IsEmpty()) {
    // For !HasIntermediateBuffer() textures, this is likely a no-op.
    nsIntRegion region = aUpdateRect;
    aTexture->Updated(&region);
  }

  aTexture->PrepareTextureSource(aTextureSource);
}

class TextureSourceRecycler {
 public:
  explicit TextureSourceRecycler(nsTArray<TileHost>&& aTileSet)
      : mTiles(std::move(aTileSet)), mFirstPossibility(0) {}

  // Attempts to recycle a texture source that is already bound to the
  // texture host for aTile.
  void RecycleTextureSourceForTile(TileHost& aTile) {
    for (size_t i = mFirstPossibility; i < mTiles.Length(); i++) {
      // Skip over existing tiles without a retained texture source
      // and make sure we don't iterate them in the future.
      if (!mTiles[i].mTextureSource) {
        if (i == mFirstPossibility) {
          mFirstPossibility++;
        }
        continue;
      }

      // If this tile matches, then copy across the retained texture source (if
      // any).
      if (aTile.mTextureHost == mTiles[i].mTextureHost) {
        aTile.mTextureSource = std::move(mTiles[i].mTextureSource);
        if (aTile.mTextureHostOnWhite) {
          aTile.mTextureSourceOnWhite =
              std::move(mTiles[i].mTextureSourceOnWhite);
        }
        break;
      }
    }
  }

  // Attempts to recycle any texture source to avoid needing to allocate
  // a new one.
  void RecycleTextureSource(TileHost& aTile) {
    for (size_t i = mFirstPossibility; i < mTiles.Length(); i++) {
      if (!mTiles[i].mTextureSource) {
        if (i == mFirstPossibility) {
          mFirstPossibility++;
        }
        continue;
      }

      if (mTiles[i].mTextureSource && mTiles[i].mTextureHost->GetFormat() ==
                                          aTile.mTextureHost->GetFormat()) {
        aTile.mTextureSource = std::move(mTiles[i].mTextureSource);
        if (aTile.mTextureHostOnWhite) {
          aTile.mTextureSourceOnWhite =
              std::move(mTiles[i].mTextureSourceOnWhite);
        }
        break;
      }
    }
  }

  void RecycleTileFading(TileHost& aTile) {
    for (size_t i = 0; i < mTiles.Length(); i++) {
      if (mTiles[i].mTextureHost == aTile.mTextureHost) {
        aTile.mFadeStart = mTiles[i].mFadeStart;
      }
    }
  }

 protected:
  nsTArray<TileHost> mTiles;
  size_t mFirstPossibility;
};

bool TiledLayerBufferComposite::UseTiles(const SurfaceDescriptorTiles& aTiles,
                                         HostLayerManager* aLayerManager,
                                         ISurfaceAllocator* aAllocator) {
  if (mResolution != aTiles.resolution() || aTiles.tileSize() != mTileSize) {
    Clear();
  }
  MOZ_ASSERT(aAllocator);
  MOZ_ASSERT(aLayerManager);
  if (!aAllocator || !aLayerManager) {
    return false;
  }

  if (aTiles.resolution() == 0 || IsNaN(aTiles.resolution())) {
    // There are divisions by mResolution so this protects the compositor
    // process against malicious content processes and fuzzing.
    return false;
  }

  TilesPlacement newTiles(aTiles.firstTileX(), aTiles.firstTileY(),
                          aTiles.retainedWidth(), aTiles.retainedHeight());

  const nsTArray<TileDescriptor>& tileDescriptors = aTiles.tiles();

  TextureSourceRecycler oldRetainedTiles(std::move(mRetainedTiles));
  mRetainedTiles.SetLength(tileDescriptors.Length());

  AutoTArray<uint64_t, 10> lockedTextureSerials;
  base::ProcessId lockedTexturePid = 0;

  // Step 1, deserialize the incoming set of tiles into mRetainedTiles, and
  // attempt to recycle the TextureSource for any repeated tiles.
  //
  // Since we don't have any retained 'tile' object, we have to search for
  // instances of the same TextureHost in the old tile set. The cost of binding
  // a TextureHost to a TextureSource for gralloc (binding EGLImage to GL
  // texture) can be really high, so we avoid this whenever possible.
  for (size_t i = 0; i < tileDescriptors.Length(); i++) {
    const TileDescriptor& tileDesc = tileDescriptors[i];

    TileHost& tile = mRetainedTiles[i];

    if (tileDesc.type() != TileDescriptor::TTexturedTileDescriptor) {
      NS_WARNING_ASSERTION(
          tileDesc.type() == TileDescriptor::TPlaceholderTileDescriptor,
          "Unrecognised tile descriptor type");
      continue;
    }

    const TexturedTileDescriptor& texturedDesc =
        tileDesc.get_TexturedTileDescriptor();

    tile.mTextureHost =
        TextureHost::AsTextureHost(texturedDesc.textureParent());
    if (texturedDesc.readLocked()) {
      tile.mTextureHost->SetReadLocked();
      auto actor = tile.mTextureHost->GetIPDLActor();
      if (actor && tile.mTextureHost->IsDirectMap()) {
        lockedTextureSerials.AppendElement(
            TextureHost::GetTextureSerial(actor));

        if (lockedTexturePid) {
          MOZ_ASSERT(lockedTexturePid == actor->OtherPid());
        }
        lockedTexturePid = actor->OtherPid();
      }
    }

    if (texturedDesc.textureOnWhiteParent().isSome()) {
      tile.mTextureHostOnWhite =
          TextureHost::AsTextureHost(texturedDesc.textureOnWhiteParent().ref());
      if (texturedDesc.readLockedOnWhite()) {
        tile.mTextureHostOnWhite->SetReadLocked();
        auto actor = tile.mTextureHostOnWhite->GetIPDLActor();
        if (actor && tile.mTextureHostOnWhite->IsDirectMap()) {
          lockedTextureSerials.AppendElement(
              TextureHost::GetTextureSerial(actor));
        }
      }
    }

    tile.mTileCoord = newTiles.TileCoord(i);

    // If this same tile texture existed in the old tile set then this will move
    // the texture source into our new tile.
    oldRetainedTiles.RecycleTextureSourceForTile(tile);

    // If this tile is in the process of fading, we need to keep that going
    oldRetainedTiles.RecycleTileFading(tile);

    if (aTiles.isProgressive() && texturedDesc.wasPlaceholder()) {
      // This is a progressive paint, and the tile used to be a placeholder.
      // We need to begin fading it in (if enabled via
      // layers.tiles.fade-in.enabled)
      tile.mFadeStart = TimeStamp::Now();

      aLayerManager->CompositeUntil(
          tile.mFadeStart +
          TimeDuration::FromMilliseconds(
              StaticPrefs::layers_tiles_fade_in_duration_ms()));
    }
  }

#ifdef XP_DARWIN
  if (lockedTextureSerials.Length() > 0) {
    TextureSync::SetTexturesLocked(lockedTexturePid, lockedTextureSerials);
  }
#endif

  // Step 2, attempt to recycle unused texture sources from the old tile set
  // into new tiles.
  //
  // For gralloc, binding a new TextureHost to the existing TextureSource is the
  // fastest way to ensure that any implicit locking on the old gralloc image is
  // released.
  for (TileHost& tile : mRetainedTiles) {
    if (!tile.mTextureHost || tile.mTextureSource) {
      continue;
    }
    oldRetainedTiles.RecycleTextureSource(tile);
  }

  // Step 3, handle the texture uploads, texture source binding and release the
  // copy-on-write locks for textures with an internal buffer.
  for (size_t i = 0; i < mRetainedTiles.Length(); i++) {
    TileHost& tile = mRetainedTiles[i];
    if (!tile.mTextureHost) {
      continue;
    }

    const TileDescriptor& tileDesc = tileDescriptors[i];
    const TexturedTileDescriptor& texturedDesc =
        tileDesc.get_TexturedTileDescriptor();

    UseTileTexture(tile.mTextureHost, tile.mTextureSource,
                   texturedDesc.updateRect(),
                   aLayerManager->GetTextureSourceProvider());

    if (tile.mTextureHostOnWhite) {
      UseTileTexture(tile.mTextureHostOnWhite, tile.mTextureSourceOnWhite,
                     texturedDesc.updateRect(),
                     aLayerManager->GetTextureSourceProvider());
    }
  }

  mTiles = newTiles;
  mTileSize = aTiles.tileSize();
  mTileOrigin = aTiles.tileOrigin();
  mValidRegion = aTiles.validRegion();
  mResolution = aTiles.resolution();
  mFrameResolution = CSSToParentLayerScale2D(aTiles.frameXResolution(),
                                             aTiles.frameYResolution());

  return true;
}

void TiledLayerBufferComposite::Clear() {
  mRetainedTiles.Clear();
  mTiles.mFirst = TileCoordIntPoint();
  mTiles.mSize = TileCoordIntSize();
  mValidRegion = nsIntRegion();
  mResolution = 1.0;
}

void TiledContentHost::Composite(
    Compositor* aCompositor, LayerComposite* aLayer, EffectChain& aEffectChain,
    float aOpacity, const gfx::Matrix4x4& aTransform,
    const gfx::SamplingFilter aSamplingFilter, const gfx::IntRect& aClipRect,
    const nsIntRegion* aVisibleRegion /* = nullptr */,
    const Maybe<gfx::Polygon>& aGeometry) {
  // Reduce the opacity of the low-precision buffer to make it a
  // little more subtle and less jarring. In particular, text
  // rendered at low-resolution and scaled tends to look pretty
  // heavy and this helps mitigate that. When we reduce the opacity
  // we also make sure to draw the background color behind the
  // reduced-opacity tile so that content underneath doesn't show
  // through.
  // However, in cases where the background is transparent, or the layer
  // already has some opacity, we want to skip this behaviour. Otherwise
  // we end up changing the expected overall transparency of the content,
  // and it just looks wrong.
  DeviceColor backgroundColor;
  if (aOpacity == 1.0f && StaticPrefs::layers_low_precision_opacity() < 1.0f) {
    // Background colors are only stored on scrollable layers. Grab
    // the one from the nearest scrollable ancestor layer.
    for (LayerMetricsWrapper ancestor(GetLayer(),
                                      LayerMetricsWrapper::StartAt::BOTTOM);
         ancestor; ancestor = ancestor.GetParent()) {
      if (ancestor.Metrics().IsScrollable()) {
        backgroundColor = ancestor.Metadata().GetBackgroundColor();
        break;
      }
    }
  }
  float lowPrecisionOpacityReduction =
      (aOpacity == 1.0f && backgroundColor.a == 1.0f)
          ? StaticPrefs::layers_low_precision_opacity()
          : 1.0f;

  nsIntRegion tmpRegion;
  const nsIntRegion* renderRegion = aVisibleRegion;
#ifndef MOZ_IGNORE_PAINT_WILL_RESAMPLE
  if (PaintWillResample()) {
    // If we're resampling, then the texture image will contain exactly the
    // entire visible region's bounds, and we should draw it all in one quad
    // to avoid unexpected aliasing.
    tmpRegion = aVisibleRegion->GetBounds();
    renderRegion = &tmpRegion;
  }
#endif

  // Render the low and high precision buffers.
  RenderLayerBuffer(
      mLowPrecisionTiledBuffer, aCompositor,
      lowPrecisionOpacityReduction < 1.0f ? &backgroundColor : nullptr,
      aEffectChain, lowPrecisionOpacityReduction * aOpacity, aSamplingFilter,
      aClipRect, *renderRegion, aTransform, aGeometry);

  RenderLayerBuffer(mTiledBuffer, aCompositor, nullptr, aEffectChain, aOpacity,
                    aSamplingFilter, aClipRect, *renderRegion, aTransform,
                    aGeometry);
}

void TiledContentHost::RenderTile(
    TileHost& aTile, Compositor* aCompositor, EffectChain& aEffectChain,
    float aOpacity, const gfx::Matrix4x4& aTransform,
    const gfx::SamplingFilter aSamplingFilter, const gfx::IntRect& aClipRect,
    const nsIntRegion& aScreenRegion, const IntPoint& aTextureOffset,
    const IntSize& aTextureBounds, const gfx::Rect& aVisibleRect,
    const Maybe<gfx::Polygon>& aGeometry) {
  MOZ_ASSERT(!aTile.IsPlaceholderTile());

  AutoLockTextureHost autoLock(aTile.mTextureHost);
  AutoLockTextureHost autoLockOnWhite(aTile.mTextureHostOnWhite);
  if (autoLock.Failed() || autoLockOnWhite.Failed()) {
    NS_WARNING("Failed to lock tile");
    return;
  }

  if (!aTile.mTextureHost->BindTextureSource(aTile.mTextureSource)) {
    return;
  }

  if (aTile.mTextureHostOnWhite &&
      !aTile.mTextureHostOnWhite->BindTextureSource(
          aTile.mTextureSourceOnWhite)) {
    return;
  }

  RefPtr<TexturedEffect> effect = CreateTexturedEffect(
      aTile.mTextureSource, aTile.mTextureSourceOnWhite, aSamplingFilter, true);
  if (!effect) {
    return;
  }

  float opacity = aTile.GetFadeInOpacity(aOpacity);
  aEffectChain.mPrimaryEffect = effect;

  for (auto iter = aScreenRegion.RectIter(); !iter.Done(); iter.Next()) {
    const IntRect& rect = iter.Get();
    Rect graphicsRect(rect.X(), rect.Y(), rect.Width(), rect.Height());
    Rect textureRect(rect.X() - aTextureOffset.x, rect.Y() - aTextureOffset.y,
                     rect.Width(), rect.Height());

    effect->mTextureCoords.SetRect(
        textureRect.X() / aTextureBounds.width,
        textureRect.Y() / aTextureBounds.height,
        textureRect.Width() / aTextureBounds.width,
        textureRect.Height() / aTextureBounds.height);

    aCompositor->DrawGeometry(graphicsRect, aClipRect, aEffectChain, opacity,
                              aTransform, aVisibleRect, aGeometry);
  }

  DiagnosticFlags flags = DiagnosticFlags::CONTENT | DiagnosticFlags::TILE;
  if (aTile.mTextureHostOnWhite) {
    flags |= DiagnosticFlags::COMPONENT_ALPHA;
  }
  aCompositor->DrawDiagnostics(flags, aScreenRegion, aClipRect, aTransform,
                               mFlashCounter);
}

void TiledContentHost::RenderLayerBuffer(
    TiledLayerBufferComposite& aLayerBuffer, Compositor* aCompositor,
    const DeviceColor* aBackgroundColor, EffectChain& aEffectChain,
    float aOpacity, const gfx::SamplingFilter aSamplingFilter,
    const gfx::IntRect& aClipRect, nsIntRegion aVisibleRegion,
    gfx::Matrix4x4 aTransform, const Maybe<Polygon>& aGeometry) {
  float resolution = aLayerBuffer.GetResolution();
  gfx::Size layerScale(1, 1);

  // We assume that the current frame resolution is the one used in our high
  // precision layer buffer. Compensate for a changing frame resolution when
  // rendering the low precision buffer.
  if (aLayerBuffer.GetFrameResolution() != mTiledBuffer.GetFrameResolution()) {
    const CSSToParentLayerScale2D& layerResolution =
        aLayerBuffer.GetFrameResolution();
    const CSSToParentLayerScale2D& localResolution =
        mTiledBuffer.GetFrameResolution();
    layerScale.width = layerResolution.xScale / localResolution.xScale;
    layerScale.height = layerResolution.yScale / localResolution.yScale;
    aVisibleRegion.ScaleRoundOut(layerScale.width, layerScale.height);
  }

  // Make sure we don't render at low resolution where we have valid high
  // resolution content, to avoid overdraw and artifacts with semi-transparent
  // layers.
  nsIntRegion maskRegion;
  if (resolution != mTiledBuffer.GetResolution()) {
    maskRegion = mTiledBuffer.GetValidRegion();
    // XXX This should be ScaleRoundIn, but there is no such function on
    //     nsIntRegion.
    maskRegion.ScaleRoundOut(layerScale.width, layerScale.height);
  }

  // Make sure the resolution and difference in frame resolution are accounted
  // for in the layer transform.
  aTransform.PreScale(1 / (resolution * layerScale.width),
                      1 / (resolution * layerScale.height), 1);

  DiagnosticFlags componentAlphaDiagnostic = DiagnosticFlags::NO_DIAGNOSTIC;

  nsIntRegion compositeRegion = aLayerBuffer.GetValidRegion();
  compositeRegion.AndWith(aVisibleRegion);
  compositeRegion.SubOut(maskRegion);

  IntRect visibleRect = aVisibleRegion.GetBounds();

  if (compositeRegion.IsEmpty()) {
    return;
  }

  if (aBackgroundColor) {
    nsIntRegion backgroundRegion = compositeRegion;
    backgroundRegion.ScaleRoundOut(resolution, resolution);
    EffectChain effect;
    effect.mPrimaryEffect = new EffectSolidColor(*aBackgroundColor);
    for (auto iter = backgroundRegion.RectIter(); !iter.Done(); iter.Next()) {
      const IntRect& rect = iter.Get();
      Rect graphicsRect(rect.X(), rect.Y(), rect.Width(), rect.Height());
      aCompositor->DrawGeometry(graphicsRect, aClipRect, effect, 1.0,
                                aTransform, aGeometry);
    }
  }

  for (size_t i = 0; i < aLayerBuffer.GetTileCount(); ++i) {
    TileHost& tile = aLayerBuffer.GetTile(i);
    if (tile.IsPlaceholderTile()) {
      continue;
    }

    TileCoordIntPoint tileCoord = aLayerBuffer.GetPlacement().TileCoord(i);
    // A sanity check that catches a lot of mistakes.
    MOZ_ASSERT(tileCoord.x == tile.mTileCoord.x &&
               tileCoord.y == tile.mTileCoord.y);

    IntPoint tileOffset = aLayerBuffer.GetTileOffset(tileCoord);
    nsIntRegion tileDrawRegion =
        IntRect(tileOffset, aLayerBuffer.GetScaledTileSize());
    tileDrawRegion.AndWith(compositeRegion);

    if (tileDrawRegion.IsEmpty()) {
      continue;
    }

    tileDrawRegion.ScaleRoundOut(resolution, resolution);
    RenderTile(tile, aCompositor, aEffectChain, aOpacity, aTransform,
               aSamplingFilter, aClipRect, tileDrawRegion,
               tileOffset * resolution, aLayerBuffer.GetTileSize(),
               gfx::Rect(visibleRect.X(), visibleRect.Y(), visibleRect.Width(),
                         visibleRect.Height()),
               aGeometry);

    if (tile.mTextureHostOnWhite) {
      componentAlphaDiagnostic = DiagnosticFlags::COMPONENT_ALPHA;
    }
  }

  gfx::Rect rect(visibleRect.X(), visibleRect.Y(), visibleRect.Width(),
                 visibleRect.Height());
  aCompositor->DrawDiagnostics(
      DiagnosticFlags::CONTENT | componentAlphaDiagnostic, rect, aClipRect,
      aTransform, mFlashCounter);
}

void TiledContentHost::PrintInfo(std::stringstream& aStream,
                                 const char* aPrefix) {
  aStream << aPrefix;
  aStream << nsPrintfCString("TiledContentHost (0x%p)", this).get();

#if defined(MOZ_DUMP_PAINTING)
  if (StaticPrefs::layers_dump_texture()) {
    nsAutoCString pfx(aPrefix);
    pfx += "  ";

    Dump(aStream, pfx.get(), false);
  }
#endif
}

void TiledContentHost::Dump(std::stringstream& aStream, const char* aPrefix,
                            bool aDumpHtml) {
  mTiledBuffer.Dump(
      aStream, aPrefix, aDumpHtml,
      TextureDumpMode::
          DoNotCompress /* compression not supported on host side */);
}

void TiledContentHost::AddAnimationInvalidation(nsIntRegion& aRegion) {
  return mTiledBuffer.AddAnimationInvalidation(aRegion);
}

}  // namespace layers
}  // namespace mozilla
