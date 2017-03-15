/*
 * Copyright 2015 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#ifndef SkXfermode_proccoeff_DEFINED
#define SkXfermode_proccoeff_DEFINED

#include "SkXfermode.h"
#include "SkReadBuffer.h"
#include "SkWriteBuffer.h"

struct ProcCoeff {
    SkXfermodeProc      fProc;
    SkXfermodeProc4f    fProc4f;
    SkXfermode::Coeff   fSC;
    SkXfermode::Coeff   fDC;
};

#define CANNOT_USE_COEFF    SkXfermode::Coeff(-1)

class SK_API SkProcCoeffXfermode : public SkXfermode {
public:
    SkProcCoeffXfermode(const ProcCoeff& rec, Mode mode) {
        fMode = mode;
        fProc = rec.fProc;
        // these may be valid, or may be CANNOT_USE_COEFF
        fSrcCoeff = rec.fSC;
        fDstCoeff = rec.fDC;
    }

    void xfer32(SkPMColor dst[], const SkPMColor src[], int count,
                const SkAlpha aa[]) const override;
    void xfer16(uint16_t dst[], const SkPMColor src[], int count,
                const SkAlpha aa[]) const override;
    void xferA8(SkAlpha dst[], const SkPMColor src[], int count,
                const SkAlpha aa[]) const override;

    bool asMode(Mode* mode) const override;

    bool supportsCoverageAsAlpha() const override;

    bool isOpaque(SkXfermode::SrcColorOpacity opacityType) const override;

#if SK_SUPPORT_GPU
    sk_sp<GrFragmentProcessor> makeFragmentProcessorForImageFilter(
                                                        sk_sp<GrFragmentProcessor>) const override;
    sk_sp<GrXPFactory> asXPFactory() const override;
#endif

    SK_TO_STRING_OVERRIDE()
    SK_DECLARE_PUBLIC_FLATTENABLE_DESERIALIZATION_PROCS(SkProcCoeffXfermode)

    bool onAppendStages(SkRasterPipeline*) const override;

protected:
    void flatten(SkWriteBuffer& buffer) const override;

    Mode getMode() const { return fMode; }

    SkXfermodeProc getProc() const { return fProc; }

private:
    SkXfermodeProc  fProc;
    Mode            fMode;
    Coeff           fSrcCoeff, fDstCoeff;

    friend class SkXfermode;

    typedef SkXfermode INHERITED;
};

#endif // #ifndef SkXfermode_proccoeff_DEFINED
