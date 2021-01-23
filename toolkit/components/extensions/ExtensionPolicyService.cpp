/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2; -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/ExtensionPolicyService.h"
#include "mozilla/extensions/DocumentObserver.h"
#include "mozilla/extensions/WebExtensionContentScript.h"
#include "mozilla/extensions/WebExtensionPolicy.h"

#include "mozilla/BasePrincipal.h"
#include "mozilla/ClearOnShutdown.h"
#include "mozilla/Preferences.h"
#include "mozilla/ResultExtensions.h"
#include "mozilla/Services.h"
#include "mozilla/SimpleEnumerator.h"
#include "mozilla/StaticPrefs_extensions.h"
#include "mozilla/dom/ContentChild.h"
#include "mozilla/dom/ContentFrameMessageManager.h"
#include "mozilla/dom/ContentParent.h"
#include "mozilla/dom/Promise.h"
#include "mozilla/dom/Promise-inl.h"
#include "mozIExtensionProcessScript.h"
#include "nsDocShell.h"
#include "nsEscape.h"
#include "nsGkAtoms.h"
#include "nsIChannel.h"
#include "nsIContentPolicy.h"
#include "nsIDocShell.h"
#include "mozilla/dom/Document.h"
#include "nsGlobalWindowOuter.h"
#include "nsILoadInfo.h"
#include "nsIXULRuntime.h"
#include "nsImportModule.h"
#include "nsNetUtil.h"
#include "nsPrintfCString.h"
#include "nsPIDOMWindow.h"
#include "nsXULAppAPI.h"
#include "nsQueryObject.h"

