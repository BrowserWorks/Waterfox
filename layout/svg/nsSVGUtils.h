/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef NS_SVGUTILS_H
#define NS_SVGUTILS_H

// include math.h to pick up definition of M_ maths defines e.g. M_PI
#include <math.h>

#include "DrawMode.h"
#include "gfx2DGlue.h"
#include "gfxMatrix.h"
#include "gfxPoint.h"
#include "gfxRect.h"
#include "mozilla/gfx/Rect.h"
#include "nsAlgorithm.h"
#include "nsChangeHint.h"
#include "nsColor.h"
#include "nsCOMPtr.h"
#include "nsID.h"
#include "nsIFrame.h"
#include "nsISupportsBase.h"
#include "nsMathUtils.h"
#include "nsStyleStruct.h"
#include <algorithm>

class gfxContext;
class nsFrameList;
class nsIContent;
class nsIDocument;
class nsIFrame;
class nsPresContext;
class nsStyleContext;
class nsStyleSVGPaint;
class nsSVGDisplayContainerFrame;
class nsSVGElement;
class nsSVGEnum;
class nsSVGLength2;
class nsSVGOuterSVGFrame;
class nsSVGPathGeometryFrame;
class nsTextFrame;

struct nsStyleSVG;
struct nsRect;

namespace mozilla {
class SVGContextPaint;
struct SVGContextPaintImpl;
namespace dom {
class Element;
class UserSpaceMetrics;
} // namespace dom
namespace gfx {
class DrawTarget;
class GeneralPattern;
} // namespace gfx
} // namespace mozilla

// maximum dimension of an offscreen surface - choose so that
// the surface size doesn't overflow a 32-bit signed int using
// 4 bytes per pixel; in line with Factory::CheckSurfaceSize
// In fact Macs can't even manage that
#define NS_SVG_OFFSCREEN_MAX_DIMENSION 4096

#define SVG_HIT_TEST_FILL        0x01
#define SVG_HIT_TEST_STROKE      0x02
#define SVG_HIT_TEST_CHECK_MRECT 0x04


bool NS_SVGPathCachingEnabled();
bool NS_SVGDisplayListHitTestingEnabled();
bool NS_SVGDisplayListPaintingEnabled();
bool NS_SVGNewGetBBoxEnabled();

/**
 * Sometimes we need to distinguish between an empty box and a box
 * that contains an element that has no size e.g. a point at the origin.
 */
class SVGBBox {
  typedef mozilla::gfx::Rect Rect;

public:
  SVGBBox() 
    : mIsEmpty(true) {}

  MOZ_IMPLICIT SVGBBox(const Rect& aRect)
    : mBBox(aRect), mIsEmpty(false) {}

  MOZ_IMPLICIT SVGBBox(const gfxRect& aRect)
    : mBBox(ToRect(aRect)), mIsEmpty(false) {}

  gfxRect ToThebesRect() const {
    return ThebesRect(mBBox);
  }

  bool IsEmpty() const {
    return mIsEmpty;
  }

  bool IsFinite() const {
    return mBBox.IsFinite();
  }

  void Scale(float aScale) {
    mBBox.Scale(aScale);
  }

  void UnionEdges(const SVGBBox& aSVGBBox) {
    if (aSVGBBox.mIsEmpty) {
      return;
    }
    mBBox = mIsEmpty ? aSVGBBox.mBBox : mBBox.UnionEdges(aSVGBBox.mBBox);
    mIsEmpty = false;
  }

  void Intersect(const SVGBBox& aSVGBBox) {
    if (!mIsEmpty && !aSVGBBox.mIsEmpty) {
      mBBox = mBBox.Intersect(aSVGBBox.mBBox);
      if (mBBox.IsEmpty()) {
        mIsEmpty = true;
        mBBox = Rect(0, 0, 0, 0);
      }
    } else {
      mIsEmpty = true;
      mBBox = Rect(0, 0, 0, 0);
    }
  }

private:
  Rect mBBox;
  bool mIsEmpty;
};

