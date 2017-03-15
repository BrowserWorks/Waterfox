/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "WorkerScope.h"

#include "jsapi.h"
#include "mozilla/EventListenerManager.h"
#include "mozilla/dom/BindingDeclarations.h"
#include "mozilla/dom/Console.h"
#include "mozilla/dom/DedicatedWorkerGlobalScopeBinding.h"
#include "mozilla/dom/Fetch.h"
#include "mozilla/dom/FunctionBinding.h"
#include "mozilla/dom/IDBFactory.h"
#include "mozilla/dom/ImageBitmap.h"
#include "mozilla/dom/ImageBitmapBinding.h"
#include "mozilla/dom/Performance.h"
#include "mozilla/dom/Promise.h"
#include "mozilla/dom/PromiseWorkerProxy.h"
#include "mozilla/dom/ServiceWorkerGlobalScopeBinding.h"
#include "mozilla/dom/SharedWorkerGlobalScopeBinding.h"
#include "mozilla/dom/SimpleGlobalObject.h"
#include "mozilla/dom/WorkerDebuggerGlobalScopeBinding.h"
#include "mozilla/dom/WorkerGlobalScopeBinding.h"
#include "mozilla/dom/WorkerLocation.h"
#include "mozilla/dom/WorkerNavigator.h"
#include "mozilla/dom/cache/CacheStorage.h"
#include "mozilla/Services.h"
#include "nsServiceManagerUtils.h"

#include "nsIDocument.h"
#include "nsIServiceWorkerManager.h"
#include "nsIScriptTimeoutHandler.h"

#ifdef ANDROID
#include <android/log.h>
#endif

#include "Crypto.h"
#include "Principal.h"
#include "RuntimeService.h"
#include "ScriptLoader.h"
#include "WorkerPrivate.h"
#include "WorkerRunnable.h"
#include "ServiceWorkerClients.h"
#include "ServiceWorkerManager.h"
#include "ServiceWorkerRegistration.h"

#ifdef XP_WIN
#undef PostMessage
#endif

extern already_AddRefed<nsIScriptTimeoutHandler>
NS_CreateJSTimeoutHandler(JSContext* aCx,
                          mozilla::dom::workers::WorkerPrivate* aWorkerPrivate,
                          mozilla::dom::Function& aFunction,
                          const mozilla::dom::Sequence<JS::Value>& aArguments,
                          mozilla::ErrorResult& aError);

extern already_AddRefed<nsIScriptTimeoutHandler>
NS_CreateJSTimeoutHandler(JSContext* aCx,
                          mozilla::dom::workers::WorkerPrivate* aWorkerPrivate,
                          const nsAString& aExpression);

using namespace mozilla;
using namespace mozilla::dom;
USING_WORKERS_NAMESPACE

using mozilla::dom::cache::CacheStorage;
using mozilla::ipc::PrincipalInfo;

WorkerGlobalScope::WorkerGlobalScope(WorkerPrivate* aWorkerPrivate)
: mWindowInteractionsAllowed(0)
, mWorkerPrivate(aWorkerPrivate)
{
  mWorkerPrivate->AssertIsOnWorkerThread();
}

WorkerGlobalScope::~WorkerGlobalScope()
{
  mWorkerPrivate->AssertIsOnWorkerThread();
}

NS_IMPL_CYCLE_COLLECTION_CLASS(WorkerGlobalScope)

NS_IMPL_CYCLE_COLLECTION_TRAVERSE_BEGIN_INHERITED(WorkerGlobalScope,
                                                  DOMEventTargetHelper)
  tmp->mWorkerPrivate->AssertIsOnWorkerThread();
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mConsole)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mCrypto)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mPerformance)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mLocation)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mNavigator)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mIndexedDB)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mCacheStorage)
  tmp->TraverseHostObjectURIs(cb);
  tmp->mWorkerPrivate->TraverseTimeouts(cb);
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_END

NS_IMPL_CYCLE_COLLECTION_UNLINK_BEGIN_INHERITED(WorkerGlobalScope,
                                                DOMEventTargetHelper)
  tmp->mWorkerPrivate->AssertIsOnWorkerThread();
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mConsole)
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mCrypto)
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mPerformance)
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mLocation)
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mNavigator)
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mIndexedDB)
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mCacheStorage)
  tmp->UnlinkHostObjectURIs();
  tmp->mWorkerPrivate->UnlinkTimeouts();
NS_IMPL_CYCLE_COLLECTION_UNLINK_END

