/* -*- Mode: C++; tab-width: 20; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef GFX_OGLSHADERPROGRAM_H
#define GFX_OGLSHADERPROGRAM_H

#include "GLContext.h"                  // for fast inlines of glUniform*
#include "gfxTypes.h"
#include "ImageTypes.h"
#include "mozilla/Assertions.h"         // for MOZ_ASSERT, etc
#include "mozilla/Pair.h"               // for Pair
#include "mozilla/RefPtr.h"             // for RefPtr
#include "mozilla/gfx/Matrix.h"         // for Matrix4x4
#include "mozilla/gfx/Rect.h"           // for Rect
#include "mozilla/gfx/Types.h"
#include "nsDebug.h"                    // for NS_ASSERTION
#include "nsPoint.h"                    // for nsIntPoint
#include "nsTArray.h"                   // for nsTArray
#include "mozilla/layers/CompositorTypes.h"

#include <string>

namespace mozilla {
namespace layers {

class Layer;

enum ShaderFeatures {
  ENABLE_RENDER_COLOR=0x01,
  ENABLE_TEXTURE_RECT=0x02,
  ENABLE_TEXTURE_EXTERNAL=0x04,
  ENABLE_TEXTURE_YCBCR=0x08,
  ENABLE_TEXTURE_NV12=0x10,
  ENABLE_TEXTURE_COMPONENT_ALPHA=0x20,
  ENABLE_TEXTURE_NO_ALPHA=0x40,
  ENABLE_TEXTURE_RB_SWAP=0x80,
  ENABLE_OPACITY=0x100,
  ENABLE_BLUR=0x200,
  ENABLE_COLOR_MATRIX=0x400,
  ENABLE_MASK=0x800,
  ENABLE_NO_PREMUL_ALPHA=0x1000,
  ENABLE_DEAA=0x2000,
  ENABLE_DYNAMIC_GEOMETRY=0x4000
};

class KnownUniform {
public:
  // this needs to be kept in sync with strings in 'AddUniforms'
  enum KnownUniformName {
    NotAKnownUniform = -1,

    LayerTransform = 0,
    LayerTransformInverse,
    MaskTransform,
    BackdropTransform,
    LayerRects,
    MatrixProj,
    TextureTransform,
    TextureRects,
    RenderTargetOffset,
    LayerOpacity,
    Texture,
    YTexture,
    CbTexture,
    CrTexture,
    BlackTexture,
    WhiteTexture,
    MaskTexture,
    BackdropTexture,
    RenderColor,
    TexCoordMultiplier,
    CbCrTexCoordMultiplier,
    TexturePass2,
    ColorMatrix,
    ColorMatrixVector,
    BlurRadius,
    BlurOffset,
    BlurAlpha,
    BlurGaussianKernel,
    SSEdges,
    ViewportSize,
    VisibleCenter,
    YuvColorMatrix,

    KnownUniformCount
  };

  KnownUniform()
  {
    mName = NotAKnownUniform;
    mNameString = nullptr;
    mLocation = -1;
    memset(&mValue, 0, sizeof(mValue));
  }

  bool UpdateUniform(int32_t i1) {
    if (mLocation == -1) return false;
    if (mValue.i1 != i1) {
      mValue.i1 = i1;
      return true;
    }
    return false;
  }

  bool UpdateUniform(float f1) {
    if (mLocation == -1) return false;
    if (mValue.f1 != f1) {
      mValue.f1 = f1;
      return true;
    }
    return false;
  }

  bool UpdateUniform(float f1, float f2) {
    if (mLocation == -1) return false;
    if (mValue.f16v[0] != f1 ||
        mValue.f16v[1] != f2)
    {
      mValue.f16v[0] = f1;
      mValue.f16v[1] = f2;
      return true;
    }
    return false;
  }

  bool UpdateUniform(float f1, float f2, float f3, float f4) {
    if (mLocation == -1) return false;
    if (mValue.f16v[0] != f1 ||
        mValue.f16v[1] != f2 ||
        mValue.f16v[2] != f3 ||
        mValue.f16v[3] != f4)
    {
      mValue.f16v[0] = f1;
      mValue.f16v[1] = f2;
      mValue.f16v[2] = f3;
      mValue.f16v[3] = f4;
      return true;
    }
    return false;
  }

  bool UpdateUniform(int cnt, const float *fp) {
    if (mLocation == -1) return false;
    switch (cnt) {
    case 1:
    case 2:
    case 3:
    case 4:
    case 9:
    case 16:
      if (memcmp(mValue.f16v, fp, sizeof(float) * cnt) != 0) {
        memcpy(mValue.f16v, fp, sizeof(float) * cnt);
        return true;
      }
      return false;
    }

    NS_NOTREACHED("cnt must be 1 2 3 4 9 or 16");
    return false;
  }

  bool UpdateArrayUniform(int cnt, const float *fp) {
    if (mLocation == -1) return false;
    if (cnt > 16) {
      return false;
    }

    if (memcmp(mValue.f16v, fp, sizeof(float) * cnt) != 0) {
      memcpy(mValue.f16v, fp, sizeof(float) * cnt);
      return true;
    }
    return false;
  }

  bool UpdateArrayUniform(int cnt, const gfx::Point3D* points) {
    if (mLocation == -1) return false;
    if (cnt > 4) {
      return false;
    }

    float fp[12];
    float *d = fp;
    for(int i=0; i < cnt; i++) {
      // Note: Do not want to make assumptions about .x, .y, .z member packing.
      // If gfx::Point3D is updated to make this guarantee, SIMD optimizations
      // may be possible
      *d++ = points[i].x;
      *d++ = points[i].y;
      *d++ = points[i].z;
    }

    if (memcmp(mValue.f16v, fp, sizeof(float) * cnt * 3) != 0) {
      memcpy(mValue.f16v, fp, sizeof(float) * cnt * 3);
      return true;
    }
    return false;
  }

  KnownUniformName mName;
  const char *mNameString;
  int32_t mLocation;

  union {
    int i1;
    float f1;
    float f16v[16];
  } mValue;
};

class ShaderConfigOGL
{
public:
  ShaderConfigOGL() :
    mFeatures(0),
    mCompositionOp(gfx::CompositionOp::OP_OVER)
  {}

  void SetRenderColor(bool aEnabled);
  void SetTextureTarget(GLenum aTarget);
  void SetRBSwap(bool aEnabled);
  void SetNoAlpha(bool aEnabled);
  void SetOpacity(bool aEnabled);
  void SetYCbCr(bool aEnabled);
  void SetNV12(bool aEnabled);
  void SetComponentAlpha(bool aEnabled);
  void SetColorMatrix(bool aEnabled);
  void SetBlur(bool aEnabled);
  void SetMask(bool aEnabled);
  void SetDEAA(bool aEnabled);
  void SetCompositionOp(gfx::CompositionOp aOp);
  void SetNoPremultipliedAlpha();
  void SetDynamicGeometry(bool aEnabled);

  bool operator< (const ShaderConfigOGL& other) const {
    return mFeatures < other.mFeatures ||
           (mFeatures == other.mFeatures &&
            (int)mCompositionOp < (int)other.mCompositionOp);
  }

public:
  void SetFeature(int aBitmask, bool aState) {
    if (aState)
      mFeatures |= aBitmask;
    else
      mFeatures &= (~aBitmask);
  }

  int mFeatures;
  gfx::CompositionOp mCompositionOp;
};

static inline ShaderConfigOGL
ShaderConfigFromTargetAndFormat(GLenum aTarget,
                                gfx::SurfaceFormat aFormat)
{
  ShaderConfigOGL config;
  config.SetTextureTarget(aTarget);
  config.SetRBSwap(aFormat == gfx::SurfaceFormat::B8G8R8A8 ||
                   aFormat == gfx::SurfaceFormat::B8G8R8X8);
  config.SetNoAlpha(aFormat == gfx::SurfaceFormat::B8G8R8X8 ||
                    aFormat == gfx::SurfaceFormat::R8G8B8X8 ||
                    aFormat == gfx::SurfaceFormat::R5G6B5_UINT16);
  return config;
}

/**
 * This struct represents the shaders that make up a program and the uniform
 * and attribute parmeters that those shaders take.
 * It is used by ShaderProgramOGL.
 * Use the factory method GetProfileFor to create instances.
 */
