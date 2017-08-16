/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/SchedulerGroup.h"

#include "jsfriendapi.h"
#include "mozilla/AbstractThread.h"
#include "mozilla/Atomics.h"
#include "mozilla/Move.h"
#include "nsINamed.h"
#include "nsQueryObject.h"
#include "mozilla/dom/ScriptSettings.h"
#include "nsThreadUtils.h"

#include "mozilla/Telemetry.h"

using namespace mozilla;

/* SchedulerEventTarget */

namespace {

#define NS_DISPATCHEREVENTTARGET_IID \
{ 0xbf4e36c8, 0x7d04, 0x4ef4, \
  { 0xbb, 0xd8, 0x11, 0x09, 0x0a, 0xdb, 0x4d, 0xf7 } }

class SchedulerEventTarget final : public nsIEventTarget
{
  RefPtr<SchedulerGroup> mDispatcher;
  TaskCategory mCategory;

public:
  NS_DECLARE_STATIC_IID_ACCESSOR(NS_DISPATCHEREVENTTARGET_IID)

  SchedulerEventTarget(SchedulerGroup* aDispatcher, TaskCategory aCategory)
   : mDispatcher(aDispatcher)
   , mCategory(aCategory)
  {}

  NS_DECL_THREADSAFE_ISUPPORTS
  NS_DECL_NSIEVENTTARGET_FULL

  SchedulerGroup* Dispatcher() const { return mDispatcher; }

private:
  ~SchedulerEventTarget() {}
};

NS_DEFINE_STATIC_IID_ACCESSOR(SchedulerEventTarget, NS_DISPATCHEREVENTTARGET_IID)

static Atomic<uint64_t> gEarliestUnprocessedVsync(0);

class MOZ_RAII AutoCollectVsyncTelemetry final
{
public:
  explicit AutoCollectVsyncTelemetry(SchedulerGroup::Runnable* aRunnable
                                     MOZ_GUARD_OBJECT_NOTIFIER_PARAM)
    : mIsBackground(aRunnable->IsBackground())
  {
    MOZ_GUARD_OBJECT_NOTIFIER_INIT;
#ifdef EARLY_BETA_OR_EARLIER
    aRunnable->GetName(mKey);
    mStart = TimeStamp::Now();
#endif
  }
  ~AutoCollectVsyncTelemetry()
  {
#ifdef EARLY_BETA_OR_EARLIER
    if (Telemetry::CanRecordBase()) {
      CollectTelemetry();
    }
#endif
  }

private:
  void CollectTelemetry();

  bool mIsBackground;
  nsCString mKey;
  TimeStamp mStart;
  MOZ_DECL_USE_GUARD_OBJECT_NOTIFIER
};

void
AutoCollectVsyncTelemetry::CollectTelemetry()
{
  TimeStamp now = TimeStamp::Now();

  mozilla::Telemetry::HistogramID eventsId =
    mIsBackground ? Telemetry::CONTENT_JS_BACKGROUND_TICK_DELAY_EVENTS_MS
                  : Telemetry::CONTENT_JS_FOREGROUND_TICK_DELAY_EVENTS_MS;
  mozilla::Telemetry::HistogramID totalId =
    mIsBackground ? Telemetry::CONTENT_JS_BACKGROUND_TICK_DELAY_TOTAL_MS
                  : Telemetry::CONTENT_JS_FOREGROUND_TICK_DELAY_TOTAL_MS;

  uint64_t lastSeenVsync = gEarliestUnprocessedVsync;
  if (!lastSeenVsync) {
    return;
  }

  bool inconsistent = false;
  TimeStamp creation = TimeStamp::ProcessCreation(&inconsistent);
  if (inconsistent) {
    return;
  }

  TimeStamp pendingVsync =
    creation + TimeDuration::FromMicroseconds(lastSeenVsync);

  if (pendingVsync > now) {
    return;
  }

  uint32_t duration =
    static_cast<uint32_t>((now - pendingVsync).ToMilliseconds());

  Telemetry::Accumulate(eventsId, mKey, duration);
  Telemetry::Accumulate(totalId, duration);

  if (pendingVsync > mStart) {
    return;
  }

  Telemetry::Accumulate(Telemetry::CONTENT_JS_KNOWN_TICK_DELAY_MS, duration);

  return;
}

} // namespace

