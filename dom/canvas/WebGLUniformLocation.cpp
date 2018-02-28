/* -*- Mode: C++; tab-width: 20; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "WebGLUniformLocation.h"

#include "GLContext.h"
#include "mozilla/dom/ToJSValue.h"
#include "mozilla/dom/WebGLRenderingContextBinding.h"
#include "WebGLActiveInfo.h"
#include "WebGLContext.h"
#include "WebGLProgram.h"

namespace mozilla {

WebGLUniformLocation::WebGLUniformLocation(WebGLContext* webgl,
                                           const webgl::LinkedProgramInfo* linkInfo,
                                           webgl::UniformInfo* info, GLuint loc,
                                           size_t arrayIndex)
    : WebGLContextBoundObject(webgl)
    , mLinkInfo(linkInfo)
    , mInfo(info)
    , mLoc(loc)
    , mArrayIndex(arrayIndex)
{ }

WebGLUniformLocation::~WebGLUniformLocation()
{ }

bool
WebGLUniformLocation::ValidateForProgram(const WebGLProgram* prog,
                                         const char* funcName) const
{
    // Check the weak-pointer.
    if (!mLinkInfo) {
        mContext->ErrorInvalidOperation("%s: This uniform location is obsolete because"
                                        " its program has been successfully relinked.",
                                        funcName);
        return false;
    }

    if (mLinkInfo->prog != prog) {
        mContext->ErrorInvalidOperation("%s: This uniform location corresponds to a"
                                        " different program.", funcName);
        return false;
    }

    return true;
}

static bool
IsUniformSetterTypeValid(GLenum setterType, GLenum uniformType)
{
    // The order in this switch matches table 2.10 from OpenGL ES
    // 3.0.4 (Aug 27, 2014) es_spec_3.0.4.pdf
    switch (uniformType) {
    case LOCAL_GL_FLOAT:
    case LOCAL_GL_FLOAT_VEC2:
    case LOCAL_GL_FLOAT_VEC3:
    case LOCAL_GL_FLOAT_VEC4:
        return setterType == LOCAL_GL_FLOAT;

    case LOCAL_GL_INT:
    case LOCAL_GL_INT_VEC2:
    case LOCAL_GL_INT_VEC3:
    case LOCAL_GL_INT_VEC4:
        return setterType == LOCAL_GL_INT;

    case LOCAL_GL_UNSIGNED_INT:
    case LOCAL_GL_UNSIGNED_INT_VEC2:
    case LOCAL_GL_UNSIGNED_INT_VEC3:
    case LOCAL_GL_UNSIGNED_INT_VEC4:
        return setterType == LOCAL_GL_UNSIGNED_INT;

        /* bool can be set via any function: 0, 0.0f -> FALSE, _ -> TRUE */
    case LOCAL_GL_BOOL:
    case LOCAL_GL_BOOL_VEC2:
    case LOCAL_GL_BOOL_VEC3:
    case LOCAL_GL_BOOL_VEC4:
        return (setterType == LOCAL_GL_INT   ||
                setterType == LOCAL_GL_FLOAT ||
                setterType == LOCAL_GL_UNSIGNED_INT);

    case LOCAL_GL_FLOAT_MAT2:
    case LOCAL_GL_FLOAT_MAT3:
    case LOCAL_GL_FLOAT_MAT4:
    case LOCAL_GL_FLOAT_MAT2x3:
    case LOCAL_GL_FLOAT_MAT2x4:
    case LOCAL_GL_FLOAT_MAT3x2:
    case LOCAL_GL_FLOAT_MAT3x4:
    case LOCAL_GL_FLOAT_MAT4x2:
    case LOCAL_GL_FLOAT_MAT4x3:
        return setterType == LOCAL_GL_FLOAT;

        /* Samplers can only be set via Uniform1i */
    case LOCAL_GL_SAMPLER_2D:
    case LOCAL_GL_SAMPLER_3D:
    case LOCAL_GL_SAMPLER_CUBE:
    case LOCAL_GL_SAMPLER_2D_SHADOW:
    case LOCAL_GL_SAMPLER_2D_ARRAY:
    case LOCAL_GL_SAMPLER_2D_ARRAY_SHADOW:
    case LOCAL_GL_SAMPLER_CUBE_SHADOW:

    case LOCAL_GL_INT_SAMPLER_2D:
    case LOCAL_GL_INT_SAMPLER_3D:
    case LOCAL_GL_INT_SAMPLER_CUBE:
    case LOCAL_GL_INT_SAMPLER_2D_ARRAY:

    case LOCAL_GL_UNSIGNED_INT_SAMPLER_2D:
    case LOCAL_GL_UNSIGNED_INT_SAMPLER_3D:
    case LOCAL_GL_UNSIGNED_INT_SAMPLER_CUBE:
    case LOCAL_GL_UNSIGNED_INT_SAMPLER_2D_ARRAY:
        return setterType == LOCAL_GL_INT;

    default:
        MOZ_CRASH("GFX: Bad `uniformType`.");
    }
}

