/*
 * Copyright 2015 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "SkBitmap.h"
#include "SkCodecPriv.h"
#include "SkColorPriv.h"
#include "SkColorSpace_Base.h"
#include "SkColorTable.h"
#include "SkMath.h"
#include "SkOpts.h"
#include "SkPngCodec.h"
#include "SkPoint3.h"
#include "SkSize.h"
#include "SkStream.h"
#include "SkSwizzler.h"
#include "SkTemplates.h"
#include "SkUtils.h"

#include "png.h"

// This warning triggers false postives way too often in here.
#if defined(__GNUC__) && !defined(__clang__)
    #pragma GCC diagnostic ignored "-Wclobbered"
#endif

#if PNG_LIBPNG_VER_MAJOR > 1 || (PNG_LIBPNG_VER_MAJOR == 1 && PNG_LIBPNG_VER_MINOR >= 5)
    // This is not needed with version 1.5
    #undef SK_GOOGLE3_PNG_HACK
#endif

// FIXME (scroggo): We can use png_jumpbuf directly once Google3 is on 1.6
#define PNG_JMPBUF(x) png_jmpbuf((png_structp) x)

///////////////////////////////////////////////////////////////////////////////
// Callback functions
///////////////////////////////////////////////////////////////////////////////

// When setjmp is first called, it returns 0, meaning longjmp was not called.
constexpr int kSetJmpOkay   = 0;
// An error internal to libpng.
constexpr int kPngError     = 1;
// Passed to longjmp when we have decoded as many lines as we need.
constexpr int kStopDecoding = 2;

static void sk_error_fn(png_structp png_ptr, png_const_charp msg) {
    SkCodecPrintf("------ png error %s\n", msg);
    longjmp(PNG_JMPBUF(png_ptr), kPngError);
}

void sk_warning_fn(png_structp, png_const_charp msg) {
    SkCodecPrintf("----- png warning %s\n", msg);
}

#ifdef PNG_READ_UNKNOWN_CHUNKS_SUPPORTED
static int sk_read_user_chunk(png_structp png_ptr, png_unknown_chunkp chunk) {
    SkPngChunkReader* chunkReader = (SkPngChunkReader*)png_get_user_chunk_ptr(png_ptr);
    // readChunk() returning true means continue decoding
    return chunkReader->readChunk((const char*)chunk->name, chunk->data, chunk->size) ? 1 : -1;
}
#endif

///////////////////////////////////////////////////////////////////////////////
// Helpers
///////////////////////////////////////////////////////////////////////////////

class AutoCleanPng : public SkNoncopyable {
public:
    /*
     *  This class does not take ownership of stream or reader, but if codecPtr
     *  is non-NULL, and decodeBounds succeeds, it will have created a new
     *  SkCodec (pointed to by *codecPtr) which will own/ref them, as well as
     *  the png_ptr and info_ptr.
     */
    AutoCleanPng(png_structp png_ptr, SkStream* stream, SkPngChunkReader* reader,
            SkCodec** codecPtr)
        : fPng_ptr(png_ptr)
        , fInfo_ptr(nullptr)
        , fDecodedBounds(false)
        , fReadHeader(false)
        , fStream(stream)
        , fChunkReader(reader)
        , fOutCodec(codecPtr)
    {}

    ~AutoCleanPng() {
        // fInfo_ptr will never be non-nullptr unless fPng_ptr is.
        if (fPng_ptr) {
            png_infopp info_pp = fInfo_ptr ? &fInfo_ptr : nullptr;
            png_destroy_read_struct(&fPng_ptr, info_pp, nullptr);
        }
    }

    void setInfoPtr(png_infop info_ptr) {
        SkASSERT(nullptr == fInfo_ptr);
        fInfo_ptr = info_ptr;
    }

    /**
     *  Reads enough of the input stream to decode the bounds.
     *  @return false if the stream is not a valid PNG (or too short).
     *          true if it read enough of the stream to determine the bounds.
     *          In the latter case, the stream may have been read beyond the
     *          point to determine the bounds, and the png_ptr will have saved
     *          any extra data. Further, if the codecPtr supplied to the
     *          constructor was not NULL, it will now point to a new SkCodec,
     *          which owns (or refs, in the case of the SkPngChunkReader) the
     *          inputs. If codecPtr was NULL, the png_ptr and info_ptr are
     *          unowned, and it is up to the caller to destroy them.
     */
    bool decodeBounds();

private:
    png_structp         fPng_ptr;
    png_infop           fInfo_ptr;
    bool                fDecodedBounds;
    bool                fReadHeader;
    SkStream*           fStream;
    SkPngChunkReader*   fChunkReader;
    SkCodec**           fOutCodec;

    /**
     *  Supplied to libpng to call when it has read enough data to determine
     *  bounds.
     */
    static void InfoCallback(png_structp png_ptr, png_infop) {
        // png_get_progressive_ptr returns the pointer we set on the png_ptr with
        // png_set_progressive_read_fn
        static_cast<AutoCleanPng*>(png_get_progressive_ptr(png_ptr))->infoCallback();
    }

    void infoCallback();

#ifdef SK_GOOGLE3_PNG_HACK
// public so it can be called by SkPngCodec::rereadHeaderIfNecessary().
public:
#endif
    void releasePngPtrs() {
        fPng_ptr = nullptr;
        fInfo_ptr = nullptr;
    }
};
#define AutoCleanPng(...) SK_REQUIRE_LOCAL_VAR(AutoCleanPng)

bool AutoCleanPng::decodeBounds() {
    if (setjmp(PNG_JMPBUF(fPng_ptr))) {
        return false;
    }

    png_set_progressive_read_fn(fPng_ptr, this, InfoCallback, nullptr, nullptr);

    // Arbitrary buffer size, though note that it matches (below)
    // SkPngCodec::processData(). FIXME: Can we better suit this to the size of
    // the PNG header?
    constexpr size_t kBufferSize = 4096;
    char buffer[kBufferSize];

    while (true) {
        const size_t bytesRead = fStream->read(buffer, kBufferSize);
        if (!bytesRead) {
            // We have read to the end of the input without decoding bounds.
            break;
        }

        png_process_data(fPng_ptr, fInfo_ptr, (png_bytep) buffer, bytesRead);
        if (fReadHeader) {
            break;
        }
    }

    // For safety, clear the pointer to this object.
    png_set_progressive_read_fn(fPng_ptr, nullptr, nullptr, nullptr, nullptr);
    return fDecodedBounds;
}

