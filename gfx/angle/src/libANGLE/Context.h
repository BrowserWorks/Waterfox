//
// Copyright (c) 2002-2014 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//

// Context.h: Defines the gl::Context class, managing all GL state and performing
// rendering operations. It is the GLES2 specific implementation of EGLContext.

#ifndef LIBANGLE_CONTEXT_H_
#define LIBANGLE_CONTEXT_H_

#include <set>
#include <string>

#include "angle_gl.h"
#include "common/angleutils.h"
#include "libANGLE/RefCountObject.h"
#include "libANGLE/Caps.h"
#include "libANGLE/Constants.h"
#include "libANGLE/ContextState.h"
#include "libANGLE/Error.h"
#include "libANGLE/HandleAllocator.h"
#include "libANGLE/VertexAttribute.h"
#include "libANGLE/Workarounds.h"
#include "libANGLE/angletypes.h"

namespace rx
{
class ContextImpl;
class EGLImplFactory;
}

namespace egl
{
class AttributeMap;
class Surface;
struct Config;
}

namespace gl
{
class Compiler;
class Shader;
class Program;
class Texture;
class Framebuffer;
class Renderbuffer;
class FenceNV;
class FenceSync;
class Query;
class ResourceManager;
class Buffer;
struct VertexAttribute;
class VertexArray;
class Sampler;
class TransformFeedback;

class Context final : public ValidationContext
{
  public:
    Context(rx::EGLImplFactory *implFactory,
            const egl::Config *config,
            const Context *shareContext,
            const egl::AttributeMap &attribs);

    virtual ~Context();

    void makeCurrent(egl::Surface *surface);
    void releaseSurface();

    // These create  and destroy methods are merely pass-throughs to
    // ResourceManager, which owns these object types
    GLuint createBuffer();
    GLuint createShader(GLenum type);
    GLuint createProgram();
    GLuint createTexture();
    GLuint createRenderbuffer();
    GLuint createSampler();
    GLuint createTransformFeedback();
    GLsync createFenceSync();
    GLuint createPaths(GLsizei range);

    void deleteBuffer(GLuint buffer);
    void deleteShader(GLuint shader);
    void deleteProgram(GLuint program);
    void deleteTexture(GLuint texture);
    void deleteRenderbuffer(GLuint renderbuffer);
    void deleteSampler(GLuint sampler);
    void deleteTransformFeedback(GLuint transformFeedback);
    void deleteFenceSync(GLsync fenceSync);
    void deletePaths(GLuint first, GLsizei range);

    // CHROMIUM_path_rendering
    bool hasPathData(GLuint path) const;
    bool hasPath(GLuint path) const;
    void setPathCommands(GLuint path,
                         GLsizei numCommands,
                         const GLubyte *commands,
                         GLsizei numCoords,
                         GLenum coordType,
                         const void *coords);
    void setPathParameterf(GLuint path, GLenum pname, GLfloat value);
    void getPathParameterfv(GLuint path, GLenum pname, GLfloat *value) const;
    void setPathStencilFunc(GLenum func, GLint ref, GLuint mask);

    // Framebuffers are owned by the Context, so these methods do not pass through
    GLuint createFramebuffer();
    void deleteFramebuffer(GLuint framebuffer);

    // NV Fences are owned by the Context.
    GLuint createFenceNV();
    void deleteFenceNV(GLuint fence);

    // Queries are owned by the Context;
    GLuint createQuery();
    void deleteQuery(GLuint query);

    // Vertex arrays are owned by the Context
    GLuint createVertexArray();
    void deleteVertexArray(GLuint vertexArray);

