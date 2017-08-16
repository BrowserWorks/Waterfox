//
// Copyright (c) 2002-2013 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//

// Texture.h: Defines the gl::Texture class [OpenGL ES 2.0.24] section 3.7 page 63.

#ifndef LIBANGLE_TEXTURE_H_
#define LIBANGLE_TEXTURE_H_

#include <vector>
#include <map>

#include "angle_gl.h"
#include "common/debug.h"
#include "libANGLE/Caps.h"
#include "libANGLE/Debug.h"
#include "libANGLE/Constants.h"
#include "libANGLE/Error.h"
#include "libANGLE/FramebufferAttachment.h"
#include "libANGLE/Image.h"
#include "libANGLE/Stream.h"
#include "libANGLE/angletypes.h"
#include "libANGLE/formatutils.h"

namespace egl
{
class Surface;
class Stream;
}

namespace rx
{
class GLImplFactory;
class TextureImpl;
class TextureGL;
}

namespace gl
{
class ContextState;
class Framebuffer;
class Texture;

bool IsMipmapFiltered(const SamplerState &samplerState);

struct ImageDesc final
{
    ImageDesc();
    ImageDesc(const Extents &size, const Format &format);

    ImageDesc(const ImageDesc &other) = default;
    ImageDesc &operator=(const ImageDesc &other) = default;

    Extents size;
    Format format;
};

struct SwizzleState final
{
    SwizzleState();
    SwizzleState(GLenum red, GLenum green, GLenum blue, GLenum alpha);
    SwizzleState(const SwizzleState &other) = default;
    SwizzleState &operator=(const SwizzleState &other) = default;

    bool swizzleRequired() const;

    bool operator==(const SwizzleState &other) const;
    bool operator!=(const SwizzleState &other) const;

    GLenum swizzleRed;
    GLenum swizzleGreen;
    GLenum swizzleBlue;
    GLenum swizzleAlpha;
};

// State from Table 6.9 (state per texture object) in the OpenGL ES 3.0.2 spec.
struct TextureState final : public angle::NonCopyable
{
    TextureState(GLenum target);

    bool swizzleRequired() const;
    GLuint getEffectiveBaseLevel() const;
    GLuint getEffectiveMaxLevel() const;

    // Returns the value called "q" in the GLES 3.0.4 spec section 3.8.10.
    GLuint getMipmapMaxLevel() const;

    // Returns true if base level changed.
    bool setBaseLevel(GLuint baseLevel);
    void setMaxLevel(GLuint maxLevel);

    bool isCubeComplete() const;
    bool isSamplerComplete(const SamplerState &samplerState, const ContextState &data) const;

    const ImageDesc &getImageDesc(GLenum target, size_t level) const;

    GLenum getTarget() const { return mTarget; }
    const SwizzleState &getSwizzleState() const { return mSwizzleState; }
    const SamplerState &getSamplerState() const { return mSamplerState; }
    GLenum getUsage() const { return mUsage; }

  private:
    // Texture needs access to the ImageDesc functions.
    friend class Texture;
    // TODO(jmadill): Remove TextureGL from friends.
    friend class rx::TextureGL;
    friend bool operator==(const TextureState &a, const TextureState &b);

    bool computeSamplerCompleteness(const SamplerState &samplerState,
                                    const ContextState &data) const;
    bool computeMipmapCompleteness() const;
    bool computeLevelCompleteness(GLenum target, size_t level) const;

    GLenum getBaseImageTarget() const;

    void setImageDesc(GLenum target, size_t level, const ImageDesc &desc);
    void setImageDescChain(GLuint baselevel,
                           GLuint maxLevel,
                           Extents baseSize,
                           const Format &format);
    void clearImageDesc(GLenum target, size_t level);
    void clearImageDescs();

    const GLenum mTarget;

    SwizzleState mSwizzleState;

    SamplerState mSamplerState;

    GLuint mBaseLevel;
    GLuint mMaxLevel;

    GLenum mDepthStencilTextureMode;

    bool mImmutableFormat;
    GLuint mImmutableLevels;

    // From GL_ANGLE_texture_usage
    GLenum mUsage;

    std::vector<ImageDesc> mImageDescs;

