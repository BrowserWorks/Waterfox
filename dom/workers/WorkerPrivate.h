/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_dom_workers_workerprivate_h__
#define mozilla_dom_workers_workerprivate_h__

#include "Workers.h"

#include "js/CharacterEncoding.h"
#include "nsIContentPolicy.h"
#include "nsIContentSecurityPolicy.h"
#include "nsILoadGroup.h"
#include "nsIWorkerDebugger.h"
#include "nsPIDOMWindow.h"

#include "mozilla/Assertions.h"
#include "mozilla/Attributes.h"
#include "mozilla/CondVar.h"
#include "mozilla/ConsoleReportCollector.h"
#include "mozilla/DOMEventTargetHelper.h"
#include "mozilla/Move.h"
#include "mozilla/TimeStamp.h"
#include "mozilla/dom/BindingDeclarations.h"
#include "nsAutoPtr.h"
#include "nsCycleCollectionParticipant.h"
#include "nsDataHashtable.h"
#include "nsHashKeys.h"
#include "nsRefPtrHashtable.h"
#include "nsString.h"
#include "nsTArray.h"
#include "nsThreadUtils.h"
#include "nsTObserverArray.h"

#include "Queue.h"
#include "WorkerHolder.h"

#ifdef XP_WIN
#undef PostMessage
#endif

class nsIChannel;
class nsIConsoleReportCollector;
class nsIDocument;
class nsIEventTarget;
class nsIPrincipal;
class nsIScriptContext;
class nsIScriptTimeoutHandler;
class nsISerializable;
class nsIThread;
class nsIThreadInternal;
class nsITimer;
class nsIURI;
template<class T> class nsMainThreadPtrHandle;

namespace JS {
struct RuntimeStats;
} // namespace JS

namespace mozilla {
class ThrottledEventQueue;
namespace dom {
class Function;
class MessagePort;
class MessagePortIdentifier;
class PromiseNativeHandler;
class StructuredCloneHolder;
class WorkerDebuggerGlobalScope;
class WorkerGlobalScope;
struct WorkerOptions;
} // namespace dom
namespace ipc {
class PrincipalInfo;
} // namespace ipc
} // namespace mozilla

struct PRThread;

class ReportDebuggerErrorRunnable;
class PostDebuggerMessageRunnable;

BEGIN_WORKERS_NAMESPACE

class AutoSyncLoopHolder;
class SharedWorker;
class ServiceWorkerClientInfo;
class WorkerControlEventTarget;
class WorkerControlRunnable;
class WorkerDebugger;
class WorkerPrivate;
class WorkerRunnable;
class WorkerThread;

// SharedMutex is a small wrapper around an (internal) reference-counted Mutex
// object. It exists to avoid changing a lot of code to use Mutex* instead of
// Mutex&.
class SharedMutex
{
  typedef mozilla::Mutex Mutex;

  class RefCountedMutex final : public Mutex
  {
  public:
    explicit RefCountedMutex(const char* aName)
    : Mutex(aName)
    { }

    NS_INLINE_DECL_THREADSAFE_REFCOUNTING(RefCountedMutex)

  private:
    ~RefCountedMutex()
    { }
  };

  RefPtr<RefCountedMutex> mMutex;

public:
  explicit SharedMutex(const char* aName)
  : mMutex(new RefCountedMutex(aName))
  { }

  SharedMutex(SharedMutex& aOther)
  : mMutex(aOther.mMutex)
  { }

  operator Mutex&()
  {
    return *mMutex;
  }

  operator const Mutex&() const
  {
    return *mMutex;
  }

  void
  AssertCurrentThreadOwns() const
  {
    mMutex->AssertCurrentThreadOwns();
  }
};

class WorkerErrorBase {
public:
  nsString mMessage;
  nsString mFilename;
  uint32_t mLineNumber;
  uint32_t mColumnNumber;
  uint32_t mErrorNumber;

  WorkerErrorBase()
  : mLineNumber(0),
    mColumnNumber(0),
    mErrorNumber(0)
  { }

  void AssignErrorBase(JSErrorBase* aReport);
};

class WorkerErrorNote : public WorkerErrorBase {
public:
  void AssignErrorNote(JSErrorNotes::Note* aNote);
};

class WorkerErrorReport : public WorkerErrorBase {
public:
  nsString mLine;
  uint32_t mFlags;
  JSExnType mExnType;
  bool mMutedError;
  nsTArray<WorkerErrorNote> mNotes;

  WorkerErrorReport()
  : mFlags(0),
    mExnType(JSEXN_ERR),
    mMutedError(false)
  { }

  void AssignErrorReport(JSErrorReport* aReport);
};

template <class Derived>
class WorkerPrivateParent : public DOMEventTargetHelper
{
protected:
  class EventTarget;
  friend class EventTarget;

  typedef mozilla::ipc::PrincipalInfo PrincipalInfo;

public:
  struct LocationInfo
  {
    nsCString mHref;
    nsCString mProtocol;
    nsCString mHost;
    nsCString mHostname;
    nsCString mPort;
    nsCString mPathname;
    nsCString mSearch;
    nsCString mHash;
    nsString mOrigin;
  };

protected:
  typedef mozilla::ErrorResult ErrorResult;

  SharedMutex mMutex;
  mozilla::CondVar mCondVar;

  // Protected by mMutex.
  RefPtr<EventTarget> mEventTarget;
  nsTArray<RefPtr<WorkerRunnable>> mPreStartRunnables;

private:
  WorkerPrivate* mParent;
  nsString mScriptURL;
  // This is the worker name for shared workers and dedicated workers.
  nsString mWorkerName;
  // This is the worker scope for service workers.
  nsCString mServiceWorkerScope;
  LocationInfo mLocationInfo;
  // The lifetime of these objects within LoadInfo is managed explicitly;
  // they do not need to be cycle collected.
  WorkerLoadInfo mLoadInfo;

