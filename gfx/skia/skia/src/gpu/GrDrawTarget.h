/*
 * Copyright 2010 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#ifndef GrDrawTarget_DEFINED
#define GrDrawTarget_DEFINED

#include "GrClip.h"
#include "GrContext.h"
#include "GrPathProcessor.h"
#include "GrPrimitiveProcessor.h"
#include "GrPathRendering.h"
#include "GrXferProcessor.h"

#include "batches/GrDrawBatch.h"

#include "SkClipStack.h"
#include "SkMatrix.h"
#include "SkPath.h"
#include "SkStringUtils.h"
#include "SkStrokeRec.h"
#include "SkTArray.h"
#include "SkTLazy.h"
#include "SkTypes.h"
#include "SkXfermode.h"

//#define ENABLE_MDB 1

class GrAuditTrail;
class GrBatch;
class GrClearBatch;
class GrClip;
class GrCaps;
class GrPath;
class GrDrawPathBatchBase;
class GrPipelineBuilder;

class GrDrawTarget final : public SkRefCnt {
public:
    /** Options for GrDrawTarget behavior. */
    struct Options {
        Options ()
            : fClipBatchToBounds(false)
            , fDrawBatchBounds(false)
            , fMaxBatchLookback(-1)
            , fMaxBatchLookahead(-1) {}
        bool fClipBatchToBounds;
        bool fDrawBatchBounds;
        int  fMaxBatchLookback;
        int  fMaxBatchLookahead;
    };

    GrDrawTarget(GrRenderTarget*, GrGpu*, GrResourceProvider*, GrAuditTrail*, const Options&);

    ~GrDrawTarget() override;

    void makeClosed() {
        fLastFullClearBatch = nullptr;
        // We only close drawTargets When MDB is enabled. When MDB is disabled there is only
        // ever one drawTarget and all calls will be funnelled into it.
#ifdef ENABLE_MDB
        this->setFlag(kClosed_Flag);
#endif
        this->forwardCombine();
    }

    bool isClosed() const { return this->isSetFlag(kClosed_Flag); }

    // TODO: this entry point is only needed in the non-MDB world. Remove when
    // we make the switch to MDB
    void clearRT() { fRenderTarget = nullptr; }

    /*
     * Notify this drawTarget that it relies on the contents of 'dependedOn'
     */
    void addDependency(GrSurface* dependedOn);

    /*
     * Does this drawTarget depend on 'dependedOn'?
     */
    bool dependsOn(GrDrawTarget* dependedOn) const {
        return fDependencies.find(dependedOn) >= 0;
    }

    /*
     * Dump out the drawTarget dependency DAG
     */
    SkDEBUGCODE(void dump() const;)

    /**
     * Empties the draw buffer of any queued up draws.
     */
    void reset();

    /**
     * Together these two functions flush all queued up draws to GrCommandBuffer. The return value
     * of drawBatches() indicates whether any commands were actually issued to the GPU.
     */
    void prepareBatches(GrBatchFlushState* flushState);
    bool drawBatches(GrBatchFlushState* flushState);

    /**
     * Gets the capabilities of the draw target.
     */
    const GrCaps* caps() const { return fGpu->caps(); }

    void drawBatch(const GrPipelineBuilder&, GrDrawContext*, const GrClip&, GrDrawBatch*);

    void addBatch(sk_sp<GrBatch>);

    /**
     * Draws the path into user stencil bits. Upon return, all user stencil values
     * inside the path will be nonzero. The path's fill must be either even/odd or
     * winding (notnverse or hairline).It will respect the HW antialias boolean (if
     * possible in the 3D API).  Note, we will never have an inverse fill with
     * stencil path.
     */
    void stencilPath(GrDrawContext*,
                     const GrClip&,
                     bool useHWAA,
                     const SkMatrix& viewMatrix,
                     const GrPath*);

    /** Clears the entire render target */
    void fullClear(GrRenderTarget*, GrColor color);

    /** Discards the contents render target. */
    void discard(GrRenderTarget*);

    /**
     * Copies a pixel rectangle from one surface to another. This call may finalize
     * reserved vertex/index data (as though a draw call was made). The src pixels
     * copied are specified by srcRect. They are copied to a rect of the same
     * size in dst with top left at dstPoint. If the src rect is clipped by the
     * src bounds then  pixel values in the dst rect corresponding to area clipped
     * by the src rect are not overwritten. This method is not guaranteed to succeed
     * depending on the type of surface, configs, etc, and the backend-specific
     * limitations.
     */
    bool copySurface(GrSurface* dst,
                     GrSurface* src,
                     const SkIRect& srcRect,
                     const SkIPoint& dstPoint);

    gr_instanced::InstancedRendering* instancedRendering() const {
        SkASSERT(fInstancedRendering);
        return fInstancedRendering;
    }

