/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/*
 * structs that contain the data provided by nsStyleContext, the
 * internal API for computed style data for an element
 */

#ifndef nsStyleStruct_h___
#define nsStyleStruct_h___

#include "mozilla/ArenaObjectID.h"
#include "mozilla/Attributes.h"
#include "mozilla/CSSVariableValues.h"
#include "mozilla/Maybe.h"
#include "mozilla/SheetType.h"
#include "mozilla/StaticPtr.h"
#include "mozilla/StyleComplexColor.h"
#include "mozilla/StyleStructContext.h"
#include "mozilla/UniquePtr.h"
#include "nsColor.h"
#include "nsCoord.h"
#include "nsMargin.h"
#include "nsFont.h"
#include "nsStyleCoord.h"
#include "nsStyleConsts.h"
#include "nsChangeHint.h"
#include "nsPresContext.h"
#include "nsCOMPtr.h"
#include "nsCOMArray.h"
#include "nsTArray.h"
#include "nsCSSValue.h"
#include "imgRequestProxy.h"
#include "Orientation.h"
#include "CounterStyleManager.h"
#include <cstddef> // offsetof()
#include <utility>
#include "X11UndefineNone.h"

class nsIFrame;
class nsIURI;
class nsStyleContext;
class nsTextFrame;
class imgIContainer;
struct nsStyleVisibility;
namespace mozilla {
namespace dom {
class ImageTracker;
} // namespace dom
} // namespace mozilla

// Includes nsStyleStructID.
#include "nsStyleStructFwd.h"

// Bits for each struct.
// NS_STYLE_INHERIT_BIT defined in nsStyleStructFwd.h
#define NS_STYLE_INHERIT_MASK              0x000ffffff

// Bits for inherited structs.
#define NS_STYLE_INHERITED_STRUCT_MASK \
  ((nsStyleStructID_size_t(1) << nsStyleStructID_Inherited_Count) - 1)
// Bits for reset structs.
#define NS_STYLE_RESET_STRUCT_MASK \
  (((nsStyleStructID_size_t(1) << nsStyleStructID_Reset_Count) - 1) \
   << nsStyleStructID_Inherited_Count)

// Additional bits for nsStyleContext's mBits:
// See nsStyleContext::HasTextDecorationLines
#define NS_STYLE_HAS_TEXT_DECORATION_LINES 0x001000000
// See nsStyleContext::HasPseudoElementData.
#define NS_STYLE_HAS_PSEUDO_ELEMENT_DATA   0x002000000
// See nsStyleContext::RelevantLinkIsVisited
#define NS_STYLE_RELEVANT_LINK_VISITED     0x004000000
// See nsStyleContext::IsStyleIfVisited
#define NS_STYLE_IS_STYLE_IF_VISITED       0x008000000
// See nsStyleContext::HasChildThatUsesGrandancestorStyle
#define NS_STYLE_CHILD_USES_GRANDANCESTOR_STYLE 0x010000000
// See nsStyleContext::IsShared
#define NS_STYLE_IS_SHARED                 0x020000000
// See nsStyleContext::AssertStructsNotUsedElsewhere
// (This bit is currently only used in #ifdef DEBUG code.)
#define NS_STYLE_IS_GOING_AWAY             0x040000000
// See nsStyleContext::ShouldSuppressLineBreak
#define NS_STYLE_SUPPRESS_LINEBREAK        0x080000000
// See nsStyleContext::IsInDisplayNoneSubtree
#define NS_STYLE_IN_DISPLAY_NONE_SUBTREE   0x100000000
// See nsStyleContext::FindChildWithRules
#define NS_STYLE_INELIGIBLE_FOR_SHARING    0x200000000
// See nsStyleContext::HasChildThatUsesResetStyle
#define NS_STYLE_HAS_CHILD_THAT_USES_RESET_STYLE 0x400000000
// See nsStyleContext::IsTextCombined
#define NS_STYLE_IS_TEXT_COMBINED          0x800000000
// See nsStyleContext::GetPseudoEnum
#define NS_STYLE_CONTEXT_TYPE_SHIFT        36

// Additional bits for nsRuleNode's mDependentBits:
#define NS_RULE_NODE_IS_ANIMATION_RULE      0x01000000
// Free bit                                 0x02000000
#define NS_RULE_NODE_USED_DIRECTLY          0x04000000
#define NS_RULE_NODE_IS_IMPORTANT           0x08000000
#define NS_RULE_NODE_LEVEL_MASK             0xf0000000
#define NS_RULE_NODE_LEVEL_SHIFT            28

// Additional bits for nsRuleNode's mNoneBits:
#define NS_RULE_NODE_HAS_ANIMATION_DATA     0x80000000

static_assert(int(mozilla::SheetType::Count) - 1 <=
                (NS_RULE_NODE_LEVEL_MASK >> NS_RULE_NODE_LEVEL_SHIFT),
              "NS_RULE_NODE_LEVEL_MASK cannot fit SheetType");

static_assert(NS_STYLE_INHERIT_MASK == (1 << nsStyleStructID_Length) - 1,
              "NS_STYLE_INHERIT_MASK is not correct");

static_assert((NS_RULE_NODE_IS_ANIMATION_RULE & NS_STYLE_INHERIT_MASK) == 0,
  "NS_RULE_NODE_IS_ANIMATION_RULE must not overlap the style struct bits.");

namespace mozilla {

struct Position {
  using Coord = nsStyleCoord::CalcValue;

  Coord mXPosition, mYPosition;

  // Initialize nothing
  Position() {}

  // Sets both mXPosition and mYPosition to the given percent value for the
  // initial property-value (e.g. 0.0f for "0% 0%", or 0.5f for "50% 50%")
  void SetInitialPercentValues(float aPercentVal);

  // Sets both mXPosition and mYPosition to 0 (app units) for the
  // initial property-value as a length with no percentage component.
  void SetInitialZeroValues();

  // True if the effective background image position described by this depends
  // on the size of the corresponding frame.
  bool DependsOnPositioningAreaSize() const {
    return mXPosition.mPercent != 0.0f || mYPosition.mPercent != 0.0f;
  }

  bool operator==(const Position& aOther) const {
    return mXPosition == aOther.mXPosition &&
      mYPosition == aOther.mYPosition;
  }
  bool operator!=(const Position& aOther) const {
    return !(*this == aOther);
  }
};

} // namespace mozilla

// The lifetime of these objects is managed by the presshell's arena.
struct MOZ_NEEDS_MEMMOVABLE_MEMBERS nsStyleFont
{
  nsStyleFont(const nsFont& aFont, StyleStructContext aContext);
  nsStyleFont(const nsStyleFont& aStyleFont);
  explicit nsStyleFont(StyleStructContext aContext);
  ~nsStyleFont() {
    MOZ_COUNT_DTOR(nsStyleFont);
  }
  void FinishStyle(nsPresContext* aPresContext) {}

  nsChangeHint CalcDifference(const nsStyleFont& aNewData) const;
  static nsChangeHint MaxDifference() {
    return NS_STYLE_HINT_REFLOW |
           nsChangeHint_NeutralChange;
  }
  static nsChangeHint DifferenceAlwaysHandledForDescendants() {
    // CalcDifference never returns the reflow hints that are sometimes
    // handled for descendants as hints not handled for descendants.
    return nsChangeHint_NeedReflow |
           nsChangeHint_ReflowChangesSizeOrPosition |
           nsChangeHint_ClearAncestorIntrinsics;
  }

  /**
   * Return aSize multiplied by the current text zoom factor (in aPresContext).
   * aSize is allowed to be negative, but the caller is expected to deal with
   * negative results.  The result is clamped to nscoord_MIN .. nscoord_MAX.
   */
  static nscoord ZoomText(StyleStructContext aContext, nscoord aSize);
  /**
   * Return aSize divided by the current text zoom factor (in aPresContext).
   * aSize is allowed to be negative, but the caller is expected to deal with
   * negative results.  The result is clamped to nscoord_MIN .. nscoord_MAX.
   */
  static nscoord UnZoomText(nsPresContext* aPresContext, nscoord aSize);
  static already_AddRefed<nsIAtom> GetLanguage(StyleStructContext aPresContext);

  void* operator new(size_t sz, nsStyleFont* aSelf) { return aSelf; }
  void* operator new(size_t sz, nsPresContext* aContext) {
    return aContext->PresShell()->
      AllocateByObjectID(mozilla::eArenaObjectID_nsStyleFont, sz);
  }
  void Destroy(nsPresContext* aContext);

  void EnableZoom(nsPresContext* aContext, bool aEnable);

  nsFont  mFont;        // [inherited]
  nscoord mSize;        // [inherited] Our "computed size". Can be different
                        // from mFont.size which is our "actual size" and is
                        // enforced to be >= the user's preferred min-size.
                        // mFont.size should be used for display purposes
                        // while mSize is the value to return in
                        // getComputedStyle() for example.
  uint8_t mGenericID;   // [inherited] generic CSS font family, if any;
                        // value is a kGenericFont_* constant, see nsFont.h.

  // MathML scriptlevel support
  int8_t  mScriptLevel;          // [inherited]
  // MathML  mathvariant support
  uint8_t mMathVariant;          // [inherited]
  // MathML displaystyle support
  uint8_t mMathDisplay;         // [inherited]

  // allow different min font-size for certain cases
  uint8_t mMinFontSizeRatio;     // [inherited] percent * 100

  // was mLanguage set based on a lang attribute in the document?
  bool mExplicitLanguage;        // [inherited]

  // should calls to ZoomText() and UnZoomText() be made to the font
  // size on this nsStyleFont?
  bool mAllowZoom;               // [inherited]

  // The value mSize would have had if scriptminsize had never been applied
  nscoord mScriptUnconstrainedSize;
  nscoord mScriptMinSize;        // [inherited] length
  float   mScriptSizeMultiplier; // [inherited]
  nsCOMPtr<nsIAtom> mLanguage;   // [inherited]
};

struct nsStyleGradientStop
{
  nsStyleCoord mLocation; // percent, coord, calc, none
  nscolor mColor;
  bool mIsInterpolationHint;

  // Use ==/!= on nsStyleGradient instead of on the gradient stop.
  bool operator==(const nsStyleGradientStop&) const = delete;
  bool operator!=(const nsStyleGradientStop&) const = delete;
};

class nsStyleGradient final
{
public:
  nsStyleGradient();
  uint8_t mShape;  // NS_STYLE_GRADIENT_SHAPE_*
  uint8_t mSize;   // NS_STYLE_GRADIENT_SIZE_*;
                   // not used (must be FARTHEST_CORNER) for linear shape
  bool mRepeating;
  bool mLegacySyntax;

  nsStyleCoord mBgPosX; // percent, coord, calc, none
  nsStyleCoord mBgPosY; // percent, coord, calc, none
  nsStyleCoord mAngle;  // none, angle

  nsStyleCoord mRadiusX; // percent, coord, calc, none
  nsStyleCoord mRadiusY; // percent, coord, calc, none

  // stops are in the order specified in the stylesheet
  nsTArray<nsStyleGradientStop> mStops;

  bool operator==(const nsStyleGradient& aOther) const;
  bool operator!=(const nsStyleGradient& aOther) const {
    return !(*this == aOther);
  }

  bool IsOpaque();
  bool HasCalc();
  uint32_t Hash(PLDHashNumber aHash);

  NS_INLINE_DECL_THREADSAFE_REFCOUNTING(nsStyleGradient)

private:
  // Private destructor, to discourage deletion outside of Release():
  ~nsStyleGradient() {}

  nsStyleGradient(const nsStyleGradient& aOther) = delete;
  nsStyleGradient& operator=(const nsStyleGradient& aOther) = delete;
};

/**
 * A wrapper for an imgRequestProxy that supports off-main-thread creation
 * and equality comparison.
 *
 * An nsStyleImageRequest can be created in two ways:
 *
 * 1. Using the constructor that takes an imgRequestProxy.  This must
 *    be called from the main thread.  The nsStyleImageRequest is
 *    immediately considered "resolved", and the get() method that
 *    returns the imgRequestProxy can be called.
 *
 * 2. Using the constructor that takes the URL, base URI, referrer
 *    and principal that can be used to inititiate an image load and
 *    produce an imgRequestProxy later.  This can be called from
 *    any thread.  The nsStyleImageRequest is not considered "resolved"
 *    at this point, and the Resolve() method must be called later
 *    to initiate the image load and make calls to get() valid.
 *
 * Calls to TrackImage(), UntrackImage(), LockImage(), UnlockImage() and
 * RequestDiscard() are made to the imgRequestProxy and ImageTracker as
 * appropriate, according to the mode flags passed in to the constructor.
 *
 * The main thread constructor takes a pointer to the css::ImageValue that
 * is the specified url() value, while the off-main-thread constructor
 * creates a new css::ImageValue to represent the url() information passed
 * to the constructor.  This ImageValue is held on to for the comparisons done
 * in DefinitelyEquals(), so that we don't need to call into the non-OMT-safe
 * Equals() on the nsIURI objects returned from imgRequestProxy::GetURI().
 */
class nsStyleImageRequest
{
public:
  // Flags describing whether the imgRequestProxy must be tracked in the
  // ImageTracker, whether LockImage/UnlockImage calls will be made
  // when obtaining and releasing the imgRequestProxy, and whether
  // RequestDiscard will be called on release.
  enum class Mode : uint8_t {
    // The imgRequestProxy will be added to the ImageTracker when resolved
    // Without this flag, the nsStyleImageRequest itself will call LockImage/
    // UnlockImage on the imgRequestProxy, rather than leaving locking to the
    // ImageTracker to manage.
    //
    // This flag is currently used by all nsStyleImageRequests except
    // those for list-style-image and cursor.
    Track = 0x1,

    // The imgRequestProxy will have its RequestDiscard method called when
    // the nsStyleImageRequest is going away.
    //
    // This is currently used only for cursor images.
    Discard = 0x2,
  };

  // Must be called from the main thread.
  //
  // aImageTracker must be non-null iff aModeFlags contains Track.
  nsStyleImageRequest(Mode aModeFlags,
                      imgRequestProxy* aRequestProxy,
                      mozilla::css::ImageValue* aImageValue,
                      mozilla::dom::ImageTracker* aImageTracker);

  // Can be called from any thread, but Resolve() must be called later
  // on the main thread before get() can be used.
  nsStyleImageRequest(
      Mode aModeFlags,
      nsStringBuffer* aURLBuffer,
      already_AddRefed<mozilla::PtrHolder<nsIURI>> aBaseURI,
      already_AddRefed<mozilla::PtrHolder<nsIURI>> aReferrer,
      already_AddRefed<mozilla::PtrHolder<nsIPrincipal>> aPrincipal);

  bool Resolve(nsPresContext* aPresContext);
  bool IsResolved() const { return mResolved; }

  imgRequestProxy* get() {
    MOZ_ASSERT(IsResolved(), "Resolve() must be called first");
    MOZ_ASSERT(NS_IsMainThread());
    return mRequestProxy.get();
  }
  const imgRequestProxy* get() const {
    return const_cast<nsStyleImageRequest*>(this)->get();
  }

  // Returns whether the ImageValue objects in the two nsStyleImageRequests
  // return true from URLValueData::DefinitelyEqualURIs.
  bool DefinitelyEquals(const nsStyleImageRequest& aOther) const;

  NS_INLINE_DECL_THREADSAFE_REFCOUNTING(nsStyleImageRequest);

private:
  ~nsStyleImageRequest();
  nsStyleImageRequest& operator=(const nsStyleImageRequest& aOther) = delete;

  void MaybeTrackAndLock();

  RefPtr<imgRequestProxy> mRequestProxy;
  RefPtr<mozilla::css::ImageValue> mImageValue;
  RefPtr<mozilla::dom::ImageTracker> mImageTracker;

  Mode mModeFlags;
  bool mResolved;
};

MOZ_MAKE_ENUM_CLASS_BITWISE_OPERATORS(nsStyleImageRequest::Mode)

enum nsStyleImageType {
  eStyleImageType_Null,
  eStyleImageType_Image,
  eStyleImageType_Gradient,
  eStyleImageType_Element
};

struct CachedBorderImageData
{
  // Caller are expected to ensure that the value of aSVGViewportSize is
  // different from the cached one since the method won't do the check.
  void SetCachedSVGViewportSize(const mozilla::Maybe<nsSize>& aSVGViewportSize);
  const mozilla::Maybe<nsSize>& GetCachedSVGViewportSize();
  void PurgeCachedImages();
  void SetSubImage(uint8_t aIndex, imgIContainer* aSubImage);
  imgIContainer* GetSubImage(uint8_t aIndex);

private:
  // If this is a SVG border-image, we save the size of the SVG viewport that
  // we used when rasterizing any cached border-image subimages. (The viewport
  // size matters for percent-valued sizes & positions in inner SVG doc).
  mozilla::Maybe<nsSize> mCachedSVGViewportSize;
  nsCOMArray<imgIContainer> mSubImages;
};

/**
 * Represents a paintable image of one of the following types.
 * (1) A real image loaded from an external source.
 * (2) A CSS linear or radial gradient.
 * (3) An element within a document, or an <img>, <video>, or <canvas> element
 *     not in a document.
 * (*) Optionally a crop rect can be set to paint a partial (rectangular)
 * region of an image. (Currently, this feature is only supported with an
 * image of type (1)).
 */
struct nsStyleImage
{
  nsStyleImage();
  ~nsStyleImage();
  nsStyleImage(const nsStyleImage& aOther);
  nsStyleImage& operator=(const nsStyleImage& aOther);

  void SetNull();
  void SetImageRequest(already_AddRefed<nsStyleImageRequest> aImage);
  void SetGradientData(nsStyleGradient* aGradient);
  void SetElementId(const char16_t* aElementId);
  void SetCropRect(mozilla::UniquePtr<nsStyleSides> aCropRect);

  void ResolveImage(nsPresContext* aContext) {
    MOZ_ASSERT(mType != eStyleImageType_Image || mImage);
    if (mType == eStyleImageType_Image && !mImage->IsResolved()) {
      mImage->Resolve(aContext);
    }
  }

  nsStyleImageType GetType() const {
    return mType;
  }
  nsStyleImageRequest* GetImageRequest() const {
    MOZ_ASSERT(mType == eStyleImageType_Image, "Data is not an image!");
    MOZ_ASSERT(mImage);
    return mImage;
  }
  imgRequestProxy* GetImageData() const {
    return GetImageRequest()->get();
  }
  nsStyleGradient* GetGradientData() const {
    NS_ASSERTION(mType == eStyleImageType_Gradient, "Data is not a gradient!");
    return mGradient;
  }
  const char16_t* GetElementId() const {
    NS_ASSERTION(mType == eStyleImageType_Element, "Data is not an element!");
    return mElementId;
  }
  const mozilla::UniquePtr<nsStyleSides>& GetCropRect() const {
    NS_ASSERTION(mType == eStyleImageType_Image,
                 "Only image data can have a crop rect");
    return mCropRect;
  }

  /**
   * Compute the actual crop rect in pixels, using the source image bounds.
   * The computation involves converting percentage unit to pixel unit and
   * clamping each side value to fit in the source image bounds.
   * @param aActualCropRect the computed actual crop rect.
   * @param aIsEntireImage true iff |aActualCropRect| is identical to the
   * source image bounds.
   * @return true iff |aActualCropRect| holds a meaningful value.
   */
  bool ComputeActualCropRect(nsIntRect& aActualCropRect,
                               bool* aIsEntireImage = nullptr) const;

  /**
   * Starts the decoding of a image.
   */
  nsresult StartDecoding() const;
  /**
   * @return true if the item is definitely opaque --- i.e., paints every
   * pixel within its bounds opaquely, and the bounds contains at least a pixel.
   */
  bool IsOpaque() const;
  /**
   * @return true if this image is fully loaded, and its size is calculated;
   * always returns true if |mType| is |eStyleImageType_Gradient| or
   * |eStyleImageType_Element|.
   */
  bool IsComplete() const;
  /**
   * @return true if this image is loaded without error;
   * always returns true if |mType| is |eStyleImageType_Gradient| or
   * |eStyleImageType_Element|.
   */
  bool IsLoaded() const;
  /**
   * @return true if it is 100% confident that this image contains no pixel
   * to draw.
   */
  bool IsEmpty() const {
    // There are some other cases when the image will be empty, for example
    // when the crop rect is empty. However, checking the emptiness of crop
    // rect is non-trivial since each side value can be specified with
    // percentage unit, which can not be evaluated until the source image size
    // is available. Therefore, we currently postpone the evaluation of crop
    // rect until the actual rendering time --- alternatively until GetOpaqueRegion()
    // is called.
    return mType == eStyleImageType_Null;
  }

