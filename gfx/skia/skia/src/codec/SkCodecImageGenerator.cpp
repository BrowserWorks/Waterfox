/*
 * Copyright 2015 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "SkCodecImageGenerator.h"

SkImageGenerator* SkCodecImageGenerator::NewFromEncodedCodec(sk_sp<SkData> data) {
    SkCodec* codec = SkCodec::NewFromData(data);
    if (nullptr == codec) {
        return nullptr;
    }

    return new SkCodecImageGenerator(codec, data);
}

static SkImageInfo make_premul(const SkImageInfo& info) {
    if (kUnpremul_SkAlphaType == info.alphaType()) {
        return info.makeAlphaType(kPremul_SkAlphaType);
    }

    return info;
}

SkCodecImageGenerator::SkCodecImageGenerator(SkCodec* codec, sk_sp<SkData> data)
    : INHERITED(make_premul(codec->getInfo()))
    , fCodec(codec)
    , fData(std::move(data))
{}

SkData* SkCodecImageGenerator::onRefEncodedData(SK_REFENCODEDDATA_CTXPARAM) {
    return SkRef(fData.get());
}

bool SkCodecImageGenerator::onGetPixels(const SkImageInfo& info, void* pixels, size_t rowBytes,
        SkPMColor ctable[], int* ctableCount) {

    // FIXME (msarett):
    // We don't give the client the chance to request an SkColorSpace.  Until we improve
    // the API, let's assume that they want legacy mode.
    SkImageInfo decodeInfo = info.makeColorSpace(nullptr);

    SkCodec::Result result = fCodec->getPixels(decodeInfo, pixels, rowBytes, nullptr, ctable,
            ctableCount);
    switch (result) {
        case SkCodec::kSuccess:
        case SkCodec::kIncompleteInput:
            return true;
        default:
            return false;
    }
}

bool SkCodecImageGenerator::onQueryYUV8(SkYUVSizeInfo* sizeInfo, SkYUVColorSpace* colorSpace) const
{
    return fCodec->queryYUV8(sizeInfo, colorSpace);
}

bool SkCodecImageGenerator::onGetYUV8Planes(const SkYUVSizeInfo& sizeInfo, void* planes[3]) {
    SkCodec::Result result = fCodec->getYUV8Planes(sizeInfo, planes);

    switch (result) {
        case SkCodec::kSuccess:
        case SkCodec::kIncompleteInput:
            return true;
        default:
            return false;
    }
}