    void bindArrayBuffer(GLuint bufferHandle);
    void bindElementArrayBuffer(GLuint bufferHandle);
    void bindTexture(GLenum target, GLuint handle);
    void bindReadFramebuffer(GLuint framebufferHandle);
    void bindDrawFramebuffer(GLuint framebufferHandle);
    void bindVertexArray(GLuint vertexArrayHandle);
    void bindSampler(GLuint textureUnit, GLuint samplerHandle);
    void bindGenericUniformBuffer(GLuint bufferHandle);
    void bindIndexedUniformBuffer(GLuint bufferHandle,
                                  GLuint index,
                                  GLintptr offset,
                                  GLsizeiptr size);
    void bindGenericTransformFeedbackBuffer(GLuint bufferHandle);
    void bindIndexedTransformFeedbackBuffer(GLuint bufferHandle,
                                            GLuint index,
                                            GLintptr offset,
                                            GLsizeiptr size);
    void bindCopyReadBuffer(GLuint bufferHandle);
    void bindCopyWriteBuffer(GLuint bufferHandle);
    void bindPixelPackBuffer(GLuint bufferHandle);
    void bindPixelUnpackBuffer(GLuint bufferHandle);
    void useProgram(GLuint program);
    void bindTransformFeedback(GLuint transformFeedbackHandle);
    void bindDrawIndirectBuffer(GLuint bufferHandle);

    Error beginQuery(GLenum target, GLuint query);
    Error endQuery(GLenum target);
    Error queryCounter(GLuint id, GLenum target);
    void getQueryiv(GLenum target, GLenum pname, GLint *params);
    void getQueryObjectiv(GLuint id, GLenum pname, GLint *params);
    void getQueryObjectuiv(GLuint id, GLenum pname, GLuint *params);
    void getQueryObjecti64v(GLuint id, GLenum pname, GLint64 *params);
    void getQueryObjectui64v(GLuint id, GLenum pname, GLuint64 *params);

    void setVertexAttribDivisor(GLuint index, GLuint divisor);

    void samplerParameteri(GLuint sampler, GLenum pname, GLint param);
    void samplerParameteriv(GLuint sampler, GLenum pname, const GLint *param);
    void samplerParameterf(GLuint sampler, GLenum pname, GLfloat param);
    void samplerParameterfv(GLuint sampler, GLenum pname, const GLfloat *param);

    void getSamplerParameteriv(GLuint sampler, GLenum pname, GLint *params);
    void getSamplerParameterfv(GLuint sampler, GLenum pname, GLfloat *params);

    void programParameteri(GLuint program, GLenum pname, GLint value);

    Buffer *getBuffer(GLuint handle) const;
    FenceNV *getFenceNV(GLuint handle);
    FenceSync *getFenceSync(GLsync handle) const;
    Texture *getTexture(GLuint handle) const;
    Framebuffer *getFramebuffer(GLuint handle) const;
    Renderbuffer *getRenderbuffer(GLuint handle) const;
    VertexArray *getVertexArray(GLuint handle) const;
    Sampler *getSampler(GLuint handle) const;
    Query *getQuery(GLuint handle, bool create, GLenum type);
    Query *getQuery(GLuint handle) const;
    TransformFeedback *getTransformFeedback(GLuint handle) const;
    void objectLabel(GLenum identifier, GLuint name, GLsizei length, const GLchar *label);
    void objectPtrLabel(const void *ptr, GLsizei length, const GLchar *label);
    void getObjectLabel(GLenum identifier,
                        GLuint name,
                        GLsizei bufSize,
                        GLsizei *length,
                        GLchar *label) const;
    void getObjectPtrLabel(const void *ptr, GLsizei bufSize, GLsizei *length, GLchar *label) const;

    Texture *getTargetTexture(GLenum target) const;
    Texture *getSamplerTexture(unsigned int sampler, GLenum type) const;

    Compiler *getCompiler() const;

    bool isSampler(GLuint samplerName) const;

    bool isVertexArrayGenerated(GLuint vertexArray);
    bool isTransformFeedbackGenerated(GLuint vertexArray);

