/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/Assertions.h"
#include "mozilla/LinkedList.h"

#include "nsCORSListenerProxy.h"
#include "nsIChannel.h"
#include "nsIHttpChannel.h"
#include "HttpChannelChild.h"
#include "nsIHttpChannelInternal.h"
#include "nsError.h"
#include "nsContentUtils.h"
#include "nsIScriptSecurityManager.h"
#include "nsNetUtil.h"
#include "nsIInterfaceRequestorUtils.h"
#include "nsServiceManagerUtils.h"
#include "nsMimeTypes.h"
#include "nsIStreamConverterService.h"
#include "nsStringStream.h"
#include "nsGkAtoms.h"
#include "nsWhitespaceTokenizer.h"
#include "nsIChannelEventSink.h"
#include "nsIAsyncVerifyRedirectCallback.h"
#include "nsCharSeparatedTokenizer.h"
#include "nsAsyncRedirectVerifyHelper.h"
#include "nsClassHashtable.h"
#include "nsHashKeys.h"
#include "nsStreamUtils.h"
#include "mozilla/Preferences.h"
#include "nsIScriptError.h"
#include "nsILoadGroup.h"
#include "nsILoadContext.h"
#include "nsIConsoleService.h"
#include "nsIDOMNode.h"
#include "nsIDOMWindowUtils.h"
#include "nsIDOMWindow.h"
#include "nsINetworkInterceptController.h"
#include "nsNullPrincipal.h"
#include "nsICorsPreflightCallback.h"
#include "nsISupportsImpl.h"
#include "mozilla/LoadInfo.h"
#include "nsIHttpHeaderVisitor.h"
#include <algorithm>

using namespace mozilla;

#define PREFLIGHT_CACHE_SIZE 100

static bool gDisableCORS = false;
static bool gDisableCORSPrivateData = false;

static void
LogBlockedRequest(nsIRequest* aRequest,
                  const char* aProperty,
                  const char16_t* aParam)
{
  nsresult rv = NS_OK;

  // Build the error object and log it to the console
  nsCOMPtr<nsIConsoleService> console(do_GetService(NS_CONSOLESERVICE_CONTRACTID, &rv));
  if (NS_FAILED(rv)) {
    NS_WARNING("Failed to log blocked cross-site request (no console)");
    return;
  }

  nsCOMPtr<nsIScriptError> scriptError =
    do_CreateInstance(NS_SCRIPTERROR_CONTRACTID, &rv);
  if (NS_FAILED(rv)) {
    NS_WARNING("Failed to log blocked cross-site request (no scriptError)");
    return;
  }

  nsCOMPtr<nsIChannel> channel = do_QueryInterface(aRequest);
  nsCOMPtr<nsIURI> aUri;
  channel->GetURI(getter_AddRefs(aUri));
  nsAutoCString spec;
  if (aUri) {
    spec = aUri->GetSpecOrDefault();
  }

  // Generate the error message
  nsXPIDLString blockedMessage;
  NS_ConvertUTF8toUTF16 specUTF16(spec);
  const char16_t* params[] = { specUTF16.get(), aParam };
  rv = nsContentUtils::FormatLocalizedString(nsContentUtils::eSECURITY_PROPERTIES,
                                             aProperty,
                                             params,
                                             blockedMessage);

  if (NS_FAILED(rv)) {
    NS_WARNING("Failed to log blocked cross-site request (no formalizedStr");
    return;
  }

  nsAutoString msg(blockedMessage.get());

  // query innerWindowID and log to web console, otherwise log to
  // the error to the browser console.
  uint64_t innerWindowID = nsContentUtils::GetInnerWindowID(aRequest);

  if (innerWindowID > 0) {
    rv = scriptError->InitWithWindowID(msg,
                                       EmptyString(), // sourceName
                                       EmptyString(), // sourceLine
                                       0,             // lineNumber
                                       0,             // columnNumber
                                       nsIScriptError::warningFlag,
                                       "CORS",
                                       innerWindowID);
  }
  else {
    rv = scriptError->Init(msg,
                           EmptyString(), // sourceName
                           EmptyString(), // sourceLine
                           0,             // lineNumber
                           0,             // columnNumber
                           nsIScriptError::warningFlag,
                           "CORS");
  }
  if (NS_FAILED(rv)) {
    NS_WARNING("Failed to log blocked cross-site request (scriptError init failed)");
    return;
  }
  console->LogMessage(scriptError);
}

//////////////////////////////////////////////////////////////////////////
// Preflight cache

class nsPreflightCache
{
public:
  struct TokenTime
  {
    nsCString token;
    TimeStamp expirationTime;
  };

  struct CacheEntry : public LinkedListElement<CacheEntry>
  {
    explicit CacheEntry(nsCString& aKey)
      : mKey(aKey)
    {
      MOZ_COUNT_CTOR(nsPreflightCache::CacheEntry);
    }

    ~CacheEntry()
    {
      MOZ_COUNT_DTOR(nsPreflightCache::CacheEntry);
    }

    void PurgeExpired(TimeStamp now);
    bool CheckRequest(const nsCString& aMethod,
                        const nsTArray<nsCString>& aCustomHeaders);

    nsCString mKey;
    nsTArray<TokenTime> mMethods;
    nsTArray<TokenTime> mHeaders;
  };

  nsPreflightCache()
  {
    MOZ_COUNT_CTOR(nsPreflightCache);
  }

  ~nsPreflightCache()
  {
    Clear();
    MOZ_COUNT_DTOR(nsPreflightCache);
  }

  bool Initialize()
  {
    return true;
  }

  CacheEntry* GetEntry(nsIURI* aURI, nsIPrincipal* aPrincipal,
                       bool aWithCredentials, bool aCreate);
  void RemoveEntries(nsIURI* aURI, nsIPrincipal* aPrincipal);

  void Clear();

private:
  static bool GetCacheKey(nsIURI* aURI, nsIPrincipal* aPrincipal,
                            bool aWithCredentials, nsACString& _retval);

  nsClassHashtable<nsCStringHashKey, CacheEntry> mTable;
  LinkedList<CacheEntry> mList;
};

// Will be initialized in EnsurePreflightCache.
static nsPreflightCache* sPreflightCache = nullptr;

static bool EnsurePreflightCache()
{
  if (sPreflightCache)
    return true;

  nsAutoPtr<nsPreflightCache> newCache(new nsPreflightCache());

  if (newCache->Initialize()) {
    sPreflightCache = newCache.forget();
    return true;
  }

  return false;
}

void
nsPreflightCache::CacheEntry::PurgeExpired(TimeStamp now)
{
  uint32_t i;
  for (i = 0; i < mMethods.Length(); ++i) {
    if (now >= mMethods[i].expirationTime) {
      mMethods.RemoveElementAt(i--);
    }
  }
  for (i = 0; i < mHeaders.Length(); ++i) {
    if (now >= mHeaders[i].expirationTime) {
      mHeaders.RemoveElementAt(i--);
    }
  }
}

