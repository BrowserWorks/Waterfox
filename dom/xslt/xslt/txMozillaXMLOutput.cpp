/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "txMozillaXMLOutput.h"

#include "mozilla/dom/Document.h"
#include "nsIDocShell.h"
#include "nsIScriptElement.h"
#include "nsCharsetSource.h"
#include "nsIRefreshURI.h"
#include "nsPIDOMWindow.h"
#include "nsIContent.h"
#include "nsContentCID.h"
#include "nsUnicharUtils.h"
#include "nsGkAtoms.h"
#include "txLog.h"
#include "nsNameSpaceManager.h"
#include "txStringUtils.h"
#include "txURIUtils.h"
#include "nsIDocumentTransformer.h"
#include "mozilla/StyleSheetInlines.h"
#include "mozilla/css/Loader.h"
#include "mozilla/dom/DocumentType.h"
#include "mozilla/dom/DocumentFragment.h"
#include "mozilla/dom/Element.h"
#include "mozilla/dom/ScriptLoader.h"
#include "mozilla/Encoding.h"
#include "nsContentUtils.h"
#include "nsDocElementCreatedNotificationRunner.h"
#include "txXMLUtils.h"
#include "nsContentSink.h"
#include "nsINode.h"
#include "nsContentCreatorFunctions.h"
#include "nsError.h"
#include "nsIFrame.h"
#include <algorithm>
#include "nsTextNode.h"
#include "mozilla/dom/Comment.h"
#include "mozilla/dom/ProcessingInstruction.h"

using namespace mozilla;
using namespace mozilla::dom;

#define TX_ENSURE_CURRENTNODE                            \
  NS_ASSERTION(mCurrentNode, "mCurrentNode is nullptr"); \
  if (!mCurrentNode) return NS_ERROR_UNEXPECTED

txMozillaXMLOutput::txMozillaXMLOutput(txOutputFormat* aFormat,
                                       nsITransformObserver* aObserver)
    : mTreeDepth(0),
      mBadChildLevel(0),
      mTableState(NORMAL),
      mCreatingNewDocument(true),
      mOpenedElementIsHTML(false),
      mRootContentCreated(false),
      mNoFixup(false) {
  MOZ_COUNT_CTOR(txMozillaXMLOutput);
  if (aObserver) {
    mNotifier = new txTransformNotifier();
    if (mNotifier) {
      mNotifier->Init(aObserver);
    }
  }

  mOutputFormat.merge(*aFormat);
  mOutputFormat.setFromDefaults();
}

txMozillaXMLOutput::txMozillaXMLOutput(txOutputFormat* aFormat,
                                       DocumentFragment* aFragment,
                                       bool aNoFixup)
    : mTreeDepth(0),
      mBadChildLevel(0),
      mTableState(NORMAL),
      mCreatingNewDocument(false),
      mOpenedElementIsHTML(false),
      mRootContentCreated(false),
      mNoFixup(aNoFixup) {
  MOZ_COUNT_CTOR(txMozillaXMLOutput);
  mOutputFormat.merge(*aFormat);
  mOutputFormat.setFromDefaults();

  mCurrentNode = aFragment;
  mDocument = mCurrentNode->OwnerDoc();
  mNodeInfoManager = mDocument->NodeInfoManager();
}

txMozillaXMLOutput::~txMozillaXMLOutput() {
  MOZ_COUNT_DTOR(txMozillaXMLOutput);
}

nsresult txMozillaXMLOutput::attribute(nsAtom* aPrefix, nsAtom* aLocalName,
                                       nsAtom* aLowercaseLocalName,
                                       const int32_t aNsID,
                                       const nsString& aValue) {
  RefPtr<nsAtom> owner;
  if (mOpenedElementIsHTML && aNsID == kNameSpaceID_None) {
    if (aLowercaseLocalName) {
      aLocalName = aLowercaseLocalName;
    } else {
      owner = TX_ToLowerCaseAtom(aLocalName);
      NS_ENSURE_TRUE(owner, NS_ERROR_OUT_OF_MEMORY);

      aLocalName = owner;
    }
  }

  return attributeInternal(aPrefix, aLocalName, aNsID, aValue);
}

