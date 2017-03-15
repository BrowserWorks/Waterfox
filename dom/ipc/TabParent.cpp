/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "base/basictypes.h"

#include "TabParent.h"

#include "AudioChannelService.h"
#include "AppProcessChecker.h"
#include "mozIApplication.h"
#ifdef ACCESSIBILITY
#include "mozilla/a11y/DocAccessibleParent.h"
#include "nsAccessibilityService.h"
#endif
#include "mozilla/BrowserElementParent.h"
#include "mozilla/dom/ContentBridgeParent.h"
#include "mozilla/dom/ContentParent.h"
#include "mozilla/dom/DataTransfer.h"
#include "mozilla/dom/Event.h"
#include "mozilla/dom/indexedDB/ActorsParent.h"
#include "mozilla/plugins/PluginWidgetParent.h"
#include "mozilla/EventStateManager.h"
#include "mozilla/gfx/2D.h"
#include "mozilla/gfx/DataSurfaceHelpers.h"
#include "mozilla/gfx/GPUProcessManager.h"
#include "mozilla/Hal.h"
#include "mozilla/IMEStateManager.h"
#include "mozilla/ipc/DocumentRendererParent.h"
#include "mozilla/jsipc/CrossProcessObjectWrappers.h"
#include "mozilla/layers/AsyncDragMetrics.h"
#include "mozilla/layers/InputAPZContext.h"
#include "mozilla/layout/RenderFrameParent.h"
#include "mozilla/LookAndFeel.h"
#include "mozilla/MouseEvents.h"
#include "mozilla/net/NeckoChild.h"
#include "mozilla/Preferences.h"
#include "mozilla/TextEvents.h"
#include "mozilla/TouchEvents.h"
#include "mozilla/UniquePtr.h"
#include "mozilla/Unused.h"
#include "BlobParent.h"
#include "nsCOMPtr.h"
#include "nsContentAreaDragDrop.h"
#include "nsContentUtils.h"
#include "nsDebug.h"
#include "nsFocusManager.h"
#include "nsFrameLoader.h"
#include "nsIBaseWindow.h"
#include "nsIBrowser.h"
#include "nsIContent.h"
#include "nsIDocShell.h"
#include "nsIDocShellTreeOwner.h"
#include "nsIDOMElement.h"
#include "nsIDOMEvent.h"
#include "nsIDOMWindow.h"
#include "nsIDOMWindowUtils.h"
#include "nsIInterfaceRequestorUtils.h"
#include "nsILoadInfo.h"
#include "nsPrincipal.h"
#include "nsIPromptFactory.h"
#include "nsIURI.h"
#include "nsIWindowWatcher.h"
#include "nsIWebBrowserChrome.h"
#include "nsIXULBrowserWindow.h"
#include "nsIXULWindow.h"
#include "nsIRemoteBrowser.h"
#include "nsViewManager.h"
#include "nsVariant.h"
#include "nsIWidget.h"
#ifndef XP_WIN
#include "nsJARProtocolHandler.h"
#endif
#include "nsPIDOMWindow.h"
#include "nsPresShell.h"
#include "nsPrintfCString.h"
#include "nsServiceManagerUtils.h"
#include "nsThreadUtils.h"
#include "PermissionMessageUtils.h"
#include "StructuredCloneData.h"
#include "ColorPickerParent.h"
#include "DatePickerParent.h"
#include "FilePickerParent.h"
#include "TabChild.h"
#include "LoadContext.h"
#include "nsNetCID.h"
#include "nsIAuthInformation.h"
#include "nsIAuthPromptCallback.h"
#include "nsAuthInformationHolder.h"
#include "nsICancelable.h"
#include "gfxPrefs.h"
#include "nsILoginManagerPrompter.h"
#include "nsPIWindowRoot.h"
#include "nsIAuthPrompt2.h"
#include "gfxDrawable.h"
#include "ImageOps.h"
#include "UnitTransforms.h"
#include <algorithm>
#include "mozilla/WebBrowserPersistDocumentParent.h"
#include "nsIGroupedSHistory.h"
#include "PartialSHistory.h"

#if defined(XP_WIN) && defined(ACCESSIBILITY)
#include "mozilla/a11y/AccessibleWrap.h"
#endif

using namespace mozilla::dom;
using namespace mozilla::ipc;
using namespace mozilla::layers;
using namespace mozilla::layout;
using namespace mozilla::services;
using namespace mozilla::widget;
using namespace mozilla::jsipc;
using namespace mozilla::gfx;

using mozilla::Unused;

// The flags passed by the webProgress notifications are 16 bits shifted
// from the ones registered by webProgressListeners.
#define NOTIFY_FLAG_SHIFT 16

