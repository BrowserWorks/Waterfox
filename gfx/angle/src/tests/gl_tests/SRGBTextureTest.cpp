//
// Copyright 2015 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//

#include "test_utils/ANGLETest.h"
#include "test_utils/gl_raii.h"

namespace angle
{

class SRGBTextureTest : public ANGLETest
{
  protected:
    SRGBTextureTest()
    {
        setWindowWidth(128);
        setWindowHeight(128);
        setConfigRedBits(8);
        setConfigGreenBits(8);
        setConfigBlueBits(8);
        setConfigAlphaBits(8);
    }

    void SetUp() override
    {
        ANGLETest::SetUp();

        const std::string vs =
            "precision highp float;\n"
            "attribute vec4 position;\n"
            "varying vec2 texcoord;\n"
            "\n"
            "void main()\n"
            "{\n"
            "   gl_Position = vec4(position.xy, 0.0, 1.0);\n"
            "   texcoord = (position.xy * 0.5) + 0.5;\n"
            "}\n";

        const std::string fs =
            "precision highp float;\n"
            "uniform sampler2D tex;\n"
            "varying vec2 texcoord;\n"
            "\n"
            "void main()\n"
            "{\n"
            "   gl_FragColor = texture2D(tex, texcoord);\n"
            "}\n";

        mProgram = CompileProgram(vs, fs);
        ASSERT_NE(0u, mProgram);

        mTextureLocation = glGetUniformLocation(mProgram, "tex");
        ASSERT_NE(-1, mTextureLocation);
    }

    void TearDown() override
    {
        glDeleteProgram(mProgram);

        ANGLETest::TearDown();
    }

    GLuint mProgram        = 0;
    GLint mTextureLocation = -1;
};

TEST_P(SRGBTextureTest, SRGBValidation)
{
    bool supported = extensionEnabled("GL_EXT_sRGB") || getClientMajorVersion() == 3;

    GLuint tex = 0;
    glGenTextures(1, &tex);
    glBindTexture(GL_TEXTURE_2D, tex);

    GLubyte pixel[3] = { 0 };
    glTexImage2D(GL_TEXTURE_2D, 0, GL_SRGB, 1, 1, 0, GL_SRGB, GL_UNSIGNED_BYTE, pixel);
    if (supported)
    {
        EXPECT_GL_NO_ERROR();

        glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, 0, 0, GL_SRGB, GL_UNSIGNED_BYTE, pixel);
        EXPECT_GL_NO_ERROR();

        glGenerateMipmap(GL_TEXTURE_2D);
        EXPECT_GL_ERROR(GL_INVALID_OPERATION);
    }
    else
    {
        EXPECT_GL_ERROR(GL_INVALID_ENUM);
    }

    glDeleteTextures(1, &tex);
}

TEST_P(SRGBTextureTest, SRGBAValidation)
{
    bool supported = extensionEnabled("GL_EXT_sRGB") || getClientMajorVersion() == 3;

    GLuint tex = 0;
    glGenTextures(1, &tex);
    glBindTexture(GL_TEXTURE_2D, tex);

    GLubyte pixel[4] = { 0 };
    glTexImage2D(GL_TEXTURE_2D, 0, GL_SRGB_ALPHA_EXT, 1, 1, 0, GL_SRGB_ALPHA_EXT, GL_UNSIGNED_BYTE, pixel);
    if (supported)
    {
        EXPECT_GL_NO_ERROR();

        glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, 0, 0, GL_SRGB_ALPHA_EXT, GL_UNSIGNED_BYTE, pixel);
        EXPECT_GL_NO_ERROR();

        glGenerateMipmap(GL_TEXTURE_2D);
        if (getClientMajorVersion() == 2)
        {
            EXPECT_GL_ERROR(GL_INVALID_OPERATION);
        }
        else
        {
            EXPECT_GL_NO_ERROR();
        }
    }
    else
    {
        EXPECT_GL_ERROR(GL_INVALID_ENUM);
    }

    glDeleteTextures(1, &tex);
}

TEST_P(SRGBTextureTest, SRGBARenderbuffer)
{
    bool supported = extensionEnabled("GL_EXT_sRGB") || getClientMajorVersion() == 3;

    GLuint rbo = 0;
    glGenRenderbuffers(1, &rbo);
    glBindRenderbuffer(GL_RENDERBUFFER, rbo);

    glRenderbufferStorage(GL_RENDERBUFFER, GL_SRGB8_ALPHA8_EXT, 1, 1);
    if (supported)
    {
        EXPECT_GL_NO_ERROR();
    }
    else
    {
        EXPECT_GL_ERROR(GL_INVALID_ENUM);

        // Make sure the rbo has a size for future tests
        glRenderbufferStorage(GL_RENDERBUFFER, GL_RGBA8_OES, 1, 1);
        EXPECT_GL_NO_ERROR();
    }

    GLuint fbo = 0;
    glGenFramebuffers(1, &fbo);
    glBindFramebuffer(GL_FRAMEBUFFER, fbo);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, rbo);
    EXPECT_GL_NO_ERROR();

    GLint colorEncoding = 0;
    glGetFramebufferAttachmentParameteriv(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                                          GL_FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING_EXT, &colorEncoding);
    if (supported)
    {
        EXPECT_GL_NO_ERROR();
        EXPECT_EQ(GL_SRGB_EXT, colorEncoding);
    }
    else
    {
        EXPECT_GL_ERROR(GL_INVALID_ENUM);
    }

    glDeleteFramebuffers(1, &fbo);
    glDeleteRenderbuffers(1, &rbo);
}

