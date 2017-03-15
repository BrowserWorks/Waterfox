/*
 * Copyright 2011 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "SkGpuDevice.h"

#include "GrBlurUtils.h"
#include "GrContext.h"
#include "GrDrawContextPriv.h"
#include "GrGpu.h"
#include "GrImageIDTextureAdjuster.h"
#include "GrStyle.h"
#include "GrTracing.h"

#include "SkCanvasPriv.h"
#include "SkDraw.h"
#include "SkErrorInternals.h"
#include "SkGlyphCache.h"
#include "SkGr.h"
#include "SkGrPriv.h"
#include "SkImage_Base.h"
#include "SkImageCacherator.h"
#include "SkImageFilter.h"
#include "SkImageFilterCache.h"
#include "SkLatticeIter.h"
#include "SkMaskFilter.h"
#include "SkPathEffect.h"
#include "SkPicture.h"
#include "SkPictureData.h"
#include "SkRasterClip.h"
#include "SkRRect.h"
#include "SkRecord.h"
#include "SkSpecialImage.h"
#include "SkStroke.h"
#include "SkSurface.h"
#include "SkSurface_Gpu.h"
#include "SkTLazy.h"
#include "SkUtils.h"
#include "SkVertState.h"
#include "SkXfermode.h"
#include "batches/GrRectBatchFactory.h"
#include "effects/GrBicubicEffect.h"
#include "effects/GrDashingEffect.h"
#include "effects/GrSimpleTextureEffect.h"
#include "effects/GrTextureDomain.h"
#include "text/GrTextUtils.h"

#if SK_SUPPORT_GPU

#define ASSERT_SINGLE_OWNER \
    SkDEBUGCODE(GrSingleOwner::AutoEnforce debug_SingleOwner(fContext->debugSingleOwner());)

#if 0
    extern bool (*gShouldDrawProc)();
    #define CHECK_SHOULD_DRAW(draw)                             \
        do {                                                    \
            if (gShouldDrawProc && !gShouldDrawProc()) return;  \
            this->prepareDraw(draw);                            \
        } while (0)
#else
    #define CHECK_SHOULD_DRAW(draw) this->prepareDraw(draw)
#endif

///////////////////////////////////////////////////////////////////////////////

/** Checks that the alpha type is legal and gets constructor flags. Returns false if device creation
    should fail. */
bool SkGpuDevice::CheckAlphaTypeAndGetFlags(
                        const SkImageInfo* info, SkGpuDevice::InitContents init, unsigned* flags) {
    *flags = 0;
    if (info) {
        switch (info->alphaType()) {
            case kPremul_SkAlphaType:
                break;
            case kOpaque_SkAlphaType:
                *flags |= SkGpuDevice::kIsOpaque_Flag;
                break;
            default: // If it is unpremul or unknown don't try to render
                return false;
        }
    }
    if (kClear_InitContents == init) {
        *flags |= kNeedClear_Flag;
    }
    return true;
}

sk_sp<SkGpuDevice> SkGpuDevice::Make(sk_sp<GrDrawContext> drawContext,
                                     int width, int height,
                                     InitContents init) {
    if (!drawContext || drawContext->wasAbandoned()) {
        return nullptr;
    }
    unsigned flags;
    if (!CheckAlphaTypeAndGetFlags(nullptr, init, &flags)) {
        return nullptr;
    }
    return sk_sp<SkGpuDevice>(new SkGpuDevice(std::move(drawContext), width, height, flags));
}

sk_sp<SkGpuDevice> SkGpuDevice::Make(GrContext* context, SkBudgeted budgeted,
                                     const SkImageInfo& info, int sampleCount,
                                     GrSurfaceOrigin origin,
                                     const SkSurfaceProps* props, InitContents init) {
    unsigned flags;
    if (!CheckAlphaTypeAndGetFlags(&info, init, &flags)) {
        return nullptr;
    }

    sk_sp<GrDrawContext> drawContext(MakeDrawContext(context, budgeted, info,
                                                     sampleCount, origin, props));
    if (!drawContext) {
        return nullptr;
    }

    return sk_sp<SkGpuDevice>(new SkGpuDevice(std::move(drawContext),
                                              info.width(), info.height(), flags));
}

static SkImageInfo make_info(GrDrawContext* context, int w, int h, bool opaque) {
    SkColorType colorType;
    if (!GrPixelConfigToColorType(context->config(), &colorType)) {
        colorType = kUnknown_SkColorType;
    }
    return SkImageInfo::Make(w, h, colorType,
                             opaque ? kOpaque_SkAlphaType : kPremul_SkAlphaType,
                             sk_ref_sp(context->getColorSpace()));
}

SkGpuDevice::SkGpuDevice(sk_sp<GrDrawContext> drawContext, int width, int height, unsigned flags)
    : INHERITED(make_info(drawContext.get(), width, height, SkToBool(flags & kIsOpaque_Flag)),
                drawContext->surfaceProps())
    , fContext(SkRef(drawContext->accessRenderTarget()->getContext()))
    , fDrawContext(std::move(drawContext))
{
    fSize.set(width, height);
    fOpaque = SkToBool(flags & kIsOpaque_Flag);

    if (flags & kNeedClear_Flag) {
        this->clearAll();
    }
}

sk_sp<GrDrawContext> SkGpuDevice::MakeDrawContext(GrContext* context,
                                                  SkBudgeted budgeted,
                                                  const SkImageInfo& origInfo,
                                                  int sampleCount,
                                                  GrSurfaceOrigin origin,
                                                  const SkSurfaceProps* surfaceProps) {
    if (kUnknown_SkColorType == origInfo.colorType() ||
        origInfo.width() < 0 || origInfo.height() < 0) {
        return nullptr;
    }

    if (!context) {
        return nullptr;
    }

    SkColorType ct = origInfo.colorType();
    SkAlphaType at = origInfo.alphaType();
    SkColorSpace* cs = origInfo.colorSpace();
    if (kRGB_565_SkColorType == ct || kGray_8_SkColorType == ct) {
        at = kOpaque_SkAlphaType;  // force this setting
    }
    if (kOpaque_SkAlphaType != at) {
        at = kPremul_SkAlphaType;  // force this setting
    }

    GrPixelConfig config = SkImageInfo2GrPixelConfig(ct, at, cs, *context->caps());

    return context->makeDrawContext(SkBackingFit::kExact,               // Why exact?
                                    origInfo.width(), origInfo.height(),
                                    config, sk_ref_sp(cs), sampleCount,
                                    origin, surfaceProps, budgeted);
}

sk_sp<SkSpecialImage> SkGpuDevice::filterTexture(const SkDraw& draw,
                                                 SkSpecialImage* srcImg,
                                                 int left, int top,
                                                 SkIPoint* offset,
                                                 const SkImageFilter* filter) {
    SkASSERT(srcImg->isTextureBacked());
    SkASSERT(filter);

    SkMatrix matrix = *draw.fMatrix;
    matrix.postTranslate(SkIntToScalar(-left), SkIntToScalar(-top));
    const SkIRect clipBounds = draw.fRC->getBounds().makeOffset(-left, -top);
    SkAutoTUnref<SkImageFilterCache> cache(this->getImageFilterCache());
    SkImageFilter::OutputProperties outputProperties(fDrawContext->getColorSpace());
    SkImageFilter::Context ctx(matrix, clipBounds, cache.get(), outputProperties);

    return filter->filterImage(srcImg, ctx, offset);
}

///////////////////////////////////////////////////////////////////////////////

bool SkGpuDevice::onReadPixels(const SkImageInfo& dstInfo, void* dstPixels, size_t dstRowBytes,
                               int x, int y) {
    ASSERT_SINGLE_OWNER

    return fDrawContext->readPixels(dstInfo, dstPixels, dstRowBytes, x, y);
}

bool SkGpuDevice::onWritePixels(const SkImageInfo& srcInfo, const void* srcPixels,
                                size_t srcRowBytes, int x, int y) {
    ASSERT_SINGLE_OWNER

    return fDrawContext->writePixels(srcInfo, srcPixels, srcRowBytes, x, y);
}

bool SkGpuDevice::onAccessPixels(SkPixmap* pmap) {
    ASSERT_SINGLE_OWNER
    return false;
}

// call this every draw call, to ensure that the context reflects our state,
// and not the state from some other canvas/device
void SkGpuDevice::prepareDraw(const SkDraw& draw) {
    ASSERT_SINGLE_OWNER

    fClip.reset(draw.fClipStack, &this->getOrigin());
}

GrDrawContext* SkGpuDevice::accessDrawContext() {
    ASSERT_SINGLE_OWNER
    return fDrawContext.get();
}

void SkGpuDevice::clearAll() {
    ASSERT_SINGLE_OWNER
    GrColor color = 0;
    GR_CREATE_TRACE_MARKER_CONTEXT("SkGpuDevice", "clearAll", fContext);
    SkIRect rect = SkIRect::MakeWH(this->width(), this->height());
    fDrawContext->clear(&rect, color, true);
}

void SkGpuDevice::replaceDrawContext(bool shouldRetainContent) {
    ASSERT_SINGLE_OWNER

    SkBudgeted budgeted = fDrawContext->drawContextPriv().isBudgeted();

    sk_sp<GrDrawContext> newDC(MakeDrawContext(this->context(), 
                                               budgeted,
                                               this->imageInfo(),
                                               fDrawContext->numColorSamples(),
                                               fDrawContext->origin(),
                                               &this->surfaceProps()));
    if (!newDC) {
        return;
    }

    if (shouldRetainContent) {
        if (fDrawContext->wasAbandoned()) {
            return;
        }
        newDC->copySurface(fDrawContext->asTexture().get(),
                           SkIRect::MakeWH(this->width(), this->height()),
                           SkIPoint::Make(0, 0));
    }

    fDrawContext = newDC;
}

