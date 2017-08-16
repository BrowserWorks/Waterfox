//
// Copyright (c) 2014 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//

// DisplayD3D.h: D3D implementation of egl::Display

#ifndef LIBANGLE_RENDERER_D3D_DISPLAYD3D_H_
#define LIBANGLE_RENDERER_D3D_DISPLAYD3D_H_

#include "libANGLE/renderer/DisplayImpl.h"
#include "libANGLE/Device.h"

namespace rx
{
class RendererD3D;

class DisplayD3D : public DisplayImpl
{
  public:
    DisplayD3D();

    egl::Error initialize(egl::Display *display) override;
    virtual void terminate() override;

    // Surface creation
    SurfaceImpl *createWindowSurface(const egl::SurfaceState &state,
                                     const egl::Config *configuration,
                                     EGLNativeWindowType window,
                                     const egl::AttributeMap &attribs) override;
    SurfaceImpl *createPbufferSurface(const egl::SurfaceState &state,
                                      const egl::Config *configuration,
                                      const egl::AttributeMap &attribs) override;
    SurfaceImpl *createPbufferFromClientBuffer(const egl::SurfaceState &state,
                                               const egl::Config *configuration,
                                               EGLenum buftype,
                                               EGLClientBuffer clientBuffer,
                                               const egl::AttributeMap &attribs) override;
    SurfaceImpl *createPixmapSurface(const egl::SurfaceState &state,
                                     const egl::Config *configuration,
                                     NativePixmapType nativePixmap,
                                     const egl::AttributeMap &attribs) override;

    ImageImpl *createImage(EGLenum target,
                           egl::ImageSibling *buffer,
                           const egl::AttributeMap &attribs) override;

    ContextImpl *createContext(const gl::ContextState &state) override;

    StreamProducerImpl *createStreamProducerD3DTextureNV12(
        egl::Stream::ConsumerType consumerType,
        const egl::AttributeMap &attribs) override;

    egl::Error makeCurrent(egl::Surface *drawSurface, egl::Surface *readSurface, gl::Context *context) override;

    egl::ConfigSet generateConfigs() override;

    bool testDeviceLost() override;
    egl::Error restoreLostDevice() override;

    bool isValidNativeWindow(EGLNativeWindowType window) const override;
    egl::Error validateClientBuffer(const egl::Config *configuration,
                                    EGLenum buftype,
                                    EGLClientBuffer clientBuffer,
                                    const egl::AttributeMap &attribs) const override;

    egl::Error getDevice(DeviceImpl **device) override;

    std::string getVendorString() const override;

    egl::Error waitClient() const override;
    egl::Error waitNative(EGLint engine,
                          egl::Surface *drawSurface,
                          egl::Surface *readSurface) const override;
    gl::Version getMaxSupportedESVersion() const override;

  private:
    void generateExtensions(egl::DisplayExtensions *outExtensions) const override;
    void generateCaps(egl::Caps *outCaps) const override;

    egl::Display *mDisplay;

    rx::RendererD3D *mRenderer;
};

}

#endif // LIBANGLE_RENDERER_D3D_DISPLAYD3D_H_
