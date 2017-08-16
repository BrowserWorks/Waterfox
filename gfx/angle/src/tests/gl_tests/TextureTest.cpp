//
// Copyright 2015 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//

#include "common/mathutil.h"
#include "test_utils/ANGLETest.h"
#include "test_utils/gl_raii.h"

using namespace angle;

namespace
{

// Take a pixel, and reset the components not covered by the format to default
// values. In particular, the default value for the alpha component is 255
// (1.0 as unsigned normalized fixed point value).
GLColor SliceFormatColor(GLenum format, GLColor full)
{
    switch (format)
    {
        case GL_RED:
            return GLColor(full.R, 0, 0, 255u);
        case GL_RG:
            return GLColor(full.R, full.G, 0, 255u);
        case GL_RGB:
            return GLColor(full.R, full.G, full.B, 255u);
        case GL_RGBA:
            return full;
        default:
            UNREACHABLE();
            return GLColor::white;
    }
}

class TexCoordDrawTest : public ANGLETest
{
  protected:
    TexCoordDrawTest() : ANGLETest(), mProgram(0), mFramebuffer(0), mFramebufferColorTexture(0)
    {
        setWindowWidth(128);
        setWindowHeight(128);
        setConfigRedBits(8);
        setConfigGreenBits(8);
        setConfigBlueBits(8);
        setConfigAlphaBits(8);
    }

    virtual std::string getVertexShaderSource()
    {
        return std::string(SHADER_SOURCE
        (
            precision highp float;
            attribute vec4 position;
            varying vec2 texcoord;

            void main()
            {
                gl_Position = vec4(position.xy, 0.0, 1.0);
                texcoord = (position.xy * 0.5) + 0.5;
            }
        )
        );
    }

    virtual std::string getFragmentShaderSource() = 0;

    virtual void setUpProgram()
    {
        const std::string vertexShaderSource   = getVertexShaderSource();
        const std::string fragmentShaderSource = getFragmentShaderSource();

        mProgram = CompileProgram(vertexShaderSource, fragmentShaderSource);
        ASSERT_NE(0u, mProgram);
        ASSERT_GL_NO_ERROR();
    }

    void SetUp() override
    {
        ANGLETest::SetUp();

        setUpFramebuffer();
    }

    void TearDown() override
    {
        glBindFramebuffer(GL_FRAMEBUFFER, 0);
        glDeleteFramebuffers(1, &mFramebuffer);
        glDeleteTextures(1, &mFramebufferColorTexture);
        glDeleteProgram(mProgram);
        ANGLETest::TearDown();
    }

    void setUpFramebuffer()
    {
        // We use an FBO to work around an issue where the default framebuffer applies SRGB
        // conversion (particularly known to happen incorrectly on Intel GL drivers). It's not
        // clear whether this issue can even be fixed on all backends. For example GLES 3.0.4 spec
        // section 4.4 says that the format of the default framebuffer is entirely up to the window
        // system, so it might be SRGB, and GLES 3.0 doesn't have a "FRAMEBUFFER_SRGB" to turn off
        // SRGB conversion like desktop GL does.
        // TODO(oetuaho): Get rid of this if the underlying issue is fixed.
        glGenFramebuffers(1, &mFramebuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, mFramebuffer);

        glGenTextures(1, &mFramebufferColorTexture);
        glBindTexture(GL_TEXTURE_2D, mFramebufferColorTexture);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, getWindowWidth(), getWindowHeight(), 0, GL_RGBA,
                     GL_UNSIGNED_BYTE, nullptr);
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D,
                               mFramebufferColorTexture, 0);
        ASSERT_GL_NO_ERROR();
        ASSERT_GLENUM_EQ(GL_FRAMEBUFFER_COMPLETE, glCheckFramebufferStatus(GL_FRAMEBUFFER));
        glBindTexture(GL_TEXTURE_2D, 0);
    }

    // Returns the created texture ID.
    GLuint create2DTexture()
    {
        GLuint texture2D;
        glGenTextures(1, &texture2D);
        glBindTexture(GL_TEXTURE_2D, texture2D);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 1, 1, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
        EXPECT_GL_NO_ERROR();
        return texture2D;
    }

    GLuint mProgram;
    GLuint mFramebuffer;

  private:
    GLuint mFramebufferColorTexture;
};

class Texture2DTest : public TexCoordDrawTest
{
  protected:
    Texture2DTest() : TexCoordDrawTest(), mTexture2D(0), mTexture2DUniformLocation(-1) {}

    std::string getFragmentShaderSource() override
    {
        return std::string(SHADER_SOURCE
        (
            precision highp float;
            uniform sampler2D tex;
            varying vec2 texcoord;

            void main()
            {
                gl_FragColor = texture2D(tex, texcoord);
            }
        )
        );
    }

    virtual const char *getTextureUniformName() { return "tex"; }

    void setUpProgram() override
    {
        TexCoordDrawTest::setUpProgram();
        mTexture2DUniformLocation = glGetUniformLocation(mProgram, getTextureUniformName());
        ASSERT_NE(-1, mTexture2DUniformLocation);
    }

    void SetUp() override
    {
        TexCoordDrawTest::SetUp();
        mTexture2D = create2DTexture();

        ASSERT_GL_NO_ERROR();
    }

    void TearDown() override
    {
        glDeleteTextures(1, &mTexture2D);
        TexCoordDrawTest::TearDown();
    }

    // Tests CopyTexSubImage with floating point textures of various formats.
    void testFloatCopySubImage(int sourceImageChannels, int destImageChannels)
    {
        // TODO(jmadill): Figure out why this is broken on Intel D3D11
        if (IsIntel() && getPlatformRenderer() == EGL_PLATFORM_ANGLE_TYPE_D3D11_ANGLE)
        {
            std::cout << "Test skipped on Intel D3D11." << std::endl;
            return;
        }

        setUpProgram();

        if (getClientMajorVersion() < 3)
        {
            if (!extensionEnabled("GL_OES_texture_float"))
            {
                std::cout << "Test skipped due to missing GL_OES_texture_float." << std::endl;
                return;
            }

            if ((sourceImageChannels < 3 || destImageChannels < 3) && !extensionEnabled("GL_EXT_texture_rg"))
            {
                std::cout << "Test skipped due to missing GL_EXT_texture_rg." << std::endl;
                return;
            }
        }

        GLfloat sourceImageData[4][16] =
        {
            { // R
                1.0f,
                0.0f,
                0.0f,
                1.0f
            },
            { // RG
                1.0f, 0.0f,
                0.0f, 1.0f,
                0.0f, 0.0f,
                1.0f, 1.0f
            },
            { // RGB
                1.0f, 0.0f, 0.0f,
                0.0f, 1.0f, 0.0f,
                0.0f, 0.0f, 1.0f,
                1.0f, 1.0f, 0.0f
            },
            { // RGBA
                1.0f, 0.0f, 0.0f, 1.0f,
                0.0f, 1.0f, 0.0f, 1.0f,
                0.0f, 0.0f, 1.0f, 1.0f,
                1.0f, 1.0f, 0.0f, 1.0f
            },
        };

        GLenum imageFormats[] =
        {
            GL_R32F,
            GL_RG32F,
            GL_RGB32F,
            GL_RGBA32F,
        };

        GLenum sourceUnsizedFormats[] =
        {
            GL_RED,
            GL_RG,
            GL_RGB,
            GL_RGBA,
        };

        GLuint textures[2];

        glGenTextures(2, textures);

        GLfloat *imageData = sourceImageData[sourceImageChannels - 1];
        GLenum sourceImageFormat = imageFormats[sourceImageChannels - 1];
        GLenum sourceUnsizedFormat = sourceUnsizedFormats[sourceImageChannels - 1];
        GLenum destImageFormat = imageFormats[destImageChannels - 1];

        glBindTexture(GL_TEXTURE_2D, textures[0]);
        glTexStorage2DEXT(GL_TEXTURE_2D, 1, sourceImageFormat, 2, 2);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
        glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, 2, 2, sourceUnsizedFormat, GL_FLOAT, imageData);

        if (sourceImageChannels < 3 && !extensionEnabled("GL_EXT_texture_rg"))
        {
            // This is not supported
            ASSERT_GL_ERROR(GL_INVALID_OPERATION);
        }
        else
        {
            ASSERT_GL_NO_ERROR();
        }

        GLuint fbo;
        glGenFramebuffers(1, &fbo);
        glBindFramebuffer(GL_FRAMEBUFFER, fbo);
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, textures[0], 0);

        glBindTexture(GL_TEXTURE_2D, textures[1]);
        glTexStorage2DEXT(GL_TEXTURE_2D, 1, destImageFormat, 2, 2);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);

        glCopyTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, 0, 0, 2, 2);
        ASSERT_GL_NO_ERROR();

        glBindFramebuffer(GL_FRAMEBUFFER, 0);
        drawQuad(mProgram, "position", 0.5f);

        int testImageChannels = std::min(sourceImageChannels, destImageChannels);

        EXPECT_PIXEL_COLOR_EQ(0, 0, GLColor::red);
        if (testImageChannels > 1)
        {
            EXPECT_PIXEL_EQ(getWindowHeight() - 1, 0, 0, 255, 0, 255);
            EXPECT_PIXEL_EQ(getWindowHeight() - 1, getWindowWidth() - 1, 255, 255, 0, 255);
            if (testImageChannels > 2)
            {
                EXPECT_PIXEL_EQ(0, getWindowWidth() - 1, 0, 0, 255, 255);
            }
        }

        glDeleteFramebuffers(1, &fbo);
        glDeleteTextures(2, textures);

        ASSERT_GL_NO_ERROR();
    }

    GLuint mTexture2D;
    GLint mTexture2DUniformLocation;
};

class Texture2DTestES3 : public Texture2DTest
{
  protected:
    Texture2DTestES3() : Texture2DTest() {}

    std::string getVertexShaderSource() override
    {
        return std::string(
            "#version 300 es\n"
            "out vec2 texcoord;\n"
            "in vec4 position;\n"
            "void main()\n"
            "{\n"
            "    gl_Position = vec4(position.xy, 0.0, 1.0);\n"
            "    texcoord = (position.xy * 0.5) + 0.5;\n"
            "}\n");
    }

    std::string getFragmentShaderSource() override
    {
        return std::string(
            "#version 300 es\n"
            "precision highp float;\n"
            "uniform highp sampler2D tex;\n"
            "in vec2 texcoord;\n"
            "out vec4 fragColor;\n"
            "void main()\n"
            "{\n"
            "    fragColor = texture(tex, texcoord);\n"
            "}\n");
    }

    void SetUp() override
    {
        Texture2DTest::SetUp();
        setUpProgram();
    }
};

class Texture2DIntegerAlpha1TestES3 : public Texture2DTest
{
  protected:
    Texture2DIntegerAlpha1TestES3() : Texture2DTest() {}

    std::string getVertexShaderSource() override
    {
        return std::string(
            "#version 300 es\n"
            "out vec2 texcoord;\n"
            "in vec4 position;\n"
            "void main()\n"
            "{\n"
            "    gl_Position = vec4(position.xy, 0.0, 1.0);\n"
            "    texcoord = (position.xy * 0.5) + 0.5;\n"
            "}\n");
    }

    std::string getFragmentShaderSource() override
    {
        return std::string(
            "#version 300 es\n"
            "precision highp float;\n"
            "uniform highp isampler2D tex;\n"
            "in vec2 texcoord;\n"
            "out vec4 fragColor;\n"
            "void main()\n"
            "{\n"
            "    vec4 green = vec4(0, 1, 0, 1);\n"
            "    vec4 black = vec4(0, 0, 0, 0);\n"
            "    fragColor = (texture(tex, texcoord).a == 1) ? green : black;\n"
            "}\n");
    }

    void SetUp() override
    {
        Texture2DTest::SetUp();
        setUpProgram();
    }
};

class Texture2DUnsignedIntegerAlpha1TestES3 : public Texture2DTest
{
  protected:
    Texture2DUnsignedIntegerAlpha1TestES3() : Texture2DTest() {}

    std::string getVertexShaderSource() override
    {
        return std::string(
            "#version 300 es\n"
            "out vec2 texcoord;\n"
            "in vec4 position;\n"
            "void main()\n"
            "{\n"
            "    gl_Position = vec4(position.xy, 0.0, 1.0);\n"
            "    texcoord = (position.xy * 0.5) + 0.5;\n"
            "}\n");
    }

    std::string getFragmentShaderSource() override
    {
        return std::string(
            "#version 300 es\n"
            "precision highp float;\n"
            "uniform highp usampler2D tex;\n"
            "in vec2 texcoord;\n"
            "out vec4 fragColor;\n"
            "void main()\n"
            "{\n"
            "    vec4 green = vec4(0, 1, 0, 1);\n"
            "    vec4 black = vec4(0, 0, 0, 0);\n"
            "    fragColor = (texture(tex, texcoord).a == 1u) ? green : black;\n"
            "}\n");
    }

    void SetUp() override
    {
        Texture2DTest::SetUp();
        setUpProgram();
    }
};

class Texture2DTestWithDrawScale : public Texture2DTest
{
  protected:
    Texture2DTestWithDrawScale() : Texture2DTest(), mDrawScaleUniformLocation(-1) {}

    std::string getVertexShaderSource() override
    {
        return std::string(SHADER_SOURCE
        (
            precision highp float;
            attribute vec4 position;
            varying vec2 texcoord;

            uniform vec2 drawScale;

            void main()
            {
                gl_Position = vec4(position.xy * drawScale, 0.0, 1.0);
                texcoord = (position.xy * 0.5) + 0.5;
            }
        )
        );
    }

    void SetUp() override
    {
        Texture2DTest::SetUp();

        setUpProgram();

        mDrawScaleUniformLocation = glGetUniformLocation(mProgram, "drawScale");
        ASSERT_NE(-1, mDrawScaleUniformLocation);

        glUseProgram(mProgram);
        glUniform2f(mDrawScaleUniformLocation, 1.0f, 1.0f);
        glUseProgram(0);
        ASSERT_GL_NO_ERROR();
    }

    GLint mDrawScaleUniformLocation;
};

class Sampler2DAsFunctionParameterTest : public Texture2DTest
{
  protected:
    Sampler2DAsFunctionParameterTest() : Texture2DTest() {}

    std::string getFragmentShaderSource() override
    {
        return std::string(SHADER_SOURCE
        (
            precision highp float;
            uniform sampler2D tex;
            varying vec2 texcoord;

            vec4 computeFragColor(sampler2D aTex)
            {
                return texture2D(aTex, texcoord);
            }

            void main()
            {
                gl_FragColor = computeFragColor(tex);
            }
        )
        );
    }

    void SetUp() override
    {
        Texture2DTest::SetUp();
        setUpProgram();
    }
};

class TextureCubeTest : public TexCoordDrawTest
{
  protected:
    TextureCubeTest()
        : TexCoordDrawTest(),
          mTexture2D(0),
          mTextureCube(0),
          mTexture2DUniformLocation(-1),
          mTextureCubeUniformLocation(-1)
    {
    }

    std::string getFragmentShaderSource() override
    {
        return std::string(SHADER_SOURCE
        (
            precision highp float;
            uniform sampler2D tex2D;
            uniform samplerCube texCube;
            varying vec2 texcoord;

            void main()
            {
                gl_FragColor = texture2D(tex2D, texcoord);
                gl_FragColor += textureCube(texCube, vec3(texcoord, 0));
            }
        )
        );
    }

    void SetUp() override
    {
        TexCoordDrawTest::SetUp();

        glGenTextures(1, &mTextureCube);
        glBindTexture(GL_TEXTURE_CUBE_MAP, mTextureCube);
        glTexStorage2DEXT(GL_TEXTURE_CUBE_MAP, 1, GL_RGBA8, 1, 1);
        EXPECT_GL_NO_ERROR();

        mTexture2D = create2DTexture();

        setUpProgram();

        mTexture2DUniformLocation = glGetUniformLocation(mProgram, "tex2D");
        ASSERT_NE(-1, mTexture2DUniformLocation);
        mTextureCubeUniformLocation = glGetUniformLocation(mProgram, "texCube");
        ASSERT_NE(-1, mTextureCubeUniformLocation);
    }

    void TearDown() override
    {
        glDeleteTextures(1, &mTextureCube);
        TexCoordDrawTest::TearDown();
    }

    GLuint mTexture2D;
    GLuint mTextureCube;
    GLint mTexture2DUniformLocation;
    GLint mTextureCubeUniformLocation;
};

class SamplerArrayTest : public TexCoordDrawTest
{
  protected:
    SamplerArrayTest()
        : TexCoordDrawTest(),
          mTexture2DA(0),
          mTexture2DB(0),
          mTexture0UniformLocation(-1),
          mTexture1UniformLocation(-1)
    {
    }

    std::string getFragmentShaderSource() override
    {
        return std::string(SHADER_SOURCE
        (
            precision mediump float;
            uniform highp sampler2D tex2DArray[2];
            varying vec2 texcoord;
            void main()
            {
                gl_FragColor = texture2D(tex2DArray[0], texcoord);
                gl_FragColor += texture2D(tex2DArray[1], texcoord);
            }
        )
        );
    }

