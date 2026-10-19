/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsHTMLDocument.h"

#include "DocumentInlines.h"
#include "mozilla/PresShell.h"
#include "mozilla/StaticPrefs_intl.h"
#include "mozilla/css/Loader.h"
#include "mozilla/dom/ContentList.h"
#include "mozilla/dom/PrototypeDocumentContentSink.h"
#include "mozilla/parser/PrototypeDocumentParser.h"
#include "nsArrayUtils.h"
#include "nsAttrName.h"
#include "nsCOMPtr.h"
#include "nsCommandManager.h"
#include "nsContentUtils.h"
#include "nsDOMString.h"
#include "nsDocShell.h"
#include "nsDocShellLoadTypes.h"
#include "nsError.h"
#include "nsFrameSelection.h"
#include "nsGenericHTMLElement.h"
#include "nsGkAtoms.h"
#include "nsHTMLParts.h"
#include "nsICachingChannel.h"
#include "nsIDocumentViewer.h"
#include "nsIPrincipal.h"
#include "nsIProtocolHandler.h"
#include "nsIScriptContext.h"
#include "nsIScriptElement.h"
#include "nsIStreamListener.h"
#include "nsIURI.h"
#include "nsIXMLContentSink.h"
#include "nsJSPrincipals.h"
#include "nsJSUtils.h"
#include "nsNameSpaceManager.h"
#include "nsNetCID.h"
#include "nsNetUtil.h"
#include "nsPIDOMWindow.h"
#include "nsPresContext.h"
#include "nsPrintfCString.h"
#include "nsReadableUtils.h"
#include "nsString.h"
#include "nsUnicharUtils.h"

// AHMED 12-2
#include "mozAutoDocUpdate.h"
#include "mozilla/Encoding.h"
#include "mozilla/EventListenerManager.h"
#include "mozilla/IdentifierMapEntry.h"
#include "mozilla/LoadInfo.h"
#include "mozilla/Preferences.h"
#include "mozilla/ScopeExit.h"
#include "mozilla/StyleSheet.h"
#include "mozilla/StyleSheetInlines.h"
#include "mozilla/dom/Element.h"
#include "mozilla/dom/HTMLBodyElement.h"
#include "mozilla/dom/HTMLDocumentBinding.h"
#include "mozilla/dom/HTMLIFrameElement.h"
#include "mozilla/dom/Selection.h"
#include "mozilla/dom/ShadowIncludingTreeIterator.h"
#include "mozilla/dom/nsCSPContext.h"
#include "mozilla/glean/DomMetrics.h"
#include "nsBidiUtils.h"
#include "nsCCUncollectableMarker.h"
#include "nsCharsetSource.h"
#include "nsFocusManager.h"
#include "nsHtml5Module.h"
#include "nsHtml5Parser.h"
#include "nsHtml5TreeOpExecutor.h"
#include "nsIContent.h"
#include "nsIFrame.h"
#include "nsIRequest.h"
#include "nsMimeTypes.h"
#include "nsNodeInfoManager.h"
#include "nsParser.h"
#include "nsRange.h"
#include "nsSandboxFlags.h"

using namespace mozilla;
using namespace mozilla::dom;

#include "prtime.h"

// #define DEBUG_charset

// ==================================================================
// =
// ==================================================================

nsresult NS_NewHTMLDocument(Document** aInstancePtrResult,
                            nsIPrincipal* aPrincipal,
                            nsIPrincipal* aPartitionedPrincipal,
                            mozilla::dom::LoadedAsData aLoadedAsData) {
  RefPtr<nsHTMLDocument> doc = new nsHTMLDocument(aLoadedAsData);

  nsresult rv = doc->Init(aPrincipal, aPartitionedPrincipal);

  if (NS_FAILED(rv)) {
    *aInstancePtrResult = nullptr;
    return rv;
  }

  doc->SetLoadedAsData(aLoadedAsData != mozilla::dom::LoadedAsData::No,
                       /* aConsiderForMemoryReporting */ true);
  doc.forget(aInstancePtrResult);

  return NS_OK;
}

