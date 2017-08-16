//
// Copyright (c) 2016 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//

// DisplayOzone.cpp: Ozone implementation of egl::Display

#include "libANGLE/renderer/gl/egl/ozone/DisplayOzone.h"

#include <fcntl.h>
#include <poll.h>
#include <iostream>
#include <unistd.h>
#include <sys/time.h>

#include <EGL/eglext.h>

#include <gbm.h>
#include <drm_fourcc.h>

#include "common/debug.h"
#include "libANGLE/Config.h"
#include "libANGLE/Display.h"
#include "libANGLE/Surface.h"
#include "libANGLE/renderer/gl/FramebufferGL.h"
#include "libANGLE/renderer/gl/RendererGL.h"
#include "libANGLE/renderer/gl/StateManagerGL.h"
#include "libANGLE/renderer/gl/egl/FunctionsEGLDL.h"
#include "libANGLE/renderer/gl/egl/ozone/SurfaceOzone.h"
#include "platform/Platform.h"

// ARM-specific extension needed to make Mali GPU behave - not in any
// published header file.
#ifndef EGL_SYNC_PRIOR_COMMANDS_IMPLICIT_EXTERNAL_ARM
#define EGL_SYNC_PRIOR_COMMANDS_IMPLICIT_EXTERNAL_ARM 0x328A
#endif

#ifndef EGL_NO_CONFIG_MESA
#define EGL_NO_CONFIG_MESA ((EGLConfig)0)
#endif

namespace
{

EGLint UnsignedToSigned(uint32_t u)
{
    return *reinterpret_cast<const EGLint *>(&u);
}

drmModeModeInfoPtr ChooseMode(drmModeConnectorPtr conn)
{
    drmModeModeInfoPtr mode = nullptr;
    ASSERT(conn);
    ASSERT(conn->connection == DRM_MODE_CONNECTED);
    // use first preferred mode if any, else end up with last mode in list
    for (int i = 0; i < conn->count_modes; ++i)
    {
        mode = conn->modes + i;
        if (mode->type & DRM_MODE_TYPE_PREFERRED)
        {
            break;
        }
    }
    return mode;
}

int ChooseCRTC(int fd, drmModeConnectorPtr conn)
{
    for (int i = 0; i < conn->count_encoders; ++i)
    {
        drmModeEncoderPtr enc = drmModeGetEncoder(fd, conn->encoders[i]);
        unsigned long crtcs = enc->possible_crtcs;
        drmModeFreeEncoder(enc);
        if (crtcs)
        {
            return __builtin_ctzl(crtcs);
        }
    }
    return -1;
}
}  // namespace