namespace mozilla {
namespace dom {

TabParent::LayerToTabParentTable* TabParent::sLayerToTabParentTable = nullptr;

NS_IMPL_ISUPPORTS(TabParent,
                  nsITabParent,
                  nsIAuthPromptProvider,
                  nsISecureBrowserUI,
                  nsISupportsWeakReference,
                  nsIWebBrowserPersistable)

TabParent::TabParent(nsIContentParent* aManager,
                     const TabId& aTabId,
                     const TabContext& aContext,
                     uint32_t aChromeFlags)
  : TabContext(aContext)
  , mFrameElement(nullptr)
  , mRect(0, 0, 0, 0)
  , mDimensions(0, 0)
  , mOrientation(0)
  , mDPI(0)
  , mRounding(0)
  , mDefaultScale(0)
  , mUpdatedDimensions(false)
  , mSizeMode(nsSizeMode_Normal)
  , mManager(aManager)
  , mDocShellIsActive(false)
  , mMarkedDestroying(false)
  , mIsDestroyed(false)
  , mChromeFlags(aChromeFlags)
  , mDragValid(false)
  , mInitedByParent(false)
  , mTabId(aTabId)
  , mCreatingWindow(false)
  , mCursor(nsCursor(-1))
  , mTabSetsCursor(false)
  , mHasContentOpener(false)
#ifdef DEBUG
  , mActiveSupressDisplayportCount(0)
#endif
  , mLayerTreeEpoch(0)
  , mPreserveLayers(false)
{
  MOZ_ASSERT(aManager);
}

TabParent::~TabParent()
{
}

TabParent*
TabParent::GetTabParentFromLayersId(uint64_t aLayersId)
{
  if (!sLayerToTabParentTable) {
    return nullptr;
  }
  return sLayerToTabParentTable->Get(aLayersId);
}

void
TabParent::AddTabParentToTable(uint64_t aLayersId, TabParent* aTabParent)
{
  if (!sLayerToTabParentTable) {
    sLayerToTabParentTable = new LayerToTabParentTable();
  }
  sLayerToTabParentTable->Put(aLayersId, aTabParent);
}

void
TabParent::RemoveTabParentFromTable(uint64_t aLayersId)
{
  if (!sLayerToTabParentTable) {
    return;
  }
  sLayerToTabParentTable->Remove(aLayersId);
  if (sLayerToTabParentTable->Count() == 0) {
    delete sLayerToTabParentTable;
    sLayerToTabParentTable = nullptr;
  }
}

void
TabParent::CacheFrameLoader(nsFrameLoader* aFrameLoader)
{
  mFrameLoader = aFrameLoader;
}

/**
 * Will return nullptr if there is no outer window available for the
 * document hosting the owner element of this TabParent. Also will return
 * nullptr if that outer window is in the process of closing.
 */
already_AddRefed<nsPIDOMWindowOuter>
TabParent::GetParentWindowOuter()
{
  nsCOMPtr<nsIContent> frame = do_QueryInterface(GetOwnerElement());
  if (!frame) {
    return nullptr;
  }

  nsCOMPtr<nsPIDOMWindowOuter> parent = frame->OwnerDoc()->GetWindow();
  if (!parent || parent->Closed()) {
    return nullptr;
  }

  return parent.forget();
}

void
TabParent::SetOwnerElement(Element* aElement)
{
  // If we held previous content then unregister for its events.
  RemoveWindowListeners();

  // If we change top-level documents then we need to change our
  // registration with them.
  RefPtr<nsPIWindowRoot> curTopLevelWin, newTopLevelWin;
  if (mFrameElement) {
    curTopLevelWin = nsContentUtils::GetWindowRoot(mFrameElement->OwnerDoc());
  }
  if (aElement) {
    newTopLevelWin = nsContentUtils::GetWindowRoot(aElement->OwnerDoc());
  }
  bool isSameTopLevelWin = curTopLevelWin == newTopLevelWin;
  if (curTopLevelWin && !isSameTopLevelWin) {
    curTopLevelWin->RemoveBrowser(this);
  }

  // Update to the new content, and register to listen for events from it.
  mFrameElement = aElement;

  if (newTopLevelWin && !isSameTopLevelWin) {
    newTopLevelWin->AddBrowser(this);
  }

  if (mFrameElement) {
    bool useGlobalHistory =
      !mFrameElement->HasAttr(kNameSpaceID_None, nsGkAtoms::disableglobalhistory);
    Unused << SendSetUseGlobalHistory(useGlobalHistory);
  }

#if defined(XP_WIN) && defined(ACCESSIBILITY)
  if (!mIsDestroyed) {
    uintptr_t newWindowHandle = 0;
    if (nsCOMPtr<nsIWidget> widget = GetWidget()) {
      newWindowHandle =
        reinterpret_cast<uintptr_t>(widget->GetNativeData(NS_NATIVE_WINDOW));
    }
    Unused << SendUpdateNativeWindowHandle(newWindowHandle);
  }
#endif

  AddWindowListeners();
  TryCacheDPIAndScale();
}

void
TabParent::AddWindowListeners()
{
  if (mFrameElement && mFrameElement->OwnerDoc()) {
    if (nsCOMPtr<nsPIDOMWindowOuter> window = mFrameElement->OwnerDoc()->GetWindow()) {
      nsCOMPtr<EventTarget> eventTarget = window->GetTopWindowRoot();
      if (eventTarget) {
        eventTarget->AddEventListener(NS_LITERAL_STRING("MozUpdateWindowPos"),
                                      this, false, false);
      }
    }
    if (nsIPresShell* shell = mFrameElement->OwnerDoc()->GetShell()) {
      mPresShellWithRefreshListener = shell;
      shell->AddPostRefreshObserver(this);
    }

    RefPtr<AudioChannelService> acs = AudioChannelService::GetOrCreate();
    if (acs) {
      acs->RegisterTabParent(this);
    }
  }
}

void
TabParent::RemoveWindowListeners()
{
  if (mFrameElement && mFrameElement->OwnerDoc()->GetWindow()) {
    nsCOMPtr<nsPIDOMWindowOuter> window = mFrameElement->OwnerDoc()->GetWindow();
    nsCOMPtr<EventTarget> eventTarget = window->GetTopWindowRoot();
    if (eventTarget) {
      eventTarget->RemoveEventListener(NS_LITERAL_STRING("MozUpdateWindowPos"),
                                       this, false);
    }
  }
  if (mPresShellWithRefreshListener) {
    mPresShellWithRefreshListener->RemovePostRefreshObserver(this);
    mPresShellWithRefreshListener = nullptr;
  }

  RefPtr<AudioChannelService> acs = AudioChannelService::GetOrCreate();
  if (acs) {
    acs->UnregisterTabParent(this);
  }
}

void
TabParent::DidRefresh()
{
  if (mChromeOffset != -GetChildProcessOffset()) {
    UpdatePosition();
  }
}

void
TabParent::GetAppType(nsAString& aOut)
{
  aOut.Truncate();
  nsCOMPtr<Element> elem = do_QueryInterface(mFrameElement);
  if (!elem) {
    return;
  }

  elem->GetAttr(kNameSpaceID_None, nsGkAtoms::mozapptype, aOut);
}

bool
TabParent::IsVisible() const
{
  RefPtr<nsFrameLoader> frameLoader = GetFrameLoader();
  if (!frameLoader) {
    return false;
  }

  return frameLoader->GetVisible();
}

void
TabParent::DestroyInternal()
{
  IMEStateManager::OnTabParentDestroying(this);

  RemoveWindowListeners();

  // If this fails, it's most likely due to a content-process crash,
  // and auto-cleanup will kick in.  Otherwise, the child side will
  // destroy itself and send back __delete__().
  Unused << SendDestroy();

  if (RenderFrameParent* frame = GetRenderFrame()) {
    RemoveTabParentFromTable(frame->GetLayersId());
    frame->Destroy();
  }

  // Let all PluginWidgets know we are tearing down. Prevents
  // these objects from sending async events after the child side
  // is shut down.
  const ManagedContainer<PPluginWidgetParent>& kids =
    ManagedPPluginWidgetParent();
  for (auto iter = kids.ConstIter(); !iter.Done(); iter.Next()) {
    static_cast<mozilla::plugins::PluginWidgetParent*>(
       iter.Get()->GetKey())->ParentDestroy();
  }
}

void
TabParent::Destroy()
{
  // Aggressively release the window to avoid leaking the world in shutdown
  // corner cases.
  mBrowserDOMWindow = nullptr;

  if (mIsDestroyed) {
    return;
  }

  DestroyInternal();

  mIsDestroyed = true;

  if (XRE_IsParentProcess()) {
    ContentParent::NotifyTabDestroying(this->GetTabId(), Manager()->AsContentParent()->ChildID());
  } else {
    ContentParent::NotifyTabDestroying(this->GetTabId(), Manager()->ChildID());
  }

  mMarkedDestroying = true;
}

bool
TabParent::RecvEnsureLayersConnected()
{
  if (RenderFrameParent* frame = GetRenderFrame()) {
    frame->EnsureLayersConnected();
  }
  return true;
}

bool
TabParent::Recv__delete__()
{
  if (XRE_IsParentProcess()) {
    ContentParent::DeallocateTabId(mTabId,
                                   Manager()->AsContentParent()->ChildID(),
                                   mMarkedDestroying);
  }
  else {
    Manager()->AsContentBridgeParent()->NotifyTabDestroyed();
    ContentParent::DeallocateTabId(mTabId,
                                   Manager()->ChildID(),
                                   mMarkedDestroying);
  }

  return true;
}

void
TabParent::ActorDestroy(ActorDestroyReason why)
{
  // Even though TabParent::Destroy calls this, we need to do it here too in
  // case of a crash.
  IMEStateManager::OnTabParentDestroying(this);

  // Prevent executing ContentParent::NotifyTabDestroying in
  // TabParent::Destroy() called by frameLoader->DestroyComplete() below
  // when tab crashes in contentprocess because ContentParent::ActorDestroy()
  // in main process will be triggered before this function
  // and remove the process information that
  // ContentParent::NotifyTabDestroying need from mContentParentMap.

  // When tab crashes in content process,
  // there is no need to call ContentParent::NotifyTabDestroying
  // because the jobs in ContentParent::NotifyTabDestroying
  // will be done by ContentParent::ActorDestroy.
  if (XRE_IsContentProcess() && why == AbnormalShutdown && !mIsDestroyed) {
    DestroyInternal();
    mIsDestroyed = true;
  }

  RefPtr<nsFrameLoader> frameLoader = GetFrameLoader(true);
  nsCOMPtr<nsIObserverService> os = services::GetObserverService();
  if (frameLoader) {
    nsCOMPtr<Element> frameElement(mFrameElement);
    ReceiveMessage(CHILD_PROCESS_SHUTDOWN_MESSAGE, false, nullptr, nullptr,
                   nullptr);
    frameLoader->DestroyComplete();

    if (why == AbnormalShutdown && os) {
      os->NotifyObservers(NS_ISUPPORTS_CAST(nsIFrameLoader*, frameLoader),
                          "oop-frameloader-crashed", nullptr);
      nsCOMPtr<nsIFrameLoaderOwner> owner = do_QueryInterface(frameElement);
      if (owner) {
        RefPtr<nsFrameLoader> currentFrameLoader = owner->GetFrameLoader();
        // It's possible that the frameloader owner has already moved on
        // and created a new frameloader. If so, we don't fire the event,
        // since the frameloader owner has clearly moved on.
        if (currentFrameLoader == frameLoader) {
          nsContentUtils::DispatchTrustedEvent(frameElement->OwnerDoc(), frameElement,
                                               NS_LITERAL_STRING("oop-browser-crashed"),
                                               true, true);

        }
      }
    }

    mFrameLoader = nullptr;
  }

  if (os) {
    os->NotifyObservers(NS_ISUPPORTS_CAST(nsITabParent*, this), "ipc:browser-destroyed", nullptr);
  }
}

bool
TabParent::RecvMoveFocus(const bool& aForward, const bool& aForDocumentNavigation)
{
  nsCOMPtr<nsIFocusManager> fm = do_GetService(FOCUSMANAGER_CONTRACTID);
  if (fm) {
    nsCOMPtr<nsIDOMElement> dummy;

    uint32_t type = aForward ?
      (aForDocumentNavigation ? static_cast<uint32_t>(nsIFocusManager::MOVEFOCUS_FORWARDDOC) :
                                static_cast<uint32_t>(nsIFocusManager::MOVEFOCUS_FORWARD)) :
      (aForDocumentNavigation ? static_cast<uint32_t>(nsIFocusManager::MOVEFOCUS_BACKWARDDOC) :
                                static_cast<uint32_t>(nsIFocusManager::MOVEFOCUS_BACKWARD));
    nsCOMPtr<nsIDOMElement> frame = do_QueryInterface(mFrameElement);
    fm->MoveFocus(nullptr, frame, type, nsIFocusManager::FLAG_BYKEY,
                  getter_AddRefs(dummy));
  }
  return true;
}

bool
TabParent::RecvSizeShellTo(const uint32_t& aFlags, const int32_t& aWidth, const int32_t& aHeight,
                           const int32_t& aShellItemWidth, const int32_t& aShellItemHeight)
{
  NS_ENSURE_TRUE(mFrameElement, true);

  nsCOMPtr<nsIDocShell> docShell = mFrameElement->OwnerDoc()->GetDocShell();
  NS_ENSURE_TRUE(docShell, true);

  nsCOMPtr<nsIDocShellTreeOwner> treeOwner;
  nsresult rv = docShell->GetTreeOwner(getter_AddRefs(treeOwner));
  NS_ENSURE_SUCCESS(rv, true);

  int32_t width = aWidth;
  int32_t height = aHeight;

  if (aFlags & nsIEmbeddingSiteWindow::DIM_FLAGS_IGNORE_CX) {
    width = mDimensions.width;
  }

  if (aFlags & nsIEmbeddingSiteWindow::DIM_FLAGS_IGNORE_CY) {
    height = mDimensions.height;
  }

  nsCOMPtr<nsIXULWindow> xulWin(do_GetInterface(treeOwner));
  NS_ENSURE_TRUE(xulWin, true);
  xulWin->SizeShellToWithLimit(width, height, aShellItemWidth, aShellItemHeight);

  return true;
}

bool
TabParent::RecvDropLinks(nsTArray<nsString>&& aLinks)
{
  nsCOMPtr<nsIBrowser> browser = do_QueryInterface(mFrameElement);
  if (browser) {
    UniquePtr<const char16_t*[]> links;
    links = MakeUnique<const char16_t*[]>(aLinks.Length());
    for (uint32_t i = 0; i < aLinks.Length(); i++) {
      links[i] = aLinks[i].get();
    }
    browser->DropLinks(aLinks.Length(), links.get());
  }
  return true;
}

bool
TabParent::RecvEvent(const RemoteDOMEvent& aEvent)
{
  nsCOMPtr<nsIDOMEvent> event = do_QueryInterface(aEvent.mEvent);
  NS_ENSURE_TRUE(event, true);

  nsCOMPtr<mozilla::dom::EventTarget> target = do_QueryInterface(mFrameElement);
  NS_ENSURE_TRUE(target, true);

  event->SetOwner(target);

  bool dummy;
  target->DispatchEvent(event, &dummy);
  return true;
}

TabParent* TabParent::sNextTabParent;

/* static */ TabParent*
TabParent::GetNextTabParent()
{
  TabParent* result = sNextTabParent;
  sNextTabParent = nullptr;
  return result;
}

bool
TabParent::SendLoadRemoteScript(const nsString& aURL,
                                const bool& aRunInGlobalScope)
{
  if (mCreatingWindow) {
    mDelayedFrameScripts.AppendElement(FrameScriptInfo(aURL, aRunInGlobalScope));
    return true;
  }

  MOZ_ASSERT(mDelayedFrameScripts.IsEmpty());
  return PBrowserParent::SendLoadRemoteScript(aURL, aRunInGlobalScope);
}

void
TabParent::LoadURL(nsIURI* aURI)
{
    MOZ_ASSERT(aURI);

    if (mIsDestroyed) {
        return;
    }

    nsCString spec;
    aURI->GetSpec(spec);

    if (mCreatingWindow) {
        // Don't send the message if the child wants to load its own URL.
        MOZ_ASSERT(mDelayedURL.IsEmpty());
        mDelayedURL = spec;
        return;
    }

    Unused << SendLoadURL(spec, GetShowInfo());
}

void
TabParent::Show(const ScreenIntSize& size, bool aParentIsActive)
{
    mDimensions = size;
    if (mIsDestroyed) {
        return;
    }

    TextureFactoryIdentifier textureFactoryIdentifier;
    uint64_t layersId = 0;
    bool success = false;
    RenderFrameParent* renderFrame = nullptr;
    if (IsInitedByParent()) {
        // If TabParent is initialized by parent side then the RenderFrame must also
        // be created here. If TabParent is initialized by child side,
        // child side will create RenderFrame.
        MOZ_ASSERT(!GetRenderFrame());
        RefPtr<nsFrameLoader> frameLoader = GetFrameLoader();
        if (frameLoader) {
          renderFrame = new RenderFrameParent(frameLoader, &success);
          MOZ_ASSERT(success);
          layersId = renderFrame->GetLayersId();
          renderFrame->GetTextureFactoryIdentifier(&textureFactoryIdentifier);
          AddTabParentToTable(layersId, this);
          Unused << SendPRenderFrameConstructor(renderFrame);
        }
    } else {
      // Otherwise, the child should have constructed the RenderFrame,
      // and we should already know about it.
      MOZ_ASSERT(GetRenderFrame());
    }

    nsCOMPtr<nsISupports> container = mFrameElement->OwnerDoc()->GetContainer();
    nsCOMPtr<nsIBaseWindow> baseWindow = do_QueryInterface(container);
    nsCOMPtr<nsIWidget> mainWidget;
    baseWindow->GetMainWidget(getter_AddRefs(mainWidget));
    mSizeMode = mainWidget ? mainWidget->SizeMode() : nsSizeMode_Normal;

    Unused << SendShow(size, GetShowInfo(), textureFactoryIdentifier,
                       layersId, renderFrame, aParentIsActive, mSizeMode);
}

bool
TabParent::RecvSetDimensions(const uint32_t& aFlags,
                             const int32_t& aX, const int32_t& aY,
                             const int32_t& aCx, const int32_t& aCy)
{
  MOZ_ASSERT(!(aFlags & nsIEmbeddingSiteWindow::DIM_FLAGS_SIZE_INNER),
             "We should never see DIM_FLAGS_SIZE_INNER here!");

  NS_ENSURE_TRUE(mFrameElement, true);
  nsCOMPtr<nsIDocShell> docShell = mFrameElement->OwnerDoc()->GetDocShell();
  NS_ENSURE_TRUE(docShell, true);
  nsCOMPtr<nsIDocShellTreeOwner> treeOwner;
  docShell->GetTreeOwner(getter_AddRefs(treeOwner));
  nsCOMPtr<nsIBaseWindow> treeOwnerAsWin = do_QueryInterface(treeOwner);
  NS_ENSURE_TRUE(treeOwnerAsWin, true);

  // We only care about the parameters that actually changed, see more
  // details in TabChild::SetDimensions.
  int32_t unused;
  int32_t x = aX;
  if (aFlags & nsIEmbeddingSiteWindow::DIM_FLAGS_IGNORE_X) {
    treeOwnerAsWin->GetPosition(&x, &unused);
  }

  int32_t y = aY;
  if (aFlags & nsIEmbeddingSiteWindow::DIM_FLAGS_IGNORE_Y) {
    treeOwnerAsWin->GetPosition(&unused, &y);
  }

  int32_t cx = aCx;
  if (aFlags & nsIEmbeddingSiteWindow::DIM_FLAGS_IGNORE_CX) {
    treeOwnerAsWin->GetSize(&cx, &unused);
  }

  int32_t cy = aCy;
  if (aFlags & nsIEmbeddingSiteWindow::DIM_FLAGS_IGNORE_CY) {
    treeOwnerAsWin->GetSize(&unused, &cy);
  }

  if (aFlags & nsIEmbeddingSiteWindow::DIM_FLAGS_POSITION &&
      aFlags & nsIEmbeddingSiteWindow::DIM_FLAGS_SIZE_OUTER) {
    treeOwnerAsWin->SetPositionAndSize(x, y, cx, cy,
                                       nsIBaseWindow::eRepaint);
    return true;
  }

  if (aFlags & nsIEmbeddingSiteWindow::DIM_FLAGS_POSITION) {
    treeOwnerAsWin->SetPosition(x, y);
    mUpdatedDimensions = false;
    UpdatePosition();
    return true;
  }

  if (aFlags & nsIEmbeddingSiteWindow::DIM_FLAGS_SIZE_OUTER) {
    treeOwnerAsWin->SetSize(cx, cy, true);
    return true;
  }

  MOZ_ASSERT(false, "Unknown flags!");
  return false;
}

nsresult
TabParent::UpdatePosition()
{
  RefPtr<nsFrameLoader> frameLoader = GetFrameLoader();
  if (!frameLoader) {
    return NS_OK;
  }
  nsIntRect windowDims;
  NS_ENSURE_SUCCESS(frameLoader->GetWindowDimensions(windowDims), NS_ERROR_FAILURE);
  UpdateDimensions(windowDims, mDimensions);
  return NS_OK;
}

void
TabParent::UpdateDimensions(const nsIntRect& rect, const ScreenIntSize& size)
{
  if (mIsDestroyed) {
    return;
  }
  nsCOMPtr<nsIWidget> widget = GetWidget();
  if (!widget) {
    NS_WARNING("No widget found in TabParent::UpdateDimensions");
    return;
  }

  hal::ScreenConfiguration config;
  hal::GetCurrentScreenConfiguration(&config);
  ScreenOrientationInternal orientation = config.orientation();
  LayoutDeviceIntPoint clientOffset = widget->GetClientOffset();
  LayoutDeviceIntPoint chromeOffset = -GetChildProcessOffset();

  if (!mUpdatedDimensions || mOrientation != orientation ||
      mDimensions != size || !mRect.IsEqualEdges(rect) ||
      clientOffset != mClientOffset ||
      chromeOffset != mChromeOffset) {

    mUpdatedDimensions = true;
    mRect = rect;
    mDimensions = size;
    mOrientation = orientation;
    mClientOffset = clientOffset;
    mChromeOffset = chromeOffset;

    CSSToLayoutDeviceScale widgetScale = widget->GetDefaultScale();

    LayoutDeviceIntRect devicePixelRect =
      ViewAs<LayoutDevicePixel>(mRect,
                                PixelCastJustification::LayoutDeviceIsScreenForTabDims);
    LayoutDeviceIntSize devicePixelSize =
      ViewAs<LayoutDevicePixel>(mDimensions,
                                PixelCastJustification::LayoutDeviceIsScreenForTabDims);

    CSSRect unscaledRect = devicePixelRect / widgetScale;
    CSSSize unscaledSize = devicePixelSize / widgetScale;
    Unused << SendUpdateDimensions(unscaledRect, unscaledSize,
                                   orientation, clientOffset, chromeOffset);
  }
}

void
TabParent::SizeModeChanged(const nsSizeMode& aSizeMode)
{
  if (!mIsDestroyed && aSizeMode != mSizeMode) {
    mSizeMode = aSizeMode;
    Unused << SendSizeModeChanged(aSizeMode);
  }
}

void
TabParent::UIResolutionChanged()
{
  if (!mIsDestroyed) {
    // TryCacheDPIAndScale()'s cache is keyed off of
    // mDPI being greater than 0, so this invalidates it.
    mDPI = -1;
    TryCacheDPIAndScale();
    // If mDPI was set to -1 to invalidate it and then TryCacheDPIAndScale
    // fails to cache the values, then mDefaultScale.scale might be invalid.
    // We don't want to send that value to content. Just send -1 for it too in
    // that case.
    Unused << SendUIResolutionChanged(mDPI, mRounding,
                                      mDPI < 0 ? -1.0 : mDefaultScale.scale);
  }
}

void
TabParent::ThemeChanged()
{
  if (!mIsDestroyed) {
    // The theme has changed, and any cached values we had sent down
    // to the child have been invalidated. When this method is called,
    // LookAndFeel should have the up-to-date values, which we now
    // send down to the child. We do this for every remote tab for now,
    // but bug 1156934 has been filed to do it once per content process.
    Unused << SendThemeChanged(LookAndFeel::GetIntCache());
  }
}

void
TabParent::HandleAccessKey(const WidgetKeyboardEvent& aEvent,
                           nsTArray<uint32_t>& aCharCodes,
                           const int32_t& aModifierMask)
{
  if (!mIsDestroyed) {
    Unused << SendHandleAccessKey(aEvent, aCharCodes, aModifierMask);
  }
}

void
TabParent::Activate()
{
  if (!mIsDestroyed) {
    Unused << SendActivate();
  }
}

void
TabParent::Deactivate()
{
  if (!mIsDestroyed) {
    Unused << SendDeactivate();
  }
}

NS_IMETHODIMP
TabParent::Init(mozIDOMWindowProxy *window)
{
  return NS_OK;
}

NS_IMETHODIMP
TabParent::GetState(uint32_t *aState)
{
  NS_ENSURE_ARG(aState);
  NS_WARNING("SecurityState not valid here");
  *aState = 0;
  return NS_OK;
}

NS_IMETHODIMP
TabParent::SetDocShell(nsIDocShell *aDocShell)
{
  NS_ENSURE_ARG(aDocShell);
  NS_WARNING("No mDocShell member in TabParent so there is no docShell to set");
  return NS_OK;
}

