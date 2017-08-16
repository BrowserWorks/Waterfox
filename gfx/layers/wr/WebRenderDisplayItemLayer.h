/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef GFX_WEBRENDERDISPLAYITEMLAYER_H
#define GFX_WEBRENDERDISPLAYITEMLAYER_H

#include "Layers.h"
#include "mozilla/layers/ImageClient.h"
#include "mozilla/layers/PWebRenderBridgeChild.h"
#include "mozilla/layers/WebRenderLayer.h"
#include "mozilla/layers/WebRenderLayerManager.h"
#include "mozilla/Maybe.h"
#include "mozilla/webrender/WebRenderTypes.h"

namespace mozilla {
namespace layers {

class WebRenderDisplayItemLayer : public WebRenderLayer,
                                  public DisplayItemLayer {
public:
  explicit WebRenderDisplayItemLayer(WebRenderLayerManager* aLayerManager)
    : DisplayItemLayer(aLayerManager, static_cast<WebRenderLayer*>(this))
  {
    MOZ_COUNT_CTOR(WebRenderDisplayItemLayer);
  }

  Maybe<wr::ImageKey> SendImageContainer(ImageContainer* aContainer,
                                         nsTArray<layers::WebRenderParentCommand>& aParentCommands);
  bool PushItemAsBlobImage(wr::DisplayListBuilder& aBuilder,
                           const StackingContextHelper& aSc);

protected:
  virtual ~WebRenderDisplayItemLayer();

public:
  Layer* GetLayer() override { return this; }
  void RenderLayer(wr::DisplayListBuilder& aBuilder,
                   const StackingContextHelper& aHelper) override;

private:
  wr::BuiltDisplayList mBuiltDisplayList;
  nsTArray<WebRenderParentCommand> mParentCommands;
  RefPtr<ImageClient> mImageClient;
  RefPtr<ImageContainer> mImageContainer;
  wr::MaybeExternalImageId mExternalImageId;
  Maybe<wr::ImageKey> mKey;
};

} // namespace layers
} // namespace mozilla

#endif // GFX_WEBRENDERDisplayItemLayer_H