  Atomic<bool> mLoadingWorkerScript;

  // Only used for top level workers.
  nsTArray<nsCOMPtr<nsIRunnable>> mQueuedRunnables;

  // Protected by mMutex.
  JSSettings mJSSettings;

  // Only touched on the parent thread (currently this is always the main
  // thread as SharedWorkers are always top-level).
  nsTArray<RefPtr<SharedWorker>> mSharedWorkers;

  uint64_t mBusyCount;
  // SharedWorkers may have multiple windows paused, so this must be
  // a count instead of just a boolean.
  uint32_t mParentWindowPausedDepth;
  Status mParentStatus;
  bool mParentFrozen;
  bool mIsChromeWorker;
  bool mMainThreadObjectsForgotten;
  // mIsSecureContext is set once in our constructor; after that it can be read
  // from various threads.  We could make this const if we were OK with setting
  // it in the initializer list via calling some function that takes all sorts
  // of state (loadinfo, worker type, parent).
  //
  // It's a bit unfortunate that we have to have an out-of-band boolean for
  // this, but we need access to this state from the parent thread, and we can't
  // use our global object's secure state there.
  bool mIsSecureContext;
  WorkerType mWorkerType;
  TimeStamp mCreationTimeStamp;
  DOMHighResTimeStamp mCreationTimeHighRes;

protected:
  // The worker is owned by its thread, which is represented here.  This is set
  // in Construct() and emptied by WorkerFinishedRunnable, and conditionally
  // traversed by the cycle collector if the busy count is zero.
  RefPtr<WorkerPrivate> mSelfRef;

  WorkerPrivateParent(WorkerPrivate* aParent,
                      const nsAString& aScriptURL, bool aIsChromeWorker,
                      WorkerType aWorkerType,
                      const nsAString& aWorkerName,
                      const nsACString& aServiceWorkerScope,
                      WorkerLoadInfo& aLoadInfo);

  ~WorkerPrivateParent();

private:
  Derived*
  ParentAsWorkerPrivate() const
  {
    return static_cast<Derived*>(const_cast<WorkerPrivateParent*>(this));
  }

  bool
  NotifyPrivate(Status aStatus);

  bool
  TerminatePrivate()
  {
    return NotifyPrivate(Terminating);
  }

  void
  PostMessageInternal(JSContext* aCx, JS::Handle<JS::Value> aMessage,
                      const Sequence<JSObject*>& aTransferable,
                      ErrorResult& aRv);

  nsresult
  DispatchPrivate(already_AddRefed<WorkerRunnable> aRunnable, nsIEventTarget* aSyncLoopTarget);

public:
  virtual JSObject*
  WrapObject(JSContext* aCx, JS::Handle<JSObject*> aGivenProto) override;

  NS_DECL_ISUPPORTS_INHERITED
  NS_DECL_CYCLE_COLLECTION_SCRIPT_HOLDER_CLASS_INHERITED(WorkerPrivateParent,
                                                         DOMEventTargetHelper)

  void
  EnableDebugger();

  void
  DisableDebugger();

  void
  ClearSelfRef()
  {
    AssertIsOnParentThread();
    MOZ_ASSERT(mSelfRef);
    mSelfRef = nullptr;
  }

  nsresult
  Dispatch(already_AddRefed<WorkerRunnable> aRunnable)
  {
    return DispatchPrivate(Move(aRunnable), nullptr);
  }

  nsresult
  DispatchControlRunnable(already_AddRefed<WorkerControlRunnable> aWorkerControlRunnable);

  nsresult
  DispatchDebuggerRunnable(already_AddRefed<WorkerRunnable> aDebuggerRunnable);

  already_AddRefed<WorkerRunnable>
  MaybeWrapAsWorkerRunnable(already_AddRefed<nsIRunnable> aRunnable);

  already_AddRefed<nsIEventTarget>
  GetEventTarget();

  // May be called on any thread...
  bool
  Start();

  // Called on the parent thread.
  bool
  Notify(Status aStatus)
  {
    return NotifyPrivate(aStatus);
  }

  bool
  Cancel()
  {
    return Notify(Canceling);
  }

  bool
  Kill()
  {
    return Notify(Killing);
  }

  // We can assume that an nsPIDOMWindow will be available for Freeze, Thaw
  // as these are only used for globals going in and out of the bfcache.
  //
  // XXXbz: This is a bald-faced lie given the uses in RegisterSharedWorker and
  // CloseSharedWorkersForWindow, which pass null for aWindow to Thaw and Freeze
  // respectively.  See bug 1251722.
  bool
  Freeze(nsPIDOMWindowInner* aWindow);

  bool
  Thaw(nsPIDOMWindowInner* aWindow);

  // When we debug a worker, we want to disconnect the window and the worker
  // communication. This happens calling this method.
  // Note: this method doesn't suspend the worker! Use Freeze/Thaw instead.
  void
  ParentWindowPaused();

  void
  ParentWindowResumed();

  bool
  Terminate()
  {
    AssertIsOnParentThread();
    return TerminatePrivate();
  }

  bool
  Close();

  bool
  ModifyBusyCount(bool aIncrease);

  bool
  ProxyReleaseMainThreadObjects();

  void
  PostMessage(JSContext* aCx, JS::Handle<JS::Value> aMessage,
              const Sequence<JSObject*>& aTransferable,
              ErrorResult& aRv);

  void
  UpdateContextOptions(const JS::ContextOptions& aContextOptions);

