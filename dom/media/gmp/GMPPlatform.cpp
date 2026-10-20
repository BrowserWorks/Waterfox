/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "GMPPlatform.h"

#include "GMPChild.h"
#include "GMPStorageChild.h"
#include "GMPTimerChild.h"
#include "base/task.h"
#include "base/thread.h"
#include "base/time.h"
#include "mozilla/Atomics.h"
#include "mozilla/Monitor.h"
#include "mozilla/Mutex.h"
#include "mozilla/ReentrantMonitor.h"
#include "mozilla/StaticMutex.h"
#include "nsThreadUtils.h"

#ifdef XP_WIN
#  include "mozilla/UntrustedModulesProcessor.h"
#endif

#include <ctime>

namespace mozilla::gmp {

static GMPChild* sChild = nullptr;

// sShutdown is atomic so GMPRunnable::Run() can check it lock-free. The
// counters and the shutdown snapshot are serialized by sPlatformStateMutex so
// that closing admission and reading whether any plugin execution remains is a
// single transaction.
static Atomic<bool> sShutdown{false};
static StaticMutex sPlatformStateMutex;
static uint32_t sLiveThreads MOZ_GUARDED_BY(sPlatformStateMutex) = 0;
static uint32_t sLivePluginObjects MOZ_GUARDED_BY(sPlatformStateMutex) = 0;

// We just need a refcounted wrapper for GMPTask objects.
class GMPRunnable final : public Runnable {
 public:
  GMPRunnable(GMPTask* aTask, bool aCancelOnShutdown)
      : Runnable("mozilla::gmp::GMPRunnable"),
        mTask(aTask),
        mCancelOnShutdown(aCancelOnShutdown) {
    MOZ_ASSERT(mTask);
  }

  NS_IMETHOD Run() override {
    if (!(mCancelOnShutdown && sShutdown)) {
      mTask->Run();
      mTask->Destroy();
    }
    mTask = nullptr;
    return NS_OK;
  }

 private:
  GMPTask* mTask;
  const bool mCancelOnShutdown;
};

class GMPSyncRunnable final : public Runnable {
 public:
  explicit GMPSyncRunnable(GMPTask* aTask)
      : Runnable("mozilla::gmp::GMPSyncRunnable"), mTask(aTask) {
    MOZ_ASSERT(mTask);
  }

  void WaitUntilDone() {
    // We assert here for two reasons.
    // 1) Nobody should be blocking the main thread.
    // 2) This prevents deadlocks when doing sync calls to main which if the
    //    main thread tries to do a sync call back to the calling thread.
    MOZ_ASSERT(!NS_IsMainThread());

    MonitorAutoLock lock(mMonitor);
    while (!mDone) {
      lock.Wait();
    }
  }

  NS_IMETHOD Run() override {
    mTask->Run();
    mTask->Destroy();
    mTask = nullptr;
    MonitorAutoLock lock(mMonitor);
    mDone = true;
    lock.Notify();
    return NS_OK;
  }

 private:
  bool mDone MOZ_GUARDED_BY(mMonitor) = false;
  GMPTask* mTask;
  Monitor mMonitor{"GMPSyncRunnable"};
};

class GMPThreadImpl final : public GMPThread {
 public:
  GMPThreadImpl();
  virtual ~GMPThreadImpl();

  // GMPThread
  void Post(GMPTask* aTask) override;
  void Join() override;

 private:
  Mutex mMutex{"GMPThreadImpl"};
  base::Thread mThread MOZ_GUARDED_BY(mMutex){"GMPThread"};
};

GMPErr CreateThread(GMPThread** aThread) {
  if (!aThread) {
    return GMPGenericErr;
  }

  StaticMutexAutoLock lock(sPlatformStateMutex);
  if (sShutdown) {
    return GMPGenericErr;
  }

  *aThread = new GMPThreadImpl();
  ++sLiveThreads;

  return GMPNoErr;
}

GMPErr RunOnMainThread(GMPTask* aTask) {
  if (!aTask || sShutdown) {
    return GMPGenericErr;
  }

  if (NS_FAILED(NS_DispatchToMainThread(
          MakeAndAddRef<GMPRunnable>(aTask, /* aCancelOnShutdown */ true)))) {
    return GMPGenericErr;
  }

  return GMPNoErr;
}

GMPErr SyncRunOnMainThread(GMPTask* aTask) {
  if (!aTask || sShutdown || NS_IsMainThread()) {
    return GMPGenericErr;
  }

  RefPtr<GMPSyncRunnable> r = new GMPSyncRunnable(aTask);
  if (NS_FAILED(NS_DispatchToMainThread(r))) {
    return GMPGenericErr;
  }

  r->WaitUntilDone();
  return GMPNoErr;
}

class MOZ_CAPABILITY("mutex") GMPMutexImpl final : public GMPMutex {
 public:
  GMPMutexImpl();
  virtual ~GMPMutexImpl();

  // GMPMutex
  void Acquire() override MOZ_CAPABILITY_ACQUIRE();
  void Release() override MOZ_CAPABILITY_RELEASE();
  void Destroy() override;

