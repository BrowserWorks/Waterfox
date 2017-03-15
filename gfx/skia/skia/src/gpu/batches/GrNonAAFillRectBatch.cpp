/*
 * Copyright 2015 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "GrNonAAFillRectBatch.h"

#include "GrBatchFlushState.h"
#include "GrColor.h"
#include "GrDefaultGeoProcFactory.h"
#include "GrPrimitiveProcessor.h"
#include "GrResourceProvider.h"
#include "GrQuad.h"
#include "GrVertexBatch.h"

#include "SkMatrixPriv.h"

static const int kVertsPerInstance = 4;
static const int kIndicesPerInstance = 6;

/** We always use per-vertex colors so that rects can be batched across color changes. Sometimes
    we  have explicit local coords and sometimes not. We *could* always provide explicit local
    coords and just duplicate the positions when the caller hasn't provided a local coord rect,
    but we haven't seen a use case which frequently switches between local rect and no local
    rect draws.

    The vertex attrib order is always pos, color, [local coords].
 */
static sk_sp<GrGeometryProcessor> make_gp(bool readsCoverage) {
    using namespace GrDefaultGeoProcFactory;
    Color color(Color::kAttribute_Type);
    Coverage coverage(readsCoverage ? Coverage::kSolid_Type : Coverage::kNone_Type);

    LocalCoords localCoords(LocalCoords::kHasExplicit_Type);
    return GrDefaultGeoProcFactory::Make(color, coverage, localCoords, SkMatrix::I());
}

static void tesselate(intptr_t vertices,
                      size_t vertexStride,
                      GrColor color,
                      const SkMatrix* viewMatrix,
                      const SkRect& rect,
                      const GrQuad* localQuad) {
    SkPoint* positions = reinterpret_cast<SkPoint*>(vertices);

    positions->setRectFan(rect.fLeft, rect.fTop,
                          rect.fRight, rect.fBottom, vertexStride);

    if (viewMatrix) {
        SkMatrixPriv::MapPointsWithStride(*viewMatrix, positions, vertexStride, kVertsPerInstance);
    }

    // Setup local coords
    // TODO we should only do this if local coords are being read
    if (localQuad) {
        static const int kLocalOffset = sizeof(SkPoint) + sizeof(GrColor);
        for (int i = 0; i < kVertsPerInstance; i++) {
            SkPoint* coords = reinterpret_cast<SkPoint*>(vertices + kLocalOffset +
                              i * vertexStride);
            *coords = localQuad->point(i);
        }
    }

    static const int kColorOffset = sizeof(SkPoint);
    GrColor* vertColor = reinterpret_cast<GrColor*>(vertices + kColorOffset);
    for (int j = 0; j < 4; ++j) {
        *vertColor = color;
        vertColor = (GrColor*) ((intptr_t) vertColor + vertexStride);
    }
}

class NonAAFillRectBatch : public GrVertexBatch {
public:
    DEFINE_BATCH_CLASS_ID

    NonAAFillRectBatch(GrColor color, const SkMatrix& viewMatrix, const SkRect& rect,
                       const SkRect* localRect, const SkMatrix* localMatrix)
            : INHERITED(ClassID()) {
        SkASSERT(!viewMatrix.hasPerspective() && (!localMatrix ||
                                                  !localMatrix->hasPerspective()));
        RectInfo& info = fRects.push_back();
        info.fColor = color;
        info.fViewMatrix = viewMatrix;
        info.fRect = rect;
        if (localRect && localMatrix) {
            info.fLocalQuad.setFromMappedRect(*localRect, *localMatrix);
        } else if (localRect) {
            info.fLocalQuad.set(*localRect);
        } else if (localMatrix) {
            info.fLocalQuad.setFromMappedRect(rect, *localMatrix);
        } else {
            info.fLocalQuad.set(rect);
        }
        this->setTransformedBounds(fRects[0].fRect, viewMatrix, HasAABloat::kNo, IsZeroArea::kNo);
    }

    const char* name() const override { return "NonAAFillRectBatch"; }

    SkString dumpInfo() const override {
        SkString str;
        str.appendf("# batched: %d\n", fRects.count());
        for (int i = 0; i < fRects.count(); ++i) {
            const RectInfo& info = fRects[i];
            str.appendf("%d: Color: 0x%08x, Rect [L: %.2f, T: %.2f, R: %.2f, B: %.2f]\n",
                        i, info.fColor,
                        info.fRect.fLeft, info.fRect.fTop, info.fRect.fRight, info.fRect.fBottom);
        }
        str.append(INHERITED::dumpInfo());
        return str;
    }