nsresult txMozillaXMLOutput::attribute(nsAtom* aPrefix,
                                       const nsAString& aLocalName,
                                       const int32_t aNsID,
                                       const nsString& aValue) {
  RefPtr<nsAtom> lname;

  if (mOpenedElementIsHTML && aNsID == kNameSpaceID_None) {
    nsAutoString lnameStr;
    nsContentUtils::ASCIIToLower(aLocalName, lnameStr);
    lname = NS_Atomize(lnameStr);
  } else {
    lname = NS_Atomize(aLocalName);
  }

  NS_ENSURE_TRUE(lname, NS_ERROR_OUT_OF_MEMORY);

  // Check that it's a valid name
  if (!nsContentUtils::IsValidNodeName(lname, aPrefix, aNsID)) {
    // Try without prefix
    aPrefix = nullptr;
    if (!nsContentUtils::IsValidNodeName(lname, aPrefix, aNsID)) {
      // Don't return error here since the callers don't deal
      return NS_OK;
    }
  }

  return attributeInternal(aPrefix, lname, aNsID, aValue);
}

nsresult txMozillaXMLOutput::attributeInternal(nsAtom* aPrefix,
                                               nsAtom* aLocalName,
                                               int32_t aNsID,
                                               const nsString& aValue) {
  if (!mOpenedElement) {
    // XXX Signal this? (can't add attributes after element closed)
    return NS_OK;
  }

  NS_ASSERTION(!mBadChildLevel, "mBadChildLevel set when element is opened");

  return mOpenedElement->SetAttr(aNsID, aLocalName, aPrefix, aValue, false);
}

nsresult txMozillaXMLOutput::characters(const nsAString& aData, bool aDOE) {
  nsresult rv = closePrevious(false);
  NS_ENSURE_SUCCESS(rv, rv);

  if (!mBadChildLevel) {
    mText.Append(aData);
  }

  return NS_OK;
}

nsresult txMozillaXMLOutput::comment(const nsString& aData) {
  nsresult rv = closePrevious(true);
  NS_ENSURE_SUCCESS(rv, rv);

  if (mBadChildLevel) {
    return NS_OK;
  }

  TX_ENSURE_CURRENTNODE;

  RefPtr<Comment> comment = new (mNodeInfoManager) Comment(mNodeInfoManager);

  rv = comment->SetText(aData, false);
  NS_ENSURE_SUCCESS(rv, rv);

  return mCurrentNode->AppendChildTo(comment, true);
}

nsresult txMozillaXMLOutput::endDocument(nsresult aResult) {
  TX_ENSURE_CURRENTNODE;

  if (NS_FAILED(aResult)) {
    if (mNotifier) {
      mNotifier->OnTransformEnd(aResult);
    }

    return NS_OK;
  }

  nsresult rv = closePrevious(true);
  if (NS_FAILED(rv)) {
    if (mNotifier) {
      mNotifier->OnTransformEnd(rv);
    }

    return rv;
  }

  if (mCreatingNewDocument) {
    // This should really be handled by Document::EndLoad
    MOZ_ASSERT(mDocument->GetReadyStateEnum() == Document::READYSTATE_LOADING,
               "Bad readyState");
    mDocument->SetReadyStateInternal(Document::READYSTATE_INTERACTIVE);
    if (ScriptLoader* loader = mDocument->ScriptLoader()) {
      loader->ParsingComplete(false);
    }
  }

  if (!mRefreshString.IsEmpty()) {
    nsPIDOMWindowOuter* win = mDocument->GetWindow();
    if (win) {
      nsCOMPtr<nsIRefreshURI> refURI = do_QueryInterface(win->GetDocShell());
      if (refURI) {
        refURI->SetupRefreshURIFromHeader(
            mDocument->GetDocBaseURI(), mDocument->NodePrincipal(),
            mDocument->InnerWindowID(), mRefreshString);
      }
    }
  }

  if (mNotifier) {
    mNotifier->OnTransformEnd();
  }

  return NS_OK;
}

