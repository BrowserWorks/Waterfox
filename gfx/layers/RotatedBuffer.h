/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef ROTATEDBUFFER_H_
#define ROTATEDBUFFER_H_

#include "gfxTypes.h"
#include <stdint.h>                        // for uint32_t
#include "mozilla/Assertions.h"            // for MOZ_ASSERT, etc
#include "mozilla/RefPtr.h"                // for RefPtr, already_AddRefed
#include "mozilla/gfx/2D.h"                // for DrawTarget, etc
#include "mozilla/gfx/MatrixFwd.h"         // for Matrix
#include "mozilla/layers/TextureClient.h"  // for TextureClient
#include "mozilla/mozalloc.h"              // for operator delete
#include "nsCOMPtr.h"                      // for already_AddRefed
#include "nsISupportsImpl.h"               // for MOZ_COUNT_CTOR, etc
#include "nsRegion.h"                      // for nsIntRegion
#include "LayersTypes.h"

namespace mozilla {
namespace layers {

class PaintedLayer;
class ContentClient;

// Mixin class for classes which need logic for loaning out a draw target.
// See comments on BorrowDrawTargetForQuadrantUpdate.
class BorrowDrawTarget {
 public:
  void ReturnDrawTarget(gfx::DrawTarget*& aReturned);

 protected:
  // The draw target loaned by BorrowDrawTargetForQuadrantUpdate. It should not
  // be used, we just keep a reference to ensure it is kept alive and so we can
  // correctly restore state when it is returned.
  RefPtr<gfx::DrawTarget> mLoanedDrawTarget;
  gfx::Matrix mLoanedTransform;
};

/**
 * This is a cairo/Thebes surface, but with a literal twist. Scrolling
 * causes the layer's visible region to move. We want to keep
 * reusing the same surface if the region size hasn't changed, but we don't
 * want to keep moving the contents of the surface around in memory. So
 * we use a trick.
 * Consider just the vertical case, and suppose the buffer is H pixels
 * high and we're scrolling down by N pixels. Instead of copying the
 * buffer contents up by N pixels, we leave the buffer contents in place,
 * and paint content rows H to H+N-1 into rows 0 to N-1 of the buffer.
 * Then we can refresh the screen by painting rows N to H-1 of the buffer
 * at row 0 on the screen, and then painting rows 0 to N-1 of the buffer
 * at row H-N on the screen.
 * mBufferRotation.y would be N in this example.
 */
class RotatedBuffer : public BorrowDrawTarget {
 public:
  typedef gfxContentType ContentType;

  NS_INLINE_DECL_THREADSAFE_REFCOUNTING(RotatedBuffer)

  RotatedBuffer(const gfx::IntRect& aBufferRect,
                const gfx::IntPoint& aBufferRotation)
      : mCapture(nullptr),
        mBufferRect(aBufferRect),
        mBufferRotation(aBufferRotation),
        mDidSelfCopy(false) {}
  RotatedBuffer() : mCapture(nullptr), mDidSelfCopy(false) {}

  /**
   * Initializes the rotated buffer to begin capturing all drawing performed
   * on it, to be eventually replayed. Callers must call EndCapture, or
   * FlushCapture before the rotated buffer is destroyed.
   */
  void BeginCapture();

  /**
   * Finishes a capture and returns it. The capture must be replayed to the
   * buffer before it is presented or it will contain invalid contents.
   */
  RefPtr<gfx::DrawTargetCapture> EndCapture();

  /**
   * Returns whether the RotatedBuffer is currently capturing all drawing
   * performed on it, to be eventually replayed.
   */
  bool IsCapturing() const { return !!mCapture; }

  /**
   * Draws the contents of this rotated buffer into the specified draw target.
   * It is the callers repsonsibility to ensure aTarget is flushed after calling
   * this method.
   */
  void DrawBufferWithRotation(
      gfx::DrawTarget* aTarget, float aOpacity = 1.0,
      gfx::CompositionOp aOperator = gfx::CompositionOp::OP_OVER,
      gfx::SourceSurface* aMask = nullptr,
      const gfx::Matrix* aMaskTransform = nullptr) const;

