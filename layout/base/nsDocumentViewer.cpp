/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* container for a document and its presentation */

#include "gfxContext.h"
#include "mozilla/PresShell.h"
#include "mozilla/PresShellWidgetListener.h"
#include "mozilla/RestyleManager.h"
#include "mozilla/ServoStyleSet.h"
#include "mozilla/dom/AutoSuppressEventHandlingAndSuspend.h"
#include "mozilla/dom/BeforeUnloadEvent.h"
#include "mozilla/dom/BrowsingContext.h"
#include "mozilla/dom/Document.h"
#include "mozilla/dom/DocumentInlines.h"
#include "mozilla/dom/FragmentDirective.h"
#include "mozilla/dom/PopupBlocker.h"
#include "mozilla/dom/Selection.h"
#include "mozilla/widget/Screen.h"
#include "nsCOMPtr.h"
#include "nsContentUtils.h"
#include "nsDeviceContext.h"
#include "nsFrameSelection.h"
#include "nsGenericHTMLElement.h"
#include "nsIContent.h"
#include "nsIDocumentViewer.h"
#include "nsIDocumentViewerPrint.h"
#include "nsIFrame.h"
#include "nsIScreen.h"
#include "nsISelectionListener.h"
#include "nsPresContext.h"
#include "nsReadableUtils.h"
#include "nsStubMutationObserver.h"
#include "nsSubDocumentFrame.h"
#include "nsThreadUtils.h"
#include "nscore.h"
#ifdef ACCESSIBILITY
#  include "mozilla/a11y/DocAccessible.h"
#endif
#include "imgIContainer.h"  // image animation mode constants
#include "mozilla/BasicEvents.h"
#include "mozilla/Encoding.h"
#include "mozilla/ErrorResult.h"
#include "mozilla/Preferences.h"
#include "mozilla/ReflowInput.h"
#include "mozilla/ScrollContainerFrame.h"
#include "mozilla/SpinEventLoopUntil.h"
#include "mozilla/StaticPrefs_dom.h"
#include "mozilla/StaticPrefs_fission.h"
#include "mozilla/StaticPrefs_javascript.h"
#include "mozilla/StaticPrefs_print.h"
#include "mozilla/StyleSheet.h"
#include "mozilla/StyleSheetInlines.h"
#include "mozilla/ThrottledEventQueue.h"
#include "mozilla/Try.h"
#include "mozilla/WeakPtr.h"
#include "mozilla/css/Loader.h"
#include "nsCharsetSource.h"
#include "nsCopySupport.h"
#include "nsDOMNavigationTiming.h"
#include "nsDocShell.h"
#include "nsFocusManager.h"
#include "nsGlobalWindowInner.h"
#include "nsGlobalWindowOuter.h"
#include "nsIBaseWindow.h"
#include "nsIClipboard.h"
#include "nsIClipboardHelper.h"
#include "nsIDocumentViewerEdit.h"
#include "nsIImageLoadingContent.h"
#include "nsIInterfaceRequestor.h"
#include "nsIInterfaceRequestorUtils.h"
#include "nsILayoutHistoryState.h"
#include "nsILoadContext.h"
#include "nsIPromptCollection.h"
#include "nsIPromptService.h"
#include "nsIXULRuntime.h"
#include "nsJSEnvironment.h"
#include "nsNetUtil.h"
#include "nsPIDOMWindow.h"
#include "nsPIWindowRoot.h"
#include "nsPageSequenceFrame.h"
#include "nsSandboxFlags.h"
#include "nsStyleSheetService.h"
#include "nsXULPopupManager.h"

//--------------------------
// Printing Include
//---------------------------
#ifdef NS_PRINTING

#  include "nsDeviceContextSpecProxy.h"
#  include "nsIWebBrowserPrint.h"
#  include "nsPrintJob.h"

// Print Options
#  include "nsIPrintSettings.h"
#  include "nsIPrintSettingsService.h"
#  include "nsISimpleEnumerator.h"

#endif  // NS_PRINTING

// focus
#include "mozilla/EventDispatcher.h"
#include "mozilla/dom/SessionHistoryEntry.h"
#include "mozilla/dom/XMLHttpRequestMainThread.h"
#include "nsIDOMEventListener.h"
#include "nsISHEntry.h"
#include "nsISHistory.h"
#include "nsISelectionController.h"
#include "nsIWebNavigation.h"

// paint forcing
#include <stdio.h>

#include "mozilla/BasePrincipal.h"
#include "mozilla/dom/Element.h"
#include "mozilla/dom/Event.h"
#include "mozilla/dom/ScriptLoader.h"
#include "mozilla/dom/WindowGlobalChild.h"

namespace mozilla::dom {
class PrintPreviewResultInfo;
}  // namespace mozilla::dom

using namespace mozilla;
using namespace mozilla::dom;

using mozilla::layout::RemotePrintJobChild;
using PrintPreviewResolver =
    std::function<void(const mozilla::dom::PrintPreviewResultInfo&)>;

//-----------------------------------------------------
// LOGGING
#include "LayoutLogging.h"
#include "mozilla/Logging.h"

extern mozilla::LazyLogModule gPageCacheLog;

#ifdef NS_PRINTING
mozilla::LazyLogModule gPrintingLog("printing");

#  define PR_PL(_p1) MOZ_LOG(gPrintingLog, mozilla::LogLevel::Debug, _p1);
#endif  // NS_PRINTING

#define PRT_YESNO(_p) ((_p) ? "YES" : "NO")
//-----------------------------------------------------

class nsDocumentViewer;

// a small delegate class used to avoid circular references

class nsDocViewerSelectionListener final : public nsISelectionListener {
 public:
  // nsISupports interface...
  NS_DECL_ISUPPORTS

  // nsISelectionListerner interface
  NS_DECL_NSISELECTIONLISTENER

  explicit nsDocViewerSelectionListener(nsDocumentViewer* aDocViewer)
      : mDocViewer(aDocViewer), mSelectionWasCollapsed(true) {}

  void Disconnect() { mDocViewer = nullptr; }

 protected:
  virtual ~nsDocViewerSelectionListener() = default;

  nsDocumentViewer* mDocViewer;
  bool mSelectionWasCollapsed;
};

namespace viewer_detail {

/**
 * Mutation observer for use until we hand ourselves over to our SHEntry.
 */
class BFCachePreventionObserver final : public nsStubMutationObserver {
 public:
  explicit BFCachePreventionObserver(Document* aDocument)
      : mDocument(aDocument) {}

  NS_DECL_ISUPPORTS

  NS_DECL_NSIMUTATIONOBSERVER_CHARACTERDATACHANGED
  NS_DECL_NSIMUTATIONOBSERVER_ATTRIBUTECHANGED
  NS_DECL_NSIMUTATIONOBSERVER_CONTENTAPPENDED
  NS_DECL_NSIMUTATIONOBSERVER_CONTENTINSERTED
  NS_DECL_NSIMUTATIONOBSERVER_CONTENTREMOVED
  NS_DECL_NSIMUTATIONOBSERVER_NODEWILLBEDESTROYED

  // Stop observing the document.
  void Disconnect();

 private:
  ~BFCachePreventionObserver() = default;

  // Helper for the work that needs to happen when mutations happen.
  void MutationHappened();

  Document* mDocument;  // Weak; we get notified if it dies
};

NS_IMPL_ISUPPORTS(BFCachePreventionObserver, nsIMutationObserver)

void BFCachePreventionObserver::CharacterDataChanged(
    nsIContent* aContent, const CharacterDataChangeInfo&) {
  if (aContent->IsInNativeAnonymousSubtree()) {
    return;
  }
  MutationHappened();
}

void BFCachePreventionObserver::AttributeChanged(Element* aElement,
                                                 int32_t aNameSpaceID,
                                                 nsAtom* aAttribute,
                                                 AttrModType,
                                                 const nsAttrValue* aOldValue) {
  if (aElement->IsInNativeAnonymousSubtree()) {
    return;
  }
  MutationHappened();
}

void BFCachePreventionObserver::ContentAppended(nsIContent* aFirstNewContent,
                                                const ContentAppendInfo&) {
  if (aFirstNewContent->IsInNativeAnonymousSubtree()) {
    return;
  }
  MutationHappened();
}

void BFCachePreventionObserver::ContentInserted(nsIContent* aChild,
                                                const ContentInsertInfo&) {
  if (aChild->IsInNativeAnonymousSubtree()) {
    return;
  }
  MutationHappened();
}

void BFCachePreventionObserver::ContentWillBeRemoved(nsIContent* aChild,
                                                     const ContentRemoveInfo&) {
  if (aChild->IsInNativeAnonymousSubtree()) {
    return;
  }
  MutationHappened();
}

void BFCachePreventionObserver::NodeWillBeDestroyed(nsINode* aNode) {
  mDocument = nullptr;
}

void BFCachePreventionObserver::Disconnect() {
  if (mDocument) {
    mDocument->RemoveMutationObserver(this);
    // It will no longer tell us when it goes away, so make sure we're
    // not holding a dangling ref.
    mDocument = nullptr;
  }
}

void BFCachePreventionObserver::MutationHappened() {
  MOZ_ASSERT(
      mDocument,
      "How can we not have a document but be getting notified for mutations?");
  mDocument->DisallowBFCaching();
  Disconnect();
}

}  // namespace viewer_detail

using viewer_detail::BFCachePreventionObserver;

//-------------------------------------------------------------
class nsDocumentViewer final : public nsIDocumentViewer,
                               public nsIDocumentViewerEdit,
                               public nsIDocumentViewerPrint
#ifdef NS_PRINTING
    ,
                               public nsIWebBrowserPrint
#endif

{
  friend class nsDocViewerSelectionListener;
  friend class nsPagePrintTimer;
  friend class nsPrintJob;

 public:
  nsDocumentViewer();

  // nsISupports interface...
  NS_DECL_ISUPPORTS

  // nsIDocumentViewer interface...
  NS_DECL_NSIDOCUMENTVIEWER

  // nsIDocumentViewerEdit
  NS_DECL_NSIDOCUMENTVIEWEREDIT

#ifdef NS_PRINTING
  // nsIWebBrowserPrint
  NS_DECL_NSIWEBBROWSERPRINT
#endif

  // nsIDocumentViewerPrint Printing Methods
  NS_DECL_NSIDOCUMENTVIEWERPRINT

 protected:
  virtual ~nsDocumentViewer();

 private:
  void MakeWindow();
  void CreateDeviceContext(nsSubDocumentFrame* aContainerFrame);

  /**
   * If aDoCreation is true, this creates the device context, creates a
   * prescontext if necessary, and calls MakeWindow.
   *
   * If aForceSetNewDocument is false, then SetNewDocument won't be
   * called if the window's current document is already mDocument.
   *
   * FIXME(emilio): aNeedMakeCX makes no sense, it only influences whether
   * aDoInitialReflow is true.
   */
  nsresult InitInternal(nsIWidget* aParentWidget,
                        mozilla::dom::WindowGlobalChild* aActor,
                        const LayoutDeviceIntRect& aBounds, bool aDoCreation,
                        bool aNeedMakeCX = true,
                        bool aForceSetNewDocument = true);
  /**
   * @param aDoInitialReflow set to true if you want to kick off the initial
   * reflow
   */
  MOZ_CAN_RUN_SCRIPT_BOUNDARY
  nsresult InitPresentationStuff(bool aDoInitialReflow);

  already_AddRefed<nsINode> GetPopupNode();
  already_AddRefed<nsINode> GetPopupLinkNode();
  already_AddRefed<nsIImageLoadingContent> GetPopupImageNode();

  void PrepareToStartLoad();
  bool ShouldHaveGalleyPresentation() const;

  nsresult SyncParentSubDocMap();

  mozilla::dom::Selection* GetDocumentSelection();

  void DestroyPresShell();
  void DestroyPresContext();

  void InvalidatePotentialSubDocDisplayItem();

  std::tuple<const nsIFrame*, int32_t> GetCurrentSheetFrameAndNumber() const;

 protected:
  // This will make mPresShell stop listener to any widget it's currently
  // listening to, and start listening to mWindow for events. Note that
  // the previous mWindow listener might be kept around as the
  // PreviouslyAttachedWidgetListener so that we are able to paint the old page
  // while the new one loads.
  void AttachToTopLevelWidget();
  void DetachFromTopLevelWidget();

  // IMPORTANT: The ownership implicit in the following member
  // variables has been explicitly checked and set using nsCOMPtr
  // for owning pointers and raw COM interface pointers for weak
  // (ie, non owning) references. If you add any members to this
  // class, please make the ownership explicit (pinkerton, scc).

  WeakPtr<nsDocShell> mContainer;          // it owns me!
  RefPtr<nsDeviceContext> mDeviceContext;  // We create and own this baby

  // the following six items are explicitly in this order
  // so they will be destroyed in the reverse order (pinkerton, scc)
  nsCOMPtr<Document> mDocument;
  nsCOMPtr<nsIWidget> mWindow;  // may be null
  RefPtr<nsPresContext> mPresContext;
  RefPtr<PresShell> mPresShell;

  RefPtr<nsDocViewerSelectionListener> mSelectionListener;

  nsCOMPtr<nsIDocumentViewer> mPreviousViewer;
  // Observer that will prevent bfcaching if it gets notified.  This
  // is non-null precisely when mSHEntry is non-null.
  RefPtr<BFCachePreventionObserver> mBFCachePreventionObserver;

  nsIWidget* mParentWidget;  // purposely won't be ref counted.  May be null

  LayoutDeviceIntRect mBounds;

  int16_t mNumURLStarts;
  int16_t mDestroyBlockedCount;

  unsigned mStopped : 1;
  unsigned mLoaded : 1;
  unsigned mDeferredWindowClose : 1;
  // document management data
  //   these items are specific to markup documents (html and xml)
  //   may consider splitting these out into a subclass
  unsigned mIsSticky : 1;
  unsigned mInPermitUnload : 1;
  unsigned mInPermitUnloadPrompt : 1;

#ifdef NS_PRINTING
  unsigned mClosingWhilePrinting : 1;
  unsigned mCloseWindowAfterPrint : 1;

  RefPtr<nsPrintJob> mPrintJob;
#endif  // NS_PRINTING

  /* character set member data */
  int32_t mReloadEncodingSource;
  const Encoding* mReloadEncoding;

  bool mInitializedForPrintPreview;
  bool mHidden;
};

