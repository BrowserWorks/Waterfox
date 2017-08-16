//
// Copyright (c) 2014 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//

// State.h: Defines the State class, encapsulating raw GL state

#ifndef LIBANGLE_STATE_H_
#define LIBANGLE_STATE_H_

#include <bitset>
#include <memory>

#include "common/angleutils.h"
#include "common/Color.h"
#include "libANGLE/Debug.h"
#include "libANGLE/Program.h"
#include "libANGLE/RefCountObject.h"
#include "libANGLE/Renderbuffer.h"
#include "libANGLE/Sampler.h"
#include "libANGLE/Texture.h"
#include "libANGLE/TransformFeedback.h"
#include "libANGLE/Version.h"
#include "libANGLE/VertexAttribute.h"
#include "libANGLE/angletypes.h"

namespace gl
{
class Query;
class VertexArray;
class Context;
struct Caps;

typedef std::map<GLenum, BindingPointer<Texture>> TextureMap;

class State : angle::NonCopyable
{
  public:
    State();
    ~State();

    void initialize(const Caps &caps,
                    const Extensions &extensions,
                    const Version &clientVersion,
                    bool debug,
                    bool bindGeneratesResource);
    void reset();

    // State chunk getters
    const RasterizerState &getRasterizerState() const;
    const BlendState &getBlendState() const;
    const DepthStencilState &getDepthStencilState() const;

    // Clear behavior setters & state parameter block generation function
    void setColorClearValue(float red, float green, float blue, float alpha);
    void setDepthClearValue(float depth);
    void setStencilClearValue(int stencil);

    const ColorF &getColorClearValue() const { return mColorClearValue; }
    float getDepthClearValue() const { return mDepthClearValue; }
    int getStencilClearValue() const { return mStencilClearValue; }

    // Write mask manipulation
    void setColorMask(bool red, bool green, bool blue, bool alpha);
    void setDepthMask(bool mask);

    // Discard toggle & query
    bool isRasterizerDiscardEnabled() const;
    void setRasterizerDiscard(bool enabled);

    // Primitive restart
    bool isPrimitiveRestartEnabled() const;
    void setPrimitiveRestart(bool enabled);

    // Face culling state manipulation
    bool isCullFaceEnabled() const;
    void setCullFace(bool enabled);
    void setCullMode(GLenum mode);
    void setFrontFace(GLenum front);

    // Depth test state manipulation
    bool isDepthTestEnabled() const;
    void setDepthTest(bool enabled);
    void setDepthFunc(GLenum depthFunc);
    void setDepthRange(float zNear, float zFar);
    float getNearPlane() const;
    float getFarPlane() const;

    // Blend state manipulation
    bool isBlendEnabled() const;
    void setBlend(bool enabled);
    void setBlendFactors(GLenum sourceRGB, GLenum destRGB, GLenum sourceAlpha, GLenum destAlpha);
    void setBlendColor(float red, float green, float blue, float alpha);
    void setBlendEquation(GLenum rgbEquation, GLenum alphaEquation);
    const ColorF &getBlendColor() const;

    // Stencil state maniupulation
    bool isStencilTestEnabled() const;
    void setStencilTest(bool enabled);
    void setStencilParams(GLenum stencilFunc, GLint stencilRef, GLuint stencilMask);
    void setStencilBackParams(GLenum stencilBackFunc, GLint stencilBackRef, GLuint stencilBackMask);
    void setStencilWritemask(GLuint stencilWritemask);
    void setStencilBackWritemask(GLuint stencilBackWritemask);
    void setStencilOperations(GLenum stencilFail, GLenum stencilPassDepthFail, GLenum stencilPassDepthPass);
    void setStencilBackOperations(GLenum stencilBackFail, GLenum stencilBackPassDepthFail, GLenum stencilBackPassDepthPass);
    GLint getStencilRef() const;
    GLint getStencilBackRef() const;

    // Depth bias/polygon offset state manipulation
    bool isPolygonOffsetFillEnabled() const;
    void setPolygonOffsetFill(bool enabled);
    void setPolygonOffsetParams(GLfloat factor, GLfloat units);

    // Multisample coverage state manipulation
    bool isSampleAlphaToCoverageEnabled() const;
    void setSampleAlphaToCoverage(bool enabled);
    bool isSampleCoverageEnabled() const;
    void setSampleCoverage(bool enabled);
    void setSampleCoverageParams(GLclampf value, bool invert);
    GLclampf getSampleCoverageValue() const;
    bool getSampleCoverageInvert() const;

