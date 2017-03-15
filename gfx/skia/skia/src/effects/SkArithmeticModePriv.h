/*
 * Copyright 2016 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#ifndef SkArithmeticModePriv_DEFINED
#define SkArithmeticModePriv_DEFINED

#include "SkArithmeticMode.h"

struct SkArithmeticParams {
    float fK[4];
    bool fEnforcePMColor;
};

#ifndef SK_SUPPORT_LEGACY_ARITHMETICMODE

class SK_API SkArithmeticMode {
public:
    /**
     *  result = clamp[k1 * src * dst + k2 * src + k3 * dst + k4]
     *
     *  k1=k2=k3=0, k4=1.0 results in returning opaque white
     *  k1=k3=k4=0, k2=1.0 results in returning the src
     *  k1=k2=k4=0, k3=1.0 results in returning the dst
     */
    static sk_sp<SkXfermode> Make(SkScalar k1, SkScalar k2, SkScalar k3, SkScalar k4,
                                  bool enforcePMColor = true);
#ifdef SK_SUPPORT_LEGACY_XFERMODE_PTR
    static SkXfermode* Create(SkScalar k1, SkScalar k2,
                              SkScalar k3, SkScalar k4,
                              bool enforcePMColor = true) {
        return Make(k1, k2, k3, k4, enforcePMColor).release();
    }
#endif

    SK_DECLARE_FLATTENABLE_REGISTRAR_GROUP();

private:
    SkArithmeticMode(); // can't be instantiated
};

#endif

#endif
