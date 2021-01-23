/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef MOZILLA_GFX_SINGLETILEDCONTENTCLIENT_H
#define MOZILLA_GFX_SINGLETILEDCONTENTCLIENT_H

#include "TiledContentClient.h"

namespace mozilla {
namespace layers {

class ClientTiledPaintedLayer;
class ClientLayerManager;

/**
 * Provide an instance of TiledLayerBuffer backed by drawable TextureClients.
 * This buffer provides an implementation of ValidateTile using a
 * thebes callback and can support painting using a single paint buffer.
 * Whether a single paint buffer is used is controlled by
 * StaticPrefs::PerTileDrawing().
 */
class ClientSingleTiledLayerBuffer : public ClientTiledLayerBuffer,
                                     public TextureClientAllocator {
  virtual ~ClientSingleTiledLayerBuffer() = default;

 public:
  ClientSingleTiledLayerBuffer(ClientTiledPaintedLayer& aPaintedLayer,
                               CompositableClient& aCompositableClient,
                               ClientLayerManager* aManager);

  // TextureClientAllocator
  already_AddRefed<TextureClient> GetTextureClient() override;
  void ReturnTextureClientDeferred(TextureClient* aClient) override {}
  void ReportClientLost() override {}

  // ClientTiledLayerBuffer
  void PaintThebes(const nsIntRegion& aNewValidRegion,
                   const nsIntRegion& aPaintRegion,
                   const nsIntRegion& aDirtyRegion,
                   LayerManager::DrawPaintedLayerCallback aCallback,
                   void* aCallbackData,
                   TilePaintFlags aFlags = TilePaintFlags::None) override;

  bool SupportsProgressiveUpdate() override { return false; }
  bool ProgressiveUpdate(const nsIntRegion& aValidRegion,
                         const nsIntRegion& aInvalidRegion,
                         const nsIntRegion& aOldValidRegion,
                         nsIntRegion& aOutDrawnRegion,
                         BasicTiledLayerPaintData* aPaintData,
                         LayerManager::DrawPaintedLayerCallback aCallback,
                         void* aCallbackData) override {
    MOZ_ASSERT(false, "ProgressiveUpdate not supported!");
    return false;
  }

  void ResetPaintedAndValidState() override {
    mValidRegion.SetEmpty();
    mTile.DiscardBuffers();
  }

  const nsIntRegion& GetValidRegion() override { return mValidRegion; }

  bool IsLowPrecision() const override { return false; }

  void ReleaseTiles();

  void DiscardBuffers();

  SurfaceDescriptorTiles GetSurfaceDescriptorTiles();

 private:
  TileClient mTile;

  RefPtr<ClientLayerManager> mManager;

  nsIntRegion mValidRegion;
  bool mWasLastPaintProgressive;

  /**
   * While we're adding tiles, this is used to keep track of the position of
   * the top-left of the top-left-most tile.  When we come to wrap the tiles in
   * TiledDrawTarget we subtract the value of this member from each tile's
   * offset so that all the tiles have a positive offset, then add a
   * translation to the TiledDrawTarget to compensate.  This is important so
   * that the mRect of the TiledDrawTarget is always at a positive x/y
   * position, otherwise its GetSize() methods will be broken.
   */
  gfx::IntPoint mTilingOrigin;
  gfx::IntSize mSize;
  gfxImageFormat mFormat;
};

class SingleTiledContentClient : public TiledContentClient {
 public:
  SingleTiledContentClient(ClientTiledPaintedLayer& aPaintedLayer,
                           ClientLayerManager* aManager);

 protected:
  ~SingleTiledContentClient() {
    MOZ_COUNT_DTOR(SingleTiledContentClient);

    mTiledBuffer->ReleaseTiles();
  }

 public:
  static bool ClientSupportsLayerSize(const gfx::IntSize& aSize,
                                      ClientLayerManager* aManager);

  void ClearCachedResources() override;

  void UpdatedBuffer(TiledBufferType aType) override;

  ClientTiledLayerBuffer* GetTiledBuffer() override { return mTiledBuffer; }
  ClientTiledLayerBuffer* GetLowPrecisionTiledBuffer() override {
    return nullptr;
  }

 private:
  RefPtr<ClientSingleTiledLayerBuffer> mTiledBuffer;
};

}  // namespace layers
}  // namespace mozilla

#endif
