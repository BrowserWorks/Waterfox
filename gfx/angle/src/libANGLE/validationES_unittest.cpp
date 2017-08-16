//
// Copyright 2015 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// validationES unit tests:
//   Unit tests for general ES validation functions.
//

#include <gmock/gmock.h>
#include <gtest/gtest.h>

#include "libANGLE/ContextState.h"
#include "libANGLE/renderer/FramebufferImpl_mock.h"
#include "libANGLE/renderer/ProgramImpl_mock.h"
#include "libANGLE/renderer/TextureImpl_mock.h"
#include "libANGLE/validationES.h"
#include "tests/angle_unittests_utils.h"

using namespace gl;
using namespace rx;
using testing::_;
using testing::NiceMock;
using testing::Return;

namespace
{

class MockValidationContext : public ValidationContext
{
  public:
    MockValidationContext(const Version &version,
                          State *state,
                          const Caps &caps,
                          const TextureCapsMap &textureCaps,
                          const Extensions &extensions,
                          const ResourceManager *resourceManager,
                          const Limitations &limitations,
                          const ResourceMap<Framebuffer> &framebufferMap,
                          bool skipValidation);

    MOCK_METHOD1(handleError, void(const Error &));
};

MockValidationContext::MockValidationContext(const Version &version,
                                             State *state,
                                             const Caps &caps,
                                             const TextureCapsMap &textureCaps,
                                             const Extensions &extensions,
                                             const ResourceManager *resourceManager,
                                             const Limitations &limitations,
                                             const ResourceMap<Framebuffer> &framebufferMap,
                                             bool skipValidation)
    : ValidationContext(version,
                        state,
                        caps,
                        textureCaps,
                        extensions,
                        resourceManager,
                        limitations,
                        framebufferMap,
                        skipValidation)
{
}

// Test that ANGLE generates an INVALID_OPERATION when validating index data that uses a value
// larger than MAX_ELEMENT_INDEX. Not specified in the GLES 3 spec, it's undefined behaviour,
// but we want a test to ensure we maintain this behaviour.
TEST(ValidationESTest, DrawElementsWithMaxIndexGivesError)
{
    auto framebufferImpl = MakeFramebufferMock();
    auto programImpl     = MakeProgramMock();

    // TODO(jmadill): Generalize some of this code so we can re-use it for other tests.
    NiceMock<MockGLFactory> mockFactory;
    EXPECT_CALL(mockFactory, createFramebuffer(_)).WillOnce(Return(framebufferImpl));
    EXPECT_CALL(mockFactory, createProgram(_)).WillOnce(Return(programImpl));
    EXPECT_CALL(mockFactory, createVertexArray(_)).WillOnce(Return(nullptr));

    State state;
    Caps caps;
    TextureCapsMap textureCaps;
    Extensions extensions;
    Limitations limitations;
    ResourceMap<Framebuffer> framebufferMap;

    // Set some basic caps.
    caps.maxElementIndex     = 100;
    caps.maxDrawBuffers      = 1;
    caps.maxColorAttachments = 1;
    state.initialize(caps, extensions, Version(3, 0), false, true);

    NiceMock<MockTextureImpl> *textureImpl = new NiceMock<MockTextureImpl>();
    EXPECT_CALL(mockFactory, createTexture(_)).WillOnce(Return(textureImpl));
    EXPECT_CALL(*textureImpl, setStorage(_, _, _, _)).WillOnce(Return(Error(GL_NO_ERROR)));
    EXPECT_CALL(*textureImpl, destructor()).Times(1).RetiresOnSaturation();

    Texture *texture = new Texture(&mockFactory, 0, GL_TEXTURE_2D);
    texture->addRef();
    texture->setStorage(GL_TEXTURE_2D, 1, GL_RGBA8, Extents(1, 1, 0));

    VertexArray *vertexArray = new VertexArray(&mockFactory, 0, 1);
    Framebuffer *framebuffer = new Framebuffer(caps, &mockFactory, 1);
    framebuffer->setAttachment(GL_FRAMEBUFFER_DEFAULT, GL_BACK, ImageIndex::Make2D(0), texture);

    Program *program = new Program(&mockFactory, nullptr, 1);

    state.setVertexArrayBinding(vertexArray);
    state.setDrawFramebufferBinding(framebuffer);
    state.setProgram(program);

    NiceMock<MockValidationContext> testContext(Version(3, 0), &state, caps, textureCaps,
                                                extensions, nullptr, limitations, framebufferMap,
                                                false);

    // Set the expectation for the validation error here.
    Error expectedError(GL_INVALID_OPERATION, g_ExceedsMaxElementErrorMessage);
    EXPECT_CALL(testContext, handleError(expectedError)).Times(1);

    // Call once with maximum index, and once with an excessive index.
    GLuint indexData[] = {0, 1, static_cast<GLuint>(caps.maxElementIndex - 1),
                          3, 4, static_cast<GLuint>(caps.maxElementIndex)};
    IndexRange indexRange;
    EXPECT_TRUE(ValidateDrawElements(&testContext, GL_TRIANGLES, 3, GL_UNSIGNED_INT, indexData, 1,
                                     &indexRange));
    EXPECT_FALSE(ValidateDrawElements(&testContext, GL_TRIANGLES, 6, GL_UNSIGNED_INT, indexData, 2,
                                      &indexRange));

    texture->release();

    state.setVertexArrayBinding(nullptr);
    state.setDrawFramebufferBinding(nullptr);
    state.setProgram(nullptr);

    SafeDelete(vertexArray);
    SafeDelete(framebuffer);
    SafeDelete(program);
}

}  // anonymous namespace
