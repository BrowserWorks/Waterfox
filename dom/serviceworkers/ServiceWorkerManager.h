/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_dom_workers_serviceworkermanager_h
#define mozilla_dom_workers_serviceworkermanager_h

#include "nsIServiceWorkerManager.h"
#include "nsCOMPtr.h"

#include "ServiceWorkerShutdownState.h"
#include "ipc/IPCMessageUtils.h"
#include "mozilla/Attributes.h"
#include "mozilla/AutoRestore.h"
#include "mozilla/ConsoleReportCollector.h"
#include "mozilla/HashTable.h"
#include "mozilla/LinkedList.h"
#include "mozilla/MozPromise.h"
#include "mozilla/Preferences.h"
#include "mozilla/TypedEnumBits.h"
#include "mozilla/UniquePtr.h"
#include "mozilla/WeakPtr.h"
#include "mozilla/dom/BindingUtils.h"
#include "mozilla/dom/ClientHandle.h"
#include "mozilla/dom/Promise.h"
#include "mozilla/dom/ServiceWorkerRegistrar.h"
#include "mozilla/dom/ServiceWorkerRegistrarTypes.h"
#include "mozilla/dom/ServiceWorkerRegistrationInfo.h"
#include "mozilla/dom/ServiceWorkerUtils.h"
#include "mozilla/ipc/BackgroundUtils.h"
#include "nsClassHashtable.h"
#include "nsDataHashtable.h"
#include "nsRefPtrHashtable.h"
#include "nsTArrayForwardDeclare.h"

class nsIConsoleReportCollector;

namespace mozilla {

class OriginAttributes;

namespace ipc {
class PrincipalInfo;
}  // namespace ipc

namespace dom {

class ContentParent;
class ServiceWorkerInfo;
class ServiceWorkerJobQueue;
class ServiceWorkerManagerChild;
class ServiceWorkerPrivate;
class ServiceWorkerRegistrar;
class ServiceWorkerShutdownBlocker;

class ServiceWorkerUpdateFinishCallback {
 protected:
  virtual ~ServiceWorkerUpdateFinishCallback() = default;

 public:
  NS_INLINE_DECL_REFCOUNTING(ServiceWorkerUpdateFinishCallback)

  virtual void UpdateSucceeded(ServiceWorkerRegistrationInfo* aInfo) = 0;

