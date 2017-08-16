//
// Copyright 2016 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// DisplayNULL.cpp:
//    Implements the class methods for DisplayNULL.
//

#include "libANGLE/renderer/null/DisplayNULL.h"

#include "common/debug.h"

#include "libANGLE/renderer/null/ContextNULL.h"
#include "libANGLE/renderer/null/DeviceNULL.h"
#include "libANGLE/renderer/null/ImageNULL.h"
#include "libANGLE/renderer/null/SurfaceNULL.h"

namespace rx
{

DisplayNULL::DisplayNULL() : DisplayImpl(), mDevice(nullptr)
{
}

DisplayNULL::~DisplayNULL()
{
}

egl::Error DisplayNULL::initialize(egl::Display *display)
{
    mDevice = new DeviceNULL();
    return egl::NoError();
}

void DisplayNULL::terminate()
{
    SafeDelete(mDevice);
}

egl::Error DisplayNULL::makeCurrent(egl::Surface *drawSurface,
                                    egl::Surface *readSurface,
                                    gl::Context *context)
{
    return egl::NoError();
}

egl::ConfigSet DisplayNULL::generateConfigs()
{
    egl::Config config;
    config.renderTargetFormat    = GL_RGBA8;
    config.depthStencilFormat    = GL_DEPTH24_STENCIL8;
    config.bufferSize            = 32;
    config.redSize               = 8;
    config.greenSize             = 8;
    config.blueSize              = 8;
    config.alphaSize             = 8;
    config.alphaMaskSize         = 0;
    config.bindToTextureRGB      = EGL_TRUE;
    config.bindToTextureRGBA     = EGL_TRUE;
    config.colorBufferType       = EGL_RGB_BUFFER;
    config.configCaveat          = EGL_NONE;
    config.conformant            = EGL_OPENGL_ES2_BIT | EGL_OPENGL_ES3_BIT;
    config.depthSize             = 24;
    config.level                 = 0;
    config.matchNativePixmap     = EGL_NONE;
    config.maxPBufferWidth       = 0;
    config.maxPBufferHeight      = 0;
    config.maxPBufferPixels      = 0;
    config.maxSwapInterval       = 1;
    config.minSwapInterval       = 1;
    config.nativeRenderable      = EGL_TRUE;
    config.nativeVisualID        = 0;
    config.nativeVisualType      = EGL_NONE;
    config.renderableType        = EGL_OPENGL_ES2_BIT | EGL_OPENGL_ES3_BIT;
    config.sampleBuffers         = 0;
    config.samples               = 0;
    config.stencilSize           = 8;
    config.surfaceType           = EGL_WINDOW_BIT | EGL_PBUFFER_BIT;
    config.optimalOrientation    = 0;
    config.transparentType       = EGL_NONE;
    config.transparentRedValue   = 0;
    config.transparentGreenValue = 0;
    config.transparentBlueValue  = 0;

    egl::ConfigSet configSet;
    configSet.add(config);
    return configSet;
}

bool DisplayNULL::testDeviceLost()
{
    return false;
}

egl::Error DisplayNULL::restoreLostDevice()
{
    return egl::NoError();
}

bool DisplayNULL::isValidNativeWindow(EGLNativeWindowType window) const
{
    return true;
}

std::string DisplayNULL::getVendorString() const
{
    return "NULL";
}

egl::Error DisplayNULL::getDevice(DeviceImpl **device)
{
    *device = mDevice;
    return egl::NoError();
}

egl::Error DisplayNULL::waitClient() const
{
    return egl::NoError();
}

egl::Error DisplayNULL::waitNative(EGLint engine,
                                   egl::Surface *drawSurface,
                                   egl::Surface *readSurface) const
{
    return egl::NoError();
}

gl::Version DisplayNULL::getMaxSupportedESVersion() const
{
    return gl::Version(3, 2);
}

SurfaceImpl *DisplayNULL::createWindowSurface(const egl::SurfaceState &state,
                                              const egl::Config *configuration,
                                              EGLNativeWindowType window,
                                              const egl::AttributeMap &attribs)
{
    return new SurfaceNULL(state);
}

SurfaceImpl *DisplayNULL::createPbufferSurface(const egl::SurfaceState &state,
                                               const egl::Config *configuration,
                                               const egl::AttributeMap &attribs)
{
    return new SurfaceNULL(state);
}

SurfaceImpl *DisplayNULL::createPbufferFromClientBuffer(const egl::SurfaceState &state,
                                                        const egl::Config *configuration,
                                                        EGLenum buftype,
                                                        EGLClientBuffer buffer,
                                                        const egl::AttributeMap &attribs)
{
    return new SurfaceNULL(state);
}

SurfaceImpl *DisplayNULL::createPixmapSurface(const egl::SurfaceState &state,
                                              const egl::Config *configuration,
                                              NativePixmapType nativePixmap,
                                              const egl::AttributeMap &attribs)
{
    return new SurfaceNULL(state);
}

ImageImpl *DisplayNULL::createImage(EGLenum target,
                                    egl::ImageSibling *buffer,
                                    const egl::AttributeMap &attribs)
{
    return new ImageNULL();
}

ContextImpl *DisplayNULL::createContext(const gl::ContextState &state)
{
    return new ContextNULL(state);
}

StreamProducerImpl *DisplayNULL::createStreamProducerD3DTextureNV12(
    egl::Stream::ConsumerType consumerType,
    const egl::AttributeMap &attribs)
{
    UNIMPLEMENTED();
    return nullptr;
}

void DisplayNULL::generateExtensions(egl::DisplayExtensions *outExtensions) const
{
    outExtensions->createContextRobustness            = true;
    outExtensions->postSubBuffer                      = true;
    outExtensions->createContext                      = true;
    outExtensions->deviceQuery                        = true;
    outExtensions->image                              = true;
    outExtensions->imageBase                          = true;
    outExtensions->glTexture2DImage                   = true;
    outExtensions->glTextureCubemapImage              = true;
    outExtensions->glTexture3DImage                   = true;
    outExtensions->glRenderbufferImage                = true;
    outExtensions->getAllProcAddresses                = true;
    outExtensions->flexibleSurfaceCompatibility       = true;
    outExtensions->directComposition                  = true;
    outExtensions->createContextNoError               = true;
    outExtensions->createContextWebGLCompatibility    = true;
    outExtensions->createContextBindGeneratesResource = true;
    outExtensions->swapBuffersWithDamage              = true;
}

void DisplayNULL::generateCaps(egl::Caps *outCaps) const
{
    outCaps->textureNPOT = true;
}

}  // namespace rx
