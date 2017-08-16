//
// Copyright 2015 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// IndexDataManagerPerfTest:
//   Performance test for index buffer management.
//

#include "ANGLEPerfTest.h"

#include <gmock/gmock.h>

#include "angle_unittests_utils.h"
#include "libANGLE/renderer/d3d/BufferD3D.h"
#include "libANGLE/renderer/d3d/IndexBuffer.h"
#include "libANGLE/renderer/d3d/IndexDataManager.h"

using namespace testing;

namespace
{

class MockIndexBuffer : public rx::IndexBuffer
{
  public:
    MockIndexBuffer(unsigned int bufferSize, GLenum indexType)
        : mBufferSize(bufferSize),
          mIndexType(indexType)
    {
    }

    MOCK_METHOD3(initialize, gl::Error(unsigned int, GLenum, bool));
    MOCK_METHOD3(mapBuffer, gl::Error(unsigned int, unsigned int, void**));
    MOCK_METHOD0(unmapBuffer, gl::Error());
    MOCK_METHOD0(discard, gl::Error());
    MOCK_METHOD2(setSize, gl::Error(unsigned int, GLenum));

    // inlined for speed
    GLenum getIndexType() const override { return mIndexType; }
    unsigned int getBufferSize() const override { return mBufferSize; }

  private:
    unsigned int mBufferSize;
    GLenum mIndexType;
};

class MockBufferFactoryD3D : public rx::BufferFactoryD3D
{
  public:
    MockBufferFactoryD3D(unsigned int bufferSize, GLenum indexType)
        : mBufferSize(bufferSize),
          mIndexType(indexType)
    {
    }

    MOCK_METHOD0(createVertexBuffer, rx::VertexBuffer*());
    MOCK_CONST_METHOD1(getVertexConversionType, rx::VertexConversionType(gl::VertexFormatType));
    MOCK_CONST_METHOD1(getVertexComponentType, GLenum(gl::VertexFormatType));
    MOCK_CONST_METHOD3(getVertexSpaceRequired,
                       gl::ErrorOrResult<unsigned int>(const gl::VertexAttribute &,
                                                       GLsizei,
                                                       GLsizei));

    // Dependency injection
    rx::IndexBuffer* createIndexBuffer() override
    {
        return new MockIndexBuffer(mBufferSize, mIndexType);
    }

  private:
    unsigned int mBufferSize;
    GLenum mIndexType;
};

class MockBufferD3D : public rx::BufferD3D
{
  public:
    MockBufferD3D(rx::BufferFactoryD3D *factory) : BufferD3D(mockState, factory), mData() {}

    // BufferImpl
    gl::Error setData(GLenum target, const void *data, size_t size, GLenum) override
    {
        mData.resize(size);
        if (data && size > 0)
        {
            memcpy(&mData[0], data, size);
        }
        return gl::Error(GL_NO_ERROR);
    }

    MOCK_METHOD4(setSubData, gl::Error(GLenum, const void *, size_t, size_t));
    MOCK_METHOD4(copySubData, gl::Error(BufferImpl*, GLintptr, GLintptr, GLsizeiptr));
    MOCK_METHOD2(map, gl::Error(GLenum, GLvoid **));
    MOCK_METHOD4(mapRange, gl::Error(size_t, size_t, GLbitfield, GLvoid **));
    MOCK_METHOD1(unmap, gl::Error(GLboolean *));

    // BufferD3D
    MOCK_METHOD0(markTransformFeedbackUsage, gl::Error());

    // inlined for speed
    bool supportsDirectBinding() const override { return false; }
    size_t getSize() const override { return mData.size(); }

    gl::Error getData(const uint8_t **outData) override
    {
        *outData = &mData[0];
        return gl::Error(GL_NO_ERROR);
    }

  private:
    gl::BufferState mockState;
    std::vector<uint8_t> mData;
};

class MockGLFactoryD3D : public rx::MockGLFactory
{
  public:
    MockGLFactoryD3D(MockBufferFactoryD3D *bufferFactory) : mBufferFactory(bufferFactory) {}

    rx::BufferImpl *createBuffer(const gl::BufferState &state) override
    {
        MockBufferD3D *mockBufferD3D = new MockBufferD3D(mBufferFactory);

        EXPECT_CALL(*mBufferFactory, createVertexBuffer())
            .WillOnce(Return(nullptr))
            .RetiresOnSaturation();
        mockBufferD3D->initializeStaticData();

        return mockBufferD3D;
    }

    MockBufferFactoryD3D *mBufferFactory;
};

class IndexDataManagerPerfTest : public ANGLEPerfTest
{
  public:
    IndexDataManagerPerfTest();

    void step() override;

    rx::IndexDataManager mIndexDataManager;
    GLsizei mIndexCount;
    unsigned int mBufferSize;
    MockBufferFactoryD3D mMockBufferFactory;
    MockGLFactoryD3D mMockGLFactory;
    gl::Buffer mIndexBuffer;
};

IndexDataManagerPerfTest::IndexDataManagerPerfTest()
    : ANGLEPerfTest("IndexDataManger", "_run"),
      mIndexDataManager(&mMockBufferFactory, rx::RENDERER_D3D11),
      mIndexCount(4000),
      mBufferSize(mIndexCount * sizeof(GLushort)),
      mMockBufferFactory(mBufferSize, GL_UNSIGNED_SHORT),
      mMockGLFactory(&mMockBufferFactory),
      mIndexBuffer(&mMockGLFactory, 1)
{
    std::vector<GLushort> indexData(mIndexCount);
    for (GLsizei index = 0; index < mIndexCount; ++index)
    {
        indexData[index] = static_cast<GLushort>(index);
    }
    mIndexBuffer.bufferData(GL_ARRAY_BUFFER, &indexData[0], indexData.size() * sizeof(GLushort),
                            GL_STATIC_DRAW);
}

void IndexDataManagerPerfTest::step()
{
    rx::TranslatedIndexData translatedIndexData;
    for (unsigned int iteration = 0; iteration < 100; ++iteration)
    {
        mIndexBuffer.getIndexRange(GL_UNSIGNED_SHORT, 0, mIndexCount, false,
                                   &translatedIndexData.indexRange);
        mIndexDataManager.prepareIndexData(GL_UNSIGNED_SHORT, mIndexCount, &mIndexBuffer, nullptr,
                                           &translatedIndexData, false);
    }
}

TEST_F(IndexDataManagerPerfTest, Run)
{
    run();
}

}  // anonymous namespace