NS_IMPL_CYCLE_COLLECTION_TRACE_BEGIN_INHERITED(WorkerGlobalScope,
                                               DOMEventTargetHelper)
  tmp->mWorkerPrivate->AssertIsOnWorkerThread();
NS_IMPL_CYCLE_COLLECTION_TRACE_END

NS_IMPL_ADDREF_INHERITED(WorkerGlobalScope, DOMEventTargetHelper)
NS_IMPL_RELEASE_INHERITED(WorkerGlobalScope, DOMEventTargetHelper)

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(WorkerGlobalScope)
  NS_INTERFACE_MAP_ENTRY(nsIGlobalObject)
  NS_INTERFACE_MAP_ENTRY(nsISupportsWeakReference)
NS_INTERFACE_MAP_END_INHERITING(DOMEventTargetHelper)

JSObject*
WorkerGlobalScope::WrapObject(JSContext* aCx, JS::Handle<JSObject*> aGivenProto)
{
  MOZ_CRASH("We should never get here!");
}

Console*
WorkerGlobalScope::GetConsole(ErrorResult& aRv)
{
  mWorkerPrivate->AssertIsOnWorkerThread();

  if (!mConsole) {
    mConsole = Console::Create(nullptr, aRv);
    if (NS_WARN_IF(aRv.Failed())) {
      return nullptr;
    }
  }

  return mConsole;
}

Crypto*
WorkerGlobalScope::GetCrypto(ErrorResult& aError)
{
  mWorkerPrivate->AssertIsOnWorkerThread();

  if (!mCrypto) {
    mCrypto = new Crypto();
    mCrypto->Init(this);
  }

  return mCrypto;
}

already_AddRefed<CacheStorage>
WorkerGlobalScope::GetCaches(ErrorResult& aRv)
{
  if (!mCacheStorage) {
    MOZ_ASSERT(mWorkerPrivate);
    mCacheStorage = CacheStorage::CreateOnWorker(cache::DEFAULT_NAMESPACE, this,
                                                 mWorkerPrivate, aRv);
  }

  RefPtr<CacheStorage> ref = mCacheStorage;
  return ref.forget();
}

bool
WorkerGlobalScope::IsSecureContext() const
{
  bool globalSecure =
    JS_GetIsSecureContext(js::GetObjectCompartment(GetWrapperPreserveColor()));
  MOZ_ASSERT(globalSecure == mWorkerPrivate->IsSecureContext());
  return globalSecure;
}

already_AddRefed<WorkerLocation>
WorkerGlobalScope::Location()
{
  mWorkerPrivate->AssertIsOnWorkerThread();

  if (!mLocation) {
    WorkerPrivate::LocationInfo& info = mWorkerPrivate->GetLocationInfo();

    mLocation = WorkerLocation::Create(info);
    MOZ_ASSERT(mLocation);
  }

  RefPtr<WorkerLocation> location = mLocation;
  return location.forget();
}

already_AddRefed<WorkerNavigator>
WorkerGlobalScope::Navigator()
{
  mWorkerPrivate->AssertIsOnWorkerThread();

  if (!mNavigator) {
    mNavigator = WorkerNavigator::Create(mWorkerPrivate->OnLine());
    MOZ_ASSERT(mNavigator);
  }

  RefPtr<WorkerNavigator> navigator = mNavigator;
  return navigator.forget();
}

already_AddRefed<WorkerNavigator>
WorkerGlobalScope::GetExistingNavigator() const
{
  mWorkerPrivate->AssertIsOnWorkerThread();

  RefPtr<WorkerNavigator> navigator = mNavigator;
  return navigator.forget();
}

void
WorkerGlobalScope::Close(JSContext* aCx, ErrorResult& aRv)
{
  mWorkerPrivate->AssertIsOnWorkerThread();

  if (mWorkerPrivate->IsServiceWorker()) {
    aRv.Throw(NS_ERROR_DOM_INVALID_ACCESS_ERR);
  } else {
    mWorkerPrivate->CloseInternal(aCx);
  }
}

OnErrorEventHandlerNonNull*
WorkerGlobalScope::GetOnerror()
{
  mWorkerPrivate->AssertIsOnWorkerThread();

  EventListenerManager* elm = GetExistingListenerManager();
  return elm ? elm->GetOnErrorEventHandler() : nullptr;
}