  void
  UpdateLanguages(const nsTArray<nsString>& aLanguages);

  void
  UpdatePreference(WorkerPreference aPref, bool aValue);

  void
  UpdateJSWorkerMemoryParameter(JSGCParamKey key, uint32_t value);

#ifdef JS_GC_ZEAL
  void
  UpdateGCZeal(uint8_t aGCZeal, uint32_t aFrequency);
#endif

  void
  GarbageCollect(bool aShrinking);

  void
  CycleCollect(bool aDummy);

  void
  OfflineStatusChangeEvent(bool aIsOffline);

  void
  MemoryPressure(bool aDummy);

  bool
  RegisterSharedWorker(SharedWorker* aSharedWorker, MessagePort* aPort);

  void
  BroadcastErrorToSharedWorkers(JSContext* aCx,
                                const WorkerErrorReport* aReport,
                                bool aIsErrorEvent);

  void
  WorkerScriptLoaded();

  void
  QueueRunnable(nsIRunnable* aRunnable)
  {
    AssertIsOnParentThread();
    mQueuedRunnables.AppendElement(aRunnable);
  }

  WorkerPrivate*
  GetParent() const
  {
    return mParent;
  }

  bool
  IsFrozen() const
  {
    AssertIsOnParentThread();
    return mParentFrozen;
  }

  bool
  IsParentWindowPaused() const
  {
    AssertIsOnParentThread();
    return mParentWindowPausedDepth > 0;
  }

  bool
  IsAcceptingEvents()
  {
    AssertIsOnParentThread();

    MutexAutoLock lock(mMutex);
    return mParentStatus < Terminating;
    }

  Status
  ParentStatus() const
  {
    mMutex.AssertCurrentThreadOwns();
    return mParentStatus;
  }

  nsIScriptContext*
  GetScriptContext() const
  {
    AssertIsOnMainThread();
    return mLoadInfo.mScriptContext;
  }

  const nsString&
  ScriptURL() const
  {
    return mScriptURL;
  }

  const nsCString&
  Domain() const
  {
    return mLoadInfo.mDomain;
  }

  bool
  IsFromWindow() const
  {
    return mLoadInfo.mFromWindow;
  }

  nsLoadFlags
  GetLoadFlags() const
  {
    return mLoadInfo.mLoadFlags;
  }

  uint64_t
  WindowID() const
  {
    return mLoadInfo.mWindowID;
  }

  uint64_t
  ServiceWorkerID() const
  {
    return mLoadInfo.mServiceWorkerID;
  }

  const nsCString&
  ServiceWorkerScope() const
  {
    MOZ_DIAGNOSTIC_ASSERT(IsServiceWorker());
    return mServiceWorkerScope;
  }

  nsIURI*
  GetBaseURI() const
  {
    AssertIsOnMainThread();
    return mLoadInfo.mBaseURI;
  }

  void
  SetBaseURI(nsIURI* aBaseURI);

  nsIURI*
  GetResolvedScriptURI() const
  {
    AssertIsOnMainThread();
    return mLoadInfo.mResolvedScriptURI;
  }

  const nsString&
  ServiceWorkerCacheName() const
  {
    MOZ_ASSERT(IsServiceWorker());
    AssertIsOnMainThread();
    return mLoadInfo.mServiceWorkerCacheName;
  }

  const ChannelInfo&
  GetChannelInfo() const
  {
    return mLoadInfo.mChannelInfo;
  }

  void
  SetChannelInfo(const ChannelInfo& aChannelInfo)
  {
    AssertIsOnMainThread();
    MOZ_ASSERT(!mLoadInfo.mChannelInfo.IsInitialized());
    MOZ_ASSERT(aChannelInfo.IsInitialized());
    mLoadInfo.mChannelInfo = aChannelInfo;
  }

  void
  InitChannelInfo(nsIChannel* aChannel)
  {
    mLoadInfo.mChannelInfo.InitFromChannel(aChannel);
  }

  void
  InitChannelInfo(const ChannelInfo& aChannelInfo)
  {
    mLoadInfo.mChannelInfo = aChannelInfo;
  }

  // This is used to handle importScripts(). When the worker is first loaded
  // and executed, it happens in a sync loop. At this point it sets
  // mLoadingWorkerScript to true. importScripts() calls that occur during the
  // execution run in nested sync loops and so this continues to return true,
  // leading to these scripts being cached offline.
  // mLoadingWorkerScript is set to false when the top level loop ends.
  // importScripts() in function calls or event handlers are always fetched
  // from the network.
  bool
  LoadScriptAsPartOfLoadingServiceWorkerScript()
  {
    MOZ_ASSERT(IsServiceWorker());
    return mLoadingWorkerScript;
  }

  void
  SetLoadingWorkerScript(bool aLoadingWorkerScript)
  {
    // any thread
    MOZ_ASSERT(IsServiceWorker());
    mLoadingWorkerScript = aLoadingWorkerScript;
  }

  TimeStamp CreationTimeStamp() const
  {
    return mCreationTimeStamp;
  }

  DOMHighResTimeStamp CreationTime() const
  {
    return mCreationTimeHighRes;
  }

  DOMHighResTimeStamp TimeStampToDOMHighRes(const TimeStamp& aTimeStamp) const
  {
    MOZ_ASSERT(!aTimeStamp.IsNull());
    TimeDuration duration = aTimeStamp - mCreationTimeStamp;
    return duration.ToMilliseconds();
  }

  nsIPrincipal*
  GetPrincipal() const
  {
    AssertIsOnMainThread();
    return mLoadInfo.mPrincipal;
  }

  const nsAString& Origin() const
  {
    return mLoadInfo.mOrigin;
  }

