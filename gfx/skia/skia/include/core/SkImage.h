/*
 * Copyright 2012 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#ifndef SkImage_DEFINED
#define SkImage_DEFINED

#include "GrTypes.h"
#include "SkFilterQuality.h"
#include "SkImageInfo.h"
#include "SkImageEncoder.h"
#include "SkRefCnt.h"
#include "SkScalar.h"
#include "SkShader.h"

#if defined(SK_BUILD_FOR_ANDROID) && __ANDROID_API__ >= 26
#include <android/hardware_buffer.h>
#endif

class SkData;
class SkCanvas;
class SkImageFilter;
class SkImageGenerator;
class SkPaint;
class SkPicture;
class SkString;
class SkSurface;
class GrBackendTexture;
class GrContext;
class GrContextThreadSafeProxy;
class GrTexture;

/** \class SkImage
    SkImage describes a two dimensional array of pixels to draw. The pixels may be
    decoded in a raster bitmap, encoded in a SkPicture or compressed data stream,
    or located in GPU memory as a GPU texture.

    SkImage cannot be modified after it is created. SkImage may allocate additional
    storage as needed; for instance, an encoded SkImage may decode when drawn.

    SkImage width and height are greater than zero. Creating an SkImage with zero width
    or height returns SkImage equal to nullptr.

    SkImage may be created from SkBitmap, SkPixmap, SkSurface, SkPicture, encoded streams,
    GPU texture, YUV_ColorSpace data, or hardware buffer. Encoded streams supported
    include BMP, GIF, HEIF, ICO, JPEG, PNG, WBMP, WebP. Supported encoding details
    vary with platform.
*/
class SK_API SkImage : public SkRefCnt {
public:
    typedef SkImageInfo Info;
    typedef void* ReleaseContext;

    /** Creates SkImage from SkPixmap and copy of pixels. Since pixels are copied, SkPixmap
        pixels may be modified or deleted without affecting SkImage.

        SkImage is returned if SkPixmap is valid. Valid SkPixmap parameters include:
        dimensions are greater than zero;
        each dimension fits in 29 bits;
        SkColorType and SkAlphaType are valid, and SkColorType is not kUnknown_SkColorType;
        row bytes are large enough to hold one row of pixels;
        pixel address is not nullptr.

        @param pixmap  SkImageInfo, pixel address, and row bytes
        @return        copy of SkPixmap pixels, or nullptr
    */
    static sk_sp<SkImage> MakeRasterCopy(const SkPixmap& pixmap);

    /** Creates SkImage from SkImageInfo, sharing pixels.

        SkImage is returned if SkImageInfo is valid. Valid SkImageInfo parameters include:
        dimensions are greater than zero;
        each dimension fits in 29 bits;
        SkColorType and SkAlphaType are valid, and SkColorType is not kUnknown_SkColorType;
        rowBytes are large enough to hold one row of pixels;
        pixels is not nullptr, and contains enough data for SkImage.

        @param info      contains width, height, SkAlphaType, SkColorType, SkColorSpace
        @param pixels    address or pixel storage
        @param rowBytes  size of pixel row or larger
        @return          SkImage sharing pixels, or nullptr
    */
    static sk_sp<SkImage> MakeRasterData(const Info& info, sk_sp<SkData> pixels, size_t rowBytes);

    typedef void (*RasterReleaseProc)(const void* pixels, ReleaseContext);

    /** Creates SkImage from pixmap, sharing SkPixmap pixels. Pixels must remain valid and
        unchanged until rasterReleaseProc is called. rasterReleaseProc is passed
        releaseContext when SkImage is deleted or no longer refers to pixmap pixels.

        Pass nullptr for rasterReleaseProc to share SkPixmap without requiring a callback
        when SkImage is released. Pass nullptr for releaseContext if rasterReleaseProc
        does not require state.

        SkImage is returned if pixmap is valid. Valid SkPixmap parameters include:
        dimensions are greater than zero;
        each dimension fits in 29 bits;
        SkColorType and SkAlphaType are valid, and SkColorType is not kUnknown_SkColorType;
        row bytes are large enough to hold one row of pixels;
        pixel address is not nullptr.

        @param pixmap             SkImageInfo, pixel address, and row bytes
        @param rasterReleaseProc  function called when pixels can be released; or nullptr
        @param releaseContext     state passed to rasterReleaseProc; or nullptr
        @return                   SkImage sharing pixmap
    */
    static sk_sp<SkImage> MakeFromRaster(const SkPixmap& pixmap,
                                         RasterReleaseProc rasterReleaseProc,
                                         ReleaseContext releaseContext);

    /** Creates SkImage from bitmap, sharing or copying bitmap pixels. If the bitmap
        is marked immutable, and its pixel memory is shareable, it may be shared
        instead of copied.

        SkImage is returned if bitmap is valid. Valid SkBitmap parameters include:
        dimensions are greater than zero;
        each dimension fits in 29 bits;
        SkColorType and SkAlphaType are valid, and SkColorType is not kUnknown_SkColorType;
        row bytes are large enough to hold one row of pixels;
        pixel address is not nullptr.

        @param bitmap  SkImageInfo, row bytes, and pixels
        @return        created SkImage, or nullptr
    */
    static sk_sp<SkImage> MakeFromBitmap(const SkBitmap& bitmap);

