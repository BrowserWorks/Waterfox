/*
 * Copyright 2015 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "SkBmpCodec.h"
#include "SkColorTable.h"
#include "SkImageInfo.h"
#include "SkSampler.h"
#include "SkTypes.h"

/*
 * This class implements the decoding for bmp images that use an RLE encoding
 */
class SkBmpRLECodec : public SkBmpCodec {
public:

    /*
     * Creates an instance of the decoder
     *
     * Called only by SkBmpCodec::NewFromStream
     * There should be no other callers despite this being public
     *
     * @param info contains properties of the encoded data
     * @param stream the stream of encoded image data
     * @param bitsPerPixel the number of bits used to store each pixel
     * @param numColors the number of colors in the color table
     * @param bytesPerColor the number of bytes in the stream used to represent
                            each color in the color table
     * @param offset the offset of the image pixel data from the end of the
     *               headers
     * @param rowOrder indicates whether rows are ordered top-down or bottom-up
     * @param RLEBytes indicates the amount of data left in the stream
     *                 after decoding the headers
     */
    SkBmpRLECodec(int width, int height, const SkEncodedInfo& info, SkStream* stream,
            uint16_t bitsPerPixel, uint32_t numColors, uint32_t bytesPerColor,
            uint32_t offset, SkCodec::SkScanlineOrder rowOrder,
            size_t RLEBytes);

    int setSampleX(int);

protected:

    Result onGetPixels(const SkImageInfo& dstInfo, void* dst,
                       size_t dstRowBytes, const Options&, SkPMColor*,
                       int*, int*) override;

    SkCodec::Result prepareToDecode(const SkImageInfo& dstInfo,
            const SkCodec::Options& options, SkPMColor inputColorPtr[],
            int* inputColorCount) override;

private:

    /*
     * Creates the color table
     * Sets colorCount to the new color count if it is non-nullptr
     */
    bool createColorTable(SkColorType dstColorType, int* colorCount);

    bool initializeStreamBuffer();

    /*
     * Before signalling kIncompleteInput, we should attempt to load the
     * stream buffer with additional data.
     *
     * @return the number of bytes remaining in the stream buffer after
     *         attempting to read more bytes from the stream
     */
    size_t checkForMoreData();

    /*
     * Set an RLE pixel using the color table
     */
    void setPixel(void* dst, size_t dstRowBytes,
                  const SkImageInfo& dstInfo, uint32_t x, uint32_t y,
                  uint8_t index);
    /*
     * Set an RLE24 pixel from R, G, B values
     */
    void setRGBPixel(void* dst, size_t dstRowBytes,
                     const SkImageInfo& dstInfo, uint32_t x, uint32_t y,
                     uint8_t red, uint8_t green, uint8_t blue);

    /*
     * If dst is NULL, this is a signal to skip the rows.
     */
    int decodeRows(const SkImageInfo& dstInfo, void* dst, size_t dstRowBytes,
            const Options& opts) override;

    bool skipRows(int count) override;

    SkSampler* getSampler(bool createIfNecessary) override;

    SkAutoTUnref<SkColorTable>          fColorTable;    // owned
    // fNumColors is the number specified in the header, or 0 if not present in the header.
    const uint32_t                      fNumColors;
    const uint32_t                      fBytesPerColor;
    const uint32_t                      fOffset;
    SkAutoTDeleteArray<uint8_t>         fStreamBuffer;
    size_t                              fRLEBytes;
    const size_t                        fOrigRLEBytes;
    uint32_t                            fCurrRLEByte;
    int                                 fSampleX;
    SkAutoTDelete<SkSampler>            fSampler;

    // Scanline decodes allow the client to ask for a single scanline at a time.
    // This can be tricky when the RLE encoding instructs the decoder to jump down
    // multiple lines.  This field keeps track of lines that need to be skipped
    // on subsequent calls to decodeRows().
    int                                 fLinesToSkip;

    typedef SkBmpCodec INHERITED;
};