class nsDocumentShownDispatcher : public Runnable {
 public:
  explicit nsDocumentShownDispatcher(nsCOMPtr<Document> aDocument)
      : Runnable("nsDocumentShownDispatcher"), mDocument(aDocument) {}

  NS_IMETHOD Run() override;

 private:
  nsCOMPtr<Document> mDocument;
};

//------------------------------------------------------------------
// nsDocumentViewer
//------------------------------------------------------------------

//------------------------------------------------------------------
already_AddRefed<nsIDocumentViewer> NS_NewDocumentViewer() {
  return MakeAndAddRef<nsDocumentViewer>();
}

void nsDocumentViewer::PrepareToStartLoad() {
  MOZ_DIAGNOSTIC_ASSERT(!GetIsPrintPreview(),
                        "Print preview tab should never navigate");

  mStopped = false;
  mLoaded = false;
  mDeferredWindowClose = false;

#ifdef NS_PRINTING
  mClosingWhilePrinting = false;

  // Make sure we have destroyed it and cleared the data member
  if (RefPtr job = std::move(mPrintJob)) {
    job->Destroy();
  }

#endif  // NS_PRINTING
}

bool nsDocumentViewer::ShouldHaveGalleyPresentation() const {
  if (!mDocument) {
    return false;
  }
#ifdef NS_PRINTING
  if (mPrintJob) {
    // When getting printed, either for print or print preview, the print job
    // takes care of setting up the presentation of the document.
    return false;
  }
#endif
  return true;
}

nsDocumentViewer::nsDocumentViewer()
    : mParentWidget(nullptr),
      mNumURLStarts(0),
      mDestroyBlockedCount(0),
      mStopped(false),
      mLoaded(false),
      mDeferredWindowClose(false),
      mIsSticky(true),
      mInPermitUnload(false),
      mInPermitUnloadPrompt(false),
#ifdef NS_PRINTING
      mClosingWhilePrinting(false),
      mCloseWindowAfterPrint(false),
#endif  // NS_PRINTING
      mReloadEncodingSource(kCharsetUninitialized),
      mReloadEncoding(nullptr),
      mInitializedForPrintPreview(false),
      mHidden(false) {
  PrepareToStartLoad();
}

NS_IMPL_ADDREF(nsDocumentViewer)
NS_IMPL_RELEASE(nsDocumentViewer)

NS_INTERFACE_MAP_BEGIN(nsDocumentViewer)
  NS_INTERFACE_MAP_ENTRY(nsIDocumentViewer)
  NS_INTERFACE_MAP_ENTRY(nsIDocumentViewerEdit)
  NS_INTERFACE_MAP_ENTRY(nsIDocumentViewerPrint)
  NS_INTERFACE_MAP_ENTRY_AMBIGUOUS(nsISupports, nsIDocumentViewer)
#ifdef NS_PRINTING
  NS_INTERFACE_MAP_ENTRY(nsIWebBrowserPrint)
#endif
NS_INTERFACE_MAP_END

nsDocumentViewer::~nsDocumentViewer() {
  if (mDocument) {
    Close();
    nsCOMPtr doc = std::move(mDocument);
    doc->Destroy();
  }

#ifdef NS_PRINTING
  if (RefPtr job = std::move(mPrintJob)) {
    job->Destroy();
  }
#endif

  MOZ_RELEASE_ASSERT(mDestroyBlockedCount == 0);
  NS_ASSERTION(!mPresShell && !mPresContext,
               "User did not call nsIDocumentViewer::Destroy");
  if (mPresShell || mPresContext) {
    Destroy();
  }

  if (mSelectionListener) {
    mSelectionListener->Disconnect();
  }

  // XXX(?) Revoke pending invalidate events
}

/*
 * This method is called by the Document Loader once a document has
 * been created for a particular data stream...  The content viewer
 * must cache this document for later use when Init(...) is called.
 *
 * This method is also called when an out of band document.write() happens.
 * In that case, the document passed in is the same as the previous document.
 */
/* virtual */
void nsDocumentViewer::LoadStart(Document* aDocument) {
  MOZ_ASSERT(aDocument);

  if (!mDocument) {
    mDocument = aDocument;
  }
}

nsresult nsDocumentViewer::SyncParentSubDocMap() {
  nsCOMPtr<nsIDocShell> docShell(mContainer);
  if (!docShell) {
    return NS_OK;
  }

  nsCOMPtr<nsPIDOMWindowOuter> pwin(docShell->GetWindow());
  if (!mDocument || !pwin) {
    return NS_OK;
  }

  nsCOMPtr<Element> element = pwin->GetFrameElementInternal();
  if (!element) {
    return NS_OK;
  }

  nsCOMPtr<nsIDocShellTreeItem> parent;
  docShell->GetInProcessParent(getter_AddRefs(parent));

  nsCOMPtr<nsPIDOMWindowOuter> parent_win =
      parent ? parent->GetWindow() : nullptr;
  if (!parent_win) {
    return NS_OK;
  }

  nsCOMPtr<Document> parent_doc = parent_win->GetDoc();
  if (!parent_doc) {
    return NS_OK;
  }

  if (mDocument && parent_doc->GetSubDocumentFor(element) != mDocument &&
      parent_doc->EventHandlingSuppressed()) {
    mDocument->SuppressEventHandling(parent_doc->EventHandlingSuppressed());
  }
  return parent_doc->SetSubDocumentFor(element, mDocument);
}

NS_IMETHODIMP
nsDocumentViewer::SetContainer(nsIDocShell* aContainer) {
  mContainer = static_cast<nsDocShell*>(aContainer);

  // We're loading a new document into the window where this document
  // viewer lives, sync the parent document's frame element -> sub
  // document map

  return SyncParentSubDocMap();
}

NS_IMETHODIMP
nsDocumentViewer::GetContainer(nsIDocShell** aResult) {
  NS_ENSURE_ARG_POINTER(aResult);

  nsCOMPtr<nsIDocShell> container(mContainer);
  container.swap(*aResult);
  return NS_OK;
}

NS_IMETHODIMP
nsDocumentViewer::Init(nsIWidget* aParentWidget,
                       const LayoutDeviceIntRect& aBounds,
                       WindowGlobalChild* aActor) {
  return InitInternal(aParentWidget, aActor, aBounds, true);
}

nsresult nsDocumentViewer::InitPresentationStuff(bool aDoInitialReflow) {
  // We assert this because initializing the pres shell could otherwise cause
  // re-entrancy into nsDocumentViewer methods, which might cause a different
  // pres shell to be created.  Callers of InitPresentationStuff should ensure
  // the call is appropriately bounded by an nsAutoScriptBlocker to decide
  // when it is safe for these re-entrant calls to be made.
  MOZ_ASSERT(!nsContentUtils::IsSafeToRunScript(),
             "InitPresentationStuff must only be called when scripts are "
             "blocked");
  NS_ASSERTION(!mPresShell, "Someone should have destroyed the presshell!");
#ifdef NS_PRINTING
  MOZ_ASSERT(!mPrintJob,
             "Shouldn't be creating a presentation for a print job");
#endif

  // Now make the shell for the document
  nsCOMPtr<Document> doc = mDocument;
  RefPtr<nsPresContext> presContext = mPresContext;
  mPresShell = doc->CreatePresShell(presContext, FindContainerFrame());
  if (!mPresShell) {
    return NS_ERROR_FAILURE;
  }

  AttachToTopLevelWidget();

  mPresShell->BeginObservingDocument();

  // Initialize our view manager

  {
    int32_t p2a = mPresContext->AppUnitsPerDevPixel();
    MOZ_ASSERT(
        p2a ==
        mPresContext->DeviceContext()->AppUnitsPerDevPixelAtUnitFullZoom());

    const nsSize size = LayoutDevicePixel::ToAppUnits(mBounds.Size(), p2a);
    mPresContext->SetInitialVisibleArea(nsRect(nsPoint(), size));
    // We rely on the default zoom not being initialized until here.
    mPresContext->RecomputeBrowsingContextDependentData();
  }

  if (mWindow && mDocument->IsTopLevelContentDocument()) {
    // Set initial safe area insets
    LayoutDeviceIntMargin windowSafeAreaInsets;
    LayoutDeviceIntRect windowRect = mWindow->GetScreenBounds();
    if (nsCOMPtr<nsIScreen> screen = mWindow->GetWidgetScreen()) {
      windowSafeAreaInsets = nsContentUtils::GetWindowSafeAreaInsets(
          screen, mWindow->GetSafeAreaInsets(), windowRect);
    }
    mPresContext->SetSafeAreaInsets(windowSafeAreaInsets);
  }

  if (aDoInitialReflow) {
    RefPtr<PresShell> presShell = mPresShell;
    // Initial reflow
    presShell->Initialize();
  }

  // now register ourselves as a selection listener, so that we get
  // called when the selection changes in the window
  if (!mSelectionListener) {
    mSelectionListener = MakeRefPtr<nsDocViewerSelectionListener>(this);
  }

  if (RefPtr<mozilla::dom::Selection> selection = GetDocumentSelection()) {
    selection->AddSelectionListener(mSelectionListener);
  }

  if (aDoInitialReflow && mDocument) {
    nsCOMPtr<Document> document = mDocument;
    document->ScrollToRef();
  }

  return NS_OK;
}

static already_AddRefed<nsPresContext> CreatePresContext(
    Document* aDocument, nsPresContext::nsPresContextType aType,
    nsIFrame* aContainerFrame) {
  RefPtr<nsPresContext> result = aContainerFrame
                                     ? new nsPresContext(aDocument, aType)
                                     : new nsRootPresContext(aDocument, aType);

  return result.forget();
}

//-----------------------------------------------
// This method can be used to initial the "presentation"
// The aDoCreation indicates whether it should create
// all the new objects or just initialize the existing ones
nsresult nsDocumentViewer::InitInternal(nsIWidget* aParentWidget,
                                        WindowGlobalChild* aActor,
                                        const LayoutDeviceIntRect& aBounds,
                                        bool aDoCreation,
                                        bool aNeedMakeCX /*= true*/,
                                        bool aForceSetNewDocument /* = true*/) {
  // We don't want any scripts to run here. That can cause flushing,
  // which can cause reentry into initialization of this document viewer,
  // which would be disastrous.
  nsAutoScriptBlocker blockScripts;

  mParentWidget = aParentWidget;  // not ref counted

  mBounds = aBounds;

  NS_ENSURE_TRUE(mDocument, NS_ERROR_NULL_POINTER);

  nsSubDocumentFrame* containerFrame = FindContainerFrame();

  bool makeCX = false;
  if (aDoCreation) {
    CreateDeviceContext(containerFrame);

    // XXXbz this is a nasty hack to do with the fact that we create
    // presentations both in Init() and in Show()...  Ideally we would only do
    // it in one place (Show()) and require that callers call init(), open(),
    // show() in that order or something.
    if (!mPresContext && ShouldHaveGalleyPresentation() &&
        (aParentWidget || containerFrame || mDocument->IsBeingUsedAsImage() ||
         (mDocument->GetDisplayDocument() &&
          mDocument->GetDisplayDocument()->GetPresShell()))) {
      // Create presentation context
      mPresContext = CreatePresContext(
          mDocument, nsPresContext::eContext_Galley, containerFrame);
      mPresContext->Init(mDeviceContext);

#ifdef NS_PRINTING
      makeCX = !GetIsPrintPreview() &&
               aNeedMakeCX;  // needs to be true except when we are already in
                             // PP or we are enabling/disabling paginated mode.
#else
      makeCX = true;
#endif
    }

    if (mPresContext) {
      // We must do this before we tell the script global object about
      // this new document since doing that will cause us to re-enter
      // into nsSubDocumentFrame code through reflows caused by
      // FlushPendingNotifications() calls down the road...
      Hide();
    } else {
      // Avoid leaking the old viewer.
      if (nsCOMPtr prev = std::move(mPreviousViewer)) {
        prev->Destroy();
      }
    }
  }

  nsCOMPtr<nsIInterfaceRequestor> requestor(mContainer);
  if (requestor) {
    // Set script-context-owner in the document

    nsCOMPtr<nsPIDOMWindowOuter> window = do_GetInterface(requestor);

    if (window) {
      nsCOMPtr<Document> curDoc = window->GetExtantDoc();
      if (aForceSetNewDocument || curDoc != mDocument) {
        nsresult rv = window->SetNewDocument(mDocument, nullptr, false, aActor);
        if (NS_FAILED(rv)) {
          Destroy();
          return rv;
        }
      }
    }
  }

  if (aDoCreation && mPresContext) {
    return InitPresentationStuff(!makeCX);
  }

  return NS_OK;
}

void nsDocumentViewer::SetNavigationTiming(nsDOMNavigationTiming* timing) {
  NS_ASSERTION(mDocument, "Must have a document to set navigation timing.");
  if (mDocument) {
    mDocument->SetNavigationTiming(timing);
  }
}