  a11y::PDocAccessibleParent*
TabParent::AllocPDocAccessibleParent(PDocAccessibleParent* aParent,
                                     const uint64_t&, const uint32_t&,
                                     const IAccessibleHolder&)
{
#ifdef ACCESSIBILITY
  return new a11y::DocAccessibleParent();
#else
  return nullptr;
#endif
}

bool
TabParent::DeallocPDocAccessibleParent(PDocAccessibleParent* aParent)
{
#ifdef ACCESSIBILITY
  delete static_cast<a11y::DocAccessibleParent*>(aParent);
#endif
  return true;
}

bool
TabParent::RecvPDocAccessibleConstructor(PDocAccessibleParent* aDoc,
                                         PDocAccessibleParent* aParentDoc,
                                         const uint64_t& aParentID,
                                         const uint32_t& aMsaaID,
                                         const IAccessibleHolder& aDocCOMProxy)
{
#ifdef ACCESSIBILITY
  auto doc = static_cast<a11y::DocAccessibleParent*>(aDoc);
  if (aParentDoc) {
    // A document should never directly be the parent of another document.
    // There should always be an outer doc accessible child of the outer
    // document containing the child.
    MOZ_ASSERT(aParentID);
    if (!aParentID) {
      return false;
    }

    auto parentDoc = static_cast<a11y::DocAccessibleParent*>(aParentDoc);
    bool added = parentDoc->AddChildDoc(doc, aParentID);
#ifdef XP_WIN
    MOZ_ASSERT(aDocCOMProxy.IsNull());
    if (added) {
      a11y::WrapperFor(doc)->SetID(aMsaaID);
    }
#endif
    return added;
  } else {
    // null aParentDoc means this document is at the top level in the child
    // process.  That means it makes no sense to get an id for an accessible
    // that is its parent.
    MOZ_ASSERT(!aParentID);
    if (aParentID) {
      return false;
    }

    doc->SetTopLevel();
    a11y::DocManager::RemoteDocAdded(doc);
#ifdef XP_WIN
    a11y::WrapperFor(doc)->SetID(aMsaaID);
    MOZ_ASSERT(!aDocCOMProxy.IsNull());
    RefPtr<IAccessible> proxy(aDocCOMProxy.Get());
    doc->SetCOMProxy(proxy);
#endif
  }
#endif
  return true;
}

a11y::DocAccessibleParent*
TabParent::GetTopLevelDocAccessible() const
{
#ifdef ACCESSIBILITY
  // XXX Consider managing non top level PDocAccessibles with their parent
  // document accessible.
  const ManagedContainer<PDocAccessibleParent>& docs = ManagedPDocAccessibleParent();
  for (auto iter = docs.ConstIter(); !iter.Done(); iter.Next()) {
    auto doc = static_cast<a11y::DocAccessibleParent*>(iter.Get()->GetKey());
    if (!doc->ParentDoc()) {
      return doc;
    }
  }

  MOZ_ASSERT(docs.Count() == 0, "If there isn't a top level accessible doc "
                                "there shouldn't be an accessible doc at all!");
#endif
  return nullptr;
}

PDocumentRendererParent*
TabParent::AllocPDocumentRendererParent(const nsRect& documentRect,
                                        const gfx::Matrix& transform,
                                        const nsString& bgcolor,
                                        const uint32_t& renderFlags,
                                        const bool& flushLayout,
                                        const nsIntSize& renderSize)
{
    return new DocumentRendererParent();
}

bool
TabParent::DeallocPDocumentRendererParent(PDocumentRendererParent* actor)
{
    delete actor;
    return true;
}

PFilePickerParent*
TabParent::AllocPFilePickerParent(const nsString& aTitle, const int16_t& aMode)
{
  return new FilePickerParent(aTitle, aMode);
}

bool
TabParent::DeallocPFilePickerParent(PFilePickerParent* actor)
{
  delete actor;
  return true;
}

auto
TabParent::AllocPIndexedDBPermissionRequestParent(const Principal& aPrincipal)
  -> PIndexedDBPermissionRequestParent*
{
  MOZ_ASSERT(NS_IsMainThread());

  nsCOMPtr<nsIPrincipal> principal(aPrincipal);
  if (!principal) {
    return nullptr;
  }

  nsCOMPtr<nsIContentParent> manager = Manager();
  if (manager->IsContentParent()) {
    if (NS_WARN_IF(!AssertAppPrincipal(manager->AsContentParent(),
                                       principal))) {
      return nullptr;
    }
  } else {
    MOZ_CRASH("Figure out security checks for bridged content!");
  }

  if (NS_WARN_IF(!mFrameElement)) {
    return nullptr;
  }

  return
    mozilla::dom::indexedDB::AllocPIndexedDBPermissionRequestParent(mFrameElement,
                                                                    principal);
}

bool
TabParent::RecvPIndexedDBPermissionRequestConstructor(
                                      PIndexedDBPermissionRequestParent* aActor,
                                      const Principal& aPrincipal)
{
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(aActor);

  return
    mozilla::dom::indexedDB::RecvPIndexedDBPermissionRequestConstructor(aActor);
}

bool
TabParent::DeallocPIndexedDBPermissionRequestParent(
                                      PIndexedDBPermissionRequestParent* aActor)
{
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(aActor);

  return
    mozilla::dom::indexedDB::DeallocPIndexedDBPermissionRequestParent(aActor);
}

void
TabParent::SendMouseEvent(const nsAString& aType, float aX, float aY,
                          int32_t aButton, int32_t aClickCount,
                          int32_t aModifiers, bool aIgnoreRootScrollFrame)
{
  if (!mIsDestroyed) {
    Unused << PBrowserParent::SendMouseEvent(nsString(aType), aX, aY,
                                             aButton, aClickCount,
                                             aModifiers, aIgnoreRootScrollFrame);
  }
}

void
TabParent::SendKeyEvent(const nsAString& aType,
                        int32_t aKeyCode,
                        int32_t aCharCode,
                        int32_t aModifiers,
                        bool aPreventDefault)
{
  if (!mIsDestroyed) {
    Unused << PBrowserParent::SendKeyEvent(nsString(aType), aKeyCode, aCharCode,
                                           aModifiers, aPreventDefault);
  }
}

bool TabParent::SendRealMouseEvent(WidgetMouseEvent& event)
{
  if (mIsDestroyed) {
    return false;
  }
  event.mRefPoint += GetChildProcessOffset();

  nsCOMPtr<nsIWidget> widget = GetWidget();
  if (widget) {
    // When we mouseenter the tab, the tab's cursor should
    // become the current cursor.  When we mouseexit, we stop.
    if (eMouseEnterIntoWidget == event.mMessage) {
      mTabSetsCursor = true;
      if (mCustomCursor) {
        widget->SetCursor(mCustomCursor, mCustomCursorHotspotX, mCustomCursorHotspotY);
      } else if (mCursor != nsCursor(-1)) {
        widget->SetCursor(mCursor);
      }
    } else if (eMouseExitFromWidget == event.mMessage) {
      mTabSetsCursor = false;
    }
  }

  ScrollableLayerGuid guid;
  uint64_t blockId;
  ApzAwareEventRoutingToChild(&guid, &blockId, nullptr);

  if (eMouseMove == event.mMessage) {
    if (event.mReason == WidgetMouseEvent::eSynthesized) {
      return SendSynthMouseMoveEvent(event, guid, blockId);
    } else {
      return SendRealMouseMoveEvent(event, guid, blockId);
    }
  }

  return SendRealMouseButtonEvent(event, guid, blockId);
}

LayoutDeviceToCSSScale
TabParent::GetLayoutDeviceToCSSScale()
{
  nsCOMPtr<nsIContent> content = do_QueryInterface(mFrameElement);
  nsIDocument* doc = (content ? content->OwnerDoc() : nullptr);
  nsIPresShell* shell = (doc ? doc->GetShell() : nullptr);
  nsPresContext* ctx = (shell ? shell->GetPresContext() : nullptr);
  return LayoutDeviceToCSSScale(ctx
    ? (float)ctx->AppUnitsPerDevPixel() / nsPresContext::AppUnitsPerCSSPixel()
    : 0.0f);
}

bool
TabParent::SendRealDragEvent(WidgetDragEvent& event, uint32_t aDragAction,
                             uint32_t aDropEffect)
{
  if (mIsDestroyed) {
    return false;
  }
  event.mRefPoint += GetChildProcessOffset();
  return PBrowserParent::SendRealDragEvent(event, aDragAction, aDropEffect);
}

LayoutDevicePoint TabParent::AdjustTapToChildWidget(const LayoutDevicePoint& aPoint)
{
  return aPoint + LayoutDevicePoint(GetChildProcessOffset());
}

bool TabParent::SendMouseWheelEvent(WidgetWheelEvent& event)
{
  if (mIsDestroyed) {
    return false;
  }

  ScrollableLayerGuid guid;
  uint64_t blockId;
  ApzAwareEventRoutingToChild(&guid, &blockId, nullptr);
  event.mRefPoint += GetChildProcessOffset();
  return PBrowserParent::SendMouseWheelEvent(event, guid, blockId);
}

bool TabParent::RecvDispatchWheelEvent(const mozilla::WidgetWheelEvent& aEvent)
{
  nsCOMPtr<nsIWidget> widget = GetWidget();
  if (!widget) {
    return true;
  }

  WidgetWheelEvent localEvent(aEvent);
  localEvent.mWidget = widget;
  localEvent.mRefPoint -= GetChildProcessOffset();

  widget->DispatchInputEvent(&localEvent);
  return true;
}

bool
TabParent::RecvDispatchMouseEvent(const mozilla::WidgetMouseEvent& aEvent)
{
  nsCOMPtr<nsIWidget> widget = GetWidget();
  if (!widget) {
    return true;
  }

  WidgetMouseEvent localEvent(aEvent);
  localEvent.mWidget = widget;
  localEvent.mRefPoint -= GetChildProcessOffset();

  widget->DispatchInputEvent(&localEvent);
  return true;
}

bool
TabParent::RecvDispatchKeyboardEvent(const mozilla::WidgetKeyboardEvent& aEvent)
{
  nsCOMPtr<nsIWidget> widget = GetWidget();
  if (!widget) {
    return true;
  }

  WidgetKeyboardEvent localEvent(aEvent);
  localEvent.mWidget = widget;
  localEvent.mRefPoint -= GetChildProcessOffset();

  widget->DispatchInputEvent(&localEvent);
  return true;
}

static void
DoCommandCallback(mozilla::Command aCommand, void* aData)
{
  static_cast<InfallibleTArray<mozilla::CommandInt>*>(aData)->AppendElement(aCommand);
}

bool
TabParent::RecvRequestNativeKeyBindings(const WidgetKeyboardEvent& aEvent,
                                        MaybeNativeKeyBinding* aBindings)
{
  AutoTArray<mozilla::CommandInt, 4> singleLine;
  AutoTArray<mozilla::CommandInt, 4> multiLine;
  AutoTArray<mozilla::CommandInt, 4> richText;

  *aBindings = mozilla::void_t();

  nsCOMPtr<nsIWidget> widget = GetWidget();
  if (!widget) {
    return true;
  }

  WidgetKeyboardEvent localEvent(aEvent);

  if (NS_FAILED(widget->AttachNativeKeyEvent(localEvent))) {
    return true;
  }

  widget->ExecuteNativeKeyBinding(nsIWidget::NativeKeyBindingsForSingleLineEditor,
                                  localEvent, DoCommandCallback, &singleLine);
  widget->ExecuteNativeKeyBinding(nsIWidget::NativeKeyBindingsForMultiLineEditor,
                                  localEvent, DoCommandCallback, &multiLine);
  widget->ExecuteNativeKeyBinding(nsIWidget::NativeKeyBindingsForRichTextEditor,
                                  localEvent, DoCommandCallback, &richText);

  if (!singleLine.IsEmpty() || !multiLine.IsEmpty() || !richText.IsEmpty()) {
    *aBindings = NativeKeyBinding(singleLine, multiLine, richText);
  }

  return true;
}

class SynthesizedEventObserver : public nsIObserver
{
  NS_DECL_ISUPPORTS

public:
  SynthesizedEventObserver(TabParent* aTabParent, const uint64_t& aObserverId)
    : mTabParent(aTabParent)
    , mObserverId(aObserverId)
  {
    MOZ_ASSERT(mTabParent);
  }

