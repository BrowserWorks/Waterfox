/* -*- Mode: c++; c-basic-offset: 2; indent-tabs-mode: nil; tab-width: 4; -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "GLScreenBuffer.h"

#include <cstring>
#include "CompositorTypes.h"
#include "mozilla/StaticPrefs_webgl.h"
#include "GLContext.h"
#include "GLBlitHelper.h"
#include "GLReadTexImageHelper.h"
#include "SharedSurfaceEGL.h"
#include "SharedSurfaceGL.h"
#include "ScopedGLHelpers.h"
#include "gfx2DGlue.h"
#include "../layers/ipc/ShadowLayers.h"
#include "mozilla/layers/TextureForwarder.h"
#include "mozilla/layers/TextureClientSharedSurface.h"

#ifdef XP_WIN
#  include "SharedSurfaceANGLE.h"         // for SurfaceFactory_ANGLEShareHandle
#  include "SharedSurfaceD3D11Interop.h"  // for SurfaceFactory_D3D11Interop
#  include "mozilla/gfx/DeviceManagerDx.h"
#endif

#ifdef XP_MACOSX
#  include "SharedSurfaceIO.h"
#endif

#ifdef MOZ_X11
#  include "GLXLibrary.h"
#  include "SharedSurfaceGLX.h"
#endif

#ifdef MOZ_WAYLAND
#  include "gfxPlatformGtk.h"
#  include "SharedSurfaceDMABUF.h"
#endif

namespace mozilla::gl {

UniquePtr<GLScreenBuffer> GLScreenBuffer::Create(GLContext* gl,
                                                 const gfx::IntSize& size,
                                                 const SurfaceCaps& caps) {
  UniquePtr<GLScreenBuffer> ret;

  layers::TextureFlags flags = layers::TextureFlags::ORIGIN_BOTTOM_LEFT;
  if (!caps.premultAlpha) {
    flags |= layers::TextureFlags::NON_PREMULTIPLIED;
  }

  UniquePtr<SurfaceFactory> factory =
      MakeUnique<SurfaceFactory_Basic>(gl, caps, flags);

  ret.reset(new GLScreenBuffer(gl, caps, std::move(factory)));
  return ret;
}

/* static */
UniquePtr<SurfaceFactory> GLScreenBuffer::CreateFactory(
    GLContext* gl, const SurfaceCaps& caps,
    layers::KnowsCompositor* compositorConnection,
    const layers::TextureFlags& flags) {
  const auto& ipcChannel = compositorConnection->GetTextureForwarder();
  const auto& backend = compositorConnection->GetCompositorBackendType();
  bool useANGLE = compositorConnection->GetCompositorUseANGLE();
  return CreateFactory(gl, caps, ipcChannel, backend, useANGLE, flags);
}

