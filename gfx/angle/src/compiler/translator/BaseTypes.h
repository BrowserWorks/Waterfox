//
// Copyright (c) 2002-2013 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//

#ifndef COMPILER_TRANSLATOR_BASETYPES_H_
#define COMPILER_TRANSLATOR_BASETYPES_H_

#include <algorithm>
#include <array>

#include "common/debug.h"
#include "GLSLANG/ShaderLang.h"

namespace sh
{

//
// Precision qualifiers
//
enum TPrecision
{
    // These need to be kept sorted
    EbpUndefined,
    EbpLow,
    EbpMedium,
    EbpHigh,

    // end of list
    EbpLast
};

inline const char* getPrecisionString(TPrecision p)
{
    switch(p)
    {
        case EbpHigh:   return "highp";
        case EbpMedium: return "mediump";
        case EbpLow:    return "lowp";
        default:        return "mediump";  // Safest fallback
    }
}

//
// Basic type.  Arrays, vectors, etc., are orthogonal to this.
//
enum TBasicType
{
    EbtVoid,
    EbtFloat,
    EbtInt,
    EbtUInt,
    EbtBool,
    EbtGVec4,              // non type: represents vec4, ivec4, and uvec4
    EbtGenType,            // non type: represents float, vec2, vec3, and vec4
    EbtGenIType,           // non type: represents int, ivec2, ivec3, and ivec4
    EbtGenUType,           // non type: represents uint, uvec2, uvec3, and uvec4
    EbtGenBType,           // non type: represents bool, bvec2, bvec3, and bvec4
    EbtVec,                // non type: represents vec2, vec3, and vec4
    EbtIVec,               // non type: represents ivec2, ivec3, and ivec4
    EbtUVec,               // non type: represents uvec2, uvec3, and uvec4
    EbtBVec,               // non type: represents bvec2, bvec3, and bvec4
    EbtGuardSamplerBegin,  // non type: see implementation of IsSampler()
    EbtSampler2D,
    EbtSampler3D,
    EbtSamplerCube,
    EbtSampler2DArray,
    EbtSamplerExternalOES,  // Only valid if OES_EGL_image_external exists.
    EbtSampler2DRect,       // Only valid if GL_ARB_texture_rectangle exists.
    EbtISampler2D,
    EbtISampler3D,
    EbtISamplerCube,
    EbtISampler2DArray,
    EbtUSampler2D,
    EbtUSampler3D,
    EbtUSamplerCube,
    EbtUSampler2DArray,
    EbtSampler2DShadow,
    EbtSamplerCubeShadow,
    EbtSampler2DArrayShadow,
    EbtGuardSamplerEnd,  // non type: see implementation of IsSampler()
    EbtGSampler2D,       // non type: represents sampler2D, isampler2D, and usampler2D
    EbtGSampler3D,       // non type: represents sampler3D, isampler3D, and usampler3D
    EbtGSamplerCube,     // non type: represents samplerCube, isamplerCube, and usamplerCube
    EbtGSampler2DArray,  // non type: represents sampler2DArray, isampler2DArray, and
                         // usampler2DArray

    // images
    EbtGuardImageBegin,
    EbtImage2D,
    EbtIImage2D,
    EbtUImage2D,
    EbtImage3D,
    EbtIImage3D,
    EbtUImage3D,
    EbtImage2DArray,
    EbtIImage2DArray,
    EbtUImage2DArray,
    EbtImageCube,
    EbtIImageCube,
    EbtUImageCube,
    EbtGuardImageEnd,

    EbtGuardGImageBegin,
    EbtGImage2D,       // non type: represents image2D, uimage2D, iimage2D
    EbtGImage3D,       // non type: represents image3D, uimage3D, iimage3D
    EbtGImage2DArray,  // non type: represents image2DArray, uimage2DArray, iimage2DArray
    EbtGImageCube,     // non type: represents imageCube, uimageCube, iimageCube
    EbtGuardGImageEnd,

    EbtStruct,
    EbtInterfaceBlock,
    EbtAddress,  // should be deprecated??

