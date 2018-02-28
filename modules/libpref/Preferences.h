/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_Preferences_h
#define mozilla_Preferences_h

#ifndef MOZILLA_INTERNAL_API
#error "This header is only usable from within libxul (MOZILLA_INTERNAL_API)."
#endif

#include "nsIPrefService.h"
#include "nsIPrefBranch.h"
#include "nsIPrefBranchInternal.h"
#include "nsIObserver.h"
#include "nsCOMPtr.h"
#include "nsTArray.h"
#include "nsWeakReference.h"
#include "mozilla/Atomics.h"
#include "mozilla/MemoryReporting.h"

class nsIFile;

#ifndef have_PrefChangedFunc_typedef
typedef void (*PrefChangedFunc)(const char *, void *);
#define have_PrefChangedFunc_typedef
#endif

#ifdef DEBUG
enum pref_initPhase {
  START,
  BEGIN_INIT_PREFS,
  END_INIT_PREFS,
  BEGIN_ALL_PREFS,
  END_ALL_PREFS
};

#define SET_PREF_PHASE(p) Preferences::SetInitPhase(p)
#else
#define SET_PREF_PHASE(p) do { } while (0)
#endif

namespace mozilla {
struct Ok;
template <typename V, typename E> class Result;
namespace dom {
class PrefSetting;
} // namespace dom

class Preferences final : public nsIPrefService,
                          public nsIObserver,
                          public nsIPrefBranchInternal,
                          public nsSupportsWeakReference
{
public:
  typedef mozilla::dom::PrefSetting PrefSetting;

  NS_DECL_THREADSAFE_ISUPPORTS
  NS_DECL_NSIPREFSERVICE
  NS_FORWARD_NSIPREFBRANCH(sRootBranch->)
  NS_DECL_NSIOBSERVER

  Preferences();

  mozilla::Result<Ok, const char*> Init();

  /**
   * Returns true if the Preferences service is available, false otherwise.
   */
  static bool IsServiceAvailable();

  /**
   * Initialize user prefs from prefs.js/user.js
   */
  static void InitializeUserPrefs();

  /**
   * Returns the singleton instance which is addreffed.
   */
  static Preferences* GetInstanceForService();

  /**
   * Finallizes global members.
   */
  static void Shutdown();

  /**
   * Returns shared pref service instance
   * NOTE: not addreffed.
   */
  static nsIPrefService* GetService()
  {
    NS_ENSURE_TRUE(InitStaticMembers(), nullptr);
    return sPreferences;
  }

  /**
   * Returns shared pref branch instance.
   * NOTE: not addreffed.
   */
  static nsIPrefBranch* GetRootBranch()
  {
    NS_ENSURE_TRUE(InitStaticMembers(), nullptr);
    return sRootBranch;
  }

  /**
   * Returns shared default pref branch instance.
   * NOTE: not addreffed.
   */
  static nsIPrefBranch* GetDefaultRootBranch()
  {
    NS_ENSURE_TRUE(InitStaticMembers(), nullptr);
    return sDefaultRootBranch;
  }

  /**
   * Gets int or bool type pref value with default value if failed to get
   * the pref.
   */
  static bool GetBool(const char* aPref, bool aDefault = false)
  {
    bool result = aDefault;
    GetBool(aPref, &result);
    return result;
  }

  static int32_t GetInt(const char* aPref, int32_t aDefault = 0)
  {
    int32_t result = aDefault;
    GetInt(aPref, &result);
    return result;
  }

  static uint32_t GetUint(const char* aPref, uint32_t aDefault = 0)
  {
    uint32_t result = aDefault;
    GetUint(aPref, &result);
    return result;
  }

  static float GetFloat(const char* aPref, float aDefault = 0)
  {
    float result = aDefault;
    GetFloat(aPref, &result);
    return result;
  }

  /**
   * Gets int, float, or bool type pref value with raw return value of
   * nsIPrefBranch.
   *
   * @param aPref       A pref name.
   * @param aResult     Must not be nullptr.  The value is never modified
   *                    when these methods fail.
   */
  static nsresult GetBool(const char* aPref, bool* aResult);
  static nsresult GetInt(const char* aPref, int32_t* aResult);
  static nsresult GetFloat(const char* aPref, float* aResult);
  static nsresult GetUint(const char* aPref, uint32_t* aResult)
  {
    int32_t result;
    nsresult rv = GetInt(aPref, &result);
    if (NS_SUCCEEDED(rv)) {
      *aResult = static_cast<uint32_t>(result);
    }
    return rv;
  }

  /**
   * Gets string type pref value with raw return value of nsIPrefBranch.
   *
   * @param aPref       A pref name.
   * @param aResult     The value is never modified when these methods fail.
   */
  static nsresult GetCString(const char* aPref, nsACString& aResult);
  static nsresult GetString(const char* aPref, nsAString& aResult);
  static nsresult GetLocalizedCString(const char* aPref, nsACString& aResult);
  static nsresult GetLocalizedString(const char* aPref, nsAString& aResult);

  static nsresult GetComplex(const char* aPref, const nsIID &aType,
                             void** aResult);

  /**
   * Sets various type pref values.
   */
  static nsresult SetBool(const char* aPref, bool aValue);
  static nsresult SetInt(const char* aPref, int32_t aValue);
  static nsresult SetUint(const char* aPref, uint32_t aValue)
  {
    return SetInt(aPref, static_cast<int32_t>(aValue));
  }
  static nsresult SetFloat(const char* aPref, float aValue);
  static nsresult SetCString(const char* aPref, const char* aValue);
  static nsresult SetCString(const char* aPref, const nsACString &aValue);
  static nsresult SetString(const char* aPref, const char16ptr_t aValue);
  static nsresult SetString(const char* aPref, const nsAString &aValue);

  static nsresult SetComplex(const char* aPref, const nsIID &aType,
                             nsISupports* aValue);

  /**
   * Clears user set pref.
   */
  static nsresult ClearUser(const char* aPref);

  /**
   * Whether the pref has a user value or not.
   */
  static bool HasUserValue(const char* aPref);

  /**
   * Gets the type of the pref.
   */
  static int32_t GetType(const char* aPref);

  /**
   * Adds/Removes the observer for the root pref branch.
   * The observer is referenced strongly if AddStrongObserver is used.  On the
   * other hand, it is referenced weakly, if AddWeakObserver is used.
   * See nsIPrefBranch.idl for details.
   */
  static nsresult AddStrongObserver(nsIObserver* aObserver, const char* aPref);
  static nsresult AddWeakObserver(nsIObserver* aObserver, const char* aPref);
  static nsresult RemoveObserver(nsIObserver* aObserver, const char* aPref);

  /**
   * Adds/Removes two or more observers for the root pref branch.
   * Pass to aPrefs an array of const char* whose last item is nullptr.
   */
  static nsresult AddStrongObservers(nsIObserver* aObserver,
                                     const char** aPrefs);
  static nsresult AddWeakObservers(nsIObserver* aObserver,
                                   const char** aPrefs);
  static nsresult RemoveObservers(nsIObserver* aObserver,
                                  const char** aPrefs);

  /**
   * Registers/Unregisters the callback function for the aPref.
   */
  static nsresult RegisterCallback(PrefChangedFunc aCallback,
                                   const char* aPref,
                                   void* aClosure = nullptr)
  {
    return RegisterCallback(aCallback, aPref, aClosure, ExactMatch);
  }
  static nsresult UnregisterCallback(PrefChangedFunc aCallback,
                                     const char* aPref,
                                     void* aClosure = nullptr)
  {
    return UnregisterCallback(aCallback, aPref, aClosure, ExactMatch);
  }
  // Like RegisterCallback, but also calls the callback immediately for
  // initialization.
  static nsresult RegisterCallbackAndCall(PrefChangedFunc aCallback,
                                          const char* aPref,
                                          void* aClosure = nullptr)
  {
    return RegisterCallbackAndCall(aCallback, aPref, aClosure, ExactMatch);
  }

  /**
   * Like RegisterCallback, but registers a callback for a prefix of multiple
   * pref names, not a single pref name.
   */
  static nsresult RegisterPrefixCallback(PrefChangedFunc aCallback,
                                         const char* aPref,
                                         void* aClosure = nullptr)
  {
    return RegisterCallback(aCallback, aPref, aClosure, PrefixMatch);
  }

  /**
   * Like RegisterPrefixCallback, but also calls the callback immediately for
   * initialization.
   */
  static nsresult RegisterPrefixCallbackAndCall(PrefChangedFunc aCallback,
                                                const char* aPref,
                                                void* aClosure = nullptr)
  {
    return RegisterCallbackAndCall(aCallback, aPref, aClosure, PrefixMatch);
  }

  /**
   * Unregister a callback registered with RegisterPrefixCallback or
   * RegisterPrefixCallbackAndCall.
   */
  static nsresult UnregisterPrefixCallback(PrefChangedFunc aCallback,
                                           const char* aPref,
                                           void* aClosure = nullptr)
  {
    return UnregisterCallback(aCallback, aPref, aClosure, PrefixMatch);
  }

  /**
   * Adds the aVariable to cache table.  aVariable must be a pointer for a
   * static variable.  The value will be modified when the pref value is
   * changed but note that even if you modified it, the value isn't assigned to
   * the pref.
   */
  static nsresult AddBoolVarCache(bool* aVariable,
                                  const char* aPref,
                                  bool aDefault = false);
  static nsresult AddIntVarCache(int32_t* aVariable,
                                 const char* aPref,
                                 int32_t aDefault = 0);
  static nsresult AddUintVarCache(uint32_t* aVariable,
                                  const char* aPref,
                                  uint32_t aDefault = 0);
  template <MemoryOrdering Order>
  static nsresult AddAtomicUintVarCache(Atomic<uint32_t, Order>* aVariable,
                                        const char* aPref,
                                        uint32_t aDefault = 0);
  static nsresult AddFloatVarCache(float* aVariable,
                                   const char* aPref,
                                   float aDefault = 0.0f);

  /**
   * Gets the default bool, int or uint value of the pref.
   * The result is raw result of nsIPrefBranch::Get*Pref().
   * If the pref could have any value, you needed to use these methods.
   * If not so, you could use below methods.
   */
  static nsresult GetDefaultBool(const char* aPref, bool* aResult);
  static nsresult GetDefaultInt(const char* aPref, int32_t* aResult);
  static nsresult GetDefaultUint(const char* aPref, uint32_t* aResult)
  {
    return GetDefaultInt(aPref, reinterpret_cast<int32_t*>(aResult));
  }

  /**
   * Gets the default bool, int or uint value of the pref directly.
   * You can set an invalid value of the pref to aFailedResult.  If these
   * methods failed to get the default value, they would return the
   * aFailedResult value.
   */
  static bool GetDefaultBool(const char* aPref, bool aFailedResult)
  {
    bool result;
    return NS_SUCCEEDED(GetDefaultBool(aPref, &result)) ? result :
                                                          aFailedResult;
  }
  static int32_t GetDefaultInt(const char* aPref, int32_t aFailedResult)
  {
    int32_t result;
    return NS_SUCCEEDED(GetDefaultInt(aPref, &result)) ? result : aFailedResult;
  }
  static uint32_t GetDefaultUint(const char* aPref, uint32_t aFailedResult)
  {
   return static_cast<uint32_t>(
     GetDefaultInt(aPref, static_cast<int32_t>(aFailedResult)));
  }

  /**
   * Gets the default value of the char type pref.
   */
  static nsresult GetDefaultCString(const char* aPref, nsACString& aResult);
  static nsresult GetDefaultString(const char* aPref, nsAString& aResult);
  static nsresult GetDefaultLocalizedCString(const char* aPref,
                                             nsACString& aResult);
  static nsresult GetDefaultLocalizedString(const char* aPref,
                                            nsAString& aResult);

  static nsresult GetDefaultComplex(const char* aPref, const nsIID &aType,
                                    void** aResult);

  /**
   * Gets the type of the pref.
   */
  static int32_t GetDefaultType(const char* aPref);

  // Used to synchronise preferences between chrome and content processes.
  static void GetPreferences(InfallibleTArray<PrefSetting>* aPrefs);
  static void GetPreference(PrefSetting* aPref);
  static void SetPreference(const PrefSetting& aPref);

  static void SetInitPreferences(nsTArray<PrefSetting>* aPrefs);

#ifdef DEBUG
  static void SetInitPhase(pref_initPhase phase);
  static pref_initPhase InitPhase();
#endif

  static int64_t SizeOfIncludingThisAndOtherStuff(mozilla::MallocSizeOf aMallocSizeOf);

  static void DirtyCallback();

  // Explicitly choosing synchronous or asynchronous (if allowed)
  // preferences file write.  Only for the default file.  The guarantee
  // for the "blocking" is that when it returns, the file on disk
  // reflect the current state of preferences.
  nsresult SavePrefFileBlocking();
  nsresult SavePrefFileAsynchronous();

protected:
  virtual ~Preferences();

  nsresult NotifyServiceObservers(const char *aSubject);
  /**
   * Loads the prefs.js file from the profile, or creates a new one.
   *
   * @return the prefs file if successful, or nullptr on failure.
   */
  already_AddRefed<nsIFile> ReadSavedPrefs();

  /**
   * Loads the user.js file from the profile if present.
   */
  void ReadUserOverridePrefs();

  nsresult MakeBackupPrefFile(nsIFile *aFile);

  // Default pref file save can be blocking or not.
  enum class SaveMethod {
    Blocking,
    Asynchronous
  };

  // Off main thread is only respected for the default aFile value (nullptr)
  nsresult SavePrefFileInternal(nsIFile* aFile, SaveMethod aSaveMethod);
  nsresult WritePrefFile(nsIFile* aFile, SaveMethod aSaveMethod);

  // If this is false, only blocking writes, on main thread are allowed.
  bool AllowOffMainThreadSave();

  /**
   * Helpers for implementing
   * Register(Prefix)Callback/Unregister(Prefix)Callback.
   */
public:
  // Public so the ValueObserver classes can use it.
  enum MatchKind {
    PrefixMatch,
    ExactMatch,
  };

protected:
  static nsresult RegisterCallback(PrefChangedFunc aCallback,
                                   const char* aPref,
                                   void* aClosure,
                                   MatchKind aMatchKind);
  static nsresult UnregisterCallback(PrefChangedFunc aCallback,
                                     const char* aPref,
                                     void* aClosure,
                                     MatchKind aMatchKind);
  static nsresult RegisterCallbackAndCall(PrefChangedFunc aCallback,
                                          const char* aPref,
                                          void* aClosure,
                                          MatchKind aMatchKind);

private:
  nsCOMPtr<nsIFile>        mCurrentFile;
  bool                     mDirty = false;
  bool                     mProfileShutdown = false;
  // we wait a bit after prefs are dirty before writing them. In this
  // period, mDirty and mSavePending will both be true.
  bool                     mSavePending = false;

  static Preferences*      sPreferences;
  static nsIPrefBranch*    sRootBranch;
  static nsIPrefBranch*    sDefaultRootBranch;
  static bool              sShutdown;

  /**
   * Init static members.  TRUE if it succeeded.  Otherwise, FALSE.
   */
  static bool InitStaticMembers();
};

} // namespace mozilla

#endif // mozilla_Preferences_h
