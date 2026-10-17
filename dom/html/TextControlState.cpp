/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "TextControlState.h"

#include "mozilla/Attributes.h"
#include "mozilla/AutoRestore.h"
#include "mozilla/CaretAssociationHint.h"
#include "mozilla/ErrorResult.h"
#include "mozilla/EventListenerManager.h"
#include "mozilla/EventStateManager.h"
#include "mozilla/IMEStateManager.h"
#include "mozilla/InputEventOptions.h"
#include "mozilla/KeyEventHandler.h"
#include "mozilla/Maybe.h"
#include "mozilla/NativeKeyBindingsType.h"
#include "mozilla/Preferences.h"
#include "mozilla/PresShell.h"
#include "mozilla/ScrollContainerFrame.h"
#include "mozilla/ScrollTypes.h"
#include "mozilla/ShortcutKeys.h"
#include "mozilla/StaticPrefs_dom.h"
#include "mozilla/StaticPrefs_ui.h"
#include "mozilla/TextComposition.h"
#include "mozilla/TextEvents.h"
#include "mozilla/TextInputListener.h"
#include "mozilla/dom/Event.h"
#include "mozilla/dom/HTMLInputElement.h"
#include "mozilla/dom/HTMLTextAreaElement.h"
#include "mozilla/dom/KeyboardEvent.h"
#include "mozilla/dom/ScriptSettings.h"
#include "mozilla/dom/Selection.h"
#include "mozilla/dom/Text.h"
#include "nsAttrValue.h"
#include "nsAttrValueInlines.h"
#include "nsBaseCommandController.h"
#include "nsCOMPtr.h"
#include "nsCaret.h"
#include "nsContentCreatorFunctions.h"
#include "nsContentUtils.h"
#include "nsFocusManager.h"
#include "nsFrameSelection.h"
#include "nsGenericHTMLElement.h"
#include "nsIController.h"
#include "nsIControllers.h"
#include "nsIDOMEventListener.h"
#include "nsIDocumentEncoder.h"
#include "nsIWidget.h"
#include "nsPIDOMWindow.h"
#include "nsServiceManagerUtils.h"
#include "nsTextControlFrame.h"
#include "nsTextNode.h"

namespace mozilla {

using namespace dom;
using ValueSetterOption = TextControlState::ValueSetterOption;
using ValueSetterOptions = TextControlState::ValueSetterOptions;

/*****************************************************************************
 * TextControlElement
 *****************************************************************************/

NS_IMPL_CYCLE_COLLECTION_CLASS(TextControlElement)

NS_IMPL_CYCLE_COLLECTION_TRAVERSE_BEGIN_INHERITED(
    TextControlElement, nsGenericHTMLFormControlElementWithState)
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_END

NS_IMPL_CYCLE_COLLECTION_UNLINK_BEGIN_INHERITED(
    TextControlElement, nsGenericHTMLFormControlElementWithState)
NS_IMPL_CYCLE_COLLECTION_UNLINK_END

NS_IMPL_ISUPPORTS_CYCLE_COLLECTION_INHERITED_0(
    TextControlElement, nsGenericHTMLFormControlElementWithState)

/*static*/
already_AddRefed<TextControlElement>
TextControlElement::GetTextControlElementFromEditingHost(nsIContent* aHost) {
  if (!aHost || !aHost->IsInNativeAnonymousSubtree()) {
    return nullptr;
  }

  auto* parent = TextControlElement::FromNodeOrNull(
      aHost->GetClosestNativeAnonymousSubtreeRootParentOrHost());
  return do_AddRef(parent);
}

TextControlElement::FocusTristate TextControlElement::FocusState() {
  // We can't be focused if we aren't in a (composed) document
  Document* doc = GetComposedDoc();
  if (!doc) {
    return FocusTristate::eUnfocusable;
  }

  // first see if we are disabled or not. If disabled then do nothing.
  if (IsDisabled()) {
    return FocusTristate::eUnfocusable;
  }

  return IsInActiveTab(doc) ? FocusTristate::eActiveWindow
                            : FocusTristate::eInactiveWindow;
}

using ValueChangeKind = TextControlElement::ValueChangeKind;

MOZ_CAN_RUN_SCRIPT inline nsresult SetEditorFlagsIfNecessary(
    EditorBase& aEditorBase, uint32_t aFlags) {
  if (aEditorBase.Flags() == aFlags) {
    return NS_OK;
  }
  return aEditorBase.SetFlags(aFlags);
}

/*****************************************************************************
 * mozilla::AutoInputEventSuppresser
 *****************************************************************************/

class MOZ_STACK_CLASS AutoInputEventSuppresser final {
 public:
  explicit AutoInputEventSuppresser(TextEditor* aTextEditor)
      : mTextEditor(aTextEditor),
        // To protect against a reentrant call to SetValue, we check whether
        // another SetValue is already happening for this editor.  If it is,
        // we must wait until we unwind to re-enable oninput events.
        mOuterTransaction(aTextEditor->IsSuppressingDispatchingInputEvent()) {
    MOZ_ASSERT(mTextEditor);
    mTextEditor->SuppressDispatchingInputEvent(true);
  }
  ~AutoInputEventSuppresser() {
    mTextEditor->SuppressDispatchingInputEvent(mOuterTransaction);
  }

 private:
  RefPtr<TextEditor> mTextEditor;
  bool mOuterTransaction;
};

/*****************************************************************************
 * mozilla::AutoRestoreEditorState
 *****************************************************************************/

class MOZ_RAII AutoRestoreEditorState final {
 public:
  MOZ_CAN_RUN_SCRIPT explicit AutoRestoreEditorState(TextEditor* aTextEditor)
      : mTextEditor(aTextEditor),
        mSavedFlags(mTextEditor->Flags()),
        mSavedMaxLength(mTextEditor->MaxTextLength()),
        mSavedEchoingPasswordPrevented(
            mTextEditor->EchoingPasswordPrevented()) {
    MOZ_ASSERT(mTextEditor);

    // EditorBase::SetFlags() is a virtual method.  Even though it does nothing
    // if new flags and current flags are same, the calling cost causes
    // appearing the method in profile.  So, this class should check if it's
    // necessary to call.
    uint32_t flags = mSavedFlags;
    flags &= ~nsIEditor::eEditorReadonlyMask;
    if (mSavedFlags != flags) {
      // It's aTextEditor and whose lifetime must be guaranteed by the caller.
      MOZ_KnownLive(mTextEditor)->SetFlags(flags);
    }
    mTextEditor->PreventToEchoPassword();
    mTextEditor->SetMaxTextLength(-1);
  }

  MOZ_CAN_RUN_SCRIPT ~AutoRestoreEditorState() {
    if (!mSavedEchoingPasswordPrevented) {
      mTextEditor->AllowToEchoPassword();
    }
    mTextEditor->SetMaxTextLength(mSavedMaxLength);
    // mTextEditor's lifetime must be guaranteed by owner of the instance
    // since the constructor is marked as `MOZ_CAN_RUN_SCRIPT` and this is
    // a stack only class.
    SetEditorFlagsIfNecessary(MOZ_KnownLive(*mTextEditor), mSavedFlags);
  }

 private:
  TextEditor* mTextEditor;
  uint32_t mSavedFlags;
  int32_t mSavedMaxLength;
  bool mSavedEchoingPasswordPrevented;
};

/*****************************************************************************
 * mozilla::AutoDisableUndo
 *****************************************************************************/

class MOZ_RAII AutoDisableUndo final {
 public:
  explicit AutoDisableUndo(TextEditor* aTextEditor)
      : mTextEditor(aTextEditor), mNumberOfMaximumTransactions(0) {
    MOZ_ASSERT(mTextEditor);

    mNumberOfMaximumTransactions =
        mTextEditor ? mTextEditor->NumberOfMaximumTransactions() : 0;
    DebugOnly<bool> disabledUndoRedo = mTextEditor->DisableUndoRedo();
    NS_WARNING_ASSERTION(disabledUndoRedo,
                         "Failed to disable undo/redo transactions");
  }

  ~AutoDisableUndo() {
    // Don't change enable/disable of undo/redo if it's enabled after
    // it's disabled by the constructor because we shouldn't change
    // the maximum undo/redo count to the old value.
    if (mTextEditor->IsUndoRedoEnabled()) {
      return;
    }
    // If undo/redo was enabled, mNumberOfMaximumTransactions is -1 or lager
    // than 0.  Only when it's 0, it was disabled.
    if (mNumberOfMaximumTransactions) {
      DebugOnly<bool> enabledUndoRedo =
          mTextEditor->EnableUndoRedo(mNumberOfMaximumTransactions);
      NS_WARNING_ASSERTION(enabledUndoRedo,
                           "Failed to enable undo/redo transactions");
    } else {
      DebugOnly<bool> disabledUndoRedo = mTextEditor->DisableUndoRedo();
      NS_WARNING_ASSERTION(disabledUndoRedo,
                           "Failed to disable undo/redo transactions");
    }
  }