bool
nsPreflightCache::CacheEntry::CheckRequest(const nsCString& aMethod,
                                           const nsTArray<nsCString>& aHeaders)
{
  PurgeExpired(TimeStamp::NowLoRes());

  if (!aMethod.EqualsLiteral("GET") && !aMethod.EqualsLiteral("POST")) {
    uint32_t i;
    for (i = 0; i < mMethods.Length(); ++i) {
      if (aMethod.Equals(mMethods[i].token))
        break;
    }
    if (i == mMethods.Length()) {
      return false;
    }
  }

  for (uint32_t i = 0; i < aHeaders.Length(); ++i) {
    uint32_t j;
    for (j = 0; j < mHeaders.Length(); ++j) {
      if (aHeaders[i].Equals(mHeaders[j].token,
                             nsCaseInsensitiveCStringComparator())) {
        break;
      }
    }
    if (j == mHeaders.Length()) {
      return false;
    }
  }

  return true;
}

nsPreflightCache::CacheEntry*
nsPreflightCache::GetEntry(nsIURI* aURI,
                           nsIPrincipal* aPrincipal,
                           bool aWithCredentials,
                           bool aCreate)
{
  nsCString key;
  if (!GetCacheKey(aURI, aPrincipal, aWithCredentials, key)) {
    NS_WARNING("Invalid cache key!");
    return nullptr;
  }

  CacheEntry* existingEntry = nullptr;

  if (mTable.Get(key, &existingEntry)) {
    // Entry already existed so just return it. Also update the LRU list.

    // Move to the head of the list.
    existingEntry->removeFrom(mList);
    mList.insertFront(existingEntry);

    return existingEntry;
  }

  if (!aCreate) {
    return nullptr;
  }

  // This is a new entry, allocate and insert into the table now so that any
  // failures don't cause items to be removed from a full cache.
  CacheEntry* newEntry = new CacheEntry(key);
  if (!newEntry) {
    NS_WARNING("Failed to allocate new cache entry!");
    return nullptr;
  }

  NS_ASSERTION(mTable.Count() <= PREFLIGHT_CACHE_SIZE,
               "Something is borked, too many entries in the cache!");

  // Now enforce the max count.
  if (mTable.Count() == PREFLIGHT_CACHE_SIZE) {
    // Try to kick out all the expired entries.
    TimeStamp now = TimeStamp::NowLoRes();
    for (auto iter = mTable.Iter(); !iter.Done(); iter.Next()) {
      nsAutoPtr<CacheEntry>& entry = iter.Data();
      entry->PurgeExpired(now);

      if (entry->mHeaders.IsEmpty() &&
          entry->mMethods.IsEmpty()) {
        // Expired, remove from the list as well as the hash table.
        entry->removeFrom(sPreflightCache->mList);
        iter.Remove();
      }
    }

    // If that didn't remove anything then kick out the least recently used
    // entry.
    if (mTable.Count() == PREFLIGHT_CACHE_SIZE) {
      CacheEntry* lruEntry = static_cast<CacheEntry*>(mList.popLast());
      MOZ_ASSERT(lruEntry);

      // This will delete 'lruEntry'.
      mTable.Remove(lruEntry->mKey);

      NS_ASSERTION(mTable.Count() == PREFLIGHT_CACHE_SIZE - 1,
                   "Somehow tried to remove an entry that was never added!");
    }
  }

  mTable.Put(key, newEntry);
  mList.insertFront(newEntry);

  return newEntry;
}

void
nsPreflightCache::RemoveEntries(nsIURI* aURI, nsIPrincipal* aPrincipal)
{
  CacheEntry* entry;
  nsCString key;
  if (GetCacheKey(aURI, aPrincipal, true, key) &&
      mTable.Get(key, &entry)) {
    entry->removeFrom(mList);
    mTable.Remove(key);
  }

  if (GetCacheKey(aURI, aPrincipal, false, key) &&
      mTable.Get(key, &entry)) {
    entry->removeFrom(mList);
    mTable.Remove(key);
  }
}

void
nsPreflightCache::Clear()
{
  mList.clear();
  mTable.Clear();
}

/* static */ bool
nsPreflightCache::GetCacheKey(nsIURI* aURI,
                              nsIPrincipal* aPrincipal,
                              bool aWithCredentials,
                              nsACString& _retval)
{
  NS_ASSERTION(aURI, "Null uri!");
  NS_ASSERTION(aPrincipal, "Null principal!");

  NS_NAMED_LITERAL_CSTRING(space, " ");

  nsCOMPtr<nsIURI> uri;
  nsresult rv = aPrincipal->GetURI(getter_AddRefs(uri));
  NS_ENSURE_SUCCESS(rv, false);

  nsAutoCString scheme, host, port;
  if (uri) {
    uri->GetScheme(scheme);
    uri->GetHost(host);
    port.AppendInt(NS_GetRealPort(uri));
  }

  if (aWithCredentials) {
    _retval.AssignLiteral("cred");
  }
  else {
    _retval.AssignLiteral("nocred");
  }

  nsAutoCString spec;
  rv = aURI->GetSpec(spec);
  NS_ENSURE_SUCCESS(rv, false);

  _retval.Append(space + scheme + space + host + space + port + space +
                 spec);

  return true;
}

//////////////////////////////////////////////////////////////////////////
// nsCORSListenerProxy

NS_IMPL_ISUPPORTS(nsCORSListenerProxy, nsIStreamListener,
                  nsIRequestObserver, nsIChannelEventSink,
                  nsIInterfaceRequestor, nsIThreadRetargetableStreamListener)

/* static */
void
nsCORSListenerProxy::Startup()
{
  Preferences::AddBoolVarCache(&gDisableCORS,
                               "content.cors.disable");
  Preferences::AddBoolVarCache(&gDisableCORSPrivateData,
                               "content.cors.no_private_data");
}

/* static */
void
nsCORSListenerProxy::Shutdown()
{
  delete sPreflightCache;
  sPreflightCache = nullptr;
}

nsCORSListenerProxy::nsCORSListenerProxy(nsIStreamListener* aOuter,
                                         nsIPrincipal* aRequestingPrincipal,
                                         bool aWithCredentials)
  : mOuterListener(aOuter),
    mRequestingPrincipal(aRequestingPrincipal),
    mOriginHeaderPrincipal(aRequestingPrincipal),
    mWithCredentials(aWithCredentials && !gDisableCORSPrivateData),
    mRequestApproved(false),
    mHasBeenCrossSite(false)
{
}

nsCORSListenerProxy::~nsCORSListenerProxy()
{
}

nsresult
nsCORSListenerProxy::Init(nsIChannel* aChannel, DataURIHandling aAllowDataURI)
{
  aChannel->GetNotificationCallbacks(getter_AddRefs(mOuterNotificationCallbacks));
  aChannel->SetNotificationCallbacks(this);

  nsresult rv = UpdateChannel(aChannel, aAllowDataURI, UpdateType::Default);
  if (NS_FAILED(rv)) {
    mOuterListener = nullptr;
    mRequestingPrincipal = nullptr;
    mOriginHeaderPrincipal = nullptr;
    mOuterNotificationCallbacks = nullptr;
  }
#ifdef DEBUG
  mInited = true;
#endif
  return rv;
}

