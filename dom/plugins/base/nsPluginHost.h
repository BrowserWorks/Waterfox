/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef nsPluginHost_h_
#define nsPluginHost_h_

#include "mozilla/LinkedList.h"
#include "mozilla/StaticPtr.h"

#include "nsIPluginHost.h"
#include "nsIObserver.h"
#include "nsCOMPtr.h"
#include "prlink.h"
#include "nsIPluginTag.h"
#include "nsPluginsDir.h"
#include "nsWeakReference.h"
#include "MainThreadUtils.h"
#include "nsTArray.h"
#include "nsINamed.h"
#include "nsTObserverArray.h"
#include "nsITimer.h"
#include "nsPluginTags.h"
#include "nsIEffectiveTLDService.h"
#include "nsIIDNService.h"
#include "nsCRT.h"
#include "mozilla/dom/PromiseNativeHandler.h"
#include "mozilla/plugins/PluginTypes.h"

#ifdef XP_WIN
#  include <minwindef.h>
#  include "nsIWindowsRegKey.h"
#endif

namespace mozilla {
namespace plugins {
class BlocklistPromiseHandler;
}  // namespace plugins
namespace dom {
class ContentParent;
}  // namespace dom
}  // namespace mozilla

class nsNPAPIPlugin;
class nsIFile;
class nsIChannel;
class nsPluginNativeWindow;
class nsObjectLoadingContent;
class nsPluginInstanceOwner;
class nsPluginUnloadRunnable;
class nsNPAPIPluginInstance;
class nsNPAPIPluginStreamListener;
class nsIPluginInstanceOwner;
class nsIInputStream;
class nsIStreamListener;
#ifndef npapi_h_
struct _NPP;
typedef _NPP* NPP;
#endif

class PluginFinder;

