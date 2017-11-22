/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/*
  This file provides the implementation for xul popup listener which
  tracks xul popups and context menus
 */

#include "nsXULPopupListener.h"
#include "nsCOMPtr.h"
#include "nsGkAtoms.h"
#include "nsIDOMElement.h"
#include "nsIDOMXULElement.h"
#include "nsIDOMNodeList.h"
#include "nsIDOMDocument.h"
#include "nsIDOMDocumentXBL.h"
#include "nsContentCID.h"
#include "nsContentUtils.h"
#include "nsXULPopupManager.h"
#include "nsIScriptContext.h"
#include "nsIDOMWindow.h"
#include "nsIDOMXULDocument.h"
#include "nsIDocument.h"
#include "nsServiceManagerUtils.h"
#include "nsIPrincipal.h"
#include "nsIScriptSecurityManager.h"
#include "nsLayoutUtils.h"
#include "mozilla/ReflowInput.h"
#include "nsIObjectLoadingContent.h"
#include "mozilla/EventStateManager.h"
#include "mozilla/EventStates.h"
#include "mozilla/Preferences.h"
#include "mozilla/dom/Event.h" // for nsIDOMEvent::InternalDOMEvent()
#include "mozilla/dom/EventTarget.h"
#include "mozilla/dom/FragmentOrElement.h"

// for event firing in context menus
#include "nsPresContext.h"
#include "nsIPresShell.h"
#include "nsFocusManager.h"
#include "nsPIDOMWindow.h"
#include "nsViewManager.h"
#include "nsError.h"
#include "nsMenuFrame.h"

using namespace mozilla;
using namespace mozilla::dom;

// on win32 and os/2, context menus come up on mouse up. On other platforms,
// they appear on mouse down. Certain bits of code care about this difference.
#if defined(XP_WIN)
#define NS_CONTEXT_MENU_IS_MOUSEUP 1
#endif

nsXULPopupListener::nsXULPopupListener(mozilla::dom::Element* aElement,
                                       bool aIsContext)
  : mElement(aElement), mPopupContent(nullptr), mIsContext(aIsContext)
{
}

nsXULPopupListener::~nsXULPopupListener(void)
{
  ClosePopup();
}

NS_IMPL_CYCLE_COLLECTION(nsXULPopupListener, mElement, mPopupContent)
NS_IMPL_CYCLE_COLLECTING_ADDREF(nsXULPopupListener)
NS_IMPL_CYCLE_COLLECTING_RELEASE(nsXULPopupListener)

NS_IMPL_CYCLE_COLLECTION_CAN_SKIP_BEGIN(nsXULPopupListener)
  // If the owner, mElement, can be skipped, so can we.
  if (tmp->mElement) {
    return mozilla::dom::FragmentOrElement::CanSkip(tmp->mElement, true);
  }
NS_IMPL_CYCLE_COLLECTION_CAN_SKIP_END

NS_IMPL_CYCLE_COLLECTION_CAN_SKIP_IN_CC_BEGIN(nsXULPopupListener)
  if (tmp->mElement) {
    return mozilla::dom::FragmentOrElement::CanSkipInCC(tmp->mElement);
  }
NS_IMPL_CYCLE_COLLECTION_CAN_SKIP_IN_CC_END

NS_IMPL_CYCLE_COLLECTION_CAN_SKIP_THIS_BEGIN(nsXULPopupListener)
  if (tmp->mElement) {
    return mozilla::dom::FragmentOrElement::CanSkipThis(tmp->mElement);
  }
NS_IMPL_CYCLE_COLLECTION_CAN_SKIP_THIS_END

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(nsXULPopupListener)
  NS_INTERFACE_MAP_ENTRY(nsIDOMEventListener)
  NS_INTERFACE_MAP_ENTRY(nsISupports)
NS_INTERFACE_MAP_END

////////////////////////////////////////////////////////////////
// nsIDOMEventListener

