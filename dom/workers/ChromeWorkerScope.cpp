/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "ChromeWorkerScope.h"

#include "jsapi.h"

#include "nsXPCOM.h"
#include "nsNativeCharsetUtils.h"
#include "nsString.h"

#include "WorkerPrivate.h"

using namespace mozilla::dom;
USING_WORKERS_NAMESPACE

namespace {

#ifdef BUILD_CTYPES

char*
UnicodeToNative(JSContext* aCx, const char16_t* aSource, size_t aSourceLen)
{
  nsDependentString unicode(aSource, aSourceLen);

  nsAutoCString native;
  if (NS_FAILED(NS_CopyUnicodeToNative(unicode, native))) {
    JS_ReportErrorASCII(aCx, "Could not convert string to native charset!");
    return nullptr;
  }

  char* result = static_cast<char*>(JS_malloc(aCx, native.Length() + 1));
  if (!result) {
    return nullptr;
  }

  memcpy(result, native.get(), native.Length());
  result[native.Length()] = 0;
  return result;
}

#endif // BUILD_CTYPES

} // namespace

BEGIN_WORKERS_NAMESPACE

bool
DefineChromeWorkerFunctions(JSContext* aCx, JS::Handle<JSObject*> aGlobal)
{
  // Currently ctypes is the only special property given to ChromeWorkers.
#ifdef BUILD_CTYPES
  {
    JS::Rooted<JS::Value> ctypes(aCx);
    if (!JS_InitCTypesClass(aCx, aGlobal) ||
        !JS_GetProperty(aCx, aGlobal, "ctypes", &ctypes)) {
      return false;
    }

    static const JSCTypesCallbacks callbacks = {
      UnicodeToNative
    };

    JS_SetCTypesCallbacks(ctypes.toObjectOrNull(), &callbacks);
  }
#endif // BUILD_CTYPES

  return true;
}

END_WORKERS_NAMESPACE