/* static */
UniquePtr<SurfaceFactory> GLScreenBuffer::CreateFactory(
    GLContext* gl, const SurfaceCaps& caps,
    layers::LayersIPCChannel* ipcChannel, layers::LayersBackend backend,
    bool useANGLE, const layers::TextureFlags& flags) {
  const bool useGl =
      !StaticPrefs::webgl_force_layers_readback() &&
      (backend == layers::LayersBackend::LAYERS_OPENGL ||
       (backend == layers::LayersBackend::LAYERS_WR && !useANGLE));
  const bool useD3D =
      !StaticPrefs::webgl_force_layers_readback() &&
      (backend == layers::LayersBackend::LAYERS_D3D11 ||
       (backend == layers::LayersBackend::LAYERS_WR && useANGLE));

  UniquePtr<SurfaceFactory> factory = nullptr;
  if (useGl) {
#if defined(XP_MACOSX)
    factory = SurfaceFactory_IOSurface::Create(gl, caps, ipcChannel, flags);
#elif defined(MOZ_WAYLAND)
    if (gl->GetContextType() == GLContextType::EGL) {
      if (gfxPlatformGtk::GetPlatform()->UseWaylandDMABufWebGL()) {
        factory =
            MakeUnique<SurfaceFactory_DMABUF>(gl, caps, ipcChannel, flags);
      }
    }
#elif defined(MOZ_X11)
    if (sGLXLibrary.UseTextureFromPixmap())
      factory = SurfaceFactory_GLXDrawable::Create(gl, caps, ipcChannel, flags);
#elif defined(MOZ_WIDGET_UIKIT)
    factory = MakeUnique<SurfaceFactory_GLTexture>(mGLContext, caps, ipcChannel,
                                                   mFlags);
#elif defined(MOZ_WIDGET_ANDROID)
    if (XRE_IsParentProcess() && !StaticPrefs::webgl_enable_surface_texture()) {
      factory = SurfaceFactory_EGLImage::Create(gl, caps, ipcChannel, flags);
    } else {
      factory =
          SurfaceFactory_SurfaceTexture::Create(gl, caps, ipcChannel, flags);
    }
#else
    if (gl->GetContextType() == GLContextType::EGL) {
      if (XRE_IsParentProcess()) {
        factory = SurfaceFactory_EGLImage::Create(gl, caps, ipcChannel, flags);
      }
    }
#endif
  } else if (useD3D) {
#ifdef XP_WIN
    // Ensure devices initialization. SharedSurfaceANGLE and
    // SharedSurfaceD3D11Interop use them. The devices are lazily initialized
    // with WebRender to reduce memory usage.
    if (XRE_IsContentProcess()) {
      gfxPlatform::GetPlatform()->EnsureDevicesInitialized();
    }

    // Enable surface sharing only if ANGLE and compositing devices
    // are both WARP or both not WARP
    gfx::DeviceManagerDx* dm = gfx::DeviceManagerDx::Get();
    MOZ_ASSERT(dm);
    if (gl->IsANGLE() && (gl->IsWARP() == dm->IsWARP()) &&
        dm->TextureSharingWorks()) {
      factory =
          SurfaceFactory_ANGLEShareHandle::Create(gl, caps, ipcChannel, flags);
    }

    if (!factory && StaticPrefs::webgl_dxgl_enabled()) {
      factory =
          SurfaceFactory_D3D11Interop::Create(gl, caps, ipcChannel, flags);
    }
#endif
  }

#ifdef MOZ_X11
  if (!factory && sGLXLibrary.UseTextureFromPixmap()) {
    factory = SurfaceFactory_GLXDrawable::Create(gl, caps, ipcChannel, flags);
  }
#endif

  return factory;
}

GLScreenBuffer::GLScreenBuffer(GLContext* gl, const SurfaceCaps& caps,
                               UniquePtr<SurfaceFactory> factory)
    : mGL(gl),
      mCaps(caps),
      mFactory(std::move(factory)),
      mUserDrawFB(0),
      mUserReadFB(0),
      mInternalDrawFB(0),
      mInternalReadFB(0)
#ifdef DEBUG
      ,
      mInInternalMode_DrawFB(true),
      mInInternalMode_ReadFB(true)
#endif
{
}

GLScreenBuffer::~GLScreenBuffer() {
  mFactory = nullptr;
  mRead = nullptr;

  if (!mBack) return;

  // Detach mBack cleanly.
  mBack->Surf()->ProducerRelease();
}

void GLScreenBuffer::BindFB(GLuint fb) {
  GLuint drawFB = DrawFB();
  GLuint readFB = ReadFB();

  mUserDrawFB = fb;
  mUserReadFB = fb;
  mInternalDrawFB = (fb == 0) ? drawFB : fb;
  mInternalReadFB = (fb == 0) ? readFB : fb;

  if (mInternalDrawFB == mInternalReadFB) {
    mGL->raw_fBindFramebuffer(LOCAL_GL_FRAMEBUFFER, mInternalDrawFB);
  } else {
    MOZ_ASSERT(mGL->IsSupported(GLFeature::split_framebuffer));
    mGL->raw_fBindFramebuffer(LOCAL_GL_DRAW_FRAMEBUFFER_EXT, mInternalDrawFB);
    mGL->raw_fBindFramebuffer(LOCAL_GL_READ_FRAMEBUFFER_EXT, mInternalReadFB);
  }

#ifdef DEBUG
  mInInternalMode_DrawFB = false;
  mInInternalMode_ReadFB = false;
#endif
}

void GLScreenBuffer::BindDrawFB(GLuint fb) {
  MOZ_ASSERT(mGL->IsSupported(GLFeature::split_framebuffer));

  GLuint drawFB = DrawFB();
  mUserDrawFB = fb;
  mInternalDrawFB = (fb == 0) ? drawFB : fb;

  mGL->raw_fBindFramebuffer(LOCAL_GL_DRAW_FRAMEBUFFER_EXT, mInternalDrawFB);

#ifdef DEBUG
  mInInternalMode_DrawFB = false;
#endif
}

void GLScreenBuffer::BindReadFB(GLuint fb) {
  MOZ_ASSERT(mGL->IsSupported(GLFeature::split_framebuffer));

  GLuint readFB = ReadFB();
  mUserReadFB = fb;
  mInternalReadFB = (fb == 0) ? readFB : fb;

  mGL->raw_fBindFramebuffer(LOCAL_GL_READ_FRAMEBUFFER_EXT, mInternalReadFB);

#ifdef DEBUG
  mInInternalMode_ReadFB = false;
#endif
}