namespace rx
{

// TODO(fjhenigman) Implement swap control.  Until then this is unused.
SwapControlData::SwapControlData()
    : targetSwapInterval(0), maxSwapInterval(-1), currentSwapInterval(-1)
{
}

DisplayOzone::Buffer::Buffer(DisplayOzone *display,
                             uint32_t useFlags,
                             uint32_t gbmFormat,
                             uint32_t drmFormat,
                             uint32_t drmFormatFB,
                             int depthBits,
                             int stencilBits)
    : mDisplay(display),
      mNative(nullptr),
      mWidth(0),
      mHeight(0),
      mDepthBits(depthBits),
      mStencilBits(stencilBits),
      mUseFlags(useFlags),
      mGBMFormat(gbmFormat),
      mDRMFormat(drmFormat),
      mDRMFormatFB(drmFormatFB),
      mBO(nullptr),
      mDMABuf(-1),
      mHasDRMFB(false),
      mDRMFB(0),
      mImage(EGL_NO_IMAGE_KHR),
      mColorBuffer(0),
      mDSBuffer(0),
      mGLFB(0),
      mTexture(0)
{
}

DisplayOzone::Buffer::~Buffer()
{
    mDisplay->mFunctionsGL->deleteFramebuffers(1, &mGLFB);
    reset();
}

void DisplayOzone::Buffer::reset()
{
    if (mHasDRMFB)
    {
        int fd = gbm_device_get_fd(mDisplay->mGBM);
        drmModeRmFB(fd, mDRMFB);
        mHasDRMFB = false;
    }

    FunctionsGL *gl = mDisplay->mFunctionsGL;
    gl->deleteRenderbuffers(1, &mColorBuffer);
    mColorBuffer = 0;
    gl->deleteRenderbuffers(1, &mDSBuffer);
    mDSBuffer = 0;

    // Here we might destroy the GL framebuffer (mGLFB) but unlike every other resource in Buffer,
    // it does not get destroyed (and recreated) because when it is the default framebuffer for
    // an ANGLE surface then ANGLE expects it to have the same lifetime as that surface.

    if (mImage != EGL_NO_IMAGE_KHR)
    {
        mDisplay->mEGL->destroyImageKHR(mImage);
        mImage = EGL_NO_IMAGE_KHR;
    }

    if (mTexture)
    {
        gl->deleteTextures(1, &mTexture);
        mTexture = 0;
    }

    if (mDMABuf >= 0)
    {
        close(mDMABuf);
        mDMABuf = -1;
    }

    if (mBO)
    {
        gbm_bo_destroy(mBO);
        mBO = nullptr;
    }
}

bool DisplayOzone::Buffer::resize(int32_t width, int32_t height)
{
    if (mWidth == width && mHeight == height)
    {
        return true;
    }

    reset();

    if (width <= 0 || height <= 0)
    {
        return true;
    }

    mBO = gbm_bo_create(mDisplay->mGBM, width, height, mGBMFormat, mUseFlags);
    if (!mBO)
    {
        return false;
    }

    mDMABuf = gbm_bo_get_fd(mBO);
    if (mDMABuf < 0)
    {
        return false;
    }

    // clang-format off
    const EGLint attr[] =
    {
        EGL_WIDTH, width,
        EGL_HEIGHT, height,
        EGL_LINUX_DRM_FOURCC_EXT, UnsignedToSigned(mDRMFormat),
        EGL_DMA_BUF_PLANE0_FD_EXT, mDMABuf,
        EGL_DMA_BUF_PLANE0_PITCH_EXT, UnsignedToSigned(gbm_bo_get_stride(mBO)),
        EGL_DMA_BUF_PLANE0_OFFSET_EXT, 0,
        EGL_NONE,
    };
    // clang-format on

    mImage = mDisplay->mEGL->createImageKHR(EGL_NO_CONTEXT, EGL_LINUX_DMA_BUF_EXT, nullptr, attr);
    if (mImage == EGL_NO_IMAGE_KHR)
    {
        return false;
    }

    FunctionsGL *gl    = mDisplay->mFunctionsGL;
    StateManagerGL *sm = mDisplay->getRenderer()->getStateManager();

    gl->genRenderbuffers(1, &mColorBuffer);
    sm->bindRenderbuffer(GL_RENDERBUFFER, mColorBuffer);
    gl->eglImageTargetRenderbufferStorageOES(GL_RENDERBUFFER, mImage);

    sm->bindFramebuffer(GL_FRAMEBUFFER, mGLFB);
    gl->framebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0_EXT, GL_RENDERBUFFER,
                                mColorBuffer);

    if (mDepthBits || mStencilBits)
    {
        gl->genRenderbuffers(1, &mDSBuffer);
        sm->bindRenderbuffer(GL_RENDERBUFFER, mDSBuffer);
        gl->renderbufferStorage(GL_RENDERBUFFER, GL_DEPTH24_STENCIL8_OES, width, height);
    }

    if (mDepthBits)
    {
        gl->framebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER,
                                    mDSBuffer);
    }

    if (mStencilBits)
    {
        gl->framebufferRenderbuffer(GL_FRAMEBUFFER, GL_STENCIL_ATTACHMENT, GL_RENDERBUFFER,
                                    mDSBuffer);
    }

    mWidth  = width;
    mHeight = height;
    return true;
}

