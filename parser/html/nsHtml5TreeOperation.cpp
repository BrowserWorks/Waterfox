/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=2 sw=2 et tw=78: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsHtml5TreeOperation.h"
#include "nsContentUtils.h"
#include "nsDocElementCreatedNotificationRunner.h"
#include "nsNodeUtils.h"
#include "nsAttrName.h"
#include "nsHtml5TreeBuilder.h"
#include "nsIDOMMutationEvent.h"
#include "mozAutoDocUpdate.h"
#include "nsBindingManager.h"
#include "nsXBLBinding.h"
#include "nsHtml5DocumentMode.h"
#include "nsHtml5HtmlAttributes.h"
#include "nsContentCreatorFunctions.h"
#include "nsIScriptElement.h"
#include "nsIDTD.h"
#include "nsISupportsImpl.h"
#include "nsIDOMHTMLFormElement.h"
#include "nsIFormControl.h"
#include "nsIStyleSheetLinkingElement.h"
#include "nsIDOMDocumentType.h"
#include "nsIObserverService.h"
#include "mozilla/Services.h"
#include "nsIMutationObserver.h"
#include "nsIFormProcessor.h"
#include "nsIServiceManager.h"
#include "nsEscape.h"
#include "mozilla/dom/Comment.h"
#include "mozilla/dom/Element.h"
#include "mozilla/dom/HTMLImageElement.h"
#include "mozilla/dom/HTMLTemplateElement.h"
#include "nsHtml5SVGLoadDispatcher.h"
#include "nsIURI.h"
#include "nsIProtocolHandler.h"
#include "nsNetUtil.h"
#include "nsIHTMLDocument.h"
#include "mozilla/Likely.h"
#include "nsTextNode.h"

using namespace mozilla;

static NS_DEFINE_CID(kFormProcessorCID, NS_FORMPROCESSOR_CID);

/**
 * Helper class that opens a notification batch if the current doc
 * is different from the executor doc.
 */
class MOZ_STACK_CLASS nsHtml5OtherDocUpdate {
  public:
    nsHtml5OtherDocUpdate(nsIDocument* aCurrentDoc, nsIDocument* aExecutorDoc)
    {
      NS_PRECONDITION(aCurrentDoc, "Node has no doc?");
      NS_PRECONDITION(aExecutorDoc, "Executor has no doc?");
      if (MOZ_LIKELY(aCurrentDoc == aExecutorDoc)) {
        mDocument = nullptr;
      } else {
        mDocument = aCurrentDoc;
        aCurrentDoc->BeginUpdate(UPDATE_CONTENT_MODEL);        
      }
    }

    ~nsHtml5OtherDocUpdate()
    {
      if (MOZ_UNLIKELY(mDocument)) {
        mDocument->EndUpdate(UPDATE_CONTENT_MODEL);
      }
    }
  private:
    nsCOMPtr<nsIDocument> mDocument;
};

nsHtml5TreeOperation::nsHtml5TreeOperation()
 : mOpCode(eTreeOpUninitialized)
{
  MOZ_COUNT_CTOR(nsHtml5TreeOperation);
}

nsHtml5TreeOperation::~nsHtml5TreeOperation()
{
  MOZ_COUNT_DTOR(nsHtml5TreeOperation);
  NS_ASSERTION(mOpCode != eTreeOpUninitialized, "Uninitialized tree op.");
  switch(mOpCode) {
    case eTreeOpAddAttributes:
      delete mTwo.attributes;
      break;
    case eTreeOpCreateElementNetwork:
    case eTreeOpCreateElementNotNetwork:
      delete mThree.attributes;
      break;
    case eTreeOpAppendDoctypeToDocument:
      delete mTwo.stringPair;
      break;
    case eTreeOpFosterParentText:
    case eTreeOpAppendText:
    case eTreeOpAppendComment:
    case eTreeOpAppendCommentToDocument:
    case eTreeOpAddViewSourceHref:
    case eTreeOpAddViewSourceBase:
      delete[] mTwo.unicharPtr;
      break;
    case eTreeOpSetDocumentCharset:
    case eTreeOpNeedsCharsetSwitchTo:
      delete[] mOne.charPtr;
      break;
    case eTreeOpProcessOfflineManifest:
      free(mOne.unicharPtr);
      break;
    default: // keep the compiler happy
      break;
  }
}

nsresult
nsHtml5TreeOperation::AppendTextToTextNode(const char16_t* aBuffer,
                                           uint32_t aLength,
                                           nsIContent* aTextNode,
                                           nsHtml5DocumentBuilder* aBuilder)
{
  NS_PRECONDITION(aTextNode, "Got null text node.");
  MOZ_ASSERT(aBuilder);
  MOZ_ASSERT(aBuilder->IsInDocUpdate());
  uint32_t oldLength = aTextNode->TextLength();
  CharacterDataChangeInfo info = {
    true,
    oldLength,
    oldLength,
    aLength
  };
  nsNodeUtils::CharacterDataWillChange(aTextNode, &info);

  nsresult rv = aTextNode->AppendText(aBuffer, aLength, false);
  NS_ENSURE_SUCCESS(rv, rv);

  nsNodeUtils::CharacterDataChanged(aTextNode, &info);
  return rv;
}