nsHTMLDocument::nsHTMLDocument(mozilla::dom::LoadedAsData aLoadedAsData)
    : Document("text/html", aLoadedAsData),
      mContentListHolder(nullptr),
      mNumForms(0),
      mLoadFlags(0),
      mWarnedWidthHeight(false),
      mIsPlainText(false),
      mViewSource(false) {
  mType = eHTML;
  mDefaultElementType = kNameSpaceID_XHTML;
  mCompatMode = eCompatibility_NavQuirks;
}

nsHTMLDocument::~nsHTMLDocument() = default;

JSObject* nsHTMLDocument::WrapNode(JSContext* aCx,
                                   JS::Handle<JSObject*> aGivenProto) {
  return HTMLDocument_Binding::Wrap(aCx, this, aGivenProto);
}

nsresult nsHTMLDocument::Init(nsIPrincipal* aPrincipal,
                              nsIPrincipal* aPartitionedPrincipal) {
  nsresult rv = Document::Init(aPrincipal, aPartitionedPrincipal);
  NS_ENSURE_SUCCESS(rv, rv);

  // Now reset the compatibility mode of the CSSLoader
  // to match our compat mode.
  if (mCSSLoader) {
    mCSSLoader->SetCompatibilityMode(mCompatMode);
  }

  return NS_OK;
}

void nsHTMLDocument::Reset(nsIChannel* aChannel, nsILoadGroup* aLoadGroup) {
  Document::Reset(aChannel, aLoadGroup);

  if (aChannel) {
    aChannel->GetLoadFlags(&mLoadFlags);
  }
}

void nsHTMLDocument::ResetToURI(nsIURI* aURI, nsILoadGroup* aLoadGroup,
                                nsIPrincipal* aPrincipal,
                                nsIPrincipal* aPartitionedPrincipal) {
  mLoadFlags = nsIRequest::LOAD_NORMAL;

  Document::ResetToURI(aURI, aLoadGroup, aPrincipal, aPartitionedPrincipal);

  mImages = nullptr;
  mApplets = nullptr;
  mEmbeds = nullptr;
  mLinks = nullptr;
  mAnchors = nullptr;
  mScripts = nullptr;

  mForms = nullptr;

  // Make the content type default to "text/html", we are a HTML
  // document, after all. Once we start getting data, this may be
  // changed.
  SetContentType(nsDependentCString("text/html"));
}

void nsHTMLDocument::TryReloadCharset(nsIDocumentViewer* aViewer,
                                      int32_t& aCharsetSource,
                                      NotNull<const Encoding*>& aEncoding) {
  if (aViewer) {
    int32_t reloadEncodingSource;
    const auto reloadEncoding =
        aViewer->GetReloadEncodingAndSource(&reloadEncodingSource);
    if (kCharsetUninitialized != reloadEncodingSource) {
      aViewer->ForgetReloadEncoding();

      if (reloadEncodingSource <= aCharsetSource ||
          !IsAsciiCompatible(aEncoding)) {
        return;
      }

      if (reloadEncoding && IsAsciiCompatible(reloadEncoding)) {
        aCharsetSource = reloadEncodingSource;
        aEncoding = WrapNotNull(reloadEncoding);
      }
    }
  }
}

void nsHTMLDocument::TryUserForcedCharset(nsIDocumentViewer* aViewer,
                                          nsIDocShell* aDocShell,
                                          int32_t& aCharsetSource,
                                          NotNull<const Encoding*>& aEncoding,
                                          bool& aForceAutoDetection) {
  auto resetForce = MakeScopeExit([&] {
    if (aDocShell) {
      nsDocShell::Cast(aDocShell)->ResetForcedAutodetection();
    }
  });

  if (aCharsetSource >= kCharsetFromOtherComponent) {
    return;
  }

  // mCharacterSet not updated yet for channel, so check aEncoding, too.
  if (WillIgnoreCharsetOverride() || !IsAsciiCompatible(aEncoding)) {
    return;
  }

  if (aDocShell && nsDocShell::Cast(aDocShell)->GetForcedAutodetection()) {
    // This is the Character Encoding menu code path in Firefox
    aForceAutoDetection = true;
  }
}

