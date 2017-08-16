/* -*- Mode: C++; tab-width: 20; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "gfxFT2FontBase.h"
#include "gfxFT2Utils.h"
#include "harfbuzz/hb.h"
#include "mozilla/Likely.h"
#include "gfxFontConstants.h"
#include "gfxFontUtils.h"

using namespace mozilla::gfx;

gfxFT2FontBase::gfxFT2FontBase(const RefPtr<UnscaledFontFreeType>& aUnscaledFont,
                               cairo_scaled_font_t *aScaledFont,
                               gfxFontEntry *aFontEntry,
                               const gfxFontStyle *aFontStyle)
    : gfxFont(aUnscaledFont, aFontEntry, aFontStyle, kAntialiasDefault, aScaledFont),
      mSpaceGlyph(0),
      mHasMetrics(false)
{
    cairo_scaled_font_reference(mScaledFont);
    gfxFT2LockedFace face(this);
    mFUnitsConvFactor = face.XScale();
}

gfxFT2FontBase::~gfxFT2FontBase()
{
    cairo_scaled_font_destroy(mScaledFont);
}

uint32_t
gfxFT2FontBase::GetGlyph(uint32_t aCharCode)
{
    // FcFreeTypeCharIndex needs to lock the FT_Face and can end up searching
    // through all the postscript glyph names in the font.  Therefore use a
    // lightweight cache, which is stored on the cairo_font_face_t.

    cairo_font_face_t *face =
        cairo_scaled_font_get_font_face(CairoScaledFont());

    if (cairo_font_face_status(face) != CAIRO_STATUS_SUCCESS)
        return 0;

    // This cache algorithm and size is based on what is done in
    // cairo_scaled_font_text_to_glyphs and pango_fc_font_real_get_glyph.  I
    // think the concept is that adjacent characters probably come mostly from
    // one Unicode block.  This assumption is probably not so valid with
    // scripts with large character sets as used for East Asian languages.

    struct CmapCacheSlot {
        uint32_t mCharCode;
        uint32_t mGlyphIndex;
    };
    const uint32_t kNumSlots = 256;
    static cairo_user_data_key_t sCmapCacheKey;

    CmapCacheSlot *slots = static_cast<CmapCacheSlot*>
        (cairo_font_face_get_user_data(face, &sCmapCacheKey));

    if (!slots) {
        // cairo's caches can keep some cairo_font_faces alive past our last
        // destroy, so the destroy function (free) for the cache must be
        // callable from cairo without any assumptions about what other
        // modules have not been shutdown.
        slots = static_cast<CmapCacheSlot*>
            (calloc(kNumSlots, sizeof(CmapCacheSlot)));
        if (!slots)
            return 0;

        cairo_status_t status =
            cairo_font_face_set_user_data(face, &sCmapCacheKey, slots, free);
        if (status != CAIRO_STATUS_SUCCESS) { // OOM
            free(slots);
            return 0;
        }

        // Invalidate slot 0 by setting its char code to something that would
        // never end up in slot 0.  All other slots are already invalid
        // because they have mCharCode = 0 and a glyph for char code 0 will
        // always be in the slot 0.
        slots[0].mCharCode = 1;
    }

    CmapCacheSlot *slot = &slots[aCharCode % kNumSlots];
    if (slot->mCharCode != aCharCode) {
        slot->mCharCode = aCharCode;
        slot->mGlyphIndex = gfxFT2LockedFace(this).GetGlyph(aCharCode);
    }

    return slot->mGlyphIndex;
}

void
gfxFT2FontBase::GetGlyphExtents(uint32_t aGlyph, cairo_text_extents_t* aExtents)
{
    NS_PRECONDITION(aExtents != nullptr, "aExtents must not be NULL");

    cairo_glyph_t glyphs[1];
    glyphs[0].index = aGlyph;
    glyphs[0].x = 0.0;
    glyphs[0].y = 0.0;
    // cairo does some caching for us here but perhaps a small gain could be
    // made by caching more.  It is usually only the advance that is needed,
    // so caching only the advance could allow many requests to be cached with
    // little memory use.  Ideally this cache would be merged with
    // gfxGlyphExtents.
    cairo_scaled_font_glyph_extents(CairoScaledFont(), glyphs, 1, aExtents);
}

const gfxFont::Metrics&
gfxFT2FontBase::GetHorizontalMetrics()
{
    if (mHasMetrics)
        return mMetrics;

    if (MOZ_UNLIKELY(GetStyle()->size <= 0.0) ||
        MOZ_UNLIKELY(GetStyle()->sizeAdjust == 0.0)) {
        new(&mMetrics) gfxFont::Metrics(); // zero initialize
        mSpaceGlyph = GetGlyph(' ');
    } else {
        gfxFT2LockedFace face(this);
        face.GetMetrics(&mMetrics, &mSpaceGlyph);
    }

    SanitizeMetrics(&mMetrics, false);

#if 0
    //    printf("font name: %s %f\n", NS_ConvertUTF16toUTF8(GetName()).get(), GetStyle()->size);
    //    printf ("pango font %s\n", pango_font_description_to_string (pango_font_describe (font)));

    fprintf (stderr, "Font: %s\n", NS_ConvertUTF16toUTF8(GetName()).get());
    fprintf (stderr, "    emHeight: %f emAscent: %f emDescent: %f\n", mMetrics.emHeight, mMetrics.emAscent, mMetrics.emDescent);
    fprintf (stderr, "    maxAscent: %f maxDescent: %f\n", mMetrics.maxAscent, mMetrics.maxDescent);
    fprintf (stderr, "    internalLeading: %f externalLeading: %f\n", mMetrics.externalLeading, mMetrics.internalLeading);
    fprintf (stderr, "    spaceWidth: %f aveCharWidth: %f xHeight: %f\n", mMetrics.spaceWidth, mMetrics.aveCharWidth, mMetrics.xHeight);
    fprintf (stderr, "    uOff: %f uSize: %f stOff: %f stSize: %f\n", mMetrics.underlineOffset, mMetrics.underlineSize, mMetrics.strikeoutOffset, mMetrics.strikeoutSize);
#endif

    mHasMetrics = true;
    return mMetrics;
}

// Get the glyphID of a space
uint32_t
gfxFT2FontBase::GetSpaceGlyph()
{
    GetHorizontalMetrics();
    return mSpaceGlyph;
}

uint32_t
gfxFT2FontBase::GetGlyph(uint32_t unicode, uint32_t variation_selector)
{
    if (variation_selector) {
        uint32_t id =
            gfxFT2LockedFace(this).GetUVSGlyph(unicode, variation_selector);
        if (id) {
            return id;
        }
        unicode = gfxFontUtils::GetUVSFallback(unicode, variation_selector);
        if (unicode) {
            return GetGlyph(unicode);
        }
        return 0;
    }

    return GetGlyph(unicode);
}

int32_t
gfxFT2FontBase::GetGlyphWidth(DrawTarget& aDrawTarget, uint16_t aGID)
{
    cairo_text_extents_t extents;
    GetGlyphExtents(aGID, &extents);
    // convert to 16.16 fixed point
    return NS_lround(0x10000 * extents.x_advance);
}

bool
gfxFT2FontBase::SetupCairoFont(DrawTarget* aDrawTarget)
{
    // The scaled font ctm is not relevant right here because
    // cairo_set_scaled_font does not record the scaled font itself, but
    // merely the font_face, font_matrix, font_options.  The scaled_font used
    // for the target can be different from the scaled_font passed to
    // cairo_set_scaled_font.  (Unfortunately we have measured only for an
    // identity ctm.)
    cairo_scaled_font_t *cairoFont = CairoScaledFont();

    if (cairo_scaled_font_status(cairoFont) != CAIRO_STATUS_SUCCESS) {
        // Don't cairo_set_scaled_font as that would propagate the error to
        // the cairo_t, precluding any further drawing.
        return false;
    }
    // Thoughts on which font_options to set on the context:
    //
    // cairoFont has been created for screen rendering.
    //
    // When the context is being used for screen rendering, we should set
    // font_options such that the same scaled_font gets used (when the ctm is
    // the same).  The use of explicit font_options recorded in
    // CreateScaledFont ensures that this will happen.
    //
    // XXXkt: For pdf and ps surfaces, I don't know whether it's better to
    // remove surface-specific options, or try to draw with the same
    // scaled_font that was used to measure.  As the same font_face is being
    // used, its font_options will often override some values anyway (unless
    // perhaps we remove those from the FcPattern at face creation).
    //
    // I can't see any significant difference in printing, irrespective of
    // what is set here.  It's too late to change things here as measuring has
    // already taken place.  We should really be measuring with a different
    // font for pdf and ps surfaces (bug 403513).
    cairo_set_scaled_font(gfxFont::RefCairo(aDrawTarget), cairoFont);
    return true;
}