nsresult
nsHtml5TreeOperation::AppendText(const char16_t* aBuffer,
                                 uint32_t aLength,
                                 nsIContent* aParent,
                                 nsHtml5DocumentBuilder* aBuilder)
{
  nsresult rv = NS_OK;
  nsIContent* lastChild = aParent->GetLastChild();
  if (lastChild && lastChild->IsNodeOfType(nsINode::eTEXT)) {
    nsHtml5OtherDocUpdate update(aParent->OwnerDoc(),
                                 aBuilder->GetDocument());
    return AppendTextToTextNode(aBuffer, 
                                aLength, 
                                lastChild, 
                                aBuilder);
  }

  nsNodeInfoManager* nodeInfoManager = aParent->OwnerDoc()->NodeInfoManager();
  RefPtr<nsTextNode> text = new nsTextNode(nodeInfoManager);
  NS_ASSERTION(text, "Infallible malloc failed?");
  rv = text->SetText(aBuffer, aLength, false);
  NS_ENSURE_SUCCESS(rv, rv);

  return Append(text, aParent, aBuilder);
}

nsresult
nsHtml5TreeOperation::Append(nsIContent* aNode,
                             nsIContent* aParent,
                             nsHtml5DocumentBuilder* aBuilder)
{
  MOZ_ASSERT(aBuilder);
  MOZ_ASSERT(aBuilder->IsInDocUpdate());
  nsresult rv = NS_OK;
  nsHtml5OtherDocUpdate update(aParent->OwnerDoc(),
                               aBuilder->GetDocument());
  uint32_t childCount = aParent->GetChildCount();
  rv = aParent->AppendChildTo(aNode, false);
  if (NS_SUCCEEDED(rv)) {
    aNode->SetParserHasNotified();
    nsNodeUtils::ContentAppended(aParent, aNode, childCount);
  }
  return rv;
}

nsresult
nsHtml5TreeOperation::AppendToDocument(nsIContent* aNode,
                                       nsHtml5DocumentBuilder* aBuilder)
{
  MOZ_ASSERT(aBuilder);
  MOZ_ASSERT(aBuilder->GetDocument() == aNode->OwnerDoc());
  MOZ_ASSERT(aBuilder->IsInDocUpdate());
  nsresult rv = NS_OK;

  nsIDocument* doc = aBuilder->GetDocument();
  uint32_t childCount = doc->GetChildCount();
  rv = doc->AppendChildTo(aNode, false);
  if (rv == NS_ERROR_DOM_HIERARCHY_REQUEST_ERR) {
    aNode->SetParserHasNotified();
    return NS_OK;
  }
  NS_ENSURE_SUCCESS(rv, rv);
  aNode->SetParserHasNotified();
  nsNodeUtils::ContentInserted(doc, aNode, childCount);

  NS_ASSERTION(!nsContentUtils::IsSafeToRunScript(),
               "Someone forgot to block scripts");
  if (aNode->IsElement()) {
    nsContentUtils::AddScriptRunner(
        new nsDocElementCreatedNotificationRunner(doc));
  }
  return rv;
}

static bool
IsElementOrTemplateContent(nsINode* aNode) {
  if (aNode) {
    if (aNode->IsElement()) {
      return true;
    } else if (aNode->NodeType() == nsIDOMNode::DOCUMENT_FRAGMENT_NODE) {
      // Check if the node is a template content.
      mozilla::dom::DocumentFragment* frag =
        static_cast<mozilla::dom::DocumentFragment*>(aNode);
      nsIContent* fragHost = frag->GetHost();
      if (fragHost && nsNodeUtils::IsTemplateElement(fragHost)) {
        return true;
      }
    }
  }
  return false;
}

void
nsHtml5TreeOperation::Detach(nsIContent* aNode, nsHtml5DocumentBuilder* aBuilder)
{
  MOZ_ASSERT(aBuilder);
  MOZ_ASSERT(aBuilder->IsInDocUpdate());
  nsCOMPtr<nsINode> parent = aNode->GetParentNode();
  if (parent) {
    nsHtml5OtherDocUpdate update(parent->OwnerDoc(),
        aBuilder->GetDocument());
    int32_t pos = parent->IndexOf(aNode);
    NS_ASSERTION((pos >= 0), "Element not found as child of its parent");
    parent->RemoveChildAt(pos, true);
  }
}

