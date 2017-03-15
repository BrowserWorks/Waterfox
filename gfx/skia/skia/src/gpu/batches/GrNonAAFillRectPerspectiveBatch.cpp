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

static const int kVertsPerInstance = 4;
static const int kIndicesPerInstance = 6;

/** We always use per-vertex colors so that rects can be batched across color changes. Sometimes
    we  have explicit local coords and sometimes not. We *could* always provide explicit local
    coords and just duplicate the positions when the caller hasn't provided a local coord rect,
    but we haven't seen a use case which frequently switches between local rect and no local
    rect draws.

    The vertex attrib order is always pos, color, [local coords].
 */
static sk_sp<GrGeometryProcessor> make_persp_gp(const SkMatrix& viewMatrix,
                                                bool readsCoverage,
                                                bool hasExplicitLocalCoords,
                                                const SkMatrix* localMatrix) {
    SkASSERT(viewMatrix.hasPerspective() || (localMatrix && localMatrix->hasPerspective()));

    using namespace GrDefaultGeoProcFactory;
    Color color(Color::kAttribute_Type);
    Coverage coverage(readsCoverage ? Coverage::kSolid_Type : Coverage::kNone_Type);

    // If we have perspective on the viewMatrix then we won't map on the CPU, nor will we map
    // the local rect on the cpu (in case the localMatrix also has perspective).
    // Otherwise, if we have a local rect, then we apply the localMatrix directly to the localRect
    // to generate vertex local coords
    if (viewMatrix.hasPerspective()) {
        LocalCoords localCoords(hasExplicitLocalCoords ? LocalCoords::kHasExplicit_Type :
                                                         LocalCoords::kUsePosition_Type,
                                localMatrix);
        return GrDefaultGeoProcFactory::Make(color, coverage, localCoords, viewMatrix);
    } else if (hasExplicitLocalCoords) {
        LocalCoords localCoords(LocalCoords::kHasExplicit_Type, localMatrix);
        return GrDefaultGeoProcFactory::Make(color, coverage, localCoords, SkMatrix::I());
    } else {
        LocalCoords localCoords(LocalCoords::kUsePosition_Type, localMatrix);
        return GrDefaultGeoProcFactory::MakeForDeviceSpace(color, coverage, localCoords,
                                                           viewMatrix);
    }
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
        viewMatrix->mapPointsWithStride(positions, vertexStride, kVertsPerInstance);
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

// We handle perspective in the local matrix or viewmatrix with special batches
class GrNonAAFillRectPerspectiveBatch : public GrVertexBatch {
public:
    DEFINE_BATCH_CLASS_ID

    GrNonAAFillRectPerspectiveBatch(GrColor color, const SkMatrix& viewMatrix, const SkRect& rect,
                                    const SkRect* localRect, const SkMatrix* localMatrix)
            : INHERITED(ClassID())
            , fViewMatrix(viewMatrix) {
        SkASSERT(viewMatrix.hasPerspective() || (localMatrix &&
                                                 localMatrix->hasPerspective()));
        RectInfo& info = fRects.push_back();
        info.fColor = color;
        info.fRect = rect;
        fHasLocalRect = SkToBool(localRect);
        fHasLocalMatrix = SkToBool(localMatrix);
        if (fHasLocalMatrix) {
            fLocalMatrix = *localMatrix;
        }
        if (fHasLocalRect) {
            info.fLocalRect = *localRect;
        }
        this->setTransformedBounds(rect, viewMatrix, HasAABloat::kNo, IsZeroArea::kNo);
    }

    const char* name() const override { return "NonAAFillRectPerspectiveBatch"; }

    SkString dumpInfo() const override {
        SkString str;
        str.appendf("# batched: %d\n", fRects.count());
        for (int i = 0; i < fRects.count(); ++i) {
            const RectInfo& geo = fRects[0];
            str.appendf("%d: Color: 0x%08x, Rect [L: %.2f, T: %.2f, R: %.2f, B: %.2f]\n",
                        i, geo.fColor,
                        geo.fRect.fLeft, geo.fRect.fTop, geo.fRect.fRight, geo.fRect.fBottom);
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
    GrNonAAFillRectPerspectiveBatch() : INHERITED(ClassID()) {}

    void onPrepareDraws(Target* target) const override {
        sk_sp<GrGeometryProcessor> gp = make_persp_gp(fViewMatrix,
                                                      fOverrides.readsCoverage(),
                                                      fHasLocalRect,
                                                      fHasLocalMatrix ? &fLocalMatrix : nullptr);
        if (!gp) {
            SkDebugf("Couldn't create GrGeometryProcessor\n");
            return;
        }
        SkASSERT(fHasLocalRect
                     ? gp->getVertexStride() ==
                         sizeof(GrDefaultGeoProcFactory::PositionColorLocalCoordAttr)
                     : gp->getVertexStride() == sizeof(GrDefaultGeoProcFactory::PositionColorAttr));

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
            const RectInfo& info = fRects[i];
            intptr_t verts = reinterpret_cast<intptr_t>(vertices) +
                             i * kVertsPerInstance * vertexStride;
            if (fHasLocalRect) {
                GrQuad quad(info.fLocalRect);
                tesselate(verts, vertexStride, info.fColor, nullptr, info.fRect, &quad);
            } else {
                tesselate(verts, vertexStride, info.fColor, nullptr, info.fRect, nullptr);
            }
        }
        helper.recordDraw(target, gp.get());
    }

    bool onCombineIfPossible(GrBatch* t, const GrCaps& caps) override {
        GrNonAAFillRectPerspectiveBatch* that = t->cast<GrNonAAFillRectPerspectiveBatch>();
        if (!GrPipeline::CanCombine(*this->pipeline(), this->bounds(), *that->pipeline(),
                                    that->bounds(), caps)) {
            return false;
        }

        // We could batch across perspective vm changes if we really wanted to
        if (!fViewMatrix.cheapEqualTo(that->fViewMatrix)) {
            return false;
        }
        if (fHasLocalRect != that->fHasLocalRect) {
            return false;
        }
        if (fHasLocalMatrix && !fLocalMatrix.cheapEqualTo(that->fLocalMatrix)) {
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
        SkRect fRect;
        GrColor fColor;
        SkRect fLocalRect;
    };

    GrXPOverridesForBatch fOverrides;
    SkSTArray<1, RectInfo, true> fRects;
    bool fHasLocalMatrix;
    bool fHasLocalRect;
    SkMatrix fLocalMatrix;
    SkMatrix fViewMatrix;

    typedef GrVertexBatch INHERITED;
};

namespace GrNonAAFillRectBatch {

GrDrawBatch* CreateWithPerspective(GrColor color,
                                   const SkMatrix& viewMatrix,
                                   const SkRect& rect,
                                   const SkRect* localRect,
                                   const SkMatrix* localMatrix) {
    return new GrNonAAFillRectPerspectiveBatch(color, viewMatrix, rect, localRect, localMatrix);
}

};

///////////////////////////////////////////////////////////////////////////////////////////////////

#ifdef GR_TEST_UTILS

#include "GrBatchTest.h"

DRAW_BATCH_TEST_DEFINE(PerspRectBatch) {
    GrColor color = GrRandomColor(random);
    SkRect rect = GrTest::TestRect(random);
    SkRect localRect = GrTest::TestRect(random);
    SkMatrix viewMatrix = GrTest::TestMatrix(random);
    bool hasLocalMatrix = random->nextBool();
    SkMatrix localMatrix;
    if (!viewMatrix.hasPerspective()) {
        localMatrix = GrTest::TestMatrixPerspective(random);
        hasLocalMatrix = true;
    }

    bool hasLocalRect = random->nextBool();
    return GrNonAAFillRectBatch::CreateWithPerspective(color, viewMatrix, rect,
                                                       hasLocalRect ? &localRect : nullptr,
                                                       hasLocalMatrix ? &localMatrix : nullptr);
}

#endif
