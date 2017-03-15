/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* vim: set ts=8 sts=4 et sw=4 tw=99: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */


#include "mozilla/scache/StartupCache.h"

#include "jsapi.h"
#include "jsfriendapi.h"

#include "nsJSPrincipals.h"

using namespace JS;
using namespace mozilla::scache;
using mozilla::UniquePtr;

// We only serialize scripts with system principals. So we don't serialize the
// principals when writing a script. Instead, when reading it back, we set the
// principals to the system principals.
nsresult
ReadCachedScript(StartupCache* cache, nsACString& uri, JSContext* cx,
                 nsIPrincipal* systemPrincipal, MutableHandleScript scriptp)
{
    UniquePtr<char[]> buf;
    uint32_t len;
    nsresult rv = cache->GetBuffer(PromiseFlatCString(uri).get(), &buf, &len);
    if (NS_FAILED(rv))
        return rv; // don't warn since NOT_AVAILABLE is an ok error

    JS::TranscodeBuffer buffer;
    buffer.replaceRawBuffer(reinterpret_cast<uint8_t*>(buf.release()), len);
    JS::TranscodeResult code = JS::DecodeScript(cx, buffer, scriptp);
    if (code == JS::TranscodeResult_Ok)
        return NS_OK;

    if ((code & JS::TranscodeResult_Failure) != 0)
        return NS_ERROR_FAILURE;

    MOZ_ASSERT((code & JS::TranscodeResult_Throw) != 0);
    JS_ClearPendingException(cx);
    return NS_ERROR_OUT_OF_MEMORY;
}

nsresult
ReadCachedFunction(StartupCache* cache, nsACString& uri, JSContext* cx,
                   nsIPrincipal* systemPrincipal, JSFunction** functionp)
{
    // This doesn't actually work ...
    return NS_ERROR_NOT_IMPLEMENTED;
}

nsresult
WriteCachedScript(StartupCache* cache, nsACString& uri, JSContext* cx,
                  nsIPrincipal* systemPrincipal, HandleScript script)
{
    MOZ_ASSERT(JS_GetScriptPrincipals(script) == nsJSPrincipals::get(systemPrincipal));

    JS::TranscodeBuffer buffer;
    JS::TranscodeResult code = JS::EncodeScript(cx, buffer, script);
    if (code != JS::TranscodeResult_Ok) {
        if ((code & JS::TranscodeResult_Failure) != 0)
            return NS_ERROR_FAILURE;
        MOZ_ASSERT((code & JS::TranscodeResult_Throw) != 0);
        JS_ClearPendingException(cx);
        return NS_ERROR_OUT_OF_MEMORY;
    }

    size_t size = buffer.length();
    if (size > UINT32_MAX)
        return NS_ERROR_FAILURE;
    nsresult rv = cache->PutBuffer(PromiseFlatCString(uri).get(),
                                   reinterpret_cast<char*>(buffer.begin()),
                                   size);
    return rv;
}

nsresult
WriteCachedFunction(StartupCache* cache, nsACString& uri, JSContext* cx,
                    nsIPrincipal* systemPrincipal, JSFunction* function)
{
    // This doesn't actually work ...
    return NS_ERROR_NOT_IMPLEMENTED;
}