void nsHTMLDocument::TryParentCharset(nsIDocShell* aDocShell,
                                      int32_t& aCharsetSource,
                                      NotNull<const Encoding*>& aEncoding,
                                      bool& aForceAutoDetection) {
  if (!aDocShell) {
    return;
  }
  if (aCharsetSource >= kCharsetFromOtherComponent) {
    return;
  }

  int32_t parentSource;
  const Encoding* parentCharset;
  nsCOMPtr<nsIPrincipal> parentPrincipal;
  aDocShell->GetParentCharset(parentCharset, &parentSource,
                              getter_AddRefs(parentPrincipal));
  if (!parentCharset) {
    return;
  }
  if (kCharsetFromInitialUserForcedAutoDetection == parentSource ||
      kCharsetFromFinalUserForcedAutoDetection == parentSource) {
    if (WillIgnoreCharsetOverride() ||
        !aEncoding->IsAsciiCompatible() ||  // if channel said UTF-16
        !parentCharset->IsAsciiCompatible()) {
      return;
    }
    aEncoding = WrapNotNull(parentCharset);
    aCharsetSource = kCharsetFromParentFrame;
    aForceAutoDetection = true;
    return;
  }

  if (aCharsetSource >= kCharsetFromParentFrame) {
    return;
  }

  if (kCharsetFromInitialAutoDetectionASCII <= parentSource) {
    // Make sure that's OK
    if (!NodePrincipal()->Equals(parentPrincipal) ||
        !parentCharset->IsAsciiCompatible()) {
      return;
    }

    aEncoding = WrapNotNull(parentCharset);
    aCharsetSource = kCharsetFromParentFrame;
  }
}

// Using a prototype document is only allowed with chrome privilege.
bool ShouldUsePrototypeDocument(nsIChannel* aChannel, Document* aDoc) {
  if (!aChannel || !aDoc ||
      !StaticPrefs::dom_prototype_document_cache_enabled()) {
    return false;
  }
  return nsContentUtils::IsChromeDoc(aDoc);
}

