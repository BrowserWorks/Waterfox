/*
 * Copyright 2016 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "GrSurfaceContext.h"

#include "GrContextPriv.h"
#include "GrDrawingManager.h"
#include "GrOpList.h"
#include "SkGr.h"

#include "../private/GrAuditTrail.h"

#define ASSERT_SINGLE_OWNER \
    SkDEBUGCODE(GrSingleOwner::AutoEnforce debug_SingleOwner(this->singleOwner());)
#define RETURN_FALSE_IF_ABANDONED  if (this->drawingManager()->wasAbandoned()) { return false; }

// In MDB mode the reffing of the 'getLastOpList' call's result allows in-progress
// GrOpLists to be picked up and added to by renderTargetContexts lower in the call
// stack. When this occurs with a closed GrOpList, a new one will be allocated
// when the renderTargetContext attempts to use it (via getOpList).
GrSurfaceContext::GrSurfaceContext(GrContext* context,
                                   GrDrawingManager* drawingMgr,
                                   GrPixelConfig config,
                                   sk_sp<SkColorSpace> colorSpace,
                                   GrAuditTrail* auditTrail,
                                   GrSingleOwner* singleOwner)
        : fContext(context)
        , fAuditTrail(auditTrail)
        , fColorSpaceInfo(std::move(colorSpace), config)
        , fDrawingManager(drawingMgr)
#ifdef SK_DEBUG
        , fSingleOwner(singleOwner)
#endif
{
    // We never should have a sRGB pixel config with a non-SRGB gamma color space.
    SkASSERT(!GrPixelConfigIsSRGB(config) ||
             (fColorSpaceInfo.colorSpace() && fColorSpaceInfo.colorSpace()->gammaCloseToSRGB()));
}

bool GrSurfaceContext::readPixels(const SkImageInfo& dstInfo, void* dstBuffer,
                                  size_t dstRowBytes, int x, int y, uint32_t flags) {
    ASSERT_SINGLE_OWNER
    RETURN_FALSE_IF_ABANDONED
    SkDEBUGCODE(this->validate();)
    GR_AUDIT_TRAIL_AUTO_FRAME(fAuditTrail, "GrSurfaceContext::readPixels");

    // TODO: this seems to duplicate code in SkImage_Gpu::onReadPixels
    if (kUnpremul_SkAlphaType == dstInfo.alphaType()) {
        flags |= GrContextPriv::kUnpremul_PixelOpsFlag;
    }
    auto colorType = SkColorTypeToGrColorType(dstInfo.colorType());
    if (GrColorType::kUnknown == colorType) {
        return false;
    }
    return fContext->contextPriv().readSurfacePixels(this, x, y, dstInfo.width(), dstInfo.height(),
                                                     colorType, dstInfo.colorSpace(), dstBuffer,
                                                     dstRowBytes, flags);
}

bool GrSurfaceContext::writePixels(const SkImageInfo& srcInfo, const void* srcBuffer,
                                   size_t srcRowBytes, int x, int y, uint32_t flags) {
    ASSERT_SINGLE_OWNER
    RETURN_FALSE_IF_ABANDONED
    SkDEBUGCODE(this->validate();)
    GR_AUDIT_TRAIL_AUTO_FRAME(fAuditTrail, "GrSurfaceContext::writePixels");

    if (kUnpremul_SkAlphaType == srcInfo.alphaType()) {
        flags |= GrContextPriv::kUnpremul_PixelOpsFlag;
    }
    auto colorType = SkColorTypeToGrColorType(srcInfo.colorType());
    if (GrColorType::kUnknown == colorType) {
        return false;
    }
    return fContext->contextPriv().writeSurfacePixels(this, x, y, srcInfo.width(), srcInfo.height(),
                                                      colorType, srcInfo.colorSpace(), srcBuffer,
                                                      srcRowBytes, flags);
}

bool GrSurfaceContext::copy(GrSurfaceProxy* src, const SkIRect& srcRect, const SkIPoint& dstPoint) {
    ASSERT_SINGLE_OWNER
    RETURN_FALSE_IF_ABANDONED
    SkDEBUGCODE(this->validate();)
    GR_AUDIT_TRAIL_AUTO_FRAME(fAuditTrail, "GrSurfaceContext::onCopy");

    return this->getOpList()->copySurface(*fContext->caps(),
                                          this->asSurfaceProxy(), src, srcRect, dstPoint);
}