bool
WebGLUniformLocation::ValidateSizeAndType(uint8_t setterElemSize, GLenum setterType,
                                          const char* funcName) const
{
    MOZ_ASSERT(mLinkInfo);

    const auto& uniformElemSize = mInfo->mActiveInfo->mElemSize;
    if (setterElemSize != uniformElemSize) {
        mContext->ErrorInvalidOperation("%s: Function used differs from uniform size: %i",
                                        funcName, uniformElemSize);
        return false;
    }

    const auto& uniformElemType = mInfo->mActiveInfo->mElemType;
    if (!IsUniformSetterTypeValid(setterType, uniformElemType)) {
        mContext->ErrorInvalidOperation("%s: Function used is incompatible with uniform"
                                        " type: %i",
                                        funcName, uniformElemType);
        return false;
    }

    return true;
}

bool
WebGLUniformLocation::ValidateArrayLength(uint8_t setterElemSize, size_t setterArraySize,
                                          const char* funcName) const
{
    MOZ_ASSERT(mLinkInfo);

    if (setterArraySize == 0 ||
        setterArraySize % setterElemSize)
    {
        mContext->ErrorInvalidValue("%s: Expected an array of length a multiple of %d,"
                                    " got an array of length %zu.",
                                    funcName, setterElemSize, setterArraySize);
        return false;
    }

    /* GLES 2.0.25, Section 2.10, p38
     *   When loading `N` elements starting at an arbitrary position `k` in a uniform
     *   declared as an array, elements `k` through `k + N - 1` in the array will be
     *   replaced with the new values. Values for any array element that exceeds the
     *   highest array element index used, as reported by `GetActiveUniform`, will be
     *   ignored by GL.
     */
    if (!mInfo->mActiveInfo->mIsArray &&
        setterArraySize != setterElemSize)
    {
        mContext->ErrorInvalidOperation("%s: Expected an array of length exactly %d"
                                        " (since this uniform is not an array uniform),"
                                        " got an array of length %zu.",
                                        funcName, setterElemSize, setterArraySize);
        return false;
    }

    return true;
}