NS_IMPL_ISUPPORTS(SchedulerEventTarget, SchedulerEventTarget, nsIEventTarget)

NS_IMETHODIMP
SchedulerEventTarget::DispatchFromScript(nsIRunnable* aRunnable, uint32_t aFlags)
{
  return Dispatch(do_AddRef(aRunnable), aFlags);
}

NS_IMETHODIMP
SchedulerEventTarget::Dispatch(already_AddRefed<nsIRunnable> aRunnable, uint32_t aFlags)
{
  if (NS_WARN_IF(aFlags != NS_DISPATCH_NORMAL)) {
    return NS_ERROR_UNEXPECTED;
  }
  return mDispatcher->Dispatch(nullptr, mCategory, Move(aRunnable));
}

NS_IMETHODIMP
SchedulerEventTarget::DelayedDispatch(already_AddRefed<nsIRunnable>, uint32_t)
{
  return NS_ERROR_NOT_IMPLEMENTED;
}

NS_IMETHODIMP
SchedulerEventTarget::IsOnCurrentThread(bool* aIsOnCurrentThread)
{
  *aIsOnCurrentThread = NS_IsMainThread();
  return NS_OK;
}

/* static */ nsresult
SchedulerGroup::UnlabeledDispatch(const char* aName,
                                  TaskCategory aCategory,
                                  already_AddRefed<nsIRunnable>&& aRunnable)
{
  nsCOMPtr<nsIRunnable> runnable(aRunnable);
  if (aName) {
    if (nsCOMPtr<nsINamed> named = do_QueryInterface(runnable)) {
      named->SetName(aName);
    }
  }
  if (NS_IsMainThread()) {
    return NS_DispatchToCurrentThread(runnable.forget());
  } else {
    return NS_DispatchToMainThread(runnable.forget());
  }
}

/* static */ void
SchedulerGroup::MarkVsyncReceived()
{
  if (gEarliestUnprocessedVsync) {
    // If we've seen a vsync already, but haven't handled it, keep the
    // older one.
    return;
  }

  MOZ_ASSERT(!NS_IsMainThread());
  bool inconsistent = false;
  TimeStamp creation = TimeStamp::ProcessCreation(&inconsistent);
  if (inconsistent) {
    return;
  }

  gEarliestUnprocessedVsync = (TimeStamp::Now() - creation).ToMicroseconds();
}

/* static */ void
SchedulerGroup::MarkVsyncRan()
{
  gEarliestUnprocessedVsync = 0;
}

SchedulerGroup* SchedulerGroup::sRunningDispatcher;

SchedulerGroup::SchedulerGroup()
 : mAccessValid(false)
{
}

nsresult
SchedulerGroup::Dispatch(const char* aName,
                         TaskCategory aCategory,
                         already_AddRefed<nsIRunnable>&& aRunnable)
{
  return LabeledDispatch(aName, aCategory, Move(aRunnable));
}

nsIEventTarget*
SchedulerGroup::EventTargetFor(TaskCategory aCategory) const
{
  MOZ_ASSERT(aCategory != TaskCategory::Count);
  MOZ_ASSERT(mEventTargets[size_t(aCategory)]);
  return mEventTargets[size_t(aCategory)];
}

AbstractThread*
SchedulerGroup::AbstractMainThreadFor(TaskCategory aCategory)
{
  MOZ_RELEASE_ASSERT(NS_IsMainThread());
  return AbstractMainThreadForImpl(aCategory);
}

AbstractThread*
SchedulerGroup::AbstractMainThreadForImpl(TaskCategory aCategory)
{
  MOZ_RELEASE_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(aCategory != TaskCategory::Count);
  MOZ_ASSERT(mEventTargets[size_t(aCategory)]);

  if (!mAbstractThreads[size_t(aCategory)]) {
    mAbstractThreads[size_t(aCategory)] =
      AbstractThread::CreateEventTargetWrapper(mEventTargets[size_t(aCategory)],
                                               /* aDrainDirectTasks = */ true);
  }

  return mAbstractThreads[size_t(aCategory)];
}

void
SchedulerGroup::CreateEventTargets(bool aNeedValidation)
{
  for (size_t i = 0; i < size_t(TaskCategory::Count); i++) {
    TaskCategory category = static_cast<TaskCategory>(i);
    if (!aNeedValidation) {
      // The chrome TabGroup dispatches directly to the main thread. This means
      // that we don't have to worry about cyclical references when cleaning up
      // the chrome TabGroup.
      mEventTargets[i] = do_GetMainThread();
    } else {
      mEventTargets[i] = CreateEventTargetFor(category);
    }
  }
}

