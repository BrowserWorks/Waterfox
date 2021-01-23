/* -*- Mode: C++; tab-width: 20; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#if defined(MOZ_WIDGET_GTK)
#  define GET_NATIVE_WINDOW_FROM_REAL_WIDGET(aWidget) \
    ((EGLNativeWindowType)aWidget->GetNativeData(NS_NATIVE_EGL_WINDOW))
#  define GET_NATIVE_WINDOW_FROM_COMPOSITOR_WIDGET(aWidget) \
    (aWidget->AsX11()->GetEGLNativeWindow())
#elif defined(MOZ_WIDGET_ANDROID)
#  define GET_NATIVE_WINDOW_FROM_REAL_WIDGET(aWidget) \
    ((EGLNativeWindowType)aWidget->GetNativeData(NS_JAVA_SURFACE))
#  define GET_NATIVE_WINDOW_FROM_COMPOSITOR_WIDGET(aWidget) \
    (aWidget->AsAndroid()->GetEGLNativeWindow())
#elif defined(XP_WIN)
#  define GET_NATIVE_WINDOW_FROM_REAL_WIDGET(aWidget) \
    ((EGLNativeWindowType)aWidget->GetNativeData(NS_NATIVE_WINDOW))
#  define GET_NATIVE_WINDOW_FROM_COMPOSITOR_WIDGET(aWidget) \
    ((EGLNativeWindowType)aWidget->AsWindows()->GetHwnd())
#else
#  define GET_NATIVE_WINDOW_FROM_REAL_WIDGET(aWidget) \
    ((EGLNativeWindowType)aWidget->GetNativeData(NS_NATIVE_WINDOW))
#  define GET_NATIVE_WINDOW_FROM_COMPOSITOR_WIDGET(aWidget)     \
    ((EGLNativeWindowType)aWidget->RealWidget()->GetNativeData( \
        NS_NATIVE_WINDOW))
#endif

#if defined(XP_UNIX)
#  ifdef MOZ_WIDGET_ANDROID
#    include <android/native_window.h>
#    include <android/native_window_jni.h>
#    include "mozilla/widget/AndroidCompositorWidget.h"
#  endif

#  define GLES2_LIB "libGLESv2.so"
#  define GLES2_LIB2 "libGLESv2.so.2"

#elif defined(XP_WIN)
#  include "mozilla/widget/WinCompositorWidget.h"
#  include "nsIFile.h"

#  define GLES2_LIB "libGLESv2.dll"

#  ifndef WIN32_LEAN_AND_MEAN
#    define WIN32_LEAN_AND_MEAN 1
#  endif

#  include <windows.h>
#else
#  error "Platform not recognized"
#endif

#include "gfxASurface.h"
#include "gfxCrashReporterUtils.h"
#include "gfxFailure.h"
#include "gfxPlatform.h"
#include "gfxUtils.h"
#include "GLBlitHelper.h"
#include "GLContextEGL.h"
#include "GLContextProvider.h"
#include "GLLibraryEGL.h"
#include "LayersLogging.h"
#include "mozilla/ArrayUtils.h"
#include "mozilla/Preferences.h"
#include "mozilla/Services.h"
#include "mozilla/gfx/gfxVars.h"
#include "mozilla/layers/CompositorOptions.h"
#include "mozilla/widget/CompositorWidget.h"
#include "nsDebug.h"
#include "nsIWidget.h"
#include "nsThreadUtils.h"
#include "ScopedGLHelpers.h"
#include "TextureImageEGL.h"

#if defined(MOZ_WIDGET_GTK)
#  include "mozilla/widget/GtkCompositorWidget.h"
#endif

#if defined(MOZ_WAYLAND)
#  include "nsDataHashtable.h"

#  include <gtk/gtk.h>
#  include <gdk/gdkx.h>
#  include <gdk/gdkwayland.h>
#  include <wayland-egl.h>
#  include <dlfcn.h>

#  define IS_WAYLAND_DISPLAY()    \
    (gdk_display_get_default() && \
     !GDK_IS_X11_DISPLAY(gdk_display_get_default()))
#endif

using namespace mozilla::gfx;

namespace mozilla {
namespace gl {

using namespace mozilla::widget;

#if defined(MOZ_WAYLAND)
class WaylandGLSurface {
 public:
  WaylandGLSurface(struct wl_surface* aWaylandSurface,
                   struct wl_egl_window* aEGLWindow);
  ~WaylandGLSurface();

 private:
  struct wl_surface* mWaylandSurface;
  struct wl_egl_window* mEGLWindow;
};

static nsDataHashtable<nsPtrHashKey<void>, WaylandGLSurface*> sWaylandGLSurface;

void DeleteWaylandGLSurface(EGLSurface surface) {
  // We're running on Wayland which means our EGLSurface may
  // have attached Wayland backend data which must be released.
  if (IS_WAYLAND_DISPLAY()) {
    auto entry = sWaylandGLSurface.Lookup(surface);
    if (entry) {
      delete entry.Data();
      entry.Remove();
    }
  }
}
#endif

#define ADD_ATTR_2(_array, _k, _v) \
  do {                             \
    (_array).AppendElement(_k);    \
    (_array).AppendElement(_v);    \
  } while (0)

#define ADD_ATTR_1(_array, _k)  \
  do {                          \
    (_array).AppendElement(_k); \
  } while (0)

static bool CreateConfigScreen(GLLibraryEGL* const egl,
                               EGLConfig* const aConfig,
                               const bool aEnableDepthBuffer,
                               const bool aUseGles);

// append three zeros at the end of attribs list to work around
// EGL implementation bugs that iterate until they find 0, instead of
// EGL_NONE. See bug 948406.
#define EGL_ATTRIBS_LIST_SAFE_TERMINATION_WORKING_AROUND_BUGS \
  LOCAL_EGL_NONE, 0, 0, 0

static EGLint kTerminationAttribs[] = {
    EGL_ATTRIBS_LIST_SAFE_TERMINATION_WORKING_AROUND_BUGS};

static int next_power_of_two(int v) {
  v--;
  v |= v >> 1;
  v |= v >> 2;
  v |= v >> 4;
  v |= v >> 8;
  v |= v >> 16;
  v++;

  return v;
}

static bool is_power_of_two(int v) {
  NS_ASSERTION(v >= 0, "bad value");

  if (v == 0) return true;

  return (v & (v - 1)) == 0;
}

static void DestroySurface(GLLibraryEGL* const egl,
                           const EGLSurface oldSurface) {
  if (oldSurface != EGL_NO_SURFACE) {
    // TODO: This breaks TLS MakeCurrent caching.
    egl->fMakeCurrent(egl->Display(), EGL_NO_SURFACE, EGL_NO_SURFACE,
                      EGL_NO_CONTEXT);
    egl->fDestroySurface(egl->Display(), oldSurface);
#if defined(MOZ_WAYLAND)
    DeleteWaylandGLSurface(oldSurface);
#endif
  }
}

static EGLSurface CreateFallbackSurface(GLLibraryEGL* const egl,
                                        const EGLConfig& config) {
  nsCString discardFailureId;
  if (!GLLibraryEGL::EnsureInitialized(false, &discardFailureId)) {
    gfxCriticalNote << "Failed to load EGL library 3!";
    return EGL_NO_SURFACE;
  }

  if (egl->IsExtensionSupported(GLLibraryEGL::KHR_surfaceless_context)) {
    // We don't need a PBuffer surface in this case
    return EGL_NO_SURFACE;
  }

  std::vector<EGLint> pbattrs;
  pbattrs.push_back(LOCAL_EGL_WIDTH);
  pbattrs.push_back(1);
  pbattrs.push_back(LOCAL_EGL_HEIGHT);
  pbattrs.push_back(1);

  for (const auto& cur : kTerminationAttribs) {
    pbattrs.push_back(cur);
  }

  EGLSurface surface =
      egl->fCreatePbufferSurface(egl->Display(), config, pbattrs.data());
  if (!surface) {
    MOZ_CRASH("Failed to create fallback EGLSurface");
  }

  return surface;
}

static EGLSurface CreateSurfaceFromNativeWindow(
    GLLibraryEGL* const egl, const EGLNativeWindowType window,
    const EGLConfig config) {
  MOZ_ASSERT(window);
  EGLSurface newSurface = EGL_NO_SURFACE;

#ifdef MOZ_WIDGET_ANDROID
  JNIEnv* const env = jni::GetEnvForThread();
  ANativeWindow* const nativeWindow =
      ANativeWindow_fromSurface(env, reinterpret_cast<jobject>(window));
  newSurface = egl->fCreateWindowSurface(egl->fGetDisplay(EGL_DEFAULT_DISPLAY),
                                         config, nativeWindow, 0);
  ANativeWindow_release(nativeWindow);
#else
  newSurface = egl->fCreateWindowSurface(egl->Display(), config, window, 0);
#endif
  return newSurface;
}

/* GLContextEGLFactory class was added as a friend of GLContextEGL
 * so that it could access  GLContextEGL::CreateGLContext. This was
 * done so that a new function would not need to be added to the shared
 * GLContextProvider interface.
 */
