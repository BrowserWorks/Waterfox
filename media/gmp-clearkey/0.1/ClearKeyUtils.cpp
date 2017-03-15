/*
 * Copyright 2015, Mozilla Foundation and contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <algorithm>
#include <ctype.h>
#include <stdarg.h>
#include <stdint.h>
#include <vector>

#include "ClearKeyUtils.h"
#include "ClearKeyBase64.h"
#include "ArrayUtils.h"
#include <assert.h>
#include <memory.h>
#include "BigEndian.h"
#include "openaes/oaes_lib.h"

using namespace std;

void
CK_Log(const char* aFmt, ...)
{
  va_list ap;

  va_start(ap, aFmt);
  vprintf(aFmt, ap);
  va_end(ap);

  printf("\n");
  fflush(stdout);
}

static void
IncrementIV(vector<uint8_t>& aIV) {
  using mozilla::BigEndian;

  assert(aIV.size() == 16);
  BigEndian::writeUint64(&aIV[8], BigEndian::readUint64(&aIV[8]) + 1);
}

/* static */ void
ClearKeyUtils::DecryptAES(const vector<uint8_t>& aKey,
                          vector<uint8_t>& aData, vector<uint8_t>& aIV)
{
  assert(aIV.size() == CENC_KEY_LEN);
  assert(aKey.size() == CENC_KEY_LEN);

  OAES_CTX* aes = oaes_alloc();
  oaes_key_import_data(aes, &aKey[0], aKey.size());
  oaes_set_option(aes, OAES_OPTION_ECB, nullptr);

  for (size_t i = 0; i < aData.size(); i += CENC_KEY_LEN) {
    size_t encLen;
    oaes_encrypt(aes, &aIV[0], CENC_KEY_LEN, nullptr, &encLen);

    vector<uint8_t> enc(encLen);
    oaes_encrypt(aes, &aIV[0], CENC_KEY_LEN, &enc[0], &encLen);

    assert(encLen >= 2 * OAES_BLOCK_SIZE + CENC_KEY_LEN);
    size_t blockLen = min(aData.size() - i, CENC_KEY_LEN);
    for (size_t j = 0; j < blockLen; j++) {
      aData[i + j] ^= enc[2 * OAES_BLOCK_SIZE + j];
    }
    IncrementIV(aIV);
  }

  oaes_free(&aes);
}

/**
 * ClearKey expects all Key IDs to be base64 encoded with non-standard alphabet
 * and padding.
 */
static bool
EncodeBase64Web(vector<uint8_t> aBinary, string& aEncoded)
{
  const char sAlphabet[] =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_";
  const uint8_t sMask = 0x3f;

  aEncoded.resize((aBinary.size() * 8 + 5) / 6);

  // Pad binary data in case there's rubbish past the last byte.
  aBinary.push_back(0);

  // Number of bytes not consumed in the previous character
  uint32_t shift = 0;

  auto out = aEncoded.begin();
  auto data = aBinary.begin();
  for (string::size_type i = 0; i < aEncoded.length(); i++) {
    if (shift) {
      out[i] = (*data << (6 - shift)) & sMask;
      data++;
    } else {
      out[i] = 0;
    }

    out[i] += (*data >> (shift + 2)) & sMask;
    shift = (shift + 2) % 8;

    // Cast idx to size_t before using it as an array-index,
    // to pacify clang 'Wchar-subscripts' warning:
    size_t idx = static_cast<size_t>(out[i]);
    assert(idx < MOZ_ARRAY_LENGTH(sAlphabet)); // out of bounds index for 'sAlphabet'
    out[i] = sAlphabet[idx];
  }

  return true;
}

/* static */ void
ClearKeyUtils::MakeKeyRequest(const vector<KeyId>& aKeyIDs,
                              string& aOutRequest,
                              GMPSessionType aSessionType)
{
  assert(aKeyIDs.size() && aOutRequest.empty());

  aOutRequest.append("{\"kids\":[");
  for (size_t i = 0; i < aKeyIDs.size(); i++) {
    if (i) {
      aOutRequest.append(",");
    }
    aOutRequest.append("\"");

    string base64key;
    EncodeBase64Web(aKeyIDs[i], base64key);
    aOutRequest.append(base64key);

    aOutRequest.append("\"");
  }
  aOutRequest.append("],\"type\":");

  aOutRequest.append("\"");
  aOutRequest.append(SessionTypeToString(aSessionType));
  aOutRequest.append("\"}");
}

#define EXPECT_SYMBOL(CTX, X) do { \
  if (GetNextSymbol(CTX) != (X)) { \
    CK_LOGE("Unexpected symbol in JWK parser"); \
    return false; \
  } \
} while (false)

struct ParserContext {
  const uint8_t* mIter;
  const uint8_t* mEnd;
};

static uint8_t
PeekSymbol(ParserContext& aCtx)
{
  for (; aCtx.mIter < aCtx.mEnd; (aCtx.mIter)++) {
    if (!isspace(*aCtx.mIter)) {
      return *aCtx.mIter;
    }
  }

  return 0;
}

