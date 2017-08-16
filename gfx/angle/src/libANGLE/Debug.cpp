//
// Copyright (c) 2015 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//

// Debug.cpp: Defines debug state used for GL_KHR_debug

#include "libANGLE/Debug.h"

#include "common/debug.h"

#include <algorithm>
#include <tuple>

namespace gl
{

Debug::Debug()
    : mOutputEnabled(false),
      mCallbackFunction(nullptr),
      mCallbackUserParam(nullptr),
      mMessages(),
      mMaxLoggedMessages(0),
      mOutputSynchronous(false),
      mGroups()
{
    pushDefaultGroup();
}

void Debug::setMaxLoggedMessages(GLuint maxLoggedMessages)
{
    mMaxLoggedMessages = maxLoggedMessages;
}

void Debug::setOutputEnabled(bool enabled)
{
    mOutputEnabled = enabled;
}

bool Debug::isOutputEnabled() const
{
    return mOutputEnabled;
}

void Debug::setOutputSynchronous(bool synchronous)
{
    mOutputSynchronous = synchronous;
}

bool Debug::isOutputSynchronous() const
{
    return mOutputSynchronous;
}

void Debug::setCallback(GLDEBUGPROCKHR callback, const void *userParam)
{
    mCallbackFunction  = callback;
    mCallbackUserParam = userParam;
}

GLDEBUGPROCKHR Debug::getCallback() const
{
    return mCallbackFunction;
}

const void *Debug::getUserParam() const
{
    return mCallbackUserParam;
}

void Debug::insertMessage(GLenum source,
                          GLenum type,
                          GLuint id,
                          GLenum severity,
                          const std::string &message)
{
    std::string messageCopy(message);
    insertMessage(source, type, id, severity, std::move(messageCopy));
}

void Debug::insertMessage(GLenum source,
                          GLenum type,
                          GLuint id,
                          GLenum severity,
                          std::string &&message)
{
    if (!isMessageEnabled(source, type, id, severity))
    {
        return;
    }

    if (mCallbackFunction != nullptr)
    {
        // TODO(geofflang) Check the synchronous flag and potentially flush messages from another
        // thread.
        mCallbackFunction(source, type, id, severity, static_cast<GLsizei>(message.length()),
                          message.c_str(), mCallbackUserParam);
    }
    else
    {
        if (mMessages.size() >= mMaxLoggedMessages)
        {
            // Drop messages over the limit
            return;
        }

        Message m;
        m.source   = source;
        m.type     = type;
        m.id       = id;
        m.severity = severity;
        m.message  = std::move(message);

        mMessages.push_back(std::move(m));
    }
}

size_t Debug::getMessages(GLuint count,
                          GLsizei bufSize,
                          GLenum *sources,
                          GLenum *types,
                          GLuint *ids,
                          GLenum *severities,
                          GLsizei *lengths,
                          GLchar *messageLog)
{
    size_t messageCount       = 0;
    size_t messageStringIndex = 0;
    while (messageCount <= count && !mMessages.empty())
    {
        const Message &m = mMessages.front();

        if (messageLog != nullptr)
        {
            // Check that this message can fit in the message buffer
            if (messageStringIndex + m.message.length() + 1 > static_cast<size_t>(bufSize))
            {
                break;
            }

            std::copy(m.message.begin(), m.message.end(), messageLog + messageStringIndex);
            messageStringIndex += m.message.length();

            messageLog[messageStringIndex] = '\0';
            messageStringIndex += 1;
        }

        if (sources != nullptr)
        {
            sources[messageCount] = m.source;
        }

        if (types != nullptr)
        {
            types[messageCount] = m.type;
        }

        if (ids != nullptr)
        {
            ids[messageCount] = m.id;
        }

        if (severities != nullptr)
        {
            severities[messageCount] = m.severity;
        }

        if (lengths != nullptr)
        {
            lengths[messageCount] = static_cast<GLsizei>(m.message.length());
        }

        mMessages.pop_front();

        messageCount++;
    }

    return messageCount;
}

size_t Debug::getNextMessageLength() const
{
    return mMessages.empty() ? 0 : mMessages.front().message.length();
}

size_t Debug::getMessageCount() const
{
    return mMessages.size();
}

void Debug::setMessageControl(GLenum source,
                              GLenum type,
                              GLenum severity,
                              std::vector<GLuint> &&ids,
                              bool enabled)
{
    Control c;
    c.source   = source;
    c.type     = type;
    c.severity = severity;
    c.ids      = std::move(ids);
    c.enabled  = enabled;

    auto &controls = mGroups.back().controls;
    controls.push_back(std::move(c));
}

void Debug::pushGroup(GLenum source, GLuint id, std::string &&message)
{
    insertMessage(source, GL_DEBUG_TYPE_PUSH_GROUP, id, GL_DEBUG_SEVERITY_NOTIFICATION,
                  std::string(message));

    Group g;
    g.source  = source;
    g.id      = id;
    g.message = std::move(message);
    mGroups.push_back(std::move(g));
}

void Debug::popGroup()
{
    // Make sure the default group is not about to be popped
    ASSERT(mGroups.size() > 1);

    Group g = mGroups.back();
    mGroups.pop_back();

    insertMessage(g.source, GL_DEBUG_TYPE_POP_GROUP, g.id, GL_DEBUG_SEVERITY_NOTIFICATION,
                  g.message);
}

size_t Debug::getGroupStackDepth() const
{
    return mGroups.size();
}

bool Debug::isMessageEnabled(GLenum source, GLenum type, GLuint id, GLenum severity) const
{
    if (!mOutputEnabled)
    {
        return false;
    }

    for (auto groupIter = mGroups.rbegin(); groupIter != mGroups.rend(); groupIter++)
    {
        const auto &controls = groupIter->controls;
        for (auto controlIter = controls.rbegin(); controlIter != controls.rend(); controlIter++)
        {
            const auto &control = *controlIter;

            if (control.source != GL_DONT_CARE && control.source != source)
            {
                continue;
            }

            if (control.type != GL_DONT_CARE && control.type != type)
            {
                continue;
            }

            if (control.severity != GL_DONT_CARE && control.severity != severity)
            {
                continue;
            }

            if (!control.ids.empty() &&
                std::find(control.ids.begin(), control.ids.end(), id) == control.ids.end())
            {
                continue;
            }

            return control.enabled;
        }
    }

    return true;
}

void Debug::pushDefaultGroup()
{
    Group g;
    g.source  = GL_NONE;
    g.id      = 0;
    g.message = "";

    Control c0;
    c0.source   = GL_DONT_CARE;
    c0.type     = GL_DONT_CARE;
    c0.severity = GL_DONT_CARE;
    c0.enabled = true;
    g.controls.push_back(std::move(c0));

    Control c1;
    c1.source   = GL_DONT_CARE;
    c1.type     = GL_DONT_CARE;
    c1.severity = GL_DEBUG_SEVERITY_LOW;
    c1.enabled = false;
    g.controls.push_back(std::move(c1));

    mGroups.push_back(std::move(g));
}
}  // namespace gl
