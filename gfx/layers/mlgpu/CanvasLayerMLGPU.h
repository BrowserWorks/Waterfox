/* -*- Mode: C++; tab-width: 20; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef GFX_CanvasLayerMLGPU_H
#define GFX_CanvasLayerMLGPU_H

#include "Layers.h"                     // for CanvasLayer, etc
#include "TexturedLayerMLGPU.h"
#include "mozilla/Attributes.h"         // for override
#include "mozilla/RefPtr.h"             // for RefPtr
#include "mozilla/layers/LayerManagerMLGPU.h"  // for LayerComposite, etc
#include "mozilla/layers/LayersTypes.h"  // for LayerRenderState, etc
#include "nsDebug.h"                    // for NS_RUNTIMEABORT
#include "nsRect.h"                     // for mozilla::gfx::IntRect
#include "nscore.h"                     // for nsACString

namespace mozilla {
namespace layers {

class CompositableHost;
class ImageHost;

class CanvasLayerMLGPU final : public CanvasLayer,
                               public TexturedLayerMLGPU
{
public:
  explicit CanvasLayerMLGPU(LayerManagerMLGPU* aManager);

protected:
  ~CanvasLayerMLGPU() override;

public:
  void Initialize(const Data& aData) override {
    MOZ_CRASH("Incompatibe surface type");
  }

  Layer* GetLayer() override;
  void Disconnect() override;

  HostLayer* AsHostLayer() override { return this; }
  CanvasLayerMLGPU* AsCanvasLayerMLGPU() override { return this; }
  gfx::SamplingFilter GetSamplingFilter() override;
  void ClearCachedResources() override;
  void SetRegionToRender(LayerIntRegion&& aRegion) override;

  MOZ_LAYER_DECL_NAME("CanvasLayerMLGPU", TYPE_CANVAS)

protected:
  void PrintInfo(std::stringstream& aStream, const char* aPrefix) override;
  void CleanupResources();
};

} // namespace layers
} // namespace mozilla

#endif /* GFX_CanvasLayerMLGPU_H */
