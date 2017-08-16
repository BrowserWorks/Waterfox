//
// Copyright (c) 2002-2013 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//

//
// Implement the top-level of interface to the compiler,
// as defined in ShaderLang.h
//

#include "GLSLANG/ShaderLang.h"

#include "compiler/translator/Compiler.h"
#include "compiler/translator/InitializeDll.h"
#include "compiler/translator/length_limits.h"
#ifdef ANGLE_ENABLE_HLSL
#include "compiler/translator/TranslatorHLSL.h"
#endif // ANGLE_ENABLE_HLSL
#include "compiler/translator/VariablePacker.h"
#include "angle_gl.h"

using namespace sh;

namespace
{

bool isInitialized = false;

//
// This is the platform independent interface between an OGL driver
// and the shading language compiler.
//

template <typename VarT>
const std::vector<VarT> *GetVariableList(const TCompiler *compiler);

template <>
const std::vector<Uniform> *GetVariableList(const TCompiler *compiler)
{
    return &compiler->getUniforms();
}

template <>
const std::vector<Varying> *GetVariableList(const TCompiler *compiler)
{
    return &compiler->getVaryings();
}

template <>
const std::vector<Attribute> *GetVariableList(const TCompiler *compiler)
{
    return &compiler->getAttributes();
}

template <>
const std::vector<OutputVariable> *GetVariableList(const TCompiler *compiler)
{
    return &compiler->getOutputVariables();
}

template <>
const std::vector<InterfaceBlock> *GetVariableList(const TCompiler *compiler)
{
    return &compiler->getInterfaceBlocks();
}

template <typename VarT>
const std::vector<VarT> *GetShaderVariables(const ShHandle handle)
{
    if (!handle)
    {
        return NULL;
    }

    TShHandleBase* base = static_cast<TShHandleBase*>(handle);
    TCompiler* compiler = base->getAsCompiler();
    if (!compiler)
    {
        return NULL;
    }

    return GetVariableList<VarT>(compiler);
}

TCompiler *GetCompilerFromHandle(ShHandle handle)
{
    if (!handle)
        return NULL;
    TShHandleBase *base = static_cast<TShHandleBase *>(handle);
    return base->getAsCompiler();
}

#ifdef ANGLE_ENABLE_HLSL
TranslatorHLSL *GetTranslatorHLSLFromHandle(ShHandle handle)
{
    if (!handle)
        return NULL;
    TShHandleBase *base = static_cast<TShHandleBase *>(handle);
    return base->getAsTranslatorHLSL();
}
#endif // ANGLE_ENABLE_HLSL

}  // anonymous namespace

//
// Driver must call this first, once, before doing any other compiler operations.
// Subsequent calls to this function are no-op.
//
bool ShInitialize()
{
    if (!isInitialized)
    {
        isInitialized = InitProcess();
    }
    return isInitialized;
}

//
// Cleanup symbol tables
//
bool ShFinalize()
{
    if (isInitialized)
    {
        DetachProcess();
        isInitialized = false;
    }
    return true;
}

//
// Initialize built-in resources with minimum expected values.
//
void ShInitBuiltInResources(ShBuiltInResources* resources)
{
    // Make comparable.
    memset(resources, 0, sizeof(*resources));

    // Constants.
    resources->MaxVertexAttribs = 8;
    resources->MaxVertexUniformVectors = 128;
    resources->MaxVaryingVectors = 8;
    resources->MaxVertexTextureImageUnits = 0;
    resources->MaxCombinedTextureImageUnits = 8;
    resources->MaxTextureImageUnits = 8;
    resources->MaxFragmentUniformVectors = 16;
    resources->MaxDrawBuffers = 1;

    // Extensions.
    resources->OES_standard_derivatives = 0;
    resources->OES_EGL_image_external = 0;
    resources->OES_EGL_image_external_essl3    = 0;
    resources->NV_EGL_stream_consumer_external = 0;
    resources->ARB_texture_rectangle = 0;
    resources->EXT_blend_func_extended      = 0;
    resources->EXT_draw_buffers = 0;
    resources->EXT_frag_depth = 0;
    resources->EXT_shader_texture_lod = 0;
    resources->WEBGL_debug_shader_precision = 0;
    resources->EXT_shader_framebuffer_fetch = 0;
    resources->NV_shader_framebuffer_fetch = 0;
    resources->ARM_shader_framebuffer_fetch = 0;

    resources->NV_draw_buffers = 0;

    // Disable highp precision in fragment shader by default.
    resources->FragmentPrecisionHigh = 0;

    // GLSL ES 3.0 constants.
    resources->MaxVertexOutputVectors = 16;
    resources->MaxFragmentInputVectors = 15;
    resources->MinProgramTexelOffset = -8;
    resources->MaxProgramTexelOffset = 7;

    // Extensions constants.
    resources->MaxDualSourceDrawBuffers = 0;

    // Disable name hashing by default.
    resources->HashFunction = NULL;

    resources->ArrayIndexClampingStrategy = SH_CLAMP_WITH_CLAMP_INTRINSIC;

    resources->MaxExpressionComplexity = 256;
    resources->MaxCallStackDepth       = 256;
    resources->MaxFunctionParameters   = 1024;

    // ES 3.1 Revision 4, 7.2 Built-in Constants
    resources->MaxImageUnits            = 4;
    resources->MaxVertexImageUniforms   = 0;
    resources->MaxFragmentImageUniforms = 0;
    resources->MaxComputeImageUniforms  = 4;
    resources->MaxCombinedImageUniforms = 4;

    resources->MaxCombinedShaderOutputResources = 4;

    resources->MaxComputeWorkGroupCount[0] = 65535;
    resources->MaxComputeWorkGroupCount[1] = 65535;
    resources->MaxComputeWorkGroupCount[2] = 65535;
    resources->MaxComputeWorkGroupSize[0]  = 128;
    resources->MaxComputeWorkGroupSize[1]  = 128;
    resources->MaxComputeWorkGroupSize[2]  = 64;
    resources->MaxComputeUniformComponents = 512;
    resources->MaxComputeTextureImageUnits = 16;

    resources->MaxComputeAtomicCounters       = 8;
    resources->MaxComputeAtomicCounterBuffers = 1;

    resources->MaxVertexAtomicCounters   = 0;
    resources->MaxFragmentAtomicCounters = 0;
    resources->MaxCombinedAtomicCounters = 8;
    resources->MaxAtomicCounterBindings  = 1;

    resources->MaxVertexAtomicCounterBuffers   = 0;
    resources->MaxFragmentAtomicCounterBuffers = 0;
    resources->MaxCombinedAtomicCounterBuffers = 1;
    resources->MaxAtomicCounterBufferSize      = 32;
}

