/* -*- Mode: C++; tab-width: 20; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "RotatedBuffer.h"
#include <sys/types.h>                  // for int32_t
#include <algorithm>                    // for max
#include "BasicImplData.h"              // for BasicImplData
#include "BasicLayersImpl.h"            // for ToData
#include "BufferUnrotate.h"             // for BufferUnrotate
#include "GeckoProfiler.h"              // for PROFILER_LABEL
#include "Layers.h"                     // for PaintedLayer, Layer, etc
#include "gfxPlatform.h"                // for gfxPlatform
#include "gfxPrefs.h"                   // for gfxPrefs
#include "gfxUtils.h"                   // for gfxUtils
#include "mozilla/ArrayUtils.h"         // for ArrayLength
#include "mozilla/gfx/BasePoint.h"      // for BasePoint
#include "mozilla/gfx/BaseRect.h"       // for BaseRect
#include "mozilla/gfx/BaseSize.h"       // for BaseSize
#include "mozilla/gfx/Matrix.h"         // for Matrix
#include "mozilla/gfx/Point.h"          // for Point, IntPoint
#include "mozilla/gfx/Rect.h"           // for Rect, IntRect
#include "mozilla/gfx/Types.h"          // for ExtendMode::ExtendMode::CLAMP, etc
#include "mozilla/layers/ShadowLayers.h"  // for ShadowableLayer
#include "mozilla/layers/TextureClient.h"  // for TextureClient
#include "mozilla/gfx/Point.h"          // for IntSize
#include "gfx2DGlue.h"
#include "nsLayoutUtils.h"              // for invalidation debugging

namespace mozilla {

using namespace gfx;

namespace layers {

IntRect
RotatedBuffer::GetQuadrantRectangle(XSide aXSide, YSide aYSide) const
{
  // quadrantTranslation is the amount we translate the top-left
  // of the quadrant by to get coordinates relative to the layer
  IntPoint quadrantTranslation = -mBufferRotation;
  quadrantTranslation.x += aXSide == LEFT ? mBufferRect.width : 0;
  quadrantTranslation.y += aYSide == TOP ? mBufferRect.height : 0;
  return mBufferRect + quadrantTranslation;
}

Rect
RotatedBuffer::GetSourceRectangle(XSide aXSide, YSide aYSide) const
{
  Rect result;
  if (aXSide == LEFT) {
    result.x = 0;
    result.width = mBufferRotation.x;
  } else {
    result.x = mBufferRotation.x;
    result.width = mBufferRect.width - mBufferRotation.x;
  }
  if (aYSide == TOP) {
    result.y = 0;
    result.height = mBufferRotation.y;
  } else {
    result.y = mBufferRotation.y;
    result.height = mBufferRect.height - mBufferRotation.y;
  }
  return result;
}

/**
 * @param aXSide LEFT means we draw from the left side of the buffer (which
 * is drawn on the right side of mBufferRect). RIGHT means we draw from
 * the right side of the buffer (which is drawn on the left side of
 * mBufferRect).
 * @param aYSide TOP means we draw from the top side of the buffer (which
 * is drawn on the bottom side of mBufferRect). BOTTOM means we draw from
 * the bottom side of the buffer (which is drawn on the top side of
 * mBufferRect).
 */