  nsILoadGroup*
  GetLoadGroup() const
  {
    AssertIsOnMainThread();
    return mLoadInfo.mLoadGroup;
  }

  // This method allows the principal to be retrieved off the main thread.
  // Principals are main-thread objects so the caller must ensure that all
  // access occurs on the main thread.
  nsIPrincipal*
  GetPrincipalDontAssertMainThread() const
  {
      return mLoadInfo.mPrincipal;
  }

  nsresult
  SetPrincipalOnMainThread(nsIPrincipal* aPrincipal, nsILoadGroup* aLoadGroup);

  nsresult
  SetPrincipalFromChannel(nsIChannel* aChannel);

#ifdef MOZ_DIAGNOSTIC_ASSERT_ENABLED
  bool
  FinalChannelPrincipalIsValid(nsIChannel* aChannel);

  bool
  PrincipalURIMatchesScriptURL();
#endif

  bool
  UsesSystemPrincipal() const
  {
    return mLoadInfo.mPrincipalIsSystem;
  }

  const PrincipalInfo&
  GetPrincipalInfo() const
  {
    return *mLoadInfo.mPrincipalInfo;
  }

  already_AddRefed<nsIChannel>
  ForgetWorkerChannel()
  {
    AssertIsOnMainThread();
    return mLoadInfo.mChannel.forget();
  }

  nsIDocument* GetDocument() const;

  nsPIDOMWindowInner*
  GetWindow()
  {
    AssertIsOnMainThread();
    return mLoadInfo.mWindow;
  }

  nsIContentSecurityPolicy*
  GetCSP() const
  {
    AssertIsOnMainThread();
    return mLoadInfo.mCSP;
  }

  void
  SetCSP(nsIContentSecurityPolicy* aCSP);

  nsresult
  SetCSPFromHeaderValues(const nsACString& aCSPHeaderValue,
                         const nsACString& aCSPReportOnlyHeaderValue);

  void
  SetReferrerPolicyFromHeaderValue(const nsACString& aReferrerPolicyHeaderValue);

  net::ReferrerPolicy
  GetReferrerPolicy() const
  {
    return mLoadInfo.mReferrerPolicy;
  }

  void
  SetReferrerPolicy(net::ReferrerPolicy aReferrerPolicy)
  {
    mLoadInfo.mReferrerPolicy = aReferrerPolicy;
  }

  bool
  IsEvalAllowed() const
  {
    return mLoadInfo.mEvalAllowed;
  }

  void
  SetEvalAllowed(bool aEvalAllowed)
  {
    mLoadInfo.mEvalAllowed = aEvalAllowed;
  }

  bool
  GetReportCSPViolations() const
  {
    return mLoadInfo.mReportCSPViolations;
  }

  void
  SetReportCSPViolations(bool aReport)
  {
    mLoadInfo.mReportCSPViolations = aReport;
  }

  bool
  XHRParamsAllowed() const
  {
    return mLoadInfo.mXHRParamsAllowed;
  }

  void
  SetXHRParamsAllowed(bool aAllowed)
  {
    mLoadInfo.mXHRParamsAllowed = aAllowed;
  }

  LocationInfo&
  GetLocationInfo()
  {
    return mLocationInfo;
  }

  void
  CopyJSSettings(JSSettings& aSettings)
  {
    mozilla::MutexAutoLock lock(mMutex);
    aSettings = mJSSettings;
  }

  void
  CopyJSCompartmentOptions(JS::CompartmentOptions& aOptions)
  {
    mozilla::MutexAutoLock lock(mMutex);
    aOptions = IsChromeWorker() ? mJSSettings.chrome.compartmentOptions
                                : mJSSettings.content.compartmentOptions;
  }

  // The ability to be a chrome worker is orthogonal to the type of
  // worker [Dedicated|Shared|Service].
  bool
  IsChromeWorker() const
  {
    return mIsChromeWorker;
  }

  WorkerType
  Type() const
  {
    return mWorkerType;
  }

  bool
  IsDedicatedWorker() const
  {
    return mWorkerType == WorkerTypeDedicated;
  }

  bool
  IsSharedWorker() const
  {
    return mWorkerType == WorkerTypeShared;
  }

  bool
  IsServiceWorker() const
  {
    return mWorkerType == WorkerTypeService;
  }

  nsContentPolicyType
  ContentPolicyType() const
  {
    return ContentPolicyType(mWorkerType);
  }

  static nsContentPolicyType
  ContentPolicyType(WorkerType aWorkerType)
  {
    switch (aWorkerType) {
    case WorkerTypeDedicated:
      return nsIContentPolicy::TYPE_INTERNAL_WORKER;
    case WorkerTypeShared:
      return nsIContentPolicy::TYPE_INTERNAL_SHARED_WORKER;
    case WorkerTypeService:
      return nsIContentPolicy::TYPE_INTERNAL_SERVICE_WORKER;
    default:
      MOZ_ASSERT_UNREACHABLE("Invalid worker type");
      return nsIContentPolicy::TYPE_INVALID;
    }
  }

  const nsString&
  WorkerName() const
  {
    return mWorkerName;
  }

  bool
  IsStorageAllowed() const
  {
    return mLoadInfo.mStorageAllowed;
  }

  const OriginAttributes&
  GetOriginAttributes() const
  {
    return mLoadInfo.mOriginAttributes;
  }

  // Determine if the SW testing per-window flag is set by devtools
  bool
  ServiceWorkersTestingInWindow() const
  {
    return mLoadInfo.mServiceWorkersTestingInWindow;
  }

  void
  GetAllSharedWorkers(nsTArray<RefPtr<SharedWorker>>& aSharedWorkers);

