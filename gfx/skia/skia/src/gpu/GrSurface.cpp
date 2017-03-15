/*
 * Copyright 2012 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "GrSurface.h"
#include "GrContext.h"
#include "GrSurfacePriv.h"

#include "SkBitmap.h"
#include "SkGrPriv.h"
#include "SkImageEncoder.h"
#include <stdio.h>

size_t GrSurface::WorstCaseSize(const GrSurfaceDesc& desc) {
    size_t size;

    bool isRenderTarget = SkToBool(desc.fFlags & kRenderTarget_GrSurfaceFlag);
    if (isRenderTarget) {
        // We own one color value for each MSAA sample.
        int colorValuesPerPixel = SkTMax(1, desc.fSampleCnt);
        if (desc.fSampleCnt) {
            // Worse case, we own the resolve buffer so that is one more sample per pixel.
            colorValuesPerPixel += 1;
        }
        SkASSERT(kUnknown_GrPixelConfig != desc.fConfig);
        SkASSERT(!GrPixelConfigIsCompressed(desc.fConfig));
        size_t colorBytes = GrBytesPerPixel(desc.fConfig);
        SkASSERT(colorBytes > 0);

        size = (size_t) colorValuesPerPixel * desc.fWidth * desc.fHeight * colorBytes;
    } else {
        if (GrPixelConfigIsCompressed(desc.fConfig)) {
            size = GrCompressedFormatDataSize(desc.fConfig, desc.fWidth, desc.fHeight);
        } else {
            size = (size_t) desc.fWidth * desc.fHeight * GrBytesPerPixel(desc.fConfig);
        }

        size += size/3;  // in case we have to mipmap
    }

    return size;
}

template<typename T> static bool adjust_params(int surfaceWidth,
                                               int surfaceHeight,
                                               size_t bpp,
                                               int* left, int* top, int* width, int* height,
                                               T** data,
                                               size_t* rowBytes) {
    if (!*rowBytes) {
        *rowBytes = *width * bpp;
    }

    SkIRect subRect = SkIRect::MakeXYWH(*left, *top, *width, *height);
    SkIRect bounds = SkIRect::MakeWH(surfaceWidth, surfaceHeight);

    if (!subRect.intersect(bounds)) {
        return false;
    }
    *data = reinterpret_cast<void*>(reinterpret_cast<intptr_t>(*data) +
            (subRect.fTop - *top) * *rowBytes + (subRect.fLeft - *left) * bpp);

    *left = subRect.fLeft;
    *top = subRect.fTop;
    *width = subRect.width();
    *height = subRect.height();
    return true;
}

bool GrSurfacePriv::AdjustReadPixelParams(int surfaceWidth,
                                          int surfaceHeight,
                                          size_t bpp,
                                          int* left, int* top, int* width, int* height,
                                          void** data,
                                          size_t* rowBytes) {
    return adjust_params<void>(surfaceWidth, surfaceHeight, bpp, left, top, width, height, data,
                               rowBytes);
}

bool GrSurfacePriv::AdjustWritePixelParams(int surfaceWidth,
                                           int surfaceHeight,
                                           size_t bpp,
                                           int* left, int* top, int* width, int* height,
                                           const void** data,
                                           size_t* rowBytes) {
    return adjust_params<const void>(surfaceWidth, surfaceHeight, bpp, left, top, width, height,
                                     data, rowBytes);
}


//////////////////////////////////////////////////////////////////////////////

bool GrSurface::writePixels(int left, int top, int width, int height,
                            GrPixelConfig config, const void* buffer, size_t rowBytes,
                            uint32_t pixelOpsFlags) {
    // go through context so that all necessary flushing occurs
    GrContext* context = this->getContext();
    if (nullptr == context) {
        return false;
    }
    return context->writeSurfacePixels(this, left, top, width, height, config, buffer,
                                       rowBytes, pixelOpsFlags);
}

bool GrSurface::readPixels(int left, int top, int width, int height,
                           GrPixelConfig config, void* buffer, size_t rowBytes,
                           uint32_t pixelOpsFlags) {
    // go through context so that all necessary flushing occurs
    GrContext* context = this->getContext();
    if (nullptr == context) {
        return false;
    }
    return context->readSurfacePixels(this, left, top, width, height, config, buffer,
                                      rowBytes, pixelOpsFlags);
}

// TODO: This should probably be a non-member helper function. It might only be needed in
// debug or developer builds.
bool GrSurface::savePixels(const char* filename) {
    SkBitmap bm;
    if (!bm.tryAllocPixels(SkImageInfo::MakeN32Premul(this->width(), this->height()))) {
        return false;
    }

    bool result = this->readPixels(0, 0, this->width(), this->height(), kSkia8888_GrPixelConfig,
                                   bm.getPixels());
    if (!result) {
        SkDebugf("------ failed to read pixels for %s\n", filename);
        return false;
    }

    // remove any previous version of this file
    remove(filename);

    if (!SkImageEncoder::EncodeFile(filename, bm, SkImageEncoder::kPNG_Type, 100)) {
        SkDebugf("------ failed to encode %s\n", filename);
        remove(filename);   // remove any partial file
        return false;
    }

    return true;
}

void GrSurface::flushWrites() {
    if (!this->wasDestroyed()) {
        this->getContext()->flushSurfaceWrites(this);
    }
}

bool GrSurface::hasPendingRead() const {
    const GrTexture* thisTex = this->asTexture();
    if (thisTex && thisTex->internalHasPendingRead()) {
        return true;
    }
    const GrRenderTarget* thisRT = this->asRenderTarget();
    if (thisRT && thisRT->internalHasPendingRead()) {
        return true;
    }
    return false;
}

bool GrSurface::hasPendingWrite() const {
    const GrTexture* thisTex = this->asTexture();
    if (thisTex && thisTex->internalHasPendingWrite()) {
        return true;
    }
    const GrRenderTarget* thisRT = this->asRenderTarget();
    if (thisRT && thisRT->internalHasPendingWrite()) {
        return true;
    }
    return false;
}

bool GrSurface::hasPendingIO() const {
    const GrTexture* thisTex = this->asTexture();
    if (thisTex && thisTex->internalHasPendingIO()) {
        return true;
    }
    const GrRenderTarget* thisRT = this->asRenderTarget();
    if (thisRT && thisRT->internalHasPendingIO()) {
        return true;
    }
    return false;
}

void GrSurface::onRelease() {
    this->invokeReleaseProc();
    this->INHERITED::onRelease();
}

void GrSurface::onAbandon() {
    this->invokeReleaseProc();
    this->INHERITED::onAbandon();
}
