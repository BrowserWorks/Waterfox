/*
 * Copyright 2016 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */
 
#ifndef SKSL_UTIL
#define SKSL_UTIL

#include <iomanip>
#include <string>
#include <sstream>
#include "stdlib.h"
#include "assert.h"
#include "SkTypes.h"    

namespace SkSL {

// our own definitions of certain std:: functions, because they are not always present on Android

template <typename T> std::string to_string(T value) {
    std::stringstream buffer;
    buffer << std::setprecision(std::numeric_limits<T>::digits10) << value;
    return buffer.str();
}

#if _MSC_VER
#define NORETURN __declspec(noreturn)
#else
#define NORETURN __attribute__((__noreturn__))
#endif
int stoi(std::string s);

double stod(std::string s);

long stol(std::string s);

NORETURN void sksl_abort();

} // namespace

#ifdef DEBUG
#define ASSERT(x) assert(x)
#define ASSERT_RESULT(x) ASSERT(x);
#else
#define ASSERT(x)
#define ASSERT_RESULT(x) x
#endif

#ifdef SKIA
#define ABORT(...) { SkDebugf(__VA_ARGS__); sksl_abort(); }
#else
#define ABORT(...) { sksl_abort(); }
#endif

#endif