JS::Value
WebGLUniformLocation::GetUniform(JSContext* js) const
{
    MOZ_ASSERT(mLinkInfo);

    const uint8_t elemSize = mInfo->mActiveInfo->mElemSize;
    static const uint8_t kMaxElemSize = 16;
    MOZ_ASSERT(elemSize <= kMaxElemSize);

    GLuint prog = mLinkInfo->prog->mGLName;

    gl::GLContext* gl = mContext->GL();
    gl->MakeCurrent();

    switch (mInfo->mActiveInfo->mElemType) {
    case LOCAL_GL_INT:
    case LOCAL_GL_INT_VEC2:
    case LOCAL_GL_INT_VEC3:
    case LOCAL_GL_INT_VEC4:
    case LOCAL_GL_SAMPLER_2D:
    case LOCAL_GL_SAMPLER_3D:
    case LOCAL_GL_SAMPLER_CUBE:
    case LOCAL_GL_SAMPLER_2D_SHADOW:
    case LOCAL_GL_SAMPLER_2D_ARRAY:
    case LOCAL_GL_SAMPLER_2D_ARRAY_SHADOW:
    case LOCAL_GL_SAMPLER_CUBE_SHADOW:
    case LOCAL_GL_INT_SAMPLER_2D:
    case LOCAL_GL_INT_SAMPLER_3D:
    case LOCAL_GL_INT_SAMPLER_CUBE:
    case LOCAL_GL_INT_SAMPLER_2D_ARRAY:
    case LOCAL_GL_UNSIGNED_INT_SAMPLER_2D:
    case LOCAL_GL_UNSIGNED_INT_SAMPLER_3D:
    case LOCAL_GL_UNSIGNED_INT_SAMPLER_CUBE:
    case LOCAL_GL_UNSIGNED_INT_SAMPLER_2D_ARRAY:
        {
            GLint buffer[kMaxElemSize] = {0};
            gl->fGetUniformiv(prog, mLoc, buffer);

            if (elemSize == 1)
                return JS::Int32Value(buffer[0]);

            JSObject* obj = dom::Int32Array::Create(js, mContext, elemSize, buffer);
            if (!obj) {
                mContext->ErrorOutOfMemory("getUniform: Out of memory.");
                return JS::NullValue();
            }
            return JS::ObjectOrNullValue(obj);
        }

    case LOCAL_GL_BOOL:
    case LOCAL_GL_BOOL_VEC2:
    case LOCAL_GL_BOOL_VEC3:
    case LOCAL_GL_BOOL_VEC4:
        {
            GLint buffer[kMaxElemSize] = {0};
            gl->fGetUniformiv(prog, mLoc, buffer);

            if (elemSize == 1)
                return JS::BooleanValue(buffer[0]);

            bool boolBuffer[kMaxElemSize];
            for (uint8_t i = 0; i < kMaxElemSize; i++)
                boolBuffer[i] = buffer[i];

            JS::RootedValue val(js);
            // Be careful: we don't want to convert all of |uv|!
            if (!dom::ToJSValue(js, boolBuffer, elemSize, &val)) {
                mContext->ErrorOutOfMemory("getUniform: Out of memory.");
                return JS::NullValue();
            }
            return val;
        }

    case LOCAL_GL_FLOAT:
    case LOCAL_GL_FLOAT_VEC2:
    case LOCAL_GL_FLOAT_VEC3:
    case LOCAL_GL_FLOAT_VEC4:
    case LOCAL_GL_FLOAT_MAT2:
    case LOCAL_GL_FLOAT_MAT3:
    case LOCAL_GL_FLOAT_MAT4:
    case LOCAL_GL_FLOAT_MAT2x3:
    case LOCAL_GL_FLOAT_MAT2x4:
    case LOCAL_GL_FLOAT_MAT3x2:
    case LOCAL_GL_FLOAT_MAT3x4:
    case LOCAL_GL_FLOAT_MAT4x2:
    case LOCAL_GL_FLOAT_MAT4x3:
        {
            GLfloat buffer[16] = {0.0f};
            gl->fGetUniformfv(prog, mLoc, buffer);

            if (elemSize == 1)
                return JS::DoubleValue(buffer[0]);

            JSObject* obj = dom::Float32Array::Create(js, mContext, elemSize, buffer);
            if (!obj) {
                mContext->ErrorOutOfMemory("getUniform: Out of memory.");
                return JS::NullValue();
            }
            return JS::ObjectOrNullValue(obj);
        }

    case LOCAL_GL_UNSIGNED_INT:
    case LOCAL_GL_UNSIGNED_INT_VEC2:
    case LOCAL_GL_UNSIGNED_INT_VEC3:
    case LOCAL_GL_UNSIGNED_INT_VEC4:
        {
            GLuint buffer[kMaxElemSize] = {0};
            gl->fGetUniformuiv(prog, mLoc, buffer);

            if (elemSize == 1)
                return JS::DoubleValue(buffer[0]); // This is Double because only Int32 is special cased.

            JSObject* obj = dom::Uint32Array::Create(js, mContext, elemSize, buffer);
            if (!obj) {
                mContext->ErrorOutOfMemory("getUniform: Out of memory.");
                return JS::NullValue();
            }
            return JS::ObjectOrNullValue(obj);
        }

    default:
        MOZ_CRASH("GFX: Invalid elemType.");
    }
}

////////////////////////////////////////////////////////////////////////////////

JSObject*
WebGLUniformLocation::WrapObject(JSContext* js, JS::Handle<JSObject*> givenProto)
{
    return dom::WebGLUniformLocationBinding::Wrap(js, this, givenProto);
}

NS_IMPL_CYCLE_COLLECTION_WRAPPERCACHE_0(WebGLUniformLocation)

NS_IMPL_CYCLE_COLLECTION_ROOT_NATIVE(WebGLUniformLocation, AddRef)
NS_IMPL_CYCLE_COLLECTION_UNROOT_NATIVE(WebGLUniformLocation, Release)

} // namespace mozilla