nsresult nsHTMLDocument::StartDocumentLoad(
    const char* aCommand, nsIChannel* aChannel, nsILoadGroup* aLoadGroup,
    nsISupports* aContainer, nsIStreamListener** aDocListener, bool aReset) {
  if (!aCommand) {
    MOZ_ASSERT(false, "Command is mandatory");
    return NS_ERROR_INVALID_POINTER;
  }
  if (mType != eHTML) {
    MOZ_ASSERT(mType == eXHTML);
    MOZ_ASSERT(false, "Must not set HTML doc to XHTML mode before load start.");
    return NS_ERROR_DOM_INVALID_STATE_ERR;
  }

  nsAutoCString contentType;
  aChannel->GetContentType(contentType);

  bool view =
      !strcmp(aCommand, "view") || !strcmp(aCommand, "external-resource");
  mViewSource = !strcmp(aCommand, "view-source");
  bool asData = !strcmp(aCommand, kLoadAsData);
  if (!(view || mViewSource || asData)) {
    MOZ_ASSERT(false, "Bad parser command");
    return NS_ERROR_INVALID_ARG;
  }

  bool html = contentType.EqualsLiteral(TEXT_HTML);
  bool xhtml = !html && (contentType.EqualsLiteral(APPLICATION_XHTML_XML) ||
                         contentType.EqualsLiteral(APPLICATION_WAPXHTML_XML));
  mIsPlainText =
      !html && !xhtml && nsContentUtils::IsPlainTextType(contentType);
  if (!(html || xhtml || mIsPlainText || mViewSource)) {
    MOZ_ASSERT(false, "Channel with bad content type.");
    return NS_ERROR_INVALID_ARG;
  }

  bool forceUtf8 =
      mIsPlainText && nsContentUtils::IsUtf8OnlyPlainTextType(contentType);

  bool loadAsHtml5 = true;

  if (!mViewSource && xhtml) {
    // We're parsing XHTML as XML, remember that.
    mType = eXHTML;
    SetCompatibilityMode(eCompatibility_FullStandards);
    loadAsHtml5 = false;
  }

  nsresult rv = Document::StartDocumentLoad(aCommand, aChannel, aLoadGroup,
                                            aContainer, aDocListener, aReset);
  if (NS_FAILED(rv)) {
    return rv;
  }

  nsCOMPtr<nsIURI> uri;
  rv = aChannel->GetURI(getter_AddRefs(uri));
  if (NS_FAILED(rv)) {
    return rv;
  }

  nsCOMPtr<nsIDocShell> docShell(do_QueryInterface(aContainer));

  bool loadWithPrototype = false;
  RefPtr<nsHtml5Parser> html5Parser;
  if (loadAsHtml5) {
    html5Parser = nsHtml5Module::NewHtml5Parser();
    mParser = html5Parser;
    if (mIsPlainText) {
      if (mViewSource) {
        html5Parser->MarkAsNotScriptCreated("view-source-plain");
      } else {
        html5Parser->MarkAsNotScriptCreated("plain-text");
      }
    } else if (mViewSource && !html) {
      html5Parser->MarkAsNotScriptCreated("view-source-xml");
    } else if (view && NS_IsAboutBlank(uri)) {
      // Sadness: There are Chromium-originating WPTs that assume that
      // as soon as `iframe.contentWindow.location.href == "about:blank"`,
      // the about:blank DOM exists even for _non-initial_ navigations to
      // about:blank. Since Chromium-originating WPTs manage to expect this,
      // chances are that Web content might expect this as well, and the
      // expectation was valid in Gecko previously. Therefore, let's
      // special-case even _non-initial_ about:blank.
      // /content-security-policy/inheritance/history-iframe.sub.html
      // /content-security-policy/inheritance/window-open-local-after-network-scheme.sub.html
      html5Parser->MarkAsNotScriptCreated("about-blank");
    } else {
      html5Parser->MarkAsNotScriptCreated(aCommand);
    }
  } else if (xhtml && ShouldUsePrototypeDocument(aChannel, this)) {
    loadWithPrototype = true;
    nsCOMPtr<nsIURI> originalURI;
    aChannel->GetOriginalURI(getter_AddRefs(originalURI));
    mParser = new mozilla::parser::PrototypeDocumentParser(originalURI, this);
  } else {
    mParser = new nsParser();
  }

  // Look for the parent document.  Note that at this point we don't have our
  // content viewer set up yet, and therefore do not have a useful
  // mParentDocument.

  // in this block of code, if we get an error result, we return it
  // but if we get a null pointer, that's perfectly legal for parent
  // and parentViewer
  nsCOMPtr<nsIDocShellTreeItem> parentAsItem;
  if (docShell) {
    docShell->GetInProcessSameTypeParent(getter_AddRefs(parentAsItem));
  }

  nsCOMPtr<nsIDocShell> parent(do_QueryInterface(parentAsItem));
  nsCOMPtr<nsIDocumentViewer> parentViewer;
  if (parent) {
    rv = parent->GetDocViewer(getter_AddRefs(parentViewer));
    NS_ENSURE_SUCCESS(rv, rv);
  }

  nsCOMPtr<nsIDocumentViewer> viewer;
  if (docShell) {
    docShell->GetDocViewer(getter_AddRefs(viewer));
  }
  if (!viewer) {
    viewer = std::move(parentViewer);
  }

  nsAutoCString urlSpec;
  uri->GetSpec(urlSpec);
#ifdef DEBUG_charset
  printf("Determining charset for %s\n", urlSpec.get());
#endif

  // These are the charset source and charset for our document
  bool forceAutoDetection = false;
  int32_t charsetSource = kCharsetUninitialized;
  auto encoding = UTF_8_ENCODING;

  // For error reporting and referrer policy setting
  nsHtml5TreeOpExecutor* executor = nullptr;
  if (loadAsHtml5) {
    executor = static_cast<nsHtml5TreeOpExecutor*>(mParser->GetContentSink());
  }

  if (forceUtf8) {
    charsetSource = kCharsetFromUtf8OnlyMime;
  } else if (!IsHTMLDocument() || !docShell) {  // no docshell for text/html XHR
    charsetSource =
        IsHTMLDocument() ? kCharsetFromFallback : kCharsetFromDocTypeDefault;
    TryChannelCharset(aChannel, charsetSource, encoding, executor);
  } else {
    NS_ASSERTION(docShell, "Unexpected null value");

    // The following will try to get the character encoding from various
    // sources. Each Try* function will return early if the source is already
    // at least as large as any of the sources it might look at.  Some of
    // these functions (like TryReloadCharset and TryParentCharset) can set
    // charsetSource to various values depending on where the charset they
    // end up finding originally comes from.

    // Try the channel's charset (e.g., charset from HTTP
    // "Content-Type" header) first. This way, we get to reject overrides in
    // TryParentCharset and TryUserForcedCharset if the channel said UTF-16.
    // This is to avoid socially engineered XSS by adding user-supplied
    // content to a UTF-16 site such that the byte have a dangerous
    // interpretation as ASCII and the user can be lured to using the
    // charset menu.
    TryChannelCharset(aChannel, charsetSource, encoding, executor);

    TryUserForcedCharset(viewer, docShell, charsetSource, encoding,
                         forceAutoDetection);

    TryReloadCharset(viewer, charsetSource, encoding);  // For encoding reload
    TryParentCharset(docShell, charsetSource, encoding, forceAutoDetection);
  }

  SetDocumentCharacterSetSource(charsetSource);
  SetDocumentCharacterSet(encoding);

  // Set the parser as the stream listener for the document loader...
  rv = NS_OK;
  nsCOMPtr<nsIStreamListener> listener = mParser->GetStreamListener();
  listener.forget(aDocListener);

#ifdef DEBUG_charset
  printf(" charset = %s source %d\n", charset.get(), charsetSource);
#endif
  mParser->SetDocumentCharset(encoding, charsetSource, forceAutoDetection);
  mParser->SetCommand(aCommand);

  if (!IsHTMLDocument()) {
    MOZ_ASSERT(!loadAsHtml5);
    if (loadWithPrototype) {
      nsCOMPtr<nsIContentSink> sink;
      NS_NewPrototypeDocumentContentSink(getter_AddRefs(sink), this, uri,
                                         docShell, aChannel);
      mParser->SetContentSink(sink);
    } else {
      nsCOMPtr<nsIXMLContentSink> xmlsink;
      NS_NewXMLContentSink(getter_AddRefs(xmlsink), this, uri, docShell,
                           aChannel);
      mParser->SetContentSink(xmlsink);
    }
  } else {
    MOZ_ASSERT(loadAsHtml5);
    html5Parser->Initialize(this, uri, docShell, aChannel);
  }

  // parser the content of the URI
  mParser->Parse(uri);

  return rv;
}

