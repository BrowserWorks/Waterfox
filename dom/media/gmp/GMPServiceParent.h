/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef GMPServiceParent_h_
#define GMPServiceParent_h_

#include "GMPService.h"
#include "mozilla/gmp/PGMPServiceParent.h"
#include "mozIGeckoMediaPluginChromeService.h"
#include "nsClassHashtable.h"
#include "nsDataHashtable.h"
#include "mozilla/Atomics.h"
#include "nsIAsyncShutdown.h"
#include "nsThreadUtils.h"
#include "mozilla/MozPromise.h"
#include "GMPStorage.h"

template <class> struct already_AddRefed;

namespace mozilla {
namespace gmp {

class GMPParent;

class GeckoMediaPluginServiceParent final : public GeckoMediaPluginService
                                          , public mozIGeckoMediaPluginChromeService
                                          , public nsIAsyncShutdownBlocker
{
public:
  static already_AddRefed<GeckoMediaPluginServiceParent> GetSingleton();

  GeckoMediaPluginServiceParent();
  nsresult Init() override;

  NS_DECL_ISUPPORTS_INHERITED
  NS_DECL_NSIASYNCSHUTDOWNBLOCKER

  // mozIGeckoMediaPluginService
  NS_IMETHOD HasPluginForAPI(const nsACString& aAPI,
                             nsTArray<nsCString>* aTags,
                             bool *aRetVal) override;
  NS_IMETHOD GetNodeId(const nsAString& aOrigin,
                       const nsAString& aTopLevelOrigin,
                       const nsAString& aGMPName,
                       bool aInPrivateBrowsingMode,
                       UniquePtr<GetNodeIdCallback>&& aCallback) override;

  NS_DECL_MOZIGECKOMEDIAPLUGINCHROMESERVICE
  NS_DECL_NSIOBSERVER

  void AsyncShutdownNeeded(GMPParent* aParent);
  void AsyncShutdownComplete(GMPParent* aParent);

  int32_t AsyncShutdownTimeoutMs();
#ifdef MOZ_CRASHREPORTER
  void SetAsyncShutdownPluginState(GMPParent* aGMPParent, char aId, const nsCString& aState);
#endif // MOZ_CRASHREPORTER
  RefPtr<GenericPromise> EnsureInitialized();
  RefPtr<GenericPromise> AsyncAddPluginDirectory(const nsAString& aDirectory);

  // GMP thread access only
  bool IsShuttingDown();

  already_AddRefed<GMPStorage> GetMemoryStorageFor(const nsACString& aNodeId);
  nsresult ForgetThisSiteNative(const nsAString& aSite,
                                const mozilla::OriginAttributesPattern& aPattern);

  // Notifies that some user of this class is created/destroyed.
  void ServiceUserCreated();
  void ServiceUserDestroyed();

  void UpdateContentProcessGMPCapabilities();

private:
  friend class GMPServiceParent;

  virtual ~GeckoMediaPluginServiceParent();

  void ClearStorage();

  already_AddRefed<GMPParent> SelectPluginForAPI(const nsACString& aNodeId,
                                                 const nsCString& aAPI,
                                                 const nsTArray<nsCString>& aTags);

  already_AddRefed<GMPParent> FindPluginForAPIFrom(size_t aSearchStartIndex,
                                                   const nsCString& aAPI,
                                                   const nsTArray<nsCString>& aTags,
                                                   size_t* aOutPluginIndex);

  nsresult GetNodeId(const nsAString& aOrigin, const nsAString& aTopLevelOrigin,
                     const nsAString& aGMPName,
                     bool aInPrivateBrowsing, nsACString& aOutId);

  void UnloadPlugins();
  void CrashPlugins();
  void NotifySyncShutdownComplete();
  void NotifyAsyncShutdownComplete();

  void ProcessPossiblePlugin(nsIFile* aDir);

  void RemoveOnGMPThread(const nsAString& aDirectory,
                         const bool aDeleteFromDisk,
                         const bool aCanDefer);

  nsresult SetAsyncShutdownTimeout();

  struct DirectoryFilter {
    virtual bool operator()(nsIFile* aPath) = 0;
    ~DirectoryFilter() {}
  };
  void ClearNodeIdAndPlugin(DirectoryFilter& aFilter);
  void ClearNodeIdAndPlugin(nsIFile* aPluginStorageDir,
                            DirectoryFilter& aFilter);
  void ForgetThisSiteOnGMPThread(const nsACString& aOrigin,
                                 const mozilla::OriginAttributesPattern& aPattern);
  void ClearRecentHistoryOnGMPThread(PRTime aSince);

  already_AddRefed<GMPParent> GetById(uint32_t aPluginId);

protected:
  friend class GMPParent;
  void ReAddOnGMPThread(const RefPtr<GMPParent>& aOld);
  void PluginTerminated(const RefPtr<GMPParent>& aOld);
  void InitializePlugins(AbstractThread* aAbstractGMPThread) override;
  RefPtr<GenericPromise::AllPromiseType> LoadFromEnvironment();
  RefPtr<GenericPromise> AddOnGMPThread(nsString aDirectory);
  bool GetContentParentFrom(GMPCrashHelper* aHelper,
                            const nsACString& aNodeId,
                            const nsCString& aAPI,
                            const nsTArray<nsCString>& aTags,
                            UniquePtr<GetGMPContentParentCallback>&& aCallback)
    override;
private:
  // Creates a copy of aOriginal. Note that the caller is responsible for
  // adding this to GeckoMediaPluginServiceParent::mPlugins.
  already_AddRefed<GMPParent> ClonePlugin(const GMPParent* aOriginal);
  nsresult EnsurePluginsOnDiskScanned();
  nsresult InitStorage();

  class PathRunnable : public Runnable
  {
  public:
    enum EOperation {
      REMOVE,
      REMOVE_AND_DELETE_FROM_DISK,
    };

    PathRunnable(GeckoMediaPluginServiceParent* aService, const nsAString& aPath,
                 EOperation aOperation, bool aDefer = false)
      : mService(aService)
      , mPath(aPath)
      , mOperation(aOperation)
      , mDefer(aDefer)
    { }

    NS_DECL_NSIRUNNABLE

  private:
    RefPtr<GeckoMediaPluginServiceParent> mService;
    nsString mPath;
    EOperation mOperation;
    bool mDefer;
  };

  // Protected by mMutex from the base class.
  nsTArray<RefPtr<GMPParent>> mPlugins;
  bool mShuttingDown;
  nsTArray<RefPtr<GMPParent>> mAsyncShutdownPlugins;

#ifdef MOZ_CRASHREPORTER
  Mutex mAsyncShutdownPluginStatesMutex; // Protects mAsyncShutdownPluginStates.
  class AsyncShutdownPluginStates
  {
  public:
    void Update(const nsCString& aPlugin, const nsCString& aInstance,
                char aId, const nsCString& aState);
  private:
    struct State { nsCString mStateSequence; nsCString mLastStateDescription; };
    typedef nsClassHashtable<nsCStringHashKey, State> StatesByInstance;
    typedef nsClassHashtable<nsCStringHashKey, StatesByInstance> StateInstancesByPlugin;
    StateInstancesByPlugin mStates;
  } mAsyncShutdownPluginStates;
#endif // MOZ_CRASHREPORTER

  // True if we've inspected MOZ_GMP_PATH on the GMP thread and loaded any
  // plugins found there into mPlugins.
  Atomic<bool> mScannedPluginOnDisk;

  template<typename T>
  class MainThreadOnly {
  public:
    MOZ_IMPLICIT MainThreadOnly(T aValue)
      : mValue(aValue)
    {}
    operator T&() {
      MOZ_ASSERT(NS_IsMainThread());
      return mValue;
    }

  private:
    T mValue;
  };

  MainThreadOnly<bool> mWaitingForPluginsSyncShutdown;

  nsTArray<nsString> mPluginsWaitingForDeletion;

  nsCOMPtr<nsIFile> mStorageBaseDir;

  // Hashes of (origin,topLevelOrigin) to the node id for
  // non-persistent sessions.
  nsClassHashtable<nsUint32HashKey, nsCString> mTempNodeIds;

  // Hashes node id to whether that node id is allowed to store data
  // persistently on disk.
  nsDataHashtable<nsCStringHashKey, bool> mPersistentStorageAllowed;

  // Synchronization for barrier that ensures we've loaded GMPs from
  // MOZ_GMP_PATH before allowing GetContentParentFrom() to proceed.
  Monitor mInitPromiseMonitor;
  MozPromiseHolder<GenericPromise> mInitPromise;
  bool mLoadPluginsFromDiskComplete;

  // Hashes nodeId to the hashtable of storage for that nodeId.
  nsRefPtrHashtable<nsCStringHashKey, GMPStorage> mTempGMPStorage;

  // Tracks how many users are running (on the GMP thread). Only when this count
  // drops to 0 can we safely shut down the thread.
  MainThreadOnly<int32_t> mServiceUserCount;
};

nsresult ReadSalt(nsIFile* aPath, nsACString& aOutData);
bool MatchOrigin(nsIFile* aPath,
                 const nsACString& aSite,
                 const mozilla::OriginAttributesPattern& aPattern);

class GMPServiceParent final : public PGMPServiceParent
{
public:
  explicit GMPServiceParent(GeckoMediaPluginServiceParent* aService)
    : mService(aService)
  {
    mService->ServiceUserCreated();
  }
  virtual ~GMPServiceParent();

  bool RecvGetGMPNodeId(const nsString& aOrigin,
                        const nsString& aTopLevelOrigin,
                        const nsString& aGMPName,
                        const bool& aInPrivateBrowsing,
                        nsCString* aID) override;
  void ActorDestroy(ActorDestroyReason aWhy) override;

  static PGMPServiceParent* Create(Transport* aTransport, ProcessId aOtherPid);

  bool RecvSelectGMP(const nsCString& aNodeId,
                     const nsCString& aAPI,
                     nsTArray<nsCString>&& aTags,
                     uint32_t* aOutPluginId,
                     nsresult* aOutRv) override;

  bool RecvLaunchGMP(const uint32_t& aPluginId,
                     nsTArray<ProcessId>&& aAlreadyBridgedTo,
                     ProcessId* aOutID,
                     nsCString* aOutDisplayName,
                     nsresult* aOutRv) override;

private:
  void CloseTransport(Monitor* aSyncMonitor, bool* aCompleted);

  RefPtr<GeckoMediaPluginServiceParent> mService;
};

} // namespace gmp
} // namespace mozilla

#endif // GMPServiceParent_h_