///////////////////////////////////////////////////////////////////////////////

void SkGpuDevice::drawPaint(const SkDraw& draw, const SkPaint& paint) {
    ASSERT_SINGLE_OWNER
    CHECK_SHOULD_DRAW(draw);
    GR_CREATE_TRACE_MARKER_CONTEXT("SkGpuDevice", "drawPaint", fContext);

    GrPaint grPaint;
    if (!SkPaintToGrPaint(this->context(), fDrawContext.get(), paint, *draw.fMatrix, &grPaint)) {
        return;
    }

    fDrawContext->drawPaint(fClip, grPaint, *draw.fMatrix);
}

// must be in SkCanvas::PointMode order
static const GrPrimitiveType gPointMode2PrimitiveType[] = {
    kPoints_GrPrimitiveType,
    kLines_GrPrimitiveType,
    kLineStrip_GrPrimitiveType
};

// suppress antialiasing on axis-aligned integer-coordinate lines
static bool needs_antialiasing(SkCanvas::PointMode mode, size_t count, const SkPoint pts[]) {
    if (mode == SkCanvas::PointMode::kPoints_PointMode) {
        return false;
    }
    if (count == 2) {
        // We do not antialias as long as the primary axis of the line is integer-aligned, even if
        // the other coordinates are not. This does mean the two end pixels of the line will be
        // sharp even when they shouldn't be, but turning antialiasing on (as things stand
        // currently) means that the line will turn into a two-pixel-wide blur. While obviously a
        // more complete fix is possible down the road, for the time being we accept the error on
        // the two end pixels as being the lesser of two evils.
        if (pts[0].fX == pts[1].fX) {
            return ((int) pts[0].fX) != pts[0].fX;
        }
        if (pts[0].fY == pts[1].fY) {
            return ((int) pts[0].fY) != pts[0].fY;
        }
    }
    return true;
}

void SkGpuDevice::drawPoints(const SkDraw& draw, SkCanvas::PointMode mode,
                             size_t count, const SkPoint pts[], const SkPaint& paint) {
    ASSERT_SINGLE_OWNER
    GR_CREATE_TRACE_MARKER_CONTEXT("SkGpuDevice", "drawPoints", fContext);
    CHECK_SHOULD_DRAW(draw);

    SkScalar width = paint.getStrokeWidth();
    if (width < 0) {
        return;
    }

    if (paint.getPathEffect() && 2 == count && SkCanvas::kLines_PointMode == mode) {
        GrStyle style(paint, SkPaint::kStroke_Style);
        GrPaint grPaint;
        if (!SkPaintToGrPaint(this->context(), fDrawContext.get(), paint, *draw.fMatrix,
                              &grPaint)) {
            return;
        }
        SkPath path;
        path.setIsVolatile(true);
        path.moveTo(pts[0]);
        path.lineTo(pts[1]);
        fDrawContext->drawPath(fClip, grPaint, *draw.fMatrix, path, style);
        return;
    }

    SkScalar scales[2];
    bool isHairline = (0 == width) || (1 == width && draw.fMatrix->getMinMaxScales(scales) &&
                                       SkScalarNearlyEqual(scales[0], 1.f) &&
                                       SkScalarNearlyEqual(scales[1], 1.f));
    // we only handle non-antialiased hairlines and paints without path effects or mask filters,
    // else we let the SkDraw call our drawPath()
    if (!isHairline || paint.getPathEffect() || paint.getMaskFilter() ||
        (paint.isAntiAlias() && needs_antialiasing(mode, count, pts))) {
        draw.drawPoints(mode, count, pts, paint, true);
        return;
    }

    GrPrimitiveType primitiveType = gPointMode2PrimitiveType[mode];

    const SkMatrix* viewMatrix = draw.fMatrix;
#ifdef SK_BUILD_FOR_ANDROID_FRAMEWORK
    // This offsetting in device space matches the expectations of the Android framework for non-AA
    // points and lines.
    SkMatrix tempMatrix;
    if (GrIsPrimTypeLines(primitiveType) || kPoints_GrPrimitiveType == primitiveType) {
        tempMatrix = *viewMatrix;
        static const SkScalar kOffset = 0.063f; // Just greater than 1/16.
        tempMatrix.postTranslate(kOffset, kOffset);
        viewMatrix = &tempMatrix;
    }
#endif

    GrPaint grPaint;
    if (!SkPaintToGrPaint(this->context(), fDrawContext.get(), paint, *viewMatrix, &grPaint)) {
        return;
    }

    fDrawContext->drawVertices(fClip,
                               grPaint,
                               *viewMatrix,
                               primitiveType,
                               SkToS32(count),
                               (SkPoint*)pts,
                               nullptr,
                               nullptr,
                               nullptr,
                               0);
}

///////////////////////////////////////////////////////////////////////////////

void SkGpuDevice::drawRect(const SkDraw& draw, const SkRect& rect, const SkPaint& paint) {
    ASSERT_SINGLE_OWNER
    GR_CREATE_TRACE_MARKER_CONTEXT("SkGpuDevice", "drawRect", fContext);
    CHECK_SHOULD_DRAW(draw);


    // A couple reasons we might need to call drawPath.
    if (paint.getMaskFilter() || paint.getPathEffect()) {
        SkPath path;
        path.setIsVolatile(true);
        path.addRect(rect);
        GrBlurUtils::drawPathWithMaskFilter(fContext, fDrawContext.get(),
                                            fClip, path, paint,
                                            *draw.fMatrix, nullptr,
                                            draw.fRC->getBounds(), true);
        return;
    }

    GrPaint grPaint;
    if (!SkPaintToGrPaint(this->context(), fDrawContext.get(), paint, *draw.fMatrix, &grPaint)) {
        return;
    }

    GrStyle style(paint);
    fDrawContext->drawRect(fClip, grPaint, *draw.fMatrix, rect, &style);
}

///////////////////////////////////////////////////////////////////////////////

void SkGpuDevice::drawRRect(const SkDraw& draw, const SkRRect& rrect,
                            const SkPaint& paint) {
    ASSERT_SINGLE_OWNER
    GR_CREATE_TRACE_MARKER_CONTEXT("SkGpuDevice", "drawRRect", fContext);
    CHECK_SHOULD_DRAW(draw);

    GrPaint grPaint;
    if (!SkPaintToGrPaint(this->context(), fDrawContext.get(), paint, *draw.fMatrix, &grPaint)) {
        return;
    }

    GrStyle style(paint);
    if (paint.getMaskFilter()) {
        // try to hit the fast path for drawing filtered round rects

        SkRRect devRRect;
        if (rrect.transform(*draw.fMatrix, &devRRect)) {
            if (devRRect.allCornersCircular()) {
                SkRect maskRect;
                if (paint.getMaskFilter()->canFilterMaskGPU(devRRect,
                                                            draw.fRC->getBounds(),
                                                            *draw.fMatrix,
                                                            &maskRect)) {
                    SkIRect finalIRect;
                    maskRect.roundOut(&finalIRect);
                    if (draw.fRC->quickReject(finalIRect)) {
                        // clipped out
                        return;
                    }
                    if (paint.getMaskFilter()->directFilterRRectMaskGPU(fContext,
                                                                        fDrawContext.get(),
                                                                        &grPaint,
                                                                        fClip,
                                                                        *draw.fMatrix,
                                                                        style.strokeRec(),
                                                                        rrect,
                                                                        devRRect)) {
                        return;
                    }
                }

            }
        }
    }

    if (paint.getMaskFilter() || style.pathEffect()) {
        // The only mask filter the native rrect drawing code could've handle was taken
        // care of above.
        // A path effect will presumably transform this rrect into something else.
        SkPath path;
        path.setIsVolatile(true);
        path.addRRect(rrect);
        GrBlurUtils::drawPathWithMaskFilter(fContext, fDrawContext.get(),
                                            fClip, path, paint,
                                            *draw.fMatrix, nullptr,
                                            draw.fRC->getBounds(), true);
        return;
    }

    SkASSERT(!style.pathEffect());

    fDrawContext->drawRRect(fClip, grPaint, *draw.fMatrix, rrect, style);
}


void SkGpuDevice::drawDRRect(const SkDraw& draw, const SkRRect& outer,
                             const SkRRect& inner, const SkPaint& paint) {
    ASSERT_SINGLE_OWNER
    GR_CREATE_TRACE_MARKER_CONTEXT("SkGpuDevice", "drawDRRect", fContext);
    CHECK_SHOULD_DRAW(draw);

    if (outer.isEmpty()) {
       return;
    }

    if (inner.isEmpty()) {
        return this->drawRRect(draw, outer, paint);
    }

    SkStrokeRec stroke(paint);

    if (stroke.isFillStyle() && !paint.getMaskFilter() && !paint.getPathEffect()) {
        GrPaint grPaint;
        if (!SkPaintToGrPaint(this->context(), fDrawContext.get(), paint, *draw.fMatrix,
                              &grPaint)) {
            return;
        }

        fDrawContext->drawDRRect(fClip, grPaint, *draw.fMatrix, outer, inner);
        return;
    }

    SkPath path;
    path.setIsVolatile(true);
    path.addRRect(outer);
    path.addRRect(inner);
    path.setFillType(SkPath::kEvenOdd_FillType);

    GrBlurUtils::drawPathWithMaskFilter(fContext, fDrawContext.get(),
                                        fClip, path, paint,
                                        *draw.fMatrix, nullptr,
                                        draw.fRC->getBounds(), true);
}


