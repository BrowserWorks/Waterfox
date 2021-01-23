/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2; -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/ExtensionPolicyService.h"
#include "mozilla/extensions/DocumentObserver.h"
#include "mozilla/extensions/WebExtensionContentScript.h"
#include "mozilla/extensions/WebExtensionPolicy.h"

#include "mozilla/AddonManagerWebAPI.h"
#include "mozilla/ResultExtensions.h"
#include "mozilla/StaticPrefs_extensions.h"
#include "nsEscape.h"
#include "nsIObserver.h"
#include "nsISubstitutingProtocolHandler.h"
#include "nsNetUtil.h"
#include "nsPrintfCString.h"

namespace mozilla {
namespace extensions {

using namespace dom;

static const char kProto[] = "moz-extension";

static const char kBackgroundPageHTMLStart[] =
    "<!DOCTYPE html>\n\
<html>\n\
  <head><meta charset=\"utf-8\"></head>\n\
  <body>";

static const char kBackgroundPageHTMLScript[] =
    "\n\
    <script type=\"text/javascript\" src=\"%s\"></script>";

static const char kBackgroundPageHTMLEnd[] =
    "\n\
  </body>\n\
</html>";

static const char kRestrictedDomainPref[] =
    "extensions.webextensions.restrictedDomains";

static inline ExtensionPolicyService& EPS() {
  return ExtensionPolicyService::GetSingleton();
}

static nsISubstitutingProtocolHandler* Proto() {
  static nsCOMPtr<nsISubstitutingProtocolHandler> sHandler;

  if (MOZ_UNLIKELY(!sHandler)) {
    nsCOMPtr<nsIIOService> ios = do_GetIOService();
    MOZ_RELEASE_ASSERT(ios);

    nsCOMPtr<nsIProtocolHandler> handler;
    ios->GetProtocolHandler(kProto, getter_AddRefs(handler));

    sHandler = do_QueryInterface(handler);
    MOZ_RELEASE_ASSERT(sHandler);

    ClearOnShutdown(&sHandler);
  }

  return sHandler;
}

bool ParseGlobs(GlobalObject& aGlobal, Sequence<OwningMatchGlobOrString> aGlobs,
                nsTArray<RefPtr<MatchGlob>>& aResult, ErrorResult& aRv) {
  for (auto& elem : aGlobs) {
    if (elem.IsMatchGlob()) {
      aResult.AppendElement(elem.GetAsMatchGlob());
    } else {
      RefPtr<MatchGlob> glob =
          MatchGlob::Constructor(aGlobal, elem.GetAsString(), true, aRv);
      if (aRv.Failed()) {
        return false;
      }
      aResult.AppendElement(glob);
    }
  }
  return true;
}

enum class ErrorBehavior {
  CreateEmptyPattern,
  Fail,
};

already_AddRefed<MatchPatternSet> ParseMatches(
    GlobalObject& aGlobal,
    const OwningMatchPatternSetOrStringSequence& aMatches,
    const MatchPatternOptions& aOptions, ErrorBehavior aErrorBehavior,
    ErrorResult& aRv) {
  if (aMatches.IsMatchPatternSet()) {
    return do_AddRef(aMatches.GetAsMatchPatternSet().get());
  }

  const auto& strings = aMatches.GetAsStringSequence();

  nsTArray<OwningStringOrMatchPattern> patterns;
  if (!patterns.SetCapacity(strings.Length(), fallible)) {
    aRv.Throw(NS_ERROR_OUT_OF_MEMORY);
    return nullptr;
  }

  for (auto& string : strings) {
    OwningStringOrMatchPattern elt;
    elt.SetAsString() = string;
    patterns.AppendElement(elt);
  }

  RefPtr<MatchPatternSet> result =
      MatchPatternSet::Constructor(aGlobal, patterns, aOptions, aRv);

  if (aRv.Failed() && aErrorBehavior == ErrorBehavior::CreateEmptyPattern) {
    aRv.SuppressException();
    result = MatchPatternSet::Constructor(aGlobal, {}, aOptions, aRv);
  }

  return result.forget();
}

/*****************************************************************************
 * WebExtensionPolicy
 *****************************************************************************/

WebExtensionPolicy::WebExtensionPolicy(GlobalObject& aGlobal,
                                       const WebExtensionInit& aInit,
                                       ErrorResult& aRv)
    : mId(NS_AtomizeMainThread(aInit.mId)),
      mHostname(aInit.mMozExtensionHostname),
      mName(aInit.mName),
      mExtensionPageCSP(aInit.mExtensionPageCSP),
      mContentScriptCSP(aInit.mContentScriptCSP),
      mLocalizeCallback(aInit.mLocalizeCallback),
      mIsPrivileged(aInit.mIsPrivileged),
      mPermissions(new AtomSet(aInit.mPermissions)) {
  if (!ParseGlobs(aGlobal, aInit.mWebAccessibleResources, mWebAccessiblePaths,
                  aRv)) {
    return;
  }

  // We set this here to prevent this policy changing after creation.
  mAllowPrivateBrowsingByDefault =
      StaticPrefs::extensions_allowPrivateBrowsingByDefault();

  MatchPatternOptions options;
  options.mRestrictSchemes = !HasPermission(nsGkAtoms::mozillaAddons);

  mHostPermissions = ParseMatches(aGlobal, aInit.mAllowedOrigins, options,
                                  ErrorBehavior::CreateEmptyPattern, aRv);
  if (aRv.Failed()) {
    return;
  }

  if (!aInit.mBackgroundScripts.IsNull()) {
    mBackgroundScripts.SetValue().AppendElements(
        aInit.mBackgroundScripts.Value());
  }

  if (mExtensionPageCSP.IsVoid()) {
    EPS().GetDefaultCSP(mExtensionPageCSP);
  }

  if (mContentScriptCSP.IsVoid()) {
    EPS().GetDefaultCSP(mContentScriptCSP);
  }

  mContentScripts.SetCapacity(aInit.mContentScripts.Length());
  for (const auto& scriptInit : aInit.mContentScripts) {
    // The activeTab permission is only for dynamically injected scripts,
    // it cannot be used for declarative content scripts.
    if (scriptInit.mHasActiveTabPermission) {
      aRv.Throw(NS_ERROR_INVALID_ARG);
      return;
    }

    RefPtr<WebExtensionContentScript> contentScript =
        new WebExtensionContentScript(aGlobal, *this, scriptInit, aRv);
    if (aRv.Failed()) {
      return;
    }
    mContentScripts.AppendElement(std::move(contentScript));
  }

  if (aInit.mReadyPromise.WasPassed()) {
    mReadyPromise = &aInit.mReadyPromise.Value();
  }

  nsresult rv = NS_NewURI(getter_AddRefs(mBaseURI), aInit.mBaseURL);
  if (NS_FAILED(rv)) {
    aRv.Throw(rv);
  }
}

already_AddRefed<WebExtensionPolicy> WebExtensionPolicy::Constructor(
    GlobalObject& aGlobal, const WebExtensionInit& aInit, ErrorResult& aRv) {
  RefPtr<WebExtensionPolicy> policy =
      new WebExtensionPolicy(aGlobal, aInit, aRv);
  if (aRv.Failed()) {
    return nullptr;
  }
  return policy.forget();
}

/* static */
void WebExtensionPolicy::GetActiveExtensions(
    dom::GlobalObject& aGlobal,
    nsTArray<RefPtr<WebExtensionPolicy>>& aResults) {
  EPS().GetAll(aResults);
}

/* static */
already_AddRefed<WebExtensionPolicy> WebExtensionPolicy::GetByID(
    dom::GlobalObject& aGlobal, const nsAString& aID) {
  return do_AddRef(EPS().GetByID(aID));
}

/* static */
already_AddRefed<WebExtensionPolicy> WebExtensionPolicy::GetByHostname(
    dom::GlobalObject& aGlobal, const nsACString& aHostname) {
  return do_AddRef(EPS().GetByHost(aHostname));
}

/* static */
already_AddRefed<WebExtensionPolicy> WebExtensionPolicy::GetByURI(
    dom::GlobalObject& aGlobal, nsIURI* aURI) {
  return do_AddRef(EPS().GetByURL(aURI));
}

void WebExtensionPolicy::SetActive(bool aActive, ErrorResult& aRv) {
  if (aActive == mActive) {
    return;
  }

  bool ok = aActive ? Enable() : Disable();

  if (!ok) {
    aRv.Throw(NS_ERROR_UNEXPECTED);
  }
}

bool WebExtensionPolicy::Enable() {
  MOZ_ASSERT(!mActive);

  if (!EPS().RegisterExtension(*this)) {
    return false;
  }

  Unused << Proto()->SetSubstitution(MozExtensionHostname(), mBaseURI);

  mActive = true;
  return true;
}

bool WebExtensionPolicy::Disable() {
  MOZ_ASSERT(mActive);
  MOZ_ASSERT(EPS().GetByID(Id()) == this);

  if (!EPS().UnregisterExtension(*this)) {
    return false;
  }

  Unused << Proto()->SetSubstitution(MozExtensionHostname(), nullptr);

  mActive = false;
  return true;
}

void WebExtensionPolicy::GetURL(const nsAString& aPath, nsAString& aResult,
                                ErrorResult& aRv) const {
  auto result = GetURL(aPath);
  if (result.isOk()) {
    aResult = result.unwrap();
  } else {
    aRv.Throw(result.unwrapErr());
  }
}

Result<nsString, nsresult> WebExtensionPolicy::GetURL(
    const nsAString& aPath) const {
  nsPrintfCString spec("%s://%s/", kProto, mHostname.get());

  nsCOMPtr<nsIURI> uri;
  MOZ_TRY(NS_NewURI(getter_AddRefs(uri), spec));

  MOZ_TRY(uri->Resolve(NS_ConvertUTF16toUTF8(aPath), spec));

  return NS_ConvertUTF8toUTF16(spec);
}

void WebExtensionPolicy::RegisterContentScript(
    WebExtensionContentScript& script, ErrorResult& aRv) {
  // Raise an "invalid argument" error if the script is not related to
  // the expected extension or if it is already registered.
  if (script.mExtension != this || mContentScripts.Contains(&script)) {
    aRv.Throw(NS_ERROR_INVALID_ARG);
    return;
  }

  RefPtr<WebExtensionContentScript> newScript = &script;

  if (!mContentScripts.AppendElement(std::move(newScript), fallible)) {
    aRv.Throw(NS_ERROR_OUT_OF_MEMORY);
    return;
  }

  WebExtensionPolicy_Binding::ClearCachedContentScriptsValue(this);
}

void WebExtensionPolicy::UnregisterContentScript(
    const WebExtensionContentScript& script, ErrorResult& aRv) {
  if (script.mExtension != this || !mContentScripts.RemoveElement(&script)) {
    aRv.Throw(NS_ERROR_INVALID_ARG);
    return;
  }

  WebExtensionPolicy_Binding::ClearCachedContentScriptsValue(this);
}

void WebExtensionPolicy::InjectContentScripts(ErrorResult& aRv) {
  nsresult rv = EPS().InjectContentScripts(this);
  if (NS_FAILED(rv)) {
    aRv.Throw(rv);
  }
}

/* static */
bool WebExtensionPolicy::UseRemoteWebExtensions(GlobalObject& aGlobal) {
  return EPS().UseRemoteExtensions();
}

/* static */
bool WebExtensionPolicy::IsExtensionProcess(GlobalObject& aGlobal) {
  return EPS().IsExtensionProcess();
}

namespace {
/**
 * Maintains a dynamically updated AtomSet based on the comma-separated
 * values in the given string pref.
 */
class AtomSetPref : public nsIObserver, public nsSupportsWeakReference {
 public:
  NS_DECL_ISUPPORTS
  NS_DECL_NSIOBSERVER

