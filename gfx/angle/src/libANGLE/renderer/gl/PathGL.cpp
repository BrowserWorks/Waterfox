//
// Copyright (c) 2016 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//

// PathGL.cpp: Implementation for PathGL class.

#include "libANGLE/renderer/gl/PathGL.h"
#include "libANGLE/renderer/gl/FunctionsGL.h"

namespace rx
{

PathGL::PathGL(const FunctionsGL *functions, GLuint path) : mFunctions(functions), mPathID(path)
{
}

PathGL::~PathGL()
{
}

gl::Error PathGL::setCommands(GLsizei numCommands,
                              const GLubyte *commands,
                              GLsizei numCoords,
                              GLenum coordType,
                              const void *coords)
{
    mFunctions->pathCommandsNV(mPathID, numCommands, commands, numCoords, coordType, coords);
    return gl::Error(GL_NO_ERROR);
}

void PathGL::setPathParameter(GLenum pname, GLfloat value)
{
    mFunctions->setPathParameterfNV(mPathID, pname, value);
}

}  // rx