void SkPngCodec::processData() {
    switch (setjmp(PNG_JMPBUF(fPng_ptr))) {
        case kPngError:
            // There was an error. Stop processing data.
            // FIXME: Do we need to discard png_ptr?
            return;
        case kStopDecoding:
            // We decoded all the lines we want.
            return;
        case kSetJmpOkay:
            // Everything is okay.
            break;
        default:
            // No other values should be passed to longjmp.
            SkASSERT(false);
    }

    // Arbitrary buffer size
    constexpr size_t kBufferSize = 4096;
    char buffer[kBufferSize];

    while (true) {
        const size_t bytesRead = this->stream()->read(buffer, kBufferSize);
        png_process_data(fPng_ptr, fInfo_ptr, (png_bytep) buffer, bytesRead);

        if (!bytesRead) {
            // We have read to the end of the input. Note that we quit *after*
            // calling png_process_data, because decodeBounds may have told
            // libpng to save the remainder of the buffer, in which case
            // png_process_data will process the saved buffer, though the
            // stream has no more to read.
            break;
        }
    }
}

// Note: SkColorTable claims to store SkPMColors, which is not necessarily the case here.
bool SkPngCodec::createColorTable(const SkImageInfo& dstInfo, int* ctableCount) {

    int numColors;
    png_color* palette;
    if (!png_get_PLTE(fPng_ptr, fInfo_ptr, &palette, &numColors)) {
        return false;
    }

    // Contents depend on tableColorType and our choice of if/when to premultiply:
    // { kPremul, kUnpremul, kOpaque } x { RGBA, BGRA }
    SkPMColor colorTable[256];
    SkColorType tableColorType = fColorXform ? kRGBA_8888_SkColorType : dstInfo.colorType();

    png_bytep alphas;
    int numColorsWithAlpha = 0;
    if (png_get_tRNS(fPng_ptr, fInfo_ptr, &alphas, &numColorsWithAlpha, nullptr)) {
        // If we are performing a color xform, it will handle the premultiply.  Otherwise,
        // we'll do it here.
        bool premultiply =  !fColorXform && needs_premul(dstInfo, this->getInfo());

        // Choose which function to use to create the color table. If the final destination's
        // colortype is unpremultiplied, the color table will store unpremultiplied colors.
        PackColorProc proc = choose_pack_color_proc(premultiply, tableColorType);

        for (int i = 0; i < numColorsWithAlpha; i++) {
            // We don't have a function in SkOpts that combines a set of alphas with a set
            // of RGBs.  We could write one, but it's hardly worth it, given that this
            // is such a small fraction of the total decode time.
            colorTable[i] = proc(alphas[i], palette->red, palette->green, palette->blue);
            palette++;
        }
    }

    if (numColorsWithAlpha < numColors) {
        // The optimized code depends on a 3-byte png_color struct with the colors
        // in RGB order.  These checks make sure it is safe to use.
        static_assert(3 == sizeof(png_color), "png_color struct has changed.  Opts are broken.");
#ifdef SK_DEBUG
        SkASSERT(&palette->red < &palette->green);
        SkASSERT(&palette->green < &palette->blue);
#endif

        if (is_rgba(tableColorType)) {
            SkOpts::RGB_to_RGB1(colorTable + numColorsWithAlpha, palette,
                    numColors - numColorsWithAlpha);
        } else {
            SkOpts::RGB_to_BGR1(colorTable + numColorsWithAlpha, palette,
                    numColors - numColorsWithAlpha);
        }
    }

    // If we are not decoding to F16, we can color xform now and store the results
    // in the color table.
    if (fColorXform && kRGBA_F16_SkColorType != dstInfo.colorType()) {
        SkColorSpaceXform::ColorFormat xformColorFormat = is_rgba(dstInfo.colorType()) ?
                SkColorSpaceXform::kRGBA_8888_ColorFormat :
                SkColorSpaceXform::kBGRA_8888_ColorFormat;
        SkAlphaType xformAlphaType = select_xform_alpha(dstInfo.alphaType(),
                                                        this->getInfo().alphaType());
        fColorXform->apply(colorTable, colorTable, numColors, xformColorFormat,
                           SkColorSpaceXform::kRGBA_8888_ColorFormat, xformAlphaType);
    }

    // Pad the color table with the last color in the table (or black) in the case that
    // invalid pixel indices exceed the number of colors in the table.
    const int maxColors = 1 << fBitDepth;
    if (numColors < maxColors) {
        SkPMColor lastColor = numColors > 0 ? colorTable[numColors - 1] : SK_ColorBLACK;
        sk_memset32(colorTable + numColors, lastColor, maxColors - numColors);
    }

    // Set the new color count.
    if (ctableCount != nullptr) {
        *ctableCount = maxColors;
    }

    fColorTable.reset(new SkColorTable(colorTable, maxColors));
    return true;
}

///////////////////////////////////////////////////////////////////////////////
// Creation
///////////////////////////////////////////////////////////////////////////////

bool SkPngCodec::IsPng(const char* buf, size_t bytesRead) {
    return !png_sig_cmp((png_bytep) buf, (png_size_t)0, bytesRead);
}

#if (PNG_LIBPNG_VER_MAJOR > 1) || (PNG_LIBPNG_VER_MAJOR == 1 && PNG_LIBPNG_VER_MINOR >= 6)

static float png_fixed_point_to_float(png_fixed_point x) {
    // We multiply by the same factor that libpng used to convert
    // fixed point -> double.  Since we want floats, we choose to
    // do the conversion ourselves rather than convert
    // fixed point -> double -> float.
    return ((float) x) * 0.00001f;
}

static float png_inverted_fixed_point_to_float(png_fixed_point x) {
    // This is necessary because the gAMA chunk actually stores 1/gamma.
    return 1.0f / png_fixed_point_to_float(x);
}

static constexpr float gSRGB_toXYZD50[] {
    0.4358f, 0.3853f, 0.1430f,    // Rx, Gx, Bx
    0.2224f, 0.7170f, 0.0606f,    // Ry, Gy, Gz
    0.0139f, 0.0971f, 0.7139f,    // Rz, Gz, Bz
};

