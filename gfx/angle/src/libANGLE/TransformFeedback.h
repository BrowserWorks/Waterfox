//
// Copyright (c) 2014 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//

#ifndef LIBANGLE_TRANSFORM_FEEDBACK_H_
#define LIBANGLE_TRANSFORM_FEEDBACK_H_

#include "libANGLE/RefCountObject.h"

#include "common/angleutils.h"
#include "libANGLE/Debug.h"

#include "angle_gl.h"

namespace rx
{
class GLImplFactory;
class TransformFeedbackImpl;
}

namespace gl
{
class Buffer;
struct Caps;
class Program;

class TransformFeedbackState final : public angle::NonCopyable
{
  public:
    TransformFeedbackState(size_t maxIndexedBuffers);

    const BindingPointer<Buffer> &getGenericBuffer() const;
    const OffsetBindingPointer<Buffer> &getIndexedBuffer(size_t idx) const;
    const std::vector<OffsetBindingPointer<Buffer>> &getIndexedBuffers() const;

  private:
    friend class TransformFeedback;

    std::string mLabel;

    bool mActive;
    GLenum mPrimitiveMode;
    bool mPaused;

    Program *mProgram;

    BindingPointer<Buffer> mGenericBuffer;
    std::vector<OffsetBindingPointer<Buffer>> mIndexedBuffers;
};

class TransformFeedback final : public RefCountObject, public LabeledObject
{
  public:
    TransformFeedback(rx::GLImplFactory *implFactory, GLuint id, const Caps &caps);
    virtual ~TransformFeedback();

    void setLabel(const std::string &label) override;
    const std::string &getLabel() const override;

    void begin(GLenum primitiveMode, Program *program);
    void end();
    void pause();
    void resume();

    bool isActive() const;
    bool isPaused() const;
    GLenum getPrimitiveMode() const;

    bool hasBoundProgram(GLuint program) const;

    void bindGenericBuffer(Buffer *buffer);
    const BindingPointer<Buffer> &getGenericBuffer() const;

    void bindIndexedBuffer(size_t index, Buffer *buffer, size_t offset, size_t size);
    const OffsetBindingPointer<Buffer> &getIndexedBuffer(size_t index) const;
    size_t getIndexedBufferCount() const;

    void detachBuffer(GLuint bufferName);

    rx::TransformFeedbackImpl *getImplementation();
    const rx::TransformFeedbackImpl *getImplementation() const;

  private:
    void bindProgram(Program *program);

    TransformFeedbackState mState;
    rx::TransformFeedbackImpl* mImplementation;
};

}

#endif // LIBANGLE_TRANSFORM_FEEDBACK_H_