  bool operator==(const nsStyleImage& aOther) const;
  bool operator!=(const nsStyleImage& aOther) const {
    return !(*this == aOther);
  }

  bool ImageDataEquals(const nsStyleImage& aOther) const
  {
    return GetType() == eStyleImageType_Image &&
           aOther.GetType() == eStyleImageType_Image &&
           GetImageData() == aOther.GetImageData();
  }

  // These methods are used for the caller to caches the sub images created
  // during a border-image paint operation
  inline void SetSubImage(uint8_t aIndex, imgIContainer* aSubImage) const;
  inline imgIContainer* GetSubImage(uint8_t aIndex) const;
  void PurgeCacheForViewportChange(
    const mozilla::Maybe<nsSize>& aSVGViewportSize,
    const bool aHasIntrinsicRatio) const;

private:
  void DoCopy(const nsStyleImage& aOther);
  void EnsureCachedBIData() const;

  // This variable keeps some cache data for border image and is lazily
  // allocated since it is only used in border image case.
  mozilla::UniquePtr<CachedBorderImageData> mCachedBIData;

  nsStyleImageType mType;
  union {
    nsStyleImageRequest* mImage;
    nsStyleGradient* mGradient;
    char16_t* mElementId;
  };

  // This is _currently_ used only in conjunction with eStyleImageType_Image.
  mozilla::UniquePtr<nsStyleSides> mCropRect;
};

struct MOZ_NEEDS_MEMMOVABLE_MEMBERS nsStyleColor
{
  explicit nsStyleColor(StyleStructContext aContext);
  nsStyleColor(const nsStyleColor& aOther);
  ~nsStyleColor() {
    MOZ_COUNT_DTOR(nsStyleColor);
  }
  void FinishStyle(nsPresContext* aPresContext) {}

  nscolor CalcComplexColor(const mozilla::StyleComplexColor& aColor) const {
    return mozilla::LinearBlendColors(aColor.mColor, mColor,
                                      aColor.mForegroundRatio);
  }

  nsChangeHint CalcDifference(const nsStyleColor& aNewData) const;
  static nsChangeHint MaxDifference() {
    return nsChangeHint_RepaintFrame;
  }
  static nsChangeHint DifferenceAlwaysHandledForDescendants() {
    // CalcDifference never returns the reflow hints that are sometimes
    // handled for descendants at all.
    return nsChangeHint(0);
  }

  void* operator new(size_t sz, nsStyleColor* aSelf) { return aSelf; }
  void* operator new(size_t sz, nsPresContext* aContext) {
    return aContext->PresShell()->
      AllocateByObjectID(mozilla::eArenaObjectID_nsStyleColor, sz);
  }
  void Destroy(nsPresContext* aContext) {
    this->~nsStyleColor();
    aContext->PresShell()->
      FreeByObjectID(mozilla::eArenaObjectID_nsStyleColor, this);
  }

  // Don't add ANY members to this struct!  We can achieve caching in the rule
  // tree (rather than the style tree) by letting color stay by itself! -dwh
  nscolor mColor;                 // [inherited]
};

/**
 * An array of objects, similar to AutoTArray<T,1> but which is memmovable. It
 * always has length >= 1.
 */
template<typename T>
class nsStyleAutoArray
{
public:
  // This constructor places a single element in mFirstElement.
  enum WithSingleInitialElement { WITH_SINGLE_INITIAL_ELEMENT };
  explicit nsStyleAutoArray(WithSingleInitialElement) {}
  nsStyleAutoArray(const nsStyleAutoArray& aOther) { *this = aOther; }
  nsStyleAutoArray& operator=(const nsStyleAutoArray& aOther) {
    mFirstElement = aOther.mFirstElement;
    mOtherElements = aOther.mOtherElements;
    return *this;
  }

  bool operator==(const nsStyleAutoArray& aOther) const {
    return Length() == aOther.Length() &&
           mFirstElement == aOther.mFirstElement &&
           mOtherElements == aOther.mOtherElements;
  }
  bool operator!=(const nsStyleAutoArray& aOther) const {
    return !(*this == aOther);
  }

  size_t Length() const {
    return mOtherElements.Length() + 1;
  }
  const T& operator[](size_t aIndex) const {
    return aIndex == 0 ? mFirstElement : mOtherElements[aIndex - 1];
  }
  T& operator[](size_t aIndex) {
    return aIndex == 0 ? mFirstElement : mOtherElements[aIndex - 1];
  }

  void EnsureLengthAtLeast(size_t aMinLen) {
    if (aMinLen > 0) {
      mOtherElements.EnsureLengthAtLeast(aMinLen - 1);
    }
  }

  void SetLengthNonZero(size_t aNewLen) {
    MOZ_ASSERT(aNewLen > 0);
    mOtherElements.SetLength(aNewLen - 1);
  }

  void TruncateLengthNonZero(size_t aNewLen) {
    MOZ_ASSERT(aNewLen > 0);
    MOZ_ASSERT(aNewLen <= Length());
    mOtherElements.TruncateLength(aNewLen - 1);
  }

private:
  T mFirstElement;
  nsTArray<T> mOtherElements;
};

struct nsStyleImageLayers {
  // Indices into kBackgroundLayerTable and kMaskLayerTable
  enum {
    shorthand = 0,
    color,
    image,
    repeat,
    positionX,
    positionY,
    clip,
    origin,
    size,
    attachment,
    maskMode,
    composite
  };

  enum class LayerType : uint8_t {
    Background = 0,
    Mask
  };

  explicit nsStyleImageLayers(LayerType aType);
  nsStyleImageLayers(const nsStyleImageLayers &aSource);
  ~nsStyleImageLayers() {
    MOZ_COUNT_DTOR(nsStyleImageLayers);
  }

  static bool IsInitialPositionForLayerType(mozilla::Position aPosition, LayerType aType);

  struct Size;
  friend struct Size;
  struct Size {
    struct Dimension : public nsStyleCoord::CalcValue {
      nscoord ResolveLengthPercentage(nscoord aAvailable) const {
        double d = double(mPercent) * double(aAvailable) + double(mLength);
        if (d < 0.0) {
          return 0;
        }
        return NSToCoordRoundWithClamp(float(d));
      }
    };
    Dimension mWidth, mHeight;

    bool IsInitialValue() const {
      return mWidthType == eAuto && mHeightType == eAuto;
    }

    nscoord ResolveWidthLengthPercentage(const nsSize& aBgPositioningArea) const {
      MOZ_ASSERT(mWidthType == eLengthPercentage,
                 "resolving non-length/percent dimension!");
      return mWidth.ResolveLengthPercentage(aBgPositioningArea.width);
    }

    nscoord ResolveHeightLengthPercentage(const nsSize& aBgPositioningArea) const {
      MOZ_ASSERT(mHeightType == eLengthPercentage,
                 "resolving non-length/percent dimension!");
      return mHeight.ResolveLengthPercentage(aBgPositioningArea.height);
    }

    // Except for eLengthPercentage, Dimension types which might change
    // how a layer is painted when the corresponding frame's dimensions
    // change *must* precede all dimension types which are agnostic to
    // frame size; see DependsOnDependsOnPositioningAreaSizeSize.
    enum DimensionType {
      // If one of mWidth and mHeight is eContain or eCover, then both are.
      // NOTE: eContain and eCover *must* be equal to NS_STYLE_BG_SIZE_CONTAIN
      // and NS_STYLE_BG_SIZE_COVER (in kBackgroundSizeKTable).
      eContain, eCover,

      eAuto,
      eLengthPercentage,
      eDimensionType_COUNT
    };
    uint8_t mWidthType, mHeightType;

    // True if the effective image size described by this depends on the size of
    // the corresponding frame, when aImage (which must not have null type) is
    // the background image.
    bool DependsOnPositioningAreaSize(const nsStyleImage& aImage) const;

    // Initialize nothing
    Size() {}

    // Initialize to initial values
    void SetInitialValues();

    bool operator==(const Size& aOther) const;
    bool operator!=(const Size& aOther) const {
      return !(*this == aOther);
    }
  };

  struct Repeat;
  friend struct Repeat;
  struct Repeat {
    uint8_t mXRepeat, mYRepeat;

    // Initialize nothing
    Repeat() {}

    bool IsInitialValue() const {
      return mXRepeat == NS_STYLE_IMAGELAYER_REPEAT_REPEAT &&
             mYRepeat == NS_STYLE_IMAGELAYER_REPEAT_REPEAT;
    }

    bool DependsOnPositioningAreaSize() const {
      return mXRepeat == NS_STYLE_IMAGELAYER_REPEAT_SPACE ||
             mYRepeat == NS_STYLE_IMAGELAYER_REPEAT_SPACE;
    }

    // Initialize to initial values
    void SetInitialValues() {
      mXRepeat = NS_STYLE_IMAGELAYER_REPEAT_REPEAT;
      mYRepeat = NS_STYLE_IMAGELAYER_REPEAT_REPEAT;
    }

    bool operator==(const Repeat& aOther) const {
      return mXRepeat == aOther.mXRepeat &&
             mYRepeat == aOther.mYRepeat;
    }
    bool operator!=(const Repeat& aOther) const {
      return !(*this == aOther);
    }
  };

  struct Layer;
  friend struct Layer;
  struct Layer {
    nsStyleImage  mImage;         // [reset]
    RefPtr<mozilla::css::URLValueData> mSourceURI;  // [reset]
                                  // mask-only property
                                  // This property is used for mask layer only.
                                  // For a background layer, it should always
                                  // be the initial value, which is nullptr.
                                  // Store mask-image URI so that we can resolve
                                  // SVG mask path later.  (Might be a URLValue
                                  // or an ImageValue.)
    mozilla::Position mPosition;  // [reset]
    Size          mSize;          // [reset]
    uint8_t       mClip;          // [reset] See nsStyleConsts.h
    MOZ_INIT_OUTSIDE_CTOR
      uint8_t     mOrigin;        // [reset] See nsStyleConsts.h
    uint8_t       mAttachment;    // [reset] See nsStyleConsts.h
                                  // background-only property
                                  // This property is used for background layer
                                  // only. For a mask layer, it should always
                                  // be the initial value, which is
                                  // NS_STYLE_IMAGELAYER_ATTACHMENT_SCROLL.
    uint8_t       mBlendMode;     // [reset] See nsStyleConsts.h
                                  // background-only property
                                  // This property is used for background layer
                                  // only. For a mask layer, it should always
                                  // be the initial value, which is
                                  // NS_STYLE_BLEND_NORMAL.
    uint8_t       mComposite;     // [reset] See nsStyleConsts.h
                                  // mask-only property
                                  // This property is used for mask layer only.
                                  // For a background layer, it should always
                                  // be the initial value, which is
                                  // NS_STYLE_COMPOSITE_MODE_ADD.
    uint8_t       mMaskMode;      // [reset] See nsStyleConsts.h
                                  // mask-only property
                                  // This property is used for mask layer only.
                                  // For a background layer, it should always
                                  // be the initial value, which is
                                  // NS_STYLE_MASK_MODE_MATCH_SOURCE.
    Repeat        mRepeat;        // [reset] See nsStyleConsts.h

    // This constructor does not initialize mRepeat or mOrigin and Initialize()
    // must be called to do that.
    Layer();
    ~Layer();

    // Initialize mRepeat and mOrigin by specified layer type
    void Initialize(LayerType aType);

    void ResolveImage(nsPresContext* aContext) {
      if (mImage.GetType() == eStyleImageType_Image) {
        mImage.ResolveImage(aContext);
      }
    }

    // True if the rendering of this layer might change when the size
    // of the background positioning area changes.  This is true for any
    // non-solid-color background whose position or size depends on
    // the size of the positioning area.  It's also true for SVG images
    // whose root <svg> node has a viewBox.
    bool RenderingMightDependOnPositioningAreaSizeChange() const;

    // Compute the change hint required by changes in just this layer.
    nsChangeHint CalcDifference(const Layer& aNewLayer) const;

    // An equality operator that compares the images using URL-equality
    // rather than pointer-equality.
    bool operator==(const Layer& aOther) const;
    bool operator!=(const Layer& aOther) const {
      return !(*this == aOther);
    }
  };

  // The (positive) number of computed values of each property, since
  // the lengths of the lists are independent.
  uint32_t mAttachmentCount,
           mClipCount,
           mOriginCount,
           mRepeatCount,
           mPositionXCount,
           mPositionYCount,
           mImageCount,
           mSizeCount,
           mMaskModeCount,
           mBlendModeCount,
           mCompositeCount;

  // Layers are stored in an array, matching the top-to-bottom order in
  // which they are specified in CSS.  The number of layers to be used
  // should come from the background-image property.  We create
  // additional |Layer| objects for *any* property, not just
  // background-image.  This means that the bottommost layer that
  // callers in layout care about (which is also the one whose
  // background-clip applies to the background-color) may not be last
  // layer.  In layers below the bottom layer, properties will be
  // uninitialized unless their count, above, indicates that they are
  // present.
  nsStyleAutoArray<Layer> mLayers;

  const Layer& BottomLayer() const { return mLayers[mImageCount - 1]; }

  void ResolveImages(nsPresContext* aContext) {
    for (uint32_t i = 0; i < mImageCount; ++i) {
      mLayers[i].ResolveImage(aContext);
    }
  }

  nsChangeHint CalcDifference(const nsStyleImageLayers& aNewLayers,
                              nsStyleImageLayers::LayerType aType) const;

  bool HasLayerWithImage() const;
  nsStyleImageLayers& operator=(const nsStyleImageLayers& aOther);

  static const nsCSSPropertyID kBackgroundLayerTable[];
  static const nsCSSPropertyID kMaskLayerTable[];

  #define NS_FOR_VISIBLE_IMAGE_LAYERS_BACK_TO_FRONT(var_, layers_) \
    for (uint32_t var_ = (layers_).mImageCount; var_-- != 0; )
  #define NS_FOR_VISIBLE_IMAGE_LAYERS_BACK_TO_FRONT_WITH_RANGE(var_, layers_, start_, count_) \
    NS_ASSERTION((int32_t)(start_) >= 0 && (uint32_t)(start_) < (layers_).mImageCount, "Invalid layer start!"); \
    NS_ASSERTION((count_) > 0 && (count_) <= (start_) + 1, "Invalid layer range!"); \
    for (uint32_t var_ = (start_) + 1; var_-- != (uint32_t)((start_) + 1 - (count_)); )
};

struct MOZ_NEEDS_MEMMOVABLE_MEMBERS nsStyleBackground {
  explicit nsStyleBackground(StyleStructContext aContext);
  nsStyleBackground(const nsStyleBackground& aOther);
  ~nsStyleBackground();

  // Resolves and tracks the images in mImage.  Only called with a Servo-backed
  // style system, where those images must be resolved later than the OMT
  // nsStyleBackground constructor call.
  void FinishStyle(nsPresContext* aPresContext);

  void* operator new(size_t sz, nsStyleBackground* aSelf) { return aSelf; }
  void* operator new(size_t sz, nsPresContext* aContext) {
    return aContext->PresShell()->
      AllocateByObjectID(mozilla::eArenaObjectID_nsStyleBackground, sz);
  }
  void Destroy(nsPresContext* aContext);

  nsChangeHint CalcDifference(const nsStyleBackground& aNewData) const;
  static nsChangeHint MaxDifference() {
     return nsChangeHint_UpdateEffects |
           nsChangeHint_RepaintFrame |
           nsChangeHint_UpdateBackgroundPosition |
           nsChangeHint_NeutralChange;
  }
  static nsChangeHint DifferenceAlwaysHandledForDescendants() {
    // CalcDifference never returns the reflow hints that are sometimes
    // handled for descendants at all.
    return nsChangeHint(0);
  }

  // True if this background is completely transparent.
  bool IsTransparent() const;

  // We have to take slower codepaths for fixed background attachment,
  // but we don't want to do that when there's no image.
  // Not inline because it uses an nsCOMPtr<imgIRequest>
  // FIXME: Should be in nsStyleStructInlines.h.
  bool HasFixedBackground(nsIFrame* aFrame) const;

  // Checks to see if this has a non-empty image with "local" attachment.
  // This is defined in nsStyleStructInlines.h.
  inline bool HasLocalBackground() const;

  const nsStyleImageLayers::Layer& BottomLayer() const { return mImage.BottomLayer(); }

  nsStyleImageLayers mImage;
  nscolor mBackgroundColor;       // [reset]
};

#define NS_SPACING_MARGIN   0
#define NS_SPACING_PADDING  1
#define NS_SPACING_BORDER   2


struct MOZ_NEEDS_MEMMOVABLE_MEMBERS nsStyleMargin
{
  explicit nsStyleMargin(StyleStructContext aContext);
  nsStyleMargin(const nsStyleMargin& aMargin);
  ~nsStyleMargin() {
    MOZ_COUNT_DTOR(nsStyleMargin);
  }
  void FinishStyle(nsPresContext* aPresContext) {}

  void* operator new(size_t sz, nsStyleMargin* aSelf) { return aSelf; }
  void* operator new(size_t sz, nsPresContext* aContext) {
    return aContext->PresShell()->
      AllocateByObjectID(mozilla::eArenaObjectID_nsStyleMargin, sz);
  }
  void Destroy(nsPresContext* aContext);

  nsChangeHint CalcDifference(const nsStyleMargin& aNewData) const;
  static nsChangeHint MaxDifference() {
    return nsChangeHint_NeedReflow |
           nsChangeHint_ReflowChangesSizeOrPosition |
           nsChangeHint_ClearAncestorIntrinsics;
  }
  static nsChangeHint DifferenceAlwaysHandledForDescendants() {
    // CalcDifference can return all of the reflow hints sometimes not
    // handled for descendants as hints not handled for descendants.
    return nsChangeHint(0);
  }

  bool GetMargin(nsMargin& aMargin) const
  {
    if (!mMargin.ConvertsToLength()) {
      return false;
    }

    NS_FOR_CSS_SIDES(side) {
      aMargin.Side(side) = mMargin.ToLength(side);
    }
    return true;
  }

  // Return true if either the start or end side in the axis is 'auto'.
  // (defined in WritingModes.h since we need the full WritingMode type)
  inline bool HasBlockAxisAuto(mozilla::WritingMode aWM) const;
  inline bool HasInlineAxisAuto(mozilla::WritingMode aWM) const;

  nsStyleSides  mMargin; // [reset] coord, percent, calc, auto
};

struct MOZ_NEEDS_MEMMOVABLE_MEMBERS nsStylePadding
{
  explicit nsStylePadding(StyleStructContext aContext);
  nsStylePadding(const nsStylePadding& aPadding);
  ~nsStylePadding() {
    MOZ_COUNT_DTOR(nsStylePadding);
  }
  void FinishStyle(nsPresContext* aPresContext) {}

  void* operator new(size_t sz, nsStylePadding* aSelf) { return aSelf; }
  void* operator new(size_t sz, nsPresContext* aContext) {
    return aContext->PresShell()->
      AllocateByObjectID(mozilla::eArenaObjectID_nsStylePadding, sz);
  }
  void Destroy(nsPresContext* aContext);

  nsChangeHint CalcDifference(const nsStylePadding& aNewData) const;
  static nsChangeHint MaxDifference() {
    return NS_STYLE_HINT_REFLOW & ~nsChangeHint_ClearDescendantIntrinsics;
  }
  static nsChangeHint DifferenceAlwaysHandledForDescendants() {
    // CalcDifference can return nsChangeHint_ClearAncestorIntrinsics as
    // a hint not handled for descendants.  We could (and perhaps
    // should) return nsChangeHint_NeedReflow and
    // nsChangeHint_ReflowChangesSizeOrPosition as always handled for
    // descendants, but since they're always returned in conjunction
    // with nsChangeHint_ClearAncestorIntrinsics (which is not), it
    // won't ever lead to any optimization in
    // nsStyleContext::CalcStyleDifference.
    return nsChangeHint(0);
  }

