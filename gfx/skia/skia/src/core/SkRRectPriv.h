/*
 * Copyright 2018 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#ifndef SkRRectPriv_DEFINED
#define SkRRectPriv_DEFINED

#include "SkRRect.h"

class SkRRectPriv {
public:
    static bool IsCircle(const SkRRect& rr) {
        return rr.isOval() && SkScalarNearlyEqual(rr.fRadii[0].fX, rr.fRadii[0].fY);
    }

    static SkVector GetSimpleRadii(const SkRRect& rr) {
        SkASSERT(!rr.isComplex());
        return rr.fRadii[0];
    }

    static bool IsSimpleCircular(const SkRRect& rr) {
        return rr.isSimple() && SkScalarNearlyEqual(rr.fRadii[0].fX, rr.fRadii[0].fY);
    }

    static bool EqualRadii(const SkRRect& rr) {
        return rr.isRect() || SkRRectPriv::IsCircle(rr)  || SkRRectPriv::IsSimpleCircular(rr);
    }

    static bool AllCornersCircular(const SkRRect& rr, SkScalar tolerance = SK_ScalarNearlyZero);
};

#endif

