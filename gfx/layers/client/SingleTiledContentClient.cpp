/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/layers/SingleTiledContentClient.h"

#include "ClientTiledPaintedLayer.h"
#include "mozilla/Maybe.h"
#include "mozilla/UniquePtr.h"

namespace mozilla {
namespace layers {

SingleTiledContentClient::SingleTiledContentClient(
    ClientTiledPaintedLayer& aPaintedLayer, ClientLayerManager* aManager)
    : TiledContentClient(aManager, "Single") {
  MOZ_COUNT_CTOR(SingleTiledContentClient);

  mTiledBuffer =
      new ClientSingleTiledLayerBuffer(aPaintedLayer, *this, aManager);
}

void SingleTiledContentClient::ClearCachedResources() {
  CompositableClient::ClearCachedResources();
  mTiledBuffer->DiscardBuffers();
}

void SingleTiledContentClient::UpdatedBuffer(TiledBufferType aType) {
  mForwarder->UseTiledLayerBuffer(this,
                                  mTiledBuffer->GetSurfaceDescriptorTiles());
}

/* static */
bool SingleTiledContentClient::ClientSupportsLayerSize(
    const gfx::IntSize& aSize, ClientLayerManager* aManager) {
  int32_t maxTextureSize = aManager->GetMaxTextureSize();
  return aSize.width <= maxTextureSize && aSize.height <= maxTextureSize;
}

ClientSingleTiledLayerBuffer::ClientSingleTiledLayerBuffer(
    ClientTiledPaintedLayer& aPaintedLayer,
    CompositableClient& aCompositableClient, ClientLayerManager* aManager)
    : ClientTiledLayerBuffer(aPaintedLayer, aCompositableClient),
      mManager(aManager),
      mWasLastPaintProgressive(false),
      mFormat(gfx::SurfaceFormat::UNKNOWN) {}

void ClientSingleTiledLayerBuffer::ReleaseTiles() {
  if (!mTile.IsPlaceholderTile()) {
    mTile.DiscardBuffers();
  }
  mTile.SetTextureAllocator(nullptr);
}

void ClientSingleTiledLayerBuffer::DiscardBuffers() {
  if (!mTile.IsPlaceholderTile()) {
    mTile.DiscardFrontBuffer();
    mTile.DiscardBackBuffer();
  }
}

SurfaceDescriptorTiles
ClientSingleTiledLayerBuffer::GetSurfaceDescriptorTiles() {
  nsTArray<TileDescriptor> tiles;

  TileDescriptor tileDesc = mTile.GetTileDescriptor();
  tiles.AppendElement(tileDesc);
  mTile.mUpdateRect = gfx::IntRect();

  return SurfaceDescriptorTiles(mValidRegion, tiles, mTilingOrigin, mSize, 0, 0,
                                1, 1, 1.0, mFrameResolution.xScale,
                                mFrameResolution.yScale,
                                mWasLastPaintProgressive);
}

already_AddRefed<TextureClient>
ClientSingleTiledLayerBuffer::GetTextureClient() {
  MOZ_ASSERT(mFormat != gfx::SurfaceFormat::UNKNOWN);
  return mCompositableClient.CreateTextureClientForDrawing(
      gfx::ImageFormatToSurfaceFormat(mFormat), mSize, BackendSelector::Content,
      TextureFlags::DISALLOW_BIGIMAGE | TextureFlags::IMMEDIATE_UPLOAD |
          TextureFlags::NON_BLOCKING_READ_LOCK);
}

void ClientSingleTiledLayerBuffer::PaintThebes(
    const nsIntRegion& aNewValidRegion, const nsIntRegion& aPaintRegion,
    const nsIntRegion& aDirtyRegion,
    LayerManager::DrawPaintedLayerCallback aCallback, void* aCallbackData,
    TilePaintFlags aFlags) {
  mWasLastPaintProgressive = !!(aFlags & TilePaintFlags::Progressive);
  bool asyncPaint = !!(aFlags & TilePaintFlags::Async);

  // Compare layer valid region size to current backbuffer size, discard if not
  // matching.
  gfx::IntSize size = aNewValidRegion.GetBounds().Size();
  gfx::IntPoint origin = aNewValidRegion.GetBounds().TopLeft();
  nsIntRegion paintRegion = aPaintRegion;

  RefPtr<TextureClient> discardedFrontBuffer = nullptr;
  RefPtr<TextureClient> discardedFrontBufferOnWhite = nullptr;
  nsIntRegion discardedValidRegion;

  if (mSize != size || mTilingOrigin != origin) {
    discardedFrontBuffer = mTile.mFrontBuffer;
    discardedFrontBufferOnWhite = mTile.mFrontBufferOnWhite;
    discardedValidRegion = mValidRegion;

    TILING_LOG(
        "TILING %p: Single-tile valid region changed. Discarding buffers.\n",
        &mPaintedLayer);
    ResetPaintedAndValidState();
    mSize = size;
    mTilingOrigin = origin;
    paintRegion = aNewValidRegion;
  }

  SurfaceMode mode;
  gfxContentType content = GetContentType(&mode);
  mFormat = gfxPlatform::GetPlatform()->OptimalFormatForContent(content);

  if (mTile.IsPlaceholderTile()) {
    mTile.SetTextureAllocator(this);
  }

  if (mManager->AsShadowForwarder()->SupportsTextureDirectMapping()) {
    AutoTArray<uint64_t, 2> syncTextureSerials;
    mTile.GetSyncTextureSerials(mode, syncTextureSerials);
    if (syncTextureSerials.Length() > 0) {
      mManager->AsShadowForwarder()->SyncTextures(syncTextureSerials);
    }
  }

  // The dirty region relative to the top-left of the tile.
  nsIntRegion tileVisibleRegion = aNewValidRegion.MovedBy(-mTilingOrigin);
  nsIntRegion tileDirtyRegion = paintRegion.MovedBy(-mTilingOrigin);

  Maybe<AcquiredBackBuffer> backBuffer =
      mTile.AcquireBackBuffer(mCompositableClient, tileDirtyRegion,
                              tileVisibleRegion, content, mode, aFlags);

  if (!backBuffer) {
    return;
  }

  // Mark the area we need to paint in the back buffer as invalid in the
  // front buffer as they will become out of sync.
  mTile.mInvalidFront.OrWith(tileDirtyRegion);

  // Add backbuffer's invalid region to the dirty region to be painted.
  // This will be empty if we were able to copy from the front in to the back.
  nsIntRegion tileInvalidRegion = mTile.mInvalidBack;
  tileInvalidRegion.AndWith(tileVisibleRegion);

  paintRegion.OrWith(tileInvalidRegion.MovedBy(mTilingOrigin));
  tileDirtyRegion.OrWith(tileInvalidRegion);

  // Mark the region we will be painting and the region we copied from the front
  // buffer as needing to be uploaded to the compositor
  mTile.mUpdateRect =
      tileDirtyRegion.GetBounds().Union(backBuffer->mUpdatedRect);

  // If the old frontbuffer was discarded then attempt to copy what we
  // can from it to the new backbuffer.
  if (discardedFrontBuffer) {
    nsIntRegion copyableRegion;
    copyableRegion.And(aNewValidRegion, discardedValidRegion);
    copyableRegion.SubOut(aDirtyRegion);

    OpenMode readMode =
        asyncPaint ? OpenMode::OPEN_READ_ASYNC : OpenMode::OPEN_READ;

    DualTextureClientAutoLock discardedBuffer(
        discardedFrontBuffer, discardedFrontBufferOnWhite, readMode);

    if (discardedBuffer.Succeeded()) {
      RefPtr<gfx::SourceSurface> discardedSurface = discardedBuffer->Snapshot();

      for (auto iter = copyableRegion.RectIter(); !iter.Done(); iter.Next()) {
        const gfx::IntRect src =
            iter.Get() - discardedValidRegion.GetBounds().TopLeft();
        const gfx::IntPoint dest = iter.Get().TopLeft() - mTilingOrigin;

        backBuffer->mTarget->CopySurface(discardedSurface, src, dest);
      }

      TILING_LOG("TILING %p: Region copied from discarded frontbuffer %s\n",
                 &mPaintedLayer, Stringify(copyableRegion).c_str());

      // We don't need to repaint valid content that was just copied.
      paintRegion.SubOut(copyableRegion);
      copyableRegion.MoveBy(-mTilingOrigin);
      tileDirtyRegion.SubOut(copyableRegion);
    } else {
      gfxWarning() << "[Tiling:Client] Failed to aquire the discarded front "
                      "buffer's draw target";
    }
  }

  if (mode != SurfaceMode::SURFACE_OPAQUE) {
    for (auto iter = tileDirtyRegion.RectIter(); !iter.Done(); iter.Next()) {
      const gfx::Rect drawRect(iter.Get().X(), iter.Get().Y(),
                               iter.Get().Width(), iter.Get().Height());
      backBuffer->mTarget->ClearRect(drawRect);
    }
  }

  // Paint into the target
  {
    RefPtr<gfxContext> ctx = gfxContext::CreateOrNull(backBuffer->mTarget);
    if (!ctx) {
      gfxDevCrash(gfx::LogReason::InvalidContext)
          << "SingleTiledContextClient context problem "
          << gfx::hexa(backBuffer->mTarget);
      return;
    }
    ctx->SetMatrix(
        ctx->CurrentMatrix().PreTranslate(-mTilingOrigin.x, -mTilingOrigin.y));

    aCallback(&mPaintedLayer, ctx, paintRegion, paintRegion,
              DrawRegionClip::DRAW, nsIntRegion(), aCallbackData);
  }

  if (asyncPaint) {
    if (!backBuffer->mCapture->IsEmpty()) {
      UniquePtr<PaintTask> task(new PaintTask());
      task->mCapture = backBuffer->mCapture;
      task->mTarget = backBuffer->mBackBuffer;
      task->mClients = std::move(backBuffer->mTextureClients);
      if (discardedFrontBuffer) {
        task->mClients.AppendElement(discardedFrontBuffer);
      }
      if (discardedFrontBufferOnWhite) {
        task->mClients.AppendElement(discardedFrontBufferOnWhite);
      }

      // The target is an alias for the capture, and the paint thread expects
      // to be the only one with a reference to the capture
      backBuffer->mTarget = nullptr;
      backBuffer->mCapture = nullptr;

      PaintThread::Get()->QueuePaintTask(std::move(task));
      mManager->SetQueuedAsyncPaints();
    }
  } else {
    MOZ_ASSERT(backBuffer->mTarget == backBuffer->mBackBuffer);
    MOZ_ASSERT(!backBuffer->mCapture);
  }

  // The new buffer is now validated, remove the dirty region from it.
  mTile.mInvalidBack.SubOut(tileDirtyRegion);

  backBuffer = Nothing();

  mTile.Flip();
  UnlockTile(mTile);

  mValidRegion = aNewValidRegion;
  mLastPaintSurfaceMode = mode;
  mLastPaintContentType = content;
}

}  // namespace layers
}  // namespace mozilla
