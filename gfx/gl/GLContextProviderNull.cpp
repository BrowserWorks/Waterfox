/* -*- Mode: C++; tab-width: 20; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "GLContextProvider.h"

namespace mozilla {
namespace gl {

using namespace mozilla::widget;

already_AddRefed<GLContext> GLContextProviderNull::CreateForCompositorWidget(
    CompositorWidget* aCompositorWidget, bool aWebRender,
    bool aForceAccelerated) {
  return nullptr;
}

already_AddRefed<GLContext> GLContextProviderNull::CreateWrappingExisting(
    void*, void*) {
  return nullptr;
}

already_AddRefed<GLContext> GLContextProviderNull::CreateOffscreen(
    const gfx::IntSize&, const SurfaceCaps&, CreateContextFlags,
    nsACString* const out_failureId) {
  *out_failureId = NS_LITERAL_CSTRING("FEATURE_FAILURE_NULL");
  return nullptr;
}

already_AddRefed<GLContext> GLContextProviderNull::CreateHeadless(
    CreateContextFlags, nsACString* const out_failureId) {
  *out_failureId = NS_LITERAL_CSTRING("FEATURE_FAILURE_NULL");
  return nullptr;
}

GLContext* GLContextProviderNull::GetGlobalContext() { return nullptr; }

void GLContextProviderNull::Shutdown() {}

} /* namespace gl */
} /* namespace mozilla */