void
RotatedBuffer::DrawBufferQuadrant(gfx::DrawTarget* aTarget,
                                  XSide aXSide, YSide aYSide,
                                  ContextSource aSource,
                                  float aOpacity,
                                  gfx::CompositionOp aOperator,
                                  gfx::SourceSurface* aMask,
                                  const gfx::Matrix* aMaskTransform) const
{
  // The rectangle that we're going to fill. Basically we're going to
  // render the buffer at mBufferRect + quadrantTranslation to get the
  // pixels in the right place, but we're only going to paint within
  // mBufferRect
  IntRect quadrantRect = GetQuadrantRectangle(aXSide, aYSide);
  IntRect fillRect;
  if (!fillRect.IntersectRect(mBufferRect, quadrantRect))
    return;

  gfx::Point quadrantTranslation(quadrantRect.x, quadrantRect.y);

  MOZ_ASSERT(aSource != BUFFER_BOTH);
  RefPtr<SourceSurface> snapshot = GetSourceSurface(aSource);

  if (!snapshot) {
    gfxCriticalError() << "Invalid snapshot in RotatedBuffer::DrawBufferQuadrant";
    return;
  }

  // direct2d is much slower when using OP_SOURCE so use OP_OVER and
  // (maybe) a clear instead. Normally we need to draw in a single operation
  // (to avoid flickering) but direct2d is ok since it defers rendering.
  // We should try abstract this logic in a helper when we have other use
  // cases.
  if ((aTarget->GetBackendType() == BackendType::DIRECT2D ||
       aTarget->GetBackendType() == BackendType::DIRECT2D1_1) &&
      aOperator == CompositionOp::OP_SOURCE) {
    aOperator = CompositionOp::OP_OVER;
    if (snapshot->GetFormat() == SurfaceFormat::B8G8R8A8) {
      aTarget->ClearRect(IntRectToRect(fillRect));
    }
  }

  // OP_SOURCE is unbounded in Azure, and we really don't want that behaviour here.
  // We also can't do a ClearRect+FillRect since we need the drawing to happen
  // as an atomic operation (to prevent flickering).
  // We also need this clip in the case where we have a mask, since the mask surface
  // might cover more than fillRect, but we only want to touch the pixels inside
  // fillRect.
  aTarget->PushClipRect(IntRectToRect(fillRect));

  if (aMask) {
    Matrix oldTransform = aTarget->GetTransform();

    // Transform from user -> buffer space.
    Matrix transform =
      Matrix::Translation(quadrantTranslation.x, quadrantTranslation.y);

    Matrix inverseMask = *aMaskTransform;
    inverseMask.Invert();

    transform *= oldTransform;
    transform *= inverseMask;

#ifdef MOZ_GFX_OPTIMIZE_MOBILE
    SurfacePattern source(snapshot, ExtendMode::CLAMP, transform, SamplingFilter::POINT);
#else
    SurfacePattern source(snapshot, ExtendMode::CLAMP, transform);
#endif

    aTarget->SetTransform(*aMaskTransform);
    aTarget->MaskSurface(source, aMask, Point(0, 0), DrawOptions(aOpacity, aOperator));
    aTarget->SetTransform(oldTransform);
  } else {
#ifdef MOZ_GFX_OPTIMIZE_MOBILE
    DrawSurfaceOptions options(SamplingFilter::POINT);
#else
    DrawSurfaceOptions options;
#endif
    aTarget->DrawSurface(snapshot, IntRectToRect(fillRect),
                         GetSourceRectangle(aXSide, aYSide),
                         options,
                         DrawOptions(aOpacity, aOperator));
  }

  aTarget->PopClip();
}

void
RotatedBuffer::DrawBufferWithRotation(gfx::DrawTarget *aTarget, ContextSource aSource,
                                      float aOpacity,
                                      gfx::CompositionOp aOperator,
                                      gfx::SourceSurface* aMask,
                                      const gfx::Matrix* aMaskTransform) const
{
  PROFILER_LABEL("RotatedBuffer", "DrawBufferWithRotation",
    js::ProfileEntry::Category::GRAPHICS);

  // See above, in Azure Repeat should always be a safe, even faster choice
  // though! Particularly on D2D Repeat should be a lot faster, need to look
  // into that. TODO[Bas]
  DrawBufferQuadrant(aTarget, LEFT, TOP, aSource, aOpacity, aOperator, aMask, aMaskTransform);
  DrawBufferQuadrant(aTarget, RIGHT, TOP, aSource, aOpacity, aOperator, aMask, aMaskTransform);
  DrawBufferQuadrant(aTarget, LEFT, BOTTOM, aSource, aOpacity, aOperator, aMask, aMaskTransform);
  DrawBufferQuadrant(aTarget, RIGHT, BOTTOM, aSource, aOpacity, aOperator,aMask, aMaskTransform);
}

already_AddRefed<SourceSurface>
SourceRotatedBuffer::GetSourceSurface(ContextSource aSource) const
{
  RefPtr<SourceSurface> surf;
  if (aSource == BUFFER_BLACK) {
    surf = mSource;
  } else {
    MOZ_ASSERT(aSource == BUFFER_WHITE);
    surf = mSourceOnWhite;
  }

  MOZ_ASSERT(surf);
  return surf.forget();
}