 private:
  TextEditor* mTextEditor;
  int32_t mNumberOfMaximumTransactions;
};

static bool SuppressEventHandlers(Element* aElement) {
  // Right now we only suppress event handlers and controller manipulation
  // when in a print preview or print context!
  return aElement->OwnerDoc()->IsStaticDocument();
}

/*****************************************************************************
 * mozilla::TextInputSelectionController
 *****************************************************************************/

class TextInputSelectionController final : public nsSupportsWeakReference,
                                           public nsISelectionController {
  ~TextInputSelectionController() = default;

 public:
  NS_DECL_CYCLE_COLLECTING_ISUPPORTS_FINAL
  NS_DECL_CYCLE_COLLECTION_CLASS_AMBIGUOUS(TextInputSelectionController,
                                           nsISelectionController)

  TextInputSelectionController(PresShell* aPresShell,
                               Element& aEditorRootAnonymousDiv);

  void DisconnectFromPresShell();
  nsFrameSelection* GetIndependentFrameSelection() const {
    return mFrameSelection;
  }
  // Will return null if !mFrameSelection.
  Selection* GetSelection(SelectionType aSelectionType);

  // NSISELECTIONCONTROLLER INTERFACES
  NS_IMETHOD SetDisplaySelection(int16_t toggle) override;
  NS_IMETHOD GetDisplaySelection(int16_t* _retval) override;
  NS_IMETHOD SetSelectionFlags(int16_t aInEnable) override;
  NS_IMETHOD GetSelectionFlags(int16_t* aOutEnable) override;
  NS_IMETHOD GetSelectionFromScript(RawSelectionType aRawSelectionType,
                                    Selection** aSelection) override;
  Selection* GetSelection(RawSelectionType aRawSelectionType) override;
  MOZ_CAN_RUN_SCRIPT NS_IMETHOD ScrollSelectionIntoView(
      RawSelectionType aRawSelectionType, SelectionRegion aRegion,
      ControllerScrollFlags aFlags) override;
  NS_IMETHOD RepaintSelection(RawSelectionType aRawSelectionType) override;
  nsresult RepaintSelection(nsPresContext* aPresContext,
                            SelectionType aSelectionType);
  NS_IMETHOD SetCaretEnabled(bool enabled) override;
  NS_IMETHOD SetCaretReadOnly(bool aReadOnly) override;
  NS_IMETHOD GetCaretEnabled(bool* _retval) override;
  NS_IMETHOD GetCaretVisible(bool* _retval) override;
  NS_IMETHOD SetCaretVisibilityDuringSelection(bool aVisibility) override;
  MOZ_CAN_RUN_SCRIPT NS_IMETHOD PhysicalMove(int16_t aDirection,
                                             int16_t aAmount,
                                             bool aExtend) override;
  MOZ_CAN_RUN_SCRIPT NS_IMETHOD CharacterMove(bool aForward,
                                              bool aExtend) override;
  MOZ_CAN_RUN_SCRIPT NS_IMETHOD WordMove(bool aForward, bool aExtend) override;
  MOZ_CAN_RUN_SCRIPT NS_IMETHOD LineMove(bool aForward, bool aExtend) override;
  MOZ_CAN_RUN_SCRIPT NS_IMETHOD IntraLineMove(bool aForward,
                                              bool aExtend) override;
  MOZ_CAN_RUN_SCRIPT NS_IMETHOD ParagraphMove(bool aForward,
                                              bool aExtend) override;
  MOZ_CAN_RUN_SCRIPT NS_IMETHOD PageMove(bool aForward, bool aExtend) override;
  NS_IMETHOD CompleteScroll(bool aForward) override;
  MOZ_CAN_RUN_SCRIPT NS_IMETHOD CompleteMove(bool aForward,
                                             bool aExtend) override;
  NS_IMETHOD ScrollPage(bool aForward) override;
  NS_IMETHOD ScrollLine(bool aForward) override;
  NS_IMETHOD ScrollCharacter(bool aRight) override;
  void SelectionWillTakeFocus() override;
  void SelectionWillLoseFocus() override;
  using nsISelectionController::ScrollSelectionIntoView;

  ScrollContainerFrame* GetScrollFrame() const {
    if (!mFrameSelection) {
      return nullptr;
    }
    auto* limiter = mFrameSelection->GetIndependentSelectionRootElement();
    if (!limiter) {
      return nullptr;
    }
    auto* textControl = limiter->GetContainingShadowHost();
    if (!textControl) {
      return nullptr;
    }
    return do_QueryFrame(textControl->GetPrimaryFrame());
  }

 private:
  RefPtr<nsFrameSelection> mFrameSelection;
  nsWeakPtr mPresShellWeak;
};

NS_IMPL_CYCLE_COLLECTING_ADDREF(TextInputSelectionController)
NS_IMPL_CYCLE_COLLECTING_RELEASE(TextInputSelectionController)
NS_INTERFACE_TABLE_HEAD(TextInputSelectionController)
  NS_INTERFACE_TABLE(TextInputSelectionController, nsISelectionController,
                     nsISelectionDisplay, nsISupportsWeakReference)
  NS_INTERFACE_TABLE_TO_MAP_SEGUE_CYCLE_COLLECTION(TextInputSelectionController)
NS_INTERFACE_MAP_END

NS_IMPL_CYCLE_COLLECTION_WEAK(TextInputSelectionController, mFrameSelection)

TextInputSelectionController::TextInputSelectionController(
    PresShell* aPresShell, Element& aEditorRootAnonymousDiv) {
  if (aPresShell) {
    const bool accessibleCaretEnabled = PresShell::AccessibleCaretEnabled(
        aEditorRootAnonymousDiv.OwnerDoc()->GetDocShell());
    mFrameSelection = new nsFrameSelection(aPresShell, accessibleCaretEnabled,
                                           &aEditorRootAnonymousDiv);
    mPresShellWeak = do_GetWeakReference(aPresShell);

    // Restore drag state if needed.
    // FIXME(emilio): This is a bit hacky...
    auto* draggingNode = aPresShell->GetPresContext()
                             ->EventStateManager()
                             ->GetTrackingDragGestureContent();
    if (draggingNode && draggingNode->GetAsElementOrParentElement() ==
                            &aEditorRootAnonymousDiv) {
      mFrameSelection->RestoreDragState();
    }
  }
}

void TextInputSelectionController::DisconnectFromPresShell() {
  if (mFrameSelection) {
    mFrameSelection->DisconnectFromPresShell();
    mFrameSelection = nullptr;
  }
}

Selection* TextInputSelectionController::GetSelection(
    SelectionType aSelectionType) {
  if (!mFrameSelection) {
    return nullptr;
  }

  return mFrameSelection->GetSelection(aSelectionType);
}

NS_IMETHODIMP
TextInputSelectionController::SetDisplaySelection(int16_t aToggle) {
  if (!mFrameSelection) {
    return NS_ERROR_NULL_POINTER;
  }
  mFrameSelection->SetDisplaySelection(aToggle);
  return NS_OK;
}

NS_IMETHODIMP
TextInputSelectionController::GetDisplaySelection(int16_t* aToggle) {
  if (!mFrameSelection) {
    return NS_ERROR_NULL_POINTER;
  }
  *aToggle = mFrameSelection->GetDisplaySelection();
  return NS_OK;
}

NS_IMETHODIMP
TextInputSelectionController::SetSelectionFlags(int16_t aToggle) {
  return NS_OK;  // stub this out. not used in input
}

NS_IMETHODIMP
TextInputSelectionController::GetSelectionFlags(int16_t* aOutEnable) {
  *aOutEnable = nsISelectionDisplay::DISPLAY_TEXT;
  return NS_OK;
}

NS_IMETHODIMP
TextInputSelectionController::GetSelectionFromScript(
    RawSelectionType aRawSelectionType, Selection** aSelection) {
  if (!mFrameSelection) {
    return NS_ERROR_NULL_POINTER;
  }

  *aSelection =
      mFrameSelection->GetSelection(ToSelectionType(aRawSelectionType));

  // GetSelection() fails only when aRawSelectionType is invalid value.
  if (!(*aSelection)) {
    return NS_ERROR_INVALID_ARG;
  }

  NS_ADDREF(*aSelection);
  return NS_OK;
}

Selection* TextInputSelectionController::GetSelection(
    RawSelectionType aRawSelectionType) {
  return GetSelection(ToSelectionType(aRawSelectionType));
}

NS_IMETHODIMP
TextInputSelectionController::ScrollSelectionIntoView(
    RawSelectionType aRawSelectionType, SelectionRegion aRegion,
    ControllerScrollFlags aFlags) {
  if (!mFrameSelection) {
    return NS_ERROR_NULL_POINTER;
  }
  RefPtr<nsFrameSelection> frameSelection = mFrameSelection;
  return frameSelection->ScrollSelectionIntoView(
      ToSelectionType(aRawSelectionType), aRegion, aFlags);
}

NS_IMETHODIMP
TextInputSelectionController::RepaintSelection(
    RawSelectionType aRawSelectionType) {
  if (!mFrameSelection) {
    return NS_ERROR_NULL_POINTER;
  }
  RefPtr<nsFrameSelection> frameSelection = mFrameSelection;
  return frameSelection->RepaintSelection(ToSelectionType(aRawSelectionType));
}

nsresult TextInputSelectionController::RepaintSelection(
    nsPresContext* aPresContext, SelectionType aSelectionType) {
  if (!mFrameSelection) {
    return NS_ERROR_NULL_POINTER;
  }
  RefPtr<nsFrameSelection> frameSelection = mFrameSelection;
  return frameSelection->RepaintSelection(aSelectionType);
}

NS_IMETHODIMP
TextInputSelectionController::SetCaretEnabled(bool enabled) {
  if (!mPresShellWeak) {
    return NS_ERROR_NOT_INITIALIZED;
  }
  RefPtr<PresShell> presShell = do_QueryReferent(mPresShellWeak);
  if (!presShell) {
    return NS_ERROR_FAILURE;
  }

  // tell the pres shell to enable the caret, rather than settings its
  // visibility directly. this way the presShell's idea of caret visibility is
  // maintained.
  presShell->SetCaretEnabled(enabled);

  return NS_OK;
}

NS_IMETHODIMP
TextInputSelectionController::SetCaretReadOnly(bool aReadOnly) {
  if (!mPresShellWeak) {
    return NS_ERROR_NOT_INITIALIZED;
  }
  nsresult rv;
  RefPtr<PresShell> presShell = do_QueryReferent(mPresShellWeak, &rv);
  if (!presShell) {
    return NS_ERROR_FAILURE;
  }

  if (!mFrameSelection) {
    return NS_ERROR_FAILURE;
  }

  presShell->SetCaretReadOnly(aReadOnly);
  return NS_OK;
}

NS_IMETHODIMP
TextInputSelectionController::GetCaretEnabled(bool* _retval) {
  return GetCaretVisible(_retval);
}

NS_IMETHODIMP
TextInputSelectionController::GetCaretVisible(bool* _retval) {
  if (!mPresShellWeak) {
    return NS_ERROR_NOT_INITIALIZED;
  }
  nsresult rv;
  RefPtr<PresShell> presShell = do_QueryReferent(mPresShellWeak, &rv);
  if (!presShell) {
    return NS_ERROR_FAILURE;
  }
  RefPtr<nsCaret> caret = presShell->GetOriginalCaret();
  if (!caret) {
    return NS_ERROR_FAILURE;
  }
  // If the caret is for another selection, our caret is hidden.
  Selection* selection = caret->GetSelection();
  if (!selection || selection->GetFrameSelection() != mFrameSelection) {
    *_retval = false;
    return NS_OK;
  }
  *_retval = caret->IsVisible();
  return NS_OK;
}

NS_IMETHODIMP
TextInputSelectionController::SetCaretVisibilityDuringSelection(
    bool aVisibility) {
  if (!mPresShellWeak) {
    return NS_ERROR_NOT_INITIALIZED;
  }
  nsresult rv;
  RefPtr<PresShell> presShell = do_QueryReferent(mPresShellWeak, &rv);
  if (!presShell) {
    return NS_ERROR_FAILURE;
  }
  presShell->SetCaretVisibilityDuringSelection(aVisibility);
  return NS_OK;
}

NS_IMETHODIMP
TextInputSelectionController::PhysicalMove(int16_t aDirection, int16_t aAmount,
                                           bool aExtend) {
  if (!mFrameSelection) {
    return NS_ERROR_NULL_POINTER;
  }
  RefPtr<nsFrameSelection> frameSelection = mFrameSelection;
  return frameSelection->PhysicalMove(aDirection, aAmount, aExtend);
}

NS_IMETHODIMP
TextInputSelectionController::CharacterMove(bool aForward, bool aExtend) {
  if (!mFrameSelection) {
    return NS_ERROR_NULL_POINTER;
  }
  RefPtr<nsFrameSelection> frameSelection = mFrameSelection;
  return frameSelection->CharacterMove(aForward, aExtend);
}

NS_IMETHODIMP
TextInputSelectionController::WordMove(bool aForward, bool aExtend) {
  if (!mFrameSelection) {
    return NS_ERROR_NULL_POINTER;
  }
  RefPtr<nsFrameSelection> frameSelection = mFrameSelection;
  return frameSelection->WordMove(aForward, aExtend);
}

NS_IMETHODIMP
TextInputSelectionController::LineMove(bool aForward, bool aExtend) {
  if (!mFrameSelection) {
    return NS_ERROR_NULL_POINTER;
  }
  RefPtr<nsFrameSelection> frameSelection = mFrameSelection;
  nsresult result = frameSelection->LineMove(aForward, aExtend);
  if (NS_FAILED(result)) {
    result = CompleteMove(aForward, aExtend);
  }
  return result;
}

NS_IMETHODIMP
TextInputSelectionController::IntraLineMove(bool aForward, bool aExtend) {
  if (!mFrameSelection) {
    return NS_ERROR_NULL_POINTER;
  }
  RefPtr<nsFrameSelection> frameSelection = mFrameSelection;
  return frameSelection->IntraLineMove(aForward, aExtend);
}

NS_IMETHODIMP
TextInputSelectionController::ParagraphMove(bool aForward, bool aExtend) {
  if (!mFrameSelection) {
    return NS_ERROR_NULL_POINTER;
  }
  RefPtr<nsFrameSelection> frameSelection = mFrameSelection;
  return frameSelection->ParagraphMove(aForward, aExtend);
}

NS_IMETHODIMP
TextInputSelectionController::PageMove(bool aForward, bool aExtend) {
  // expected behavior for PageMove is to scroll AND move the caret
  // and to remain relative position of the caret in view. see Bug 4302.
  if (auto* frame = GetScrollFrame()) {
    RefPtr fs = mFrameSelection;
    // We won't scroll parent scrollable element of mScrollContainerFrame.
    // Therefore, this may be handled when mScrollContainerFrame is completely
    // outside of the view. In such case, user may be confused since they might
    // have wanted to scroll a parent scrollable element. For making clearer
    // which element handles PageDown/PageUp, we should move selection into view
    // even if selection is not changed.
    return fs->PageMove(aForward, aExtend, frame,
                        nsFrameSelection::SelectionIntoView::Yes);
  }
  // Similarly, if there is no scrollable frame, we should move the editor
  // frame into the view for making it clearer which element handles
  // PageDown/PageUp.
  return ScrollSelectionIntoView(SelectionType::eNormal,
                                 nsISelectionController::SELECTION_FOCUS_REGION,
                                 SelectionScrollMode::SyncFlush);
}

NS_IMETHODIMP
TextInputSelectionController::CompleteScroll(bool aForward) {
  if (auto* sf = GetScrollFrame()) {
    sf->ScrollBy(nsIntPoint(0, aForward ? 1 : -1), ScrollUnit::WHOLE,
                 ScrollMode::Instant);
  }
  return NS_OK;
}

NS_IMETHODIMP
TextInputSelectionController::CompleteMove(bool aForward, bool aExtend) {
  if (NS_WARN_IF(!mFrameSelection)) {
    return NS_ERROR_NULL_POINTER;
  }
  RefPtr<nsFrameSelection> frameSelection = mFrameSelection;

  // grab the parent / root DIV for this text widget
  Element* const parentDIV =
      frameSelection->GetIndependentSelectionRootElement();
  if (!parentDIV) {
    return NS_ERROR_UNEXPECTED;
  }

  // make the caret be either at the very beginning (0) or the very end
  uint32_t offset = 0;
  CaretAssociationHint hint = CaretAssociationHint::Before;
  if (aForward) {
    offset = parentDIV->GetChildCount();

    // Prevent the caret from being placed after the last
    // BR node in the content tree!

    if (offset) {
      nsIContent* child = parentDIV->GetLastChild();

      if (child->IsHTMLElement(nsGkAtoms::br)) {
        --offset;
        hint = CaretAssociationHint::After;  // for Bug 106855
      }
    }
  }

  const OwningNonNull<Element> pinnedParentDIV(*parentDIV);
  const nsFrameSelection::FocusMode focusMode =
      aExtend ? nsFrameSelection::FocusMode::kExtendSelection
              : nsFrameSelection::FocusMode::kCollapseToNewPoint;
  frameSelection->HandleClick(pinnedParentDIV, offset, offset, focusMode, hint);

  // if we got this far, attempt to scroll no matter what the above result is
  return CompleteScroll(aForward);
}

NS_IMETHODIMP
TextInputSelectionController::ScrollPage(bool aForward) {
  if (auto* sf = GetScrollFrame()) {
    sf->ScrollBy(nsIntPoint(0, aForward ? 1 : -1), ScrollUnit::PAGES,
                 ScrollMode::Smooth);
  }
  return NS_OK;
}

NS_IMETHODIMP
TextInputSelectionController::ScrollLine(bool aForward) {
  if (auto* sf = GetScrollFrame()) {
    sf->ScrollBy(nsIntPoint(0, aForward ? 1 : -1), ScrollUnit::LINES,
                 ScrollMode::Smooth);
  }
  return NS_OK;
}

NS_IMETHODIMP
TextInputSelectionController::ScrollCharacter(bool aRight) {
  if (auto* sf = GetScrollFrame()) {
    sf->ScrollBy(nsIntPoint(aRight ? 1 : -1, 0), ScrollUnit::LINES,
                 ScrollMode::Smooth);
  }
  return NS_OK;
}

void TextInputSelectionController::SelectionWillTakeFocus() {
  if (mFrameSelection) {
    if (PresShell* shell = mFrameSelection->GetPresShell()) {
      // text input selection always considers to move the
      // selection.
      shell->FrameSelectionWillTakeFocus(
          *mFrameSelection,
          StaticPrefs::dom_selection_mimic_chrome_tostring_enabled()
              ? PresShell::CanMoveLastSelectionForToString::Yes
              : PresShell::CanMoveLastSelectionForToString::No);
    }
  }
}

void TextInputSelectionController::SelectionWillLoseFocus() {
  if (mFrameSelection) {
    if (PresShell* shell = mFrameSelection->GetPresShell()) {
      shell->FrameSelectionWillLoseFocus(*mFrameSelection);
    }
  }
}

/*****************************************************************************
 * mozilla::TextInputListener
 *****************************************************************************/

TextInputListener::TextInputListener(TextControlElement* aTxtCtrlElement)
    : mTxtCtrlElement(aTxtCtrlElement),
      mTextControlState(aTxtCtrlElement ? aTxtCtrlElement->GetTextControlState()
                                        : nullptr) {}

NS_IMPL_CYCLE_COLLECTING_ADDREF(TextInputListener)
NS_IMPL_CYCLE_COLLECTING_RELEASE(TextInputListener)

NS_INTERFACE_MAP_BEGIN(TextInputListener)
  NS_INTERFACE_MAP_ENTRY(nsISupportsWeakReference)
  NS_INTERFACE_MAP_ENTRY(nsIDOMEventListener)
  NS_INTERFACE_MAP_ENTRY_AMBIGUOUS(nsISupports, nsIDOMEventListener)
  NS_INTERFACE_MAP_ENTRIES_CYCLE_COLLECTION(TextInputListener)
NS_INTERFACE_MAP_END

NS_IMPL_CYCLE_COLLECTION_CLASS(TextInputListener)
NS_IMPL_CYCLE_COLLECTION_UNLINK_BEGIN(TextInputListener)
  NS_IMPL_CYCLE_COLLECTION_UNLINK_WEAK_REFERENCE
NS_IMPL_CYCLE_COLLECTION_UNLINK_END
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_BEGIN(TextInputListener)
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_END

void TextInputListener::OnSelectionChange(Selection& aSelection,
                                          int16_t aReason) {
  if (!mListeningToSelectionChange) {
    return;
  }

  RefPtr<TextControlElement> txtCtrlElement = mTxtCtrlElement;

  // Fire the select event
  // The specs don't exactly say when we should fire the select event.
  // IE: Whenever you add/remove a character to/from the selection. Also
  //     each time for select all. Also if you get to the end of the text
  //     field you will get new event for each keypress or a continuous
  //     stream of events if you use the mouse. IE will fire select event
  //     when the selection collapses to nothing if you are holding down
  //     the shift or mouse button.
  // Mozilla: If we have non-empty selection we will fire a new event for each
  //          keypress (or mouseup) if the selection changed. Mozilla will also
  //          create the event each time select all is called, even if
  //          everything was previously selected, because technically select all
  //          will first collapse and then extend. Mozilla will never create an
  //          event if the selection collapses to nothing.
  // FYI: If you want to skip dispatching eFormSelect event and if there are no
  //      event listeners, you can refer
  //      nsPIDOMWindow::HasFormSelectEventListeners(), but be careful about
  //      some C++ event handlers, e.g., HTMLTextAreaElement::PostHandleEvent().
  bool collapsed = aSelection.IsCollapsed();
  if (!collapsed && (aReason & (nsISelectionListener::MOUSEUP_REASON |
                                nsISelectionListener::KEYPRESS_REASON |
                                nsISelectionListener::SELECTALL_REASON))) {
    if (txtCtrlElement) {
      if (auto* frame = txtCtrlElement->GetPrimaryFrame()) {
        RefPtr<PresShell> presShell = frame->PresShell();
        nsEventStatus status = nsEventStatus_eIgnore;
        WidgetEvent event(true, eFormSelect);
        presShell->HandleEventWithTarget(&event, frame, txtCtrlElement,
                                         &status);
      }
    }
  }

  // if the collapsed state did not change, don't fire notifications
  if (collapsed == mSelectionWasCollapsed) {
    return;
  }

  mSelectionWasCollapsed = collapsed;

  if (nsFocusManager::GetFocusedElementStatic() != txtCtrlElement) {
    return;
  }

  UpdateTextInputCommands(u"select"_ns);
}

MOZ_CAN_RUN_SCRIPT
static void DoCommandCallback(Command aCommand, void* aData) {
  RefPtr el = static_cast<TextControlElement*>(aData);
  nsCOMPtr<nsIControllers> controllers;
  if (auto* input = HTMLInputElement::FromNode(el)) {
    input->GetControllers(getter_AddRefs(controllers));
  } else if (auto* textArea = HTMLTextAreaElement::FromNode(el)) {
    textArea->GetControllers(getter_AddRefs(controllers));
  }

  if (!controllers) {
    NS_WARNING("Could not get controllers");
    return;
  }

  const char* commandStr = WidgetKeyboardEvent::GetCommandStr(aCommand);

  nsCOMPtr<nsIController> controller;
  controllers->GetControllerForCommand(commandStr, getter_AddRefs(controller));
  if (!controller) {
    return;
  }

  bool commandEnabled;
  if (NS_WARN_IF(NS_FAILED(
          controller->IsCommandEnabled(commandStr, &commandEnabled)))) {
    return;
  }
  if (commandEnabled) {
    controller->DoCommand(commandStr);
  }
}

void TextInputListener::StartToHandleShortcutKeys() {
  if (mListeningToKeyboardEvents) {
    return;
  }
  EventListenerManager* const manager =
      mTxtCtrlElement->GetOrCreateListenerManager();
  if (!manager) {
    return;
  }
  mListeningToKeyboardEvents = true;
  manager->AddEventListenerByType(this, u"keydown"_ns,
                                  TrustedEventsAtSystemGroupBubble());
  manager->AddEventListenerByType(this, u"keypress"_ns,
                                  TrustedEventsAtSystemGroupBubble());
  manager->AddEventListenerByType(this, u"keyup"_ns,
                                  TrustedEventsAtSystemGroupBubble());
}

void TextInputListener::EndHandlingShortcutKeys() {
  if (!mListeningToKeyboardEvents) {
    return;
  }
  mListeningToKeyboardEvents = false;
  EventListenerManager* const manager =
      mTxtCtrlElement->GetExistingListenerManager();
  if (manager) {
    manager->RemoveEventListenerByType(this, u"keydown"_ns,
                                       TrustedEventsAtSystemGroupBubble());
    manager->RemoveEventListenerByType(this, u"keypress"_ns,
                                       TrustedEventsAtSystemGroupBubble());
    manager->RemoveEventListenerByType(this, u"keyup"_ns,
                                       TrustedEventsAtSystemGroupBubble());
  }
}

MOZ_CAN_RUN_SCRIPT_BOUNDARY NS_IMETHODIMP
TextInputListener::HandleEvent(Event* aEvent) {
  if (aEvent->DefaultPrevented()) {
    return NS_OK;
  }

  if (!aEvent->IsTrusted()) {
    return NS_OK;
  }

  RefPtr<KeyboardEvent> keyEvent = aEvent->AsKeyboardEvent();
  if (!keyEvent) {
    return NS_ERROR_UNEXPECTED;
  }

  WidgetKeyboardEvent* widgetKeyEvent =
      aEvent->WidgetEventPtr()->AsKeyboardEvent();
  if (!widgetKeyEvent) {
    return NS_ERROR_UNEXPECTED;
  }

  {
    auto* input = HTMLInputElement::FromNode(mTxtCtrlElement);
    if (input && input->StepsInputValue(*widgetKeyEvent)) {
      // As an special case, don't handle key events that would step the value
      // of our <input type=number>.
      return NS_OK;
    }
  }

  auto ExecuteOurShortcutKeys = [&](TextControlElement& aTextControlElement)
                                    MOZ_CAN_RUN_SCRIPT_FOR_DEFINITION -> bool {
    KeyEventHandler* keyHandlers = ShortcutKeys::GetHandlers(
        aTextControlElement.IsTextArea() ? HandlerType::eTextArea
                                         : HandlerType::eInput);

    RefPtr<nsAtom> eventTypeAtom =
        ShortcutKeys::ConvertEventToDOMEventType(widgetKeyEvent);
    for (KeyEventHandler* handler = keyHandlers; handler;
         handler = handler->GetNextHandler()) {
      if (!handler->EventTypeEquals(eventTypeAtom)) {
        continue;
      }

      if (!handler->KeyEventMatched(keyEvent, 0, IgnoreModifierState())) {
        continue;
      }

      // XXX Do we execute only one handler even if the handler neither stops
      //     propagation nor prevents default of the event?
      nsresult rv = handler->ExecuteHandler(&aTextControlElement, aEvent);
      if (NS_SUCCEEDED(rv)) {
        return true;
      }
    }
    return false;
  };

  auto ExecuteNativeKeyBindings =
      [&](TextControlElement& aTextControlElement)
          MOZ_CAN_RUN_SCRIPT_FOR_DEFINITION -> bool {
    if (widgetKeyEvent->mMessage != eKeyPress) {
      return false;
    }

    NativeKeyBindingsType nativeKeyBindingsType =
        aTextControlElement.IsTextArea()
            ? NativeKeyBindingsType::MultiLineEditor
            : NativeKeyBindingsType::SingleLineEditor;

    nsIWidget* widget = widgetKeyEvent->mWidget;
    // If the event is created by chrome script, the widget is nullptr.
    if (MOZ_UNLIKELY(!widget)) {
      widget = nsContentUtils::WidgetForContent(&aTextControlElement);
      if (MOZ_UNLIKELY(NS_WARN_IF(!widget))) {
        return false;
      }
    }

    // WidgetKeyboardEvent::ExecuteEditCommands() requires non-nullptr mWidget.
    // If the event is created by chrome script, it is nullptr but we need to
    // execute native key bindings.  Therefore, we need to set widget to
    // WidgetEvent::mWidget temporarily.
    AutoRestore<nsCOMPtr<nsIWidget>> saveWidget(widgetKeyEvent->mWidget);
    widgetKeyEvent->mWidget = widget;
    if (widgetKeyEvent->ExecuteEditCommands(
            nativeKeyBindingsType, DoCommandCallback, &aTextControlElement)) {
      aEvent->PreventDefault();
      return true;
    }
    return false;
  };

  OwningNonNull<TextControlElement> textControlElement(*mTxtCtrlElement);
  if (StaticPrefs::
          ui_key_textcontrol_prefer_native_key_bindings_over_builtin_shortcut_key_definitions()) {
    if (!ExecuteNativeKeyBindings(textControlElement)) {
      ExecuteOurShortcutKeys(textControlElement);
    }
  } else {
    if (!ExecuteOurShortcutKeys(textControlElement)) {
      ExecuteNativeKeyBindings(textControlElement);
    }
  }
  return NS_OK;
}

nsresult TextInputListener::OnEditActionHandled(TextEditor& aTextEditor) {
  // UpdateTextInputCommands may run script
  const RefPtr<TextControlElement> kungFuDeathGrip(mTxtCtrlElement);
  (void)kungFuDeathGrip;

  // Update the undo / redo menus
  //
  size_t numUndoItems = aTextEditor.NumberOfUndoItems();
  size_t numRedoItems = aTextEditor.NumberOfRedoItems();
  if ((numUndoItems && !mHadUndoItems) || (!numUndoItems && mHadUndoItems) ||
      (numRedoItems && !mHadRedoItems) || (!numRedoItems && mHadRedoItems)) {
    // Modify the menu if undo or redo items are different
    UpdateTextInputCommands(u"undo"_ns);

    mHadUndoItems = numUndoItems != 0;
    mHadRedoItems = numRedoItems != 0;
  }

  HandleValueChanged(aTextEditor);

  return mTextControlState ? mTextControlState->OnEditActionHandled() : NS_OK;
}

void TextInputListener::HandleValueChanged(TextEditor& aTextEditor) {
  // Make sure we know we were changed (do NOT set this to false if there are
  // no undo items; JS could change the value and we'd still need to save it)
  if (mSetValueChanged) {
    mTxtCtrlElement->SetValueChanged(true);
  }

  if (!mSettingValue) {
    // NOTE(emilio): execCommand might get here even though it might not be a
    // "proper" user-interactive change. Might be worth reconsidering which
    // ValueChangeKind are we passing down.
    mTxtCtrlElement->OnValueChanged(ValueChangeKind::UserInteraction,
                                    aTextEditor.IsEmpty(), nullptr);
    if (mTextControlState) {
      mTextControlState->ClearLastInteractiveValue();
    }
  }
}

nsresult TextInputListener::UpdateTextInputCommands(
    const nsAString& aCommandsToUpdate) {
  nsCOMPtr<Document> doc = mTxtCtrlElement->GetComposedDoc();
  if (NS_WARN_IF(!doc)) {
    return NS_ERROR_FAILURE;
  }
  nsPIDOMWindowOuter* domWindow = doc->GetWindow();
  if (NS_WARN_IF(!domWindow)) {
    return NS_ERROR_FAILURE;
  }
  domWindow->UpdateCommands(aCommandsToUpdate);
  return NS_OK;
}

/*****************************************************************************
 * mozilla::AutoTextControlHandlingState
 *
 * This class is temporarily created in the stack and can manage nested
 * handling state of TextControlState.  While this instance exists, lifetime of
 * TextControlState which created the instance is guaranteed.  In other words,
 * you can use this class as "kungFuDeathGrip" for TextControlState.
 *****************************************************************************/

enum class TextControlAction {
  CommitComposition,
  Destructor,
  PrepareEditor,
  SetRangeText,
  SetSelectionRange,
  SetValue,
  DeinitSelection,
  Unlink,
};

class MOZ_STACK_CLASS AutoTextControlHandlingState {
 public:
  AutoTextControlHandlingState() = delete;
  explicit AutoTextControlHandlingState(const AutoTextControlHandlingState&) =
      delete;
  AutoTextControlHandlingState(AutoTextControlHandlingState&&) = delete;
  void operator=(AutoTextControlHandlingState&) = delete;
  void operator=(const AutoTextControlHandlingState&) = delete;