    void computePipelineOptimizations(GrInitInvariantOutput* color,
                                      GrInitInvariantOutput* coverage,
                                      GrBatchToXPOverrides* overrides) const override {
        // When this is called on a batch, there is only one geometry bundle
        color->setKnownFourComponents(fRects[0].fColor);
        coverage->setKnownSingleComponent(0xff);
    }

    void initBatchTracker(const GrXPOverridesForBatch& overrides) override {
        overrides.getOverrideColorIfSet(&fRects[0].fColor);
        fOverrides = overrides;
    }

private:
    NonAAFillRectBatch() : INHERITED(ClassID()) {}

    void onPrepareDraws(Target* target) const override {
        sk_sp<GrGeometryProcessor> gp = make_gp(fOverrides.readsCoverage());
        if (!gp) {
            SkDebugf("Couldn't create GrGeometryProcessor\n");
            return;
        }
        SkASSERT(gp->getVertexStride() ==
                 sizeof(GrDefaultGeoProcFactory::PositionColorLocalCoordAttr));

        size_t vertexStride = gp->getVertexStride();
        int instanceCount = fRects.count();

        SkAutoTUnref<const GrBuffer> indexBuffer(target->resourceProvider()->refQuadIndexBuffer());
        InstancedHelper helper;
        void* vertices = helper.init(target, kTriangles_GrPrimitiveType, vertexStride,
                                     indexBuffer, kVertsPerInstance,
                                     kIndicesPerInstance, instanceCount);
        if (!vertices || !indexBuffer) {
            SkDebugf("Could not allocate vertices\n");
            return;
        }

        for (int i = 0; i < instanceCount; i++) {
            intptr_t verts = reinterpret_cast<intptr_t>(vertices) +
                             i * kVertsPerInstance * vertexStride;
            tesselate(verts, vertexStride, fRects[i].fColor, &fRects[i].fViewMatrix,
                      fRects[i].fRect, &fRects[i].fLocalQuad);
        }
        helper.recordDraw(target, gp.get());
    }

    bool onCombineIfPossible(GrBatch* t, const GrCaps& caps) override {
        NonAAFillRectBatch* that = t->cast<NonAAFillRectBatch>();
        if (!GrPipeline::CanCombine(*this->pipeline(), this->bounds(), *that->pipeline(),
                                    that->bounds(), caps)) {
            return false;
        }

        // In the event of two batches, one who can tweak, one who cannot, we just fall back to
        // not tweaking
        if (fOverrides.canTweakAlphaForCoverage() && !that->fOverrides.canTweakAlphaForCoverage()) {
            fOverrides = that->fOverrides;
        }

        fRects.push_back_n(that->fRects.count(), that->fRects.begin());
        this->joinBounds(*that);
        return true;
    }

    struct RectInfo {
        GrColor fColor;
        SkMatrix fViewMatrix;
        SkRect fRect;
        GrQuad fLocalQuad;
    };

    GrXPOverridesForBatch fOverrides;
    SkSTArray<1, RectInfo, true> fRects;

    typedef GrVertexBatch INHERITED;
};

namespace GrNonAAFillRectBatch {

GrDrawBatch* Create(GrColor color,
                    const SkMatrix& viewMatrix,
                    const SkRect& rect,
                    const SkRect* localRect,
                    const SkMatrix* localMatrix) {
    return new NonAAFillRectBatch(color, viewMatrix, rect, localRect, localMatrix);
}

};

///////////////////////////////////////////////////////////////////////////////////////////////////

#ifdef GR_TEST_UTILS

#include "GrBatchTest.h"

DRAW_BATCH_TEST_DEFINE(RectBatch) {
    GrColor color = GrRandomColor(random);
    SkRect rect = GrTest::TestRect(random);
    SkRect localRect = GrTest::TestRect(random);
    SkMatrix viewMatrix = GrTest::TestMatrixInvertible(random);
    SkMatrix localMatrix = GrTest::TestMatrix(random);

    bool hasLocalRect = random->nextBool();
    bool hasLocalMatrix = random->nextBool();
    return GrNonAAFillRectBatch::Create(color, viewMatrix, rect,
                                        hasLocalRect ? &localRect : nullptr,
                                        hasLocalMatrix ? &localMatrix : nullptr);
}

#endif
