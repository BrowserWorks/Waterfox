/*
 * Copyright 2013 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#ifndef SkGpuBlurUtils_DEFINED
#define SkGpuBlurUtils_DEFINED

#if SK_SUPPORT_GPU
#include "GrDrawContext.h"

class GrContext;
class GrTexture;

struct SkRect;

namespace SkGpuBlurUtils {
  /**
    * Applies a 2D Gaussian blur to a given texture. The blurred result is returned
    * as a drawContext in case the caller wishes to future draw into the result.
    * Note: one of sigmaX and sigmaY should be non-zero!
    * @param context         The GPU context
    * @param srcTexture      The source texture to be blurred.
    * @param colorSpace      Color space of the source (used for the drawContext result, too).
    * @param dstBounds       The destination bounds, relative to the source texture.
    * @param srcBounds       The source bounds, relative to the source texture. If non-null,
    *                        no pixels will be sampled outside of this rectangle.
    * @param sigmaX          The blur's standard deviation in X.
    * @param sigmaY          The blur's standard deviation in Y.
    * @param fit             backing fit for the returned draw context
    * @return                The drawContext containing the blurred result.
    */
    sk_sp<GrDrawContext> GaussianBlur(GrContext* context,
                                      GrTexture* srcTexture,
                                      sk_sp<SkColorSpace> colorSpace,
                                      const SkIRect& dstBounds,
                                      const SkIRect* srcBounds,
                                      float sigmaX,
                                      float sigmaY,
                                      SkBackingFit fit = SkBackingFit::kApprox);
};

#endif
#endif