static bool convert_to_D50(SkMatrix44* toXYZD50, float toXYZ[9], float whitePoint[2]) {
    float wX = whitePoint[0];
    float wY = whitePoint[1];
    if (wX < 0.0f || wY < 0.0f || (wX + wY > 1.0f)) {
        return false;
    }

    // Calculate the XYZ illuminant.  Call this the src illuminant.
    float wZ = 1.0f - wX - wY;
    float scale = 1.0f / wY;
    // TODO (msarett):
    // What are common src illuminants?  I'm guessing we will almost always see D65.  Should
    // we go ahead and save a precomputed D65->D50 Bradford matrix?  Should we exit early if
    // if the src illuminant is D50?
    SkVector3 srcXYZ = SkVector3::Make(wX * scale, 1.0f, wZ * scale);

    // The D50 illuminant.
    SkVector3 dstXYZ = SkVector3::Make(0.96422f, 1.0f, 0.82521f);

    // Calculate the chromatic adaptation matrix.  We will use the Bradford method, thus
    // the matrices below.  The Bradford method is used by Adobe and is widely considered
    // to be the best.
    // http://www.brucelindbloom.com/index.html?Eqn_ChromAdapt.html
    SkMatrix mA, mAInv;
    mA.setAll(0.8951f, 0.2664f, -0.1614f, -0.7502f, 1.7135f, 0.0367f, 0.0389f, -0.0685f, 1.0296f);
    mAInv.setAll(0.9869929f, -0.1470543f, 0.1599627f, 0.4323053f, 0.5183603f, 0.0492912f,
                 -0.0085287f, 0.0400428f, 0.9684867f);

    // Map illuminant into cone response domain.
    SkVector3 srcCone;
    srcCone.fX = mA[0] * srcXYZ.fX + mA[1] * srcXYZ.fY + mA[2] * srcXYZ.fZ;
    srcCone.fY = mA[3] * srcXYZ.fX + mA[4] * srcXYZ.fY + mA[5] * srcXYZ.fZ;
    srcCone.fZ = mA[6] * srcXYZ.fX + mA[7] * srcXYZ.fY + mA[8] * srcXYZ.fZ;
    SkVector3 dstCone;
    dstCone.fX = mA[0] * dstXYZ.fX + mA[1] * dstXYZ.fY + mA[2] * dstXYZ.fZ;
    dstCone.fY = mA[3] * dstXYZ.fX + mA[4] * dstXYZ.fY + mA[5] * dstXYZ.fZ;
    dstCone.fZ = mA[6] * dstXYZ.fX + mA[7] * dstXYZ.fY + mA[8] * dstXYZ.fZ;

    SkMatrix DXToD50;
    DXToD50.setIdentity();
    DXToD50[0] = dstCone.fX / srcCone.fX;
    DXToD50[4] = dstCone.fY / srcCone.fY;
    DXToD50[8] = dstCone.fZ / srcCone.fZ;
    DXToD50.postConcat(mAInv);
    DXToD50.preConcat(mA);

    SkMatrix toXYZ3x3;
    toXYZ3x3.setAll(toXYZ[0], toXYZ[3], toXYZ[6], toXYZ[1], toXYZ[4], toXYZ[7], toXYZ[2], toXYZ[5],
                    toXYZ[8]);
    toXYZ3x3.postConcat(DXToD50);

    toXYZD50->set3x3(toXYZ3x3[0], toXYZ3x3[3], toXYZ3x3[6],
                     toXYZ3x3[1], toXYZ3x3[4], toXYZ3x3[7],
                     toXYZ3x3[2], toXYZ3x3[5], toXYZ3x3[8]);
    return true;
}

#endif // LIBPNG >= 1.6

// Returns a colorSpace object that represents any color space information in
// the encoded data.  If the encoded data contains no color space, this will
// return NULL.
sk_sp<SkColorSpace> read_color_space(png_structp png_ptr, png_infop info_ptr) {

#if (PNG_LIBPNG_VER_MAJOR > 1) || (PNG_LIBPNG_VER_MAJOR == 1 && PNG_LIBPNG_VER_MINOR >= 6)

    // First check for an ICC profile
    png_bytep profile;
    png_uint_32 length;
    // The below variables are unused, however, we need to pass them in anyway or
    // png_get_iCCP() will return nothing.
    // Could knowing the |name| of the profile ever be interesting?  Maybe for debugging?
    png_charp name;
    // The |compression| is uninteresting since:
    //   (1) libpng has already decompressed the profile for us.
    //   (2) "deflate" is the only mode of decompression that libpng supports.
    int compression;
    if (PNG_INFO_iCCP == png_get_iCCP(png_ptr, info_ptr, &name, &compression, &profile,
            &length)) {
        return SkColorSpace::NewICC(profile, length);
    }

    // Second, check for sRGB.
    if (png_get_valid(png_ptr, info_ptr, PNG_INFO_sRGB)) {

        // sRGB chunks also store a rendering intent: Absolute, Relative,
        // Perceptual, and Saturation.
        // FIXME (msarett): Extract this information from the sRGB chunk once
        //                  we are able to handle this information in
        //                  SkColorSpace.
        return SkColorSpace::NewNamed(SkColorSpace::kSRGB_Named);
    }

    // Next, check for chromaticities.
    png_fixed_point toXYZFixed[9];
    float toXYZ[9];
    png_fixed_point whitePointFixed[2];
    float whitePoint[2];
    png_fixed_point gamma;
    float gammas[3];
    if (png_get_cHRM_XYZ_fixed(png_ptr, info_ptr, &toXYZFixed[0], &toXYZFixed[1], &toXYZFixed[2],
                               &toXYZFixed[3], &toXYZFixed[4], &toXYZFixed[5], &toXYZFixed[6],
                               &toXYZFixed[7], &toXYZFixed[8]) &&
        png_get_cHRM_fixed(png_ptr, info_ptr, &whitePointFixed[0], &whitePointFixed[1], nullptr,
                           nullptr, nullptr, nullptr, nullptr, nullptr))
    {
        for (int i = 0; i < 9; i++) {
            toXYZ[i] = png_fixed_point_to_float(toXYZFixed[i]);
        }
        whitePoint[0] = png_fixed_point_to_float(whitePointFixed[0]);
        whitePoint[1] = png_fixed_point_to_float(whitePointFixed[1]);

        SkMatrix44 toXYZD50(SkMatrix44::kUninitialized_Constructor);
        if (!convert_to_D50(&toXYZD50, toXYZ, whitePoint)) {
            toXYZD50.set3x3RowMajorf(gSRGB_toXYZD50);
        }

        if (PNG_INFO_gAMA == png_get_gAMA_fixed(png_ptr, info_ptr, &gamma)) {
            float value = png_inverted_fixed_point_to_float(gamma);
            gammas[0] = value;
            gammas[1] = value;
            gammas[2] = value;

            return SkColorSpace_Base::NewRGB(gammas, toXYZD50);
        }

        // Default to sRGB gamma if the image has color space information,
        // but does not specify gamma.
        return SkColorSpace::NewRGB(SkColorSpace::kSRGB_RenderTargetGamma, toXYZD50);
    }

    // Last, check for gamma.
    if (PNG_INFO_gAMA == png_get_gAMA_fixed(png_ptr, info_ptr, &gamma)) {

        // Set the gammas.
        float value = png_inverted_fixed_point_to_float(gamma);
        gammas[0] = value;
        gammas[1] = value;
        gammas[2] = value;

        // Since there is no cHRM, we will guess sRGB gamut.
        SkMatrix44 toXYZD50(SkMatrix44::kUninitialized_Constructor);
        toXYZD50.set3x3RowMajorf(gSRGB_toXYZD50);

        return SkColorSpace_Base::NewRGB(gammas, toXYZD50);
    }

#endif // LIBPNG >= 1.6

    // Report that there is no color space information in the PNG.  SkPngCodec is currently
    // implemented to guess sRGB in this case.
    return nullptr;
}

