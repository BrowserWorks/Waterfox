//
// Copyright 2015 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// string_utils:
//   String helper functions.
//

#ifndef LIBANGLE_STRING_UTILS_H_
#define LIBANGLE_STRING_UTILS_H_

#include <string>
#include <vector>

#include "common/Optional.h"

namespace angle
{

extern const char kWhitespaceASCII[];

enum WhitespaceHandling
{
    KEEP_WHITESPACE,
    TRIM_WHITESPACE,
};

enum SplitResult
{
    SPLIT_WANT_ALL,
    SPLIT_WANT_NONEMPTY,
};

std::vector<std::string> SplitString(const std::string &input,
                                     const std::string &delimiters,
                                     WhitespaceHandling whitespace,
                                     SplitResult resultType);

void SplitStringAlongWhitespace(const std::string &input,
                                std::vector<std::string> *tokensOut);

std::string TrimString(const std::string &input, const std::string &trimChars);

bool HexStringToUInt(const std::string &input, unsigned int *uintOut);

bool ReadFileToString(const std::string &path, std::string *stringOut);

Optional<std::vector<wchar_t>> WidenString(size_t length, const char *cString);

// Check if the string str begins with the given prefix.
// Prefix may not be NULL and needs to be NULL terminated.
// The comparison is case sensitive.
bool BeginsWith(const std::string &str, const char *prefix);

// Check if the string str begins with the given prefix.
// str and prefix may not be NULL and need to be NULL terminated.
// The comparison is case sensitive.
bool BeginsWith(const char *str, const char *prefix);

// Check if the string str ends with the given suffix.
// Suffix may not be NUL and needs to be NULL terminated.
// The comparison is case sensitive.
bool EndsWith(const std::string& str, const char* suffix);
}

#endif // LIBANGLE_STRING_UTILS_H_