//
// LoadComplete(aStatus)
//
//   aStatus - The status returned from loading the document.
//
// This method is called by the container when the document has been
// completely loaded.
//
NS_IMETHODIMP
nsDocumentViewer::LoadComplete(nsresult aStatus) {
  /* We need to protect ourself against auto-destruction in case the
     window is closed while processing the OnLoad event.  See bug
     http://bugzilla.mozilla.org/show_bug.cgi?id=78445 for more
     explanation.
  */
  RefPtr<nsDocumentViewer> kungFuDeathGrip(this);

  // Flush out layout so it's up-to-date by the time onload is called.
  // Note that this could destroy the window, so do this before
  // checking for our mDocument and its window.
  if (mPresShell && !mStopped) {
    // Hold strong ref because this could conceivably run script
    RefPtr<PresShell> presShell = mPresShell;
    presShell->FlushPendingNotifications(FlushType::Layout);
  }

  NS_ENSURE_TRUE(mDocument, NS_ERROR_NOT_AVAILABLE);

  // First, get the window from the document...
  nsCOMPtr<nsPIDOMWindowOuter> window = mDocument->GetWindow();
  RefPtr<nsDocShell> docShell = nsDocShell::Cast(window->GetDocShell());

  mLoaded = true;

  // Now, fire either an OnLoad or OnError event to the document...
  bool restoring = false;
  // XXXbz imagelib kills off the document load for a full-page image with
  // NS_ERROR_PARSED_DATA_CACHED if it's in the cache.  So we want to treat
  // that one as a success code; otherwise whether we fire onload for the image
  // will depend on whether it's cached!
  if (window &&
      (NS_SUCCEEDED(aStatus) || aStatus == NS_ERROR_PARSED_DATA_CACHED)) {
    // If this code changes, the code in nsDocLoader::DocLoaderIsEmpty
    // that fires load events for document.open() cases might need to
    // be updated too.
    nsEventStatus status = nsEventStatus_eIgnore;
    WidgetEvent event(true, eLoad);
    event.mFlags.mBubbles = false;
    event.mFlags.mCancelable = false;
    // XXX Dispatching to |window|, but using |document| as the target.
    event.mTarget = mDocument;

    // If the document presentation is being restored, we don't want to fire
    // onload to the document content since that would likely confuse scripts
    // on the page.

    NS_ENSURE_TRUE(docShell, NS_ERROR_UNEXPECTED);

    // Unfortunately, docShell->GetRestoringDocument() might no longer be set
    // correctly.  In particular, it can be false by now if someone took it upon
    // themselves to block onload from inside restoration and unblock it later.
    // But we can detect the restoring case very simply: by whether our
    // document's readyState is COMPLETE.
    restoring =
        (mDocument->GetReadyStateEnum() == Document::READYSTATE_COMPLETE) &&
        !mDocument->InitialAboutBlankLoadCompleting();
    if (!restoring) {
      NS_ASSERTION(
          mDocument->GetReadyStateEnum() == Document::READYSTATE_INTERACTIVE ||
              // test_stricttransportsecurity.html has old-style
              // docshell-generated about:blank docs reach this code!
              (mDocument->GetReadyStateEnum() ==
                   Document::READYSTATE_COMPLETE &&
               mDocument->InitialAboutBlankLoadCompleting()),
          "Bad readystate");
#ifdef DEBUG
      bool docShellThinksWeAreRestoring;
      docShell->GetRestoringDocument(&docShellThinksWeAreRestoring);
      MOZ_ASSERT(!docShellThinksWeAreRestoring,
                 "How can docshell think we are restoring if we don't have a "
                 "READYSTATE_COMPLETE document?");
#endif  // DEBUG
      nsCOMPtr<Document> d = mDocument;
      if (!mDocument->InitialAboutBlankLoadCompleting()) {
        mDocument->SetReadyStateInternal(Document::READYSTATE_COMPLETE);
      }

      RefPtr<nsDOMNavigationTiming> timing(d->GetNavigationTiming());
      if (timing) {
        timing->NotifyLoadEventStart();
      }

      // Dispatch observer notification to notify observers document load is
      // complete.
      nsCOMPtr<nsIObserverService> os = mozilla::services::GetObserverService();
      if (os) {
        nsIPrincipal* principal = d->NodePrincipal();
        os->NotifyObservers(ToSupports(d),
                            principal->IsSystemPrincipal()
                                ? "chrome-document-loaded"
                                : "content-document-loaded",
                            nullptr);
      }

      nsPIDOMWindowInner* innerWindow = window->GetCurrentInnerWindow();
      d->SetLoadEventFiring(true);
      RefPtr<nsPresContext> presContext = mPresContext;
      // MOZ_KnownLive due to bug 1506441
      EventDispatcher::Dispatch(
          MOZ_KnownLive(nsGlobalWindowOuter::Cast(window)), presContext, &event,
          nullptr, &status);
      d->SetLoadEventFiring(false);

      if (timing) {
        timing->NotifyLoadEventEnd();
      }

      if (innerWindow) {
        innerWindow->QueuePerformanceNavigationTiming();
      }
    }
  } else {
    // XXX: Should fire error event to the document...

    // If our load was explicitly aborted, then we want to set our
    // readyState to COMPLETE, and fire a readystatechange event.
    if (aStatus == NS_BINDING_ABORTED && mDocument) {
      mDocument->NotifyAbortedLoad();
    }
  }

  // Notify the document that it has been shown (regardless of whether
  // it was just loaded). Note: mDocument may be null now if the above
  // firing of onload caused the document to unload. Or, mDocument may not be
  // the "current active" document, if the above firing of onload caused our
  // docshell to navigate away. NOTE: In this latter scenario, it's likely that
  // we fired pagehide (when navigating away) without ever having fired
  // pageshow, and that's pretty broken... Fortunately, this should be rare.
  // (It requires us to spin the event loop in onload handler, e.g. via sync
  // XHR, in order for the navigation-away to happen before onload completes.)
  // We skip firing pageshow if we're currently handling unload, or if loading
  // was explicitly aborted.
  if (mDocument && mDocument->IsCurrentActiveDocument() &&
      aStatus != NS_BINDING_ABORTED) {
    // Re-get window, since it might have changed during above firing of onload
    window = mDocument->GetWindow();
    if (window) {
      docShell = nsDocShell::Cast(window->GetDocShell());
      bool isInUnload;
      if (docShell && NS_SUCCEEDED(docShell->GetIsInUnload(&isInUnload)) &&
          !isInUnload) {
        mDocument->OnPageShow(restoring, nullptr);
      }
    }
  }

  if (!mStopped) {
    if (mDocument) {
      // This is the final attempt to scroll to an anchor / text directive.
      // This is the last iteration of the algorithm described in the spec for
      // trying to scroll to a fragment.
      // https://html.spec.whatwg.org/#try-to-scroll-to-the-fragment
      nsCOMPtr<Document> document = mDocument;
      document->ScrollToRef();
    }

    // Now that the document has loaded, we can tell the presshell
    // to unsuppress painting.
    if (mPresShell) {
      if (mDocument && mDocument->IsInitialDocument() && docShell &&
          !docShell->HasStartedLoadingOtherThanInitialBlankURI()) {
        // Delay paint unsuppression in case a new load elsewhere is started
        // in the same task that permitted the initial about:blank to fire
        // its load event. This is important for the front end, which assumes
        // that it's performance-wise OK to create an empty XUL browser,
        // append it in a document, and only then make it start navigating
        // away from the initial about:blank.
        nsCOMPtr<nsIRunnable> task = NewRunnableMethod<RefPtr<PresShell>>(
            "nsDocShell::UnsuppressPaintingIfNoNavigationAwayFromAboutBlank",
            docShell,
            &nsDocShell::UnsuppressPaintingIfNoNavigationAwayFromAboutBlank,
            mPresShell);
        mDocument->Dispatch(task.forget());
      } else {
        RefPtr<PresShell> presShell = mPresShell;
        presShell->UnsuppressPainting();
        // mPresShell could have been removed now, see bug 378682/421432
        if (mPresShell) {
          mPresShell->LoadComplete();
        }
      }
    }
  }

  // https://wicg.github.io/scroll-to-text-fragment/#invoking-text-directives
  // Monkeypatching HTML § 7.4.6.3 Scrolling to a fragment:
  // 2.1 If the user agent has reason to believe the user is no longer
  //     interested in scrolling to the fragment, then:
  // 2.1.1 Set pending text directives to null.
  //
  // Gecko's implementation differs from the spec (ie., it implements its
  // intention but doesn't follow step by step), therefore the mentioned steps
  // are not applied in the same manner.
  // However, this should be the right place to do this.
  if (mDocument) {
    mDocument->FragmentDirective()->ClearUninvokedDirectives();
  }
  if (mDocument && !restoring) {
    mDocument->LoadEventFired();
  }

  // It's probably a good idea to GC soon since we have finished loading.
  nsJSContext::PokeGC(
      JS::GCReason::LOAD_END,
      mDocument ? mDocument->GetWrapperPreserveColor() : nullptr);

#ifdef NS_PRINTING
  // Check to see if someone tried to print during the load
  if (window) {
    auto* outerWin = nsGlobalWindowOuter::Cast(window);
    outerWin->StopDelayingPrintingUntilAfterLoad();
    if (outerWin->DelayedPrintUntilAfterLoad()) {
      // We call into the inner because it ensures there's an active document
      // and such, and it also waits until the whole thing completes, which is
      // nice because it allows us to close if needed right here.
      if (RefPtr inner =
              nsGlobalWindowInner::Cast(window->GetCurrentInnerWindow())) {
        inner->Print(IgnoreErrors());
      }
      if (outerWin->DelayedCloseForPrinting()) {
        outerWin->Close();
      }
    } else {
      MOZ_ASSERT(!outerWin->DelayedCloseForPrinting());
    }
  }
#endif

  return NS_OK;
}

bool nsDocumentViewer::GetLoadCompleted() { return mLoaded; }

bool nsDocumentViewer::GetIsStopped() { return mStopped; }

NS_IMETHODIMP
nsDocumentViewer::PermitUnload(PermitUnloadAction aAction,
                               bool* aPermitUnload) {
  // We're going to be running JS and nested event loops, which could cause our
  // DocShell to be destroyed. Make sure we stay alive until the end of the
  // function.
  RefPtr<nsDocumentViewer> kungFuDeathGrip(this);

  if (StaticPrefs::dom_disable_beforeunload()) {
    aAction = eDontPromptAndUnload;
  }

  *aPermitUnload = true;

  NS_ENSURE_STATE(mContainer);

  RefPtr<BrowsingContext> bc = mContainer->GetBrowsingContext();
  if (!bc) {
    return NS_OK;
  }

  if (bc->GetIsDocumentPiP()) {
    // https://wicg.github.io/document-picture-in-picture/#close-document-pip-window
    return NS_OK;
  }

  // Per spec, we need to increase the ignore-opens-during-unload counter while
  // dispatching the "beforeunload" event on both the document we're currently
  // dispatching the event to and the document that we explicitly asked to
  // unload.
  IgnoreOpensDuringUnload ignoreOpens(mDocument);

  bool foundBlocker = false;
  bool foundOOPListener = false;
  bc->PreOrderWalk([&](BrowsingContext* aBC) {
    if (!aBC->IsInProcess()) {
      WindowContext* wc = aBC->GetCurrentWindowContext();
      if (wc && wc->NeedsBeforeUnload()) {
        foundOOPListener = true;
      }
    } else if (aBC->GetDocShell()) {
      nsCOMPtr<nsIDocumentViewer> viewer(aBC->GetDocShell()->GetDocViewer());
      if (viewer && viewer->DispatchBeforeUnload() != eContinue) {
        foundBlocker = true;
      }
    }
  });

  if (!foundOOPListener) {
    if (!foundBlocker) {
      return NS_OK;
    }
    if (aAction != ePrompt) {
      *aPermitUnload = aAction == eDontPromptAndUnload;
      return NS_OK;
    }
  }

  // NB: we nullcheck mDocument because it might now be dead as a result of
  // the event being dispatched.
  RefPtr<WindowGlobalChild> wgc(mDocument ? mDocument->GetWindowGlobalChild()
                                          : nullptr);
  if (!wgc) {
    return NS_OK;
  }

  nsAutoSyncOperation sync(mDocument, SyncOperationBehavior::eSuspendInput);
  AutoSuppressEventHandlingAndSuspend seh(bc->Group());

  mInPermitUnloadPrompt = true;

  bool done = false;
  wgc->SendCheckPermitUnload(
      foundBlocker, aAction,
      [&](bool aPermit) {
        done = true;
        *aPermitUnload = aPermit;
      },
      [&](auto) {
        // If the prompt aborted, we tell our consumer that it is not allowed
        // to unload the page. One reason that prompts abort is that the user
        // performed some action that caused the page to unload while our prompt
        // was active. In those cases we don't want our consumer to also unload
        // the page.
        //
        // XXX: Are there other cases where prompts can abort? Is it ok to
        //      prevent unloading the page in those cases?
        done = true;
        *aPermitUnload = false;
      });

  SpinEventLoopUntil("nsDocumentViewer::PermitUnload"_ns,
                     [&]() { return done; });

  mInPermitUnloadPrompt = false;
  return NS_OK;
}

