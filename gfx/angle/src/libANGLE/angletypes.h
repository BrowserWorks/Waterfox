//
// Copyright (c) 2012-2013 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//

// angletypes.h : Defines a variety of structures and enum types that are used throughout libGLESv2

#ifndef LIBANGLE_ANGLETYPES_H_
#define LIBANGLE_ANGLETYPES_H_

#include "libANGLE/Constants.h"
#include "libANGLE/RefCountObject.h"

#include <stdint.h>

#include <bitset>
#include <unordered_map>

namespace gl
{
class Buffer;
class State;
class Program;
struct VertexAttribute;
struct VertexAttribCurrentValueData;

enum PrimitiveType
{
    PRIMITIVE_POINTS,
    PRIMITIVE_LINES,
    PRIMITIVE_LINE_STRIP,
    PRIMITIVE_LINE_LOOP,
    PRIMITIVE_TRIANGLES,
    PRIMITIVE_TRIANGLE_STRIP,
    PRIMITIVE_TRIANGLE_FAN,
    PRIMITIVE_TYPE_MAX,
};

PrimitiveType GetPrimitiveType(GLenum drawMode);

enum SamplerType
{
    SAMPLER_PIXEL,
    SAMPLER_VERTEX
};

struct Rectangle
{
    Rectangle() : x(0), y(0), width(0), height(0) {}
    Rectangle(int x_in, int y_in, int width_in, int height_in)
        : x(x_in), y(y_in), width(width_in), height(height_in)
    {
    }

    int x0() const { return x; }
    int y0() const { return y; }
    int x1() const { return x + width; }
    int y1() const { return y + height; }

    int x;
    int y;
    int width;
    int height;
};

bool operator==(const Rectangle &a, const Rectangle &b);
bool operator!=(const Rectangle &a, const Rectangle &b);

bool ClipRectangle(const Rectangle &source, const Rectangle &clip, Rectangle *intersection);

struct Offset
{
    int x;
    int y;
    int z;

    Offset() : x(0), y(0), z(0) { }
    Offset(int x_in, int y_in, int z_in) : x(x_in), y(y_in), z(z_in) { }
};

struct Extents
{
    int width;
    int height;
    int depth;

    Extents() : width(0), height(0), depth(0) { }
    Extents(int width_, int height_, int depth_) : width(width_), height(height_), depth(depth_) { }

    Extents(const Extents &other) = default;
    Extents &operator=(const Extents &other) = default;

    bool empty() const { return (width * height * depth) == 0; }
};

bool operator==(const Extents &lhs, const Extents &rhs);
bool operator!=(const Extents &lhs, const Extents &rhs);

struct Box
{
    int x;
    int y;
    int z;
    int width;
    int height;
    int depth;

    Box() : x(0), y(0), z(0), width(0), height(0), depth(0) { }
    Box(int x_in, int y_in, int z_in, int width_in, int height_in, int depth_in) : x(x_in), y(y_in), z(z_in), width(width_in), height(height_in), depth(depth_in) { }
    Box(const Offset &offset, const Extents &size) : x(offset.x), y(offset.y), z(offset.z), width(size.width), height(size.height), depth(size.depth) { }
    bool operator==(const Box &other) const;
    bool operator!=(const Box &other) const;
};


struct RasterizerState
{
    bool cullFace;
    GLenum cullMode;
    GLenum frontFace;

    bool polygonOffsetFill;
    GLfloat polygonOffsetFactor;
    GLfloat polygonOffsetUnits;

    bool pointDrawMode;
    bool multiSample;

    bool rasterizerDiscard;
};

struct BlendState
{
    bool blend;
    GLenum sourceBlendRGB;
    GLenum destBlendRGB;
    GLenum sourceBlendAlpha;
    GLenum destBlendAlpha;
    GLenum blendEquationRGB;
    GLenum blendEquationAlpha;

    bool colorMaskRed;
    bool colorMaskGreen;
    bool colorMaskBlue;
    bool colorMaskAlpha;

    bool sampleAlphaToCoverage;

    bool dither;
};

struct DepthStencilState
{
    bool depthTest;
    GLenum depthFunc;
    bool depthMask;

    bool stencilTest;
    GLenum stencilFunc;
    GLuint stencilMask;
    GLenum stencilFail;
    GLenum stencilPassDepthFail;
    GLenum stencilPassDepthPass;
    GLuint stencilWritemask;
    GLenum stencilBackFunc;
    GLuint stencilBackMask;
    GLenum stencilBackFail;
    GLenum stencilBackPassDepthFail;
    GLenum stencilBackPassDepthPass;
    GLuint stencilBackWritemask;
};

// State from Table 6.10 (state per sampler object)
struct SamplerState
{
    SamplerState();
    static SamplerState CreateDefaultForTarget(GLenum target);

    GLenum minFilter;
    GLenum magFilter;

    GLenum wrapS;
    GLenum wrapT;
    GLenum wrapR;

    // From EXT_texture_filter_anisotropic
    float maxAnisotropy;