    void getBooleanv(GLenum pname, GLboolean *params);
    void getFloatv(GLenum pname, GLfloat *params);
    void getIntegerv(GLenum pname, GLint *params);
    void getInteger64v(GLenum pname, GLint64 *params);
    void getPointerv(GLenum pname, void **params) const;
    void getBooleani_v(GLenum target, GLuint index, GLboolean *data);
    void getIntegeri_v(GLenum target, GLuint index, GLint *data);
    void getInteger64i_v(GLenum target, GLuint index, GLint64 *data);

    void activeTexture(GLenum texture);
    void blendColor(GLclampf red, GLclampf green, GLclampf blue, GLclampf alpha);
    void blendEquation(GLenum mode);
    void blendEquationSeparate(GLenum modeRGB, GLenum modeAlpha);
    void blendFunc(GLenum sfactor, GLenum dfactor);
    void blendFuncSeparate(GLenum srcRGB, GLenum dstRGB, GLenum srcAlpha, GLenum dstAlpha);
    void clearColor(GLclampf red, GLclampf green, GLclampf blue, GLclampf alpha);
    void clearDepthf(GLclampf depth);
    void clearStencil(GLint s);
    void colorMask(GLboolean red, GLboolean green, GLboolean blue, GLboolean alpha);
    void cullFace(GLenum mode);
    void depthFunc(GLenum func);
    void depthMask(GLboolean flag);
    void depthRangef(GLclampf zNear, GLclampf zFar);
    void disable(GLenum cap);
    void disableVertexAttribArray(GLuint index);
    void enable(GLenum cap);
    void enableVertexAttribArray(GLuint index);
    void frontFace(GLenum mode);
    void hint(GLenum target, GLenum mode);
    void lineWidth(GLfloat width);
    void pixelStorei(GLenum pname, GLint param);
    void polygonOffset(GLfloat factor, GLfloat units);
    void sampleCoverage(GLclampf value, GLboolean invert);
    void scissor(GLint x, GLint y, GLsizei width, GLsizei height);
    void stencilFuncSeparate(GLenum face, GLenum func, GLint ref, GLuint mask);
    void stencilMaskSeparate(GLenum face, GLuint mask);
    void stencilOpSeparate(GLenum face, GLenum fail, GLenum zfail, GLenum zpass);
    void vertexAttrib1f(GLuint index, GLfloat x);
    void vertexAttrib1fv(GLuint index, const GLfloat *values);
    void vertexAttrib2f(GLuint index, GLfloat x, GLfloat y);
    void vertexAttrib2fv(GLuint index, const GLfloat *values);
    void vertexAttrib3f(GLuint index, GLfloat x, GLfloat y, GLfloat z);
    void vertexAttrib3fv(GLuint index, const GLfloat *values);
    void vertexAttrib4f(GLuint index, GLfloat x, GLfloat y, GLfloat z, GLfloat w);
    void vertexAttrib4fv(GLuint index, const GLfloat *values);
    void vertexAttribPointer(GLuint index,
                             GLint size,
                             GLenum type,
                             GLboolean normalized,
                             GLsizei stride,
                             const GLvoid *ptr);
    void viewport(GLint x, GLint y, GLsizei width, GLsizei height);

    void vertexAttribIPointer(GLuint index,
                              GLint size,
                              GLenum type,
                              GLsizei stride,
                              const GLvoid *pointer);
    void vertexAttribI4i(GLuint index, GLint x, GLint y, GLint z, GLint w);
    void vertexAttribI4ui(GLuint index, GLuint x, GLuint y, GLuint z, GLuint w);
    void vertexAttribI4iv(GLuint index, const GLint *v);
    void vertexAttribI4uiv(GLuint index, const GLuint *v);