bool DisplayOzone::Buffer::initialize(const NativeWindow *native)
{
    mNative = native;
    mDisplay->mFunctionsGL->genFramebuffers(1, &mGLFB);
    return resize(native->width, native->height);
}

bool DisplayOzone::Buffer::initialize(int width, int height)
{
    mDisplay->mFunctionsGL->genFramebuffers(1, &mGLFB);
    return resize(width, height);
}

void DisplayOzone::Buffer::bindTexImage()
{
    mDisplay->mFunctionsGL->eglImageTargetTexture2DOES(GL_TEXTURE_2D, mImage);
}

GLuint DisplayOzone::Buffer::getTexture()
{
    // TODO(fjhenigman) Try not to create a new texture every time.  That already works on Intel
    // and should work on Mali with proper fences.
    FunctionsGL *gl    = mDisplay->mFunctionsGL;
    StateManagerGL *sm = mDisplay->getRenderer()->getStateManager();

    gl->genTextures(1, &mTexture);
    sm->bindTexture(GL_TEXTURE_2D, mTexture);
    gl->texParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    gl->texParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    gl->texParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    gl->texParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    ASSERT(mImage != EGL_NO_IMAGE_KHR);
    gl->eglImageTargetTexture2DOES(GL_TEXTURE_2D, mImage);
    return mTexture;
}

uint32_t DisplayOzone::Buffer::getDRMFB()
{
    if (!mHasDRMFB)
    {
        int fd              = gbm_device_get_fd(mDisplay->mGBM);
        uint32_t handles[4] = {gbm_bo_get_handle(mBO).u32};
        uint32_t pitches[4] = {gbm_bo_get_stride(mBO)};
        uint32_t offsets[4] = {0};
        if (drmModeAddFB2(fd, mWidth, mHeight, mDRMFormatFB, handles, pitches, offsets, &mDRMFB, 0))
        {
            std::cerr << "drmModeAddFB2 failed" << std::endl;
        }
        else
        {
            mHasDRMFB = true;
        }
    }

    return mDRMFB;
}

FramebufferGL *DisplayOzone::Buffer::framebufferGL(const gl::FramebufferState &state)
{
    return new FramebufferGL(
        mGLFB, state, mDisplay->mFunctionsGL, mDisplay->getRenderer()->getWorkarounds(),
        mDisplay->getRenderer()->getBlitter(), mDisplay->getRenderer()->getStateManager());
}

void DisplayOzone::Buffer::present()
{
    if (mNative)
    {
        if (mNative->visible)
        {
            mDisplay->drawBuffer(this);
        }
        resize(mNative->width, mNative->height);
    }
}

DisplayOzone::DisplayOzone()
    : DisplayEGL(),
      mSwapControl(SwapControl::ABSENT),
      mMinSwapInterval(0),
      mMaxSwapInterval(0),
      mCurrentSwapInterval(-1),
      mGBM(nullptr),
      mConnector(nullptr),
      mMode(nullptr),
      mCRTC(nullptr),
      mSetCRTC(true),
      mWidth(0),
      mHeight(0),
      mScanning(nullptr),
      mPending(nullptr),
      mDrawing(nullptr),
      mUnused(nullptr),
      mProgram(0),
      mVertexShader(0),
      mFragmentShader(0),
      mVertexBuffer(0),
      mIndexBuffer(0),
      mCenterUniform(0),
      mWindowSizeUniform(0),
      mBorderSizeUniform(0),
      mDepthUniform(0)
{
}

DisplayOzone::~DisplayOzone()
{
}

