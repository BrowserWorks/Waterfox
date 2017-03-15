/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* vim: set ts=8 sts=4 et sw=4 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "gfxUtils.h"
#include "GLBlitHelper.h"
#include "GLContext.h"
#include "GLScreenBuffer.h"
#include "ScopedGLHelpers.h"
#include "mozilla/Preferences.h"
#include "ImageContainer.h"
#include "HeapCopyOfStackArray.h"
#include "mozilla/gfx/Matrix.h"
#include "mozilla/UniquePtr.h"

#ifdef MOZ_WIDGET_ANDROID
#include "AndroidSurfaceTexture.h"
#include "GLImages.h"
#include "GLLibraryEGL.h"
#endif

#ifdef XP_MACOSX
#include "MacIOSurfaceImage.h"
#include "GLContextCGL.h"
#endif

using mozilla::layers::PlanarYCbCrImage;
using mozilla::layers::PlanarYCbCrData;

namespace mozilla {
namespace gl {

GLBlitHelper::GLBlitHelper(GLContext* gl)
    : mGL(gl)
    , mTexBlit_Buffer(0)
    , mTexBlit_VertShader(0)
    , mTex2DBlit_FragShader(0)
    , mTex2DRectBlit_FragShader(0)
    , mTex2DBlit_Program(0)
    , mTex2DRectBlit_Program(0)
    , mYFlipLoc(-1)
    , mTextureTransformLoc(-1)
    , mTexExternalBlit_FragShader(0)
    , mTexYUVPlanarBlit_FragShader(0)
    , mTexNV12PlanarBlit_FragShader(0)
    , mTexExternalBlit_Program(0)
    , mTexYUVPlanarBlit_Program(0)
    , mTexNV12PlanarBlit_Program(0)
    , mFBO(0)
    , mSrcTexY(0)
    , mSrcTexCb(0)
    , mSrcTexCr(0)
    , mSrcTexEGL(0)
    , mYTexScaleLoc(-1)
    , mCbCrTexScaleLoc(-1)
    , mYuvColorMatrixLoc(-1)
    , mTexWidth(0)
    , mTexHeight(0)
    , mCurYScale(1.0f)
    , mCurCbCrScale(1.0f)
{
}

GLBlitHelper::~GLBlitHelper()
{
    if (!mGL->MakeCurrent())
        return;

    DeleteTexBlitProgram();

    GLuint tex[] = {
        mSrcTexY,
        mSrcTexCb,
        mSrcTexCr,
        mSrcTexEGL,
    };

    mSrcTexY = mSrcTexCb = mSrcTexCr = mSrcTexEGL = 0;
    mGL->fDeleteTextures(ArrayLength(tex), tex);

    if (mFBO) {
        mGL->fDeleteFramebuffers(1, &mFBO);
    }
    mFBO = 0;
}

// Allowed to be destructive of state we restore in functions below.
bool
GLBlitHelper::InitTexQuadProgram(BlitType target)
{
    const char kTexBlit_VertShaderSource[] = "\
        #version 100                                  \n\
        #ifdef GL_ES                                  \n\
        precision mediump float;                      \n\
        #endif                                        \n\
        attribute vec2 aPosition;                     \n\
                                                      \n\
        uniform float uYflip;                         \n\
        varying vec2 vTexCoord;                       \n\
                                                      \n\
        void main(void)                               \n\
        {                                             \n\
            vTexCoord = aPosition;                    \n\
            vTexCoord.y = abs(vTexCoord.y - uYflip);  \n\
            vec2 vertPos = aPosition * 2.0 - 1.0;     \n\
            gl_Position = vec4(vertPos, 0.0, 1.0);    \n\
        }                                             \n\
    ";

    const char kTex2DBlit_FragShaderSource[] = "\
        #version 100                                        \n\
        #ifdef GL_ES                                        \n\
        #ifdef GL_FRAGMENT_PRECISION_HIGH                   \n\
            precision highp float;                          \n\
        #else                                               \n\
            precision mediump float;                        \n\
        #endif                                              \n\
        #endif                                              \n\
        uniform sampler2D uTexUnit;                         \n\
                                                            \n\
        varying vec2 vTexCoord;                             \n\
                                                            \n\
        void main(void)                                     \n\
        {                                                   \n\
            gl_FragColor = texture2D(uTexUnit, vTexCoord);  \n\
        }                                                   \n\
    ";

    const char kTex2DRectBlit_FragShaderSource[] = "\
        #version 100                                                  \n\
        #ifdef GL_FRAGMENT_PRECISION_HIGH                             \n\
            precision highp float;                                    \n\
        #else                                                         \n\
            precision mediump float;                                  \n\
        #endif                                                        \n\
                                                                      \n\
        uniform sampler2D uTexUnit;                                   \n\
        uniform vec2 uTexCoordMult;                                   \n\
                                                                      \n\
        varying vec2 vTexCoord;                                       \n\
                                                                      \n\
        void main(void)                                               \n\
        {                                                             \n\
            gl_FragColor = texture2DRect(uTexUnit,                    \n\
                                         vTexCoord * uTexCoordMult);  \n\
        }                                                             \n\
    ";
#ifdef ANDROID /* MOZ_WIDGET_ANDROID */
    const char kTexExternalBlit_FragShaderSource[] = "\
        #version 100                                                    \n\
        #extension GL_OES_EGL_image_external : require                  \n\
        #ifdef GL_FRAGMENT_PRECISION_HIGH                               \n\
            precision highp float;                                      \n\
        #else                                                           \n\
            precision mediump float;                                    \n\
        #endif                                                          \n\
        varying vec2 vTexCoord;                                         \n\
        uniform mat4 uTextureTransform;                                 \n\
        uniform samplerExternalOES uTexUnit;                            \n\
                                                                        \n\
        void main()                                                     \n\
        {                                                               \n\
            gl_FragColor = texture2D(uTexUnit,                          \n\
                (uTextureTransform * vec4(vTexCoord, 0.0, 1.0)).xy);    \n\
        }                                                               \n\
    ";
#endif
    /* From Rec601:
    [R]   [1.1643835616438356,  0.0,                 1.5960267857142858]      [ Y -  16]
    [G] = [1.1643835616438358, -0.3917622900949137, -0.8129676472377708]    x [Cb - 128]
    [B]   [1.1643835616438356,  2.017232142857143,   8.862867620416422e-17]   [Cr - 128]

    For [0,1] instead of [0,255], and to 5 places:
    [R]   [1.16438,  0.00000,  1.59603]   [ Y - 0.06275]
    [G] = [1.16438, -0.39176, -0.81297] x [Cb - 0.50196]
    [B]   [1.16438,  2.01723,  0.00000]   [Cr - 0.50196]

    From Rec709:
    [R]   [1.1643835616438356,  4.2781193979771426e-17, 1.7927410714285714]     [ Y -  16]
    [G] = [1.1643835616438358, -0.21324861427372963,   -0.532909328559444]    x [Cb - 128]
    [B]   [1.1643835616438356,  2.1124017857142854,     0.0]                    [Cr - 128]

    For [0,1] instead of [0,255], and to 5 places:
    [R]   [1.16438,  0.00000,  1.79274]   [ Y - 0.06275]
    [G] = [1.16438, -0.21325, -0.53291] x [Cb - 0.50196]
    [B]   [1.16438,  2.11240,  0.00000]   [Cr - 0.50196]
    */
    const char kTexYUVPlanarBlit_FragShaderSource[] = "\
        #version 100                                                        \n\
        #ifdef GL_ES                                                        \n\
        precision mediump float;                                            \n\
        #endif                                                              \n\
        varying vec2 vTexCoord;                                             \n\
        uniform sampler2D uYTexture;                                        \n\
        uniform sampler2D uCbTexture;                                       \n\
        uniform sampler2D uCrTexture;                                       \n\
        uniform vec2 uYTexScale;                                            \n\
        uniform vec2 uCbCrTexScale;                                         \n\
        uniform mat3 uYuvColorMatrix;                                       \n\
        void main()                                                         \n\
        {                                                                   \n\
            float y = texture2D(uYTexture, vTexCoord * uYTexScale).r;       \n\
            float cb = texture2D(uCbTexture, vTexCoord * uCbCrTexScale).r;  \n\
            float cr = texture2D(uCrTexture, vTexCoord * uCbCrTexScale).r;  \n\
            y = y - 0.06275;                                                \n\
            cb = cb - 0.50196;                                              \n\
            cr = cr - 0.50196;                                              \n\
            vec3 yuv = vec3(y, cb, cr);                                     \n\
            gl_FragColor.rgb = uYuvColorMatrix * yuv;                       \n\
            gl_FragColor.a = 1.0;                                           \n\
        }                                                                   \n\
    ";

#ifdef XP_MACOSX
    const char kTexNV12PlanarBlit_FragShaderSource[] = "\
        #version 100                                                             \n\
        #extension GL_ARB_texture_rectangle : require                            \n\
        #ifdef GL_ES                                                             \n\
        precision mediump float                                                  \n\
        #endif                                                                   \n\
        varying vec2 vTexCoord;                                                  \n\
        uniform sampler2DRect uYTexture;                                         \n\
        uniform sampler2DRect uCbCrTexture;                                      \n\
        uniform vec2 uYTexScale;                                                 \n\
        uniform vec2 uCbCrTexScale;                                              \n\
        void main()                                                              \n\
        {                                                                        \n\
            float y = texture2DRect(uYTexture, vTexCoord * uYTexScale).r;        \n\
            float cb = texture2DRect(uCbCrTexture, vTexCoord * uCbCrTexScale).r; \n\
            float cr = texture2DRect(uCbCrTexture, vTexCoord * uCbCrTexScale).a; \n\
            y = (y - 0.06275) * 1.16438;                                         \n\
            cb = cb - 0.50196;                                                   \n\
            cr = cr - 0.50196;                                                   \n\
            gl_FragColor.r = y + cr * 1.59603;                                   \n\
            gl_FragColor.g = y - 0.81297 * cr - 0.39176 * cb;                    \n\
            gl_FragColor.b = y + cb * 2.01723;                                   \n\
            gl_FragColor.a = 1.0;                                                \n\
        }                                                                        \n\
    ";
#endif

    bool success = false;

    GLuint* programPtr;
    GLuint* fragShaderPtr;
    const char* fragShaderSource;
    switch (target) {
    case ConvertEGLImage:
    case BlitTex2D:
        programPtr = &mTex2DBlit_Program;
        fragShaderPtr = &mTex2DBlit_FragShader;
        fragShaderSource = kTex2DBlit_FragShaderSource;
        break;
    case BlitTexRect:
        programPtr = &mTex2DRectBlit_Program;
        fragShaderPtr = &mTex2DRectBlit_FragShader;
        fragShaderSource = kTex2DRectBlit_FragShaderSource;
        break;
#ifdef ANDROID
    case ConvertSurfaceTexture:
    case ConvertGralloc:
        programPtr = &mTexExternalBlit_Program;
        fragShaderPtr = &mTexExternalBlit_FragShader;
        fragShaderSource = kTexExternalBlit_FragShaderSource;
        break;
#endif
    case ConvertPlanarYCbCr:
        programPtr = &mTexYUVPlanarBlit_Program;
        fragShaderPtr = &mTexYUVPlanarBlit_FragShader;
        fragShaderSource = kTexYUVPlanarBlit_FragShaderSource;
        break;
#ifdef XP_MACOSX
    case ConvertMacIOSurfaceImage:
        programPtr = &mTexNV12PlanarBlit_Program;
        fragShaderPtr = &mTexNV12PlanarBlit_FragShader;
        fragShaderSource = kTexNV12PlanarBlit_FragShaderSource;
        break;
#endif
    default:
        return false;
    }

    GLuint& program = *programPtr;
    GLuint& fragShader = *fragShaderPtr;

    // Use do-while(false) to let us break on failure
    do {
        if (program) {
            // Already have it...
            success = true;
            break;
        }

        if (!mTexBlit_Buffer) {

            /* CCW tri-strip:
             * 2---3
             * | \ |
             * 0---1
             */
            GLfloat verts[] = {
                0.0f, 0.0f,
                1.0f, 0.0f,
                0.0f, 1.0f,
                1.0f, 1.0f
            };
            HeapCopyOfStackArray<GLfloat> vertsOnHeap(verts);

            MOZ_ASSERT(!mTexBlit_Buffer);
            mGL->fGenBuffers(1, &mTexBlit_Buffer);
            mGL->fBindBuffer(LOCAL_GL_ARRAY_BUFFER, mTexBlit_Buffer);

            // Make sure we have a sane size.
            mGL->fBufferData(LOCAL_GL_ARRAY_BUFFER, vertsOnHeap.ByteLength(), vertsOnHeap.Data(), LOCAL_GL_STATIC_DRAW);
        }

        if (!mTexBlit_VertShader) {

            const char* vertShaderSource = kTexBlit_VertShaderSource;

            mTexBlit_VertShader = mGL->fCreateShader(LOCAL_GL_VERTEX_SHADER);
            mGL->fShaderSource(mTexBlit_VertShader, 1, &vertShaderSource, nullptr);
            mGL->fCompileShader(mTexBlit_VertShader);
        }

        MOZ_ASSERT(!fragShader);
        fragShader = mGL->fCreateShader(LOCAL_GL_FRAGMENT_SHADER);
        mGL->fShaderSource(fragShader, 1, &fragShaderSource, nullptr);
        mGL->fCompileShader(fragShader);

        program = mGL->fCreateProgram();
        mGL->fAttachShader(program, mTexBlit_VertShader);
        mGL->fAttachShader(program, fragShader);
        mGL->fBindAttribLocation(program, 0, "aPosition");
        mGL->fLinkProgram(program);

        if (GLContext::ShouldSpew()) {
            GLint status = 0;
            mGL->fGetShaderiv(mTexBlit_VertShader, LOCAL_GL_COMPILE_STATUS, &status);
            if (status != LOCAL_GL_TRUE) {
                NS_ERROR("Vert shader compilation failed.");

                GLint length = 0;
                mGL->fGetShaderiv(mTexBlit_VertShader, LOCAL_GL_INFO_LOG_LENGTH, &length);
                if (!length) {
                    printf_stderr("No shader info log available.\n");
                    break;
                }

                auto buffer = MakeUnique<char[]>(length);
                mGL->fGetShaderInfoLog(mTexBlit_VertShader, length, nullptr, buffer.get());

                printf_stderr("Shader info log (%d bytes): %s\n", length, buffer.get());
                break;
            }

            status = 0;
            mGL->fGetShaderiv(fragShader, LOCAL_GL_COMPILE_STATUS, &status);
            if (status != LOCAL_GL_TRUE) {
                NS_ERROR("Frag shader compilation failed.");

                GLint length = 0;
                mGL->fGetShaderiv(fragShader, LOCAL_GL_INFO_LOG_LENGTH, &length);
                if (!length) {
                    printf_stderr("No shader info log available.\n");
                    break;
                }

                auto buffer = MakeUnique<char[]>(length);
                mGL->fGetShaderInfoLog(fragShader, length, nullptr, buffer.get());

                printf_stderr("Shader info log (%d bytes): %s\n", length, buffer.get());
                break;
            }
        }

        GLint status = 0;
        mGL->fGetProgramiv(program, LOCAL_GL_LINK_STATUS, &status);
        if (status != LOCAL_GL_TRUE) {
            if (GLContext::ShouldSpew()) {
                NS_ERROR("Linking blit program failed.");
                GLint length = 0;
                mGL->fGetProgramiv(program, LOCAL_GL_INFO_LOG_LENGTH, &length);
                if (!length) {
                    printf_stderr("No program info log available.\n");
                    break;
                }

                auto buffer = MakeUnique<char[]>(length);
                mGL->fGetProgramInfoLog(program, length, nullptr, buffer.get());

                printf_stderr("Program info log (%d bytes): %s\n", length, buffer.get());
            }
            break;
        }

        // Cache and set attribute and uniform
        mGL->fUseProgram(program);
        switch (target) {
#ifdef ANDROID
            case ConvertSurfaceTexture:
            case ConvertGralloc:
#endif
            case BlitTex2D:
            case BlitTexRect:
            case ConvertEGLImage: {
                GLint texUnitLoc = mGL->fGetUniformLocation(program, "uTexUnit");
                MOZ_ASSERT(texUnitLoc != -1, "uniform uTexUnit not found");
                mGL->fUniform1i(texUnitLoc, 0);
                break;
            }
            case ConvertPlanarYCbCr: {
                GLint texY = mGL->fGetUniformLocation(program, "uYTexture");
                GLint texCb = mGL->fGetUniformLocation(program, "uCbTexture");
                GLint texCr = mGL->fGetUniformLocation(program, "uCrTexture");
                mYTexScaleLoc = mGL->fGetUniformLocation(program, "uYTexScale");
                mCbCrTexScaleLoc = mGL->fGetUniformLocation(program, "uCbCrTexScale");
                mYuvColorMatrixLoc = mGL->fGetUniformLocation(program, "uYuvColorMatrix");

                DebugOnly<bool> hasUniformLocations = texY != -1 &&
                                                      texCb != -1 &&
                                                      texCr != -1 &&
                                                      mYTexScaleLoc != -1 &&
                                                      mCbCrTexScaleLoc != -1 &&
                                                      mYuvColorMatrixLoc != -1;
                MOZ_ASSERT(hasUniformLocations, "uniforms not found");

                mGL->fUniform1i(texY, Channel_Y);
                mGL->fUniform1i(texCb, Channel_Cb);
                mGL->fUniform1i(texCr, Channel_Cr);
                break;
            }
            case ConvertMacIOSurfaceImage: {
#ifdef XP_MACOSX
                GLint texY = mGL->fGetUniformLocation(program, "uYTexture");
                GLint texCbCr = mGL->fGetUniformLocation(program, "uCbCrTexture");
                mYTexScaleLoc = mGL->fGetUniformLocation(program, "uYTexScale");
                mCbCrTexScaleLoc= mGL->fGetUniformLocation(program, "uCbCrTexScale");

                DebugOnly<bool> hasUniformLocations = texY != -1 &&
                                                      texCbCr != -1 &&
                                                      mYTexScaleLoc != -1 &&
                                                      mCbCrTexScaleLoc != -1;
                MOZ_ASSERT(hasUniformLocations, "uniforms not found");

                mGL->fUniform1i(texY, Channel_Y);
                mGL->fUniform1i(texCbCr, Channel_Cb);
#endif
                break;
            }
            default:
                return false;
        }
        MOZ_ASSERT(mGL->fGetAttribLocation(program, "aPosition") == 0);
        mYFlipLoc = mGL->fGetUniformLocation(program, "uYflip");
        MOZ_ASSERT(mYFlipLoc != -1, "uniform: uYflip not found");
        mTextureTransformLoc = mGL->fGetUniformLocation(program, "uTextureTransform");
        if (mTextureTransformLoc >= 0) {
            // Set identity matrix as default
            gfx::Matrix4x4 identity;
            mGL->fUniformMatrix4fv(mTextureTransformLoc, 1, false, &identity._11);
        }
        success = true;
    } while (false);

    if (!success) {
        // Clean up:
        DeleteTexBlitProgram();
        return false;
    }

    mGL->fUseProgram(program);
    mGL->fEnableVertexAttribArray(0);
    mGL->fBindBuffer(LOCAL_GL_ARRAY_BUFFER, mTexBlit_Buffer);
    mGL->fVertexAttribPointer(0,
                              2,
                              LOCAL_GL_FLOAT,
                              false,
                              0,
                              nullptr);
    return true;
}

bool
GLBlitHelper::UseTexQuadProgram(BlitType target, const gfx::IntSize& srcSize)
{
    if (!InitTexQuadProgram(target)) {
        return false;
    }

    if (target == BlitTexRect) {
        GLint texCoordMultLoc = mGL->fGetUniformLocation(mTex2DRectBlit_Program, "uTexCoordMult");
        MOZ_ASSERT(texCoordMultLoc != -1, "uniform not found");
        mGL->fUniform2f(texCoordMultLoc, srcSize.width, srcSize.height);
    }

    return true;
}

void
GLBlitHelper::DeleteTexBlitProgram()
{
    if (mTexBlit_Buffer) {
        mGL->fDeleteBuffers(1, &mTexBlit_Buffer);
        mTexBlit_Buffer = 0;
    }
    if (mTexBlit_VertShader) {
        mGL->fDeleteShader(mTexBlit_VertShader);
        mTexBlit_VertShader = 0;
    }
    if (mTex2DBlit_FragShader) {
        mGL->fDeleteShader(mTex2DBlit_FragShader);
        mTex2DBlit_FragShader = 0;
    }
    if (mTex2DRectBlit_FragShader) {
        mGL->fDeleteShader(mTex2DRectBlit_FragShader);
        mTex2DRectBlit_FragShader = 0;
    }
    if (mTex2DBlit_Program) {
        mGL->fDeleteProgram(mTex2DBlit_Program);
        mTex2DBlit_Program = 0;
    }
    if (mTex2DRectBlit_Program) {
        mGL->fDeleteProgram(mTex2DRectBlit_Program);
        mTex2DRectBlit_Program = 0;
    }
    if (mTexExternalBlit_FragShader) {
        mGL->fDeleteShader(mTexExternalBlit_FragShader);
        mTexExternalBlit_FragShader = 0;
    }
    if (mTexYUVPlanarBlit_FragShader) {
        mGL->fDeleteShader(mTexYUVPlanarBlit_FragShader);
        mTexYUVPlanarBlit_FragShader = 0;
    }
    if (mTexNV12PlanarBlit_FragShader) {
        mGL->fDeleteShader(mTexNV12PlanarBlit_FragShader);
        mTexNV12PlanarBlit_FragShader = 0;
    }
    if (mTexExternalBlit_Program) {
        mGL->fDeleteProgram(mTexExternalBlit_Program);
        mTexExternalBlit_Program = 0;
    }
    if (mTexYUVPlanarBlit_Program) {
        mGL->fDeleteProgram(mTexYUVPlanarBlit_Program);
        mTexYUVPlanarBlit_Program = 0;
    }
    if (mTexNV12PlanarBlit_Program) {
        mGL->fDeleteProgram(mTexNV12PlanarBlit_Program);
        mTexNV12PlanarBlit_Program = 0;
    }
}

void
GLBlitHelper::BlitFramebufferToFramebuffer(GLuint srcFB, GLuint destFB,
                                           const gfx::IntSize& srcSize,
                                           const gfx::IntSize& destSize,
                                           bool internalFBs)
{
    MOZ_ASSERT(!srcFB || mGL->fIsFramebuffer(srcFB));
    MOZ_ASSERT(!destFB || mGL->fIsFramebuffer(destFB));

    MOZ_ASSERT(mGL->IsSupported(GLFeature::framebuffer_blit));

    ScopedBindFramebuffer boundFB(mGL);
    ScopedGLState scissor(mGL, LOCAL_GL_SCISSOR_TEST, false);

    if (internalFBs) {
        mGL->Screen()->BindReadFB_Internal(srcFB);
        mGL->Screen()->BindDrawFB_Internal(destFB);
    } else {
        mGL->BindReadFB(srcFB);
        mGL->BindDrawFB(destFB);
    }

    mGL->fBlitFramebuffer(0, 0,  srcSize.width,  srcSize.height,
                          0, 0, destSize.width, destSize.height,
                          LOCAL_GL_COLOR_BUFFER_BIT,
                          LOCAL_GL_NEAREST);
}

void
GLBlitHelper::BlitFramebufferToFramebuffer(GLuint srcFB, GLuint destFB,
                                           const gfx::IntSize& srcSize,
                                           const gfx::IntSize& destSize,
                                           const GLFormats& srcFormats,
                                           bool internalFBs)
{
    MOZ_ASSERT(!srcFB || mGL->fIsFramebuffer(srcFB));
    MOZ_ASSERT(!destFB || mGL->fIsFramebuffer(destFB));

    if (mGL->IsSupported(GLFeature::framebuffer_blit)) {
        BlitFramebufferToFramebuffer(srcFB, destFB,
                                     srcSize, destSize,
                                     internalFBs);
        return;
    }

    GLuint tex = CreateTextureForOffscreen(mGL, srcFormats, srcSize);
    MOZ_ASSERT(tex);

    BlitFramebufferToTexture(srcFB, tex, srcSize, srcSize, internalFBs);
    BlitTextureToFramebuffer(tex, destFB, srcSize, destSize, internalFBs);

    mGL->fDeleteTextures(1, &tex);
}

void
GLBlitHelper::BindAndUploadYUVTexture(Channel which,
                                      uint32_t width,
                                      uint32_t height,
                                      void* data,
                                      bool needsAllocation)
{
    MOZ_ASSERT(which < Channel_Max, "Invalid channel!");
    GLuint* srcTexArr[3] = {&mSrcTexY, &mSrcTexCb, &mSrcTexCr};
    GLuint& tex = *srcTexArr[which];

    // RED textures aren't valid in GLES2, and ALPHA textures are not valid in desktop GL Core Profiles.
    // So use R8 textures on GL3.0+ and GLES3.0+, but LUMINANCE/LUMINANCE/UNSIGNED_BYTE otherwise.
    GLenum format;
    GLenum internalFormat;
    if (mGL->IsAtLeast(gl::ContextProfile::OpenGLCore, 300) ||
        mGL->IsAtLeast(gl::ContextProfile::OpenGLES, 300)) {
        format = LOCAL_GL_RED;
        internalFormat = LOCAL_GL_R8;
    } else {
        format = LOCAL_GL_LUMINANCE;
        internalFormat = LOCAL_GL_LUMINANCE;
    }

    if (!tex) {
        MOZ_ASSERT(needsAllocation);
        tex = CreateTexture(mGL, internalFormat, format, LOCAL_GL_UNSIGNED_BYTE,
                            gfx::IntSize(width, height), false);
    }
    mGL->fActiveTexture(LOCAL_GL_TEXTURE0 + which);

    mGL->fBindTexture(LOCAL_GL_TEXTURE_2D, tex);
    if (!needsAllocation) {
        mGL->fTexSubImage2D(LOCAL_GL_TEXTURE_2D,
                            0,
                            0,
                            0,
                            width,
                            height,
                            format,
                            LOCAL_GL_UNSIGNED_BYTE,
                            data);
    } else {
        mGL->fTexImage2D(LOCAL_GL_TEXTURE_2D,
                         0,
                         internalFormat,
                         width,
                         height,
                         0,
                         format,
                         LOCAL_GL_UNSIGNED_BYTE,
                         data);
    }
}

void
GLBlitHelper::BindAndUploadEGLImage(EGLImage image, GLuint target)
{
    MOZ_ASSERT(image != EGL_NO_IMAGE, "Bad EGLImage");

    if (!mSrcTexEGL) {
        mGL->fGenTextures(1, &mSrcTexEGL);
        mGL->fBindTexture(target, mSrcTexEGL);
        mGL->fTexParameteri(target, LOCAL_GL_TEXTURE_WRAP_S, LOCAL_GL_CLAMP_TO_EDGE);
        mGL->fTexParameteri(target, LOCAL_GL_TEXTURE_WRAP_T, LOCAL_GL_CLAMP_TO_EDGE);
        mGL->fTexParameteri(target, LOCAL_GL_TEXTURE_MAG_FILTER, LOCAL_GL_NEAREST);
        mGL->fTexParameteri(target, LOCAL_GL_TEXTURE_MIN_FILTER, LOCAL_GL_NEAREST);
    } else {
        mGL->fBindTexture(target, mSrcTexEGL);
    }
    mGL->fEGLImageTargetTexture2D(target, image);
}

#ifdef MOZ_WIDGET_ANDROID

#define ATTACH_WAIT_MS 50

bool
GLBlitHelper::BlitSurfaceTextureImage(layers::SurfaceTextureImage* stImage)
{
    AndroidSurfaceTexture* surfaceTexture = stImage->GetSurfaceTexture();

    ScopedBindTextureUnit boundTU(mGL, LOCAL_GL_TEXTURE0);

    if (NS_FAILED(surfaceTexture->Attach(mGL, PR_MillisecondsToInterval(ATTACH_WAIT_MS))))
        return false;

    // UpdateTexImage() changes the EXTERNAL binding, so save it here
    // so we can restore it after.
    int oldBinding = 0;
    mGL->fGetIntegerv(LOCAL_GL_TEXTURE_BINDING_EXTERNAL, &oldBinding);

    surfaceTexture->UpdateTexImage();

    gfx::Matrix4x4 transform;
    surfaceTexture->GetTransformMatrix(transform);

    mGL->fUniformMatrix4fv(mTextureTransformLoc, 1, false, &transform._11);
    mGL->fDrawArrays(LOCAL_GL_TRIANGLE_STRIP, 0, 4);

    surfaceTexture->Detach();

    mGL->fBindTexture(LOCAL_GL_TEXTURE_EXTERNAL, oldBinding);
    return true;
}

bool
GLBlitHelper::BlitEGLImageImage(layers::EGLImageImage* image)
{
    EGLImage eglImage = image->GetImage();
    EGLSync eglSync = image->GetSync();

    if (eglSync) {
        EGLint status = sEGLLibrary.fClientWaitSync(EGL_DISPLAY(), eglSync, 0, LOCAL_EGL_FOREVER);
        if (status != LOCAL_EGL_CONDITION_SATISFIED) {
            return false;
        }
    }

    ScopedBindTextureUnit boundTU(mGL, LOCAL_GL_TEXTURE0);

    int oldBinding = 0;
    mGL->fGetIntegerv(LOCAL_GL_TEXTURE_BINDING_2D, &oldBinding);

    BindAndUploadEGLImage(eglImage, LOCAL_GL_TEXTURE_2D);

    mGL->fDrawArrays(LOCAL_GL_TRIANGLE_STRIP, 0, 4);

    mGL->fBindTexture(LOCAL_GL_TEXTURE_2D, oldBinding);
    return true;
}

#endif

bool
GLBlitHelper::BlitPlanarYCbCrImage(layers::PlanarYCbCrImage* yuvImage)
{
    ScopedBindTextureUnit boundTU(mGL, LOCAL_GL_TEXTURE0);
    const PlanarYCbCrData* yuvData = yuvImage->GetData();

    bool needsAllocation = false;
    if (mTexWidth != yuvData->mYStride || mTexHeight != yuvData->mYSize.height) {
        mTexWidth = yuvData->mYStride;
        mTexHeight = yuvData->mYSize.height;
        needsAllocation = true;
    }

    GLint oldTex[3];
    for (int i = 0; i < 3; i++) {
        mGL->fActiveTexture(LOCAL_GL_TEXTURE0 + i);
        mGL->fGetIntegerv(LOCAL_GL_TEXTURE_BINDING_2D, &oldTex[i]);
    }
    BindAndUploadYUVTexture(Channel_Y, yuvData->mYStride, yuvData->mYSize.height, yuvData->mYChannel, needsAllocation);
    BindAndUploadYUVTexture(Channel_Cb, yuvData->mCbCrStride, yuvData->mCbCrSize.height, yuvData->mCbChannel, needsAllocation);
    BindAndUploadYUVTexture(Channel_Cr, yuvData->mCbCrStride, yuvData->mCbCrSize.height, yuvData->mCrChannel, needsAllocation);

    if (needsAllocation) {
        mGL->fUniform2f(mYTexScaleLoc, (float)yuvData->mYSize.width/yuvData->mYStride, 1.0f);
        mGL->fUniform2f(mCbCrTexScaleLoc, (float)yuvData->mCbCrSize.width/yuvData->mCbCrStride, 1.0f);
    }

    float* yuvToRgb = gfxUtils::Get3x3YuvColorMatrix(yuvData->mYUVColorSpace);
    mGL->fUniformMatrix3fv(mYuvColorMatrixLoc, 1, 0, yuvToRgb);

    mGL->fDrawArrays(LOCAL_GL_TRIANGLE_STRIP, 0, 4);
    for (int i = 0; i < 3; i++) {
        mGL->fActiveTexture(LOCAL_GL_TEXTURE0 + i);
        mGL->fBindTexture(LOCAL_GL_TEXTURE_2D, oldTex[i]);
    }
    return true;
}

#ifdef XP_MACOSX
bool
GLBlitHelper::BlitMacIOSurfaceImage(layers::MacIOSurfaceImage* ioImage)
{
    ScopedBindTextureUnit boundTU(mGL, LOCAL_GL_TEXTURE0);
    MacIOSurface* surf = ioImage->GetSurface();

    GLint oldTex[2];
    for (int i = 0; i < 2; i++) {
        mGL->fActiveTexture(LOCAL_GL_TEXTURE0 + i);
        mGL->fGetIntegerv(LOCAL_GL_TEXTURE_BINDING_2D, &oldTex[i]);
    }

    GLuint textures[2];
    mGL->fGenTextures(2, textures);

    mGL->fActiveTexture(LOCAL_GL_TEXTURE0);
    mGL->fBindTexture(LOCAL_GL_TEXTURE_RECTANGLE_ARB, textures[0]);
    mGL->fTexParameteri(LOCAL_GL_TEXTURE_RECTANGLE_ARB, LOCAL_GL_TEXTURE_WRAP_T, LOCAL_GL_CLAMP_TO_EDGE);
    mGL->fTexParameteri(LOCAL_GL_TEXTURE_RECTANGLE_ARB, LOCAL_GL_TEXTURE_WRAP_S, LOCAL_GL_CLAMP_TO_EDGE);
    surf->CGLTexImageIOSurface2D(gl::GLContextCGL::Cast(mGL)->GetCGLContext(), 0);
    mGL->fUniform2f(mYTexScaleLoc, surf->GetWidth(0), surf->GetHeight(0));

    mGL->fActiveTexture(LOCAL_GL_TEXTURE1);
    mGL->fBindTexture(LOCAL_GL_TEXTURE_RECTANGLE_ARB, textures[1]);
    mGL->fTexParameteri(LOCAL_GL_TEXTURE_RECTANGLE_ARB, LOCAL_GL_TEXTURE_WRAP_T, LOCAL_GL_CLAMP_TO_EDGE);
    mGL->fTexParameteri(LOCAL_GL_TEXTURE_RECTANGLE_ARB, LOCAL_GL_TEXTURE_WRAP_S, LOCAL_GL_CLAMP_TO_EDGE);
    surf->CGLTexImageIOSurface2D(gl::GLContextCGL::Cast(mGL)->GetCGLContext(), 1);
    mGL->fUniform2f(mCbCrTexScaleLoc, surf->GetWidth(1), surf->GetHeight(1));

    mGL->fDrawArrays(LOCAL_GL_TRIANGLE_STRIP, 0, 4);
    for (int i = 0; i < 2; i++) {
        mGL->fActiveTexture(LOCAL_GL_TEXTURE0 + i);
        mGL->fBindTexture(LOCAL_GL_TEXTURE_2D, oldTex[i]);
    }

    mGL->fDeleteTextures(2, textures);
    return true;
}
#endif

bool
GLBlitHelper::BlitImageToFramebuffer(layers::Image* srcImage,
                                     const gfx::IntSize& destSize,
                                     GLuint destFB,
                                     OriginPos destOrigin)
{
    ScopedGLDrawState autoStates(mGL);

    BlitType type;
    OriginPos srcOrigin;

    switch (srcImage->GetFormat()) {
    case ImageFormat::PLANAR_YCBCR:
        type = ConvertPlanarYCbCr;
        srcOrigin = OriginPos::BottomLeft;
        break;

#ifdef MOZ_WIDGET_ANDROID
    case ImageFormat::SURFACE_TEXTURE:
        type = ConvertSurfaceTexture;
        srcOrigin = srcImage->AsSurfaceTextureImage()->GetOriginPos();
        break;
    case ImageFormat::EGLIMAGE:
        type = ConvertEGLImage;
        srcOrigin = srcImage->AsEGLImageImage()->GetOriginPos();
        break;
#endif
#ifdef XP_MACOSX
    case ImageFormat::MAC_IOSURFACE:
        type = ConvertMacIOSurfaceImage;
        srcOrigin = OriginPos::TopLeft;
        break;
#endif

    default:
        return false;
    }

    bool init = InitTexQuadProgram(type);
    if (!init) {
        return false;
    }

    const bool needsYFlip = (srcOrigin != destOrigin);
    mGL->fUniform1f(mYFlipLoc, needsYFlip ? (float)1.0 : (float)0.0);

    ScopedBindFramebuffer boundFB(mGL, destFB);
    mGL->fColorMask(LOCAL_GL_TRUE, LOCAL_GL_TRUE, LOCAL_GL_TRUE, LOCAL_GL_TRUE);
    mGL->fViewport(0, 0, destSize.width, destSize.height);

    switch (type) {
    case ConvertPlanarYCbCr: {
            const auto saved = mGL->GetIntAs<GLint>(LOCAL_GL_UNPACK_ALIGNMENT);
            mGL->fPixelStorei(LOCAL_GL_UNPACK_ALIGNMENT, 1);
            const auto ret = BlitPlanarYCbCrImage(static_cast<PlanarYCbCrImage*>(srcImage));
            mGL->fPixelStorei(LOCAL_GL_UNPACK_ALIGNMENT, saved);
            return ret;
        }

#ifdef MOZ_WIDGET_ANDROID
    case ConvertSurfaceTexture:
        return BlitSurfaceTextureImage(static_cast<layers::SurfaceTextureImage*>(srcImage));

    case ConvertEGLImage:
        return BlitEGLImageImage(static_cast<layers::EGLImageImage*>(srcImage));
#endif

#ifdef XP_MACOSX
    case ConvertMacIOSurfaceImage:
        return BlitMacIOSurfaceImage(srcImage->AsMacIOSurfaceImage());
#endif

    default:
        return false;
    }
}

bool
GLBlitHelper::BlitImageToTexture(layers::Image* srcImage,
                                 const gfx::IntSize& destSize,
                                 GLuint destTex,
                                 GLenum destTarget,
                                 OriginPos destOrigin)
{
    ScopedFramebufferForTexture autoFBForTex(mGL, destTex, destTarget);
    if (!autoFBForTex.IsComplete())
        return false;

    return BlitImageToFramebuffer(srcImage, destSize, autoFBForTex.FB(), destOrigin);
}

void
GLBlitHelper::BlitTextureToFramebuffer(GLuint srcTex, GLuint destFB,
                                       const gfx::IntSize& srcSize,
                                       const gfx::IntSize& destSize,
                                       GLenum srcTarget,
                                       bool internalFBs)
{
    MOZ_ASSERT(mGL->fIsTexture(srcTex));
    MOZ_ASSERT(!destFB || mGL->fIsFramebuffer(destFB));

    if (mGL->IsSupported(GLFeature::framebuffer_blit)) {
        ScopedFramebufferForTexture srcWrapper(mGL, srcTex, srcTarget);
        MOZ_DIAGNOSTIC_ASSERT(srcWrapper.IsComplete());

        BlitFramebufferToFramebuffer(srcWrapper.FB(), destFB,
                                     srcSize, destSize,
                                     internalFBs);
        return;
    }

    DrawBlitTextureToFramebuffer(srcTex, destFB, srcSize, destSize, srcTarget,
                                 internalFBs);
}


void
GLBlitHelper::DrawBlitTextureToFramebuffer(GLuint srcTex, GLuint destFB,
                                           const gfx::IntSize& srcSize,
                                           const gfx::IntSize& destSize,
                                           GLenum srcTarget,
                                           bool internalFBs)
{
    BlitType type;
    switch (srcTarget) {
    case LOCAL_GL_TEXTURE_2D:
        type = BlitTex2D;
        break;
    case LOCAL_GL_TEXTURE_RECTANGLE_ARB:
        type = BlitTexRect;
        break;
    default:
        MOZ_CRASH("GFX: Fatal Error: Bad `srcTarget`.");
        break;
    }

    ScopedGLDrawState autoStates(mGL);
    if (internalFBs) {
        mGL->Screen()->BindFB_Internal(destFB);
    } else {
        mGL->BindFB(destFB);
    }

    // Does destructive things to (only!) what we just saved above.
    bool good = UseTexQuadProgram(type, srcSize);
    if (!good) {
        // We're up against the wall, so bail.
        MOZ_DIAGNOSTIC_ASSERT(false,
                              "Error: Failed to prepare to blit texture->framebuffer.\n");
        mGL->fScissor(0, 0, destSize.width, destSize.height);
        mGL->fColorMask(1, 1, 1, 1);
        mGL->fClear(LOCAL_GL_COLOR_BUFFER_BIT);
        return;
    }

    mGL->fDrawArrays(LOCAL_GL_TRIANGLE_STRIP, 0, 4);
}

void
GLBlitHelper::BlitFramebufferToTexture(GLuint srcFB, GLuint destTex,
                                       const gfx::IntSize& srcSize,
                                       const gfx::IntSize& destSize,
                                       GLenum destTarget,
                                       bool internalFBs)
{
    // On the Android 4.3 emulator, IsFramebuffer may return false incorrectly.
    MOZ_ASSERT_IF(mGL->Renderer() != GLRenderer::AndroidEmulator, !srcFB || mGL->fIsFramebuffer(srcFB));
    MOZ_ASSERT(mGL->fIsTexture(destTex));

    if (mGL->IsSupported(GLFeature::framebuffer_blit)) {
        ScopedFramebufferForTexture destWrapper(mGL, destTex, destTarget);

        BlitFramebufferToFramebuffer(srcFB, destWrapper.FB(),
                                     srcSize, destSize,
                                     internalFBs);
        return;
    }

    ScopedBindTexture autoTex(mGL, destTex, destTarget);

    ScopedBindFramebuffer boundFB(mGL);
    if (internalFBs) {
        mGL->Screen()->BindFB_Internal(srcFB);
    } else {
        mGL->BindFB(srcFB);
    }

    ScopedGLState scissor(mGL, LOCAL_GL_SCISSOR_TEST, false);
    mGL->fCopyTexSubImage2D(destTarget, 0,
                       0, 0,
                       0, 0,
                       srcSize.width, srcSize.height);
}

void
GLBlitHelper::BlitTextureToTexture(GLuint srcTex, GLuint destTex,
                                   const gfx::IntSize& srcSize,
                                   const gfx::IntSize& destSize,
                                   GLenum srcTarget, GLenum destTarget)
{
    MOZ_ASSERT(mGL->fIsTexture(srcTex));
    MOZ_ASSERT(mGL->fIsTexture(destTex));

    // Generally, just use the CopyTexSubImage path
    ScopedFramebufferForTexture srcWrapper(mGL, srcTex, srcTarget);

    BlitFramebufferToTexture(srcWrapper.FB(), destTex,
                             srcSize, destSize, destTarget);
}

} // namespace gl
} // namespace mozilla