struct ProgramProfileOGL
{
  /**
   * Factory method; creates an instance of this class for the given
   * ShaderConfigOGL
   */
  static ProgramProfileOGL GetProfileFor(ShaderConfigOGL aConfig);

  // the source code for the program's shaders
  std::string mVertexShaderString;
  std::string mFragmentShaderString;

  // the vertex attributes
  nsTArray<Pair<nsCString, GLuint>> mAttributes;

  KnownUniform mUniforms[KnownUniform::KnownUniformCount];
  nsTArray<const char *> mDefines;
  size_t mTextureCount;

  ProgramProfileOGL() :
    mTextureCount(0)
  {}

 private:
  static void BuildMixBlender(const ShaderConfigOGL& aConfig, std::ostringstream& fs);
};


#if defined(DEBUG)
#define CHECK_CURRENT_PROGRAM 1
#define ASSERT_THIS_PROGRAM                                             \
  do {                                                                  \
    GLuint currentProgram;                                              \
    mGL->GetUIntegerv(LOCAL_GL_CURRENT_PROGRAM, &currentProgram);       \
    MOZ_ASSERT(currentProgram == mProgram,                              \
                 "SetUniform with wrong program active!");              \
  } while (0)
#else
#define ASSERT_THIS_PROGRAM                                             \
  do { } while (0)