    void debugMessageControl(GLenum source,
                             GLenum type,
                             GLenum severity,
                             GLsizei count,
                             const GLuint *ids,
                             GLboolean enabled);
    void debugMessageInsert(GLenum source,
                            GLenum type,
                            GLuint id,
                            GLenum severity,
                            GLsizei length,
                            const GLchar *buf);
    void debugMessageCallback(GLDEBUGPROCKHR callback, const void *userParam);
    GLuint getDebugMessageLog(GLuint count,
                              GLsizei bufSize,
                              GLenum *sources,
                              GLenum *types,
                              GLuint *ids,
                              GLenum *severities,
                              GLsizei *lengths,
                              GLchar *messageLog);
    void pushDebugGroup(GLenum source, GLuint id, GLsizei length, const GLchar *message);
    void popDebugGroup();

    void clear(GLbitfield mask);
    void clearBufferfv(GLenum buffer, GLint drawbuffer, const GLfloat *values);
    void clearBufferuiv(GLenum buffer, GLint drawbuffer, const GLuint *values);
    void clearBufferiv(GLenum buffer, GLint drawbuffer, const GLint *values);
    void clearBufferfi(GLenum buffer, GLint drawbuffer, GLfloat depth, GLint stencil);

    Error drawArrays(GLenum mode, GLint first, GLsizei count);
    Error drawArraysInstanced(GLenum mode, GLint first, GLsizei count, GLsizei instanceCount);

    Error drawElements(GLenum mode,
                       GLsizei count,
                       GLenum type,
                       const GLvoid *indices,
                       const IndexRange &indexRange);
    Error drawElementsInstanced(GLenum mode,
                                GLsizei count,
                                GLenum type,
                                const GLvoid *indices,
                                GLsizei instances,
                                const IndexRange &indexRange);
    Error drawRangeElements(GLenum mode,
                            GLuint start,
                            GLuint end,
                            GLsizei count,
                            GLenum type,
                            const GLvoid *indices,
                            const IndexRange &indexRange);

    void blitFramebuffer(GLint srcX0,
                         GLint srcY0,
                         GLint srcX1,
                         GLint srcY1,
                         GLint dstX0,
                         GLint dstY0,
                         GLint dstX1,
                         GLint dstY1,
                         GLbitfield mask,
                         GLenum filter);

    void readPixels(GLint x,
                    GLint y,
                    GLsizei width,
                    GLsizei height,
                    GLenum format,
                    GLenum type,
                    GLvoid *pixels);

    void copyTexImage2D(GLenum target,
                        GLint level,
                        GLenum internalformat,
                        GLint x,
                        GLint y,
                        GLsizei width,
                        GLsizei height,
                        GLint border);

    void copyTexSubImage2D(GLenum target,
                           GLint level,
                           GLint xoffset,
                           GLint yoffset,
                           GLint x,
                           GLint y,
                           GLsizei width,
                           GLsizei height);

    void copyTexSubImage3D(GLenum target,
                           GLint level,
                           GLint xoffset,
                           GLint yoffset,
                           GLint zoffset,
                           GLint x,
                           GLint y,
                           GLsizei width,
                           GLsizei height);

    void framebufferTexture2D(GLenum target,
                              GLenum attachment,
                              GLenum textarget,
                              GLuint texture,
                              GLint level);

    void framebufferRenderbuffer(GLenum target,
                                 GLenum attachment,
                                 GLenum renderbuffertarget,
                                 GLuint renderbuffer);

    void framebufferTextureLayer(GLenum target,
                                 GLenum attachment,
                                 GLuint texture,
                                 GLint level,
                                 GLint layer);

    void drawBuffers(GLsizei n, const GLenum *bufs);
    void readBuffer(GLenum mode);

    void discardFramebuffer(GLenum target, GLsizei numAttachments, const GLenum *attachments);
    void invalidateFramebuffer(GLenum target, GLsizei numAttachments, const GLenum *attachments);
    void invalidateSubFramebuffer(GLenum target,
                                  GLsizei numAttachments,
                                  const GLenum *attachments,
                                  GLint x,
                                  GLint y,
                                  GLsizei width,
                                  GLsizei height);