/////////////////////////////////////////////////////////////////////////////

void SkGpuDevice::drawRegion(const SkDraw& draw, const SkRegion& region, const SkPaint& paint) {
    if (paint.getMaskFilter()) {
        SkPath path;
        region.getBoundaryPath(&path);
        return this->drawPath(draw, path, paint, nullptr, false);
    }

    GrPaint grPaint;
    if (!SkPaintToGrPaint(this->context(), fDrawContext.get(), paint, *draw.fMatrix, &grPaint)) {
        return;
    }

    fDrawContext->drawRegion(fClip, grPaint, *draw.fMatrix, region, GrStyle(paint));
}

void SkGpuDevice::drawOval(const SkDraw& draw, const SkRect& oval, const SkPaint& paint) {
    ASSERT_SINGLE_OWNER
    GR_CREATE_TRACE_MARKER_CONTEXT("SkGpuDevice", "drawOval", fContext);
    CHECK_SHOULD_DRAW(draw);

    // Presumably the path effect warps this to something other than an oval
    if (paint.getPathEffect()) {
        SkPath path;
        path.setIsVolatile(true);
        path.addOval(oval);
        this->drawPath(draw, path, paint, nullptr, true);
        return;
    }

    if (paint.getMaskFilter()) {
        // The RRect path can handle special case blurring
        SkRRect rr = SkRRect::MakeOval(oval);
        return this->drawRRect(draw, rr, paint);
    }

    GrPaint grPaint;
    if (!SkPaintToGrPaint(this->context(), fDrawContext.get(), paint, *draw.fMatrix, &grPaint)) {
        return;
    }

    fDrawContext->drawOval(fClip, grPaint, *draw.fMatrix, oval, GrStyle(paint));
}

void SkGpuDevice::drawArc(const SkDraw& draw, const SkRect& oval, SkScalar startAngle,
                          SkScalar sweepAngle, bool useCenter, const SkPaint& paint) {
    ASSERT_SINGLE_OWNER
    GR_CREATE_TRACE_MARKER_CONTEXT("SkGpuDevice", "drawArc", fContext);
    CHECK_SHOULD_DRAW(draw);

    if (paint.getMaskFilter()) {
        this->INHERITED::drawArc(draw, oval, startAngle, sweepAngle, useCenter, paint);
        return;
    }
    GrPaint grPaint;
    if (!SkPaintToGrPaint(this->context(), fDrawContext.get(), paint, *draw.fMatrix, &grPaint)) {
        return;
    }

    fDrawContext->drawArc(fClip, grPaint, *draw.fMatrix, oval, startAngle, sweepAngle, useCenter,
                          GrStyle(paint));
}

#include "SkMaskFilter.h"

///////////////////////////////////////////////////////////////////////////////
void SkGpuDevice::drawStrokedLine(const SkPoint points[2],
                                  const SkDraw& draw,
                                  const SkPaint& origPaint) {
    ASSERT_SINGLE_OWNER
    GR_CREATE_TRACE_MARKER_CONTEXT("SkGpuDevice", "drawStrokedLine", fContext);
    CHECK_SHOULD_DRAW(draw);

    // Adding support for round capping would require a GrDrawContext::fillRRectWithLocalMatrix
    // entry point
    SkASSERT(SkPaint::kRound_Cap != origPaint.getStrokeCap());
    SkASSERT(SkPaint::kStroke_Style == origPaint.getStyle());
    SkASSERT(!origPaint.getPathEffect());
    SkASSERT(!origPaint.getMaskFilter());

    const SkScalar halfWidth = 0.5f * origPaint.getStrokeWidth();
    SkASSERT(halfWidth > 0);

    SkVector v = points[1] - points[0];

    SkScalar length = SkPoint::Normalize(&v);
    if (!length) {
        v.fX = 1.0f;
        v.fY = 0.0f;
    }

    SkPaint newPaint(origPaint);
    newPaint.setStyle(SkPaint::kFill_Style);

    SkScalar xtraLength = 0.0f;
    if (SkPaint::kButt_Cap != origPaint.getStrokeCap()) {
        xtraLength = halfWidth;
    }

    SkPoint mid = points[0] + points[1];
    mid.scale(0.5f);

    SkRect rect = SkRect::MakeLTRB(mid.fX-halfWidth, mid.fY - 0.5f*length - xtraLength,
                                   mid.fX+halfWidth, mid.fY + 0.5f*length + xtraLength);
    SkMatrix m;
    m.setSinCos(v.fX, -v.fY, mid.fX, mid.fY);

    SkMatrix local = m;

    m.postConcat(*draw.fMatrix);

    GrPaint grPaint;
    if (!SkPaintToGrPaint(this->context(), fDrawContext.get(), newPaint, m, &grPaint)) {
        return;
    }

    fDrawContext->fillRectWithLocalMatrix(fClip, grPaint, m, rect, local);
}

void SkGpuDevice::drawPath(const SkDraw& draw, const SkPath& origSrcPath,
                           const SkPaint& paint, const SkMatrix* prePathMatrix,
                           bool pathIsMutable) {
    ASSERT_SINGLE_OWNER
    if (!origSrcPath.isInverseFillType() && !paint.getPathEffect() && !prePathMatrix) {
        SkPoint points[2];
        if (SkPaint::kStroke_Style == paint.getStyle() && paint.getStrokeWidth() > 0 &&
            !paint.getMaskFilter() && SkPaint::kRound_Cap != paint.getStrokeCap() &&
            draw.fMatrix->preservesRightAngles() && origSrcPath.isLine(points)) {
            // Path-based stroking looks better for thin rects
            SkScalar strokeWidth = draw.fMatrix->getMaxScale() * paint.getStrokeWidth();
            if (strokeWidth >= 1.0f) {
                // Round capping support is currently disabled b.c. it would require
                // a RRect batch that takes a localMatrix.
                this->drawStrokedLine(points, draw, paint);
                return;
            }
        }
        bool isClosed;
        SkRect rect;
        if (origSrcPath.isRect(&rect, &isClosed) && isClosed) {
            this->drawRect(draw, rect, paint);
            return;
        }
        if (origSrcPath.isOval(&rect)) {
            this->drawOval(draw, rect, paint);
            return;
        }
        SkRRect rrect;
        if (origSrcPath.isRRect(&rrect)) {
            this->drawRRect(draw, rrect, paint);
            return;
        }
    }

    CHECK_SHOULD_DRAW(draw);
    GR_CREATE_TRACE_MARKER_CONTEXT("SkGpuDevice", "drawPath", fContext);

    GrBlurUtils::drawPathWithMaskFilter(fContext, fDrawContext.get(),
                                        fClip, origSrcPath, paint,
                                        *draw.fMatrix, prePathMatrix,
                                        draw.fRC->getBounds(), pathIsMutable);
}

static const int kBmpSmallTileSize = 1 << 10;

static inline int get_tile_count(const SkIRect& srcRect, int tileSize)  {
    int tilesX = (srcRect.fRight / tileSize) - (srcRect.fLeft / tileSize) + 1;
    int tilesY = (srcRect.fBottom / tileSize) - (srcRect.fTop / tileSize) + 1;
    return tilesX * tilesY;
}

static int determine_tile_size(const SkIRect& src, int maxTileSize) {
    if (maxTileSize <= kBmpSmallTileSize) {
        return maxTileSize;
    }

    size_t maxTileTotalTileSize = get_tile_count(src, maxTileSize);
    size_t smallTotalTileSize = get_tile_count(src, kBmpSmallTileSize);

    maxTileTotalTileSize *= maxTileSize * maxTileSize;
    smallTotalTileSize *= kBmpSmallTileSize * kBmpSmallTileSize;

    if (maxTileTotalTileSize > 2 * smallTotalTileSize) {
        return kBmpSmallTileSize;
    } else {
        return maxTileSize;
    }
}

// Given a bitmap, an optional src rect, and a context with a clip and matrix determine what
// pixels from the bitmap are necessary.
static void determine_clipped_src_rect(int width, int height,
                                       const GrClip& clip,
                                       const SkMatrix& viewMatrix,
                                       const SkMatrix& srcToDstRect,
                                       const SkISize& imageSize,
                                       const SkRect* srcRectPtr,
                                       SkIRect* clippedSrcIRect) {
    clip.getConservativeBounds(width, height, clippedSrcIRect, nullptr);
    SkMatrix inv = SkMatrix::Concat(viewMatrix, srcToDstRect);
    if (!inv.invert(&inv)) {
        clippedSrcIRect->setEmpty();
        return;
    }
    SkRect clippedSrcRect = SkRect::Make(*clippedSrcIRect);
    inv.mapRect(&clippedSrcRect);
    if (srcRectPtr) {
        if (!clippedSrcRect.intersect(*srcRectPtr)) {
            clippedSrcIRect->setEmpty();
            return;
        }
    }
    clippedSrcRect.roundOut(clippedSrcIRect);
    SkIRect bmpBounds = SkIRect::MakeSize(imageSize);
    if (!clippedSrcIRect->intersect(bmpBounds)) {
        clippedSrcIRect->setEmpty();
    }
}

