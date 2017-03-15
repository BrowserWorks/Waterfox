
/*
 * Copyright 2013 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */
#ifndef GrCaps_DEFINED
#define GrCaps_DEFINED

#include "GrTypes.h"
#include "GrTypesPriv.h"
#include "GrBlend.h"
#include "GrShaderVar.h"
#include "SkRefCnt.h"
#include "SkString.h"

struct GrContextOptions;

class GrShaderCaps : public SkRefCnt {
public:
    /** Info about shader variable precision within a given shader stage. That is, this info
        is relevant to a float (or vecNf) variable declared with a GrSLPrecision
        in a given GrShaderType. The info here is hoisted from the OpenGL spec. */
    struct PrecisionInfo {
        PrecisionInfo() {
            fLogRangeLow = 0;
            fLogRangeHigh = 0;
            fBits = 0;
        }

        /** Is this precision level allowed in the shader stage? */
        bool supported() const { return 0 != fBits; }

        bool operator==(const PrecisionInfo& that) const {
            return fLogRangeLow == that.fLogRangeLow && fLogRangeHigh == that.fLogRangeHigh &&
                   fBits == that.fBits;
        }
        bool operator!=(const PrecisionInfo& that) const { return !(*this == that); }

        /** floor(log2(|min_value|)) */
        int fLogRangeLow;
        /** floor(log2(|max_value|)) */
        int fLogRangeHigh;
        /** Number of bits of precision. As defined in OpenGL (with names modified to reflect this
            struct) :
            """
            If the smallest representable value greater than 1 is 1 + e, then fBits will
            contain floor(log2(e)), and every value in the range [2^fLogRangeLow,
            2^fLogRangeHigh] can be represented to at least one part in 2^fBits.
            """
          */
        int fBits;
    };

    GrShaderCaps();

    virtual SkString dump() const;

    bool shaderDerivativeSupport() const { return fShaderDerivativeSupport; }
    bool geometryShaderSupport() const { return fGeometryShaderSupport; }
    bool pathRenderingSupport() const { return fPathRenderingSupport; }
    bool dstReadInShaderSupport() const { return fDstReadInShaderSupport; }
    bool dualSourceBlendingSupport() const { return fDualSourceBlendingSupport; }
    bool integerSupport() const { return fIntegerSupport; }
    bool texelBufferSupport() const { return fTexelBufferSupport; }

    /**
    * Get the precision info for a variable of type kFloat_GrSLType, kVec2f_GrSLType, etc in a
    * given shader type. If the shader type is not supported or the precision level is not
    * supported in that shader type then the returned struct will report false when supported() is
    * called.
    */
    const PrecisionInfo& getFloatShaderPrecisionInfo(GrShaderType shaderType,
                                                     GrSLPrecision precision) const {
        return fFloatPrecisions[shaderType][precision];
    }

    /**
    * Is there any difference between the float shader variable precision types? If this is true
    * then unless the shader type is not supported, any call to getFloatShaderPrecisionInfo() would
    * report the same info for all precisions in all shader types.
    */
    bool floatPrecisionVaries() const { return fShaderPrecisionVaries; }

    /**
     * PLS storage size in bytes (0 when not supported). The PLS spec defines a minimum size of 16
     * bytes whenever PLS is supported.
     */
    int pixelLocalStorageSize() const { return fPixelLocalStorageSize; }

    /**
     * True if this context supports the necessary extensions and features to enable the PLS path
     * renderer.
     */
    bool plsPathRenderingSupport() const {
#if GR_ENABLE_PLS_PATH_RENDERING
        return fPLSPathRenderingSupport;
#else
        return false;
#endif
    }

protected:
    /** Subclasses must call this after initialization in order to apply caps overrides requested by
        the client. Note that overrides will only reduce the caps never expand them. */
    void applyOptionsOverrides(const GrContextOptions& options);

    bool fShaderDerivativeSupport : 1;
    bool fGeometryShaderSupport : 1;
    bool fPathRenderingSupport : 1;
    bool fDstReadInShaderSupport : 1;
    bool fDualSourceBlendingSupport : 1;
    bool fIntegerSupport : 1;
    bool fTexelBufferSupport : 1;

    bool fShaderPrecisionVaries;
    PrecisionInfo fFloatPrecisions[kGrShaderTypeCount][kGrSLPrecisionCount];
    int fPixelLocalStorageSize;
    bool fPLSPathRenderingSupport;

private:
    virtual void onApplyOptionsOverrides(const GrContextOptions&) {}
    typedef SkRefCnt INHERITED;
};

/**
 * Represents the capabilities of a GrContext.
 */
class GrCaps : public SkRefCnt {
public:
    GrCaps(const GrContextOptions&);

    virtual SkString dump() const;

    GrShaderCaps* shaderCaps() const { return fShaderCaps; }