// GRRR WINDOWS HATE HATE HATE
#undef CLIP_MASK

class MOZ_RAII SVGAutoRenderState
{
  typedef mozilla::gfx::DrawTarget DrawTarget;

public:
  explicit SVGAutoRenderState(DrawTarget* aDrawTarget
                              MOZ_GUARD_OBJECT_NOTIFIER_PARAM);
  ~SVGAutoRenderState();

  void SetPaintingToWindow(bool aPaintingToWindow);

  static bool IsPaintingToWindow(DrawTarget* aDrawTarget);

private:
  DrawTarget* mDrawTarget;
  void* mOriginalRenderState;
  bool mPaintingToWindow;
  MOZ_DECL_USE_GUARD_OBJECT_NOTIFIER
};


#define NS_ISVGFILTERREFERENCE_IID \
{ 0x9744ee20, 0x1bcf, 0x4c62, \
 { 0x86, 0x7d, 0xd3, 0x7a, 0x91, 0x60, 0x3e, 0xef } }

class nsISVGFilterReference : public nsISupports
{
public:
  NS_DECLARE_STATIC_IID_ACCESSOR(NS_ISVGFILTERREFERENCE_IID)
  virtual void Invalidate() = 0;
};

NS_DEFINE_STATIC_IID_ACCESSOR(nsISVGFilterReference, NS_ISVGFILTERREFERENCE_IID)

/**
 * General functions used by all of SVG layout and possibly content code.
 * If a method is used by content and depends only on other content methods
 * it should go in SVGContentUtils instead.
 */
class nsSVGUtils
{
public:
  typedef mozilla::dom::Element Element;
  typedef mozilla::gfx::AntialiasMode AntialiasMode;
  typedef mozilla::gfx::DrawTarget DrawTarget;
  typedef mozilla::gfx::FillRule FillRule;
  typedef mozilla::gfx::GeneralPattern GeneralPattern;
  typedef mozilla::gfx::Size Size;
  typedef mozilla::SVGContextPaint SVGContextPaint;
  typedef mozilla::SVGContextPaintImpl SVGContextPaintImpl;
  typedef mozilla::image::DrawResult DrawResult;

  static void Init();

  NS_DECLARE_FRAME_PROPERTY_DELETABLE(ObjectBoundingBoxProperty, gfxRect)

  /**
   * Gets the nearest nsSVGInnerSVGFrame or nsSVGOuterSVGFrame frame. aFrame
   * must be an SVG frame. If aFrame is of type nsGkAtoms::svgOuterSVGFrame,
   * returns nullptr.
   */
  static nsSVGDisplayContainerFrame* GetNearestSVGViewport(nsIFrame *aFrame);

  /**
   * Returns the frame's post-filter visual overflow rect when passed the
   * frame's pre-filter visual overflow rect. If the frame is not currently
   * being filtered, this function simply returns aUnfilteredRect.
   */
  static nsRect GetPostFilterVisualOverflowRect(nsIFrame *aFrame,
                                                const nsRect &aUnfilteredRect);

