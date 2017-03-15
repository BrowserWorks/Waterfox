/*
 * Copyright 2016 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */
#include "GrProgramDesc.h"

#include "GrProcessor.h"
#include "GrPipeline.h"
#include "GrRenderTargetPriv.h"
#include "SkChecksum.h"
#include "glsl/GrGLSLFragmentProcessor.h"
#include "glsl/GrGLSLFragmentShaderBuilder.h"
#include "glsl/GrGLSLCaps.h"

static uint16_t sampler_key(GrSLType samplerType, GrPixelConfig config, GrShaderFlags visibility,
                            const GrGLSLCaps& caps) {
    enum {
        kFirstSamplerType = kTexture2DSampler_GrSLType,
        kLastSamplerType = kTextureBufferSampler_GrSLType,
        kSamplerTypeKeyBits = 4
    };
    GR_STATIC_ASSERT(kLastSamplerType - kFirstSamplerType < (1 << kSamplerTypeKeyBits));

    SkASSERT((int)samplerType >= kFirstSamplerType && (int)samplerType <= kLastSamplerType);
    int samplerTypeKey = samplerType - kFirstSamplerType;

    return SkToU16(caps.configTextureSwizzle(config).asKey() |
                   (samplerTypeKey << 8) |
                   (caps.samplerPrecision(config, visibility) << (8 + kSamplerTypeKeyBits)));
}

static void add_sampler_keys(GrProcessorKeyBuilder* b, const GrProcessor& proc,
                             const GrGLSLCaps& caps) {
    int numTextures = proc.numTextures();
    int numSamplers = numTextures + proc.numBuffers();
    // Need two bytes per key (swizzle, sampler type, and precision).
    int word32Count = (numSamplers + 1) / 2;
    if (0 == word32Count) {
        return;
    }
    uint16_t* k16 = SkTCast<uint16_t*>(b->add32n(word32Count));
    int i = 0;
    for (; i < numTextures; ++i) {
        const GrTextureAccess& access = proc.textureAccess(i);
        const GrTexture* tex = access.getTexture();
        k16[i] = sampler_key(tex->samplerType(), tex->config(), access.getVisibility(), caps);
    }
    for (; i < numSamplers; ++i) {
        const GrBufferAccess& access = proc.bufferAccess(i - numTextures);
        k16[i] = sampler_key(kTextureBufferSampler_GrSLType, access.texelConfig(),
                             access.visibility(), caps);
    }
    // zero the last 16 bits if the number of samplers is odd.
    if (numSamplers & 0x1) {
        k16[numSamplers] = 0;
    }
}

/**
 * A function which emits a meta key into the key builder.  This is required because shader code may
 * be dependent on properties of the effect that the effect itself doesn't use
 * in its key (e.g. the pixel format of textures used). So we create a meta-key for
 * every effect using this function. It is also responsible for inserting the effect's class ID
 * which must be different for every GrProcessor subclass. It can fail if an effect uses too many
 * transforms, etc, for the space allotted in the meta-key.  NOTE, both FPs and GPs share this
 * function because it is hairy, though FPs do not have attribs, and GPs do not have transforms
 */
static bool gen_meta_key(const GrProcessor& proc,
                         const GrGLSLCaps& glslCaps,
                         uint32_t transformKey,
                         GrProcessorKeyBuilder* b) {
    size_t processorKeySize = b->size();
    uint32_t classID = proc.classID();

    // Currently we allow 16 bits for the class id and the overall processor key size.
    static const uint32_t kMetaKeyInvalidMask = ~((uint32_t)SK_MaxU16);
    if ((processorKeySize | classID) & kMetaKeyInvalidMask) {
        return false;
    }

    add_sampler_keys(b, proc, glslCaps);

    uint32_t* key = b->add32n(2);
    key[0] = (classID << 16) | SkToU32(processorKeySize);
    key[1] = transformKey;
    return true;
}