    void SetUp() override
    {
        TexCoordDrawTest::SetUp();

        setUpProgram();

        mTexture0UniformLocation = glGetUniformLocation(mProgram, "tex2DArray[0]");
        ASSERT_NE(-1, mTexture0UniformLocation);
        mTexture1UniformLocation = glGetUniformLocation(mProgram, "tex2DArray[1]");
        ASSERT_NE(-1, mTexture1UniformLocation);

        mTexture2DA = create2DTexture();
        mTexture2DB = create2DTexture();
        ASSERT_GL_NO_ERROR();
    }

    void TearDown() override
    {
        glDeleteTextures(1, &mTexture2DA);
        glDeleteTextures(1, &mTexture2DB);
        TexCoordDrawTest::TearDown();
    }

    void testSamplerArrayDraw()
    {
        GLubyte texData[4];
        texData[0] = 0;
        texData[1] = 60;
        texData[2] = 0;
        texData[3] = 255;

        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, mTexture2DA);
        glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, 1, 1, GL_RGBA, GL_UNSIGNED_BYTE, texData);

        texData[1] = 120;
        glActiveTexture(GL_TEXTURE1);
        glBindTexture(GL_TEXTURE_2D, mTexture2DB);
        glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, 1, 1, GL_RGBA, GL_UNSIGNED_BYTE, texData);
        EXPECT_GL_ERROR(GL_NO_ERROR);

        glUseProgram(mProgram);
        glUniform1i(mTexture0UniformLocation, 0);
        glUniform1i(mTexture1UniformLocation, 1);
        drawQuad(mProgram, "position", 0.5f);
        EXPECT_GL_NO_ERROR();

        EXPECT_PIXEL_NEAR(0, 0, 0, 180, 0, 255, 2);
    }

    GLuint mTexture2DA;
    GLuint mTexture2DB;
    GLint mTexture0UniformLocation;
    GLint mTexture1UniformLocation;
};


class SamplerArrayAsFunctionParameterTest : public SamplerArrayTest
{
  protected:
    SamplerArrayAsFunctionParameterTest() : SamplerArrayTest() {}

    std::string getFragmentShaderSource() override
    {
        return std::string(SHADER_SOURCE
        (
            precision mediump float;
            uniform highp sampler2D tex2DArray[2];
            varying vec2 texcoord;

            vec4 computeFragColor(highp sampler2D aTex2DArray[2])
            {
                return texture2D(aTex2DArray[0], texcoord) + texture2D(aTex2DArray[1], texcoord);
            }

            void main()
            {
                gl_FragColor = computeFragColor(tex2DArray);
            }
        )
        );
    }
};

class Texture2DArrayTestES3 : public TexCoordDrawTest
{
  protected:
    Texture2DArrayTestES3() : TexCoordDrawTest(), m2DArrayTexture(0), mTextureArrayLocation(-1) {}

    std::string getVertexShaderSource() override
    {
        return std::string(
            "#version 300 es\n"
            "out vec2 texcoord;\n"
            "in vec4 position;\n"
            "void main()\n"
            "{\n"
            "    gl_Position = vec4(position.xy, 0.0, 1.0);\n"
            "    texcoord = (position.xy * 0.5) + 0.5;\n"
            "}\n");
    }

    std::string getFragmentShaderSource() override
    {
        return std::string(
            "#version 300 es\n"
            "precision highp float;\n"
            "uniform highp sampler2DArray tex2DArray;\n"
            "in vec2 texcoord;\n"
            "out vec4 fragColor;\n"
            "void main()\n"
            "{\n"
            "    fragColor = texture(tex2DArray, vec3(texcoord.x, texcoord.y, 0.0));\n"
            "}\n");
    }

    void SetUp() override
    {
        TexCoordDrawTest::SetUp();

        setUpProgram();

        mTextureArrayLocation = glGetUniformLocation(mProgram, "tex2DArray");
        ASSERT_NE(-1, mTextureArrayLocation);

        glGenTextures(1, &m2DArrayTexture);
        ASSERT_GL_NO_ERROR();
    }

    void TearDown() override
    {
        glDeleteTextures(1, &m2DArrayTexture);
        TexCoordDrawTest::TearDown();
    }

    GLuint m2DArrayTexture;
    GLint mTextureArrayLocation;
};

class TextureSizeTextureArrayTest : public TexCoordDrawTest
{
  protected:
    TextureSizeTextureArrayTest()
        : TexCoordDrawTest(),
          mTexture2DA(0),
          mTexture2DB(0),
          mTexture0Location(-1),
          mTexture1Location(-1)
    {
    }

    std::string getVertexShaderSource() override
    {
        return std::string(
            "#version 300 es\n"
            "in vec4 position;\n"
            "void main()\n"
            "{\n"
            "    gl_Position = vec4(position.xy, 0.0, 1.0);\n"
            "}\n");
    }

    std::string getFragmentShaderSource() override
    {
        return std::string(
            "#version 300 es\n"
            "precision highp float;\n"
            "uniform highp sampler2D tex2DArray[2];\n"
            "out vec4 fragColor;\n"
            "void main()\n"
            "{\n"
            "    float red = float(textureSize(tex2DArray[0], 0).x) / 255.0;\n"
            "    float green = float(textureSize(tex2DArray[1], 0).x) / 255.0;\n"
            "    fragColor = vec4(red, green, 0.0, 1.0);\n"
            "}\n");
    }

    void SetUp() override
    {
        TexCoordDrawTest::SetUp();

        setUpProgram();

        mTexture0Location = glGetUniformLocation(mProgram, "tex2DArray[0]");
        ASSERT_NE(-1, mTexture0Location);
        mTexture1Location = glGetUniformLocation(mProgram, "tex2DArray[1]");
        ASSERT_NE(-1, mTexture1Location);

        mTexture2DA = create2DTexture();
        mTexture2DB = create2DTexture();
        ASSERT_GL_NO_ERROR();
    }

    void TearDown() override
    {
        glDeleteTextures(1, &mTexture2DA);
        glDeleteTextures(1, &mTexture2DB);
        TexCoordDrawTest::TearDown();
    }

    GLuint mTexture2DA;
    GLuint mTexture2DB;
    GLint mTexture0Location;
    GLint mTexture1Location;
};

class Texture3DTestES3 : public TexCoordDrawTest
{
  protected:
    Texture3DTestES3() : TexCoordDrawTest(), mTexture3D(0), mTexture3DUniformLocation(-1) {}

    std::string getVertexShaderSource() override
    {
        return std::string(
            "#version 300 es\n"
            "out vec2 texcoord;\n"
            "in vec4 position;\n"
            "void main()\n"
            "{\n"
            "    gl_Position = vec4(position.xy, 0.0, 1.0);\n"
            "    texcoord = (position.xy * 0.5) + 0.5;\n"
            "}\n");
    }

    std::string getFragmentShaderSource() override
    {
        return std::string(
            "#version 300 es\n"
            "precision highp float;\n"
            "uniform highp sampler3D tex3D;\n"
            "in vec2 texcoord;\n"
            "out vec4 fragColor;\n"
            "void main()\n"
            "{\n"
            "    fragColor = texture(tex3D, vec3(texcoord, 0.0));\n"
            "}\n");
    }

    void SetUp() override
    {
        TexCoordDrawTest::SetUp();

        glGenTextures(1, &mTexture3D);

        setUpProgram();

        mTexture3DUniformLocation = glGetUniformLocation(mProgram, "tex3D");
        ASSERT_NE(-1, mTexture3DUniformLocation);
    }

    void TearDown() override
    {
        glDeleteTextures(1, &mTexture3D);
        TexCoordDrawTest::TearDown();
    }

    GLuint mTexture3D;
    GLint mTexture3DUniformLocation;
};

class ShadowSamplerPlusSampler3DTestES3 : public TexCoordDrawTest
{
  protected:
    ShadowSamplerPlusSampler3DTestES3()
        : TexCoordDrawTest(),
          mTextureShadow(0),
          mTexture3D(0),
          mTextureShadowUniformLocation(-1),
          mTexture3DUniformLocation(-1),
          mDepthRefUniformLocation(-1)
    {
    }

    std::string getVertexShaderSource() override
    {
        return std::string(
            "#version 300 es\n"
            "out vec2 texcoord;\n"
            "in vec4 position;\n"
            "void main()\n"
            "{\n"
            "    gl_Position = vec4(position.xy, 0.0, 1.0);\n"
            "    texcoord = (position.xy * 0.5) + 0.5;\n"
            "}\n");
    }

    std::string getFragmentShaderSource() override
    {
        return std::string(
            "#version 300 es\n"
            "precision highp float;\n"
            "uniform highp sampler2DShadow tex2DShadow;\n"
            "uniform highp sampler3D tex3D;\n"
            "in vec2 texcoord;\n"
            "uniform float depthRef;\n"
            "out vec4 fragColor;\n"
            "void main()\n"
            "{\n"
            "    fragColor = vec4(texture(tex2DShadow, vec3(texcoord, depthRef)) * 0.5);\n"
            "    fragColor += texture(tex3D, vec3(texcoord, 0.0));\n"
            "}\n");
    }

    void SetUp() override
    {
        TexCoordDrawTest::SetUp();

        glGenTextures(1, &mTexture3D);

        glGenTextures(1, &mTextureShadow);
        glBindTexture(GL_TEXTURE_2D, mTextureShadow);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_COMPARE_MODE, GL_COMPARE_REF_TO_TEXTURE);

        setUpProgram();

        mTextureShadowUniformLocation = glGetUniformLocation(mProgram, "tex2DShadow");
        ASSERT_NE(-1, mTextureShadowUniformLocation);
        mTexture3DUniformLocation = glGetUniformLocation(mProgram, "tex3D");
        ASSERT_NE(-1, mTexture3DUniformLocation);
        mDepthRefUniformLocation = glGetUniformLocation(mProgram, "depthRef");
        ASSERT_NE(-1, mDepthRefUniformLocation);
    }

    void TearDown() override
    {
        glDeleteTextures(1, &mTextureShadow);
        glDeleteTextures(1, &mTexture3D);
        TexCoordDrawTest::TearDown();
    }

    GLuint mTextureShadow;
    GLuint mTexture3D;
    GLint mTextureShadowUniformLocation;
    GLint mTexture3DUniformLocation;
    GLint mDepthRefUniformLocation;
};

class SamplerTypeMixTestES3 : public TexCoordDrawTest
{
  protected:
    SamplerTypeMixTestES3()
        : TexCoordDrawTest(),
          mTexture2D(0),
          mTextureCube(0),
          mTexture2DShadow(0),
          mTextureCubeShadow(0),
          mTexture2DUniformLocation(-1),
          mTextureCubeUniformLocation(-1),
          mTexture2DShadowUniformLocation(-1),
          mTextureCubeShadowUniformLocation(-1),
          mDepthRefUniformLocation(-1)
    {
    }

    std::string getVertexShaderSource() override
    {
        return std::string(
            "#version 300 es\n"
            "out vec2 texcoord;\n"
            "in vec4 position;\n"
            "void main()\n"
            "{\n"
            "    gl_Position = vec4(position.xy, 0.0, 1.0);\n"
            "    texcoord = (position.xy * 0.5) + 0.5;\n"
            "}\n");
    }

    std::string getFragmentShaderSource() override
    {
        return std::string(
            "#version 300 es\n"
            "precision highp float;\n"
            "uniform highp sampler2D tex2D;\n"
            "uniform highp samplerCube texCube;\n"
            "uniform highp sampler2DShadow tex2DShadow;\n"
            "uniform highp samplerCubeShadow texCubeShadow;\n"
            "in vec2 texcoord;\n"
            "uniform float depthRef;\n"
            "out vec4 fragColor;\n"
            "void main()\n"
            "{\n"
            "    fragColor = texture(tex2D, texcoord);\n"
            "    fragColor += texture(texCube, vec3(1.0, 0.0, 0.0));\n"
            "    fragColor += vec4(texture(tex2DShadow, vec3(texcoord, depthRef)) * 0.25);\n"
            "    fragColor += vec4(texture(texCubeShadow, vec4(1.0, 0.0, 0.0, depthRef)) * "
            "0.125);\n"
            "}\n");
    }

    void SetUp() override
    {
        TexCoordDrawTest::SetUp();

        glGenTextures(1, &mTexture2D);
        glGenTextures(1, &mTextureCube);

        glGenTextures(1, &mTexture2DShadow);
        glBindTexture(GL_TEXTURE_2D, mTexture2DShadow);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_COMPARE_MODE, GL_COMPARE_REF_TO_TEXTURE);

        glGenTextures(1, &mTextureCubeShadow);
        glBindTexture(GL_TEXTURE_CUBE_MAP, mTextureCubeShadow);
        glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_COMPARE_MODE, GL_COMPARE_REF_TO_TEXTURE);

        setUpProgram();

        mTexture2DUniformLocation = glGetUniformLocation(mProgram, "tex2D");
        ASSERT_NE(-1, mTexture2DUniformLocation);
        mTextureCubeUniformLocation = glGetUniformLocation(mProgram, "texCube");
        ASSERT_NE(-1, mTextureCubeUniformLocation);
        mTexture2DShadowUniformLocation = glGetUniformLocation(mProgram, "tex2DShadow");
        ASSERT_NE(-1, mTexture2DShadowUniformLocation);
        mTextureCubeShadowUniformLocation = glGetUniformLocation(mProgram, "texCubeShadow");
        ASSERT_NE(-1, mTextureCubeShadowUniformLocation);
        mDepthRefUniformLocation = glGetUniformLocation(mProgram, "depthRef");
        ASSERT_NE(-1, mDepthRefUniformLocation);

        ASSERT_GL_NO_ERROR();
    }

    void TearDown() override
    {
        glDeleteTextures(1, &mTexture2D);
        glDeleteTextures(1, &mTextureCube);
        glDeleteTextures(1, &mTexture2DShadow);
        glDeleteTextures(1, &mTextureCubeShadow);
        TexCoordDrawTest::TearDown();
    }

    GLuint mTexture2D;
    GLuint mTextureCube;
    GLuint mTexture2DShadow;
    GLuint mTextureCubeShadow;
    GLint mTexture2DUniformLocation;
    GLint mTextureCubeUniformLocation;
    GLint mTexture2DShadowUniformLocation;
    GLint mTextureCubeShadowUniformLocation;
    GLint mDepthRefUniformLocation;
};

class SamplerInStructTest : public Texture2DTest
{
  protected:
    SamplerInStructTest() : Texture2DTest() {}

    const char *getTextureUniformName() override { return "us.tex"; }

    std::string getFragmentShaderSource() override
    {
        return std::string(
            "precision highp float;\n"
            "struct S\n"
            "{\n"
            "    vec4 a;\n"
            "    highp sampler2D tex;\n"
            "};\n"
            "uniform S us;\n"
            "varying vec2 texcoord;\n"
            "void main()\n"
            "{\n"
            "    gl_FragColor = texture2D(us.tex, texcoord + us.a.x);\n"
            "}\n");
    }

    void runSamplerInStructTest()
    {
        setUpProgram();

        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, mTexture2D);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 1, 1, 0, GL_RGBA, GL_UNSIGNED_BYTE,
                     &GLColor::green);
        drawQuad(mProgram, "position", 0.5f);
        EXPECT_PIXEL_COLOR_EQ(0, 0, GLColor::green);
    }
};

class SamplerInStructAsFunctionParameterTest : public SamplerInStructTest
{
  protected:
    SamplerInStructAsFunctionParameterTest() : SamplerInStructTest() {}

    std::string getFragmentShaderSource() override
    {
        return std::string(
            "precision highp float;\n"
            "struct S\n"
            "{\n"
            "    vec4 a;\n"
            "    highp sampler2D tex;\n"
            "};\n"
            "uniform S us;\n"
            "varying vec2 texcoord;\n"
            "vec4 sampleFrom(S s) {\n"
            "    return texture2D(s.tex, texcoord + s.a.x);\n"
            "}\n"
            "void main()\n"
            "{\n"
            "    gl_FragColor = sampleFrom(us);\n"
            "}\n");
    }
};

class SamplerInStructArrayAsFunctionParameterTest : public SamplerInStructTest
{
  protected:
    SamplerInStructArrayAsFunctionParameterTest() : SamplerInStructTest() {}

    const char *getTextureUniformName() override { return "us[0].tex"; }

    std::string getFragmentShaderSource() override
    {
        return std::string(
            "precision highp float;\n"
            "struct S\n"
            "{\n"
            "    vec4 a;\n"
            "    highp sampler2D tex;\n"
            "};\n"
            "uniform S us[1];\n"
            "varying vec2 texcoord;\n"
            "vec4 sampleFrom(S s) {\n"
            "    return texture2D(s.tex, texcoord + s.a.x);\n"
            "}\n"
            "void main()\n"
            "{\n"
            "    gl_FragColor = sampleFrom(us[0]);\n"
            "}\n");
    }
};

class SamplerInNestedStructAsFunctionParameterTest : public SamplerInStructTest
{
  protected:
    SamplerInNestedStructAsFunctionParameterTest() : SamplerInStructTest() {}

    const char *getTextureUniformName() override { return "us[0].sub.tex"; }

    std::string getFragmentShaderSource() override
    {
        return std::string(
            "precision highp float;\n"
            "struct SUB\n"
            "{\n"
            "    vec4 a;\n"
            "    highp sampler2D tex;\n"
            "};\n"
            "struct S\n"
            "{\n"
            "    SUB sub;\n"
            "};\n"
            "uniform S us[1];\n"
            "varying vec2 texcoord;\n"
            "vec4 sampleFrom(SUB s) {\n"
            "    return texture2D(s.tex, texcoord + s.a.x);\n"
            "}\n"
            "void main()\n"
            "{\n"
            "    gl_FragColor = sampleFrom(us[0].sub);\n"
            "}\n");
    }
};

