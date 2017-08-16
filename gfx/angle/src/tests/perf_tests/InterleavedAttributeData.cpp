//
// Copyright (c) 2014 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// InterleavedAttributeData:
//   Performance test for draws using interleaved attribute data in vertex buffers.
//

#include <sstream>

#include "ANGLEPerfTest.h"
#include "shader_utils.h"

using namespace angle;

namespace
{

struct InterleavedAttributeDataParams final : public RenderTestParams
{
    InterleavedAttributeDataParams()
    {
        // Common default values
        majorVersion = 2;
        minorVersion = 0;
        windowWidth  = 512;
        windowHeight = 512;
        numSprites   = 3000;
    }

    // static parameters
    unsigned int numSprites;
};

std::ostream &operator<<(std::ostream &os, const InterleavedAttributeDataParams &params)
{
    os << params.suffix().substr(1);

    if (params.eglParameters.majorVersion != EGL_DONT_CARE)
    {
        os << "_" << params.eglParameters.majorVersion << "_" << params.eglParameters.minorVersion;
    }

    return os;
}

class InterleavedAttributeDataBenchmark
    : public ANGLERenderTest,
      public ::testing::WithParamInterface<InterleavedAttributeDataParams>
{
  public:
    InterleavedAttributeDataBenchmark();

    void initializeBenchmark() override;
    void destroyBenchmark() override;
    void drawBenchmark() override;

  private:
    GLuint mPointSpriteProgram;
    GLuint mPositionColorBuffer[2];

    // The buffers contain two floats and 3 unsigned bytes per point sprite
    const size_t mBytesPerSprite = 2 * sizeof(float) + 3;
};

InterleavedAttributeDataBenchmark::InterleavedAttributeDataBenchmark()
    : ANGLERenderTest("InterleavedAttributeData", GetParam()), mPointSpriteProgram(0)
{
}

void InterleavedAttributeDataBenchmark::initializeBenchmark()
{
    const auto &params = GetParam();

    // Compile point sprite shaders
    const std::string vs =
        "attribute vec4 aPosition;"
        "attribute vec4 aColor;"
        "varying vec4 vColor;"
        "void main()"
        "{"
        "    gl_PointSize = 25.0;"
        "    gl_Position  = aPosition;"
        "    vColor = aColor;"
        "}";

    const std::string fs =
        "precision mediump float;"
        "varying vec4 vColor;"
        "void main()"
        "{"
        "    gl_FragColor = vColor;"
        "}";

    mPointSpriteProgram = CompileProgram(vs, fs);
    ASSERT_NE(0u, mPointSpriteProgram);

    glClearColor(0.0f, 1.0f, 0.0f, 1.0f);

    for (size_t i = 0; i < ArraySize(mPositionColorBuffer); i++)
    {
        // Set up initial data for pointsprite positions and colors
        std::vector<uint8_t> positionColorData(mBytesPerSprite * params.numSprites);
        for (unsigned int j = 0; j < params.numSprites; j++)
        {
            float pointSpriteX =
                (static_cast<float>(rand() % getWindow()->getWidth()) / getWindow()->getWidth()) *
                    2.0f - 1.0f;
            float pointSpriteY =
                (static_cast<float>(rand() % getWindow()->getHeight()) / getWindow()->getHeight()) *
                    2.0f - 1.0f;
            GLubyte pointSpriteRed   = static_cast<GLubyte>(rand() % 255);
            GLubyte pointSpriteGreen = static_cast<GLubyte>(rand() % 255);
            GLubyte pointSpriteBlue  = static_cast<GLubyte>(rand() % 255);

            // Add position data for the pointsprite
            *reinterpret_cast<float *>(
                &(positionColorData[j * mBytesPerSprite + 0 * sizeof(float) + 0])) =
                pointSpriteX;  // X
            *reinterpret_cast<float *>(
                &(positionColorData[j * mBytesPerSprite + 1 * sizeof(float) + 0])) =
                pointSpriteY;  // Y

            // Add color data for the pointsprite
            positionColorData[j * mBytesPerSprite + 2 * sizeof(float) + 0] = pointSpriteRed;    // R
            positionColorData[j * mBytesPerSprite + 2 * sizeof(float) + 1] = pointSpriteGreen;  // G
            positionColorData[j * mBytesPerSprite + 2 * sizeof(float) + 2] = pointSpriteBlue;   // B
        }

        // Generate the GL buffer with the position/color data
        glGenBuffers(1, &mPositionColorBuffer[i]);
        glBindBuffer(GL_ARRAY_BUFFER, mPositionColorBuffer[i]);
        glBufferData(GL_ARRAY_BUFFER, params.numSprites * mBytesPerSprite, &(positionColorData[0]),
                     GL_STATIC_DRAW);
    }

    ASSERT_GL_NO_ERROR();
}

void InterleavedAttributeDataBenchmark::destroyBenchmark()
{
    glDeleteProgram(mPointSpriteProgram);

    for (size_t i = 0; i < ArraySize(mPositionColorBuffer); i++)
    {
        glDeleteBuffers(1, &mPositionColorBuffer[i]);
    }
}

void InterleavedAttributeDataBenchmark::drawBenchmark()
{
    glClear(GL_COLOR_BUFFER_BIT);

    for (size_t k = 0; k < 20; k++)
    {
        for (size_t i = 0; i < ArraySize(mPositionColorBuffer); i++)
        {
            // Firstly get the attribute locations for the program
            glUseProgram(mPointSpriteProgram);
            GLint positionLocation = glGetAttribLocation(mPointSpriteProgram, "aPosition");
            ASSERT_NE(positionLocation, -1);
            GLint colorLocation = glGetAttribLocation(mPointSpriteProgram, "aColor");
            ASSERT_NE(colorLocation, -1);

            // Bind the position data from one buffer
            glBindBuffer(GL_ARRAY_BUFFER, mPositionColorBuffer[i]);
            glEnableVertexAttribArray(positionLocation);
            glVertexAttribPointer(positionLocation, 2, GL_FLOAT, GL_FALSE,
                                  static_cast<GLsizei>(mBytesPerSprite), 0);

            // But bind the color data from the other buffer.
            glBindBuffer(GL_ARRAY_BUFFER,
                         mPositionColorBuffer[(i + 1) % ArraySize(mPositionColorBuffer)]);
            glEnableVertexAttribArray(colorLocation);
            glVertexAttribPointer(colorLocation, 3, GL_UNSIGNED_BYTE, GL_TRUE,
                                  static_cast<GLsizei>(mBytesPerSprite),
                                  reinterpret_cast<void *>(2 * sizeof(float)));

            // Then draw the colored pointsprites
            glDrawArrays(GL_POINTS, 0, GetParam().numSprites);
            glFlush();

            glDisableVertexAttribArray(positionLocation);
            glDisableVertexAttribArray(colorLocation);
        }
    }

    ASSERT_GL_NO_ERROR();
}

TEST_P(InterleavedAttributeDataBenchmark, Run)
{
    run();
}

InterleavedAttributeDataParams D3D11Params()
{
    InterleavedAttributeDataParams params;
    params.eglParameters = egl_platform::D3D11();
    return params;
}

InterleavedAttributeDataParams D3D11_9_3Params()
{
    InterleavedAttributeDataParams params;
    params.eglParameters = egl_platform::D3D11_FL9_3();
    return params;
}

InterleavedAttributeDataParams D3D9Params()
{
    InterleavedAttributeDataParams params;
    params.eglParameters = egl_platform::D3D9();
    return params;
}

InterleavedAttributeDataParams OpenGLParams()
{
    InterleavedAttributeDataParams params;
    params.eglParameters = egl_platform::OPENGL();
    return params;
}

ANGLE_INSTANTIATE_TEST(InterleavedAttributeDataBenchmark,
                       D3D11Params(),
                       D3D11_9_3Params(),
                       D3D9Params(),
                       OpenGLParams());

}  // anonymous namespace