nsresult
nsXULPopupListener::HandleEvent(nsIDOMEvent* aEvent)
{
  nsAutoString eventType;
  aEvent->GetType(eventType);

  if(!((eventType.EqualsLiteral("mousedown") && !mIsContext) ||
       (eventType.EqualsLiteral("contextmenu") && mIsContext)))
    return NS_OK;

  int16_t button;

  nsCOMPtr<nsIDOMMouseEvent> mouseEvent = do_QueryInterface(aEvent);
  if (!mouseEvent) {
    //non-ui event passed in.  bad things.
    return NS_OK;
  }

  // Get the node that was clicked on.
  EventTarget* target = mouseEvent->AsEvent()->InternalDOMEvent()->GetTarget();
  nsCOMPtr<nsIDOMNode> targetNode = do_QueryInterface(target);

  if (!targetNode && mIsContext) {
    // Not a DOM node, see if it's the DOM window (bug 380818).
    nsCOMPtr<nsPIDOMWindowInner> domWin = do_QueryInterface(target);
    if (!domWin) {
      return NS_ERROR_DOM_WRONG_TYPE_ERR;
    }
    // Try to use the root node as target node.
    nsCOMPtr<nsIDocument> doc = domWin->GetDoc();

    if (doc)
      targetNode = do_QueryInterface(doc->GetRootElement());
    if (!targetNode) {
      return NS_ERROR_FAILURE;
    }
  }

  nsCOMPtr<nsIContent> targetContent = do_QueryInterface(target);
  if (!targetContent) {
    return NS_OK;
  }

  {
    EventTarget* originalTarget = mouseEvent->AsEvent()->InternalDOMEvent()->GetOriginalTarget();
    nsCOMPtr<nsIContent> content = do_QueryInterface(originalTarget);
    if (content && EventStateManager::IsRemoteTarget(content)) {
      return NS_OK;
    }
  }

  bool preventDefault;
  mouseEvent->AsEvent()->GetDefaultPrevented(&preventDefault);
  if (preventDefault && targetNode && mIsContext) {
    // Someone called preventDefault on a context menu.
    // Let's make sure they are allowed to do so.
    bool eventEnabled =
      Preferences::GetBool("dom.event.contextmenu.enabled", true);
    if (!eventEnabled) {
      // If the target node is for plug-in, we should not open XUL context
      // menu on windowless plug-ins.
      nsCOMPtr<nsIObjectLoadingContent> olc = do_QueryInterface(targetNode);
      uint32_t type;
      if (olc && NS_SUCCEEDED(olc->GetDisplayedType(&type)) &&
          type == nsIObjectLoadingContent::TYPE_PLUGIN) {
        return NS_OK;
      }

      // The user wants his contextmenus.  Let's make sure that this is a website
      // and not chrome since there could be places in chrome which don't want
      // contextmenus.
      nsCOMPtr<nsINode> node = do_QueryInterface(targetNode);
      if (node) {
        nsCOMPtr<nsIPrincipal> system;
        nsContentUtils::GetSecurityManager()->
          GetSystemPrincipal(getter_AddRefs(system));
        if (node->NodePrincipal() != system) {
          // This isn't chrome.  Cancel the preventDefault() and
          // let the event go forth.
          preventDefault = false;
        }
      }
    }
  }

  if (preventDefault) {
    // someone called preventDefault. bail.
    return NS_OK;
  }

  // prevent popups on menu and menuitems as they handle their own popups
  // This was added for bug 96920.
  // If a menu item child was clicked on that leads to a popup needing
  // to show, we know (guaranteed) that we're dealing with a menu or
  // submenu of an already-showing popup.  We don't need to do anything at all.
  if (!mIsContext) {
    if (targetContent &&
        targetContent->IsAnyOfXULElements(nsGkAtoms::menu, nsGkAtoms::menuitem))
      return NS_OK;
  }

  if (mIsContext) {
#ifndef NS_CONTEXT_MENU_IS_MOUSEUP
    uint16_t inputSource = nsIDOMMouseEvent::MOZ_SOURCE_UNKNOWN;
    mouseEvent->GetMozInputSource(&inputSource);
    bool isTouch = inputSource == nsIDOMMouseEvent::MOZ_SOURCE_TOUCH;
    // If the context menu launches on mousedown,
    // we have to fire focus on the content we clicked on
    FireFocusOnTargetContent(targetNode, isTouch);
#endif
  }
  else {
    // Only open popups when the left mouse button is down.
    mouseEvent->GetButton(&button);
    if (button != 0)
      return NS_OK;
  }

  // Open the popup. LaunchPopup will call StopPropagation and PreventDefault
  // in the right situations.
  LaunchPopup(aEvent, targetContent);

  return NS_OK;
}