    /** Creates SkImage from data returned by imageGenerator. Generated data is owned by SkImage and may not
        be shared or accessed.

        subset allows selecting a portion of the full image. Pass nullptr to select the entire image;
        otherwise, subset must be contained by image bounds.

        SkImage is returned if generator data is valid. Valid data parameters vary by type of data
        and platform.

        imageGenerator may wrap SkPicture data, codec data, or custom data.

        @param imageGenerator  stock or custom routines to retrieve SkImage
        @param subset          bounds of returned SkImage; may be nullptr
        @return                created SkImage, or nullptr
    */
    static sk_sp<SkImage> MakeFromGenerator(std::unique_ptr<SkImageGenerator> imageGenerator,
                                            const SkIRect* subset = nullptr);

    /** Creates SkImage from encoded data.
        subset allows selecting a portion of the full image. Pass nullptr to select the entire image;
        otherwise, subset must be contained by image bounds.

        SkImage is returned if format of the encoded data is recognized and supported.
        Recognized formats vary by platform.

        @param encoded  data of SkImage to decode
        @param subset   bounds of returned SkImage; may be nullptr
        @return         created SkImage, or nullptr
    */
    static sk_sp<SkImage> MakeFromEncoded(sk_sp<SkData> encoded, const SkIRect* subset = nullptr);

    typedef void (*TextureReleaseProc)(ReleaseContext releaseContext);

    /** Deprecated.
    */
    static sk_sp<SkImage> MakeFromTexture(GrContext* context,
                                          const GrBackendTexture& backendTexture,
                                          GrSurfaceOrigin origin,
                                          SkAlphaType alphaType,
                                          sk_sp<SkColorSpace> colorSpace) {
        return MakeFromTexture(context, backendTexture, origin, alphaType, colorSpace, nullptr,
                               nullptr);
    }

    /** Deprecated.
    */
    static sk_sp<SkImage> MakeFromTexture(GrContext* context,
                                          const GrBackendTexture& backendTexture,
                                          GrSurfaceOrigin origin,
                                          SkAlphaType alphaType,
                                          sk_sp<SkColorSpace> colorSpace,
                                          TextureReleaseProc textureReleaseProc,
                                          ReleaseContext releaseContext);

    /** Creates SkImage from GPU texture associated with context. Caller is responsible for
        managing the lifetime of GPU texture.

        SkImage is returned if format of backendTexture is recognized and supported.
        Recognized formats vary by GPU back-end.

        @param context         GPU context
        @param backendTexture  texture residing on GPU
        @param origin          one of: kBottomLeft_GrSurfaceOrigin, kTopLeft_GrSurfaceOrigin
        @param colorType       one of: kUnknown_SkColorType, kAlpha_8_SkColorType,
                               kRGB_565_SkColorType, kARGB_4444_SkColorType,
                               kRGBA_8888_SkColorType, kBGRA_8888_SkColorType,
                               kGray_8_SkColorType, kRGBA_F16_SkColorType
        @param alphaType       one of: kUnknown_SkAlphaType, kOpaque_SkAlphaType,
                               kPremul_SkAlphaType, kUnpremul_SkAlphaType
        @param colorSpace      range of colors; may be nullptr
        @return                created SkImage, or nullptr
    */
    static sk_sp<SkImage> MakeFromTexture(GrContext* context,
                                          const GrBackendTexture& backendTexture,
                                          GrSurfaceOrigin origin,
                                          SkColorType colorType,
                                          SkAlphaType alphaType,
                                          sk_sp<SkColorSpace> colorSpace) {
        return MakeFromTexture(context, backendTexture, origin, colorType, alphaType, colorSpace,
                               nullptr, nullptr);
    }

    /** Creates SkImage from GPU texture associated with context. GPU texture must stay
        valid and unchanged until textureReleaseProc is called. textureReleaseProc is
        passed releaseContext when SkImage is deleted or no longer refers to texture.

        SkImage is returned if format of backendTexture is recognized and supported.
        Recognized formats vary by GPU back-end.

        @param context             GPU context
        @param backendTexture      texture residing on GPU
        @param origin              one of: kBottomLeft_GrSurfaceOrigin, kTopLeft_GrSurfaceOrigin
        @param colorType           one of: kUnknown_SkColorType, kAlpha_8_SkColorType,
                                   kRGB_565_SkColorType, kARGB_4444_SkColorType,
                                   kRGBA_8888_SkColorType, kBGRA_8888_SkColorType,
                                   kGray_8_SkColorType, kRGBA_F16_SkColorType
        @param alphaType           one of: kUnknown_SkAlphaType, kOpaque_SkAlphaType,
                                   kPremul_SkAlphaType, kUnpremul_SkAlphaType
        @param colorSpace          range of colors; may be nullptr
        @param textureReleaseProc  function called when texture can be released
        @param releaseContext      state passed to textureReleaseProc
        @return                    created SkImage, or nullptr
    */
    static sk_sp<SkImage> MakeFromTexture(GrContext* context,
                                          const GrBackendTexture& backendTexture,
                                          GrSurfaceOrigin origin,
                                          SkColorType colorType,
                                          SkAlphaType alphaType,
                                          sk_sp<SkColorSpace> colorSpace,
                                          TextureReleaseProc textureReleaseProc,
                                          ReleaseContext releaseContext);