    // end of list
    EbtLast
};

inline TBasicType convertGImageToFloatImage(TBasicType type)
{
    switch (type)
    {
        case EbtGImage2D:
            return EbtImage2D;
        case EbtGImage3D:
            return EbtImage3D;
        case EbtGImage2DArray:
            return EbtImage2DArray;
        case EbtGImageCube:
            return EbtImageCube;
        default:
            UNREACHABLE();
    }
    return EbtLast;
}

inline TBasicType convertGImageToIntImage(TBasicType type)
{
    switch (type)
    {
        case EbtGImage2D:
            return EbtIImage2D;
        case EbtGImage3D:
            return EbtIImage3D;
        case EbtGImage2DArray:
            return EbtIImage2DArray;
        case EbtGImageCube:
            return EbtIImageCube;
        default:
            UNREACHABLE();
    }
    return EbtLast;
}

inline TBasicType convertGImageToUnsignedImage(TBasicType type)
{
    switch (type)
    {
        case EbtGImage2D:
            return EbtUImage2D;
        case EbtGImage3D:
            return EbtUImage3D;
        case EbtGImage2DArray:
            return EbtUImage2DArray;
        case EbtGImageCube:
            return EbtUImageCube;
        default:
            UNREACHABLE();
    }
    return EbtLast;
}

const char* getBasicString(TBasicType t);

inline bool IsSampler(TBasicType type)
{
    return type > EbtGuardSamplerBegin && type < EbtGuardSamplerEnd;
}

inline bool IsImage(TBasicType type)
{
    return type > EbtGuardImageBegin && type < EbtGuardImageEnd;
}

inline bool IsGImage(TBasicType type)
{
    return type > EbtGuardGImageBegin && type < EbtGuardGImageEnd;
}

inline bool IsOpaqueType(TBasicType type)
{
    // TODO (mradev): add atomic types as opaque.
    return IsSampler(type) || IsImage(type);
}

inline bool IsIntegerSampler(TBasicType type)
{
    switch (type)
    {
      case EbtISampler2D:
      case EbtISampler3D:
      case EbtISamplerCube:
      case EbtISampler2DArray:
      case EbtUSampler2D:
      case EbtUSampler3D:
      case EbtUSamplerCube:
      case EbtUSampler2DArray:
        return true;
      case EbtSampler2D:
      case EbtSampler3D:
      case EbtSamplerCube:
      case EbtSamplerExternalOES:
      case EbtSampler2DRect:
      case EbtSampler2DArray:
      case EbtSampler2DShadow:
      case EbtSamplerCubeShadow:
      case EbtSampler2DArrayShadow:
        return false;
      default:
        assert(!IsSampler(type));
    }

    return false;
}

inline bool IsFloatImage(TBasicType type)
{
    switch (type)
    {
        case EbtImage2D:
        case EbtImage3D:
        case EbtImage2DArray:
        case EbtImageCube:
            return true;
        default:
            break;
    }

    return false;
}

inline bool IsIntegerImage(TBasicType type)
{

    switch (type)
    {
        case EbtIImage2D:
        case EbtIImage3D:
        case EbtIImage2DArray:
        case EbtIImageCube:
            return true;
        default:
            break;
    }

    return false;
}

inline bool IsUnsignedImage(TBasicType type)
{

    switch (type)
    {
        case EbtUImage2D:
        case EbtUImage3D:
        case EbtUImage2DArray:
        case EbtUImageCube:
            return true;
        default:
            break;
    }

    return false;
}

inline bool IsSampler2D(TBasicType type)
{
    switch (type)
    {
      case EbtSampler2D:
      case EbtISampler2D:
      case EbtUSampler2D:
      case EbtSampler2DArray:
      case EbtISampler2DArray:
      case EbtUSampler2DArray:
      case EbtSampler2DRect:
      case EbtSamplerExternalOES:
      case EbtSampler2DShadow:
      case EbtSampler2DArrayShadow:
        return true;
      case EbtSampler3D:
      case EbtISampler3D:
      case EbtUSampler3D:
      case EbtISamplerCube:
      case EbtUSamplerCube:
      case EbtSamplerCube:
      case EbtSamplerCubeShadow:
        return false;
      default:
        assert(!IsSampler(type));
    }

    return false;
}

inline bool IsSamplerCube(TBasicType type)
{
    switch (type)
    {
      case EbtSamplerCube:
      case EbtISamplerCube:
      case EbtUSamplerCube:
      case EbtSamplerCubeShadow:
        return true;
      case EbtSampler2D:
      case EbtSampler3D:
      case EbtSamplerExternalOES:
      case EbtSampler2DRect:
      case EbtSampler2DArray:
      case EbtISampler2D:
      case EbtISampler3D:
      case EbtISampler2DArray:
      case EbtUSampler2D:
      case EbtUSampler3D:
      case EbtUSampler2DArray:
      case EbtSampler2DShadow:
      case EbtSampler2DArrayShadow:
        return false;
      default:
        assert(!IsSampler(type));
    }

    return false;
}

inline bool IsSampler3D(TBasicType type)
{
    switch (type)
    {
      case EbtSampler3D:
      case EbtISampler3D:
      case EbtUSampler3D:
        return true;
      case EbtSampler2D:
      case EbtSamplerCube:
      case EbtSamplerExternalOES:
      case EbtSampler2DRect:
      case EbtSampler2DArray:
      case EbtISampler2D:
      case EbtISamplerCube:
      case EbtISampler2DArray:
      case EbtUSampler2D:
      case EbtUSamplerCube:
      case EbtUSampler2DArray:
      case EbtSampler2DShadow:
      case EbtSamplerCubeShadow:
      case EbtSampler2DArrayShadow:
        return false;
      default:
        assert(!IsSampler(type));
    }

    return false;
}

inline bool IsSamplerArray(TBasicType type)
{
    switch (type)
    {
      case EbtSampler2DArray:
      case EbtISampler2DArray:
      case EbtUSampler2DArray:
      case EbtSampler2DArrayShadow:
        return true;
      case EbtSampler2D:
      case EbtISampler2D:
      case EbtUSampler2D:
      case EbtSampler2DRect:
      case EbtSamplerExternalOES:
      case EbtSampler3D:
      case EbtISampler3D:
      case EbtUSampler3D:
      case EbtISamplerCube:
      case EbtUSamplerCube:
      case EbtSamplerCube:
      case EbtSampler2DShadow:
      case EbtSamplerCubeShadow:
        return false;
      default:
        assert(!IsSampler(type));
    }

    return false;
}

inline bool IsShadowSampler(TBasicType type)
{
    switch (type)
    {
      case EbtSampler2DShadow:
      case EbtSamplerCubeShadow:
      case EbtSampler2DArrayShadow:
        return true;
      case EbtISampler2D:
      case EbtISampler3D:
      case EbtISamplerCube:
      case EbtISampler2DArray:
      case EbtUSampler2D:
      case EbtUSampler3D:
      case EbtUSamplerCube:
      case EbtUSampler2DArray:
      case EbtSampler2D:
      case EbtSampler3D:
      case EbtSamplerCube:
      case EbtSamplerExternalOES:
      case EbtSampler2DRect:
      case EbtSampler2DArray:
        return false;
      default:
        assert(!IsSampler(type));
    }

    return false;
}

inline bool IsInteger(TBasicType type)
{
    return type == EbtInt || type == EbtUInt;
}

inline bool SupportsPrecision(TBasicType type)
{
    return type == EbtFloat || type == EbtInt || type == EbtUInt || IsOpaqueType(type);
}

//
// Qualifiers and built-ins.  These are mainly used to see what can be read
// or written, and by the machine dependent translator to know which registers
// to allocate variables in.  Since built-ins tend to go to different registers
// than varying or uniform, it makes sense they are peers, not sub-classes.
//
enum TQualifier
{
    EvqTemporary,   // For temporaries (within a function), read/write
    EvqGlobal,      // For globals read/write
    EvqConst,       // User defined constants and non-output parameters in functions
    EvqAttribute,   // Readonly
    EvqVaryingIn,   // readonly, fragment shaders only
    EvqVaryingOut,  // vertex shaders only  read/write
    EvqUniform,     // Readonly, vertex and fragment

