/*
 * Copyright 2015 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#ifndef GrPipeline_DEFINED
#define GrPipeline_DEFINED

#include "GrColor.h"
#include "GrFragmentProcessor.h"
#include "GrNonAtomicRef.h"
#include "GrPendingProgramElement.h"
#include "GrProcessorSet.h"
#include "GrProgramDesc.h"
#include "GrRect.h"
#include "GrRenderTargetProxy.h"
#include "GrScissorState.h"
#include "GrUserStencilSettings.h"
#include "GrWindowRectsState.h"
#include "SkMatrix.h"
#include "SkRefCnt.h"
#include "effects/GrCoverageSetOpXP.h"
#include "effects/GrDisableColorXP.h"
#include "effects/GrPorterDuffXferProcessor.h"
#include "effects/GrSimpleTextureEffect.h"

class GrAppliedClip;
class GrDeviceCoordTexture;
class GrOp;
class GrRenderTargetContext;

/**
 * This immutable object contains information needed to set build a shader program and set API
 * state for a draw. It is used along with a GrPrimitiveProcessor and a source of geometric
 * data (GrMesh or GrPath) to draw.
 */
class GrPipeline {
public:
    ///////////////////////////////////////////////////////////////////////////
    /// @name Creation

    enum Flags {
        /**
         * Perform HW anti-aliasing. This means either HW FSAA, if supported by the render target,
         * or smooth-line rendering if a line primitive is drawn and line smoothing is supported by
         * the 3D API.
         */
        kHWAntialias_Flag = 0x1,
        /**
         * Modifies the vertex shader so that vertices will be positioned at pixel centers.
         */
        kSnapVerticesToPixelCenters_Flag = 0x2,
        /** Disables conversion to sRGB from linear when writing to a sRGB destination. */
        kDisableOutputConversionToSRGB_Flag = 0x4,
        /** Allows conversion from sRGB to linear when reading from processor's sRGB texture. */
        kAllowSRGBInputs_Flag = 0x8,
    };

    static uint32_t SRGBFlagsFromPaint(const GrPaint& paint) {
        uint32_t flags = 0;
        if (paint.getAllowSRGBInputs()) {
            flags |= kAllowSRGBInputs_Flag;
        }
        if (paint.getDisableOutputConversionToSRGB()) {
            flags |= kDisableOutputConversionToSRGB_Flag;
        }
        return flags;
    }

    enum ScissorState : bool {
        kEnabled = true,
        kDisabled = false
    };

    struct InitArgs {
        uint32_t fFlags = 0;
        const GrUserStencilSettings* fUserStencil = &GrUserStencilSettings::kUnused;
        GrRenderTargetProxy* fProxy = nullptr;
        const GrCaps* fCaps = nullptr;
        GrResourceProvider* fResourceProvider = nullptr;
        GrXferProcessor::DstProxy fDstProxy;
    };

    /**
     *  Graphics state that can change dynamically without creating a new pipeline.
     **/
    struct DynamicState {
        // Overrides the scissor rectangle (if scissor is enabled in the pipeline).
        // TODO: eventually this should be the only way to specify a scissor rectangle, as is the
        // case with the simple constructor.
        SkIRect fScissorRect;
    };

    /**
     * Creates a simple pipeline with default settings and no processors. The provided blend mode
     * must be "Porter Duff" (<= kLastCoeffMode). If using ScissorState::kEnabled, the caller must
     * specify a scissor rectangle through the DynamicState struct.
     **/
    GrPipeline(GrRenderTargetProxy*, ScissorState, SkBlendMode);

    GrPipeline(const InitArgs&, GrProcessorSet&&, GrAppliedClip&&);

    GrPipeline(const GrPipeline&) = delete;
    GrPipeline& operator=(const GrPipeline&) = delete;

    /// @}

    ///////////////////////////////////////////////////////////////////////////
    /// @name GrFragmentProcessors

    // Make the renderTargetContext's GrOpList be dependent on any GrOpLists in this pipeline
    void addDependenciesTo(GrOpList* recipient, const GrCaps&) const;

    int numColorFragmentProcessors() const { return fNumColorProcessors; }
    int numCoverageFragmentProcessors() const {
        return fFragmentProcessors.count() - fNumColorProcessors;
    }
    int numFragmentProcessors() const { return fFragmentProcessors.count(); }

    const GrXferProcessor& getXferProcessor() const {
        if (fXferProcessor) {
            return *fXferProcessor.get();
        } else {
            // A null xp member means the common src-over case. GrXferProcessor's ref'ing
            // mechanism is not thread safe so we do not hold a ref on this global.
            return GrPorterDuffXPFactory::SimpleSrcOverXP();
        }
    }