    // Multisampling/alpha to one manipulation.
    void setSampleAlphaToOne(bool enabled);
    bool isSampleAlphaToOneEnabled() const;
    void setMultisampling(bool enabled);
    bool isMultisamplingEnabled() const;

    // Scissor test state toggle & query
    bool isScissorTestEnabled() const;
    void setScissorTest(bool enabled);
    void setScissorParams(GLint x, GLint y, GLsizei width, GLsizei height);
    const Rectangle &getScissor() const;

    // Dither state toggle & query
    bool isDitherEnabled() const;
    void setDither(bool enabled);

    // Generic state toggle & query
    void setEnableFeature(GLenum feature, bool enabled);
    bool getEnableFeature(GLenum feature) const;

    // Line width state setter
    void setLineWidth(GLfloat width);
    float getLineWidth() const;

    // Hint setters
    void setGenerateMipmapHint(GLenum hint);
    void setFragmentShaderDerivativeHint(GLenum hint);

    // GL_CHROMIUM_bind_generates_resource
    bool isBindGeneratesResourceEnabled() const;

    // Viewport state setter/getter
    void setViewportParams(GLint x, GLint y, GLsizei width, GLsizei height);
    const Rectangle &getViewport() const;

    // Texture binding & active texture unit manipulation
    void setActiveSampler(unsigned int active);
    unsigned int getActiveSampler() const;
    void setSamplerTexture(GLenum type, Texture *texture);
    Texture *getTargetTexture(GLenum target) const;
    Texture *getSamplerTexture(unsigned int sampler, GLenum type) const;
    GLuint getSamplerTextureId(unsigned int sampler, GLenum type) const;
    void detachTexture(const TextureMap &zeroTextures, GLuint texture);
    void initializeZeroTextures(const TextureMap &zeroTextures);

    // Sampler object binding manipulation
    void setSamplerBinding(GLuint textureUnit, Sampler *sampler);
    GLuint getSamplerId(GLuint textureUnit) const;
    Sampler *getSampler(GLuint textureUnit) const;
    void detachSampler(GLuint sampler);

    // Renderbuffer binding manipulation
    void setRenderbufferBinding(Renderbuffer *renderbuffer);
    GLuint getRenderbufferId() const;
    Renderbuffer *getCurrentRenderbuffer() const;
    void detachRenderbuffer(GLuint renderbuffer);

    // Framebuffer binding manipulation
    void setReadFramebufferBinding(Framebuffer *framebuffer);
    void setDrawFramebufferBinding(Framebuffer *framebuffer);
    Framebuffer *getTargetFramebuffer(GLenum target) const;
    Framebuffer *getReadFramebuffer() const;
    Framebuffer *getDrawFramebuffer() const;
    bool removeReadFramebufferBinding(GLuint framebuffer);
    bool removeDrawFramebufferBinding(GLuint framebuffer);

    // Vertex array object binding manipulation
    void setVertexArrayBinding(VertexArray *vertexArray);
    GLuint getVertexArrayId() const;
    VertexArray *getVertexArray() const;
    bool removeVertexArrayBinding(GLuint vertexArray);

    // Program binding manipulation
    void setProgram(Program *newProgram);
    Program *getProgram() const;

    // Transform feedback object (not buffer) binding manipulation
    void setTransformFeedbackBinding(TransformFeedback *transformFeedback);
    TransformFeedback *getCurrentTransformFeedback() const;
    bool isTransformFeedbackActiveUnpaused() const;
    bool removeTransformFeedbackBinding(GLuint transformFeedback);

    // Query binding manipulation
    bool isQueryActive(const GLenum type) const;
    bool isQueryActive(Query *query) const;
    void setActiveQuery(GLenum target, Query *query);
    GLuint getActiveQueryId(GLenum target) const;
    Query *getActiveQuery(GLenum target) const;

    //// Typed buffer binding point manipulation ////
    // GL_ARRAY_BUFFER
    void setArrayBufferBinding(Buffer *buffer);
    GLuint getArrayBufferId() const;

    void setDrawIndirectBufferBinding(Buffer *buffer);
    Buffer *getDrawIndirectBuffer() const { return mDrawIndirectBuffer.get(); }

    // GL_UNIFORM_BUFFER - Both indexed and generic targets
    void setGenericUniformBufferBinding(Buffer *buffer);
    void setIndexedUniformBufferBinding(GLuint index, Buffer *buffer, GLintptr offset, GLsizeiptr size);
    const OffsetBindingPointer<Buffer> &getIndexedUniformBuffer(size_t index) const;