  void
  CloseSharedWorkersForWindow(nsPIDOMWindowInner* aWindow);

  void
  CloseAllSharedWorkers();

  void
  UpdateOverridenLoadGroup(nsILoadGroup* aBaseLoadGroup);

  already_AddRefed<nsIRunnable>
  StealLoadFailedAsyncRunnable()
  {
    return mLoadInfo.mLoadFailedAsyncRunnable.forget();
  }

  void
  FlushReportsToSharedWorkers(nsIConsoleReportCollector* aReporter);

  IMPL_EVENT_HANDLER(message)
  IMPL_EVENT_HANDLER(error)

  // Check whether this worker is a secure context.  For use from the parent
  // thread only; the canonical "is secure context" boolean is stored on the
  // compartment of the worker global.  The only reason we don't
  // AssertIsOnParentThread() here is so we can assert that this value matches
  // the one on the compartment, which has to be done from the worker thread.
  bool IsSecureContext() const
  {
    return mIsSecureContext;
  }

#ifdef DEBUG
  void
  AssertIsOnParentThread() const;

  void
  AssertInnerWindowIsCorrect() const;
#else
  void
  AssertIsOnParentThread() const
  { }

  void
  AssertInnerWindowIsCorrect() const
  { }
#endif

#ifdef MOZ_DIAGNOSTIC_ASSERT_ENABLED
  bool
  PrincipalIsValid() const;
#endif
};

class WorkerDebugger : public nsIWorkerDebugger {
  friend class ::ReportDebuggerErrorRunnable;
  friend class ::PostDebuggerMessageRunnable;

  WorkerPrivate* mWorkerPrivate;
  bool mIsInitialized;
  nsTArray<nsCOMPtr<nsIWorkerDebuggerListener>> mListeners;

public:
  explicit WorkerDebugger(WorkerPrivate* aWorkerPrivate);

  NS_DECL_ISUPPORTS
  NS_DECL_NSIWORKERDEBUGGER

  void
  AssertIsOnParentThread();

  void
  Close();

  void
  PostMessageToDebugger(const nsAString& aMessage);

  void
  ReportErrorToDebugger(const nsAString& aFilename, uint32_t aLineno,
                        const nsAString& aMessage);

private:
  virtual
  ~WorkerDebugger();

  void
  PostMessageToDebuggerOnMainThread(const nsAString& aMessage);

  void
  ReportErrorToDebuggerOnMainThread(const nsAString& aFilename,
                                    uint32_t aLineno,
                                    const nsAString& aMessage);
};

class WorkerPrivate : public WorkerPrivateParent<WorkerPrivate>
{
  friend class WorkerHolder;
  friend class WorkerPrivateParent<WorkerPrivate>;
  typedef WorkerPrivateParent<WorkerPrivate> ParentType;
  friend class AutoSyncLoopHolder;

  struct TimeoutInfo;

  class MemoryReporter;
  friend class MemoryReporter;

  friend class WorkerThread;

  enum GCTimerMode
  {
    PeriodicTimer = 0,
    IdleTimer,
    NoTimer
  };

  bool mDebuggerRegistered;
  WorkerDebugger* mDebugger;

  Queue<WorkerControlRunnable*, 4> mControlQueue;
  Queue<WorkerRunnable*, 4> mDebuggerQueue;

  // Touched on multiple threads, protected with mMutex.
  JSContext* mJSContext;
  RefPtr<WorkerCrossThreadDispatcher> mCrossThreadDispatcher;
  nsTArray<nsCOMPtr<nsIRunnable>> mUndispatchedRunnablesForSyncLoop;
  RefPtr<WorkerThread> mThread;
  PRThread* mPRThread;

  // Things touched on worker thread only.
  RefPtr<WorkerGlobalScope> mScope;
  RefPtr<WorkerDebuggerGlobalScope> mDebuggerScope;
  nsTArray<ParentType*> mChildWorkers;
  nsTObserverArray<WorkerHolder*> mHolders;
  uint32_t mNumHoldersPreventingShutdownStart;
  nsTArray<nsAutoPtr<TimeoutInfo>> mTimeouts;
  uint32_t mDebuggerEventLoopLevel;
  RefPtr<ThrottledEventQueue> mMainThreadThrottledEventQueue;
  nsCOMPtr<nsIEventTarget> mMainThreadEventTarget;
  RefPtr<WorkerControlEventTarget> mWorkerControlEventTarget;

  struct SyncLoopInfo
  {
    explicit SyncLoopInfo(EventTarget* aEventTarget);

    RefPtr<EventTarget> mEventTarget;
    bool mCompleted;
    bool mResult;
#ifdef DEBUG
    bool mHasRun;
#endif
  };

  // This is only modified on the worker thread, but in DEBUG builds
  // AssertValidSyncLoop function iterates it on other threads. Therefore
  // modifications are done with mMutex held *only* in DEBUG builds.
  nsTArray<nsAutoPtr<SyncLoopInfo>> mSyncLoopStack;

  nsCOMPtr<nsITimer> mTimer;
  nsCOMPtr<nsITimerCallback> mTimerRunnable;

  nsCOMPtr<nsITimer> mGCTimer;

  RefPtr<MemoryReporter> mMemoryReporter;

  // fired on the main thread if the worker script fails to load
  nsCOMPtr<nsIRunnable> mLoadFailedRunnable;