/* static */ bool
RotatedContentBuffer::IsClippingCheap(DrawTarget* aTarget, const nsIntRegion& aRegion)
{
  // Assume clipping is cheap if the draw target just has an integer
  // translation, and the visible region is simple.
  return !aTarget->GetTransform().HasNonIntegerTranslation() &&
         aRegion.GetNumRects() <= 1;
}

void
RotatedContentBuffer::DrawTo(PaintedLayer* aLayer,
                             DrawTarget* aTarget,
                             float aOpacity,
                             CompositionOp aOp,
                             SourceSurface* aMask,
                             const Matrix* aMaskTransform)
{
  if (!EnsureBuffer()) {
    return;
  }

  bool clipped = false;

  // If the entire buffer is valid, we can just draw the whole thing,
  // no need to clip. But we'll still clip if clipping is cheap ---
  // that might let us copy a smaller region of the buffer.
  // Also clip to the visible region if we're told to.
  if (!aLayer->GetValidRegion().Contains(BufferRect()) ||
      (ToData(aLayer)->GetClipToVisibleRegion() &&
       !aLayer->GetVisibleRegion().ToUnknownRegion().Contains(BufferRect())) ||
      IsClippingCheap(aTarget, aLayer->GetLocalVisibleRegion().ToUnknownRegion())) {
    // We don't want to draw invalid stuff, so we need to clip. Might as
    // well clip to the smallest area possible --- the visible region.
    // Bug 599189 if there is a non-integer-translation transform in aTarget,
    // we might sample pixels outside GetLocalVisibleRegion(), which is wrong
    // and may cause gray lines.
    gfxUtils::ClipToRegion(aTarget, aLayer->GetLocalVisibleRegion().ToUnknownRegion());
    clipped = true;
  }

  DrawBufferWithRotation(aTarget, BUFFER_BLACK, aOpacity, aOp, aMask, aMaskTransform);
  if (clipped) {
    aTarget->PopClip();
  }
}

DrawTarget*
RotatedContentBuffer::BorrowDrawTargetForQuadrantUpdate(const IntRect& aBounds,
                                                        ContextSource aSource,
                                                        DrawIterator* aIter)
{
  IntRect bounds = aBounds;
  if (aIter) {
    // If an iterator was provided, then BeginPaint must have been run with
    // PAINT_CAN_DRAW_ROTATED, and the draw region might cover multiple quadrants.
    // Iterate over each of them, and return an appropriate buffer each time we find
    // one that intersects the draw region. The iterator mCount value tracks which
    // quadrants we have considered across multiple calls to this function.
    aIter->mDrawRegion.SetEmpty();
    while (aIter->mCount < 4) {
      IntRect quadrant = GetQuadrantRectangle((aIter->mCount & 1) ? LEFT : RIGHT,
        (aIter->mCount & 2) ? TOP : BOTTOM);
      aIter->mDrawRegion.And(aBounds, quadrant);
      aIter->mCount++;
      if (!aIter->mDrawRegion.IsEmpty()) {
        break;
      }
    }
    if (aIter->mDrawRegion.IsEmpty()) {
      return nullptr;
    }
    bounds = aIter->mDrawRegion.GetBounds();
  }

  if (!EnsureBuffer()) {
    return nullptr;
  }

  MOZ_ASSERT(!mLoanedDrawTarget, "draw target has been borrowed and not returned");
  if (aSource == BUFFER_BOTH && HaveBufferOnWhite()) {
    if (!EnsureBufferOnWhite()) {
      return nullptr;
    }
    MOZ_ASSERT(mDTBuffer && mDTBuffer->IsValid() && mDTBufferOnWhite && mDTBufferOnWhite->IsValid());
    mLoanedDrawTarget = Factory::CreateDualDrawTarget(mDTBuffer, mDTBufferOnWhite);
  } else if (aSource == BUFFER_WHITE) {
    if (!EnsureBufferOnWhite()) {
      return nullptr;
    }
    mLoanedDrawTarget = mDTBufferOnWhite;
  } else {
    // BUFFER_BLACK, or BUFFER_BOTH with a single buffer.
    mLoanedDrawTarget = mDTBuffer;
  }

  // Figure out which quadrant to draw in
  int32_t xBoundary = mBufferRect.XMost() - mBufferRotation.x;
  int32_t yBoundary = mBufferRect.YMost() - mBufferRotation.y;
  XSide sideX = bounds.XMost() <= xBoundary ? RIGHT : LEFT;
  YSide sideY = bounds.YMost() <= yBoundary ? BOTTOM : TOP;
  IntRect quadrantRect = GetQuadrantRectangle(sideX, sideY);
  NS_ASSERTION(quadrantRect.Contains(bounds), "Messed up quadrants");

  mLoanedTransform = mLoanedDrawTarget->GetTransform();
  mLoanedDrawTarget->SetTransform(Matrix(mLoanedTransform).
                                    PreTranslate(-quadrantRect.x,
                                                 -quadrantRect.y));

  return mLoanedDrawTarget;
}

