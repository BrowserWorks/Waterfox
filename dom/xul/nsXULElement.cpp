/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *
 * This Original Code has been modified by IBM Corporation.
 * Modifications made by IBM described herein are
 * Copyright (c) International Business Machines
 * Corporation, 2000
 *
 * Modifications to Mozilla code or documentation
 * identified per MPL Section 3.3
 *
 * Date         Modified by     Description of modification
 * 03/27/2000   IBM Corp.       Added PR_CALLBACK for Optlink
 *                               use in OS2
 */

#include "nsCOMPtr.h"
#include "nsDOMCID.h"
#include "nsError.h"
#include "nsDOMString.h"
#include "nsIDOMEvent.h"
#include "nsIAtom.h"
#include "nsIBaseWindow.h"
#include "nsIDOMAttr.h"
#include "nsIDOMDocument.h"
#include "nsIDOMElement.h"
#include "nsIDOMEventListener.h"
#include "nsIDOMNodeList.h"
#include "nsIDOMXULCommandDispatcher.h"
#include "nsIDOMXULElement.h"
#include "nsIDOMXULSelectCntrlItemEl.h"
#include "nsIDocument.h"
#include "nsLayoutStylesheetCache.h"
#include "mozilla/AsyncEventDispatcher.h"
#include "mozilla/ClearOnShutdown.h"
#include "mozilla/EventListenerManager.h"
#include "mozilla/EventStateManager.h"
#include "mozilla/EventStates.h"
#include "mozilla/DeclarationBlockInlines.h"
#include "nsFocusManager.h"
#include "nsHTMLStyleSheet.h"
#include "nsNameSpaceManager.h"
#include "nsIObjectInputStream.h"
#include "nsIObjectOutputStream.h"
#include "nsIPresShell.h"
#include "nsIPrincipal.h"
#include "nsIRDFCompositeDataSource.h"
#include "nsIRDFNode.h"
#include "nsIRDFService.h"
#include "nsIScriptContext.h"
#include "nsIScriptError.h"
#include "nsIScriptSecurityManager.h"
#include "nsIServiceManager.h"
#include "mozilla/css/StyleRule.h"
#include "nsIURL.h"
#include "nsViewManager.h"
#include "nsIWidget.h"
#include "nsIXULDocument.h"
#include "nsIXULTemplateBuilder.h"
#include "nsLayoutCID.h"
#include "nsContentCID.h"
#include "mozilla/dom/Event.h"
#include "nsRDFCID.h"
#include "nsStyleConsts.h"
#include "nsXPIDLString.h"
#include "nsXULControllers.h"
#include "nsIBoxObject.h"
#include "nsPIBoxObject.h"
#include "XULDocument.h"
#include "nsXULPopupListener.h"
#include "nsRuleWalker.h"
#include "nsIDOMCSSStyleDeclaration.h"
#include "nsCSSParser.h"
#include "ListBoxObject.h"
#include "nsContentUtils.h"
#include "nsContentList.h"
#include "mozilla/InternalMutationEvent.h"
#include "mozilla/MouseEvents.h"
#include "nsIDOMMutationEvent.h"
#include "nsPIDOMWindow.h"
#include "nsJSPrincipals.h"
#include "nsDOMAttributeMap.h"
#include "nsGkAtoms.h"
#include "nsXULContentUtils.h"
#include "nsNodeUtils.h"
#include "nsFrameLoader.h"
#include "mozilla/Logging.h"
#include "rdf.h"
#include "nsIControllers.h"
#include "nsAttrValueOrString.h"
#include "nsAttrValueInlines.h"
#include "mozilla/Attributes.h"
#include "nsIController.h"
#include "nsQueryObject.h"
#include <algorithm>
#include "nsIDOMChromeWindow.h"

// The XUL doc interface
#include "nsIDOMXULDocument.h"

#include "nsReadableUtils.h"
#include "nsIFrame.h"
#include "nsNodeInfoManager.h"
#include "nsXBLBinding.h"
#include "mozilla/EventDispatcher.h"
#include "mozAutoDocUpdate.h"
#include "nsIDOMXULCommandEvent.h"
#include "nsCCUncollectableMarker.h"
#include "nsICSSDeclaration.h"

#include "mozilla/dom/XULElementBinding.h"
#include "mozilla/dom/BoxObject.h"
#include "mozilla/dom/HTMLIFrameElement.h"

using namespace mozilla;
using namespace mozilla::dom;

#ifdef XUL_PROTOTYPE_ATTRIBUTE_METERING
uint32_t             nsXULPrototypeAttribute::gNumElements;
uint32_t             nsXULPrototypeAttribute::gNumAttributes;
uint32_t             nsXULPrototypeAttribute::gNumCacheTests;
uint32_t             nsXULPrototypeAttribute::gNumCacheHits;
uint32_t             nsXULPrototypeAttribute::gNumCacheSets;
uint32_t             nsXULPrototypeAttribute::gNumCacheFills;
#endif

class nsXULElementTearoff final : public nsIFrameLoaderOwner
{
  ~nsXULElementTearoff() {}

public:
  NS_DECL_CYCLE_COLLECTING_ISUPPORTS
  NS_DECL_CYCLE_COLLECTION_CLASS(nsXULElementTearoff)

  explicit nsXULElementTearoff(nsXULElement* aElement)
    : mElement(aElement)
  {
  }

  NS_FORWARD_NSIFRAMELOADEROWNER(static_cast<nsXULElement*>(mElement.get())->)
private:
  nsCOMPtr<nsIDOMXULElement> mElement;
};

NS_IMPL_CYCLE_COLLECTION(nsXULElementTearoff, mElement)

NS_IMPL_CYCLE_COLLECTING_ADDREF(nsXULElementTearoff)
NS_IMPL_CYCLE_COLLECTING_RELEASE(nsXULElementTearoff)

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(nsXULElementTearoff)
  NS_INTERFACE_MAP_ENTRY(nsIFrameLoaderOwner)
NS_INTERFACE_MAP_END_AGGREGATED(mElement)

//----------------------------------------------------------------------
// nsXULElement
//

nsXULElement::nsXULElement(already_AddRefed<mozilla::dom::NodeInfo> aNodeInfo)
    : nsStyledElement(aNodeInfo),
      mBindingParent(nullptr)
{
    XUL_PROTOTYPE_ATTRIBUTE_METER(gNumElements);

    // We may be READWRITE by default; check.
    if (IsReadWriteTextElement()) {
        AddStatesSilently(NS_EVENT_STATE_MOZ_READWRITE);
        RemoveStatesSilently(NS_EVENT_STATE_MOZ_READONLY);
    }
}

nsXULElement::~nsXULElement()
{
}

nsXULElement::nsXULSlots::nsXULSlots()
    : nsXULElement::nsDOMSlots()
{
}

nsXULElement::nsXULSlots::~nsXULSlots()
{
    NS_IF_RELEASE(mControllers); // Forces release
    nsCOMPtr<nsIFrameLoader> frameLoader = do_QueryInterface(mFrameLoaderOrOpener);
    if (frameLoader) {
        static_cast<nsFrameLoader*>(frameLoader.get())->Destroy();
    }
}

void
nsXULElement::nsXULSlots::Traverse(nsCycleCollectionTraversalCallback &cb)
{
    NS_CYCLE_COLLECTION_NOTE_EDGE_NAME(cb, "mSlots->mFrameLoaderOrOpener");
    cb.NoteXPCOMChild(mFrameLoaderOrOpener);
}

nsINode::nsSlots*
nsXULElement::CreateSlots()
{
    return new nsXULSlots();
}

void
nsXULElement::MaybeUpdatePrivateLifetime()
{
    if (AttrValueIs(kNameSpaceID_None, nsGkAtoms::windowtype,
                    NS_LITERAL_STRING("navigator:browser"),
                    eCaseMatters)) {
        return;
    }

    nsPIDOMWindowOuter* win = OwnerDoc()->GetWindow();
    nsCOMPtr<nsIDocShell> docShell = win ? win->GetDocShell() : nullptr;
    if (docShell) {
        docShell->SetAffectPrivateSessionLifetime(false);
    }
}

/* static */
already_AddRefed<nsXULElement>
nsXULElement::Create(nsXULPrototypeElement* aPrototype, mozilla::dom::NodeInfo *aNodeInfo,
                     bool aIsScriptable, bool aIsRoot)
{
    RefPtr<mozilla::dom::NodeInfo> ni = aNodeInfo;
    RefPtr<nsXULElement> element = new nsXULElement(ni.forget());
    if (element) {
        if (aPrototype->mHasIdAttribute) {
            element->SetHasID();
        }
        if (aPrototype->mHasClassAttribute) {
            element->SetFlags(NODE_MAY_HAVE_CLASS);
        }
        if (aPrototype->mHasStyleAttribute) {
            element->SetMayHaveStyle();
        }

        element->MakeHeavyweight(aPrototype);
        if (aIsScriptable) {
            // Check each attribute on the prototype to see if we need to do
            // any additional processing and hookup that would otherwise be
            // done 'automagically' by SetAttr().
            for (uint32_t i = 0; i < aPrototype->mNumAttributes; ++i) {
                element->AddListenerFor(aPrototype->mAttributes[i].mName,
                                        true);
            }
        }

        if (aIsRoot && aPrototype->mNodeInfo->Equals(nsGkAtoms::window)) {
            for (uint32_t i = 0; i < aPrototype->mNumAttributes; ++i) {
                if (aPrototype->mAttributes[i].mName.Equals(nsGkAtoms::windowtype)) {
                    element->MaybeUpdatePrivateLifetime();
                }
            }
        }
    }

    return element.forget();
}

nsresult
nsXULElement::Create(nsXULPrototypeElement* aPrototype,
                     nsIDocument* aDocument,
                     bool aIsScriptable,
                     bool aIsRoot,
                     Element** aResult)
{
    // Create an nsXULElement from a prototype
    NS_PRECONDITION(aPrototype != nullptr, "null ptr");
    if (! aPrototype)
        return NS_ERROR_NULL_POINTER;

    NS_PRECONDITION(aResult != nullptr, "null ptr");
    if (! aResult)
        return NS_ERROR_NULL_POINTER;

    RefPtr<mozilla::dom::NodeInfo> nodeInfo;
    if (aDocument) {
        mozilla::dom::NodeInfo* ni = aPrototype->mNodeInfo;
        nodeInfo = aDocument->NodeInfoManager()->
          GetNodeInfo(ni->NameAtom(), ni->GetPrefixAtom(), ni->NamespaceID(),
                      nsIDOMNode::ELEMENT_NODE);
    } else {
        nodeInfo = aPrototype->mNodeInfo;
    }

    RefPtr<nsXULElement> element = Create(aPrototype, nodeInfo,
                                            aIsScriptable, aIsRoot);
    element.forget(aResult);

    return NS_OK;
}

nsresult
NS_NewXULElement(Element** aResult, already_AddRefed<mozilla::dom::NodeInfo>&& aNodeInfo)
{
    RefPtr<mozilla::dom::NodeInfo> ni = aNodeInfo;

    NS_PRECONDITION(ni, "need nodeinfo for non-proto Create");

    nsIDocument* doc = ni->GetDocument();
    if (doc && !doc->AllowXULXBL()) {
        return NS_ERROR_NOT_AVAILABLE;
    }

    NS_ADDREF(*aResult = new nsXULElement(ni.forget()));

    return NS_OK;
}

void
NS_TrustedNewXULElement(nsIContent** aResult,
                        already_AddRefed<mozilla::dom::NodeInfo>&& aNodeInfo)
{
    RefPtr<mozilla::dom::NodeInfo> ni = aNodeInfo;
    NS_PRECONDITION(ni, "need nodeinfo for non-proto Create");

    // Create an nsXULElement with the specified namespace and tag.
    NS_ADDREF(*aResult = new nsXULElement(ni.forget()));
}

//----------------------------------------------------------------------
// nsISupports interface

NS_IMPL_CYCLE_COLLECTION_CLASS(nsXULElement)

NS_IMPL_CYCLE_COLLECTION_TRAVERSE_BEGIN_INHERITED(nsXULElement,
                                                  nsStyledElement)
    {
        nsXULSlots* slots = static_cast<nsXULSlots*>(tmp->GetExistingSlots());
        if (slots) {
            slots->Traverse(cb);
        }
    }
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_END

NS_IMPL_CYCLE_COLLECTION_UNLINK_BEGIN_INHERITED(nsXULElement,
                                                nsStyledElement)
    // Why aren't we unlinking the prototype?
    tmp->ClearHasID();
NS_IMPL_CYCLE_COLLECTION_UNLINK_END

NS_IMPL_ADDREF_INHERITED(nsXULElement, nsStyledElement)
NS_IMPL_RELEASE_INHERITED(nsXULElement, nsStyledElement)

NS_INTERFACE_TABLE_HEAD_CYCLE_COLLECTION_INHERITED(nsXULElement)
    NS_INTERFACE_TABLE_INHERITED(nsXULElement, nsIDOMNode, nsIDOMElement,
                                 nsIDOMXULElement)
    NS_ELEMENT_INTERFACE_TABLE_TO_MAP_SEGUE
    NS_INTERFACE_MAP_ENTRY_TEAROFF(nsIFrameLoaderOwner,
                                   new nsXULElementTearoff(this))
NS_INTERFACE_MAP_END_INHERITING(nsStyledElement)

//----------------------------------------------------------------------
// nsIDOMNode interface