  /**
   * Schedules an update of the frame's bounds (which will in turn invalidate
   * the new area that the frame should paint to).
   *
   * This does nothing when passed an NS_FRAME_IS_NONDISPLAY frame.
   * In future we may want to allow ReflowSVG to be called on such frames,
   * but that would be better implemented as a ForceReflowSVG function to
   * be called synchronously while painting them without marking or paying
   * attention to dirty bits like this function.
   *
   * This is very similar to PresShell::FrameNeedsReflow. The main reason that
   * we have this function instead of using FrameNeedsReflow is because we need
   * to be able to call it under nsSVGOuterSVGFrame::NotifyViewportChange when
   * that function is called by nsSVGOuterSVGFrame::Reflow. FrameNeedsReflow
   * is not suitable for calling during reflow though, and it asserts as much.
   * The reason that we want to be callable under NotifyViewportChange is
   * because we want to synchronously notify and dirty the nsSVGOuterSVGFrame's
   * children so that when nsSVGOuterSVGFrame::DidReflow is called its children
   * will be updated for the new size as appropriate. Otherwise we'd have to
   * post an event to the event loop to mark dirty flags and request an update.
   *
   * Another reason that we don't currently want to call
   * PresShell::FrameNeedsReflow is because passing eRestyle to it to get it to
   * mark descendants dirty would cause it to descend through
   * nsSVGForeignObjectFrame frames to mark their children dirty, but we want to
   * handle nsSVGForeignObjectFrame specially. It would also do unnecessary work
   * descending into NS_FRAME_IS_NONDISPLAY frames.
   */
  static void ScheduleReflowSVG(nsIFrame *aFrame);

  /**
   * Returns true if the frame or any of its children need ReflowSVG
   * to be called on them.
   */
  static bool NeedsReflowSVG(nsIFrame *aFrame);

  /*
   * Update the filter invalidation region for ancestor frames, if relevant.
   */
  static void NotifyAncestorsOfFilterRegionChange(nsIFrame *aFrame);

  /**
   * Percentage lengths in SVG are resolved against the width/height of the
   * nearest viewport (or its viewBox, if set). This helper returns the size
   * of this "context" for the given frame so that percentage values can be
   * resolved.
   */
  static Size GetContextSize(const nsIFrame* aFrame);

  /* Computes the input length in terms of object space coordinates.
     Input: rect - bounding box
            length - length to be converted
  */
  static float ObjectSpace(const gfxRect &aRect, const nsSVGLength2 *aLength);

  /* Computes the input length in terms of user space coordinates.
     Input: content - object to be used for determining user space
     Input: length - length to be converted
  */
  static float UserSpace(nsSVGElement *aSVGElement, const nsSVGLength2 *aLength);
  static float UserSpace(nsIFrame *aFrame, const nsSVGLength2 *aLength);
  static float UserSpace(const mozilla::dom::UserSpaceMetrics& aMetrics, const nsSVGLength2 *aLength);

  /* Find the outermost SVG frame of the passed frame */
  static nsSVGOuterSVGFrame *
  GetOuterSVGFrame(nsIFrame *aFrame);

  /**
   * Get the covered region for a frame. Return null if it's not an SVG frame.
   * @param aRect gets a rectangle in app units
   * @return the outer SVG frame which aRect is relative to
   */
  static nsIFrame*
  GetOuterSVGFrameAndCoveredRegion(nsIFrame* aFrame, nsRect* aRect);

  /* Paint SVG frame with SVG effects - aDirtyRect is the area being
   * redrawn, in device pixel coordinates relative to the outer svg */
  static DrawResult
  PaintFrameWithEffects(nsIFrame *aFrame,
                        gfxContext& aContext,
                        const gfxMatrix& aTransform,
                        const nsIntRect *aDirtyRect = nullptr);

  /* Hit testing - check if point hits the clipPath of indicated
   * frame.  Returns true if no clipPath set. */
  static bool
  HitTestClip(nsIFrame *aFrame, const gfxPoint &aPoint);
  
  /**
   * Hit testing - check if point hits any children of aFrame.  aPoint is
   * expected to be in the coordinate space established by aFrame for its
   * children (e.g. the space established by the 'viewBox' attribute on <svg>).
   */
  static nsIFrame *
  HitTestChildren(nsSVGDisplayContainerFrame *aFrame, const gfxPoint &aPoint);

  /*
   * Returns the CanvasTM of the indicated frame, whether it's a
   * child SVG frame, container SVG frame, or a regular frame.
   * For regular frames, we just return an identity matrix.
   */
  static gfxMatrix GetCanvasTM(nsIFrame* aFrame);

