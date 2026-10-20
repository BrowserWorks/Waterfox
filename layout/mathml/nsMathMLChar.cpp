/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsMathMLChar.h"

#include <algorithm>
#include <numeric>

#include "gfxContext.h"
#include "gfxMathTable.h"
#include "gfxTextRun.h"
#include "gfxUtils.h"
#include "mozilla/BinarySearch.h"
#include "mozilla/ComputedStyle.h"
#include "mozilla/LookAndFeel.h"
#include "mozilla/MathAlgorithms.h"
#include "mozilla/Sprintf.h"
#include "mozilla/StaticPrefs_mathml.h"
#include "mozilla/UniquePtr.h"
#include "mozilla/dom/Document.h"
#include "mozilla/gfx/2D.h"
#include "mozilla/intl/UnicodeScriptCodes.h"
#include "nsCSSRendering.h"
#include "nsContentUtils.h"
#include "nsDeviceContext.h"
#include "nsDisplayList.h"
#include "nsFontMetrics.h"
#include "nsIFrame.h"
#include "nsIObserver.h"
#include "nsIObserverService.h"
#include "nsLayoutUtils.h"
#include "nsMathMLOperators.h"
#include "nsNetUtil.h"
#include "nsPresContext.h"
#include "nsUnicharUtils.h"

using namespace mozilla;
using namespace mozilla::gfx;
using namespace mozilla::image;

// #define NOISY_SEARCH 1

// BUG 848725 Drawing failure with stretchy horizontal parenthesis when no fonts
// are installed. "kMaxScaleFactor" is required to limit the scale for the
// vertical and horizontal stretchy operators.
static const float kMaxScaleFactor = 20.0;
static const float kLargeOpFactor = float(M_SQRT2);
static const float kIntegralFactor = 2.0;

static void NormalizeDefaultFont(nsFont& aFont, float aFontSizeInflation) {
  aFont.size.ScaleBy(aFontSizeInflation);
}

// -----------------------------------------------------------------------------
static const nsGlyphCode kNullGlyph = {{0}, false};

// -----------------------------------------------------------------------------
// nsGlyphTable is a class that provides an interface for accessing glyphs
// of stretchy chars. It acts like a table that stores the variants of bigger
// sizes (if any) and the partial glyphs needed to build extensible symbols.
//
// Bigger sizes (if any) of the char can then be retrieved with BigOf(...).
// Partial glyphs can be retrieved with ElementAt(...).
//
// A table consists of "nsGlyphCode"s which are viewed either as Unicode
// points (for nsUnicodeTable) or as direct glyph indices (for
// nsOpenTypeTable)
// -----------------------------------------------------------------------------

class nsGlyphTable {
 public:
  virtual ~nsGlyphTable() = default;
  virtual bool IsUnicodeTable() const { return false; }

  virtual const nsCString& FontNameFor(const nsGlyphCode& aGlyphCode) const = 0;

  // Getters for the parts
  virtual nsGlyphCode ElementAt(DrawTarget* aDrawTarget,
                                int32_t aAppUnitsPerDevPixel,
                                gfxFontGroup* aFontGroup, char16_t aChar,
                                bool aVertical, uint32_t aPosition) = 0;
  virtual nsGlyphCode BigOf(DrawTarget* aDrawTarget,
                            int32_t aAppUnitsPerDevPixel,
                            gfxFontGroup* aFontGroup, char16_t aChar,
                            bool aVertical, uint32_t aSize) = 0;

  // True if this table contains parts to render this char
  virtual bool HasPartsOf(DrawTarget* aDrawTarget, int32_t aAppUnitsPerDevPixel,
                          gfxFontGroup* aFontGroup, char16_t aChar,
                          bool aVertical) = 0;

  virtual already_AddRefed<gfxTextRun> MakeTextRun(
      DrawTarget* aDrawTarget, int32_t aAppUnitsPerDevPixel,
      gfxFontGroup* aFontGroup, const nsGlyphCode& aGlyph) = 0;

 protected:
  // For speedy re-use, we always cache the last data used in the table.
  // mCharCache is the Unicode point of the last char that was queried in this
  // table.
  char16_t mCharCache = 0;
};

// A Unicode construction is a set of all the stretchy MathML characters that
// can be rendered with Unicode using larger and/or partial glyphs. The entry
// of each stretchy character gives the 4 partial glyphs and the variants of
// bigger sizes (if any):
// Base | Top (or Left) | Middle | Bottom (or Right) | Glue | Size 0 | Size 1
// A position that is not relevant to a particular character is indicated there
// with the UNICODE REPLACEMENT CHARACTER 0xFFFD.
// FIXME: This table was converted from the original mathfontUnicode.properties
// in bug 1007090. It has been unchanged for backward compatibility but probably
// at some point this should be standardized and implemented cross-browser.
// See also https://w3c.github.io/mathml-core/#unicode-based-glyph-assemblies
typedef char16_t const UnicodeConstruction[7];
// clang-format off
static const UnicodeConstruction gUnicodeTableConstructions[] = {
  { 0x0028, 0x239B, 0x0000, 0x239D, 0x239C, 0x0028, 0x0000 },
  { 0x0029, 0x239E, 0x0000, 0x23A0, 0x239F, 0x0029, 0x0000 },
  { 0x003D, 0x0000, 0x0000, 0x0000, 0x003D, 0x003D, 0x0000 },
  { 0x005B, 0x23A1, 0x0000, 0x23A3, 0x23A2, 0x005B, 0x0000 },
  { 0x005D, 0x23A4, 0x0000, 0x23A6, 0x23A5, 0x005D, 0x0000 },
  { 0x005F, 0x0000, 0x0000, 0x0000, 0x0332, 0x0332, 0x0000 },
  { 0x007B, 0x23A7, 0x23A8, 0x23A9, 0x23AA, 0x007B, 0x0000 },
  { 0x007C, 0x0000, 0x0000, 0x0000, 0x007C, 0x007C, 0x0000 },
  { 0x007D, 0x23AB, 0x23AC, 0x23AD, 0x23AA, 0x007D, 0x0000 },
  { 0x00AF, 0x0000, 0x0000, 0x0000, 0x0305, 0x00AF, 0x0000 },
  { 0x0332, 0x0000, 0x0000, 0x0000, 0x0332, 0x0332, 0x0000 },
  { 0x2016, 0x0000, 0x0000, 0x0000, 0x2016, 0x2016, 0x0000 },
  { 0x203E, 0x0000, 0x0000, 0x0000, 0x0305, 0x00AF, 0x0000 },
  { 0x2190, 0x2190, 0x0000, 0x0000, 0x23AF, 0x2190, 0x27F5 },
  { 0x2191, 0x2191, 0x0000, 0x0000, 0x23D0, 0x2191, 0x0000 },
  { 0x2192, 0x0000, 0x0000, 0x2192, 0x23AF, 0x2192, 0x27F6 },
  { 0x2193, 0x0000, 0x0000, 0x2193, 0x23D0, 0x2193, 0x0000 },
  { 0x2194, 0x2190, 0x0000, 0x2192, 0x23AF, 0x2194, 0x27F7 },
  { 0x2195, 0x2191, 0x0000, 0x2193, 0x23D0, 0x2195, 0x0000 },
  { 0x21A4, 0x2190, 0x0000, 0x22A3, 0x23AF, 0x21AA, 0x27FB },
  { 0x21A6, 0x22A2, 0x0000, 0x2192, 0x23AF, 0x21A6, 0x27FC },
  { 0x21BC, 0x21BC, 0x0000, 0x0000, 0x23AF, 0x21BC, 0x0000 },
  { 0x21BD, 0x21BD, 0x0000, 0x0000, 0x23AF, 0x21BD, 0x0000 },
  { 0x21C0, 0x0000, 0x0000, 0x21C0, 0x23AF, 0x21C0, 0x0000 },
  { 0x21C1, 0x0000, 0x0000, 0x21C1, 0x23AF, 0x21C1, 0x0000 },
  { 0x21D0, 0x0000, 0x0000, 0x0000, 0x0000, 0x21D0, 0x27F8 },
  { 0x21D2, 0x0000, 0x0000, 0x0000, 0x0000, 0x21D2, 0x27F9 },
  { 0x21D4, 0x0000, 0x0000, 0x0000, 0x0000, 0x21D4, 0x27FA },
  { 0x2223, 0x0000, 0x0000, 0x0000, 0x2223, 0x2223, 0x0000 },
  { 0x2225, 0x0000, 0x0000, 0x0000, 0x2225, 0x2225, 0x0000 },
  { 0x222B, 0x2320, 0x0000, 0x2321, 0x23AE, 0x222B, 0x0000 },
  { 0x2308, 0x23A1, 0x0000, 0x0000, 0x23A2, 0x2308, 0x0000 },
  { 0x2309, 0x23A4, 0x0000, 0x0000, 0x23A5, 0x2309, 0x0000 },
  { 0x230A, 0x0000, 0x0000, 0x23A3, 0x23A2, 0x230A, 0x0000 },
  { 0x230B, 0x0000, 0x0000, 0x23A6, 0x23A5, 0x230B, 0x0000 },
  { 0x23B0, 0x23A7, 0x0000, 0x23AD, 0x23AA, 0x23B0, 0x0000 },
  { 0x23B1, 0x23AB, 0x0000, 0x23A9, 0x23AA, 0x23B1, 0x0000 },
  { 0x27F5, 0x2190, 0x0000, 0x0000, 0x23AF, 0x27F5, 0x0000 },
  { 0x27F6, 0x0000, 0x0000, 0x2192, 0x23AF, 0x27F6, 0x0000 },
  { 0x27F7, 0x2190, 0x0000, 0x2192, 0x23AF, 0x27F7, 0x0000 },
  { 0x294E, 0x21BC, 0x0000, 0x21C0, 0x23AF, 0x294E, 0x0000 },
  { 0x2950, 0x21BD, 0x0000, 0x21C1, 0x23AF, 0x2950, 0x0000 },
  { 0x295A, 0x21BC, 0x0000, 0x22A3, 0x23AF, 0x295A, 0x0000 },
  { 0x295B, 0x22A2, 0x0000, 0x21C0, 0x23AF, 0x295B, 0x0000 },
  { 0x295E, 0x21BD, 0x0000, 0x22A3, 0x23AF, 0x295E, 0x0000 },
  { 0x295F, 0x22A2, 0x0000, 0x21C1, 0x23AF, 0x295F, 0x0000 },
};
// clang-format on

class nsUnicodeTable final : public nsGlyphTable {
 public:
  constexpr nsUnicodeTable() = default;

  bool IsUnicodeTable() const final { return true; };

  const nsCString& FontNameFor(const nsGlyphCode& aGlyphCode) const override {
    MOZ_ASSERT_UNREACHABLE();
    return VoidCString();
  }

  virtual nsGlyphCode ElementAt(DrawTarget* aDrawTarget,
                                int32_t aAppUnitsPerDevPixel,
                                gfxFontGroup* aFontGroup, char16_t aChar,
                                bool aVertical, uint32_t aPosition) override;

  virtual nsGlyphCode BigOf(DrawTarget* aDrawTarget,
                            int32_t aAppUnitsPerDevPixel,
                            gfxFontGroup* aFontGroup, char16_t aChar,
                            bool aVertical, uint32_t aSize) override {
    return ElementAt(aDrawTarget, aAppUnitsPerDevPixel, aFontGroup, aChar,
                     aVertical, 4 + aSize);
  }