void
BorrowDrawTarget::ReturnDrawTarget(gfx::DrawTarget*& aReturned)
{
  MOZ_ASSERT(mLoanedDrawTarget);
  MOZ_ASSERT(aReturned == mLoanedDrawTarget);
  if (mLoanedDrawTarget) {
    mLoanedDrawTarget->SetTransform(mLoanedTransform);
    mLoanedDrawTarget = nullptr;
  }
  aReturned = nullptr;
}

gfxContentType
RotatedContentBuffer::BufferContentType()
{
  if (mBufferProvider || (mDTBuffer && mDTBuffer->IsValid())) {
    SurfaceFormat format = SurfaceFormat::B8G8R8A8;

    if (mBufferProvider) {
      format = mBufferProvider->GetFormat();
    } else if (mDTBuffer && mDTBuffer->IsValid()) {
      format = mDTBuffer->GetFormat();
    }

    return ContentForFormat(format);
  }
  return gfxContentType::SENTINEL;
}

bool
RotatedContentBuffer::BufferSizeOkFor(const IntSize& aSize)
{
  return (aSize == mBufferRect.Size() ||
          (SizedToVisibleBounds != mBufferSizePolicy &&
           aSize < mBufferRect.Size()));
}

bool
RotatedContentBuffer::EnsureBuffer()
{
  NS_ASSERTION(!mLoanedDrawTarget, "Loaned draw target must be returned");
  if (!mDTBuffer || !mDTBuffer->IsValid()) {
    if (mBufferProvider) {
      mDTBuffer = mBufferProvider->BorrowDrawTarget();
    }
  }

  NS_WARNING_ASSERTION(mDTBuffer && mDTBuffer->IsValid(), "no buffer");
  return !!mDTBuffer;
}

bool
RotatedContentBuffer::EnsureBufferOnWhite()
{
  NS_ASSERTION(!mLoanedDrawTarget, "Loaned draw target must be returned");
  if (!mDTBufferOnWhite) {
    if (mBufferProviderOnWhite) {
      mDTBufferOnWhite =
        mBufferProviderOnWhite->BorrowDrawTarget();
    }
  }

  NS_WARNING_ASSERTION(mDTBufferOnWhite, "no buffer");
  return !!mDTBufferOnWhite;
}

bool
RotatedContentBuffer::HaveBuffer() const
{
  return mBufferProvider || (mDTBuffer && mDTBuffer->IsValid());
}

bool
RotatedContentBuffer::HaveBufferOnWhite() const
{
  return mBufferProviderOnWhite || (mDTBufferOnWhite && mDTBufferOnWhite->IsValid());
}

static void
WrapRotationAxis(int32_t* aRotationPoint, int32_t aSize)
{
  if (*aRotationPoint < 0) {
    *aRotationPoint += aSize;
  } else if (*aRotationPoint >= aSize) {
    *aRotationPoint -= aSize;
  }
}

static IntRect
ComputeBufferRect(const IntRect& aRequestedRect)
{
  IntRect rect(aRequestedRect);
  // Set a minimum width to guarantee a minimum size of buffers we
  // allocate (and work around problems on some platforms with smaller
  // dimensions).  64 is the magic number needed to work around the
  // rendering glitch, and guarantees image rows can be SIMD'd for
  // even r5g6b5 surfaces pretty much everywhere.
  rect.width = std::max(aRequestedRect.width, 64);
  return rect;
}

void
RotatedContentBuffer::FlushBuffers()
{
  if (mDTBuffer) {
    mDTBuffer->Flush();
  }
  if (mDTBufferOnWhite) {
    mDTBufferOnWhite->Flush();
  }
}