egl::Error DisplayOzone::initialize(egl::Display *display)
{
    int fd;
    char deviceName[30];
    drmModeResPtr resources = nullptr;

    for (int i = 0; i < 9; ++i)
    {
        snprintf(deviceName, sizeof(deviceName), "/dev/dri/card%d", i);
        fd = open(deviceName, O_RDWR | O_CLOEXEC);
        if (fd >= 0)
        {
            resources = drmModeGetResources(fd);
            if (resources)
            {
                if (resources->count_connectors > 0)
                {
                    break;
                }
                drmModeFreeResources(resources);
                resources = nullptr;
            }
            close(fd);
        }
    }
    if (!resources)
    {
        return egl::Error(EGL_NOT_INITIALIZED, "Could not open drm device.");
    }

    mGBM = gbm_create_device(fd);
    if (!mGBM)
    {
        close(fd);
        drmModeFreeResources(resources);
        return egl::Error(EGL_NOT_INITIALIZED, "Could not create gbm device.");
    }

    mConnector            = nullptr;
    bool monitorConnected = false;
    for (int i = 0; !mCRTC && i < resources->count_connectors; ++i)
    {
        drmModeFreeConnector(mConnector);
        mConnector = drmModeGetConnector(fd, resources->connectors[i]);
        if (!mConnector || mConnector->connection != DRM_MODE_CONNECTED)
        {
            continue;
        }
        monitorConnected = true;
        mMode = ChooseMode(mConnector);
        if (!mMode)
        {
            continue;
        }
        int n = ChooseCRTC(fd, mConnector);
        if (n < 0)
        {
            continue;
        }
        mCRTC = drmModeGetCrtc(fd, resources->crtcs[n]);
    }
    drmModeFreeResources(resources);

    if (mCRTC)
    {
        mWidth  = mMode->hdisplay;
        mHeight = mMode->vdisplay;
    }
    else if (!monitorConnected)
    {
        // Even though there is no monitor to show it, we still do
        // everything the same as if there were one, so we need an
        // arbitrary size for our buffers.
        mWidth  = 1280;
        mHeight = 1024;
    }
    else
    {
        return egl::Error(EGL_NOT_INITIALIZED, "Failed to choose mode/crtc.");
    }

    // ANGLE builds its executables with an RPATH so they pull in ANGLE's libGL and libEGL.
    // Here we need to open the native libEGL.  An absolute path would work, but then we
    // couldn't use LD_LIBRARY_PATH which is often useful during development.  Instead we take
    // advantage of the fact that the system lib is available under multiple names (for example
    // with a .1 suffix) while Angle only installs libEGL.so.
    FunctionsEGLDL *egl = new FunctionsEGLDL();
    mEGL = egl;
    ANGLE_TRY(egl->initialize(display->getNativeDisplayId(), "libEGL.so.1"));

    const char *necessaryExtensions[] = {
        "EGL_KHR_image_base", "EGL_EXT_image_dma_buf_import", "EGL_KHR_surfaceless_context",
    };
    for (auto &ext : necessaryExtensions)
    {
        if (!mEGL->hasExtension(ext))
        {
            return egl::Error(EGL_NOT_INITIALIZED, "need %s", ext);
        }
    }

    if (mEGL->hasExtension("EGL_MESA_configless_context"))
    {
        mConfig = EGL_NO_CONFIG_MESA;
    }
    else
    {
        // clang-format off
        const EGLint attrib[] =
        {
            // We want RGBA8 and DEPTH24_STENCIL8
            EGL_RED_SIZE, 8,
            EGL_GREEN_SIZE, 8,
            EGL_BLUE_SIZE, 8,
            EGL_ALPHA_SIZE, 8,
            EGL_DEPTH_SIZE, 24,
            EGL_STENCIL_SIZE, 8,
            EGL_NONE,
        };
        // clang-format on
        EGLint numConfig;
        EGLConfig config[1];
        if (!mEGL->chooseConfig(attrib, config, 1, &numConfig) || numConfig < 1)
        {
            return egl::Error(EGL_NOT_INITIALIZED, "Could not get EGL config.");
        }
        mConfig = config[0];
    }

    ANGLE_TRY(initializeContext(display->getAttributeMap()));

    if (!mEGL->makeCurrent(EGL_NO_SURFACE, mContext))
    {
        return egl::Error(EGL_NOT_INITIALIZED, "Could not make context current.");
    }

    mFunctionsGL = mEGL->makeFunctionsGL();
    mFunctionsGL->initialize();

    return DisplayGL::initialize(display);
}