  nsStyleSides  mPadding;         // [reset] coord, percent, calc

  bool IsWidthDependent() const {
    return !mPadding.ConvertsToLength();
  }

  bool GetPadding(nsMargin& aPadding) const
  {
    if (!mPadding.ConvertsToLength()) {
      return false;
    }

    NS_FOR_CSS_SIDES(side) {
      // Clamp negative calc() to 0.
      aPadding.Side(side) = std::max(mPadding.ToLength(side), 0);
    }
    return true;
  }
};

struct nsBorderColors
{
  nsBorderColors* mNext;
  nscolor mColor;

  nsBorderColors() : mNext(nullptr), mColor(NS_RGB(0,0,0)) {}
  explicit nsBorderColors(const nscolor& aColor) : mNext(nullptr), mColor(aColor) {}
  ~nsBorderColors();

  nsBorderColors* Clone() const { return Clone(true); }

  static bool Equal(const nsBorderColors* c1,
                      const nsBorderColors* c2) {
    if (c1 == c2) {
      return true;
    }
    while (c1 && c2) {
      if (c1->mColor != c2->mColor) {
        return false;
      }
      c1 = c1->mNext;
      c2 = c2->mNext;
    }
    // both should be nullptr if these are equal, otherwise one
    // has more colors than another
    return !c1 && !c2;
  }

private:
  nsBorderColors* Clone(bool aDeep) const;
};

struct nsCSSShadowItem
{
  nscoord mXOffset;
  nscoord mYOffset;
  nscoord mRadius;
  nscoord mSpread;

  nscolor      mColor;
  bool mHasColor; // Whether mColor should be used
  bool mInset;

  nsCSSShadowItem() : mHasColor(false) {
    MOZ_COUNT_CTOR(nsCSSShadowItem);
  }
  ~nsCSSShadowItem() {
    MOZ_COUNT_DTOR(nsCSSShadowItem);
  }

  bool operator==(const nsCSSShadowItem& aOther) const {
    return (mXOffset == aOther.mXOffset &&
            mYOffset == aOther.mYOffset &&
            mRadius == aOther.mRadius &&
            mHasColor == aOther.mHasColor &&
            mSpread == aOther.mSpread &&
            mInset == aOther.mInset &&
            (!mHasColor || mColor == aOther.mColor));
  }
  bool operator!=(const nsCSSShadowItem& aOther) const {
    return !(*this == aOther);
  }
};

class nsCSSShadowArray final
{
public:
  void* operator new(size_t aBaseSize, uint32_t aArrayLen) {
    // We can allocate both this nsCSSShadowArray and the
    // actual array in one allocation. The amount of memory to
    // allocate is equal to the class's size + the number of bytes for all
    // but the first array item (because aBaseSize includes one
    // item, see the private declarations)
    return ::operator new(aBaseSize +
                          (aArrayLen - 1) * sizeof(nsCSSShadowItem));
  }

  explicit nsCSSShadowArray(uint32_t aArrayLen) :
    mLength(aArrayLen)
  {
    MOZ_COUNT_CTOR(nsCSSShadowArray);
    for (uint32_t i = 1; i < mLength; ++i) {
      // Make sure we call the constructors of each nsCSSShadowItem
      // (the first one is called for us because we declared it under private)
      new (&mArray[i]) nsCSSShadowItem();
    }
  }

private:
  // Private destructor, to discourage deletion outside of Release():
  ~nsCSSShadowArray() {
    MOZ_COUNT_DTOR(nsCSSShadowArray);
    for (uint32_t i = 1; i < mLength; ++i) {
      mArray[i].~nsCSSShadowItem();
    }
  }

public:
  uint32_t Length() const { return mLength; }
  nsCSSShadowItem* ShadowAt(uint32_t i) {
    MOZ_ASSERT(i < mLength, "Accessing too high an index in the text shadow array!");
    return &mArray[i];
  }
  const nsCSSShadowItem* ShadowAt(uint32_t i) const {
    MOZ_ASSERT(i < mLength, "Accessing too high an index in the text shadow array!");
    return &mArray[i];
  }

  bool HasShadowWithInset(bool aInset) {
    for (uint32_t i = 0; i < mLength; ++i) {
      if (mArray[i].mInset == aInset) {
        return true;
      }
    }
    return false;
  }

  bool operator==(const nsCSSShadowArray& aOther) const {
    if (mLength != aOther.Length()) {
      return false;
    }

    for (uint32_t i = 0; i < mLength; ++i) {
      if (ShadowAt(i) != aOther.ShadowAt(i)) {
        return false;
      }
    }

    return true;
  }

  NS_INLINE_DECL_THREADSAFE_REFCOUNTING(nsCSSShadowArray)

private:
  uint32_t mLength;
  nsCSSShadowItem mArray[1]; // This MUST be the last item
};

// Border widths are rounded to the nearest-below integer number of pixels,
// but values between zero and one device pixels are always rounded up to
// one device pixel.
#define NS_ROUND_BORDER_TO_PIXELS(l,tpp) \
  ((l) == 0) ? 0 : std::max((tpp), (l) / (tpp) * (tpp))
// Outline offset is rounded to the nearest integer number of pixels, but values
// between zero and one device pixels are always rounded up to one device pixel.
// Note that the offset can be negative.
#define NS_ROUND_OFFSET_TO_PIXELS(l,tpp) \
  (((l) == 0) ? 0 : \
    ((l) > 0) ? std::max( (tpp), ((l) + ((tpp) / 2)) / (tpp) * (tpp)) : \
                std::min(-(tpp), ((l) - ((tpp) / 2)) / (tpp) * (tpp)))

// Returns if the given border style type is visible or not
static bool IsVisibleBorderStyle(uint8_t aStyle)
{
  return (aStyle != NS_STYLE_BORDER_STYLE_NONE &&
          aStyle != NS_STYLE_BORDER_STYLE_HIDDEN);
}

struct MOZ_NEEDS_MEMMOVABLE_MEMBERS nsStyleBorder
{
  explicit nsStyleBorder(StyleStructContext aContext);
  nsStyleBorder(const nsStyleBorder& aBorder);
  ~nsStyleBorder();

  // Resolves and tracks mBorderImageSource.  Only called with a Servo-backed
  // style system, where those images must be resolved later than the OMT
  // nsStyleBorder constructor call.
  void FinishStyle(nsPresContext* aPresContext);

  void* operator new(size_t sz, nsStyleBorder* aSelf) { return aSelf; }
  void* operator new(size_t sz, nsPresContext* aContext) {
    return aContext->PresShell()->
      AllocateByObjectID(mozilla::eArenaObjectID_nsStyleBorder, sz);
  }
  void Destroy(nsPresContext* aContext);

  nsChangeHint CalcDifference(const nsStyleBorder& aNewData) const;
  static nsChangeHint MaxDifference() {
    return NS_STYLE_HINT_REFLOW |
           nsChangeHint_UpdateOverflow |
           nsChangeHint_BorderStyleNoneChange |
           nsChangeHint_NeutralChange;
  }
  static nsChangeHint DifferenceAlwaysHandledForDescendants() {
    // CalcDifference never returns the reflow hints that are sometimes
    // handled for descendants as hints not handled for descendants.
    return nsChangeHint_NeedReflow |
           nsChangeHint_ReflowChangesSizeOrPosition |
           nsChangeHint_ClearAncestorIntrinsics;
  }

  void EnsureBorderColors() {
    if (!mBorderColors) {
      mBorderColors = new nsBorderColors*[4];
      if (mBorderColors) {
        for (int32_t i = 0; i < 4; i++) {
          mBorderColors[i] = nullptr;
        }
      }
    }
  }

  void ClearBorderColors(mozilla::css::Side aSide) {
    if (mBorderColors && mBorderColors[aSide]) {
      delete mBorderColors[aSide];
      mBorderColors[aSide] = nullptr;
    }
  }

  // Return whether aStyle is a visible style.  Invisible styles cause
  // the relevant computed border width to be 0.
  // Note that this does *not* consider the effects of 'border-image':
  // if border-style is none, but there is a loaded border image,
  // HasVisibleStyle will be false even though there *is* a border.
  bool HasVisibleStyle(mozilla::css::Side aSide) const
  {
    return IsVisibleBorderStyle(mBorderStyle[aSide]);
  }

  // aBorderWidth is in twips
  void SetBorderWidth(mozilla::css::Side aSide, nscoord aBorderWidth)
  {
    nscoord roundedWidth =
      NS_ROUND_BORDER_TO_PIXELS(aBorderWidth, mTwipsPerPixel);
    mBorder.Side(aSide) = roundedWidth;
    if (HasVisibleStyle(aSide)) {
      mComputedBorder.Side(aSide) = roundedWidth;
    }
  }

  // Get the computed border (plus rounding).  This does consider the
  // effects of 'border-style: none', but does not consider
  // 'border-image'.
  const nsMargin& GetComputedBorder() const
  {
    return mComputedBorder;
  }

  bool HasBorder() const
  {
    return mComputedBorder != nsMargin(0,0,0,0) || !mBorderImageSource.IsEmpty();
  }

  // Get the actual border width for a particular side, in appunits.  Note that
  // this is zero if and only if there is no border to be painted for this
  // side.  That is, this value takes into account the border style and the
  // value is rounded to the nearest device pixel by NS_ROUND_BORDER_TO_PIXELS.
  nscoord GetComputedBorderWidth(mozilla::css::Side aSide) const
  {
    return GetComputedBorder().Side(aSide);
  }

  uint8_t GetBorderStyle(mozilla::css::Side aSide) const
  {
    NS_ASSERTION(aSide <= NS_SIDE_LEFT, "bad side");
    return mBorderStyle[aSide];
  }

  void SetBorderStyle(mozilla::css::Side aSide, uint8_t aStyle)
  {
    NS_ASSERTION(aSide <= NS_SIDE_LEFT, "bad side");
    mBorderStyle[aSide] = aStyle;
    mComputedBorder.Side(aSide) =
      (HasVisibleStyle(aSide) ? mBorder.Side(aSide) : 0);
  }

  inline bool IsBorderImageLoaded() const
  {
    return mBorderImageSource.IsLoaded();
  }

  void ResolveImage(nsPresContext* aContext)
  {
    if (mBorderImageSource.GetType() == eStyleImageType_Image) {
      mBorderImageSource.ResolveImage(aContext);
    }
  }

  nsMargin GetImageOutset() const;

  void GetCompositeColors(int32_t aIndex, nsBorderColors** aColors) const
  {
    if (!mBorderColors) {
      *aColors = nullptr;
    } else {
      *aColors = mBorderColors[aIndex];
    }
  }

  void AppendBorderColor(int32_t aIndex, nscolor aColor)
  {
    NS_ASSERTION(aIndex >= 0 && aIndex <= 3, "bad side for composite border color");
    nsBorderColors* colorEntry = new nsBorderColors(aColor);
    if (!mBorderColors[aIndex]) {
      mBorderColors[aIndex] = colorEntry;
    } else {
      nsBorderColors* last = mBorderColors[aIndex];
      while (last->mNext) {
        last = last->mNext;
      }
      last->mNext = colorEntry;
    }
  }

  imgIRequest* GetBorderImageRequest() const
  {
    if (mBorderImageSource.GetType() == eStyleImageType_Image) {
      return mBorderImageSource.GetImageData();
    }
    return nullptr;
  }

public:
  nsBorderColors** mBorderColors;     // [reset] composite (stripe) colors
  nsStyleCorners mBorderRadius;       // [reset] coord, percent
  nsStyleImage   mBorderImageSource;  // [reset]
  nsStyleSides   mBorderImageSlice;   // [reset] factor, percent
  nsStyleSides   mBorderImageWidth;   // [reset] length, factor, percent, auto
  nsStyleSides   mBorderImageOutset;  // [reset] length, factor

  uint8_t        mBorderImageFill;    // [reset]
  uint8_t        mBorderImageRepeatH; // [reset] see nsStyleConsts.h
  uint8_t        mBorderImageRepeatV; // [reset]
  mozilla::StyleFloatEdge mFloatEdge; // [reset]
  mozilla::StyleBoxDecorationBreak mBoxDecorationBreak; // [reset]

protected:
  uint8_t       mBorderStyle[4];  // [reset] See nsStyleConsts.h

public:
  // [reset] the colors to use for a simple border.
  // not used for -moz-border-colors
  union {
    struct {
      mozilla::StyleComplexColor mBorderTopColor;
      mozilla::StyleComplexColor mBorderRightColor;
      mozilla::StyleComplexColor mBorderBottomColor;
      mozilla::StyleComplexColor mBorderLeftColor;
    };
    mozilla::StyleComplexColor mBorderColor[4];
  };

protected:
  // mComputedBorder holds the CSS2.1 computed border-width values.
  // In particular, these widths take into account the border-style
  // for the relevant side, and the values are rounded to the nearest
  // device pixel (which is not part of the definition of computed
  // values). The presence or absence of a border-image does not
  // affect border-width values.
  nsMargin      mComputedBorder;

  // mBorder holds the nscoord values for the border widths as they
  // would be if all the border-style values were visible (not hidden
  // or none).  This member exists so that when we create structs
  // using the copy constructor during style resolution the new
  // structs will know what the specified values of the border were in
  // case they have more specific rules setting the border style.
  //
  // Note that this isn't quite the CSS specified value, since this
  // has had the enumerated border widths converted to lengths, and
  // all lengths converted to twips.  But it's not quite the computed
  // value either. The values are rounded to the nearest device pixel.
  nsMargin      mBorder;

private:
  nscoord       mTwipsPerPixel;

  nsStyleBorder& operator=(const nsStyleBorder& aOther) = delete;
};