class GLContextEGLFactory {
 public:
  static already_AddRefed<GLContext> Create(EGLNativeWindowType aWindow,
                                            bool aWebRender);
  static already_AddRefed<GLContext> CreateImpl(EGLNativeWindowType aWindow,
                                                bool aWebRender, bool aUseGles);

 private:
  GLContextEGLFactory() = default;
  ~GLContextEGLFactory() = default;
};

already_AddRefed<GLContext> GLContextEGLFactory::CreateImpl(
    EGLNativeWindowType aWindow, bool aWebRender, bool aUseGles) {
  nsCString discardFailureId;
  if (!GLLibraryEGL::EnsureInitialized(false, &discardFailureId)) {
    gfxCriticalNote << "Failed to load EGL library 3!";
    return nullptr;
  }

  auto* egl = gl::GLLibraryEGL::Get();
  bool doubleBuffered = true;

  EGLConfig config;
  if (aWebRender && egl->IsANGLE()) {
    // Force enable alpha channel to make sure ANGLE use correct framebuffer
    // formart
    const int bpp = 32;
    const bool withDepth = true;
    if (!CreateConfig(egl, &config, bpp, withDepth, aUseGles)) {
      gfxCriticalNote << "Failed to create EGLConfig for WebRender ANGLE!";
      return nullptr;
    }
  } else {
    if (!CreateConfigScreen(egl, &config, /* aEnableDepthBuffer */ aWebRender,
                            aUseGles)) {
      gfxCriticalNote << "Failed to create EGLConfig!";
      return nullptr;
    }
  }

  EGLSurface surface = EGL_NO_SURFACE;
  if (aWindow) {
    surface = mozilla::gl::CreateSurfaceFromNativeWindow(egl, aWindow, config);
  }

  CreateContextFlags flags = CreateContextFlags::NONE;
  if (aWebRender && aUseGles) {
    flags |= CreateContextFlags::PREFER_ES3;
  }
  if (!aWebRender) {
    flags |= CreateContextFlags::REQUIRE_COMPAT_PROFILE;
  }

  SurfaceCaps caps = SurfaceCaps::Any();
  RefPtr<GLContextEGL> gl = GLContextEGL::CreateGLContext(
      egl, flags, caps, false, config, surface, aUseGles, &discardFailureId);
  if (!gl) {
    const auto err = egl->fGetError();
    gfxCriticalNote << "Failed to create EGLContext!: " << gfx::hexa(err);
    mozilla::gl::DestroySurface(egl, surface);
    return nullptr;
  }

  gl->MakeCurrent();
  gl->SetIsDoubleBuffered(doubleBuffered);

#if defined(MOZ_WAYLAND)
  if (surface != EGL_NO_SURFACE && IS_WAYLAND_DISPLAY()) {
    // Make eglSwapBuffers() non-blocking on wayland
    egl->fSwapInterval(egl->Display(), 0);
  }
#endif
  if (aWebRender && egl->IsANGLE()) {
    MOZ_ASSERT(doubleBuffered);
    egl->fSwapInterval(egl->Display(), 0);
  }
  return gl.forget();
}

already_AddRefed<GLContext> GLContextEGLFactory::Create(
    EGLNativeWindowType aWindow, bool aWebRender) {
  RefPtr<GLContext> glContext = CreateImpl(aWindow, aWebRender,
                                           /* aUseGles */ false);
  if (!glContext) {
    glContext = CreateImpl(aWindow, aWebRender, /* aUseGles */ true);
  }
  return glContext.forget();
}

