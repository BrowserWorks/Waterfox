//
// Copyright (c) 2014 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// UtilsHLSL.cpp:
//   Utility methods for GLSL to HLSL translation.
//

#include "compiler/translator/UtilsHLSL.h"
#include "compiler/translator/IntermNode.h"
#include "compiler/translator/StructureHLSL.h"
#include "compiler/translator/SymbolTable.h"

namespace sh
{

TString SamplerString(const TBasicType type)
{
    if (IsShadowSampler(type))
    {
        return "SamplerComparisonState";
    }
    else
    {
        return "SamplerState";
    }
}

TString SamplerString(HLSLTextureSamplerGroup type)
{
    if (type >= HLSL_COMPARISON_SAMPLER_GROUP_BEGIN && type <= HLSL_COMPARISON_SAMPLER_GROUP_END)
    {
        return "SamplerComparisonState";
    }
    else
    {
        return "SamplerState";
    }
}

HLSLTextureSamplerGroup TextureGroup(const TBasicType type)
{
    switch (type)
    {
        case EbtSampler2D:
            return HLSL_TEXTURE_2D;
        case EbtSamplerCube:
            return HLSL_TEXTURE_CUBE;
        case EbtSamplerExternalOES:
            return HLSL_TEXTURE_2D;
        case EbtSampler2DArray:
            return HLSL_TEXTURE_2D_ARRAY;
        case EbtSampler3D:
            return HLSL_TEXTURE_3D;
        case EbtISampler2D:
            return HLSL_TEXTURE_2D_INT4;
        case EbtISampler3D:
            return HLSL_TEXTURE_3D_INT4;
        case EbtISamplerCube:
            return HLSL_TEXTURE_2D_ARRAY_INT4;
        case EbtISampler2DArray:
            return HLSL_TEXTURE_2D_ARRAY_INT4;
        case EbtUSampler2D:
            return HLSL_TEXTURE_2D_UINT4;
        case EbtUSampler3D:
            return HLSL_TEXTURE_3D_UINT4;
        case EbtUSamplerCube:
            return HLSL_TEXTURE_2D_ARRAY_UINT4;
        case EbtUSampler2DArray:
            return HLSL_TEXTURE_2D_ARRAY_UINT4;
        case EbtSampler2DShadow:
            return HLSL_TEXTURE_2D_COMPARISON;
        case EbtSamplerCubeShadow:
            return HLSL_TEXTURE_CUBE_COMPARISON;
        case EbtSampler2DArrayShadow:
            return HLSL_TEXTURE_2D_ARRAY_COMPARISON;
        default:
            UNREACHABLE();
    }
    return HLSL_TEXTURE_UNKNOWN;
}

TString TextureString(const HLSLTextureSamplerGroup type)
{
    switch (type)
    {
        case HLSL_TEXTURE_2D:
            return "Texture2D";
        case HLSL_TEXTURE_CUBE:
            return "TextureCube";
        case HLSL_TEXTURE_2D_ARRAY:
            return "Texture2DArray";
        case HLSL_TEXTURE_3D:
            return "Texture3D";
        case HLSL_TEXTURE_2D_INT4:
            return "Texture2D<int4>";
        case HLSL_TEXTURE_3D_INT4:
            return "Texture3D<int4>";
        case HLSL_TEXTURE_2D_ARRAY_INT4:
            return "Texture2DArray<int4>";
        case HLSL_TEXTURE_2D_UINT4:
            return "Texture2D<uint4>";
        case HLSL_TEXTURE_3D_UINT4:
            return "Texture3D<uint4>";
        case HLSL_TEXTURE_2D_ARRAY_UINT4:
            return "Texture2DArray<uint4>";
        case HLSL_TEXTURE_2D_COMPARISON:
            return "Texture2D";
        case HLSL_TEXTURE_CUBE_COMPARISON:
            return "TextureCube";
        case HLSL_TEXTURE_2D_ARRAY_COMPARISON:
            return "Texture2DArray";
        default:
            UNREACHABLE();
    }

    return "<unknown texture type>";
}

TString TextureString(const TBasicType type)
{
    return TextureString(TextureGroup(type));
}

TString TextureGroupSuffix(const HLSLTextureSamplerGroup type)
{
    switch (type)
    {
        case HLSL_TEXTURE_2D:
            return "2D";
        case HLSL_TEXTURE_CUBE:
            return "Cube";
        case HLSL_TEXTURE_2D_ARRAY:
            return "2DArray";
        case HLSL_TEXTURE_3D:
            return "3D";
        case HLSL_TEXTURE_2D_INT4:
            return "2D_int4_";
        case HLSL_TEXTURE_3D_INT4:
            return "3D_int4_";
        case HLSL_TEXTURE_2D_ARRAY_INT4:
            return "2DArray_int4_";
        case HLSL_TEXTURE_2D_UINT4:
            return "2D_uint4_";
        case HLSL_TEXTURE_3D_UINT4:
            return "3D_uint4_";
        case HLSL_TEXTURE_2D_ARRAY_UINT4:
            return "2DArray_uint4_";
        case HLSL_TEXTURE_2D_COMPARISON:
            return "2D_comparison";
        case HLSL_TEXTURE_CUBE_COMPARISON:
            return "Cube_comparison";
        case HLSL_TEXTURE_2D_ARRAY_COMPARISON:
            return "2DArray_comparison";
        default:
            UNREACHABLE();
    }

    return "<unknown texture type>";
}

TString TextureGroupSuffix(const TBasicType type)
{
    return TextureGroupSuffix(TextureGroup(type));
}

TString TextureTypeSuffix(const TBasicType type)
{
    switch (type)
    {
        case EbtISamplerCube:
            return "Cube_int4_";
        case EbtUSamplerCube:
            return "Cube_uint4_";
        case EbtSamplerExternalOES:
            return "_External";
        default:
            // All other types are identified by their group suffix
            return TextureGroupSuffix(type);
    }
}

TString DecorateUniform(const TName &name, const TType &type)
{
    return DecorateIfNeeded(name);
}

TString DecorateField(const TString &string, const TStructure &structure)
{
    if (structure.name().compare(0, 3, "gl_") != 0)
    {
        return Decorate(string);
    }

    return string;
}

TString DecoratePrivate(const TString &privateText)
{
    return "dx_" + privateText;
}

TString Decorate(const TString &string)
{
    if (string.compare(0, 3, "gl_") != 0)
    {
        return "_" + string;
    }

    return string;
}

TString DecorateIfNeeded(const TName &name)
{
    if (name.isInternal())
    {
        return name.getString();
    }
    else
    {
        return Decorate(name.getString());
    }
}

TString DecorateFunctionIfNeeded(const TName &name)
{
    if (name.isInternal())
    {
        return TFunction::unmangleName(name.getString());
    }
    else
    {
        return Decorate(TFunction::unmangleName(name.getString()));
    }
}

TString TypeString(const TType &type)
{
    const TStructure* structure = type.getStruct();
    if (structure)
    {
        const TString& typeName = structure->name();
        if (typeName != "")
        {
            return StructNameString(*structure);
        }
        else   // Nameless structure, define in place
        {
            return StructureHLSL::defineNameless(*structure);
        }
    }
    else if (type.isMatrix())
    {
        int cols = type.getCols();
        int rows = type.getRows();
        return "float" + str(cols) + "x" + str(rows);
    }
    else
    {
        switch (type.getBasicType())
        {
          case EbtFloat:
            switch (type.getNominalSize())
            {
              case 1: return "float";
              case 2: return "float2";
              case 3: return "float3";
              case 4: return "float4";
            }
          case EbtInt:
            switch (type.getNominalSize())
            {
              case 1: return "int";
              case 2: return "int2";
              case 3: return "int3";
              case 4: return "int4";
            }
          case EbtUInt:
            switch (type.getNominalSize())
            {
              case 1: return "uint";
              case 2: return "uint2";
              case 3: return "uint3";
              case 4: return "uint4";
            }
          case EbtBool:
            switch (type.getNominalSize())
            {
              case 1: return "bool";
              case 2: return "bool2";
              case 3: return "bool3";
              case 4: return "bool4";
            }
          case EbtVoid:
            return "void";
          case EbtSampler2D:
          case EbtISampler2D:
          case EbtUSampler2D:
          case EbtSampler2DArray:
          case EbtISampler2DArray:
          case EbtUSampler2DArray:
            return "sampler2D";
          case EbtSamplerCube:
          case EbtISamplerCube:
          case EbtUSamplerCube:
            return "samplerCUBE";
          case EbtSamplerExternalOES:
            return "sampler2D";
          default:
            break;
        }
    }

    UNREACHABLE();
    return "<unknown type>";
}

TString StructNameString(const TStructure &structure)
{
    if (structure.name().empty())
    {
        return "";
    }

    // For structures at global scope we use a consistent
    // translation so that we can link between shader stages.
    if (structure.atGlobalScope())
    {
        return Decorate(structure.name());
    }

    return "ss" + str(structure.uniqueId()) + "_" + structure.name();
}

TString QualifiedStructNameString(const TStructure &structure, bool useHLSLRowMajorPacking,
                                  bool useStd140Packing)
{
    if (structure.name() == "")
    {
        return "";
    }

    TString prefix = "";

    // Structs packed with row-major matrices in HLSL are prefixed with "rm"
    // GLSL column-major maps to HLSL row-major, and the converse is true

    if (useStd140Packing)
    {
        prefix += "std_";
    }

    if (useHLSLRowMajorPacking)
    {
        prefix += "rm_";
    }

    return prefix + StructNameString(structure);
}

TString InterpolationString(TQualifier qualifier)
{
    switch (qualifier)
    {
      case EvqVaryingIn:           return "";
      case EvqFragmentIn:          return "";
      case EvqSmoothIn:            return "linear";
      case EvqFlatIn:              return "nointerpolation";
      case EvqCentroidIn:          return "centroid";
      case EvqVaryingOut:          return "";
      case EvqVertexOut:           return "";
      case EvqSmoothOut:           return "linear";
      case EvqFlatOut:             return "nointerpolation";
      case EvqCentroidOut:         return "centroid";
      default: UNREACHABLE();
    }

    return "";
}

TString QualifierString(TQualifier qualifier)
{
    switch (qualifier)
    {
      case EvqIn:            return "in";
      case EvqOut:           return "inout"; // 'out' results in an HLSL error if not all fields are written, for GLSL it's undefined
      case EvqInOut:         return "inout";
      case EvqConstReadOnly: return "const";
      default: UNREACHABLE();
    }

    return "";
}

TString DisambiguateFunctionName(const TIntermSequence *parameters)
{
    TString disambiguatingString;
    for (auto parameter : *parameters)
    {
        const TType &paramType = parameter->getAsTyped()->getType();
        // Disambiguation is needed for float2x2 and float4 parameters. These are the only parameter
        // types that HLSL thinks are identical. float2x3 and float3x2 are different types, for
        // example. Other parameter types are not added to function names to avoid making function
        // names longer.
        if (paramType.getObjectSize() == 4 && paramType.getBasicType() == EbtFloat)
        {
            disambiguatingString += "_" + TypeString(paramType);
        }
    }
    return disambiguatingString;
}

}  // namespace sh
