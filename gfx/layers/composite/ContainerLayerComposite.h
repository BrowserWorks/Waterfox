/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef GFX_ContainerLayerComposite_H
#define GFX_ContainerLayerComposite_H

#include "Layers.h"              // for Layer (ptr only), etc
#include "mozilla/Attributes.h"  // for override
#include "mozilla/UniquePtr.h"   // for UniquePtr
#include "mozilla/layers/LayerManagerComposite.h"
#include "mozilla/gfx/Rect.h"

namespace mozilla {
namespace layers {

class APZSampler;
class CompositableHost;
class CompositingRenderTarget;
struct PreparedData;

class ContainerLayerComposite : public ContainerLayer, public LayerComposite {
  template <class ContainerT>
  friend void ContainerPrepare(ContainerT* aContainer,
                               LayerManagerComposite* aManager,
                               const RenderTargetIntRect& aClipRect);
  template <class ContainerT>
  friend void ContainerRender(ContainerT* aContainer,
                              LayerManagerComposite* aManager,
                              const RenderTargetIntRect& aClipRect,
                              const Maybe<gfx::Polygon>& aGeometry);
  template <class ContainerT>
  friend void RenderLayers(ContainerT* aContainer,
                           LayerManagerComposite* aManager,
                           const RenderTargetIntRect& aClipRect,
                           const Maybe<gfx::Polygon>& aGeometry);
  template <class ContainerT>
  friend void RenderIntermediate(ContainerT* aContainer,
                                 LayerManagerComposite* aManager,
                                 const gfx::IntRect& aClipRect,
                                 RefPtr<CompositingRenderTarget> surface);
  template <class ContainerT>
  friend RefPtr<CompositingRenderTarget>
  CreateTemporaryTargetAndCopyFromBackground(
      ContainerT* aContainer, LayerManagerComposite* aManager,
      const RenderTargetIntRect& aClipRect);
  template <class ContainerT>
  friend RefPtr<CompositingRenderTarget> CreateOrRecycleTarget(
      ContainerT* aContainer, LayerManagerComposite* aManager,
      const RenderTargetIntRect& aClipRect);

  template <class ContainerT>
  void RenderMinimap(ContainerT* aContainer, const RefPtr<APZSampler>& aSampler,
                     LayerManagerComposite* aManager,
                     const RenderTargetIntRect& aClipRect, Layer* aLayer);

 public:
  explicit ContainerLayerComposite(LayerManagerComposite* aManager);

 protected:
  virtual ~ContainerLayerComposite();

 public:
  // LayerComposite Implementation
  Layer* GetLayer() override { return this; }

  void SetLayerManager(HostLayerManager* aManager) override {
    LayerComposite::SetLayerManager(aManager);
    mManager = aManager;
    mLastIntermediateSurface = nullptr;
  }

  void Destroy() override;

  LayerComposite* GetFirstChildComposite() override;

  void Cleanup() override;

  void RenderLayer(const gfx::IntRect& aClipRect,
                   const Maybe<gfx::Polygon>& aGeometry) override;

  void Prepare(const RenderTargetIntRect& aClipRect) override;

  void ComputeEffectiveTransforms(
      const gfx::Matrix4x4& aTransformToSurface) override {
    DefaultComputeEffectiveTransforms(aTransformToSurface);
  }

  const LayerIntRegion& GetShadowVisibleRegion() override;

  void CleanupResources() override;

  HostLayer* AsHostLayer() override { return this; }

  // container layers don't use a compositable
  CompositableHost* GetCompositableHost() override { return nullptr; }

  // If the layer has a pres shell resolution, add a post-scale
  // to the layer's transform equal to the pres shell resolution we're
  // scaling to. This cancels out the post scale of '1 / resolution'
  // added by Layout. TODO: It would be nice to get rid of both of these
  // post-scales.
  float GetPostXScale() const override {
    return mSimpleAttrs.GetPostXScale() * mPresShellResolution;
  }
  float GetPostYScale() const override {
    return mSimpleAttrs.GetPostYScale() * mPresShellResolution;
  }

  const char* Name() const override { return "ContainerLayerComposite"; }
  UniquePtr<PreparedData> mPrepared;

  RefPtr<CompositingRenderTarget> mLastIntermediateSurface;
};

class RefLayerComposite : public RefLayer, public LayerComposite {
  template <class ContainerT>
  friend void ContainerPrepare(ContainerT* aContainer,
                               LayerManagerComposite* aManager,
                               const RenderTargetIntRect& aClipRect);
  template <class ContainerT>
  friend void ContainerRender(ContainerT* aContainer,
                              LayerManagerComposite* aManager,
                              const gfx::IntRect& aClipRect,
                              const Maybe<gfx::Polygon>& aGeometry);
  template <class ContainerT>
  friend void RenderLayers(ContainerT* aContainer,
                           LayerManagerComposite* aManager,
                           const gfx::IntRect& aClipRect,
                           const Maybe<gfx::Polygon>& aGeometry);
  template <class ContainerT>
  friend void RenderIntermediate(ContainerT* aContainer,
                                 LayerManagerComposite* aManager,
                                 const gfx::IntRect& aClipRect,
                                 RefPtr<CompositingRenderTarget> surface);
  template <class ContainerT>
  friend RefPtr<CompositingRenderTarget>
  CreateTemporaryTargetAndCopyFromBackground(ContainerT* aContainer,
                                             LayerManagerComposite* aManager,
                                             const gfx::IntRect& aClipRect);
  template <class ContainerT>
  friend RefPtr<CompositingRenderTarget> CreateTemporaryTarget(
      ContainerT* aContainer, LayerManagerComposite* aManager,
      const gfx::IntRect& aClipRect);

 public:
  explicit RefLayerComposite(LayerManagerComposite* aManager);

 protected:
  virtual ~RefLayerComposite();

 public:
  /** LayerOGL implementation */
  Layer* GetLayer() override { return this; }

  void SetLayerManager(HostLayerManager* aManager) override {
    LayerComposite::SetLayerManager(aManager);
    mManager = aManager;
    mLastIntermediateSurface = nullptr;
  }

  void Destroy() override;

  LayerComposite* GetFirstChildComposite() override;

  void RenderLayer(const gfx::IntRect& aClipRect,
                   const Maybe<gfx::Polygon>& aGeometry) override;

  void Prepare(const RenderTargetIntRect& aClipRect) override;

  void ComputeEffectiveTransforms(
      const gfx::Matrix4x4& aTransformToSurface) override {
    DefaultComputeEffectiveTransforms(aTransformToSurface);
  }

  const LayerIntRegion& GetShadowVisibleRegion() override;

  void Cleanup() override;

  void CleanupResources() override;

  HostLayer* AsHostLayer() override { return this; }

  // ref layers don't use a compositable
  CompositableHost* GetCompositableHost() override { return nullptr; }

  const char* Name() const override { return "RefLayerComposite"; }
  UniquePtr<PreparedData> mPrepared;
  RefPtr<CompositingRenderTarget> mLastIntermediateSurface;
};

}  // namespace layers
}  // namespace mozilla

#endif /* GFX_ContainerLayerComposite_H */
