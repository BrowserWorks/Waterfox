/*
 * Copyright 2017 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#ifndef GrColorSpaceInfo_DEFINED
#define GrColorSpaceInfo_DEFINED

#include "GrColorSpaceXform.h"
#include "GrTypes.h"
#include "SkColorSpace.h"
#include "SkRefCnt.h"

/** Describes the color space properties of a surface context. */
class GrColorSpaceInfo {
public:
    GrColorSpaceInfo(sk_sp<SkColorSpace>, GrPixelConfig);

    bool isGammaCorrect() const { return static_cast<bool>(fColorSpace); }

    SkColorSpace* colorSpace() const { return fColorSpace.get(); }
    sk_sp<SkColorSpace> refColorSpace() const { return fColorSpace; }

    GrColorSpaceXform* colorSpaceXformFromSRGB() const;
    sk_sp<GrColorSpaceXform> refColorSpaceXformFromSRGB() const {
        return sk_ref_sp(this->colorSpaceXformFromSRGB());
    }

    // TODO: Remove or replace with SkColorType
    GrPixelConfig config() const { return fConfig; }

private:
    sk_sp<SkColorSpace> fColorSpace;
    mutable sk_sp<GrColorSpaceXform> fColorXformFromSRGB;
    GrPixelConfig fConfig;
    mutable bool fInitializedColorSpaceXformFromSRGB;
};

#endif