  /**
   * Complete the drawing operation. The region to draw must have been
   * drawn before this is called. The contents of the buffer are drawn
   * to aTarget.
   */
  void DrawTo(PaintedLayer* aLayer, gfx::DrawTarget* aTarget, float aOpacity,
              gfx::CompositionOp aOp, gfx::SourceSurface* aMask,
              const gfx::Matrix* aMaskTransform);

  /**
   * Update the specified region of this rotated buffer with the contents
   * of a source rotated buffer.
   */
  void UpdateDestinationFrom(const RotatedBuffer& aSource,
                             const gfx::IntRect& aUpdateRect);

  /**
   * A draw iterator is used to keep track of which quadrant of a rotated
   * buffer and region of that quadrant is being updated.
   */
  struct DrawIterator {
    friend class RotatedBuffer;
    DrawIterator() : mCount(0) {}

    nsIntRegion mDrawRegion;

   private:
    uint32_t mCount;
  };

  /**
   * Get a draw target at the specified resolution for updating |aBounds|,
   * which must be contained within a single quadrant.
   *
   * The result should only be held temporarily by the caller (it will be kept
   * alive by this). Once used it should be returned using ReturnDrawTarget.
   * BorrowDrawTargetForQuadrantUpdate may not be called more than once without
   * first calling ReturnDrawTarget.
   *
   * ReturnDrawTarget will by default restore the transform on the draw target.
   * But it is the callers responsibility to restore the clip.
   * The caller should flush the draw target, if necessary.
   * If aSetTransform is false, the required transform will be set in
   * aOutTransform.
   */
  gfx::DrawTarget* BorrowDrawTargetForQuadrantUpdate(
      const gfx::IntRect& aBounds, DrawIterator* aIter);

  struct Parameters {
    Parameters(const gfx::IntRect& aBufferRect,
               const gfx::IntPoint& aBufferRotation)
        : mBufferRect(aBufferRect),
          mBufferRotation(aBufferRotation),
          mDidSelfCopy(false) {}

    bool IsRotated() const;
    bool RectWrapsBuffer(const gfx::IntRect& aRect) const;

    void SetUnrotated();

    gfx::IntRect mBufferRect;
    gfx::IntPoint mBufferRotation;
    bool mDidSelfCopy;
  };

  /**
   * Returns the new buffer parameters for rotating to a
   * destination buffer rect.
   */
  Parameters AdjustedParameters(const gfx::IntRect& aDestBufferRect) const;

  /**
   * Unrotates the pixels of the rotated buffer for the specified
   * new buffer parameters.
   */
  bool UnrotateBufferTo(const Parameters& aParameters);

  void SetParameters(const Parameters& aParameters);

  /**
   * |BufferRect()| is the rect of device pixels that this
   * RotatedBuffer covers.  That is what DrawBufferWithRotation()
   * will paint when it's called.
   */
  const gfx::IntRect& BufferRect() const { return mBufferRect; }
  const gfx::IntPoint& BufferRotation() const { return mBufferRotation; }

  /**
   * Overrides the current buffer rect with the specified rect.
   * Do not do this unless you know what you're doing.
   */
  void SetBufferRect(const gfx::IntRect& aBufferRect) {
    mBufferRect = aBufferRect;
  }

  /**
   * Overrides the current buffer rotation with the specified point.
   * Do not do this unless you know what you're doing.
   */
  void SetBufferRotation(const gfx::IntPoint& aBufferRotation) {
    mBufferRotation = aBufferRotation;
  }

  /**
   * Returns whether this buffer did a self copy when adjusting to
   * a new buffer rect. This is only used externally for syncing
   * rotated buffers.
   */
  bool DidSelfCopy() const { return mDidSelfCopy; }

  /**
   * Clears the self copy flag.
   */
  void ClearDidSelfCopy() { mDidSelfCopy = false; }

  /**
   * Gets the content type for this buffer.
   */
  ContentType GetContentType() const;