class SamplerInStructAndOtherVariableTest : public SamplerInStructTest
{
  protected:
    SamplerInStructAndOtherVariableTest() : SamplerInStructTest() {}

    std::string getFragmentShaderSource() override
    {
        return std::string(
            "precision highp float;\n"
            "struct S\n"
            "{\n"
            "    vec4 a;\n"
            "    highp sampler2D tex;\n"
            "};\n"
            "uniform S us;\n"
            "uniform float us_tex;\n"
            "varying vec2 texcoord;\n"
            "void main()\n"
            "{\n"
            "    gl_FragColor = texture2D(us.tex, texcoord + us.a.x + us_tex);\n"
            "}\n");
    }
};

TEST_P(Texture2DTest, NegativeAPISubImage)
{
    glBindTexture(GL_TEXTURE_2D, mTexture2D);
    EXPECT_GL_ERROR(GL_NO_ERROR);

    setUpProgram();

    const GLubyte *pixels[20] = { 0 };
    glTexSubImage2D(GL_TEXTURE_2D, 0, 1, 1, 1, 1, GL_RGBA, GL_UNSIGNED_BYTE, pixels);
    EXPECT_GL_ERROR(GL_INVALID_VALUE);

    if (extensionEnabled("GL_EXT_texture_storage"))
    {
        // Create a 1-level immutable texture.
        glTexStorage2DEXT(GL_TEXTURE_2D, 1, GL_RGBA8, 2, 2);

        // Try calling sub image on the second level.
        glTexSubImage2D(GL_TEXTURE_2D, 1, 1, 1, 1, 1, GL_RGBA, GL_UNSIGNED_BYTE, pixels);
        EXPECT_GL_ERROR(GL_INVALID_OPERATION);
    }
}

// Test that querying GL_TEXTURE_BINDING* doesn't cause an unexpected error.
TEST_P(Texture2DTest, QueryBinding)
{
    glBindTexture(GL_TEXTURE_2D, 0);
    EXPECT_GL_ERROR(GL_NO_ERROR);

    GLint textureBinding;
    glGetIntegerv(GL_TEXTURE_BINDING_2D, &textureBinding);
    EXPECT_GL_NO_ERROR();
    EXPECT_EQ(0, textureBinding);

    glGetIntegerv(GL_TEXTURE_BINDING_EXTERNAL_OES, &textureBinding);
    if (extensionEnabled("GL_OES_EGL_image_external") ||
        extensionEnabled("GL_NV_EGL_stream_consumer_external"))
    {
        EXPECT_GL_NO_ERROR();
        EXPECT_EQ(0, textureBinding);
    }
    else
    {
        EXPECT_GL_ERROR(GL_INVALID_ENUM);
    }
}

TEST_P(Texture2DTest, ZeroSizedUploads)
{
    glBindTexture(GL_TEXTURE_2D, mTexture2D);
    EXPECT_GL_ERROR(GL_NO_ERROR);

    setUpProgram();

    // Use the texture first to make sure it's in video memory
    glUseProgram(mProgram);
    glUniform1i(mTexture2DUniformLocation, 0);
    drawQuad(mProgram, "position", 0.5f);

    const GLubyte *pixel[4] = { 0 };

    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, 0, 0, GL_RGBA, GL_UNSIGNED_BYTE, pixel);
    EXPECT_GL_NO_ERROR();

    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, 0, 1, GL_RGBA, GL_UNSIGNED_BYTE, pixel);
    EXPECT_GL_NO_ERROR();

    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, 1, 0, GL_RGBA, GL_UNSIGNED_BYTE, pixel);
    EXPECT_GL_NO_ERROR();
}

// Test drawing with two texture types, to trigger an ANGLE bug in validation
TEST_P(TextureCubeTest, CubeMapBug)
{
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, mTexture2D);
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_CUBE_MAP, mTextureCube);
    EXPECT_GL_ERROR(GL_NO_ERROR);

    glUseProgram(mProgram);
    glUniform1i(mTexture2DUniformLocation, 0);
    glUniform1i(mTextureCubeUniformLocation, 1);
    drawQuad(mProgram, "position", 0.5f);
    EXPECT_GL_NO_ERROR();
}

// Test drawing with two texture types accessed from the same shader and check that the result of
// drawing is correct.
TEST_P(TextureCubeTest, CubeMapDraw)
{
    GLubyte texData[4];
    texData[0] = 0;
    texData[1] = 60;
    texData[2] = 0;
    texData[3] = 255;

    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, mTexture2D);
    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, 1, 1, GL_RGBA, GL_UNSIGNED_BYTE, texData);

    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_CUBE_MAP, mTextureCube);
    texData[1] = 120;
    glTexSubImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_X, 0, 0, 0, 1, 1, GL_RGBA, GL_UNSIGNED_BYTE,
                    texData);
    EXPECT_GL_ERROR(GL_NO_ERROR);

    glUseProgram(mProgram);
    glUniform1i(mTexture2DUniformLocation, 0);
    glUniform1i(mTextureCubeUniformLocation, 1);
    drawQuad(mProgram, "position", 0.5f);
    EXPECT_GL_NO_ERROR();

    int px = getWindowWidth() - 1;
    int py = 0;
    EXPECT_PIXEL_NEAR(px, py, 0, 180, 0, 255, 2);
}

TEST_P(Sampler2DAsFunctionParameterTest, Sampler2DAsFunctionParameter)
{
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, mTexture2D);
    GLubyte texData[4];
    texData[0] = 0;
    texData[1] = 128;
    texData[2] = 0;
    texData[3] = 255;
    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, 1, 1, GL_RGBA, GL_UNSIGNED_BYTE, texData);
    glUseProgram(mProgram);
    glUniform1i(mTexture2DUniformLocation, 0);
    drawQuad(mProgram, "position", 0.5f);
    EXPECT_GL_NO_ERROR();

    EXPECT_PIXEL_NEAR(0, 0, 0, 128, 0, 255, 2);
}

// Test drawing with two textures passed to the shader in a sampler array.
TEST_P(SamplerArrayTest, SamplerArrayDraw)
{
    testSamplerArrayDraw();
}

// Test drawing with two textures passed to the shader in a sampler array which is passed to a
// user-defined function in the shader.
TEST_P(SamplerArrayAsFunctionParameterTest, SamplerArrayAsFunctionParameter)
{
    testSamplerArrayDraw();
}

// Copy of a test in conformance/textures/texture-mips, to test generate mipmaps
TEST_P(Texture2DTestWithDrawScale, MipmapsTwice)
{
    int px = getWindowWidth() / 2;
    int py = getWindowHeight() / 2;

    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, mTexture2D);

    std::vector<GLColor> pixelsRed(16u * 16u, GLColor::red);

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 16, 16, 0, GL_RGBA, GL_UNSIGNED_BYTE, pixelsRed.data());
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glGenerateMipmap(GL_TEXTURE_2D);

    glUseProgram(mProgram);
    glUniform1i(mTexture2DUniformLocation, 0);
    glUniform2f(mDrawScaleUniformLocation, 0.0625f, 0.0625f);
    drawQuad(mProgram, "position", 0.5f);
    EXPECT_GL_NO_ERROR();
    EXPECT_PIXEL_COLOR_EQ(px, py, GLColor::red);

    std::vector<GLColor> pixelsBlue(16u * 16u, GLColor::blue);

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 16, 16, 0, GL_RGBA, GL_UNSIGNED_BYTE,
                 pixelsBlue.data());
    glGenerateMipmap(GL_TEXTURE_2D);

    std::vector<GLColor> pixelsGreen(16u * 16u, GLColor::green);

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 16, 16, 0, GL_RGBA, GL_UNSIGNED_BYTE,
                 pixelsGreen.data());
    glGenerateMipmap(GL_TEXTURE_2D);

    drawQuad(mProgram, "position", 0.5f);

    EXPECT_GL_NO_ERROR();
    EXPECT_PIXEL_COLOR_EQ(px, py, GLColor::green);
}

// Test creating a FBO with a cube map render target, to test an ANGLE bug
// https://code.google.com/p/angleproject/issues/detail?id=849
TEST_P(TextureCubeTest, CubeMapFBO)
{
    GLuint fbo;
    glGenFramebuffers(1, &fbo);
    glBindFramebuffer(GL_FRAMEBUFFER, fbo);

    glBindTexture(GL_TEXTURE_CUBE_MAP, mTextureCube);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_CUBE_MAP_POSITIVE_Y, mTextureCube, 0);

    EXPECT_GLENUM_EQ(GL_FRAMEBUFFER_COMPLETE, glCheckFramebufferStatus(GL_FRAMEBUFFER));

    glDeleteFramebuffers(1, &fbo);

    EXPECT_GL_NO_ERROR();
}

// Test that glTexSubImage2D works properly when glTexStorage2DEXT has initialized the image with a default color.
TEST_P(Texture2DTest, TexStorage)
{
    int width = getWindowWidth();
    int height = getWindowHeight();

    GLuint tex2D;
    glGenTextures(1, &tex2D);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, tex2D);

    // Fill with red
    std::vector<GLubyte> pixels(3 * 16 * 16);
    for (size_t pixelId = 0; pixelId < 16 * 16; ++pixelId)
    {
        pixels[pixelId * 3 + 0] = 255;
        pixels[pixelId * 3 + 1] = 0;
        pixels[pixelId * 3 + 2] = 0;
    }

    // ANGLE internally uses RGBA as the DirectX format for RGB images
    // therefore glTexStorage2DEXT initializes the image to a default color to get a consistent alpha color.
    // The data is kept in a CPU-side image and the image is marked as dirty.
    glTexStorage2DEXT(GL_TEXTURE_2D, 1, GL_RGB8, 16, 16);

    // Initializes the color of the upper-left 8x8 pixels, leaves the other pixels untouched.
    // glTexSubImage2D should take into account that the image is dirty.
    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, 8, 8, GL_RGB, GL_UNSIGNED_BYTE, pixels.data());
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

    setUpProgram();

    glUseProgram(mProgram);
    glUniform1i(mTexture2DUniformLocation, 0);
    drawQuad(mProgram, "position", 0.5f);
    glDeleteTextures(1, &tex2D);
    EXPECT_GL_NO_ERROR();
    EXPECT_PIXEL_EQ(width / 4, height / 4, 255, 0, 0, 255);

    // Validate that the region of the texture without data has an alpha of 1.0
    GLubyte pixel[4];
    glReadPixels(3 * width / 4, 3 * height / 4, 1, 1, GL_RGBA, GL_UNSIGNED_BYTE, pixel);
    EXPECT_EQ(pixel[3], 255);
}

// Test that glTexSubImage2D combined with a PBO works properly when glTexStorage2DEXT has initialized the image with a default color.
TEST_P(Texture2DTest, TexStorageWithPBO)
{
    if (extensionEnabled("NV_pixel_buffer_object"))
    {
        int width = getWindowWidth();
        int height = getWindowHeight();

        GLuint tex2D;
        glGenTextures(1, &tex2D);
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, tex2D);

        // Fill with red
        std::vector<GLubyte> pixels(3 * 16 * 16);
        for (size_t pixelId = 0; pixelId < 16 * 16; ++pixelId)
        {
            pixels[pixelId * 3 + 0] = 255;
            pixels[pixelId * 3 + 1] = 0;
            pixels[pixelId * 3 + 2] = 0;
        }

        // Read 16x16 region from red backbuffer to PBO
        GLuint pbo;
        glGenBuffers(1, &pbo);
        glBindBuffer(GL_PIXEL_UNPACK_BUFFER, pbo);
        glBufferData(GL_PIXEL_UNPACK_BUFFER, 3 * 16 * 16, pixels.data(), GL_STATIC_DRAW);

        // ANGLE internally uses RGBA as the DirectX format for RGB images
        // therefore glTexStorage2DEXT initializes the image to a default color to get a consistent alpha color.
        // The data is kept in a CPU-side image and the image is marked as dirty.
        glTexStorage2DEXT(GL_TEXTURE_2D, 1, GL_RGB8, 16, 16);

        // Initializes the color of the upper-left 8x8 pixels, leaves the other pixels untouched.
        // glTexSubImage2D should take into account that the image is dirty.
        glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, 8, 8, GL_RGB, GL_UNSIGNED_BYTE, NULL);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

        setUpProgram();

        glUseProgram(mProgram);
        glUniform1i(mTexture2DUniformLocation, 0);
        drawQuad(mProgram, "position", 0.5f);
        glDeleteTextures(1, &tex2D);
        glDeleteBuffers(1, &pbo);
        EXPECT_GL_NO_ERROR();
        EXPECT_PIXEL_EQ(3 * width / 4, 3 * height / 4, 0, 0, 0, 255);
        EXPECT_PIXEL_EQ(width / 4, height / 4, 255, 0, 0, 255);
    }
}

// See description on testFloatCopySubImage
TEST_P(Texture2DTest, CopySubImageFloat_R_R)
{
    testFloatCopySubImage(1, 1);
}

TEST_P(Texture2DTest, CopySubImageFloat_RG_R)
{
    testFloatCopySubImage(2, 1);
}

TEST_P(Texture2DTest, CopySubImageFloat_RG_RG)
{
    testFloatCopySubImage(2, 2);
}

TEST_P(Texture2DTest, CopySubImageFloat_RGB_R)
{
    if (IsIntel() && IsLinux())
    {
        // TODO(cwallez): Fix on Linux Intel drivers (http://anglebug.com/1346)
        std::cout << "Test disabled on Linux Intel OpenGL." << std::endl;
        return;
    }

    testFloatCopySubImage(3, 1);
}

TEST_P(Texture2DTest, CopySubImageFloat_RGB_RG)
{
    if (IsIntel() && IsLinux())
    {
        // TODO(cwallez): Fix on Linux Intel drivers (http://anglebug.com/1346)
        std::cout << "Test disabled on Linux Intel OpenGL." << std::endl;
        return;
    }

    testFloatCopySubImage(3, 2);
}

TEST_P(Texture2DTest, CopySubImageFloat_RGB_RGB)
{
    if (IsIntel() && IsLinux())
    {
        // TODO(cwallez): Fix on Linux Intel drivers (http://anglebug.com/1346)
        std::cout << "Test disabled on Linux Intel OpenGL." << std::endl;
        return;
    }

    // TODO (bug 1284): Investigate RGBA32f D3D SDK Layers messages on D3D11_FL9_3
    if (IsD3D11_FL93())
    {
        std::cout << "Test skipped on Feature Level 9_3." << std::endl;
        return;
    }

    testFloatCopySubImage(3, 3);
}

TEST_P(Texture2DTest, CopySubImageFloat_RGBA_R)
{
    testFloatCopySubImage(4, 1);
}

TEST_P(Texture2DTest, CopySubImageFloat_RGBA_RG)
{
    testFloatCopySubImage(4, 2);
}

TEST_P(Texture2DTest, CopySubImageFloat_RGBA_RGB)
{
    // TODO (bug 1284): Investigate RGBA32f D3D SDK Layers messages on D3D11_FL9_3
    if (IsD3D11_FL93())
    {
        std::cout << "Test skipped on Feature Level 9_3." << std::endl;
        return;
    }

    testFloatCopySubImage(4, 3);
}

TEST_P(Texture2DTest, CopySubImageFloat_RGBA_RGBA)
{
    // TODO (bug 1284): Investigate RGBA32f D3D SDK Layers messages on D3D11_FL9_3
    if (IsD3D11_FL93())
    {
        std::cout << "Test skipped on Feature Level 9_3." << std::endl;
        return;
    }

    testFloatCopySubImage(4, 4);
}