nsresult
nsHtml5TreeOperation::AppendChildrenToNewParent(nsIContent* aNode,
                                                nsIContent* aParent,
                                                nsHtml5DocumentBuilder* aBuilder)
{
  MOZ_ASSERT(aBuilder);
  MOZ_ASSERT(aBuilder->IsInDocUpdate());
  nsHtml5OtherDocUpdate update(aParent->OwnerDoc(),
                               aBuilder->GetDocument());

  uint32_t childCount = aParent->GetChildCount();
  bool didAppend = false;
  while (aNode->HasChildren()) {
    nsCOMPtr<nsIContent> child = aNode->GetFirstChild();
    aNode->RemoveChildAt(0, true);
    nsresult rv = aParent->AppendChildTo(child, false);
    NS_ENSURE_SUCCESS(rv, rv);
    didAppend = true;
  }
  if (didAppend) {
    nsNodeUtils::ContentAppended(aParent, aParent->GetChildAt(childCount),
                                 childCount);
  }
  return NS_OK;
}

nsresult
nsHtml5TreeOperation::FosterParent(nsIContent* aNode,
                                   nsIContent* aParent,
                                   nsIContent* aTable,
                                   nsHtml5DocumentBuilder* aBuilder)
{
  MOZ_ASSERT(aBuilder);
  MOZ_ASSERT(aBuilder->IsInDocUpdate());
  nsIContent* foster = aTable->GetParent();

  if (IsElementOrTemplateContent(foster)) {

    nsHtml5OtherDocUpdate update(foster->OwnerDoc(),
                                 aBuilder->GetDocument());

    uint32_t pos = foster->IndexOf(aTable);
    nsresult rv = foster->InsertChildAt(aNode, pos, false);
    NS_ENSURE_SUCCESS(rv, rv);
    nsNodeUtils::ContentInserted(foster, aNode, pos);
    return rv;
  }

  return Append(aNode, aParent, aBuilder);
}

nsresult
nsHtml5TreeOperation::AddAttributes(nsIContent* aNode,
                                    nsHtml5HtmlAttributes* aAttributes,
                                    nsHtml5DocumentBuilder* aBuilder)
{
  dom::Element* node = aNode->AsElement();
  nsHtml5OtherDocUpdate update(node->OwnerDoc(),
                               aBuilder->GetDocument());

  int32_t len = aAttributes->getLength();
  for (int32_t i = len; i > 0;) {
    --i;
    // prefix doesn't need regetting. it is always null or a static atom
    // local name is never null
    nsCOMPtr<nsIAtom> localName =
      Reget(aAttributes->getLocalNameNoBoundsCheck(i));
    int32_t nsuri = aAttributes->getURINoBoundsCheck(i);
    if (!node->HasAttr(nsuri, localName)) {
      // prefix doesn't need regetting. it is always null or a static atom
      // local name is never null
      node->SetAttr(nsuri,
                    localName,
                    aAttributes->getPrefixNoBoundsCheck(i),
                    *(aAttributes->getValueNoBoundsCheck(i)),
                    true);
      // XXX what to do with nsresult?
    }
  }
  return NS_OK;
}