NS_IMETHODIMP
nsCORSListenerProxy::OnStartRequest(nsIRequest* aRequest,
                                    nsISupports* aContext)
{
  MOZ_ASSERT(mInited, "nsCORSListenerProxy has not been initialized properly");
  nsresult rv = CheckRequestApproved(aRequest);
  mRequestApproved = NS_SUCCEEDED(rv);
  if (!mRequestApproved) {
    nsCOMPtr<nsIChannel> channel = do_QueryInterface(aRequest);
    if (channel) {
      nsCOMPtr<nsIURI> uri;
      NS_GetFinalChannelURI(channel, getter_AddRefs(uri));
      if (uri) {
        if (sPreflightCache) {
          // OK to use mRequestingPrincipal since preflights never get
          // redirected.
          sPreflightCache->RemoveEntries(uri, mRequestingPrincipal);
        } else {
          nsCOMPtr<nsIHttpChannelChild> httpChannelChild =
            do_QueryInterface(channel);
          if (httpChannelChild) {
            rv = httpChannelChild->RemoveCorsPreflightCacheEntry(uri, mRequestingPrincipal);
            if (NS_FAILED(rv)) {
              // Only warn here to ensure we fall through the request Cancel()
              // and outer listener OnStartRequest() calls.
              NS_WARNING("Failed to remove CORS preflight cache entry!");
            }
          }
        }
      }
    }

    aRequest->Cancel(NS_ERROR_DOM_BAD_URI);
    mOuterListener->OnStartRequest(aRequest, aContext);

    return NS_ERROR_DOM_BAD_URI;
  }

  return mOuterListener->OnStartRequest(aRequest, aContext);
}

namespace {
class CheckOriginHeader final : public nsIHttpHeaderVisitor {

public:
  NS_DECL_ISUPPORTS

  CheckOriginHeader()
   : mHeaderCount(0)
  {}

  NS_IMETHOD
  VisitHeader(const nsACString & aHeader, const nsACString & aValue) override
  {
    if (aHeader.EqualsLiteral("Access-Control-Allow-Origin")) {
      mHeaderCount++;
    }

    if (mHeaderCount > 1) {
      return NS_ERROR_DOM_BAD_URI;
    }
    return NS_OK;
  }

private:
  uint32_t mHeaderCount;

  ~CheckOriginHeader()
  {}

};

NS_IMPL_ISUPPORTS(CheckOriginHeader, nsIHttpHeaderVisitor)
}

nsresult
nsCORSListenerProxy::CheckRequestApproved(nsIRequest* aRequest)
{
  // Check if this was actually a cross domain request
  if (!mHasBeenCrossSite) {
    return NS_OK;
  }

  if (gDisableCORS) {
    LogBlockedRequest(aRequest, "CORSDisabled", nullptr);
    return NS_ERROR_DOM_BAD_URI;
  }

  // Check if the request failed
  nsresult status;
  nsresult rv = aRequest->GetStatus(&status);
  NS_ENSURE_SUCCESS(rv, rv);
  NS_ENSURE_SUCCESS(status, status);

  // Test that things worked on a HTTP level
  nsCOMPtr<nsIHttpChannel> http = do_QueryInterface(aRequest);
  if (!http) {
    LogBlockedRequest(aRequest, "CORSRequestNotHttp", nullptr);
    return NS_ERROR_DOM_BAD_URI;
  }

  nsCOMPtr<nsIHttpChannelInternal> internal = do_QueryInterface(aRequest);
  NS_ENSURE_STATE(internal);
  bool responseSynthesized = false;
  if (NS_SUCCEEDED(internal->GetResponseSynthesized(&responseSynthesized)) &&
      responseSynthesized) {
    // For synthesized responses, we don't need to perform any checks.
    // Note: This would be unsafe if we ever changed our behavior to allow
    // service workers to intercept CORS preflights.
    return NS_OK;
  }

  // Check the Access-Control-Allow-Origin header
  RefPtr<CheckOriginHeader> visitor = new CheckOriginHeader();
  nsAutoCString allowedOriginHeader;

  // check for duplicate headers
  rv = http->VisitOriginalResponseHeaders(visitor);
  if (NS_FAILED(rv)) {
    LogBlockedRequest(aRequest, "CORSAllowOriginNotMatchingOrigin", nullptr);
    return rv;
  }

  rv = http->GetResponseHeader(
    NS_LITERAL_CSTRING("Access-Control-Allow-Origin"), allowedOriginHeader);
  if (NS_FAILED(rv)) {
    LogBlockedRequest(aRequest, "CORSMissingAllowOrigin", nullptr);
    return rv;
  }

  // Bug 1210985 - Explicitly point out the error that the credential is
  // not supported if the allowing origin is '*'. Note that this check
  // has to be done before the condition
  //
  // >> if (mWithCredentials || !allowedOriginHeader.EqualsLiteral("*"))
  //
  // below since "if (A && B)" is included in "if (A || !B)".
  //
  if (mWithCredentials && allowedOriginHeader.EqualsLiteral("*")) {
    LogBlockedRequest(aRequest, "CORSNotSupportingCredentials", nullptr);
    return NS_ERROR_DOM_BAD_URI;
  }

  if (mWithCredentials || !allowedOriginHeader.EqualsLiteral("*")) {
    MOZ_ASSERT(!nsContentUtils::IsExpandedPrincipal(mOriginHeaderPrincipal));
    nsAutoCString origin;
    nsContentUtils::GetASCIIOrigin(mOriginHeaderPrincipal, origin);

    if (!allowedOriginHeader.Equals(origin)) {
      LogBlockedRequest(aRequest, "CORSAllowOriginNotMatchingOrigin",
                        NS_ConvertUTF8toUTF16(allowedOriginHeader).get());
      return NS_ERROR_DOM_BAD_URI;
    }
  }

  // Check Access-Control-Allow-Credentials header
  if (mWithCredentials) {
    nsAutoCString allowCredentialsHeader;
    rv = http->GetResponseHeader(
      NS_LITERAL_CSTRING("Access-Control-Allow-Credentials"), allowCredentialsHeader);

    if (!allowCredentialsHeader.EqualsLiteral("true")) {
      LogBlockedRequest(aRequest, "CORSMissingAllowCredentials", nullptr);
      return NS_ERROR_DOM_BAD_URI;
    }
  }

  return NS_OK;
}

NS_IMETHODIMP
nsCORSListenerProxy::OnStopRequest(nsIRequest* aRequest,
                                   nsISupports* aContext,
                                   nsresult aStatusCode)
{
  MOZ_ASSERT(mInited, "nsCORSListenerProxy has not been initialized properly");
  nsresult rv = mOuterListener->OnStopRequest(aRequest, aContext, aStatusCode);
  mOuterListener = nullptr;
  mOuterNotificationCallbacks = nullptr;
  return rv;
}

