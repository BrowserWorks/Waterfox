/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef MOZILLA_GFX_SCALEDFONTDWRITE_H_
#define MOZILLA_GFX_SCALEDFONTDWRITE_H_

#include <dwrite.h>
#include "ScaledFontBase.h"

struct ID2D1GeometrySink;
struct gfxFontStyle;

namespace mozilla {
namespace gfx {

class NativeFontResourceDWrite;
class UnscaledFontDWrite;

class ScaledFontDWrite final : public ScaledFontBase {
 public:
  MOZ_DECLARE_REFCOUNTED_VIRTUAL_TYPENAME(ScaledFontDWrite, override)
  ScaledFontDWrite(IDWriteFontFace* aFont,
                   const RefPtr<UnscaledFont>& aUnscaledFont, Float aSize)
      : ScaledFontBase(aUnscaledFont, aSize),
        mFontFace(aFont),
        mUseEmbeddedBitmap(false),
        mRenderingMode(DWRITE_RENDERING_MODE_DEFAULT),
        mGamma(2.2f),
        mContrast(1.0f),
        mClearTypeLevel(1.0f) {}

  ScaledFontDWrite(IDWriteFontFace* aFontFace,
                   const RefPtr<UnscaledFont>& aUnscaledFont, Float aSize,
                   bool aUseEmbeddedBitmap,
                   DWRITE_RENDERING_MODE aRenderingMode,
                   IDWriteRenderingParams* aParams, Float aGamma,
                   Float aContrast, Float aClearTypeLevel,
                   const gfxFontStyle* aStyle = nullptr);

  FontType GetType() const override { return FontType::DWRITE; }

  already_AddRefed<Path> GetPathForGlyphs(const GlyphBuffer& aBuffer,
                                          const DrawTarget* aTarget) override;
  void CopyGlyphsToBuilder(const GlyphBuffer& aBuffer, PathBuilder* aBuilder,
                           const Matrix* aTransformHint) override;

  void CopyGlyphsToSink(const GlyphBuffer& aBuffer,
                        ID2D1SimplifiedGeometrySink* aSink);

  bool CanSerialize() override { return true; }

  bool GetFontInstanceData(FontInstanceDataOutput aCb, void* aBaton) override;

  bool GetWRFontInstanceOptions(
      Maybe<wr::FontInstanceOptions>* aOutOptions,
      Maybe<wr::FontInstancePlatformOptions>* aOutPlatformOptions,
      std::vector<FontVariation>* aOutVariations) override;

  AntialiasMode GetDefaultAAMode() override;

  bool UseEmbeddedBitmaps() const { return mUseEmbeddedBitmap; }
  bool ForceGDIMode() const {
    return mRenderingMode == DWRITE_RENDERING_MODE_GDI_CLASSIC;
  }
  DWRITE_RENDERING_MODE GetRenderingMode() const { return mRenderingMode; }

  bool HasSyntheticBold() const {
    return (mFontFace->GetSimulations() & DWRITE_FONT_SIMULATIONS_BOLD) != 0;
  }

#ifdef USE_SKIA
  SkTypeface* CreateSkTypeface() override;
  void SetupSkFontDrawOptions(SkFont& aFont) override;
  SkFontStyle mStyle;
#endif

  RefPtr<IDWriteFontFace> mFontFace;
  bool mUseEmbeddedBitmap;
  DWRITE_RENDERING_MODE mRenderingMode;
  // DrawTargetD2D1 requires the IDWriteRenderingParams,
  // but we also separately need to store the gamma and contrast
  // since Skia needs to be able to access these without having
  // to use the full set of DWrite parameters (which would be
  // required to recreate an IDWriteRenderingParams) in a
  // DrawTargetRecording playback.
  RefPtr<IDWriteRenderingParams> mParams;
  Float mGamma;
  Float mContrast;
  Float mClearTypeLevel;

#ifdef USE_CAIRO_SCALED_FONT
  cairo_font_face_t* CreateCairoFontFace(
      cairo_font_options_t* aFontOptions) override;
  void PrepareCairoScaledFont(cairo_scaled_font_t* aFont) override;
#endif

 private:
  friend class NativeFontResourceDWrite;
  friend class UnscaledFontDWrite;

  struct InstanceData {
    explicit InstanceData(ScaledFontDWrite* aScaledFont)
        : mUseEmbeddedBitmap(aScaledFont->mUseEmbeddedBitmap),
          mApplySyntheticBold(aScaledFont->HasSyntheticBold()),
          mRenderingMode(aScaledFont->mRenderingMode),
          mGamma(aScaledFont->mGamma),
          mContrast(aScaledFont->mContrast),
          mClearTypeLevel(aScaledFont->mClearTypeLevel) {}

    InstanceData(const wr::FontInstanceOptions* aOptions,
                 const wr::FontInstancePlatformOptions* aPlatformOptions);

    bool mUseEmbeddedBitmap;
    bool mApplySyntheticBold;
    DWRITE_RENDERING_MODE mRenderingMode;
    Float mGamma;
    Float mContrast;
    Float mClearTypeLevel;
  };
};

}  // namespace gfx
}  // namespace mozilla

#endif /* MOZILLA_GFX_SCALEDFONTDWRITE_H_ */
