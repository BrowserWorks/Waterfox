/*
 * Copyright 2012 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "SkSweepGradient.h"

static SkMatrix translate(SkScalar dx, SkScalar dy) {
    SkMatrix matrix;
    matrix.setTranslate(dx, dy);
    return matrix;
}

SkSweepGradient::SkSweepGradient(SkScalar cx, SkScalar cy, const Descriptor& desc)
    : SkGradientShaderBase(desc, translate(-cx, -cy))
    , fCenter(SkPoint::Make(cx, cy))
{
    // overwrite the tilemode to a canonical value (since sweep ignores it)
    fTileMode = SkShader::kClamp_TileMode;
}

SkShader::GradientType SkSweepGradient::asAGradient(GradientInfo* info) const {
    if (info) {
        commonAsAGradient(info);
        info->fPoint[0] = fCenter;
    }
    return kSweep_GradientType;
}

sk_sp<SkFlattenable> SkSweepGradient::CreateProc(SkReadBuffer& buffer) {
    DescriptorScope desc;
    if (!desc.unflatten(buffer)) {
        return nullptr;
    }
    const SkPoint center = buffer.readPoint();
    return SkGradientShader::MakeSweep(center.x(), center.y(), desc.fColors,
                                       std::move(desc.fColorSpace), desc.fPos, desc.fCount,
                                       desc.fGradFlags, desc.fLocalMatrix);
}

void SkSweepGradient::flatten(SkWriteBuffer& buffer) const {
    this->INHERITED::flatten(buffer);
    buffer.writePoint(fCenter);
}

size_t SkSweepGradient::onContextSize(const ContextRec&) const {
    return sizeof(SweepGradientContext);
}

SkShader::Context* SkSweepGradient::onCreateContext(const ContextRec& rec, void* storage) const {
    return CheckedCreateContext<SweepGradientContext>(storage, *this, rec);
}

SkSweepGradient::SweepGradientContext::SweepGradientContext(
        const SkSweepGradient& shader, const ContextRec& rec)
    : INHERITED(shader, rec) {}

//  returns angle in a circle [0..2PI) -> [0..255]
static unsigned SkATan2_255(float y, float x) {
    //    static const float g255Over2PI = 255 / (2 * SK_ScalarPI);
    static const float g255Over2PI = 40.584510488433314f;

    float result = sk_float_atan2(y, x);
    if (!SkScalarIsFinite(result)) {
        return 0;
    }
    if (result < 0) {
        result += 2 * SK_ScalarPI;
    }
    SkASSERT(result >= 0);
    // since our value is always >= 0, we can cast to int, which is faster than
    // calling floorf()
    int ir = (int)(result * g255Over2PI);
    SkASSERT(ir >= 0 && ir <= 255);
    return ir;
}

void SkSweepGradient::SweepGradientContext::shadeSpan(int x, int y, SkPMColor* SK_RESTRICT dstC,
                                                      int count) {
    SkMatrix::MapXYProc proc = fDstToIndexProc;
    const SkMatrix&     matrix = fDstToIndex;
    const SkPMColor* SK_RESTRICT cache = fCache->getCache32();
    int                 toggle = init_dither_toggle(x, y);
    SkPoint             srcPt;

    if (fDstToIndexClass != kPerspective_MatrixClass) {
        proc(matrix, SkIntToScalar(x) + SK_ScalarHalf,
                     SkIntToScalar(y) + SK_ScalarHalf, &srcPt);
        SkScalar dx, fx = srcPt.fX;
        SkScalar dy, fy = srcPt.fY;

        if (fDstToIndexClass == kFixedStepInX_MatrixClass) {
            const auto step = matrix.fixedStepInX(SkIntToScalar(y) + SK_ScalarHalf);
            dx = step.fX;
            dy = step.fY;
        } else {
            SkASSERT(fDstToIndexClass == kLinear_MatrixClass);
            dx = matrix.getScaleX();
            dy = matrix.getSkewY();
        }

        for (; count > 0; --count) {
            *dstC++ = cache[toggle + SkATan2_255(fy, fx)];
            fx += dx;
            fy += dy;
            toggle = next_dither_toggle(toggle);
        }
    } else {  // perspective case
        for (int stop = x + count; x < stop; x++) {
            proc(matrix, SkIntToScalar(x) + SK_ScalarHalf,
                         SkIntToScalar(y) + SK_ScalarHalf, &srcPt);
            *dstC++ = cache[toggle + SkATan2_255(srcPt.fY, srcPt.fX)];
            toggle = next_dither_toggle(toggle);
        }
    }
}

/////////////////////////////////////////////////////////////////////

#if SK_SUPPORT_GPU

#include "SkGr.h"
#include "gl/GrGLContext.h"
#include "glsl/GrGLSLCaps.h"
#include "glsl/GrGLSLFragmentShaderBuilder.h"

class GrSweepGradient : public GrGradientEffect {
public:
    class GLSLSweepProcessor;

    static sk_sp<GrFragmentProcessor> Make(const CreateArgs& args) {
        return sk_sp<GrFragmentProcessor>(new GrSweepGradient(args));
    }
    virtual ~GrSweepGradient() { }

    const char* name() const override { return "Sweep Gradient"; }

private:
    GrSweepGradient(const CreateArgs& args)
    : INHERITED(args) {
        this->initClassID<GrSweepGradient>();
    }

    GrGLSLFragmentProcessor* onCreateGLSLInstance() const override;

    virtual void onGetGLSLProcessorKey(const GrGLSLCaps& caps,
                                       GrProcessorKeyBuilder* b) const override;

    GR_DECLARE_FRAGMENT_PROCESSOR_TEST;

    typedef GrGradientEffect INHERITED;
};

/////////////////////////////////////////////////////////////////////

class GrSweepGradient::GLSLSweepProcessor : public GrGradientEffect::GLSLProcessor {
public:
    GLSLSweepProcessor(const GrProcessor&) {}
    virtual ~GLSLSweepProcessor() { }

    virtual void emitCode(EmitArgs&) override;

    static void GenKey(const GrProcessor& processor, const GrGLSLCaps&, GrProcessorKeyBuilder* b) {
        b->add32(GenBaseGradientKey(processor));
    }

private:
    typedef GrGradientEffect::GLSLProcessor INHERITED;

};

/////////////////////////////////////////////////////////////////////

GrGLSLFragmentProcessor* GrSweepGradient::onCreateGLSLInstance() const {
    return new GrSweepGradient::GLSLSweepProcessor(*this);
}

void GrSweepGradient::onGetGLSLProcessorKey(const GrGLSLCaps& caps,
                                            GrProcessorKeyBuilder* b) const {
    GrSweepGradient::GLSLSweepProcessor::GenKey(*this, caps, b);
}


/////////////////////////////////////////////////////////////////////

GR_DEFINE_FRAGMENT_PROCESSOR_TEST(GrSweepGradient);

sk_sp<GrFragmentProcessor> GrSweepGradient::TestCreate(GrProcessorTestData* d) {
    SkPoint center = {d->fRandom->nextUScalar1(), d->fRandom->nextUScalar1()};

    SkColor colors[kMaxRandomGradientColors];
    SkScalar stopsArray[kMaxRandomGradientColors];
    SkScalar* stops = stopsArray;
    SkShader::TileMode tmIgnored;
    int colorCount = RandomGradientParams(d->fRandom, colors, &stops, &tmIgnored);
    sk_sp<SkShader> shader(SkGradientShader::MakeSweep(center.fX, center.fY,  colors, stops,
                                                       colorCount));
    SkMatrix viewMatrix = GrTest::TestMatrix(d->fRandom);
    auto dstColorSpace = GrTest::TestColorSpace(d->fRandom);
    sk_sp<GrFragmentProcessor> fp = shader->asFragmentProcessor(SkShader::AsFPArgs(
        d->fContext, &viewMatrix, NULL, kNone_SkFilterQuality, dstColorSpace.get(),
        SkSourceGammaTreatment::kRespect));
    GrAlwaysAssert(fp);
    return fp;
}

/////////////////////////////////////////////////////////////////////

void GrSweepGradient::GLSLSweepProcessor::emitCode(EmitArgs& args) {
    const GrSweepGradient& ge = args.fFp.cast<GrSweepGradient>();
    this->emitUniforms(args.fUniformHandler, ge);
    SkString coords2D = args.fFragBuilder->ensureCoords2D(args.fTransformedCoords[0]);
    SkString t;
    // 0.1591549430918 is 1/(2*pi), used since atan returns values [-pi, pi]
    // On Intel GPU there is an issue where it reads the second arguement to atan "- %s.x" as an int
    // thus must us -1.0 * %s.x to work correctly
    if (args.fGLSLCaps->mustForceNegatedAtanParamToFloat()){
        t.printf("(atan(- %s.y, -1.0 * %s.x) * 0.1591549430918 + 0.5)",
                 coords2D.c_str(), coords2D.c_str());
    } else {
        t.printf("(atan(- %s.y, - %s.x) * 0.1591549430918 + 0.5)",
                 coords2D.c_str(), coords2D.c_str());
    }
    this->emitColor(args.fFragBuilder,
                    args.fUniformHandler,
                    args.fGLSLCaps,
                    ge, t.c_str(),
                    args.fOutputColor,
                    args.fInputColor,
                    args.fTexSamplers);
}

/////////////////////////////////////////////////////////////////////

sk_sp<GrFragmentProcessor> SkSweepGradient::asFragmentProcessor(const AsFPArgs& args) const {

    SkMatrix matrix;
    if (!this->getLocalMatrix().invert(&matrix)) {
        return nullptr;
    }
    if (args.fLocalMatrix) {
        SkMatrix inv;
        if (!args.fLocalMatrix->invert(&inv)) {
            return nullptr;
        }
        matrix.postConcat(inv);
    }
    matrix.postConcat(fPtsToUnit);

    sk_sp<GrColorSpaceXform> colorSpaceXform = GrColorSpaceXform::Make(fColorSpace.get(),
                                                                       args.fDstColorSpace);
    sk_sp<GrFragmentProcessor> inner(GrSweepGradient::Make(
        GrGradientEffect::CreateArgs(args.fContext, this, &matrix, SkShader::kClamp_TileMode,
                                     std::move(colorSpaceXform), SkToBool(args.fDstColorSpace))));
    return GrFragmentProcessor::MulOutputByInputAlpha(std::move(inner));
}

#endif

#ifndef SK_IGNORE_TO_STRING
void SkSweepGradient::toString(SkString* str) const {
    str->append("SkSweepGradient: (");

    str->append("center: (");
    str->appendScalar(fCenter.fX);
    str->append(", ");
    str->appendScalar(fCenter.fY);
    str->append(") ");

    this->INHERITED::toString(str);

    str->append(")");
}
#endif