  NS_IMETHOD Observe(nsISupports* aSubject,
                     const char* aTopic,
                     const char16_t* aData) override
  {
    if (!mTabParent || !mObserverId) {
      // We already sent the notification, or we don't actually need to
      // send any notification at all.
      return NS_OK;
    }

    if (!mTabParent->SendNativeSynthesisResponse(mObserverId, nsCString(aTopic))) {
      NS_WARNING("Unable to send native event synthesization response!");
    }
    // Null out tabparent to indicate we already sent the response
    mTabParent = nullptr;
    return NS_OK;
  }

private:
  virtual ~SynthesizedEventObserver() { }

  RefPtr<TabParent> mTabParent;
  uint64_t mObserverId;
};

NS_IMPL_ISUPPORTS(SynthesizedEventObserver, nsIObserver)

class MOZ_STACK_CLASS AutoSynthesizedEventResponder
{
public:
  AutoSynthesizedEventResponder(TabParent* aTabParent,
                                const uint64_t& aObserverId,
                                const char* aTopic)
    : mObserver(new SynthesizedEventObserver(aTabParent, aObserverId))
    , mTopic(aTopic)
  { }

  ~AutoSynthesizedEventResponder()
  {
    // This may be a no-op if the observer already sent a response.
    mObserver->Observe(nullptr, mTopic, nullptr);
  }

  nsIObserver* GetObserver()
  {
    return mObserver;
  }

private:
  nsCOMPtr<nsIObserver> mObserver;
  const char* mTopic;
};

bool
TabParent::RecvSynthesizeNativeKeyEvent(const int32_t& aNativeKeyboardLayout,
                                        const int32_t& aNativeKeyCode,
                                        const uint32_t& aModifierFlags,
                                        const nsString& aCharacters,
                                        const nsString& aUnmodifiedCharacters,
                                        const uint64_t& aObserverId)
{
  AutoSynthesizedEventResponder responder(this, aObserverId, "keyevent");
  nsCOMPtr<nsIWidget> widget = GetWidget();
  if (widget) {
    widget->SynthesizeNativeKeyEvent(aNativeKeyboardLayout, aNativeKeyCode,
      aModifierFlags, aCharacters, aUnmodifiedCharacters,
      responder.GetObserver());
  }
  return true;
}

bool
TabParent::RecvSynthesizeNativeMouseEvent(const LayoutDeviceIntPoint& aPoint,
                                          const uint32_t& aNativeMessage,
                                          const uint32_t& aModifierFlags,
                                          const uint64_t& aObserverId)
{
  AutoSynthesizedEventResponder responder(this, aObserverId, "mouseevent");
  nsCOMPtr<nsIWidget> widget = GetWidget();
  if (widget) {
    widget->SynthesizeNativeMouseEvent(aPoint, aNativeMessage, aModifierFlags,
      responder.GetObserver());
  }
  return true;
}

bool
TabParent::RecvSynthesizeNativeMouseMove(const LayoutDeviceIntPoint& aPoint,
                                         const uint64_t& aObserverId)
{
  AutoSynthesizedEventResponder responder(this, aObserverId, "mousemove");
  nsCOMPtr<nsIWidget> widget = GetWidget();
  if (widget) {
    widget->SynthesizeNativeMouseMove(aPoint, responder.GetObserver());
  }
  return true;
}

bool
TabParent::RecvSynthesizeNativeMouseScrollEvent(const LayoutDeviceIntPoint& aPoint,
                                                const uint32_t& aNativeMessage,
                                                const double& aDeltaX,
                                                const double& aDeltaY,
                                                const double& aDeltaZ,
                                                const uint32_t& aModifierFlags,
                                                const uint32_t& aAdditionalFlags,
                                                const uint64_t& aObserverId)
{
  AutoSynthesizedEventResponder responder(this, aObserverId, "mousescrollevent");
  nsCOMPtr<nsIWidget> widget = GetWidget();
  if (widget) {
    widget->SynthesizeNativeMouseScrollEvent(aPoint, aNativeMessage,
      aDeltaX, aDeltaY, aDeltaZ, aModifierFlags, aAdditionalFlags,
      responder.GetObserver());
  }
  return true;
}

bool
TabParent::RecvSynthesizeNativeTouchPoint(const uint32_t& aPointerId,
                                          const TouchPointerState& aPointerState,
                                          const LayoutDeviceIntPoint& aPoint,
                                          const double& aPointerPressure,
                                          const uint32_t& aPointerOrientation,
                                          const uint64_t& aObserverId)
{
  AutoSynthesizedEventResponder responder(this, aObserverId, "touchpoint");
  nsCOMPtr<nsIWidget> widget = GetWidget();
  if (widget) {
    widget->SynthesizeNativeTouchPoint(aPointerId, aPointerState, aPoint,
      aPointerPressure, aPointerOrientation, responder.GetObserver());
  }
  return true;
}

bool
TabParent::RecvSynthesizeNativeTouchTap(const LayoutDeviceIntPoint& aPoint,
                                        const bool& aLongTap,
                                        const uint64_t& aObserverId)
{
  AutoSynthesizedEventResponder responder(this, aObserverId, "touchtap");
  nsCOMPtr<nsIWidget> widget = GetWidget();
  if (widget) {
    widget->SynthesizeNativeTouchTap(aPoint, aLongTap, responder.GetObserver());
  }
  return true;
}

bool
TabParent::RecvClearNativeTouchSequence(const uint64_t& aObserverId)
{
  AutoSynthesizedEventResponder responder(this, aObserverId, "cleartouch");
  nsCOMPtr<nsIWidget> widget = GetWidget();
  if (widget) {
    widget->ClearNativeTouchSequence(responder.GetObserver());
  }
  return true;
}

bool TabParent::SendRealKeyEvent(WidgetKeyboardEvent& event)
{
  if (mIsDestroyed) {
    return false;
  }
  event.mRefPoint += GetChildProcessOffset();

  MaybeNativeKeyBinding bindings;
  bindings = void_t();
  if (event.mMessage == eKeyPress) {
    nsCOMPtr<nsIWidget> widget = GetWidget();

    AutoTArray<mozilla::CommandInt, 4> singleLine;
    AutoTArray<mozilla::CommandInt, 4> multiLine;
    AutoTArray<mozilla::CommandInt, 4> richText;

    widget->ExecuteNativeKeyBinding(nsIWidget::NativeKeyBindingsForSingleLineEditor,
                                    event, DoCommandCallback, &singleLine);
    widget->ExecuteNativeKeyBinding(nsIWidget::NativeKeyBindingsForMultiLineEditor,
                                    event, DoCommandCallback, &multiLine);
    widget->ExecuteNativeKeyBinding(nsIWidget::NativeKeyBindingsForRichTextEditor,
                                    event, DoCommandCallback, &richText);

    if (!singleLine.IsEmpty() || !multiLine.IsEmpty() || !richText.IsEmpty()) {
      bindings = NativeKeyBinding(singleLine, multiLine, richText);
    }
  }

  return PBrowserParent::SendRealKeyEvent(event, bindings);
}

bool TabParent::SendRealTouchEvent(WidgetTouchEvent& event)
{
  if (mIsDestroyed) {
    return false;
  }

  // PresShell::HandleEventInternal adds touches on touch end/cancel.  This
  // confuses remote content and the panning and zooming logic into thinking
  // that the added touches are part of the touchend/cancel, when actually
  // they're not.
  if (event.mMessage == eTouchEnd || event.mMessage == eTouchCancel) {
    for (int i = event.mTouches.Length() - 1; i >= 0; i--) {
      if (!event.mTouches[i]->mChanged) {
        event.mTouches.RemoveElementAt(i);
      }
    }
  }

  ScrollableLayerGuid guid;
  uint64_t blockId;
  nsEventStatus apzResponse;
  ApzAwareEventRoutingToChild(&guid, &blockId, &apzResponse);

  if (mIsDestroyed) {
    return false;
  }

  LayoutDeviceIntPoint offset = GetChildProcessOffset();
  for (uint32_t i = 0; i < event.mTouches.Length(); i++) {
    event.mTouches[i]->mRefPoint += offset;
  }

  return (event.mMessage == eTouchMove) ?
    PBrowserParent::SendRealTouchMoveEvent(event, guid, blockId, apzResponse) :
    PBrowserParent::SendRealTouchEvent(event, guid, blockId, apzResponse);
}

bool
TabParent::SendHandleTap(TapType aType,
                         const LayoutDevicePoint& aPoint,
                         Modifiers aModifiers,
                         const ScrollableLayerGuid& aGuid,
                         uint64_t aInputBlockId)
{
  if (mIsDestroyed) {
    return false;
  }
  if ((aType == TapType::eSingleTap || aType == TapType::eSecondTap) &&
      GetRenderFrame()) {
    GetRenderFrame()->TakeFocusForClickFromTap();
  }
  LayoutDeviceIntPoint offset = GetChildProcessOffset();
  return PBrowserParent::SendHandleTap(aType, aPoint + offset, aModifiers, aGuid,
      aInputBlockId);
}

bool
TabParent::RecvSyncMessage(const nsString& aMessage,
                           const ClonedMessageData& aData,
                           InfallibleTArray<CpowEntry>&& aCpows,
                           const IPC::Principal& aPrincipal,
                           nsTArray<StructuredCloneData>* aRetVal)
{
  // FIXME Permission check for TabParent in Content process
  nsIPrincipal* principal = aPrincipal;
  if (Manager()->IsContentParent()) {
    ContentParent* parent = Manager()->AsContentParent();
    if (!ContentParent::IgnoreIPCPrincipal() &&
        parent && principal && !AssertAppPrincipal(parent, principal)) {
      return false;
    }
  }

  StructuredCloneData data;
  ipc::UnpackClonedMessageDataForParent(aData, data);

  CrossProcessCpowHolder cpows(Manager(), aCpows);
  return ReceiveMessage(aMessage, true, &data, &cpows, aPrincipal, aRetVal);
}

bool
TabParent::RecvRpcMessage(const nsString& aMessage,
                          const ClonedMessageData& aData,
                          InfallibleTArray<CpowEntry>&& aCpows,
                          const IPC::Principal& aPrincipal,
                          nsTArray<StructuredCloneData>* aRetVal)
{
  // FIXME Permission check for TabParent in Content process
  nsIPrincipal* principal = aPrincipal;
  if (Manager()->IsContentParent()) {
    ContentParent* parent = Manager()->AsContentParent();
    if (!ContentParent::IgnoreIPCPrincipal() &&
        parent && principal && !AssertAppPrincipal(parent, principal)) {
      return false;
    }
  }

  StructuredCloneData data;
  ipc::UnpackClonedMessageDataForParent(aData, data);

  CrossProcessCpowHolder cpows(Manager(), aCpows);
  return ReceiveMessage(aMessage, true, &data, &cpows, aPrincipal, aRetVal);
}

bool
TabParent::RecvAsyncMessage(const nsString& aMessage,
                            InfallibleTArray<CpowEntry>&& aCpows,
                            const IPC::Principal& aPrincipal,
                            const ClonedMessageData& aData)
{
  // FIXME Permission check for TabParent in Content process
  nsIPrincipal* principal = aPrincipal;
  if (Manager()->IsContentParent()) {
    ContentParent* parent = Manager()->AsContentParent();
    if (!ContentParent::IgnoreIPCPrincipal() &&
        parent && principal && !AssertAppPrincipal(parent, principal)) {
      return false;
    }
  }

  StructuredCloneData data;
  ipc::UnpackClonedMessageDataForParent(aData, data);

  CrossProcessCpowHolder cpows(Manager(), aCpows);
  return ReceiveMessage(aMessage, false, &data, &cpows, aPrincipal, nullptr);
}

bool
TabParent::RecvSetCursor(const uint32_t& aCursor, const bool& aForce)
{
  mCursor = static_cast<nsCursor>(aCursor);
  mCustomCursor = nullptr;

  nsCOMPtr<nsIWidget> widget = GetWidget();
  if (widget) {
    if (aForce) {
      widget->ClearCachedCursor();
    }
    if (mTabSetsCursor) {
      widget->SetCursor(mCursor);
    }
  }
  return true;
}

bool
TabParent::RecvSetCustomCursor(const nsCString& aCursorData,
                               const uint32_t& aWidth,
                               const uint32_t& aHeight,
                               const uint32_t& aStride,
                               const uint8_t& aFormat,
                               const uint32_t& aHotspotX,
                               const uint32_t& aHotspotY,
                               const bool& aForce)
{
  mCursor = nsCursor(-1);

  nsCOMPtr<nsIWidget> widget = GetWidget();
  if (widget) {
    if (aForce) {
      widget->ClearCachedCursor();
    }

    if (mTabSetsCursor) {
      const gfx::IntSize size(aWidth, aHeight);

      RefPtr<gfx::DataSourceSurface> customCursor =
          gfx::CreateDataSourceSurfaceFromData(size,
                                               static_cast<gfx::SurfaceFormat>(aFormat),
                                               reinterpret_cast<const uint8_t*>(aCursorData.BeginReading()),
                                               aStride);

      RefPtr<gfxDrawable> drawable = new gfxSurfaceDrawable(customCursor, size);
      nsCOMPtr<imgIContainer> cursorImage(image::ImageOps::CreateFromDrawable(drawable));
      widget->SetCursor(cursorImage, aHotspotX, aHotspotY);
      mCustomCursor = cursorImage;
      mCustomCursorHotspotX = aHotspotX;
      mCustomCursorHotspotY = aHotspotY;
    }
  }

  return true;
}

nsIXULBrowserWindow*
TabParent::GetXULBrowserWindow()
{
  if (!mFrameElement) {
    return nullptr;
  }

  nsCOMPtr<nsIDocShell> docShell = mFrameElement->OwnerDoc()->GetDocShell();
  if (!docShell) {
    return nullptr;
  }

  nsCOMPtr<nsIDocShellTreeOwner> treeOwner;
  docShell->GetTreeOwner(getter_AddRefs(treeOwner));
  if (!treeOwner) {
    return nullptr;
  }

  nsCOMPtr<nsIXULWindow> window = do_GetInterface(treeOwner);
  if (!window) {
    return nullptr;
  }

  nsCOMPtr<nsIXULBrowserWindow> xulBrowserWindow;
  window->GetXULBrowserWindow(getter_AddRefs(xulBrowserWindow));
  return xulBrowserWindow;
}

bool
TabParent::RecvSetStatus(const uint32_t& aType, const nsString& aStatus)
{
  nsCOMPtr<nsIXULBrowserWindow> xulBrowserWindow = GetXULBrowserWindow();
  if (!xulBrowserWindow) {
    return true;
  }

  switch (aType) {
   case nsIWebBrowserChrome::STATUS_SCRIPT:
    xulBrowserWindow->SetJSStatus(aStatus);
    break;
   case nsIWebBrowserChrome::STATUS_LINK:
    xulBrowserWindow->SetOverLink(aStatus, nullptr);
    break;
  }
  return true;
}

bool
TabParent::RecvShowTooltip(const uint32_t& aX, const uint32_t& aY, const nsString& aTooltip,
                           const nsString& aDirection)
{
  nsCOMPtr<nsIXULBrowserWindow> xulBrowserWindow = GetXULBrowserWindow();
  if (!xulBrowserWindow) {
    return true;
  }

  xulBrowserWindow->ShowTooltip(aX, aY, aTooltip, aDirection);
  return true;
}

bool
TabParent::RecvHideTooltip()
{
  nsCOMPtr<nsIXULBrowserWindow> xulBrowserWindow = GetXULBrowserWindow();
  if (!xulBrowserWindow) {
    return true;
  }

  xulBrowserWindow->HideTooltip();
  return true;
}

bool
TabParent::RecvNotifyIMEFocus(const ContentCache& aContentCache,
                              const IMENotification& aIMENotification,
                              nsIMEUpdatePreference* aPreference)
{
  nsCOMPtr<nsIWidget> widget = GetWidget();
  if (!widget) {
    *aPreference = nsIMEUpdatePreference();
    return true;
  }

  mContentCache.AssignContent(aContentCache, widget, &aIMENotification);
  IMEStateManager::NotifyIME(aIMENotification, widget, true);

  if (aIMENotification.mMessage == NOTIFY_IME_OF_FOCUS) {
    *aPreference = widget->GetIMEUpdatePreference();
  }
  return true;
}

bool
TabParent::RecvNotifyIMETextChange(const ContentCache& aContentCache,
                                   const IMENotification& aIMENotification)
{
  nsCOMPtr<nsIWidget> widget = GetWidget();
  if (!widget)
    return true;

#ifdef DEBUG
  nsIMEUpdatePreference updatePreference = widget->GetIMEUpdatePreference();
  NS_ASSERTION(updatePreference.WantTextChange(),
               "Don't call Send/RecvNotifyIMETextChange without NOTIFY_TEXT_CHANGE");
#endif

  mContentCache.AssignContent(aContentCache, widget, &aIMENotification);
  mContentCache.MaybeNotifyIME(widget, aIMENotification);
  return true;
}

bool
TabParent::RecvNotifyIMECompositionUpdate(
             const ContentCache& aContentCache,
             const IMENotification& aIMENotification)
{
  nsCOMPtr<nsIWidget> widget = GetWidget();
  if (!widget) {
    return true;
  }

  mContentCache.AssignContent(aContentCache, widget, &aIMENotification);
  mContentCache.MaybeNotifyIME(widget, aIMENotification);
  return true;
}

bool
TabParent::RecvNotifyIMESelection(const ContentCache& aContentCache,
                                  const IMENotification& aIMENotification)
{
  nsCOMPtr<nsIWidget> widget = GetWidget();
  if (!widget)
    return true;

  mContentCache.AssignContent(aContentCache, widget, &aIMENotification);
  mContentCache.MaybeNotifyIME(widget, aIMENotification);
  return true;
}

bool
TabParent::RecvUpdateContentCache(const ContentCache& aContentCache)
{
  nsCOMPtr<nsIWidget> widget = GetWidget();
  if (!widget) {
    return true;
  }

  mContentCache.AssignContent(aContentCache, widget);
  return true;
}

bool
TabParent::RecvNotifyIMEMouseButtonEvent(
             const IMENotification& aIMENotification,
             bool* aConsumedByIME)
{

  nsCOMPtr<nsIWidget> widget = GetWidget();
  if (!widget) {
    *aConsumedByIME = false;
    return true;
  }
  nsresult rv = IMEStateManager::NotifyIME(aIMENotification, widget, true);
  *aConsumedByIME = rv == NS_SUCCESS_EVENT_CONSUMED;
  return true;
}

bool
TabParent::RecvNotifyIMEPositionChange(const ContentCache& aContentCache,
                                       const IMENotification& aIMENotification)
{
  nsCOMPtr<nsIWidget> widget = GetWidget();
  if (!widget) {
    return true;
  }

  mContentCache.AssignContent(aContentCache, widget, &aIMENotification);
  mContentCache.MaybeNotifyIME(widget, aIMENotification);
  return true;
}

bool
TabParent::RecvOnEventNeedingAckHandled(const EventMessage& aMessage)
{
  // This is called when the child process receives WidgetCompositionEvent or
  // WidgetSelectionEvent.
  nsCOMPtr<nsIWidget> widget = GetWidget();
  if (!widget) {
    return true;
  }

  // While calling OnEventNeedingAckHandled(), TabParent *might* be destroyed
  // since it may send notifications to IME.
  RefPtr<TabParent> kungFuDeathGrip(this);
  mContentCache.OnEventNeedingAckHandled(widget, aMessage);
  return true;
}

void
TabParent::HandledWindowedPluginKeyEvent(const NativeEventData& aKeyEventData,
                                         bool aIsConsumed)
{
  DebugOnly<bool> ok =
    SendHandledWindowedPluginKeyEvent(aKeyEventData, aIsConsumed);
  NS_WARNING_ASSERTION(ok, "SendHandledWindowedPluginKeyEvent failed");
}

bool
TabParent::RecvOnWindowedPluginKeyEvent(const NativeEventData& aKeyEventData)
{
  nsCOMPtr<nsIWidget> widget = GetWidget();
  if (NS_WARN_IF(!widget)) {
    // Notifies the plugin process of the key event being not consumed by us.
    HandledWindowedPluginKeyEvent(aKeyEventData, false);
    return true;
  }
  nsresult rv = widget->OnWindowedPluginKeyEvent(aKeyEventData, this);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    // Notifies the plugin process of the key event being not consumed by us.
    HandledWindowedPluginKeyEvent(aKeyEventData, false);
    return true;
  }