#endif

/**
 * Represents an OGL shader program. The details of a program are represented
 * by a ProgramProfileOGL
 */
class ShaderProgramOGL
{
public:
  typedef mozilla::gl::GLContext GLContext;

  ShaderProgramOGL(GLContext* aGL, const ProgramProfileOGL& aProfile);

  ~ShaderProgramOGL();

  bool HasInitialized() {
    NS_ASSERTION(mProgramState != STATE_OK || mProgram > 0, "Inconsistent program state");
    return mProgramState == STATE_OK;
  }

  GLuint GetProgram();

  bool Initialize();

  GLint CreateShader(GLenum aShaderType, const char *aShaderSource);

  /**
   * Creates a program and stores its id.
   */
  bool CreateProgram(const char *aVertexShaderString,
                     const char *aFragmentShaderString);

  /**
   * The following set of methods set a uniform argument to the shader program.
   * Not all uniforms may be set for all programs, and such uses will throw
   * an assertion.
   */
  void SetLayerTransform(const gfx::Matrix4x4& aMatrix) {
    SetMatrixUniform(KnownUniform::LayerTransform, aMatrix);
  }

  void SetLayerTransformInverse(const gfx::Matrix4x4& aMatrix) {
    SetMatrixUniform(KnownUniform::LayerTransformInverse, aMatrix);
  }

  void SetMaskLayerTransform(const gfx::Matrix4x4& aMatrix) {
    SetMatrixUniform(KnownUniform::MaskTransform, aMatrix);
  }

  void SetBackdropTransform(const gfx::Matrix4x4& aMatrix) {
    SetMatrixUniform(KnownUniform::BackdropTransform, aMatrix);
  }

  void SetDEAAEdges(const gfx::Point3D* aEdges) {
    SetArrayUniform(KnownUniform::SSEdges, 4, aEdges);
  }

  void SetViewportSize(const gfx::IntSize& aSize) {
    float vals[2] = { (float)aSize.width, (float)aSize.height };
    SetUniform(KnownUniform::ViewportSize, 2, vals);
  }

  void SetVisibleCenter(const gfx::Point& aVisibleCenter) {
    float vals[2] = { aVisibleCenter.x, aVisibleCenter.y };
    SetUniform(KnownUniform::VisibleCenter, 2, vals);
  }

  void SetLayerRects(const gfx::Rect* aRects) {
    float vals[16] = { aRects[0].x, aRects[0].y, aRects[0].width, aRects[0].height,
                       aRects[1].x, aRects[1].y, aRects[1].width, aRects[1].height,
                       aRects[2].x, aRects[2].y, aRects[2].width, aRects[2].height,
                       aRects[3].x, aRects[3].y, aRects[3].width, aRects[3].height };
    SetUniform(KnownUniform::LayerRects, 16, vals);
  }

  void SetProjectionMatrix(const gfx::Matrix4x4& aMatrix) {
    SetMatrixUniform(KnownUniform::MatrixProj, aMatrix);
  }

  // sets this program's texture transform, if it uses one
  void SetTextureTransform(const gfx::Matrix4x4& aMatrix) {
    SetMatrixUniform(KnownUniform::TextureTransform, aMatrix);
  }

  void SetTextureRects(const gfx::Rect* aRects) {
    float vals[16] = { aRects[0].x, aRects[0].y, aRects[0].width, aRects[0].height,
                       aRects[1].x, aRects[1].y, aRects[1].width, aRects[1].height,
                       aRects[2].x, aRects[2].y, aRects[2].width, aRects[2].height,
                       aRects[3].x, aRects[3].y, aRects[3].width, aRects[3].height };
    SetUniform(KnownUniform::TextureRects, 16, vals);
  }

  void SetRenderOffset(const nsIntPoint& aOffset) {
    float vals[4] = { float(aOffset.x), float(aOffset.y) };
    SetUniform(KnownUniform::RenderTargetOffset, 2, vals);
  }

  void SetRenderOffset(float aX, float aY) {
    float vals[2] = { aX, aY };
    SetUniform(KnownUniform::RenderTargetOffset, 2, vals);
  }