void DisplayOzone::pageFlipHandler(int fd,
                                   unsigned int sequence,
                                   unsigned int tv_sec,
                                   unsigned int tv_usec,
                                   void *data)
{
    DisplayOzone *display = reinterpret_cast<DisplayOzone *>(data);
    uint64_t tv = tv_sec;
    display->pageFlipHandler(sequence, tv * 1000000 + tv_usec);
}

void DisplayOzone::pageFlipHandler(unsigned int sequence, uint64_t tv)
{
    ASSERT(mPending);
    mUnused   = mScanning;
    mScanning = mPending;
    mPending  = nullptr;
}

void DisplayOzone::presentScreen()
{
    if (!mCRTC)
    {
        // no monitor
        return;
    }

    // see if pending flip has finished, without blocking
    int fd = gbm_device_get_fd(mGBM);
    if (mPending)
    {
        pollfd pfd;
        pfd.fd     = fd;
        pfd.events = POLLIN;
        if (poll(&pfd, 1, 0) < 0)
        {
            std::cerr << "poll failed: " << errno << " " << strerror(errno) << std::endl;
        }
        if (pfd.revents & POLLIN)
        {
            drmEventContext event;
            event.version           = DRM_EVENT_CONTEXT_VERSION;
            event.page_flip_handler = pageFlipHandler;
            drmHandleEvent(fd, &event);
        }
    }

    // if pending flip has finished, schedule next one
    if (!mPending && mDrawing)
    {
        flushGL();
        if (mSetCRTC)
        {
            if (drmModeSetCrtc(fd, mCRTC->crtc_id, mDrawing->getDRMFB(), 0, 0,
                               &mConnector->connector_id, 1, mMode))
            {
                std::cerr << "set crtc failed: " << errno << " " << strerror(errno) << std::endl;
            }
            mSetCRTC = false;
        }
        if (drmModePageFlip(fd, mCRTC->crtc_id, mDrawing->getDRMFB(), DRM_MODE_PAGE_FLIP_EVENT,
                            this))
        {
            std::cerr << "page flip failed: " << errno << " " << strerror(errno) << std::endl;
        }
        mPending = mDrawing;
        mDrawing = nullptr;
    }
}

GLuint DisplayOzone::makeShader(GLuint type, const char *src)
{
    FunctionsGL *gl = mFunctionsGL;
    GLuint shader = gl->createShader(type);
    gl->shaderSource(shader, 1, &src, nullptr);
    gl->compileShader(shader);

    GLchar buf[999];
    GLsizei len;
    GLint compiled;
    gl->getShaderInfoLog(shader, sizeof(buf), &len, buf);
    gl->getShaderiv(shader, GL_COMPILE_STATUS, &compiled);
    if (compiled != GL_TRUE)
    {
        ANGLEPlatformCurrent()->logError("DisplayOzone shader compilation error:");
        ANGLEPlatformCurrent()->logError(buf);
    }

    return shader;
}