bool SkGpuDevice::shouldTileImageID(uint32_t imageID, const SkIRect& imageRect,
                                    const SkMatrix& viewMatrix,
                                    const SkMatrix& srcToDstRect,
                                    const GrTextureParams& params,
                                    const SkRect* srcRectPtr,
                                    int maxTileSize,
                                    int* tileSize,
                                    SkIRect* clippedSubset) const {
    ASSERT_SINGLE_OWNER
    // if it's larger than the max tile size, then we have no choice but tiling.
    if (imageRect.width() > maxTileSize || imageRect.height() > maxTileSize) {
        determine_clipped_src_rect(fDrawContext->width(), fDrawContext->height(), fClip, viewMatrix,
                                   srcToDstRect, imageRect.size(), srcRectPtr, clippedSubset);
        *tileSize = determine_tile_size(*clippedSubset, maxTileSize);
        return true;
    }

    // If the image would only produce 4 tiles of the smaller size, don't bother tiling it.
    const size_t area = imageRect.width() * imageRect.height();
    if (area < 4 * kBmpSmallTileSize * kBmpSmallTileSize) {
        return false;
    }

    // At this point we know we could do the draw by uploading the entire bitmap
    // as a texture. However, if the texture would be large compared to the
    // cache size and we don't require most of it for this draw then tile to
    // reduce the amount of upload and cache spill.

    // assumption here is that sw bitmap size is a good proxy for its size as
    // a texture
    size_t bmpSize = area * sizeof(SkPMColor);  // assume 32bit pixels
    size_t cacheSize;
    fContext->getResourceCacheLimits(nullptr, &cacheSize);
    if (bmpSize < cacheSize / 2) {
        return false;
    }

    // Figure out how much of the src we will need based on the src rect and clipping. Reject if
    // tiling memory savings would be < 50%.
    determine_clipped_src_rect(fDrawContext->width(), fDrawContext->height(), fClip, viewMatrix,
                               srcToDstRect, imageRect.size(), srcRectPtr, clippedSubset);
    *tileSize = kBmpSmallTileSize; // already know whole bitmap fits in one max sized tile.
    size_t usedTileBytes = get_tile_count(*clippedSubset, kBmpSmallTileSize) *
                           kBmpSmallTileSize * kBmpSmallTileSize;

    return usedTileBytes < 2 * bmpSize;
}

bool SkGpuDevice::shouldTileImage(const SkImage* image, const SkRect* srcRectPtr,
                                  SkCanvas::SrcRectConstraint constraint, SkFilterQuality quality,
                                  const SkMatrix& viewMatrix,
                                  const SkMatrix& srcToDstRect) const {
    ASSERT_SINGLE_OWNER
    // if image is explictly texture backed then just use the texture
    if (as_IB(image)->peekTexture()) {
        return false;
    }

    GrTextureParams params;
    bool doBicubic;
    GrTextureParams::FilterMode textureFilterMode =
                    GrSkFilterQualityToGrFilterMode(quality, viewMatrix, srcToDstRect, &doBicubic);

    int tileFilterPad;
    if (doBicubic) {
        tileFilterPad = GrBicubicEffect::kFilterTexelPad;
    } else if (GrTextureParams::kNone_FilterMode == textureFilterMode) {
        tileFilterPad = 0;
    } else {
        tileFilterPad = 1;
    }
    params.setFilterMode(textureFilterMode);

    int maxTileSize = fContext->caps()->maxTileSize() - 2 * tileFilterPad;

    // these are output, which we safely ignore, as we just want to know the predicate
    int outTileSize;
    SkIRect outClippedSrcRect;

    return this->shouldTileImageID(image->unique(), image->bounds(), viewMatrix, srcToDstRect,
                                   params, srcRectPtr, maxTileSize, &outTileSize,
                                   &outClippedSrcRect);
}

void SkGpuDevice::drawBitmap(const SkDraw& origDraw,
                             const SkBitmap& bitmap,
                             const SkMatrix& m,
                             const SkPaint& paint) {
    ASSERT_SINGLE_OWNER
    CHECK_SHOULD_DRAW(origDraw);
    SkMatrix viewMatrix;
    viewMatrix.setConcat(*origDraw.fMatrix, m);

    int maxTileSize = fContext->caps()->maxTileSize();

    // The tile code path doesn't currently support AA, so if the paint asked for aa and we could
    // draw untiled, then we bypass checking for tiling purely for optimization reasons.
    bool drawAA = !fDrawContext->isUnifiedMultisampled() &&
                  paint.isAntiAlias() &&
                  bitmap.width() <= maxTileSize &&
                  bitmap.height() <= maxTileSize;

    bool skipTileCheck = drawAA || paint.getMaskFilter();

    if (!skipTileCheck) {
        SkRect srcRect = SkRect::MakeIWH(bitmap.width(), bitmap.height());
        int tileSize;
        SkIRect clippedSrcRect;

        GrTextureParams params;
        bool doBicubic;
        GrTextureParams::FilterMode textureFilterMode =
            GrSkFilterQualityToGrFilterMode(paint.getFilterQuality(), viewMatrix, SkMatrix::I(),
                                            &doBicubic);

        int tileFilterPad;

        if (doBicubic) {
            tileFilterPad = GrBicubicEffect::kFilterTexelPad;
        } else if (GrTextureParams::kNone_FilterMode == textureFilterMode) {
            tileFilterPad = 0;
        } else {
            tileFilterPad = 1;
        }
        params.setFilterMode(textureFilterMode);

        int maxTileSizeForFilter = fContext->caps()->maxTileSize() - 2 * tileFilterPad;
        if (this->shouldTileImageID(bitmap.getGenerationID(), bitmap.getSubset(), viewMatrix,
                                    SkMatrix::I(), params, &srcRect, maxTileSizeForFilter,
                                    &tileSize, &clippedSrcRect)) {
            this->drawTiledBitmap(bitmap, viewMatrix, SkMatrix::I(), srcRect, clippedSrcRect,
                                  params, paint, SkCanvas::kStrict_SrcRectConstraint, tileSize,
                                  doBicubic);
            return;
        }
    }
    GrBitmapTextureMaker maker(fContext, bitmap);
    this->drawTextureProducer(&maker, nullptr, nullptr, SkCanvas::kStrict_SrcRectConstraint,
                              viewMatrix, fClip, paint);
}

// This method outsets 'iRect' by 'outset' all around and then clamps its extents to
// 'clamp'. 'offset' is adjusted to remain positioned over the top-left corner
// of 'iRect' for all possible outsets/clamps.
static inline void clamped_outset_with_offset(SkIRect* iRect,
                                              int outset,
                                              SkPoint* offset,
                                              const SkIRect& clamp) {
    iRect->outset(outset, outset);

    int leftClampDelta = clamp.fLeft - iRect->fLeft;
    if (leftClampDelta > 0) {
        offset->fX -= outset - leftClampDelta;
        iRect->fLeft = clamp.fLeft;
    } else {
        offset->fX -= outset;
    }

    int topClampDelta = clamp.fTop - iRect->fTop;
    if (topClampDelta > 0) {
        offset->fY -= outset - topClampDelta;
        iRect->fTop = clamp.fTop;
    } else {
        offset->fY -= outset;
    }

    if (iRect->fRight > clamp.fRight) {
        iRect->fRight = clamp.fRight;
    }
    if (iRect->fBottom > clamp.fBottom) {
        iRect->fBottom = clamp.fBottom;
    }
}

// Break 'bitmap' into several tiles to draw it since it has already
// been determined to be too large to fit in VRAM
void SkGpuDevice::drawTiledBitmap(const SkBitmap& bitmap,
                                  const SkMatrix& viewMatrix,
                                  const SkMatrix& dstMatrix,
                                  const SkRect& srcRect,
                                  const SkIRect& clippedSrcIRect,
                                  const GrTextureParams& params,
                                  const SkPaint& origPaint,
                                  SkCanvas::SrcRectConstraint constraint,
                                  int tileSize,
                                  bool bicubic) {
    ASSERT_SINGLE_OWNER

    // This is the funnel for all paths that draw tiled bitmaps/images. Log histogram entries.
    SK_HISTOGRAM_BOOLEAN("DrawTiled", true);
    LogDrawScaleFactor(viewMatrix, origPaint.getFilterQuality());

    // The following pixel lock is technically redundant, but it is desirable
    // to lock outside of the tile loop to prevent redecoding the whole image
    // at each tile in cases where 'bitmap' holds an SkDiscardablePixelRef that
    // is larger than the limit of the discardable memory pool.
    SkAutoLockPixels alp(bitmap);

    const SkPaint* paint = &origPaint;
    SkPaint tempPaint;
    if (origPaint.isAntiAlias() && !fDrawContext->isUnifiedMultisampled()) {
        // Drop antialiasing to avoid seams at tile boundaries.
        tempPaint = origPaint;
        tempPaint.setAntiAlias(false);
        paint = &tempPaint;
    }
    SkRect clippedSrcRect = SkRect::Make(clippedSrcIRect);

    int nx = bitmap.width() / tileSize;
    int ny = bitmap.height() / tileSize;
    for (int x = 0; x <= nx; x++) {
        for (int y = 0; y <= ny; y++) {
            SkRect tileR;
            tileR.set(SkIntToScalar(x * tileSize),
                      SkIntToScalar(y * tileSize),
                      SkIntToScalar((x + 1) * tileSize),
                      SkIntToScalar((y + 1) * tileSize));

            if (!SkRect::Intersects(tileR, clippedSrcRect)) {
                continue;
            }

            if (!tileR.intersect(srcRect)) {
                continue;
            }

            SkIRect iTileR;
            tileR.roundOut(&iTileR);
            SkVector offset = SkPoint::Make(SkIntToScalar(iTileR.fLeft),
                                            SkIntToScalar(iTileR.fTop));
            SkRect rectToDraw = SkRect::MakeXYWH(offset.fX, offset.fY,
                                                 tileR.width(), tileR.height());
            dstMatrix.mapRect(&rectToDraw);
            if (GrTextureParams::kNone_FilterMode != params.filterMode() || bicubic) {
                SkIRect iClampRect;

                if (SkCanvas::kFast_SrcRectConstraint == constraint) {
                    // In bleed mode we want to always expand the tile on all edges
                    // but stay within the bitmap bounds
                    iClampRect = SkIRect::MakeWH(bitmap.width(), bitmap.height());
                } else {
                    // In texture-domain/clamp mode we only want to expand the
                    // tile on edges interior to "srcRect" (i.e., we want to
                    // not bleed across the original clamped edges)
                    srcRect.roundOut(&iClampRect);
                }
                int outset = bicubic ? GrBicubicEffect::kFilterTexelPad : 1;
                clamped_outset_with_offset(&iTileR, outset, &offset, iClampRect);
            }

            SkBitmap tmpB;
            if (bitmap.extractSubset(&tmpB, iTileR)) {
                // now offset it to make it "local" to our tmp bitmap
                tileR.offset(-offset.fX, -offset.fY);
                GrTextureParams paramsTemp = params;
                // de-optimized this determination
                bool needsTextureDomain = true;
                this->drawBitmapTile(tmpB,
                                     viewMatrix,
                                     rectToDraw,
                                     tileR,
                                     paramsTemp,
                                     *paint,
                                     constraint,
                                     bicubic,
                                     needsTextureDomain);
            }
        }
    }
}

