/* -*- Mode: C++; tab-width: 20; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "WebGLExtensions.h"

#include "GLContext.h"
#include "mozilla/dom/WebGLRenderingContextBinding.h"
#include "mozilla/StaticPrefs_webgl.h"
#include "WebGLContext.h"

namespace mozilla {

WebGLExtensionBlendMinMax::WebGLExtensionBlendMinMax(WebGLContext* webgl)
    : WebGLExtensionBase(webgl) {
  MOZ_ASSERT(IsSupported(webgl), "Don't construct extension if unsupported.");
}

bool WebGLExtensionBlendMinMax::IsSupported(const WebGLContext* webgl) {
  if (webgl->IsWebGL2()) return false;

  return webgl->GL()->IsSupported(gl::GLFeature::blend_minmax);
}

// -

WebGLExtensionExplicitPresent::WebGLExtensionExplicitPresent(
    WebGLContext* const webgl)
    : WebGLExtensionBase(webgl) {
  MOZ_ASSERT(IsSupported(webgl), "Don't construct extension if unsupported.");
}

bool WebGLExtensionExplicitPresent::IsSupported(
    const WebGLContext* const webgl) {
  return StaticPrefs::webgl_enable_draft_extensions();
}

// -

WebGLExtensionFloatBlend::WebGLExtensionFloatBlend(WebGLContext* const webgl)
    : WebGLExtensionBase(webgl) {
  MOZ_ASSERT(IsSupported(webgl), "Don't construct extension if unsupported.");
}

bool WebGLExtensionFloatBlend::IsSupported(const WebGLContext* const webgl) {
  if (!WebGLExtensionColorBufferFloat::IsSupported(webgl) &&
      !WebGLExtensionEXTColorBufferFloat::IsSupported(webgl))
    return false;

  const auto& gl = webgl->gl;
  if (!gl->IsGLES() && gl->Version() >= 300) return true;
  if (gl->IsGLES() && gl->Version() >= 320) return true;
  return gl->IsExtensionSupported(gl::GLContext::EXT_float_blend);
}

// -

WebGLExtensionFBORenderMipmap::WebGLExtensionFBORenderMipmap(
    WebGLContext* const webgl)
    : WebGLExtensionBase(webgl) {
  MOZ_ASSERT(IsSupported(webgl), "Don't construct extension if unsupported.");
}

bool WebGLExtensionFBORenderMipmap::IsSupported(
    const WebGLContext* const webgl) {
  if (webgl->IsWebGL2()) return false;

  const auto& gl = webgl->gl;
  if (!gl->IsGLES()) return true;
  if (gl->Version() >= 300) return true;
  return gl->IsExtensionSupported(gl::GLContext::OES_fbo_render_mipmap);
}

// -

WebGLExtensionMultiview::WebGLExtensionMultiview(WebGLContext* const webgl)
    : WebGLExtensionBase(webgl) {
  MOZ_ASSERT(IsSupported(webgl), "Don't construct extension if unsupported.");
}

bool WebGLExtensionMultiview::IsSupported(const WebGLContext* const webgl) {
  if (!webgl->IsWebGL2()) return false;

  const auto& gl = webgl->gl;
  return gl->IsSupported(gl::GLFeature::multiview);
}

}  // namespace mozilla
