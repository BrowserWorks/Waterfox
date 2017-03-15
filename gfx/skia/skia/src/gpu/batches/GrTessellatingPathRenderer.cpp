/*
 * Copyright 2015 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "GrTessellatingPathRenderer.h"

#include "GrAuditTrail.h"
#include "GrBatchFlushState.h"
#include "GrBatchTest.h"
#include "GrClip.h"
#include "GrDefaultGeoProcFactory.h"
#include "GrDrawTarget.h"
#include "GrMesh.h"
#include "GrPathUtils.h"
#include "GrPipelineBuilder.h"
#include "GrResourceCache.h"
#include "GrResourceProvider.h"
#include "GrTessellator.h"
#include "SkGeometry.h"

#include "batches/GrVertexBatch.h"

#include <stdio.h>

/*
 * This path renderer tessellates the path into triangles using GrTessellator, uploads the
 * triangles to a vertex buffer, and renders them with a single draw call. It can do screenspace
 * antialiasing with a one-pixel coverage ramp.
 */
namespace {

struct TessInfo {
    SkScalar  fTolerance;
    int       fCount;
};

// When the SkPathRef genID changes, invalidate a corresponding GrResource described by key.
class PathInvalidator : public SkPathRef::GenIDChangeListener {
public:
    explicit PathInvalidator(const GrUniqueKey& key) : fMsg(key) {}
private:
    GrUniqueKeyInvalidatedMessage fMsg;

    void onChange() override {
        SkMessageBus<GrUniqueKeyInvalidatedMessage>::Post(fMsg);
    }
};

bool cache_match(GrBuffer* vertexBuffer, SkScalar tol, int* actualCount) {
    if (!vertexBuffer) {
        return false;
    }
    const SkData* data = vertexBuffer->getUniqueKey().getCustomData();
    SkASSERT(data);
    const TessInfo* info = static_cast<const TessInfo*>(data->data());
    if (info->fTolerance == 0 || info->fTolerance < 3.0f * tol) {
        *actualCount = info->fCount;
        return true;
    }
    return false;
}

class StaticVertexAllocator : public GrTessellator::VertexAllocator {
public:
    StaticVertexAllocator(size_t stride, GrResourceProvider* resourceProvider, bool canMapVB)
      : VertexAllocator(stride)
      , fResourceProvider(resourceProvider)
      , fCanMapVB(canMapVB)
      , fVertices(nullptr) {
    }
    void* lock(int vertexCount) override {
        size_t size = vertexCount * stride();
        fVertexBuffer.reset(fResourceProvider->createBuffer(
            size, kVertex_GrBufferType, kStatic_GrAccessPattern, 0));
        if (!fVertexBuffer.get()) {
            return nullptr;
        }
        if (fCanMapVB) {
            fVertices = fVertexBuffer->map();
        } else {
            fVertices = sk_malloc_throw(vertexCount * stride());
        }
        return fVertices;
    }
    void unlock(int actualCount) override {
        if (fCanMapVB) {
            fVertexBuffer->unmap();
        } else {
            fVertexBuffer->updateData(fVertices, actualCount * stride());
            sk_free(fVertices);
        }
        fVertices = nullptr;
    }
    GrBuffer* vertexBuffer() { return fVertexBuffer.get(); }
private:
    SkAutoTUnref<GrBuffer> fVertexBuffer;
    GrResourceProvider* fResourceProvider;
    bool fCanMapVB;
    void* fVertices;
};

class DynamicVertexAllocator : public GrTessellator::VertexAllocator {
public:
    DynamicVertexAllocator(size_t stride, GrVertexBatch::Target* target)
      : VertexAllocator(stride)
      , fTarget(target)
      , fVertexBuffer(nullptr)
      , fVertices(nullptr) {
    }
    void* lock(int vertexCount) override {
        fVertexCount = vertexCount;
        fVertices = fTarget->makeVertexSpace(stride(), vertexCount, &fVertexBuffer, &fFirstVertex);
        return fVertices;
    }
    void unlock(int actualCount) override {
        fTarget->putBackVertices(fVertexCount - actualCount, stride());
        fVertices = nullptr;
    }
    const GrBuffer* vertexBuffer() const { return fVertexBuffer; }
    int firstVertex() const { return fFirstVertex; }
private:
    GrVertexBatch::Target* fTarget;
    const GrBuffer* fVertexBuffer;
    int fVertexCount;
    int fFirstVertex;
    void* fVertices;
};

}  // namespace

GrTessellatingPathRenderer::GrTessellatingPathRenderer() {
}

bool GrTessellatingPathRenderer::onCanDrawPath(const CanDrawPathArgs& args) const {
    // This path renderer can draw fill styles, and can do screenspace antialiasing via a
    // one-pixel coverage ramp. It can do convex and concave paths, but we'll leave the convex
    // ones to simpler algorithms. We pass on paths that have styles, though they may come back
    // around after applying the styling information to the geometry to create a filled path. In
    // the non-AA case, We skip paths thta don't have a key since the real advantage of this path
    // renderer comes from caching the tessellated geometry. In the AA case, we do not cache, so we
    // accept paths without keys.
    if (!args.fShape->style().isSimpleFill() || args.fShape->knownToBeConvex()) {
        return false;
    }
    if (args.fAntiAlias) {
#ifdef SK_DISABLE_SCREENSPACE_TESS_AA_PATH_RENDERER
        return false;
#else
        SkPath path;
        args.fShape->asPath(&path);
        if (path.countVerbs() > 10) {
            return false;
        }
#endif
    } else if (!args.fShape->hasUnstyledKey()) {
        return false;
    }
    return true;
}