  JS::UniqueChars mDefaultLocale; // nulled during worker JSContext init
  TimeStamp mKillTime;
  uint32_t mErrorHandlerRecursionCount;
  uint32_t mNextTimeoutId;
  Status mStatus;
  bool mFrozen;
  bool mTimerRunning;
  bool mRunningExpiredTimeouts;
  bool mPendingEventQueueClearing;
  bool mCancelAllPendingRunnables;
  bool mPeriodicGCTimerRunning;
  bool mIdleGCTimerRunning;
  bool mWorkerScriptExecutedSuccessfully;
  bool mFetchHandlerWasAdded;
  bool mPreferences[WORKERPREF_COUNT];
  bool mOnLine;

protected:
  ~WorkerPrivate();

public:
  static already_AddRefed<WorkerPrivate>
  Constructor(const GlobalObject& aGlobal, const nsAString& aScriptURL,
              const WorkerOptions& aOptions,
              ErrorResult& aRv);

  static already_AddRefed<WorkerPrivate>
  Constructor(const GlobalObject& aGlobal, const nsAString& aScriptURL,
              bool aIsChromeWorker, WorkerType aWorkerType,
              const nsAString& aWorkerName,
              WorkerLoadInfo* aLoadInfo, ErrorResult& aRv);

  static already_AddRefed<WorkerPrivate>
  Constructor(JSContext* aCx, const nsAString& aScriptURL, bool aIsChromeWorker,
              WorkerType aWorkerType, const nsAString& aWorkerName,
              const nsACString& aServiceWorkerScope,
              WorkerLoadInfo* aLoadInfo, ErrorResult& aRv);

  static bool
  WorkerAvailable(JSContext* /* unused */, JSObject* /* unused */);

  enum LoadGroupBehavior
  {
    InheritLoadGroup,
    OverrideLoadGroup
  };

  static nsresult
  GetLoadInfo(JSContext* aCx, nsPIDOMWindowInner* aWindow,
              WorkerPrivate* aParent,
              const nsAString& aScriptURL, bool aIsChromeWorker,
              LoadGroupBehavior aLoadGroupBehavior, WorkerType aWorkerType,
              WorkerLoadInfo* aLoadInfo);

  static void
  OverrideLoadInfoLoadGroup(WorkerLoadInfo& aLoadInfo);

  bool
  IsDebuggerRegistered()
  {
    AssertIsOnMainThread();

    // No need to lock here since this is only ever modified by the same thread.
    return mDebuggerRegistered;
  }

  void
  SetIsDebuggerRegistered(bool aDebuggerRegistered)
  {
    AssertIsOnMainThread();

    MutexAutoLock lock(mMutex);

    MOZ_ASSERT(mDebuggerRegistered != aDebuggerRegistered);
    mDebuggerRegistered = aDebuggerRegistered;

    mCondVar.Notify();
  }

  void
  WaitForIsDebuggerRegistered(bool aDebuggerRegistered)
  {
    AssertIsOnParentThread();

    MOZ_ASSERT(!NS_IsMainThread());

    MutexAutoLock lock(mMutex);

    while (mDebuggerRegistered != aDebuggerRegistered) {
      mCondVar.Wait();
    }
  }

  WorkerDebugger*
  Debugger() const
  {
    AssertIsOnMainThread();

    MOZ_ASSERT(mDebugger);
    return mDebugger;
  }

  void
  SetDebugger(WorkerDebugger* aDebugger)
  {
    AssertIsOnMainThread();

    MOZ_ASSERT(mDebugger != aDebugger);
    mDebugger = aDebugger;
  }

  JS::UniqueChars
  AdoptDefaultLocale()
  {
    MOZ_ASSERT(mDefaultLocale,
               "the default locale must have been successfully set for anyone "
               "to be trying to adopt it");
    return Move(mDefaultLocale);
  }

  void
  DoRunLoop(JSContext* aCx);

  bool
  InterruptCallback(JSContext* aCx);

  nsresult
  IsOnCurrentThread(bool* aIsOnCurrentThread);

  bool
  CloseInternal(JSContext* aCx)
  {
    AssertIsOnWorkerThread();
    return NotifyInternal(aCx, Closing);
  }

  bool
  FreezeInternal();

  bool
  ThawInternal();

  void
  TraverseTimeouts(nsCycleCollectionTraversalCallback& aCallback);

  void
  UnlinkTimeouts();

  bool
  ModifyBusyCountFromWorker(bool aIncrease);

  bool
  AddChildWorker(ParentType* aChildWorker);

  void
  RemoveChildWorker(ParentType* aChildWorker);

  void
  PostMessageToParent(JSContext* aCx,
                      JS::Handle<JS::Value> aMessage,
                      const Sequence<JSObject*>& aTransferable,
                      ErrorResult& aRv)
  {
    PostMessageToParentInternal(aCx, aMessage, aTransferable, aRv);
  }

  void
  PostMessageToParentMessagePort(JSContext* aCx,
                                 JS::Handle<JS::Value> aMessage,
                                 const Sequence<JSObject*>& aTransferable,
                                 ErrorResult& aRv);

  void
  EnterDebuggerEventLoop();

  void
  LeaveDebuggerEventLoop();

  void
  PostMessageToDebugger(const nsAString& aMessage);

  void
  SetDebuggerImmediate(Function& aHandler, ErrorResult& aRv);

  void
  ReportErrorToDebugger(const nsAString& aFilename, uint32_t aLineno,
                        const nsAString& aMessage);

  bool
  NotifyInternal(JSContext* aCx, Status aStatus);

  void
  ReportError(JSContext* aCx, JS::ConstUTF8CharsZ aToStringResult,
              JSErrorReport* aReport);

  static void
  ReportErrorToConsole(const char* aMessage);

  int32_t
  SetTimeout(JSContext* aCx, nsIScriptTimeoutHandler* aHandler,
             int32_t aTimeout, bool aIsInterval,
             ErrorResult& aRv);

