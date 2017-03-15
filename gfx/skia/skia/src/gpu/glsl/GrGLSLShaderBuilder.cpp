/*
 * Copyright 2014 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "GrSwizzle.h"
#include "glsl/GrGLSLShaderBuilder.h"
#include "glsl/GrGLSLCaps.h"
#include "glsl/GrGLSLColorSpaceXformHelper.h"
#include "glsl/GrGLSLShaderVar.h"
#include "glsl/GrGLSLSampler.h"
#include "glsl/GrGLSLProgramBuilder.h"

GrGLSLShaderBuilder::GrGLSLShaderBuilder(GrGLSLProgramBuilder* program)
    : fProgramBuilder(program)
    , fInputs(GrGLSLProgramBuilder::kVarsPerBlock)
    , fOutputs(GrGLSLProgramBuilder::kVarsPerBlock)
    , fFeaturesAddedMask(0)
    , fCodeIndex(kCode)
    , fFinalized(false) {
    // We push back some dummy pointers which will later become our header
    for (int i = 0; i <= kCode; i++) {
        fShaderStrings.push_back();
        fCompilerStrings.push_back(nullptr);
        fCompilerStringLengths.push_back(0);
    }

    this->main() = "void main() {";
}

void GrGLSLShaderBuilder::declAppend(const GrGLSLShaderVar& var) {
    SkString tempDecl;
    var.appendDecl(fProgramBuilder->glslCaps(), &tempDecl);
    this->codeAppendf("%s;", tempDecl.c_str());
}

void GrGLSLShaderBuilder::appendPrecisionModifier(GrSLPrecision precision) {
    if (fProgramBuilder->glslCaps()->usesPrecisionModifiers()) {
        this->codeAppendf("%s ", GrGLSLPrecisionString(precision));
    }
}

void GrGLSLShaderBuilder::emitFunction(GrSLType returnType,
                                       const char* name,
                                       int argCnt,
                                       const GrGLSLShaderVar* args,
                                       const char* body,
                                       SkString* outName) {
    this->functions().append(GrGLSLTypeString(returnType));
    fProgramBuilder->nameVariable(outName, '\0', name);
    this->functions().appendf(" %s", outName->c_str());
    this->functions().append("(");
    for (int i = 0; i < argCnt; ++i) {
        args[i].appendDecl(fProgramBuilder->glslCaps(), &this->functions());
        if (i < argCnt - 1) {
            this->functions().append(", ");
        }
    }
    this->functions().append(") {\n");
    this->functions().append(body);
    this->functions().append("}\n\n");
}

void GrGLSLShaderBuilder::appendTextureLookup(SkString* out,
                                              SamplerHandle samplerHandle,
                                              const char* coordName,
                                              GrSLType varyingType) const {
    const GrGLSLCaps* glslCaps = fProgramBuilder->glslCaps();
    const GrGLSLSampler& sampler = fProgramBuilder->getSampler(samplerHandle);
    GrSLType samplerType = sampler.type();
    if (samplerType == kTexture2DRectSampler_GrSLType) {
        if (varyingType == kVec2f_GrSLType) {
            out->appendf("%s(%s, textureSize(%s) * %s)",
                         GrGLSLTexture2DFunctionName(varyingType, samplerType,
                                                     glslCaps->generation()),
                         sampler.getSamplerNameForTexture2D(),
                         sampler.getSamplerNameForTexture2D(),
                         coordName);
        } else {
            out->appendf("%s(%s, vec3(textureSize(%s) * %s.xy, %s.z))",
                         GrGLSLTexture2DFunctionName(varyingType, samplerType,
                                                     glslCaps->generation()),
                         sampler.getSamplerNameForTexture2D(),
                         sampler.getSamplerNameForTexture2D(),
                         coordName,
                         coordName);
        }
    } else {
        out->appendf("%s(%s, %s)",
                     GrGLSLTexture2DFunctionName(varyingType, samplerType, glslCaps->generation()),
                     sampler.getSamplerNameForTexture2D(),
                     coordName);
    }

    this->appendTextureSwizzle(out, sampler.config());
}

void GrGLSLShaderBuilder::appendTextureLookup(SamplerHandle samplerHandle,
                                              const char* coordName,
                                              GrSLType varyingType,
                                              GrGLSLColorSpaceXformHelper* colorXformHelper) {
    if (colorXformHelper && colorXformHelper->getXformMatrix()) {
        // With a color gamut transform, we need to wrap the lookup in another function call
        SkString lookup;
        this->appendTextureLookup(&lookup, samplerHandle, coordName, varyingType);
        this->appendColorGamutXform(lookup.c_str(), colorXformHelper);
    } else {
        this->appendTextureLookup(&this->code(), samplerHandle, coordName, varyingType);
    }
}

void GrGLSLShaderBuilder::appendTextureLookupAndModulate(
                                                    const char* modulation,
                                                    SamplerHandle samplerHandle,
                                                    const char* coordName,
                                                    GrSLType varyingType,
                                                    GrGLSLColorSpaceXformHelper* colorXformHelper) {
    SkString lookup;
    this->appendTextureLookup(&lookup, samplerHandle, coordName, varyingType);
    if (colorXformHelper && colorXformHelper->getXformMatrix()) {
        SkString xform;
        this->appendColorGamutXform(&xform, lookup.c_str(), colorXformHelper);
        this->codeAppend((GrGLSLExpr4(modulation) * GrGLSLExpr4(xform)).c_str());
    } else {
        this->codeAppend((GrGLSLExpr4(modulation) * GrGLSLExpr4(lookup)).c_str());
    }
}

void GrGLSLShaderBuilder::appendColorGamutXform(SkString* out,
                                                const char* srcColor,
                                                GrGLSLColorSpaceXformHelper* colorXformHelper) {
    // Our color is (r, g, b, a), but we want to multiply (r, g, b, 1) by our matrix, then
    // re-insert the original alpha. The supplied srcColor is likely to be of the form
    // "texture(...)", and we don't want to evaluate that twice, so wrap everything in a function.
    static const GrGLSLShaderVar gColorGamutXformArgs[] = {
        GrGLSLShaderVar("color", kVec4f_GrSLType),
        GrGLSLShaderVar("xform", kMat44f_GrSLType),
    };
    SkString functionBody;
    // Gamut xform, clamp to destination gamut
    functionBody.append("\tcolor.rgb = clamp((xform * vec4(color.rgb, 1.0)).rgb, 0.0, 1.0);\n");
    functionBody.append("\treturn color;");
    SkString colorGamutXformFuncName;
    this->emitFunction(kVec4f_GrSLType,
                       "colorGamutXform",
                       SK_ARRAY_COUNT(gColorGamutXformArgs),
                       gColorGamutXformArgs,
                       functionBody.c_str(),
                       &colorGamutXformFuncName);

    out->appendf("%s(%s, %s)", colorGamutXformFuncName.c_str(), srcColor,
                 colorXformHelper->getXformMatrix());
}

void GrGLSLShaderBuilder::appendColorGamutXform(const char* srcColor,
                                                GrGLSLColorSpaceXformHelper* colorXformHelper) {
    SkString xform;
    this->appendColorGamutXform(&xform, srcColor, colorXformHelper);
    this->codeAppend(xform.c_str());
}

void GrGLSLShaderBuilder::appendTexelFetch(SkString* out,
                                           SamplerHandle samplerHandle,
                                           const char* coordExpr) const {
    const GrGLSLSampler& sampler = fProgramBuilder->getSampler(samplerHandle);
    SkASSERT(fProgramBuilder->glslCaps()->texelFetchSupport());
    SkASSERT(GrSLTypeIsCombinedSamplerType(sampler.type()));

    out->appendf("texelFetch(%s, %s)", sampler.getSamplerNameForTexelFetch(), coordExpr);

    this->appendTextureSwizzle(out, sampler.config());
}

void GrGLSLShaderBuilder::appendTexelFetch(SamplerHandle samplerHandle, const char* coordExpr) {
    this->appendTexelFetch(&this->code(), samplerHandle, coordExpr);
}

void GrGLSLShaderBuilder::appendTextureSwizzle(SkString* out, GrPixelConfig config) const {
    const GrSwizzle& configSwizzle = fProgramBuilder->glslCaps()->configTextureSwizzle(config);

    if (configSwizzle != GrSwizzle::RGBA()) {
        out->appendf(".%s", configSwizzle.c_str());
    }
}

bool GrGLSLShaderBuilder::addFeature(uint32_t featureBit, const char* extensionName) {
    if (featureBit & fFeaturesAddedMask) {
        return false;
    }
    this->extensions().appendf("#extension %s: require\n", extensionName);
    fFeaturesAddedMask |= featureBit;
    return true;
}

void GrGLSLShaderBuilder::appendDecls(const VarArray& vars, SkString* out) const {
    for (int i = 0; i < vars.count(); ++i) {
        vars[i].appendDecl(fProgramBuilder->glslCaps(), out);
        out->append(";\n");
    }
}

void GrGLSLShaderBuilder::addLayoutQualifier(const char* param, InterfaceQualifier interface) {
    SkASSERT(fProgramBuilder->glslCaps()->generation() >= k330_GrGLSLGeneration ||
             fProgramBuilder->glslCaps()->mustEnableAdvBlendEqs());
    fLayoutParams[interface].push_back() = param;
}

void GrGLSLShaderBuilder::compileAndAppendLayoutQualifiers() {
    static const char* interfaceQualifierNames[] = {
        "out"
    };

    for (int interface = 0; interface <= kLastInterfaceQualifier; ++interface) {
        const SkTArray<SkString>& params = fLayoutParams[interface];
        if (params.empty()) {
            continue;
        }
        this->layoutQualifiers().appendf("layout(%s", params[0].c_str());
        for (int i = 1; i < params.count(); ++i) {
            this->layoutQualifiers().appendf(", %s", params[i].c_str());
        }
        this->layoutQualifiers().appendf(") %s;\n", interfaceQualifierNames[interface]);
    }

    GR_STATIC_ASSERT(0 == GrGLSLShaderBuilder::kOut_InterfaceQualifier);
    GR_STATIC_ASSERT(SK_ARRAY_COUNT(interfaceQualifierNames) == kLastInterfaceQualifier + 1);
}

void GrGLSLShaderBuilder::finalize(uint32_t visibility) {
    SkASSERT(!fFinalized);
    this->versionDecl() = fProgramBuilder->glslCaps()->versionDeclString();
    this->compileAndAppendLayoutQualifiers();
    SkASSERT(visibility);
    fProgramBuilder->appendUniformDecls((GrShaderFlags) visibility, &this->uniforms());
    this->appendDecls(fInputs, &this->inputs());
    this->appendDecls(fOutputs, &this->outputs());
    this->onFinalize();
    // append the 'footer' to code
    this->code().append("}");

    for (int i = 0; i <= fCodeIndex; i++) {
        fCompilerStrings[i] = fShaderStrings[i].c_str();
        fCompilerStringLengths[i] = (int)fShaderStrings[i].size();
    }

    fFinalized = true;
}
