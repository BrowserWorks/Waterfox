/*
 * Copyright 2010 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "GrFixedClip.h"

#include "GrAppliedClip.h"
#include "GrDrawContext.h"

bool GrFixedClip::quickContains(const SkRect& rect) const {
    if (fWindowRectsState.enabled()) {
        return false;
    }
    return !fScissorState.enabled() || GrClip::IsInsideClip(fScissorState.rect(), rect);
}

void GrFixedClip::getConservativeBounds(int w, int h, SkIRect* devResult, bool* iior) const {
    devResult->setXYWH(0, 0, w, h);
    if (fScissorState.enabled()) {
        if (!devResult->intersect(fScissorState.rect())) {
            devResult->setEmpty();
        }
    }
    if (iior) {
        *iior = true;
    }
}

bool GrFixedClip::isRRect(const SkRect& rtBounds, SkRRect* rr, bool* aa) const {
    if (fWindowRectsState.enabled()) {
        return false;
    }
    if (fScissorState.enabled()) {
        SkRect rect = SkRect::Make(fScissorState.rect());
        if (!rect.intersects(rtBounds)) {
            return false;
        }
        rr->setRect(rect);
        *aa = false;
        return true;
    }
    return false;
};

bool GrFixedClip::apply(GrContext*, GrDrawContext* dc, bool, bool, GrAppliedClip* out) const {
    if (fScissorState.enabled()) {
        SkIRect tightScissor = SkIRect::MakeWH(dc->width(), dc->height());
        if (!tightScissor.intersect(fScissorState.rect())) {
            return false;
        }
        if (IsOutsideClip(tightScissor, out->clippedDrawBounds())) {
            return false;
        }
        if (!IsInsideClip(fScissorState.rect(), out->clippedDrawBounds())) {
            out->addScissor(tightScissor);
        }
    }

    if (fWindowRectsState.enabled()) {
        out->addWindowRectangles(fWindowRectsState);
    }

    return true;
}

const GrFixedClip& GrFixedClip::Disabled() {
    static const GrFixedClip disabled = GrFixedClip();
    return disabled;
}