  /**
   * Returns the transform from aFrame's user space to canvas space. Only call
   * with SVG frames. This is like GetCanvasTM, except that it only includes
   * the transforms from aFrame's user space (i.e. the coordinate context
   * established by its 'transform' attribute, or else the coordinate context
   * that its _parent_ establishes for its children) to outer-<svg> device
   * space. Specifically, it does not include any other transforms introduced
   * by the frame such as x/y offsets and viewBox attributes.
   */
  static gfxMatrix GetUserToCanvasTM(nsIFrame* aFrame);

  /**
   * Notify the descendants of aFrame of a change to one of their ancestors
   * that might affect them.
   */
  static void
  NotifyChildrenOfSVGChange(nsIFrame *aFrame, uint32_t aFlags);

  /*
   * Get frame's covered region by walking the children and doing union.
   */
  static nsRect
  GetCoveredRegion(const nsFrameList &aFrames);

  static nsRect
  TransformFrameRectToOuterSVG(const nsRect& aRect,
                               const gfxMatrix& aMatrix,
                               nsPresContext* aPresContext);

  /*
   * Convert a surface size to an integer for use by thebes
   * possibly making it smaller in the process so the surface does not
   * use excessive memory.
   *
   * @param aSize the desired surface size
   * @param aResultOverflows true if the desired surface size is too big
   * @return the surface size to use
   */
  static mozilla::gfx::IntSize ConvertToSurfaceSize(const gfxSize& aSize,
                                                    bool *aResultOverflows);

  /*
   * Hit test a given rectangle/matrix.
   */
  static bool
  HitTestRect(const mozilla::gfx::Matrix &aMatrix,
              float aRX, float aRY, float aRWidth, float aRHeight,
              float aX, float aY);


  /**
   * Get the clip rect for the given frame, taking into account the CSS 'clip'
   * property. See:
   * http://www.w3.org/TR/SVG11/masking.html#OverflowAndClipProperties
   * The arguments for aX, aY, aWidth and aHeight should be the dimensions of
   * the viewport established by aFrame.
   */
  static gfxRect
  GetClipRectForFrame(nsIFrame *aFrame,
                      float aX, float aY, float aWidth, float aHeight);

  static void SetClipRect(gfxContext *aContext,
                          const gfxMatrix &aCTM,
                          const gfxRect &aRect);

  /* Using group opacity instead of fill or stroke opacity on a
   * geometry object seems to be a common authoring mistake.  If we're
   * not applying filters and not both stroking and filling, we can
   * generate the same result without going through the overhead of a
   * push/pop group. */
  static bool
  CanOptimizeOpacity(nsIFrame *aFrame);

  /**
   * Take the CTM to userspace for an element, and adjust it to a CTM to its
   * object bounding box space if aUnits is SVG_UNIT_TYPE_OBJECTBOUNDINGBOX.
   * (I.e. so that [0,0] is at the top left of its bbox, and [1,1] is at the
   * bottom right of its bbox).
   *
   * If the bbox is empty, this will return a singular matrix.
   */
  static gfxMatrix
  AdjustMatrixForUnits(const gfxMatrix &aMatrix,
                       nsSVGEnum *aUnits,
                       nsIFrame *aFrame);

  enum BBoxFlags {
    eBBoxIncludeFill           = 1 << 0,
    eBBoxIncludeFillGeometry   = 1 << 1,
    eBBoxIncludeStroke         = 1 << 2,
    eBBoxIncludeStrokeGeometry = 1 << 3,
    eBBoxIncludeMarkers        = 1 << 4,
    eBBoxIncludeClipped        = 1 << 5
  };
  /**
   * Get the SVG bbox (the SVG spec's simplified idea of bounds) of aFrame in
   * aFrame's userspace.
   */
  static gfxRect GetBBox(nsIFrame *aFrame,
                         // If the default arg changes, update the handling for
                         // ObjectBoundingBoxProperty() in the implementation.
                         uint32_t aFlags = eBBoxIncludeFillGeometry);

