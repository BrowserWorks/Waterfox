/*
 * Copyright 2010 The Android Open Source Project
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#ifndef SkDevice_DEFINED
#define SkDevice_DEFINED

#include "SkRefCnt.h"
#include "SkCanvas.h"
#include "SkColor.h"
#include "SkSurfaceProps.h"

class SkBitmap;
class SkClipStack;
class SkDraw;
class SkDrawFilter;
class SkImageFilterCache;
struct SkIRect;
class SkMatrix;
class SkMetaData;
class SkRegion;
class SkSpecialImage;
class GrRenderTarget;

class SK_API SkBaseDevice : public SkRefCnt {
public:
    /**
     *  Construct a new device.
    */
    explicit SkBaseDevice(const SkImageInfo&, const SkSurfaceProps&);
    virtual ~SkBaseDevice();

    SkMetaData& getMetaData();

    /**
     *  Return ImageInfo for this device. If the canvas is not backed by pixels
     *  (cpu or gpu), then the info's ColorType will be kUnknown_SkColorType.
     */
    const SkImageInfo& imageInfo() const { return fInfo; }

    /**
     *  Return SurfaceProps for this device.
     */
    const SkSurfaceProps& surfaceProps() const {
        return fSurfaceProps;
    }

    /**
     *  Return the bounds of the device in the coordinate space of the root
     *  canvas. The root device will have its top-left at 0,0, but other devices
     *  such as those associated with saveLayer may have a non-zero origin.
     */
    void getGlobalBounds(SkIRect* bounds) const {
        SkASSERT(bounds);
        const SkIPoint& origin = this->getOrigin();
        bounds->setXYWH(origin.x(), origin.y(), this->width(), this->height());
    }

    SkIRect getGlobalBounds() const {
        SkIRect bounds;
        this->getGlobalBounds(&bounds);
        return bounds;
    }

    int width() const {
        return this->imageInfo().width();
    }

    int height() const {
        return this->imageInfo().height();
    }

    bool isOpaque() const {
        return this->imageInfo().isOpaque();
    }

#ifdef SK_SUPPORT_LEGACY_ACCESSBITMAP
    /** Return the bitmap associated with this device. Call this each time you need
        to access the bitmap, as it notifies the subclass to perform any flushing
        etc. before you examine the pixels.
        @param changePixels set to true if the caller plans to change the pixels
        @return the device's bitmap
    */
    const SkBitmap& accessBitmap(bool changePixels);
#endif

    bool writePixels(const SkImageInfo&, const void*, size_t rowBytes, int x, int y);

    /**
     *  Try to get write-access to the pixels behind the device. If successful, this returns true
     *  and fills-out the pixmap parameter. On success it also bumps the genID of the underlying
     *  bitmap.
     *
     *  On failure, returns false and ignores the pixmap parameter.
     */
    bool accessPixels(SkPixmap* pmap);

    /**
     *  Try to get read-only-access to the pixels behind the device. If successful, this returns
     *  true and fills-out the pixmap parameter.
     *
     *  On failure, returns false and ignores the pixmap parameter.
     */
    bool peekPixels(SkPixmap*);

    /**
     *  Return the device's origin: its offset in device coordinates from
     *  the default origin in its canvas' matrix/clip
     */
    const SkIPoint& getOrigin() const { return fOrigin; }