nsresult txMozillaXMLOutput::endElement() {
  TX_ENSURE_CURRENTNODE;

  if (mBadChildLevel) {
    --mBadChildLevel;
    MOZ_LOG(txLog::xslt, LogLevel::Debug,
            ("endElement, mBadChildLevel = %d\n", mBadChildLevel));
    return NS_OK;
  }

  --mTreeDepth;

  nsresult rv = closePrevious(true);
  NS_ENSURE_SUCCESS(rv, rv);

  NS_ASSERTION(mCurrentNode->IsElement(), "borked mCurrentNode");
  NS_ENSURE_TRUE(mCurrentNode->IsElement(), NS_ERROR_UNEXPECTED);

  Element* element = mCurrentNode->AsElement();

  // Handle html-elements
  if (!mNoFixup) {
    if (element->IsHTMLElement()) {
      rv = endHTMLElement(element);
      NS_ENSURE_SUCCESS(rv, rv);
    }

    // Handle elements that are different when parser-created
    if (nsIContent::RequiresDoneCreatingElement(
            element->NodeInfo()->NamespaceID(),
            element->NodeInfo()->NameAtom())) {
      element->DoneCreatingElement();
    } else if (element->IsSVGElement(nsGkAtoms::script) ||
               element->IsHTMLElement(nsGkAtoms::script)) {
      nsCOMPtr<nsIScriptElement> sele = do_QueryInterface(element);
      if (sele) {
        bool block = sele->AttemptToExecute();
        // If the act of insertion evaluated the script, we're fine.
        // Else, add this script element to the array of loading scripts.
        if (block) {
          rv = mNotifier->AddScriptElement(sele);
          NS_ENSURE_SUCCESS(rv, rv);
        }
      } else {
        MOZ_ASSERT(nsNameSpaceManager::GetInstance()->mSVGDisabled,
                   "Script elements need to implement nsIScriptElement and SVG "
                   "wasn't disabled.");
      }
    } else if (nsIContent::RequiresDoneAddingChildren(
                   element->NodeInfo()->NamespaceID(),
                   element->NodeInfo()->NameAtom())) {
      element->DoneAddingChildren(true);
    }
  }

  if (mCreatingNewDocument) {
    // Handle all sorts of stylesheets
    if (auto* linkStyle = LinkStyle::FromNode(*mCurrentNode)) {
      linkStyle->SetEnableUpdates(true);
      auto updateOrError = linkStyle->UpdateStyleSheet(mNotifier);
      if (mNotifier && updateOrError.isOk() &&
          updateOrError.unwrap().ShouldBlock()) {
        mNotifier->AddPendingStylesheet();
      }
    }
  }

  // Add the element to the tree if it wasn't added before and take one step
  // up the tree
  uint32_t last = mCurrentNodeStack.Count() - 1;
  NS_ASSERTION(last != (uint32_t)-1, "empty stack");

  nsCOMPtr<nsINode> parent = mCurrentNodeStack.SafeObjectAt(last);
  mCurrentNodeStack.RemoveObjectAt(last);

  if (mCurrentNode == mNonAddedNode) {
    if (parent == mDocument) {
      NS_ASSERTION(!mRootContentCreated,
                   "Parent to add to shouldn't be a document if we "
                   "have a root content");
      mRootContentCreated = true;
    }

    // Check to make sure that script hasn't inserted the node somewhere
    // else in the tree
    if (!mCurrentNode->GetParentNode()) {
      parent->AppendChildTo(mNonAddedNode, true);
    }
    mNonAddedNode = nullptr;
  }

  mCurrentNode = parent;

  mTableState =
      static_cast<TableState>(NS_PTR_TO_INT32(mTableStateStack.pop()));

  return NS_OK;
}

void txMozillaXMLOutput::getOutputDocument(Document** aDocument) {
  NS_IF_ADDREF(*aDocument = mDocument);
}

nsresult txMozillaXMLOutput::processingInstruction(const nsString& aTarget,
                                                   const nsString& aData) {
  nsresult rv = closePrevious(true);
  NS_ENSURE_SUCCESS(rv, rv);

  if (mOutputFormat.mMethod == eHTMLOutput) return NS_OK;

  TX_ENSURE_CURRENTNODE;

  rv = nsContentUtils::CheckQName(aTarget, false);
  NS_ENSURE_SUCCESS(rv, rv);

  nsCOMPtr<nsIContent> pi =
      NS_NewXMLProcessingInstruction(mNodeInfoManager, aTarget, aData);

  LinkStyle* linkStyle = nullptr;
  if (mCreatingNewDocument) {
    linkStyle = LinkStyle::FromNode(*pi);
    if (linkStyle) {
      linkStyle->SetEnableUpdates(false);
    }
  }

  rv = mCurrentNode->AppendChildTo(pi, true);
  NS_ENSURE_SUCCESS(rv, rv);

  if (linkStyle) {
    linkStyle->SetEnableUpdates(true);
    auto updateOrError = linkStyle->UpdateStyleSheet(mNotifier);
    if (mNotifier && updateOrError.isOk() &&
        updateOrError.unwrap().ShouldBlock()) {
      mNotifier->AddPendingStylesheet();
    }
  }

  return NS_OK;
}

nsresult txMozillaXMLOutput::startDocument() {
  if (mNotifier) {
    mNotifier->OnTransformStart();
  }

  if (mCreatingNewDocument) {
    ScriptLoader* loader = mDocument->ScriptLoader();
    if (loader) {
      loader->BeginDeferringScripts();
    }
  }

  return NS_OK;
}

