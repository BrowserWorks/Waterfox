/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
// vim:cindent:ts=2:et:sw=2:
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsCSSRenderingBorders.h"

#include "gfxUtils.h"
#include "mozilla/ArrayUtils.h"
#include "mozilla/gfx/2D.h"
#include "mozilla/gfx/Helpers.h"
#include "mozilla/gfx/PathHelpers.h"
#include "BorderConsts.h"
#include "DashedCornerFinder.h"
#include "DottedCornerFinder.h"
#include "nsLayoutUtils.h"
#include "nsStyleConsts.h"
#include "nsContentUtils.h"
#include "nsCSSColorUtils.h"
#include "GeckoProfiler.h"
#include "nsExpirationTracker.h"
#include "RoundedRect.h"
#include "nsIScriptError.h"
#include "nsClassHashtable.h"
#include "nsPresContext.h"
#include "nsStyleStruct.h"
#include "mozilla/gfx/2D.h"
#include "gfx2DGlue.h"
#include "gfxGradientCache.h"
#include <algorithm>

using namespace mozilla;
using namespace mozilla::gfx;

#define MAX_COMPOSITE_BORDER_WIDTH LayoutDeviceIntCoord(10000)

/**
 * nsCSSRendering::PaintBorder
 * nsCSSRendering::PaintOutline
 *   -> DrawBorders
 *
 * DrawBorders
 *   -> Ability to use specialized approach?
 *      |- Draw using specialized function
 *   |- separate corners?
 *   |- dashed side mask
 *   |
 *   -> can border be drawn in 1 pass? (e.g., solid border same color all around)
 *      |- DrawBorderSides with all 4 sides
 *   -> more than 1 pass?
 *      |- for each corner
 *         |- clip to DoCornerClipSubPath
 *         |- for each side adjacent to corner
 *            |- clip to GetSideClipSubPath
 *            |- DrawBorderSides with one side
 *      |- for each side
 *         |- GetSideClipWithoutCornersRect
 *         |- DrawDashedOrDottedSide || DrawBorderSides with one side
 */

static void ComputeBorderCornerDimensions(const Float* aBorderWidths,
                                          const RectCornerRadii& aRadii,
                                          RectCornerRadii *aDimsResult);

// given a side index, get the previous and next side index
#define NEXT_SIDE(_s) mozilla::css::Side(((_s) + 1) & 3)
#define PREV_SIDE(_s) mozilla::css::Side(((_s) + 3) & 3)

// given a corner index, get the previous and next corner index
#define NEXT_CORNER(_s) mozilla::css::Corner(((_s) + 1) & 3)
#define PREV_CORNER(_s) mozilla::css::Corner(((_s) + 3) & 3)

// from the given base color and the background color, turn
// color into a color for the given border pattern style
static Color MakeBorderColor(nscolor aColor,
                             nscolor aBackgroundColor,
                             BorderColorStyle aBorderColorStyle);


// Given a line index (an index starting from the outside of the
// border going inwards) and an array of line styles, calculate the
// color that that stripe of the border should be rendered in.
static Color ComputeColorForLine(uint32_t aLineIndex,
                                   const BorderColorStyle* aBorderColorStyle,
                                   uint32_t aBorderColorStyleCount,
                                   nscolor aBorderColor,
                                   nscolor aBackgroundColor);

static Color ComputeCompositeColorForLine(uint32_t aLineIndex,
                                          const nsBorderColors* aBorderColors);

// little helper function to check if the array of 4 floats given are
// equal to the given value
static bool
CheckFourFloatsEqual(const Float *vals, Float k)
{
  return (vals[0] == k &&
          vals[1] == k &&
          vals[2] == k &&
          vals[3] == k);
}

static bool
IsZeroSize(const Size& sz) {
  return sz.width == 0.0 || sz.height == 0.0;
}

static bool
AllCornersZeroSize(const RectCornerRadii& corners) {
  return IsZeroSize(corners[NS_CORNER_TOP_LEFT]) &&
    IsZeroSize(corners[NS_CORNER_TOP_RIGHT]) &&
    IsZeroSize(corners[NS_CORNER_BOTTOM_RIGHT]) &&
    IsZeroSize(corners[NS_CORNER_BOTTOM_LEFT]);
}

static mozilla::css::Side
GetHorizontalSide(mozilla::css::Corner aCorner)
{
  return (aCorner == C_TL || aCorner == C_TR) ? NS_SIDE_TOP : NS_SIDE_BOTTOM;
}

static mozilla::css::Side
GetVerticalSide(mozilla::css::Corner aCorner)
{
  return (aCorner == C_TL || aCorner == C_BL) ? NS_SIDE_LEFT : NS_SIDE_RIGHT;
}

static mozilla::css::Corner
GetCWCorner(mozilla::css::Side aSide)
{
  return mozilla::css::Corner(NEXT_SIDE(aSide));
}

static mozilla::css::Corner
GetCCWCorner(mozilla::css::Side aSide)
{
  return mozilla::css::Corner(aSide);
}

static bool
IsSingleSide(int aSides)
{
  return aSides == SIDE_BIT_TOP || aSides == SIDE_BIT_RIGHT ||
         aSides == SIDE_BIT_BOTTOM || aSides == SIDE_BIT_LEFT;
}

static bool
IsHorizontalSide(mozilla::css::Side aSide)
{
  return aSide == NS_SIDE_TOP || aSide == NS_SIDE_BOTTOM;
}

typedef enum {
  // Normal solid square corner.  Will be rectangular, the size of the
  // adjacent sides.  If the corner has a border radius, the corner
  // will always be solid, since we don't do dotted/dashed etc.
  CORNER_NORMAL,

  // Paint the corner in whatever style is not dotted/dashed of the
  // adjacent corners.
  CORNER_SOLID,

  // Paint the corner as a dot, the size of the bigger of the adjacent
  // sides.
  CORNER_DOT
} CornerStyle;

nsCSSBorderRenderer::nsCSSBorderRenderer(nsPresContext* aPresContext,
                                         const nsIDocument* aDocument,
                                         DrawTarget* aDrawTarget,
                                         const Rect& aDirtyRect,
                                         Rect& aOuterRect,
                                         const uint8_t* aBorderStyles,
                                         const Float* aBorderWidths,
                                         RectCornerRadii& aBorderRadii,
                                         const nscolor* aBorderColors,
                                         nsBorderColors* const* aCompositeColors,
                                         nscolor aBackgroundColor)
  : mPresContext(aPresContext),
    mDocument(aDocument),
    mDrawTarget(aDrawTarget),
    mDirtyRect(aDirtyRect),
    mOuterRect(aOuterRect),
    mBorderStyles(aBorderStyles),
    mBorderWidths(aBorderWidths),
    mBorderRadii(aBorderRadii),
    mBorderColors(aBorderColors),
    mCompositeColors(aCompositeColors),
    mBackgroundColor(aBackgroundColor)
{
  if (!mCompositeColors) {
    static nsBorderColors * const noColors[4] = { nullptr };
    mCompositeColors = &noColors[0];
  }

  mInnerRect = mOuterRect;
  mInnerRect.Deflate(
      Margin(mBorderStyles[0] != NS_STYLE_BORDER_STYLE_NONE ? mBorderWidths[0] : 0,
             mBorderStyles[1] != NS_STYLE_BORDER_STYLE_NONE ? mBorderWidths[1] : 0,
             mBorderStyles[2] != NS_STYLE_BORDER_STYLE_NONE ? mBorderWidths[2] : 0,
             mBorderStyles[3] != NS_STYLE_BORDER_STYLE_NONE ? mBorderWidths[3] : 0));

  ComputeBorderCornerDimensions(mBorderWidths,
                                mBorderRadii, &mBorderCornerDimensions);

  mOneUnitBorder = CheckFourFloatsEqual(mBorderWidths, 1.0);
  mNoBorderRadius = AllCornersZeroSize(mBorderRadii);
  mAvoidStroke = false;
}

/* static */ void
nsCSSBorderRenderer::ComputeInnerRadii(const RectCornerRadii& aRadii,
                                       const Float* aBorderSizes,
                                       RectCornerRadii* aInnerRadiiRet)
{
  RectCornerRadii& iRadii = *aInnerRadiiRet;

  iRadii[C_TL].width = std::max(0.f, aRadii[C_TL].width - aBorderSizes[NS_SIDE_LEFT]);
  iRadii[C_TL].height = std::max(0.f, aRadii[C_TL].height - aBorderSizes[NS_SIDE_TOP]);

  iRadii[C_TR].width = std::max(0.f, aRadii[C_TR].width - aBorderSizes[NS_SIDE_RIGHT]);
  iRadii[C_TR].height = std::max(0.f, aRadii[C_TR].height - aBorderSizes[NS_SIDE_TOP]);

  iRadii[C_BR].width = std::max(0.f, aRadii[C_BR].width - aBorderSizes[NS_SIDE_RIGHT]);
  iRadii[C_BR].height = std::max(0.f, aRadii[C_BR].height - aBorderSizes[NS_SIDE_BOTTOM]);

  iRadii[C_BL].width = std::max(0.f, aRadii[C_BL].width - aBorderSizes[NS_SIDE_LEFT]);
  iRadii[C_BL].height = std::max(0.f, aRadii[C_BL].height - aBorderSizes[NS_SIDE_BOTTOM]);
}

/* static */ void
nsCSSBorderRenderer::ComputeOuterRadii(const RectCornerRadii& aRadii,
                                       const Float* aBorderSizes,
                                       RectCornerRadii* aOuterRadiiRet)
{
  RectCornerRadii& oRadii = *aOuterRadiiRet;

  // default all corners to sharp corners
  oRadii = RectCornerRadii(0.f);

  // round the edges that have radii > 0.0 to start with
  if (aRadii[C_TL].width > 0.f && aRadii[C_TL].height > 0.f) {
    oRadii[C_TL].width = std::max(0.f, aRadii[C_TL].width + aBorderSizes[NS_SIDE_LEFT]);
    oRadii[C_TL].height = std::max(0.f, aRadii[C_TL].height + aBorderSizes[NS_SIDE_TOP]);
  }

  if (aRadii[C_TR].width > 0.f && aRadii[C_TR].height > 0.f) {
    oRadii[C_TR].width = std::max(0.f, aRadii[C_TR].width + aBorderSizes[NS_SIDE_RIGHT]);
    oRadii[C_TR].height = std::max(0.f, aRadii[C_TR].height + aBorderSizes[NS_SIDE_TOP]);
  }

  if (aRadii[C_BR].width > 0.f && aRadii[C_BR].height > 0.f) {
    oRadii[C_BR].width = std::max(0.f, aRadii[C_BR].width + aBorderSizes[NS_SIDE_RIGHT]);
    oRadii[C_BR].height = std::max(0.f, aRadii[C_BR].height + aBorderSizes[NS_SIDE_BOTTOM]);
  }

  if (aRadii[C_BL].width > 0.f && aRadii[C_BL].height > 0.f) {
    oRadii[C_BL].width = std::max(0.f, aRadii[C_BL].width + aBorderSizes[NS_SIDE_LEFT]);
    oRadii[C_BL].height = std::max(0.f, aRadii[C_BL].height + aBorderSizes[NS_SIDE_BOTTOM]);
  }
}

/*static*/ void
ComputeBorderCornerDimensions(const Float* aBorderWidths,
                              const RectCornerRadii& aRadii,
                              RectCornerRadii* aDimsRet)
{
  Float leftWidth = aBorderWidths[NS_SIDE_LEFT];
  Float topWidth = aBorderWidths[NS_SIDE_TOP];
  Float rightWidth = aBorderWidths[NS_SIDE_RIGHT];
  Float bottomWidth = aBorderWidths[NS_SIDE_BOTTOM];

  if (AllCornersZeroSize(aRadii)) {
    // These will always be in pixel units from CSS
    (*aDimsRet)[C_TL] = Size(leftWidth, topWidth);
    (*aDimsRet)[C_TR] = Size(rightWidth, topWidth);
    (*aDimsRet)[C_BR] = Size(rightWidth, bottomWidth);
    (*aDimsRet)[C_BL] = Size(leftWidth, bottomWidth);
  } else {
    // Always round up to whole pixels for the corners; it's safe to
    // make the corners bigger than necessary, and this way we ensure
    // that we avoid seams.
    (*aDimsRet)[C_TL] = Size(ceil(std::max(leftWidth, aRadii[C_TL].width)),
                             ceil(std::max(topWidth, aRadii[C_TL].height)));
    (*aDimsRet)[C_TR] = Size(ceil(std::max(rightWidth, aRadii[C_TR].width)),
                             ceil(std::max(topWidth, aRadii[C_TR].height)));
    (*aDimsRet)[C_BR] = Size(ceil(std::max(rightWidth, aRadii[C_BR].width)),
                             ceil(std::max(bottomWidth, aRadii[C_BR].height)));
    (*aDimsRet)[C_BL] = Size(ceil(std::max(leftWidth, aRadii[C_BL].width)),
                             ceil(std::max(bottomWidth, aRadii[C_BL].height)));
  }
}

bool
nsCSSBorderRenderer::AreBorderSideFinalStylesSame(uint8_t aSides)
{
  NS_ASSERTION(aSides != 0 && (aSides & ~SIDE_BITS_ALL) == 0,
               "AreBorderSidesSame: invalid whichSides!");

  /* First check if the specified styles and colors are the same for all sides */
  int firstStyle = 0;
  NS_FOR_CSS_SIDES (i) {
    if (firstStyle == i) {
      if (((1 << i) & aSides) == 0)
        firstStyle++;
      continue;
    }

    if (((1 << i) & aSides) == 0) {
      continue;
    }

    if (mBorderStyles[firstStyle] != mBorderStyles[i] ||
        mBorderColors[firstStyle] != mBorderColors[i] ||
        !nsBorderColors::Equal(mCompositeColors[firstStyle],
                               mCompositeColors[i]))
      return false;
  }

  /* Then if it's one of the two-tone styles and we're not
   * just comparing the TL or BR sides */
  switch (mBorderStyles[firstStyle]) {
    case NS_STYLE_BORDER_STYLE_GROOVE:
    case NS_STYLE_BORDER_STYLE_RIDGE:
    case NS_STYLE_BORDER_STYLE_INSET:
    case NS_STYLE_BORDER_STYLE_OUTSET:
      return ((aSides & ~(SIDE_BIT_TOP | SIDE_BIT_LEFT)) == 0 ||
              (aSides & ~(SIDE_BIT_BOTTOM | SIDE_BIT_RIGHT)) == 0);
  }

  return true;
}

bool
nsCSSBorderRenderer::IsSolidCornerStyle(uint8_t aStyle, mozilla::css::Corner aCorner)
{
  switch (aStyle) {
    case NS_STYLE_BORDER_STYLE_SOLID:
      return true;

    case NS_STYLE_BORDER_STYLE_INSET:
    case NS_STYLE_BORDER_STYLE_OUTSET:
      return (aCorner == NS_CORNER_TOP_LEFT || aCorner == NS_CORNER_BOTTOM_RIGHT);

    case NS_STYLE_BORDER_STYLE_GROOVE:
    case NS_STYLE_BORDER_STYLE_RIDGE:
      return mOneUnitBorder && (aCorner == NS_CORNER_TOP_LEFT || aCorner == NS_CORNER_BOTTOM_RIGHT);

    case NS_STYLE_BORDER_STYLE_DOUBLE:
      return mOneUnitBorder;

    default:
      return false;
  }
}

bool
nsCSSBorderRenderer::IsCornerMergeable(mozilla::css::Corner aCorner)
{
  // Corner between dotted borders with same width and small radii is
  // merged into single dot.
  //
  //  widthH / 2.0
  // |<---------->|
  // |            |
  // |radius.width|
  // |<--->|      |
  // |     |      |
  // |    _+------+------------+-----
  // |  /      ###|###         |
  // |/    #######|#######     |
  // +   #########|#########   |
  // |  ##########|##########  |
  // | ###########|########### |
  // | ###########|########### |
  // |############|############|
  // +------------+############|
  // |#########################|
  // | ####################### |
  // | ####################### |
  // |  #####################  |
  // |   ###################   |
  // |     ###############     |
  // |         #######         |
  // +-------------------------+----
  // |                         |
  // |                         |
  mozilla::css::Side sideH(GetHorizontalSide(aCorner));
  mozilla::css::Side sideV(GetVerticalSide(aCorner));
  uint8_t styleH = mBorderStyles[sideH];
  uint8_t styleV = mBorderStyles[sideV];
  if (styleH != styleV || styleH != NS_STYLE_BORDER_STYLE_DOTTED) {
    return false;
  }

  Float widthH = mBorderWidths[sideH];
  Float widthV = mBorderWidths[sideV];
  if (widthH != widthV) {
    return false;
  }

  Size radius = mBorderRadii[aCorner];
  return IsZeroSize(radius) ||
         (radius.width < widthH / 2.0f && radius.height < widthH / 2.0f);
}