  void
  ClearTimeout(int32_t aId);

  bool
  RunExpiredTimeouts(JSContext* aCx);

  bool
  RescheduleTimeoutTimer(JSContext* aCx);

  void
  UpdateContextOptionsInternal(JSContext* aCx, const JS::ContextOptions& aContextOptions);

  void
  UpdateLanguagesInternal(const nsTArray<nsString>& aLanguages);

  void
  UpdatePreferenceInternal(WorkerPreference aPref, bool aValue);

  void
  UpdateJSWorkerMemoryParameterInternal(JSContext* aCx, JSGCParamKey key, uint32_t aValue);

  enum WorkerRanOrNot {
    WorkerNeverRan = 0,
    WorkerRan
  };

  void
  ScheduleDeletion(WorkerRanOrNot aRanOrNot);

  bool
  CollectRuntimeStats(JS::RuntimeStats* aRtStats, bool aAnonymize);

#ifdef JS_GC_ZEAL
  void
  UpdateGCZealInternal(JSContext* aCx, uint8_t aGCZeal, uint32_t aFrequency);
#endif

  void
  GarbageCollectInternal(JSContext* aCx, bool aShrinking,
                         bool aCollectChildren);

  void
  CycleCollectInternal(bool aCollectChildren);

  void
  OfflineStatusChangeEventInternal(bool aIsOffline);

  void
  MemoryPressureInternal();

  void
  SetFetchHandlerWasAdded()
  {
    MOZ_ASSERT(IsServiceWorker());
    AssertIsOnWorkerThread();
    mFetchHandlerWasAdded = true;
  }

  bool
  FetchHandlerWasAdded() const
  {
    MOZ_ASSERT(IsServiceWorker());
    AssertIsOnWorkerThread();
    return mFetchHandlerWasAdded;
  }

  JSContext*
  GetJSContext() const
  {
    AssertIsOnWorkerThread();
    return mJSContext;
  }

  WorkerGlobalScope*
  GlobalScope() const
  {
    AssertIsOnWorkerThread();
    return mScope;
  }

  WorkerDebuggerGlobalScope*
  DebuggerGlobalScope() const
  {
    AssertIsOnWorkerThread();
    return mDebuggerScope;
  }

  void
  SetThread(WorkerThread* aThread);

  void
  AssertIsOnWorkerThread() const
#ifdef DEBUG
  ;
#else
  { }
#endif

  WorkerCrossThreadDispatcher*
  GetCrossThreadDispatcher();

  // This may block!
  void
  BeginCTypesCall();

  // This may block!
  void
  EndCTypesCall();

  void
  BeginCTypesCallback()
  {
    // If a callback is beginning then we need to do the exact same thing as
    // when a ctypes call ends.
    EndCTypesCall();
  }

  void
  EndCTypesCallback()
  {
    // If a callback is ending then we need to do the exact same thing as
    // when a ctypes call begins.
    BeginCTypesCall();
  }

  bool
  ConnectMessagePort(JSContext* aCx, MessagePortIdentifier& aIdentifier);

  WorkerGlobalScope*
  GetOrCreateGlobalScope(JSContext* aCx);

  WorkerDebuggerGlobalScope*
  CreateDebuggerGlobalScope(JSContext* aCx);

  bool
  RegisterBindings(JSContext* aCx, JS::Handle<JSObject*> aGlobal);

