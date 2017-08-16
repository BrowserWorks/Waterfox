//
// Copyright (c) 2012 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//

// VertexBuffer11.h: Defines the D3D11 VertexBuffer implementation.

#ifndef LIBANGLE_RENDERER_D3D_D3D11_VERTEXBUFFER11_H_
#define LIBANGLE_RENDERER_D3D_D3D11_VERTEXBUFFER11_H_

#include <stdint.h>

#include "libANGLE/renderer/d3d/VertexBuffer.h"

namespace rx
{
class Renderer11;

class VertexBuffer11 : public VertexBuffer
{
  public:
    explicit VertexBuffer11(Renderer11 *const renderer);

    gl::Error initialize(unsigned int size, bool dynamicUsage) override;

    gl::Error storeVertexAttributes(const gl::VertexAttribute &attrib,
                                    GLenum currentValueType,
                                    GLint start,
                                    GLsizei count,
                                    GLsizei instances,
                                    unsigned int offset,
                                    const uint8_t *sourceData) override;

    unsigned int getBufferSize() const override;
    gl::Error setBufferSize(unsigned int size) override;
    gl::Error discard() override;

    void hintUnmapResource() override;

    ID3D11Buffer *getBuffer() const;

  private:
    ~VertexBuffer11() override;
    gl::Error mapResource();

    Renderer11 *const mRenderer;

    ID3D11Buffer *mBuffer;
    unsigned int mBufferSize;
    bool mDynamicUsage;

    uint8_t *mMappedResourceData;
};

}  // namespace rx

#endif // LIBANGLE_RENDERER_D3D_D3D11_VERTEXBUFFER11_H_
