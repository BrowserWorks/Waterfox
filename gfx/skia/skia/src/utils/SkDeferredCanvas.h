
/*
 * Copyright 2016 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#ifndef SkDeferredCanvas_DEFINED
#define SkDeferredCanvas_DEFINED

#include "../private/SkTDArray.h"
#include "SkCanvas.h"

class SK_API SkDeferredCanvas : public SkCanvas {
public:
    SkDeferredCanvas(SkCanvas*);
    ~SkDeferredCanvas() override;

#ifdef SK_SUPPORT_LEGACY_DRAWFILTER
    SkDrawFilter* setDrawFilter(SkDrawFilter*) override;
#endif

protected:
    sk_sp<SkSurface> onNewSurface(const SkImageInfo&, const SkSurfaceProps&) override;
    SkISize getBaseLayerSize() const override;
    bool getClipBounds(SkRect* bounds) const override;
    bool getClipDeviceBounds(SkIRect* bounds) const override;
    bool isClipEmpty() const override;
    bool isClipRect() const override;
    bool onPeekPixels(SkPixmap*) override;
    bool onAccessTopLayerPixels(SkPixmap*) override;
    SkImageInfo onImageInfo() const override;
    bool onGetProps(SkSurfaceProps*) const override;
    void onFlush() override;
//    SkCanvas* canvasForDrawIter() override;

    void willSave() override;
    SaveLayerStrategy getSaveLayerStrategy(const SaveLayerRec&) override;
    void willRestore() override;

    void didConcat(const SkMatrix&) override;
    void didSetMatrix(const SkMatrix&) override;

    void onDrawDRRect(const SkRRect&, const SkRRect&, const SkPaint&) override;
    virtual void onDrawText(const void* text, size_t byteLength, SkScalar x, SkScalar y,
                            const SkPaint&) override;
    virtual void onDrawPosText(const void* text, size_t byteLength, const SkPoint pos[],
                               const SkPaint&) override;
    virtual void onDrawPosTextH(const void* text, size_t byteLength, const SkScalar xpos[],
                                SkScalar constY, const SkPaint&) override;
    virtual void onDrawTextOnPath(const void* text, size_t byteLength, const SkPath& path,
                                  const SkMatrix* matrix, const SkPaint&) override;
    void onDrawTextRSXform(const void* text, size_t byteLength, const SkRSXform[],
                           const SkRect* cullRect, const SkPaint&) override;
    virtual void onDrawTextBlob(const SkTextBlob* blob, SkScalar x, SkScalar y,
                                const SkPaint& paint) override;
    virtual void onDrawPatch(const SkPoint cubics[12], const SkColor colors[4],
                             const SkPoint texCoords[4], SkXfermode* xmode,
                             const SkPaint& paint) override;

    void onDrawPaint(const SkPaint&) override;
    void onDrawPoints(PointMode, size_t count, const SkPoint pts[], const SkPaint&) override;
    void onDrawRect(const SkRect&, const SkPaint&) override;
    void onDrawRegion(const SkRegion& region, const SkPaint& paint) override;
    void onDrawOval(const SkRect&, const SkPaint&) override;
    void onDrawArc(const SkRect&, SkScalar, SkScalar, bool, const SkPaint&) override;
    void onDrawRRect(const SkRRect&, const SkPaint&) override;
    void onDrawPath(const SkPath&, const SkPaint&) override;

    void onDrawBitmap(const SkBitmap&, SkScalar left, SkScalar top, const SkPaint*) override;
    void onDrawBitmapLattice(const SkBitmap&, const Lattice& lattice, const SkRect& dst,
                             const SkPaint*) override;
    void onDrawBitmapNine(const SkBitmap&, const SkIRect& center, const SkRect& dst,
                          const SkPaint*) override;
    void onDrawBitmapRect(const SkBitmap&, const SkRect* src, const SkRect& dst, const SkPaint*,
                          SrcRectConstraint) override;

    void onDrawImage(const SkImage*, SkScalar left, SkScalar top, const SkPaint*) override;
    void onDrawImageLattice(const SkImage*, const Lattice& lattice, const SkRect& dst,
                            const SkPaint*) override;
    void onDrawImageNine(const SkImage* image, const SkIRect& center,
                         const SkRect& dst, const SkPaint*) override;
    void onDrawImageRect(const SkImage*, const SkRect* src, const SkRect& dst,
                         const SkPaint*, SrcRectConstraint) override;

    void onDrawVertices(VertexMode vmode, int vertexCount,
                              const SkPoint vertices[], const SkPoint texs[],
                              const SkColor colors[], SkXfermode* xmode,
                              const uint16_t indices[], int indexCount,
                              const SkPaint&) override;
    void onDrawAtlas(const SkImage* image, const SkRSXform xform[],
                     const SkRect rects[], const SkColor colors[],
                     int count, SkXfermode::Mode mode,
                     const SkRect* cull, const SkPaint* paint) override;

    void onClipRect(const SkRect&, ClipOp, ClipEdgeStyle) override;
    void onClipRRect(const SkRRect&, ClipOp, ClipEdgeStyle) override;
    void onClipPath(const SkPath&, ClipOp, ClipEdgeStyle) override;
    void onClipRegion(const SkRegion&, ClipOp) override;

    void onDrawDrawable(SkDrawable*, const SkMatrix*) override;
    void onDrawPicture(const SkPicture*, const SkMatrix*, const SkPaint*) override;
    void onDrawAnnotation(const SkRect&, const char[], SkData*) override;

    class Iter;

private:
    SkCanvas* fCanvas;

    enum Type {
        kSave_Type,
        kClipRect_Type,
        kTrans_Type,
        kScaleTrans_Type,
    };
    struct Rec {
        Type    fType;
        union {
            SkRect      fBounds;
            SkVector    fTranslate;
            struct {
                SkVector    fScale;
                SkVector    fTrans; // post translate
            } fScaleTrans;
        } fData;

        bool isConcat(SkMatrix*) const;
        void getConcat(SkMatrix* mat) const {
            SkDEBUGCODE(bool isconcat = ) this->isConcat(mat);
            SkASSERT(isconcat);
        }
        void setConcat(const SkMatrix&);
    };
    SkTDArray<Rec>  fRecs;

    void push_save();
    void push_cliprect(const SkRect&);
    bool push_concat(const SkMatrix&);
    
    void emit(const Rec& rec);

    void flush_all();
    void flush_before_saves();
    void flush_le(int index);
    void flush_translate(SkScalar* x, SkScalar* y, const SkPaint&);
    void flush_translate(SkScalar* x, SkScalar* y, const SkRect& bounds, const SkPaint* = nullptr);
    void flush_check(SkRect* bounds, const SkPaint*, unsigned flags = 0);

    void internal_flush_translate(SkScalar* x, SkScalar* y, const SkRect* boundsOrNull);

    typedef SkCanvas INHERITED;
};


#endif