MOZ_CAN_RUN_SCRIPT_BOUNDARY PermitUnloadResult
nsDocumentViewer::DispatchBeforeUnload() {
  AutoDontWarnAboutSyncXHR disableSyncXHRWarning;

  if (!mDocument || mInPermitUnload || mInPermitUnloadPrompt || !mContainer) {
    return eContinue;
  }

  // First, get the script global object from the document...
  RefPtr<nsGlobalWindowOuter> window =
      nsGlobalWindowOuter::Cast(mDocument->GetWindow());
  if (!window) {
    // This is odd, but not fatal
    NS_WARNING("window not set for document!");
    return eContinue;
  }

  NS_ASSERTION(nsContentUtils::IsSafeToRunScript(), "This is unsafe");

  // https://html.spec.whatwg.org/multipage/browsing-the-web.html#prompt-to-unload-a-document
  // Create an RAII object on mDocument that will increment the
  // should-ignore-opens-during-unload counter on initialization
  // and decrement it again when it goes out of score (regardless
  // of how we exit this function).
  IgnoreOpensDuringUnload ignoreOpens(mDocument);

  // Now, fire an BeforeUnload event to the document and see if it's ok
  // to unload...
  nsPresContext* presContext = mDocument->GetPresContext();
  auto event = MakeRefPtr<BeforeUnloadEvent>(mDocument, presContext, nullptr);
  event->InitEvent(u"beforeunload"_ns, false, true);

  // Dispatching to |window|, but using |document| as the target.
  event->SetTarget(mDocument);
  event->SetTrusted(true);

  // In evil cases we might be destroyed while handling the
  // onbeforeunload event, don't let that happen. (see also bug#331040)
  RefPtr<nsDocumentViewer> kungFuDeathGrip(this);

  {
    // Never permit popups from the beforeunload handler, no matter
    // how we get here.
    AutoPopupStatePusher popupStatePusher(PopupBlocker::openAbused, true);

    RefPtr<BrowsingContext> bc = mContainer->GetBrowsingContext();
    NS_ASSERTION(bc, "should have a browsing context in document viewer");

    // Never permit dialogs from the beforeunload handler
    nsGlobalWindowOuter::TemporarilyDisableDialogs disableDialogs(bc);

    Document::PageUnloadingEventTimeStamp timestamp(mDocument);

    mInPermitUnload = true;
    RefPtr<nsPresContext> presContext = mPresContext;
    EventDispatcher::DispatchDOMEvent(window, nullptr, event, presContext,
                                      nullptr);
    mInPermitUnload = false;
  }

  nsAutoString text;
  event->GetReturnValue(text);

  // NB: we nullcheck mDocument because it might now be dead as a result of
  // the event being dispatched.
  if (window->AreDialogsEnabled() && mDocument &&
      !(mDocument->GetSandboxFlags() & SANDBOXED_MODALS) &&
      (!StaticPrefs::dom_require_user_interaction_for_beforeunload() ||
       mDocument->ChromeRulesEnabled() || mDocument->UserHasInteracted()) &&
      (event->WidgetEventPtr()->DefaultPrevented() || !text.IsEmpty())) {
    return eCanceledByBeforeUnload;
  }
  return eContinue;
}

NS_IMETHODIMP
nsDocumentViewer::GetBeforeUnloadFiring(bool* aInEvent) {
  *aInEvent = mInPermitUnload;
  return NS_OK;
}

NS_IMETHODIMP
nsDocumentViewer::GetInPermitUnload(bool* aInEvent) {
  *aInEvent = mInPermitUnloadPrompt;
  return NS_OK;
}

NS_IMETHODIMP
nsDocumentViewer::PageHide(bool aIsUnload) {
  AutoDontWarnAboutSyncXHR disableSyncXHRWarning;

  mHidden = true;

  if (!mDocument) {
    return NS_ERROR_NULL_POINTER;
  }

  if (aIsUnload) {
    // Poke the GC. The window might be collectable garbage now.
    nsJSContext::PokeGC(JS::GCReason::PAGE_HIDE,
                        mDocument->GetWrapperPreserveColor(),
                        TimeDuration::FromMilliseconds(
                            StaticPrefs::javascript_options_gc_delay() * 2));
  }

  // https://html.spec.whatwg.org/multipage/browsing-the-web.html#unload-a-document
  // Create an RAII object on mDocument that will increment the
  // should-ignore-opens-during-unload counter on initialization
  // and decrement it again when it goes out of scope.
  IgnoreOpensDuringUnload ignoreOpens(mDocument);

  mDocument->OnPageHide(!aIsUnload, nullptr);

  // inform the window so that the focus state is reset.
  NS_ENSURE_STATE(mDocument);
  nsPIDOMWindowOuter* window = mDocument->GetWindow();
  if (window) {
    window->PageHidden(!aIsUnload);
  }

  if (aIsUnload) {
    // if Destroy() was called during OnPageHide(), mDocument is nullptr.
    NS_ENSURE_STATE(mDocument);

    // First, get the window from the document...
    RefPtr<nsPIDOMWindowOuter> window = mDocument->GetWindow();

    if (!window) {
      // Fail if no window is available...
      NS_WARNING("window not set for document!");
      return NS_ERROR_NULL_POINTER;
    }

    // Now, fire an Unload event to the document...
    nsEventStatus status = nsEventStatus_eIgnore;
    WidgetEvent event(true, eUnload);
    event.mFlags.mBubbles = false;
    // XXX Dispatching to |window|, but using |document| as the target.
    event.mTarget = mDocument;

    // Never permit popups from the unload handler, no matter how we get
    // here.
    AutoPopupStatePusher popupStatePusher(PopupBlocker::openAbused, true);

    Document::PageUnloadingEventTimeStamp timestamp(mDocument);

    RefPtr<nsPresContext> presContext = mPresContext;
    // MOZ_KnownLive due to bug 1506441
    EventDispatcher::Dispatch(MOZ_KnownLive(nsGlobalWindowOuter::Cast(window)),
                              presContext, &event, nullptr, &status);
  }

  // look for open menupopups and close them after the unload event, in case
  // the unload event listeners open any new popups
  nsContentUtils::HidePopupsInDocument(mDocument);

  return NS_OK;
}

NS_IMETHODIMP
nsDocumentViewer::Open() {
  NS_ENSURE_TRUE(mPresShell, NS_ERROR_NOT_INITIALIZED);

  if (mDocument) {
    mDocument->SetContainer(mContainer);
  }

  MOZ_TRY(InitInternal(mParentWidget, nullptr, mBounds, false));

  mHidden = false;

  if (mPresShell) {
    mPresShell->SetForwardingContainer(WeakPtr<nsDocShell>());
  }

  // Rehook the child presentations.  The child shells are still in
  // session history, so get them from there.

  SyncParentSubDocMap();

  // XXX re-enable image animations once that works correctly

  PrepareToStartLoad();

  // When loading a page from the bfcache with puppet widgets, we do the
  // widget attachment here (it is otherwise done in MakeWindow, which is
  // called for non-bfcache pages in the history, but not bfcache pages).
  // Attachment is necessary, since we get detached when another page
  // is browsed to. That is, if we are one page A, then when we go to
  // page B, we detach. So page A's view has no widget. If we then go
  // back to it, and it is in the bfcache, we will use that view, which
  // doesn't have a widget. The attach call here will properly attach us.
  AttachToTopLevelWidget();

  return NS_OK;
}

NS_IMETHODIMP
nsDocumentViewer::Close() {
  // All callers are supposed to call close to break circular
  // references.  If we do this stuff in the destructor, the
  // destructor might never be called (especially if we're being
  // used from JS.

  // Close is also needed to disable scripts during paint suppression,
  // since we transfer the existing global object to the new document
  // that is loaded.  In the future, the global object may become a proxy
  // for an object that can be switched in and out so that we don't need
  // to disable scripts during paint suppression.

  if (!mDocument) {
    return NS_OK;
  }

#ifdef NS_PRINTING
  // A Close was called while we were printing
  // so don't clear the ScriptGlobalObject
  // or clear the mDocument below
  if (mPrintJob && !mClosingWhilePrinting) {
    mClosingWhilePrinting = true;
  } else
#endif
  {
    // out of band cleanup of docshell
    mDocument->SetScriptGlobalObject(nullptr);

    if (mDocument) {
      mDocument->RemovedFromDocShell();
    }
  }

  return NS_OK;
}

NS_IMETHODIMP
nsDocumentViewer::Destroy() {
  // Don't let the document get unloaded while we are printing.
  // this could happen if we hit the back button during printing.
  // We also keep the viewer from being cached in session history, since
  // we require all documents there to be sanitized.
  if (mDestroyBlockedCount != 0) {
    return NS_OK;
  }

#ifdef NS_PRINTING
  // Here is where we check to see if the document was still being prepared
  // for printing when it was asked to be destroy from someone externally
  // This usually happens if the document is unloaded while the user is in the
  // Print Dialog
  //
  // So we flip the bool to remember that the document is going away
  // and we can clean up and abort later after returning from the Print Dialog
  if (mPrintJob && mPrintJob->CheckBeforeDestroy()) {
    return NS_OK;
  }
#endif

  // We want to make sure to disconnect mBFCachePreventionObserver before we
  // Sanitize() below.
  if (mBFCachePreventionObserver) {
    mBFCachePreventionObserver->Disconnect();
    mBFCachePreventionObserver = nullptr;
  }

  // The document was not put in the bfcache

  // Protect against pres shell destruction running scripts and re-entrantly
  // creating a new presentation.
  nsAutoScriptBlocker scriptBlocker;

  if (mPresShell) {
    DestroyPresShell();
  }
  if (nsCOMPtr doc = std::move(mDocument)) {
    doc->Destroy();
  }

  // All callers are supposed to call destroy to break circular
  // references.  If we do this stuff in the destructor, the
  // destructor might never be called (especially if we're being
  // used from JS.

#ifdef NS_PRINTING
  if (RefPtr printJob = std::move(mPrintJob)) {
    if (printJob->CreatedForPrintPreview()) {
      printJob->FinishPrintPreview();
    }
    printJob->Destroy();
    MOZ_ASSERT(!mPrintJob,
               "mPrintJob shouldn't be recreated while destroying it");
  }
#endif

  // Avoid leaking the old viewer.
  if (mPreviousViewer) {
    mPreviousViewer->Destroy();
    mPreviousViewer = nullptr;
  }

  mDeviceContext = nullptr;

  if (mPresContext) {
    DestroyPresContext();
  }

  mWindow = nullptr;
  mContainer = WeakPtr<nsDocShell>();

  return NS_OK;
}

NS_IMETHODIMP
nsDocumentViewer::Stop(void) {
  NS_ASSERTION(mDocument, "Stop called too early or too late");
  if (mDocument) {
    mDocument->StopDocumentLoad();
  }

  mStopped = true;

  if (!mLoaded && mPresShell) {
    // Well, we might as well paint what we have so far.
    RefPtr<PresShell> presShell = mPresShell;  // bug 378682
    presShell->UnsuppressPainting();
  }

  return NS_OK;
}

NS_IMETHODIMP
nsDocumentViewer::GetDOMDocument(Document** aResult) {
  NS_ENSURE_TRUE(mDocument, NS_ERROR_NOT_AVAILABLE);
  nsCOMPtr<Document> document = mDocument;
  document.forget(aResult);
  return NS_OK;
}

Document* nsDocumentViewer::GetDocument() { return mDocument; }

nsresult nsDocumentViewer::SetDocument(Document* aDocument) {
  // Assumptions:
  //
  // 1) this document viewer has been initialized with a call to Init().
  // 2) the stylesheets associated with the document have been added
  // to the document.

  // XXX Right now, this method assumes that the layout of the current
  // document hasn't started yet.  More cleanup will probably be
  // necessary to make this method work for the case when layout *has*
  // occurred for the current document.
  // That work can happen when and if it is needed.

  if (!aDocument) {
    return NS_ERROR_NULL_POINTER;
  }

  return SetDocumentInternal(aDocument, false);
}

NS_IMETHODIMP
nsDocumentViewer::SetDocumentInternal(Document* aDocument,
                                      bool aForceReuseInnerWindow) {
  MOZ_ASSERT(aDocument);

  // Set new container
  aDocument->SetContainer(mContainer);

  if (mDocument != aDocument) {
    if (aForceReuseInnerWindow) {
      // Transfer the navigation timing information to the new document, since
      // we're keeping the same inner and hence should really have the same
      // timing information.
      aDocument->SetNavigationTiming(mDocument->GetNavigationTiming());
    }

    if (mDocument &&
        (mDocument->IsStaticDocument() || aDocument->IsStaticDocument())) {
      nsContentUtils::AddScriptRunner(NewRunnableMethod(
          "Document::Destroy", mDocument, &Document::Destroy));
    }

    // Clear the list of old child docshells. Child docshells for the new
    // document will be constructed as frames are created.
    if (!aDocument->IsStaticDocument()) {
      nsCOMPtr<nsIDocShell> node(mContainer);
      if (node) {
        int32_t count;
        node->GetInProcessChildCount(&count);
        for (int32_t i = 0; i < count; ++i) {
          nsCOMPtr<nsIDocShellTreeItem> child;
          node->GetInProcessChildAt(0, getter_AddRefs(child));
          node->RemoveChild(child);
        }
      }
    }

    // Replace the old document with the new one. Do this only when
    // the new document really is a new document.
    mDocument = aDocument;

    // Set the script global object on the new document
    nsCOMPtr<nsPIDOMWindowOuter> window =
        mContainer ? mContainer->GetWindow() : nullptr;
    if (window) {
      nsresult rv =
          window->SetNewDocument(aDocument, nullptr, aForceReuseInnerWindow);
      if (NS_FAILED(rv)) {
        Destroy();
        return rv;
      }
    }
  }

  MOZ_TRY(SyncParentSubDocMap());

  // Replace the current pres shell with a new shell for the new document

  // Protect against pres shell destruction running scripts and re-entrantly
  // creating a new presentation.
  nsAutoScriptBlocker scriptBlocker;

  if (mPresShell) {
    DestroyPresShell();
  }

  if (mPresContext) {
    DestroyPresContext();

    mWindow = nullptr;
    MOZ_TRY(InitInternal(mParentWidget, nullptr, mBounds, true, true, false));
  }

  return NS_OK;
}

