/* -*- Mode: C++; tab-width: 20; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef GFX_TILEDCONTENTHOST_H
#define GFX_TILEDCONTENTHOST_H

#include <stdint.h>                     // for uint16_t
#include <stdio.h>                      // for FILE
#include <algorithm>                    // for swap
#include "ContentHost.h"                // for ContentHost
#include "TiledLayerBuffer.h"           // for TiledLayerBuffer, etc
#include "CompositableHost.h"
#include "mozilla/Assertions.h"         // for MOZ_ASSERT, etc
#include "mozilla/Attributes.h"         // for override
#include "mozilla/RefPtr.h"             // for RefPtr
#include "mozilla/gfx/MatrixFwd.h"      // for Matrix4x4
#include "mozilla/gfx/Point.h"          // for Point
#include "mozilla/gfx/Rect.h"           // for Rect
#include "mozilla/gfx/Types.h"          // for SamplingFilter
#include "mozilla/layers/CompositorTypes.h"  // for TextureInfo, etc
#include "mozilla/layers/LayersSurfaces.h"  // for SurfaceDescriptor
#include "mozilla/layers/LayersTypes.h"  // for LayerRenderState, etc
#include "mozilla/layers/TextureHost.h"  // for TextureHost
#include "mozilla/layers/TextureClient.h"
#include "mozilla/mozalloc.h"           // for operator delete
#include "nsRegion.h"                   // for nsIntRegion
#include "nscore.h"                     // for nsACString

namespace mozilla {

namespace layers {

class Compositor;
class ISurfaceAllocator;
class Layer;
class ThebesBufferData;
class TextureReadLock;
struct EffectChain;


class TileHost {
public:
  // Constructs a placeholder TileHost. See the comments above
  // TiledLayerBuffer for more information on what this is used for;
  // essentially, this is a sentinel used to represent an invalid or blank
  // tile.
  TileHost()
  {}

  // Constructs a TileHost from a TextureReadLock and TextureHost.
  TileHost(TextureReadLock* aSharedLock,
               TextureHost* aTextureHost,
               TextureHost* aTextureHostOnWhite,
               TextureSource* aSource,
               TextureSource* aSourceOnWhite)
    : mTextureHost(aTextureHost)
    , mTextureHostOnWhite(aTextureHostOnWhite)
    , mTextureSource(aSource)
    , mTextureSourceOnWhite(aSourceOnWhite)
  {}

  TileHost(const TileHost& o) {
    mTextureHost = o.mTextureHost;
    mTextureHostOnWhite = o.mTextureHostOnWhite;
    mTextureSource = o.mTextureSource;
    mTextureSourceOnWhite = o.mTextureSourceOnWhite;
    mTilePosition = o.mTilePosition;
  }
  TileHost& operator=(const TileHost& o) {
    if (this == &o) {
      return *this;
    }
    mTextureHost = o.mTextureHost;
    mTextureHostOnWhite = o.mTextureHostOnWhite;
    mTextureSource = o.mTextureSource;
    mTextureSourceOnWhite = o.mTextureSourceOnWhite;
    mTilePosition = o.mTilePosition;
    return *this;
  }

  bool operator== (const TileHost& o) const {
    return mTextureHost == o.mTextureHost;
  }
  bool operator!= (const TileHost& o) const {
    return mTextureHost != o.mTextureHost;
  }

  bool IsPlaceholderTile() const { return mTextureHost == nullptr; }

  void Dump(std::stringstream& aStream) {
    aStream << "TileHost(...)"; // fill in as needed
  }

  void DumpTexture(std::stringstream& aStream, TextureDumpMode /* aCompress, ignored for host tiles */) {
    // TODO We should combine the OnWhite/OnBlack here an just output a single image.
    CompositableHost::DumpTextureHost(aStream, mTextureHost);
  }

  /**
   * This does a linear tween of the passed opacity (which is assumed
   * to be between 0.0 and 1.0). The duration of the fade is controlled
   * by the 'layers.tiles.fade-in.duration-ms' preference. It is enabled
   * via 'layers.tiles.fade-in.enabled'
   */
  float GetFadeInOpacity(float aOpacity);

  CompositableTextureHostRef mTextureHost;
  CompositableTextureHostRef mTextureHostOnWhite;
  mutable CompositableTextureSourceRef mTextureSource;
  mutable CompositableTextureSourceRef mTextureSourceOnWhite;
  // This is not strictly necessary but makes debugging whole lot easier.
  TileIntPoint mTilePosition;
  TimeStamp mFadeStart;
};

class TiledLayerBufferComposite
  : public TiledLayerBuffer<TiledLayerBufferComposite, TileHost>
{
  friend class TiledLayerBuffer<TiledLayerBufferComposite, TileHost>;

public:
  TiledLayerBufferComposite();
  ~TiledLayerBufferComposite();

  bool UseTiles(const SurfaceDescriptorTiles& aTileDescriptors,
                Compositor* aCompositor,
                ISurfaceAllocator* aAllocator);

  void Clear();

  TileHost GetPlaceholderTile() const { return TileHost(); }

  // Stores the absolute resolution of the containing frame, calculated
  // by the sum of the resolutions of all parent layers' FrameMetrics.
  const CSSToParentLayerScale2D& GetFrameResolution() { return mFrameResolution; }

  void SetCompositor(Compositor* aCompositor);

  void AddAnimationInvalidation(nsIntRegion& aRegion);
protected:

  CSSToParentLayerScale2D mFrameResolution;
};