void GLScreenBuffer::BindReadFB_Internal(GLuint fb) {
  MOZ_ASSERT(mGL->IsSupported(GLFeature::split_framebuffer));

  mInternalReadFB = mUserReadFB = fb;
  mGL->raw_fBindFramebuffer(LOCAL_GL_READ_FRAMEBUFFER_EXT, mInternalReadFB);

#ifdef DEBUG
  mInInternalMode_ReadFB = true;
#endif
}

GLuint GLScreenBuffer::GetDrawFB() const {
#ifdef DEBUG
  MOZ_ASSERT(!mInInternalMode_DrawFB);

  // Don't need a branch here, because:
  // LOCAL_GL_DRAW_FRAMEBUFFER_BINDING_EXT == LOCAL_GL_FRAMEBUFFER_BINDING ==
  // 0x8CA6 We use raw_ here because this is debug code and we need to see what
  // the driver thinks.
  GLuint actual = 0;
  mGL->raw_fGetIntegerv(LOCAL_GL_DRAW_FRAMEBUFFER_BINDING_EXT, (GLint*)&actual);

  GLuint predicted = mInternalDrawFB;
  if (predicted != actual && !mGL->CheckContextLost()) {
    printf_stderr("Misprediction: Bound draw FB predicted: %d. Was: %d.\n",
                  predicted, actual);
    MOZ_ASSERT(false, "Draw FB binding misprediction!");
  }
#endif

  return mUserDrawFB;
}

GLuint GLScreenBuffer::GetReadFB() const {
#ifdef DEBUG
  MOZ_ASSERT(!mInInternalMode_ReadFB);

  // We use raw_ here because this is debug code and we need to see what
  // the driver thinks.
  GLuint actual = 0;
  if (mGL->IsSupported(GLFeature::split_framebuffer))
    mGL->raw_fGetIntegerv(LOCAL_GL_READ_FRAMEBUFFER_BINDING_EXT,
                          (GLint*)&actual);
  else
    mGL->raw_fGetIntegerv(LOCAL_GL_FRAMEBUFFER_BINDING, (GLint*)&actual);

  GLuint predicted = mInternalReadFB;
  if (predicted != actual && !mGL->CheckContextLost()) {
    printf_stderr("Misprediction: Bound read FB predicted: %d. Was: %d.\n",
                  predicted, actual);
    MOZ_ASSERT(false, "Read FB binding misprediction!");
  }
#endif

  return mUserReadFB;
}

GLuint GLScreenBuffer::GetFB() const {
  MOZ_ASSERT(GetDrawFB() == GetReadFB());
  return GetDrawFB();
}

void GLScreenBuffer::DeletingFB(GLuint fb) {
  if (fb == mInternalDrawFB) {
    mInternalDrawFB = 0;
    mUserDrawFB = 0;
  }
  if (fb == mInternalReadFB) {
    mInternalReadFB = 0;
    mUserReadFB = 0;
  }
}

bool GLScreenBuffer::CopyTexImage2D(GLenum target, GLint level,
                                    GLenum internalformat, GLint x, GLint y,
                                    GLsizei width, GLsizei height,
                                    GLint border) {
  SharedSurface* surf;
  if (GetReadFB() == 0) {
    surf = SharedSurf();
  } else {
    surf = mGL->mFBOMapping[GetReadFB()];
  }
  if (surf) {
    return surf->CopyTexImage2D(target, level, internalformat, x, y, width,
                                height, border);
  }

  return false;
}

bool GLScreenBuffer::ReadPixels(GLint x, GLint y, GLsizei width, GLsizei height,
                                GLenum format, GLenum type, GLvoid* pixels) {
  // If the currently bound framebuffer is backed by a SharedSurface
  // then it might want to override how we read pixel data from it.
  // This is normally only the default framebuffer, but we can also
  // have SharedSurfaces bound to other framebuffers when doing
  // readback for BasicLayers.
  SharedSurface* surf;
  if (GetReadFB() == 0) {
    surf = SharedSurf();
  } else {
    surf = mGL->mFBOMapping[GetReadFB()];
  }
  if (surf) {
    return surf->ReadPixels(x, y, width, height, format, type, pixels);
  }

  return false;
}

void GLScreenBuffer::Morph(UniquePtr<SurfaceFactory> newFactory) {
  MOZ_RELEASE_ASSERT(newFactory, "newFactory must not be null");
  mFactory = std::move(newFactory);
}