PresShell* nsDocumentViewer::GetPresShell() { return mPresShell; }

nsPresContext* nsDocumentViewer::GetPresContext() { return mPresContext; }

NS_IMETHODIMP
nsDocumentViewer::GetBounds(LayoutDeviceIntRect& aResult) {
  NS_ENSURE_TRUE(mDocument, NS_ERROR_NOT_AVAILABLE);
  aResult = mBounds;
  return NS_OK;
}

nsIDocumentViewer* nsDocumentViewer::GetPreviousViewer() {
  return mPreviousViewer;
}

void nsDocumentViewer::SetPreviousViewer(nsIDocumentViewer* aViewer) {
  // NOTE:  |Show| sets |mPreviousViewer| to null without calling this
  // function.

  if (aViewer) {
    NS_ASSERTION(!mPreviousViewer,
                 "can't set previous viewer when there already is one");

    // In a multiple chaining situation (which occurs when running a thrashing
    // test like i-bench or jrgm's tests with no delay), we can build up a
    // whole chain of viewers.  In order to avoid this, we always set our
    // previous viewer to the MOST previous viewer in the chain, and then dump
    // the intermediate link from the chain.  This ensures that at most only 2
    // documents are alive and undestroyed at any given time (the one that is
    // showing and the one that is loading with painting suppressed). It's very
    // important that if this ever gets changed the code before the
    // RestorePresentation call in nsDocShell::InternalLoad be changed
    // accordingly.
    //
    // Make sure we hold a strong ref to prevViewer here, since we'll
    // tell aViewer to drop it.
    nsCOMPtr<nsIDocumentViewer> prevViewer = aViewer->GetPreviousViewer();
    if (prevViewer) {
      aViewer->SetPreviousViewer(nullptr);
      aViewer->Destroy();
      return SetPreviousViewer(prevViewer);
    }
  }

  mPreviousViewer = aViewer;
}

NS_IMETHODIMP
nsDocumentViewer::SetBoundsWithFlags(const LayoutDeviceIntRect& aBounds,
                                     uint32_t aFlags) {
  NS_ENSURE_TRUE(mDocument, NS_ERROR_NOT_AVAILABLE);

  bool boundsChanged = !mBounds.IsEqualEdges(aBounds);
  mBounds = aBounds;

  if (mPresContext) {
    // Ensure presContext's deviceContext is up to date, as we sometimes get
    // here before a resolution-change notification has been fully handled
    // during display configuration changes, especially when there are lots
    // of windows/widgets competing to handle the notifications.
    // (See bug 1154125.)
    if (mPresContext->DeviceContext()->CheckDPIChange()) {
      mPresContext->UIResolutionChangedSync();
    }

    int32_t p2a = mPresContext->AppUnitsPerDevPixel();
    const nsSize size = LayoutDeviceSize::ToAppUnits(mBounds.Size(), p2a);
    if (boundsChanged && mPresContext->GetVisibleArea().Size() == size) {
      // If the view/frame tree and prescontext visible area already has the new
      // size but we did not, then it's likely that we got reflowed in response
      // to a call to GetContentSize. Thus there is a disconnect between the
      // size on the document viewer/docshell/containing widget and view
      // tree/frame tree/prescontext visible area). SetLayoutViewportSize
      // compares to the pres context visible area to determine if it needs to
      // do anything; if they are the same as the new size it won't do anything,
      // but we still need to invalidate because what we want to draw to the
      // screen has changed.
      if (nsIFrame* f = mPresShell->GetRootFrame()) {
        f->InvalidateFrame();

        // Forcibly refresh the viewport sizes even if the view size is not
        // changed since it is possible that the |mBounds| change means that
        // the software keyboard appeared/disappeared. In such cases we might
        // need to fire visual viewport events.
        mPresShell->RefreshViewportSize();
      }
    }

    RefPtr ps = mPresShell;
    ps->SetLayoutViewportSize(size,
                              !!(aFlags & nsIDocumentViewer::eDelayResize));
  }

  // If there's a previous viewer, it's the one that's actually showing,
  // so be sure to resize it as well so it paints over the right area.
  // This may slow down the performance of the new page load, but resize
  // during load is also probably a relatively unusual condition
  // relating to things being hidden while something is loaded.  It so
  // happens that Firefox does this a good bit with its infobar, and it
  // looks ugly if we don't do this.
  if (mPreviousViewer) {
    nsCOMPtr<nsIDocumentViewer> previousViewer = mPreviousViewer;
    previousViewer->SetBounds(aBounds);
  }

  return NS_OK;
}

NS_IMETHODIMP
nsDocumentViewer::SetBounds(const LayoutDeviceIntRect& aBounds) {
  return SetBoundsWithFlags(aBounds, 0);
}

NS_IMETHODIMP
nsDocumentViewer::Move(int32_t aX, int32_t aY) {
  NS_ENSURE_TRUE(mDocument, NS_ERROR_NOT_AVAILABLE);
  mBounds.MoveTo(aX, aY);
  if (mWindow) {
    mWindow->Move(mBounds.TopLeft() / mWindow->GetDesktopToDeviceScale());
  }
  return NS_OK;
}

NS_IMETHODIMP
nsDocumentViewer::Show() {
  NS_ENSURE_TRUE(mDocument, NS_ERROR_NOT_AVAILABLE);

  // We don't need the previous viewer anymore since we're not
  // displaying it.
  if (nsCOMPtr prev = std::move(mPreviousViewer)) {
    prev->Destroy();
  }

  // Hold on to the document so we can use it after the script blocker below
  // has been released (which might re-entrantly call into other
  // nsDocumentViewer methods).
  nsCOMPtr<Document> document = mDocument;

  if (!mPresContext && ShouldHaveGalleyPresentation()) {
    // The InitPresentationStuff call below requires a script blocker, because
    // its PresShell::Initialize call can cause scripts to run and therefore
    // re-entrant calls to nsDocumentViewer methods to be made.
    nsAutoScriptBlocker scriptBlocker;

    NS_ASSERTION(!mWindow, "Window already created but no presshell?");

    nsCOMPtr<nsIBaseWindow> base_win(mContainer);
    if (base_win) {
      base_win->GetParentWidget(&mParentWidget);
      if (mParentWidget) {
        // GetParentWidget AddRefs, but mParentWidget is weak
        mParentWidget->Release();
      }
    }

    nsSubDocumentFrame* containerFrame = FindContainerFrame();

    CreateDeviceContext(containerFrame);

    // Create presentation context
    NS_ASSERTION(!mPresContext,
                 "Shouldn't have a prescontext if we have no shell!");
    mPresContext = CreatePresContext(mDocument, nsPresContext::eContext_Galley,
                                     containerFrame);
    mPresContext->Init(mDeviceContext);
    Hide();

    InitPresentationStuff(mDocument->MayStartLayout());

    // If we get here the document load has already started and the
    // window is shown because some JS on the page caused it to be
    // shown...

    if (mPresShell) {
      RefPtr<PresShell> presShell = mPresShell;  // bug 378682
      presShell->UnsuppressPainting();
    }
  }

  // Notify observers that a new page has been shown. This will get run
  // from the event loop after we actually draw the page.
  auto event = MakeRefPtr<nsDocumentShownDispatcher>(document);
  document->Dispatch(event.forget());

  return NS_OK;
}

NS_IMETHODIMP
nsDocumentViewer::Hide() {
  if (!mPresShell) {
    return NS_OK;
  }

  NS_ASSERTION(mPresContext, "Can't have a presshell and no prescontext!");

  // Avoid leaking the old viewer.
  if (nsCOMPtr prev = std::move(mPreviousViewer)) {
    prev->Destroy();
  }

  if (mIsSticky) {
    // This window is sticky, that means that it might be shown again
    // and we don't want the presshell n' all that to be thrown away
    // just because the window is hidden.

    return NS_OK;
  }

  nsCOMPtr<nsIDocShell> docShell(mContainer);
  if (docShell) {
#ifdef DEBUG
    nsCOMPtr<nsIDocumentViewer> currentViewer;
    docShell->GetDocViewer(getter_AddRefs(currentViewer));
    MOZ_ASSERT(currentViewer == this);
#endif
    nsCOMPtr<nsILayoutHistoryState> layoutState;
    mPresShell->CaptureHistoryState(getter_AddRefs(layoutState));
  }

  // Do not run ScriptRunners queued by DestroyPresShell() in the intermediate
  // state before we're done destroying PresShell, PresContext, ViewManager,
  // etc.
  nsAutoScriptBlocker scriptBlocker;

  DestroyPresShell();

  DestroyPresContext();

  mWindow = nullptr;
  mDeviceContext = nullptr;
  mParentWidget = nullptr;
  return NS_OK;
}

NS_IMETHODIMP
nsDocumentViewer::GetSticky(bool* aSticky) {
  *aSticky = mIsSticky;

  return NS_OK;
}

NS_IMETHODIMP
nsDocumentViewer::SetSticky(bool aSticky) {
  mIsSticky = aSticky;

  return NS_OK;
}

NS_IMETHODIMP
nsDocumentViewer::ClearHistoryEntry() {
  if (mDocument) {
    nsJSContext::PokeGC(JS::GCReason::PAGE_HIDE,
                        mDocument->GetWrapperPreserveColor(),
                        TimeDuration::FromMilliseconds(
                            StaticPrefs::javascript_options_gc_delay() * 2));
  }

  return NS_OK;
}

//-------------------------------------------------------

void nsDocumentViewer::DetachFromTopLevelWidget() {
  if (mPresShell) {
    if (auto* listener = mPresShell->GetWidgetListener();
        listener && listener->HasWidget()) {
      listener->DetachFromTopLevelWidget();
    }
  }
}

void nsDocumentViewer::AttachToTopLevelWidget() {
  DetachFromTopLevelWidget();
  if (mPresShell && mParentWidget) {
    auto* listener = mPresShell->GetWidgetListener();
    listener->AttachToTopLevelWidget(mParentWidget);
    mWindow = mParentWidget;
  }
}

nsSubDocumentFrame* nsDocumentViewer::FindContainerFrame() {
  if (!mContainer) {
    return nullptr;
  }

  nsCOMPtr<nsIDocShell> docShell(mContainer);
  nsCOMPtr<nsPIDOMWindowOuter> pwin(docShell->GetWindow());
  if (!pwin) {
    return nullptr;
  }

  nsCOMPtr<Element> containerElement = pwin->GetFrameElementInternal();
  if (!containerElement) {
    return nullptr;
  }

  nsIFrame* subdocFrame = containerElement->GetPrimaryFrame();
  if (!subdocFrame) {
    // XXX Silenced by default in bug 1175289
    LAYOUT_WARNING("Subdocument container has no frame");
    return nullptr;
  }

  // Check subdocFrame just to be safe. If this somehow fails we treat that as
  // display:none, the document is not displayed.
  if (!subdocFrame->IsSubDocumentFrame()) {
    NS_WARNING_ASSERTION(subdocFrame->Type() == LayoutFrameType::None,
                         "Subdocument container has non-subdocument frame");
    return nullptr;
  }

  return static_cast<nsSubDocumentFrame*>(subdocFrame);
}

void nsDocumentViewer::CreateDeviceContext(
    nsSubDocumentFrame* aContainerFrame) {
  MOZ_ASSERT(!mPresShell && !mWindow,
             "This will screw up our existing presentation");
  MOZ_ASSERT(mDocument, "Gotta have a document here");

  if (Document* doc = mDocument->GetDisplayDocument()) {
    NS_ASSERTION(!aContainerFrame,
                 "External resource document embedded somewhere?");
    // We want to use our display document's device context if possible
    if (nsPresContext* ctx = doc->GetPresContext()) {
      mDeviceContext = ctx->DeviceContext();
      return;
    }
  }

  // Create a device context even if we already have one, since our widget
  // might have changed.
  nsIWidget* widget = nullptr;
  if (aContainerFrame) {
    widget = aContainerFrame->GetNearestWidget();
  }
  if (!widget) {
    widget = mParentWidget;
  }
  if (widget) {
    widget = widget->GetTopLevelWidget();
  }

  mDeviceContext = MakeRefPtr<nsDeviceContext>();
  mDeviceContext->Init(widget);
}

// Return the selection for the document. Note that text fields have their
// own selection, which cannot be accessed with this method.
mozilla::dom::Selection* nsDocumentViewer::GetDocumentSelection() {
  if (!mPresShell) {
    return nullptr;
  }

  return mPresShell->GetCurrentSelection(SelectionType::eNormal);
}

/* ============================================================================
 * nsIDocumentViewerEdit
 * ============================================================================
 */

MOZ_CAN_RUN_SCRIPT_BOUNDARY NS_IMETHODIMP nsDocumentViewer::ClearSelection() {
  // use nsCopySupport::GetSelectionForCopy() ?
  RefPtr<mozilla::dom::Selection> selection = GetDocumentSelection();
  if (!selection) {
    return NS_ERROR_FAILURE;
  }

  ErrorResult rv;
  selection->CollapseToStart(rv);
  return rv.StealNSResult();
}

