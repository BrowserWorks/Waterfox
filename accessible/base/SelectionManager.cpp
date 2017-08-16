/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/a11y/SelectionManager.h"

#include "DocAccessible-inl.h"
#include "HyperTextAccessible.h"
#include "HyperTextAccessible-inl.h"
#include "nsAccessibilityService.h"
#include "nsAccUtils.h"
#include "nsCoreUtils.h"
#include "nsEventShell.h"
#include "nsFrameSelection.h"

#include "nsIAccessibleTypes.h"
#include "nsIDOMDocument.h"
#include "nsIPresShell.h"
#include "mozilla/dom/Selection.h"
#include "mozilla/dom/Element.h"

using namespace mozilla;
using namespace mozilla::a11y;
using mozilla::dom::Selection;

struct mozilla::a11y::SelData final
{
  SelData(Selection* aSel, int32_t aReason) :
    mSel(aSel), mReason(aReason) {}

  RefPtr<Selection> mSel;
  int16_t mReason;

  NS_INLINE_DECL_REFCOUNTING(SelData)

private:
  // Private destructor, to discourage deletion outside of Release():
  ~SelData() {}
};

SelectionManager::SelectionManager() :
  mCaretOffset(-1), mAccWithCaret(nullptr)
{

}

void
SelectionManager::ClearControlSelectionListener()
{

  // Remove 'this' registered as selection listener for the normal selection.
  nsCOMPtr<nsISelection> normalSel = do_QueryReferent(mCurrCtrlNormalSel);
  if (normalSel) {
    normalSel->AsSelection()->RemoveSelectionListener(this);
    mCurrCtrlNormalSel = nullptr;
  }

  // Remove 'this' registered as selection listener for the spellcheck
  // selection.
  nsCOMPtr<nsISelection> spellSel = do_QueryReferent(mCurrCtrlSpellSel);
  if (spellSel) {
    spellSel->AsSelection()->RemoveSelectionListener(this);
    mCurrCtrlSpellSel = nullptr;
  }
}

void
SelectionManager::SetControlSelectionListener(dom::Element* aFocusedElm)
{
  // When focus moves such that the caret is part of a new frame selection
  // this removes the old selection listener and attaches a new one for
  // the current focus.
  ClearControlSelectionListener();

  nsIFrame* controlFrame = aFocusedElm->GetPrimaryFrame();
  if (!controlFrame)
    return;

  const nsFrameSelection* frameSel = controlFrame->GetConstFrameSelection();
  NS_ASSERTION(frameSel, "No frame selection for focused element!");
  if (!frameSel)
    return;

  // Register 'this' as selection listener for the normal selection.
  nsCOMPtr<nsISelection> normalSel = frameSel->GetSelection(SelectionType::eNormal);
  normalSel->AsSelection()->AddSelectionListener(this);
  mCurrCtrlNormalSel = do_GetWeakReference(normalSel);

  // Register 'this' as selection listener for the spell check selection.
  nsCOMPtr<nsISelection> spellSel = frameSel->GetSelection(SelectionType::eSpellCheck);
  spellSel->AsSelection()->AddSelectionListener(this);
  mCurrCtrlSpellSel = do_GetWeakReference(spellSel);
}

void
SelectionManager::AddDocSelectionListener(nsIPresShell* aPresShell)
{
  const nsFrameSelection* frameSel = aPresShell->ConstFrameSelection();

  // Register 'this' as selection listener for the normal selection.
  Selection* normalSel = frameSel->GetSelection(SelectionType::eNormal);
  normalSel->AddSelectionListener(this);

  // Register 'this' as selection listener for the spell check selection.
  Selection* spellSel = frameSel->GetSelection(SelectionType::eSpellCheck);
  spellSel->AddSelectionListener(this);
}

void
SelectionManager::RemoveDocSelectionListener(nsIPresShell* aPresShell)
{
  const nsFrameSelection* frameSel = aPresShell->ConstFrameSelection();

  // Remove 'this' registered as selection listener for the normal selection.
  Selection* normalSel = frameSel->GetSelection(SelectionType::eNormal);
  normalSel->RemoveSelectionListener(this);

  // Remove 'this' registered as selection listener for the spellcheck
  // selection.
  Selection* spellSel = frameSel->GetSelection(SelectionType::eSpellCheck);
  spellSel->RemoveSelectionListener(this);
}

