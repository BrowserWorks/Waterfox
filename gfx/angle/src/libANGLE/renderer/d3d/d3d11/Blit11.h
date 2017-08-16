//
// Copyright (c) 2013 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//

// Blit11.cpp: Texture copy utility class.

#ifndef LIBANGLE_RENDERER_D3D_D3D11_BLIT11_H_
#define LIBANGLE_RENDERER_D3D_D3D11_BLIT11_H_

#include "common/angleutils.h"
#include "libANGLE/angletypes.h"
#include "libANGLE/Error.h"
#include "libANGLE/renderer/d3d/d3d11/renderer11_utils.h"

#include <map>

namespace rx
{
class Renderer11;

class Blit11 : angle::NonCopyable
{
  public:
    explicit Blit11(Renderer11 *renderer);
    ~Blit11();

    gl::Error swizzleTexture(ID3D11ShaderResourceView *source,
                             ID3D11RenderTargetView *dest,
                             const gl::Extents &size,
                             const gl::SwizzleState &swizzleTarget);

    gl::Error copyTexture(ID3D11ShaderResourceView *source,
                          const gl::Box &sourceArea,
                          const gl::Extents &sourceSize,
                          ID3D11RenderTargetView *dest,
                          const gl::Box &destArea,
                          const gl::Extents &destSize,
                          const gl::Rectangle *scissor,
                          GLenum destFormat,
                          GLenum filter,
                          bool maskOffAlpha,
                          bool unpackPremultiplyAlpha,
                          bool unpackUnmultiplyAlpha);

    gl::Error copyStencil(const TextureHelper11 &source,
                          unsigned int sourceSubresource,
                          const gl::Box &sourceArea,
                          const gl::Extents &sourceSize,
                          const TextureHelper11 &dest,
                          unsigned int destSubresource,
                          const gl::Box &destArea,
                          const gl::Extents &destSize,
                          const gl::Rectangle *scissor);

    gl::Error copyDepth(ID3D11ShaderResourceView *source,
                        const gl::Box &sourceArea,
                        const gl::Extents &sourceSize,
                        ID3D11DepthStencilView *dest,
                        const gl::Box &destArea,
                        const gl::Extents &destSize,
                        const gl::Rectangle *scissor);

    gl::Error copyDepthStencil(const TextureHelper11 &source,
                               unsigned int sourceSubresource,
                               const gl::Box &sourceArea,
                               const gl::Extents &sourceSize,
                               const TextureHelper11 &dest,
                               unsigned int destSubresource,
                               const gl::Box &destArea,
                               const gl::Extents &destSize,
                               const gl::Rectangle *scissor);

    gl::ErrorOrResult<TextureHelper11> resolveDepth(RenderTarget11 *depth);

    gl::ErrorOrResult<TextureHelper11> resolveStencil(RenderTarget11 *depthStencil, bool alsoDepth);

    using BlitConvertFunction = void(const gl::Box &sourceArea,
                                     const gl::Box &destArea,
                                     const gl::Rectangle &clipRect,
                                     const gl::Extents &sourceSize,
                                     unsigned int sourceRowPitch,
                                     unsigned int destRowPitch,
                                     ptrdiff_t readOffset,
                                     ptrdiff_t writeOffset,
                                     size_t copySize,
                                     size_t srcPixelStride,
                                     size_t destPixelStride,
                                     const uint8_t *sourceData,
                                     uint8_t *destData);