    // GL_COPY_[READ/WRITE]_BUFFER
    void setCopyReadBufferBinding(Buffer *buffer);
    void setCopyWriteBufferBinding(Buffer *buffer);

    // GL_PIXEL[PACK/UNPACK]_BUFFER
    void setPixelPackBufferBinding(Buffer *buffer);
    void setPixelUnpackBufferBinding(Buffer *buffer);

    // Retrieve typed buffer by target (non-indexed)
    Buffer *getTargetBuffer(GLenum target) const;
    // Detach a buffer from all bindings
    void detachBuffer(GLuint bufferName);

    // Vertex attrib manipulation
    void setEnableVertexAttribArray(unsigned int attribNum, bool enabled);
    void setVertexAttribf(GLuint index, const GLfloat values[4]);
    void setVertexAttribu(GLuint index, const GLuint values[4]);
    void setVertexAttribi(GLuint index, const GLint values[4]);
    void setVertexAttribState(unsigned int attribNum, Buffer *boundBuffer, GLint size, GLenum type,
                              bool normalized, bool pureInteger, GLsizei stride, const void *pointer);
    void setVertexAttribDivisor(GLuint index, GLuint divisor);
    const VertexAttribCurrentValueData &getVertexAttribCurrentValue(unsigned int attribNum) const;
    const void *getVertexAttribPointer(unsigned int attribNum) const;

    // Pixel pack state manipulation
    void setPackAlignment(GLint alignment);
    GLint getPackAlignment() const;
    void setPackReverseRowOrder(bool reverseRowOrder);
    bool getPackReverseRowOrder() const;
    void setPackRowLength(GLint rowLength);
    GLint getPackRowLength() const;
    void setPackSkipRows(GLint skipRows);
    GLint getPackSkipRows() const;
    void setPackSkipPixels(GLint skipPixels);
    GLint getPackSkipPixels() const;
    const PixelPackState &getPackState() const;
    PixelPackState &getPackState();

    // Pixel unpack state manipulation
    void setUnpackAlignment(GLint alignment);
    GLint getUnpackAlignment() const;
    void setUnpackRowLength(GLint rowLength);
    GLint getUnpackRowLength() const;
    void setUnpackImageHeight(GLint imageHeight);
    GLint getUnpackImageHeight() const;
    void setUnpackSkipImages(GLint skipImages);
    GLint getUnpackSkipImages() const;
    void setUnpackSkipRows(GLint skipRows);
    GLint getUnpackSkipRows() const;
    void setUnpackSkipPixels(GLint skipPixels);
    GLint getUnpackSkipPixels() const;
    const PixelUnpackState &getUnpackState() const;
    PixelUnpackState &getUnpackState();

    // Debug state
    const Debug &getDebug() const;
    Debug &getDebug();

    // CHROMIUM_framebuffer_mixed_samples coverage modulation
    void setCoverageModulation(GLenum components);
    GLenum getCoverageModulation() const;

    // CHROMIUM_path_rendering
    void loadPathRenderingMatrix(GLenum matrixMode, const GLfloat *matrix);
    const GLfloat *getPathRenderingMatrix(GLenum which) const;
    void setPathStencilFunc(GLenum func, GLint ref, GLuint mask);

    GLenum getPathStencilFunc() const;
    GLint getPathStencilRef() const;
    GLuint getPathStencilMask() const;

    // GL_EXT_sRGB_write_control
    void setFramebufferSRGB(bool sRGB);
    bool getFramebufferSRGB() const;

    // State query functions
    void getBooleanv(GLenum pname, GLboolean *params);
    void getFloatv(GLenum pname, GLfloat *params);
    void getIntegerv(const ContextState &data, GLenum pname, GLint *params);
    void getPointerv(GLenum pname, void **params) const;
    void getIntegeri_v(GLenum target, GLuint index, GLint *data);
    void getInteger64i_v(GLenum target, GLuint index, GLint64 *data);
    void getBooleani_v(GLenum target, GLuint index, GLboolean *data);

    bool hasMappedBuffer(GLenum target) const;

