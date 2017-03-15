/*
 * Copyright 2009 The Android Open Source Project
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "SkImageEncoder.h"
#include "SkBitmap.h"
#include "SkPixelSerializer.h"
#include "SkPixmap.h"
#include "SkStream.h"
#include "SkTemplates.h"

SkImageEncoder::~SkImageEncoder() {}

bool SkImageEncoder::encodeStream(SkWStream* stream, const SkBitmap& bm,
                                  int quality) {
    quality = SkMin32(100, SkMax32(0, quality));
    return this->onEncode(stream, bm, quality);
}

bool SkImageEncoder::encodeFile(const char file[], const SkBitmap& bm,
                                int quality) {
    quality = SkMin32(100, SkMax32(0, quality));
    SkFILEWStream   stream(file);
    return this->onEncode(&stream, bm, quality);
}

SkData* SkImageEncoder::encodeData(const SkBitmap& bm, int quality) {
    SkDynamicMemoryWStream stream;
    quality = SkMin32(100, SkMax32(0, quality));
    if (this->onEncode(&stream, bm, quality)) {
        return stream.detachAsData().release();
    }
    return nullptr;
}

bool SkImageEncoder::EncodeFile(const char file[], const SkBitmap& bm, Type t,
                                int quality) {
    SkAutoTDelete<SkImageEncoder> enc(SkImageEncoder::Create(t));
    return enc.get() && enc.get()->encodeFile(file, bm, quality);
}

bool SkImageEncoder::EncodeStream(SkWStream* stream, const SkBitmap& bm, Type t,
                                  int quality) {
    SkAutoTDelete<SkImageEncoder> enc(SkImageEncoder::Create(t));
    return enc.get() && enc.get()->encodeStream(stream, bm, quality);
}

SkData* SkImageEncoder::EncodeData(const SkBitmap& bm, Type t, int quality) {
    SkAutoTDelete<SkImageEncoder> enc(SkImageEncoder::Create(t));
    return enc.get() ? enc.get()->encodeData(bm, quality) : nullptr;
}

SkData* SkImageEncoder::EncodeData(const SkImageInfo& info, const void* pixels, size_t rowBytes,
                                   Type t, int quality) {
    SkBitmap bm;
    if (!bm.installPixels(info, const_cast<void*>(pixels), rowBytes)) {
        return nullptr;
    }
    bm.setImmutable();
    return SkImageEncoder::EncodeData(bm, t, quality);
}

SkData* SkImageEncoder::EncodeData(const SkPixmap& pixmap,
                                   Type t, int quality) {
    SkBitmap bm;
    if (!bm.installPixels(pixmap)) {
        return nullptr;
    }
    bm.setImmutable();
    return SkImageEncoder::EncodeData(bm, t, quality);
}

namespace {
class ImageEncoderPixelSerializer final : public SkPixelSerializer {
protected:
    bool onUseEncodedData(const void*, size_t) override { return true; }
    SkData* onEncode(const SkPixmap& pmap) override {
        return SkImageEncoder::EncodeData(pmap, SkImageEncoder::kPNG_Type, 100);
    }
};
} // namespace

SkPixelSerializer* SkImageEncoder::CreatePixelSerializer() {
    return new ImageEncoderPixelSerializer;
}
