/*
 * Copyright 2015 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "SkCodec.h"
#include "SkData.h"
#include "SkImageGenerator.h"

class SkCodecImageGenerator : public SkImageGenerator {
public:
    /*
     * If this data represents an encoded image that we know how to decode,
     * return an SkCodecImageGenerator.  Otherwise return nullptr.
     */
    static SkImageGenerator* NewFromEncodedCodec(sk_sp<SkData>);
    static SkImageGenerator* NewFromEncodedCodec(SkData* data) {
        return NewFromEncodedCodec(sk_ref_sp(data));
    }

protected:
    SkData* onRefEncodedData(SK_REFENCODEDDATA_CTXPARAM) override;

    bool onGetPixels(const SkImageInfo& info, void* pixels, size_t rowBytes, SkPMColor ctable[],
            int* ctableCount) override;

    bool onQueryYUV8(SkYUVSizeInfo*, SkYUVColorSpace*) const override;

    bool onGetYUV8Planes(const SkYUVSizeInfo&, void* planes[3]) override;

private:
    /*
     * Takes ownership of codec
     */
    SkCodecImageGenerator(SkCodec* codec, sk_sp<SkData>);

    SkAutoTDelete<SkCodec> fCodec;
    sk_sp<SkData> fData;

    typedef SkImageGenerator INHERITED;
};
