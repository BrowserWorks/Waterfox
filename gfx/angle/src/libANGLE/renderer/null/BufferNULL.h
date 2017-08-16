//
// Copyright 2016 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// BufferNULL.h:
//    Defines the class interface for BufferNULL, implementing BufferImpl.
//

#ifndef LIBANGLE_RENDERER_NULL_BUFFERNULL_H_
#define LIBANGLE_RENDERER_NULL_BUFFERNULL_H_

#include "libANGLE/renderer/BufferImpl.h"

namespace rx
{

class BufferNULL : public BufferImpl
{
  public:
    BufferNULL(const gl::BufferState &state);
    ~BufferNULL() override;

    gl::Error setData(GLenum target, const void *data, size_t size, GLenum usage) override;
    gl::Error setSubData(GLenum target, const void *data, size_t size, size_t offset) override;
    gl::Error copySubData(BufferImpl *source,
                          GLintptr sourceOffset,
                          GLintptr destOffset,
                          GLsizeiptr size) override;
    gl::Error map(GLenum access, GLvoid **mapPtr) override;
    gl::Error mapRange(size_t offset, size_t length, GLbitfield access, GLvoid **mapPtr) override;
    gl::Error unmap(GLboolean *result) override;

    gl::Error getIndexRange(GLenum type,
                            size_t offset,
                            size_t count,
                            bool primitiveRestartEnabled,
                            gl::IndexRange *outRange) override;

  private:
    std::vector<uint8_t> mData;
};

}  // namespace rx

#endif  // LIBANGLE_RENDERER_NULL_BUFFERNULL_H_