bool nsHTMLDocument::UseWidthDeviceWidthFallbackViewport() const {
  if (mIsPlainText) {
    // Plain text documents are simple enough that font inflation doesn't offer
    // any appreciable advantage over defaulting to "width=device-width" and
    // subsequently turning on word-wrapping.
    return true;
  }
  return Document::UseWidthDeviceWidthFallbackViewport();
}

Element* nsHTMLDocument::GetUnfocusedKeyEventTarget() {
  if (nsGenericHTMLElement* body = GetBody()) {
    return body;
  }
  return Document::GetUnfocusedKeyEventTarget();
}

bool nsHTMLDocument::IsRegistrableDomainSuffixOfOrEqualTo(
    const nsAString& aHostSuffixString, const nsACString& aOrigHost) {
  // https://html.spec.whatwg.org/multipage/browsers.html#is-a-registrable-domain-suffix-of-or-is-equal-to
  if (aHostSuffixString.IsEmpty()) {
    return false;
  }

  nsCOMPtr<nsIURI> origURI = CreateInheritingURIForHost(aOrigHost);
  if (!origURI) {
    // Error: failed to parse input domain
    return false;
  }

  nsCOMPtr<nsIURI> newURI =
      RegistrableDomainSuffixOfInternal(aHostSuffixString, origURI);
  if (!newURI) {
    // Error: illegal domain
    return false;
  }
  return true;
}

