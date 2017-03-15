/*
 * Copyright 2015 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "SkBmpStandardCodec.h"
#include "SkCodecPriv.h"
#include "SkColorPriv.h"
#include "SkStream.h"

/*
 * Creates an instance of the decoder
 * Called only by NewFromStream
 */
SkBmpStandardCodec::SkBmpStandardCodec(int width, int height, const SkEncodedInfo& info,
                                       SkStream* stream, uint16_t bitsPerPixel, uint32_t numColors,
                                       uint32_t bytesPerColor, uint32_t offset,
                                       SkCodec::SkScanlineOrder rowOrder,
                                       bool isOpaque, bool inIco)
    : INHERITED(width, height, info, stream, bitsPerPixel, rowOrder)
    , fColorTable(nullptr)
    , fNumColors(numColors)
    , fBytesPerColor(bytesPerColor)
    , fOffset(offset)
    , fSwizzler(nullptr)
    , fSrcBuffer(new uint8_t [this->srcRowBytes()])
    , fIsOpaque(isOpaque)
    , fInIco(inIco)
    , fAndMaskRowBytes(fInIco ? SkAlign4(compute_row_bytes(this->getInfo().width(), 1)) : 0)
{}

/*
 * Initiates the bitmap decode
 */
SkCodec::Result SkBmpStandardCodec::onGetPixels(const SkImageInfo& dstInfo,
                                        void* dst, size_t dstRowBytes,
                                        const Options& opts,
                                        SkPMColor* inputColorPtr,
                                        int* inputColorCount,
                                        int* rowsDecoded) {
    if (opts.fSubset) {
        // Subsets are not supported.
        return kUnimplemented;
    }
    if (dstInfo.dimensions() != this->getInfo().dimensions()) {
        SkCodecPrintf("Error: scaling not supported.\n");
        return kInvalidScale;
    }
    if (!conversion_possible_ignore_color_space(dstInfo, this->getInfo())) {
        SkCodecPrintf("Error: cannot convert input type to output type.\n");
        return kInvalidConversion;
    }

    Result result = this->prepareToDecode(dstInfo, opts, inputColorPtr, inputColorCount);
    if (kSuccess != result) {
        return result;
    }
    int rows = this->decodeRows(dstInfo, dst, dstRowBytes, opts);
    if (rows != dstInfo.height()) {
        *rowsDecoded = rows;
        return kIncompleteInput;
    }
    return kSuccess;
}

/*
 * Process the color table for the bmp input
 */
 bool SkBmpStandardCodec::createColorTable(SkColorType dstColorType, SkAlphaType dstAlphaType,
         int* numColors) {
    // Allocate memory for color table
    uint32_t colorBytes = 0;
    SkPMColor colorTable[256];
    if (this->bitsPerPixel() <= 8) {
        // Inform the caller of the number of colors
        uint32_t maxColors = 1 << this->bitsPerPixel();
        if (nullptr != numColors) {
            // We set the number of colors to maxColors in order to ensure
            // safe memory accesses.  Otherwise, an invalid pixel could
            // access memory outside of our color table array.
            *numColors = maxColors;
        }
        // Don't bother reading more than maxColors.
        const uint32_t numColorsToRead =
            fNumColors == 0 ? maxColors : SkTMin(fNumColors, maxColors);

        // Read the color table from the stream
        colorBytes = numColorsToRead * fBytesPerColor;
        SkAutoTDeleteArray<uint8_t> cBuffer(new uint8_t[colorBytes]);
        if (stream()->read(cBuffer.get(), colorBytes) != colorBytes) {
            SkCodecPrintf("Error: unable to read color table.\n");
            return false;
        }

        // Choose the proper packing function
        bool isPremul = (kPremul_SkAlphaType == dstAlphaType) && !fIsOpaque;
        PackColorProc packARGB = choose_pack_color_proc(isPremul, dstColorType);

        // Fill in the color table
        uint32_t i = 0;
        for (; i < numColorsToRead; i++) {
            uint8_t blue = get_byte(cBuffer.get(), i*fBytesPerColor);
            uint8_t green = get_byte(cBuffer.get(), i*fBytesPerColor + 1);
            uint8_t red = get_byte(cBuffer.get(), i*fBytesPerColor + 2);
            uint8_t alpha;
            if (fIsOpaque) {
                alpha = 0xFF;
            } else {
                alpha = get_byte(cBuffer.get(), i*fBytesPerColor + 3);
            }
            colorTable[i] = packARGB(alpha, red, green, blue);
        }

        // To avoid segmentation faults on bad pixel data, fill the end of the
        // color table with black.  This is the same the behavior as the
        // chromium decoder.
        for (; i < maxColors; i++) {
            colorTable[i] = SkPackARGB32NoCheck(0xFF, 0, 0, 0);
        }

        // Set the color table
        fColorTable.reset(new SkColorTable(colorTable, maxColors));
    }

    // Bmp-in-Ico files do not use an offset to indicate where the pixel data
    // begins.  Pixel data always begins immediately after the color table.
    if (!fInIco) {
        // Check that we have not read past the pixel array offset
        if(fOffset < colorBytes) {
            // This may occur on OS 2.1 and other old versions where the color
            // table defaults to max size, and the bmp tries to use a smaller
            // color table.  This is invalid, and our decision is to indicate
            // an error, rather than try to guess the intended size of the
            // color table.
            SkCodecPrintf("Error: pixel data offset less than color table size.\n");
            return false;
        }

        // After reading the color table, skip to the start of the pixel array
        if (stream()->skip(fOffset - colorBytes) != fOffset - colorBytes) {
            SkCodecPrintf("Error: unable to skip to image data.\n");
            return false;
        }
    }

    // Return true on success
    return true;
}

