/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef nsDocShell_h__
#define nsDocShell_h__

#include "nsITimer.h"
#include "nsContentPolicyUtils.h"
#include "nsIDocShell.h"
#include "nsIDocShellTreeItem.h"
#include "nsIBaseWindow.h"
#include "nsINetworkInterceptController.h"
#include "nsIScrollable.h"
#include "nsITextScroll.h"
#include "nsIContentViewerContainer.h"
#include "nsIDOMStorageManager.h"
#include "nsDocLoader.h"
#include "mozilla/BasePrincipal.h"
#include "mozilla/UniquePtr.h"
#include "mozilla/WeakPtr.h"
#include "mozilla/TimeStamp.h"
#include "GeckoProfiler.h"
#include "mozilla/dom/ProfileTimelineMarkerBinding.h"
#include "mozilla/LinkedList.h"
#include "jsapi.h"

// Helper Classes
#include "nsCOMPtr.h"
#include "nsPoint.h" // mCurrent/mDefaultScrollbarPreferences
#include "nsString.h"
#include "nsAutoPtr.h"
#include "nsThreadUtils.h"
#include "nsContentUtils.h"
#include "timeline/ObservedDocShell.h"
#include "timeline/TimelineConsumers.h"
#include "timeline/TimelineMarker.h"

// Threshold value in ms for META refresh based redirects
#define REFRESH_REDIRECT_TIMER 15000

// Interfaces Needed
#include "nsIDocCharset.h"
#include "nsIInterfaceRequestor.h"
#include "nsIRefreshURI.h"
#include "nsIWebNavigation.h"
#include "nsIWebPageDescriptor.h"
#include "nsIWebProgressListener.h"
#include "nsIDocShellLoadInfo.h"
#include "nsIAuthPromptProvider.h"
#include "nsILoadContext.h"
#include "nsIWebShellServices.h"
#include "nsILinkHandler.h"
#include "nsIClipboardCommands.h"
#include "nsITabParent.h"
#include "nsCRT.h"
#include "prtime.h"
#include "nsRect.h"
#include "Units.h"
#include "nsIDeprecationWarner.h"

namespace mozilla {
enum class TaskCategory;
namespace dom {
class EventTarget;
class PendingGlobalHistoryEntry;
typedef uint32_t ScreenOrientationInternal;
} // namespace dom
} // namespace mozilla

class nsDocShell;
class nsDOMNavigationTiming;
class nsGlobalWindow;
class nsIController;
class nsIScrollableFrame;
class OnLinkClickEvent;
class nsDSURIContentListener;
class nsDocShellEditorData;
class nsIClipboardDragDropHookList;
class nsICommandManager;
class nsIContentViewer;
class nsIDocument;
class nsIDOMNode;
class nsIDocShellTreeOwner;
class nsIGlobalHistory2;
class nsIHttpChannel;
class nsIMutableArray;
class nsIPrompt;
class nsISHistory;
class nsISecureBrowserUI;
class nsIStringBundle;
class nsIURIFixup;
class nsIURILoader;
class nsIWebBrowserFind;
class nsIWidget;

/* internally used ViewMode types */
enum ViewMode
{
  viewNormal = 0x0,
  viewSource = 0x1
};

class nsRefreshTimer : public nsITimerCallback
{
public:
  nsRefreshTimer();

  NS_DECL_THREADSAFE_ISUPPORTS
  NS_DECL_NSITIMERCALLBACK

  int32_t GetDelay() { return mDelay ;}

  RefPtr<nsDocShell> mDocShell;
  nsCOMPtr<nsIURI> mURI;
  int32_t mDelay;
  bool mRepeat;
  bool mMetaRefresh;

protected:
  virtual ~nsRefreshTimer();
};

enum eCharsetReloadState
{
  eCharsetReloadInit,
  eCharsetReloadRequested,
  eCharsetReloadStopOrigional
};