void nsHTMLDocument::AddedForm() { ++mNumForms; }

void nsHTMLDocument::RemovedForm() { --mNumForms; }

int32_t nsHTMLDocument::GetNumFormsSynchronous() const { return mNumForms; }

// https://html.spec.whatwg.org/multipage/dom.html#dom-document-nameditem
void nsHTMLDocument::NamedGetter(JSContext* aCx, const nsAString& aName,
                                 bool& aFound,
                                 JS::MutableHandle<JSObject*> aRetVal,
                                 mozilla::ErrorResult& aRv) {
  if (!StaticPrefs::dom_document_name_getter_follow_spec_enabled()) {
    JS::Rooted<JS::Value> v(aCx);
    if ((aFound = ResolveNameForWindow(aCx, aName, &v, aRv))) {
      SetUseCounter(mozilla::eUseCounter_custom_HTMLDocumentNamedGetterHit);
      aRetVal.set(v.toObjectOrNull());
    }
    return;
  }

  aFound = false;
  aRetVal.set(nullptr);

  // Step 1. Let elements be the list of named elements with the name name that
  // are in a document tree with the Document as their root.
  IdentifierMapEntry* entry = mIdentifierMap.GetEntry(aName);
  if (!entry) {
    return;
  }

  BaseContentList* list = entry->GetDocumentNameContentList();
  if (!list || list->Length() == 0) {
    return;
  }

  JS::Rooted<JS::Value> v(aCx);
  if (list->Length() == 1) {
    nsIContent* element = list->Item(0);
    if (auto iframe = HTMLIFrameElement::FromNode(element)) {
      // Step 2. If elements has only one element, and that element is an iframe
      // element, and that iframe element's content navigable is not null, then
      // return the active WindowProxy of the element's content navigable.
      Nullable<WindowProxyHolder> win = iframe->GetContentWindow();
      if (win.IsNull()) {
        return;
      }

      if (!ToJSValue(aCx, win.Value(), &v)) {
        aRv.NoteJSContextException(aCx);
        return;
      }

      if (v.isNullOrUndefined()) {
        return;
      }
    } else {
      // Step 3. Otherwise, if elements has only one element, return that
      // element.
      if (!ToJSValue(aCx, element, &v)) {
        aRv.NoteJSContextException(aCx);
        return;
      }
    }
  } else {
    // Step 4. Otherwise, return an HTMLCollection rooted at the Document node,
    // whose filter matches only named elements with the name name.
    if (!ToJSValue(aCx, list, &v)) {
      aRv.NoteJSContextException(aCx);
      return;
    }
  }

  bool collect = false;
#ifdef NIGHTLY_BUILD
  bool preventShadowing = false;
  if (StaticPrefs::dom_document_name_getter_prevent_shadowing_enabled()) {
    if (HTMLDocument_Binding::InterfaceHasProperty(aName)) {
      preventShadowing = true;
      collect = mShadowedHTMLDocumentProperties.Length() <= 10;
    }
  } else
#endif
  {
    // To limit the possible performance/memory impact, only collect at most 10
    // properties.
    collect = mShadowedHTMLDocumentProperties.Length() <= 10 &&
              HTMLDocument_Binding::InterfaceHasProperty(aName);
  }

  if (collect) {
    if (!mShadowedHTMLDocumentProperties.Contains(aName)) {
      mShadowedHTMLDocumentProperties.AppendElement(aName);
    }
  }

#ifdef NIGHTLY_BUILD
  if (preventShadowing) {
    AutoTArray<nsString, 1> params;
    params.AppendElement(aName);
    nsContentUtils::ReportToConsole(nsIScriptError::warningFlag, "DOM"_ns, this,
                                    PropertiesFile::DOM_PROPERTIES,
                                    "DocumentShadowingBlockedWarning", params);
    return;
  }
#endif

  SetUseCounter(mozilla::eUseCounter_custom_HTMLDocumentNamedGetterHit);
  aFound = true;
  aRetVal.set(&v.toObject());
}