    GLfloat minLod;
    GLfloat maxLod;

    GLenum compareMode;
    GLenum compareFunc;

    GLenum sRGBDecode;
};

bool operator==(const SamplerState &a, const SamplerState &b);
bool operator!=(const SamplerState &a, const SamplerState &b);

struct PixelStoreStateBase
{
    BindingPointer<Buffer> pixelBuffer;
    GLint alignment   = 4;
    GLint rowLength   = 0;
    GLint skipRows    = 0;
    GLint skipPixels  = 0;
    GLint imageHeight = 0;
    GLint skipImages  = 0;
};

struct PixelUnpackState : PixelStoreStateBase
{
    PixelUnpackState() {}

    PixelUnpackState(GLint alignmentIn, GLint rowLengthIn)
    {
        alignment = alignmentIn;
        rowLength = rowLengthIn;
    }
};

struct PixelPackState : PixelStoreStateBase
{
    PixelPackState() {}

    PixelPackState(GLint alignmentIn, bool reverseRowOrderIn)
        : reverseRowOrder(reverseRowOrderIn)
    {
        alignment = alignmentIn;
    }

    bool reverseRowOrder = false;
};

// Used in Program and VertexArray.
typedef std::bitset<MAX_VERTEX_ATTRIBS> AttributesMask;

// Use in Program
typedef std::bitset<IMPLEMENTATION_MAX_COMBINED_SHADER_UNIFORM_BUFFERS> UniformBlockBindingMask;

// A map of GL objects indexed by object ID. The specific map implementation may change.
// Client code should treat it as a std::map.
template <class ResourceT>
using ResourceMap = std::unordered_map<GLuint, ResourceT *>;
}

namespace rx
{
// A macro that determines whether an object has a given runtime type.
#if defined(__clang__)
#if __has_feature(cxx_rtti)
#define ANGLE_HAS_DYNAMIC_CAST 1
#endif
#elif !defined(NDEBUG) && (!defined(_MSC_VER) || defined(_CPPRTTI)) && (!defined(__GNUC__) || __GNUC__ < 4 || (__GNUC__ == 4 && __GNUC_MINOR__ < 3) || defined(__GXX_RTTI))
#define ANGLE_HAS_DYNAMIC_CAST 1
#endif

#ifdef ANGLE_HAS_DYNAMIC_CAST
#define ANGLE_HAS_DYNAMIC_TYPE(type, obj) (dynamic_cast<type >(obj) != nullptr)
#undef ANGLE_HAS_DYNAMIC_CAST
#else
#define ANGLE_HAS_DYNAMIC_TYPE(type, obj) (obj != nullptr)
#endif

// Downcast a base implementation object (EG TextureImpl to TextureD3D)
template <typename DestT, typename SrcT>
inline DestT *GetAs(SrcT *src)
{
    ASSERT(ANGLE_HAS_DYNAMIC_TYPE(DestT*, src));
    return static_cast<DestT*>(src);
}

template <typename DestT, typename SrcT>
inline const DestT *GetAs(const SrcT *src)
{
    ASSERT(ANGLE_HAS_DYNAMIC_TYPE(const DestT*, src));
    return static_cast<const DestT*>(src);
}

#undef ANGLE_HAS_DYNAMIC_TYPE

// Downcast a GL object to an Impl (EG gl::Texture to rx::TextureD3D)
template <typename DestT, typename SrcT>
inline DestT *GetImplAs(SrcT *src)
{
    return GetAs<DestT>(src->getImplementation());
}

}

#include "angletypes.inl"

namespace angle
{
// Zero-based for better array indexing
enum FramebufferBinding
{
    FramebufferBindingRead = 0,
    FramebufferBindingDraw,
    FramebufferBindingSingletonMax,
    FramebufferBindingBoth = FramebufferBindingSingletonMax,
    FramebufferBindingMax,
    FramebufferBindingUnknown = FramebufferBindingMax,
};

inline FramebufferBinding EnumToFramebufferBinding(GLenum enumValue)
{
    switch (enumValue)
    {
        case GL_READ_FRAMEBUFFER:
            return FramebufferBindingRead;
        case GL_DRAW_FRAMEBUFFER:
            return FramebufferBindingDraw;
        case GL_FRAMEBUFFER:
            return FramebufferBindingBoth;
        default:
            UNREACHABLE();
            return FramebufferBindingUnknown;
    }
}

inline GLenum FramebufferBindingToEnum(FramebufferBinding binding)
{
    switch (binding)
    {
        case FramebufferBindingRead:
            return GL_READ_FRAMEBUFFER;
        case FramebufferBindingDraw:
            return GL_DRAW_FRAMEBUFFER;
        case FramebufferBindingBoth:
            return GL_FRAMEBUFFER;
        default:
            UNREACHABLE();
            return GL_NONE;
    }
}
}  // namespace angle

namespace gl
{
class ContextState;
}  // namespace gl

#endif // LIBANGLE_ANGLETYPES_H_