RotatedContentBuffer::PaintState
RotatedContentBuffer::BeginPaint(PaintedLayer* aLayer,
                                 uint32_t aFlags)
{
  PaintState result;
  // We need to disable rotation if we're going to be resampled when
  // drawing, because we might sample across the rotation boundary.
  bool canHaveRotation = gfxPlatform::BufferRotationEnabled() &&
                         !(aFlags & (PAINT_WILL_RESAMPLE | PAINT_NO_ROTATION));

  nsIntRegion validRegion = aLayer->GetValidRegion();

  bool canUseOpaqueSurface = aLayer->CanUseOpaqueSurface();
  ContentType layerContentType =
    canUseOpaqueSurface ? gfxContentType::COLOR :
                          gfxContentType::COLOR_ALPHA;

  SurfaceMode mode;
  nsIntRegion neededRegion;
  IntRect destBufferRect;

  bool canReuseBuffer = HaveBuffer();

  while (true) {
    mode = aLayer->GetSurfaceMode();
    neededRegion = aLayer->GetVisibleRegion().ToUnknownRegion();
    canReuseBuffer &= BufferSizeOkFor(neededRegion.GetBounds().Size());
    result.mContentType = layerContentType;

    if (canReuseBuffer) {
      if (mBufferRect.Contains(neededRegion.GetBounds())) {
        // We don't need to adjust mBufferRect.
        destBufferRect = mBufferRect;
      } else if (neededRegion.GetBounds().Size() <= mBufferRect.Size()) {
        // The buffer's big enough but doesn't contain everything that's
        // going to be visible. We'll move it.
        destBufferRect = IntRect(neededRegion.GetBounds().TopLeft(), mBufferRect.Size());
      } else {
        destBufferRect = neededRegion.GetBounds();
      }
    } else {
      // We won't be reusing the buffer.  Compute a new rect.
      destBufferRect = ComputeBufferRect(neededRegion.GetBounds());
    }

    if (mode == SurfaceMode::SURFACE_COMPONENT_ALPHA) {
#if defined(MOZ_GFX_OPTIMIZE_MOBILE)
      mode = SurfaceMode::SURFACE_SINGLE_CHANNEL_ALPHA;
#else
      if (!aLayer->GetParent() ||
          !aLayer->GetParent()->SupportsComponentAlphaChildren() ||
          !aLayer->AsShadowableLayer() ||
          !aLayer->AsShadowableLayer()->HasShadow()) {
        mode = SurfaceMode::SURFACE_SINGLE_CHANNEL_ALPHA;
      } else {
        result.mContentType = gfxContentType::COLOR;
      }
#endif
    }

    if ((aFlags & PAINT_WILL_RESAMPLE) &&
        (!neededRegion.GetBounds().IsEqualInterior(destBufferRect) ||
         neededRegion.GetNumRects() > 1))
    {
      // The area we add to neededRegion might not be painted opaquely.
      if (mode == SurfaceMode::SURFACE_OPAQUE) {
        result.mContentType = gfxContentType::COLOR_ALPHA;
        mode = SurfaceMode::SURFACE_SINGLE_CHANNEL_ALPHA;
      }

      // We need to validate the entire buffer, to make sure that only valid
      // pixels are sampled.
      neededRegion = destBufferRect;
    }

    // If we have an existing buffer, but the content type has changed or we
    // have transitioned into/out of component alpha, then we need to recreate it.
    if (canReuseBuffer &&
        (result.mContentType != BufferContentType() ||
        (mode == SurfaceMode::SURFACE_COMPONENT_ALPHA) != HaveBufferOnWhite()))
    {
      // Restart the decision process; we won't re-enter since we guard on
      // being able to re-use the buffer.
      canReuseBuffer = false;
      continue;
    }

    break;
  }

  if (HaveBuffer() &&
      (result.mContentType != BufferContentType() ||
      (mode == SurfaceMode::SURFACE_COMPONENT_ALPHA) != HaveBufferOnWhite()))
  {
    // We're effectively clearing the valid region, so we need to draw
    // the entire needed region now.
    canReuseBuffer = false;
    result.mRegionToInvalidate = aLayer->GetValidRegion();
    validRegion.SetEmpty();
    Clear();

#if defined(MOZ_DUMP_PAINTING)
    if (nsLayoutUtils::InvalidationDebuggingIsEnabled()) {
      if (result.mContentType != BufferContentType()) {
        printf_stderr("Invalidating entire rotated buffer (layer %p): content type changed\n", aLayer);
      } else if ((mode == SurfaceMode::SURFACE_COMPONENT_ALPHA) != HaveBufferOnWhite()) {
        printf_stderr("Invalidating entire rotated buffer (layer %p): component alpha changed\n", aLayer);
      }
    }
#endif
  }

  NS_ASSERTION(destBufferRect.Contains(neededRegion.GetBounds()),
               "Destination rect doesn't contain what we need to paint");

  result.mRegionToDraw.Sub(neededRegion, validRegion);

  if (result.mRegionToDraw.IsEmpty())
    return result;

  if (HaveBuffer()) {
    // Do not modify result.mRegionToDraw or result.mContentType after this call.
    // Do not modify mBufferRect, mBufferRotation, or mDidSelfCopy,
    // or call CreateBuffer before this call.
    FinalizeFrame(result.mRegionToDraw);
  }

  IntRect drawBounds = result.mRegionToDraw.GetBounds();
  RefPtr<DrawTarget> destDTBuffer;
  RefPtr<DrawTarget> destDTBufferOnWhite;
  uint32_t bufferFlags = 0;
  if (mode == SurfaceMode::SURFACE_COMPONENT_ALPHA) {
    bufferFlags |= BUFFER_COMPONENT_ALPHA;
  }
  if (canReuseBuffer) {
    if (!EnsureBuffer()) {
      return result;
    }
    IntRect keepArea;
    if (keepArea.IntersectRect(destBufferRect, mBufferRect)) {
      // Set mBufferRotation so that the pixels currently in mDTBuffer
      // will still be rendered in the right place when mBufferRect
      // changes to destBufferRect.
      IntPoint newRotation = mBufferRotation +
        (destBufferRect.TopLeft() - mBufferRect.TopLeft());
      WrapRotationAxis(&newRotation.x, mBufferRect.width);
      WrapRotationAxis(&newRotation.y, mBufferRect.height);
      NS_ASSERTION(gfx::IntRect(gfx::IntPoint(0,0), mBufferRect.Size()).Contains(newRotation),
                   "newRotation out of bounds");
      int32_t xBoundary = destBufferRect.XMost() - newRotation.x;
      int32_t yBoundary = destBufferRect.YMost() - newRotation.y;
      bool drawWrapsBuffer = (drawBounds.x < xBoundary && xBoundary < drawBounds.XMost()) ||
                             (drawBounds.y < yBoundary && yBoundary < drawBounds.YMost());
      if ((drawWrapsBuffer && !(aFlags & PAINT_CAN_DRAW_ROTATED)) ||
          (newRotation != IntPoint(0,0) && !canHaveRotation)) {
        // The stuff we need to redraw will wrap around an edge of the
        // buffer (and the caller doesn't know how to support that), so
        // move the pixels we can keep into a position that lets us
        // redraw in just one quadrant.
        if (mBufferRotation == IntPoint(0,0)) {
          IntRect srcRect(IntPoint(0, 0), mBufferRect.Size());
          IntPoint dest = mBufferRect.TopLeft() - destBufferRect.TopLeft();
          MOZ_ASSERT(mDTBuffer && mDTBuffer->IsValid());
          mDTBuffer->CopyRect(srcRect, dest);
          if (mode == SurfaceMode::SURFACE_COMPONENT_ALPHA) {
            if (!EnsureBufferOnWhite()) {
              return result;
            }
            MOZ_ASSERT(mDTBufferOnWhite && mDTBufferOnWhite->IsValid());
            mDTBufferOnWhite->CopyRect(srcRect, dest);
          }
          result.mDidSelfCopy = true;
          mDidSelfCopy = true;
          // Don't set destBuffer; we special-case self-copies, and
          // just did the necessary work above.
          mBufferRect = destBufferRect;
        } else {
          // With azure and a data surface perform an buffer unrotate
          // (SelfCopy).
          unsigned char* data;
          IntSize size;
          int32_t stride;
          SurfaceFormat format;

          if (mDTBuffer->LockBits(&data, &size, &stride, &format)) {
            uint8_t bytesPerPixel = BytesPerPixel(format);
            BufferUnrotate(data,
                           size.width * bytesPerPixel,
                           size.height, stride,
                           newRotation.x * bytesPerPixel, newRotation.y);
            mDTBuffer->ReleaseBits(data);

            if (mode == SurfaceMode::SURFACE_COMPONENT_ALPHA) {
              if (!EnsureBufferOnWhite()) {
                return result;
              }
              MOZ_ASSERT(mDTBufferOnWhite && mDTBufferOnWhite->IsValid());
              mDTBufferOnWhite->LockBits(&data, &size, &stride, &format);
              uint8_t bytesPerPixel = BytesPerPixel(format);
              BufferUnrotate(data,
                             size.width * bytesPerPixel,
                             size.height, stride,
                             newRotation.x * bytesPerPixel, newRotation.y);
              mDTBufferOnWhite->ReleaseBits(data);
            }

            // Buffer unrotate moves all the pixels, note that
            // we self copied for SyncBackToFrontBuffer
            result.mDidSelfCopy = true;
            mDidSelfCopy = true;
            mBufferRect = destBufferRect;
            mBufferRotation = IntPoint(0, 0);
          }

          if (!result.mDidSelfCopy) {
            destBufferRect = ComputeBufferRect(neededRegion.GetBounds());
            CreateBuffer(result.mContentType, destBufferRect, bufferFlags,
                         &destDTBuffer, &destDTBufferOnWhite);
            if (!destDTBuffer ||
                (!destDTBufferOnWhite && (bufferFlags & BUFFER_COMPONENT_ALPHA))) {
              if (Factory::ReasonableSurfaceSize(IntSize(destBufferRect.width, destBufferRect.height))) {
                gfxCriticalNote << "Failed 1 buffer db=" << hexa(destDTBuffer.get()) << " dw=" << hexa(destDTBufferOnWhite.get()) << " for " << destBufferRect.x << ", " << destBufferRect.y << ", " << destBufferRect.width << ", " << destBufferRect.height;
              }
              return result;
            }
          }
        }
      } else {
        mBufferRect = destBufferRect;
        mBufferRotation = newRotation;
      }
    } else {
      // No pixels are going to be kept. The whole visible region
      // will be redrawn, so we don't need to copy anything, so we don't
      // set destBuffer.
      mBufferRect = destBufferRect;
      mBufferRotation = IntPoint(0,0);
    }
  } else {
    // The buffer's not big enough, so allocate a new one
    CreateBuffer(result.mContentType, destBufferRect, bufferFlags,
                 &destDTBuffer, &destDTBufferOnWhite);
    if (!destDTBuffer ||
        (!destDTBufferOnWhite && (bufferFlags & BUFFER_COMPONENT_ALPHA))) {
      if (Factory::ReasonableSurfaceSize(IntSize(destBufferRect.width, destBufferRect.height))) {
        gfxCriticalNote << "Failed 2 buffer db=" << hexa(destDTBuffer.get()) << " dw=" << hexa(destDTBufferOnWhite.get()) << " for " << destBufferRect.x << ", " << destBufferRect.y << ", " << destBufferRect.width << ", " << destBufferRect.height;
      }
      return result;
    }
  }

  NS_ASSERTION(!(aFlags & PAINT_WILL_RESAMPLE) || destBufferRect == neededRegion.GetBounds(),
               "If we're resampling, we need to validate the entire buffer");

  // If we have no buffered data already, then destBuffer will be a fresh buffer
  // and we do not need to clear it below.
  bool isClear = !HaveBuffer();

  if (destDTBuffer) {
    if (!isClear && (mode != SurfaceMode::SURFACE_COMPONENT_ALPHA || HaveBufferOnWhite())) {
      // Copy the bits
      IntPoint offset = -destBufferRect.TopLeft();
      Matrix mat = Matrix::Translation(offset.x, offset.y);
      destDTBuffer->SetTransform(mat);
      if (!EnsureBuffer()) {
        return result;
      }
      MOZ_ASSERT(mDTBuffer && mDTBuffer->IsValid(), "Have we got a Thebes buffer for some reason?");
      DrawBufferWithRotation(destDTBuffer, BUFFER_BLACK, 1.0, CompositionOp::OP_SOURCE);
      destDTBuffer->SetTransform(Matrix());

      if (mode == SurfaceMode::SURFACE_COMPONENT_ALPHA) {
        if (!destDTBufferOnWhite || !EnsureBufferOnWhite()) {
          return result;
        }
        MOZ_ASSERT(mDTBufferOnWhite && mDTBufferOnWhite->IsValid(), "Have we got a Thebes buffer for some reason?");
        destDTBufferOnWhite->SetTransform(mat);
        DrawBufferWithRotation(destDTBufferOnWhite, BUFFER_WHITE, 1.0, CompositionOp::OP_SOURCE);
        destDTBufferOnWhite->SetTransform(Matrix());
      }
    }

    mDTBuffer = destDTBuffer.forget();
    mDTBufferOnWhite = destDTBufferOnWhite.forget();
    mBufferRect = destBufferRect;
    mBufferRotation = IntPoint(0,0);
  }
  NS_ASSERTION(canHaveRotation || mBufferRotation == IntPoint(0,0),
               "Rotation disabled, but we have nonzero rotation?");

  nsIntRegion invalidate;
  invalidate.Sub(aLayer->GetValidRegion(), destBufferRect);
  result.mRegionToInvalidate.Or(result.mRegionToInvalidate, invalidate);
  result.mClip = DrawRegionClip::DRAW;
  result.mMode = mode;

  return result;
}

