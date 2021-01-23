/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef MOZILLA_GFX_SCALEDFONTBASE_H_
#define MOZILLA_GFX_SCALEDFONTBASE_H_

#include "2D.h"

// Skia uses cairo_scaled_font_t as the internal font type in ScaledFont
#if defined(USE_SKIA) || defined(USE_CAIRO)
#  define USE_CAIRO_SCALED_FONT
#endif

#ifdef USE_SKIA
#  include "skia/include/core/SkFont.h"
#  include "skia/include/core/SkPath.h"
#  include "skia/include/core/SkTypeface.h"
#endif
#ifdef USE_CAIRO_SCALED_FONT
#  include "cairo.h"
#endif

namespace mozilla {
namespace gfx {

class ScaledFontBase : public ScaledFont {
 public:
  MOZ_DECLARE_REFCOUNTED_VIRTUAL_TYPENAME(ScaledFontBase, override)

  ScaledFontBase(const RefPtr<UnscaledFont>& aUnscaledFont, Float aSize);
  virtual ~ScaledFontBase();

  virtual already_AddRefed<Path> GetPathForGlyphs(
      const GlyphBuffer& aBuffer, const DrawTarget* aTarget) override;

  virtual void CopyGlyphsToBuilder(const GlyphBuffer& aBuffer,
                                   PathBuilder* aBuilder,
                                   const Matrix* aTransformHint) override;

  virtual Float GetSize() const override { return mSize; }

#ifdef USE_SKIA
  SkTypeface* GetSkTypeface();
  virtual void SetupSkFontDrawOptions(SkFont& aFont) {}
#endif

#ifdef USE_CAIRO_SCALED_FONT
  virtual cairo_scaled_font_t* GetCairoScaledFont() override;
#endif

 protected:
  friend class DrawTargetSkia;
#ifdef USE_SKIA
  Atomic<SkTypeface*> mTypeface;
  virtual SkTypeface* CreateSkTypeface() { return nullptr; }
  SkPath GetSkiaPathForGlyphs(const GlyphBuffer& aBuffer);
#endif
#ifdef USE_CAIRO_SCALED_FONT
  virtual cairo_font_face_t* CreateCairoFontFace(
      cairo_font_options_t* aFontOptions) {
    return nullptr;
  }
  virtual void PrepareCairoScaledFont(cairo_scaled_font_t* aFont) {}
  cairo_scaled_font_t* mScaledFont;
#endif
  Float mSize;
};

}  // namespace gfx
}  // namespace mozilla

#endif /* MOZILLA_GFX_SCALEDFONTBASE_H_ */
