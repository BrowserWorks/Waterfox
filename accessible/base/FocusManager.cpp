/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "FocusManager.h"

#include "Accessible-inl.h"
#include "AccIterator.h"
#include "DocAccessible-inl.h"
#include "nsAccessibilityService.h"
#include "nsAccUtils.h"
#include "nsEventShell.h"
#include "Role.h"

#include "nsFocusManager.h"
#include "mozilla/EventStateManager.h"
#include "mozilla/dom/Element.h"
#include "mozilla/dom/TabParent.h"

namespace mozilla {
namespace a11y {

FocusManager::FocusManager()
{
}

FocusManager::~FocusManager()
{
}

Accessible*
FocusManager::FocusedAccessible() const
{
  if (mActiveItem)
    return mActiveItem;

  nsINode* focusedNode = FocusedDOMNode();
  if (focusedNode) {
    DocAccessible* doc = 
      GetAccService()->GetDocAccessible(focusedNode->OwnerDoc());
    return doc ? doc->GetAccessibleEvenIfNotInMapOrContainer(focusedNode) : nullptr;
  }

  return nullptr;
}

bool
FocusManager::IsFocused(const Accessible* aAccessible) const
{
  if (mActiveItem)
    return mActiveItem == aAccessible;

  nsINode* focusedNode = FocusedDOMNode();
  if (focusedNode) {
    // XXX: Before getting an accessible for node having a DOM focus make sure
    // they belong to the same document because it can trigger unwanted document
    // accessible creation for temporary about:blank document. Without this
    // peculiarity we would end up with plain implementation based on
    // FocusedAccessible() method call. Make sure this issue is fixed in
    // bug 638465.
    if (focusedNode->OwnerDoc() == aAccessible->GetNode()->OwnerDoc()) {
      DocAccessible* doc = 
        GetAccService()->GetDocAccessible(focusedNode->OwnerDoc());
      return aAccessible ==
        (doc ? doc->GetAccessibleEvenIfNotInMapOrContainer(focusedNode) : nullptr);
    }
  }
  return false;
}

bool
FocusManager::IsFocusWithin(const Accessible* aContainer) const
{
  Accessible* child = FocusedAccessible();
  while (child) {
    if (child == aContainer)
      return true;

    child = child->Parent();
  }
  return false;
}

FocusManager::FocusDisposition
FocusManager::IsInOrContainsFocus(const Accessible* aAccessible) const
{
  Accessible* focus = FocusedAccessible();
  if (!focus)
    return eNone;

  // If focused.
  if (focus == aAccessible)
    return eFocused;

  // If contains the focus.
  Accessible* child = focus->Parent();
  while (child) {
    if (child == aAccessible)
      return eContainsFocus;

    child = child->Parent();
  }

  // If contained by focus.
  child = aAccessible->Parent();
  while (child) {
    if (child == focus)
      return eContainedByFocus;

    child = child->Parent();
  }

  return eNone;
}

void
FocusManager::NotifyOfDOMFocus(nsISupports* aTarget)
{
#ifdef A11Y_LOG
  if (logging::IsEnabled(logging::eFocus))
    logging::FocusNotificationTarget("DOM focus", "Target", aTarget);
#endif

  mActiveItem = nullptr;

  nsCOMPtr<nsINode> targetNode(do_QueryInterface(aTarget));
  if (targetNode) {
    DocAccessible* document =
      GetAccService()->GetDocAccessible(targetNode->OwnerDoc());
    if (document) {
      // Set selection listener for focused element.
      if (targetNode->IsElement())
        SelectionMgr()->SetControlSelectionListener(targetNode->AsElement());

      document->HandleNotification<FocusManager, nsINode>
        (this, &FocusManager::ProcessDOMFocus, targetNode);
    }
  }
}

void
FocusManager::NotifyOfDOMBlur(nsISupports* aTarget)
{
#ifdef A11Y_LOG
  if (logging::IsEnabled(logging::eFocus))
    logging::FocusNotificationTarget("DOM blur", "Target", aTarget);
#endif

  mActiveItem = nullptr;

  // If DOM document stays focused then fire accessible focus event to process
  // the case when no element within this DOM document will be focused.
  nsCOMPtr<nsINode> targetNode(do_QueryInterface(aTarget));
  if (targetNode && targetNode->OwnerDoc() == FocusedDOMDocument()) {
    nsIDocument* DOMDoc = targetNode->OwnerDoc();
    DocAccessible* document =
      GetAccService()->GetDocAccessible(DOMDoc);
    if (document) {
      // Clear selection listener for previously focused element.
      if (targetNode->IsElement())
        SelectionMgr()->ClearControlSelectionListener();

      document->HandleNotification<FocusManager, nsINode>
        (this, &FocusManager::ProcessDOMFocus, DOMDoc);
    }
  }
}

void
FocusManager::ActiveItemChanged(Accessible* aItem, bool aCheckIfActive)
{
#ifdef A11Y_LOG
  if (logging::IsEnabled(logging::eFocus))
    logging::FocusNotificationTarget("active item changed", "Item", aItem);
#endif

  // Nothing changed, happens for XUL trees and HTML selects.
  if (aItem && aItem == mActiveItem)
    return;

  mActiveItem = nullptr;

  if (aItem && aCheckIfActive) {
    Accessible* widget = aItem->ContainerWidget();
#ifdef A11Y_LOG
    if (logging::IsEnabled(logging::eFocus))
      logging::ActiveWidget(widget);
#endif
    if (!widget || !widget->IsActiveWidget() || !widget->AreItemsOperable())
      return;
  }
  mActiveItem = aItem;

  // If mActiveItem is null, we might need to shift a11y focus to a remote
  // element.
  if (!mActiveItem && XRE_IsParentProcess()) {
    nsFocusManager* domfm = nsFocusManager::GetFocusManager();
    if (domfm) {
      nsIContent* focusedElm = domfm->GetFocusedContent();
      if (focusedElm) {
        bool remote = EventStateManager::IsRemoteTarget(focusedElm);
        if (remote) {
          dom::TabParent* tab = dom::TabParent::GetFrom(focusedElm);
          if (tab) {
            a11y::DocAccessibleParent* dap = tab->GetTopLevelDocAccessible();
            if (dap) {
              Unused << dap->SendRestoreFocus();
            }
          }
        }
      }
    }
  }

  // If active item is changed then fire accessible focus event on it, otherwise
  // if there's no an active item then fire focus event to accessible having
  // DOM focus.
  Accessible* target = FocusedAccessible();
  if (target) {
    DispatchFocusEvent(target->Document(), target);
  }
}

void
FocusManager::ForceFocusEvent()
{
  nsINode* focusedNode = FocusedDOMNode();
  if (focusedNode) {
    DocAccessible* document =
      GetAccService()->GetDocAccessible(focusedNode->OwnerDoc());
    if (document) {
      document->HandleNotification<FocusManager, nsINode>
        (this, &FocusManager::ProcessDOMFocus, focusedNode);
    }
  }
}

void
FocusManager::DispatchFocusEvent(DocAccessible* aDocument,
                                 Accessible* aTarget)
{
  NS_PRECONDITION(aDocument, "No document for focused accessible!");
  if (aDocument) {
    RefPtr<AccEvent> event =
      new AccEvent(nsIAccessibleEvent::EVENT_FOCUS, aTarget,
                   eAutoDetect, AccEvent::eCoalesceOfSameType);
    aDocument->FireDelayedEvent(event);

#ifdef A11Y_LOG
    if (logging::IsEnabled(logging::eFocus))
      logging::FocusDispatched(aTarget);
#endif
  }
}

void
FocusManager::ProcessDOMFocus(nsINode* aTarget)
{
#ifdef A11Y_LOG
  if (logging::IsEnabled(logging::eFocus))
    logging::FocusNotificationTarget("process DOM focus", "Target", aTarget);
#endif

  DocAccessible* document =
    GetAccService()->GetDocAccessible(aTarget->OwnerDoc());
  if (!document)
    return;

  Accessible* target = document->GetAccessibleEvenIfNotInMapOrContainer(aTarget);
  if (target) {
    // Check if still focused. Otherwise we can end up with storing the active
    // item for control that isn't focused anymore.
    nsINode* focusedNode = FocusedDOMNode();
    if (!focusedNode)
      return;

    Accessible* DOMFocus =
      document->GetAccessibleEvenIfNotInMapOrContainer(focusedNode);
    if (target != DOMFocus)
      return;

    Accessible* activeItem = target->CurrentItem();
    if (activeItem) {
      mActiveItem = activeItem;
      target = activeItem;
    }

    DispatchFocusEvent(document, target);
  }
}

void
FocusManager::ProcessFocusEvent(AccEvent* aEvent)
{
  NS_PRECONDITION(aEvent->GetEventType() == nsIAccessibleEvent::EVENT_FOCUS,
                  "Focus event is expected!");

  // Emit focus event if event target is the active item. Otherwise then check
  // if it's still focused and then update active item and emit focus event.
  Accessible* target = aEvent->GetAccessible();
  if (target != mActiveItem) {

    // Check if still focused. Otherwise we can end up with storing the active
    // item for control that isn't focused anymore.
    DocAccessible* document = aEvent->Document();
    nsINode* focusedNode = FocusedDOMNode();
    if (!focusedNode)
      return;

    Accessible* DOMFocus =
      document->GetAccessibleEvenIfNotInMapOrContainer(focusedNode);
    if (target != DOMFocus)
      return;

    Accessible* activeItem = target->CurrentItem();
    if (activeItem) {
      mActiveItem = activeItem;
      target = activeItem;
    }
  }

  // Fire menu start/end events for ARIA menus.
  if (target->IsARIARole(nsGkAtoms::menuitem)) {
    // The focus was moved into menu.
    Accessible* ARIAMenubar = nullptr;
    for (Accessible* parent = target->Parent(); parent; parent = parent->Parent()) {
      if (parent->IsARIARole(nsGkAtoms::menubar)) {
        ARIAMenubar = parent;
        break;
      }

      // Go up in the parent chain of the menu hierarchy.
      if (!parent->IsARIARole(nsGkAtoms::menuitem) &&
          !parent->IsARIARole(nsGkAtoms::menu)) {
        break;
      }
    }

    if (ARIAMenubar != mActiveARIAMenubar) {
      // Leaving ARIA menu. Fire menu_end event on current menubar.
      if (mActiveARIAMenubar) {
        RefPtr<AccEvent> menuEndEvent =
          new AccEvent(nsIAccessibleEvent::EVENT_MENU_END, mActiveARIAMenubar,
                       aEvent->FromUserInput());
        nsEventShell::FireEvent(menuEndEvent);
      }

      mActiveARIAMenubar = ARIAMenubar;

      // Entering ARIA menu. Fire menu_start event.
      if (mActiveARIAMenubar) {
        RefPtr<AccEvent> menuStartEvent =
          new AccEvent(nsIAccessibleEvent::EVENT_MENU_START,
                       mActiveARIAMenubar, aEvent->FromUserInput());
        nsEventShell::FireEvent(menuStartEvent);
      }
    }
  } else if (mActiveARIAMenubar) {
    // Focus left a menu. Fire menu_end event.
    RefPtr<AccEvent> menuEndEvent =
      new AccEvent(nsIAccessibleEvent::EVENT_MENU_END, mActiveARIAMenubar,
                   aEvent->FromUserInput());
    nsEventShell::FireEvent(menuEndEvent);

    mActiveARIAMenubar = nullptr;
  }

#ifdef A11Y_LOG
  if (logging::IsEnabled(logging::eFocus))
    logging::FocusNotificationTarget("fire focus event", "Target", target);
#endif

  // Reset cached caret value. The cache will be updated upon processing the
  // next caret move event. This ensures that we will return the correct caret
  // offset before the caret move event is handled.
  SelectionMgr()->ResetCaretOffset();

  RefPtr<AccEvent> focusEvent =
    new AccEvent(nsIAccessibleEvent::EVENT_FOCUS, target, aEvent->FromUserInput());
  nsEventShell::FireEvent(focusEvent);

  // Fire scrolling_start event when the document receives the focus if it has
  // an anchor jump. If an accessible within the document receive the focus
  // then null out the anchor jump because it no longer applies.
  DocAccessible* targetDocument = target->Document();
  Accessible* anchorJump = targetDocument->AnchorJump();
  if (anchorJump) {
    if (target == targetDocument) {
      // XXX: bug 625699, note in some cases the node could go away before we
      // we receive focus event, for example if the node is removed from DOM.
      nsEventShell::FireEvent(nsIAccessibleEvent::EVENT_SCROLLING_START,
                              anchorJump, aEvent->FromUserInput());
    }
    targetDocument->SetAnchorJump(nullptr);
  }
}

nsINode*
FocusManager::FocusedDOMNode() const
{
  nsFocusManager* DOMFocusManager = nsFocusManager::GetFocusManager();
  nsIContent* focusedElm = DOMFocusManager->GetFocusedContent();

  // No focus on remote target elements like xul:browser having DOM focus and
  // residing in chrome process because it means an element in content process
  // keeps the focus.
  if (focusedElm) {
    if (EventStateManager::IsRemoteTarget(focusedElm)) {
      return nullptr;
    }
    return focusedElm;
  }

  // Otherwise the focus can be on DOM document.
  nsPIDOMWindowOuter* focusedWnd = DOMFocusManager->GetFocusedWindow();
  return focusedWnd ? focusedWnd->GetExtantDoc() : nullptr;
}

nsIDocument*
FocusManager::FocusedDOMDocument() const
{
  nsINode* focusedNode = FocusedDOMNode();
  return focusedNode ? focusedNode->OwnerDoc() : nullptr;
}

} // namespace a11y
} // namespace mozilla
