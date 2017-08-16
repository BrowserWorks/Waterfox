//
// Copyright (c) 2014 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//

// Data.cpp: Container class for all GL relevant state, caps and objects

#include "libANGLE/ContextState.h"

#include "libANGLE/Framebuffer.h"
#include "libANGLE/ResourceManager.h"

namespace gl
{

ContextState::ContextState(uintptr_t contextIn,
                           const Version &clientVersion,
                           State *stateIn,
                           const Caps &capsIn,
                           const TextureCapsMap &textureCapsIn,
                           const Extensions &extensionsIn,
                           const ResourceManager *resourceManagerIn,
                           const Limitations &limitationsIn,
                           const ResourceMap<Framebuffer> &framebufferMap)
    : mClientVersion(clientVersion),
      mContext(contextIn),
      mState(stateIn),
      mCaps(capsIn),
      mTextureCaps(textureCapsIn),
      mExtensions(extensionsIn),
      mResourceManager(resourceManagerIn),
      mLimitations(limitationsIn),
      mFramebufferMap(framebufferMap)
{
}

ContextState::~ContextState()
{
}

const TextureCaps &ContextState::getTextureCap(GLenum internalFormat) const
{
    return mTextureCaps.get(internalFormat);
}

ValidationContext::ValidationContext(const Version &clientVersion,
                                     State *state,
                                     const Caps &caps,
                                     const TextureCapsMap &textureCaps,
                                     const Extensions &extensions,
                                     const ResourceManager *resourceManager,
                                     const Limitations &limitations,
                                     const ResourceMap<Framebuffer> &framebufferMap,
                                     bool skipValidation)
    : mState(reinterpret_cast<uintptr_t>(this),
             clientVersion,
             state,
             caps,
             textureCaps,
             extensions,
             resourceManager,
             limitations,
             framebufferMap),
      mSkipValidation(skipValidation)
{
}

bool ValidationContext::getQueryParameterInfo(GLenum pname, GLenum *type, unsigned int *numParams)
{
    if (pname >= GL_DRAW_BUFFER0_EXT && pname <= GL_DRAW_BUFFER15_EXT)
    {
        *type      = GL_INT;
        *numParams = 1;
        return true;
    }

    // Please note: the query type returned for DEPTH_CLEAR_VALUE in this implementation
    // is FLOAT rather than INT, as would be suggested by the GL ES 2.0 spec. This is due
    // to the fact that it is stored internally as a float, and so would require conversion
    // if returned from Context::getIntegerv. Since this conversion is already implemented
    // in the case that one calls glGetIntegerv to retrieve a float-typed state variable, we
    // place DEPTH_CLEAR_VALUE with the floats. This should make no difference to the calling
    // application.
    switch (pname)
    {
        case GL_COMPRESSED_TEXTURE_FORMATS:
        {
            *type      = GL_INT;
            *numParams = static_cast<unsigned int>(getCaps().compressedTextureFormats.size());
            return true;
        }
        case GL_PROGRAM_BINARY_FORMATS_OES:
        {
            *type      = GL_INT;
            *numParams = static_cast<unsigned int>(getCaps().programBinaryFormats.size());
            return true;
        }
        case GL_SHADER_BINARY_FORMATS:
        {
            *type      = GL_INT;
            *numParams = static_cast<unsigned int>(getCaps().shaderBinaryFormats.size());
            return true;
        }

        case GL_MAX_VERTEX_ATTRIBS:
        case GL_MAX_VERTEX_UNIFORM_VECTORS:
        case GL_MAX_VARYING_VECTORS:
        case GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS:
        case GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS:
        case GL_MAX_TEXTURE_IMAGE_UNITS:
        case GL_MAX_FRAGMENT_UNIFORM_VECTORS:
        case GL_MAX_RENDERBUFFER_SIZE:
        case GL_MAX_COLOR_ATTACHMENTS_EXT:
        case GL_MAX_DRAW_BUFFERS_EXT:
        case GL_NUM_SHADER_BINARY_FORMATS:
        case GL_NUM_COMPRESSED_TEXTURE_FORMATS:
        case GL_ARRAY_BUFFER_BINDING:
        // case GL_FRAMEBUFFER_BINDING: // equivalent to DRAW_FRAMEBUFFER_BINDING_ANGLE
        case GL_DRAW_FRAMEBUFFER_BINDING_ANGLE:
        case GL_READ_FRAMEBUFFER_BINDING_ANGLE:
        case GL_RENDERBUFFER_BINDING:
        case GL_CURRENT_PROGRAM:
        case GL_PACK_ALIGNMENT:
        case GL_PACK_REVERSE_ROW_ORDER_ANGLE:
        case GL_UNPACK_ALIGNMENT:
        case GL_GENERATE_MIPMAP_HINT:
        case GL_FRAGMENT_SHADER_DERIVATIVE_HINT_OES:
        case GL_RED_BITS:
        case GL_GREEN_BITS:
        case GL_BLUE_BITS:
        case GL_ALPHA_BITS:
        case GL_DEPTH_BITS:
        case GL_STENCIL_BITS:
        case GL_ELEMENT_ARRAY_BUFFER_BINDING:
        case GL_CULL_FACE_MODE:
        case GL_FRONT_FACE:
        case GL_ACTIVE_TEXTURE:
        case GL_STENCIL_FUNC:
        case GL_STENCIL_VALUE_MASK:
        case GL_STENCIL_REF:
        case GL_STENCIL_FAIL:
        case GL_STENCIL_PASS_DEPTH_FAIL:
        case GL_STENCIL_PASS_DEPTH_PASS:
        case GL_STENCIL_BACK_FUNC:
        case GL_STENCIL_BACK_VALUE_MASK:
        case GL_STENCIL_BACK_REF:
        case GL_STENCIL_BACK_FAIL:
        case GL_STENCIL_BACK_PASS_DEPTH_FAIL:
        case GL_STENCIL_BACK_PASS_DEPTH_PASS:
        case GL_DEPTH_FUNC:
        case GL_BLEND_SRC_RGB:
        case GL_BLEND_SRC_ALPHA:
        case GL_BLEND_DST_RGB:
        case GL_BLEND_DST_ALPHA:
        case GL_BLEND_EQUATION_RGB:
        case GL_BLEND_EQUATION_ALPHA:
        case GL_STENCIL_WRITEMASK:
        case GL_STENCIL_BACK_WRITEMASK:
        case GL_STENCIL_CLEAR_VALUE:
        case GL_SUBPIXEL_BITS:
        case GL_MAX_TEXTURE_SIZE:
        case GL_MAX_CUBE_MAP_TEXTURE_SIZE:
        case GL_SAMPLE_BUFFERS:
        case GL_SAMPLES:
        case GL_IMPLEMENTATION_COLOR_READ_TYPE:
        case GL_IMPLEMENTATION_COLOR_READ_FORMAT:
        case GL_TEXTURE_BINDING_2D:
        case GL_TEXTURE_BINDING_CUBE_MAP:
        case GL_RESET_NOTIFICATION_STRATEGY_EXT:
        case GL_NUM_PROGRAM_BINARY_FORMATS_OES:
        {
            *type      = GL_INT;
            *numParams = 1;
            return true;
        }
        case GL_MAX_SAMPLES_ANGLE:
        {
            if (!getExtensions().framebufferMultisample)
            {
                return false;
            }
            *type      = GL_INT;
            *numParams = 1;
            return true;
        }
        case GL_MAX_VIEWPORT_DIMS:
        {
            *type      = GL_INT;
            *numParams = 2;
            return true;
        }
        case GL_VIEWPORT:
        case GL_SCISSOR_BOX:
        {
            *type      = GL_INT;
            *numParams = 4;
            return true;
        }
        case GL_SHADER_COMPILER:
        case GL_SAMPLE_COVERAGE_INVERT:
        case GL_DEPTH_WRITEMASK:
        case GL_CULL_FACE:                 // CULL_FACE through DITHER are natural to IsEnabled,
        case GL_POLYGON_OFFSET_FILL:       // but can be retrieved through the Get{Type}v queries.
        case GL_SAMPLE_ALPHA_TO_COVERAGE:  // For this purpose, they are treated here as
                                           // bool-natural
        case GL_SAMPLE_COVERAGE:
        case GL_SCISSOR_TEST:
        case GL_STENCIL_TEST:
        case GL_DEPTH_TEST:
        case GL_BLEND:
        case GL_DITHER:
        case GL_CONTEXT_ROBUST_ACCESS_EXT:
        {
            *type      = GL_BOOL;
            *numParams = 1;
            return true;
        }
        case GL_COLOR_WRITEMASK:
        {
            *type      = GL_BOOL;
            *numParams = 4;
            return true;
        }
        case GL_POLYGON_OFFSET_FACTOR:
        case GL_POLYGON_OFFSET_UNITS:
        case GL_SAMPLE_COVERAGE_VALUE:
        case GL_DEPTH_CLEAR_VALUE:
        case GL_LINE_WIDTH:
        {
            *type      = GL_FLOAT;
            *numParams = 1;
            return true;
        }
        case GL_ALIASED_LINE_WIDTH_RANGE:
        case GL_ALIASED_POINT_SIZE_RANGE:
        case GL_DEPTH_RANGE:
        {
            *type      = GL_FLOAT;
            *numParams = 2;
            return true;
        }
        case GL_COLOR_CLEAR_VALUE:
        case GL_BLEND_COLOR:
        {
            *type      = GL_FLOAT;
            *numParams = 4;
            return true;
        }
        case GL_MAX_TEXTURE_MAX_ANISOTROPY_EXT:
            if (!getExtensions().maxTextureAnisotropy)
            {
                return false;
            }
            *type      = GL_FLOAT;
            *numParams = 1;
            return true;
        case GL_TIMESTAMP_EXT:
            if (!getExtensions().disjointTimerQuery)
            {
                return false;
            }
            *type      = GL_INT_64_ANGLEX;
            *numParams = 1;
            return true;
        case GL_GPU_DISJOINT_EXT:
            if (!getExtensions().disjointTimerQuery)
            {
                return false;
            }
            *type      = GL_INT;
            *numParams = 1;
            return true;
        case GL_COVERAGE_MODULATION_CHROMIUM:
            if (!getExtensions().framebufferMixedSamples)
            {
                return false;
            }
            *type      = GL_INT;
            *numParams = 1;
            return true;
        case GL_TEXTURE_BINDING_EXTERNAL_OES:
            if (!getExtensions().eglStreamConsumerExternal && !getExtensions().eglImageExternal)
            {
                return false;
            }
            *type      = GL_INT;
            *numParams = 1;
            return true;
    }

    if (getExtensions().debug)
    {
        switch (pname)
        {
            case GL_DEBUG_LOGGED_MESSAGES:
            case GL_DEBUG_NEXT_LOGGED_MESSAGE_LENGTH:
            case GL_DEBUG_GROUP_STACK_DEPTH:
            case GL_MAX_DEBUG_MESSAGE_LENGTH:
            case GL_MAX_DEBUG_LOGGED_MESSAGES:
            case GL_MAX_DEBUG_GROUP_STACK_DEPTH:
            case GL_MAX_LABEL_LENGTH:
                *type      = GL_INT;
                *numParams = 1;
                return true;

            case GL_DEBUG_OUTPUT_SYNCHRONOUS:
            case GL_DEBUG_OUTPUT:
                *type      = GL_BOOL;
                *numParams = 1;
                return true;
        }
    }

    if (getExtensions().multisampleCompatibility)
    {
        switch (pname)
        {
            case GL_MULTISAMPLE_EXT:
            case GL_SAMPLE_ALPHA_TO_ONE_EXT:
                *type      = GL_BOOL;
                *numParams = 1;
                return true;
        }
    }

    if (getExtensions().pathRendering)
    {
        switch (pname)
        {
            case GL_PATH_MODELVIEW_MATRIX_CHROMIUM:
            case GL_PATH_PROJECTION_MATRIX_CHROMIUM:
                *type = GL_FLOAT;
                *numParams = 16;
                return true;
        }
    }

    if (getExtensions().bindGeneratesResource)
    {
        switch (pname)
        {
            case GL_BIND_GENERATES_RESOURCE_CHROMIUM:
                *type      = GL_BOOL;
                *numParams = 1;
                return true;
        }
    }

    if (getExtensions().sRGBWriteControl)
    {
        switch (pname)
        {
            case GL_FRAMEBUFFER_SRGB_EXT:
                *type      = GL_BOOL;
                *numParams = 1;
                return true;
        }
    }

    // Check for ES3.0+ parameter names which are also exposed as ES2 extensions
    switch (pname)
    {
        case GL_PACK_ROW_LENGTH:
        case GL_PACK_SKIP_ROWS:
        case GL_PACK_SKIP_PIXELS:
            if ((getClientMajorVersion() < 3) && !getExtensions().packSubimage)
            {
                return false;
            }
            *type      = GL_INT;
            *numParams = 1;
            return true;
        case GL_UNPACK_ROW_LENGTH:
        case GL_UNPACK_SKIP_ROWS:
        case GL_UNPACK_SKIP_PIXELS:
            if ((getClientMajorVersion() < 3) && !getExtensions().unpackSubimage)
            {
                return false;
            }
            *type      = GL_INT;
            *numParams = 1;
            return true;
        case GL_VERTEX_ARRAY_BINDING:
            if ((getClientMajorVersion() < 3) && !getExtensions().vertexArrayObject)
            {
                return false;
            }
            *type      = GL_INT;
            *numParams = 1;
            return true;
        case GL_PIXEL_PACK_BUFFER_BINDING:
        case GL_PIXEL_UNPACK_BUFFER_BINDING:
            if ((getClientMajorVersion() < 3) && !getExtensions().pixelBufferObject)
            {
                return false;
            }
            *type      = GL_INT;
            *numParams = 1;
            return true;
    }

    if (getClientVersion() < Version(3, 0))
    {
        return false;
    }

    // Check for ES3.0+ parameter names
    switch (pname)
    {
        case GL_MAX_UNIFORM_BUFFER_BINDINGS:
        case GL_UNIFORM_BUFFER_OFFSET_ALIGNMENT:
        case GL_UNIFORM_BUFFER_BINDING:
        case GL_TRANSFORM_FEEDBACK_BINDING:
        case GL_TRANSFORM_FEEDBACK_BUFFER_BINDING:
        case GL_COPY_READ_BUFFER_BINDING:
        case GL_COPY_WRITE_BUFFER_BINDING:
        case GL_SAMPLER_BINDING:
        case GL_READ_BUFFER:
        case GL_TEXTURE_BINDING_3D:
        case GL_TEXTURE_BINDING_2D_ARRAY:
        case GL_MAX_3D_TEXTURE_SIZE:
        case GL_MAX_ARRAY_TEXTURE_LAYERS:
        case GL_MAX_VERTEX_UNIFORM_BLOCKS:
        case GL_MAX_FRAGMENT_UNIFORM_BLOCKS:
        case GL_MAX_COMBINED_UNIFORM_BLOCKS:
        case GL_MAX_VERTEX_OUTPUT_COMPONENTS:
        case GL_MAX_FRAGMENT_INPUT_COMPONENTS:
        case GL_MAX_VARYING_COMPONENTS:
        case GL_MAX_VERTEX_UNIFORM_COMPONENTS:
        case GL_MAX_FRAGMENT_UNIFORM_COMPONENTS:
        case GL_MIN_PROGRAM_TEXEL_OFFSET:
        case GL_MAX_PROGRAM_TEXEL_OFFSET:
        case GL_NUM_EXTENSIONS:
        case GL_MAJOR_VERSION:
        case GL_MINOR_VERSION:
        case GL_MAX_ELEMENTS_INDICES:
        case GL_MAX_ELEMENTS_VERTICES:
        case GL_MAX_TRANSFORM_FEEDBACK_INTERLEAVED_COMPONENTS:
        case GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS:
        case GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS:
        case GL_UNPACK_IMAGE_HEIGHT:
        case GL_UNPACK_SKIP_IMAGES:
        {
            *type      = GL_INT;
            *numParams = 1;
            return true;
        }

        case GL_MAX_ELEMENT_INDEX:
        case GL_MAX_UNIFORM_BLOCK_SIZE:
        case GL_MAX_COMBINED_VERTEX_UNIFORM_COMPONENTS:
        case GL_MAX_COMBINED_FRAGMENT_UNIFORM_COMPONENTS:
        case GL_MAX_SERVER_WAIT_TIMEOUT:
        {
            *type      = GL_INT_64_ANGLEX;
            *numParams = 1;
            return true;
        }

        case GL_TRANSFORM_FEEDBACK_ACTIVE:
        case GL_TRANSFORM_FEEDBACK_PAUSED:
        case GL_PRIMITIVE_RESTART_FIXED_INDEX:
        case GL_RASTERIZER_DISCARD:
        {
            *type      = GL_BOOL;
            *numParams = 1;
            return true;
        }

        case GL_MAX_TEXTURE_LOD_BIAS:
        {
            *type      = GL_FLOAT;
            *numParams = 1;
            return true;
        }
    }

    if (getExtensions().requestExtension)
    {
        switch (pname)
        {
            case GL_NUM_REQUESTABLE_EXTENSIONS_ANGLE:
                *type      = GL_INT;
                *numParams = 1;
                return true;
        }
    }

    if (getClientVersion() < Version(3, 1))
    {
        return false;
    }

    switch (pname)
    {
        case GL_DRAW_INDIRECT_BUFFER_BINDING:
        case GL_MAX_FRAMEBUFFER_WIDTH:
        case GL_MAX_FRAMEBUFFER_HEIGHT:
        case GL_MAX_FRAMEBUFFER_SAMPLES:
        case GL_MAX_SAMPLE_MASK_WORDS:
        case GL_MAX_COLOR_TEXTURE_SAMPLES:
        case GL_MAX_DEPTH_TEXTURE_SAMPLES:
        case GL_MAX_INTEGER_SAMPLES:
        case GL_MAX_VERTEX_ATTRIB_RELATIVE_OFFSET:
        case GL_MAX_VERTEX_ATTRIB_BINDINGS:
        case GL_MAX_VERTEX_ATTRIB_STRIDE:
        case GL_MAX_VERTEX_ATOMIC_COUNTER_BUFFERS:
        case GL_MAX_VERTEX_ATOMIC_COUNTERS:
        case GL_MAX_VERTEX_IMAGE_UNIFORMS:
        case GL_MAX_VERTEX_SHADER_STORAGE_BLOCKS:
        case GL_MAX_FRAGMENT_ATOMIC_COUNTER_BUFFERS:
        case GL_MAX_FRAGMENT_ATOMIC_COUNTERS:
        case GL_MAX_FRAGMENT_IMAGE_UNIFORMS:
        case GL_MAX_FRAGMENT_SHADER_STORAGE_BLOCKS:
        case GL_MIN_PROGRAM_TEXTURE_GATHER_OFFSET:
        case GL_MAX_PROGRAM_TEXTURE_GATHER_OFFSET:
        case GL_MAX_COMPUTE_WORK_GROUP_INVOCATIONS:
        case GL_MAX_COMPUTE_UNIFORM_BLOCKS:
        case GL_MAX_COMPUTE_TEXTURE_IMAGE_UNITS:
        case GL_MAX_COMPUTE_SHARED_MEMORY_SIZE:
        case GL_MAX_COMPUTE_UNIFORM_COMPONENTS:
        case GL_MAX_COMPUTE_ATOMIC_COUNTER_BUFFERS:
        case GL_MAX_COMPUTE_ATOMIC_COUNTERS:
        case GL_MAX_COMPUTE_IMAGE_UNIFORMS:
        case GL_MAX_COMBINED_COMPUTE_UNIFORM_COMPONENTS:
        case GL_MAX_COMPUTE_SHADER_STORAGE_BLOCKS:
        case GL_MAX_COMBINED_SHADER_OUTPUT_RESOURCES:
        case GL_MAX_UNIFORM_LOCATIONS:
        case GL_MAX_ATOMIC_COUNTER_BUFFER_BINDINGS:
        case GL_MAX_ATOMIC_COUNTER_BUFFER_SIZE:
        case GL_MAX_COMBINED_ATOMIC_COUNTER_BUFFERS:
        case GL_MAX_COMBINED_ATOMIC_COUNTERS:
        case GL_MAX_IMAGE_UNITS:
        case GL_MAX_COMBINED_IMAGE_UNIFORMS:
        case GL_MAX_SHADER_STORAGE_BUFFER_BINDINGS:
        case GL_MAX_COMBINED_SHADER_STORAGE_BLOCKS:
        case GL_SHADER_STORAGE_BUFFER_OFFSET_ALIGNMENT:
            *type      = GL_INT;
            *numParams = 1;
            return true;
        case GL_MAX_SHADER_STORAGE_BLOCK_SIZE:
            *type      = GL_INT_64_ANGLEX;
            *numParams = 1;
            return true;
    }

    return false;
}

bool ValidationContext::getIndexedQueryParameterInfo(GLenum target,
                                                     GLenum *type,
                                                     unsigned int *numParams)
{
    if (getClientVersion() < Version(3, 0))
    {
        return false;
    }

    switch (target)
    {
        case GL_TRANSFORM_FEEDBACK_BUFFER_BINDING:
        case GL_UNIFORM_BUFFER_BINDING:
        {
            *type      = GL_INT;
            *numParams = 1;
            return true;
        }
        case GL_TRANSFORM_FEEDBACK_BUFFER_START:
        case GL_TRANSFORM_FEEDBACK_BUFFER_SIZE:
        case GL_UNIFORM_BUFFER_START:
        case GL_UNIFORM_BUFFER_SIZE:
        {
            *type      = GL_INT_64_ANGLEX;
            *numParams = 1;
            return true;
        }
    }

    if (getClientVersion() < Version(3, 1))
    {
        return false;
    }

    switch (target)
    {
        case GL_MAX_COMPUTE_WORK_GROUP_COUNT:
        case GL_MAX_COMPUTE_WORK_GROUP_SIZE:
        {
            *type      = GL_INT;
            *numParams = 1;
            return true;
        }
    }

    return false;
}

Program *ValidationContext::getProgram(GLuint handle) const
{
    return mState.mResourceManager->getProgram(handle);
}

Shader *ValidationContext::getShader(GLuint handle) const
{
    return mState.mResourceManager->getShader(handle);
}

bool ValidationContext::isTextureGenerated(GLuint texture) const
{
    return mState.mResourceManager->isTextureGenerated(texture);
}

bool ValidationContext::isBufferGenerated(GLuint buffer) const
{
    return mState.mResourceManager->isBufferGenerated(buffer);
}

bool ValidationContext::isRenderbufferGenerated(GLuint renderbuffer) const
{
    return mState.mResourceManager->isRenderbufferGenerated(renderbuffer);
}

bool ValidationContext::isFramebufferGenerated(GLuint framebuffer) const
{
    ASSERT(mState.mFramebufferMap.find(0) != mState.mFramebufferMap.end());
    return mState.mFramebufferMap.find(framebuffer) != mState.mFramebufferMap.end();
}

}  // namespace gl
