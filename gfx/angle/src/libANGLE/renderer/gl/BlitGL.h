//
// Copyright 2015 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//

// BlitGL.h: Defines the BlitGL class, a helper for blitting textures

#ifndef LIBANGLE_RENDERER_GL_BLITGL_H_
#define LIBANGLE_RENDERER_GL_BLITGL_H_

#include "angle_gl.h"
#include "common/angleutils.h"
#include "libANGLE/angletypes.h"
#include "libANGLE/Error.h"

namespace gl
{
class Framebuffer;
}

namespace rx
{

class FramebufferGL;
class FunctionsGL;
class StateManagerGL;
class TextureGL;
struct WorkaroundsGL;

class BlitGL : public angle::NonCopyable
{
  public:
    BlitGL(const FunctionsGL *functions,
           const WorkaroundsGL &workarounds,
           StateManagerGL *stateManager);
    ~BlitGL();

    gl::Error copyImageToLUMAWorkaroundTexture(GLuint texture,
                                               GLenum textureType,
                                               GLenum target,
                                               GLenum lumaFormat,
                                               size_t level,
                                               const gl::Rectangle &sourceArea,
                                               GLenum internalFormat,
                                               const gl::Framebuffer *source);

    gl::Error copySubImageToLUMAWorkaroundTexture(GLuint texture,
                                                  GLenum textureType,
                                                  GLenum target,
                                                  GLenum lumaFormat,
                                                  size_t level,
                                                  const gl::Offset &destOffset,
                                                  const gl::Rectangle &sourceArea,
                                                  const gl::Framebuffer *source);

    gl::Error blitColorBufferWithShader(const gl::Framebuffer *source,
                                        const gl::Framebuffer *dest,
                                        const gl::Rectangle &sourceArea,
                                        const gl::Rectangle &destArea,
                                        GLenum filter);

    gl::Error copySubTexture(TextureGL *source,
                             TextureGL *dest,
                             const gl::Extents &sourceSize,
                             const gl::Rectangle &sourceArea,
                             const gl::Offset &destOffset,
                             bool needsLumaWorkaround,
                             GLenum lumaFormat,
                             bool unpackFlipY,
                             bool unpackPremultiplyAlpha,
                             bool unpackUnmultiplyAlpha);

    gl::Error copyTexSubImage(TextureGL *source,
                              TextureGL *dest,
                              const gl::Rectangle &sourceArea,
                              const gl::Offset &destOffset);

    gl::Error initializeResources();

  private:
    void orphanScratchTextures();
    void setScratchTextureParameter(GLenum param, GLenum value);

    const FunctionsGL *mFunctions;
    const WorkaroundsGL &mWorkarounds;
    StateManagerGL *mStateManager;

    GLuint mBlitProgram;
    GLint mTexCoordAttributeLocation;
    GLint mSourceTextureLocation;
    GLint mScaleLocation;
    GLint mOffsetLocation;
    GLint mMultiplyAlphaLocation;
    GLint mUnMultiplyAlphaLocation;

    GLuint mScratchTextures[2];
    GLuint mScratchFBO;

    GLuint mVAO;
    GLuint mVertexBuffer;
};
}

#endif  // LIBANGLE_RENDERER_GL_BLITGL_H_