void SkGpuDevice::drawBitmapTile(const SkBitmap& bitmap,
                                 const SkMatrix& viewMatrix,
                                 const SkRect& dstRect,
                                 const SkRect& srcRect,
                                 const GrTextureParams& params,
                                 const SkPaint& paint,
                                 SkCanvas::SrcRectConstraint constraint,
                                 bool bicubic,
                                 bool needsTextureDomain) {
    // We should have already handled bitmaps larger than the max texture size.
    SkASSERT(bitmap.width() <= fContext->caps()->maxTextureSize() &&
             bitmap.height() <= fContext->caps()->maxTextureSize());
    // We should be respecting the max tile size by the time we get here.
    SkASSERT(bitmap.width() <= fContext->caps()->maxTileSize() &&
             bitmap.height() <= fContext->caps()->maxTileSize());

    sk_sp<GrTexture> texture = GrMakeCachedBitmapTexture(fContext, bitmap, params,
                                                         fDrawContext->sourceGammaTreatment());
    if (nullptr == texture) {
        return;
    }
    sk_sp<GrColorSpaceXform> colorSpaceXform =
        GrColorSpaceXform::Make(bitmap.colorSpace(), fDrawContext->getColorSpace());

    SkScalar iw = 1.f / texture->width();
    SkScalar ih = 1.f / texture->height();

    SkMatrix texMatrix;
    // Compute a matrix that maps the rect we will draw to the src rect.
    texMatrix.setRectToRect(dstRect, srcRect, SkMatrix::kStart_ScaleToFit);
    texMatrix.postScale(iw, ih);

    // Construct a GrPaint by setting the bitmap texture as the first effect and then configuring
    // the rest from the SkPaint.
    sk_sp<GrFragmentProcessor> fp;

    if (needsTextureDomain && (SkCanvas::kStrict_SrcRectConstraint == constraint)) {
        // Use a constrained texture domain to avoid color bleeding
        SkRect domain;
        if (srcRect.width() > SK_Scalar1) {
            domain.fLeft  = (srcRect.fLeft + 0.5f) * iw;
            domain.fRight = (srcRect.fRight - 0.5f) * iw;
        } else {
            domain.fLeft = domain.fRight = srcRect.centerX() * iw;
        }
        if (srcRect.height() > SK_Scalar1) {
            domain.fTop  = (srcRect.fTop + 0.5f) * ih;
            domain.fBottom = (srcRect.fBottom - 0.5f) * ih;
        } else {
            domain.fTop = domain.fBottom = srcRect.centerY() * ih;
        }
        if (bicubic) {
            fp = GrBicubicEffect::Make(texture.get(), std::move(colorSpaceXform), texMatrix,
                                       domain);
        } else {
            fp = GrTextureDomainEffect::Make(texture.get(), std::move(colorSpaceXform), texMatrix,
                                             domain, GrTextureDomain::kClamp_Mode,
                                             params.filterMode());
        }
    } else if (bicubic) {
        SkASSERT(GrTextureParams::kNone_FilterMode == params.filterMode());
        SkShader::TileMode tileModes[2] = { params.getTileModeX(), params.getTileModeY() };
        fp = GrBicubicEffect::Make(texture.get(), std::move(colorSpaceXform), texMatrix, tileModes);
    } else {
        fp = GrSimpleTextureEffect::Make(texture.get(), std::move(colorSpaceXform), texMatrix, params);
    }

    GrPaint grPaint;
    if (!SkPaintToGrPaintWithTexture(this->context(), fDrawContext.get(), paint, viewMatrix,
                                     std::move(fp), kAlpha_8_SkColorType == bitmap.colorType(),
                                     &grPaint)) {
        return;
    }

    fDrawContext->drawRect(fClip, grPaint, viewMatrix, dstRect);
}

void SkGpuDevice::drawSprite(const SkDraw& draw, const SkBitmap& bitmap,
                             int left, int top, const SkPaint& paint) {
    ASSERT_SINGLE_OWNER
    CHECK_SHOULD_DRAW(draw);
    GR_CREATE_TRACE_MARKER_CONTEXT("SkGpuDevice", "drawSprite", fContext);

    if (fContext->abandoned()) {
        return;
    }

    sk_sp<GrTexture> texture;
    {
        SkAutoLockPixels alp(bitmap, true);
        if (!bitmap.readyToDraw()) {
            return;
        }

        // draw sprite neither filters nor tiles.
        texture.reset(GrRefCachedBitmapTexture(fContext, bitmap,
                                               GrTextureParams::ClampNoFilter(),
                                               SkSourceGammaTreatment::kRespect));
        if (!texture) {
            return;
        }
    }

    SkIRect srcRect = SkIRect::MakeXYWH(bitmap.pixelRefOrigin().fX,
                                        bitmap.pixelRefOrigin().fY,
                                        bitmap.width(),
                                        bitmap.height());

    sk_sp<SkSpecialImage> srcImg(SkSpecialImage::MakeFromGpu(srcRect,
                                                             bitmap.getGenerationID(),
                                                             std::move(texture),
                                                             sk_ref_sp(bitmap.colorSpace()),
                                                             &this->surfaceProps()));

    this->drawSpecial(draw, srcImg.get(), left, top, paint);
}


void SkGpuDevice::drawSpecial(const SkDraw& draw, 
                              SkSpecialImage* special1,
                              int left, int top,
                              const SkPaint& paint) {
    ASSERT_SINGLE_OWNER
    CHECK_SHOULD_DRAW(draw);
    GR_CREATE_TRACE_MARKER_CONTEXT("SkGpuDevice", "drawSpecial", fContext);

    SkIPoint offset = { 0, 0 };

    sk_sp<SkSpecialImage> result;
    if (paint.getImageFilter()) {
        result = this->filterTexture(draw, special1, left, top,
                                      &offset,
                                      paint.getImageFilter());
        if (!result) {
            return;
        }
    } else {
        result = sk_ref_sp(special1);
    }

    SkASSERT(result->isTextureBacked());
    sk_sp<GrTexture> texture = result->asTextureRef(fContext);

    SkPaint tmpUnfiltered(paint);
    tmpUnfiltered.setImageFilter(nullptr);

    sk_sp<GrColorSpaceXform> colorSpaceXform =
        GrColorSpaceXform::Make(result->getColorSpace(), fDrawContext->getColorSpace());
    GrPaint grPaint;
    sk_sp<GrFragmentProcessor> fp(GrSimpleTextureEffect::Make(texture.get(),
                                                              std::move(colorSpaceXform),
                                                              SkMatrix::I()));
    if (GrPixelConfigIsAlphaOnly(texture->config())) {
        fp = GrFragmentProcessor::MulOutputByInputUnpremulColor(std::move(fp));
    } else {
        fp = GrFragmentProcessor::MulOutputByInputAlpha(std::move(fp));
    }
    if (!SkPaintToGrPaintReplaceShader(this->context(), fDrawContext.get(), tmpUnfiltered,
                                       std::move(fp), &grPaint)) {
        return;
    }

    const SkIRect& subset = result->subset();

    fDrawContext->fillRectToRect(fClip,
                                 grPaint,
                                 SkMatrix::I(),
                                 SkRect::Make(SkIRect::MakeXYWH(left + offset.fX, top + offset.fY,
                                                                subset.width(), subset.height())),
                                 SkRect::MakeXYWH(SkIntToScalar(subset.fLeft) / texture->width(),
                                                  SkIntToScalar(subset.fTop) / texture->height(),
                                                  SkIntToScalar(subset.width()) / texture->width(),
                                                  SkIntToScalar(subset.height()) / texture->height()));
}