    bool npotTextureTileSupport() const { return fNPOTTextureTileSupport; }
    /** To avoid as-yet-unnecessary complexity we don't allow any partial support of MIP Maps (e.g.
        only for POT textures) */
    bool mipMapSupport() const { return fMipMapSupport; }

    /**
     * Skia convention is that a device only has sRGB support if it supports sRGB formats for both
     * textures and framebuffers. In addition:
     *   Decoding to linear of an sRGB texture can be disabled.
     */
    bool srgbSupport() const { return fSRGBSupport; }
    /**
     * Is there support for enabling/disabling sRGB writes for sRGB-capable color buffers?
     */
    bool srgbWriteControl() const { return fSRGBWriteControl; }
    bool twoSidedStencilSupport() const { return fTwoSidedStencilSupport; }
    bool stencilWrapOpsSupport() const { return  fStencilWrapOpsSupport; }
    bool discardRenderTargetSupport() const { return fDiscardRenderTargetSupport; }
    bool gpuTracingSupport() const { return fGpuTracingSupport; }
    bool compressedTexSubImageSupport() const { return fCompressedTexSubImageSupport; }
    bool oversizedStencilSupport() const { return fOversizedStencilSupport; }
    bool textureBarrierSupport() const { return fTextureBarrierSupport; }
    bool sampleLocationsSupport() const { return fSampleLocationsSupport; }
    bool multisampleDisableSupport() const { return fMultisampleDisableSupport; }
    bool usesMixedSamples() const { return fUsesMixedSamples; }
    bool preferClientSideDynamicBuffers() const { return fPreferClientSideDynamicBuffers; }

    bool useDrawInsteadOfClear() const { return fUseDrawInsteadOfClear; }
    bool useDrawInsteadOfPartialRenderTargetWrite() const {
        return fUseDrawInsteadOfPartialRenderTargetWrite;
    }

    bool useDrawInsteadOfAllRenderTargetWrites() const {
        return fUseDrawInsteadOfAllRenderTargetWrites;
    }

    bool preferVRAMUseOverFlushes() const { return fPreferVRAMUseOverFlushes; }

    /**
     * Indicates the level of support for gr_instanced::* functionality. A higher level includes
     * all functionality from the levels below it.
     */
    enum class InstancedSupport {
        kNone,
        kBasic,
        kMultisampled,
        kMixedSampled
    };

    InstancedSupport instancedSupport() const { return fInstancedSupport; }

    bool avoidInstancedDrawsToFPTargets() const { return fAvoidInstancedDrawsToFPTargets; }

    /**
     * Indicates the capabilities of the fixed function blend unit.
     */
    enum BlendEquationSupport {
        kBasic_BlendEquationSupport,             //<! Support to select the operator that
                                                 //   combines src and dst terms.
        kAdvanced_BlendEquationSupport,          //<! Additional fixed function support for specific
                                                 //   SVG/PDF blend modes. Requires blend barriers.
        kAdvancedCoherent_BlendEquationSupport,  //<! Advanced blend equation support that does not
                                                 //   require blend barriers, and permits overlap.

        kLast_BlendEquationSupport = kAdvancedCoherent_BlendEquationSupport
    };

    BlendEquationSupport blendEquationSupport() const { return fBlendEquationSupport; }

    bool advancedBlendEquationSupport() const {
        return fBlendEquationSupport >= kAdvanced_BlendEquationSupport;
    }

    bool advancedCoherentBlendEquationSupport() const {
        return kAdvancedCoherent_BlendEquationSupport == fBlendEquationSupport;
    }

    bool canUseAdvancedBlendEquation(GrBlendEquation equation) const {
        SkASSERT(GrBlendEquationIsAdvanced(equation));
        return SkToBool(fAdvBlendEqBlacklist & (1 << equation));
    }

    /**
     * Indicates whether GPU->CPU memory mapping for GPU resources such as vertex buffers and
     * textures allows partial mappings or full mappings.
     */
    enum MapFlags {
        kNone_MapFlags   = 0x0,       //<! Cannot map the resource.

        kCanMap_MapFlag  = 0x1,       //<! The resource can be mapped. Must be set for any of
                                      //   the other flags to have meaning.k
        kSubset_MapFlag  = 0x2,       //<! The resource can be partially mapped.
    };

    uint32_t mapBufferFlags() const { return fMapBufferFlags; }

    // Scratch textures not being reused means that those scratch textures
    // that we upload to (i.e., don't have a render target) will not be
    // recycled in the texture cache. This is to prevent ghosting by drivers
    // (in particular for deferred architectures).
    bool reuseScratchTextures() const { return fReuseScratchTextures; }
    bool reuseScratchBuffers() const { return fReuseScratchBuffers; }

    /// maximum number of attribute values per vertex
    int maxVertexAttributes() const { return fMaxVertexAttributes; }

