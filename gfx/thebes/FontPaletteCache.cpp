/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "FontPaletteCache.h"
#include "COLRFonts.h"
#include "gfxFontEntry.h"

using namespace mozilla;

// Return a cached palette, if present; the caller is holding a read lock.
already_AddRefed<gfx::FontPalette> gfx::PaletteCache::GetCachedPalette(
    gfx::FontPaletteValueSet* aPaletteValueSet, nsAtom* aPaletteName) {
  if (aPaletteValueSet != mPaletteValueSet) {
    return nullptr;
  }

  auto entry = Lookup(aPaletteName);
  if (entry) {
    RefPtr result = entry.Data().mPalette;
    return result.forget();
  }

  return nullptr;
}

// Add a palette to the cache, checking that the palette value set matches.
void gfx::PaletteCache::AddPalette(gfx::FontPaletteValueSet* aPaletteValueSet,
                                   nsAtom* aPaletteName,
                                   gfx::FontPalette* aPalette) {
  if (aPaletteValueSet != mPaletteValueSet) {
    // Discard any palettes that were created for a different value set.
    Clear();
    mPaletteValueSet = aPaletteValueSet;
  }

  CacheData newData;
  newData.mKey = aPaletteName;
  newData.mPalette = aPalette;
  Put(aPaletteName, std::move(newData));
}
