//
// Copyright (c) 2016 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//

// validationEGL.cpp: Validation functions for generic EGL entry point parameters

#include "libANGLE/validationEGL.h"

#include "common/utilities.h"
#include "libANGLE/Config.h"
#include "libANGLE/Context.h"
#include "libANGLE/Device.h"
#include "libANGLE/Display.h"
#include "libANGLE/Image.h"
#include "libANGLE/Stream.h"
#include "libANGLE/Surface.h"
#include "libANGLE/Texture.h"
#include "libANGLE/formatutils.h"

#include <EGL/eglext.h>

namespace
{
size_t GetMaximumMipLevel(const gl::Context *context, GLenum target)
{
    const gl::Caps &caps = context->getCaps();

    size_t maxDimension = 0;
    switch (target)
    {
        case GL_TEXTURE_2D:
            maxDimension = caps.max2DTextureSize;
            break;
        case GL_TEXTURE_CUBE_MAP:
            maxDimension = caps.maxCubeMapTextureSize;
            break;
        case GL_TEXTURE_3D:
            maxDimension = caps.max3DTextureSize;
            break;
        case GL_TEXTURE_2D_ARRAY:
            maxDimension = caps.max2DTextureSize;
            break;
        default:
            UNREACHABLE();
    }

    return gl::log2(static_cast<int>(maxDimension));
}

bool TextureHasNonZeroMipLevelsSpecified(const gl::Context *context, const gl::Texture *texture)
{
    size_t maxMip = GetMaximumMipLevel(context, texture->getTarget());
    for (size_t level = 1; level < maxMip; level++)
    {
        if (texture->getTarget() == GL_TEXTURE_CUBE_MAP)
        {
            for (GLenum face = gl::FirstCubeMapTextureTarget; face <= gl::LastCubeMapTextureTarget;
                 face++)
            {
                if (texture->getFormat(face, level).valid())
                {
                    return true;
                }
            }
        }
        else
        {
            if (texture->getFormat(texture->getTarget(), level).valid())
            {
                return true;
            }
        }
    }

    return false;
}

bool CubeTextureHasUnspecifiedLevel0Face(const gl::Texture *texture)
{
    ASSERT(texture->getTarget() == GL_TEXTURE_CUBE_MAP);
    for (GLenum face = gl::FirstCubeMapTextureTarget; face <= gl::LastCubeMapTextureTarget; face++)
    {
        if (!texture->getFormat(face, 0).valid())
        {
            return true;
        }
    }

    return false;
}

egl::Error ValidateStreamAttribute(const EGLAttrib attribute,
                                   const EGLAttrib value,
                                   const egl::DisplayExtensions &extensions)
{
    switch (attribute)
    {
        case EGL_STREAM_STATE_KHR:
        case EGL_PRODUCER_FRAME_KHR:
        case EGL_CONSUMER_FRAME_KHR:
            return egl::Error(EGL_BAD_ACCESS, "Attempt to initialize readonly parameter");
        case EGL_CONSUMER_LATENCY_USEC_KHR:
            // Technically not in spec but a latency < 0 makes no sense so we check it
            if (value < 0)
            {
                return egl::Error(EGL_BAD_PARAMETER, "Latency must be positive");
            }
            break;
        case EGL_CONSUMER_ACQUIRE_TIMEOUT_USEC_KHR:
            if (!extensions.streamConsumerGLTexture)
            {
                return egl::Error(EGL_BAD_ATTRIBUTE, "Consumer GL extension not enabled");
            }
            // Again not in spec but it should be positive anyways
            if (value < 0)
            {
                return egl::Error(EGL_BAD_PARAMETER, "Timeout must be positive");
            }
            break;
        default:
            return egl::Error(EGL_BAD_ATTRIBUTE, "Invalid stream attribute");
    }
    return egl::Error(EGL_SUCCESS);
}

egl::Error ValidateCreateImageKHRMipLevelCommon(gl::Context *context,
                                                const gl::Texture *texture,
                                                EGLAttrib level)
{
    // Note that the spec EGL_KHR_create_image spec does not explicitly specify an error
    // when the level is outside the base/max level range, but it does mention that the
    // level "must be a part of the complete texture object <buffer>". It can be argued
    // that out-of-range levels are not a part of the complete texture.
    const GLuint effectiveBaseLevel = texture->getTextureState().getEffectiveBaseLevel();
    if (level > 0 &&
        (!texture->isMipmapComplete() || static_cast<GLuint>(level) < effectiveBaseLevel ||
         static_cast<GLuint>(level) > texture->getTextureState().getMipmapMaxLevel()))
    {
        return egl::Error(EGL_BAD_PARAMETER, "texture must be complete if level is non-zero.");
    }

    if (level == 0 && !texture->isMipmapComplete() &&
        TextureHasNonZeroMipLevelsSpecified(context, texture))
    {
        return egl::Error(EGL_BAD_PARAMETER,
                          "if level is zero and the texture is incomplete, it must have no mip "
                          "levels specified except zero.");
    }

    return egl::Error(EGL_SUCCESS);
}

}  // namespace