  // If the key event is posted to another process, we need to wait a call
  // of HandledWindowedPluginKeyEvent().  So, nothing to do here in this case.
  if (rv == NS_SUCCESS_EVENT_HANDLED_ASYNCHRONOUSLY) {
    return true;
  }

  // Otherwise, the key event is handled synchronously.  Let's notify the
  // plugin process of the key event's result.
  bool consumed = (rv == NS_SUCCESS_EVENT_CONSUMED);
  HandledWindowedPluginKeyEvent(aKeyEventData, consumed);

  return true;
}

bool
TabParent::RecvRequestFocus(const bool& aCanRaise)
{
  nsCOMPtr<nsIFocusManager> fm = nsFocusManager::GetFocusManager();
  if (!fm) {
    return true;
  }

  nsCOMPtr<nsIContent> content = do_QueryInterface(mFrameElement);
  if (!content || !content->OwnerDoc()) {
    return true;
  }

  uint32_t flags = nsIFocusManager::FLAG_NOSCROLL;
  if (aCanRaise)
    flags |= nsIFocusManager::FLAG_RAISE;

  nsCOMPtr<nsIDOMElement> node = do_QueryInterface(mFrameElement);
  fm->SetFocus(node, flags);
  return true;
}

bool
TabParent::RecvEnableDisableCommands(const nsString& aAction,
                                     nsTArray<nsCString>&& aEnabledCommands,
                                     nsTArray<nsCString>&& aDisabledCommands)
{
  nsCOMPtr<nsIRemoteBrowser> remoteBrowser = do_QueryInterface(mFrameElement);
  if (remoteBrowser) {
    UniquePtr<const char*[]> enabledCommands, disabledCommands;

    if (aEnabledCommands.Length()) {
      enabledCommands = MakeUnique<const char*[]>(aEnabledCommands.Length());
      for (uint32_t c = 0; c < aEnabledCommands.Length(); c++) {
        enabledCommands[c] = aEnabledCommands[c].get();
      }
    }

    if (aDisabledCommands.Length()) {
      disabledCommands = MakeUnique<const char*[]>(aDisabledCommands.Length());
      for (uint32_t c = 0; c < aDisabledCommands.Length(); c++) {
        disabledCommands[c] = aDisabledCommands[c].get();
      }
    }

    remoteBrowser->EnableDisableCommands(aAction,
                                         aEnabledCommands.Length(), enabledCommands.get(),
                                         aDisabledCommands.Length(), disabledCommands.get());
  }

  return true;
}

NS_IMETHODIMP
TabParent::GetChildProcessOffset(int32_t* aOutCssX, int32_t* aOutCssY)
{
  NS_ENSURE_ARG(aOutCssX);
  NS_ENSURE_ARG(aOutCssY);
  CSSPoint offset = LayoutDevicePoint(GetChildProcessOffset())
      * GetLayoutDeviceToCSSScale();
  *aOutCssX = offset.x;
  *aOutCssY = offset.y;
  return NS_OK;
}

LayoutDeviceIntPoint
TabParent::GetChildProcessOffset()
{
  // The "toplevel widget" in child processes is always at position
  // 0,0.  Map the event coordinates to match that.

  LayoutDeviceIntPoint offset(0, 0);
  RefPtr<nsFrameLoader> frameLoader = GetFrameLoader();
  if (!frameLoader) {
    return offset;
  }
  nsIFrame* targetFrame = frameLoader->GetPrimaryFrameOfOwningContent();
  if (!targetFrame) {
    return offset;
  }

  // Find out how far we're offset from the nearest widget.
  nsCOMPtr<nsIWidget> widget = GetWidget();
  if (!widget) {
    return offset;
  }
  nsPoint pt = nsLayoutUtils::GetEventCoordinatesRelativeTo(widget,
                                                            LayoutDeviceIntPoint(0, 0),
                                                            targetFrame);

  return LayoutDeviceIntPoint::FromAppUnitsToNearest(
           pt, targetFrame->PresContext()->AppUnitsPerDevPixel());
}

bool
TabParent::RecvReplyKeyEvent(const WidgetKeyboardEvent& event)
{
  NS_ENSURE_TRUE(mFrameElement, true);

  WidgetKeyboardEvent localEvent(event);
  // Mark the event as not to be dispatched to remote process again.
  localEvent.StopCrossProcessForwarding();

  // Here we convert the WidgetEvent that we received to an nsIDOMEvent
  // to be able to dispatch it to the <browser> element as the target element.
  nsIDocument* doc = mFrameElement->OwnerDoc();
  nsIPresShell* presShell = doc->GetShell();
  NS_ENSURE_TRUE(presShell, true);
  nsPresContext* presContext = presShell->GetPresContext();
  NS_ENSURE_TRUE(presContext, true);

  AutoHandlingUserInputStatePusher userInpStatePusher(localEvent.IsTrusted(),
                                                      &localEvent, doc);

  EventDispatcher::Dispatch(mFrameElement, presContext, &localEvent);
  return true;
}

bool
TabParent::RecvDispatchAfterKeyboardEvent(const WidgetKeyboardEvent& aEvent)
{
  NS_ENSURE_TRUE(mFrameElement, true);

  WidgetKeyboardEvent localEvent(aEvent);
  localEvent.mWidget = GetWidget();

  nsIDocument* doc = mFrameElement->OwnerDoc();
  nsCOMPtr<nsIPresShell> presShell = doc->GetShell();
  NS_ENSURE_TRUE(presShell, true);

  if (mFrameElement &&
      PresShell::BeforeAfterKeyboardEventEnabled() &&
      localEvent.mMessage != eKeyPress) {
    presShell->DispatchAfterKeyboardEvent(mFrameElement, localEvent,
                                          aEvent.DefaultPrevented());
  }

  return true;
}

bool
TabParent::RecvAccessKeyNotHandled(const WidgetKeyboardEvent& aEvent)
{
  NS_ENSURE_TRUE(mFrameElement, true);

  WidgetKeyboardEvent localEvent(aEvent);
  localEvent.mMessage = eAccessKeyNotFound;
  localEvent.mAccessKeyForwardedToChild = false;

  // Here we convert the WidgetEvent that we received to an nsIDOMEvent
  // to be able to dispatch it to the <browser> element as the target element.
  nsIDocument* doc = mFrameElement->OwnerDoc();
  nsIPresShell* presShell = doc->GetShell();
  NS_ENSURE_TRUE(presShell, true);

  if (presShell->CanDispatchEvent()) {
    nsPresContext* presContext = presShell->GetPresContext();
    NS_ENSURE_TRUE(presContext, true);

    EventDispatcher::Dispatch(mFrameElement, presContext, &localEvent);
  }

  return true;
}

bool
TabParent::HandleQueryContentEvent(WidgetQueryContentEvent& aEvent)
{
  nsCOMPtr<nsIWidget> widget = GetWidget();
  if (!widget) {
    return true;
  }
  if (NS_WARN_IF(!mContentCache.HandleQueryContentEvent(aEvent, widget)) ||
      NS_WARN_IF(!aEvent.mSucceeded)) {
    return true;
  }
  switch (aEvent.mMessage) {
    case eQueryTextRect:
    case eQueryCaretRect:
    case eQueryEditorRect:
      aEvent.mReply.mRect -= GetChildProcessOffset();
      break;
    default:
      break;
  }
  return true;
}

bool
TabParent::SendCompositionEvent(WidgetCompositionEvent& event)
{
  if (mIsDestroyed) {
    return false;
  }

  if (!mContentCache.OnCompositionEvent(event)) {
    return true;
  }
  return PBrowserParent::SendCompositionEvent(event);
}

bool
TabParent::SendSelectionEvent(WidgetSelectionEvent& event)
{
  if (mIsDestroyed) {
    return false;
  }
  nsCOMPtr<nsIWidget> widget = GetWidget();
  if (!widget) {
    return true;
  }
  mContentCache.OnSelectionEvent(event);
  if (NS_WARN_IF(!PBrowserParent::SendSelectionEvent(event))) {
    return false;
  }
  event.mSucceeded = true;
  return true;
}

bool
TabParent::SendPasteTransferable(const IPCDataTransfer& aDataTransfer,
                                 const bool& aIsPrivateData,
                                 const IPC::Principal& aRequestingPrincipal)
{
  return PBrowserParent::SendPasteTransferable(aDataTransfer,
                                               aIsPrivateData,
                                               aRequestingPrincipal);
}

/*static*/ TabParent*
TabParent::GetFrom(nsFrameLoader* aFrameLoader)
{
  if (!aFrameLoader) {
    return nullptr;
  }
  PBrowserParent* remoteBrowser = aFrameLoader->GetRemoteBrowser();
  return static_cast<TabParent*>(remoteBrowser);
}

/*static*/ TabParent*
TabParent::GetFrom(nsIFrameLoader* aFrameLoader)
{
  if (!aFrameLoader)
    return nullptr;
  return GetFrom(static_cast<nsFrameLoader*>(aFrameLoader));
}

/*static*/ TabParent*
TabParent::GetFrom(nsITabParent* aTabParent)
{
  return static_cast<TabParent*>(aTabParent);
}

/*static*/ TabParent*
TabParent::GetFrom(PBrowserParent* aTabParent)
{
  return static_cast<TabParent*>(aTabParent);
}

/*static*/ TabParent*
TabParent::GetFrom(nsIContent* aContent)
{
  nsCOMPtr<nsIFrameLoaderOwner> loaderOwner = do_QueryInterface(aContent);
  if (!loaderOwner) {
    return nullptr;
  }
  RefPtr<nsFrameLoader> frameLoader = loaderOwner->GetFrameLoader();
  return GetFrom(frameLoader);
}

/*static*/ TabId
TabParent::GetTabIdFrom(nsIDocShell *docShell)
{
  nsCOMPtr<nsITabChild> tabChild(TabChild::GetFrom(docShell));
  if (tabChild) {
    return static_cast<TabChild*>(tabChild.get())->GetTabId();
  }
  return TabId(0);
}

RenderFrameParent*
TabParent::GetRenderFrame()
{
  PRenderFrameParent* p = LoneManagedOrNullAsserts(ManagedPRenderFrameParent());
  RenderFrameParent* frame = static_cast<RenderFrameParent*>(p);

  return frame;
}

bool
TabParent::RecvRequestIMEToCommitComposition(const bool& aCancel,
                                             bool* aIsCommitted,
                                             nsString* aCommittedString)
{
  nsCOMPtr<nsIWidget> widget = GetWidget();
  if (!widget) {
    *aIsCommitted = false;
    return true;
  }

  *aIsCommitted =
    mContentCache.RequestIMEToCommitComposition(widget, aCancel,
                                                *aCommittedString);
  return true;
}

bool
TabParent::RecvStartPluginIME(const WidgetKeyboardEvent& aKeyboardEvent,
                              const int32_t& aPanelX, const int32_t& aPanelY,
                              nsString* aCommitted)
{
  nsCOMPtr<nsIWidget> widget = GetWidget();
  if (!widget) {
    return true;
  }
  widget->StartPluginIME(aKeyboardEvent,
                         (int32_t&)aPanelX,
                         (int32_t&)aPanelY,
                         *aCommitted);
  return true;
}

bool
TabParent::RecvSetPluginFocused(const bool& aFocused)
{
  nsCOMPtr<nsIWidget> widget = GetWidget();
  if (!widget) {
    return true;
  }
  widget->SetPluginFocused((bool&)aFocused);
  return true;
}