#if defined(MOZ_WAYLAND) || defined(MOZ_WIDGET_ANDROID)
/* static */
EGLSurface GLContextEGL::CreateEGLSurfaceForCompositorWidget(
    widget::CompositorWidget* aCompositorWidget, const EGLConfig aConfig) {
  nsCString discardFailureId;
  if (!GLLibraryEGL::EnsureInitialized(false, &discardFailureId)) {
    gfxCriticalNote << "Failed to load EGL library 6!";
    return EGL_NO_SURFACE;
  }

  MOZ_ASSERT(aCompositorWidget);
  EGLNativeWindowType window =
      GET_NATIVE_WINDOW_FROM_COMPOSITOR_WIDGET(aCompositorWidget);
  if (!window) {
    gfxCriticalNote << "window is null";
    return EGL_NO_SURFACE;
  }

  const auto& egl = GLLibraryEGL::Get();
  return mozilla::gl::CreateSurfaceFromNativeWindow(egl, window, aConfig);
}
#endif

GLContextEGL::GLContextEGL(GLLibraryEGL* const egl, CreateContextFlags flags,
                           const SurfaceCaps& caps, bool isOffscreen,
                           EGLConfig config, EGLSurface surface,
                           EGLContext context)
    : GLContext(flags, caps, nullptr, isOffscreen, false),
      mEgl(egl),
      mConfig(config),
      mContext(context),
      mSurface(surface),
      mFallbackSurface(CreateFallbackSurface(mEgl, mConfig)) {
#ifdef DEBUG
  printf_stderr("Initializing context %p surface %p on display %p\n", mContext,
                mSurface, mEgl->Display());
#endif
}

void GLContextEGL::OnMarkDestroyed() {
  if (mSurfaceOverride != EGL_NO_SURFACE) {
    SetEGLSurfaceOverride(EGL_NO_SURFACE);
  }
}

GLContextEGL::~GLContextEGL() {
  MarkDestroyed();

  // Wrapped context should not destroy eglContext/Surface
  if (!mOwnsContext) {
    return;
  }

#ifdef DEBUG
  printf_stderr("Destroying context %p surface %p on display %p\n", mContext,
                mSurface, mEgl->Display());
#endif

  mEgl->fDestroyContext(mEgl->Display(), mContext);

  mozilla::gl::DestroySurface(mEgl, mSurface);
  mozilla::gl::DestroySurface(mEgl, mFallbackSurface);
}

bool GLContextEGL::Init() {
  if (!GLContext::Init()) return false;

  bool current = MakeCurrent();
  if (!current) {
    gfx::LogFailure(
        NS_LITERAL_CSTRING("Couldn't get device attachments for device."));
    return false;
  }

  mShareWithEGLImage = mEgl->HasKHRImageBase() &&
                       mEgl->HasKHRImageTexture2D() &&
                       IsExtensionSupported(OES_EGL_image);

  return true;
}

bool GLContextEGL::BindTexImage() {
  if (!mSurface) return false;

  if (mBound && !ReleaseTexImage()) return false;

  EGLBoolean success = mEgl->fBindTexImage(
      mEgl->Display(), (EGLSurface)mSurface, LOCAL_EGL_BACK_BUFFER);
  if (success == LOCAL_EGL_FALSE) return false;

  mBound = true;
  return true;
}

bool GLContextEGL::ReleaseTexImage() {
  if (!mBound) return true;

  if (!mSurface) return false;

  EGLBoolean success;
  success = mEgl->fReleaseTexImage(mEgl->Display(), (EGLSurface)mSurface,
                                   LOCAL_EGL_BACK_BUFFER);
  if (success == LOCAL_EGL_FALSE) return false;

  mBound = false;
  return true;
}

void GLContextEGL::SetEGLSurfaceOverride(EGLSurface surf) {
  mSurfaceOverride = surf;
  DebugOnly<bool> ok = MakeCurrent(true);
  MOZ_ASSERT(ok);
}

bool GLContextEGL::MakeCurrentImpl() const {
  EGLSurface surface =
      (mSurfaceOverride != EGL_NO_SURFACE) ? mSurfaceOverride : mSurface;
  if (!surface) {
    surface = mFallbackSurface;
  }

  const bool succeeded =
      mEgl->fMakeCurrent(mEgl->Display(), surface, surface, mContext);
  if (!succeeded) {
    const auto eglError = mEgl->fGetError();
    if (eglError == LOCAL_EGL_CONTEXT_LOST) {
      OnContextLostError();
    } else {
      NS_WARNING("Failed to make GL context current!");
#ifdef DEBUG
      printf_stderr("EGL Error: 0x%04x\n", eglError);
#endif
    }
  }

  return succeeded;
}

bool GLContextEGL::IsCurrentImpl() const {
  return mEgl->fGetCurrentContext() == mContext;
}

bool GLContextEGL::RenewSurface(CompositorWidget* aWidget) {
  if (!mOwnsContext) {
    return false;
  }
  // unconditionally release the surface and create a new one. Don't try to
  // optimize this away. If we get here, then by definition we know that we want
  // to get a new surface.
  ReleaseSurface();
  MOZ_ASSERT(aWidget);

  EGLNativeWindowType nativeWindow =
      GET_NATIVE_WINDOW_FROM_COMPOSITOR_WIDGET(aWidget);
  if (nativeWindow) {
    mSurface =
        mozilla::gl::CreateSurfaceFromNativeWindow(mEgl, nativeWindow, mConfig);
    if (!mSurface) {
      NS_WARNING("Failed to create EGLSurface from native window");
      return false;
    }
  }
  const bool ok = MakeCurrent(true);
  MOZ_ASSERT(ok);
#if defined(MOZ_WAYLAND)
  if (mSurface && IS_WAYLAND_DISPLAY()) {
    // Make eglSwapBuffers() non-blocking on wayland
    mEgl->fSwapInterval(mEgl->Display(), 0);
  }
#endif
  return ok;
}

void GLContextEGL::ReleaseSurface() {
  if (mOwnsContext) {
    mozilla::gl::DestroySurface(mEgl, mSurface);
  }
  if (mSurface == mSurfaceOverride) {
    mSurfaceOverride = EGL_NO_SURFACE;
  }
  mSurface = EGL_NO_SURFACE;
}

Maybe<SymbolLoader> GLContextEGL::GetSymbolLoader() const {
  return mEgl->GetSymbolLoader();
}