    enum DirtyBitType
    {
        DIRTY_BIT_SCISSOR_TEST_ENABLED,
        DIRTY_BIT_SCISSOR,
        DIRTY_BIT_VIEWPORT,
        DIRTY_BIT_DEPTH_RANGE,
        DIRTY_BIT_BLEND_ENABLED,
        DIRTY_BIT_BLEND_COLOR,
        DIRTY_BIT_BLEND_FUNCS,
        DIRTY_BIT_BLEND_EQUATIONS,
        DIRTY_BIT_COLOR_MASK,
        DIRTY_BIT_SAMPLE_ALPHA_TO_COVERAGE_ENABLED,
        DIRTY_BIT_SAMPLE_COVERAGE_ENABLED,
        DIRTY_BIT_SAMPLE_COVERAGE,
        DIRTY_BIT_DEPTH_TEST_ENABLED,
        DIRTY_BIT_DEPTH_FUNC,
        DIRTY_BIT_DEPTH_MASK,
        DIRTY_BIT_STENCIL_TEST_ENABLED,
        DIRTY_BIT_STENCIL_FUNCS_FRONT,
        DIRTY_BIT_STENCIL_FUNCS_BACK,
        DIRTY_BIT_STENCIL_OPS_FRONT,
        DIRTY_BIT_STENCIL_OPS_BACK,
        DIRTY_BIT_STENCIL_WRITEMASK_FRONT,
        DIRTY_BIT_STENCIL_WRITEMASK_BACK,
        DIRTY_BIT_CULL_FACE_ENABLED,
        DIRTY_BIT_CULL_FACE,
        DIRTY_BIT_FRONT_FACE,
        DIRTY_BIT_POLYGON_OFFSET_FILL_ENABLED,
        DIRTY_BIT_POLYGON_OFFSET,
        DIRTY_BIT_RASTERIZER_DISCARD_ENABLED,
        DIRTY_BIT_LINE_WIDTH,
        DIRTY_BIT_PRIMITIVE_RESTART_ENABLED,
        DIRTY_BIT_CLEAR_COLOR,
        DIRTY_BIT_CLEAR_DEPTH,
        DIRTY_BIT_CLEAR_STENCIL,
        DIRTY_BIT_UNPACK_ALIGNMENT,
        DIRTY_BIT_UNPACK_ROW_LENGTH,
        DIRTY_BIT_UNPACK_IMAGE_HEIGHT,
        DIRTY_BIT_UNPACK_SKIP_IMAGES,
        DIRTY_BIT_UNPACK_SKIP_ROWS,
        DIRTY_BIT_UNPACK_SKIP_PIXELS,
        DIRTY_BIT_UNPACK_BUFFER_BINDING,
        DIRTY_BIT_PACK_ALIGNMENT,
        DIRTY_BIT_PACK_REVERSE_ROW_ORDER,
        DIRTY_BIT_PACK_ROW_LENGTH,
        DIRTY_BIT_PACK_SKIP_ROWS,
        DIRTY_BIT_PACK_SKIP_PIXELS,
        DIRTY_BIT_PACK_BUFFER_BINDING,
        DIRTY_BIT_DITHER_ENABLED,
        DIRTY_BIT_GENERATE_MIPMAP_HINT,
        DIRTY_BIT_SHADER_DERIVATIVE_HINT,
        DIRTY_BIT_READ_FRAMEBUFFER_BINDING,
        DIRTY_BIT_DRAW_FRAMEBUFFER_BINDING,
        DIRTY_BIT_RENDERBUFFER_BINDING,
        DIRTY_BIT_VERTEX_ARRAY_BINDING,
        DIRTY_BIT_DRAW_INDIRECT_BUFFER_BINDING,
        DIRTY_BIT_PROGRAM_BINDING,
        DIRTY_BIT_MULTISAMPLING,
        DIRTY_BIT_SAMPLE_ALPHA_TO_ONE,
        DIRTY_BIT_COVERAGE_MODULATION,         // CHROMIUM_framebuffer_mixed_samples
        DIRTY_BIT_PATH_RENDERING_MATRIX_MV,    // CHROMIUM_path_rendering path model view matrix
        DIRTY_BIT_PATH_RENDERING_MATRIX_PROJ,  // CHROMIUM_path_rendering path projection matrix
        DIRTY_BIT_PATH_RENDERING_STENCIL_STATE,
        DIRTY_BIT_FRAMEBUFFER_SRGB,  // GL_EXT_sRGB_write_control
        DIRTY_BIT_CURRENT_VALUE_0,
        DIRTY_BIT_CURRENT_VALUE_MAX = DIRTY_BIT_CURRENT_VALUE_0 + MAX_VERTEX_ATTRIBS,
        DIRTY_BIT_INVALID           = DIRTY_BIT_CURRENT_VALUE_MAX,
        DIRTY_BIT_MAX               = DIRTY_BIT_INVALID,
    };

