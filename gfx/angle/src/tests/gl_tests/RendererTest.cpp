//
// Copyright 2015 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// RendererTest:
//   These tests are designed to ensure that the various configurations of the test fixtures work as expected.
//   If one of these tests fails, then it is likely that some of the other tests are being configured incorrectly.
//   For example, they might be using the D3D11 renderer when the test is meant to be using the D3D9 renderer.

#include "test_utils/ANGLETest.h"

using namespace angle;

namespace
{

class RendererTest : public ANGLETest
{
  protected:
    RendererTest()
    {
        setWindowWidth(128);
        setWindowHeight(128);
    }
};

TEST_P(RendererTest, RequestedRendererCreated)
{
    std::string rendererString = std::string(reinterpret_cast<const char*>(glGetString(GL_RENDERER)));
    std::transform(rendererString.begin(), rendererString.end(), rendererString.begin(), ::tolower);

    std::string versionString = std::string(reinterpret_cast<const char*>(glGetString(GL_VERSION)));
    std::transform(versionString.begin(), versionString.end(), versionString.begin(), ::tolower);

    const EGLPlatformParameters &platform = GetParam().eglParameters;

    // Ensure that the renderer string contains D3D11, if we requested a D3D11 renderer.
    if (platform.renderer == EGL_PLATFORM_ANGLE_TYPE_D3D11_ANGLE)
    {
        ASSERT_NE(rendererString.find(std::string("direct3d11")), std::string::npos);
    }

    // Ensure that the renderer string contains D3D9, if we requested a D3D9 renderer.
    if (platform.renderer == EGL_PLATFORM_ANGLE_TYPE_D3D9_ANGLE)
    {
        ASSERT_NE(rendererString.find(std::string("direct3d9")), std::string::npos);
    }

    // Ensure that the major and minor versions trigger expected behavior in D3D11
    if (platform.renderer == EGL_PLATFORM_ANGLE_TYPE_D3D11_ANGLE)
    {
        // Ensure that the renderer uses WARP, if we requested it.
        if (platform.deviceType == EGL_PLATFORM_ANGLE_DEVICE_TYPE_WARP_ANGLE)
        {
            auto basicRenderPos = rendererString.find(std::string("microsoft basic render"));
            auto softwareAdapterPos = rendererString.find(std::string("software adapter"));
            ASSERT_TRUE(basicRenderPos != std::string::npos || softwareAdapterPos != std::string::npos);
        }

        std::vector<std::string> acceptableShaderModels;

        // When no specific major/minor version is requested, then ANGLE should return the highest possible feature level by default.
        // The current hardware driver might not support Feature Level 11_0, but WARP always does.
        // Therefore if WARP is specified but no major/minor version is specified, then we test to check that ANGLE returns FL11_0.
        if (platform.majorVersion >= 11 || platform.majorVersion == EGL_DONT_CARE)
        {
            // Feature Level 10_0 corresponds to shader model 5_0
            acceptableShaderModels.push_back("ps_5_0");
        }

        if (platform.majorVersion >= 10 || platform.majorVersion == EGL_DONT_CARE)
        {
            if (platform.minorVersion >= 1 || platform.minorVersion == EGL_DONT_CARE)
            {
                // Feature Level 10_1 corresponds to shader model 4_1
                acceptableShaderModels.push_back("ps_4_1");
            }

            if (platform.minorVersion >= 0 || platform.minorVersion == EGL_DONT_CARE)
            {
                // Feature Level 10_0 corresponds to shader model 4_0
                acceptableShaderModels.push_back("ps_4_0");
            }
        }

        if (platform.majorVersion == 9 && platform.minorVersion == 3)
        {
            acceptableShaderModels.push_back("ps_4_0_level_9_3");
        }

        bool found = false;
        for (size_t i = 0; i < acceptableShaderModels.size(); i++)
        {
            if (rendererString.find(acceptableShaderModels[i]) != std::string::npos)
            {
                found = true;
            }
        }

        ASSERT_TRUE(found);
    }

    if (platform.renderer == EGL_PLATFORM_ANGLE_TYPE_NULL_ANGLE)
    {
        ASSERT_TRUE(IsNULL());
    }

    EGLint glesMajorVersion = GetParam().majorVersion;
    EGLint glesMinorVersion = GetParam().minorVersion;

    // Ensure that the renderer string contains the requested version number
    if (glesMajorVersion == 3 && glesMinorVersion == 1)
    {
        ASSERT_NE(versionString.find(std::string("es 3.1")), std::string::npos);
    }
    else if (glesMajorVersion == 3 && glesMinorVersion == 0)
    {
        ASSERT_NE(versionString.find(std::string("es 3.0")), std::string::npos);
    }
    else if (glesMajorVersion == 2 && glesMinorVersion == 0)
    {
        ASSERT_NE(versionString.find(std::string("es 2.0")), std::string::npos);
    }
    else
    {
        FAIL() << "Unhandled GL ES client version.";
    }
}

// Perform a simple operation (clear and read pixels) to verify the device is working
TEST_P(RendererTest, SimpleOperation)
{
    if (IsNULL())
    {
        std::cout << "ANGLE NULL backend clears are not functional" << std::endl;
        return;
    }

    glClearColor(0.0f, 1.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    EXPECT_PIXEL_EQ(0, 0, 0, 255, 0, 255);
}

// Select configurations (e.g. which renderer, which GLES major version) these tests should be run against.

ANGLE_INSTANTIATE_TEST(RendererTest,
                       // ES2 on top of D3D9
                       ES2_D3D9(),
                       ES2_D3D9_REFERENCE(),

                       // ES2 on top of D3D11 feature level 9.3 to 11.0
                       ES2_D3D11(),
                       ES2_D3D11_FL11_0(),
                       ES2_D3D11_FL10_1(),
                       ES2_D3D11_FL10_0(),
                       ES2_D3D11_FL9_3(),

                       // ES2 on top of D3D11 WARP feature level 9.3 to 11.0
                       ES2_D3D11_WARP(),
                       ES2_D3D11_FL11_0_WARP(),
                       ES2_D3D11_FL10_1_WARP(),
                       ES2_D3D11_FL10_0_WARP(),
                       ES2_D3D11_FL9_3_WARP(),

                       // ES2 on top of D3D11 reference feature level 9.3 to 11.0
                       ES2_D3D11_REFERENCE(),
                       ES2_D3D11_FL11_0_REFERENCE(),
                       ES2_D3D11_FL10_1_REFERENCE(),
                       ES2_D3D11_FL10_0_REFERENCE(),
                       ES2_D3D11_FL9_3_REFERENCE(),

                       // ES3 on top of D3D11 feature level 9.3 to 11.0
                       ES3_D3D11(),
                       ES3_D3D11_FL11_0(),
                       ES3_D3D11_FL10_1(),
                       ES3_D3D11_FL10_0(),

                       // ES3 on top of D3D11 WARP feature level 9.3 to 11.0
                       ES3_D3D11_WARP(),
                       ES3_D3D11_FL11_0_WARP(),
                       ES3_D3D11_FL10_1_WARP(),
                       ES3_D3D11_FL10_0_WARP(),

                       // ES3 on top of D3D11 reference feature level 9.3 to 11.0
                       ES3_D3D11_REFERENCE(),
                       ES3_D3D11_FL11_0_REFERENCE(),
                       ES3_D3D11_FL10_1_REFERENCE(),
                       ES3_D3D11_FL10_0_REFERENCE(),

                       // ES2 on top of desktop OpenGL versions 2.1 to 4.5
                       ES2_OPENGL(),
                       ES2_OPENGL(2, 1),
                       ES2_OPENGL(3, 0),
                       ES2_OPENGL(3, 1),
                       ES2_OPENGL(3, 2),
                       ES2_OPENGL(3, 3),
                       ES2_OPENGL(4, 0),
                       ES2_OPENGL(4, 1),
                       ES2_OPENGL(4, 2),
                       ES2_OPENGL(4, 3),
                       ES2_OPENGL(4, 4),
                       ES2_OPENGL(4, 5),

                       // ES2 on top of desktop OpenGL versions 3.2 to 4.5
                       ES3_OPENGL(),
                       ES3_OPENGL(3, 2),
                       ES3_OPENGL(3, 3),
                       ES3_OPENGL(4, 0),
                       ES3_OPENGL(4, 1),
                       ES3_OPENGL(4, 2),
                       ES3_OPENGL(4, 3),
                       ES3_OPENGL(4, 4),
                       ES3_OPENGL(4, 5),

                       // ES2 on top of OpenGL ES 2.0 to 3.2
                       ES2_OPENGLES(),
                       ES2_OPENGLES(2, 0),
                       ES2_OPENGLES(3, 0),
                       ES2_OPENGLES(3, 1),
                       ES2_OPENGLES(3, 2),

                       // ES2 on top of OpenGL ES 3.0 to 3.2
                       ES3_OPENGLES(),
                       ES3_OPENGLES(3, 0),
                       ES3_OPENGLES(3, 1),
                       ES3_OPENGLES(3, 2),

                       // All ES version on top of the NULL backend
                       ES2_NULL(),
                       ES3_NULL(),
                       ES31_NULL());
}