nsresult
nsXULElement::Clone(mozilla::dom::NodeInfo *aNodeInfo, nsINode **aResult) const
{
    *aResult = nullptr;

    RefPtr<mozilla::dom::NodeInfo> ni = aNodeInfo;
    RefPtr<nsXULElement> element = new nsXULElement(ni.forget());

    // XXX TODO: set up RDF generic builder n' stuff if there is a
    // 'datasources' attribute? This is really kind of tricky,
    // because then we'd need to -selectively- copy children that
    // -weren't- generated from RDF. Ugh. Forget it.

    // Note that we're _not_ copying mControllers.

    uint32_t count = mAttrsAndChildren.AttrCount();
    nsresult rv = NS_OK;
    for (uint32_t i = 0; i < count; ++i) {
        const nsAttrName* originalName = mAttrsAndChildren.AttrNameAt(i);
        const nsAttrValue* originalValue = mAttrsAndChildren.AttrAt(i);
        nsAttrValue attrValue;

        // Style rules need to be cloned.
        if (originalValue->Type() == nsAttrValue::eCSSDeclaration) {
            DeclarationBlock* decl = originalValue->GetCSSDeclarationValue();
            RefPtr<css::Declaration>
              declClone = new css::Declaration(*decl->AsGecko());

            nsString stringValue;
            originalValue->ToString(stringValue);

            attrValue.SetTo(declClone.forget(), &stringValue);
        } else {
            attrValue.SetTo(*originalValue);
        }

        if (originalName->IsAtom()) {
           rv = element->mAttrsAndChildren.SetAndSwapAttr(originalName->Atom(),
                                                          attrValue);
        } else {
            rv = element->mAttrsAndChildren.SetAndSwapAttr(originalName->NodeInfo(),
                                                           attrValue);
        }
        NS_ENSURE_SUCCESS(rv, rv);
        element->AddListenerFor(*originalName, true);
        if (originalName->Equals(nsGkAtoms::id) &&
            !originalValue->IsEmptyString()) {
            element->SetHasID();
        }
        if (originalName->Equals(nsGkAtoms::_class)) {
            element->SetFlags(NODE_MAY_HAVE_CLASS);
        }
        if (originalName->Equals(nsGkAtoms::style)) {
            element->SetMayHaveStyle();
        }
    }

    element.forget(aResult);
    return rv;
}

//----------------------------------------------------------------------

NS_IMETHODIMP
nsXULElement::GetElementsByAttribute(const nsAString& aAttribute,
                                     const nsAString& aValue,
                                     nsIDOMNodeList** aReturn)
{
    *aReturn = GetElementsByAttribute(aAttribute, aValue).take();
    return NS_OK;
}

already_AddRefed<nsINodeList>
nsXULElement::GetElementsByAttribute(const nsAString& aAttribute,
                                     const nsAString& aValue)
{
    nsCOMPtr<nsIAtom> attrAtom(NS_Atomize(aAttribute));
    void* attrValue = new nsString(aValue);
    RefPtr<nsContentList> list =
        new nsContentList(this,
                          XULDocument::MatchAttribute,
                          nsContentUtils::DestroyMatchString,
                          attrValue,
                          true,
                          attrAtom,
                          kNameSpaceID_Unknown);
    return list.forget();
}

NS_IMETHODIMP
nsXULElement::GetElementsByAttributeNS(const nsAString& aNamespaceURI,
                                       const nsAString& aAttribute,
                                       const nsAString& aValue,
                                       nsIDOMNodeList** aReturn)
{
    ErrorResult rv;
    *aReturn =
        GetElementsByAttributeNS(aNamespaceURI, aAttribute, aValue, rv).take();
    return rv.StealNSResult();
}

already_AddRefed<nsINodeList>
nsXULElement::GetElementsByAttributeNS(const nsAString& aNamespaceURI,
                                       const nsAString& aAttribute,
                                       const nsAString& aValue,
                                       ErrorResult& rv)
{
    nsCOMPtr<nsIAtom> attrAtom(NS_Atomize(aAttribute));

    int32_t nameSpaceId = kNameSpaceID_Wildcard;
    if (!aNamespaceURI.EqualsLiteral("*")) {
      rv =
        nsContentUtils::NameSpaceManager()->RegisterNameSpace(aNamespaceURI,
                                                              nameSpaceId);
      if (rv.Failed()) {
          return nullptr;
      }
    }

    void* attrValue = new nsString(aValue);
    RefPtr<nsContentList> list =
        new nsContentList(this,
                          XULDocument::MatchAttribute,
                          nsContentUtils::DestroyMatchString,
                          attrValue,
                          true,
                          attrAtom,
                          nameSpaceId);

    return list.forget();
}

EventListenerManager*
nsXULElement::GetEventListenerManagerForAttr(nsIAtom* aAttrName, bool* aDefer)
{
    // XXXbz sXBL/XBL2 issue: should we instead use GetComposedDoc()
    // here, override BindToTree for those classes and munge event
    // listeners there?
    nsIDocument* doc = OwnerDoc();

    nsPIDOMWindowInner *window;
    Element *root = doc->GetRootElement();
    if ((!root || root == this) && !mNodeInfo->Equals(nsGkAtoms::overlay) &&
        (window = doc->GetInnerWindow())) {

        nsCOMPtr<EventTarget> piTarget = do_QueryInterface(window);

        *aDefer = false;
        return piTarget->GetOrCreateListenerManager();
    }

    return nsStyledElement::GetEventListenerManagerForAttr(aAttrName, aDefer);
}

// returns true if the element is not a list
static bool IsNonList(mozilla::dom::NodeInfo* aNodeInfo)
{
  return !aNodeInfo->Equals(nsGkAtoms::tree) &&
         !aNodeInfo->Equals(nsGkAtoms::listbox) &&
         !aNodeInfo->Equals(nsGkAtoms::richlistbox);
}

bool
nsXULElement::IsFocusableInternal(int32_t *aTabIndex, bool aWithMouse)
{
  /*
   * Returns true if an element may be focused, and false otherwise. The inout
   * argument aTabIndex will be set to the tab order index to be used; -1 for
   * elements that should not be part of the tab order and a greater value to
   * indicate its tab order.
   *
   * Confusingly, the supplied value for the aTabIndex argument may indicate
   * whether the element may be focused as a result of the -moz-user-focus
   * property, where -1 means no and 0 means yes.
   *
   * For controls, the element cannot be focused and is not part of the tab
   * order if it is disabled.
   *
   * Controls (those that implement nsIDOMXULControlElement):
   *  *aTabIndex = -1  no tabindex     Not focusable or tabbable
   *  *aTabIndex = -1  tabindex="-1"   Not focusable or tabbable
   *  *aTabIndex = -1  tabindex=">=0"  Focusable and tabbable
   *  *aTabIndex >= 0  no tabindex     Focusable and tabbable
   *  *aTabIndex >= 0  tabindex="-1"   Focusable but not tabbable
   *  *aTabIndex >= 0  tabindex=">=0"  Focusable and tabbable
   * Non-controls:
   *  *aTabIndex = -1                  Not focusable or tabbable
   *  *aTabIndex >= 0                  Focusable and tabbable
   *
   * If aTabIndex is null, then the tabindex is not computed, and
   * true is returned for non-disabled controls and false otherwise.
   */

  // elements are not focusable by default
  bool shouldFocus = false;

#ifdef XP_MACOSX
  // on Mac, mouse interactions only focus the element if it's a list,
  // or if it's a remote target, since the remote target must handle
  // the focus.
  if (aWithMouse &&
      IsNonList(mNodeInfo) &&
      !EventStateManager::IsRemoteTarget(this))
  {
    return false;
  }
#endif

  nsCOMPtr<nsIDOMXULControlElement> xulControl = do_QueryObject(this);
  if (xulControl) {
    // a disabled element cannot be focused and is not part of the tab order
    bool disabled;
    xulControl->GetDisabled(&disabled);
    if (disabled) {
      if (aTabIndex)
        *aTabIndex = -1;
      return false;
    }
    shouldFocus = true;
  }

  if (aTabIndex) {
    if (xulControl) {
      if (HasAttr(kNameSpaceID_None, nsGkAtoms::tabindex)) {
        // if either the aTabIndex argument or a specified tabindex is non-negative,
        // the element becomes focusable.
        int32_t tabIndex = 0;
        xulControl->GetTabIndex(&tabIndex);
        shouldFocus = *aTabIndex >= 0 || tabIndex >= 0;
        *aTabIndex = tabIndex;
      } else {
        // otherwise, if there is no tabindex attribute, just use the value of
        // *aTabIndex to indicate focusability. Reset any supplied tabindex to 0.
        shouldFocus = *aTabIndex >= 0;
        if (shouldFocus)
          *aTabIndex = 0;
      }

      if (shouldFocus && sTabFocusModelAppliesToXUL &&
          !(sTabFocusModel & eTabFocus_formElementsMask)) {
        // By default, the tab focus model doesn't apply to xul element on any system but OS X.
        // on OS X we're following it for UI elements (XUL) as sTabFocusModel is based on
        // "Full Keyboard Access" system setting (see mac/nsILookAndFeel).
        // both textboxes and list elements (i.e. trees and list) should always be focusable
        // (textboxes are handled as html:input)
        // For compatibility, we only do this for controls, otherwise elements like <browser>
        // cannot take this focus.
        if (IsNonList(mNodeInfo))
          *aTabIndex = -1;
      }
    } else {
      shouldFocus = *aTabIndex >= 0;
    }
  }

  return shouldFocus;
}

bool
nsXULElement::PerformAccesskey(bool aKeyCausesActivation,
                               bool aIsTrustedEvent)
{
    nsCOMPtr<nsIContent> content(this);

    if (IsXULElement(nsGkAtoms::label)) {
        nsCOMPtr<nsIDOMElement> element;

        nsAutoString control;
        GetAttr(kNameSpaceID_None, nsGkAtoms::control, control);
        if (!control.IsEmpty()) {
            //XXXsmaug Should we use ShadowRoot::GetElementById in case
            //         content is in Shadow DOM?
            nsCOMPtr<nsIDOMDocument> domDocument =
                do_QueryInterface(content->GetUncomposedDoc());
            if (domDocument)
                domDocument->GetElementById(control, getter_AddRefs(element));
        }
        // here we'll either change |content| to the element referenced by
        // |element|, or clear it.
        content = do_QueryInterface(element);

        if (!content) {
            return false;
        }
    }

    nsIFrame* frame = content->GetPrimaryFrame();
    if (!frame || !frame->IsVisibleConsideringAncestors()) {
        return false;
    }

    bool focused = false;
    nsXULElement* elm = FromContent(content);
    if (elm) {
        // Define behavior for each type of XUL element.
        if (!content->IsXULElement(nsGkAtoms::toolbarbutton)) {
          nsIFocusManager* fm = nsFocusManager::GetFocusManager();
          if (fm) {
            nsCOMPtr<nsIDOMElement> elementToFocus;
            // for radio buttons, focus the radiogroup instead
            if (content->IsXULElement(nsGkAtoms::radio)) {
              nsCOMPtr<nsIDOMXULSelectControlItemElement> controlItem(do_QueryInterface(content));
              if (controlItem) {
                bool disabled;
                controlItem->GetDisabled(&disabled);
                if (!disabled) {
                  nsCOMPtr<nsIDOMXULSelectControlElement> selectControl;
                  controlItem->GetControl(getter_AddRefs(selectControl));
                  elementToFocus = do_QueryInterface(selectControl);
                }
              }
            } else {
              elementToFocus = do_QueryInterface(content);
            }
            if (elementToFocus) {
              fm->SetFocus(elementToFocus, nsIFocusManager::FLAG_BYKEY);

              // Return true if the element became focused.
              nsPIDOMWindowOuter* window = OwnerDoc()->GetWindow();
              focused = (window && window->GetFocusedNode());
            }
          }
        }
        if (aKeyCausesActivation &&
            !content->IsAnyOfXULElements(nsGkAtoms::textbox, nsGkAtoms::menulist)) {
          elm->ClickWithInputSource(nsIDOMMouseEvent::MOZ_SOURCE_KEYBOARD, aIsTrustedEvent);
        }
    } else {
        return content->PerformAccesskey(aKeyCausesActivation, aIsTrustedEvent);
    }

    return focused;
}

//----------------------------------------------------------------------

void
nsXULElement::AddListenerFor(const nsAttrName& aName,
                             bool aCompileEventHandlers)
{
    // If appropriate, add a popup listener and/or compile the event
    // handler. Called when we change the element's document, create a
    // new element, change an attribute's value, etc.
    // Eventlistenener-attributes are always in the null namespace
    if (aName.IsAtom()) {
        nsIAtom *attr = aName.Atom();
        MaybeAddPopupListener(attr);
        if (aCompileEventHandlers &&
            nsContentUtils::IsEventAttributeName(attr, EventNameType_XUL)) {
            nsAutoString value;
            GetAttr(kNameSpaceID_None, attr, value);
            SetEventHandler(attr, value, true);
        }
    }
}

void
nsXULElement::MaybeAddPopupListener(nsIAtom* aLocalName)
{
    // If appropriate, add a popup listener. Called when we change the
    // element's document, create a new element, change an attribute's
    // value, etc.
    if (aLocalName == nsGkAtoms::menu ||
        aLocalName == nsGkAtoms::contextmenu ||
        // XXXdwh popup and context are deprecated
        aLocalName == nsGkAtoms::popup ||
        aLocalName == nsGkAtoms::context) {
        AddPopupListener(aLocalName);
    }
}

//----------------------------------------------------------------------
//
// nsIContent interface
//
void
nsXULElement::UpdateEditableState(bool aNotify)
{
    // Don't call through to Element here because the things
    // it does don't work for cases when we're an editable control.
    nsIContent *parent = GetParent();

    SetEditableFlag(parent && parent->HasFlag(NODE_IS_EDITABLE));
    UpdateState(aNotify);
}

/**
 * Returns true if the user-agent style sheet rules for this XUL element are
 * in minimal-xul.css instead of xul.css.
 */
