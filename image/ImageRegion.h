/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_image_ImageRegion_h
#define mozilla_image_ImageRegion_h

#include "gfxRect.h"
#include "mozilla/gfx/Types.h"

namespace mozilla {
namespace image {

/**
 * An axis-aligned rectangle in tiled image space, with an optional sampling
 * restriction rect. The drawing code ensures that if a sampling restriction
 * rect is present, any pixels sampled during the drawing process are found
 * within that rect.
 *
 * The sampling restriction rect exists primarily for callers which perform
 * pixel snapping. Other callers should generally use one of the Create()
 * overloads.
 */
class ImageRegion
{
  typedef mozilla::gfx::ExtendMode ExtendMode;

public:
  static ImageRegion Empty()
  {
    return ImageRegion(gfxRect(), ExtendMode::CLAMP);
  }

  static ImageRegion Create(const gfxRect& aRect,
                            ExtendMode aExtendMode = ExtendMode::CLAMP)
  {
    return ImageRegion(aRect, aExtendMode);
  }

  static ImageRegion Create(const gfxSize& aSize,
                            ExtendMode aExtendMode = ExtendMode::CLAMP)
  {
    return ImageRegion(gfxRect(0, 0, aSize.width, aSize.height), aExtendMode);
  }

  static ImageRegion Create(const nsIntSize& aSize,
                            ExtendMode aExtendMode = ExtendMode::CLAMP)
  {
    return ImageRegion(gfxRect(0, 0, aSize.width, aSize.height), aExtendMode);
  }

  static ImageRegion CreateWithSamplingRestriction(const gfxRect& aRect,
                                                   const gfxRect& aRestriction,
                                                   ExtendMode aExtendMode = ExtendMode::CLAMP)
  {
    return ImageRegion(aRect, aRestriction, aExtendMode);
  }

  bool IsRestricted() const { return mIsRestricted; }
  const gfxRect& Rect() const { return mRect; }

  const gfxRect& Restriction() const
  {
    MOZ_ASSERT(mIsRestricted);
    return mRestriction;
  }

  bool RestrictionContains(const gfxRect& aRect) const
  {
    if (!mIsRestricted) {
      return true;
    }
    return mRestriction.Contains(aRect);
  }

  ImageRegion Intersect(const gfxRect& aRect) const
  {
    if (mIsRestricted) {
      return CreateWithSamplingRestriction(aRect.Intersect(mRect),
                                           aRect.Intersect(mRestriction));
    }
    return Create(aRect.Intersect(mRect));
  }

  gfxRect IntersectAndRestrict(const gfxRect& aRect) const
  {
    gfxRect intersection = mRect.Intersect(aRect);
    if (mIsRestricted) {
      intersection = mRestriction.Intersect(intersection);
    }
    return intersection;
  }

  void MoveBy(gfxFloat dx, gfxFloat dy)
  {
    mRect.MoveBy(dx, dy);
    if (mIsRestricted) {
      mRestriction.MoveBy(dx, dy);
    }
  }

  void Scale(gfxFloat sx, gfxFloat sy)
  {
    mRect.Scale(sx, sy);
    if (mIsRestricted) {
      mRestriction.Scale(sx, sy);
    }
  }

  void TransformBy(const gfxMatrix& aMatrix)
  {
    mRect = aMatrix.TransformRect(mRect);
    if (mIsRestricted) {
      mRestriction = aMatrix.TransformRect(mRestriction);
    }
  }

  void TransformBoundsBy(const gfxMatrix& aMatrix)
  {
    mRect = aMatrix.TransformBounds(mRect);
    if (mIsRestricted) {
      mRestriction = aMatrix.TransformBounds(mRestriction);
    }
  }

  ImageRegion operator-(const gfxPoint& aPt) const
  {
    if (mIsRestricted) {
      return CreateWithSamplingRestriction(mRect - aPt, mRestriction - aPt);
    }
    return Create(mRect - aPt);
  }

  ImageRegion operator+(const gfxPoint& aPt) const
  {
    if (mIsRestricted) {
      return CreateWithSamplingRestriction(mRect + aPt, mRestriction + aPt);
    }
    return Create(mRect + aPt);
  }

  gfx::ExtendMode GetExtendMode() const
  {
    return mExtendMode;
  }

  /* ImageRegion() : mIsRestricted(false) { } */

private:
  explicit ImageRegion(const gfxRect& aRect, ExtendMode aExtendMode)
    : mRect(aRect)
    , mExtendMode(aExtendMode)
    , mIsRestricted(false)
  { }

  ImageRegion(const gfxRect& aRect, const gfxRect& aRestriction, ExtendMode aExtendMode)
    : mRect(aRect)
    , mRestriction(aRestriction)
    , mExtendMode(aExtendMode)
    , mIsRestricted(true)
  { }

  gfxRect mRect;
  gfxRect mRestriction;
  ExtendMode mExtendMode;
  bool    mIsRestricted;
};

} // namespace image
} // namespace mozilla

#endif // mozilla_image_ImageRegion_h