class nsDocShell final
  : public nsDocLoader
  , public nsIDocShell
  , public nsIWebNavigation
  , public nsIBaseWindow
  , public nsIScrollable
  , public nsITextScroll
  , public nsIDocCharset
  , public nsIContentViewerContainer
  , public nsIRefreshURI
  , public nsIWebProgressListener
  , public nsIWebPageDescriptor
  , public nsIAuthPromptProvider
  , public nsILoadContext
  , public nsIWebShellServices
  , public nsILinkHandler
  , public nsIClipboardCommands
  , public nsIDOMStorageManager
  , public nsINetworkInterceptController
  , public nsIDeprecationWarner
  , public mozilla::SupportsWeakPtr<nsDocShell>
{
  friend class nsDSURIContentListener;

public:
  MOZ_DECLARE_WEAKREFERENCE_TYPENAME(nsDocShell)

  nsDocShell();

  virtual nsresult Init() override;

  NS_DECL_ISUPPORTS_INHERITED

  NS_DECL_NSIDOCSHELL
  NS_DECL_NSIDOCSHELLTREEITEM
  NS_DECL_NSIWEBNAVIGATION
  NS_DECL_NSIBASEWINDOW
  NS_DECL_NSISCROLLABLE
  NS_DECL_NSITEXTSCROLL
  NS_DECL_NSIDOCCHARSET
  NS_DECL_NSIINTERFACEREQUESTOR
  NS_DECL_NSIWEBPROGRESSLISTENER
  NS_DECL_NSIREFRESHURI
  NS_DECL_NSICONTENTVIEWERCONTAINER
  NS_DECL_NSIWEBPAGEDESCRIPTOR
  NS_DECL_NSIAUTHPROMPTPROVIDER
  NS_DECL_NSICLIPBOARDCOMMANDS
  NS_DECL_NSIWEBSHELLSERVICES
  NS_DECL_NSINETWORKINTERCEPTCONTROLLER
  NS_DECL_NSIDEPRECATIONWARNER
  NS_FORWARD_SAFE_NSIDOMSTORAGEMANAGER(TopSessionStorageManager())

  NS_IMETHOD Stop() override
  {
    // Need this here because otherwise nsIWebNavigation::Stop
    // overrides the docloader's Stop()
    return nsDocLoader::Stop();
  }

  // Need to implement (and forward) nsISecurityEventSink, because
  // nsIWebProgressListener has methods with identical names...
  NS_FORWARD_NSISECURITYEVENTSINK(nsDocLoader::)

  // nsILinkHandler
  NS_IMETHOD OnLinkClick(nsIContent* aContent,
                         nsIURI* aURI,
                         const char16_t* aTargetSpec,
                         const nsAString& aFileName,
                         nsIInputStream* aPostDataStream,
                         nsIInputStream* aHeadersDataStream,
                         bool aIsTrusted,
                         nsIPrincipal* aTriggeringPrincipal) override;
  NS_IMETHOD OnLinkClickSync(nsIContent* aContent,
                             nsIURI* aURI,
                             const char16_t* aTargetSpec,
                             const nsAString& aFileName,
                             nsIInputStream* aPostDataStream = 0,
                             nsIInputStream* aHeadersDataStream = 0,
                             bool aNoOpenerImplied = false,
                             nsIDocShell** aDocShell = 0,
                             nsIRequest** aRequest = 0,
                             nsIPrincipal* aTriggeringPrincipal = nullptr) override;
  NS_IMETHOD OnOverLink(nsIContent* aContent,
                        nsIURI* aURI,
                        const char16_t* aTargetSpec) override;
  NS_IMETHOD OnLeaveLink() override;

  nsDocShellInfoLoadType ConvertLoadTypeToDocShellLoadInfo(uint32_t aLoadType);
  uint32_t ConvertDocShellLoadInfoToLoadType(
    nsDocShellInfoLoadType aDocShellLoadType);

  // Don't use NS_DECL_NSILOADCONTEXT because some of nsILoadContext's methods
  // are shared with nsIDocShell (appID, etc.) and can't be declared twice.
  NS_IMETHOD GetAssociatedWindow(mozIDOMWindowProxy**) override;
  NS_IMETHOD GetTopWindow(mozIDOMWindowProxy**) override;
  NS_IMETHOD GetTopFrameElement(nsIDOMElement**) override;
  NS_IMETHOD GetNestedFrameId(uint64_t*) override;
  NS_IMETHOD GetIsContent(bool*) override;
  NS_IMETHOD GetUsePrivateBrowsing(bool*) override;
  NS_IMETHOD SetUsePrivateBrowsing(bool) override;
  NS_IMETHOD SetPrivateBrowsing(bool) override;
  NS_IMETHOD GetUseRemoteTabs(bool*) override;
  NS_IMETHOD SetRemoteTabs(bool) override;
  NS_IMETHOD GetScriptableOriginAttributes(JS::MutableHandle<JS::Value>) override;

  // Restores a cached presentation from history (mLSHE).
  // This method swaps out the content viewer and simulates loads for
  // subframes. It then simulates the completion of the toplevel load.
  nsresult RestoreFromHistory();

  // Perform a URI load from a refresh timer. This is just like the
  // ForceRefreshURI method on nsIRefreshURI, but makes sure to take
  // the timer involved out of mRefreshURIList if it's there.
  // aTimer must not be null.
  nsresult ForceRefreshURIFromTimer(nsIURI* aURI, int32_t aDelay,
                                    bool aMetaRefresh, nsITimer* aTimer);

  friend class OnLinkClickEvent;

  // We need dummy OnLocationChange in some cases to update the UI without
  // updating security info.
  void FireDummyOnLocationChange()
  {
    FireOnLocationChange(this, nullptr, mCurrentURI,
                         LOCATION_CHANGE_SAME_DOCUMENT);
  }

  nsresult HistoryTransactionRemoved(int32_t aIndex);

  // Notify Scroll observers when an async panning/zooming transform
  // has started being applied
  void NotifyAsyncPanZoomStarted();
  // Notify Scroll observers when an async panning/zooming transform
  // is no longer applied
  void NotifyAsyncPanZoomStopped();

  void SetInFrameSwap(bool aInSwap)
  {
    mInFrameSwap = aInSwap;
  }
  bool InFrameSwap();

private:
  bool CanSetOriginAttributes();

public:
  const mozilla::OriginAttributes&
  GetOriginAttributes()
  {
    return mOriginAttributes;
  }

  nsresult SetOriginAttributes(const mozilla::OriginAttributes& aAttrs);

  void GetInterceptedDocumentId(nsAString& aId)
  {
    aId = mInterceptedDocumentId;
  }

private:
  // An observed docshell wrapper is created when recording markers is enabled.
  mozilla::UniquePtr<mozilla::ObservedDocShell> mObserved;

  // It is necessary to allow adding a timeline marker wherever a docshell
  // instance is available. This operation happens frequently and needs to
  // be very fast, so instead of using a Map or having to search for some
  // docshell-specific markers storage, a pointer to an `ObservedDocShell` is
  // is stored on docshells directly.
  friend void mozilla::TimelineConsumers::AddConsumer(nsDocShell*);
  friend void mozilla::TimelineConsumers::RemoveConsumer(nsDocShell*);
  friend void mozilla::TimelineConsumers::AddMarkerForDocShell(
    nsDocShell*, const char*, MarkerTracingType, MarkerStackRequest);
  friend void mozilla::TimelineConsumers::AddMarkerForDocShell(
    nsDocShell*, const char*, const TimeStamp&, MarkerTracingType,
    MarkerStackRequest);
  friend void mozilla::TimelineConsumers::AddMarkerForDocShell(
    nsDocShell*, UniquePtr<AbstractTimelineMarker>&&);
  friend void mozilla::TimelineConsumers::PopMarkers(nsDocShell*,
    JSContext*, nsTArray<dom::ProfileTimelineMarker>&);

public:
  // Tell the favicon service that aNewURI has the same favicon as aOldURI.
  static void CopyFavicon(nsIURI* aOldURI,
                          nsIURI* aNewURI,
                          nsIPrincipal* aLoadingPrincipal,
                          bool aInPrivateBrowsing);

  static nsDocShell* Cast(nsIDocShell* aDocShell)
  {
    return static_cast<nsDocShell*>(aDocShell);
  }

protected:
  virtual ~nsDocShell();
  virtual void DestroyChildren() override;

  // Content Viewer Management
  nsresult EnsureContentViewer();
  // aPrincipal can be passed in if the caller wants. If null is
  // passed in, the about:blank principal will end up being used.
  nsresult CreateAboutBlankContentViewer(nsIPrincipal* aPrincipal,
                                         nsIURI* aBaseURI,
                                         bool aTryToSaveOldPresentation = true,
                                         bool aCheckPermitUnload = true);
  nsresult CreateContentViewer(const nsACString& aContentType,
                               nsIRequest* aRequest,
                               nsIStreamListener** aContentHandler);
  nsresult NewContentViewerObj(const nsACString& aContentType,
                               nsIRequest* aRequest, nsILoadGroup* aLoadGroup,
                               nsIStreamListener** aContentHandler,
                               nsIContentViewer** aViewer);
  nsresult SetupNewViewer(nsIContentViewer* aNewViewer);

  void SetupReferrerFromChannel(nsIChannel* aChannel);

  nsresult GetEldestPresContext(nsPresContext** aPresContext);

  // Get the principal that we'll set on the channel if we're inheriting. If
  // aConsiderCurrentDocument is true, we try to use the current document if
  // at all possible. If that fails, we fall back on the parent document.
  // If that fails too, we force creation of a content viewer and use the
  // resulting principal. If aConsiderCurrentDocument is false, we just look
  // at the parent.
  nsIPrincipal* GetInheritedPrincipal(bool aConsiderCurrentDocument);

  // Actually open a channel and perform a URI load. Callers need to pass a
  // non-null aTriggeringPrincipal which initiated the URI load. Please note
  // that aTriggeringPrincipal will be used for performing security checks.
  // If the argument aURI is provided by the web, then please do not pass a
  // SystemPrincipal as the triggeringPrincipal. If principalToInherit is
  // null, then no inheritance of any sort will happen and the load will
  // get a principal based on the URI being loaded.
  // If aSrcdoc is not void, the load will be considered as a srcdoc load,
  // and the contents of aSrcdoc will be loaded instead of aURI.
  // aOriginalURI will be set as the originalURI on the channel that does the
  // load. If aOriginalURI is null, aURI will be set as the originalURI.
  // If aLoadReplace is true, LOAD_REPLACE flag will be set to the nsIChannel.
  nsresult DoURILoad(nsIURI* aURI,
                     nsIURI* aOriginalURI,
                     bool aLoadReplace,
                     nsIURI* aReferrer,
                     bool aSendReferrer,
                     uint32_t aReferrerPolicy,
                     nsIPrincipal* aTriggeringPrincipal,
                     nsIPrincipal* aPrincipalToInherit,
                     const char* aTypeHint,
                     const nsAString& aFileName,
                     nsIInputStream* aPostData,
                     nsIInputStream* aHeadersData,
                     bool aFirstParty,
                     nsIDocShell** aDocShell,
                     nsIRequest** aRequest,
                     bool aIsNewWindowTarget,
                     bool aBypassClassifier,
                     bool aForceAllowCookies,
                     const nsAString& aSrcdoc,
                     nsIURI* aBaseURI,
                     nsContentPolicyType aContentPolicyType);
  nsresult AddHeadersToChannel(nsIInputStream* aHeadersData,
                               nsIChannel* aChannel);
  nsresult DoChannelLoad(nsIChannel* aChannel,
                         nsIURILoader* aURILoader,
                         bool aBypassClassifier);

  nsresult ScrollToAnchor(bool aCurHasRef,
                          bool aNewHasRef,
                          nsACString& aNewHash,
                          uint32_t aLoadType);

  // Returns true if would have called FireOnLocationChange,
  // but did not because aFireOnLocationChange was false on entry.
  // In this case it is the caller's responsibility to ensure
  // FireOnLocationChange is called.
  // In all other cases false is returned.
  bool OnLoadingSite(nsIChannel* aChannel,
                     bool aFireOnLocationChange,
                     bool aAddToGlobalHistory = true);

  // Returns true if would have called FireOnLocationChange,
  // but did not because aFireOnLocationChange was false on entry.
  // In this case it is the caller's responsibility to ensure
  // FireOnLocationChange is called.
  // In all other cases false is returned.
  // Either aChannel or aTriggeringPrincipal must be null. If aChannel is
  // present, the owner should be gotten from it.
  // If OnNewURI calls AddToSessionHistory, it will pass its
  // aCloneSHChildren argument as aCloneChildren.
  bool OnNewURI(nsIURI* aURI, nsIChannel* aChannel,
                nsIPrincipal* aTriggeringPrincipal,
                nsIPrincipal* aPrincipalToInherit,
                uint32_t aLoadType,
                bool aFireOnLocationChange,
                bool aAddToGlobalHistory,
                bool aCloneSHChildren);

  void SetReferrerURI(nsIURI* aURI);
  void SetReferrerPolicy(uint32_t aReferrerPolicy);

  // Session History
  bool ShouldAddToSessionHistory(nsIURI* aURI);
  // Either aChannel or aOwner must be null. If aChannel is
  // present, the owner should be gotten from it.
  // If aCloneChildren is true, then our current session history's
  // children will be cloned onto the new entry. This should be
  // used when we aren't actually changing the document while adding
  // the new session history entry.
  nsresult AddToSessionHistory(nsIURI* aURI, nsIChannel* aChannel,
                               nsIPrincipal* aTriggeringPrincipal,
                               nsIPrincipal* aPrincipalToInherit,
                               bool aCloneChildren,
                               nsISHEntry** aNewEntry);
  nsresult AddChildSHEntryToParent(nsISHEntry* aNewEntry, int32_t aChildOffset,
                                   bool aCloneChildren);

  nsresult AddChildSHEntryInternal(nsISHEntry* aCloneRef, nsISHEntry* aNewEntry,
                                   int32_t aChildOffset, uint32_t aLoadType,
                                   bool aCloneChildren);

  nsresult LoadHistoryEntry(nsISHEntry* aEntry, uint32_t aLoadType);
  nsresult PersistLayoutHistoryState();

  // Clone a session history tree for subframe navigation.
  // The tree rooted at |aSrcEntry| will be cloned into |aDestEntry|, except
  // for the entry with id |aCloneID|, which will be replaced with
  // |aReplaceEntry|. |aSrcShell| is a (possibly null) docshell which
  // corresponds to |aSrcEntry| via its mLSHE or mOHE pointers, and will
  // have that pointer updated to point to the cloned history entry.
  // If aCloneChildren is true then the children of the entry with id
  // |aCloneID| will be cloned into |aReplaceEntry|.
  static nsresult CloneAndReplace(nsISHEntry* aSrcEntry,
                                  nsDocShell* aSrcShell,
                                  uint32_t aCloneID,
                                  nsISHEntry* aReplaceEntry,
                                  bool aCloneChildren,
                                  nsISHEntry** aDestEntry);

  // Child-walking callback for CloneAndReplace
  static nsresult CloneAndReplaceChild(nsISHEntry* aEntry, nsDocShell* aShell,
                                       int32_t aChildIndex, void* aData);

  nsresult GetRootSessionHistory(nsISHistory** aReturn);
  nsresult GetHttpChannel(nsIChannel* aChannel, nsIHttpChannel** aReturn);
  bool ShouldDiscardLayoutState(nsIHttpChannel* aChannel);

  // Determine whether this docshell corresponds to the given history entry,
  // via having a pointer to it in mOSHE or mLSHE.
  bool HasHistoryEntry(nsISHEntry* aEntry) const
  {
    return aEntry && (aEntry == mOSHE || aEntry == mLSHE);
  }

  // Update any pointers (mOSHE or mLSHE) to aOldEntry to point to aNewEntry
  void SwapHistoryEntries(nsISHEntry* aOldEntry, nsISHEntry* aNewEntry);

  // Call this method to swap in a new history entry to m[OL]SHE, rather than
  // setting it directly. This completes the navigation in all docshells
  // in the case of a subframe navigation.
  void SetHistoryEntry(nsCOMPtr<nsISHEntry>* aPtr, nsISHEntry* aEntry);

  // Child-walking callback for SetHistoryEntry
  static nsresult SetChildHistoryEntry(nsISHEntry* aEntry, nsDocShell* aShell,
                                       int32_t aEntryIndex, void* aData);

  // Callback prototype for WalkHistoryEntries.
  // aEntry is the child history entry, aShell is its corresponding docshell,
  // aChildIndex is the child's index in its parent entry, and aData is
  // the opaque pointer passed to WalkHistoryEntries.
  typedef nsresult(*WalkHistoryEntriesFunc)(nsISHEntry* aEntry,
                                            nsDocShell* aShell,
                                            int32_t aChildIndex,
                                            void* aData);

  // For each child of aRootEntry, find the corresponding docshell which is
  // a child of aRootShell, and call aCallback. The opaque pointer aData
  // is passed to the callback.
  static nsresult WalkHistoryEntries(nsISHEntry* aRootEntry,
                                     nsDocShell* aRootShell,
                                     WalkHistoryEntriesFunc aCallback,
                                     void* aData);

  // overridden from nsDocLoader, this provides more information than the
  // normal OnStateChange with flags STATE_REDIRECTING
  virtual void OnRedirectStateChange(nsIChannel* aOldChannel,
                                     nsIChannel* aNewChannel,
                                     uint32_t aRedirectFlags,
                                     uint32_t aStateFlags) override;

  /**
   * Helper function that determines if channel is an HTTP POST.
   *
   * @param aChannel
   *        The channel to test
   *
   * @return True iff channel is an HTTP post.
   */
  bool ChannelIsPost(nsIChannel* aChannel);

  /**
   * Helper function that finds the last URI and its transition flags for a
   * channel.
   *
   * This method first checks the channel's property bag to see if previous
   * info has been saved. If not, it gives back the referrer of the channel.
   *
   * @param aChannel
   *        The channel we are transitioning to
   * @param aURI
   *        Output parameter with the previous URI, not addref'd
   * @param aChannelRedirectFlags
   *        If a redirect, output parameter with the previous redirect flags
   *        from nsIChannelEventSink
   */
  void ExtractLastVisit(nsIChannel* aChannel,
                        nsIURI** aURI,
                        uint32_t* aChannelRedirectFlags);

  /**
   * Helper function that caches a URI and a transition for saving later.
   *
   * @param aChannel
   *        Channel that will have these properties saved
   * @param aURI
   *        The URI to save for later
   * @param aChannelRedirectFlags
   *        The nsIChannelEventSink redirect flags to save for later
   */
  void SaveLastVisit(nsIChannel* aChannel,
                     nsIURI* aURI,
                     uint32_t aChannelRedirectFlags);

  /**
   * Helper function for adding a URI visit using IHistory. If IHistory is
   * not available, the method tries nsIGlobalHistory2.
   *
   * The IHistory API maintains chains of visits, tracking both HTTP referrers
   * and redirects for a user session. VisitURI requires the current URI and
   * the previous URI in the chain.
   *
   * Visits can be saved either during a redirect or when the request has
   * reached its final destination. The previous URI in the visit may be
   * from another redirect or it may be the referrer.
   *
   * @pre aURI is not null.
   *
   * @param aURI
   *        The URI that was just visited
   * @param aReferrerURI
   *        The referrer URI of this request
   * @param aPreviousURI
   *        The previous URI of this visit (may be the same as aReferrerURI)
   * @param aChannelRedirectFlags
   *        For redirects, the redirect flags from nsIChannelEventSink
   *        (0 otherwise)
   * @param aResponseStatus
   *        For HTTP channels, the response code (0 otherwise).
   */
  void AddURIVisit(nsIURI* aURI,
                   nsIURI* aReferrerURI,
                   nsIURI* aPreviousURI,
                   uint32_t aChannelRedirectFlags,
                   uint32_t aResponseStatus = 0);

  // Helper Routines
  nsresult ConfirmRepost(bool* aRepost);
  NS_IMETHOD GetPromptAndStringBundle(nsIPrompt** aPrompt,
                                      nsIStringBundle** aStringBundle);
  NS_IMETHOD GetChildOffset(nsIDOMNode* aChild, nsIDOMNode* aParent,
                            int32_t* aOffset);
  nsIScrollableFrame* GetRootScrollFrame();
  NS_IMETHOD EnsureScriptEnvironment();
  NS_IMETHOD EnsureEditorData();
  nsresult EnsureTransferableHookData();
  NS_IMETHOD EnsureFind();
  nsresult RefreshURIFromQueue();
  NS_IMETHOD LoadErrorPage(nsIURI* aURI, const char16_t* aURL,
                           const char* aErrorPage,
                           const char16_t* aErrorType,
                           const char16_t* aDescription,
                           const char* aCSSClass,
                           nsIChannel* aFailedChannel);
  bool IsPrintingOrPP(bool aDisplayErrorDialog = true);
  bool IsNavigationAllowed(bool aDisplayPrintErrorDialog = true,
                           bool aCheckIfUnloadFired = true);

  nsresult SetBaseUrlForWyciwyg(nsIContentViewer* aContentViewer);

  static inline uint32_t PRTimeToSeconds(PRTime aTimeUsec)
  {
    PRTime usecPerSec = PR_USEC_PER_SEC;
    return uint32_t(aTimeUsec /= usecPerSec);
  }

  inline bool UseErrorPages()
  {
    return (mObserveErrorPages ? sUseErrorPages : mUseErrorPages);
  }

  bool IsFrame();

  //
  // Helper method that is called when a new document (including any
  // sub-documents - ie. frames) has been completely loaded.
  //
  virtual nsresult EndPageLoad(nsIWebProgress* aProgress,
                               nsIChannel* aChannel,
                               nsresult aResult);

  // Sets the current document's current state object to the given SHEntry's
  // state object. The current state object is eventually given to the page
  // in the PopState event.
  nsresult SetDocCurrentStateObj(nsISHEntry* aShEntry);

  nsresult CheckLoadingPermissions();

  // Security checks to prevent frameset spoofing. See comments at
  // implementation sites.
  static bool CanAccessItem(nsIDocShellTreeItem* aTargetItem,
                            nsIDocShellTreeItem* aAccessingItem,
                            bool aConsiderOpener = true);
  static bool ValidateOrigin(nsIDocShellTreeItem* aOriginTreeItem,
                             nsIDocShellTreeItem* aTargetTreeItem);

  // Returns true if would have called FireOnLocationChange,
  // but did not because aFireOnLocationChange was false on entry.
  // In this case it is the caller's responsibility to ensure
  // FireOnLocationChange is called.
  // In all other cases false is returned.
  bool SetCurrentURI(nsIURI* aURI, nsIRequest* aRequest,
                     bool aFireOnLocationChange,
                     uint32_t aLocationFlags);

  // The following methods deal with saving and restoring content viewers
  // in session history.

  // mContentViewer points to the current content viewer associated with
  // this docshell. When loading a new document, the content viewer is
  // either destroyed or stored into a session history entry. To make sure
  // that destruction happens in a controlled fashion, a given content viewer
  // is always owned in exactly one of these ways:
  //   1) The content viewer is active and owned by a docshell's
  //      mContentViewer.
  //   2) The content viewer is still being displayed while we begin loading
  //      a new document. The content viewer is owned by the _new_
  //      content viewer's mPreviousViewer, and has a pointer to the
  //      nsISHEntry where it will eventually be stored. The content viewer
  //      has been close()d by the docshell, which detaches the document from
  //      the window object.
  //   3) The content viewer is cached in session history. The nsISHEntry
  //      has the only owning reference to the content viewer. The viewer
  //      has released its nsISHEntry pointer to prevent circular ownership.
  //
  // When restoring a content viewer from session history, open() is called
  // to reattach the document to the window object. The content viewer is
  // then placed into mContentViewer and removed from the history entry.
  // (mContentViewer is put into session history as described above, if
  // applicable).

  // Determines whether we can safely cache the current mContentViewer in
  // session history. This checks a number of factors such as cache policy,
  // pending requests, and unload handlers.
  // |aLoadType| should be the load type that will replace the current
  // presentation. |aNewRequest| should be the request for the document to
  // be loaded in place of the current document, or null if such a request
  // has not been created yet. |aNewDocument| should be the document that will
  // replace the current document.
  bool CanSavePresentation(uint32_t aLoadType,
                           nsIRequest* aNewRequest,
                           nsIDocument* aNewDocument);

  // Captures the state of the supporting elements of the presentation
  // (the "window" object, docshell tree, meta-refresh loads, and security
  // state) and stores them on |mOSHE|.
  nsresult CaptureState();

  // Begin the toplevel restore process for |aSHEntry|.
  // This simulates a channel open, and defers the real work until
  // RestoreFromHistory is called from a PLEvent.
  nsresult RestorePresentation(nsISHEntry* aSHEntry, bool* aRestoring);

  // Call BeginRestore(nullptr, false) for each child of this shell.
  nsresult BeginRestoreChildren();

  // Method to get our current position and size without flushing
  void DoGetPositionAndSize(int32_t* aX, int32_t* aY, int32_t* aWidth,
                            int32_t* aHeight);

  // Call this when a URI load is handed to us (via OnLinkClick or
  // InternalLoad). This makes sure that we're not inside unload, or that if
  // we are it's still OK to load this URI.
  bool IsOKToLoadURI(nsIURI* aURI);

  void ReattachEditorToWindow(nsISHEntry* aSHEntry);

  nsCOMPtr<nsIDOMStorageManager> mSessionStorageManager;
  nsIDOMStorageManager* TopSessionStorageManager();

  // helpers for executing commands
  nsresult GetControllerForCommand(const char* aCommand,
                                   nsIController** aResult);
  nsresult EnsureCommandHandler();

  nsIChannel* GetCurrentDocChannel();

  bool ShouldBlockLoadingForBackButton();

  // Convenience method for getting our parent docshell. Can return null
  already_AddRefed<nsDocShell> GetParentDocshell();

protected:
  nsresult GetCurScrollPos(int32_t aScrollOrientation, int32_t* aCurPos);
  nsresult SetCurScrollPosEx(int32_t aCurHorizontalPos,
                             int32_t aCurVerticalPos);

  // Override the parent setter from nsDocLoader
  virtual nsresult SetDocLoaderParent(nsDocLoader* aLoader) override;

  void ClearFrameHistory(nsISHEntry* aEntry);

  /**
   * Initializes mTiming if it isn't yet.
   * After calling this, mTiming is non-null. This method returns true if the
   * initialization of the Timing can be reset (basically this is true if a new
   * Timing object is created).
   * In case the loading is aborted, MaybeResetInitTiming() can be called
   * passing the return value of MaybeInitTiming(): if it's possible to reset
   * the Timing, this method will do it.
   */
  MOZ_MUST_USE bool MaybeInitTiming();
  void MaybeResetInitTiming(bool aReset);

  bool DisplayLoadError(nsresult aError, nsIURI* aURI, const char16_t* aURL,
                        nsIChannel* aFailedChannel)
  {
    bool didDisplayLoadError = false;
    DisplayLoadError(aError, aURI, aURL, aFailedChannel, &didDisplayLoadError);
    return didDisplayLoadError;
  }

public:
  // Event type dispatched by RestorePresentation
  class RestorePresentationEvent : public mozilla::Runnable
  {
  public:
    NS_DECL_NSIRUNNABLE
    explicit RestorePresentationEvent(nsDocShell* aDs) : mDocShell(aDs) {}
    void Revoke() { mDocShell = nullptr; }
  private:
    RefPtr<nsDocShell> mDocShell;
  };

protected:
  bool JustStartedNetworkLoad();

  nsresult CreatePrincipalFromReferrer(nsIURI* aReferrer,
                                       nsIPrincipal** aResult);

  static const nsCString FrameTypeToString(uint32_t aFrameType)
  {
    switch (aFrameType) {
      case FRAME_TYPE_BROWSER:
        return NS_LITERAL_CSTRING("browser");
      case FRAME_TYPE_REGULAR:
        return NS_LITERAL_CSTRING("regular");
      default:
        NS_ERROR("Unknown frame type");
        return EmptyCString();
    }
  }

  uint32_t GetInheritedFrameType();

  bool HasUnloadedParent();

  void UpdateGlobalHistoryTitle(nsIURI* aURI);

  NS_IMETHOD_(void) GetOriginAttributes(mozilla::OriginAttributes& aAttrs) override;

  // Dimensions of the docshell
  nsIntRect mBounds;
  nsString mName;
  nsString mTitle;
  nsString mCustomUserAgent;

  /**
   * Content-Type Hint of the most-recently initiated load. Used for
   * session history entries.
   */
  nsCString mContentTypeHint;
  nsIntPoint mDefaultScrollbarPref; // persistent across doc loads

  nsCOMPtr<nsIMutableArray> mRefreshURIList;
  nsCOMPtr<nsIMutableArray> mSavedRefreshURIList;
  RefPtr<nsDSURIContentListener> mContentListener;
  nsCOMPtr<nsIContentViewer> mContentViewer;
  nsCOMPtr<nsIWidget> mParentWidget;

  // mCurrentURI should be marked immutable on set if possible.
  nsCOMPtr<nsIURI> mCurrentURI;
  nsCOMPtr<nsIURI> mReferrerURI;
  uint32_t mReferrerPolicy;
  RefPtr<nsGlobalWindow> mScriptGlobal;
  nsCOMPtr<nsISHistory> mSessionHistory;
  nsCOMPtr<nsIGlobalHistory2> mGlobalHistory;
  nsCOMPtr<nsIWebBrowserFind> mFind;
  nsCOMPtr<nsICommandManager> mCommandManager;
  // Reference to the SHEntry for this docshell until the page is destroyed.
  // Somebody give me better name
  nsCOMPtr<nsISHEntry> mOSHE;
  // Reference to the SHEntry for this docshell until the page is loaded
  // Somebody give me better name.
  // If mLSHE is non-null, non-pushState subframe loads don't create separate
  // root history entries. That is, frames loaded during the parent page
  // load don't generate history entries the way frame navigation after the
  // parent has loaded does. (This isn't the only purpose of mLSHE.)
  nsCOMPtr<nsISHEntry> mLSHE;

  // Holds a weak pointer to a RestorePresentationEvent object if any that
  // holds a weak pointer back to us. We use this pointer to possibly revoke
  // the event whenever necessary.
  nsRevocableEventPtr<RestorePresentationEvent> mRestorePresentationEvent;

  // Editor data, if this document is designMode or contentEditable.
  nsAutoPtr<nsDocShellEditorData> mEditorData;

  // Transferable hooks/callbacks
  nsCOMPtr<nsIClipboardDragDropHookList> mTransferableHookData;

  // Secure browser UI object
  nsCOMPtr<nsISecureBrowserUI> mSecurityUI;

  // The URI we're currently loading. This is only relevant during the
  // firing of a pagehide/unload. The caller of FirePageHideNotification()
  // is responsible for setting it and unsetting it. It may be null if the
  // pagehide/unload is happening for some reason other than just loading a
  // new URI.
  nsCOMPtr<nsIURI> mLoadingURI;

  // Set in LoadErrorPage from the method argument and used later
  // in CreateContentViewer. We have to delay an shistory entry creation
  // for which these objects are needed.
  nsCOMPtr<nsIURI> mFailedURI;
  nsCOMPtr<nsIChannel> mFailedChannel;
  uint32_t mFailedLoadType;

  // Set in DoURILoad when either the LOAD_RELOAD_ALLOW_MIXED_CONTENT flag or
  // the LOAD_NORMAL_ALLOW_MIXED_CONTENT flag is set.
  // Checked in nsMixedContentBlocker, to see if the channels match.
  nsCOMPtr<nsIChannel> mMixedContentChannel;

  // WEAK REFERENCES BELOW HERE.
  // Note these are intentionally not addrefd. Doing so will create a cycle.
  // For that reasons don't use nsCOMPtr.

  nsIDocShellTreeOwner* mTreeOwner; // Weak Reference
  mozilla::dom::EventTarget* mChromeEventHandler; // Weak Reference

  eCharsetReloadState mCharsetReloadState;

  // Offset in the parent's child list.
  // -1 if the docshell is added dynamically to the parent shell.
  uint32_t mChildOffset;
  uint32_t mBusyFlags;
  uint32_t mAppType;
  uint32_t mLoadType;

  int32_t mMarginWidth;
  int32_t mMarginHeight;

  // This can either be a content docshell or a chrome docshell. After
  // Create() is called, the type is not expected to change.
  int32_t mItemType;

  // Index into the SHTransaction list, indicating the previous and current
  // transaction at the time that this DocShell begins to load
  int32_t mPreviousTransIndex;
  int32_t mLoadedTransIndex;

  uint32_t mSandboxFlags;
  nsWeakPtr mOnePermittedSandboxedNavigator;

  // The orientation lock as described by
  // https://w3c.github.io/screen-orientation/
  mozilla::dom::ScreenOrientationInternal mOrientationLock;

  // mFullscreenAllowed stores how we determine whether fullscreen is allowed
  // when GetFullscreenAllowed() is called. Fullscreen is allowed in a
  // docshell when all containing iframes have the allowfullscreen
  // attribute set to true. When mFullscreenAllowed is CHECK_ATTRIBUTES
  // we check this docshell's containing frame for the allowfullscreen
  // attribute, and recurse onto the parent docshell to ensure all containing
  // frames also have the allowfullscreen attribute. If we find an ancestor
  // docshell with mFullscreenAllowed not equal to CHECK_ATTRIBUTES, we've
  // reached a content boundary, and mFullscreenAllowed denotes whether the
  // parent across the content boundary has allowfullscreen=true in all its
  // containing iframes. mFullscreenAllowed defaults to CHECK_ATTRIBUTES and
  // is set otherwise when docshells which are content boundaries are created.
  enum FullscreenAllowedState : uint8_t
  {
    CHECK_ATTRIBUTES,
    PARENT_ALLOWS,
    PARENT_PROHIBITS
  };
  FullscreenAllowedState mFullscreenAllowed;

  // Cached value of the "browser.xul.error_pages.enabled" preference.
  static bool sUseErrorPages;

  bool mCreated : 1;
  bool mAllowSubframes : 1;
  bool mAllowPlugins : 1;
  bool mAllowJavascript : 1;
  bool mAllowMetaRedirects : 1;
  bool mAllowImages : 1;
  bool mAllowMedia : 1;
  bool mAllowDNSPrefetch : 1;
  bool mAllowWindowControl : 1;
  bool mAllowContentRetargeting : 1;
  bool mAllowContentRetargetingOnChildren : 1;
  bool mUseErrorPages : 1;
  bool mObserveErrorPages : 1;
  bool mAllowAuth : 1;
  bool mAllowKeywordFixup : 1;
  bool mIsOffScreenBrowser : 1;
  bool mIsActive : 1;
  bool mDisableMetaRefreshWhenInactive : 1;
  bool mIsPrerendered : 1;
  bool mIsAppTab : 1;
  bool mUseGlobalHistory : 1;
  bool mUseRemoteTabs : 1;
  bool mUseTrackingProtection : 1;
  bool mDeviceSizeIsPageSize : 1;
  bool mWindowDraggingAllowed : 1;
  bool mInFrameSwap : 1;
  bool mInheritPrivateBrowsingId : 1;

  // Because scriptability depends on the mAllowJavascript values of our
  // ancestors, we cache the effective scriptability and recompute it when
  // it might have changed;
  bool mCanExecuteScripts : 1;
  void RecomputeCanExecuteScripts();

  // This boolean is set to true right before we fire pagehide and generally
  // unset when we embed a new content viewer. While it's true no navigation
  // is allowed in this docshell.
  bool mFiredUnloadEvent : 1;

  // this flag is for bug #21358. a docshell may load many urls
  // which don't result in new documents being created (i.e. a new
  // content viewer) we want to make sure we don't call a on load
  // event more than once for a given content viewer.
  bool mEODForCurrentDocument : 1;
  bool mURIResultedInDocument : 1;

  bool mIsBeingDestroyed : 1;

  bool mIsExecutingOnLoadHandler : 1;

  // Indicates that a DocShell in this "docshell tree" is printing
  bool mIsPrintingOrPP : 1;

  // Indicates to CreateContentViewer() that it is safe to cache the old
  // presentation of the page, and to SetupNewViewer() that the old viewer
  // should be passed a SHEntry to save itself into.
  bool mSavingOldViewer : 1;

  // @see nsIDocShellHistory::createdDynamically
  bool mDynamicallyCreated : 1;
  bool mAffectPrivateSessionLifetime : 1;
  bool mInvisible : 1;
  bool mHasLoadedNonBlankURI : 1;

  // This flag means that mTiming has been initialized but nulled out.
  // We will check the innerWin's timing before creating a new one
  // in MaybeInitTiming()
  bool mBlankTiming : 1;

  // The following two fields cannot be declared as bit fields
  // because of uses with AutoRestore.
  bool mCreatingDocument; // (should be) debugging only
#ifdef DEBUG
  bool mInEnsureScriptEnv;
#endif

  nsID mHistoryID;
  uint32_t mDefaultLoadFlags;

  static nsIURIFixup* sURIFixup;

  RefPtr<nsDOMNavigationTiming> mTiming;

  // Are we a regular frame, a browser frame, or an app frame?
  uint32_t mFrameType;

  // This represents the state of private browsing in the docshell.
  // Currently treated as a binary value: 1 - in private mode, 0 - not private mode
  // On content docshells mPrivateBrowsingId == mOriginAttributes.mPrivateBrowsingId
  // On chrome docshells this value will be set, but not have the corresponding
  // origin attribute set.
  uint32_t mPrivateBrowsingId;

  nsString mInterceptedDocumentId;

private:
  nsCString mForcedCharset;
  nsCString mParentCharset;
  int32_t mParentCharsetSource;
  nsCOMPtr<nsIPrincipal> mParentCharsetPrincipal;
  nsTObserverArray<nsWeakPtr> mPrivacyObservers;
  nsTObserverArray<nsWeakPtr> mReflowObservers;
  nsTObserverArray<nsWeakPtr> mScrollObservers;
  nsCString mOriginalUriString;
  nsWeakPtr mOpener;
  mozilla::OriginAttributes mOriginAttributes;

  mozilla::UniquePtr<mozilla::dom::PendingGlobalHistoryEntry> mPrerenderGlobalHistory;

  // A depth count of how many times NotifyRunToCompletionStart
  // has been called without a matching NotifyRunToCompletionStop.
  uint32_t mJSRunToCompletionDepth;

  // Whether or not touch events are overridden. Possible values are defined
  // as constants in the nsIDocShell.idl file.
  uint32_t mTouchEventsOverride;

  // Separate function to do the actual name (i.e. not _top, _self etc.)
  // searching for FindItemWithName.
  nsresult DoFindItemWithName(const nsAString& aName,
                              nsIDocShellTreeItem* aRequestor,
                              nsIDocShellTreeItem* aOriginalRequestor,
                              bool aSkipTabGroup,
                              nsIDocShellTreeItem** aResult);

  // Helper assertion to enforce that mInPrivateBrowsing is in sync with
  // OriginAttributes.mPrivateBrowsingId
  void AssertOriginAttributesMatchPrivateBrowsing();

  // Notify consumers of a search being loaded through the observer service:
  void MaybeNotifyKeywordSearchLoading(const nsString& aProvider,
                                       const nsString& aKeyword);

  // Internal implementation of nsIDocShell::FirePageHideNotification.
  // If aSkipCheckingDynEntries is true, it will not try to remove dynamic
  // subframe entries. This is to avoid redundant RemoveDynEntries calls in all
  // children docshells.
  void FirePageHideNotificationInternal(bool aIsUnload,
                                        bool aSkipCheckingDynEntries);

  // Dispatch a runnable to the TabGroup associated to this docshell.
  nsresult DispatchToTabGroup(const char* aName,
                              mozilla::TaskCategory aCategory,
                              already_AddRefed<nsIRunnable>&& aRunnable);

#ifdef DEBUG
  // We're counting the number of |nsDocShells| to help find leaks
  static unsigned long gNumberOfDocShells;
#endif /* DEBUG */

public:
  class InterfaceRequestorProxy : public nsIInterfaceRequestor
  {
  public:
    explicit InterfaceRequestorProxy(nsIInterfaceRequestor* aRequestor);
    NS_DECL_THREADSAFE_ISUPPORTS
    NS_DECL_NSIINTERFACEREQUESTOR

  protected:
    virtual ~InterfaceRequestorProxy();
    InterfaceRequestorProxy() {}
    nsWeakPtr mWeakPtr;
  };
};

#endif /* nsDocShell_h__ */
