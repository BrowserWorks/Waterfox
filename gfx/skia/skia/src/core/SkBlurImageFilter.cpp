/*
 * Copyright 2011 The Android Open Source Project
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "SkAutoPixmapStorage.h"
#include "SkColorPriv.h"
#include "SkGpuBlurUtils.h"
#include "SkOpts.h"
#include "SkReadBuffer.h"
#include "SkSpecialImage.h"
#include "SkWriteBuffer.h"

#if SK_SUPPORT_GPU
#include "GrContext.h"
#include "SkGr.h"
#endif

class SkBlurImageFilterImpl : public SkImageFilter {
public:
    SkBlurImageFilterImpl(SkScalar sigmaX,
                      SkScalar sigmaY,
                      sk_sp<SkImageFilter> input,
                      const CropRect* cropRect);

    SkRect computeFastBounds(const SkRect&) const override;

    SK_TO_STRING_OVERRIDE()
    SK_DECLARE_PUBLIC_FLATTENABLE_DESERIALIZATION_PROCS(SkBlurImageFilterImpl)

#ifdef SK_SUPPORT_LEGACY_IMAGEFILTER_PTR
    static SkImageFilter* Create(SkScalar sigmaX, SkScalar sigmaY, SkImageFilter* input = nullptr,
                                 const CropRect* cropRect = nullptr) {
        return SkImageFilter::MakeBlur(sigmaX, sigmaY, sk_ref_sp<SkImageFilter>(input),
                                     cropRect).release();
    }
#endif

protected:
    void flatten(SkWriteBuffer&) const override;
    sk_sp<SkSpecialImage> onFilterImage(SkSpecialImage* source, const Context&,
                                        SkIPoint* offset) const override;
    SkIRect onFilterNodeBounds(const SkIRect& src, const SkMatrix&, MapDirection) const override;

private:
    SkSize   fSigma;
    typedef SkImageFilter INHERITED;

    friend class SkImageFilter;
};

SK_DEFINE_FLATTENABLE_REGISTRAR_GROUP_START(SkImageFilter)
    SK_DEFINE_FLATTENABLE_REGISTRAR_ENTRY(SkBlurImageFilterImpl)
SK_DEFINE_FLATTENABLE_REGISTRAR_GROUP_END

///////////////////////////////////////////////////////////////////////////////

sk_sp<SkImageFilter> SkImageFilter::MakeBlur(SkScalar sigmaX, SkScalar sigmaY,
                                             sk_sp<SkImageFilter> input,
                                             const CropRect* cropRect) {
    if (0 == sigmaX && 0 == sigmaY && !cropRect) {
        return input;
    }
    return sk_sp<SkImageFilter>(new SkBlurImageFilterImpl(sigmaX, sigmaY, input, cropRect));
}

// This rather arbitrary-looking value results in a maximum box blur kernel size
// of 1000 pixels on the raster path, which matches the WebKit and Firefox
// implementations. Since the GPU path does not compute a box blur, putting
// the limit on sigma ensures consistent behaviour between the GPU and
// raster paths.
#define MAX_SIGMA SkIntToScalar(532)

static SkVector map_sigma(const SkSize& localSigma, const SkMatrix& ctm) {
    SkVector sigma = SkVector::Make(localSigma.width(), localSigma.height());
    ctm.mapVectors(&sigma, 1);
    sigma.fX = SkMinScalar(SkScalarAbs(sigma.fX), MAX_SIGMA);
    sigma.fY = SkMinScalar(SkScalarAbs(sigma.fY), MAX_SIGMA);
    return sigma;
}

SkBlurImageFilterImpl::SkBlurImageFilterImpl(SkScalar sigmaX,
                                     SkScalar sigmaY,
                                     sk_sp<SkImageFilter> input,
                                     const CropRect* cropRect)
    : INHERITED(&input, 1, cropRect)
    , fSigma(SkSize::Make(sigmaX, sigmaY)) {
}

sk_sp<SkFlattenable> SkBlurImageFilterImpl::CreateProc(SkReadBuffer& buffer) {
    SK_IMAGEFILTER_UNFLATTEN_COMMON(common, 1);
    SkScalar sigmaX = buffer.readScalar();
    SkScalar sigmaY = buffer.readScalar();
    return SkImageFilter::MakeBlur(sigmaX, sigmaY, common.getInput(0), &common.cropRect());
}

void SkBlurImageFilterImpl::flatten(SkWriteBuffer& buffer) const {
    this->INHERITED::flatten(buffer);
    buffer.writeScalar(fSigma.fWidth);
    buffer.writeScalar(fSigma.fHeight);
}

static void get_box3_params(SkScalar s, int *kernelSize, int* kernelSize3, int *lowOffset,
                            int *highOffset) {
    float pi = SkScalarToFloat(SK_ScalarPI);
    int d = static_cast<int>(floorf(SkScalarToFloat(s) * 3.0f * sqrtf(2.0f * pi) / 4.0f + 0.5f));
    *kernelSize = d;
    if (d % 2 == 1) {
        *lowOffset = *highOffset = (d - 1) / 2;
        *kernelSize3 = d;
    } else {
        *highOffset = d / 2;
        *lowOffset = *highOffset - 1;
        *kernelSize3 = d + 1;
    }
}

sk_sp<SkSpecialImage> SkBlurImageFilterImpl::onFilterImage(SkSpecialImage* source,
                                                       const Context& ctx,
                                                       SkIPoint* offset) const {
    SkIPoint inputOffset = SkIPoint::Make(0, 0);

    sk_sp<SkSpecialImage> input(this->filterInput(0, source, ctx, &inputOffset));
    if (!input) {
        return nullptr;
    }

    SkIRect inputBounds = SkIRect::MakeXYWH(inputOffset.fX, inputOffset.fY,
                                            input->width(), input->height());

    SkIRect dstBounds;
    if (!this->applyCropRect(this->mapContext(ctx), inputBounds, &dstBounds)) {
        return nullptr;
    }
    if (!inputBounds.intersect(dstBounds)) {
        return nullptr;
    }

    const SkVector sigma = map_sigma(fSigma, ctx.ctm());

#if SK_SUPPORT_GPU
    if (source->isTextureBacked()) {
        GrContext* context = source->getContext();
        sk_sp<GrTexture> inputTexture(input->asTextureRef(context));
        SkASSERT(inputTexture);

        if (0 == sigma.x() && 0 == sigma.y()) {
            offset->fX = inputBounds.x();
            offset->fY = inputBounds.y();
            return input->makeSubset(inputBounds.makeOffset(-inputOffset.x(),
                                                            -inputOffset.y()));
        }

        offset->fX = dstBounds.fLeft;
        offset->fY = dstBounds.fTop;
        inputBounds.offset(-inputOffset);
        dstBounds.offset(-inputOffset);
        // We intentionally use the source's color space, not the destination's (from ctx). We
        // always blur in the source's config, so we need a compatible color space. We also want to
        // avoid doing gamut conversion on every fetch of the texture.
        sk_sp<GrDrawContext> drawContext(SkGpuBlurUtils::GaussianBlur(
                                                                context,
                                                                inputTexture.get(),
                                                                sk_ref_sp(source->getColorSpace()),
                                                                dstBounds,
                                                                &inputBounds,
                                                                sigma.x(),
                                                                sigma.y()));
        if (!drawContext) {
            return nullptr;
        }

        // TODO: Get the colorSpace from the drawContext (once it has one)
        return SkSpecialImage::MakeFromGpu(SkIRect::MakeWH(dstBounds.width(), dstBounds.height()),
                                           kNeedNewImageUniqueID_SpecialImage,
                                           drawContext->asTexture(),
                                           sk_ref_sp(input->getColorSpace()), &source->props());
    }
#endif

    int kernelSizeX, kernelSizeX3, lowOffsetX, highOffsetX;
    int kernelSizeY, kernelSizeY3, lowOffsetY, highOffsetY;
    get_box3_params(sigma.x(), &kernelSizeX, &kernelSizeX3, &lowOffsetX, &highOffsetX);
    get_box3_params(sigma.y(), &kernelSizeY, &kernelSizeY3, &lowOffsetY, &highOffsetY);

    if (kernelSizeX < 0 || kernelSizeY < 0) {
        return nullptr;
    }

    if (kernelSizeX == 0 && kernelSizeY == 0) {
        offset->fX = inputBounds.x();
        offset->fY = inputBounds.y();
        return input->makeSubset(inputBounds.makeOffset(-inputOffset.x(),
                                                        -inputOffset.y()));
    }

    SkBitmap inputBM;

    if (!input->getROPixels(&inputBM)) {
        return nullptr;
    }

    if (inputBM.colorType() != kN32_SkColorType) {
        return nullptr;
    }

    SkImageInfo info = SkImageInfo::Make(dstBounds.width(), dstBounds.height(),
                                         inputBM.colorType(), inputBM.alphaType());

    SkBitmap tmp, dst;
    if (!tmp.tryAllocPixels(info) || !dst.tryAllocPixels(info)) {
        return nullptr;
    }

    SkAutoLockPixels inputLock(inputBM), tmpLock(tmp), dstLock(dst);

    offset->fX = dstBounds.fLeft;
    offset->fY = dstBounds.fTop;
    SkPMColor* t = tmp.getAddr32(0, 0);
    SkPMColor* d = dst.getAddr32(0, 0);
    int w = dstBounds.width(), h = dstBounds.height();
    const SkPMColor* s = inputBM.getAddr32(inputBounds.x() - inputOffset.x(),
                                           inputBounds.y() - inputOffset.y());
    inputBounds.offset(-dstBounds.x(), -dstBounds.y());
    dstBounds.offset(-dstBounds.x(), -dstBounds.y());
    SkIRect inputBoundsT = SkIRect::MakeLTRB(inputBounds.top(), inputBounds.left(),
                                             inputBounds.bottom(), inputBounds.right());
    SkIRect dstBoundsT = SkIRect::MakeWH(dstBounds.height(), dstBounds.width());
    int sw = int(inputBM.rowBytes() >> 2);

    /**
     *
     * In order to make memory accesses cache-friendly, we reorder the passes to
     * use contiguous memory reads wherever possible.
     *
     * For example, the 6 passes of the X-and-Y blur case are rewritten as
     * follows. Instead of 3 passes in X and 3 passes in Y, we perform
     * 2 passes in X, 1 pass in X transposed to Y on write, 2 passes in X,
     * then 1 pass in X transposed to Y on write.
     *
     * +----+       +----+       +----+        +---+       +---+       +---+        +----+
     * + AB + ----> | AB | ----> | AB | -----> | A | ----> | A | ----> | A | -----> | AB |
     * +----+ blurX +----+ blurX +----+ blurXY | B | blurX | B | blurX | B | blurXY +----+
     *                                         +---+       +---+       +---+
     *
     * In this way, two of the y-blurs become x-blurs applied to transposed
     * images, and all memory reads are contiguous.
     */
    if (kernelSizeX > 0 && kernelSizeY > 0) {
        SkOpts::box_blur_xx(s, sw,  inputBounds,  t, kernelSizeX,  lowOffsetX,  highOffsetX, w, h);
        SkOpts::box_blur_xx(t,  w,  dstBounds,    d, kernelSizeX,  highOffsetX, lowOffsetX,  w, h);
        SkOpts::box_blur_xy(d,  w,  dstBounds,    t, kernelSizeX3, highOffsetX, highOffsetX, w, h);
        SkOpts::box_blur_xx(t,  h,  dstBoundsT,   d, kernelSizeY,  lowOffsetY,  highOffsetY, h, w);
        SkOpts::box_blur_xx(d,  h,  dstBoundsT,   t, kernelSizeY,  highOffsetY, lowOffsetY,  h, w);
        SkOpts::box_blur_xy(t,  h,  dstBoundsT,   d, kernelSizeY3, highOffsetY, highOffsetY, h, w);
    } else if (kernelSizeX > 0) {
        SkOpts::box_blur_xx(s, sw,  inputBounds,  d, kernelSizeX,  lowOffsetX,  highOffsetX, w, h);
        SkOpts::box_blur_xx(d,  w,  dstBounds,    t, kernelSizeX,  highOffsetX, lowOffsetX,  w, h);
        SkOpts::box_blur_xx(t,  w,  dstBounds,    d, kernelSizeX3, highOffsetX, highOffsetX, w, h);
    } else if (kernelSizeY > 0) {
        SkOpts::box_blur_yx(s, sw,  inputBoundsT, d, kernelSizeY,  lowOffsetY,  highOffsetY, h, w);
        SkOpts::box_blur_xx(d,  h,  dstBoundsT,   t, kernelSizeY,  highOffsetY, lowOffsetY,  h, w);
        SkOpts::box_blur_xy(t,  h,  dstBoundsT,   d, kernelSizeY3, highOffsetY, highOffsetY, h, w);
    }

    return SkSpecialImage::MakeFromRaster(SkIRect::MakeWH(dstBounds.width(),
                                                          dstBounds.height()),
                                          dst, &source->props());
}


SkRect SkBlurImageFilterImpl::computeFastBounds(const SkRect& src) const {
    SkRect bounds = this->getInput(0) ? this->getInput(0)->computeFastBounds(src) : src;
    bounds.outset(SkScalarMul(fSigma.width(), SkIntToScalar(3)),
                  SkScalarMul(fSigma.height(), SkIntToScalar(3)));
    return bounds;
}

SkIRect SkBlurImageFilterImpl::onFilterNodeBounds(const SkIRect& src, const SkMatrix& ctm,
                                              MapDirection) const {
    SkVector sigma = map_sigma(fSigma, ctm);
    return src.makeOutset(SkScalarCeilToInt(SkScalarMul(sigma.x(), SkIntToScalar(3))),
                          SkScalarCeilToInt(SkScalarMul(sigma.y(), SkIntToScalar(3))));
}

#ifndef SK_IGNORE_TO_STRING
void SkBlurImageFilterImpl::toString(SkString* str) const {
    str->appendf("SkBlurImageFilterImpl: (");
    str->appendf("sigma: (%f, %f) input (", fSigma.fWidth, fSigma.fHeight);

    if (this->getInput(0)) {
        this->getInput(0)->toString(str);
    }

    str->append("))");
}
#endif