bool GLScreenBuffer::Attach(SharedSurface* surf, const gfx::IntSize& size) {
  ScopedBindFramebuffer autoFB(mGL);

  const bool readNeedsUnlock = (mRead && SharedSurf());
  if (readNeedsUnlock) {
    SharedSurf()->UnlockProd();
  }

  surf->LockProd();

  if (mRead && surf->mAttachType == SharedSurf()->mAttachType &&
      size == Size()) {
    // Same size, same type, ready for reuse!
    mRead->Attach(surf);
  } else {
    UniquePtr<ReadBuffer> read = CreateRead(surf);
    if (!read) {
      surf->UnlockProd();
      if (readNeedsUnlock) {
        SharedSurf()->LockProd();
      }
      return false;
    }

    mRead = std::move(read);
  }

  // Check that we're all set up.
  MOZ_ASSERT(SharedSurf() == surf);

  return true;
}

bool GLScreenBuffer::Swap(const gfx::IntSize& size) {
  RefPtr<layers::SharedSurfaceTextureClient> newBack =
      mFactory->NewTexClient(size);
  if (!newBack) return false;

  // In the case of DXGL interop, the new surface needs to be acquired before
  // it is attached so that the interop surface is locked, which populates
  // the GL renderbuffer. This results in the renderbuffer being ready and
  // attachment to framebuffer succeeds in Attach() call.
  newBack->Surf()->ProducerAcquire();

  if (!Attach(newBack->Surf(), size)) {
    newBack->Surf()->ProducerRelease();
    return false;
  }
  // Attach was successful.

  mFront = mBack;
  mBack = newBack;

  if (mCaps.preserve && mFront && mBack) {
    auto src = mFront->Surf();
    auto dest = mBack->Surf();

    // uint32_t srcPixel = ReadPixel(src);
    // uint32_t destPixel = ReadPixel(dest);
    // printf_stderr("Before: src: 0x%08x, dest: 0x%08x\n", srcPixel,
    // destPixel);
#ifdef DEBUG
    GLContext::LocalErrorScope errorScope(*mGL);
#endif

    if (!SharedSurface::ProdCopy(src, dest, mFactory.get())) {
      newBack->Surf()->ProducerRelease();
      return false;
    }

#ifdef DEBUG
    MOZ_ASSERT(!errorScope.GetError());
#endif

    // srcPixel = ReadPixel(src);
    // destPixel = ReadPixel(dest);
    // printf_stderr("After: src: 0x%08x, dest: 0x%08x\n", srcPixel, destPixel);
  }

  // XXX: We would prefer to fence earlier on platforms that don't need
  // the full ProducerAcquire/ProducerRelease semantics, so that the fence
  // doesn't include the copy operation. Unfortunately, the current API
  // doesn't expose a good way to do that.
  if (mFront) {
    mFront->Surf()->ProducerRelease();
  }

  return true;
}

bool GLScreenBuffer::Resize(const gfx::IntSize& size) {
  RefPtr<layers::SharedSurfaceTextureClient> newBack =
      mFactory->NewTexClient(size);
  if (!newBack) return false;

  if (!Attach(newBack->Surf(), size)) return false;

  if (mBack) mBack->Surf()->ProducerRelease();

  mBack = newBack;

  mBack->Surf()->ProducerAcquire();

  return true;
}

UniquePtr<ReadBuffer> GLScreenBuffer::CreateRead(SharedSurface* surf) {
  GLContext* gl = mFactory->mGL;
  const GLFormats& formats = mFactory->mFormats;
  const SurfaceCaps& caps = mFactory->ReadCaps();

  return ReadBuffer::Create(gl, caps, formats, surf);
}

////////////////////////////////////////////////////////////////////////
// Utils

static void CreateRenderbuffersForOffscreen(GLContext* const aGL,
                                            const GLFormats& aFormats,
                                            const gfx::IntSize& aSize,
                                            GLuint* const aDepthRB,
                                            GLuint* const aStencilRB) {
  const auto fnCreateRenderbuffer = [&](const GLenum sizedFormat) {
    GLuint rb = 0;
    aGL->fGenRenderbuffers(1, &rb);
    ScopedBindRenderbuffer autoRB(aGL, rb);

    aGL->fRenderbufferStorage(LOCAL_GL_RENDERBUFFER, sizedFormat, aSize.width,
                              aSize.height);
    return rb;
  };

  if (aDepthRB && aStencilRB && aFormats.depthStencil) {
    *aDepthRB = fnCreateRenderbuffer(aFormats.depthStencil);
    *aStencilRB = *aDepthRB;
  } else {
    if (aDepthRB) {
      MOZ_ASSERT(aFormats.depth);

      *aDepthRB = fnCreateRenderbuffer(aFormats.depth);
    }

    if (aStencilRB) {
      MOZ_ASSERT(aFormats.stencil);

      *aStencilRB = fnCreateRenderbuffer(aFormats.stencil);
    }
  }
}