NS_IMETHODIMP
nsCORSListenerProxy::OnDataAvailable(nsIRequest* aRequest,
                                     nsISupports* aContext,
                                     nsIInputStream* aInputStream,
                                     uint64_t aOffset,
                                     uint32_t aCount)
{
  // NB: This can be called on any thread!  But we're guaranteed that it is
  // called between OnStartRequest and OnStopRequest, so we don't need to worry
  // about races.

  MOZ_ASSERT(mInited, "nsCORSListenerProxy has not been initialized properly");
  if (!mRequestApproved) {
    return NS_ERROR_DOM_BAD_URI;
  }
  return mOuterListener->OnDataAvailable(aRequest, aContext, aInputStream,
                                         aOffset, aCount);
}

void
nsCORSListenerProxy::SetInterceptController(nsINetworkInterceptController* aInterceptController)
{
  mInterceptController = aInterceptController;
}

NS_IMETHODIMP
nsCORSListenerProxy::GetInterface(const nsIID & aIID, void **aResult)
{
  if (aIID.Equals(NS_GET_IID(nsIChannelEventSink))) {
    *aResult = static_cast<nsIChannelEventSink*>(this);
    NS_ADDREF_THIS();

    return NS_OK;
  }

  if (aIID.Equals(NS_GET_IID(nsINetworkInterceptController)) &&
      mInterceptController) {
    nsCOMPtr<nsINetworkInterceptController> copy(mInterceptController);
    *aResult = copy.forget().take();

    return NS_OK;
  }

  return mOuterNotificationCallbacks ?
    mOuterNotificationCallbacks->GetInterface(aIID, aResult) :
    NS_ERROR_NO_INTERFACE;
}

NS_IMETHODIMP
nsCORSListenerProxy::AsyncOnChannelRedirect(nsIChannel *aOldChannel,
                                            nsIChannel *aNewChannel,
                                            uint32_t aFlags,
                                            nsIAsyncVerifyRedirectCallback *aCb)
{
  nsresult rv;
  if (NS_IsInternalSameURIRedirect(aOldChannel, aNewChannel, aFlags) ||
      NS_IsHSTSUpgradeRedirect(aOldChannel, aNewChannel, aFlags)) {
    // Internal redirects still need to be updated in order to maintain
    // the correct headers.  We use DataURIHandling::Allow, since unallowed
    // data URIs should have been blocked before we got to the internal
    // redirect.
    rv = UpdateChannel(aNewChannel, DataURIHandling::Allow,
                       UpdateType::InternalOrHSTSRedirect);
    if (NS_FAILED(rv)) {
        NS_WARNING("nsCORSListenerProxy::AsyncOnChannelRedirect: "
                   "internal redirect UpdateChannel() returned failure");
      aOldChannel->Cancel(rv);
      return rv;
    }
  } else {
    // A real, external redirect.  Perform CORS checking on new URL.
    rv = CheckRequestApproved(aOldChannel);
    if (NS_FAILED(rv)) {
      nsCOMPtr<nsIURI> oldURI;
      NS_GetFinalChannelURI(aOldChannel, getter_AddRefs(oldURI));
      if (oldURI) {
        if (sPreflightCache) {
          // OK to use mRequestingPrincipal since preflights never get
          // redirected.
          sPreflightCache->RemoveEntries(oldURI, mRequestingPrincipal);
        } else {
          nsCOMPtr<nsIHttpChannelChild> httpChannelChild =
            do_QueryInterface(aOldChannel);
          if (httpChannelChild) {
            rv = httpChannelChild->RemoveCorsPreflightCacheEntry(oldURI, mRequestingPrincipal);
            if (NS_FAILED(rv)) {
              // Only warn here to ensure we call the channel Cancel() below
              NS_WARNING("Failed to remove CORS preflight cache entry!");
            }
          }
        }
      }
      aOldChannel->Cancel(NS_ERROR_DOM_BAD_URI);
      return NS_ERROR_DOM_BAD_URI;
    }

    if (mHasBeenCrossSite) {
      // Once we've been cross-site, cross-origin redirects reset our source
      // origin. Note that we need to call GetChannelURIPrincipal() because
      // we are looking for the principal that is actually being loaded and not
      // the principal that initiated the load.
      nsCOMPtr<nsIPrincipal> oldChannelPrincipal;
      nsContentUtils::GetSecurityManager()->
        GetChannelURIPrincipal(aOldChannel, getter_AddRefs(oldChannelPrincipal));
      nsCOMPtr<nsIPrincipal> newChannelPrincipal;
      nsContentUtils::GetSecurityManager()->
        GetChannelURIPrincipal(aNewChannel, getter_AddRefs(newChannelPrincipal));
      if (!oldChannelPrincipal || !newChannelPrincipal) {
        rv = NS_ERROR_OUT_OF_MEMORY;
      }

      if (NS_SUCCEEDED(rv)) {
        bool equal;
        rv = oldChannelPrincipal->Equals(newChannelPrincipal, &equal);
        if (NS_SUCCEEDED(rv) && !equal) {
          // Spec says to set our source origin to a unique origin.
          mOriginHeaderPrincipal =
            nsNullPrincipal::CreateWithInheritedAttributes(oldChannelPrincipal);
        }
      }

      if (NS_FAILED(rv)) {
        aOldChannel->Cancel(rv);
        return rv;
      }
    }

    rv = UpdateChannel(aNewChannel, DataURIHandling::Disallow,
                       UpdateType::Default);
    if (NS_FAILED(rv)) {
        NS_WARNING("nsCORSListenerProxy::AsyncOnChannelRedirect: "
                   "UpdateChannel() returned failure");
      aOldChannel->Cancel(rv);
      return rv;
    }
  }

  nsCOMPtr<nsIChannelEventSink> outer =
    do_GetInterface(mOuterNotificationCallbacks);
  if (outer) {
    return outer->AsyncOnChannelRedirect(aOldChannel, aNewChannel, aFlags, aCb);
  }

  aCb->OnRedirectVerifyCallback(NS_OK);

  return NS_OK;
}

NS_IMETHODIMP
nsCORSListenerProxy::CheckListenerChain()
{
  MOZ_ASSERT(NS_IsMainThread());

  if (nsCOMPtr<nsIThreadRetargetableStreamListener> retargetableListener =
        do_QueryInterface(mOuterListener)) {
    return retargetableListener->CheckListenerChain();
  }

  return NS_ERROR_NO_INTERFACE;
}