DrawTarget*
RotatedContentBuffer::BorrowDrawTargetForPainting(PaintState& aPaintState,
                                                  DrawIterator* aIter /* = nullptr */)
{
  if (aPaintState.mMode == SurfaceMode::SURFACE_NONE) {
    return nullptr;
  }

  DrawTarget* result = BorrowDrawTargetForQuadrantUpdate(aPaintState.mRegionToDraw.GetBounds(),
                                                         BUFFER_BOTH, aIter);
  if (!result) {
    return nullptr;
  }

  nsIntRegion* drawPtr = &aPaintState.mRegionToDraw;
  if (aIter) {
    // The iterators draw region currently only contains the bounds of the region,
    // this makes it the precise region.
    aIter->mDrawRegion.And(aIter->mDrawRegion, aPaintState.mRegionToDraw);
    drawPtr = &aIter->mDrawRegion;
  }
  if (result->GetBackendType() == BackendType::DIRECT2D ||
      result->GetBackendType() == BackendType::DIRECT2D1_1) {
    // Simplify the draw region to avoid hitting expensive drawing paths
    // for complex regions.
    drawPtr->SimplifyOutwardByArea(100 * 100);
  }

  if (aPaintState.mMode == SurfaceMode::SURFACE_COMPONENT_ALPHA) {
    if (!mDTBuffer || !mDTBuffer->IsValid() ||
        !mDTBufferOnWhite || !mDTBufferOnWhite->IsValid()) {
      // This can happen in release builds if allocating one of the two buffers
      // failed. This in turn can happen if unreasonably large textures are
      // requested.
      return nullptr;
    }
    for (auto iter = drawPtr->RectIter(); !iter.Done(); iter.Next()) {
      const IntRect& rect = iter.Get();
      mDTBuffer->FillRect(Rect(rect.x, rect.y, rect.width, rect.height),
                          ColorPattern(Color(0.0, 0.0, 0.0, 1.0)));
      mDTBufferOnWhite->FillRect(Rect(rect.x, rect.y, rect.width, rect.height),
                                 ColorPattern(Color(1.0, 1.0, 1.0, 1.0)));
    }
  } else if (aPaintState.mContentType == gfxContentType::COLOR_ALPHA && HaveBuffer()) {
    // HaveBuffer() => we have an existing buffer that we must clear
    for (auto iter = drawPtr->RectIter(); !iter.Done(); iter.Next()) {
      const IntRect& rect = iter.Get();
      result->ClearRect(Rect(rect.x, rect.y, rect.width, rect.height));
    }
  }

  return result;
}

already_AddRefed<SourceSurface>
RotatedContentBuffer::GetSourceSurface(ContextSource aSource) const
{
  if (!mDTBuffer || !mDTBuffer->IsValid()) {
    gfxCriticalNote << "Invalid buffer in RotatedContentBuffer::GetSourceSurface " << gfx::hexa(mDTBuffer);
    return nullptr;
  }

  if (aSource == BUFFER_BLACK) {
    return mDTBuffer->Snapshot();
  } else {
    if (!mDTBufferOnWhite || !mDTBufferOnWhite->IsValid()) {
    gfxCriticalNote << "Invalid buffer on white in RotatedContentBuffer::GetSourceSurface " << gfx::hexa(mDTBufferOnWhite);
      return nullptr;
    }
    MOZ_ASSERT(aSource == BUFFER_WHITE);
    return mDTBufferOnWhite->Snapshot();
  }
}

} // namespace layers
} // namespace mozilla