BorderColorStyle
nsCSSBorderRenderer::BorderColorStyleForSolidCorner(uint8_t aStyle, mozilla::css::Corner aCorner)
{
  // note that this function assumes that the corner is already solid,
  // as per the earlier function
  switch (aStyle) {
    case NS_STYLE_BORDER_STYLE_SOLID:
    case NS_STYLE_BORDER_STYLE_DOUBLE:
      return BorderColorStyleSolid;

    case NS_STYLE_BORDER_STYLE_INSET:
    case NS_STYLE_BORDER_STYLE_GROOVE:
      if (aCorner == NS_CORNER_TOP_LEFT)
        return BorderColorStyleDark;
      else if (aCorner == NS_CORNER_BOTTOM_RIGHT)
        return BorderColorStyleLight;
      break;

    case NS_STYLE_BORDER_STYLE_OUTSET:
    case NS_STYLE_BORDER_STYLE_RIDGE:
      if (aCorner == NS_CORNER_TOP_LEFT)
        return BorderColorStyleLight;
      else if (aCorner == NS_CORNER_BOTTOM_RIGHT)
        return BorderColorStyleDark;
      break;
  }

  return BorderColorStyleNone;
}

Rect
nsCSSBorderRenderer::GetCornerRect(mozilla::css::Corner aCorner)
{
  Point offset(0.f, 0.f);

  if (aCorner == C_TR || aCorner == C_BR)
    offset.x = mOuterRect.Width() - mBorderCornerDimensions[aCorner].width;
  if (aCorner == C_BR || aCorner == C_BL)
    offset.y = mOuterRect.Height() - mBorderCornerDimensions[aCorner].height;

  return Rect(mOuterRect.TopLeft() + offset,
              mBorderCornerDimensions[aCorner]);
}

Rect
nsCSSBorderRenderer::GetSideClipWithoutCornersRect(mozilla::css::Side aSide)
{
  Point offset(0.f, 0.f);

  // The offset from the outside rect to the start of this side's
  // box.  For the top and bottom sides, the height of the box
  // must be the border height; the x start must take into account
  // the corner size (which may be bigger than the right or left
  // side's width).  The same applies to the right and left sides.
  if (aSide == NS_SIDE_TOP) {
    offset.x = mBorderCornerDimensions[C_TL].width;
  } else if (aSide == NS_SIDE_RIGHT) {
    offset.x = mOuterRect.Width() - mBorderWidths[NS_SIDE_RIGHT];
    offset.y = mBorderCornerDimensions[C_TR].height;
  } else if (aSide == NS_SIDE_BOTTOM) {
    offset.x = mBorderCornerDimensions[C_BL].width;
    offset.y = mOuterRect.Height() - mBorderWidths[NS_SIDE_BOTTOM];
  } else if (aSide == NS_SIDE_LEFT) {
    offset.y = mBorderCornerDimensions[C_TL].height;
  }

  // The sum of the width & height of the corners adjacent to the
  // side.  This relies on the relationship between side indexing and
  // corner indexing; that is, 0 == SIDE_TOP and 0 == CORNER_TOP_LEFT,
  // with both proceeding clockwise.
  Size sideCornerSum = mBorderCornerDimensions[GetCCWCorner(aSide)]
                     + mBorderCornerDimensions[GetCWCorner(aSide)];
  Rect rect(mOuterRect.TopLeft() + offset,
            mOuterRect.Size() - sideCornerSum);

  if (IsHorizontalSide(aSide))
    rect.height = mBorderWidths[aSide];
  else
    rect.width = mBorderWidths[aSide];

  return rect;
}

// The side border type and the adjacent border types are
// examined and one of the different types of clipping (listed
// below) is selected.

typedef enum {
  // clip to the trapezoid formed by the corners of the
  // inner and outer rectangles for the given side
  //
  // +---------------
  // |\%%%%%%%%%%%%%%
  // |  \%%%%%%%%%%%%
  // |   \%%%%%%%%%%%
  // |     \%%%%%%%%%
  // |      +--------
  // |      |
  // |      |
  SIDE_CLIP_TRAPEZOID,

  // clip to the trapezoid formed by the outer rectangle
  // corners and the center of the region, making sure
  // that diagonal lines all go directly from the outside
  // corner to the inside corner, but that they then continue on
  // to the middle.
  //
  // This is needed for correctly clipping rounded borders,
  // which might extend past the SIDE_CLIP_TRAPEZOID trap.
  //
  // +-------__--+---
  //  \%%%%_-%%%%%%%%
  //    \+-%%%%%%%%%%
  //    / \%%%%%%%%%%
  //   /   \%%%%%%%%%
  //  |     +%%_-+---
  // |        +%%%%%%
  // |       / \%%%%%
  // +      +    \%%%
  // |      |      +-
  SIDE_CLIP_TRAPEZOID_FULL,

  // clip to the rectangle formed by the given side including corner.
  // This is used by the non-dotted side next to dotted side.
  //
  // +---------------
  // |%%%%%%%%%%%%%%%
  // |%%%%%%%%%%%%%%%
  // |%%%%%%%%%%%%%%%
  // |%%%%%%%%%%%%%%%
  // +------+--------
  // |      |
  // |      |
  SIDE_CLIP_RECTANGLE_CORNER,

  // clip to the rectangle formed by the given side excluding corner.
  // This is used by the dotted side next to non-dotted side.
  //
  // +------+--------
  // |      |%%%%%%%%
  // |      |%%%%%%%%
  // |      |%%%%%%%%
  // |      |%%%%%%%%
  // |      +--------
  // |      |
  // |      |
  SIDE_CLIP_RECTANGLE_NO_CORNER,
} SideClipType;

// Given three points, p0, p1, and midPoint, move p1 further in to the
// rectangle (of which aMidPoint is the center) so that it reaches the
// closer of the horizontal or vertical lines intersecting the midpoint,
// while maintaing the slope of the line.  If p0 and p1 are the same,
// just move p1 to midPoint (since there's no slope to maintain).
// FIXME: Extending only to the midpoint isn't actually sufficient for
// boxes with asymmetric radii.
static void
MaybeMoveToMidPoint(Point& aP0, Point& aP1, const Point& aMidPoint)
{
  Point ps = aP1 - aP0;

  if (ps.x == 0.0) {
    if (ps.y == 0.0) {
      aP1 = aMidPoint;
    } else {
      aP1.y = aMidPoint.y;
    }
  } else {
    if (ps.y == 0.0) {
      aP1.x = aMidPoint.x;
    } else {
      Float k = std::min((aMidPoint.x - aP0.x) / ps.x,
                         (aMidPoint.y - aP0.y) / ps.y);
      aP1 = aP0 + ps * k;
    }
  }
}

already_AddRefed<Path>
nsCSSBorderRenderer::GetSideClipSubPath(mozilla::css::Side aSide)
{
  // the clip proceeds clockwise from the top left corner;
  // so "start" in each case is the start of the region from that side.
  //
  // the final path will be formed like:
  // s0 ------- e0
  // |         /
  // s1 ----- e1
  //
  // that is, the second point will always be on the inside

  Point start[2];
  Point end[2];

#define IS_DOTTED(_s)  ((_s) == NS_STYLE_BORDER_STYLE_DOTTED)
  bool isDotted      = IS_DOTTED(mBorderStyles[aSide]);
  bool startIsDotted = IS_DOTTED(mBorderStyles[PREV_SIDE(aSide)]);
  bool endIsDotted   = IS_DOTTED(mBorderStyles[NEXT_SIDE(aSide)]);
#undef IS_DOTTED

  SideClipType startType = SIDE_CLIP_TRAPEZOID;
  SideClipType endType = SIDE_CLIP_TRAPEZOID;

  if (!IsZeroSize(mBorderRadii[GetCCWCorner(aSide)])) {
    startType = SIDE_CLIP_TRAPEZOID_FULL;
  } else if (startIsDotted && !isDotted) {
    startType = SIDE_CLIP_RECTANGLE_CORNER;
  } else if (!startIsDotted && isDotted) {
    startType = SIDE_CLIP_RECTANGLE_NO_CORNER;
  }

  if (!IsZeroSize(mBorderRadii[GetCWCorner(aSide)])) {
    endType = SIDE_CLIP_TRAPEZOID_FULL;
  } else if (endIsDotted && !isDotted) {
    endType = SIDE_CLIP_RECTANGLE_CORNER;
  } else if (!endIsDotted && isDotted) {
    endType = SIDE_CLIP_RECTANGLE_NO_CORNER;
  }

  Point midPoint = mInnerRect.Center();

  start[0] = mOuterRect.CCWCorner(aSide);
  start[1] = mInnerRect.CCWCorner(aSide);

  end[0] = mOuterRect.CWCorner(aSide);
  end[1] = mInnerRect.CWCorner(aSide);

  if (startType == SIDE_CLIP_TRAPEZOID_FULL) {
    MaybeMoveToMidPoint(start[0], start[1], midPoint);
  } else if (startType == SIDE_CLIP_RECTANGLE_CORNER) {
    if (IsHorizontalSide(aSide)) {
      start[1] = Point(mOuterRect.CCWCorner(aSide).x, mInnerRect.CCWCorner(aSide).y);
    } else {
      start[1] = Point(mInnerRect.CCWCorner(aSide).x, mOuterRect.CCWCorner(aSide).y);
    }
  } else if (startType == SIDE_CLIP_RECTANGLE_NO_CORNER) {
    if (IsHorizontalSide(aSide)) {
      start[0] = Point(mInnerRect.CCWCorner(aSide).x, mOuterRect.CCWCorner(aSide).y);
    } else {
      start[0] = Point(mOuterRect.CCWCorner(aSide).x, mInnerRect.CCWCorner(aSide).y);
    }
  }

  if (endType == SIDE_CLIP_TRAPEZOID_FULL) {
    MaybeMoveToMidPoint(end[0], end[1], midPoint);
  } else if (endType == SIDE_CLIP_RECTANGLE_CORNER) {
    if (IsHorizontalSide(aSide)) {
      end[1] = Point(mOuterRect.CWCorner(aSide).x, mInnerRect.CWCorner(aSide).y);
    } else {
      end[1] = Point(mInnerRect.CWCorner(aSide).x, mOuterRect.CWCorner(aSide).y);
    }
  } else if (endType == SIDE_CLIP_RECTANGLE_NO_CORNER) {
    if (IsHorizontalSide(aSide)) {
      end[0] = Point(mInnerRect.CWCorner(aSide).x, mOuterRect.CWCorner(aSide).y);
    } else {
      end[0] = Point(mOuterRect.CWCorner(aSide).x, mInnerRect.CWCorner(aSide).y);
    }
  }

  RefPtr<PathBuilder> builder = mDrawTarget->CreatePathBuilder();
  builder->MoveTo(start[0]);
  builder->LineTo(end[0]);
  builder->LineTo(end[1]);
  builder->LineTo(start[1]);
  builder->Close();
  return builder->Finish();
}

Point
nsCSSBorderRenderer::GetStraightBorderPoint(mozilla::css::Side aSide,
                                            mozilla::css::Corner aCorner,
                                            bool* aIsUnfilled,
                                            Float aDotOffset)

{
  // Calculate the end point of the side for dashed/dotted border, that is also
  // the end point of the corner curve.  The point is specified by aSide and
  // aCorner. (e.g. NS_SIDE_TOP and C_TL means the left end of border-top)
  //
  //
  //  aCorner        aSide
  //         +--------------------
  //         |
  //         |
  //         |         +----------
  //         |    the end point
  //         |
  //         |         +----------
  //         |         |
  //         |         |
  //         |         |
  //
  // The position of the point depends on the border-style, border-width, and
  // border-radius of the side, corner, and the adjacent side beyond the corner,
  // to make those sides (and corner) interact well.
  //
  // If the style of aSide is dotted and the dot at the point should be
  // unfilled, true is stored to *aIsUnfilled, otherwise false is stored.

  const Float signsList[4][2] = {
    { +1.0f, +1.0f },
    { -1.0f, +1.0f },
    { -1.0f, -1.0f },
    { +1.0f, -1.0f }
  };
  const Float (& signs)[2] = signsList[aCorner];

  *aIsUnfilled = false;

  Point P = mOuterRect.AtCorner(aCorner);
  uint8_t style = mBorderStyles[aSide];
  Float borderWidth = mBorderWidths[aSide];
  Size dim = mBorderCornerDimensions[aCorner];
  bool isHorizontal = IsHorizontalSide(aSide);
  //
  //    aCorner      aSide
  //           +--------------
  //           |
  //           |   +----------
  //           |   |
  // otherSide |   |
  //           |   |
  mozilla::css::Side otherSide = ((uint8_t)aSide == (uint8_t)aCorner)
                                 ? PREV_SIDE(aSide)
                                 : NEXT_SIDE(aSide);
  uint8_t otherStyle = mBorderStyles[otherSide];
  Float otherBorderWidth = mBorderWidths[otherSide];
  Size radius = mBorderRadii[aCorner];
  if (IsZeroSize(radius)) {
    radius.width = 0.0f;
    radius.height = 0.0f;
  }
  if (style == NS_STYLE_BORDER_STYLE_DOTTED) {
    // Offset the dot's location along the side toward the corner by a
    // multiple of its width.
    if (isHorizontal) {
      P.x -= signs[0] * aDotOffset * borderWidth;
    } else {
      P.y -= signs[1] * aDotOffset * borderWidth;
    }
  }
  if (style == NS_STYLE_BORDER_STYLE_DOTTED &&
      otherStyle == NS_STYLE_BORDER_STYLE_DOTTED) {
    if (borderWidth == otherBorderWidth) {
      if (radius.width < borderWidth / 2.0f &&
          radius.height < borderWidth / 2.0f) {
        // Two dots are merged into one and placed at the corner.
        //
        //  borderWidth / 2.0
        // |<---------->|
        // |            |
        // |radius.width|
        // |<--->|      |
        // |     |      |
        // |    _+------+------------+-----
        // |  /      ###|###         |
        // |/    #######|#######     |
        // +   #########|#########   |
        // |  ##########|##########  |
        // | ###########|########### |
        // | ###########|########### |
        // |############|############|
        // +------------+############|
        // |########### P ###########|
        // | ####################### |
        // | ####################### |
        // |  #####################  |
        // |   ###################   |
        // |     ###############     |
        // |         #######         |
        // +-------------------------+----
        // |                         |
        // |                         |
        P.x += signs[0] * borderWidth / 2.0f;
        P.y += signs[1] * borderWidth / 2.0f;
      } else {
        // Two dots are drawn separately.
        //
        //    borderWidth * 1.5
        //   |<------------>|
        //   |              |
        //   |radius.width  |
        //   |<----->|      |
        //   |       |      |
        //   |    _--+-+----+---
        //   |  _-     |  ##|##
        //   | /       | ###|###
        //   |/        |####|####
        //   |         |####+####
        //   |         |### P ###
        //   +         | ###|###
        //   |         |  ##|##
        //   +---------+----+---
        //   |  #####  |
        //   | ####### |
        //   |#########|
        //   +----+----+
        //   |#########|
        //   | ####### |
        //   |  #####  |
        //   |         |
        //
        // There should be enough gap between 2 dots even if radius.width is
        // small but larger than borderWidth / 2.0.  borderWidth * 1.5 is the
        // value that there's imaginally unfilled dot at the corner.  The
        // unfilled dot may overflow from the outer curve, but filled dots
        // doesn't, so this could be acceptable solution at least for now.
        // We may have to find better model/value.
        //
        //    imaginally unfilled dot at the corner
        //        |
        //        v    +----+---
        //      *****  |  ##|##
        //     ******* | ###|###
        //    *********|####|####
        //    *********|####+####
        //    *********|### P ###
        //     ******* | ###|###
        //      *****  |  ##|##
        //   +---------+----+---
        //   |  #####  |
        //   | ####### |
        //   |#########|
        //   +----+----+
        //   |#########|
        //   | ####### |
        //   |  #####  |
        //   |         |
        Float minimum = borderWidth * 1.5f;
        if (isHorizontal) {
          P.x += signs[0] * std::max(radius.width, minimum);
          P.y += signs[1] * borderWidth / 2.0f;
        } else {
          P.x += signs[0] * borderWidth / 2.0f;
          P.y += signs[1] * std::max(radius.height, minimum);
        }
      }

      return P;
    }

    if (borderWidth < otherBorderWidth) {
      // This side is smaller than other side, other side draws the corner.
      //
      //  otherBorderWidth + borderWidth / 2.0
      // |<---------->|
      // |            |
      // +---------+--+--------
      // |  #####  | *|*  ###
      // | ####### |**|**#####
      // |#########|**+**##+##
      // |####+####|* P *#####
      // |#########| ***  ###
      // | ####### +-----------
      // |  #####  |  ^
      // |         |  |
      // |         | first dot is not filled
      // |         |
      //
      //      radius.width
      // |<----------------->|
      // |                   |
      // |             ___---+-------------
      // |         __--     #|#       ###
      // |       _-        ##|##     #####
      // |     /           ##+##     ##+##
      // |   /             # P #     #####
      // |  |               #|#       ###
      // | |             __--+-------------
      // ||            _-    ^
      // ||           /      |
      // |           /      first dot is filled
      // |          |
      // |          |
      // |  #####  |
      // | ####### |
      // |#########|
      // +----+----+
      // |#########|
      // | ####### |
      // |  #####  |
      Float minimum = otherBorderWidth + borderWidth / 2.0f;
      if (isHorizontal) {
        if (radius.width < minimum) {
          *aIsUnfilled = true;
          P.x += signs[0] * minimum;
        } else {
          P.x += signs[0] * radius.width;
        }
        P.y += signs[1] * borderWidth / 2.0f;
      } else {
        P.x += signs[0] * borderWidth / 2.0f;
        if (radius.height < minimum) {
          *aIsUnfilled = true;
          P.y += signs[1] * minimum;
        } else {
          P.y += signs[1] * radius.height;
        }
      }

      return P;
    }

    // This side is larger than other side, this side draws the corner.
    //
    //  borderWidth / 2.0
    // |<-->|
    // |    |
    // +----+---------------------
    // |  ##|##           #####
    // | ###|###         #######
    // |####|####       #########
    // |####+####       ####+####
    // |### P ###       #########
    // | #######         #######
    // |  #####           #####
    // +-----+---------------------
    // | *** |
    // |*****|
    // |**+**| <-- first dot in other side is not filled
    // |*****|
    // | *** |
    // | ### |
    // |#####|
    // |##+##|
    // |#####|
    // | ### |
    // |     |
    if (isHorizontal) {
      P.x += signs[0] * std::max(radius.width, borderWidth / 2.0f);
      P.y += signs[1] * borderWidth / 2.0f;
    } else {
      P.x += signs[0] * borderWidth / 2.0f;
      P.y += signs[1] * std::max(radius.height, borderWidth / 2.0f);
    }
    return P;
  }

  if (style == NS_STYLE_BORDER_STYLE_DOTTED) {
    // If only this side is dotted, other side draws the corner.
    //
    //  otherBorderWidth + borderWidth / 2.0
    // |<------->|
    // |         |
    // +------+--+--------
    // |##  ##| *|*  ###
    // |##  ##|**|**#####
    // |##  ##|**+**##+##
    // |##  ##|* P *#####
    // |##  ##| ***  ###
    // |##  ##+-----------
    // |##  ##|  ^
    // |##  ##|  |
    // |##  ##| first dot is not filled
    // |##  ##|
    //
    //      radius.width
    // |<----------------->|
    // |                   |
    // |             ___---+-------------
    // |         __--     #|#       ###
    // |       _-        ##|##     #####
    // |     /           ##+##     ##+##
    // |   /             # P #     #####
    // |  |               #|#       ###
    // | |             __--+-------------
    // ||            _-    ^
    // ||          /       |
    // |         /        first dot is filled
    // |        |
    // |       |
    // |      |
    // |      |
    // |      |
    // +------+
    // |##  ##|
    // |##  ##|
    // |##  ##|
    Float minimum = otherBorderWidth + borderWidth / 2.0f;
    if (isHorizontal) {
      if (radius.width < minimum) {
        *aIsUnfilled = true;
        P.x += signs[0] * minimum;
      } else {
        P.x += signs[0] * radius.width;
      }
      P.y += signs[1] * borderWidth / 2.0f;
    } else {
      P.x += signs[0] * borderWidth / 2.0f;
      if (radius.height < minimum) {
        *aIsUnfilled = true;
        P.y += signs[1] * minimum;
      } else {
        P.y += signs[1] * radius.height;
      }
    }
    return P;
  }

  if (otherStyle == NS_STYLE_BORDER_STYLE_DOTTED && IsZeroSize(radius)) {
    // If other side is dotted and radius=0, draw side to the end of corner.
    //
    //   +-------------------------------
    //   |##########          ##########
    // P +##########          ##########
    //   |##########          ##########
    //   +-----+-------------------------
    //   | *** |
    //   |*****|
    //   |**+**| <-- first dot in other side is not filled
    //   |*****|
    //   | *** |
    //   | ### |
    //   |#####|
    //   |##+##|
    //   |#####|
    //   | ### |
    //   |     |
    if (isHorizontal) {
      P.y += signs[1] * borderWidth / 2.0f;
    } else {
      P.x += signs[0] * borderWidth / 2.0f;
    }
    return P;
  }

  // Other cases.
  //
  //  dim.width
  // |<----------------->|
  // |                   |
  // |             ___---+------------------
  // |         __--      |#######        ###
  // |       _-        P +#######        ###
  // |     /             |#######        ###
  // |   /          __---+------------------
  // |  |       __--
  // | |       /
  // ||      /
  // ||     |
  // |     |
  // |    |
  // |   |
  // |   |
  // +-+-+
  // |###|
  // |###|
  // |###|
  // |###|
  // |###|
  // |   |
  // |   |
  if (isHorizontal) {
    P.x += signs[0] * dim.width;
    P.y += signs[1] * borderWidth / 2.0f;
  } else {
    P.x += signs[0] * borderWidth / 2.0f;
    P.y += signs[1] * dim.height;
  }

  return P;
}

