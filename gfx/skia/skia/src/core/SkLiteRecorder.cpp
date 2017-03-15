/*
 * Copyright 2016 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "SkLiteDL.h"
#include "SkLiteRecorder.h"
#include "SkSurface.h"

SkLiteRecorder::SkLiteRecorder()
    : SkCanvas({0,0,1,1}, SkCanvas::kConservativeRasterClip_InitFlag)
    , fDL(nullptr) {}

void SkLiteRecorder::reset(SkLiteDL* dl) {
    this->resetForNextPicture(dl->getBounds().roundOut());
    fDL = dl;
}

sk_sp<SkSurface> SkLiteRecorder::onNewSurface(const SkImageInfo&, const SkSurfaceProps&) {
    return nullptr;
}

#ifdef SK_SUPPORT_LEGACY_DRAWFILTER
SkDrawFilter* SkLiteRecorder::setDrawFilter(SkDrawFilter* df) {
    fDL->setDrawFilter(df);
    return SkCanvas::setDrawFilter(df);
}
#endif

void SkLiteRecorder::willSave() { fDL->save(); }
SkCanvas::SaveLayerStrategy SkLiteRecorder::getSaveLayerStrategy(const SaveLayerRec& rec) {
    fDL->saveLayer(rec.fBounds, rec.fPaint, rec.fBackdrop, rec.fSaveLayerFlags);
    return SkCanvas::kNoLayer_SaveLayerStrategy;
}
void SkLiteRecorder::willRestore() { fDL->restore(); }

void SkLiteRecorder::didConcat   (const SkMatrix& matrix)   { fDL->   concat(matrix); }
void SkLiteRecorder::didSetMatrix(const SkMatrix& matrix)   { fDL->setMatrix(matrix); }
void SkLiteRecorder::didTranslate(SkScalar dx, SkScalar dy) { fDL->translate(dx, dy); }

void SkLiteRecorder::onClipRect(const SkRect& rect, ClipOp op, ClipEdgeStyle style) {
    fDL->clipRect(rect, op, style==kSoft_ClipEdgeStyle);
    SkCanvas::onClipRect(rect, op, style);
}
void SkLiteRecorder::onClipRRect(const SkRRect& rrect, ClipOp op, ClipEdgeStyle style) {
    fDL->clipRRect(rrect, op, style==kSoft_ClipEdgeStyle);
    SkCanvas::onClipRRect(rrect, op, style);
}
void SkLiteRecorder::onClipPath(const SkPath& path, ClipOp op, ClipEdgeStyle style) {
    fDL->clipPath(path, op, style==kSoft_ClipEdgeStyle);
    SkCanvas::onClipPath(path, op, style);
}
void SkLiteRecorder::onClipRegion(const SkRegion& region, ClipOp op) {
    fDL->clipRegion(region, op);
    SkCanvas::onClipRegion(region, op);
}

void SkLiteRecorder::onDrawPaint(const SkPaint& paint) {
    fDL->drawPaint(paint);
}
void SkLiteRecorder::onDrawPath(const SkPath& path, const SkPaint& paint) {
    fDL->drawPath(path, paint);
}
void SkLiteRecorder::onDrawRect(const SkRect& rect, const SkPaint& paint) {
    fDL->drawRect(rect, paint);
}
void SkLiteRecorder::onDrawRegion(const SkRegion& region, const SkPaint& paint) {
    fDL->drawRegion(region, paint);
}
void SkLiteRecorder::onDrawOval(const SkRect& oval, const SkPaint& paint) {
    fDL->drawOval(oval, paint);
}
void SkLiteRecorder::onDrawArc(const SkRect& oval, SkScalar startAngle, SkScalar sweepAngle,
                               bool useCenter, const SkPaint& paint) {
    fDL->drawArc(oval, startAngle, sweepAngle, useCenter, paint);
}
void SkLiteRecorder::onDrawRRect(const SkRRect& rrect, const SkPaint& paint) {
    fDL->drawRRect(rrect, paint);
}
void SkLiteRecorder::onDrawDRRect(const SkRRect& out, const SkRRect& in, const SkPaint& paint) {
    fDL->drawDRRect(out, in, paint);
}

void SkLiteRecorder::onDrawDrawable(SkDrawable* drawable, const SkMatrix* matrix) {
    fDL->drawDrawable(drawable, matrix);
}
void SkLiteRecorder::onDrawPicture(const SkPicture* picture,
                                   const SkMatrix* matrix,
                                   const SkPaint* paint) {
    fDL->drawPicture(picture, matrix, paint);
}
void SkLiteRecorder::onDrawAnnotation(const SkRect& rect, const char key[], SkData* val) {
    fDL->drawAnnotation(rect, key, val);
}

void SkLiteRecorder::onDrawText(const void* text, size_t bytes,
                                SkScalar x, SkScalar y,
                                const SkPaint& paint) {
    fDL->drawText(text, bytes, x, y, paint);
}
void SkLiteRecorder::onDrawPosText(const void* text, size_t bytes,
                                   const SkPoint pos[],
                                   const SkPaint& paint) {
    fDL->drawPosText(text, bytes, pos, paint);
}
void SkLiteRecorder::onDrawPosTextH(const void* text, size_t bytes,
                                    const SkScalar xs[], SkScalar y,
                                    const SkPaint& paint) {
    fDL->drawPosTextH(text, bytes, xs, y, paint);
}
void SkLiteRecorder::onDrawTextOnPath(const void* text, size_t bytes,
                                      const SkPath& path, const SkMatrix* matrix,
                                      const SkPaint& paint) {
    fDL->drawTextOnPath(text, bytes, path, matrix, paint);
}
void SkLiteRecorder::onDrawTextRSXform(const void* text, size_t bytes,
                                       const SkRSXform xform[], const SkRect* cull,
                                       const SkPaint& paint) {
    fDL->drawTextRSXform(text, bytes, xform, cull, paint);
}
void SkLiteRecorder::onDrawTextBlob(const SkTextBlob* blob,
                                    SkScalar x, SkScalar y,
                                    const SkPaint& paint) {
    fDL->drawTextBlob(blob, x,y, paint);
}

void SkLiteRecorder::onDrawBitmap(const SkBitmap& bm,
                                  SkScalar x, SkScalar y,
                                  const SkPaint* paint) {
    fDL->drawImage(SkImage::MakeFromBitmap(bm), x,y, paint);
}
void SkLiteRecorder::onDrawBitmapNine(const SkBitmap& bm,
                                      const SkIRect& center, const SkRect& dst,
                                      const SkPaint* paint) {
    fDL->drawImageNine(SkImage::MakeFromBitmap(bm), center, dst, paint);
}
void SkLiteRecorder::onDrawBitmapRect(const SkBitmap& bm,
                                      const SkRect* src, const SkRect& dst,
                                      const SkPaint* paint, SrcRectConstraint constraint) {
    fDL->drawImageRect(SkImage::MakeFromBitmap(bm), src, dst, paint, constraint);
}
void SkLiteRecorder::onDrawBitmapLattice(const SkBitmap& bm,
                                         const SkCanvas::Lattice& lattice, const SkRect& dst,
                                         const SkPaint* paint) {
    fDL->drawImageLattice(SkImage::MakeFromBitmap(bm), lattice, dst, paint);
}

void SkLiteRecorder::onDrawImage(const SkImage* img,
                                  SkScalar x, SkScalar y,
                                  const SkPaint* paint) {
    fDL->drawImage(sk_ref_sp(img), x,y, paint);
}
void SkLiteRecorder::onDrawImageNine(const SkImage* img,
                                      const SkIRect& center, const SkRect& dst,
                                      const SkPaint* paint) {
    fDL->drawImageNine(sk_ref_sp(img), center, dst, paint);
}
void SkLiteRecorder::onDrawImageRect(const SkImage* img,
                                      const SkRect* src, const SkRect& dst,
                                      const SkPaint* paint, SrcRectConstraint constraint) {
    fDL->drawImageRect(sk_ref_sp(img), src, dst, paint, constraint);
}
void SkLiteRecorder::onDrawImageLattice(const SkImage* img,
                                        const SkCanvas::Lattice& lattice, const SkRect& dst,
                                        const SkPaint* paint) {
    fDL->drawImageLattice(sk_ref_sp(img), lattice, dst, paint);
}


void SkLiteRecorder::onDrawPatch(const SkPoint cubics[12],
                                 const SkColor colors[4], const SkPoint texCoords[4],
                                 SkXfermode* xfermode, const SkPaint& paint) {
    fDL->drawPatch(cubics, colors, texCoords, xfermode, paint);
}
void SkLiteRecorder::onDrawPoints(SkCanvas::PointMode mode,
                                  size_t count, const SkPoint pts[],
                                  const SkPaint& paint) {
    fDL->drawPoints(mode, count, pts, paint);
}
void SkLiteRecorder::onDrawVertices(SkCanvas::VertexMode mode,
                                    int count, const SkPoint vertices[],
                                    const SkPoint texs[], const SkColor colors[],
                                    SkXfermode* xfermode,
                                    const uint16_t indices[], int indexCount,
                                    const SkPaint& paint) {
    fDL->drawVertices(mode, count, vertices, texs, colors, xfermode, indices, indexCount, paint);
}
void SkLiteRecorder::onDrawAtlas(const SkImage* atlas,
                                 const SkRSXform xforms[],
                                 const SkRect texs[],
                                 const SkColor colors[],
                                 int count,
                                 SkXfermode::Mode xfermode,
                                 const SkRect* cull,
                                 const SkPaint* paint) {
    fDL->drawAtlas(atlas, xforms, texs, colors, count, xfermode, cull, paint);
}

void SkLiteRecorder::didTranslateZ(SkScalar dz) {
    fDL->translateZ(dz);
}
void SkLiteRecorder::onDrawShadowedPicture(const SkPicture* picture,
                                           const SkMatrix* matrix,
                                           const SkPaint* paint,
                                           const SkShadowParams& params) {
    fDL->drawShadowedPicture(picture, matrix, paint, params);
}
