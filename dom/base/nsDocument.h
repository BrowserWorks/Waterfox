/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/*
 * Base class for all our document implementations.
 */

#ifndef nsDocument_h___
#define nsDocument_h___

#include "nsIDocument.h"

#include "nsCOMPtr.h"
#include "nsAutoPtr.h"
#include "nsCRT.h"
#include "nsWeakReference.h"
#include "nsWeakPtr.h"
#include "nsTArray.h"
#include "nsIDOMDocument.h"
#include "nsIDOMDocumentXBL.h"
#include "nsStubDocumentObserver.h"
#include "nsIScriptGlobalObject.h"
#include "nsIContent.h"
#include "nsIPrincipal.h"
#include "nsIParser.h"
#include "nsBindingManager.h"
#include "nsInterfaceHashtable.h"
#include "nsJSThingHashtable.h"
#include "nsIScriptObjectPrincipal.h"
#include "nsIURI.h"
#include "nsScriptLoader.h"
#include "nsIRadioGroupContainer.h"
#include "nsILayoutHistoryState.h"
#include "nsIRequest.h"
#include "nsILoadGroup.h"
#include "nsTObserverArray.h"
#include "nsStubMutationObserver.h"
#include "nsIChannel.h"
#include "nsCycleCollectionParticipant.h"
#include "nsContentList.h"
#include "nsGkAtoms.h"
#include "nsIApplicationCache.h"
#include "nsIApplicationCacheContainer.h"
#include "mozilla/StyleSetHandle.h"
#include "PLDHashTable.h"
#include "nsAttrAndChildArray.h"
#include "nsDOMAttributeMap.h"
#include "nsIContentViewer.h"
#include "nsIInterfaceRequestor.h"
#include "nsILoadContext.h"
#include "nsIProgressEventSink.h"
#include "nsISecurityEventSink.h"
#include "nsIChannelEventSink.h"
#include "imgIRequest.h"
#include "mozilla/EventListenerManager.h"
#include "mozilla/EventStates.h"
#include "mozilla/MemoryReporting.h"
#include "mozilla/PendingAnimationTracker.h"
#include "mozilla/dom/DOMImplementation.h"
#include "mozilla/dom/StyleSheetList.h"
#include "nsDataHashtable.h"
#include "mozilla/TimeStamp.h"
#include "mozilla/Attributes.h"
#include "nsIDOMXPathEvaluator.h"
#include "jsfriendapi.h"
#include "ImportManager.h"
#include "mozilla/LinkedList.h"
#include "CustomElementRegistry.h"
#include "mozilla/dom/Performance.h"

#define XML_DECLARATION_BITS_DECLARATION_EXISTS   (1 << 0)
#define XML_DECLARATION_BITS_ENCODING_EXISTS      (1 << 1)
#define XML_DECLARATION_BITS_STANDALONE_EXISTS    (1 << 2)
#define XML_DECLARATION_BITS_STANDALONE_YES       (1 << 3)


class nsDOMStyleSheetSetList;
class nsDocument;
class nsIRadioVisitor;
class nsIFormControl;
struct nsRadioGroupStruct;
class nsOnloadBlocker;
class nsUnblockOnloadEvent;
class nsDOMNavigationTiming;
class nsWindowSizes;
class nsHtml5TreeOpExecutor;
class nsDocumentOnStack;
class nsISecurityConsoleMessage;
class nsPIBoxObject;

namespace mozilla {
class EventChainPreVisitor;
namespace dom {
class BoxObject;
class ImageTracker;
struct LifecycleCallbacks;
class CallbackFunction;
class DOMIntersectionObserver;
class Performance;

struct FullscreenRequest : public LinkedListElement<FullscreenRequest>
{
  explicit FullscreenRequest(Element* aElement);
  FullscreenRequest(const FullscreenRequest&) = delete;
  ~FullscreenRequest();

  Element* GetElement() const { return mElement; }
  nsDocument* GetDocument() const { return mDocument; }

private:
  RefPtr<Element> mElement;
  RefPtr<nsDocument> mDocument;

public:
  // This value should be true if the fullscreen request is
  // originated from chrome code.
  bool mIsCallerChrome = false;
  // This value denotes whether we should trigger a NewOrigin event if
  // requesting fullscreen in its document causes the origin which is
  // fullscreen to change. We may want *not* to trigger that event if
  // we're calling RequestFullScreen() as part of a continuation of a
  // request in a subdocument in different process, whereupon the caller
  // need to send some notification itself with the real origin.
  bool mShouldNotifyNewOrigin = true;
};

} // namespace dom
} // namespace mozilla

/**
 * Right now our identifier map entries contain information for 'name'
 * and 'id' mappings of a given string. This is so that
 * nsHTMLDocument::ResolveName only has to do one hash lookup instead
 * of two. It's not clear whether this still matters for performance.
 *
 * We also store the document.all result list here. This is mainly so that
 * when all elements with the given ID are removed and we remove
 * the ID's nsIdentifierMapEntry, the document.all result is released too.
 * Perhaps the document.all results should have their own hashtable
 * in nsHTMLDocument.
 */
class nsIdentifierMapEntry : public nsStringHashKey
{
public:
  typedef mozilla::dom::Element Element;
  typedef mozilla::net::ReferrerPolicy ReferrerPolicy;

  explicit nsIdentifierMapEntry(const nsAString& aKey) :
    nsStringHashKey(&aKey), mNameContentList(nullptr)
  {
  }
  explicit nsIdentifierMapEntry(const nsAString* aKey) :
    nsStringHashKey(aKey), mNameContentList(nullptr)
  {
  }
  nsIdentifierMapEntry(const nsIdentifierMapEntry& aOther) :
    nsStringHashKey(&aOther.GetKey())
  {
    NS_ERROR("Should never be called");
  }
  ~nsIdentifierMapEntry();

  void AddNameElement(nsINode* aDocument, Element* aElement);
  void RemoveNameElement(Element* aElement);
  bool IsEmpty();
  nsBaseContentList* GetNameContentList() {
    return mNameContentList;
  }
  bool HasNameElement() const {
    return mNameContentList && mNameContentList->Length() != 0;
  }

  /**
   * Returns the element if we know the element associated with this
   * id. Otherwise returns null.
   */
  Element* GetIdElement();
  /**
   * Returns the list of all elements associated with this id.
   */
  const nsTArray<Element*>& GetIdElements() const {
    return mIdContentList;
  }
  /**
   * If this entry has a non-null image element set (using SetImageElement),
   * the image element will be returned, otherwise the same as GetIdElement().
   */
  Element* GetImageIdElement();
  /**
   * Append all the elements with this id to aElements
   */
  void AppendAllIdContent(nsCOMArray<nsIContent>* aElements);
  /**
   * This can fire ID change callbacks.
   * @return true if the content could be added, false if we failed due
   * to OOM.
   */
  bool AddIdElement(Element* aElement);
  /**
   * This can fire ID change callbacks.
   */
  void RemoveIdElement(Element* aElement);
  /**
   * Set the image element override for this ID. This will be returned by
   * GetIdElement(true) if non-null.
   */
  void SetImageElement(Element* aElement);
  bool HasIdElementExposedAsHTMLDocumentProperty();

  bool HasContentChangeCallback() { return mChangeCallbacks != nullptr; }
  void AddContentChangeCallback(nsIDocument::IDTargetObserver aCallback,
                                void* aData, bool aForImage);
  void RemoveContentChangeCallback(nsIDocument::IDTargetObserver aCallback,
                                void* aData, bool aForImage);

  void Traverse(nsCycleCollectionTraversalCallback* aCallback);

  struct ChangeCallback {
    nsIDocument::IDTargetObserver mCallback;
    void* mData;
    bool mForImage;
  };

  struct ChangeCallbackEntry : public PLDHashEntryHdr {
    typedef const ChangeCallback KeyType;
    typedef const ChangeCallback* KeyTypePointer;

