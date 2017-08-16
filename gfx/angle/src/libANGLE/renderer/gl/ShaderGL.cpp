//
// Copyright 2015 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//

// ShaderGL.cpp: Implements the class methods for ShaderGL.

#include "libANGLE/renderer/gl/ShaderGL.h"

#include "common/debug.h"
#include "libANGLE/Compiler.h"
#include "libANGLE/renderer/gl/FunctionsGL.h"
#include "libANGLE/renderer/gl/RendererGL.h"
#include "libANGLE/renderer/gl/WorkaroundsGL.h"

#include <iostream>

namespace rx
{

ShaderGL::ShaderGL(const gl::ShaderState &data,
                   const FunctionsGL *functions,
                   const WorkaroundsGL &workarounds)
    : ShaderImpl(data), mFunctions(functions), mWorkarounds(workarounds), mShaderID(0)
{
    ASSERT(mFunctions);
}

ShaderGL::~ShaderGL()
{
    if (mShaderID != 0)
    {
        mFunctions->deleteShader(mShaderID);
        mShaderID = 0;
    }
}

ShCompileOptions ShaderGL::prepareSourceAndReturnOptions(std::stringstream *sourceStream,
                                                         std::string * /*sourcePath*/)
{
    // Reset the previous state
    if (mShaderID != 0)
    {
        mFunctions->deleteShader(mShaderID);
        mShaderID = 0;
    }

    *sourceStream << mData.getSource();

    ShCompileOptions options = SH_INIT_GL_POSITION;

    if (mWorkarounds.doWhileGLSLCausesGPUHang)
    {
        options |= SH_REWRITE_DO_WHILE_LOOPS;
    }

    if (mWorkarounds.emulateAbsIntFunction)
    {
        options |= SH_EMULATE_ABS_INT_FUNCTION;
    }

    if (mWorkarounds.addAndTrueToLoopCondition)
    {
        options |= SH_ADD_AND_TRUE_TO_LOOP_CONDITION;
    }

    if (mWorkarounds.emulateIsnanFloat)
    {
        options |= SH_EMULATE_ISNAN_FLOAT_FUNCTION;
    }

    if (mWorkarounds.useUnusedBlocksWithStandardOrSharedLayout)
    {
        options |= SH_USE_UNUSED_STANDARD_SHARED_BLOCKS;
    }

    if (mWorkarounds.dontRemoveInvariantForFragmentInput)
    {
        options |= SH_DONT_REMOVE_INVARIANT_FOR_FRAGMENT_INPUT;
    }

    if (mWorkarounds.removeInvariantAndCentroidForESSL3)
    {
        options |= SH_REMOVE_INVARIANT_AND_CENTROID_FOR_ESSL3;
    }

    return options;
}

bool ShaderGL::postTranslateCompile(gl::Compiler *compiler, std::string *infoLog)
{
    // Translate the ESSL into GLSL
    const char *translatedSourceCString = mData.getTranslatedSource().c_str();

    // Generate a shader object and set the source
    mShaderID = mFunctions->createShader(mData.getShaderType());
    mFunctions->shaderSource(mShaderID, 1, &translatedSourceCString, nullptr);
    mFunctions->compileShader(mShaderID);

    // Check for compile errors from the native driver
    GLint compileStatus = GL_FALSE;
    mFunctions->getShaderiv(mShaderID, GL_COMPILE_STATUS, &compileStatus);
    if (compileStatus == GL_FALSE)
    {
        // Compilation failed, put the error into the info log
        GLint infoLogLength = 0;
        mFunctions->getShaderiv(mShaderID, GL_INFO_LOG_LENGTH, &infoLogLength);

        // Info log length includes the null terminator, so 1 means that the info log is an empty
        // string.
        if (infoLogLength > 1)
        {
            std::vector<char> buf(infoLogLength);
            mFunctions->getShaderInfoLog(mShaderID, infoLogLength, nullptr, &buf[0]);

            mFunctions->deleteShader(mShaderID);
            mShaderID = 0;

            *infoLog = &buf[0];
            TRACE("\n%s", infoLog->c_str());
        }
        else
        {
            TRACE("\nShader compilation failed with no info log.");
        }
        return false;
    }

    return true;
}

std::string ShaderGL::getDebugInfo() const
{
    return std::string();
}

GLuint ShaderGL::getShaderID() const
{
    return mShaderID;
}

}