void SkPngCodec::allocateStorage(const SkImageInfo& dstInfo) {
    switch (fXformMode) {
        case kSwizzleOnly_XformMode:
            break;
        case kColorOnly_XformMode:
            // Intentional fall through.  A swizzler hasn't been created yet, but one will
            // be created later if we are sampling.  We'll go ahead and allocate
            // enough memory to swizzle if necessary.
        case kSwizzleColor_XformMode: {
            const size_t colorXformBytes = dstInfo.width() * sizeof(uint32_t);
            fStorage.reset(colorXformBytes);
            fColorXformSrcRow = (uint32_t*) fStorage.get();
            break;
        }
    }
}

void SkPngCodec::applyXformRow(void* dst, const void* src) {
    const SkColorSpaceXform::ColorFormat srcColorFormat = SkColorSpaceXform::kRGBA_8888_ColorFormat;
    switch (fXformMode) {
        case kSwizzleOnly_XformMode:
            fSwizzler->swizzle(dst, (const uint8_t*) src);
            break;
        case kColorOnly_XformMode:
            fColorXform->apply(dst, (const uint32_t*) src, fXformWidth, fXformColorFormat,
                               srcColorFormat, fXformAlphaType);
            break;
        case kSwizzleColor_XformMode:
            fSwizzler->swizzle(fColorXformSrcRow, (const uint8_t*) src);
            fColorXform->apply(dst, fColorXformSrcRow, fXformWidth, fXformColorFormat,
                               srcColorFormat, fXformAlphaType);
            break;
    }
}

class SkPngNormalDecoder : public SkPngCodec {
public:
    SkPngNormalDecoder(const SkEncodedInfo& info, const SkImageInfo& imageInfo, SkStream* stream,
            SkPngChunkReader* reader, png_structp png_ptr, png_infop info_ptr, int bitDepth)
        : INHERITED(info, imageInfo, stream, reader, png_ptr, info_ptr, bitDepth)
        , fLinesDecoded(0)
        , fDst(nullptr)
        , fRowBytes(0)
        , fFirstRow(0)
        , fLastRow(0)
    {}

    static void AllRowsCallback(png_structp png_ptr, png_bytep row, png_uint_32 rowNum, int /*pass*/) {
        GetDecoder(png_ptr)->allRowsCallback(row, rowNum);
    }

    static void RowCallback(png_structp png_ptr, png_bytep row, png_uint_32 rowNum, int /*pass*/) {
        GetDecoder(png_ptr)->rowCallback(row, rowNum);
    }

#ifdef SK_GOOGLE3_PNG_HACK
    static void RereadInfoCallback(png_structp png_ptr, png_infop) {
        GetDecoder(png_ptr)->rereadInfoCallback();
    }
#endif

private:
    int                         fLinesDecoded; // FIXME: Move to baseclass?
    void*                       fDst;
    size_t                      fRowBytes;

    // Variables for partial decode
    int                         fFirstRow;  // FIXME: Move to baseclass?
    int                         fLastRow;

    typedef SkPngCodec INHERITED;

    static SkPngNormalDecoder* GetDecoder(png_structp png_ptr) {
        return static_cast<SkPngNormalDecoder*>(png_get_progressive_ptr(png_ptr));
    }

    Result decodeAllRows(void* dst, size_t rowBytes, int* rowsDecoded) override {
        const int height = this->getInfo().height();
        png_progressive_info_ptr callback = nullptr;
#ifdef SK_GOOGLE3_PNG_HACK
        callback = RereadInfoCallback;
#endif
        png_set_progressive_read_fn(this->png_ptr(), this, callback, AllRowsCallback, nullptr);
        fDst = dst;
        fRowBytes = rowBytes;

        fLinesDecoded = 0;

        this->processData();

        if (fLinesDecoded == height) {
            return SkCodec::kSuccess;
        }

        if (rowsDecoded) {
            *rowsDecoded = fLinesDecoded;
        }

        return SkCodec::kIncompleteInput;
    }

    void allRowsCallback(png_bytep row, int rowNum) {
        SkASSERT(rowNum - fFirstRow == fLinesDecoded);
        fLinesDecoded++;
        this->applyXformRow(fDst, row);
        fDst = SkTAddOffset<void>(fDst, fRowBytes);
    }

    void setRange(int firstRow, int lastRow, void* dst, size_t rowBytes) override {
        png_progressive_info_ptr callback = nullptr;
#ifdef SK_GOOGLE3_PNG_HACK
        callback = RereadInfoCallback;
#endif
        png_set_progressive_read_fn(this->png_ptr(), this, callback, RowCallback, nullptr);
        fFirstRow = firstRow;
        fLastRow = lastRow;
        fDst = dst;
        fRowBytes = rowBytes;
        fLinesDecoded = 0;
    }

    SkCodec::Result decode(int* rowsDecoded) override {
        this->processData();

        if (fLinesDecoded == fLastRow - fFirstRow + 1) {
            return SkCodec::kSuccess;
        }

        if (rowsDecoded) {
            *rowsDecoded = fLinesDecoded;
        }

        return SkCodec::kIncompleteInput;
    }

    void rowCallback(png_bytep row, int rowNum) {
        if (rowNum < fFirstRow) {
            // Ignore this row.
            return;
        }

        SkASSERT(rowNum <= fLastRow);

        // If there is no swizzler, all rows are needed.
        if (!this->swizzler() || this->swizzler()->rowNeeded(fLinesDecoded)) {
            this->applyXformRow(fDst, row);
            fDst = SkTAddOffset<void>(fDst, fRowBytes);
        }

        fLinesDecoded++;

        if (rowNum == fLastRow) {
            // Fake error to stop decoding scanlines.
            longjmp(PNG_JMPBUF(this->png_ptr()), kStopDecoding);
        }
    }
};

class SkPngInterlacedDecoder : public SkPngCodec {
public:
    SkPngInterlacedDecoder(const SkEncodedInfo& info, const SkImageInfo& imageInfo,
            SkStream* stream, SkPngChunkReader* reader, png_structp png_ptr, png_infop info_ptr,
            int bitDepth, int numberPasses)
        : INHERITED(info, imageInfo, stream, reader, png_ptr, info_ptr, bitDepth)
        , fNumberPasses(numberPasses)
        , fFirstRow(0)
        , fLastRow(0)
        , fLinesDecoded(0)
        , fInterlacedComplete(false)
        , fPng_rowbytes(0)
    {}