nsresult txMozillaXMLOutput::startElement(nsAtom* aPrefix, nsAtom* aLocalName,
                                          nsAtom* aLowercaseLocalName,
                                          const int32_t aNsID) {
  MOZ_ASSERT(aNsID != kNameSpaceID_None || !aPrefix,
             "Can't have prefix without namespace");

  if (mOutputFormat.mMethod == eHTMLOutput && aNsID == kNameSpaceID_None) {
    RefPtr<nsAtom> owner;
    if (!aLowercaseLocalName) {
      owner = TX_ToLowerCaseAtom(aLocalName);
      NS_ENSURE_TRUE(owner, NS_ERROR_OUT_OF_MEMORY);

      aLowercaseLocalName = owner;
    }
    return startElementInternal(nullptr, aLowercaseLocalName,
                                kNameSpaceID_XHTML);
  }

  return startElementInternal(aPrefix, aLocalName, aNsID);
}

nsresult txMozillaXMLOutput::startElement(nsAtom* aPrefix,
                                          const nsAString& aLocalName,
                                          const int32_t aNsID) {
  int32_t nsId = aNsID;
  RefPtr<nsAtom> lname;

  if (mOutputFormat.mMethod == eHTMLOutput && aNsID == kNameSpaceID_None) {
    nsId = kNameSpaceID_XHTML;

    nsAutoString lnameStr;
    nsContentUtils::ASCIIToLower(aLocalName, lnameStr);
    lname = NS_Atomize(lnameStr);
  } else {
    lname = NS_Atomize(aLocalName);
  }

  // No biggie if we lose the prefix due to OOM
  NS_ENSURE_TRUE(lname, NS_ERROR_OUT_OF_MEMORY);

  // Check that it's a valid name
  if (!nsContentUtils::IsValidNodeName(lname, aPrefix, nsId)) {
    // Try without prefix
    aPrefix = nullptr;
    if (!nsContentUtils::IsValidNodeName(lname, aPrefix, nsId)) {
      return NS_ERROR_XSLT_BAD_NODE_NAME;
    }
  }

  return startElementInternal(aPrefix, lname, nsId);
}

nsresult txMozillaXMLOutput::startElementInternal(nsAtom* aPrefix,
                                                  nsAtom* aLocalName,
                                                  int32_t aNsID) {
  TX_ENSURE_CURRENTNODE;

  if (mBadChildLevel) {
    ++mBadChildLevel;
    MOZ_LOG(txLog::xslt, LogLevel::Debug,
            ("startElement, mBadChildLevel = %d\n", mBadChildLevel));
    return NS_OK;
  }

  nsresult rv = closePrevious(true);
  NS_ENSURE_SUCCESS(rv, rv);

  // Push and init state
  if (mTreeDepth == MAX_REFLOW_DEPTH) {
    // eCloseElement couldn't add the parent so we fail as well or we've
    // reached the limit of the depth of the tree that we allow.
    ++mBadChildLevel;
    MOZ_LOG(txLog::xslt, LogLevel::Debug,
            ("startElement, mBadChildLevel = %d\n", mBadChildLevel));
    return NS_OK;
  }

  ++mTreeDepth;

  rv = mTableStateStack.push(NS_INT32_TO_PTR(mTableState));
  NS_ENSURE_SUCCESS(rv, rv);

  if (!mCurrentNodeStack.AppendObject(mCurrentNode)) {
    return NS_ERROR_OUT_OF_MEMORY;
  }

  mTableState = NORMAL;
  mOpenedElementIsHTML = false;

  // Create the element
  RefPtr<NodeInfo> ni = mNodeInfoManager->GetNodeInfo(
      aLocalName, aPrefix, aNsID, nsINode::ELEMENT_NODE);

  NS_NewElement(getter_AddRefs(mOpenedElement), ni.forget(),
                mCreatingNewDocument ? FROM_PARSER_XSLT : FROM_PARSER_FRAGMENT);

  // Set up the element and adjust state
  if (!mNoFixup) {
    if (aNsID == kNameSpaceID_XHTML) {
      mOpenedElementIsHTML = (mOutputFormat.mMethod == eHTMLOutput);
      rv = startHTMLElement(mOpenedElement, mOpenedElementIsHTML);
      NS_ENSURE_SUCCESS(rv, rv);
    }
  }

  if (mCreatingNewDocument) {
    // Handle all sorts of stylesheets
    if (auto* linkStyle = LinkStyle::FromNodeOrNull(mOpenedElement)) {
      linkStyle->SetEnableUpdates(false);
    }
  }

  return NS_OK;
}