  /*
   * "User space" is the space that the frame's BBox (as calculated by
   * nsSVGUtils::GetBBox) is in. "Frame space" is the space that has its origin
   * at the top left of the union of the frame's border-box rects over all
   * continuations.
   * This function returns the offset one needs to add to something in frame
   * space in order to get its coordinates in user space.
   */
  static gfxPoint FrameSpaceInCSSPxToUserSpaceOffset(nsIFrame *aFrame);

  /**
   * Convert a userSpaceOnUse/objectBoundingBoxUnits rectangle that's specified
   * using four nsSVGLength2 values into a user unit rectangle in user space.
   *
   * @param aXYWH pointer to 4 consecutive nsSVGLength2 objects containing
   * the x, y, width and height values in that order
   * @param aBBox the bounding box of the object the rect is relative to;
   * may be null if aUnits is not SVG_UNIT_TYPE_OBJECTBOUNDINGBOX
   * @param aFrame the object in which to interpret user-space units;
   * may be null if aUnits is SVG_UNIT_TYPE_OBJECTBOUNDINGBOX
   */
  static gfxRect
  GetRelativeRect(uint16_t aUnits, const nsSVGLength2 *aXYWH,
                  const gfxRect& aBBox, nsIFrame *aFrame);

  static gfxRect
  GetRelativeRect(uint16_t aUnits, const nsSVGLength2 *aXYWH,
                  const gfxRect& aBBox,
                  const mozilla::dom::UserSpaceMetrics& aMetrics);

  /**
   * Find the first frame, starting with aStartFrame and going up its
   * parent chain, that is not an svgAFrame.
   */
  static nsIFrame* GetFirstNonAAncestorFrame(nsIFrame* aStartFrame);

  static bool OuterSVGIsCallingReflowSVG(nsIFrame *aFrame);
  static bool AnyOuterSVGIsCallingReflowSVG(nsIFrame *aFrame);

  /**
   * See https://svgwg.org/svg2-draft/painting.html#NonScalingStroke
   *
   * If the computed value of the 'vector-effect' property on aFrame is
   * 'non-scaling-stroke', then this function will set aUserToOuterSVG to the
   * transform from aFrame's SVG user space to the initial coordinate system
   * established by the viewport of aFrame's outer-<svg>'s (the coordinate
   * system in which the stroke is fixed).  If aUserToOuterSVG is set to a
   * non-identity matrix this function returns true, else it returns false.
   */
  static bool GetNonScalingStrokeTransform(nsIFrame *aFrame,
                                           gfxMatrix* aUserToOuterSVG);

  /**
   * Compute the maximum possible device space stroke extents of a path given
   * the path's device space path extents, its stroke style and its ctm.
   *
   * This is a workaround for the lack of suitable cairo API for getting the
   * tight device space stroke extents of a path. This basically gives us the
   * tightest extents that we can guarantee fully enclose the inked stroke
   * without doing the calculations for the actual tight extents. We exploit
   * the fact that cairo does have an API for getting the tight device space
   * fill/path extents.
   *
   * This should die once bug 478152 is fixed.
   */
  static gfxRect PathExtentsToMaxStrokeExtents(const gfxRect& aPathExtents,
                                               nsTextFrame* aFrame,
                                               const gfxMatrix& aMatrix);
  static gfxRect PathExtentsToMaxStrokeExtents(const gfxRect& aPathExtents,
                                               nsSVGPathGeometryFrame* aFrame,
                                               const gfxMatrix& aMatrix);

  /**
   * Convert a floating-point value to a 32-bit integer value, clamping to
   * the range of valid integers.
   */
  static int32_t ClampToInt(double aVal)
  {
    return NS_lround(std::max(double(INT32_MIN),
                            std::min(double(INT32_MAX), aVal)));
  }