void
nsCSSBorderRenderer::GetOuterAndInnerBezier(Bezier* aOuterBezier,
                                            Bezier* aInnerBezier,
                                            mozilla::css::Corner aCorner)
{
  // Return bezier control points for outer and inner curve for given corner.
  //
  //               ___---+ outer curve
  //           __--      |
  //         _-          |
  //       /             |
  //     /               |
  //    |                |
  //   |             __--+ inner curve
  //  |            _-
  //  |           /
  // |           /
  // |          |
  // |          |
  // |         |
  // |         |
  // |         |
  // +---------+

  mozilla::css::Side sideH(GetHorizontalSide(aCorner));
  mozilla::css::Side sideV(GetVerticalSide(aCorner));

  Size outerCornerSize(ceil(mBorderRadii[aCorner].width),
                       ceil(mBorderRadii[aCorner].height));
  Size innerCornerSize(ceil(std::max(0.0f, mBorderRadii[aCorner].width -
                                     mBorderWidths[sideV])),
                       ceil(std::max(0.0f, mBorderRadii[aCorner].height -
                                     mBorderWidths[sideH])));

  GetBezierPointsForCorner(aOuterBezier, aCorner, mOuterRect.AtCorner(aCorner),
                           outerCornerSize);

  GetBezierPointsForCorner(aInnerBezier, aCorner, mInnerRect.AtCorner(aCorner),
                           innerCornerSize);
}

void
nsCSSBorderRenderer::FillSolidBorder(const Rect& aOuterRect,
                                     const Rect& aInnerRect,
                                     const RectCornerRadii& aBorderRadii,
                                     const Float* aBorderSizes,
                                     int aSides,
                                     const ColorPattern& aColor)
{
  // Note that this function is allowed to draw more than just the
  // requested sides.

  // If we have a border radius, do full rounded rectangles
  // and fill, regardless of what sides we're asked to draw.
  if (!AllCornersZeroSize(aBorderRadii)) {
    RefPtr<PathBuilder> builder = mDrawTarget->CreatePathBuilder();

    RectCornerRadii innerRadii;
    ComputeInnerRadii(aBorderRadii, aBorderSizes, &innerRadii);

    // do the outer border
    AppendRoundedRectToPath(builder, aOuterRect, aBorderRadii, true);

    // then do the inner border CCW
    AppendRoundedRectToPath(builder, aInnerRect, innerRadii, false);

    RefPtr<Path> path = builder->Finish();

    mDrawTarget->Fill(path, aColor);
    return;
  }

  // If we're asked to draw all sides of an equal-sized border,
  // stroking is fastest.  This is a fairly common path, but partial
  // sides is probably second in the list -- there are a bunch of
  // common border styles, such as inset and outset, that are
  // top-left/bottom-right split.
  if (aSides == SIDE_BITS_ALL &&
      CheckFourFloatsEqual(aBorderSizes, aBorderSizes[0]) &&
      !mAvoidStroke)
  {
    Float strokeWidth = aBorderSizes[0];
    Rect r(aOuterRect);
    r.Deflate(strokeWidth / 2.f);
    mDrawTarget->StrokeRect(r, aColor, StrokeOptions(strokeWidth));
    return;
  }

  // Otherwise, we have unequal sized borders or we're only
  // drawing some sides; create rectangles for each side
  // and fill them.

  Rect r[4];

  // compute base rects for each side
  if (aSides & SIDE_BIT_TOP) {
    r[NS_SIDE_TOP] =
        Rect(aOuterRect.X(), aOuterRect.Y(),
             aOuterRect.Width(), aBorderSizes[NS_SIDE_TOP]);
  }

  if (aSides & SIDE_BIT_BOTTOM) {
    r[NS_SIDE_BOTTOM] =
        Rect(aOuterRect.X(), aOuterRect.YMost() - aBorderSizes[NS_SIDE_BOTTOM],
             aOuterRect.Width(), aBorderSizes[NS_SIDE_BOTTOM]);
  }

  if (aSides & SIDE_BIT_LEFT) {
    r[NS_SIDE_LEFT] =
        Rect(aOuterRect.X(), aOuterRect.Y(),
             aBorderSizes[NS_SIDE_LEFT], aOuterRect.Height());
  }

  if (aSides & SIDE_BIT_RIGHT) {
    r[NS_SIDE_RIGHT] =
        Rect(aOuterRect.XMost() - aBorderSizes[NS_SIDE_RIGHT], aOuterRect.Y(),
             aBorderSizes[NS_SIDE_RIGHT], aOuterRect.Height());
  }

  // If two sides meet at a corner that we're rendering, then
  // make sure that we adjust one of the sides to avoid overlap.
  // This is especially important in the case of colors with
  // an alpha channel.

  if ((aSides & (SIDE_BIT_TOP | SIDE_BIT_LEFT)) == (SIDE_BIT_TOP | SIDE_BIT_LEFT)) {
    // adjust the left's top down a bit
    r[NS_SIDE_LEFT].y += aBorderSizes[NS_SIDE_TOP];
    r[NS_SIDE_LEFT].height -= aBorderSizes[NS_SIDE_TOP];
  }

  if ((aSides & (SIDE_BIT_TOP | SIDE_BIT_RIGHT)) == (SIDE_BIT_TOP | SIDE_BIT_RIGHT)) {
    // adjust the top's left a bit
    r[NS_SIDE_TOP].width -= aBorderSizes[NS_SIDE_RIGHT];
  }

  if ((aSides & (SIDE_BIT_BOTTOM | SIDE_BIT_RIGHT)) == (SIDE_BIT_BOTTOM | SIDE_BIT_RIGHT)) {
    // adjust the right's bottom a bit
    r[NS_SIDE_RIGHT].height -= aBorderSizes[NS_SIDE_BOTTOM];
  }

  if ((aSides & (SIDE_BIT_BOTTOM | SIDE_BIT_LEFT)) == (SIDE_BIT_BOTTOM | SIDE_BIT_LEFT)) {
    // adjust the bottom's left a bit
    r[NS_SIDE_BOTTOM].x += aBorderSizes[NS_SIDE_LEFT];
    r[NS_SIDE_BOTTOM].width -= aBorderSizes[NS_SIDE_LEFT];
  }

  // Filling these one by one is faster than filling them all at once.
  for (uint32_t i = 0; i < 4; i++) {
    if (aSides & (1 << i)) {
      MaybeSnapToDevicePixels(r[i], *mDrawTarget, true);
      mDrawTarget->FillRect(r[i], aColor);
    }
  }
}

Color
MakeBorderColor(nscolor aColor, nscolor aBackgroundColor,
                BorderColorStyle aBorderColorStyle)
{
  nscolor colors[2];
  int k = 0;

  switch (aBorderColorStyle) {
    case BorderColorStyleNone:
      return Color(0.f, 0.f, 0.f, 0.f); // transparent black

    case BorderColorStyleLight:
      k = 1;
      MOZ_FALLTHROUGH;
    case BorderColorStyleDark:
      NS_GetSpecial3DColors(colors, aBackgroundColor, aColor);
      return Color::FromABGR(colors[k]);

    case BorderColorStyleSolid:
    default:
      return Color::FromABGR(aColor);
  }
}

Color
ComputeColorForLine(uint32_t aLineIndex,
                    const BorderColorStyle* aBorderColorStyle,
                    uint32_t aBorderColorStyleCount,
                    nscolor aBorderColor,
                    nscolor aBackgroundColor)
{
  NS_ASSERTION(aLineIndex < aBorderColorStyleCount, "Invalid lineIndex given");

  return MakeBorderColor(aBorderColor, aBackgroundColor,
                         aBorderColorStyle[aLineIndex]);
}

Color
ComputeCompositeColorForLine(uint32_t aLineIndex,
                             const nsBorderColors* aBorderColors)
{
  while (aLineIndex-- && aBorderColors->mNext)
    aBorderColors = aBorderColors->mNext;

  return Color::FromABGR(aBorderColors->mColor);
}

void
nsCSSBorderRenderer::DrawBorderSidesCompositeColors(int aSides, const nsBorderColors *aCompositeColors)
{
  RectCornerRadii radii = mBorderRadii;

  // the generic composite colors path; each border is 1px in size
  Rect soRect = mOuterRect;
  Float maxBorderWidth = 0;
  NS_FOR_CSS_SIDES (i) {
    maxBorderWidth = std::max(maxBorderWidth, Float(mBorderWidths[i]));
  }

  Float fakeBorderSizes[4];

  Point itl = mInnerRect.TopLeft();
  Point ibr = mInnerRect.BottomRight();

  for (uint32_t i = 0; i < uint32_t(maxBorderWidth); i++) {
    ColorPattern color(ToDeviceColor(
                         ComputeCompositeColorForLine(i, aCompositeColors)));

    Rect siRect = soRect;
    siRect.Deflate(1.0);

    // now cap the rects to the real mInnerRect
    Point tl = siRect.TopLeft();
    Point br = siRect.BottomRight();

    tl.x = std::min(tl.x, itl.x);
    tl.y = std::min(tl.y, itl.y);

    br.x = std::max(br.x, ibr.x);
    br.y = std::max(br.y, ibr.y);

    siRect = Rect(tl.x, tl.y, br.x - tl.x , br.y - tl.y);

    fakeBorderSizes[NS_SIDE_TOP] = siRect.TopLeft().y - soRect.TopLeft().y;
    fakeBorderSizes[NS_SIDE_RIGHT] = soRect.TopRight().x - siRect.TopRight().x;
    fakeBorderSizes[NS_SIDE_BOTTOM] = soRect.BottomRight().y - siRect.BottomRight().y;
    fakeBorderSizes[NS_SIDE_LEFT] = siRect.BottomLeft().x - soRect.BottomLeft().x;

    FillSolidBorder(soRect, siRect, radii, fakeBorderSizes, aSides, color);

    soRect = siRect;

    ComputeInnerRadii(radii, fakeBorderSizes, &radii);
  }
}