    static void InterlacedRowCallback(png_structp png_ptr, png_bytep row, png_uint_32 rowNum, int pass) {
        auto decoder = static_cast<SkPngInterlacedDecoder*>(png_get_progressive_ptr(png_ptr));
        decoder->interlacedRowCallback(row, rowNum, pass);
    }

#ifdef SK_GOOGLE3_PNG_HACK
    static void RereadInfoInterlacedCallback(png_structp png_ptr, png_infop) {
        static_cast<SkPngInterlacedDecoder*>(png_get_progressive_ptr(png_ptr))->rereadInfoInterlaced();
    }
#endif

private:
    const int               fNumberPasses;
    int                     fFirstRow;
    int                     fLastRow;
    void*                   fDst;
    size_t                  fRowBytes;
    int                     fLinesDecoded;
    bool                    fInterlacedComplete;
    size_t                  fPng_rowbytes;
    SkAutoTMalloc<png_byte> fInterlaceBuffer;

    typedef SkPngCodec INHERITED;

#ifdef SK_GOOGLE3_PNG_HACK
    void rereadInfoInterlaced() {
        this->rereadInfoCallback();
        // Note: This allocates more memory than necessary, if we are sampling/subset.
        this->setUpInterlaceBuffer(this->getInfo().height());
    }
#endif

    // FIXME: Currently sharing interlaced callback for all rows and subset. It's not
    // as expensive as the subset version of non-interlaced, but it still does extra
    // work.
    void interlacedRowCallback(png_bytep row, int rowNum, int pass) {
        if (rowNum < fFirstRow || rowNum > fLastRow) {
            // Ignore this row
            return;
        }

        png_bytep oldRow = fInterlaceBuffer.get() + (rowNum - fFirstRow) * fPng_rowbytes;
        png_progressive_combine_row(this->png_ptr(), oldRow, row);

        if (0 == pass) {
            // The first pass initializes all rows.
            SkASSERT(row);
            SkASSERT(fLinesDecoded == rowNum - fFirstRow);
            fLinesDecoded++;
        } else {
            SkASSERT(fLinesDecoded == fLastRow - fFirstRow + 1);
            if (fNumberPasses - 1 == pass && rowNum == fLastRow) {
                // Last pass, and we have read all of the rows we care about. Note that
                // we do not care about reading anything beyond the end of the image (or
                // beyond the last scanline requested).
                fInterlacedComplete = true;
                // Fake error to stop decoding scanlines.
                longjmp(PNG_JMPBUF(this->png_ptr()), kStopDecoding);
            }
        }
    }

    SkCodec::Result decodeAllRows(void* dst, size_t rowBytes, int* rowsDecoded) override {
        const int height = this->getInfo().height();
        this->setUpInterlaceBuffer(height);
        png_progressive_info_ptr callback = nullptr;
#ifdef SK_GOOGLE3_PNG_HACK
        callback = RereadInfoInterlacedCallback;
#endif
        png_set_progressive_read_fn(this->png_ptr(), this, callback, InterlacedRowCallback,
                                    nullptr);

        fFirstRow = 0;
        fLastRow = height - 1;
        fLinesDecoded = 0;

        this->processData();

        png_bytep srcRow = fInterlaceBuffer.get();
        // FIXME: When resuming, this may rewrite rows that did not change.
        for (int rowNum = 0; rowNum < fLinesDecoded; rowNum++) {
            this->applyXformRow(dst, srcRow);
            dst = SkTAddOffset<void>(dst, rowBytes);
            srcRow = SkTAddOffset<png_byte>(srcRow, fPng_rowbytes);
        }
        if (fInterlacedComplete) {
            return SkCodec::kSuccess;
        }

        if (rowsDecoded) {
            *rowsDecoded = fLinesDecoded;
        }

        return SkCodec::kIncompleteInput;
    }

    void setRange(int firstRow, int lastRow, void* dst, size_t rowBytes) override {
        // FIXME: We could skip rows in the interlace buffer that we won't put in the output.
        this->setUpInterlaceBuffer(lastRow - firstRow + 1);
        png_progressive_info_ptr callback = nullptr;
#ifdef SK_GOOGLE3_PNG_HACK
        callback = RereadInfoInterlacedCallback;
#endif
        png_set_progressive_read_fn(this->png_ptr(), this, callback, InterlacedRowCallback, nullptr);
        fFirstRow = firstRow;
        fLastRow = lastRow;
        fDst = dst;
        fRowBytes = rowBytes;
        fLinesDecoded = 0;
    }

    SkCodec::Result decode(int* rowsDecoded) override {
        this->processData();

        // Now apply Xforms on all the rows that were decoded.
        if (!fLinesDecoded) {
            return SkCodec::kIncompleteInput;
        }
        const int lastRow = fLinesDecoded + fFirstRow - 1;
        SkASSERT(lastRow <= fLastRow);

        // FIXME: For resuming interlace, we may swizzle a row that hasn't changed. But it
        // may be too tricky/expensive to handle that correctly.
        png_bytep srcRow = fInterlaceBuffer.get();
        const int sampleY = this->swizzler() ? this->swizzler()->sampleY() : 1;
        void* dst = fDst;
        for (int rowNum = fFirstRow; rowNum <= lastRow; rowNum += sampleY) {
            this->applyXformRow(dst, srcRow);
            dst = SkTAddOffset<void>(dst, fRowBytes);
            srcRow = SkTAddOffset<png_byte>(srcRow, fPng_rowbytes * sampleY);
        }

        if (fInterlacedComplete) {
            return SkCodec::kSuccess;
        }

        if (rowsDecoded) {
            *rowsDecoded = fLinesDecoded;
        }
        return SkCodec::kIncompleteInput;
    }

    void setUpInterlaceBuffer(int height) {
        fPng_rowbytes = png_get_rowbytes(this->png_ptr(), this->info_ptr());
        fInterlaceBuffer.reset(fPng_rowbytes * height);
        fInterlacedComplete = false;
    }
};

