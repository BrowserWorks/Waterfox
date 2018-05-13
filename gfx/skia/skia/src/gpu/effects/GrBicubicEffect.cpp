/*
 * Copyright 2014 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "GrBicubicEffect.h"

#include "GrTexture.h"
#include "glsl/GrGLSLFragmentShaderBuilder.h"
#include "glsl/GrGLSLProgramDataManager.h"
#include "glsl/GrGLSLUniformHandler.h"
#include "../private/GrGLSL.h"

class GrGLBicubicEffect : public GrGLSLFragmentProcessor {
public:
    void emitCode(EmitArgs&) override;

    static inline void GenKey(const GrProcessor& effect, const GrShaderCaps&,
                              GrProcessorKeyBuilder* b) {
        const GrBicubicEffect& bicubicEffect = effect.cast<GrBicubicEffect>();
        b->add32(GrTextureDomain::GLDomain::DomainKey(bicubicEffect.domain()));
    }

protected:
    void onSetData(const GrGLSLProgramDataManager&, const GrFragmentProcessor&) override;

private:
    typedef GrGLSLProgramDataManager::UniformHandle UniformHandle;

    UniformHandle               fImageIncrementUni;
    GrTextureDomain::GLDomain   fDomain;

    typedef GrGLSLFragmentProcessor INHERITED;
};

void GrGLBicubicEffect::emitCode(EmitArgs& args) {
    const GrBicubicEffect& bicubicEffect = args.fFp.cast<GrBicubicEffect>();

    GrGLSLUniformHandler* uniformHandler = args.fUniformHandler;
    fImageIncrementUni = uniformHandler->addUniform(kFragment_GrShaderFlag, kHalf2_GrSLType,
                                                    "ImageIncrement");

    const char* imgInc = uniformHandler->getUniformCStr(fImageIncrementUni);

    GrGLSLFPFragmentBuilder* fragBuilder = args.fFragBuilder;
    SkString coords2D = fragBuilder->ensureCoords2D(args.fTransformedCoords[0]);

    /*
     * Filter weights come from Don Mitchell & Arun Netravali's 'Reconstruction Filters in Computer
     * Graphics', ACM SIGGRAPH Computer Graphics 22, 4 (Aug. 1988).
     * ACM DL: http://dl.acm.org/citation.cfm?id=378514
     * Free  : http://www.cs.utexas.edu/users/fussell/courses/cs384g/lectures/mitchell/Mitchell.pdf
     *
     * The authors define a family of cubic filters with two free parameters (B and C):
     *
     *            { (12 - 9B - 6C)|x|^3 + (-18 + 12B + 6C)|x|^2 + (6 - 2B)          if |x| < 1
     * k(x) = 1/6 { (-B - 6C)|x|^3 + (6B + 30C)|x|^2 + (-12B - 48C)|x| + (8B + 24C) if 1 <= |x| < 2
     *            { 0                                                               otherwise
     *
     * Various well-known cubic splines can be generated, and the authors select (1/3, 1/3) as their
     * favorite overall spline - this is now commonly known as the Mitchell filter, and is the
     * source of the specific weights below.
     *
     * This is GLSL, so the matrix is column-major (transposed from standard matrix notation).
     */
    fragBuilder->codeAppend("half4x4 kMitchellCoefficients = half4x4("
                            " 1.0 / 18.0,  16.0 / 18.0,   1.0 / 18.0,  0.0 / 18.0,"
                            "-9.0 / 18.0,   0.0 / 18.0,   9.0 / 18.0,  0.0 / 18.0,"
                            "15.0 / 18.0, -36.0 / 18.0,  27.0 / 18.0, -6.0 / 18.0,"
                            "-7.0 / 18.0,  21.0 / 18.0, -21.0 / 18.0,  7.0 / 18.0);");
    fragBuilder->codeAppendf("float2 coord = %s - %s * float2(0.5);", coords2D.c_str(), imgInc);
    // We unnormalize the coord in order to determine our fractional offset (f) within the texel
    // We then snap coord to a texel center and renormalize. The snap prevents cases where the
    // starting coords are near a texel boundary and accumulations of imgInc would cause us to skip/
    // double hit a texel.
    fragBuilder->codeAppendf("coord /= %s;", imgInc);
    fragBuilder->codeAppend("float2 f = fract(coord);");
    fragBuilder->codeAppendf("coord = (coord - f + float2(0.5)) * %s;", imgInc);
    fragBuilder->codeAppend("half4 wx = kMitchellCoefficients * half4(1.0, f.x, f.x * f.x, f.x * f.x * f.x);");
    fragBuilder->codeAppend("half4 wy = kMitchellCoefficients * half4(1.0, f.y, f.y * f.y, f.y * f.y * f.y);");
    fragBuilder->codeAppend("half4 rowColors[4];");
    for (int y = 0; y < 4; ++y) {
        for (int x = 0; x < 4; ++x) {
            SkString coord;
            coord.printf("coord + %s * float2(%d, %d)", imgInc, x - 1, y - 1);
            SkString sampleVar;
            sampleVar.printf("rowColors[%d]", x);
            fDomain.sampleTexture(fragBuilder,
                                  args.fUniformHandler,
                                  args.fShaderCaps,
                                  bicubicEffect.domain(),
                                  sampleVar.c_str(),
                                  coord,
                                  args.fTexSamplers[0]);
        }
        fragBuilder->codeAppendf(
            "half4 s%d = wx.x * rowColors[0] + wx.y * rowColors[1] + wx.z * rowColors[2] + wx.w * rowColors[3];",
            y);
    }
    SkString bicubicColor("(wy.x * s0 + wy.y * s1 + wy.z * s2 + wy.w * s3)");
    fragBuilder->codeAppendf("%s = %s * %s;", args.fOutputColor, bicubicColor.c_str(),
                             args.fInputColor);
}

