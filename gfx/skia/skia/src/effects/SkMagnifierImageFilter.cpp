/*
 * Copyright 2012 The Android Open Source Project
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "SkMagnifierImageFilter.h"

#include "SkBitmap.h"
#include "SkColorPriv.h"
#include "SkReadBuffer.h"
#include "SkSpecialImage.h"
#include "SkWriteBuffer.h"
#include "SkValidationUtils.h"

////////////////////////////////////////////////////////////////////////////////
#if SK_SUPPORT_GPU
#include "GrContext.h"
#include "GrDrawContext.h"
#include "GrInvariantOutput.h"
#include "effects/GrSingleTextureEffect.h"
#include "glsl/GrGLSLFragmentProcessor.h"
#include "glsl/GrGLSLFragmentShaderBuilder.h"
#include "glsl/GrGLSLProgramDataManager.h"
#include "glsl/GrGLSLUniformHandler.h"

class GrMagnifierEffect : public GrSingleTextureEffect {

public:
    static sk_sp<GrFragmentProcessor> Make(GrTexture* texture,
                                           const SkRect& bounds,
                                           float xOffset,
                                           float yOffset,
                                           float xInvZoom,
                                           float yInvZoom,
                                           float xInvInset,
                                           float yInvInset) {
        return sk_sp<GrFragmentProcessor>(new GrMagnifierEffect(texture, bounds,
                                                                xOffset, yOffset,
                                                                xInvZoom, yInvZoom,
                                                                xInvInset, yInvInset));
    }

    ~GrMagnifierEffect() override {}

    const char* name() const override { return "Magnifier"; }

    const SkRect& bounds() const { return fBounds; }    // Bounds of source image.
    // Offset to apply to zoomed pixels, (srcRect position / texture size).
    float xOffset() const { return fXOffset; }
    float yOffset() const { return fYOffset; }

    // Scale to apply to zoomed pixels (srcRect size / bounds size).
    float xInvZoom() const { return fXInvZoom; }
    float yInvZoom() const { return fYInvZoom; }

    // 1/radius over which to transition from unzoomed to zoomed pixels (bounds size / inset).
    float xInvInset() const { return fXInvInset; }
    float yInvInset() const { return fYInvInset; }

private:
    GrMagnifierEffect(GrTexture* texture,
                      const SkRect& bounds,
                      float xOffset,
                      float yOffset,
                      float xInvZoom,
                      float yInvZoom,
                      float xInvInset,
                      float yInvInset)
        : INHERITED(texture, nullptr, GrCoordTransform::MakeDivByTextureWHMatrix(texture))
        , fBounds(bounds)
        , fXOffset(xOffset)
        , fYOffset(yOffset)
        , fXInvZoom(xInvZoom)
        , fYInvZoom(yInvZoom)
        , fXInvInset(xInvInset)
        , fYInvInset(yInvInset) {
        this->initClassID<GrMagnifierEffect>();
    }

    GrGLSLFragmentProcessor* onCreateGLSLInstance() const override;

    void onGetGLSLProcessorKey(const GrGLSLCaps&, GrProcessorKeyBuilder*) const override;

    bool onIsEqual(const GrFragmentProcessor&) const override;

    void onComputeInvariantOutput(GrInvariantOutput* inout) const override;

    GR_DECLARE_FRAGMENT_PROCESSOR_TEST;

    SkRect fBounds;
    float fXOffset;
    float fYOffset;
    float fXInvZoom;
    float fYInvZoom;
    float fXInvInset;
    float fYInvInset;

    typedef GrSingleTextureEffect INHERITED;
};

// For brevity
typedef GrGLSLProgramDataManager::UniformHandle UniformHandle;

class GrGLMagnifierEffect : public GrGLSLFragmentProcessor {
public:
    void emitCode(EmitArgs&) override;

protected:
    void onSetData(const GrGLSLProgramDataManager&, const GrProcessor&) override;

private:
    UniformHandle       fOffsetVar;
    UniformHandle       fInvZoomVar;
    UniformHandle       fInvInsetVar;
    UniformHandle       fBoundsVar;

    typedef GrGLSLFragmentProcessor INHERITED;
};

void GrGLMagnifierEffect::emitCode(EmitArgs& args) {
    GrGLSLUniformHandler* uniformHandler = args.fUniformHandler;
    fOffsetVar = uniformHandler->addUniform(kFragment_GrShaderFlag,
                                            kVec2f_GrSLType, kDefault_GrSLPrecision,
                                            "Offset");
    fInvZoomVar = uniformHandler->addUniform(kFragment_GrShaderFlag,
                                             kVec2f_GrSLType, kDefault_GrSLPrecision,
                                             "InvZoom");
    fInvInsetVar = uniformHandler->addUniform(kFragment_GrShaderFlag,
                                              kVec2f_GrSLType, kDefault_GrSLPrecision,
                                              "InvInset");
    fBoundsVar = uniformHandler->addUniform(kFragment_GrShaderFlag,
                                            kVec4f_GrSLType, kDefault_GrSLPrecision,
                                            "Bounds");

    GrGLSLFPFragmentBuilder* fragBuilder = args.fFragBuilder;
    SkString coords2D = fragBuilder->ensureCoords2D(args.fTransformedCoords[0]);
    fragBuilder->codeAppendf("\t\tvec2 coord = %s;\n", coords2D.c_str());
    fragBuilder->codeAppendf("\t\tvec2 zoom_coord = %s + %s * %s;\n",
                             uniformHandler->getUniformCStr(fOffsetVar),
                             coords2D.c_str(),
                             uniformHandler->getUniformCStr(fInvZoomVar));
    const char* bounds = uniformHandler->getUniformCStr(fBoundsVar);
    fragBuilder->codeAppendf("\t\tvec2 delta = (coord - %s.xy) * %s.zw;\n", bounds, bounds);
    fragBuilder->codeAppendf("\t\tdelta = min(delta, vec2(1.0, 1.0) - delta);\n");
    fragBuilder->codeAppendf("\t\tdelta = delta * %s;\n",
                             uniformHandler->getUniformCStr(fInvInsetVar));

    fragBuilder->codeAppend("\t\tfloat weight = 0.0;\n");
    fragBuilder->codeAppend("\t\tif (delta.s < 2.0 && delta.t < 2.0) {\n");
    fragBuilder->codeAppend("\t\t\tdelta = vec2(2.0, 2.0) - delta;\n");
    fragBuilder->codeAppend("\t\t\tfloat dist = length(delta);\n");
    fragBuilder->codeAppend("\t\t\tdist = max(2.0 - dist, 0.0);\n");
    fragBuilder->codeAppend("\t\t\tweight = min(dist * dist, 1.0);\n");
    fragBuilder->codeAppend("\t\t} else {\n");
    fragBuilder->codeAppend("\t\t\tvec2 delta_squared = delta * delta;\n");
    fragBuilder->codeAppend("\t\t\tweight = min(min(delta_squared.x, delta_squared.y), 1.0);\n");
    fragBuilder->codeAppend("\t\t}\n");

    fragBuilder->codeAppend("\t\tvec2 mix_coord = mix(coord, zoom_coord, weight);\n");
    fragBuilder->codeAppend("\t\tvec4 output_color = ");
    fragBuilder->appendTextureLookup(args.fTexSamplers[0], "mix_coord");
    fragBuilder->codeAppend(";\n");

    fragBuilder->codeAppendf("\t\t%s = output_color;", args.fOutputColor);
    SkString modulate;
    GrGLSLMulVarBy4f(&modulate, args.fOutputColor, args.fInputColor);
    fragBuilder->codeAppend(modulate.c_str());
}

void GrGLMagnifierEffect::onSetData(const GrGLSLProgramDataManager& pdman,
                                    const GrProcessor& effect) {
    const GrMagnifierEffect& zoom = effect.cast<GrMagnifierEffect>();
    pdman.set2f(fOffsetVar, zoom.xOffset(), zoom.yOffset());
    pdman.set2f(fInvZoomVar, zoom.xInvZoom(), zoom.yInvZoom());
    pdman.set2f(fInvInsetVar, zoom.xInvInset(), zoom.yInvInset());
    pdman.set4f(fBoundsVar, zoom.bounds().x(), zoom.bounds().y(),
                            zoom.bounds().width(), zoom.bounds().height());
}

/////////////////////////////////////////////////////////////////////

void GrMagnifierEffect::onGetGLSLProcessorKey(const GrGLSLCaps& caps,
                                              GrProcessorKeyBuilder* b) const {
    GrGLMagnifierEffect::GenKey(*this, caps, b);
}

GrGLSLFragmentProcessor* GrMagnifierEffect::onCreateGLSLInstance() const {
    return new GrGLMagnifierEffect;
}

GR_DEFINE_FRAGMENT_PROCESSOR_TEST(GrMagnifierEffect);

sk_sp<GrFragmentProcessor> GrMagnifierEffect::TestCreate(GrProcessorTestData* d) {
    GrTexture* texture = d->fTextures[0];
    const int kMaxWidth = 200;
    const int kMaxHeight = 200;
    const int kMaxInset = 20;
    uint32_t width = d->fRandom->nextULessThan(kMaxWidth);
    uint32_t height = d->fRandom->nextULessThan(kMaxHeight);
    uint32_t x = d->fRandom->nextULessThan(kMaxWidth - width);
    uint32_t y = d->fRandom->nextULessThan(kMaxHeight - height);
    uint32_t inset = d->fRandom->nextULessThan(kMaxInset);

    sk_sp<GrFragmentProcessor> effect(GrMagnifierEffect::Make(
        texture,
        SkRect::MakeWH(SkIntToScalar(kMaxWidth), SkIntToScalar(kMaxHeight)),
        (float) width / texture->width(),
        (float) height / texture->height(),
        texture->width() / (float) x,
        texture->height() / (float) y,
        (float) inset / texture->width(),
        (float) inset / texture->height()));
    SkASSERT(effect);
    return effect;
}

///////////////////////////////////////////////////////////////////////////////

bool GrMagnifierEffect::onIsEqual(const GrFragmentProcessor& sBase) const {
    const GrMagnifierEffect& s = sBase.cast<GrMagnifierEffect>();
    return (this->fBounds == s.fBounds &&
            this->fXOffset == s.fXOffset &&
            this->fYOffset == s.fYOffset &&
            this->fXInvZoom == s.fXInvZoom &&
            this->fYInvZoom == s.fYInvZoom &&
            this->fXInvInset == s.fXInvInset &&
            this->fYInvInset == s.fYInvInset);
}

void GrMagnifierEffect::onComputeInvariantOutput(GrInvariantOutput* inout) const {
    this->updateInvariantOutputForModulation(inout);
}

#endif

////////////////////////////////////////////////////////////////////////////////

sk_sp<SkImageFilter> SkMagnifierImageFilter::Make(const SkRect& srcRect, SkScalar inset,
                                                  sk_sp<SkImageFilter> input,
                                                  const CropRect* cropRect) {

    if (!SkScalarIsFinite(inset) || !SkIsValidRect(srcRect)) {
        return nullptr;
    }
    // Negative numbers in src rect are not supported
    if (srcRect.fLeft < 0 || srcRect.fTop < 0) {
        return nullptr;
    }
    return sk_sp<SkImageFilter>(new SkMagnifierImageFilter(srcRect, inset,
                                                           std::move(input),
                                                           cropRect));
}


SkMagnifierImageFilter::SkMagnifierImageFilter(const SkRect& srcRect,
                                               SkScalar inset,
                                               sk_sp<SkImageFilter> input,
                                               const CropRect* cropRect)
    : INHERITED(&input, 1, cropRect)
    , fSrcRect(srcRect)
    , fInset(inset) {
    SkASSERT(srcRect.x() >= 0 && srcRect.y() >= 0 && inset >= 0);
}

sk_sp<SkFlattenable> SkMagnifierImageFilter::CreateProc(SkReadBuffer& buffer) {
    SK_IMAGEFILTER_UNFLATTEN_COMMON(common, 1);
    SkRect src;
    buffer.readRect(&src);
    return Make(src, buffer.readScalar(), common.getInput(0), &common.cropRect());
}

void SkMagnifierImageFilter::flatten(SkWriteBuffer& buffer) const {
    this->INHERITED::flatten(buffer);
    buffer.writeRect(fSrcRect);
    buffer.writeScalar(fInset);
}

sk_sp<SkSpecialImage> SkMagnifierImageFilter::onFilterImage(SkSpecialImage* source,
                                                            const Context& ctx,
                                                            SkIPoint* offset) const {
    SkIPoint inputOffset = SkIPoint::Make(0, 0);
    sk_sp<SkSpecialImage> input(this->filterInput(0, source, ctx, &inputOffset));
    if (!input) {
        return nullptr;
    }

    const SkIRect inputBounds = SkIRect::MakeXYWH(inputOffset.x(), inputOffset.y(),
                                                  input->width(), input->height());

    SkIRect bounds;
    if (!this->applyCropRect(ctx, inputBounds, &bounds)) {
        return nullptr;
    }

    SkScalar invInset = fInset > 0 ? SkScalarInvert(fInset) : SK_Scalar1;

    SkScalar invXZoom = fSrcRect.width() / bounds.width();
    SkScalar invYZoom = fSrcRect.height() / bounds.height();


#if SK_SUPPORT_GPU
    if (source->isTextureBacked()) {
        GrContext* context = source->getContext();

        sk_sp<GrTexture> inputTexture(input->asTextureRef(context));
        SkASSERT(inputTexture);

        offset->fX = bounds.left();
        offset->fY = bounds.top();
        bounds.offset(-inputOffset);

        SkScalar yOffset = inputTexture->origin() == kTopLeft_GrSurfaceOrigin
            ? fSrcRect.y()
            : inputTexture->height() -
                      fSrcRect.height() * inputTexture->height() / bounds.height() - fSrcRect.y();
        int boundsY = inputTexture->origin() == kTopLeft_GrSurfaceOrigin
            ? bounds.y()
            : inputTexture->height() - bounds.height();
        SkRect effectBounds = SkRect::MakeXYWH(
            SkIntToScalar(bounds.x()) / inputTexture->width(),
            SkIntToScalar(boundsY) / inputTexture->height(),
            SkIntToScalar(inputTexture->width()) / bounds.width(),
            SkIntToScalar(inputTexture->height()) / bounds.height());
        // SRGBTODO: Handle sRGB here
        sk_sp<GrFragmentProcessor> fp(GrMagnifierEffect::Make(
                                                        inputTexture.get(),
                                                        effectBounds,
                                                        fSrcRect.x() / inputTexture->width(),
                                                        yOffset / inputTexture->height(),
                                                        invXZoom,
                                                        invYZoom,
                                                        bounds.width() * invInset,
                                                        bounds.height() * invInset));
        if (!fp) {
            return nullptr;
        }

        return DrawWithFP(context, std::move(fp), bounds, ctx.outputProperties());
    }
#endif

    SkBitmap inputBM;

    if (!input->getROPixels(&inputBM)) {
        return nullptr;
    }

    if ((inputBM.colorType() != kN32_SkColorType) ||
        (fSrcRect.width() >= inputBM.width()) || (fSrcRect.height() >= inputBM.height())) {
        return nullptr;
    }

    SkAutoLockPixels alp(inputBM);
    SkASSERT(inputBM.getPixels());
    if (!inputBM.getPixels() || inputBM.width() <= 0 || inputBM.height() <= 0) {
        return nullptr;
    }

    const SkImageInfo info = SkImageInfo::MakeN32Premul(bounds.width(), bounds.height());

    SkBitmap dst;
    if (!dst.tryAllocPixels(info)) {
        return nullptr;
    }

    SkAutoLockPixels dstLock(dst);

    SkColor* dptr = dst.getAddr32(0, 0);
    int dstWidth = dst.width(), dstHeight = dst.height();
    for (int y = 0; y < dstHeight; ++y) {
        for (int x = 0; x < dstWidth; ++x) {
            SkScalar x_dist = SkMin32(x, dstWidth - x - 1) * invInset;
            SkScalar y_dist = SkMin32(y, dstHeight - y - 1) * invInset;
            SkScalar weight = 0;

            static const SkScalar kScalar2 = SkScalar(2);

            // To create a smooth curve at the corners, we need to work on
            // a square twice the size of the inset.
            if (x_dist < kScalar2 && y_dist < kScalar2) {
                x_dist = kScalar2 - x_dist;
                y_dist = kScalar2 - y_dist;

                SkScalar dist = SkScalarSqrt(SkScalarSquare(x_dist) +
                                             SkScalarSquare(y_dist));
                dist = SkMaxScalar(kScalar2 - dist, 0);
                weight = SkMinScalar(SkScalarSquare(dist), SK_Scalar1);
            } else {
                SkScalar sqDist = SkMinScalar(SkScalarSquare(x_dist),
                                              SkScalarSquare(y_dist));
                weight = SkMinScalar(sqDist, SK_Scalar1);
            }

            SkScalar x_interp = SkScalarMul(weight, (fSrcRect.x() + x * invXZoom)) +
                           (SK_Scalar1 - weight) * x;
            SkScalar y_interp = SkScalarMul(weight, (fSrcRect.y() + y * invYZoom)) +
                           (SK_Scalar1 - weight) * y;

            int x_val = SkTPin(bounds.x() + SkScalarFloorToInt(x_interp), 0, inputBM.width() - 1);
            int y_val = SkTPin(bounds.y() + SkScalarFloorToInt(y_interp), 0, inputBM.height() - 1);

            *dptr = *inputBM.getAddr32(x_val, y_val);
            dptr++;
        }
    }

    offset->fX = bounds.left();
    offset->fY = bounds.top();
    return SkSpecialImage::MakeFromRaster(SkIRect::MakeWH(bounds.width(), bounds.height()),
                                          dst);
}

#ifndef SK_IGNORE_TO_STRING
void SkMagnifierImageFilter::toString(SkString* str) const {
    str->appendf("SkMagnifierImageFilter: (");
    str->appendf("src: (%f,%f,%f,%f) ",
                 fSrcRect.fLeft, fSrcRect.fTop, fSrcRect.fRight, fSrcRect.fBottom);
    str->appendf("inset: %f", fInset);
    str->append(")");
}
#endif