void
nsCSSBorderRenderer::DrawBorderSides(int aSides)
{
  if (aSides == 0 || (aSides & ~SIDE_BITS_ALL) != 0) {
    NS_WARNING("DrawBorderSides: invalid sides!");
    return;
  }

  uint8_t borderRenderStyle = NS_STYLE_BORDER_STYLE_NONE;
  nscolor borderRenderColor;
  const nsBorderColors *compositeColors = nullptr;

  uint32_t borderColorStyleCount = 0;
  BorderColorStyle borderColorStyleTopLeft[3], borderColorStyleBottomRight[3];
  BorderColorStyle *borderColorStyle = nullptr;

  NS_FOR_CSS_SIDES (i) {
    if ((aSides & (1 << i)) == 0)
      continue;
    borderRenderStyle = mBorderStyles[i];
    borderRenderColor = mBorderColors[i];
    compositeColors = mCompositeColors[i];
    break;
  }

  if (borderRenderStyle == NS_STYLE_BORDER_STYLE_NONE ||
      borderRenderStyle == NS_STYLE_BORDER_STYLE_HIDDEN)
    return;

  if (borderRenderStyle == NS_STYLE_BORDER_STYLE_DASHED ||
      borderRenderStyle == NS_STYLE_BORDER_STYLE_DOTTED) {
    // Draw each corner separately, with the given side's color.
    if (aSides & SIDE_BIT_TOP) {
      DrawDashedOrDottedCorner(NS_SIDE_TOP, C_TL);
    } else if (aSides & SIDE_BIT_LEFT) {
      DrawDashedOrDottedCorner(NS_SIDE_LEFT, C_TL);
    }

    if (aSides & SIDE_BIT_TOP) {
      DrawDashedOrDottedCorner(NS_SIDE_TOP, C_TR);
    } else if (aSides & SIDE_BIT_RIGHT) {
      DrawDashedOrDottedCorner(NS_SIDE_RIGHT, C_TR);
    }

    if (aSides & SIDE_BIT_BOTTOM) {
      DrawDashedOrDottedCorner(NS_SIDE_BOTTOM, C_BL);
    } else if (aSides & SIDE_BIT_LEFT) {
      DrawDashedOrDottedCorner(NS_SIDE_LEFT, C_BL);
    }

    if (aSides & SIDE_BIT_BOTTOM) {
      DrawDashedOrDottedCorner(NS_SIDE_BOTTOM, C_BR);
    } else if (aSides & SIDE_BIT_RIGHT) {
      DrawDashedOrDottedCorner(NS_SIDE_RIGHT, C_BR);
    }
    return;
  }

  // -moz-border-colors is a hack; if we have it for a border, then
  // it's always drawn solid, and each color is given 1px.  The last
  // color is used for the remainder of the border's size.  Just
  // hand off to another function to do all that.
  if (compositeColors) {
    Float maxBorderWidth(0);
    NS_FOR_CSS_SIDES (i) {
      maxBorderWidth = std::max(maxBorderWidth, mBorderWidths[i]);
    }
    if (maxBorderWidth <= MAX_COMPOSITE_BORDER_WIDTH) {
      DrawBorderSidesCompositeColors(aSides, compositeColors);
      return;
    }
    NS_WARNING("DrawBorderSides: too large border width for composite colors");
 }

  // We're not doing compositeColors, so we can calculate the
  // borderColorStyle based on the specified style.  The
  // borderColorStyle array goes from the outer to the inner style.
  //
  // If the border width is 1, we need to change the borderRenderStyle
  // a bit to make sure that we get the right colors -- e.g. 'ridge'
  // with a 1px border needs to look like solid, not like 'outset'.
  if (mOneUnitBorder &&
      (borderRenderStyle == NS_STYLE_BORDER_STYLE_RIDGE ||
       borderRenderStyle == NS_STYLE_BORDER_STYLE_GROOVE ||
       borderRenderStyle == NS_STYLE_BORDER_STYLE_DOUBLE))
    borderRenderStyle = NS_STYLE_BORDER_STYLE_SOLID;

  switch (borderRenderStyle) {
    case NS_STYLE_BORDER_STYLE_SOLID:
      borderColorStyleTopLeft[0] = BorderColorStyleSolid;

      borderColorStyleBottomRight[0] = BorderColorStyleSolid;

      borderColorStyleCount = 1;
      break;

    case NS_STYLE_BORDER_STYLE_GROOVE:
      borderColorStyleTopLeft[0] = BorderColorStyleDark;
      borderColorStyleTopLeft[1] = BorderColorStyleLight;

      borderColorStyleBottomRight[0] = BorderColorStyleLight;
      borderColorStyleBottomRight[1] = BorderColorStyleDark;

      borderColorStyleCount = 2;
      break;

    case NS_STYLE_BORDER_STYLE_RIDGE:
      borderColorStyleTopLeft[0] = BorderColorStyleLight;
      borderColorStyleTopLeft[1] = BorderColorStyleDark;

      borderColorStyleBottomRight[0] = BorderColorStyleDark;
      borderColorStyleBottomRight[1] = BorderColorStyleLight;

      borderColorStyleCount = 2;
      break;

    case NS_STYLE_BORDER_STYLE_DOUBLE:
      borderColorStyleTopLeft[0] = BorderColorStyleSolid;
      borderColorStyleTopLeft[1] = BorderColorStyleNone;
      borderColorStyleTopLeft[2] = BorderColorStyleSolid;

      borderColorStyleBottomRight[0] = BorderColorStyleSolid;
      borderColorStyleBottomRight[1] = BorderColorStyleNone;
      borderColorStyleBottomRight[2] = BorderColorStyleSolid;

      borderColorStyleCount = 3;
      break;

    case NS_STYLE_BORDER_STYLE_INSET:
      borderColorStyleTopLeft[0] = BorderColorStyleDark;
      borderColorStyleBottomRight[0] = BorderColorStyleLight;

      borderColorStyleCount = 1;
      break;

    case NS_STYLE_BORDER_STYLE_OUTSET:
      borderColorStyleTopLeft[0] = BorderColorStyleLight;
      borderColorStyleBottomRight[0] = BorderColorStyleDark;

      borderColorStyleCount = 1;
      break;

    default:
      NS_NOTREACHED("Unhandled border style!!");
      break;
  }

  // The only way to get to here is by having a
  // borderColorStyleCount < 1 or > 3; this should never happen,
  // since -moz-border-colors doesn't get handled here.
  NS_ASSERTION(borderColorStyleCount > 0 && borderColorStyleCount < 4,
               "Non-border-colors case with borderColorStyleCount < 1 or > 3; what happened?");

  // The caller should never give us anything with a mix
  // of TL/BR if the border style would require a
  // TL/BR split.
  if (aSides & (SIDE_BIT_BOTTOM | SIDE_BIT_RIGHT))
    borderColorStyle = borderColorStyleBottomRight;
  else
    borderColorStyle = borderColorStyleTopLeft;

  // Distribute the border across the available space.
  Float borderWidths[3][4];

  if (borderColorStyleCount == 1) {
    NS_FOR_CSS_SIDES (i) {
      borderWidths[0][i] = mBorderWidths[i];
    }
  } else if (borderColorStyleCount == 2) {
    // with 2 color styles, any extra pixel goes to the outside
    NS_FOR_CSS_SIDES (i) {
      borderWidths[0][i] = int32_t(mBorderWidths[i]) / 2 + int32_t(mBorderWidths[i]) % 2;
      borderWidths[1][i] = int32_t(mBorderWidths[i]) / 2;
    }
  } else if (borderColorStyleCount == 3) {
    // with 3 color styles, any extra pixel (or lack of extra pixel)
    // goes to the middle
    NS_FOR_CSS_SIDES (i) {
      if (mBorderWidths[i] == 1.0) {
        borderWidths[0][i] = 1.f;
        borderWidths[1][i] = borderWidths[2][i] = 0.f;
      } else {
        int32_t rest = int32_t(mBorderWidths[i]) % 3;
        borderWidths[0][i] = borderWidths[2][i] = borderWidths[1][i] = (int32_t(mBorderWidths[i]) - rest) / 3;

        if (rest == 1) {
          borderWidths[1][i] += 1.f;
        } else if (rest == 2) {
          borderWidths[0][i] += 1.f;
          borderWidths[2][i] += 1.f;
        }
      }
    }
  }

  // make a copy that we can modify
  RectCornerRadii radii = mBorderRadii;

  Rect soRect(mOuterRect);
  Rect siRect(mOuterRect);

  // If adjacent side is dotted and radius=0, draw side to the end of corner.
  //
  // +--------------------------------
  // |################################
  // |
  // |################################
  // +-----+--------------------------
  // |     |
  // |     |
  // |     |
  // |     |
  // |     |
  // | ### |
  // |#####|
  // |#####|
  // |#####|
  // | ### |
  // |     |
  bool noMarginTop = false;
  bool noMarginRight = false;
  bool noMarginBottom = false;
  bool noMarginLeft = false;

  // If there is at least one dotted side, every side is rendered separately.
  if (IsSingleSide(aSides)) {
    if (aSides == SIDE_BIT_TOP) {
      if (mBorderStyles[NS_SIDE_RIGHT] == NS_STYLE_BORDER_STYLE_DOTTED &&
          IsZeroSize(mBorderRadii[C_TR])) {
        noMarginRight = true;
      }
      if (mBorderStyles[NS_SIDE_LEFT] == NS_STYLE_BORDER_STYLE_DOTTED &&
          IsZeroSize(mBorderRadii[C_TL])) {
        noMarginLeft = true;
      }
    } else if (aSides == SIDE_BIT_RIGHT) {
      if (mBorderStyles[NS_SIDE_TOP] == NS_STYLE_BORDER_STYLE_DOTTED &&
          IsZeroSize(mBorderRadii[C_TR])) {
        noMarginTop = true;
      }
      if (mBorderStyles[NS_SIDE_BOTTOM] == NS_STYLE_BORDER_STYLE_DOTTED &&
          IsZeroSize(mBorderRadii[C_BR])) {
        noMarginBottom = true;
      }
    } else if (aSides == SIDE_BIT_BOTTOM) {
      if (mBorderStyles[NS_SIDE_RIGHT] == NS_STYLE_BORDER_STYLE_DOTTED &&
          IsZeroSize(mBorderRadii[C_BR])) {
        noMarginRight = true;
      }
      if (mBorderStyles[NS_SIDE_LEFT] == NS_STYLE_BORDER_STYLE_DOTTED &&
          IsZeroSize(mBorderRadii[C_BL])) {
        noMarginLeft = true;
      }
    } else {
      if (mBorderStyles[NS_SIDE_TOP] == NS_STYLE_BORDER_STYLE_DOTTED &&
          IsZeroSize(mBorderRadii[C_TL])) {
        noMarginTop = true;
      }
      if (mBorderStyles[NS_SIDE_BOTTOM] == NS_STYLE_BORDER_STYLE_DOTTED &&
          IsZeroSize(mBorderRadii[C_BL])) {
        noMarginBottom = true;
      }
    }
  }

  for (unsigned int i = 0; i < borderColorStyleCount; i++) {
    // walk siRect inwards at the start of the loop to get the
    // correct inner rect.
    //
    // If noMarginTop is false:
    //   --------------------+
    //                      /|
    //                     / |
    //                    L  |
    //   ----------------+   |
    //                   |   |
    //                   |   |
    //
    // If noMarginTop is true:
    //   ----------------+<--+
    //                   |   |
    //                   |   |
    //                   |   |
    //                   |   |
    //                   |   |
    //                   |   |
    siRect.Deflate(Margin(noMarginTop ? 0 : borderWidths[i][0],
                          noMarginRight ? 0 : borderWidths[i][1],
                          noMarginBottom ? 0 : borderWidths[i][2],
                          noMarginLeft ? 0 : borderWidths[i][3]));

    if (borderColorStyle[i] != BorderColorStyleNone) {
      Color c = ComputeColorForLine(i, borderColorStyle, borderColorStyleCount,
                                    borderRenderColor, mBackgroundColor);
      ColorPattern color(ToDeviceColor(c));

      FillSolidBorder(soRect, siRect, radii, borderWidths[i], aSides, color);
    }

    ComputeInnerRadii(radii, borderWidths[i], &radii);

    // And now soRect is the same as siRect, for the next line in.
    soRect = siRect;
  }
}

void
nsCSSBorderRenderer::SetupDashedOptions(StrokeOptions* aStrokeOptions,
                                        Float aDash[2],
                                        mozilla::css::Side aSide,
                                        Float aBorderLength, bool isCorner)
{
  uint8_t style = mBorderStyles[aSide];
  Float borderWidth = mBorderWidths[aSide];

  // Dashed line starts and ends with half segment in most case.
  //
  // __--+---+---+---+---+---+---+---+---+--__
  //     |###|   |   |###|###|   |   |###|
  //     |###|   |   |###|###|   |   |###|
  //     |###|   |   |###|###|   |   |###|
  // __--+---+---+---+---+---+---+---+---+--__
  //
  // If radius=0 and other side is either dotted or 0-width, it starts or ends
  // with full segment.
  //
  // +---+---+---+---+---+---+---+---+---+---+
  // |###|###|   |   |###|###|   |   |###|###|
  // |###|###|   |   |###|###|   |   |###|###|
  // |###|###|   |   |###|###|   |   |###|###|
  // +---++--+---+---+---+---+---+---+--++---+
  // |    |                             |    |
  // |    |                             |    |
  // |    |                             |    |
  // |    |                             |    |
  // | ## |                             | ## |
  // |####|                             |####|
  // |####|                             |####|
  // | ## |                             | ## |
  // |    |                             |    |
  bool fullStart = false, fullEnd = false;
  Float halfDash;
  if (style == NS_STYLE_BORDER_STYLE_DASHED) {
    if (IsZeroSize(mBorderRadii[GetCCWCorner(aSide)]) &&
        (mBorderStyles[PREV_SIDE(aSide)] == NS_STYLE_BORDER_STYLE_DOTTED ||
         mBorderWidths[PREV_SIDE(aSide)] == 0.0f ||
         borderWidth <= 1.0f)) {
      fullStart = true;
    }

    if (IsZeroSize(mBorderRadii[GetCWCorner(aSide)]) &&
        (mBorderStyles[NEXT_SIDE(aSide)] == NS_STYLE_BORDER_STYLE_DOTTED ||
         mBorderWidths[NEXT_SIDE(aSide)] == 0.0f)) {
      fullEnd = true;
    }

    halfDash = borderWidth * DOT_LENGTH * DASH_LENGTH / 2.0f;
  } else {
    halfDash = borderWidth * DOT_LENGTH / 2.0f;
  }

  if (style == NS_STYLE_BORDER_STYLE_DASHED && aBorderLength > 0.0f) {
    // The number of half segments, with maximum dash length.
    int32_t count = floor(aBorderLength / halfDash);
    Float minHalfDash = borderWidth * DOT_LENGTH / 2.0f;

    if (fullStart && fullEnd) {
      // count should be 4n + 2
      //
      //   1 +       4       +        4      + 1
      //
      // |   |               |               |   |
      // +---+---+---+---+---+---+---+---+---+---+
      // |###|###|   |   |###|###|   |   |###|###|
      // |###|###|   |   |###|###|   |   |###|###|
      // |###|###|   |   |###|###|   |   |###|###|
      // +---+---+---+---+---+---+---+---+---+---+

      // If border is too short, draw solid line.
      if (aBorderLength < 6.0f * minHalfDash)
        return;

      if (count % 4 == 0) {
        count += 2;
      } else if (count % 4 == 1) {
        count += 1;
      } else if (count % 4 == 3) {
        count += 3;
      }
    } else if (fullStart || fullEnd) {
      // count should be 4n + 1
      //
      //   1 +       4       +        4
      //
      // |   |               |               |
      // +---+---+---+---+---+---+---+---+---+
      // |###|###|   |   |###|###|   |   |###|
      // |###|###|   |   |###|###|   |   |###|
      // |###|###|   |   |###|###|   |   |###|
      // +---+---+---+---+---+---+---+---+---+
      //
      //         4       +        4      + 1
      //
      // |               |               |   |
      // +---+---+---+---+---+---+---+---+---+
      // |###|   |   |###|###|   |   |###|###|
      // |###|   |   |###|###|   |   |###|###|
      // |###|   |   |###|###|   |   |###|###|
      // +---+---+---+---+---+---+---+---+---+

      // If border is too short, draw solid line.
      if (aBorderLength < 5.0f * minHalfDash)
        return;

      if (count % 4 == 0) {
        count += 1;
      } else if (count % 4 == 2) {
        count += 3;
      } else if (count % 4 == 3) {
        count += 2;
      }
    } else {
      // count should be 4n
      //
      //         4       +        4
      //
      // |               |               |
      // +---+---+---+---+---+---+---+---+
      // |###|   |   |###|###|   |   |###|
      // |###|   |   |###|###|   |   |###|
      // |###|   |   |###|###|   |   |###|
      // +---+---+---+---+---+---+---+---+

      // If border is too short, draw solid line.
      if (aBorderLength < 4.0f * minHalfDash)
        return;

      if (count % 4 == 1) {
        count += 3;
      } else if (count % 4 == 2) {
        count += 2;
      } else if (count % 4 == 3) {
        count += 1;
      }
    }
    halfDash = aBorderLength / count;
  }

  Float fullDash = halfDash * 2.0f;

  aDash[0] = fullDash;
  aDash[1] = fullDash;

  if (style == NS_STYLE_BORDER_STYLE_DASHED && fullDash > 1.0f) {
    if (!fullStart) {
      // Draw half segments on both ends.
      aStrokeOptions->mDashOffset = halfDash;
    }
  } else if (style != NS_STYLE_BORDER_STYLE_DOTTED && isCorner) {
    // If side ends with filled full segment, corner should start with unfilled
    // full segment. Not needed for dotted corners, as they overlap one dot with
    // the side's end.
    //
    //     corner            side
    //   ------------>|<---------------------------
    //                |
    //          __+---+---+---+---+---+---+---+---+
    //       _+-  |   |###|###|   |   |###|###|   |
    //     /##|   |   |###|###|   |   |###|###|   |
    //    +####|   |  |###|###|   |   |###|###|   |
    //   /#\####| _+--+---+---+---+---+---+---+---+
    //  |####\##+-
    //  |#####+-
    //  +--###/
    //  |  --+
    aStrokeOptions->mDashOffset = fullDash;
  }

  aStrokeOptions->mDashPattern = aDash;
  aStrokeOptions->mDashLength = 2;

  PrintAsFormatString("dash: %f %f\n", aDash[0], aDash[1]);
}

