//
// Copyright (c) 2015 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// compiler_test.h:
//     utilities for compiler unit tests.

#ifndef TESTS_TEST_UTILS_COMPILER_TEST_H_
#define TESTS_TEST_UTILS_COMPILER_TEST_H_

#include <map>

#include "gtest/gtest.h"

#include "angle_gl.h"
#include "compiler/translator/TranslatorESSL.h"
#include "GLSLANG/ShaderLang.h"

namespace sh
{

bool compileTestShader(GLenum type,
                       ShShaderSpec spec,
                       ShShaderOutput output,
                       const std::string &shaderString,
                       ShBuiltInResources *resources,
                       ShCompileOptions compileOptions,
                       std::string *translatedCode,
                       std::string *infoLog);

bool compileTestShader(GLenum type,
                       ShShaderSpec spec,
                       ShShaderOutput output,
                       const std::string &shaderString,
                       ShCompileOptions compileOptions,
                       std::string *translatedCode,
                       std::string *infoLog);

class MatchOutputCodeTest : public testing::Test
{
  protected:
    MatchOutputCodeTest(GLenum shaderType,
                        ShCompileOptions defaultCompileOptions,
                        ShShaderOutput outputType);

    void addOutputType(const ShShaderOutput outputType);

    ShBuiltInResources *getResources();

    // Compile functions clear any results from earlier calls to them.
    void compile(const std::string &shaderString);
    void compile(const std::string &shaderString, const ShCompileOptions compileOptions);

    bool foundInESSLCode(const char *stringToFind) const
    {
        return foundInCode(SH_ESSL_OUTPUT, stringToFind);
    }

    bool foundInGLSLCode(const char *stringToFind) const
    {
        return foundInCode(SH_GLSL_COMPATIBILITY_OUTPUT, stringToFind);
    }

    bool foundInCode(ShShaderOutput output, const char *stringToFind) const;

    // Test that the string occurs for exactly expectedOccurrences times
    bool foundInCode(ShShaderOutput output,
                     const char *stringToFind,
                     const int expectedOccurrences) const;

    // Test that the string is found in all outputs
    bool foundInCode(const char *stringToFind) const;

    // Test that the string occurs for exactly expectedOccurrences times in all outputs
    bool foundInCode(const char *stringToFind, const int expectedOccurrences) const;

    // Test that the string is found in none of the outputs
    bool notFoundInCode(const char *stringToFind) const;

  private:
    bool compileWithSettings(ShShaderOutput output,
                             const std::string &shaderString,
                             ShCompileOptions compileOptions,
                             std::string *translatedCode,
                             std::string *infoLog);

    GLenum mShaderType;
    ShCompileOptions mDefaultCompileOptions;
    ShBuiltInResources mResources;

    std::map<ShShaderOutput, std::string> mOutputCode;
};

const TIntermSymbol *FindSymbolNode(TIntermNode *root,
                                    const TString &symbolName,
                                    TBasicType basicType);

// Returns a pointer to a function call node with a mangled name functionName.
const TIntermAggregate *FindFunctionCallNode(TIntermNode *root, const TString &functionName);
}

#endif // TESTS_TEST_UTILS_COMPILER_TEST_H_
