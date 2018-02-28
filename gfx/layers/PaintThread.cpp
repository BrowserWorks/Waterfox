/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=99: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "PaintThread.h"

#include "base/task.h"
#include "gfxPrefs.h"
#include "mozilla/layers/CompositorBridgeChild.h"
#include "mozilla/gfx/2D.h"
#include "mozilla/Preferences.h"
#include "mozilla/SyncRunnable.h"

namespace mozilla {
namespace layers {

using namespace gfx;

StaticAutoPtr<PaintThread> PaintThread::sSingleton;
StaticRefPtr<nsIThread> PaintThread::sThread;
PlatformThreadId PaintThread::sThreadId;

void
PaintThread::Release()
{
}

void
PaintThread::AddRef()
{
}

void
PaintThread::InitOnPaintThread()
{
  MOZ_ASSERT(!NS_IsMainThread());
  sThreadId = PlatformThread::CurrentId();
}

bool
PaintThread::Init()
{
  MOZ_ASSERT(NS_IsMainThread());

  RefPtr<nsIThread> thread;
  nsresult rv = NS_NewNamedThread("PaintThread", getter_AddRefs(thread));
  if (NS_FAILED(rv)) {
    return false;
  }
  sThread = thread;

  nsCOMPtr<nsIRunnable> paintInitTask =
    NewRunnableMethod("PaintThread::InitOnPaintThread",
                      this, &PaintThread::InitOnPaintThread);
  SyncRunnable::DispatchToThread(sThread, paintInitTask);
  return true;
}

/* static */ void
PaintThread::Start()
{
  PaintThread::sSingleton = new PaintThread();

  if (!PaintThread::sSingleton->Init()) {
    gfxCriticalNote << "Unable to start paint thread";
    PaintThread::sSingleton = nullptr;
  }
}

/* static */ PaintThread*
PaintThread::Get()
{
  MOZ_ASSERT(NS_IsMainThread());
  return PaintThread::sSingleton.get();
}

void
DestroyPaintThread(UniquePtr<PaintThread>&& pt)
{
  MOZ_ASSERT(PaintThread::IsOnPaintThread());
  pt->ShutdownOnPaintThread();
}

/* static */ void
PaintThread::Shutdown()
{
  MOZ_ASSERT(NS_IsMainThread());

  UniquePtr<PaintThread> pt(sSingleton.forget());
  if (!pt) {
    return;
  }

  sThread->Dispatch(NewRunnableFunction(DestroyPaintThread, Move(pt)));
  sThread->Shutdown();
  sThread = nullptr;
}

void
PaintThread::ShutdownOnPaintThread()
{
  MOZ_ASSERT(IsOnPaintThread());
}

/* static */ bool
PaintThread::IsOnPaintThread()
{
  return sThreadId == PlatformThread::CurrentId();
}

void
PaintThread::PaintContentsAsync(CompositorBridgeChild* aBridge,
                                gfx::DrawTargetCapture* aCapture,
                                gfx::DrawTarget* aTarget)
{
  MOZ_ASSERT(IsOnPaintThread());

  // Draw all the things into the actual dest target.
  aTarget->DrawCapturedDT(aCapture, Matrix());

  if (aBridge) {
    aBridge->NotifyFinishedAsyncPaint();
  }
}

void
PaintThread::PaintContents(DrawTargetCapture* aCapture,
                           DrawTarget* aTarget)
{
  MOZ_ASSERT(NS_IsMainThread());

  // If painting asynchronously, we need to acquire the compositor bridge which
  // owns the underlying MessageChannel. Otherwise we leave it null and use
  // synchronous dispatch.
  RefPtr<CompositorBridgeChild> cbc;
  if (!gfxPrefs::LayersOMTPForceSync()) {
    cbc = CompositorBridgeChild::Get();
    cbc->NotifyBeginAsyncPaint();
  }
  RefPtr<DrawTargetCapture> capture(aCapture);
  RefPtr<DrawTarget> target(aTarget);

  RefPtr<PaintThread> self = this;
  RefPtr<Runnable> task = NS_NewRunnableFunction("PaintThread::PaintContents",
    [self, cbc, capture, target]() -> void
  {
    self->PaintContentsAsync(cbc, capture, target);
  });

  if (cbc) {
    sThread->Dispatch(task.forget());
  } else {
    SyncRunnable::DispatchToThread(sThread, task);
  }
}

} // namespace layers
} // namespace mozilla