  virtual void UpdateFailed(ErrorResult& aStatus) = 0;
};

#define NS_SERVICEWORKERMANAGER_IMPL_IID             \
  { /* f4f8755a-69ca-46e8-a65d-775745535990 */       \
    0xf4f8755a, 0x69ca, 0x46e8, {                    \
      0xa6, 0x5d, 0x77, 0x57, 0x45, 0x53, 0x59, 0x90 \
    }                                                \
  }

/*
 * The ServiceWorkerManager is a per-process global that deals with the
 * installation, querying and event dispatch of ServiceWorkers for all the
 * origins in the process.
 *
 * NOTE: the following documentation is a WIP and only applies with
 * dom.serviceWorkers.parent_intercept=true:
 *
 * The ServiceWorkerManager (SWM) is a main-thread, parent-process singleton
 * that encapsulates the browser-global state of service workers. This state
 * includes, but is not limited to, all service worker registrations and all
 * controlled service worker clients. The SWM also provides methods to read and
 * mutate this state and to dispatch operations (e.g. DOM events such as a
 * FetchEvent) to service workers.
 *
 * Example usage:
 *
 * MOZ_ASSERT(NS_IsMainThread(), "SWM is main-thread only");
 *
 * RefPtr<ServiceWorkerManager> swm = ServiceWorkerManager::GetInstance();
 *
 * // Nullness must be checked by code that possibly executes during browser
 * // shutdown, which is when the SWM is destroyed.
 * if (swm) {
 *   // Do something with the SWM.
 * }
 */
class ServiceWorkerManager final : public nsIServiceWorkerManager,
                                   public nsIObserver {
  friend class GetRegistrationsRunnable;
  friend class GetRegistrationRunnable;
  friend class ServiceWorkerJob;
  friend class ServiceWorkerRegistrationInfo;
  friend class ServiceWorkerUnregisterJob;
  friend class ServiceWorkerUpdateJob;
  friend class UpdateTimerCallback;

 public:
  NS_DECL_ISUPPORTS
  NS_DECL_NSISERVICEWORKERMANAGER
  NS_DECL_NSIOBSERVER

  // Return true if the given principal and URI matches a registered service
  // worker which handles fetch event.
  // If there is a matched service worker but doesn't handle fetch events, this
  // method will try to set the matched service worker as the controller of the
  // passed in channel. Then also schedule a soft-update job for the service
  // worker.
  bool IsAvailable(nsIPrincipal* aPrincipal, nsIURI* aURI,
                   nsIChannel* aChannel);

  // Return true if the given content process could potentially be executing
  // service worker code with the given principal.  At the current time, this
  // just means that we have any registration for the origin, regardless of
  // scope.  This is a very weak guarantee but is the best we can do when push
  // notifications can currently spin up a service worker in content processes
  // without our involvement in the parent process.
  //
  // In the future when there is only a single ServiceWorkerManager in the
  // parent process that is entirely in control of spawning and running service
  // worker code, we will be able to authoritatively indicate whether there is
  // an activate service worker in the given content process.  At that time we
  // will rename this method HasActiveServiceWorkerInstance and provide
  // semantics that ensure this method returns true until the worker is known to
  // have shut down in order to allow the caller to induce a crash for security
  // reasons without having to worry about shutdown races with the worker.
  bool MayHaveActiveServiceWorkerInstance(ContentParent* aContent,
                                          nsIPrincipal* aPrincipal);

  void DispatchFetchEvent(nsIInterceptedChannel* aChannel, ErrorResult& aRv);

  void Update(nsIPrincipal* aPrincipal, const nsACString& aScope,
              nsCString aNewestWorkerScriptUrl,
              ServiceWorkerUpdateFinishCallback* aCallback);

  void UpdateInternal(nsIPrincipal* aPrincipal, const nsACString& aScope,
                      nsCString&& aNewestWorkerScriptUrl,
                      ServiceWorkerUpdateFinishCallback* aCallback);

  void SoftUpdate(const OriginAttributes& aOriginAttributes,
                  const nsACString& aScope);

  void SoftUpdateInternal(const OriginAttributes& aOriginAttributes,
                          const nsACString& aScope,
                          ServiceWorkerUpdateFinishCallback* aCallback);

  void PropagateSoftUpdate(const OriginAttributes& aOriginAttributes,
                           const nsAString& aScope);

  void PropagateRemove(const nsACString& aHost);

  void Remove(const nsACString& aHost);

  void PropagateRemoveAll();

  void RemoveAll();

  RefPtr<ServiceWorkerRegistrationPromise> Register(
      const ClientInfo& aClientInfo, const nsACString& aScopeURL,
      const nsACString& aScriptURL,
      ServiceWorkerUpdateViaCache aUpdateViaCache);

  RefPtr<ServiceWorkerRegistrationPromise> GetRegistration(
      const ClientInfo& aClientInfo, const nsACString& aURL) const;

  RefPtr<ServiceWorkerRegistrationListPromise> GetRegistrations(
      const ClientInfo& aClientInfo) const;

  already_AddRefed<ServiceWorkerRegistrationInfo> GetRegistration(
      nsIPrincipal* aPrincipal, const nsACString& aScope) const;

  already_AddRefed<ServiceWorkerRegistrationInfo> GetRegistration(
      const mozilla::ipc::PrincipalInfo& aPrincipal,
      const nsACString& aScope) const;

  already_AddRefed<ServiceWorkerRegistrationInfo> CreateNewRegistration(
      const nsCString& aScope, nsIPrincipal* aPrincipal,
      ServiceWorkerUpdateViaCache aUpdateViaCache);

  void RemoveRegistration(ServiceWorkerRegistrationInfo* aRegistration);

  void StoreRegistration(nsIPrincipal* aPrincipal,
                         ServiceWorkerRegistrationInfo* aRegistration);

  void FinishFetch(ServiceWorkerRegistrationInfo* aRegistration);

  /**
   * Report an error for the given scope to any window we think might be
   * interested, failing over to the Browser Console if we couldn't find any.
   *
   * Error messages should be localized, so you probably want to call
   * LocalizeAndReportToAllClients instead, which in turn calls us after
   * localizing the error.
   */
  void ReportToAllClients(const nsCString& aScope, const nsString& aMessage,
                          const nsString& aFilename, const nsString& aLine,
                          uint32_t aLineNumber, uint32_t aColumnNumber,
                          uint32_t aFlags);

  /**
   * Report a localized error for the given scope to any window we think might
   * be interested.
   *
   * Note that this method takes an nsTArray<nsString> for the parameters, not
   * bare chart16_t*[].  You can use a std::initializer_list constructor inline
   * so that argument might look like: nsTArray<nsString> { some_nsString,
   * PromiseFlatString(some_nsSubString_aka_nsAString),
   * NS_ConvertUTF8toUTF16(some_nsCString_or_nsCSubString),
   * NS_LITERAL_STRING("some literal") }.  If you have anything else, like a
   * number, you can use an nsAutoString with AppendInt/friends.
   *
   * @param [aFlags]
   *   The nsIScriptError flag, one of errorFlag (0x0), warningFlag (0x1),
   *   infoFlag (0x8).  We default to error if omitted because usually we're
   *   logging exceptional and/or obvious breakage.
   */
  static void LocalizeAndReportToAllClients(
      const nsCString& aScope, const char* aStringKey,
      const nsTArray<nsString>& aParamArray, uint32_t aFlags = 0x0,
      const nsString& aFilename = EmptyString(),
      const nsString& aLine = EmptyString(), uint32_t aLineNumber = 0,
      uint32_t aColumnNumber = 0);

  // Always consumes the error by reporting to consoles of all controlled
  // documents.
  void HandleError(JSContext* aCx, nsIPrincipal* aPrincipal,
                   const nsCString& aScope, const nsString& aWorkerURL,
                   const nsString& aMessage, const nsString& aFilename,
                   const nsString& aLine, uint32_t aLineNumber,
                   uint32_t aColumnNumber, uint32_t aFlags, JSExnType aExnType);

  [[nodiscard]] RefPtr<GenericErrorResultPromise> MaybeClaimClient(
      const ClientInfo& aClientInfo,
      ServiceWorkerRegistrationInfo* aWorkerRegistration);

  [[nodiscard]] RefPtr<GenericErrorResultPromise> MaybeClaimClient(
      const ClientInfo& aClientInfo,
      const ServiceWorkerDescriptor& aServiceWorker);

  void SetSkipWaitingFlag(nsIPrincipal* aPrincipal, const nsCString& aScope,
                          uint64_t aServiceWorkerID);

  static already_AddRefed<ServiceWorkerManager> GetInstance();

  void LoadRegistration(const ServiceWorkerRegistrationData& aRegistration);

  void LoadRegistrations(
      const nsTArray<ServiceWorkerRegistrationData>& aRegistrations);

  void MaybeCheckNavigationUpdate(const ClientInfo& aClientInfo);

  nsresult SendPushEvent(const nsACString& aOriginAttributes,
                         const nsACString& aScope, const nsAString& aMessageId,
                         const Maybe<nsTArray<uint8_t>>& aData);

  nsresult NotifyUnregister(nsIPrincipal* aPrincipal, const nsAString& aScope);

  void WorkerIsIdle(ServiceWorkerInfo* aWorker);

  RefPtr<ServiceWorkerRegistrationPromise> WhenReady(
      const ClientInfo& aClientInfo);

  void CheckPendingReadyPromises();

  void RemovePendingReadyPromise(const ClientInfo& aClientInfo);

  void NoteInheritedController(const ClientInfo& aClientInfo,
                               const ServiceWorkerDescriptor& aController);

  void BlockShutdownOn(GenericNonExclusivePromise* aPromise,
                       uint32_t aShutdownStateId);

  nsresult GetClientRegistration(
      const ClientInfo& aClientInfo,
      ServiceWorkerRegistrationInfo** aRegistrationInfo);

  // Returns the shutdown state ID (may be an invalid ID if an
  // nsIAsyncShutdownBlocker is not used).
  uint32_t MaybeInitServiceWorkerShutdownProgress() const;

  void ReportServiceWorkerShutdownProgress(
      uint32_t aShutdownStateId,
      ServiceWorkerShutdownState::Progress aProgress) const;

 private:
  struct RegistrationDataPerPrincipal;

  static bool FindScopeForPath(const nsACString& aScopeKey,
                               const nsACString& aPath,
                               RegistrationDataPerPrincipal** aData,
                               nsACString& aMatch);

  ServiceWorkerManager();
  ~ServiceWorkerManager();

  void Init(ServiceWorkerRegistrar* aRegistrar);

  RefPtr<GenericErrorResultPromise> StartControllingClient(
      const ClientInfo& aClientInfo,
      ServiceWorkerRegistrationInfo* aRegistrationInfo,
      bool aControlClientHandle = true);

  void StopControllingClient(const ClientInfo& aClientInfo);

  void MaybeStartShutdown();

  void MaybeFinishShutdown();

  already_AddRefed<ServiceWorkerJobQueue> GetOrCreateJobQueue(
      const nsACString& aOriginSuffix, const nsACString& aScope);

  void MaybeRemoveRegistrationInfo(const nsACString& aScopeKey);

  already_AddRefed<ServiceWorkerRegistrationInfo> GetRegistration(
      const nsACString& aScopeKey, const nsACString& aScope) const;

  void AbortCurrentUpdate(ServiceWorkerRegistrationInfo* aRegistration);

  nsresult Update(ServiceWorkerRegistrationInfo* aRegistration);

  ServiceWorkerInfo* GetActiveWorkerInfoForScope(
      const OriginAttributes& aOriginAttributes, const nsACString& aScope);

  void StopControllingRegistration(
      ServiceWorkerRegistrationInfo* aRegistration);

  already_AddRefed<ServiceWorkerRegistrationInfo>
  GetServiceWorkerRegistrationInfo(const ClientInfo& aClientInfo) const;

  already_AddRefed<ServiceWorkerRegistrationInfo>
  GetServiceWorkerRegistrationInfo(nsIPrincipal* aPrincipal,
                                   nsIURI* aURI) const;

  already_AddRefed<ServiceWorkerRegistrationInfo>
  GetServiceWorkerRegistrationInfo(const nsACString& aScopeKey,
                                   nsIURI* aURI) const;

  // This method generates a key using isInElementBrowser from the principal. We
  // don't use the origin because it can change during the loading.
  static nsresult PrincipalToScopeKey(nsIPrincipal* aPrincipal,
                                      nsACString& aKey);

  static nsresult PrincipalInfoToScopeKey(
      const mozilla::ipc::PrincipalInfo& aPrincipalInfo, nsACString& aKey);

  static void AddScopeAndRegistration(
      const nsACString& aScope, ServiceWorkerRegistrationInfo* aRegistation);

  static bool HasScope(nsIPrincipal* aPrincipal, const nsACString& aScope);

  static void RemoveScopeAndRegistration(
      ServiceWorkerRegistrationInfo* aRegistration);

  void QueueFireEventOnServiceWorkerRegistrations(
      ServiceWorkerRegistrationInfo* aRegistration, const nsAString& aName);

  void UpdateClientControllers(ServiceWorkerRegistrationInfo* aRegistration);

  void MaybeRemoveRegistration(ServiceWorkerRegistrationInfo* aRegistration);

  // Removes all service worker registrations that matches the given pattern.
  void RemoveAllRegistrations(OriginAttributesPattern* aPattern);

  RefPtr<ServiceWorkerManagerChild> mActor;

  bool mShuttingDown;

  nsTArray<nsCOMPtr<nsIServiceWorkerManagerListener>> mListeners;

  void NotifyListenersOnRegister(
      nsIServiceWorkerRegistrationInfo* aRegistration);

  void NotifyListenersOnUnregister(
      nsIServiceWorkerRegistrationInfo* aRegistration);

  void ScheduleUpdateTimer(nsIPrincipal* aPrincipal, const nsACString& aScope);

  void UpdateTimerFired(nsIPrincipal* aPrincipal, const nsACString& aScope);

  void MaybeSendUnregister(nsIPrincipal* aPrincipal, const nsACString& aScope);

  nsresult SendNotificationEvent(const nsAString& aEventName,
                                 const nsACString& aOriginSuffix,
                                 const nsACString& aScope, const nsAString& aID,
                                 const nsAString& aTitle, const nsAString& aDir,
                                 const nsAString& aLang, const nsAString& aBody,
                                 const nsAString& aTag, const nsAString& aIcon,
                                 const nsAString& aData,
                                 const nsAString& aBehavior);

  // Used by remove() and removeAll() when clearing history.
  // MUST ONLY BE CALLED FROM UnregisterIfMatchesHost!
  void ForceUnregister(RegistrationDataPerPrincipal* aRegistrationData,
                       ServiceWorkerRegistrationInfo* aRegistration);

  // An "orphaned" registration is one that is unregistered and not controlling
  // clients. The ServiceWorkerManager must know about all orphaned
  // registrations to forcefully shutdown all Service Workers during browser
  // shutdown.
  void AddOrphanedRegistration(ServiceWorkerRegistrationInfo* aRegistration);

  void RemoveOrphanedRegistration(ServiceWorkerRegistrationInfo* aRegistration);

  HashSet<RefPtr<ServiceWorkerRegistrationInfo>,
          PointerHasher<ServiceWorkerRegistrationInfo*>>
      mOrphanedRegistrations;

  RefPtr<ServiceWorkerShutdownBlocker> mShutdownBlocker;

  nsClassHashtable<nsCStringHashKey, RegistrationDataPerPrincipal>
      mRegistrationInfos;

  struct ControlledClientData {
    RefPtr<ClientHandle> mClientHandle;
    RefPtr<ServiceWorkerRegistrationInfo> mRegistrationInfo;

    ControlledClientData(ClientHandle* aClientHandle,
                         ServiceWorkerRegistrationInfo* aRegistrationInfo)
        : mClientHandle(aClientHandle), mRegistrationInfo(aRegistrationInfo) {}
  };

  nsClassHashtable<nsIDHashKey, ControlledClientData> mControlledClients;

  struct PendingReadyData {
    RefPtr<ClientHandle> mClientHandle;
    RefPtr<ServiceWorkerRegistrationPromise::Private> mPromise;

    explicit PendingReadyData(ClientHandle* aClientHandle)
        : mClientHandle(aClientHandle),
          mPromise(new ServiceWorkerRegistrationPromise::Private(__func__)) {}
  };

  nsTArray<UniquePtr<PendingReadyData>> mPendingReadyList;
};

}  // namespace dom
}  // namespace mozilla

#endif  // mozilla_dom_workers_serviceworkermanager_h