nsIContent*
nsHtml5TreeOperation::CreateElement(int32_t aNs,
                                    nsIAtom* aName,
                                    nsHtml5HtmlAttributes* aAttributes,
                                    mozilla::dom::FromParser aFromParser,
                                    nsNodeInfoManager* aNodeInfoManager,
                                    nsHtml5DocumentBuilder* aBuilder)
{
  bool isKeygen = (aName == nsHtml5Atoms::keygen && aNs == kNameSpaceID_XHTML);
  if (MOZ_UNLIKELY(isKeygen)) {
    aName = nsHtml5Atoms::select;
  }

  nsCOMPtr<dom::Element> newElement;
  RefPtr<dom::NodeInfo> nodeInfo = aNodeInfoManager->
    GetNodeInfo(aName, nullptr, aNs, nsIDOMNode::ELEMENT_NODE);
  NS_ASSERTION(nodeInfo, "Got null nodeinfo.");
  NS_NewElement(getter_AddRefs(newElement),
                nodeInfo.forget(),
                aFromParser);
  NS_ASSERTION(newElement, "Element creation created null pointer.");

  dom::Element* newContent = newElement;
  aBuilder->HoldElement(newElement.forget());

  if (MOZ_UNLIKELY(aName == nsHtml5Atoms::style || aName == nsHtml5Atoms::link)) {
    nsCOMPtr<nsIStyleSheetLinkingElement> ssle(do_QueryInterface(newContent));
    if (ssle) {
      ssle->InitStyleLinkElement(false);
      ssle->SetEnableUpdates(false);
    }
  } else if (MOZ_UNLIKELY(isKeygen)) {
    // Adapted from CNavDTD
    nsresult rv;
    nsCOMPtr<nsIFormProcessor> theFormProcessor =
      do_GetService(kFormProcessorCID, &rv);
    if (NS_FAILED(rv)) {
      return newContent;
    }

    nsTArray<nsString> theContent;
    nsAutoString theAttribute;

    (void) theFormProcessor->ProvideContent(NS_LITERAL_STRING("select"),
                                            theContent,
                                            theAttribute);

    newContent->SetAttr(kNameSpaceID_None,
                        nsGkAtoms::moztype,
                        nullptr,
                        theAttribute,
                        false);

    RefPtr<dom::NodeInfo> optionNodeInfo =
      aNodeInfoManager->GetNodeInfo(nsHtml5Atoms::option,
                                    nullptr,
                                    kNameSpaceID_XHTML,
                                    nsIDOMNode::ELEMENT_NODE);

    for (uint32_t i = 0; i < theContent.Length(); ++i) {
      nsCOMPtr<dom::Element> optionElt;
      RefPtr<dom::NodeInfo> ni = optionNodeInfo;
      NS_NewElement(getter_AddRefs(optionElt),
                    ni.forget(),
                    aFromParser);
      RefPtr<nsTextNode> optionText = new nsTextNode(aNodeInfoManager);
      (void) optionText->SetText(theContent[i], false);
      optionElt->AppendChildTo(optionText, false);
      newContent->AppendChildTo(optionElt, false);
      // XXXsmaug Shouldn't we call this after adding all the child nodes.
      newContent->DoneAddingChildren(false);
    }
  }

  if (!aAttributes) {
    return newContent;
  }

  int32_t len = aAttributes->getLength();
  for (int32_t i = 0; i < len; i++) {
    // prefix doesn't need regetting. it is always null or a static atom
    // local name is never null
    nsCOMPtr<nsIAtom> localName =
      Reget(aAttributes->getLocalNameNoBoundsCheck(i));
    nsCOMPtr<nsIAtom> prefix = aAttributes->getPrefixNoBoundsCheck(i);
    int32_t nsuri = aAttributes->getURINoBoundsCheck(i);

    if (aNs == kNameSpaceID_XHTML &&
        nsHtml5Atoms::a == aName &&
        nsHtml5Atoms::name == localName) {
      // This is an HTML5-incompliant Geckoism.
      // Remove when fixing bug 582361
      NS_ConvertUTF16toUTF8 cname(*(aAttributes->getValueNoBoundsCheck(i)));
      NS_ConvertUTF8toUTF16 uv(nsUnescape(cname.BeginWriting()));
      newContent->SetAttr(nsuri,
                          localName,
                          prefix,
                          uv,
                          false);
    } else {
      nsString& value = *(aAttributes->getValueNoBoundsCheck(i));
      newContent->SetAttr(nsuri,
                          localName,
                          prefix,
                          value,
                          false);

      // Custom element setup may be needed if there is an "is" attribute.
      if (kNameSpaceID_None == nsuri && !prefix && nsGkAtoms::is == localName) {
        nsContentUtils::SetupCustomElement(newContent, &value);
      }
    }
  }
  return newContent;
}

void
nsHtml5TreeOperation::SetFormElement(nsIContent* aNode, nsIContent* aParent)
{
  nsCOMPtr<nsIFormControl> formControl(do_QueryInterface(aNode));
  nsCOMPtr<nsIDOMHTMLImageElement> domImageElement = do_QueryInterface(aNode);
  // NS_ASSERTION(formControl, "Form-associated element did not implement nsIFormControl.");
  // TODO: uncomment the above line when <keygen> (bug 101019) is supported by Gecko
  nsCOMPtr<nsIDOMHTMLFormElement> formElement(do_QueryInterface(aParent));
  NS_ASSERTION(formElement, "The form element doesn't implement nsIDOMHTMLFormElement.");
  // avoid crashing on <keygen>
  if (formControl &&
      !aNode->HasAttr(kNameSpaceID_None, nsGkAtoms::form)) {
    formControl->SetForm(formElement);
  } else if (domImageElement) {
    RefPtr<dom::HTMLImageElement> imageElement =
      static_cast<dom::HTMLImageElement*>(domImageElement.get());
    MOZ_ASSERT(imageElement);
    imageElement->SetForm(formElement);
  }
}

nsresult
nsHtml5TreeOperation::AppendIsindexPrompt(nsIContent* parent, nsHtml5DocumentBuilder* aBuilder)
{
  nsXPIDLString prompt;
  nsresult rv =
      nsContentUtils::GetLocalizedString(nsContentUtils::eFORMS_PROPERTIES,
                                         "IsIndexPromptWithSpace", prompt);
  uint32_t len = prompt.Length();
  if (NS_FAILED(rv)) {
    return rv;
  }
  if (!len) {
    // Don't bother appending a zero-length text node.
    return NS_OK;
  }
  return AppendText(prompt.BeginReading(), len, parent, aBuilder);
}

