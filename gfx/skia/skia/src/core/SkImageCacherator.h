/*
 * Copyright 2015 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#ifndef SkImageCacherator_DEFINED
#define SkImageCacherator_DEFINED

#include "SkImageGenerator.h"
#include "SkMutex.h"
#include "SkTemplates.h"

class GrCaps;
class GrContext;
class GrSamplerParams;
class GrTextureProxy;
class GrUniqueKey;
class SkBitmap;
class SkImage;

/*
 *  Internal class to manage caching the output of an ImageGenerator.
 */
class SkImageCacherator {
public:
    static SkImageCacherator* NewFromGenerator(std::unique_ptr<SkImageGenerator>,
                                               const SkIRect* subset = nullptr);

    ~SkImageCacherator();

    const SkImageInfo& info() const { return fInfo; }
    uint32_t uniqueID() const { return this->getUniqueID(kLegacy_CachedFormat); }

    enum CachedFormat {
        kLegacy_CachedFormat,    // The format from the generator, with any color space stripped out
        kLinearF16_CachedFormat, // Half float RGBA with linear gamma
        kSRGB8888_CachedFormat,  // sRGB bytes
        kSBGR8888_CachedFormat,  // sRGB bytes, in BGR order

        kNumCachedFormats,
    };

    /**
     *  On success (true), bitmap will point to the pixels for this generator. If this returns
     *  false, the bitmap will be reset to empty.
     *
     *  If not NULL, the client will be notified (->notifyAddedToCache()) when resources are
     *  added to the cache on its behalf.
     */
    bool lockAsBitmap(GrContext*, SkBitmap*, const SkImage* client, SkColorSpace* dstColorSpace,
                      SkImage::CachingHint = SkImage::kAllow_CachingHint);

#if SK_SUPPORT_GPU
    /**
     *  Returns a ref() on the texture produced by this generator. The caller must call unref()
     *  when it is done. Will return nullptr on failure.
     *
     *  If not NULL, the client will be notified (->notifyAddedToCache()) when resources are
     *  added to the cache on its behalf.
     *
     *  The caller is responsible for calling proxy->unref() when they are done.
     *
     *  The scaleAdjust in/out parameter will return any scale adjustment that needs
     *  to be applied to the absolute texture coordinates in the case where the image
     *  was resized to meet the sampling requirements (e.g., resized out to the next power of 2).
     *  It can be null if the caller knows resizing will not be required.
     */
    sk_sp<GrTextureProxy> lockAsTextureProxy(GrContext*, const GrSamplerParams&,
                                             SkColorSpace* dstColorSpace,
                                             sk_sp<SkColorSpace>* texColorSpace,
                                             const SkImage* client,
                                             SkScalar scaleAdjust[2],
                                             SkImage::CachingHint = SkImage::kAllow_CachingHint);
#endif

    /**
     *  If the underlying src naturally is represented by an encoded blob (in SkData), this returns
     *  a ref to that data. If not, it returns null.
     *
     *  If a GrContext is specified, then the caller is only interested in gpu-specific encoded
     *  formats, so others (e.g. PNG) can just return nullptr.
     */
    SkData* refEncoded(GrContext*);

    // Only return true if the generate has already been cached.
    bool lockAsBitmapOnlyIfAlreadyCached(SkBitmap*, CachedFormat);
    // Call the underlying generator directly
    bool directGeneratePixels(const SkImageInfo& dstInfo, void* dstPixels, size_t dstRB,
                              int srcX, int srcY, SkTransferFunctionBehavior behavior);

private:
    // Ref-counted tuple(SkImageGenerator, SkMutex) which allows sharing of one generator
    // among several cacherators.
    class SharedGenerator final : public SkNVRefCnt<SharedGenerator> {
    public:
        static sk_sp<SharedGenerator> Make(std::unique_ptr<SkImageGenerator> gen) {
            return gen ? sk_sp<SharedGenerator>(new SharedGenerator(std::move(gen))) : nullptr;
        }

    private:
        explicit SharedGenerator(std::unique_ptr<SkImageGenerator> gen)
            : fGenerator(std::move(gen))
        {
            SkASSERT(fGenerator);
        }

        friend class ScopedGenerator;
        friend class SkImageCacherator;

        std::unique_ptr<SkImageGenerator> fGenerator;
        SkMutex                           fMutex;
    };
    class ScopedGenerator;

    struct Validator {
        Validator(sk_sp<SharedGenerator>, const SkIRect* subset);

        MOZ_IMPLICIT operator bool() const { return fSharedGenerator.get(); }

        sk_sp<SharedGenerator> fSharedGenerator;
        SkImageInfo            fInfo;
        SkIPoint               fOrigin;
        uint32_t               fUniqueID;
    };

    SkImageCacherator(Validator*);

    CachedFormat chooseCacheFormat(SkColorSpace* dstColorSpace, const GrCaps* = nullptr);
    SkImageInfo buildCacheInfo(CachedFormat);

    bool tryLockAsBitmap(SkBitmap*, const SkImage*, SkImage::CachingHint, CachedFormat,
                         const SkImageInfo&);
#if SK_SUPPORT_GPU
    // Returns the texture proxy. If the cacherator is generating the texture and wants to cache it,
    // it should use the passed in key (if the key is valid).
    sk_sp<GrTextureProxy> lockTextureProxy(GrContext*,
                                           const GrUniqueKey& key,
                                           const SkImage* client,
                                           SkImage::CachingHint,
                                           bool willBeMipped,
                                           SkColorSpace* dstColorSpace);
    // Returns the color space of the texture that would be returned if you called lockTexture.
    // Separate code path to allow querying of the color space for textures that cached (even
    // externally).
    sk_sp<SkColorSpace> getColorSpace(GrContext*, SkColorSpace* dstColorSpace);
    void makeCacheKeyFromOrigKey(const GrUniqueKey& origKey, CachedFormat, GrUniqueKey* cacheKey);
#endif

    sk_sp<SharedGenerator> fSharedGenerator;
    const SkImageInfo      fInfo;
    const SkIPoint         fOrigin;

    struct IDRec {
        SkOnce      fOnce;
        uint32_t    fUniqueID;
    };
    mutable IDRec fIDRecs[kNumCachedFormats];

    uint32_t getUniqueID(CachedFormat) const;

    friend class GrImageTextureMaker;
    friend class SkImage;
    friend class SkImage_Generator;
};

#endif
