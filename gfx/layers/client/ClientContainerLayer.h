/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef GFX_CLIENTCONTAINERLAYER_H
#define GFX_CLIENTCONTAINERLAYER_H

#include <stdint.h>              // for uint32_t
#include "ClientLayerManager.h"  // for ClientLayerManager, etc
#include "Layers.h"              // for Layer, ContainerLayer, etc
#include "nsDebug.h"             // for NS_ASSERTION
#include "nsISupportsImpl.h"     // for MOZ_COUNT_CTOR, etc
#include "nsISupportsUtils.h"    // for NS_ADDREF, NS_RELEASE
#include "nsRegion.h"            // for nsIntRegion
#include "nsTArray.h"            // for AutoTArray
#include "ReadbackProcessor.h"
#include "ClientPaintedLayer.h"

namespace mozilla {
namespace layers {

class ShadowableLayer;

class ClientContainerLayer : public ContainerLayer, public ClientLayer {
 public:
  explicit ClientContainerLayer(ClientLayerManager* aManager)
      : ContainerLayer(aManager, static_cast<ClientLayer*>(this)) {
    MOZ_COUNT_CTOR(ClientContainerLayer);
    mSupportsComponentAlphaChildren = true;
  }

 protected:
  virtual ~ClientContainerLayer() {
    ContainerLayer::RemoveAllChildren();
    MOZ_COUNT_DTOR(ClientContainerLayer);
  }

 public:
  void RenderLayer() override {
    RenderMaskLayers(this);

    DefaultComputeSupportsComponentAlphaChildren();

    ReadbackProcessor readback;
    readback.BuildUpdates(this);

    nsTArray<Layer*> children = CollectChildren();
    for (uint32_t i = 0; i < children.Length(); i++) {
      Layer* child = children.ElementAt(i);

      ToClientLayer(child)->RenderLayerWithReadback(&readback);

      if (!ClientManager()->GetRepeatTransaction() &&
          !child->GetInvalidRegion().IsEmpty()) {
        child->Mutated();
      }
    }
  }

  void SetVisibleRegion(const LayerIntRegion& aRegion) override {
    NS_ASSERTION(ClientManager()->InConstruction(),
                 "Can only set properties in construction phase");
    ContainerLayer::SetVisibleRegion(aRegion);
  }
  bool InsertAfter(Layer* aChild, Layer* aAfter) override {
    if (!ClientManager()->InConstruction()) {
      NS_ERROR("Can only set properties in construction phase");
      return false;
    }

    if (!ContainerLayer::InsertAfter(aChild, aAfter)) {
      return false;
    }

    ClientManager()->AsShadowForwarder()->InsertAfter(
        ClientManager()->Hold(this), ClientManager()->Hold(aChild),
        aAfter ? ClientManager()->Hold(aAfter) : nullptr);
    return true;
  }

  bool RemoveChild(Layer* aChild) override {
    if (!ClientManager()->InConstruction()) {
      NS_ERROR("Can only set properties in construction phase");
      return false;
    }
    // hold on to aChild before we remove it!
    ShadowableLayer* heldChild = ClientManager()->Hold(aChild);
    if (!ContainerLayer::RemoveChild(aChild)) {
      return false;
    }
    ClientManager()->AsShadowForwarder()->RemoveChild(
        ClientManager()->Hold(this), heldChild);
    return true;
  }

  bool RepositionChild(Layer* aChild, Layer* aAfter) override {
    if (!ClientManager()->InConstruction()) {
      NS_ERROR("Can only set properties in construction phase");
      return false;
    }
    if (!ContainerLayer::RepositionChild(aChild, aAfter)) {
      return false;
    }
    ClientManager()->AsShadowForwarder()->RepositionChild(
        ClientManager()->Hold(this), ClientManager()->Hold(aChild),
        aAfter ? ClientManager()->Hold(aAfter) : nullptr);
    return true;
  }

  Layer* AsLayer() override { return this; }
  ShadowableLayer* AsShadowableLayer() override { return this; }

  void ComputeEffectiveTransforms(
      const gfx::Matrix4x4& aTransformToSurface) override {
    DefaultComputeEffectiveTransforms(aTransformToSurface);
  }

  void ForceIntermediateSurface() { mUseIntermediateSurface = true; }

  void SetSupportsComponentAlphaChildren(bool aSupports) {
    mSupportsComponentAlphaChildren = aSupports;
  }

 protected:
  ClientLayerManager* ClientManager() {
    return static_cast<ClientLayerManager*>(mManager);
  }
};

class ClientRefLayer : public RefLayer, public ClientLayer {
 public:
  explicit ClientRefLayer(ClientLayerManager* aManager)
      : RefLayer(aManager, static_cast<ClientLayer*>(this)) {
    MOZ_COUNT_CTOR(ClientRefLayer);
  }

 protected:
  MOZ_COUNTED_DTOR_OVERRIDE(ClientRefLayer)

 public:
  Layer* AsLayer() override { return this; }
  ShadowableLayer* AsShadowableLayer() override { return this; }

  void RenderLayer() override { RenderMaskLayers(this); }

  void ComputeEffectiveTransforms(
      const gfx::Matrix4x4& aTransformToSurface) override {
    DefaultComputeEffectiveTransforms(aTransformToSurface);
  }

 private:
  ClientLayerManager* ClientManager() {
    return static_cast<ClientLayerManager*>(mManager);
  }
};

}  // namespace layers
}  // namespace mozilla

#endif
