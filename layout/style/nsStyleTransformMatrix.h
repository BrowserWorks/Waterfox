/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/*
 * A class representing three matrices that can be used for style transforms.
 */

#ifndef nsStyleTransformMatrix_h_
#define nsStyleTransformMatrix_h_

#include "mozilla/EnumeratedArray.h"
#include "nsCSSValue.h"

#include <limits>

class nsIFrame;
class nsStyleContext;
class nsPresContext;
struct gfxQuaternion;
struct nsRect;
namespace mozilla {
class RuleNodeCacheConditions;
} // namespace mozilla

/**
 * A helper to generate gfxMatrixes from css transform functions.
 */
namespace nsStyleTransformMatrix {
  // The operator passed to Servo backend.
  enum class MatrixTransformOperator: uint8_t {
    Interpolate,
    Accumulate
  };

  // Function for applying perspective() transform function. We treat
  // any value smaller than epsilon as perspective(infinity), which
  // follows CSSWG's resolution on perspective(0). See bug 1316236.
  inline void ApplyPerspectiveToMatrix(mozilla::gfx::Matrix4x4& aMatrix,
                                       float aDepth)
  {
    if (aDepth >= std::numeric_limits<float>::epsilon()) {
      aMatrix.Perspective(aDepth);
    }
  }

  /**
   * This class provides on-demand access to the 'reference box' for CSS
   * transforms (needed to resolve percentage values in 'transform',
   * 'transform-origin', etc.):
   *
   *    http://dev.w3.org/csswg/css-transforms/#reference-box
   *
   * This class helps us to avoid calculating the reference box unless and
   * until it is actually needed. This is important for performance when
   * transforms are applied to SVG elements since the reference box for SVG is
   * much more expensive to calculate (than for elements with a CSS layout box
   * where we can use the nsIFrame's cached mRect), much more common (than on
   * HTML), and yet very rarely have percentage values that require the
   * reference box to be resolved. We also don't want to cause SVG frames to
   * cache lots of ObjectBoundingBoxProperty objects that aren't needed.
   *
   * If UNIFIED_CONTINUATIONS (experimental, and currently broke) is defined,
   * we consider the reference box for non-SVG frames to be the smallest
   * rectangle containing a frame and all of its continuations.  For example,
   * if there is a <span> element with several continuations split over
   * several lines, this function will return the rectangle containing all of
   * those continuations. (This behavior is not currently in a spec.)
   */
  class MOZ_STACK_CLASS TransformReferenceBox final {
  public:
    typedef nscoord (TransformReferenceBox::*DimensionGetter)();

    explicit TransformReferenceBox()
      : mFrame(nullptr)
      , mIsCached(false)
    {}

    explicit TransformReferenceBox(const nsIFrame* aFrame)
      : mFrame(aFrame)
      , mIsCached(false)
    {
      MOZ_ASSERT(mFrame);
    }

    explicit TransformReferenceBox(const nsIFrame* aFrame,
                                   const nsSize& aFallbackDimensions)
    {
      mFrame = aFrame;
      mIsCached = false;
      if (!mFrame) {
        Init(aFallbackDimensions);
      }
    }

    void Init(const nsIFrame* aFrame) {
      MOZ_ASSERT(!mFrame && !mIsCached);
      mFrame = aFrame;
    }

    void Init(const nsSize& aDimensions);

    /**
     * The offset of the reference box from the nsIFrame's TopLeft(). This
     * is non-zero only in the case of SVG content. If we can successfully
     * implement UNIFIED_CONTINUATIONS at some point in the future then it
     * may also be non-zero for non-SVG content.
     */
    nscoord X() {
      EnsureDimensionsAreCached();
      return mX;
    }
    nscoord Y() {
      EnsureDimensionsAreCached();
      return mY;
    }

    /**
     * The size of the reference box.
     */
    nscoord Width() {
      EnsureDimensionsAreCached();
      return mWidth;
    }
    nscoord Height() {
      EnsureDimensionsAreCached();
      return mHeight;
    }

    bool IsEmpty() {
      return !mFrame;
    }

  private:
    // We don't really need to prevent copying, but since none of our consumers
    // currently need to copy, preventing copying may allow us to catch some
    // cases where we use pass-by-value instead of pass-by-reference.
    TransformReferenceBox(const TransformReferenceBox&) = delete;

