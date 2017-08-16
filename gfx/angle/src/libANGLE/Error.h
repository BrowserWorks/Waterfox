//
// Copyright (c) 2014 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Error.h: Defines the egl::Error and gl::Error classes which encapsulate API errors
// and optional error messages.

#ifndef LIBANGLE_ERROR_H_
#define LIBANGLE_ERROR_H_

#include "angle_gl.h"
#include "common/angleutils.h"
#include <EGL/egl.h>

#include <string>
#include <memory>

namespace gl
{

template <typename T>
class ErrorOrResult;

class Error final
{
  public:
    explicit inline Error(GLenum errorCode);
    Error(GLenum errorCode, std::string &&msg);
    Error(GLenum errorCode, const char *msg, ...);
    Error(GLenum errorCode, GLuint id, const char *msg, ...);
    inline Error(const Error &other);
    inline Error(Error &&other);

    inline Error &operator=(const Error &other);
    inline Error &operator=(Error &&other);

    inline GLenum getCode() const;
    inline GLuint getID() const;
    inline bool isError() const;

    const std::string &getMessage() const;

    // Useful for mocking and testing
    bool operator==(const Error &other) const;
    bool operator!=(const Error &other) const;

  private:
    void createMessageString() const;

    GLenum mCode;
    GLuint mID;
    mutable std::unique_ptr<std::string> mMessage;
};

namespace priv
{
template <GLenum EnumT>
class ErrorStream : angle::NonCopyable
{
  public:
    ErrorStream();

    template <typename T>
    ErrorStream &operator<<(T value);

    operator Error();

    template <typename T>
    operator ErrorOrResult<T>()
    {
        return static_cast<Error>(*this);
    }

  private:
    std::ostringstream mErrorStream;
};

// These convience methods for HRESULTS (really long) are used all over the place in the D3D
// back-ends.
#if defined(ANGLE_PLATFORM_WINDOWS)
template <>
template <>
inline ErrorStream<GL_OUT_OF_MEMORY> &ErrorStream<GL_OUT_OF_MEMORY>::operator<<(HRESULT hresult)
{
    mErrorStream << "HRESULT: 0x" << std::ios::hex << hresult;
    return *this;
}

template <>
template <>
inline ErrorStream<GL_INVALID_OPERATION> &ErrorStream<GL_INVALID_OPERATION>::operator<<(
    HRESULT hresult)
{
    mErrorStream << "HRESULT: 0x" << std::ios::hex << hresult;
    return *this;
}
#endif  // defined(ANGLE_PLATFORM_WINDOWS)

template <GLenum EnumT>
template <typename T>
ErrorStream<EnumT> &ErrorStream<EnumT>::operator<<(T value)
{
    mErrorStream << value;
    return *this;
}

}  // namespace priv

using OutOfMemory   = priv::ErrorStream<GL_OUT_OF_MEMORY>;
using InternalError = priv::ErrorStream<GL_INVALID_OPERATION>;

template <typename T>
class ErrorOrResult
{
  public:
    ErrorOrResult(const gl::Error &error) : mError(error) {}
    ErrorOrResult(gl::Error &&error) : mError(std::move(error)) {}

    ErrorOrResult(T &&result)
        : mError(GL_NO_ERROR), mResult(std::forward<T>(result))
    {
    }

    ErrorOrResult(const T &result)
        : mError(GL_NO_ERROR), mResult(result)
    {
    }

    bool isError() const { return mError.isError(); }
    const gl::Error &getError() const { return mError; }
    T &&getResult() { return std::move(mResult); }

  private:
    Error mError;
    T mResult;
};

inline Error NoError()
{
    return Error(GL_NO_ERROR);
}

}  // namespace gl

namespace egl
{

class Error final
{
  public:
    explicit inline Error(EGLint errorCode);
    Error(EGLint errorCode, const char *msg, ...);
    Error(EGLint errorCode, EGLint id, const char *msg, ...);
    inline Error(const Error &other);
    inline Error(Error &&other);

    inline Error &operator=(const Error &other);
    inline Error &operator=(Error &&other);

    inline EGLint getCode() const;
    inline EGLint getID() const;
    inline bool isError() const;

    const std::string &getMessage() const;

  private:
    void createMessageString() const;

    EGLint mCode;
    EGLint mID;
    mutable std::unique_ptr<std::string> mMessage;
};

inline Error NoError()
{
    return Error(EGL_SUCCESS);
}

}  // namespace egl

#define ANGLE_CONCAT1(x, y) x##y
#define ANGLE_CONCAT2(x, y) ANGLE_CONCAT1(x, y)
#define ANGLE_LOCAL_VAR ANGLE_CONCAT2(_localVar, __LINE__)

#define ANGLE_TRY(EXPR)                \
    {                                  \
        auto ANGLE_LOCAL_VAR = EXPR;   \
        if (ANGLE_LOCAL_VAR.isError()) \
        {                              \
            return ANGLE_LOCAL_VAR;    \
        }                              \
    }                                  \
    ANGLE_EMPTY_STATEMENT

#define ANGLE_TRY_RESULT(EXPR, RESULT)         \
    {                                          \
        auto ANGLE_LOCAL_VAR = EXPR;           \
        if (ANGLE_LOCAL_VAR.isError())         \
        {                                      \
            return ANGLE_LOCAL_VAR.getError(); \
        }                                      \
        RESULT = ANGLE_LOCAL_VAR.getResult();  \
    }                                          \
    ANGLE_EMPTY_STATEMENT

#undef ANGLE_LOCAL_VAR
#undef ANGLE_CONCAT2
#undef ANGLE_CONCAT1

#include "Error.inl"

#endif // LIBANGLE_ERROR_H_