static inline bool XULElementsRulesInMinimalXULSheet(nsIAtom* aTag)
{
  return // scrollbar parts:
         aTag == nsGkAtoms::scrollbar ||
         aTag == nsGkAtoms::scrollbarbutton ||
         aTag == nsGkAtoms::scrollcorner ||
         aTag == nsGkAtoms::slider ||
         aTag == nsGkAtoms::thumb ||
         aTag == nsGkAtoms::scale ||
         // other
         aTag == nsGkAtoms::resizer ||
         aTag == nsGkAtoms::label ||
         aTag == nsGkAtoms::videocontrols;
}

#ifdef DEBUG
/**
 * Returns true if aElement is a XUL element created by the video controls
 * binding. HTML <video> and <audio> bindings pull in this binding. This
 * binding creates lots of different types of XUL elements.
 */
static inline bool
IsInVideoControls(nsXULElement* aElement)
{
  nsIContent* ancestor = aElement->GetParent();
  while (ancestor) {
    if (ancestor->NodeInfo()->Equals(nsGkAtoms::videocontrols, kNameSpaceID_XUL)) {
      return true;
    }
    ancestor = ancestor->GetParent();
  }
  return false;
}

/**
 * Returns true if aElement is an element created by the <binding
 * id="feedreaderUI"> binding or one of the bindings bound to such an element.
 * element in one of the binding for such an element. Only
 * subscribe.xhtml#feedSubscribeLine pulls in the feedreaderUI binding. This
 * binding creates lots of different types of XUL elements.
 */
bool
IsInFeedSubscribeLine(nsXULElement* aElement)
{
  nsIContent* bindingParent = aElement->GetBindingParent();
  if (bindingParent) {
    while (bindingParent->GetBindingParent()) {
      bindingParent = bindingParent->GetBindingParent();
    }
    nsIAtom* idAtom = bindingParent->GetID();
    if (idAtom && idAtom->Equals(NS_LITERAL_STRING("feedSubscribeLine"))) {
      return true;
    }
  }
  return false;
}
#endif

class XULInContentErrorReporter : public Runnable
{
public:
  explicit XULInContentErrorReporter(nsIDocument* aDocument) : mDocument(aDocument) {}

  NS_IMETHOD Run() override
  {
    mDocument->WarnOnceAbout(nsIDocument::eImportXULIntoContent, false);
    return NS_OK;
  }

private:
  nsCOMPtr<nsIDocument> mDocument;
};

nsresult
nsXULElement::BindToTree(nsIDocument* aDocument,
                         nsIContent* aParent,
                         nsIContent* aBindingParent,
                         bool aCompileEventHandlers)
{
  if (!aBindingParent &&
      aDocument &&
      !aDocument->IsLoadedAsInteractiveData() &&
      !aDocument->AllowXULXBL() &&
      !aDocument->HasWarnedAbout(nsIDocument::eImportXULIntoContent)) {
    nsContentUtils::AddScriptRunner(new XULInContentErrorReporter(aDocument));
  }

  nsresult rv = nsStyledElement::BindToTree(aDocument, aParent,
                                            aBindingParent,
                                            aCompileEventHandlers);
  NS_ENSURE_SUCCESS(rv, rv);

  nsIDocument* doc = GetComposedDoc();
  if (doc &&
      !doc->LoadsFullXULStyleSheetUpFront() &&
      !doc->IsUnstyledDocument()) {

    // To save CPU cycles and memory, non-XUL documents only load the user
    // agent style sheet rules for a minimal set of XUL elements such as
    // 'scrollbar' that may be created implicitly for their content (those
    // rules being in minimal-xul.css).  This is where we make sure that all
    // the other XUL UA style sheet rules (xul.css) have been loaded if the
    // minimal set is not sufficient.
    //
    // We do this during binding, not element construction, because elements
    // can be moved from the document that creates them to another document.

    if (!XULElementsRulesInMinimalXULSheet(NodeInfo()->NameAtom())) {
      auto cache = nsLayoutStylesheetCache::For(doc->GetStyleBackendType());
      doc->EnsureOnDemandBuiltInUASheet(cache->XULSheet());
      // To keep memory usage down it is important that we try and avoid
      // pulling xul.css into non-XUL documents. That should be very rare, and
      // for HTML we currently should only pull it in if the document contains
      // an <audio> or <video> element. This assertion is here to make sure
      // that we don't fail to notice if a change to bindings causes us to
      // start pulling in xul.css much more frequently. If this assertion
      // fails then we need to figure out why, and how we can continue to avoid
      // pulling in xul.css.
      // Note that add-ons may introduce bindings that cause this assertion to
      // fire.
      NS_ASSERTION(IsInVideoControls(this) ||
                   IsInFeedSubscribeLine(this) ||
                   IsXULElement(nsGkAtoms::datetimebox),
                   "Unexpected XUL element in non-XUL doc");
    }
  }

  if (aDocument) {
      NS_ASSERTION(!nsContentUtils::IsSafeToRunScript(),
                   "Missing a script blocker!");
      // We're in a document now.  Kick off the frame load.
      LoadSrc();
  }

  return rv;
}

void
nsXULElement::UnbindFromTree(bool aDeep, bool aNullParent)
{
    // mControllers can own objects that are implemented
    // in JavaScript (such as some implementations of
    // nsIControllers.  These objects prevent their global
    // object's script object from being garbage collected,
    // which means JS continues to hold an owning reference
    // to the nsGlobalWindow, which owns the document,
    // which owns this content.  That's a cycle, so we break
    // it here.  (It might be better to break this by releasing
    // mDocument in nsGlobalWindow::SetDocShell, but I'm not
    // sure whether that would fix all possible cycles through
    // mControllers.)
    nsXULSlots* slots = static_cast<nsXULSlots*>(GetExistingDOMSlots());
    if (slots) {
        NS_IF_RELEASE(slots->mControllers);
        RefPtr<nsFrameLoader> frameLoader = GetFrameLoader();
        if (frameLoader) {
            frameLoader->Destroy();
        }
        slots->mFrameLoaderOrOpener = nullptr;
    }

    nsStyledElement::UnbindFromTree(aDeep, aNullParent);
}

void
nsXULElement::RemoveChildAt(uint32_t aIndex, bool aNotify)
{
    nsCOMPtr<nsIContent> oldKid = mAttrsAndChildren.GetSafeChildAt(aIndex);
    if (!oldKid) {
      return;
    }

    // On the removal of a <treeitem>, <treechildren>, or <treecell> element,
    // the possibility exists that some of the items in the removed subtree
    // are selected (and therefore need to be deselected). We need to account for this.
    nsCOMPtr<nsIDOMXULMultiSelectControlElement> controlElement;
    nsCOMPtr<nsIListBoxObject> listBox;
    bool fireSelectionHandler = false;

    // -1 = do nothing, -2 = null out current item
    // anything else = index to re-set as current
    int32_t newCurrentIndex = -1;

    if (oldKid->NodeInfo()->Equals(nsGkAtoms::listitem, kNameSpaceID_XUL)) {
      // This is the nasty case. We have (potentially) a slew of selected items
      // and cells going away.
      // First, retrieve the tree.
      // Check first whether this element IS the tree
      controlElement = do_QueryObject(this);

      // If it's not, look at our parent
      if (!controlElement)
        GetParentTree(getter_AddRefs(controlElement));
      nsCOMPtr<nsIDOMXULElement> xulElement(do_QueryInterface(controlElement));

      nsCOMPtr<nsIDOMElement> oldKidElem = do_QueryInterface(oldKid);
      if (xulElement && oldKidElem) {
        // Iterate over all of the items and find out if they are contained inside
        // the removed subtree.
        int32_t length;
        controlElement->GetSelectedCount(&length);
        for (int32_t i = 0; i < length; i++) {
          nsCOMPtr<nsIDOMXULSelectControlItemElement> node;
          controlElement->MultiGetSelectedItem(i, getter_AddRefs(node));
          // we need to QI here to do an XPCOM-correct pointercompare
          nsCOMPtr<nsIDOMElement> selElem = do_QueryInterface(node);
          if (selElem == oldKidElem &&
              NS_SUCCEEDED(controlElement->RemoveItemFromSelection(node))) {
            length--;
            i--;
            fireSelectionHandler = true;
          }
        }

        nsCOMPtr<nsIDOMXULSelectControlItemElement> curItem;
        controlElement->GetCurrentItem(getter_AddRefs(curItem));
        nsCOMPtr<nsIContent> curNode = do_QueryInterface(curItem);
        if (curNode && nsContentUtils::ContentIsDescendantOf(curNode, oldKid)) {
            // Current item going away
            nsCOMPtr<nsIBoxObject> box;
            xulElement->GetBoxObject(getter_AddRefs(box));
            listBox = do_QueryInterface(box);
            if (listBox && oldKidElem) {
              listBox->GetIndexOfItem(oldKidElem, &newCurrentIndex);
            }

            // If any of this fails, we'll just set the current item to null
            if (newCurrentIndex == -1)
              newCurrentIndex = -2;
        }
      }
    }

    nsStyledElement::RemoveChildAt(aIndex, aNotify);

    if (newCurrentIndex == -2) {
        controlElement->SetCurrentItem(nullptr);
    } else if (newCurrentIndex > -1) {
        // Make sure the index is still valid
        int32_t treeRows;
        listBox->GetRowCount(&treeRows);
        if (treeRows > 0) {
            newCurrentIndex = std::min((treeRows - 1), newCurrentIndex);
            nsCOMPtr<nsIDOMElement> newCurrentItem;
            listBox->GetItemAtIndex(newCurrentIndex, getter_AddRefs(newCurrentItem));
            nsCOMPtr<nsIDOMXULSelectControlItemElement> xulCurItem = do_QueryInterface(newCurrentItem);
            if (xulCurItem)
                controlElement->SetCurrentItem(xulCurItem);
        } else {
            controlElement->SetCurrentItem(nullptr);
        }
    }

    nsIDocument* doc;
    if (fireSelectionHandler && (doc = GetComposedDoc())) {
      nsContentUtils::DispatchTrustedEvent(doc,
                                           static_cast<nsIContent*>(this),
                                           NS_LITERAL_STRING("select"),
                                           false,
                                           true);
    }
}

void
nsXULElement::UnregisterAccessKey(const nsAString& aOldValue)
{
    // If someone changes the accesskey, unregister the old one
    //
    nsIDocument* doc = GetComposedDoc();
    if (doc && !aOldValue.IsEmpty()) {
        nsIPresShell *shell = doc->GetShell();

        if (shell) {
            nsIContent *content = this;

            // find out what type of content node this is
            if (mNodeInfo->Equals(nsGkAtoms::label)) {
                // For anonymous labels the unregistering must
                // occur on the binding parent control.
                // XXXldb: And what if the binding parent is null?
                content = GetBindingParent();
            }

            if (content) {
                shell->GetPresContext()->EventStateManager()->
                    UnregisterAccessKey(content, aOldValue.First());
            }
        }
    }
}

nsresult
nsXULElement::BeforeSetAttr(int32_t aNamespaceID, nsIAtom* aName,
                            nsAttrValueOrString* aValue, bool aNotify)
{
    if (aNamespaceID == kNameSpaceID_None && aName == nsGkAtoms::accesskey &&
        IsInUncomposedDoc()) {
        nsAutoString oldValue;
        if (GetAttr(aNamespaceID, aName, oldValue)) {
            UnregisterAccessKey(oldValue);
        }
    } else if (aNamespaceID == kNameSpaceID_None &&
               (aName == nsGkAtoms::command || aName == nsGkAtoms::observes) &&
               IsInUncomposedDoc()) {
//         XXX sXBL/XBL2 issue! Owner or current document?
        nsAutoString oldValue;
        GetAttr(kNameSpaceID_None, nsGkAtoms::observes, oldValue);
        if (oldValue.IsEmpty()) {
          GetAttr(kNameSpaceID_None, nsGkAtoms::command, oldValue);
        }

        if (!oldValue.IsEmpty()) {
          RemoveBroadcaster(oldValue);
        }
    } else if (aNamespaceID == kNameSpaceID_None &&
               aValue &&
               mNodeInfo->Equals(nsGkAtoms::window) &&
               aName == nsGkAtoms::chromemargin) {
      nsAttrValue attrValue;
      // Make sure the margin format is valid first
      if (!attrValue.ParseIntMarginValue(aValue->String())) {
        return NS_ERROR_INVALID_ARG;
      }
    } else if (aNamespaceID == kNameSpaceID_None &&
               aName == nsGkAtoms::usercontextid) {
        nsAutoString oldValue;
        bool hasAttribute = GetAttr(kNameSpaceID_None, nsGkAtoms::usercontextid, oldValue);
        if (hasAttribute && (!aValue || !aValue->String().Equals(oldValue))) {
          MOZ_ASSERT(false, "Changing usercontextid is not allowed.");
          return NS_ERROR_INVALID_ARG;
        }
    }

    return nsStyledElement::BeforeSetAttr(aNamespaceID, aName,
                                          aValue, aNotify);
}