  virtual bool HasPartsOf(DrawTarget* aDrawTarget, int32_t aAppUnitsPerDevPixel,
                          gfxFontGroup* aFontGroup, char16_t aChar,
                          bool aVertical) override {
    return (ElementAt(aDrawTarget, aAppUnitsPerDevPixel, aFontGroup, aChar,
                      aVertical, 0)
                .Exists() ||
            ElementAt(aDrawTarget, aAppUnitsPerDevPixel, aFontGroup, aChar,
                      aVertical, 1)
                .Exists() ||
            ElementAt(aDrawTarget, aAppUnitsPerDevPixel, aFontGroup, aChar,
                      aVertical, 2)
                .Exists() ||
            ElementAt(aDrawTarget, aAppUnitsPerDevPixel, aFontGroup, aChar,
                      aVertical, 3)
                .Exists());
  }

  virtual already_AddRefed<gfxTextRun> MakeTextRun(
      DrawTarget* aDrawTarget, int32_t aAppUnitsPerDevPixel,
      gfxFontGroup* aFontGroup, const nsGlyphCode& aGlyph) override;

  // Not available for the heap!
  void* operator new(size_t) = delete;
  void* operator new[](size_t) = delete;

 private:
  struct UnicodeConstructionComparator {
    int operator()(const UnicodeConstruction& aValue) const {
      if (mTarget < aValue[0]) {
        return -1;
      }
      if (mTarget > aValue[0]) {
        return 1;
      }
      return 0;
    }
    explicit UnicodeConstructionComparator(char16_t aTarget)
        : mTarget(aTarget) {}
    const char16_t mTarget;
  };
  size_t mCachedIndex = 0;
};

static constinit nsUnicodeTable gUnicodeTable;

/* virtual */
nsGlyphCode nsUnicodeTable::ElementAt(DrawTarget* /* aDrawTarget */,
                                      int32_t /* aAppUnitsPerDevPixel */,
                                      gfxFontGroup* /* aFontGroup */,
                                      char16_t aChar, bool /* aVertical */,
                                      uint32_t aPosition) {
  // Update our cache if it is not associated to this character
  if (mCharCache != aChar) {
    size_t match;
    if (!BinarySearchIf(gUnicodeTableConstructions, 0,
                        std::size(gUnicodeTableConstructions),
                        UnicodeConstructionComparator(aChar), &match)) {
      return kNullGlyph;
    }
    // update our cache with the new settings
    mCachedIndex = match;
    mCharCache = aChar;
  }

  const UnicodeConstruction& construction =
      gUnicodeTableConstructions[mCachedIndex];
  if (aPosition + 1 >= std::size(construction)) {
    return kNullGlyph;
  }
  nsGlyphCode ch;
  ch.code = construction[aPosition + 1];
  ch.isGlyphID = false;
  return ch.code == char16_t(0xFFFD) ? kNullGlyph : ch;
}

/* virtual */
already_AddRefed<gfxTextRun> nsUnicodeTable::MakeTextRun(
    DrawTarget* aDrawTarget, int32_t aAppUnitsPerDevPixel,
    gfxFontGroup* aFontGroup, const nsGlyphCode& aGlyph) {
  NS_ASSERTION(!aGlyph.isGlyphID,
               "nsUnicodeTable can only access glyphs by code point");
  return aFontGroup->MakeTextRun(&aGlyph.code, 1, aDrawTarget,
                                 aAppUnitsPerDevPixel, gfx::ShapedTextFlags(),
                                 nsTextFrameUtils::Flags(), nullptr);
}

// An instance of nsOpenTypeTable is associated with one gfxFontEntry that
// corresponds to an Open Type font with a MATH table. All the glyphs come from
// the same font and the calls to access size variants and parts are directly
// forwarded to the gfx code.
class nsOpenTypeTable final : public nsGlyphTable {
 public:
  MOZ_COUNTED_DTOR(nsOpenTypeTable)

  virtual nsGlyphCode ElementAt(DrawTarget* aDrawTarget,
                                int32_t aAppUnitsPerDevPixel,
                                gfxFontGroup* aFontGroup, char16_t aChar,
                                bool aVertical, uint32_t aPosition) override;
  virtual nsGlyphCode BigOf(DrawTarget* aDrawTarget,
                            int32_t aAppUnitsPerDevPixel,
                            gfxFontGroup* aFontGroup, char16_t aChar,
                            bool aVertical, uint32_t aSize) override;
  virtual bool HasPartsOf(DrawTarget* aDrawTarget, int32_t aAppUnitsPerDevPixel,
                          gfxFontGroup* aFontGroup, char16_t aChar,
                          bool aVertical) override;

  const nsCString& FontNameFor(const nsGlyphCode& aGlyphCode) const override {
    NS_ASSERTION(aGlyphCode.isGlyphID,
                 "nsOpenTypeTable can only access glyphs by id");
    return mFontFamilyName;
  }

  virtual already_AddRefed<gfxTextRun> MakeTextRun(
      DrawTarget* aDrawTarget, int32_t aAppUnitsPerDevPixel,
      gfxFontGroup* aFontGroup, const nsGlyphCode& aGlyph) override;

  // This returns a new OpenTypeTable instance to give access to OpenType MATH
  // table or nullptr if the font does not have such table. Ownership is passed
  // to the caller.
  static UniquePtr<nsOpenTypeTable> Create(gfxFont* aFont,
                                           gfx::ShapedTextFlags aFlags) {
    if (!aFont->TryGetMathTable()) {
      return nullptr;
    }
    return WrapUnique(new nsOpenTypeTable(aFont, aFlags));
  }

 private:
  RefPtr<gfxFont> mFont;
  nsCString mFontFamilyName;
  uint32_t mGlyphID;
  gfx::ShapedTextFlags mFlags;

  nsOpenTypeTable(gfxFont* aFont, gfx::ShapedTextFlags aFlags)
      : mFont(aFont),
        mFontFamilyName(aFont->GetFontEntry()->FamilyName()),
        mGlyphID(0),
        mFlags(aFlags) {
    MOZ_COUNT_CTOR(nsOpenTypeTable);
  }

  void UpdateCache(DrawTarget* aDrawTarget, int32_t aAppUnitsPerDevPixel,
                   gfxFontGroup* aFontGroup, char16_t aChar);

  bool IsRtl() const {
    return bool(mFlags & gfx::ShapedTextFlags::TEXT_IS_RTL);
  };
};

void nsOpenTypeTable::UpdateCache(DrawTarget* aDrawTarget,
                                  int32_t aAppUnitsPerDevPixel,
                                  gfxFontGroup* aFontGroup, char16_t aChar) {
  if (mCharCache != aChar) {
    RefPtr<gfxTextRun> textRun =
        aFontGroup->MakeTextRun(&aChar, 1, aDrawTarget, aAppUnitsPerDevPixel,
                                mFlags, nsTextFrameUtils::Flags(), nullptr);
    const gfxTextRun::CompressedGlyph& data = textRun->GetCharacterGlyphs()[0];
    if (data.IsSimpleGlyph()) {
      mGlyphID = data.GetSimpleGlyph();
    } else if (data.GetGlyphCount() == 1) {
      mGlyphID = textRun->GetDetailedGlyphs(0, 1)->mGlyphID;
    } else {
      mGlyphID = 0;
    }
    mCharCache = aChar;
  }
}

/* virtual */
nsGlyphCode nsOpenTypeTable::ElementAt(DrawTarget* aDrawTarget,
                                       int32_t aAppUnitsPerDevPixel,
                                       gfxFontGroup* aFontGroup, char16_t aChar,
                                       bool aVertical, uint32_t aPosition) {
  UpdateCache(aDrawTarget, aAppUnitsPerDevPixel, aFontGroup, aChar);

  uint32_t parts[4];
  if (!mFont->MathTable()->VariantsParts(mGlyphID, aVertical, IsRtl(), parts)) {
    return kNullGlyph;
  }

  uint32_t glyphID = parts[aPosition];
  if (!glyphID) {
    return kNullGlyph;
  }
  nsGlyphCode glyph;
  glyph.glyphID = glyphID;
  glyph.isGlyphID = true;
  return glyph;
}

/* virtual */
nsGlyphCode nsOpenTypeTable::BigOf(DrawTarget* aDrawTarget,
                                   int32_t aAppUnitsPerDevPixel,
                                   gfxFontGroup* aFontGroup, char16_t aChar,
                                   bool aVertical, uint32_t aSize) {
  UpdateCache(aDrawTarget, aAppUnitsPerDevPixel, aFontGroup, aChar);

  uint32_t glyphID =
      mFont->MathTable()->VariantsSize(mGlyphID, aVertical, IsRtl(), aSize);
  if (!glyphID) {
    return kNullGlyph;
  }

  nsGlyphCode glyph;
  glyph.glyphID = glyphID;
  glyph.isGlyphID = true;
  return glyph;
}

/* virtual */
bool nsOpenTypeTable::HasPartsOf(DrawTarget* aDrawTarget,
                                 int32_t aAppUnitsPerDevPixel,
                                 gfxFontGroup* aFontGroup, char16_t aChar,
                                 bool aVertical) {
  UpdateCache(aDrawTarget, aAppUnitsPerDevPixel, aFontGroup, aChar);

  uint32_t parts[4];
  if (!mFont->MathTable()->VariantsParts(mGlyphID, aVertical, IsRtl(), parts)) {
    return false;
  }

  return parts[0] || parts[1] || parts[2] || parts[3];
}

/* virtual */
already_AddRefed<gfxTextRun> nsOpenTypeTable::MakeTextRun(
    DrawTarget* aDrawTarget, int32_t aAppUnitsPerDevPixel,
    gfxFontGroup* aFontGroup, const nsGlyphCode& aGlyph) {
  NS_ASSERTION(aGlyph.isGlyphID,
               "nsOpenTypeTable can only access glyphs by id");

  gfxTextRunFactory::Parameters params = {
      aDrawTarget, nullptr, nullptr, nullptr, 0, aAppUnitsPerDevPixel};
  RefPtr<gfxTextRun> textRun = gfxTextRun::Create(
      &params, 1, aFontGroup, mFlags, nsTextFrameUtils::Flags());
  RefPtr<gfxFont> font = aFontGroup->GetFirstValidFont();
  textRun->AddGlyphRun(font, FontMatchType::Kind::kFontGroup, 0, false,
                       gfx::ShapedTextFlags::TEXT_ORIENT_HORIZONTAL, false);
  // We don't care about CSS writing mode here;
  // math runs are assumed to be horizontal.
  gfxTextRun::DetailedGlyph detailedGlyph;
  detailedGlyph.mGlyphID = aGlyph.glyphID;
  detailedGlyph.mAdvance = NSToCoordRound(
      aAppUnitsPerDevPixel * font->GetGlyphAdvance(aGlyph.glyphID));
  textRun->SetDetailedGlyphs(0, 1, &detailedGlyph);

  return textRun.forget();
}

// -----------------------------------------------------------------------------
// And now the implementation of nsMathMLChar

nsMathMLChar::~nsMathMLChar() { MOZ_COUNT_DTOR(nsMathMLChar); }

void nsMathMLChar::SetComputedStyle(ComputedStyle* aComputedStyle) {
  MOZ_ASSERT(aComputedStyle);
  mComputedStyle = aComputedStyle;
}