static bool gen_frag_proc_and_meta_keys(const GrPrimitiveProcessor& primProc,
                                        const GrFragmentProcessor& fp,
                                        const GrGLSLCaps& glslCaps,
                                        GrProcessorKeyBuilder* b) {
    for (int i = 0; i < fp.numChildProcessors(); ++i) {
        if (!gen_frag_proc_and_meta_keys(primProc, fp.childProcessor(i), glslCaps, b)) {
            return false;
        }
    }

    fp.getGLSLProcessorKey(glslCaps, b);

    return gen_meta_key(fp, glslCaps, primProc.getTransformKey(fp.coordTransforms(),
                                                               fp.numCoordTransforms()), b);
}

bool GrProgramDesc::Build(GrProgramDesc* desc,
                          const GrPrimitiveProcessor& primProc,
                          bool hasPointSize,
                          const GrPipeline& pipeline,
                          const GrGLSLCaps& glslCaps) {
    // The descriptor is used as a cache key. Thus when a field of the
    // descriptor will not affect program generation (because of the attribute
    // bindings in use or other descriptor field settings) it should be set
    // to a canonical value to avoid duplicate programs with different keys.

    GR_STATIC_ASSERT(0 == kProcessorKeysOffset % sizeof(uint32_t));
    // Make room for everything up to the effect keys.
    desc->key().reset();
    desc->key().push_back_n(kProcessorKeysOffset);

    GrProcessorKeyBuilder b(&desc->key());

    primProc.getGLSLProcessorKey(glslCaps, &b);
    if (!gen_meta_key(primProc, glslCaps, 0, &b)) {
        desc->key().reset();
        return false;
    }
    GrProcessor::RequiredFeatures requiredFeatures = primProc.requiredFeatures();

    for (int i = 0; i < pipeline.numFragmentProcessors(); ++i) {
        const GrFragmentProcessor& fp = pipeline.getFragmentProcessor(i);
        if (!gen_frag_proc_and_meta_keys(primProc, fp, glslCaps, &b)) {
            desc->key().reset();
            return false;
        }
        requiredFeatures |= fp.requiredFeatures();
    }

    const GrXferProcessor& xp = pipeline.getXferProcessor();
    xp.getGLSLProcessorKey(glslCaps, &b);
    if (!gen_meta_key(xp, glslCaps, 0, &b)) {
        desc->key().reset();
        return false;
    }
    requiredFeatures |= xp.requiredFeatures();

    // --------DO NOT MOVE HEADER ABOVE THIS LINE--------------------------------------------------
    // Because header is a pointer into the dynamic array, we can't push any new data into the key
    // below here.
    KeyHeader* header = desc->atOffset<KeyHeader, kHeaderOffset>();

    // make sure any padding in the header is zeroed.
    memset(header, 0, kHeaderSize);

    GrRenderTarget* rt = pipeline.getRenderTarget();

    if (requiredFeatures & (GrProcessor::kFragmentPosition_RequiredFeature |
                            GrProcessor::kSampleLocations_RequiredFeature)) {
        header->fSurfaceOriginKey = GrGLSLFragmentShaderBuilder::KeyForSurfaceOrigin(rt->origin());
    } else {
        header->fSurfaceOriginKey = 0;
    }

    if (requiredFeatures & GrProcessor::kSampleLocations_RequiredFeature) {
        SkASSERT(pipeline.isHWAntialiasState());
        header->fSamplePatternKey =
            rt->renderTargetPriv().getMultisampleSpecs(pipeline.getStencil()).fUniqueID;
    } else {
        header->fSamplePatternKey = 0;
    }

    header->fOutputSwizzle = glslCaps.configOutputSwizzle(rt->config()).asKey();

    header->fIgnoresCoverage = pipeline.ignoresCoverage() ? 1 : 0;

    header->fSnapVerticesToPixelCenters = pipeline.snapVerticesToPixelCenters();
    header->fColorFragmentProcessorCnt = pipeline.numColorFragmentProcessors();
    header->fCoverageFragmentProcessorCnt = pipeline.numCoverageFragmentProcessors();
    // Fail if the client requested more processors than the key can fit.
    if (header->fColorFragmentProcessorCnt != pipeline.numColorFragmentProcessors() ||
        header->fCoverageFragmentProcessorCnt != pipeline.numCoverageFragmentProcessors()) {
        return false;
    }
    header->fHasPointSize = hasPointSize ? 1 : 0;
    return true;
}