    /**
     * If the GrXferProcessor uses a texture to access the dst color, then this returns that
     * texture and the offset to the dst contents within that texture.
     */
    GrTextureProxy* dstTextureProxy(SkIPoint* offset = nullptr) const {
        if (offset) {
            *offset = fDstTextureOffset;
        }
        return fDstTextureProxy.get();
    }

    GrTexture* peekDstTexture(SkIPoint* offset = nullptr) const {
        if (GrTextureProxy* dstProxy = this->dstTextureProxy(offset)) {
            return dstProxy->priv().peekTexture();
        }

        return nullptr;
    }

    const GrFragmentProcessor& getColorFragmentProcessor(int idx) const {
        SkASSERT(idx < this->numColorFragmentProcessors());
        return *fFragmentProcessors[idx].get();
    }

    const GrFragmentProcessor& getCoverageFragmentProcessor(int idx) const {
        SkASSERT(idx < this->numCoverageFragmentProcessors());
        return *fFragmentProcessors[fNumColorProcessors + idx].get();
    }

    const GrFragmentProcessor& getFragmentProcessor(int idx) const {
        return *fFragmentProcessors[idx].get();
    }

    /// @}

    /**
     * Retrieves the currently set render-target.
     *
     * @return    The currently set render target.
     */
    GrRenderTargetProxy* proxy() const { return fProxy.get(); }
    GrRenderTarget* renderTarget() const { return fProxy.get()->priv().peekRenderTarget(); }

    const GrUserStencilSettings* getUserStencil() const { return fUserStencilSettings; }

    const GrScissorState& getScissorState() const { return fScissorState; }

    const GrWindowRectsState& getWindowRectsState() const { return fWindowRectsState; }

    bool isHWAntialiasState() const { return SkToBool(fFlags & kHWAntialias_Flag); }
    bool snapVerticesToPixelCenters() const {
        return SkToBool(fFlags & kSnapVerticesToPixelCenters_Flag);
    }
    bool getDisableOutputConversionToSRGB() const {
        return SkToBool(fFlags & kDisableOutputConversionToSRGB_Flag);
    }
    bool getAllowSRGBInputs() const {
        return SkToBool(fFlags & kAllowSRGBInputs_Flag);
    }
    bool hasStencilClip() const {
        return SkToBool(fFlags & kHasStencilClip_Flag);
    }
    bool isStencilEnabled() const {
        return SkToBool(fFlags & kStencilEnabled_Flag);
    }
    bool isBad() const { return SkToBool(fFlags & kIsBad_Flag); }

    GrXferBarrierType xferBarrierType(const GrCaps& caps) const;

    static SkString DumpFlags(uint32_t flags) {
        if (flags) {
            SkString result;
            if (flags & GrPipeline::kSnapVerticesToPixelCenters_Flag) {
                result.append("Snap vertices to pixel center.\n");
            }
            if (flags & GrPipeline::kHWAntialias_Flag) {
                result.append("HW Antialiasing enabled.\n");
            }
            if (flags & GrPipeline::kDisableOutputConversionToSRGB_Flag) {
                result.append("Disable output conversion to sRGB.\n");
            }
            if (flags & GrPipeline::kAllowSRGBInputs_Flag) {
                result.append("Allow sRGB Inputs.\n");
            }
            return result;
        }
        return SkString("No pipeline flags\n");
    }

private:
    void markAsBad() { fFlags |= kIsBad_Flag; }

    /** This is a continuation of the public "Flags" enum. */
    enum PrivateFlags {
        kHasStencilClip_Flag = 0x10,
        kStencilEnabled_Flag = 0x20,
        kIsBad_Flag = 0x40,
    };

    using RenderTargetProxy = GrPendingIOResource<GrRenderTargetProxy, kWrite_GrIOType>;
    using DstTextureProxy = GrPendingIOResource<GrTextureProxy, kRead_GrIOType>;
    using FragmentProcessorArray = SkAutoSTArray<8, std::unique_ptr<const GrFragmentProcessor>>;

    DstTextureProxy fDstTextureProxy;
    SkIPoint fDstTextureOffset;
    // MDB TODO: do we still need the destination proxy here?
    RenderTargetProxy fProxy;
    GrScissorState fScissorState;
    GrWindowRectsState fWindowRectsState;
    const GrUserStencilSettings* fUserStencilSettings;
    uint16_t fFlags;
    sk_sp<const GrXferProcessor> fXferProcessor;
    FragmentProcessorArray fFragmentProcessors;

    // This value is also the index in fFragmentProcessors where coverage processors begin.
    int fNumColorProcessors;

    typedef SkRefCnt INHERITED;
};

#endif