// Verify that if the srgb decode extension is available, srgb textures are too
TEST_P(SRGBTextureTest, SRGBDecodeExtensionAvailability)
{
    bool hasSRGBDecode = extensionEnabled("GL_EXT_texture_sRGB_decode");
    if (hasSRGBDecode)
    {
        bool hasSRGBTextures = extensionEnabled("GL_EXT_sRGB") || getClientMajorVersion() >= 3;
        EXPECT_TRUE(hasSRGBTextures);
    }
}

// Test basic functionality of SRGB decode using the texture parameter
TEST_P(SRGBTextureTest, SRGBDecodeTextureParameter)
{
    if (!extensionEnabled("GL_EXT_texture_sRGB_decode"))
    {
        std::cout << "Test skipped because GL_EXT_texture_sRGB_decode is not available."
                  << std::endl;
        return;
    }

    GLColor linearColor(64, 127, 191, 255);
    GLColor srgbColor(13, 54, 133, 255);

    GLTexture tex;
    glBindTexture(GL_TEXTURE_2D, tex.get());
    glTexImage2D(GL_TEXTURE_2D, 0, GL_SRGB_ALPHA_EXT, 1, 1, 0, GL_SRGB_ALPHA_EXT, GL_UNSIGNED_BYTE,
                 &linearColor);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_SRGB_DECODE_EXT, GL_DECODE_EXT);
    ASSERT_GL_NO_ERROR();

    glUseProgram(mProgram);
    glUniform1i(mTextureLocation, 0);

    glDisable(GL_DEPTH_TEST);
    drawQuad(mProgram, "position", 0.5f);

    EXPECT_PIXEL_COLOR_NEAR(0, 0, srgbColor, 1.0);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_SRGB_DECODE_EXT, GL_SKIP_DECODE_EXT);
    drawQuad(mProgram, "position", 0.5f);

    EXPECT_PIXEL_COLOR_NEAR(0, 0, linearColor, 1.0);
}

// Test basic functionality of SRGB decode using the sampler parameter
TEST_P(SRGBTextureTest, SRGBDecodeSamplerParameter)
{
    if (!extensionEnabled("GL_EXT_texture_sRGB_decode") || getClientMajorVersion() < 3)
    {
        std::cout << "Test skipped because GL_EXT_texture_sRGB_decode or ES3 is not available."
                  << std::endl;
        return;
    }

    GLColor linearColor(64, 127, 191, 255);
    GLColor srgbColor(13, 54, 133, 255);

    GLTexture tex;
    glBindTexture(GL_TEXTURE_2D, tex.get());
    glTexImage2D(GL_TEXTURE_2D, 0, GL_SRGB_ALPHA_EXT, 1, 1, 0, GL_SRGB_ALPHA_EXT, GL_UNSIGNED_BYTE,
                 &linearColor);
    ASSERT_GL_NO_ERROR();

    GLSampler sampler;
    glBindSampler(0, sampler.get());
    glSamplerParameteri(sampler.get(), GL_TEXTURE_SRGB_DECODE_EXT, GL_DECODE_EXT);

    glUseProgram(mProgram);
    glUniform1i(mTextureLocation, 0);

    glDisable(GL_DEPTH_TEST);
    drawQuad(mProgram, "position", 0.5f);

    EXPECT_PIXEL_COLOR_NEAR(0, 0, srgbColor, 1.0);

    glSamplerParameteri(sampler.get(), GL_TEXTURE_SRGB_DECODE_EXT, GL_SKIP_DECODE_EXT);
    drawQuad(mProgram, "position", 0.5f);

    EXPECT_PIXEL_COLOR_NEAR(0, 0, linearColor, 1.0);
}
// Use this to select which configurations (e.g. which renderer, which GLES major version) these tests should be run against.
ANGLE_INSTANTIATE_TEST(SRGBTextureTest,
                       ES2_D3D9(),
                       ES2_D3D11(),
                       ES3_D3D11(),
                       ES2_OPENGL(),
                       ES3_OPENGL(),
                       ES2_OPENGLES(),
                       ES3_OPENGLES());

} // namespace
