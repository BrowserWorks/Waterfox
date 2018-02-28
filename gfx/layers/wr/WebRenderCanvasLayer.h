/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef GFX_WEBRENDERCANVASLAYER_H
#define GFX_WEBRENDERCANVASLAYER_H

#include "mozilla/layers/WebRenderLayer.h"
#include "mozilla/layers/WebRenderLayerManager.h"
#include "ShareableCanvasLayer.h"

namespace mozilla {
namespace gfx {
class SourceSurface;
}; // namespace gfx

namespace layers {

class WebRenderCanvasLayer : public WebRenderLayer,
                             public ShareableCanvasLayer
{
public:
  explicit WebRenderCanvasLayer(WebRenderLayerManager* aLayerManager)
    : ShareableCanvasLayer(aLayerManager, static_cast<WebRenderLayer*>(this))
  {
    MOZ_COUNT_CTOR(WebRenderCanvasLayer);
  }

  virtual void Initialize(const Data& aData) override;

  virtual CompositableForwarder* GetForwarder() override;

  virtual void AttachCompositable() override;

  virtual void ClearCachedResources() override;

protected:
  virtual ~WebRenderCanvasLayer();

  void ClearWrResources();

public:
  Layer* GetLayer() override { return this; }
  void RenderLayer(wr::DisplayListBuilder& aBuilder,
                   const StackingContextHelper& aSc) override;

protected:
  wr::MaybeExternalImageId mExternalImageId;
};

} // namespace layers
} // namespace mozilla

#endif // GFX_WEBRENDERCANVASLAYER_H
