/* -*- Mode: C++; tab-width: 20; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "gfxDWriteFonts.h"

#include <algorithm>
#include "gfxDWriteFontList.h"
#include "gfxContext.h"
#include "gfxTextRun.h"
#include "mozilla/gfx/gfxVars.h"

#include "harfbuzz/hb.h"
#include "mozilla/FontPropertyTypes.h"

using namespace mozilla;
using namespace mozilla::gfx;

// Code to determine whether Windows is set to use ClearType font smoothing;
// based on private functions in cairo-win32-font.c

#ifndef SPI_GETFONTSMOOTHINGTYPE
#  define SPI_GETFONTSMOOTHINGTYPE 0x200a
#endif
#ifndef FE_FONTSMOOTHINGCLEARTYPE
#  define FE_FONTSMOOTHINGCLEARTYPE 2
#endif

// Cleartype can be dynamically enabled/disabled, so we have to allow for
// dynamically updating it.
static BYTE GetSystemTextQuality() {
  BOOL font_smoothing;
  UINT smoothing_type;

  if (!SystemParametersInfo(SPI_GETFONTSMOOTHING, 0, &font_smoothing, 0)) {
    return DEFAULT_QUALITY;
  }

  if (font_smoothing) {
    if (!SystemParametersInfo(SPI_GETFONTSMOOTHINGTYPE, 0, &smoothing_type,
                              0)) {
      return DEFAULT_QUALITY;
    }

    if (smoothing_type == FE_FONTSMOOTHINGCLEARTYPE) {
      return CLEARTYPE_QUALITY;
    }

    return ANTIALIASED_QUALITY;
  }

  return DEFAULT_QUALITY;
}

#ifndef SPI_GETFONTSMOOTHINGCONTRAST
#  define SPI_GETFONTSMOOTHINGCONTRAST 0x200c
#endif

// "Retrieves a contrast value that is used in ClearType smoothing. Valid
// contrast values are from 1000 to 2200. The default value is 1400."
static FLOAT GetSystemGDIGamma() {
  static FLOAT sGDIGamma = 0.0f;
  if (!sGDIGamma) {
    UINT value = 0;
    if (!SystemParametersInfo(SPI_GETFONTSMOOTHINGCONTRAST, 0, &value, 0) ||
        value < 1000 || value > 2200) {
      value = 1400;
    }
    sGDIGamma = value / 1000.0f;
  }
  return sGDIGamma;
}

////////////////////////////////////////////////////////////////////////////////
// gfxDWriteFont
gfxDWriteFont::gfxDWriteFont(const RefPtr<UnscaledFontDWrite>& aUnscaledFont,
                             gfxFontEntry* aFontEntry,
                             const gfxFontStyle* aFontStyle,
                             RefPtr<IDWriteFontFace> aFontFace,
                             AntialiasOption anAAOption)
    : gfxFont(aUnscaledFont, aFontEntry, aFontStyle, anAAOption),
      mFontFace(aFontFace ? aFontFace : aUnscaledFont->GetFontFace()),
      mMetrics(nullptr),
      mUseSubpixelPositions(false),
      mAllowManualShowGlyphs(true),
      mAzureScaledFontUsedClearType(false) {
  // If the IDWriteFontFace1 interface is available, we can use that for
  // faster glyph width retrieval.
  mFontFace->QueryInterface(__uuidof(IDWriteFontFace1),
                            (void**)getter_AddRefs(mFontFace1));

  ComputeMetrics(anAAOption);
}

gfxDWriteFont::~gfxDWriteFont() { delete mMetrics; }

void gfxDWriteFont::UpdateSystemTextQuality() {
  BYTE newQuality = GetSystemTextQuality();
  if (gfxVars::SystemTextQuality() != newQuality) {
    gfxVars::SetSystemTextQuality(newQuality);
  }
}

void gfxDWriteFont::SystemTextQualityChanged() {
  // If ClearType status has changed, update our value,
  Factory::SetSystemTextQuality(gfxVars::SystemTextQuality());
  // flush cached stuff that depended on the old setting, and force
  // reflow everywhere to ensure we are using correct glyph metrics.
  gfxPlatform::FlushFontAndWordCaches();
  gfxPlatform::ForceGlobalReflow();
}

UniquePtr<gfxFont> gfxDWriteFont::CopyWithAntialiasOption(
    AntialiasOption anAAOption) {
  auto entry = static_cast<gfxDWriteFontEntry*>(mFontEntry.get());
  RefPtr<UnscaledFontDWrite> unscaledFont =
      static_cast<UnscaledFontDWrite*>(mUnscaledFont.get());
  return MakeUnique<gfxDWriteFont>(unscaledFont, entry, &mStyle, mFontFace,
                                   anAAOption);
}

const gfxFont::Metrics& gfxDWriteFont::GetHorizontalMetrics() {
  return *mMetrics;
}

bool gfxDWriteFont::GetFakeMetricsForArialBlack(
    DWRITE_FONT_METRICS* aFontMetrics) {
  gfxFontStyle style(mStyle);
  style.weight = FontWeight(700);

  gfxFontEntry* fe = gfxPlatformFontList::PlatformFontList()->FindFontForFamily(
      NS_LITERAL_CSTRING("Arial"), &style);
  if (!fe || fe == mFontEntry) {
    return false;
  }

  RefPtr<gfxFont> font = fe->FindOrMakeFont(&style);
  gfxDWriteFont* dwFont = static_cast<gfxDWriteFont*>(font.get());
  dwFont->mFontFace->GetMetrics(aFontMetrics);

  return true;
}

void gfxDWriteFont::ComputeMetrics(AntialiasOption anAAOption) {
  DWRITE_FONT_METRICS fontMetrics;
  if (!(mFontEntry->Weight().Min() == FontWeight(900) &&
        mFontEntry->Weight().Max() == FontWeight(900) &&
        !mFontEntry->IsUserFont() &&
        mFontEntry->Name().EqualsLiteral("Arial Black") &&
        GetFakeMetricsForArialBlack(&fontMetrics))) {
    mFontFace->GetMetrics(&fontMetrics);
  }

  if (mStyle.sizeAdjust >= 0.0) {
    gfxFloat aspect =
        (gfxFloat)fontMetrics.xHeight / fontMetrics.designUnitsPerEm;
    mAdjustedSize = mStyle.GetAdjustedSize(aspect);
  } else {
    mAdjustedSize = mStyle.size;
  }

  // Note that GetMeasuringMode depends on mAdjustedSize
  if ((anAAOption == gfxFont::kAntialiasDefault && UsingClearType() &&
       GetMeasuringMode() == DWRITE_MEASURING_MODE_NATURAL) ||
      anAAOption == gfxFont::kAntialiasSubpixel) {
    mUseSubpixelPositions = true;
    // note that this may be reset to FALSE if we determine that a bitmap
    // strike is going to be used
  }

  gfxDWriteFontEntry* fe = static_cast<gfxDWriteFontEntry*>(mFontEntry.get());
  if (fe->IsCJKFont() && HasBitmapStrikeForSize(NS_lround(mAdjustedSize))) {
    mAdjustedSize = NS_lround(mAdjustedSize);
    mUseSubpixelPositions = false;
    // if we have bitmaps, we need to tell Cairo NOT to use subpixel AA,
    // to avoid the manual-subpixel codepath in cairo-d2d-surface.cpp
    // which fails to render bitmap glyphs (see bug 626299).
    // This option will be passed to the cairo_dwrite_scaled_font_t
    // after creation.
    mAllowManualShowGlyphs = false;
  }

  mMetrics = new gfxFont::Metrics;
  ::memset(mMetrics, 0, sizeof(*mMetrics));

  mFUnitsConvFactor = float(mAdjustedSize / fontMetrics.designUnitsPerEm);

  mMetrics->xHeight = fontMetrics.xHeight * mFUnitsConvFactor;
  mMetrics->capHeight = fontMetrics.capHeight * mFUnitsConvFactor;

  mMetrics->maxAscent = round(fontMetrics.ascent * mFUnitsConvFactor);
  mMetrics->maxDescent = round(fontMetrics.descent * mFUnitsConvFactor);
  mMetrics->maxHeight = mMetrics->maxAscent + mMetrics->maxDescent;

  mMetrics->emHeight = mAdjustedSize;
  mMetrics->emAscent =
      mMetrics->emHeight * mMetrics->maxAscent / mMetrics->maxHeight;
  mMetrics->emDescent = mMetrics->emHeight - mMetrics->emAscent;

  mMetrics->maxAdvance = mAdjustedSize;

  // try to get the true maxAdvance value from 'hhea'
  gfxFontEntry::AutoTable hheaTable(GetFontEntry(),
                                    TRUETYPE_TAG('h', 'h', 'e', 'a'));
  if (hheaTable) {
    uint32_t len;
    const MetricsHeader* hhea = reinterpret_cast<const MetricsHeader*>(
        hb_blob_get_data(hheaTable, &len));
    if (len >= sizeof(MetricsHeader)) {
      mMetrics->maxAdvance =
          uint16_t(hhea->advanceWidthMax) * mFUnitsConvFactor;
    }
  }

  mMetrics->internalLeading =
      std::max(mMetrics->maxHeight - mMetrics->emHeight, 0.0);
  mMetrics->externalLeading = ceil(fontMetrics.lineGap * mFUnitsConvFactor);

  UINT32 ucs = L' ';
  UINT16 glyph;
  if (SUCCEEDED(mFontFace->GetGlyphIndices(&ucs, 1, &glyph)) && glyph != 0) {
    mSpaceGlyph = glyph;
    mMetrics->spaceWidth = MeasureGlyphWidth(glyph);
  } else {
    mMetrics->spaceWidth = 0;
  }

  // try to get aveCharWidth from the OS/2 table, fall back to measuring 'x'
  // if the table is not available or if using hinted/pixel-snapped widths
  if (mUseSubpixelPositions) {
    mMetrics->aveCharWidth = 0;
    gfxFontEntry::AutoTable os2Table(GetFontEntry(),
                                     TRUETYPE_TAG('O', 'S', '/', '2'));
    if (os2Table) {
      uint32_t len;
      const OS2Table* os2 =
          reinterpret_cast<const OS2Table*>(hb_blob_get_data(os2Table, &len));
      if (len >= 4) {
        // Not checking against sizeof(mozilla::OS2Table) here because older
        // versions of the table have different sizes; we only need the first
        // two 16-bit fields here.
        mMetrics->aveCharWidth =
            int16_t(os2->xAvgCharWidth) * mFUnitsConvFactor;
      }
    }
  }

  if (mMetrics->aveCharWidth < 1) {
    ucs = L'x';
    if (SUCCEEDED(mFontFace->GetGlyphIndices(&ucs, 1, &glyph)) && glyph != 0) {
      mMetrics->aveCharWidth = MeasureGlyphWidth(glyph);
    }
    if (mMetrics->aveCharWidth < 1) {
      // Let's just assume the X is square.
      mMetrics->aveCharWidth = fontMetrics.xHeight * mFUnitsConvFactor;
    }
  }

  ucs = L'0';
  if (SUCCEEDED(mFontFace->GetGlyphIndices(&ucs, 1, &glyph)) && glyph != 0) {
    mMetrics->zeroWidth = MeasureGlyphWidth(glyph);
  } else {
    mMetrics->zeroWidth = -1.0;  // indicates not found
  }

  mMetrics->underlineOffset = fontMetrics.underlinePosition * mFUnitsConvFactor;
  mMetrics->underlineSize = fontMetrics.underlineThickness * mFUnitsConvFactor;
  mMetrics->strikeoutOffset =
      fontMetrics.strikethroughPosition * mFUnitsConvFactor;
  mMetrics->strikeoutSize =
      fontMetrics.strikethroughThickness * mFUnitsConvFactor;

  SanitizeMetrics(mMetrics, GetFontEntry()->mIsBadUnderlineFont);

#if 0
    printf("Font: %p (%s) size: %f\n", this,
           NS_ConvertUTF16toUTF8(GetName()).get(), mStyle.size);
    printf("    emHeight: %f emAscent: %f emDescent: %f\n", mMetrics->emHeight, mMetrics->emAscent, mMetrics->emDescent);
    printf("    maxAscent: %f maxDescent: %f maxAdvance: %f\n", mMetrics->maxAscent, mMetrics->maxDescent, mMetrics->maxAdvance);
    printf("    internalLeading: %f externalLeading: %f\n", mMetrics->internalLeading, mMetrics->externalLeading);
    printf("    spaceWidth: %f aveCharWidth: %f zeroWidth: %f\n",
           mMetrics->spaceWidth, mMetrics->aveCharWidth, mMetrics->zeroWidth);
    printf("    xHeight: %f capHeight: %f\n", mMetrics->xHeight, mMetrics->capHeight);
    printf("    uOff: %f uSize: %f stOff: %f stSize: %f\n",
           mMetrics->underlineOffset, mMetrics->underlineSize, mMetrics->strikeoutOffset, mMetrics->strikeoutSize);
#endif
}

using namespace mozilla;  // for AutoSwap_* types

struct EBLCHeader {
  AutoSwap_PRUint32 version;
  AutoSwap_PRUint32 numSizes;
};

struct SbitLineMetrics {
  int8_t ascender;
  int8_t descender;
  uint8_t widthMax;
  int8_t caretSlopeNumerator;
  int8_t caretSlopeDenominator;
  int8_t caretOffset;
  int8_t minOriginSB;
  int8_t minAdvanceSB;
  int8_t maxBeforeBL;
  int8_t minAfterBL;
  int8_t pad1;
  int8_t pad2;
};

struct BitmapSizeTable {
  AutoSwap_PRUint32 indexSubTableArrayOffset;
  AutoSwap_PRUint32 indexTablesSize;
  AutoSwap_PRUint32 numberOfIndexSubTables;
  AutoSwap_PRUint32 colorRef;
  SbitLineMetrics hori;
  SbitLineMetrics vert;
  AutoSwap_PRUint16 startGlyphIndex;
  AutoSwap_PRUint16 endGlyphIndex;
  uint8_t ppemX;
  uint8_t ppemY;
  uint8_t bitDepth;
  uint8_t flags;
};

typedef EBLCHeader EBSCHeader;

struct BitmapScaleTable {
  SbitLineMetrics hori;
  SbitLineMetrics vert;
  uint8_t ppemX;
  uint8_t ppemY;
  uint8_t substitutePpemX;
  uint8_t substitutePpemY;
};

bool gfxDWriteFont::HasBitmapStrikeForSize(uint32_t aSize) {
  uint8_t* tableData;
  uint32_t len;
  void* tableContext;
  BOOL exists;
  HRESULT hr = mFontFace->TryGetFontTable(
      DWRITE_MAKE_OPENTYPE_TAG('E', 'B', 'L', 'C'), (const void**)&tableData,
      &len, &tableContext, &exists);
  if (FAILED(hr)) {
    return false;
  }

  bool hasStrike = false;
  // not really a loop, but this lets us use 'break' to skip out of the block
  // as soon as we know the answer, and skips it altogether if the table is
  // not present
  while (exists) {
    if (len < sizeof(EBLCHeader)) {
      break;
    }
    const EBLCHeader* hdr = reinterpret_cast<const EBLCHeader*>(tableData);
    if (hdr->version != 0x00020000) {
      break;
    }
    uint32_t numSizes = hdr->numSizes;
    if (numSizes > 0xffff) {  // sanity-check, prevent overflow below
      break;
    }
    if (len < sizeof(EBLCHeader) + numSizes * sizeof(BitmapSizeTable)) {
      break;
    }
    const BitmapSizeTable* sizeTable =
        reinterpret_cast<const BitmapSizeTable*>(hdr + 1);
    for (uint32_t i = 0; i < numSizes; ++i, ++sizeTable) {
      if (sizeTable->ppemX == aSize && sizeTable->ppemY == aSize) {
        // we ignore a strike that contains fewer than 4 glyphs,
        // as that probably indicates a font such as Courier New
        // that provides bitmaps ONLY for the "shading" characters
        // U+2591..2593
        hasStrike = (uint16_t(sizeTable->endGlyphIndex) >=
                     uint16_t(sizeTable->startGlyphIndex) + 3);
        break;
      }
    }
    // if we reach here, we didn't find a strike; unconditionally break
    // out of the while-loop block
    break;
  }
  mFontFace->ReleaseFontTable(tableContext);

  if (hasStrike) {
    return true;
  }

  // if we didn't find a real strike, check if the font calls for scaling
  // another bitmap to this size
  hr = mFontFace->TryGetFontTable(DWRITE_MAKE_OPENTYPE_TAG('E', 'B', 'S', 'C'),
                                  (const void**)&tableData, &len, &tableContext,
                                  &exists);
  if (FAILED(hr)) {
    return false;
  }

  while (exists) {
    if (len < sizeof(EBSCHeader)) {
      break;
    }
    const EBSCHeader* hdr = reinterpret_cast<const EBSCHeader*>(tableData);
    if (hdr->version != 0x00020000) {
      break;
    }
    uint32_t numSizes = hdr->numSizes;
    if (numSizes > 0xffff) {
      break;
    }
    if (len < sizeof(EBSCHeader) + numSizes * sizeof(BitmapScaleTable)) {
      break;
    }
    const BitmapScaleTable* scaleTable =
        reinterpret_cast<const BitmapScaleTable*>(hdr + 1);
    for (uint32_t i = 0; i < numSizes; ++i, ++scaleTable) {
      if (scaleTable->ppemX == aSize && scaleTable->ppemY == aSize) {
        hasStrike = true;
        break;
      }
    }
    break;
  }
  mFontFace->ReleaseFontTable(tableContext);

  return hasStrike;
}

bool gfxDWriteFont::IsValid() const { return mFontFace != nullptr; }

IDWriteFontFace* gfxDWriteFont::GetFontFace() { return mFontFace.get(); }

gfxFont::RunMetrics gfxDWriteFont::Measure(const gfxTextRun* aTextRun,
                                           uint32_t aStart, uint32_t aEnd,
                                           BoundingBoxType aBoundingBoxType,
                                           DrawTarget* aRefDrawTarget,
                                           Spacing* aSpacing,
                                           gfx::ShapedTextFlags aOrientation) {
  gfxFont::RunMetrics metrics =
      gfxFont::Measure(aTextRun, aStart, aEnd, aBoundingBoxType, aRefDrawTarget,
                       aSpacing, aOrientation);

  // if aBoundingBoxType is LOOSE_INK_EXTENTS
  // and the underlying cairo font may be antialiased,
  // we can't trust Windows to have considered all the pixels
  // so we need to add "padding" to the bounds.
  // (see bugs 475968, 439831, compare also bug 445087)
  if (aBoundingBoxType == LOOSE_INK_EXTENTS &&
      mAntialiasOption != kAntialiasNone &&
      GetMeasuringMode() == DWRITE_MEASURING_MODE_GDI_CLASSIC &&
      metrics.mBoundingBox.Width() > 0) {
    metrics.mBoundingBox.MoveByX(-aTextRun->GetAppUnitsPerDevUnit());
    metrics.mBoundingBox.SetWidth(metrics.mBoundingBox.Width() +
                                  aTextRun->GetAppUnitsPerDevUnit() * 3);
  }

  return metrics;
}

bool gfxDWriteFont::ProvidesGlyphWidths() const {
  return !mUseSubpixelPositions ||
         (mFontFace->GetSimulations() & DWRITE_FONT_SIMULATIONS_BOLD) ||
         (((gfxDWriteFontEntry*)(GetFontEntry()))->HasVariations() &&
          !mStyle.variationSettings.IsEmpty());
}

int32_t gfxDWriteFont::GetGlyphWidth(uint16_t aGID) {
  if (!mGlyphWidths) {
    mGlyphWidths = MakeUnique<nsDataHashtable<nsUint32HashKey, int32_t>>(128);
  }

  int32_t width = -1;
  if (mGlyphWidths->Get(aGID, &width)) {
    return width;
  }

  width = NS_lround(MeasureGlyphWidth(aGID) * 65536.0);
  mGlyphWidths->Put(aGID, width);
  return width;
}

bool gfxDWriteFont::GetForceGDIClassic() const {
  return static_cast<gfxDWriteFontEntry*>(mFontEntry.get())
             ->GetForceGDIClassic() &&
         cairo_dwrite_get_cleartype_rendering_mode() < 0 &&
         GetAdjustedSize() <= gfxDWriteFontList::PlatformFontList()
                                  ->GetForceGDIClassicMaxFontSize();
}

DWRITE_MEASURING_MODE
gfxDWriteFont::GetMeasuringMode() const {
  return GetForceGDIClassic()
             ? DWRITE_MEASURING_MODE_GDI_CLASSIC
             : gfxWindowsPlatform::GetPlatform()->DWriteMeasuringMode();
}

gfxFloat gfxDWriteFont::MeasureGlyphWidth(uint16_t aGlyph) {
  MOZ_SEH_TRY {
    HRESULT hr;
    if (mFontFace1) {
      int32_t advance;
      if (mUseSubpixelPositions) {
        hr = mFontFace1->GetDesignGlyphAdvances(1, &aGlyph, &advance, FALSE);
        if (SUCCEEDED(hr)) {
          return advance * mFUnitsConvFactor;
        }
      } else {
        hr = mFontFace1->GetGdiCompatibleGlyphAdvances(
            FLOAT(mAdjustedSize), 1.0f, nullptr,
            GetMeasuringMode() == DWRITE_MEASURING_MODE_GDI_NATURAL, FALSE, 1,
            &aGlyph, &advance);
        if (SUCCEEDED(hr)) {
          return NS_lround(advance * mFUnitsConvFactor);
        }
      }
    } else {
      DWRITE_GLYPH_METRICS metrics;
      if (mUseSubpixelPositions) {
        hr = mFontFace->GetDesignGlyphMetrics(&aGlyph, 1, &metrics, FALSE);
        if (SUCCEEDED(hr)) {
          return metrics.advanceWidth * mFUnitsConvFactor;
        }
      } else {
        hr = mFontFace->GetGdiCompatibleGlyphMetrics(
            FLOAT(mAdjustedSize), 1.0f, nullptr,
            GetMeasuringMode() == DWRITE_MEASURING_MODE_GDI_NATURAL, &aGlyph, 1,
            &metrics, FALSE);
        if (SUCCEEDED(hr)) {
          return NS_lround(metrics.advanceWidth * mFUnitsConvFactor);
        }
      }
    }
  }
  MOZ_SEH_EXCEPT(EXCEPTION_EXECUTE_HANDLER) {
    // Exception (e.g. disk i/o error) occurred when DirectWrite tried to use
    // the font resource; possibly a failing drive or similar hardware issue.
    // Mark the font as invalid, and wipe the fontEntry's charmap so that font
    // selection will skip it; we'll use a fallback font instead.
    mIsValid = false;
    GetFontEntry()->mCharacterMap = new gfxCharacterMap();
    GetFontEntry()->mShmemCharacterMap = nullptr;
    gfxCriticalError() << "Exception occurred measuring glyph width for "
                       << GetFontEntry()->Name().get();
  }
  return 0.0;
}

bool gfxDWriteFont::GetGlyphBounds(uint16_t aGID, gfxRect* aBounds,
                                   bool aTight) {
  DWRITE_GLYPH_METRICS m;
  HRESULT hr = mFontFace->GetDesignGlyphMetrics(&aGID, 1, &m, FALSE);
  if (FAILED(hr)) {
    return false;
  }
  gfxRect bounds(m.leftSideBearing, m.topSideBearing - m.verticalOriginY,
                 m.advanceWidth - m.leftSideBearing - m.rightSideBearing,
                 m.advanceHeight - m.topSideBearing - m.bottomSideBearing);
  bounds.Scale(mFUnitsConvFactor);
  // GetDesignGlyphMetrics returns 'ideal' glyph metrics, we need to pad to
  // account for antialiasing.
  if (!aTight && !aBounds->IsEmpty()) {
    bounds.Inflate(1.0, 0.0);
  }
  *aBounds = bounds;
  return true;
}

void gfxDWriteFont::AddSizeOfExcludingThis(MallocSizeOf aMallocSizeOf,
                                           FontCacheSizes* aSizes) const {
  gfxFont::AddSizeOfExcludingThis(aMallocSizeOf, aSizes);
  aSizes->mFontInstances += aMallocSizeOf(mMetrics);
  if (mGlyphWidths) {
    aSizes->mFontInstances +=
        mGlyphWidths->ShallowSizeOfIncludingThis(aMallocSizeOf);
  }
}

void gfxDWriteFont::AddSizeOfIncludingThis(MallocSizeOf aMallocSizeOf,
                                           FontCacheSizes* aSizes) const {
  aSizes->mFontInstances += aMallocSizeOf(this);
  AddSizeOfExcludingThis(aMallocSizeOf, aSizes);
}

already_AddRefed<ScaledFont> gfxDWriteFont::GetScaledFont(
    mozilla::gfx::DrawTarget* aTarget) {
  if (mAzureScaledFontUsedClearType != UsingClearType()) {
    mAzureScaledFont = nullptr;
  }
  if (!mAzureScaledFont) {
    gfxDWriteFontEntry* fe = static_cast<gfxDWriteFontEntry*>(mFontEntry.get());
    bool forceGDI = GetForceGDIClassic();

    IDWriteRenderingParams* params =
        gfxWindowsPlatform::GetPlatform()->GetRenderingParams(
            UsingClearType()
                ? (forceGDI ? gfxWindowsPlatform::TEXT_RENDERING_GDI_CLASSIC
                            : gfxWindowsPlatform::TEXT_RENDERING_NORMAL)
                : gfxWindowsPlatform::TEXT_RENDERING_NO_CLEARTYPE);

    DWRITE_RENDERING_MODE renderingMode = params->GetRenderingMode();
    FLOAT gamma = params->GetGamma();
    FLOAT contrast = params->GetEnhancedContrast();
    FLOAT clearTypeLevel = params->GetClearTypeLevel();
    if (forceGDI || renderingMode == DWRITE_RENDERING_MODE_GDI_CLASSIC) {
      renderingMode = DWRITE_RENDERING_MODE_GDI_CLASSIC;
      gamma = GetSystemGDIGamma();
      contrast = 0.0f;
    }

    bool useEmbeddedBitmap =
        (renderingMode == DWRITE_RENDERING_MODE_DEFAULT ||
         renderingMode == DWRITE_RENDERING_MODE_GDI_CLASSIC) &&
        fe->IsCJKFont() && HasBitmapStrikeForSize(NS_lround(mAdjustedSize));

    const gfxFontStyle* fontStyle = GetStyle();
    mAzureScaledFont = Factory::CreateScaledFontForDWriteFont(
        mFontFace, fontStyle, GetUnscaledFont(), GetAdjustedSize(),
        useEmbeddedBitmap, (int)renderingMode, params, gamma, contrast,
        clearTypeLevel);
    if (!mAzureScaledFont) {
      return nullptr;
    }
    InitializeScaledFont();
    mAzureScaledFontUsedClearType = UsingClearType();
  }

  RefPtr<ScaledFont> scaledFont(mAzureScaledFont);
  return scaledFont.forget();
}

bool gfxDWriteFont::ShouldRoundXOffset(cairo_t* aCairo) const {
  // show_glyphs is implemented on the font and so is used for all Cairo
  // surface types; however, it may pixel-snap depending on the dwrite
  // rendering mode
  return GetForceGDIClassic() ||
         gfxWindowsPlatform::GetPlatform()->DWriteMeasuringMode() !=
             DWRITE_MEASURING_MODE_NATURAL;
}