static Float
GetBorderLength(mozilla::css::Side aSide,
                const Point& aStart, const Point& aEnd)
{
  if (aSide == NS_SIDE_TOP) {
    return aEnd.x - aStart.x;
  }
  if (aSide == NS_SIDE_RIGHT) {
    return aEnd.y - aStart.y;
  }
  if (aSide == NS_SIDE_BOTTOM) {
    return aStart.x - aEnd.x;
  }
  return aStart.y - aEnd.y;
}

void
nsCSSBorderRenderer::DrawDashedOrDottedSide(mozilla::css::Side aSide)
{
  // Draw dashed/dotted side with following approach.
  //
  // dashed side
  //   Draw dashed line along the side, with appropriate dash length and gap
  //   to make the side symmetric as far as possible.  Dash length equals to
  //   the gap, and the ratio of the dash length to border-width is the maximum
  //   value in in [1, 3] range.
  //   In most case, line ends with half segment, to joint with corner easily.
  //   If adjacent side is dotted or 0px and border-radius for the corner
  //   between them is 0, the line ends with full segment.
  //   (see comment for GetStraightBorderPoint for more detail)
  //
  // dotted side
  //   If border-width <= 2.0, draw 1:1 dashed line.
  //   Otherwise, draw circles along the side, with appropriate gap that makes
  //   the side symmetric as far as possible.  The ratio of the gap to
  //   border-width is the maximum value in [0.5, 1] range in most case.
  //   if the side is too short and there's only 2 dots, it can be more smaller.
  //   If there's no space to place 2 dots at the side, draw single dot at the
  //   middle of the side.
  //   In most case, line ends with filled dot, to joint with corner easily,
  //   If adjacent side is dotted with larger border-width, or other style,
  //   the line ends with unfilled dot.
  //   (see comment for GetStraightBorderPoint for more detail)

  NS_ASSERTION(mBorderStyles[aSide] == NS_STYLE_BORDER_STYLE_DASHED ||
               mBorderStyles[aSide] == NS_STYLE_BORDER_STYLE_DOTTED,
               "Style should be dashed or dotted.");

  Float borderWidth = mBorderWidths[aSide];
  if (borderWidth == 0.0f) {
    return;
  }

  if (mBorderStyles[aSide] == NS_STYLE_BORDER_STYLE_DOTTED &&
      borderWidth > 2.0f) {
    DrawDottedSideSlow(aSide);
    return;
  }

  nscolor borderColor = mBorderColors[aSide];
  bool ignored;
  // Get the start and end points of the side, ensuring that any dot origins get
  // pushed outward to account for stroking.
  Point start = GetStraightBorderPoint(aSide, GetCCWCorner(aSide), &ignored, 0.5f);
  Point end = GetStraightBorderPoint(aSide, GetCWCorner(aSide), &ignored, 0.5f);
  if (borderWidth < 2.0f) {
    // Round start to draw dot on each pixel.
    if (IsHorizontalSide(aSide)) {
      start.x = round(start.x);
    } else {
      start.y = round(start.y);
    }
  }

  Float borderLength = GetBorderLength(aSide, start, end);
  if (borderLength < 0.0f) {
    return;
  }

  StrokeOptions strokeOptions(borderWidth);
  Float dash[2];
  SetupDashedOptions(&strokeOptions, dash, aSide, borderLength, false);

  // For dotted sides that can merge with their prior dotted sides, advance the
  // dash offset to measure the distance around the combined path. This prevents
  // two dots from bunching together at a corner.
  mozilla::css::Side mergeSide = aSide;
  while (IsCornerMergeable(GetCCWCorner(mergeSide))) {
    mergeSide = PREV_SIDE(mergeSide);
    // If we looped all the way around, measure starting at the top side, since
    // we need to pick a fixed location to start measuring distance from still.
    if (mergeSide == aSide) {
      mergeSide = eSideTop;
      break;
    }
  }
  while (mergeSide != aSide) {
    // Measure the length of the merged side starting from a possibly unmergeable
    // corner up to the merged corner. A merged corner effectively has no border
    // radius, so we can just use the cheaper AtCorner to find the end point.
    Float mergeLength =
      GetBorderLength(mergeSide,
                      GetStraightBorderPoint(mergeSide, GetCCWCorner(mergeSide), &ignored, 0.5f),
                      mOuterRect.AtCorner(GetCWCorner(mergeSide)));
    // Add in the merged side length. Also offset the dash progress by an extra
    // dot's width to avoid drawing a dot that would overdraw where the merged side
    // would have ended in a gap, i.e. O_O_
    //                                    O
    strokeOptions.mDashOffset += mergeLength + borderWidth;
    mergeSide = NEXT_SIDE(mergeSide);
  }

  DrawOptions drawOptions;
  if (mBorderStyles[aSide] == NS_STYLE_BORDER_STYLE_DOTTED) {
    drawOptions.mAntialiasMode = AntialiasMode::NONE;
  }


  mDrawTarget->StrokeLine(start, end,
                          ColorPattern(ToDeviceColor(borderColor)),
                          strokeOptions,
                          drawOptions);
}

void
nsCSSBorderRenderer::DrawDottedSideSlow(mozilla::css::Side aSide)
{
  // Draw each circles separately for dotted with borderWidth > 2.0.
  // Dashed line with CapStyle::ROUND doesn't render perfect circles.

  NS_ASSERTION(mBorderStyles[aSide] == NS_STYLE_BORDER_STYLE_DOTTED,
               "Style should be dotted.");

  Float borderWidth = mBorderWidths[aSide];
  if (borderWidth == 0.0f) {
    return;
  }

  nscolor borderColor = mBorderColors[aSide];
  bool isStartUnfilled, isEndUnfilled;
  Point start = GetStraightBorderPoint(aSide, GetCCWCorner(aSide),
                                       &isStartUnfilled);
  Point end = GetStraightBorderPoint(aSide, GetCWCorner(aSide),
                                     &isEndUnfilled);
  enum {
    // Corner is not mergeable.
    NO_MERGE,

    // Corner between different colors.
    // Two dots are merged into one, and both side draw half dot.
    MERGE_HALF,

    // Corner between same colors, CCW corner of the side.
    // Two dots are merged into one, and this side draw entire dot.
    //
    // MERGE_ALL               MERGE_NONE
    //   |                       |
    //   v                       v
    // +-----------------------+----+
    // | ##      ##      ##    | ## |
    // |####    ####    ####   |####|
    // |####    ####    ####   |####|
    // | ##      ##      ##    | ## |
    // +----+------------------+    |
    // |    |                  |    |
    // |    |                  |    |
    // |    |                  |    |
    // | ## |                  | ## |
    // |####|                  |####|
    MERGE_ALL,

    // Corner between same colors, CW corner of the side.
    // Two dots are merged into one, and this side doesn't draw dot.
    MERGE_NONE
  } mergeStart = NO_MERGE, mergeEnd = NO_MERGE;
  if (IsCornerMergeable(GetCCWCorner(aSide))) {
    if (borderColor == mBorderColors[PREV_SIDE(aSide)]) {
      mergeStart = MERGE_ALL;
    } else {
      mergeStart = MERGE_HALF;
    }
  }

  if (IsCornerMergeable(GetCWCorner(aSide))) {
    if (borderColor == mBorderColors[NEXT_SIDE(aSide)]) {
      mergeEnd = MERGE_NONE;
    } else {
      mergeEnd = MERGE_HALF;
    }
  }

  Float borderLength = GetBorderLength(aSide, start, end);
  if (borderLength < 0.0f) {
    if (isStartUnfilled || isEndUnfilled) {
      return;
    }
    borderLength = 0.0f;
    start = end = (start + end) / 2.0f;
  }

  Float dotWidth = borderWidth * DOT_LENGTH;
  Float radius = borderWidth / 2.0f;
  if (borderLength < dotWidth) {
    // If dots on start and end may overlap, draw a dot at the middle of them.
    //
    //     ___---+-------+---___
    // __--      | ##### |      --__
    //          #|#######|#
    //         ##|#######|##
    //        ###|#######|###
    //        ###+###+###+###
    //         start ## end #
    //         ##|#######|##
    //          #|#######|#
    //           | ##### |
    //       __--+-------+--__
    //     _-                 -_
    //
    // If that circle overflows from outer rect, do not draw it.
    //
    //           +-------+
    //           | ##### |
    //          #|#######|#
    //         ##|#######|##
    //        ###|#######|###
    //        ###|###+###|###
    //        ###|#######|###
    //         ##|#######|##
    //          #|#######|#
    //           | ##### |
    //           +--+-+--+
    //           |  | |  |
    //           |  | |  |
    if (!mOuterRect.Contains(Rect(start.x - radius, start.y - radius,
                                  borderWidth, borderWidth))) {
      return;
    }

    if (isStartUnfilled || isEndUnfilled) {
      return;
    }

    Point P = (start + end) / 2;
    RefPtr<PathBuilder> builder = mDrawTarget->CreatePathBuilder();
    builder->MoveTo(Point(P.x + radius, P.y));
    builder->Arc(P, radius, 0.0f, Float(2.0 * M_PI));
    RefPtr<Path> path = builder->Finish();
    mDrawTarget->Fill(path, ColorPattern(ToDeviceColor(borderColor)));
    return;
  }

  if (mergeStart == MERGE_HALF || mergeEnd == MERGE_HALF) {
    // MERGE_HALF
    //               Eo
    //   -------+----+
    //        ##### /
    //       ######/
    //      ######/
    //      ####+
    //      ##/ end
    //       /
    //      /
    //   --+
    //     Ei
    //
    // other (NO_MERGE, MERGE_ALL, MERGE_NONE)
    //               Eo
    //   ------------+
    //        #####  |
    //       ####### |
    //      #########|
    //      ####+####|
    //      ## end ##|
    //       ####### |
    //        #####  |
    //   ------------+
    //               Ei

    Point I(0.0f, 0.0f), J(0.0f, 0.0f);
    if (aSide == NS_SIDE_TOP) {
      I.x = 1.0f;
      J.y = 1.0f;
    } else if (aSide == NS_SIDE_RIGHT) {
      I.y = 1.0f;
      J.x = -1.0f;
    } else if (aSide == NS_SIDE_BOTTOM) {
      I.x = -1.0f;
      J.y = -1.0f;
    } else if (aSide == NS_SIDE_LEFT) {
      I.y = -1.0f;
      J.x = 1.0f;
    }

    Point So, Si, Eo, Ei;

    So = (start + (-I + -J) * borderWidth / 2.0f);
    Si = (mergeStart == MERGE_HALF)
         ? (start + (I + J) * borderWidth / 2.0f)
         : (start + (-I + J) * borderWidth / 2.0f);
    Eo = (end + (I - J) * borderWidth / 2.0f);
    Ei = (mergeEnd == MERGE_HALF)
         ? (end + (-I + J) * borderWidth / 2.0f)
         : (end + (I + J) * borderWidth / 2.0f);

    RefPtr<PathBuilder> builder = mDrawTarget->CreatePathBuilder();
    builder->MoveTo(So);
    builder->LineTo(Eo);
    builder->LineTo(Ei);
    builder->LineTo(Si);
    builder->Close();
    RefPtr<Path> path = builder->Finish();

    mDrawTarget->PushClip(path);
  }

  size_t count = round(borderLength / dotWidth);
  if (isStartUnfilled == isEndUnfilled) {
    // Split into 2n segments.
    if (count % 2) {
      count++;
    }
  } else {
    // Split into 2n+1 segments.
    if (count % 2 == 0) {
      count++;
    }
  }

  // A: radius == borderWidth / 2.0
  // B: borderLength / count == borderWidth * (1 - overlap)
  //
  //   A      B         B        B        B     A
  // |<-->|<------>|<------>|<------>|<------>|<-->|
  // |    |        |        |        |        |    |
  // +----+--------+--------+--------+--------+----+
  // |  ##|##    **|**    ##|##    **|**    ##|##  |
  // | ###|###  ***|***  ###|###  ***|***  ###|### |
  // |####|####****|****####|####****|****####|####|
  // |####+####****+****####+####****+****####+####|
  // |# start #****|****####|####****|****## end ##|
  // | ###|###  ***|***  ###|###  ***|***  ###|### |
  // |  ##|##    **|**    ##|##    **|**    ##|##  |
  // +----+----+---+--------+--------+---+----+----+
  // |         |                         |         |
  // |         |                         |         |

  // If isStartUnfilled is true, draw dots on 2j+1 points, if not, draw dots on
  // 2j points.
  size_t from = isStartUnfilled ? 1 : 0;

  // If mergeEnd == MERGE_NONE, last dot is drawn by next side.
  size_t to = count;
  if (mergeEnd == MERGE_NONE) {
    if (to > 2) {
      to -= 2;
    } else {
      to = 0;
    }
  }

  Point fromP = (start * (count - from) + end * from) / count;
  Point toP = (start * (count - to) + end * to) / count;
  // Extend dirty rect to avoid clipping pixel for anti-aliasing.
  const Float AA_MARGIN = 2.0f;

  if (aSide == NS_SIDE_TOP) {
    // Tweak |from| and |to| to fit into |mDirtyRect + radius margin|,
    // to render only paths that may overlap mDirtyRect.
    //
    //                mDirtyRect + radius margin
    //              +--+---------------------+--+
    //              |                           |
    //              |         mDirtyRect        |
    //              +  +---------------------+  +
    // from   ===>  |from                    to |   <===  to
    //    +-----+-----+-----+-----+-----+-----+-----+-----+
    //   ###        |###         ###         ###|        ###
    //  #####       #####       #####       #####       #####
    //  #####       #####       #####       #####       #####
    //  #####       #####       #####       #####       #####
    //   ###        |###         ###         ###|        ###
    //              |  |                     |  |
    //              +  +---------------------+  +
    //              |                           |
    //              |                           |
    //              +--+---------------------+--+

    Float left = mDirtyRect.x - radius - AA_MARGIN;
    if (fromP.x < left) {
      size_t tmp = ceil(count * (left - start.x) / (end.x - start.x));
      if (tmp > from) {
        // We increment by 2, so odd/even should match between before/after.
        if ((tmp & 1) != (from & 1)) {
          from = tmp - 1;
        } else {
          from = tmp;
        }
      }
    }
    Float right = mDirtyRect.x + mDirtyRect.width + radius + AA_MARGIN;
    if (toP.x > right) {
      size_t tmp = floor(count * (right - start.x) / (end.x - start.x));
      if (tmp < to) {
        if ((tmp & 1) != (to & 1)) {
          to = tmp + 1;
        } else {
          to = tmp;
        }
      }
    }
  } else if (aSide == NS_SIDE_RIGHT) {
    Float top = mDirtyRect.y - radius - AA_MARGIN;
    if (fromP.y < top) {
      size_t tmp = ceil(count * (top - start.y) / (end.y - start.y));
      if (tmp > from) {
        if ((tmp & 1) != (from & 1)) {
          from = tmp - 1;
        } else {
          from = tmp;
        }
      }
    }
    Float bottom = mDirtyRect.y + mDirtyRect.height + radius + AA_MARGIN;
    if (toP.y > bottom) {
      size_t tmp = floor(count * (bottom - start.y) / (end.y - start.y));
      if (tmp < to) {
        if ((tmp & 1) != (to & 1)) {
          to = tmp + 1;
        } else {
          to = tmp;
        }
      }
    }
  } else if (aSide == NS_SIDE_BOTTOM) {
    Float right = mDirtyRect.x + mDirtyRect.width + radius + AA_MARGIN;
    if (fromP.x > right) {
      size_t tmp = ceil(count * (right - start.x) / (end.x - start.x));
      if (tmp > from) {
        if ((tmp & 1) != (from & 1)) {
          from = tmp - 1;
        } else {
          from = tmp;
        }
      }
    }
    Float left = mDirtyRect.x - radius - AA_MARGIN;
    if (toP.x < left) {
      size_t tmp = floor(count * (left - start.x) / (end.x - start.x));
      if (tmp < to) {
        if ((tmp & 1) != (to & 1)) {
          to = tmp + 1;
        } else {
          to = tmp;
        }
      }
    }
  } else if (aSide == NS_SIDE_LEFT) {
    Float bottom = mDirtyRect.y + mDirtyRect.height + radius + AA_MARGIN;
    if (fromP.y > bottom) {
      size_t tmp = ceil(count * (bottom - start.y) / (end.y - start.y));
      if (tmp > from) {
        if ((tmp & 1) != (from & 1)) {
          from = tmp - 1;
        } else {
          from = tmp;
        }
      }
    }
    Float top = mDirtyRect.y - radius - AA_MARGIN;
    if (toP.y < top) {
      size_t tmp = floor(count * (top - start.y) / (end.y - start.y));
      if (tmp < to) {
        if ((tmp & 1) != (to & 1)) {
          to = tmp + 1;
        } else {
          to = tmp;
        }
      }
    }
  }

  RefPtr<PathBuilder> builder = mDrawTarget->CreatePathBuilder();
  size_t segmentCount = 0;
  for (size_t i = from; i <= to; i += 2) {
    if (segmentCount > BORDER_SEGMENT_COUNT_MAX) {
      RefPtr<Path> path = builder->Finish();
      mDrawTarget->Fill(path, ColorPattern(ToDeviceColor(borderColor)));
      builder = mDrawTarget->CreatePathBuilder();
      segmentCount = 0;
    }

    Point P = (start * (count - i) + end * i) / count;
    builder->MoveTo(Point(P.x + radius, P.y));
    builder->Arc(P, radius, 0.0f, Float(2.0 * M_PI));
    segmentCount++;
  }
  RefPtr<Path> path = builder->Finish();
  mDrawTarget->Fill(path, ColorPattern(ToDeviceColor(borderColor)));

  if (mergeStart == MERGE_HALF || mergeEnd == MERGE_HALF) {
    mDrawTarget->PopClip();
  }
}

