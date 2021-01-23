/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "SourceSurfaceCapture.h"
#include "DrawCommand.h"
#include "DrawTargetCapture.h"
#include "MainThreadUtils.h"
#include "mozilla/gfx/Logging.h"

namespace mozilla {
namespace gfx {

SourceSurfaceCapture::SourceSurfaceCapture(DrawTargetCaptureImpl* aOwner)
    : mOwner(aOwner),
      mHasCommandList(false),
      mShouldResolveToLuminance{false},
      mLuminanceType{LuminanceType::LUMINANCE},
      mOpacity{1.0f},
      mLock("SourceSurfaceCapture.mLock") {
  mSize = mOwner->GetSize();
  mFormat = mOwner->GetFormat();
  mRefDT = mOwner->mRefDT;
  mStride = mOwner->mStride;
  mSurfaceAllocationSize = mOwner->mSurfaceAllocationSize;
}

SourceSurfaceCapture::SourceSurfaceCapture(
    DrawTargetCaptureImpl* aOwner,
    LuminanceType aLuminanceType /* = LuminanceType::LINEARRGB */,
    Float aOpacity /* = 1.0f */)
    : mOwner{aOwner},
      mHasCommandList{false},
      mShouldResolveToLuminance{true},
      mLuminanceType{aLuminanceType},
      mOpacity{aOpacity},
      mLock{"SourceSurfaceCapture.mLock"} {
  mSize = mOwner->GetSize();
  mFormat = mOwner->GetFormat();
  mRefDT = mOwner->mRefDT;
  mStride = mOwner->mStride;
  mSurfaceAllocationSize = mOwner->mSurfaceAllocationSize;

  // In this case our DrawTarget will not track us, so copy its drawing
  // commands.
  DrawTargetWillChange();
}

SourceSurfaceCapture::SourceSurfaceCapture(DrawTargetCaptureImpl* aOwner,
                                           SourceSurface* aSurfToOptimize)
    : mOwner{aOwner},
      mHasCommandList{false},
      mShouldResolveToLuminance{false},
      mLuminanceType{LuminanceType::LUMINANCE},
      mOpacity{1.0f},
      mLock{"SourceSurfaceCapture.mLock"},
      mSurfToOptimize(aSurfToOptimize) {
  mSize = aSurfToOptimize->GetSize();
  mFormat = aSurfToOptimize->GetFormat();
  mRefDT = mOwner->mRefDT;
}

SourceSurfaceCapture::~SourceSurfaceCapture() = default;

void SourceSurfaceCapture::SizeOfExcludingThis(MallocSizeOf aMallocSizeOf,
                                               SizeOfInfo& aInfo) const {
  MutexAutoLock lock(mLock);
  aInfo.AddType(SurfaceType::CAPTURE);
  if (mSurfToOptimize) {
    mSurfToOptimize->SizeOfExcludingThis(aMallocSizeOf, aInfo);
    return;
  }
  if (mResolved) {
    mResolved->SizeOfExcludingThis(aMallocSizeOf, aInfo);
    return;
  }
  if (mHasCommandList) {
    aInfo.mHeapBytes += mCommands.BufferCapacity();
    return;
  }
}

bool SourceSurfaceCapture::IsValid() const {
  // We must either be able to source a command list, or we must have a cached
  // and rasterized surface.
  MutexAutoLock lock(mLock);

  if (mSurfToOptimize) {
    // We were given a surface, but we haven't tried to optimize it yet
    // with the reference draw target.
    return mSurfToOptimize->IsValid();
  }
  if (mResolved) {
    // We were given a surface, and we already optimized it with the
    // reference draw target.
    return mResolved->IsValid();
  }

  // We have no underlying surface, so it must be a set of drawing commands.
  return mOwner || mHasCommandList;
}

RefPtr<SourceSurface> SourceSurfaceCapture::Resolve(BackendType aBackendType) {
  MutexAutoLock lock(mLock);

  if (mSurfToOptimize) {
    mResolved = mRefDT->OptimizeSourceSurface(mSurfToOptimize);
    mSurfToOptimize = nullptr;
  }

  if (mResolved || (!mOwner && !mHasCommandList)) {
    // We are already resolved, or there is no way we can rasterize
    // anything, we don't have a source DrawTarget and we don't have
    // a command list. Return whatever our cached surface is.
    return mResolved;
  }

  BackendType backendType = aBackendType;
  if (backendType == BackendType::NONE) {
    backendType = mRefDT->GetBackendType();
  }

  // Note: SurfaceType is not 1:1 with BackendType, so we can't easily decide
  // that they match. Instead we just cache the first thing to be requested.
  // We ensured no mResolved existed before.
  mResolved = ResolveImpl(backendType);

  return mResolved;
}

RefPtr<SourceSurface> SourceSurfaceCapture::ResolveImpl(
    BackendType aBackendType) {
  RefPtr<DrawTarget> dt;
  uint8_t* data = nullptr;
  if (!mSurfaceAllocationSize) {
    if (aBackendType == mRefDT->GetBackendType()) {
      dt = mRefDT->CreateSimilarDrawTarget(mSize, mFormat);
    } else {
      dt = Factory::CreateDrawTarget(aBackendType, mSize, mFormat);
    }
  } else {
    data = static_cast<uint8_t*>(calloc(1, mSurfaceAllocationSize));
    if (!data) {
      return nullptr;
    }
    BackendType type = Factory::DoesBackendSupportDataDrawtarget(aBackendType)
                           ? aBackendType
                           : BackendType::SKIA;
    dt = Factory::CreateDrawTargetForData(type, data, mSize, mStride, mFormat);
    if (!dt || !dt->IsValid()) {
      free(data);
      return nullptr;
    }
  }

  if (!dt || !dt->IsValid()) {
    // Make sure we haven't allocated and aren't leaking something, the code
    // right anove here should have guaranteed that.
    MOZ_ASSERT(!data);
    return nullptr;
  }

  // If we're still attached to a DrawTarget, use its command list rather than
  // our own (which will be empty).
  CaptureCommandList& commands =
      mHasCommandList ? mCommands : mOwner->mCommands;
  for (CaptureCommandList::iterator iter(commands); !iter.Done(); iter.Next()) {
    DrawingCommand* cmd = iter.Get();
    cmd->ExecuteOnDT(dt, nullptr);
  }

  RefPtr<SourceSurface> surf;
  if (!mShouldResolveToLuminance) {
    surf = dt->Snapshot();
  } else {
    surf = dt->IntoLuminanceSource(mLuminanceType, mOpacity);
  }

  if (data) {
    surf->AddUserData(reinterpret_cast<UserDataKey*>(dt.get()), data, free);
  }

  return surf;
}

already_AddRefed<DataSourceSurface> SourceSurfaceCapture::GetDataSurface() {
  RefPtr<SourceSurface> surface = Resolve();
  if (!surface) {
    return nullptr;
  }
  return surface->GetDataSurface();
}

void SourceSurfaceCapture::DrawTargetWillDestroy() {
  MutexAutoLock lock(mLock);

  // The source DrawTarget is going away, so we can just steal its commands.
  mCommands = std::move(mOwner->mCommands);
  mHasCommandList = true;
  mOwner = nullptr;
}

void SourceSurfaceCapture::DrawTargetWillChange() {
  MutexAutoLock lock(mLock);

  for (CaptureCommandList::iterator iter(mOwner->mCommands); !iter.Done();
       iter.Next()) {
    DrawingCommand* cmd = iter.Get();
    cmd->CloneInto(&mCommands);
  }

  mHasCommandList = true;
  mOwner = nullptr;
}

}  // namespace gfx
}  // namespace mozilla