// Port of https://www.khronos.org/registry/webgl/conformance-suites/1.0.3/conformance/textures/texture-npot.html
// Run against GL_ALPHA/UNSIGNED_BYTE format, to ensure that D3D11 Feature Level 9_3 correctly handles GL_ALPHA
TEST_P(Texture2DTest, TextureNPOT_GL_ALPHA_UBYTE)
{
    const int npotTexSize = 5;
    const int potTexSize = 4; // Should be less than npotTexSize
    GLuint tex2D;

    if (extensionEnabled("GL_OES_texture_npot"))
    {
        // This test isn't applicable if texture_npot is enabled
        return;
    }

    setUpProgram();

    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);

    // Default unpack alignment is 4. The values of 'pixels' below needs it to be 1.
    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);

    glActiveTexture(GL_TEXTURE0);
    glGenTextures(1, &tex2D);
    glBindTexture(GL_TEXTURE_2D, tex2D);

    std::vector<GLubyte> pixels(1 * npotTexSize * npotTexSize);
    for (size_t pixelId = 0; pixelId < npotTexSize * npotTexSize; ++pixelId)
    {
        pixels[pixelId] = 64;
    }

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

    // Check that an NPOT texture not on level 0 generates INVALID_VALUE
    glTexImage2D(GL_TEXTURE_2D, 1, GL_ALPHA, npotTexSize, npotTexSize, 0, GL_ALPHA, GL_UNSIGNED_BYTE, pixels.data());
    EXPECT_GL_ERROR(GL_INVALID_VALUE);

    // Check that an NPOT texture on level 0 succeeds
    glTexImage2D(GL_TEXTURE_2D, 0, GL_ALPHA, npotTexSize, npotTexSize, 0, GL_ALPHA, GL_UNSIGNED_BYTE, pixels.data());
    EXPECT_GL_NO_ERROR();

    // Check that generateMipmap fails on NPOT
    glGenerateMipmap(GL_TEXTURE_2D);
    EXPECT_GL_ERROR(GL_INVALID_OPERATION);

    // Check that nothing is drawn if filtering is not correct for NPOT
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    glClear(GL_COLOR_BUFFER_BIT);
    drawQuad(mProgram, "position", 1.0f);
    EXPECT_PIXEL_EQ(getWindowWidth() / 2, getWindowHeight() / 2, 0, 0, 0, 255);

    // NPOT texture with TEXTURE_MIN_FILTER not NEAREST or LINEAR should draw with 0,0,0,255
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST_MIPMAP_LINEAR);
    glClear(GL_COLOR_BUFFER_BIT);
    drawQuad(mProgram, "position", 1.0f);
    EXPECT_PIXEL_EQ(getWindowWidth() / 2, getWindowHeight() / 2, 0, 0, 0, 255);

    // NPOT texture with TEXTURE_MIN_FILTER set to LINEAR should draw
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glClear(GL_COLOR_BUFFER_BIT);
    drawQuad(mProgram, "position", 1.0f);
    EXPECT_PIXEL_EQ(getWindowWidth() / 2, getWindowHeight() / 2, 0, 0, 0, 64);

    // Check that glTexImage2D for POT texture succeeds
    glTexImage2D(GL_TEXTURE_2D, 0, GL_ALPHA, potTexSize, potTexSize, 0, GL_ALPHA, GL_UNSIGNED_BYTE, pixels.data());
    EXPECT_GL_NO_ERROR();

    // Check that generateMipmap for an POT texture succeeds
    glGenerateMipmap(GL_TEXTURE_2D);
    EXPECT_GL_NO_ERROR();

    // POT texture with TEXTURE_MIN_FILTER set to LINEAR_MIPMAP_LINEAR should draw
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    glClear(GL_COLOR_BUFFER_BIT);
    drawQuad(mProgram, "position", 1.0f);
    EXPECT_PIXEL_EQ(getWindowWidth() / 2, getWindowHeight() / 2, 0, 0, 0, 64);
    EXPECT_GL_NO_ERROR();
}

// Test to ensure that glTexSubImage2D always accepts data for non-power-of-two subregions.
// ANGLE previously rejected this if GL_OES_texture_npot wasn't active, which is incorrect.
TEST_P(Texture2DTest, NPOTSubImageParameters)
{
    // TODO(geofflang): Allow the GL backend to accept SubImage calls with a null data ptr. (bug
    // 1278)
    if (getPlatformRenderer() == EGL_PLATFORM_ANGLE_TYPE_OPENGL_ANGLE ||
        getPlatformRenderer() == EGL_PLATFORM_ANGLE_TYPE_OPENGLES_ANGLE)
    {
        std::cout << "Test disabled on OpenGL." << std::endl;
        return;
    }

    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, mTexture2D);

    // Create an 8x8 (i.e. power-of-two) texture.
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 8, 8, 0, GL_RGBA, GL_UNSIGNED_BYTE, nullptr);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glGenerateMipmap(GL_TEXTURE_2D);

    // Supply a 3x3 (i.e. non-power-of-two) subimage to the texture.
    // This should always work, even if GL_OES_texture_npot isn't active.
    glTexSubImage2D(GL_TEXTURE_2D, 1, 0, 0, 3, 3, GL_RGBA, GL_UNSIGNED_BYTE, nullptr);

    EXPECT_GL_NO_ERROR();
}

// Test to check that texture completeness is determined correctly when the texture base level is
// greater than 0, and also that level 0 is not sampled when base level is greater than 0.
TEST_P(Texture2DTestES3, DrawWithBaseLevel1)
{
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, mTexture2D);

    std::vector<GLColor> texDataRed(4u * 4u, GLColor::red);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 4, 4, 0, GL_RGBA, GL_UNSIGNED_BYTE, texDataRed.data());
    std::vector<GLColor> texDataGreen(2u * 2u, GLColor::green);
    glTexImage2D(GL_TEXTURE_2D, 1, GL_RGBA, 2, 2, 0, GL_RGBA, GL_UNSIGNED_BYTE,
                 texDataGreen.data());
    glTexImage2D(GL_TEXTURE_2D, 2, GL_RGBA, 1, 1, 0, GL_RGBA, GL_UNSIGNED_BYTE,
                 texDataGreen.data());
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_BASE_LEVEL, 1);

    EXPECT_GL_NO_ERROR();

    drawQuad(mProgram, "position", 0.5f);

    EXPECT_PIXEL_COLOR_EQ(0, 0, GLColor::green);
}

// Test that drawing works correctly when levels outside the BASE_LEVEL/MAX_LEVEL range do not
// have images defined.
TEST_P(Texture2DTestES3, DrawWithLevelsOutsideRangeUndefined)
{
    if (IsAMD() && getPlatformRenderer() == EGL_PLATFORM_ANGLE_TYPE_OPENGL_ANGLE)
    {
        // Observed crashing on AMD. Oddly the crash only happens with 2D textures, not 3D or array.
        std::cout << "Test skipped on AMD OpenGL." << std::endl;
        return;
    }
    if (IsOSX())
    {
        // Observed incorrect rendering on OSX.
        std::cout << "Test skipped on OSX." << std::endl;
        return;
    }
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, mTexture2D);
    std::vector<GLColor> texDataGreen(2u * 2u, GLColor::green);
    glTexImage2D(GL_TEXTURE_2D, 1, GL_RGBA8, 2, 2, 0, GL_RGBA, GL_UNSIGNED_BYTE,
                 texDataGreen.data());
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_BASE_LEVEL, 1);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAX_LEVEL, 1);

    EXPECT_GL_NO_ERROR();

    drawQuad(mProgram, "position", 0.5f);

    EXPECT_PIXEL_COLOR_EQ(0, 0, GLColor::green);
}

// Test that drawing works correctly when level 0 is undefined and base level is 1.
TEST_P(Texture2DTestES3, DrawWithLevelZeroUndefined)
{
    if (IsAMD() && getPlatformRenderer() == EGL_PLATFORM_ANGLE_TYPE_OPENGL_ANGLE)
    {
        // Observed crashing on AMD. Oddly the crash only happens with 2D textures, not 3D or array.
        std::cout << "Test skipped on AMD OpenGL." << std::endl;
        return;
    }
    if (IsOSX())
    {
        // Observed incorrect rendering on OSX.
        std::cout << "Test skipped on OSX." << std::endl;
        return;
    }
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, mTexture2D);
    std::vector<GLColor> texDataGreen(2u * 2u, GLColor::green);
    glTexImage2D(GL_TEXTURE_2D, 1, GL_RGBA8, 2, 2, 0, GL_RGBA, GL_UNSIGNED_BYTE,
                 texDataGreen.data());
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_BASE_LEVEL, 1);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAX_LEVEL, 2);

    EXPECT_GL_NO_ERROR();

    // Texture is incomplete.
    drawQuad(mProgram, "position", 0.5f);
    EXPECT_PIXEL_COLOR_EQ(0, 0, GLColor::black);

    glTexImage2D(GL_TEXTURE_2D, 2, GL_RGBA8, 1, 1, 0, GL_RGBA, GL_UNSIGNED_BYTE,
                 texDataGreen.data());

    // Texture is now complete.
    drawQuad(mProgram, "position", 0.5f);
    EXPECT_PIXEL_COLOR_EQ(0, 0, GLColor::green);
}

// Test that drawing works correctly when levels outside the BASE_LEVEL/MAX_LEVEL range have
// dimensions that don't fit the images inside the range.
// GLES 3.0.4 section 3.8.13 Texture completeness
TEST_P(Texture2DTestES3, DrawWithLevelsOutsideRangeWithInconsistentDimensions)
{
    if (IsOSX())
    {
        // Observed incorrect rendering on OSX.
        std::cout << "Test skipped on OSX." << std::endl;
        return;
    }
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, mTexture2D);
    std::vector<GLColor> texDataRed(8u * 8u, GLColor::red);
    std::vector<GLColor> texDataGreen(2u * 2u, GLColor::green);
    std::vector<GLColor> texDataCyan(2u * 2u, GLColor::cyan);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);

    // Two levels that are initially unused.
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, 8, 8, 0, GL_RGBA, GL_UNSIGNED_BYTE, texDataRed.data());
    glTexImage2D(GL_TEXTURE_2D, 2, GL_RGBA8, 2, 2, 0, GL_RGBA, GL_UNSIGNED_BYTE,
                 texDataCyan.data());

    // One level that is used - only this level should affect completeness.
    glTexImage2D(GL_TEXTURE_2D, 1, GL_RGBA8, 2, 2, 0, GL_RGBA, GL_UNSIGNED_BYTE,
                 texDataGreen.data());

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_BASE_LEVEL, 1);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAX_LEVEL, 1);

    EXPECT_GL_NO_ERROR();

    drawQuad(mProgram, "position", 0.5f);

    EXPECT_PIXEL_COLOR_EQ(0, 0, GLColor::green);

    if (IsIntel() && getPlatformRenderer() == EGL_PLATFORM_ANGLE_TYPE_OPENGL_ANGLE)
    {
        // Intel was observed drawing color 0,0,0,0 instead of the texture color after the base
        // level was changed.
        std::cout << "Test partially skipped on Intel OpenGL." << std::endl;
        return;
    }

    // Switch the level that is being used to the cyan level 2.
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_BASE_LEVEL, 2);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAX_LEVEL, 2);

    EXPECT_GL_NO_ERROR();

    drawQuad(mProgram, "position", 0.5f);

    EXPECT_PIXEL_COLOR_EQ(0, 0, GLColor::cyan);
}

// Test that drawing works correctly when levels outside the BASE_LEVEL/MAX_LEVEL range do not
// have images defined.
TEST_P(Texture3DTestES3, DrawWithLevelsOutsideRangeUndefined)
{
    if (IsOSX())
    {
        // Observed incorrect rendering on OSX.
        std::cout << "Test skipped on OSX." << std::endl;
        return;
    }
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_3D, mTexture3D);
    std::vector<GLColor> texDataGreen(2u * 2u * 2u, GLColor::green);
    glTexImage3D(GL_TEXTURE_3D, 1, GL_RGBA8, 2, 2, 2, 0, GL_RGBA, GL_UNSIGNED_BYTE,
                 texDataGreen.data());
    glTexParameteri(GL_TEXTURE_3D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_3D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
    glTexParameteri(GL_TEXTURE_3D, GL_TEXTURE_BASE_LEVEL, 1);
    glTexParameteri(GL_TEXTURE_3D, GL_TEXTURE_MAX_LEVEL, 1);

    EXPECT_GL_NO_ERROR();

    drawQuad(mProgram, "position", 0.5f);

    EXPECT_PIXEL_COLOR_EQ(0, 0, GLColor::green);
}

// Test that drawing works correctly when levels outside the BASE_LEVEL/MAX_LEVEL range have
// dimensions that don't fit the images inside the range.
// GLES 3.0.4 section 3.8.13 Texture completeness
TEST_P(Texture3DTestES3, DrawWithLevelsOutsideRangeWithInconsistentDimensions)
{
    if (IsOSX())
    {
        // Observed incorrect rendering on OSX.
        std::cout << "Test skipped on OSX." << std::endl;
        return;
    }
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_3D, mTexture3D);
    std::vector<GLColor> texDataRed(8u * 8u * 8u, GLColor::red);
    std::vector<GLColor> texDataGreen(2u * 2u * 2u, GLColor::green);
    std::vector<GLColor> texDataCyan(2u * 2u * 2u, GLColor::cyan);

    glTexParameteri(GL_TEXTURE_3D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_3D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);

    // Two levels that are initially unused.
    glTexImage3D(GL_TEXTURE_3D, 0, GL_RGBA8, 8, 8, 8, 0, GL_RGBA, GL_UNSIGNED_BYTE,
                 texDataRed.data());
    glTexImage3D(GL_TEXTURE_3D, 2, GL_RGBA8, 2, 2, 2, 0, GL_RGBA, GL_UNSIGNED_BYTE,
                 texDataCyan.data());

    // One level that is used - only this level should affect completeness.
    glTexImage3D(GL_TEXTURE_3D, 1, GL_RGBA8, 2, 2, 2, 0, GL_RGBA, GL_UNSIGNED_BYTE,
                 texDataGreen.data());

    glTexParameteri(GL_TEXTURE_3D, GL_TEXTURE_BASE_LEVEL, 1);
    glTexParameteri(GL_TEXTURE_3D, GL_TEXTURE_MAX_LEVEL, 1);

    EXPECT_GL_NO_ERROR();

    drawQuad(mProgram, "position", 0.5f);

    EXPECT_PIXEL_COLOR_EQ(0, 0, GLColor::green);

    if (IsIntel() && getPlatformRenderer() == EGL_PLATFORM_ANGLE_TYPE_OPENGL_ANGLE)
    {
        // Intel was observed drawing color 0,0,0,0 instead of the texture color after the base
        // level was changed.
        std::cout << "Test partially skipped on Intel OpenGL." << std::endl;
        return;
    }

    // Switch the level that is being used to the cyan level 2.
    glTexParameteri(GL_TEXTURE_3D, GL_TEXTURE_BASE_LEVEL, 2);
    glTexParameteri(GL_TEXTURE_3D, GL_TEXTURE_MAX_LEVEL, 2);

    EXPECT_GL_NO_ERROR();

    drawQuad(mProgram, "position", 0.5f);

    EXPECT_PIXEL_COLOR_EQ(0, 0, GLColor::cyan);
}

// Test that drawing works correctly when levels outside the BASE_LEVEL/MAX_LEVEL range do not
// have images defined.
TEST_P(Texture2DArrayTestES3, DrawWithLevelsOutsideRangeUndefined)
{
    if (IsOSX())
    {
        // Observed incorrect rendering on OSX.
        std::cout << "Test skipped on OSX." << std::endl;
        return;
    }
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D_ARRAY, m2DArrayTexture);
    std::vector<GLColor> texDataGreen(2u * 2u * 2u, GLColor::green);
    glTexImage3D(GL_TEXTURE_2D_ARRAY, 1, GL_RGBA8, 2, 2, 2, 0, GL_RGBA, GL_UNSIGNED_BYTE,
                 texDataGreen.data());
    glTexParameteri(GL_TEXTURE_2D_ARRAY, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D_ARRAY, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
    glTexParameteri(GL_TEXTURE_2D_ARRAY, GL_TEXTURE_BASE_LEVEL, 1);
    glTexParameteri(GL_TEXTURE_2D_ARRAY, GL_TEXTURE_MAX_LEVEL, 1);

    EXPECT_GL_NO_ERROR();

    drawQuad(mProgram, "position", 0.5f);

    EXPECT_PIXEL_COLOR_EQ(0, 0, GLColor::green);
}

// Test that drawing works correctly when levels outside the BASE_LEVEL/MAX_LEVEL range have
// dimensions that don't fit the images inside the range.
// GLES 3.0.4 section 3.8.13 Texture completeness
TEST_P(Texture2DArrayTestES3, DrawWithLevelsOutsideRangeWithInconsistentDimensions)
{
    if (IsOSX())
    {
        // Observed incorrect rendering on OSX.
        std::cout << "Test skipped on OSX." << std::endl;
        return;
    }
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_3D, m2DArrayTexture);
    std::vector<GLColor> texDataRed(8u * 8u * 8u, GLColor::red);
    std::vector<GLColor> texDataGreen(2u * 2u * 2u, GLColor::green);
    std::vector<GLColor> texDataCyan(2u * 2u * 2u, GLColor::cyan);

    glTexParameteri(GL_TEXTURE_2D_ARRAY, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D_ARRAY, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);

    // Two levels that are initially unused.
    glTexImage3D(GL_TEXTURE_2D_ARRAY, 0, GL_RGBA8, 8, 8, 8, 0, GL_RGBA, GL_UNSIGNED_BYTE,
                 texDataRed.data());
    glTexImage3D(GL_TEXTURE_2D_ARRAY, 2, GL_RGBA8, 2, 2, 2, 0, GL_RGBA, GL_UNSIGNED_BYTE,
                 texDataCyan.data());

    // One level that is used - only this level should affect completeness.
    glTexImage3D(GL_TEXTURE_2D_ARRAY, 1, GL_RGBA8, 2, 2, 2, 0, GL_RGBA, GL_UNSIGNED_BYTE,
                 texDataGreen.data());

    glTexParameteri(GL_TEXTURE_2D_ARRAY, GL_TEXTURE_BASE_LEVEL, 1);
    glTexParameteri(GL_TEXTURE_2D_ARRAY, GL_TEXTURE_MAX_LEVEL, 1);

    EXPECT_GL_NO_ERROR();

    drawQuad(mProgram, "position", 0.5f);

    EXPECT_PIXEL_COLOR_EQ(0, 0, GLColor::green);

    if (IsIntel() && getPlatformRenderer() == EGL_PLATFORM_ANGLE_TYPE_OPENGL_ANGLE)
    {
        // Intel was observed drawing color 0,0,0,0 instead of the texture color after the base
        // level was changed.
        std::cout << "Test partially skipped on Intel OpenGL." << std::endl;
        return;
    }
    if (IsNVIDIA() && (getPlatformRenderer() == EGL_PLATFORM_ANGLE_TYPE_OPENGL_ANGLE ||
                       getPlatformRenderer() == EGL_PLATFORM_ANGLE_TYPE_OPENGLES_ANGLE))
    {
        // NVIDIA was observed drawing color 0,0,0,0 instead of the texture color after the base
        // level was changed.
        std::cout << "Test partially skipped on NVIDIA OpenGL." << std::endl;
        return;
    }

    // Switch the level that is being used to the cyan level 2.
    glTexParameteri(GL_TEXTURE_2D_ARRAY, GL_TEXTURE_BASE_LEVEL, 2);
    glTexParameteri(GL_TEXTURE_2D_ARRAY, GL_TEXTURE_MAX_LEVEL, 2);

    EXPECT_GL_NO_ERROR();

    drawQuad(mProgram, "position", 0.5f);

    EXPECT_PIXEL_COLOR_EQ(0, 0, GLColor::cyan);
}