#ifndef NS_CONTEXT_MENU_IS_MOUSEUP
nsresult
nsXULPopupListener::FireFocusOnTargetContent(nsIDOMNode* aTargetNode, bool aIsTouch)
{
  nsresult rv;
  nsCOMPtr<nsIDOMDocument> domDoc;
  rv = aTargetNode->GetOwnerDocument(getter_AddRefs(domDoc));
  if(NS_SUCCEEDED(rv) && domDoc)
  {
    nsCOMPtr<nsIDocument> doc = do_QueryInterface(domDoc);

    // Get nsIDOMElement for targetNode
    nsIPresShell *shell = doc->GetShell();
    if (!shell)
      return NS_ERROR_FAILURE;

    // strong reference to keep this from going away between events
    // XXXbz between what events?  We don't use this local at all!
    RefPtr<nsPresContext> context = shell->GetPresContext();

    nsCOMPtr<nsIContent> content = do_QueryInterface(aTargetNode);
    nsIFrame* targetFrame = content->GetPrimaryFrame();
    if (!targetFrame) return NS_ERROR_FAILURE;

    const nsStyleUserInterface* ui = targetFrame->StyleUserInterface();
    bool suppressBlur = (ui->mUserFocus == StyleUserFocus::Ignore);

    nsCOMPtr<nsIDOMElement> element;
    nsCOMPtr<nsIContent> newFocus = do_QueryInterface(content);

    nsIFrame* currFrame = targetFrame;
    // Look for the nearest enclosing focusable frame.
    while (currFrame) {
        int32_t tabIndexUnused;
        if (currFrame->IsFocusable(&tabIndexUnused, true)) {
          newFocus = currFrame->GetContent();
          nsCOMPtr<nsIDOMElement> domElement(do_QueryInterface(newFocus));
          if (domElement) {
            element = domElement;
            break;
          }
        }
        currFrame = currFrame->GetParent();
    }

    nsIFocusManager* fm = nsFocusManager::GetFocusManager();
    if (fm) {
      if (element) {
        uint32_t focusFlags = nsIFocusManager::FLAG_BYMOUSE |
                              nsIFocusManager::FLAG_NOSCROLL;
        if (aIsTouch) {
          focusFlags |= nsIFocusManager::FLAG_BYTOUCH;
        }
        fm->SetFocus(element, focusFlags);
      } else if (!suppressBlur) {
        nsPIDOMWindowOuter *window = doc->GetWindow();
        fm->ClearFocus(window);
      }
    }

    EventStateManager* esm = context->EventStateManager();
    nsCOMPtr<nsIContent> focusableContent = do_QueryInterface(element);
    esm->SetContentState(focusableContent, NS_EVENT_STATE_ACTIVE);
  }
  return rv;
}
#endif

// ClosePopup
//
// Do everything needed to shut down the popup.
//
// NOTE: This routine is safe to call even if the popup is already closed.
//
void
nsXULPopupListener::ClosePopup()
{
  if (mPopupContent) {
    // this is called when the listener is going away, so make sure that the
    // popup is hidden. Use asynchronous hiding just to be safe so we don't
    // fire events during destruction.
    nsXULPopupManager* pm = nsXULPopupManager::GetInstance();
    if (pm)
      pm->HidePopup(mPopupContent, false, true, true, false);
    mPopupContent = nullptr;  // release the popup
  }
} // ClosePopup

static already_AddRefed<nsIContent>
GetImmediateChild(nsIContent* aContent, nsIAtom *aTag)
{
  for (nsIContent* child = aContent->GetFirstChild();
       child;
       child = child->GetNextSibling()) {
    if (child->IsXULElement(aTag)) {
      nsCOMPtr<nsIContent> ret = child;
      return ret.forget();
    }
  }

  return nullptr;
}