  /**
   * Generic constructor.  If TextControlAction does not require additional
   * data, must use this constructor.
   */
  MOZ_CAN_RUN_SCRIPT AutoTextControlHandlingState(
      TextControlState& aTextControlState, TextControlAction aTextControlAction)
      : mParent(aTextControlState.mHandlingState),
        mTextControlState(aTextControlState),
        mTextCtrlElement(aTextControlState.mTextCtrlElement),
        mTextControlAction(aTextControlAction) {
    MOZ_ASSERT(aTextControlAction != TextControlAction::SetValue,
               "Use specific constructor");
    mTextControlState.mHandlingState = this;
    if (Is(TextControlAction::CommitComposition)) {
      MOZ_ASSERT(mParent);
      MOZ_ASSERT(mParent->Is(TextControlAction::SetValue));
      // If we're trying to commit composition before handling SetValue,
      // the parent old values will be outdated so that we need to clear
      // them.
      mParent->InvalidateOldValue();
    }
  }

  /**
   * TextControlAction::SetValue specific constructor.  Current setting value
   * must be specified and the creator should check whether we succeeded to
   * allocate memory for line breaker conversion.
   */
  MOZ_CAN_RUN_SCRIPT AutoTextControlHandlingState(
      TextControlState& aTextControlState, TextControlAction aTextControlAction,
      const nsAString& aSettingValue, const nsAString* aOldValue,
      const ValueSetterOptions& aOptions, ErrorResult& aRv)
      : mParent(aTextControlState.mHandlingState),
        mTextControlState(aTextControlState),
        mTextCtrlElement(aTextControlState.mTextCtrlElement),
        mSettingValue(aSettingValue),
        mOldValue(aOldValue),
        mValueSetterOptions(aOptions),
        mTextControlAction(aTextControlAction) {
    MOZ_ASSERT(aTextControlAction == TextControlAction::SetValue,
               "Use generic constructor");
    mTextControlState.mHandlingState = this;
    if (!nsContentUtils::PlatformToDOMLineBreaks(mSettingValue, fallible)) {
      aRv.Throw(NS_ERROR_OUT_OF_MEMORY);
      return;
    }
    // Update all setting value's new value because older value shouldn't
    // overwrite newer value.
    if (mParent) {
      // If SetValue is nested, parents cannot trust their old value anymore.
      // So, we need to clear them.
      mParent->UpdateSettingValueAndInvalidateOldValue(mSettingValue);
    }
  }