void nsHTMLDocument::GetSupportedNames(nsTArray<nsString>& aNames) {
  if (!StaticPrefs::dom_document_name_getter_follow_spec_enabled()) {
    GetSupportedNamesForWindow(aNames);
    return;
  }

  for (const auto& entry : mIdentifierMap) {
    if (entry.HasDocumentNameElement()) {
      aNames.AppendElement(entry.GetKeyAsString());
    }
  }
}

bool nsHTMLDocument::ResolveNameForWindow(JSContext* aCx,
                                          const nsAString& aName,
                                          JS::MutableHandle<JS::Value> aRetval,
                                          ErrorResult& aError) {
  IdentifierMapEntry* entry = mIdentifierMap.GetEntry(aName);
  if (!entry) {
    return false;
  }

  BaseContentList* list = entry->GetNameContentList();
  uint32_t length = list ? list->Length() : 0;

  nsIContent* node;
  if (length > 0) {
    if (length > 1) {
      // The list contains more than one element, return the whole list.
      if (!ToJSValue(aCx, list, aRetval)) {
        aError.NoteJSContextException(aCx);
        return false;
      }
      return true;
    }

    // Only one element in the list, return the element instead of returning
    // the list.
    node = list->Item(0);
  } else {
    // No named items were found, see if there's one registerd by id for aName.
    Element* e = entry->GetIdElement();

    if (!e || !nsGenericHTMLElement::ShouldExposeIdAsHTMLDocumentProperty(e)) {
      return false;
    }

    node = e;
  }

  if (!ToJSValue(aCx, node, aRetval)) {
    aError.NoteJSContextException(aCx);
    return false;
  }

  return true;
}

void nsHTMLDocument::GetSupportedNamesForWindow(nsTArray<nsString>& aNames) {
  for (const auto& entry : mIdentifierMap) {
    if (entry.HasNameElement() ||
        entry.HasIdElementExposedAsHTMLDocumentProperty()) {
      aNames.AppendElement(entry.GetKeyAsString());
    }
  }
}

//----------------------------

// forms related stuff

bool nsHTMLDocument::MatchFormControls(Element* aElement, int32_t aNamespaceID,
                                       nsAtom* aAtom, void* aData) {
  return aElement->IsHTMLFormControlElement();
}

nsresult nsHTMLDocument::Clone(dom::NodeInfo* aNodeInfo,
                               nsINode** aResult) const {
  NS_ASSERTION(aNodeInfo->NodeInfoManager() == mNodeInfoManager,
               "Can't import this document into another document!");

  RefPtr<nsHTMLDocument> clone = new nsHTMLDocument(LoadedAsData::AsData);
  nsresult rv = CloneDocHelper(clone.get());
  NS_ENSURE_SUCCESS(rv, rv);

  // State from nsHTMLDocument
  clone->mLoadFlags = mLoadFlags;

  clone.forget(aResult);
  return NS_OK;
}

/* virtual */
void nsHTMLDocument::DocAddSizeOfExcludingThis(
    nsWindowSizes& aWindowSizes) const {
  Document::DocAddSizeOfExcludingThis(aWindowSizes);

  // Measurement of the following members may be added later if DMD finds it is
  // worthwhile:
  // - mLinks
  // - mAnchors
}

bool nsHTMLDocument::IsAsciiCompatible(const Encoding* aEncoding) {
  return aEncoding->IsAsciiCompatible() ||
         (aEncoding == ISO_2022_JP_ENCODING &&
          !GetContentTypeInternal().EqualsLiteral("text/html"));
}

