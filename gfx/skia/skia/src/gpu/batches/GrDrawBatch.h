/*
 * Copyright 2015 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#ifndef GrDrawBatch_DEFINED
#define GrDrawBatch_DEFINED

#include <functional>
#include "GrBatch.h"
#include "GrPipeline.h"

struct GrInitInvariantOutput;

/**
 * GrDrawBatches are flushed in two phases (preDraw, and draw). In preDraw uploads to GrGpuResources
 * and draws are determined and scheduled. They are issued in the draw phase. GrBatchToken is used
 * to sequence the uploads relative to each other and to draws.
 **/

class GrBatchDrawToken {
public:
    static GrBatchDrawToken AlreadyFlushedToken() { return GrBatchDrawToken(0); }

    GrBatchDrawToken(const GrBatchDrawToken& that) : fSequenceNumber(that.fSequenceNumber) {}
    GrBatchDrawToken& operator =(const GrBatchDrawToken& that) {
        fSequenceNumber = that.fSequenceNumber;
        return *this;
    }
    bool operator==(const GrBatchDrawToken& that) const {
        return fSequenceNumber == that.fSequenceNumber;
    }
    bool operator!=(const GrBatchDrawToken& that) const { return !(*this == that); }

private:
    GrBatchDrawToken();
    explicit GrBatchDrawToken(uint64_t sequenceNumber) : fSequenceNumber(sequenceNumber) {}
    friend class GrBatchFlushState;
    uint64_t fSequenceNumber;
};

/**
 * Base class for GrBatches that draw. These batches have a GrPipeline installed by GrDrawTarget.
 */
class GrDrawBatch : public GrBatch {
public:
    /** Method that performs an upload on behalf of a DeferredUploadFn. */
    using WritePixelsFn = std::function<bool(GrSurface* texture,
                                             int left, int top, int width, int height,
                                             GrPixelConfig config, const void* buffer,
                                             size_t rowBytes)>;
    /** See comments before GrDrawBatch::Target definition on how deferred uploaders work. */
    using DeferredUploadFn = std::function<void(WritePixelsFn&)>;

    class Target;

    GrDrawBatch(uint32_t classID);
    ~GrDrawBatch() override;

    /**
     * Fills in a structure informing the XP of overrides to its normal behavior.
     */
    void getPipelineOptimizations(GrPipelineOptimizations* override) const;

    const GrPipeline* pipeline() const {
        SkASSERT(fPipelineInstalled);
        return reinterpret_cast<const GrPipeline*>(fPipelineStorage.get());
    }

    bool installPipeline(const GrPipeline::CreateArgs&);

    // TODO no GrPrimitiveProcessors yet read fragment position
    bool willReadFragmentPosition() const { return false; }

    uint32_t renderTargetUniqueID() const final {
        SkASSERT(fPipelineInstalled);
        return this->pipeline()->getRenderTarget()->uniqueID();
    }

    GrRenderTarget* renderTarget() const final {
        SkASSERT(fPipelineInstalled);
        return this->pipeline()->getRenderTarget();
    }

    SkString dumpInfo() const override {
        SkString string;
        string.appendf("RT: %d\n", this->renderTargetUniqueID());
        string.append("ColorStages:\n");
        for (int i = 0; i < this->pipeline()->numColorFragmentProcessors(); i++) {
            string.appendf("\t\t%s\n\t\t%s\n",
                           this->pipeline()->getColorFragmentProcessor(i).name(),
                           this->pipeline()->getColorFragmentProcessor(i).dumpInfo().c_str());
        }
        string.append("CoverageStages:\n");
        for (int i = 0; i < this->pipeline()->numCoverageFragmentProcessors(); i++) {
            string.appendf("\t\t%s\n\t\t%s\n",
                           this->pipeline()->getCoverageFragmentProcessor(i).name(),
                           this->pipeline()->getCoverageFragmentProcessor(i).dumpInfo().c_str());
        }
        string.appendf("XP: %s\n", this->pipeline()->getXferProcessor().name());

        bool scissorEnabled = this->pipeline()->getScissorState().enabled();
        string.appendf("Scissor: ");
        if (scissorEnabled) {
            string.appendf("[L: %d, T: %d, R: %d, B: %d]\n",
                           this->pipeline()->getScissorState().rect().fLeft,
                           this->pipeline()->getScissorState().rect().fTop,
                           this->pipeline()->getScissorState().rect().fRight,
                           this->pipeline()->getScissorState().rect().fBottom);
        } else {
            string.appendf("<disabled>\n");
        }
        string.append(INHERITED::dumpInfo());

        return string;
    }

protected:
    virtual void computePipelineOptimizations(GrInitInvariantOutput* color,
                                              GrInitInvariantOutput* coverage,
                                              GrBatchToXPOverrides* overrides) const = 0;

private:
    /**
     * initBatchTracker is a hook for the some additional overrides / optimization possibilities
     * from the GrXferProcessor.
     */
    virtual void initBatchTracker(const GrXPOverridesForBatch&) = 0;

protected:
    struct QueuedUpload {
        QueuedUpload(DeferredUploadFn&& upload, GrBatchDrawToken token)
            : fUpload(std::move(upload))
            , fUploadBeforeToken(token) {}
        DeferredUploadFn    fUpload;
        GrBatchDrawToken    fUploadBeforeToken;
    };
    SkTArray<QueuedUpload>   fInlineUploads;

private:
    SkAlignedSTStorage<1, GrPipeline>               fPipelineStorage;
    bool                                            fPipelineInstalled;
    typedef GrBatch INHERITED;
};

#endif