bool GLContextEGL::SwapBuffers() {
  EGLSurface surface =
      mSurfaceOverride != EGL_NO_SURFACE ? mSurfaceOverride : mSurface;
  if (surface) {
    if ((mEgl->IsExtensionSupported(
             GLLibraryEGL::EXT_swap_buffers_with_damage) ||
         mEgl->IsExtensionSupported(
             GLLibraryEGL::KHR_swap_buffers_with_damage))) {
      std::vector<EGLint> rects;
      for (auto iter = mDamageRegion.RectIter(); !iter.Done(); iter.Next()) {
        const IntRect& r = iter.Get();
        rects.push_back(r.X());
        rects.push_back(r.Y());
        rects.push_back(r.Width());
        rects.push_back(r.Height());
      }
      mDamageRegion.SetEmpty();
      return mEgl->fSwapBuffersWithDamage(mEgl->Display(), surface,
                                          rects.data(), rects.size() / 4);
    }
    return mEgl->fSwapBuffers(mEgl->Display(), surface);
  } else {
    return false;
  }
}

void GLContextEGL::SetDamage(const nsIntRegion& aDamageRegion) {
  mDamageRegion = aDamageRegion;
}

void GLContextEGL::GetWSIInfo(nsCString* const out) const {
  out->AppendLiteral("EGL_VENDOR: ");
  out->Append(
      (const char*)mEgl->fQueryString(mEgl->Display(), LOCAL_EGL_VENDOR));

  out->AppendLiteral("\nEGL_VERSION: ");
  out->Append(
      (const char*)mEgl->fQueryString(mEgl->Display(), LOCAL_EGL_VERSION));

  out->AppendLiteral("\nEGL_EXTENSIONS: ");
  out->Append(
      (const char*)mEgl->fQueryString(mEgl->Display(), LOCAL_EGL_EXTENSIONS));

#ifndef ANDROID  // This query will crash some old android.
  out->AppendLiteral("\nEGL_EXTENSIONS(nullptr): ");
  out->Append((const char*)mEgl->fQueryString(nullptr, LOCAL_EGL_EXTENSIONS));
#endif
}

// hold a reference to the given surface
// for the lifetime of this context.
void GLContextEGL::HoldSurface(gfxASurface* aSurf) { mThebesSurface = aSurf; }

bool GLContextEGL::HasBufferAge() const {
  return mEgl->IsExtensionSupported(GLLibraryEGL::EXT_buffer_age);
}

EGLint GLContextEGL::GetBufferAge() const {
  EGLSurface surface =
      mSurfaceOverride != EGL_NO_SURFACE ? mSurfaceOverride : mSurface;

  if (surface && HasBufferAge()) {
    EGLint result;
    mEgl->fQuerySurface(mEgl->Display(), surface, LOCAL_EGL_BUFFER_AGE_EXT,
                        &result);
    return result;
  }

  return 0;
}

#define LOCAL_EGL_CONTEXT_PROVOKING_VERTEX_DONT_CARE_MOZ 0x6000

already_AddRefed<GLContextEGL> GLContextEGL::CreateGLContext(
    GLLibraryEGL* const egl, CreateContextFlags flags, const SurfaceCaps& caps,
    bool isOffscreen, EGLConfig config, EGLSurface surface, const bool useGles,
    nsACString* const out_failureId) {
  std::vector<EGLint> required_attribs;

  if (useGles) {
    if (egl->fBindAPI(LOCAL_EGL_OPENGL_ES_API) == LOCAL_EGL_FALSE) {
      *out_failureId = NS_LITERAL_CSTRING("FEATURE_FAILURE_EGL_ES");
      NS_WARNING("Failed to bind API to GLES!");
      return nullptr;
    }
    required_attribs.push_back(LOCAL_EGL_CONTEXT_MAJOR_VERSION);
    if (flags & CreateContextFlags::PREFER_ES3) {
      required_attribs.push_back(3);
    } else {
      required_attribs.push_back(2);
    }
  } else {
    if (egl->fBindAPI(LOCAL_EGL_OPENGL_API) == LOCAL_EGL_FALSE) {
      *out_failureId = NS_LITERAL_CSTRING("FEATURE_FAILURE_EGL");
      NS_WARNING("Failed to bind API to GL!");
      return nullptr;
    }
    if (flags & CreateContextFlags::REQUIRE_COMPAT_PROFILE) {
      required_attribs.push_back(LOCAL_EGL_CONTEXT_OPENGL_PROFILE_MASK);
      required_attribs.push_back(
          LOCAL_EGL_CONTEXT_OPENGL_COMPATIBILITY_PROFILE_BIT);
      required_attribs.push_back(LOCAL_EGL_CONTEXT_MAJOR_VERSION);
      required_attribs.push_back(2);
    } else {
      required_attribs.push_back(LOCAL_EGL_CONTEXT_MAJOR_VERSION);
      required_attribs.push_back(3);
      required_attribs.push_back(LOCAL_EGL_CONTEXT_MINOR_VERSION);
      required_attribs.push_back(1);
    }
  }

  if ((flags & CreateContextFlags::PREFER_EXACT_VERSION) && egl->IsANGLE()) {
    required_attribs.push_back(
        LOCAL_EGL_CONTEXT_OPENGL_BACKWARDS_COMPATIBLE_ANGLE);
    required_attribs.push_back(LOCAL_EGL_FALSE);
  }

  const auto debugFlags = GLContext::ChooseDebugFlags(flags);
  if (!debugFlags && flags & CreateContextFlags::NO_VALIDATION &&
      egl->IsExtensionSupported(GLLibraryEGL::KHR_create_context_no_error)) {
    required_attribs.push_back(LOCAL_EGL_CONTEXT_OPENGL_NO_ERROR_KHR);
    required_attribs.push_back(LOCAL_EGL_TRUE);
  }

  if (flags & CreateContextFlags::PROVOKING_VERTEX_DONT_CARE &&
      egl->IsExtensionSupported(
          GLLibraryEGL::MOZ_create_context_provoking_vertex_dont_care)) {
    required_attribs.push_back(
        LOCAL_EGL_CONTEXT_PROVOKING_VERTEX_DONT_CARE_MOZ);
    required_attribs.push_back(LOCAL_EGL_TRUE);
  }

  std::vector<EGLint> robustness_attribs;
  std::vector<EGLint> rbab_attribs;  // RBAB: Robust Buffer Access Behavior
  if (flags & CreateContextFlags::PREFER_ROBUSTNESS) {
    if (egl->IsExtensionSupported(
            GLLibraryEGL::EXT_create_context_robustness)) {
      robustness_attribs = required_attribs;
      robustness_attribs.push_back(
          LOCAL_EGL_CONTEXT_OPENGL_RESET_NOTIFICATION_STRATEGY_EXT);
      robustness_attribs.push_back(LOCAL_EGL_LOSE_CONTEXT_ON_RESET_EXT);

      // Don't enable robust buffer access on Adreno 630 devices.
      // It causes the linking of some shaders to fail. See bug 1485441.
      nsCOMPtr<nsIGfxInfo> gfxInfo = services::GetGfxInfo();
      nsAutoString renderer;
      gfxInfo->GetAdapterDeviceID(renderer);
      if (renderer.Find("Adreno (TM) 630") == -1) {
        rbab_attribs = robustness_attribs;
        rbab_attribs.push_back(LOCAL_EGL_CONTEXT_OPENGL_ROBUST_ACCESS_EXT);
        rbab_attribs.push_back(LOCAL_EGL_TRUE);
      }
    } else if (egl->IsExtensionSupported(GLLibraryEGL::KHR_create_context)) {
      robustness_attribs = required_attribs;
      robustness_attribs.push_back(
          LOCAL_EGL_CONTEXT_OPENGL_RESET_NOTIFICATION_STRATEGY_KHR);
      robustness_attribs.push_back(LOCAL_EGL_LOSE_CONTEXT_ON_RESET_KHR);

      rbab_attribs = robustness_attribs;
      rbab_attribs.push_back(LOCAL_EGL_CONTEXT_FLAGS_KHR);
      rbab_attribs.push_back(LOCAL_EGL_CONTEXT_OPENGL_ROBUST_ACCESS_BIT_KHR);
    }
  }

  const auto fnCreate = [&](const std::vector<EGLint>& attribs) {
    auto terminated_attribs = attribs;

    for (const auto& cur : kTerminationAttribs) {
      terminated_attribs.push_back(cur);
    }

    return egl->fCreateContext(egl->Display(), config, EGL_NO_CONTEXT,
                               terminated_attribs.data());
  };

  EGLContext context;
  do {
    if (!rbab_attribs.empty()) {
      context = fnCreate(rbab_attribs);
      if (context) break;
      NS_WARNING("Failed to create EGLContext with rbab_attribs");
    }

    if (!robustness_attribs.empty()) {
      context = fnCreate(robustness_attribs);
      if (context) break;
      NS_WARNING("Failed to create EGLContext with robustness_attribs");
    }

    context = fnCreate(required_attribs);
    if (context) break;
    NS_WARNING("Failed to create EGLContext with required_attribs");

    *out_failureId = NS_LITERAL_CSTRING("FEATURE_FAILURE_EGL_CREATE");
    return nullptr;
  } while (false);
  MOZ_ASSERT(context);

  RefPtr<GLContextEGL> glContext =
      new GLContextEGL(egl, flags, caps, isOffscreen, config, surface, context);
  if (!glContext->Init()) {
    *out_failureId = NS_LITERAL_CSTRING("FEATURE_FAILURE_EGL_INIT");
    return nullptr;
  }

  return glContext.forget();
}