    /** Creates SkImage from encoded data. SkImage is uploaded to GPU back-end using context.

        Created SkImage is available to other GPU contexts, and is available across thread
        boundaries. All contexts must be in the same GPU_Share_Group, or otherwise
        share resources.

        When SkImage is no longer referenced, context releases texture memory
        asynchronously.

        GrBackendTexture decoded from data is uploaded to match SkSurface created with
        dstColorSpace. SkColorSpace of SkImage is determined by encoded data.

        SkImage is returned if format of data is recognized and supported, and if context
        supports moving resources. Recognized formats vary by platform and GPU back-end.

        SkImage is returned using MakeFromEncoded() if context is nullptr or does not support
        moving resources between contexts.

        @param context        GPU context
        @param data           SkImage to decode
        @param buildMips      create SkImage as Mip_Map if true
        @param dstColorSpace  range of colors of matching SkSurface on GPU
        @return               created SkImage, or nullptr
    */
    static sk_sp<SkImage> MakeCrossContextFromEncoded(GrContext* context, sk_sp<SkData> data,
                                                      bool buildMips, SkColorSpace* dstColorSpace);

    /** Creates SkImage from pixmap. SkImage is uploaded to GPU back-end using context.

        Created SkImage is available to other GPU contexts, and is available across thread
        boundaries. All contexts must be in the same GPU_Share_Group, or otherwise
        share resources.

        When SkImage is no longer referenced, context releases texture memory
        asynchronously.

        GrBackendTexture created from pixmap is uploaded to match SkSurface created with
        dstColorSpace. SkColorSpace of SkImage is determined by pixmap.colorSpace().

        SkImage is returned referring to GPU back-end if context is not nullptr,
        format of data is recognized and supported, and if context supports moving
        resources between contexts. Otherwise, pixmap pixel data is copied and SkImage
        as returned in raster format if possible; nullptr may be returned.
        Recognized GPU formats vary by platform and GPU back-end.

        @param context        GPU context
        @param pixmap         SkImageInfo, pixel address, and row bytes
        @param buildMips      create SkImage as Mip_Map if true
        @param dstColorSpace  range of colors of matching SkSurface on GPU
        @return               created SkImage, or nullptr
    */
    static sk_sp<SkImage> MakeCrossContextFromPixmap(GrContext* context, const SkPixmap& pixmap,
                                                     bool buildMips, SkColorSpace* dstColorSpace);

    /** Deprecated.
    */
    static sk_sp<SkImage> MakeFromAdoptedTexture(GrContext* context,
                                                 const GrBackendTexture& backendTexture,
                                                 GrSurfaceOrigin surfaceOrigin,
                                                 SkAlphaType alphaType = kPremul_SkAlphaType,
                                                 sk_sp<SkColorSpace> colorSpace = nullptr);

    /** Creates SkImage from backendTexture associated with context. backendTexture and
        returned SkImage are managed internally, and are released when no longer needed.

        SkImage is returned if format of backendTexture is recognized and supported.
        Recognized formats vary by GPU back-end.

        @param context         GPU context
        @param backendTexture  texture residing on GPU
        @param surfaceOrigin   one of: kBottomLeft_GrSurfaceOrigin, kTopLeft_GrSurfaceOrigin
        @param colorType       one of: kUnknown_SkColorType, kAlpha_8_SkColorType,
                               kRGB_565_SkColorType, kARGB_4444_SkColorType,
                               kRGBA_8888_SkColorType, kBGRA_8888_SkColorType,
                               kGray_8_SkColorType, kRGBA_F16_SkColorType
        @param alphaType       one of: kUnknown_SkAlphaType, kOpaque_SkAlphaType,
                               kPremul_SkAlphaType, kUnpremul_SkAlphaType
        @param colorSpace      range of colors; may be nullptr
        @return                created SkImage, or nullptr
    */
    static sk_sp<SkImage> MakeFromAdoptedTexture(GrContext* context,
                                                 const GrBackendTexture& backendTexture,
                                                 GrSurfaceOrigin surfaceOrigin,
                                                 SkColorType colorType,
                                                 SkAlphaType alphaType = kPremul_SkAlphaType,
                                                 sk_sp<SkColorSpace> colorSpace = nullptr);

    /** Creates SkImage from copy of yuvTextureHandles, an array of textures on GPU.
        yuvTextureHandles contain pixels for YUV planes of SkImage.
        yuvSizes contain dimensions for each pixel plane. Dimensions must be greater than
        zero but may differ from plane to plane. Returned SkImage has the dimensions
        yuvSizes[0]. yuvColorSpace describes how YUV colors convert to RGB colors.

        @param context            GPU context
        @param yuvColorSpace      one of: kJPEG_SkYUVColorSpace, kRec601_SkYUVColorSpace,
                                  kRec709_SkYUVColorSpace
        @param yuvTextureHandles  array of YUV textures on GPU
        @param yuvSizes           dimensions of YUV textures
        @param surfaceOrigin      one of: kBottomLeft_GrSurfaceOrigin, kTopLeft_GrSurfaceOrigin
        @param colorSpace         range of colors; may be nullptr
        @return                   created SkImage, or nullptr
    */
    static sk_sp<SkImage> MakeFromYUVTexturesCopy(GrContext* context, SkYUVColorSpace yuvColorSpace,
                                                  const GrBackendObject yuvTextureHandles[3],
                                                  const SkISize yuvSizes[3],
                                                  GrSurfaceOrigin surfaceOrigin,
                                                  sk_sp<SkColorSpace> colorSpace = nullptr);