static uint8_t
GetNextSymbol(ParserContext& aCtx)
{
  uint8_t sym = PeekSymbol(aCtx);
  aCtx.mIter++;
  return sym;
}

static bool SkipToken(ParserContext& aCtx);

static bool
SkipString(ParserContext& aCtx)
{
  EXPECT_SYMBOL(aCtx, '"');
  for (uint8_t sym = GetNextSymbol(aCtx); sym; sym = GetNextSymbol(aCtx)) {
    if (sym == '\\') {
      sym = GetNextSymbol(aCtx);
    } else if (sym == '"') {
      return true;
    }
  }

  return false;
}

/**
 * Skip whole object and values it contains.
 */
static bool
SkipObject(ParserContext& aCtx)
{
  EXPECT_SYMBOL(aCtx, '{');

  if (PeekSymbol(aCtx) == '}') {
    GetNextSymbol(aCtx);
    return true;
  }

  while (true) {
    if (!SkipString(aCtx)) return false;
    EXPECT_SYMBOL(aCtx, ':');
    if (!SkipToken(aCtx)) return false;

    if (PeekSymbol(aCtx) == '}') {
      GetNextSymbol(aCtx);
      return true;
    }
    EXPECT_SYMBOL(aCtx, ',');
  }

  return false;
}

/**
 * Skip array value and the values it contains.
 */
static bool
SkipArray(ParserContext& aCtx)
{
  EXPECT_SYMBOL(aCtx, '[');

  if (PeekSymbol(aCtx) == ']') {
    GetNextSymbol(aCtx);
    return true;
  }

  while (SkipToken(aCtx)) {
    if (PeekSymbol(aCtx) == ']') {
      GetNextSymbol(aCtx);
      return true;
    }
    EXPECT_SYMBOL(aCtx, ',');
  }

  return false;
}

/**
 * Skip unquoted literals like numbers, |true|, and |null|.
 * (XXX and anything else that matches /([:alnum:]|[+-.])+/)
 */
static bool
SkipLiteral(ParserContext& aCtx)
{
  for (; aCtx.mIter < aCtx.mEnd; aCtx.mIter++) {
    if (!isalnum(*aCtx.mIter) &&
        *aCtx.mIter != '.' && *aCtx.mIter != '-' && *aCtx.mIter != '+') {
      return true;
    }
  }

  return false;
}

static bool
SkipToken(ParserContext& aCtx)
{
  uint8_t startSym = PeekSymbol(aCtx);
  if (startSym == '"') {
    CK_LOGD("JWK parser skipping string");
    return SkipString(aCtx);
  } else if (startSym == '{') {
    CK_LOGD("JWK parser skipping object");
    return SkipObject(aCtx);
  } else if (startSym == '[') {
    CK_LOGD("JWK parser skipping array");
    return SkipArray(aCtx);
  } else {
    CK_LOGD("JWK parser skipping literal");
    return SkipLiteral(aCtx);
  }

  return false;
}

static bool
GetNextLabel(ParserContext& aCtx, string& aOutLabel)
{
  EXPECT_SYMBOL(aCtx, '"');

  const uint8_t* start = aCtx.mIter;
  for (uint8_t sym = GetNextSymbol(aCtx); sym; sym = GetNextSymbol(aCtx)) {
    if (sym == '\\') {
      GetNextSymbol(aCtx);
      continue;
    }

    if (sym == '"') {
      aOutLabel.assign(start, aCtx.mIter - 1);
      return true;
    }
  }

  return false;
}

static bool
ParseKeyObject(ParserContext& aCtx, KeyIdPair& aOutKey)
{
  EXPECT_SYMBOL(aCtx, '{');

  // Reject empty objects as invalid licenses.
  if (PeekSymbol(aCtx) == '}') {
    GetNextSymbol(aCtx);
    return false;
  }

  string keyId;
  string key;

  while (true) {
    string label;
    string value;

    if (!GetNextLabel(aCtx, label)) {
      return false;
    }

    EXPECT_SYMBOL(aCtx, ':');
    if (label == "kty") {
      if (!GetNextLabel(aCtx, value)) return false;
      // By spec, type must be "oct".
      if (value != "oct") return false;
    } else if (label == "k" && PeekSymbol(aCtx) == '"') {
      // if this isn't a string we will fall through to the SkipToken() path.
      if (!GetNextLabel(aCtx, key)) return false;
    } else if (label == "kid" && PeekSymbol(aCtx) == '"') {
      if (!GetNextLabel(aCtx, keyId)) return false;
    } else {
      if (!SkipToken(aCtx)) return false;
    }

    uint8_t sym = PeekSymbol(aCtx);
    if (!sym || sym == '}') {
      break;
    }
    EXPECT_SYMBOL(aCtx, ',');
  }

  return !key.empty() &&
         !keyId.empty() &&
         DecodeBase64(keyId, aOutKey.mKeyId) &&
         DecodeBase64(key, aOutKey.mKey) &&
         GetNextSymbol(aCtx) == '}';
}