    void texImage2D(GLenum target,
                    GLint level,
                    GLint internalformat,
                    GLsizei width,
                    GLsizei height,
                    GLint border,
                    GLenum format,
                    GLenum type,
                    const GLvoid *pixels);
    void texImage3D(GLenum target,
                    GLint level,
                    GLint internalformat,
                    GLsizei width,
                    GLsizei height,
                    GLsizei depth,
                    GLint border,
                    GLenum format,
                    GLenum type,
                    const GLvoid *pixels);
    void texSubImage2D(GLenum target,
                       GLint level,
                       GLint xoffset,
                       GLint yoffset,
                       GLsizei width,
                       GLsizei height,
                       GLenum format,
                       GLenum type,
                       const GLvoid *pixels);
    void texSubImage3D(GLenum target,
                       GLint level,
                       GLint xoffset,
                       GLint yoffset,
                       GLint zoffset,
                       GLsizei width,
                       GLsizei height,
                       GLsizei depth,
                       GLenum format,
                       GLenum type,
                       const GLvoid *pixels);
    void compressedTexImage2D(GLenum target,
                              GLint level,
                              GLenum internalformat,
                              GLsizei width,
                              GLsizei height,
                              GLint border,
                              GLsizei imageSize,
                              const GLvoid *data);
    void compressedTexImage3D(GLenum target,
                              GLint level,
                              GLenum internalformat,
                              GLsizei width,
                              GLsizei height,
                              GLsizei depth,
                              GLint border,
                              GLsizei imageSize,
                              const GLvoid *data);
    void compressedTexSubImage2D(GLenum target,
                                 GLint level,
                                 GLint xoffset,
                                 GLint yoffset,
                                 GLsizei width,
                                 GLsizei height,
                                 GLenum format,
                                 GLsizei imageSize,
                                 const GLvoid *data);
    void compressedTexSubImage3D(GLenum target,
                                 GLint level,
                                 GLint xoffset,
                                 GLint yoffset,
                                 GLint zoffset,
                                 GLsizei width,
                                 GLsizei height,
                                 GLsizei depth,
                                 GLenum format,
                                 GLsizei imageSize,
                                 const GLvoid *data);
    void copyTextureCHROMIUM(GLuint sourceId,
                             GLuint destId,
                             GLint internalFormat,
                             GLenum destType,
                             GLboolean unpackFlipY,
                             GLboolean unpackPremultiplyAlpha,
                             GLboolean unpackUnmultiplyAlpha);
    void copySubTextureCHROMIUM(GLuint sourceId,
                                GLuint destId,
                                GLint xoffset,
                                GLint yoffset,
                                GLint x,
                                GLint y,
                                GLsizei width,
                                GLsizei height,
                                GLboolean unpackFlipY,
                                GLboolean unpackPremultiplyAlpha,
                                GLboolean unpackUnmultiplyAlpha);
    void compressedCopyTextureCHROMIUM(GLuint sourceId, GLuint destId);

    void generateMipmap(GLenum target);

    Error flush();
    Error finish();

    void getBufferPointerv(GLenum target, GLenum pname, void **params);
    GLvoid *mapBuffer(GLenum target, GLenum access);
    GLboolean unmapBuffer(GLenum target);
    GLvoid *mapBufferRange(GLenum target, GLintptr offset, GLsizeiptr length, GLbitfield access);
    void flushMappedBufferRange(GLenum target, GLintptr offset, GLsizeiptr length);

    void beginTransformFeedback(GLenum primitiveMode);

    bool hasActiveTransformFeedback(GLuint program) const;

    void insertEventMarker(GLsizei length, const char *marker);
    void pushGroupMarker(GLsizei length, const char *marker);
    void popGroupMarker();

    void bindUniformLocation(GLuint program, GLint location, const GLchar *name);