/**
 * ContentHost for tiled PaintedLayers. Since tiled layers are special snow
 * flakes, we have a unique update process. All the textures that back the
 * tiles are added in the usual way, but Updated is called on the host side
 * in response to a message that describes the transaction for every tile.
 * Composition happens in the normal way.
 *
 * TiledContentHost has a TiledLayerBufferComposite which keeps hold of the tiles.
 * Each tile has a reference to a texture host. During the layers transaction, we
 * receive a list of descriptors for the client-side tile buffer tiles
 * (UseTiledLayerBuffer). If we receive two transactions before a composition,
 * we immediately unlock and discard the unused buffer.
 *
 * When the content host is composited, we first validate the TiledLayerBuffer
 * (Upload), which calls Updated on each tile's texture host to make sure the
 * texture data has been uploaded. For single-buffered tiles, we unlock at this
 * point, for double-buffered tiles we unlock and discard the last composited
 * buffer after compositing a new one. Rendering takes us to RenderTile which
 * is similar to Composite for non-tiled ContentHosts.
 */
class TiledContentHost : public ContentHost
{
public:
  explicit TiledContentHost(const TextureInfo& aTextureInfo);

protected:
  ~TiledContentHost();

public:
  virtual LayerRenderState GetRenderState() override
  {
    // If we have exactly one high precision tile, then we can support hwc.
    if (mTiledBuffer.GetTileCount() == 1 &&
        mLowPrecisionTiledBuffer.GetTileCount() == 0) {
      TextureHost* host = mTiledBuffer.GetTile(0).mTextureHost;
      if (host) {
        MOZ_ASSERT(!mTiledBuffer.GetTile(0).mTextureHostOnWhite, "Component alpha not supported!");

        gfx::IntPoint offset = mTiledBuffer.GetTileOffset(mTiledBuffer.GetPlacement().TilePosition(0));

        // Don't try to use HWC if the content doesn't start at the top-left of the tile.
        if (offset != GetValidRegion().GetBounds().TopLeft()) {
          return LayerRenderState();
        }

        LayerRenderState state = host->GetRenderState();
        state.SetOffset(offset);
        return state;
      }
    }
    return LayerRenderState();
  }

  // Generate effect for layerscope when using hwc.
  virtual already_AddRefed<TexturedEffect> GenEffect(const gfx::SamplingFilter aSamplingFilter) override;

  virtual bool UpdateThebes(const ThebesBufferData& aData,
                            const nsIntRegion& aUpdated,
                            const nsIntRegion& aOldValidRegionBack,
                            nsIntRegion* aUpdatedRegionBack) override
  {
    NS_ERROR("N/A for tiled layers");
    return false;
  }

  const nsIntRegion& GetValidLowPrecisionRegion() const
  {
    return mLowPrecisionTiledBuffer.GetValidRegion();
  }

  const nsIntRegion& GetValidRegion() const
  {
    return mTiledBuffer.GetValidRegion();
  }

  virtual void SetCompositor(Compositor* aCompositor) override
  {
    MOZ_ASSERT(aCompositor);
    CompositableHost::SetCompositor(aCompositor);
    mTiledBuffer.SetCompositor(aCompositor);
    mLowPrecisionTiledBuffer.SetCompositor(aCompositor);
  }

  bool UseTiledLayerBuffer(ISurfaceAllocator* aAllocator,
                           const SurfaceDescriptorTiles& aTiledDescriptor);

  virtual void Composite(LayerComposite* aLayer,
                         EffectChain& aEffectChain,
                         float aOpacity,
                         const gfx::Matrix4x4& aTransform,
                         const gfx::SamplingFilter aSamplingFilter,
                         const gfx::IntRect& aClipRect,
                         const nsIntRegion* aVisibleRegion = nullptr) override;

  virtual CompositableType GetType() override { return CompositableType::CONTENT_TILED; }

  virtual TiledContentHost* AsTiledContentHost() override { return this; }

  virtual void Attach(Layer* aLayer,
                      Compositor* aCompositor,
                      AttachFlags aFlags = NO_FLAGS) override;

  virtual void Detach(Layer* aLayer = nullptr,
                      AttachFlags aFlags = NO_FLAGS) override;

  virtual void Dump(std::stringstream& aStream,
                    const char* aPrefix="",
                    bool aDumpHtml=false) override;

  virtual void PrintInfo(std::stringstream& aStream, const char* aPrefix) override;

  virtual void AddAnimationInvalidation(nsIntRegion& aRegion) override;

private:

  void RenderLayerBuffer(TiledLayerBufferComposite& aLayerBuffer,
                         const gfx::Color* aBackgroundColor,
                         EffectChain& aEffectChain,
                         float aOpacity,
                         const gfx::SamplingFilter aSamplingFilter,
                         const gfx::IntRect& aClipRect,
                         nsIntRegion aMaskRegion,
                         gfx::Matrix4x4 aTransform);

  // Renders a single given tile.
  void RenderTile(TileHost& aTile,
                  EffectChain& aEffectChain,
                  float aOpacity,
                  const gfx::Matrix4x4& aTransform,
                  const gfx::SamplingFilter aSamplingFilter,
                  const gfx::IntRect& aClipRect,
                  const nsIntRegion& aScreenRegion,
                  const gfx::IntPoint& aTextureOffset,
                  const gfx::IntSize& aTextureBounds,
                  const gfx::Rect& aVisibleRect);

  void EnsureTileStore() {}

  TiledLayerBufferComposite    mTiledBuffer;
  TiledLayerBufferComposite    mLowPrecisionTiledBuffer;
};

} // namespace layers
} // namespace mozilla

#endif