    // TODO(jmadill): Consider storing dirty objects in a list instead of by binding.
    enum DirtyObjectType
    {
        DIRTY_OBJECT_READ_FRAMEBUFFER,
        DIRTY_OBJECT_DRAW_FRAMEBUFFER,
        DIRTY_OBJECT_VERTEX_ARRAY,
        DIRTY_OBJECT_PROGRAM,
        DIRTY_OBJECT_UNKNOWN,
        DIRTY_OBJECT_MAX = DIRTY_OBJECT_UNKNOWN,
    };

    typedef std::bitset<DIRTY_BIT_MAX> DirtyBits;
    const DirtyBits &getDirtyBits() const { return mDirtyBits; }
    void clearDirtyBits() { mDirtyBits.reset(); }
    void clearDirtyBits(const DirtyBits &bitset) { mDirtyBits &= ~bitset; }
    void setAllDirtyBits() { mDirtyBits.set(); }

    typedef std::bitset<DIRTY_OBJECT_MAX> DirtyObjects;
    void clearDirtyObjects() { mDirtyObjects.reset(); }
    void setAllDirtyObjects() { mDirtyObjects.set(); }
    void syncDirtyObjects();
    void syncDirtyObjects(const DirtyObjects &bitset);
    void syncDirtyObject(GLenum target);
    void setObjectDirty(GLenum target);

  private:
    // Cached values from Context's caps
    GLuint mMaxDrawBuffers;
    GLuint mMaxCombinedTextureImageUnits;

    ColorF mColorClearValue;
    GLclampf mDepthClearValue;
    int mStencilClearValue;

    RasterizerState mRasterizer;
    bool mScissorTest;
    Rectangle mScissor;

    BlendState mBlend;
    ColorF mBlendColor;
    bool mSampleCoverage;
    GLclampf mSampleCoverageValue;
    bool mSampleCoverageInvert;

    DepthStencilState mDepthStencil;
    GLint mStencilRef;
    GLint mStencilBackRef;

    GLfloat mLineWidth;

    GLenum mGenerateMipmapHint;
    GLenum mFragmentShaderDerivativeHint;

    bool mBindGeneratesResource;

    Rectangle mViewport;
    float mNearZ;
    float mFarZ;

    BindingPointer<Buffer> mArrayBuffer;
    BindingPointer<Buffer> mDrawIndirectBuffer;
    Framebuffer *mReadFramebuffer;
    Framebuffer *mDrawFramebuffer;
    BindingPointer<Renderbuffer> mRenderbuffer;
    Program *mProgram;

    typedef std::vector<VertexAttribCurrentValueData> VertexAttribVector;
    VertexAttribVector mVertexAttribCurrentValues; // From glVertexAttrib
    VertexArray *mVertexArray;

    // Texture and sampler bindings
    size_t mActiveSampler;   // Active texture unit selector - GL_TEXTURE0

    typedef std::vector<BindingPointer<Texture>> TextureBindingVector;
    typedef std::map<GLenum, TextureBindingVector> TextureBindingMap;
    TextureBindingMap mSamplerTextures;

    typedef std::vector<BindingPointer<Sampler>> SamplerBindingVector;
    SamplerBindingVector mSamplers;

    typedef std::map<GLenum, BindingPointer<Query>> ActiveQueryMap;
    ActiveQueryMap mActiveQueries;

    BindingPointer<Buffer> mGenericUniformBuffer;
    typedef std::vector<OffsetBindingPointer<Buffer>> BufferVector;
    BufferVector mUniformBuffers;

    BindingPointer<TransformFeedback> mTransformFeedback;

    BindingPointer<Buffer> mCopyReadBuffer;
    BindingPointer<Buffer> mCopyWriteBuffer;

    PixelUnpackState mUnpack;
    PixelPackState mPack;

    bool mPrimitiveRestart;

    Debug mDebug;

    bool mMultiSampling;
    bool mSampleAlphaToOne;

    GLenum mCoverageModulation;

    // CHROMIUM_path_rendering
    GLfloat mPathMatrixMV[16];
    GLfloat mPathMatrixProj[16];
    GLenum mPathStencilFunc;
    GLint mPathStencilRef;
    GLuint mPathStencilMask;

    // GL_EXT_sRGB_write_control
    bool mFramebufferSRGB;

    DirtyBits mDirtyBits;
    DirtyObjects mDirtyObjects;
};

}  // namespace gl

#endif // LIBANGLE_STATE_H_