    /** Creates SkImage from copy of nv12TextureHandles, an array of textures on GPU.
        nv12TextureHandles[0] contains pixels for YUV_Component_Y plane.
        nv12TextureHandles[1] contains pixels for YUV_Component_U plane,
        followed by pixels for YUV_Component_V plane.
        nv12Sizes contain dimensions for each pixel plane. Dimensions must be greater than
        zero but may differ from plane to plane. Returned SkImage has the dimensions
        nv12Sizes[0]. yuvColorSpace describes how YUV colors convert to RGB colors.

        @param context             GPU context
        @param yuvColorSpace       one of: kJPEG_SkYUVColorSpace, kRec601_SkYUVColorSpace,
                                   kRec709_SkYUVColorSpace
        @param nv12TextureHandles  array of YUV textures on GPU
        @param nv12Sizes           dimensions of YUV textures
        @param surfaceOrigin       one of: kBottomLeft_GrSurfaceOrigin, kTopLeft_GrSurfaceOrigin
        @param colorSpace          range of colors; may be nullptr
        @return                    created SkImage, or nullptr
    */
    static sk_sp<SkImage> MakeFromNV12TexturesCopy(GrContext* context,
                                                   SkYUVColorSpace yuvColorSpace,
                                                   const GrBackendObject nv12TextureHandles[2],
                                                   const SkISize nv12Sizes[2],
                                                   GrSurfaceOrigin surfaceOrigin,
                                                   sk_sp<SkColorSpace> colorSpace = nullptr);

    /** Creates SkImage from copy of yuvTextureHandles, an array of textures on GPU.
        yuvTextureHandles contain pixels for YUV planes of SkImage.
        yuvSizes contain dimensions for each pixel plane. Dimensions must be greater than
        zero but may differ from plane to plane. Returned SkImage has the dimensions
        yuvSizes[0]. yuvColorSpace describes how YUV colors convert to RGB colors.

        @param context            GPU context
        @param yuvColorSpace      one of: kJPEG_SkYUVColorSpace, kRec601_SkYUVColorSpace,
                                  kRec709_SkYUVColorSpace
        @param yuvTextureHandles  array of YUV textures on GPU
        @param yuvSizes           dimensions of YUV textures
        @param surfaceOrigin      one of: kBottomLeft_GrSurfaceOrigin, kTopLeft_GrSurfaceOrigin
        @param colorSpace         range of colors; may be nullptr
        @return                   created SkImage, or nullptr
    */
    static sk_sp<SkImage> MakeFromYUVTexturesCopy(GrContext* context, SkYUVColorSpace yuvColorSpace,
                                                  const GrBackendTexture yuvTextureHandles[3],
                                                  const SkISize yuvSizes[3],
                                                  GrSurfaceOrigin surfaceOrigin,
                                                  sk_sp<SkColorSpace> colorSpace = nullptr);

    /** Creates SkImage from copy of nv12TextureHandles, an array of textures on GPU.
        nv12TextureHandles[0] contains pixels for YUV_Component_Y plane.
        nv12TextureHandles[1] contains pixels for YUV_Component_U plane,
        followed by pixels for YUV_Component_V plane.
        nv12Sizes contain dimensions for each pixel plane. Dimensions must be greater than
        zero but may differ from plane to plane. Returned SkImage has the dimensions
        nv12Sizes[0]. yuvColorSpace describes how YUV colors convert to RGB colors.

        @param context             GPU context
        @param yuvColorSpace       one of: kJPEG_SkYUVColorSpace, kRec601_SkYUVColorSpace,
                                   kRec709_SkYUVColorSpace
        @param nv12TextureHandles  array of YUV textures on GPU
        @param nv12Sizes           dimensions of YUV textures
        @param surfaceOrigin       one of: kBottomLeft_GrSurfaceOrigin, kTopLeft_GrSurfaceOrigin
        @param colorSpace          range of colors; may be nullptr
        @return                    created SkImage, or nullptr
    */
    static sk_sp<SkImage> MakeFromNV12TexturesCopy(GrContext* context,
                                                   SkYUVColorSpace yuvColorSpace,
                                                   const GrBackendTexture nv12TextureHandles[2],
                                                   const SkISize nv12Sizes[2],
                                                   GrSurfaceOrigin surfaceOrigin,
                                                   sk_sp<SkColorSpace> colorSpace = nullptr);

    enum class BitDepth {
        kU8,  //!< Use 8 bits per ARGB component using unsigned integer format.
        kF16, //!< Use 16 bits per ARGB component using half-precision floating point format.
    };

    /** Creates SkImage from picture. Returned SkImage width and height are set by dimensions.
        SkImage draws picture with matrix and paint, set to bitDepth and colorSpace.

        If matrix is nullptr, draws with identity SkMatrix. If paint is nullptr, draws
        with default SkPaint. colorSpace may be nullptr.

        @param picture     stream of drawing commands
        @param dimensions  width and height
        @param matrix      SkMatrix to rotate, scale, translate, and so on; may be nullptr
        @param paint       SkPaint to apply transparency, filtering, and so on; may be nullptr
        @param bitDepth    8 bit integer or 16 bit float: per component
        @param colorSpace  range of colors; may be nullptr
        @return            created SkImage, or nullptr
    */
    static sk_sp<SkImage> MakeFromPicture(sk_sp<SkPicture> picture, const SkISize& dimensions,
                                          const SkMatrix* matrix, const SkPaint* paint,
                                          BitDepth bitDepth,
                                          sk_sp<SkColorSpace> colorSpace);

#if defined(SK_BUILD_FOR_ANDROID) && __ANDROID_API__ >= 26
    /** (see skbug.com/7447)
        Creates SkImage from Android hardware buffer.
        Returned SkImage takes a reference on the buffer.

        Only available on Android, when __ANDROID_API__ is defined to be 26 or greater.

        @param hardwareBuffer  AHardwareBuffer Android hardware buffer
        @param alphaType       one of: kUnknown_SkAlphaType, kOpaque_SkAlphaType,
                               kPremul_SkAlphaType, kUnpremul_SkAlphaType
        @param colorSpace      range of colors; may be nullptr
        @return                created SkImage, or nullptr
    */
    static sk_sp<SkImage> MakeFromAHardwareBuffer(AHardwareBuffer* hardwareBuffer,
                                                 SkAlphaType alphaType = kPremul_SkAlphaType,
                                                 sk_sp<SkColorSpace> colorSpace = nullptr);
#endif