// Please note that the CSP directive 'upgrade-insecure-requests' relies
// on the promise that channels get updated from http: to https: before
// the channel fetches any data from the netwerk. Such channels should
// not be blocked by CORS and marked as cross origin requests. E.g.:
// toplevel page: https://www.example.com loads
//           xhr: http://www.example.com/foo which gets updated to
//                https://www.example.com/foo
// In such a case we should bail out of CORS and rely on the promise that
// nsHttpChannel::Connect() upgrades the request from http to https.
bool
CheckUpgradeInsecureRequestsPreventsCORS(nsIPrincipal* aRequestingPrincipal,
                                         nsIChannel* aChannel)
{
  nsCOMPtr<nsIURI> channelURI;
  nsresult rv = NS_GetFinalChannelURI(aChannel, getter_AddRefs(channelURI));
  NS_ENSURE_SUCCESS(rv, false);
  bool isHttpScheme = false;
  rv = channelURI->SchemeIs("http", &isHttpScheme);
  NS_ENSURE_SUCCESS(rv, false);

  // upgrade insecure requests is only applicable to http requests
  if (!isHttpScheme) {
    return false;
  }

  nsCOMPtr<nsIURI> principalURI;
  rv = aRequestingPrincipal->GetURI(getter_AddRefs(principalURI));
  NS_ENSURE_SUCCESS(rv, false);

  // if the requestingPrincipal does not have a uri, there is nothing to do
  if (!principalURI) {
    return false;
  }

  nsCOMPtr<nsIURI>originalURI;
  rv = aChannel->GetOriginalURI(getter_AddRefs(originalURI));
  NS_ENSURE_SUCCESS(rv, false);

  nsAutoCString principalHost, channelHost, origChannelHost;

  // if we can not query a host from the uri, there is nothing to do
  if (NS_FAILED(principalURI->GetAsciiHost(principalHost)) ||
      NS_FAILED(channelURI->GetAsciiHost(channelHost)) ||
      NS_FAILED(originalURI->GetAsciiHost(origChannelHost))) {
    return false;
  }

  // if the hosts do not match, there is nothing to do
  if (!principalHost.EqualsIgnoreCase(channelHost.get())) {
    return false;
  }

  // also check that uri matches the one of the originalURI
  if (!channelHost.EqualsIgnoreCase(origChannelHost.get())) {
    return false;
  }

  nsCOMPtr<nsILoadInfo> loadInfo;
  rv = aChannel->GetLoadInfo(getter_AddRefs(loadInfo));
  NS_ENSURE_SUCCESS(rv, false);

  // lets see if the loadInfo indicates that the request will
  // be upgraded before fetching any data from the netwerk.
  return loadInfo->GetUpgradeInsecureRequests();
}


nsresult
nsCORSListenerProxy::UpdateChannel(nsIChannel* aChannel,
                                   DataURIHandling aAllowDataURI,
                                   UpdateType aUpdateType)
{
  nsCOMPtr<nsIURI> uri, originalURI;
  nsresult rv = NS_GetFinalChannelURI(aChannel, getter_AddRefs(uri));
  NS_ENSURE_SUCCESS(rv, rv);
  rv = aChannel->GetOriginalURI(getter_AddRefs(originalURI));
  NS_ENSURE_SUCCESS(rv, rv);

  nsCOMPtr<nsILoadInfo> loadInfo = aChannel->GetLoadInfo();

  // exempt data URIs from the same origin check.
  if (aAllowDataURI == DataURIHandling::Allow && originalURI == uri) {
    bool dataScheme = false;
    rv = uri->SchemeIs("data", &dataScheme);
    NS_ENSURE_SUCCESS(rv, rv);
    if (dataScheme) {
      return NS_OK;
    }
    if (loadInfo && loadInfo->GetAboutBlankInherits() &&
        NS_IsAboutBlank(uri)) {
      return NS_OK;
    }
  }

  // Set CORS attributes on channel so that intercepted requests get correct
  // values. We have to do this here because the CheckMayLoad checks may lead
  // to early return. We can't be sure this is an http channel though, so we
  // can't return early on failure.
  nsCOMPtr<nsIHttpChannelInternal> internal = do_QueryInterface(aChannel);
  if (internal) {
    rv = internal->SetCorsMode(nsIHttpChannelInternal::CORS_MODE_CORS);
    NS_ENSURE_SUCCESS(rv, rv);
    rv = internal->SetCorsIncludeCredentials(mWithCredentials);
    NS_ENSURE_SUCCESS(rv, rv);
  }

  // Check that the uri is ok to load
  rv = nsContentUtils::GetSecurityManager()->
    CheckLoadURIWithPrincipal(mRequestingPrincipal, uri,
                              nsIScriptSecurityManager::STANDARD);
  NS_ENSURE_SUCCESS(rv, rv);

  if (originalURI != uri) {
    rv = nsContentUtils::GetSecurityManager()->
      CheckLoadURIWithPrincipal(mRequestingPrincipal, originalURI,
                                nsIScriptSecurityManager::STANDARD);
    NS_ENSURE_SUCCESS(rv, rv);
  }

  if (!mHasBeenCrossSite &&
      NS_SUCCEEDED(mRequestingPrincipal->CheckMayLoad(uri, false, false)) &&
      (originalURI == uri ||
       NS_SUCCEEDED(mRequestingPrincipal->CheckMayLoad(originalURI,
                                                       false, false)))) {
    return NS_OK;
  }

  // if the CSP directive 'upgrade-insecure-requests' is used then we should
  // not incorrectly require CORS if the only difference of a subresource
  // request and the main page is the scheme.
  // e.g. toplevel page: https://www.example.com loads
  //                xhr: http://www.example.com/somefoo,
  // then the xhr request will be upgraded to https before it fetches any data
  // from the netwerk, hence we shouldn't require CORS in that specific case.
  if (CheckUpgradeInsecureRequestsPreventsCORS(mRequestingPrincipal, aChannel)) {
    return NS_OK;
  }

  // Check if we need to do a preflight, and if so set one up. This must be
  // called once we know that the request is going, or has gone, cross-origin.
  rv = CheckPreflightNeeded(aChannel, aUpdateType);
  NS_ENSURE_SUCCESS(rv, rv);

  // It's a cross site load
  mHasBeenCrossSite = true;

  nsCString userpass;
  uri->GetUserPass(userpass);
  NS_ENSURE_TRUE(userpass.IsEmpty(), NS_ERROR_DOM_BAD_URI);

  // If we have an expanded principal here, we'll reject the CORS request,
  // because we can't send a useful Origin header which is required for CORS.
  if (nsContentUtils::IsExpandedPrincipal(mOriginHeaderPrincipal)) {
    return NS_ERROR_DOM_BAD_URI;
  }

  // Add the Origin header
  nsAutoCString origin;
  rv = nsContentUtils::GetASCIIOrigin(mOriginHeaderPrincipal, origin);
  NS_ENSURE_SUCCESS(rv, rv);

  nsCOMPtr<nsIHttpChannel> http = do_QueryInterface(aChannel);
  NS_ENSURE_TRUE(http, NS_ERROR_FAILURE);

  rv = http->SetRequestHeader(NS_LITERAL_CSTRING("Origin"), origin, false);
  NS_ENSURE_SUCCESS(rv, rv);

  // Make cookie-less if needed. We don't need to do anything here if the
  // channel was opened with AsyncOpen2, since then AsyncOpen2 will take
  // care of the cookie policy for us.
  if (!mWithCredentials &&
      (!loadInfo || !loadInfo->GetEnforceSecurity())) {
    nsLoadFlags flags;
    rv = http->GetLoadFlags(&flags);
    NS_ENSURE_SUCCESS(rv, rv);

    flags |= nsIRequest::LOAD_ANONYMOUS;
    rv = http->SetLoadFlags(flags);
    NS_ENSURE_SUCCESS(rv, rv);
  }

  return NS_OK;
}