nsresult
nsHtml5TreeOperation::FosterParentText(nsIContent* aStackParent,
                                       char16_t* aBuffer,
                                       uint32_t aLength,
                                       nsIContent* aTable,
                                       nsHtml5DocumentBuilder* aBuilder)
{
  MOZ_ASSERT(aBuilder);
  MOZ_ASSERT(aBuilder->IsInDocUpdate());
  nsresult rv = NS_OK;
  nsIContent* foster = aTable->GetParent();

  if (IsElementOrTemplateContent(foster)) {
    nsHtml5OtherDocUpdate update(foster->OwnerDoc(),
                                 aBuilder->GetDocument());

    uint32_t pos = foster->IndexOf(aTable);

    nsIContent* previousSibling = aTable->GetPreviousSibling();
    if (previousSibling && previousSibling->IsNodeOfType(nsINode::eTEXT)) {
      return AppendTextToTextNode(aBuffer,
                                  aLength,
                                  previousSibling,
                                  aBuilder);
    }

    nsNodeInfoManager* nodeInfoManager = aStackParent->OwnerDoc()->NodeInfoManager();
    RefPtr<nsTextNode> text = new nsTextNode(nodeInfoManager);
    NS_ASSERTION(text, "Infallible malloc failed?");
    rv = text->SetText(aBuffer, aLength, false);
    NS_ENSURE_SUCCESS(rv, rv);

    rv = foster->InsertChildAt(text, pos, false);
    NS_ENSURE_SUCCESS(rv, rv);
    nsNodeUtils::ContentInserted(foster, text, pos);
    return rv;
  }

  return AppendText(aBuffer, aLength, aStackParent, aBuilder);
}

nsresult
nsHtml5TreeOperation::AppendComment(nsIContent* aParent,
                                    char16_t* aBuffer,
                                    int32_t aLength,
                                    nsHtml5DocumentBuilder* aBuilder)
{
  nsNodeInfoManager* nodeInfoManager = aParent->OwnerDoc()->NodeInfoManager();
  RefPtr<dom::Comment> comment = new dom::Comment(nodeInfoManager);
  NS_ASSERTION(comment, "Infallible malloc failed?");
  nsresult rv = comment->SetText(aBuffer, aLength, false);
  NS_ENSURE_SUCCESS(rv, rv);

  return Append(comment, aParent, aBuilder);
}

nsresult
nsHtml5TreeOperation::AppendCommentToDocument(char16_t* aBuffer,
                                              int32_t aLength,
                                              nsHtml5DocumentBuilder* aBuilder)
{
  RefPtr<dom::Comment> comment =
    new dom::Comment(aBuilder->GetNodeInfoManager());
  NS_ASSERTION(comment, "Infallible malloc failed?");
  nsresult rv = comment->SetText(aBuffer, aLength, false);
  NS_ENSURE_SUCCESS(rv, rv);

  return AppendToDocument(comment, aBuilder);
}

nsresult
nsHtml5TreeOperation::AppendDoctypeToDocument(nsIAtom* aName,
                                              const nsAString& aPublicId,
                                              const nsAString& aSystemId,
                                              nsHtml5DocumentBuilder* aBuilder)
{
  // Adapted from nsXMLContentSink
  // Create a new doctype node
  nsCOMPtr<nsIDOMDocumentType> docType;
  NS_NewDOMDocumentType(getter_AddRefs(docType),
                        aBuilder->GetNodeInfoManager(),
                        aName,
                        aPublicId,
                        aSystemId,
                        NullString());
  NS_ASSERTION(docType, "Doctype creation failed.");
  nsCOMPtr<nsIContent> asContent = do_QueryInterface(docType);
  return AppendToDocument(asContent, aBuilder);
}

nsIContent*
nsHtml5TreeOperation::GetDocumentFragmentForTemplate(nsIContent* aNode)
{
  dom::HTMLTemplateElement* tempElem =
    static_cast<dom::HTMLTemplateElement*>(aNode);
  RefPtr<dom::DocumentFragment> frag = tempElem->Content();
  return frag;
}

nsIContent*
nsHtml5TreeOperation::GetFosterParent(nsIContent* aTable, nsIContent* aStackParent)
{
  nsIContent* tableParent = aTable->GetParent();
  return IsElementOrTemplateContent(tableParent) ? tableParent : aStackParent;
}

void
nsHtml5TreeOperation::PreventScriptExecution(nsIContent* aNode)
{
  nsCOMPtr<nsIScriptElement> sele = do_QueryInterface(aNode);
  MOZ_ASSERT(sele);
  sele->PreventExecution();
}

void
nsHtml5TreeOperation::DoneAddingChildren(nsIContent* aNode)
{
  aNode->DoneAddingChildren(aNode->HasParserNotified());
}

void
nsHtml5TreeOperation::DoneCreatingElement(nsIContent* aNode)
{
  aNode->DoneCreatingElement();
}

void
nsHtml5TreeOperation::SvgLoad(nsIContent* aNode)
{
  nsCOMPtr<nsIRunnable> event = new nsHtml5SVGLoadDispatcher(aNode);
  if (NS_FAILED(NS_DispatchToMainThread(event))) {
    NS_WARNING("failed to dispatch svg load dispatcher");
  }
}

void
nsHtml5TreeOperation::MarkMalformedIfScript(nsIContent* aNode)
{
  nsCOMPtr<nsIScriptElement> sele = do_QueryInterface(aNode);
  if (sele) {
    // Make sure to serialize this script correctly, for nice round tripping.
    sele->SetIsMalformed();
  }
}