    /** Returns pixel count in each row.

        @return  pixel width in SkImage
    */
    int width() const { return fWidth; }

    /** Returns pixel row count.

        @return  pixel height in SkImage
    */
    int height() const { return fHeight; }

    /** Returns SkISize { width(), height() }.

        @return  integral size of width() and height()
    */
    SkISize dimensions() const { return SkISize::Make(fWidth, fHeight); }

    /** Returns SkIRect { 0, 0, width(), height() }.

        @return  integral rectangle from origin to width() and height()
    */
    SkIRect bounds() const { return SkIRect::MakeWH(fWidth, fHeight); }

    /** Returns value unique to image. SkImage contents cannot change after SkImage is
        created. Any operation to create a new SkImage will receive generate a new
        unique number.

        @return  unique identifier
    */
    uint32_t uniqueID() const { return fUniqueID; }

    /** Returns SkAlphaType, one of: kUnknown_SkAlphaType, kOpaque_SkAlphaType,
        kPremul_SkAlphaType, kUnpremul_SkAlphaType.

        SkAlphaType returned was a parameter to an SkImage constructor,
        or was parsed from encoded data.

        @return  SkAlphaType in SkImage
    */
    SkAlphaType alphaType() const;

    /** Returns SkColorSpace, the range of colors, associated with SkImage.  The
        reference count of SkColorSpace is unchanged. The returned SkColorSpace is
        immutable.

        SkColorSpace returned was passed to an SkImage constructor,
        or was parsed from encoded data. SkColorSpace returned may be ignored when SkImage
        is drawn, depending on the capabilities of the SkSurface receiving the drawing.

        @return  SkColorSpace in SkImage, or nullptr
    */
    SkColorSpace* colorSpace() const;

    /** Returns a smart pointer to SkColorSpace, the range of colors, associated with
        SkImage.  The smart pointer tracks the number of objects sharing this
        SkColorSpace reference so the memory is released when the owners destruct.

        The returned SkColorSpace is immutable.

        SkColorSpace returned was passed to an SkImage constructor,
        or was parsed from encoded data. SkColorSpace returned may be ignored when SkImage
        is drawn, depending on the capabilities of the SkSurface receiving the drawing.

        @return  SkColorSpace in SkImage, or nullptr, wrapped in a smart pointer
    */
    sk_sp<SkColorSpace> refColorSpace() const;

    /** Returns true if SkImage pixels represent transparency only. If true, each pixel
        is packed in 8 bits as defined by kAlpha_8_SkColorType.

        @return  true if pixels represent a transparency mask
    */
    bool isAlphaOnly() const;

    /** Returns true if pixels ignore their alpha value and are treated as fully opaque.

        @return  true if SkAlphaType is kOpaque_SkAlphaType
    */
    bool isOpaque() const { return SkAlphaTypeIsOpaque(this->alphaType()); }

    /** Creates SkShader from SkImage. SkShader dimensions are taken from SkImage. SkShader uses
        SkShader::TileMode rules to fill drawn area outside SkImage. localMatrix permits
        transforming SkImage before SkCanvas matrix is applied.

        @param tileMode1    tiling in x, one of: SkShader::kClamp_TileMode, SkShader::kRepeat_TileMode,
                            SkShader::kMirror_TileMode
        @param tileMode2    tiling in y, one of: SkShader::kClamp_TileMode, SkShader::kRepeat_TileMode,
                            SkShader::kMirror_TileMode
        @param localMatrix  SkImage transformation, or nullptr
        @return             SkShader containing SkImage
    */
    sk_sp<SkShader> makeShader(SkShader::TileMode tileMode1, SkShader::TileMode tileMode2,
                               const SkMatrix* localMatrix = nullptr) const;

    /** Creates SkShader from SkImage. SkShader dimensions are taken from SkImage. SkShader uses
        SkShader::kClamp_TileMode to fill drawn area outside SkImage. localMatrix permits
        transforming SkImage before SkCanvas matrix is applied.

        @param localMatrix  SkImage transformation, or nullptr
        @return             SkShader containing SkImage
    */
    sk_sp<SkShader> makeShader(const SkMatrix* localMatrix = nullptr) const {
        return this->makeShader(SkShader::kClamp_TileMode, SkShader::kClamp_TileMode, localMatrix);
    }

    /** Copies SkImage pixel address, row bytes, and SkImageInfo to pixmap, if address
        is available, and returns true. If pixel address is not available, return
        false and leave pixmap unchanged.

        @param pixmap  storage for pixel state if pixels are readable; otherwise, ignored
        @return        true if SkImage has direct access to pixels
    */
    bool peekPixels(SkPixmap* pixmap) const;

    /** Deprecated.
    */
    GrTexture* getTexture() const;

    /** Returns true the contents of SkImage was created on or uploaded to GPU memory,
        and is available as a GPU texture.

        @return  true if SkImage is a GPU texture
    */
    bool isTextureBacked() const;