void
SelectionManager::ProcessTextSelChangeEvent(AccEvent* aEvent)
{
  // Fire selection change event if it's not pure caret-move selection change,
  // i.e. the accessible has or had not collapsed selection.
  AccTextSelChangeEvent* event = downcast_accEvent(aEvent);
  if (!event->IsCaretMoveOnly())
    nsEventShell::FireEvent(aEvent);

  // Fire caret move event if there's a caret in the selection.
  nsINode* caretCntrNode =
    nsCoreUtils::GetDOMNodeFromDOMPoint(event->mSel->GetFocusNode(),
                                        event->mSel->FocusOffset());
  if (!caretCntrNode)
    return;

  HyperTextAccessible* caretCntr = nsAccUtils::GetTextContainer(caretCntrNode);
  NS_ASSERTION(caretCntr,
               "No text container for focus while there's one for common ancestor?!");
  if (!caretCntr)
    return;

  Selection* selection = caretCntr->DOMSelection();

  // XXX Sometimes we can't get a selection for caretCntr, in that case assume
  // event->mSel is correct.
  if (!selection)
    selection = event->mSel;

  mCaretOffset = caretCntr->DOMPointToOffset(selection->GetFocusNode(),
                                             selection->FocusOffset());
  mAccWithCaret = caretCntr;
  if (mCaretOffset != -1) {
    RefPtr<AccCaretMoveEvent> caretMoveEvent =
      new AccCaretMoveEvent(caretCntr, mCaretOffset, aEvent->FromUserInput());
    nsEventShell::FireEvent(caretMoveEvent);
  }
}

NS_IMETHODIMP
SelectionManager::NotifySelectionChanged(nsIDOMDocument* aDOMDocument,
                                         nsISelection* aSelection,
                                         int16_t aReason)
{
  if (NS_WARN_IF(!aDOMDocument) || NS_WARN_IF(!aSelection)) {
    return NS_ERROR_INVALID_ARG;
  }

  nsCOMPtr<nsIDocument> documentNode(do_QueryInterface(aDOMDocument));
  DocAccessible* document = GetAccService()->GetDocAccessible(documentNode);

#ifdef A11Y_LOG
  if (logging::IsEnabled(logging::eSelection))
    logging::SelChange(aSelection, document, aReason);
#endif

  if (document) {
    // Selection manager has longer lifetime than any document accessible,
    // so that we are guaranteed that the notification is processed before
    // the selection manager is destroyed.
    RefPtr<SelData> selData =
      new SelData(aSelection->AsSelection(), aReason);
    document->HandleNotification<SelectionManager, SelData>
      (this, &SelectionManager::ProcessSelectionChanged, selData);
  }

  return NS_OK;
}

void
SelectionManager::ProcessSelectionChanged(SelData* aSelData)
{
  Selection* selection = aSelData->mSel;
  if (!selection->GetPresShell())
    return;

  const nsRange* range = selection->GetAnchorFocusRange();
  nsINode* cntrNode = nullptr;
  if (range)
    cntrNode = range->GetCommonAncestor();

  if (!cntrNode) {
    cntrNode = selection->GetFrameSelection()->GetAncestorLimiter();
    if (!cntrNode) {
      cntrNode = selection->GetPresShell()->GetDocument();
      NS_ASSERTION(aSelData->mSel->GetPresShell()->ConstFrameSelection() == selection->GetFrameSelection(),
                   "Wrong selection container was used!");
    }
  }

  HyperTextAccessible* text = nsAccUtils::GetTextContainer(cntrNode);
  if (!text) {
    NS_NOTREACHED("We must reach document accessible implementing text interface!");
    return;
  }

  if (selection->GetType() == SelectionType::eNormal) {
    RefPtr<AccEvent> event =
      new AccTextSelChangeEvent(text, selection, aSelData->mReason);
    text->Document()->FireDelayedEvent(event);

  } else if (selection->GetType() == SelectionType::eSpellCheck) {
    // XXX: fire an event for container accessible of the focus/anchor range
    // of the spelcheck selection.
    text->Document()->FireDelayedEvent(nsIAccessibleEvent::EVENT_TEXT_ATTRIBUTE_CHANGED,
                                       text);
  }
}