nsresult
nsXULElement::AfterSetAttr(int32_t aNamespaceID, nsIAtom* aName,
                           const nsAttrValue* aValue, bool aNotify)
{
    if (aNamespaceID == kNameSpaceID_None) {
        if (aValue) {
            // Add popup and event listeners. We can't call AddListenerFor since
            // the attribute isn't set yet.
            MaybeAddPopupListener(aName);
            if (nsContentUtils::IsEventAttributeName(aName, EventNameType_XUL)) {
                if (aValue->Type() == nsAttrValue::eString) {
                    SetEventHandler(aName, aValue->GetStringValue(), true);
                } else {
                    nsAutoString body;
                    aValue->ToString(body);
                    SetEventHandler(aName, body, true);
                }
            }

            nsIDocument* document = GetUncomposedDoc();

            // Hide chrome if needed
            if (mNodeInfo->Equals(nsGkAtoms::window)) {
                if (aName == nsGkAtoms::hidechrome) {
                    HideWindowChrome(
                      aValue->Equals(NS_LITERAL_STRING("true"), eCaseMatters));
                } else if (aName == nsGkAtoms::chromemargin) {
                    SetChromeMargins(aValue);
                } else if (aName == nsGkAtoms::windowtype &&
                           document && document->GetRootElement() == this) {
                    MaybeUpdatePrivateLifetime();
                }
            }
            // title, (in)activetitlebarcolor and drawintitlebar are settable on
            // any root node (windows, dialogs, etc)
            if (document && document->GetRootElement() == this) {
                if (aName == nsGkAtoms::title) {
                    document->NotifyPossibleTitleChange(false);
                } else if ((aName == nsGkAtoms::activetitlebarcolor ||
                            aName == nsGkAtoms::inactivetitlebarcolor)) {
                    nscolor color = NS_RGBA(0, 0, 0, 0);
                    if (aValue->Type() == nsAttrValue::eColor) {
                        aValue->GetColorValue(color);
                    } else {
                        nsAutoString tmp;
                        nsAttrValue attrValue;
                        aValue->ToString(tmp);
                        attrValue.ParseColor(tmp);
                        attrValue.GetColorValue(color);
                    }
                    SetTitlebarColor(color, aName == nsGkAtoms::activetitlebarcolor);
                } else if (aName == nsGkAtoms::drawintitlebar) {
                    SetDrawsInTitlebar(
                        aValue->Equals(NS_LITERAL_STRING("true"), eCaseMatters));
                } else if (aName == nsGkAtoms::drawtitle) {
                    SetDrawsTitle(
                        aValue->Equals(NS_LITERAL_STRING("true"), eCaseMatters));
                } else if (aName == nsGkAtoms::localedir) {
                    // if the localedir changed on the root element, reset the document direction
                    nsCOMPtr<nsIXULDocument> xuldoc = do_QueryInterface(document);
                    if (xuldoc) {
                        xuldoc->ResetDocumentDirection();
                    }
                } else if (aName == nsGkAtoms::lwtheme ||
                         aName == nsGkAtoms::lwthemetextcolor) {
                    // if the lwtheme changed, make sure to reset the document lwtheme cache
                    nsCOMPtr<nsIXULDocument> xuldoc = do_QueryInterface(document);
                    if (xuldoc) {
                        xuldoc->ResetDocumentLWTheme();
                        UpdateBrightTitlebarForeground(document);
                    }
                } else if (aName == nsGkAtoms::brighttitlebarforeground) {
                    UpdateBrightTitlebarForeground(document);
                }
            }

            if (aName == nsGkAtoms::src && document) {
                LoadSrc();
            }
        } else {
            if (mNodeInfo->Equals(nsGkAtoms::window)) {
                if (aName == nsGkAtoms::hidechrome) {
                    HideWindowChrome(false);
                } else if (aName == nsGkAtoms::chromemargin) {
                    ResetChromeMargins();
                }
            }

            nsIDocument* doc = GetUncomposedDoc();
            if (doc && doc->GetRootElement() == this) {
                if ((aName == nsGkAtoms::activetitlebarcolor ||
                     aName == nsGkAtoms::inactivetitlebarcolor)) {
                    // Use 0, 0, 0, 0 as the "none" color.
                    SetTitlebarColor(NS_RGBA(0, 0, 0, 0), aName == nsGkAtoms::activetitlebarcolor);
                } else if (aName == nsGkAtoms::localedir) {
                    // if the localedir changed on the root element, reset the document direction
                    nsCOMPtr<nsIXULDocument> xuldoc = do_QueryInterface(doc);
                    if (xuldoc) {
                        xuldoc->ResetDocumentDirection();
                    }
                } else if ((aName == nsGkAtoms::lwtheme ||
                            aName == nsGkAtoms::lwthemetextcolor)) {
                    // if the lwtheme changed, make sure to restyle appropriately
                    nsCOMPtr<nsIXULDocument> xuldoc = do_QueryInterface(doc);
                    if (xuldoc) {
                        xuldoc->ResetDocumentLWTheme();
                        UpdateBrightTitlebarForeground(doc);
                    }
                } else if (aName == nsGkAtoms::brighttitlebarforeground) {
                    UpdateBrightTitlebarForeground(doc);
                } else if (aName == nsGkAtoms::drawintitlebar) {
                    SetDrawsInTitlebar(false);
                } else if (aName == nsGkAtoms::drawtitle) {
                    SetDrawsTitle(false);
                }
            }
        }

        // XXX need to check if they're changing an event handler: if
        // so, then we need to unhook the old one.  Or something.
    }

    return nsStyledElement::AfterSetAttr(aNamespaceID, aName,
                                         aValue, aNotify);
}

bool
nsXULElement::ParseAttribute(int32_t aNamespaceID,
                             nsIAtom* aAttribute,
                             const nsAString& aValue,
                             nsAttrValue& aResult)
{
    // Parse into a nsAttrValue
    if (!nsStyledElement::ParseAttribute(aNamespaceID, aAttribute, aValue,
                                         aResult)) {
        // Fall back to parsing as atom for short values
        aResult.ParseStringOrAtom(aValue);
    }

    return true;
}

void
nsXULElement::RemoveBroadcaster(const nsAString & broadcasterId)
{
    nsCOMPtr<nsIDOMXULDocument> xuldoc = do_QueryInterface(OwnerDoc());
    if (xuldoc) {
        nsCOMPtr<nsIDOMElement> broadcaster;
        nsCOMPtr<nsIDOMDocument> domDoc (do_QueryInterface(xuldoc));
        domDoc->GetElementById(broadcasterId, getter_AddRefs(broadcaster));
        if (broadcaster) {
            xuldoc->RemoveBroadcastListenerFor(broadcaster, this,
              NS_LITERAL_STRING("*"));
        }
    }
}

void
nsXULElement::DestroyContent()
{
    nsXULSlots* slots = static_cast<nsXULSlots*>(GetExistingDOMSlots());
    if (slots) {
        NS_IF_RELEASE(slots->mControllers);
        RefPtr<nsFrameLoader> frameLoader = GetFrameLoader();
        if (frameLoader) {
            frameLoader->Destroy();
        }
        slots->mFrameLoaderOrOpener = nullptr;
    }

    nsStyledElement::DestroyContent();
}

#ifdef DEBUG
void
nsXULElement::List(FILE* out, int32_t aIndent) const
{
    nsCString prefix("XUL");
    if (HasSlots()) {
      prefix.Append('*');
    }
    prefix.Append(' ');

    nsStyledElement::List(out, aIndent, prefix);
}
#endif

nsresult
nsXULElement::PreHandleEvent(EventChainPreVisitor& aVisitor)
{
    aVisitor.mForceContentDispatch = true; //FIXME! Bug 329119
    if (IsRootOfNativeAnonymousSubtree() &&
        (IsAnyOfXULElements(nsGkAtoms::scrollbar, nsGkAtoms::scrollcorner)) &&
        (aVisitor.mEvent->mMessage == eMouseClick ||
         aVisitor.mEvent->mMessage == eMouseDoubleClick ||
         aVisitor.mEvent->mMessage == eXULCommand ||
         aVisitor.mEvent->mMessage == eContextMenu ||
         aVisitor.mEvent->mMessage == eDragStart)) {
        // Don't propagate these events from native anonymous scrollbar.
        aVisitor.mCanHandle = true;
        aVisitor.mParentTarget = nullptr;
        return NS_OK;
    }
    if (aVisitor.mEvent->mMessage == eXULCommand &&
        aVisitor.mEvent->mClass == eInputEventClass &&
        aVisitor.mEvent->mOriginalTarget == static_cast<nsIContent*>(this) &&
        !IsXULElement(nsGkAtoms::command)) {
        // Check that we really have an xul command event. That will be handled
        // in a special way.
        nsCOMPtr<nsIDOMXULCommandEvent> xulEvent =
            do_QueryInterface(aVisitor.mDOMEvent);
        // See if we have a command elt.  If so, we execute on the command
        // instead of on our content element.
        nsAutoString command;
        if (xulEvent && GetAttr(kNameSpaceID_None, nsGkAtoms::command, command) &&
            !command.IsEmpty()) {
            // Stop building the event target chain for the original event.
            // We don't want it to propagate to any DOM nodes.
            aVisitor.mCanHandle = false;
            aVisitor.mAutomaticChromeDispatch = false;

            // XXX sXBL/XBL2 issue! Owner or current document?
            nsCOMPtr<nsIDOMDocument> domDoc(do_QueryInterface(GetUncomposedDoc()));
            NS_ENSURE_STATE(domDoc);
            nsCOMPtr<nsIDOMElement> commandElt;
            domDoc->GetElementById(command, getter_AddRefs(commandElt));
            nsCOMPtr<nsIContent> commandContent(do_QueryInterface(commandElt));
            if (commandContent) {
                // Create a new command event to dispatch to the element
                // pointed to by the command attribute.  The new event's
                // sourceEvent will be the original command event that we're
                // handling.
                nsCOMPtr<nsIDOMEvent> domEvent = aVisitor.mDOMEvent;
                while (domEvent) {
                    Event* event = domEvent->InternalDOMEvent();
                    NS_ENSURE_STATE(!SameCOMIdentity(event->GetOriginalTarget(),
                                                     commandContent));
                    nsCOMPtr<nsIDOMXULCommandEvent> commandEvent =
                        do_QueryInterface(domEvent);
                    if (commandEvent) {
                        commandEvent->GetSourceEvent(getter_AddRefs(domEvent));
                    } else {
                        domEvent = nullptr;
                    }
                }

                WidgetInputEvent* orig = aVisitor.mEvent->AsInputEvent();
                nsContentUtils::DispatchXULCommand(
                  commandContent,
                  aVisitor.mEvent->IsTrusted(),
                  aVisitor.mDOMEvent,
                  nullptr,
                  orig->IsControl(),
                  orig->IsAlt(),
                  orig->IsShift(),
                  orig->IsMeta());
            } else {
                NS_WARNING("A XUL element is attached to a command that doesn't exist!\n");
            }
            return NS_OK;
        }
    }

    return nsStyledElement::PreHandleEvent(aVisitor);
}

// XXX This _should_ be an implementation method, _not_ publicly exposed :-(
NS_IMETHODIMP
nsXULElement::GetResource(nsIRDFResource** aResource)
{
    ErrorResult rv;
    *aResource = GetResource(rv).take();
    return rv.StealNSResult();
}

already_AddRefed<nsIRDFResource>
nsXULElement::GetResource(ErrorResult& rv)
{
    nsAutoString id;
    GetAttr(kNameSpaceID_None, nsGkAtoms::ref, id);
    if (id.IsEmpty()) {
        GetAttr(kNameSpaceID_None, nsGkAtoms::id, id);
    }

    if (id.IsEmpty()) {
        return nullptr;
    }

    nsCOMPtr<nsIRDFResource> resource;
    rv = nsXULContentUtils::RDFService()->
        GetUnicodeResource(id, getter_AddRefs(resource));
    return resource.forget();
}

NS_IMETHODIMP
nsXULElement::GetDatabase(nsIRDFCompositeDataSource** aDatabase)
{
    *aDatabase = GetDatabase().take();
    return NS_OK;
}

already_AddRefed<nsIRDFCompositeDataSource>
nsXULElement::GetDatabase()
{
    nsCOMPtr<nsIXULTemplateBuilder> builder = GetBuilder();
    if (!builder) {
        return nullptr;
    }

    nsCOMPtr<nsIRDFCompositeDataSource> database;
    builder->GetDatabase(getter_AddRefs(database));
    return database.forget();
}


NS_IMETHODIMP
nsXULElement::GetBuilder(nsIXULTemplateBuilder** aBuilder)
{
    *aBuilder = GetBuilder().take();
    return NS_OK;
}

already_AddRefed<nsIXULTemplateBuilder>
nsXULElement::GetBuilder()
{
    // XXX sXBL/XBL2 issue! Owner or current document?
    nsCOMPtr<nsIXULDocument> xuldoc = do_QueryInterface(GetUncomposedDoc());
    if (!xuldoc) {
        return nullptr;
    }

    nsCOMPtr<nsIXULTemplateBuilder> builder;
    xuldoc->GetTemplateBuilderFor(this, getter_AddRefs(builder));
    return builder.forget();
}

//----------------------------------------------------------------------
// Implementation methods

NS_IMETHODIMP
nsXULElement::WalkContentStyleRules(nsRuleWalker* aRuleWalker)
{
    return NS_OK;
}

nsChangeHint
nsXULElement::GetAttributeChangeHint(const nsIAtom* aAttribute,
                                     int32_t aModType) const
{
    nsChangeHint retval(nsChangeHint(0));

    if (aAttribute == nsGkAtoms::value &&
        (aModType == nsIDOMMutationEvent::REMOVAL ||
         aModType == nsIDOMMutationEvent::ADDITION)) {
      if (IsAnyOfXULElements(nsGkAtoms::label, nsGkAtoms::description))
        // Label and description dynamically morph between a normal
        // block and a cropping single-line XUL text frame.  If the
        // value attribute is being added or removed, then we need to
        // return a hint of frame change.  (See bugzilla bug 95475 for
        // details.)
        retval = nsChangeHint_ReconstructFrame;
    } else {
        // if left or top changes we reflow. This will happen in xul
        // containers that manage positioned children such as a stack.
        if (nsGkAtoms::left == aAttribute || nsGkAtoms::top == aAttribute ||
            nsGkAtoms::right == aAttribute || nsGkAtoms::bottom == aAttribute ||
            nsGkAtoms::start == aAttribute || nsGkAtoms::end == aAttribute)
            retval = NS_STYLE_HINT_REFLOW;
    }

    return retval;
}

