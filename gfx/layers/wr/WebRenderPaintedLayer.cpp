/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "WebRenderPaintedLayer.h"

#include "LayersLogging.h"
#include "mozilla/ArrayUtils.h"
#include "mozilla/layers/ScrollingLayersHelper.h"
#include "mozilla/layers/StackingContextHelper.h"
#include "mozilla/layers/WebRenderBridgeChild.h"
#include "mozilla/layers/UpdateImageHelper.h"
#include "mozilla/webrender/WebRenderTypes.h"
#include "gfxPrefs.h"
#include "gfxUtils.h"

namespace mozilla {
namespace layers {

using namespace mozilla::gfx;

bool
WebRenderPaintedLayer::SetupExternalImages()
{
  // XXX We won't keep using ContentClient for WebRenderPaintedLayer in the future and
  // there is a crash problem for ContentClient on MacOS. So replace ContentClient with
  // ImageClient. See bug 1341001.

  if (!mImageContainer) {
    mImageContainer = LayerManager::CreateImageContainer();
  }

  if (!mImageClient) {
    mImageClient = ImageClient::CreateImageClient(CompositableType::IMAGE,
                                                  WrBridge(),
                                                  TextureFlags::DEFAULT);
    if (!mImageClient) {
      return false;
    }
    mImageClient->Connect();
  }

  if (mExternalImageId.isNothing()) {
    mExternalImageId = Some(WrBridge()->AllocExternalImageIdForCompositable(mImageClient));
  }

  return true;
}

bool
WebRenderPaintedLayer::UpdateImageClient()
{
  MOZ_ASSERT(WrManager()->GetPaintedLayerCallback());
  LayerIntRegion visibleRegion = GetVisibleRegion();
  LayerIntRect bounds = visibleRegion.GetBounds();
  LayerIntSize size = bounds.Size();
  IntSize imageSize(size.width, size.height);

  UpdateImageHelper helper(mImageContainer, mImageClient, imageSize);

  {
    RefPtr<DrawTarget> target = helper.GetDrawTarget();
    if (!target) {
      return false;
    }

    target->ClearRect(Rect(0, 0, imageSize.width, imageSize.height));
    target->SetTransform(Matrix().PreTranslate(-bounds.x, -bounds.y));
    RefPtr<gfxContext> ctx =
        gfxContext::CreatePreservingTransformOrNull(target);
    MOZ_ASSERT(ctx); // already checked the target above

    WrManager()->GetPaintedLayerCallback()(this,
                                           ctx,
                                           visibleRegion.ToUnknownRegion(), visibleRegion.ToUnknownRegion(),
                                           DrawRegionClip::DRAW, nsIntRegion(), WrManager()->GetPaintedLayerCallbackData());

    if (gfxPrefs::WebRenderHighlightPaintedLayers()) {
      target->SetTransform(Matrix());
      target->FillRect(Rect(0, 0, imageSize.width, imageSize.height), ColorPattern(Color(1.0, 0.0, 0.0, 0.5)));
    }
  }

  if (!helper.UpdateImage()) {
    return false;
  }

  return true;
}

void
WebRenderPaintedLayer::CreateWebRenderDisplayList(wr::DisplayListBuilder& aBuilder,
                                                  const StackingContextHelper& aSc)
{
  ScrollingLayersHelper scroller(this, aBuilder, aSc);
  StackingContextHelper sc(aSc, aBuilder, this);

  LayerRect rect = Bounds();
  DumpLayerInfo("PaintedLayer", rect);

  LayerRect clipRect = ClipRect().valueOr(rect);
  Maybe<WrImageMask> mask = BuildWrMaskLayer(&sc);
  WrClipRegionToken clip = aBuilder.PushClipRegion(
      sc.ToRelativeWrRect(clipRect),
      mask.ptrOr(nullptr));

  WrImageKey key = GetImageKey();
  WrBridge()->AddWebRenderParentCommand(OpAddExternalImage(mExternalImageId.value(), key));
  WrManager()->AddImageKeyForDiscard(key);

  aBuilder.PushImage(sc.ToRelativeWrRect(rect), clip, wr::ImageRendering::Auto, key);
}

void
WebRenderPaintedLayer::RenderLayer(wr::DisplayListBuilder& aBuilder,
                                   const StackingContextHelper& aSc)
{
  if (!SetupExternalImages()) {
    return;
  }

  if (GetVisibleRegion().IsEmpty()) {
    if (gfxPrefs::LayersDump()) {
      printf_stderr("PaintedLayer %p skipping\n", this->GetLayer());
    }
    return;
  }

  nsIntRegion regionToPaint;
  regionToPaint.Sub(mVisibleRegion.ToUnknownRegion(), mValidRegion);

  // We have something to paint but can't. This usually happens only in
  // empty transactions
  if (!regionToPaint.IsEmpty() && !WrManager()->GetPaintedLayerCallback()) {
    WrManager()->SetTransactionIncomplete();
    return;
  }

  if (!regionToPaint.IsEmpty() && WrManager()->GetPaintedLayerCallback()) {
    if (!UpdateImageClient()) {
      return;
    }
  } else {
    // We have an empty transaction, just reuse the old image we had before.
    MOZ_ASSERT(mExternalImageId);
    MOZ_ASSERT(mImageContainer->HasCurrentImage());
    MOZ_ASSERT(GetInvalidRegion().IsEmpty());
  }

  CreateWebRenderDisplayList(aBuilder, aSc);
}

} // namespace layers
} // namespace mozilla
