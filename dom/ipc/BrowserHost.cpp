/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/dom/BrowserHost.h"

#include "mozilla/Unused.h"
#include "mozilla/dom/CancelContentJSOptionsBinding.h"
#include "mozilla/dom/WindowGlobalParent.h"

#include "nsIObserverService.h"

namespace mozilla {
namespace dom {

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(BrowserHost)
  NS_INTERFACE_MAP_ENTRY(nsIRemoteTab)
  NS_INTERFACE_MAP_ENTRY(nsISupportsWeakReference)
  NS_INTERFACE_MAP_ENTRY_AMBIGUOUS(nsISupports, RemoteBrowser)
NS_INTERFACE_MAP_END

NS_IMPL_CYCLE_COLLECTION_WEAK(BrowserHost, mRoot)

NS_IMPL_CYCLE_COLLECTING_ADDREF(BrowserHost)
NS_IMPL_CYCLE_COLLECTING_RELEASE(BrowserHost)

BrowserHost::BrowserHost(BrowserParent* aParent)
    : mId(aParent->GetTabId()),
      mRoot(aParent),
      mEffectsInfo{EffectsInfo::FullyHidden()} {
  mRoot->SetBrowserHost(this);
}

BrowserHost* BrowserHost::GetFrom(nsIRemoteTab* aRemoteTab) {
  return static_cast<BrowserHost*>(aRemoteTab);
}

TabId BrowserHost::GetTabId() const { return mId; }

mozilla::layers::LayersId BrowserHost::GetLayersId() const {
  return mRoot->GetLayersId();
}

BrowsingContext* BrowserHost::GetBrowsingContext() const {
  return mRoot->GetBrowsingContext();
}

nsILoadContext* BrowserHost::GetLoadContext() const {
  RefPtr<nsILoadContext> loadContext = mRoot->GetLoadContext();
  return loadContext;
}

a11y::DocAccessibleParent* BrowserHost::GetTopLevelDocAccessible() const {
  return mRoot->GetTopLevelDocAccessible();
}

void BrowserHost::LoadURL(nsIURI* aURI, nsIPrincipal* aTriggeringPrincipal) {
  MOZ_ASSERT(aURI);
  MOZ_ASSERT(aTriggeringPrincipal);

  mRoot->LoadURL(aURI, aTriggeringPrincipal);
}

void BrowserHost::ResumeLoad(uint64_t aPendingSwitchId) {
  mRoot->ResumeLoad(aPendingSwitchId);
}

void BrowserHost::DestroyStart() { mRoot->Destroy(); }

void BrowserHost::DestroyComplete() {
  if (!mRoot) {
    return;
  }
  mRoot->SetOwnerElement(nullptr);
  mRoot->Destroy();
  mRoot->SetBrowserHost(nullptr);
  mRoot = nullptr;

  nsCOMPtr<nsIObserverService> os = services::GetObserverService();
  if (os) {
    os->NotifyObservers(NS_ISUPPORTS_CAST(nsIRemoteTab*, this),
                        "ipc:browser-destroyed", nullptr);
  }
}

bool BrowserHost::Show(const OwnerShowInfo& aShowInfo) {
  return mRoot->Show(aShowInfo);
}

void BrowserHost::UpdateDimensions(const nsIntRect& aRect,
                                   const ScreenIntSize& aSize) {
  mRoot->UpdateDimensions(aRect, aSize);
}

void BrowserHost::UpdateEffects(EffectsInfo aEffects) {
  if (!mRoot || mEffectsInfo == aEffects) {
    return;
  }
  mEffectsInfo = aEffects;
  Unused << mRoot->SendUpdateEffects(mEffectsInfo);
}

/* attribute boolean suspendMediaWhenInactive; */
NS_IMETHODIMP
BrowserHost::GetSuspendMediaWhenInactive(bool* aSuspendMediaWhenInactive) {
  if (!mRoot) {
    *aSuspendMediaWhenInactive = false;
    return NS_OK;
  }
  *aSuspendMediaWhenInactive = mRoot->GetSuspendMediaWhenInactive();
  return NS_OK;
}

NS_IMETHODIMP
BrowserHost::SetSuspendMediaWhenInactive(bool aSuspendMediaWhenInactive) {
  if (!mRoot) {
    return NS_OK;
  }
  VisitAll([&](BrowserParent* aBrowserParent) {
    aBrowserParent->SetSuspendMediaWhenInactive(aSuspendMediaWhenInactive);
  });
  return NS_OK;
}

/* attribute boolean docShellIsActive; */
NS_IMETHODIMP
BrowserHost::GetDocShellIsActive(bool* aDocShellIsActive) {
  if (!mRoot) {
    *aDocShellIsActive = false;
    return NS_OK;
  }
  *aDocShellIsActive = mRoot->GetDocShellIsActive();
  return NS_OK;
}

NS_IMETHODIMP
BrowserHost::SetDocShellIsActive(bool aDocShellIsActive) {
  if (!mRoot) {
    return NS_OK;
  }
  VisitAll([&](BrowserParent* aBrowserParent) {
    aBrowserParent->SetDocShellIsActive(aDocShellIsActive);
  });
  return NS_OK;
}

/* attribute boolean renderLayers; */
NS_IMETHODIMP
BrowserHost::GetRenderLayers(bool* aRenderLayers) {
  if (!mRoot) {
    *aRenderLayers = false;
    return NS_OK;
  }
  *aRenderLayers = mRoot->GetRenderLayers();
  return NS_OK;
}

NS_IMETHODIMP
BrowserHost::SetRenderLayers(bool aRenderLayers) {
  if (!mRoot) {
    return NS_OK;
  }
  mRoot->SetRenderLayers(aRenderLayers);
  return NS_OK;
}

/* readonly attribute boolean hasLayers; */
NS_IMETHODIMP
BrowserHost::GetHasLayers(bool* aHasLayers) {
  if (!mRoot) {
    *aHasLayers = false;
    return NS_OK;
  }
  *aHasLayers = mRoot->GetHasLayers();
  return NS_OK;
}

/* void resolutionChanged (); */
NS_IMETHODIMP
BrowserHost::NotifyResolutionChanged(void) {
  if (!mRoot) {
    return NS_OK;
  }
  VisitAll([](BrowserParent* aBrowserParent) {
    aBrowserParent->NotifyResolutionChanged();
  });
  return NS_OK;
}

/* void deprioritize (); */
NS_IMETHODIMP
BrowserHost::Deprioritize(void) {
  if (!mRoot) {
    return NS_OK;
  }
  VisitAll(
      [](BrowserParent* aBrowserParent) { aBrowserParent->Deprioritize(); });
  return NS_OK;
}

/* void preserveLayers (in boolean aPreserveLayers); */
NS_IMETHODIMP
BrowserHost::PreserveLayers(bool aPreserveLayers) {
  if (!mRoot) {
    return NS_OK;
  }
  VisitAll([&](BrowserParent* aBrowserParent) {
    aBrowserParent->PreserveLayers(aPreserveLayers);
  });
  return NS_OK;
}

/* readonly attribute uint64_t tabId; */
NS_IMETHODIMP
BrowserHost::GetTabId(uint64_t* aTabId) {
  *aTabId = mId;
  return NS_OK;
}

/* readonly attribute uint64_t contentProcessId; */
NS_IMETHODIMP
BrowserHost::GetContentProcessId(uint64_t* aContentProcessId) {
  if (!mRoot) {
    *aContentProcessId = 0;
    return NS_OK;
  }
  *aContentProcessId = GetContentParent()->ChildID();
  return NS_OK;
}

/* readonly attribute int32_t osPid; */
NS_IMETHODIMP
BrowserHost::GetOsPid(int32_t* aOsPid) {
  if (!mRoot) {
    *aOsPid = 0;
    return NS_OK;
  }
  *aOsPid = GetContentParent()->Pid();
  return NS_OK;
}

/* readonly attribute boolean hasPresented; */
NS_IMETHODIMP
BrowserHost::GetHasPresented(bool* aHasPresented) {
  if (!mRoot) {
    *aHasPresented = false;
    return NS_OK;
  }
  *aHasPresented = mRoot->GetHasPresented();
  return NS_OK;
}

/* void transmitPermissionsForPrincipal (in nsIPrincipal aPrincipal); */
NS_IMETHODIMP
BrowserHost::TransmitPermissionsForPrincipal(nsIPrincipal* aPrincipal) {
  if (!mRoot) {
    return NS_OK;
  }
  return GetContentParent()->TransmitPermissionsForPrincipal(aPrincipal);
}

/* readonly attribute boolean hasBeforeUnload; */
NS_IMETHODIMP
BrowserHost::GetHasBeforeUnload(bool* aHasBeforeUnload) {
  if (!mRoot || !GetBrowsingContext()) {
    *aHasBeforeUnload = false;
    return NS_OK;
  }

  bool result = false;

  GetBrowsingContext()->PreOrderWalk(
      [&result](BrowsingContext* aBrowsingContext) {
        WindowGlobalParent* windowGlobal =
            aBrowsingContext->Canonical()->GetCurrentWindowGlobal();

        if (windowGlobal) {
          result |= windowGlobal->HasBeforeUnload();
        }
      });

  *aHasBeforeUnload = result;
  return NS_OK;
}

/* boolean startApzAutoscroll (in float aAnchorX, in float aAnchorY, in nsViewID
 * aScrollId, in uint32_t aPresShellId); */
NS_IMETHODIMP
BrowserHost::StartApzAutoscroll(float aAnchorX, float aAnchorY,
                                nsViewID aScrollId, uint32_t aPresShellId,
                                bool* _retval) {
  if (!mRoot) {
    return NS_OK;
  }
  *_retval =
      mRoot->StartApzAutoscroll(aAnchorX, aAnchorY, aScrollId, aPresShellId);
  return NS_OK;
}

/* void stopApzAutoscroll (in nsViewID aScrollId, in uint32_t aPresShellId); */
NS_IMETHODIMP
BrowserHost::StopApzAutoscroll(nsViewID aScrollId, uint32_t aPresShellId) {
  if (!mRoot) {
    return NS_OK;
  }
  mRoot->StopApzAutoscroll(aScrollId, aPresShellId);
  return NS_OK;
}

NS_IMETHODIMP
BrowserHost::MaybeCancelContentJSExecutionFromScript(
    nsIRemoteTab::NavigationType aNavigationType,
    JS::Handle<JS::Value> aCancelContentJSOptions, JSContext* aCx) {
  // If we're in the process of creating a new window (via window.open), then
  // the load that called this function isn't a "normal" load and should be
  // ignored for the purposes of cancelling content JS.
  if (!mRoot || mRoot->CreatingWindow()) {
    return NS_OK;
  }
  dom::CancelContentJSOptions cancelContentJSOptions;
  if (!cancelContentJSOptions.Init(aCx, aCancelContentJSOptions)) {
    return NS_ERROR_INVALID_ARG;
  }
  if (StaticPrefs::dom_ipc_cancel_content_js_when_navigating()) {
    GetContentParent()->CancelContentJSExecutionIfRunning(
        mRoot, aNavigationType, cancelContentJSOptions);
  }
  return NS_OK;
}

}  // namespace dom
}  // namespace mozilla