NS_IMETHODIMP_(bool)
nsXULElement::IsAttributeMapped(const nsIAtom* aAttribute) const
{
    return false;
}

// Controllers Methods
NS_IMETHODIMP
nsXULElement::GetControllers(nsIControllers** aResult)
{
    ErrorResult rv;
    NS_IF_ADDREF(*aResult = GetControllers(rv));
    return rv.StealNSResult();
}

nsIControllers*
nsXULElement::GetControllers(ErrorResult& rv)
{
    if (! Controllers()) {
        nsDOMSlots* slots = DOMSlots();

        rv = NS_NewXULControllers(nullptr, NS_GET_IID(nsIControllers),
                                  reinterpret_cast<void**>(&slots->mControllers));

        NS_ASSERTION(!rv.Failed(), "unable to create a controllers");
        if (rv.Failed()) {
            return nullptr;
        }
    }

    return Controllers();
}

NS_IMETHODIMP
nsXULElement::GetBoxObject(nsIBoxObject** aResult)
{
    ErrorResult rv;
    *aResult = GetBoxObject(rv).take();
    return rv.StealNSResult();
}

already_AddRefed<BoxObject>
nsXULElement::GetBoxObject(ErrorResult& rv)
{
    // XXX sXBL/XBL2 issue! Owner or current document?
    return OwnerDoc()->GetBoxObjectFor(this, rv);
}

// Methods for setting/getting attributes from nsIDOMXULElement
#define NS_IMPL_XUL_STRING_ATTR(_method, _atom)                     \
  NS_IMETHODIMP                                                     \
  nsXULElement::Get##_method(nsAString& aReturn)                    \
  {                                                                 \
    GetAttr(kNameSpaceID_None, nsGkAtoms::_atom, aReturn);         \
    return NS_OK;                                                   \
  }                                                                 \
  NS_IMETHODIMP                                                     \
  nsXULElement::Set##_method(const nsAString& aValue)               \
  {                                                                 \
    return SetAttr(kNameSpaceID_None, nsGkAtoms::_atom, aValue,    \
                   true);                                        \
  }

#define NS_IMPL_XUL_BOOL_ATTR(_method, _atom)                       \
  NS_IMETHODIMP                                                     \
  nsXULElement::Get##_method(bool* aResult)                         \
  {                                                                 \
    *aResult = _method();                                           \
    return NS_OK;                                                   \
  }                                                                 \
  NS_IMETHODIMP                                                     \
  nsXULElement::Set##_method(bool aValue)                           \
  {                                                                 \
      SetXULBoolAttr(nsGkAtoms::_atom, aValue);                     \
      return NS_OK;                                                 \
  }


NS_IMPL_XUL_STRING_ATTR(Align, align)
NS_IMPL_XUL_STRING_ATTR(Dir, dir)
NS_IMPL_XUL_STRING_ATTR(Flex, flex)
NS_IMPL_XUL_STRING_ATTR(FlexGroup, flexgroup)
NS_IMPL_XUL_STRING_ATTR(Ordinal, ordinal)
NS_IMPL_XUL_STRING_ATTR(Orient, orient)
NS_IMPL_XUL_STRING_ATTR(Pack, pack)
NS_IMPL_XUL_BOOL_ATTR(Hidden, hidden)
NS_IMPL_XUL_BOOL_ATTR(Collapsed, collapsed)
NS_IMPL_XUL_BOOL_ATTR(AllowEvents, allowevents)
NS_IMPL_XUL_STRING_ATTR(Observes, observes)
NS_IMPL_XUL_STRING_ATTR(Menu, menu)
NS_IMPL_XUL_STRING_ATTR(ContextMenu, contextmenu)
NS_IMPL_XUL_STRING_ATTR(Tooltip, tooltip)
NS_IMPL_XUL_STRING_ATTR(Width, width)
NS_IMPL_XUL_STRING_ATTR(Height, height)
NS_IMPL_XUL_STRING_ATTR(MinWidth, minwidth)
NS_IMPL_XUL_STRING_ATTR(MinHeight, minheight)
NS_IMPL_XUL_STRING_ATTR(MaxWidth, maxwidth)
NS_IMPL_XUL_STRING_ATTR(MaxHeight, maxheight)
NS_IMPL_XUL_STRING_ATTR(Persist, persist)
NS_IMPL_XUL_STRING_ATTR(Left, left)
NS_IMPL_XUL_STRING_ATTR(Top, top)
NS_IMPL_XUL_STRING_ATTR(Datasources, datasources)
NS_IMPL_XUL_STRING_ATTR(Ref, ref)
NS_IMPL_XUL_STRING_ATTR(TooltipText, tooltiptext)
NS_IMPL_XUL_STRING_ATTR(StatusText, statustext)

nsresult
nsXULElement::LoadSrc()
{
    // Allow frame loader only on objects for which a container box object
    // can be obtained.
    if (!IsAnyOfXULElements(nsGkAtoms::browser, nsGkAtoms::editor,
                            nsGkAtoms::iframe)) {
        return NS_OK;
    }
    if (!IsInUncomposedDoc() ||
        !OwnerDoc()->GetRootElement() ||
        OwnerDoc()->GetRootElement()->
            NodeInfo()->Equals(nsGkAtoms::overlay, kNameSpaceID_XUL)) {
        return NS_OK;
    }
    RefPtr<nsFrameLoader> frameLoader = GetFrameLoader();
    if (!frameLoader) {
        // Check if we have an opener we need to be setting
        nsXULSlots* slots = static_cast<nsXULSlots*>(Slots());
        nsCOMPtr<nsPIDOMWindowOuter> opener = do_QueryInterface(slots->mFrameLoaderOrOpener);
        if (!opener) {
            // If we are a content-primary xul-browser, we want to take the opener property!
            nsCOMPtr<nsIDOMChromeWindow> chromeWindow = do_QueryInterface(OwnerDoc()->GetWindow());
            if (AttrValueIs(kNameSpaceID_None, nsGkAtoms::type,
                            NS_LITERAL_STRING("content-primary"), eIgnoreCase) &&
                chromeWindow) {
                nsCOMPtr<mozIDOMWindowProxy> wp;
                chromeWindow->TakeOpenerForInitialContentBrowser(getter_AddRefs(wp));
                opener = nsPIDOMWindowOuter::From(wp);
            }
        }

        // false as the last parameter so that xul:iframe/browser/editor
        // session history handling works like dynamic html:iframes.
        // Usually xul elements are used in chrome, which doesn't have
        // session history at all.
        frameLoader = nsFrameLoader::Create(this, opener, false);
        slots->mFrameLoaderOrOpener = static_cast<nsIFrameLoader*>(frameLoader);
        NS_ENSURE_TRUE(frameLoader, NS_OK);

        (new AsyncEventDispatcher(this,
                                  NS_LITERAL_STRING("XULFrameLoaderCreated"),
                                  /* aBubbles */ true))->RunDOMEventWhenSafe();

        if (AttrValueIs(kNameSpaceID_None, nsGkAtoms::prerendered,
                        NS_LITERAL_STRING("true"), eIgnoreCase)) {
            nsresult rv = frameLoader->SetIsPrerendered();
            NS_ENSURE_SUCCESS(rv,rv);
        }
    }

    return frameLoader->LoadFrame();
}

nsresult
nsXULElement::GetFrameLoaderXPCOM(nsIFrameLoader **aFrameLoader)
{
    *aFrameLoader = GetFrameLoader().take();
    return NS_OK;
}

already_AddRefed<nsFrameLoader>
nsXULElement::GetFrameLoader()
{
    nsXULSlots* slots = static_cast<nsXULSlots*>(GetExistingSlots());
    if (!slots)
        return nullptr;

    nsCOMPtr<nsIFrameLoader> loader = do_QueryInterface(slots->mFrameLoaderOrOpener);
    return already_AddRefed<nsFrameLoader>(static_cast<nsFrameLoader*>(loader.forget().take()));
}

nsresult
nsXULElement::GetParentApplication(mozIApplication** aApplication)
{
    if (!aApplication) {
        return NS_ERROR_FAILURE;
    }

    *aApplication = nullptr;
    return NS_OK;
}

void
nsXULElement::PresetOpenerWindow(mozIDOMWindowProxy* aWindow, ErrorResult& aRv)
{
    nsXULSlots* slots = static_cast<nsXULSlots*>(Slots());
    MOZ_ASSERT(!slots->mFrameLoaderOrOpener, "A frameLoader or opener is present when calling PresetOpenerWindow");

    slots->mFrameLoaderOrOpener = aWindow;
}

nsresult
nsXULElement::SetIsPrerendered()
{
  return SetAttr(kNameSpaceID_None, nsGkAtoms::prerendered, nullptr,
                 NS_LITERAL_STRING("true"), true);
}

void
nsXULElement::InternalSetFrameLoader(nsIFrameLoader* aNewFrameLoader)
{
    nsXULSlots* slots = static_cast<nsXULSlots*>(GetExistingDOMSlots());
    MOZ_ASSERT(slots);

    slots->mFrameLoaderOrOpener = aNewFrameLoader;
}

void
nsXULElement::SwapFrameLoaders(HTMLIFrameElement& aOtherLoaderOwner,
                               ErrorResult& rv)
{
    if (!GetExistingDOMSlots()) {
        rv.Throw(NS_ERROR_NOT_IMPLEMENTED);
        return;
    }

    nsCOMPtr<nsIFrameLoaderOwner> flo = do_QueryInterface(static_cast<nsIDOMXULElement*>(this));
    aOtherLoaderOwner.SwapFrameLoaders(flo, rv);
}

void
nsXULElement::SwapFrameLoaders(nsXULElement& aOtherLoaderOwner,
                               ErrorResult& rv)
{
    if (&aOtherLoaderOwner == this) {
        // nothing to do
        return;
    }

    if (!GetExistingDOMSlots()) {
        rv.Throw(NS_ERROR_NOT_IMPLEMENTED);
        return;
    }

    nsCOMPtr<nsIFrameLoaderOwner> flo = do_QueryInterface(static_cast<nsIDOMXULElement*>(this));
    aOtherLoaderOwner.SwapFrameLoaders(flo, rv);
}

void
nsXULElement::SwapFrameLoaders(nsIFrameLoaderOwner* aOtherLoaderOwner,
                               mozilla::ErrorResult& rv)
{
    if (!GetExistingDOMSlots()) {
        rv.Throw(NS_ERROR_NOT_IMPLEMENTED);
        return;
    }

    RefPtr<nsFrameLoader> loader = GetFrameLoader();
    RefPtr<nsFrameLoader> otherLoader = aOtherLoaderOwner->GetFrameLoader();
    if (!loader || !otherLoader) {
        rv.Throw(NS_ERROR_NOT_IMPLEMENTED);
        return;
    }

    nsCOMPtr<nsIFrameLoaderOwner> flo = do_QueryInterface(static_cast<nsIDOMXULElement*>(this));
    rv = loader->SwapWithOtherLoader(otherLoader, flo, aOtherLoaderOwner);
}

NS_IMETHODIMP
nsXULElement::GetParentTree(nsIDOMXULMultiSelectControlElement** aTreeElement)
{
    for (nsIContent* current = GetParent(); current;
         current = current->GetParent()) {
        if (current->NodeInfo()->Equals(nsGkAtoms::listbox,
                                        kNameSpaceID_XUL)) {
            CallQueryInterface(current, aTreeElement);
            // XXX returning NS_OK because that's what the code used to do;
            // is that the right thing, though?

            return NS_OK;
        }
    }

    return NS_OK;
}

NS_IMETHODIMP
nsXULElement::Focus()
{
    ErrorResult rv;
    Focus(rv);
    return rv.StealNSResult();
}

NS_IMETHODIMP
nsXULElement::Blur()
{
    ErrorResult rv;
    Blur(rv);
    return rv.StealNSResult();
}

NS_IMETHODIMP
nsXULElement::Click()
{
  return ClickWithInputSource(nsIDOMMouseEvent::MOZ_SOURCE_UNKNOWN, /* aIsTrusted = */ true);
}

void
nsXULElement::Click(ErrorResult& rv)
{
  rv = ClickWithInputSource(nsIDOMMouseEvent::MOZ_SOURCE_UNKNOWN, nsContentUtils::IsCallerChrome());
}

nsresult
nsXULElement::ClickWithInputSource(uint16_t aInputSource, bool aIsTrustedEvent)
{
    if (BoolAttrIsTrue(nsGkAtoms::disabled))
        return NS_OK;

    nsCOMPtr<nsIDocument> doc = GetComposedDoc(); // Strong just in case
    if (doc) {
        nsCOMPtr<nsIPresShell> shell = doc->GetShell();
        if (shell) {
            // strong ref to PresContext so events don't destroy it
            RefPtr<nsPresContext> context = shell->GetPresContext();

            WidgetMouseEvent eventDown(aIsTrustedEvent, eMouseDown,
                                       nullptr, WidgetMouseEvent::eReal);
            WidgetMouseEvent eventUp(aIsTrustedEvent, eMouseUp,
                                     nullptr, WidgetMouseEvent::eReal);
            WidgetMouseEvent eventClick(aIsTrustedEvent, eMouseClick, nullptr,
                                        WidgetMouseEvent::eReal);
            eventDown.inputSource = eventUp.inputSource = eventClick.inputSource
                                  = aInputSource;

            // send mouse down
            nsEventStatus status = nsEventStatus_eIgnore;
            EventDispatcher::Dispatch(static_cast<nsIContent*>(this),
                                      context, &eventDown,  nullptr, &status);

            // send mouse up
            status = nsEventStatus_eIgnore;  // reset status
            EventDispatcher::Dispatch(static_cast<nsIContent*>(this),
                                      context, &eventUp, nullptr, &status);

            // send mouse click
            status = nsEventStatus_eIgnore;  // reset status
            EventDispatcher::Dispatch(static_cast<nsIContent*>(this),
                                      context, &eventClick, nullptr, &status);

            // If the click has been prevented, lets skip the command call
            // this is how a physical click works
            if (status == nsEventStatus_eConsumeNoDefault) {
                return NS_OK;
            }
        }
    }

    // oncommand is fired when an element is clicked...
    return DoCommand();
}