  private:
    enum BlitShaderType
    {
        BLITSHADER_INVALID,
        BLITSHADER_2D_RGBAF,
        BLITSHADER_2D_RGBAF_PREMULTIPLY,
        BLITSHADER_2D_RGBAF_UNMULTIPLY,
        BLITSHADER_2D_BGRAF,
        BLITSHADER_2D_BGRAF_PREMULTIPLY,
        BLITSHADER_2D_BGRAF_UNMULTIPLY,
        BLITSHADER_2D_RGBF,
        BLITSHADER_2D_RGBF_PREMULTIPLY,
        BLITSHADER_2D_RGBF_UNMULTIPLY,
        BLITSHADER_2D_RGF,
        BLITSHADER_2D_RF,
        BLITSHADER_2D_ALPHA,
        BLITSHADER_2D_LUMA,
        BLITSHADER_2D_LUMAALPHA,
        BLITSHADER_2D_RGBAUI,
        BLITSHADER_2D_RGBAI,
        BLITSHADER_2D_RGBUI,
        BLITSHADER_2D_RGBI,
        BLITSHADER_2D_RGUI,
        BLITSHADER_2D_RGI,
        BLITSHADER_2D_RUI,
        BLITSHADER_2D_RI,
        BLITSHADER_3D_RGBAF,
        BLITSHADER_3D_RGBAUI,
        BLITSHADER_3D_RGBAI,
        BLITSHADER_3D_BGRAF,
        BLITSHADER_3D_RGBF,
        BLITSHADER_3D_RGBUI,
        BLITSHADER_3D_RGBI,
        BLITSHADER_3D_RGF,
        BLITSHADER_3D_RGUI,
        BLITSHADER_3D_RGI,
        BLITSHADER_3D_RF,
        BLITSHADER_3D_RUI,
        BLITSHADER_3D_RI,
        BLITSHADER_3D_ALPHA,
        BLITSHADER_3D_LUMA,
        BLITSHADER_3D_LUMAALPHA,
    };

    enum SwizzleShaderType
    {
        SWIZZLESHADER_INVALID,
        SWIZZLESHADER_2D_FLOAT,
        SWIZZLESHADER_2D_UINT,
        SWIZZLESHADER_2D_INT,
        SWIZZLESHADER_CUBE_FLOAT,
        SWIZZLESHADER_CUBE_UINT,
        SWIZZLESHADER_CUBE_INT,
        SWIZZLESHADER_3D_FLOAT,
        SWIZZLESHADER_3D_UINT,
        SWIZZLESHADER_3D_INT,
        SWIZZLESHADER_ARRAY_FLOAT,
        SWIZZLESHADER_ARRAY_UINT,
        SWIZZLESHADER_ARRAY_INT,
    };

    typedef void (*WriteVertexFunction)(const gl::Box &sourceArea,
                                        const gl::Extents &sourceSize,
                                        const gl::Box &destArea,
                                        const gl::Extents &destSize,
                                        void *outVertices,
                                        unsigned int *outStride,
                                        unsigned int *outVertexCount,
                                        D3D11_PRIMITIVE_TOPOLOGY *outTopology);

    enum ShaderDimension
    {
        SHADER_2D,
        SHADER_3D,
    };

    struct Shader
    {
        ShaderDimension dimension;
        ID3D11PixelShader *pixelShader;
    };

    struct ShaderSupport
    {
        ID3D11InputLayout *inputLayout;
        ID3D11VertexShader *vertexShader;
        ID3D11GeometryShader *geometryShader;
        WriteVertexFunction vertexWriteFunction;
    };

    gl::Error initResources();

    ShaderSupport getShaderSupport(const Shader &shader);

    static BlitShaderType GetBlitShaderType(GLenum destinationFormat,
                                            bool isSigned,
                                            bool unpackPremultiplyAlpha,
                                            bool unpackUnmultiplyAlpha,
                                            ShaderDimension dimension);
    static SwizzleShaderType GetSwizzleShaderType(GLenum type, D3D11_SRV_DIMENSION dimensionality);

    gl::Error copyDepthStencilImpl(const TextureHelper11 &source,
                                   unsigned int sourceSubresource,
                                   const gl::Box &sourceArea,
                                   const gl::Extents &sourceSize,
                                   const TextureHelper11 &dest,
                                   unsigned int destSubresource,
                                   const gl::Box &destArea,
                                   const gl::Extents &destSize,
                                   const gl::Rectangle *scissor,
                                   bool stencilOnly);