nsresult
nsCORSListenerProxy::CheckPreflightNeeded(nsIChannel* aChannel, UpdateType aUpdateType)
{
  // If this caller isn't using AsyncOpen2, or if this *is* a preflight channel,
  // then we shouldn't initiate preflight for this channel.
  nsCOMPtr<nsILoadInfo> loadInfo = aChannel->GetLoadInfo();
  if (!loadInfo ||
      loadInfo->GetSecurityMode() !=
        nsILoadInfo::SEC_REQUIRE_CORS_DATA_INHERITS ||
      loadInfo->GetIsPreflight()) {
    return NS_OK;
  }

  bool doPreflight = loadInfo->GetForcePreflight();

  nsCOMPtr<nsIHttpChannel> http = do_QueryInterface(aChannel);
  NS_ENSURE_TRUE(http, NS_ERROR_DOM_BAD_URI);
  nsAutoCString method;
  http->GetRequestMethod(method);
  if (!method.LowerCaseEqualsLiteral("get") &&
      !method.LowerCaseEqualsLiteral("post") &&
      !method.LowerCaseEqualsLiteral("head")) {
    doPreflight = true;
  }

  // Avoid copying the array here
  const nsTArray<nsCString>& loadInfoHeaders = loadInfo->CorsUnsafeHeaders();
  if (!loadInfoHeaders.IsEmpty()) {
    doPreflight = true;
  }

  // Add Content-Type header if needed
  nsTArray<nsCString> headers;
  nsAutoCString contentTypeHeader;
  nsresult rv = http->GetRequestHeader(NS_LITERAL_CSTRING("Content-Type"),
                                       contentTypeHeader);
  // GetRequestHeader return an error if the header is not set. Don't add
  // "content-type" to the list if that's the case.
  if (NS_SUCCEEDED(rv) &&
      !nsContentUtils::IsAllowedNonCorsContentType(contentTypeHeader) &&
      !loadInfoHeaders.Contains(NS_LITERAL_CSTRING("content-type"),
                                nsCaseInsensitiveCStringArrayComparator())) {
    headers.AppendElements(loadInfoHeaders);
    headers.AppendElement(NS_LITERAL_CSTRING("content-type"));
    doPreflight = true;
  }

  if (!doPreflight) {
    return NS_OK;
  }

  // A preflight is needed. But if we've already been cross-site, then
  // we already did a preflight when that happened, and so we're not allowed
  // to do another preflight again.
  if (aUpdateType != UpdateType::InternalOrHSTSRedirect) {
    NS_ENSURE_FALSE(mHasBeenCrossSite, NS_ERROR_DOM_BAD_URI);
  }

  nsCOMPtr<nsIHttpChannelInternal> internal = do_QueryInterface(http);
  NS_ENSURE_TRUE(internal, NS_ERROR_DOM_BAD_URI);

  internal->SetCorsPreflightParameters(
    headers.IsEmpty() ? loadInfoHeaders : headers);

  return NS_OK;
}

//////////////////////////////////////////////////////////////////////////
// Preflight proxy

// Class used as streamlistener and notification callback when
// doing the initial OPTIONS request for a CORS check
class nsCORSPreflightListener final : public nsIStreamListener,
                                      public nsIInterfaceRequestor,
                                      public nsIChannelEventSink
{
public:
  nsCORSPreflightListener(nsIPrincipal* aReferrerPrincipal,
                          nsICorsPreflightCallback* aCallback,
                          nsILoadContext* aLoadContext,
                          bool aWithCredentials,
                          const nsCString& aPreflightMethod,
                          const nsTArray<nsCString>& aPreflightHeaders)
   : mPreflightMethod(aPreflightMethod),
     mPreflightHeaders(aPreflightHeaders),
     mReferrerPrincipal(aReferrerPrincipal),
     mCallback(aCallback),
     mLoadContext(aLoadContext),
     mWithCredentials(aWithCredentials)
  {
  }

  NS_DECL_ISUPPORTS
  NS_DECL_NSISTREAMLISTENER
  NS_DECL_NSIREQUESTOBSERVER
  NS_DECL_NSIINTERFACEREQUESTOR
  NS_DECL_NSICHANNELEVENTSINK

  nsresult CheckPreflightRequestApproved(nsIRequest* aRequest);

private:
  ~nsCORSPreflightListener() {}

  void AddResultToCache(nsIRequest* aRequest);

  nsCString mPreflightMethod;
  nsTArray<nsCString> mPreflightHeaders;
  nsCOMPtr<nsIPrincipal> mReferrerPrincipal;
  nsCOMPtr<nsICorsPreflightCallback> mCallback;
  nsCOMPtr<nsILoadContext> mLoadContext;
  bool mWithCredentials;
};

NS_IMPL_ISUPPORTS(nsCORSPreflightListener, nsIStreamListener,
                  nsIRequestObserver, nsIInterfaceRequestor,
                  nsIChannelEventSink)

void
nsCORSPreflightListener::AddResultToCache(nsIRequest *aRequest)
{
  nsCOMPtr<nsIHttpChannel> http = do_QueryInterface(aRequest);
  NS_ASSERTION(http, "Request was not http");

  // The "Access-Control-Max-Age" header should return an age in seconds.
  nsAutoCString headerVal;
  http->GetResponseHeader(NS_LITERAL_CSTRING("Access-Control-Max-Age"),
                          headerVal);
  if (headerVal.IsEmpty()) {
    return;
  }

  // Sanitize the string. We only allow 'delta-seconds' as specified by
  // http://dev.w3.org/2006/waf/access-control (digits 0-9 with no leading or
  // trailing non-whitespace characters).
  uint32_t age = 0;
  nsCSubstring::const_char_iterator iter, end;
  headerVal.BeginReading(iter);
  headerVal.EndReading(end);
  while (iter != end) {
    if (*iter < '0' || *iter > '9') {
      return;
    }
    age = age * 10 + (*iter - '0');
    // Cap at 24 hours. This also avoids overflow
    age = std::min(age, 86400U);
    ++iter;
  }

  if (!age || !EnsurePreflightCache()) {
    return;
  }


  // String seems fine, go ahead and cache.
  // Note that we have already checked that these headers follow the correct
  // syntax.

  nsCOMPtr<nsIURI> uri;
  NS_GetFinalChannelURI(http, getter_AddRefs(uri));

  TimeStamp expirationTime = TimeStamp::NowLoRes() + TimeDuration::FromSeconds(age);

  nsPreflightCache::CacheEntry* entry =
    sPreflightCache->GetEntry(uri, mReferrerPrincipal, mWithCredentials,
                              true);
  if (!entry) {
    return;
  }

  // The "Access-Control-Allow-Methods" header contains a comma separated
  // list of method names.
  http->GetResponseHeader(NS_LITERAL_CSTRING("Access-Control-Allow-Methods"),
                          headerVal);

  nsCCharSeparatedTokenizer methods(headerVal, ',');
  while(methods.hasMoreTokens()) {
    const nsDependentCSubstring& method = methods.nextToken();
    if (method.IsEmpty()) {
      continue;
    }
    uint32_t i;
    for (i = 0; i < entry->mMethods.Length(); ++i) {
      if (entry->mMethods[i].token.Equals(method)) {
        entry->mMethods[i].expirationTime = expirationTime;
        break;
      }
    }
    if (i == entry->mMethods.Length()) {
      nsPreflightCache::TokenTime* newMethod =
        entry->mMethods.AppendElement();
      if (!newMethod) {
        return;
      }

      newMethod->token = method;
      newMethod->expirationTime = expirationTime;
    }
  }

  // The "Access-Control-Allow-Headers" header contains a comma separated
  // list of method names.
  http->GetResponseHeader(NS_LITERAL_CSTRING("Access-Control-Allow-Headers"),
                          headerVal);

  nsCCharSeparatedTokenizer headers(headerVal, ',');
  while(headers.hasMoreTokens()) {
    const nsDependentCSubstring& header = headers.nextToken();
    if (header.IsEmpty()) {
      continue;
    }
    uint32_t i;
    for (i = 0; i < entry->mHeaders.Length(); ++i) {
      if (entry->mHeaders[i].token.Equals(header)) {
        entry->mHeaders[i].expirationTime = expirationTime;
        break;
      }
    }
    if (i == entry->mHeaders.Length()) {
      nsPreflightCache::TokenTime* newHeader =
        entry->mHeaders.AppendElement();
      if (!newHeader) {
        return;
      }

      newHeader->token = header;
      newHeader->expirationTime = expirationTime;
    }
  }
}

