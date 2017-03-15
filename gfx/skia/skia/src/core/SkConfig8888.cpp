/*
 * Copyright 2014 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "SkBitmap.h"
#include "SkCanvas.h"
#include "SkConfig8888.h"
#include "SkColorPriv.h"
#include "SkDither.h"
#include "SkMathPriv.h"
#include "SkUnPreMultiply.h"

enum AlphaVerb {
    kNothing_AlphaVerb,
    kPremul_AlphaVerb,
    kUnpremul_AlphaVerb,
};

template <bool doSwapRB, AlphaVerb doAlpha> uint32_t convert32(uint32_t c) {
    if (doSwapRB) {
        c = SkSwizzle_RB(c);
    }

    // Lucky for us, in both RGBA and BGRA, the alpha component is always in the same place, so
    // we can perform premul or unpremul the same way without knowing the swizzles for RGB.
    switch (doAlpha) {
        case kNothing_AlphaVerb:
            // no change
            break;
        case kPremul_AlphaVerb:
            c = SkPreMultiplyARGB(SkGetPackedA32(c), SkGetPackedR32(c),
                                  SkGetPackedG32(c), SkGetPackedB32(c));
            break;
        case kUnpremul_AlphaVerb:
            c = SkUnPreMultiply::UnPreMultiplyPreservingByteOrder(c);
            break;
    }
    return c;
}

template <bool doSwapRB, AlphaVerb doAlpha>
void convert32_row(uint32_t* dst, const uint32_t* src, int count) {
    // This has to be correct if src == dst (but not partial overlap)
    for (int i = 0; i < count; ++i) {
        dst[i] = convert32<doSwapRB, doAlpha>(src[i]);
    }
}

static bool is_32bit_colortype(SkColorType ct) {
    return kRGBA_8888_SkColorType == ct || kBGRA_8888_SkColorType == ct;
}

static AlphaVerb compute_AlphaVerb(SkAlphaType src, SkAlphaType dst) {
    SkASSERT(kUnknown_SkAlphaType != src);
    SkASSERT(kUnknown_SkAlphaType != dst);

    if (kOpaque_SkAlphaType == src || kOpaque_SkAlphaType == dst || src == dst) {
        return kNothing_AlphaVerb;
    }
    if (kPremul_SkAlphaType == dst) {
        SkASSERT(kUnpremul_SkAlphaType == src);
        return kPremul_AlphaVerb;
    } else {
        SkASSERT(kPremul_SkAlphaType == src);
        SkASSERT(kUnpremul_SkAlphaType == dst);
        return kUnpremul_AlphaVerb;
    }
}

static void memcpy32_row(uint32_t* dst, const uint32_t* src, int count) {
    memcpy(dst, src, count * 4);
}

bool SkSrcPixelInfo::convertPixelsTo(SkDstPixelInfo* dst, int width, int height) const {
    if (width <= 0 || height <= 0) {
        return false;
    }

    if (!is_32bit_colortype(fColorType) || !is_32bit_colortype(dst->fColorType)) {
        return false;
    }

    void (*proc)(uint32_t* dst, const uint32_t* src, int count);
    AlphaVerb doAlpha = compute_AlphaVerb(fAlphaType, dst->fAlphaType);
    bool doSwapRB = fColorType != dst->fColorType;

    switch (doAlpha) {
        case kNothing_AlphaVerb:
            if (doSwapRB) {
                proc = convert32_row<true, kNothing_AlphaVerb>;
            } else {
                if (fPixels == dst->fPixels) {
                    return true;
                }
                proc = memcpy32_row;
            }
            break;
        case kPremul_AlphaVerb:
            if (doSwapRB) {
                proc = convert32_row<true, kPremul_AlphaVerb>;
            } else {
                proc = convert32_row<false, kPremul_AlphaVerb>;
            }
            break;
        case kUnpremul_AlphaVerb:
            if (doSwapRB) {
                proc = convert32_row<true, kUnpremul_AlphaVerb>;
            } else {
                proc = convert32_row<false, kUnpremul_AlphaVerb>;
            }
            break;
    }

    uint32_t* dstP = static_cast<uint32_t*>(dst->fPixels);
    const uint32_t* srcP = static_cast<const uint32_t*>(fPixels);
    size_t srcInc = fRowBytes >> 2;
    size_t dstInc = dst->fRowBytes >> 2;
    for (int y = 0; y < height; ++y) {
        proc(dstP, srcP, width);
        dstP += dstInc;
        srcP += srcInc;
    }
    return true;
}

static void copy_g8_to_32(void* dst, size_t dstRB, const void* src, size_t srcRB, int w, int h) {
    uint32_t* dst32 = (uint32_t*)dst;
    const uint8_t* src8 = (const uint8_t*)src;

    for (int y = 0; y < h; ++y) {
        for (int x = 0; x < w; ++x) {
            dst32[x] = SkPackARGB32(0xFF, src8[x], src8[x], src8[x]);
        }
        dst32 = (uint32_t*)((char*)dst32 + dstRB);
        src8 += srcRB;
    }
}

static void copy_32_to_g8(void* dst, size_t dstRB, const void* src, size_t srcRB,
                          const SkImageInfo& srcInfo) {
    uint8_t* dst8 = (uint8_t*)dst;
    const uint32_t* src32 = (const uint32_t*)src;

    const int w = srcInfo.width();
    const int h = srcInfo.height();
    const bool isBGRA = (kBGRA_8888_SkColorType == srcInfo.colorType());

    for (int y = 0; y < h; ++y) {
        if (isBGRA) {
            // BGRA
            for (int x = 0; x < w; ++x) {
                uint32_t s = src32[x];
                dst8[x] = SkComputeLuminance((s >> 16) & 0xFF, (s >> 8) & 0xFF, s & 0xFF);
            }
        } else {
            // RGBA
            for (int x = 0; x < w; ++x) {
                uint32_t s = src32[x];
                dst8[x] = SkComputeLuminance(s & 0xFF, (s >> 8) & 0xFF, (s >> 16) & 0xFF);
            }
        }
        src32 = (const uint32_t*)((const char*)src32 + srcRB);
        dst8 += dstRB;
    }
}

static bool extract_alpha(void* dst, size_t dstRB, const void* src, size_t srcRB,
                          const SkImageInfo& srcInfo, SkColorTable* ctable) {
    uint8_t* SK_RESTRICT dst8 = (uint8_t*)dst;

    const int w = srcInfo.width();
    const int h = srcInfo.height();
    if (srcInfo.isOpaque()) {
        // src is opaque, so just fill alpha with 0xFF
        for (int y = 0; y < h; ++y) {
           memset(dst8, 0xFF, w);
           dst8 += dstRB;
        }
        return true;
    }
    switch (srcInfo.colorType()) {
        case kN32_SkColorType: {
            const SkPMColor* SK_RESTRICT src32 = (const SkPMColor*)src;
            for (int y = 0; y < h; ++y) {
                for (int x = 0; x < w; ++x) {
                    dst8[x] = SkGetPackedA32(src32[x]);
                }
                dst8 += dstRB;
                src32 = (const SkPMColor*)((const char*)src32 + srcRB);
            }
            break;
        }
        case kARGB_4444_SkColorType: {
            const SkPMColor16* SK_RESTRICT src16 = (const SkPMColor16*)src;
            for (int y = 0; y < h; ++y) {
                for (int x = 0; x < w; ++x) {
                    dst8[x] = SkPacked4444ToA32(src16[x]);
                }
                dst8 += dstRB;
                src16 = (const SkPMColor16*)((const char*)src16 + srcRB);
            }
            break;
        }
        case kIndex_8_SkColorType: {
            if (nullptr == ctable) {
                return false;
            }
            const SkPMColor* SK_RESTRICT table = ctable->readColors();
            const uint8_t* SK_RESTRICT src8 = (const uint8_t*)src;
            for (int y = 0; y < h; ++y) {
                for (int x = 0; x < w; ++x) {
                    dst8[x] = SkGetPackedA32(table[src8[x]]);
                }
                dst8 += dstRB;
                src8 += srcRB;
            }
            break;
        }
        default:
            return false;
    }
    return true;
}

bool SkPixelInfo::CopyPixels(const SkImageInfo& dstInfo, void* dstPixels, size_t dstRB,
                             const SkImageInfo& srcInfo, const void* srcPixels, size_t srcRB,
                             SkColorTable* ctable) {
    if (srcInfo.dimensions() != dstInfo.dimensions()) {
        return false;
    }

    const int width = srcInfo.width();
    const int height = srcInfo.height();

    // Do the easiest one first : both configs are equal
    if ((srcInfo == dstInfo) && !ctable) {
        size_t bytes = width * srcInfo.bytesPerPixel();
        for (int y = 0; y < height; ++y) {
            memcpy(dstPixels, srcPixels, bytes);
            srcPixels = (const char*)srcPixels + srcRB;
            dstPixels = (char*)dstPixels + dstRB;
        }
        return true;
    }

    // Handle fancy alpha swizzling if both are ARGB32
    if (4 == srcInfo.bytesPerPixel() && 4 == dstInfo.bytesPerPixel()) {
        SkDstPixelInfo dstPI;
        dstPI.fColorType = dstInfo.colorType();
        dstPI.fAlphaType = dstInfo.alphaType();
        dstPI.fPixels = dstPixels;
        dstPI.fRowBytes = dstRB;

        SkSrcPixelInfo srcPI;
        srcPI.fColorType = srcInfo.colorType();
        srcPI.fAlphaType = srcInfo.alphaType();
        srcPI.fPixels = srcPixels;
        srcPI.fRowBytes = srcRB;

        return srcPI.convertPixelsTo(&dstPI, width, height);
    }

    // If they agree on colorType and the alphaTypes are compatible, then we just memcpy.
    // Note: we've already taken care of 32bit colortypes above.
    if (srcInfo.colorType() == dstInfo.colorType()) {
        switch (srcInfo.colorType()) {
            case kRGB_565_SkColorType:
            case kAlpha_8_SkColorType:
            case kGray_8_SkColorType:
                break;
            case kIndex_8_SkColorType:
            case kARGB_4444_SkColorType:
            case kRGBA_F16_SkColorType:
                if (srcInfo.alphaType() != dstInfo.alphaType()) {
                    return false;
                }
                break;
            default:
                return false;
        }
        SkRectMemcpy(dstPixels, dstRB, srcPixels, srcRB, width * srcInfo.bytesPerPixel(), height);
        return true;
    }

    /*
     *  Begin section where we try to change colorTypes along the way. Not all combinations
     *  are supported.
     */

    if (kGray_8_SkColorType == srcInfo.colorType() && 4 == dstInfo.bytesPerPixel()) {
        copy_g8_to_32(dstPixels, dstRB, srcPixels, srcRB, width, height);
        return true;
    }
    if (kGray_8_SkColorType == dstInfo.colorType() && 4 == srcInfo.bytesPerPixel()) {
        copy_32_to_g8(dstPixels, dstRB, srcPixels, srcRB, srcInfo);
        return true;
    }

    if (kAlpha_8_SkColorType == dstInfo.colorType() &&
        extract_alpha(dstPixels, dstRB, srcPixels, srcRB, srcInfo, ctable)) {
        return true;
    }

    // Can no longer draw directly into 4444, but we can manually whack it for a few combinations
    if (kARGB_4444_SkColorType == dstInfo.colorType() &&
        (kN32_SkColorType == srcInfo.colorType() || kIndex_8_SkColorType == srcInfo.colorType())) {
        if (srcInfo.alphaType() == kUnpremul_SkAlphaType) {
            // Our method for converting to 4444 assumes premultiplied.
            return false;
        }

        const SkPMColor* table = nullptr;
        if (kIndex_8_SkColorType == srcInfo.colorType()) {
            if (nullptr == ctable) {
                return false;
            }
            table = ctable->readColors();
        }

        for (int y = 0; y < height; ++y) {
            DITHER_4444_SCAN(y);
            SkPMColor16* SK_RESTRICT dstRow = (SkPMColor16*)dstPixels;
            if (table) {
                const uint8_t* SK_RESTRICT srcRow = (const uint8_t*)srcPixels;
                for (int x = 0; x < width; ++x) {
                    dstRow[x] = SkDitherARGB32To4444(table[srcRow[x]], DITHER_VALUE(x));
                }
            } else {
                const SkPMColor* SK_RESTRICT srcRow = (const SkPMColor*)srcPixels;
                for (int x = 0; x < width; ++x) {
                    dstRow[x] = SkDitherARGB32To4444(srcRow[x], DITHER_VALUE(x));
                }
            }
            dstPixels = (char*)dstPixels + dstRB;
            srcPixels = (const char*)srcPixels + srcRB;
        }
        return true;
    }

    if (dstInfo.alphaType() == kUnpremul_SkAlphaType) {
        // We do not support drawing to unpremultiplied bitmaps.
        return false;
    }

    // Final fall-back, draw with a canvas
    //
    // Always clear the dest in case one of the blitters accesses it
    // TODO: switch the allocation of tmpDst to call sk_calloc_throw
    {
        SkBitmap bm;
        if (!bm.installPixels(srcInfo, const_cast<void*>(srcPixels), srcRB, ctable, nullptr, nullptr)) {
            return false;
        }
        SkAutoTUnref<SkCanvas> canvas(SkCanvas::NewRasterDirect(dstInfo, dstPixels, dstRB));
        if (nullptr == canvas.get()) {
            return false;
        }

        SkPaint  paint;
        paint.setDither(true);

        canvas->clear(0);
        canvas->drawBitmap(bm, 0, 0, &paint);
        return true;
    }
}