NS_IMETHODIMP
nsXULElement::DoCommand()
{
    nsCOMPtr<nsIDocument> doc = GetComposedDoc(); // strong just in case
    if (doc) {
        nsContentUtils::DispatchXULCommand(this, true);
    }

    return NS_OK;
}

nsIContent *
nsXULElement::GetBindingParent() const
{
    return mBindingParent;
}

bool
nsXULElement::IsNodeOfType(uint32_t aFlags) const
{
    return !(aFlags & ~eCONTENT);
}

nsresult
nsXULElement::AddPopupListener(nsIAtom* aName)
{
    // Add a popup listener to the element
    bool isContext = (aName == nsGkAtoms::context ||
                        aName == nsGkAtoms::contextmenu);
    uint32_t listenerFlag = isContext ?
                            XUL_ELEMENT_HAS_CONTENTMENU_LISTENER :
                            XUL_ELEMENT_HAS_POPUP_LISTENER;

    if (HasFlag(listenerFlag)) {
        return NS_OK;
    }

    nsCOMPtr<nsIDOMEventListener> listener =
      new nsXULPopupListener(this, isContext);

    // Add the popup as a listener on this element.
    EventListenerManager* manager = GetOrCreateListenerManager();
    SetFlags(listenerFlag);

    if (isContext) {
      manager->AddEventListenerByType(listener,
                                      NS_LITERAL_STRING("contextmenu"),
                                      TrustedEventsAtSystemGroupBubble());
    } else {
      manager->AddEventListenerByType(listener,
                                      NS_LITERAL_STRING("mousedown"),
                                      TrustedEventsAtSystemGroupBubble());
    }
    return NS_OK;
}

EventStates
nsXULElement::IntrinsicState() const
{
    EventStates state = nsStyledElement::IntrinsicState();

    if (IsReadWriteTextElement()) {
        state |= NS_EVENT_STATE_MOZ_READWRITE;
        state &= ~NS_EVENT_STATE_MOZ_READONLY;
    }

    return state;
}

//----------------------------------------------------------------------

nsresult
nsXULElement::MakeHeavyweight(nsXULPrototypeElement* aPrototype)
{
    if (!aPrototype) {
        return NS_OK;
    }

    uint32_t i;
    nsresult rv;
    for (i = 0; i < aPrototype->mNumAttributes; ++i) {
        nsXULPrototypeAttribute* protoattr = &aPrototype->mAttributes[i];
        nsAttrValue attrValue;

        // Style rules need to be cloned.
        if (protoattr->mValue.Type() == nsAttrValue::eCSSDeclaration) {
            DeclarationBlock* decl = protoattr->mValue.GetCSSDeclarationValue();
            RefPtr<css::Declaration>
              declClone = new css::Declaration(*decl->AsGecko());

            nsString stringValue;
            protoattr->mValue.ToString(stringValue);

            attrValue.SetTo(declClone.forget(), &stringValue);
        } else {
            attrValue.SetTo(protoattr->mValue);
        }

        // XXX we might wanna have a SetAndTakeAttr that takes an nsAttrName
        if (protoattr->mName.IsAtom()) {
            rv = mAttrsAndChildren.SetAndSwapAttr(protoattr->mName.Atom(), attrValue);
        } else {
            rv = mAttrsAndChildren.SetAndSwapAttr(protoattr->mName.NodeInfo(),
                                                  attrValue);
        }
        NS_ENSURE_SUCCESS(rv, rv);
    }
    return NS_OK;
}

nsresult
nsXULElement::HideWindowChrome(bool aShouldHide)
{
    nsIDocument* doc = GetUncomposedDoc();
    if (!doc || doc->GetRootElement() != this)
      return NS_ERROR_UNEXPECTED;

    // only top level chrome documents can hide the window chrome
    if (!doc->IsRootDisplayDocument())
      return NS_OK;

    nsIPresShell *shell = doc->GetShell();

    if (shell) {
        nsIFrame* frame = GetPrimaryFrame();

        nsPresContext *presContext = shell->GetPresContext();

        if (frame && presContext && presContext->IsChrome()) {
            nsView* view = frame->GetClosestView();

            if (view) {
                nsIWidget* w = view->GetWidget();
                NS_ENSURE_STATE(w);
                w->HideWindowChrome(aShouldHide);
            }
        }
    }

    return NS_OK;
}

nsIWidget*
nsXULElement::GetWindowWidget()
{
    nsIDocument* doc = GetComposedDoc();

    // only top level chrome documents can set the titlebar color
    if (doc && doc->IsRootDisplayDocument()) {
        nsCOMPtr<nsISupports> container = doc->GetContainer();
        nsCOMPtr<nsIBaseWindow> baseWindow = do_QueryInterface(container);
        if (baseWindow) {
            nsCOMPtr<nsIWidget> mainWidget;
            baseWindow->GetMainWidget(getter_AddRefs(mainWidget));
            return mainWidget;
        }
    }
    return nullptr;
}

void
nsXULElement::SetTitlebarColor(nscolor aColor, bool aActive)
{
    nsIWidget* mainWidget = GetWindowWidget();
    if (mainWidget) {
        mainWidget->SetWindowTitlebarColor(aColor, aActive);
    }
}

class SetDrawInTitleBarEvent : public Runnable
{
public:
  SetDrawInTitleBarEvent(nsIWidget* aWidget, bool aState)
    : mWidget(aWidget)
    , mState(aState)
  {}

  NS_IMETHOD Run() override {
    NS_ASSERTION(mWidget, "You shouldn't call this runnable with a null widget!");

    mWidget->SetDrawsInTitlebar(mState);
    return NS_OK;
  }

private:
  nsCOMPtr<nsIWidget> mWidget;
  bool mState;
};

void
nsXULElement::SetDrawsInTitlebar(bool aState)
{
    nsIWidget* mainWidget = GetWindowWidget();
    if (mainWidget) {
        nsContentUtils::AddScriptRunner(new SetDrawInTitleBarEvent(mainWidget, aState));
    }
}

void
nsXULElement::SetDrawsTitle(bool aState)
{
    nsIWidget* mainWidget = GetWindowWidget();
    if (mainWidget) {
        // We can do this synchronously because SetDrawsTitle doesn't have any
        // synchronous effects apart from a harmless invalidation.
        mainWidget->SetDrawsTitle(aState);
    }
}

void
nsXULElement::UpdateBrightTitlebarForeground(nsIDocument* aDoc)
{
    nsIWidget* mainWidget = GetWindowWidget();
    if (mainWidget) {
        // We can do this synchronously because SetBrightTitlebarForeground doesn't have any
        // synchronous effects apart from a harmless invalidation.
        mainWidget->SetUseBrightTitlebarForeground(
          aDoc->GetDocumentLWTheme() == nsIDocument::Doc_Theme_Bright ||
          aDoc->GetRootElement()->AttrValueIs(kNameSpaceID_None,
                                              nsGkAtoms::brighttitlebarforeground,
                                              NS_LITERAL_STRING("true"),
                                              eCaseMatters));
    }
}

class MarginSetter : public Runnable
{
public:
    explicit MarginSetter(nsIWidget* aWidget) :
        mWidget(aWidget), mMargin(-1, -1, -1, -1)
    {}
    MarginSetter(nsIWidget *aWidget, const LayoutDeviceIntMargin& aMargin) :
        mWidget(aWidget), mMargin(aMargin)
    {}

    NS_IMETHOD Run() override
    {
        // SetNonClientMargins can dispatch native events, hence doing
        // it off a script runner.
        mWidget->SetNonClientMargins(mMargin);
        return NS_OK;
    }

private:
    nsCOMPtr<nsIWidget> mWidget;
    LayoutDeviceIntMargin mMargin;
};

void
nsXULElement::SetChromeMargins(const nsAttrValue* aValue)
{
    if (!aValue)
        return;

    nsIWidget* mainWidget = GetWindowWidget();
    if (!mainWidget)
        return;

    // top, right, bottom, left - see nsAttrValue
    nsIntMargin margins;
    bool gotMargins = false;

    if (aValue->Type() == nsAttrValue::eIntMarginValue) {
        gotMargins = aValue->GetIntMarginValue(margins);
    } else {
        nsAutoString tmp;
        aValue->ToString(tmp);
        gotMargins = nsContentUtils::ParseIntMarginValue(tmp, margins);
    }
    if (gotMargins) {
        nsContentUtils::AddScriptRunner(
            new MarginSetter(
                mainWidget, LayoutDeviceIntMargin::FromUnknownMargin(margins)));
    }
}

void
nsXULElement::ResetChromeMargins()
{
    nsIWidget* mainWidget = GetWindowWidget();
    if (!mainWidget)
        return;
    // See nsIWidget
    nsContentUtils::AddScriptRunner(new MarginSetter(mainWidget));
}

bool
nsXULElement::BoolAttrIsTrue(nsIAtom* aName) const
{
    const nsAttrValue* attr =
        GetAttrInfo(kNameSpaceID_None, aName).mValue;

    return attr && attr->Type() == nsAttrValue::eAtom &&
           attr->GetAtomValue() == nsGkAtoms::_true;
}

void
nsXULElement::RecompileScriptEventListeners()
{
    int32_t i, count = mAttrsAndChildren.AttrCount();
    for (i = 0; i < count; ++i) {
        const nsAttrName *name = mAttrsAndChildren.AttrNameAt(i);

        // Eventlistenener-attributes are always in the null namespace
        if (!name->IsAtom()) {
            continue;
        }

        nsIAtom *attr = name->Atom();
        if (!nsContentUtils::IsEventAttributeName(attr, EventNameType_XUL)) {
            continue;
        }

        nsAutoString value;
        GetAttr(kNameSpaceID_None, attr, value);
        SetEventHandler(attr, value, true);
    }
}

bool
nsXULElement::IsEventAttributeName(nsIAtom *aName)
{
  return nsContentUtils::IsEventAttributeName(aName, EventNameType_XUL);
}

JSObject*
nsXULElement::WrapNode(JSContext *aCx, JS::Handle<JSObject*> aGivenProto)
{
    return dom::XULElementBinding::Wrap(aCx, this, aGivenProto);
}

NS_IMPL_CYCLE_COLLECTION_CLASS(nsXULPrototypeNode)

NS_IMPL_CYCLE_COLLECTION_UNLINK_BEGIN(nsXULPrototypeNode)
    if (tmp->mType == nsXULPrototypeNode::eType_Element) {
        static_cast<nsXULPrototypeElement*>(tmp)->Unlink();
    } else if (tmp->mType == nsXULPrototypeNode::eType_Script) {
        static_cast<nsXULPrototypeScript*>(tmp)->UnlinkJSObjects();
    }
NS_IMPL_CYCLE_COLLECTION_UNLINK_END
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_BEGIN(nsXULPrototypeNode)
    if (tmp->mType == nsXULPrototypeNode::eType_Element) {
        nsXULPrototypeElement *elem =
            static_cast<nsXULPrototypeElement*>(tmp);
        NS_CYCLE_COLLECTION_NOTE_EDGE_NAME(cb, "mNodeInfo");
        cb.NoteNativeChild(elem->mNodeInfo,
                           NS_CYCLE_COLLECTION_PARTICIPANT(NodeInfo));
        uint32_t i;
        for (i = 0; i < elem->mNumAttributes; ++i) {
            const nsAttrName& name = elem->mAttributes[i].mName;
            if (!name.IsAtom()) {
                NS_CYCLE_COLLECTION_NOTE_EDGE_NAME(cb,
                    "mAttributes[i].mName.NodeInfo()");
                cb.NoteNativeChild(name.NodeInfo(),
                                   NS_CYCLE_COLLECTION_PARTICIPANT(NodeInfo));
            }
        }
        ImplCycleCollectionTraverse(cb, elem->mChildren, "mChildren");
    }
    NS_IMPL_CYCLE_COLLECTION_TRAVERSE_SCRIPT_OBJECTS
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_END
NS_IMPL_CYCLE_COLLECTION_TRACE_BEGIN(nsXULPrototypeNode)
    if (tmp->mType == nsXULPrototypeNode::eType_Script) {
        nsXULPrototypeScript *script =
            static_cast<nsXULPrototypeScript*>(tmp);
        script->Trace(aCallbacks, aClosure);
    }
NS_IMPL_CYCLE_COLLECTION_TRACE_END

NS_IMPL_CYCLE_COLLECTION_ROOT_NATIVE(nsXULPrototypeNode, AddRef)
NS_IMPL_CYCLE_COLLECTION_UNROOT_NATIVE(nsXULPrototypeNode, Release)

//----------------------------------------------------------------------
//
// nsXULPrototypeAttribute
//

nsXULPrototypeAttribute::~nsXULPrototypeAttribute()
{
    MOZ_COUNT_DTOR(nsXULPrototypeAttribute);
}


//----------------------------------------------------------------------
//
// nsXULPrototypeElement
//