    int maxRenderTargetSize() const { return fMaxRenderTargetSize; }
    int maxTextureSize() const { return fMaxTextureSize; }
    /** This is the maximum tile size to use by GPU devices for rendering sw-backed images/bitmaps.
        It is usually the max texture size, unless we're overriding it for testing. */
    int maxTileSize() const { SkASSERT(fMaxTileSize <= fMaxTextureSize); return fMaxTileSize; }

    // Will be 0 if MSAA is not supported
    int maxColorSampleCount() const { return fMaxColorSampleCount; }
    // Will be 0 if MSAA is not supported
    int maxStencilSampleCount() const { return fMaxStencilSampleCount; }
    // Will be 0 if raster multisample is not supported. Raster multisample is a special HW mode
    // where the rasterizer runs with more samples than are in the target framebuffer.
    int maxRasterSamples() const { return fMaxRasterSamples; }
    // We require the sample count to be less than maxColorSampleCount and maxStencilSampleCount.
    // If we are using mixed samples, we only care about stencil.
    int maxSampleCount() const {
        if (this->usesMixedSamples()) {
            return this->maxStencilSampleCount();
        } else {
            return SkTMin(this->maxColorSampleCount(), this->maxStencilSampleCount());
        }
    }

    int maxWindowRectangles() const { return fMaxWindowRectangles; }

    virtual bool isConfigTexturable(GrPixelConfig config) const = 0;
    virtual bool isConfigRenderable(GrPixelConfig config, bool withMSAA) const = 0;

    bool suppressPrints() const { return fSuppressPrints; }

    bool immediateFlush() const { return fImmediateFlush; }

    size_t bufferMapThreshold() const {
        SkASSERT(fBufferMapThreshold >= 0);
        return fBufferMapThreshold;
    }

    bool fullClearIsFree() const { return fFullClearIsFree; }

    /** True in environments that will issue errors if memory uploaded to buffers
        is not initialized (even if not read by draw calls). */
    bool mustClearUploadedBufferData() const { return fMustClearUploadedBufferData; }

    bool sampleShadingSupport() const { return fSampleShadingSupport; }

    bool fenceSyncSupport() const { return fFenceSyncSupport; }

protected:
    /** Subclasses must call this at the end of their constructors in order to apply caps
        overrides requested by the client. Note that overrides will only reduce the caps never
        expand them. */
    void applyOptionsOverrides(const GrContextOptions& options);

    SkAutoTUnref<GrShaderCaps>    fShaderCaps;

    bool fNPOTTextureTileSupport                     : 1;
    bool fMipMapSupport                              : 1;
    bool fSRGBSupport                                : 1;
    bool fSRGBWriteControl                           : 1;
    bool fTwoSidedStencilSupport                     : 1;
    bool fStencilWrapOpsSupport                      : 1;
    bool fDiscardRenderTargetSupport                 : 1;
    bool fReuseScratchTextures                       : 1;
    bool fReuseScratchBuffers                        : 1;
    bool fGpuTracingSupport                          : 1;
    bool fCompressedTexSubImageSupport               : 1;
    bool fOversizedStencilSupport                    : 1;
    bool fTextureBarrierSupport                      : 1;
    bool fSampleLocationsSupport                     : 1;
    bool fMultisampleDisableSupport                  : 1;
    bool fUsesMixedSamples                           : 1;
    bool fPreferClientSideDynamicBuffers             : 1;
    bool fFullClearIsFree                            : 1;
    bool fMustClearUploadedBufferData                : 1;

    // Driver workaround
    bool fUseDrawInsteadOfClear                      : 1;
    bool fUseDrawInsteadOfPartialRenderTargetWrite   : 1;
    bool fUseDrawInsteadOfAllRenderTargetWrites      : 1;
    bool fAvoidInstancedDrawsToFPTargets             : 1;

    // ANGLE workaround
    bool fPreferVRAMUseOverFlushes                   : 1;

    bool fSampleShadingSupport                       : 1;
    // TODO: this may need to be an enum to support different fence types
    bool fFenceSyncSupport                           : 1;

    InstancedSupport fInstancedSupport;

    BlendEquationSupport fBlendEquationSupport;
    uint32_t fAdvBlendEqBlacklist;
    GR_STATIC_ASSERT(kLast_GrBlendEquation < 32);

    uint32_t fMapBufferFlags;
    int fBufferMapThreshold;

    int fMaxRenderTargetSize;
    int fMaxVertexAttributes;
    int fMaxTextureSize;
    int fMaxTileSize;
    int fMaxColorSampleCount;
    int fMaxStencilSampleCount;
    int fMaxRasterSamples;
    int fMaxWindowRectangles;

private:
    virtual void onApplyOptionsOverrides(const GrContextOptions&) {}

    bool fSuppressPrints : 1;
    bool fImmediateFlush: 1;

    typedef SkRefCnt INHERITED;
};

#endif