class TessellatingPathBatch : public GrVertexBatch {
public:
    DEFINE_BATCH_CLASS_ID

    static GrDrawBatch* Create(const GrColor& color,
                               const GrShape& shape,
                               const SkMatrix& viewMatrix,
                               SkIRect devClipBounds,
                               bool antiAlias) {
        return new TessellatingPathBatch(color, shape, viewMatrix, devClipBounds, antiAlias);
    }

    const char* name() const override { return "TessellatingPathBatch"; }

    void computePipelineOptimizations(GrInitInvariantOutput* color,
                                      GrInitInvariantOutput* coverage,
                                      GrBatchToXPOverrides* overrides) const override {
        color->setKnownFourComponents(fColor);
        coverage->setUnknownSingleComponent();
    }

private:
    void initBatchTracker(const GrXPOverridesForBatch& overrides) override {
        // Handle any color overrides
        if (!overrides.readsColor()) {
            fColor = GrColor_ILLEGAL;
        }
        overrides.getOverrideColorIfSet(&fColor);
        fPipelineInfo = overrides;
    }

    SkPath getPath() const {
        SkASSERT(!fShape.style().applies());
        SkPath path;
        fShape.asPath(&path);
        return path;
    }

    void draw(Target* target, const GrGeometryProcessor* gp) const {
        SkASSERT(!fAntiAlias);
        GrResourceProvider* rp = target->resourceProvider();
        bool inverseFill = fShape.inverseFilled();
        // construct a cache key from the path's genID and the view matrix
        static const GrUniqueKey::Domain kDomain = GrUniqueKey::GenerateDomain();
        GrUniqueKey key;
        static constexpr int kClipBoundsCnt = sizeof(fDevClipBounds) / sizeof(uint32_t);
        int shapeKeyDataCnt = fShape.unstyledKeySize();
        SkASSERT(shapeKeyDataCnt >= 0);
        GrUniqueKey::Builder builder(&key, kDomain, shapeKeyDataCnt + kClipBoundsCnt);
        fShape.writeUnstyledKey(&builder[0]);
        // For inverse fills, the tessellation is dependent on clip bounds.
        if (inverseFill) {
            memcpy(&builder[shapeKeyDataCnt], &fDevClipBounds, sizeof(fDevClipBounds));
        } else {
            memset(&builder[shapeKeyDataCnt], 0, sizeof(fDevClipBounds));
        }
        builder.finish();
        SkAutoTUnref<GrBuffer> cachedVertexBuffer(rp->findAndRefTByUniqueKey<GrBuffer>(key));
        int actualCount;
        SkScalar tol = GrPathUtils::kDefaultTolerance;
        tol = GrPathUtils::scaleToleranceToSrc(tol, fViewMatrix, fShape.bounds());
        if (cache_match(cachedVertexBuffer.get(), tol, &actualCount)) {
            this->drawVertices(target, gp, cachedVertexBuffer.get(), 0, actualCount);
            return;
        }

        SkRect clipBounds = SkRect::Make(fDevClipBounds);

        SkMatrix vmi;
        if (!fViewMatrix.invert(&vmi)) {
            return;
        }
        vmi.mapRect(&clipBounds);
        bool isLinear;
        bool canMapVB = GrCaps::kNone_MapFlags != target->caps().mapBufferFlags();
        StaticVertexAllocator allocator(gp->getVertexStride(), rp, canMapVB);
        int count = GrTessellator::PathToTriangles(getPath(), tol, clipBounds, &allocator,
                                                   false, GrColor(), false, &isLinear);
        if (count == 0) {
            return;
        }
        this->drawVertices(target, gp, allocator.vertexBuffer(), 0, count);
        TessInfo info;
        info.fTolerance = isLinear ? 0 : tol;
        info.fCount = count;
        key.setCustomData(SkData::MakeWithCopy(&info, sizeof(info)));
        rp->assignUniqueKeyToResource(key, allocator.vertexBuffer());
    }

    void drawAA(Target* target, const GrGeometryProcessor* gp) const {
        SkASSERT(fAntiAlias);
        SkPath path = getPath();
        if (path.isEmpty()) {
            return;
        }
        SkRect clipBounds = SkRect::Make(fDevClipBounds);
        path.transform(fViewMatrix);
        SkScalar tol = GrPathUtils::kDefaultTolerance;
        bool isLinear;
        DynamicVertexAllocator allocator(gp->getVertexStride(), target);
        bool canTweakAlphaForCoverage = fPipelineInfo.canTweakAlphaForCoverage();
        int count = GrTessellator::PathToTriangles(path, tol, clipBounds, &allocator,
                                                   true, fColor, canTweakAlphaForCoverage,
                                                   &isLinear);
        if (count == 0) {
            return;
        }
        drawVertices(target, gp, allocator.vertexBuffer(), allocator.firstVertex(), count);
    }

