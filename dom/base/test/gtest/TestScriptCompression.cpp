/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include <cstring>

#include "gtest/gtest.h"
#include "mozilla/Vector.h"
#include "mozilla/dom/ScriptCompression.h"

using JS::loader::ScriptBytecodeCompress;
using JS::loader::ScriptBytecodeDecompress;
using mozilla::Vector;

static constexpr size_t kOffset = 16;
static constexpr uint32_t kLength = 4096;

static void Compress(Vector<uint8_t>& aBytecode, Vector<uint8_t>& aCompressed) {
  ASSERT_TRUE(aBytecode.resize(kOffset + kLength));
  for (size_t i = 0; i < aBytecode.length(); ++i) {
    aBytecode[i] = uint8_t(i * 7);
  }
  ASSERT_TRUE(ScriptBytecodeCompress(aBytecode, kOffset, aCompressed));
}

TEST(ScriptCompression, RoundTrip)
{
  Vector<uint8_t> bytecode, compressed, decoded;
  Compress(bytecode, compressed);
  ASSERT_TRUE(ScriptBytecodeDecompress(compressed, kOffset, decoded));
  ASSERT_EQ(decoded.length(), bytecode.length());
  EXPECT_EQ(memcmp(decoded.begin(), bytecode.begin(), bytecode.length()), 0);
}

TEST(ScriptCompression, RejectTruncated)
{
  Vector<uint8_t> bytecode, compressed, decoded;
  Compress(bytecode, compressed);
  while (compressed.length() > kOffset) {
    compressed.shrinkBy(1);
    SCOPED_TRACE(compressed.length());
    EXPECT_FALSE(ScriptBytecodeDecompress(compressed, kOffset, decoded));
  }
}

TEST(ScriptCompression, RejectWrongLength)
{
  Vector<uint8_t> bytecode, compressed, decoded;
  Compress(bytecode, compressed);
  for (uint32_t length : {kLength - 1, kLength + 1}) {
    memcpy(compressed.begin() + kOffset, &length, sizeof(length));
    EXPECT_FALSE(ScriptBytecodeDecompress(compressed, kOffset, decoded));
  }
}