void SkGpuDevice::drawBitmapRect(const SkDraw& draw, const SkBitmap& bitmap,
                                 const SkRect* src, const SkRect& origDst,
                                 const SkPaint& paint, SkCanvas::SrcRectConstraint constraint) {
    ASSERT_SINGLE_OWNER
    CHECK_SHOULD_DRAW(draw);

    // The src rect is inferred to be the bmp bounds if not provided. Otherwise, the src rect must
    // be clipped to the bmp bounds. To determine tiling parameters we need the filter mode which
    // in turn requires knowing the src-to-dst mapping. If the src was clipped to the bmp bounds
    // then we use the src-to-dst mapping to compute a new clipped dst rect.
    const SkRect* dst = &origDst;
    const SkRect bmpBounds = SkRect::MakeIWH(bitmap.width(), bitmap.height());
    // Compute matrix from the two rectangles
    if (!src) {
        src = &bmpBounds;
    }

    SkMatrix srcToDstMatrix;
    if (!srcToDstMatrix.setRectToRect(*src, *dst, SkMatrix::kFill_ScaleToFit)) {
        return;
    }
    SkRect tmpSrc, tmpDst;
    if (src != &bmpBounds) {
        if (!bmpBounds.contains(*src)) {
            tmpSrc = *src;
            if (!tmpSrc.intersect(bmpBounds)) {
                return; // nothing to draw
            }
            src = &tmpSrc;
            srcToDstMatrix.mapRect(&tmpDst, *src);
            dst = &tmpDst;
        }
    }

    int maxTileSize = fContext->caps()->maxTileSize();

    // The tile code path doesn't currently support AA, so if the paint asked for aa and we could
    // draw untiled, then we bypass checking for tiling purely for optimization reasons.
    bool drawAA = !fDrawContext->isUnifiedMultisampled() &&
        paint.isAntiAlias() &&
        bitmap.width() <= maxTileSize &&
        bitmap.height() <= maxTileSize;

    bool skipTileCheck = drawAA || paint.getMaskFilter();

    if (!skipTileCheck) {
        int tileSize;
        SkIRect clippedSrcRect;

        GrTextureParams params;
        bool doBicubic;
        GrTextureParams::FilterMode textureFilterMode =
            GrSkFilterQualityToGrFilterMode(paint.getFilterQuality(), *draw.fMatrix, srcToDstMatrix,
                                            &doBicubic);

        int tileFilterPad;

        if (doBicubic) {
            tileFilterPad = GrBicubicEffect::kFilterTexelPad;
        } else if (GrTextureParams::kNone_FilterMode == textureFilterMode) {
            tileFilterPad = 0;
        } else {
            tileFilterPad = 1;
        }
        params.setFilterMode(textureFilterMode);

        int maxTileSizeForFilter = fContext->caps()->maxTileSize() - 2 * tileFilterPad;
        if (this->shouldTileImageID(bitmap.getGenerationID(), bitmap.getSubset(), *draw.fMatrix,
                                    srcToDstMatrix, params, src, maxTileSizeForFilter, &tileSize,
                                    &clippedSrcRect)) {
            this->drawTiledBitmap(bitmap, *draw.fMatrix, srcToDstMatrix, *src, clippedSrcRect,
                                  params, paint, constraint, tileSize, doBicubic);
            return;
        }
    }
    GrBitmapTextureMaker maker(fContext, bitmap);
    this->drawTextureProducer(&maker, src, dst, constraint, *draw.fMatrix, fClip, paint);
}

sk_sp<SkSpecialImage> SkGpuDevice::makeSpecial(const SkBitmap& bitmap) {
    SkAutoLockPixels alp(bitmap, true);
    if (!bitmap.readyToDraw()) {
        return nullptr;
    }

    sk_sp<GrTexture> texture = GrMakeCachedBitmapTexture(fContext, bitmap,
                                                         GrTextureParams::ClampNoFilter(),
                                                         SkSourceGammaTreatment::kRespect);
    if (!texture) {
        return nullptr;
    }

    return SkSpecialImage::MakeFromGpu(bitmap.bounds(),
                                       bitmap.getGenerationID(),
                                       texture,
                                       sk_ref_sp(bitmap.colorSpace()),
                                       &this->surfaceProps());
}

sk_sp<SkSpecialImage> SkGpuDevice::makeSpecial(const SkImage* image) {
    SkPixmap pm;
    if (image->isTextureBacked()) {
        GrTexture* texture = as_IB(image)->peekTexture();

        return SkSpecialImage::MakeFromGpu(SkIRect::MakeWH(image->width(), image->height()),
                                           image->uniqueID(),
                                           sk_ref_sp(texture),
                                           sk_ref_sp(as_IB(image)->onImageInfo().colorSpace()),
                                           &this->surfaceProps());
    } else if (image->peekPixels(&pm)) {
        SkBitmap bm;

        bm.installPixels(pm);
        return this->makeSpecial(bm);
    } else {
        return nullptr;
    }
}

sk_sp<SkSpecialImage> SkGpuDevice::snapSpecial() {
    sk_sp<GrTexture> texture(this->accessDrawContext()->asTexture());
    if (!texture) {
        // When the device doesn't have a texture, we create a temporary texture.
        // TODO: we should actually only copy the portion of the source needed to apply the image
        // filter
        texture.reset(fContext->textureProvider()->createTexture(this->accessDrawContext()->desc(),
                                                                 SkBudgeted::kYes));
        if (!texture) {
            return nullptr;
        }

        if (!fContext->copySurface(texture.get(), this->accessDrawContext()->accessRenderTarget())){
            return nullptr;
        }
    }

    const SkImageInfo ii = this->imageInfo();
    const SkIRect srcRect = SkIRect::MakeWH(ii.width(), ii.height());

    return SkSpecialImage::MakeFromGpu(srcRect,
                                       kNeedNewImageUniqueID_SpecialImage,
                                       std::move(texture),
                                       sk_ref_sp(ii.colorSpace()),
                                       &this->surfaceProps());
}

void SkGpuDevice::drawDevice(const SkDraw& draw, SkBaseDevice* device,
                             int left, int top, const SkPaint& paint) {
    SkASSERT(!paint.getImageFilter());

    ASSERT_SINGLE_OWNER
    // clear of the source device must occur before CHECK_SHOULD_DRAW
    GR_CREATE_TRACE_MARKER_CONTEXT("SkGpuDevice", "drawDevice", fContext);

    // drawDevice is defined to be in device coords.
    CHECK_SHOULD_DRAW(draw);

    SkGpuDevice* dev = static_cast<SkGpuDevice*>(device);
    sk_sp<SkSpecialImage> srcImg(dev->snapSpecial());
    if (!srcImg) {
        return;
    }

    this->drawSpecial(draw, srcImg.get(), left, top, paint);
}

void SkGpuDevice::drawImage(const SkDraw& draw, const SkImage* image, SkScalar x, SkScalar y,
                            const SkPaint& paint) {
    ASSERT_SINGLE_OWNER
    SkMatrix viewMatrix = *draw.fMatrix;
    viewMatrix.preTranslate(x, y);
    uint32_t pinnedUniqueID;
    if (sk_sp<GrTexture> tex = as_IB(image)->refPinnedTexture(&pinnedUniqueID)) {
        CHECK_SHOULD_DRAW(draw);
        GrTextureAdjuster adjuster(tex.get(), image->alphaType(), image->bounds(), pinnedUniqueID,
                                   as_IB(image)->onImageInfo().colorSpace());
        this->drawTextureProducer(&adjuster, nullptr, nullptr, SkCanvas::kFast_SrcRectConstraint,
                                  viewMatrix, fClip, paint);
        return;
    } else {
        SkBitmap bm;
        if (this->shouldTileImage(image, nullptr, SkCanvas::kFast_SrcRectConstraint,
                                  paint.getFilterQuality(), *draw.fMatrix, SkMatrix::I())) {
            // only support tiling as bitmap at the moment, so force raster-version
            if (!as_IB(image)->getROPixels(&bm)) {
                return;
            }
            this->drawBitmap(draw, bm, SkMatrix::MakeTrans(x, y), paint);
        } else if (SkImageCacherator* cacher = as_IB(image)->peekCacherator()) {
            CHECK_SHOULD_DRAW(draw);
            GrImageTextureMaker maker(fContext, cacher, image, SkImage::kAllow_CachingHint);
            this->drawTextureProducer(&maker, nullptr, nullptr, SkCanvas::kFast_SrcRectConstraint,
                                      viewMatrix, fClip, paint);
        } else if (as_IB(image)->getROPixels(&bm)) {
            this->drawBitmap(draw, bm, SkMatrix::MakeTrans(x, y), paint);
        }
    }
}