 private:
  ReentrantMonitor mMonitor{"gmp-mutex"};
};

GMPErr CreateMutex(GMPMutex** aMutex) {
  if (!aMutex) {
    return GMPGenericErr;
  }

  *aMutex = new GMPMutexImpl();

  return GMPNoErr;
}

GMPErr CreateRecord(const char* aRecordName, uint32_t aRecordNameSize,
                    GMPRecord** aOutRecord, GMPRecordClient* aClient) {
  if (aRecordNameSize > GMP_MAX_RECORD_NAME_SIZE || aRecordNameSize == 0) {
    NS_WARNING("GMP tried to CreateRecord with too long or 0 record name");
    return GMPGenericErr;
  }
  GMPStorageChild* storage = sChild->GetGMPStorage();
  if (!storage) {
    return GMPGenericErr;
  }
  MOZ_ASSERT(storage);
  return storage->CreateRecord(nsDependentCString(aRecordName, aRecordNameSize),
                               aOutRecord, aClient);
}

GMPErr SetTimerOnMainThread(GMPTask* aTask, int64_t aTimeoutMS) {
  if (!aTask || sShutdown || !NS_IsMainThread()) {
    return GMPGenericErr;
  }
  GMPTimerChild* timers = sChild->GetGMPTimers();
  NS_ENSURE_TRUE(timers, GMPGenericErr);
  return timers->SetTimer(aTask, aTimeoutMS);
}

GMPErr GetClock(GMPTimestamp* aOutTime) {
  if (!aOutTime) {
    return GMPGenericErr;
  }
  *aOutTime = base::Time::Now().ToDoubleT() * 1000.0;
  return GMPNoErr;
}

void InitPlatformAPI(GMPPlatformAPI& aPlatformAPI, GMPChild* aChild) {
  if (!sChild) {
    sChild = aChild;
  }

  aPlatformAPI.version = 0;
  aPlatformAPI.createthread = &CreateThread;
  aPlatformAPI.runonmainthread = &RunOnMainThread;
  aPlatformAPI.syncrunonmainthread = &SyncRunOnMainThread;
  aPlatformAPI.createmutex = &CreateMutex;
  aPlatformAPI.createrecord = &CreateRecord;
  aPlatformAPI.settimer = &SetTimerOnMainThread;
  aPlatformAPI.getcurrenttime = &GetClock;
}

void AddPluginObject() {
  StaticMutexAutoLock lock(sPlatformStateMutex);
  ++sLivePluginObjects;
}

void RemovePluginObject() {
  StaticMutexAutoLock lock(sPlatformStateMutex);
  --sLivePluginObjects;
}

PlatformShutdownResult ShutdownPlatformAPI() {
  MOZ_ASSERT(NS_IsMainThread());
  StaticMutexAutoLock lock(sPlatformStateMutex);
  sShutdown = true;
  return sLiveThreads == 0 && sLivePluginObjects == 0
             ? PlatformShutdownResult::ReadyToUnload
             : PlatformShutdownResult::PluginExecutionOutstanding;
}

void SendFOGData(ipc::ByteBuf&& buf) {
  if (sChild) {
    sChild->SendFOGData(std::move(buf));
  }
}

#ifdef XP_WIN
RefPtr<PGMPChild::GetModulesTrustPromise> SendGetModulesTrust(
    ModuleIdentifiers&& aModules, bool aRunAtNormalPriority) {
  if (!sChild) {
    return PGMPChild::GetModulesTrustPromise::CreateAndReject(
        ipc::ResponseRejectReason::SendError, __func__);
  }
  return sChild->SendGetModulesTrust(std::move(aModules), aRunAtNormalPriority);
}
#endif

GMPThreadImpl::GMPThreadImpl() { MOZ_COUNT_CTOR(GMPThread); }

GMPThreadImpl::~GMPThreadImpl() {
  MOZ_COUNT_DTOR(GMPThread);
  StaticMutexAutoLock lock(sPlatformStateMutex);
  --sLiveThreads;
}

void GMPThreadImpl::Post(GMPTask* aTask) {
  MutexAutoLock lock(mMutex);

  if (!mThread.IsRunning()) {
    bool started = mThread.Start();
    if (!started) {
      NS_WARNING("Unable to start GMPThread!");
      return;
    }
  }

  RefPtr<GMPRunnable> r = new GMPRunnable(aTask, /* aCancelOnShutdown */ false);
  mThread.message_loop()->PostTask(
      NewRunnableMethod("gmp::GMPRunnable::Run", r.get(), &GMPRunnable::Run));
}

void GMPThreadImpl::Join() {
  {
    MutexAutoLock lock(mMutex);
    if (mThread.IsRunning()) {
      mThread.Stop();
    }
  }
  delete this;
}

GMPMutexImpl::GMPMutexImpl() { MOZ_COUNT_CTOR(GMPMutexImpl); }

GMPMutexImpl::~GMPMutexImpl() { MOZ_COUNT_DTOR(GMPMutexImpl); }

void GMPMutexImpl::Destroy() { delete this; }

MOZ_PUSH_IGNORE_THREAD_SAFETY
void GMPMutexImpl::Acquire() { mMonitor.Enter(); }

void GMPMutexImpl::Release() { mMonitor.Exit(); }
MOZ_POP_THREAD_SAFETY

GMPTask* NewGMPTask(std::function<void()>&& aFunction) {
  class Task : public GMPTask {
   public:
    explicit Task(std::function<void()>&& aFunction)
        : mFunction(std::move(aFunction)) {}
    void Destroy() override { delete this; }
    ~Task() override = default;
    void Run() override { mFunction(); }

   private:
    std::function<void()> mFunction;
  };
  return new Task(std::move(aFunction));
}

}  // namespace mozilla::gmp
