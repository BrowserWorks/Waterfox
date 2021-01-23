/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef MOZILLA_GFX_CANVASCLIENT_H
#define MOZILLA_GFX_CANVASCLIENT_H

#include "mozilla/Assertions.h"                 // for MOZ_ASSERT, etc
#include "mozilla/Attributes.h"                 // for override
#include "mozilla/RefPtr.h"                     // for RefPtr, already_AddRefed
#include "mozilla/layers/CompositableClient.h"  // for CompositableClient
#include "mozilla/layers/CompositorTypes.h"     // for TextureInfo, etc
#include "mozilla/layers/LayersSurfaces.h"      // for SurfaceDescriptor
#include "mozilla/layers/TextureClient.h"       // for TextureClient, etc
#include "mozilla/layers/PersistentBufferProvider.h"

#include "mozilla/MaybeOneOf.h"

#include "mozilla/mozalloc.h"  // for operator delete

#include "mozilla/gfx/Point.h"  // for IntSize
#include "mozilla/gfx/Types.h"  // for SurfaceFormat

class nsICanvasRenderingContextInternal;

namespace mozilla {
namespace layers {

class AsyncCanvasRenderer;
class ShareableCanvasRenderer;
class CompositableForwarder;
class ShadowableLayer;
class SharedSurfaceTextureClient;
class OOPCanvasRenderer;

/**
 * Compositable client for 2d and webgl canvas.
 */
class CanvasClient : public CompositableClient {
 public:
  typedef MaybeOneOf<ShareableCanvasRenderer*, AsyncCanvasRenderer*> Renderer;

  /**
   * Creates, configures, and returns a new canvas client. If necessary, a
   * message will be sent to the compositor to create a corresponding image
   * host.
   */
  enum CanvasClientType {
    CanvasClientSurface,
    CanvasClientGLContext,
    CanvasClientTypeShSurf,
    CanvasClientAsync,    // webgl on workers
    CanvasClientTypeOOP,  // webgl in remote process
  };
  static already_AddRefed<CanvasClient> CreateCanvasClient(
      CanvasClientType aType, CompositableForwarder* aFwd, TextureFlags aFlags);

  CanvasClient(CompositableForwarder* aFwd, TextureFlags aFlags)
      : CompositableClient(aFwd, aFlags), mFrameID(0) {
    mTextureFlags = aFlags;
  }

  virtual ~CanvasClient() = default;

  virtual void Clear(){};

  virtual void Update(gfx::IntSize aSize,
                      ShareableCanvasRenderer* aCanvasRenderer) = 0;

  bool AddTextureClient(TextureClient* aTexture) override {
    ++mFrameID;
    return CompositableClient::AddTextureClient(aTexture);
  }

  virtual void UpdateAsync(AsyncCanvasRenderer* aRenderer) {}

  virtual void UpdateFromTexture(TextureClient* aTexture) {}

  virtual void Updated() {}

 protected:
  int32_t mFrameID;
};

// Used for 2D canvases and WebGL canvas on non-GL systems where readback is
// requried.
class CanvasClient2D : public CanvasClient {
 public:
  CanvasClient2D(CompositableForwarder* aLayerForwarder, TextureFlags aFlags)
      : CanvasClient(aLayerForwarder, aFlags) {}

  TextureInfo GetTextureInfo() const override {
    return TextureInfo(CompositableType::IMAGE, mTextureFlags);
  }

  void Clear() override {
    mBackBuffer = mFrontBuffer = mBufferProviderTexture = nullptr;
  }

  void Update(gfx::IntSize aSize,
              ShareableCanvasRenderer* aCanvasRenderer) override;

  void UpdateFromTexture(TextureClient* aBuffer) override;

  bool AddTextureClient(TextureClient* aTexture) override {
    return CanvasClient::AddTextureClient(aTexture);
  }

  void OnDetach() override { mBackBuffer = mFrontBuffer = nullptr; }

 private:
  already_AddRefed<TextureClient> CreateTextureClientForCanvas(
      gfx::SurfaceFormat aFormat, gfx::IntSize aSize, TextureFlags aFlags,
      ShareableCanvasRenderer* aCanvasRenderer);

  RefPtr<TextureClient> mBackBuffer;
  RefPtr<TextureClient> mFrontBuffer;
  // We store this texture separately to make sure it is not written into
  // in Update() if for some silly reason we end up alternating between
  // UpdateFromTexture and Update.
  // This code is begging for a cleanup. The situation described above should
  // not be made possible.
  RefPtr<TextureClient> mBufferProviderTexture;
};

// Used for GL canvases where we don't need to do any readback, i.e., with a
// GL backend.
class CanvasClientSharedSurface : public CanvasClient {
 private:
  RefPtr<SharedSurfaceTextureClient> mShSurfClient;
  RefPtr<TextureClient> mReadbackClient;
  RefPtr<TextureClient> mFront;
  RefPtr<TextureClient> mNewFront;

  void ClearSurfaces();

 public:
  CanvasClientSharedSurface(CompositableForwarder* aLayerForwarder,
                            TextureFlags aFlags);

  ~CanvasClientSharedSurface();

  TextureInfo GetTextureInfo() const override {
    return TextureInfo(CompositableType::IMAGE);
  }

  void Clear() override { ClearSurfaces(); }

  void Update(gfx::IntSize aSize,
              ShareableCanvasRenderer* aCanvasRenderer) override;
  void UpdateRenderer(gfx::IntSize aSize, Renderer& aRenderer);

  void UpdateAsync(AsyncCanvasRenderer* aRenderer) override;

  void Updated() override;

  void OnDetach() override;
};

/**
 * Used for OMT<canvas> uploads using the image bridge protocol.
 * Actual CanvasClient is on the ImageBridgeChild thread, so we
 * only forward its AsyncID here
 */
class CanvasClientBridge final : public CanvasClient {
 public:
  CanvasClientBridge(CompositableForwarder* aLayerForwarder,
                     TextureFlags aFlags)
      : CanvasClient(aLayerForwarder, aFlags), mLayer(nullptr) {
    mIsAsync = true;
  }

  TextureInfo GetTextureInfo() const override {
    return TextureInfo(CompositableType::IMAGE);
  }

  void Update(gfx::IntSize aSize,
              ShareableCanvasRenderer* aCanvasRenderer) override {}

  void UpdateAsync(AsyncCanvasRenderer* aRenderer) override;

  void SetLayer(ShadowableLayer* aLayer) { mLayer = aLayer; }

 protected:
  CompositableHandle mAsyncHandle;
  ShadowableLayer* mLayer;
};

/**
 * Used for WebGL instances that perform all composition in the host process.
 */
class CanvasClientOOP final : public CanvasClient {
 public:
  CanvasClientOOP(CompositableForwarder* aLayerForwarder, TextureFlags aFlags);
  ~CanvasClientOOP();

  TextureInfo GetTextureInfo() const override {
    return TextureInfo(CompositableType::IMAGE);
  }

  virtual void Update(gfx::IntSize aSize,
                      ShareableCanvasRenderer* aCanvasRenderer) override;

  virtual void UpdateAsync(AsyncCanvasRenderer* aRenderer) override {
    MOZ_ASSERT_UNREACHABLE("Illegal to call UpdateAsync on CanvasClientOOP");
  }

  void SetLayer(ShadowableLayer* aLayer, OOPCanvasRenderer* aRenderer);

 protected:
  nsICanvasRenderingContextInternal* mCanvasContext = nullptr;
  ShadowableLayer* mLayer = nullptr;
  CompositableHandle mHandle;
};

}  // namespace layers
}  // namespace mozilla

#endif