nsresult txMozillaXMLOutput::closePrevious(bool aFlushText) {
  TX_ENSURE_CURRENTNODE;

  nsresult rv;
  if (mOpenedElement) {
    bool currentIsDoc = mCurrentNode == mDocument;
    if (currentIsDoc && mRootContentCreated) {
      // We already have a document element, but the XSLT spec allows this.
      // As a workaround, create a wrapper object and use that as the
      // document element.

      rv = createTxWrapper();
      NS_ENSURE_SUCCESS(rv, rv);
    }

    rv = mCurrentNode->AppendChildTo(mOpenedElement, true);
    NS_ENSURE_SUCCESS(rv, rv);

    if (currentIsDoc) {
      mRootContentCreated = true;
      nsContentUtils::AddScriptRunner(
          new nsDocElementCreatedNotificationRunner(mDocument));
    }

    mCurrentNode = mOpenedElement;
    mOpenedElement = nullptr;
  } else if (aFlushText && !mText.IsEmpty()) {
    // Text can't appear in the root of a document
    if (mDocument == mCurrentNode) {
      if (XMLUtils::isWhitespace(mText)) {
        mText.Truncate();

        return NS_OK;
      }

      rv = createTxWrapper();
      NS_ENSURE_SUCCESS(rv, rv);
    }
    RefPtr<nsTextNode> text =
        new (mNodeInfoManager) nsTextNode(mNodeInfoManager);

    rv = text->SetText(mText, false);
    NS_ENSURE_SUCCESS(rv, rv);

    rv = mCurrentNode->AppendChildTo(text, true);
    NS_ENSURE_SUCCESS(rv, rv);

    mText.Truncate();
  }

  return NS_OK;
}

nsresult txMozillaXMLOutput::createTxWrapper() {
  NS_ASSERTION(mDocument == mCurrentNode,
               "creating wrapper when document isn't parent");

  int32_t namespaceID;
  nsresult rv = nsContentUtils::NameSpaceManager()->RegisterNameSpace(
      NS_LITERAL_STRING(kTXNameSpaceURI), namespaceID);
  NS_ENSURE_SUCCESS(rv, rv);

  nsCOMPtr<Element> wrapper =
      mDocument->CreateElem(nsDependentAtomString(nsGkAtoms::result),
                            nsGkAtoms::transformiix, namespaceID);

#ifdef DEBUG
  // Keep track of the location of the current documentElement, if there is
  // one, so we can verify later
  uint32_t j = 0, rootLocation = 0;
#endif
  for (nsCOMPtr<nsIContent> childContent = mDocument->GetFirstChild();
       childContent; childContent = childContent->GetNextSibling()) {
#ifdef DEBUG
    if (childContent->IsElement()) {
      rootLocation = j;
    }
#endif

    if (childContent->NodeInfo()->NameAtom() ==
        nsGkAtoms::documentTypeNodeName) {
#ifdef DEBUG
      // The new documentElement should go after the document type.
      // This is needed for cases when there is no existing
      // documentElement in the document.
      rootLocation = std::max(rootLocation, j + 1);
      ++j;
#endif
    } else {
      mDocument->RemoveChildNode(childContent, true);

      rv = wrapper->AppendChildTo(childContent, true);
      NS_ENSURE_SUCCESS(rv, rv);
      break;
    }
  }

  if (!mCurrentNodeStack.AppendObject(wrapper)) {
    return NS_ERROR_OUT_OF_MEMORY;
  }
  mCurrentNode = wrapper;
  mRootContentCreated = true;
  NS_ASSERTION(rootLocation == mDocument->GetChildCount(),
               "Incorrect root location");
  return mDocument->AppendChildTo(wrapper, true);
}