  MOZ_CAN_RUN_SCRIPT ~AutoTextControlHandlingState() {
    mTextControlState.mHandlingState = mParent;
    if (!mParent && mTextControlStateDestroyed) {
      mTextControlState.DeleteOrCacheForReuse();
    }
    if (!mTextControlStateDestroyed && mPrepareEditorLater) {
      MOZ_ASSERT(nsContentUtils::IsSafeToRunScript());
      MOZ_ASSERT(Is(TextControlAction::SetValue));
      mTextControlState.PrepareEditor();
    }
  }

  void OnDestroyTextControlState() {
    if (IsHandling(TextControlAction::Destructor)) {
      // Do nothing since mTextContrlState.DeleteOrCacheForReuse() has
      // already been called.
      return;
    }
    mTextControlStateDestroyed = true;
    if (mParent) {
      mParent->OnDestroyTextControlState();
    }
  }

  void PrepareEditorLater() {
    MOZ_ASSERT(IsHandling(TextControlAction::SetValue));
    MOZ_ASSERT(!IsHandling(TextControlAction::PrepareEditor));
    // Look for the top most SetValue.
    AutoTextControlHandlingState* settingValue = nullptr;
    for (AutoTextControlHandlingState* handlingSomething = this;
         handlingSomething; handlingSomething = handlingSomething->mParent) {
      if (handlingSomething->Is(TextControlAction::SetValue)) {
        settingValue = handlingSomething;
      }
    }
    settingValue->mPrepareEditorLater = true;
  }

  /**
   * WillSetValueWithTextEditor() is called when TextControlState sets
   * value with its mTextEditor.
   */
  void WillSetValueWithTextEditor() {
    MOZ_ASSERT(Is(TextControlAction::SetValue));
    // If we're emulating user input, we don't need to manage mTextInputListener
    // by ourselves since everything should be handled by TextEditor as normal
    // user input.
    if (mValueSetterOptions.contains(ValueSetterOption::BySetUserInputAPI)) {
      return;
    }
    // Otherwise, if we're setting the value programmatically, we need to manage
    // the TextInputListener by ourselves since TextEditor users special path
    // for the performance.
    if (auto* const listener = GetTextInputListener()) [[likely]] {
      listener->SettingValue(true);
      listener->SetValueChanged(
          mValueSetterOptions.contains(ValueSetterOption::SetValueChanged));
    }
    mEditActionHandled = false;
    // Even if falling back to `TextControlState::SetValueWithoutTextEditor()`
    // due to editor destruction, it shouldn't dispatch "beforeinput" event
    // anymore.  Therefore, we should mark that we've already dispatched
    // "beforeinput" event.
    WillDispatchBeforeInputEvent();
  }

  /**
   * WillDispatchBeforeInputEvent() is called immediately before dispatching
   * "beforeinput" event in `TextControlState`.
   */
  void WillDispatchBeforeInputEvent() {
    mBeforeInputEventHasBeenDispatched = true;
  }

  /**
   * OnEditActionHandled() is called when the TextEditor handles something
   * and immediately before dispatching "input" event.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult OnEditActionHandled() {
    MOZ_ASSERT(!mEditActionHandled);
    mEditActionHandled = true;
    if (!Is(TextControlAction::SetValue)) {
      return NS_OK;
    }
    if (!mValueSetterOptions.contains(ValueSetterOption::BySetUserInputAPI)) {
      if (auto* const listener = GetTextInputListener()) {
        listener->SetValueChanged(true);
        listener->SettingValue(
            mParent && mParent->IsHandling(TextControlAction::SetValue));
      }
    }
    return NS_OK;
  }

  bool IsTextControlStateDestroyed() const {
    return mTextControlStateDestroyed;
  }
  bool HasEditActionHandled() const { return mEditActionHandled; }
  bool HasBeforeInputEventDispatched() const {
    return mBeforeInputEventHasBeenDispatched;
  }
  bool Is(TextControlAction aTextControlAction) const {
    return mTextControlAction == aTextControlAction;
  }
  bool IsHandling(TextControlAction aTextControlAction) const {
    if (mTextControlAction == aTextControlAction) {
      return true;
    }
    return mParent && mParent->IsHandling(aTextControlAction);
  }
  TextControlElement* GetTextControlElement() const { return mTextCtrlElement; }
  TextInputListener* GetTextInputListener() const {
    return mTextControlState.mTextInputListener;
  }
  const ValueSetterOptions& ValueSetterOptionsRef() const {
    MOZ_ASSERT(Is(TextControlAction::SetValue));
    return mValueSetterOptions;
  }
  const nsAString* GetOldValue() const {
    MOZ_ASSERT(Is(TextControlAction::SetValue));
    return mOldValue;
  }
  const nsString& GetSettingValue() const {
    MOZ_ASSERT(IsHandling(TextControlAction::SetValue));
    if (mTextControlAction == TextControlAction::SetValue) {
      return mSettingValue;
    }
    return mParent->GetSettingValue();
  }

 private:
  void UpdateSettingValueAndInvalidateOldValue(const nsString& aSettingValue) {
    if (mTextControlAction == TextControlAction::SetValue) {
      mSettingValue = aSettingValue;
    }
    mOldValue = nullptr;
    if (mParent) {
      mParent->UpdateSettingValueAndInvalidateOldValue(aSettingValue);
    }
  }
  void InvalidateOldValue() {
    mOldValue = nullptr;
    if (mParent) {
      mParent->InvalidateOldValue();
    }
  }

  AutoTextControlHandlingState* const mParent;
  TextControlState& mTextControlState;
  // mTextCtrlElement grabs TextControlState::mTextCtrlElement since
  // if the text control element releases mTextControlState, only this
  // can guarantee the instance of the text control element.
  RefPtr<TextControlElement> const mTextCtrlElement;
  nsAutoString mSettingValue;
  const nsAString* mOldValue = nullptr;
  ValueSetterOptions mValueSetterOptions;
  TextControlAction const mTextControlAction;
  bool mTextControlStateDestroyed = false;
  bool mEditActionHandled = false;
  bool mPrepareEditorLater = false;
  bool mBeforeInputEventHasBeenDispatched = false;
};

/*****************************************************************************
 * mozilla::TextControlState
 *****************************************************************************/

/**
 * For avoiding allocation cost of the instance, we should reuse instances
 * as far as possible.
 *
 * FYI: `25` is just a magic number considered without enough investigation,
 *      but at least, this value must not make damage for footprint.
 *      Feel free to change it if you find better number.
 */
static constexpr size_t kMaxCountOfCacheToReuse = 25;
static AutoTArray<void*, kMaxCountOfCacheToReuse>* sReleasedInstances = nullptr;
static bool sHasShutDown = false;

TextControlState::TextControlState(TextControlElement* aOwningElement)
    : mTextCtrlElement(aOwningElement),
      mEverInited(false),
      mEditorInitialized(false),
      mSelectionCached(true)
// When adding more member variable initializations here, add the same
// also to ::Construct.
{
  MOZ_COUNT_CTOR(TextControlState);
  static_assert(sizeof(*this) <= 128,
                "Please keep small TextControlState as far as possible");
}

TextControlState* TextControlState::Construct(
    TextControlElement* aOwningElement) {
  void* mem;
  if (sReleasedInstances && !sReleasedInstances->IsEmpty()) {
    mem = sReleasedInstances->PopLastElement();
  } else {
    mem = moz_xmalloc(sizeof(TextControlState));
  }

  return new (mem) TextControlState(aOwningElement);
}

TextControlState::~TextControlState() {
  MOZ_ASSERT(!mHandlingState);
  MOZ_COUNT_DTOR(TextControlState);
  AutoTextControlHandlingState handlingDesctructor(
      *this, TextControlAction::Destructor);
  Clear();
}

void TextControlState::Shutdown() {
  sHasShutDown = true;
  if (sReleasedInstances) {
    for (void* mem : *sReleasedInstances) {
      free(mem);
    }
    delete sReleasedInstances;
  }
}

void TextControlState::Destroy() {
  // If we're handling something, we should be deleted later.
  if (mHandlingState) {
    mHandlingState->OnDestroyTextControlState();
    return;
  }
  DeleteOrCacheForReuse();
  // Note that this instance may have already been deleted here.  Don't touch
  // any members.
}

void TextControlState::DeleteOrCacheForReuse() {
  MOZ_ASSERT(!IsBusy());

  void* mem = this;
  this->~TextControlState();

  // If we can cache this instance, we should do it instead of deleting it.
  if (!sHasShutDown && (!sReleasedInstances || sReleasedInstances->Length() <
                                                   kMaxCountOfCacheToReuse)) {
    // Put this instance to the cache.  Note that now, the array may be full,
    // but it's not problem to cache more instances than kMaxCountOfCacheToReuse
    // because it just requires reallocation cost of the array buffer.
    if (!sReleasedInstances) {
      sReleasedInstances = new AutoTArray<void*, kMaxCountOfCacheToReuse>;
    }
    sReleasedInstances->AppendElement(mem);
  } else {
    free(mem);
  }
}

nsresult TextControlState::OnEditActionHandled() {
  return mHandlingState ? mHandlingState->OnEditActionHandled() : NS_OK;
}

Element* TextControlState::GetRootNode() {
  return mTextCtrlElement ? mTextCtrlElement->GetTextEditorRoot() : nullptr;
}

Element* TextControlState::GetPreviewNode() {
  return mTextCtrlElement ? mTextCtrlElement->GetTextEditorPreview() : nullptr;
}

void TextControlState::Clear() {
  MOZ_ASSERT(mHandlingState);
  MOZ_ASSERT(mHandlingState->Is(TextControlAction::Destructor) ||
             mHandlingState->Is(TextControlAction::Unlink));
  if (mTextEditor) {
    mTextEditor->SetTextInputListener(nullptr);
  }
  // Currently, DeinitializeSelection() is called when the text control frame is
  // destroyed. Therefore, mTextInputListener has already stopped listening to
  // the keyboard events. However, we own it and we're the only requester of
  // doing that. Thus, we should ensure that it stops listening to the keyboard
  // events before we abandon the ownership.
  if (mTextInputListener) {
    mTextInputListener->EndHandlingShortcutKeys();
  }
  DestroyEditor();
  mTextEditor = nullptr;
  mTextInputListener = nullptr;
}

void TextControlState::Unlink() {
  AutoTextControlHandlingState handlingUnlink(*this, TextControlAction::Unlink);
  UnlinkInternal();
}

void TextControlState::UnlinkInternal() {
  MOZ_ASSERT(mHandlingState);
  MOZ_ASSERT(mHandlingState->Is(TextControlAction::Unlink));
  TextControlState* tmp = this;
  tmp->Clear();
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mSelCon)
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mTextEditor)
}