void
SchedulerGroup::Shutdown(bool aXPCOMShutdown)
{
  // There is a RefPtr cycle TabGroup -> SchedulerEventTarget -> TabGroup. To
  // avoid leaks, we need to break the chain somewhere. We shouldn't be using
  // the ThrottledEventQueue for this TabGroup when no windows belong to it,
  // so it's safe to null out the queue here.
  for (size_t i = 0; i < size_t(TaskCategory::Count); i++) {
    mEventTargets[i] = aXPCOMShutdown ? nullptr : do_GetMainThread();
    mAbstractThreads[i] = nullptr;
  }
}

already_AddRefed<nsIEventTarget>
SchedulerGroup::CreateEventTargetFor(TaskCategory aCategory)
{
  RefPtr<SchedulerEventTarget> target =
    new SchedulerEventTarget(this, aCategory);
  return target.forget();
}

/* static */ SchedulerGroup*
SchedulerGroup::FromEventTarget(nsIEventTarget* aEventTarget)
{
  RefPtr<SchedulerEventTarget> target = do_QueryObject(aEventTarget);
  if (!target) {
    return nullptr;
  }
  return target->Dispatcher();
}

nsresult
SchedulerGroup::LabeledDispatch(const char* aName,
                                TaskCategory aCategory,
                                already_AddRefed<nsIRunnable>&& aRunnable)
{
  nsCOMPtr<nsIRunnable> runnable(aRunnable);
  if (XRE_IsContentProcess()) {
    runnable = new Runnable(runnable.forget(), this);
  }
  return UnlabeledDispatch(aName, aCategory, runnable.forget());
}

void
SchedulerGroup::SetValidatingAccess(ValidationType aType)
{
  sRunningDispatcher = aType == StartValidation ? this : nullptr;
  mAccessValid = aType == StartValidation;

  dom::AutoJSAPI jsapi;
  jsapi.Init();
  js::EnableAccessValidation(jsapi.cx(), !!sRunningDispatcher);
}

SchedulerGroup::Runnable::Runnable(already_AddRefed<nsIRunnable>&& aRunnable,
                                   SchedulerGroup* aGroup)
 : mRunnable(Move(aRunnable)),
   mGroup(aGroup)
{
}

NS_IMETHODIMP
SchedulerGroup::Runnable::GetName(nsACString& aName)
{
  mozilla::Runnable::GetName(aName);
  if (aName.IsEmpty()) {
    // Try to get a name from the underlying runnable.
    nsCOMPtr<nsINamed> named = do_QueryInterface(mRunnable);
    if (named) {
      named->GetName(aName);
    }
    if (aName.IsEmpty()) {
      aName.AssignLiteral("anonymous");
    }
  }
  aName.AppendASCII("(labeled)");
  return NS_OK;
}

NS_IMETHODIMP
SchedulerGroup::Runnable::Run()
{
  MOZ_RELEASE_ASSERT(NS_IsMainThread());

  mGroup->SetValidatingAccess(StartValidation);

  nsresult result;

  {
    AutoCollectVsyncTelemetry telemetry(this);
    result = mRunnable->Run();
  }

  // The runnable's destructor can have side effects, so try to execute it in
  // the scope of the TabGroup.
  mRunnable = nullptr;

  mGroup->SetValidatingAccess(EndValidation);
  return result;
}

NS_IMPL_ISUPPORTS_INHERITED(SchedulerGroup::Runnable,
                            mozilla::Runnable,
                            SchedulerGroup::Runnable)

SchedulerGroup::AutoProcessEvent::AutoProcessEvent()
 : mPrevRunningDispatcher(SchedulerGroup::sRunningDispatcher)
{
  SchedulerGroup* prev = sRunningDispatcher;
  if (prev) {
    MOZ_ASSERT(prev->mAccessValid);
    prev->SetValidatingAccess(EndValidation);
  }
}

SchedulerGroup::AutoProcessEvent::~AutoProcessEvent()
{
  MOZ_ASSERT(!sRunningDispatcher);

  SchedulerGroup* prev = mPrevRunningDispatcher;
  if (prev) {
    prev->SetValidatingAccess(StartValidation);
  }
}