MOZ_CAN_RUN_SCRIPT_BOUNDARY NS_IMETHODIMP nsDocumentViewer::SelectAll() {
  // XXX this is a temporary implementation copied from nsWebShell
  // for now. I think Document and friends should have some helper
  // functions to make this easier.

  // use nsCopySupport::GetSelectionForCopy() ?
  RefPtr<mozilla::dom::Selection> selection = GetDocumentSelection();
  if (!selection) {
    return NS_ERROR_FAILURE;
  }

  if (!mDocument) {
    return NS_ERROR_FAILURE;
  }

  // XXX Chrome and Safari select all in the shadow, but we do it in the <body>
  // or the document element. Shouldn't we consider the root element from the
  // selection range or the focused element if there is no selection range and
  // use the shadow root?
  nsCOMPtr<nsINode> bodyNode;
  if (mDocument->IsHTMLOrXHTML()) {
    // XXXbz why not just do GetBody() for all documents, then GetRootElement()
    // if GetBody() is null?
    bodyNode = mDocument->GetBody();
  } else {
    bodyNode = mDocument->GetRootElement();
  }
  if (!bodyNode) {
    return NS_ERROR_FAILURE;
  }

  ErrorResult err;
  selection->RemoveAllRanges(err);
  if (err.Failed()) {
    return err.StealNSResult();
  }

  mozilla::dom::Selection::AutoUserInitiated userSelection(selection);
  selection->SelectAllChildren(*bodyNode, err);
  return err.StealNSResult();
}

NS_IMETHODIMP nsDocumentViewer::CopySelection() {
  RefPtr<PresShell> presShell = mPresShell;
  nsCopySupport::FireClipboardEvent(eCopy, Some(nsIClipboard::kGlobalClipboard),
                                    presShell, nullptr, nullptr);
  return NS_OK;
}

NS_IMETHODIMP nsDocumentViewer::CopyLinkLocation() {
  NS_ENSURE_TRUE(mPresShell, NS_ERROR_NOT_INITIALIZED);
  nsCOMPtr<nsINode> node = GetPopupLinkNode();
  // make noise if we're not in a link
  NS_ENSURE_TRUE(node, NS_ERROR_FAILURE);

  nsCOMPtr<dom::Element> elm(do_QueryInterface(node));
  NS_ENSURE_TRUE(elm, NS_ERROR_FAILURE);

  nsAutoString locationText;
  nsContentUtils::GetLinkLocation(elm, locationText);
  if (locationText.IsEmpty()) {
    return NS_ERROR_FAILURE;
  }

  nsresult rv = NS_OK;
  nsCOMPtr<nsIClipboardHelper> clipboard(
      do_GetService("@mozilla.org/widget/clipboardhelper;1", &rv));
  NS_ENSURE_SUCCESS(rv, rv);

  // copy the href onto the clipboard
  return clipboard->CopyString(locationText, mDocument->GetWindowContext());
}

NS_IMETHODIMP nsDocumentViewer::CopyImage(int32_t aCopyFlags) {
  NS_ENSURE_TRUE(mPresShell, NS_ERROR_NOT_INITIALIZED);
  nsCOMPtr<nsIImageLoadingContent> node = GetPopupImageNode();
  // make noise if we're not in an image
  NS_ENSURE_TRUE(node, NS_ERROR_FAILURE);

  nsCOMPtr<nsILoadContext> loadContext(mContainer);
  return nsCopySupport::ImageCopy(node, loadContext, aCopyFlags,
                                  mDocument->GetWindowContext());
}

NS_IMETHODIMP nsDocumentViewer::GetCopyable(bool* aCopyable) {
  NS_ENSURE_ARG_POINTER(aCopyable);
  *aCopyable = nsCopySupport::CanCopy(mDocument);
  return NS_OK;
}

NS_IMETHODIMP nsDocumentViewer::GetContents(const char* mimeType,
                                            bool selectionOnly,
                                            nsAString& aOutValue) {
  aOutValue.Truncate();

  NS_ENSURE_TRUE(mPresShell, NS_ERROR_NOT_INITIALIZED);
  NS_ENSURE_TRUE(mDocument, NS_ERROR_NOT_INITIALIZED);

  // Now we have the selection.  Make sure it's nonzero:
  RefPtr<Selection> sel;
  if (selectionOnly) {
    sel = nsCopySupport::GetSelectionForCopy(mDocument);
    NS_ENSURE_TRUE(sel, NS_ERROR_FAILURE);

    if (NS_WARN_IF(sel->IsCollapsed())) {
      return NS_OK;
    }
  }

  // call the copy code
  return nsCopySupport::GetContents(nsDependentCString(mimeType), 0, sel,
                                    mDocument, aOutValue);
}

NS_IMETHODIMP nsDocumentViewer::GetCanGetContents(bool* aCanGetContents) {
  NS_ENSURE_ARG_POINTER(aCanGetContents);
  *aCanGetContents = mDocument && nsCopySupport::CanCopy(mDocument);
  return NS_OK;
}

NS_IMETHODIMP nsDocumentViewer::SetCommandNode(nsINode* aNode) {
  Document* document = GetDocument();
  NS_ENSURE_STATE(document);

  nsCOMPtr<nsPIDOMWindowOuter> window(document->GetWindow());
  NS_ENSURE_TRUE(window, NS_ERROR_NOT_AVAILABLE);

  nsCOMPtr<nsPIWindowRoot> root = window->GetTopWindowRoot();
  NS_ENSURE_STATE(root);

  root->SetPopupNode(aNode);
  return NS_OK;
}

NS_IMETHODIMP
nsDocumentViewer::GetDeviceFullZoomForTest(float* aDeviceFullZoom) {
  NS_ENSURE_ARG_POINTER(aDeviceFullZoom);
  nsPresContext* pc = GetPresContext();
  *aDeviceFullZoom = pc ? pc->GetDeviceFullZoom() : 1.0;
  return NS_OK;
}

NS_IMETHODIMP
nsDocumentViewer::SetAuthorStyleDisabled(bool aStyleDisabled) {
  if (mPresShell) {
    mPresShell->SetAuthorStyleDisabled(aStyleDisabled);
  }
  return NS_OK;
}

NS_IMETHODIMP
nsDocumentViewer::GetAuthorStyleDisabled(bool* aStyleDisabled) {
  if (mPresShell) {
    *aStyleDisabled = mPresShell->GetAuthorStyleDisabled();
  } else {
    *aStyleDisabled = false;
  }
  return NS_OK;
}

/* [noscript,notxpcom] Encoding getHintCharset (); */
NS_IMETHODIMP_(const Encoding*)
nsDocumentViewer::GetReloadEncodingAndSource(int32_t* aSource) {
  *aSource = mReloadEncodingSource;
  if (kCharsetUninitialized == mReloadEncodingSource) {
    return nullptr;
  }
  return mReloadEncoding;
}

NS_IMETHODIMP_(void)
nsDocumentViewer::SetReloadEncodingAndSource(const Encoding* aEncoding,
                                             int32_t aSource) {
  MOZ_ASSERT(
      aSource == kCharsetUninitialized ||
      (aSource >=
           kCharsetFromFinalAutoDetectionWouldHaveBeenUTF8InitialWasASCII &&
       aSource <=
           kCharsetFromFinalAutoDetectionWouldNotHaveBeenUTF8DependedOnTLDInitialWasASCII) ||
      aSource == kCharsetFromFinalUserForcedAutoDetection);
  mReloadEncoding = aEncoding;
  mReloadEncodingSource = aSource;
}

NS_IMETHODIMP_(void)
nsDocumentViewer::ForgetReloadEncoding() {
  mReloadEncoding = nullptr;
  mReloadEncodingSource = kCharsetUninitialized;
}

MOZ_CAN_RUN_SCRIPT_BOUNDARY NS_IMETHODIMP nsDocumentViewer::GetContentSize(
    int32_t aMaxWidth, int32_t aMaxHeight, int32_t aPrefWidth, int32_t* aWidth,
    int32_t* aHeight) {
  NS_ENSURE_STATE(mContainer);

  RefPtr<BrowsingContext> bc = mContainer->GetBrowsingContext();
  NS_ENSURE_TRUE(bc, NS_ERROR_NOT_AVAILABLE);

  // It's only valid to access this from a top frame.  Doesn't work from
  // sub-frames.
  NS_ENSURE_TRUE(bc->IsTop(), NS_ERROR_FAILURE);

  // Convert max-width/height and pref-width to app units.
  if (aMaxWidth > 0) {
    aMaxWidth = CSSPixel::ToAppUnits(aMaxWidth);
  } else {
    aMaxWidth = NS_UNCONSTRAINEDSIZE;
  }
  if (aMaxHeight > 0) {
    aMaxHeight = CSSPixel::ToAppUnits(aMaxHeight);
  } else {
    aMaxHeight = NS_UNCONSTRAINEDSIZE;
  }
  if (aPrefWidth > 0) {
    aPrefWidth = CSSPixel::ToAppUnits(aPrefWidth);
  } else {
    aPrefWidth = 0;
  }

  RefPtr<PresShell> presShell = GetPresShell();
  NS_ENSURE_TRUE(presShell, NS_ERROR_FAILURE);

  // Flush out all content and style updates. We can't use a resize reflow
  // because it won't change some sizes that a style change reflow will.
  mDocument->FlushPendingNotifications(FlushType::Layout);

  nsIFrame* root = presShell->GetRootFrame();
  NS_ENSURE_TRUE(root, NS_ERROR_FAILURE);

  WritingMode wm = root->GetWritingMode();

  nscoord prefISize;
  {
    const auto& constraints = presShell->GetWindowSizeConstraints();
    aMaxHeight = std::min(aMaxHeight, constraints.mMaxSize.height);
    aMaxWidth = std::min(aMaxWidth, constraints.mMaxSize.width);

    UniquePtr<gfxContext> rcx(presShell->CreateReferenceRenderingContext());
    const nscoord minISize = wm.IsVertical() ? constraints.mMinSize.height
                                             : constraints.mMinSize.width;
    const nscoord maxISize = wm.IsVertical() ? aMaxHeight : aMaxWidth;
    const IntrinsicSizeInput input(rcx.get(), Nothing(), Nothing());
    if (aPrefWidth) {
      prefISize = std::max(root->GetMinISize(input), aPrefWidth);
    } else {
      prefISize = root->GetPrefISize(input);
    }
    prefISize = nsPresContext::RoundUpAppUnitsToCSSPixel(
        CSSMinMax(prefISize, minISize, maxISize));
  }

  // We should never intentionally get here with this sentinel value, but it's
  // possible that a document with huge sizes might inadvertently have a
  // prefISize that exactly matches NS_UNCONSTRAINEDSIZE.
  // Just bail if that happens.
  NS_ENSURE_TRUE(prefISize != NS_UNCONSTRAINEDSIZE, NS_ERROR_FAILURE);

  const nsSize size(wm.IsVertical() ? aMaxWidth : prefISize,
                    wm.IsVertical() ? prefISize : aMaxHeight);
  presShell->ResizeReflow(size, ResizeReflowOptions::BSizeLimit);

  RefPtr<nsPresContext> presContext = GetPresContext();
  NS_ENSURE_TRUE(presContext, NS_ERROR_FAILURE);

  // Protect against bogus returns here
  nsRect shellArea = presContext->GetVisibleArea();
  NS_ENSURE_TRUE(shellArea.width != NS_UNCONSTRAINEDSIZE &&
                     shellArea.height != NS_UNCONSTRAINEDSIZE,
                 NS_ERROR_FAILURE);

  // Leave our viewport in a consistent state.
  {
    auto newBounds = LayoutDeviceIntRect::FromAppUnitsToOutside(
        shellArea, presContext->AppUnitsPerDevPixel());
    newBounds.MoveTo(mBounds.TopLeft());
    SetBounds(newBounds);
  }

  // Ceil instead of rounding here, so we can actually guarantee showing all the
  // content.
  *aWidth = std::ceil(CSSPixel::FromAppUnits(shellArea.width));
  *aHeight = std::ceil(CSSPixel::FromAppUnits(shellArea.height));

  return NS_OK;
}

NS_IMPL_ISUPPORTS(nsDocViewerSelectionListener, nsISelectionListener)

/*
 * GetPopupNode, GetPopupLinkNode and GetPopupImageNode are helpers
 * for the cmd_copyLink / cmd_copyImageLocation / cmd_copyImageContents family
 * of commands. The focus controller stores the popup node, these retrieve
 * them and munge appropriately. Note that we have to store the popup node
 * rather than retrieving it from EventStateManager::GetFocusedContent because
 * not all content (images included) can receive focus.
 */

already_AddRefed<nsINode> nsDocumentViewer::GetPopupNode() {
  // get the document
  Document* document = GetDocument();
  NS_ENSURE_TRUE(document, nullptr);

  // get the private dom window
  nsCOMPtr<nsPIDOMWindowOuter> window(document->GetWindow());
  NS_ENSURE_TRUE(window, nullptr);
  if (window) {
    nsCOMPtr<nsPIWindowRoot> root = window->GetTopWindowRoot();
    NS_ENSURE_TRUE(root, nullptr);

    // get the popup node
    nsCOMPtr<nsINode> node = root->GetPopupNode();
    if (!node) {
      nsPIDOMWindowOuter* rootWindow = root->GetWindow();
      if (rootWindow) {
        nsCOMPtr<Document> rootDoc = rootWindow->GetExtantDoc();
        if (rootDoc) {
          nsXULPopupManager* pm = nsXULPopupManager::GetInstance();
          if (pm) {
            node = pm->GetLastTriggerPopupNode(rootDoc);
          }
        }
      }
    }
    return node.forget();
  }

  return nullptr;
}

