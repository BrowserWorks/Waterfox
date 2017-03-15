/* -*- Mode: C++; tab-width: 20; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef MOZILLA_GFX_COMPOSITORD3D9_H
#define MOZILLA_GFX_COMPOSITORD3D9_H

#include "mozilla/gfx/2D.h"
#include "mozilla/gfx/Point.h"
#include "gfx2DGlue.h"
#include "mozilla/layers/Compositor.h"
#include "mozilla/layers/TextureD3D9.h"
#include "DeviceManagerD3D9.h"

class nsWidget;

namespace mozilla {
namespace layers {

class CompositorD3D9 : public Compositor
{
public:
  CompositorD3D9(CompositorBridgeParent* aParent, widget::CompositorWidget* aWidget);
  ~CompositorD3D9();

  virtual CompositorD3D9* AsCompositorD3D9() override { return this; }

  virtual bool Initialize(nsCString* const out_failureReason) override;

  virtual TextureFactoryIdentifier
    GetTextureFactoryIdentifier() override;

  virtual bool CanUseCanvasLayerForSize(const gfx::IntSize &aSize) override;
  virtual int32_t GetMaxTextureSize() const final;

  virtual void MakeCurrent(MakeCurrentFlags aFlags = 0) override {}

  virtual already_AddRefed<CompositingRenderTarget>
    CreateRenderTarget(const gfx::IntRect &aRect,
                       SurfaceInitMode aInit) override;

  virtual already_AddRefed<CompositingRenderTarget>
    CreateRenderTargetFromSource(const gfx::IntRect &aRect,
                                 const CompositingRenderTarget *aSource,
                                 const gfx::IntPoint &aSourcePoint) override;

  virtual void SetRenderTarget(CompositingRenderTarget *aSurface) override;
  virtual CompositingRenderTarget* GetCurrentRenderTarget() const override
  {
    return mCurrentRT;
  }

  virtual void SetDestinationSurfaceSize(const gfx::IntSize& aSize) override {}

  virtual void ClearRect(const gfx::Rect& aRect) override;

  virtual void DrawQuad(const gfx::Rect &aRect,
                        const gfx::IntRect &aClipRect,
                        const EffectChain &aEffectChain,
                        gfx::Float aOpacity,
                        const gfx::Matrix4x4& aTransform,
                        const gfx::Rect& aVisibleRect) override;

  virtual void BeginFrame(const nsIntRegion& aInvalidRegion,
                          const gfx::IntRect *aClipRectIn,
                          const gfx::IntRect& aRenderBounds,
                          const nsIntRegion& aOpaqueRegion,
                          gfx::IntRect *aClipRectOut = nullptr,
                          gfx::IntRect *aRenderBoundsOut = nullptr) override;

  virtual void EndFrame() override;

  virtual void EndFrameForExternalComposition(const gfx::Matrix& aTransform) override {}

  virtual void PrepareViewport(const gfx::IntSize& aSize);

  virtual bool SupportsPartialTextureUpdate() override{ return true; }

  virtual bool SupportsEffect(EffectTypes aEffect) override;

#ifdef MOZ_DUMP_PAINTING
  virtual const char* Name() const override { return "Direct3D9"; }
#endif

  virtual LayersBackend GetBackendType() const override {
    return LayersBackend::LAYERS_D3D9;
  }

  IDirect3DDevice9* device() const
  {
    // If the reset counts don't match it means the device was lost and we are
    // in the process of recreating a new one or will be soon.
    // cf. comment in EnsureSwapChain.
    return mDeviceManager && mDeviceResetCount == mDeviceManager->GetDeviceResetCount()
           ? mDeviceManager->device()
           : nullptr;
  }

  /**
   * Returns true if the Compositor is ready to go.
   * D3D9 devices can be awkward and there is a bunch of logic around
   * resetting/recreating devices and swap chains. That is handled by this method.
   * If we don't have a device and swap chain ready for rendering, we will return
   * false and if necessary destroy the device and/or swap chain. We will also
   * schedule another composite so we get another go at rendering, thus we shouldn't
   * miss a composite due to re-creating a device.
   */
  virtual bool Ready() override;

  /**
   * Declare an offset to use when rendering layers. This will be ignored when
   * rendering to a target instead of the screen.
   */
  virtual void SetScreenRenderOffset(const ScreenPoint& aOffset) override
  {
    if (aOffset.x || aOffset.y) {
      NS_RUNTIMEABORT("SetScreenRenderOffset not supported by CompositorD3D9.");
    }
    // If the offset is 0, 0 that's okay.
  }

  virtual already_AddRefed<DataTextureSource>
    CreateDataTextureSource(TextureFlags aFlags = TextureFlags::NO_FLAGS) override;
private:
  // ensure mSize is up to date with respect to mWidget
  void EnsureSize();
  void SetSamplerForSamplingFilter(gfx::SamplingFilter aSamplingFilter);
  void PaintToTarget();
  void SetMask(const EffectChain &aEffectChain, uint32_t aMaskTexture);
  /**
   * Ensure we have a swap chain and it is ready for rendering.
   * Requires mDeviceManger to be non-null.
   * Returns true if we have a working swap chain; false otherwise.
   * If we cannot create or validate the swap chain due to a bad device manager,
   * then the device will be destroyed and set mDeviceManager to null. We will
   * schedule another composite if it is a good idea to try again or we need to
   * recreate the device.
   */
  bool EnsureSwapChain();

  already_AddRefed<IDirect3DTexture9>
  CreateTexture(const gfx::IntRect& aRect,
                const CompositingRenderTarget* aSource,
                const gfx::IntPoint& aSourcePoint);

  /**
   * Complete a mix-blend step at the end of DrawQuad().
   */
  void FinishMixBlend(const gfx::IntRect& aBackdropRect,
                      const gfx::Rect& aBackdropDest,
                      const gfx::Matrix4x4& aBackdropTransform,
                      RefPtr<IDirect3DTexture9> aBackdrop,
                      gfx::CompositionOp aBlendMode);

  /**
   * DeviceManagerD3D9 keeps a count of the number of times its device is
   * reset or recreated. We keep a parallel count (mDeviceResetCount). It
   * is possible that we miss a reset if it is 'caused' by another
   * compositor (for another window). In which case we need to invalidate
   * everything and render it all. This method checks the reset counts
   * match and if not invalidates everything (a long comment on that in
   * the cpp file).
   */
  void CheckResetCount();

  void FailedToResetDevice();

  void ReportFailure(const nsACString &aMsg, HRESULT aCode);

  /* Device manager instance for this compositor */
  RefPtr<DeviceManagerD3D9> mDeviceManager;

  /* Swap chain associated with this compositor */
  RefPtr<SwapChainD3D9> mSwapChain;

  RefPtr<CompositingRenderTargetD3D9> mDefaultRT;
  RefPtr<CompositingRenderTargetD3D9> mCurrentRT;

  LayoutDeviceIntSize mSize;

  uint32_t mDeviceResetCount;
  uint32_t mFailedResetAttempts;
};

}
}

#endif