void DisplayOzone::drawWithTexture(Buffer *buffer)
{
    FunctionsGL *gl    = mFunctionsGL;
    StateManagerGL *sm = getRenderer()->getStateManager();

    if (!mProgram)
    {
        const GLchar *vertexSource =
            "#version 100\n"
            "attribute vec3 vertex;\n"
            "uniform vec2 center;\n"
            "uniform vec2 windowSize;\n"
            "uniform vec2 borderSize;\n"
            "uniform float depth;\n"
            "varying vec3 texCoord;\n"
            "void main()\n"
            "{\n"
            "    vec2 pos = vertex.xy * (windowSize + borderSize * vertex.z);\n"
            "    gl_Position = vec4(center + pos, depth, 1);\n"
            "    texCoord = vec3(pos / windowSize * vec2(.5, -.5) + vec2(.5, .5), vertex.z);\n"
            "}\n";

        const GLchar *fragmentSource =
            "#version 100\n"
            "precision mediump float;\n"
            "uniform sampler2D tex;\n"
            "varying vec3 texCoord;\n"
            "void main()\n"
            "{\n"
            "    if (texCoord.z > 0.)\n"
            "    {\n"
            "        float c = abs((texCoord.z * 2.) - 1.);\n"
            "        gl_FragColor = vec4(c, c, c, 1);\n"
            "    }\n"
            "    else\n"
            "    {\n"
            "        gl_FragColor = texture2D(tex, texCoord.xy);\n"
            "    }\n"
            "}\n";

        mVertexShader   = makeShader(GL_VERTEX_SHADER, vertexSource);
        mFragmentShader = makeShader(GL_FRAGMENT_SHADER, fragmentSource);
        mProgram = gl->createProgram();
        gl->attachShader(mProgram, mVertexShader);
        gl->attachShader(mProgram, mFragmentShader);
        gl->bindAttribLocation(mProgram, 0, "vertex");
        gl->linkProgram(mProgram);
        GLint linked;
        gl->getProgramiv(mProgram, GL_LINK_STATUS, &linked);
        ASSERT(linked);
        mCenterUniform     = gl->getUniformLocation(mProgram, "center");
        mWindowSizeUniform = gl->getUniformLocation(mProgram, "windowSize");
        mBorderSizeUniform = gl->getUniformLocation(mProgram, "borderSize");
        mDepthUniform      = gl->getUniformLocation(mProgram, "depth");
        GLint texUniform = gl->getUniformLocation(mProgram, "tex");
        sm->useProgram(mProgram);
        gl->uniform1i(texUniform, 0);

        // clang-format off
        const GLfloat vertices[] =
        {
             // window corners, and window border inside corners
             1, -1, 0,
            -1, -1, 0,
             1,  1, 0,
            -1,  1, 0,
             // window border outside corners
             1, -1, 1,
            -1, -1, 1,
             1,  1, 1,
            -1,  1, 1,
        };
        // clang-format on
        gl->genBuffers(1, &mVertexBuffer);
        sm->bindBuffer(GL_ARRAY_BUFFER, mVertexBuffer);
        gl->bufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);

        // window border triangle strip
        const GLuint borderStrip[] = {5, 0, 4, 2, 6, 3, 7, 1, 5, 0};

        gl->genBuffers(1, &mIndexBuffer);
        sm->bindBuffer(GL_ELEMENT_ARRAY_BUFFER, mIndexBuffer);
        gl->bufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(borderStrip), borderStrip, GL_STATIC_DRAW);
    }
    else
    {
        sm->useProgram(mProgram);
        sm->bindBuffer(GL_ARRAY_BUFFER, mVertexBuffer);
        sm->bindBuffer(GL_ELEMENT_ARRAY_BUFFER, mIndexBuffer);
    }

    // convert from pixels to "-1 to 1" space
    const NativeWindow *n = buffer->getNative();
    double x              = n->x * 2. / mWidth - 1;
    double y              = n->y * 2. / mHeight - 1;
    double halfw          = n->width * 1. / mWidth;
    double halfh          = n->height * 1. / mHeight;
    double borderw        = n->borderWidth * 2. / mWidth;
    double borderh        = n->borderHeight * 2. / mHeight;

    gl->uniform2f(mCenterUniform, x + halfw, y + halfh);
    gl->uniform2f(mWindowSizeUniform, halfw, halfh);
    gl->uniform2f(mBorderSizeUniform, borderw, borderh);
    gl->uniform1f(mDepthUniform, n->depth / 1e6);

    sm->setBlendEnabled(false);
    sm->setCullFaceEnabled(false);
    sm->setStencilTestEnabled(false);
    sm->setScissorTestEnabled(false);
    sm->setDepthTestEnabled(true);
    sm->setColorMask(true, true, true, true);
    sm->setDepthMask(true);
    sm->setDepthRange(0, 1);
    sm->setDepthFunc(GL_LESS);
    sm->setViewport(gl::Rectangle(0, 0, mWidth, mHeight));
    sm->activeTexture(0);
    GLuint tex = buffer->getTexture();
    sm->bindTexture(GL_TEXTURE_2D, tex);
    gl->vertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, 0);
    gl->enableVertexAttribArray(0);
    sm->bindFramebuffer(GL_DRAW_FRAMEBUFFER, mDrawing->getGLFB());
    gl->drawArrays(GL_TRIANGLE_STRIP, 0, 4);
    gl->drawElements(GL_TRIANGLE_STRIP, 10, GL_UNSIGNED_INT, 0);
    sm->deleteTexture(tex);
}