// GetPopupLinkNode: return popup link node or fail
already_AddRefed<nsINode> nsDocumentViewer::GetPopupLinkNode() {
  // find popup node
  nsCOMPtr<nsINode> node = GetPopupNode();

  // find out if we have a link in our ancestry
  while (node) {
    if (const auto* element = Element::FromNode(*node)) {
      if (element->IsLink()) {
        return node.forget();
      }
    }

    // get our parent and keep trying...
    node = node->GetParentNode();
  }

  // if we have no node, fail
  return nullptr;
}

// GetPopupLinkNode: return popup image node or fail
already_AddRefed<nsIImageLoadingContent> nsDocumentViewer::GetPopupImageNode() {
  // find popup node
  nsCOMPtr<nsINode> node = GetPopupNode();
  nsCOMPtr<nsIImageLoadingContent> img = do_QueryInterface(node);
  return img.forget();
}

/*
 * XXX dr
 * ------
 * These two functions -- GetInLink and GetInImage -- are kind of annoying
 * in that they only get called from the controller (in
 * nsDOMWindowController::IsCommandEnabled). The actual construction of the
 * context menus in communicator (nsContextMenu.js) has its own, redundant
 * tests. No big deal, but good to keep in mind if we ever clean context
 * menus.
 */

NS_IMETHODIMP nsDocumentViewer::GetInLink(bool* aInLink) {
  NS_ENSURE_ARG_POINTER(aInLink);
  nsCOMPtr<nsINode> node = GetPopupLinkNode();
  *aInLink = !!node;
  return NS_OK;
}

NS_IMETHODIMP nsDocumentViewer::GetInImage(bool* aInImage) {
  NS_ENSURE_ARG_POINTER(aInImage);
  *aInImage = false;
  // get the popup image
  nsCOMPtr<nsIImageLoadingContent> node = GetPopupImageNode();
  if (!node) {
    return NS_OK;
  }

  // Make sure there is a URI assigned. This allows <input type="image"> to
  // be an image but rejects other <input> types. This matches what
  // nsContextMenu.js does.
  nsCOMPtr<nsIURI> uri;
  node->GetCurrentURI(getter_AddRefs(uri));
  if (uri) {
    // if we made it here, we're in an image
    *aInImage = true;
  }
  return NS_OK;
}

NS_IMETHODIMP nsDocViewerSelectionListener::NotifySelectionChanged(
    Document*, Selection*, int16_t aReason, int32_t aAmount) {
  if (!mDocViewer) {
    return NS_OK;
  }

  // get the selection state
  RefPtr<mozilla::dom::Selection> selection =
      mDocViewer->GetDocumentSelection();
  if (!selection) {
    return NS_ERROR_FAILURE;
  }

  Document* theDoc = mDocViewer->GetDocument();
  if (!theDoc) {
    return NS_ERROR_FAILURE;
  }

  nsCOMPtr<nsPIDOMWindowOuter> domWindow = theDoc->GetWindow();
  if (!domWindow) {
    return NS_ERROR_FAILURE;
  }

  bool selectionCollapsed = selection->IsCollapsed();
  // We only call UpdateCommands when the selection changes from collapsed to
  // non-collapsed or vice versa, however we skip the initializing collapse. We
  // might need another update string for simple selection changes, but that
  // would be expenseive.
  if (mSelectionWasCollapsed != selectionCollapsed) {
    domWindow->UpdateCommands(u"select"_ns);
    mSelectionWasCollapsed = selectionCollapsed;
  }

  return NS_OK;
}

/** ---------------------------------------------------
 *  From nsIWebBrowserPrint
 */

#ifdef NS_PRINTING

NS_IMETHODIMP
nsDocumentViewer::Print(nsIPrintSettings* aPrintSettings,
                        RemotePrintJobChild* aRemotePrintJob,
                        nsIWebProgressListener* aWebProgressListener) {
  if (NS_WARN_IF(!mContainer)) {
    PR_PL(("Container was destroyed yet we are still trying to use it!"));
    return NS_ERROR_FAILURE;
  }

  if (NS_WARN_IF(!mDocument) || NS_WARN_IF(!mDeviceContext)) {
    PR_PL(("Can't Print without a document and a device context"));
    return NS_ERROR_FAILURE;
  }

  if (NS_WARN_IF(mPrintJob && mPrintJob->GetIsPrinting())) {
    // If we are printing another URL, then exit.
    // The reason we check here is because this method can be called while
    // another is still in here (the printing dialog is a good example).  the
    // only time we can print more than one job at a time is the regression
    // tests.
    nsresult rv = NS_ERROR_NOT_AVAILABLE;
    RefPtr<nsPrintJob>(mPrintJob)->FirePrintingErrorEvent(rv);
    return rv;
  }

  OnDonePrinting();

  // Note: mContainer and mDocument are known to be non-null via null-checks
  // earlier in this function.
  // TODO(dholbert) Do we need to bother with this stack-owned local RefPtr?
  // (Is there an edge case where it's needed to keep the nsPrintJob alive?)
  auto printJob =
      MakeRefPtr<nsPrintJob>(*this, *mContainer, *mDocument,
                             float(AppUnitsPerCSSInch()) /
                                 float(mDeviceContext->AppUnitsPerDevPixel()));
  mPrintJob = printJob;

  nsresult rv = printJob->Print(*mDocument, aPrintSettings, aRemotePrintJob,
                                aWebProgressListener);
  if (NS_WARN_IF(NS_FAILED(rv))) {
    OnDonePrinting();
  }
  return rv;
}

NS_IMETHODIMP
nsDocumentViewer::PrintPreview(nsIPrintSettings* aPrintSettings,
                               nsIWebProgressListener* aWebProgressListener,
                               PrintPreviewResolver&& aCallback) {
  RefPtr<Document> doc = mDocument.get();
  NS_ENSURE_STATE(doc);

  if (NS_WARN_IF(GetIsPrinting())) {
    return NS_ERROR_FAILURE;
  }

  nsCOMPtr<nsIDocShell> docShell(mContainer);
  if (NS_WARN_IF(!docShell) || NS_WARN_IF(!mDeviceContext)) {
    PR_PL(("Can't Print Preview without device context and docshell"));
    return NS_ERROR_FAILURE;
  }

  NS_ENSURE_STATE(!GetIsPrinting());
  // beforeprint event may have caused DocumentViewer to be shutdown.
  NS_ENSURE_STATE(mContainer);
  NS_ENSURE_STATE(mDeviceContext);

  OnDonePrinting();

  // Note: mContainer and doc are known to be non-null via null-checks earlier
  // in this function.
  // TODO(dholbert) Do we need to bother with this stack-owned local RefPtr?
  // (Is there an edge case where it's needed to keep the nsPrintJob alive?)
  auto printJob =
      MakeRefPtr<nsPrintJob>(*this, *mContainer, *doc,
                             float(AppUnitsPerCSSInch()) /
                                 float(mDeviceContext->AppUnitsPerDevPixel()));
  mPrintJob = printJob;

  nsresult rv = printJob->PrintPreview(
      *doc, aPrintSettings, aWebProgressListener, std::move(aCallback));
  if (NS_WARN_IF(NS_FAILED(rv))) {
    OnDonePrinting();
  }
  return rv;
}

static const nsIFrame* GetTargetPageFrame(int32_t aTargetPageNum,
                                          nsPageSequenceFrame* aSequenceFrame) {
  MOZ_ASSERT(aTargetPageNum > 0 &&
             aTargetPageNum <=
                 aSequenceFrame->PrincipalChildList().GetLength());
  return aSequenceFrame->PrincipalChildList().FrameAt(aTargetPageNum - 1);
}

// Calculate the scroll position where the center of |aFrame| is positioned at
// the center of |aScrollContainerFrame|'s scroll port for the print preview.
// So what we do for that is;
// 1) Calculate the position of the center of |aFrame| in the print preview
//    coordinates.
// 2) Reduce the half height of the scroll port from the result of 1.
static nscoord ScrollPositionForFrame(
    const nsIFrame* aFrame, ScrollContainerFrame* aScrollContainerFrame,
    float aPreviewScale) {
  // Note that even if the computed scroll position is out of the range of
  // the scroll port, it gets clamped in ScrollContainerFrame::ScrollTo.
  return nscoord(aPreviewScale * aFrame->GetRect().Center().y -
                 float(aScrollContainerFrame->GetScrollPortRect().height) /
                     2.0f);
}

//----------------------------------------------------------------------
NS_IMETHODIMP
nsDocumentViewer::PrintPreviewScrollToPage(int16_t aType, int32_t aPageNum) {
  if (!GetIsPrintPreview() || mPrintJob->GetIsCreatingPrintPreview()) {
    return NS_ERROR_FAILURE;
  }

  ScrollContainerFrame* sf = mPresShell->GetRootScrollContainerFrame();
  if (!sf) {
    return NS_OK;
  }

  auto [seqFrame, sheetCount] = mPrintJob->GetSeqFrameAndCountSheets();
  (void)sheetCount;
  if (!seqFrame) {
    return NS_ERROR_FAILURE;
  }

  float previewScale = seqFrame->GetPrintPreviewScale();

  nsPoint dest = sf->GetScrollPosition();

  switch (aType) {
    case nsIWebBrowserPrint::PRINTPREVIEW_HOME:
      dest.y = 0;
      break;
    case nsIWebBrowserPrint::PRINTPREVIEW_END:
      dest.y = sf->GetScrollRange().YMost();
      break;
    case nsIWebBrowserPrint::PRINTPREVIEW_PREV_PAGE:
    case nsIWebBrowserPrint::PRINTPREVIEW_NEXT_PAGE: {
      auto [currentFrame, currentSheetNumber] = GetCurrentSheetFrameAndNumber();
      (void)currentSheetNumber;
      if (!currentFrame) {
        return NS_OK;
      }

      const nsIFrame* targetFrame = nullptr;
      if (aType == nsIWebBrowserPrint::PRINTPREVIEW_PREV_PAGE) {
        targetFrame = currentFrame->GetPrevInFlow();
      } else {
        targetFrame = currentFrame->GetNextInFlow();
      }
      if (!targetFrame) {
        return NS_OK;
      }

      dest.y = ScrollPositionForFrame(targetFrame, sf, previewScale);
      break;
    }
    case nsIWebBrowserPrint::PRINTPREVIEW_GOTO_PAGENUM: {
      if (aPageNum <= 0 || aPageNum > sheetCount) {
        return NS_ERROR_INVALID_ARG;
      }

      const nsIFrame* targetFrame = GetTargetPageFrame(aPageNum, seqFrame);
      MOZ_ASSERT(targetFrame);

      dest.y = ScrollPositionForFrame(targetFrame, sf, previewScale);
      break;
    }
    default:
      return NS_ERROR_INVALID_ARG;
      break;
  }

  sf->ScrollTo(dest, ScrollMode::Instant);

  return NS_OK;
}

std::tuple<const nsIFrame*, int32_t>
nsDocumentViewer::GetCurrentSheetFrameAndNumber() const {
  MOZ_ASSERT(mPrintJob);
  MOZ_ASSERT(GetIsPrintPreview() && !mPrintJob->GetIsCreatingPrintPreview());

  // in PP mPrtPreview->mPrintObject->mSeqFrame is null
  auto [seqFrame, sheetCount] = mPrintJob->GetSeqFrameAndCountSheets();
  (void)sheetCount;
  if (!seqFrame) {
    return {nullptr, 0};
  }

  ScrollContainerFrame* sf = mPresShell->GetRootScrollContainerFrame();
  if (!sf) {
    // No scrollable contents, returns 1 even if there are multiple sheets.
    return {seqFrame->PrincipalChildList().FirstChild(), 1};
  }

  nsPoint currentScrollPosition = sf->GetScrollPosition();
  float halfwayPoint =
      currentScrollPosition.y + float(sf->GetScrollPortRect().height) / 2.0f;
  float lastDistanceFromHalfwayPoint = std::numeric_limits<float>::max();
  int32_t sheetNumber = 0;
  const nsIFrame* currentSheet = nullptr;
  float previewScale = seqFrame->GetPrintPreviewScale();
  for (const nsIFrame* sheetFrame : seqFrame->PrincipalChildList()) {
    nsRect sheetRect = sheetFrame->GetRect();
    sheetNumber++;
    currentSheet = sheetFrame;

    float bottomOfSheet = sheetRect.YMost() * previewScale;
    if (bottomOfSheet < halfwayPoint) {
      // If the bottom of the sheet is not yet over the halfway point, iterate
      // the next frame to see if the next frame is over the halfway point and
      // compare the distance from the halfway point.
      lastDistanceFromHalfwayPoint = halfwayPoint - bottomOfSheet;
      continue;
    }

    float topOfSheet = sheetRect.Y() * previewScale;
    if (topOfSheet <= halfwayPoint) {
      // If the top of the sheet is not yet over the halfway point or on the
      // point, it's the current sheet.
      break;
    }

    // Now the sheet rect is completely over the halfway point, compare the
    // distances from the halfway point.
    if ((topOfSheet - halfwayPoint) >= lastDistanceFromHalfwayPoint) {
      // If the previous sheet distance is less than or equal to the current
      // sheet distance, choose the previous one as the current.
      sheetNumber--;
      MOZ_ASSERT(sheetNumber > 0);
      currentSheet = currentSheet->GetPrevInFlow();
      MOZ_ASSERT(currentSheet);
    }
    break;
  }

  MOZ_ASSERT(sheetNumber <= sheetCount);
  return {currentSheet, sheetNumber};
}

