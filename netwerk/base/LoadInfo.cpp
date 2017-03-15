/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/LoadInfo.h"

#include "mozilla/Assertions.h"
#include "mozilla/dom/ToJSValue.h"
#include "mozIThirdPartyUtil.h"
#include "nsFrameLoader.h"
#include "nsIContentSecurityPolicy.h"
#include "nsIDocShell.h"
#include "nsIDocument.h"
#include "nsIDOMDocument.h"
#include "nsIFrameLoader.h"
#include "nsIInterfaceRequestorUtils.h"
#include "nsISupportsImpl.h"
#include "nsISupportsUtils.h"
#include "nsContentUtils.h"
#include "nsDocShell.h"
#include "nsGlobalWindow.h"
#include "nsNullPrincipal.h"

using namespace mozilla::dom;

namespace mozilla {
namespace net {

static void
InheritOriginAttributes(nsIPrincipal* aLoadingPrincipal, NeckoOriginAttributes& aAttrs)
{
  const PrincipalOriginAttributes attrs =
    BasePrincipal::Cast(aLoadingPrincipal)->OriginAttributesRef();
  aAttrs.InheritFromDocToNecko(attrs);
}

LoadInfo::LoadInfo(nsIPrincipal* aLoadingPrincipal,
                   nsIPrincipal* aTriggeringPrincipal,
                   nsINode* aLoadingContext,
                   nsSecurityFlags aSecurityFlags,
                   nsContentPolicyType aContentPolicyType)
  : mLoadingPrincipal(aLoadingContext ?
                        aLoadingContext->NodePrincipal() : aLoadingPrincipal)
  , mTriggeringPrincipal(aTriggeringPrincipal ?
                           aTriggeringPrincipal : mLoadingPrincipal.get())
  , mPrincipalToInherit(nullptr)
  , mLoadingContext(do_GetWeakReference(aLoadingContext))
  , mSecurityFlags(aSecurityFlags)
  , mInternalContentPolicyType(aContentPolicyType)
  , mTainting(LoadTainting::Basic)
  , mUpgradeInsecureRequests(false)
  , mVerifySignedContent(false)
  , mEnforceSRI(false)
  , mForceInheritPrincipalDropped(false)
  , mInnerWindowID(0)
  , mOuterWindowID(0)
  , mParentOuterWindowID(0)
  , mFrameOuterWindowID(0)
  , mEnforceSecurity(false)
  , mInitialSecurityCheckDone(false)
  , mIsThirdPartyContext(false)
  , mForcePreflight(false)
  , mIsPreflight(false)
  , mForceHSTSPriming(false)
  , mMixedContentWouldBlock(false)
{
  MOZ_ASSERT(mLoadingPrincipal);
  MOZ_ASSERT(mTriggeringPrincipal);

#ifdef DEBUG
  // TYPE_DOCUMENT loads initiated by javascript tests will go through
  // nsIOService and use the wrong constructor.  Don't enforce the
  // !TYPE_DOCUMENT check in those cases
  bool skipContentTypeCheck = false;
  skipContentTypeCheck = Preferences::GetBool("network.loadinfo.skip_type_assertion");
#endif

  // This constructor shouldn't be used for TYPE_DOCUMENT loads that don't
  // have a loadingPrincipal
  MOZ_ASSERT(skipContentTypeCheck ||
             mInternalContentPolicyType != nsIContentPolicy::TYPE_DOCUMENT);

  // TODO(bug 1259873): Above, we initialize mIsThirdPartyContext to false meaning
  // that consumers of LoadInfo that don't pass a context or pass a context from
  // which we can't find a window will default to assuming that they're 1st
  // party. It would be nice if we could default "safe" and assume that we are
  // 3rd party until proven otherwise.

  // if consumers pass both, aLoadingContext and aLoadingPrincipal
  // then the loadingPrincipal must be the same as the node's principal
  MOZ_ASSERT(!aLoadingContext || !aLoadingPrincipal ||
             aLoadingContext->NodePrincipal() == aLoadingPrincipal);

  // if the load is sandboxed, we can not also inherit the principal
  if (mSecurityFlags & nsILoadInfo::SEC_SANDBOXED) {
    mSecurityFlags ^= nsILoadInfo::SEC_FORCE_INHERIT_PRINCIPAL;
    mForceInheritPrincipalDropped = true;
  }

  if (aLoadingContext) {
    nsCOMPtr<nsPIDOMWindowOuter> contextOuter = aLoadingContext->OwnerDoc()->GetWindow();
    if (contextOuter) {
      ComputeIsThirdPartyContext(contextOuter);
      mOuterWindowID = contextOuter->WindowID();
      nsCOMPtr<nsPIDOMWindowOuter> parent = contextOuter->GetScriptableParent();
      mParentOuterWindowID = parent ? parent->WindowID() : mOuterWindowID;
    }

    mInnerWindowID = aLoadingContext->OwnerDoc()->InnerWindowID();

    // When the element being loaded is a frame, we choose the frame's window
    // for the window ID and the frame element's window as the parent
    // window. This is the behavior that Chrome exposes to add-ons.
    // NB: If the frameLoaderOwner doesn't have a frame loader, then the load
    // must be coming from an object (such as a plugin) that's loaded into it
    // instead of a document being loaded. In that case, treat this object like
    // any other non-document-loading element.
    nsCOMPtr<nsIFrameLoaderOwner> frameLoaderOwner =
      do_QueryInterface(aLoadingContext);
    nsCOMPtr<nsIFrameLoader> fl = frameLoaderOwner ?
      frameLoaderOwner->GetFrameLoader() : nullptr;
    if (fl) {
      nsCOMPtr<nsIDocShell> docShell;
      if (NS_SUCCEEDED(fl->GetDocShell(getter_AddRefs(docShell))) && docShell) {
        nsCOMPtr<nsPIDOMWindowOuter> outerWindow = do_GetInterface(docShell);
        if (outerWindow) {
          mFrameOuterWindowID = outerWindow->WindowID();
        }
      }
    }

    // if the document forces all requests to be upgraded from http to https, then
    // we should do that for all requests. If it only forces preloads to be upgraded
    // then we should enforce upgrade insecure requests only for preloads.
    mUpgradeInsecureRequests =
      aLoadingContext->OwnerDoc()->GetUpgradeInsecureRequests(false) ||
      (nsContentUtils::IsPreloadType(mInternalContentPolicyType) &&
       aLoadingContext->OwnerDoc()->GetUpgradeInsecureRequests(true));

    // if owner doc has content signature, we enforce SRI
    nsCOMPtr<nsIChannel> channel = aLoadingContext->OwnerDoc()->GetChannel();
    if (channel) {
      nsCOMPtr<nsILoadInfo> loadInfo = channel->GetLoadInfo();
      if (loadInfo) {
        mEnforceSRI = loadInfo->GetVerifySignedContent();
      }
    }
  }

    // If CSP requires SRI (require-sri-for), then store that information
    // in the loadInfo so we can enforce SRI before loading the subresource.
    if (!mEnforceSRI) {
      // do not look into the CSP if already true:
      // a CSP saying that SRI isn't needed should not
      // overrule GetVerifySignedContent
      if (aLoadingPrincipal) {
        nsCOMPtr<nsIContentSecurityPolicy> csp;
        aLoadingPrincipal->GetCsp(getter_AddRefs(csp));
        uint32_t externalType =
          nsContentUtils::InternalContentPolicyTypeToExternal(aContentPolicyType);
        // csp could be null if loading principal is system principal
        if (csp) {
          csp->RequireSRIForType(externalType, &mEnforceSRI);
        }
        // if CSP is delivered via a meta tag, it's speculatively available
        // as 'preloadCSP'. If we are preloading a script or style, we have
        // to apply that speculative 'preloadCSP' for such loads.
        if (!mEnforceSRI && nsContentUtils::IsPreloadType(aContentPolicyType)) {
          nsCOMPtr<nsIContentSecurityPolicy> preloadCSP;
          aLoadingPrincipal->GetPreloadCsp(getter_AddRefs(preloadCSP));
          if (preloadCSP) {
            preloadCSP->RequireSRIForType(externalType, &mEnforceSRI);
          }
        }
      }
    }

  InheritOriginAttributes(mLoadingPrincipal, mOriginAttributes);

  // We need to do this after inheriting the document's origin attributes
  // above, in case the loading principal ends up being the system principal.
  if (aLoadingContext) {
    nsCOMPtr<nsILoadContext> loadContext =
      aLoadingContext->OwnerDoc()->GetLoadContext();
    nsCOMPtr<nsIDocShell> docShell = aLoadingContext->OwnerDoc()->GetDocShell();
    if (loadContext && docShell &&
        docShell->ItemType() == nsIDocShellTreeItem::typeContent) {
      bool usePrivateBrowsing;
      nsresult rv = loadContext->GetUsePrivateBrowsing(&usePrivateBrowsing);
      if (NS_SUCCEEDED(rv)) {
        mOriginAttributes.SyncAttributesWithPrivateBrowsing(usePrivateBrowsing);
      }
    }
  }

  // For chrome docshell, the mPrivateBrowsingId remains 0 even its
  // UsePrivateBrowsing() is true, so we only update the mPrivateBrowsingId in
  // origin attributes if the type of the docshell is content.
  if (aLoadingContext) {
    nsCOMPtr<nsIDocShell> docShell = aLoadingContext->OwnerDoc()->GetDocShell();
    if (docShell) {
      if (docShell->ItemType() == nsIDocShellTreeItem::typeChrome) {
        MOZ_ASSERT(mOriginAttributes.mPrivateBrowsingId == 0,
                   "chrome docshell shouldn't have mPrivateBrowsingId set.");
      }
    }
  }
}

/* Constructor takes an outer window, but no loadingNode or loadingPrincipal.
 * This constructor should only be used for TYPE_DOCUMENT loads, since they
 * have a null loadingNode and loadingPrincipal.
*/
LoadInfo::LoadInfo(nsPIDOMWindowOuter* aOuterWindow,
                   nsIPrincipal* aTriggeringPrincipal,
                   nsSecurityFlags aSecurityFlags)
  : mLoadingPrincipal(nullptr)
  , mTriggeringPrincipal(aTriggeringPrincipal)
  , mPrincipalToInherit(nullptr)
  , mSecurityFlags(aSecurityFlags)
  , mInternalContentPolicyType(nsIContentPolicy::TYPE_DOCUMENT)
  , mTainting(LoadTainting::Basic)
  , mUpgradeInsecureRequests(false)
  , mVerifySignedContent(false)
  , mEnforceSRI(false)
  , mForceInheritPrincipalDropped(false)
  , mInnerWindowID(0)
  , mOuterWindowID(0)
  , mParentOuterWindowID(0)
  , mFrameOuterWindowID(0)
  , mEnforceSecurity(false)
  , mInitialSecurityCheckDone(false)
  , mIsThirdPartyContext(false) // NB: TYPE_DOCUMENT implies not third-party.
  , mForcePreflight(false)
  , mIsPreflight(false)
  , mForceHSTSPriming(false)
  , mMixedContentWouldBlock(false)
{
  // Top-level loads are never third-party
  // Grab the information we can out of the window.
  MOZ_ASSERT(aOuterWindow);
  MOZ_ASSERT(mTriggeringPrincipal);

  // if the load is sandboxed, we can not also inherit the principal
  if (mSecurityFlags & nsILoadInfo::SEC_SANDBOXED) {
    mSecurityFlags ^= nsILoadInfo::SEC_FORCE_INHERIT_PRINCIPAL;
    mForceInheritPrincipalDropped = true;
  }

  // NB: Ignore the current inner window since we're navigating away from it.
  mOuterWindowID = aOuterWindow->WindowID();

  // TODO We can have a parent without a frame element in some cases dealing
  // with the hidden window.
  nsCOMPtr<nsPIDOMWindowOuter> parent = aOuterWindow->GetScriptableParent();
  mParentOuterWindowID = parent ? parent->WindowID() : 0;

  // get the docshell from the outerwindow, and then get the originattributes
  nsCOMPtr<nsIDocShell> docShell = aOuterWindow->GetDocShell();
  MOZ_ASSERT(docShell);
  const DocShellOriginAttributes attrs =
    nsDocShell::Cast(docShell)->GetOriginAttributes();

  if (docShell->ItemType() == nsIDocShellTreeItem::typeChrome) {
    MOZ_ASSERT(attrs.mPrivateBrowsingId == 0,
               "chrome docshell shouldn't have mPrivateBrowsingId set.");
  }

  mOriginAttributes.InheritFromDocShellToNecko(attrs);
}

LoadInfo::LoadInfo(const LoadInfo& rhs)
  : mLoadingPrincipal(rhs.mLoadingPrincipal)
  , mTriggeringPrincipal(rhs.mTriggeringPrincipal)
  , mPrincipalToInherit(rhs.mPrincipalToInherit)
  , mLoadingContext(rhs.mLoadingContext)
  , mSecurityFlags(rhs.mSecurityFlags)
  , mInternalContentPolicyType(rhs.mInternalContentPolicyType)
  , mTainting(rhs.mTainting)
  , mUpgradeInsecureRequests(rhs.mUpgradeInsecureRequests)
  , mVerifySignedContent(rhs.mVerifySignedContent)
  , mEnforceSRI(rhs.mEnforceSRI)
  , mForceInheritPrincipalDropped(rhs.mForceInheritPrincipalDropped)
  , mInnerWindowID(rhs.mInnerWindowID)
  , mOuterWindowID(rhs.mOuterWindowID)
  , mParentOuterWindowID(rhs.mParentOuterWindowID)
  , mFrameOuterWindowID(rhs.mFrameOuterWindowID)
  , mEnforceSecurity(rhs.mEnforceSecurity)
  , mInitialSecurityCheckDone(rhs.mInitialSecurityCheckDone)
  , mIsThirdPartyContext(rhs.mIsThirdPartyContext)
  , mOriginAttributes(rhs.mOriginAttributes)
  , mRedirectChainIncludingInternalRedirects(
      rhs.mRedirectChainIncludingInternalRedirects)
  , mRedirectChain(rhs.mRedirectChain)
  , mCorsUnsafeHeaders(rhs.mCorsUnsafeHeaders)
  , mForcePreflight(rhs.mForcePreflight)
  , mIsPreflight(rhs.mIsPreflight)
  , mForceHSTSPriming(rhs.mForceHSTSPriming)
  , mMixedContentWouldBlock(rhs.mMixedContentWouldBlock)
{
}

LoadInfo::LoadInfo(nsIPrincipal* aLoadingPrincipal,
                   nsIPrincipal* aTriggeringPrincipal,
                   nsIPrincipal* aPrincipalToInherit,
                   nsSecurityFlags aSecurityFlags,
                   nsContentPolicyType aContentPolicyType,
                   LoadTainting aTainting,
                   bool aUpgradeInsecureRequests,
                   bool aVerifySignedContent,
                   bool aEnforceSRI,
                   bool aForceInheritPrincipalDropped,
                   uint64_t aInnerWindowID,
                   uint64_t aOuterWindowID,
                   uint64_t aParentOuterWindowID,
                   uint64_t aFrameOuterWindowID,
                   bool aEnforceSecurity,
                   bool aInitialSecurityCheckDone,
                   bool aIsThirdPartyContext,
                   const NeckoOriginAttributes& aOriginAttributes,
                   nsTArray<nsCOMPtr<nsIPrincipal>>& aRedirectChainIncludingInternalRedirects,
                   nsTArray<nsCOMPtr<nsIPrincipal>>& aRedirectChain,
                   const nsTArray<nsCString>& aCorsUnsafeHeaders,
                   bool aForcePreflight,
                   bool aIsPreflight,
                   bool aForceHSTSPriming,
                   bool aMixedContentWouldBlock)
  : mLoadingPrincipal(aLoadingPrincipal)
  , mTriggeringPrincipal(aTriggeringPrincipal)
  , mPrincipalToInherit(aPrincipalToInherit)
  , mSecurityFlags(aSecurityFlags)
  , mInternalContentPolicyType(aContentPolicyType)
  , mTainting(aTainting)
  , mUpgradeInsecureRequests(aUpgradeInsecureRequests)
  , mVerifySignedContent(aVerifySignedContent)
  , mEnforceSRI(aEnforceSRI)
  , mForceInheritPrincipalDropped(aForceInheritPrincipalDropped)
  , mInnerWindowID(aInnerWindowID)
  , mOuterWindowID(aOuterWindowID)
  , mParentOuterWindowID(aParentOuterWindowID)
  , mFrameOuterWindowID(aFrameOuterWindowID)
  , mEnforceSecurity(aEnforceSecurity)
  , mInitialSecurityCheckDone(aInitialSecurityCheckDone)
  , mIsThirdPartyContext(aIsThirdPartyContext)
  , mOriginAttributes(aOriginAttributes)
  , mCorsUnsafeHeaders(aCorsUnsafeHeaders)
  , mForcePreflight(aForcePreflight)
  , mIsPreflight(aIsPreflight)
  , mForceHSTSPriming (aForceHSTSPriming)
  , mMixedContentWouldBlock(aMixedContentWouldBlock)
{
  // Only top level TYPE_DOCUMENT loads can have a null loadingPrincipal
  MOZ_ASSERT(mLoadingPrincipal || aContentPolicyType == nsIContentPolicy::TYPE_DOCUMENT);
  MOZ_ASSERT(mTriggeringPrincipal);

  mRedirectChainIncludingInternalRedirects.SwapElements(
    aRedirectChainIncludingInternalRedirects);

  mRedirectChain.SwapElements(aRedirectChain);
}

LoadInfo::~LoadInfo()
{
}

void
LoadInfo::ComputeIsThirdPartyContext(nsPIDOMWindowOuter* aOuterWindow)
{
  nsContentPolicyType type =
    nsContentUtils::InternalContentPolicyTypeToExternal(mInternalContentPolicyType);
  if (type == nsIContentPolicy::TYPE_DOCUMENT) {
    // Top-level loads are never third-party.
    mIsThirdPartyContext = false;
    return;
  }

  nsCOMPtr<mozIThirdPartyUtil> util(do_GetService(THIRDPARTYUTIL_CONTRACTID));
  if (NS_WARN_IF(!util)) {
    return;
  }

  util->IsThirdPartyWindow(aOuterWindow, nullptr, &mIsThirdPartyContext);
}

NS_IMPL_ISUPPORTS(LoadInfo, nsILoadInfo)

already_AddRefed<nsILoadInfo>
LoadInfo::Clone() const
{
  RefPtr<LoadInfo> copy(new LoadInfo(*this));
  return copy.forget();
}

already_AddRefed<nsILoadInfo>
LoadInfo::CloneWithNewSecFlags(nsSecurityFlags aSecurityFlags) const
{
  RefPtr<LoadInfo> copy(new LoadInfo(*this));
  copy->mSecurityFlags = aSecurityFlags;
  return copy.forget();
}

already_AddRefed<nsILoadInfo>
LoadInfo::CloneForNewRequest() const
{
  RefPtr<LoadInfo> copy(new LoadInfo(*this));
  copy->mEnforceSecurity = false;
  copy->mInitialSecurityCheckDone = false;
  copy->mRedirectChainIncludingInternalRedirects.Clear();
  copy->mRedirectChain.Clear();
  return copy.forget();
}

NS_IMETHODIMP
LoadInfo::GetLoadingPrincipal(nsIPrincipal** aLoadingPrincipal)
{
  NS_IF_ADDREF(*aLoadingPrincipal = mLoadingPrincipal);
  return NS_OK;
}

nsIPrincipal*
LoadInfo::LoadingPrincipal()
{
  return mLoadingPrincipal;
}

NS_IMETHODIMP
LoadInfo::GetTriggeringPrincipal(nsIPrincipal** aTriggeringPrincipal)
{
  NS_ADDREF(*aTriggeringPrincipal = mTriggeringPrincipal);
  return NS_OK;
}

nsIPrincipal*
LoadInfo::TriggeringPrincipal()
{
  return mTriggeringPrincipal;
}

NS_IMETHODIMP
LoadInfo::GetPrincipalToInherit(nsIPrincipal** aPrincipalToInherit)
{
  NS_IF_ADDREF(*aPrincipalToInherit = mPrincipalToInherit);
  return NS_OK;
}

NS_IMETHODIMP
LoadInfo::SetPrincipalToInherit(nsIPrincipal* aPrincipalToInherit)
{
  MOZ_ASSERT(aPrincipalToInherit, "must be a valid principal to inherit");
  mPrincipalToInherit = aPrincipalToInherit;
  return NS_OK;
}

nsIPrincipal*
LoadInfo::PrincipalToInherit()
{
  return mPrincipalToInherit;
}

NS_IMETHODIMP
LoadInfo::GetLoadingDocument(nsIDOMDocument** aResult)
{
  nsCOMPtr<nsINode> node = do_QueryReferent(mLoadingContext);
  if (node) {
    nsCOMPtr<nsIDOMDocument> context = do_QueryInterface(node->OwnerDoc());
    context.forget(aResult);
  }
  return NS_OK;
}

nsINode*
LoadInfo::LoadingNode()
{
  nsCOMPtr<nsINode> node = do_QueryReferent(mLoadingContext);
  return node;
}

NS_IMETHODIMP
LoadInfo::GetSecurityFlags(nsSecurityFlags* aResult)
{
  *aResult = mSecurityFlags;
  return NS_OK;
}

NS_IMETHODIMP
LoadInfo::GetSecurityMode(uint32_t* aFlags)
{
  *aFlags = (mSecurityFlags &
              (nsILoadInfo::SEC_REQUIRE_SAME_ORIGIN_DATA_INHERITS |
               nsILoadInfo::SEC_REQUIRE_SAME_ORIGIN_DATA_IS_BLOCKED |
               nsILoadInfo::SEC_ALLOW_CROSS_ORIGIN_DATA_INHERITS |
               nsILoadInfo::SEC_ALLOW_CROSS_ORIGIN_DATA_IS_NULL |
               nsILoadInfo::SEC_REQUIRE_CORS_DATA_INHERITS));
  return NS_OK;
}

NS_IMETHODIMP
LoadInfo::GetIsInThirdPartyContext(bool* aIsInThirdPartyContext)
{
  *aIsInThirdPartyContext = mIsThirdPartyContext;
  return NS_OK;
}

static const uint32_t sCookiePolicyMask =
  nsILoadInfo::SEC_COOKIES_DEFAULT |
  nsILoadInfo::SEC_COOKIES_INCLUDE |
  nsILoadInfo::SEC_COOKIES_SAME_ORIGIN |
  nsILoadInfo::SEC_COOKIES_OMIT;

NS_IMETHODIMP
LoadInfo::GetCookiePolicy(uint32_t *aResult)
{
  uint32_t policy = mSecurityFlags & sCookiePolicyMask;
  if (policy == nsILoadInfo::SEC_COOKIES_DEFAULT) {
    policy = (mSecurityFlags & SEC_REQUIRE_CORS_DATA_INHERITS) ?
      nsILoadInfo::SEC_COOKIES_SAME_ORIGIN : nsILoadInfo::SEC_COOKIES_INCLUDE;
  }

  *aResult = policy;
  return NS_OK;
}

void
LoadInfo::SetIncludeCookiesSecFlag()
{
  MOZ_ASSERT(!mEnforceSecurity,
             "Request should not have been opened yet");
  MOZ_ASSERT((mSecurityFlags & sCookiePolicyMask) ==
             nsILoadInfo::SEC_COOKIES_DEFAULT);
  mSecurityFlags = (mSecurityFlags & ~sCookiePolicyMask) |
                   nsILoadInfo::SEC_COOKIES_INCLUDE;
}

NS_IMETHODIMP
LoadInfo::GetForceInheritPrincipal(bool* aInheritPrincipal)
{
  *aInheritPrincipal =
    (mSecurityFlags & nsILoadInfo::SEC_FORCE_INHERIT_PRINCIPAL);
  return NS_OK;
}

NS_IMETHODIMP
LoadInfo::GetForceInheritPrincipalOverruleOwner(bool* aInheritPrincipal)
{
  *aInheritPrincipal =
    (mSecurityFlags & nsILoadInfo::SEC_FORCE_INHERIT_PRINCIPAL_OVERRULE_OWNER);
  return NS_OK;
}

NS_IMETHODIMP
LoadInfo::GetLoadingSandboxed(bool* aLoadingSandboxed)
{
  *aLoadingSandboxed = (mSecurityFlags & nsILoadInfo::SEC_SANDBOXED);
  return NS_OK;
}

NS_IMETHODIMP
LoadInfo::GetAboutBlankInherits(bool* aResult)
{
  *aResult =
    (mSecurityFlags & nsILoadInfo::SEC_ABOUT_BLANK_INHERITS);
  return NS_OK;
}

NS_IMETHODIMP
LoadInfo::GetAllowChrome(bool* aResult)
{
  *aResult =
    (mSecurityFlags & nsILoadInfo::SEC_ALLOW_CHROME);
  return NS_OK;
}

NS_IMETHODIMP
LoadInfo::GetDisallowScript(bool* aResult)
{
  *aResult =
    (mSecurityFlags & nsILoadInfo::SEC_DISALLOW_SCRIPT);
  return NS_OK;
}


NS_IMETHODIMP
LoadInfo::GetDontFollowRedirects(bool* aResult)
{
  *aResult =
    (mSecurityFlags & nsILoadInfo::SEC_DONT_FOLLOW_REDIRECTS);
  return NS_OK;
}

NS_IMETHODIMP
LoadInfo::GetLoadErrorPage(bool* aResult)
{
  *aResult =
    (mSecurityFlags & nsILoadInfo::SEC_LOAD_ERROR_PAGE);
  return NS_OK;
}

NS_IMETHODIMP
LoadInfo::GetExternalContentPolicyType(nsContentPolicyType* aResult)
{
  *aResult = nsContentUtils::InternalContentPolicyTypeToExternal(mInternalContentPolicyType);
  return NS_OK;
}

nsContentPolicyType
LoadInfo::InternalContentPolicyType()
{
  return mInternalContentPolicyType;
}

NS_IMETHODIMP
LoadInfo::GetUpgradeInsecureRequests(bool* aResult)
{
  *aResult = mUpgradeInsecureRequests;
  return NS_OK;
}

NS_IMETHODIMP
LoadInfo::SetVerifySignedContent(bool aVerifySignedContent)
{
  MOZ_ASSERT(mInternalContentPolicyType == nsIContentPolicy::TYPE_DOCUMENT,
            "can only verify content for TYPE_DOCUMENT");
  mVerifySignedContent = aVerifySignedContent;
  return NS_OK;
}

NS_IMETHODIMP
LoadInfo::GetVerifySignedContent(bool* aResult)
{
  *aResult = mVerifySignedContent;
  return NS_OK;
}

NS_IMETHODIMP
LoadInfo::SetEnforceSRI(bool aEnforceSRI)
{
  mEnforceSRI = aEnforceSRI;
  return NS_OK;
}

NS_IMETHODIMP
LoadInfo::GetEnforceSRI(bool* aResult)
{
  *aResult = mEnforceSRI;
  return NS_OK;
}

NS_IMETHODIMP
LoadInfo::GetForceInheritPrincipalDropped(bool* aResult)
{
  *aResult = mForceInheritPrincipalDropped;
  return NS_OK;
}

NS_IMETHODIMP
LoadInfo::GetInnerWindowID(uint64_t* aResult)
{
  *aResult = mInnerWindowID;
  return NS_OK;
}

NS_IMETHODIMP
LoadInfo::GetOuterWindowID(uint64_t* aResult)
{
  *aResult = mOuterWindowID;
  return NS_OK;
}

NS_IMETHODIMP
LoadInfo::GetParentOuterWindowID(uint64_t* aResult)
{
  *aResult = mParentOuterWindowID;
  return NS_OK;
}

NS_IMETHODIMP
LoadInfo::GetFrameOuterWindowID(uint64_t* aResult)
{
  *aResult = mFrameOuterWindowID;
  return NS_OK;
}

NS_IMETHODIMP
LoadInfo::GetScriptableOriginAttributes(JSContext* aCx,
  JS::MutableHandle<JS::Value> aOriginAttributes)
{
  if (NS_WARN_IF(!ToJSValue(aCx, mOriginAttributes, aOriginAttributes))) {
    return NS_ERROR_FAILURE;
  }
  return NS_OK;
}

NS_IMETHODIMP
LoadInfo::ResetPrincipalsToNullPrincipal()
{
  // take the originAttributes from the LoadInfo and create
  // a new NullPrincipal using those origin attributes.
  PrincipalOriginAttributes pAttrs;
  pAttrs.InheritFromNecko(mOriginAttributes);
  nsCOMPtr<nsIPrincipal> newNullPrincipal = nsNullPrincipal::Create(pAttrs);

  MOZ_ASSERT(mInternalContentPolicyType != nsIContentPolicy::TYPE_DOCUMENT ||
             !mLoadingPrincipal,
             "LoadingPrincipal should be null for toplevel loads");

  // the loadingPrincipal for toplevel loads is always a nullptr;
  if (mInternalContentPolicyType != nsIContentPolicy::TYPE_DOCUMENT) {
    mLoadingPrincipal = newNullPrincipal;
  }
  mTriggeringPrincipal = newNullPrincipal;
  mPrincipalToInherit = newNullPrincipal;

  // setting SEC_FORCE_INHERIT_PRINCIPAL_OVERRULE_OWNER will overrule
  // any non null owner set on the channel and will return the principal
  // form the loadinfo instead.
  mSecurityFlags |= SEC_FORCE_INHERIT_PRINCIPAL_OVERRULE_OWNER;

  return NS_OK;
}

NS_IMETHODIMP
LoadInfo::SetScriptableOriginAttributes(JSContext* aCx,
  JS::Handle<JS::Value> aOriginAttributes)
{
  NeckoOriginAttributes attrs;
  if (!aOriginAttributes.isObject() || !attrs.Init(aCx, aOriginAttributes)) {
    return NS_ERROR_INVALID_ARG;
  }

  mOriginAttributes = attrs;
  return NS_OK;
}

nsresult
LoadInfo::GetOriginAttributes(mozilla::NeckoOriginAttributes* aOriginAttributes)
{
  NS_ENSURE_ARG(aOriginAttributes);
  *aOriginAttributes = mOriginAttributes;
  return NS_OK;
}

nsresult
LoadInfo::SetOriginAttributes(const mozilla::NeckoOriginAttributes& aOriginAttributes)
{
  mOriginAttributes = aOriginAttributes;
  return NS_OK;
}

NS_IMETHODIMP
LoadInfo::SetEnforceSecurity(bool aEnforceSecurity)
{
  // Indicates whether the channel was openend using AsyncOpen2. Once set
  // to true, it must remain true throughout the lifetime of the channel.
  // Setting it to anything else than true will be discarded.
  MOZ_ASSERT(aEnforceSecurity, "aEnforceSecurity must be true");
  mEnforceSecurity = mEnforceSecurity || aEnforceSecurity;
  return NS_OK;
}

NS_IMETHODIMP
LoadInfo::GetEnforceSecurity(bool* aResult)
{
  *aResult = mEnforceSecurity;
  return NS_OK;
}

NS_IMETHODIMP
LoadInfo::SetInitialSecurityCheckDone(bool aInitialSecurityCheckDone)
{
  // Indicates whether the channel was ever evaluated by the
  // ContentSecurityManager. Once set to true, this flag must
  // remain true throughout the lifetime of the channel.
  // Setting it to anything else than true will be discarded.
  MOZ_ASSERT(aInitialSecurityCheckDone, "aInitialSecurityCheckDone must be true");
  mInitialSecurityCheckDone = mInitialSecurityCheckDone || aInitialSecurityCheckDone;
  return NS_OK;
}

NS_IMETHODIMP
LoadInfo::GetInitialSecurityCheckDone(bool* aResult)
{
  *aResult = mInitialSecurityCheckDone;
  return NS_OK;
}

NS_IMETHODIMP
LoadInfo::AppendRedirectedPrincipal(nsIPrincipal* aPrincipal, bool aIsInternalRedirect)
{
  NS_ENSURE_ARG(aPrincipal);
  MOZ_ASSERT(NS_IsMainThread());

  mRedirectChainIncludingInternalRedirects.AppendElement(aPrincipal);
  if (!aIsInternalRedirect) {
    mRedirectChain.AppendElement(aPrincipal);
  }
  return NS_OK;
}

NS_IMETHODIMP
LoadInfo::GetRedirectChainIncludingInternalRedirects(JSContext* aCx, JS::MutableHandle<JS::Value> aChain)
{
  if (!ToJSValue(aCx, mRedirectChainIncludingInternalRedirects, aChain)) {
    return NS_ERROR_OUT_OF_MEMORY;
  }
  return NS_OK;
}

const nsTArray<nsCOMPtr<nsIPrincipal>>&
LoadInfo::RedirectChainIncludingInternalRedirects()
{
  return mRedirectChainIncludingInternalRedirects;
}

NS_IMETHODIMP
LoadInfo::GetRedirectChain(JSContext* aCx, JS::MutableHandle<JS::Value> aChain)
{
  if (!ToJSValue(aCx, mRedirectChain, aChain)) {
    return NS_ERROR_OUT_OF_MEMORY;
  }
  return NS_OK;
}

const nsTArray<nsCOMPtr<nsIPrincipal>>&
LoadInfo::RedirectChain()
{
  return mRedirectChain;
}

void
LoadInfo::SetCorsPreflightInfo(const nsTArray<nsCString>& aHeaders,
                               bool aForcePreflight)
{
  MOZ_ASSERT(GetSecurityMode() == nsILoadInfo::SEC_REQUIRE_CORS_DATA_INHERITS);
  MOZ_ASSERT(!mInitialSecurityCheckDone);
  mCorsUnsafeHeaders = aHeaders;
  mForcePreflight = aForcePreflight;
}

const nsTArray<nsCString>&
LoadInfo::CorsUnsafeHeaders()
{
  return mCorsUnsafeHeaders;
}

NS_IMETHODIMP
LoadInfo::GetForcePreflight(bool* aForcePreflight)
{
  *aForcePreflight = mForcePreflight;
  return NS_OK;
}

void
LoadInfo::SetIsPreflight()
{
  MOZ_ASSERT(GetSecurityMode() == nsILoadInfo::SEC_REQUIRE_CORS_DATA_INHERITS);
  MOZ_ASSERT(!mInitialSecurityCheckDone);
  mIsPreflight = true;
}

NS_IMETHODIMP
LoadInfo::GetIsPreflight(bool* aIsPreflight)
{
  *aIsPreflight = mIsPreflight;
  return NS_OK;
}

NS_IMETHODIMP
LoadInfo::GetForceHSTSPriming(bool* aForceHSTSPriming)
{
  *aForceHSTSPriming = mForceHSTSPriming;
  return NS_OK;
}

NS_IMETHODIMP
LoadInfo::GetMixedContentWouldBlock(bool *aMixedContentWouldBlock)
{
  *aMixedContentWouldBlock = mMixedContentWouldBlock;
  return NS_OK;
}

void
LoadInfo::SetHSTSPriming(bool aMixedContentWouldBlock)
{
  mForceHSTSPriming = true;
  mMixedContentWouldBlock = aMixedContentWouldBlock;
}

void
LoadInfo::ClearHSTSPriming()
{
  mForceHSTSPriming = false;
  mMixedContentWouldBlock = false;
}

NS_IMETHODIMP
LoadInfo::GetTainting(uint32_t* aTaintingOut)
{
  MOZ_ASSERT(aTaintingOut);
  *aTaintingOut = static_cast<uint32_t>(mTainting);
  return NS_OK;
}

NS_IMETHODIMP
LoadInfo::MaybeIncreaseTainting(uint32_t aTainting)
{
  NS_ENSURE_ARG(aTainting <= TAINTING_OPAQUE);
  LoadTainting tainting = static_cast<LoadTainting>(aTainting);
  if (tainting > mTainting) {
    mTainting = tainting;
  }
  return NS_OK;
}

NS_IMETHODIMP
LoadInfo::GetIsTopLevelLoad(bool *aResult)
{
  *aResult = mFrameOuterWindowID ? mFrameOuterWindowID == mOuterWindowID
                                 : mParentOuterWindowID == mOuterWindowID;
  return NS_OK;
}

} // namespace net
} // namespace mozilla