void TextControlState::Traverse(nsCycleCollectionTraversalCallback& cb) {
  TextControlState* tmp = this;
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mSelCon)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mTextEditor)
}

nsFrameSelection* TextControlState::GetIndependentFrameSelection() const {
  return mSelCon ? mSelCon->GetIndependentFrameSelection() : nullptr;
}

TextEditor* TextControlState::GetTextEditor() {
  // Note that if the instance is destroyed in PrepareEditor(), it returns
  // NS_ERROR_NOT_INITIALIZED so that we don't need to create kungFuDeathGrip
  // in this hot path.
  if (!mTextEditor && NS_WARN_IF(NS_FAILED(PrepareEditor()))) {
    return nullptr;
  }
  return mTextEditor;
}

TextEditor* TextControlState::GetExtantTextEditor() const {
  return mTextEditor;
}

nsISelectionController* TextControlState::GetSelectionController() const {
  return mSelCon;
}

// Helper class, used below in BindToFrame().
class PrepareEditorEvent final : public Runnable {
 public:
  explicit PrepareEditorEvent(TextControlState& aState)
      : Runnable("PrepareEditorEvent"), mState(&aState) {}

  MOZ_CAN_RUN_SCRIPT_BOUNDARY NS_IMETHOD Run() override {
    if (NS_WARN_IF(!mState)) {
      return NS_ERROR_NULL_POINTER;
    }

    mState->PrepareEditor();
    return NS_OK;
  }

 private:
  WeakPtr<TextControlState> mState;
};

nsresult TextControlState::InitializeSelection(PresShell* aPresShell) {
  MOZ_ASSERT(
      !nsContentUtils::IsSafeToRunScript(),
      "TextControlState::BindToFrame() has to be called with script blocker");
  if (NS_WARN_IF(mSelCon)) {
    return NS_ERROR_FAILURE;
  }
  auto* editorRoot = GetRootNode();
  if (NS_WARN_IF(!editorRoot)) {
    return NS_ERROR_FAILURE;
  }

  // Create a SelectionController
  mSelCon = new TextInputSelectionController(aPresShell, *editorRoot);
  EnsureTextInputListener();

  // Editor will override this as needed from InitializeSelection.
  mSelCon->SetDisplaySelection(nsISelectionController::SELECTION_HIDDEN);

  // Get the caret and make it a selection listener.
  // FYI: It's safe to use raw pointer for calling
  //      Selection::AddSelectionListner() because it only appends the listener
  //      to its internal array.
  Selection* selection = mSelCon->GetSelection(SelectionType::eNormal);
  if (selection) {
    RefPtr<nsCaret> caret = aPresShell->GetOriginalCaret();
    if (caret) {
      selection->AddSelectionListener(caret);
    }
    mTextInputListener->StartToListenToSelectionChange();
  }

  // If an editor exists from before, prepare it for usage
  if (mTextEditor) {
    nsContentUtils::AddScriptRunner(MakeAndAddRef<PrepareEditorEvent>(*this));
  }

  return NS_OK;
}

struct MOZ_STACK_CLASS PreDestroyer {
  void Init(TextEditor* aTextEditor) { mTextEditor = aTextEditor; }
  ~PreDestroyer() {
    if (mTextEditor) {
      // In this case, we don't need to restore the unmasked range of password
      // editor.
      UniquePtr<PasswordMaskData> passwordMaskData = mTextEditor->PreDestroy();
    }
  }
  void Swap(RefPtr<TextEditor>& aTextEditor) {
    return mTextEditor.swap(aTextEditor);
  }

 private:
  RefPtr<TextEditor> mTextEditor;
};

void TextControlState::UpdateEditorOnTypeChange() {
  if (!mEditorInitialized) {
    return;
  }
  const auto oldFlags = mTextEditor->Flags();
  auto newFlags = oldFlags;
  if (IsPasswordTextControl()) {
    newFlags |= nsIEditor::eEditorPasswordMask;
  } else {
    newFlags &= ~nsIEditor::eEditorPasswordMask;
  }
  if (oldFlags != newFlags) {
    RefPtr editor = mTextEditor;
    editor->SetFlags(newFlags);
  }
}

void TextControlState::EnsureTextInputListener() {
  if (!mTextInputListener) {
    mTextInputListener = new TextInputListener(mTextCtrlElement);
    // Now, we have new TextInputListener. mTextEditor and this should work with
    // the latest one. Therefore, let's notify mTextEditor of the new instance.
    if (mEditorInitialized) {
      mTextEditor->SetTextInputListener(mTextInputListener);
    }
  }
  mTextInputListener->StartToHandleShortcutKeys();
}

bool TextControlState::IsPreparingEditor() const {
  return mHandlingState &&
         mHandlingState->IsHandling(TextControlAction::PrepareEditor);
}

nsresult TextControlState::PrepareEditor() {
  if (mEditorInitialized) {
    // Do not initialize the editor multiple times.
    return NS_OK;
  }

  AutoHideSelectionChanges hideSelectionChanges(GetIndependentFrameSelection());

  if (mHandlingState) {
    // Don't attempt to initialize recursively!
    if (mHandlingState->IsHandling(TextControlAction::PrepareEditor)) {
      return NS_ERROR_NOT_INITIALIZED;
    }
    // Reschedule creating editor later if we're setting value.
    if (mHandlingState->IsHandling(TextControlAction::SetValue)) {
      mHandlingState->PrepareEditorLater();
      return NS_ERROR_NOT_INITIALIZED;
    }
  }

  MOZ_ASSERT(mTextCtrlElement);

  AutoTextControlHandlingState preparingEditor(
      *this, TextControlAction::PrepareEditor);

  // Note that we don't check mTextEditor here, because we might already have
  // one around, in which case we don't create a new one, and we'll just tie
  // the required machinery to it.

  // Setup the editor flags

  // Spell check is diabled at creation time. It is enabled once
  // the editor comes into focus.
  uint32_t editorFlags = nsIEditor::eEditorSkipSpellCheck;

  if (IsSingleLineTextControl()) {
    editorFlags |= nsIEditor::eEditorSingleLineMask;
  }
  if (IsPasswordTextControl()) {
    editorFlags |= nsIEditor::eEditorPasswordMask;
  }

  bool shouldInitializeEditor = false;
  RefPtr<TextEditor> newTextEditor;  // the editor that we might create
  PreDestroyer preDestroyer;
  if (!mTextEditor) {
    shouldInitializeEditor = true;

    // Create an editor
    newTextEditor = new TextEditor();
    preDestroyer.Init(newTextEditor);
  } else {
    newTextEditor = mTextEditor;  // just pretend that we have a new editor!

    // Don't lose application flags in the process.
    if (newTextEditor->IsMailEditor()) {
      editorFlags |= nsIEditor::eEditorMailMask;
    }
  }

  // Get the current value of the textfield from the content.
  // Note that if we've created a new editor, mTextEditor is null at this stage,
  // so we will get the real value from the content.
  nsAutoString defaultValue;
  GetValue(defaultValue, /* aForDisplay = */ true);

  if (!mEditorInitialized) {
    // Now initialize the editor.
    //
    // NOTE: Conversion of '\n' to <BR> happens inside the
    //       editor's Init() call.

    // Get the DOM document
    nsCOMPtr<Document> doc = mTextCtrlElement->OwnerDoc();

    // What follows is a bit of a hack.  The editor uses the public DOM APIs
    // for its content manipulations, and it causes it to fail some security
    // checks deep inside when initializing. So we explicitly make it clear that
    // we're native code.
    // Note that any script that's directly trying to access our value
    // has to be going through some scriptable object to do that and that
    // already does the relevant security checks.
    AutoNoJSAPI nojsapi;

    RefPtr<Element> anonymousDivElement = GetRootNode();
    if (NS_WARN_IF(!anonymousDivElement) || NS_WARN_IF(!mSelCon)) {
      return NS_ERROR_FAILURE;
    }
    OwningNonNull<TextInputSelectionController> selectionController(*mSelCon);
    UniquePtr<PasswordMaskData> passwordMaskData;
    if (editorFlags & nsIEditor::eEditorPasswordMask) {
      if (mPasswordMaskData) {
        passwordMaskData = std::move(mPasswordMaskData);
      } else {
        passwordMaskData = MakeUnique<PasswordMaskData>();
      }
    } else {
      mPasswordMaskData = nullptr;
    }
    nsresult rv =
        newTextEditor->Init(*doc, *anonymousDivElement, selectionController,
                            editorFlags, std::move(passwordMaskData));
    if (NS_FAILED(rv)) {
      NS_WARNING("TextEditor::Init() failed");
      return rv;
    }
  }

  // Initialize the controller for the editor

  nsresult rv = NS_OK;
  if (!SuppressEventHandlers(mTextCtrlElement)) {
    nsCOMPtr<nsIControllers> controllers;
    if (auto* inputElement = HTMLInputElement::FromNode(mTextCtrlElement)) {
      nsresult rv = inputElement->GetControllers(getter_AddRefs(controllers));
      if (NS_WARN_IF(NS_FAILED(rv))) {
        return rv;
      }
    } else {
      auto* textAreaElement = HTMLTextAreaElement::FromNode(mTextCtrlElement);
      if (!textAreaElement) {
        return NS_ERROR_FAILURE;
      }

      nsresult rv =
          textAreaElement->GetControllers(getter_AddRefs(controllers));
      if (NS_WARN_IF(NS_FAILED(rv))) {
        return rv;
      }
    }

    if (controllers) {
      // XXX Oddly, nsresult value is overwritten in the following loop, and
      //     only the last result or `found` decides the value.
      uint32_t numControllers;
      bool found = false;
      rv = controllers->GetControllerCount(&numControllers);
      for (uint32_t i = 0; i < numControllers; i++) {
        nsCOMPtr<nsIController> controller;
        rv = controllers->GetControllerAt(i, getter_AddRefs(controller));
        if (NS_SUCCEEDED(rv) && controller) {
          nsCOMPtr<nsBaseCommandController> baseController =
              do_QueryInterface(controller);
          if (baseController) {
            baseController->SetContext(newTextEditor);
            found = true;
          }
        }
      }
      if (!found) {
        rv = NS_ERROR_FAILURE;
      }
    }
  }

  // Initialize the plaintext editor
  if (shouldInitializeEditor) {
    const int32_t wrapCols = GetWrapCols();
    MOZ_ASSERT(wrapCols >= 0);
    newTextEditor->SetWrapColumn(wrapCols);
  }

  // Set max text field length
  newTextEditor->SetMaxTextLength(mTextCtrlElement->UsedMaxLength());

  editorFlags = newTextEditor->Flags();

  // Check if the readonly/disabled attributes are set.
  if (mTextCtrlElement->IsDisabledOrReadOnly()) {
    editorFlags |= nsIEditor::eEditorReadonlyMask;
  }

  SetEditorFlagsIfNecessary(*newTextEditor, editorFlags);

  if (shouldInitializeEditor) {
    // Hold on to the newly created editor
    preDestroyer.Swap(mTextEditor);
  }

  // If we have a default value, insert it under the div we created
  // above, but be sure to use the editor so that '*' characters get
  // displayed for password fields, etc. SetValue() will call the
  // editor for us.

  if (!defaultValue.IsEmpty()) {
    // XXX rv may store error code which indicates there is no controller.
    //     However, we overwrite it only in this case.
    rv = SetEditorFlagsIfNecessary(*newTextEditor, editorFlags);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return rv;
    }

    // Now call SetValue() which will make the necessary editor calls to set
    // the default value.  Make sure to turn off undo before setting the default
    // value, and turn it back on afterwards. This will make sure we can't undo
    // past the default value.
    // So, we use ValueSetterOption::ByInternalAPI only that it will turn off
    // undo.

    if (NS_WARN_IF(!SetValue(defaultValue, ValueSetterOption::ByInternalAPI))) {
      return NS_ERROR_OUT_OF_MEMORY;
    }

    // Now restore the original editor flags.
    rv = SetEditorFlagsIfNecessary(*newTextEditor, editorFlags);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return rv;
    }
  }

  DebugOnly<bool> enabledUndoRedo =
      newTextEditor->EnableUndoRedo(TextControlElement::DEFAULT_UNDO_CAP);
  NS_WARNING_ASSERTION(enabledUndoRedo,
                       "Failed to enable undo/redo transaction");

  EnsureTextInputListener();

  if (!mEditorInitialized) {
    newTextEditor->PostCreate();
    mEverInited = true;
    mEditorInitialized = true;
  }
  newTextEditor->SetTextInputListener(mTextInputListener);

  // Restore our selection after initializing the editor.
  if (mSelectionCached) {
    mSelectionCached = false;
    const auto& props = GetSelectionProperties();
    if (props.IsDirty()) {
      SetSelectionRange(props.GetStart(), props.GetEnd(), props.GetDirection(),
                        IgnoreErrors(), ScrollAfterSelection::No);
    }
  } else {
    uint32_t position = 0;

    // Set the selection to the end of the text field (bug 1287655),
    // but only if the contents has changed (bug 1337392).
    if (mTextCtrlElement->ValueChanged()) {
      nsAutoString val;
      GetValue(val, /* aForDisplay = */ true);
      position = val.Length();
    }

    SetSelectionRange(position, position, SelectionDirection::None,
                      IgnoreErrors(), ScrollAfterSelection::No);
  }

  return preparingEditor.IsTextControlStateDestroyed()
             ? NS_ERROR_NOT_INITIALIZED
             : rv;
}