    struct SamplerCompletenessCache
    {
        SamplerCompletenessCache();

        bool cacheValid;

        // All values that affect sampler completeness that are not stored within
        // the texture itself
        SamplerState samplerState;
        bool filterable;
        GLint clientVersion;
        bool supportsNPOT;

        // Result of the sampler completeness with the above parameters
        bool samplerComplete;
    };
    mutable SamplerCompletenessCache mCompletenessCache;
};

bool operator==(const TextureState &a, const TextureState &b);
bool operator!=(const TextureState &a, const TextureState &b);

class Texture final : public egl::ImageSibling,
                      public FramebufferAttachmentObject,
                      public LabeledObject
{
  public:
    Texture(rx::GLImplFactory *factory, GLuint id, GLenum target);
    ~Texture() override;

    void setLabel(const std::string &label) override;
    const std::string &getLabel() const override;

    GLenum getTarget() const;

    void setSwizzleRed(GLenum swizzleRed);
    GLenum getSwizzleRed() const;

    void setSwizzleGreen(GLenum swizzleGreen);
    GLenum getSwizzleGreen() const;

    void setSwizzleBlue(GLenum swizzleBlue);
    GLenum getSwizzleBlue() const;

    void setSwizzleAlpha(GLenum swizzleAlpha);
    GLenum getSwizzleAlpha() const;

    void setMinFilter(GLenum minFilter);
    GLenum getMinFilter() const;

    void setMagFilter(GLenum magFilter);
    GLenum getMagFilter() const;

    void setWrapS(GLenum wrapS);
    GLenum getWrapS() const;

    void setWrapT(GLenum wrapT);
    GLenum getWrapT() const;

    void setWrapR(GLenum wrapR);
    GLenum getWrapR() const;

    void setMaxAnisotropy(float maxAnisotropy);
    float getMaxAnisotropy() const;

    void setMinLod(GLfloat minLod);
    GLfloat getMinLod() const;

    void setMaxLod(GLfloat maxLod);
    GLfloat getMaxLod() const;

    void setCompareMode(GLenum compareMode);
    GLenum getCompareMode() const;

    void setCompareFunc(GLenum compareFunc);
    GLenum getCompareFunc() const;

    void setSRGBDecode(GLenum sRGBDecode);
    GLenum getSRGBDecode() const;

    const SamplerState &getSamplerState() const;

    void setBaseLevel(GLuint baseLevel);
    GLuint getBaseLevel() const;

    void setMaxLevel(GLuint maxLevel);
    GLuint getMaxLevel() const;

    void setDepthStencilTextureMode(GLenum mode);
    GLenum getDepthStencilTextureMode() const;

    bool getImmutableFormat() const;

    GLuint getImmutableLevels() const;

    void setUsage(GLenum usage);
    GLenum getUsage() const;

    const TextureState &getTextureState() const;

    size_t getWidth(GLenum target, size_t level) const;
    size_t getHeight(GLenum target, size_t level) const;
    size_t getDepth(GLenum target, size_t level) const;
    const Format &getFormat(GLenum target, size_t level) const;

    bool isMipmapComplete() const;

    Error setImage(const PixelUnpackState &unpackState,
                   GLenum target,
                   size_t level,
                   GLenum internalFormat,
                   const Extents &size,
                   GLenum format,
                   GLenum type,
                   const uint8_t *pixels);
    Error setSubImage(const PixelUnpackState &unpackState,
                      GLenum target,
                      size_t level,
                      const Box &area,
                      GLenum format,
                      GLenum type,
                      const uint8_t *pixels);

    Error setCompressedImage(const PixelUnpackState &unpackState,
                             GLenum target,
                             size_t level,
                             GLenum internalFormat,
                             const Extents &size,
                             size_t imageSize,
                             const uint8_t *pixels);
    Error setCompressedSubImage(const PixelUnpackState &unpackState,
                                GLenum target,
                                size_t level,
                                const Box &area,
                                GLenum format,
                                size_t imageSize,
                                const uint8_t *pixels);

    Error copyImage(GLenum target,
                    size_t level,
                    const Rectangle &sourceArea,
                    GLenum internalFormat,
                    const Framebuffer *source);
    Error copySubImage(GLenum target,
                       size_t level,
                       const Offset &destOffset,
                       const Rectangle &sourceArea,
                       const Framebuffer *source);

    Error copyTexture(GLenum internalFormat,
                      GLenum type,
                      bool unpackFlipY,
                      bool unpackPremultiplyAlpha,
                      bool unpackUnmultiplyAlpha,
                      const Texture *source);
    Error copySubTexture(const Offset &destOffset,
                         const Rectangle &sourceArea,
                         bool unpackFlipY,
                         bool unpackPremultiplyAlpha,
                         bool unpackUnmultiplyAlpha,
                         const Texture *source);
    Error copyCompressedTexture(const Texture *source);

    Error setStorage(GLenum target, GLsizei levels, GLenum internalFormat, const Extents &size);

    Error setEGLImageTarget(GLenum target, egl::Image *imageTarget);

    Error generateMipmap();

    egl::Surface *getBoundSurface() const;
    egl::Stream *getBoundStream() const;

    rx::TextureImpl *getImplementation() const { return mTexture; }

    // FramebufferAttachmentObject implementation
    Extents getAttachmentSize(const FramebufferAttachment::Target &target) const override;
    const Format &getAttachmentFormat(const FramebufferAttachment::Target &target) const override;
    GLsizei getAttachmentSamples(const FramebufferAttachment::Target &target) const override;

    void onAttach() override;
    void onDetach() override;
    GLuint getId() const override;

    enum DirtyBitType
    {
        // Sampler state
        DIRTY_BIT_MIN_FILTER,
        DIRTY_BIT_MAG_FILTER,
        DIRTY_BIT_WRAP_S,
        DIRTY_BIT_WRAP_T,
        DIRTY_BIT_WRAP_R,
        DIRTY_BIT_MAX_ANISOTROPY,
        DIRTY_BIT_MIN_LOD,
        DIRTY_BIT_MAX_LOD,
        DIRTY_BIT_COMPARE_MODE,
        DIRTY_BIT_COMPARE_FUNC,
        DIRTY_BIT_SRGB_DECODE,

        // Texture state
        DIRTY_BIT_SWIZZLE_RED,
        DIRTY_BIT_SWIZZLE_GREEN,
        DIRTY_BIT_SWIZZLE_BLUE,
        DIRTY_BIT_SWIZZLE_ALPHA,
        DIRTY_BIT_BASE_LEVEL,
        DIRTY_BIT_MAX_LEVEL,

        // Misc
        DIRTY_BIT_LABEL,
        DIRTY_BIT_USAGE,

        DIRTY_BIT_COUNT,
    };
    using DirtyBits = std::bitset<DIRTY_BIT_COUNT>;

    void syncImplState();
    bool hasAnyDirtyBit() const { return mDirtyBits.any(); }

  private:
    rx::FramebufferAttachmentObjectImpl *getAttachmentImpl() const override;

    // ANGLE-only method, used internally
    friend class egl::Surface;
    void bindTexImageFromSurface(egl::Surface *surface);
    void releaseTexImageFromSurface();

    // ANGLE-only methods, used internally
    friend class egl::Stream;
    void bindStream(egl::Stream *stream);
    void releaseStream();
    void acquireImageFromStream(const egl::Stream::GLTextureDescription &desc);
    void releaseImageFromStream();

    TextureState mState;
    DirtyBits mDirtyBits;
    rx::TextureImpl *mTexture;

    std::string mLabel;

    void releaseTexImageInternal();

    egl::Surface *mBoundSurface;
    egl::Stream *mBoundStream;
};

inline bool operator==(const TextureState &a, const TextureState &b)
{
    return a.mSwizzleState == b.mSwizzleState && a.mSamplerState == b.mSamplerState &&
           a.mBaseLevel == b.mBaseLevel && a.mMaxLevel == b.mMaxLevel &&
           a.mImmutableFormat == b.mImmutableFormat && a.mImmutableLevels == b.mImmutableLevels &&
           a.mUsage == b.mUsage;
}

inline bool operator!=(const TextureState &a, const TextureState &b)
{
    return !(a == b);
}
}

#endif   // LIBANGLE_TEXTURE_H_
