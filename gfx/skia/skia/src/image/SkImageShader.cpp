/*
 * Copyright 2015 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "SkBitmapProcShader.h"
#include "SkBitmapProvider.h"
#include "SkColorShader.h"
#include "SkColorTable.h"
#include "SkEmptyShader.h"
#include "SkImage_Base.h"
#include "SkImageShader.h"
#include "SkReadBuffer.h"
#include "SkWriteBuffer.h"

SkImageShader::SkImageShader(sk_sp<SkImage> img, TileMode tmx, TileMode tmy, const SkMatrix* matrix)
    : INHERITED(matrix)
    , fImage(std::move(img))
    , fTileModeX(tmx)
    , fTileModeY(tmy)
{}

sk_sp<SkFlattenable> SkImageShader::CreateProc(SkReadBuffer& buffer) {
    const TileMode tx = (TileMode)buffer.readUInt();
    const TileMode ty = (TileMode)buffer.readUInt();
    SkMatrix matrix;
    buffer.readMatrix(&matrix);
    sk_sp<SkImage> img = buffer.readImage();
    if (!img) {
        return nullptr;
    }
    return SkImageShader::Make(std::move(img), tx, ty, &matrix);
}

void SkImageShader::flatten(SkWriteBuffer& buffer) const {
    buffer.writeUInt(fTileModeX);
    buffer.writeUInt(fTileModeY);
    buffer.writeMatrix(this->getLocalMatrix());
    buffer.writeImage(fImage.get());
}

bool SkImageShader::isOpaque() const {
    return fImage->isOpaque();
}

size_t SkImageShader::onContextSize(const ContextRec& rec) const {
    return SkBitmapProcLegacyShader::ContextSize(rec, SkBitmapProvider(fImage.get()).info());
}

SkShader::Context* SkImageShader::onCreateContext(const ContextRec& rec, void* storage) const {
    return SkBitmapProcLegacyShader::MakeContext(*this, fTileModeX, fTileModeY,
                                                 SkBitmapProvider(fImage.get()), rec, storage);
}

SkImage* SkImageShader::onIsAImage(SkMatrix* texM, TileMode xy[]) const {
    if (texM) {
        *texM = this->getLocalMatrix();
    }
    if (xy) {
        xy[0] = (TileMode)fTileModeX;
        xy[1] = (TileMode)fTileModeY;
    }
    return const_cast<SkImage*>(fImage.get());
}

#ifdef SK_SUPPORT_LEGACY_SHADER_ISABITMAP
bool SkImageShader::onIsABitmap(SkBitmap* texture, SkMatrix* texM, TileMode xy[]) const {
    const SkBitmap* bm = as_IB(fImage)->onPeekBitmap();
    if (!bm) {
        return false;
    }

    if (texture) {
        *texture = *bm;
    }
    if (texM) {
        *texM = this->getLocalMatrix();
    }
    if (xy) {
        xy[0] = (TileMode)fTileModeX;
        xy[1] = (TileMode)fTileModeY;
    }
    return true;
}
#endif

static bool bitmap_is_too_big(int w, int h) {
    // SkBitmapProcShader stores bitmap coordinates in a 16bit buffer, as it
    // communicates between its matrix-proc and its sampler-proc. Until we can
    // widen that, we have to reject bitmaps that are larger.
    //
    static const int kMaxSize = 65535;
    
    return w > kMaxSize || h > kMaxSize;
}

// returns true and set color if the bitmap can be drawn as a single color
// (for efficiency)
static bool can_use_color_shader(const SkImage* image, SkColor* color) {
#ifdef SK_BUILD_FOR_ANDROID_FRAMEWORK
    // HWUI does not support color shaders (see b/22390304)
    return false;
#endif
    
    if (1 != image->width() || 1 != image->height()) {
        return false;
    }
    
    SkPixmap pmap;
    if (!image->peekPixels(&pmap)) {
        return false;
    }
    
    switch (pmap.colorType()) {
        case kN32_SkColorType:
            *color = SkUnPreMultiply::PMColorToColor(*pmap.addr32(0, 0));
            return true;
        case kRGB_565_SkColorType:
            *color = SkPixel16ToColor(*pmap.addr16(0, 0));
            return true;
        case kIndex_8_SkColorType: {
            const SkColorTable& ctable = *pmap.ctable();
            *color = SkUnPreMultiply::PMColorToColor(ctable[*pmap.addr8(0, 0)]);
            return true;
        }
        default: // just skip the other configs for now
            break;
    }
    return false;
}

sk_sp<SkShader> SkImageShader::Make(sk_sp<SkImage> image, TileMode tx, TileMode ty,
                                    const SkMatrix* localMatrix,
                                    SkTBlitterAllocator* allocator) {
    SkShader* shader;
    SkColor color;
    if (!image || bitmap_is_too_big(image->width(), image->height())) {
        if (nullptr == allocator) {
            shader = new SkEmptyShader;
        } else {
            shader = allocator->createT<SkEmptyShader>();
        }
    } else if (can_use_color_shader(image.get(), &color)) {
        if (nullptr == allocator) {
            shader = new SkColorShader(color);
        } else {
            shader = allocator->createT<SkColorShader>(color);
        }
    } else {
        if (nullptr == allocator) {
            shader = new SkImageShader(image, tx, ty, localMatrix);
        } else {
            shader = allocator->createT<SkImageShader>(image, tx, ty, localMatrix);
        }
    }
    return sk_sp<SkShader>(shader);
}

#ifndef SK_IGNORE_TO_STRING
void SkImageShader::toString(SkString* str) const {
    const char* gTileModeName[SkShader::kTileModeCount] = {
        "clamp", "repeat", "mirror"
    };

    str->appendf("ImageShader: ((%s %s) ", gTileModeName[fTileModeX], gTileModeName[fTileModeY]);
    fImage->toString(str);
    this->INHERITED::toString(str);
    str->append(")");
}
#endif

///////////////////////////////////////////////////////////////////////////////////////////////////

#if SK_SUPPORT_GPU

#include "GrTextureAccess.h"
#include "SkGr.h"
#include "SkGrPriv.h"
#include "effects/GrSimpleTextureEffect.h"
#include "effects/GrBicubicEffect.h"
#include "effects/GrSimpleTextureEffect.h"

sk_sp<GrFragmentProcessor> SkImageShader::asFragmentProcessor(const AsFPArgs& args) const {
    SkMatrix matrix;
    matrix.setIDiv(fImage->width(), fImage->height());

    SkMatrix lmInverse;
    if (!this->getLocalMatrix().invert(&lmInverse)) {
        return nullptr;
    }
    if (args.fLocalMatrix) {
        SkMatrix inv;
        if (!args.fLocalMatrix->invert(&inv)) {
            return nullptr;
        }
        lmInverse.postConcat(inv);
    }
    matrix.preConcat(lmInverse);

    SkShader::TileMode tm[] = { fTileModeX, fTileModeY };

    // Must set wrap and filter on the sampler before requesting a texture. In two places below
    // we check the matrix scale factors to determine how to interpret the filter quality setting.
    // This completely ignores the complexity of the drawVertices case where explicit local coords
    // are provided by the caller.
    bool doBicubic;
    GrTextureParams::FilterMode textureFilterMode =
    GrSkFilterQualityToGrFilterMode(args.fFilterQuality, *args.fViewMatrix, this->getLocalMatrix(),
                                    &doBicubic);
    GrTextureParams params(tm, textureFilterMode);
    SkAutoTUnref<GrTexture> texture(as_IB(fImage)->asTextureRef(args.fContext, params,
                                                                args.fGammaTreatment));
    if (!texture) {
        return nullptr;
    }

    SkImageInfo info = as_IB(fImage)->onImageInfo();
    sk_sp<GrColorSpaceXform> colorSpaceXform = GrColorSpaceXform::Make(info.colorSpace(),
                                                                       args.fDstColorSpace);
    sk_sp<GrFragmentProcessor> inner;
    if (doBicubic) {
        inner = GrBicubicEffect::Make(texture, std::move(colorSpaceXform), matrix, tm);
    } else {
        inner = GrSimpleTextureEffect::Make(texture, std::move(colorSpaceXform), matrix, params);
    }

    if (GrPixelConfigIsAlphaOnly(texture->config())) {
        return inner;
    }
    return sk_sp<GrFragmentProcessor>(GrFragmentProcessor::MulOutputByInputAlpha(std::move(inner)));
}

#endif

///////////////////////////////////////////////////////////////////////////////////////////////////
#include "SkImagePriv.h"

sk_sp<SkShader> SkMakeBitmapShader(const SkBitmap& src, SkShader::TileMode tmx,
                                   SkShader::TileMode tmy, const SkMatrix* localMatrix,
                                   SkCopyPixelsMode cpm, SkTBlitterAllocator* allocator) {
    // Until we learn otherwise, it seems that any caller that is passing an allocator must be
    // assuming that the returned shader will have a stack-frame lifetime, so we assert that
    // they are also asking for kNever_SkCopyPixelsMode. If that proves otherwise, we can remove
    // or modify this assert.
    SkASSERT(!allocator || (kNever_SkCopyPixelsMode == cpm));

    return SkImageShader::Make(SkMakeImageFromRasterBitmap(src, cpm, allocator),
                               tmx, tmy, localMatrix, allocator);
}

static sk_sp<SkFlattenable> SkBitmapProcShader_CreateProc(SkReadBuffer& buffer) {
    SkMatrix lm;
    buffer.readMatrix(&lm);
    sk_sp<SkImage> image = buffer.readBitmapAsImage();
    SkShader::TileMode mx = (SkShader::TileMode)buffer.readUInt();
    SkShader::TileMode my = (SkShader::TileMode)buffer.readUInt();
    return image ? image->makeShader(mx, my, &lm) : nullptr;
}

SK_DEFINE_FLATTENABLE_REGISTRAR_GROUP_START(SkShader)
SK_DEFINE_FLATTENABLE_REGISTRAR_ENTRY(SkImageShader)
SkFlattenable::Register("SkBitmapProcShader", SkBitmapProcShader_CreateProc, kSkShader_Type);
SK_DEFINE_FLATTENABLE_REGISTRAR_GROUP_END