NS_IMETHODIMP
nsCORSPreflightListener::OnStartRequest(nsIRequest *aRequest,
                                        nsISupports *aContext)
{
#ifdef DEBUG
  {
    nsCOMPtr<nsIHttpChannelInternal> internal = do_QueryInterface(aRequest);
    bool responseSynthesized = false;
    if (internal &&
        NS_SUCCEEDED(internal->GetResponseSynthesized(&responseSynthesized))) {
      // For synthesized responses, we don't need to perform any checks.
      // This would be unsafe if we ever changed our behavior to allow
      // service workers to intercept CORS preflights.
      MOZ_ASSERT(!responseSynthesized);
    }
  }
#endif

  nsresult rv = CheckPreflightRequestApproved(aRequest);

  if (NS_SUCCEEDED(rv)) {
    // Everything worked, try to cache and then fire off the actual request.
    AddResultToCache(aRequest);

    mCallback->OnPreflightSucceeded();
  } else {
    mCallback->OnPreflightFailed(rv);
  }

  return rv;
}

NS_IMETHODIMP
nsCORSPreflightListener::OnStopRequest(nsIRequest *aRequest,
                                       nsISupports *aContext,
                                       nsresult aStatus)
{
  mCallback = nullptr;
  return NS_OK;
}

/** nsIStreamListener methods **/

NS_IMETHODIMP
nsCORSPreflightListener::OnDataAvailable(nsIRequest *aRequest,
                                         nsISupports *ctxt,
                                         nsIInputStream *inStr,
                                         uint64_t sourceOffset,
                                         uint32_t count)
{
  uint32_t totalRead;
  return inStr->ReadSegments(NS_DiscardSegment, nullptr, count, &totalRead);
}

NS_IMETHODIMP
nsCORSPreflightListener::AsyncOnChannelRedirect(nsIChannel *aOldChannel,
                                                nsIChannel *aNewChannel,
                                                uint32_t aFlags,
                                                nsIAsyncVerifyRedirectCallback *callback)
{
  // Only internal redirects allowed for now.
  if (!NS_IsInternalSameURIRedirect(aOldChannel, aNewChannel, aFlags) &&
      !NS_IsHSTSUpgradeRedirect(aOldChannel, aNewChannel, aFlags))
    return NS_ERROR_DOM_BAD_URI;

  callback->OnRedirectVerifyCallback(NS_OK);
  return NS_OK;
}

nsresult
nsCORSPreflightListener::CheckPreflightRequestApproved(nsIRequest* aRequest)
{
  nsresult status;
  nsresult rv = aRequest->GetStatus(&status);
  NS_ENSURE_SUCCESS(rv, rv);
  NS_ENSURE_SUCCESS(status, status);

  // Test that things worked on a HTTP level
  nsCOMPtr<nsIHttpChannel> http = do_QueryInterface(aRequest);
  nsCOMPtr<nsIHttpChannelInternal> internal = do_QueryInterface(aRequest);
  NS_ENSURE_STATE(internal);

  bool succeedded;
  rv = http->GetRequestSucceeded(&succeedded);
  if (NS_FAILED(rv) || !succeedded) {
    LogBlockedRequest(aRequest, "CORSPreflightDidNotSucceed", nullptr);
    return NS_ERROR_DOM_BAD_URI;
  }

  nsAutoCString headerVal;
  // The "Access-Control-Allow-Methods" header contains a comma separated
  // list of method names.
  http->GetResponseHeader(NS_LITERAL_CSTRING("Access-Control-Allow-Methods"),
                          headerVal);
  bool foundMethod = mPreflightMethod.EqualsLiteral("GET") ||
                       mPreflightMethod.EqualsLiteral("HEAD") ||
                       mPreflightMethod.EqualsLiteral("POST");
  nsCCharSeparatedTokenizer methodTokens(headerVal, ',');
  while(methodTokens.hasMoreTokens()) {
    const nsDependentCSubstring& method = methodTokens.nextToken();
    if (method.IsEmpty()) {
      continue;
    }
    if (!NS_IsValidHTTPToken(method)) {
      LogBlockedRequest(aRequest, "CORSInvalidAllowMethod",
                        NS_ConvertUTF8toUTF16(method).get());
      return NS_ERROR_DOM_BAD_URI;
    }
    foundMethod |= mPreflightMethod.Equals(method);
  }
  if (!foundMethod) {
    LogBlockedRequest(aRequest, "CORSMethodNotFound", nullptr);
    return NS_ERROR_DOM_BAD_URI;
  }

  // The "Access-Control-Allow-Headers" header contains a comma separated
  // list of header names.
  http->GetResponseHeader(NS_LITERAL_CSTRING("Access-Control-Allow-Headers"),
                          headerVal);
  nsTArray<nsCString> headers;
  nsCCharSeparatedTokenizer headerTokens(headerVal, ',');
  while(headerTokens.hasMoreTokens()) {
    const nsDependentCSubstring& header = headerTokens.nextToken();
    if (header.IsEmpty()) {
      continue;
    }
    if (!NS_IsValidHTTPToken(header)) {
      LogBlockedRequest(aRequest, "CORSInvalidAllowHeader",
                        NS_ConvertUTF8toUTF16(header).get());
      return NS_ERROR_DOM_BAD_URI;
    }
    headers.AppendElement(header);
  }
  for (uint32_t i = 0; i < mPreflightHeaders.Length(); ++i) {
    if (!headers.Contains(mPreflightHeaders[i],
                          nsCaseInsensitiveCStringArrayComparator())) {
      LogBlockedRequest(aRequest, "CORSMissingAllowHeaderFromPreflight",
                        NS_ConvertUTF8toUTF16(mPreflightHeaders[i]).get());
      return NS_ERROR_DOM_BAD_URI;
    }
  }

  return NS_OK;
}