    gl::Error copyAndConvertImpl(const TextureHelper11 &source,
                                 unsigned int sourceSubresource,
                                 const gl::Box &sourceArea,
                                 const gl::Extents &sourceSize,
                                 const TextureHelper11 &destStaging,
                                 const gl::Box &destArea,
                                 const gl::Extents &destSize,
                                 const gl::Rectangle *scissor,
                                 size_t readOffset,
                                 size_t writeOffset,
                                 size_t copySize,
                                 size_t srcPixelStride,
                                 size_t destPixelStride,
                                 BlitConvertFunction *convertFunction);

    gl::Error copyAndConvert(const TextureHelper11 &source,
                             unsigned int sourceSubresource,
                             const gl::Box &sourceArea,
                             const gl::Extents &sourceSize,
                             const TextureHelper11 &dest,
                             unsigned int destSubresource,
                             const gl::Box &destArea,
                             const gl::Extents &destSize,
                             const gl::Rectangle *scissor,
                             size_t readOffset,
                             size_t writeOffset,
                             size_t copySize,
                             size_t srcPixelStride,
                             size_t destPixelStride,
                             BlitConvertFunction *convertFunction);

    void addBlitShaderToMap(BlitShaderType blitShaderType,
                            ShaderDimension dimension,
                            ID3D11PixelShader *ps);

    gl::Error getBlitShader(GLenum destFormat,
                            bool isSigned,
                            bool unpackPremultiplyAlpha,
                            bool unpackUnmultiplyAlpha,
                            ShaderDimension dimension,
                            const Shader **shaderOut);
    gl::Error getSwizzleShader(GLenum type,
                               D3D11_SRV_DIMENSION viewDimension,
                               const Shader **shaderOut);

    void addSwizzleShaderToMap(SwizzleShaderType swizzleShaderType,
                               ShaderDimension dimension,
                               ID3D11PixelShader *ps);

    void clearShaderMap();
    void releaseResolveDepthStencilResources();
    gl::Error initResolveDepthStencil(const gl::Extents &extents);

    Renderer11 *mRenderer;

    std::map<BlitShaderType, Shader> mBlitShaderMap;
    std::map<SwizzleShaderType, Shader> mSwizzleShaderMap;

    bool mResourcesInitialized;
    angle::ComPtr<ID3D11Buffer> mVertexBuffer;
    angle::ComPtr<ID3D11SamplerState> mPointSampler;
    angle::ComPtr<ID3D11SamplerState> mLinearSampler;
    angle::ComPtr<ID3D11RasterizerState> mScissorEnabledRasterizerState;
    angle::ComPtr<ID3D11RasterizerState> mScissorDisabledRasterizerState;
    angle::ComPtr<ID3D11DepthStencilState> mDepthStencilState;

    d3d11::LazyInputLayout mQuad2DIL;
    d3d11::LazyShader<ID3D11VertexShader> mQuad2DVS;
    d3d11::LazyShader<ID3D11PixelShader> mDepthPS;

    d3d11::LazyInputLayout mQuad3DIL;
    d3d11::LazyShader<ID3D11VertexShader> mQuad3DVS;
    d3d11::LazyShader<ID3D11GeometryShader> mQuad3DGS;

    d3d11::LazyBlendState mAlphaMaskBlendState;

    angle::ComPtr<ID3D11Buffer> mSwizzleCB;

    d3d11::LazyShader<ID3D11VertexShader> mResolveDepthStencilVS;
    d3d11::LazyShader<ID3D11PixelShader> mResolveDepthPS;
    d3d11::LazyShader<ID3D11PixelShader> mResolveDepthStencilPS;
    d3d11::LazyShader<ID3D11PixelShader> mResolveStencilPS;
    angle::ComPtr<ID3D11ShaderResourceView> mStencilSRV;
    TextureHelper11 mResolvedDepthStencil;
    angle::ComPtr<ID3D11RenderTargetView> mResolvedDepthStencilRTView;
};

}  // namespace rx

#endif  // LIBANGLE_RENDERER_D3D_D3D11_BLIT11_H_