// Test that texture completeness is updated if texture max level changes.
// GLES 3.0.4 section 3.8.13 Texture completeness
TEST_P(Texture2DTestES3, TextureCompletenessChangesWithMaxLevel)
{
    if (IsIntel() && getPlatformRenderer() == EGL_PLATFORM_ANGLE_TYPE_OPENGL_ANGLE)
    {
        // Intel was observed having wrong behavior after the texture is made incomplete by changing
        // the base level.
        std::cout << "Test skipped on Intel OpenGL." << std::endl;
        return;
    }
    if (IsOSX())
    {
        // Observed incorrect rendering on OSX.
        std::cout << "Test skipped on OSX." << std::endl;
        return;
    }

    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, mTexture2D);
    std::vector<GLColor> texDataGreen(8u * 8u, GLColor::green);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);

    // A level that is initially unused.
    glTexImage2D(GL_TEXTURE_2D, 1, GL_RGBA8, 8, 8, 0, GL_RGBA, GL_UNSIGNED_BYTE,
                 texDataGreen.data());

    // One level that is initially used - only this level should affect completeness.
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, 2, 2, 0, GL_RGBA, GL_UNSIGNED_BYTE,
                 texDataGreen.data());

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_BASE_LEVEL, 0);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAX_LEVEL, 0);

    EXPECT_GL_NO_ERROR();

    drawQuad(mProgram, "position", 0.5f);

    EXPECT_PIXEL_COLOR_EQ(0, 0, GLColor::green);

    // Switch the max level to level 1. The levels within the used range now have inconsistent
    // dimensions and the texture should be incomplete.
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAX_LEVEL, 1);

    EXPECT_GL_NO_ERROR();

    drawQuad(mProgram, "position", 0.5f);

    EXPECT_PIXEL_COLOR_EQ(0, 0, GLColor::black);
}

// Test that 3D texture completeness is updated if texture max level changes.
// GLES 3.0.4 section 3.8.13 Texture completeness
TEST_P(Texture3DTestES3, Texture3DCompletenessChangesWithMaxLevel)
{
    if (IsIntel() && getPlatformRenderer() == EGL_PLATFORM_ANGLE_TYPE_OPENGL_ANGLE)
    {
        // Intel was observed having wrong behavior after the texture is made incomplete by changing
        // the base level.
        std::cout << "Test skipped on Intel OpenGL." << std::endl;
        return;
    }
    if (IsOSX())
    {
        // Observed incorrect rendering on OSX.
        std::cout << "Test skipped on OSX." << std::endl;
        return;
    }

    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_3D, mTexture3D);
    std::vector<GLColor> texDataGreen(2u * 2u * 2u, GLColor::green);

    glTexParameteri(GL_TEXTURE_3D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_3D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);

    // A level that is initially unused.
    glTexImage3D(GL_TEXTURE_3D, 1, GL_RGBA8, 1, 1, 2, 0, GL_RGBA, GL_UNSIGNED_BYTE,
                 texDataGreen.data());

    // One level that is initially used - only this level should affect completeness.
    glTexImage3D(GL_TEXTURE_3D, 0, GL_RGBA8, 2, 2, 2, 0, GL_RGBA, GL_UNSIGNED_BYTE,
                 texDataGreen.data());

    glTexParameteri(GL_TEXTURE_3D, GL_TEXTURE_BASE_LEVEL, 0);
    glTexParameteri(GL_TEXTURE_3D, GL_TEXTURE_MAX_LEVEL, 0);

    EXPECT_GL_NO_ERROR();

    drawQuad(mProgram, "position", 0.5f);

    EXPECT_PIXEL_COLOR_EQ(0, 0, GLColor::green);

    // Switch the max level to level 1. The levels within the used range now have inconsistent
    // dimensions and the texture should be incomplete.
    glTexParameteri(GL_TEXTURE_3D, GL_TEXTURE_MAX_LEVEL, 1);

    EXPECT_GL_NO_ERROR();

    drawQuad(mProgram, "position", 0.5f);

    EXPECT_PIXEL_COLOR_EQ(0, 0, GLColor::black);
}

// Test that texture completeness is updated if texture base level changes.
// GLES 3.0.4 section 3.8.13 Texture completeness
TEST_P(Texture2DTestES3, TextureCompletenessChangesWithBaseLevel)
{
    if (IsIntel() && getPlatformRenderer() == EGL_PLATFORM_ANGLE_TYPE_OPENGL_ANGLE)
    {
        // Intel was observed having wrong behavior after the texture is made incomplete by changing
        // the base level.
        std::cout << "Test skipped on Intel OpenGL." << std::endl;
        return;
    }

    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, mTexture2D);
    std::vector<GLColor> texDataGreen(8u * 8u, GLColor::green);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);

    // Two levels that are initially unused.
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, 8, 8, 0, GL_RGBA, GL_UNSIGNED_BYTE,
                 texDataGreen.data());
    glTexImage2D(GL_TEXTURE_2D, 1, GL_RGBA8, 2, 2, 0, GL_RGBA, GL_UNSIGNED_BYTE,
                 texDataGreen.data());

    // One level that is initially used - only this level should affect completeness.
    glTexImage2D(GL_TEXTURE_2D, 2, GL_RGBA8, 2, 2, 0, GL_RGBA, GL_UNSIGNED_BYTE,
                 texDataGreen.data());

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_BASE_LEVEL, 2);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAX_LEVEL, 2);

    EXPECT_GL_NO_ERROR();

    drawQuad(mProgram, "position", 0.5f);

    EXPECT_PIXEL_COLOR_EQ(0, 0, GLColor::green);

    // Switch the base level to level 1. The levels within the used range now have inconsistent
    // dimensions and the texture should be incomplete.
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_BASE_LEVEL, 1);

    EXPECT_GL_NO_ERROR();

    drawQuad(mProgram, "position", 0.5f);

    EXPECT_PIXEL_COLOR_EQ(0, 0, GLColor::black);
}

// Test that texture is not complete if base level is greater than max level.
// GLES 3.0.4 section 3.8.13 Texture completeness
TEST_P(Texture2DTestES3, TextureBaseLevelGreaterThanMaxLevel)
{
    if (IsIntel() && getPlatformRenderer() == EGL_PLATFORM_ANGLE_TYPE_OPENGL_ANGLE)
    {
        // Intel Windows OpenGL driver crashes if the base level of a non-immutable texture is out
        // of range.
        std::cout << "Test skipped on Intel OpenGL." << std::endl;
        return;
    }

    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, mTexture2D);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, 1, 1, 0, GL_RGBA, GL_UNSIGNED_BYTE, &GLColor::green);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_BASE_LEVEL, 10000);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAX_LEVEL, 0);

    EXPECT_GL_NO_ERROR();

    drawQuad(mProgram, "position", 0.5f);

    // Texture should be incomplete.
    EXPECT_PIXEL_COLOR_EQ(0, 0, GLColor::black);
}

// Test that immutable texture base level and max level are clamped.
// GLES 3.0.4 section 3.8.10 subsection Mipmapping
TEST_P(Texture2DTestES3, ImmutableTextureBaseLevelOutOfRange)
{
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, mTexture2D);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);

    glTexStorage2D(GL_TEXTURE_2D, 1, GL_RGBA8, 1, 1);

    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, 1, 1, GL_RGBA, GL_UNSIGNED_BYTE, &GLColor::green);

    // For immutable-format textures, base level should be clamped to [0, levels - 1], and max level
    // should be clamped to [base_level, levels - 1].
    // GLES 3.0.4 section 3.8.10 subsection Mipmapping
    // In the case of this test, those rules make the effective base level and max level 0.
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_BASE_LEVEL, 10000);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAX_LEVEL, 10000);

    EXPECT_GL_NO_ERROR();

    drawQuad(mProgram, "position", 0.5f);

    // Texture should be complete.
    EXPECT_PIXEL_COLOR_EQ(0, 0, GLColor::green);
}

// Test that changing base level works when it affects the format of the texture.
TEST_P(Texture2DTestES3, TextureFormatChangesWithBaseLevel)
{
    if (IsNVIDIA() && IsOpenGL())
    {
        // Observed rendering corruption on NVIDIA OpenGL.
        std::cout << "Test skipped on NVIDIA OpenGL." << std::endl;
        return;
    }
    if (IsIntel() && IsDesktopOpenGL())
    {
        // Observed incorrect rendering on Intel OpenGL.
        std::cout << "Test skipped on Intel OpenGL." << std::endl;
        return;
    }
    if (IsAMD() && IsDesktopOpenGL())
    {
        // Observed incorrect rendering on AMD OpenGL.
        std::cout << "Test skipped on AMD OpenGL." << std::endl;
        return;
    }

    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, mTexture2D);
    std::vector<GLColor> texDataCyan(4u * 4u, GLColor::cyan);
    std::vector<GLColor> texDataGreen(4u * 4u, GLColor::green);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);

    // RGBA8 level that's initially unused.
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, 4, 4, 0, GL_RGBA, GL_UNSIGNED_BYTE,
                 texDataCyan.data());

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_BASE_LEVEL, 1);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAX_LEVEL, 1);

    // RG8 level that's initially used, with consistent dimensions with level 0 but a different
    // format. It reads green channel data from the green and alpha channels of texDataGreen
    // (this is a bit hacky but works).
    glTexImage2D(GL_TEXTURE_2D, 1, GL_RG8, 2, 2, 0, GL_RG, GL_UNSIGNED_BYTE, texDataGreen.data());

    EXPECT_GL_NO_ERROR();

    drawQuad(mProgram, "position", 0.5f);

    EXPECT_PIXEL_COLOR_EQ(0, 0, GLColor::green);

    // Switch the texture to use the cyan level 0 with the RGBA format.
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_BASE_LEVEL, 0);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAX_LEVEL, 0);

    EXPECT_GL_NO_ERROR();

    drawQuad(mProgram, "position", 0.5f);

    EXPECT_PIXEL_COLOR_EQ(0, 0, GLColor::cyan);
}

// Test that setting a texture image works when base level is out of range.
TEST_P(Texture2DTestES3, SetImageWhenBaseLevelOutOfRange)
{
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, mTexture2D);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_BASE_LEVEL, 10000);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAX_LEVEL, 10000);

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, 1, 1, 0, GL_RGBA, GL_UNSIGNED_BYTE, &GLColor::green);

    EXPECT_GL_NO_ERROR();

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_BASE_LEVEL, 0);

    drawQuad(mProgram, "position", 0.5f);

    // Texture should be complete.
    EXPECT_PIXEL_COLOR_EQ(0, 0, GLColor::green);
}

// In the D3D11 renderer, we need to initialize some texture formats, to fill empty channels. EG RBA->RGBA8, with 1.0
// in the alpha channel. This test covers a bug where redefining array textures with these formats does not work as
// expected.
TEST_P(Texture2DArrayTestES3, RedefineInittableArray)
{
    std::vector<GLubyte> pixelData;
    for (size_t count = 0; count < 5000; count++)
    {
        pixelData.push_back(0u);
        pixelData.push_back(255u);
        pixelData.push_back(0u);
    }

    glBindTexture(GL_TEXTURE_2D_ARRAY, m2DArrayTexture);
    glUseProgram(mProgram);
    glUniform1i(mTextureArrayLocation, 0);

    // The first draw worked correctly.
    glTexImage3D(GL_TEXTURE_2D_ARRAY, 0, GL_RGB, 4, 4, 2, 0, GL_RGB, GL_UNSIGNED_BYTE, &pixelData[0]);

    glTexParameteri(GL_TEXTURE_2D_ARRAY, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D_ARRAY, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D_ARRAY, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D_ARRAY, GL_TEXTURE_WRAP_T, GL_REPEAT);
    drawQuad(mProgram, "position", 1.0f);
    EXPECT_PIXEL_COLOR_EQ(0, 0, GLColor::green);

    // The dimension of the respecification must match the original exactly to trigger the bug.
    glTexImage3D(GL_TEXTURE_2D_ARRAY, 0, GL_RGB, 4, 4, 2, 0, GL_RGB, GL_UNSIGNED_BYTE, &pixelData[0]);
    drawQuad(mProgram, "position", 1.0f);
    EXPECT_PIXEL_COLOR_EQ(0, 0, GLColor::green);

    ASSERT_GL_NO_ERROR();
}

// Test shadow sampler and regular non-shadow sampler coexisting in the same shader.
// This test is needed especially to confirm that sampler registers get assigned correctly on
// the HLSL backend even when there's a mix of different HLSL sampler and texture types.
TEST_P(ShadowSamplerPlusSampler3DTestES3, ShadowSamplerPlusSampler3DDraw)
{
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_3D, mTexture3D);
    GLubyte texData[4];
    texData[0] = 0;
    texData[1] = 60;
    texData[2] = 0;
    texData[3] = 255;
    glTexImage3D(GL_TEXTURE_3D, 0, GL_RGBA, 1, 1, 1, 0, GL_RGBA, GL_UNSIGNED_BYTE, texData);

    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, mTextureShadow);
    GLfloat depthTexData[1];
    depthTexData[0] = 0.5f;
    glTexImage2D(GL_TEXTURE_2D, 0, GL_DEPTH_COMPONENT32F, 1, 1, 0, GL_DEPTH_COMPONENT, GL_FLOAT,
                 depthTexData);

    glUseProgram(mProgram);
    glUniform1f(mDepthRefUniformLocation, 0.3f);
    glUniform1i(mTexture3DUniformLocation, 0);
    glUniform1i(mTextureShadowUniformLocation, 1);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_COMPARE_FUNC, GL_LEQUAL);
    drawQuad(mProgram, "position", 0.5f);
    EXPECT_GL_NO_ERROR();
    // The shader writes 0.5 * <comparison result (1.0)> + <texture color>
    EXPECT_PIXEL_NEAR(0, 0, 128, 188, 128, 255, 2);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_COMPARE_FUNC, GL_GREATER);
    drawQuad(mProgram, "position", 0.5f);
    EXPECT_GL_NO_ERROR();
    // The shader writes 0.5 * <comparison result (0.0)> + <texture color>
    EXPECT_PIXEL_NEAR(0, 0, 0, 60, 0, 255, 2);
}

// Test multiple different sampler types in the same shader.
// This test makes sure that even if sampler / texture registers get grouped together based on type
// or otherwise get shuffled around in the HLSL backend of the shader translator, the D3D renderer
// still has the right register index information for each ESSL sampler.
// The tested ESSL samplers have the following types in D3D11 HLSL:
// sampler2D:         Texture2D   + SamplerState
// samplerCube:       TextureCube + SamplerState
// sampler2DShadow:   Texture2D   + SamplerComparisonState
// samplerCubeShadow: TextureCube + SamplerComparisonState
TEST_P(SamplerTypeMixTestES3, SamplerTypeMixDraw)
{
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, mTexture2D);
    GLubyte texData[4];
    texData[0] = 0;
    texData[1] = 0;
    texData[2] = 120;
    texData[3] = 255;
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 1, 1, 0, GL_RGBA, GL_UNSIGNED_BYTE, texData);

    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_CUBE_MAP, mTextureCube);
    texData[0] = 0;
    texData[1] = 90;
    texData[2] = 0;
    texData[3] = 255;
    glTexStorage2D(GL_TEXTURE_CUBE_MAP, 1, GL_RGBA8, 1, 1);
    glTexSubImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_X, 0, 0, 0, 1, 1, GL_RGBA, GL_UNSIGNED_BYTE,
                    texData);

    glActiveTexture(GL_TEXTURE2);
    glBindTexture(GL_TEXTURE_2D, mTexture2DShadow);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_COMPARE_FUNC, GL_LEQUAL);
    GLfloat depthTexData[1];
    depthTexData[0] = 0.5f;
    glTexImage2D(GL_TEXTURE_2D, 0, GL_DEPTH_COMPONENT32F, 1, 1, 0, GL_DEPTH_COMPONENT, GL_FLOAT,
                 depthTexData);

    glActiveTexture(GL_TEXTURE3);
    glBindTexture(GL_TEXTURE_CUBE_MAP, mTextureCubeShadow);
    glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_COMPARE_FUNC, GL_LEQUAL);
    depthTexData[0] = 0.2f;
    glTexStorage2D(GL_TEXTURE_CUBE_MAP, 1, GL_DEPTH_COMPONENT32F, 1, 1);
    glTexSubImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_X, 0, 0, 0, 1, 1, GL_DEPTH_COMPONENT, GL_FLOAT,
                    depthTexData);

    EXPECT_GL_NO_ERROR();

    glUseProgram(mProgram);
    glUniform1f(mDepthRefUniformLocation, 0.3f);
    glUniform1i(mTexture2DUniformLocation, 0);
    glUniform1i(mTextureCubeUniformLocation, 1);
    glUniform1i(mTexture2DShadowUniformLocation, 2);
    glUniform1i(mTextureCubeShadowUniformLocation, 3);

    drawQuad(mProgram, "position", 0.5f);
    EXPECT_GL_NO_ERROR();
    // The shader writes:
    // <texture 2d color> +
    // <cube map color> +
    // 0.25 * <comparison result (1.0)> +
    // 0.125 * <comparison result (0.0)>
    EXPECT_PIXEL_NEAR(0, 0, 64, 154, 184, 255, 2);
}