class nsPluginHost final : public nsIPluginHost,
                           public nsIObserver,
                           public nsITimerCallback,
                           public nsSupportsWeakReference,
                           public nsINamed {
  friend class nsPluginTag;
  friend class nsFakePluginTag;
  friend class PluginFinder;
  virtual ~nsPluginHost();

 public:
  nsPluginHost();

  static already_AddRefed<nsPluginHost> GetInst();

  NS_DECL_ISUPPORTS
  NS_DECL_NSIPLUGINHOST
  NS_DECL_NSIOBSERVER
  NS_DECL_NSITIMERCALLBACK
  NS_DECL_NSINAMED

  // Acts like a bitfield
  enum PluginFilter {
    eExcludeNone = nsIPluginHost::EXCLUDE_NONE,
    eExcludeDisabled = nsIPluginHost::EXCLUDE_DISABLED,
    eExcludeFake = nsIPluginHost::EXCLUDE_FAKE
  };
  // FIXME-jsplugins comment about fake
  bool HavePluginForType(const nsACString& aMimeType,
                         PluginFilter aFilter = eExcludeDisabled);

  // FIXME-jsplugins what if fake has different extensions
  bool HavePluginForExtension(const nsACString& aExtension,
                              /* out */ nsACString& aMimeType,
                              PluginFilter aFilter = eExcludeDisabled);

  void GetPlugins(nsTArray<nsCOMPtr<nsIInternalPluginTag>>& aPluginArray,
                  bool aIncludeDisabled = false);

  nsresult GetURL(nsISupports* pluginInst, const char* url, const char* target,
                  nsNPAPIPluginStreamListener* streamListener,
                  const char* altHost, const char* referrer,
                  bool forceJSEnabled);
  nsresult PostURL(nsISupports* pluginInst, const char* url,
                   uint32_t postDataLen, const char* postData,
                   const char* target,
                   nsNPAPIPluginStreamListener* streamListener,
                   const char* altHost, const char* referrer,
                   bool forceJSEnabled, uint32_t postHeadersLength,
                   const char* postHeaders);

  nsresult UserAgent(const char** retstring);
  nsresult ParsePostBufferToFixHeaders(const char* inPostData,
                                       uint32_t inPostDataLen,
                                       char** outPostData,
                                       uint32_t* outPostDataLen);
  nsresult NewPluginNativeWindow(nsPluginNativeWindow** aPluginNativeWindow);

  void AddIdleTimeTarget(nsIPluginInstanceOwner* objectFrame, bool isVisible);
  void RemoveIdleTimeTarget(nsIPluginInstanceOwner* objectFrame);

  nsresult GetPluginName(nsNPAPIPluginInstance* aPluginInstance,
                         const char** aPluginName);
  nsresult StopPluginInstance(nsNPAPIPluginInstance* aInstance);
  nsresult GetPluginTagForInstance(nsNPAPIPluginInstance* aPluginInstance,
                                   nsIPluginTag** aPluginTag);

  nsresult NewPluginURLStream(const nsString& aURL,
                              nsNPAPIPluginInstance* aInstance,
                              nsNPAPIPluginStreamListener* aListener,
                              nsIInputStream* aPostStream = nullptr,
                              const char* aHeadersData = nullptr,
                              uint32_t aHeadersDataLen = 0);

  nsresult GetURLWithHeaders(
      nsNPAPIPluginInstance* pluginInst, const char* url,
      const char* target = nullptr,
      nsNPAPIPluginStreamListener* streamListener = nullptr,
      const char* altHost = nullptr, const char* referrer = nullptr,
      bool forceJSEnabled = false, uint32_t getHeadersLength = 0,
      const char* getHeaders = nullptr);

  nsresult AddHeadersToChannel(const char* aHeadersData,
                               uint32_t aHeadersDataLen,
                               nsIChannel* aGenericChannel);

  // Helper that checks if a type is whitelisted in plugin.allowed_types.
  // Always returns true if plugin.allowed_types is not set
  static bool IsTypeWhitelisted(const char* aType);

  /**
   * Returns true if a plugin can be used to load the requested MIME type. Used
   * for short circuiting before sending things to plugin code.
   */
  static bool CanUsePluginForMIMEType(const nsACString& aMIMEType);

  // checks whether aType is a type we recognize for potential special handling
  enum SpecialType {
    eSpecialType_None,
    // Needed to whitelist for async init support
    eSpecialType_Test,
    // Informs some decisions about OOP and quirks
    eSpecialType_Flash,
    // Binds to the <applet> tag, has various special
    // rules around opening channels, codebase, ...
    eSpecialType_Java
  };
  static SpecialType GetSpecialType(const nsACString& aMIMEType);

  static nsresult PostPluginUnloadEvent(PRLibrary* aLibrary);

  void PluginCrashed(nsNPAPIPlugin* aPlugin, const nsAString& aPluginDumpID,
                     const nsACString& aAdditionalMinidumps);

  nsNPAPIPluginInstance* FindInstance(const char* mimetype);
  nsNPAPIPluginInstance* FindOldestStoppedInstance();
  uint32_t StoppedInstanceCount();

  nsTArray<RefPtr<nsNPAPIPluginInstance>>* InstanceArray();

  // Return the tag for |aLibrary| if found, nullptr if not.
  nsPluginTag* FindTagForLibrary(PRLibrary* aLibrary);

  // The last argument should be false if we already have an in-flight stream
  // and don't need to set up a new stream.
  nsresult InstantiatePluginInstance(const nsACString& aMimeType, nsIURI* aURL,
                                     nsObjectLoadingContent* aContent,
                                     nsPluginInstanceOwner** aOwner);

  // Does not accept nullptr and should never fail.
  nsPluginTag* TagForPlugin(nsNPAPIPlugin* aPlugin);

  nsPluginTag* PluginWithId(uint32_t aId);

  nsresult GetPlugin(const nsACString& aMimeType, nsNPAPIPlugin** aPlugin);
  nsresult GetPluginForContentProcess(uint32_t aPluginId,
                                      nsNPAPIPlugin** aPlugin);
  void NotifyContentModuleDestroyed(uint32_t aPluginId);

  nsresult NewPluginStreamListener(nsIURI* aURL,
                                   nsNPAPIPluginInstance* aInstance,
                                   nsIStreamListener** aStreamListener);

  void CreateWidget(nsPluginInstanceOwner* aOwner);

  nsresult EnumerateSiteData(const nsACString& domain,
                             const nsTArray<nsCString>& sites,
                             nsTArray<nsCString>& result, bool firstMatchOnly);

  nsresult UpdateCachedSerializablePluginList();
  nsresult SendPluginsToContent(mozilla::dom::ContentParent* parent);
  nsresult SetPluginsInContent(
      uint32_t aPluginEpoch, nsTArray<mozilla::plugins::PluginTag>& aPlugins,
      nsTArray<mozilla::plugins::FakePluginTag>& aFakePlugins);

  void UpdatePluginBlocklistState(nsPluginTag* aPluginTag,
                                  bool aShouldSoftblock = false);

 private:
  nsresult LoadPlugins();
  nsresult UnloadPlugins();

  nsresult SetUpPluginInstance(const nsACString& aMimeType, nsIURI* aURL,
                               nsPluginInstanceOwner* aOwner);

  friend class nsPluginUnloadRunnable;
  friend class mozilla::plugins::BlocklistPromiseHandler;

  void DestroyRunningInstances(nsPluginTag* aPluginTag);

  // Writes updated plugins settings to disk and unloads the plugin
  // if it is now disabled. Should only be called by the plugin tag in question
  void UpdatePluginInfo(nsPluginTag* aPluginTag);

  nsresult TrySetUpPluginInstance(const nsACString& aMimeType, nsIURI* aURL,
                                  nsPluginInstanceOwner* aOwner);

  // FIXME-jsplugins comment here about when things may be fake
  nsPluginTag* FindPreferredPlugin(const nsTArray<nsPluginTag*>& matches);

  // Find a plugin for the given type.  If aIncludeFake is true a fake plugin
  // will be preferred if one exists; otherwise a fake plugin will never be
  // returned.  If aCheckEnabled is false, disabled plugins can be returned.
  nsIInternalPluginTag* FindPluginForType(const nsACString& aMimeType,
                                          bool aIncludeFake,
                                          bool aCheckEnabled);

  // Find specifically a fake plugin for the given type.  If aCheckEnabled is
  // false, disabled plugins can be returned.
  nsFakePluginTag* FindFakePluginForType(const nsACString& aMimeType,
                                         bool aCheckEnabled);

  // Find specifically a fake plugin for the given extension.  If aCheckEnabled
  // is false, disabled plugins can be returned.  aMimeType will be filled in
  // with the MIME type the plugin is registered for.
  nsFakePluginTag* FindFakePluginForExtension(const nsACString& aExtension,
                                              /* out */ nsACString& aMimeType,
                                              bool aCheckEnabled);

  // Find specifically a native (NPAPI) plugin for the given type.  If
  // aCheckEnabled is false, disabled plugins can be returned.
  nsPluginTag* FindNativePluginForType(const nsACString& aMimeType,
                                       bool aCheckEnabled);

  // Find specifically a native (NPAPI) plugin for the given extension.  If
  // aCheckEnabled is false, disabled plugins can be returned.  aMimeType will
  // be filled in with the MIME type the plugin is registered for.
  nsPluginTag* FindNativePluginForExtension(const nsACString& aExtension,
                                            /* out */ nsACString& aMimeType,
                                            bool aCheckEnabled);

  nsresult FindStoppedPluginForURL(nsIURI* aURL,
                                   nsIPluginInstanceOwner* aOwner);

  nsresult BroadcastPluginsToContent();

  // FIXME revisit, no ns prefix
  // Registers or unregisters the given mime type with the category manager
  enum nsRegisterType {
    ePluginRegister,
    ePluginUnregister,
    // Checks if this type should still be registered first
    ePluginMaybeUnregister
  };
  void RegisterWithCategoryManager(const nsCString& aMimeType,
                                   nsRegisterType aType);

  void AddPluginTag(nsPluginTag* aPluginTag);

  nsresult EnsurePluginLoaded(nsPluginTag* aPluginTag);

  bool IsRunningPlugin(nsPluginTag* aPluginTag);

  // Checks to see if a tag object is in our list of live tags.
  bool IsLiveTag(nsIPluginTag* tag);

  // Checks our list of live tags for an equivalent tag.
  nsPluginTag* HaveSamePlugin(const nsPluginTag* aPluginTag);

  void OnPluginInstanceDestroyed(nsPluginTag* aPluginTag);

  // To be used by the chrome process whenever the set of plugins changes.
  void IncrementChromeEpoch();

  // To be used by the chrome process; returns the current epoch.
  uint32_t ChromeEpoch();

  // To be used by the content process to get/set the last observed epoch value
  // from the chrome process.
  uint32_t ChromeEpochForContent();
  void SetChromeEpochForContent(uint32_t aEpoch);

  void UpdateInMemoryPluginInfo(nsPluginTag* aPluginTag);

  void ClearNonRunningPlugins();
  nsresult ActuallyReloadPlugins();

  // Callback into the host from PluginFinder once it's done.
  void FindingFinished();

  RefPtr<nsPluginTag> mPlugins;

  nsTArray<RefPtr<nsFakePluginTag>> mFakePlugins;

  AutoTArray<mozilla::plugins::PluginTag, 1> mSerializablePlugins;
  nsTArray<mozilla::plugins::FakePluginTag> mSerializableFakePlugins;

  bool mPluginsLoaded;

  // set by pref plugin.override_internal_types
  bool mOverrideInternalTypes;

  // set by pref plugin.disable
  bool mPluginsDisabled;

  // set by pref plugin.load_flash_only
  bool mFlashOnly;

  // Only one plugin finding operation should be run at a time.
  RefPtr<PluginFinder> mPendingFinder;
  bool mDoReloadOnceFindingFinished;
  bool mAddedFinderShutdownBlocker;

  // Any instances in this array will have valid plugin objects via GetPlugin().
  // When removing an instance it might not die - be sure to null out it's
  // plugin.
  nsTArray<RefPtr<nsNPAPIPluginInstance>> mInstances;

  // An nsIFile for the pluginreg.dat file in the profile.
#ifdef XP_WIN
  // In order to reload plugins when they change, we watch the registry via
  // this object.
  nsCOMPtr<nsIWindowsRegKey> mRegKeyHKLM;
  nsCOMPtr<nsIWindowsRegKey> mRegKeyHKCU;
#endif

  nsCOMPtr<nsIEffectiveTLDService> mTLDService;
  nsCOMPtr<nsIIDNService> mIDNService;

  // Helpers for ClearSiteData and SiteHasData.
  nsresult NormalizeHostname(nsCString& host);

  nsWeakPtr mCurrentDocument;  // weak reference, we use it to id document only

  // This epoch increases each time we load the list of plugins from disk.
  // In the chrome process, this stores the actual epoch.
  // In the content process, this stores the last epoch value observed
  // when reading plugins from chrome.
  uint32_t mPluginEpoch;

  static nsIFile* sPluginTempDir;

  // We need to hold a global ptr to ourselves because we register for
  // two different CIDs for some reason...
  static mozilla::StaticRefPtr<nsPluginHost> sInst;
};

class PluginDestructionGuard
    : public mozilla::LinkedListElement<PluginDestructionGuard> {
 public:
  explicit PluginDestructionGuard(nsNPAPIPluginInstance* aInstance);
  explicit PluginDestructionGuard(NPP npp);

  ~PluginDestructionGuard();

  static bool DelayDestroy(nsNPAPIPluginInstance* aInstance);

 protected:
  void Init() {
    NS_ASSERTION(NS_IsMainThread(), "Should be on the main thread");

    mDelayedDestroy = false;

    sList.insertBack(this);
  }

  RefPtr<nsNPAPIPluginInstance> mInstance;
  bool mDelayedDestroy;

  static mozilla::LinkedList<PluginDestructionGuard> sList;
};

#endif  // nsPluginHost_h_
