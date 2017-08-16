//
// Copyright 2016 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// RenderbufferVk.h:
//    Defines the class interface for RenderbufferVk, implementing RenderbufferImpl.
//

#ifndef LIBANGLE_RENDERER_VULKAN_RENDERBUFFERVK_H_
#define LIBANGLE_RENDERER_VULKAN_RENDERBUFFERVK_H_

#include "libANGLE/renderer/RenderbufferImpl.h"

namespace rx
{

class RenderbufferVk : public RenderbufferImpl
{
  public:
    RenderbufferVk();
    ~RenderbufferVk() override;

    gl::Error setStorage(GLenum internalformat, size_t width, size_t height) override;
    gl::Error setStorageMultisample(size_t samples,
                                    GLenum internalformat,
                                    size_t width,
                                    size_t height) override;
    gl::Error setStorageEGLImageTarget(egl::Image *image) override;

    gl::Error getAttachmentRenderTarget(const gl::FramebufferAttachment::Target &target,
                                        FramebufferAttachmentRenderTarget **rtOut) override;
};

}  // namespace rx

#endif  // LIBANGLE_RENDERER_VULKAN_RENDERBUFFERVK_H_