  void SetLayerOpacity(float aOpacity) {
    SetUniform(KnownUniform::LayerOpacity, aOpacity);
  }

  void SetTextureUnit(GLint aUnit) {
    SetUniform(KnownUniform::Texture, aUnit);
  }
  void SetYTextureUnit(GLint aUnit) {
    SetUniform(KnownUniform::YTexture, aUnit);
  }

  void SetCbTextureUnit(GLint aUnit) {
    SetUniform(KnownUniform::CbTexture, aUnit);
  }

  void SetCrTextureUnit(GLint aUnit) {
    SetUniform(KnownUniform::CrTexture, aUnit);
  }

  void SetYCbCrTextureUnits(GLint aYUnit, GLint aCbUnit, GLint aCrUnit) {
    SetUniform(KnownUniform::YTexture, aYUnit);
    SetUniform(KnownUniform::CbTexture, aCbUnit);
    SetUniform(KnownUniform::CrTexture, aCrUnit);
  }

  void SetNV12TextureUnits(GLint aYUnit, GLint aCbCrUnit) {
    SetUniform(KnownUniform::YTexture, aYUnit);
    SetUniform(KnownUniform::CbTexture, aCbCrUnit);
  }

  void SetBlackTextureUnit(GLint aUnit) {
    SetUniform(KnownUniform::BlackTexture, aUnit);
  }

  void SetWhiteTextureUnit(GLint aUnit) {
    SetUniform(KnownUniform::WhiteTexture, aUnit);
  }

  void SetMaskTextureUnit(GLint aUnit) {
    SetUniform(KnownUniform::MaskTexture, aUnit);
  }

  void SetBackdropTextureUnit(GLint aUnit) {
    SetUniform(KnownUniform::BackdropTexture, aUnit);
  }

  void SetRenderColor(const gfx::Color& aColor) {
    SetUniform(KnownUniform::RenderColor, aColor);
  }

  void SetColorMatrix(const gfx::Matrix5x4& aColorMatrix)
  {
    SetMatrixUniform(KnownUniform::ColorMatrix, &aColorMatrix._11);
    SetUniform(KnownUniform::ColorMatrixVector, 4, &aColorMatrix._51);
  }

  void SetTexCoordMultiplier(float aWidth, float aHeight) {
    float f[] = {aWidth, aHeight};
    SetUniform(KnownUniform::TexCoordMultiplier, 2, f);
  }

  void SetCbCrTexCoordMultiplier(float aWidth, float aHeight) {
    float f[] = {aWidth, aHeight};
    SetUniform(KnownUniform::CbCrTexCoordMultiplier, 2, f);
  }

  void SetYUVColorSpace(YUVColorSpace aYUVColorSpace);

  // Set whether we want the component alpha shader to return the color
  // vector (pass 1, false) or the alpha vector (pass2, true). With support
  // for multiple render targets we wouldn't need two passes here.
  void SetTexturePass2(bool aFlag) {
    SetUniform(KnownUniform::TexturePass2, aFlag ? 1 : 0);
  }

  void SetBlurRadius(float aRX, float aRY);

  void SetBlurAlpha(float aAlpha) {
    SetUniform(KnownUniform::BlurAlpha, aAlpha);
  }

  void SetBlurOffset(float aOffsetX, float aOffsetY) {
    float f[] = {aOffsetX, aOffsetY};
    SetUniform(KnownUniform::BlurOffset, 2, f);
  }

  size_t GetTextureCount() const {
    return mProfile.mTextureCount;
  }

protected:
  RefPtr<GLContext> mGL;
  // the OpenGL id of the program
  GLuint mProgram;
  ProgramProfileOGL mProfile;
  enum {
    STATE_NEW,
    STATE_OK,
    STATE_ERROR
  } mProgramState;

#ifdef CHECK_CURRENT_PROGRAM
  static int sCurrentProgramKey;
#endif

  void SetUniform(KnownUniform::KnownUniformName aKnownUniform, float aFloatValue)
  {
    ASSERT_THIS_PROGRAM;
    NS_ASSERTION(aKnownUniform >= 0 && aKnownUniform < KnownUniform::KnownUniformCount, "Invalid known uniform");

    KnownUniform& ku(mProfile.mUniforms[aKnownUniform]);
    if (ku.UpdateUniform(aFloatValue)) {
      mGL->fUniform1f(ku.mLocation, aFloatValue);
    }
  }