// Test different base levels on textures accessed through the same sampler array.
// Calling textureSize() on the samplers hits the D3D sampler metadata workaround.
TEST_P(TextureSizeTextureArrayTest, BaseLevelVariesInTextureArray)
{
    if ((IsAMD() || IsIntel()) && getPlatformRenderer() == EGL_PLATFORM_ANGLE_TYPE_D3D11_ANGLE)
    {
        std::cout << "Test skipped on Intel and AMD D3D." << std::endl;
        return;
    }
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, mTexture2DA);
    GLsizei size = 64;
    for (GLint level = 0; level < 7; ++level)
    {
        ASSERT_LT(0, size);
        glTexImage2D(GL_TEXTURE_2D, level, GL_RGBA, size, size, 0, GL_RGBA, GL_UNSIGNED_BYTE,
                     nullptr);
        size = size / 2;
    }
    ASSERT_EQ(0, size);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_BASE_LEVEL, 1);

    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, mTexture2DB);
    size = 128;
    for (GLint level = 0; level < 8; ++level)
    {
        ASSERT_LT(0, size);
        glTexImage2D(GL_TEXTURE_2D, level, GL_RGBA, size, size, 0, GL_RGBA, GL_UNSIGNED_BYTE,
                     nullptr);
        size = size / 2;
    }
    ASSERT_EQ(0, size);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_BASE_LEVEL, 3);
    EXPECT_GL_NO_ERROR();

    glUseProgram(mProgram);
    glUniform1i(mTexture0Location, 0);
    glUniform1i(mTexture1Location, 1);

    drawQuad(mProgram, "position", 0.5f);
    EXPECT_GL_NO_ERROR();
    // Red channel: width of level 1 of texture A: 32.
    // Green channel: width of level 3 of texture B: 16.
    EXPECT_PIXEL_NEAR(0, 0, 32, 16, 0, 255, 2);
}

// When sampling a texture without an alpha channel, "1" is returned as the alpha value.
// ES 3.0.4 table 3.24
TEST_P(Texture2DTestES3, TextureRGBImplicitAlpha1)
{
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, mTexture2D);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB8, 1, 1, 0, GL_RGB, GL_UNSIGNED_BYTE, nullptr);
    EXPECT_GL_NO_ERROR();

    drawQuad(mProgram, "position", 0.5f);

    EXPECT_PIXEL_ALPHA_EQ(0, 0, 255);
}

// When sampling a texture without an alpha channel, "1" is returned as the alpha value.
// ES 3.0.4 table 3.24
TEST_P(Texture2DTestES3, TextureLuminanceImplicitAlpha1)
{
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, mTexture2D);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_LUMINANCE, 1, 1, 0, GL_LUMINANCE, GL_UNSIGNED_BYTE, nullptr);
    EXPECT_GL_NO_ERROR();

    drawQuad(mProgram, "position", 0.5f);

    EXPECT_PIXEL_ALPHA_EQ(0, 0, 255);
}

// When sampling a texture without an alpha channel, "1" is returned as the alpha value.
// ES 3.0.4 table 3.24
TEST_P(Texture2DTestES3, TextureLuminance32ImplicitAlpha1)
{
    if (extensionEnabled("GL_OES_texture_float"))
    {
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, mTexture2D);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_LUMINANCE, 1, 1, 0, GL_LUMINANCE, GL_FLOAT, nullptr);
        EXPECT_GL_NO_ERROR();

        drawQuad(mProgram, "position", 0.5f);

        EXPECT_PIXEL_ALPHA_EQ(0, 0, 255);
    }
}

// When sampling a texture without an alpha channel, "1" is returned as the alpha value.
// ES 3.0.4 table 3.24
TEST_P(Texture2DTestES3, TextureLuminance16ImplicitAlpha1)
{
    if (extensionEnabled("GL_OES_texture_half_float"))
    {
        if (IsNVIDIA() && IsOpenGLES())
        {
            std::cout << "Test skipped on NVIDIA" << std::endl;
            return;
        }
        // TODO(ynovikov): re-enable once root cause of http://anglebug.com/1420 is fixed
        if (IsAndroid() && IsAdreno() && IsOpenGLES())
        {
            std::cout << "Test skipped on Adreno OpenGLES on Android." << std::endl;
            return;
        }

        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, mTexture2D);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_LUMINANCE, 1, 1, 0, GL_LUMINANCE, GL_HALF_FLOAT_OES,
                     nullptr);
        EXPECT_GL_NO_ERROR();

        drawQuad(mProgram, "position", 0.5f);

        EXPECT_PIXEL_ALPHA_EQ(0, 0, 255);
    }
}

// When sampling a texture without an alpha channel, "1" is returned as the alpha value.
// ES 3.0.4 table 3.24
TEST_P(Texture2DUnsignedIntegerAlpha1TestES3, TextureRGB8UIImplicitAlpha1)
{
    if (IsIntel())
    {
        std::cout << "Test disabled on Intel." << std::endl;
        return;
    }
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, mTexture2D);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB8UI, 1, 1, 0, GL_RGB_INTEGER, GL_UNSIGNED_BYTE, nullptr);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    EXPECT_GL_NO_ERROR();

    drawQuad(mProgram, "position", 0.5f);

    EXPECT_PIXEL_ALPHA_EQ(0, 0, 255);
}

// When sampling a texture without an alpha channel, "1" is returned as the alpha value.
// ES 3.0.4 table 3.24
TEST_P(Texture2DIntegerAlpha1TestES3, TextureRGB8IImplicitAlpha1)
{
    if (IsIntel())
    {
        std::cout << "Test disabled on Intel." << std::endl;
        return;
    }
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, mTexture2D);

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB8I, 1, 1, 0, GL_RGB_INTEGER, GL_BYTE, nullptr);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    EXPECT_GL_NO_ERROR();

    drawQuad(mProgram, "position", 0.5f);

    EXPECT_PIXEL_ALPHA_EQ(0, 0, 255);
}

// When sampling a texture without an alpha channel, "1" is returned as the alpha value.
// ES 3.0.4 table 3.24
TEST_P(Texture2DUnsignedIntegerAlpha1TestES3, TextureRGB16UIImplicitAlpha1)
{
    if (IsIntel())
    {
        std::cout << "Test disabled on Intel." << std::endl;
        return;
    }
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, mTexture2D);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB16UI, 1, 1, 0, GL_RGB_INTEGER, GL_UNSIGNED_SHORT, nullptr);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    EXPECT_GL_NO_ERROR();

    drawQuad(mProgram, "position", 0.5f);

    EXPECT_PIXEL_ALPHA_EQ(0, 0, 255);
}

// When sampling a texture without an alpha channel, "1" is returned as the alpha value.
// ES 3.0.4 table 3.24
TEST_P(Texture2DIntegerAlpha1TestES3, TextureRGB16IImplicitAlpha1)
{
    if (IsIntel())
    {
        std::cout << "Test disabled on Intel." << std::endl;
        return;
    }
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, mTexture2D);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB16I, 1, 1, 0, GL_RGB_INTEGER, GL_SHORT, nullptr);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    EXPECT_GL_NO_ERROR();

    drawQuad(mProgram, "position", 0.5f);

    EXPECT_PIXEL_ALPHA_EQ(0, 0, 255);
}

// When sampling a texture without an alpha channel, "1" is returned as the alpha value.
// ES 3.0.4 table 3.24
TEST_P(Texture2DUnsignedIntegerAlpha1TestES3, TextureRGB32UIImplicitAlpha1)
{
    if (IsIntel())
    {
        std::cout << "Test disabled on Intel." << std::endl;
        return;
    }
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, mTexture2D);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB32UI, 1, 1, 0, GL_RGB_INTEGER, GL_UNSIGNED_INT, nullptr);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    EXPECT_GL_NO_ERROR();

    drawQuad(mProgram, "position", 0.5f);

    EXPECT_PIXEL_ALPHA_EQ(0, 0, 255);
}

// When sampling a texture without an alpha channel, "1" is returned as the alpha value.
// ES 3.0.4 table 3.24
TEST_P(Texture2DIntegerAlpha1TestES3, TextureRGB32IImplicitAlpha1)
{
    if (IsIntel())
    {
        std::cout << "Test disabled on Intel." << std::endl;
        return;
    }
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, mTexture2D);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB32I, 1, 1, 0, GL_RGB_INTEGER, GL_INT, nullptr);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    EXPECT_GL_NO_ERROR();

    drawQuad(mProgram, "position", 0.5f);

    EXPECT_PIXEL_ALPHA_EQ(0, 0, 255);
}

// When sampling a texture without an alpha channel, "1" is returned as the alpha value.
// ES 3.0.4 table 3.24
TEST_P(Texture2DTestES3, TextureRGBSNORMImplicitAlpha1)
{
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, mTexture2D);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB8_SNORM, 1, 1, 0, GL_RGB, GL_BYTE, nullptr);
    EXPECT_GL_NO_ERROR();

    drawQuad(mProgram, "position", 0.5f);

    EXPECT_PIXEL_ALPHA_EQ(0, 0, 255);
}

// When sampling a texture without an alpha channel, "1" is returned as the alpha value.
// ES 3.0.4 table 3.24
TEST_P(Texture2DTestES3, TextureRGB9E5ImplicitAlpha1)
{
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, mTexture2D);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB9_E5, 1, 1, 0, GL_RGB, GL_UNSIGNED_INT_5_9_9_9_REV,
                 nullptr);
    EXPECT_GL_NO_ERROR();

    drawQuad(mProgram, "position", 0.5f);

    EXPECT_PIXEL_ALPHA_EQ(0, 0, 255);
}

// When sampling a texture without an alpha channel, "1" is returned as the alpha value.
// ES 3.0.4 table 3.24
TEST_P(Texture2DTestES3, TextureCOMPRESSEDRGB8ETC2ImplicitAlpha1)
{
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, mTexture2D);
    glCompressedTexImage2D(GL_TEXTURE_2D, 0, GL_COMPRESSED_RGB8_ETC2, 1, 1, 0, 8, nullptr);
    EXPECT_GL_NO_ERROR();

    drawQuad(mProgram, "position", 0.5f);

    EXPECT_PIXEL_ALPHA_EQ(0, 0, 255);
}

// When sampling a texture without an alpha channel, "1" is returned as the alpha value.
// ES 3.0.4 table 3.24
TEST_P(Texture2DTestES3, TextureCOMPRESSEDSRGB8ETC2ImplicitAlpha1)
{
    if (IsIntel() && IsLinux())
    {
        // TODO(cwallez): Fix on Linux Intel drivers (http://anglebug.com/1346)
        std::cout << "Test disabled on Linux Intel OpenGL." << std::endl;
        return;
    }

    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, mTexture2D);
    glCompressedTexImage2D(GL_TEXTURE_2D, 0, GL_COMPRESSED_SRGB8_ETC2, 1, 1, 0, 8, nullptr);
    EXPECT_GL_NO_ERROR();

    drawQuad(mProgram, "position", 0.5f);

    EXPECT_PIXEL_ALPHA_EQ(0, 0, 255);
}

// Use a sampler in a uniform struct.
TEST_P(SamplerInStructTest, SamplerInStruct)
{
    runSamplerInStructTest();
}

// Use a sampler in a uniform struct that's passed as a function parameter.
TEST_P(SamplerInStructAsFunctionParameterTest, SamplerInStructAsFunctionParameter)
{
    // TODO(ynovikov): re-enable once root cause of http://anglebug.com/1427 is fixed
    if (IsAndroid() && IsAdreno() && IsOpenGLES())
    {
        std::cout << "Test skipped on Adreno OpenGLES on Android." << std::endl;
        return;
    }

    if (IsWindows() && IsIntel() && IsOpenGL())
    {
        std::cout << "Test skipped on Windows OpenGL on Intel." << std::endl;
        return;
    }

    runSamplerInStructTest();
}

// Use a sampler in a uniform struct array with a struct from the array passed as a function
// parameter.
TEST_P(SamplerInStructArrayAsFunctionParameterTest, SamplerInStructArrayAsFunctionParameter)
{
    if (IsIntel() && GetParam().getRenderer() == EGL_PLATFORM_ANGLE_TYPE_OPENGL_ANGLE)
    {
        std::cout << "Test skipped on Intel OpenGL." << std::endl;
        return;
    }
    // TODO(ynovikov): re-enable once root cause of http://anglebug.com/1427 is fixed
    if (IsAndroid() && IsAdreno() && IsOpenGLES())
    {
        std::cout << "Test skipped on Adreno OpenGLES on Android." << std::endl;
        return;
    }
    runSamplerInStructTest();
}

// Use a sampler in a struct inside a uniform struct with the nested struct passed as a function
// parameter.
TEST_P(SamplerInNestedStructAsFunctionParameterTest, SamplerInNestedStructAsFunctionParameter)
{
    if (IsIntel() && GetParam().getRenderer() == EGL_PLATFORM_ANGLE_TYPE_OPENGL_ANGLE)
    {
        std::cout << "Test skipped on Intel OpenGL." << std::endl;
        return;
    }
    // TODO(ynovikov): re-enable once root cause of http://anglebug.com/1427 is fixed
    if (IsAndroid() && IsAdreno() && IsOpenGLES())
    {
        std::cout << "Test skipped on Adreno OpenGLES on Android." << std::endl;
        return;
    }
    runSamplerInStructTest();
}

// Make sure that there isn't a name conflict between sampler extracted from a struct and a
// similarly named uniform.
TEST_P(SamplerInStructAndOtherVariableTest, SamplerInStructAndOtherVariable)
{
    runSamplerInStructTest();
}

class TextureLimitsTest : public ANGLETest
{
  protected:
    struct RGBA8
    {
        uint8_t R, G, B, A;
    };

    TextureLimitsTest()
        : mProgram(0), mMaxVertexTextures(0), mMaxFragmentTextures(0), mMaxCombinedTextures(0)
    {
        setWindowWidth(128);
        setWindowHeight(128);
        setConfigRedBits(8);
        setConfigGreenBits(8);
        setConfigBlueBits(8);
        setConfigAlphaBits(8);
    }

    ~TextureLimitsTest()
    {
        if (mProgram != 0)
        {
            glDeleteProgram(mProgram);
            mProgram = 0;

            if (!mTextures.empty())
            {
                glDeleteTextures(static_cast<GLsizei>(mTextures.size()), &mTextures[0]);
            }
        }
    }

    void SetUp() override
    {
        ANGLETest::SetUp();

        glGetIntegerv(GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS, &mMaxVertexTextures);
        glGetIntegerv(GL_MAX_TEXTURE_IMAGE_UNITS, &mMaxFragmentTextures);
        glGetIntegerv(GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS, &mMaxCombinedTextures);

        ASSERT_GL_NO_ERROR();
    }

    void compileProgramWithTextureCounts(const std::string &vertexPrefix,
                                         GLint vertexTextureCount,
                                         GLint vertexActiveTextureCount,
                                         const std::string &fragPrefix,
                                         GLint fragmentTextureCount,
                                         GLint fragmentActiveTextureCount)
    {
        std::stringstream vertexShaderStr;
        vertexShaderStr << "attribute vec2 position;\n"
                        << "varying vec4 color;\n"
                        << "varying vec2 texCoord;\n";

        for (GLint textureIndex = 0; textureIndex < vertexTextureCount; ++textureIndex)
        {
            vertexShaderStr << "uniform sampler2D " << vertexPrefix << textureIndex << ";\n";
        }

        vertexShaderStr << "void main() {\n"
                        << "  gl_Position = vec4(position, 0, 1);\n"
                        << "  texCoord = (position * 0.5) + 0.5;\n"
                        << "  color = vec4(0);\n";

        for (GLint textureIndex = 0; textureIndex < vertexActiveTextureCount; ++textureIndex)
        {
            vertexShaderStr << "  color += texture2D(" << vertexPrefix << textureIndex
                            << ", texCoord);\n";
        }

        vertexShaderStr << "}";

        std::stringstream fragmentShaderStr;
        fragmentShaderStr << "varying mediump vec4 color;\n"
                          << "varying mediump vec2 texCoord;\n";

        for (GLint textureIndex = 0; textureIndex < fragmentTextureCount; ++textureIndex)
        {
            fragmentShaderStr << "uniform sampler2D " << fragPrefix << textureIndex << ";\n";
        }

        fragmentShaderStr << "void main() {\n"
                          << "  gl_FragColor = color;\n";

        for (GLint textureIndex = 0; textureIndex < fragmentActiveTextureCount; ++textureIndex)
        {
            fragmentShaderStr << "  gl_FragColor += texture2D(" << fragPrefix << textureIndex
                              << ", texCoord);\n";
        }

        fragmentShaderStr << "}";

        const std::string &vertexShaderSource   = vertexShaderStr.str();
        const std::string &fragmentShaderSource = fragmentShaderStr.str();

        mProgram = CompileProgram(vertexShaderSource, fragmentShaderSource);
    }