nsresult txMozillaXMLOutput::startHTMLElement(nsIContent* aElement,
                                              bool aIsHTML) {
  nsresult rv = NS_OK;

  if ((!aElement->IsHTMLElement(nsGkAtoms::tr) || !aIsHTML) &&
      NS_PTR_TO_INT32(mTableStateStack.peek()) == ADDED_TBODY) {
    uint32_t last = mCurrentNodeStack.Count() - 1;
    NS_ASSERTION(last != (uint32_t)-1, "empty stack");

    mCurrentNode = mCurrentNodeStack.SafeObjectAt(last);
    mCurrentNodeStack.RemoveObjectAt(last);
    mTableStateStack.pop();
  }

  if (aElement->IsHTMLElement(nsGkAtoms::table) && aIsHTML) {
    mTableState = TABLE;
  } else if (aElement->IsHTMLElement(nsGkAtoms::tr) && aIsHTML &&
             NS_PTR_TO_INT32(mTableStateStack.peek()) == TABLE) {
    RefPtr<Element> tbody;
    rv = createHTMLElement(nsGkAtoms::tbody, getter_AddRefs(tbody));
    NS_ENSURE_SUCCESS(rv, rv);

    rv = mCurrentNode->AppendChildTo(tbody, true);
    NS_ENSURE_SUCCESS(rv, rv);

    rv = mTableStateStack.push(NS_INT32_TO_PTR(ADDED_TBODY));
    NS_ENSURE_SUCCESS(rv, rv);

    if (!mCurrentNodeStack.AppendObject(tbody)) {
      return NS_ERROR_OUT_OF_MEMORY;
    }

    mCurrentNode = tbody;
  } else if (aElement->IsHTMLElement(nsGkAtoms::head) &&
             mOutputFormat.mMethod == eHTMLOutput) {
    // Insert META tag, according to spec, 16.2, like
    // <META http-equiv="Content-Type" content="text/html; charset=EUC-JP">
    RefPtr<Element> meta;
    rv = createHTMLElement(nsGkAtoms::meta, getter_AddRefs(meta));
    NS_ENSURE_SUCCESS(rv, rv);

    rv = meta->SetAttr(kNameSpaceID_None, nsGkAtoms::httpEquiv,
                       NS_LITERAL_STRING("Content-Type"), false);
    NS_ENSURE_SUCCESS(rv, rv);

    nsAutoString metacontent;
    metacontent.Append(mOutputFormat.mMediaType);
    metacontent.AppendLiteral("; charset=");
    metacontent.Append(mOutputFormat.mEncoding);
    rv = meta->SetAttr(kNameSpaceID_None, nsGkAtoms::content, metacontent,
                       false);
    NS_ENSURE_SUCCESS(rv, rv);

    // No need to notify since aElement hasn't been inserted yet
    NS_ASSERTION(!aElement->IsInUncomposedDoc(), "should not be in doc");
    rv = aElement->AppendChildTo(meta, false);
    NS_ENSURE_SUCCESS(rv, rv);
  }

  return NS_OK;
}

nsresult txMozillaXMLOutput::endHTMLElement(nsIContent* aElement) {
  if (mTableState == ADDED_TBODY) {
    NS_ASSERTION(aElement->IsHTMLElement(nsGkAtoms::tbody),
                 "Element flagged as added tbody isn't a tbody");
    uint32_t last = mCurrentNodeStack.Count() - 1;
    NS_ASSERTION(last != (uint32_t)-1, "empty stack");

    mCurrentNode = mCurrentNodeStack.SafeObjectAt(last);
    mCurrentNodeStack.RemoveObjectAt(last);
    mTableState =
        static_cast<TableState>(NS_PTR_TO_INT32(mTableStateStack.pop()));

    return NS_OK;
  } else if (mCreatingNewDocument && aElement->IsHTMLElement(nsGkAtoms::meta)) {
    // handle HTTP-EQUIV data
    nsAutoString httpEquiv;
    aElement->AsElement()->GetAttr(kNameSpaceID_None, nsGkAtoms::httpEquiv,
                                   httpEquiv);
    if (!httpEquiv.IsEmpty()) {
      nsAutoString value;
      aElement->AsElement()->GetAttr(kNameSpaceID_None, nsGkAtoms::content,
                                     value);
      if (!value.IsEmpty()) {
        nsContentUtils::ASCIIToLower(httpEquiv);
        RefPtr<nsAtom> header = NS_Atomize(httpEquiv);
        processHTTPEquiv(header, value);
      }
    }
  }

  return NS_OK;
}

void txMozillaXMLOutput::processHTTPEquiv(nsAtom* aHeader,
                                          const nsString& aValue) {
  // For now we only handle "refresh". There's a longer list in
  // HTMLContentSink::ProcessHeaderData
  if (aHeader == nsGkAtoms::refresh)
    LossyCopyUTF16toASCII(aValue, mRefreshString);
}