//
// Driver calls these to create and destroy compiler objects.
//
ShHandle ShConstructCompiler(sh::GLenum type, ShShaderSpec spec,
                             ShShaderOutput output,
                             const ShBuiltInResources* resources)
{
    TShHandleBase* base = static_cast<TShHandleBase*>(ConstructCompiler(type, spec, output));
    if (base == nullptr)
    {
        return 0;
    }

    TCompiler* compiler = base->getAsCompiler();
    if (compiler == nullptr)
    {
        return 0;
    }

    // Generate built-in symbol table.
    if (!compiler->Init(*resources))
    {
        sh::Destruct(base);
        return 0;
    }

    return reinterpret_cast<void*>(base);
}

void ShDestruct(ShHandle handle)
{
    if (handle == 0)
        return;

    TShHandleBase* base = static_cast<TShHandleBase*>(handle);

    if (base->getAsCompiler())
        DeleteCompiler(base->getAsCompiler());
}

const std::string &ShGetBuiltInResourcesString(const ShHandle handle)
{
    TCompiler *compiler = GetCompilerFromHandle(handle);
    ASSERT(compiler);
    return compiler->getBuiltInResourcesString();
}

//
// Do an actual compile on the given strings.  The result is left
// in the given compile object.
//
// Return:  The return value of ShCompile is really boolean, indicating
// success or failure.
//
bool ShCompile(const ShHandle handle,
               const char *const shaderStrings[],
               size_t numStrings,
               ShCompileOptions compileOptions)
{
    TCompiler *compiler = GetCompilerFromHandle(handle);
    ASSERT(compiler);

    return compiler->compile(shaderStrings, numStrings, compileOptions);
}

void ShClearResults(const ShHandle handle)
{
    TCompiler *compiler = GetCompilerFromHandle(handle);
    ASSERT(compiler);
    compiler->clearResults();
}

int ShGetShaderVersion(const ShHandle handle)
{
    TCompiler* compiler = GetCompilerFromHandle(handle);
    ASSERT(compiler);
    return compiler->getShaderVersion();
}

ShShaderOutput ShGetShaderOutputType(const ShHandle handle)
{
    TCompiler* compiler = GetCompilerFromHandle(handle);
    ASSERT(compiler);
    return compiler->getOutputType();
}

//
// Return any compiler log of messages for the application.
//
const std::string &ShGetInfoLog(const ShHandle handle)
{
    TCompiler *compiler = GetCompilerFromHandle(handle);
    ASSERT(compiler);

    TInfoSink &infoSink = compiler->getInfoSink();
    return infoSink.info.str();
}

//
// Return any object code.
//
const std::string &ShGetObjectCode(const ShHandle handle)
{
    TCompiler *compiler = GetCompilerFromHandle(handle);
    ASSERT(compiler);

    TInfoSink &infoSink = compiler->getInfoSink();
    return infoSink.obj.str();
}

const std::map<std::string, std::string> *ShGetNameHashingMap(
    const ShHandle handle)
{
    TCompiler *compiler = GetCompilerFromHandle(handle);
    ASSERT(compiler);
    return &(compiler->getNameMap());
}

const std::vector<Uniform> *ShGetUniforms(const ShHandle handle)
{
    return GetShaderVariables<Uniform>(handle);
}

const std::vector<Varying> *ShGetVaryings(const ShHandle handle)
{
    return GetShaderVariables<Varying>(handle);
}

const std::vector<Attribute> *ShGetAttributes(const ShHandle handle)
{
    return GetShaderVariables<Attribute>(handle);
}