namespace egl
{

Error ValidateDisplay(const Display *display)
{
    if (display == EGL_NO_DISPLAY)
    {
        return Error(EGL_BAD_DISPLAY, "display is EGL_NO_DISPLAY.");
    }

    if (!Display::isValidDisplay(display))
    {
        return Error(EGL_BAD_DISPLAY, "display is not a valid display.");
    }

    if (!display->isInitialized())
    {
        return Error(EGL_NOT_INITIALIZED, "display is not initialized.");
    }

    if (display->isDeviceLost())
    {
        return Error(EGL_CONTEXT_LOST, "display had a context loss");
    }

    return Error(EGL_SUCCESS);
}

Error ValidateSurface(const Display *display, const Surface *surface)
{
    ANGLE_TRY(ValidateDisplay(display));

    if (!display->isValidSurface(surface))
    {
        return Error(EGL_BAD_SURFACE);
    }

    return Error(EGL_SUCCESS);
}

Error ValidateConfig(const Display *display, const Config *config)
{
    ANGLE_TRY(ValidateDisplay(display));

    if (!display->isValidConfig(config))
    {
        return Error(EGL_BAD_CONFIG);
    }

    return Error(EGL_SUCCESS);
}

Error ValidateContext(const Display *display, const gl::Context *context)
{
    ANGLE_TRY(ValidateDisplay(display));

    if (!display->isValidContext(context))
    {
        return Error(EGL_BAD_CONTEXT);
    }

    return Error(EGL_SUCCESS);
}

Error ValidateImage(const Display *display, const Image *image)
{
    ANGLE_TRY(ValidateDisplay(display));

    if (!display->isValidImage(image))
    {
        return Error(EGL_BAD_PARAMETER, "image is not valid.");
    }

    return Error(EGL_SUCCESS);
}

Error ValidateStream(const Display *display, const Stream *stream)
{
    ANGLE_TRY(ValidateDisplay(display));

    const DisplayExtensions &displayExtensions = display->getExtensions();
    if (!displayExtensions.stream)
    {
        return Error(EGL_BAD_ACCESS, "Stream extension not active");
    }

    if (stream == EGL_NO_STREAM_KHR || !display->isValidStream(stream))
    {
        return Error(EGL_BAD_STREAM_KHR, "Invalid stream");
    }

    return Error(EGL_SUCCESS);
}

Error ValidateCreateContext(Display *display, Config *configuration, gl::Context *shareContext,
                            const AttributeMap& attributes)
{
    ANGLE_TRY(ValidateConfig(display, configuration));

    // Get the requested client version (default is 1) and check it is 2 or 3.
    EGLAttrib clientMajorVersion = 1;
    EGLAttrib clientMinorVersion = 0;
    EGLAttrib contextFlags       = 0;
    bool resetNotification = false;
    for (AttributeMap::const_iterator attributeIter = attributes.begin(); attributeIter != attributes.end(); attributeIter++)
    {
        EGLAttrib attribute = attributeIter->first;
        EGLAttrib value     = attributeIter->second;

        switch (attribute)
        {
          case EGL_CONTEXT_CLIENT_VERSION:
            clientMajorVersion = value;
            break;

          case EGL_CONTEXT_MINOR_VERSION:
            clientMinorVersion = value;
            break;

          case EGL_CONTEXT_FLAGS_KHR:
            contextFlags = value;
            break;

          case EGL_CONTEXT_OPENGL_DEBUG:
              break;

          case EGL_CONTEXT_OPENGL_PROFILE_MASK_KHR:
            // Only valid for OpenGL (non-ES) contexts
            return Error(EGL_BAD_ATTRIBUTE);

          case EGL_CONTEXT_OPENGL_ROBUST_ACCESS_EXT:
            if (!display->getExtensions().createContextRobustness)
            {
                return Error(EGL_BAD_ATTRIBUTE);
            }
            if (value != EGL_TRUE && value != EGL_FALSE)
            {
                return Error(EGL_BAD_ATTRIBUTE);
            }
            break;

          case EGL_CONTEXT_OPENGL_RESET_NOTIFICATION_STRATEGY_KHR:
            static_assert(EGL_LOSE_CONTEXT_ON_RESET_EXT == EGL_LOSE_CONTEXT_ON_RESET_KHR, "EGL extension enums not equal.");
            static_assert(EGL_NO_RESET_NOTIFICATION_EXT == EGL_NO_RESET_NOTIFICATION_KHR, "EGL extension enums not equal.");
            // same as EGL_CONTEXT_OPENGL_RESET_NOTIFICATION_STRATEGY_EXT, fall through
          case EGL_CONTEXT_OPENGL_RESET_NOTIFICATION_STRATEGY_EXT:
            if (!display->getExtensions().createContextRobustness)
            {
                return Error(EGL_BAD_ATTRIBUTE);
            }
            if (value == EGL_LOSE_CONTEXT_ON_RESET_EXT)
            {
                resetNotification = true;
            }
            else if (value != EGL_NO_RESET_NOTIFICATION_EXT)
            {
                return Error(EGL_BAD_ATTRIBUTE);
            }
            break;

          case EGL_CONTEXT_OPENGL_NO_ERROR_KHR:
              if (!display->getExtensions().createContextNoError)
              {
                  return Error(EGL_BAD_ATTRIBUTE, "Invalid Context attribute.");
              }
              if (value != EGL_TRUE && value != EGL_FALSE)
              {
                  return Error(EGL_BAD_ATTRIBUTE, "Attribute must be EGL_TRUE or EGL_FALSE.");
              }
              break;

          case EGL_CONTEXT_WEBGL_COMPATIBILITY_ANGLE:
              if (!display->getExtensions().createContextWebGLCompatibility)
              {
                  return Error(EGL_BAD_ATTRIBUTE,
                               "Attribute EGL_CONTEXT_WEBGL_COMPATIBILITY_ANGLE requires "
                               "EGL_ANGLE_create_context_webgl_compatibility.");
              }
              if (value != EGL_TRUE && value != EGL_FALSE)
              {
                  return Error(
                      EGL_BAD_ATTRIBUTE,
                      "EGL_CONTEXT_WEBGL_COMPATIBILITY_ANGLE must be EGL_TRUE or EGL_FALSE.");
              }
              break;

          case EGL_CONTEXT_BIND_GENERATES_RESOURCE_CHROMIUM:
              if (!display->getExtensions().createContextBindGeneratesResource)
              {
                  return Error(EGL_BAD_ATTRIBUTE,
                               "Attribute EGL_CONTEXT_BIND_GENERATES_RESOURCE_CHROMIUM requires "
                               "EGL_CHROMIUM_create_context_bind_generates_resource.");
              }
              if (value != EGL_TRUE && value != EGL_FALSE)
              {
                  return Error(EGL_BAD_ATTRIBUTE,
                               "EGL_CONTEXT_BIND_GENERATES_RESOURCE_CHROMIUM must be EGL_TRUE or "
                               "EGL_FALSE.");
              }
              break;

          default:
            return Error(EGL_BAD_ATTRIBUTE);
        }
    }

    switch (clientMajorVersion)
    {
        case 2:
            if (clientMinorVersion != 0)
            {
                return Error(EGL_BAD_CONFIG);
            }
            break;
        case 3:
            if (clientMinorVersion != 0 && clientMinorVersion != 1)
            {
                return Error(EGL_BAD_CONFIG);
            }
            if (!(configuration->conformant & EGL_OPENGL_ES3_BIT_KHR))
            {
                return Error(EGL_BAD_CONFIG);
            }
            if (display->getMaxSupportedESVersion() <
                gl::Version(static_cast<GLuint>(clientMajorVersion),
                            static_cast<GLuint>(clientMinorVersion)))
            {
                return Error(EGL_BAD_CONFIG, "Requested GLES version is not supported.");
            }
            break;
        default:
            return Error(EGL_BAD_CONFIG);
            break;
    }

    // Note: EGL_CONTEXT_OPENGL_FORWARD_COMPATIBLE_BIT_KHR does not apply to ES
    const EGLint validContextFlags = (EGL_CONTEXT_OPENGL_DEBUG_BIT_KHR |
                                      EGL_CONTEXT_OPENGL_ROBUST_ACCESS_BIT_KHR);
    if ((contextFlags & ~validContextFlags) != 0)
    {
        return Error(EGL_BAD_ATTRIBUTE);
    }

    if (shareContext)
    {
        // Shared context is invalid or is owned by another display
        if (!display->isValidContext(shareContext))
        {
            return Error(EGL_BAD_MATCH);
        }

        if (shareContext->isResetNotificationEnabled() != resetNotification)
        {
            return Error(EGL_BAD_MATCH);
        }

        if (shareContext->getClientMajorVersion() != clientMajorVersion ||
            shareContext->getClientMinorVersion() != clientMinorVersion)
        {
            return Error(EGL_BAD_CONTEXT);
        }
    }

    return Error(EGL_SUCCESS);
}

Error ValidateCreateWindowSurface(Display *display, Config *config, EGLNativeWindowType window,
                                  const AttributeMap& attributes)
{
    ANGLE_TRY(ValidateConfig(display, config));

    if (!display->isValidNativeWindow(window))
    {
        return Error(EGL_BAD_NATIVE_WINDOW);
    }

    const DisplayExtensions &displayExtensions = display->getExtensions();

    for (AttributeMap::const_iterator attributeIter = attributes.begin(); attributeIter != attributes.end(); attributeIter++)
    {
        EGLAttrib attribute = attributeIter->first;
        EGLAttrib value     = attributeIter->second;

        switch (attribute)
        {
          case EGL_RENDER_BUFFER:
            switch (value)
            {
              case EGL_BACK_BUFFER:
                break;
              case EGL_SINGLE_BUFFER:
                return Error(EGL_BAD_MATCH);   // Rendering directly to front buffer not supported
              default:
                return Error(EGL_BAD_ATTRIBUTE);
            }
            break;

          case EGL_POST_SUB_BUFFER_SUPPORTED_NV:
            if (!displayExtensions.postSubBuffer)
            {
                return Error(EGL_BAD_ATTRIBUTE);
            }
            break;

          case EGL_FLEXIBLE_SURFACE_COMPATIBILITY_SUPPORTED_ANGLE:
              if (!displayExtensions.flexibleSurfaceCompatibility)
              {
                  return Error(EGL_BAD_ATTRIBUTE);
              }
              break;

          case EGL_WIDTH:
          case EGL_HEIGHT:
            if (!displayExtensions.windowFixedSize)
            {
                return Error(EGL_BAD_ATTRIBUTE);
            }
            if (value < 0)
            {
                return Error(EGL_BAD_PARAMETER);
            }
            break;

          case EGL_FIXED_SIZE_ANGLE:
            if (!displayExtensions.windowFixedSize)
            {
                return Error(EGL_BAD_ATTRIBUTE);
            }
            break;

          case EGL_SURFACE_ORIENTATION_ANGLE:
              if (!displayExtensions.surfaceOrientation)
              {
                  return Error(EGL_BAD_ATTRIBUTE, "EGL_ANGLE_surface_orientation is not enabled.");
              }
              break;

          case EGL_VG_COLORSPACE:
            return Error(EGL_BAD_MATCH);

          case EGL_VG_ALPHA_FORMAT:
            return Error(EGL_BAD_MATCH);

          case EGL_DIRECT_COMPOSITION_ANGLE:
              if (!displayExtensions.directComposition)
              {
                  return Error(EGL_BAD_ATTRIBUTE);
              }
              break;

          default:
            return Error(EGL_BAD_ATTRIBUTE);
        }
    }

    if (Display::hasExistingWindowSurface(window))
    {
        return Error(EGL_BAD_ALLOC);
    }

    return Error(EGL_SUCCESS);
}

Error ValidateCreatePbufferSurface(Display *display, Config *config, const AttributeMap& attributes)
{
    ANGLE_TRY(ValidateConfig(display, config));

    const DisplayExtensions &displayExtensions = display->getExtensions();

    for (AttributeMap::const_iterator attributeIter = attributes.begin(); attributeIter != attributes.end(); attributeIter++)
    {
        EGLAttrib attribute = attributeIter->first;
        EGLAttrib value     = attributeIter->second;

        switch (attribute)
        {
          case EGL_WIDTH:
          case EGL_HEIGHT:
            if (value < 0)
            {
                return Error(EGL_BAD_PARAMETER);
            }
            break;

          case EGL_LARGEST_PBUFFER:
            break;

          case EGL_TEXTURE_FORMAT:
            switch (value)
            {
              case EGL_NO_TEXTURE:
              case EGL_TEXTURE_RGB:
              case EGL_TEXTURE_RGBA:
                break;
              default:
                return Error(EGL_BAD_ATTRIBUTE);
            }
            break;

          case EGL_TEXTURE_TARGET:
            switch (value)
            {
              case EGL_NO_TEXTURE:
              case EGL_TEXTURE_2D:
                break;
              default:
                return Error(EGL_BAD_ATTRIBUTE);
            }
            break;

          case EGL_MIPMAP_TEXTURE:
            break;

          case EGL_VG_COLORSPACE:
            break;

          case EGL_VG_ALPHA_FORMAT:
            break;

          case EGL_FLEXIBLE_SURFACE_COMPATIBILITY_SUPPORTED_ANGLE:
              if (!displayExtensions.flexibleSurfaceCompatibility)
              {
                  return Error(
                      EGL_BAD_ATTRIBUTE,
                      "EGL_FLEXIBLE_SURFACE_COMPATIBILITY_SUPPORTED_ANGLE cannot be used without "
                      "EGL_ANGLE_flexible_surface_compatibility support.");
              }
              break;

          default:
            return Error(EGL_BAD_ATTRIBUTE);
        }
    }

    if (!(config->surfaceType & EGL_PBUFFER_BIT))
    {
        return Error(EGL_BAD_MATCH);
    }

    const Caps &caps = display->getCaps();

    EGLAttrib textureFormat = attributes.get(EGL_TEXTURE_FORMAT, EGL_NO_TEXTURE);
    EGLAttrib textureTarget = attributes.get(EGL_TEXTURE_TARGET, EGL_NO_TEXTURE);

    if ((textureFormat != EGL_NO_TEXTURE && textureTarget == EGL_NO_TEXTURE) ||
        (textureFormat == EGL_NO_TEXTURE && textureTarget != EGL_NO_TEXTURE))
    {
        return Error(EGL_BAD_MATCH);
    }

    if ((textureFormat == EGL_TEXTURE_RGB  && config->bindToTextureRGB != EGL_TRUE) ||
        (textureFormat == EGL_TEXTURE_RGBA && config->bindToTextureRGBA != EGL_TRUE))
    {
        return Error(EGL_BAD_ATTRIBUTE);
    }

    EGLint width  = static_cast<EGLint>(attributes.get(EGL_WIDTH, 0));
    EGLint height = static_cast<EGLint>(attributes.get(EGL_HEIGHT, 0));
    if (textureFormat != EGL_NO_TEXTURE && !caps.textureNPOT && (!gl::isPow2(width) || !gl::isPow2(height)))
    {
        return Error(EGL_BAD_MATCH);
    }

    return Error(EGL_SUCCESS);
}

Error ValidateCreatePbufferFromClientBuffer(Display *display, EGLenum buftype, EGLClientBuffer buffer,
                                            Config *config, const AttributeMap& attributes)
{
    ANGLE_TRY(ValidateConfig(display, config));

    const DisplayExtensions &displayExtensions = display->getExtensions();

    switch (buftype)
    {
      case EGL_D3D_TEXTURE_2D_SHARE_HANDLE_ANGLE:
        if (!displayExtensions.d3dShareHandleClientBuffer)
        {
            return Error(EGL_BAD_PARAMETER);
        }
        if (buffer == nullptr)
        {
            return Error(EGL_BAD_PARAMETER);
        }
        break;

      case EGL_D3D_TEXTURE_ANGLE:
          if (!displayExtensions.d3dTextureClientBuffer)
          {
              return Error(EGL_BAD_PARAMETER);
          }
          if (buffer == nullptr)
          {
              return Error(EGL_BAD_PARAMETER);
          }
          break;

      default:
        return Error(EGL_BAD_PARAMETER);
    }

    for (AttributeMap::const_iterator attributeIter = attributes.begin(); attributeIter != attributes.end(); attributeIter++)
    {
        EGLAttrib attribute = attributeIter->first;
        EGLAttrib value     = attributeIter->second;

        switch (attribute)
        {
          case EGL_WIDTH:
          case EGL_HEIGHT:
            if (!displayExtensions.d3dShareHandleClientBuffer)
            {
                return Error(EGL_BAD_PARAMETER);
            }
            if (value < 0)
            {
                return Error(EGL_BAD_PARAMETER);
            }
            break;

          case EGL_TEXTURE_FORMAT:
            switch (value)
            {
              case EGL_NO_TEXTURE:
              case EGL_TEXTURE_RGB:
              case EGL_TEXTURE_RGBA:
                break;
              default:
                return Error(EGL_BAD_ATTRIBUTE);
            }
            break;

          case EGL_TEXTURE_TARGET:
            switch (value)
            {
              case EGL_NO_TEXTURE:
              case EGL_TEXTURE_2D:
                break;
              default:
                return Error(EGL_BAD_ATTRIBUTE);
            }
            break;

          case EGL_MIPMAP_TEXTURE:
            break;

          case EGL_FLEXIBLE_SURFACE_COMPATIBILITY_SUPPORTED_ANGLE:
              if (!displayExtensions.flexibleSurfaceCompatibility)
              {
                  return Error(
                      EGL_BAD_ATTRIBUTE,
                      "EGL_FLEXIBLE_SURFACE_COMPATIBILITY_SUPPORTED_ANGLE cannot be used without "
                      "EGL_ANGLE_flexible_surface_compatibility support.");
              }
              break;

          default:
            return Error(EGL_BAD_ATTRIBUTE);
        }
    }

    if (!(config->surfaceType & EGL_PBUFFER_BIT))
    {
        return Error(EGL_BAD_MATCH);
    }

    EGLAttrib textureFormat = attributes.get(EGL_TEXTURE_FORMAT, EGL_NO_TEXTURE);
    EGLAttrib textureTarget = attributes.get(EGL_TEXTURE_TARGET, EGL_NO_TEXTURE);
    if ((textureFormat != EGL_NO_TEXTURE && textureTarget == EGL_NO_TEXTURE) ||
        (textureFormat == EGL_NO_TEXTURE && textureTarget != EGL_NO_TEXTURE))
    {
        return Error(EGL_BAD_MATCH);
    }

    if ((textureFormat == EGL_TEXTURE_RGB  && config->bindToTextureRGB  != EGL_TRUE) ||
        (textureFormat == EGL_TEXTURE_RGBA && config->bindToTextureRGBA != EGL_TRUE))
    {
        return Error(EGL_BAD_ATTRIBUTE);
    }

    if (buftype == EGL_D3D_TEXTURE_2D_SHARE_HANDLE_ANGLE)
    {
        EGLint width  = static_cast<EGLint>(attributes.get(EGL_WIDTH, 0));
        EGLint height = static_cast<EGLint>(attributes.get(EGL_HEIGHT, 0));

        if (width == 0 || height == 0)
        {
            return Error(EGL_BAD_ATTRIBUTE);
        }

        const Caps &caps = display->getCaps();
        if (textureFormat != EGL_NO_TEXTURE && !caps.textureNPOT && (!gl::isPow2(width) || !gl::isPow2(height)))
        {
            return Error(EGL_BAD_MATCH);
        }
    }

    ANGLE_TRY(display->validateClientBuffer(config, buftype, buffer, attributes));

    return Error(EGL_SUCCESS);
}

Error ValidateCompatibleConfigs(const Display *display,
                                const Config *config1,
                                const Surface *surface,
                                const Config *config2,
                                EGLint surfaceType)
{

    if (!surface->flexibleSurfaceCompatibilityRequested())
    {
        // Config compatibility is defined in section 2.2 of the EGL 1.5 spec

        bool colorBufferCompat = config1->colorBufferType == config2->colorBufferType;
        if (!colorBufferCompat)
        {
            return Error(EGL_BAD_MATCH, "Color buffer types are not compatible.");
        }

        bool colorCompat =
            config1->redSize == config2->redSize && config1->greenSize == config2->greenSize &&
            config1->blueSize == config2->blueSize && config1->alphaSize == config2->alphaSize &&
            config1->luminanceSize == config2->luminanceSize;
        if (!colorCompat)
        {
            return Error(EGL_BAD_MATCH, "Color buffer sizes are not compatible.");
        }

        bool dsCompat = config1->depthSize == config2->depthSize &&
                        config1->stencilSize == config2->stencilSize;
        if (!dsCompat)
        {
            return Error(EGL_BAD_MATCH, "Depth-stencil buffer types are not compatible.");
        }
    }

    bool surfaceTypeCompat = (config1->surfaceType & config2->surfaceType & surfaceType) != 0;
    if (!surfaceTypeCompat)
    {
        return Error(EGL_BAD_MATCH, "Surface types are not compatible.");
    }

    return Error(EGL_SUCCESS);
}

Error ValidateCreateImageKHR(const Display *display,
                             gl::Context *context,
                             EGLenum target,
                             EGLClientBuffer buffer,
                             const AttributeMap &attributes)
{
    ANGLE_TRY(ValidateContext(display, context));

    const DisplayExtensions &displayExtensions = display->getExtensions();

    if (!displayExtensions.imageBase && !displayExtensions.image)
    {
        // It is out of spec what happens when calling an extension function when the extension is
        // not available.
        // EGL_BAD_DISPLAY seems like a reasonable error.
        return Error(EGL_BAD_DISPLAY, "EGL_KHR_image not supported.");
    }

    // TODO(geofflang): Complete validation from EGL_KHR_image_base:
    // If the resource specified by <dpy>, <ctx>, <target>, <buffer> and <attrib_list> is itself an
    // EGLImage sibling, the error EGL_BAD_ACCESS is generated.

    for (AttributeMap::const_iterator attributeIter = attributes.begin();
         attributeIter != attributes.end(); attributeIter++)
    {
        EGLAttrib attribute = attributeIter->first;
        EGLAttrib value     = attributeIter->second;

        switch (attribute)
        {
            case EGL_IMAGE_PRESERVED_KHR:
                switch (value)
                {
                    case EGL_TRUE:
                    case EGL_FALSE:
                        break;

                    default:
                        return Error(EGL_BAD_PARAMETER,
                                     "EGL_IMAGE_PRESERVED_KHR must be EGL_TRUE or EGL_FALSE.");
                }
                break;

            case EGL_GL_TEXTURE_LEVEL_KHR:
                if (!displayExtensions.glTexture2DImage &&
                    !displayExtensions.glTextureCubemapImage && !displayExtensions.glTexture3DImage)
                {
                    return Error(EGL_BAD_PARAMETER,
                                 "EGL_GL_TEXTURE_LEVEL_KHR cannot be used without "
                                 "KHR_gl_texture_*_image support.");
                }

                if (value < 0)
                {
                    return Error(EGL_BAD_PARAMETER, "EGL_GL_TEXTURE_LEVEL_KHR cannot be negative.");
                }
                break;

            case EGL_GL_TEXTURE_ZOFFSET_KHR:
                if (!displayExtensions.glTexture3DImage)
                {
                    return Error(EGL_BAD_PARAMETER,
                                 "EGL_GL_TEXTURE_ZOFFSET_KHR cannot be used without "
                                 "KHR_gl_texture_3D_image support.");
                }
                break;

            default:
                return Error(EGL_BAD_PARAMETER, "invalid attribute: 0x%X", attribute);
        }
    }

    switch (target)
    {
        case EGL_GL_TEXTURE_2D_KHR:
        {
            if (!displayExtensions.glTexture2DImage)
            {
                return Error(EGL_BAD_PARAMETER, "KHR_gl_texture_2D_image not supported.");
            }

            if (buffer == 0)
            {
                return Error(EGL_BAD_PARAMETER,
                             "buffer cannot reference a 2D texture with the name 0.");
            }

            const gl::Texture *texture =
                context->getTexture(egl_gl::EGLClientBufferToGLObjectHandle(buffer));
            if (texture == nullptr || texture->getTarget() != GL_TEXTURE_2D)
            {
                return Error(EGL_BAD_PARAMETER, "target is not a 2D texture.");
            }

            if (texture->getBoundSurface() != nullptr)
            {
                return Error(EGL_BAD_ACCESS, "texture has a surface bound to it.");
            }

            EGLAttrib level = attributes.get(EGL_GL_TEXTURE_LEVEL_KHR, 0);
            if (texture->getWidth(GL_TEXTURE_2D, static_cast<size_t>(level)) == 0 ||
                texture->getHeight(GL_TEXTURE_2D, static_cast<size_t>(level)) == 0)
            {
                return Error(EGL_BAD_PARAMETER,
                             "target 2D texture does not have a valid size at specified level.");
            }

            ANGLE_TRY(ValidateCreateImageKHRMipLevelCommon(context, texture, level));
        }
        break;

        case EGL_GL_TEXTURE_CUBE_MAP_POSITIVE_X_KHR:
        case EGL_GL_TEXTURE_CUBE_MAP_NEGATIVE_X_KHR:
        case EGL_GL_TEXTURE_CUBE_MAP_POSITIVE_Y_KHR:
        case EGL_GL_TEXTURE_CUBE_MAP_NEGATIVE_Y_KHR:
        case EGL_GL_TEXTURE_CUBE_MAP_POSITIVE_Z_KHR:
        case EGL_GL_TEXTURE_CUBE_MAP_NEGATIVE_Z_KHR:
        {
            if (!displayExtensions.glTextureCubemapImage)
            {
                return Error(EGL_BAD_PARAMETER, "KHR_gl_texture_cubemap_image not supported.");
            }

            if (buffer == 0)
            {
                return Error(EGL_BAD_PARAMETER,
                             "buffer cannot reference a cubemap texture with the name 0.");
            }

            const gl::Texture *texture =
                context->getTexture(egl_gl::EGLClientBufferToGLObjectHandle(buffer));
            if (texture == nullptr || texture->getTarget() != GL_TEXTURE_CUBE_MAP)
            {
                return Error(EGL_BAD_PARAMETER, "target is not a cubemap texture.");
            }

            if (texture->getBoundSurface() != nullptr)
            {
                return Error(EGL_BAD_ACCESS, "texture has a surface bound to it.");
            }

            EGLAttrib level    = attributes.get(EGL_GL_TEXTURE_LEVEL_KHR, 0);
            GLenum cubeMapFace = egl_gl::EGLCubeMapTargetToGLCubeMapTarget(target);
            if (texture->getWidth(cubeMapFace, static_cast<size_t>(level)) == 0 ||
                texture->getHeight(cubeMapFace, static_cast<size_t>(level)) == 0)
            {
                return Error(EGL_BAD_PARAMETER,
                             "target cubemap texture does not have a valid size at specified level "
                             "and face.");
            }

            ANGLE_TRY(ValidateCreateImageKHRMipLevelCommon(context, texture, level));

            if (level == 0 && !texture->isMipmapComplete() &&
                CubeTextureHasUnspecifiedLevel0Face(texture))
            {
                return Error(EGL_BAD_PARAMETER,
                             "if level is zero and the texture is incomplete, it must have all of "
                             "its faces specified at level zero.");
            }
        }
        break;

        case EGL_GL_TEXTURE_3D_KHR:
        {
            if (!displayExtensions.glTexture3DImage)
            {
                return Error(EGL_BAD_PARAMETER, "KHR_gl_texture_3D_image not supported.");
            }

            if (buffer == 0)
            {
                return Error(EGL_BAD_PARAMETER,
                             "buffer cannot reference a 3D texture with the name 0.");
            }

            const gl::Texture *texture =
                context->getTexture(egl_gl::EGLClientBufferToGLObjectHandle(buffer));
            if (texture == nullptr || texture->getTarget() != GL_TEXTURE_3D)
            {
                return Error(EGL_BAD_PARAMETER, "target is not a 3D texture.");
            }

            if (texture->getBoundSurface() != nullptr)
            {
                return Error(EGL_BAD_ACCESS, "texture has a surface bound to it.");
            }

            EGLAttrib level   = attributes.get(EGL_GL_TEXTURE_LEVEL_KHR, 0);
            EGLAttrib zOffset = attributes.get(EGL_GL_TEXTURE_ZOFFSET_KHR, 0);
            if (texture->getWidth(GL_TEXTURE_3D, static_cast<size_t>(level)) == 0 ||
                texture->getHeight(GL_TEXTURE_3D, static_cast<size_t>(level)) == 0 ||
                texture->getDepth(GL_TEXTURE_3D, static_cast<size_t>(level)) == 0)
            {
                return Error(EGL_BAD_PARAMETER,
                             "target 3D texture does not have a valid size at specified level.");
            }

            if (static_cast<size_t>(zOffset) >=
                texture->getDepth(GL_TEXTURE_3D, static_cast<size_t>(level)))
            {
                return Error(EGL_BAD_PARAMETER,
                             "target 3D texture does not have enough layers for the specified Z "
                             "offset at the specified level.");
            }

            ANGLE_TRY(ValidateCreateImageKHRMipLevelCommon(context, texture, level));
        }
        break;

        case EGL_GL_RENDERBUFFER_KHR:
        {
            if (!displayExtensions.glRenderbufferImage)
            {
                return Error(EGL_BAD_PARAMETER, "KHR_gl_renderbuffer_image not supported.");
            }

            if (attributes.contains(EGL_GL_TEXTURE_LEVEL_KHR))
            {
                return Error(EGL_BAD_PARAMETER,
                             "EGL_GL_TEXTURE_LEVEL_KHR cannot be used in conjunction with a "
                             "renderbuffer target.");
            }

            if (buffer == 0)
            {
                return Error(EGL_BAD_PARAMETER,
                             "buffer cannot reference a renderbuffer with the name 0.");
            }

            const gl::Renderbuffer *renderbuffer =
                context->getRenderbuffer(egl_gl::EGLClientBufferToGLObjectHandle(buffer));
            if (renderbuffer == nullptr)
            {
                return Error(EGL_BAD_PARAMETER, "target is not a renderbuffer.");
            }

            if (renderbuffer->getSamples() > 0)
            {
                return Error(EGL_BAD_PARAMETER, "target renderbuffer cannot be multisampled.");
            }
        }
        break;

        default:
            return Error(EGL_BAD_PARAMETER, "invalid target: 0x%X", target);
    }

    return Error(EGL_SUCCESS);
}

Error ValidateDestroyImageKHR(const Display *display, const Image *image)
{
    ANGLE_TRY(ValidateImage(display, image));

    if (!display->getExtensions().imageBase && !display->getExtensions().image)
    {
        // It is out of spec what happens when calling an extension function when the extension is
        // not available.
        // EGL_BAD_DISPLAY seems like a reasonable error.
        return Error(EGL_BAD_DISPLAY);
    }

    return Error(EGL_SUCCESS);
}

Error ValidateCreateDeviceANGLE(EGLint device_type,
                                void *native_device,
                                const EGLAttrib *attrib_list)
{
    const ClientExtensions &clientExtensions = Display::getClientExtensions();
    if (!clientExtensions.deviceCreation)
    {
        return Error(EGL_BAD_ACCESS, "Device creation extension not active");
    }

    if (attrib_list != nullptr && attrib_list[0] != EGL_NONE)
    {
        return Error(EGL_BAD_ATTRIBUTE, "Invalid attrib_list parameter");
    }

    switch (device_type)
    {
        case EGL_D3D11_DEVICE_ANGLE:
            if (!clientExtensions.deviceCreationD3D11)
            {
                return Error(EGL_BAD_ATTRIBUTE, "D3D11 device creation extension not active");
            }
            break;
        default:
            return Error(EGL_BAD_ATTRIBUTE, "Invalid device_type parameter");
    }

    return Error(EGL_SUCCESS);
}

Error ValidateReleaseDeviceANGLE(Device *device)
{
    const ClientExtensions &clientExtensions = Display::getClientExtensions();
    if (!clientExtensions.deviceCreation)
    {
        return Error(EGL_BAD_ACCESS, "Device creation extension not active");
    }

    if (device == EGL_NO_DEVICE_EXT || !Device::IsValidDevice(device))
    {
        return Error(EGL_BAD_DEVICE_EXT, "Invalid device parameter");
    }

    Display *owningDisplay = device->getOwningDisplay();
    if (owningDisplay != nullptr)
    {
        return Error(EGL_BAD_DEVICE_EXT, "Device must have been created using eglCreateDevice");
    }

    return Error(EGL_SUCCESS);
}

Error ValidateCreateStreamKHR(const Display *display, const AttributeMap &attributes)
{
    ANGLE_TRY(ValidateDisplay(display));

    const DisplayExtensions &displayExtensions = display->getExtensions();
    if (!displayExtensions.stream)
    {
        return Error(EGL_BAD_ALLOC, "Stream extension not active");
    }

    for (const auto &attributeIter : attributes)
    {
        EGLAttrib attribute = attributeIter.first;
        EGLAttrib value     = attributeIter.second;

        ANGLE_TRY(ValidateStreamAttribute(attribute, value, displayExtensions));
    }

    return Error(EGL_SUCCESS);
}

Error ValidateDestroyStreamKHR(const Display *display, const Stream *stream)
{
    ANGLE_TRY(ValidateStream(display, stream));
    return Error(EGL_SUCCESS);
}

Error ValidateStreamAttribKHR(const Display *display,
                              const Stream *stream,
                              EGLint attribute,
                              EGLint value)
{
    ANGLE_TRY(ValidateStream(display, stream));

    if (stream->getState() == EGL_STREAM_STATE_DISCONNECTED_KHR)
    {
        return Error(EGL_BAD_STATE_KHR, "Bad stream state");
    }

    return ValidateStreamAttribute(attribute, value, display->getExtensions());
}

Error ValidateQueryStreamKHR(const Display *display,
                             const Stream *stream,
                             EGLenum attribute,
                             EGLint *value)
{
    ANGLE_TRY(ValidateStream(display, stream));

    switch (attribute)
    {
        case EGL_STREAM_STATE_KHR:
        case EGL_CONSUMER_LATENCY_USEC_KHR:
            break;
        case EGL_CONSUMER_ACQUIRE_TIMEOUT_USEC_KHR:
            if (!display->getExtensions().streamConsumerGLTexture)
            {
                return Error(EGL_BAD_ATTRIBUTE, "Consumer GLTexture extension not active");
            }
            break;
        default:
            return Error(EGL_BAD_ATTRIBUTE, "Invalid attribute");
    }

    return Error(EGL_SUCCESS);
}

Error ValidateQueryStreamu64KHR(const Display *display,
                                const Stream *stream,
                                EGLenum attribute,
                                EGLuint64KHR *value)
{
    ANGLE_TRY(ValidateStream(display, stream));

    switch (attribute)
    {
        case EGL_CONSUMER_FRAME_KHR:
        case EGL_PRODUCER_FRAME_KHR:
            break;
        default:
            return Error(EGL_BAD_ATTRIBUTE, "Invalid attribute");
    }

    return Error(EGL_SUCCESS);
}

Error ValidateStreamConsumerGLTextureExternalKHR(const Display *display,
                                                 gl::Context *context,
                                                 const Stream *stream)
{
    ANGLE_TRY(ValidateDisplay(display));
    ANGLE_TRY(ValidateContext(display, context));

    const DisplayExtensions &displayExtensions = display->getExtensions();
    if (!displayExtensions.streamConsumerGLTexture)
    {
        return Error(EGL_BAD_ACCESS, "Stream consumer extension not active");
    }

    if (!context->getExtensions().eglStreamConsumerExternal)
    {
        return Error(EGL_BAD_ACCESS, "EGL stream consumer external GL extension not enabled");
    }

    if (stream == EGL_NO_STREAM_KHR || !display->isValidStream(stream))
    {
        return Error(EGL_BAD_STREAM_KHR, "Invalid stream");
    }

    if (stream->getState() != EGL_STREAM_STATE_CREATED_KHR)
    {
        return Error(EGL_BAD_STATE_KHR, "Invalid stream state");
    }

    // Lookup the texture and ensure it is correct
    gl::Texture *texture = context->getGLState().getTargetTexture(GL_TEXTURE_EXTERNAL_OES);
    if (texture == nullptr || texture->getId() == 0)
    {
        return Error(EGL_BAD_ACCESS, "No external texture bound");
    }

    return Error(EGL_SUCCESS);
}

Error ValidateStreamConsumerAcquireKHR(const Display *display,
                                       gl::Context *context,
                                       const Stream *stream)
{
    ANGLE_TRY(ValidateDisplay(display));

    const DisplayExtensions &displayExtensions = display->getExtensions();
    if (!displayExtensions.streamConsumerGLTexture)
    {
        return Error(EGL_BAD_ACCESS, "Stream consumer extension not active");
    }

    if (stream == EGL_NO_STREAM_KHR || !display->isValidStream(stream))
    {
        return Error(EGL_BAD_STREAM_KHR, "Invalid stream");
    }

    if (!context)
    {
        return Error(EGL_BAD_ACCESS, "No GL context current to calling thread.");
    }

    ANGLE_TRY(ValidateContext(display, context));

    if (!stream->isConsumerBoundToContext(context))
    {
        return Error(EGL_BAD_ACCESS, "Current GL context not associated with stream consumer");
    }

    if (stream->getConsumerType() != Stream::ConsumerType::GLTextureRGB &&
        stream->getConsumerType() != Stream::ConsumerType::GLTextureYUV)
    {
        return Error(EGL_BAD_ACCESS, "Invalid stream consumer type");
    }

    // Note: technically EGL_STREAM_STATE_EMPTY_KHR is a valid state when the timeout is non-zero.
    // However, the timeout is effectively ignored since it has no useful functionality with the
    // current producers that are implemented, so we don't allow that state
    if (stream->getState() != EGL_STREAM_STATE_NEW_FRAME_AVAILABLE_KHR &&
        stream->getState() != EGL_STREAM_STATE_OLD_FRAME_AVAILABLE_KHR)
    {
        return Error(EGL_BAD_STATE_KHR, "Invalid stream state");
    }

    return Error(EGL_SUCCESS);
}

Error ValidateStreamConsumerReleaseKHR(const Display *display,
                                       gl::Context *context,
                                       const Stream *stream)
{
    ANGLE_TRY(ValidateDisplay(display));

    const DisplayExtensions &displayExtensions = display->getExtensions();
    if (!displayExtensions.streamConsumerGLTexture)
    {
        return Error(EGL_BAD_ACCESS, "Stream consumer extension not active");
    }

    if (stream == EGL_NO_STREAM_KHR || !display->isValidStream(stream))
    {
        return Error(EGL_BAD_STREAM_KHR, "Invalid stream");
    }

    if (!context)
    {
        return Error(EGL_BAD_ACCESS, "No GL context current to calling thread.");
    }

    ANGLE_TRY(ValidateContext(display, context));

    if (!stream->isConsumerBoundToContext(context))
    {
        return Error(EGL_BAD_ACCESS, "Current GL context not associated with stream consumer");
    }

    if (stream->getConsumerType() != Stream::ConsumerType::GLTextureRGB &&
        stream->getConsumerType() != Stream::ConsumerType::GLTextureYUV)
    {
        return Error(EGL_BAD_ACCESS, "Invalid stream consumer type");
    }

    if (stream->getState() != EGL_STREAM_STATE_NEW_FRAME_AVAILABLE_KHR &&
        stream->getState() != EGL_STREAM_STATE_OLD_FRAME_AVAILABLE_KHR)
    {
        return Error(EGL_BAD_STATE_KHR, "Invalid stream state");
    }

    return Error(EGL_SUCCESS);
}

Error ValidateStreamConsumerGLTextureExternalAttribsNV(const Display *display,
                                                       gl::Context *context,
                                                       const Stream *stream,
                                                       const AttributeMap &attribs)
{
    ANGLE_TRY(ValidateDisplay(display));

    const DisplayExtensions &displayExtensions = display->getExtensions();
    if (!displayExtensions.streamConsumerGLTexture)
    {
        return Error(EGL_BAD_ACCESS, "Stream consumer extension not active");
    }

    // Although technically not a requirement in spec, the context needs to be checked for support
    // for external textures or future logic will cause assertations. This extension is also
    // effectively useless without external textures.
    if (!context->getExtensions().eglStreamConsumerExternal)
    {
        return Error(EGL_BAD_ACCESS, "EGL stream consumer external GL extension not enabled");
    }

    if (stream == EGL_NO_STREAM_KHR || !display->isValidStream(stream))
    {
        return Error(EGL_BAD_STREAM_KHR, "Invalid stream");
    }

    if (!context)
    {
        return Error(EGL_BAD_ACCESS, "No GL context current to calling thread.");
    }

    ANGLE_TRY(ValidateContext(display, context));

    if (stream->getState() != EGL_STREAM_STATE_CREATED_KHR)
    {
        return Error(EGL_BAD_STATE_KHR, "Invalid stream state");
    }

    const gl::Caps &glCaps = context->getCaps();

    EGLAttrib colorBufferType = EGL_RGB_BUFFER;
    EGLAttrib planeCount      = -1;
    EGLAttrib plane[3];
    for (int i = 0; i < 3; i++)
    {
        plane[i] = -1;
    }
    for (const auto &attributeIter : attribs)
    {
        EGLAttrib attribute = attributeIter.first;
        EGLAttrib value     = attributeIter.second;

        switch (attribute)
        {
            case EGL_COLOR_BUFFER_TYPE:
                if (value != EGL_RGB_BUFFER && value != EGL_YUV_BUFFER_EXT)
                {
                    return Error(EGL_BAD_PARAMETER, "Invalid color buffer type");
                }
                colorBufferType = value;
                break;
            case EGL_YUV_NUMBER_OF_PLANES_EXT:
                // planeCount = -1 is a tag for the default plane count so the value must be checked
                // to be positive here to ensure future logic doesn't break on invalid negative
                // inputs
                if (value < 0)
                {
                    return Error(EGL_BAD_MATCH, "Invalid plane count");
                }
                planeCount = value;
                break;
            default:
                if (attribute >= EGL_YUV_PLANE0_TEXTURE_UNIT_NV &&
                    attribute <= EGL_YUV_PLANE2_TEXTURE_UNIT_NV)
                {
                    if ((value < 0 ||
                         value >= static_cast<EGLAttrib>(glCaps.maxCombinedTextureImageUnits)) &&
                        value != EGL_NONE)
                    {
                        return Error(EGL_BAD_ACCESS, "Invalid texture unit");
                    }
                    plane[attribute - EGL_YUV_PLANE0_TEXTURE_UNIT_NV] = value;
                }
                else
                {
                    return Error(EGL_BAD_ATTRIBUTE, "Invalid attribute");
                }
        }
    }

    if (colorBufferType == EGL_RGB_BUFFER)
    {
        if (planeCount > 0)
        {
            return Error(EGL_BAD_MATCH, "Plane count must be 0 for RGB buffer");
        }
        for (int i = 0; i < 3; i++)
        {
            if (plane[i] != -1)
            {
                return Error(EGL_BAD_MATCH, "Planes cannot be specified");
            }
        }

        // Lookup the texture and ensure it is correct
        gl::Texture *texture = context->getGLState().getTargetTexture(GL_TEXTURE_EXTERNAL_OES);
        if (texture == nullptr || texture->getId() == 0)
        {
            return Error(EGL_BAD_ACCESS, "No external texture bound");
        }
    }
    else
    {
        if (planeCount == -1)
        {
            planeCount = 2;
        }
        if (planeCount < 1 || planeCount > 3)
        {
            return Error(EGL_BAD_MATCH, "Invalid YUV plane count");
        }
        for (EGLAttrib i = planeCount; i < 3; i++)
        {
            if (plane[i] != -1)
            {
                return Error(EGL_BAD_MATCH, "Invalid plane specified");
            }
        }

        // Set to ensure no texture is referenced more than once
        std::set<gl::Texture *> textureSet;
        for (EGLAttrib i = 0; i < planeCount; i++)
        {
            if (plane[i] == -1)
            {
                return Error(EGL_BAD_MATCH, "Not all planes specified");
            }
            if (plane[i] != EGL_NONE)
            {
                gl::Texture *texture = context->getGLState().getSamplerTexture(
                    static_cast<unsigned int>(plane[i]), GL_TEXTURE_EXTERNAL_OES);
                if (texture == nullptr || texture->getId() == 0)
                {
                    return Error(
                        EGL_BAD_ACCESS,
                        "No external texture bound at one or more specified texture units");
                }
                if (textureSet.find(texture) != textureSet.end())
                {
                    return Error(EGL_BAD_ACCESS, "Multiple planes bound to same texture object");
                }
                textureSet.insert(texture);
            }
        }
    }

    return Error(EGL_SUCCESS);
}

Error ValidateCreateStreamProducerD3DTextureNV12ANGLE(const Display *display,
                                                      const Stream *stream,
                                                      const AttributeMap &attribs)
{
    ANGLE_TRY(ValidateDisplay(display));

    const DisplayExtensions &displayExtensions = display->getExtensions();
    if (!displayExtensions.streamProducerD3DTextureNV12)
    {
        return Error(EGL_BAD_ACCESS, "Stream producer extension not active");
    }

    ANGLE_TRY(ValidateStream(display, stream));

    if (!attribs.isEmpty())
    {
        return Error(EGL_BAD_ATTRIBUTE, "Invalid attribute");
    }

    if (stream->getState() != EGL_STREAM_STATE_CONNECTING_KHR)
    {
        return Error(EGL_BAD_STATE_KHR, "Stream not in connecting state");
    }

    if (stream->getConsumerType() != Stream::ConsumerType::GLTextureYUV ||
        stream->getPlaneCount() != 2)
    {
        return Error(EGL_BAD_MATCH, "Incompatible stream consumer type");
    }

    return Error(EGL_SUCCESS);
}

Error ValidateStreamPostD3DTextureNV12ANGLE(const Display *display,
                                            const Stream *stream,
                                            void *texture,
                                            const AttributeMap &attribs)
{
    ANGLE_TRY(ValidateDisplay(display));

    const DisplayExtensions &displayExtensions = display->getExtensions();
    if (!displayExtensions.streamProducerD3DTextureNV12)
    {
        return Error(EGL_BAD_ACCESS, "Stream producer extension not active");
    }

    ANGLE_TRY(ValidateStream(display, stream));

    for (auto &attributeIter : attribs)
    {
        EGLAttrib attribute = attributeIter.first;
        EGLAttrib value     = attributeIter.second;

        switch (attribute)
        {
            case EGL_D3D_TEXTURE_SUBRESOURCE_ID_ANGLE:
                if (value < 0)
                {
                    return Error(EGL_BAD_PARAMETER, "Invalid subresource index");
                }
                break;
            default:
                return Error(EGL_BAD_ATTRIBUTE, "Invalid attribute");
        }
    }

    if (stream->getState() != EGL_STREAM_STATE_EMPTY_KHR &&
        stream->getState() != EGL_STREAM_STATE_NEW_FRAME_AVAILABLE_KHR &&
        stream->getState() != EGL_STREAM_STATE_OLD_FRAME_AVAILABLE_KHR)
    {
        return Error(EGL_BAD_STATE_KHR, "Stream not fully configured");
    }

    if (stream->getProducerType() != Stream::ProducerType::D3D11TextureNV12)
    {
        return Error(EGL_BAD_MATCH, "Incompatible stream producer");
    }

    if (texture == nullptr)
    {
        return egl::Error(EGL_BAD_PARAMETER, "Texture is null");
    }

    return stream->validateD3D11NV12Texture(texture);
}

Error ValidateSwapBuffersWithDamageEXT(const Display *display,
                                       const Surface *surface,
                                       EGLint *rects,
                                       EGLint n_rects)
{
    Error error = ValidateSurface(display, surface);
    if (error.isError())
    {
        return error;
    }

    if (!display->getExtensions().swapBuffersWithDamage)
    {
        // It is out of spec what happens when calling an extension function when the extension is
        // not available. EGL_BAD_DISPLAY seems like a reasonable error.
        return Error(EGL_BAD_DISPLAY, "EGL_EXT_swap_buffers_with_damage is not available.");
    }

    if (surface == EGL_NO_SURFACE)
    {
        return Error(EGL_BAD_SURFACE, "Swap surface cannot be EGL_NO_SURFACE.");
    }

    if (n_rects < 0)
    {
        return Error(EGL_BAD_PARAMETER, "n_rects cannot be negative.");
    }

    if (n_rects > 0 && rects == nullptr)
    {
        return Error(EGL_BAD_PARAMETER, "n_rects cannot be greater than zero when rects is NULL.");
    }

    return Error(EGL_SUCCESS);
}

}  // namespace gl