// static
EGLSurface GLContextEGL::CreatePBufferSurfaceTryingPowerOfTwo(
    GLLibraryEGL* const egl, EGLConfig config, EGLenum bindToTextureFormat,
    mozilla::gfx::IntSize& pbsize) {
  nsTArray<EGLint> pbattrs(16);
  EGLSurface surface = nullptr;

TRY_AGAIN_POWER_OF_TWO:
  pbattrs.Clear();
  pbattrs.AppendElement(LOCAL_EGL_WIDTH);
  pbattrs.AppendElement(pbsize.width);
  pbattrs.AppendElement(LOCAL_EGL_HEIGHT);
  pbattrs.AppendElement(pbsize.height);

  if (bindToTextureFormat != LOCAL_EGL_NONE) {
    pbattrs.AppendElement(LOCAL_EGL_TEXTURE_TARGET);
    pbattrs.AppendElement(LOCAL_EGL_TEXTURE_2D);

    pbattrs.AppendElement(LOCAL_EGL_TEXTURE_FORMAT);
    pbattrs.AppendElement(bindToTextureFormat);
  }

  for (const auto& cur : kTerminationAttribs) {
    pbattrs.AppendElement(cur);
  }

  surface = egl->fCreatePbufferSurface(egl->Display(), config, &pbattrs[0]);
  if (!surface) {
    if (!is_power_of_two(pbsize.width) || !is_power_of_two(pbsize.height)) {
      if (!is_power_of_two(pbsize.width))
        pbsize.width = next_power_of_two(pbsize.width);
      if (!is_power_of_two(pbsize.height))
        pbsize.height = next_power_of_two(pbsize.height);

      NS_WARNING("Failed to create pbuffer, trying power of two dims");
      goto TRY_AGAIN_POWER_OF_TWO;
    }

    NS_WARNING("Failed to create pbuffer surface");
    return nullptr;
  }

  return surface;
}

#if defined(MOZ_WAYLAND)
WaylandGLSurface::WaylandGLSurface(struct wl_surface* aWaylandSurface,
                                   struct wl_egl_window* aEGLWindow)
    : mWaylandSurface(aWaylandSurface), mEGLWindow(aEGLWindow) {}

WaylandGLSurface::~WaylandGLSurface() {
  wl_egl_window_destroy(mEGLWindow);
  wl_surface_destroy(mWaylandSurface);
}

// static
EGLSurface GLContextEGL::CreateWaylandBufferSurface(
    GLLibraryEGL* const egl, EGLConfig config, mozilla::gfx::IntSize& pbsize) {
  // Available as of GTK 3.8+
  static auto sGdkWaylandDisplayGetWlCompositor =
      (wl_compositor * (*)(GdkDisplay*))
          dlsym(RTLD_DEFAULT, "gdk_wayland_display_get_wl_compositor");

  if (!sGdkWaylandDisplayGetWlCompositor) return nullptr;

  struct wl_compositor* compositor =
      sGdkWaylandDisplayGetWlCompositor(gdk_display_get_default());
  struct wl_surface* wlsurface = wl_compositor_create_surface(compositor);
  struct wl_egl_window* eglwindow =
      wl_egl_window_create(wlsurface, pbsize.width, pbsize.height);

  EGLSurface surface =
      egl->fCreateWindowSurface(egl->Display(), config, eglwindow, 0);

  if (surface) {
    WaylandGLSurface* waylandData = new WaylandGLSurface(wlsurface, eglwindow);
    auto entry = sWaylandGLSurface.LookupForAdd(surface);
    entry.OrInsert([&waylandData]() { return waylandData; });
  }

  return surface;
}
#endif