  virtual bool IsLocked() = 0;
  virtual bool Lock(OpenMode aMode) = 0;
  virtual void Unlock() = 0;

  virtual bool HaveBuffer() const = 0;
  virtual bool HaveBufferOnWhite() const = 0;

  virtual gfx::SurfaceFormat GetFormat() const = 0;

  virtual already_AddRefed<gfx::SourceSurface> GetBufferSource() const {
    return GetBufferTarget()->Snapshot();
  }
  virtual gfx::DrawTarget* GetBufferTarget() const = 0;

  virtual TextureClient* GetClient() const { return nullptr; }
  virtual TextureClient* GetClientOnWhite() const { return nullptr; }

 protected:
  virtual ~RotatedBuffer() { MOZ_ASSERT(!mCapture); }

  enum XSide { LEFT, RIGHT };
  enum YSide { TOP, BOTTOM };
  gfx::IntRect GetQuadrantRectangle(XSide aXSide, YSide aYSide) const;

  gfx::Rect GetSourceRectangle(XSide aXSide, YSide aYSide) const;

  gfx::DrawTarget* GetDrawTarget() const {
    if (mCapture) {
      return mCapture;
    }
    return GetBufferTarget();
  }

  /*
   * If aMask is non-null, then it is used as an alpha mask for rendering this
   * buffer. aMaskTransform must be non-null if aMask is non-null, and is used
   * to adjust the coordinate space of the mask.
   */
  void DrawBufferQuadrant(gfx::DrawTarget* aTarget, XSide aXSide, YSide aYSide,
                          float aOpacity, gfx::CompositionOp aOperator,
                          gfx::SourceSurface* aMask,
                          const gfx::Matrix* aMaskTransform) const;

  RefPtr<gfx::DrawTargetCapture> mCapture;

  /** The area of the PaintedLayer that is covered by the buffer as a whole */
  gfx::IntRect mBufferRect;
  /**
   * The x and y rotation of the buffer. Conceptually the buffer
   * has its origin translated to mBufferRect.TopLeft() - mBufferRotation,
   * is tiled to fill the plane, and the result is clipped to mBufferRect.
   * So the pixel at mBufferRotation within the buffer is what gets painted at
   * mBufferRect.TopLeft().
   * This is "rotation" in the sense of rotating items in a linear buffer,
   * where items falling off the end of the buffer are returned to the
   * buffer at the other end, not 2D rotation!
   */
  gfx::IntPoint mBufferRotation;
  /**
   * When this is true it means that all pixels have moved inside the buffer.
   * It's not possible to sync with another buffer without a full copy.
   */
  bool mDidSelfCopy;
};

/**
 * RemoteRotatedBuffer is a rotated buffer that is backed by texture
 * clients. Before you use this class you must successfully lock it with
 * an appropriate open mode, and then also unlock it when you're finished.
 * RemoteRotatedBuffer is used by ContentClientSingleBuffered and
 * ContentClientDoubleBuffered for the OMTC code path.
 */
class RemoteRotatedBuffer : public RotatedBuffer {
 public:
  RemoteRotatedBuffer(TextureClient* aClient, TextureClient* aClientOnWhite,
                      const gfx::IntRect& aBufferRect,
                      const gfx::IntPoint& aBufferRotation)
      : RotatedBuffer(aBufferRect, aBufferRotation),
        mClient(aClient),
        mClientOnWhite(aClientOnWhite) {}

  virtual bool IsLocked() override;
  virtual bool Lock(OpenMode aMode) override;
  virtual void Unlock() override;

  virtual bool HaveBuffer() const override { return !!mClient; }
  virtual bool HaveBufferOnWhite() const override { return !!mClientOnWhite; }

  virtual gfx::SurfaceFormat GetFormat() const override;

  virtual gfx::DrawTarget* GetBufferTarget() const override;

  virtual TextureClient* GetClient() const override { return mClient; }
  virtual TextureClient* GetClientOnWhite() const override {
    return mClientOnWhite;
  }

  void SyncWithObject(RefPtr<SyncObjectClient> aSyncObject);
  void Clear();