void
nsCSSBorderRenderer::DrawDashedOrDottedCorner(mozilla::css::Side aSide,
                                              mozilla::css::Corner aCorner)
{
  // Draw dashed/dotted corner with following approach.
  //
  // dashed corner
  //   If both side has same border-width and border-width <= 2.0, draw dashed
  //   line along the corner, with appropriate dash length and gap to make the
  //   corner symmetric as far as possible.  Dash length equals to the gap, and
  //   the ratio of the dash length to border-width is the maximum value in in
  //   [1, 3] range.
  //   Otherwise, draw dashed segments along the corner, keeping same dash
  //   length ratio to border-width at that point.
  //   (see DashedCornerFinder.h for more detail)
  //   Line ends with half segments, to joint with both side easily.
  //
  // dotted corner
  //   If both side has same border-width and border-width <= 2.0, draw 1:1
  //   dashed line along the corner.
  //   Otherwise Draw circles along the corner, with appropriate gap that makes
  //   the corner symmetric as far as possible.  The size of the circle may
  //   change along the corner, that is tangent to the outer curver and the
  //   inner curve.  The ratio of the gap to circle diameter is the maximum
  //   value in [0.5, 1] range.
  //   (see DottedCornerFinder.h for more detail)
  //   Corner ends with filled dots but those dots are drawn by
  //   DrawDashedOrDottedSide.  So this may draw no circles if there's no space
  //   between 2 dots at both ends.

  NS_ASSERTION(mBorderStyles[aSide] == NS_STYLE_BORDER_STYLE_DASHED ||
               mBorderStyles[aSide] == NS_STYLE_BORDER_STYLE_DOTTED,
               "Style should be dashed or dotted.");

  if (IsCornerMergeable(aCorner)) {
    // DrawDashedOrDottedSide will draw corner.
     return;
   }

  mozilla::css::Side sideH(GetHorizontalSide(aCorner));
  mozilla::css::Side sideV(GetVerticalSide(aCorner));
  Float borderWidthH = mBorderWidths[sideH];
  Float borderWidthV = mBorderWidths[sideV];
  if (borderWidthH == 0.0f && borderWidthV == 0.0f) {
    return;
  }

  Float styleH = mBorderStyles[sideH];
  Float styleV = mBorderStyles[sideV];

  // Corner between dotted and others with radius=0 is drawn by side.
  if (IsZeroSize(mBorderRadii[aCorner]) &&
      (styleV == NS_STYLE_BORDER_STYLE_DOTTED ||
       styleH == NS_STYLE_BORDER_STYLE_DOTTED)) {
    return;
  }

  Float maxRadius = std::max(mBorderRadii[aCorner].width,
                             mBorderRadii[aCorner].height);
  if (maxRadius > BORDER_DOTTED_CORNER_MAX_RADIUS) {
    DrawFallbackSolidCorner(aSide, aCorner);
    return;
  }

  if (borderWidthH != borderWidthV || borderWidthH > 2.0f) {
    uint8_t style = mBorderStyles[aSide];
    if (style == NS_STYLE_BORDER_STYLE_DOTTED) {
      DrawDottedCornerSlow(aSide, aCorner);
    } else {
      DrawDashedCornerSlow(aSide, aCorner);
    }
    return;
  }

  nscolor borderColor = mBorderColors[aSide];
  Point points[4];
  bool ignored;
  // Get the start and end points of the corner arc, ensuring that any dot
  // origins get pushed backwards towards the edges of the corner rect to
  // account for stroking.
  points[0] = GetStraightBorderPoint(sideH, aCorner, &ignored, -0.5f);
  points[3] = GetStraightBorderPoint(sideV, aCorner, &ignored, -0.5f);
  // Round points to draw dot on each pixel.
  if (borderWidthH < 2.0f) {
    points[0].x = round(points[0].x);
  }
  if (borderWidthV < 2.0f) {
    points[3].y = round(points[3].y);
  }
  points[1] = points[0];
  points[1].x += kKappaFactor * (points[3].x - points[0].x);
  points[2] = points[3];
  points[2].y += kKappaFactor * (points[0].y - points[3].y);

  Float len = GetQuarterEllipticArcLength(fabs(points[0].x - points[3].x),
                                          fabs(points[0].y - points[3].y));

  Float dash[2];
  StrokeOptions strokeOptions(borderWidthH);
  SetupDashedOptions(&strokeOptions, dash, aSide, len, true);

  RefPtr<PathBuilder> builder = mDrawTarget->CreatePathBuilder();
  builder->MoveTo(points[0]);
  builder->BezierTo(points[1], points[2], points[3]);
  RefPtr<Path> path = builder->Finish();
  mDrawTarget->Stroke(path, ColorPattern(ToDeviceColor(borderColor)),
                      strokeOptions);
}

void
nsCSSBorderRenderer::DrawDottedCornerSlow(mozilla::css::Side aSide,
                                          mozilla::css::Corner aCorner)
{
  NS_ASSERTION(mBorderStyles[aSide] == NS_STYLE_BORDER_STYLE_DOTTED,
               "Style should be dotted.");

  mozilla::css::Side sideH(GetHorizontalSide(aCorner));
  mozilla::css::Side sideV(GetVerticalSide(aCorner));
  Float R0 = mBorderWidths[sideH] / 2.0f;
  Float Rn = mBorderWidths[sideV] / 2.0f;
  if (R0 == 0.0f && Rn == 0.0f) {
    return;
  }

  nscolor borderColor = mBorderColors[aSide];
  Bezier outerBezier;
  Bezier innerBezier;
  GetOuterAndInnerBezier(&outerBezier, &innerBezier, aCorner);

  bool ignored;
  Point C0 = GetStraightBorderPoint(sideH, aCorner, &ignored);
  Point Cn = GetStraightBorderPoint(sideV, aCorner, &ignored);
  DottedCornerFinder finder(outerBezier, innerBezier, aCorner,
                            mBorderRadii[aCorner].width,
                            mBorderRadii[aCorner].height,
                            C0, R0, Cn, Rn, mBorderCornerDimensions[aCorner]);

  RefPtr<PathBuilder> builder = mDrawTarget->CreatePathBuilder();
  size_t segmentCount = 0;
  const Float AA_MARGIN = 2.0f;
  Rect marginedDirtyRect = mDirtyRect;
  marginedDirtyRect.Inflate(std::max(R0, Rn) + AA_MARGIN);
  bool entered = false;
  while (finder.HasMore()) {
    if (segmentCount > BORDER_SEGMENT_COUNT_MAX) {
      RefPtr<Path> path = builder->Finish();
      mDrawTarget->Fill(path, ColorPattern(ToDeviceColor(borderColor)));
      builder = mDrawTarget->CreatePathBuilder();
      segmentCount = 0;
    }

    DottedCornerFinder::Result result = finder.Next();

    if (marginedDirtyRect.Contains(result.C) && result.r > 0) {
      entered = true;
      builder->MoveTo(Point(result.C.x + result.r, result.C.y));
      builder->Arc(result.C, result.r, 0, Float(2.0 * M_PI));
      segmentCount++;
    } else if (entered) {
      break;
    }
  }
  RefPtr<Path> path = builder->Finish();
  mDrawTarget->Fill(path, ColorPattern(ToDeviceColor(borderColor)));
}

static inline bool
DashedPathOverlapsRect(Rect& pathRect,
                       const Rect& marginedDirtyRect,
                       DashedCornerFinder::Result& result)
{
  // Calculate a rect that contains all control points of the |result| path,
  // and check if it intersects with |marginedDirtyRect|.
  pathRect.SetRect(result.outerSectionBezier.mPoints[0].x,
                   result.outerSectionBezier.mPoints[0].y, 0, 0);
  pathRect.ExpandToEnclose(result.outerSectionBezier.mPoints[1]);
  pathRect.ExpandToEnclose(result.outerSectionBezier.mPoints[2]);
  pathRect.ExpandToEnclose(result.outerSectionBezier.mPoints[3]);
  pathRect.ExpandToEnclose(result.innerSectionBezier.mPoints[0]);
  pathRect.ExpandToEnclose(result.innerSectionBezier.mPoints[1]);
  pathRect.ExpandToEnclose(result.innerSectionBezier.mPoints[2]);
  pathRect.ExpandToEnclose(result.innerSectionBezier.mPoints[3]);

  return pathRect.Intersects(marginedDirtyRect);
}

void
nsCSSBorderRenderer::DrawDashedCornerSlow(mozilla::css::Side aSide,
                                          mozilla::css::Corner aCorner)
{
  NS_ASSERTION(mBorderStyles[aSide] == NS_STYLE_BORDER_STYLE_DASHED,
               "Style should be dashed.");

  mozilla::css::Side sideH(GetHorizontalSide(aCorner));
  mozilla::css::Side sideV(GetVerticalSide(aCorner));
  Float borderWidthH = mBorderWidths[sideH];
  Float borderWidthV = mBorderWidths[sideV];
  if (borderWidthH == 0.0f && borderWidthV == 0.0f) {
    return;
  }

  nscolor borderColor = mBorderColors[aSide];
  Bezier outerBezier;
  Bezier innerBezier;
  GetOuterAndInnerBezier(&outerBezier, &innerBezier, aCorner);

  DashedCornerFinder finder(outerBezier, innerBezier,
                            borderWidthH, borderWidthV,
                            mBorderCornerDimensions[aCorner]);

  RefPtr<PathBuilder> builder = mDrawTarget->CreatePathBuilder();
  size_t segmentCount = 0;
  const Float AA_MARGIN = 2.0f;
  Rect marginedDirtyRect = mDirtyRect;
  marginedDirtyRect.Inflate(AA_MARGIN);
  Rect pathRect;
  bool entered = false;
  while (finder.HasMore()) {
    if (segmentCount > BORDER_SEGMENT_COUNT_MAX) {
      RefPtr<Path> path = builder->Finish();
      mDrawTarget->Fill(path, ColorPattern(ToDeviceColor(borderColor)));
      builder = mDrawTarget->CreatePathBuilder();
      segmentCount = 0;
    }

    DashedCornerFinder::Result result = finder.Next();

    if (DashedPathOverlapsRect(pathRect, marginedDirtyRect, result)) {
      entered = true;
      builder->MoveTo(result.outerSectionBezier.mPoints[0]);
      builder->BezierTo(result.outerSectionBezier.mPoints[1],
                        result.outerSectionBezier.mPoints[2],
                        result.outerSectionBezier.mPoints[3]);
      builder->LineTo(result.innerSectionBezier.mPoints[3]);
      builder->BezierTo(result.innerSectionBezier.mPoints[2],
                        result.innerSectionBezier.mPoints[1],
                        result.innerSectionBezier.mPoints[0]);
      builder->LineTo(result.outerSectionBezier.mPoints[0]);
      segmentCount++;
    } else if (entered) {
      break;
    }
  }

  if (outerBezier.mPoints[0].x != innerBezier.mPoints[0].x) {
    // Fill gap before the first section.
    //
    //     outnerPoint[0]
    //         |
    //         v
    //        _+-----------+--
    //      /   \##########|
    //    /      \#########|
    //   +        \########|
    //   |\         \######|
    //   |  \        \#####|
    //   |    \       \####|
    //   |      \       \##|
    //   |        \      \#|
    //   |          \     \|
    //   |            \  _-+--
    //   +--------------+  ^
    //   |              |  |
    //   |              |  innerPoint[0]
    //   |              |
    builder->MoveTo(outerBezier.mPoints[0]);
    builder->LineTo(innerBezier.mPoints[0]);
    builder->LineTo(Point(innerBezier.mPoints[0].x, outerBezier.mPoints[0].y));
    builder->LineTo(outerBezier.mPoints[0]);
  }

  if (outerBezier.mPoints[3].y != innerBezier.mPoints[3].y) {
    // Fill gap after the last section.
    //
    // outnerPoint[3]
    //   |
    //   |
    //   |    _+-----------+--
    //   |  /   \          |
    //   v/      \         |
    //   +        \        |
    //   |\         \      |
    //   |##\        \     |
    //   |####\       \    |
    //   |######\       \  |
    //   |########\      \ |
    //   |##########\     \|
    //   |############\  _-+--
    //   +--------------+<-- innerPoint[3]
    //   |              |
    //   |              |
    //   |              |
    builder->MoveTo(outerBezier.mPoints[3]);
    builder->LineTo(innerBezier.mPoints[3]);
    builder->LineTo(Point(outerBezier.mPoints[3].x, innerBezier.mPoints[3].y));
    builder->LineTo(outerBezier.mPoints[3]);
  }

  RefPtr<Path> path = builder->Finish();
  mDrawTarget->Fill(path, ColorPattern(ToDeviceColor(borderColor)));
}

void
nsCSSBorderRenderer::DrawFallbackSolidCorner(mozilla::css::Side aSide,
                                             mozilla::css::Corner aCorner)
{
  // Render too large dashed or dotted corner with solid style, to avoid hangup
  // inside DashedCornerFinder and DottedCornerFinder.

  NS_ASSERTION(mBorderStyles[aSide] == NS_STYLE_BORDER_STYLE_DASHED ||
               mBorderStyles[aSide] == NS_STYLE_BORDER_STYLE_DOTTED,
               "Style should be dashed or dotted.");

  nscolor borderColor = mBorderColors[aSide];
  Bezier outerBezier;
  Bezier innerBezier;
  GetOuterAndInnerBezier(&outerBezier, &innerBezier, aCorner);

  RefPtr<PathBuilder> builder = mDrawTarget->CreatePathBuilder();

  builder->MoveTo(outerBezier.mPoints[0]);
  builder->BezierTo(outerBezier.mPoints[1],
                    outerBezier.mPoints[2],
                    outerBezier.mPoints[3]);
  builder->LineTo(innerBezier.mPoints[3]);
  builder->BezierTo(innerBezier.mPoints[2],
                    innerBezier.mPoints[1],
                    innerBezier.mPoints[0]);
  builder->LineTo(outerBezier.mPoints[0]);

  RefPtr<Path> path = builder->Finish();
  mDrawTarget->Fill(path, ColorPattern(ToDeviceColor(borderColor)));

  if (mDocument) {
    if (!mPresContext->HasWarnedAboutTooLargeDashedOrDottedRadius()) {
      mPresContext->SetHasWarnedAboutTooLargeDashedOrDottedRadius();
      nsContentUtils::ReportToConsole(nsIScriptError::warningFlag,
                                      NS_LITERAL_CSTRING("CSS"),
                                      mDocument,
                                      nsContentUtils::eCSS_PROPERTIES,
                                      mBorderStyles[aSide] == NS_STYLE_BORDER_STYLE_DASHED
                                      ? "TooLargeDashedRadius"
                                      : "TooLargeDottedRadius");
    }
  }
}

bool
nsCSSBorderRenderer::AllBordersSameWidth()
{
  if (mBorderWidths[0] == mBorderWidths[1] &&
      mBorderWidths[0] == mBorderWidths[2] &&
      mBorderWidths[0] == mBorderWidths[3])
  {
    return true;
  }

  return false;
}

bool
nsCSSBorderRenderer::AllBordersSolid(bool *aHasCompositeColors)
{
  *aHasCompositeColors = false;
  NS_FOR_CSS_SIDES(i) {
    if (mCompositeColors[i] != nullptr) {
      *aHasCompositeColors = true;
    }
    if (mBorderStyles[i] == NS_STYLE_BORDER_STYLE_SOLID ||
        mBorderStyles[i] == NS_STYLE_BORDER_STYLE_NONE ||
        mBorderStyles[i] == NS_STYLE_BORDER_STYLE_HIDDEN)
    {
      continue;
    }
    return false;
  }

  return true;
}

bool IsVisible(int aStyle)
{
  if (aStyle != NS_STYLE_BORDER_STYLE_NONE &&
      aStyle != NS_STYLE_BORDER_STYLE_HIDDEN) {
        return true;
  }
  return false;
}

struct twoFloats
{
    Float a, b;

    twoFloats operator*(const Size& aSize) const {
      return { a * aSize.width, b * aSize.height };
    }

    twoFloats operator*(Float aScale) const {
      return { a * aScale, b * aScale };
    }