////////////////////////////////////////////////////////////////////////
// ReadBuffer

UniquePtr<ReadBuffer> ReadBuffer::Create(GLContext* gl, const SurfaceCaps& caps,
                                         const GLFormats& formats,
                                         SharedSurface* surf) {
  MOZ_ASSERT(surf);

  if (surf->mAttachType == AttachmentType::Screen) {
    // Don't need anything. Our read buffer will be the 'screen'.
    return UniquePtr<ReadBuffer>(new ReadBuffer(gl, 0, 0, 0, surf));
  }

  GLuint depthRB = 0;
  GLuint stencilRB = 0;

  GLuint* pDepthRB = caps.depth ? &depthRB : nullptr;
  GLuint* pStencilRB = caps.stencil ? &stencilRB : nullptr;

  GLContext::LocalErrorScope localError(*gl);

  CreateRenderbuffersForOffscreen(gl, formats, surf->mSize, pDepthRB,
                                  pStencilRB);

  GLuint colorTex = 0;
  GLuint colorRB = 0;
  GLenum target = 0;

  switch (surf->mAttachType) {
    case AttachmentType::GLTexture:
      colorTex = surf->ProdTexture();
      target = surf->ProdTextureTarget();
      break;
    case AttachmentType::GLRenderbuffer:
      colorRB = surf->ProdRenderbuffer();
      break;
    default:
      MOZ_CRASH("GFX: Unknown attachment type, create?");
  }
  MOZ_ASSERT(colorTex || colorRB);

  GLuint fb = 0;
  gl->fGenFramebuffers(1, &fb);
  gl->AttachBuffersToFB(colorTex, colorRB, depthRB, stencilRB, fb, target);
  gl->mFBOMapping[fb] = surf;

  UniquePtr<ReadBuffer> ret(new ReadBuffer(gl, fb, depthRB, stencilRB, surf));

  GLenum err = localError.GetError();
  MOZ_ASSERT_IF(err != LOCAL_GL_NO_ERROR, err == LOCAL_GL_OUT_OF_MEMORY);
  if (err) return nullptr;

  const bool needsAcquire = !surf->IsProducerAcquired();
  if (needsAcquire) {
    surf->ProducerReadAcquire();
  }
  const bool isComplete = gl->IsFramebufferComplete(fb);
  if (needsAcquire) {
    surf->ProducerReadRelease();
  }

  if (!isComplete) return nullptr;

  return ret;
}

ReadBuffer::~ReadBuffer() {
  if (!mGL->MakeCurrent()) return;

  GLuint fb = mFB;
  GLuint rbs[] = {
      mDepthRB,
      (mStencilRB != mDepthRB) ? mStencilRB
                               : 0,  // Don't double-delete DEPTH_STENCIL RBs.
  };

  mGL->fDeleteFramebuffers(1, &fb);
  mGL->fDeleteRenderbuffers(2, rbs);

  mGL->mFBOMapping.erase(mFB);
}

void ReadBuffer::Attach(SharedSurface* surf) {
  MOZ_ASSERT(surf && mSurf);
  MOZ_ASSERT(surf->mAttachType == mSurf->mAttachType);
  MOZ_ASSERT(surf->mSize == mSurf->mSize);

  // Nothing else is needed for AttachType Screen.
  if (surf->mAttachType != AttachmentType::Screen) {
    GLuint colorTex = 0;
    GLuint colorRB = 0;
    GLenum target = 0;

    switch (surf->mAttachType) {
      case AttachmentType::GLTexture:
        colorTex = surf->ProdTexture();
        target = surf->ProdTextureTarget();
        break;
      case AttachmentType::GLRenderbuffer:
        colorRB = surf->ProdRenderbuffer();
        break;
      default:
        MOZ_CRASH("GFX: Unknown attachment type, attach?");
    }

    mGL->AttachBuffersToFB(colorTex, colorRB, 0, 0, mFB, target);
    mGL->mFBOMapping[mFB] = surf;
    MOZ_GL_ASSERT(mGL, mGL->IsFramebufferComplete(mFB));
  }

  mSurf = surf;
}

const gfx::IntSize& ReadBuffer::Size() const { return mSurf->mSize; }

}  // namespace mozilla::gl