void GrGLBicubicEffect::onSetData(const GrGLSLProgramDataManager& pdman,
                                  const GrFragmentProcessor& processor) {
    const GrBicubicEffect& bicubicEffect = processor.cast<GrBicubicEffect>();
    GrSurfaceProxy* proxy = processor.textureSampler(0).proxy();
    GrTexture* texture = proxy->priv().peekTexture();

    float imageIncrement[2];
    imageIncrement[0] = 1.0f / texture->width();
    imageIncrement[1] = 1.0f / texture->height();
    pdman.set2fv(fImageIncrementUni, 1, imageIncrement);
    fDomain.setData(pdman, bicubicEffect.domain(), proxy);
}

GrBicubicEffect::GrBicubicEffect(sk_sp<GrTextureProxy> proxy,
                                 const SkMatrix& matrix,
                                 const GrSamplerState::WrapMode wrapModes[2])
        : INHERITED{kGrBicubicEffect_ClassID, ModulateByConfigOptimizationFlags(proxy->config())}
        , fCoordTransform(matrix, proxy.get())
        , fDomain(GrTextureDomain::IgnoredDomain())
        , fTextureSampler(std::move(proxy),
                          GrSamplerState(wrapModes, GrSamplerState::Filter::kNearest)) {
    this->addCoordTransform(&fCoordTransform);
    this->addTextureSampler(&fTextureSampler);
}

GrBicubicEffect::GrBicubicEffect(sk_sp<GrTextureProxy> proxy,
                                 const SkMatrix& matrix,
                                 const SkRect& domain)
        : INHERITED(kGrBicubicEffect_ClassID, ModulateByConfigOptimizationFlags(proxy->config()))
        , fCoordTransform(matrix, proxy.get())
        , fDomain(proxy.get(), domain, GrTextureDomain::kClamp_Mode)
        , fTextureSampler(std::move(proxy)) {
    this->addCoordTransform(&fCoordTransform);
    this->addTextureSampler(&fTextureSampler);
}

GrBicubicEffect::GrBicubicEffect(const GrBicubicEffect& that)
        : INHERITED(kGrBicubicEffect_ClassID, that.optimizationFlags())
        , fCoordTransform(that.fCoordTransform)
        , fDomain(that.fDomain)
        , fTextureSampler(that.fTextureSampler) {
    this->addCoordTransform(&fCoordTransform);
    this->addTextureSampler(&fTextureSampler);
}

void GrBicubicEffect::onGetGLSLProcessorKey(const GrShaderCaps& caps,
                                            GrProcessorKeyBuilder* b) const {
    GrGLBicubicEffect::GenKey(*this, caps, b);
}

GrGLSLFragmentProcessor* GrBicubicEffect::onCreateGLSLInstance() const  {
    return new GrGLBicubicEffect;
}

bool GrBicubicEffect::onIsEqual(const GrFragmentProcessor& sBase) const {
    const GrBicubicEffect& s = sBase.cast<GrBicubicEffect>();
    return fDomain == s.fDomain;
}

GR_DEFINE_FRAGMENT_PROCESSOR_TEST(GrBicubicEffect);

#if GR_TEST_UTILS
std::unique_ptr<GrFragmentProcessor> GrBicubicEffect::TestCreate(GrProcessorTestData* d) {
    int texIdx = d->fRandom->nextBool() ? GrProcessorUnitTest::kSkiaPMTextureIdx
                                        : GrProcessorUnitTest::kAlphaTextureIdx;
    static const GrSamplerState::WrapMode kClampClamp[] = {GrSamplerState::WrapMode::kClamp,
                                                           GrSamplerState::WrapMode::kClamp};
    return GrBicubicEffect::Make(d->textureProxy(texIdx), SkMatrix::I(), kClampClamp);
}
#endif

//////////////////////////////////////////////////////////////////////////////

bool GrBicubicEffect::ShouldUseBicubic(const SkMatrix& matrix, GrSamplerState::Filter* filterMode) {
    if (matrix.isIdentity()) {
        *filterMode = GrSamplerState::Filter::kNearest;
        return false;
    }

    SkScalar scales[2];
    if (!matrix.getMinMaxScales(scales) || scales[0] < SK_Scalar1) {
        // Bicubic doesn't handle arbitrary minimization well, as src texels can be skipped
        // entirely,
        *filterMode = GrSamplerState::Filter::kMipMap;
        return false;
    }
    // At this point if scales[1] == SK_Scalar1 then the matrix doesn't do any scaling.
    if (scales[1] == SK_Scalar1) {
        if (matrix.rectStaysRect() && SkScalarIsInt(matrix.getTranslateX()) &&
            SkScalarIsInt(matrix.getTranslateY())) {
            *filterMode = GrSamplerState::Filter::kNearest;
        } else {
            // Use bilerp to handle rotation or fractional translation.
            *filterMode = GrSamplerState::Filter::kBilerp;
        }
        return false;
    }
    // When we use the bicubic filtering effect each sample is read from the texture using
    // nearest neighbor sampling.
    *filterMode = GrSamplerState::Filter::kNearest;
    return true;
}
