/*
 * Copyright 2011 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#ifndef SkImageEncoder_DEFINED
#define SkImageEncoder_DEFINED

#include "SkImageInfo.h"
#include "SkTRegistry.h"

class SkBitmap;
class SkPixelSerializer;
class SkPixmap;
class SkData;
class SkWStream;

class SkImageEncoder {
public:
    // TODO (scroggo): Merge with SkEncodedFormat.
    enum Type {
        kUnknown_Type,
        kBMP_Type,
        kGIF_Type,
        kICO_Type,
        kJPEG_Type,
        kPNG_Type,
        kWBMP_Type,
        kWEBP_Type,
        kKTX_Type,
    };
    static SkImageEncoder* Create(Type);

    virtual ~SkImageEncoder();

    /*  Quality ranges from 0..100 */
    enum {
        kDefaultQuality = 80
    };

    /**
     *  Encode bitmap 'bm', returning the results in an SkData, at quality level
     *  'quality' (which can be in range 0-100). If the bitmap cannot be
     *  encoded, return null. On success, the caller is responsible for
     *  calling unref() on the data when they are finished.
     */
    SkData* encodeData(const SkBitmap&, int quality);

    /**
     * Encode bitmap 'bm' in the desired format, writing results to
     * file 'file', at quality level 'quality' (which can be in range
     * 0-100). Returns false on failure.
     */
    bool encodeFile(const char file[], const SkBitmap& bm, int quality);

    /**
     * Encode bitmap 'bm' in the desired format, writing results to
     * stream 'stream', at quality level 'quality' (which can be in
     * range 0-100). Returns false on failure.
     */
    bool encodeStream(SkWStream* stream, const SkBitmap& bm, int quality);

    static SkData* EncodeData(const SkImageInfo&, const void* pixels, size_t rowBytes,
                              Type, int quality);
    static SkData* EncodeData(const SkBitmap&, Type, int quality);

    static SkData* EncodeData(const SkPixmap&, Type, int quality);

    static bool EncodeFile(const char file[], const SkBitmap&, Type,
                           int quality);
    static bool EncodeStream(SkWStream*, const SkBitmap&, Type,
                           int quality);

    /** Uses SkImageEncoder to serialize images that are not already
        encoded as SkImageEncoder::kPNG_Type images. */
    static SkPixelSerializer* CreatePixelSerializer();

protected:
    /**
     * Encode bitmap 'bm' in the desired format, writing results to
     * stream 'stream', at quality level 'quality' (which can be in
     * range 0-100).
     *
     * This must be overridden by each SkImageEncoder implementation.
     */
    virtual bool onEncode(SkWStream* stream, const SkBitmap& bm, int quality) = 0;
};

// This macro declares a global (i.e., non-class owned) creation entry point
// for each encoder (e.g., CreateJPEGImageEncoder)
#define DECLARE_ENCODER_CREATOR(codec)          \
    SK_API SkImageEncoder *Create ## codec ();

// This macro defines the global creation entry point for each encoder. Each
// encoder implementation that registers with the encoder factory must call it.
#define DEFINE_ENCODER_CREATOR(codec) \
    SkImageEncoder* Create##codec() { return new Sk##codec; }

// All the encoders known by Skia. Note that, depending on the compiler settings,
// not all of these will be available
DECLARE_ENCODER_CREATOR(JPEGImageEncoder);
DECLARE_ENCODER_CREATOR(PNGImageEncoder);
DECLARE_ENCODER_CREATOR(KTXImageEncoder);
DECLARE_ENCODER_CREATOR(WEBPImageEncoder);

#if defined(SK_BUILD_FOR_MAC) || defined(SK_BUILD_FOR_IOS)
SkImageEncoder* CreateImageEncoder_CG(SkImageEncoder::Type type);
#endif

#if defined(SK_BUILD_FOR_WIN)
SkImageEncoder* CreateImageEncoder_WIC(SkImageEncoder::Type type);
#endif

// Typedef to make registering encoder callback easier
// This has to be defined outside SkImageEncoder. :(
typedef SkTRegistry<SkImageEncoder*(*)(SkImageEncoder::Type)> SkImageEncoder_EncodeReg;
#endif