  static already_AddRefed<AtomSetPref> Create(const nsCString& aPref) {
    RefPtr<AtomSetPref> self = new AtomSetPref(aPref.get());
    Preferences::AddWeakObserver(self, aPref);
    return self.forget();
  }

  const AtomSet& Get() const;

  bool Contains(const nsAtom* aAtom) const { return Get().Contains(aAtom); }

 protected:
  virtual ~AtomSetPref() = default;

  explicit AtomSetPref(const char* aPref) : mPref(aPref) {}

 private:
  mutable RefPtr<AtomSet> mAtomSet;
  const char* mPref;
};

const AtomSet& AtomSetPref::Get() const {
  if (!mAtomSet) {
    nsAutoCString eltsString;
    Unused << Preferences::GetCString(mPref, eltsString);

    AutoTArray<nsString, 32> elts;
    for (const nsACString& elt : eltsString.Split(',')) {
      elts.AppendElement(NS_ConvertUTF8toUTF16(elt));
      elts.LastElement().StripWhitespace();
    }
    mAtomSet = new AtomSet(elts);
  }

  return *mAtomSet;
}

NS_IMETHODIMP
AtomSetPref::Observe(nsISupports* aSubject, const char* aTopic,
                     const char16_t* aData) {
  mAtomSet = nullptr;
  return NS_OK;
}

NS_IMPL_ISUPPORTS(AtomSetPref, nsIObserver, nsISupportsWeakReference)
};  // namespace

/* static */
bool WebExtensionPolicy::IsRestrictedDoc(const DocInfo& aDoc) {
  // With the exception of top-level about:blank documents with null
  // principals, we never match documents that have non-content principals,
  // including those with null principals or system principals.
  if (aDoc.Principal() && !aDoc.Principal()->GetIsContentPrincipal()) {
    return true;
  }

  return IsRestrictedURI(aDoc.PrincipalURL());
}

/* static */
bool WebExtensionPolicy::IsRestrictedURI(const URLInfo& aURI) {
  static RefPtr<AtomSetPref> domains;
  if (!domains) {
    domains = AtomSetPref::Create(nsLiteralCString(kRestrictedDomainPref));
    ClearOnShutdown(&domains);
  }

  if (domains->Contains(aURI.HostAtom())) {
    return true;
  }

  if (AddonManagerWebAPI::IsValidSite(aURI.URI())) {
    return true;
  }

  return false;
}

nsCString WebExtensionPolicy::BackgroundPageHTML() const {
  nsCString result;

  if (mBackgroundScripts.IsNull()) {
    result.SetIsVoid(true);
    return result;
  }

  result.AppendLiteral(kBackgroundPageHTMLStart);

  for (auto& script : mBackgroundScripts.Value()) {
    nsCString escaped;
    nsAppendEscapedHTML(NS_ConvertUTF16toUTF8(script), escaped);

    result.AppendPrintf(kBackgroundPageHTMLScript, escaped.get());
  }

  result.AppendLiteral(kBackgroundPageHTMLEnd);
  return result;
}

void WebExtensionPolicy::Localize(const nsAString& aInput,
                                  nsString& aOutput) const {
  RefPtr<WebExtensionLocalizeCallback> callback(mLocalizeCallback);
  callback->Call(aInput, aOutput);
}

JSObject* WebExtensionPolicy::WrapObject(JSContext* aCx,
                                         JS::HandleObject aGivenProto) {
  return WebExtensionPolicy_Binding::Wrap(aCx, this, aGivenProto);
}

void WebExtensionPolicy::GetContentScripts(
    nsTArray<RefPtr<WebExtensionContentScript>>& aScripts) const {
  aScripts.AppendElements(mContentScripts);
}

bool WebExtensionPolicy::CanAccessContext(nsILoadContext* aContext) const {
  MOZ_ASSERT(aContext);
  return PrivateBrowsingAllowed() || !aContext->UsePrivateBrowsing();
}

bool WebExtensionPolicy::CanAccessWindow(
    const dom::WindowProxyHolder& aWindow) const {
  if (PrivateBrowsingAllowed()) {
    return true;
  }
  // match browsing mode with policy
  nsIDocShell* docShell = aWindow.get()->GetDocShell();
  nsCOMPtr<nsILoadContext> loadContext = do_QueryInterface(docShell);
  return !(loadContext && loadContext->UsePrivateBrowsing());
}

void WebExtensionPolicy::GetReadyPromise(
    JSContext* aCx, JS::MutableHandleObject aResult) const {
  if (mReadyPromise) {
    aResult.set(mReadyPromise->PromiseObj());
  } else {
    aResult.set(nullptr);
  }
}

NS_IMPL_CYCLE_COLLECTION_WRAPPERCACHE_WEAK_PTR(WebExtensionPolicy, mParent,
                                               mLocalizeCallback,
                                               mHostPermissions,
                                               mWebAccessiblePaths,
                                               mContentScripts)

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(WebExtensionPolicy)
  NS_WRAPPERCACHE_INTERFACE_MAP_ENTRY
  NS_INTERFACE_MAP_ENTRY(nsISupports)
NS_INTERFACE_MAP_END

NS_IMPL_CYCLE_COLLECTING_ADDREF(WebExtensionPolicy)
NS_IMPL_CYCLE_COLLECTING_RELEASE(WebExtensionPolicy)

/*****************************************************************************
 * WebExtensionContentScript / MozDocumentMatcher
 *****************************************************************************/

/* static */
already_AddRefed<MozDocumentMatcher> MozDocumentMatcher::Constructor(
    GlobalObject& aGlobal, const dom::MozDocumentMatcherInit& aInit,
    ErrorResult& aRv) {
  RefPtr<MozDocumentMatcher> matcher =
      new MozDocumentMatcher(aGlobal, aInit, false, aRv);
  if (aRv.Failed()) {
    return nullptr;
  }
  return matcher.forget();
}

/* static */
already_AddRefed<WebExtensionContentScript>
WebExtensionContentScript::Constructor(GlobalObject& aGlobal,
                                       WebExtensionPolicy& aExtension,
                                       const ContentScriptInit& aInit,
                                       ErrorResult& aRv) {
  RefPtr<WebExtensionContentScript> script =
      new WebExtensionContentScript(aGlobal, aExtension, aInit, aRv);
  if (aRv.Failed()) {
    return nullptr;
  }
  return script.forget();
}

MozDocumentMatcher::MozDocumentMatcher(GlobalObject& aGlobal,
                                       const dom::MozDocumentMatcherInit& aInit,
                                       bool aRestricted, ErrorResult& aRv)
    : mHasActiveTabPermission(aInit.mHasActiveTabPermission),
      mRestricted(aRestricted),
      mAllFrames(aInit.mAllFrames),
      mFrameID(aInit.mFrameID),
      mMatchAboutBlank(aInit.mMatchAboutBlank) {
  MatchPatternOptions options;
  options.mRestrictSchemes = mRestricted;

  mMatches = ParseMatches(aGlobal, aInit.mMatches, options,
                          ErrorBehavior::CreateEmptyPattern, aRv);
  if (aRv.Failed()) {
    return;
  }

  if (!aInit.mExcludeMatches.IsNull()) {
    mExcludeMatches =
        ParseMatches(aGlobal, aInit.mExcludeMatches.Value(), options,
                     ErrorBehavior::CreateEmptyPattern, aRv);
    if (aRv.Failed()) {
      return;
    }
  }

  if (!aInit.mIncludeGlobs.IsNull()) {
    if (!ParseGlobs(aGlobal, aInit.mIncludeGlobs.Value(),
                    mIncludeGlobs.SetValue(), aRv)) {
      return;
    }
  }

  if (!aInit.mExcludeGlobs.IsNull()) {
    if (!ParseGlobs(aGlobal, aInit.mExcludeGlobs.Value(),
                    mExcludeGlobs.SetValue(), aRv)) {
      return;
    }
  }
}

WebExtensionContentScript::WebExtensionContentScript(
    GlobalObject& aGlobal, WebExtensionPolicy& aExtension,
    const ContentScriptInit& aInit, ErrorResult& aRv)
    : MozDocumentMatcher(aGlobal, aInit,
                         !aExtension.HasPermission(nsGkAtoms::mozillaAddons),
                         aRv),
      mRunAt(aInit.mRunAt) {
  mCssPaths.Assign(aInit.mCssPaths);
  mJsPaths.Assign(aInit.mJsPaths);
  mExtension = &aExtension;
}

bool MozDocumentMatcher::Matches(const DocInfo& aDoc) const {
  if (!mFrameID.IsNull()) {
    if (aDoc.FrameID() != mFrameID.Value()) {
      return false;
    }
  } else {
    if (!mAllFrames && !aDoc.IsTopLevel()) {
      return false;
    }
  }

  // match browsing mode with policy
  nsCOMPtr<nsILoadContext> loadContext = aDoc.GetLoadContext();
  if (loadContext && mExtension && !mExtension->CanAccessContext(loadContext)) {
    return false;
  }

  if (!mMatchAboutBlank && aDoc.URL().InheritsPrincipal()) {
    return false;
  }

  // Top-level about:blank is a special case. We treat it as a match if
  // matchAboutBlank is true and it has the null principal. In all other
  // cases, we test the URL of the principal that it inherits.
  if (mMatchAboutBlank && aDoc.IsTopLevel() &&
      (aDoc.URL().Spec().EqualsLiteral("about:blank") ||
       aDoc.URL().Scheme() == nsGkAtoms::data) &&
      aDoc.Principal() && aDoc.Principal()->GetIsNullPrincipal()) {
    return true;
  }

  if (mRestricted && mExtension->IsRestrictedDoc(aDoc)) {
    return false;
  }

  auto& urlinfo = aDoc.PrincipalURL();
  if (mHasActiveTabPermission && aDoc.ShouldMatchActiveTabPermission() &&
      MatchPattern::MatchesAllURLs(urlinfo)) {
    return true;
  }

  return MatchesURI(urlinfo);
}

bool MozDocumentMatcher::MatchesURI(const URLInfo& aURL) const {
  if (!mMatches->Matches(aURL)) {
    return false;
  }

  if (mExcludeMatches && mExcludeMatches->Matches(aURL)) {
    return false;
  }

  if (!mIncludeGlobs.IsNull() && !mIncludeGlobs.Value().Matches(aURL.Spec())) {
    return false;
  }

  if (!mExcludeGlobs.IsNull() && mExcludeGlobs.Value().Matches(aURL.Spec())) {
    return false;
  }

  if (mRestricted && mExtension->IsRestrictedURI(aURL)) {
    return false;
  }

  return true;
}

JSObject* MozDocumentMatcher::WrapObject(JSContext* aCx,
                                         JS::HandleObject aGivenProto) {
  return MozDocumentMatcher_Binding::Wrap(aCx, this, aGivenProto);
}

JSObject* WebExtensionContentScript::WrapObject(JSContext* aCx,
                                                JS::HandleObject aGivenProto) {
  return WebExtensionContentScript_Binding::Wrap(aCx, this, aGivenProto);
}

NS_IMPL_CYCLE_COLLECTION_WRAPPERCACHE(MozDocumentMatcher, mMatches,
                                      mExcludeMatches, mIncludeGlobs,
                                      mExcludeGlobs, mExtension)

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(MozDocumentMatcher)
  NS_WRAPPERCACHE_INTERFACE_MAP_ENTRY
  NS_INTERFACE_MAP_ENTRY(nsISupports)
NS_INTERFACE_MAP_END

NS_IMPL_CYCLE_COLLECTING_ADDREF(MozDocumentMatcher)
NS_IMPL_CYCLE_COLLECTING_RELEASE(MozDocumentMatcher)

/*****************************************************************************
 * MozDocumentObserver
 *****************************************************************************/

/* static */
already_AddRefed<DocumentObserver> DocumentObserver::Constructor(
    GlobalObject& aGlobal, dom::MozDocumentCallback& aCallbacks) {
  RefPtr<DocumentObserver> matcher =
      new DocumentObserver(aGlobal.GetAsSupports(), aCallbacks);
  return matcher.forget();
}

void DocumentObserver::Observe(
    const dom::Sequence<OwningNonNull<MozDocumentMatcher>>& matchers,
    ErrorResult& aRv) {
  if (!EPS().RegisterObserver(*this)) {
    aRv.Throw(NS_ERROR_FAILURE);
    return;
  }
  mMatchers.Clear();
  for (auto& matcher : matchers) {
    if (!mMatchers.AppendElement(matcher, fallible)) {
      aRv.Throw(NS_ERROR_OUT_OF_MEMORY);
      return;
    }
  }
}

void DocumentObserver::Disconnect() {
  Unused << EPS().UnregisterObserver(*this);
}

void DocumentObserver::NotifyMatch(MozDocumentMatcher& aMatcher,
                                   nsPIDOMWindowOuter* aWindow) {
  IgnoredErrorResult rv;
  mCallbacks->OnNewDocument(
      aMatcher, WindowProxyHolder(aWindow->GetBrowsingContext()), rv);
}

void DocumentObserver::NotifyMatch(MozDocumentMatcher& aMatcher,
                                   nsILoadInfo* aLoadInfo) {
  IgnoredErrorResult rv;
  mCallbacks->OnPreloadDocument(aMatcher, aLoadInfo, rv);
}

JSObject* DocumentObserver::WrapObject(JSContext* aCx,
                                       JS::HandleObject aGivenProto) {
  return MozDocumentObserver_Binding::Wrap(aCx, this, aGivenProto);
}

NS_IMPL_CYCLE_COLLECTION_WRAPPERCACHE(DocumentObserver, mCallbacks, mMatchers,
                                      mParent)

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(DocumentObserver)
  NS_WRAPPERCACHE_INTERFACE_MAP_ENTRY
  NS_INTERFACE_MAP_ENTRY(nsISupports)
NS_INTERFACE_MAP_END

NS_IMPL_CYCLE_COLLECTING_ADDREF(DocumentObserver)
NS_IMPL_CYCLE_COLLECTING_RELEASE(DocumentObserver)

/*****************************************************************************
 * DocInfo
 *****************************************************************************/

DocInfo::DocInfo(const URLInfo& aURL, nsILoadInfo* aLoadInfo)
    : mURL(aURL), mObj(AsVariant(aLoadInfo)) {}

DocInfo::DocInfo(nsPIDOMWindowOuter* aWindow)
    : mURL(aWindow->GetDocumentURI()), mObj(AsVariant(aWindow)) {}

bool DocInfo::IsTopLevel() const {
  if (mIsTopLevel.isNothing()) {
    struct Matcher {
      bool operator()(Window aWin) { return aWin->IsTopLevelWindow(); }
      bool operator()(LoadInfo aLoadInfo) {
        return aLoadInfo->GetIsTopLevelLoad();
      }
    };
    mIsTopLevel.emplace(mObj.match(Matcher()));
  }
  return mIsTopLevel.ref();
}

bool WindowShouldMatchActiveTab(nsPIDOMWindowOuter* aWin) {
  if (aWin->IsTopLevelWindow()) {
    return true;
  }

  nsIDocShell* docshell = aWin->GetDocShell();
  if (!docshell || docshell->GetCreatedDynamically()) {
    return false;
  }

  Document* doc = aWin->GetExtantDoc();
  if (!doc) {
    return false;
  }

  nsIChannel* channel = doc->GetChannel();
  if (!channel) {
    return false;
  }

  nsCOMPtr<nsILoadInfo> loadInfo = channel->LoadInfo();
  if (!loadInfo->GetOriginalFrameSrcLoad()) {
    return false;
  }

  nsCOMPtr<nsPIDOMWindowOuter> parent = aWin->GetInProcessParent();
  MOZ_ASSERT(parent != nullptr);
  return WindowShouldMatchActiveTab(parent);
}

bool DocInfo::ShouldMatchActiveTabPermission() const {
  struct Matcher {
    bool operator()(Window aWin) { return WindowShouldMatchActiveTab(aWin); }
    bool operator()(LoadInfo aLoadInfo) { return false; }
  };
  return mObj.match(Matcher());
}

uint64_t DocInfo::FrameID() const {
  if (mFrameID.isNothing()) {
    if (IsTopLevel()) {
      mFrameID.emplace(0);
    } else {
      struct Matcher {
        uint64_t operator()(Window aWin) { return aWin->WindowID(); }
        uint64_t operator()(LoadInfo aLoadInfo) {
          return aLoadInfo->GetOuterWindowID();
        }
      };
      mFrameID.emplace(mObj.match(Matcher()));
    }
  }
  return mFrameID.ref();
}

nsIPrincipal* DocInfo::Principal() const {
  if (mPrincipal.isNothing()) {
    struct Matcher {
      explicit Matcher(const DocInfo& aThis) : mThis(aThis) {}
      const DocInfo& mThis;

      nsIPrincipal* operator()(Window aWin) {
        RefPtr<Document> doc = aWin->GetDoc();
        return doc->NodePrincipal();
      }
      nsIPrincipal* operator()(LoadInfo aLoadInfo) {
        if (!(mThis.URL().InheritsPrincipal() ||
              aLoadInfo->GetForceInheritPrincipal())) {
          return nullptr;
        }
        if (auto principal = aLoadInfo->PrincipalToInherit()) {
          return principal;
        }
        return aLoadInfo->TriggeringPrincipal();
      }
    };
    mPrincipal.emplace(mObj.match(Matcher(*this)));
  }
  return mPrincipal.ref();
}

const URLInfo& DocInfo::PrincipalURL() const {
  if (!(Principal() && Principal()->GetIsContentPrincipal())) {
    return URL();
  }

  if (mPrincipalURL.isNothing()) {
    nsIPrincipal* prin = Principal();
    auto* basePrin = BasePrincipal::Cast(prin);
    nsCOMPtr<nsIURI> uri;
    if (NS_SUCCEEDED(basePrin->GetURI(getter_AddRefs(uri)))) {
      MOZ_DIAGNOSTIC_ASSERT(uri);
      mPrincipalURL.emplace(uri);
    } else {
      mPrincipalURL.emplace(URL());
    }
  }

  return mPrincipalURL.ref();
}

}  // namespace extensions
}  // namespace mozilla