static const EGLint kEGLConfigAttribsRGB16[] = {
    LOCAL_EGL_SURFACE_TYPE, LOCAL_EGL_WINDOW_BIT,
    LOCAL_EGL_RED_SIZE,     5,
    LOCAL_EGL_GREEN_SIZE,   6,
    LOCAL_EGL_BLUE_SIZE,    5,
    LOCAL_EGL_ALPHA_SIZE,   0};

static const EGLint kEGLConfigAttribsRGB24[] = {
    LOCAL_EGL_SURFACE_TYPE, LOCAL_EGL_WINDOW_BIT,
    LOCAL_EGL_RED_SIZE,     8,
    LOCAL_EGL_GREEN_SIZE,   8,
    LOCAL_EGL_BLUE_SIZE,    8,
    LOCAL_EGL_ALPHA_SIZE,   0};

static const EGLint kEGLConfigAttribsRGBA32[] = {
    LOCAL_EGL_SURFACE_TYPE, LOCAL_EGL_WINDOW_BIT,
    LOCAL_EGL_RED_SIZE,     8,
    LOCAL_EGL_GREEN_SIZE,   8,
    LOCAL_EGL_BLUE_SIZE,    8,
    LOCAL_EGL_ALPHA_SIZE,   8};

bool CreateConfig(GLLibraryEGL* const egl, EGLConfig* aConfig, int32_t depth,
                  bool aEnableDepthBuffer, bool aUseGles) {
  EGLConfig configs[64];
  std::vector<EGLint> attribs;
  EGLint ncfg = ArrayLength(configs);

  switch (depth) {
    case 16:
      for (const auto& cur : kEGLConfigAttribsRGB16) {
        attribs.push_back(cur);
      }
      break;
    case 24:
      for (const auto& cur : kEGLConfigAttribsRGB24) {
        attribs.push_back(cur);
      }
      break;
    case 32:
      for (const auto& cur : kEGLConfigAttribsRGBA32) {
        attribs.push_back(cur);
      }
      break;
    default:
      NS_ERROR("Unknown pixel depth");
      return false;
  }

  if (aUseGles) {
    attribs.push_back(LOCAL_EGL_RENDERABLE_TYPE);
    attribs.push_back(LOCAL_EGL_OPENGL_ES2_BIT);
  }
  for (const auto& cur : kTerminationAttribs) {
    attribs.push_back(cur);
  }

  if (!egl->fChooseConfig(egl->Display(), attribs.data(), configs, ncfg,
                          &ncfg) ||
      ncfg < 1) {
    return false;
  }

  for (int j = 0; j < ncfg; ++j) {
    EGLConfig config = configs[j];
    EGLint r, g, b, a;
    if (egl->fGetConfigAttrib(egl->Display(), config, LOCAL_EGL_RED_SIZE, &r) &&
        egl->fGetConfigAttrib(egl->Display(), config, LOCAL_EGL_GREEN_SIZE,
                              &g) &&
        egl->fGetConfigAttrib(egl->Display(), config, LOCAL_EGL_BLUE_SIZE,
                              &b) &&
        egl->fGetConfigAttrib(egl->Display(), config, LOCAL_EGL_ALPHA_SIZE,
                              &a) &&
        ((depth == 16 && r == 5 && g == 6 && b == 5) ||
         (depth == 24 && r == 8 && g == 8 && b == 8) ||
         (depth == 32 && r == 8 && g == 8 && b == 8 && a == 8))) {
      EGLint z;
      if (aEnableDepthBuffer) {
        if (!egl->fGetConfigAttrib(egl->Display(), config, LOCAL_EGL_DEPTH_SIZE,
                                   &z) ||
            z != 24) {
          continue;
        }
      }
      *aConfig = config;
      return true;
    }
  }
  return false;
}

// Return true if a suitable EGLConfig was found and pass it out
// through aConfig.  Return false otherwise.
//
// NB: It's entirely legal for the returned EGLConfig to be valid yet
// have the value null.
static bool CreateConfigScreen(GLLibraryEGL* const egl,
                               EGLConfig* const aConfig,
                               const bool aEnableDepthBuffer,
                               const bool aUseGles) {
  int32_t depth = gfxVars::ScreenDepth();
  if (!CreateConfig(egl, aConfig, depth, aEnableDepthBuffer, aUseGles)) {
#ifdef MOZ_WIDGET_ANDROID
    // Bug 736005
    // Android doesn't always support 16 bit so also try 24 bit
    if (depth == 16) {
      return CreateConfig(egl, aConfig, 24, aEnableDepthBuffer, aUseGles);
    }
    // Bug 970096
    // Some devices that have 24 bit screens only support 16 bit OpenGL?
    if (depth == 24) {
      return CreateConfig(egl, aConfig, 16, aEnableDepthBuffer, aUseGles);
    }
#endif
    return false;
  } else {
    return true;
  }
}

already_AddRefed<GLContext> GLContextProviderEGL::CreateWrappingExisting(
    void* aContext, void* aSurface) {
  nsCString discardFailureId;
  if (!GLLibraryEGL::EnsureInitialized(false, &discardFailureId)) {
    MOZ_CRASH("GFX: Failed to load EGL library 2!");
    return nullptr;
  }

  if (!aContext || !aSurface) return nullptr;

  const auto& egl = GLLibraryEGL::Get();
  SurfaceCaps caps = SurfaceCaps::Any();
  EGLConfig config = EGL_NO_CONFIG;
  RefPtr<GLContextEGL> gl =
      new GLContextEGL(egl, CreateContextFlags::NONE, caps, false, config,
                       (EGLSurface)aSurface, (EGLContext)aContext);
  gl->SetIsDoubleBuffered(true);
  gl->mOwnsContext = false;

  return gl.forget();
}

already_AddRefed<GLContext> GLContextProviderEGL::CreateForCompositorWidget(
    CompositorWidget* aCompositorWidget, bool aWebRender,
    bool aForceAccelerated) {
  EGLNativeWindowType window = nullptr;
  if (aCompositorWidget) {
    window = GET_NATIVE_WINDOW_FROM_COMPOSITOR_WIDGET(aCompositorWidget);
  }
  return GLContextEGLFactory::Create(window, aWebRender);
}

#if defined(MOZ_WIDGET_ANDROID)
EGLSurface GLContextEGL::CreateCompatibleSurface(void* aWindow) {
  if (mConfig == EGL_NO_CONFIG) {
    MOZ_CRASH("GFX: Failed with invalid EGLConfig 2!");
  }

  return GLContextProviderEGL::CreateEGLSurface(aWindow, mConfig);
}