nsresult
nsHtml5TreeOperation::Perform(nsHtml5TreeOpExecutor* aBuilder,
                              nsIContent** aScriptElement)
{
  switch(mOpCode) {
    case eTreeOpUninitialized: {
      MOZ_CRASH("eTreeOpUninitialized");
    }
    case eTreeOpAppend: {
      nsIContent* node = *(mOne.node);
      nsIContent* parent = *(mTwo.node);
      return Append(node, parent, aBuilder);
    }
    case eTreeOpDetach: {
      nsIContent* node = *(mOne.node);
      Detach(node, aBuilder);
      return NS_OK;
    }
    case eTreeOpAppendChildrenToNewParent: {
      nsCOMPtr<nsIContent> node = *(mOne.node);
      nsIContent* parent = *(mTwo.node);
      return AppendChildrenToNewParent(node, parent, aBuilder);
    }
    case eTreeOpFosterParent: {
      nsIContent* node = *(mOne.node);
      nsIContent* parent = *(mTwo.node);
      nsIContent* table = *(mThree.node);
      return FosterParent(node, parent, table, aBuilder);
    }
    case eTreeOpAppendToDocument: {
      nsIContent* node = *(mOne.node);
      return AppendToDocument(node, aBuilder);
    }
    case eTreeOpAddAttributes: {
      nsIContent* node = *(mOne.node);
      nsHtml5HtmlAttributes* attributes = mTwo.attributes;
      return AddAttributes(node, attributes, aBuilder);
    }
    case eTreeOpDocumentMode: {
      aBuilder->SetDocumentMode(mOne.mode);
      return NS_OK;
    }
    case eTreeOpCreateElementNetwork:
    case eTreeOpCreateElementNotNetwork: {
      nsIContent** target = mOne.node;
      int32_t ns = mFour.integer;
      nsCOMPtr<nsIAtom> name = Reget(mTwo.atom);
      nsHtml5HtmlAttributes* attributes = mThree.attributes;
      nsIContent* intendedParent = mFive.node ? *(mFive.node) : nullptr;

      // intendedParent == nullptr is a special case where the
      // intended parent is the document.
      nsNodeInfoManager* nodeInfoManager = intendedParent ?
         intendedParent->OwnerDoc()->NodeInfoManager() :
         aBuilder->GetNodeInfoManager();

      *target = CreateElement(ns,
                              name,
                              attributes,
                              mOpCode == eTreeOpCreateElementNetwork ?
                                dom::FROM_PARSER_NETWORK :
                                dom::FROM_PARSER_DOCUMENT_WRITE,
                              nodeInfoManager,
                              aBuilder);
      return NS_OK;
    }
    case eTreeOpSetFormElement: {
      nsIContent* node = *(mOne.node);
      nsIContent* parent = *(mTwo.node);
      SetFormElement(node, parent);
      return NS_OK;
    }
    case eTreeOpAppendText: {
      nsIContent* parent = *mOne.node;
      char16_t* buffer = mTwo.unicharPtr;
      uint32_t length = mFour.integer;
      return AppendText(buffer, length, parent, aBuilder);
    }
    case eTreeOpAppendIsindexPrompt: {
      nsIContent* parent = *mOne.node;
      return AppendIsindexPrompt(parent, aBuilder);
    }
    case eTreeOpFosterParentText: {
      nsIContent* stackParent = *mOne.node;
      char16_t* buffer = mTwo.unicharPtr;
      uint32_t length = mFour.integer;
      nsIContent* table = *mThree.node;
      return FosterParentText(stackParent, buffer, length, table, aBuilder);
    }
    case eTreeOpAppendComment: {
      nsIContent* parent = *mOne.node;
      char16_t* buffer = mTwo.unicharPtr;
      int32_t length = mFour.integer;
      return AppendComment(parent, buffer, length, aBuilder);
    }
    case eTreeOpAppendCommentToDocument: {
      char16_t* buffer = mTwo.unicharPtr;
      int32_t length = mFour.integer;
      return AppendCommentToDocument(buffer, length, aBuilder);
    }
    case eTreeOpAppendDoctypeToDocument: {
      nsCOMPtr<nsIAtom> name = Reget(mOne.atom);
      nsHtml5TreeOperationStringPair* pair = mTwo.stringPair;
      nsString publicId;
      nsString systemId;
      pair->Get(publicId, systemId);
      return AppendDoctypeToDocument(name, publicId, systemId, aBuilder);
    }
    case eTreeOpGetDocumentFragmentForTemplate: {
      nsIContent* node = *(mOne.node);
      *mTwo.node = GetDocumentFragmentForTemplate(node);
      return NS_OK;
    }
    case eTreeOpGetFosterParent: {
      nsIContent* table = *(mOne.node);
      nsIContent* stackParent = *(mTwo.node);
      nsIContent* fosterParent = GetFosterParent(table, stackParent);
      *mThree.node = fosterParent;
      return NS_OK;
    }
    case eTreeOpMarkAsBroken: {
      return mOne.result;
    }
    case eTreeOpRunScript: {
      nsIContent* node = *(mOne.node);
      nsAHtml5TreeBuilderState* snapshot = mTwo.state;
      if (snapshot) {
        aBuilder->InitializeDocWriteParserState(snapshot, mFour.integer);
      }
      *aScriptElement = node;
      return NS_OK;
    }
    case eTreeOpRunScriptAsyncDefer: {
      nsIContent* node = *(mOne.node);
      aBuilder->RunScript(node);
      return NS_OK;
    }
    case eTreeOpPreventScriptExecution: {
      nsIContent* node = *(mOne.node);
      PreventScriptExecution(node);
      return NS_OK;
    }
    case eTreeOpDoneAddingChildren: {
      nsIContent* node = *(mOne.node);
      node->DoneAddingChildren(node->HasParserNotified());
      return NS_OK;
    }
    case eTreeOpDoneCreatingElement: {
      nsIContent* node = *(mOne.node);
      DoneCreatingElement(node);
      return NS_OK;
    }
    case eTreeOpSetDocumentCharset: {
      char* str = mOne.charPtr;
      int32_t charsetSource = mFour.integer;
      nsDependentCString dependentString(str);
      aBuilder->SetDocumentCharsetAndSource(dependentString, charsetSource);
      return NS_OK;
    }
    case eTreeOpNeedsCharsetSwitchTo: {
      char* str = mOne.charPtr;
      int32_t charsetSource = mFour.integer;
      int32_t lineNumber = mTwo.integer;
      aBuilder->NeedsCharsetSwitchTo(str, charsetSource, (uint32_t)lineNumber);
      return NS_OK;
    }
    case eTreeOpUpdateStyleSheet: {
      nsIContent* node = *(mOne.node);
      aBuilder->UpdateStyleSheet(node);
      return NS_OK;
    }
    case eTreeOpProcessMeta: {
      nsIContent* node = *(mOne.node);
      return aBuilder->ProcessMETATag(node);
    }
    case eTreeOpProcessOfflineManifest: {
      char16_t* str = mOne.unicharPtr;
      nsDependentString dependentString(str);
      aBuilder->ProcessOfflineManifest(dependentString);
      return NS_OK;
    }
    case eTreeOpMarkMalformedIfScript: {
      nsIContent* node = *(mOne.node);
      MarkMalformedIfScript(node);
      return NS_OK;
    }
    case eTreeOpStreamEnded: {
      aBuilder->DidBuildModel(false); // this causes a notifications flush anyway
      return NS_OK;
    }
    case eTreeOpSetStyleLineNumber: {
      nsIContent* node = *(mOne.node);
      nsCOMPtr<nsIStyleSheetLinkingElement> ssle = do_QueryInterface(node);
      NS_ASSERTION(ssle, "Node didn't QI to style.");
      ssle->SetLineNumber(mFour.integer);
      return NS_OK;
    }
    case eTreeOpSetScriptLineNumberAndFreeze: {
      nsIContent* node = *(mOne.node);
      nsCOMPtr<nsIScriptElement> sele = do_QueryInterface(node);
      NS_ASSERTION(sele, "Node didn't QI to script.");
      sele->SetScriptLineNumber(mFour.integer);
      sele->FreezeUriAsyncDefer();
      return NS_OK;
    }
    case eTreeOpSvgLoad: {
      nsIContent* node = *(mOne.node);
      SvgLoad(node);
      return NS_OK;
    }
    case eTreeOpMaybeComplainAboutCharset: {
      char* msgId = mOne.charPtr;
      bool error = mTwo.integer;
      int32_t lineNumber = mThree.integer;
      aBuilder->MaybeComplainAboutCharset(msgId, error, (uint32_t)lineNumber);
      return NS_OK;
    }
    case eTreeOpAddClass: {
      nsIContent* node = *(mOne.node);
      char16_t* str = mTwo.unicharPtr;
      nsDependentString depStr(str);
      // See viewsource.css for the possible classes
      nsAutoString klass;
      node->GetAttr(kNameSpaceID_None, nsGkAtoms::_class, klass);
      if (!klass.IsEmpty()) {
        klass.Append(' ');
        klass.Append(depStr);
        node->SetAttr(kNameSpaceID_None, nsGkAtoms::_class, klass, true);
      } else {
        node->SetAttr(kNameSpaceID_None, nsGkAtoms::_class, depStr, true);
      }
      return NS_OK;
    }
    case eTreeOpAddViewSourceHref: {
      nsIContent* node = *mOne.node;
      char16_t* buffer = mTwo.unicharPtr;
      int32_t length = mFour.integer;

      nsDependentString relative(buffer, length);

      nsIDocument* doc = aBuilder->GetDocument();

      const nsCString& charset = doc->GetDocumentCharacterSet();
      nsCOMPtr<nsIURI> uri;
      nsresult rv = NS_NewURI(getter_AddRefs(uri),
                              relative,
                              charset.get(),
                              aBuilder->GetViewSourceBaseURI());
      NS_ENSURE_SUCCESS(rv, NS_OK);

      // Reuse the fix for bug 467852
      // URLs that execute script (e.g. "javascript:" URLs) should just be
      // ignored.  There's nothing reasonable we can do with them, and allowing
      // them to execute in the context of the view-source window presents a
      // security risk.  Just return the empty string in this case.
      bool openingExecutesScript = false;
      rv = NS_URIChainHasFlags(uri,
                               nsIProtocolHandler::URI_OPENING_EXECUTES_SCRIPT,
                               &openingExecutesScript);
      if (NS_FAILED(rv) || openingExecutesScript) {
        return NS_OK;
      }

      nsAutoCString viewSourceUrl;

      // URLs that return data (e.g. "http:" URLs) should be prefixed with
      // "view-source:".  URLs that don't return data should just be returned
      // undecorated.
      bool doesNotReturnData = false;
      rv = NS_URIChainHasFlags(uri,
                               nsIProtocolHandler::URI_DOES_NOT_RETURN_DATA,
                               &doesNotReturnData);
      NS_ENSURE_SUCCESS(rv, NS_OK);
      if (!doesNotReturnData) {
        viewSourceUrl.AssignLiteral("view-source:");
      }

      nsAutoCString spec;
      rv = uri->GetSpec(spec);
      NS_ENSURE_SUCCESS(rv, rv);

      viewSourceUrl.Append(spec);

      nsAutoString utf16;
      CopyUTF8toUTF16(viewSourceUrl, utf16);

      node->SetAttr(kNameSpaceID_None, nsGkAtoms::href, utf16, true);
      return NS_OK;
    }
    case eTreeOpAddViewSourceBase: {
      char16_t* buffer = mTwo.unicharPtr;
      int32_t length = mFour.integer;
      nsDependentString baseUrl(buffer, length);
      aBuilder->AddBase(baseUrl);
      return NS_OK;
    }
    case eTreeOpAddError: {
      nsIContent* node = *(mOne.node);
      char* msgId = mTwo.charPtr;
      nsCOMPtr<nsIAtom> atom = Reget(mThree.atom);
      nsCOMPtr<nsIAtom> otherAtom = Reget(mFour.atom);
      // See viewsource.css for the possible classes in addition to "error".
      nsAutoString klass;
      node->GetAttr(kNameSpaceID_None, nsGkAtoms::_class, klass);
      if (!klass.IsEmpty()) {
        klass.AppendLiteral(" error");
        node->SetAttr(kNameSpaceID_None, nsGkAtoms::_class, klass, true);
      } else {
        node->SetAttr(kNameSpaceID_None,
                      nsGkAtoms::_class,
                      NS_LITERAL_STRING("error"),
                      true);
      }

      nsresult rv;
      nsXPIDLString message;
      if (otherAtom) {
        const char16_t* params[] = { atom->GetUTF16String(),
                                      otherAtom->GetUTF16String() };
        rv = nsContentUtils::FormatLocalizedString(
          nsContentUtils::eHTMLPARSER_PROPERTIES, msgId, params, message);
        NS_ENSURE_SUCCESS(rv, NS_OK);
      } else if (atom) {
        const char16_t* params[] = { atom->GetUTF16String() };
        rv = nsContentUtils::FormatLocalizedString(
          nsContentUtils::eHTMLPARSER_PROPERTIES, msgId, params, message);
        NS_ENSURE_SUCCESS(rv, NS_OK);
      } else {
        rv = nsContentUtils::GetLocalizedString(
          nsContentUtils::eHTMLPARSER_PROPERTIES, msgId, message);
        NS_ENSURE_SUCCESS(rv, NS_OK);
      }

      nsAutoString title;
      node->GetAttr(kNameSpaceID_None, nsGkAtoms::title, title);
      if (!title.IsEmpty()) {
        title.Append('\n');
        title.Append(message);
        node->SetAttr(kNameSpaceID_None, nsGkAtoms::title, title, true);
      } else {
        node->SetAttr(kNameSpaceID_None, nsGkAtoms::title, message, true);
      }
      return rv;
    }
    case eTreeOpAddLineNumberId: {
      nsIContent* node = *(mOne.node);
      int32_t lineNumber = mFour.integer;
      nsAutoString val(NS_LITERAL_STRING("line"));
      val.AppendInt(lineNumber);
      node->SetAttr(kNameSpaceID_None, nsGkAtoms::id, val, true);
      return NS_OK;
    }
    case eTreeOpStartLayout: {
      aBuilder->StartLayout(); // this causes a notification flush anyway
      return NS_OK;
    }
    default: {
      MOZ_CRASH("Bogus tree op");
    }
  }
  return NS_OK; // keep compiler happy
}
