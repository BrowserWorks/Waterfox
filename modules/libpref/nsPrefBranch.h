/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef nsPrefBranch_h
#define nsPrefBranch_h

#include "nsCOMPtr.h"
#include "nsIObserver.h"
#include "nsIPrefBranch.h"
#include "nsIPrefBranchInternal.h"
#include "nsIPrefLocalizedString.h"
#include "nsXPCOM.h"
#include "nsISupportsPrimitives.h"
#include "nsIRelativeFilePref.h"
#include "nsIFile.h"
#include "nsString.h"
#include "nsTArray.h"
#include "nsWeakReference.h"
#include "nsClassHashtable.h"
#include "nsCRT.h"
#include "nsISupportsImpl.h"
#include "mozilla/HashFunctions.h"
#include "mozilla/MemoryReporting.h"
#include "mozilla/Variant.h"

namespace mozilla {
class PreferenceServiceReporter;
} // namespace mozilla

class nsPrefBranch;

class PrefCallback : public PLDHashEntryHdr {
  friend class mozilla::PreferenceServiceReporter;

  public:
    typedef PrefCallback* KeyType;
    typedef const PrefCallback* KeyTypePointer;

    static const PrefCallback* KeyToPointer(PrefCallback *aKey)
    {
      return aKey;
    }

    static PLDHashNumber HashKey(const PrefCallback *aKey)
    {
      uint32_t hash = mozilla::HashString(aKey->mDomain);
      return mozilla::AddToHash(hash, aKey->mCanonical);
    }


  public:
    // Create a PrefCallback with a strong reference to its observer.
    PrefCallback(const char *aDomain, nsIObserver *aObserver,
                 nsPrefBranch *aBranch)
      : mDomain(aDomain),
        mBranch(aBranch),
        mWeakRef(nullptr),
        mStrongRef(aObserver)
    {
      MOZ_COUNT_CTOR(PrefCallback);
      nsCOMPtr<nsISupports> canonical = do_QueryInterface(aObserver);
      mCanonical = canonical;
    }

    // Create a PrefCallback with a weak reference to its observer.
    PrefCallback(const char *aDomain,
                 nsISupportsWeakReference *aObserver,
                 nsPrefBranch *aBranch)
      : mDomain(aDomain),
        mBranch(aBranch),
        mWeakRef(do_GetWeakReference(aObserver)),
        mStrongRef(nullptr)
    {
      MOZ_COUNT_CTOR(PrefCallback);
      nsCOMPtr<nsISupports> canonical = do_QueryInterface(aObserver);
      mCanonical = canonical;
    }

    // Copy constructor needs to be explicit or the linker complains.
    explicit PrefCallback(const PrefCallback *&aCopy)
      : mDomain(aCopy->mDomain),
        mBranch(aCopy->mBranch),
        mWeakRef(aCopy->mWeakRef),
        mStrongRef(aCopy->mStrongRef),
        mCanonical(aCopy->mCanonical)
    {
      MOZ_COUNT_CTOR(PrefCallback);
    }

    ~PrefCallback()
    {
      MOZ_COUNT_DTOR(PrefCallback);
    }

    bool KeyEquals(const PrefCallback *aKey) const
    {
      // We want to be able to look up a weakly-referencing PrefCallback after
      // its observer has died so we can remove it from the table.  Once the
      // callback's observer dies, its canonical pointer is stale -- in
      // particular, we may have allocated a new observer in the same spot in
      // memory!  So we can't just compare canonical pointers to determine
      // whether aKey refers to the same observer as this.
      //
      // Our workaround is based on the way we use this hashtable: When we ask
      // the hashtable to remove a PrefCallback whose weak reference has
      // expired, we use as the key for removal the same object as was inserted
      // into the hashtable.  Thus we can say that if one of the keys' weak
      // references has expired, the two keys are equal iff they're the same
      // object.

      if (IsExpired() || aKey->IsExpired())
        return this == aKey;

      if (mCanonical != aKey->mCanonical)
        return false;

      return mDomain.Equals(aKey->mDomain);
    }

    PrefCallback *GetKey() const
    {
      return const_cast<PrefCallback*>(this);
    }

    // Get a reference to the callback's observer, or null if the observer was
    // weakly referenced and has been destroyed.
    already_AddRefed<nsIObserver> GetObserver() const
    {
      if (!IsWeak()) {
        nsCOMPtr<nsIObserver> copy = mStrongRef;
        return copy.forget();
      }

      nsCOMPtr<nsIObserver> observer = do_QueryReferent(mWeakRef);
      return observer.forget();
    }

    const nsCString& GetDomain() const
    {
      return mDomain;
    }

    nsPrefBranch* GetPrefBranch() const
    {
      return mBranch;
    }

    // Has this callback's weak reference died?
    bool IsExpired() const
    {
      if (!IsWeak())
        return false;

      nsCOMPtr<nsIObserver> observer(do_QueryReferent(mWeakRef));
      return !observer;
    }

