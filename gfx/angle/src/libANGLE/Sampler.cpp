//
// Copyright (c) 2013 The ANGLE Project Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//

// Sampler.cpp : Implements the Sampler class, which represents a GLES 3
// sampler object. Sampler objects store some state needed to sample textures.

#include "libANGLE/Sampler.h"
#include "libANGLE/angletypes.h"
#include "libANGLE/renderer/GLImplFactory.h"
#include "libANGLE/renderer/SamplerImpl.h"

namespace gl
{

Sampler::Sampler(rx::GLImplFactory *factory, GLuint id)
    : RefCountObject(id), mImpl(factory->createSampler()), mLabel(), mSamplerState()
{
}

Sampler::~Sampler()
{
    SafeDelete(mImpl);
}

void Sampler::setLabel(const std::string &label)
{
    mLabel = label;
}

const std::string &Sampler::getLabel() const
{
    return mLabel;
}

void Sampler::setMinFilter(GLenum minFilter)
{
    mSamplerState.minFilter = minFilter;
}

GLenum Sampler::getMinFilter() const
{
    return mSamplerState.minFilter;
}

void Sampler::setMagFilter(GLenum magFilter)
{
    mSamplerState.magFilter = magFilter;
}

GLenum Sampler::getMagFilter() const
{
    return mSamplerState.magFilter;
}

void Sampler::setWrapS(GLenum wrapS)
{
    mSamplerState.wrapS = wrapS;
}

GLenum Sampler::getWrapS() const
{
    return mSamplerState.wrapS;
}

void Sampler::setWrapT(GLenum wrapT)
{
    mSamplerState.wrapT = wrapT;
}

GLenum Sampler::getWrapT() const
{
    return mSamplerState.wrapT;
}

void Sampler::setWrapR(GLenum wrapR)
{
    mSamplerState.wrapR = wrapR;
}

GLenum Sampler::getWrapR() const
{
    return mSamplerState.wrapR;
}

void Sampler::setMaxAnisotropy(float maxAnisotropy)
{
    mSamplerState.maxAnisotropy = maxAnisotropy;
}

float Sampler::getMaxAnisotropy() const
{
    return mSamplerState.maxAnisotropy;
}

void Sampler::setMinLod(GLfloat minLod)
{
    mSamplerState.minLod = minLod;
}

GLfloat Sampler::getMinLod() const
{
    return mSamplerState.minLod;
}

void Sampler::setMaxLod(GLfloat maxLod)
{
    mSamplerState.maxLod = maxLod;
}

GLfloat Sampler::getMaxLod() const
{
    return mSamplerState.maxLod;
}

void Sampler::setCompareMode(GLenum compareMode)
{
    mSamplerState.compareMode = compareMode;
}

GLenum Sampler::getCompareMode() const
{
    return mSamplerState.compareMode;
}

void Sampler::setCompareFunc(GLenum compareFunc)
{
    mSamplerState.compareFunc = compareFunc;
}

GLenum Sampler::getCompareFunc() const
{
    return mSamplerState.compareFunc;
}

void Sampler::setSRGBDecode(GLenum sRGBDecode)
{
    mSamplerState.sRGBDecode = sRGBDecode;
}

GLenum Sampler::getSRGBDecode() const
{
    return mSamplerState.sRGBDecode;
}

const SamplerState &Sampler::getSamplerState() const
{
    return mSamplerState;
}

rx::SamplerImpl *Sampler::getImplementation() const
{
    return mImpl;
}

}
