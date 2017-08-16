//
// Copyright (c) 2016 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//

// EGLRobustnessTest.cpp: tests for EGL_EXT_create_context_robustness

#include <gtest/gtest.h>

#include <EGL/egl.h>
#include <EGL/eglext.h>

#include "OSWindow.h"
#include "test_utils/ANGLETest.h"

using namespace angle;

class EGLRobustnessTest : public ::testing::TestWithParam<angle::PlatformParameters>
{
  public:
    void SetUp() override
    {
        mOSWindow = CreateOSWindow();
        mOSWindow->initialize("EGLRobustnessTest", 500, 500);
        mOSWindow->setVisible(true);

        auto eglGetPlatformDisplayEXT = reinterpret_cast<PFNEGLGETPLATFORMDISPLAYEXTPROC>(
            eglGetProcAddress("eglGetPlatformDisplayEXT"));

        const auto &platform = GetParam().eglParameters;

        std::vector<EGLint> displayAttributes;
        displayAttributes.push_back(EGL_PLATFORM_ANGLE_TYPE_ANGLE);
        displayAttributes.push_back(platform.renderer);
        displayAttributes.push_back(EGL_PLATFORM_ANGLE_MAX_VERSION_MAJOR_ANGLE);
        displayAttributes.push_back(platform.majorVersion);
        displayAttributes.push_back(EGL_PLATFORM_ANGLE_MAX_VERSION_MINOR_ANGLE);
        displayAttributes.push_back(platform.minorVersion);

        if (platform.deviceType != EGL_DONT_CARE)
        {
            displayAttributes.push_back(EGL_PLATFORM_ANGLE_DEVICE_TYPE_ANGLE);
            displayAttributes.push_back(platform.deviceType);
        }

        displayAttributes.push_back(EGL_NONE);

        mDisplay = eglGetPlatformDisplayEXT(EGL_PLATFORM_ANGLE_ANGLE,
                                            reinterpret_cast<void *>(mOSWindow->getNativeDisplay()),
                                            &displayAttributes[0]);
        ASSERT_NE(EGL_NO_DISPLAY, mDisplay);

        ASSERT_TRUE(eglInitialize(mDisplay, nullptr, nullptr) == EGL_TRUE);

        const char *extensions = eglQueryString(mDisplay, EGL_EXTENSIONS);
        if (strstr(extensions, "EGL_EXT_create_context_robustness") == nullptr)
        {
            std::cout << "Test skipped due to missing EGL_EXT_create_context_robustness"
                      << std::endl;
            return;
        }

        int nConfigs = 0;
        ASSERT_TRUE(eglGetConfigs(mDisplay, nullptr, 0, &nConfigs) == EGL_TRUE);
        ASSERT_LE(1, nConfigs);

        int nReturnedConfigs = 0;
        ASSERT_TRUE(eglGetConfigs(mDisplay, &mConfig, 1, &nReturnedConfigs) == EGL_TRUE);
        ASSERT_EQ(1, nReturnedConfigs);

        mWindow = eglCreateWindowSurface(mDisplay, mConfig, mOSWindow->getNativeWindow(), nullptr);
        ASSERT_EGL_SUCCESS();

        mInitialized = true;
    }

    void TearDown() override
    {
        eglDestroySurface(mDisplay, mWindow);
        eglDestroyContext(mDisplay, mContext);
        eglMakeCurrent(mDisplay, EGL_NO_SURFACE, EGL_NO_SURFACE, EGL_NO_CONTEXT);
        eglTerminate(mDisplay);
        EXPECT_EGL_SUCCESS();

        SafeDelete(mOSWindow);
    }

    void createContext(EGLint resetStrategy)
    {
        const EGLint contextAttribs[] = {EGL_CONTEXT_CLIENT_VERSION, 2,
                                         EGL_CONTEXT_OPENGL_RESET_NOTIFICATION_STRATEGY_EXT,
                                         resetStrategy, EGL_NONE};
        mContext = eglCreateContext(mDisplay, mConfig, EGL_NO_CONTEXT, contextAttribs);
        ASSERT_NE(EGL_NO_CONTEXT, mContext);

        eglMakeCurrent(mDisplay, mWindow, mWindow, mContext);
        ASSERT_EGL_SUCCESS();

        const char *extensionString = reinterpret_cast<const char *>(glGetString(GL_EXTENSIONS));
        ASSERT_NE(nullptr, strstr(extensionString, "GL_ANGLE_instanced_arrays"));

        mDrawElementsInstancedANGLE =
            (PFNGLDRAWELEMENTSINSTANCEDANGLEPROC)eglGetProcAddress("glDrawElementsInstancedANGLE");
        ASSERT_NE(nullptr, mDrawElementsInstancedANGLE);
    }