 bool
TabParent::RecvSetCandidateWindowForPlugin(
             const CandidateWindowPosition& aPosition)
{
  nsCOMPtr<nsIWidget> widget = GetWidget();
  if (!widget) {
    return true;
  }

  widget->SetCandidateWindowForPlugin(aPosition);
  return true;
}

bool
TabParent::RecvDefaultProcOfPluginEvent(const WidgetPluginEvent& aEvent)
{
  nsCOMPtr<nsIWidget> widget = GetWidget();
  if (!widget) {
    return true;
  }

  widget->DefaultProcOfPluginEvent(aEvent);
  return true;
}

bool
TabParent::RecvGetInputContext(int32_t* aIMEEnabled,
                               int32_t* aIMEOpen)
{
  nsCOMPtr<nsIWidget> widget = GetWidget();
  if (!widget) {
    *aIMEEnabled = IMEState::DISABLED;
    *aIMEOpen = IMEState::OPEN_STATE_NOT_SUPPORTED;
    return true;
  }

  InputContext context = widget->GetInputContext();
  *aIMEEnabled = static_cast<int32_t>(context.mIMEState.mEnabled);
  *aIMEOpen = static_cast<int32_t>(context.mIMEState.mOpen);
  return true;
}

bool
TabParent::RecvSetInputContext(const int32_t& aIMEEnabled,
                               const int32_t& aIMEOpen,
                               const nsString& aType,
                               const nsString& aInputmode,
                               const nsString& aActionHint,
                               const int32_t& aCause,
                               const int32_t& aFocusChange)
{
  InputContext context;
  context.mIMEState.mEnabled = static_cast<IMEState::Enabled>(aIMEEnabled);
  context.mIMEState.mOpen = static_cast<IMEState::Open>(aIMEOpen);
  context.mHTMLInputType.Assign(aType);
  context.mHTMLInputInputmode.Assign(aInputmode);
  context.mActionHint.Assign(aActionHint);
  context.mOrigin = InputContext::ORIGIN_CONTENT;

  InputContextAction action(
    static_cast<InputContextAction::Cause>(aCause),
    static_cast<InputContextAction::FocusChange>(aFocusChange));

  IMEStateManager::SetInputContextForChildProcess(this, context, action);

  return true;
}

bool
TabParent::RecvIsParentWindowMainWidgetVisible(bool* aIsVisible)
{
  nsCOMPtr<nsIContent> frame = do_QueryInterface(mFrameElement);
  if (!frame)
    return true;
  nsCOMPtr<nsIDOMWindowUtils> windowUtils =
    do_QueryInterface(frame->OwnerDoc()->GetWindow());
  nsresult rv = windowUtils->GetIsParentWindowMainWidgetVisible(aIsVisible);
  return NS_SUCCEEDED(rv);
}

bool
TabParent::RecvGetDPI(float* aValue)
{
  TryCacheDPIAndScale();

  MOZ_ASSERT(mDPI > 0,
             "Must not ask for DPI before OwnerElement is received!");
  *aValue = mDPI;
  return true;
}

bool
TabParent::RecvGetDefaultScale(double* aValue)
{
  TryCacheDPIAndScale();

  MOZ_ASSERT(mDefaultScale.scale > 0,
             "Must not ask for scale before OwnerElement is received!");
  *aValue = mDefaultScale.scale;
  return true;
}

bool
TabParent::RecvGetWidgetRounding(int32_t* aValue)
{
  TryCacheDPIAndScale();

  MOZ_ASSERT(mRounding > 0,
             "Must not ask for rounding before OwnerElement is received!");
  *aValue = mRounding;
  return true;
}

bool
TabParent::RecvGetMaxTouchPoints(uint32_t* aTouchPoints)
{
  nsCOMPtr<nsIWidget> widget = GetWidget();
  if (widget) {
    *aTouchPoints = widget->GetMaxTouchPoints();
  } else {
    *aTouchPoints = 0;
  }
  return true;
}

already_AddRefed<nsIWidget>
TabParent::GetTopLevelWidget()
{
  nsCOMPtr<nsIContent> content = do_QueryInterface(mFrameElement);
  if (content) {
    nsIPresShell* shell = content->OwnerDoc()->GetShell();
    if (shell) {
      nsViewManager* vm = shell->GetViewManager();
      nsCOMPtr<nsIWidget> widget;
      vm->GetRootWidget(getter_AddRefs(widget));
      return widget.forget();
    }
  }
  return nullptr;
}

bool
TabParent::RecvGetWidgetNativeData(WindowsHandle* aValue)
{
  *aValue = 0;
  nsCOMPtr<nsIWidget> widget = GetTopLevelWidget();
  if (widget) {
    *aValue = reinterpret_cast<WindowsHandle>(
      widget->GetNativeData(NS_NATIVE_SHAREABLE_WINDOW));
  }
  return true;
}

bool
TabParent::RecvSetNativeChildOfShareableWindow(const uintptr_t& aChildWindow)
{
#if defined(XP_WIN)
  nsCOMPtr<nsIWidget> widget = GetTopLevelWidget();
  if (widget) {
    // Note that this call will probably cause a sync native message to the
    // process that owns the child window.
    widget->SetNativeData(NS_NATIVE_CHILD_OF_SHAREABLE_WINDOW, aChildWindow);
  }
  return true;
#else
  NS_NOTREACHED(
    "TabParent::RecvSetNativeChildOfShareableWindow not implemented!");
  return false;
#endif
}

bool
TabParent::RecvDispatchFocusToTopLevelWindow()
{
  nsCOMPtr<nsIWidget> widget = GetTopLevelWidget();
  if (widget) {
    widget->SetFocus(false);
  }
  return true;
}

bool
TabParent::ReceiveMessage(const nsString& aMessage,
                          bool aSync,
                          StructuredCloneData* aData,
                          CpowHolder* aCpows,
                          nsIPrincipal* aPrincipal,
                          nsTArray<StructuredCloneData>* aRetVal)
{
  RefPtr<nsFrameLoader> frameLoader = GetFrameLoader(true);
  if (frameLoader && frameLoader->GetFrameMessageManager()) {
    RefPtr<nsFrameMessageManager> manager =
      frameLoader->GetFrameMessageManager();

    manager->ReceiveMessage(mFrameElement,
                            frameLoader,
                            aMessage,
                            aSync,
                            aData,
                            aCpows,
                            aPrincipal,
                            aRetVal);
  }
  return true;
}

// nsIAuthPromptProvider

// This method is largely copied from nsDocShell::GetAuthPrompt
NS_IMETHODIMP
TabParent::GetAuthPrompt(uint32_t aPromptReason, const nsIID& iid,
                          void** aResult)
{
  // we're either allowing auth, or it's a proxy request
  nsresult rv;
  nsCOMPtr<nsIPromptFactory> wwatch =
    do_GetService(NS_WINDOWWATCHER_CONTRACTID, &rv);
  NS_ENSURE_SUCCESS(rv, rv);

  nsCOMPtr<nsPIDOMWindowOuter> window;
  nsCOMPtr<nsIContent> frame = do_QueryInterface(mFrameElement);
  if (frame)
    window = frame->OwnerDoc()->GetWindow();

  // Get an auth prompter for our window so that the parenting
  // of the dialogs works as it should when using tabs.
  nsCOMPtr<nsISupports> prompt;
  rv = wwatch->GetPrompt(window, iid, getter_AddRefs(prompt));
  NS_ENSURE_SUCCESS(rv, rv);

  nsCOMPtr<nsILoginManagerPrompter> prompter = do_QueryInterface(prompt);
  if (prompter) {
    nsCOMPtr<nsIDOMElement> browser = do_QueryInterface(mFrameElement);
    prompter->SetBrowser(browser);
  }

  *aResult = prompt.forget().take();
  return NS_OK;
}

PColorPickerParent*
TabParent::AllocPColorPickerParent(const nsString& aTitle,
                                   const nsString& aInitialColor)
{
  return new ColorPickerParent(aTitle, aInitialColor);
}

bool
TabParent::DeallocPColorPickerParent(PColorPickerParent* actor)
{
  delete actor;
  return true;
}

PDatePickerParent*
TabParent::AllocPDatePickerParent(const nsString& aTitle,
                                  const nsString& aInitialDate)
{
  return new DatePickerParent(aTitle, aInitialDate);
}

bool
TabParent::DeallocPDatePickerParent(PDatePickerParent* actor)
{
  delete actor;
  return true;
}

PRenderFrameParent*
TabParent::AllocPRenderFrameParent()
{
  MOZ_ASSERT(ManagedPRenderFrameParent().IsEmpty());
  RefPtr<nsFrameLoader> frameLoader = GetFrameLoader();
  uint64_t layersId = 0;
  bool success = false;

  PRenderFrameParent* renderFrame =
    new RenderFrameParent(frameLoader, &success);
  if (success) {
    RenderFrameParent* rfp = static_cast<RenderFrameParent*>(renderFrame);
    layersId = rfp->GetLayersId();
    AddTabParentToTable(layersId, this);
  }
  return renderFrame;
}

bool
TabParent::DeallocPRenderFrameParent(PRenderFrameParent* aFrame)
{
  delete aFrame;
  return true;
}

bool
TabParent::SetRenderFrame(PRenderFrameParent* aRFParent)
{
  if (IsInitedByParent()) {
    return false;
  }

  RefPtr<nsFrameLoader> frameLoader = GetFrameLoader();

  if (!frameLoader) {
    return false;
  }

  RenderFrameParent* renderFrame = static_cast<RenderFrameParent*>(aRFParent);
  bool success = renderFrame->Init(frameLoader);
  if (!success) {
    return false;
  }

  uint64_t layersId = renderFrame->GetLayersId();
  AddTabParentToTable(layersId, this);

  return true;
}

bool
TabParent::GetRenderFrameInfo(TextureFactoryIdentifier* aTextureFactoryIdentifier,
                              uint64_t* aLayersId)
{
  RenderFrameParent* rfp = GetRenderFrame();
  if (!rfp) {
    return false;
  }

  *aLayersId = rfp->GetLayersId();
  rfp->GetTextureFactoryIdentifier(aTextureFactoryIdentifier);
  return true;
}

bool
TabParent::RecvAudioChannelActivityNotification(const uint32_t& aAudioChannel,
                                                const bool& aActive)
{
  if (aAudioChannel >= NUMBER_OF_AUDIO_CHANNELS) {
    return false;
  }

  nsCOMPtr<nsIObserverService> os = services::GetObserverService();
  if (os) {
    nsAutoCString topic;
    topic.Assign("audiochannel-activity-");
    topic.Append(AudioChannelService::GetAudioChannelTable()[aAudioChannel].tag);

    os->NotifyObservers(NS_ISUPPORTS_CAST(nsITabParent*, this),
                        topic.get(),
                        aActive ? u"active" : u"inactive");
  }

  return true;
}

already_AddRefed<nsFrameLoader>
TabParent::GetFrameLoader(bool aUseCachedFrameLoaderAfterDestroy) const
{
  if (mIsDestroyed && !aUseCachedFrameLoaderAfterDestroy) {
    return nullptr;
  }

  if (mFrameLoader) {
    RefPtr<nsFrameLoader> fl = mFrameLoader;
    return fl.forget();
  }
  nsCOMPtr<nsIFrameLoaderOwner> frameLoaderOwner = do_QueryInterface(mFrameElement);
  return frameLoaderOwner ? frameLoaderOwner->GetFrameLoader() : nullptr;
}

void
TabParent::TryCacheDPIAndScale()
{
  if (mDPI > 0) {
    return;
  }

  nsCOMPtr<nsIWidget> widget = GetWidget();

  if (widget) {
    mDPI = widget->GetDPI();
    mRounding = widget->RoundsWidgetCoordinatesTo();
    mDefaultScale = widget->GetDefaultScale();
  }
}

already_AddRefed<nsIWidget>
TabParent::GetWidget() const
{
  if (!mFrameElement) {
    return nullptr;
  }
  nsCOMPtr<nsIWidget> widget = nsContentUtils::WidgetForDocument(mFrameElement->OwnerDoc());
  return widget.forget();
}

void
TabParent::ApzAwareEventRoutingToChild(ScrollableLayerGuid* aOutTargetGuid,
                                       uint64_t* aOutInputBlockId,
                                       nsEventStatus* aOutApzResponse)
{
  // Let the widget know that the event will be sent to the child process,
  // which will (hopefully) send a confirmation notice back to APZ.
  // Do this even if APZ is off since we need it for swipe gesture support on
  // OS X without APZ.
  InputAPZContext::SetRoutedToChildProcess();

  if (AsyncPanZoomEnabled()) {
    if (aOutTargetGuid) {
      *aOutTargetGuid = InputAPZContext::GetTargetLayerGuid();

      // There may be cases where the APZ hit-testing code came to a different
      // conclusion than the main-thread hit-testing code as to where the event
      // is destined. In such cases the layersId of the APZ result may not match
      // the layersId of this renderframe. In such cases the main-thread hit-
      // testing code "wins" so we need to update the guid to reflect this.
      if (RenderFrameParent* rfp = GetRenderFrame()) {
        if (aOutTargetGuid->mLayersId != rfp->GetLayersId()) {
          *aOutTargetGuid = ScrollableLayerGuid(rfp->GetLayersId(), 0, FrameMetrics::NULL_SCROLL_ID);
        }
      }
    }
    if (aOutInputBlockId) {
      *aOutInputBlockId = InputAPZContext::GetInputBlockId();
    }
    if (aOutApzResponse) {
      *aOutApzResponse = InputAPZContext::GetApzResponse();
    }
  } else {
    if (aOutInputBlockId) {
      *aOutInputBlockId = 0;
    }
    if (aOutApzResponse) {
      *aOutApzResponse = nsEventStatus_eIgnore;
    }
  }
}

bool
TabParent::RecvBrowserFrameOpenWindow(PBrowserParent* aOpener,
                                      PRenderFrameParent* aRenderFrame,
                                      const nsString& aURL,
                                      const nsString& aName,
                                      const nsString& aFeatures,
                                      bool* aOutWindowOpened,
                                      TextureFactoryIdentifier* aTextureFactoryIdentifier,
                                      uint64_t* aLayersId)
{
  BrowserElementParent::OpenWindowResult opened =
    BrowserElementParent::OpenWindowOOP(TabParent::GetFrom(aOpener),
                                        this, aRenderFrame, aURL, aName, aFeatures,
                                        aTextureFactoryIdentifier, aLayersId);
  *aOutWindowOpened = (opened == BrowserElementParent::OPEN_WINDOW_ADDED);
  if (!*aOutWindowOpened) {
    Destroy();
  }
  return true;
}

bool
TabParent::RecvRespondStartSwipeEvent(const uint64_t& aInputBlockId,
                                      const bool& aStartSwipe)
{
  if (nsCOMPtr<nsIWidget> widget = GetWidget()) {
    widget->ReportSwipeStarted(aInputBlockId, aStartSwipe);
  }
  return true;
}

already_AddRefed<nsILoadContext>
TabParent::GetLoadContext()
{
  nsCOMPtr<nsILoadContext> loadContext;
  if (mLoadContext) {
    loadContext = mLoadContext;
  } else {
    bool isPrivate = mChromeFlags & nsIWebBrowserChrome::CHROME_PRIVATE_WINDOW;
    SetPrivateBrowsingAttributes(isPrivate);
    loadContext = new LoadContext(GetOwnerElement(),
                                  true /* aIsContent */,
                                  isPrivate,
                                  mChromeFlags & nsIWebBrowserChrome::CHROME_REMOTE_WINDOW,
                                  OriginAttributesRef());
    mLoadContext = loadContext;
  }
  return loadContext.forget();
}

NS_IMETHODIMP
TabParent::GetUseAsyncPanZoom(bool* useAsyncPanZoom)
{
  *useAsyncPanZoom = AsyncPanZoomEnabled();
  return NS_OK;
}

// defined in nsITabParent
NS_IMETHODIMP
TabParent::SetDocShellIsActive(bool isActive)
{
  // Increment the epoch so that layer tree updates from previous
  // SetDocShellIsActive requests are ignored.
  mLayerTreeEpoch++;

  // docshell is consider prerendered only if not active yet
  mIsPrerendered &= !isActive;
  mDocShellIsActive = isActive;
  Unused << SendSetDocShellIsActive(isActive, mPreserveLayers, mLayerTreeEpoch);

  // Ask the child to repaint using the PHangMonitor channel/thread (which may
  // be less congested).
  if (isActive) {
    ContentParent* cp = Manager()->AsContentParent();
    cp->ForceTabPaint(this, mLayerTreeEpoch);
  }

  return NS_OK;
}

NS_IMETHODIMP
TabParent::GetDocShellIsActive(bool* aIsActive)
{
  *aIsActive = mDocShellIsActive;
  return NS_OK;
}

NS_IMETHODIMP
TabParent::GetIsPrerendered(bool* aIsPrerendered)
{
  *aIsPrerendered = mIsPrerendered;
  return NS_OK;
}

NS_IMETHODIMP
TabParent::PreserveLayers(bool aPreserveLayers)
{
  mPreserveLayers = aPreserveLayers;
  return NS_OK;
}

NS_IMETHODIMP
TabParent::SuppressDisplayport(bool aEnabled)
{
  if (IsDestroyed()) {
    return NS_OK;
  }

#ifdef DEBUG
  if (aEnabled) {
    mActiveSupressDisplayportCount++;
  } else {
    mActiveSupressDisplayportCount--;
  }
  MOZ_ASSERT(mActiveSupressDisplayportCount >= 0);
#endif

  Unused << SendSuppressDisplayport(aEnabled);
  return NS_OK;
}

NS_IMETHODIMP
TabParent::GetTabId(uint64_t* aId)
{
  *aId = GetTabId();
  return NS_OK;
}

NS_IMETHODIMP
TabParent::GetOsPid(int32_t* aId)
{
  *aId = Manager()->Pid();
  return NS_OK;
}

NS_IMETHODIMP
TabParent::GetHasContentOpener(bool* aResult)
{
  *aResult = mHasContentOpener;
  return NS_OK;
}

void
TabParent::SetHasContentOpener(bool aHasContentOpener)
{
  mHasContentOpener = aHasContentOpener;
}

NS_IMETHODIMP
TabParent::NavigateByKey(bool aForward, bool aForDocumentNavigation)
{
  Unused << SendNavigateByKey(aForward, aForDocumentNavigation);
  return NS_OK;
}

class LayerTreeUpdateRunnable final
  : public mozilla::Runnable
{
  uint64_t mLayersId;
  uint64_t mEpoch;
  bool mActive;

public:
  explicit LayerTreeUpdateRunnable(uint64_t aLayersId, uint64_t aEpoch, bool aActive)
    : mLayersId(aLayersId), mEpoch(aEpoch), mActive(aActive)
  {
    MOZ_ASSERT(!NS_IsMainThread());
  }

private:
  NS_IMETHOD Run() override {
    MOZ_ASSERT(NS_IsMainThread());
    if (RefPtr<TabParent> tabParent = TabParent::GetTabParentFromLayersId(mLayersId)) {
      tabParent->LayerTreeUpdate(mEpoch, mActive);
    }
    return NS_OK;
  }
};

void
TabParent::LayerTreeUpdate(uint64_t aEpoch, bool aActive)
{
  // Ignore updates from old epochs. They might tell us that layers are
  // available when we've already sent a message to clear them. We can't trust
  // the update in that case since layers could disappear anytime after that.
  if (aEpoch != mLayerTreeEpoch || mIsDestroyed) {
    return;
  }

  nsCOMPtr<mozilla::dom::EventTarget> target = do_QueryInterface(mFrameElement);
  if (!target) {
    NS_WARNING("Could not locate target for layer tree message.");
    return;
  }

  RefPtr<Event> event = NS_NewDOMEvent(mFrameElement, nullptr, nullptr);
  if (aActive) {
    event->InitEvent(NS_LITERAL_STRING("MozLayerTreeReady"), true, false);
  } else {
    event->InitEvent(NS_LITERAL_STRING("MozLayerTreeCleared"), true, false);
  }
  event->SetTrusted(true);
  event->WidgetEventPtr()->mFlags.mOnlyChromeDispatch = true;
  bool dummy;
  mFrameElement->DispatchEvent(event, &dummy);
}

bool
TabParent::RecvForcePaintNoOp(const uint64_t& aLayerObserverEpoch)
{
  // We sent a ForcePaint message when layers were already visible. In this
  // case, we should act as if an update occurred even though we already have
  // the layers.
  LayerTreeUpdate(aLayerObserverEpoch, true);
  return true;
}

bool
TabParent::RecvRemotePaintIsReady()
{
  nsCOMPtr<mozilla::dom::EventTarget> target = do_QueryInterface(mFrameElement);
  if (!target) {
    NS_WARNING("Could not locate target for MozAfterRemotePaint message.");
    return true;
  }

  RefPtr<Event> event = NS_NewDOMEvent(mFrameElement, nullptr, nullptr);
  event->InitEvent(NS_LITERAL_STRING("MozAfterRemotePaint"), false, false);
  event->SetTrusted(true);
  event->WidgetEventPtr()->mFlags.mOnlyChromeDispatch = true;
  bool dummy;
  mFrameElement->DispatchEvent(event, &dummy);
  return true;
}

mozilla::plugins::PPluginWidgetParent*
TabParent::AllocPPluginWidgetParent()
{
  return new mozilla::plugins::PluginWidgetParent();
}

bool
TabParent::DeallocPPluginWidgetParent(mozilla::plugins::PPluginWidgetParent* aActor)
{
  delete aActor;
  return true;
}

nsresult
TabParent::HandleEvent(nsIDOMEvent* aEvent)
{
  nsAutoString eventType;
  aEvent->GetType(eventType);

  if (eventType.EqualsLiteral("MozUpdateWindowPos") && !mIsDestroyed) {
    // This event is sent when the widget moved.  Therefore we only update
    // the position.
    return UpdatePosition();
  }
  return NS_OK;
}

class FakeChannel final : public nsIChannel,
                          public nsIAuthPromptCallback,
                          public nsIInterfaceRequestor,
                          public nsILoadContext
{
public:
  FakeChannel(const nsCString& aUri, uint64_t aCallbackId, Element* aElement)
    : mCallbackId(aCallbackId)
    , mElement(aElement)
  {
    NS_NewURI(getter_AddRefs(mUri), aUri);
  }

  NS_DECL_ISUPPORTS
#define NO_IMPL override { return NS_ERROR_NOT_IMPLEMENTED; }
  NS_IMETHOD GetName(nsACString&) NO_IMPL
  NS_IMETHOD IsPending(bool*) NO_IMPL
  NS_IMETHOD GetStatus(nsresult*) NO_IMPL
  NS_IMETHOD Cancel(nsresult) NO_IMPL
  NS_IMETHOD Suspend() NO_IMPL
  NS_IMETHOD Resume() NO_IMPL
  NS_IMETHOD GetLoadGroup(nsILoadGroup**) NO_IMPL
  NS_IMETHOD SetLoadGroup(nsILoadGroup*) NO_IMPL
  NS_IMETHOD SetLoadFlags(nsLoadFlags) NO_IMPL
  NS_IMETHOD GetLoadFlags(nsLoadFlags*) NO_IMPL
  NS_IMETHOD GetOriginalURI(nsIURI**) NO_IMPL
  NS_IMETHOD SetOriginalURI(nsIURI*) NO_IMPL
  NS_IMETHOD GetURI(nsIURI** aUri) override
  {
    nsCOMPtr<nsIURI> copy = mUri;
    copy.forget(aUri);
    return NS_OK;
  }
  NS_IMETHOD GetOwner(nsISupports**) NO_IMPL
  NS_IMETHOD SetOwner(nsISupports*) NO_IMPL
  NS_IMETHOD GetLoadInfo(nsILoadInfo** aLoadInfo) override
  {
    nsCOMPtr<nsILoadInfo> copy = mLoadInfo;
    copy.forget(aLoadInfo);
    return NS_OK;
  }
  NS_IMETHOD SetLoadInfo(nsILoadInfo* aLoadInfo) override
  {
    mLoadInfo = aLoadInfo;
    return NS_OK;
  }
  NS_IMETHOD GetNotificationCallbacks(nsIInterfaceRequestor** aRequestor) override
  {
    NS_ADDREF(*aRequestor = this);
    return NS_OK;
  }
  NS_IMETHOD SetNotificationCallbacks(nsIInterfaceRequestor*) NO_IMPL
  NS_IMETHOD GetSecurityInfo(nsISupports**) NO_IMPL
  NS_IMETHOD GetContentType(nsACString&) NO_IMPL
  NS_IMETHOD SetContentType(const nsACString&) NO_IMPL
  NS_IMETHOD GetContentCharset(nsACString&) NO_IMPL
  NS_IMETHOD SetContentCharset(const nsACString&) NO_IMPL
  NS_IMETHOD GetContentLength(int64_t*) NO_IMPL
  NS_IMETHOD SetContentLength(int64_t) NO_IMPL
  NS_IMETHOD Open(nsIInputStream**) NO_IMPL
  NS_IMETHOD Open2(nsIInputStream**) NO_IMPL
  NS_IMETHOD AsyncOpen(nsIStreamListener*, nsISupports*) NO_IMPL
  NS_IMETHOD AsyncOpen2(nsIStreamListener*) NO_IMPL
  NS_IMETHOD GetContentDisposition(uint32_t*) NO_IMPL
  NS_IMETHOD SetContentDisposition(uint32_t) NO_IMPL
  NS_IMETHOD GetContentDispositionFilename(nsAString&) NO_IMPL
  NS_IMETHOD SetContentDispositionFilename(const nsAString&) NO_IMPL
  NS_IMETHOD GetContentDispositionHeader(nsACString&) NO_IMPL
  NS_IMETHOD OnAuthAvailable(nsISupports *aContext, nsIAuthInformation *aAuthInfo) override;
  NS_IMETHOD OnAuthCancelled(nsISupports *aContext, bool userCancel) override;
  NS_IMETHOD GetInterface(const nsIID & uuid, void **result) override
  {
    return QueryInterface(uuid, result);
  }
  NS_IMETHOD GetAssociatedWindow(mozIDOMWindowProxy**) NO_IMPL
  NS_IMETHOD GetTopWindow(mozIDOMWindowProxy**) NO_IMPL
  NS_IMETHOD GetTopFrameElement(nsIDOMElement** aElement) override
  {
    nsCOMPtr<nsIDOMElement> elem = do_QueryInterface(mElement);
    elem.forget(aElement);
    return NS_OK;
  }
  NS_IMETHOD GetNestedFrameId(uint64_t*) NO_IMPL
  NS_IMETHOD GetIsContent(bool*) NO_IMPL
  NS_IMETHOD GetUsePrivateBrowsing(bool*) NO_IMPL
  NS_IMETHOD SetUsePrivateBrowsing(bool) NO_IMPL
  NS_IMETHOD SetPrivateBrowsing(bool) NO_IMPL
  NS_IMETHOD GetIsInIsolatedMozBrowserElement(bool*) NO_IMPL
  NS_IMETHOD GetAppId(uint32_t*) NO_IMPL
  NS_IMETHOD GetOriginAttributes(JS::MutableHandleValue) NO_IMPL
  NS_IMETHOD GetUseRemoteTabs(bool*) NO_IMPL
  NS_IMETHOD SetRemoteTabs(bool) NO_IMPL
  NS_IMETHOD IsTrackingProtectionOn(bool*) NO_IMPL
#undef NO_IMPL

protected:
  ~FakeChannel() {}

  nsCOMPtr<nsIURI> mUri;
  uint64_t mCallbackId;
  nsCOMPtr<Element> mElement;
  nsCOMPtr<nsILoadInfo> mLoadInfo;
};

NS_IMPL_ISUPPORTS(FakeChannel, nsIChannel, nsIAuthPromptCallback,
                  nsIRequest, nsIInterfaceRequestor, nsILoadContext);

bool
TabParent::RecvAsyncAuthPrompt(const nsCString& aUri,
                               const nsString& aRealm,
                               const uint64_t& aCallbackId)
{
  nsCOMPtr<nsIAuthPrompt2> authPrompt;
  GetAuthPrompt(nsIAuthPromptProvider::PROMPT_NORMAL,
                NS_GET_IID(nsIAuthPrompt2),
                getter_AddRefs(authPrompt));
  RefPtr<FakeChannel> channel = new FakeChannel(aUri, aCallbackId, mFrameElement);
  uint32_t promptFlags = nsIAuthInformation::AUTH_HOST;

  RefPtr<nsAuthInformationHolder> holder =
    new nsAuthInformationHolder(promptFlags, aRealm,
                                EmptyCString());

  uint32_t level = nsIAuthPrompt2::LEVEL_NONE;
  nsCOMPtr<nsICancelable> dummy;
  nsresult rv =
    authPrompt->AsyncPromptAuth(channel, channel, nullptr,
                                level, holder, getter_AddRefs(dummy));

  return rv == NS_OK;
}

bool
TabParent::RecvInvokeDragSession(nsTArray<IPCDataTransfer>&& aTransfers,
                                 const uint32_t& aAction,
                                 const OptionalShmem& aVisualDnDData,
                                 const uint32_t& aStride, const uint8_t& aFormat,
                                 const LayoutDeviceIntRect& aDragRect)
{
  mInitialDataTransferItems.Clear();
  nsIPresShell* shell = mFrameElement->OwnerDoc()->GetShell();
  if (!shell) {
    if (Manager()->IsContentParent()) {
      Unused << Manager()->AsContentParent()->SendEndDragSession(true, true,
                                                                 LayoutDeviceIntPoint());
    }
    return true;
  }

  EventStateManager* esm = shell->GetPresContext()->EventStateManager();
  for (uint32_t i = 0; i < aTransfers.Length(); ++i) {
    mInitialDataTransferItems.AppendElement(mozilla::Move(aTransfers[i].items()));
  }
  if (Manager()->IsContentParent()) {
    nsCOMPtr<nsIDragService> dragService =
      do_GetService("@mozilla.org/widget/dragservice;1");
    if (dragService) {
      dragService->MaybeAddChildProcess(Manager()->AsContentParent());
    }
  }

  if (aVisualDnDData.type() == OptionalShmem::Tvoid_t ||
      !aVisualDnDData.get_Shmem().IsReadable() ||
      aVisualDnDData.get_Shmem().Size<char>() < aDragRect.height * aStride) {
    mDnDVisualization = nullptr;
  } else {
    mDnDVisualization =
        gfx::CreateDataSourceSurfaceFromData(gfx::IntSize(aDragRect.width, aDragRect.height),
                                             static_cast<gfx::SurfaceFormat>(aFormat),
                                             aVisualDnDData.get_Shmem().get<uint8_t>(),
                                             aStride);
  }

  mDragValid = true;
  mDragRect = aDragRect;

  esm->BeginTrackingRemoteDragGesture(mFrameElement);

  if (aVisualDnDData.type() == OptionalShmem::TShmem) {
    Unused << DeallocShmem(aVisualDnDData);
  }

  return true;
}

void
TabParent::AddInitialDnDDataTo(DataTransfer* aDataTransfer)
{
  for (uint32_t i = 0; i < mInitialDataTransferItems.Length(); ++i) {
    nsTArray<IPCDataTransferItem>& itemArray = mInitialDataTransferItems[i];
    for (auto& item : itemArray) {
      RefPtr<nsVariantCC> variant = new nsVariantCC();
      // Special case kFilePromiseMime so that we get the right
      // nsIFlavorDataProvider for it.
      if (item.flavor().EqualsLiteral(kFilePromiseMime)) {
        RefPtr<nsISupports> flavorDataProvider =
          new nsContentAreaDragDropDataProvider();
        variant->SetAsISupports(flavorDataProvider);
      } else if (item.data().type() == IPCDataTransferData::TnsString) {
        variant->SetAsAString(item.data().get_nsString());
      } else if (item.data().type() == IPCDataTransferData::TPBlobParent) {
        auto* parent = static_cast<BlobParent*>(item.data().get_PBlobParent());
        RefPtr<BlobImpl> impl = parent->GetBlobImpl();
        variant->SetAsISupports(impl);
      } else if (item.data().type() == IPCDataTransferData::TShmem) {
        if (nsContentUtils::IsFlavorImage(item.flavor())) {
          // An image! Get the imgIContainer for it and set it in the variant.
          nsCOMPtr<imgIContainer> imageContainer;
          nsresult rv =
            nsContentUtils::DataTransferItemToImage(item,
                                                    getter_AddRefs(imageContainer));
          if (NS_FAILED(rv)) {
            continue;
          }
          variant->SetAsISupports(imageContainer);
        } else {
          Shmem data = item.data().get_Shmem();
          variant->SetAsACString(nsDependentCString(data.get<char>(), data.Size<char>()));
        }

        mozilla::Unused << DeallocShmem(item.data().get_Shmem());
      }

      // Using system principal here, since once the data is on parent process
      // side, it can be handled as being from browser chrome or OS.

      // We set aHidden to false, as we don't need to worry about hiding data
      // from content in the parent process where there is no content.
      // XXX: Nested Content Processes may change this
      aDataTransfer->SetDataWithPrincipalFromOtherProcess(NS_ConvertUTF8toUTF16(item.flavor()),
                                                          variant, i,
                                                          nsContentUtils::GetSystemPrincipal(),
                                                          /* aHidden = */ false);
    }
  }
  mInitialDataTransferItems.Clear();
}

bool
TabParent::TakeDragVisualization(RefPtr<mozilla::gfx::SourceSurface>& aSurface,
                                 LayoutDeviceIntRect* aDragRect)
{
  if (!mDragValid)
    return false;

  aSurface = mDnDVisualization.forget();
  *aDragRect = mDragRect;
  mDragValid = false;
  return true;
}

bool
TabParent::AsyncPanZoomEnabled() const
{
  nsCOMPtr<nsIWidget> widget = GetWidget();
  return widget && widget->AsyncPanZoomEnabled();
}

NS_IMETHODIMP
TabParent::StartPersistence(uint64_t aOuterWindowID,
                            nsIWebBrowserPersistDocumentReceiver* aRecv)
{
  nsCOMPtr<nsIContentParent> manager = Manager();
  if (!manager->IsContentParent()) {
    return NS_ERROR_UNEXPECTED;
  }
  auto* actor = new WebBrowserPersistDocumentParent();
  actor->SetOnReady(aRecv);
  return manager->AsContentParent()
    ->SendPWebBrowserPersistDocumentConstructor(actor, this, aOuterWindowID)
    ? NS_OK : NS_ERROR_FAILURE;
  // (The actor will be destroyed on constructor failure.)
}

ShowInfo
TabParent::GetShowInfo()
{
  TryCacheDPIAndScale();
  if (mFrameElement) {
    nsAutoString name;
    mFrameElement->GetAttr(kNameSpaceID_None, nsGkAtoms::name, name);
    bool allowFullscreen =
      mFrameElement->HasAttr(kNameSpaceID_None, nsGkAtoms::allowfullscreen) ||
      mFrameElement->HasAttr(kNameSpaceID_None, nsGkAtoms::mozallowfullscreen);
    bool isPrivate = mFrameElement->HasAttr(kNameSpaceID_None, nsGkAtoms::mozprivatebrowsing);
    bool isTransparent =
      nsContentUtils::IsChromeDoc(mFrameElement->OwnerDoc()) &&
      mFrameElement->HasAttr(kNameSpaceID_None, nsGkAtoms::transparent);
    return ShowInfo(name, allowFullscreen, isPrivate, false,
                    isTransparent, mDPI, mRounding, mDefaultScale.scale);
  }

  return ShowInfo(EmptyString(), false, false, false,
                  false, mDPI, mRounding, mDefaultScale.scale);
}

void
TabParent::AudioChannelChangeNotification(nsPIDOMWindowOuter* aWindow,
                                          AudioChannel aAudioChannel,
                                          float aVolume,
                                          bool aMuted)
{
  if (!mFrameElement || !mFrameElement->OwnerDoc()) {
    return;
  }

  nsCOMPtr<nsPIDOMWindowOuter> window = mFrameElement->OwnerDoc()->GetWindow();
  while (window) {
    if (window == aWindow) {
      Unused << SendAudioChannelChangeNotification(static_cast<uint32_t>(aAudioChannel),
                                                   aVolume, aMuted);
      break;
    }

    nsCOMPtr<nsPIDOMWindowOuter> win = window->GetScriptableParentOrNull();
    if (!win) {
      break;
    }

    window = win;
  }
}

bool
TabParent::RecvGetTabCount(uint32_t* aValue)
{
  *aValue = 0;

  nsCOMPtr<nsIXULBrowserWindow> xulBrowserWindow = GetXULBrowserWindow();
  NS_ENSURE_TRUE(xulBrowserWindow, true);

  uint32_t tabCount;
  nsresult rv = xulBrowserWindow->GetTabCount(&tabCount);
  NS_ENSURE_SUCCESS(rv, true);

  *aValue = tabCount;
  return true;
}

bool
TabParent::RecvLookUpDictionary(const nsString& aText,
                                nsTArray<FontRange>&& aFontRangeArray,
                                const bool& aIsVertical,
                                const LayoutDeviceIntPoint& aPoint)
{
  nsCOMPtr<nsIWidget> widget = GetWidget();
  if (!widget) {
    return true;
  }

  widget->LookUpDictionary(aText, aFontRangeArray, aIsVertical,
                           aPoint - GetChildProcessOffset());
  return true;
}

bool
TabParent::RecvNotifySessionHistoryChange(const uint32_t& aCount)
{
  RefPtr<nsFrameLoader> frameLoader(GetFrameLoader());
  if (!frameLoader) {
    // FrameLoader can be nullptr if the it is destroying.
    // In this case session history change can simply be ignored.
    return true;
  }

  nsCOMPtr<nsIPartialSHistory> partialHistory;
  frameLoader->GetPartialSessionHistory(getter_AddRefs(partialHistory));
  if (!partialHistory) {
    // PartialSHistory is not enabled
    return true;
  }

  partialHistory->OnSessionHistoryChange(aCount);
  return true;
}

bool
TabParent::RecvRequestCrossBrowserNavigation(const uint32_t& aGlobalIndex)
{
  RefPtr<nsFrameLoader> frameLoader(GetFrameLoader());
  if (!frameLoader) {
    // FrameLoader can be nullptr if the it is destroying.
    // In this case we can ignore the request.
    return true;
  }

  return NS_SUCCEEDED(frameLoader->RequestGroupedHistoryNavigation(aGlobalIndex));
}

NS_IMETHODIMP
FakeChannel::OnAuthAvailable(nsISupports *aContext, nsIAuthInformation *aAuthInfo)
{
  nsAuthInformationHolder* holder =
    static_cast<nsAuthInformationHolder*>(aAuthInfo);

  if (!net::gNeckoChild->SendOnAuthAvailable(mCallbackId,
                                             holder->User(),
                                             holder->Password(),
                                             holder->Domain())) {
    return NS_ERROR_FAILURE;
  }
  return NS_OK;
}

NS_IMETHODIMP
FakeChannel::OnAuthCancelled(nsISupports *aContext, bool userCancel)
{
  if (!net::gNeckoChild->SendOnAuthCancelled(mCallbackId, userCancel)) {
    return NS_ERROR_FAILURE;
  }
  return NS_OK;
}


} // namespace dom
} // namespace mozilla
