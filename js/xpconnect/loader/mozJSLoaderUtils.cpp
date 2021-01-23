/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/scache/StartupCache.h"

#include "jsapi.h"
#include "jsfriendapi.h"

#include "mozilla/BasePrincipal.h"

using namespace JS;
using namespace mozilla::scache;
using mozilla::UniquePtr;

// We only serialize scripts with system principals. So we don't serialize the
// principals when writing a script. Instead, when reading it back, we set the
// principals to the system principals.
nsresult ReadCachedScript(StartupCache* cache, nsACString& uri, JSContext* cx,
                          MutableHandleScript scriptp) {
  const char* buf;
  uint32_t len;
  nsresult rv = cache->GetBuffer(PromiseFlatCString(uri).get(), &buf, &len);
  if (NS_FAILED(rv)) {
    return rv;  // don't warn since NOT_AVAILABLE is an ok error
  }
  void* copy = malloc(len);
  if (!copy) {
    return NS_ERROR_OUT_OF_MEMORY;
  }
  memcpy(copy, buf, len);
  JS::TranscodeBuffer buffer;
  buffer.replaceRawBuffer(reinterpret_cast<uint8_t*>(copy), len);
  JS::TranscodeResult code = JS::DecodeScript(cx, buffer, scriptp);
  if (code == JS::TranscodeResult_Ok) {
    return NS_OK;
  }

  if ((code & JS::TranscodeResult_Failure) != 0) {
    return NS_ERROR_FAILURE;
  }

  MOZ_ASSERT((code & JS::TranscodeResult_Throw) != 0);
  JS_ClearPendingException(cx);
  return NS_ERROR_OUT_OF_MEMORY;
}

nsresult WriteCachedScript(StartupCache* cache, nsACString& uri, JSContext* cx,
                           HandleScript script) {
  MOZ_ASSERT(
      nsJSPrincipals::get(JS_GetScriptPrincipals(script))->IsSystemPrincipal());

  JS::TranscodeBuffer buffer;
  JS::TranscodeResult code = JS::EncodeScript(cx, buffer, script);
  if (code != JS::TranscodeResult_Ok) {
    if ((code & JS::TranscodeResult_Failure) != 0) {
      return NS_ERROR_FAILURE;
    }
    MOZ_ASSERT((code & JS::TranscodeResult_Throw) != 0);
    JS_ClearPendingException(cx);
    return NS_ERROR_OUT_OF_MEMORY;
  }

  size_t size = buffer.length();
  if (size > UINT32_MAX) {
    return NS_ERROR_FAILURE;
  }

  // Move the vector buffer into a unique pointer buffer.
  UniquePtr<char[]> buf(
      reinterpret_cast<char*>(buffer.extractOrCopyRawBuffer()));
  nsresult rv =
      cache->PutBuffer(PromiseFlatCString(uri).get(), std::move(buf), size);
  return rv;
}