    // CHROMIUM_framebuffer_mixed_samples
    void setCoverageModulation(GLenum components);

    // CHROMIUM_path_rendering
    void loadPathRenderingMatrix(GLenum matrixMode, const GLfloat *matrix);
    void loadPathRenderingIdentityMatrix(GLenum matrixMode);
    void stencilFillPath(GLuint path, GLenum fillMode, GLuint mask);
    void stencilStrokePath(GLuint path, GLint reference, GLuint mask);
    void coverFillPath(GLuint path, GLenum coverMode);
    void coverStrokePath(GLuint path, GLenum coverMode);
    void stencilThenCoverFillPath(GLuint path, GLenum fillMode, GLuint mask, GLenum coverMode);
    void stencilThenCoverStrokePath(GLuint path, GLint reference, GLuint mask, GLenum coverMode);
    void coverFillPathInstanced(GLsizei numPaths,
                                GLenum pathNameType,
                                const void *paths,
                                GLuint pathBase,
                                GLenum coverMode,
                                GLenum transformType,
                                const GLfloat *transformValues);
    void coverStrokePathInstanced(GLsizei numPaths,
                                  GLenum pathNameType,
                                  const void *paths,
                                  GLuint pathBase,
                                  GLenum coverMode,
                                  GLenum transformType,
                                  const GLfloat *transformValues);
    void stencilFillPathInstanced(GLsizei numPaths,
                                  GLenum pathNameType,
                                  const void *paths,
                                  GLuint pathBAse,
                                  GLenum fillMode,
                                  GLuint mask,
                                  GLenum transformType,
                                  const GLfloat *transformValues);
    void stencilStrokePathInstanced(GLsizei numPaths,
                                    GLenum pathNameType,
                                    const void *paths,
                                    GLuint pathBase,
                                    GLint reference,
                                    GLuint mask,
                                    GLenum transformType,
                                    const GLfloat *transformValues);
    void stencilThenCoverFillPathInstanced(GLsizei numPaths,
                                           GLenum pathNameType,
                                           const void *paths,
                                           GLuint pathBase,
                                           GLenum fillMode,
                                           GLuint mask,
                                           GLenum coverMode,
                                           GLenum transformType,
                                           const GLfloat *transformValues);
    void stencilThenCoverStrokePathInstanced(GLsizei numPaths,
                                             GLenum pathNameType,
                                             const void *paths,
                                             GLuint pathBase,
                                             GLint reference,
                                             GLuint mask,
                                             GLenum coverMode,
                                             GLenum transformType,
                                             const GLfloat *transformValues);
    void bindFragmentInputLocation(GLuint program, GLint location, const GLchar *name);
    void programPathFragmentInputGen(GLuint program,
                                     GLint location,
                                     GLenum genMode,
                                     GLint components,
                                     const GLfloat *coeffs);

    void bufferData(GLenum target, GLsizeiptr size, const GLvoid *data, GLenum usage);
    void bufferSubData(GLenum target, GLintptr offset, GLsizeiptr size, const GLvoid *data);
    void attachShader(GLuint program, GLuint shader);
    void bindAttribLocation(GLuint program, GLuint index, const GLchar *name);
    void bindBuffer(GLenum target, GLuint buffer);
    void bindFramebuffer(GLenum target, GLuint framebuffer);
    void bindRenderbuffer(GLenum target, GLuint renderbuffer);

    void copyBufferSubData(GLenum readTarget,
                           GLenum writeTarget,
                           GLintptr readOffset,
                           GLintptr writeOffset,
                           GLsizeiptr size);

    void handleError(const Error &error) override;

    GLenum getError();
    void markContextLost();
    bool isContextLost();
    GLenum getResetStatus();
    bool isResetNotificationEnabled();

    const egl::Config *getConfig() const;
    EGLenum getClientType() const;
    EGLenum getRenderBuffer() const;

