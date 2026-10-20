/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef FONT_PALETTE_CACHE_H
#define FONT_PALETTE_CACHE_H

#include <utility>

#include "harfbuzz/hb.h"
#include "mozilla/HashFunctions.h"
#include "mozilla/MruCache.h"
#include "mozilla/RefPtr.h"
#include "mozilla/gfx/Types.h"
#include "nsAtom.h"
#include "nsTArray.h"
#include <utility>

class gfxFontEntry;

class gfxFontEntry;

namespace mozilla::gfx {

class FontPaletteValueSet;

// A resolved font palette as an array of colors.
class FontPalette {
  NS_INLINE_DECL_THREADSAFE_REFCOUNTING(FontPalette);

 public:
  FontPalette() = default;
  explicit FontPalette(nsTArray<hb_color_t>&& aColors)
      : mColors(std::move(aColors)) {}

  const nsTArray<hb_color_t>* Colors() const { return &mColors; }

 private:
  ~FontPalette() = default;

  nsTArray<hb_color_t> mColors;
};

// MRU cache used for resolved color-font palettes, to avoid reconstructing
// the palette for each glyph rendered with a given font.
using CacheKey = RefPtr<nsAtom>;
struct CacheData {
  CacheKey mKey;
  RefPtr<FontPalette> mPalette;
};

// PaletteCache is attached to a specific gfxFontEntry and holds palettes found
// in that font, with lookup by palette name.
class PaletteCache
    : public mozilla::MruCache<CacheKey, CacheData, PaletteCache, 7> {
 public:
  PaletteCache() = default;

  // Get the palette named aPaletteName, if present.
  already_AddRefed<FontPalette> GetCachedPalette(
      mozilla::gfx::FontPaletteValueSet* aPaletteValueSet,
      nsAtom* aPaletteName);

  // Store the given palette in the cache.
  void AddPalette(mozilla::gfx::FontPaletteValueSet* aPaletteValueSet,
                  nsAtom* aPaletteName, mozilla::gfx::FontPalette* aPalette);

  static bool IsEmpty(const CacheData& aVal) { return !aVal.mKey; }
  static mozilla::HashNumber Hash(const CacheKey& aKey) {
    return mozilla::HashGeneric(aKey.get());
  }
  static bool Match(const CacheKey& aKey, const CacheData& aVal) {
    return aVal.mKey == aKey;
  }

 protected:
  // The palette value set for which cached entries were created.
  RefPtr<FontPaletteValueSet> mPaletteValueSet;
};

}  // namespace mozilla::gfx

#endif