nsresult
nsXULPrototypeElement::Serialize(nsIObjectOutputStream* aStream,
                                 nsXULPrototypeDocument* aProtoDoc,
                                 const nsTArray<RefPtr<mozilla::dom::NodeInfo>> *aNodeInfos)
{
    nsresult rv;

    // Write basic prototype data
    rv = aStream->Write32(mType);

    // Write Node Info
    int32_t index = aNodeInfos->IndexOf(mNodeInfo);
    NS_ASSERTION(index >= 0, "unknown mozilla::dom::NodeInfo index");
    nsresult tmp = aStream->Write32(index);
    if (NS_FAILED(tmp)) {
      rv = tmp;
    }

    // Write Attributes
    tmp = aStream->Write32(mNumAttributes);
    if (NS_FAILED(tmp)) {
      rv = tmp;
    }

    nsAutoString attributeValue;
    uint32_t i;
    for (i = 0; i < mNumAttributes; ++i) {
        RefPtr<mozilla::dom::NodeInfo> ni;
        if (mAttributes[i].mName.IsAtom()) {
            ni = mNodeInfo->NodeInfoManager()->
                GetNodeInfo(mAttributes[i].mName.Atom(), nullptr,
                            kNameSpaceID_None,
                            nsIDOMNode::ATTRIBUTE_NODE);
            NS_ASSERTION(ni, "the nodeinfo should already exist");
        } else {
            ni = mAttributes[i].mName.NodeInfo();
        }

        index = aNodeInfos->IndexOf(ni);
        NS_ASSERTION(index >= 0, "unknown mozilla::dom::NodeInfo index");
        tmp = aStream->Write32(index);
        if (NS_FAILED(tmp)) {
          rv = tmp;
        }

        mAttributes[i].mValue.ToString(attributeValue);
        tmp = aStream->WriteWStringZ(attributeValue.get());
        if (NS_FAILED(tmp)) {
          rv = tmp;
        }
    }

    // Now write children
    tmp = aStream->Write32(uint32_t(mChildren.Length()));
    if (NS_FAILED(tmp)) {
      rv = tmp;
    }
    for (i = 0; i < mChildren.Length(); i++) {
        nsXULPrototypeNode* child = mChildren[i].get();
        switch (child->mType) {
        case eType_Element:
        case eType_Text:
        case eType_PI:
            tmp = child->Serialize(aStream, aProtoDoc, aNodeInfos);
            if (NS_FAILED(tmp)) {
              rv = tmp;
            }
            break;
        case eType_Script:
            tmp = aStream->Write32(child->mType);
            if (NS_FAILED(tmp)) {
              rv = tmp;
            }
            nsXULPrototypeScript* script = static_cast<nsXULPrototypeScript*>(child);

            tmp = aStream->Write8(script->mOutOfLine);
            if (NS_FAILED(tmp)) {
              rv = tmp;
            }
            if (! script->mOutOfLine) {
                tmp = script->Serialize(aStream, aProtoDoc, aNodeInfos);
                if (NS_FAILED(tmp)) {
                  rv = tmp;
                }
            } else {
                tmp = aStream->WriteCompoundObject(script->mSrcURI,
                                                   NS_GET_IID(nsIURI),
                                                   true);
                if (NS_FAILED(tmp)) {
                  rv = tmp;
                }

                if (script->HasScriptObject()) {
                    // This may return NS_OK without muxing script->mSrcURI's
                    // data into the cache file, in the case where that
                    // muxed document is already there (written by a prior
                    // session, or by an earlier cache episode during this
                    // session).
                    tmp = script->SerializeOutOfLine(aStream, aProtoDoc);
                    if (NS_FAILED(tmp)) {
                      rv = tmp;
                    }
                }
            }
            break;
        }
    }

    return rv;
}

nsresult
nsXULPrototypeElement::Deserialize(nsIObjectInputStream* aStream,
                                   nsXULPrototypeDocument* aProtoDoc,
                                   nsIURI* aDocumentURI,
                                   const nsTArray<RefPtr<mozilla::dom::NodeInfo>> *aNodeInfos)
{
    NS_PRECONDITION(aNodeInfos, "missing nodeinfo array");

    // Read Node Info
    uint32_t number = 0;
    nsresult rv = aStream->Read32(&number);
    if (NS_WARN_IF(NS_FAILED(rv))) return rv;
    mNodeInfo = aNodeInfos->SafeElementAt(number, nullptr);
    if (!mNodeInfo) {
        return NS_ERROR_UNEXPECTED;
    }

    // Read Attributes
    rv = aStream->Read32(&number);
    if (NS_WARN_IF(NS_FAILED(rv))) return rv;
    mNumAttributes = int32_t(number);

    if (mNumAttributes > 0) {
        mAttributes = new (fallible) nsXULPrototypeAttribute[mNumAttributes];
        if (!mAttributes) {
            return NS_ERROR_OUT_OF_MEMORY;
        }

        nsAutoString attributeValue;
        for (uint32_t i = 0; i < mNumAttributes; ++i) {
            rv = aStream->Read32(&number);
            if (NS_WARN_IF(NS_FAILED(rv))) return rv;
            mozilla::dom::NodeInfo* ni = aNodeInfos->SafeElementAt(number, nullptr);
            if (!ni) {
                return NS_ERROR_UNEXPECTED;
            }

            mAttributes[i].mName.SetTo(ni);

            rv = aStream->ReadString(attributeValue);
            if (NS_WARN_IF(NS_FAILED(rv))) return rv;
            rv = SetAttrAt(i, attributeValue, aDocumentURI);
            if (NS_WARN_IF(NS_FAILED(rv))) return rv;
        }
    }

    rv = aStream->Read32(&number);
    if (NS_WARN_IF(NS_FAILED(rv))) return rv;
    uint32_t numChildren = int32_t(number);

    if (numChildren > 0) {
        if (!mChildren.SetCapacity(numChildren, fallible)) {
            return NS_ERROR_OUT_OF_MEMORY;
        }

        for (uint32_t i = 0; i < numChildren; i++) {
            rv = aStream->Read32(&number);
            if (NS_WARN_IF(NS_FAILED(rv))) return rv;
            Type childType = (Type)number;

            RefPtr<nsXULPrototypeNode> child;

            switch (childType) {
            case eType_Element:
                child = new nsXULPrototypeElement();
                rv = child->Deserialize(aStream, aProtoDoc, aDocumentURI,
                                        aNodeInfos);
                if (NS_WARN_IF(NS_FAILED(rv))) return rv;
                break;
            case eType_Text:
                child = new nsXULPrototypeText();
                rv = child->Deserialize(aStream, aProtoDoc, aDocumentURI,
                                        aNodeInfos);
                if (NS_WARN_IF(NS_FAILED(rv))) return rv;
                break;
            case eType_PI:
                child = new nsXULPrototypePI();
                rv = child->Deserialize(aStream, aProtoDoc, aDocumentURI,
                                        aNodeInfos);
                if (NS_WARN_IF(NS_FAILED(rv))) return rv;
                break;
            case eType_Script: {
                // language version/options obtained during deserialization.
                RefPtr<nsXULPrototypeScript> script = new nsXULPrototypeScript(0, 0);

                rv = aStream->ReadBoolean(&script->mOutOfLine);
                if (NS_WARN_IF(NS_FAILED(rv))) return rv;
                if (!script->mOutOfLine) {
                    rv = script->Deserialize(aStream, aProtoDoc, aDocumentURI,
                                             aNodeInfos);
                    if (NS_WARN_IF(NS_FAILED(rv))) return rv;
                } else {
                    nsCOMPtr<nsISupports> supports;
                    rv = aStream->ReadObject(true, getter_AddRefs(supports));
                    if (NS_WARN_IF(NS_FAILED(rv))) return rv;
                    script->mSrcURI = do_QueryInterface(supports);

                    rv = script->DeserializeOutOfLine(aStream, aProtoDoc);
                    if (NS_WARN_IF(NS_FAILED(rv))) return rv;
                }

                child = script.forget();
                break;
            }
            default:
                MOZ_ASSERT(false, "Unexpected child type!");
                return NS_ERROR_UNEXPECTED;
            }

            MOZ_ASSERT(child, "Don't append null to mChildren");
            MOZ_ASSERT(child->mType == childType);
            mChildren.AppendElement(child);

            // Oh dear. Something failed during the deserialization.
            // We don't know what.  But likely consequences of failed
            // deserializations included calls to |AbortCaching| which
            // shuts down the cache and closes our streams.
            // If that happens, next time through this loop, we die a messy
            // death. So, let's just fail now, and propagate that failure
            // upward so that the ChromeProtocolHandler knows it can't use
            // a cached chrome channel for this.
            if (NS_WARN_IF(NS_FAILED(rv)))
                return rv;
        }
    }

    return rv;
}

nsresult
nsXULPrototypeElement::SetAttrAt(uint32_t aPos, const nsAString& aValue,
                                 nsIURI* aDocumentURI)
{
    NS_PRECONDITION(aPos < mNumAttributes, "out-of-bounds");

    // WARNING!!
    // This code is largely duplicated in nsXULElement::SetAttr.
    // Any changes should be made to both functions.

    if (!mNodeInfo->NamespaceEquals(kNameSpaceID_XUL)) {
        mAttributes[aPos].mValue.ParseStringOrAtom(aValue);

        return NS_OK;
    }

    if (mAttributes[aPos].mName.Equals(nsGkAtoms::id) &&
        !aValue.IsEmpty()) {
        mHasIdAttribute = true;
        // Store id as atom.
        // id="" means that the element has no id. Not that it has
        // emptystring as id.
        mAttributes[aPos].mValue.ParseAtom(aValue);

        return NS_OK;
    } else if (mAttributes[aPos].mName.Equals(nsGkAtoms::_class)) {
        mHasClassAttribute = true;
        // Compute the element's class list
        mAttributes[aPos].mValue.ParseAtomArray(aValue);

        return NS_OK;
    } else if (mAttributes[aPos].mName.Equals(nsGkAtoms::style)) {
        mHasStyleAttribute = true;
        // Parse the element's 'style' attribute

        nsCSSParser parser;

        // XXX Get correct Base URI (need GetBaseURI on *prototype* element)
        // TODO: If we implement Content Security Policy for chrome documents
        // as has been discussed, the CSP should be checked here to see if
        // inline styles are allowed to be applied.
        RefPtr<css::Declaration> declaration =
          parser.ParseStyleAttribute(aValue, aDocumentURI, aDocumentURI,
                                     // This is basically duplicating what
                                     // nsINode::NodePrincipal() does
                                     mNodeInfo->NodeInfoManager()->
                                       DocumentPrincipal());
        if (declaration) {
            mAttributes[aPos].mValue.SetTo(declaration.forget(), &aValue);

            return NS_OK;
        }
        // Don't abort if parsing failed, it could just be malformed css.
    }

    mAttributes[aPos].mValue.ParseStringOrAtom(aValue);

    return NS_OK;
}

void
nsXULPrototypeElement::Unlink()
{
    mNumAttributes = 0;
    delete[] mAttributes;
    mAttributes = nullptr;
    mChildren.Clear();
}

void
nsXULPrototypeElement::TraceAllScripts(JSTracer* aTrc)
{
    for (uint32_t i = 0; i < mChildren.Length(); ++i) {
        nsXULPrototypeNode* child = mChildren[i];
        if (child->mType == nsXULPrototypeNode::eType_Element) {
            static_cast<nsXULPrototypeElement*>(child)->TraceAllScripts(aTrc);
        } else if (child->mType == nsXULPrototypeNode::eType_Script) {
            static_cast<nsXULPrototypeScript*>(child)->TraceScriptObject(aTrc);
        }
    }
}

//----------------------------------------------------------------------
//
// nsXULPrototypeScript
//

nsXULPrototypeScript::nsXULPrototypeScript(uint32_t aLineNo, uint32_t aVersion)
    : nsXULPrototypeNode(eType_Script),
      mLineNo(aLineNo),
      mSrcLoading(false),
      mOutOfLine(true),
      mSrcLoadWaiters(nullptr),
      mLangVersion(aVersion),
      mScriptObject(nullptr)
{
}


nsXULPrototypeScript::~nsXULPrototypeScript()
{
    UnlinkJSObjects();
}

nsresult
nsXULPrototypeScript::Serialize(nsIObjectOutputStream* aStream,
                                nsXULPrototypeDocument* aProtoDoc,
                                const nsTArray<RefPtr<mozilla::dom::NodeInfo>> *aNodeInfos)
{
    NS_ENSURE_TRUE(aProtoDoc, NS_ERROR_UNEXPECTED);

    AutoJSAPI jsapi;
    if (!jsapi.Init(xpc::CompilationScope())) {
        return NS_ERROR_UNEXPECTED;
    }

    NS_ASSERTION(!mSrcLoading || mSrcLoadWaiters != nullptr ||
                 !mScriptObject,
                 "script source still loading when serializing?!");
    if (!mScriptObject)
        return NS_ERROR_FAILURE;

    // Write basic prototype data
    nsresult rv;
    rv = aStream->Write32(mLineNo);
    if (NS_FAILED(rv)) return rv;
    rv = aStream->Write32(mLangVersion);
    if (NS_FAILED(rv)) return rv;

    JSContext* cx = jsapi.cx();
    JS::Rooted<JSScript*> script(cx, mScriptObject);
    MOZ_ASSERT(xpc::CompilationScope() == JS::CurrentGlobalOrNull(cx));
    return nsContentUtils::XPConnect()->WriteScript(aStream, cx, script);
}