#ifdef SK_GOOGLE3_PNG_HACK
bool SkPngCodec::rereadHeaderIfNecessary() {
    if (!fNeedsToRereadHeader) {
        return true;
    }

    // On the first call, we'll need to rewind ourselves. Future calls will
    // have already rewound in rewindIfNecessary.
    if (this->stream()->getPosition() > 0) {
        this->stream()->rewind();
    }

    this->destroyReadStruct();
    png_structp png_ptr = png_create_read_struct(PNG_LIBPNG_VER_STRING, nullptr,
                                                 sk_error_fn, sk_warning_fn);
    if (!png_ptr) {
        return false;
    }

    // Only use the AutoCleanPng to delete png_ptr as necessary.
    // (i.e. not for reading bounds etc.)
    AutoCleanPng autoClean(png_ptr, nullptr, nullptr, nullptr);

    png_infop info_ptr = png_create_info_struct(png_ptr);
    if (info_ptr == nullptr) {
        return false;
    }

    autoClean.setInfoPtr(info_ptr);

#ifdef PNG_READ_UNKNOWN_CHUNKS_SUPPORTED
    // Hookup our chunkReader so we can see any user-chunks the caller may be interested in.
    // This needs to be installed before we read the png header.  Android may store ninepatch
    // chunks in the header.
    if (fPngChunkReader.get()) {
        png_set_keep_unknown_chunks(png_ptr, PNG_HANDLE_CHUNK_ALWAYS, (png_byte*)"", 0);
        png_set_read_user_chunk_fn(png_ptr, (png_voidp) fPngChunkReader.get(), sk_read_user_chunk);
    }
#endif

    fPng_ptr = png_ptr;
    fInfo_ptr = info_ptr;
    autoClean.releasePngPtrs();
    fNeedsToRereadHeader = false;
    return true;
}
#endif // SK_GOOGLE3_PNG_HACK

// Reads the header and initializes the output fields, if not NULL.
//
// @param stream Input data. Will be read to get enough information to properly
//      setup the codec.
// @param chunkReader SkPngChunkReader, for reading unknown chunks. May be NULL.
//      If not NULL, png_ptr will hold an *unowned* pointer to it. The caller is
//      expected to continue to own it for the lifetime of the png_ptr.
// @param outCodec Optional output variable.  If non-NULL, will be set to a new
//      SkPngCodec on success.
// @param png_ptrp Optional output variable. If non-NULL, will be set to a new
//      png_structp on success.
// @param info_ptrp Optional output variable. If non-NULL, will be set to a new
//      png_infop on success;
// @return true on success, in which case the caller is responsible for calling
//      png_destroy_read_struct(png_ptrp, info_ptrp).
//      If it returns false, the passed in fields (except stream) are unchanged.
static bool read_header(SkStream* stream, SkPngChunkReader* chunkReader, SkCodec** outCodec,
                        png_structp* png_ptrp, png_infop* info_ptrp) {
    // The image is known to be a PNG. Decode enough to know the SkImageInfo.
    png_structp png_ptr = png_create_read_struct(PNG_LIBPNG_VER_STRING, nullptr,
                                                 sk_error_fn, sk_warning_fn);
    if (!png_ptr) {
        return false;
    }

    AutoCleanPng autoClean(png_ptr, stream, chunkReader, outCodec);

    png_infop info_ptr = png_create_info_struct(png_ptr);
    if (info_ptr == nullptr) {
        return false;
    }

    autoClean.setInfoPtr(info_ptr);

    // FIXME: Could we use the return value of setjmp to specify the type of
    // error?
    if (setjmp(PNG_JMPBUF(png_ptr))) {
        return false;
    }

#ifdef PNG_READ_UNKNOWN_CHUNKS_SUPPORTED
    // Hookup our chunkReader so we can see any user-chunks the caller may be interested in.
    // This needs to be installed before we read the png header.  Android may store ninepatch
    // chunks in the header.
    if (chunkReader) {
        png_set_keep_unknown_chunks(png_ptr, PNG_HANDLE_CHUNK_ALWAYS, (png_byte*)"", 0);
        png_set_read_user_chunk_fn(png_ptr, (png_voidp) chunkReader, sk_read_user_chunk);
    }
#endif

    const bool decodedBounds = autoClean.decodeBounds();

    if (!decodedBounds) {
        return false;
    }

    // On success, decodeBounds releases ownership of png_ptr and info_ptr.
    if (png_ptrp) {
        *png_ptrp = png_ptr;
    }
    if (info_ptrp) {
        *info_ptrp = info_ptr;
    }

    // decodeBounds takes care of setting outCodec
    if (outCodec) {
        SkASSERT(*outCodec);
    }
    return true;
}

// FIXME (scroggo): Once SK_GOOGLE3_PNG_HACK is no more, this method can be inline in
// AutoCleanPng::infoCallback
static void general_info_callback(png_structp png_ptr, png_infop info_ptr,
                                  SkEncodedInfo::Color* outColor, SkEncodedInfo::Alpha* outAlpha) {
    png_uint_32 origWidth, origHeight;
    int bitDepth, encodedColorType;
    png_get_IHDR(png_ptr, info_ptr, &origWidth, &origHeight, &bitDepth,
                 &encodedColorType, nullptr, nullptr, nullptr);

    // Tell libpng to strip 16 bit/color files down to 8 bits/color.
    // TODO: Should we handle this in SkSwizzler?  Could this also benefit
    //       RAW decodes?
    if (bitDepth == 16) {
        SkASSERT(PNG_COLOR_TYPE_PALETTE != encodedColorType);
        png_set_strip_16(png_ptr);
    }

    // Now determine the default colorType and alphaType and set the required transforms.
    // Often, we depend on SkSwizzler to perform any transforms that we need.  However, we
    // still depend on libpng for many of the rare and PNG-specific cases.
    SkEncodedInfo::Color color;
    SkEncodedInfo::Alpha alpha;
    switch (encodedColorType) {
        case PNG_COLOR_TYPE_PALETTE:
            // Extract multiple pixels with bit depths of 1, 2, and 4 from a single
            // byte into separate bytes (useful for paletted and grayscale images).
            if (bitDepth < 8) {
                // TODO: Should we use SkSwizzler here?
                png_set_packing(png_ptr);
            }

            color = SkEncodedInfo::kPalette_Color;
            // Set the alpha depending on if a transparency chunk exists.
            alpha = png_get_valid(png_ptr, info_ptr, PNG_INFO_tRNS) ?
                    SkEncodedInfo::kUnpremul_Alpha : SkEncodedInfo::kOpaque_Alpha;
            break;
        case PNG_COLOR_TYPE_RGB:
            if (png_get_valid(png_ptr, info_ptr, PNG_INFO_tRNS)) {
                // Convert to RGBA if transparency chunk exists.
                png_set_tRNS_to_alpha(png_ptr);
                color = SkEncodedInfo::kRGBA_Color;
                alpha = SkEncodedInfo::kBinary_Alpha;
            } else {
                color = SkEncodedInfo::kRGB_Color;
                alpha = SkEncodedInfo::kOpaque_Alpha;
            }
            break;
        case PNG_COLOR_TYPE_GRAY:
            // Expand grayscale images to the full 8 bits from 1, 2, or 4 bits/pixel.
            if (bitDepth < 8) {
                // TODO: Should we use SkSwizzler here?
                png_set_expand_gray_1_2_4_to_8(png_ptr);
            }

            if (png_get_valid(png_ptr, info_ptr, PNG_INFO_tRNS)) {
                png_set_tRNS_to_alpha(png_ptr);
                color = SkEncodedInfo::kGrayAlpha_Color;
                alpha = SkEncodedInfo::kBinary_Alpha;
            } else {
                color = SkEncodedInfo::kGray_Color;
                alpha = SkEncodedInfo::kOpaque_Alpha;
            }
            break;
        case PNG_COLOR_TYPE_GRAY_ALPHA:
            color = SkEncodedInfo::kGrayAlpha_Color;
            alpha = SkEncodedInfo::kUnpremul_Alpha;
            break;
        case PNG_COLOR_TYPE_RGBA:
            color = SkEncodedInfo::kRGBA_Color;
            alpha = SkEncodedInfo::kUnpremul_Alpha;
            break;
        default:
            // All the color types have been covered above.
            SkASSERT(false);
            color = SkEncodedInfo::kRGBA_Color;
            alpha = SkEncodedInfo::kUnpremul_Alpha;
    }
    if (outColor) {
        *outColor = color;
    }
    if (outAlpha) {
        *outAlpha = alpha;
    }
}

