/*
 * Copyright 2015 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#ifndef GrAAStrokeRectBatch_DEFINED
#define GrAAStrokeRectBatch_DEFINED

#include "GrColor.h"

class GrBatch;
class GrDrawBatch;
class GrResourceProvider;
class SkMatrix;
struct SkRect;
class SkStrokeRec;

namespace GrAAStrokeRectBatch {

GrDrawBatch* CreateFillBetweenRects(GrColor color,
                                    const SkMatrix& viewMatrix,
                                    const SkRect& devOutside,
                                    const SkRect& devInside);

GrDrawBatch* Create(GrColor color,
                    const SkMatrix& viewMatrix,
                    const SkRect& rect,
                    const SkStrokeRec& stroke);

}

#endif
