//
// Copyright (c) 2012 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//

#include "gtest/gtest.h"

#include "MockDiagnostics.h"
#include "MockDirectiveHandler.h"
#include "compiler/preprocessor/Preprocessor.h"

#ifndef PREPROCESSOR_TESTS_PREPROCESSOR_TEST_H_
#define PREPROCESSOR_TESTS_PREPROCESSOR_TEST_H_

class PreprocessorTest : public testing::Test
{
  protected:
    PreprocessorTest()
        : mPreprocessor(&mDiagnostics, &mDirectiveHandler, pp::PreprocessorSettings())
    {
    }

    MockDiagnostics mDiagnostics;
    MockDirectiveHandler mDirectiveHandler;
    pp::Preprocessor mPreprocessor;
};

class SimplePreprocessorTest : public testing::Test
{
  protected:
    // Preprocesses the input string.
    void preprocess(const char *input);
    void preprocess(const char *input, const pp::PreprocessorSettings &settings);

    // Preprocesses the input string and verifies that it matches expected output.
    void preprocess(const char *input, const char *expected);

    // Lexes a single token from input and writes it to token.
    void lexSingleToken(const char *input, pp::Token *token);
    void lexSingleToken(size_t count, const char *const input[], pp::Token *token);

    MockDiagnostics mDiagnostics;
    MockDirectiveHandler mDirectiveHandler;

  private:
    void preprocess(const char *input, std::stringstream *output, pp::Preprocessor *preprocessor);
};

#endif  // PREPROCESSOR_TESTS_PREPROCESSOR_TEST_H_