    void EnsureDimensionsAreCached();

    const nsIFrame* mFrame;
    nscoord mX, mY, mWidth, mHeight;
    bool mIsCached;
  };

  /**
   * Return the transform function, as an nsCSSKeyword, for the given
   * nsCSSValue::Array from a transform list.
   */
  nsCSSKeyword TransformFunctionOf(const nsCSSValue::Array* aData);

  void SetIdentityMatrix(nsCSSValue::Array* aMatrix);

  float ProcessTranslatePart(const nsCSSValue& aValue,
                             nsStyleContext* aContext,
                             nsPresContext* aPresContext,
                             mozilla::RuleNodeCacheConditions& aConditions,
                             TransformReferenceBox* aRefBox,
                             TransformReferenceBox::DimensionGetter aDimensionGetter = nullptr);

  void
  ProcessInterpolateMatrix(mozilla::gfx::Matrix4x4& aMatrix,
                           const nsCSSValue::Array* aData,
                           nsStyleContext* aContext,
                           nsPresContext* aPresContext,
                           mozilla::RuleNodeCacheConditions& aConditions,
                           TransformReferenceBox& aBounds,
                           bool* aContains3dTransform);

  void
  ProcessAccumulateMatrix(mozilla::gfx::Matrix4x4& aMatrix,
                          const nsCSSValue::Array* aData,
                          nsStyleContext* aContext,
                          nsPresContext* aPresContext,
                          mozilla::RuleNodeCacheConditions& aConditions,
                          TransformReferenceBox& aBounds,
                          bool* aContains3dTransform);

  /**
   * Given an nsCSSValueList containing -moz-transform functions,
   * returns a matrix containing the value of those functions.
   *
   * @param aData The nsCSSValueList containing the transform functions
   * @param aContext The style context, used for unit conversion.
   * @param aPresContext The presentation context, used for unit conversion.
   * @param aConditions Set to uncachable (by calling SetUncacheable()) if the
   *   result cannot be cached in the rule tree, otherwise untouched.
   * @param aBounds The frame's bounding rectangle.
   * @param aAppUnitsPerMatrixUnit The number of app units per device pixel.
   * @param aContains3dTransform [out] Set to true if aList contains at least
   *   one 3d transform function (as defined in the CSS transforms
   *   specification), false otherwise.
   *
   * aContext and aPresContext may be null if all of the (non-percent)
   * length values in aData are already known to have been converted to
   * eCSSUnit_Pixel (as they are in an StyleAnimationValue)
   */
  mozilla::gfx::Matrix4x4 ReadTransforms(const nsCSSValueList* aList,
                                         nsStyleContext* aContext,
                                         nsPresContext* aPresContext,
                                         mozilla::RuleNodeCacheConditions& aConditions,
                                         TransformReferenceBox& aBounds,
                                         float aAppUnitsPerMatrixUnit,
                                         bool* aContains3dTransform);

  // Shear type for decomposition.
  enum class ShearType {
    XYSHEAR,
    XZSHEAR,
    YZSHEAR,
    Count
  };
  using ShearArray =
    mozilla::EnumeratedArray<ShearType, ShearType::Count, float>;

  /*
   * Implements the 2d transform matrix decomposition algorithm.
   */
  bool Decompose2DMatrix(const mozilla::gfx::Matrix& aMatrix,
                         mozilla::gfx::Point3D& aScale,
                         ShearArray& aShear,
                         gfxQuaternion& aRotate,
                         mozilla::gfx::Point3D& aTranslate);
  /*
   * Implements the 3d transform matrix decomposition algorithm.
   */
  bool Decompose3DMatrix(const mozilla::gfx::Matrix4x4& aMatrix,
                         mozilla::gfx::Point3D& aScale,
                         ShearArray& aShear,
                         gfxQuaternion& aRotate,
                         mozilla::gfx::Point3D& aTranslate,
                         mozilla::gfx::Point4D& aPerspective);

  mozilla::gfx::Matrix CSSValueArrayTo2DMatrix(nsCSSValue::Array* aArray);
  mozilla::gfx::Matrix4x4 CSSValueArrayTo3DMatrix(nsCSSValue::Array* aArray);

  gfxSize GetScaleValue(const nsCSSValueSharedList* aList,
                        const nsIFrame* aForFrame);
} // namespace nsStyleTransformMatrix

#endif
