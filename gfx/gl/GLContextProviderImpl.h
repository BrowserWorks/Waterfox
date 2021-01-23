/* -*- Mode: C++; tab-width: 20; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef IN_GL_CONTEXT_PROVIDER_H
#  error GLContextProviderImpl.h must only be included from GLContextProvider.h
#endif

#ifndef GL_CONTEXT_PROVIDER_NAME
#  error GL_CONTEXT_PROVIDER_NAME not defined
#endif
#if defined(MOZ_WIDGET_ANDROID)
#  include "GLTypes.h"  // for EGLSurface and EGLConfig
#endif                  // defined(MOZ_WIDGET_ANDROID)

class GL_CONTEXT_PROVIDER_NAME {
 public:
  /**
   * Create a context that renders to the surface of the widget represented by
   * the compositor widget that is passed in. The context is always created
   * with an RGB pixel format, with no alpha, depth or stencil.
   * If any of those features are needed, either use a framebuffer, or
   * use CreateOffscreen.
   *
   * This context will attempt to share resources with all other window
   * contexts.  As such, it's critical that resources allocated that are not
   * needed by other contexts be deleted before the context is destroyed.
   *
   * The GetSharedContext() method will return non-null if sharing
   * was successful.
   *
   * Note: a context created for a widget /must not/ hold a strong
   * reference to the widget; otherwise a cycle can be created through
   * a GL layer manager.
   *
   * @param aCompositorWidget Widget whose surface to create a context for
   * @param aForceAccelerated true if only accelerated contexts are allowed
   *
   * @return Context to use for the window
   */
  static already_AddRefed<GLContext> CreateForCompositorWidget(
      mozilla::widget::CompositorWidget* aCompositorWidget, bool aWebRender,
      bool aForceAccelerated);

  /**
   * Create a context for offscreen rendering.  The target of this
   * context should be treated as opaque -- it might be a FBO, or a
   * pbuffer, or some other construct.  Users of this GLContext
   * should bind framebuffer 0 directly to use this offscreen buffer.
   *
   * The offscreen context returned by this method will always have
   * the ability to be rendered into a context created by a window.
   * It might or might not share resources with the global context;
   * query GetSharedContext() for a non-null result to check.  If
   * resource sharing can be avoided on the target platform, it will
   * be, in order to isolate the offscreen context.
   *
   * @param size    The initial size of this offscreen context.
   * @param minCaps The required SurfaceCaps for this offscreen context. The
   * resulting context *may* have more/better caps than requested, but it cannot
   *                have fewer/worse caps than requested.
   * @param flags   The set of CreateContextFlags to be used for this
   *                offscreen context.
   *
   * @return Context to use for offscreen rendering
   */
  static already_AddRefed<GLContext> CreateOffscreen(
      const mozilla::gfx::IntSize& size, const SurfaceCaps& minCaps,
      CreateContextFlags flags, nsACString* const out_failureId);

  // Just create a context. We'll add offscreen stuff ourselves.
  static already_AddRefed<GLContext> CreateHeadless(
      CreateContextFlags flags, nsACString* const out_failureId);

  /**
   * Create wrapping Gecko GLContext for external gl context.
   *
   * @param aContext External context which will be wrapped by Gecko GLContext.
   * @param aSurface External surface which is used for external context.
   *
   * @return Wrapping Context to use for rendering
   */
  static already_AddRefed<GLContext> CreateWrappingExisting(void* aContext,
                                                            void* aSurface);

#if defined(MOZ_WIDGET_ANDROID)
  static EGLSurface CreateEGLSurface(void* aWindow,
                                     EGLConfig aConfig = nullptr);
  static void DestroyEGLSurface(EGLSurface surface);
#endif  // defined(MOZ_WIDGET_ANDROID)

  /**
   * Get a pointer to the global context, creating it if it doesn't exist.
   */
  static GLContext* GetGlobalContext();

  /**
   * Free any resources held by this Context Provider.
   */
  static void Shutdown();
};