    void forceContextReset()
    {
        // Cause a GPU reset by drawing 100,000,000 fullscreen quads
        GLuint program = CompileProgram(
            "attribute vec4 pos;\n"
            "void main() {gl_Position = pos;}\n",
            "precision mediump float;\n"
            "void main() {gl_FragColor = vec4(1.0);}\n");
        ASSERT_NE(0u, program);
        glUseProgram(program);

        GLfloat vertices[] = {
            -1.0f, -1.0f, 0.0f, 1.0f, -1.0f, 1.0f, 0.0f, 1.0f,
            1.0f,  -1.0f, 0.0f, 1.0f, 1.0f,  1.0f, 0.0f, 1.0f,
        };

        const int kNumQuads = 10000;
        std::vector<GLushort> indices(6 * kNumQuads);

        for (size_t i = 0; i < kNumQuads; i++)
        {
            indices[i * 6 + 0] = 0;
            indices[i * 6 + 1] = 1;
            indices[i * 6 + 2] = 2;
            indices[i * 6 + 3] = 1;
            indices[i * 6 + 4] = 2;
            indices[i * 6 + 5] = 3;
        }

        glBindAttribLocation(program, 0, "pos");
        glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 0, vertices);
        glEnableVertexAttribArray(0);

        glViewport(0, 0, mOSWindow->getWidth(), mOSWindow->getHeight());
        glClearColor(1.0, 0.0, 0.0, 1.0);
        glClear(GL_COLOR_BUFFER_BIT);
        mDrawElementsInstancedANGLE(GL_TRIANGLES, kNumQuads * 6, GL_UNSIGNED_SHORT, indices.data(),
                                    10000);

        glFinish();
    }

  protected:
    EGLDisplay mDisplay                                             = EGL_NO_DISPLAY;
    EGLSurface mWindow                                              = EGL_NO_SURFACE;
    bool mInitialized                                               = false;
    PFNGLDRAWELEMENTSINSTANCEDANGLEPROC mDrawElementsInstancedANGLE = nullptr;

  private:
    EGLContext mContext = EGL_NO_CONTEXT;
    EGLConfig mConfig   = 0;
    OSWindow *mOSWindow = nullptr;
};

// Check glGetGraphicsResetStatusEXT returns GL_NO_ERROR if we did nothing
TEST_P(EGLRobustnessTest, NoErrorByDefault)
{
    if (!mInitialized)
    {
        return;
    }
    ASSERT_TRUE(glGetGraphicsResetStatusEXT() == GL_NO_ERROR);
}

// Checks that the application gets no loss with NO_RESET_NOTIFICATION
TEST_P(EGLRobustnessTest, DISABLED_NoResetNotification)
{
    if (!mInitialized)
    {
        return;
    }

    createContext(EGL_NO_RESET_NOTIFICATION_EXT);

    if (!IsWindows())
    {
        std::cout << "Test disabled on non Windows platforms because drivers can't recover. "
                  << "See " << __FILE__ << ":" << __LINE__ << std::endl;
        return;
    }
    std::cout << "Causing a GPU reset, brace for impact." << std::endl;

    forceContextReset();
    ASSERT_TRUE(glGetGraphicsResetStatusEXT() == GL_NO_ERROR);
}

// Checks that resetting the ANGLE display allows to get rid of the context loss.
// Also checks that the application gets notified of the loss of the display.
// We coalesce both tests to reduce the number of TDRs done on Windows: by default
// having more than 5 TDRs in a minute will cause Windows to disable the GPU until
// the computer is rebooted.
TEST_P(EGLRobustnessTest, DISABLED_ResettingDisplayWorks)
{
    if (!mInitialized)
    {
        return;
    }

    createContext(EGL_LOSE_CONTEXT_ON_RESET_EXT);

    if (!IsWindows())
    {
        std::cout << "Test disabled on non Windows platforms because drivers can't recover. "
                  << "See " << __FILE__ << ":" << __LINE__ << std::endl;
        return;
    }
    std::cout << "Causing a GPU reset, brace for impact." << std::endl;

    forceContextReset();
    ASSERT_TRUE(glGetGraphicsResetStatusEXT() != GL_NO_ERROR);

    TearDown();
    SetUp();
    ASSERT_TRUE(glGetGraphicsResetStatusEXT() == GL_NO_ERROR);
}

// Tests causing GPU resets are disabled, use the following args to run them:
// --gtest_also_run_disabled_tests --gtest_filter=EGLRobustnessTest\*

// Note that on Windows the OpenGL driver fails hard (popup that closes the application)
// if there was a TDR caused by D3D so we don't run D3D tests at the same time as the OpenGL tests.
#define D3D_HAS_PRIORITY 1
#if D3D_HAS_PRIORITY && (defined(ANGLE_ENABLE_D3D9) || defined(ANGLE_ENABLE_D3D11))
ANGLE_INSTANTIATE_TEST(EGLRobustnessTest, ES2_D3D9(), ES2_D3D11());
#else
ANGLE_INSTANTIATE_TEST(EGLRobustnessTest, ES2_OPENGL());
#endif