void TextControlState::SetSelectionProperties(
    TextControlState::SelectionProperties& aProps) {
  if (IsSelectionCached() && aProps.HasMaxLength()) {
    GetSelectionProperties().SetMaxLength(*aProps.GetMaxLength());
  }
  SetSelectionRange(aProps.GetStart(), aProps.GetEnd(), aProps.GetDirection(),
                    IgnoreErrors());
}

void TextControlState::GetSelectionRange(uint32_t* aSelectionStart,
                                         uint32_t* aSelectionEnd,
                                         ErrorResult& aRv) {
  MOZ_ASSERT(aSelectionStart);
  MOZ_ASSERT(aSelectionEnd);
  MOZ_ASSERT(IsSelectionCached() || GetSelectionController(),
             "How can we not have a cached selection if we have no selection "
             "controller?");

  // Note that we may have both IsSelectionCached() _and_
  // GetSelectionController() if we haven't initialized our editor yet.
  if (IsSelectionCached()) {
    const SelectionProperties& props = GetSelectionProperties();
    *aSelectionStart = props.GetStart();
    *aSelectionEnd = props.GetEnd();
    return;
  }

  Selection* sel = mSelCon->GetSelection(SelectionType::eNormal);
  if (NS_WARN_IF(!sel)) {
    aRv.Throw(NS_ERROR_FAILURE);
    return;
  }

  Element* root = GetRootNode();
  if (NS_WARN_IF(!root)) {
    aRv.Throw(NS_ERROR_UNEXPECTED);
    return;
  }
  nsContentUtils::GetSelectionInTextControl(sel, root, *aSelectionStart,
                                            *aSelectionEnd);
}

SelectionDirection TextControlState::GetSelectionDirection(ErrorResult& aRv) {
  MOZ_ASSERT(IsSelectionCached() || GetSelectionController(),
             "How can we not have a cached selection if we have no selection "
             "controller?");

  // Note that we may have both IsSelectionCached() _and_
  // GetSelectionController() if we haven't initialized our editor yet.
  if (IsSelectionCached()) {
    return GetSelectionProperties().GetDirection();
  }

  Selection* sel = mSelCon->GetSelection(SelectionType::eNormal);
  if (NS_WARN_IF(!sel)) {
    aRv.Throw(NS_ERROR_FAILURE);
    return SelectionDirection::Forward;
  }

  nsDirection direction = sel->GetDirection();
  if (direction == eDirNext) {
    return SelectionDirection::Forward;
  }

  MOZ_ASSERT(direction == eDirPrevious);
  return SelectionDirection::Backward;
}

void TextControlState::EnsureEditorInitialized() {
  // Create an editor if one doesn't already exist
  NS_ENSURE_SUCCESS_VOID(PrepareEditor());
}

void TextControlState::SetSelectionRange(uint32_t aStart, uint32_t aEnd,
                                         SelectionDirection aDirection,
                                         ErrorResult& aRv,
                                         ScrollAfterSelection aScroll) {
  AutoTextControlHandlingState handlingSetSelectionRange(
      *this, TextControlAction::SetSelectionRange);

  if (aStart > aEnd) {
    aStart = aEnd;
  }

  if (!IsSelectionCached()) {
    RefPtr controller = mTextCtrlElement->GetSelectionController();
    if (!controller) {
      return aRv.Throw(NS_ERROR_UNEXPECTED);
    }
    RefPtr selection =
        controller->GetSelection(nsISelectionController::SELECTION_NORMAL);
    if (!selection) {
      return aRv.Throw(NS_ERROR_UNEXPECTED);
    }
    nsDirection direction = selection->GetDirection();
    if (aDirection != SelectionDirection::None) {
      direction =
          aDirection == SelectionDirection::Backward ? eDirPrevious : eDirNext;
    }

    RefPtr root = GetRootNode();
    if (!root) {
      return aRv.Throw(NS_ERROR_UNEXPECTED);
    }
    nsCOMPtr<nsINode> text = root->GetFirstChild();
    if (NS_WARN_IF(!text)) {
      return aRv.Throw(NS_ERROR_UNEXPECTED);
    }

    uint32_t textLength = text->Length();
    aStart = std::min(aStart, textLength);
    aEnd = std::min(aEnd, textLength);
    auto result = selection->SetStartAndEndInLimiter(
        *text, aStart, *text, aEnd, direction, nsISelectionListener::JS_REASON);
    if (result.isErr()) {
      return aRv.Throw(result.unwrapErr());
    }
    if (handlingSetSelectionRange.IsTextControlStateDestroyed()) {
      return;
    }
    if (aScroll == ScrollAfterSelection::Yes) {
      mTextCtrlElement->ScrollSelectionIntoViewAsync();
    }
    return;
  }

  SelectionProperties& props = GetSelectionProperties();
  if (!props.HasMaxLength()) {
    // A clone without a dirty value flag may not have a max length yet
    nsAutoString value;
    GetValue(value, /* aForDisplay = */ true);
    props.SetMaxLength(value.Length());
  }

  bool changed = props.SetStart(aStart);
  changed |= props.SetEnd(aEnd);
  changed |= props.SetDirection(aDirection);

  if (!changed) {
    return;
  }

  // It sure would be nice if we had an existing Element* or so to work with.
  RefPtr<AsyncEventDispatcher> asyncDispatcher =
      new AsyncEventDispatcher(mTextCtrlElement, eFormSelect, CanBubble::eYes);
  asyncDispatcher->PostDOMEvent();

  // SelectionChangeEventDispatcher covers this when !IsSelectionCached().
  // XXX(krosylight): Shouldn't it fire before select event?
  // Currently Gecko and Blink both fire selectionchange after select.
  if (IsSelectionCached() &&
      StaticPrefs::dom_select_events_textcontrols_selectionchange_enabled() &&
      !mTextCtrlElement->HasScheduledSelectionChangeEvent()) {
    mTextCtrlElement->SetHasScheduledSelectionChangeEvent();
    asyncDispatcher = new AsyncSelectionChangeEventDispatcher(
        mTextCtrlElement, eSelectionChange, CanBubble::eYes);
    asyncDispatcher->PostDOMEvent();
  }
}

void TextControlState::SetSelectionStart(const Nullable<uint32_t>& aStart,
                                         ErrorResult& aRv) {
  uint32_t start = 0;
  if (!aStart.IsNull()) {
    start = aStart.Value();
  }

  uint32_t ignored, end;
  GetSelectionRange(&ignored, &end, aRv);
  if (aRv.Failed()) {
    return;
  }

  SelectionDirection dir = GetSelectionDirection(aRv);
  if (aRv.Failed()) {
    return;
  }

  if (end < start) {
    end = start;
  }

  SetSelectionRange(start, end, dir, aRv);
  // The instance may have already been deleted here.
}

void TextControlState::SetSelectionEnd(const Nullable<uint32_t>& aEnd,
                                       ErrorResult& aRv) {
  uint32_t end = 0;
  if (!aEnd.IsNull()) {
    end = aEnd.Value();
  }

  uint32_t start, ignored;
  GetSelectionRange(&start, &ignored, aRv);
  if (aRv.Failed()) {
    return;
  }

  SelectionDirection dir = GetSelectionDirection(aRv);
  if (aRv.Failed()) {
    return;
  }

  SetSelectionRange(start, end, dir, aRv);
  // The instance may have already been deleted here.
}

static void DirectionToName(SelectionDirection dir, nsAString& aDirection) {
  switch (dir) {
    case SelectionDirection::None:
      // TODO(mbrodesser): this should be supported, see
      // https://bugzilla.mozilla.org/show_bug.cgi?id=1541454.
      NS_WARNING("We don't actually support this... how did we get it?");
      return aDirection.AssignLiteral("none");
    case SelectionDirection::Forward:
      return aDirection.AssignLiteral("forward");
    case SelectionDirection::Backward:
      return aDirection.AssignLiteral("backward");
  }
  MOZ_ASSERT_UNREACHABLE("Invalid SelectionDirection value");
}

void TextControlState::GetSelectionDirectionString(nsAString& aDirection,
                                                   ErrorResult& aRv) {
  SelectionDirection dir = GetSelectionDirection(aRv);
  if (aRv.Failed()) {
    return;
  }
  DirectionToName(dir, aDirection);
}

static SelectionDirection DirectionStringToSelectionDirection(
    const nsAString& aDirection) {
  if (aDirection.EqualsLiteral("backward")) {
    return SelectionDirection::Backward;
  }
  // We don't support directionless selections, see bug 1541454.
  return SelectionDirection::Forward;
}

void TextControlState::SetSelectionDirection(const nsAString& aDirection,
                                             ErrorResult& aRv) {
  SelectionDirection dir = DirectionStringToSelectionDirection(aDirection);

  uint32_t start, end;
  GetSelectionRange(&start, &end, aRv);
  if (aRv.Failed()) {
    return;
  }

  SetSelectionRange(start, end, dir, aRv);
  // The instance may have already been deleted here.
}

static SelectionDirection DirectionStringToSelectionDirection(
    const Optional<nsAString>& aDirection) {
  if (!aDirection.WasPassed()) {
    // We don't support directionless selections.
    return SelectionDirection::Forward;
  }

  return DirectionStringToSelectionDirection(aDirection.Value());
}

void TextControlState::SetSelectionRange(uint32_t aSelectionStart,
                                         uint32_t aSelectionEnd,
                                         const Optional<nsAString>& aDirection,
                                         ErrorResult& aRv,
                                         ScrollAfterSelection aScroll) {
  SelectionDirection dir = DirectionStringToSelectionDirection(aDirection);

  SetSelectionRange(aSelectionStart, aSelectionEnd, dir, aRv, aScroll);
  // The instance may have already been deleted here.
}

void TextControlState::SetRangeText(const nsAString& aReplacement,
                                    ErrorResult& aRv) {
  uint32_t start, end;
  GetSelectionRange(&start, &end, aRv);
  if (aRv.Failed()) {
    return;
  }

  SetRangeText(aReplacement, start, end, SelectionMode::Preserve, aRv,
               Some(start), Some(end));
  // The instance may have already been deleted here.
}

void TextControlState::SetRangeText(const nsAString& aReplacement,
                                    uint32_t aStart, uint32_t aEnd,
                                    SelectionMode aSelectMode, ErrorResult& aRv,
                                    const Maybe<uint32_t>& aSelectionStart,
                                    const Maybe<uint32_t>& aSelectionEnd) {
  if (aStart > aEnd) {
    aRv.Throw(NS_ERROR_DOM_INDEX_SIZE_ERR);
    return;
  }

  AutoTextControlHandlingState handlingSetRangeText(
      *this, TextControlAction::SetRangeText);

  nsAutoString value;
  mTextCtrlElement->GetValueFromSetRangeText(value);
  uint32_t inputValueLength = value.Length();

  if (aStart > inputValueLength) {
    aStart = inputValueLength;
  }

  if (aEnd > inputValueLength) {
    aEnd = inputValueLength;
  }

  uint32_t selectionStart, selectionEnd;
  if (!aSelectionStart) {
    MOZ_ASSERT(!aSelectionEnd);
    GetSelectionRange(&selectionStart, &selectionEnd, aRv);
    if (aRv.Failed()) {
      return;
    }
  } else {
    MOZ_ASSERT(aSelectionEnd);
    selectionStart = *aSelectionStart;
    selectionEnd = *aSelectionEnd;
  }

  // Batch selectionchanges from SetValueFromSetRangeText and SetSelectionRange
  Selection* selection =
      mSelCon ? mSelCon->GetSelection(SelectionType::eNormal) : nullptr;
  SelectionBatcher selectionBatcher(
      // `selection` will be grabbed by selectionBatcher itself.  Thus, we don't
      // need to grab it by ourselves.
      MOZ_KnownLive(selection), __FUNCTION__,
      nsISelectionListener::JS_REASON);  // no-op if nullptr

  MOZ_ASSERT(aStart <= aEnd);
  value.Replace(aStart, aEnd - aStart, aReplacement);
  nsresult rv =
      MOZ_KnownLive(mTextCtrlElement)->SetValueFromSetRangeText(value);
  if (NS_FAILED(rv)) {
    aRv.Throw(rv);
    return;
  }

  uint32_t newEnd = aStart + aReplacement.Length();
  int32_t delta = aReplacement.Length() - (aEnd - aStart);

  switch (aSelectMode) {
    case SelectionMode::Select:
      selectionStart = aStart;
      selectionEnd = newEnd;
      break;
    case SelectionMode::Start:
      selectionStart = selectionEnd = aStart;
      break;
    case SelectionMode::End:
      selectionStart = selectionEnd = newEnd;
      break;
    case SelectionMode::Preserve:
      if (selectionStart > aEnd) {
        selectionStart += delta;
      } else if (selectionStart > aStart) {
        selectionStart = aStart;
      }

      if (selectionEnd > aEnd) {
        selectionEnd += delta;
      } else if (selectionEnd > aStart) {
        selectionEnd = newEnd;
      }
      break;
    default:
      MOZ_ASSERT_UNREACHABLE("Unknown mode!");
  }

  SetSelectionRange(selectionStart, selectionEnd, Optional<nsAString>(), aRv);
  if (IsSelectionCached()) {
    // SetValueFromSetRangeText skipped SetMaxLength, set it here properly
    GetSelectionProperties().SetMaxLength(value.Length());
  }
}