nsresult txMozillaXMLOutput::createResultDocument(const nsAString& aName,
                                                  int32_t aNsID,
                                                  Document* aSourceDocument,
                                                  bool aLoadedAsData) {
  nsresult rv;

  // Create the document
  if (mOutputFormat.mMethod == eHTMLOutput) {
    rv = NS_NewHTMLDocument(getter_AddRefs(mDocument), aLoadedAsData);
    NS_ENSURE_SUCCESS(rv, rv);
  } else {
    // We should check the root name/namespace here and create the
    // appropriate document
    rv = NS_NewXMLDocument(getter_AddRefs(mDocument), aLoadedAsData);
    NS_ENSURE_SUCCESS(rv, rv);
  }
  // This should really be handled by Document::BeginLoad
  MOZ_ASSERT(
      mDocument->GetReadyStateEnum() == Document::READYSTATE_UNINITIALIZED,
      "Bad readyState");
  mDocument->SetReadyStateInternal(Document::READYSTATE_LOADING);
  mDocument->SetMayStartLayout(false);
  bool hasHadScriptObject = false;
  nsIScriptGlobalObject* sgo =
      aSourceDocument->GetScriptHandlingObject(hasHadScriptObject);
  NS_ENSURE_STATE(sgo || !hasHadScriptObject);

  mCurrentNode = mDocument;
  mNodeInfoManager = mDocument->NodeInfoManager();

  // Reset and set up the document
  URIUtils::ResetWithSource(mDocument, aSourceDocument);

  // Make sure we set the script handling object after resetting with the
  // source, so that we have the right principal.
  mDocument->SetScriptHandlingObject(sgo);

  mDocument->SetStateObjectFrom(aSourceDocument);

  // Set the charset
  if (!mOutputFormat.mEncoding.IsEmpty()) {
    const Encoding* encoding = Encoding::ForLabel(mOutputFormat.mEncoding);
    if (encoding) {
      mDocument->SetDocumentCharacterSetSource(kCharsetFromOtherComponent);
      mDocument->SetDocumentCharacterSet(WrapNotNull(encoding));
    }
  }

  // Set the mime-type
  if (!mOutputFormat.mMediaType.IsEmpty()) {
    mDocument->SetContentType(mOutputFormat.mMediaType);
  } else if (mOutputFormat.mMethod == eHTMLOutput) {
    mDocument->SetContentType(NS_LITERAL_STRING("text/html"));
  } else {
    mDocument->SetContentType(NS_LITERAL_STRING("application/xml"));
  }

  if (mOutputFormat.mMethod == eXMLOutput &&
      mOutputFormat.mOmitXMLDeclaration != eTrue) {
    int32_t standalone;
    if (mOutputFormat.mStandalone == eNotSet) {
      standalone = -1;
    } else if (mOutputFormat.mStandalone == eFalse) {
      standalone = 0;
    } else {
      standalone = 1;
    }

    // Could use mOutputFormat.mVersion.get() when we support
    // versions > 1.0.
    static const char16_t kOneDotZero[] = {'1', '.', '0', '\0'};
    mDocument->SetXMLDeclaration(kOneDotZero, mOutputFormat.mEncoding.get(),
                                 standalone);
  }

  // Set up script loader of the result document.
  ScriptLoader* loader = mDocument->ScriptLoader();
  if (mNotifier) {
    loader->AddObserver(mNotifier);
  } else {
    // Don't load scripts, we can't notify the caller when they're loaded.
    loader->SetEnabled(false);
  }

  if (mNotifier) {
    rv = mNotifier->SetOutputDocument(mDocument);
    NS_ENSURE_SUCCESS(rv, rv);
  }

  // Do this after calling OnDocumentCreated to ensure that the
  // PresShell/PresContext has been hooked up and get notified.
  if (mDocument) {
    mDocument->SetCompatibilityMode(eCompatibility_FullStandards);
  }

  // Add a doc-type if requested
  if (!mOutputFormat.mSystemId.IsEmpty()) {
    nsAutoString qName;
    if (mOutputFormat.mMethod == eHTMLOutput) {
      qName.AssignLiteral("html");
    } else {
      qName.Assign(aName);
    }

    nsresult rv = nsContentUtils::CheckQName(qName);
    if (NS_SUCCEEDED(rv)) {
      RefPtr<nsAtom> doctypeName = NS_Atomize(qName);
      if (!doctypeName) {
        return NS_ERROR_OUT_OF_MEMORY;
      }

      // Indicate that there is no internal subset (not just an empty one)
      RefPtr<DocumentType> documentType = NS_NewDOMDocumentType(
          mNodeInfoManager, doctypeName, mOutputFormat.mPublicId,
          mOutputFormat.mSystemId, VoidString());

      rv = mDocument->AppendChildTo(documentType, true);
      NS_ENSURE_SUCCESS(rv, rv);
    }
  }

  return NS_OK;
}