    /** Returns true if SkImage can be drawn on either raster surface or GPU surface.
        If context is nullptr, tests if SkImage draws on raster surface;
        otherwise, tests if SkImage draws on GPU surface associated with context.

        SkImage backed by GPU texture may become invalid if associated GrContext is
        invalid. lazy image may be invalid and may not draw to raster surface or
        GPU surface or both.

        @param context  GPU context
        @return         true if SkImage can be drawn
    */
    bool isValid(GrContext* context) const;

    /** Retrieves the back-end API handle of texture. If flushPendingGrContextIO is true,
        complete deferred I/O operations.

        If origin in not nullptr, copies location of content drawn into SkImage.

        @param flushPendingGrContextIO  flag to flush outstanding requests
        @param origin                   storage for one of: kTopLeft_GrSurfaceOrigin,
                                        kBottomLeft_GrSurfaceOrigin; or nullptr
        @return                         back-end API texture handle, or nullptr
    */
    GrBackendObject getTextureHandle(bool flushPendingGrContextIO,
                                     GrSurfaceOrigin* origin = nullptr) const;

    /** \enum SkImage::CachingHint
        CachingHint selects whether Skia may internally cache SkBitmap generated by
        decoding SkImage, or by copying SkImage from GPU to CPU. The default behavior
        allows caching SkBitmap.

        Choose kDisallow_CachingHint if SkImage pixels are to be used only once, or
        if SkImage pixels reside in a cache outside of Skia, or to reduce memory pressure.

        Choosing kAllow_CachingHint does not ensure that pixels will be cached.
        SkImage pixels may not be cached if memory requirements are too large or
        pixels are not accessible.
    */
    enum CachingHint {
        kAllow_CachingHint,    //!< Allows Skia to internally cache decoded and copied pixels.

        /** Disallows Skia from internally caching decoded and copied pixels. */
        kDisallow_CachingHint,
    };

    /** Copies SkRect of pixels from SkImage to dstPixels. Copy starts at offset (srcX, srcY),
        and does not exceed SkImage (width(), height()).

        dstInfo specifies width, height, SkColorType, SkAlphaType, and SkColorSpace of
        destination. dstRowBytes specifics the gap from one destination row to the next.
        Returns true if pixels are copied. Returns false if:
        - dstInfo.addr() equals nullptr
        - dstRowBytes is less than dstInfo.minRowBytes()
        - SkPixelRef is nullptr

        Pixels are copied only if pixel conversion is possible. If SkImage SkColorType is
        kGray_8_SkColorType, or kAlpha_8_SkColorType; dstInfo.colorType() must match.
        If SkImage SkColorType is kGray_8_SkColorType, dstInfo.colorSpace() must match.
        If SkImage SkAlphaType is kOpaque_SkAlphaType, dstInfo.alphaType() must
        match. If SkImage SkColorSpace is nullptr, dstInfo.colorSpace() must match. Returns
        false if pixel conversion is not possible.

        srcX and srcY may be negative to copy only top or left of source. Returns
        false if width() or height() is zero or negative.
        Returns false if abs(srcX) >= Image width(), or if abs(srcY) >= Image height().

        If cachingHint is kAllow_CachingHint, pixels may be retained locally.
        If cachingHint is kDisallow_CachingHint, pixels are not added to the local cache.

        @param dstInfo      destination width, height, SkColorType, SkAlphaType, SkColorSpace
        @param dstPixels    destination pixel storage
        @param dstRowBytes  destination row length
        @param srcX         column index whose absolute value is less than width()
        @param srcY         row index whose absolute value is less than height()
        @param cachingHint  one of: kAllow_CachingHint, kDisallow_CachingHint
        @return             true if pixels are copied to dstPixels
    */
    bool readPixels(const SkImageInfo& dstInfo, void* dstPixels, size_t dstRowBytes,
                    int srcX, int srcY, CachingHint cachingHint = kAllow_CachingHint) const;

    /** Copies a SkRect of pixels from SkImage to dst. Copy starts at (srcX, srcY), and
        does not exceed SkImage (width(), height()).

        dst specifies width, height, SkColorType, SkAlphaType, SkColorSpace, pixel storage,
        and row bytes of destination. dst.rowBytes() specifics the gap from one destination
        row to the next. Returns true if pixels are copied. Returns false if:
        - dst pixel storage equals nullptr
        - dst.rowBytes is less than SkImageInfo::minRowBytes
        - SkPixelRef is nullptr

        Pixels are copied only if pixel conversion is possible. If SkImage SkColorType is
        kGray_8_SkColorType, or kAlpha_8_SkColorType; dst.colorType() must match.
        If SkImage SkColorType is kGray_8_SkColorType, dst.colorSpace() must match.
        If SkImage SkAlphaType is kOpaque_SkAlphaType, dst.alphaType() must
        match. If SkImage SkColorSpace is nullptr, dst.colorSpace() must match. Returns
        false if pixel conversion is not possible.

        srcX and srcY may be negative to copy only top or left of source. Returns
        false if width() or height() is zero or negative.
        Returns false if abs(srcX) >= Image width(), or if abs(srcY) >= Image height().

        If cachingHint is kAllow_CachingHint, pixels may be retained locally.
        If cachingHint is kDisallow_CachingHint, pixels are not added to the local cache.

        @param dst          destination SkPixmap: SkImageInfo, pixels, row bytes
        @param srcX         column index whose absolute value is less than width()
        @param srcY         row index whose absolute value is less than height()
        @param cachingHint  one of: kAllow_CachingHint, kDisallow_CachingHint
        @return             true if pixels are copied to dst
    */
    bool readPixels(const SkPixmap& dst, int srcX, int srcY,
                    CachingHint cachingHint = kAllow_CachingHint) const;