void TextControlState::DestroyEditor() {
  // notify the editor that we are going away
  if (mEditorInitialized) {
    // FYI: TextEditor checks whether it's destroyed or not immediately after
    //      changes the DOM tree or selection so that it's safe to call
    //      PreDestroy() here even while we're handling actions with
    //      mTextEditor.
    MOZ_ASSERT(!mPasswordMaskData);
    RefPtr<TextEditor> textEditor = mTextEditor;
    mPasswordMaskData = textEditor->PreDestroy();
    MOZ_ASSERT_IF(mPasswordMaskData, !mPasswordMaskData->mTimer);
    mEditorInitialized = false;
  }
  // NOTE(emilio): It's important _not_ to null out mTextEditor (at least as
  // long as we can re-attach frames to it).
}

void TextControlState::DeinitSelection() {
  AutoTextControlHandlingState handling(*this,
                                        TextControlAction::DeinitSelection);
  if (mSelCon) {
    mSelCon->SelectionWillLoseFocus();
  }

  // Save our current value in mValue if our editor is initialized, before we
  // lose it. Similarly, cache our selection state (if needed).
  // Note that GetSelectionRange will attempt to work with our selection
  // controller, so we should make sure we do it before we start doing things
  // like destroying our editor (if we have one), tearing down the selection
  // controller, and so forth. Similarly, GetValue will pull from our editor, so
  // do that before tearing it down below.
  if (mEditorInitialized) {
    GetValue(mValue, /* aForDisplay = */ true);
  }

  if (!IsSelectionCached()) {
    // Go ahead and cache it now.
    uint32_t start = 0, end = 0;
    GetSelectionRange(&start, &end, IgnoreErrors());

    SelectionDirection direction = GetSelectionDirection(IgnoreErrors());

    SelectionProperties& props = GetSelectionProperties();
    props.SetMaxLength(mValue.Length());
    props.SetStart(start);
    props.SetEnd(end);
    props.SetDirection(direction);
    props.SetIsDirty();
    mSelectionCached = true;
  }

  // Destroy our editor
  DestroyEditor();

  // Clean up the controllers if they exist.
  if (!SuppressEventHandlers(mTextCtrlElement)) {
    const nsCOMPtr<nsIControllers> controllers = [&]() -> nsIControllers* {
      if (const auto* const inputElement =
              HTMLInputElement::FromNode(mTextCtrlElement)) {
        return inputElement->GetExtantControllers();
      }
      if (const auto* const textAreaElement =
              HTMLTextAreaElement::FromNode(mTextCtrlElement)) {
        return textAreaElement->GetExtantControllers();
      }
      return nullptr;
    }();

    if (controllers) {
      uint32_t numControllers;
      nsresult rv = controllers->GetControllerCount(&numControllers);
      NS_ASSERTION((NS_SUCCEEDED(rv)),
                   "bad result in gfx text control destructor");
      for (uint32_t i = 0; i < numControllers; i++) {
        nsCOMPtr<nsIController> controller;
        rv = controllers->GetControllerAt(i, getter_AddRefs(controller));
        if (NS_SUCCEEDED(rv) && controller) {
          nsCOMPtr<nsBaseCommandController> editController =
              do_QueryInterface(controller);
          if (editController) {
            editController->SetContext(nullptr);
          }
        }
      }
    }
  }

  if (mSelCon) {
    if (mTextInputListener) {
      mTextInputListener->EndListeningToSelectionChange();
    }

    mSelCon->DisconnectFromPresShell();
    mSelCon = nullptr;
  }

  if (mTextInputListener) {
    mTextInputListener->EndHandlingShortcutKeys();
  }
}

void TextControlState::GetValue(nsAString& aValue, bool aForDisplay) const {
  // While SetValue() is being called and requesting to commit composition to
  // IME, GetValue() may be called for appending text or something.  Then, we
  // need to return the latest aValue of SetValue() since the value hasn't
  // been set to the editor yet.
  // XXX After implementing "beforeinput" event, this becomes wrong.  The
  //     value should be modified immediately after "beforeinput" event for
  //     "insertReplacementText".
  if (mHandlingState &&
      mHandlingState->IsHandling(TextControlAction::CommitComposition)) {
    aValue = mHandlingState->GetSettingValue();
    MOZ_ASSERT(aValue.FindChar(u'\r') == -1);
    return;
  }

  if (mTextEditor && mEditorInitialized) {
    aValue.Truncate();  // initialize out param
    DebugOnly<nsresult> rv = mTextEditor->ComputeTextValue(aValue);
    MOZ_ASSERT(aValue.FindChar(u'\r') == -1);
    NS_WARNING_ASSERTION(NS_SUCCEEDED(rv), "Failed to get value");
  } else if (!mTextCtrlElement->ValueChanged() || mValue.IsVoid()) {
    // Use nsString to avoid copying string buffer at setting aValue.
    nsString value;
    mTextCtrlElement->GetDefaultValueFromContent(value, aForDisplay);
    // TODO: We should make default value not include \r.
    nsContentUtils::PlatformToDOMLineBreaks(value);
    aValue = std::move(value);
  } else {
    aValue = mValue;
    MOZ_ASSERT(aValue.FindChar(u'\r') == -1);
  }
}

bool TextControlState::ValueEquals(const nsAString& aValue) const {
  nsAutoString value;
  GetValue(value, /* aForDisplay = */ true);
  return aValue.Equals(value);
}

#ifdef DEBUG
// @param aOptions TextControlState::ValueSetterOptions
bool AreFlagsNotDemandingContradictingMovements(
    const ValueSetterOptions& aOptions) {
  return !aOptions.contains(
      {ValueSetterOption::MoveCursorToBeginSetSelectionDirectionForward,
       ValueSetterOption::MoveCursorToEndIfValueChanged});
}
#endif  // DEBUG

bool TextControlState::SetValue(const nsAString& aValue,
                                const nsAString* aOldValue,
                                const ValueSetterOptions& aOptions) {
  if (mHandlingState &&
      mHandlingState->IsHandling(TextControlAction::CommitComposition)) {
    // GetValue doesn't return current text frame's content during committing.
    // So we cannot trust this old value
    aOldValue = nullptr;
  }

  if (mPasswordMaskData) {
    // We should mask the new password, even if it's same value
    // since the same value may be one for different web app's.
    mPasswordMaskData->Reset();
  }

  const bool wasHandlingSetValue =
      mHandlingState && mHandlingState->IsHandling(TextControlAction::SetValue);

  ErrorResult error;
  AutoTextControlHandlingState handlingSetValue(
      *this, TextControlAction::SetValue, aValue, aOldValue, aOptions, error);
  if (error.Failed()) [[unlikely]] {
    MOZ_ASSERT(error.ErrorCodeIs(NS_ERROR_OUT_OF_MEMORY));
    error.SuppressException();
    return false;
  }

  const auto changeKind = [&] {
    if (aOptions.contains(ValueSetterOption::ByInternalAPI)) {
      return ValueChangeKind::Internal;
    }
    if (aOptions.contains(ValueSetterOption::BySetUserInputAPI)) {
      return ValueChangeKind::UserInteraction;
    }
    return ValueChangeKind::Script;
  }();

  if (changeKind == ValueChangeKind::Script) {
    // This value change will not be interactive. If we're an input that was
    // interactively edited, save the last interactive value now before it goes
    // away.
    if (auto* input = HTMLInputElement::FromNode(mTextCtrlElement)) {
      if (input->LastValueChangeWasInteractive()) {
        GetValue(mLastInteractiveValue, /* aForDisplay = */ true);
      }
    }
  }

  // Note that if this may be called during reframe of the editor.  In such
  // case, we shouldn't commit composition.  Therefore, when this is called
  // for internal processing, we shouldn't commit the composition.
  // TODO: In strictly speaking, we should move committing composition into
  //       editor because if "beforeinput" for this setting value is canceled,
  //       we shouldn't commit composition.  However, in Firefox, we never
  //       call this via `setUserInput` during composition.  Therefore, the
  //       bug must not be reproducible actually.
  if (aOptions.contains(ValueSetterOption::BySetUserInputAPI) ||
      aOptions.contains(ValueSetterOption::ByContentAPI)) {
    RefPtr<TextComposition> compositionInEditor =
        mTextEditor ? mTextEditor->GetComposition() : nullptr;
    if (compositionInEditor && compositionInEditor->IsComposing()) {
      // When this is called recursively, there shouldn't be composition.
      if (handlingSetValue.IsHandling(TextControlAction::CommitComposition)) {
        // Don't request to commit composition again.  But if it occurs,
        // we should skip to set the new value to the editor here.  It should
        // be set later with the newest value.
        return true;
      }
      // If setting value won't change current value, we shouldn't commit
      // composition for compatibility with the other browsers.
      MOZ_ASSERT(!aOldValue || ValueEquals(*aOldValue));
      bool isSameAsCurrentValue =
          aOldValue ? aOldValue->Equals(handlingSetValue.GetSettingValue())
                    : ValueEquals(handlingSetValue.GetSettingValue());
      if (isSameAsCurrentValue) {
        // Note that in this case, we shouldn't fire any events with setting
        // value because event handlers may try to set value recursively but
        // we cannot commit composition at that time due to unsafe to run
        // script (see below).
        return true;
      }
      // If there is composition, need to commit composition first because
      // other browsers do that.
      // NOTE: We don't need to block nested calls of this because input nor
      //       other events won't be fired by setting values and script blocker
      //       is used during setting the value to the editor.  IE also allows
      //       to set the editor value on the input event which is caused by
      //       forcibly committing composition.
      AutoTextControlHandlingState handlingCommitComposition(
          *this, TextControlAction::CommitComposition);
      if (nsContentUtils::IsSafeToRunScript()) {
        // While we're committing composition, we don't want TextEditor
        // dispatches nested `beforeinput`/`input` events if this is called by a
        // `beforeinput`/`input` event listener since the commit value will be
        // completely overwritten by the new value soon and the web app do not
        // need to handle the temporary input caused by committing composition
        // which is caused by updating the value by the web app itself  Note
        // that `input` event listener may be async function and setting value
        // may occur after the editor ends dispatching `input` event. Even in
        // this case, to avoid nest call of the async `input` event listener, we
        // need to suppress `input` events caused by committing composition.  On
        // the other hand, we need to dispatch `input` event when the value is
        // set by a `compositionupdate` event listener because once we suppress
        // `input` event for it, the composition change won't cause dispatching
        // `input` event.  Therefore, we should not suppress `input` events
        // before the editor starts handling the composition change, but we need
        // to suppress `input` events even after the editor ends handling the
        // change.
        // FYI: Even if we suppress `input` event dispatching,
        // `compositionupdate` and `compositionend` caused by the committing
        // composition will be fired.  Therefore, everything could occur during
        // a the following call.  I.e., the document may be unloaded by the web
        // app itself.
        Maybe<AutoInputEventSuppresser> preventInputEventsDuringCommit;
        if (mTextEditor->IsDispatchingInputEvent() ||
            compositionInEditor->EditorHasHandledLatestChange()) {
          preventInputEventsDuringCommit.emplace(mTextEditor);
        }
        OwningNonNull<TextEditor> textEditor(*mTextEditor);
        nsresult rv = textEditor->CommitComposition();
        if (handlingCommitComposition.IsTextControlStateDestroyed()) {
          return true;
        }
        if (NS_FAILED(rv)) {
          NS_WARNING("TextControlState failed to commit composition");
          return true;
        }
        // Note that if a composition event listener sets editor value again,
        // we should use the new value here.  The new value is stored in
        // handlingSetValue right now.
      } else {
        NS_WARNING(
            "SetValue() is called when there is composition but "
            "it's not safe to request to commit the composition");
      }
    }
  }

  if (mEditorInitialized) {
    if (!SetValueWithTextEditor(handlingSetValue)) {
      return false;
    }
  } else if (!SetValueWithoutTextEditor(handlingSetValue)) {
    return false;
  }

  // If we were handling SetValue() before, don't update the DOM state twice,
  // just let the outer call do so.
  if (!wasHandlingSetValue) {
    handlingSetValue.GetTextControlElement()->OnValueChanged(
        changeKind, handlingSetValue.GetSettingValue());
  }
  return true;
}