void DisplayOzone::drawBuffer(Buffer *buffer)
{
    if (!mDrawing)
    {
        // get buffer on which to draw window
        if (mUnused)
        {
            mDrawing = mUnused;
            mUnused  = nullptr;
        }
        else
        {
            mDrawing = new Buffer(this, GBM_BO_USE_RENDERING | GBM_BO_USE_SCANOUT,
                                  GBM_FORMAT_ARGB8888, DRM_FORMAT_ARGB8888, DRM_FORMAT_XRGB8888,
                                  true, true);  // XXX shouldn't need stencil
            if (!mDrawing || !mDrawing->initialize(mWidth, mHeight))
            {
                return;
            }
        }

        StateManagerGL *sm = getRenderer()->getStateManager();
        sm->bindFramebuffer(GL_DRAW_FRAMEBUFFER, mDrawing->getGLFB());
        sm->setClearColor(gl::ColorF(0, 0, 0, 1));
        sm->setClearDepth(1);
        sm->setScissorTestEnabled(false);
        sm->setColorMask(true, true, true, true);
        sm->setDepthMask(true);
        mFunctionsGL->clear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    }

    drawWithTexture(buffer);
    presentScreen();
}

void DisplayOzone::flushGL()
{
    mFunctionsGL->flush();
    if (mEGL->hasExtension("EGL_KHR_fence_sync"))
    {
        const EGLint attrib[] = {EGL_SYNC_CONDITION_KHR,
                                 EGL_SYNC_PRIOR_COMMANDS_IMPLICIT_EXTERNAL_ARM, EGL_NONE};
        EGLSyncKHR fence = mEGL->createSyncKHR(EGL_SYNC_FENCE_KHR, attrib);
        if (fence)
        {
            // TODO(fjhenigman) Figure out the right way to use fences on Mali GPU
            // to maximize throughput and avoid hangs when a program is interrupted.
            // This busy wait was an attempt to reduce hangs when interrupted by SIGINT,
            // but we still get some.
            for (;;)
            {
                EGLint r = mEGL->clientWaitSyncKHR(fence, EGL_SYNC_FLUSH_COMMANDS_BIT_KHR, 0);
                if (r != EGL_TIMEOUT_EXPIRED_KHR)
                {
                    break;
                }
                usleep(99);
            }
            mEGL->destroySyncKHR(fence);
            return;
        }
    }
}

void DisplayOzone::terminate()
{
    SafeDelete(mScanning);
    SafeDelete(mPending);
    SafeDelete(mDrawing);
    SafeDelete(mUnused);

    if (mProgram)
    {
        mFunctionsGL->deleteProgram(mProgram);
        mFunctionsGL->deleteShader(mVertexShader);
        mFunctionsGL->deleteShader(mFragmentShader);
        mFunctionsGL->deleteBuffers(1, &mVertexBuffer);
        mFunctionsGL->deleteBuffers(1, &mIndexBuffer);
        mProgram = 0;
    }

    DisplayGL::terminate();

    if (mContext)
    {
        // Mesa might crash if you terminate EGL with a context current
        // then re-initialize EGL, so make our context not current.
        mEGL->makeCurrent(EGL_NO_SURFACE, EGL_NO_CONTEXT);
        mEGL->destroyContext(mContext);
        mContext = nullptr;
    }

    SafeDelete(mFunctionsGL);

    if (mEGL)
    {
        mEGL->terminate();
        SafeDelete(mEGL);
    }

    drmModeFreeCrtc(mCRTC);

    if (mGBM)
    {
        int fd = gbm_device_get_fd(mGBM);
        gbm_device_destroy(mGBM);
        mGBM = nullptr;
        close(fd);
    }
}