static bool
ParseKeys(ParserContext& aCtx, vector<KeyIdPair>& aOutKeys)
{
  // Consume start of array.
  EXPECT_SYMBOL(aCtx, '[');

  while (true) {
    KeyIdPair key;
    if (!ParseKeyObject(aCtx, key)) {
      CK_LOGE("Failed to parse key object");
      return false;
    }

    assert(!key.mKey.empty() && !key.mKeyId.empty());
    aOutKeys.push_back(key);

    uint8_t sym = PeekSymbol(aCtx);
    if (!sym || sym == ']') {
      break;
    }

    EXPECT_SYMBOL(aCtx, ',');
  }

  return GetNextSymbol(aCtx) == ']';
}

/* static */ bool
ClearKeyUtils::ParseJWK(const uint8_t* aKeyData, uint32_t aKeyDataSize,
                        vector<KeyIdPair>& aOutKeys,
                        GMPSessionType aSessionType)
{
  ParserContext ctx;
  ctx.mIter = aKeyData;
  ctx.mEnd = aKeyData + aKeyDataSize;

  // Consume '{' from start of object.
  EXPECT_SYMBOL(ctx, '{');

  while (true) {
    string label;
    // Consume member key.
    if (!GetNextLabel(ctx, label)) return false;
    EXPECT_SYMBOL(ctx, ':');

    if (label == "keys") {
      // Parse "keys" array.
      if (!ParseKeys(ctx, aOutKeys)) return false;
    } else if (label == "type") {
      // Consume type string.
      string type;
      if (!GetNextLabel(ctx, type)) return false;
      if (type != SessionTypeToString(aSessionType)) {
        return false;
      }
    } else {
      SkipToken(ctx);
    }

    // Check for end of object.
    if (PeekSymbol(ctx) == '}') {
      break;
    }

    // Consume ',' between object members.
    EXPECT_SYMBOL(ctx, ',');
  }

  // Consume '}' from end of object.
  EXPECT_SYMBOL(ctx, '}');

  return true;
}

static bool
ParseKeyIds(ParserContext& aCtx, vector<KeyId>& aOutKeyIds)
{
  // Consume start of array.
  EXPECT_SYMBOL(aCtx, '[');

  while (true) {
    string label;
    vector<uint8_t> keyId;
    if (!GetNextLabel(aCtx, label) || !DecodeBase64(label, keyId)) {
      return false;
    }
    if (!keyId.empty() && keyId.size() <= kMaxKeyIdsLength) {
      aOutKeyIds.push_back(keyId);
    }

    uint8_t sym = PeekSymbol(aCtx);
    if (!sym || sym == ']') {
      break;
    }

    EXPECT_SYMBOL(aCtx, ',');
  }

  return GetNextSymbol(aCtx) == ']';
}


/* static */ bool
ClearKeyUtils::ParseKeyIdsInitData(const uint8_t* aInitData,
                                   uint32_t aInitDataSize,
                                   vector<KeyId>& aOutKeyIds)
{
  ParserContext ctx;
  ctx.mIter = aInitData;
  ctx.mEnd = aInitData + aInitDataSize;

  // Consume '{' from start of object.
  EXPECT_SYMBOL(ctx, '{');

  while (true) {
    string label;
    // Consume member kids.
    if (!GetNextLabel(ctx, label)) return false;
    EXPECT_SYMBOL(ctx, ':');

    if (label == "kids") {
      // Parse "kids" array.
      if (!ParseKeyIds(ctx, aOutKeyIds) ||
          aOutKeyIds.empty()) {
        return false;
      }
    } else {
      SkipToken(ctx);
    }

    // Check for end of object.
    if (PeekSymbol(ctx) == '}') {
      break;
    }

    // Consume ',' between object members.
    EXPECT_SYMBOL(ctx, ',');
  }

  // Consume '}' from end of object.
  EXPECT_SYMBOL(ctx, '}');

  return true;
}

/* static */ const char*
ClearKeyUtils::SessionTypeToString(GMPSessionType aSessionType)
{
  switch (aSessionType) {
    case kGMPTemporySession: return "temporary";
    case kGMPPersistentSession: return "persistent-license";
    default: {
      assert(false); // Should not reach here.
      return "invalid";
    }
  }
}

/* static */ bool
ClearKeyUtils::IsValidSessionId(const char* aBuff, uint32_t aLength)
{
  if (aLength > 10) {
    // 10 is the max number of characters in UINT32_MAX when
    // represented as a string; ClearKey session ids are integers.
    return false;
  }
  for (uint32_t i = 0; i < aLength; i++) {
    if (!isdigit(aBuff[i])) {
      return false;
    }
  }
  return true;
}

GMPMutex* GMPCreateMutex() {
  GMPMutex* mutex;
  auto err = GetPlatform()->createmutex(&mutex);
  assert(mutex);
  return GMP_FAILED(err) ? nullptr : mutex;
}
