/*
 * Copyright 2014 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "glsl/GrGLSLXferProcessor.h"

#include "GrXferProcessor.h"
#include "glsl/GrGLSLFragmentShaderBuilder.h"
#include "glsl/GrGLSLProgramDataManager.h"
#include "glsl/GrGLSLUniformHandler.h"

void GrGLSLXferProcessor::emitCode(const EmitArgs& args) {
    if (!args.fXP.willReadDstColor()) {
        this->emitOutputsForBlendState(args);
        return;
    }

    GrGLSLXPFragmentBuilder* fragBuilder = args.fXPFragBuilder;
    GrGLSLUniformHandler* uniformHandler = args.fUniformHandler;
    const char* dstColor = fragBuilder->dstColor();

    bool needsLocalOutColor = false;

    if (args.fXP.getDstTexture()) {
        bool topDown = kTopLeft_GrSurfaceOrigin == args.fXP.getDstTexture()->origin();

        if (args.fInputCoverage) {
            // We don't think any shaders actually output negative coverage, but just as a safety
            // check for floating point precision errors we compare with <= here
            fragBuilder->codeAppendf("if (all(lessThanEqual(%s, vec4(0)))) {"
                                     "    discard;"
                                     "}", args.fInputCoverage);
        }

        const char* dstTopLeftName;
        const char* dstCoordScaleName;

        fDstTopLeftUni = uniformHandler->addUniform(kFragment_GrShaderFlag,
                                                    kVec2f_GrSLType,
                                                    kDefault_GrSLPrecision,
                                                    "DstTextureUpperLeft",
                                                    &dstTopLeftName);
        fDstScaleUni = uniformHandler->addUniform(kFragment_GrShaderFlag,
                                                  kVec2f_GrSLType,
                                                  kDefault_GrSLPrecision,
                                                  "DstTextureCoordScale",
                                                  &dstCoordScaleName);
        const char* fragPos = fragBuilder->fragmentPosition();

        fragBuilder->codeAppend("// Read color from copy of the destination.\n");
        fragBuilder->codeAppendf("vec2 _dstTexCoord = (%s.xy - %s) * %s;",
                                 fragPos, dstTopLeftName, dstCoordScaleName);

        if (!topDown) {
            fragBuilder->codeAppend("_dstTexCoord.y = 1.0 - _dstTexCoord.y;");
        }

        fragBuilder->codeAppendf("vec4 %s = ", dstColor);
        fragBuilder->appendTextureLookup(args.fTexSamplers[0], "_dstTexCoord", kVec2f_GrSLType);
        fragBuilder->codeAppend(";");
    } else {
        needsLocalOutColor = args.fGLSLCaps->requiresLocalOutputColorForFBFetch();
    }

    const char* outColor = "_localColorOut";
    if (!needsLocalOutColor) {
        outColor = args.fOutputPrimary;
    } else {
        fragBuilder->codeAppendf("vec4 %s;", outColor);
    }

    this->emitBlendCodeForDstRead(fragBuilder,
                                  uniformHandler,
                                  args.fInputColor,
                                  args.fInputCoverage,
                                  dstColor,
                                  outColor,
                                  args.fOutputSecondary,
                                  args.fXP);
    if (needsLocalOutColor) {
        fragBuilder->codeAppendf("%s = %s;", args.fOutputPrimary, outColor);
    }
}

void GrGLSLXferProcessor::setData(const GrGLSLProgramDataManager& pdm, const GrXferProcessor& xp) {
    if (xp.getDstTexture()) {
        if (fDstTopLeftUni.isValid()) {
            pdm.set2f(fDstTopLeftUni, static_cast<float>(xp.dstTextureOffset().fX),
                      static_cast<float>(xp.dstTextureOffset().fY));
            pdm.set2f(fDstScaleUni, 1.f / xp.getDstTexture()->width(),
                      1.f / xp.getDstTexture()->height());
        } else {
            SkASSERT(!fDstScaleUni.isValid());
        }
    } else {
        SkASSERT(!fDstTopLeftUni.isValid());
        SkASSERT(!fDstScaleUni.isValid());
    }
    this->onSetData(pdm, xp);
}

void GrGLSLXferProcessor::DefaultCoverageModulation(GrGLSLXPFragmentBuilder* fragBuilder,
                                                    const char* srcCoverage,
                                                    const char* dstColor,
                                                    const char* outColor,
                                                    const char* outColorSecondary,
                                                    const GrXferProcessor& proc) {
    if (proc.dstReadUsesMixedSamples()) {
        if (srcCoverage) {
            fragBuilder->codeAppendf("%s *= %s;", outColor, srcCoverage);
            fragBuilder->codeAppendf("%s = %s;", outColorSecondary, srcCoverage);
        } else {
            fragBuilder->codeAppendf("%s = vec4(1.0);", outColorSecondary);
        }
    } else if (srcCoverage) {
        fragBuilder->codeAppendf("%s = %s * %s + (vec4(1.0) - %s) * %s;",
                                 outColor, srcCoverage, outColor, srcCoverage, dstColor);
    }
}
