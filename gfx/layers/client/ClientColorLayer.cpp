/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "ClientLayerManager.h"             // for ClientLayerManager, etc
#include "Layers.h"                         // for ColorLayer, etc
#include "mozilla/layers/LayersMessages.h"  // for ColorLayerAttributes, etc
#include "mozilla/mozalloc.h"               // for operator new
#include "nsCOMPtr.h"                       // for already_AddRefed
#include "nsDebug.h"                        // for NS_ASSERTION
#include "nsISupportsImpl.h"                // for Layer::AddRef, etc
#include "nsRegion.h"                       // for nsIntRegion

namespace mozilla {
namespace layers {

using namespace mozilla::gfx;

class ClientColorLayer : public ColorLayer, public ClientLayer {
 public:
  explicit ClientColorLayer(ClientLayerManager* aLayerManager)
      : ColorLayer(aLayerManager, static_cast<ClientLayer*>(this)) {
    MOZ_COUNT_CTOR(ClientColorLayer);
  }

 protected:
  MOZ_COUNTED_DTOR_OVERRIDE(ClientColorLayer)

 public:
  void SetVisibleRegion(const LayerIntRegion& aRegion) override {
    NS_ASSERTION(ClientManager()->InConstruction(),
                 "Can only set properties in construction phase");
    ColorLayer::SetVisibleRegion(aRegion);
  }

  void RenderLayer() override { RenderMaskLayers(this); }

  void FillSpecificAttributes(SpecificLayerAttributes& aAttrs) override {
    aAttrs = ColorLayerAttributes(GetColor(), GetBounds());
  }

  Layer* AsLayer() override { return this; }
  ShadowableLayer* AsShadowableLayer() override { return this; }

 protected:
  ClientLayerManager* ClientManager() {
    return static_cast<ClientLayerManager*>(mManager);
  }
};

already_AddRefed<ColorLayer> ClientLayerManager::CreateColorLayer() {
  NS_ASSERTION(InConstruction(), "Only allowed in construction phase");
  RefPtr<ClientColorLayer> layer = new ClientColorLayer(this);
  CREATE_SHADOW(Color);
  return layer.forget();
}

}  // namespace layers
}  // namespace mozilla