    explicit ChangeCallbackEntry(const ChangeCallback* aKey) :
      mKey(*aKey) { }
    ChangeCallbackEntry(const ChangeCallbackEntry& toCopy) :
      mKey(toCopy.mKey) { }

    KeyType GetKey() const { return mKey; }
    bool KeyEquals(KeyTypePointer aKey) const {
      return aKey->mCallback == mKey.mCallback &&
             aKey->mData == mKey.mData &&
             aKey->mForImage == mKey.mForImage;
    }

    static KeyTypePointer KeyToPointer(KeyType& aKey) { return &aKey; }
    static PLDHashNumber HashKey(KeyTypePointer aKey)
    {
      return mozilla::HashGeneric(aKey->mCallback, aKey->mData);
    }
    enum { ALLOW_MEMMOVE = true };

    ChangeCallback mKey;
  };

  size_t SizeOfExcludingThis(mozilla::MallocSizeOf aMallocSizeOf) const;

private:
  void FireChangeCallbacks(Element* aOldElement, Element* aNewElement,
                           bool aImageOnly = false);

  // empty if there are no elements with this ID.
  // The elements are stored as weak pointers.
  nsTArray<Element*> mIdContentList;
  RefPtr<nsBaseContentList> mNameContentList;
  nsAutoPtr<nsTHashtable<ChangeCallbackEntry> > mChangeCallbacks;
  RefPtr<Element> mImageElement;
};

namespace mozilla {
namespace dom {

} // namespace dom
} // namespace mozilla

class nsDocHeaderData
{
public:
  nsDocHeaderData(nsIAtom* aField, const nsAString& aData)
    : mField(aField), mData(aData), mNext(nullptr)
  {
  }

  ~nsDocHeaderData(void)
  {
    delete mNext;
  }

  nsCOMPtr<nsIAtom> mField;
  nsString          mData;
  nsDocHeaderData*  mNext;
};

class nsDOMStyleSheetList : public mozilla::dom::StyleSheetList,
                            public nsStubDocumentObserver
{
public:
  explicit nsDOMStyleSheetList(nsIDocument* aDocument);

  NS_DECL_ISUPPORTS_INHERITED

  // nsIDocumentObserver
  NS_DECL_NSIDOCUMENTOBSERVER_STYLESHEETADDED
  NS_DECL_NSIDOCUMENTOBSERVER_STYLESHEETREMOVED

  // nsIMutationObserver
  NS_DECL_NSIMUTATIONOBSERVER_NODEWILLBEDESTROYED

  virtual nsINode* GetParentObject() const override
  {
    return mDocument;
  }

  uint32_t Length() override;
  mozilla::StyleSheet* IndexedGetter(uint32_t aIndex, bool& aFound) override;

protected:
  virtual ~nsDOMStyleSheetList();

  int32_t       mLength;
  nsIDocument*  mDocument;
};

class nsOnloadBlocker final : public nsIRequest
{
public:
  nsOnloadBlocker() {}

  NS_DECL_ISUPPORTS
  NS_DECL_NSIREQUEST

private:
  ~nsOnloadBlocker() {}
};

class nsExternalResourceMap
{
public:
  typedef nsIDocument::ExternalResourceLoad ExternalResourceLoad;
  nsExternalResourceMap();

  /**
   * Request an external resource document.  This does exactly what
   * nsIDocument::RequestExternalResource is documented to do.
   */
  nsIDocument* RequestResource(nsIURI* aURI,
                               nsINode* aRequestingNode,
                               nsDocument* aDisplayDocument,
                               ExternalResourceLoad** aPendingLoad);

  /**
   * Enumerate the resource documents.  See
   * nsIDocument::EnumerateExternalResources.
   */
  void EnumerateResources(nsIDocument::nsSubDocEnumFunc aCallback, void* aData);

  /**
   * Traverse ourselves for cycle-collection
   */
  void Traverse(nsCycleCollectionTraversalCallback* aCallback) const;

  /**
   * Shut ourselves down (used for cycle-collection unlink), as well
   * as for document destruction.
   */
  void Shutdown()
  {
    mPendingLoads.Clear();
    mMap.Clear();
    mHaveShutDown = true;
  }

  bool HaveShutDown() const
  {
    return mHaveShutDown;
  }

  // Needs to be public so we can traverse them sanely
  struct ExternalResource
  {
    ~ExternalResource();
    nsCOMPtr<nsIDocument> mDocument;
    nsCOMPtr<nsIContentViewer> mViewer;
    nsCOMPtr<nsILoadGroup> mLoadGroup;
  };

  // Hide all our viewers
  void HideViewers();

  // Show all our viewers
  void ShowViewers();

protected:
  class PendingLoad : public ExternalResourceLoad,
                      public nsIStreamListener
  {
    ~PendingLoad() {}

  public:
    explicit PendingLoad(nsDocument* aDisplayDocument) :
      mDisplayDocument(aDisplayDocument)
    {}

    NS_DECL_ISUPPORTS
    NS_DECL_NSISTREAMLISTENER
    NS_DECL_NSIREQUESTOBSERVER

    /**
     * Start aURI loading.  This will perform the necessary security checks and
     * so forth.
     */
    nsresult StartLoad(nsIURI* aURI, nsINode* aRequestingNode);

    /**
     * Set up an nsIContentViewer based on aRequest.  This is guaranteed to
     * put null in *aViewer and *aLoadGroup on all failures.
     */
    nsresult SetupViewer(nsIRequest* aRequest, nsIContentViewer** aViewer,
                         nsILoadGroup** aLoadGroup);

  private:
    RefPtr<nsDocument> mDisplayDocument;
    nsCOMPtr<nsIStreamListener> mTargetListener;
    nsCOMPtr<nsIURI> mURI;
  };
  friend class PendingLoad;

  class LoadgroupCallbacks final : public nsIInterfaceRequestor
  {
    ~LoadgroupCallbacks() {}
  public:
    explicit LoadgroupCallbacks(nsIInterfaceRequestor* aOtherCallbacks)
      : mCallbacks(aOtherCallbacks)
    {}
    NS_DECL_ISUPPORTS
    NS_DECL_NSIINTERFACEREQUESTOR
  private:
    // The only reason it's safe to hold a strong ref here without leaking is
    // that the notificationCallbacks on a loadgroup aren't the docshell itself
    // but a shim that holds a weak reference to the docshell.
    nsCOMPtr<nsIInterfaceRequestor> mCallbacks;

    // Use shims for interfaces that docshell implements directly so that we
    // don't hand out references to the docshell.  The shims should all allow
    // getInterface back on us, but other than that each one should only
    // implement one interface.

    // XXXbz I wish we could just derive the _allcaps thing from _i
#define DECL_SHIM(_i, _allcaps)                                              \
    class _i##Shim final : public nsIInterfaceRequestor,                     \
                           public _i                                         \
    {                                                                        \
      ~_i##Shim() {}                                                         \
    public:                                                                  \
      _i##Shim(nsIInterfaceRequestor* aIfreq, _i* aRealPtr)                  \
        : mIfReq(aIfreq), mRealPtr(aRealPtr)                                 \
      {                                                                      \
        NS_ASSERTION(mIfReq, "Expected non-null here");                      \
        NS_ASSERTION(mRealPtr, "Expected non-null here");                    \
      }                                                                      \
      NS_DECL_ISUPPORTS                                                      \
      NS_FORWARD_NSIINTERFACEREQUESTOR(mIfReq->)                             \
      NS_FORWARD_##_allcaps(mRealPtr->)                                      \
    private:                                                                 \
      nsCOMPtr<nsIInterfaceRequestor> mIfReq;                                \
      nsCOMPtr<_i> mRealPtr;                                                 \
    };

    DECL_SHIM(nsILoadContext, NSILOADCONTEXT)
    DECL_SHIM(nsIProgressEventSink, NSIPROGRESSEVENTSINK)
    DECL_SHIM(nsIChannelEventSink, NSICHANNELEVENTSINK)
    DECL_SHIM(nsISecurityEventSink, NSISECURITYEVENTSINK)
    DECL_SHIM(nsIApplicationCacheContainer, NSIAPPLICATIONCACHECONTAINER)
#undef DECL_SHIM
  };