void nsMathMLChar::SetData(nsString& aData) {
  mData = aData;
  // some assumptions until proven otherwise
  // note that mGlyph is not initialized
  mDirection = StretchDirection::Unsupported;
  mBoundingMetrics = nsBoundingMetrics();
  // check if stretching is applicable ...
  if (1 == mData.Length()) {
    mDirection = nsMathMLOperators::GetStretchyDirection(mData);
    // default tentative table (not the one that is necessarily going
    // to be used)
  }
}

// -----------------------------------------------------------------------------
/*
 The Stretch:
 @param aContainerSize - suggested size for the stretched char
 @param aDesiredStretchSize - OUT parameter. The desired size
 after stretching. If no stretching is done, the output will
 simply give the base size.

 How it works?
 Summary:-
 The Stretch() method first looks for a glyph of appropriate
 size; If a glyph is found, it is cached by this object and
 its size is returned in aDesiredStretchSize. The cached
 glyph will then be used at the painting stage.
 If no glyph of appropriate size is found, a search is made
 to see if the char can be built by parts.

 Details:-
 A character gets stretched through the following pipeline :

 1) If the base size of the char is sufficient to cover the
    container' size, we use that. If not, it will still be
    used as a fallback if the other stages in the pipeline fail.
    Issues :
    a) The base size, the parts and the variants of a char can
       be in different fonts. For eg., the base size for '(' should
       come from a normal ascii font if CMEX10 is used, since CMEX10
       only contains the stretched versions. Hence, there are two
       ComputedStyles in use throughout the process. The leaf style
       context of the char holds fonts with which to try to stretch
       the char. The parent ComputedStyle of the char contains fonts
       for normal rendering. So the parent context is the one used
       to get the initial base size at the start of the pipeline.
    b) For operators that can be largeop's in display mode,
       we will skip the base size even if it fits, so that
       the next stage in the pipeline is given a chance to find
       a largeop variant. If the next stage fails, we fallback
       to the base size.

 2) We search for the first larger variant of the char that fits the
    container' size.  We first search for larger variants using the glyph
    table corresponding to the first existing font specified in the list of
    stretchy fonts held by the leaf ComputedStyle (from -moz-math-stretchy in
    mathml.css).  Generic fonts are resolved by the preference
    "font.mathfont-family".
    Issues :
    a) the largeop and display settings determine the starting
       size when we do the above search, regardless of whether
       smaller variants already fit the container' size.
    b) if it is a largeopOnly request (i.e., a displaystyle operator
       with largeop=true and stretchy=false), we break after finding
       the first starting variant, regardless of whether that
       variant fits the container's size.

 3) If a variant of appropriate size wasn't found, we see if the char
    can be built by parts using the same glyph table.
    Issue:
       There are chars that have no middle and glue glyphs. For
       such chars, the parts need to be joined using the rule.
       By convention (TeXbook p.225), the descent of the parts is
       zero while their ascent gives the thickness of the rule that
       should be used to join them.

 4) If a match was not found in that glyph table, repeat from 2 to search the
    ordered list of stretchy fonts for the first font with a glyph table that
    provides a fit to the container size.  If no fit is found, the closest fit
    is used.

 Of note:
 When the pipeline completes successfully, the desired size of the
 stretched char can actually be slightly larger or smaller than
 aContainerSize. But it is the responsibility of the caller to
 account for the spacing when setting aContainerSize, and to leave
 any extra margin when placing the stretched char.
*/
// -----------------------------------------------------------------------------

// plain TeX settings (TeXbook p.152)
static constexpr float kMathMLDelimiterFactor = 0.901;
static constexpr float kMathMLDelimiterShortfallPoints = 5.0;

static bool IsSizeOK(nscoord a, nscoord b, MathMLStretchFlags aStretchFlags) {
  // Normal: True if 'a' is around +/-10% of the target 'b' (10% is
  // 1-DelimiterFactor). This often gives a chance to the base size to
  // win, especially in the context of sloppy markups without protective
  // <mrow></mrow>
  bool isNormal =
      (aStretchFlags.contains(MathMLStretchFlag::Normal)) &&
      Abs<float>(a - b) < (1.0f - kMathMLDelimiterFactor) * float(b);

  // Nearer: True if 'a' is around max{ +/-10% of 'b' , 'b' - 5pt },
  // as documented in The TeXbook, Ch.17, p.152.
  // i.e. within 10% and within 5pt
  bool isNearer = false;
  if (aStretchFlags.contains(MathMLStretchFlag::Nearer) ||
      aStretchFlags.contains(MathMLStretchFlag::LargeOperator)) {
    float c = std::max(float(b) * kMathMLDelimiterFactor,
                       float(b) - nsPresContext::CSSPointsToAppUnits(
                                      kMathMLDelimiterShortfallPoints));
    isNearer = Abs<float>(b - a) <= float(b) - c;
  }

  // Smaller: Mainly for transitory use, to compare two candidate
  // choices
  bool isSmaller = aStretchFlags.contains(MathMLStretchFlag::Smaller) &&
                   float(a) >= kMathMLDelimiterFactor * float(b) && a <= b;

  // Larger: Critical to the sqrt code to ensure that the radical
  // size is tall enough
  bool isLarger = (aStretchFlags.contains(MathMLStretchFlag::Larger) ||
                   aStretchFlags.contains(MathMLStretchFlag::LargeOperator)) &&
                  a >= b;

  return (isNormal || isSmaller || isNearer || isLarger);
}

static bool IsSizeBetter(nscoord a, nscoord olda, nscoord b,
                         MathMLStretchFlags aStretchFlags) {
  if (0 == olda) {
    return true;
  }
  if (aStretchFlags.contains(MathMLStretchFlag::Larger) ||
      aStretchFlags.contains(MathMLStretchFlag::LargeOperator)) {
    return (a >= olda) ? (olda < b) : (a >= b);
  }
  if (aStretchFlags.contains(MathMLStretchFlag::Smaller)) {
    return (a <= olda) ? (olda > b) : (a <= b);
  }

  // XXXkt prob want log scale here i.e. 1.5 is closer to 1 than 0.5
  return Abs(a - b) < Abs(olda - b);
}

// We want to place the glyphs even when they don't fit at their
// full extent, i.e., we may clip to tolerate a small amount of
// overlap between the parts. This is important to cater for fonts
// with long glues.
static nscoord ComputeSizeFromParts(nsPresContext* aPresContext,
                                    nsGlyphCode* aGlyphs, nscoord* aSizes,
                                    nscoord aTargetSize) {
  enum { first, middle, last, glue };
  // Add the parts that cannot be left out.
  nscoord sum = 0;
  for (int32_t i = first; i <= last; i++) {
    sum += aSizes[i];
  }

  // Determine how much is used in joins
  nscoord oneDevPixel = aPresContext->AppUnitsPerDevPixel();
  int32_t joins = aGlyphs[middle] == aGlyphs[glue] ? 1 : 2;

  // Pick a maximum size using a maximum number of glue glyphs that we are
  // prepared to draw for one character.
  const int32_t maxGlyphs = 1000;

  // This also takes into account the fact that, if the glue has no size,
  // then the character can't be lengthened.
  nscoord maxSize = sum - 2 * joins * oneDevPixel + maxGlyphs * aSizes[glue];
  if (maxSize < aTargetSize) {
    return maxSize;  // settle with the maximum size
  }

  // Get the minimum allowable size using some flex.
  nscoord minSize = NSToCoordRound(kMathMLDelimiterFactor * sum);

  if (minSize > aTargetSize) {
    return minSize;  // settle with the minimum size
  }

  // Fill-up the target area
  return aTargetSize;
}

// Update the font if there is a family change and returns the font group.
bool nsMathMLChar::SetFontFamily(nsPresContext* aPresContext,
                                 const nsGlyphTable* aGlyphTable,
                                 const nsGlyphCode& aGlyphCode,
                                 const StyleFontFamilyList& aDefaultFamilyList,
                                 nsFont& aFont,
                                 RefPtr<gfxFontGroup>* aFontGroup) {
  StyleFontFamilyList glyphCodeFont;
  if (aGlyphCode.isGlyphID) {
    glyphCodeFont = StyleFontFamilyList::WithOneUnquotedFamily(
        aGlyphTable->FontNameFor(aGlyphCode));
  }

  const StyleFontFamilyList& familyList =
      aGlyphCode.isGlyphID ? glyphCodeFont : aDefaultFamilyList;

  if (!*aFontGroup || aFont.family.families != familyList) {
    nsFont font = aFont;
    font.family.families = familyList;
    const nsStyleFont* styleFont = mComputedStyle->StyleFont();
    nsFontMetrics::Params params;
    params.language = styleFont->mLanguage;
    params.explicitLanguage = styleFont->mExplicitLanguage;
    params.userFontSet = aPresContext->GetUserFontSet();
    params.textPerf = aPresContext->GetTextPerfMetrics();
    params.featureValueLookup = aPresContext->GetFontFeatureValuesLookup();
    RefPtr<nsFontMetrics> fm = aPresContext->GetMetricsFor(font, params);
    // Set the font if it is an unicode table or if the same family name has
    // been found.
    const bool shouldSetFont = [&] {
      if (aGlyphTable && aGlyphTable->IsUnicodeTable()) {
        return true;
      }

      if (familyList.list.IsEmpty()) {
        return false;
      }

      const auto& firstFontInList = familyList.list.AsSpan()[0];

      RefPtr<gfxFont> firstFont = fm->GetThebesFontGroup()->GetFirstValidFont();
      RefPtr<nsAtom> firstFontName =
          NS_Atomize(firstFont->GetFontEntry()->FamilyName());

      return firstFontInList.IsFamilyName() &&
             firstFontInList.AsFamilyName().name.AsAtom() == firstFontName;
    }();
    if (!shouldSetFont) {
      return false;
    }
    aFont.family.families = familyList;
    *aFontGroup = fm->GetThebesFontGroup();
  }
  return true;
}

static nsBoundingMetrics MeasureTextRun(DrawTarget* aDrawTarget,
                                        gfxTextRun* aTextRun) {
  gfxTextRun::Metrics metrics =
      aTextRun->MeasureText(gfxFont::TIGHT_HINTED_OUTLINE_EXTENTS, aDrawTarget);

  nsBoundingMetrics bm;
  bm.leftBearing = NSToCoordFloor(metrics.mBoundingBox.X());
  bm.rightBearing = NSToCoordCeil(metrics.mBoundingBox.XMost());
  bm.ascent = NSToCoordCeil(-metrics.mBoundingBox.Y());
  bm.descent = NSToCoordCeil(metrics.mBoundingBox.YMost());
  bm.width = NSToCoordRound(metrics.mAdvanceWidth);

  return bm;
}

class nsMathMLChar::StretchEnumContext {
 public:
  StretchEnumContext(nsMathMLChar* aChar, nsPresContext* aPresContext,
                     DrawTarget* aDrawTarget, float aFontSizeInflation,
                     StretchDirection aStretchDirection, nscoord aTargetSize,
                     MathMLStretchFlags aStretchFlags,
                     nsBoundingMetrics& aStretchedMetrics,
                     const StyleFontFamilyList& aFamilyList, bool& aGlyphFound)
      : mChar(aChar),
        mPresContext(aPresContext),
        mDrawTarget(aDrawTarget),
        mFontSizeInflation(aFontSizeInflation),
        mDirection(aStretchDirection),
        mTargetSize(aTargetSize),
        mStretchFlags(aStretchFlags),
        mBoundingMetrics(aStretchedMetrics),
        mFamilyList(aFamilyList),
        mTryVariants(true),
        mTryParts(true),
        mGlyphFound(aGlyphFound) {}

