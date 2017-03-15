/*
 * Copyright 2016 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#ifndef GrAnalyticRectBatch_DEFINED
#define GrAnalyticRectBatch_DEFINED

#include "GrColor.h"

class GrDrawBatch;
class SkMatrix;
struct SkRect;

/*
 * This class wraps helper functions that draw rects analytically. Used when a shader requires a
 * distance vector.
 *
 * @param color        the shape's color
 * @param viewMatrix   the shape's local matrix
 * @param rect         the shape in source space
 * @param croppedRect  the shape in device space, clipped to the device's bounds
 * @param bounds       the axis aligned bounds of the shape in device space
 */
class GrAnalyticRectBatch {
public:
    static GrDrawBatch* CreateAnalyticRectBatch(GrColor color,
                                                const SkMatrix& viewMatrix,
                                                const SkRect& rect,
                                                const SkRect& croppedRect,
                                                const SkRect& bounds);
};

#endif // GrAnalyticRectBatch_DEFINED