    /** Copies SkImage to dst, scaling pixels to fit dst.width() and dst.height(), and
        converting pixels to match dst.colorType() and dst.alphaType(). Returns true if
        pixels are copied. Returns false if dst.addr() is nullptr, or dst.rowBytes() is
        less than dst SkImageInfo::minRowBytes.

        Pixels are copied only if pixel conversion is possible. If SkImage SkColorType is
        kGray_8_SkColorType, or kAlpha_8_SkColorType; dst.colorType() must match.
        If SkImage SkColorType is kGray_8_SkColorType, dst.colorSpace() must match.
        If SkImage SkAlphaType is kOpaque_SkAlphaType, dst.alphaType() must
        match. If SkImage SkColorSpace is nullptr, dst.colorSpace() must match. Returns
        false if pixel conversion is not possible.

        Scales the image, with filterQuality, to match dst.width() and dst.height().
        filterQuality kNone_SkFilterQuality is fastest, typically implemented with
        nearest neighbor filter. kLow_SkFilterQuality is typically implemented with
        bilerp filter. kMedium_SkFilterQuality is typically implemented with
        bilerp filter, and Filter_Quality_MipMap when size is reduced.
        kHigh_SkFilterQuality is slowest, typically implemented with Filter_Quality_BiCubic.

        If cachingHint is kAllow_CachingHint, pixels may be retained locally.
        If cachingHint is kDisallow_CachingHint, pixels are not added to the local cache.

        @param dst            destination SkPixmap: SkImageInfo, pixels, row bytes
        @param filterQuality  one of: kNone_SkFilterQuality, kLow_SkFilterQuality,
                              kMedium_SkFilterQuality, kHigh_SkFilterQuality
        @param cachingHint    one of: kAllow_CachingHint, kDisallow_CachingHint
        @return               true if pixels are scaled to fit dst
    */
    bool scalePixels(const SkPixmap& dst, SkFilterQuality filterQuality,
                     CachingHint cachingHint = kAllow_CachingHint) const;

    /** Encodes SkImage pixels, returning result as SkData.

        Returns nullptr if encoding fails, or if encodedImageFormat is not supported.

        SkImage encoding in a format requires both building with one or more of:
        SK_HAS_JPEG_LIBRARY, SK_HAS_PNG_LIBRARY, SK_HAS_WEBP_LIBRARY; and platform support
        for the encoded format.

        If SK_BUILD_FOR_MAC or SK_BUILD_FOR_IOS is defined, encodedImageFormat can
        additionally be one of: SkEncodedImageFormat::kICO, SkEncodedImageFormat::kBMP,
        SkEncodedImageFormat::kGIF.

        quality is a platform and format specific metric trading off size and encoding
        error. When used, quality equaling 100 encodes with the least error. quality may
        be ignored by the encoder.

        @param encodedImageFormat  one of: SkEncodedImageFormat::kJPEG, SkEncodedImageFormat::kPNG,
                                   SkEncodedImageFormat::kWEBP
        @param quality             encoder specific metric with 100 equaling best
        @return                    encoded SkImage, or nullptr
    */
    sk_sp<SkData> encodeToData(SkEncodedImageFormat encodedImageFormat, int quality) const;

    /** Encodes SkImage pixels, returning result as SkData. Returns existing encoded data
        if present; otherwise, SkImage is encoded with SkEncodedImageFormat::kPNG. Skia
        must be built with SK_HAS_PNG_LIBRARY to encode SkImage.

        Returns nullptr if existing encoded data is missing or invalid, and
        encoding fails.

        @return  encoded SkImage, or nullptr
    */
    sk_sp<SkData> encodeToData() const;

    /** Returns encoded SkImage pixels as SkData, if SkImage was created from supported
        encoded stream format. Platform support for formats vary and may require building
        with one or more of: SK_HAS_JPEG_LIBRARY, SK_HAS_PNG_LIBRARY, SK_HAS_WEBP_LIBRARY.

        Returns nullptr if SkImage contents are not encoded.

        @return  encoded SkImage, or nullptr
    */
    sk_sp<SkData> refEncodedData() const;

    /** Appends SkImage description to string, including unique ID, width, height, and
        whether the image is opaque.

        @param string  storage for description; existing content is preserved
        @return        string appended with SkImage description
    */
    const char* toString(SkString* string) const;

    /** Returns subset of SkImage. subset must be fully contained by SkImage dimensions().
        The implementation may share pixels, or may copy them.

        Returns nullptr if subset is empty, or subset is not contained by bounds, or
        pixels in SkImage could not be read or copied.

        @param subset  bounds of returned SkImage
        @return        partial or full SkImage, or nullptr
    */
    sk_sp<SkImage> makeSubset(const SkIRect& subset) const;

    /** Returns SkImage backed by GPU texture associated with context. Returned SkImage is
        compatible with SkSurface created with dstColorSpace. Returns original
        SkImage if context and dstColorSpace match.

        Returns nullptr if context is nullptr, or if SkImage was created with another
        GrContext.

        @param context        GPU context
        @param dstColorSpace  range of colors of matching SkSurface on GPU
        @return               created SkImage, or nullptr
    */
    sk_sp<SkImage> makeTextureImage(GrContext* context, SkColorSpace* dstColorSpace) const;