  static bool EnumCallback(const StyleSingleFontFamily& aFamily, void* aData,
                           gfx::ShapedTextFlags aFlags, bool aRtl);

 private:
  bool TryVariants(nsGlyphTable* aGlyphTable, RefPtr<gfxFontGroup>* aFontGroup,
                   const StyleFontFamilyList& aFamilyList, bool aRtl);
  bool TryParts(nsGlyphTable* aGlyphTable, RefPtr<gfxFontGroup>* aFontGroup,
                const StyleFontFamilyList& aFamilyList);

  nsMathMLChar* mChar;
  nsPresContext* mPresContext;
  DrawTarget* mDrawTarget;
  float mFontSizeInflation;
  const StretchDirection mDirection;
  const nscoord mTargetSize;
  const MathMLStretchFlags mStretchFlags;
  nsBoundingMetrics& mBoundingMetrics;
  // Font families to search
  const StyleFontFamilyList& mFamilyList;

 public:
  bool mTryVariants;
  bool mTryParts;

 private:
  bool mUnicodeTableTried = false;
  bool& mGlyphFound;
};

// 2. See if there are any glyphs of the appropriate size.
// Returns true if the size is OK, false to keep searching.
// Always updates the char if a better match is found.
bool nsMathMLChar::StretchEnumContext::TryVariants(
    nsGlyphTable* aGlyphTable, RefPtr<gfxFontGroup>* aFontGroup,
    const StyleFontFamilyList& aFamilyList, bool aRtl) {
  // Use our stretchy ComputedStyle now that stretching is in progress
  ComputedStyle* sc = mChar->mComputedStyle;
  nsFont font = sc->StyleFont()->mFont;
  NormalizeDefaultFont(font, mFontSizeInflation);

  bool isVertical = (mDirection == StretchDirection::Vertical);
  nscoord oneDevPixel = mPresContext->AppUnitsPerDevPixel();
  char16_t uchar = mChar->mData[0];
  bool largeop = mStretchFlags.contains(MathMLStretchFlag::LargeOperator);
  bool largeopOnly =
      largeop && (mStretchFlags & kMathMLStretchVariableSet).isEmpty();
  bool maxWidth = mStretchFlags.contains(MathMLStretchFlag::MaxWidth);

  nscoord bestSize =
      isVertical ? mBoundingMetrics.ascent + mBoundingMetrics.descent
                 : mBoundingMetrics.rightBearing - mBoundingMetrics.leftBearing;
  bool haveBetter = false;

  // start at size = 1 (size = 0 is the char at its normal size), except for
  // rtlm fonts since they might have a character there.
  int32_t size = aRtl ? 0 : 1;
  nsGlyphCode ch;
  nscoord displayOperatorMinHeight = 0;
  if (largeopOnly) {
    NS_ASSERTION(isVertical, "Stretching should be in the vertical direction");
    ch = aGlyphTable->BigOf(mDrawTarget, oneDevPixel, *aFontGroup, uchar,
                            isVertical, 0);
    if (ch.isGlyphID) {
      RefPtr<gfxFont> mathFont = aFontGroup->get()->GetFirstMathFont();
      // For OpenType MATH fonts, we will rely on the DisplayOperatorMinHeight
      // to select the right size variant.
      if (mathFont) {
        displayOperatorMinHeight = mathFont->MathTable()->Constant(
            gfxMathTable::DisplayOperatorMinHeight, oneDevPixel);
      }
    }
  }
#ifdef NOISY_SEARCH
  printf("  searching in %s ...\n", NS_LossyConvertUTF16toASCII(aFamily).get());
#endif
  while ((ch = aGlyphTable->BigOf(mDrawTarget, oneDevPixel, *aFontGroup, uchar,
                                  isVertical, size))
             .Exists()) {
    if (!mChar->SetFontFamily(mPresContext, aGlyphTable, ch, aFamilyList, font,
                              aFontGroup)) {
      // if largeopOnly is set, break now
      if (largeopOnly) {
        break;
      }
      ++size;
      continue;
    }

    RefPtr<gfxTextRun> textRun =
        aGlyphTable->MakeTextRun(mDrawTarget, oneDevPixel, *aFontGroup, ch);
    nsBoundingMetrics bm = MeasureTextRun(mDrawTarget, textRun.get());

    nscoord charSize =
        isVertical ? bm.ascent + bm.descent : bm.rightBearing - bm.leftBearing;

    if (largeopOnly ||
        IsSizeBetter(charSize, bestSize, mTargetSize, mStretchFlags)) {
      mGlyphFound = true;
      if (maxWidth) {
        // IsSizeBetter() checked that charSize < maxsize;
        // Leave ascent, descent, and bestsize as these contain maxsize.
        if (mBoundingMetrics.width < bm.width) {
          mBoundingMetrics.width = bm.width;
        }
        if (mBoundingMetrics.leftBearing > bm.leftBearing) {
          mBoundingMetrics.leftBearing = bm.leftBearing;
        }
        if (mBoundingMetrics.rightBearing < bm.rightBearing) {
          mBoundingMetrics.rightBearing = bm.rightBearing;
        }
        // Continue to check other sizes unless largeopOnly
        haveBetter = largeopOnly;
      } else {
        mBoundingMetrics = bm;
        haveBetter = true;
        bestSize = charSize;
        mChar->mGlyphs[0] = std::move(textRun);
        mChar->mDrawingMethod = DrawingMethod::Variant;

        mChar->mItalicCorrection = 0;
        if (ch.isGlyphID) {
          if (RefPtr<gfxFont> mathFont =
                  aFontGroup->get()->GetFirstMathFont()) {
            mChar->mItalicCorrection = NSToCoordRound(
                mathFont->MathTable()->ItalicsCorrection(ch.glyphID) *
                oneDevPixel);
          }
        }
      }
#ifdef NOISY_SEARCH
      printf("    size:%d Current best\n", size);
#endif
    } else {
#ifdef NOISY_SEARCH
      printf("    size:%d Rejected!\n", size);
#endif
      if (haveBetter) {
        break;  // Not making an futher progress, stop searching
      }
    }

    // If this a largeop only operator, we stop if the glyph is large enough.
    if (largeopOnly && (bm.ascent + bm.descent) >= displayOperatorMinHeight) {
      break;
    }
    ++size;
  }

  return haveBetter &&
         (largeopOnly || IsSizeOK(bestSize, mTargetSize, mStretchFlags));
}

// 3. Build by parts.
// Returns true if the size is OK, false to keep searching.
// Always updates the char if a better match is found.
bool nsMathMLChar::StretchEnumContext::TryParts(
    nsGlyphTable* aGlyphTable, RefPtr<gfxFontGroup>* aFontGroup,
    const StyleFontFamilyList& aFamilyList) {
  // Use our stretchy ComputedStyle now that stretching is in progress
  nsFont font = mChar->mComputedStyle->StyleFont()->mFont;
  NormalizeDefaultFont(font, mFontSizeInflation);

  // Compute the bounding metrics of all partial glyphs
  RefPtr<gfxTextRun> textRun[4];
  nsGlyphCode chdata[4];
  nsBoundingMetrics bmdata[4];
  nscoord sizedata[4];

  bool isVertical = (mDirection == StretchDirection::Vertical);
  nscoord oneDevPixel = mPresContext->AppUnitsPerDevPixel();
  char16_t uchar = mChar->mData[0];
  bool maxWidth = mStretchFlags.contains(MathMLStretchFlag::MaxWidth);
  if (!aGlyphTable->HasPartsOf(mDrawTarget, oneDevPixel, *aFontGroup, uchar,
                               isVertical)) {
    return false;  // to next table
  }

  for (int32_t i = 0; i < 4; i++) {
    nsGlyphCode ch = aGlyphTable->ElementAt(mDrawTarget, oneDevPixel,
                                            *aFontGroup, uchar, isVertical, i);
    chdata[i] = ch;
    if (ch.Exists()) {
      if (!mChar->SetFontFamily(mPresContext, aGlyphTable, ch, aFamilyList,
                                font, aFontGroup)) {
        return false;
      }

      textRun[i] =
          aGlyphTable->MakeTextRun(mDrawTarget, oneDevPixel, *aFontGroup, ch);
      nsBoundingMetrics bm = MeasureTextRun(mDrawTarget, textRun[i].get());
      bmdata[i] = bm;
      sizedata[i] = isVertical ? bm.ascent + bm.descent
                               : bm.rightBearing - bm.leftBearing;
    } else {
      // Null glue indicates that a rule will be drawn, which can stretch to
      // fill any space.
      textRun[i] = nullptr;
      bmdata[i] = nsBoundingMetrics();
      sizedata[i] = i == 3 ? mTargetSize : 0;
    }
  }

  // For the Unicode table, we check that all the glyphs are actually found and
  // come from the same font.
  if (aGlyphTable->IsUnicodeTable()) {
    gfxFont* unicodeFont = nullptr;
    for (const auto& i : textRun) {
      if (!i) {
        continue;
      }
      if (i->GetLength() != 1 || i->GetCharacterGlyphs()[0].IsMissing()) {
        return false;
      }
      uint32_t numGlyphRuns;
      const gfxTextRun::GlyphRun* glyphRuns = i->GetGlyphRuns(&numGlyphRuns);
      if (numGlyphRuns != 1) {
        return false;
      }
      if (!unicodeFont) {
        unicodeFont = glyphRuns[0].mFont;
      } else if (unicodeFont != glyphRuns[0].mFont) {
        return false;
      }
    }
  }

  // Build by parts if we have successfully computed the
  // bounding metrics of all parts.
  nscoord computedSize =
      ComputeSizeFromParts(mPresContext, chdata, sizedata, mTargetSize);

  nscoord currentSize =
      isVertical ? mBoundingMetrics.ascent + mBoundingMetrics.descent
                 : mBoundingMetrics.rightBearing - mBoundingMetrics.leftBearing;

  if (!IsSizeBetter(computedSize, currentSize, mTargetSize, mStretchFlags)) {
#ifdef NOISY_SEARCH
    printf("    Font %s Rejected!\n",
           NS_LossyConvertUTF16toASCII(fontName).get());
#endif
    return false;  // to next table
  }

#ifdef NOISY_SEARCH
  printf("    Font %s Current best!\n",
         NS_LossyConvertUTF16toASCII(fontName).get());
#endif

  // The computed size is the best we have found so far...
  // now is the time to compute and cache our bounding metrics
  if (isVertical) {
    int32_t i;
    // Try and find the first existing part and then determine the extremal
    // horizontal metrics of the parts.
    for (i = 0; i <= 3 && !textRun[i]; i++) {
      ;
    }
    if (i == 4) {
      NS_ERROR("Cannot stretch - All parts missing");
      return false;
    }
    nscoord lbearing = bmdata[i].leftBearing;
    nscoord rbearing = bmdata[i].rightBearing;
    nscoord width = bmdata[i].width;
    i++;
    for (; i <= 3; i++) {
      if (!textRun[i]) {
        continue;
      }
      lbearing = std::min(lbearing, bmdata[i].leftBearing);
      rbearing = std::max(rbearing, bmdata[i].rightBearing);
      width = std::max(width, bmdata[i].width);
    }
    if (maxWidth) {
      lbearing = std::min(lbearing, mBoundingMetrics.leftBearing);
      rbearing = std::max(rbearing, mBoundingMetrics.rightBearing);
      width = std::max(width, mBoundingMetrics.width);
    }
    mBoundingMetrics.width = width;
    // When maxWidth, updating ascent and descent indicates that no characters
    // larger than this character's minimum size need to be checked as they
    // will not be used.
    mBoundingMetrics.ascent = bmdata[0].ascent;  // not used except with descent
                                                 // for height
    mBoundingMetrics.descent = computedSize - mBoundingMetrics.ascent;
    mBoundingMetrics.leftBearing = lbearing;
    mBoundingMetrics.rightBearing = rbearing;
  } else {
    int32_t i;
    // Try and find the first existing part and then determine the extremal
    // vertical metrics of the parts.
    for (i = 0; i <= 3 && !textRun[i]; i++) {
      ;
    }
    if (i == 4) {
      NS_ERROR("Cannot stretch - All parts missing");
      return false;
    }
    nscoord ascent = bmdata[i].ascent;
    nscoord descent = bmdata[i].descent;
    i++;
    for (; i <= 3; i++) {
      if (!textRun[i]) {
        continue;
      }
      ascent = std::max(ascent, bmdata[i].ascent);
      descent = std::max(descent, bmdata[i].descent);
    }
    mBoundingMetrics.width = computedSize;
    mBoundingMetrics.ascent = ascent;
    mBoundingMetrics.descent = descent;
    mBoundingMetrics.leftBearing = 0;
    mBoundingMetrics.rightBearing = computedSize;
  }
  // TODO(bug 2009367): mChar->mItalicCorrection should be set to the italic
  // correction of the glyph assembly.

  mGlyphFound = true;
  if (maxWidth) {
    return false;  // Continue to check other sizes
  }

  // reset
  mChar->mDrawingMethod = DrawingMethod::Parts;
  for (int32_t i = 0; i < 4; i++) {
    mChar->mGlyphs[i] = std::move(textRun[i]);
    mChar->mBmData[i] = bmdata[i];
  }

  return IsSizeOK(computedSize, mTargetSize, mStretchFlags);
}