void SkGpuDevice::drawImageRect(const SkDraw& draw, const SkImage* image, const SkRect* src,
                                const SkRect& dst, const SkPaint& paint,
                                SkCanvas::SrcRectConstraint constraint) {
    ASSERT_SINGLE_OWNER
    uint32_t pinnedUniqueID;
    if (sk_sp<GrTexture> tex = as_IB(image)->refPinnedTexture(&pinnedUniqueID)) {
        CHECK_SHOULD_DRAW(draw);
        GrTextureAdjuster adjuster(tex.get(), image->alphaType(), image->bounds(), pinnedUniqueID,
                                   as_IB(image)->onImageInfo().colorSpace());
        this->drawTextureProducer(&adjuster, src, &dst, constraint, *draw.fMatrix, fClip, paint);
        return;
    }
    SkBitmap bm;
    SkMatrix srcToDstRect;
    srcToDstRect.setRectToRect((src ? *src : SkRect::MakeIWH(image->width(), image->height())),
                               dst, SkMatrix::kFill_ScaleToFit);
    if (this->shouldTileImage(image, src, constraint, paint.getFilterQuality(), *draw.fMatrix,
                              srcToDstRect)) {
        // only support tiling as bitmap at the moment, so force raster-version
        if (!as_IB(image)->getROPixels(&bm)) {
            return;
        }
        this->drawBitmapRect(draw, bm, src, dst, paint, constraint);
    } else if (SkImageCacherator* cacher = as_IB(image)->peekCacherator()) {
        CHECK_SHOULD_DRAW(draw);
        GrImageTextureMaker maker(fContext, cacher, image, SkImage::kAllow_CachingHint);
        this->drawTextureProducer(&maker, src, &dst, constraint, *draw.fMatrix, fClip, paint);
    } else if (as_IB(image)->getROPixels(&bm)) {
        this->drawBitmapRect(draw, bm, src, dst, paint, constraint);
    }
}

void SkGpuDevice::drawProducerNine(const SkDraw& draw, GrTextureProducer* producer,
                                   const SkIRect& center, const SkRect& dst, const SkPaint& paint) {
    GR_CREATE_TRACE_MARKER_CONTEXT("SkGpuDevice", "drawProducerNine", fContext);

    CHECK_SHOULD_DRAW(draw);

    bool useFallback = paint.getMaskFilter() || paint.isAntiAlias() ||
                       fDrawContext->isUnifiedMultisampled();
    bool doBicubic;
    GrTextureParams::FilterMode textureFilterMode =
        GrSkFilterQualityToGrFilterMode(paint.getFilterQuality(), *draw.fMatrix, SkMatrix::I(),
                                        &doBicubic);
    if (useFallback || doBicubic || GrTextureParams::kNone_FilterMode != textureFilterMode) {
        SkLatticeIter iter(producer->width(), producer->height(), center, dst);

        SkRect srcR, dstR;
        while (iter.next(&srcR, &dstR)) {
            this->drawTextureProducer(producer, &srcR, &dstR, SkCanvas::kStrict_SrcRectConstraint,
                                      *draw.fMatrix, fClip, paint);
        }
        return;
    }

    static const GrTextureParams::FilterMode kMode = GrTextureParams::kNone_FilterMode;
    sk_sp<GrFragmentProcessor> fp(
        producer->createFragmentProcessor(SkMatrix::I(),
                                          SkRect::MakeIWH(producer->width(), producer->height()),
                                          GrTextureProducer::kNo_FilterConstraint, true,
                                          &kMode, fDrawContext->getColorSpace(),
                                          fDrawContext->sourceGammaTreatment()));
    GrPaint grPaint;
    if (!SkPaintToGrPaintWithTexture(this->context(), fDrawContext.get(), paint, *draw.fMatrix,
                                     std::move(fp), producer->isAlphaOnly(), &grPaint)) {
        return;
    }

    std::unique_ptr<SkLatticeIter> iter(
            new SkLatticeIter(producer->width(), producer->height(), center, dst));
    fDrawContext->drawImageLattice(fClip, grPaint, *draw.fMatrix, producer->width(),
                                   producer->height(), std::move(iter), dst);
}

void SkGpuDevice::drawImageNine(const SkDraw& draw, const SkImage* image,
                                const SkIRect& center, const SkRect& dst, const SkPaint& paint) {
    ASSERT_SINGLE_OWNER
    uint32_t pinnedUniqueID;
    if (sk_sp<GrTexture> tex = as_IB(image)->refPinnedTexture(&pinnedUniqueID)) {
        CHECK_SHOULD_DRAW(draw);
        GrTextureAdjuster adjuster(tex.get(), image->alphaType(), image->bounds(), pinnedUniqueID,
                                   as_IB(image)->onImageInfo().colorSpace());
        this->drawProducerNine(draw, &adjuster, center, dst, paint);
    } else {
        SkBitmap bm;
        if (SkImageCacherator* cacher = as_IB(image)->peekCacherator()) {
            GrImageTextureMaker maker(fContext, cacher, image, SkImage::kAllow_CachingHint);
            this->drawProducerNine(draw, &maker, center, dst, paint);
        } else if (as_IB(image)->getROPixels(&bm)) {
            this->drawBitmapNine(draw, bm, center, dst, paint);
        }
    }
}

void SkGpuDevice::drawBitmapNine(const SkDraw& draw, const SkBitmap& bitmap, const SkIRect& center,
                                 const SkRect& dst, const SkPaint& paint) {
    ASSERT_SINGLE_OWNER
    GrBitmapTextureMaker maker(fContext, bitmap);
    this->drawProducerNine(draw, &maker, center, dst, paint);
}

void SkGpuDevice::drawProducerLattice(const SkDraw& draw, GrTextureProducer* producer,
                                      const SkCanvas::Lattice& lattice, const SkRect& dst,
                                      const SkPaint& paint) {
    GR_CREATE_TRACE_MARKER_CONTEXT("SkGpuDevice", "drawProducerLattice", fContext);

    CHECK_SHOULD_DRAW(draw);

    static const GrTextureParams::FilterMode kMode = GrTextureParams::kNone_FilterMode;
    sk_sp<GrFragmentProcessor> fp(
        producer->createFragmentProcessor(SkMatrix::I(),
                                          SkRect::MakeIWH(producer->width(), producer->height()),
                                          GrTextureProducer::kNo_FilterConstraint, true,
                                          &kMode, fDrawContext->getColorSpace(),
                                          fDrawContext->sourceGammaTreatment()));
    GrPaint grPaint;
    if (!SkPaintToGrPaintWithTexture(this->context(), fDrawContext.get(), paint, *draw.fMatrix,
                                     std::move(fp), producer->isAlphaOnly(), &grPaint)) {
        return;
    }

    std::unique_ptr<SkLatticeIter> iter(
            new SkLatticeIter(lattice, dst));
    fDrawContext->drawImageLattice(fClip, grPaint, *draw.fMatrix, producer->width(),
                                   producer->height(), std::move(iter), dst);
}

void SkGpuDevice::drawImageLattice(const SkDraw& draw, const SkImage* image,
                                   const SkCanvas::Lattice& lattice, const SkRect& dst,
                                   const SkPaint& paint) {
    ASSERT_SINGLE_OWNER
    uint32_t pinnedUniqueID;
    if (sk_sp<GrTexture> tex = as_IB(image)->refPinnedTexture(&pinnedUniqueID)) {
        CHECK_SHOULD_DRAW(draw);
        GrTextureAdjuster adjuster(tex.get(), image->alphaType(), image->bounds(), pinnedUniqueID,
                                   as_IB(image)->onImageInfo().colorSpace());
        this->drawProducerLattice(draw, &adjuster, lattice, dst, paint);
    } else {
        SkBitmap bm;
        if (SkImageCacherator* cacher = as_IB(image)->peekCacherator()) {
            GrImageTextureMaker maker(fContext, cacher, image, SkImage::kAllow_CachingHint);
            this->drawProducerLattice(draw, &maker, lattice, dst, paint);
        } else if (as_IB(image)->getROPixels(&bm)) {
            this->drawBitmapLattice(draw, bm, lattice, dst, paint);
        }
    }
}

void SkGpuDevice::drawBitmapLattice(const SkDraw& draw, const SkBitmap& bitmap,
                                    const SkCanvas::Lattice& lattice, const SkRect& dst,
                                    const SkPaint& paint) {
    ASSERT_SINGLE_OWNER
    GrBitmapTextureMaker maker(fContext, bitmap);
    this->drawProducerLattice(draw, &maker, lattice, dst, paint);
}

///////////////////////////////////////////////////////////////////////////////

// must be in SkCanvas::VertexMode order
static const GrPrimitiveType gVertexMode2PrimitiveType[] = {
    kTriangles_GrPrimitiveType,
    kTriangleStrip_GrPrimitiveType,
    kTriangleFan_GrPrimitiveType,
};

