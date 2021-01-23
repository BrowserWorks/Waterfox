/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

// HttpLog.h should generally be included first
#include "HttpLog.h"

#include "nsHttpAuthCache.h"

#include <algorithm>
#include <stdlib.h>

#include "mozilla/Attributes.h"
#include "nsString.h"
#include "nsCRT.h"
#include "nsIObserverService.h"
#include "mozilla/Services.h"
#include "mozilla/DebugOnly.h"
#include "nsNetUtil.h"

namespace mozilla {
namespace net {

static inline void GetAuthKey(const char* scheme, const char* host,
                              int32_t port, nsACString const& originSuffix,
                              nsCString& key) {
  key.Truncate();
  key.Append(originSuffix);
  key.Append(':');
  key.Append(scheme);
  key.AppendLiteral("://");
  key.Append(host);
  key.Append(':');
  key.AppendInt(port);
}

// return true if the two strings are equal or both empty.  an empty string
// is either null or zero length.
static bool StrEquivalent(const char16_t* a, const char16_t* b) {
  static const char16_t emptyStr[] = {0};

  if (!a) a = emptyStr;
  if (!b) b = emptyStr;

  return nsCRT::strcmp(a, b) == 0;
}

//-----------------------------------------------------------------------------
// nsHttpAuthCache <public>
//-----------------------------------------------------------------------------

nsHttpAuthCache::nsHttpAuthCache()
    : mDB(128), mObserver(new OriginClearObserver(this)) {
  LOG(("nsHttpAuthCache::nsHttpAuthCache %p", this));

  nsCOMPtr<nsIObserverService> obsSvc = services::GetObserverService();
  if (obsSvc) {
    obsSvc->AddObserver(mObserver, "clear-origin-attributes-data", false);
  }
}

nsHttpAuthCache::~nsHttpAuthCache() {
  LOG(("nsHttpAuthCache::~nsHttpAuthCache %p", this));

  ClearAll();
  nsCOMPtr<nsIObserverService> obsSvc = services::GetObserverService();
  if (obsSvc) {
    obsSvc->RemoveObserver(mObserver, "clear-origin-attributes-data");
    mObserver->mOwner = nullptr;
  }
}

nsresult nsHttpAuthCache::GetAuthEntryForPath(const char* scheme,
                                              const char* host, int32_t port,
                                              const char* path,
                                              nsACString const& originSuffix,
                                              nsHttpAuthEntry** entry) {
  LOG(("nsHttpAuthCache::GetAuthEntryForPath %p [path=%s]\n", this, path));

  nsAutoCString key;
  nsHttpAuthNode* node = LookupAuthNode(scheme, host, port, originSuffix, key);
  if (!node) return NS_ERROR_NOT_AVAILABLE;

  *entry = node->LookupEntryByPath(path);
  LOG(("  returning %p", *entry));
  return *entry ? NS_OK : NS_ERROR_NOT_AVAILABLE;
}

nsresult nsHttpAuthCache::GetAuthEntryForDomain(const char* scheme,
                                                const char* host, int32_t port,
                                                const char* realm,
                                                nsACString const& originSuffix,
                                                nsHttpAuthEntry** entry)

{
  LOG(("nsHttpAuthCache::GetAuthEntryForDomain %p [realm=%s]\n", this, realm));

  nsAutoCString key;
  nsHttpAuthNode* node = LookupAuthNode(scheme, host, port, originSuffix, key);
  if (!node) return NS_ERROR_NOT_AVAILABLE;

  *entry = node->LookupEntryByRealm(realm);
  LOG(("  returning %p", *entry));
  return *entry ? NS_OK : NS_ERROR_NOT_AVAILABLE;
}

nsresult nsHttpAuthCache::SetAuthEntry(const char* scheme, const char* host,
                                       int32_t port, const char* path,
                                       const char* realm, const char* creds,
                                       const char* challenge,
                                       nsACString const& originSuffix,
                                       const nsHttpAuthIdentity* ident,
                                       nsISupports* metadata) {
  nsresult rv;

  LOG(("nsHttpAuthCache::SetAuthEntry %p [realm=%s path=%s metadata=%p]\n",
       this, realm, path, metadata));

  nsAutoCString key;
  nsHttpAuthNode* node = LookupAuthNode(scheme, host, port, originSuffix, key);

  if (!node) {
    // create a new entry node and set the given entry
    node = new nsHttpAuthNode();
    LOG(("  new nsHttpAuthNode %p for key='%s'", node, key.get()));
    rv = node->SetAuthEntry(path, realm, creds, challenge, ident, metadata);
    if (NS_FAILED(rv))
      delete node;
    else
      mDB.Put(key, node);
    return rv;
  }

  return node->SetAuthEntry(path, realm, creds, challenge, ident, metadata);
}

void nsHttpAuthCache::ClearAuthEntry(const char* scheme, const char* host,
                                     int32_t port, const char* realm,
                                     nsACString const& originSuffix) {
  nsAutoCString key;
  GetAuthKey(scheme, host, port, originSuffix, key);
  LOG(("nsHttpAuthCache::ClearAuthEntry %p key='%s'\n", this, key.get()));
  mDB.Remove(key);
}

void nsHttpAuthCache::ClearAll() {
  LOG(("nsHttpAuthCache::ClearAll %p\n", this));
  mDB.Clear();
}

//-----------------------------------------------------------------------------
// nsHttpAuthCache <private>
//-----------------------------------------------------------------------------

nsHttpAuthNode* nsHttpAuthCache::LookupAuthNode(const char* scheme,
                                                const char* host, int32_t port,
                                                nsACString const& originSuffix,
                                                nsCString& key) {
  GetAuthKey(scheme, host, port, originSuffix, key);
  nsHttpAuthNode* result = mDB.Get(key);

  LOG(("nsHttpAuthCache::LookupAuthNode %p key='%s' found node=%p", this,
       key.get(), result));
  return result;
}

NS_IMPL_ISUPPORTS(nsHttpAuthCache::OriginClearObserver, nsIObserver)

NS_IMETHODIMP
nsHttpAuthCache::OriginClearObserver::Observe(nsISupports* subject,
                                              const char* topic,
                                              const char16_t* data_unicode) {
  NS_ENSURE_TRUE(mOwner, NS_ERROR_NOT_AVAILABLE);

  OriginAttributesPattern pattern;
  if (!pattern.Init(nsDependentString(data_unicode))) {
    NS_ERROR("Cannot parse origin attributes pattern");
    return NS_ERROR_FAILURE;
  }

  mOwner->ClearOriginData(pattern);
  return NS_OK;
}

void nsHttpAuthCache::ClearOriginData(OriginAttributesPattern const& pattern) {
  LOG(("nsHttpAuthCache::ClearOriginData %p", this));

  for (auto iter = mDB.Iter(); !iter.Done(); iter.Next()) {
    const nsACString& key = iter.Key();

    // Extract the origin attributes suffix from the key.
    int32_t colon = key.FindChar(':');
    MOZ_ASSERT(colon != kNotFound);
    nsDependentCSubstring oaSuffix = StringHead(key, colon);

    // Build the OriginAttributes object of it...
    OriginAttributes oa;
    DebugOnly<bool> rv = oa.PopulateFromSuffix(oaSuffix);
    MOZ_ASSERT(rv);

    // ...and match it against the given pattern.
    if (pattern.Matches(oa)) {
      iter.Remove();
    }
  }
}

//-----------------------------------------------------------------------------
// nsHttpAuthIdentity
//-----------------------------------------------------------------------------

nsresult nsHttpAuthIdentity::Set(const char16_t* domain, const char16_t* user,
                                 const char16_t* pass) {
  char16_t *newUser, *newPass, *newDomain;

  int domainLen = domain ? NS_strlen(domain) : 0;
  int userLen = user ? NS_strlen(user) : 0;
  int passLen = pass ? NS_strlen(pass) : 0;

  int len = userLen + 1 + passLen + 1 + domainLen + 1;
  newUser = (char16_t*)malloc(len * sizeof(char16_t));
  if (!newUser) return NS_ERROR_OUT_OF_MEMORY;

  if (user) memcpy(newUser, user, userLen * sizeof(char16_t));
  newUser[userLen] = 0;

  newPass = &newUser[userLen + 1];
  if (pass) memcpy(newPass, pass, passLen * sizeof(char16_t));
  newPass[passLen] = 0;

  newDomain = &newPass[passLen + 1];
  if (domain) memcpy(newDomain, domain, domainLen * sizeof(char16_t));
  newDomain[domainLen] = 0;

  // wait until the end to clear member vars in case input params
  // reference our members!
  if (mUser) free(mUser);
  mUser = newUser;
  mPass = newPass;
  mDomain = newDomain;
  return NS_OK;
}

void nsHttpAuthIdentity::Clear() {
  if (mUser) {
    free(mUser);
    mUser = nullptr;
    mPass = nullptr;
    mDomain = nullptr;
  }
}

bool nsHttpAuthIdentity::Equals(const nsHttpAuthIdentity& ident) const {
  // we could probably optimize this with a single loop, but why bother?
  return StrEquivalent(mUser, ident.mUser) &&
         StrEquivalent(mPass, ident.mPass) &&
         StrEquivalent(mDomain, ident.mDomain);
}

//-----------------------------------------------------------------------------
// nsHttpAuthEntry
//-----------------------------------------------------------------------------

nsHttpAuthEntry::~nsHttpAuthEntry() {
  if (mRealm) free(mRealm);

  while (mRoot) {
    nsHttpAuthPath* ap = mRoot;
    mRoot = mRoot->mNext;
    free(ap);
  }
}

nsresult nsHttpAuthEntry::AddPath(const char* aPath) {
  // null path matches empty path
  if (!aPath) aPath = "";

  nsHttpAuthPath* tempPtr = mRoot;
  while (tempPtr) {
    const char* curpath = tempPtr->mPath;
    if (strncmp(aPath, curpath, strlen(curpath)) == 0)
      return NS_OK;  // subpath already exists in the list

    tempPtr = tempPtr->mNext;
  }

  // Append the aPath
  nsHttpAuthPath* newAuthPath;
  int newpathLen = strlen(aPath);
  newAuthPath = (nsHttpAuthPath*)malloc(sizeof(nsHttpAuthPath) + newpathLen);
  if (!newAuthPath) return NS_ERROR_OUT_OF_MEMORY;

  memcpy(newAuthPath->mPath, aPath, newpathLen + 1);
  newAuthPath->mNext = nullptr;

  if (!mRoot)
    mRoot = newAuthPath;  // first entry
  else
    mTail->mNext = newAuthPath;  // Append newAuthPath

  // update the tail pointer.
  mTail = newAuthPath;
  return NS_OK;
}

nsresult nsHttpAuthEntry::Set(const char* path, const char* realm,
                              const char* creds, const char* chall,
                              const nsHttpAuthIdentity* ident,
                              nsISupports* metadata) {
  char *newRealm, *newCreds, *newChall;

  int realmLen = realm ? strlen(realm) : 0;
  int credsLen = creds ? strlen(creds) : 0;
  int challLen = chall ? strlen(chall) : 0;

  int len = realmLen + 1 + credsLen + 1 + challLen + 1;
  newRealm = (char*)malloc(len);
  if (!newRealm) return NS_ERROR_OUT_OF_MEMORY;

  if (realm) memcpy(newRealm, realm, realmLen);
  newRealm[realmLen] = 0;

  newCreds = &newRealm[realmLen + 1];
  if (creds) memcpy(newCreds, creds, credsLen);
  newCreds[credsLen] = 0;

  newChall = &newCreds[credsLen + 1];
  if (chall) memcpy(newChall, chall, challLen);
  newChall[challLen] = 0;

  nsresult rv = NS_OK;
  if (ident) {
    rv = mIdent.Set(*ident);
  } else if (mIdent.IsEmpty()) {
    // If we are not given an identity and our cached identity has not been
    // initialized yet (so is currently empty), initialize it now by
    // filling it with nulls.  We need to do that because consumers expect
    // that mIdent is initialized after this function returns.
    rv = mIdent.Set(nullptr, nullptr, nullptr);
  }
  if (NS_FAILED(rv)) {
    free(newRealm);
    return rv;
  }

  rv = AddPath(path);
  if (NS_FAILED(rv)) {
    free(newRealm);
    return rv;
  }

  // wait until the end to clear member vars in case input params
  // reference our members!
  if (mRealm) free(mRealm);

  mRealm = newRealm;
  mCreds = newCreds;
  mChallenge = newChall;
  mMetaData = metadata;

  return NS_OK;
}

//-----------------------------------------------------------------------------
// nsHttpAuthNode
//-----------------------------------------------------------------------------

nsHttpAuthNode::nsHttpAuthNode() {
  LOG(("Creating nsHttpAuthNode @%p\n", this));
}

nsHttpAuthNode::~nsHttpAuthNode() {
  LOG(("Destroying nsHttpAuthNode @%p\n", this));

  mList.Clear();
}

nsHttpAuthEntry* nsHttpAuthNode::LookupEntryByPath(const char* path) {
  // null path matches empty path
  if (!path) path = "";

  // look for an entry that either matches or contains this directory.
  // ie. we'll give out credentials if the given directory is a sub-
  // directory of an existing entry.
  for (uint32_t i = 0; i < mList.Length(); ++i) {
    const auto& entry = mList[i];
    nsHttpAuthPath* authPath = entry->RootPath();
    while (authPath) {
      const char* entryPath = authPath->mPath;
      // proxy auth entries have no path, so require exact match on
      // empty path string.
      if (entryPath[0] == '\0') {
        if (path[0] == '\0') {
          return entry.get();
        }
      } else if (strncmp(path, entryPath, strlen(entryPath)) == 0) {
        return entry.get();
      }

      authPath = authPath->mNext;
    }
  }
  return nullptr;
}

nsHttpAuthNode::EntryList::const_iterator nsHttpAuthNode::LookupEntryItrByRealm(
    const char* realm) const {
  // null realm matches empty realm
  if (!realm) realm = "";

  return std::find_if(mList.cbegin(), mList.cend(), [&realm](const auto& val) {
    return strcmp(realm, val->Realm()) == 0;
  });
}

nsHttpAuthEntry* nsHttpAuthNode::LookupEntryByRealm(const char* realm) {
  auto itr = LookupEntryItrByRealm(realm);
  if (itr != mList.cend()) {
    return itr->get();
  }

  return nullptr;
}

nsresult nsHttpAuthNode::SetAuthEntry(const char* path, const char* realm,
                                      const char* creds, const char* challenge,
                                      const nsHttpAuthIdentity* ident,
                                      nsISupports* metadata) {
  // look for an entry with a matching realm
  nsHttpAuthEntry* entry = LookupEntryByRealm(realm);
  if (!entry) {
    // We want the latest identity be at the begining of the list so that
    // the newest working credentials are sent first on new requests.
    // Changing a realm is sometimes used to "timeout" authrozization.
    mList.InsertElementAt(
        0, WrapUnique(new nsHttpAuthEntry(path, realm, creds, challenge, ident,
                                          metadata)));
  } else {
    // update the entry...
    nsresult rv = entry->Set(path, realm, creds, challenge, ident, metadata);
    NS_ENSURE_SUCCESS(rv, rv);
  }

  return NS_OK;
}

void nsHttpAuthNode::ClearAuthEntry(const char* realm) {
  auto idx = LookupEntryItrByRealm(realm);
  if (idx != mList.cend()) {
    mList.RemoveElementAt(idx);
  }
}

}  // namespace net
}  // namespace mozilla
