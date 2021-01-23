/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef MOZILLA_GFX_RENDERCOMPOSITOR_H
#define MOZILLA_GFX_RENDERCOMPOSITOR_H

#include "mozilla/RefPtr.h"
#include "mozilla/UniquePtr.h"
#include "mozilla/webrender/WebRenderTypes.h"
#include "Units.h"

namespace mozilla {

namespace gl {
class GLContext;
}

namespace layers {
class SyncObjectHost;
}  // namespace layers

namespace widget {
class CompositorWidget;
}

namespace wr {

class RenderCompositor {
 public:
  static UniquePtr<RenderCompositor> Create(
      RefPtr<widget::CompositorWidget>&& aWidget);

  RenderCompositor(RefPtr<widget::CompositorWidget>&& aWidget);
  virtual ~RenderCompositor();

  virtual bool BeginFrame() = 0;

  // Called to notify the RenderCompositor that all of the commands for a frame
  // have been pushed to the queue.
  // @return a RenderedFrameId for the frame
  virtual RenderedFrameId EndFrame(
      const nsTArray<DeviceIntRect>& aDirtyRects) = 0;
  // Returns false when waiting gpu tasks is failed.
  // It might happen when rendering context is lost.
  virtual bool WaitForGPU() { return true; }

  // Check for and return the last completed frame.
  // @return the last (highest) completed RenderedFrameId
  virtual RenderedFrameId GetLastCompletedFrameId() {
    return mLatestRenderFrameId.Prev();
  }

  // Update FrameId when WR rendering does not happen.
  virtual RenderedFrameId UpdateFrameId() { return GetNextRenderFrameId(); }

  virtual void Pause() = 0;
  virtual bool Resume() = 0;
  // Called when WR rendering is skipped
  virtual void Update() {}

  virtual gl::GLContext* gl() const { return nullptr; }

  virtual bool MakeCurrent();

  virtual bool UseANGLE() const { return false; }

  virtual bool UseDComp() const { return false; }

  virtual bool UseTripleBuffering() const { return false; }

  virtual LayoutDeviceIntSize GetBufferSize() = 0;

  widget::CompositorWidget* GetWidget() const { return mWidget; }

  layers::SyncObjectHost* GetSyncObject() const { return mSyncObject.get(); }

  virtual bool IsContextLost();

  virtual bool SupportAsyncScreenshot() { return true; }

  virtual bool ShouldUseNativeCompositor() { return false; }
  virtual uint32_t GetMaxUpdateRects() { return 0; }

  // Interface for wr::Compositor
  virtual void CompositorBeginFrame() {}
  virtual void CompositorEndFrame() {}
  virtual void Bind(wr::NativeTileId aId, wr::DeviceIntPoint* aOffset,
                    uint32_t* aFboId, wr::DeviceIntRect aDirtyRect,
                    wr::DeviceIntRect aValidRect) {}
  virtual void Unbind() {}
  virtual void CreateSurface(wr::NativeSurfaceId aId,
                             wr::DeviceIntPoint aVirtualOffset,
                             wr::DeviceIntSize aTileSize, bool aIsOpaque) {}
  virtual void DestroySurface(NativeSurfaceId aId) {}
  virtual void CreateTile(wr::NativeSurfaceId, int32_t aX, int32_t aY) {}
  virtual void DestroyTile(wr::NativeSurfaceId, int32_t aX, int32_t aY) {}
  virtual void AddSurface(wr::NativeSurfaceId aId, wr::DeviceIntPoint aPosition,
                          wr::DeviceIntRect aClipRect) {}
  virtual void EnableNativeCompositor(bool aEnable) {}
  virtual void DeInit() {}
  virtual CompositorCapabilities GetCompositorCapabilities() = 0;

  // Interface for partial present
  virtual bool UsePartialPresent() { return false; }
  virtual bool RequestFullRender() { return false; }
  virtual uint32_t GetMaxPartialPresentRects() { return 0; }
  virtual bool ShouldDrawPreviousPartialPresentRegions() { return false; }

  // Whether the surface origin is top-left.
  virtual bool SurfaceOriginIsTopLeft() { return false; }

  // Does readback if wr_renderer_readback() could not get correct WR rendered
  // result. It could happen when WebRender renders to multiple overlay layers.
  virtual bool MaybeReadback(const gfx::IntSize& aReadbackSize,
                             const wr::ImageFormat& aReadbackFormat,
                             const Range<uint8_t>& aReadbackBuffer) {
    return false;
  }

 protected:
  // We default this to 2, so that mLatestRenderFrameId.Prev() is always valid.
  RenderedFrameId mLatestRenderFrameId = RenderedFrameId{2};
  RenderedFrameId GetNextRenderFrameId() {
    mLatestRenderFrameId = mLatestRenderFrameId.Next();
    return mLatestRenderFrameId;
  }

  RefPtr<widget::CompositorWidget> mWidget;
  RefPtr<layers::SyncObjectHost> mSyncObject;
};

}  // namespace wr
}  // namespace mozilla

#endif
