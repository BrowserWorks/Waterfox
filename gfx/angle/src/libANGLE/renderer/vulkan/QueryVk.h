//
// Copyright 2016 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// QueryVk.h:
//    Defines the class interface for QueryVk, implementing QueryImpl.
//

#ifndef LIBANGLE_RENDERER_VULKAN_QUERYVK_H_
#define LIBANGLE_RENDERER_VULKAN_QUERYVK_H_

#include "libANGLE/renderer/QueryImpl.h"

namespace rx
{

class QueryVk : public QueryImpl
{
  public:
    QueryVk(GLenum type);
    ~QueryVk() override;

    gl::Error begin() override;
    gl::Error end() override;
    gl::Error queryCounter() override;
    gl::Error getResult(GLint *params) override;
    gl::Error getResult(GLuint *params) override;
    gl::Error getResult(GLint64 *params) override;
    gl::Error getResult(GLuint64 *params) override;
    gl::Error isResultAvailable(bool *available) override;
};

}  // namespace rx

#endif  // LIBANGLE_RENDERER_VULKAN_QUERYVK_H_
