/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "WebGLExtensions.h"

#include "GLContext.h"
#include "mozilla/dom/WebGLRenderingContextBinding.h"
#include "WebGLContext.h"
#include "WebGLFormats.h"

namespace mozilla {

WebGLExtensionCompressedTextureASTC::WebGLExtensionCompressedTextureASTC(
    WebGLContext* webgl)
    : WebGLExtensionBase(webgl) {
  MOZ_ASSERT(IsSupported(webgl), "Don't construct extension if unsupported.");

  RefPtr<WebGLContext> webgl_ = webgl;  // Bug 1201275
  const auto fnAdd = [&webgl_](GLenum sizedFormat,
                               webgl::EffectiveFormat effFormat) {
    auto& fua = webgl_->mFormatUsage;

    auto usage = fua->EditUsage(effFormat);
    usage->isFilterable = true;
    fua->AllowSizedTexFormat(sizedFormat, usage);
  };

#define FOO(x) LOCAL_GL_##x, webgl::EffectiveFormat::x

  fnAdd(FOO(COMPRESSED_RGBA_ASTC_4x4_KHR));
  fnAdd(FOO(COMPRESSED_RGBA_ASTC_5x4_KHR));
  fnAdd(FOO(COMPRESSED_RGBA_ASTC_5x5_KHR));
  fnAdd(FOO(COMPRESSED_RGBA_ASTC_6x5_KHR));
  fnAdd(FOO(COMPRESSED_RGBA_ASTC_6x6_KHR));
  fnAdd(FOO(COMPRESSED_RGBA_ASTC_8x5_KHR));
  fnAdd(FOO(COMPRESSED_RGBA_ASTC_8x6_KHR));
  fnAdd(FOO(COMPRESSED_RGBA_ASTC_8x8_KHR));
  fnAdd(FOO(COMPRESSED_RGBA_ASTC_10x5_KHR));
  fnAdd(FOO(COMPRESSED_RGBA_ASTC_10x6_KHR));
  fnAdd(FOO(COMPRESSED_RGBA_ASTC_10x8_KHR));
  fnAdd(FOO(COMPRESSED_RGBA_ASTC_10x10_KHR));
  fnAdd(FOO(COMPRESSED_RGBA_ASTC_12x10_KHR));
  fnAdd(FOO(COMPRESSED_RGBA_ASTC_12x12_KHR));

  fnAdd(FOO(COMPRESSED_SRGB8_ALPHA8_ASTC_4x4_KHR));
  fnAdd(FOO(COMPRESSED_SRGB8_ALPHA8_ASTC_5x4_KHR));
  fnAdd(FOO(COMPRESSED_SRGB8_ALPHA8_ASTC_5x5_KHR));
  fnAdd(FOO(COMPRESSED_SRGB8_ALPHA8_ASTC_6x5_KHR));
  fnAdd(FOO(COMPRESSED_SRGB8_ALPHA8_ASTC_6x6_KHR));
  fnAdd(FOO(COMPRESSED_SRGB8_ALPHA8_ASTC_8x5_KHR));
  fnAdd(FOO(COMPRESSED_SRGB8_ALPHA8_ASTC_8x6_KHR));
  fnAdd(FOO(COMPRESSED_SRGB8_ALPHA8_ASTC_8x8_KHR));
  fnAdd(FOO(COMPRESSED_SRGB8_ALPHA8_ASTC_10x5_KHR));
  fnAdd(FOO(COMPRESSED_SRGB8_ALPHA8_ASTC_10x6_KHR));
  fnAdd(FOO(COMPRESSED_SRGB8_ALPHA8_ASTC_10x8_KHR));
  fnAdd(FOO(COMPRESSED_SRGB8_ALPHA8_ASTC_10x10_KHR));
  fnAdd(FOO(COMPRESSED_SRGB8_ALPHA8_ASTC_12x10_KHR));
  fnAdd(FOO(COMPRESSED_SRGB8_ALPHA8_ASTC_12x12_KHR));

#undef FOO
}

bool WebGLExtensionCompressedTextureASTC::IsSupported(
    const WebGLContext* webgl) {
  gl::GLContext* gl = webgl->GL();
  return gl->IsExtensionSupported(
      gl::GLContext::KHR_texture_compression_astc_ldr);
}

}  // namespace mozilla