//
// LaunchPopup
//
// Given the element on which the event was triggered and the mouse locations in
// Client and widget coordinates, popup a new window showing the appropriate
// content.
//
// aTargetContent is the target of the mouse event aEvent that triggered the
// popup. mElement is the element that the popup menu is attached to.
// aTargetContent may be equal to mElement or it may be a descendant.
//
// This looks for an attribute on |mElement| of the appropriate popup type
// (popup, context) and uses that attribute's value as an ID for
// the popup content in the document.
//
nsresult
nsXULPopupListener::LaunchPopup(nsIDOMEvent* aEvent, nsIContent* aTargetContent)
{
  nsresult rv = NS_OK;

  nsAutoString identifier;
  nsIAtom* type = mIsContext ? nsGkAtoms::context : nsGkAtoms::popup;
  bool hasPopupAttr = mElement->GetAttr(kNameSpaceID_None, type, identifier);

  if (identifier.IsEmpty()) {
    hasPopupAttr = mElement->GetAttr(kNameSpaceID_None,
                          mIsContext ? nsGkAtoms::contextmenu : nsGkAtoms::menu,
                          identifier) || hasPopupAttr;
  }

  if (hasPopupAttr) {
    aEvent->StopPropagation();
    aEvent->PreventDefault();
  }

  if (identifier.IsEmpty())
    return rv;

  // Try to find the popup content and the document.
  nsCOMPtr<nsIDocument> document = mElement->GetComposedDoc();
  if (!document) {
    NS_WARNING("No document!");
    return NS_ERROR_FAILURE;
  }

  // Handle the _child case for popups and context menus
  nsCOMPtr<nsIContent> popup;
  if (identifier.EqualsLiteral("_child")) {
    popup = GetImmediateChild(mElement, nsGkAtoms::menupopup);
    if (!popup) {
      nsCOMPtr<nsIDOMDocumentXBL> nsDoc(do_QueryInterface(document));
      nsCOMPtr<nsIDOMNodeList> list;
      nsCOMPtr<nsIDOMElement> el = do_QueryInterface(mElement);
      nsDoc->GetAnonymousNodes(el, getter_AddRefs(list));
      if (list) {
        uint32_t ctr,listLength;
        nsCOMPtr<nsIDOMNode> node;
        list->GetLength(&listLength);
        for (ctr = 0; ctr < listLength; ctr++) {
          list->Item(ctr, getter_AddRefs(node));
          nsCOMPtr<nsIContent> childContent(do_QueryInterface(node));

          if (childContent->NodeInfo()->Equals(nsGkAtoms::menupopup,
                                               kNameSpaceID_XUL)) {
            popup.swap(childContent);
            break;
          }
        }
      }
    }
  } else if (!mElement->IsInUncomposedDoc() ||
             !(popup = document->GetElementById(identifier))) {
    // XXXsmaug Should we try to use ShadowRoot::GetElementById in case
    //          mElement is in shadow DOM?
    //
    // Use getElementById to obtain the popup content and gracefully fail if
    // we didn't find any popup content in the document.
    NS_WARNING("GetElementById had some kind of spasm.");
    return rv;
  }

  // return if no popup was found or the popup is the element itself.
  if (!popup || popup == mElement)
    return NS_OK;

  // Submenus can't be used as context menus or popups, bug 288763.
  // Similar code also in nsXULTooltipListener::GetTooltipFor.
  nsIContent* parent = popup->GetParent();
  if (parent) {
    nsMenuFrame* menu = do_QueryFrame(parent->GetPrimaryFrame());
    if (menu)
      return NS_OK;
  }

  nsXULPopupManager* pm = nsXULPopupManager::GetInstance();
  if (!pm)
    return NS_OK;

  // For left-clicks, if the popup has an position attribute, or both the
  // popupanchor and popupalign attributes are used, anchor the popup to the
  // element, otherwise just open it at the screen position where the mouse
  // was clicked. Context menus always open at the mouse position.
  mPopupContent = popup;
  if (!mIsContext &&
      (mPopupContent->HasAttr(kNameSpaceID_None, nsGkAtoms::position) ||
       (mPopupContent->HasAttr(kNameSpaceID_None, nsGkAtoms::popupanchor) &&
        mPopupContent->HasAttr(kNameSpaceID_None, nsGkAtoms::popupalign)))) {
    pm->ShowPopup(mPopupContent, mElement, EmptyString(), 0, 0,
                  false, true, false, aEvent);
  }
  else {
    int32_t xPos = 0, yPos = 0;
    nsCOMPtr<nsIDOMMouseEvent> mouseEvent = do_QueryInterface(aEvent);
    mouseEvent->GetScreenX(&xPos);
    mouseEvent->GetScreenY(&yPos);

    pm->ShowPopupAtScreen(mPopupContent, xPos, yPos, mIsContext, aEvent);
  }

  return NS_OK;
}