    RGBA8 getPixel(GLint texIndex)
    {
        RGBA8 pixel = {static_cast<uint8_t>(texIndex & 0x7u), static_cast<uint8_t>(texIndex >> 3),
                       0, 255u};
        return pixel;
    }

    void initTextures(GLint tex2DCount, GLint texCubeCount)
    {
        GLint totalCount = tex2DCount + texCubeCount;
        mTextures.assign(totalCount, 0);
        glGenTextures(totalCount, &mTextures[0]);
        ASSERT_GL_NO_ERROR();

        std::vector<RGBA8> texData(16 * 16);

        GLint texIndex = 0;
        for (; texIndex < tex2DCount; ++texIndex)
        {
            texData.assign(texData.size(), getPixel(texIndex));
            glActiveTexture(GL_TEXTURE0 + texIndex);
            glBindTexture(GL_TEXTURE_2D, mTextures[texIndex]);
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 16, 16, 0, GL_RGBA, GL_UNSIGNED_BYTE,
                         &texData[0]);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        }

        ASSERT_GL_NO_ERROR();

        for (; texIndex < texCubeCount; ++texIndex)
        {
            texData.assign(texData.size(), getPixel(texIndex));
            glActiveTexture(GL_TEXTURE0 + texIndex);
            glBindTexture(GL_TEXTURE_CUBE_MAP, mTextures[texIndex]);
            glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_X, 0, GL_RGBA, 16, 16, 0, GL_RGBA,
                         GL_UNSIGNED_BYTE, &texData[0]);
            glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_Y, 0, GL_RGBA, 16, 16, 0, GL_RGBA,
                         GL_UNSIGNED_BYTE, &texData[0]);
            glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_Z, 0, GL_RGBA, 16, 16, 0, GL_RGBA,
                         GL_UNSIGNED_BYTE, &texData[0]);
            glTexImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_X, 0, GL_RGBA, 16, 16, 0, GL_RGBA,
                         GL_UNSIGNED_BYTE, &texData[0]);
            glTexImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_Y, 0, GL_RGBA, 16, 16, 0, GL_RGBA,
                         GL_UNSIGNED_BYTE, &texData[0]);
            glTexImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_Z, 0, GL_RGBA, 16, 16, 0, GL_RGBA,
                         GL_UNSIGNED_BYTE, &texData[0]);
            glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
            glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
            glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
            glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        }

        ASSERT_GL_NO_ERROR();
    }

    void testWithTextures(GLint vertexTextureCount,
                          const std::string &vertexTexturePrefix,
                          GLint fragmentTextureCount,
                          const std::string &fragmentTexturePrefix)
    {
        // Generate textures
        initTextures(vertexTextureCount + fragmentTextureCount, 0);

        glUseProgram(mProgram);
        RGBA8 expectedSum = {0};
        for (GLint texIndex = 0; texIndex < vertexTextureCount; ++texIndex)
        {
            std::stringstream uniformNameStr;
            uniformNameStr << vertexTexturePrefix << texIndex;
            const std::string &uniformName = uniformNameStr.str();
            GLint location = glGetUniformLocation(mProgram, uniformName.c_str());
            ASSERT_NE(-1, location);

            glUniform1i(location, texIndex);
            RGBA8 contribution = getPixel(texIndex);
            expectedSum.R += contribution.R;
            expectedSum.G += contribution.G;
        }

        for (GLint texIndex = 0; texIndex < fragmentTextureCount; ++texIndex)
        {
            std::stringstream uniformNameStr;
            uniformNameStr << fragmentTexturePrefix << texIndex;
            const std::string &uniformName = uniformNameStr.str();
            GLint location = glGetUniformLocation(mProgram, uniformName.c_str());
            ASSERT_NE(-1, location);

            glUniform1i(location, texIndex + vertexTextureCount);
            RGBA8 contribution = getPixel(texIndex + vertexTextureCount);
            expectedSum.R += contribution.R;
            expectedSum.G += contribution.G;
        }

        ASSERT_GE(256u, expectedSum.G);

        drawQuad(mProgram, "position", 0.5f);
        ASSERT_GL_NO_ERROR();
        EXPECT_PIXEL_EQ(0, 0, expectedSum.R, expectedSum.G, 0, 255);
    }

    GLuint mProgram;
    std::vector<GLuint> mTextures;
    GLint mMaxVertexTextures;
    GLint mMaxFragmentTextures;
    GLint mMaxCombinedTextures;
};

// Test rendering with the maximum vertex texture units.
TEST_P(TextureLimitsTest, MaxVertexTextures)
{
    // TODO(jmadill): Figure out why this fails on Intel.
    if (IsIntel() && GetParam().getRenderer() == EGL_PLATFORM_ANGLE_TYPE_OPENGL_ANGLE)
    {
        std::cout << "Test skipped on Intel." << std::endl;
        return;
    }

    compileProgramWithTextureCounts("tex", mMaxVertexTextures, mMaxVertexTextures, "tex", 0, 0);
    ASSERT_NE(0u, mProgram);
    ASSERT_GL_NO_ERROR();

    testWithTextures(mMaxVertexTextures, "tex", 0, "tex");
}

// Test rendering with the maximum fragment texture units.
TEST_P(TextureLimitsTest, MaxFragmentTextures)
{
    // TODO(jmadill): Figure out why this fails on Intel.
    if (IsIntel() && GetParam().getRenderer() == EGL_PLATFORM_ANGLE_TYPE_OPENGL_ANGLE)
    {
        std::cout << "Test skipped on Intel." << std::endl;
        return;
    }

    compileProgramWithTextureCounts("tex", 0, 0, "tex", mMaxFragmentTextures, mMaxFragmentTextures);
    ASSERT_NE(0u, mProgram);
    ASSERT_GL_NO_ERROR();

    testWithTextures(mMaxFragmentTextures, "tex", 0, "tex");
}

// Test rendering with maximum combined texture units.
TEST_P(TextureLimitsTest, MaxCombinedTextures)
{
    // TODO(jmadill): Investigate workaround.
    if (IsIntel() && GetParam() == ES2_OPENGL())
    {
        std::cout << "Test skipped on Intel." << std::endl;
        return;
    }

    GLint vertexTextures = mMaxVertexTextures;

    if (vertexTextures + mMaxFragmentTextures > mMaxCombinedTextures)
    {
        vertexTextures = mMaxCombinedTextures - mMaxFragmentTextures;
    }

    compileProgramWithTextureCounts("vtex", vertexTextures, vertexTextures, "ftex",
                                    mMaxFragmentTextures, mMaxFragmentTextures);
    ASSERT_NE(0u, mProgram);
    ASSERT_GL_NO_ERROR();

    testWithTextures(vertexTextures, "vtex", mMaxFragmentTextures, "ftex");
}

// Negative test for exceeding the number of vertex textures
TEST_P(TextureLimitsTest, ExcessiveVertexTextures)
{
    compileProgramWithTextureCounts("tex", mMaxVertexTextures + 1, mMaxVertexTextures + 1, "tex", 0,
                                    0);
    ASSERT_EQ(0u, mProgram);
}

// Negative test for exceeding the number of fragment textures
TEST_P(TextureLimitsTest, ExcessiveFragmentTextures)
{
    compileProgramWithTextureCounts("tex", 0, 0, "tex", mMaxFragmentTextures + 1,
                                    mMaxFragmentTextures + 1);
    ASSERT_EQ(0u, mProgram);
}

// Test active vertex textures under the limit, but excessive textures specified.
TEST_P(TextureLimitsTest, MaxActiveVertexTextures)
{
    // TODO(jmadill): Figure out why this fails on Intel.
    if (IsIntel() && GetParam().getRenderer() == EGL_PLATFORM_ANGLE_TYPE_OPENGL_ANGLE)
    {
        std::cout << "Test skipped on Intel." << std::endl;
        return;
    }

    compileProgramWithTextureCounts("tex", mMaxVertexTextures + 4, mMaxVertexTextures, "tex", 0, 0);
    ASSERT_NE(0u, mProgram);
    ASSERT_GL_NO_ERROR();

    testWithTextures(mMaxVertexTextures, "tex", 0, "tex");
}

// Test active fragment textures under the limit, but excessive textures specified.
TEST_P(TextureLimitsTest, MaxActiveFragmentTextures)
{
    // TODO(jmadill): Figure out why this fails on Intel.
    if (IsIntel() && GetParam().getRenderer() == EGL_PLATFORM_ANGLE_TYPE_OPENGL_ANGLE)
    {
        std::cout << "Test skipped on Intel." << std::endl;
        return;
    }

    compileProgramWithTextureCounts("tex", 0, 0, "tex", mMaxFragmentTextures + 4,
                                    mMaxFragmentTextures);
    ASSERT_NE(0u, mProgram);
    ASSERT_GL_NO_ERROR();

    testWithTextures(0, "tex", mMaxFragmentTextures, "tex");
}

// Negative test for pointing two sampler uniforms of different types to the same texture.
// GLES 2.0.25 section 2.10.4 page 39.
TEST_P(TextureLimitsTest, TextureTypeConflict)
{
    const std::string &vertexShader =
        "attribute vec2 position;\n"
        "varying float color;\n"
        "uniform sampler2D tex2D;\n"
        "uniform samplerCube texCube;\n"
        "void main() {\n"
        "  gl_Position = vec4(position, 0, 1);\n"
        "  vec2 texCoord = (position * 0.5) + 0.5;\n"
        "  color = texture2D(tex2D, texCoord).x;\n"
        "  color += textureCube(texCube, vec3(texCoord, 0)).x;\n"
        "}";
    const std::string &fragmentShader =
        "varying mediump float color;\n"
        "void main() {\n"
        "  gl_FragColor = vec4(color, 0, 0, 1);\n"
        "}";

    mProgram = CompileProgram(vertexShader, fragmentShader);
    ASSERT_NE(0u, mProgram);

    initTextures(1, 0);

    glUseProgram(mProgram);
    GLint tex2DLocation = glGetUniformLocation(mProgram, "tex2D");
    ASSERT_NE(-1, tex2DLocation);
    GLint texCubeLocation = glGetUniformLocation(mProgram, "texCube");
    ASSERT_NE(-1, texCubeLocation);

    glUniform1i(tex2DLocation, 0);
    glUniform1i(texCubeLocation, 0);
    ASSERT_GL_NO_ERROR();

    drawQuad(mProgram, "position", 0.5f);
    EXPECT_GL_ERROR(GL_INVALID_OPERATION);
}

// Negative test for rendering with texture outside the valid range.
// TODO(jmadill): Possibly adjust the test according to the spec:
// GLES 3.0.4 section 2.12.7 mentions that specifying an out-of-range sampler uniform value
// generates an INVALID_VALUE error - GLES 2.0 doesn't yet have this mention.
TEST_P(TextureLimitsTest, DrawWithTexturePastMaximum)
{
    const std::string &vertexShader =
        "attribute vec2 position;\n"
        "varying float color;\n"
        "uniform sampler2D tex2D;\n"
        "void main() {\n"
        "  gl_Position = vec4(position, 0, 1);\n"
        "  vec2 texCoord = (position * 0.5) + 0.5;\n"
        "  color = texture2D(tex2D, texCoord).x;\n"
        "}";
    const std::string &fragmentShader =
        "varying mediump float color;\n"
        "void main() {\n"
        "  gl_FragColor = vec4(color, 0, 0, 1);\n"
        "}";

    mProgram = CompileProgram(vertexShader, fragmentShader);
    ASSERT_NE(0u, mProgram);

    glUseProgram(mProgram);
    GLint tex2DLocation = glGetUniformLocation(mProgram, "tex2D");
    ASSERT_NE(-1, tex2DLocation);

    glUniform1i(tex2DLocation, mMaxCombinedTextures);
    ASSERT_GL_NO_ERROR();

    drawQuad(mProgram, "position", 0.5f);
    EXPECT_GL_ERROR(GL_INVALID_OPERATION);
}

class Texture2DNorm16TestES3 : public Texture2DTestES3
{
  protected:
    Texture2DNorm16TestES3() : Texture2DTestES3(), mTextures{0, 0, 0}, mFBO(0), mRenderbuffer(0) {}

    void SetUp() override
    {
        Texture2DTestES3::SetUp();

        glActiveTexture(GL_TEXTURE0);
        glGenTextures(3, mTextures);
        glGenFramebuffers(1, &mFBO);
        glGenRenderbuffers(1, &mRenderbuffer);

        for (size_t textureIndex = 0; textureIndex < 3; textureIndex++)
        {
            glBindTexture(GL_TEXTURE_2D, mTextures[textureIndex]);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        }

        glBindTexture(GL_TEXTURE_2D, 0);

        ASSERT_GL_NO_ERROR();
    }

    void TearDown() override
    {
        glDeleteTextures(3, mTextures);
        glDeleteFramebuffers(1, &mFBO);
        glDeleteRenderbuffers(1, &mRenderbuffer);

        Texture2DTestES3::TearDown();
    }

    void testNorm16Texture(GLint internalformat, GLenum format, GLenum type)
    {
        GLushort pixelValue  = (type == GL_SHORT) ? 0x7FFF : 0x6A35;
        GLushort imageData[] = {pixelValue, pixelValue, pixelValue, pixelValue};

        setUpProgram();

        glBindFramebuffer(GL_FRAMEBUFFER, mFBO);
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, mTextures[0],
                               0);

        glBindTexture(GL_TEXTURE_2D, mTextures[0]);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA16_EXT, 1, 1, 0, GL_RGBA, GL_UNSIGNED_SHORT, nullptr);

        glBindTexture(GL_TEXTURE_2D, mTextures[1]);
        glTexImage2D(GL_TEXTURE_2D, 0, internalformat, 1, 1, 0, format, type, imageData);

        EXPECT_GL_NO_ERROR();

        drawQuad(mProgram, "position", 0.5f);

        GLubyte expectedValue = (type == GL_SHORT) ? 0xFF : static_cast<GLubyte>(pixelValue >> 8);

        EXPECT_PIXEL_COLOR_EQ(
            0, 0, SliceFormatColor(
                      format, GLColor(expectedValue, expectedValue, expectedValue, expectedValue)));

        glBindFramebuffer(GL_FRAMEBUFFER, 0);

        ASSERT_GL_NO_ERROR();
    }

    void testNorm16Render(GLint internalformat, GLenum format, GLenum type)
    {
        GLushort pixelValue = 0x6A35;
        GLushort imageData[] = {pixelValue, pixelValue, pixelValue, pixelValue};

        setUpProgram();

        glBindTexture(GL_TEXTURE_2D, mTextures[1]);
        glTexImage2D(GL_TEXTURE_2D, 0, internalformat, 1, 1, 0, format, type, nullptr);

        glBindFramebuffer(GL_FRAMEBUFFER, mFBO);
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, mTextures[1],
                               0);

        glBindTexture(GL_TEXTURE_2D, mTextures[2]);
        glTexImage2D(GL_TEXTURE_2D, 0, internalformat, 1, 1, 0, format, type, imageData);

        EXPECT_GL_NO_ERROR();

        drawQuad(mProgram, "position", 0.5f);

        GLubyte expectedValue = static_cast<GLubyte>(pixelValue >> 8);
        EXPECT_PIXEL_COLOR_EQ(
            0, 0, SliceFormatColor(
                      format, GLColor(expectedValue, expectedValue, expectedValue, expectedValue)));

        glBindRenderbuffer(GL_RENDERBUFFER, mRenderbuffer);
        glRenderbufferStorage(GL_RENDERBUFFER, internalformat, 1, 1);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER,
                                  mRenderbuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, 0);
        EXPECT_GL_NO_ERROR();

        glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT);

        glCopyTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, 0, 0, 1, 1);

        EXPECT_PIXEL_COLOR_EQ(0, 0, SliceFormatColor(format, GLColor::white));

        glBindFramebuffer(GL_FRAMEBUFFER, 0);

        ASSERT_GL_NO_ERROR();
    }

    GLuint mTextures[3];
    GLuint mFBO;
    GLuint mRenderbuffer;
};

// Test texture formats enabled by the GL_EXT_texture_norm16 extension.
TEST_P(Texture2DNorm16TestES3, TextureNorm16Test)
{
    if (!extensionEnabled("GL_EXT_texture_norm16"))
    {
        std::cout << "Test skipped due to missing GL_EXT_texture_norm16." << std::endl;
        return;
    }

    testNorm16Texture(GL_R16_EXT, GL_RED, GL_UNSIGNED_SHORT);
    testNorm16Texture(GL_RG16_EXT, GL_RG, GL_UNSIGNED_SHORT);
    testNorm16Texture(GL_RGB16_EXT, GL_RGB, GL_UNSIGNED_SHORT);
    testNorm16Texture(GL_RGBA16_EXT, GL_RGBA, GL_UNSIGNED_SHORT);
    testNorm16Texture(GL_R16_SNORM_EXT, GL_RED, GL_SHORT);
    testNorm16Texture(GL_RG16_SNORM_EXT, GL_RG, GL_SHORT);
    testNorm16Texture(GL_RGB16_SNORM_EXT, GL_RGB, GL_SHORT);
    testNorm16Texture(GL_RGBA16_SNORM_EXT, GL_RGBA, GL_SHORT);

    testNorm16Render(GL_R16_EXT, GL_RED, GL_UNSIGNED_SHORT);
    testNorm16Render(GL_RG16_EXT, GL_RG, GL_UNSIGNED_SHORT);
    testNorm16Render(GL_RGBA16_EXT, GL_RGBA, GL_UNSIGNED_SHORT);
}