    enum { ALLOW_MEMMOVE = true };

  private:
    nsCString             mDomain;
    nsPrefBranch         *mBranch;

    // Exactly one of mWeakRef and mStrongRef should be non-null.
    nsWeakPtr             mWeakRef;
    nsCOMPtr<nsIObserver> mStrongRef;

    // We need a canonical nsISupports pointer, per bug 578392.
    nsISupports          *mCanonical;

    bool IsWeak() const
    {
      return !!mWeakRef;
    }
};

class nsPrefBranch final : public nsIPrefBranchInternal,
                           public nsIObserver,
                           public nsSupportsWeakReference
{
  friend class mozilla::PreferenceServiceReporter;
public:
  NS_DECL_ISUPPORTS
  NS_DECL_NSIPREFBRANCH
  NS_DECL_NSIPREFBRANCH2
  NS_DECL_NSIOBSERVER

  nsPrefBranch(const char *aPrefRoot, bool aDefaultBranch);
  nsPrefBranch() = delete;

  int32_t GetRootLength() const { return mPrefRoot.Length(); }

  nsresult RemoveObserverFromMap(const char *aDomain, nsISupports *aObserver);

  static void NotifyObserver(const char *newpref, void *data);

  size_t SizeOfIncludingThis(mozilla::MallocSizeOf aMallocSizeOf);

  static void ReportToConsole(const nsAString& aMessage);

protected:
  /**
   * Helper class for either returning a raw cstring or nsCString.
   */
  typedef mozilla::Variant<const char*, const nsCString> PrefNameBase;
  class PrefName : public PrefNameBase
  {
  public:
    explicit PrefName(const char* aName) : PrefNameBase(aName) {}
    explicit PrefName(const nsCString& aName) : PrefNameBase(aName) {}

    /**
     * Use default move constructors, disallow copy constructors.
     */
    PrefName(PrefName&& aOther) = default;
    PrefName& operator=(PrefName&& aOther) = default;
    PrefName(const PrefName&) = delete;
    PrefName& operator=(const PrefName&) = delete;

    struct PtrMatcher {
      static const char* match(const char* aVal) { return aVal; }
      static const char* match(const nsCString& aVal) { return aVal.get(); }
    };

    struct LenMatcher {
      static size_t match(const char* aVal) { return strlen(aVal); }
      static size_t match(const nsCString& aVal) { return aVal.Length(); }
    };

    const char* get() const {
      static PtrMatcher m;
      return match(m);
    }

    size_t Length() const {
      static LenMatcher m;
      return match(m);
    }
  };

  virtual ~nsPrefBranch();

  nsresult   GetDefaultFromPropertiesFile(const char *aPrefName, char16_t **return_buf);
  // As SetCharPref, but without any check on the length of |aValue|
  nsresult   SetCharPrefInternal(const char *aPrefName, const char *aValue);
  // Reject strings that are more than 1Mb, warn if strings are more than 16kb
  nsresult   CheckSanityOfStringLength(const char* aPrefName, const nsAString& aValue);
  nsresult   CheckSanityOfStringLength(const char* aPrefName, const nsACString& aValue);
  nsresult   CheckSanityOfStringLength(const char* aPrefName, const char* aValue);
  nsresult   CheckSanityOfStringLength(const char* aPrefName, const uint32_t aLength);
  void RemoveExpiredCallback(PrefCallback *aCallback);
  PrefName getPrefName(const char *aPrefName) const;
  void       freeObserverList(void);

private:
  const nsCString mPrefRoot;
  bool                  mIsDefault;

  bool                  mFreeingObserverList;
  nsClassHashtable<PrefCallback, PrefCallback> mObservers;
};


class nsPrefLocalizedString final : public nsIPrefLocalizedString,
                                    public nsISupportsString
{
public:
  nsPrefLocalizedString();

  NS_DECL_ISUPPORTS
  NS_FORWARD_NSISUPPORTSSTRING(mUnicodeString->)
  NS_FORWARD_NSISUPPORTSPRIMITIVE(mUnicodeString->)

  nsresult Init();

private:
  virtual ~nsPrefLocalizedString();

  NS_IMETHOD GetData(char16_t**) override;
  NS_IMETHOD SetData(const char16_t* aData) override;
  NS_IMETHOD SetDataWithLength(uint32_t aLength, const char16_t *aData) override;

  nsCOMPtr<nsISupportsString> mUnicodeString;
};


class nsRelativeFilePref : public nsIRelativeFilePref
{
public:
  NS_DECL_ISUPPORTS
  NS_DECL_NSIRELATIVEFILEPREF

  nsRelativeFilePref();

private:
  virtual ~nsRelativeFilePref();

  nsCOMPtr<nsIFile> mFile;
  nsCString mRelativeToKey;
};

#endif
