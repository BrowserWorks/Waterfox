/*
 * Copyright 2006 The Android Open Source Project
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "SkBlitRow.h"
#include "SkColorFilter.h"
#include "SkColorPriv.h"
#include "SkModeColorFilter.h"
#include "SkReadBuffer.h"
#include "SkWriteBuffer.h"
#include "SkUtils.h"
#include "SkString.h"
#include "SkValidationUtils.h"
#include "SkPM4f.h"

//////////////////////////////////////////////////////////////////////////////////////////////////

#ifndef SK_IGNORE_TO_STRING
void SkModeColorFilter::toString(SkString* str) const {
    str->append("SkModeColorFilter: color: 0x");
    str->appendHex(fColor);
    str->append(" mode: ");
    str->append(SkXfermode::ModeName(fMode));
}
#endif

bool SkModeColorFilter::asColorMode(SkColor* color, SkXfermode::Mode* mode) const {
    if (color) {
        *color = fColor;
    }
    if (mode) {
        *mode = fMode;
    }
    return true;
}

uint32_t SkModeColorFilter::getFlags() const {
    uint32_t flags = 0;
    switch (fMode) {
        case SkXfermode::kDst_Mode:      //!< [Da, Dc]
        case SkXfermode::kSrcATop_Mode:  //!< [Da, Sc * Da + (1 - Sa) * Dc]
            flags |= kAlphaUnchanged_Flag;
        default:
            break;
    }
    return flags;
}

void SkModeColorFilter::filterSpan(const SkPMColor shader[], int count, SkPMColor result[]) const {
    SkPMColor       color = fPMColor;
    SkXfermodeProc  proc = fProc;

    for (int i = 0; i < count; i++) {
        result[i] = proc(color, shader[i]);
    }
}

void SkModeColorFilter::filterSpan4f(const SkPM4f shader[], int count, SkPM4f result[]) const {
    SkPM4f            color = SkPM4f::FromPMColor(fPMColor);
    SkXfermodeProc4f  proc = SkXfermode::GetProc4f(fMode);

    for (int i = 0; i < count; i++) {
        result[i] = proc(color, shader[i]);
    }
}

void SkModeColorFilter::flatten(SkWriteBuffer& buffer) const {
    buffer.writeColor(fColor);
    buffer.writeUInt(fMode);
}

void SkModeColorFilter::updateCache() {
    fPMColor = SkPreMultiplyColor(fColor);
    fProc = SkXfermode::GetProc(fMode);
}

sk_sp<SkFlattenable> SkModeColorFilter::CreateProc(SkReadBuffer& buffer) {
    SkColor color = buffer.readColor();
    SkXfermode::Mode mode = (SkXfermode::Mode)buffer.readUInt();
    return SkColorFilter::MakeModeFilter(color, mode);
}

///////////////////////////////////////////////////////////////////////////////
#if SK_SUPPORT_GPU
#include "GrBlend.h"
#include "GrInvariantOutput.h"
#include "effects/GrXfermodeFragmentProcessor.h"
#include "effects/GrConstColorProcessor.h"
#include "SkGr.h"

sk_sp<GrFragmentProcessor> SkModeColorFilter::asFragmentProcessor(GrContext*) const {
    if (SkXfermode::kDst_Mode == fMode) {
        return nullptr;
    }

    sk_sp<GrFragmentProcessor> constFP(
        GrConstColorProcessor::Make(SkColorToPremulGrColor(fColor),
                                    GrConstColorProcessor::kIgnore_InputMode));
    sk_sp<GrFragmentProcessor> fp(
        GrXfermodeFragmentProcessor::MakeFromSrcProcessor(std::move(constFP), fMode));
    if (!fp) {
        return nullptr;
    }
#ifdef SK_DEBUG
    // With a solid color input this should always be able to compute the blended color
    // (at least for coeff modes)
    if (fMode <= SkXfermode::kLastCoeffMode) {
        static SkRandom gRand;
        GrInvariantOutput io(GrPremulColor(gRand.nextU()), kRGBA_GrColorComponentFlags,
                                false);
        fp->computeInvariantOutput(&io);
        SkASSERT(io.validFlags() == kRGBA_GrColorComponentFlags);
    }
#endif
    return fp;
}

#endif

///////////////////////////////////////////////////////////////////////////////

class Src_SkModeColorFilter final : public SkModeColorFilter {
public:
    Src_SkModeColorFilter(SkColor color) : INHERITED(color, SkXfermode::kSrc_Mode) {}

    void filterSpan(const SkPMColor shader[], int count, SkPMColor result[]) const override {
        sk_memset32(result, this->getPMColor(), count);
    }

private:
    typedef SkModeColorFilter INHERITED;
};

class SrcOver_SkModeColorFilter final : public SkModeColorFilter {
public:
    SrcOver_SkModeColorFilter(SkColor color) : INHERITED(color, SkXfermode::kSrcOver_Mode) { }

    void filterSpan(const SkPMColor shader[], int count, SkPMColor result[]) const override {
        SkBlitRow::Color32(result, shader, count, this->getPMColor());
    }

private:
    typedef SkModeColorFilter INHERITED;
};

///////////////////////////////////////////////////////////////////////////////

sk_sp<SkColorFilter> SkColorFilter::MakeModeFilter(SkColor color, SkXfermode::Mode mode) {
    if (!SkIsValidMode(mode)) {
        return nullptr;
    }

    unsigned alpha = SkColorGetA(color);

    // first collaps some modes if possible

    if (SkXfermode::kClear_Mode == mode) {
        color = 0;
        mode = SkXfermode::kSrc_Mode;
    } else if (SkXfermode::kSrcOver_Mode == mode) {
        if (0 == alpha) {
            mode = SkXfermode::kDst_Mode;
        } else if (255 == alpha) {
            mode = SkXfermode::kSrc_Mode;
        }
        // else just stay srcover
    }

    // weed out combinations that are noops, and just return null
    if (SkXfermode::kDst_Mode == mode ||
        (0 == alpha && (SkXfermode::kSrcOver_Mode == mode ||
                        SkXfermode::kDstOver_Mode == mode ||
                        SkXfermode::kDstOut_Mode == mode ||
                        SkXfermode::kSrcATop_Mode == mode ||
                        SkXfermode::kXor_Mode == mode ||
                        SkXfermode::kDarken_Mode == mode)) ||
            (0xFF == alpha && SkXfermode::kDstIn_Mode == mode)) {
        return nullptr;
    }

    switch (mode) {
        case SkXfermode::kSrc_Mode:
            return sk_make_sp<Src_SkModeColorFilter>(color);
        case SkXfermode::kSrcOver_Mode:
            return sk_make_sp<SrcOver_SkModeColorFilter>(color);
        default:
            return SkModeColorFilter::Make(color, mode);
    }
}