void
WorkerGlobalScope::SetOnerror(OnErrorEventHandlerNonNull* aHandler)
{
  mWorkerPrivate->AssertIsOnWorkerThread();

  EventListenerManager* elm = GetOrCreateListenerManager();
  if (elm) {
    elm->SetEventHandler(aHandler);
  }
}

void
WorkerGlobalScope::ImportScripts(const Sequence<nsString>& aScriptURLs,
                                 ErrorResult& aRv)
{
  mWorkerPrivate->AssertIsOnWorkerThread();
  scriptloader::Load(mWorkerPrivate, aScriptURLs, WorkerScript, aRv);
}

int32_t
WorkerGlobalScope::SetTimeout(JSContext* aCx,
                              Function& aHandler,
                              const int32_t aTimeout,
                              const Sequence<JS::Value>& aArguments,
                              ErrorResult& aRv)
{
  mWorkerPrivate->AssertIsOnWorkerThread();

  nsCOMPtr<nsIScriptTimeoutHandler> handler =
    NS_CreateJSTimeoutHandler(aCx, mWorkerPrivate, aHandler, aArguments, aRv);
  if (NS_WARN_IF(aRv.Failed())) {
    return 0;
  }

  return mWorkerPrivate->SetTimeout(aCx, handler, aTimeout, false, aRv);
}

int32_t
WorkerGlobalScope::SetTimeout(JSContext* aCx,
                              const nsAString& aHandler,
                              const int32_t aTimeout,
                              const Sequence<JS::Value>& /* unused */,
                              ErrorResult& aRv)
{
  mWorkerPrivate->AssertIsOnWorkerThread();

  nsCOMPtr<nsIScriptTimeoutHandler> handler =
    NS_CreateJSTimeoutHandler(aCx, mWorkerPrivate, aHandler);
  return mWorkerPrivate->SetTimeout(aCx, handler, aTimeout, false, aRv);
}

void
WorkerGlobalScope::ClearTimeout(int32_t aHandle)
{
  mWorkerPrivate->AssertIsOnWorkerThread();
  mWorkerPrivate->ClearTimeout(aHandle);
}

int32_t
WorkerGlobalScope::SetInterval(JSContext* aCx,
                               Function& aHandler,
                               const Optional<int32_t>& aTimeout,
                               const Sequence<JS::Value>& aArguments,
                               ErrorResult& aRv)
{
  mWorkerPrivate->AssertIsOnWorkerThread();

  bool isInterval = aTimeout.WasPassed();
  int32_t timeout = aTimeout.WasPassed() ? aTimeout.Value() : 0;

  nsCOMPtr<nsIScriptTimeoutHandler> handler =
    NS_CreateJSTimeoutHandler(aCx, mWorkerPrivate, aHandler, aArguments, aRv);
  if (NS_WARN_IF(aRv.Failed())) {
    return 0;
  }

  return mWorkerPrivate->SetTimeout(aCx, handler,  timeout, isInterval, aRv);
}

int32_t
WorkerGlobalScope::SetInterval(JSContext* aCx,
                               const nsAString& aHandler,
                               const Optional<int32_t>& aTimeout,
                               const Sequence<JS::Value>& /* unused */,
                               ErrorResult& aRv)
{
  mWorkerPrivate->AssertIsOnWorkerThread();

  Sequence<JS::Value> dummy;

  bool isInterval = aTimeout.WasPassed();
  int32_t timeout = aTimeout.WasPassed() ? aTimeout.Value() : 0;

  nsCOMPtr<nsIScriptTimeoutHandler> handler =
    NS_CreateJSTimeoutHandler(aCx, mWorkerPrivate, aHandler);
  return mWorkerPrivate->SetTimeout(aCx, handler, timeout, isInterval, aRv);
}

void
WorkerGlobalScope::ClearInterval(int32_t aHandle)
{
  mWorkerPrivate->AssertIsOnWorkerThread();
  mWorkerPrivate->ClearTimeout(aHandle);
}

void
WorkerGlobalScope::Atob(const nsAString& aAtob, nsAString& aOutput, ErrorResult& aRv) const
{
  mWorkerPrivate->AssertIsOnWorkerThread();
  aRv = nsContentUtils::Atob(aAtob, aOutput);
}

void
WorkerGlobalScope::Btoa(const nsAString& aBtoa, nsAString& aOutput, ErrorResult& aRv) const
{
  mWorkerPrivate->AssertIsOnWorkerThread();
  aRv = nsContentUtils::Btoa(aBtoa, aOutput);
}