/* static */
static EGLSurface CreateEGLSurfaceImpl(void* aWindow, EGLConfig aConfig,
                                       bool aUseGles) {
  // NOTE: aWindow is an ANativeWindow
  nsCString discardFailureId;
  if (!GLLibraryEGL::EnsureInitialized(false, &discardFailureId)) {
    MOZ_CRASH("GFX: Failed to load EGL library 4!");
  }
  auto* egl = gl::GLLibraryEGL::Get();
  EGLConfig config = aConfig;
  if (!config && !CreateConfigScreen(egl, &config,
                                     /* aEnableDepthBuffer */ false,
                                     /* useGles */ aUseGles)) {
    return EGL_NO_SURFACE;
  }

  MOZ_ASSERT(aWindow);
  return egl->fCreateWindowSurface(egl->Display(), config, aWindow, 0);
}

/* static */
EGLSurface GLContextProviderEGL::CreateEGLSurface(void* aWindow,
                                                  EGLConfig aConfig) {
  EGLSurface surface =
      CreateEGLSurfaceImpl(aWindow, aConfig, /* aUseGles */ false);
  if (surface == EGL_NO_SURFACE) {
    surface = CreateEGLSurfaceImpl(aWindow, aConfig, /* aUseGles */ true);
    if (surface == EGL_NO_SURFACE) {
      MOZ_CRASH("GFX: Failed to create EGLSurface 2!");
    }
  }
  return surface;
}

/* static */
void GLContextProviderEGL::DestroyEGLSurface(EGLSurface surface) {
  nsCString discardFailureId;
  if (!GLLibraryEGL::EnsureInitialized(false, &discardFailureId)) {
    MOZ_CRASH("GFX: Failed to load EGL library 5!");
  }
  auto* egl = gl::GLLibraryEGL::Get();
  egl->fDestroySurface(egl->Display(), surface);
}
#endif  // defined(ANDROID)

static void FillOffscreenContextAttribs(bool alpha, bool depth, bool stencil,
                                        bool bpp16, bool es3, bool useGles,
                                        nsTArray<EGLint>* out) {
  out->AppendElement(LOCAL_EGL_SURFACE_TYPE);
#if defined(MOZ_WAYLAND)
  if (IS_WAYLAND_DISPLAY()) {
    // Wayland on desktop does not support PBuffer or FBO.
    // We create a dummy wl_egl_window instead.
    out->AppendElement(LOCAL_EGL_WINDOW_BIT);
  } else {
    out->AppendElement(LOCAL_EGL_PBUFFER_BIT);
  }
#else
  out->AppendElement(LOCAL_EGL_PBUFFER_BIT);
#endif

  if (useGles) {
    out->AppendElement(LOCAL_EGL_RENDERABLE_TYPE);
    if (es3) {
      out->AppendElement(LOCAL_EGL_OPENGL_ES3_BIT_KHR);
    } else {
      out->AppendElement(LOCAL_EGL_OPENGL_ES2_BIT);
    }
  }

  out->AppendElement(LOCAL_EGL_RED_SIZE);
  if (bpp16) {
    out->AppendElement(alpha ? 4 : 5);
  } else {
    out->AppendElement(8);
  }

  out->AppendElement(LOCAL_EGL_GREEN_SIZE);
  if (bpp16) {
    out->AppendElement(alpha ? 4 : 6);
  } else {
    out->AppendElement(8);
  }

  out->AppendElement(LOCAL_EGL_BLUE_SIZE);
  if (bpp16) {
    out->AppendElement(alpha ? 4 : 5);
  } else {
    out->AppendElement(8);
  }

  out->AppendElement(LOCAL_EGL_ALPHA_SIZE);
  if (alpha) {
    out->AppendElement(bpp16 ? 4 : 8);
  } else {
    out->AppendElement(0);
  }

  out->AppendElement(LOCAL_EGL_DEPTH_SIZE);
  out->AppendElement(depth ? 16 : 0);

  out->AppendElement(LOCAL_EGL_STENCIL_SIZE);
  out->AppendElement(stencil ? 8 : 0);

  // EGL_ATTRIBS_LIST_SAFE_TERMINATION_WORKING_AROUND_BUGS
  out->AppendElement(LOCAL_EGL_NONE);
  out->AppendElement(0);

  out->AppendElement(0);
  out->AppendElement(0);
}

static GLint GetAttrib(GLLibraryEGL* egl, EGLConfig config, EGLint attrib) {
  EGLint bits = 0;
  egl->fGetConfigAttrib(egl->Display(), config, attrib, &bits);
  MOZ_ASSERT(egl->fGetError() == LOCAL_EGL_SUCCESS);

  return bits;
}

static EGLConfig ChooseConfigOffscreen(GLLibraryEGL* egl,
                                       CreateContextFlags flags,
                                       const SurfaceCaps& minCaps,
                                       bool aUseGles,
                                       SurfaceCaps* const out_configCaps) {
  nsTArray<EGLint> configAttribList;
  FillOffscreenContextAttribs(minCaps.alpha, minCaps.depth, minCaps.stencil,
                              minCaps.bpp16,
                              bool(flags & CreateContextFlags::PREFER_ES3),
                              aUseGles, &configAttribList);

  const EGLint* configAttribs = configAttribList.Elements();

  // We're guaranteed to get at least minCaps, and the sorting dictated by the
  // spec for eglChooseConfig reasonably assures that a reasonable 'best' config
  // is on top.
  const EGLint kMaxConfigs = 1;
  EGLConfig configs[kMaxConfigs];
  EGLint foundConfigs = 0;
  if (!egl->fChooseConfig(egl->Display(), configAttribs, configs, kMaxConfigs,
                          &foundConfigs) ||
      foundConfigs == 0) {
    return EGL_NO_CONFIG;
  }

  EGLConfig config = configs[0];

  *out_configCaps = minCaps;  // Pick up any preserve, etc.
  out_configCaps->color = true;
  out_configCaps->alpha = bool(GetAttrib(egl, config, LOCAL_EGL_ALPHA_SIZE));
  out_configCaps->depth = bool(GetAttrib(egl, config, LOCAL_EGL_DEPTH_SIZE));
  out_configCaps->stencil =
      bool(GetAttrib(egl, config, LOCAL_EGL_STENCIL_SIZE));
  out_configCaps->bpp16 = (GetAttrib(egl, config, LOCAL_EGL_RED_SIZE) < 8);

  return config;
}

