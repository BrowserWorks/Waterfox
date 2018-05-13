/*
 * Copyright 2014 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "GrGLSLFragmentShaderBuilder.h"
#include "GrRenderTarget.h"
#include "GrRenderTargetPriv.h"
#include "GrShaderCaps.h"
#include "gl/GrGLGpu.h"
#include "glsl/GrGLSLProgramBuilder.h"
#include "glsl/GrGLSLUniformHandler.h"
#include "glsl/GrGLSLVarying.h"
#include "../private/GrGLSL.h"

const char* GrGLSLFragmentShaderBuilder::kDstColorName = "_dstColor";

static const char* specific_layout_qualifier_name(GrBlendEquation equation) {
    SkASSERT(GrBlendEquationIsAdvanced(equation));

    static const char* kLayoutQualifierNames[] = {
        "blend_support_screen",
        "blend_support_overlay",
        "blend_support_darken",
        "blend_support_lighten",
        "blend_support_colordodge",
        "blend_support_colorburn",
        "blend_support_hardlight",
        "blend_support_softlight",
        "blend_support_difference",
        "blend_support_exclusion",
        "blend_support_multiply",
        "blend_support_hsl_hue",
        "blend_support_hsl_saturation",
        "blend_support_hsl_color",
        "blend_support_hsl_luminosity"
    };
    return kLayoutQualifierNames[equation - kFirstAdvancedGrBlendEquation];

    GR_STATIC_ASSERT(0 == kScreen_GrBlendEquation - kFirstAdvancedGrBlendEquation);
    GR_STATIC_ASSERT(1 == kOverlay_GrBlendEquation - kFirstAdvancedGrBlendEquation);
    GR_STATIC_ASSERT(2 == kDarken_GrBlendEquation - kFirstAdvancedGrBlendEquation);
    GR_STATIC_ASSERT(3 == kLighten_GrBlendEquation - kFirstAdvancedGrBlendEquation);
    GR_STATIC_ASSERT(4 == kColorDodge_GrBlendEquation - kFirstAdvancedGrBlendEquation);
    GR_STATIC_ASSERT(5 == kColorBurn_GrBlendEquation - kFirstAdvancedGrBlendEquation);
    GR_STATIC_ASSERT(6 == kHardLight_GrBlendEquation - kFirstAdvancedGrBlendEquation);
    GR_STATIC_ASSERT(7 == kSoftLight_GrBlendEquation - kFirstAdvancedGrBlendEquation);
    GR_STATIC_ASSERT(8 == kDifference_GrBlendEquation - kFirstAdvancedGrBlendEquation);
    GR_STATIC_ASSERT(9 == kExclusion_GrBlendEquation - kFirstAdvancedGrBlendEquation);
    GR_STATIC_ASSERT(10 == kMultiply_GrBlendEquation - kFirstAdvancedGrBlendEquation);
    GR_STATIC_ASSERT(11 == kHSLHue_GrBlendEquation - kFirstAdvancedGrBlendEquation);
    GR_STATIC_ASSERT(12 == kHSLSaturation_GrBlendEquation - kFirstAdvancedGrBlendEquation);
    GR_STATIC_ASSERT(13 == kHSLColor_GrBlendEquation - kFirstAdvancedGrBlendEquation);
    GR_STATIC_ASSERT(14 == kHSLLuminosity_GrBlendEquation - kFirstAdvancedGrBlendEquation);
    GR_STATIC_ASSERT(SK_ARRAY_COUNT(kLayoutQualifierNames) ==
                     kGrBlendEquationCnt - kFirstAdvancedGrBlendEquation);
}

uint8_t GrGLSLFragmentShaderBuilder::KeyForSurfaceOrigin(GrSurfaceOrigin origin) {
    SkASSERT(kTopLeft_GrSurfaceOrigin == origin || kBottomLeft_GrSurfaceOrigin == origin);
    return origin + 1;

    GR_STATIC_ASSERT(0 == kTopLeft_GrSurfaceOrigin);
    GR_STATIC_ASSERT(1 == kBottomLeft_GrSurfaceOrigin);
}

GrGLSLFragmentShaderBuilder::GrGLSLFragmentShaderBuilder(GrGLSLProgramBuilder* program)
    : GrGLSLFragmentBuilder(program)
    , fSetupFragPosition(false)
    , fHasCustomColorOutput(false)
    , fCustomColorOutputIndex(-1)
    , fHasSecondaryOutput(false)
    , fForceHighPrecision(false) {
    fSubstageIndices.push_back(0);
#ifdef SK_DEBUG
    fHasReadDstColor = false;
#endif
}

SkString GrGLSLFragmentShaderBuilder::ensureCoords2D(const GrShaderVar& coords) {
    if (kFloat3_GrSLType != coords.getType() && kHalf3_GrSLType != coords.getType()) {
        SkASSERT(kFloat2_GrSLType == coords.getType() || kHalf2_GrSLType == coords.getType());
        return coords.getName();
    }

    SkString coords2D;
    coords2D.printf("%s_ensure2D", coords.c_str());
    this->codeAppendf("\tfloat2 %s = %s.xy / %s.z;", coords2D.c_str(), coords.c_str(),
                      coords.c_str());
    return coords2D;
}

const char* GrGLSLFragmentShaderBuilder::dstColor() {
    SkDEBUGCODE(fHasReadDstColor = true;)

    const char* override = fProgramBuilder->primitiveProcessor().getDestColorOverride();
    if (override != nullptr) {
        return override;
    }

    const GrShaderCaps* shaderCaps = fProgramBuilder->shaderCaps();
    if (shaderCaps->fbFetchSupport()) {
        this->addFeature(1 << kFramebufferFetch_GLSLPrivateFeature,
                         shaderCaps->fbFetchExtensionString());

        // Some versions of this extension string require declaring custom color output on ES 3.0+
        const char* fbFetchColorName = shaderCaps->fbFetchColorName();
        if (shaderCaps->fbFetchNeedsCustomOutput()) {
            this->enableCustomOutput();
            fOutputs[fCustomColorOutputIndex].setTypeModifier(GrShaderVar::kInOut_TypeModifier);
            fbFetchColorName = DeclaredColorOutputName();
            // Set the dstColor to an intermediate variable so we don't override it with the output
            this->codeAppendf("half4 %s = %s;", kDstColorName, fbFetchColorName);
        } else {
            return fbFetchColorName;
        }
    }
    return kDstColorName;
}

void GrGLSLFragmentShaderBuilder::enableAdvancedBlendEquationIfNeeded(GrBlendEquation equation) {
    SkASSERT(GrBlendEquationIsAdvanced(equation));

    const GrShaderCaps& caps = *fProgramBuilder->shaderCaps();
    if (!caps.mustEnableAdvBlendEqs()) {
        return;
    }

    this->addFeature(1 << kBlendEquationAdvanced_GLSLPrivateFeature,
                     "GL_KHR_blend_equation_advanced");
    if (caps.mustEnableSpecificAdvBlendEqs()) {
        this->addLayoutQualifier(specific_layout_qualifier_name(equation), kOut_InterfaceQualifier);
    } else {
        this->addLayoutQualifier("blend_support_all_equations", kOut_InterfaceQualifier);
    }
}

void GrGLSLFragmentShaderBuilder::enableCustomOutput() {
    if (!fHasCustomColorOutput) {
        fHasCustomColorOutput = true;
        fCustomColorOutputIndex = fOutputs.count();
        fOutputs.push_back().set(kHalf4_GrSLType, DeclaredColorOutputName(),
                                 GrShaderVar::kOut_TypeModifier);
        fProgramBuilder->finalizeFragmentOutputColor(fOutputs.back());
    }
}

void GrGLSLFragmentShaderBuilder::enableSecondaryOutput() {
    SkASSERT(!fHasSecondaryOutput);
    fHasSecondaryOutput = true;
    const GrShaderCaps& caps = *fProgramBuilder->shaderCaps();
    if (const char* extension = caps.secondaryOutputExtensionString()) {
        this->addFeature(1 << kBlendFuncExtended_GLSLPrivateFeature, extension);
    }

    // If the primary output is declared, we must declare also the secondary output
    // and vice versa, since it is not allowed to use a built-in gl_FragColor and a custom
    // output. The condition also co-incides with the condition in whici GLES SL 2.0
    // requires the built-in gl_SecondaryFragColorEXT, where as 3.0 requires a custom output.
    if (caps.mustDeclareFragmentShaderOutput()) {
        fOutputs.push_back().set(kHalf4_GrSLType, DeclaredSecondaryColorOutputName(),
                                 GrShaderVar::kOut_TypeModifier);
        fProgramBuilder->finalizeFragmentSecondaryColor(fOutputs.back());
    }
}

const char* GrGLSLFragmentShaderBuilder::getPrimaryColorOutputName() const {
    return fHasCustomColorOutput ? DeclaredColorOutputName() : "sk_FragColor";
}

void GrGLSLFragmentBuilder::declAppendf(const char* fmt, ...) {
    va_list argp;
    va_start(argp, fmt);
    inputs().appendVAList(fmt, argp);
    va_end(argp);
}

const char* GrGLSLFragmentShaderBuilder::getSecondaryColorOutputName() const {
    const GrShaderCaps& caps = *fProgramBuilder->shaderCaps();
    return caps.mustDeclareFragmentShaderOutput() ? DeclaredSecondaryColorOutputName()
                                                  : "gl_SecondaryFragColorEXT";
}

GrSurfaceOrigin GrGLSLFragmentShaderBuilder::getSurfaceOrigin() const {
    SkASSERT(fProgramBuilder->header().fSurfaceOriginKey);
    return static_cast<GrSurfaceOrigin>(fProgramBuilder->header().fSurfaceOriginKey-1);

    GR_STATIC_ASSERT(0 == kTopLeft_GrSurfaceOrigin);
    GR_STATIC_ASSERT(1 == kBottomLeft_GrSurfaceOrigin);
}

void GrGLSLFragmentShaderBuilder::onFinalize() {
    fProgramBuilder->varyingHandler()->getFragDecls(&this->inputs(), &this->outputs());
}

void GrGLSLFragmentShaderBuilder::onBeforeChildProcEmitCode() {
    SkASSERT(fSubstageIndices.count() >= 1);
    fSubstageIndices.push_back(0);
    // second-to-last value in the fSubstageIndices stack is the index of the child proc
    // at that level which is currently emitting code.
    fMangleString.appendf("_c%d", fSubstageIndices[fSubstageIndices.count() - 2]);
}

void GrGLSLFragmentShaderBuilder::onAfterChildProcEmitCode() {
    SkASSERT(fSubstageIndices.count() >= 2);
    fSubstageIndices.pop_back();
    fSubstageIndices.back()++;
    int removeAt = fMangleString.findLastOf('_');
    fMangleString.remove(removeAt, fMangleString.size() - removeAt);
}
