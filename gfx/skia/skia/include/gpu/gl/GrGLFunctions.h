
/*
 * Copyright 2012 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#ifndef GrGLFunctions_DEFINED
#define GrGLFunctions_DEFINED

#include <functional>
#include "GrGLTypes.h"
#include "../private/SkTLogic.h"

extern "C" {

///////////////////////////////////////////////////////////////////////////////

typedef GrGLvoid (* GrGLActiveTextureProc)(GrGLenum texture);
typedef GrGLvoid (* GrGLAttachShaderProc)(GrGLuint program, GrGLuint shader);
typedef GrGLvoid (* GrGLBeginQueryProc)(GrGLenum target, GrGLuint id);
typedef GrGLvoid (* GrGLBindAttribLocationProc)(GrGLuint program, GrGLuint index, const char* name);
typedef GrGLvoid (* GrGLBindBufferProc)(GrGLenum target, GrGLuint buffer);
typedef GrGLvoid (* GrGLBindFramebufferProc)(GrGLenum target, GrGLuint framebuffer);
typedef GrGLvoid (* GrGLBindRenderbufferProc)(GrGLenum target, GrGLuint renderbuffer);
typedef GrGLvoid (* GrGLBindTextureProc)(GrGLenum target, GrGLuint texture);
typedef GrGLvoid (* GrGLBindFragDataLocationProc)(GrGLuint program, GrGLuint colorNumber, const GrGLchar* name);
typedef GrGLvoid (* GrGLBindFragDataLocationIndexedProc)(GrGLuint program, GrGLuint colorNumber, GrGLuint index, const GrGLchar * name);
typedef GrGLvoid (* GrGLBindVertexArrayProc)(GrGLuint array);
typedef GrGLvoid (* GrGLBlendBarrierProc)();
typedef GrGLvoid (* GrGLBlendColorProc)(GrGLclampf red, GrGLclampf green, GrGLclampf blue, GrGLclampf alpha);
typedef GrGLvoid (* GrGLBlendEquationProc)(GrGLenum mode);
typedef GrGLvoid (* GrGLBlendFuncProc)(GrGLenum sfactor, GrGLenum dfactor);
typedef GrGLvoid (* GrGLBlitFramebufferProc)(GrGLint srcX0, GrGLint srcY0, GrGLint srcX1, GrGLint srcY1, GrGLint dstX0, GrGLint dstY0, GrGLint dstX1, GrGLint dstY1, GrGLbitfield mask, GrGLenum filter);
typedef GrGLvoid (* GrGLBufferDataProc)(GrGLenum target, GrGLsizeiptr size, const GrGLvoid* data, GrGLenum usage);
typedef GrGLvoid (* GrGLBufferSubDataProc)(GrGLenum target, GrGLintptr offset, GrGLsizeiptr size, const GrGLvoid* data);
typedef GrGLenum (* GrGLCheckFramebufferStatusProc)(GrGLenum target);
typedef GrGLvoid (* GrGLClearProc)(GrGLbitfield mask);
typedef GrGLvoid (* GrGLClearColorProc)(GrGLclampf red, GrGLclampf green, GrGLclampf blue, GrGLclampf alpha);
typedef GrGLvoid (* GrGLClearStencilProc)(GrGLint s);
typedef GrGLvoid (* GrGLClearTexImageProc)(GrGLuint texture, GrGLint level, GrGLenum format, GrGLenum type,const GrGLvoid * data);
typedef GrGLvoid (* GrGLClearTexSubImageProc)(GrGLuint texture, GrGLint level, GrGLint xoffset, GrGLint yoffset, GrGLint zoffset, GrGLsizei width, GrGLsizei height, GrGLsizei depth, GrGLenum format, GrGLenum type,const GrGLvoid * data);
typedef GrGLvoid (* GrGLColorMaskProc)(GrGLboolean red, GrGLboolean green, GrGLboolean blue, GrGLboolean alpha);
typedef GrGLvoid (* GrGLCompileShaderProc)(GrGLuint shader);
typedef GrGLvoid (* GrGLCompressedTexImage2DProc)(GrGLenum target, GrGLint level, GrGLenum internalformat, GrGLsizei width, GrGLsizei height, GrGLint border, GrGLsizei imageSize, const GrGLvoid* data);
typedef GrGLvoid (* GrGLCompressedTexSubImage2DProc)(GrGLenum target, GrGLint level, GrGLint xoffset, GrGLint yoffset, GrGLsizei width, GrGLsizei height, GrGLenum format, GrGLsizei imageSize, const GrGLvoid* data);
typedef GrGLvoid (* GrGLCopyTexSubImage2DProc)(GrGLenum target, GrGLint level, GrGLint xoffset, GrGLint yoffset, GrGLint x, GrGLint y, GrGLsizei width, GrGLsizei height);
typedef GrGLuint (* GrGLCreateProgramProc)();
typedef GrGLuint (* GrGLCreateShaderProc)(GrGLenum type);
typedef GrGLvoid (* GrGLCullFaceProc)(GrGLenum mode);
typedef GrGLvoid (* GrGLDeleteBuffersProc)(GrGLsizei n, const GrGLuint* buffers);
typedef GrGLvoid (* GrGLDeleteFramebuffersProc)(GrGLsizei n, const GrGLuint *framebuffers);
typedef GrGLvoid (* GrGLDeleteProgramProc)(GrGLuint program);
typedef GrGLvoid (* GrGLDeleteQueriesProc)(GrGLsizei n, const GrGLuint *ids);
typedef GrGLvoid (* GrGLDeleteRenderbuffersProc)(GrGLsizei n, const GrGLuint *renderbuffers);
typedef GrGLvoid (* GrGLDeleteShaderProc)(GrGLuint shader);
typedef GrGLvoid (* GrGLDeleteTexturesProc)(GrGLsizei n, const GrGLuint* textures);
typedef GrGLvoid (* GrGLDeleteVertexArraysProc)(GrGLsizei n, const GrGLuint *arrays);
typedef GrGLvoid (* GrGLDepthMaskProc)(GrGLboolean flag);
typedef GrGLvoid (* GrGLDisableProc)(GrGLenum cap);
typedef GrGLvoid (* GrGLDisableVertexAttribArrayProc)(GrGLuint index);
typedef GrGLvoid (* GrGLDrawArraysProc)(GrGLenum mode, GrGLint first, GrGLsizei count);
typedef GrGLvoid (* GrGLDrawArraysInstancedProc)(GrGLenum mode, GrGLint first, GrGLsizei count, GrGLsizei primcount);
typedef GrGLvoid (* GrGLDrawArraysIndirectProc)(GrGLenum mode, const GrGLvoid* indirect);
typedef GrGLvoid (* GrGLDrawBufferProc)(GrGLenum mode);
typedef GrGLvoid (* GrGLDrawBuffersProc)(GrGLsizei n, const GrGLenum* bufs);
typedef GrGLvoid (* GrGLDrawElementsProc)(GrGLenum mode, GrGLsizei count, GrGLenum type, const GrGLvoid* indices);
typedef GrGLvoid (* GrGLDrawElementsInstancedProc)(GrGLenum mode, GrGLsizei count, GrGLenum type, const GrGLvoid *indices, GrGLsizei primcount);
typedef GrGLvoid (* GrGLDrawElementsIndirectProc)(GrGLenum mode, GrGLenum type, const GrGLvoid* indirect);
typedef GrGLvoid (* GrGLDrawRangeElementsProc)(GrGLenum mode, GrGLuint start, GrGLuint end, GrGLsizei count, GrGLenum type, const GrGLvoid* indices);
typedef GrGLvoid (* GrGLEnableProc)(GrGLenum cap);
typedef GrGLvoid (* GrGLEnableVertexAttribArrayProc)(GrGLuint index);
typedef GrGLvoid (* GrGLEndQueryProc)(GrGLenum target);
typedef GrGLvoid (* GrGLFinishProc)();
typedef GrGLvoid (* GrGLFlushProc)();
typedef GrGLvoid (* GrGLFlushMappedBufferRangeProc)(GrGLenum target, GrGLintptr offset, GrGLsizeiptr length);
typedef GrGLvoid (* GrGLFramebufferRenderbufferProc)(GrGLenum target, GrGLenum attachment, GrGLenum renderbuffertarget, GrGLuint renderbuffer);
typedef GrGLvoid (* GrGLFramebufferTexture2DProc)(GrGLenum target, GrGLenum attachment, GrGLenum textarget, GrGLuint texture, GrGLint level);
typedef GrGLvoid (* GrGLFramebufferTexture2DMultisampleProc)(GrGLenum target, GrGLenum attachment, GrGLenum textarget, GrGLuint texture, GrGLint level, GrGLsizei samples);
typedef GrGLvoid (* GrGLFrontFaceProc)(GrGLenum mode);
typedef GrGLvoid (* GrGLGenBuffersProc)(GrGLsizei n, GrGLuint* buffers);
typedef GrGLvoid (* GrGLGenFramebuffersProc)(GrGLsizei n, GrGLuint *framebuffers);
typedef GrGLvoid (* GrGLGenerateMipmapProc)(GrGLenum target);
typedef GrGLvoid (* GrGLGenQueriesProc)(GrGLsizei n, GrGLuint *ids);
typedef GrGLvoid (* GrGLGenRenderbuffersProc)(GrGLsizei n, GrGLuint *renderbuffers);
typedef GrGLvoid (* GrGLGenTexturesProc)(GrGLsizei n, GrGLuint* textures);
typedef GrGLvoid (* GrGLGenVertexArraysProc)(GrGLsizei n, GrGLuint *arrays);
typedef GrGLvoid (* GrGLGetBufferParameterivProc)(GrGLenum target, GrGLenum pname, GrGLint* params);
typedef GrGLenum (* GrGLGetErrorProc)();
typedef GrGLvoid (* GrGLGetFramebufferAttachmentParameterivProc)(GrGLenum target, GrGLenum attachment, GrGLenum pname, GrGLint* params);
typedef GrGLvoid (* GrGLGetIntegervProc)(GrGLenum pname, GrGLint* params);
typedef GrGLvoid (* GrGLGetMultisamplefvProc)(GrGLenum pname, GrGLuint index, GrGLfloat* val);
typedef GrGLvoid (* GrGLGetProgramBinaryProc)(GrGLuint program, GrGLsizei bufsize, GrGLsizei* length, GrGLenum *binaryFormat, void *binary);
typedef GrGLvoid (* GrGLGetProgramInfoLogProc)(GrGLuint program, GrGLsizei bufsize, GrGLsizei* length, char* infolog);
typedef GrGLvoid (* GrGLGetProgramivProc)(GrGLuint program, GrGLenum pname, GrGLint* params);
typedef GrGLvoid (* GrGLGetQueryivProc)(GrGLenum GLtarget, GrGLenum pname, GrGLint *params);
typedef GrGLvoid (* GrGLGetQueryObjecti64vProc)(GrGLuint id, GrGLenum pname, GrGLint64 *params);
typedef GrGLvoid (* GrGLGetQueryObjectivProc)(GrGLuint id, GrGLenum pname, GrGLint *params);
typedef GrGLvoid (* GrGLGetQueryObjectui64vProc)(GrGLuint id, GrGLenum pname, GrGLuint64 *params);
typedef GrGLvoid (* GrGLGetQueryObjectuivProc)(GrGLuint id, GrGLenum pname, GrGLuint *params);
typedef GrGLvoid (* GrGLGetRenderbufferParameterivProc)(GrGLenum target, GrGLenum pname, GrGLint* params);
typedef GrGLvoid (* GrGLGetShaderInfoLogProc)(GrGLuint shader, GrGLsizei bufsize, GrGLsizei* length, char* infolog);
typedef GrGLvoid (* GrGLGetShaderivProc)(GrGLuint shader, GrGLenum pname, GrGLint* params);
typedef GrGLvoid (* GrGLGetShaderPrecisionFormatProc)(GrGLenum shadertype, GrGLenum precisiontype, GrGLint *range, GrGLint *precision);
typedef const GrGLubyte* (* GrGLGetStringProc)(GrGLenum name);
typedef const GrGLubyte* (* GrGLGetStringiProc)(GrGLenum name, GrGLuint index);
typedef GrGLvoid (* GrGLGetTexLevelParameterivProc)(GrGLenum target, GrGLint level, GrGLenum pname, GrGLint* params);
typedef GrGLint (* GrGLGetUniformLocationProc)(GrGLuint program, const char* name);
typedef GrGLvoid (* GrGLInsertEventMarkerProc)(GrGLsizei length, const char* marker);
typedef GrGLvoid (* GrGLInvalidateBufferDataProc)(GrGLuint buffer);
typedef GrGLvoid (* GrGLInvalidateBufferSubDataProc)(GrGLuint buffer, GrGLintptr offset, GrGLsizeiptr length);
typedef GrGLvoid (* GrGLInvalidateFramebufferProc)(GrGLenum target, GrGLsizei numAttachments,  const GrGLenum *attachments);
typedef GrGLvoid (* GrGLInvalidateSubFramebufferProc)(GrGLenum target, GrGLsizei numAttachments, const GrGLenum *attachments, GrGLint x, GrGLint y, GrGLsizei width, GrGLsizei height);
typedef GrGLvoid (* GrGLInvalidateTexImageProc)(GrGLuint texture, GrGLint level);
typedef GrGLvoid (* GrGLInvalidateTexSubImageProc)(GrGLuint texture, GrGLint level, GrGLint xoffset, GrGLint yoffset, GrGLint zoffset, GrGLsizei width, GrGLsizei height, GrGLsizei depth);
typedef GrGLboolean (* GrGLIsTextureProc)(GrGLuint texture);
typedef GrGLvoid (* GrGLLineWidthProc)(GrGLfloat width);
typedef GrGLvoid (* GrGLLinkProgramProc)(GrGLuint program);
typedef GrGLvoid* (* GrGLMapBufferProc)(GrGLenum target, GrGLenum access);
typedef GrGLvoid* (* GrGLMapBufferRangeProc)(GrGLenum target, GrGLintptr offset, GrGLsizeiptr length, GrGLbitfield access);
typedef GrGLvoid* (* GrGLMapBufferSubDataProc)(GrGLuint target, GrGLintptr offset, GrGLsizeiptr size, GrGLenum access);
typedef GrGLvoid* (* GrGLMapTexSubImage2DProc)(GrGLenum target, GrGLint level, GrGLint xoffset, GrGLint yoffset, GrGLsizei width, GrGLsizei height, GrGLenum format, GrGLenum type, GrGLenum access);
typedef GrGLvoid (* GrGLPixelStoreiProc)(GrGLenum pname, GrGLint param);
typedef GrGLvoid (* GrGLPolygonModeProc)(GrGLenum face, GrGLenum mode);
typedef GrGLvoid (* GrGLPopGroupMarkerProc)();
typedef GrGLvoid (* GrGLProgramBinaryProc)(GrGLuint program, GrGLenum binaryFormat, void *binary, GrGLsizei length);
typedef GrGLvoid (* GrGLProgramParameteriProc)(GrGLuint program, GrGLenum pname, GrGLint value);
typedef GrGLvoid (* GrGLPushGroupMarkerProc)(GrGLsizei length, const char* marker);
typedef GrGLvoid (* GrGLQueryCounterProc)(GrGLuint id, GrGLenum target);
typedef GrGLvoid (* GrGLRasterSamplesProc)(GrGLuint samples, GrGLboolean fixedsamplelocations);
typedef GrGLvoid (* GrGLReadBufferProc)(GrGLenum src);
typedef GrGLvoid (* GrGLReadPixelsProc)(GrGLint x, GrGLint y, GrGLsizei width, GrGLsizei height, GrGLenum format, GrGLenum type, GrGLvoid* pixels);
typedef GrGLvoid (* GrGLRenderbufferStorageProc)(GrGLenum target, GrGLenum internalformat, GrGLsizei width, GrGLsizei height);
typedef GrGLvoid (* GrGLRenderbufferStorageMultisampleProc)(GrGLenum target, GrGLsizei samples, GrGLenum internalformat, GrGLsizei width, GrGLsizei height);
typedef GrGLvoid (* GrGLResolveMultisampleFramebufferProc)();
typedef GrGLvoid (* GrGLScissorProc)(GrGLint x, GrGLint y, GrGLsizei width, GrGLsizei height);
// GL_CHROMIUM_bind_uniform_location
typedef GrGLvoid (* GrGLBindUniformLocationProc)(GrGLuint program, GrGLint location, const char* name);

#if GR_GL_USE_NEW_SHADER_SOURCE_SIGNATURE
typedef GrGLvoid (* GrGLShaderSourceProc)(GrGLuint shader, GrGLsizei count, const char* const * str, const GrGLint* length);
#else
typedef GrGLvoid (* GrGLShaderSourceProc)(GrGLuint shader, GrGLsizei count, const char** str, const GrGLint* length);
#endif
typedef GrGLvoid (* GrGLStencilFuncProc)(GrGLenum func, GrGLint ref, GrGLuint mask);
typedef GrGLvoid (* GrGLStencilFuncSeparateProc)(GrGLenum face, GrGLenum func, GrGLint ref, GrGLuint mask);
typedef GrGLvoid (* GrGLStencilMaskProc)(GrGLuint mask);
typedef GrGLvoid (* GrGLStencilMaskSeparateProc)(GrGLenum face, GrGLuint mask);
typedef GrGLvoid (* GrGLStencilOpProc)(GrGLenum fail, GrGLenum zfail, GrGLenum zpass);
typedef GrGLvoid (* GrGLStencilOpSeparateProc)(GrGLenum face, GrGLenum fail, GrGLenum zfail, GrGLenum zpass);
typedef GrGLvoid (* GrGLTexBufferProc)(GrGLenum target, GrGLenum internalformat, GrGLuint buffer);
typedef GrGLvoid (* GrGLTexBufferRangeProc)(GrGLenum target, GrGLenum internalformat, GrGLuint buffer, GrGLintptr offset, GrGLsizeiptr size);
typedef GrGLvoid (* GrGLTexImage2DProc)(GrGLenum target, GrGLint level, GrGLint internalformat, GrGLsizei width, GrGLsizei height, GrGLint border, GrGLenum format, GrGLenum type, const GrGLvoid* pixels);
typedef GrGLvoid (* GrGLTexParameteriProc)(GrGLenum target, GrGLenum pname, GrGLint param);
typedef GrGLvoid (* GrGLTexParameterivProc)(GrGLenum target, GrGLenum pname, const GrGLint* params);
typedef GrGLvoid (* GrGLTexStorage2DProc)(GrGLenum target, GrGLsizei levels, GrGLenum internalformat, GrGLsizei width, GrGLsizei height);
typedef GrGLvoid (* GrGLDiscardFramebufferProc)(GrGLenum target, GrGLsizei numAttachments, const GrGLenum* attachments);
typedef GrGLvoid (* GrGLTexSubImage2DProc)(GrGLenum target, GrGLint level, GrGLint xoffset, GrGLint yoffset, GrGLsizei width, GrGLsizei height, GrGLenum format, GrGLenum type, const GrGLvoid* pixels);
typedef GrGLvoid (* GrGLTextureBarrierProc)();
typedef GrGLvoid (* GrGLUniform1fProc)(GrGLint location, GrGLfloat v0);
typedef GrGLvoid (* GrGLUniform1iProc)(GrGLint location, GrGLint v0);
typedef GrGLvoid (* GrGLUniform1fvProc)(GrGLint location, GrGLsizei count, const GrGLfloat* v);
typedef GrGLvoid (* GrGLUniform1ivProc)(GrGLint location, GrGLsizei count, const GrGLint* v);
typedef GrGLvoid (* GrGLUniform2fProc)(GrGLint location, GrGLfloat v0, GrGLfloat v1);
typedef GrGLvoid (* GrGLUniform2iProc)(GrGLint location, GrGLint v0, GrGLint v1);
typedef GrGLvoid (* GrGLUniform2fvProc)(GrGLint location, GrGLsizei count, const GrGLfloat* v);
typedef GrGLvoid (* GrGLUniform2ivProc)(GrGLint location, GrGLsizei count, const GrGLint* v);
typedef GrGLvoid (* GrGLUniform3fProc)(GrGLint location, GrGLfloat v0, GrGLfloat v1, GrGLfloat v2);
typedef GrGLvoid (* GrGLUniform3iProc)(GrGLint location, GrGLint v0, GrGLint v1, GrGLint v2);
typedef GrGLvoid (* GrGLUniform3fvProc)(GrGLint location, GrGLsizei count, const GrGLfloat* v);
typedef GrGLvoid (* GrGLUniform3ivProc)(GrGLint location, GrGLsizei count, const GrGLint* v);
typedef GrGLvoid (* GrGLUniform4fProc)(GrGLint location, GrGLfloat v0, GrGLfloat v1, GrGLfloat v2, GrGLfloat v3);
typedef GrGLvoid (* GrGLUniform4iProc)(GrGLint location, GrGLint v0, GrGLint v1, GrGLint v2, GrGLint v3);
typedef GrGLvoid (* GrGLUniform4fvProc)(GrGLint location, GrGLsizei count, const GrGLfloat* v);
typedef GrGLvoid (* GrGLUniform4ivProc)(GrGLint location, GrGLsizei count, const GrGLint* v);
typedef GrGLvoid (* GrGLUniformMatrix2fvProc)(GrGLint location, GrGLsizei count, GrGLboolean transpose, const GrGLfloat* value);
typedef GrGLvoid (* GrGLUniformMatrix3fvProc)(GrGLint location, GrGLsizei count, GrGLboolean transpose, const GrGLfloat* value);
typedef GrGLvoid (* GrGLUniformMatrix4fvProc)(GrGLint location, GrGLsizei count, GrGLboolean transpose, const GrGLfloat* value);
typedef GrGLboolean (* GrGLUnmapBufferProc)(GrGLenum target);
typedef GrGLvoid (* GrGLUnmapBufferSubDataProc)(const GrGLvoid* mem);
typedef GrGLvoid (* GrGLUnmapTexSubImage2DProc)(const GrGLvoid* mem);
typedef GrGLvoid (* GrGLUseProgramProc)(GrGLuint program);
typedef GrGLvoid (* GrGLVertexAttrib1fProc)(GrGLuint indx, const GrGLfloat value);
typedef GrGLvoid (* GrGLVertexAttrib2fvProc)(GrGLuint indx, const GrGLfloat* values);
typedef GrGLvoid (* GrGLVertexAttrib3fvProc)(GrGLuint indx, const GrGLfloat* values);
typedef GrGLvoid (* GrGLVertexAttrib4fvProc)(GrGLuint indx, const GrGLfloat* values);
typedef GrGLvoid (* GrGLVertexAttribDivisorProc)(GrGLuint index, GrGLuint divisor);
typedef GrGLvoid (* GrGLVertexAttribIPointerProc)(GrGLuint indx, GrGLint size, GrGLenum type, GrGLsizei stride, const GrGLvoid* ptr);
typedef GrGLvoid (* GrGLVertexAttribPointerProc)(GrGLuint indx, GrGLint size, GrGLenum type, GrGLboolean normalized, GrGLsizei stride, const GrGLvoid* ptr);
typedef GrGLvoid (* GrGLViewportProc)(GrGLint x, GrGLint y, GrGLsizei width, GrGLsizei height);

/* GL_NV_path_rendering */
typedef GrGLvoid (* GrGLMatrixLoadfProc)(GrGLenum matrixMode, const GrGLfloat* m);
typedef GrGLvoid (* GrGLMatrixLoadIdentityProc)(GrGLenum);
typedef GrGLvoid (* GrGLPathCommandsProc)(GrGLuint path, GrGLsizei numCommands, const GrGLubyte *commands, GrGLsizei numCoords, GrGLenum coordType, const GrGLvoid *coords);
typedef GrGLvoid (* GrGLPathParameteriProc)(GrGLuint path, GrGLenum pname, GrGLint value);
typedef GrGLvoid (* GrGLPathParameterfProc)(GrGLuint path, GrGLenum pname, GrGLfloat value);
typedef GrGLuint (* GrGLGenPathsProc)(GrGLsizei range);
typedef GrGLvoid (* GrGLDeletePathsProc)(GrGLuint path, GrGLsizei range);
typedef GrGLboolean (* GrGLIsPathProc)(GrGLuint path);
typedef GrGLvoid (* GrGLPathStencilFuncProc)(GrGLenum func, GrGLint ref, GrGLuint mask);
typedef GrGLvoid (* GrGLStencilFillPathProc)(GrGLuint path, GrGLenum fillMode, GrGLuint mask);
typedef GrGLvoid (* GrGLStencilStrokePathProc)(GrGLuint path, GrGLint reference, GrGLuint mask);
typedef GrGLvoid (* GrGLStencilFillPathInstancedProc)(GrGLsizei numPaths, GrGLenum pathNameType, const GrGLvoid *paths, GrGLuint pathBase, GrGLenum fillMode, GrGLuint mask, GrGLenum transformType, const GrGLfloat *transformValues);
typedef GrGLvoid (* GrGLStencilStrokePathInstancedProc)(GrGLsizei numPaths, GrGLenum pathNameType, const GrGLvoid *paths, GrGLuint pathBase, GrGLint reference, GrGLuint mask, GrGLenum transformType, const GrGLfloat *transformValues);
typedef GrGLvoid (* GrGLCoverFillPathProc)(GrGLuint path, GrGLenum coverMode);
typedef GrGLvoid (* GrGLCoverStrokePathProc)(GrGLuint name, GrGLenum coverMode);
typedef GrGLvoid (* GrGLCoverFillPathInstancedProc)(GrGLsizei numPaths, GrGLenum pathNameType, const GrGLvoid *paths, GrGLuint pathBase, GrGLenum coverMode, GrGLenum transformType, const GrGLfloat *transformValues);
typedef GrGLvoid (* GrGLCoverStrokePathInstancedProc)(GrGLsizei numPaths, GrGLenum pathNameType, const GrGLvoid *paths, GrGLuint pathBase, GrGLenum coverMode, GrGLenum transformType, const GrGLfloat* transformValues);
// NV_path_rendering v1.2
typedef GrGLvoid (* GrGLStencilThenCoverFillPathProc)(GrGLuint path, GrGLenum fillMode, GrGLuint mask, GrGLenum coverMode);
typedef GrGLvoid (* GrGLStencilThenCoverStrokePathProc)(GrGLuint path, GrGLint reference, GrGLuint mask, GrGLenum coverMode);
typedef GrGLvoid (* GrGLStencilThenCoverFillPathInstancedProc)(GrGLsizei numPaths, GrGLenum pathNameType, const GrGLvoid *paths, GrGLuint pathBase, GrGLenum fillMode, GrGLuint mask, GrGLenum coverMode, GrGLenum transformType, const GrGLfloat *transformValues);
typedef GrGLvoid (* GrGLStencilThenCoverStrokePathInstancedProc)(GrGLsizei numPaths, GrGLenum pathNameType, const GrGLvoid *paths, GrGLuint pathBase, GrGLint reference, GrGLuint mask, GrGLenum coverMode, GrGLenum transformType, const GrGLfloat *transformValues);
// NV_path_rendering v1.3
typedef GrGLvoid (* GrGLProgramPathFragmentInputGenProc)(GrGLuint program, GrGLint location, GrGLenum genMode, GrGLint components,const GrGLfloat *coeffs);
// CHROMIUM_path_rendering
typedef GrGLvoid (* GrGLBindFragmentInputLocationProc)(GrGLuint program, GrGLint location, const GrGLchar* name);

