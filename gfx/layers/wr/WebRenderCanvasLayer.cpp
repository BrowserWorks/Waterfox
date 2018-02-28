/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "WebRenderCanvasLayer.h"

#include "AsyncCanvasRenderer.h"
#include "gfxPrefs.h"
#include "gfxUtils.h"
#include "GLContext.h"
#include "GLScreenBuffer.h"
#include "LayersLogging.h"
#include "mozilla/gfx/2D.h"
#include "mozilla/layers/ScrollingLayersHelper.h"
#include "mozilla/layers/StackingContextHelper.h"
#include "mozilla/layers/TextureClientSharedSurface.h"
#include "mozilla/layers/WebRenderBridgeChild.h"
#include "PersistentBufferProvider.h"
#include "SharedSurface.h"
#include "SharedSurfaceGL.h"
#include "mozilla/webrender/WebRenderTypes.h"

namespace mozilla {
namespace layers {

WebRenderCanvasLayer::~WebRenderCanvasLayer()
{
  MOZ_COUNT_DTOR(WebRenderCanvasLayer);
  ClearWrResources();
}

void
WebRenderCanvasLayer::ClearWrResources()
{
  if (mExternalImageId.isSome()) {
    WrBridge()->DeallocExternalImageId(mExternalImageId.ref());
    mExternalImageId = Nothing();
  }
}

void
WebRenderCanvasLayer::Initialize(const Data& aData)
{
  ShareableCanvasLayer::Initialize(aData);

  // XXX: Use basic surface factory until we support shared surface.
  if (!mGLContext || mGLFrontbuffer)
    return;

  gl::GLScreenBuffer* screen = mGLContext->Screen();
  auto factory = MakeUnique<gl::SurfaceFactory_Basic>(mGLContext, screen->mCaps, mFlags);
  screen->Morph(Move(factory));
}

void
WebRenderCanvasLayer::RenderLayer(wr::DisplayListBuilder& aBuilder,
                                  const StackingContextHelper& aSc)
{
  UpdateCompositableClient();

  if (mExternalImageId.isNothing()) {
    mExternalImageId = Some(WrBridge()->AllocExternalImageIdForCompositable(mCanvasClient));
  }

  Maybe<gfx::Matrix4x4> transform;
  const bool needsYFlip = (mOriginPos == gl::OriginPos::BottomLeft);
  if (needsYFlip) {
    transform = Some(GetTransform().PreTranslate(0, mBounds.height, 0).PreScale(1, -1, 1));
  }

  ScrollingLayersHelper scroller(this, aBuilder, aSc);
  StackingContextHelper sc(aSc, aBuilder, this, transform);

  LayerRect rect(0, 0, mBounds.width, mBounds.height);
  DumpLayerInfo("CanvasLayer", rect);

  wr::ImageRendering filter = wr::ToImageRendering(mSamplingFilter);

  if (gfxPrefs::LayersDump()) {
    printf_stderr("CanvasLayer %p texture-filter=%s\n",
                  this->GetLayer(),
                  Stringify(filter).c_str());
  }

  wr::WrImageKey key = GenerateImageKey();
  WrBridge()->AddWebRenderParentCommand(OpAddExternalImage(mExternalImageId.value(), key));
  WrManager()->AddImageKeyForDiscard(key);

  wr::LayoutRect r = sc.ToRelativeLayoutRect(rect);
  aBuilder.PushImage(r, r, filter, key);
}

void
WebRenderCanvasLayer::AttachCompositable()
{
  mCanvasClient->Connect();
}

CompositableForwarder*
WebRenderCanvasLayer::GetForwarder()
{
  return WrManager()->WrBridge();
}

void
WebRenderCanvasLayer::ClearCachedResources()
{
  ClearWrResources();
  if (mBufferProvider) {
    mBufferProvider->ClearCachedResources();
  }
  if (mCanvasClient) {
    mCanvasClient->Clear();
  }
}

} // namespace layers
} // namespace mozilla