const std::vector<OutputVariable> *ShGetOutputVariables(const ShHandle handle)
{
    return GetShaderVariables<OutputVariable>(handle);
}

const std::vector<InterfaceBlock> *ShGetInterfaceBlocks(const ShHandle handle)
{
    return GetShaderVariables<InterfaceBlock>(handle);
}

WorkGroupSize ShGetComputeShaderLocalGroupSize(const ShHandle handle)
{
    ASSERT(handle);

    TShHandleBase *base = static_cast<TShHandleBase *>(handle);
    TCompiler *compiler = base->getAsCompiler();
    ASSERT(compiler);

    return compiler->getComputeShaderLocalSize();
}

bool ShCheckVariablesWithinPackingLimits(int maxVectors,
                                         const std::vector<ShaderVariable> &variables)
{
    VariablePacker packer;
    return packer.CheckVariablesWithinPackingLimits(maxVectors, variables);
}

bool ShGetInterfaceBlockRegister(const ShHandle handle,
                                 const std::string &interfaceBlockName,
                                 unsigned int *indexOut)
{
#ifdef ANGLE_ENABLE_HLSL
    ASSERT(indexOut);

    TranslatorHLSL *translator = GetTranslatorHLSLFromHandle(handle);
    ASSERT(translator);

    if (!translator->hasInterfaceBlock(interfaceBlockName))
    {
        return false;
    }

    *indexOut = translator->getInterfaceBlockRegister(interfaceBlockName);
    return true;
#else
    return false;
#endif // ANGLE_ENABLE_HLSL
}

const std::map<std::string, unsigned int> *ShGetUniformRegisterMap(const ShHandle handle)
{
#ifdef ANGLE_ENABLE_HLSL
    TranslatorHLSL *translator = GetTranslatorHLSLFromHandle(handle);
    ASSERT(translator);

    return translator->getUniformRegisterMap();
#else
    return nullptr;
#endif  // ANGLE_ENABLE_HLSL
}

namespace sh
{
bool Initialize()
{
    return ShInitialize();
}

bool Finalize()
{
    return ShFinalize();
}

void InitBuiltInResources(ShBuiltInResources *resources)
{
    ShInitBuiltInResources(resources);
}

const std::string &GetBuiltInResourcesString(const ShHandle handle)
{
    return ShGetBuiltInResourcesString(handle);
}

ShHandle ConstructCompiler(sh::GLenum type,
                           ShShaderSpec spec,
                           ShShaderOutput output,
                           const ShBuiltInResources *resources)
{
    return ShConstructCompiler(type, spec, output, resources);
}

void Destruct(ShHandle handle)
{
    return ShDestruct(handle);
}

bool Compile(const ShHandle handle,
             const char *const shaderStrings[],
             size_t numStrings,
             ShCompileOptions compileOptions)
{
    return ShCompile(handle, shaderStrings, numStrings, compileOptions);
}

void ClearResults(const ShHandle handle)
{
    return ShClearResults(handle);
}

int GetShaderVersion(const ShHandle handle)
{
    return ShGetShaderVersion(handle);
}

ShShaderOutput GetShaderOutputType(const ShHandle handle)
{
    return ShGetShaderOutputType(handle);
}

const std::string &GetInfoLog(const ShHandle handle)
{
    return ShGetInfoLog(handle);
}

const std::string &GetObjectCode(const ShHandle handle)
{
    return ShGetObjectCode(handle);
}

const std::map<std::string, std::string> *GetNameHashingMap(const ShHandle handle)
{
    return ShGetNameHashingMap(handle);
}

const std::vector<sh::Uniform> *GetUniforms(const ShHandle handle)
{
    return ShGetUniforms(handle);
}
const std::vector<sh::Varying> *GetVaryings(const ShHandle handle)
{
    return ShGetVaryings(handle);
}
const std::vector<sh::Attribute> *GetAttributes(const ShHandle handle)
{
    return ShGetAttributes(handle);
}

const std::vector<sh::OutputVariable> *GetOutputVariables(const ShHandle handle)
{
    return ShGetOutputVariables(handle);
}
const std::vector<sh::InterfaceBlock> *GetInterfaceBlocks(const ShHandle handle)
{
    return ShGetInterfaceBlocks(handle);
}

sh::WorkGroupSize GetComputeShaderLocalGroupSize(const ShHandle handle)
{
    return ShGetComputeShaderLocalGroupSize(handle);
}

bool CheckVariablesWithinPackingLimits(int maxVectors,
                                       const std::vector<sh::ShaderVariable> &variables)
{
    return ShCheckVariablesWithinPackingLimits(maxVectors, variables);
}

bool GetInterfaceBlockRegister(const ShHandle handle,
                               const std::string &interfaceBlockName,
                               unsigned int *indexOut)
{
    return ShGetInterfaceBlockRegister(handle, interfaceBlockName, indexOut);
}

const std::map<std::string, unsigned int> *GetUniformRegisterMap(const ShHandle handle)
{
    return ShGetUniformRegisterMap(handle);
}

}  // namespace sh