void
WorkerGlobalScope::Dump(const Optional<nsAString>& aString) const
{
  mWorkerPrivate->AssertIsOnWorkerThread();

  if (!aString.WasPassed()) {
    return;
  }

#if !(defined(DEBUG) || defined(MOZ_ENABLE_JS_DUMP))
  if (!mWorkerPrivate->DumpEnabled()) {
    return;
  }
#endif

  NS_ConvertUTF16toUTF8 str(aString.Value());

  MOZ_LOG(nsContentUtils::DOMDumpLog(), LogLevel::Debug, ("[Worker.Dump] %s", str.get()));
#ifdef ANDROID
  __android_log_print(ANDROID_LOG_INFO, "Gecko", "%s", str.get());
#endif
  fputs(str.get(), stdout);
  fflush(stdout);
}

Performance*
WorkerGlobalScope::GetPerformance()
{
  mWorkerPrivate->AssertIsOnWorkerThread();

  if (!mPerformance) {
    mPerformance = Performance::CreateForWorker(mWorkerPrivate);
  }

  return mPerformance;
}

already_AddRefed<Promise>
WorkerGlobalScope::Fetch(const RequestOrUSVString& aInput,
                         const RequestInit& aInit, ErrorResult& aRv)
{
  return FetchRequest(this, aInput, aInit, aRv);
}

already_AddRefed<IDBFactory>
WorkerGlobalScope::GetIndexedDB(ErrorResult& aErrorResult)
{
  mWorkerPrivate->AssertIsOnWorkerThread();

  RefPtr<IDBFactory> indexedDB = mIndexedDB;

  if (!indexedDB) {
    if (!mWorkerPrivate->IsStorageAllowed()) {
      NS_WARNING("IndexedDB is not allowed in this worker!");
      aErrorResult = NS_ERROR_DOM_SECURITY_ERR;
      return nullptr;
    }

    JSContext* cx = mWorkerPrivate->GetJSContext();
    MOZ_ASSERT(cx);

    JS::Rooted<JSObject*> owningObject(cx, GetGlobalJSObject());
    MOZ_ASSERT(owningObject);

    const PrincipalInfo& principalInfo = mWorkerPrivate->GetPrincipalInfo();

    nsresult rv =
      IDBFactory::CreateForWorker(cx,
                                  owningObject,
                                  principalInfo,
                                  mWorkerPrivate->WindowID(),
                                  getter_AddRefs(indexedDB));
    if (NS_WARN_IF(NS_FAILED(rv))) {
      aErrorResult = rv;
      return nullptr;
    }

    mIndexedDB = indexedDB;
  }

  return indexedDB.forget();
}

already_AddRefed<Promise>
WorkerGlobalScope::CreateImageBitmap(const ImageBitmapSource& aImage,
                                     ErrorResult& aRv)
{
  if (aImage.IsArrayBuffer() || aImage.IsArrayBufferView()) {
    aRv.Throw(NS_ERROR_NOT_IMPLEMENTED);
    return nullptr;
  }

  return ImageBitmap::Create(this, aImage, Nothing(), aRv);
}

already_AddRefed<Promise>
WorkerGlobalScope::CreateImageBitmap(const ImageBitmapSource& aImage,
                                     int32_t aSx, int32_t aSy, int32_t aSw, int32_t aSh,
                                     ErrorResult& aRv)
{
  if (aImage.IsArrayBuffer() || aImage.IsArrayBufferView()) {
    aRv.Throw(NS_ERROR_NOT_IMPLEMENTED);
    return nullptr;
  }

  return ImageBitmap::Create(this, aImage, Some(gfx::IntRect(aSx, aSy, aSw, aSh)), aRv);
}

already_AddRefed<mozilla::dom::Promise>
WorkerGlobalScope::CreateImageBitmap(const ImageBitmapSource& aImage,
                                     int32_t aOffset, int32_t aLength,
                                     ImageBitmapFormat aFormat,
                                     const Sequence<ChannelPixelLayout>& aLayout,
                                     ErrorResult& aRv)
{
  if (aImage.IsArrayBuffer() || aImage.IsArrayBufferView()) {
    return ImageBitmap::Create(this, aImage, aOffset, aLength, aFormat, aLayout,
                               aRv);
  } else {
    aRv.Throw(NS_ERROR_TYPE_ERR);
    return nullptr;
  }
}