private:
    friend class GrDrawingManager; // for resetFlag & TopoSortTraits
    friend class GrDrawContextPriv; // for clearStencilClip

    enum Flags {
        kClosed_Flag    = 0x01,   //!< This drawTarget can't accept any more batches

        kWasOutput_Flag = 0x02,   //!< Flag for topological sorting
        kTempMark_Flag  = 0x04,   //!< Flag for topological sorting
    };

    void setFlag(uint32_t flag) {
        fFlags |= flag;
    }

    void resetFlag(uint32_t flag) {
        fFlags &= ~flag;
    }

    bool isSetFlag(uint32_t flag) const {
        return SkToBool(fFlags & flag);
    }

    struct TopoSortTraits {
        static void Output(GrDrawTarget* dt, int /* index */) {
            dt->setFlag(GrDrawTarget::kWasOutput_Flag);
        }
        static bool WasOutput(const GrDrawTarget* dt) {
            return dt->isSetFlag(GrDrawTarget::kWasOutput_Flag);
        }
        static void SetTempMark(GrDrawTarget* dt) {
            dt->setFlag(GrDrawTarget::kTempMark_Flag);
        }
        static void ResetTempMark(GrDrawTarget* dt) {
            dt->resetFlag(GrDrawTarget::kTempMark_Flag);
        }
        static bool IsTempMarked(const GrDrawTarget* dt) {
            return dt->isSetFlag(GrDrawTarget::kTempMark_Flag);
        }
        static int NumDependencies(const GrDrawTarget* dt) {
            return dt->fDependencies.count();
        }
        static GrDrawTarget* Dependency(GrDrawTarget* dt, int index) {
            return dt->fDependencies[index];
        }
    };

    // Returns the batch that the input batch was combined with or the input batch if it wasn't
    // combined.
    GrBatch* recordBatch(GrBatch*, const SkRect& clippedBounds);
    void forwardCombine();

    // Makes a copy of the dst if it is necessary for the draw. Returns false if a copy is required
    // but couldn't be made. Otherwise, returns true.  This method needs to be protected because it
    // needs to be accessed by GLPrograms to setup a correct drawstate
    bool setupDstReadIfNecessary(const GrPipelineBuilder&,
                                 GrRenderTarget*,
                                 const GrClip&,
                                 const GrPipelineOptimizations& optimizations,
                                 GrXferProcessor::DstTexture*,
                                 const SkRect& batchBounds);

    void addDependency(GrDrawTarget* dependedOn);

    // Used only by drawContextPriv.
    void clearStencilClip(const GrFixedClip&, bool insideStencilMask, GrRenderTarget*);

    struct RecordedBatch {
        sk_sp<GrBatch> fBatch;
        SkRect         fClippedBounds;
    };
    SkSTArray<256, RecordedBatch, true>             fRecordedBatches;
    GrClearBatch*                                   fLastFullClearBatch;
    // The context is only in service of the GrClip, remove once it doesn't need this.
    GrContext*                                      fContext;
    GrGpu*                                          fGpu;
    GrResourceProvider*                             fResourceProvider;
    GrAuditTrail*                                   fAuditTrail;

    SkDEBUGCODE(int                                 fDebugID;)
    uint32_t                                        fFlags;

    // 'this' drawTarget relies on the output of the drawTargets in 'fDependencies'
    SkTDArray<GrDrawTarget*>                        fDependencies;
    GrRenderTarget*                                 fRenderTarget;

    bool                                            fClipBatchToBounds;
    bool                                            fDrawBatchBounds;
    int                                             fMaxBatchLookback;
    int                                             fMaxBatchLookahead;

    SkAutoTDelete<gr_instanced::InstancedRendering> fInstancedRendering;

    typedef SkRefCnt INHERITED;
};

#endif