namespace mozilla {

using namespace extensions;

using dom::AutoJSAPI;
using dom::ContentFrameMessageManager;
using dom::Document;
using dom::Promise;

#define BASE_CSP_PREF "extensions.webextensions.base-content-security-policy"
#define DEFAULT_BASE_CSP                                          \
  "script-src 'self' https://* moz-extension: blob: filesystem: " \
  "'unsafe-eval' 'unsafe-inline'; "                               \
  "object-src 'self' https://* moz-extension: blob: filesystem:;"

#define DEFAULT_CSP_PREF \
  "extensions.webextensions.default-content-security-policy"
#define DEFAULT_DEFAULT_CSP "script-src 'self'; object-src 'self';"

#define OBS_TOPIC_PRELOAD_SCRIPT "web-extension-preload-content-script"
#define OBS_TOPIC_LOAD_SCRIPT "web-extension-load-content-script"

static const char kDocElementInserted[] = "initial-document-element-inserted";

static mozIExtensionProcessScript& ProcessScript() {
  static nsCOMPtr<mozIExtensionProcessScript> sProcessScript;

  if (MOZ_UNLIKELY(!sProcessScript)) {
    nsCOMPtr<mozIExtensionProcessScriptJSM> jsm =
        do_ImportModule("resource://gre/modules/ExtensionProcessScript.jsm");
    MOZ_RELEASE_ASSERT(jsm);

    Unused << jsm->GetExtensionProcessScript(getter_AddRefs(sProcessScript));
    MOZ_RELEASE_ASSERT(sProcessScript);
    ClearOnShutdown(&sProcessScript);
  }
  return *sProcessScript;
}

/*****************************************************************************
 * ExtensionPolicyService
 *****************************************************************************/

/* static */ ExtensionPolicyService& ExtensionPolicyService::GetSingleton() {
  static RefPtr<ExtensionPolicyService> sExtensionPolicyService;

  if (MOZ_UNLIKELY(!sExtensionPolicyService)) {
    sExtensionPolicyService = new ExtensionPolicyService();
    RegisterWeakMemoryReporter(sExtensionPolicyService);
    ClearOnShutdown(&sExtensionPolicyService);
  }
  return *sExtensionPolicyService.get();
}

ExtensionPolicyService::ExtensionPolicyService() {
  mObs = services::GetObserverService();
  MOZ_RELEASE_ASSERT(mObs);

  mBaseCSP.SetIsVoid(true);
  mDefaultCSP.SetIsVoid(true);

  RegisterObservers();
}

ExtensionPolicyService::~ExtensionPolicyService() {
  UnregisterWeakMemoryReporter(this);
}

bool ExtensionPolicyService::UseRemoteExtensions() const {
  static Maybe<bool> sRemoteExtensions;
  if (MOZ_UNLIKELY(sRemoteExtensions.isNothing())) {
    sRemoteExtensions = Some(StaticPrefs::extensions_webextensions_remote());
  }
  return sRemoteExtensions.value() && BrowserTabsRemoteAutostart();
}

bool ExtensionPolicyService::IsExtensionProcess() const {
  bool isRemote = UseRemoteExtensions();

  if (isRemote && XRE_IsContentProcess()) {
    auto& remoteType = dom::ContentChild::GetSingleton()->GetRemoteType();
    return remoteType.EqualsLiteral(EXTENSION_REMOTE_TYPE);
  }
  return !isRemote && XRE_IsParentProcess();
}

WebExtensionPolicy* ExtensionPolicyService::GetByURL(const URLInfo& aURL) {
  if (aURL.Scheme() == nsGkAtoms::moz_extension) {
    return GetByHost(aURL.Host());
  }
  return nullptr;
}

void ExtensionPolicyService::GetAll(
    nsTArray<RefPtr<WebExtensionPolicy>>& aResult) {
  for (auto iter = mExtensions.Iter(); !iter.Done(); iter.Next()) {
    aResult.AppendElement(iter.Data());
  }
}

bool ExtensionPolicyService::RegisterExtension(WebExtensionPolicy& aPolicy) {
  bool ok =
      (!GetByID(aPolicy.Id()) && !GetByHost(aPolicy.MozExtensionHostname()));
  MOZ_ASSERT(ok);

  if (!ok) {
    return false;
  }

  mExtensions.Put(aPolicy.Id(), RefPtr{&aPolicy});
  mExtensionHosts.Put(aPolicy.MozExtensionHostname(), RefPtr{&aPolicy});
  return true;
}

bool ExtensionPolicyService::UnregisterExtension(WebExtensionPolicy& aPolicy) {
  bool ok = (GetByID(aPolicy.Id()) == &aPolicy &&
             GetByHost(aPolicy.MozExtensionHostname()) == &aPolicy);
  MOZ_ASSERT(ok);

  if (!ok) {
    return false;
  }

  mExtensions.Remove(aPolicy.Id());
  mExtensionHosts.Remove(aPolicy.MozExtensionHostname());
  return true;
}

bool ExtensionPolicyService::RegisterObserver(DocumentObserver& aObserver) {
  if (mObservers.GetWeak(&aObserver)) {
    return false;
  }

  mObservers.Put(&aObserver, RefPtr{&aObserver});
  return true;
}

bool ExtensionPolicyService::UnregisterObserver(DocumentObserver& aObserver) {
  if (!mObservers.GetWeak(&aObserver)) {
    return false;
  }

  mObservers.Remove(&aObserver);
  return true;
}

/*****************************************************************************
 * nsIMemoryReporter
 *****************************************************************************/

NS_IMETHODIMP
ExtensionPolicyService::CollectReports(nsIHandleReportCallback* aHandleReport,
                                       nsISupports* aData, bool aAnonymize) {
  for (auto iter = mExtensions.Iter(); !iter.Done(); iter.Next()) {
    auto& ext = iter.Data();

    nsAtomCString id(ext->Id());

    NS_ConvertUTF16toUTF8 name(ext->Name());
    name.ReplaceSubstring("\"", "");
    name.ReplaceSubstring("\\", "");

    nsString url;
    MOZ_TRY_VAR(url, ext->GetURL(NS_LITERAL_STRING("")));

    nsPrintfCString desc("Extension(id=%s, name=\"%s\", baseURL=%s)", id.get(),
                         name.get(), NS_ConvertUTF16toUTF8(url).get());
    desc.ReplaceChar('/', '\\');

    nsCString path("extensions/");
    path.Append(desc);

    aHandleReport->Callback(
        EmptyCString(), path, KIND_NONHEAP, UNITS_COUNT, 1,
        NS_LITERAL_CSTRING("WebExtensions that are active in this session"),
        aData);
  }

  return NS_OK;
}

/*****************************************************************************
 * Content script management
 *****************************************************************************/

void ExtensionPolicyService::RegisterObservers() {
  mObs->AddObserver(this, kDocElementInserted, false);
  mObs->AddObserver(this, "tab-content-frameloader-created", false);
  if (XRE_IsContentProcess()) {
    mObs->AddObserver(this, "http-on-opening-request", false);
    mObs->AddObserver(this, "document-on-opening-request", false);
  }

  Preferences::AddStrongObserver(this, BASE_CSP_PREF);
  Preferences::AddStrongObserver(this, DEFAULT_CSP_PREF);
}

void ExtensionPolicyService::UnregisterObservers() {
  mObs->RemoveObserver(this, kDocElementInserted);
  mObs->RemoveObserver(this, "tab-content-frameloader-created");
  if (XRE_IsContentProcess()) {
    mObs->RemoveObserver(this, "http-on-opening-request");
    mObs->RemoveObserver(this, "document-on-opening-request");
  }

  Preferences::RemoveObserver(this, BASE_CSP_PREF);
  Preferences::RemoveObserver(this, DEFAULT_CSP_PREF);
}

nsresult ExtensionPolicyService::Observe(nsISupports* aSubject,
                                         const char* aTopic,
                                         const char16_t* aData) {
  if (!strcmp(aTopic, kDocElementInserted)) {
    nsCOMPtr<Document> doc = do_QueryInterface(aSubject);
    if (doc) {
      CheckDocument(doc);
    }
  } else if (!strcmp(aTopic, "http-on-opening-request") ||
             !strcmp(aTopic, "document-on-opening-request")) {
    nsCOMPtr<nsIChannel> chan = do_QueryInterface(aSubject);
    if (chan) {
      CheckRequest(chan);
    }
  } else if (!strcmp(aTopic, "tab-content-frameloader-created")) {
    RefPtr<ContentFrameMessageManager> mm = do_QueryObject(aSubject);
    NS_ENSURE_TRUE(mm, NS_ERROR_UNEXPECTED);

    mMessageManagers.PutEntry(mm);

    mm->AddSystemEventListener(NS_LITERAL_STRING("unload"), this, false, false);
  } else if (!strcmp(aTopic, NS_PREFBRANCH_PREFCHANGE_TOPIC_ID)) {
    const nsCString converted = NS_ConvertUTF16toUTF8(aData);
    const char* pref = converted.get();
    if (!strcmp(pref, BASE_CSP_PREF)) {
      mBaseCSP.SetIsVoid(true);
    } else if (!strcmp(pref, DEFAULT_CSP_PREF)) {
      mDefaultCSP.SetIsVoid(true);
    }
  }
  return NS_OK;
}

nsresult ExtensionPolicyService::HandleEvent(dom::Event* aEvent) {
  RefPtr<ContentFrameMessageManager> mm = do_QueryObject(aEvent->GetTarget());
  MOZ_ASSERT(mm);
  if (mm) {
    mMessageManagers.RemoveEntry(mm);
  }
  return NS_OK;
}

nsresult ForEachDocShell(
    nsIDocShell* aDocShell,
    const std::function<nsresult(nsIDocShell*)>& aCallback) {
  nsTArray<RefPtr<nsIDocShell>> docShells;
  MOZ_TRY(aDocShell->GetAllDocShellsInSubtree(
      nsIDocShell::typeContent, nsIDocShell::ENUMERATE_FORWARDS, docShells));

  for (auto& docShell : docShells) {
    MOZ_TRY(aCallback(docShell));
  }
  return NS_OK;
}

already_AddRefed<Promise> ExtensionPolicyService::ExecuteContentScript(
    nsPIDOMWindowInner* aWindow, WebExtensionContentScript& aScript) {
  if (!aWindow->IsCurrentInnerWindow()) {
    return nullptr;
  }

  RefPtr<Promise> promise;
  ProcessScript().LoadContentScript(&aScript, aWindow, getter_AddRefs(promise));
  return promise.forget();
}

RefPtr<Promise> ExtensionPolicyService::ExecuteContentScripts(
    JSContext* aCx, nsPIDOMWindowInner* aWindow,
    const nsTArray<RefPtr<WebExtensionContentScript>>& aScripts) {
  AutoTArray<RefPtr<Promise>, 8> promises;

  for (auto& script : aScripts) {
    if (RefPtr<Promise> promise = ExecuteContentScript(aWindow, *script)) {
      promises.AppendElement(std::move(promise));
    }
  }

  RefPtr<Promise> promise = Promise::All(aCx, promises, IgnoreErrors());
  MOZ_RELEASE_ASSERT(promise);
  return promise;
}

nsresult ExtensionPolicyService::InjectContentScripts(
    WebExtensionPolicy* aExtension) {
  AutoJSAPI jsapi;
  MOZ_ALWAYS_TRUE(jsapi.Init(xpc::PrivilegedJunkScope()));

  for (auto iter = mMessageManagers.ConstIter(); !iter.Done(); iter.Next()) {
    ContentFrameMessageManager* mm = iter.Get()->GetKey();

    nsCOMPtr<nsIDocShell> docShell = mm->GetDocShell(IgnoreErrors());
    NS_ENSURE_TRUE(docShell, NS_ERROR_UNEXPECTED);

    auto result =
        ForEachDocShell(docShell, [&](nsIDocShell* aDocShell) -> nsresult {
          nsCOMPtr<nsPIDOMWindowOuter> win = aDocShell->GetWindow();
          if (!win->GetDocumentURI()) {
            return NS_OK;
          }
          DocInfo docInfo(win);

          using RunAt = dom::ContentScriptRunAt;
          namespace RunAtValues = dom::ContentScriptRunAtValues;
          using Scripts = AutoTArray<RefPtr<WebExtensionContentScript>, 8>;

          Scripts scripts[RunAtValues::Count];

          auto GetScripts = [&](RunAt aRunAt) -> Scripts&& {
            static_assert(sizeof(aRunAt) == 1, "Our cast is wrong");
            return std::move(scripts[uint8_t(aRunAt)]);
          };

          for (const auto& script : aExtension->ContentScripts()) {
            if (script->Matches(docInfo)) {
              GetScripts(script->RunAt()).AppendElement(script);
            }
          }

          nsCOMPtr<nsPIDOMWindowInner> inner = win->GetCurrentInnerWindow();

          MOZ_TRY(ExecuteContentScripts(jsapi.cx(), inner,
                                        GetScripts(RunAt::Document_start))
                      ->ThenWithCycleCollectedArgs(
                          [](JSContext* aCx, JS::HandleValue aValue,
                             ExtensionPolicyService* aSelf,
                             nsPIDOMWindowInner* aInner, Scripts&& aScripts) {
                            return aSelf
                                ->ExecuteContentScripts(aCx, aInner, aScripts)
                                .forget();
                          },
                          this, inner, GetScripts(RunAt::Document_end))
                      .andThen([&](auto aPromise) {
                        return aPromise->ThenWithCycleCollectedArgs(
                            [](JSContext* aCx, JS::HandleValue aValue,
                               ExtensionPolicyService* aSelf,
                               nsPIDOMWindowInner* aInner, Scripts&& aScripts) {
                              return aSelf
                                  ->ExecuteContentScripts(aCx, aInner, aScripts)
                                  .forget();
                            },
                            this, inner, GetScripts(RunAt::Document_idle));
                      }));

          return NS_OK;
        });
    MOZ_TRY(result);
  }
  return NS_OK;
}

// Checks a request for matching content scripts, and begins pre-loading them
// if necessary.
void ExtensionPolicyService::CheckRequest(nsIChannel* aChannel) {
  nsCOMPtr<nsILoadInfo> loadInfo = aChannel->LoadInfo();
  auto loadType = loadInfo->GetExternalContentPolicyType();
  if (loadType != nsIContentPolicy::TYPE_DOCUMENT &&
      loadType != nsIContentPolicy::TYPE_SUBDOCUMENT) {
    return;
  }

  nsCOMPtr<nsIURI> uri;
  if (NS_FAILED(aChannel->GetURI(getter_AddRefs(uri)))) {
    return;
  }

  CheckContentScripts({uri.get(), loadInfo}, true);
}

static bool CheckParentFrames(nsPIDOMWindowOuter* aWindow,
                              WebExtensionPolicy& aPolicy) {
  nsCOMPtr<nsIURI> aboutAddons;
  if (NS_FAILED(NS_NewURI(getter_AddRefs(aboutAddons), "about:addons"))) {
    return false;
  }
  nsCOMPtr<nsIURI> htmlAboutAddons;
  if (NS_FAILED(
          NS_NewURI(getter_AddRefs(htmlAboutAddons),
                    "chrome://mozapps/content/extensions/aboutaddons.html"))) {
    return false;
  }

  auto* piWin = aWindow;
  while ((piWin = piWin->GetInProcessScriptableParentOrNull())) {
    auto* win = nsGlobalWindowOuter::Cast(piWin);

    auto* principal = BasePrincipal::Cast(win->GetPrincipal());
    if (principal->IsSystemPrincipal()) {
      // The add-on manager is a special case, since it contains extension
      // options pages in same-type <browser> frames.
      nsIURI* uri = win->GetDocumentURI();
      bool equals;
      if ((NS_SUCCEEDED(uri->Equals(aboutAddons, &equals)) && equals) ||
          (NS_SUCCEEDED(uri->Equals(htmlAboutAddons, &equals)) && equals)) {
        return true;
      }
    }

    if (principal->AddonPolicy() != &aPolicy) {
      return false;
    }
  }

  return true;
}

// Checks a document, just after the document element has been inserted, for
// matching content scripts or extension principals, and loads them if
// necessary.
void ExtensionPolicyService::CheckDocument(Document* aDocument) {
  nsCOMPtr<nsPIDOMWindowOuter> win = aDocument->GetWindow();
  if (win) {
    nsIDocShell* docShell = win->GetDocShell();
    RefPtr<ContentFrameMessageManager> mm = docShell->GetMessageManager();
    if (!mm || !mMessageManagers.Contains(mm)) {
      return;
    }

    if (win->GetDocumentURI()) {
      CheckContentScripts(win.get(), false);
    }

    nsIPrincipal* principal = aDocument->NodePrincipal();

    RefPtr<WebExtensionPolicy> policy =
        BasePrincipal::Cast(principal)->AddonPolicy();
    if (policy) {
      bool privileged = IsExtensionProcess() && CheckParentFrames(win, *policy);

      ProcessScript().InitExtensionDocument(policy, aDocument, privileged);
    }
  }
}

void ExtensionPolicyService::CheckContentScripts(const DocInfo& aDocInfo,
                                                 bool aIsPreload) {
  nsCOMPtr<nsPIDOMWindowInner> win;
  if (!aIsPreload) {
    win = aDocInfo.GetWindow()->GetCurrentInnerWindow();
  }

  nsTArray<RefPtr<WebExtensionContentScript>> scriptsToLoad;

  for (auto iter = mExtensions.Iter(); !iter.Done(); iter.Next()) {
    RefPtr<WebExtensionPolicy> policy = iter.Data();

    for (auto& script : policy->ContentScripts()) {
      if (script->Matches(aDocInfo)) {
        if (aIsPreload) {
          ProcessScript().PreloadContentScript(script);
        } else {
          // Collect the content scripts to load instead of loading them
          // right away (to prevent a loaded content script from being
          // able to invalidate the iterator by triggering a call to
          // policy->UnregisterContentScript while we are still iterating
          // over all its content scripts). See Bug 1593240.
          scriptsToLoad.AppendElement(script);
        }
      }
    }

    for (auto& script : scriptsToLoad) {
      if (!win->IsCurrentInnerWindow()) {
        break;
      }

      RefPtr<Promise> promise;
      ProcessScript().LoadContentScript(script, win, getter_AddRefs(promise));
    }

    scriptsToLoad.ClearAndRetainStorage();
  }

  for (auto iter = mObservers.Iter(); !iter.Done(); iter.Next()) {
    RefPtr<DocumentObserver> observer = iter.Data();

    for (auto& matcher : observer->Matchers()) {
      if (matcher->Matches(aDocInfo)) {
        if (aIsPreload) {
          observer->NotifyMatch(*matcher, aDocInfo.GetLoadInfo());
        } else {
          observer->NotifyMatch(*matcher, aDocInfo.GetWindow());
        }
      }
    }
  }
}

/*****************************************************************************
 * nsIAddonPolicyService
 *****************************************************************************/

nsresult ExtensionPolicyService::GetBaseCSP(nsAString& aBaseCSP) {
  if (mBaseCSP.IsVoid()) {
    nsresult rv = Preferences::GetString(BASE_CSP_PREF, mBaseCSP);
    if (NS_FAILED(rv)) {
      mBaseCSP.AssignLiteral(DEFAULT_BASE_CSP);
    }
    mBaseCSP.SetIsVoid(false);
  }

  aBaseCSP.Assign(mBaseCSP);
  return NS_OK;
}

nsresult ExtensionPolicyService::GetDefaultCSP(nsAString& aDefaultCSP) {
  if (mDefaultCSP.IsVoid()) {
    nsresult rv = Preferences::GetString(DEFAULT_CSP_PREF, mDefaultCSP);
    if (NS_FAILED(rv)) {
      mDefaultCSP.AssignLiteral(DEFAULT_DEFAULT_CSP);
    }
    mDefaultCSP.SetIsVoid(false);
  }

  aDefaultCSP.Assign(mDefaultCSP);
  return NS_OK;
}

nsresult ExtensionPolicyService::GetExtensionPageCSP(const nsAString& aAddonId,
                                                     nsAString& aResult) {
  if (WebExtensionPolicy* policy = GetByID(aAddonId)) {
    policy->GetExtensionPageCSP(aResult);
    return NS_OK;
  }
  return NS_ERROR_INVALID_ARG;
}

nsresult ExtensionPolicyService::GetContentScriptCSP(const nsAString& aAddonId,
                                                     nsAString& aResult) {
  if (WebExtensionPolicy* policy = GetByID(aAddonId)) {
    policy->GetContentScriptCSP(aResult);
    return NS_OK;
  }
  return NS_ERROR_INVALID_ARG;
}

nsresult ExtensionPolicyService::GetGeneratedBackgroundPageUrl(
    const nsACString& aHostname, nsACString& aResult) {
  if (WebExtensionPolicy* policy = GetByHost(aHostname)) {
    nsAutoCString url("data:text/html,");

    nsCString html = policy->BackgroundPageHTML();
    nsAutoCString escaped;

    url.Append(NS_EscapeURL(html, esc_Minimal, escaped));

    aResult = url;
    return NS_OK;
  }
  return NS_ERROR_INVALID_ARG;
}

nsresult ExtensionPolicyService::AddonHasPermission(const nsAString& aAddonId,
                                                    const nsAString& aPerm,
                                                    bool* aResult) {
  if (WebExtensionPolicy* policy = GetByID(aAddonId)) {
    *aResult = policy->HasPermission(aPerm);
    return NS_OK;
  }
  return NS_ERROR_INVALID_ARG;
}

nsresult ExtensionPolicyService::AddonMayLoadURI(const nsAString& aAddonId,
                                                 nsIURI* aURI, bool aExplicit,
                                                 bool* aResult) {
  if (WebExtensionPolicy* policy = GetByID(aAddonId)) {
    *aResult = policy->CanAccessURI(aURI, aExplicit);
    return NS_OK;
  }
  return NS_ERROR_INVALID_ARG;
}

nsresult ExtensionPolicyService::GetExtensionName(const nsAString& aAddonId,
                                                  nsAString& aName) {
  if (WebExtensionPolicy* policy = GetByID(aAddonId)) {
    aName.Assign(policy->Name());
    return NS_OK;
  }
  return NS_ERROR_INVALID_ARG;
}

nsresult ExtensionPolicyService::ExtensionURILoadableByAnyone(nsIURI* aURI,
                                                              bool* aResult) {
  URLInfo url(aURI);
  if (WebExtensionPolicy* policy = GetByURL(url)) {
    *aResult = policy->IsPathWebAccessible(url.FilePath());
    return NS_OK;
  }
  return NS_ERROR_INVALID_ARG;
}

nsresult ExtensionPolicyService::ExtensionURIToAddonId(nsIURI* aURI,
                                                       nsAString& aResult) {
  if (WebExtensionPolicy* policy = GetByURL(aURI)) {
    policy->GetId(aResult);
  } else {
    aResult.SetIsVoid(true);
  }
  return NS_OK;
}

NS_IMPL_CYCLE_COLLECTION(ExtensionPolicyService, mExtensions, mExtensionHosts,
                         mObservers)

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(ExtensionPolicyService)
  NS_INTERFACE_MAP_ENTRY(nsIAddonPolicyService)
  NS_INTERFACE_MAP_ENTRY(nsIObserver)
  NS_INTERFACE_MAP_ENTRY(nsIDOMEventListener)
  NS_INTERFACE_MAP_ENTRY(nsIMemoryReporter)
  NS_INTERFACE_MAP_ENTRY_AMBIGUOUS(nsISupports, nsIAddonPolicyService)
NS_INTERFACE_MAP_END

NS_IMPL_CYCLE_COLLECTING_ADDREF(ExtensionPolicyService)
NS_IMPL_CYCLE_COLLECTING_RELEASE(ExtensionPolicyService)

}  // namespace mozilla