#ifdef SK_GOOGLE3_PNG_HACK
void SkPngCodec::rereadInfoCallback() {
    general_info_callback(fPng_ptr, fInfo_ptr, nullptr, nullptr);
    png_set_interlace_handling(fPng_ptr);
    png_read_update_info(fPng_ptr, fInfo_ptr);
}
#endif

void AutoCleanPng::infoCallback() {
    SkEncodedInfo::Color color;
    SkEncodedInfo::Alpha alpha;
    general_info_callback(fPng_ptr, fInfo_ptr, &color, &alpha);

    const int numberPasses = png_set_interlace_handling(fPng_ptr);

    fReadHeader = true;
    fDecodedBounds = true;
#ifndef SK_GOOGLE3_PNG_HACK
    // 1 tells libpng to save any extra data. We may be able to be more efficient by saving
    // it ourselves.
    png_process_data_pause(fPng_ptr, 1);
#else
    // Hack to make png_process_data stop.
    fPng_ptr->buffer_size = 0;
#endif
    if (fOutCodec) {
        SkASSERT(nullptr == *fOutCodec);
        sk_sp<SkColorSpace> colorSpace = read_color_space(fPng_ptr, fInfo_ptr);
        if (!colorSpace) {
            // Treat unmarked pngs as sRGB.
            colorSpace = SkColorSpace::NewNamed(SkColorSpace::kSRGB_Named);
        }

        SkEncodedInfo encodedInfo = SkEncodedInfo::Make(color, alpha, 8);
        // FIXME (scroggo): Once we get rid of SK_GOOGLE3_PNG_HACK, general_info_callback can
        // be inlined, so these values will already be set.
        png_uint_32 origWidth = png_get_image_width(fPng_ptr, fInfo_ptr);
        png_uint_32 origHeight = png_get_image_height(fPng_ptr, fInfo_ptr);
        png_byte bitDepth = png_get_bit_depth(fPng_ptr, fInfo_ptr);
        SkImageInfo imageInfo = encodedInfo.makeImageInfo(origWidth, origHeight, colorSpace);

        if (SkEncodedInfo::kOpaque_Alpha == alpha) {
            png_color_8p sigBits;
            if (png_get_sBIT(fPng_ptr, fInfo_ptr, &sigBits)) {
                if (5 == sigBits->red && 6 == sigBits->green && 5 == sigBits->blue) {
                    // Recommend a decode to 565 if the sBIT indicates 565.
                    imageInfo = imageInfo.makeColorType(kRGB_565_SkColorType);
                }
            }
        }

        if (1 == numberPasses) {
            *fOutCodec = new SkPngNormalDecoder(encodedInfo, imageInfo, fStream,
                    fChunkReader, fPng_ptr, fInfo_ptr, bitDepth);
        } else {
            *fOutCodec = new SkPngInterlacedDecoder(encodedInfo, imageInfo, fStream,
                    fChunkReader, fPng_ptr, fInfo_ptr, bitDepth, numberPasses);
        }
    }


    // Release the pointers, which are now owned by the codec or the caller is expected to
    // take ownership.
    this->releasePngPtrs();
}

SkPngCodec::SkPngCodec(const SkEncodedInfo& encodedInfo, const SkImageInfo& imageInfo,
                       SkStream* stream, SkPngChunkReader* chunkReader, void* png_ptr,
                       void* info_ptr, int bitDepth)
    : INHERITED(encodedInfo, imageInfo, stream)
    , fPngChunkReader(SkSafeRef(chunkReader))
    , fPng_ptr(png_ptr)
    , fInfo_ptr(info_ptr)
    , fColorXformSrcRow(nullptr)
    , fBitDepth(bitDepth)
#ifdef SK_GOOGLE3_PNG_HACK
    , fNeedsToRereadHeader(true)
#endif
{}

SkPngCodec::~SkPngCodec() {
    this->destroyReadStruct();
}

void SkPngCodec::destroyReadStruct() {
    if (fPng_ptr) {
        // We will never have a nullptr fInfo_ptr with a non-nullptr fPng_ptr
        SkASSERT(fInfo_ptr);
        png_destroy_read_struct((png_struct**)&fPng_ptr, (png_info**)&fInfo_ptr, nullptr);
        fPng_ptr = nullptr;
        fInfo_ptr = nullptr;
    }
}

///////////////////////////////////////////////////////////////////////////////
// Getting the pixels
///////////////////////////////////////////////////////////////////////////////

bool SkPngCodec::initializeXforms(const SkImageInfo& dstInfo, const Options& options,
                                  SkPMColor ctable[], int* ctableCount) {
    if (setjmp(PNG_JMPBUF((png_struct*)fPng_ptr))) {
        SkCodecPrintf("Failed on png_read_update_info.\n");
        return false;
    }
    png_read_update_info(fPng_ptr, fInfo_ptr);

    // Reset fSwizzler and fColorXform.  We can't do this in onRewind() because the
    // interlaced scanline decoder may need to rewind.
    fSwizzler.reset(nullptr);
    fColorXform = nullptr;

    if (needs_color_xform(dstInfo, this->getInfo())) {
        fColorXform = SkColorSpaceXform::New(this->getInfo().colorSpace(), dstInfo.colorSpace());
        SkASSERT(fColorXform);
    }

    // If the image is RGBA and we have a color xform, we can skip the swizzler.
    // FIXME (msarett):
    // Support more input types to fColorXform (ex: RGB, Gray) and skip the swizzler more often.
    if (fColorXform && SkEncodedInfo::kRGBA_Color == this->getEncodedInfo().color() &&
        !options.fSubset)
    {
        fXformMode = kColorOnly_XformMode;
        return true;
    }

    if (SkEncodedInfo::kPalette_Color == this->getEncodedInfo().color()) {
        if (!this->createColorTable(dstInfo, ctableCount)) {
            return false;
        }
    }

    // Copy the color table to the client if they request kIndex8 mode.
    copy_color_table(dstInfo, fColorTable, ctable, ctableCount);

    this->initializeSwizzler(dstInfo, options);
    return true;
}