    const GLubyte *getString(GLenum name) const;
    const GLubyte *getStringi(GLenum name, GLuint index) const;

    size_t getExtensionStringCount() const;

    void requestExtension(const char *name);
    size_t getRequestableExtensionStringCount() const;

    rx::ContextImpl *getImplementation() const { return mImplementation.get(); }
    const Workarounds &getWorkarounds() const;

  private:
    void syncRendererState();
    void syncRendererState(const State::DirtyBits &bitMask, const State::DirtyObjects &objectMask);
    void syncStateForReadPixels();
    void syncStateForTexImage();
    void syncStateForClear();
    void syncStateForBlit();
    VertexArray *checkVertexArrayAllocation(GLuint vertexArrayHandle);
    TransformFeedback *checkTransformFeedbackAllocation(GLuint transformFeedback);
    Framebuffer *checkFramebufferAllocation(GLuint framebufferHandle);

    void detachBuffer(GLuint buffer);
    void detachTexture(GLuint texture);
    void detachFramebuffer(GLuint framebuffer);
    void detachRenderbuffer(GLuint renderbuffer);
    void detachVertexArray(GLuint vertexArray);
    void detachTransformFeedback(GLuint transformFeedback);
    void detachSampler(GLuint sampler);

    void initRendererString();
    void initVersionStrings();
    void initExtensionStrings();

    void initCaps(bool webGLContext);
    void updateCaps();
    void initWorkarounds();

    LabeledObject *getLabeledObject(GLenum identifier, GLuint name) const;
    LabeledObject *getLabeledObjectFromPtr(const void *ptr) const;

    std::unique_ptr<rx::ContextImpl> mImplementation;

    // Caps to use for validation
    Caps mCaps;
    TextureCapsMap mTextureCaps;
    Extensions mExtensions;
    Limitations mLimitations;

    // Shader compiler
    Compiler *mCompiler;

    State mGLState;

    const egl::Config *mConfig;
    EGLenum mClientType;

    TextureMap mZeroTextures;

    ResourceMap<Framebuffer> mFramebufferMap;
    HandleAllocator mFramebufferHandleAllocator;

    ResourceMap<FenceNV> mFenceNVMap;
    HandleAllocator mFenceNVHandleAllocator;

    ResourceMap<Query> mQueryMap;
    HandleAllocator mQueryHandleAllocator;

    ResourceMap<VertexArray> mVertexArrayMap;
    HandleAllocator mVertexArrayHandleAllocator;

    ResourceMap<TransformFeedback> mTransformFeedbackMap;
    HandleAllocator mTransformFeedbackAllocator;

    const char *mVersionString;
    const char *mShadingLanguageString;
    const char *mRendererString;
    const char *mExtensionString;
    std::vector<const char *> mExtensionStrings;
    const char *mRequestableExtensionString;
    std::vector<const char *> mRequestableExtensionStrings;

    // Recorded errors
    typedef std::set<GLenum> ErrorSet;
    ErrorSet mErrors;

    // Current/lost context flags
    bool mHasBeenCurrent;
    bool mContextLost;
    GLenum mResetStatus;
    bool mContextLostForced;
    GLenum mResetStrategy;
    bool mRobustAccess;
    egl::Surface *mCurrentSurface;

    ResourceManager *mResourceManager;

    State::DirtyBits mTexImageDirtyBits;
    State::DirtyObjects mTexImageDirtyObjects;
    State::DirtyBits mReadPixelsDirtyBits;
    State::DirtyObjects mReadPixelsDirtyObjects;
    State::DirtyBits mClearDirtyBits;
    State::DirtyObjects mClearDirtyObjects;
    State::DirtyBits mBlitDirtyBits;
    State::DirtyObjects mBlitDirtyObjects;

    Workarounds mWorkarounds;
};

}  // namespace gl

#endif   // LIBANGLE_CONTEXT_H_
