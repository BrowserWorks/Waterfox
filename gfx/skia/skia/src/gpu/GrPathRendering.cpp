/*
 * Copyright 2014 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "GrGpu.h"
#include "GrPathRendering.h"
#include "SkDescriptor.h"
#include "SkScalerContext.h"
#include "SkGlyph.h"
#include "SkMatrix.h"
#include "SkTypeface.h"
#include "GrPathRange.h"

const GrUserStencilSettings& GrPathRendering::GetStencilPassSettings(FillType fill) {
    switch (fill) {
        default:
            SK_ABORT("Unexpected path fill.");
        case GrPathRendering::kWinding_FillType: {
            constexpr static GrUserStencilSettings kWindingStencilPass(
                GrUserStencilSettings::StaticInit<
                    0xffff,
                    GrUserStencilTest::kAlwaysIfInClip,
                    0xffff,
                    GrUserStencilOp::kIncWrap,
                    GrUserStencilOp::kIncWrap,
                    0xffff>()
            );
            return kWindingStencilPass;
        }
        case GrPathRendering::kEvenOdd_FillType: {
            constexpr static GrUserStencilSettings kEvenOddStencilPass(
                GrUserStencilSettings::StaticInit<
                    0xffff,
                    GrUserStencilTest::kAlwaysIfInClip,
                    0xffff,
                    GrUserStencilOp::kInvert,
                    GrUserStencilOp::kInvert,
                    0xffff>()
            );
            return kEvenOddStencilPass;
        }
    }
}

class GlyphGenerator : public GrPathRange::PathGenerator {
public:
    GlyphGenerator(const SkTypeface& typeface, const SkScalerContextEffects& effects,
                   const SkDescriptor& desc)
        : fScalerContext(typeface.createScalerContext(effects, &desc))
#ifdef SK_DEBUG
        , fDesc(desc.copy())
#endif
    {}

    int getNumPaths() override {
        return fScalerContext->getGlyphCount();
    }

    void generatePath(int glyphID, SkPath* out) override {
        fScalerContext->getPath(glyphID, out);
    }
#ifdef SK_DEBUG
    bool isEqualTo(const SkDescriptor& desc) const override { return *fDesc == desc; }
#endif
private:
    const std::unique_ptr<SkScalerContext> fScalerContext;
#ifdef SK_DEBUG
    const std::unique_ptr<SkDescriptor> fDesc;
#endif
};

sk_sp<GrPathRange> GrPathRendering::createGlyphs(const SkTypeface* typeface,
                                                 const SkScalerContextEffects& effects,
                                                 const SkDescriptor* desc,
                                                 const GrStyle& style) {
    if (nullptr == typeface) {
        typeface = SkTypeface::GetDefaultTypeface();
        SkASSERT(nullptr != typeface);
    }

    if (desc) {
        sk_sp<GlyphGenerator> generator(new GlyphGenerator(*typeface, effects, *desc));
        return this->createPathRange(generator.get(), style);
    }

    SkAutoDescriptor ad;
    SkDescriptor*    genericDesc =
        SkScalerContext::MakeDescriptorForPaths(typeface->uniqueID(), &ad);

    // No effects, so we make a dummy struct
    SkScalerContextEffects noEffects;

    sk_sp<GlyphGenerator> generator(new GlyphGenerator(*typeface, noEffects, *genericDesc));
    return this->createPathRange(generator.get(), style);
}

void GrPathRendering::stencilPath(const StencilPathArgs& args, const GrPath* path) {
    fGpu->handleDirtyContext();
    this->onStencilPath(args, path);
}

void GrPathRendering::drawPath(const GrPipeline& pipeline,
                               const GrPrimitiveProcessor& primProc,
                               // Cover pass settings in pipeline.
                               const GrStencilSettings& stencilPassSettings,
                               const GrPath* path) {
    fGpu->handleDirtyContext();
    if (GrXferBarrierType barrierType = pipeline.xferBarrierType(*fGpu->caps())) {
        fGpu->xferBarrier(pipeline.renderTarget(), barrierType);
    }
    this->onDrawPath(pipeline, primProc, stencilPassSettings, path);
}

void GrPathRendering::drawPaths(const GrPipeline& pipeline,
                                const GrPrimitiveProcessor& primProc,
                                // Cover pass settings in pipeline.
                                const GrStencilSettings& stencilPassSettings,
                                const GrPathRange* pathRange,
                                const void* indices,
                                PathIndexType indexType,
                                const float transformValues[],
                                PathTransformType transformType,
                                int count) {
    fGpu->handleDirtyContext();
    if (GrXferBarrierType barrierType = pipeline.xferBarrierType(*fGpu->caps())) {
        fGpu->xferBarrier(pipeline.renderTarget(), barrierType);
    }
#ifdef SK_DEBUG
    pathRange->assertPathsLoaded(indices, indexType, count);
#endif
    this->onDrawPaths(pipeline, primProc, stencilPassSettings, pathRange, indices, indexType,
                      transformValues, transformType, count);
}