    EvqVertexIn,     // Vertex shader input
    EvqFragmentOut,  // Fragment shader output
    EvqVertexOut,    // Vertex shader output
    EvqFragmentIn,   // Fragment shader input

    // parameters
    EvqIn,
    EvqOut,
    EvqInOut,
    EvqConstReadOnly,

    // built-ins read by vertex shader
    EvqInstanceID,
    EvqVertexID,

    // built-ins written by vertex shader
    EvqPosition,
    EvqPointSize,

    // built-ins read by fragment shader
    EvqFragCoord,
    EvqFrontFacing,
    EvqPointCoord,

    // built-ins written by fragment shader
    EvqFragColor,
    EvqFragData,

    EvqFragDepth,     // gl_FragDepth for ESSL300.
    EvqFragDepthEXT,  // gl_FragDepthEXT for ESSL100, EXT_frag_depth.

    EvqSecondaryFragColorEXT,  // EXT_blend_func_extended
    EvqSecondaryFragDataEXT,   // EXT_blend_func_extended

    // built-ins written by the shader_framebuffer_fetch extension(s)
    EvqLastFragColor,
    EvqLastFragData,

    // GLSL ES 3.0 vertex output and fragment input
    EvqSmooth,    // Incomplete qualifier, smooth is the default
    EvqFlat,      // Incomplete qualifier
    EvqCentroid,  // Incomplete qualifier
    EvqSmoothOut,
    EvqFlatOut,
    EvqCentroidOut,  // Implies smooth
    EvqSmoothIn,
    EvqFlatIn,
    EvqCentroidIn,  // Implies smooth