bool nsHTMLDocument::WillIgnoreCharsetOverride() {
  if (mEncodingMenuDisabled) {
    return true;
  }
  if (mType != eHTML) {
    MOZ_ASSERT(mType == eXHTML);
    return true;
  }
  if (mCharacterSetSource >= kCharsetFromByteOrderMark) {
    return true;
  }
  if (!mCharacterSet->IsAsciiCompatible() &&
      mCharacterSet != ISO_2022_JP_ENCODING) {
    return true;
  }
  if (mCharacterSet == ISO_2022_JP_ENCODING) {
    // This, unfortunately, isn't exactly the same check as in the parser.
    if (GetContentTypeInternal().EqualsLiteral("text/html")) {
      return true;
    }
  }
  nsIURI* uri = GetOriginalURI();
  if (uri) {
    if (uri->SchemeIs("about")) {
      return true;
    }
    bool isResource;
    nsresult rv = NS_URIChainHasFlags(
        uri, nsIProtocolHandler::URI_IS_UI_RESOURCE, &isResource);
    if (NS_FAILED(rv) || isResource) {
      return true;
    }
  }

  switch (mCharacterSetSource) {
    case kCharsetUninitialized:
    case kCharsetFromFallback:
    case kCharsetFromDocTypeDefault:
    case kCharsetFromInitialAutoDetectionWouldHaveBeenUTF8:
    case kCharsetFromInitialAutoDetectionWouldNotHaveBeenUTF8DependedOnTLD:
    case kCharsetFromFinalAutoDetectionWouldHaveBeenUTF8InitialWasASCII:
    case kCharsetFromFinalAutoDetectionWouldNotHaveBeenUTF8DependedOnTLD:
    case kCharsetFromParentFrame:
    case kCharsetFromXmlDeclaration:
    case kCharsetFromMetaTag:
    case kCharsetFromChannel:
      return false;
  }

  bool potentialEffect = false;
  nsIPrincipal* parentPrincipal = NodePrincipal();

  auto subDoc = [&potentialEffect, parentPrincipal](Document& aSubDoc) {
    if (parentPrincipal->Equals(aSubDoc.NodePrincipal()) &&
        !aSubDoc.WillIgnoreCharsetOverride()) {
      potentialEffect = true;
      return CallState::Stop;
    }
    return CallState::Continue;
  };
  EnumerateSubDocuments(subDoc);

  return !potentialEffect;
}

class nsHTMLDocument::ContentListHolder : public mozilla::Runnable {
 public:
  ContentListHolder(nsHTMLDocument* aDocument,
                    mozilla::dom::ContentList* aFormList,
                    mozilla::dom::ContentList* aFormControlList)
      : mozilla::Runnable("ContentListHolder"),
        mDocument(aDocument),
        mFormList(aFormList),
        mFormControlList(aFormControlList) {}

  ~ContentListHolder() {
    MOZ_ASSERT(!mDocument->mContentListHolder ||
               mDocument->mContentListHolder == this);
    mDocument->mContentListHolder = nullptr;
  }

  RefPtr<nsHTMLDocument> mDocument;
  RefPtr<mozilla::dom::ContentList> mFormList;
  RefPtr<mozilla::dom::ContentList> mFormControlList;
};

void nsHTMLDocument::GetFormsAndFormControls(ContentList** aFormList,
                                             ContentList** aFormControlList) {
  RefPtr<ContentListHolder> holder = mContentListHolder;
  if (!holder) {
    RefPtr<ContentList> htmlForms = GetExistingForms();
    if (!htmlForms) {
      // If the document doesn't have an existing forms content list, create a
      // new one which will be released soon by ContentListHolder.  The idea is
      // that we don't have that list hanging around for a long time and slowing
      // down future DOM mutations.
      //
      // Please keep this in sync with Document::Forms().
      htmlForms = new ContentList(this, kNameSpaceID_XHTML, nsGkAtoms::form,
                                  nsGkAtoms::form,
                                  /* aDeep = */ true,
                                  /* aLiveList = */ true);
    }

    RefPtr htmlFormControls = new ContentList(
        this, nsHTMLDocument::MatchFormControls, nullptr, nullptr,
        /* aDeep = */ true,
        /* aMatchAtom = */ nullptr,
        /* aMatchNameSpaceId = */ kNameSpaceID_None,
        /* aFuncMayDependOnAttr = */ true,
        /* aLiveList = */ true);

    holder = new ContentListHolder(this, htmlForms, htmlFormControls);
    RefPtr<ContentListHolder> runnable = holder;
    if (NS_SUCCEEDED(Dispatch(runnable.forget()))) {
      mContentListHolder = holder;
    }
  }

  NS_ADDREF(*aFormList = holder->mFormList);
  NS_ADDREF(*aFormControlList = holder->mFormControlList);
}