void SkBmpStandardCodec::initializeSwizzler(const SkImageInfo& dstInfo, const Options& opts) {
    // In the case of bmp-in-icos, we will report BGRA to the client,
    // since we may be required to apply an alpha mask after the decode.
    // However, the swizzler needs to know the actual format of the bmp.
    SkEncodedInfo swizzlerInfo = this->getEncodedInfo();
    if (fInIco) {
        if (this->bitsPerPixel() <= 8) {
            swizzlerInfo = SkEncodedInfo::Make(SkEncodedInfo::kPalette_Color,
                    swizzlerInfo.alpha(), this->bitsPerPixel());
        } else if (this->bitsPerPixel() == 24) {
            swizzlerInfo = SkEncodedInfo::Make(SkEncodedInfo::kBGR_Color,
                    SkEncodedInfo::kOpaque_Alpha, 8);
        }
    }

    // Get a pointer to the color table if it exists
    const SkPMColor* colorPtr = get_color_ptr(fColorTable.get());

    // Create swizzler
    fSwizzler.reset(SkSwizzler::CreateSwizzler(swizzlerInfo, colorPtr, dstInfo, opts));
    SkASSERT(fSwizzler);
}

SkCodec::Result SkBmpStandardCodec::prepareToDecode(const SkImageInfo& dstInfo,
        const SkCodec::Options& options, SkPMColor inputColorPtr[], int* inputColorCount) {
    // Create the color table if necessary and prepare the stream for decode
    // Note that if it is non-NULL, inputColorCount will be modified
    if (!this->createColorTable(dstInfo.colorType(), dstInfo.alphaType(), inputColorCount)) {
        SkCodecPrintf("Error: could not create color table.\n");
        return SkCodec::kInvalidInput;
    }

    // Copy the color table to the client if necessary
    copy_color_table(dstInfo, this->fColorTable, inputColorPtr, inputColorCount);

    // Initialize a swizzler
    this->initializeSwizzler(dstInfo, options);
    return SkCodec::kSuccess;
}

/*
 * Performs the bitmap decoding for standard input format
 */