// XXXdholbert As noted in nsIWebBrowserPrint.idl, this API (the IDL attr
// 'printPreviewCurrentPageNumber') is misnamed and needs s/Page/Sheet/.  See
// bug 1669762.
NS_IMETHODIMP
nsDocumentViewer::GetPrintPreviewCurrentPageNumber(int32_t* aNumber) {
  NS_ENSURE_ARG_POINTER(aNumber);
  NS_ENSURE_TRUE(mPrintJob, NS_ERROR_FAILURE);
  if (!GetIsPrintPreview() || mPrintJob->GetIsCreatingPrintPreview()) {
    return NS_ERROR_FAILURE;
  }

  auto [currentFrame, currentSheetNumber] = GetCurrentSheetFrameAndNumber();
  (void)currentFrame;
  if (!currentSheetNumber) {
    return NS_ERROR_FAILURE;
  }

  *aNumber = currentSheetNumber;

  return NS_OK;
}

// XXX This always returns false for subdocuments
NS_IMETHODIMP
nsDocumentViewer::GetDoingPrint(bool* aDoingPrint) {
  NS_ENSURE_ARG_POINTER(aDoingPrint);

  // XXX shouldn't this be GetDoingPrint() ?
  *aDoingPrint = mPrintJob ? mPrintJob->CreatedForPrintPreview() : false;
  return NS_OK;
}

// XXX This always returns false for subdocuments
NS_IMETHODIMP
nsDocumentViewer::GetDoingPrintPreview(bool* aDoingPrintPreview) {
  NS_ENSURE_ARG_POINTER(aDoingPrintPreview);

  *aDoingPrintPreview = mPrintJob ? mPrintJob->CreatedForPrintPreview() : false;
  return NS_OK;
}

NS_IMETHODIMP
nsDocumentViewer::GetCloseWindowAfterPrint(bool* aCloseWindowAfterPrint) {
  NS_ENSURE_ARG_POINTER(aCloseWindowAfterPrint);

  *aCloseWindowAfterPrint = mCloseWindowAfterPrint;
  return NS_OK;
}

NS_IMETHODIMP
nsDocumentViewer::SetCloseWindowAfterPrint(bool aCloseWindowAfterPrint) {
  mCloseWindowAfterPrint = aCloseWindowAfterPrint;
  return NS_OK;
}

NS_IMETHODIMP
nsDocumentViewer::ExitPrintPreview() {
  NS_ENSURE_TRUE(mPrintJob, NS_ERROR_FAILURE);

  if (GetIsPrinting()) {
    // Block exiting the print preview window if we're in the middle of an
    // actual print.
    return NS_ERROR_FAILURE;
  }

  if (!GetIsPrintPreview()) {
    NS_ERROR("Wow, we should never get here!");
    return NS_OK;
  }

  RefPtr printJob = std::move(mPrintJob);
  printJob->Destroy();

  // Since the print preview implementation discards the window that was used
  // to show the print preview, we skip certain cleanup that we would otherwise
  // want to do.  Specifically, we do not call `SetIsPrintPreview(false)` to
  // unblock navigation, we do not call `SetOverrideDPPX` to reset the
  // devicePixelRatio, and we do not call `Show` to make such changes take
  // affect.

  return NS_OK;
}

NS_IMETHODIMP
nsDocumentViewer::GetRawNumPages(int32_t* aRawNumPages) {
  NS_ENSURE_ARG_POINTER(aRawNumPages);
  NS_ENSURE_TRUE(mPrintJob, NS_ERROR_FAILURE);

  *aRawNumPages = mPrintJob->GetRawNumPages();
  return *aRawNumPages > 0 ? NS_OK : NS_ERROR_FAILURE;
}

// XXXdholbert As noted in nsIWebBrowserPrint.idl, this API (the IDL attr
// 'printPreviewNumPages') is misnamed and needs s/Page/Sheet/.
// See bug 1669762.
NS_IMETHODIMP
nsDocumentViewer::GetPrintPreviewNumPages(int32_t* aPrintPreviewNumPages) {
  NS_ENSURE_ARG_POINTER(aPrintPreviewNumPages);
  NS_ENSURE_TRUE(mPrintJob, NS_ERROR_FAILURE);
  *aPrintPreviewNumPages = mPrintJob->GetPrintPreviewNumSheets();
  return *aPrintPreviewNumPages > 0 ? NS_OK : NS_ERROR_FAILURE;
}

//----------------------------------------------------------------------------------
// Printing/Print Preview Helpers
//----------------------------------------------------------------------------------

//----------------------------------------------------------------------------------
// Walks the document tree and tells each DocShell whether Printing/PP is
// happening
#endif  // NS_PRINTING

//------------------------------------------------------------
// XXX this always returns false for subdocuments
bool nsDocumentViewer::GetIsPrinting() const {
#ifdef NS_PRINTING
  if (mPrintJob) {
    return mPrintJob->GetIsPrinting();
  }
#endif
  return false;
}

//------------------------------------------------------------
// The PrintJob holds the current value
// this called from inside the DocViewer.
// XXX it always returns false for subdocuments
bool nsDocumentViewer::GetIsPrintPreview() const {
#ifdef NS_PRINTING
  return mPrintJob && mPrintJob->CreatedForPrintPreview();
#else
  return false;
#endif
}

//------------------------------------------------------------
// Notification from the PrintJob of the current PP status
void nsDocumentViewer::SetIsPrintPreview(bool aIsPrintPreview) {
  // Protect against pres shell destruction running scripts.
  nsAutoScriptBlocker scriptBlocker;

  if (!aIsPrintPreview) {
    InvalidatePotentialSubDocDisplayItem();
    if (mPresShell) {
      DestroyPresShell();
    }
    mWindow = nullptr;
    mPresContext = nullptr;
    mPresShell = nullptr;
  }
}

//----------------------------------------------------------------------------------
// nsIDocumentViewerPrint IFace
//----------------------------------------------------------------------------------

//------------------------------------------------------------
void nsDocumentViewer::IncrementDestroyBlockedCount() {
  ++mDestroyBlockedCount;
}

void nsDocumentViewer::DecrementDestroyBlockedCount() {
  --mDestroyBlockedCount;
}

//------------------------------------------------------------
// This called ONLY when printing has completed and the DV
// is being notified that it should get rid of the nsPrintJob.
//
// BUT, if we are in Print Preview then we want to ignore the
// notification (we do not get rid of the nsPrintJob)
//
// One small caveat:
//   This IS called from two places in this module for cleaning
//   up when an error occurred during the start up printing
//   and print preview
//
void nsDocumentViewer::OnDonePrinting() {
#ifdef NS_PRINTING
  RefPtr printJob = std::move(mPrintJob);
  if (!printJob) {
    // If Destroy() has been called during calling nsPrintJob::Print() or
    // nsPrintJob::PrintPreview(), mPrintJob is already nullptr here.
    // So, the following clean up does nothing in such case.
    // (Do we need some of this for that case?)
    return;
  }
  if (GetIsPrintPreview()) {
    printJob->DestroyPrintingData();
  } else {
    printJob->Destroy();
  }

// We are done printing, now clean up.
//
// If the original document to print was not a static clone, we opened a new
// window and are responsible for cleaning up the whole <browser> or window
// (see the OPEN_PRINT_BROWSER code, specifically
// handleStaticCloneCreatedForPrint()), so gotta run window.close(), which
// will take care of this.
//
// Otherwise the front-end code is responsible for cleaning the UI.
#  ifdef ANDROID
  // Android doesn't support Content Analysis and prints in a different way,
  // so use different logic to clean up.
  bool closeWindowAfterPrint = !printJob->CreatedForPrintPreview();
#  else
  bool closeWindowAfterPrint = GetCloseWindowAfterPrint();
#  endif
  if (closeWindowAfterPrint) {
    if (mContainer) {
      if (nsCOMPtr<nsPIDOMWindowOuter> win = mContainer->GetWindow()) {
        win->Close();
      }
    }
  } else if (mClosingWhilePrinting) {
    if (nsCOMPtr doc = std::move(mDocument)) {
      doc->Destroy();
    }
    mClosingWhilePrinting = false;
  }
#endif  // NS_PRINTING
}

NS_IMETHODIMP nsDocumentViewer::SetPrintSettingsForSubdocument(
    nsIPrintSettings* aPrintSettings, RemotePrintJobChild* aRemotePrintJob) {
#ifdef NS_PRINTING
  {
    nsAutoScriptBlocker scriptBlocker;

    if (mPresShell) {
      DestroyPresShell();
    }

    if (mPresContext) {
      DestroyPresContext();
    }

    MOZ_ASSERT(!mPresContext);
    MOZ_ASSERT(!mPresShell);

    if (MOZ_UNLIKELY(!mDocument)) {
      return NS_ERROR_NOT_AVAILABLE;
    }

    auto devspec = MakeRefPtr<nsDeviceContextSpecProxy>(aRemotePrintJob);
    MOZ_TRY(devspec->Init(aPrintSettings, /* aIsPrintPreview = */ true));
    mDeviceContext = MakeRefPtr<nsDeviceContext>();
    MOZ_TRY(mDeviceContext->InitForPrinting(devspec));
    mPresContext = CreatePresContext(
        mDocument, nsPresContext::eContext_PrintPreview, FindContainerFrame());
    mPresContext->SetPrintSettings(aPrintSettings);
    mPresContext->Init(mDeviceContext);
    MOZ_TRY(InitPresentationStuff(true));
  }

  RefPtr<PresShell> shell = mPresShell;
  shell->FlushPendingNotifications(FlushType::Layout);
#endif
  return NS_OK;
}

NS_IMETHODIMP nsDocumentViewer::SetPageModeForTesting(
    bool aPageMode, nsIPrintSettings* aPrintSettings) {
  // The DestroyPresShell call requires a script blocker, since the
  // PresShell::Destroy call it does can cause scripts to run, which could
  // re-entrantly call methods on the nsDocumentViewer.
  nsAutoScriptBlocker scriptBlocker;

  if (mPresShell) {
    DestroyPresShell();
  }

  if (mPresContext) {
    DestroyPresContext();
  }

  mWindow = nullptr;

  NS_ENSURE_STATE(mDocument);
  if (aPageMode) {
    mPresContext = CreatePresContext(
        mDocument, nsPresContext::eContext_PageLayout, FindContainerFrame());
    NS_ENSURE_TRUE(mPresContext, NS_ERROR_OUT_OF_MEMORY);
    mPresContext->SetPaginatedScrolling(true);
    mPresContext->SetPrintSettings(aPrintSettings);
    mPresContext->Init(mDeviceContext);

    double pageWidth = 0, pageHeight = 0;
    aPrintSettings->GetEffectivePageSize(&pageWidth, &pageHeight);
    mPresContext->SetPageSize(
        nsSize(mPresContext->CSSTwipsToAppUnits(NSToIntFloor(pageWidth)),
               mPresContext->CSSTwipsToAppUnits(NSToIntFloor(pageHeight))));
    mPresContext->SetIsRootPaginatedDocument(true);
    mPresContext->SetPageScale(1.0f);
  }

  MOZ_TRY(InitInternal(mParentWidget, nullptr, mBounds, true, false, false));

  Show();
  return NS_OK;
}

NS_IMETHODIMP
nsDocumentViewer::GetIsTabModalPromptAllowed(bool* aAllowed) {
  *aAllowed = !mHidden;
  return NS_OK;
}

NS_IMETHODIMP
nsDocumentViewer::GetIsHidden(bool* aHidden) {
  *aHidden = mHidden;
  return NS_OK;
}

NS_IMETHODIMP
nsDocumentViewer::SetIsHidden(bool aHidden) {
  mHidden = aHidden;
  return NS_OK;
}

void nsDocumentViewer::DestroyPresShell() {
  // We assert this because destroying the pres shell could otherwise cause
  // re-entrancy into nsDocumentViewer methods, and all callers of
  // DestroyPresShell need to do other cleanup work afterwards before it
  // is safe for those re-entrant method calls to be made.
  MOZ_ASSERT(!nsContentUtils::IsSafeToRunScript(),
             "DestroyPresShell must only be called when scripts are blocked");

  // Break circular reference (or something)
  mPresShell->EndObservingDocument();

  RefPtr<mozilla::dom::Selection> selection = GetDocumentSelection();
  if (selection && mSelectionListener) {
    selection->RemoveSelectionListener(mSelectionListener);
  }

  RefPtr ps = std::move(mPresShell);
  ps->Destroy();
}

void nsDocumentViewer::InvalidatePotentialSubDocDisplayItem() {
  if (nsSubDocumentFrame* f = FindContainerFrame()) {
    f->MarkNeedsDisplayItemRebuild();
  }
}

void nsDocumentViewer::DestroyPresContext() {
  InvalidatePotentialSubDocDisplayItem();
  mPresContext = nullptr;
}

void nsDocumentViewer::SetPrintPreviewPresentation(nsPresContext* aPresContext,
                                                   PresShell* aPresShell) {
  // Protect against pres shell destruction running scripts and re-entrantly
  // creating a new presentation.
  nsAutoScriptBlocker scriptBlocker;

  if (mPresShell) {
    DestroyPresShell();
  }

  mWindow = nullptr;
  mPresContext = aPresContext;
  mPresShell = aPresShell;

  AttachToTopLevelWidget();
}

// Fires the "document-shown" event so that interested parties are aware of it.
NS_IMETHODIMP
nsDocumentShownDispatcher::Run() {
  nsCOMPtr<nsIObserverService> observerService =
      mozilla::services::GetObserverService();
  if (observerService) {
    observerService->NotifyObservers(ToSupports(mDocument), "document-shown",
                                     nullptr);
  }
  return NS_OK;
}