    twoFloats operator+(const Point& aPoint) const {
      return { a + aPoint.x, b + aPoint.y };
    }

    operator Point() const {
      return Point(a, b);
    }
};

void
nsCSSBorderRenderer::DrawSingleWidthSolidBorder()
{
  // Easy enough to deal with.
  Rect rect = mOuterRect;
  rect.Deflate(0.5);

  const twoFloats cornerAdjusts[4] = { { +0.5,  0   },
                                       {    0, +0.5 },
                                       { -0.5,  0   },
                                       {    0, -0.5 } };
  NS_FOR_CSS_SIDES(side) {
    Point firstCorner = rect.CCWCorner(side) + cornerAdjusts[side];
    Point secondCorner = rect.CWCorner(side) + cornerAdjusts[side];

    ColorPattern color(ToDeviceColor(mBorderColors[side]));

    mDrawTarget->StrokeLine(firstCorner, secondCorner, color);
  }
}

// Intersect a ray from the inner corner to the outer corner
// with the border radius, yielding the intersection point.
static Point
IntersectBorderRadius(const Point& aCenter, const Size& aRadius,
                      const Point& aInnerCorner,
                      const Point& aCornerDirection)
{
  Point toCorner = aCornerDirection;
  // transform to-corner ray to unit-circle space
  toCorner.x /= aRadius.width;
  toCorner.y /= aRadius.height;
  // normalize to-corner ray
  Float cornerDist = toCorner.Length();
  if (cornerDist < 1.0e-6f) {
    return aInnerCorner;
  }
  toCorner = toCorner / cornerDist;
  // ray from inner corner to border radius center
  Point toCenter = aCenter - aInnerCorner;
  // transform to-center ray to unit-circle space
  toCenter.x /= aRadius.width;
  toCenter.y /= aRadius.height;
  // compute offset of intersection with border radius unit circle
  Float offset = toCenter.DotProduct(toCorner);
  // compute discriminant to check for intersections
  Float discrim = 1.0f - toCenter.DotProduct(toCenter) + offset * offset;
  // choose farthest intersection
  offset += sqrtf(std::max(discrim, 0.0f));
  // transform to-corner ray back out of unit-circle space
  toCorner.x *= aRadius.width;
  toCorner.y *= aRadius.height;
  return aInnerCorner + toCorner * offset;
}

// Calculate the split point and split angle for a border radius with
// differing sides.
static inline void
SplitBorderRadius(const Point& aCenter, const Size& aRadius,
                  const Point& aOuterCorner, const Point& aInnerCorner,
                  const twoFloats& aCornerMults, Float aStartAngle,
                  Point& aSplit, Float& aSplitAngle)
{
  Point cornerDir = aOuterCorner - aInnerCorner;
  if (cornerDir.x == cornerDir.y && aRadius.IsSquare()) {
    // optimize 45-degree intersection with circle since we can assume
    // the circle center lies along the intersection edge
    aSplit = aCenter - aCornerMults * (aRadius * Float(1.0f / M_SQRT2));
    aSplitAngle = aStartAngle + 0.5f * M_PI / 2.0f;
  } else {
    aSplit = IntersectBorderRadius(aCenter, aRadius, aInnerCorner, cornerDir);
    aSplitAngle =
      atan2f((aSplit.y - aCenter.y) / aRadius.height,
             (aSplit.x - aCenter.x) / aRadius.width);
  }
}

// Compute the size of the skirt needed, given the color alphas
// of each corner side and the slope between them.
static void
ComputeCornerSkirtSize(Float aAlpha1, Float aAlpha2,
                       Float aSlopeY, Float aSlopeX,
                       Float& aSizeResult, Float& aSlopeResult)
{
  // If either side is (almost) invisible or there is no diagonal edge,
  // then don't try to render a skirt.
  if (aAlpha1 < 0.01f || aAlpha2 < 0.01f) {
    return;
  }
  aSlopeX = fabs(aSlopeX);
  aSlopeY = fabs(aSlopeY);
  if (aSlopeX < 1.0e-6f || aSlopeY < 1.0e-6f) {
    return;
  }

  // If first and second color don't match, we need to split the corner in
  // half. The diagonal edges created may not have full pixel coverage given
  // anti-aliasing, so we need to compute a small subpixel skirt edge. This
  // assumes each half has half coverage to start with, and that coverage
  // increases as the skirt is pushed over, with the end result that we want
  // to roughly preserve the alpha value along this edge.
  // Given slope m, alphas a and A, use quadratic formula to solve for S in:
  //   a*(1 - 0.5*(1-S)*(1-mS))*(1 - 0.5*A) + 0.5*A = A
  // yielding:
  //   S = ((1+m) - sqrt((1+m)*(1+m) + 4*m*(1 - A/(a*(1-0.5*A))))) / (2*m)
  // and substitute k = (1+m)/(2*m):
  //   S = k - sqrt(k*k + (1 - A/(a*(1-0.5*A)))/m)
  Float slope = aSlopeY / aSlopeX;
  Float slopeScale = (1.0f + slope) / (2.0f * slope);
  Float discrim =
    slopeScale*slopeScale +
      (1 - aAlpha2 / (aAlpha1 * (1.0f - 0.49f * aAlpha2))) / slope;
  if (discrim >= 0) {
    aSizeResult = slopeScale - sqrtf(discrim);
    aSlopeResult = slope;
  }
}

// Draws a border radius with possibly different sides.
// A skirt is drawn underneath the corner intersection to hide possible
// seams when anti-aliased drawing is used.
static void
DrawBorderRadius(DrawTarget* aDrawTarget,
                 mozilla::css::Corner c,
                 const Point& aOuterCorner, const Point& aInnerCorner,
                 const twoFloats& aCornerMultPrev, const twoFloats& aCornerMultNext,
                 const Size& aCornerDims,
                 const Size& aOuterRadius, const Size& aInnerRadius,
                 const Color& aFirstColor, const Color& aSecondColor,
                 Float aSkirtSize, Float aSkirtSlope)
{
  // Connect edge to outer arc start point
  Point outerCornerStart = aOuterCorner + aCornerMultPrev * aCornerDims;
  // Connect edge to outer arc end point
  Point outerCornerEnd = aOuterCorner + aCornerMultNext * aCornerDims;
  // Connect edge to inner arc start point
  Point innerCornerStart =
    outerCornerStart +
      aCornerMultNext * (aCornerDims - aInnerRadius);
  // Connect edge to inner arc end point
  Point innerCornerEnd =
    outerCornerEnd +
      aCornerMultPrev * (aCornerDims - aInnerRadius);

  // Outer arc start point
  Point outerArcStart = aOuterCorner + aCornerMultPrev * aOuterRadius;
  // Outer arc end point
  Point outerArcEnd = aOuterCorner + aCornerMultNext * aOuterRadius;
  // Inner arc start point
  Point innerArcStart = aInnerCorner + aCornerMultPrev * aInnerRadius;
  // Inner arc end point
  Point innerArcEnd = aInnerCorner + aCornerMultNext * aInnerRadius;

  // Outer radius center
  Point outerCenter = aOuterCorner + (aCornerMultPrev + aCornerMultNext) * aOuterRadius;
  // Inner radius center
  Point innerCenter = aInnerCorner + (aCornerMultPrev + aCornerMultNext) * aInnerRadius;

  RefPtr<PathBuilder> builder;
  RefPtr<Path> path;

  if (aFirstColor.a > 0) {
    builder = aDrawTarget->CreatePathBuilder();
    builder->MoveTo(outerCornerStart);
  }

  if (aFirstColor != aSecondColor) {
    // Start and end angles of corner quadrant
    Float startAngle = (c * M_PI) / 2.0f - M_PI,
          endAngle = startAngle + M_PI / 2.0f,
          outerSplitAngle, innerSplitAngle;
    Point outerSplit, innerSplit;

    // Outer half-way point
    SplitBorderRadius(outerCenter, aOuterRadius, aOuterCorner, aInnerCorner,
                      aCornerMultPrev + aCornerMultNext, startAngle,
                      outerSplit, outerSplitAngle);
    // Inner half-way point
    if (aInnerRadius.IsEmpty()) {
      innerSplit = aInnerCorner;
      innerSplitAngle = endAngle;
    } else {
      SplitBorderRadius(innerCenter, aInnerRadius, aOuterCorner, aInnerCorner,
                        aCornerMultPrev + aCornerMultNext, startAngle,
                        innerSplit, innerSplitAngle);
    }

    // Draw first half with first color
    if (aFirstColor.a > 0) {
      AcuteArcToBezier(builder.get(), outerCenter, aOuterRadius,
                       outerArcStart, outerSplit, startAngle, outerSplitAngle);
      // Draw skirt as part of first half
      if (aSkirtSize > 0) {
        builder->LineTo(outerSplit + aCornerMultNext * aSkirtSize);
        builder->LineTo(innerSplit - aCornerMultPrev * (aSkirtSize * aSkirtSlope));
      }
      AcuteArcToBezier(builder.get(), innerCenter, aInnerRadius,
                       innerSplit, innerArcStart, innerSplitAngle, startAngle);
      if ((innerCornerStart - innerArcStart).DotProduct(aCornerMultPrev) > 0) {
        builder->LineTo(innerCornerStart);
      }
      builder->Close();
      path = builder->Finish();
      aDrawTarget->Fill(path, ColorPattern(aFirstColor));
    }

    // Draw second half with second color
    if (aSecondColor.a > 0) {
      builder = aDrawTarget->CreatePathBuilder();
      builder->MoveTo(outerCornerEnd);
      if ((innerArcEnd - innerCornerEnd).DotProduct(aCornerMultNext) < 0) {
        builder->LineTo(innerCornerEnd);
      }
      AcuteArcToBezier(builder.get(), innerCenter, aInnerRadius,
                       innerArcEnd, innerSplit, endAngle, innerSplitAngle);
      AcuteArcToBezier(builder.get(), outerCenter, aOuterRadius,
                       outerSplit, outerArcEnd, outerSplitAngle, endAngle);
      builder->Close();
      path = builder->Finish();
      aDrawTarget->Fill(path, ColorPattern(aSecondColor));
    }
  } else if (aFirstColor.a > 0) {
    // Draw corner with single color
    AcuteArcToBezier(builder.get(), outerCenter, aOuterRadius,
                     outerArcStart, outerArcEnd);
    builder->LineTo(outerCornerEnd);
    if ((innerArcEnd - innerCornerEnd).DotProduct(aCornerMultNext) < 0) {
      builder->LineTo(innerCornerEnd);
    }
    AcuteArcToBezier(builder.get(), innerCenter, aInnerRadius,
                     innerArcEnd, innerArcStart, -kKappaFactor);
    if ((innerCornerStart - innerArcStart).DotProduct(aCornerMultPrev) > 0) {
      builder->LineTo(innerCornerStart);
    }
    builder->Close();
    path = builder->Finish();
    aDrawTarget->Fill(path, ColorPattern(aFirstColor));
  }
}

// Draw a corner with possibly different sides.
// A skirt is drawn underneath the corner intersection to hide possible
// seams when anti-aliased drawing is used.
static void
DrawCorner(DrawTarget* aDrawTarget,
           const Point& aOuterCorner, const Point& aInnerCorner,
           const twoFloats& aCornerMultPrev, const twoFloats& aCornerMultNext,
           const Size& aCornerDims,
           const Color& aFirstColor, const Color& aSecondColor,
           Float aSkirtSize, Float aSkirtSlope)
{
  // Corner box start point
  Point cornerStart = aOuterCorner + aCornerMultPrev * aCornerDims;
  // Corner box end point
  Point cornerEnd = aOuterCorner + aCornerMultNext * aCornerDims;

  RefPtr<PathBuilder> builder;
  RefPtr<Path> path;

  if (aFirstColor.a > 0) {
    builder = aDrawTarget->CreatePathBuilder();
    builder->MoveTo(cornerStart);
  }

  if (aFirstColor != aSecondColor) {
    // Draw first half with first color
    if (aFirstColor.a > 0) {
      builder->LineTo(aOuterCorner);
      // Draw skirt as part of first half
      if (aSkirtSize > 0) {
        builder->LineTo(aOuterCorner + aCornerMultNext * aSkirtSize);
        builder->LineTo(aInnerCorner - aCornerMultPrev * (aSkirtSize * aSkirtSlope));
      }
      builder->LineTo(aInnerCorner);
      builder->Close();
      path = builder->Finish();
      aDrawTarget->Fill(path, ColorPattern(aFirstColor));
    }

    // Draw second half with second color
    if (aSecondColor.a > 0) {
      builder = aDrawTarget->CreatePathBuilder();
      builder->MoveTo(cornerEnd);
      builder->LineTo(aInnerCorner);
      builder->LineTo(aOuterCorner);
      builder->Close();
      path = builder->Finish();
      aDrawTarget->Fill(path, ColorPattern(aSecondColor));
    }
  } else if (aFirstColor.a > 0) {
    // Draw corner with single color
    builder->LineTo(aOuterCorner);
    builder->LineTo(cornerEnd);
    builder->LineTo(aInnerCorner);
    builder->Close();
    path = builder->Finish();
    aDrawTarget->Fill(path, ColorPattern(aFirstColor));
  }
}

void
nsCSSBorderRenderer::DrawNoCompositeColorSolidBorder()
{
  const twoFloats cornerMults[4] = { { -1,  0 },
                                     {  0, -1 },
                                     { +1,  0 },
                                     {  0, +1 } };

  const twoFloats centerAdjusts[4] = { { 0, +0.5 },
                                       { -0.5, 0 },
                                       { 0, -0.5 },
                                       { +0.5, 0 } };

  RectCornerRadii innerRadii;
  ComputeInnerRadii(mBorderRadii, mBorderWidths, &innerRadii);

  Rect strokeRect = mOuterRect;
  strokeRect.Deflate(Margin(mBorderWidths[0] / 2.0, mBorderWidths[1] / 2.0,
                            mBorderWidths[2] / 2.0, mBorderWidths[3] / 2.0));

  NS_FOR_CSS_SIDES(i) {
    // We now draw the current side and the CW corner following it.
    // The CCW corner of this side was already drawn in the previous iteration.
    // The side will be drawn as an explicit stroke, and the CW corner will be
    // filled separately.
    // If the next side does not have a matching color, then we split the
    // corner into two halves, one of each side's color and draw both.
    // Thus, the CCW corner of the next side will end up drawn here.

    // the corner index -- either 1 2 3 0 (cw) or 0 3 2 1 (ccw)
    mozilla::css::Corner c = mozilla::css::Corner((i+1) % 4);
    mozilla::css::Corner prevCorner = mozilla::css::Corner(i);

    // i+2 and i+3 respectively.  These are used to index into the corner
    // multiplier table, and were deduced by calculating out the long form
    // of each corner and finding a pattern in the signs and values.
    int i1 = (i+1) % 4;
    int i2 = (i+2) % 4;
    int i3 = (i+3) % 4;

    Float sideWidth = 0.0f;
    Color firstColor, secondColor;
    if (IsVisible(mBorderStyles[i]) && mBorderWidths[i]) {
      // draw the side since it is visible
      sideWidth = mBorderWidths[i];
      firstColor = ToDeviceColor(mBorderColors[i]);
      // if the next side is visible, use its color for corner
      secondColor =
        IsVisible(mBorderStyles[i1]) && mBorderWidths[i1] ?
          ToDeviceColor(mBorderColors[i1]) :
          firstColor;
    } else if (IsVisible(mBorderStyles[i1]) && mBorderWidths[i1]) {
      // assign next side's color to both corner sides
      firstColor = ToDeviceColor(mBorderColors[i1]);
      secondColor = firstColor;
    } else {
      // neither side is visible, so nothing to do
      continue;
    }

    Point outerCorner = mOuterRect.AtCorner(c);
    Point innerCorner = mInnerRect.AtCorner(c);

    // start and end points of border side stroke between corners
    Point sideStart =
      mOuterRect.AtCorner(prevCorner) +
        cornerMults[i2] * mBorderCornerDimensions[prevCorner];
    Point sideEnd = outerCorner + cornerMults[i] * mBorderCornerDimensions[c];
    // check if the side is visible and not inverted
    if (sideWidth > 0 && firstColor.a > 0 &&
        -(sideEnd - sideStart).DotProduct(cornerMults[i]) > 0) {
      mDrawTarget->StrokeLine(sideStart + centerAdjusts[i] * sideWidth,
                              sideEnd + centerAdjusts[i] * sideWidth,
                              ColorPattern(firstColor),
                              StrokeOptions(sideWidth));
    }

    Float skirtSize = 0.0f, skirtSlope = 0.0f;
    // the sides don't match, so compute a skirt
    if (firstColor != secondColor &&
        mPresContext->Type() != nsPresContext::eContext_Print) {
      Point cornerDir = outerCorner - innerCorner;
      ComputeCornerSkirtSize(firstColor.a, secondColor.a,
                             cornerDir.DotProduct(cornerMults[i]),
                             cornerDir.DotProduct(cornerMults[i3]),
                             skirtSize, skirtSlope);
    }

    if (!mBorderRadii[c].IsEmpty()) {
      // the corner has a border radius
      DrawBorderRadius(mDrawTarget,
                       c, outerCorner, innerCorner,
                       cornerMults[i], cornerMults[i3],
                       mBorderCornerDimensions[c],
                       mBorderRadii[c], innerRadii[c],
                       firstColor, secondColor, skirtSize, skirtSlope);
    } else if (!mBorderCornerDimensions[c].IsEmpty()) {
      // a corner with no border radius
      DrawCorner(mDrawTarget,
                 outerCorner, innerCorner,
                 cornerMults[i], cornerMults[i3],
                 mBorderCornerDimensions[c],
                 firstColor, secondColor, skirtSize, skirtSlope);
    }
  }
}