int SkBmpStandardCodec::decodeRows(const SkImageInfo& dstInfo, void* dst, size_t dstRowBytes,
        const Options& opts) {
    // Iterate over rows of the image
    const int height = dstInfo.height();
    for (int y = 0; y < height; y++) {
        // Read a row of the input
        if (this->stream()->read(fSrcBuffer.get(), this->srcRowBytes()) != this->srcRowBytes()) {
            SkCodecPrintf("Warning: incomplete input stream.\n");
            return y;
        }

        // Decode the row in destination format
        uint32_t row = this->getDstRow(y, dstInfo.height());

        void* dstRow = SkTAddOffset<void>(dst, row * dstRowBytes);
        fSwizzler->swizzle(dstRow, fSrcBuffer.get());
    }

    if (fInIco && fIsOpaque) {
        const int startScanline = this->currScanline();
        if (startScanline < 0) {
            // We are not performing a scanline decode.
            // Just decode the entire ICO mask and return.
            decodeIcoMask(this->stream(), dstInfo, dst, dstRowBytes);
            return height;
        }

        // In order to perform a scanline ICO decode, we must be able
        // to skip ahead in the stream in order to apply the AND mask
        // to the requested scanlines.
        // We will do this by taking advantage of the fact that
        // SkIcoCodec always uses a SkMemoryStream as its underlying
        // representation of the stream.
        const void* memoryBase = this->stream()->getMemoryBase();
        SkASSERT(nullptr != memoryBase);
        SkASSERT(this->stream()->hasLength());
        SkASSERT(this->stream()->hasPosition());

        const size_t length = this->stream()->getLength();
        const size_t currPosition = this->stream()->getPosition();

        // Calculate how many bytes we must skip to reach the AND mask.
        const int remainingScanlines = this->getInfo().height() - startScanline - height;
        const size_t bytesToSkip = remainingScanlines * this->srcRowBytes() +
                startScanline * fAndMaskRowBytes;
        const size_t subStreamStartPosition = currPosition + bytesToSkip;
        if (subStreamStartPosition >= length) {
            // FIXME: How can we indicate that this decode was actually incomplete?
            return height;
        }

        // Create a subStream to pass to decodeIcoMask().  It is useful to encapsulate
        // the memory base into a stream in order to safely handle incomplete images
        // without reading out of bounds memory.
        const void* subStreamMemoryBase = SkTAddOffset<const void>(memoryBase,
                subStreamStartPosition);
        const size_t subStreamLength = length - subStreamStartPosition;
        // This call does not transfer ownership of the subStreamMemoryBase.
        SkMemoryStream subStream(subStreamMemoryBase, subStreamLength, false);

        // FIXME: If decodeIcoMask does not succeed, is there a way that we can
        //        indicate the decode was incomplete?
        decodeIcoMask(&subStream, dstInfo, dst, dstRowBytes);
    }

    return height;
}

void SkBmpStandardCodec::decodeIcoMask(SkStream* stream, const SkImageInfo& dstInfo,
        void* dst, size_t dstRowBytes) {
    // BMP in ICO have transparency, so this cannot be 565, and this mask
    // prevents us from using kIndex8. The below code depends on the output
    // being an SkPMColor.
    SkASSERT(kRGBA_8888_SkColorType == dstInfo.colorType() ||
            kBGRA_8888_SkColorType == dstInfo.colorType());

    // If we are sampling, make sure that we only mask the sampled pixels.
    // We do not need to worry about sampling in the y-dimension because that
    // should be handled by SkSampledCodec.
    const int sampleX = fSwizzler->sampleX();
    const int sampledWidth = get_scaled_dimension(this->getInfo().width(), sampleX);
    const int srcStartX = get_start_coord(sampleX);


    SkPMColor* dstPtr = (SkPMColor*) dst;
    for (int y = 0; y < dstInfo.height(); y++) {
        // The srcBuffer will at least be large enough
        if (stream->read(fSrcBuffer.get(), fAndMaskRowBytes) != fAndMaskRowBytes) {
            SkCodecPrintf("Warning: incomplete AND mask for bmp-in-ico.\n");
            return;
        }

        int row = this->getDstRow(y, dstInfo.height());

        SkPMColor* dstRow =
                SkTAddOffset<SkPMColor>(dstPtr, row * dstRowBytes);

        int srcX = srcStartX;
        for (int dstX = 0; dstX < sampledWidth; dstX++) {
            int quotient;
            int modulus;
            SkTDivMod(srcX, 8, &quotient, &modulus);
            uint32_t shift = 7 - modulus;
            uint32_t alphaBit = (fSrcBuffer.get()[quotient] >> shift) & 0x1;
            dstRow[dstX] &= alphaBit - 1;
            srcX += sampleX;
        }
    }
}

uint64_t SkBmpStandardCodec::onGetFillValue(const SkImageInfo& dstInfo) const {
    const SkPMColor* colorPtr = get_color_ptr(fColorTable.get());
    if (colorPtr) {
        return get_color_table_fill_value(dstInfo.colorType(), dstInfo.alphaType(), colorPtr, 0,
                                          nullptr);
    }
    return INHERITED::onGetFillValue(dstInfo);
}