DedicatedWorkerGlobalScope::DedicatedWorkerGlobalScope(WorkerPrivate* aWorkerPrivate)
: WorkerGlobalScope(aWorkerPrivate)
{
}

bool
DedicatedWorkerGlobalScope::WrapGlobalObject(JSContext* aCx,
                                             JS::MutableHandle<JSObject*> aReflector)
{
  mWorkerPrivate->AssertIsOnWorkerThread();
  MOZ_ASSERT(!mWorkerPrivate->IsSharedWorker());

  JS::CompartmentOptions options;
  mWorkerPrivate->CopyJSCompartmentOptions(options);

  const bool usesSystemPrincipal = mWorkerPrivate->UsesSystemPrincipal();

  // Note that xpc::ShouldDiscardSystemSource() and
  // xpc::ExtraWarningsForSystemJS() read prefs that are cached on the main
  // thread. This is benignly racey.
  const bool discardSource = usesSystemPrincipal &&
                             xpc::ShouldDiscardSystemSource();
  const bool extraWarnings = usesSystemPrincipal &&
                             xpc::ExtraWarningsForSystemJS();

  JS::CompartmentBehaviors& behaviors = options.behaviors();
  behaviors.setDiscardSource(discardSource)
           .extraWarningsOverride().set(extraWarnings);

  const bool sharedMemoryEnabled = xpc::SharedMemoryEnabled();

  JS::CompartmentCreationOptions& creationOptions = options.creationOptions();
  creationOptions.setSharedMemoryAndAtomicsEnabled(sharedMemoryEnabled);

  return DedicatedWorkerGlobalScopeBinding::Wrap(aCx, this, this,
                                                 options,
                                                 GetWorkerPrincipal(),
                                                 true, aReflector);
}

void
DedicatedWorkerGlobalScope::PostMessage(JSContext* aCx,
                                        JS::Handle<JS::Value> aMessage,
                                        const Optional<Sequence<JS::Value>>& aTransferable,
                                        ErrorResult& aRv)
{
  mWorkerPrivate->AssertIsOnWorkerThread();
  mWorkerPrivate->PostMessageToParent(aCx, aMessage, aTransferable, aRv);
}

SharedWorkerGlobalScope::SharedWorkerGlobalScope(WorkerPrivate* aWorkerPrivate,
                                                 const nsCString& aName)
: WorkerGlobalScope(aWorkerPrivate), mName(aName)
{
}

bool
SharedWorkerGlobalScope::WrapGlobalObject(JSContext* aCx,
                                          JS::MutableHandle<JSObject*> aReflector)
{
  mWorkerPrivate->AssertIsOnWorkerThread();
  MOZ_ASSERT(mWorkerPrivate->IsSharedWorker());

  JS::CompartmentOptions options;
  mWorkerPrivate->CopyJSCompartmentOptions(options);

  return SharedWorkerGlobalScopeBinding::Wrap(aCx, this, this, options,
                                              GetWorkerPrincipal(),
                                              true, aReflector);
}

NS_IMPL_CYCLE_COLLECTION_INHERITED(ServiceWorkerGlobalScope, WorkerGlobalScope,
                                   mClients, mRegistration)
NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION_INHERITED(ServiceWorkerGlobalScope)
NS_INTERFACE_MAP_END_INHERITING(WorkerGlobalScope)

NS_IMPL_ADDREF_INHERITED(ServiceWorkerGlobalScope, WorkerGlobalScope)
NS_IMPL_RELEASE_INHERITED(ServiceWorkerGlobalScope, WorkerGlobalScope)

ServiceWorkerGlobalScope::ServiceWorkerGlobalScope(WorkerPrivate* aWorkerPrivate,
                                                   const nsACString& aScope)
  : WorkerGlobalScope(aWorkerPrivate),
    mScope(NS_ConvertUTF8toUTF16(aScope))
{
}

ServiceWorkerGlobalScope::~ServiceWorkerGlobalScope()
{
}

bool
ServiceWorkerGlobalScope::WrapGlobalObject(JSContext* aCx,
                                           JS::MutableHandle<JSObject*> aReflector)
{
  mWorkerPrivate->AssertIsOnWorkerThread();
  MOZ_ASSERT(mWorkerPrivate->IsServiceWorker());

  JS::CompartmentOptions options;
  mWorkerPrivate->CopyJSCompartmentOptions(options);

  return ServiceWorkerGlobalScopeBinding::Wrap(aCx, this, this, options,
                                               GetWorkerPrincipal(),
                                               true, aReflector);
}

