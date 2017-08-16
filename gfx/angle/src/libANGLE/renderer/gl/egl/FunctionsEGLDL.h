//
// Copyright (c) 2016 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//

// FunctionsEGL.h: Implements FunctionsEGL with dlopen/dlsym/dlclose

#ifndef LIBANGLE_RENDERER_GL_CROS_FUNCTIONSEGLDL_H_
#define LIBANGLE_RENDERER_GL_CROS_FUNCTIONSEGLDL_H_

#include "libANGLE/renderer/gl/egl/FunctionsEGL.h"
#include "libANGLE/renderer/gl/egl/functionsegl_typedefs.h"

namespace rx
{

class DynamicLib final
{
  public:
    void *handle;

    DynamicLib();
    ~DynamicLib();
};

class FunctionsEGLDL : public FunctionsEGL
{
  public:
    FunctionsEGLDL();
    ~FunctionsEGLDL() override;

    egl::Error initialize(EGLNativeDisplayType nativeDisplay, const char *libName);
    void *getProcAddress(const char *name) const override;

  private:
    PFNEGLGETPROCADDRESSPROC mGetProcAddressPtr;
    static DynamicLib sNativeLib;
};
}  // namespace rx

#endif  // LIBANGLE_RENDERER_GL_CROS_FUNCTIONSEGLDL_H_