    // GLSL ES 3.1 compute shader special variables
    EvqComputeIn,
    EvqNumWorkGroups,
    EvqWorkGroupSize,
    EvqWorkGroupID,
    EvqLocalInvocationID,
    EvqGlobalInvocationID,
    EvqLocalInvocationIndex,

    // GLSL ES 3.1 memory qualifiers
    EvqReadOnly,
    EvqWriteOnly,
    EvqCoherent,
    EvqRestrict,
    EvqVolatile,

    // end of list
    EvqLast
};

inline bool IsQualifierUnspecified(TQualifier qualifier)
{
    return (qualifier == EvqTemporary || qualifier == EvqGlobal);
}

enum TLayoutImageInternalFormat
{
    EiifUnspecified,
    EiifRGBA32F,
    EiifRGBA16F,
    EiifR32F,
    EiifRGBA32UI,
    EiifRGBA16UI,
    EiifRGBA8UI,
    EiifR32UI,
    EiifRGBA32I,
    EiifRGBA16I,
    EiifRGBA8I,
    EiifR32I,
    EiifRGBA8,
    EiifRGBA8_SNORM
};

enum TLayoutMatrixPacking
{
    EmpUnspecified,
    EmpRowMajor,
    EmpColumnMajor
};

enum TLayoutBlockStorage
{
    EbsUnspecified,
    EbsShared,
    EbsPacked,
    EbsStd140
};

struct TLayoutQualifier
{
    int location;
    unsigned int locationsSpecified;
    TLayoutMatrixPacking matrixPacking;
    TLayoutBlockStorage blockStorage;

    // Compute shader layout qualifiers.
    sh::WorkGroupSize localSize;

    // Image format layout qualifier
    TLayoutImageInternalFormat imageInternalFormat;

    static TLayoutQualifier create()
    {
        TLayoutQualifier layoutQualifier;

        layoutQualifier.location = -1;
        layoutQualifier.locationsSpecified = 0;
        layoutQualifier.matrixPacking = EmpUnspecified;
        layoutQualifier.blockStorage = EbsUnspecified;

        layoutQualifier.localSize.fill(-1);

        layoutQualifier.imageInternalFormat = EiifUnspecified;
        return layoutQualifier;
    }

    bool isEmpty() const
    {
        return location == -1 && matrixPacking == EmpUnspecified &&
               blockStorage == EbsUnspecified && !localSize.isAnyValueSet() &&
               imageInternalFormat == EiifUnspecified;
    }

    bool isCombinationValid() const
    {
        bool workSizeSpecified = localSize.isAnyValueSet();
        bool otherLayoutQualifiersSpecified =
            (location != -1 || matrixPacking != EmpUnspecified || blockStorage != EbsUnspecified ||
             imageInternalFormat != EiifUnspecified);

        // we can have either the work group size specified, or the other layout qualifiers
        return !(workSizeSpecified && otherLayoutQualifiersSpecified);
    }

    bool isLocalSizeEqual(const sh::WorkGroupSize &localSizeIn) const
    {
        return localSize.isWorkGroupSizeMatching(localSizeIn);
    }
};

struct TMemoryQualifier
{
    // GLSL ES 3.10 Revision 4, 4.9 Memory Access Qualifiers
    // An image can be qualified as both readonly and writeonly. It still can be can be used with
    // imageSize().
    bool readonly;
    bool writeonly;
    bool coherent;

    // restrict and volatile are reserved keywords in C/C++
    bool restrictQualifier;
    bool volatileQualifier;
    static TMemoryQualifier create()
    {
        TMemoryQualifier memoryQualifier;

        memoryQualifier.readonly          = false;
        memoryQualifier.writeonly         = false;
        memoryQualifier.coherent          = false;
        memoryQualifier.restrictQualifier = false;
        memoryQualifier.volatileQualifier = false;

        return memoryQualifier;
    }