ServiceWorkerClients*
ServiceWorkerGlobalScope::Clients()
{
  if (!mClients) {
    mClients = new ServiceWorkerClients(this);
  }

  return mClients;
}

ServiceWorkerRegistration*
ServiceWorkerGlobalScope::Registration()
{
  if (!mRegistration) {
    mRegistration =
      ServiceWorkerRegistration::CreateForWorker(mWorkerPrivate, mScope);
  }

  return mRegistration;
}

namespace {

class SkipWaitingResultRunnable final : public WorkerRunnable
{
  RefPtr<PromiseWorkerProxy> mPromiseProxy;

public:
  SkipWaitingResultRunnable(WorkerPrivate* aWorkerPrivate,
                            PromiseWorkerProxy* aPromiseProxy)
    : WorkerRunnable(aWorkerPrivate)
    , mPromiseProxy(aPromiseProxy)
  {
    AssertIsOnMainThread();
  }

  virtual bool
  WorkerRun(JSContext* aCx, WorkerPrivate* aWorkerPrivate) override
  {
    MOZ_ASSERT(aWorkerPrivate);
    aWorkerPrivate->AssertIsOnWorkerThread();

    RefPtr<Promise> promise = mPromiseProxy->WorkerPromise();
    promise->MaybeResolveWithUndefined();

    // Release the reference on the worker thread.
    mPromiseProxy->CleanUp();

    return true;
  }
};

class WorkerScopeSkipWaitingRunnable final : public Runnable
{
  RefPtr<PromiseWorkerProxy> mPromiseProxy;
  nsCString mScope;

public:
  WorkerScopeSkipWaitingRunnable(PromiseWorkerProxy* aPromiseProxy,
                                 const nsCString& aScope)
    : mPromiseProxy(aPromiseProxy)
    , mScope(aScope)
  {
    MOZ_ASSERT(aPromiseProxy);
  }

  NS_IMETHOD
  Run() override
  {
    AssertIsOnMainThread();

    MutexAutoLock lock(mPromiseProxy->Lock());
    if (mPromiseProxy->CleanedUp()) {
      return NS_OK;
    }

    WorkerPrivate* workerPrivate = mPromiseProxy->GetWorkerPrivate();
    MOZ_DIAGNOSTIC_ASSERT(workerPrivate);

    RefPtr<ServiceWorkerManager> swm = ServiceWorkerManager::GetInstance();
    if (swm) {
      swm->SetSkipWaitingFlag(workerPrivate->GetPrincipal(), mScope,
                              workerPrivate->ServiceWorkerID());
    }

    RefPtr<SkipWaitingResultRunnable> runnable =
      new SkipWaitingResultRunnable(workerPrivate, mPromiseProxy);

    if (!runnable->Dispatch()) {
      NS_WARNING("Failed to dispatch SkipWaitingResultRunnable to the worker.");
    }
    return NS_OK;
  }
};

} // namespace

already_AddRefed<Promise>
ServiceWorkerGlobalScope::SkipWaiting(ErrorResult& aRv)
{
  mWorkerPrivate->AssertIsOnWorkerThread();
  MOZ_ASSERT(mWorkerPrivate->IsServiceWorker());

  RefPtr<Promise> promise = Promise::Create(this, aRv);
  if (NS_WARN_IF(aRv.Failed())) {
    return nullptr;
  }

  RefPtr<PromiseWorkerProxy> promiseProxy =
    PromiseWorkerProxy::Create(mWorkerPrivate, promise);
  if (!promiseProxy) {
    promise->MaybeResolveWithUndefined();
    return promise.forget();
  }

  RefPtr<WorkerScopeSkipWaitingRunnable> runnable =
    new WorkerScopeSkipWaitingRunnable(promiseProxy,
                                       NS_ConvertUTF16toUTF8(mScope));

  MOZ_ALWAYS_SUCCEEDS(mWorkerPrivate->DispatchToMainThread(runnable.forget()));
  return promise.forget();
}

bool
ServiceWorkerGlobalScope::OpenWindowEnabled(JSContext* aCx, JSObject* aObj)
{
  WorkerPrivate* worker = GetCurrentThreadWorkerPrivate();
  MOZ_ASSERT(worker);
  worker->AssertIsOnWorkerThread();
  return worker->OpenWindowEnabled();
}

WorkerDebuggerGlobalScope::WorkerDebuggerGlobalScope(
                                                  WorkerPrivate* aWorkerPrivate)
