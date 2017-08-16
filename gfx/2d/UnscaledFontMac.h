/* -*- Mode: C++; tab-width: 20; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef MOZILLA_GFX_UNSCALEDFONTMAC_H_
#define MOZILLA_GFX_UNSCALEDFONTMAC_H_

#ifdef MOZ_WIDGET_COCOA
#include <ApplicationServices/ApplicationServices.h>
#else
#include <CoreGraphics/CoreGraphics.h>
#include <CoreText/CoreText.h>
#endif

#include "2D.h"

namespace mozilla {
namespace gfx {

class UnscaledFontMac final : public UnscaledFont
{
public:
  MOZ_DECLARE_REFCOUNTED_VIRTUAL_TYPENAME(UnscaledFontMac, override)
  explicit UnscaledFontMac(CGFontRef aFont)
    : mFont(aFont)
  {
    CFRetain(mFont);
  }
  ~UnscaledFontMac()
  {
    CFRelease(mFont);
  }

  FontType GetType() const override { return FontType::MAC; }

  CGFontRef GetFont() const { return mFont; }

  bool GetFontFileData(FontFileDataOutput aDataCallback, void *aBaton) override;

  already_AddRefed<ScaledFont>
    CreateScaledFont(Float aGlyphSize,
                     const uint8_t* aInstanceData,
                     uint32_t aInstanceDataLength) override;

  static CGFontRef
    CreateCGFontWithVariations(CGFontRef aFont,
                               uint32_t aVariationCount,
                               const FontVariation* aVariations);

private:
  CGFontRef mFont;
};

} // namespace gfx
} // namespace mozilla

#endif /* MOZILLA_GFX_UNSCALEDFONTMAC_H_ */