  static nscolor GetFallbackOrPaintColor(nsStyleContext *aStyleContext,
                                         nsStyleSVGPaint nsStyleSVG::*aFillOrStroke);

  static void
  MakeFillPatternFor(nsIFrame *aFrame,
                     gfxContext* aContext,
                     GeneralPattern* aOutPattern,
                     SVGContextPaint* aContextPaint = nullptr);

  static void
  MakeStrokePatternFor(nsIFrame* aFrame,
                       gfxContext* aContext,
                       GeneralPattern* aOutPattern,
                       SVGContextPaint* aContextPaint = nullptr);

  static float GetOpacity(nsStyleSVGOpacitySource aOpacityType,
                          const float& aOpacity,
                          SVGContextPaint* aContextPaint);

  /*
   * @return false if there is no stroke
   */
  static bool HasStroke(nsIFrame* aFrame,
                        SVGContextPaint* aContextPaint = nullptr);

  static float GetStrokeWidth(nsIFrame* aFrame,
                              SVGContextPaint* aContextPaint = nullptr);

  /*
   * Set up a cairo context for a stroked path (including any dashing that
   * applies).
   */
  static void SetupCairoStrokeGeometry(nsIFrame* aFrame, gfxContext *aContext,
                                       SVGContextPaint* aContextPaint = nullptr);

  /**
   * This function returns a set of bit flags indicating which parts of the
   * element (fill, stroke, bounds) should intercept pointer events. It takes
   * into account the type of element and the value of the 'pointer-events'
   * property on the element.
   */
  static uint16_t GetGeometryHitTestFlags(nsIFrame* aFrame);

  static FillRule ToFillRule(mozilla::StyleFillRule aFillRule) {
    return aFillRule == mozilla::StyleFillRule::Evenodd ?
             FillRule::FILL_EVEN_ODD : FillRule::FILL_WINDING;
  }

  static AntialiasMode ToAntialiasMode(uint8_t aTextRendering) {
    return aTextRendering == NS_STYLE_TEXT_RENDERING_OPTIMIZESPEED ?
             AntialiasMode::NONE : AntialiasMode::SUBPIXEL;
  }

  /**
   * Render a SVG glyph.
   * @param aElement the SVG glyph element to render
   * @param aContext the thebes aContext to draw to
   * @return true if rendering succeeded
   */
  static bool PaintSVGGlyph(Element* aElement, gfxContext* aContext);
  /**
   * Get the extents of a SVG glyph.
   * @param aElement the SVG glyph element
   * @param aSVGToAppSpace the matrix mapping the SVG glyph space to the
   *   target context space
   * @param aResult the result (valid when true is returned)
   * @return true if calculating the extents succeeded
   */
  static bool GetSVGGlyphExtents(Element* aElement,
                                 const gfxMatrix& aSVGToAppSpace,
                                 gfxRect* aResult);

  /**
   * Returns the app unit canvas bounds of a userspace rect.
   *
   * @param aToCanvas Transform from userspace to canvas device space.
   */
  static nsRect
  ToCanvasBounds(const gfxRect &aUserspaceRect,
                 const gfxMatrix &aToCanvas,
                 const nsPresContext *presContext);

  struct MaskUsage {
    bool shouldGenerateMaskLayer;
    bool shouldGenerateClipMaskLayer;
    bool shouldApplyClipPath;
    bool shouldApplyBasicShape;
    float opacity;

    MaskUsage()
      : shouldGenerateMaskLayer(false), shouldGenerateClipMaskLayer(false),
        shouldApplyClipPath(false), shouldApplyBasicShape(false), opacity(0.0)
    { }
  };

  static void
  DetermineMaskUsage(nsIFrame* aFrame, bool aHandleOpacity, MaskUsage& aUsage);

  static float
  ComputeOpacity(nsIFrame* aFrame, bool aHandleOpacity);
};

#endif