/*static*/
already_AddRefed<GLContextEGL>
GLContextEGL::CreateEGLPBufferOffscreenContextImpl(
    CreateContextFlags flags, const mozilla::gfx::IntSize& size,
    const SurfaceCaps& minCaps, bool aUseGles,
    nsACString* const out_failureId) {
  bool forceEnableHardware =
      bool(flags & CreateContextFlags::FORCE_ENABLE_HARDWARE);
  if (!GLLibraryEGL::EnsureInitialized(forceEnableHardware, out_failureId)) {
    return nullptr;
  }

  auto* egl = gl::GLLibraryEGL::Get();
  SurfaceCaps configCaps;
  EGLConfig config =
      ChooseConfigOffscreen(egl, flags, minCaps, aUseGles, &configCaps);
  if (config == EGL_NO_CONFIG) {
    *out_failureId = NS_LITERAL_CSTRING("FEATURE_FAILURE_EGL_NO_CONFIG");
    NS_WARNING("Failed to find a compatible config.");
    return nullptr;
  }

  if (GLContext::ShouldSpew()) {
    egl->DumpEGLConfig(config);
  }

  mozilla::gfx::IntSize pbSize(size);
  EGLSurface surface = nullptr;
#if defined(MOZ_WAYLAND)
  if (IS_WAYLAND_DISPLAY()) {
    surface = GLContextEGL::CreateWaylandBufferSurface(egl, config, pbSize);
  } else
#endif
  {
    surface = GLContextEGL::CreatePBufferSurfaceTryingPowerOfTwo(
        egl, config, LOCAL_EGL_NONE, pbSize);
  }
  if (!surface) {
    *out_failureId = NS_LITERAL_CSTRING("FEATURE_FAILURE_EGL_POT");
    NS_WARNING("Failed to create PBuffer for context!");
    return nullptr;
  }

  RefPtr<GLContextEGL> gl = GLContextEGL::CreateGLContext(
      egl, flags, configCaps, true, config, surface, aUseGles, out_failureId);
  if (!gl) {
    NS_WARNING("Failed to create GLContext from PBuffer");
    egl->fDestroySurface(egl->Display(), surface);
#if defined(MOZ_WAYLAND)
    DeleteWaylandGLSurface(surface);
#endif
    return nullptr;
  }

  return gl.forget();
}

already_AddRefed<GLContextEGL> GLContextEGL::CreateEGLPBufferOffscreenContext(
    CreateContextFlags flags, const mozilla::gfx::IntSize& size,
    const SurfaceCaps& minCaps, nsACString* const out_failureId) {
  RefPtr<GLContextEGL> gl = CreateEGLPBufferOffscreenContextImpl(
      flags, size, minCaps, /* aUseGles */ false, out_failureId);
  if (!gl) {
    gl = CreateEGLPBufferOffscreenContextImpl(
        flags, size, minCaps, /* aUseGles */ true, out_failureId);
  }
  return gl.forget();
}

/*static*/
already_AddRefed<GLContext> GLContextProviderEGL::CreateHeadless(
    CreateContextFlags flags, nsACString* const out_failureId) {
  mozilla::gfx::IntSize dummySize = mozilla::gfx::IntSize(16, 16);
  SurfaceCaps dummyCaps = SurfaceCaps::Any();
  return GLContextEGL::CreateEGLPBufferOffscreenContext(
      flags, dummySize, dummyCaps, out_failureId);
}

// Under EGL, on Android, pbuffers are supported fine, though
// often without the ability to texture from them directly.
/*static*/
already_AddRefed<GLContext> GLContextProviderEGL::CreateOffscreen(
    const mozilla::gfx::IntSize& size, const SurfaceCaps& minCaps,
    CreateContextFlags flags, nsACString* const out_failureId) {
  bool forceEnableHardware =
      bool(flags & CreateContextFlags::FORCE_ENABLE_HARDWARE);
  if (!GLLibraryEGL::EnsureInitialized(
          forceEnableHardware, out_failureId)) {  // Needed for IsANGLE().
    return nullptr;
  }

  auto* egl = gl::GLLibraryEGL::Get();
  bool canOffscreenUseHeadless = true;
  if (egl->IsANGLE()) {
    // ANGLE needs to use PBuffers.
    canOffscreenUseHeadless = false;
  }

#if defined(MOZ_WIDGET_ANDROID)
  // Using a headless context loses the SurfaceCaps
  // which can cause a loss of depth and/or stencil
  canOffscreenUseHeadless = false;
#endif  //  defined(MOZ_WIDGET_ANDROID)

  RefPtr<GLContext> gl;
  SurfaceCaps minOffscreenCaps = minCaps;

  if (canOffscreenUseHeadless) {
    gl = CreateHeadless(flags, out_failureId);
    if (!gl) {
      return nullptr;
    }
  } else {
    gl = GLContextEGL::CreateEGLPBufferOffscreenContext(
        flags, size, minOffscreenCaps, out_failureId);
    if (!gl) return nullptr;

    // Pull the actual resulting caps to ensure that our offscreen matches our
    // backbuffer.
    minOffscreenCaps.alpha = gl->Caps().alpha;
    minOffscreenCaps.depth = gl->Caps().depth;
    minOffscreenCaps.stencil = gl->Caps().stencil;
  }

  // Init the offscreen with the updated offscreen caps.
  if (!gl->InitOffscreen(size, minOffscreenCaps)) {
    *out_failureId = NS_LITERAL_CSTRING("FEATURE_FAILURE_EGL_OFFSCREEN");
    return nullptr;
  }

  return gl.forget();
}

// Don't want a global context on Android as 1) share groups across 2 threads
// fail on many Tegra drivers (bug 759225) and 2) some mobile devices have a
// very strict limit on global number of GL contexts (bug 754257) and 3) each
// EGL context eats 750k on B2G (bug 813783)
/*static*/
GLContext* GLContextProviderEGL::GetGlobalContext() { return nullptr; }

/*static*/
void GLContextProviderEGL::Shutdown() {
  const RefPtr<GLLibraryEGL> egl = GLLibraryEGL::Get();
  if (egl) {
    egl->Shutdown();
  }
}

} /* namespace gl */
} /* namespace mozilla */

#undef EGL_ATTRIBS_LIST_SAFE_TERMINATION_WORKING_AROUND_BUGS