nsresult
nsXULPrototypeScript::SerializeOutOfLine(nsIObjectOutputStream* aStream,
                                         nsXULPrototypeDocument* aProtoDoc)
{
    nsresult rv = NS_ERROR_NOT_IMPLEMENTED;

    bool isChrome = false;
    if (NS_FAILED(mSrcURI->SchemeIs("chrome", &isChrome)) || !isChrome)
       // Don't cache scripts that don't come from chrome uris.
       return rv;

    nsXULPrototypeCache* cache = nsXULPrototypeCache::GetInstance();
    if (!cache)
        return NS_ERROR_OUT_OF_MEMORY;

    NS_ASSERTION(cache->IsEnabled(),
                 "writing to the cache file, but the XUL cache is off?");
    bool exists;
    cache->HasData(mSrcURI, &exists);

    /* return will be NS_OK from GetAsciiSpec.
     * that makes no sense.
     * nor does returning NS_OK from HasMuxedDocument.
     * XXX return something meaningful.
     */
    if (exists)
        return NS_OK;

    nsCOMPtr<nsIObjectOutputStream> oos;
    rv = cache->GetOutputStream(mSrcURI, getter_AddRefs(oos));
    NS_ENSURE_SUCCESS(rv, rv);

    nsresult tmp = Serialize(oos, aProtoDoc, nullptr);
    if (NS_FAILED(tmp)) {
      rv = tmp;
    }
    tmp = cache->FinishOutputStream(mSrcURI);
    if (NS_FAILED(tmp)) {
      rv = tmp;
    }

    if (NS_FAILED(rv))
        cache->AbortCaching();
    return rv;
}


nsresult
nsXULPrototypeScript::Deserialize(nsIObjectInputStream* aStream,
                                  nsXULPrototypeDocument* aProtoDoc,
                                  nsIURI* aDocumentURI,
                                  const nsTArray<RefPtr<mozilla::dom::NodeInfo>> *aNodeInfos)
{
    nsresult rv;
    NS_ASSERTION(!mSrcLoading || mSrcLoadWaiters != nullptr ||
                 !mScriptObject,
                 "prototype script not well-initialized when deserializing?!");

    // Read basic prototype data
    rv = aStream->Read32(&mLineNo);
    if (NS_FAILED(rv)) return rv;
    rv = aStream->Read32(&mLangVersion);
    if (NS_FAILED(rv)) return rv;

    AutoJSAPI jsapi;
    if (!jsapi.Init(xpc::CompilationScope())) {
        return NS_ERROR_UNEXPECTED;
    }
    JSContext* cx = jsapi.cx();

    JS::Rooted<JSScript*> newScriptObject(cx);
    rv = nsContentUtils::XPConnect()->ReadScript(aStream, cx,
                                                 newScriptObject.address());
    NS_ENSURE_SUCCESS(rv, rv);
    Set(newScriptObject);
    return NS_OK;
}


nsresult
nsXULPrototypeScript::DeserializeOutOfLine(nsIObjectInputStream* aInput,
                                           nsXULPrototypeDocument* aProtoDoc)
{
    // Keep track of failure via rv, so we can
    // AbortCaching if things look bad.
    nsresult rv = NS_OK;
    nsXULPrototypeCache* cache = nsXULPrototypeCache::GetInstance();

    nsCOMPtr<nsIObjectInputStream> objectInput = aInput;
    if (cache) {
        bool useXULCache = true;
        if (mSrcURI) {
            // NB: we must check the XUL script cache early, to avoid
            // multiple deserialization attempts for a given script.
            // Note that XULDocument::LoadScript
            // checks the XUL script cache too, in order to handle the
            // serialization case.
            //
            // We need do this only for <script src='strres.js'> and the
            // like, i.e., out-of-line scripts that are included by several
            // different XUL documents stored in the cache file.
            useXULCache = cache->IsEnabled();

            if (useXULCache) {
                JSScript* newScriptObject =
                    cache->GetScript(mSrcURI);
                if (newScriptObject)
                    Set(newScriptObject);
            }
        }

        if (!mScriptObject) {
            if (mSrcURI) {
                rv = cache->GetInputStream(mSrcURI, getter_AddRefs(objectInput));
            }
            // If !mSrcURI, we have an inline script. We shouldn't have
            // to do anything else in that case, I think.

            // We do reflect errors into rv, but our caller may want to
            // ignore our return value, because mScriptObject will be null
            // after any error, and that suffices to cause the script to
            // be reloaded (from the src= URI, if any) and recompiled.
            // We're better off slow-loading than bailing out due to a
            // error.
            if (NS_SUCCEEDED(rv))
                rv = Deserialize(objectInput, aProtoDoc, nullptr, nullptr);

            if (NS_SUCCEEDED(rv)) {
                if (useXULCache && mSrcURI) {
                    bool isChrome = false;
                    mSrcURI->SchemeIs("chrome", &isChrome);
                    if (isChrome) {
                        JS::Rooted<JSScript*> script(RootingCx(), GetScriptObject());
                        cache->PutScript(mSrcURI, script);
                    }
                }
                cache->FinishInputStream(mSrcURI);
            } else {
                // If mSrcURI is not in the cache,
                // rv will be NS_ERROR_NOT_AVAILABLE and we'll try to
                // update the cache file to hold a serialization of
                // this script, once it has finished loading.
                if (rv != NS_ERROR_NOT_AVAILABLE)
                    cache->AbortCaching();
            }
        }
    }
    return rv;
}

class NotifyOffThreadScriptCompletedRunnable : public Runnable
{
    // An array of all outstanding script receivers. All reference counting of
    // these objects happens on the main thread. When we return to the main
    // thread from script compilation we make sure our receiver is still in
    // this array (still alive) before proceeding. This array is cleared during
    // shutdown, potentially before all outstanding script compilations have
    // finished. We do not need to worry about pointer replay here, because
    // a) we should not be starting script compilation after clearing this
    // array and b) in all other cases the receiver will still be alive.
    static StaticAutoPtr<nsTArray<nsCOMPtr<nsIOffThreadScriptReceiver>>> sReceivers;
    static bool sSetupClearOnShutdown;

    nsIOffThreadScriptReceiver* mReceiver;
    void *mToken;

public:
    NotifyOffThreadScriptCompletedRunnable(nsIOffThreadScriptReceiver* aReceiver,
                                           void *aToken)
      : mReceiver(aReceiver), mToken(aToken)
    {}

    static void NoteReceiver(nsIOffThreadScriptReceiver* aReceiver) {
        if (!sSetupClearOnShutdown) {
            ClearOnShutdown(&sReceivers);
            sSetupClearOnShutdown = true;
            sReceivers = new nsTArray<nsCOMPtr<nsIOffThreadScriptReceiver>>();
        }

        // If we ever crash here, it's because we tried to lazy compile script
        // too late in shutdown.
        sReceivers->AppendElement(aReceiver);
    }

    NS_DECL_NSIRUNNABLE
};

StaticAutoPtr<nsTArray<nsCOMPtr<nsIOffThreadScriptReceiver>>> NotifyOffThreadScriptCompletedRunnable::sReceivers;
bool NotifyOffThreadScriptCompletedRunnable::sSetupClearOnShutdown = false;

NS_IMETHODIMP
NotifyOffThreadScriptCompletedRunnable::Run()
{
    MOZ_ASSERT(NS_IsMainThread());

    JS::Rooted<JSScript*> script(RootingCx());
    {
        AutoJSAPI jsapi;
        if (!jsapi.Init(xpc::CompilationScope())) {
            // Now what?  I guess we just leak... this should probably never
            // happen.
            return NS_ERROR_UNEXPECTED;
        }
        JSContext* cx = jsapi.cx();
        script = JS::FinishOffThreadScript(cx, mToken);
    }

    if (!sReceivers) {
        // We've already shut down.
        return NS_OK;
    }

    auto index = sReceivers->IndexOf(mReceiver);
    MOZ_RELEASE_ASSERT(index != sReceivers->NoIndex);
    nsCOMPtr<nsIOffThreadScriptReceiver> receiver = (*sReceivers)[index].forget();
    sReceivers->RemoveElementAt(index);

    return receiver->OnScriptCompileComplete(script, script ? NS_OK : NS_ERROR_FAILURE);
}

static void
OffThreadScriptReceiverCallback(void *aToken, void *aCallbackData)
{
    // Be careful not to adjust the refcount on the receiver, as this callback
    // may be invoked off the main thread.
    nsIOffThreadScriptReceiver* aReceiver = static_cast<nsIOffThreadScriptReceiver*>(aCallbackData);
    RefPtr<NotifyOffThreadScriptCompletedRunnable> notify =
        new NotifyOffThreadScriptCompletedRunnable(aReceiver, aToken);
    NS_DispatchToMainThread(notify);
}

nsresult
nsXULPrototypeScript::Compile(JS::SourceBufferHolder& aSrcBuf,
                              nsIURI* aURI, uint32_t aLineNo,
                              nsIDocument* aDocument,
                              nsIOffThreadScriptReceiver *aOffThreadReceiver /* = nullptr */)
{
    // We'll compile the script in the compilation scope.
    AutoJSAPI jsapi;
    if (!jsapi.Init(xpc::CompilationScope())) {
        return NS_ERROR_UNEXPECTED;
    }
    JSContext* cx = jsapi.cx();

    nsresult rv;
    nsAutoCString urlspec;
    nsContentUtils::GetWrapperSafeScriptFilename(aDocument, aURI, urlspec, &rv);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return rv;
    }

    // Ok, compile it to create a prototype script object!
    NS_ENSURE_TRUE(JSVersion(mLangVersion) != JSVERSION_UNKNOWN, NS_OK);
    JS::CompileOptions options(cx);
    options.setIntroductionType("scriptElement")
           .setFileAndLine(urlspec.get(), aLineNo)
           .setVersion(JSVersion(mLangVersion));
    // If the script was inline, tell the JS parser to save source for
    // Function.prototype.toSource(). If it's out of line, we retrieve the
    // source from the files on demand.
    options.setSourceIsLazy(mOutOfLine);
    JS::Rooted<JSObject*> scope(cx, JS::CurrentGlobalOrNull(cx));
    if (scope) {
      JS::ExposeObjectToActiveJS(scope);
    }

    if (aOffThreadReceiver && JS::CanCompileOffThread(cx, options, aSrcBuf.length())) {
        if (!JS::CompileOffThread(cx, options,
                                  aSrcBuf.get(), aSrcBuf.length(),
                                  OffThreadScriptReceiverCallback,
                                  static_cast<void*>(aOffThreadReceiver))) {
            return NS_ERROR_OUT_OF_MEMORY;
        }
        NotifyOffThreadScriptCompletedRunnable::NoteReceiver(aOffThreadReceiver);
    } else {
        JS::Rooted<JSScript*> script(cx);
        if (!JS::Compile(cx, options, aSrcBuf, &script))
            return NS_ERROR_OUT_OF_MEMORY;
        Set(script);
    }
    return NS_OK;
}

nsresult
nsXULPrototypeScript::Compile(const char16_t* aText,
                              int32_t aTextLength,
                              nsIURI* aURI,
                              uint32_t aLineNo,
                              nsIDocument* aDocument,
                              nsIOffThreadScriptReceiver *aOffThreadReceiver /* = nullptr */)
{
  JS::SourceBufferHolder srcBuf(aText, aTextLength,
                                JS::SourceBufferHolder::NoOwnership);
  return Compile(srcBuf, aURI, aLineNo, aDocument, aOffThreadReceiver);
}

void
nsXULPrototypeScript::UnlinkJSObjects()
{
    if (mScriptObject) {
        mScriptObject = nullptr;
        mozilla::DropJSObjects(this);
    }
}

void
nsXULPrototypeScript::Set(JSScript* aObject)
{
    MOZ_ASSERT(!mScriptObject, "Leaking script object.");
    if (!aObject) {
        mScriptObject = nullptr;
        return;
    }

    mScriptObject = aObject;
    mozilla::HoldJSObjects(this);
}

//----------------------------------------------------------------------
//
// nsXULPrototypeText
//

nsresult
nsXULPrototypeText::Serialize(nsIObjectOutputStream* aStream,
                              nsXULPrototypeDocument* aProtoDoc,
                              const nsTArray<RefPtr<mozilla::dom::NodeInfo>> *aNodeInfos)
{
    nsresult rv;

    // Write basic prototype data
    rv = aStream->Write32(mType);

    nsresult tmp = aStream->WriteWStringZ(mValue.get());
    if (NS_FAILED(tmp)) {
      rv = tmp;
    }

    return rv;
}

nsresult
nsXULPrototypeText::Deserialize(nsIObjectInputStream* aStream,
                                nsXULPrototypeDocument* aProtoDoc,
                                nsIURI* aDocumentURI,
                                const nsTArray<RefPtr<mozilla::dom::NodeInfo>> *aNodeInfos)
{
    nsresult rv = aStream->ReadString(mValue);
    if (NS_WARN_IF(NS_FAILED(rv))) {
        return rv;
    }
    return NS_OK;
}

//----------------------------------------------------------------------
//
// nsXULPrototypePI
//

nsresult
nsXULPrototypePI::Serialize(nsIObjectOutputStream* aStream,
                            nsXULPrototypeDocument* aProtoDoc,
                            const nsTArray<RefPtr<mozilla::dom::NodeInfo>> *aNodeInfos)
{
    nsresult rv;

    // Write basic prototype data
    rv = aStream->Write32(mType);

    nsresult tmp = aStream->WriteWStringZ(mTarget.get());
    if (NS_FAILED(tmp)) {
      rv = tmp;
    }
    tmp = aStream->WriteWStringZ(mData.get());
    if (NS_FAILED(tmp)) {
      rv = tmp;
    }

    return rv;
}

nsresult
nsXULPrototypePI::Deserialize(nsIObjectInputStream* aStream,
                              nsXULPrototypeDocument* aProtoDoc,
                              nsIURI* aDocumentURI,
                              const nsTArray<RefPtr<mozilla::dom::NodeInfo>> *aNodeInfos)
{
    nsresult rv;

    rv = aStream->ReadString(mTarget);
    if (NS_FAILED(rv)) return rv;
    rv = aStream->ReadString(mData);
    if (NS_FAILED(rv)) return rv;

    return rv;
}