bool TextControlState::SetValueWithTextEditor(
    AutoTextControlHandlingState& aHandlingSetValue) {
  MOZ_ASSERT(aHandlingSetValue.Is(TextControlAction::SetValue));
  MOZ_ASSERT(mTextEditor);
  MOZ_DIAGNOSTIC_ASSERT(mEditorInitialized);
  MOZ_DIAGNOSTIC_ASSERT(mTextInputListener);
  NS_WARNING_ASSERTION(!EditorHasComposition(),
                       "Failed to commit composition before setting value.  "
                       "Investigate the cause!");

#ifdef DEBUG
  if (IsSingleLineTextControl()) {
    NS_ASSERTION(mEditorInitialized || aHandlingSetValue.IsHandling(
                                           TextControlAction::PrepareEditor),
                 "We should never try to use the editor if we're not "
                 "initialized unless we're being initialized");
  }
#endif

  MOZ_ASSERT(!aHandlingSetValue.GetOldValue() ||
             ValueEquals(*aHandlingSetValue.GetOldValue()));
  const bool isSameAsCurrentValue =
      aHandlingSetValue.GetOldValue()
          ? aHandlingSetValue.GetOldValue()->Equals(
                aHandlingSetValue.GetSettingValue())
          : ValueEquals(aHandlingSetValue.GetSettingValue());

  // this is necessary to avoid infinite recursion
  if (isSameAsCurrentValue) {
    return true;
  }

  RefPtr<TextEditor> textEditor = mTextEditor;

  nsCOMPtr<Document> document = textEditor->GetDocument();
  if (NS_WARN_IF(!document)) {
    return true;
  }

  // Time to mess with our security context... See comments in GetValue()
  // for why this is needed.  Note that we have to do this up here, because
  // otherwise SelectAll() will fail.
  AutoNoJSAPI nojsapi;

  // FYI: It's safe to use raw pointer for selection here because
  //      SelectionBatcher will grab it with RefPtr.
  Selection* selection = mSelCon->GetSelection(SelectionType::eNormal);
  SelectionBatcher selectionBatcher(
      // `selection` will be grabbed by selectionBatcher itself.  Thus, we don't
      // need to grab it by ourselves.
      MOZ_KnownLive(selection), __FUNCTION__);

  // get the flags, remove readonly, disabled and max-length,
  // set the value, restore flags
  AutoRestoreEditorState restoreState(textEditor);

  aHandlingSetValue.WillSetValueWithTextEditor();

  if (aHandlingSetValue.ValueSetterOptionsRef().contains(
          ValueSetterOption::BySetUserInputAPI)) {
    // If the caller inserts text as part of user input, for example,
    // autocomplete, we need to replace the text as "insert string"
    // because undo should cancel only this operation (i.e., previous
    // transactions typed by user shouldn't be merged with this).
    // In this case, we need to dispatch "input" event because
    // web apps may need to know the user's operation.
    // In this case, we need to dispatch "beforeinput" events since
    // we're emulating the user's input.  Passing nullptr as
    // nsIPrincipal means that that may be user's input.  So, let's
    // do it.
    nsresult rv = textEditor->ReplaceTextAsAction(
        aHandlingSetValue.GetSettingValue(), nullptr,
        StaticPrefs::dom_input_event_allow_to_cancel_set_user_input()
            ? TextEditor::AllowBeforeInputEventCancelable::Yes
            : TextEditor::AllowBeforeInputEventCancelable::No);
    NS_WARNING_ASSERTION(NS_SUCCEEDED(rv),
                         "EditorBase::ReplaceTextAsAction() failed");
    return rv != NS_ERROR_OUT_OF_MEMORY;
  }

  // Don't dispatch "beforeinput" event nor "input" event for setting value
  // by script.
  AutoInputEventSuppresser suppressInputEventDispatching(textEditor);

  // On <input> or <textarea>, we shouldn't preserve existing undo
  // transactions because other browsers do not preserve them too
  // and not preserving transactions makes setting value faster.
  //
  // (Except if chrome opts into this behavior).
  Maybe<AutoDisableUndo> disableUndo;
  if (!aHandlingSetValue.ValueSetterOptionsRef().contains(
          ValueSetterOption::PreserveUndoHistory)) {
    disableUndo.emplace(textEditor);
  }

  if (selection) {
    // Since we don't use undo transaction, we don't need to store
    // selection state.  SetText will set selection to tail.
    IgnoredErrorResult ignoredError;
    MOZ_KnownLive(selection)->RemoveAllRanges(ignoredError);
    NS_WARNING_ASSERTION(!ignoredError.Failed(),
                         "Selection::RemoveAllRanges() failed, but ignored");
  }

  // In this case, we makes the editor stop dispatching "input"
  // event so that passing nullptr as nsIPrincipal is safe for now.
  nsresult rv = textEditor->SetTextAsAction(
      aHandlingSetValue.GetSettingValue(),
      aHandlingSetValue.ValueSetterOptionsRef().contains(
          ValueSetterOption::BySetUserInputAPI) &&
              !StaticPrefs::dom_input_event_allow_to_cancel_set_user_input()
          ? TextEditor::AllowBeforeInputEventCancelable::No
          : TextEditor::AllowBeforeInputEventCancelable::Yes,
      nullptr);
  NS_WARNING_ASSERTION(NS_SUCCEEDED(rv),
                       "TextEditor::SetTextAsAction() failed");

  // Call the listener's OnEditActionHandled() callback manually if
  // OnEditActionHandled() hasn't been called yet since TextEditor don't use
  // the transaction manager in this path and it could be that the editor
  // would bypass calling the listener for that reason.
  if (!aHandlingSetValue.HasEditActionHandled()) {
    nsresult rvOnEditActionHandled =
        MOZ_KnownLive(aHandlingSetValue.GetTextInputListener())
            ->OnEditActionHandled(*textEditor);
    NS_WARNING_ASSERTION(NS_SUCCEEDED(rvOnEditActionHandled),
                         "TextInputListener::OnEditActionHandled() failed");
    if (rv != NS_ERROR_OUT_OF_MEMORY) {
      rv = rvOnEditActionHandled;
    }
  }

  return rv != NS_ERROR_OUT_OF_MEMORY;
}

bool TextControlState::SetValueWithoutTextEditor(
    AutoTextControlHandlingState& aHandlingSetValue) {
  MOZ_ASSERT(aHandlingSetValue.Is(TextControlAction::SetValue));
  MOZ_ASSERT(!mEditorInitialized);
  NS_WARNING_ASSERTION(!EditorHasComposition(),
                       "Failed to commit composition before setting value.  "
                       "Investigate the cause!");

  if (mValue.IsVoid()) {
    mValue.SetIsVoid(false);
  }

  if (mValue.Equals(aHandlingSetValue.GetSettingValue())) {
    // Even if our value is not actually changing, apparently we need to mark
    // our SelectionProperties dirty to make accessibility tests happy.
    // Probably because they depend on the SetSelectionRange() call we make on
    // our frame in RestoreSelectionState, but I have no idea why they do.
    // FIXME(emilio): Unclear if this is still true.
    if (IsSelectionCached()) {
      GetSelectionProperties().SetIsDirty();
    }
    return true;
  }
  bool handleSettingValue = true;
  // If `SetValue()` call is nested, `GetSettingValue()` result will be
  // modified.  So, we need to store input event data value before
  // dispatching beforeinput event.
  nsString inputEventData(aHandlingSetValue.GetSettingValue());
  if (aHandlingSetValue.ValueSetterOptionsRef().contains(
          ValueSetterOption::BySetUserInputAPI) &&
      !aHandlingSetValue.HasBeforeInputEventDispatched()) {
    // This probably occurs when session restorer sets the old value with
    // `setUserInput`.  If so, we need to dispatch "beforeinput" event of
    // "insertReplacementText" for conforming to the spec.  However, the
    // spec does NOT treat the session restoring case.  Therefore, if this
    // breaks session restorere in a lot of web apps, we should probably
    // stop dispatching it or make it non-cancelable.
    MOZ_ASSERT(aHandlingSetValue.GetTextControlElement());
    MOZ_ASSERT(!aHandlingSetValue.GetSettingValue().IsVoid());
    aHandlingSetValue.WillDispatchBeforeInputEvent();
    nsEventStatus status = nsEventStatus_eIgnore;
    DebugOnly<nsresult> rvIgnored = nsContentUtils::DispatchInputEvent(
        MOZ_KnownLive(aHandlingSetValue.GetTextControlElement()),
        eEditorBeforeInput, EditorInputType::eInsertReplacementText, nullptr,
        InputEventOptions(
            inputEventData,
            StaticPrefs::dom_input_event_allow_to_cancel_set_user_input()
                ? InputEventOptions::NeverCancelable::No
                : InputEventOptions::NeverCancelable::Yes),
        &status);
    NS_WARNING_ASSERTION(NS_SUCCEEDED(rvIgnored),
                         "Failed to dispatch beforeinput event");
    if (status == nsEventStatus_eConsumeNoDefault) {
      return true;  // "beforeinput" event was canceled.
    }
    // If we were destroyed by "beforeinput" event listeners, probably, we
    // don't need to keep handling it.
    if (aHandlingSetValue.IsTextControlStateDestroyed()) {
      return true;
    }
    // Even if "beforeinput" event was not canceled, its listeners may do
    // something.  If it causes creating `TextEditor` and bind this to a
    // frame, we need to use the path, but `TextEditor` shouldn't fire
    // "beforeinput" event again.  Therefore, we need to prevent editor
    // to dispatch it.
    if (mEditorInitialized) {
      AutoInputEventSuppresser suppressInputEvent(mTextEditor);
      if (!SetValueWithTextEditor(aHandlingSetValue)) {
        return false;
      }
      // If we were destroyed by "beforeinput" event listeners, probably, we
      // don't need to keep handling it.
      if (aHandlingSetValue.IsTextControlStateDestroyed()) {
        return true;
      }
      handleSettingValue = false;
    }
  }

  if (handleSettingValue) {
    if (!mValue.Assign(aHandlingSetValue.GetSettingValue(), fallible)) {
      return false;
    }

    // Since we have no editor we presumably have cached selection state.
    if (IsSelectionCached()) {
      MOZ_ASSERT(AreFlagsNotDemandingContradictingMovements(
          aHandlingSetValue.ValueSetterOptionsRef()));

      SelectionProperties& props = GetSelectionProperties();
      // Setting a max length and thus capping selection range early prevents
      // selection change detection in setRangeText. Temporarily disable
      // capping here with UINT32_MAX, and set it later in ::SetRangeText().
      props.SetMaxLength(aHandlingSetValue.ValueSetterOptionsRef().contains(
                             ValueSetterOption::BySetRangeTextAPI)
                             ? UINT32_MAX
                             : aHandlingSetValue.GetSettingValue().Length());
      if (aHandlingSetValue.ValueSetterOptionsRef().contains(
              ValueSetterOption::MoveCursorToEndIfValueChanged)) {
        props.SetStart(aHandlingSetValue.GetSettingValue().Length());
        props.SetEnd(aHandlingSetValue.GetSettingValue().Length());
        props.SetDirection(SelectionDirection::Forward);
      } else if (aHandlingSetValue.ValueSetterOptionsRef().contains(
                     ValueSetterOption::
                         MoveCursorToBeginSetSelectionDirectionForward)) {
        props.SetStart(0);
        props.SetEnd(0);
        props.SetDirection(SelectionDirection::Forward);
      }
    }

    // Update the frame display if needed. No need to notify if we're
    // mid-destroying the editor from frame destruction.
    //
    // TODO(emilio): Eventually we should probably keep the editor around!
    const bool deinittingSelection =
        mHandlingState &&
        mHandlingState->IsHandling(TextControlAction::DeinitSelection);
    mTextCtrlElement->UpdateValueDisplay(!deinittingSelection);
  }

  // If this is called as part of user input, we need to dispatch "input"
  // event with "insertReplacementText" since web apps may want to know
  // the user operation which changes editor value with a built-in function
  // like autocomplete, password manager, session restore, etc.
  // XXX Should we stop dispatching `input` event if the text control
  //     element has already removed from the DOM tree by a `beforeinput`
  //     event listener?
  if (aHandlingSetValue.ValueSetterOptionsRef().contains(
          ValueSetterOption::BySetUserInputAPI)) {
    MOZ_ASSERT(aHandlingSetValue.GetTextControlElement());

    // Update validity state before dispatching "input" event for its
    // listeners like `EditorBase::NotifyEditorObservers()`.
    aHandlingSetValue.GetTextControlElement()->OnValueChanged(
        ValueChangeKind::UserInteraction, aHandlingSetValue.GetSettingValue());

    ClearLastInteractiveValue();

    MOZ_ASSERT(!aHandlingSetValue.GetSettingValue().IsVoid());
    DebugOnly<nsresult> rvIgnored = nsContentUtils::DispatchInputEvent(
        MOZ_KnownLive(aHandlingSetValue.GetTextControlElement()), eEditorInput,
        EditorInputType::eInsertReplacementText, nullptr,
        InputEventOptions(inputEventData,
                          InputEventOptions::NeverCancelable::No));
    NS_WARNING_ASSERTION(NS_SUCCEEDED(rvIgnored),
                         "Failed to dispatch input event");
  }

  return true;
}

bool TextControlState::EditorHasComposition() {
  return mTextEditor && mTextEditor->IsIMEComposing();
}

}  // namespace mozilla