 private:
  RemoteRotatedBuffer(TextureClient* aClient, TextureClient* aClientOnWhite,
                      gfx::DrawTarget* aTarget, gfx::DrawTarget* aTargetOnWhite,
                      gfx::DrawTarget* aTargetDual,
                      const gfx::IntRect& aBufferRect,
                      const gfx::IntPoint& aBufferRotation)
      : RotatedBuffer(aBufferRect, aBufferRotation),
        mClient(aClient),
        mClientOnWhite(aClientOnWhite),
        mTarget(aTarget),
        mTargetOnWhite(aTargetOnWhite),
        mTargetDual(aTargetDual) {}

  RefPtr<TextureClient> mClient;
  RefPtr<TextureClient> mClientOnWhite;

  RefPtr<gfx::DrawTarget> mTarget;
  RefPtr<gfx::DrawTarget> mTargetOnWhite;
  RefPtr<gfx::DrawTarget> mTargetDual;
};

/**
 * DrawTargetRotatedBuffer is a rotated buffer that is backed by draw targets,
 * and is used by ContentClientBasic for the on-mtc code path.
 */
class DrawTargetRotatedBuffer : public RotatedBuffer {
 public:
  DrawTargetRotatedBuffer(gfx::DrawTarget* aTarget,
                          gfx::DrawTarget* aTargetOnWhite,
                          const gfx::IntRect& aBufferRect,
                          const gfx::IntPoint& aBufferRotation)
      : RotatedBuffer(aBufferRect, aBufferRotation),
        mTarget(aTarget),
        mTargetOnWhite(aTargetOnWhite) {
    if (mTargetOnWhite) {
      mTargetDual = gfx::Factory::CreateDualDrawTarget(mTarget, mTargetOnWhite);
    } else {
      mTargetDual = mTarget;
    }
  }

  virtual bool IsLocked() override { return false; }
  virtual bool Lock(OpenMode aMode) override { return true; }
  virtual void Unlock() override {}

  virtual bool HaveBuffer() const override { return !!mTargetDual; }
  virtual bool HaveBufferOnWhite() const override { return !!mTargetOnWhite; }

  virtual gfx::SurfaceFormat GetFormat() const override;

  virtual gfx::DrawTarget* GetBufferTarget() const override;

 private:
  RefPtr<gfx::DrawTarget> mTarget;
  RefPtr<gfx::DrawTarget> mTargetOnWhite;
  RefPtr<gfx::DrawTarget> mTargetDual;
};

/**
 * SourceRotatedBuffer is a rotated buffer that is backed by source surfaces,
 * and may only be used to draw into other buffers or be read directly.
 */
class SourceRotatedBuffer : public RotatedBuffer {
 public:
  SourceRotatedBuffer(gfx::SourceSurface* aSource,
                      gfx::SourceSurface* aSourceOnWhite,
                      const gfx::IntRect& aBufferRect,
                      const gfx::IntPoint& aBufferRotation)
      : RotatedBuffer(aBufferRect, aBufferRotation),
        mSource(aSource),
        mSourceOnWhite(aSourceOnWhite) {
    mSourceDual =
        gfx::Factory::CreateDualSourceSurface(mSource, mSourceOnWhite);
  }

  virtual bool IsLocked() override { return false; }
  virtual bool Lock(OpenMode aMode) override { return false; }
  virtual void Unlock() override {}

  virtual already_AddRefed<gfx::SourceSurface> GetBufferSource() const override;

  virtual gfx::SurfaceFormat GetFormat() const override;

  virtual bool HaveBuffer() const override { return !!mSourceDual; }
  virtual bool HaveBufferOnWhite() const override { return !!mSourceOnWhite; }

  virtual gfx::DrawTarget* GetBufferTarget() const override { return nullptr; }

 private:
  RefPtr<gfx::SourceSurface> mSource;
  RefPtr<gfx::SourceSurface> mSourceOnWhite;
  RefPtr<gfx::SourceSurface> mSourceDual;
};

}  // namespace layers
}  // namespace mozilla

#endif /* ROTATEDBUFFER_H_ */
