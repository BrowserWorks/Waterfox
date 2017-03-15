/* -*- Mode: C++; tab-width: 20; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef MOZILLA_GFX_COMPOSITORD3D11_H
#define MOZILLA_GFX_COMPOSITORD3D11_H

#include "mozilla/gfx/2D.h"
#include "gfx2DGlue.h"
#include "mozilla/layers/Compositor.h"
#include "TextureD3D11.h"
#include <d3d11.h>

class nsWidget;

namespace mozilla {
namespace layers {

#define LOGD3D11(param)

struct VertexShaderConstants
{
  float layerTransform[4][4];
  float projection[4][4];
  float renderTargetOffset[4];
  gfx::Rect textureCoords;
  gfx::Rect layerQuad;
  gfx::Rect maskQuad;
  float backdropTransform[4][4];
};

struct PixelShaderConstants
{
  float layerColor[4];
  float layerOpacity[4];
  int blendConfig[4];
  float yuvColorMatrix[3][4];
};

struct DeviceAttachmentsD3D11;

class CompositorD3D11 : public Compositor
{
public:
  CompositorD3D11(CompositorBridgeParent* aParent, widget::CompositorWidget* aWidget);
  ~CompositorD3D11();

  virtual CompositorD3D11* AsCompositorD3D11() override { return this; }

  virtual bool Initialize(nsCString* const out_failureReason) override;

  virtual TextureFactoryIdentifier
    GetTextureFactoryIdentifier() override;

  virtual already_AddRefed<DataTextureSource>
    CreateDataTextureSource(TextureFlags aFlags = TextureFlags::NO_FLAGS) override;

  virtual bool CanUseCanvasLayerForSize(const gfx::IntSize& aSize) override;
  virtual int32_t GetMaxTextureSize() const final;

  virtual void MakeCurrent(MakeCurrentFlags aFlags = 0)  override {}

  virtual already_AddRefed<CompositingRenderTarget>
    CreateRenderTarget(const gfx::IntRect &aRect,
                       SurfaceInitMode aInit) override;

  virtual already_AddRefed<CompositingRenderTarget>
    CreateRenderTargetFromSource(const gfx::IntRect& aRect,
                                 const CompositingRenderTarget* aSource,
                                 const gfx::IntPoint& aSourcePoint) override;

  virtual void SetRenderTarget(CompositingRenderTarget* aSurface) override;
  virtual CompositingRenderTarget* GetCurrentRenderTarget() const override
  {
    return mCurrentRT;
  }

  virtual void SetDestinationSurfaceSize(const gfx::IntSize& aSize) override {}

  /**
   * Declare an offset to use when rendering layers. This will be ignored when
   * rendering to a target instead of the screen.
   */
  virtual void SetScreenRenderOffset(const ScreenPoint& aOffset) override
  {
    if (aOffset.x || aOffset.y) {
      NS_RUNTIMEABORT("SetScreenRenderOffset not supported by CompositorD3D11.");
    }
    // If the offset is 0, 0 that's okay.
  }

  virtual void ClearRect(const gfx::Rect& aRect) override;

  virtual void DrawQuad(const gfx::Rect &aRect,
                        const gfx::IntRect &aClipRect,
                        const EffectChain &aEffectChain,
                        gfx::Float aOpacity,
                        const gfx::Matrix4x4& aTransform,
                        const gfx::Rect& aVisibleRect) override;

  /**
   * Start a new frame. If aClipRectIn is null, sets *aClipRectOut to the
   * screen dimensions. 
   */
  virtual void BeginFrame(const nsIntRegion& aInvalidRegion,
                          const gfx::IntRect *aClipRectIn,
                          const gfx::IntRect& aRenderBounds,
                          const nsIntRegion& aOpaqueRegion,
                          gfx::IntRect *aClipRectOut = nullptr,
                          gfx::IntRect *aRenderBoundsOut = nullptr) override;

  /**
   * Flush the current frame to the screen.
   */
  virtual void EndFrame() override;

  /**
   * Post rendering stuff if the rendering is outside of this Compositor
   * e.g., by Composer2D
   */
  virtual void EndFrameForExternalComposition(const gfx::Matrix& aTransform) override {}

  /**
   * Setup the viewport and projection matrix for rendering
   * to a window of the given dimensions.
   */
  virtual void PrepareViewport(const gfx::IntSize& aSize);
  virtual void PrepareViewport(const gfx::IntSize& aSize, const gfx::Matrix4x4& aProjection,
                               float aZNear, float aZFar);

  virtual bool SupportsPartialTextureUpdate() override { return true; }

#ifdef MOZ_DUMP_PAINTING
  virtual const char* Name() const override { return "Direct3D 11"; }
#endif

  virtual LayersBackend GetBackendType() const override {
    return LayersBackend::LAYERS_D3D11;
  }

  virtual void ForcePresent();

  ID3D11Device* GetDevice() { return mDevice; }

  ID3D11DeviceContext* GetDC() { return mContext; }

private:
  enum Severity {
    Recoverable,
    DebugAssert,
    Critical,
  };

  void HandleError(HRESULT hr, Severity aSeverity = DebugAssert);

  // Same as Failed(), except the severity is critical (with no abort) and
  // a string prefix must be provided.
  bool Failed(HRESULT hr, const char* aContext);

  // ensure mSize is up to date with respect to mWidget
  void EnsureSize();
  bool VerifyBufferSize();
  bool UpdateRenderTarget();
  bool UpdateConstantBuffers();
  void SetSamplerForSamplingFilter(gfx::SamplingFilter aSamplingFilter);
  ID3D11PixelShader* GetPSForEffect(Effect *aEffect, MaskType aMaskType);
  void PaintToTarget();
  RefPtr<ID3D11Texture2D> CreateTexture(const gfx::IntRect& aRect,
                                        const CompositingRenderTarget* aSource,
                                        const gfx::IntPoint& aSourcePoint);
  bool CopyBackdrop(const gfx::IntRect& aRect,
                    RefPtr<ID3D11Texture2D>* aOutTexture,
                    RefPtr<ID3D11ShaderResourceView>* aOutView);

  RefPtr<ID3D11DeviceContext> mContext;
  RefPtr<ID3D11Device> mDevice;
  RefPtr<IDXGISwapChain> mSwapChain;
  RefPtr<CompositingRenderTargetD3D11> mDefaultRT;
  RefPtr<CompositingRenderTargetD3D11> mCurrentRT;

  RefPtr<ID3D11Query> mQuery;

  DeviceAttachmentsD3D11* mAttachments;

  LayoutDeviceIntSize mSize;

  HWND mHwnd;

  D3D_FEATURE_LEVEL mFeatureLevel;

  VertexShaderConstants mVSConstants;
  PixelShaderConstants mPSConstants;
  bool mDisableSequenceForNextFrame;
  bool mAllowPartialPresents;

  gfx::IntRect mInvalidRect;
  // This is the clip rect applied to the default DrawTarget (i.e. the window)
  gfx::IntRect mCurrentClip;
  nsIntRegion mInvalidRegion;

  bool mVerifyBuffersFailed;
};

}
}

#endif
