/*
 * Copyright 2012 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "GrGaussianConvolutionFragmentProcessor.h"

#include "GrTexture.h"
#include "GrTextureProxy.h"
#include "../private/GrGLSL.h"
#include "glsl/GrGLSLFragmentProcessor.h"
#include "glsl/GrGLSLFragmentShaderBuilder.h"
#include "glsl/GrGLSLProgramDataManager.h"
#include "glsl/GrGLSLUniformHandler.h"

// For brevity
using UniformHandle = GrGLSLProgramDataManager::UniformHandle;
using Direction = GrGaussianConvolutionFragmentProcessor::Direction;

class GrGLConvolutionEffect : public GrGLSLFragmentProcessor {
public:
    void emitCode(EmitArgs&) override;

    static inline void GenKey(const GrProcessor&, const GrShaderCaps&, GrProcessorKeyBuilder*);

protected:
    void onSetData(const GrGLSLProgramDataManager&, const GrFragmentProcessor&) override;

private:
    UniformHandle fKernelUni;
    UniformHandle fImageIncrementUni;
    UniformHandle fBoundsUni;

    typedef GrGLSLFragmentProcessor INHERITED;
};

void GrGLConvolutionEffect::emitCode(EmitArgs& args) {
    const GrGaussianConvolutionFragmentProcessor& ce =
            args.fFp.cast<GrGaussianConvolutionFragmentProcessor>();

    GrGLSLUniformHandler* uniformHandler = args.fUniformHandler;
    fImageIncrementUni = uniformHandler->addUniform(kFragment_GrShaderFlag, kHalf2_GrSLType,
                                                    "ImageIncrement");
    if (ce.useBounds()) {
        fBoundsUni = uniformHandler->addUniform(kFragment_GrShaderFlag, kHalf2_GrSLType,
                                                "Bounds");
    }

    int width = ce.width();

    int arrayCount = (width + 3) / 4;
    SkASSERT(4 * arrayCount >= width);

    fKernelUni = uniformHandler->addUniformArray(kFragment_GrShaderFlag, kHalf4_GrSLType,
                                                 "Kernel", arrayCount);

    GrGLSLFPFragmentBuilder* fragBuilder = args.fFragBuilder;
    SkString coords2D = fragBuilder->ensureCoords2D(args.fTransformedCoords[0]);

    fragBuilder->codeAppendf("%s = half4(0, 0, 0, 0);", args.fOutputColor);

    const GrShaderVar& kernel = uniformHandler->getUniformVariable(fKernelUni);
    const char* imgInc = uniformHandler->getUniformCStr(fImageIncrementUni);

    fragBuilder->codeAppendf("float2 coord = %s - %d.0 * %s;", coords2D.c_str(), ce.radius(), imgInc);
    fragBuilder->codeAppend("float2 coordSampled = half2(0, 0);");

    // Manually unroll loop because some drivers don't; yields 20-30% speedup.
    const char* kVecSuffix[4] = {".x", ".y", ".z", ".w"};
    for (int i = 0; i < width; i++) {
        SkString index;
        SkString kernelIndex;
        index.appendS32(i / 4);
        kernel.appendArrayAccess(index.c_str(), &kernelIndex);
        kernelIndex.append(kVecSuffix[i & 0x3]);

        fragBuilder->codeAppend("coordSampled = coord;");
        if (ce.useBounds()) {
            // We used to compute a bool indicating whether we're in bounds or not, cast it to a
            // float, and then mul weight*texture_sample by the float. However, the Adreno 430 seems
            // to have a bug that caused corruption.
            const char* bounds = uniformHandler->getUniformCStr(fBoundsUni);
            const char* component = ce.direction() == Direction::kY ? "y" : "x";

            switch (ce.mode()) {
                case GrTextureDomain::kClamp_Mode: {
                    fragBuilder->codeAppendf("coordSampled.%s = clamp(coord.%s, %s.x, %s.y);\n",
                                             component, component, bounds, bounds);
                    break;
                }
                case GrTextureDomain::kRepeat_Mode: {
                    fragBuilder->codeAppendf("coordSampled.%s = "
                                             "mod(coord.%s - %s.x, %s.y - %s.x) + %s.x;\n",
                                             component, component, bounds, bounds, bounds, bounds);
                    break;
                }
                case GrTextureDomain::kDecal_Mode: {
                    fragBuilder->codeAppendf("if (coord.%s >= %s.x && coord.%s <= %s.y) {",
                                             component, bounds, component, bounds);
                    break;
                }
                default: {
                    SK_ABORT("Unsupported operation.");
                }
            }
        }
        fragBuilder->codeAppendf("%s += ", args.fOutputColor);
        fragBuilder->appendTextureLookup(args.fTexSamplers[0], "coordSampled");
        fragBuilder->codeAppendf(" * %s;\n", kernelIndex.c_str());
        if (GrTextureDomain::kDecal_Mode == ce.mode()) {
            fragBuilder->codeAppend("}");
        }
        fragBuilder->codeAppendf("coord += %s;\n", imgInc);
    }
    fragBuilder->codeAppendf("%s *= %s;\n", args.fOutputColor, args.fInputColor);
}

void GrGLConvolutionEffect::onSetData(const GrGLSLProgramDataManager& pdman,
                                      const GrFragmentProcessor& processor) {
    const GrGaussianConvolutionFragmentProcessor& conv =
            processor.cast<GrGaussianConvolutionFragmentProcessor>();
    GrSurfaceProxy* proxy = conv.textureSampler(0).proxy();
    GrTexture& texture = *proxy->priv().peekTexture();

    float imageIncrement[2] = {0};
    float ySign = proxy->origin() != kTopLeft_GrSurfaceOrigin ? 1.0f : -1.0f;
    switch (conv.direction()) {
        case Direction::kX:
            imageIncrement[0] = 1.0f / texture.width();
            break;
        case Direction::kY:
            imageIncrement[1] = ySign / texture.height();
            break;
        default:
            SK_ABORT("Unknown filter direction.");
    }
    pdman.set2fv(fImageIncrementUni, 1, imageIncrement);
    if (conv.useBounds()) {
        float bounds[2] = {0};
        bounds[0] = conv.bounds()[0];
        bounds[1] = conv.bounds()[1];
        if (GrTextureDomain::kClamp_Mode == conv.mode()) {
            bounds[0] += SK_ScalarHalf;
            bounds[1] -= SK_ScalarHalf;
        }
        if (Direction::kX == conv.direction()) {
            SkScalar inv = SkScalarInvert(SkIntToScalar(texture.width()));
            pdman.set2f(fBoundsUni, inv * bounds[0], inv * bounds[1]);
        } else {
            SkScalar inv = SkScalarInvert(SkIntToScalar(texture.height()));
            if (proxy->origin() != kTopLeft_GrSurfaceOrigin) {
                pdman.set2f(fBoundsUni, 1.0f - (inv * bounds[1]), 1.0f - (inv * bounds[0]));
            } else {
                pdman.set2f(fBoundsUni, inv * bounds[1], inv * bounds[0]);
            }
        }
    }
    int width = conv.width();

    int arrayCount = (width + 3) / 4;
    SkASSERT(4 * arrayCount >= width);
    pdman.set4fv(fKernelUni, arrayCount, conv.kernel());
}

void GrGLConvolutionEffect::GenKey(const GrProcessor& processor, const GrShaderCaps&,
                                   GrProcessorKeyBuilder* b) {
    const GrGaussianConvolutionFragmentProcessor& conv =
            processor.cast<GrGaussianConvolutionFragmentProcessor>();
    uint32_t key = conv.radius();
    key <<= 3;
    key |= Direction::kY == conv.direction() ? 0x4 : 0x0;
    key |= static_cast<uint32_t>(conv.mode());
    b->add32(key);
}

///////////////////////////////////////////////////////////////////////////////
static void fill_in_1D_gaussian_kernel(float* kernel, int width, float gaussianSigma, int radius) {
    const float denom = 1.0f / (2.0f * gaussianSigma * gaussianSigma);

    float sum = 0.0f;
    for (int i = 0; i < width; ++i) {
        float x = static_cast<float>(i - radius);
        // Note that the constant term (1/(sqrt(2*pi*sigma^2)) of the Gaussian
        // is dropped here, since we renormalize the kernel below.
        kernel[i] = sk_float_exp(-x * x * denom);
        sum += kernel[i];
    }
    // Normalize the kernel
    float scale = 1.0f / sum;
    for (int i = 0; i < width; ++i) {
        kernel[i] *= scale;
    }
}

GrGaussianConvolutionFragmentProcessor::GrGaussianConvolutionFragmentProcessor(
                                                            sk_sp<GrTextureProxy> proxy,
                                                            Direction direction,
                                                            int radius,
                                                            float gaussianSigma,
                                                            GrTextureDomain::Mode mode,
                                                            int bounds[2])
        : INHERITED(kGrGaussianConvolutionFragmentProcessor_ClassID,
                    ModulateByConfigOptimizationFlags(proxy->config()))
        , fCoordTransform(proxy.get())
        , fTextureSampler(std::move(proxy))
        , fRadius(radius)
        , fDirection(direction)
        , fMode(mode) {
    this->addCoordTransform(&fCoordTransform);
    this->addTextureSampler(&fTextureSampler);
    SkASSERT(radius <= kMaxKernelRadius);

    fill_in_1D_gaussian_kernel(fKernel, this->width(), gaussianSigma, this->radius());

    memcpy(fBounds, bounds, sizeof(fBounds));
}

GrGaussianConvolutionFragmentProcessor::GrGaussianConvolutionFragmentProcessor(
        const GrGaussianConvolutionFragmentProcessor& that)
        : INHERITED(kGrGaussianConvolutionFragmentProcessor_ClassID, that.optimizationFlags())
        , fCoordTransform(that.fCoordTransform)
        , fTextureSampler(that.fTextureSampler)
        , fRadius(that.fRadius)
        , fDirection(that.fDirection)
        , fMode(that.fMode) {
    this->addCoordTransform(&fCoordTransform);
    this->addTextureSampler(&fTextureSampler);
    memcpy(fKernel, that.fKernel, that.width() * sizeof(float));
    memcpy(fBounds, that.fBounds, sizeof(fBounds));
}

void GrGaussianConvolutionFragmentProcessor::onGetGLSLProcessorKey(const GrShaderCaps& caps,
                                                                   GrProcessorKeyBuilder* b) const {
    GrGLConvolutionEffect::GenKey(*this, caps, b);
}

GrGLSLFragmentProcessor* GrGaussianConvolutionFragmentProcessor::onCreateGLSLInstance() const {
    return new GrGLConvolutionEffect;
}

bool GrGaussianConvolutionFragmentProcessor::onIsEqual(const GrFragmentProcessor& sBase) const {
    const GrGaussianConvolutionFragmentProcessor& s =
            sBase.cast<GrGaussianConvolutionFragmentProcessor>();
    return (this->radius() == s.radius() && this->direction() == s.direction() &&
            this->mode() == s.mode() &&
            0 == memcmp(fBounds, s.fBounds, sizeof(fBounds)) &&
            0 == memcmp(fKernel, s.fKernel, this->width() * sizeof(float)));
}

///////////////////////////////////////////////////////////////////////////////

GR_DEFINE_FRAGMENT_PROCESSOR_TEST(GrGaussianConvolutionFragmentProcessor);

#if GR_TEST_UTILS
std::unique_ptr<GrFragmentProcessor> GrGaussianConvolutionFragmentProcessor::TestCreate(
        GrProcessorTestData* d) {
    int texIdx = d->fRandom->nextBool() ? GrProcessorUnitTest::kSkiaPMTextureIdx
                                        : GrProcessorUnitTest::kAlphaTextureIdx;
    sk_sp<GrTextureProxy> proxy = d->textureProxy(texIdx);

    int bounds[2];
    int modeIdx = d->fRandom->nextRangeU(0, GrTextureDomain::kModeCount-1);

    Direction dir;
    if (d->fRandom->nextBool()) {
        dir = Direction::kX;
        bounds[0] = d->fRandom->nextRangeU(0, proxy->width()-1);
        bounds[1] = d->fRandom->nextRangeU(bounds[0], proxy->width()-1);
    } else {
        dir = Direction::kY;
        bounds[0] = d->fRandom->nextRangeU(0, proxy->height()-1);
        bounds[1] = d->fRandom->nextRangeU(bounds[0], proxy->height()-1);
    }

    int radius = d->fRandom->nextRangeU(1, kMaxKernelRadius);
    float sigma = radius / 3.f;

    return GrGaussianConvolutionFragmentProcessor::Make(
            d->textureProxy(texIdx),
            dir, radius, sigma, static_cast<GrTextureDomain::Mode>(modeIdx), bounds);
}
#endif
