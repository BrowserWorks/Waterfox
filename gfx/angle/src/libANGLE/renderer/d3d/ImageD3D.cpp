//
// Copyright (c) 2002-2015 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//

// Image.h: Implements the rx::Image class, an abstract base class for the
// renderer-specific classes which will define the interface to the underlying
// surfaces or resources.

#include "libANGLE/renderer/d3d/ImageD3D.h"

#include "libANGLE/formatutils.h"
#include "libANGLE/Framebuffer.h"
#include "libANGLE/FramebufferAttachment.h"
#include "libANGLE/renderer/d3d/FramebufferD3D.h"
#include "libANGLE/renderer/d3d/RenderTargetD3D.h"

namespace rx
{

ImageD3D::ImageD3D()
    : mWidth(0),
      mHeight(0),
      mDepth(0),
      mInternalFormat(GL_NONE),
      mRenderable(false),
      mTarget(GL_NONE),
      mDirty(false)
{
}

GLenum
ImageD3D::getSizedInputFormat(GLenum inputType) const
{
    const auto &internalFormat = gl::GetInternalFormatInfo(mInternalFormat);
    const auto &unsizedInternalFormat = internalFormat.format;
    const auto &sizedInputFormat = gl::GetSizedInternalFormat(unsizedInternalFormat, inputType);
    return sizedInputFormat;
}

}  // namespace rx