  /**
   * Add an ExternalResource for aURI.  aViewer and aLoadGroup might be null
   * when this is called if the URI didn't result in an XML document.  This
   * function makes sure to remove the pending load for aURI, if any, from our
   * hashtable, and to notify its observers, if any.
   */
  nsresult AddExternalResource(nsIURI* aURI, nsIContentViewer* aViewer,
                               nsILoadGroup* aLoadGroup,
                               nsIDocument* aDisplayDocument);

  nsClassHashtable<nsURIHashKey, ExternalResource> mMap;
  nsRefPtrHashtable<nsURIHashKey, PendingLoad> mPendingLoads;
  bool mHaveShutDown;
};

// Base class for our document implementations.
class nsDocument : public nsIDocument,
                   public nsIDOMDocument,
                   public nsIDOMDocumentXBL,
                   public nsSupportsWeakReference,
                   public nsIScriptObjectPrincipal,
                   public nsIRadioGroupContainer,
                   public nsIApplicationCacheContainer,
                   public nsStubMutationObserver,
                   public nsIObserver,
                   public nsIDOMXPathEvaluator
{
  friend class nsIDocument;

public:
  typedef mozilla::dom::Element Element;
  using nsIDocument::GetElementsByTagName;
  typedef mozilla::net::ReferrerPolicy ReferrerPolicy;

  NS_DECL_CYCLE_COLLECTING_ISUPPORTS

  NS_DECL_SIZEOF_EXCLUDING_THIS

  virtual void Reset(nsIChannel *aChannel, nsILoadGroup *aLoadGroup) override;
  virtual void ResetToURI(nsIURI *aURI, nsILoadGroup *aLoadGroup,
                          nsIPrincipal* aPrincipal) override;

  // StartDocumentLoad is pure virtual so that subclasses must override it.
  // The nsDocument StartDocumentLoad does some setup, but does NOT set
  // *aDocListener; this is the job of subclasses.
  virtual nsresult StartDocumentLoad(const char* aCommand,
                                     nsIChannel* aChannel,
                                     nsILoadGroup* aLoadGroup,
                                     nsISupports* aContainer,
                                     nsIStreamListener **aDocListener,
                                     bool aReset = true,
                                     nsIContentSink* aContentSink = nullptr) override = 0;

  virtual void StopDocumentLoad() override;

  virtual void NotifyPossibleTitleChange(bool aBoundTitleElement) override;

  virtual void SetDocumentURI(nsIURI* aURI) override;

  virtual void SetChromeXHRDocURI(nsIURI* aURI) override;

  virtual void SetChromeXHRDocBaseURI(nsIURI* aURI) override;

  virtual void ApplySettingsFromCSP(bool aSpeculative) override;

  /**
   * Set the principal responsible for this document.
   */
  virtual void SetPrincipal(nsIPrincipal *aPrincipal) override;

  /**
   * Get the Content-Type of this document.
   */
  // NS_IMETHOD GetContentType(nsAString& aContentType);
  // Already declared in nsIDOMDocument

  /**
   * Set the Content-Type of this document.
   */
  virtual void SetContentType(const nsAString& aContentType) override;

  virtual void SetBaseURI(nsIURI* aURI) override;

  /**
   * Get/Set the base target of a link in a document.
   */
  virtual void GetBaseTarget(nsAString &aBaseTarget) override;

  /**
   * Return a standard name for the document's character set. This will
   * trigger a startDocumentLoad if necessary to answer the question.
   */
  virtual void SetDocumentCharacterSet(const nsACString& aCharSetID) override;

  /**
   * Add an observer that gets notified whenever the charset changes.
   */
  virtual nsresult AddCharSetObserver(nsIObserver* aObserver) override;

  /**
   * Remove a charset observer.
   */
  virtual void RemoveCharSetObserver(nsIObserver* aObserver) override;

  virtual Element* AddIDTargetObserver(nsIAtom* aID, IDTargetObserver aObserver,
                                       void* aData, bool aForImage) override;
  virtual void RemoveIDTargetObserver(nsIAtom* aID, IDTargetObserver aObserver,
                                      void* aData, bool aForImage) override;

  /**
   * Access HTTP header data (this may also get set from other sources, like
   * HTML META tags).
   */
  virtual void GetHeaderData(nsIAtom* aHeaderField, nsAString& aData) const override;
  virtual void SetHeaderData(nsIAtom* aheaderField,
                             const nsAString& aData) override;

  /**
   * Create a new presentation shell that will use aContext for
   * its presentation context (presentation contexts <b>must not</b> be
   * shared among multiple presentation shells).
   */
  virtual already_AddRefed<nsIPresShell> CreateShell(
      nsPresContext* aContext,
      nsViewManager* aViewManager,
      mozilla::StyleSetHandle aStyleSet) override;
  virtual void DeleteShell() override;

  virtual nsresult GetAllowPlugins(bool* aAllowPlugins) override;

  static bool IsElementAnimateEnabled(JSContext* aCx, JSObject* aObject);
  static bool IsWebAnimationsEnabled(JSContext* aCx, JSObject* aObject);
  virtual mozilla::dom::DocumentTimeline* Timeline() override;
  virtual void GetAnimations(
      nsTArray<RefPtr<mozilla::dom::Animation>>& aAnimations) override;
  mozilla::LinkedList<mozilla::dom::DocumentTimeline>& Timelines() override
  {
    return mTimelines;
  }

  virtual nsresult SetSubDocumentFor(Element* aContent,
                                     nsIDocument* aSubDoc) override;
  virtual nsIDocument* GetSubDocumentFor(nsIContent* aContent) const override;
  virtual Element* FindContentForSubDocument(nsIDocument *aDocument) const override;
  virtual Element* GetRootElementInternal() const override;

  virtual void EnsureOnDemandBuiltInUASheet(mozilla::StyleSheet* aSheet) override;

  /**
   * Get the (document) style sheets owned by this document.
   * These are ordered, highest priority last
   */
  virtual int32_t GetNumberOfStyleSheets() const override;
  virtual mozilla::StyleSheet* GetStyleSheetAt(int32_t aIndex) const override;
  virtual int32_t GetIndexOfStyleSheet(
      const mozilla::StyleSheet* aSheet) const override;
  virtual void AddStyleSheet(mozilla::StyleSheet* aSheet) override;
  virtual void RemoveStyleSheet(mozilla::StyleSheet* aSheet) override;

  virtual void UpdateStyleSheets(
      nsTArray<RefPtr<mozilla::StyleSheet>>& aOldSheets,
      nsTArray<RefPtr<mozilla::StyleSheet>>& aNewSheets) override;
  virtual void AddStyleSheetToStyleSets(mozilla::StyleSheet* aSheet);
  virtual void RemoveStyleSheetFromStyleSets(mozilla::StyleSheet* aSheet);

  virtual void InsertStyleSheetAt(mozilla::StyleSheet* aSheet,
                                  int32_t aIndex) override;
  virtual void SetStyleSheetApplicableState(mozilla::StyleSheet* aSheet,
                                            bool aApplicable) override;

  virtual nsresult LoadAdditionalStyleSheet(additionalSheetType aType,
                                            nsIURI* aSheetURI) override;
  virtual nsresult AddAdditionalStyleSheet(additionalSheetType aType,
                                           mozilla::StyleSheet* aSheet) override;
  virtual void RemoveAdditionalStyleSheet(additionalSheetType aType,
                                          nsIURI* sheetURI) override;
  virtual mozilla::StyleSheet* GetFirstAdditionalAuthorSheet() override;

  virtual nsIChannel* GetChannel() const override {
    return mChannel;
  }

  virtual nsIChannel* GetFailedChannel() const override {
    return mFailedChannel;
  }
  virtual void SetFailedChannel(nsIChannel* aChannel) override {
    mFailedChannel = aChannel;
  }

  virtual void SetScriptGlobalObject(nsIScriptGlobalObject* aGlobalObject) override;

  virtual void SetScriptHandlingObject(nsIScriptGlobalObject* aScriptObject) override;

  virtual nsIGlobalObject* GetScopeObject() const override;
  void SetScopeObject(nsIGlobalObject* aGlobal) override;
  /**
   * Get the script loader for this document
   */
  virtual nsScriptLoader* ScriptLoader() override;

  /**
   * Add/Remove an element to the document's id and name hashes
   */
  virtual void AddToIdTable(Element* aElement, nsIAtom* aId) override;
  virtual void RemoveFromIdTable(Element* aElement, nsIAtom* aId) override;
  virtual void AddToNameTable(Element* aElement, nsIAtom* aName) override;
  virtual void RemoveFromNameTable(Element* aElement, nsIAtom* aName) override;

  /**
   * Add a new observer of document change notifications. Whenever
   * content is changed, appended, inserted or removed the observers are
   * informed.
   */
  virtual void AddObserver(nsIDocumentObserver* aObserver) override;

  /**
   * Remove an observer of document change notifications. This will
   * return false if the observer cannot be found.
   */
  virtual bool RemoveObserver(nsIDocumentObserver* aObserver) override;

  // Observation hooks used to propagate notifications to document
  // observers.
  virtual void BeginUpdate(nsUpdateType aUpdateType) override;
  virtual void EndUpdate(nsUpdateType aUpdateType) override;
  virtual void BeginLoad() override;
  virtual void EndLoad() override;

  virtual void SetReadyStateInternal(ReadyState rs) override;

  virtual void ContentStateChanged(nsIContent* aContent,
                                   mozilla::EventStates aStateMask)
                                     override;
  virtual void DocumentStatesChanged(
                 mozilla::EventStates aStateMask) override;

  virtual void StyleRuleChanged(mozilla::StyleSheet* aStyleSheet,
                                mozilla::css::Rule* aStyleRule) override;
  virtual void StyleRuleAdded(mozilla::StyleSheet* aStyleSheet,
                              mozilla::css::Rule* aStyleRule) override;
  virtual void StyleRuleRemoved(mozilla::StyleSheet* aStyleSheet,
                                mozilla::css::Rule* aStyleRule) override;

  virtual void FlushPendingNotifications(mozFlushType aType) override;
  virtual void FlushExternalResources(mozFlushType aType) override;
  virtual void SetXMLDeclaration(const char16_t *aVersion,
                                 const char16_t *aEncoding,
                                 const int32_t aStandalone) override;
  virtual void GetXMLDeclaration(nsAString& aVersion,
                                 nsAString& aEncoding,
                                 nsAString& Standalone) override;
  virtual bool IsScriptEnabled() override;

  virtual void OnPageShow(bool aPersisted, mozilla::dom::EventTarget* aDispatchStartTarget) override;
  virtual void OnPageHide(bool aPersisted, mozilla::dom::EventTarget* aDispatchStartTarget) override;

  virtual void WillDispatchMutationEvent(nsINode* aTarget) override;
  virtual void MutationEventDispatched(nsINode* aTarget) override;

  // nsINode
  virtual bool IsNodeOfType(uint32_t aFlags) const override;
  virtual nsIContent *GetChildAt(uint32_t aIndex) const override;
  virtual nsIContent * const * GetChildArray(uint32_t* aChildCount) const override;
  virtual int32_t IndexOf(const nsINode* aPossibleChild) const override;
  virtual uint32_t GetChildCount() const override;
  virtual nsresult InsertChildAt(nsIContent* aKid, uint32_t aIndex,
                                 bool aNotify) override;
  virtual void RemoveChildAt(uint32_t aIndex, bool aNotify) override;
  virtual nsresult Clone(mozilla::dom::NodeInfo *aNodeInfo, nsINode **aResult) const override
  {
    return NS_ERROR_NOT_IMPLEMENTED;
  }

  // nsIRadioGroupContainer
  NS_IMETHOD WalkRadioGroup(const nsAString& aName,
                            nsIRadioVisitor* aVisitor,
                            bool aFlushContent) override;
  virtual void
    SetCurrentRadioButton(const nsAString& aName,
                          mozilla::dom::HTMLInputElement* aRadio) override;
  virtual mozilla::dom::HTMLInputElement*
    GetCurrentRadioButton(const nsAString& aName) override;
  NS_IMETHOD
    GetNextRadioButton(const nsAString& aName,
                       const bool aPrevious,
                       mozilla::dom::HTMLInputElement*  aFocusedRadio,
                       mozilla::dom::HTMLInputElement** aRadioOut) override;
  virtual void AddToRadioGroup(const nsAString& aName,
                               nsIFormControl* aRadio) override;
  virtual void RemoveFromRadioGroup(const nsAString& aName,
                                    nsIFormControl* aRadio) override;
  virtual uint32_t GetRequiredRadioCount(const nsAString& aName) const override;
  virtual void RadioRequiredWillChange(const nsAString& aName,
                                       bool aRequiredAdded) override;
  virtual bool GetValueMissingState(const nsAString& aName) const override;
  virtual void SetValueMissingState(const nsAString& aName, bool aValue) override;

  // for radio group
  nsRadioGroupStruct* GetRadioGroup(const nsAString& aName) const;
  nsRadioGroupStruct* GetOrCreateRadioGroup(const nsAString& aName);

  virtual nsViewportInfo GetViewportInfo(const mozilla::ScreenIntSize& aDisplaySize) override;

  void ReportUseCounters();

  virtual void AddIntersectionObserver(
    mozilla::dom::DOMIntersectionObserver* aObserver) override;
  virtual void RemoveIntersectionObserver(
    mozilla::dom::DOMIntersectionObserver* aObserver) override;
  virtual void UpdateIntersectionObservations() override;
  virtual void ScheduleIntersectionObserverNotification() override;
  virtual void NotifyIntersectionObservers() override;

  virtual void NotifyLayerManagerRecreated() override;


private:
  void AddOnDemandBuiltInUASheet(mozilla::StyleSheet* aSheet);
  nsRadioGroupStruct* GetRadioGroupInternal(const nsAString& aName) const;
  void SendToConsole(nsCOMArray<nsISecurityConsoleMessage>& aMessages);

public:
  // nsIDOMNode
  NS_FORWARD_NSIDOMNODE_TO_NSINODE_OVERRIDABLE

  // nsIDOMDocument
  NS_DECL_NSIDOMDOCUMENT

  // nsIDOMDocumentXBL
  NS_DECL_NSIDOMDOCUMENTXBL

  // nsIDOMEventTarget
  virtual nsresult PreHandleEvent(
                     mozilla::EventChainPreVisitor& aVisitor) override;
  virtual mozilla::EventListenerManager*
    GetOrCreateListenerManager() override;
  virtual mozilla::EventListenerManager*
    GetExistingListenerManager() const override;

  // nsIScriptObjectPrincipal
  virtual nsIPrincipal* GetPrincipal() override;

  // nsIApplicationCacheContainer
  NS_DECL_NSIAPPLICATIONCACHECONTAINER

  // nsIObserver
  NS_DECL_NSIOBSERVER

  NS_DECL_NSIDOMXPATHEVALUATOR

  virtual nsresult Init();

  virtual already_AddRefed<Element> CreateElem(const nsAString& aName,
                                               nsIAtom* aPrefix,
                                               int32_t aNamespaceID,
                                               const nsAString* aIs = nullptr) override;

  virtual void Sanitize() override;

  virtual void EnumerateSubDocuments(nsSubDocEnumFunc aCallback,
                                                 void *aData) override;

  virtual bool CanSavePresentation(nsIRequest *aNewRequest) override;
  virtual void Destroy() override;
  virtual void RemovedFromDocShell() override;
  virtual already_AddRefed<nsILayoutHistoryState> GetLayoutHistoryState() const override;

  virtual void BlockOnload() override;
  virtual void UnblockOnload(bool aFireSync) override;

  virtual void AddStyleRelevantLink(mozilla::dom::Link* aLink) override;
  virtual void ForgetLink(mozilla::dom::Link* aLink) override;

  virtual void ClearBoxObjectFor(nsIContent* aContent) override;

  virtual already_AddRefed<mozilla::dom::BoxObject>
  GetBoxObjectFor(mozilla::dom::Element* aElement,
                  mozilla::ErrorResult& aRv) override;

  virtual Element*
    GetAnonymousElementByAttribute(nsIContent* aElement,
                                   nsIAtom* aAttrName,
                                   const nsAString& aAttrValue) const override;

  virtual Element* ElementFromPointHelper(float aX, float aY,
                                          bool aIgnoreRootScrollFrame,
                                          bool aFlushLayout) override;

  virtual void ElementsFromPointHelper(float aX, float aY,
                                       uint32_t aFlags,
                                       nsTArray<RefPtr<mozilla::dom::Element>>& aElements) override;

  virtual nsresult NodesFromRectHelper(float aX, float aY,
                                                   float aTopSize, float aRightSize,
                                                   float aBottomSize, float aLeftSize,
                                                   bool aIgnoreRootScrollFrame,
                                                   bool aFlushLayout,
                                                   nsIDOMNodeList** aReturn) override;

  virtual void FlushSkinBindings() override;

  virtual nsresult InitializeFrameLoader(nsFrameLoader* aLoader) override;
  virtual nsresult FinalizeFrameLoader(nsFrameLoader* aLoader, nsIRunnable* aFinalizer) override;
  virtual void TryCancelFrameLoaderInitialization(nsIDocShell* aShell) override;
  virtual nsIDocument*
    RequestExternalResource(nsIURI* aURI,
                            nsINode* aRequestingNode,
                            ExternalResourceLoad** aPendingLoad) override;
  virtual void
    EnumerateExternalResources(nsSubDocEnumFunc aCallback, void* aData) override;

  // Returns our (lazily-initialized) animation controller.
  // If HasAnimationController is true, this is guaranteed to return non-null.
  nsSMILAnimationController* GetAnimationController() override;

  virtual mozilla::PendingAnimationTracker*
  GetPendingAnimationTracker() final override
  {
    return mPendingAnimationTracker;
  }

  virtual mozilla::PendingAnimationTracker*
  GetOrCreatePendingAnimationTracker() override;

  virtual void SuppressEventHandling(SuppressionType aWhat,
                                     uint32_t aIncrease) override;

  virtual void UnsuppressEventHandlingAndFireEvents(SuppressionType aWhat,
                                                    bool aFireEvents) override;

  void DecreaseEventSuppression() {
    MOZ_ASSERT(mEventsSuppressed);
    --mEventsSuppressed;
    MaybeRescheduleAnimationFrameNotifications();
  }

  void ResumeAnimations() {
    MOZ_ASSERT(mAnimationsPaused);
    --mAnimationsPaused;
    MaybeRescheduleAnimationFrameNotifications();
  }

  virtual nsIDocument* GetTemplateContentsOwner() override;

  NS_DECL_CYCLE_COLLECTION_SKIPPABLE_SCRIPT_HOLDER_CLASS_AMBIGUOUS(nsDocument,
                                                                   nsIDocument)

  void DoNotifyPossibleTitleChange();

  nsExternalResourceMap& ExternalResourceMap()
  {
    return mExternalResourceMap;
  }

  void SetLoadedAsData(bool aLoadedAsData) { mLoadedAsData = aLoadedAsData; }
  void SetLoadedAsInteractiveData(bool aLoadedAsInteractiveData)
  {
    mLoadedAsInteractiveData = aLoadedAsInteractiveData;
  }

  nsresult CloneDocHelper(nsDocument* clone) const;

  void MaybeInitializeFinalizeFrameLoaders();

  void MaybeEndOutermostXBLUpdate();

  virtual void PreloadPictureOpened() override;
  virtual void PreloadPictureClosed() override;

  virtual void
    PreloadPictureImageSource(const nsAString& aSrcsetAttr,
                              const nsAString& aSizesAttr,
                              const nsAString& aTypeAttr,
                              const nsAString& aMediaAttr) override;

  virtual already_AddRefed<nsIURI>
    ResolvePreloadImage(nsIURI *aBaseURI,
                        const nsAString& aSrcAttr,
                        const nsAString& aSrcsetAttr,
                        const nsAString& aSizesAttr) override;

  virtual void MaybePreLoadImage(nsIURI* uri,
                                 const nsAString &aCrossOriginAttr,
                                 ReferrerPolicy aReferrerPolicy) override;
  virtual void ForgetImagePreload(nsIURI* aURI) override;

  virtual void MaybePreconnect(nsIURI* uri,
                               mozilla::CORSMode aCORSMode) override;

  virtual void PreloadStyle(nsIURI* uri, const nsAString& charset,
                            const nsAString& aCrossOriginAttr,
                            ReferrerPolicy aReferrerPolicy,
                            const nsAString& aIntegrity) override;

  virtual nsresult LoadChromeSheetSync(nsIURI* uri, bool isAgentSheet,
                                       RefPtr<mozilla::StyleSheet>* aSheet) override;

  virtual nsISupports* GetCurrentContentSink() override;

  virtual mozilla::EventStates GetDocumentState() override;

  // Only BlockOnload should call this!
  void AsyncBlockOnload();

  virtual void SetScrollToRef(nsIURI *aDocumentURI) override;
  virtual void ScrollToRef() override;
  virtual void ResetScrolledToRefAlready() override;
  virtual void SetChangeScrollPosWhenScrollingToRef(bool aValue) override;

  virtual Element *GetElementById(const nsAString& aElementId) override;
  virtual const nsTArray<Element*>* GetAllElementsForId(const nsAString& aElementId) const override;

  virtual Element *LookupImageElement(const nsAString& aElementId) override;
  virtual void MozSetImageElement(const nsAString& aImageElementId,
                                  Element* aElement) override;

  // AddPlugin adds a plugin-related element to mPlugins when the element is
  // added to the tree.
  virtual nsresult AddPlugin(nsIObjectLoadingContent* aPlugin) override;
  // RemovePlugin removes a plugin-related element to mPlugins when the
  // element is removed from the tree.
  virtual void RemovePlugin(nsIObjectLoadingContent* aPlugin) override;
  // GetPlugins returns the plugin-related elements from
  // the frame and any subframes.
  virtual void GetPlugins(nsTArray<nsIObjectLoadingContent*>& aPlugins) override;

  // Adds an element to mResponsiveContent when the element is
  // added to the tree.
  virtual nsresult AddResponsiveContent(nsIContent* aContent) override;
  // Removes an element from mResponsiveContent when the element is
  // removed from the tree.
  virtual void RemoveResponsiveContent(nsIContent* aContent) override;
  // Notifies any responsive content added by AddResponsiveContent upon media
  // features values changing.
  virtual void NotifyMediaFeatureValuesChanged() override;

  virtual nsresult GetStateObject(nsIVariant** aResult) override;

  virtual nsDOMNavigationTiming* GetNavigationTiming() const override;
  virtual nsresult SetNavigationTiming(nsDOMNavigationTiming* aTiming) override;

  virtual Element* FindImageMap(const nsAString& aNormalizedMapName) override;

  virtual nsTArray<Element*> GetFullscreenStack() const override;
  virtual void AsyncRequestFullScreen(
    mozilla::UniquePtr<FullscreenRequest>&& aRequest) override;
  virtual void RestorePreviousFullScreenState() override;
  virtual bool IsFullscreenLeaf() override;
  virtual nsresult
    RemoteFrameFullscreenChanged(nsIDOMElement* aFrameElement) override;

  virtual nsresult RemoteFrameFullscreenReverted() override;
  virtual nsIDocument* GetFullscreenRoot() override;
  virtual void SetFullscreenRoot(nsIDocument* aRoot) override;

  // Returns the size of the mBlockedTrackingNodes array. (nsIDocument.h)
  //
  // This array contains nodes that have been blocked to prevent
  // user tracking. They most likely have had their nsIChannel
  // canceled by the URL classifier (Safebrowsing).
  //
  // A script can subsequently use GetBlockedTrackingNodes()
  // to get a list of references to these nodes.
  //
  // Note:
  // This expresses how many tracking nodes have been blocked for this
  // document since its beginning, not how many of them are still around
  // in the DOM tree. Weak references to blocked nodes are added in the
  // mBlockedTrackingNodesArray but they are not removed when those nodes
  // are removed from the tree or even garbage collected.
  long BlockedTrackingNodeCount() const;

  //
  // Returns strong references to mBlockedTrackingNodes. (nsIDocument.h)
  //
  // This array contains nodes that have been blocked to prevent
  // user tracking. They most likely have had their nsIChannel
  // canceled by the URL classifier (Safebrowsing).
  //
  already_AddRefed<nsSimpleContentList> BlockedTrackingNodes() const;

  static bool IsUnprefixedFullscreenEnabled(JSContext* aCx, JSObject* aObject);

  // Do the "fullscreen element ready check" from the fullscreen spec.
  // It returns true if the given element is allowed to go into fullscreen.
  bool FullscreenElementReadyCheck(Element* aElement, bool aWasCallerChrome);

  // This is called asynchronously by nsIDocument::AsyncRequestFullScreen()
  // to move this document into full-screen mode if allowed.
  void RequestFullScreen(mozilla::UniquePtr<FullscreenRequest>&& aRequest);

  // Removes all elements from the full-screen stack, removing full-scren
  // styles from the top element in the stack.
  void CleanupFullscreenState();

  // Pushes aElement onto the full-screen stack, and removes full-screen styles
  // from the former full-screen stack top, and its ancestors, and applies the
  // styles to aElement. aElement becomes the new "full-screen element".
  bool FullScreenStackPush(Element* aElement);

  // Remove the top element from the full-screen stack. Removes the full-screen
  // styles from the former top element, and applies them to the new top
  // element, if there is one.
  void FullScreenStackPop();

  // Returns the top element from the full-screen stack.
  Element* FullScreenStackTop();

  // DOM-exposed fullscreen API
  bool FullscreenEnabled() override;
  Element* GetFullscreenElement() override;

  void RequestPointerLock(Element* aElement) override;
  bool SetPointerLock(Element* aElement, int aCursorStyle);
  static void UnlockPointer(nsIDocument* aDoc = nullptr);

  void SetCurrentOrientation(mozilla::dom::OrientationType aType,
                             uint16_t aAngle) override;
  uint16_t CurrentOrientationAngle() const override;
  mozilla::dom::OrientationType CurrentOrientationType() const override;
  void SetOrientationPendingPromise(mozilla::dom::Promise* aPromise) override;
  mozilla::dom::Promise* GetOrientationPendingPromise() const override;

  // This method may fire a DOM event; if it does so it will happen
  // synchronously.
  void UpdateVisibilityState();
  // Posts an event to call UpdateVisibilityState
  virtual void PostVisibilityUpdateEvent() override;

  // Since we wouldn't automatically play media from non-visited page, we need
  // to notify window when the page was first visited.
  void MaybeActiveMediaComponents();

  virtual void DocAddSizeOfExcludingThis(nsWindowSizes* aWindowSizes) const override;
  // DocAddSizeOfIncludingThis is inherited from nsIDocument.

  virtual nsIDOMNode* AsDOMNode() override { return this; }

  // WebIDL bits
  virtual mozilla::dom::DOMImplementation*
    GetImplementation(mozilla::ErrorResult& rv) override;
  virtual void
    RegisterElement(JSContext* aCx, const nsAString& aName,
                    const mozilla::dom::ElementRegistrationOptions& aOptions,
                    JS::MutableHandle<JSObject*> aRetval,
                    mozilla::ErrorResult& rv) override;
  virtual mozilla::dom::StyleSheetList* StyleSheets() override;
  virtual void SetSelectedStyleSheetSet(const nsAString& aSheetSet) override;
  virtual void GetLastStyleSheetSet(nsString& aSheetSet) override;
  virtual mozilla::dom::DOMStringList* StyleSheetSets() override;
  virtual void EnableStyleSheetsForSet(const nsAString& aSheetSet) override;
  virtual already_AddRefed<Element> CreateElement(const nsAString& aTagName,
                                                  const mozilla::dom::ElementCreationOptionsOrString& aOptions,
                                                  ErrorResult& rv) override;
  virtual already_AddRefed<Element> CreateElementNS(const nsAString& aNamespaceURI,
                                                    const nsAString& aQualifiedName,
                                                    const mozilla::dom::ElementCreationOptionsOrString& aOptions,
                                                    mozilla::ErrorResult& rv) override;

  virtual nsIDocument* MasterDocument() override
  {
    return mMasterDocument ? mMasterDocument.get()
                           : this;
  }

  virtual void SetMasterDocument(nsIDocument* master) override
  {
    MOZ_ASSERT(master);
    mMasterDocument = master;
  }

  virtual bool IsMasterDocument() override
  {
    return !mMasterDocument;
  }

  virtual mozilla::dom::ImportManager* ImportManager() override
  {
    if (mImportManager) {
      MOZ_ASSERT(!mMasterDocument, "Only the master document has ImportManager set");
      return mImportManager.get();
    }

    if (mMasterDocument) {
      return mMasterDocument->ImportManager();
    }

    // ImportManager is created lazily.
    // If the manager is not yet set it has to be the
    // master document and this is the first import in it.
    // Let's create a new manager.
    mImportManager = new mozilla::dom::ImportManager();
    return mImportManager.get();
  }

  virtual bool HasSubImportLink(nsINode* aLink) override
  {
    return mSubImportLinks.Contains(aLink);
  }

  virtual uint32_t IndexOfSubImportLink(nsINode* aLink) override
  {
    return mSubImportLinks.IndexOf(aLink);
  }

  virtual void AddSubImportLink(nsINode* aLink) override
  {
    mSubImportLinks.AppendElement(aLink);
  }

  virtual nsINode* GetSubImportLink(uint32_t aIdx) override
  {
    return aIdx < mSubImportLinks.Length() ? mSubImportLinks[aIdx].get()
                                           : nullptr;
  }

  virtual void UnblockDOMContentLoaded() override;

protected:
  friend class nsNodeUtils;
  friend class nsDocumentOnStack;

  void IncreaseStackRefCnt()
  {
    ++mStackRefCnt;
  }

  void DecreaseStackRefCnt()
  {
    if (--mStackRefCnt == 0 && mNeedsReleaseAfterStackRefCntRelease) {
      mNeedsReleaseAfterStackRefCntRelease = false;
      NS_RELEASE_THIS();
    }
  }

  /**
   * Check that aId is not empty and log a message to the console
   * service if it is.
   * @returns true if aId looks correct, false otherwise.
   */
  inline bool CheckGetElementByIdArg(const nsAString& aId)
  {
    if (aId.IsEmpty()) {
      ReportEmptyGetElementByIdArg();
      return false;
    }
    return true;
  }

  void ReportEmptyGetElementByIdArg();

  void DispatchContentLoadedEvents();

  void RetrieveRelevantHeaders(nsIChannel *aChannel);

  void TryChannelCharset(nsIChannel *aChannel,
                         int32_t& aCharsetSource,
                         nsACString& aCharset,
                         nsHtml5TreeOpExecutor* aExecutor);

  // Call this before the document does something that will unbind all content.
  // That will stop us from doing a lot of work as each element is removed.
  void DestroyElementMaps();

  // Refreshes the hrefs of all the links in the document.
  void RefreshLinkHrefs();

  nsIContent* GetFirstBaseNodeWithHref();
  nsresult SetFirstBaseNodeWithHref(nsIContent *node);

  /**
   * Returns the title element of the document as defined by the HTML
   * specification, or null if there isn't one.  For documents whose root
   * element is an <svg:svg>, this is the first <svg:title> element that's a
   * child of the root.  For other documents, it's the first HTML title element
   * in the document.
   */
  Element* GetTitleElement();

public:
  // Get our title
  virtual void GetTitle(nsString& aTitle) override;
  // Set our title
  virtual void SetTitle(const nsAString& aTitle, mozilla::ErrorResult& rv) override;

  bool mIsTopLevelContentDocument: 1;
  bool mIsContentDocument: 1;

  bool IsTopLevelContentDocument();
  void SetIsTopLevelContentDocument(bool aIsTopLevelContentDocument);

  bool IsContentDocument() const;
  void SetIsContentDocument(bool aIsContentDocument);

  js::ExpandoAndGeneration mExpandoAndGeneration;

  bool ContainsEMEContent();

  bool ContainsMSEContent();

protected:
  already_AddRefed<nsIPresShell> doCreateShell(nsPresContext* aContext,
                                               nsViewManager* aViewManager,
                                               mozilla::StyleSetHandle aStyleSet);

  void RemoveDocStyleSheetsFromStyleSets();
  void RemoveStyleSheetsFromStyleSets(
      const nsTArray<RefPtr<mozilla::StyleSheet>>& aSheets,
      mozilla::SheetType aType);
  void ResetStylesheetsToURI(nsIURI* aURI);
  void FillStyleSet(mozilla::StyleSetHandle aStyleSet);

  // Return whether all the presshells for this document are safe to flush
  bool IsSafeToFlush() const;

  void DispatchPageTransition(mozilla::dom::EventTarget* aDispatchTarget,
                              const nsAString& aType,
                              bool aPersisted);

  virtual nsPIDOMWindowOuter* GetWindowInternal() const override;
  virtual nsIScriptGlobalObject* GetScriptHandlingObjectInternal() const override;
  virtual bool InternalAllowXULXBL() override;

  void UpdateScreenOrientation();

#define NS_DOCUMENT_NOTIFY_OBSERVERS(func_, params_)                        \
  NS_OBSERVER_ARRAY_NOTIFY_XPCOM_OBSERVERS(mObservers, nsIDocumentObserver, \
                                           func_, params_);

#ifdef DEBUG
  void VerifyRootContentState();
#endif

  explicit nsDocument(const char* aContentType);
  virtual ~nsDocument();

  void EnsureOnloadBlocker();

  void NotifyStyleSheetApplicableStateChanged();

  // Apply the fullscreen state to the document, and trigger related
  // events. It returns false if the fullscreen element ready check
  // fails and nothing gets changed.
  bool ApplyFullscreen(const FullscreenRequest& aRequest);

  nsTArray<nsIObserver*> mCharSetObservers;

  PLDHashTable *mSubDocuments;

  // Array of owning references to all children
  nsAttrAndChildArray mChildren;

  // Pointer to our parser if we're currently in the process of being
  // parsed into.
  nsCOMPtr<nsIParser> mParser;

  // Weak reference to our sink for in case we no longer have a parser.  This
  // will allow us to flush out any pending stuff from the sink even if
  // EndLoad() has already happened.
  nsWeakPtr mWeakSink;

  nsTArray<RefPtr<mozilla::StyleSheet>> mStyleSheets;
  nsTArray<RefPtr<mozilla::StyleSheet>> mOnDemandBuiltInUASheets;
  nsTArray<RefPtr<mozilla::StyleSheet>> mAdditionalSheets[AdditionalSheetTypeCount];

  // Array of observers
  nsTObserverArray<nsIDocumentObserver*> mObservers;

  // Array of intersection observers
  nsTArray<RefPtr<mozilla::dom::DOMIntersectionObserver>> mIntersectionObservers;

  // Tracker for animations that are waiting to start.
  // nullptr until GetOrCreatePendingAnimationTracker is called.
  RefPtr<mozilla::PendingAnimationTracker> mPendingAnimationTracker;

  // Weak reference to the scope object (aka the script global object)
  // that, unlike mScriptGlobalObject, is never unset once set. This
  // is a weak reference to avoid leaks due to circular references.
  nsWeakPtr mScopeObject;

  // Stack of full-screen elements. When we request full-screen we push the
  // full-screen element onto this stack, and when we cancel full-screen we
  // pop one off this stack, restoring the previous full-screen state
  nsTArray<nsWeakPtr> mFullScreenStack;

  // The root of the doc tree in which this document is in. This is only
  // non-null when this document is in fullscreen mode.
  nsWeakPtr mFullscreenRoot;

private:
  static bool CustomElementConstructor(JSContext* aCx, unsigned aArgc, JS::Value* aVp);

  /**
   * Check if the passed custom element name, aOptions.mIs, is a registered
   * custom element type or not, then return the custom element name for future
   * usage.
   *
   * If there is no existing custom element definition for this name, throw a
   * NotFoundError.
   */
  const nsString* CheckCustomElementName(
    const mozilla::dom::ElementCreationOptions& aOptions,
    const nsAString& aLocalName,
    uint32_t aNamespaceID,
    ErrorResult& rv);

public:
  virtual already_AddRefed<mozilla::dom::CustomElementRegistry>
    GetCustomElementRegistry() override;

  // Check whether web components are enabled for the global of aObject.
  static bool IsWebComponentsEnabled(JSContext* aCx, JSObject* aObject);
  // Check whether web components are enabled for the global of the document
  // this nodeinfo comes from.
  static bool IsWebComponentsEnabled(mozilla::dom::NodeInfo* aNodeInfo);
  // Check whether web components are enabled for the given window.
  static bool IsWebComponentsEnabled(nsPIDOMWindowInner* aWindow);

  RefPtr<mozilla::EventListenerManager> mListenerManager;
  RefPtr<mozilla::dom::StyleSheetList> mDOMStyleSheets;
  RefPtr<nsDOMStyleSheetSetList> mStyleSheetSetList;
  RefPtr<nsScriptLoader> mScriptLoader;
  nsDocHeaderData* mHeaderData;
  /* mIdentifierMap works as follows for IDs:
   * 1) Attribute changes affect the table immediately (removing and adding
   *    entries as needed).
   * 2) Removals from the DOM affect the table immediately
   * 3) Additions to the DOM always update existing entries for names, and add
   *    new ones for IDs.
   */
  nsTHashtable<nsIdentifierMapEntry> mIdentifierMap;

  nsClassHashtable<nsStringHashKey, nsRadioGroupStruct> mRadioGroups;

  // Recorded time of change to 'loading' state.
  mozilla::TimeStamp mLoadingTimeStamp;

  // True if the document has been detached from its content viewer.
  bool mIsGoingAway:1;
  // True if the document is being destroyed.
  bool mInDestructor:1;

  // True if this document has ever had an HTML or SVG <title> element
  // bound to it
  bool mMayHaveTitleElement:1;

  bool mHasWarnedAboutBoxObjects:1;

  bool mDelayFrameLoaderInitialization:1;

  bool mSynchronousDOMContentLoaded:1;

  bool mInXBLUpdate:1;

  // Whether we're currently under a FlushPendingNotifications call to
  // our presshell.  This is used to handle flush reentry correctly.
  bool mInFlush:1;

  // Parser aborted. True if the parser of this document was forcibly
  // terminated instead of letting it finish at its own pace.
  bool mParserAborted:1;

  friend class nsCallRequestFullScreen;

  // ScreenOrientation "pending promise" as described by
  // http://www.w3.org/TR/screen-orientation/
  RefPtr<mozilla::dom::Promise> mOrientationPendingPromise;

  uint16_t mCurrentOrientationAngle;
  mozilla::dom::OrientationType mCurrentOrientationType;

  // Keeps track of whether we have a pending
  // 'style-sheet-applicable-state-changed' notification.
  bool mSSApplicableStateNotificationPending:1;

  // Whether we have reported use counters for this document with Telemetry yet.
  // Normally this is only done at document destruction time, but for image
  // documents (SVG documents) that are not guaranteed to be destroyed, we
  // report use counters when the image cache no longer has any imgRequestProxys
  // pointing to them.  We track whether we ever reported use counters so
  // that we only report them once for the document.
  bool mReportedUseCounters:1;

  // Whether we have filled our pres shell's style set with the document's
  // additional sheets and sheets from the nsStyleSheetService.
  bool mStyleSetFilled:1;

  uint8_t mPendingFullscreenRequests;

  uint8_t mXMLDeclarationBits;

  nsInterfaceHashtable<nsPtrHashKey<nsIContent>, nsPIBoxObject> *mBoxObjectTable;

  // A document "without a browsing context" that owns the content of
  // HTMLTemplateElement.
  nsCOMPtr<nsIDocument> mTemplateContentsOwner;

  // Our update nesting level
  uint32_t mUpdateNestLevel;

  // The application cache that this document is associated with, if
  // any.  This can change during the lifetime of the document.
  nsCOMPtr<nsIApplicationCache> mApplicationCache;

  nsCOMPtr<nsIContent> mFirstBaseNodeWithHref;

  mozilla::EventStates mDocumentState;
  mozilla::EventStates mGotDocumentState;

  RefPtr<nsDOMNavigationTiming> mTiming;
private:
  friend class nsUnblockOnloadEvent;
  // Recomputes the visibility state but doesn't set the new value.
  mozilla::dom::VisibilityState GetVisibilityState() const;
  void NotifyStyleSheetAdded(mozilla::StyleSheet* aSheet, bool aDocumentSheet);
  void NotifyStyleSheetRemoved(mozilla::StyleSheet* aSheet, bool aDocumentSheet);

  void PostUnblockOnloadEvent();
  void DoUnblockOnload();

  nsresult CheckFrameOptions();
  nsresult InitCSP(nsIChannel* aChannel);

  /**
   * Find the (non-anonymous) content in this document for aFrame. It will
   * be aFrame's content node if that content is in this document and not
   * anonymous. Otherwise, when aFrame is in a subdocument, we use the frame
   * element containing the subdocument containing aFrame, and/or find the
   * nearest non-anonymous ancestor in this document.
   * Returns null if there is no such element.
   */
  nsIContent* GetContentInThisDocument(nsIFrame* aFrame) const;

  // Just like EnableStyleSheetsForSet, but doesn't check whether
  // aSheetSet is null and allows the caller to control whether to set
  // aSheetSet as the preferred set in the CSSLoader.
  void EnableStyleSheetsForSetInternal(const nsAString& aSheetSet,
                                       bool aUpdateCSSLoader);

  // Revoke any pending notifications due to requestAnimationFrame calls
  void RevokeAnimationFrameNotifications();
  // Reschedule any notifications we need to handle
  // requestAnimationFrame, if it's OK to do so.
  void MaybeRescheduleAnimationFrameNotifications();

  void ClearAllBoxObjects();

  // Returns true if the scheme for the url for this document is "about"
  bool IsAboutPage();

  // These are not implemented and not supported.
  nsDocument(const nsDocument& aOther);
  nsDocument& operator=(const nsDocument& aOther);

  // The layout history state that should be used by nodes in this
  // document.  We only actually store a pointer to it when:
  // 1)  We have no script global object.
  // 2)  We haven't had Destroy() called on us yet.
  nsCOMPtr<nsILayoutHistoryState> mLayoutHistoryState;

  // Currently active onload blockers
  uint32_t mOnloadBlockCount;
  // Onload blockers which haven't been activated yet
  uint32_t mAsyncOnloadBlockCount;
  nsCOMPtr<nsIRequest> mOnloadBlocker;

  // A hashtable of styled links keyed by address pointer.
  nsTHashtable<nsPtrHashKey<mozilla::dom::Link> > mStyledLinks;
#ifdef DEBUG
  // Indicates whether mStyledLinks was cleared or not.  This is used to track
  // state so we can provide useful assertions to consumers of ForgetLink and
  // AddStyleRelevantLink.
  bool mStyledLinksCleared;
#endif

  // A set of responsive images keyed by address pointer.
  nsTHashtable< nsPtrHashKey<nsIContent> > mResponsiveContent;

  // Member to store out last-selected stylesheet set.
  nsString mLastStyleSheetSet;

  nsTArray<RefPtr<nsFrameLoader> > mInitializableFrameLoaders;
  nsTArray<nsCOMPtr<nsIRunnable> > mFrameLoaderFinalizers;
  RefPtr<nsRunnableMethod<nsDocument> > mFrameLoaderRunner;

  nsCOMPtr<nsIRunnable> mMaybeEndOutermostXBLUpdateRunner;

  nsRevocableEventPtr<nsRunnableMethod<nsDocument, void, false> >
    mPendingTitleChangeEvent;

  nsExternalResourceMap mExternalResourceMap;

  // All images in process of being preloaded.  This is a hashtable so
  // we can remove them as the real image loads start; that way we
  // make sure to not keep the image load going when no one cares
  // about it anymore.
  nsRefPtrHashtable<nsURIHashKey, imgIRequest> mPreloadingImages;

  // A list of preconnects initiated by the preloader. This prevents
  // the same uri from being used more than once, and allows the dom
  // builder to not repeat the work of the preloader.
  nsDataHashtable< nsURIHashKey, bool> mPreloadedPreconnects;

  // Current depth of picture elements from parser
  int32_t mPreloadPictureDepth;

  // Set if we've found a URL for the current picture
  nsString mPreloadPictureFoundSource;

  RefPtr<mozilla::dom::DOMImplementation> mDOMImplementation;

  RefPtr<nsContentList> mImageMaps;

  nsCString mScrollToRef;
  uint8_t mScrolledToRefAlready : 1;
  uint8_t mChangeScrollPosWhenScrollingToRef : 1;

  // Tracking for plugins in the document.
  nsTHashtable< nsPtrHashKey<nsIObjectLoadingContent> > mPlugins;

  RefPtr<mozilla::dom::DocumentTimeline> mDocumentTimeline;
  mozilla::LinkedList<mozilla::dom::DocumentTimeline> mTimelines;

  enum ViewportType {
    DisplayWidthHeight,
    Specified,
    Unknown
  };

  ViewportType mViewportType;

  // These member variables cache information about the viewport so we don't have to
  // recalculate it each time.
  bool mValidWidth, mValidHeight;
  mozilla::LayoutDeviceToScreenScale mScaleMinFloat;
  mozilla::LayoutDeviceToScreenScale mScaleMaxFloat;
  mozilla::LayoutDeviceToScreenScale mScaleFloat;
  mozilla::CSSToLayoutDeviceScale mPixelRatio;
  bool mAutoSize, mAllowZoom, mAllowDoubleTapZoom, mValidScaleFloat, mValidMaxScale, mScaleStrEmpty, mWidthStrEmpty;
  mozilla::CSSSize mViewportSize;

  nsrefcnt mStackRefCnt;
  bool mNeedsReleaseAfterStackRefCntRelease;

  nsCOMPtr<nsIDocument> mMasterDocument;
  RefPtr<mozilla::dom::ImportManager> mImportManager;
  nsTArray<nsCOMPtr<nsINode> > mSubImportLinks;

  // Set to true when the document is possibly controlled by the ServiceWorker.
  // Used to prevent multiple requests to ServiceWorkerManager.
  bool mMaybeServiceWorkerControlled;

#ifdef DEBUG
public:
  bool mWillReparent;
#endif
};

class nsDocumentOnStack
{
public:
  explicit nsDocumentOnStack(nsDocument* aDoc) : mDoc(aDoc)
  {
    mDoc->IncreaseStackRefCnt();
  }
  ~nsDocumentOnStack()
  {
    mDoc->DecreaseStackRefCnt();
  }
private:
  nsDocument* mDoc;
};

#endif /* nsDocument_h___ */
