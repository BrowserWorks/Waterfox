/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "DrawTargetCapture.h"
#include "DrawCommand.h"
#include "DrawCommands.h"
#include "gfxPlatform.h"
#include "SourceSurfaceCapture.h"
#include "FilterNodeCapture.h"
#include "PathCapture.h"

namespace mozilla {
namespace gfx {

DrawTargetCaptureImpl::~DrawTargetCaptureImpl() {
  if (mSnapshot && !mSnapshot->hasOneRef()) {
    mSnapshot->DrawTargetWillDestroy();
    mSnapshot = nullptr;
  }
}

DrawTargetCaptureImpl::DrawTargetCaptureImpl(gfx::DrawTarget* aTarget,
                                             size_t aFlushBytes)
    : mSnapshot(nullptr),
      mStride(0),
      mSurfaceAllocationSize(0),
      mFlushBytes(aFlushBytes) {
  mSize = aTarget->GetSize();
  mCurrentClipBounds.push(IntRect(IntPoint(0, 0), mSize));
  mFormat = aTarget->GetFormat();
  SetPermitSubpixelAA(aTarget->GetPermitSubpixelAA());

  mRefDT = aTarget;
}

DrawTargetCaptureImpl::DrawTargetCaptureImpl(BackendType aBackend,
                                             const IntSize& aSize,
                                             SurfaceFormat aFormat)
    : mSize(aSize),
      mSnapshot(nullptr),
      mStride(0),
      mSurfaceAllocationSize(0),
      mFlushBytes(0) {
  RefPtr<DrawTarget> screenRefDT =
      gfxPlatform::GetPlatform()->ScreenReferenceDrawTarget();

  mCurrentClipBounds.push(IntRect(IntPoint(0, 0), aSize));
  mFormat = aFormat;
  SetPermitSubpixelAA(IsOpaque(mFormat));
  if (aBackend == screenRefDT->GetBackendType()) {
    mRefDT = screenRefDT;
  } else {
    // This situation can happen if a blur operation decides to
    // use an unaccelerated path even if the system backend is
    // Direct2D.
    //
    // We don't really want to encounter the reverse scenario:
    // we shouldn't pick an accelerated backend if the system
    // backend is skia.
    if (aBackend == BackendType::DIRECT2D1_1) {
      gfxWarning() << "Creating a RefDT in DrawTargetCapture.";
    }

    // Create a 1x1 size ref dt to create assets
    // If we have to snapshot, we'll just create the real DT
    IntSize size(1, 1);
    mRefDT = Factory::CreateDrawTarget(aBackend, size, mFormat);
  }
}

bool DrawTargetCaptureImpl::Init(const IntSize& aSize, DrawTarget* aRefDT) {
  if (!aRefDT) {
    return false;
  }

  mRefDT = aRefDT;

  mSize = aSize;
  mCurrentClipBounds.push(IntRect(IntPoint(0, 0), aSize));

  mFormat = aRefDT->GetFormat();
  SetPermitSubpixelAA(IsOpaque(mFormat));
  return true;
}

void DrawTargetCaptureImpl::InitForData(int32_t aStride,
                                        size_t aSurfaceAllocationSize) {
  MOZ_ASSERT(!mFlushBytes);
  mStride = aStride;
  mSurfaceAllocationSize = aSurfaceAllocationSize;
}

already_AddRefed<SourceSurface> DrawTargetCaptureImpl::Snapshot() {
  if (!mSnapshot) {
    mSnapshot = new SourceSurfaceCapture(this);
  }

  RefPtr<SourceSurface> surface = mSnapshot;
  return surface.forget();
}

already_AddRefed<SourceSurface> DrawTargetCaptureImpl::IntoLuminanceSource(
    LuminanceType aLuminanceType, float aOpacity) {
  RefPtr<SourceSurface> surface =
      new SourceSurfaceCapture(this, aLuminanceType, aOpacity);
  return surface.forget();
}

already_AddRefed<SourceSurface> DrawTargetCaptureImpl::OptimizeSourceSurface(
    SourceSurface* aSurface) const {
  // If the surface is a recording, make sure it gets resolved on the paint
  // thread.
  if (aSurface->GetType() == SurfaceType::CAPTURE) {
    RefPtr<SourceSurface> surface = aSurface;
    return surface.forget();
  }
  RefPtr<SourceSurfaceCapture> surface = new SourceSurfaceCapture(
      const_cast<DrawTargetCaptureImpl*>(this), aSurface);
  return surface.forget();
}

void DrawTargetCaptureImpl::DetachAllSnapshots() { MarkChanged(); }

#define AppendCommand(arg) new (AppendToCommandList<arg>()) arg
#define ReuseOrAppendCommand(arg) new (ReuseOrAppendToCommandList<arg>()) arg

void DrawTargetCaptureImpl::SetPermitSubpixelAA(bool aPermitSubpixelAA) {
  // Save memory by eliminating state changes with no effect
  if (mPermitSubpixelAA == aPermitSubpixelAA) {
    return;
  }

  ReuseOrAppendCommand(SetPermitSubpixelAACommand)(aPermitSubpixelAA);

  // Have to update mPermitSubpixelAA for this DT
  // because some code paths query the current setting
  // to determine subpixel AA eligibility.
  DrawTarget::SetPermitSubpixelAA(aPermitSubpixelAA);
}

void DrawTargetCaptureImpl::DrawSurface(SourceSurface* aSurface,
                                        const Rect& aDest, const Rect& aSource,
                                        const DrawSurfaceOptions& aSurfOptions,
                                        const DrawOptions& aOptions) {
  aSurface->GuaranteePersistance();
  AppendCommand(DrawSurfaceCommand)(aSurface, aDest, aSource, aSurfOptions,
                                    aOptions);
}

void DrawTargetCaptureImpl::DrawSurfaceWithShadow(
    SourceSurface* aSurface, const Point& aDest, const DeviceColor& aColor,
    const Point& aOffset, Float aSigma, CompositionOp aOperator) {
  aSurface->GuaranteePersistance();
  AppendCommand(DrawSurfaceWithShadowCommand)(aSurface, aDest, aColor, aOffset,
                                              aSigma, aOperator);
}

void DrawTargetCaptureImpl::DrawFilter(FilterNode* aNode,
                                       const Rect& aSourceRect,
                                       const Point& aDestPoint,
                                       const DrawOptions& aOptions) {
  // @todo XXX - this won't work properly long term yet due to filternodes not
  // being immutable.
  AppendCommand(DrawFilterCommand)(aNode, aSourceRect, aDestPoint, aOptions);
}

void DrawTargetCaptureImpl::ClearRect(const Rect& aRect) {
  AppendCommand(ClearRectCommand)(aRect);
}

void DrawTargetCaptureImpl::MaskSurface(const Pattern& aSource,
                                        SourceSurface* aMask, Point aOffset,
                                        const DrawOptions& aOptions) {
  aMask->GuaranteePersistance();
  AppendCommand(MaskSurfaceCommand)(aSource, aMask, aOffset, aOptions);
}

void DrawTargetCaptureImpl::CopySurface(SourceSurface* aSurface,
                                        const IntRect& aSourceRect,
                                        const IntPoint& aDestination) {
  aSurface->GuaranteePersistance();
  AppendCommand(CopySurfaceCommand)(aSurface, aSourceRect, aDestination);
}

void DrawTargetCaptureImpl::CopyRect(const IntRect& aSourceRect,
                                     const IntPoint& aDestination) {
  AppendCommand(CopyRectCommand)(aSourceRect, aDestination);
}

void DrawTargetCaptureImpl::FillRect(const Rect& aRect, const Pattern& aPattern,
                                     const DrawOptions& aOptions) {
  AppendCommand(FillRectCommand)(aRect, aPattern, aOptions);
}

void DrawTargetCaptureImpl::FillRoundedRect(const RoundedRect& aRect,
                                            const Pattern& aPattern,
                                            const DrawOptions& aOptions) {
  AppendCommand(FillRoundedRectCommand)(aRect, aPattern, aOptions);
}

void DrawTargetCaptureImpl::StrokeRect(const Rect& aRect,
                                       const Pattern& aPattern,
                                       const StrokeOptions& aStrokeOptions,
                                       const DrawOptions& aOptions) {
  AppendCommand(StrokeRectCommand)(aRect, aPattern, aStrokeOptions, aOptions);
}

void DrawTargetCaptureImpl::StrokeLine(const Point& aStart, const Point& aEnd,
                                       const Pattern& aPattern,
                                       const StrokeOptions& aStrokeOptions,
                                       const DrawOptions& aOptions) {
  AppendCommand(StrokeLineCommand)(aStart, aEnd, aPattern, aStrokeOptions,
                                   aOptions);
}

void DrawTargetCaptureImpl::Stroke(const Path* aPath, const Pattern& aPattern,
                                   const StrokeOptions& aStrokeOptions,
                                   const DrawOptions& aOptions) {
  AppendCommand(StrokeCommand)(aPath, aPattern, aStrokeOptions, aOptions);
}

void DrawTargetCaptureImpl::Fill(const Path* aPath, const Pattern& aPattern,
                                 const DrawOptions& aOptions) {
  AppendCommand(FillCommand)(aPath, aPattern, aOptions);
}

void DrawTargetCaptureImpl::FillGlyphs(ScaledFont* aFont,
                                       const GlyphBuffer& aBuffer,
                                       const Pattern& aPattern,
                                       const DrawOptions& aOptions) {
  AppendCommand(FillGlyphsCommand)(aFont, aBuffer, aPattern, aOptions);
}

void DrawTargetCaptureImpl::StrokeGlyphs(ScaledFont* aFont,
                                         const GlyphBuffer& aBuffer,
                                         const Pattern& aPattern,
                                         const StrokeOptions& aStrokeOptions,
                                         const DrawOptions& aOptions) {
  AppendCommand(StrokeGlyphsCommand)(aFont, aBuffer, aPattern, aStrokeOptions,
                                     aOptions);
}

void DrawTargetCaptureImpl::Mask(const Pattern& aSource, const Pattern& aMask,
                                 const DrawOptions& aOptions) {
  AppendCommand(MaskCommand)(aSource, aMask, aOptions);
}

void DrawTargetCaptureImpl::PushClip(const Path* aPath) {
  // We need Pushes and Pops to match so instead of trying
  // to compute the bounds of the path just repush the current
  // bounds.
  mCurrentClipBounds.push(mCurrentClipBounds.top());

  AppendCommand(PushClipCommand)(aPath);
}

void DrawTargetCaptureImpl::PushClipRect(const Rect& aRect) {
  IntRect deviceRect = RoundedOut(mTransform.TransformBounds(aRect));
  mCurrentClipBounds.push(mCurrentClipBounds.top().Intersect(deviceRect));

  AppendCommand(PushClipRectCommand)(aRect);
}

void DrawTargetCaptureImpl::PushLayer(bool aOpaque, Float aOpacity,
                                      SourceSurface* aMask,
                                      const Matrix& aMaskTransform,
                                      const IntRect& aBounds,
                                      bool aCopyBackground) {
  // Have to update mPermitSubpixelAA for this DT
  // because some code paths query the current setting
  // to determine subpixel AA eligibility.
  PushedLayer layer(GetPermitSubpixelAA());
  mPushedLayers.push_back(layer);
  DrawTarget::SetPermitSubpixelAA(aOpaque);

  if (aMask) {
    aMask->GuaranteePersistance();
  }

  AppendCommand(PushLayerCommand)(aOpaque, aOpacity, aMask, aMaskTransform,
                                  aBounds, aCopyBackground);
}

void DrawTargetCaptureImpl::PopLayer() {
  MOZ_ASSERT(mPushedLayers.size());
  DrawTarget::SetPermitSubpixelAA(mPushedLayers.back().mOldPermitSubpixelAA);
  mPushedLayers.pop_back();

  AppendCommand(PopLayerCommand)();
}

void DrawTargetCaptureImpl::PopClip() {
  mCurrentClipBounds.pop();
  AppendCommand(PopClipCommand)();
}

void DrawTargetCaptureImpl::SetTransform(const Matrix& aTransform) {
  // Save memory by eliminating state changes with no effect
  if (mTransform.ExactlyEquals(aTransform)) {
    return;
  }

  ReuseOrAppendCommand(SetTransformCommand)(aTransform);

  // Have to update the transform for this DT
  // because some code paths query the current transform
  // to render specific things.
  DrawTarget::SetTransform(aTransform);
}

void DrawTargetCaptureImpl::Blur(const AlphaBoxBlur& aBlur) {
  // gfxAlphaBoxBlur should not use this if it takes the accelerated path.
  MOZ_ASSERT(GetBackendType() == BackendType::SKIA);

  AppendCommand(BlurCommand)(aBlur);
}

void DrawTargetCaptureImpl::PadEdges(const IntRegion& aRegion) {
  AppendCommand(PadEdgesCommand)(aRegion);
}

void DrawTargetCaptureImpl::ReplayToDrawTarget(DrawTarget* aDT,
                                               const Matrix& aTransform) {
  for (CaptureCommandList::iterator iter(mCommands); !iter.Done();
       iter.Next()) {
    DrawingCommand* cmd = iter.Get();
    cmd->ExecuteOnDT(aDT, &aTransform);
  }
}

void DrawTargetCaptureImpl::MarkChanged() {
  if (!mSnapshot) {
    return;
  }

  if (mSnapshot->hasOneRef()) {
    mSnapshot = nullptr;
    return;
  }

  mSnapshot->DrawTargetWillChange();
  mSnapshot = nullptr;
}

already_AddRefed<DrawTarget> DrawTargetCaptureImpl::CreateSimilarDrawTarget(
    const IntSize& aSize, SurfaceFormat aFormat) const {
  return MakeAndAddRef<DrawTargetCaptureImpl>(GetBackendType(), aSize, aFormat);
}

RefPtr<DrawTarget> DrawTargetCaptureImpl::CreateClippedDrawTarget(
    const Rect& aBounds, SurfaceFormat aFormat) {
  IntRect& bounds = mCurrentClipBounds.top();
  auto dt = MakeRefPtr<DrawTargetCaptureImpl>(GetBackendType(), bounds.Size(),
                                              aFormat);
  RefPtr<DrawTarget> result =
      gfx::Factory::CreateOffsetDrawTarget(dt, bounds.TopLeft());
  result->SetTransform(mTransform);
  return result;
}

RefPtr<DrawTarget> DrawTargetCaptureImpl::CreateSimilarRasterTarget(
    const IntSize& aSize, SurfaceFormat aFormat) const {
  MOZ_ASSERT(!mRefDT->IsCaptureDT());
  return mRefDT->CreateSimilarDrawTarget(aSize, aFormat);
}

already_AddRefed<PathBuilder> DrawTargetCaptureImpl::CreatePathBuilder(
    FillRule aFillRule) const {
  if (mRefDT->GetBackendType() == BackendType::DIRECT2D1_1) {
    return MakeRefPtr<PathBuilderCapture>(aFillRule, mRefDT).forget();
  }

  return mRefDT->CreatePathBuilder(aFillRule);
}

already_AddRefed<FilterNode> DrawTargetCaptureImpl::CreateFilter(
    FilterType aType) {
  if (mRefDT->GetBackendType() == BackendType::DIRECT2D1_1) {
    return MakeRefPtr<FilterNodeCapture>(aType).forget();
  } else {
    return mRefDT->CreateFilter(aType);
  }
}

bool DrawTargetCaptureImpl::IsEmpty() const { return mCommands.IsEmpty(); }

void DrawTargetCaptureImpl::Dump() {
  TreeLog<> output;
  output << "DrawTargetCapture(" << (void*)(this) << ")\n";
  TreeAutoIndent<> indent(output);
  mCommands.Log(output);
  output << "\n";
}

}  // namespace gfx
}  // namespace mozilla