SurfaceImpl *DisplayOzone::createWindowSurface(const egl::SurfaceState &state,
                                               const egl::Config *configuration,
                                               EGLNativeWindowType window,
                                               const egl::AttributeMap &attribs)
{
    Buffer *buffer = new Buffer(this, GBM_BO_USE_RENDERING, GBM_FORMAT_ARGB8888,
                                DRM_FORMAT_ARGB8888, DRM_FORMAT_XRGB8888, true, true);
    if (!buffer || !buffer->initialize(reinterpret_cast<const NativeWindow *>(window)))
    {
        return nullptr;
    }
    return new SurfaceOzone(state, getRenderer(), buffer);
}

SurfaceImpl *DisplayOzone::createPbufferSurface(const egl::SurfaceState &state,
                                                const egl::Config *configuration,
                                                const egl::AttributeMap &attribs)
{
    EGLAttrib width  = attribs.get(EGL_WIDTH, 0);
    EGLAttrib height = attribs.get(EGL_HEIGHT, 0);
    Buffer *buffer = new Buffer(this, GBM_BO_USE_RENDERING, GBM_FORMAT_ARGB8888,
                                DRM_FORMAT_ARGB8888, DRM_FORMAT_XRGB8888, true, true);
    if (!buffer || !buffer->initialize(width, height))
    {
        return nullptr;
    }
    return new SurfaceOzone(state, getRenderer(), buffer);
}

SurfaceImpl *DisplayOzone::createPbufferFromClientBuffer(const egl::SurfaceState &state,
                                                         const egl::Config *configuration,
                                                         EGLenum buftype,
                                                         EGLClientBuffer clientBuffer,
                                                         const egl::AttributeMap &attribs)
{
    UNIMPLEMENTED();
    return nullptr;
}

SurfaceImpl *DisplayOzone::createPixmapSurface(const egl::SurfaceState &state,
                                               const egl::Config *configuration,
                                               NativePixmapType nativePixmap,
                                               const egl::AttributeMap &attribs)
{
    UNIMPLEMENTED();
    return nullptr;
}

egl::Error DisplayOzone::getDevice(DeviceImpl **device)
{
    UNIMPLEMENTED();
    return egl::Error(EGL_BAD_DISPLAY);
}

egl::ConfigSet DisplayOzone::generateConfigs()
{
    egl::ConfigSet configs;

    egl::Config config;
    config.redSize           = 8;
    config.greenSize         = 8;
    config.blueSize          = 8;
    config.alphaSize         = 8;
    config.depthSize         = 24;
    config.stencilSize       = 8;
    config.bindToTextureRGBA = EGL_TRUE;
    config.renderableType    = EGL_OPENGL_ES2_BIT;
    config.surfaceType       = EGL_WINDOW_BIT | EGL_PBUFFER_BIT;

    configs.add(config);
    return configs;
}

bool DisplayOzone::testDeviceLost()
{
    return false;
}

egl::Error DisplayOzone::restoreLostDevice()
{
    UNIMPLEMENTED();
    return egl::Error(EGL_BAD_DISPLAY);
}

bool DisplayOzone::isValidNativeWindow(EGLNativeWindowType window) const
{
    return true;
}

egl::Error DisplayOzone::getDriverVersion(std::string *version) const
{
    *version = "";
    return egl::Error(EGL_SUCCESS);
}

egl::Error DisplayOzone::waitClient() const
{
    // TODO(fjhenigman) Implement this.
    return egl::Error(EGL_SUCCESS);
}

egl::Error DisplayOzone::waitNative(EGLint engine,
                                    egl::Surface *drawSurface,
                                    egl::Surface *readSurface) const
{
    // TODO(fjhenigman) Implement this.
    return egl::Error(EGL_SUCCESS);
}

void DisplayOzone::setSwapInterval(EGLSurface drawable, SwapControlData *data)
{
    ASSERT(data != nullptr);
}

}  // namespace rx