: mWorkerPrivate(aWorkerPrivate)
{
  mWorkerPrivate->AssertIsOnWorkerThread();
}

WorkerDebuggerGlobalScope::~WorkerDebuggerGlobalScope()
{
  mWorkerPrivate->AssertIsOnWorkerThread();
}

NS_IMPL_CYCLE_COLLECTION_CLASS(WorkerDebuggerGlobalScope)

NS_IMPL_CYCLE_COLLECTION_TRAVERSE_BEGIN_INHERITED(WorkerDebuggerGlobalScope,
                                                  DOMEventTargetHelper)
  tmp->mWorkerPrivate->AssertIsOnWorkerThread();
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mConsole)
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_END

NS_IMPL_CYCLE_COLLECTION_UNLINK_BEGIN_INHERITED(WorkerDebuggerGlobalScope,
                                                DOMEventTargetHelper)
  tmp->mWorkerPrivate->AssertIsOnWorkerThread();
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mConsole)
NS_IMPL_CYCLE_COLLECTION_UNLINK_END

NS_IMPL_CYCLE_COLLECTION_TRACE_BEGIN_INHERITED(WorkerDebuggerGlobalScope,
                                               DOMEventTargetHelper)
  tmp->mWorkerPrivate->AssertIsOnWorkerThread();
NS_IMPL_CYCLE_COLLECTION_TRACE_END

NS_IMPL_ADDREF_INHERITED(WorkerDebuggerGlobalScope, DOMEventTargetHelper)
NS_IMPL_RELEASE_INHERITED(WorkerDebuggerGlobalScope, DOMEventTargetHelper)

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(WorkerDebuggerGlobalScope)
  NS_INTERFACE_MAP_ENTRY(nsIGlobalObject)
NS_INTERFACE_MAP_END_INHERITING(DOMEventTargetHelper)

bool
WorkerDebuggerGlobalScope::WrapGlobalObject(JSContext* aCx,
                                            JS::MutableHandle<JSObject*> aReflector)
{
  mWorkerPrivate->AssertIsOnWorkerThread();

  JS::CompartmentOptions options;
  mWorkerPrivate->CopyJSCompartmentOptions(options);

  return WorkerDebuggerGlobalScopeBinding::Wrap(aCx, this, this, options,
                                                GetWorkerPrincipal(), true,
                                                aReflector);
}

void
WorkerDebuggerGlobalScope::GetGlobal(JSContext* aCx,
                                     JS::MutableHandle<JSObject*> aGlobal,
                                     ErrorResult& aRv)
{
  WorkerGlobalScope* scope = mWorkerPrivate->GetOrCreateGlobalScope(aCx);
  if (!scope) {
    aRv.Throw(NS_ERROR_FAILURE);
  }

  aGlobal.set(scope->GetWrapper());
}

void
WorkerDebuggerGlobalScope::CreateSandbox(JSContext* aCx, const nsAString& aName,
                                         JS::Handle<JSObject*> aPrototype,
                                         JS::MutableHandle<JSObject*> aResult,
                                         ErrorResult& aRv)
{
  mWorkerPrivate->AssertIsOnWorkerThread();

  aResult.set(nullptr);

  JS::Rooted<JS::Value> protoVal(aCx);
  protoVal.setObjectOrNull(aPrototype);
  JS::Rooted<JSObject*> sandbox(aCx,
    SimpleGlobalObject::Create(SimpleGlobalObject::GlobalType::WorkerDebuggerSandbox,
                               protoVal));

  if (!sandbox) {
    aRv.Throw(NS_ERROR_OUT_OF_MEMORY);
    return;
  }

  if (!JS_WrapObject(aCx, &sandbox)) {
    aRv.NoteJSContextException(aCx);
    return;
  }

  aResult.set(sandbox);
}

void
WorkerDebuggerGlobalScope::LoadSubScript(JSContext* aCx,
                                         const nsAString& aURL,
                                         const Optional<JS::Handle<JSObject*>>& aSandbox,
                                         ErrorResult& aRv)
{
  mWorkerPrivate->AssertIsOnWorkerThread();

  Maybe<JSAutoCompartment> ac;
  if (aSandbox.WasPassed()) {
    JS::Rooted<JSObject*> sandbox(aCx, js::CheckedUnwrap(aSandbox.Value()));
    if (!IsDebuggerSandbox(sandbox)) {
      aRv.Throw(NS_ERROR_INVALID_ARG);
      return;
    }

    ac.emplace(aCx, sandbox);
  }

  nsTArray<nsString> urls;
  urls.AppendElement(aURL);
  scriptloader::Load(mWorkerPrivate, urls, DebuggerScript, aRv);
}