// Returns true iff stretching succeeded with the given family.
// This is called for each family, whether it exists or not.
bool nsMathMLChar::StretchEnumContext::EnumCallback(
    const StyleSingleFontFamily& aFamily, void* aData,
    gfx::ShapedTextFlags aFlags, bool aRtl) {
  StretchEnumContext* context = static_cast<StretchEnumContext*>(aData);

  // for comparisons, force use of unquoted names
  StyleFontFamilyList family;
  if (aFamily.IsFamilyName()) {
    family = StyleFontFamilyList::WithOneUnquotedFamily(
        nsAtomCString(aFamily.AsFamilyName().name.AsAtom()));
  }

  // Check font family if it is not a generic one
  // We test with the kNullGlyph
  ComputedStyle* sc = context->mChar->mComputedStyle;
  nsFont font = sc->StyleFont()->mFont;
  NormalizeDefaultFont(font, context->mFontSizeInflation);
  RefPtr<gfxFontGroup> fontGroup;
  if (!aFamily.IsGeneric() &&
      !context->mChar->SetFontFamily(context->mPresContext, nullptr, kNullGlyph,
                                     family, font, &fontGroup)) {
    return false;  // Could not set the family
  }

  // Determine the glyph table to use for this font.
  UniquePtr<nsOpenTypeTable> openTypeTable;
  auto glyphTable = [&aFamily, &fontGroup, &openTypeTable,
                     &aFlags]() -> nsGlyphTable* {
    if (!aFamily.IsGeneric()) {
      // If the font contains an Open Type MATH table, use it.
      RefPtr<gfxFont> font = fontGroup->GetFirstValidFont();
      openTypeTable = nsOpenTypeTable::Create(font, aFlags);
      if (openTypeTable) {
        return openTypeTable.get();
      }
    }
    // Fallback to the Unicode table.
    return &gUnicodeTable;
  }();
  MOZ_ASSERT(glyphTable);

  if (!openTypeTable) {
    // Make sure we only try the UnicodeTable once.
    if (context->mUnicodeTableTried) {
      return false;
    }
    context->mUnicodeTableTried = true;
  }

  // If the unicode table is being used, then search all font families.  If a
  // special table is being used then the font in this family should have the
  // specified glyphs.
  const StyleFontFamilyList& familyList =
      glyphTable->IsUnicodeTable() ? context->mFamilyList : family;

  return (context->mTryVariants &&
          context->TryVariants(glyphTable, &fontGroup, familyList, aRtl)) ||
         (context->mTryParts &&
          context->TryParts(glyphTable, &fontGroup, familyList));
}

static void AppendFallbacks(nsTArray<StyleSingleFontFamily>& aNames,
                            const nsTArray<nsCString>& aFallbacks) {
  for (const nsCString& fallback : aFallbacks) {
    aNames.AppendElement(StyleSingleFontFamily::FamilyName(
        StyleFamilyName{StyleAtom(NS_Atomize(fallback)),
                        StyleFontFamilyNameSyntax::Identifiers}));
  }
}

// insert math fallback families just before the first generic or at the end
// when no generic present
static void InsertMathFallbacks(StyleFontFamilyList& aFamilyList,
                                nsTArray<nsCString>& aFallbacks) {
  nsTArray<StyleSingleFontFamily> mergedList;

  bool inserted = false;
  for (const auto& name : aFamilyList.list.AsSpan()) {
    if (!inserted && name.IsGeneric()) {
      inserted = true;
      AppendFallbacks(mergedList, aFallbacks);
    }
    mergedList.AppendElement(name);
  }

  if (!inserted) {
    AppendFallbacks(mergedList, aFallbacks);
  }
  aFamilyList = StyleFontFamilyList::WithNames(std::move(mergedList));
}

// Characters that are mirrorable with RTLM but shouldn't be mirrored with a
// scale fallback as that would change semantics.
//
// 0x2231: Clockwise Integral.
// 0x2232: Clockwise Contour Integral.
// 0x2233: Anticlockwise Contour Integral.
// 0x2A11: Anticlockwise Integration.
// 0x2A17: Integral with Leftwards Arrow with Hook.
bool CanBeMirroredWithScaleFallback(uint32_t ch) {
  return ch != 0x2231 && ch != 0x2232 && ch != 0x2233 && ch != 0x2A11 &&
         ch != 0x2A17;
}