#define ASSERT_BORDER_COLOR_FIELD(side_)                          \
  static_assert(offsetof(nsStyleBorder, mBorder##side_##Color) == \
                  offsetof(nsStyleBorder, mBorderColor) +         \
                    size_t(mozilla::eSide##side_) *               \
                    sizeof(mozilla::StyleComplexColor),           \
                "mBorder" #side_ "Color must be at same offset "  \
                "as mBorderColor[mozilla::eSide" #side_ "]")
ASSERT_BORDER_COLOR_FIELD(Top);
ASSERT_BORDER_COLOR_FIELD(Right);
ASSERT_BORDER_COLOR_FIELD(Bottom);
ASSERT_BORDER_COLOR_FIELD(Left);
#undef ASSERT_BORDER_COLOR_FIELD


struct MOZ_NEEDS_MEMMOVABLE_MEMBERS nsStyleOutline
{
  explicit nsStyleOutline(StyleStructContext aContext);
  nsStyleOutline(const nsStyleOutline& aOutline);
  ~nsStyleOutline() {
    MOZ_COUNT_DTOR(nsStyleOutline);
  }
  void FinishStyle(nsPresContext* aPresContext) {}

  void* operator new(size_t sz, nsStyleOutline* aSelf) { return aSelf; }
  void* operator new(size_t sz, nsPresContext* aContext) {
    return aContext->PresShell()->
      AllocateByObjectID(mozilla::eArenaObjectID_nsStyleOutline, sz);
  }
  void Destroy(nsPresContext* aContext) {
    this->~nsStyleOutline();
    aContext->PresShell()->
      FreeByObjectID(mozilla::eArenaObjectID_nsStyleOutline, this);
  }

  void RecalcData();
  nsChangeHint CalcDifference(const nsStyleOutline& aNewData) const;
  static nsChangeHint MaxDifference() {
    return nsChangeHint_UpdateOverflow |
           nsChangeHint_SchedulePaint |
           nsChangeHint_RepaintFrame |
           nsChangeHint_NeutralChange;
  }
  static nsChangeHint DifferenceAlwaysHandledForDescendants() {
    // CalcDifference never returns the reflow hints that are sometimes
    // handled for descendants at all.
    return nsChangeHint(0);
  }

  nsStyleCorners  mOutlineRadius; // [reset] coord, percent, calc

  // This is the specified value of outline-width, but with length values
  // computed to absolute.  mActualOutlineWidth stores the outline-width
  // value used by layout.  (We must store mOutlineWidth for the same
  // style struct resolution reasons that we do nsStyleBorder::mBorder;
  // see that field's comment.)
  nsStyleCoord  mOutlineWidth;    // [reset] coord, enum (see nsStyleConsts.h)
  nscoord       mOutlineOffset;   // [reset]
  mozilla::StyleComplexColor mOutlineColor; // [reset]
  uint8_t       mOutlineStyle;    // [reset] See nsStyleConsts.h

  nscoord GetOutlineWidth() const
  {
    return mActualOutlineWidth;
  }

protected:
  // The actual value of outline-width is the computed value (an absolute
  // length, forced to zero when outline-style is none) rounded to device
  // pixels.  This is the value used by layout.
  nscoord       mActualOutlineWidth;
  nscoord       mTwipsPerPixel;
};


/**
 * An object that allows sharing of arrays that store 'quotes' property
 * values.  This is particularly important for inheritance, where we want
 * to share the same 'quotes' value with a parent style context.
 */
class nsStyleQuoteValues
{
public:
  typedef nsTArray<std::pair<nsString, nsString>> QuotePairArray;
  NS_INLINE_DECL_THREADSAFE_REFCOUNTING(nsStyleQuoteValues);
  QuotePairArray mQuotePairs;

private:
  ~nsStyleQuoteValues() {}
};

struct MOZ_NEEDS_MEMMOVABLE_MEMBERS nsStyleList
{
  explicit nsStyleList(StyleStructContext aContext);
  nsStyleList(const nsStyleList& aStyleList);
  ~nsStyleList();

  void FinishStyle(nsPresContext* aPresContext);

  void* operator new(size_t sz, nsStyleList* aSelf) { return aSelf; }
  void* operator new(size_t sz, nsPresContext* aContext) {
    return aContext->PresShell()->
      AllocateByObjectID(mozilla::eArenaObjectID_nsStyleList, sz);
  }
  void Destroy(nsPresContext* aContext) {
    this->~nsStyleList();
    aContext->PresShell()->
      FreeByObjectID(mozilla::eArenaObjectID_nsStyleList, this);
  }

  nsChangeHint CalcDifference(const nsStyleList& aNewData) const;
  static nsChangeHint MaxDifference() {
    return nsChangeHint_ReconstructFrame |
           NS_STYLE_HINT_REFLOW;
  }
  static nsChangeHint DifferenceAlwaysHandledForDescendants() {
    // CalcDifference never returns the reflow hints that are sometimes
    // handled for descendants as hints not handled for descendants.
    return nsChangeHint_NeedReflow |
           nsChangeHint_ReflowChangesSizeOrPosition |
           nsChangeHint_ClearAncestorIntrinsics;
  }

  static void Shutdown() {
    sInitialQuotes = nullptr;
    sNoneQuotes = nullptr;
  }

  imgRequestProxy* GetListStyleImage() const
  {
    return mListStyleImage ? mListStyleImage->get() : nullptr;
  }

  void GetListStyleType(nsSubstring& aType) const { mCounterStyle->GetStyleName(aType); }
  mozilla::CounterStyle* GetCounterStyle() const
  {
    return mCounterStyle.get();
  }
  void SetCounterStyle(mozilla::CounterStyle* aStyle)
  {
    // NB: This function is called off-main-thread during parallel restyle, but
    // only with builtin styles that use dummy refcounting.
    MOZ_ASSERT(NS_IsMainThread() || !aStyle->IsDependentStyle());
    mCounterStyle = aStyle;
  }
  void SetListStyleType(const nsSubstring& aType,
                        nsPresContext* aPresContext)
  {
    SetCounterStyle(aPresContext->CounterStyleManager()->BuildCounterStyle(aType));
  }

  const nsStyleQuoteValues::QuotePairArray& GetQuotePairs() const;

  void SetQuotesInherit(const nsStyleList* aOther);
  void SetQuotesInitial();
  void SetQuotesNone();
  void SetQuotes(nsStyleQuoteValues::QuotePairArray&& aValues);

  uint8_t mListStylePosition;                  // [inherited]
  RefPtr<nsStyleImageRequest> mListStyleImage; // [inherited]
private:
  RefPtr<mozilla::CounterStyle> mCounterStyle; // [inherited]
  RefPtr<nsStyleQuoteValues> mQuotes;   // [inherited]
  nsStyleList& operator=(const nsStyleList& aOther) = delete;
public:
  nsRect        mImageRegion;           // [inherited] the rect to use within an image

private:
  // nsStyleQuoteValues objects representing two common values, for sharing.
  static mozilla::StaticRefPtr<nsStyleQuoteValues> sInitialQuotes;
  static mozilla::StaticRefPtr<nsStyleQuoteValues> sNoneQuotes;
};

struct nsStyleGridLine
{
  // http://dev.w3.org/csswg/css-grid/#typedef-grid-line
  // XXXmats we could optimize memory size here
  bool mHasSpan;
  int32_t mInteger;  // 0 means not provided
  nsString mLineName;  // Empty string means not provided.

  // These are the limits that we choose to clamp grid line numbers to.
  // http://dev.w3.org/csswg/css-grid/#overlarge-grids
  // mInteger is clamped to this range:
  static const int32_t kMinLine = -10000;
  static const int32_t kMaxLine = 10000;

  nsStyleGridLine()
    : mHasSpan(false)
    , mInteger(0)
    // mLineName get its default constructor, the empty string
  {
  }

  nsStyleGridLine(const nsStyleGridLine& aOther)
  {
    (*this) = aOther;
  }

  void operator=(const nsStyleGridLine& aOther)
  {
    mHasSpan = aOther.mHasSpan;
    mInteger = aOther.mInteger;
    mLineName = aOther.mLineName;
  }

  bool operator!=(const nsStyleGridLine& aOther) const
  {
    return mHasSpan != aOther.mHasSpan ||
           mInteger != aOther.mInteger ||
           mLineName != aOther.mLineName;
  }

  void SetToInteger(uint32_t value)
  {
    mHasSpan = false;
    mInteger = value;
    mLineName.Truncate();
  }

  void SetAuto()
  {
    mHasSpan = false;
    mInteger = 0;
    mLineName.Truncate();
  }

  bool IsAuto() const
  {
    bool haveInitialValues =  mInteger == 0 && mLineName.IsEmpty();
    MOZ_ASSERT(!(haveInitialValues && mHasSpan),
               "should not have 'span' when other components are "
               "at their initial values");
    return haveInitialValues;
  }
};

// Computed value of the grid-template-columns or grid-template-rows property
// (but *not* grid-template-areas.)
// http://dev.w3.org/csswg/css-grid/#track-sizing
//
// This represents either:
// * none:
//   mIsSubgrid is false, all three arrays are empty
// * <track-list>:
//   mIsSubgrid is false,
//   mMinTrackSizingFunctions and mMaxTrackSizingFunctions
//   are of identical non-zero size,
//   and mLineNameLists is one element longer than that.
//   (Delimiting N columns requires N+1 lines:
//   one before each track, plus one at the very end.)
//
//   An omitted <line-names> is still represented in mLineNameLists,
//   as an empty sub-array.
//
//   A <track-size> specified as a single <track-breadth> is represented
//   as identical min and max sizing functions.
//   A 'fit-content(size)' <track-size> is represented as eStyleUnit_None
//   in the min sizing function and 'size' in the max sizing function.
//
//   The units for nsStyleCoord are:
//   * eStyleUnit_Percent represents a <percentage>
//   * eStyleUnit_FlexFraction represents a <flex> flexible fraction
//   * eStyleUnit_Coord represents a <length>
//   * eStyleUnit_Enumerated represents min-content or max-content
// * subgrid <line-name-list>?:
//   mIsSubgrid is true,
//   mLineNameLists may or may not be empty,
//   mMinTrackSizingFunctions and mMaxTrackSizingFunctions are empty.
//
// If mRepeatAutoIndex != -1 then that index is an <auto-repeat> and
// mIsAutoFill == true means it's an 'auto-fill', otherwise 'auto-fit'.
// mRepeatAutoLineNameListBefore is the list of line names before the track
// size, mRepeatAutoLineNameListAfter the names after.  (They are empty
// when there is no <auto-repeat> track, i.e. when mRepeatAutoIndex == -1).
// When mIsSubgrid is true, mRepeatAutoLineNameListBefore contains the line
// names and mRepeatAutoLineNameListAfter is empty.
struct nsStyleGridTemplate
{
  nsTArray<nsTArray<nsString>> mLineNameLists;
  nsTArray<nsStyleCoord> mMinTrackSizingFunctions;
  nsTArray<nsStyleCoord> mMaxTrackSizingFunctions;
  nsTArray<nsString> mRepeatAutoLineNameListBefore;
  nsTArray<nsString> mRepeatAutoLineNameListAfter;
  int16_t mRepeatAutoIndex; // -1 or the track index for an auto-fill/fit track
  bool mIsAutoFill : 1;
  bool mIsSubgrid : 1;

  nsStyleGridTemplate()
    : mRepeatAutoIndex(-1)
    , mIsAutoFill(false)
    , mIsSubgrid(false)
  {
  }

  inline bool operator!=(const nsStyleGridTemplate& aOther) const {
    return
      mIsSubgrid != aOther.mIsSubgrid ||
      mLineNameLists != aOther.mLineNameLists ||
      mMinTrackSizingFunctions != aOther.mMinTrackSizingFunctions ||
      mMaxTrackSizingFunctions != aOther.mMaxTrackSizingFunctions ||
      mIsAutoFill != aOther.mIsAutoFill ||
      mRepeatAutoIndex != aOther.mRepeatAutoIndex ||
      mRepeatAutoLineNameListBefore != aOther.mRepeatAutoLineNameListBefore ||
      mRepeatAutoLineNameListAfter != aOther.mRepeatAutoLineNameListAfter;
  }

  bool HasRepeatAuto() const {
    return mRepeatAutoIndex != -1;
  }

  bool IsRepeatAutoIndex(uint32_t aIndex) const {
    MOZ_ASSERT(aIndex < uint32_t(2*nsStyleGridLine::kMaxLine));
    return int32_t(aIndex) == mRepeatAutoIndex;
  }
};

struct MOZ_NEEDS_MEMMOVABLE_MEMBERS nsStylePosition
{
  explicit nsStylePosition(StyleStructContext aContext);
  nsStylePosition(const nsStylePosition& aOther);
  ~nsStylePosition();
  void FinishStyle(nsPresContext* aPresContext) {}

  void* operator new(size_t sz, nsStylePosition* aSelf) { return aSelf; }
  void* operator new(size_t sz, nsPresContext* aContext) {
    return aContext->PresShell()->
      AllocateByObjectID(mozilla::eArenaObjectID_nsStylePosition, sz);
  }
  void Destroy(nsPresContext* aContext) {
    this->~nsStylePosition();
    aContext->PresShell()->
      FreeByObjectID(mozilla::eArenaObjectID_nsStylePosition, this);
  }

  nsChangeHint CalcDifference(const nsStylePosition& aNewData,
                              const nsStyleVisibility* aOldStyleVisibility) const;
  static nsChangeHint MaxDifference() {
    return NS_STYLE_HINT_REFLOW |
           nsChangeHint_NeutralChange |
           nsChangeHint_RecomputePosition |
           nsChangeHint_UpdateParentOverflow |
           nsChangeHint_UpdateComputedBSize;
  }
  static nsChangeHint DifferenceAlwaysHandledForDescendants() {
    // CalcDifference can return all of the reflow hints that are
    // sometimes handled for descendants as hints not handled for
    // descendants.
    return nsChangeHint(0);
  }

  /**
   * Return the used value for 'align-self' given our parent StyleContext
   * aParent (or null for the root).
   */
  uint8_t UsedAlignSelf(nsStyleContext* aParent) const;

  /**
   * Return the computed value for 'justify-items' given our parent StyleContext
   * aParent (or null for the root).
   */
  uint8_t ComputedJustifyItems(nsStyleContext* aParent) const;

  /**
   * Return the used value for 'justify-self' given our parent StyleContext
   * aParent (or null for the root).
   */
  uint8_t UsedJustifySelf(nsStyleContext* aParent) const;

  mozilla::Position mObjectPosition;    // [reset]
  nsStyleSides  mOffset;                // [reset] coord, percent, calc, auto
  nsStyleCoord  mWidth;                 // [reset] coord, percent, enum, calc, auto
  nsStyleCoord  mMinWidth;              // [reset] coord, percent, enum, calc
  nsStyleCoord  mMaxWidth;              // [reset] coord, percent, enum, calc, none
  nsStyleCoord  mHeight;                // [reset] coord, percent, calc, auto
  nsStyleCoord  mMinHeight;             // [reset] coord, percent, calc
  nsStyleCoord  mMaxHeight;             // [reset] coord, percent, calc, none
  nsStyleCoord  mFlexBasis;             // [reset] coord, percent, enum, calc, auto
  nsStyleCoord  mGridAutoColumnsMin;    // [reset] coord, percent, enum, calc, flex
  nsStyleCoord  mGridAutoColumnsMax;    // [reset] coord, percent, enum, calc, flex
  nsStyleCoord  mGridAutoRowsMin;       // [reset] coord, percent, enum, calc, flex
  nsStyleCoord  mGridAutoRowsMax;       // [reset] coord, percent, enum, calc, flex
  uint8_t       mGridAutoFlow;          // [reset] enumerated. See nsStyleConsts.h
  mozilla::StyleBoxSizing mBoxSizing;   // [reset] see nsStyleConsts.h

  uint16_t      mAlignContent;          // [reset] fallback value in the high byte
  uint8_t       mAlignItems;            // [reset] see nsStyleConsts.h
  uint8_t       mAlignSelf;             // [reset] see nsStyleConsts.h
  uint16_t      mJustifyContent;        // [reset] fallback value in the high byte
private:
  friend class nsRuleNode;

  // mJustifyItems should only be read via ComputedJustifyItems(), which
  // lazily resolves its "auto" value. nsRuleNode needs direct access so
  // it can set mJustifyItems' value when populating this struct.
  uint8_t       mJustifyItems;          // [reset] see nsStyleConsts.h
public:
  uint8_t       mJustifySelf;           // [reset] see nsStyleConsts.h
  uint8_t       mFlexDirection;         // [reset] see nsStyleConsts.h
  uint8_t       mFlexWrap;              // [reset] see nsStyleConsts.h
  uint8_t       mObjectFit;             // [reset] see nsStyleConsts.h
  int32_t       mOrder;                 // [reset] integer
  float         mFlexGrow;              // [reset] float
  float         mFlexShrink;            // [reset] float
  nsStyleCoord  mZIndex;                // [reset] integer, auto
  nsStyleGridTemplate mGridTemplateColumns;
  nsStyleGridTemplate mGridTemplateRows;

  // nullptr for 'none'
  RefPtr<mozilla::css::GridTemplateAreasValue> mGridTemplateAreas;

  nsStyleGridLine mGridColumnStart;
  nsStyleGridLine mGridColumnEnd;
  nsStyleGridLine mGridRowStart;
  nsStyleGridLine mGridRowEnd;
  nsStyleCoord    mGridColumnGap;       // [reset] coord, percent, calc
  nsStyleCoord    mGridRowGap;          // [reset] coord, percent, calc

  // FIXME: Logical-coordinate equivalents to these WidthDepends... and
  // HeightDepends... methods have been introduced (see below); we probably
  // want to work towards removing the physical methods, and using the logical
  // ones in all cases.

  bool WidthDependsOnContainer() const
    {
      return mWidth.GetUnit() == eStyleUnit_Auto ||
        WidthCoordDependsOnContainer(mWidth);
    }

  // NOTE: For a flex item, "min-width:auto" is supposed to behave like
  // "min-content", which does depend on the container, so you might think we'd
  // need a special case for "flex item && min-width:auto" here.  However,
  // we don't actually need that special-case code, because flex items are
  // explicitly supposed to *ignore* their min-width (i.e. behave like it's 0)
  // until the flex container explicitly considers it.  So -- since the flex
  // container doesn't rely on this method, we don't need to worry about
  // special behavior for flex items' "min-width:auto" values here.
  bool MinWidthDependsOnContainer() const
    { return WidthCoordDependsOnContainer(mMinWidth); }
  bool MaxWidthDependsOnContainer() const
    { return WidthCoordDependsOnContainer(mMaxWidth); }

  // Note that these functions count 'auto' as depending on the
  // container since that's the case for absolutely positioned elements.
  // However, some callers do not care about this case and should check
  // for it, since it is the most common case.
  // FIXME: We should probably change the assumption to be the other way
  // around.
  // Consider this as part of moving to the logical-coordinate APIs.
  bool HeightDependsOnContainer() const
    {
      return mHeight.GetUnit() == eStyleUnit_Auto || // CSS 2.1, 10.6.4, item (5)
        HeightCoordDependsOnContainer(mHeight);
    }

  // NOTE: The comment above MinWidthDependsOnContainer about flex items
  // applies here, too.
  bool MinHeightDependsOnContainer() const
    { return HeightCoordDependsOnContainer(mMinHeight); }
  bool MaxHeightDependsOnContainer() const
    { return HeightCoordDependsOnContainer(mMaxHeight); }

  bool OffsetHasPercent(mozilla::css::Side aSide) const
  {
    return mOffset.Get(aSide).HasPercent();
  }

  // Logical-coordinate accessors for width and height properties,
  // given a WritingMode value. The definitions of these methods are
  // found in WritingModes.h (after the WritingMode class is fully
  // declared).
  inline nsStyleCoord& ISize(mozilla::WritingMode aWM);
  inline nsStyleCoord& MinISize(mozilla::WritingMode aWM);
  inline nsStyleCoord& MaxISize(mozilla::WritingMode aWM);
  inline nsStyleCoord& BSize(mozilla::WritingMode aWM);
  inline nsStyleCoord& MinBSize(mozilla::WritingMode aWM);
  inline nsStyleCoord& MaxBSize(mozilla::WritingMode aWM);
  inline const nsStyleCoord& ISize(mozilla::WritingMode aWM) const;
  inline const nsStyleCoord& MinISize(mozilla::WritingMode aWM) const;
  inline const nsStyleCoord& MaxISize(mozilla::WritingMode aWM) const;
  inline const nsStyleCoord& BSize(mozilla::WritingMode aWM) const;
  inline const nsStyleCoord& MinBSize(mozilla::WritingMode aWM) const;
  inline const nsStyleCoord& MaxBSize(mozilla::WritingMode aWM) const;
  inline bool ISizeDependsOnContainer(mozilla::WritingMode aWM) const;
  inline bool MinISizeDependsOnContainer(mozilla::WritingMode aWM) const;
  inline bool MaxISizeDependsOnContainer(mozilla::WritingMode aWM) const;
  inline bool BSizeDependsOnContainer(mozilla::WritingMode aWM) const;
  inline bool MinBSizeDependsOnContainer(mozilla::WritingMode aWM) const;
  inline bool MaxBSizeDependsOnContainer(mozilla::WritingMode aWM) const;

private:
  static bool WidthCoordDependsOnContainer(const nsStyleCoord &aCoord);
  static bool HeightCoordDependsOnContainer(const nsStyleCoord &aCoord)
    { return aCoord.HasPercent(); }
};

struct nsStyleTextOverflowSide
{
  nsStyleTextOverflowSide() : mType(NS_STYLE_TEXT_OVERFLOW_CLIP) {}

  bool operator==(const nsStyleTextOverflowSide& aOther) const {
    return mType == aOther.mType &&
           (mType != NS_STYLE_TEXT_OVERFLOW_STRING ||
            mString == aOther.mString);
  }
  bool operator!=(const nsStyleTextOverflowSide& aOther) const {
    return !(*this == aOther);
  }

  nsString mString;
  uint8_t  mType;
};

struct nsStyleTextOverflow
{
  nsStyleTextOverflow() : mLogicalDirections(true) {}
  bool operator==(const nsStyleTextOverflow& aOther) const {
    return mLeft == aOther.mLeft && mRight == aOther.mRight;
  }
  bool operator!=(const nsStyleTextOverflow& aOther) const {
    return !(*this == aOther);
  }

  // Returns the value to apply on the left side.
  const nsStyleTextOverflowSide& GetLeft(uint8_t aDirection) const {
    NS_ASSERTION(aDirection == NS_STYLE_DIRECTION_LTR ||
                 aDirection == NS_STYLE_DIRECTION_RTL, "bad direction");
    return !mLogicalDirections || aDirection == NS_STYLE_DIRECTION_LTR ?
             mLeft : mRight;
  }

  // Returns the value to apply on the right side.
  const nsStyleTextOverflowSide& GetRight(uint8_t aDirection) const {
    NS_ASSERTION(aDirection == NS_STYLE_DIRECTION_LTR ||
                 aDirection == NS_STYLE_DIRECTION_RTL, "bad direction");
    return !mLogicalDirections || aDirection == NS_STYLE_DIRECTION_LTR ?
             mRight : mLeft;
  }

  // Returns the first value that was specified.
  const nsStyleTextOverflowSide* GetFirstValue() const {
    return mLogicalDirections ? &mRight : &mLeft;
  }

  // Returns the second value, or null if there was only one value specified.
  const nsStyleTextOverflowSide* GetSecondValue() const {
    return mLogicalDirections ? nullptr : &mRight;
  }

  nsStyleTextOverflowSide mLeft;  // start side when mLogicalDirections is true
  nsStyleTextOverflowSide mRight; // end side when mLogicalDirections is true
  bool mLogicalDirections;  // true when only one value was specified
};

struct MOZ_NEEDS_MEMMOVABLE_MEMBERS nsStyleTextReset
{
  explicit nsStyleTextReset(StyleStructContext aContext);
  nsStyleTextReset(const nsStyleTextReset& aOther);
  ~nsStyleTextReset();
  void FinishStyle(nsPresContext* aPresContext) {}

  void* operator new(size_t sz, nsStyleTextReset* aSelf) { return aSelf; }
  void* operator new(size_t sz, nsPresContext* aContext) {
    return aContext->PresShell()->
      AllocateByObjectID(mozilla::eArenaObjectID_nsStyleTextReset, sz);
  }
  void Destroy(nsPresContext* aContext) {
    this->~nsStyleTextReset();
    aContext->PresShell()->
      FreeByObjectID(mozilla::eArenaObjectID_nsStyleTextReset, this);
  }

  // Note the difference between this and
  // nsStyleContext::HasTextDecorationLines.
  bool HasTextDecorationLines() const {
    return mTextDecorationLine != NS_STYLE_TEXT_DECORATION_LINE_NONE &&
           mTextDecorationLine != NS_STYLE_TEXT_DECORATION_LINE_OVERRIDE_ALL;
  }

  nsChangeHint CalcDifference(const nsStyleTextReset& aNewData) const;
  static nsChangeHint MaxDifference() {
    return nsChangeHint(
        NS_STYLE_HINT_REFLOW |
        nsChangeHint_UpdateSubtreeOverflow);
  }
  static nsChangeHint DifferenceAlwaysHandledForDescendants() {
    // CalcDifference never returns the reflow hints that are sometimes
    // handled for descendants as hints not handled for descendants.
    return nsChangeHint_NeedReflow |
           nsChangeHint_ReflowChangesSizeOrPosition |
           nsChangeHint_ClearAncestorIntrinsics;
  }

  nsStyleTextOverflow mTextOverflow;    // [reset] enum, string

  uint8_t mTextDecorationLine;          // [reset] see nsStyleConsts.h
  uint8_t mTextDecorationStyle;         // [reset] see nsStyleConsts.h
  uint8_t mUnicodeBidi;                 // [reset] see nsStyleConsts.h
  nscoord mInitialLetterSink;           // [reset] 0 means normal
  float mInitialLetterSize;             // [reset] 0.0f means normal
  mozilla::StyleComplexColor mTextDecorationColor; // [reset]
};

struct MOZ_NEEDS_MEMMOVABLE_MEMBERS nsStyleText
{
  explicit nsStyleText(StyleStructContext aContext);
  nsStyleText(const nsStyleText& aOther);
  ~nsStyleText();
  void FinishStyle(nsPresContext* aPresContext) {}

  void* operator new(size_t sz, nsStyleText* aSelf) { return aSelf; }
  void* operator new(size_t sz, nsPresContext* aContext) {
    return aContext->PresShell()->
      AllocateByObjectID(mozilla::eArenaObjectID_nsStyleText, sz);
  }
  void Destroy(nsPresContext* aContext) {
    this->~nsStyleText();
    aContext->PresShell()->
      FreeByObjectID(mozilla::eArenaObjectID_nsStyleText, this);
  }

  nsChangeHint CalcDifference(const nsStyleText& aNewData) const;
  static nsChangeHint MaxDifference() {
    return nsChangeHint_ReconstructFrame |
           NS_STYLE_HINT_REFLOW |
           nsChangeHint_UpdateSubtreeOverflow |
           nsChangeHint_NeutralChange;
  }
  static nsChangeHint DifferenceAlwaysHandledForDescendants() {
    // CalcDifference never returns the reflow hints that are sometimes
    // handled for descendants as hints not handled for descendants.
    return nsChangeHint_NeedReflow |
           nsChangeHint_ReflowChangesSizeOrPosition |
           nsChangeHint_ClearAncestorIntrinsics;
  }

  uint8_t mTextAlign;                   // [inherited] see nsStyleConsts.h
  uint8_t mTextAlignLast;               // [inherited] see nsStyleConsts.h
  bool mTextAlignTrue : 1;              // [inherited] see nsStyleConsts.h
  bool mTextAlignLastTrue : 1;          // [inherited] see nsStyleConsts.h
  uint8_t mTextTransform;               // [inherited] see nsStyleConsts.h
  uint8_t mWhiteSpace;                  // [inherited] see nsStyleConsts.h
  uint8_t mWordBreak;                   // [inherited] see nsStyleConsts.h
  uint8_t mOverflowWrap;                // [inherited] see nsStyleConsts.h
  uint8_t mHyphens;                     // [inherited] see nsStyleConsts.h
  uint8_t mRubyAlign;                   // [inherited] see nsStyleConsts.h
  uint8_t mRubyPosition;                // [inherited] see nsStyleConsts.h
  uint8_t mTextSizeAdjust;              // [inherited] see nsStyleConsts.h
  uint8_t mTextCombineUpright;          // [inherited] see nsStyleConsts.h
  uint8_t mControlCharacterVisibility;  // [inherited] see nsStyleConsts.h
  uint8_t mTextEmphasisPosition;        // [inherited] see nsStyleConsts.h
  uint8_t mTextEmphasisStyle;           // [inherited] see nsStyleConsts.h
  uint8_t mTextRendering;               // [inherited] see nsStyleConsts.h
  int32_t mTabSize;                     // [inherited] see nsStyleConsts.h
  mozilla::StyleComplexColor mTextEmphasisColor;      // [inherited]
  mozilla::StyleComplexColor mWebkitTextFillColor;    // [inherited]
  mozilla::StyleComplexColor mWebkitTextStrokeColor;  // [inherited]

  nsStyleCoord mWordSpacing;            // [inherited] coord, percent, calc
  nsStyleCoord mLetterSpacing;          // [inherited] coord, normal
  nsStyleCoord mLineHeight;             // [inherited] coord, factor, normal
  nsStyleCoord mTextIndent;             // [inherited] coord, percent, calc
  nsStyleCoord mWebkitTextStrokeWidth;  // [inherited] coord

  RefPtr<nsCSSShadowArray> mTextShadow; // [inherited] nullptr in case of a zero-length

  nsString mTextEmphasisStyleString;    // [inherited]

  bool WhiteSpaceIsSignificant() const {
    return mWhiteSpace == NS_STYLE_WHITESPACE_PRE ||
           mWhiteSpace == NS_STYLE_WHITESPACE_PRE_WRAP ||
           mWhiteSpace == NS_STYLE_WHITESPACE_PRE_SPACE;
  }

  bool NewlineIsSignificantStyle() const {
    return mWhiteSpace == NS_STYLE_WHITESPACE_PRE ||
           mWhiteSpace == NS_STYLE_WHITESPACE_PRE_WRAP ||
           mWhiteSpace == NS_STYLE_WHITESPACE_PRE_LINE;
  }

  bool WhiteSpaceOrNewlineIsSignificant() const {
    return mWhiteSpace == NS_STYLE_WHITESPACE_PRE ||
           mWhiteSpace == NS_STYLE_WHITESPACE_PRE_WRAP ||
           mWhiteSpace == NS_STYLE_WHITESPACE_PRE_LINE ||
           mWhiteSpace == NS_STYLE_WHITESPACE_PRE_SPACE;
  }

  bool TabIsSignificant() const {
    return mWhiteSpace == NS_STYLE_WHITESPACE_PRE ||
           mWhiteSpace == NS_STYLE_WHITESPACE_PRE_WRAP;
  }

  bool WhiteSpaceCanWrapStyle() const {
    return mWhiteSpace == NS_STYLE_WHITESPACE_NORMAL ||
           mWhiteSpace == NS_STYLE_WHITESPACE_PRE_WRAP ||
           mWhiteSpace == NS_STYLE_WHITESPACE_PRE_LINE;
  }

  bool WordCanWrapStyle() const {
    return WhiteSpaceCanWrapStyle() &&
           mOverflowWrap == NS_STYLE_OVERFLOWWRAP_BREAK_WORD;
  }

  bool HasTextEmphasis() const {
    return !mTextEmphasisStyleString.IsEmpty();
  }

  bool HasWebkitTextStroke() const {
    return mWebkitTextStrokeWidth.GetCoordValue() > 0;
  }

  // These are defined in nsStyleStructInlines.h.
  inline bool HasTextShadow() const;
  inline nsCSSShadowArray* GetTextShadow() const;

  // The aContextFrame argument on each of these is the frame this
  // style struct is for.  If the frame is for SVG text or inside ruby,
  // the return value will be massaged to be something that makes sense
  // for those cases.
  inline bool NewlineIsSignificant(const nsTextFrame* aContextFrame) const;
  inline bool WhiteSpaceCanWrap(const nsIFrame* aContextFrame) const;
  inline bool WordCanWrap(const nsIFrame* aContextFrame) const;

  mozilla::LogicalSide TextEmphasisSide(mozilla::WritingMode aWM) const;
};

struct nsStyleImageOrientation
{
  static nsStyleImageOrientation CreateAsAngleAndFlip(double aRadians,
                                                      bool aFlip) {
    uint8_t orientation(0);

    // Compute the final angle value, rounding to the closest quarter turn.
    double roundedAngle = fmod(aRadians, 2 * M_PI);
    if      (roundedAngle < 0.25 * M_PI) { orientation = ANGLE_0;  }
    else if (roundedAngle < 0.75 * M_PI) { orientation = ANGLE_90; }
    else if (roundedAngle < 1.25 * M_PI) { orientation = ANGLE_180;}
    else if (roundedAngle < 1.75 * M_PI) { orientation = ANGLE_270;}
    else                                 { orientation = ANGLE_0;  }

    // Add a bit for 'flip' if needed.
    if (aFlip) {
      orientation |= FLIP_MASK;
    }

    return nsStyleImageOrientation(orientation);
  }

  static nsStyleImageOrientation CreateAsFlip() {
    return nsStyleImageOrientation(FLIP_MASK);
  }

  static nsStyleImageOrientation CreateAsFromImage() {
    return nsStyleImageOrientation(FROM_IMAGE_MASK);
  }

  // The default constructor yields 0 degrees of rotation and no flip.
  nsStyleImageOrientation() : mOrientation(0) { }

  bool IsDefault()   const { return mOrientation == 0; }
  bool IsFlipped()   const { return mOrientation & FLIP_MASK; }
  bool IsFromImage() const { return mOrientation & FROM_IMAGE_MASK; }
  bool SwapsWidthAndHeight() const {
    uint8_t angle = mOrientation & ORIENTATION_MASK;
    return (angle == ANGLE_90) || (angle == ANGLE_270);
  }

  mozilla::image::Angle Angle() const {
    switch (mOrientation & ORIENTATION_MASK) {
      case ANGLE_0:   return mozilla::image::Angle::D0;
      case ANGLE_90:  return mozilla::image::Angle::D90;
      case ANGLE_180: return mozilla::image::Angle::D180;
      case ANGLE_270: return mozilla::image::Angle::D270;
      default:
        NS_NOTREACHED("Unexpected angle");
        return mozilla::image::Angle::D0;
    }
  }

  nsStyleCoord AngleAsCoord() const {
    switch (mOrientation & ORIENTATION_MASK) {
      case ANGLE_0:   return nsStyleCoord(0.0f,   eStyleUnit_Degree);
      case ANGLE_90:  return nsStyleCoord(90.0f,  eStyleUnit_Degree);
      case ANGLE_180: return nsStyleCoord(180.0f, eStyleUnit_Degree);
      case ANGLE_270: return nsStyleCoord(270.0f, eStyleUnit_Degree);
      default:
        NS_NOTREACHED("Unexpected angle");
        return nsStyleCoord();
    }
  }

  bool operator==(const nsStyleImageOrientation& aOther) const {
    return aOther.mOrientation == mOrientation;
  }

  bool operator!=(const nsStyleImageOrientation& aOther) const {
    return !(*this == aOther);
  }

protected:
  enum Bits {
    ORIENTATION_MASK = 0x1 | 0x2,  // The bottom two bits are the angle.
    FLIP_MASK        = 0x4,        // Whether the image should be flipped.
    FROM_IMAGE_MASK  = 0x8,        // Whether the image's inherent orientation
  };                               // should be used.

  enum Angles {
    ANGLE_0   = 0,
    ANGLE_90  = 1,
    ANGLE_180 = 2,
    ANGLE_270 = 3,
  };

  explicit nsStyleImageOrientation(uint8_t aOrientation)
    : mOrientation(aOrientation)
  { }

  uint8_t mOrientation;
};

struct MOZ_NEEDS_MEMMOVABLE_MEMBERS nsStyleVisibility
{
  explicit nsStyleVisibility(StyleStructContext aContext);
  nsStyleVisibility(const nsStyleVisibility& aVisibility);
  ~nsStyleVisibility() {
    MOZ_COUNT_DTOR(nsStyleVisibility);
  }
  void FinishStyle(nsPresContext* aPresContext) {}

  void* operator new(size_t sz, nsStyleVisibility* aSelf) { return aSelf; }
  void* operator new(size_t sz, nsPresContext* aContext) {
    return aContext->PresShell()->
      AllocateByObjectID(mozilla::eArenaObjectID_nsStyleVisibility, sz);
  }
  void Destroy(nsPresContext* aContext) {
    this->~nsStyleVisibility();
    aContext->PresShell()->
      FreeByObjectID(mozilla::eArenaObjectID_nsStyleVisibility, this);
  }

  nsChangeHint CalcDifference(const nsStyleVisibility& aNewData) const;
  static nsChangeHint MaxDifference() {
    return nsChangeHint_ReconstructFrame |
           NS_STYLE_HINT_REFLOW |
           nsChangeHint_NeutralChange;
  }
  static nsChangeHint DifferenceAlwaysHandledForDescendants() {
    // CalcDifference never returns the reflow hints that are sometimes
    // handled for descendants as hints not handled for descendants.
    return nsChangeHint_NeedReflow |
           nsChangeHint_ReflowChangesSizeOrPosition |
           nsChangeHint_ClearAncestorIntrinsics;
  }

  nsStyleImageOrientation mImageOrientation;  // [inherited]
  uint8_t mDirection;                  // [inherited] see nsStyleConsts.h NS_STYLE_DIRECTION_*
  uint8_t mVisible;                    // [inherited]
  uint8_t mImageRendering;             // [inherited] see nsStyleConsts.h
  uint8_t mWritingMode;                // [inherited] see nsStyleConsts.h
  uint8_t mTextOrientation;            // [inherited] see nsStyleConsts.h
  uint8_t mColorAdjust;                // [inherited] see nsStyleConsts.h

  bool IsVisible() const {
    return (mVisible == NS_STYLE_VISIBILITY_VISIBLE);
  }

  bool IsVisibleOrCollapsed() const {
    return ((mVisible == NS_STYLE_VISIBILITY_VISIBLE) ||
            (mVisible == NS_STYLE_VISIBILITY_COLLAPSE));
  }
};

struct nsTimingFunction
{

  enum class Type {
    Ease,         // ease
    Linear,       // linear
    EaseIn,       // ease-in
    EaseOut,      // ease-out
    EaseInOut,    // ease-in-out
    StepStart,    // step-start and steps(..., start)
    StepEnd,      // step-end, steps(..., end) and steps(...)
    CubicBezier,  // cubic-bezier()
  };

  // Whether the timing function type is represented by a spline,
  // and thus will have mFunc filled in.
  static bool IsSplineType(Type aType)
  {
    return aType != Type::StepStart && aType != Type::StepEnd;
  }

  explicit nsTimingFunction(int32_t aTimingFunctionType
                              = NS_STYLE_TRANSITION_TIMING_FUNCTION_EASE)
  {
    AssignFromKeyword(aTimingFunctionType);
  }

  nsTimingFunction(float x1, float y1, float x2, float y2)
    : mType(Type::CubicBezier)
  {
    mFunc.mX1 = x1;
    mFunc.mY1 = y1;
    mFunc.mX2 = x2;
    mFunc.mY2 = y2;
  }

  enum class Keyword { Implicit, Explicit };

  nsTimingFunction(Type aType, uint32_t aSteps)
    : mType(aType)
  {
    MOZ_ASSERT(mType == Type::StepStart || mType == Type::StepEnd,
               "wrong type");
    mSteps = aSteps;
  }

  nsTimingFunction(const nsTimingFunction& aOther)
  {
    *this = aOther;
  }

  Type mType;
  union {
    struct {
      float mX1;
      float mY1;
      float mX2;
      float mY2;
    } mFunc;
    struct {
      uint32_t mSteps;
    };
  };

  nsTimingFunction&
  operator=(const nsTimingFunction& aOther)
  {
    if (&aOther == this) {
      return *this;
    }

    mType = aOther.mType;

    if (HasSpline()) {
      mFunc.mX1 = aOther.mFunc.mX1;
      mFunc.mY1 = aOther.mFunc.mY1;
      mFunc.mX2 = aOther.mFunc.mX2;
      mFunc.mY2 = aOther.mFunc.mY2;
    } else {
      mSteps = aOther.mSteps;
    }

    return *this;
  }

  bool operator==(const nsTimingFunction& aOther) const
  {
    if (mType != aOther.mType) {
      return false;
    }
    if (HasSpline()) {
      return mFunc.mX1 == aOther.mFunc.mX1 && mFunc.mY1 == aOther.mFunc.mY1 &&
             mFunc.mX2 == aOther.mFunc.mX2 && mFunc.mY2 == aOther.mFunc.mY2;
    }
    return mSteps == aOther.mSteps;
  }

  bool operator!=(const nsTimingFunction& aOther) const
  {
    return !(*this == aOther);
  }

  bool HasSpline() const { return IsSplineType(mType); }

private:
  void AssignFromKeyword(int32_t aTimingFunctionType);
};

namespace mozilla {

struct StyleTransition
{
  StyleTransition() { /* leaves uninitialized; see also SetInitialValues */ }
  explicit StyleTransition(const StyleTransition& aCopy);

  void SetInitialValues();

  // Delay and Duration are in milliseconds

  const nsTimingFunction& GetTimingFunction() const { return mTimingFunction; }
  float GetDelay() const { return mDelay; }
  float GetDuration() const { return mDuration; }
  nsCSSPropertyID GetProperty() const { return mProperty; }
  nsIAtom* GetUnknownProperty() const { return mUnknownProperty; }

  float GetCombinedDuration() const {
    // http://dev.w3.org/csswg/css-transitions/#combined-duration
    return std::max(mDuration, 0.0f) + mDelay;
  }

  void SetTimingFunction(const nsTimingFunction& aTimingFunction)
    { mTimingFunction = aTimingFunction; }
  void SetDelay(float aDelay) { mDelay = aDelay; }
  void SetDuration(float aDuration) { mDuration = aDuration; }
  void SetProperty(nsCSSPropertyID aProperty)
    {
      NS_ASSERTION(aProperty != eCSSProperty_UNKNOWN &&
                   aProperty != eCSSPropertyExtra_variable,
                   "invalid property");
      mProperty = aProperty;
    }
  void SetUnknownProperty(nsCSSPropertyID aProperty,
                          const nsAString& aPropertyString);
  void CopyPropertyFrom(const StyleTransition& aOther)
    {
      mProperty = aOther.mProperty;
      mUnknownProperty = aOther.mUnknownProperty;
    }

  nsTimingFunction& TimingFunctionSlot() { return mTimingFunction; }

  bool operator==(const StyleTransition& aOther) const;
  bool operator!=(const StyleTransition& aOther) const
    { return !(*this == aOther); }

private:
  nsTimingFunction mTimingFunction;
  float mDuration;
  float mDelay;
  nsCSSPropertyID mProperty;
  nsCOMPtr<nsIAtom> mUnknownProperty; // used when mProperty is
                                      // eCSSProperty_UNKNOWN or
                                      // eCSSPropertyExtra_variable
};

struct StyleAnimation
{
  StyleAnimation() { /* leaves uninitialized; see also SetInitialValues */ }
  explicit StyleAnimation(const StyleAnimation& aCopy);

  void SetInitialValues();

  // Delay and Duration are in milliseconds

  const nsTimingFunction& GetTimingFunction() const { return mTimingFunction; }
  float GetDelay() const { return mDelay; }
  float GetDuration() const { return mDuration; }
  const nsString& GetName() const { return mName; }
  dom::PlaybackDirection GetDirection() const { return mDirection; }
  dom::FillMode GetFillMode() const { return mFillMode; }
  uint8_t GetPlayState() const { return mPlayState; }
  float GetIterationCount() const { return mIterationCount; }

  void SetTimingFunction(const nsTimingFunction& aTimingFunction)
    { mTimingFunction = aTimingFunction; }
  void SetDelay(float aDelay) { mDelay = aDelay; }
  void SetDuration(float aDuration) { mDuration = aDuration; }
  void SetName(const nsSubstring& aName) { mName = aName; }
  void SetDirection(dom::PlaybackDirection aDirection) { mDirection = aDirection; }
  void SetFillMode(dom::FillMode aFillMode) { mFillMode = aFillMode; }
  void SetPlayState(uint8_t aPlayState) { mPlayState = aPlayState; }
  void SetIterationCount(float aIterationCount)
    { mIterationCount = aIterationCount; }

  nsTimingFunction& TimingFunctionSlot() { return mTimingFunction; }

  bool operator==(const StyleAnimation& aOther) const;
  bool operator!=(const StyleAnimation& aOther) const
    { return !(*this == aOther); }

private:
  nsTimingFunction mTimingFunction;
  float mDuration;
  float mDelay;
  nsString mName; // empty string for 'none'
  dom::PlaybackDirection mDirection;
  dom::FillMode mFillMode;
  uint8_t mPlayState;
  float mIterationCount; // mozilla::PositiveInfinity<float>() means infinite
};

class StyleBasicShape final
{
public:
  explicit StyleBasicShape(StyleBasicShapeType type)
    : mType(type),
      mFillRule(StyleFillRule::Nonzero)
  {
    mPosition.SetInitialPercentValues(0.5f);
  }

  StyleBasicShapeType GetShapeType() const { return mType; }
  nsCSSKeyword GetShapeTypeName() const;

  StyleFillRule GetFillRule() const { return mFillRule; }
  void SetFillRule(StyleFillRule aFillRule)
  {
    MOZ_ASSERT(mType == StyleBasicShapeType::Polygon, "expected polygon");
    mFillRule = aFillRule;
  }

  Position& GetPosition() {
    MOZ_ASSERT(mType == StyleBasicShapeType::Circle ||
               mType == StyleBasicShapeType::Ellipse,
               "expected circle or ellipse");
    return mPosition;
  }
  const Position& GetPosition() const {
    MOZ_ASSERT(mType == StyleBasicShapeType::Circle ||
               mType == StyleBasicShapeType::Ellipse,
               "expected circle or ellipse");
    return mPosition;
  }

  bool HasRadius() const {
    MOZ_ASSERT(mType == StyleBasicShapeType::Inset, "expected inset");
    nsStyleCoord zero;
    zero.SetCoordValue(0);
    NS_FOR_CSS_HALF_CORNERS(corner) {
      if (mRadius.Get(corner) != zero) {
        return true;
      }
    }
    return false;
  }
  nsStyleCorners& GetRadius() {
    MOZ_ASSERT(mType == StyleBasicShapeType::Inset, "expected inset");
    return mRadius;
  }
  const nsStyleCorners& GetRadius() const {
    MOZ_ASSERT(mType == StyleBasicShapeType::Inset, "expected inset");
    return mRadius;
  }

  // mCoordinates has coordinates for polygon or radii for
  // ellipse and circle.
  nsTArray<nsStyleCoord>& Coordinates()
  {
    return mCoordinates;
  }

  const nsTArray<nsStyleCoord>& Coordinates() const
  {
    return mCoordinates;
  }

  bool operator==(const StyleBasicShape& aOther) const
  {
    return mType == aOther.mType &&
           mFillRule == aOther.mFillRule &&
           mCoordinates == aOther.mCoordinates &&
           mPosition == aOther.mPosition &&
           mRadius == aOther.mRadius;
  }
  bool operator!=(const StyleBasicShape& aOther) const {
    return !(*this == aOther);
  }

  NS_INLINE_DECL_THREADSAFE_REFCOUNTING(StyleBasicShape);

private:
  ~StyleBasicShape() {}

  StyleBasicShapeType mType;
  StyleFillRule mFillRule;

  // mCoordinates has coordinates for polygon or radii for
  // ellipse and circle.
  // (top, right, bottom, left) for inset
  nsTArray<nsStyleCoord> mCoordinates;
  // position of center for ellipse or circle
  Position mPosition;
  // corner radii for inset (0 if not set)
  nsStyleCorners mRadius;
};

template<typename ReferenceBox>
struct StyleShapeSource
{
  StyleShapeSource()
    : mURL(nullptr)
  {}

  StyleShapeSource(const StyleShapeSource& aSource)
    : StyleShapeSource()
  {
    if (aSource.mType == StyleShapeSourceType::URL) {
      SetURL(aSource.mURL);
    } else if (aSource.mType == StyleShapeSourceType::Shape) {
      SetBasicShape(aSource.mBasicShape, aSource.mReferenceBox);
    } else if (aSource.mType == StyleShapeSourceType::Box) {
      SetReferenceBox(aSource.mReferenceBox);
    }
  }

  ~StyleShapeSource()
  {
    ReleaseRef();
  }

  StyleShapeSource& operator=(const StyleShapeSource& aOther)
  {
    if (this == &aOther) {
      return *this;
    }

    if (aOther.mType == StyleShapeSourceType::URL) {
      SetURL(aOther.mURL);
    } else if (aOther.mType == StyleShapeSourceType::Shape) {
      SetBasicShape(aOther.mBasicShape, aOther.mReferenceBox);
    } else if (aOther.mType == StyleShapeSourceType::Box) {
      SetReferenceBox(aOther.mReferenceBox);
    } else {
      ReleaseRef();
      mReferenceBox = ReferenceBox::NoBox;
      mType = StyleShapeSourceType::None;
    }
    return *this;
  }

  bool operator==(const StyleShapeSource& aOther) const
  {
    if (mType != aOther.mType) {
      return false;
    }

    if (mType == StyleShapeSourceType::URL) {
      return mURL->Equals(*aOther.mURL);
    } else if (mType == StyleShapeSourceType::Shape) {
      return *mBasicShape == *aOther.mBasicShape &&
             mReferenceBox == aOther.mReferenceBox;
    } else if (mType == StyleShapeSourceType::Box) {
      return mReferenceBox == aOther.mReferenceBox;
    }

    return true;
  }

  bool operator!=(const StyleShapeSource& aOther) const
  {
    return !(*this == aOther);
  }

  StyleShapeSourceType GetType() const
  {
    return mType;
  }

  css::URLValue* GetURL() const
  {
    MOZ_ASSERT(mType == StyleShapeSourceType::URL, "Wrong shape source type!");
    return mURL;
  }

  bool SetURL(css::URLValue* aValue)
  {
    MOZ_ASSERT(aValue);
    ReleaseRef();
    mURL = aValue;
    mURL->AddRef();
    mType = StyleShapeSourceType::URL;
    return true;
  }

  StyleBasicShape* GetBasicShape() const
  {
    MOZ_ASSERT(mType == StyleShapeSourceType::Shape, "Wrong shape source type!");
    return mBasicShape;
  }

  void SetBasicShape(StyleBasicShape* aBasicShape,
                     ReferenceBox aReferenceBox)
  {
    NS_ASSERTION(aBasicShape, "expected pointer");
    ReleaseRef();
    mBasicShape = aBasicShape;
    mBasicShape->AddRef();
    mReferenceBox = aReferenceBox;
    mType = StyleShapeSourceType::Shape;
  }

  ReferenceBox GetReferenceBox() const
  {
    MOZ_ASSERT(mType == StyleShapeSourceType::Box ||
               mType == StyleShapeSourceType::Shape,
               "Wrong shape source type!");
    return mReferenceBox;
  }

  void SetReferenceBox(ReferenceBox aReferenceBox)
  {
    ReleaseRef();
    mReferenceBox = aReferenceBox;
    mType = StyleShapeSourceType::Box;
  }

private:
  void ReleaseRef()
  {
    if (mType == StyleShapeSourceType::Shape) {
      NS_ASSERTION(mBasicShape, "expected pointer");
      mBasicShape->Release();
    } else if (mType == StyleShapeSourceType::URL) {
      NS_ASSERTION(mURL, "expected pointer");
      mURL->Release();
    }
    // Both mBasicShape and mURL are pointers in a union. Nulling one of them
    // nulls both of them.
    mURL = nullptr;
  }

  void* operator new(size_t) = delete;

  union {
    StyleBasicShape* mBasicShape;
    css::URLValue* mURL;
  };
  StyleShapeSourceType mType = StyleShapeSourceType::None;
  ReferenceBox mReferenceBox = ReferenceBox::NoBox;
};

using StyleClipPath = StyleShapeSource<StyleClipPathGeometryBox>;
using StyleShapeOutside = StyleShapeSource<StyleShapeOutsideShapeBox>;

} // namespace mozilla

struct MOZ_NEEDS_MEMMOVABLE_MEMBERS nsStyleDisplay
{
  explicit nsStyleDisplay(StyleStructContext aContext);
  nsStyleDisplay(const nsStyleDisplay& aOther);
  ~nsStyleDisplay() {
    MOZ_COUNT_DTOR(nsStyleDisplay);
  }
  void FinishStyle(nsPresContext* aPresContext) {}

  void* operator new(size_t sz, nsStyleDisplay* aSelf) { return aSelf; }
  void* operator new(size_t sz, nsPresContext* aContext) {
    return aContext->PresShell()->
      AllocateByObjectID(mozilla::eArenaObjectID_nsStyleDisplay, sz);
  }
  void Destroy(nsPresContext* aContext) {
    this->~nsStyleDisplay();
    aContext->PresShell()->
      FreeByObjectID(mozilla::eArenaObjectID_nsStyleDisplay, this);
  }

  nsChangeHint CalcDifference(const nsStyleDisplay& aNewData) const;
  static nsChangeHint MaxDifference() {
    // All the parts of FRAMECHANGE are present in CalcDifference.
    return nsChangeHint(nsChangeHint_ReconstructFrame |
                        NS_STYLE_HINT_REFLOW |
                        nsChangeHint_UpdateTransformLayer |
                        nsChangeHint_UpdateOverflow |
                        nsChangeHint_UpdatePostTransformOverflow |
                        nsChangeHint_UpdateContainingBlock |
                        nsChangeHint_AddOrRemoveTransform |
                        nsChangeHint_NeutralChange);
  }
  static nsChangeHint DifferenceAlwaysHandledForDescendants() {
    // CalcDifference can return all of the reflow hints that are
    // sometimes handled for descendants as hints not handled for
    // descendants.
    return nsChangeHint(0);
  }

  // We guarantee that if mBinding is non-null, so are mBinding->GetURI() and
  // mBinding->mOriginPrincipal.
  RefPtr<mozilla::css::URLValue> mBinding; // [reset]
  mozilla::StyleDisplay mDisplay;          // [reset] see nsStyleConsts.h SyleDisplay
  mozilla::StyleDisplay mOriginalDisplay;  // [reset] saved mDisplay for
                                           //         position:absolute/fixed
                                           //         and float:left/right;
                                           //         otherwise equal to
                                           //         mDisplay
  uint8_t mContain;             // [reset] see nsStyleConsts.h NS_STYLE_CONTAIN_*
  uint8_t mAppearance;          // [reset]
  uint8_t mPosition;            // [reset] see nsStyleConsts.h

  // [reset] See StyleFloat in nsStyleConsts.h.
  mozilla::StyleFloat mFloat;
  // [reset] Save mFloat for position:absolute/fixed; otherwise equal to mFloat.
  mozilla::StyleFloat mOriginalFloat;

  mozilla::StyleClear mBreakType;  // [reset]
  uint8_t mBreakInside;         // [reset] NS_STYLE_PAGE_BREAK_AUTO/AVOID
  bool mBreakBefore;    // [reset]
  bool mBreakAfter;     // [reset]
  uint8_t mOverflowX;           // [reset] see nsStyleConsts.h
  uint8_t mOverflowY;           // [reset] see nsStyleConsts.h
  uint8_t mOverflowClipBox;     // [reset] see nsStyleConsts.h
  uint8_t mResize;              // [reset] see nsStyleConsts.h
  mozilla::StyleOrient mOrient; // [reset] see nsStyleConsts.h
  uint8_t mIsolation;           // [reset] see nsStyleConsts.h
  uint8_t mTopLayer;            // [reset] see nsStyleConsts.h
  uint8_t mWillChangeBitField;  // [reset] see nsStyleConsts.h. Stores a
                                // bitfield representation of the properties
                                // that are frequently queried. This should
                                // match mWillChange. Also tracks if any of the
                                // properties in the will-change list require
                                // a stacking context.
  nsTArray<nsString> mWillChange;

  uint8_t mTouchAction;         // [reset] see nsStyleConsts.h
  uint8_t mScrollBehavior;      // [reset] see nsStyleConsts.h NS_STYLE_SCROLL_BEHAVIOR_*
  uint8_t mScrollSnapTypeX;     // [reset] see nsStyleConsts.h NS_STYLE_SCROLL_SNAP_TYPE_*
  uint8_t mScrollSnapTypeY;     // [reset] see nsStyleConsts.h NS_STYLE_SCROLL_SNAP_TYPE_*
  nsStyleCoord mScrollSnapPointsX; // [reset]
  nsStyleCoord mScrollSnapPointsY; // [reset]
  mozilla::Position mScrollSnapDestination; // [reset]
  nsTArray<mozilla::Position> mScrollSnapCoordinate; // [reset]

  // mSpecifiedTransform is the list of transform functions as
  // specified, or null to indicate there is no transform.  (inherit or
  // initial are replaced by an actual list of transform functions, or
  // null, as appropriate.)
  uint8_t mBackfaceVisibility;
  uint8_t mTransformStyle;
  uint8_t mTransformBox;        // [reset] see nsStyleConsts.h
  RefPtr<nsCSSValueSharedList> mSpecifiedTransform; // [reset]
  nsStyleCoord mTransformOrigin[3]; // [reset] percent, coord, calc, 3rd param is coord, calc only
  nsStyleCoord mChildPerspective; // [reset] none, coord
  nsStyleCoord mPerspectiveOrigin[2]; // [reset] percent, coord, calc

  nsStyleCoord mVerticalAlign;  // [reset] coord, percent, calc, enum (see nsStyleConsts.h)

  nsStyleAutoArray<mozilla::StyleTransition> mTransitions; // [reset]

  // The number of elements in mTransitions that are not from repeating
  // a list due to another property being longer.
  uint32_t mTransitionTimingFunctionCount,
           mTransitionDurationCount,
           mTransitionDelayCount,
           mTransitionPropertyCount;

  nsStyleAutoArray<mozilla::StyleAnimation> mAnimations; // [reset]

  // The number of elements in mAnimations that are not from repeating
  // a list due to another property being longer.
  uint32_t mAnimationTimingFunctionCount,
           mAnimationDurationCount,
           mAnimationDelayCount,
           mAnimationNameCount,
           mAnimationDirectionCount,
           mAnimationFillModeCount,
           mAnimationPlayStateCount,
           mAnimationIterationCountCount;

  mozilla::StyleShapeOutside mShapeOutside; // [reset]

  bool IsBlockInsideStyle() const {
    return mozilla::StyleDisplay::Block == mDisplay ||
           mozilla::StyleDisplay::ListItem == mDisplay ||
           mozilla::StyleDisplay::InlineBlock == mDisplay ||
           mozilla::StyleDisplay::TableCaption == mDisplay;
    // Should TABLE_CELL be included here?  They have
    // block frames nested inside of them.
    // (But please audit all callers before changing.)
  }

  bool IsBlockOutsideStyle() const {
    return mozilla::StyleDisplay::Block == mDisplay ||
           mozilla::StyleDisplay::Flex == mDisplay ||
           mozilla::StyleDisplay::WebkitBox == mDisplay ||
           mozilla::StyleDisplay::Grid == mDisplay ||
           mozilla::StyleDisplay::ListItem == mDisplay ||
           mozilla::StyleDisplay::Table == mDisplay;
  }

  static bool IsDisplayTypeInlineOutside(mozilla::StyleDisplay aDisplay) {
    return mozilla::StyleDisplay::Inline == aDisplay ||
           mozilla::StyleDisplay::InlineBlock == aDisplay ||
           mozilla::StyleDisplay::InlineTable == aDisplay ||
           mozilla::StyleDisplay::InlineBox == aDisplay ||
           mozilla::StyleDisplay::InlineFlex == aDisplay ||
           mozilla::StyleDisplay::WebkitInlineBox == aDisplay ||
           mozilla::StyleDisplay::InlineGrid == aDisplay ||
           mozilla::StyleDisplay::InlineXulGrid == aDisplay ||
           mozilla::StyleDisplay::InlineStack == aDisplay ||
           mozilla::StyleDisplay::Ruby == aDisplay ||
           mozilla::StyleDisplay::RubyBase == aDisplay ||
           mozilla::StyleDisplay::RubyBaseContainer == aDisplay ||
           mozilla::StyleDisplay::RubyText == aDisplay ||
           mozilla::StyleDisplay::RubyTextContainer == aDisplay ||
           mozilla::StyleDisplay::Contents == aDisplay;
  }

  bool IsInlineOutsideStyle() const {
    return IsDisplayTypeInlineOutside(mDisplay);
  }

  bool IsOriginalDisplayInlineOutsideStyle() const {
    return IsDisplayTypeInlineOutside(mOriginalDisplay);
  }

  bool IsInnerTableStyle() const {
    return mozilla::StyleDisplay::TableCaption == mDisplay ||
           mozilla::StyleDisplay::TableCell == mDisplay ||
           mozilla::StyleDisplay::TableRow == mDisplay ||
           mozilla::StyleDisplay::TableRowGroup == mDisplay ||
           mozilla::StyleDisplay::TableHeaderGroup == mDisplay ||
           mozilla::StyleDisplay::TableFooterGroup == mDisplay ||
           mozilla::StyleDisplay::TableColumn == mDisplay ||
           mozilla::StyleDisplay::TableColumnGroup == mDisplay;
  }

  bool IsFloatingStyle() const {
    return mozilla::StyleFloat::None != mFloat;
  }

  bool IsAbsolutelyPositionedStyle() const {
    return NS_STYLE_POSITION_ABSOLUTE == mPosition ||
           NS_STYLE_POSITION_FIXED == mPosition;
  }

  bool IsRelativelyPositionedStyle() const {
    return NS_STYLE_POSITION_RELATIVE == mPosition ||
           NS_STYLE_POSITION_STICKY == mPosition;
  }
  bool IsPositionForcingStackingContext() const {
    return NS_STYLE_POSITION_STICKY == mPosition ||
           NS_STYLE_POSITION_FIXED == mPosition;
  }

  static bool IsRubyDisplayType(mozilla::StyleDisplay aDisplay) {
    return mozilla::StyleDisplay::Ruby == aDisplay ||
           mozilla::StyleDisplay::RubyBase == aDisplay ||
           mozilla::StyleDisplay::RubyBaseContainer == aDisplay ||
           mozilla::StyleDisplay::RubyText == aDisplay ||
           mozilla::StyleDisplay::RubyTextContainer == aDisplay;
  }

  bool IsRubyDisplayType() const {
    return IsRubyDisplayType(mDisplay);
  }

  bool IsOutOfFlowStyle() const {
    return (IsAbsolutelyPositionedStyle() || IsFloatingStyle());
  }

  bool IsScrollableOverflow() const {
    // mOverflowX and mOverflowY always match when one of them is
    // NS_STYLE_OVERFLOW_VISIBLE or NS_STYLE_OVERFLOW_CLIP.
    return mOverflowX != NS_STYLE_OVERFLOW_VISIBLE &&
           mOverflowX != NS_STYLE_OVERFLOW_CLIP;
  }

  bool IsContainPaint() const {
    return NS_STYLE_CONTAIN_PAINT & mContain;
  }

  /* Returns whether the element has the -moz-transform property
   * or a related property. */
  bool HasTransformStyle() const {
    return mSpecifiedTransform != nullptr ||
           mTransformStyle == NS_STYLE_TRANSFORM_STYLE_PRESERVE_3D ||
           (mWillChangeBitField & NS_STYLE_WILL_CHANGE_TRANSFORM);
  }

  bool HasPerspectiveStyle() const {
    return mChildPerspective.GetUnit() == eStyleUnit_Coord;
  }

  bool BackfaceIsHidden() const {
    return mBackfaceVisibility == NS_STYLE_BACKFACE_VISIBILITY_HIDDEN;
  }

  // These are defined in nsStyleStructInlines.h.

  // The aContextFrame argument on each of these is the frame this
  // style struct is for.  If the frame is for SVG text, the return
  // value will be massaged to be something that makes sense for
  // SVG text.
  inline bool IsBlockInside(const nsIFrame* aContextFrame) const;
  inline bool IsBlockOutside(const nsIFrame* aContextFrame) const;
  inline bool IsInlineOutside(const nsIFrame* aContextFrame) const;
  inline bool IsOriginalDisplayInlineOutside(const nsIFrame* aContextFrame) const;
  inline mozilla::StyleDisplay GetDisplay(const nsIFrame* aContextFrame) const;
  inline bool IsFloating(const nsIFrame* aContextFrame) const;
  inline bool IsRelativelyPositioned(const nsIFrame* aContextFrame) const;
  inline bool IsAbsolutelyPositioned(const nsIFrame* aContextFrame) const;

  // These methods are defined in nsStyleStructInlines.h.

  /**
   * Returns whether the element is a containing block for its
   * absolutely positioned descendants.
   * aContextFrame is the frame for which this is the nsStyleDisplay.
   */
  inline bool IsAbsPosContainingBlock(const nsIFrame* aContextFrame) const;

  /**
   * The same as IsAbsPosContainingBlock, except skipping the tests that
   * are based on the frame rather than the style context (thus
   * potentially returning a false positive).
   */
  template<class StyleContextLike>
  inline bool IsAbsPosContainingBlockForAppropriateFrame(
                StyleContextLike* aStyleContext) const;

  /**
   * Returns true when the element has the transform property
   * or a related property, and supports CSS transforms.
   * aContextFrame is the frame for which this is the nsStyleDisplay.
   */
  inline bool HasTransform(const nsIFrame* aContextFrame) const;

  /**
   * Returns true when the element is a containing block for its fixed-pos
   * descendants.
   * aContextFrame is the frame for which this is the nsStyleDisplay.
   */
  inline bool IsFixedPosContainingBlock(const nsIFrame* aContextFrame) const;

  /**
   * The same as IsFixedPosContainingBlock, except skipping the tests that
   * are based on the frame rather than the style context (thus
   * potentially returning a false positive).
   */
  template<class StyleContextLike>
  inline bool IsFixedPosContainingBlockForAppropriateFrame(
                StyleContextLike* aStyleContext) const;

private:
  // Helpers for above functions, which do some but not all of the tests
  // for them (since transform must be tested separately for each).
  template<class StyleContextLike>
  inline bool HasAbsPosContainingBlockStyleInternal(
                StyleContextLike* aStyleContext) const;
  template<class StyleContextLike>
  inline bool HasFixedPosContainingBlockStyleInternal(
                StyleContextLike* aStyleContext) const;

public:
  // Return the 'float' and 'clear' properties, with inline-{start,end} values
  // resolved to {left,right} according to the given writing mode. These are
  // defined in WritingModes.h.
  inline mozilla::StyleFloat PhysicalFloats(mozilla::WritingMode aWM) const;
  inline mozilla::StyleClear PhysicalBreakType(mozilla::WritingMode aWM) const;
};

struct MOZ_NEEDS_MEMMOVABLE_MEMBERS nsStyleTable
{
  explicit nsStyleTable(StyleStructContext aContext);
  nsStyleTable(const nsStyleTable& aOther);
  ~nsStyleTable();
  void FinishStyle(nsPresContext* aPresContext) {}

  void* operator new(size_t sz, nsStyleTable* aSelf) { return aSelf; }
  void* operator new(size_t sz, nsPresContext* aContext) {
    return aContext->PresShell()->
      AllocateByObjectID(mozilla::eArenaObjectID_nsStyleTable, sz);
  }
  void Destroy(nsPresContext* aContext) {
    this->~nsStyleTable();
    aContext->PresShell()->
      FreeByObjectID(mozilla::eArenaObjectID_nsStyleTable, this);
  }

  nsChangeHint CalcDifference(const nsStyleTable& aNewData) const;
  static nsChangeHint MaxDifference() {
    return nsChangeHint_ReconstructFrame;
  }
  static nsChangeHint DifferenceAlwaysHandledForDescendants() {
    // CalcDifference never returns the reflow hints that are sometimes
    // handled for descendants as hints not handled for descendants.
    return nsChangeHint(0);
  }

  uint8_t       mLayoutStrategy;// [reset] see nsStyleConsts.h NS_STYLE_TABLE_LAYOUT_*
  int32_t       mSpan;          // [reset] the number of columns spanned by a colgroup or col
};

struct MOZ_NEEDS_MEMMOVABLE_MEMBERS nsStyleTableBorder
{
  explicit nsStyleTableBorder(StyleStructContext aContext);
  nsStyleTableBorder(const nsStyleTableBorder& aOther);
  ~nsStyleTableBorder();
  void FinishStyle(nsPresContext* aPresContext) {}

  void* operator new(size_t sz, nsStyleTableBorder* aSelf) { return aSelf; }
  void* operator new(size_t sz, nsPresContext* aContext) {
    return aContext->PresShell()->
      AllocateByObjectID(mozilla::eArenaObjectID_nsStyleTableBorder, sz);
  }
  void Destroy(nsPresContext* aContext) {
    this->~nsStyleTableBorder();
    aContext->PresShell()->
      FreeByObjectID(mozilla::eArenaObjectID_nsStyleTableBorder, this);
  }

  nsChangeHint CalcDifference(const nsStyleTableBorder& aNewData) const;
  static nsChangeHint MaxDifference() {
    return nsChangeHint_ReconstructFrame |
           NS_STYLE_HINT_REFLOW;
  }
  static nsChangeHint DifferenceAlwaysHandledForDescendants() {
    // CalcDifference never returns the reflow hints that are sometimes
    // handled for descendants as hints not handled for descendants.
    return nsChangeHint_NeedReflow |
           nsChangeHint_ReflowChangesSizeOrPosition |
           nsChangeHint_ClearAncestorIntrinsics;
  }

  nscoord       mBorderSpacingCol;// [inherited]
  nscoord       mBorderSpacingRow;// [inherited]
  uint8_t       mBorderCollapse;// [inherited]
  uint8_t       mCaptionSide;   // [inherited]
  uint8_t       mEmptyCells;    // [inherited]
};

enum nsStyleContentType {
  eStyleContentType_String        = 1,
  eStyleContentType_Image         = 10,
  eStyleContentType_Attr          = 20,
  eStyleContentType_Counter       = 30,
  eStyleContentType_Counters      = 31,
  eStyleContentType_OpenQuote     = 40,
  eStyleContentType_CloseQuote    = 41,
  eStyleContentType_NoOpenQuote   = 42,
  eStyleContentType_NoCloseQuote  = 43,
  eStyleContentType_AltContent    = 50,
  eStyleContentType_Uninitialized
};

struct nsStyleContentData
{
  nsStyleContentType  mType;
  union {
    char16_t *mString;
    imgRequestProxy *mImage;
    nsCSSValue::Array* mCounters;
  } mContent;
#ifdef DEBUG
  bool mImageTracked;
#endif

  nsStyleContentData()
    : mType(eStyleContentType_Uninitialized)
#ifdef DEBUG
    , mImageTracked(false)
#endif
  {
    MOZ_COUNT_CTOR(nsStyleContentData);
    mContent.mString = nullptr;
  }
  nsStyleContentData(const nsStyleContentData&);

  ~nsStyleContentData();
  nsStyleContentData& operator=(const nsStyleContentData& aOther);
  bool operator==(const nsStyleContentData& aOther) const;

  bool operator!=(const nsStyleContentData& aOther) const {
    return !(*this == aOther);
  }

  void TrackImage(mozilla::dom::ImageTracker* aImageTracker);
  void UntrackImage(mozilla::dom::ImageTracker* aImageTracker);

  void SetImage(imgRequestProxy* aRequest)
  {
    MOZ_ASSERT(!mImageTracked,
               "Setting a new image without untracking the old one!");
    MOZ_ASSERT(mType == eStyleContentType_Image, "Wrong type!");
    NS_IF_ADDREF(mContent.mImage = aRequest);
  }
};

struct nsStyleCounterData
{
  nsString  mCounter;
  int32_t   mValue;

  bool operator==(const nsStyleCounterData& aOther) const {
    return mValue == aOther.mValue && mCounter == aOther.mCounter;
  }

  bool operator!=(const nsStyleCounterData& aOther) const {
    return !(*this == aOther);
  }
};

struct MOZ_NEEDS_MEMMOVABLE_MEMBERS nsStyleContent
{
  explicit nsStyleContent(StyleStructContext aContext);
  nsStyleContent(const nsStyleContent& aContent);
  ~nsStyleContent();
  void FinishStyle(nsPresContext* aPresContext) {}

  void* operator new(size_t sz, nsStyleContent* aSelf) { return aSelf; }
  void* operator new(size_t sz, nsPresContext* aContext) {
    return aContext->PresShell()->
      AllocateByObjectID(mozilla::eArenaObjectID_nsStyleContent, sz);
  }
  void Destroy(nsPresContext* aContext);

  nsChangeHint CalcDifference(const nsStyleContent& aNewData) const;
  static nsChangeHint MaxDifference() {
    return nsChangeHint_ReconstructFrame |
           NS_STYLE_HINT_REFLOW;
  }
  static nsChangeHint DifferenceAlwaysHandledForDescendants() {
    // CalcDifference never returns the reflow hints that are sometimes
    // handled for descendants as hints not handled for descendants.
    return nsChangeHint_NeedReflow |
           nsChangeHint_ReflowChangesSizeOrPosition |
           nsChangeHint_ClearAncestorIntrinsics;
  }

  uint32_t ContentCount() const { return mContents.Length(); } // [reset]

  const nsStyleContentData& ContentAt(uint32_t aIndex) const {
    return mContents[aIndex];
  }

  nsStyleContentData& ContentAt(uint32_t aIndex) { return mContents[aIndex]; }

  void AllocateContents(uint32_t aCount) {
    // We need to run the destructors of the elements of mContents, so we
    // delete and reallocate even if aCount == mContentCount.  (If
    // nsStyleContentData had its members private and managed their
    // ownership on setting, we wouldn't need this, but that seems
    // unnecessary at this point.)
    mContents.Clear();
    mContents.SetLength(aCount);
  }

  uint32_t CounterIncrementCount() const { return mIncrements.Length(); }  // [reset]
  const nsStyleCounterData& CounterIncrementAt(uint32_t aIndex) const {
    return mIncrements[aIndex];
  }

  void AllocateCounterIncrements(uint32_t aCount) {
    mIncrements.Clear();
    mIncrements.SetLength(aCount);
  }

  void SetCounterIncrementAt(uint32_t aIndex, const nsString& aCounter, int32_t aIncrement) {
    mIncrements[aIndex].mCounter = aCounter;
    mIncrements[aIndex].mValue = aIncrement;
  }

  uint32_t CounterResetCount() const { return mResets.Length(); }  // [reset]
  const nsStyleCounterData& CounterResetAt(uint32_t aIndex) const {
    return mResets[aIndex];
  }

  void AllocateCounterResets(uint32_t aCount) {
    mResets.Clear();
    mResets.SetLength(aCount);
  }

  void SetCounterResetAt(uint32_t aIndex, const nsString& aCounter, int32_t aValue) {
    mResets[aIndex].mCounter = aCounter;
    mResets[aIndex].mValue = aValue;
  }

protected:
  nsTArray<nsStyleContentData> mContents;
  nsTArray<nsStyleCounterData> mIncrements;
  nsTArray<nsStyleCounterData> mResets;
};

struct MOZ_NEEDS_MEMMOVABLE_MEMBERS nsStyleUIReset
{
  explicit nsStyleUIReset(StyleStructContext aContext);
  nsStyleUIReset(const nsStyleUIReset& aOther);
  ~nsStyleUIReset();
  void FinishStyle(nsPresContext* aPresContext) {}

  void* operator new(size_t sz, nsStyleUIReset* aSelf) { return aSelf; }
  void* operator new(size_t sz, nsPresContext* aContext) {
    return aContext->PresShell()->
      AllocateByObjectID(mozilla::eArenaObjectID_nsStyleUIReset, sz);
  }
  void Destroy(nsPresContext* aContext) {
    this->~nsStyleUIReset();
    aContext->PresShell()->
      FreeByObjectID(mozilla::eArenaObjectID_nsStyleUIReset, this);
  }

  nsChangeHint CalcDifference(const nsStyleUIReset& aNewData) const;
  static nsChangeHint MaxDifference() {
    return nsChangeHint_ReconstructFrame |
           NS_STYLE_HINT_REFLOW;
  }
  static nsChangeHint DifferenceAlwaysHandledForDescendants() {
    // CalcDifference never returns the reflow hints that are sometimes
    // handled for descendants as hints not handled for descendants.
    return nsChangeHint_NeedReflow |
           nsChangeHint_ReflowChangesSizeOrPosition |
           nsChangeHint_ClearAncestorIntrinsics;
  }

  mozilla::StyleUserSelect     mUserSelect;     // [reset](selection-style)
  uint8_t mForceBrokenImageIcon; // [reset] (0 if not forcing, otherwise forcing)
  uint8_t                      mIMEMode;        // [reset]
  mozilla::StyleWindowDragging mWindowDragging; // [reset]
  uint8_t                      mWindowShadow;   // [reset]
};

struct nsCursorImage
{
  bool mHaveHotspot;
  float mHotspotX, mHotspotY;

  nsCursorImage();
  nsCursorImage(const nsCursorImage& aOther);
  ~nsCursorImage();

  nsCursorImage& operator=(const nsCursorImage& aOther);

  bool operator==(const nsCursorImage& aOther) const;
  bool operator!=(const nsCursorImage& aOther) const
  {
    return !(*this == aOther);
  }

  void SetImage(imgIRequest *aImage) {
    if (mImage) {
      mImage->UnlockImage();
      mImage->RequestDiscard();
    }
    mImage = aImage;
    if (mImage) {
      mImage->LockImage();
    }
  }
  imgIRequest* GetImage() const {
    return mImage;
  }

private:
  nsCOMPtr<imgIRequest> mImage;
};

struct MOZ_NEEDS_MEMMOVABLE_MEMBERS nsStyleUserInterface
{
  explicit nsStyleUserInterface(StyleStructContext aContext);
  nsStyleUserInterface(const nsStyleUserInterface& aOther);
  ~nsStyleUserInterface();
  void FinishStyle(nsPresContext* aPresContext) {}

  void* operator new(size_t sz, nsStyleUserInterface* aSelf) { return aSelf; }
  void* operator new(size_t sz, nsPresContext* aContext) {
    return aContext->PresShell()->
      AllocateByObjectID(mozilla::eArenaObjectID_nsStyleUserInterface, sz);
  }
  void Destroy(nsPresContext* aContext) {
    this->~nsStyleUserInterface();
    aContext->PresShell()->
      FreeByObjectID(mozilla::eArenaObjectID_nsStyleUserInterface, this);
  }

  nsChangeHint CalcDifference(const nsStyleUserInterface& aNewData) const;
  static nsChangeHint MaxDifference() {
    return nsChangeHint_ReconstructFrame |
           nsChangeHint_NeedReflow |
           nsChangeHint_NeedDirtyReflow |
           NS_STYLE_HINT_VISUAL |
           nsChangeHint_UpdateCursor |
           nsChangeHint_NeutralChange;
  }
  static nsChangeHint DifferenceAlwaysHandledForDescendants() {
    // CalcDifference never returns the reflow hints that are sometimes
    // handled for descendants as hints not handled for descendants.
    return nsChangeHint_NeedReflow;
  }

  mozilla::StyleUserInput   mUserInput;       // [inherited]
  mozilla::StyleUserModify  mUserModify;      // [inherited] (modify-content)
  mozilla::StyleUserFocus   mUserFocus;       // [inherited] (auto-select)
  uint8_t                   mPointerEvents;   // [inherited] see nsStyleConsts.h

  uint8_t mCursor;                            // [inherited] See nsStyleConsts.h
  nsTArray<nsCursorImage> mCursorImages;      // [inherited] images and coords

  inline uint8_t GetEffectivePointerEvents(nsIFrame* aFrame) const;
};

struct MOZ_NEEDS_MEMMOVABLE_MEMBERS nsStyleXUL
{
  explicit nsStyleXUL(StyleStructContext aContext);
  nsStyleXUL(const nsStyleXUL& aSource);
  ~nsStyleXUL();
  void FinishStyle(nsPresContext* aPresContext) {}

  void* operator new(size_t sz, nsStyleXUL* aSelf) { return aSelf; }
  void* operator new(size_t sz, nsPresContext* aContext) {
    return aContext->PresShell()->
      AllocateByObjectID(mozilla::eArenaObjectID_nsStyleXUL, sz);
  }
  void Destroy(nsPresContext* aContext) {
    this->~nsStyleXUL();
    aContext->PresShell()->
      FreeByObjectID(mozilla::eArenaObjectID_nsStyleXUL, this);
  }

  nsChangeHint CalcDifference(const nsStyleXUL& aNewData) const;
  static nsChangeHint MaxDifference() {
    return nsChangeHint_ReconstructFrame |
           NS_STYLE_HINT_REFLOW;
  }
  static nsChangeHint DifferenceAlwaysHandledForDescendants() {
    // CalcDifference never returns the reflow hints that are sometimes
    // handled for descendants as hints not handled for descendants.
    return nsChangeHint_NeedReflow |
           nsChangeHint_ReflowChangesSizeOrPosition |
           nsChangeHint_ClearAncestorIntrinsics;
  }

  float         mBoxFlex;               // [reset] see nsStyleConsts.h
  uint32_t      mBoxOrdinal;            // [reset] see nsStyleConsts.h
  mozilla::StyleBoxAlign mBoxAlign;         // [reset]
  mozilla::StyleBoxDirection mBoxDirection; // [reset]
  mozilla::StyleBoxOrient mBoxOrient;       // [reset]
  mozilla::StyleBoxPack mBoxPack;           // [reset]
  bool          mStretchStack;          // [reset] see nsStyleConsts.h
};

struct MOZ_NEEDS_MEMMOVABLE_MEMBERS nsStyleColumn
{
  explicit nsStyleColumn(StyleStructContext aContext);
  nsStyleColumn(const nsStyleColumn& aSource);
  ~nsStyleColumn();
  void FinishStyle(nsPresContext* aPresContext) {}

  void* operator new(size_t sz, nsStyleColumn* aSelf) { return aSelf; }
  void* operator new(size_t sz, nsPresContext* aContext) {
    return aContext->PresShell()->
      AllocateByObjectID(mozilla::eArenaObjectID_nsStyleColumn, sz);
  }
  void Destroy(nsPresContext* aContext) {
    this->~nsStyleColumn();
    aContext->PresShell()->
      FreeByObjectID(mozilla::eArenaObjectID_nsStyleColumn, this);
  }

  nsChangeHint CalcDifference(const nsStyleColumn& aNewData) const;
  static nsChangeHint MaxDifference() {
    return nsChangeHint_ReconstructFrame |
           NS_STYLE_HINT_REFLOW |
           nsChangeHint_NeutralChange;
  }
  static nsChangeHint DifferenceAlwaysHandledForDescendants() {
    // CalcDifference never returns the reflow hints that are sometimes
    // handled for descendants as hints not handled for descendants.
    return nsChangeHint_NeedReflow |
           nsChangeHint_ReflowChangesSizeOrPosition |
           nsChangeHint_ClearAncestorIntrinsics;
  }

  /**
   * This is the maximum number of columns we can process. It's used in both
   * nsColumnSetFrame and nsRuleNode.
   */
  static const uint32_t kMaxColumnCount = 1000;

  uint32_t     mColumnCount; // [reset] see nsStyleConsts.h
  nsStyleCoord mColumnWidth; // [reset] coord, auto
  nsStyleCoord mColumnGap;   // [reset] coord, normal

  mozilla::StyleComplexColor mColumnRuleColor; // [reset]
  uint8_t      mColumnRuleStyle;  // [reset]
  uint8_t      mColumnFill;  // [reset] see nsStyleConsts.h

  void SetColumnRuleWidth(nscoord aWidth) {
    mColumnRuleWidth = NS_ROUND_BORDER_TO_PIXELS(aWidth, mTwipsPerPixel);
  }

  nscoord GetComputedColumnRuleWidth() const {
    return (IsVisibleBorderStyle(mColumnRuleStyle) ? mColumnRuleWidth : 0);
  }

protected:
  nscoord mColumnRuleWidth;  // [reset] coord
  nscoord mTwipsPerPixel;
};

enum nsStyleSVGPaintType {
  eStyleSVGPaintType_None = 1,
  eStyleSVGPaintType_Color,
  eStyleSVGPaintType_Server,
  eStyleSVGPaintType_ContextFill,
  eStyleSVGPaintType_ContextStroke
};

enum nsStyleSVGOpacitySource : uint8_t {
  eStyleSVGOpacitySource_Normal,
  eStyleSVGOpacitySource_ContextFillOpacity,
  eStyleSVGOpacitySource_ContextStrokeOpacity
};

class nsStyleSVGPaint
{
public:
  explicit nsStyleSVGPaint(nsStyleSVGPaintType aType = nsStyleSVGPaintType(0));
  nsStyleSVGPaint(const nsStyleSVGPaint& aSource);
  ~nsStyleSVGPaint();

  nsStyleSVGPaint& operator=(const nsStyleSVGPaint& aOther);

  nsStyleSVGPaintType Type() const { return mType; }

  void SetNone();
  void SetColor(nscolor aColor);
  void SetPaintServer(mozilla::css::URLValue* aPaintServer,
                      nscolor aFallbackColor);
  void SetContextValue(nsStyleSVGPaintType aType,
                       nscolor aFallbackColor);

  nscolor GetColor() const {
    MOZ_ASSERT(mType == eStyleSVGPaintType_Color);
    return mPaint.mColor;
  }

  mozilla::css::URLValue* GetPaintServer() const {
    MOZ_ASSERT(mType == eStyleSVGPaintType_Server);
    return mPaint.mPaintServer;
  }

  nscolor GetFallbackColor() const {
    MOZ_ASSERT(mType == eStyleSVGPaintType_Server ||
               mType == eStyleSVGPaintType_ContextFill ||
               mType == eStyleSVGPaintType_ContextStroke);
    return mFallbackColor;
  }

  bool operator==(const nsStyleSVGPaint& aOther) const;
  bool operator!=(const nsStyleSVGPaint& aOther) const {
    return !(*this == aOther);
  }

private:
  void Reset();
  void Assign(const nsStyleSVGPaint& aOther);

  union {
    nscolor mColor;
    mozilla::css::URLValue* mPaintServer;
  } mPaint;
  nsStyleSVGPaintType mType;
  nscolor mFallbackColor;
};

struct MOZ_NEEDS_MEMMOVABLE_MEMBERS nsStyleSVG
{
  explicit nsStyleSVG(StyleStructContext aContext);
  nsStyleSVG(const nsStyleSVG& aSource);
  ~nsStyleSVG();
  void FinishStyle(nsPresContext* aPresContext) {}

  void* operator new(size_t sz, nsStyleSVG* aSelf) { return aSelf; }
  void* operator new(size_t sz, nsPresContext* aContext) {
    return aContext->PresShell()->
      AllocateByObjectID(mozilla::eArenaObjectID_nsStyleSVG, sz);
  }
  void Destroy(nsPresContext* aContext) {
    this->~nsStyleSVG();
    aContext->PresShell()->
      FreeByObjectID(mozilla::eArenaObjectID_nsStyleSVG, this);
  }

  nsChangeHint CalcDifference(const nsStyleSVG& aNewData) const;
  static nsChangeHint MaxDifference() {
    return nsChangeHint_UpdateEffects |
           nsChangeHint_NeedReflow |
           nsChangeHint_NeedDirtyReflow | // XXX remove me: bug 876085
           nsChangeHint_RepaintFrame;
  }
  static nsChangeHint DifferenceAlwaysHandledForDescendants() {
    // CalcDifference never returns nsChangeHint_NeedReflow as a hint
    // not handled for descendants, and never returns
    // nsChangeHint_ClearAncestorIntrinsics at all.
    return nsChangeHint_NeedReflow;
  }

  nsStyleSVGPaint  mFill;             // [inherited]
  nsStyleSVGPaint  mStroke;           // [inherited]
  RefPtr<mozilla::css::URLValue> mMarkerEnd;   // [inherited]
  RefPtr<mozilla::css::URLValue> mMarkerMid;   // [inherited]
  RefPtr<mozilla::css::URLValue> mMarkerStart; // [inherited]
  nsTArray<nsStyleCoord> mStrokeDasharray;  // [inherited] coord, percent, factor

  nsStyleCoord     mStrokeDashoffset; // [inherited] coord, percent, factor
  nsStyleCoord     mStrokeWidth;      // [inherited] coord, percent, factor

  float            mFillOpacity;      // [inherited]
  float            mStrokeMiterlimit; // [inherited]
  float            mStrokeOpacity;    // [inherited]

  mozilla::StyleFillRule    mClipRule;  // [inherited]
  uint8_t          mColorInterpolation; // [inherited] see nsStyleConsts.h
  uint8_t          mColorInterpolationFilters; // [inherited] see nsStyleConsts.h
  mozilla::StyleFillRule    mFillRule;         // [inherited] see nsStyleConsts.h
  uint8_t          mPaintOrder;       // [inherited] see nsStyleConsts.h
  uint8_t          mShapeRendering;   // [inherited] see nsStyleConsts.h
  uint8_t          mStrokeLinecap;    // [inherited] see nsStyleConsts.h
  uint8_t          mStrokeLinejoin;   // [inherited] see nsStyleConsts.h
  uint8_t          mTextAnchor;       // [inherited] see nsStyleConsts.h

  nsStyleSVGOpacitySource FillOpacitySource() const {
    uint8_t value = (mContextFlags & FILL_OPACITY_SOURCE_MASK) >>
                    FILL_OPACITY_SOURCE_SHIFT;
    return nsStyleSVGOpacitySource(value);
  }
  nsStyleSVGOpacitySource StrokeOpacitySource() const {
    uint8_t value = (mContextFlags & STROKE_OPACITY_SOURCE_MASK) >>
                    STROKE_OPACITY_SOURCE_SHIFT;
    return nsStyleSVGOpacitySource(value);
  }
  bool StrokeDasharrayFromObject() const {
    return mContextFlags & STROKE_DASHARRAY_CONTEXT;
  }
  bool StrokeDashoffsetFromObject() const {
    return mContextFlags & STROKE_DASHOFFSET_CONTEXT;
  }
  bool StrokeWidthFromObject() const {
    return mContextFlags & STROKE_WIDTH_CONTEXT;
  }

  void SetFillOpacitySource(nsStyleSVGOpacitySource aValue) {
    mContextFlags = (mContextFlags & ~FILL_OPACITY_SOURCE_MASK) |
                    (aValue << FILL_OPACITY_SOURCE_SHIFT);
  }
  void SetStrokeOpacitySource(nsStyleSVGOpacitySource aValue) {
    mContextFlags = (mContextFlags & ~STROKE_OPACITY_SOURCE_MASK) |
                    (aValue << STROKE_OPACITY_SOURCE_SHIFT);
  }
  void SetStrokeDasharrayFromObject(bool aValue) {
    mContextFlags = (mContextFlags & ~STROKE_DASHARRAY_CONTEXT) |
                    (aValue ? STROKE_DASHARRAY_CONTEXT : 0);
  }
  void SetStrokeDashoffsetFromObject(bool aValue) {
    mContextFlags = (mContextFlags & ~STROKE_DASHOFFSET_CONTEXT) |
                    (aValue ? STROKE_DASHOFFSET_CONTEXT : 0);
  }
  void SetStrokeWidthFromObject(bool aValue) {
    mContextFlags = (mContextFlags & ~STROKE_WIDTH_CONTEXT) |
                    (aValue ? STROKE_WIDTH_CONTEXT : 0);
  }

  bool HasMarker() const {
    return mMarkerStart || mMarkerMid || mMarkerEnd;
  }

  /**
   * Returns true if the stroke is not "none" and the stroke-opacity is greater
   * than zero. This ignores stroke-widths as that depends on the context.
   */
  bool HasStroke() const {
    return mStroke.Type() != eStyleSVGPaintType_None && mStrokeOpacity > 0;
  }

  /**
   * Returns true if the fill is not "none" and the fill-opacity is greater
   * than zero.
   */
  bool HasFill() const {
    return mFill.Type() != eStyleSVGPaintType_None && mFillOpacity > 0;
  }

private:
  // Flags to represent the use of context-fill and context-stroke
  // for fill-opacity or stroke-opacity, and context-value for stroke-dasharray,
  // stroke-dashoffset and stroke-width.
  enum {
    FILL_OPACITY_SOURCE_MASK   = 0x03,  // fill-opacity: context-{fill,stroke}
    STROKE_OPACITY_SOURCE_MASK = 0x0C,  // stroke-opacity: context-{fill,stroke}
    STROKE_DASHARRAY_CONTEXT   = 0x10,  // stroke-dasharray: context-value
    STROKE_DASHOFFSET_CONTEXT  = 0x20,  // stroke-dashoffset: context-value
    STROKE_WIDTH_CONTEXT       = 0x40,  // stroke-width: context-value
    FILL_OPACITY_SOURCE_SHIFT   = 0,
    STROKE_OPACITY_SOURCE_SHIFT = 2,
  };

  uint8_t          mContextFlags;     // [inherited]
};

struct nsStyleFilter
{
  nsStyleFilter();
  nsStyleFilter(const nsStyleFilter& aSource);
  ~nsStyleFilter();
  void FinishStyle(nsPresContext* aPresContext) {}

  nsStyleFilter& operator=(const nsStyleFilter& aOther);

  bool operator==(const nsStyleFilter& aOther) const;
  bool operator!=(const nsStyleFilter& aOther) const {
    return !(*this == aOther);
  }

  uint32_t GetType() const {
    return mType;
  }

  const nsStyleCoord& GetFilterParameter() const {
    NS_ASSERTION(mType != NS_STYLE_FILTER_DROP_SHADOW &&
                 mType != NS_STYLE_FILTER_URL &&
                 mType != NS_STYLE_FILTER_NONE, "wrong filter type");
    return mFilterParameter;
  }
  void SetFilterParameter(const nsStyleCoord& aFilterParameter,
                          int32_t aType);

  mozilla::css::URLValue* GetURL() const {
    MOZ_ASSERT(mType == NS_STYLE_FILTER_URL, "wrong filter type");
    return mURL;
  }

  bool SetURL(mozilla::css::URLValue* aValue);

  nsCSSShadowArray* GetDropShadow() const {
    NS_ASSERTION(mType == NS_STYLE_FILTER_DROP_SHADOW, "wrong filter type");
    return mDropShadow;
  }
  void SetDropShadow(nsCSSShadowArray* aDropShadow);

private:
  void ReleaseRef();

  uint32_t mType; // see NS_STYLE_FILTER_* constants in nsStyleConsts.h
  nsStyleCoord mFilterParameter; // coord, percent, factor, angle
  union {
    mozilla::css::URLValue* mURL;
    nsCSSShadowArray* mDropShadow;
  };
};

template<>
struct nsTArray_CopyChooser<nsStyleFilter>
{
  typedef nsTArray_CopyWithConstructors<nsStyleFilter> Type;
};

struct MOZ_NEEDS_MEMMOVABLE_MEMBERS nsStyleSVGReset
{
  explicit nsStyleSVGReset(StyleStructContext aContext);
  nsStyleSVGReset(const nsStyleSVGReset& aSource);
  ~nsStyleSVGReset();

  // Resolves and tracks the images in mMask.  Only called with a Servo-backed
  // style system, where those images must be resolved later than the OMT
  // nsStyleSVGReset constructor call.
  void FinishStyle(nsPresContext* aPresContext);

  void* operator new(size_t sz, nsStyleSVGReset* aSelf) { return aSelf; }
  void* operator new(size_t sz, nsPresContext* aContext) {
    return aContext->PresShell()->
      AllocateByObjectID(mozilla::eArenaObjectID_nsStyleSVGReset, sz);
  }
  void Destroy(nsPresContext* aContext);

  nsChangeHint CalcDifference(const nsStyleSVGReset& aNewData) const;
  static nsChangeHint MaxDifference() {
    return nsChangeHint_UpdateEffects |
           nsChangeHint_UpdateOverflow |
           nsChangeHint_NeutralChange |
           nsChangeHint_RepaintFrame |
           nsChangeHint_UpdateBackgroundPosition |
           NS_STYLE_HINT_REFLOW;
  }
  static nsChangeHint DifferenceAlwaysHandledForDescendants() {
    // CalcDifference never returns the reflow hints that are sometimes
    // handled for descendants as hints not handled for descendants.
    return nsChangeHint_NeedReflow |
           nsChangeHint_ReflowChangesSizeOrPosition |
           nsChangeHint_ClearAncestorIntrinsics;
  }

  bool HasClipPath() const {
    return mClipPath.GetType() != mozilla::StyleShapeSourceType::None;
  }

  bool HasNonScalingStroke() const {
    return mVectorEffect == NS_STYLE_VECTOR_EFFECT_NON_SCALING_STROKE;
  }

  nsStyleImageLayers    mMask;
  mozilla::StyleClipPath mClipPath;   // [reset]
  nscolor          mStopColor;        // [reset]
  nscolor          mFloodColor;       // [reset]
  nscolor          mLightingColor;    // [reset]

  float            mStopOpacity;      // [reset]
  float            mFloodOpacity;     // [reset]

  uint8_t          mDominantBaseline; // [reset] see nsStyleConsts.h
  uint8_t          mVectorEffect;     // [reset] see nsStyleConsts.h
  uint8_t          mMaskType;         // [reset] see nsStyleConsts.h
};

struct MOZ_NEEDS_MEMMOVABLE_MEMBERS nsStyleVariables
{
  explicit nsStyleVariables(StyleStructContext aContext);
  nsStyleVariables(const nsStyleVariables& aSource);
  ~nsStyleVariables();
  void FinishStyle(nsPresContext* aPresContext) {}

  void* operator new(size_t sz, nsStyleVariables* aSelf) { return aSelf; }
  void* operator new(size_t sz, nsPresContext* aContext) {
    return aContext->PresShell()->
      AllocateByObjectID(mozilla::eArenaObjectID_nsStyleVariables, sz);
  }
  void Destroy(nsPresContext* aContext) {
    this->~nsStyleVariables();
    aContext->PresShell()->
      FreeByObjectID(mozilla::eArenaObjectID_nsStyleVariables, this);
  }

  nsChangeHint CalcDifference(const nsStyleVariables& aNewData) const;
  static nsChangeHint MaxDifference() {
    return nsChangeHint(0);
  }
  static nsChangeHint DifferenceAlwaysHandledForDescendants() {
    // CalcDifference never returns nsChangeHint_NeedReflow or
    // nsChangeHint_ClearAncestorIntrinsics at all.
    return nsChangeHint(0);
  }

  mozilla::CSSVariableValues mVariables;
};

struct MOZ_NEEDS_MEMMOVABLE_MEMBERS nsStyleEffects
{
  explicit nsStyleEffects(StyleStructContext aContext);
  nsStyleEffects(const nsStyleEffects& aSource);
  ~nsStyleEffects();
  void FinishStyle(nsPresContext* aPresContext) {}

  void* operator new(size_t sz, nsStyleEffects* aSelf) { return aSelf; }
  void* operator new(size_t sz, nsPresContext* aContext) {
    return aContext->PresShell()->
      AllocateByObjectID(mozilla::eArenaObjectID_nsStyleEffects, sz);
  }
  void Destroy(nsPresContext* aContext) {
    this->~nsStyleEffects();
    aContext->PresShell()->
      FreeByObjectID(mozilla::eArenaObjectID_nsStyleEffects, this);
  }

  nsChangeHint CalcDifference(const nsStyleEffects& aNewData) const;
  static nsChangeHint MaxDifference() {
    return nsChangeHint_AllReflowHints |
           nsChangeHint_UpdateOverflow |
           nsChangeHint_SchedulePaint |
           nsChangeHint_RepaintFrame |
           nsChangeHint_UpdateOpacityLayer |
           nsChangeHint_UpdateUsesOpacity |
           nsChangeHint_UpdateContainingBlock |
           nsChangeHint_UpdateEffects |
           nsChangeHint_NeutralChange;
  }
  static nsChangeHint DifferenceAlwaysHandledForDescendants() {
    // CalcDifference never returns the reflow hints that are sometimes
    // handled for descendants as hints not handled for descendants.
    return nsChangeHint_NeedReflow |
           nsChangeHint_ReflowChangesSizeOrPosition |
           nsChangeHint_ClearAncestorIntrinsics;
  }

  bool HasFilters() const {
    return !mFilters.IsEmpty();
  }

  nsTArray<nsStyleFilter>  mFilters;   // [reset]
  RefPtr<nsCSSShadowArray> mBoxShadow; // [reset] nullptr for 'none'
  nsRect  mClip;                       // [reset] offsets from UL border edge
  float   mOpacity;                    // [reset]
  uint8_t mClipFlags;                  // [reset] see nsStyleConsts.h
  uint8_t mMixBlendMode;               // [reset] see nsStyleConsts.h
};

#define STATIC_ASSERT_TYPE_LAYOUTS_MATCH(T1, T2)                               \
  static_assert(sizeof(T1) == sizeof(T2),                                      \
      "Size mismatch between " #T1 " and " #T2);                               \
  static_assert(alignof(T1) == alignof(T2),                                    \
      "Align mismatch between " #T1 " and " #T2);                              \

#define STATIC_ASSERT_FIELD_OFFSET_MATCHES(T1, T2, field)                      \
  static_assert(offsetof(T1, field) == offsetof(T2, field),                    \
      "Field offset mismatch of " #field " between " #T1 " and " #T2);         \

/**
 * These *_Simple types are used to map Gecko types to layout-equivalent but
 * simpler Rust types, to aid Rust binding generation.
 *
 * If something in this types or the assertions below needs to change, ask
 * bholley, heycam or emilio before!
 *
 * <div rustbindgen="true" replaces="nsPoint">
 */
struct nsPoint_Simple {
  nscoord x, y;
};

STATIC_ASSERT_TYPE_LAYOUTS_MATCH(nsPoint, nsPoint_Simple);
STATIC_ASSERT_FIELD_OFFSET_MATCHES(nsPoint, nsPoint_Simple, x);
STATIC_ASSERT_FIELD_OFFSET_MATCHES(nsPoint, nsPoint_Simple, y);

/**
 * <div rustbindgen="true" replaces="nsMargin">
 */
struct nsMargin_Simple {
  nscoord top, right, bottom, left;
};

STATIC_ASSERT_TYPE_LAYOUTS_MATCH(nsMargin, nsMargin_Simple);
STATIC_ASSERT_FIELD_OFFSET_MATCHES(nsMargin, nsMargin_Simple, top);
STATIC_ASSERT_FIELD_OFFSET_MATCHES(nsMargin, nsMargin_Simple, right);
STATIC_ASSERT_FIELD_OFFSET_MATCHES(nsMargin, nsMargin_Simple, bottom);
STATIC_ASSERT_FIELD_OFFSET_MATCHES(nsMargin, nsMargin_Simple, left);

/**
 * <div rustbindgen="true" replaces="nsRect">
 */
struct nsRect_Simple {
  nscoord x, y, width, height;
};

STATIC_ASSERT_TYPE_LAYOUTS_MATCH(nsRect, nsRect_Simple);
STATIC_ASSERT_FIELD_OFFSET_MATCHES(nsRect, nsRect_Simple, x);
STATIC_ASSERT_FIELD_OFFSET_MATCHES(nsRect, nsRect_Simple, y);
STATIC_ASSERT_FIELD_OFFSET_MATCHES(nsRect, nsRect_Simple, width);
STATIC_ASSERT_FIELD_OFFSET_MATCHES(nsRect, nsRect_Simple, height);

/**
 * <div rustbindgen="true" replaces="nsSize">
 */
struct nsSize_Simple {
  nscoord width, height;
};

STATIC_ASSERT_TYPE_LAYOUTS_MATCH(nsSize, nsSize_Simple);
STATIC_ASSERT_FIELD_OFFSET_MATCHES(nsSize, nsSize_Simple, width);
STATIC_ASSERT_FIELD_OFFSET_MATCHES(nsSize, nsSize_Simple, height);

/**
 * <div rustbindgen="true" replaces="UniquePtr">
 *
 * TODO(Emilio): This is a workaround and we should be able to get rid of this
 * one.
 */
template<typename T, typename Deleter = mozilla::DefaultDelete<T>>
struct UniquePtr_Simple {
  T* mPtr;
};

STATIC_ASSERT_TYPE_LAYOUTS_MATCH(mozilla::UniquePtr<int>, UniquePtr_Simple<int>);

/**
 * <div rustbindgen replaces="nsTArray"></div>
 */
template<typename T>
class nsTArray_Simple {
  T* mBuffer;
public:
  // The existence of a destructor here prevents bindgen from deriving the Clone
  // trait via a simple memory copy.
  ~nsTArray_Simple() {};
};

STATIC_ASSERT_TYPE_LAYOUTS_MATCH(nsTArray<nsStyleImageLayers::Layer>,
                                 nsTArray_Simple<nsStyleImageLayers::Layer>);
STATIC_ASSERT_TYPE_LAYOUTS_MATCH(nsTArray<mozilla::StyleTransition>,
                                 nsTArray_Simple<mozilla::StyleTransition>);
STATIC_ASSERT_TYPE_LAYOUTS_MATCH(nsTArray<mozilla::StyleAnimation>,
                                 nsTArray_Simple<mozilla::StyleAnimation>);

#endif /* nsStyleStruct_h___ */