void
WorkerDebuggerGlobalScope::EnterEventLoop()
{
  mWorkerPrivate->EnterDebuggerEventLoop();
}

void
WorkerDebuggerGlobalScope::LeaveEventLoop()
{
  mWorkerPrivate->LeaveDebuggerEventLoop();
}

void
WorkerDebuggerGlobalScope::PostMessage(const nsAString& aMessage)
{
  mWorkerPrivate->PostMessageToDebugger(aMessage);
}

void
WorkerDebuggerGlobalScope::SetImmediate(Function& aHandler, ErrorResult& aRv)
{
  mWorkerPrivate->SetDebuggerImmediate(aHandler, aRv);
}

void
WorkerDebuggerGlobalScope::ReportError(JSContext* aCx,
                                       const nsAString& aMessage)
{
  JS::AutoFilename chars;
  uint32_t lineno = 0;
  JS::DescribeScriptedCaller(aCx, &chars, &lineno);
  nsString filename(NS_ConvertUTF8toUTF16(chars.get()));
  mWorkerPrivate->ReportErrorToDebugger(filename, lineno, aMessage);
}

void
WorkerDebuggerGlobalScope::RetrieveConsoleEvents(JSContext* aCx,
                                                 nsTArray<JS::Value>& aEvents,
                                                 ErrorResult& aRv)
{
  WorkerGlobalScope* scope = mWorkerPrivate->GetOrCreateGlobalScope(aCx);
  if (!scope) {
    aRv.Throw(NS_ERROR_FAILURE);
    return;
  }

  RefPtr<Console> console = scope->GetConsole(aRv);
  if (NS_WARN_IF(aRv.Failed())) {
    return;
  }

  console->RetrieveConsoleEvents(aCx, aEvents, aRv);
}

void
WorkerDebuggerGlobalScope::SetConsoleEventHandler(JSContext* aCx,
                                                  AnyCallback* aHandler,
                                                  ErrorResult& aRv)
{
  WorkerGlobalScope* scope = mWorkerPrivate->GetOrCreateGlobalScope(aCx);
  if (!scope) {
    aRv.Throw(NS_ERROR_FAILURE);
    return;
  }

  RefPtr<Console> console = scope->GetConsole(aRv);
  if (NS_WARN_IF(aRv.Failed())) {
    return;
  }

  console->SetConsoleEventHandler(aHandler);
}

Console*
WorkerDebuggerGlobalScope::GetConsole(ErrorResult& aRv)
{
  mWorkerPrivate->AssertIsOnWorkerThread();

  // Debugger console has its own console object.
  if (!mConsole) {
    mConsole = Console::Create(nullptr, aRv);
    if (NS_WARN_IF(aRv.Failed())) {
      return nullptr;
    }
  }

  return mConsole;
}

void
WorkerDebuggerGlobalScope::Dump(JSContext* aCx,
                                const Optional<nsAString>& aString) const
{
  WorkerGlobalScope* scope = mWorkerPrivate->GetOrCreateGlobalScope(aCx);
  if (scope) {
    scope->Dump(aString);
  }
}

BEGIN_WORKERS_NAMESPACE

bool
IsWorkerGlobal(JSObject* object)
{
  nsIGlobalObject* globalObject = nullptr;
  return NS_SUCCEEDED(UNWRAP_OBJECT(WorkerGlobalScope, object,
                                    globalObject)) && !!globalObject;
}

bool
IsDebuggerGlobal(JSObject* object)
{
  nsIGlobalObject* globalObject = nullptr;
  return NS_SUCCEEDED(UNWRAP_OBJECT(WorkerDebuggerGlobalScope, object,
                                    globalObject)) && !!globalObject;
}

bool
IsDebuggerSandbox(JSObject* object)
{
  return SimpleGlobalObject::SimpleGlobalType(object) ==
    SimpleGlobalObject::GlobalType::WorkerDebuggerSandbox;
}

bool
GetterOnlyJSNative(JSContext* aCx, unsigned aArgc, JS::Value* aVp)
{
  JS_ReportErrorNumberASCII(aCx, js::GetErrorMessage, nullptr, JSMSG_GETTER_ONLY);
  return false;
}

END_WORKERS_NAMESPACE
