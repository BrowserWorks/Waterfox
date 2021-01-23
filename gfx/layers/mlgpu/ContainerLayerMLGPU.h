/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_gfx_layers_mlgpu_ContainerLayerMLGPU_h
#define mozilla_gfx_layers_mlgpu_ContainerLayerMLGPU_h

#include "LayerMLGPU.h"
#include "MLGDeviceTypes.h"

namespace mozilla {
namespace layers {

class MLGDevice;
class RenderViewMLGPU;

class ContainerLayerMLGPU final : public ContainerLayer, public LayerMLGPU {
 public:
  explicit ContainerLayerMLGPU(LayerManagerMLGPU* aManager);
  virtual ~ContainerLayerMLGPU();

  MOZ_LAYER_DECL_NAME("ContainerLayerMLGPU", TYPE_CONTAINER)

  HostLayer* AsHostLayer() override { return this; }
  ContainerLayerMLGPU* AsContainerLayerMLGPU() override { return this; }
  Layer* GetLayer() override { return this; }

  void ComputeEffectiveTransforms(
      const gfx::Matrix4x4& aTransformToSurface) override {
    DefaultComputeEffectiveTransforms(aTransformToSurface);
  }
  void SetInvalidCompositeRect(const gfx::IntRect* aRect) override;
  void ClearCachedResources() override;

  const LayerIntRegion& GetShadowVisibleRegion() override;

  RefPtr<MLGRenderTarget> UpdateRenderTarget(MLGDevice* aDevice,
                                             MLGRenderTargetFlags aFlags);

  MLGRenderTarget* GetRenderTarget() const { return mRenderTarget; }
  gfx::IntPoint GetTargetOffset() const { return mTargetOffset; }
  gfx::IntSize GetTargetSize() const { return mTargetSize; }
  const gfx::IntRect& GetInvalidRect() const { return mInvalidRect; }
  void ClearInvalidRect() { mInvalidRect.SetEmpty(); }
  bool IsContentOpaque() override;
  bool NeedsSurfaceCopy() const { return mSurfaceCopyNeeded; }

  RenderViewMLGPU* GetRenderView() const { return mView; }
  void SetRenderView(RenderViewMLGPU* aView) {
    MOZ_ASSERT(!mView);
    mView = aView;
  }

  void ComputeIntermediateSurfaceBounds();

  // Similar to ContainerLayerComposite, we need to include the pres shell
  // resolution, if there is one, in the layer's post-scale.
  float GetPostXScale() const override {
    return mSimpleAttrs.GetPostXScale() * mPresShellResolution;
  }
  float GetPostYScale() const override {
    return mSimpleAttrs.GetPostYScale() * mPresShellResolution;
  }

 protected:
  bool OnPrepareToRender(FrameBuilder* aBuilder) override;
  void OnLayerManagerChange(LayerManagerMLGPU* aManager) override;

 private:
  static Maybe<gfx::IntRect> FindVisibleBounds(
      Layer* aLayer, const Maybe<RenderTargetIntRect>& aClip);

  RefPtr<MLGRenderTarget> mRenderTarget;

  // We cache these since occlusion culling can change the visible region.
  gfx::IntPoint mTargetOffset;
  gfx::IntSize mTargetSize;

  // The region of the container that needs to be recomposited if visible. We
  // store this as a rectangle instead of an nsIntRegion for efficiency. This
  // is in layer coordinates.
  gfx::IntRect mInvalidRect;
  bool mInvalidateEntireSurface;
  bool mSurfaceCopyNeeded;

  // This is only valid for intermediate surfaces while an instance of
  // FrameBuilder is live.
  RenderViewMLGPU* mView;
};

}  // namespace layers
}  // namespace mozilla

#endif  // mozilla_gfx_layers_mlgpu_ContainerLayerMLGPU_h