protected:
    enum TileUsage {
        kPossible_TileUsage,    //!< the created device may be drawn tiled
        kNever_TileUsage,       //!< the created device will never be drawn tiled
    };

    struct TextFlags {
        uint32_t    fFlags;     // SkPaint::getFlags()
    };

    /**
     * Returns the text-related flags, possibly modified based on the state of the
     * device (e.g. support for LCD).
     */
    uint32_t filterTextFlags(const SkPaint&) const;

    virtual bool onShouldDisableLCD(const SkPaint&) const { return false; }

    /** These are called inside the per-device-layer loop for each draw call.
     When these are called, we have already applied any saveLayer operations,
     and are handling any looping from the paint, and any effects from the
     DrawFilter.
     */
    virtual void drawPaint(const SkDraw&, const SkPaint& paint) = 0;
    virtual void drawPoints(const SkDraw&, SkCanvas::PointMode mode, size_t count,
                            const SkPoint[], const SkPaint& paint) = 0;
    virtual void drawRect(const SkDraw&, const SkRect& r,
                          const SkPaint& paint) = 0;
    virtual void drawRegion(const SkDraw&, const SkRegion& r,
                            const SkPaint& paint);
    virtual void drawOval(const SkDraw&, const SkRect& oval,
                          const SkPaint& paint) = 0;
    /** By the time this is called we know that abs(sweepAngle) is in the range [0, 360). */
    virtual void drawArc(const SkDraw&, const SkRect& oval, SkScalar startAngle,
                         SkScalar sweepAngle, bool useCenter, const SkPaint& paint);
    virtual void drawRRect(const SkDraw&, const SkRRect& rr,
                           const SkPaint& paint) = 0;

    // Default impl calls drawPath()
    virtual void drawDRRect(const SkDraw&, const SkRRect& outer,
                            const SkRRect& inner, const SkPaint&);

    /**
     *  If pathIsMutable, then the implementation is allowed to cast path to a
     *  non-const pointer and modify it in place (as an optimization). Canvas
     *  may do this to implement helpers such as drawOval, by placing a temp
     *  path on the stack to hold the representation of the oval.
     *
     *  If prePathMatrix is not null, it should logically be applied before any
     *  stroking or other effects. If there are no effects on the paint that
     *  affect the geometry/rasterization, then the pre matrix can just be
     *  pre-concated with the current matrix.
     */
    virtual void drawPath(const SkDraw&, const SkPath& path,
                          const SkPaint& paint,
                          const SkMatrix* prePathMatrix = NULL,
                          bool pathIsMutable = false) = 0;
    virtual void drawBitmap(const SkDraw&, const SkBitmap& bitmap,
                            const SkMatrix& matrix, const SkPaint& paint) = 0;
    virtual void drawSprite(const SkDraw&, const SkBitmap& bitmap,
                            int x, int y, const SkPaint& paint) = 0;

    /**
     *  The default impl. will create a bitmap-shader from the bitmap,
     *  and call drawRect with it.
     */
    virtual void drawBitmapRect(const SkDraw&, const SkBitmap&,
                                const SkRect* srcOrNull, const SkRect& dst,
                                const SkPaint& paint,
                                SkCanvas::SrcRectConstraint) = 0;
    virtual void drawBitmapNine(const SkDraw&, const SkBitmap&, const SkIRect& center,
                                const SkRect& dst, const SkPaint&);
    virtual void drawBitmapLattice(const SkDraw&, const SkBitmap&, const SkCanvas::Lattice&,
                                   const SkRect& dst, const SkPaint&);

    virtual void drawImage(const SkDraw&, const SkImage*, SkScalar x, SkScalar y, const SkPaint&);
    virtual void drawImageRect(const SkDraw&, const SkImage*, const SkRect* src, const SkRect& dst,
                               const SkPaint&, SkCanvas::SrcRectConstraint);
    virtual void drawImageNine(const SkDraw&, const SkImage*, const SkIRect& center,
                               const SkRect& dst, const SkPaint&);
    virtual void drawImageLattice(const SkDraw&, const SkImage*, const SkCanvas::Lattice&,
                                  const SkRect& dst, const SkPaint&);

    /**
     *  Does not handle text decoration.
     *  Decorations (underline and stike-thru) will be handled by SkCanvas.
     */
    virtual void drawText(const SkDraw&, const void* text, size_t len,
                          SkScalar x, SkScalar y, const SkPaint& paint) = 0;
    virtual void drawPosText(const SkDraw&, const void* text, size_t len,
                             const SkScalar pos[], int scalarsPerPos,
                             const SkPoint& offset, const SkPaint& paint) = 0;
    virtual void drawVertices(const SkDraw&, SkCanvas::VertexMode, int vertexCount,
                              const SkPoint verts[], const SkPoint texs[],
                              const SkColor colors[], SkXfermode* xmode,
                              const uint16_t indices[], int indexCount,
                              const SkPaint& paint) = 0;
    // default implementation unrolls the blob runs.
    virtual void drawTextBlob(const SkDraw&, const SkTextBlob*, SkScalar x, SkScalar y,
                              const SkPaint& paint, SkDrawFilter* drawFilter);
    // default implementation calls drawVertices
    virtual void drawPatch(const SkDraw&, const SkPoint cubics[12], const SkColor colors[4],
                           const SkPoint texCoords[4], SkXfermode* xmode, const SkPaint& paint);

    // default implementation calls drawPath
    virtual void drawAtlas(const SkDraw&, const SkImage* atlas, const SkRSXform[], const SkRect[],
                           const SkColor[], int count, SkXfermode::Mode, const SkPaint&);

    virtual void drawAnnotation(const SkDraw&, const SkRect&, const char[], SkData*) {}

    /** The SkDevice passed will be an SkDevice which was returned by a call to
        onCreateDevice on this device with kNeverTile_TileExpectation.
     */
    virtual void drawDevice(const SkDraw&, SkBaseDevice*, int x, int y,
                            const SkPaint&) = 0;

    virtual void drawTextOnPath(const SkDraw&, const void* text, size_t len, const SkPath&,
                                const SkMatrix*, const SkPaint&);
    virtual void drawTextRSXform(const SkDraw&, const void* text, size_t len, const SkRSXform[],
                                 const SkPaint&);

    virtual void drawSpecial(const SkDraw&, SkSpecialImage*, int x, int y, const SkPaint&);
    virtual sk_sp<SkSpecialImage> makeSpecial(const SkBitmap&);
    virtual sk_sp<SkSpecialImage> makeSpecial(const SkImage*);
    virtual sk_sp<SkSpecialImage> snapSpecial();

    bool readPixels(const SkImageInfo&, void* dst, size_t rowBytes, int x, int y);

    ///////////////////////////////////////////////////////////////////////////