nsresult txMozillaXMLOutput::createHTMLElement(nsAtom* aName,
                                               Element** aResult) {
  NS_ASSERTION(mOutputFormat.mMethod == eHTMLOutput,
               "need to adjust createHTMLElement");

  *aResult = nullptr;

  RefPtr<NodeInfo> ni;
  ni = mNodeInfoManager->GetNodeInfo(aName, nullptr, kNameSpaceID_XHTML,
                                     nsINode::ELEMENT_NODE);

  nsCOMPtr<Element> el;
  nsresult rv = NS_NewHTMLElement(
      getter_AddRefs(el), ni.forget(),
      mCreatingNewDocument ? FROM_PARSER_XSLT : FROM_PARSER_FRAGMENT);
  el.forget(aResult);
  return rv;
}

txTransformNotifier::txTransformNotifier()
    : mPendingStylesheetCount(0), mInTransform(false) {}

txTransformNotifier::~txTransformNotifier() = default;

NS_IMPL_ISUPPORTS(txTransformNotifier, nsIScriptLoaderObserver,
                  nsICSSLoaderObserver)

NS_IMETHODIMP
txTransformNotifier::ScriptAvailable(nsresult aResult,
                                     nsIScriptElement* aElement,
                                     bool aIsInlineClassicScript, nsIURI* aURI,
                                     int32_t aLineNo) {
  if (NS_FAILED(aResult) && mScriptElements.RemoveObject(aElement)) {
    SignalTransformEnd();
  }

  return NS_OK;
}

NS_IMETHODIMP
txTransformNotifier::ScriptEvaluated(nsresult aResult,
                                     nsIScriptElement* aElement,
                                     bool aIsInline) {
  if (mScriptElements.RemoveObject(aElement)) {
    SignalTransformEnd();
  }

  return NS_OK;
}

NS_IMETHODIMP
txTransformNotifier::StyleSheetLoaded(StyleSheet* aSheet, bool aWasDeferred,
                                      nsresult aStatus) {
  if (mPendingStylesheetCount == 0) {
    // We weren't waiting on this stylesheet anyway.  This can happen if
    // SignalTransformEnd got called with an error aResult.  See
    // http://bugzilla.mozilla.org/show_bug.cgi?id=215465.
    return NS_OK;
  }

  // We're never waiting for alternate stylesheets
  if (!aWasDeferred) {
    --mPendingStylesheetCount;
    SignalTransformEnd();
  }

  return NS_OK;
}

void txTransformNotifier::Init(nsITransformObserver* aObserver) {
  mObserver = aObserver;
}

nsresult txTransformNotifier::AddScriptElement(nsIScriptElement* aElement) {
  return mScriptElements.AppendObject(aElement) ? NS_OK
                                                : NS_ERROR_OUT_OF_MEMORY;
}

void txTransformNotifier::AddPendingStylesheet() { ++mPendingStylesheetCount; }

void txTransformNotifier::OnTransformEnd(nsresult aResult) {
  mInTransform = false;
  SignalTransformEnd(aResult);
}

void txTransformNotifier::OnTransformStart() { mInTransform = true; }

nsresult txTransformNotifier::SetOutputDocument(Document* aDocument) {
  mDocument = aDocument;

  // Notify the contentsink that the document is created
  return mObserver->OnDocumentCreated(mDocument);
}

void txTransformNotifier::SignalTransformEnd(nsresult aResult) {
  if (mInTransform ||
      (NS_SUCCEEDED(aResult) &&
       (mScriptElements.Count() > 0 || mPendingStylesheetCount > 0))) {
    return;
  }

  // mPendingStylesheetCount is nonzero at this point only if aResult is an
  // error.  Set it to 0 so we won't reenter this code when we stop the
  // CSSLoader.
  mPendingStylesheetCount = 0;
  mScriptElements.Clear();

  // Make sure that we don't get deleted while this function is executed and
  // we remove ourselfs from the scriptloader
  nsCOMPtr<nsIScriptLoaderObserver> kungFuDeathGrip(this);

  if (mDocument) {
    mDocument->ScriptLoader()->DeferCheckpointReached();
    mDocument->ScriptLoader()->RemoveObserver(this);
    // XXX Maybe we want to cancel script loads if NS_FAILED(rv)?

    if (NS_FAILED(aResult)) {
      mDocument->CSSLoader()->Stop();
    }
  }

  if (NS_SUCCEEDED(aResult)) {
    mObserver->OnTransformDone(aResult, mDocument);
  }
}