void SkGpuDevice::drawVertices(const SkDraw& draw, SkCanvas::VertexMode vmode,
                              int vertexCount, const SkPoint vertices[],
                              const SkPoint texs[], const SkColor colors[],
                              SkXfermode* xmode,
                              const uint16_t indices[], int indexCount,
                              const SkPaint& paint) {
    ASSERT_SINGLE_OWNER
    CHECK_SHOULD_DRAW(draw);
    GR_CREATE_TRACE_MARKER_CONTEXT("SkGpuDevice", "drawVertices", fContext);

    // If both textures and vertex-colors are nullptr, strokes hairlines with the paint's color.
    if ((nullptr == texs || nullptr == paint.getShader()) && nullptr == colors) {

        texs = nullptr;

        SkPaint copy(paint);
        copy.setStyle(SkPaint::kStroke_Style);
        copy.setStrokeWidth(0);

        GrPaint grPaint;
        // we ignore the shader if texs is null.
        if (!SkPaintToGrPaintNoShader(this->context(), fDrawContext.get(), copy, &grPaint)) {
            return;
        }

        int triangleCount = 0;
        int n = (nullptr == indices) ? vertexCount : indexCount;
        switch (vmode) {
            case SkCanvas::kTriangles_VertexMode:
                triangleCount = n / 3;
                break;
            case SkCanvas::kTriangleStrip_VertexMode:
            case SkCanvas::kTriangleFan_VertexMode:
                triangleCount = n - 2;
                break;
        }

        VertState       state(vertexCount, indices, indexCount);
        VertState::Proc vertProc = state.chooseProc(vmode);

        //number of indices for lines per triangle with kLines
        indexCount = triangleCount * 6;

        SkAutoTDeleteArray<uint16_t> lineIndices(new uint16_t[indexCount]);
        int i = 0;
        while (vertProc(&state)) {
            lineIndices[i]     = state.f0;
            lineIndices[i + 1] = state.f1;
            lineIndices[i + 2] = state.f1;
            lineIndices[i + 3] = state.f2;
            lineIndices[i + 4] = state.f2;
            lineIndices[i + 5] = state.f0;
            i += 6;
        }
        fDrawContext->drawVertices(fClip,
                                   grPaint,
                                   *draw.fMatrix,
                                   kLines_GrPrimitiveType,
                                   vertexCount,
                                   vertices,
                                   texs,
                                   colors,
                                   lineIndices.get(),
                                   indexCount);
        return;
    }

    GrPrimitiveType primType = gVertexMode2PrimitiveType[vmode];

    SkAutoSTMalloc<128, GrColor> convertedColors(0);
    if (colors) {
        // need to convert byte order and from non-PM to PM. TODO: Keep unpremul until after
        // interpolation.
        convertedColors.reset(vertexCount);
        for (int i = 0; i < vertexCount; ++i) {
            convertedColors[i] = SkColorToPremulGrColor(colors[i]);
        }
        colors = convertedColors.get();
    }
    GrPaint grPaint;
    if (texs && paint.getShader()) {
        if (colors) {
            // When there are texs and colors the shader and colors are combined using xmode. A null
            // xmode is defined to mean modulate.
            SkXfermode::Mode colorMode;
            if (xmode) {
                if (!xmode->asMode(&colorMode)) {
                    return;
                }
            } else {
                colorMode = SkXfermode::kModulate_Mode;
            }
            if (!SkPaintToGrPaintWithXfermode(this->context(), fDrawContext.get(), paint,
                                              *draw.fMatrix, colorMode, false, &grPaint)) {
                return;
            }
        } else {
            // We have a shader, but no colors to blend it against.
            if (!SkPaintToGrPaint(this->context(), fDrawContext.get(), paint, *draw.fMatrix,
                                  &grPaint)) {
                return;
            }
        }
    } else {
        if (colors) {
            // We have colors, but either have no shader or no texture coords (which implies that
            // we should ignore the shader).
            if (!SkPaintToGrPaintWithPrimitiveColor(this->context(), fDrawContext.get(), paint,
                                                    &grPaint)) {
                return;
            }
        } else {
            // No colors and no shaders. Just draw with the paint color.
            if (!SkPaintToGrPaintNoShader(this->context(), fDrawContext.get(), paint, &grPaint)) {
                return;
            }
        }
    }

    fDrawContext->drawVertices(fClip,
                               grPaint,
                               *draw.fMatrix,
                               primType,
                               vertexCount,
                               vertices,
                               texs,
                               colors,
                               indices,
                               indexCount);
}

///////////////////////////////////////////////////////////////////////////////

void SkGpuDevice::drawAtlas(const SkDraw& draw, const SkImage* atlas, const SkRSXform xform[],
                            const SkRect texRect[], const SkColor colors[], int count,
                            SkXfermode::Mode mode, const SkPaint& paint) {
    ASSERT_SINGLE_OWNER
    if (paint.isAntiAlias()) {
        this->INHERITED::drawAtlas(draw, atlas, xform, texRect, colors, count, mode, paint);
        return;
    }

    CHECK_SHOULD_DRAW(draw);
    GR_CREATE_TRACE_MARKER_CONTEXT("SkGpuDevice", "drawText", fContext);

    SkPaint p(paint);
    p.setShader(atlas->makeShader(SkShader::kClamp_TileMode, SkShader::kClamp_TileMode));

    GrPaint grPaint;
    if (colors) {
        if (!SkPaintToGrPaintWithXfermode(this->context(), fDrawContext.get(), p, *draw.fMatrix,
                                          mode, true, &grPaint)) {
            return;
        }
    } else {
        if (!SkPaintToGrPaint(this->context(), fDrawContext.get(), p, *draw.fMatrix, &grPaint)) {
            return;
        }
    }

    SkDEBUGCODE(this->validate();)
    fDrawContext->drawAtlas(fClip, grPaint, *draw.fMatrix, count, xform, texRect, colors);
}

///////////////////////////////////////////////////////////////////////////////

void SkGpuDevice::drawText(const SkDraw& draw, const void* text,
                           size_t byteLength, SkScalar x, SkScalar y,
                           const SkPaint& paint) {
    ASSERT_SINGLE_OWNER
    CHECK_SHOULD_DRAW(draw);
    GR_CREATE_TRACE_MARKER_CONTEXT("SkGpuDevice", "drawText", fContext);

    GrPaint grPaint;
    if (!SkPaintToGrPaint(this->context(), fDrawContext.get(), paint, *draw.fMatrix, &grPaint)) {
        return;
    }

    SkDEBUGCODE(this->validate();)

    fDrawContext->drawText(fClip, grPaint, paint, *draw.fMatrix,
                           (const char *)text, byteLength, x, y, draw.fRC->getBounds());
}

void SkGpuDevice::drawPosText(const SkDraw& draw, const void* text, size_t byteLength,
                              const SkScalar pos[], int scalarsPerPos,
                              const SkPoint& offset, const SkPaint& paint) {
    ASSERT_SINGLE_OWNER
    GR_CREATE_TRACE_MARKER_CONTEXT("SkGpuDevice", "drawPosText", fContext);
    CHECK_SHOULD_DRAW(draw);

    GrPaint grPaint;
    if (!SkPaintToGrPaint(this->context(), fDrawContext.get(), paint, *draw.fMatrix, &grPaint)) {
        return;
    }

    SkDEBUGCODE(this->validate();)

    fDrawContext->drawPosText(fClip, grPaint, paint, *draw.fMatrix,
                              (const char *)text, byteLength, pos, scalarsPerPos, offset,
                              draw.fRC->getBounds());
}

void SkGpuDevice::drawTextBlob(const SkDraw& draw, const SkTextBlob* blob, SkScalar x, SkScalar y,
                               const SkPaint& paint, SkDrawFilter* drawFilter) {
    ASSERT_SINGLE_OWNER
    GR_CREATE_TRACE_MARKER_CONTEXT("SkGpuDevice", "drawTextBlob", fContext);
    CHECK_SHOULD_DRAW(draw);

    SkDEBUGCODE(this->validate();)

    fDrawContext->drawTextBlob(fClip, paint, *draw.fMatrix,
                               blob, x, y, drawFilter, draw.fRC->getBounds());
}

///////////////////////////////////////////////////////////////////////////////

bool SkGpuDevice::onShouldDisableLCD(const SkPaint& paint) const {
    return GrTextUtils::ShouldDisableLCD(paint);
}

void SkGpuDevice::flush() {
    ASSERT_SINGLE_OWNER

    fDrawContext->prepareForExternalIO();
}

///////////////////////////////////////////////////////////////////////////////

SkBaseDevice* SkGpuDevice::onCreateDevice(const CreateInfo& cinfo, const SkPaint*) {
    ASSERT_SINGLE_OWNER

    SkSurfaceProps props(this->surfaceProps().flags(), cinfo.fPixelGeometry);

    // layers are never drawn in repeat modes, so we can request an approx
    // match and ignore any padding.
    SkBackingFit fit = kNever_TileUsage == cinfo.fTileUsage ? SkBackingFit::kApprox
                                                            : SkBackingFit::kExact;

    sk_sp<GrDrawContext> dc(fContext->makeDrawContext(fit,
                                                      cinfo.fInfo.width(), cinfo.fInfo.height(),
                                                      fDrawContext->config(),
                                                      sk_ref_sp(fDrawContext->getColorSpace()),
                                                      fDrawContext->desc().fSampleCnt,
                                                      kDefault_GrSurfaceOrigin,
                                                      &props));
    if (!dc) {
        SkErrorInternals::SetError( kInternalError_SkError,
                                    "---- failed to create gpu device texture [%d %d]\n",
                                    cinfo.fInfo.width(), cinfo.fInfo.height());
        return nullptr;    
    }

    // Skia's convention is to only clear a device if it is non-opaque.
    InitContents init = cinfo.fInfo.isOpaque() ? kUninit_InitContents : kClear_InitContents;

    return SkGpuDevice::Make(std::move(dc),
                             cinfo.fInfo.width(), cinfo.fInfo.height(),
                             init).release();
}

sk_sp<SkSurface> SkGpuDevice::makeSurface(const SkImageInfo& info, const SkSurfaceProps& props) {
    ASSERT_SINGLE_OWNER
    // TODO: Change the signature of newSurface to take a budgeted parameter.
    static const SkBudgeted kBudgeted = SkBudgeted::kNo;
    return SkSurface::MakeRenderTarget(fContext, kBudgeted, info, fDrawContext->desc().fSampleCnt,
                                       fDrawContext->origin(), &props);
}

SkImageFilterCache* SkGpuDevice::getImageFilterCache() {
    ASSERT_SINGLE_OWNER
    // We always return a transient cache, so it is freed after each
    // filter traversal.
    return SkImageFilterCache::Create(SkImageFilterCache::kDefaultTransientSize);
}

#endif