#ifdef SK_SUPPORT_LEGACY_ACCESSBITMAP
    /** Update as needed the pixel value in the bitmap, so that the caller can
        access the pixels directly.
        @return The device contents as a bitmap
    */
    virtual const SkBitmap& onAccessBitmap() {
        SkASSERT(0);
        return fLegacyBitmap;
    }
#endif

    virtual GrContext* context() const { return nullptr; }

protected:
    virtual sk_sp<SkSurface> makeSurface(const SkImageInfo&, const SkSurfaceProps&);
    virtual bool onPeekPixels(SkPixmap*) { return false; }

    /**
     *  The caller is responsible for "pre-clipping" the dst. The impl can assume that the dst
     *  image at the specified x,y offset will fit within the device's bounds.
     *
     *  This is explicitly asserted in readPixels(), the public way to call this.
     */
    virtual bool onReadPixels(const SkImageInfo&, void*, size_t, int x, int y);

    /**
     *  The caller is responsible for "pre-clipping" the src. The impl can assume that the src
     *  image at the specified x,y offset will fit within the device's bounds.
     *
     *  This is explicitly asserted in writePixelsDirect(), the public way to call this.
     */
    virtual bool onWritePixels(const SkImageInfo&, const void*, size_t, int x, int y);

    virtual bool onAccessPixels(SkPixmap*) { return false; }

    struct CreateInfo {
        static SkPixelGeometry AdjustGeometry(const SkImageInfo&, TileUsage, SkPixelGeometry,
                                              bool preserveLCDText);

        // The constructor may change the pixel geometry based on other parameters.
        CreateInfo(const SkImageInfo& info,
                   TileUsage tileUsage,
                   SkPixelGeometry geo)
            : fInfo(info)
            , fTileUsage(tileUsage)
            , fPixelGeometry(AdjustGeometry(info, tileUsage, geo, false))
        {}

        CreateInfo(const SkImageInfo& info,
                   TileUsage tileUsage,
                   SkPixelGeometry geo,
                   bool preserveLCDText)
            : fInfo(info)
            , fTileUsage(tileUsage)
            , fPixelGeometry(AdjustGeometry(info, tileUsage, geo, preserveLCDText))
        {}

        const SkImageInfo       fInfo;
        const TileUsage         fTileUsage;
        const SkPixelGeometry   fPixelGeometry;
    };

    /**
     *  Create a new device based on CreateInfo. If the paint is not null, then it represents a
     *  preview of how the new device will be composed with its creator device (this).
     *
     *  The subclass may be handed this device in drawDevice(), so it must always return
     *  a device that it knows how to draw, and that it knows how to identify if it is not of the
     *  same subclass (since drawDevice is passed a SkBaseDevice*). If the subclass cannot fulfill
     *  that contract (e.g. PDF cannot support some settings on the paint) it should return NULL,
     *  and the caller may then decide to explicitly create a bitmapdevice, knowing that later
     *  it could not call drawDevice with it (but it could call drawSprite or drawBitmap).
     */
    virtual SkBaseDevice* onCreateDevice(const CreateInfo&, const SkPaint*) {
        return NULL;
    }

    // A helper function used by derived classes to log the scale factor of a bitmap or image draw.
    static void LogDrawScaleFactor(const SkMatrix&, SkFilterQuality);

private:
    friend class SkCanvas;
    friend struct DeviceCM; //for setMatrixClip
    friend class SkDraw;
    friend class SkDrawIter;
    friend class SkDeviceFilteredPaint;
    friend class SkNoPixelsBitmapDevice;
    friend class SkSurface_Raster;
    friend class DeviceTestingAccess;

    // used to change the backend's pixels (and possibly config/rowbytes)
    // but cannot change the width/height, so there should be no change to
    // any clip information.
    // TODO: move to SkBitmapDevice
    virtual void replaceBitmapBackendForRasterSurface(const SkBitmap&) {}

    virtual bool forceConservativeRasterClip() const { return false; }

    /**
     * Don't call this!
     */
    virtual GrDrawContext* accessDrawContext() { return nullptr; }

    // just called by SkCanvas when built as a layer
    void setOrigin(int x, int y) { fOrigin.set(x, y); }

    /** Causes any deferred drawing to the device to be completed.
     */
    virtual void flush() {}

    virtual SkImageFilterCache* getImageFilterCache() { return NULL; }

    friend class SkBitmapDevice;
    void privateResize(int w, int h) {
        *const_cast<SkImageInfo*>(&fInfo) = fInfo.makeWH(w, h);
    }

    SkIPoint    fOrigin;
    SkMetaData* fMetaData;
    const SkImageInfo    fInfo;
    const SkSurfaceProps fSurfaceProps;

#ifdef SK_SUPPORT_LEGACY_ACCESSBITMAP
    SkBitmap    fLegacyBitmap;
#endif

    typedef SkRefCnt INHERITED;
};

#endif