  bool
  RegisterDebuggerBindings(JSContext* aCx, JS::Handle<JSObject*> aGlobal);

#define WORKER_SIMPLE_PREF(name, getter, NAME)                                \
  bool                                                                        \
  getter() const                                                              \
  {                                                                           \
    AssertIsOnWorkerThread();                                                 \
    return mPreferences[WORKERPREF_##NAME];                                   \
  }
#define WORKER_PREF(name, callback)
#include "WorkerPrefs.h"
#undef WORKER_SIMPLE_PREF
#undef WORKER_PREF

  bool
  OnLine() const
  {
    AssertIsOnWorkerThread();
    return mOnLine;
  }

  void
  StopSyncLoop(nsIEventTarget* aSyncLoopTarget, bool aResult);

  bool
  AllPendingRunnablesShouldBeCanceled() const
  {
    return mCancelAllPendingRunnables;
  }

  void
  ClearMainEventQueue(WorkerRanOrNot aRanOrNot);

  void
  ClearDebuggerEventQueue();

  void
  OnProcessNextEvent();

  void
  AfterProcessNextEvent();

  void
  AssertValidSyncLoop(nsIEventTarget* aSyncLoopTarget)
#ifdef DEBUG
  ;
#else
  { }
#endif

  void
  SetWorkerScriptExecutedSuccessfully()
  {
    AssertIsOnWorkerThread();
    // Should only be called once!
    MOZ_ASSERT(!mWorkerScriptExecutedSuccessfully);
    mWorkerScriptExecutedSuccessfully = true;
  }

  // Only valid after CompileScriptRunnable has finished running!
  bool
  WorkerScriptExecutedSuccessfully() const
  {
    AssertIsOnWorkerThread();
    return mWorkerScriptExecutedSuccessfully;
  }

  void
  MaybeDispatchLoadFailedRunnable();

  // Get the event target to use when dispatching to the main thread
  // from this Worker thread.  This may be the main thread itself or
  // a ThrottledEventQueue to the main thread.
  nsIEventTarget*
  MainThreadEventTarget();

  nsresult
  DispatchToMainThread(nsIRunnable* aRunnable,
                       uint32_t aFlags = NS_DISPATCH_NORMAL);

  nsresult
  DispatchToMainThread(already_AddRefed<nsIRunnable> aRunnable,
                       uint32_t aFlags = NS_DISPATCH_NORMAL);

  // Get an event target that will dispatch runnables as control runnables on
  // the worker thread.  Implement nsICancelableRunnable if you wish to take
  // action on cancelation.
  nsIEventTarget*
  ControlEventTarget();

private:
  WorkerPrivate(WorkerPrivate* aParent,
                const nsAString& aScriptURL, bool aIsChromeWorker,
                WorkerType aWorkerType, const nsAString& aWorkerName,
                const nsACString& aServiceWorkerScope,
                WorkerLoadInfo& aLoadInfo);

  bool
  MayContinueRunning()
  {
    AssertIsOnWorkerThread();

    Status status;
    {
      MutexAutoLock lock(mMutex);
      status = mStatus;
    }

    if (status < Terminating) {
      return true;
    }

    return false;
  }

  void
  CancelAllTimeouts();

  enum class ProcessAllControlRunnablesResult
  {
    // We did not process anything.
    Nothing,
    // We did process something, states may have changed, but we can keep
    // executing script.
    MayContinue,
    // We did process something, and should not continue executing script.
    Abort
  };

  ProcessAllControlRunnablesResult
  ProcessAllControlRunnables()
  {
    MutexAutoLock lock(mMutex);
    return ProcessAllControlRunnablesLocked();
  }

  ProcessAllControlRunnablesResult
  ProcessAllControlRunnablesLocked();

  void
  EnableMemoryReporter();

  void
  DisableMemoryReporter();

  void
  WaitForWorkerEvents(PRIntervalTime interval = PR_INTERVAL_NO_TIMEOUT);

  void
  PostMessageToParentInternal(JSContext* aCx,
                              JS::Handle<JS::Value> aMessage,
                              const Sequence<JSObject*>& aTransferable,
                              ErrorResult& aRv);

  void
  GetAllPreferences(bool aPreferences[WORKERPREF_COUNT]) const
  {
    AssertIsOnWorkerThread();
    memcpy(aPreferences, mPreferences, WORKERPREF_COUNT * sizeof(bool));
  }

  // If the worker shutdown status is equal or greater then aFailStatus, this
  // operation will fail and nullptr will be returned. See WorkerHolder.h for
  // more information about the correct value to use.
  already_AddRefed<nsIEventTarget>
  CreateNewSyncLoop(Status aFailStatus);

  bool
  RunCurrentSyncLoop();

  bool
  DestroySyncLoop(uint32_t aLoopIndex, nsIThreadInternal* aThread = nullptr);

  void
  InitializeGCTimers();

  void
  SetGCTimerMode(GCTimerMode aMode);

  void
  ShutdownGCTimers();

  bool
  AddHolder(WorkerHolder* aHolder, Status aFailStatus);

  void
  RemoveHolder(WorkerHolder* aHolder);

  void
  NotifyHolders(JSContext* aCx, Status aStatus);

  bool
  HasActiveHolders()
  {
    return !(mChildWorkers.IsEmpty() && mTimeouts.IsEmpty() &&
             mHolders.IsEmpty());
  }
};

// This class is only used to trick the DOM bindings.  We never create
// instances of it, and static_casting to it is fine since it doesn't add
// anything to WorkerPrivate.
class ChromeWorkerPrivate : public WorkerPrivate
{
public:
  static already_AddRefed<ChromeWorkerPrivate>
  Constructor(const GlobalObject& aGlobal, const nsAString& aScriptURL,
              ErrorResult& rv);

  static bool
  WorkerAvailable(JSContext* aCx, JSObject* /* unused */);

private:
  ChromeWorkerPrivate() = delete;
  ChromeWorkerPrivate(const ChromeWorkerPrivate& aRHS) = delete;
  ChromeWorkerPrivate& operator =(const ChromeWorkerPrivate& aRHS) = delete;
};

WorkerPrivate*
GetWorkerPrivateFromContext(JSContext* aCx);

WorkerPrivate*
GetCurrentThreadWorkerPrivate();

bool
IsCurrentThreadRunningChromeWorker();

JSContext*
GetCurrentThreadJSContext();

JSObject*
GetCurrentThreadWorkerGlobal();

class AutoSyncLoopHolder
{
  WorkerPrivate* mWorkerPrivate;
  nsCOMPtr<nsIEventTarget> mTarget;
  uint32_t mIndex;

public:
  // See CreateNewSyncLoop() for more information about the correct value to use
  // for aFailStatus.
  AutoSyncLoopHolder(WorkerPrivate* aWorkerPrivate, Status aFailStatus)
  : mWorkerPrivate(aWorkerPrivate)
  , mTarget(aWorkerPrivate->CreateNewSyncLoop(aFailStatus))
  , mIndex(aWorkerPrivate->mSyncLoopStack.Length() - 1)
  {
    aWorkerPrivate->AssertIsOnWorkerThread();
  }

  ~AutoSyncLoopHolder()
  {
    if (mWorkerPrivate && mTarget) {
      mWorkerPrivate->AssertIsOnWorkerThread();
      mWorkerPrivate->StopSyncLoop(mTarget, false);
      mWorkerPrivate->DestroySyncLoop(mIndex);
    }
  }

  bool
  Run()
  {
    WorkerPrivate* workerPrivate = mWorkerPrivate;
    mWorkerPrivate = nullptr;

    workerPrivate->AssertIsOnWorkerThread();

    return workerPrivate->RunCurrentSyncLoop();
  }

  nsIEventTarget*
  GetEventTarget() const
  {
    // This can be null if CreateNewSyncLoop() fails.
    return mTarget;
  }
};

END_WORKERS_NAMESPACE

#endif /* mozilla_dom_workers_workerprivate_h__ */