nsresult nsMathMLChar::StretchInternal(
    nsIFrame* aForFrame, DrawTarget* aDrawTarget, float aFontSizeInflation,
    StretchDirection& aStretchDirection,
    const nsBoundingMetrics& aContainerSize,
    nsBoundingMetrics& aDesiredStretchSize, MathMLStretchFlags aStretchFlags,
    // These are currently only used when
    // aStretchFlags.contains(MathMLStretchFlag::MaxWidth):
    float aMaxSize, bool aMaxSizeIsAbsolute) {
  nsPresContext* presContext = aForFrame->PresContext();

  // if we have been called before, and we didn't actually stretch, our
  // direction may have been set to StretchDirection::Unsupported.
  // So first set our direction back to its instrinsic value
  StretchDirection direction = nsMathMLOperators::GetStretchyDirection(mData);

  // Set default font and get the default bounding metrics
  // mComputedStyle is a leaf context used only when stretching happens.
  // For the base size, the default font should come from the parent context
  nsFont font = aForFrame->StyleFont()->mFont;
  NormalizeDefaultFont(font, aFontSizeInflation);

  const nsStyleFont* styleFont = mComputedStyle->StyleFont();
  nsFontMetrics::Params params;
  params.language = styleFont->mLanguage;
  params.explicitLanguage = styleFont->mExplicitLanguage;
  params.userFontSet = presContext->GetUserFontSet();
  params.textPerf = presContext->GetTextPerfMetrics();
  RefPtr<nsFontMetrics> fm = presContext->GetMetricsFor(font, params);
  uint32_t len = uint32_t(mData.Length());

  gfx::ShapedTextFlags flags = gfx::ShapedTextFlags();
  // If the math font doesn't support rtlm, fall back to using a scale of -1 on
  // the Y axis.
  if (mMirroringMethod == MirroringMethod::Glyph) {
    RefPtr<gfxFont> font = fm->GetThebesFontGroup()->GetFirstMathFont();
    const uint32_t kRtlm = HB_TAG('r', 't', 'l', 'm');
    if (!font || !font->FeatureWillHandleChar(intl::Script::COMMON, kRtlm,
                                              mData.First())) {
      mMirroringMethod = MirroringMethod::ScaleFallback;
    }
  }

  if (mMirroringMethod == MirroringMethod::ScaleFallback &&
      !CanBeMirroredWithScaleFallback(mData.First())) {
    mMirroringMethod = MirroringMethod::None;
  }

  if (mMirroringMethod == MirroringMethod::Glyph ||
      mMirroringMethod == MirroringMethod::Character) {
    flags |= gfx::ShapedTextFlags::TEXT_IS_RTL;
  }

  mGlyphs[0] = fm->GetThebesFontGroup()->MakeTextRun(
      static_cast<const char16_t*>(mData.get()), len, aDrawTarget,
      presContext->AppUnitsPerDevPixel(), flags, nsTextFrameUtils::Flags(),
      presContext->MissingFontRecorder());
  aDesiredStretchSize = MeasureTextRun(aDrawTarget, mGlyphs[0].get());

  bool maxWidth = aStretchFlags.contains(MathMLStretchFlag::MaxWidth);
  if (!maxWidth) {
    mUnscaledAscent = aDesiredStretchSize.ascent;
  }

  //////////////////////////////////////////////////////////////////////////////
  // 1. Check the common situations where stretching is not actually needed
  //////////////////////////////////////////////////////////////////////////////

  // quick return if there is nothing special about this char
  if ((aStretchDirection != direction &&
       aStretchDirection != StretchDirection::Default) ||
      (aStretchFlags - MathMLStretchFlag::MaxWidth).isEmpty()) {
    mDirection = StretchDirection::Unsupported;
    return NS_OK;
  }

  // if no specified direction, attempt to stretch in our preferred direction
  if (aStretchDirection == StretchDirection::Default) {
    aStretchDirection = direction;
  }

  // see if this is a particular largeop or largeopOnly request
  bool largeop = aStretchFlags.contains(MathMLStretchFlag::LargeOperator);
  bool stretchy = !(aStretchFlags & kMathMLStretchVariableSet).isEmpty();
  bool largeopOnly = largeop && !stretchy;

  bool isVertical = (direction == StretchDirection::Vertical);

  nscoord targetSize =
      isVertical ? aContainerSize.ascent + aContainerSize.descent
                 : aContainerSize.rightBearing - aContainerSize.leftBearing;

  if (maxWidth) {
    // See if it is only necessary to consider glyphs up to some maximum size.
    // Set the current height to the maximum size, and set aStretchFlags to
    // MathMLStretchFlag::Smaller if the size is variable, so that only smaller
    // sizes are considered.  targetSize from GetMaxWidth() is 0.
    if (stretchy) {
      // variable size stretch - consider all sizes < maxsize
      aStretchFlags -= kMathMLStretchVariableSet;
      aStretchFlags += MathMLStretchFlag::Smaller;
    }

    // Use kMathMLDelimiterFactor to allow some slightly larger glyphs as
    // maxsize is not enforced exactly.
    if (aMaxSize == kMathMLOperatorSizeInfinity) {
      aDesiredStretchSize.ascent = nscoord_MAX;
      aDesiredStretchSize.descent = 0;
    } else {
      nscoord height = aDesiredStretchSize.ascent + aDesiredStretchSize.descent;
      if (height == 0) {
        if (aMaxSizeIsAbsolute) {
          aDesiredStretchSize.ascent =
              NSToCoordRound(aMaxSize / kMathMLDelimiterFactor);
          aDesiredStretchSize.descent = 0;
        }
        // else: leave height as 0
      } else {
        float scale = aMaxSizeIsAbsolute ? aMaxSize / height : aMaxSize;
        scale /= kMathMLDelimiterFactor;
        aDesiredStretchSize.ascent =
            NSToCoordRound(scale * aDesiredStretchSize.ascent);
        aDesiredStretchSize.descent =
            NSToCoordRound(scale * aDesiredStretchSize.descent);
      }
    }
  }

  nsBoundingMetrics initialSize = aDesiredStretchSize;
  nscoord charSize = isVertical
                         ? initialSize.ascent + initialSize.descent
                         : initialSize.rightBearing - initialSize.leftBearing;

  bool done = false;

  if (!maxWidth && !largeop) {
    // Doing Stretch() not GetMaxWidth(),
    // and not a largeop in display mode; we're done if size fits
    if ((targetSize <= 0) || ((isVertical && charSize >= targetSize) ||
                              IsSizeOK(charSize, targetSize, aStretchFlags))) {
      done = true;
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  // 2/3. Search for a glyph or set of part glyphs of appropriate size
  //////////////////////////////////////////////////////////////////////////////

  bool glyphFound = false;

  if (!done) {  // normal case
    // Use the css font-family but add preferred fallback fonts.
    font = mComputedStyle->StyleFont()->mFont;
    NormalizeDefaultFont(font, aFontSizeInflation);

    // really shouldn't be doing things this way but for now
    // insert fallbacks into the list
    AutoTArray<nsCString, 16> mathFallbacks;
    nsAutoCString value;
    gfxPlatformFontList* pfl = gfxPlatformFontList::PlatformFontList();
    pfl->Lock();
    if (pfl->GetFontPrefs()->LookupName("serif.x-math"_ns, value)) {
      gfxFontUtils::ParseFontList(value, mathFallbacks);
    }
    if (pfl->GetFontPrefs()->LookupNameList("serif.x-math"_ns, value)) {
      gfxFontUtils::ParseFontList(value, mathFallbacks);
    }
    pfl->Unlock();
    InsertMathFallbacks(font.family.families, mathFallbacks);

#ifdef NOISY_SEARCH
    nsAutoString fontlistStr;
    font.fontlist.ToString(fontlistStr, false, true);
    printf(
        "Searching in " % s " for a glyph of appropriate size for: 0x%04X:%c\n",
        NS_ConvertUTF16toUTF8(fontlistStr).get(), mData[0], mData[0] & 0x00FF);
#endif
    StretchEnumContext enumData(this, presContext, aDrawTarget,
                                aFontSizeInflation, aStretchDirection,
                                targetSize, aStretchFlags, aDesiredStretchSize,
                                font.family.families, glyphFound);
    enumData.mTryParts = !largeopOnly;

    for (const StyleSingleFontFamily& name :
         font.family.families.list.AsSpan()) {
      if (StretchEnumContext::EnumCallback(
              name, &enumData, flags,
              mMirroringMethod == MirroringMethod::Glyph)) {
        break;
      }
    }
  }

  if (!maxWidth) {
    // Now, we know how we are going to draw the char. Update the member
    // variables accordingly.
    mUnscaledAscent = aDesiredStretchSize.ascent;
  }

  if (glyphFound) {
    return NS_OK;
  }

  // We did not find a size variant or a glyph assembly to stretch this
  // operator. Verify whether a font with an OpenType MATH table is available
  // and record missing math script otherwise.
  gfxMissingFontRecorder* MFR = presContext->MissingFontRecorder();
  RefPtr<gfxFont> firstMathFont = fm->GetThebesFontGroup()->GetFirstMathFont();
  if (MFR && !firstMathFont) {
    MFR->RecordScript(intl::Script::MATHEMATICAL_NOTATION);
  }

  // If the scale_stretchy_operators option is disabled, we are done.
  if (!StaticPrefs::mathml_scale_stretchy_operators_enabled()) {
    return NS_OK;
  }

  // stretchy character
  if (stretchy) {
    if (isVertical) {
      float scale = std::min(
          kMaxScaleFactor,
          float(aContainerSize.ascent + aContainerSize.descent) /
              (aDesiredStretchSize.ascent + aDesiredStretchSize.descent));
      if (!largeop || scale > 1.0) {
        // make the character match the desired height.
        if (!maxWidth) {
          mScaleY *= scale;
        }
        aDesiredStretchSize.ascent *= scale;
        aDesiredStretchSize.descent *= scale;
      }
    } else {
      float scale = std::min(
          kMaxScaleFactor,
          float(aContainerSize.rightBearing - aContainerSize.leftBearing) /
              (aDesiredStretchSize.rightBearing -
               aDesiredStretchSize.leftBearing));
      if (!largeop || scale > 1.0) {
        // make the character match the desired width.
        if (!maxWidth) {
          mScaleX *= scale;
        }
        aDesiredStretchSize.leftBearing *= scale;
        aDesiredStretchSize.rightBearing *= scale;
        aDesiredStretchSize.width *= scale;
      }
    }
  }

  // We do not have a char variant for this largeop in display mode, so we
  // apply a scale transform to the base char.
  if (largeop) {
    float scale;
    float largeopFactor = kLargeOpFactor;

    // increase the width if it is not largeopFactor times larger
    // than the initial one.
    if ((aDesiredStretchSize.rightBearing - aDesiredStretchSize.leftBearing) <
        largeopFactor * (initialSize.rightBearing - initialSize.leftBearing)) {
      scale =
          (largeopFactor *
           (initialSize.rightBearing - initialSize.leftBearing)) /
          (aDesiredStretchSize.rightBearing - aDesiredStretchSize.leftBearing);
      if (!maxWidth) {
        mScaleX *= scale;
      }
      aDesiredStretchSize.leftBearing *= scale;
      aDesiredStretchSize.rightBearing *= scale;
      aDesiredStretchSize.width *= scale;
    }

    // increase the height if it is not largeopFactor times larger
    // than the initial one.
    if (nsMathMLOperators::IsIntegralOperator(mData)) {
      // integrals are drawn taller
      largeopFactor = kIntegralFactor;
    }
    if ((aDesiredStretchSize.ascent + aDesiredStretchSize.descent) <
        largeopFactor * (initialSize.ascent + initialSize.descent)) {
      scale = (largeopFactor * (initialSize.ascent + initialSize.descent)) /
              (aDesiredStretchSize.ascent + aDesiredStretchSize.descent);
      if (!maxWidth) {
        mScaleY *= scale;
      }
      aDesiredStretchSize.ascent *= scale;
      aDesiredStretchSize.descent *= scale;
    }
  }

  return NS_OK;
}

nsresult nsMathMLChar::Stretch(nsIFrame* aForFrame, DrawTarget* aDrawTarget,
                               float aFontSizeInflation,
                               StretchDirection aStretchDirection,
                               const nsBoundingMetrics& aContainerSize,
                               nsBoundingMetrics& aDesiredStretchSize,
                               MathMLStretchFlags aStretchFlags, bool aRTL) {
  NS_ASSERTION((aStretchFlags - kMathMLStretchSet).isEmpty(),
               "Unexpected stretch flags");

  mDrawingMethod = DrawingMethod::Normal;
  mMirroringMethod = [&] {
    if (!aRTL || !nsMathMLOperators::IsMirrorableOperator(mData)) {
      return MirroringMethod::None;
    }
    // Character level mirroring (always supported)
    if (nsMathMLOperators::GetMirroredOperator(mData) != mData) {
      return MirroringMethod::Character;
    }
    // Glyph level mirroring (needs rtlm feature)
    return MirroringMethod::Glyph;
  }();
  mScaleY = mScaleX = 1.0;
  mDirection = aStretchDirection;
  nsresult rv =
      StretchInternal(aForFrame, aDrawTarget, aFontSizeInflation, mDirection,
                      aContainerSize, aDesiredStretchSize, aStretchFlags);

  // Record the metrics
  mBoundingMetrics = aDesiredStretchSize;

  return rv;
}

// What happens here is that the StretchInternal algorithm is used but
// modified by passing the MathMLStretchFlag::MaxWidth stretch hint.  That
// causes StretchInternal to return horizontal bounding metrics that are the
// maximum that might be returned from a Stretch.
//
// In order to avoid considering widths of some characters in fonts that will
// not be used for any stretch size, StretchInternal sets the initial height
// to infinity and looks for any characters smaller than this height.  When a
// character built from parts is considered, (it will be used by Stretch for
// any characters greater than its minimum size, so) the height is set to its
// minimum size, so that only widths of smaller subsequent characters are
// considered.
nscoord nsMathMLChar::GetMaxWidth(nsIFrame* aForFrame, DrawTarget* aDrawTarget,
                                  float aFontSizeInflation,
                                  MathMLStretchFlags aStretchFlags) {
  nsBoundingMetrics bm;
  StretchDirection direction = StretchDirection::Vertical;
  const nsBoundingMetrics container;  // zero target size

  StretchInternal(aForFrame, aDrawTarget, aFontSizeInflation, direction,
                  container, bm, aStretchFlags + MathMLStretchFlag::MaxWidth);

  return std::max(bm.width, bm.rightBearing) - std::min(0, bm.leftBearing);
}

namespace mozilla {

class nsDisplayMathMLSelectionRect final : public nsPaintedDisplayItem {
 public:
  nsDisplayMathMLSelectionRect(nsDisplayListBuilder* aBuilder, nsIFrame* aFrame,
                               const nsRect& aRect)
      : nsPaintedDisplayItem(aBuilder, aFrame), mRect(aRect) {
    MOZ_COUNT_CTOR(nsDisplayMathMLSelectionRect);
  }

  MOZ_COUNTED_DTOR_FINAL(nsDisplayMathMLSelectionRect)

  virtual void Paint(nsDisplayListBuilder* aBuilder, gfxContext* aCtx) override;
  NS_DISPLAY_DECL_NAME("MathMLSelectionRect", TYPE_MATHML_SELECTION_RECT)
 private:
  nsRect mRect;
};

void nsDisplayMathMLSelectionRect::Paint(nsDisplayListBuilder* aBuilder,
                                         gfxContext* aCtx) {
  DrawTarget* drawTarget = aCtx->GetDrawTarget();
  Rect rect = NSRectToSnappedRect(mRect + ToReferenceFrame(),
                                  mFrame->PresContext()->AppUnitsPerDevPixel(),
                                  *drawTarget);
  // get color to use for selection from the look&feel object
  nscolor bgColor = LookAndFeel::Color(LookAndFeel::ColorID::Highlight, mFrame);
  drawTarget->FillRect(rect, ColorPattern(ToDeviceColor(bgColor)));
}

class nsDisplayMathMLCharForeground final : public nsPaintedDisplayItem {
 public:
  nsDisplayMathMLCharForeground(nsDisplayListBuilder* aBuilder,
                                nsIFrame* aFrame, nsMathMLChar* aChar,
                                const bool aIsSelected)
      : nsPaintedDisplayItem(aBuilder, aFrame),
        mChar(aChar),
        mIsSelected(aIsSelected) {
    MOZ_COUNT_CTOR(nsDisplayMathMLCharForeground);
  }

  MOZ_COUNTED_DTOR_FINAL(nsDisplayMathMLCharForeground)

  virtual nsRect GetBounds(nsDisplayListBuilder* aBuilder,
                           bool* aSnap) const override {
    *aSnap = false;
    nsRect rect;
    mChar->GetRect(rect);
    nsPoint offset = ToReferenceFrame() + rect.TopLeft();
    nsBoundingMetrics bm;
    mChar->GetBoundingMetrics(bm);
    nsRect temp(offset.x + bm.leftBearing, offset.y,
                bm.rightBearing - bm.leftBearing, bm.ascent + bm.descent);
    // Bug 748220
    temp.Inflate(mFrame->PresContext()->AppUnitsPerDevPixel());
    return temp;
  }

  virtual void Paint(nsDisplayListBuilder* aBuilder,
                     gfxContext* aCtx) override {
    mChar->PaintForeground(mFrame, *aCtx, ToReferenceFrame(), mIsSelected);
  }

  NS_DISPLAY_DECL_NAME("MathMLCharForeground", TYPE_MATHML_CHAR_FOREGROUND)

  virtual nsRect GetComponentAlphaBounds(
      nsDisplayListBuilder* aBuilder) const override {
    bool snap;
    return GetBounds(aBuilder, &snap);
  }

 private:
  nsMathMLChar* mChar;
  bool mIsSelected;
};

#ifdef DEBUG
class nsDisplayMathMLCharDebug final : public nsPaintedDisplayItem {
 public:
  nsDisplayMathMLCharDebug(nsDisplayListBuilder* aBuilder, nsIFrame* aFrame,
                           const nsRect& aRect)
      : nsPaintedDisplayItem(aBuilder, aFrame), mRect(aRect) {
    MOZ_COUNT_CTOR(nsDisplayMathMLCharDebug);
  }

  MOZ_COUNTED_DTOR_FINAL(nsDisplayMathMLCharDebug)

  virtual void Paint(nsDisplayListBuilder* aBuilder, gfxContext* aCtx) override;
  NS_DISPLAY_DECL_NAME("MathMLCharDebug", TYPE_MATHML_CHAR_DEBUG)

 private:
  nsRect mRect;
};

void nsDisplayMathMLCharDebug::Paint(nsDisplayListBuilder* aBuilder,
                                     gfxContext* aCtx) {
  // for visual debug
  Sides skipSides;
  nsPresContext* presContext = mFrame->PresContext();
  ComputedStyle* computedStyle = mFrame->Style();
  nsRect rect = mRect + ToReferenceFrame();

  PaintBorderFlags flags = aBuilder->ShouldSyncDecodeImages()
                               ? PaintBorderFlags::SyncDecodeImages
                               : PaintBorderFlags();

  // Since this is used only for debugging, we don't need to worry about
  // tracking the ImgDrawResult.
  (void)nsCSSRendering::PaintBorder(presContext, *aCtx, mFrame,
                                    GetPaintRect(aBuilder, aCtx), rect,
                                    computedStyle, flags, skipSides);

  nsCSSRendering::PaintNonThemedOutline(presContext, *aCtx, mFrame,
                                        GetPaintRect(aBuilder, aCtx), rect,
                                        computedStyle);
}
#endif

}  // namespace mozilla

void nsMathMLChar::Display(nsDisplayListBuilder* aBuilder, nsIFrame* aForFrame,
                           const nsDisplayListSet& aLists, uint32_t aIndex,
                           const nsRect* aSelectedRect) {
  ComputedStyle* computedStyle = mComputedStyle;
  if (!computedStyle->StyleVisibility()->IsVisible()) {
    return;
  }

  const bool isSelected = aSelectedRect && !aSelectedRect->IsEmpty();

  if (isSelected) {
    aLists.BorderBackground()->AppendNewToTop<nsDisplayMathMLSelectionRect>(
        aBuilder, aForFrame, *aSelectedRect);
  }
  aLists.Content()->AppendNewToTopWithIndex<nsDisplayMathMLCharForeground>(
      aBuilder, aForFrame, aIndex, this, isSelected);
}

void nsMathMLChar::ApplyTransforms(gfxContext* aThebesContext,
                                   int32_t aAppUnitsPerGfxUnit, nsRect& r) {
  // apply the transforms
  nsPoint pt =
      (mMirroringMethod != MirroringMethod::None) ? r.TopRight() : r.TopLeft();
  gfxPoint devPixelOffset(NSAppUnitsToFloatPixels(pt.x, aAppUnitsPerGfxUnit),
                          NSAppUnitsToFloatPixels(pt.y, aAppUnitsPerGfxUnit));
  aThebesContext->SetMatrixDouble(
      aThebesContext->CurrentMatrixDouble()
          .PreTranslate(devPixelOffset)
          .PreScale(
              mScaleX *
                  (mMirroringMethod == MirroringMethod::ScaleFallback ? -1 : 1),
              mScaleY));

  // update the bounding rectangle.
  r.x = r.y = 0;
  r.width /= mScaleX;
  r.height /= mScaleY;
}

void nsMathMLChar::PaintForeground(nsIFrame* aForFrame,
                                   gfxContext& aRenderingContext, nsPoint aPt,
                                   bool aIsSelected) {
  ComputedStyle* computedStyle = mComputedStyle;
  nsPresContext* presContext = aForFrame->PresContext();

  if (mDrawingMethod == DrawingMethod::Normal) {
    // normal drawing if there is nothing special about this char
    // Use our parent element's style
    computedStyle = aForFrame->Style();
  }

  // Set color ...
  nscolor fgColor = computedStyle->GetVisitedDependentColor(
      &nsStyleText::mWebkitTextFillColor);
  if (aIsSelected) {
    // get color to use for selection from the look&feel object
    fgColor = LookAndFeel::Color(LookAndFeel::ColorID::Highlighttext, aForFrame,
                                 fgColor);
  }
  aRenderingContext.SetColor(sRGBColor::FromABGR(fgColor));
  aRenderingContext.Save();
  nsRect r = mRect + aPt;
  ApplyTransforms(&aRenderingContext,
                  aForFrame->PresContext()->AppUnitsPerDevPixel(), r);

  switch (mDrawingMethod) {
    case DrawingMethod::Normal:
    case DrawingMethod::Variant:
      // draw a single glyph (base size or size variant)
      // XXXfredw verify if mGlyphs[0] is non-null to workaround bug 973322.
      if (mGlyphs[0]) {
        mGlyphs[0]->Draw(
            Range(mGlyphs[0].get()), gfx::Point(0.0, mUnscaledAscent),
            gfxTextRun::DrawParams(&aRenderingContext,
                                   presContext->GetFontPaletteValueSet()));
      }
      break;
    case DrawingMethod::Parts: {
      // paint by parts
      if (StretchDirection::Vertical == mDirection) {
        PaintVertically(presContext, &aRenderingContext, r, fgColor);
      } else if (StretchDirection::Horizontal == mDirection) {
        PaintHorizontally(presContext, &aRenderingContext, r, fgColor);
      }
      break;
    }
    default:
      MOZ_ASSERT_UNREACHABLE("Unknown drawing method");
      break;
  }

  aRenderingContext.Restore();
}

/* =============================================================================
  Helper routines that actually do the job of painting the char by parts
 */

class AutoPushClipRect {
  gfxContext* mThebesContext;

 public:
  AutoPushClipRect(gfxContext* aThebesContext, int32_t aAppUnitsPerGfxUnit,
                   const nsRect& aRect)
      : mThebesContext(aThebesContext) {
    mThebesContext->Save();
    gfxRect clip = nsLayoutUtils::RectToGfxRect(aRect, aAppUnitsPerGfxUnit);
    mThebesContext->SnappedClip(clip);
  }
  ~AutoPushClipRect() { mThebesContext->Restore(); }
};

static nsPoint SnapToDevPixels(const gfxContext* aThebesContext,
                               int32_t aAppUnitsPerGfxUnit,
                               const nsPoint& aPt) {
  gfxPoint pt(NSAppUnitsToFloatPixels(aPt.x, aAppUnitsPerGfxUnit),
              NSAppUnitsToFloatPixels(aPt.y, aAppUnitsPerGfxUnit));
  pt = aThebesContext->UserToDevice(pt);
  pt.Round();
  pt = aThebesContext->DeviceToUser(pt);
  return nsPoint(NSFloatPixelsToAppUnits(pt.x, aAppUnitsPerGfxUnit),
                 NSFloatPixelsToAppUnits(pt.y, aAppUnitsPerGfxUnit));
}

static void PaintRule(DrawTarget& aDrawTarget, int32_t aAppUnitsPerGfxUnit,
                      nsRect& aRect, nscolor aColor) {
  Rect rect = NSRectToSnappedRect(aRect, aAppUnitsPerGfxUnit, aDrawTarget);
  ColorPattern color(ToDeviceColor(aColor));
  aDrawTarget.FillRect(rect, color);
}

// paint a stretchy char by assembling glyphs vertically
nsresult nsMathMLChar::PaintVertically(nsPresContext* aPresContext,
                                       gfxContext* aThebesContext,
                                       nsRect& aRect, nscolor aColor) {
  DrawTarget& aDrawTarget = *aThebesContext->GetDrawTarget();

  // Get the device pixel size in the vertical direction.
  // (This makes no effort to optimize for non-translation transformations.)
  nscoord oneDevPixel = aPresContext->AppUnitsPerDevPixel();

  // get metrics data to be re-used later
  int32_t i = 0;
  nscoord dx = aRect.x;
  nscoord offset[3], start[3], end[3];
  for (i = 0; i <= 2; ++i) {
    const nsBoundingMetrics& bm = mBmData[i];
    nscoord dy;
    if (0 == i) {  // top
      dy = aRect.y + bm.ascent;
    } else if (2 == i) {  // bottom
      dy = aRect.y + aRect.height - bm.descent;
    } else {  // middle
      dy = aRect.y + std::midpoint(bm.ascent, aRect.height - bm.descent);
    }
    // _cairo_scaled_font_show_glyphs snaps origins to device pixels.
    // Do this now so that we can get the other dimensions right.
    // (This may not achieve much with non-rectangular transformations.)
    dy = SnapToDevPixels(aThebesContext, oneDevPixel, nsPoint(dx, dy)).y;
    // abcissa passed to Draw
    offset[i] = dy;
    // _cairo_scaled_font_glyph_device_extents rounds outwards to the nearest
    // pixel, so the bm values can include 1 row of faint pixels on each edge.
    // Don't rely on this pixel as it can look like a gap.
    if (bm.ascent + bm.descent >= 2 * oneDevPixel) {
      start[i] = dy - bm.ascent + oneDevPixel;  // top join
      end[i] = dy + bm.descent - oneDevPixel;   // bottom join
    } else {
      // To avoid overlaps, we don't add one pixel on each side when the part
      // is too small.
      start[i] = dy - bm.ascent;  // top join
      end[i] = dy + bm.descent;   // bottom join
    }
  }

  // If there are overlaps, then join at the mid point
  for (i = 0; i < 2; ++i) {
    if (end[i] > start[i + 1]) {
      end[i] = std::midpoint(end[i], start[i + 1]);
      start[i + 1] = end[i];
    }
  }

  nsRect unionRect = aRect;
  unionRect.x += mBoundingMetrics.leftBearing;
  unionRect.width =
      mBoundingMetrics.rightBearing - mBoundingMetrics.leftBearing;
  // RTL characters have the origin on the other side. To correctly display them
  // we need to shift the X coordinate by the width.
  if (mMirroringMethod == MirroringMethod::Glyph ||
      mMirroringMethod == MirroringMethod::Character) {
    unionRect.x -= unionRect.width;
  }
  unionRect.Inflate(oneDevPixel);

  gfxTextRun::DrawParams params(aThebesContext,
                                aPresContext->GetFontPaletteValueSet());

  /////////////////////////////////////
  // draw top, middle, bottom
  for (i = 0; i <= 2; ++i) {
    // glue can be null
    if (mGlyphs[i]) {
      nscoord dy = offset[i];
      // Draw a glyph in a clipped area so that we don't have hairy chars
      // pending outside
      nsRect clipRect = unionRect;
      // Clip at the join to get a solid edge (without overlap or gap), when
      // this won't change the glyph too much.  If the glyph is too small to
      // clip then we'll overlap rather than have a gap.
      nscoord height = mBmData[i].ascent + mBmData[i].descent;
      if (height * (1.0 - kMathMLDelimiterFactor) > oneDevPixel) {
        if (0 == i) {  // top
          clipRect.height = end[i] - clipRect.y;
        } else if (2 == i) {  // bottom
          clipRect.height -= start[i] - clipRect.y;
          clipRect.y = start[i];
        } else {  // middle
          clipRect.y = start[i];
          clipRect.height = end[i] - start[i];
        }
      }
      if (!clipRect.IsEmpty()) {
        AutoPushClipRect clip(aThebesContext, oneDevPixel, clipRect);
        mGlyphs[i]->Draw(Range(mGlyphs[i].get()), gfx::Point(dx, dy), params);
      }
    }
  }

  ///////////////
  // fill the gap between top and middle, and between middle and bottom.
  if (!mGlyphs[3]) {  // null glue : draw a rule
    // figure out the dimensions of the rule to be drawn :
    // set lbearing to rightmost lbearing among the two current successive
    // parts.
    // set rbearing to leftmost rbearing among the two current successive parts.
    // this not only satisfies the convention used for over/underbraces
    // in TeX, but also takes care of broken fonts like the stretchy integral
    // in Symbol for small font sizes in unix.
    nscoord lbearing, rbearing;
    int32_t first = 0, last = 1;
    while (last <= 2) {
      if (mGlyphs[last]) {
        lbearing = mBmData[last].leftBearing;
        rbearing = mBmData[last].rightBearing;
        if (mGlyphs[first]) {
          if (lbearing < mBmData[first].leftBearing) {
            lbearing = mBmData[first].leftBearing;
          }
          if (rbearing > mBmData[first].rightBearing) {
            rbearing = mBmData[first].rightBearing;
          }
        }
      } else if (mGlyphs[first]) {
        lbearing = mBmData[first].leftBearing;
        rbearing = mBmData[first].rightBearing;
      } else {
        NS_ERROR("Cannot stretch - All parts missing");
        return NS_ERROR_UNEXPECTED;
      }
      // paint the rule between the parts
      nsRect rule(aRect.x + lbearing, end[first], rbearing - lbearing,
                  start[last] - end[first]);
      PaintRule(aDrawTarget, oneDevPixel, rule, aColor);
      first = last;
      last++;
    }
  } else if (mBmData[3].ascent + mBmData[3].descent > 0) {
    // glue is present
    nsBoundingMetrics& bm = mBmData[3];
    // Ensure the stride for the glue is not reduced to less than one pixel
    if (bm.ascent + bm.descent >= 3 * oneDevPixel) {
      // To protect against gaps, pretend the glue is smaller than it is,
      // in order to trim off ends and thus get a solid edge for the join.
      bm.ascent -= oneDevPixel;
      bm.descent -= oneDevPixel;
    }

    nsRect clipRect = unionRect;

    for (i = 0; i < 2; ++i) {
      // Make sure not to draw outside the character
      nscoord dy = std::max(end[i], aRect.y);
      nscoord fillEnd = std::min(start[i + 1], aRect.YMost());
      while (dy < fillEnd) {
        clipRect.y = dy;
        clipRect.height = std::min(bm.ascent + bm.descent, fillEnd - dy);
        AutoPushClipRect clip(aThebesContext, oneDevPixel, clipRect);
        dy += bm.ascent;
        mGlyphs[3]->Draw(Range(mGlyphs[3].get()), gfx::Point(dx, dy), params);
        dy += bm.descent;
      }
    }
  }
#ifdef DEBUG
  else {
    for (i = 0; i < 2; ++i) {
      NS_ASSERTION(end[i] >= start[i + 1],
                   "gap between parts with missing glue glyph");
    }
  }
#endif
  return NS_OK;
}

// paint a stretchy char by assembling glyphs horizontally
nsresult nsMathMLChar::PaintHorizontally(nsPresContext* aPresContext,
                                         gfxContext* aThebesContext,
                                         nsRect& aRect, nscolor aColor) {
  DrawTarget& aDrawTarget = *aThebesContext->GetDrawTarget();

  // Get the device pixel size in the horizontal direction.
  // (This makes no effort to optimize for non-translation transformations.)
  nscoord oneDevPixel = aPresContext->AppUnitsPerDevPixel();

  // get metrics data to be re-used later
  int32_t i = 0;
  nscoord dy = aRect.y + mBoundingMetrics.ascent;
  nscoord offset[3], start[3], end[3];
  for (i = 0; i <= 2; ++i) {
    const nsBoundingMetrics& bm = mBmData[i];
    nscoord dx;
    if (0 == i) {  // left
      dx = aRect.x - bm.leftBearing;
    } else if (2 == i) {  // right
      dx = aRect.x + aRect.width - bm.rightBearing;
    } else {  // middle
      dx = aRect.x + (aRect.width - bm.width) / 2;
    }
    // _cairo_scaled_font_show_glyphs snaps origins to device pixels.
    // Do this now so that we can get the other dimensions right.
    // (This may not achieve much with non-rectangular transformations.)
    dx = SnapToDevPixels(aThebesContext, oneDevPixel, nsPoint(dx, dy)).x;
    // abcissa passed to Draw
    offset[i] = dx;
    // _cairo_scaled_font_glyph_device_extents rounds outwards to the nearest
    // pixel, so the bm values can include 1 row of faint pixels on each edge.
    // Don't rely on this pixel as it can look like a gap.
    if (bm.rightBearing - bm.leftBearing >= 2 * oneDevPixel) {
      start[i] = dx + bm.leftBearing + oneDevPixel;  // left join
      end[i] = dx + bm.rightBearing - oneDevPixel;   // right join
    } else {
      // To avoid overlaps, we don't add one pixel on each side when the part
      // is too small.
      start[i] = dx + bm.leftBearing;  // left join
      end[i] = dx + bm.rightBearing;   // right join
    }
  }

  // If there are overlaps, then join at the mid point
  for (i = 0; i < 2; ++i) {
    if (end[i] > start[i + 1]) {
      end[i] = std::midpoint(end[i], start[i + 1]);
      start[i + 1] = end[i];
    }
  }

  nsRect unionRect = aRect;
  unionRect.Inflate(oneDevPixel);

  gfxTextRun::DrawParams params(aThebesContext,
                                aPresContext->GetFontPaletteValueSet());

  ///////////////////////////
  // draw left, middle, right
  for (i = 0; i <= 2; ++i) {
    // glue can be null
    if (mGlyphs[i]) {
      nscoord dx = offset[i];
      nsRect clipRect = unionRect;
      // Clip at the join to get a solid edge (without overlap or gap), when
      // this won't change the glyph too much.  If the glyph is too small to
      // clip then we'll overlap rather than have a gap.
      nscoord width = mBmData[i].rightBearing - mBmData[i].leftBearing;
      if (width * (1.0 - kMathMLDelimiterFactor) > oneDevPixel) {
        if (0 == i) {  // left
          clipRect.width = end[i] - clipRect.x;
        } else if (2 == i) {  // right
          clipRect.width -= start[i] - clipRect.x;
          clipRect.x = start[i];
        } else {  // middle
          clipRect.x = start[i];
          clipRect.width = end[i] - start[i];
        }
      }
      if (!clipRect.IsEmpty()) {
        AutoPushClipRect clip(aThebesContext, oneDevPixel, clipRect);
        mGlyphs[i]->Draw(Range(mGlyphs[i].get()), gfx::Point(dx, dy), params);
      }
    }
  }

  ////////////////
  // fill the gap between left and middle, and between middle and right.
  if (!mGlyphs[3]) {  // null glue : draw a rule
    // figure out the dimensions of the rule to be drawn :
    // set ascent to lowest ascent among the two current successive parts.
    // set descent to highest descent among the two current successive parts.
    // this satisfies the convention used for over/underbraces, and helps
    // fix broken fonts.
    nscoord ascent, descent;
    int32_t first = 0, last = 1;
    while (last <= 2) {
      if (mGlyphs[last]) {
        ascent = mBmData[last].ascent;
        descent = mBmData[last].descent;
        if (mGlyphs[first]) {
          if (ascent > mBmData[first].ascent) {
            ascent = mBmData[first].ascent;
          }
          if (descent > mBmData[first].descent) {
            descent = mBmData[first].descent;
          }
        }
      } else if (mGlyphs[first]) {
        ascent = mBmData[first].ascent;
        descent = mBmData[first].descent;
      } else {
        NS_ERROR("Cannot stretch - All parts missing");
        return NS_ERROR_UNEXPECTED;
      }
      // paint the rule between the parts
      nsRect rule(end[first], dy - ascent, start[last] - end[first],
                  ascent + descent);
      PaintRule(aDrawTarget, oneDevPixel, rule, aColor);
      first = last;
      last++;
    }
  } else if (mBmData[3].rightBearing - mBmData[3].leftBearing > 0) {
    // glue is present
    nsBoundingMetrics& bm = mBmData[3];
    // Ensure the stride for the glue is not reduced to less than one pixel
    if (bm.rightBearing - bm.leftBearing >= 3 * oneDevPixel) {
      // To protect against gaps, pretend the glue is smaller than it is,
      // in order to trim off ends and thus get a solid edge for the join.
      bm.leftBearing += oneDevPixel;
      bm.rightBearing -= oneDevPixel;
    }

    nsRect clipRect = unionRect;

    for (i = 0; i < 2; ++i) {
      // Make sure not to draw outside the character
      nscoord dx = std::max(end[i], aRect.x);
      nscoord fillEnd = std::min(start[i + 1], aRect.XMost());
      while (dx < fillEnd) {
        clipRect.x = dx;
        clipRect.width =
            std::min(bm.rightBearing - bm.leftBearing, fillEnd - dx);
        AutoPushClipRect clip(aThebesContext, oneDevPixel, clipRect);
        dx -= bm.leftBearing;
        mGlyphs[3]->Draw(Range(mGlyphs[3].get()), gfx::Point(dx, dy), params);
        dx += bm.rightBearing;
      }
    }
  }
#ifdef DEBUG
  else {  // no glue
    for (i = 0; i < 2; ++i) {
      NS_ASSERTION(end[i] >= start[i + 1],
                   "gap between parts with missing glue glyph");
    }
  }
#endif
  return NS_OK;
}