/* ARB_program_interface_query */
typedef GrGLint (* GrGLGetProgramResourceLocationProc)(GrGLuint program, GrGLenum programInterface, const GrGLchar *name);

/* GL_NV_framebuffer_mixed_samples */
typedef GrGLvoid (* GrGLCoverageModulationProc)(GrGLenum components);

/* EXT_multi_draw_indirect */
typedef GrGLvoid (* GrGLMultiDrawArraysIndirectProc)(GrGLenum mode, const GrGLvoid *indirect, GrGLsizei drawcount, GrGLsizei stride);
typedef GrGLvoid (* GrGLMultiDrawElementsIndirectProc)(GrGLenum mode, GrGLenum type, const GrGLvoid *indirect, GrGLsizei drawcount, GrGLsizei stride);

/* ARB_sample_shading */
typedef GrGLvoid (* GrGLMinSampleShadingProc)(GrGLfloat value);

/* ARB_sync */
typedef GrGLsync (* GrGLFenceSyncProc)(GrGLenum condition, GrGLbitfield flags);
typedef GrGLboolean (* GrGLIsSyncProc)(GrGLsync sync);
typedef GrGLenum (* GrGLClientWaitSyncProc)(GrGLsync sync, GrGLbitfield flags, GrGLuint64 timeout);
typedef GrGLvoid (* GrGLWaitSyncProc)(GrGLsync sync, GrGLbitfield flags, GrGLuint64 timeout);
typedef GrGLvoid (* GrGLDeleteSyncProc)(GrGLsync sync);

