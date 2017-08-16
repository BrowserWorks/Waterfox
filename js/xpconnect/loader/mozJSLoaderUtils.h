/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* vim: set ts=8 sts=4 et sw=4 tw=99: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozJSLoaderUtils_h
#define mozJSLoaderUtils_h

#include "nsString.h"

namespace mozilla {
namespace scache {
class StartupCache;
} // namespace scache
} // namespace mozilla

nsresult
ReadCachedScript(mozilla::scache::StartupCache* cache, nsACString& uri,
                 JSContext* cx, nsIPrincipal* systemPrincipal,
                 JS::MutableHandleScript scriptp);

nsresult
WriteCachedScript(mozilla::scache::StartupCache* cache, nsACString& uri,
                  JSContext* cx, nsIPrincipal* systemPrincipal,
                  JS::HandleScript script);

#endif /* mozJSLoaderUtils_h */