    void onPrepareDraws(Target* target) const override {
        sk_sp<GrGeometryProcessor> gp;
        {
            using namespace GrDefaultGeoProcFactory;

            Color color(fColor);
            LocalCoords localCoords(fPipelineInfo.readsLocalCoords() ?
                                    LocalCoords::kUsePosition_Type :
                                    LocalCoords::kUnused_Type);
            Coverage::Type coverageType;
            if (fAntiAlias) {
                color = Color(Color::kAttribute_Type);
                if (fPipelineInfo.canTweakAlphaForCoverage()) {
                    coverageType = Coverage::kSolid_Type;
                } else {
                    coverageType = Coverage::kAttribute_Type;
                }
            } else if (fPipelineInfo.readsCoverage()) {
                coverageType = Coverage::kSolid_Type;
            } else {
                coverageType = Coverage::kNone_Type;
            }
            Coverage coverage(coverageType);
            if (fAntiAlias) {
                gp = GrDefaultGeoProcFactory::MakeForDeviceSpace(color, coverage, localCoords,
                                                                 fViewMatrix);
            } else {
                gp = GrDefaultGeoProcFactory::Make(color, coverage, localCoords, fViewMatrix);
            }
        }
        if (fAntiAlias) {
            this->drawAA(target, gp.get());
        } else {
            this->draw(target, gp.get());
        }
    }

    void drawVertices(Target* target, const GrGeometryProcessor* gp, const GrBuffer* vb,
                      int firstVertex, int count) const {
        GrPrimitiveType primitiveType = TESSELLATOR_WIREFRAME ? kLines_GrPrimitiveType
                                                              : kTriangles_GrPrimitiveType;
        GrMesh mesh;
        mesh.init(primitiveType, vb, firstVertex, count);
        target->draw(gp, mesh);
    }

    bool onCombineIfPossible(GrBatch*, const GrCaps&) override { return false; }

    TessellatingPathBatch(const GrColor& color,
                          const GrShape& shape,
                          const SkMatrix& viewMatrix,
                          const SkIRect& devClipBounds,
                          bool antiAlias)
      : INHERITED(ClassID())
      , fColor(color)
      , fShape(shape)
      , fViewMatrix(viewMatrix)
      , fDevClipBounds(devClipBounds)
      , fAntiAlias(antiAlias) {
        SkRect devBounds;
        viewMatrix.mapRect(&devBounds, shape.bounds());
        if (shape.inverseFilled()) {
            // Because the clip bounds are used to add a contour for inverse fills, they must also
            // include the path bounds.
            devBounds.join(SkRect::Make(fDevClipBounds));
        }
        this->setBounds(devBounds, HasAABloat::kNo, IsZeroArea::kNo);
    }

    GrColor                 fColor;
    GrShape                 fShape;
    SkMatrix                fViewMatrix;
    SkIRect                 fDevClipBounds;
    bool                    fAntiAlias;
    GrXPOverridesForBatch   fPipelineInfo;

    typedef GrVertexBatch INHERITED;
};

bool GrTessellatingPathRenderer::onDrawPath(const DrawPathArgs& args) {
    GR_AUDIT_TRAIL_AUTO_FRAME(args.fDrawContext->auditTrail(),
                              "GrTessellatingPathRenderer::onDrawPath");
    SkIRect clipBoundsI;
    args.fClip->getConservativeBounds(args.fDrawContext->width(), args.fDrawContext->height(),
                                      &clipBoundsI);
    SkAutoTUnref<GrDrawBatch> batch(TessellatingPathBatch::Create(args.fPaint->getColor(),
                                                                  *args.fShape,
                                                                  *args.fViewMatrix,
                                                                  clipBoundsI,
                                                                  args.fAntiAlias));

    GrPipelineBuilder pipelineBuilder(*args.fPaint, args.fDrawContext->mustUseHWAA(*args.fPaint));
    pipelineBuilder.setUserStencil(args.fUserStencilSettings);

    args.fDrawContext->drawBatch(pipelineBuilder, *args.fClip, batch);

    return true;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#ifdef GR_TEST_UTILS

DRAW_BATCH_TEST_DEFINE(TesselatingPathBatch) {
    GrColor color = GrRandomColor(random);
    SkMatrix viewMatrix = GrTest::TestMatrixInvertible(random);
    SkPath path = GrTest::TestPath(random);
    SkIRect devClipBounds = SkIRect::MakeLTRB(
        random->nextU(), random->nextU(), random->nextU(), random->nextU());
    devClipBounds.sort();
    bool antiAlias = random->nextBool();
    GrStyle style;
    do {
        GrTest::TestStyle(random, &style);
    } while (!style.isSimpleFill());
    GrShape shape(path, style);
    return TessellatingPathBatch::Create(color, shape, viewMatrix, devClipBounds, antiAlias);
}

#endif