NS_IMETHODIMP
nsCORSPreflightListener::GetInterface(const nsIID & aIID, void **aResult)
{
  if (aIID.Equals(NS_GET_IID(nsILoadContext)) && mLoadContext) {
    nsCOMPtr<nsILoadContext> copy = mLoadContext;
    copy.forget(aResult);
    return NS_OK;
  }

  return QueryInterface(aIID, aResult);
}

void
nsCORSListenerProxy::RemoveFromCorsPreflightCache(nsIURI* aURI,
                                                  nsIPrincipal* aRequestingPrincipal)
{
  MOZ_ASSERT(XRE_IsParentProcess());
  if (sPreflightCache) {
    sPreflightCache->RemoveEntries(aURI, aRequestingPrincipal);
  }
}

nsresult
nsCORSListenerProxy::StartCORSPreflight(nsIChannel* aRequestChannel,
                                        nsICorsPreflightCallback* aCallback,
                                        nsTArray<nsCString>& aUnsafeHeaders,
                                        nsIChannel** aPreflightChannel)
{
  *aPreflightChannel = nullptr;

  if (gDisableCORS) {
    LogBlockedRequest(aRequestChannel, "CORSDisabled", nullptr);
    return NS_ERROR_DOM_BAD_URI;
  }

  nsAutoCString method;
  nsCOMPtr<nsIHttpChannel> httpChannel(do_QueryInterface(aRequestChannel));
  NS_ENSURE_TRUE(httpChannel, NS_ERROR_UNEXPECTED);
  httpChannel->GetRequestMethod(method);

  nsCOMPtr<nsIURI> uri;
  nsresult rv = NS_GetFinalChannelURI(aRequestChannel, getter_AddRefs(uri));
  NS_ENSURE_SUCCESS(rv, rv);

  nsCOMPtr<nsILoadInfo> originalLoadInfo = aRequestChannel->GetLoadInfo();
  MOZ_ASSERT(originalLoadInfo, "can not perform CORS preflight without a loadInfo");
  if (!originalLoadInfo) {
    return NS_ERROR_FAILURE;
  }

  MOZ_ASSERT(originalLoadInfo->GetSecurityMode() ==
             nsILoadInfo::SEC_REQUIRE_CORS_DATA_INHERITS,
             "how did we end up here?");

  nsCOMPtr<nsIPrincipal> principal = originalLoadInfo->LoadingPrincipal();
  MOZ_ASSERT(principal &&
             originalLoadInfo->GetExternalContentPolicyType() !=
               nsIContentPolicy::TYPE_DOCUMENT,
             "Should not do CORS loads for top-level loads, so a loadingPrincipal should always exist.");
  bool withCredentials = originalLoadInfo->GetCookiePolicy() ==
    nsILoadInfo::SEC_COOKIES_INCLUDE;

  nsPreflightCache::CacheEntry* entry =
    sPreflightCache ?
    sPreflightCache->GetEntry(uri, principal, withCredentials, false) :
    nullptr;

  if (entry && entry->CheckRequest(method, aUnsafeHeaders)) {
    aCallback->OnPreflightSucceeded();
    return NS_OK;
  }

  // Either it wasn't cached or the cached result has expired. Build a
  // channel for the OPTIONS request.

  nsCOMPtr<nsILoadInfo> loadInfo = static_cast<mozilla::LoadInfo*>
    (originalLoadInfo.get())->CloneForNewRequest();
  static_cast<mozilla::LoadInfo*>(loadInfo.get())->SetIsPreflight();

  nsCOMPtr<nsILoadGroup> loadGroup;
  rv = aRequestChannel->GetLoadGroup(getter_AddRefs(loadGroup));
  NS_ENSURE_SUCCESS(rv, rv);

  // We want to give the preflight channel's notification callbacks the same
  // load context as the original channel's notification callbacks had.  We
  // don't worry about a load context provided via the loadgroup here, since
  // they have the same loadgroup.
  nsCOMPtr<nsIInterfaceRequestor> callbacks;
  rv = aRequestChannel->GetNotificationCallbacks(getter_AddRefs(callbacks));
  NS_ENSURE_SUCCESS(rv, rv);
  nsCOMPtr<nsILoadContext> loadContext = do_GetInterface(callbacks);

  nsLoadFlags loadFlags;
  rv = aRequestChannel->GetLoadFlags(&loadFlags);
  NS_ENSURE_SUCCESS(rv, rv);

  // Preflight requests should never be intercepted by service workers and
  // are always anonymous.
  // NOTE: We ignore CORS checks on synthesized responses (see the CORS
  // preflights, then we need to extend the GetResponseSynthesized() check in
  // nsCORSListenerProxy::CheckRequestApproved()). If we change our behavior
  // here and allow service workers to intercept CORS preflights, then that
  // check won't be safe any more.
  loadFlags |= nsIChannel::LOAD_BYPASS_SERVICE_WORKER |
               nsIRequest::LOAD_ANONYMOUS;

  nsCOMPtr<nsIChannel> preflightChannel;
  rv = NS_NewChannelInternal(getter_AddRefs(preflightChannel),
                             uri,
                             loadInfo,
                             loadGroup,
                             nullptr,   // aCallbacks
                             loadFlags);
  NS_ENSURE_SUCCESS(rv, rv);

  // Set method and headers
  nsCOMPtr<nsIHttpChannel> preHttp = do_QueryInterface(preflightChannel);
  NS_ASSERTION(preHttp, "Failed to QI to nsIHttpChannel!");

  rv = preHttp->SetRequestMethod(NS_LITERAL_CSTRING("OPTIONS"));
  NS_ENSURE_SUCCESS(rv, rv);

  rv = preHttp->
    SetRequestHeader(NS_LITERAL_CSTRING("Access-Control-Request-Method"),
                     method, false);
  NS_ENSURE_SUCCESS(rv, rv);

  nsTArray<nsCString> preflightHeaders;
  if (!aUnsafeHeaders.IsEmpty()) {
    for (uint32_t i = 0; i < aUnsafeHeaders.Length(); ++i) {
      preflightHeaders.AppendElement();
      ToLowerCase(aUnsafeHeaders[i], preflightHeaders[i]);
    }
    preflightHeaders.Sort();
    nsAutoCString headers;
    for (uint32_t i = 0; i < preflightHeaders.Length(); ++i) {
      if (i != 0) {
        headers += ',';
      }
      headers += preflightHeaders[i];
    }
    rv = preHttp->
      SetRequestHeader(NS_LITERAL_CSTRING("Access-Control-Request-Headers"),
                       headers, false);
    NS_ENSURE_SUCCESS(rv, rv);
  }

  // Set up listener which will start the original channel
  RefPtr<nsCORSPreflightListener> preflightListener =
    new nsCORSPreflightListener(principal, aCallback, loadContext,
                                withCredentials, method, preflightHeaders);

  rv = preflightChannel->SetNotificationCallbacks(preflightListener);
  NS_ENSURE_SUCCESS(rv, rv);

  // Start preflight
  rv = preflightChannel->AsyncOpen2(preflightListener);
  NS_ENSURE_SUCCESS(rv, rv);

  // Return newly created preflight channel
  preflightChannel.forget(aPreflightChannel);

  return NS_OK;
}