// Test that UNPACK_SKIP_IMAGES doesn't have an effect on 2D texture uploads.
// GLES 3.0.4 section 3.8.3.
TEST_P(Texture2DTestES3, UnpackSkipImages2D)
{
    if (IsIntel() && IsDesktopOpenGL())
    {
        std::cout << "Test skipped on Intel OpenGL." << std::endl;
        return;
    }
    // TODO(ynovikov): re-enable once root cause of http://anglebug.com/1429 is fixed
    if (IsAndroid() && IsAdreno() && IsOpenGLES())
    {
        std::cout << "Test skipped on Adreno OpenGLES on Android." << std::endl;
        return;
    }

    glBindTexture(GL_TEXTURE_2D, mTexture2D);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    ASSERT_GL_NO_ERROR();

    // SKIP_IMAGES should not have an effect on uploading 2D textures
    glPixelStorei(GL_UNPACK_SKIP_IMAGES, 1000);
    ASSERT_GL_NO_ERROR();

    std::vector<GLColor> pixelsGreen(128u * 128u, GLColor::green);

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, 128, 128, 0, GL_RGBA, GL_UNSIGNED_BYTE,
                 pixelsGreen.data());
    ASSERT_GL_NO_ERROR();

    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, 128, 128, GL_RGBA, GL_UNSIGNED_BYTE,
                    pixelsGreen.data());
    ASSERT_GL_NO_ERROR();

    glUseProgram(mProgram);
    drawQuad(mProgram, "position", 0.5f);
    ASSERT_GL_NO_ERROR();

    EXPECT_PIXEL_COLOR_EQ(0, 0, GLColor::green);
}

// Test that skip defined in unpack parameters is taken into account when determining whether
// unpacking source extends outside unpack buffer bounds.
TEST_P(Texture2DTestES3, UnpackSkipPixelsOutOfBounds)
{
    glBindTexture(GL_TEXTURE_2D, mTexture2D);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    ASSERT_GL_NO_ERROR();

    GLBuffer buf;
    glBindBuffer(GL_PIXEL_UNPACK_BUFFER, buf.get());
    std::vector<GLColor> pixelsGreen(128u * 128u, GLColor::green);
    glBufferData(GL_PIXEL_UNPACK_BUFFER, pixelsGreen.size() * 4u, pixelsGreen.data(),
                 GL_DYNAMIC_COPY);
    ASSERT_GL_NO_ERROR();

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, 128, 128, 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
    ASSERT_GL_NO_ERROR();

    glPixelStorei(GL_UNPACK_SKIP_PIXELS, 1);
    ASSERT_GL_NO_ERROR();

    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, 128, 128, GL_RGBA, GL_UNSIGNED_BYTE, 0);
    EXPECT_GL_ERROR(GL_INVALID_OPERATION);

    glPixelStorei(GL_UNPACK_SKIP_PIXELS, 0);
    glPixelStorei(GL_UNPACK_SKIP_ROWS, 1);
    ASSERT_GL_NO_ERROR();

    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, 128, 128, GL_RGBA, GL_UNSIGNED_BYTE, 0);
    EXPECT_GL_ERROR(GL_INVALID_OPERATION);
}

// Test that unpacking rows that overlap in a pixel unpack buffer works as expected.
TEST_P(Texture2DTestES3, UnpackOverlappingRowsFromUnpackBuffer)
{
    if (IsD3D11())
    {
        std::cout << "Test skipped on D3D." << std::endl;
        return;
    }
    if (IsOSX() && IsAMD())
    {
        // Incorrect rendering results seen on OSX AMD.
        std::cout << "Test skipped on OSX AMD." << std::endl;
        return;
    }

    const GLuint width            = 8u;
    const GLuint height           = 8u;
    const GLuint unpackRowLength  = 5u;
    const GLuint unpackSkipPixels = 1u;

    setWindowWidth(width);
    setWindowHeight(height);

    glBindTexture(GL_TEXTURE_2D, mTexture2D);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    ASSERT_GL_NO_ERROR();

    GLBuffer buf;
    glBindBuffer(GL_PIXEL_UNPACK_BUFFER, buf.get());
    std::vector<GLColor> pixelsGreen((height - 1u) * unpackRowLength + width + unpackSkipPixels,
                                     GLColor::green);

    for (GLuint skippedPixel = 0u; skippedPixel < unpackSkipPixels; ++skippedPixel)
    {
        pixelsGreen[skippedPixel] = GLColor(255, 0, 0, 255);
    }

    glBufferData(GL_PIXEL_UNPACK_BUFFER, pixelsGreen.size() * 4u, pixelsGreen.data(),
                 GL_DYNAMIC_COPY);
    ASSERT_GL_NO_ERROR();

    glPixelStorei(GL_UNPACK_ROW_LENGTH, unpackRowLength);
    glPixelStorei(GL_UNPACK_SKIP_PIXELS, unpackSkipPixels);
    ASSERT_GL_NO_ERROR();

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
    ASSERT_GL_NO_ERROR();

    glUseProgram(mProgram);
    drawQuad(mProgram, "position", 0.5f);
    ASSERT_GL_NO_ERROR();

    GLuint windowPixelCount = getWindowWidth() * getWindowHeight();
    std::vector<GLColor> actual(windowPixelCount, GLColor::black);
    glReadPixels(0, 0, getWindowWidth(), getWindowHeight(), GL_RGBA, GL_UNSIGNED_BYTE,
                 actual.data());
    std::vector<GLColor> expected(windowPixelCount, GLColor::green);
    EXPECT_EQ(expected, actual);
}

template <typename T>
T UNorm(double value)
{
    return static_cast<T>(value * static_cast<double>(std::numeric_limits<T>::max()));
}

// Test rendering a depth texture with mipmaps.
TEST_P(Texture2DTestES3, DepthTexturesWithMipmaps)
{
    //TODO(cwallez) this is failing on Intel Win7 OpenGL
    if (IsIntel() && IsWindows() && IsOpenGL())
    {
        std::cout << "Test skipped on Intel OpenGL." << std::endl;
        return;
    }

    const int size = getWindowWidth();

    auto dim   = [size](int level) { return size >> level; };
    int levels = gl::log2(size);

    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, mTexture2D);
    glTexStorage2D(GL_TEXTURE_2D, levels, GL_DEPTH_COMPONENT24, size, size);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST_MIPMAP_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    ASSERT_GL_NO_ERROR();

    glUseProgram(mProgram);
    glUniform1i(mTexture2DUniformLocation, 0);

    std::vector<unsigned char> expected;

    for (int level = 0; level < levels; ++level)
    {
        double value = (static_cast<double>(level) / static_cast<double>(levels - 1));
        expected.push_back(UNorm<unsigned char>(value));

        int levelDim = dim(level);

        ASSERT_GT(levelDim, 0);

        std::vector<unsigned int> initData(levelDim * levelDim, UNorm<unsigned int>(value));
        glTexSubImage2D(GL_TEXTURE_2D, level, 0, 0, levelDim, levelDim, GL_DEPTH_COMPONENT,
                        GL_UNSIGNED_INT, initData.data());
    }
    ASSERT_GL_NO_ERROR();

    for (int level = 0; level < levels; ++level)
    {
        glViewport(0, 0, dim(level), dim(level));
        drawQuad(mProgram, "position", 0.5f);
        GLColor actual = ReadColor(0, 0);
        EXPECT_NEAR(expected[level], actual.R, 10u);
    }

    ASSERT_GL_NO_ERROR();
}

// Tests unpacking into the unsized GL_ALPHA format.
TEST_P(Texture2DTestES3, UnsizedAlphaUnpackBuffer)
{
    // TODO(jmadill): Figure out why this fails on OSX.
    ANGLE_SKIP_TEST_IF(IsOSX());

    // Initialize the texure.
    glBindTexture(GL_TEXTURE_2D, mTexture2D);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_ALPHA, getWindowWidth(), getWindowHeight(), 0, GL_ALPHA,
                 GL_UNSIGNED_BYTE, nullptr);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);

    std::vector<GLubyte> bufferData(getWindowWidth() * getWindowHeight(), 127);

    // Pull in the color data from the unpack buffer.
    GLBuffer unpackBuffer;
    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    glBindBuffer(GL_PIXEL_UNPACK_BUFFER, unpackBuffer.get());
    glBufferData(GL_PIXEL_UNPACK_BUFFER, getWindowWidth() * getWindowHeight(), bufferData.data(),
                 GL_STATIC_DRAW);

    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, getWindowWidth(), getWindowHeight(), GL_ALPHA,
                    GL_UNSIGNED_BYTE, nullptr);

    // Clear to a weird color to make sure we're drawing something.
    glClearColor(0.5f, 0.8f, 1.0f, 0.2f);
    glClear(GL_COLOR_BUFFER_BIT);

    // Draw with the alpha texture and verify.
    drawQuad(mProgram, "position", 0.5f);

    ASSERT_GL_NO_ERROR();
    EXPECT_PIXEL_NEAR(0, 0, 0, 0, 0, 127, 1);
}

// Ensure stale unpack data doesn't propagate in D3D11.
TEST_P(Texture2DTestES3, StaleUnpackData)
{
    // Init unpack buffer.
    GLsizei pixelCount = getWindowWidth() * getWindowHeight() / 2;
    std::vector<GLColor> pixels(pixelCount, GLColor::red);

    GLBuffer unpackBuffer;
    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    glBindBuffer(GL_PIXEL_UNPACK_BUFFER, unpackBuffer.get());
    GLsizei bufferSize = pixelCount * sizeof(GLColor);
    glBufferData(GL_PIXEL_UNPACK_BUFFER, bufferSize, pixels.data(), GL_STATIC_DRAW);

    // Create from unpack buffer.
    glBindTexture(GL_TEXTURE_2D, mTexture2D);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, getWindowWidth() / 2, getWindowHeight() / 2, 0,
                 GL_RGBA, GL_UNSIGNED_BYTE, nullptr);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);

    drawQuad(mProgram, "position", 0.5f);

    ASSERT_GL_NO_ERROR();
    EXPECT_PIXEL_COLOR_EQ(0, 0, GLColor::red);

    // Fill unpack with green, recreating buffer.
    pixels.assign(getWindowWidth() * getWindowHeight(), GLColor::green);
    GLsizei size2 = getWindowWidth() * getWindowHeight() * sizeof(GLColor);
    glBufferData(GL_PIXEL_UNPACK_BUFFER, size2, pixels.data(), GL_STATIC_DRAW);

    // Reinit texture with green.
    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, getWindowWidth() / 2, getWindowHeight() / 2, GL_RGBA,
                    GL_UNSIGNED_BYTE, nullptr);

    drawQuad(mProgram, "position", 0.5f);

    ASSERT_GL_NO_ERROR();
    EXPECT_PIXEL_COLOR_EQ(0, 0, GLColor::green);
}

// This test covers a D3D format redefinition bug for 3D textures. The base level format was not
// being properly checked, and the texture storage of the previous texture format was persisting.
// This would result in an ASSERT in debug and incorrect rendering in release.
// See http://anglebug.com/1609 and WebGL 2 test conformance2/misc/views-with-offsets.html.
TEST_P(Texture3DTestES3, FormatRedefinitionBug)
{
    GLTexture tex;
    glBindTexture(GL_TEXTURE_3D, tex.get());
    glTexImage3D(GL_TEXTURE_3D, 0, GL_RGBA8, 1, 1, 1, 0, GL_RGBA, GL_UNSIGNED_BYTE, nullptr);

    GLFramebuffer framebuffer;
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer.get());
    glFramebufferTextureLayer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, tex.get(), 0, 0);

    glCheckFramebufferStatus(GL_FRAMEBUFFER);

    std::vector<uint8_t> pixelData(100, 0);

    glTexImage3D(GL_TEXTURE_3D, 0, GL_RGB565, 1, 1, 1, 0, GL_RGB, GL_UNSIGNED_SHORT_5_6_5, nullptr);
    glTexSubImage3D(GL_TEXTURE_3D, 0, 0, 0, 0, 1, 1, 1, GL_RGB, GL_UNSIGNED_SHORT_5_6_5,
                    pixelData.data());

    ASSERT_GL_NO_ERROR();
}

// Use this to select which configurations (e.g. which renderer, which GLES major version) these tests should be run against.
// TODO(oetuaho): Enable all below tests on OpenGL. Requires a fix for ANGLE bug 1278.
ANGLE_INSTANTIATE_TEST(Texture2DTest,
                       ES2_D3D9(),
                       ES2_D3D11(),
                       ES2_D3D11_FL9_3(),
                       ES2_OPENGL(),
                       ES2_OPENGLES());
ANGLE_INSTANTIATE_TEST(TextureCubeTest,
                       ES2_D3D9(),
                       ES2_D3D11(),
                       ES2_D3D11_FL9_3(),
                       ES2_OPENGL(),
                       ES2_OPENGLES());
ANGLE_INSTANTIATE_TEST(Texture2DTestWithDrawScale,
                       ES2_D3D9(),
                       ES2_D3D11(),
                       ES2_D3D11_FL9_3(),
                       ES2_OPENGL(),
                       ES2_OPENGLES());
ANGLE_INSTANTIATE_TEST(Sampler2DAsFunctionParameterTest,
                       ES2_D3D9(),
                       ES2_D3D11(),
                       ES2_D3D11_FL9_3(),
                       ES2_OPENGL(),
                       ES2_OPENGLES());
ANGLE_INSTANTIATE_TEST(SamplerArrayTest,
                       ES2_D3D9(),
                       ES2_D3D11(),
                       ES2_D3D11_FL9_3(),
                       ES2_OPENGL(),
                       ES2_OPENGLES());
ANGLE_INSTANTIATE_TEST(SamplerArrayAsFunctionParameterTest,
                       ES2_D3D9(),
                       ES2_D3D11(),
                       ES2_D3D11_FL9_3(),
                       ES2_OPENGL(),
                       ES2_OPENGLES());
ANGLE_INSTANTIATE_TEST(Texture2DTestES3, ES3_D3D11(), ES3_OPENGL(), ES3_OPENGLES());
ANGLE_INSTANTIATE_TEST(Texture3DTestES3, ES3_D3D11(), ES3_OPENGL(), ES3_OPENGLES());
ANGLE_INSTANTIATE_TEST(Texture2DIntegerAlpha1TestES3, ES3_D3D11(), ES3_OPENGL(), ES3_OPENGLES());
ANGLE_INSTANTIATE_TEST(Texture2DUnsignedIntegerAlpha1TestES3,
                       ES3_D3D11(),
                       ES3_OPENGL(),
                       ES3_OPENGLES());
ANGLE_INSTANTIATE_TEST(ShadowSamplerPlusSampler3DTestES3,
                       ES3_D3D11(),
                       ES3_OPENGL(),
                       ES3_OPENGLES());
ANGLE_INSTANTIATE_TEST(SamplerTypeMixTestES3, ES3_D3D11(), ES3_OPENGL(), ES3_OPENGLES());
ANGLE_INSTANTIATE_TEST(Texture2DArrayTestES3, ES3_D3D11(), ES3_OPENGL(), ES3_OPENGLES());
ANGLE_INSTANTIATE_TEST(TextureSizeTextureArrayTest, ES3_D3D11(), ES3_OPENGL());
ANGLE_INSTANTIATE_TEST(SamplerInStructTest,
                       ES2_D3D11(),
                       ES2_D3D11_FL9_3(),
                       ES2_D3D9(),
                       ES2_OPENGL(),
                       ES2_OPENGLES());
ANGLE_INSTANTIATE_TEST(SamplerInStructAsFunctionParameterTest,
                       ES2_D3D11(),
                       ES2_D3D11_FL9_3(),
                       ES2_D3D9(),
                       ES2_OPENGL(),
                       ES2_OPENGLES());
ANGLE_INSTANTIATE_TEST(SamplerInStructArrayAsFunctionParameterTest,
                       ES2_D3D11(),
                       ES2_D3D11_FL9_3(),
                       ES2_D3D9(),
                       ES2_OPENGL(),
                       ES2_OPENGLES());
ANGLE_INSTANTIATE_TEST(SamplerInNestedStructAsFunctionParameterTest,
                       ES2_D3D11(),
                       ES2_D3D11_FL9_3(),
                       ES2_D3D9(),
                       ES2_OPENGL(),
                       ES2_OPENGLES());
ANGLE_INSTANTIATE_TEST(SamplerInStructAndOtherVariableTest,
                       ES2_D3D11(),
                       ES2_D3D11_FL9_3(),
                       ES2_D3D9(),
                       ES2_OPENGL(),
                       ES2_OPENGLES());
ANGLE_INSTANTIATE_TEST(TextureLimitsTest, ES2_D3D11(), ES2_OPENGL(), ES2_OPENGLES());
ANGLE_INSTANTIATE_TEST(Texture2DNorm16TestES3, ES3_D3D11(), ES3_OPENGL(), ES3_OPENGLES());

}  // anonymous namespace
