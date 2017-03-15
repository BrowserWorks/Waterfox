/*
 * Copyright 2012 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "SkSurface_Gpu.h"

#include "GrContextPriv.h"
#include "GrResourceProvider.h"
#include "SkCanvas.h"
#include "SkGpuDevice.h"
#include "SkImage_Base.h"
#include "SkImage_Gpu.h"
#include "SkImagePriv.h"
#include "SkSurface_Base.h"

#if SK_SUPPORT_GPU

SkSurface_Gpu::SkSurface_Gpu(sk_sp<SkGpuDevice> device)
    : INHERITED(device->width(), device->height(), &device->surfaceProps())
    , fDevice(std::move(device)) {
}

SkSurface_Gpu::~SkSurface_Gpu() {
}

static GrRenderTarget* prepare_rt_for_external_access(SkSurface_Gpu* surface,
                                                      SkSurface::BackendHandleAccess access) {
    switch (access) {
        case SkSurface::kFlushRead_BackendHandleAccess:
            break;
        case SkSurface::kFlushWrite_BackendHandleAccess:
        case SkSurface::kDiscardWrite_BackendHandleAccess:
            // for now we don't special-case on Discard, but we may in the future.
            surface->notifyContentWillChange(SkSurface::kRetain_ContentChangeMode);
            break;
    }

    // Grab the render target *after* firing notifications, as it may get switched if CoW kicks in.
    surface->getDevice()->flush();
    GrDrawContext* dc = surface->getDevice()->accessDrawContext();
    return dc->accessRenderTarget();
}

GrBackendObject SkSurface_Gpu::onGetTextureHandle(BackendHandleAccess access) {
    GrRenderTarget* rt = prepare_rt_for_external_access(this, access);
    GrTexture* texture = rt->asTexture();
    if (texture) {
        return texture->getTextureHandle();
    }
    return 0;
}

bool SkSurface_Gpu::onGetRenderTargetHandle(GrBackendObject* obj, BackendHandleAccess access) {
    GrRenderTarget* rt = prepare_rt_for_external_access(this, access);
    *obj = rt->getRenderTargetHandle();
    return true;
}

SkCanvas* SkSurface_Gpu::onNewCanvas() {
    SkCanvas::InitFlags flags = SkCanvas::kDefault_InitFlags;
    flags = static_cast<SkCanvas::InitFlags>(flags | SkCanvas::kConservativeRasterClip_InitFlag);

    return new SkCanvas(fDevice.get(), flags);
}

sk_sp<SkSurface> SkSurface_Gpu::onNewSurface(const SkImageInfo& info) {
    int sampleCount = fDevice->accessDrawContext()->numColorSamples();
    GrSurfaceOrigin origin = fDevice->accessDrawContext()->origin();
    // TODO: Make caller specify this (change virtual signature of onNewSurface).
    static const SkBudgeted kBudgeted = SkBudgeted::kNo;
    return SkSurface::MakeRenderTarget(fDevice->context(), kBudgeted, info, sampleCount,
                                       origin, &this->props());
}

sk_sp<SkImage> SkSurface_Gpu::onNewImageSnapshot(SkBudgeted budgeted, SkCopyPixelsMode cpm) {
    GrRenderTarget* rt = fDevice->accessDrawContext()->accessRenderTarget();
    SkASSERT(rt);
    GrTexture* tex = rt->asTexture();
    SkAutoTUnref<GrTexture> copy;
    // If the original render target is a buffer originally created by the client, then we don't
    // want to ever retarget the SkSurface at another buffer we create. Force a copy now to avoid
    // copy-on-write.
    if (kAlways_SkCopyPixelsMode == cpm || !tex || rt->resourcePriv().refsWrappedObjects()) {
        GrSurfaceDesc desc = fDevice->accessDrawContext()->desc();
        GrContext* ctx = fDevice->context();
        desc.fFlags = desc.fFlags & ~kRenderTarget_GrSurfaceFlag;
        copy.reset(ctx->textureProvider()->createTexture(desc, budgeted));
        if (!copy) {
            return nullptr;
        }
        if (!ctx->copySurface(copy, rt)) {
            return nullptr;
        }
        tex = copy;
    }
    const SkImageInfo info = fDevice->imageInfo();
    sk_sp<SkImage> image;
    if (tex) {
        image = sk_make_sp<SkImage_Gpu>(info.width(), info.height(), kNeedNewImageUniqueID,
                                        info.alphaType(), tex, sk_ref_sp(info.colorSpace()),
                                        budgeted);
    }
    return image;
}

// Create a new render target and, if necessary, copy the contents of the old
// render target into it. Note that this flushes the SkGpuDevice but
// doesn't force an OpenGL flush.
void SkSurface_Gpu::onCopyOnWrite(ContentChangeMode mode) {
    GrRenderTarget* rt = fDevice->accessDrawContext()->accessRenderTarget();
    // are we sharing our render target with the image? Note this call should never create a new
    // image because onCopyOnWrite is only called when there is a cached image.
    sk_sp<SkImage> image(this->refCachedImage(SkBudgeted::kNo, kNo_ForceUnique));
    SkASSERT(image);
    if (rt->asTexture() == as_IB(image)->peekTexture()) {
        this->fDevice->replaceDrawContext(SkSurface::kRetain_ContentChangeMode == mode);
        SkTextureImageApplyBudgetedDecision(image.get());
    } else if (kDiscard_ContentChangeMode == mode) {
        this->SkSurface_Gpu::onDiscard();
    }
}

void SkSurface_Gpu::onDiscard() {
    fDevice->accessDrawContext()->discard();
}

void SkSurface_Gpu::onPrepareForExternalIO() {
    fDevice->flush();
}

///////////////////////////////////////////////////////////////////////////////

bool SkSurface_Gpu::Valid(const SkImageInfo& info) {
    switch (info.colorType()) {
        case kRGBA_F16_SkColorType:
            return info.colorSpace() && info.colorSpace()->gammaIsLinear();
        case kRGBA_8888_SkColorType:
        case kBGRA_8888_SkColorType:
            return !info.colorSpace() || info.colorSpace()->gammaCloseToSRGB();
        default:
            return !info.colorSpace();
    }
}

bool SkSurface_Gpu::Valid(GrContext* context, GrPixelConfig config, SkColorSpace* colorSpace) {
    switch (config) {
        case kRGBA_half_GrPixelConfig:
            return colorSpace && colorSpace->gammaIsLinear();
        case kSRGBA_8888_GrPixelConfig:
        case kSBGRA_8888_GrPixelConfig:
            return context->caps()->srgbSupport() && colorSpace && colorSpace->gammaCloseToSRGB();
        case kRGBA_8888_GrPixelConfig:
        case kBGRA_8888_GrPixelConfig:
            // If we don't have sRGB support, we may get here with a color space. It still needs
            // to be sRGB-like (so that the application will work correctly on sRGB devices.)
            return !colorSpace ||
                (!context->caps()->srgbSupport() && colorSpace->gammaCloseToSRGB());
        default:
            return !colorSpace;
    }
}

sk_sp<SkSurface> SkSurface::MakeRenderTarget(GrContext* ctx, SkBudgeted budgeted,
                                             const SkImageInfo& info, int sampleCount,
                                             GrSurfaceOrigin origin, const SkSurfaceProps* props) {
    if (!SkSurface_Gpu::Valid(info)) {
        return nullptr;
    }

    sk_sp<SkGpuDevice> device(SkGpuDevice::Make(
            ctx, budgeted, info, sampleCount, origin, props, SkGpuDevice::kClear_InitContents));
    if (!device) {
        return nullptr;
    }
    return sk_make_sp<SkSurface_Gpu>(std::move(device));
}

sk_sp<SkSurface> SkSurface::MakeFromBackendTexture(GrContext* context,
                                                   const GrBackendTextureDesc& desc,
                                                   sk_sp<SkColorSpace> colorSpace,
                                                   const SkSurfaceProps* props) {
    if (!context) {
        return nullptr;
    }
    if (!SkToBool(desc.fFlags & kRenderTarget_GrBackendTextureFlag)) {
        return nullptr;
    }
    if (!SkSurface_Gpu::Valid(context, desc.fConfig, colorSpace.get())) {
        return nullptr;
    }

    sk_sp<GrDrawContext> dc(context->contextPriv().makeBackendTextureDrawContext(
                                                                    desc,
                                                                    std::move(colorSpace),
                                                                    props,
                                                                    kBorrow_GrWrapOwnership));
    if (!dc) {
        return nullptr;
    }

    sk_sp<SkGpuDevice> device(SkGpuDevice::Make(std::move(dc), desc.fWidth, desc.fHeight,
                                                SkGpuDevice::kUninit_InitContents));
    if (!device) {
        return nullptr;
    }
    return sk_make_sp<SkSurface_Gpu>(std::move(device));
}

sk_sp<SkSurface> SkSurface::MakeFromBackendRenderTarget(GrContext* context,
                                                        const GrBackendRenderTargetDesc& desc,
                                                        sk_sp<SkColorSpace> colorSpace,
                                                        const SkSurfaceProps* props) {
    if (!context) {
        return nullptr;
    }
    if (!SkSurface_Gpu::Valid(context, desc.fConfig, colorSpace.get())) {
        return nullptr;
    }

    sk_sp<GrDrawContext> dc(context->contextPriv().makeBackendRenderTargetDrawContext(
                                                                            desc,
                                                                            std::move(colorSpace),
                                                                            props));
    if (!dc) {
        return nullptr;
    }

    sk_sp<SkGpuDevice> device(SkGpuDevice::Make(std::move(dc), desc.fWidth, desc.fHeight,
                                                SkGpuDevice::kUninit_InitContents));
    if (!device) {
        return nullptr;
    }

    return sk_make_sp<SkSurface_Gpu>(std::move(device));
}

sk_sp<SkSurface> SkSurface::MakeFromBackendTextureAsRenderTarget(GrContext* context,
                                                                 const GrBackendTextureDesc& desc,
                                                                 sk_sp<SkColorSpace> colorSpace,
                                                                 const SkSurfaceProps* props) {
    if (!context) {
        return nullptr;
    }
    if (!SkSurface_Gpu::Valid(context, desc.fConfig, colorSpace.get())) {
        return nullptr;
    }

    sk_sp<GrDrawContext> dc(context->contextPriv().makeBackendTextureAsRenderTargetDrawContext(
                                                                            desc,
                                                                            std::move(colorSpace),
                                                                            props));
    if (!dc) {
        return nullptr;
    }

    sk_sp<SkGpuDevice> device(SkGpuDevice::Make(std::move(dc), desc.fWidth, desc.fHeight,
                                                SkGpuDevice::kUninit_InitContents));
    if (!device) {
        return nullptr;
    }
    return sk_make_sp<SkSurface_Gpu>(std::move(device));
}

#endif