    /** Returns raster image or lazy image. Copies SkImage backed by GPU texture into
        CPU memory if needed. Returns original SkImage if decoded in raster bitmap,
        or if encoded in a stream.

        Returns nullptr if backed by GPU texture and copy fails.

        @return  raster image, lazy image, or nullptr
    */
    sk_sp<SkImage> makeNonTextureImage() const;

    /** Returns raster image. Copies SkImage backed by GPU texture into CPU memory,
        or decodes SkImage from lazy image. Returns original SkImage if decoded in
        raster bitmap.

        Returns nullptr if copy, decode, or pixel read fails.

        @return  raster image, or nullptr
    */
    sk_sp<SkImage> makeRasterImage() const;

    /** Creates filtered SkImage. filter processes original SkImage, potentially changing
        color, position, and size. subset is the bounds of original SkImage processed
        by filter. clipBounds is the expected bounds of the filtered SkImage. outSubset
        is required storage for the actual bounds of the filtered SkImage. offset is
        required storage for translation of returned SkImage.

        Returns nullptr if SkImage could not be created. If nullptr is returned, outSubset
        and offset are undefined.

        Useful for animation of SkImageFilter that varies size from frame to frame.
        Returned SkImage is created larger than required by filter so that GPU texture
        can be reused with different sized effects. outSubset describes the valid bounds
        of GPU texture returned. offset translates the returned SkImage to keep subsequent
        animation frames aligned with respect to each other.

        @param filter      how SkImage is sampled when transformed
        @param subset      bounds of SkImage processed by filter
        @param clipBounds  expected bounds of filtered SkImage
        @param outSubset   storage for returned SkImage bounds
        @param offset      storage for returned SkImage translation
        @return            filtered SkImage, or nullptr
    */
    sk_sp<SkImage> makeWithFilter(const SkImageFilter* filter, const SkIRect& subset,
                                  const SkIRect& clipBounds, SkIRect* outSubset,
                                  SkIPoint* offset) const;

    typedef std::function<void(GrBackendTexture)> BackendTextureReleaseProc;

    /** Creates a GrBackendTexture from the provided SkImage. Returns true and
        stores result in backendTexture and backendTextureReleaseProc if
        texture is created; otherwise, returns false and leaves
        backendTexture and backendTextureReleaseProc unmodified.

        Call backendTextureReleaseProc after deleting backendTexture.
        backendTextureReleaseProc cleans up auxiliary data related to returned
        backendTexture. The caller must delete returned backendTexture after use.

        If SkImage is both texture backed and singly referenced, image is returned in
        backendTexture without conversion or making a copy. SkImage is singly referenced
        if its was transferred solely using std::move().

        If SkImage is not texture backed, returns texture with SkImage contents.

        @param context                    GPU context
        @param image                      SkImage used for texture
        @param backendTexture             storage for backend texture
        @param backendTextureReleaseProc  storage for clean up function
        @return                           true if backend texture was created
    */
    static bool MakeBackendTextureFromSkImage(GrContext* context,
                                              sk_sp<SkImage> image,
                                              GrBackendTexture* backendTexture,
                                              BackendTextureReleaseProc* backendTextureReleaseProc);

    enum LegacyBitmapMode {
        kRO_LegacyBitmapMode, //!< Returned bitmap is read-only and immutable.
    };

    /** Creates raster SkBitmap with same pixels as SkImage. If legacyBitmapMode is
        kRO_LegacyBitmapMode, returned bitmap is read-only and immutable.
        Returns true if SkBitmap is stored in bitmap. Returns false and resets bitmap if
        SkBitmap write did not succeed.

        @param bitmap            storage for legacy SkBitmap
        @param legacyBitmapMode  to be deprecated
        @return                  true if SkBitmap was created
    */
    bool asLegacyBitmap(SkBitmap* bitmap, LegacyBitmapMode legacyBitmapMode = kRO_LegacyBitmapMode) const;

    /** Returns true if SkImage is backed by an image-generator or other service that creates
        and caches its pixels or texture on-demand.

        @return  true if SkImage is created as needed
    */
    bool isLazyGenerated() const;

    /** Creates SkImage in target SkColorSpace.
        Returns nullptr if SkImage could not be created.

        Returns original SkImage if it is in target SkColorSpace.
        Otherwise, converts pixels from SkImage SkColorSpace to target SkColorSpace.
        If SkImage colorSpace() returns nullptr, SkImage SkColorSpace is assumed to be sRGB.

        SkTransferFunctionBehavior is to be deprecated.

        Set premulBehavior to SkTransferFunctionBehavior::kRespect to convert SkImage
        pixels to a linear space, before converting to destination SkColorType
        and SkColorSpace.

        Set premulBehavior to SkTransferFunctionBehavior::kIgnore to treat SkImage
        pixels as linear, when converting to destination SkColorType
        and SkColorSpace, ignoring pixel encoding.

        @param target          SkColorSpace describing color range of returned SkImage
        @param premulBehavior  one of: SkTransferFunctionBehavior::kRespect,
                               SkTransferFunctionBehavior::kIgnore
        @return                created SkImage in target SkColorSpace
    */
    sk_sp<SkImage> makeColorSpace(sk_sp<SkColorSpace> target,
                                  SkTransferFunctionBehavior premulBehavior) const;

private:
    SkImage(int width, int height, uint32_t uniqueID);
    friend class SkImage_Base;

    const int       fWidth;
    const int       fHeight;
    const uint32_t  fUniqueID;

    typedef SkRefCnt INHERITED;
};

#endif