void SkPngCodec::initializeXformParams() {
    switch (fXformMode) {
        case kColorOnly_XformMode:
            fXformColorFormat = select_xform_format(this->dstInfo().colorType());
            fXformAlphaType = select_xform_alpha(this->dstInfo().alphaType(),
                                                 this->getInfo().alphaType());
            fXformWidth = this->dstInfo().width();
            break;
        case kSwizzleColor_XformMode:
            fXformColorFormat = select_xform_format(this->dstInfo().colorType());
            fXformAlphaType = select_xform_alpha(this->dstInfo().alphaType(),
                                                 this->getInfo().alphaType());
            fXformWidth = this->swizzler()->swizzleWidth();
            break;
        default:
            break;
    }
}

static inline bool apply_xform_on_decode(SkColorType dstColorType, SkEncodedInfo::Color srcColor) {
    // We will apply the color xform when reading the color table, unless F16 is requested.
    return SkEncodedInfo::kPalette_Color != srcColor || kRGBA_F16_SkColorType == dstColorType;
}

void SkPngCodec::initializeSwizzler(const SkImageInfo& dstInfo, const Options& options) {
    SkImageInfo swizzlerInfo = dstInfo;
    Options swizzlerOptions = options;
    fXformMode = kSwizzleOnly_XformMode;
    if (fColorXform && apply_xform_on_decode(dstInfo.colorType(), this->getEncodedInfo().color())) {
        swizzlerInfo = swizzlerInfo.makeColorType(kRGBA_8888_SkColorType);
        if (kPremul_SkAlphaType == dstInfo.alphaType()) {
            swizzlerInfo = swizzlerInfo.makeAlphaType(kUnpremul_SkAlphaType);
        }

        fXformMode = kSwizzleColor_XformMode;

        // Here, we swizzle into temporary memory, which is not zero initialized.
        // FIXME (msarett):
        // Is this a problem?
        swizzlerOptions.fZeroInitialized = kNo_ZeroInitialized;
    }

    const SkPMColor* colors = get_color_ptr(fColorTable.get());
    fSwizzler.reset(SkSwizzler::CreateSwizzler(this->getEncodedInfo(), colors, swizzlerInfo,
                                               swizzlerOptions));
    SkASSERT(fSwizzler);
}

SkSampler* SkPngCodec::getSampler(bool createIfNecessary) {
    if (fSwizzler || !createIfNecessary) {
        return fSwizzler;
    }

    this->initializeSwizzler(this->dstInfo(), this->options());
    return fSwizzler;
}

bool SkPngCodec::onRewind() {
#ifdef SK_GOOGLE3_PNG_HACK
    fNeedsToRereadHeader = true;
    return true;
#else
    // This sets fPng_ptr and fInfo_ptr to nullptr. If read_header
    // succeeds, they will be repopulated, and if it fails, they will
    // remain nullptr. Any future accesses to fPng_ptr and fInfo_ptr will
    // come through this function which will rewind and again attempt
    // to reinitialize them.
    this->destroyReadStruct();

    png_structp png_ptr;
    png_infop info_ptr;
    if (!read_header(this->stream(), fPngChunkReader.get(), nullptr, &png_ptr, &info_ptr)) {
        return false;
    }

    fPng_ptr = png_ptr;
    fInfo_ptr = info_ptr;
    return true;
#endif
}

SkCodec::Result SkPngCodec::onGetPixels(const SkImageInfo& dstInfo, void* dst,
                                        size_t rowBytes, const Options& options,
                                        SkPMColor ctable[], int* ctableCount,
                                        int* rowsDecoded) {
    if (!conversion_possible(dstInfo, this->getInfo()) ||
        !this->initializeXforms(dstInfo, options, ctable, ctableCount))
    {
        return kInvalidConversion;
    }
#ifdef SK_GOOGLE3_PNG_HACK
    // Note that this is done after initializeXforms. Otherwise that method
    // would not have png_ptr to use.
    if (!this->rereadHeaderIfNecessary()) {
        return kCouldNotRewind;
    }
#endif

    if (options.fSubset) {
        return kUnimplemented;
    }

    this->allocateStorage(dstInfo);
    this->initializeXformParams();
    return this->decodeAllRows(dst, rowBytes, rowsDecoded);
}

SkCodec::Result SkPngCodec::onStartIncrementalDecode(const SkImageInfo& dstInfo,
        void* dst, size_t rowBytes, const SkCodec::Options& options,
        SkPMColor* ctable, int* ctableCount) {
    if (!conversion_possible(dstInfo, this->getInfo()) ||
        !this->initializeXforms(dstInfo, options, ctable, ctableCount))
    {
        return kInvalidConversion;
    }
#ifdef SK_GOOGLE3_PNG_HACK
    // See note in onGetPixels.
    if (!this->rereadHeaderIfNecessary()) {
        return kCouldNotRewind;
    }
#endif

    this->allocateStorage(dstInfo);

    int firstRow, lastRow;
    if (options.fSubset) {
        firstRow = options.fSubset->top();
        lastRow = options.fSubset->bottom() - 1;
    } else {
        firstRow = 0;
        lastRow = dstInfo.height() - 1;
    }
    this->setRange(firstRow, lastRow, dst, rowBytes);
    return kSuccess;
}

SkCodec::Result SkPngCodec::onIncrementalDecode(int* rowsDecoded) {
    // FIXME: Only necessary on the first call.
    this->initializeXformParams();

    return this->decode(rowsDecoded);
}

uint64_t SkPngCodec::onGetFillValue(const SkImageInfo& dstInfo) const {
    const SkPMColor* colorPtr = get_color_ptr(fColorTable.get());
    if (colorPtr) {
        SkAlphaType alphaType = select_xform_alpha(dstInfo.alphaType(),
                                                   this->getInfo().alphaType());
        return get_color_table_fill_value(dstInfo.colorType(), alphaType, colorPtr, 0,
                                          fColorXform.get());
    }
    return INHERITED::onGetFillValue(dstInfo);
}

SkCodec* SkPngCodec::NewFromStream(SkStream* stream, SkPngChunkReader* chunkReader) {
    SkAutoTDelete<SkStream> streamDeleter(stream);

    SkCodec* outCodec = nullptr;
    if (read_header(streamDeleter.get(), chunkReader, &outCodec, nullptr, nullptr)) {
        // Codec has taken ownership of the stream.
        SkASSERT(outCodec);
        streamDeleter.release();
        return outCodec;
    }

    return nullptr;
}