void
nsCSSBorderRenderer::DrawRectangularCompositeColors()
{
  nsBorderColors *currentColors[4];
  memcpy(currentColors, mCompositeColors, sizeof(nsBorderColors*) * 4);
  Rect rect = mOuterRect;
  rect.Deflate(0.5);

  const twoFloats cornerAdjusts[4] = { { +0.5,  0   },
                                        {    0, +0.5 },
                                        { -0.5,  0   },
                                        {    0, -0.5 } };

  for (int i = 0; i < mBorderWidths[0]; i++) {
    NS_FOR_CSS_SIDES(side) {
      int sideNext = (side + 1) % 4;

      Point firstCorner = rect.CCWCorner(side) + cornerAdjusts[side];
      Point secondCorner = rect.CWCorner(side) - cornerAdjusts[side];

      Color currentColor = Color::FromABGR(
        currentColors[side] ? currentColors[side]->mColor
                            : mBorderColors[side]);

      mDrawTarget->StrokeLine(firstCorner, secondCorner,
                              ColorPattern(ToDeviceColor(currentColor)));

      Point cornerTopLeft = rect.CWCorner(side) - Point(0.5, 0.5);
      Color nextColor = Color::FromABGR(
        currentColors[sideNext] ? currentColors[sideNext]->mColor
                                : mBorderColors[sideNext]);

      Color cornerColor((currentColor.r + nextColor.r) / 2.f,
                        (currentColor.g + nextColor.g) / 2.f,
                        (currentColor.b + nextColor.b) / 2.f,
                        (currentColor.a + nextColor.a) / 2.f);
      mDrawTarget->FillRect(Rect(cornerTopLeft, Size(1, 1)),
                            ColorPattern(ToDeviceColor(cornerColor)));

      if (side != 0) {
        // We'll have to keep side 0 for the color averaging on side 3.
        if (currentColors[side] && currentColors[side]->mNext) {
          currentColors[side] = currentColors[side]->mNext;
        }
      }
    }
    // Now advance the color for side 0.
    if (currentColors[0] && currentColors[0]->mNext) {
      currentColors[0] = currentColors[0]->mNext;
    }
    rect.Deflate(1);
  }
}

void
nsCSSBorderRenderer::DrawBorders()
{
  bool forceSeparateCorners = false;

  // Examine the border style to figure out if we can draw it in one
  // go or not.
  bool tlBordersSame = AreBorderSideFinalStylesSame(SIDE_BIT_TOP | SIDE_BIT_LEFT);
  bool brBordersSame = AreBorderSideFinalStylesSame(SIDE_BIT_BOTTOM | SIDE_BIT_RIGHT);
  bool allBordersSame = AreBorderSideFinalStylesSame(SIDE_BITS_ALL);
  if (allBordersSame &&
      ((mCompositeColors[0] == nullptr &&
       (mBorderStyles[0] == NS_STYLE_BORDER_STYLE_NONE ||
        mBorderStyles[0] == NS_STYLE_BORDER_STYLE_HIDDEN ||
        mBorderColors[0] == NS_RGBA(0,0,0,0))) ||
       (mCompositeColors[0] &&
        (mCompositeColors[0]->mColor == NS_RGBA(0,0,0,0) &&
         !mCompositeColors[0]->mNext))))
  {
    // All borders are the same style, and the style is either none or hidden, or the color
    // is transparent.
    // This also checks if the first composite color is transparent, and there are
    // no others. It doesn't check if there are subsequent transparent ones, because
    // that would be very silly.
    return;
  }

  AutoRestoreTransform autoRestoreTransform;
  Matrix mat = mDrawTarget->GetTransform();

  // Clamp the CTM to be pixel-aligned; we do this only
  // for translation-only matrices now, but we could do it
  // if the matrix has just a scale as well.  We should not
  // do it if there's a rotation.
  if (mat.HasNonTranslation()) {
    if (!mat.HasNonAxisAlignedTransform()) {
      // Scale + transform. Avoid stroke fast-paths so that we have a chance
      // of snapping to pixel boundaries.
      mAvoidStroke = true;
    }
  } else {
    mat._31 = floor(mat._31 + 0.5);
    mat._32 = floor(mat._32 + 0.5);
    autoRestoreTransform.Init(mDrawTarget);
    mDrawTarget->SetTransform(mat);

    // round mOuterRect and mInnerRect; they're already an integer
    // number of pixels apart and should stay that way after
    // rounding. We don't do this if there's a scale in the current transform
    // since this loses information that might be relevant when we're scaling.
    mOuterRect.Round();
    mInnerRect.Round();
  }

  bool allBordersSameWidth = AllBordersSameWidth();

  if (allBordersSameWidth && mBorderWidths[0] == 0.0) {
    // Some of the allBordersSameWidth codepaths depend on the border
    // width being greater than zero.
    return;
  }

  // Initial values only used when the border colors/widths are all the same:
  ColorPattern color(ToDeviceColor(mBorderColors[NS_SIDE_TOP]));
  StrokeOptions strokeOptions(mBorderWidths[NS_SIDE_TOP]); // stroke width

  bool allBordersSolid;

  // First there's a couple of 'special cases' that have specifically optimized
  // drawing paths, when none of these can be used we move on to the generalized
  // border drawing code.
  if (allBordersSame &&
      mCompositeColors[0] == nullptr &&
      allBordersSameWidth &&
      mBorderStyles[0] == NS_STYLE_BORDER_STYLE_SOLID &&
      mNoBorderRadius &&
      !mAvoidStroke)
  {
    // Very simple case.
    Rect rect = mOuterRect;
    rect.Deflate(mBorderWidths[0] / 2.0);
    mDrawTarget->StrokeRect(rect, color, strokeOptions);
    return;
  }

  if (allBordersSame &&
      mCompositeColors[0] == nullptr &&
      mBorderStyles[0] == NS_STYLE_BORDER_STYLE_SOLID &&
      !mAvoidStroke &&
      !mNoBorderRadius)
  {
    // Relatively simple case.
    gfxRect outerRect = ThebesRect(mOuterRect);
    RoundedRect borderInnerRect(outerRect, mBorderRadii);
    borderInnerRect.Deflate(mBorderWidths[NS_SIDE_TOP],
                            mBorderWidths[NS_SIDE_BOTTOM],
                            mBorderWidths[NS_SIDE_LEFT],
                            mBorderWidths[NS_SIDE_RIGHT]);

    // Instead of stroking we just use two paths: an inner and an outer.
    // This allows us to draw borders that we couldn't when stroking. For example,
    // borders with a border width >= the border radius. (i.e. when there are
    // square corners on the inside)
    //
    // Further, this approach can be more efficient because the backend
    // doesn't need to compute an offset curve to stroke the path. We know that
    // the rounded parts are elipses we can offset exactly and can just compute
    // a new cubic approximation.
    RefPtr<PathBuilder> builder = mDrawTarget->CreatePathBuilder();
    AppendRoundedRectToPath(builder, mOuterRect, mBorderRadii, true);
    AppendRoundedRectToPath(builder, ToRect(borderInnerRect.rect), borderInnerRect.corners, false);
    RefPtr<Path> path = builder->Finish();
    mDrawTarget->Fill(path, color);
    return;
  }

  bool hasCompositeColors;

  allBordersSolid = AllBordersSolid(&hasCompositeColors);
  // This leaves the border corners non-interpolated for single width borders.
  // Doing this is slightly faster and shouldn't be a problem visually.
  if (allBordersSolid &&
      allBordersSameWidth &&
      mCompositeColors[0] == nullptr &&
      mBorderWidths[0] == 1 &&
      mNoBorderRadius &&
      !mAvoidStroke)
  {
    DrawSingleWidthSolidBorder();
    return;
  }

  if (allBordersSolid && !hasCompositeColors &&
      !mAvoidStroke)
  {
    DrawNoCompositeColorSolidBorder();
    return;
  }

  if (allBordersSolid &&
      allBordersSameWidth &&
      mNoBorderRadius &&
      !mAvoidStroke)
  {
    // Easy enough to deal with.
    DrawRectangularCompositeColors();
    return;
  }

  // If we have composite colors -and- border radius,
  // then use separate corners so we get OP_ADD for the corners.
  // Otherwise, we'll get artifacts as we draw stacked 1px-wide curves.
  if (allBordersSame && mCompositeColors[0] != nullptr && !mNoBorderRadius)
    forceSeparateCorners = true;

  PrintAsString(" mOuterRect: "), PrintAsString(mOuterRect), PrintAsStringNewline();
  PrintAsString(" mInnerRect: "), PrintAsString(mInnerRect), PrintAsStringNewline();
  PrintAsFormatString(" mBorderColors: 0x%08x 0x%08x 0x%08x 0x%08x\n", mBorderColors[0], mBorderColors[1], mBorderColors[2], mBorderColors[3]);

  // if conditioning the outside rect failed, then bail -- the outside
  // rect is supposed to enclose the entire border
  {
    gfxRect outerRect = ThebesRect(mOuterRect);
    outerRect.Condition();
    if (outerRect.IsEmpty())
      return;
    mOuterRect = ToRect(outerRect);

    gfxRect innerRect = ThebesRect(mInnerRect);
    innerRect.Condition();
    mInnerRect = ToRect(innerRect);
  }

  int dashedSides = 0;

  NS_FOR_CSS_SIDES(i) {
    uint8_t style = mBorderStyles[i];
    if (style == NS_STYLE_BORDER_STYLE_DASHED ||
        style == NS_STYLE_BORDER_STYLE_DOTTED)
    {
      // pretend that all borders aren't the same; we need to draw
      // things separately for dashed/dotting
      allBordersSame = false;
      dashedSides |= (1 << i);
    }
  }

  PrintAsFormatString(" allBordersSame: %d dashedSides: 0x%02x\n", allBordersSame, dashedSides);

  if (allBordersSame && !forceSeparateCorners) {
    /* Draw everything in one go */
    DrawBorderSides(SIDE_BITS_ALL);
    PrintAsStringNewline("---------------- (1)");
  } else {
    PROFILER_LABEL("nsCSSBorderRenderer", "DrawBorders::multipass",
      js::ProfileEntry::Category::GRAPHICS);

    /* We have more than one pass to go.  Draw the corners separately from the sides. */

    /*
     * If we have a 1px-wide border, the corners are going to be
     * negligible, so don't bother doing anything fancy.  Just extend
     * the top and bottom borders to the right 1px and the left border
     * to the bottom 1px.  We do this by twiddling the corner dimensions,
     * which causes the right to happen later on.  Only do this if we have
     * a 1.0 unit border all around and no border radius.
     */

    NS_FOR_CSS_CORNERS(corner) {
      const mozilla::css::Side sides[2] = { mozilla::css::Side(corner), PREV_SIDE(corner) };

      if (!IsZeroSize(mBorderRadii[corner]))
        continue;

      if (mBorderWidths[sides[0]] == 1.0 && mBorderWidths[sides[1]] == 1.0) {
        if (corner == NS_CORNER_TOP_LEFT || corner == NS_CORNER_TOP_RIGHT)
          mBorderCornerDimensions[corner].width = 0.0;
        else
          mBorderCornerDimensions[corner].height = 0.0;
      }
    }

    // First, the corners
    NS_FOR_CSS_CORNERS(corner) {
      // if there's no corner, don't do all this work for it
      if (IsZeroSize(mBorderCornerDimensions[corner]))
        continue;

      const int sides[2] = { corner, PREV_SIDE(corner) };
      int sideBits = (1 << sides[0]) | (1 << sides[1]);

      bool simpleCornerStyle = mCompositeColors[sides[0]] == nullptr &&
                                 mCompositeColors[sides[1]] == nullptr &&
                                 AreBorderSideFinalStylesSame(sideBits);

      // If we don't have anything complex going on in this corner,
      // then we can just fill the corner with a solid color, and avoid
      // the potentially expensive clip.
      if (simpleCornerStyle &&
          IsZeroSize(mBorderRadii[corner]) &&
          IsSolidCornerStyle(mBorderStyles[sides[0]], corner))
      {
        Color color = MakeBorderColor(mBorderColors[sides[0]],
                                      mBackgroundColor,
                                      BorderColorStyleForSolidCorner(mBorderStyles[sides[0]], corner));
        mDrawTarget->FillRect(GetCornerRect(corner),
                              ColorPattern(ToDeviceColor(color)));
        continue;
      }

      // clip to the corner
      mDrawTarget->PushClipRect(GetCornerRect(corner));

      if (simpleCornerStyle) {
        // we don't need a group for this corner, the sides are the same,
        // but we weren't able to render just a solid block for the corner.
        DrawBorderSides(sideBits);
      } else {
        // Sides are different.  We could draw using OP_ADD to
        // get correct color blending behaviour at the seam.  We'd need
        // to do it in an offscreen surface to ensure that we're
        // always compositing on transparent black.  If the colors
        // don't have transparency and the current destination surface
        // has an alpha channel, we could just clear the region and
        // avoid the temporary, but that situation doesn't happen all
        // that often in practice (we double buffer to no-alpha
        // surfaces). We choose just to seam though, as the performance
        // advantages outway the modest easthetic improvement.

        for (int cornerSide = 0; cornerSide < 2; cornerSide++) {
          mozilla::css::Side side = mozilla::css::Side(sides[cornerSide]);
          uint8_t style = mBorderStyles[side];

          PrintAsFormatString("corner: %d cornerSide: %d side: %d style: %d\n", corner, cornerSide, side, style);

          RefPtr<Path> path = GetSideClipSubPath(side);
          mDrawTarget->PushClip(path);

          DrawBorderSides(1 << side);

          mDrawTarget->PopClip();
        }
      }

      mDrawTarget->PopClip();

      PrintAsStringNewline();
    }

    // in the case of a single-unit border, we already munged the
    // corners up above; so we can just draw the top left and bottom
    // right sides separately, if they're the same.
    //
    // We need to check for mNoBorderRadius, because when there is
    // one, FillSolidBorder always draws the full rounded rectangle
    // and expects there to be a clip in place.
    int alreadyDrawnSides = 0;
    if (mOneUnitBorder &&
        mNoBorderRadius &&
        (dashedSides & (SIDE_BIT_TOP | SIDE_BIT_LEFT)) == 0)
    {
      if (tlBordersSame) {
        DrawBorderSides(SIDE_BIT_TOP | SIDE_BIT_LEFT);
        alreadyDrawnSides |= (SIDE_BIT_TOP | SIDE_BIT_LEFT);
      }

      if (brBordersSame && (dashedSides & (SIDE_BIT_BOTTOM | SIDE_BIT_RIGHT)) == 0) {
        DrawBorderSides(SIDE_BIT_BOTTOM | SIDE_BIT_RIGHT);
        alreadyDrawnSides |= (SIDE_BIT_BOTTOM | SIDE_BIT_RIGHT);
      }
    }

    // We're done with the corners, now draw the sides.
    NS_FOR_CSS_SIDES (side) {
      // if we drew it above, skip it
      if (alreadyDrawnSides & (1 << side))
        continue;

      // If there's no border on this side, skip it
      if (mBorderWidths[side] == 0.0 ||
          mBorderStyles[side] == NS_STYLE_BORDER_STYLE_HIDDEN ||
          mBorderStyles[side] == NS_STYLE_BORDER_STYLE_NONE)
        continue;


      if (dashedSides & (1 << side)) {
        // Dashed sides will always draw just the part ignoring the
        // corners for the side, so no need to clip.
        DrawDashedOrDottedSide(side);

        PrintAsStringNewline("---------------- (d)");
        continue;
      }

      // Undashed sides will currently draw the entire side,
      // including parts that would normally be covered by a corner,
      // so we need to clip.
      //
      // XXX Optimization -- it would be good to make this work like
      // DrawDashedOrDottedSide, and have a DrawOneSide function that just
      // draws one side and not the corners, because then we can
      // avoid the potentially expensive clip.
      mDrawTarget->PushClipRect(GetSideClipWithoutCornersRect(side));

      DrawBorderSides(1 << side);

      mDrawTarget->PopClip();

      PrintAsStringNewline("---------------- (*)");
    }
  }
}