/* ARB_internalformat_query */
typedef GrGLvoid (* GrGLGetInternalformativProc)(GrGLenum target, GrGLenum internalformat, GrGLenum pname, GrGLsizei bufSize, GrGLint *params);

/* KHR_debug */
typedef GrGLvoid (* GrGLDebugMessageControlProc)(GrGLenum source, GrGLenum type, GrGLenum severity, GrGLsizei count, const GrGLuint* ids, GrGLboolean enabled);
typedef GrGLvoid (* GrGLDebugMessageInsertProc)(GrGLenum source, GrGLenum type, GrGLuint id, GrGLenum severity, GrGLsizei length,  const GrGLchar* buf);
typedef GrGLvoid (* GrGLDebugMessageCallbackProc)(GRGLDEBUGPROC callback, const GrGLvoid* userParam);
typedef GrGLuint (* GrGLGetDebugMessageLogProc)(GrGLuint count, GrGLsizei bufSize, GrGLenum* sources, GrGLenum* types, GrGLuint* ids, GrGLenum* severities, GrGLsizei* lengths,  GrGLchar* messageLog);
typedef GrGLvoid (* GrGLPushDebugGroupProc)(GrGLenum source, GrGLuint id, GrGLsizei length,  const GrGLchar * message);
typedef GrGLvoid (* GrGLPopDebugGroupProc)();
typedef GrGLvoid (* GrGLObjectLabelProc)(GrGLenum identifier, GrGLuint name, GrGLsizei length, const GrGLchar *label);

/** EXT_window_rectangles */
typedef GrGLvoid (* GrGLWindowRectanglesProc)(GrGLenum mode, GrGLsizei count, const GrGLint box[]);

/** EGL functions */
typedef const char* (* GrEGLQueryStringProc)(GrEGLDisplay dpy, GrEGLint name);
typedef GrEGLDisplay (* GrEGLGetCurrentDisplayProc)();
typedef GrEGLImage (* GrEGLCreateImageProc)(GrEGLDisplay dpy, GrEGLContext ctx, GrEGLenum target, GrEGLClientBuffer buffer, const GrEGLint *attrib_list);
typedef GrEGLBoolean (* GrEGLDestroyImageProc)(GrEGLDisplay dpy, GrEGLImage image);
}  // extern "C"

template <typename GLPTR> using GrGLFunction = std::function<skstd::remove_pointer_t<GLPTR>>;

#endif