  void SetUniform(KnownUniform::KnownUniformName aKnownUniform, const gfx::Color& aColor) {
    ASSERT_THIS_PROGRAM;
    NS_ASSERTION(aKnownUniform >= 0 && aKnownUniform < KnownUniform::KnownUniformCount, "Invalid known uniform");

    KnownUniform& ku(mProfile.mUniforms[aKnownUniform]);
    if (ku.UpdateUniform(aColor.r, aColor.g, aColor.b, aColor.a)) {
      mGL->fUniform4fv(ku.mLocation, 1, ku.mValue.f16v);
    }
  }

  void SetUniform(KnownUniform::KnownUniformName aKnownUniform, int aLength, const float *aFloatValues)
  {
    ASSERT_THIS_PROGRAM;
    NS_ASSERTION(aKnownUniform >= 0 && aKnownUniform < KnownUniform::KnownUniformCount, "Invalid known uniform");

    KnownUniform& ku(mProfile.mUniforms[aKnownUniform]);
    if (ku.UpdateUniform(aLength, aFloatValues)) {
      switch (aLength) {
      case 1: mGL->fUniform1fv(ku.mLocation, 1, ku.mValue.f16v); break;
      case 2: mGL->fUniform2fv(ku.mLocation, 1, ku.mValue.f16v); break;
      case 3: mGL->fUniform3fv(ku.mLocation, 1, ku.mValue.f16v); break;
      case 4: mGL->fUniform4fv(ku.mLocation, 1, ku.mValue.f16v); break;
      case 16: mGL->fUniform4fv(ku.mLocation, 4, ku.mValue.f16v); break;
      default:
        NS_NOTREACHED("Bogus aLength param");
      }
    }
  }

  void SetArrayUniform(KnownUniform::KnownUniformName aKnownUniform, int aLength, float *aFloatValues)
  {
    ASSERT_THIS_PROGRAM;
    NS_ASSERTION(aKnownUniform >= 0 && aKnownUniform < KnownUniform::KnownUniformCount, "Invalid known uniform");

    KnownUniform& ku(mProfile.mUniforms[aKnownUniform]);
    if (ku.UpdateArrayUniform(aLength, aFloatValues)) {
      mGL->fUniform1fv(ku.mLocation, aLength, ku.mValue.f16v);
    }
  }

  void SetArrayUniform(KnownUniform::KnownUniformName aKnownUniform, int aLength, const gfx::Point3D *aPointValues)
  {
    ASSERT_THIS_PROGRAM;
    NS_ASSERTION(aKnownUniform >= 0 && aKnownUniform < KnownUniform::KnownUniformCount, "Invalid known uniform");

    KnownUniform& ku(mProfile.mUniforms[aKnownUniform]);
    if (ku.UpdateArrayUniform(aLength, aPointValues)) {
      mGL->fUniform3fv(ku.mLocation, aLength, ku.mValue.f16v);
    }
  }

  void SetUniform(KnownUniform::KnownUniformName aKnownUniform, GLint aIntValue) {
    ASSERT_THIS_PROGRAM;
    NS_ASSERTION(aKnownUniform >= 0 && aKnownUniform < KnownUniform::KnownUniformCount, "Invalid known uniform");

    KnownUniform& ku(mProfile.mUniforms[aKnownUniform]);
    if (ku.UpdateUniform(aIntValue)) {
      mGL->fUniform1i(ku.mLocation, aIntValue);
    }
  }

  void SetMatrixUniform(KnownUniform::KnownUniformName aKnownUniform, const float *aFloatValues) {
    ASSERT_THIS_PROGRAM;
    NS_ASSERTION(aKnownUniform >= 0 && aKnownUniform < KnownUniform::KnownUniformCount, "Invalid known uniform");

    KnownUniform& ku(mProfile.mUniforms[aKnownUniform]);
    if (ku.UpdateUniform(16, aFloatValues)) {
      mGL->fUniformMatrix4fv(ku.mLocation, 1, false, ku.mValue.f16v);
    }
  }

  void SetMatrix3fvUniform(KnownUniform::KnownUniformName aKnownUniform, const float *aFloatValues) {
    ASSERT_THIS_PROGRAM;
    NS_ASSERTION(aKnownUniform >= 0 && aKnownUniform < KnownUniform::KnownUniformCount, "Invalid known uniform");

    KnownUniform& ku(mProfile.mUniforms[aKnownUniform]);
    if (ku.UpdateUniform(9, aFloatValues)) {
      mGL->fUniformMatrix3fv(ku.mLocation, 1, false, ku.mValue.f16v);
    }
  }

  void SetMatrixUniform(KnownUniform::KnownUniformName aKnownUniform, const gfx::Matrix4x4& aMatrix) {
    SetMatrixUniform(aKnownUniform, &aMatrix._11);
  }
};

} // namespace layers
} // namespace mozilla

#endif /* GFX_OGLSHADERPROGRAM_H */