    bool isEmpty()
    {
        return !readonly && !writeonly && !coherent && !restrictQualifier && !volatileQualifier;
    }
};

inline const char *getWorkGroupSizeString(size_t dimension)
{
    switch (dimension)
    {
        case 0u:
            return "local_size_x";
        case 1u:
            return "local_size_y";
        case 2u:
            return "local_size_z";
        default:
            UNREACHABLE();
            return "dimension out of bounds";
    }
}

//
// This is just for debug print out, carried along with the definitions above.
//
inline const char* getQualifierString(TQualifier q)
{
    // clang-format off
    switch(q)
    {
    case EvqTemporary:              return "Temporary";
    case EvqGlobal:                 return "Global";
    case EvqConst:                  return "const";
    case EvqAttribute:              return "attribute";
    case EvqVaryingIn:              return "varying";
    case EvqVaryingOut:             return "varying";
    case EvqUniform:                return "uniform";
    case EvqVertexIn:               return "in";
    case EvqFragmentOut:            return "out";
    case EvqVertexOut:              return "out";
    case EvqFragmentIn:             return "in";
    case EvqIn:                     return "in";
    case EvqOut:                    return "out";
    case EvqInOut:                  return "inout";
    case EvqConstReadOnly:          return "const";
    case EvqInstanceID:             return "InstanceID";
    case EvqVertexID:               return "VertexID";
    case EvqPosition:               return "Position";
    case EvqPointSize:              return "PointSize";
    case EvqFragCoord:              return "FragCoord";
    case EvqFrontFacing:            return "FrontFacing";
    case EvqPointCoord:             return "PointCoord";
    case EvqFragColor:              return "FragColor";
    case EvqFragData:               return "FragData";
    case EvqFragDepthEXT:           return "FragDepth";
    case EvqFragDepth:              return "FragDepth";
    case EvqSecondaryFragColorEXT:  return "SecondaryFragColorEXT";
    case EvqSecondaryFragDataEXT:   return "SecondaryFragDataEXT";
    case EvqLastFragColor:          return "LastFragColor";
    case EvqLastFragData:           return "LastFragData";
    case EvqSmoothOut:              return "smooth out";
    case EvqCentroidOut:            return "smooth centroid out";
    case EvqFlatOut:                return "flat out";
    case EvqSmoothIn:               return "smooth in";
    case EvqFlatIn:                 return "flat in";
    case EvqCentroidIn:             return "smooth centroid in";
    case EvqCentroid:               return "centroid";
    case EvqFlat:                   return "flat";
    case EvqSmooth:                 return "smooth";
    case EvqComputeIn:              return "in";
    case EvqNumWorkGroups:          return "NumWorkGroups";
    case EvqWorkGroupSize:          return "WorkGroupSize";
    case EvqWorkGroupID:            return "WorkGroupID";
    case EvqLocalInvocationID:      return "LocalInvocationID";
    case EvqGlobalInvocationID:     return "GlobalInvocationID";
    case EvqLocalInvocationIndex:   return "LocalInvocationIndex";
    case EvqReadOnly:               return "readonly";
    case EvqWriteOnly:              return "writeonly";
    default: UNREACHABLE();         return "unknown qualifier";
    }
    // clang-format on
}

inline const char* getMatrixPackingString(TLayoutMatrixPacking mpq)
{
    switch (mpq)
    {
    case EmpUnspecified:    return "mp_unspecified";
    case EmpRowMajor:       return "row_major";
    case EmpColumnMajor:    return "column_major";
    default: UNREACHABLE(); return "unknown matrix packing";
    }
}

inline const char* getBlockStorageString(TLayoutBlockStorage bsq)
{
    switch (bsq)
    {
    case EbsUnspecified:    return "bs_unspecified";
    case EbsShared:         return "shared";
    case EbsPacked:         return "packed";
    case EbsStd140:         return "std140";
    default: UNREACHABLE(); return "unknown block storage";
    }
}

inline const char *getImageInternalFormatString(TLayoutImageInternalFormat iifq)
{
    switch (iifq)
    {
        case EiifRGBA32F:
            return "rgba32f";
        case EiifRGBA16F:
            return "rgba16f";
        case EiifR32F:
            return "r32f";
        case EiifRGBA32UI:
            return "rgba32ui";
        case EiifRGBA16UI:
            return "rgba16ui";
        case EiifRGBA8UI:
            return "rgba8ui";
        case EiifR32UI:
            return "r32ui";
        case EiifRGBA32I:
            return "rgba32i";
        case EiifRGBA16I:
            return "rgba16i";
        case EiifRGBA8I:
            return "rgba8i";
        case EiifR32I:
            return "r32i";
        case EiifRGBA8:
            return "rgba8";
        case EiifRGBA8_SNORM:
            return "rgba8_snorm";
        default:
            UNREACHABLE();
            return "unknown internal image format";
    }
}

}  // namespace sh

#endif // COMPILER_TRANSLATOR_BASETYPES_H_
