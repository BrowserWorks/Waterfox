/*
 * Copyright 2015 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "glsl/GrGLSLProgramBuilder.h"

#include "GrPipeline.h"
#include "glsl/GrGLSLFragmentProcessor.h"
#include "glsl/GrGLSLGeometryProcessor.h"
#include "glsl/GrGLSLVarying.h"
#include "glsl/GrGLSLXferProcessor.h"

const int GrGLSLProgramBuilder::kVarsPerBlock = 8;

GrGLSLProgramBuilder::GrGLSLProgramBuilder(const GrPipeline& pipeline,
                                           const GrPrimitiveProcessor& primProc,
                                           const GrProgramDesc& desc)
    : fVS(this)
    , fGS(this)
    , fFS(this)
    , fStageIndex(-1)
    , fPipeline(pipeline)
    , fPrimProc(primProc)
    , fDesc(desc)
    , fGeometryProcessor(nullptr)
    , fXferProcessor(nullptr)
    , fNumVertexSamplers(0)
    , fNumGeometrySamplers(0)
    , fNumFragmentSamplers(0) {
}

void GrGLSLProgramBuilder::addFeature(GrShaderFlags shaders,
                                      uint32_t featureBit,
                                      const char* extensionName) {
    if (shaders & kVertex_GrShaderFlag) {
        fVS.addFeature(featureBit, extensionName);
    }
    if (shaders & kGeometry_GrShaderFlag) {
        SkASSERT(this->glslCaps()->geometryShaderSupport());
        fGS.addFeature(featureBit, extensionName);
    }
    if (shaders & kFragment_GrShaderFlag) {
        fFS.addFeature(featureBit, extensionName);
    }
}

bool GrGLSLProgramBuilder::emitAndInstallProcs(GrGLSLExpr4* inputColor,
                                               GrGLSLExpr4* inputCoverage) {
    // First we loop over all of the installed processors and collect coord transforms.  These will
    // be sent to the GrGLSLPrimitiveProcessor in its emitCode function
    const GrPrimitiveProcessor& primProc = this->primitiveProcessor();

    this->emitAndInstallPrimProc(primProc, inputColor, inputCoverage);

    this->emitAndInstallFragProcs(inputColor, inputCoverage);
    if (primProc.getPixelLocalStorageState() !=
        GrPixelLocalStorageState::kDraw_GrPixelLocalStorageState) {
        this->emitAndInstallXferProc(this->pipeline().getXferProcessor(), *inputColor,
                                     *inputCoverage, this->pipeline().ignoresCoverage(),
                                     primProc.getPixelLocalStorageState());
        this->emitFSOutputSwizzle(this->pipeline().getXferProcessor().hasSecondaryOutput());
    }

    return this->checkSamplerCounts();
}

void GrGLSLProgramBuilder::emitAndInstallPrimProc(const GrPrimitiveProcessor& proc,
                                                  GrGLSLExpr4* outputColor,
                                                  GrGLSLExpr4* outputCoverage) {
    // Program builders have a bit of state we need to clear with each effect
    AutoStageAdvance adv(this);
    this->nameExpression(outputColor, "outputColor");
    this->nameExpression(outputCoverage, "outputCoverage");

    const char* distanceVectorName = nullptr;
    if (this->fPipeline.usesDistanceVectorField() && proc.implementsDistanceVector()) {
        // Each individual user (FP) of the distance vector must be able to handle having this
        // variable be undeclared. There is no single default value that will yield a reasonable
        // result for all users.
        distanceVectorName = fFS.distanceVectorName();
        fFS.codeAppend( "// Normalized vector to the closest geometric edge (in device space)\n");
        fFS.codeAppend( "// Distance to the edge encoded in the z-component\n");
        fFS.codeAppendf("vec4 %s;", distanceVectorName);
    }

    // Enclose custom code in a block to avoid namespace conflicts
    SkString openBrace;
    openBrace.printf("{ // Stage %d, %s\n", fStageIndex, proc.name());
    fFS.codeAppend(openBrace.c_str());
    fVS.codeAppendf("// Primitive Processor %s\n", proc.name());

    SkASSERT(!fGeometryProcessor);
    fGeometryProcessor = proc.createGLSLInstance(*this->glslCaps());

    SkSTArray<4, SamplerHandle> texSamplers(proc.numTextures());
    SkSTArray<2, SamplerHandle> bufferSamplers(proc.numBuffers());
    this->emitSamplers(proc, &texSamplers, &bufferSamplers);

    GrGLSLPrimitiveProcessor::FPCoordTransformHandler transformHandler(fPipeline,
                                                                       &fTransformedCoordVars);
    GrGLSLGeometryProcessor::EmitArgs args(&fVS,
                                           &fFS,
                                           this->varyingHandler(),
                                           this->uniformHandler(),
                                           this->glslCaps(),
                                           proc,
                                           outputColor->c_str(),
                                           outputCoverage->c_str(),
                                           distanceVectorName,
                                           texSamplers.begin(),
                                           bufferSamplers.begin(),
                                           &transformHandler);
    fGeometryProcessor->emitCode(args);

    // We have to check that effects and the code they emit are consistent, ie if an effect
    // asks for dst color, then the emit code needs to follow suit
    SkDEBUGCODE(verify(proc);)

    fFS.codeAppend("}");
}

void GrGLSLProgramBuilder::emitAndInstallFragProcs(GrGLSLExpr4* color, GrGLSLExpr4* coverage) {
    int transformedCoordVarsIdx = 0;
    GrGLSLExpr4** inOut = &color;
    for (int i = 0; i < this->pipeline().numFragmentProcessors(); ++i) {
        if (i == this->pipeline().numColorFragmentProcessors()) {
            inOut = &coverage;
        }
        GrGLSLExpr4 output;
        const GrFragmentProcessor& fp = this->pipeline().getFragmentProcessor(i);
        this->emitAndInstallFragProc(fp, i, transformedCoordVarsIdx, **inOut, &output);
        GrFragmentProcessor::Iter iter(&fp);
        while (const GrFragmentProcessor* fp = iter.next()) {
            transformedCoordVarsIdx += fp->numCoordTransforms();
        }
        **inOut = output;
    }
}

// TODO Processors cannot output zeros because an empty string is all 1s
// the fix is to allow effects to take the GrGLSLExpr4 directly
void GrGLSLProgramBuilder::emitAndInstallFragProc(const GrFragmentProcessor& fp,
                                                  int index,
                                                  int transformedCoordVarsIdx,
                                                  const GrGLSLExpr4& input,
                                                  GrGLSLExpr4* output) {
    // Program builders have a bit of state we need to clear with each effect
    AutoStageAdvance adv(this);
    this->nameExpression(output, "output");

    // Enclose custom code in a block to avoid namespace conflicts
    SkString openBrace;
    openBrace.printf("{ // Stage %d, %s\n", fStageIndex, fp.name());
    fFS.codeAppend(openBrace.c_str());

    GrGLSLFragmentProcessor* fragProc = fp.createGLSLInstance();

    SkSTArray<4, SamplerHandle> textureSamplerArray(fp.numTextures());
    SkSTArray<2, SamplerHandle> bufferSamplerArray(fp.numBuffers());
    GrFragmentProcessor::Iter iter(&fp);
    while (const GrFragmentProcessor* subFP = iter.next()) {
        this->emitSamplers(*subFP, &textureSamplerArray, &bufferSamplerArray);
    }

    const GrShaderVar* coordVars = fTransformedCoordVars.begin() + transformedCoordVarsIdx;
    GrGLSLFragmentProcessor::TransformedCoordVars coords(&fp, coordVars);
    GrGLSLFragmentProcessor::TextureSamplers textureSamplers(&fp, textureSamplerArray.begin());
    GrGLSLFragmentProcessor::BufferSamplers bufferSamplers(&fp, bufferSamplerArray.begin());
    GrGLSLFragmentProcessor::EmitArgs args(&fFS,
                                           this->uniformHandler(),
                                           this->glslCaps(),
                                           fp,
                                           output->c_str(),
                                           input.isOnes() ? nullptr : input.c_str(),
                                           coords,
                                           textureSamplers,
                                           bufferSamplers,
                                           this->primitiveProcessor().implementsDistanceVector());

    fragProc->emitCode(args);

    // We have to check that effects and the code they emit are consistent, ie if an effect
    // asks for dst color, then the emit code needs to follow suit
    SkDEBUGCODE(verify(fp);)
    fFragmentProcessors.push_back(fragProc);

    fFS.codeAppend("}");
}

void GrGLSLProgramBuilder::emitAndInstallXferProc(const GrXferProcessor& xp,
                                                  const GrGLSLExpr4& colorIn,
                                                  const GrGLSLExpr4& coverageIn,
                                                  bool ignoresCoverage,
                                                  GrPixelLocalStorageState plsState) {
    // Program builders have a bit of state we need to clear with each effect
    AutoStageAdvance adv(this);

    SkASSERT(!fXferProcessor);
    fXferProcessor = xp.createGLSLInstance();

    // Enable dual source secondary output if we have one
    if (xp.hasSecondaryOutput()) {
        fFS.enableSecondaryOutput();
    }

    if (this->glslCaps()->mustDeclareFragmentShaderOutput()) {
        fFS.enableCustomOutput();
    }

    SkString openBrace;
    openBrace.printf("{ // Xfer Processor: %s\n", xp.name());
    fFS.codeAppend(openBrace.c_str());

    SkSTArray<4, SamplerHandle> texSamplers(xp.numTextures());
    SkSTArray<2, SamplerHandle> bufferSamplers(xp.numBuffers());
    this->emitSamplers(xp, &texSamplers, &bufferSamplers);

    bool usePLSDstRead = (plsState == GrPixelLocalStorageState::kFinish_GrPixelLocalStorageState);
    GrGLSLXferProcessor::EmitArgs args(&fFS,
                                       this->uniformHandler(),
                                       this->glslCaps(),
                                       xp, colorIn.c_str(),
                                       ignoresCoverage ? nullptr : coverageIn.c_str(),
                                       fFS.getPrimaryColorOutputName(),
                                       fFS.getSecondaryColorOutputName(),
                                       texSamplers.begin(),
                                       bufferSamplers.begin(),
                                       usePLSDstRead);
    fXferProcessor->emitCode(args);

    // We have to check that effects and the code they emit are consistent, ie if an effect
    // asks for dst color, then the emit code needs to follow suit
    SkDEBUGCODE(verify(xp);)
    fFS.codeAppend("}");
}

void GrGLSLProgramBuilder::emitSamplers(const GrProcessor& processor,
                                        SkTArray<SamplerHandle>* outTexSamplers,
                                        SkTArray<SamplerHandle>* outBufferSamplers) {
    SkString name;
    int numTextures = processor.numTextures();
    for (int t = 0; t < numTextures; ++t) {
        const GrTextureAccess& access = processor.textureAccess(t);
        GrSLType samplerType = access.getTexture()->samplerType();
        if (kTextureExternalSampler_GrSLType == samplerType) {
            const char* externalFeatureString = this->glslCaps()->externalTextureExtensionString();
            // We shouldn't ever create a GrGLTexture that requires external sampler type
            SkASSERT(externalFeatureString);
            this->addFeature(access.getVisibility(),
                             1 << GrGLSLShaderBuilder::kExternalTexture_GLSLPrivateFeature,
                             externalFeatureString);
        }
        name.printf("TextureSampler_%d", outTexSamplers->count());
        this->emitSampler(samplerType, access.getTexture()->config(),
                          name.c_str(), access.getVisibility(), outTexSamplers);
    }

    if (int numBuffers = processor.numBuffers()) {
        SkASSERT(this->glslCaps()->texelBufferSupport());
        GrShaderFlags texelBufferVisibility = kNone_GrShaderFlags;

        for (int b = 0; b < numBuffers; ++b) {
            const GrBufferAccess& access = processor.bufferAccess(b);
            name.printf("BufferSampler_%d", outBufferSamplers->count());
            this->emitSampler(kTextureBufferSampler_GrSLType, access.texelConfig(), name.c_str(),
                              access.visibility(), outBufferSamplers);
            texelBufferVisibility |= access.visibility();
        }

        if (const char* extension = this->glslCaps()->texelBufferExtensionString()) {
            this->addFeature(texelBufferVisibility,
                             1 << GrGLSLShaderBuilder::kTexelBuffer_GLSLPrivateFeature,
                             extension);
        }
    }
}

void GrGLSLProgramBuilder::emitSampler(GrSLType samplerType,
                                       GrPixelConfig config,
                                       const char* name,
                                       GrShaderFlags visibility,
                                       SkTArray<SamplerHandle>* outSamplers) {
    if (visibility & kVertex_GrShaderFlag) {
        ++fNumVertexSamplers;
    }
    if (visibility & kGeometry_GrShaderFlag) {
        SkASSERT(this->primitiveProcessor().willUseGeoShader());
        ++fNumGeometrySamplers;
    }
    if (visibility & kFragment_GrShaderFlag) {
        ++fNumFragmentSamplers;
    }
    GrSLPrecision precision = this->glslCaps()->samplerPrecision(config, visibility);
    SamplerHandle handle = this->uniformHandler()->addSampler(visibility,
                                                              config,
                                                              samplerType,
                                                              precision,
                                                              name);
    outSamplers->emplace_back(handle);
}

void GrGLSLProgramBuilder::emitFSOutputSwizzle(bool hasSecondaryOutput) {
    // Swizzle the fragment shader outputs if necessary.
    GrSwizzle swizzle;
    swizzle.setFromKey(this->desc().header().fOutputSwizzle);
    if (swizzle != GrSwizzle::RGBA()) {
        fFS.codeAppendf("%s = %s.%s;", fFS.getPrimaryColorOutputName(),
                        fFS.getPrimaryColorOutputName(),
                        swizzle.c_str());
        if (hasSecondaryOutput) {
            fFS.codeAppendf("%s = %s.%s;", fFS.getSecondaryColorOutputName(),
                            fFS.getSecondaryColorOutputName(),
                            swizzle.c_str());
        }
    }
}

bool GrGLSLProgramBuilder::checkSamplerCounts() {
    const GrGLSLCaps& glslCaps = *this->glslCaps();
    if (fNumVertexSamplers > glslCaps.maxVertexSamplers()) {
        GrCapsDebugf(this->caps(), "Program would use too many vertex samplers\n");
        return false;
    }
    if (fNumGeometrySamplers > glslCaps.maxGeometrySamplers()) {
        GrCapsDebugf(this->caps(), "Program would use too many geometry samplers\n");
        return false;
    }
    if (fNumFragmentSamplers > glslCaps.maxFragmentSamplers()) {
        GrCapsDebugf(this->caps(), "Program would use too many fragment samplers\n");
        return false;
    }
    // If the same sampler is used in two different shaders, it counts as two combined samplers.
    int numCombinedSamplers = fNumVertexSamplers + fNumGeometrySamplers + fNumFragmentSamplers;
    if (numCombinedSamplers > glslCaps.maxCombinedSamplers()) {
        GrCapsDebugf(this->caps(), "Program would use too many combined samplers\n");
        return false;
    }
    return true;
}

#ifdef SK_DEBUG
void GrGLSLProgramBuilder::verify(const GrPrimitiveProcessor& gp) {
    SkASSERT(fFS.usedProcessorFeatures() == gp.requiredFeatures());
}

void GrGLSLProgramBuilder::verify(const GrXferProcessor& xp) {
    SkASSERT(fFS.usedProcessorFeatures() == xp.requiredFeatures());
    SkASSERT(fFS.hasReadDstColor() == xp.willReadDstColor());
}

void GrGLSLProgramBuilder::verify(const GrFragmentProcessor& fp) {
    SkASSERT(fFS.usedProcessorFeatures() == fp.requiredFeatures());
}
#endif

void GrGLSLProgramBuilder::nameVariable(SkString* out, char prefix, const char* name, bool mangle) {
    if ('\0' == prefix) {
        *out = name;
    } else {
        out->printf("%c%s", prefix, name);
    }
    if (mangle) {
        if (out->endsWith('_')) {
            // Names containing "__" are reserved.
            out->append("x");
        }
        out->appendf("_Stage%d%s", fStageIndex, fFS.getMangleString().c_str());
    }
}

void GrGLSLProgramBuilder::nameExpression(GrGLSLExpr4* output, const char* baseName) {
    // create var to hold stage result.  If we already have a valid output name, just use that
    // otherwise create a new mangled one.  This name is only valid if we are reordering stages
    // and have to tell stage exactly where to put its output.
    SkString outName;
    if (output->isValid()) {
        outName = output->c_str();
    } else {
        this->nameVariable(&outName, '\0', baseName);
    }
    fFS.codeAppendf("vec4 %s;", outName.c_str());
    *output = outName;
}

void GrGLSLProgramBuilder::appendUniformDecls(GrShaderFlags visibility, SkString* out) const {
    this->uniformHandler()->appendUniformDecls(visibility, out);
}

const GrGLSLSampler& GrGLSLProgramBuilder::getSampler(SamplerHandle handle) const {
    return this->uniformHandler()->getSampler(handle);
}

void GrGLSLProgramBuilder::addRTAdjustmentUniform(GrSLPrecision precision,
                                                  const char* name,
                                                  const char** outName) {
        SkASSERT(!fUniformHandles.fRTAdjustmentUni.isValid());
        fUniformHandles.fRTAdjustmentUni =
            this->uniformHandler()->addUniform(kVertex_GrShaderFlag,
                                               kVec4f_GrSLType,
                                               precision,
                                               name,
                                               outName);
}

void GrGLSLProgramBuilder::addRTHeightUniform(const char* name, const char** outName) {
        SkASSERT(!fUniformHandles.fRTHeightUni.isValid());
        GrGLSLUniformHandler* uniformHandler = this->uniformHandler();
        fUniformHandles.fRTHeightUni =
            uniformHandler->internalAddUniformArray(kFragment_GrShaderFlag,
                                                    kFloat_GrSLType, kDefault_GrSLPrecision,
                                                    name, false, 0, outName);
}

void GrGLSLProgramBuilder::cleanupFragmentProcessors() {
    for (int i = 0; i < fFragmentProcessors.count(); ++i) {
        delete fFragmentProcessors[i];
    }
}

void GrGLSLProgramBuilder::finalizeShaders() {
    this->varyingHandler()->finalize();
    fVS.finalize(kVertex_GrShaderFlag);
    fFS.finalize(kFragment_GrShaderFlag);
}
