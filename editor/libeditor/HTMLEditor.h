/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_HTMLEditor_h
#define mozilla_HTMLEditor_h

#include "mozilla/Attributes.h"
#include "mozilla/ComposerCommandsUpdater.h"
#include "mozilla/CSSEditUtils.h"
#include "mozilla/EditorUtils.h"
#include "mozilla/ManualNAC.h"
#include "mozilla/Result.h"
#include "mozilla/TextEditor.h"
#include "mozilla/UniquePtr.h"
#include "mozilla/dom/Element.h"
#include "mozilla/dom/File.h"

#include "nsAttrName.h"
#include "nsCOMPtr.h"
#include "nsIDocumentObserver.h"
#include "nsIDOMEventListener.h"
#include "nsIEditorMailSupport.h"
#include "nsIHTMLAbsPosEditor.h"
#include "nsIHTMLEditor.h"
#include "nsIHTMLInlineTableEditor.h"
#include "nsIHTMLObjectResizer.h"
#include "nsITableEditor.h"
#include "nsPoint.h"
#include "nsStubMutationObserver.h"
#include "nsTArray.h"

class nsDocumentFragment;
class nsHTMLDocument;
class nsITransferable;
class nsIClipboard;
class nsRange;
class nsStaticAtom;
class nsTableWrapperFrame;

namespace mozilla {
class AlignStateAtSelection;
class AutoSelectionSetterAfterTableEdit;
class AutoSetTemporaryAncestorLimiter;
class EditActionResult;
class EditResult;
class EmptyEditableFunctor;
class JoinNodeTransaction;
class ListElementSelectionState;
class ListItemElementSelectionState;
class MoveNodeResult;
class ParagraphStateAtSelection;
class ResizerSelectionListener;
class Runnable;
class SplitNodeTransaction;
class SplitRangeOffFromNodeResult;
class SplitRangeOffResult;
class WSRunObject;
class WSRunScanner;
class WSScanResult;
enum class EditSubAction : int32_t;
struct PropItem;
template <class T>
class OwningNonNull;
namespace dom {
class AbstractRange;
class Blob;
class DocumentFragment;
class Event;
class MouseEvent;
class StaticRange;
}  // namespace dom
namespace widget {
struct IMEState;
}  // namespace widget

enum class ParagraphSeparator { div, p, br };

/**
 * The HTML editor implementation.<br>
 * Use to edit HTML document represented as a DOM tree.
 */
class HTMLEditor final : public TextEditor,
                         public nsIHTMLEditor,
                         public nsIHTMLObjectResizer,
                         public nsIHTMLAbsPosEditor,
                         public nsITableEditor,
                         public nsIHTMLInlineTableEditor,
                         public nsStubMutationObserver,
                         public nsIEditorMailSupport {
 public:
  /****************************************************************************
   * NOTE: DO NOT MAKE YOUR NEW METHODS PUBLIC IF they are called by other
   *       classes under libeditor except EditorEventListener and
   *       HTMLEditorEventListener because each public method which may fire
   *       eEditorInput event will need to instantiate new stack class for
   *       managing input type value of eEditorInput and cache some objects
   *       for smarter handling.  In other words, when you add new root
   *       method to edit the DOM tree, you can make your new method public.
   ****************************************************************************/

  NS_DECL_ISUPPORTS_INHERITED
  NS_DECL_CYCLE_COLLECTION_CLASS_INHERITED(HTMLEditor, TextEditor)

  // nsStubMutationObserver overrides
  NS_DECL_NSIMUTATIONOBSERVER_CONTENTAPPENDED
  NS_DECL_NSIMUTATIONOBSERVER_CONTENTINSERTED
  NS_DECL_NSIMUTATIONOBSERVER_CONTENTREMOVED

  // nsIHTMLEditor methods
  NS_DECL_NSIHTMLEDITOR

  // nsIHTMLObjectResizer methods (implemented in HTMLObjectResizer.cpp)
  NS_DECL_NSIHTMLOBJECTRESIZER

  // nsIHTMLAbsPosEditor methods (implemented in HTMLAbsPositionEditor.cpp)
  NS_DECL_NSIHTMLABSPOSEDITOR

  // nsIHTMLInlineTableEditor methods (implemented in HTMLInlineTableEditor.cpp)
  NS_DECL_NSIHTMLINLINETABLEEDITOR

  // nsIEditorMailSupport methods
  NS_DECL_NSIEDITORMAILSUPPORT

  // nsITableEditor methods
  NS_DECL_NSITABLEEDITOR

  // nsISelectionListener overrides
  NS_DECL_NSISELECTIONLISTENER

  HTMLEditor();

  nsHTMLDocument* GetHTMLDocument() const;

  MOZ_CAN_RUN_SCRIPT virtual void PreDestroy(bool aDestroyingFrames) override;

  bool GetReturnInParagraphCreatesNewParagraph();

  // TextEditor overrides
  MOZ_CAN_RUN_SCRIPT virtual nsresult Init(Document& aDoc, Element* aRoot,
                                           nsISelectionController* aSelCon,
                                           uint32_t aFlags,
                                           const nsAString& aValue) override;
  MOZ_CAN_RUN_SCRIPT_BOUNDARY NS_IMETHOD BeginningOfDocument() override;
  NS_IMETHOD SetFlags(uint32_t aFlags) override;

  /**
   * IsEmpty() checks whether the editor is empty.  If editor has only padding
   * <br> element for empty editor, returns true.  If editor's root element has
   * non-empty text nodes or other nodes like <br>, returns false even if there
   * are only empty blocks.
   */
  virtual bool IsEmpty() const override;

  virtual bool CanPaste(int32_t aClipboardType) const override;
  using EditorBase::CanPaste;

  MOZ_CAN_RUN_SCRIPT virtual nsresult PasteTransferableAsAction(
      nsITransferable* aTransferable,
      nsIPrincipal* aPrincipal = nullptr) override;

  MOZ_CAN_RUN_SCRIPT NS_IMETHOD DeleteNode(nsINode* aNode) override;

  MOZ_CAN_RUN_SCRIPT NS_IMETHOD InsertLineBreak() override;

  MOZ_CAN_RUN_SCRIPT virtual nsresult HandleKeyPressEvent(
      WidgetKeyboardEvent* aKeyboardEvent) override;
  virtual nsIContent* GetFocusedContent() const override;
  virtual nsIContent* GetFocusedContentForIME() const override;
  virtual bool IsActiveInDOMWindow() const override;
  virtual dom::EventTarget* GetDOMEventTarget() const override;
  virtual Element* FindSelectionRoot(nsINode* aNode) const override;
  virtual bool IsAcceptableInputEvent(WidgetGUIEvent* aGUIEvent) override;
  virtual nsresult GetPreferredIMEState(widget::IMEState* aState) override;

  /**
   * GetBackgroundColorState() returns what the background color of the
   * selection.
   *
   * @param aMixed      true if there is more than one font color
   * @param aOutColor   Color string. "" is returned for none.
   */
  MOZ_CAN_RUN_SCRIPT nsresult GetBackgroundColorState(bool* aMixed,
                                                      nsAString& aOutColor);

  /**
   * PasteNoFormatting() pastes content in clipboard without any style
   * information.
   *
   * @param aSelectionType      nsIClipboard::kGlobalClipboard or
   *                            nsIClipboard::kSelectionClipboard.
   * @param aPrincipal          Set subject principal if it may be called by
   *                            JS.  If set to nullptr, will be treated as
   *                            called by system.
   */
  MOZ_CAN_RUN_SCRIPT nsresult PasteNoFormattingAsAction(
      int32_t aSelectionType, nsIPrincipal* aPrincipal = nullptr);

  /**
   * PasteAsQuotationAsAction() pastes content in clipboard with newly created
   * blockquote element.  If the editor is in plaintext mode, will paste the
   * content with appending ">" to start of each line.
   *
   * @param aClipboardType      nsIClipboard::kGlobalClipboard or
   *                            nsIClipboard::kSelectionClipboard.
   * @param aDispatchPasteEvent true if this should dispatch ePaste event
   *                            before pasting.  Otherwise, false.
   * @param aPrincipal          Set subject principal if it may be called by
   *                            JS.  If set to nullptr, will be treated as
   *                            called by system.
   */
  MOZ_CAN_RUN_SCRIPT virtual nsresult PasteAsQuotationAsAction(
      int32_t aClipboardType, bool aDispatchPasteEvent,
      nsIPrincipal* aPrincipal = nullptr) override;

  /**
   * Can we paste |aTransferable| or, if |aTransferable| is null, will a call
   * to pasteTransferable later possibly succeed if given an instance of
   * nsITransferable then? True if the doc is modifiable, and, if
   * |aTransfeable| is non-null, we have pasteable data in |aTransfeable|.
   */
  virtual bool CanPasteTransferable(nsITransferable* aTransferable) override;

  /**
   * InsertLineBreakAsAction() is called when user inputs a line break with
   * Shift + Enter or something.
   *
   * @param aPrincipal          Set subject principal if it may be called by
   *                            JS.  If set to nullptr, will be treated as
   *                            called by system.
   */
  MOZ_CAN_RUN_SCRIPT virtual nsresult InsertLineBreakAsAction(
      nsIPrincipal* aPrincipal = nullptr) override;

  /**
   * InsertParagraphSeparatorAsAction() is called when user tries to separate
   * current paragraph with Enter key press in HTMLEditor or something.
   *
   * @param aPrincipal          Set subject principal if it may be called by
   *                            JS.  If set to nullptr, will be treated as
   *                            called by system.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  InsertParagraphSeparatorAsAction(nsIPrincipal* aPrincipal = nullptr);

  MOZ_CAN_RUN_SCRIPT nsresult
  InsertElementAtSelectionAsAction(Element* aElement, bool aDeleteSelection,
                                   nsIPrincipal* aPrincipal = nullptr);

  MOZ_CAN_RUN_SCRIPT nsresult InsertLinkAroundSelectionAsAction(
      Element* aAnchorElement, nsIPrincipal* aPrincipal = nullptr);

  /**
   * CreateElementWithDefaults() creates new element whose name is
   * aTagName with some default attributes are set.  Note that this is a
   * public utility method.  I.e., just creates element, not insert it
   * into the DOM tree.
   * NOTE: This is available for internal use too since this does not change
   *       the DOM tree nor undo transactions, and does not refer Selection,
   *       etc.
   *
   * @param aTagName            The new element's tag name.  If the name is
   *                            one of "href", "anchor" or "namedanchor",
   *                            this creates an <a> element.
   * @return                    Newly created element.
   */
  MOZ_CAN_RUN_SCRIPT already_AddRefed<Element> CreateElementWithDefaults(
      const nsAtom& aTagName);

  /**
   * Indent or outdent content around Selection.
   *
   * @param aPrincipal          Set subject principal if it may be called by
   *                            JS.  If set to nullptr, will be treated as
   *                            called by system.
   */
  MOZ_CAN_RUN_SCRIPT nsresult
  IndentAsAction(nsIPrincipal* aPrincipal = nullptr);
  MOZ_CAN_RUN_SCRIPT nsresult
  OutdentAsAction(nsIPrincipal* aPrincipal = nullptr);

  MOZ_CAN_RUN_SCRIPT nsresult SetParagraphFormatAsAction(
      const nsAString& aParagraphFormat, nsIPrincipal* aPrincipal = nullptr);

  MOZ_CAN_RUN_SCRIPT nsresult AlignAsAction(const nsAString& aAlignType,
                                            nsIPrincipal* aPrincipal = nullptr);

  MOZ_CAN_RUN_SCRIPT nsresult RemoveListAsAction(
      const nsAString& aListType, nsIPrincipal* aPrincipal = nullptr);

  /**
   * MakeOrChangeListAsAction() makes selected hard lines list element(s).
   *
   * @param aListElementTagName         The new list element tag name.  Must be
   *                                    nsGkAtoms::ul, nsGkAtoms::ol or
   *                                    nsGkAtoms::dl.
   * @param aBulletType                 If this is not empty string, it's set
   *                                    to `type` attribute of new list item
   *                                    elements.  Otherwise, existing `type`
   *                                    attributes will be removed.
   * @param aSelectAllOfCurrentList     Yes if this should treat all of
   *                                    ancestor list element at selection.
   */
  enum class SelectAllOfCurrentList { Yes, No };
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult MakeOrChangeListAsAction(
      nsAtom& aListElementTagName, const nsAString& aBulletType,
      SelectAllOfCurrentList aSelectAllOfCurrentList,
      nsIPrincipal* aPrincipal = nullptr);

  /**
   * event callback when a mouse button is pressed
   * @param aX      [IN] horizontal position of the pointer
   * @param aY      [IN] vertical position of the pointer
   * @param aTarget [IN] the element triggering the event
   * @param aMouseEvent [IN] the event
   */
  MOZ_CAN_RUN_SCRIPT nsresult OnMouseDown(int32_t aX, int32_t aY,
                                          Element* aTarget,
                                          dom::Event* aMouseEvent);

  /**
   * event callback when a mouse button is released
   * @param aX      [IN] horizontal position of the pointer
   * @param aY      [IN] vertical position of the pointer
   */
  MOZ_CAN_RUN_SCRIPT nsresult OnMouseUp(int32_t aX, int32_t aY);

  /**
   * event callback when the mouse pointer is moved
   * @param aMouseEvent [IN] the event
   */
  MOZ_CAN_RUN_SCRIPT nsresult OnMouseMove(dom::MouseEvent* aMouseEvent);

  /**
   * IsCSSEnabled() returns true if this editor treats styles with style
   * attribute of HTML elements.  Otherwise, if this editor treats all styles
   * with "font style elements" like <b>, <i>, etc, and <blockquote> to indent,
   * align attribute to align contents, returns false.
   */
  bool IsCSSEnabled() const {
    // TODO: removal of mCSSAware and use only the presence of mCSSEditUtils
    return mCSSAware && mCSSEditUtils && mCSSEditUtils->IsCSSPrefChecked();
  }

  /**
   * Enable/disable object resizers for <img> elements, <table> elements,
   * absolute positioned elements (required absolute position editor enabled).
   */
  MOZ_CAN_RUN_SCRIPT void EnableObjectResizer(bool aEnable) {
    if (mIsObjectResizingEnabled == aEnable) {
      return;
    }

    AutoEditActionDataSetter editActionData(
        *this, EditAction::eEnableOrDisableResizer);
    if (NS_WARN_IF(!editActionData.CanHandle())) {
      return;
    }

    mIsObjectResizingEnabled = aEnable;
    RefreshEditingUI();
  }
  bool IsObjectResizerEnabled() const { return mIsObjectResizingEnabled; }

  Element* GetResizerTarget() const { return mResizedObject; }

  /**
   * Enable/disable inline table editor, e.g., adding new row or column,
   * removing existing row or column.
   */
  MOZ_CAN_RUN_SCRIPT void EnableInlineTableEditor(bool aEnable) {
    if (mIsInlineTableEditingEnabled == aEnable) {
      return;
    }

    AutoEditActionDataSetter editActionData(
        *this, EditAction::eEnableOrDisableInlineTableEditingUI);
    if (NS_WARN_IF(!editActionData.CanHandle())) {
      return;
    }

    mIsInlineTableEditingEnabled = aEnable;
    RefreshEditingUI();
  }
  bool IsInlineTableEditorEnabled() const {
    return mIsInlineTableEditingEnabled;
  }

  /**
   * Enable/disable absolute position editor, resizing absolute positioned
   * elements (required object resizers enabled) or positioning them with
   * dragging grabber.
   */
  MOZ_CAN_RUN_SCRIPT void EnableAbsolutePositionEditor(bool aEnable) {
    if (mIsAbsolutelyPositioningEnabled == aEnable) {
      return;
    }

    AutoEditActionDataSetter editActionData(
        *this, EditAction::eEnableOrDisableAbsolutePositionEditor);
    if (NS_WARN_IF(!editActionData.CanHandle())) {
      return;
    }

    mIsAbsolutelyPositioningEnabled = aEnable;
    RefreshEditingUI();
  }
  bool IsAbsolutePositionEditorEnabled() const {
    return mIsAbsolutelyPositioningEnabled;
  }

  // non-virtual methods of interface methods

  /**
   * returns the deepest absolutely positioned container of the selection
   * if it exists or null.
   */
  MOZ_CAN_RUN_SCRIPT already_AddRefed<Element>
  GetAbsolutelyPositionedSelectionContainer() const;

  Element* GetPositionedElement() const { return mAbsolutelyPositionedObject; }

  /**
   * extracts the selection from the normal flow of the document and
   * positions it.
   *
   * @param aEnabled [IN] true to absolutely position the selection,
   *                      false to put it back in the normal flow
   * @param aPrincipal          Set subject principal if it may be called by
   *                            JS.  If set to nullptr, will be treated as
   *                            called by system.
   */
  MOZ_CAN_RUN_SCRIPT nsresult SetSelectionToAbsoluteOrStaticAsAction(
      bool aEnabled, nsIPrincipal* aPrincipal = nullptr);

  /**
   * returns the absolute z-index of a positioned element. Never returns 'auto'
   * @return         the z-index of the element
   * @param aElement [IN] the element.
   */
  MOZ_CAN_RUN_SCRIPT int32_t GetZIndex(Element& aElement);

  /**
   * adds aChange to the z-index of the currently positioned element.
   *
   * @param aChange [IN] relative change to apply to current z-index
   * @param aPrincipal          Set subject principal if it may be called by
   *                            JS.  If set to nullptr, will be treated as
   *                            called by system.
   */
  MOZ_CAN_RUN_SCRIPT nsresult
  AddZIndexAsAction(int32_t aChange, nsIPrincipal* aPrincipal = nullptr);

  MOZ_CAN_RUN_SCRIPT nsresult SetBackgroundColorAsAction(
      const nsAString& aColor, nsIPrincipal* aPrincipal = nullptr);

  /**
   * SetInlinePropertyAsAction() sets a property which changes inline style of
   * text.  E.g., bold, italic, super and sub.
   * This automatically removes exclusive style, however, treats all changes
   * as a transaction.
   *
   * @param aPrincipal          Set subject principal if it may be called by
   *                            JS.  If set to nullptr, will be treated as
   *                            called by system.
   */
  MOZ_CAN_RUN_SCRIPT nsresult SetInlinePropertyAsAction(
      nsAtom& aProperty, nsAtom* aAttribute, const nsAString& aValue,
      nsIPrincipal* aPrincipal = nullptr);

  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult GetInlineProperty(
      nsAtom* aHTMLProperty, nsAtom* aAttribute, const nsAString& aValue,
      bool* aFirst, bool* aAny, bool* aAll) const;
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult GetInlinePropertyWithAttrValue(
      nsAtom* aHTMLProperty, nsAtom* aAttribute, const nsAString& aValue,
      bool* aFirst, bool* aAny, bool* aAll, nsAString& outValue);

  /**
   * RemoveInlinePropertyAsAction() removes a property which changes inline
   * style of text.  E.g., bold, italic, super and sub.
   *
   * @param aHTMLProperty   Tag name whcih represents the inline style you want
   *                        to remove.  E.g., nsGkAtoms::strong, nsGkAtoms::b,
   *                        etc.  If nsGkAtoms::href, <a> element which has
   *                        href attribute will be removed.
   *                        If nsGkAtoms::name, <a> element which has non-empty
   *                        name attribute will be removed.
   * @param aAttribute  If aHTMLProperty is nsGkAtoms::font, aAttribute should
   *                    be nsGkAtoms::fase, nsGkAtoms::size, nsGkAtoms::color
   *                    or nsGkAtoms::bgcolor.  Otherwise, set nullptr.
   *                    Must not use nsGkAtoms::_empty here.
   * @param aPrincipal  Set subject principal if it may be called by JS.  If
   *                    set to nullptr, will be treated as called by system.
   */
  MOZ_CAN_RUN_SCRIPT nsresult RemoveInlinePropertyAsAction(
      nsStaticAtom& aHTMLProperty, nsStaticAtom* aAttribute,
      nsIPrincipal* aPrincipal = nullptr);

  MOZ_CAN_RUN_SCRIPT nsresult
  RemoveAllInlinePropertiesAsAction(nsIPrincipal* aPrincipal = nullptr);

  MOZ_CAN_RUN_SCRIPT nsresult
  IncreaseFontSizeAsAction(nsIPrincipal* aPrincipal = nullptr);

  MOZ_CAN_RUN_SCRIPT nsresult
  DecreaseFontSizeAsAction(nsIPrincipal* aPrincipal = nullptr);

  /**
   * GetFontColorState() returns foreground color information in first
   * range of Selection.
   * If first range of Selection is collapsed and there is a cache of style for
   * new text, aIsMixed is set to false and aColor is set to the cached color.
   * If first range of Selection is collapsed and there is no cached color,
   * this returns the color of the node, aIsMixed is set to false and aColor is
   * set to the color.
   * If first range of Selection is not collapsed, this collects colors of
   * each node in the range.  If there are two or more colors, aIsMixed is set
   * to true and aColor is truncated.  If only one color is set to all of the
   * range, aIsMixed is set to false and aColor is set to the color.
   * If there is no Selection ranges, aIsMixed is set to false and aColor is
   * truncated.
   *
   * @param aIsMixed            Must not be nullptr.  This is set to true
   *                            if there is two or more colors in first
   *                            range of Selection.
   * @param aColor              Returns the color if only one color is set to
   *                            all of first range in Selection.  Otherwise,
   *                            returns empty string.
   * @return                    Returns error only when illegal cases, e.g.,
   *                            Selection instance has gone, first range
   *                            Selection is broken.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  GetFontColorState(bool* aIsMixed, nsAString& aColor);

  /**
   * SetComposerCommandsUpdater() sets or unsets mComposerCommandsUpdater.
   * This will crash in debug build if the editor already has an instance
   * but called with another instance.
   */
  void SetComposerCommandsUpdater(
      ComposerCommandsUpdater* aComposerCommandsUpdater) {
    MOZ_ASSERT(!aComposerCommandsUpdater || !mComposerCommandsUpdater ||
               aComposerCommandsUpdater == mComposerCommandsUpdater);
    mComposerCommandsUpdater = aComposerCommandsUpdater;
  }

  nsStaticAtom& DefaultParagraphSeparatorTagName() const {
    return HTMLEditor::ToParagraphSeparatorTagName(mDefaultParagraphSeparator);
  }
  ParagraphSeparator GetDefaultParagraphSeparator() const {
    return mDefaultParagraphSeparator;
  }
  void SetDefaultParagraphSeparator(ParagraphSeparator aSep) {
    mDefaultParagraphSeparator = aSep;
  }
  static nsStaticAtom& ToParagraphSeparatorTagName(
      ParagraphSeparator aSeparator) {
    switch (aSeparator) {
      case ParagraphSeparator::div:
        return *nsGkAtoms::div;
      case ParagraphSeparator::p:
        return *nsGkAtoms::p;
      case ParagraphSeparator::br:
        return *nsGkAtoms::br;
      default:
        MOZ_ASSERT_UNREACHABLE("New paragraph separator isn't handled here");
        return *nsGkAtoms::div;
    }
  }

  /**
   * Modifies the table containing the selection according to the
   * activation of an inline table editing UI element
   * @param aUIAnonymousElement [IN] the inline table editing UI element
   */
  MOZ_CAN_RUN_SCRIPT nsresult
  DoInlineTableEditingAction(const Element& aUIAnonymousElement);

  /**
   * GetInclusiveAncestorByTagName() looks for an element node whose name
   * matches aTagName from aNode or anchor node of Selection to <body> element.
   *
   * @param aTagName        The tag name which you want to look for.
   *                        Must not be nsGkAtoms::_empty.
   *                        If nsGkAtoms::list, the result may be <ul>, <ol> or
   *                        <dl> element.
   *                        If nsGkAtoms::td, the result may be <td> or <th>.
   *                        If nsGkAtoms::href, the result may be <a> element
   *                        which has "href" attribute with non-empty value.
   *                        If nsGkAtoms::anchor, the result may be <a> which
   *                        has "name" attribute with non-empty value.
   * @param aContent        Start node to look for the result.
   * @return                If an element which matches aTagName, returns
   *                        an Element.  Otherwise, nullptr.
   */
  Element* GetInclusiveAncestorByTagName(const nsStaticAtom& aTagName,
                                         nsIContent& aContent) const;

  /**
   * Get an active editor's editing host in DOM window.  If this editor isn't
   * active in the DOM window, this returns NULL.
   */
  Element* GetActiveEditingHost() const;

  /**
   * Retruns true if we're in designMode.
   */
  bool IsInDesignMode() const {
    Document* document = GetDocument();
    return document && document->HasFlag(NODE_IS_EDITABLE);
  }

  /**
   * NotifyEditingHostMaybeChanged() is called when new element becomes
   * contenteditable when the document already had contenteditable elements.
   */
  void NotifyEditingHostMaybeChanged();

  /** Insert a string as quoted text
   * (whose representation is dependant on the editor type),
   * replacing the selected text (if any).
   *
   * @param aQuotedText    The actual text to be quoted
   * @parem aNodeInserted  Return the node which was inserted.
   */
  MOZ_CAN_RUN_SCRIPT  // USED_BY_COMM_CENTRAL
      nsresult
      InsertAsQuotation(const nsAString& aQuotedText, nsINode** aNodeInserted);

  /**
   * Inserts a plaintext string at the current location,
   * with special processing for lines beginning with ">",
   * which will be treated as mail quotes and inserted
   * as plaintext quoted blocks.
   * If the selection is not collapsed, the selection is deleted
   * and the insertion takes place at the resulting collapsed selection.
   *
   * @param aString   the string to be inserted
   */
  MOZ_CAN_RUN_SCRIPT nsresult
  InsertTextWithQuotations(const nsAString& aStringToInsert);

  MOZ_CAN_RUN_SCRIPT nsresult InsertHTMLAsAction(
      const nsAString& aInString, nsIPrincipal* aPrincipal = nullptr);

 protected:  // May be called by friends.
  /****************************************************************************
   * Some friend classes are allowed to call the following protected methods.
   * However, those methods won't prepare caches of some objects which are
   * necessary for them.  So, if you call them from friend classes, you need
   * to make sure that AutoEditActionDataSetter is created.
   ****************************************************************************/

  /**
   * InsertBRElementWithTransaction() creates a <br> element and inserts it
   * before aPointToInsert.  Then, tries to collapse selection at or after the
   * new <br> node if aSelect is not eNone.
   *
   * @param aPointToInsert      The DOM point where should be <br> node inserted
   *                            before.
   * @param aSelect             If eNone, this won't change selection.
   *                            If eNext, selection will be collapsed after
   *                            the <br> element.
   *                            If ePrevious, selection will be collapsed at
   *                            the <br> element.
   * @return                    The new <br> node.  If failed to create new
   *                            <br> node, returns nullptr.
   */
  MOZ_CAN_RUN_SCRIPT already_AddRefed<Element> InsertBRElementWithTransaction(
      const EditorDOMPoint& aPointToInsert, EDirection aSelect = eNone);

  /**
   * DeleteNodeWithTransaction() removes aContent from the DOM tree if it's
   * modifiable.  Note that this is not an override of same method of
   * EditorBase.
   *
   * @param aContent    The node to be removed from the DOM tree.
   */
  MOZ_CAN_RUN_SCRIPT nsresult DeleteNodeWithTransaction(nsIContent& aContent);

  /**
   * DeleteTextWithTransaction() removes text in the range from aTextNode if
   * it's modifiable.  Note that this not an override of same method of
   * EditorBase.
   *
   * @param aTextNode           The text node which should be modified.
   * @param aOffset             Start offset of removing text in aTextNode.
   * @param aLength             Length of removing text.
   */
  MOZ_CAN_RUN_SCRIPT nsresult DeleteTextWithTransaction(dom::Text& aTextNode,
                                                        uint32_t aOffset,
                                                        uint32_t aLength);

  /**
   * ReplaceTextWithTransaction() replaces text in the range with
   * aStringToInsert.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult ReplaceTextWithTransaction(
      dom::Text& aTextNode, uint32_t aOffset, uint32_t aLength,
      const nsAString& aStringToInsert);

  /**
   * DeleteParentBlocksIfEmpty() removes parent block elements if they
   * don't have visible contents.  Note that due performance issue of
   * WSRunObject, this call may be expensive.  And also note that this
   * removes a empty block with a transaction.  So, please make sure that
   * you've already created `AutoPlaceholderBatch`.
   *
   * @param aPoint      The point whether this method climbing up the DOM
   *                    tree to remove empty parent blocks.
   * @return            NS_OK if one or more empty block parents are deleted.
   *                    NS_SUCCESS_EDITOR_ELEMENT_NOT_FOUND if the point is
   *                    not in empty block.
   *                    Or NS_ERROR_* if something unexpected occurs.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  DeleteParentBlocksWithTransactionIfEmpty(const EditorDOMPoint& aPoint);

  /**
   * InsertTextWithTransaction() inserts aStringToInsert at aPointToInsert.
   */
  MOZ_CAN_RUN_SCRIPT virtual nsresult InsertTextWithTransaction(
      Document& aDocument, const nsAString& aStringToInsert,
      const EditorRawDOMPoint& aPointToInsert,
      EditorRawDOMPoint* aPointAfterInsertedString = nullptr) override;

  /**
   * CopyLastEditableChildStyles() clones inline container elements into
   * aPreviousBlock to aNewBlock to keep using same style in it.
   *
   * @param aPreviousBlock      The previous block element.  All inline
   *                            elements which are last sibling of each level
   *                            are cloned to aNewBlock.
   * @param aNewBlock           New block container element.
   * @param aNewBRElement       If this method creates a new <br> element for
   *                            placeholder, this is set to the new <br>
   *                            element.
   */
  MOZ_CAN_RUN_SCRIPT nsresult CopyLastEditableChildStylesWithTransaction(
      Element& aPreviousBlock, Element& aNewBlock,
      RefPtr<Element>* aNewBRElement);

  /**
   * RemoveBlockContainerWithTransaction() removes aElement from the DOM tree
   * but moves its all children to its parent node and if its parent needs <br>
   * element to have at least one line-height, this inserts <br> element
   * automatically.
   *
   * @param aElement            Block element to be removed.
   */
  MOZ_CAN_RUN_SCRIPT nsresult
  RemoveBlockContainerWithTransaction(Element& aElement);

  virtual Element* GetEditorRoot() const override;
  MOZ_CAN_RUN_SCRIPT virtual nsresult RemoveAttributeOrEquivalent(
      Element* aElement, nsAtom* aAttribute,
      bool aSuppressTransaction) override;
  MOZ_CAN_RUN_SCRIPT virtual nsresult SetAttributeOrEquivalent(
      Element* aElement, nsAtom* aAttribute, const nsAString& aValue,
      bool aSuppressTransaction) override;
  using EditorBase::RemoveAttributeOrEquivalent;
  using EditorBase::SetAttributeOrEquivalent;

  /**
   * Returns container element of ranges in Selection.  If Selection is
   * collapsed, returns focus container node (or its parent element).
   * If Selection selects only one element node, returns the element node.
   * If Selection is only one range, returns common ancestor of the range.
   * XXX If there are two or more Selection ranges, this returns parent node
   *     of start container of a range which starts with different node from
   *     start container of the first range.
   */
  Element* GetSelectionContainerElement() const;

  /**
   * GetFirstSelectedTableCellElement() returns a <td> or <th> element if
   * first range of Selection (i.e., result of Selection::GetRangeAt(0))
   * selects a <td> element or <th> element.  Even if Selection is in
   * a cell element, this returns nullptr.  And even if 2nd or later
   * range of Selection selects a cell element, also returns nullptr.
   * Note that when this looks for a cell element, this resets the internal
   * index of ranges of Selection.  When you call
   * GetNextSelectedTableCellElement() after a call of this, it'll return 2nd
   * selected cell if there is.
   *
   * @param aRv                 Returns error if there is no selection or
   *                            first range of Selection is unexpected.
   * @return                    A <td> or <th> element is selected by first
   *                            range of Selection.  Note that the range must
   *                            be: startContaienr and endContainer are same
   *                            <tr> element, startOffset + 1 equals endOffset.
   */
  already_AddRefed<Element> GetFirstSelectedTableCellElement(
      ErrorResult& aRv) const;

  /**
   * GetNextSelectedTableCellElement() is a stateful method to retrieve
   * selected table cell elements which are selected by 2nd or later ranges
   * of Selection.  When you call GetFirstSelectedTableCellElement(), it
   * resets internal counter of this method.  Then, following calls of
   * GetNextSelectedTableCellElement() scans the remaining ranges of Selection.
   * If a range selects a <td> or <th> element, returns the cell element.
   * If a range selects an element but neither <td> nor <th> element, this
   * ignores the range.  If a range is in a text node, returns null without
   * throwing exception, but stops scanning the remaining ranges even you
   * call this again.
   * Note that this may cross <table> boundaries since this method just
   * scans all ranges of Selection.  Therefore, returning cells which
   * belong to different <table> elements.
   *
   * @param aRv                 Returns error if Selection doesn't have
   *                            range properly.
   * @return                    A <td> or <th> element if one of remaining
   *                            ranges selects a <td> or <th> element unless
   *                            this does not meet a range in a text node.
   */
  already_AddRefed<Element> GetNextSelectedTableCellElement(
      ErrorResult& aRv) const;

  /**
   * DeleteTableCellContentsWithTransaction() removes any contents in cell
   * elements.  If two or more cell elements are selected, this removes
   * all selected cells' contents.  Otherwise, this removes contents of
   * a cell which contains first selection range.  This does not return
   * error even if selection is not in cell element, just does nothing.
   */
  MOZ_CAN_RUN_SCRIPT nsresult DeleteTableCellContentsWithTransaction();

  static void IsNextCharInNodeWhitespace(nsIContent* aContent, int32_t aOffset,
                                         bool* outIsSpace, bool* outIsNBSP,
                                         nsIContent** outNode = nullptr,
                                         int32_t* outOffset = 0);
  static void IsPrevCharInNodeWhitespace(nsIContent* aContent, int32_t aOffset,
                                         bool* outIsSpace, bool* outIsNBSP,
                                         nsIContent** outNode = nullptr,
                                         int32_t* outOffset = 0);

  /**
   * extracts an element from the normal flow of the document and
   * positions it, and puts it back in the normal flow.
   * @param aElement [IN] the element
   * @param aEnabled [IN] true to absolutely position the element,
   *                      false to put it back in the normal flow
   */
  MOZ_CAN_RUN_SCRIPT nsresult SetPositionToAbsoluteOrStatic(Element& aElement,
                                                            bool aEnabled);

  /**
   * adds aChange to the z-index of an arbitrary element.
   * @param aElement [IN] the element
   * @param aChange  [IN] relative change to apply to current z-index of
   *                      the element
   * @param aReturn  [OUT] the new z-index of the element
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult RelativeChangeElementZIndex(
      Element& aElement, int32_t aChange, int32_t* aReturn);

  /**
   * Join together any adjacent editable text nodes in the range.
   */
  MOZ_CAN_RUN_SCRIPT nsresult CollapseAdjacentTextNodes(nsRange& aRange);

  /**
   * IsInVisibleTextFrames() returns true if all text in aText is in visible
   * text frames.  Callers have to guarantee that there is no pending reflow.
   */
  bool IsInVisibleTextFrames(dom::Text& aText) const;

  /**
   * IsVisibleTextNode() returns true if aText has visible text.  If it has
   * only whitespaces and they are collapsed, returns false.
   */
  bool IsVisibleTextNode(Text& aText) const;

  /**
   * IsEmptyNode() figures out if aNode is an empty node.  A block can have
   * children and still be considered empty, if the children are empty or
   * non-editable.
   */
  bool IsEmptyNode(nsINode& aNode, bool aSingleBRDoesntCount = false,
                   bool aListOrCellNotEmpty = false,
                   bool aSafeToAskFrames = false) const {
    bool seenBR = false;
    return IsEmptyNodeImpl(aNode, aSingleBRDoesntCount, aListOrCellNotEmpty,
                           aSafeToAskFrames, &seenBR);
  }

  bool IsEmptyNodeImpl(nsINode& aNode, bool aSingleBRDoesntCount,
                       bool aListOrCellNotEmpty, bool aSafeToAskFrames,
                       bool* aSeenBR) const;

  static bool HasAttributes(Element* aElement) {
    MOZ_ASSERT(aElement);
    uint32_t attrCount = aElement->GetAttrCount();
    return attrCount > 1 ||
           (1 == attrCount &&
            !aElement->GetAttrNameAt(0)->Equals(nsGkAtoms::mozdirty));
  }

  /**
   * Content-based query returns true if <aProperty aAttribute=aValue> effects
   * aNode.  If <aProperty aAttribute=aValue> contains aNode, but
   * <aProperty aAttribute=SomeOtherValue> also contains aNode and the second is
   * more deeply nested than the first, then the first does not effect aNode.
   *
   * @param aNode      The target of the query
   * @param aProperty  The property that we are querying for
   * @param aAttribute The attribute of aProperty, example: color in
   *                   <FONT color="blue"> May be null.
   * @param aValue     The value of aAttribute, example: blue in
   *                   <FONT color="blue"> May be null.  Ignored if aAttribute
   *                   is null.
   * @param outValue   [OUT] the value of the attribute, if aIsSet is true
   * @return           true if <aProperty aAttribute=aValue> effects
   *                   aNode.
   *
   * The nsIContent variant returns aIsSet instead of using an out parameter.
   */
  static bool IsTextPropertySetByContent(nsINode* aNode, nsAtom* aProperty,
                                         nsAtom* aAttribute,
                                         const nsAString* aValue,
                                         nsAString* outValue = nullptr);

  static dom::Element* GetLinkElement(nsINode* aNode);

  /**
   * Small utility routine to test if a break node is visible to user.
   */
  bool IsVisibleBRElement(const nsINode* aNode);

  /**
   * Helper routines for font size changing.
   */
  enum class FontSize { incr, decr };
  MOZ_CAN_RUN_SCRIPT nsresult RelativeFontChangeOnTextNode(FontSize aDir,
                                                           Text& aTextNode,
                                                           int32_t aStartOffset,
                                                           int32_t aEndOffset);

  MOZ_CAN_RUN_SCRIPT nsresult SetInlinePropertyOnNode(nsIContent& aNode,
                                                      nsAtom& aProperty,
                                                      nsAtom* aAttribute,
                                                      const nsAString& aValue);

  /**
   * SplitAncestorStyledInlineElementsAtRangeEdges() splits all ancestor inline
   * elements in the block at both aStartPoint and aEndPoint if given style
   * matches with some of them.
   *
   * @param aStartPoint Start of range to split ancestor inline elements.
   * @param aEndPoint   End of range to split ancestor inline elements.
   * @param aProperty   The style tag name which you want to split.  Set
   *                    nullptr if you want to split any styled elements.
   * @param aAttribute  Attribute name if aProperty has some styles like
   *                    nsGkAtoms::font.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT SplitRangeOffResult
  SplitAncestorStyledInlineElementsAtRangeEdges(
      const EditorDOMPoint& aStartPoint, const EditorDOMPoint& aEndPoint,
      nsAtom* aProperty, nsAtom* aAttribute);

  /**
   * SplitAncestorStyledInlineElementsAt() splits ancestor inline elements at
   * aPointToSplit if specified style matches with them.
   *
   * @param aPointToSplit       The point to split style at.
   * @param aProperty           The style tag name which you want to split.
   *                            Set nullptr if you want to split any styled
   *                            elements.
   * @param aAttribute          Attribute name if aProperty has some styles
   *                            like nsGkAtoms::font.
   * @return                    The result of SplitNodeDeepWithTransaction()
   *                            with topmost split element.  If this didn't
   *                            find inline elements to be split, Handled()
   *                            returns false.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT SplitNodeResult
  SplitAncestorStyledInlineElementsAt(const EditorDOMPoint& aPointToSplit,
                                      nsAtom* aProperty, nsAtom* aAttribute);

  /**
   * GetPriorHTMLSibling() returns the previous editable sibling, if there is
   * one within the parent, optionally skipping text nodes that are only
   * whitespace.
   */
  enum class SkipWhitespace { Yes, No };
  nsIContent* GetPriorHTMLSibling(nsINode* aNode,
                                  SkipWhitespace = SkipWhitespace::No) const;

  /**
   * GetNextHTMLSibling() returns the next editable sibling, if there is
   * one within the parent, optionally skipping text nodes that are only
   * whitespace.
   */
  nsIContent* GetNextHTMLSibling(nsINode* aNode,
                                 SkipWhitespace = SkipWhitespace::No) const;

  // Helper for GetPriorHTMLSibling/GetNextHTMLSibling.
  static bool SkippableWhitespace(nsINode* aNode, SkipWhitespace aSkipWS) {
    return aSkipWS == SkipWhitespace::Yes && aNode->IsText() &&
           aNode->AsText()->TextIsOnlyWhitespace();
  }

  /**
   * GetPreviousHTMLElementOrText*() methods are similar to
   * EditorBase::GetPreviousElementOrText*() but this won't return nodes
   * outside active editing host.
   */
  nsIContent* GetPreviousHTMLElementOrText(const nsINode& aNode) const {
    return GetPreviousHTMLElementOrTextInternal(aNode, false);
  }
  nsIContent* GetPreviousHTMLElementOrTextInBlock(const nsINode& aNode) const {
    return GetPreviousHTMLElementOrTextInternal(aNode, true);
  }
  template <typename PT, typename CT>
  nsIContent* GetPreviousHTMLElementOrText(
      const EditorDOMPointBase<PT, CT>& aPoint) const {
    return GetPreviousHTMLElementOrTextInternal(aPoint, false);
  }
  template <typename PT, typename CT>
  nsIContent* GetPreviousHTMLElementOrTextInBlock(
      const EditorDOMPointBase<PT, CT>& aPoint) const {
    return GetPreviousHTMLElementOrTextInternal(aPoint, true);
  }

  /**
   * GetPreviousHTMLElementOrTextInternal() methods are common implementation
   * of above methods.  Please don't use this method directly.
   */
  nsIContent* GetPreviousHTMLElementOrTextInternal(const nsINode& aNode,
                                                   bool aNoBlockCrossing) const;
  template <typename PT, typename CT>
  nsIContent* GetPreviousHTMLElementOrTextInternal(
      const EditorDOMPointBase<PT, CT>& aPoint, bool aNoBlockCrossing) const;

  /**
   * GetPreviousEditableHTMLNode*() methods are similar to
   * EditorBase::GetPreviousEditableNode() but this won't return nodes outside
   * active editing host.
   */
  nsIContent* GetPreviousEditableHTMLNode(nsINode& aNode) const {
    return GetPreviousEditableHTMLNodeInternal(aNode, false);
  }
  nsIContent* GetPreviousEditableHTMLNodeInBlock(nsINode& aNode) const {
    return GetPreviousEditableHTMLNodeInternal(aNode, true);
  }
  template <typename PT, typename CT>
  nsIContent* GetPreviousEditableHTMLNode(
      const EditorDOMPointBase<PT, CT>& aPoint) const {
    return GetPreviousEditableHTMLNodeInternal(aPoint, false);
  }
  template <typename PT, typename CT>
  nsIContent* GetPreviousEditableHTMLNodeInBlock(
      const EditorDOMPointBase<PT, CT>& aPoint) const {
    return GetPreviousEditableHTMLNodeInternal(aPoint, true);
  }

  /**
   * GetPreviousEditableHTMLNodeInternal() methods are common implementation
   * of above methods.  Please don't use this method directly.
   */
  nsIContent* GetPreviousEditableHTMLNodeInternal(nsINode& aNode,
                                                  bool aNoBlockCrossing) const;
  template <typename PT, typename CT>
  nsIContent* GetPreviousEditableHTMLNodeInternal(
      const EditorDOMPointBase<PT, CT>& aPoint, bool aNoBlockCrossing) const;

  /**
   * GetNextHTMLElementOrText*() methods are similar to
   * EditorBase::GetNextElementOrText*() but this won't return nodes outside
   * active editing host.
   *
   * Note that same as EditorBase::GetTextEditableNode(), methods which take
   * |const EditorRawDOMPoint&| start to search from the node pointed by it.
   * On the other hand, methods which take |nsINode&| start to search from
   * next node of aNode.
   */
  nsIContent* GetNextHTMLElementOrText(const nsINode& aNode) const {
    return GetNextHTMLElementOrTextInternal(aNode, false);
  }
  nsIContent* GetNextHTMLElementOrTextInBlock(const nsINode& aNode) const {
    return GetNextHTMLElementOrTextInternal(aNode, true);
  }
  template <typename PT, typename CT>
  nsIContent* GetNextHTMLElementOrText(
      const EditorDOMPointBase<PT, CT>& aPoint) const {
    return GetNextHTMLElementOrTextInternal(aPoint, false);
  }
  template <typename PT, typename CT>
  nsIContent* GetNextHTMLElementOrTextInBlock(
      const EditorDOMPointBase<PT, CT>& aPoint) const {
    return GetNextHTMLElementOrTextInternal(aPoint, true);
  }

  /**
   * GetNextHTMLNodeInternal() methods are common implementation
   * of above methods.  Please don't use this method directly.
   */
  nsIContent* GetNextHTMLElementOrTextInternal(const nsINode& aNode,
                                               bool aNoBlockCrossing) const;
  template <typename PT, typename CT>
  nsIContent* GetNextHTMLElementOrTextInternal(
      const EditorDOMPointBase<PT, CT>& aPoint, bool aNoBlockCrossing) const;

  /**
   * GetNextEditableHTMLNode*() methods are similar to
   * EditorBase::GetNextEditableNode() but this won't return nodes outside
   * active editing host.
   *
   * Note that same as EditorBase::GetTextEditableNode(), methods which take
   * |const EditorRawDOMPoint&| start to search from the node pointed by it.
   * On the other hand, methods which take |nsINode&| start to search from
   * next node of aNode.
   */
  nsIContent* GetNextEditableHTMLNode(nsINode& aNode) const {
    return GetNextEditableHTMLNodeInternal(aNode, false);
  }
  nsIContent* GetNextEditableHTMLNodeInBlock(nsINode& aNode) const {
    return GetNextEditableHTMLNodeInternal(aNode, true);
  }
  template <typename PT, typename CT>
  nsIContent* GetNextEditableHTMLNode(
      const EditorDOMPointBase<PT, CT>& aPoint) const {
    return GetNextEditableHTMLNodeInternal(aPoint, false);
  }
  template <typename PT, typename CT>
  nsIContent* GetNextEditableHTMLNodeInBlock(
      const EditorDOMPointBase<PT, CT>& aPoint) const {
    return GetNextEditableHTMLNodeInternal(aPoint, true);
  }

  /**
   * GetNextEditableHTMLNodeInternal() methods are common implementation
   * of above methods.  Please don't use this method directly.
   */
  nsIContent* GetNextEditableHTMLNodeInternal(nsINode& aNode,
                                              bool aNoBlockCrossing) const;
  template <typename PT, typename CT>
  nsIContent* GetNextEditableHTMLNodeInternal(
      const EditorDOMPointBase<PT, CT>& aPoint, bool aNoBlockCrossing) const;

  bool IsFirstEditableChild(nsINode* aNode) const;
  bool IsLastEditableChild(nsINode* aNode) const;
  nsIContent* GetFirstEditableChild(nsINode& aNode) const;
  nsIContent* GetLastEditableChild(nsINode& aNode) const;

  nsIContent* GetFirstEditableLeaf(nsINode& aNode) const;
  nsIContent* GetLastEditableLeaf(nsINode& aNode) const;

  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult GetInlinePropertyBase(
      nsAtom& aHTMLProperty, nsAtom* aAttribute, const nsAString* aValue,
      bool* aFirst, bool* aAny, bool* aAll, nsAString* outValue) const;

  /**
   * ClearStyleAt() splits parent elements to remove the specified style.
   * If this splits some parent elements at near their start or end, such
   * empty elements will be removed.  Then, remove the specified style
   * from the point and returns DOM point to put caret.
   *
   * @param aPoint      The point to clear style at.
   * @param aProperty   An HTML tag name which represents a style.
   *                    Set nullptr if you want to clear all styles.
   * @param aAttribute  Attribute name if aProperty has some styles like
   *                    nsGkAtoms::font.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT EditResult ClearStyleAt(
      const EditorDOMPoint& aPoint, nsAtom* aProperty, nsAtom* aAttribute);

  MOZ_CAN_RUN_SCRIPT nsresult SetPositionToAbsolute(Element& aElement);
  MOZ_CAN_RUN_SCRIPT nsresult SetPositionToStatic(Element& aElement);

  /**
   * OnModifyDocument() is called when the editor is changed.  This should
   * be called only by runnable in HTMLEditor::OnDocumentModified() to call
   * HTMLEditor::OnModifyDocument() with AutoEditActionDataSetter instance.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult OnModifyDocument();

  /**
   * DoSplitNode() creates a new node (left node) identical to an existing
   * node (right node), and split the contents between the same point in both
   * nodes.
   *
   * @param aStartOfRightNode   The point to split.  Its container will be
   *                            the right node, i.e., become the new node's
   *                            next sibling.  And the point will be start
   *                            of the right node.
   * @param aNewLeftNode        The new node called as left node, so, this
   *                            becomes the container of aPointToSplit's
   *                            previous sibling.
   * @param aError              Must have not already failed.
   *                            If succeed to insert aLeftNode before the
   *                            right node and remove unnecessary contents
   *                            (and collapse selection at end of the left
   *                            node if necessary), returns no error.
   *                            Otherwise, an error.
   */
  MOZ_CAN_RUN_SCRIPT void DoSplitNode(const EditorDOMPoint& aStartOfRightNode,
                                      nsIContent& aNewLeftNode,
                                      ErrorResult& aError);

  /**
   * DoJoinNodes() merges contents in aContentToJoin to aContentToKeep and
   * remove aContentToJoin from the DOM tree.  aContentToJoin and aContentToKeep
   * must have same parent, aParent.  Additionally, if one of aContentToJoin or
   * aContentToKeep is a text node, the other must be a text node.
   *
   * @param aContentToKeep  The node that will remain after the join.
   * @param aContentToJoin  The node that will be joined with aContentToKeep.
   *                        There is no requirement that the two nodes be of the
   *                        same type.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  DoJoinNodes(nsIContent& aContentToKeep, nsIContent& aContentToJoin);

 protected:  // edit sub-action handler
  /**
   * CanHandleHTMLEditSubAction() checks whether there is at least one
   * selection range or not, and whether the first range is editable.
   * If it's not editable, `Canceled()` of the result returns true.
   * If `Selection` is in odd situation, returns an error.
   *
   * XXX I think that `IsSelectionEditable()` is better name, but it's already
   *     in `EditorBase`...
   */
  EditActionResult CanHandleHTMLEditSubAction() const;

  /**
   * EnsureCaretNotAfterPaddingBRElement() makes sure that caret is NOT after
   * padding `<br>` element for preventing insertion after padding `<br>`
   * element at empty last line.
   * NOTE: This method should be called only when `Selection` is collapsed
   *       because `Selection` is a pain to work with when not collapsed.
   *       (no good way to extend start or end of selection), so we need to
   *       ignore those types of selections.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  EnsureCaretNotAfterPaddingBRElement();

  /**
   * PrepareInlineStylesForCaret() consider inline styles from top level edit
   * sub-action and setting it to `mTypeInState` and clear inline style cache
   * if necessary.
   * NOTE: This method should be called only when `Selection` is collapsed.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult PrepareInlineStylesForCaret();

  /**
   * HandleInsertText() handles inserting text at selection.
   *
   * @param aEditSubAction      Must be EditSubAction::eInsertText or
   *                            EditSubAction::eInsertTextComingFromIME.
   * @param aInsertionString    String to be inserted at selection.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT virtual EditActionResult HandleInsertText(
      EditSubAction aEditSubAction, const nsAString& aInsertionString) final;

  /**
   * GetInlineStyles() retrieves the style of aNode and modifies each item of
   * aStyleCacheArray.  This might cause flushing layout at retrieving computed
   * values of CSS properties.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  GetInlineStyles(nsIContent& aContent, AutoStyleCacheArray& aStyleCacheArray);

  /**
   * CacheInlineStyles() caches style of aContent into mCachedInlineStyles of
   * TopLevelEditSubAction.  This may cause flushing layout at retrieving
   * computed value of CSS properties.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  CacheInlineStyles(nsIContent& aContent);

  /**
   * ReapplyCachedStyles() restores some styles which are disappeared during
   * handling edit action and it should be restored.  This may cause flushing
   * layout at retrieving computed value of CSS properties.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult ReapplyCachedStyles();

  /**
   * CreateStyleForInsertText() sets CSS properties which are stored in
   * TypeInState to proper element node.
   * XXX This modifies Selection, but should return insertion point instead.
   *
   * @param aAbstractRange      Set current selection range where new text
   *                            should be inserted.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  CreateStyleForInsertText(const dom::AbstractRange& aAbstractRange);

  /**
   * GetMostAncestorMailCiteElement() returns most-ancestor mail cite element.
   * "mail cite element" is <pre> element when it's in plaintext editor mode
   * or an element with which calling HTMLEditUtils::IsMailCite() returns true.
   *
   * @param aNode       The start node to look for parent mail cite elements.
   */
  Element* GetMostAncestorMailCiteElement(nsINode& aNode) const;

  /**
   * SplitMailCiteElements() splits mail-cite elements at start of Selection if
   * Selection starts from inside a mail-cite element.  Of course, if it's
   * necessary, this inserts <br> node to new left nodes or existing right
   * nodes.
   * XXX This modifies Selection, but should return SplitNodeResult() instead.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT EditActionResult
  SplitMailCiteElements(const EditorDOMPoint& aPointToSplit);

  /**
   * InsertBRElement() inserts a <br> element into aInsertToBreak.
   * This may split container elements at the point and/or may move following
   * <br> element to immediately after the new <br> element if necessary.
   * XXX This method name is too generic and unclear whether such complicated
   *     things will be done automatically or not.
   * XXX This modifies Selection, but should return CreateElementResult instead.
   *
   * @param aInsertToBreak      The point where new <br> element will be
   *                            inserted before.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  InsertBRElement(const EditorDOMPoint& aInsertToBreak);

  /**
   * GetMostAncestorInlineElement() returns the most ancestor inline element
   * between aNode and the editing host.  Even if the editing host is an inline
   * element, this method never returns the editing host as the result.
   */
  nsIContent* GetMostAncestorInlineElement(nsINode& aNode) const;

  /**
   * SplitParentInlineElementsAtRangeEdges() splits parent inline nodes at both
   * start and end of aRangeItem.  If this splits at every point, this modifies
   * aRangeItem to point each split point (typically, right node).
   *
   * @param aRangeItem          [in/out] One or two DOM points where should be
   *                            split.  Will be modified to split point if
   *                            they're split.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  SplitParentInlineElementsAtRangeEdges(RangeItem& aRangeItem);

  /**
   * SplitParentInlineElementsAtRangeEdges(nsTArray<RefPtr<nsRange>>&) calls
   * SplitParentInlineElementsAtRangeEdges(RangeItem&) for each range.  Then,
   * updates given range to keep edit target ranges as expected.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  SplitParentInlineElementsAtRangeEdges(
      nsTArray<RefPtr<nsRange>>& aArrayOfRanges);

  /**
   * SplitElementsAtEveryBRElement() splits before all <br> elements in
   * aMostAncestorToBeSplit.  All <br> nodes will be moved before right node
   * at splitting its parent.  Finally, this returns left node, first <br>
   * element, next left node, second <br> element... and right-most node.
   *
   * @param aMostAncestorToBeSplit      Most-ancestor element which should
   *                                    be split.
   * @param aOutArrayOfNodes            First left node, first <br> element,
   *                                    Second left node, second <br> element,
   *                                    ...right-most node.  So, all nodes
   *                                    in this list should be siblings (may be
   *                                    broken the relation by mutation event
   *                                    listener though). If first <br> element
   *                                    is first leaf node of
   *                                    aMostAncestorToBeSplit, starting from
   *                                    the first <br> element.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult SplitElementsAtEveryBRElement(
      nsIContent& aMostAncestorToBeSplit,
      nsTArray<OwningNonNull<nsIContent>>& aOutArrayOfContents);

  /**
   * MaybeSplitElementsAtEveryBRElement() calls SplitElementsAtEveryBRElement()
   * for each given node when this needs to do that for aEditSubAction.
   * If split a node, it in aArrayOfContents is replaced with split nodes and
   * <br> elements.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult MaybeSplitElementsAtEveryBRElement(
      nsTArray<OwningNonNull<nsIContent>>& aArrayOfContents,
      EditSubAction aEditSubAction);

  /**
   * CollectEditableChildren() collects child nodes of aNode (starting from
   * first editable child, but may return non-editable children after it).
   *
   * @param aNode               Parent node of retrieving children.
   * @param aOutArrayOfContents [out] This method will inserts found children
   *                            into this array.
   * @param aIndexToInsertChildren      Starting from this index, found
   *                                    children will be inserted to the array.
   * @param aCollectListChildren        If Yes, will collect children of list
   *                                    and list-item elements recursively.
   * @param aCollectTableChildren       If Yes, will collect children of table
   *                                    related elements recursively.
   * @param aCollectNonEditableNodes    If Yes, will collect found children
   *                                    even if they are not editable.
   * @return                    Number of found children.
   */
  enum class CollectListChildren { No, Yes };
  enum class CollectTableChildren { No, Yes };
  enum class CollectNonEditableNodes { No, Yes };
  size_t CollectChildren(
      nsINode& aNode, nsTArray<OwningNonNull<nsIContent>>& aOutArrayOfContents,
      size_t aIndexToInsertChildren, CollectListChildren aCollectListChildren,
      CollectTableChildren aCollectTableChildren,
      CollectNonEditableNodes aCollectNonEditableNodes) const;

  /**
   * SplitInlinessAndCollectEditTargetNodes() splits text nodes and inline
   * elements around aArrayOfRanges.  Then, collects edit target nodes to
   * aOutArrayOfNodes.  Finally, each edit target nodes is split at every
   * <br> element in it.
   * FYI: You can use SplitInlinesAndCollectEditTargetNodesInOneHardLine()
   *      or SplitInlinesAndCollectEditTargetNodesInExtendedSelectionRanges()
   *      instead if you want to call this with a hard line including
   *      specific DOM point or extended selection ranges.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  SplitInlinesAndCollectEditTargetNodes(
      nsTArray<RefPtr<nsRange>>& aArrayOfRanges,
      nsTArray<OwningNonNull<nsIContent>>& aOutArrayOfContents,
      EditSubAction aEditSubAction,
      CollectNonEditableNodes aCollectNonEditableNodes);

  /**
   * SplitTextNodesAtRangeEnd() splits text nodes if each range end is in
   * middle of a text node.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  SplitTextNodesAtRangeEnd(nsTArray<RefPtr<nsRange>>& aArrayOfRanges);

  /**
   * CollectEditTargetNodes() collects edit target nodes in aArrayOfRanges.
   * First, this collects all nodes in given ranges, then, modifies the
   * result for specific edit sub-actions.
   * FYI: You can use CollectEditTargetNodesInExtendedSelectionRanges() instead
   *      if you want to call this with extended selection ranges.
   */
  nsresult CollectEditTargetNodes(
      nsTArray<RefPtr<nsRange>>& aArrayOfRanges,
      nsTArray<OwningNonNull<nsIContent>>& aOutArrayOfContents,
      EditSubAction aEditSubAction,
      CollectNonEditableNodes aCollectNonEditableNodes);

  /**
   * GetWhiteSpaceEndPoint() returns point at first or last ASCII whitespace
   * or non-breakable space starting from aPoint.  I.e., this returns next or
   * previous point whether the character is neither ASCII whitespace nor
   * non-brekable space.
   */
  enum class ScanDirection { Backward, Forward };
  template <typename PT, typename RT>
  static EditorDOMPoint GetWhiteSpaceEndPoint(
      const RangeBoundaryBase<PT, RT>& aPoint, ScanDirection aScanDirection);

  /**
   * GetCurrentHardLineStartPoint() returns start point of hard line
   * including aPoint.  If the line starts after a `<br>` element, returns
   * next sibling of the `<br>` element.  If the line is first line of a block,
   * returns point of the block.
   * NOTE: The result may be point of editing host.  I.e., the container may
   *       be outside of editing host.
   */
  template <typename PT, typename RT>
  EditorDOMPoint GetCurrentHardLineStartPoint(
      const RangeBoundaryBase<PT, RT>& aPoint, EditSubAction aEditSubAction);

  /**
   * GetCurrentHardLineEndPoint() returns end point of hard line including
   * aPoint.  If the line ends with a `<br>` element, returns the `<br>`
   * element unless it's the last node of a block.  If the line is last line
   * of a block, returns next sibling of the block.  Additionally, if the
   * line ends with a linefeed in pre-formated text node, returns point of
   * the linefeed.
   * NOTE: This result may be point of editing host.  I.e., the container
   *       may be outside of editing host.
   */
  template <typename PT, typename RT>
  EditorDOMPoint GetCurrentHardLineEndPoint(
      const RangeBoundaryBase<PT, RT>& aPoint);

  /**
   * CreateRangeIncludingAdjuscentWhiteSpaces() creates an nsRange instance
   * which may be expanded from the given range to include adjuscent
   * whitespaces.  If this fails handling something, returns nullptr.
   */
  already_AddRefed<nsRange> CreateRangeIncludingAdjuscentWhiteSpaces(
      const dom::AbstractRange& aAbstractRange);
  template <typename SPT, typename SRT, typename EPT, typename ERT>
  already_AddRefed<nsRange> CreateRangeIncludingAdjuscentWhiteSpaces(
      const RangeBoundaryBase<SPT, SRT>& aStartRef,
      const RangeBoundaryBase<EPT, ERT>& aEndRef);

  /**
   * GetSelectionRangesExtendedToIncludeAdjuscentWhiteSpaces() collects
   * selection ranges with extending to include adjuscent whitespaces
   * of each range start and end.
   *
   * @param aOutArrayOfRanges   [out] Always appended same number of ranges
   *                            as Selection::RangeCount().  Must be empty
   *                            when you call this.
   */
  void GetSelectionRangesExtendedToIncludeAdjuscentWhiteSpaces(
      nsTArray<RefPtr<nsRange>>& aOutArrayOfRanges);

  /**
   * CreateRangeExtendedToHardLineStartAndEnd() creates an nsRange instance
   * which may be expanded to start/end of hard line at both edges of the given
   * range.  If this fails handling something, returns nullptr.
   */
  already_AddRefed<nsRange> CreateRangeExtendedToHardLineStartAndEnd(
      const dom::AbstractRange& aAbstractRange, EditSubAction aEditSubAction);
  template <typename SPT, typename SRT, typename EPT, typename ERT>
  already_AddRefed<nsRange> CreateRangeExtendedToHardLineStartAndEnd(
      const RangeBoundaryBase<SPT, SRT>& aStartRef,
      const RangeBoundaryBase<EPT, ERT>& aEndRef, EditSubAction aEditSubAction);

  /**
   * GetSelectionRangesExtendedToHardLineStartAndEnd() collects selection ranges
   * with extending to start/end of hard line from each range start and end.
   * XXX This means that same range may be included in the result.
   *
   * @param aOutArrayOfRanges   [out] Always appended same number of ranges
   *                            as Selection::RangeCount().  Must be empty
   *                            when you call this.
   */
  void GetSelectionRangesExtendedToHardLineStartAndEnd(
      nsTArray<RefPtr<nsRange>>& aOutArrayOfRanges,
      EditSubAction aEditSubAction);

  /**
   * SplitInlinesAndCollectEditTargetNodesInExtendedSelectionRanges() calls
   * SplitInlinesAndCollectEditTargetNodes() with result of
   * GetSelectionRangesExtendedToHardLineStartAndEnd().  See comments for these
   * methods for the detail.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  SplitInlinesAndCollectEditTargetNodesInExtendedSelectionRanges(
      nsTArray<OwningNonNull<nsIContent>>& aOutArrayOfContents,
      EditSubAction aEditSubAction,
      CollectNonEditableNodes aCollectNonEditableNodes) {
    AutoTArray<RefPtr<nsRange>, 4> extendedSelectionRanges;
    GetSelectionRangesExtendedToHardLineStartAndEnd(extendedSelectionRanges,
                                                    aEditSubAction);
    nsresult rv = SplitInlinesAndCollectEditTargetNodes(
        extendedSelectionRanges, aOutArrayOfContents, aEditSubAction,
        aCollectNonEditableNodes);
    NS_WARNING_ASSERTION(NS_SUCCEEDED(rv),
                         "SplitInlinesAndCollectEditTargetNodes() failed");
    return rv;
  }

  /**
   * SplitInlinesAndCollectEditTargetNodesInOneHardLine() just calls
   * SplitInlinesAndCollectEditTargetNodes() with result of calling
   * CreateRangeExtendedToHardLineStartAndEnd() with aPointInOneHardLine.
   * In other words, returns nodes in the hard line including
   * `aPointInOneHardLine`.  See the comments for these methods for the
   * detail.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  SplitInlinesAndCollectEditTargetNodesInOneHardLine(
      const EditorDOMPoint& aPointInOneHardLine,
      nsTArray<OwningNonNull<nsIContent>>& aOutArrayOfContents,
      EditSubAction aEditSubAction,
      CollectNonEditableNodes aCollectNonEditableNodes) {
    if (NS_WARN_IF(!aPointInOneHardLine.IsSet())) {
      return NS_ERROR_INVALID_ARG;
    }
    RefPtr<nsRange> oneLineRange = CreateRangeExtendedToHardLineStartAndEnd(
        aPointInOneHardLine.ToRawRangeBoundary(),
        aPointInOneHardLine.ToRawRangeBoundary(), aEditSubAction);
    if (!oneLineRange) {
      // XXX It seems odd to create collapsed range for one line range...
      ErrorResult error;
      oneLineRange =
          nsRange::Create(aPointInOneHardLine.ToRawRangeBoundary(),
                          aPointInOneHardLine.ToRawRangeBoundary(), error);
      if (NS_WARN_IF(error.Failed())) {
        return error.StealNSResult();
      }
    }
    AutoTArray<RefPtr<nsRange>, 1> arrayOfLineRanges;
    arrayOfLineRanges.AppendElement(oneLineRange);
    nsresult rv = SplitInlinesAndCollectEditTargetNodes(
        arrayOfLineRanges, aOutArrayOfContents, aEditSubAction,
        aCollectNonEditableNodes);
    NS_WARNING_ASSERTION(NS_SUCCEEDED(rv),
                         "SplitInlinesAndCollectEditTargetNodes() failed");
    return rv;
  }

  /**
   * CollectEditTargetNodesInExtendedSelectionRanges() calls
   * CollectEditTargetNodes() with result of
   * GetSelectionRangesExtendedToHardLineStartAndEnd().  See comments for these
   * methods for the detail.
   */
  nsresult CollectEditTargetNodesInExtendedSelectionRanges(
      nsTArray<OwningNonNull<nsIContent>>& aOutArrayOfContents,
      EditSubAction aEditSubAction,
      CollectNonEditableNodes aCollectNonEditableNodes) {
    AutoTArray<RefPtr<nsRange>, 4> extendedSelectionRanges;
    GetSelectionRangesExtendedToHardLineStartAndEnd(extendedSelectionRanges,
                                                    aEditSubAction);
    nsresult rv =
        CollectEditTargetNodes(extendedSelectionRanges, aOutArrayOfContents,
                               aEditSubAction, aCollectNonEditableNodes);
    NS_WARNING_ASSERTION(NS_SUCCEEDED(rv), "CollectEditTargetNodes() failed");
    return rv;
  }

  /**
   * SelectBRElementIfCollapsedInEmptyBlock() helper method for
   * CreateRangeIncludingAdjuscentWhiteSpaces() and
   * CreateRangeExtendedToLineStartAndEnd().  If the given range is collapsed
   * in a block and the block has only one `<br>` element, this makes
   * aStartRef and aEndRef select the `<br>` element.
   */
  template <typename SPT, typename SRT, typename EPT, typename ERT>
  void SelectBRElementIfCollapsedInEmptyBlock(
      RangeBoundaryBase<SPT, SRT>& aStartRef,
      RangeBoundaryBase<EPT, ERT>& aEndRef);

  /**
   * GetChildNodesOf() returns all child nodes of aParent with an array.
   */
  static void GetChildNodesOf(
      nsINode& aParentNode,
      nsTArray<OwningNonNull<nsIContent>>& aOutArrayOfContents) {
    MOZ_ASSERT(aOutArrayOfContents.IsEmpty());
    aOutArrayOfContents.SetCapacity(aParentNode.GetChildCount());
    for (nsIContent* childContent = aParentNode.GetFirstChild(); childContent;
         childContent = childContent->GetNextSibling()) {
      aOutArrayOfContents.AppendElement(*childContent);
    }
  }

  /**
   * GetDeepestEditableOnlyChildDivBlockquoteOrListElement() returns a `<div>`,
   * `<blockquote>` or one of list elements.  This method climbs down from
   * aContent while there is only one editable children and the editable child
   * is `<div>`, `<blockquote>` or a list element.  When it reaches different
   * kind of node, returns the last found element.
   */
  Element* GetDeepestEditableOnlyChildDivBlockquoteOrListElement(
      nsINode& aNode);

  /**
   * Try to get parent list element at `Selection`.  This returns first find
   * parent list element of common ancestor of ranges (looking for it from
   * first range to last range).
   */
  Element* GetParentListElementAtSelection() const;

  /**
   * MaybeExtendSelectionToHardLineEdgesForBlockEditAction() adjust Selection if
   * there is only one range.  If range start and/or end point is <br> node or
   * something non-editable point, they should be moved to nearest text node or
   * something where the other methods easier to handle edit action.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  MaybeExtendSelectionToHardLineEdgesForBlockEditAction();

  /**
   * IsEmptyInlineNode() returns true if aContent is an inline node and it does
   * not have meaningful content.
   */
  bool IsEmptyInlineNode(nsIContent& aContent) const;

  /**
   * IsEmptyOneHardLine() returns true if aArrayOfContents does not represent
   * 2 or more lines and have meaningful content.
   */
  bool IsEmptyOneHardLine(
      nsTArray<OwningNonNull<nsIContent>>& aArrayOfContents) const {
    if (NS_WARN_IF(aArrayOfContents.IsEmpty())) {
      return true;
    }

    bool brElementHasFound = false;
    for (OwningNonNull<nsIContent>& content : aArrayOfContents) {
      if (!EditorUtils::IsEditableContent(content, EditorType::HTML)) {
        continue;
      }
      if (content->IsHTMLElement(nsGkAtoms::br)) {
        // If there are 2 or more `<br>` elements, it's not empty line since
        // there may be only one `<br>` element in a hard line.
        if (brElementHasFound) {
          return false;
        }
        brElementHasFound = true;
        continue;
      }
      if (!IsEmptyInlineNode(content)) {
        return false;
      }
    }
    return true;
  }

  /**
   * MaybeSplitAncestorsForInsertWithTransaction() does nothing if container of
   * aStartOfDeepestRightNode can have an element whose tag name is aTag.
   * Otherwise, looks for an ancestor node which is or is in active editing
   * host and can have an element whose name is aTag.  If there is such
   * ancestor, its descendants are split.
   *
   * Note that this may create empty elements while splitting ancestors.
   *
   * @param aTag                        The name of element to be inserted
   *                                    after calling this method.
   * @param aStartOfDeepestRightNode    The start point of deepest right node.
   *                                    This point must be descendant of
   *                                    active editing host.
   * @return                            When succeeded, SplitPoint() returns
   *                                    the point to insert the element.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT SplitNodeResult
  MaybeSplitAncestorsForInsertWithTransaction(
      nsAtom& aTag, const EditorDOMPoint& aStartOfDeepestRightNode);

  /**
   * SplitRangeOffFromBlock() splits aBlockElement at two points, before
   * aStartOfMiddleElement and after aEndOfMiddleElement.  If they are very
   * start or very end of aBlcok, this won't create empty block.
   *
   * @param aBlockElement           A block element which will be split.
   * @param aStartOfMiddleElement   Start node of middle block element.
   * @param aEndOfMiddleElement     End node of middle block element.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT SplitRangeOffFromNodeResult
  SplitRangeOffFromBlock(Element& aBlockElement,
                         nsIContent& aStartOfMiddleElement,
                         nsIContent& aEndOfMiddleElement);

  /**
   * SplitRangeOffFromBlockAndRemoveMiddleContainer() splits the nodes
   * between aStartOfRange and aEndOfRange, then, removes the middle element
   * and moves its content to where the middle element was.
   *
   * @param aBlockElement           The node which will be split.
   * @param aStartOfRange           The first node which will be unwrapped
   *                                from aBlockElement.
   * @param aEndOfRange             The last node which will be unwrapped from
   *                                aBlockElement.
   * @return                        The left content is new created left
   *                                element of aBlockElement.
   *                                The right content is split element,
   *                                i.e., must be aBlockElement.
   *                                The middle content is nullptr since
   *                                removing it is the job of this method.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT SplitRangeOffFromNodeResult
  SplitRangeOffFromBlockAndRemoveMiddleContainer(Element& aBlockElement,
                                                 nsIContent& aStartOfRange,
                                                 nsIContent& aEndOfRange);

  /**
   * MoveNodesIntoNewBlockquoteElement() inserts at least one <blockquote>
   * element and moves nodes in aArrayOfContents into new <blockquote>
   * elements.
   * If aArrayOfContents includes a table related element except <table>,
   * this calls itself recursively to insert <blockquote> into the cell.
   *
   * @param aArrayOfContents    Nodes which will be moved into created
   *                            <blockquote> elements.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult MoveNodesIntoNewBlockquoteElement(
      nsTArray<OwningNonNull<nsIContent>>& aArrayOfContents);

  /**
   * RemoveBlockContainerElements() removes all format blocks, table related
   * element, etc in aArrayOfContents from the DOM tree.
   * If aArrayOfContents has a format node, it will be removed and its contents
   * will be moved to where it was.
   * If aArrayOfContents has a table related element, <li>, <blockquote> or
   * <div>, it will be removed and its contents will be moved to where it was.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult RemoveBlockContainerElements(
      nsTArray<OwningNonNull<nsIContent>>& aArrayOfContents);

  /**
   * CreateOrChangeBlockContainerElement() formats all nodes in aArrayOfContents
   * with block elements whose name is aBlockTag.
   * If aArrayOfContents has an inline element, a block element is created and
   * the inline element and following inline elements are moved into the new
   * block element.
   * If aArrayOfContents has <br> elements, they'll be removed from the DOM
   * tree and new block element will be created when there are some remaining
   * inline elements.
   * If aArrayOfContents has a block element, this calls itself with children
   * of the block element.  Then, new block element will be created when there
   * are some remaining inline elements.
   *
   * @param aArrayOfContents    Must be descendants of a node.
   * @param aBlockTag           The element name of new block elements.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult CreateOrChangeBlockContainerElement(
      nsTArray<OwningNonNull<nsIContent>>& aArrayOfContents, nsAtom& aBlockTag);

  /**
   * FormatBlockContainerWithTransaction() is implementation of "formatBlock"
   * command of `Document.execCommand()`.  This applies block style or removes
   * it.
   * NOTE: This creates AutoSelectionRestorer.  Therefore, even when this
   *       return NS_OK, editor may have been destroyed.
   *
   * @param aBlockType          New block tag name.
   *                            If nsGkAtoms::normal or nsGkAtoms::_empty,
   *                            RemoveBlockContainerElements() will be called.
   *                            If nsGkAtoms::blockquote,
   *                            MoveNodesIntoNewBlockquoteElement() will be
   *                            called.  Otherwise,
   *                            CreateOrChangeBlockContainerElement() will be
   *                            called.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  FormatBlockContainerWithTransaction(nsAtom& aBlockType);

  /**
   * InsertBRElementIfHardLineIsEmptyAndEndsWithBlockBoundary() determines if
   * aPointToInsert is start of a hard line and end of the line (i.e, the
   * line is empty) and the line ends with block boundary, inserts a `<br>`
   * element.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  InsertBRElementIfHardLineIsEmptyAndEndsWithBlockBoundary(
      const EditorDOMPoint& aPointToInsert);

  /**
   * Insert a `<br>` element if aElement is a block element and empty.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  InsertBRElementIfEmptyBlockElement(Element& aElement);

  /**
   * Insert padding `<br>` element for empty last line into aElement if
   * aElement is a block element and empty.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  InsertPaddingBRElementForEmptyLastLineIfNeeded(Element& aElement);

  /**
   * This method inserts a padding `<br>` element for empty last line if
   * selection is collapsed and container of the range needs it.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  MaybeInsertPaddingBRElementForEmptyLastLineAtSelection();

  /**
   * IsEmptyBlockElement() returns true if aElement is a block level element
   * and it doesn't have any visible content.
   */
  enum class IgnoreSingleBR { Yes, No };
  bool IsEmptyBlockElement(Element& aElement,
                           IgnoreSingleBR aIgnoreSingleBR) const;

  /**
   * SplitParagraph() splits the parent block, aParentDivOrP, at
   * aStartOfRightNode.
   *
   * @param aParentDivOrP       The parent block to be split.  This must be <p>
   *                            or <div> element.
   * @param aStartOfRightNode   The point to be start of right node after
   *                            split.  This must be descendant of
   *                            aParentDivOrP.
   * @param aNextBRNode         Next <br> node if there is.  Otherwise, nullptr.
   *                            If this is not nullptr, the <br> node may be
   *                            removed.
   */
  template <typename PT, typename CT>
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult SplitParagraph(
      Element& aParentDivOrP,
      const EditorDOMPointBase<PT, CT>& aStartOfRightNode, nsIContent* aBRNode);

  /**
   * HandleInsertParagraphInParagraph() does the right thing for Enter key
   * press or 'insertParagraph' command in aParentDivOrP.  aParentDivOrP will
   * be split at start of first selection range.
   *
   * @param aParentDivOrP   The parent block.  This must be <p> or <div>
   *                        element.
   * @return                Returns with NS_OK if this doesn't meat any
   *                        unexpected situation.  If this method tries to
   *                        split the paragraph, marked as handled.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT EditActionResult
  HandleInsertParagraphInParagraph(Element& aParentDivOrP);

  /**
   * HandleInsertParagraphInHeadingElement() handles insertParagraph command
   * (i.e., handling Enter key press) in a heading element.  This splits
   * aHeader element at aOffset in aNode.  Then, if right heading element is
   * empty, it'll be removed and new paragraph is created (its type is decided
   * with default paragraph separator).
   *
   * @param aHeader             The heading element to be split.
   * @param aNode               Typically, Selection start container,
   *                            where to be split.
   * @param aOffset             Typically, Selection start offset in the
   *                            start container, where to be split.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  HandleInsertParagraphInHeadingElement(Element& aHeader, nsINode& aNode,
                                        int32_t aOffset);

  /**
   * HandleInsertParagraphInListItemElement() handles insertParagraph command
   * (i.e., handling Enter key press) in a list item element.
   *
   * @param aListItem           The list item which has the following point.
   * @param aNode               Typically, Selection start container, where to
   *                            insert a break.
   * @param aOffset             Typically, Selection start offset in the
   *                            start container, where to insert a break.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  HandleInsertParagraphInListItemElement(Element& aListItem, nsINode& aNode,
                                         int32_t aOffset);

  /**
   * GetNearestAncestorListItemElement() returns a list item element if
   * aContent or its ancestor in editing host is one.  However, this won't
   * cross table related element.
   */
  Element* GetNearestAncestorListItemElement(nsIContent& aContent) const;

  /**
   * InsertParagraphSeparatorAsSubAction() handles insertPargraph commad
   * (i.e., handling Enter key press) with the above helper methods.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT EditActionResult
  InsertParagraphSeparatorAsSubAction();

  /**
   * Returns true if aNode1 or aNode2 or both is the descendant of some type of
   * table element, but their nearest table element ancestors differ.  "Table
   * element" here includes not just <table> but also <td>, <tbody>, <tr>, etc.
   * The nodes count as being their own descendants for this purpose, so a
   * table element is its own nearest table element ancestor.
   */
  static bool NodesInDifferentTableElements(nsINode& aNode1, nsINode& aNode2);

  /**
   * ChangeListElementType() replaces child list items of aListElement with
   * new list item element whose tag name is aNewListItemTag.
   * Note that if there are other list elements as children of aListElement,
   * this calls itself recursively even though it's invalid structure.
   *
   * @param aListElement        The list element whose list items will be
   *                            replaced.
   * @param aNewListTag         New list tag name.
   * @param aNewListItemTag     New list item tag name.
   * @return                    New list element or an error code if it fails.
   *                            New list element may be aListElement if its
   *                            tag name is same as aNewListTag.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT CreateElementResult ChangeListElementType(
      Element& aListElement, nsAtom& aListType, nsAtom& aItemType);

  /**
   * ChangeSelectedHardLinesToList() converts selected ranges to specified
   * list element.  If there is different type of list elements, this method
   * converts them to specified list items too.  Basically, each hard line
   * will be wrapped with a list item element.  However, only when `<p>`
   * element is selected, its child `<br>` elements won't be treated as
   * hard line separators.  Perhaps, this is a bug.
   * NOTE: This method creates AutoSelectionRestorer.  Therefore, each caller
   *       need to check if the editor is still available even if this returns
   *       NS_OK.
   *
   * @param aListElementTagName         The new list element tag name.
   * @param aListItemElementTagName     The new list item element tag name.
   * @param aBulletType                 If this is not empty string, it's set
   *                                    to `type` attribute of new list item
   *                                    elements.  Otherwise, existing `type`
   *                                    attributes will be removed.
   * @param aSelectAllOfCurrentList     Yes if this should treat all of
   *                                    ancestor list element at selection.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT EditActionResult
  ChangeSelectedHardLinesToList(nsAtom& aListElementTagName,
                                nsAtom& aListItemElementTagName,
                                const nsAString& aBulletType,
                                SelectAllOfCurrentList aSelectAllOfCurrentList);

  /**
   * MakeOrChangeListAndListItemAsSubAction() handles create list commands with
   * current selection.  If
   *
   * @param aListElementOrListItemElementTagName
   *                                    The new list element tag name or
   *                                    new list item tag name.
   *                                    If the former, list item tag name will
   *                                    be computed automatically.  Otherwise,
   *                                    list tag name will be computed.
   * @param aBulletType                 If this is not empty string, it's set
   *                                    to `type` attribute of new list item
   *                                    elements.  Otherwise, existing `type`
   *                                    attributes will be removed.
   * @param aSelectAllOfCurrentList     Yes if this should treat all of
   *                                    ancestor list element at selection.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT EditActionResult
  MakeOrChangeListAndListItemAsSubAction(
      nsAtom& aListElementOrListItemElementTagName,
      const nsAString& aBulletType,
      SelectAllOfCurrentList aSelectAllOfCurrentList);

  /**
   * If aContent is a text node that contains only collapsed whitespace or empty
   * and editable.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  DeleteNodeIfInvisibleAndEditableTextNode(nsIContent& aContent);

  /**
   * DeleteTextAndTextNodesWithTransaction() removes text nodes which are in
   * the given range and delete some characters in start and/or end of
   * the range.
   */
  template <typename EditorDOMPointType>
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  DeleteTextAndTextNodesWithTransaction(const EditorDOMPointType& aStartPoint,
                                        const EditorDOMPointType& aEndPoint);

  /**
   * If aPoint follows invisible `<br>` element, returns the invisible `<br>`
   * element.  Otherwise, nullptr.
   */
  template <typename PT, typename CT>
  Element* GetInvisibleBRElementAt(const EditorDOMPointBase<PT, CT>& aPoint);

  /**
   * JoinNodesWithTransaction() joins aLeftNode and aRightNode.  Content of
   * aLeftNode will be merged into aRightNode.  Actual implemenation of this
   * method is JoinNodesImpl().  So, see its explanation for the detail.
   *
   * @param aLeftNode   Will be removed from the DOM tree.
   * @param aRightNode  The node which will be new container of the content of
   *                    aLeftNode.
   */
  MOZ_CAN_RUN_SCRIPT nsresult JoinNodesWithTransaction(nsINode& aLeftNode,
                                                       nsINode& aRightNode);

  /**
   * JoinNearestEditableNodesWithTransaction() joins two editable nodes which
   * are themselves or the nearest editable node of aLeftNode and aRightNode.
   * XXX This method's behavior is odd.  For example, if user types Backspace
   *     key at the second editable paragraph in this case:
   *     <div contenteditable>
   *       <p>first editable paragraph</p>
   *       <p contenteditable="false">non-editable paragraph</p>
   *       <p>second editable paragraph</p>
   *     </div>
   *     The first editable paragraph's content will be moved into the second
   *     editable paragraph and the non-editable paragraph becomes the first
   *     paragraph of the editor.  I don't think that it's expected behavior of
   *     any users...
   *
   * @param aLeftNode   The node which will be removed.
   * @param aRightNode  The node which will be inserted the content of
   *                    aLeftNode.
   * @param aNewFirstChildOfRightNode
   *                    [out] The point at the first child of aRightNode.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  JoinNearestEditableNodesWithTransaction(
      nsIContent& aLeftNode, nsIContent& aRightNode,
      EditorDOMPoint* aNewFirstChildOfRightNode);

  /**
   * ReplaceContainerAndCloneAttributesWithTransaction() creates new element
   * whose name is aTagName, copies all attributes from aOldContainer to the
   * new element, moves all children in aOldContainer to the new element, then,
   * removes aOldContainer from the DOM tree.
   *
   * @param aOldContainer       The element node which should be replaced
   *                            with new element.
   * @param aTagName            The name of new element node.
   */
  MOZ_CAN_RUN_SCRIPT already_AddRefed<Element>
  ReplaceContainerAndCloneAttributesWithTransaction(Element& aOldContainer,
                                                    nsAtom& aTagName) {
    return ReplaceContainerWithTransactionInternal(
        aOldContainer, aTagName, *nsGkAtoms::_empty, EmptyString(), true);
  }

  /**
   * ReplaceContainerWithTransaction() creates new element whose name is
   * aTagName, sets aAttributes of the new element to aAttributeValue, moves
   * all children in aOldContainer to the new element, then, removes
   * aOldContainer from the DOM tree.
   *
   * @param aOldContainer       The element node which should be replaced
   *                            with new element.
   * @param aTagName            The name of new element node.
   * @param aAttribute          Attribute name to be set to the new element.
   * @param aAttributeValue     Attribute value to be set to aAttribute.
   */
  MOZ_CAN_RUN_SCRIPT already_AddRefed<Element> ReplaceContainerWithTransaction(
      Element& aOldContainer, nsAtom& aTagName, nsAtom& aAttribute,
      const nsAString& aAttributeValue) {
    return ReplaceContainerWithTransactionInternal(
        aOldContainer, aTagName, aAttribute, aAttributeValue, false);
  }

  /**
   * ReplaceContainerWithTransaction() creates new element whose name is
   * aTagName, moves all children in aOldContainer to the new element, then,
   * removes aOldContainer from the DOM tree.
   *
   * @param aOldContainer       The element node which should be replaced
   *                            with new element.
   * @param aTagName            The name of new element node.
   */
  MOZ_CAN_RUN_SCRIPT already_AddRefed<Element> ReplaceContainerWithTransaction(
      Element& aOldContainer, nsAtom& aTagName) {
    return ReplaceContainerWithTransactionInternal(
        aOldContainer, aTagName, *nsGkAtoms::_empty, EmptyString(), false);
  }

  /**
   * RemoveContainerWithTransaction() removes aElement from the DOM tree and
   * moves all its children to the parent of aElement.
   *
   * @param aElement            The element to be removed.
   */
  MOZ_CAN_RUN_SCRIPT nsresult RemoveContainerWithTransaction(Element& aElement);

  /**
   * InsertContainerWithTransaction() creates new element whose name is
   * aTagName, moves aContent into the new element, then, inserts the new
   * element into where aContent was.
   * Note that this method does not check if aContent is valid child of
   * the new element.  So, callers need to guarantee it.
   *
   * @param aContent            The content which will be wrapped with new
   *                            element.
   * @param aTagName            Element name of new element which will wrap
   *                            aContent and be inserted into where aContent
   *                            was.
   * @return                    The new element.
   */
  MOZ_CAN_RUN_SCRIPT already_AddRefed<Element> InsertContainerWithTransaction(
      nsIContent& aContent, nsAtom& aTagName) {
    return InsertContainerWithTransactionInternal(
        aContent, aTagName, *nsGkAtoms::_empty, EmptyString());
  }

  /**
   * InsertContainerWithTransaction() creates new element whose name is
   * aTagName, sets its aAttribute to aAttributeValue, moves aContent into the
   * new element, then, inserts the new element into where aContent was.
   * Note that this method does not check if aContent is valid child of
   * the new element.  So, callers need to guarantee it.
   *
   * @param aContent            The content which will be wrapped with new
   *                            element.
   * @param aTagName            Element name of new element which will wrap
   *                            aContent and be inserted into where aContent
   *                            was.
   * @param aAttribute          Attribute which should be set to the new
   *                            element.
   * @param aAttributeValue     Value to be set to aAttribute.
   * @return                    The new element.
   */
  MOZ_CAN_RUN_SCRIPT already_AddRefed<Element> InsertContainerWithTransaction(
      nsIContent& aContent, nsAtom& aTagName, nsAtom& aAttribute,
      const nsAString& aAttributeValue) {
    return InsertContainerWithTransactionInternal(aContent, aTagName,
                                                  aAttribute, aAttributeValue);
  }

  /**
   * MoveNodeWithTransaction() moves aContent to aPointToInsert.
   *
   * @param aContent        The node to be moved.
   */
  MOZ_CAN_RUN_SCRIPT nsresult MoveNodeWithTransaction(
      nsIContent& aContent, const EditorDOMPoint& aPointToInsert);

  /**
   * MoveNodeToEndWithTransaction() moves aContent to end of aNewContainer.
   *
   * @param aContent        The node to be moved.
   * @param aNewContainer   The new container which will contain aContent as
   *                        its last child.
   */
  MOZ_CAN_RUN_SCRIPT nsresult
  MoveNodeToEndWithTransaction(nsIContent& aContent, nsINode& aNewContainer) {
    EditorDOMPoint pointToInsert;
    pointToInsert.SetToEndOf(&aNewContainer);
    return MoveNodeWithTransaction(aContent, pointToInsert);
  }

  /**
   * MoveNodeOrChildrenWithTransaction() moves aContent to aPointToInsert.  If
   * cannot insert aContent due to invalid relation, moves only its children
   * recursively and removes aContent from the DOM tree.
   *
   * @param aContent            Content which should be moved.
   * @param aPointToInsert      The point to be inserted aContent or its
   *                            descendants.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT MoveNodeResult
  MoveNodeOrChildrenWithTransaction(nsIContent& aNode,
                                    const EditorDOMPoint& aPointToInsert);

  /**
   * MoveChildrenWithTransaction() moves the children of aElement to
   * aPointToInsert.  If cannot insert some children due to invalid relation,
   * calls MoveNodeOrChildrenWithTransaction() to remove the children but keep
   * moving its children.
   *
   * @param aElement            Container element whose children should be
   *                            moved.
   * @param aPointToInsert      The point to be inserted children of aElement
   *                            or its descendants.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT MoveNodeResult MoveChildrenWithTransaction(
      Element& aElement, const EditorDOMPoint& aPointToInsert);

  /**
   * MoveAllChildren() moves all children of aContainer to before
   * aPointToInsert.GetChild().
   * See explanation of MoveChildrenBetween() for the detail of the behavior.
   *
   * @param aContainer          The container node whose all children should
   *                            be moved.
   * @param aPointToInsert      The insertion point.  The container must not
   *                            be a data node like a text node.
   * @param aError              The result.  If this succeeds to move children,
   *                            returns NS_OK.  Otherwise, an error.
   */
  void MoveAllChildren(nsINode& aContainer,
                       const EditorRawDOMPoint& aPointToInsert,
                       ErrorResult& aError);

  /**
   * MoveChildrenBetween() moves all children between aFirstChild and aLastChild
   * to before aPointToInsert.GetChild(). If some children are moved to
   * different container while this method moves other children, they are just
   * ignored. If the child node referred by aPointToInsert is moved to different
   * container while this method moves children, returns error.
   *
   * @param aFirstChild         The first child which should be moved to
   *                            aPointToInsert.
   * @param aLastChild          The last child which should be moved.  This
   *                            must be a sibling of aFirstChild and it should
   *                            be positioned after aFirstChild in the DOM tree
   *                            order.
   * @param aPointToInsert      The insertion point.  The container must not
   *                            be a data node like a text node.
   * @param aError              The result.  If this succeeds to move children,
   *                            returns NS_OK.  Otherwise, an error.
   */
  void MoveChildrenBetween(nsIContent& aFirstChild, nsIContent& aLastChild,
                           const EditorRawDOMPoint& aPointToInsert,
                           ErrorResult& aError);

  /**
   * MovePreviousSiblings() moves all siblings before aChild (i.e., aChild
   * won't be moved) to before aPointToInsert.GetChild().
   * See explanation of MoveChildrenBetween() for the detail of the behavior.
   *
   * @param aChild              The node which is next sibling of the last
   *                            node to be moved.
   * @param aPointToInsert      The insertion point.  The container must not
   *                            be a data node like a text node.
   * @param aError              The result.  If this succeeds to move children,
   *                            returns NS_OK.  Otherwise, an error.
   */
  void MovePreviousSiblings(nsIContent& aChild,
                            const EditorRawDOMPoint& aPointToInsert,
                            ErrorResult& aError);

  /**
   * MoveOneHardLineContents() moves the content in a hard line which contains
   * aPointInHardLine to aPointToInsert or end of aPointToInsert's container.
   *
   * @param aPointInHardLine            A point in a hard line.  All nodes in
   *                                    same hard line will be moved.
   * @param aPointToInsert              Point to insert contents of the hard
   *                                    line.
   * @param aMoveToEndOfContainer       If `Yes`, aPointToInsert.Offset() will
   *                                    be ignored and instead, all contents
   *                                    will be appended to the container of
   *                                    aPointToInsert.  The result may be
   *                                    different from setting this to `No`
   *                                    and aPointToInsert points end of the
   *                                    container because mutation event
   *                                    listeners may modify children of the
   *                                    container while we're moving nodes.
   */
  enum class MoveToEndOfContainer { Yes, No };
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT MoveNodeResult MoveOneHardLineContents(
      const EditorDOMPoint& aPointInHardLine,
      const EditorDOMPoint& aPointToInsert,
      MoveToEndOfContainer aMoveToEndOfContainer = MoveToEndOfContainer::No);

  /**
   * SplitNodeWithTransaction() creates a transaction to create a new node
   * (left node) identical to an existing node (right node), and split the
   * contents between the same point in both nodes, then, execute the
   * transaction.
   *
   * @param aStartOfRightNode   The point to split.  Its container will be
   *                            the right node, i.e., become the new node's
   *                            next sibling.  And the point will be start
   *                            of the right node.
   * @param aError              If succeed, returns no error.  Otherwise, an
   *                            error.
   */
  MOZ_CAN_RUN_SCRIPT already_AddRefed<nsIContent> SplitNodeWithTransaction(
      const EditorDOMPoint& aStartOfRightNode, ErrorResult& aResult);

  enum class SplitAtEdges {
    // SplitNodeDeepWithTransaction() won't split container element
    // nodes at their edges.  I.e., when split point is start or end of
    // container, it won't be split.
    eDoNotCreateEmptyContainer,
    // SplitNodeDeepWithTransaction() always splits containers even
    // if the split point is at edge of a container.  E.g., if split point is
    // start of an inline element, empty inline element is created as a new left
    // node.
    eAllowToCreateEmptyContainer,
  };

  /**
   * SplitNodeDeepWithTransaction() splits aMostAncestorToSplit deeply.
   *
   * @param aMostAncestorToSplit        The most ancestor node which should be
   *                                    split.
   * @param aStartOfDeepestRightNode    The start point of deepest right node.
   *                                    This point must be descendant of
   *                                    aMostAncestorToSplit.
   * @param aSplitAtEdges               Whether the caller allows this to
   *                                    create empty container element when
   *                                    split point is start or end of an
   *                                    element.
   * @return                            SplitPoint() returns split point in
   *                                    aMostAncestorToSplit.  The point must
   *                                    be good to insert something if the
   *                                    caller want to do it.
   */
  MOZ_CAN_RUN_SCRIPT SplitNodeResult
  SplitNodeDeepWithTransaction(nsIContent& aMostAncestorToSplit,
                               const EditorDOMPoint& aDeepestStartOfRightNode,
                               SplitAtEdges aSplitAtEdges);

  /**
   * JoinNodesDeepWithTransaction() joins aLeftNode and aRightNode "deeply".
   * First, they are joined simply, then, new right node is assumed as the
   * child at length of the left node before joined and new left node is
   * assumed as its previous sibling.  Then, they will be joined again.
   * And then, these steps are repeated.
   *
   * @param aLeftContent    The node which will be removed form the tree.
   * @param aRightContent   The node which will be inserted the contents of
   *                        aRightContent.
   * @return                The point of the first child of the last right node.
   *                        The result is always set if this succeeded.
   */
  MOZ_CAN_RUN_SCRIPT Result<EditorDOMPoint, nsresult>
  JoinNodesDeepWithTransaction(nsIContent& aLeftContent,
                               nsIContent& aRightContent);

  /**
   * TryToJoinBlocksWithTransaction() tries to join two block elements.  The
   * right element is always joined to the left element.  If the elements are
   * the same type and not nested within each other,
   * JoinEditableNodesWithTransaction() is called (example, joining two list
   * items together into one).  If the elements are not the same type, or one
   * is a descendant of the other, we instead destroy the right block placing
   * its children into leftblock.
   *
   * @return            Sets canceled to true if the operation should do
   *                    nothing anymore even if this doesn't join the blocks.
   *                    Sets handled to true if this actually handles the
   *                    request.  Note that this may set it to true even if this
   *                    does not join the block.  E.g., if the blocks shouldn't
   *                    be joined or it's impossible to join them but it's not
   *                    unexpected case, this returns true with this.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT EditActionResult
  TryToJoinBlocksWithTransaction(nsIContent& aLeftContentInBlock,
                                 nsIContent& aRightContentInBlock);

  /**
   * GetGoodCaretPointFor() returns a good point to collapse `Selection`
   * after handling edit action with aDirectionAndAmount.
   *
   * @param aContent            The content where you want to put caret
   *                            around.
   * @param aDirectionAndAmount Muse be one of eNext, eNextWord, eToEndOfLine,
   *                            ePrevious, ePreviousWord and eToBeggingOfLine.
   *                            Set the direction of handled edit action.
   */
  EditorDOMPoint GetGoodCaretPointFor(
      nsIContent& aContent, nsIEditor::EDirection aDirectionAndAmount);

  /**
   * RemoveEmptyInclusiveAncestorInlineElements() removes empty inclusive
   * ancestor inline elements in inclusive ancestor block element of aContent.
   *
   * @param aContent    Must be an empty content.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  RemoveEmptyInclusiveAncestorInlineElements(nsIContent& aContent);

  /**
   * MaybeDeleteTopMostEmptyAncestor() looks for top most empty block ancestor
   * of aStartContent in aEditingHostElement.
   * If found empty ancestor is a list item element, inserts a <br> element
   * before its parent element if grand parent is a list element.  Then,
   * collapse Selection to after the empty block.
   * If found empty ancestor is not a list item element, collapse Selection to
   * somewhere depending on aAction.
   * Finally, removes the empty block ancestor.
   *
   * @param aStartContent       Start content to look for empty ancestors.
   * @param aEditingHostElement Current editing host.
   * @param aDirectionAndAmount If found empty ancestor block is a list item
   *                            element, this is ignored.  Otherwise:
   *                            - If eNext, eNextWord or eToEndOfLine, collapse
   *                              Selection to after found empty ancestor.
   *                            - If ePrevious, ePreviousWord or
   *                              eToBeginningOfLine, collapse Selection to
   *                              end of previous editable node.
   *                            Otherwise, eNone is allowed but does nothing.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT EditActionResult
  MaybeDeleteTopMostEmptyAncestor(nsIContent& aStartContent,
                                  Element& aEditingHostElement,
                                  nsIEditor::EDirection aDirectionAndAmount);

  /**
   * GetRangeExtendedToIncludeInvisibleNodes() returns extended range.
   * If there are some invisible nodes around aAbstractRange, they may
   * be included.
   *
   * @param aAbstractRange      Original range.  This must not be collapsed
   *                            and must be positioned.
   * @return                    Extended range.
   */
  already_AddRefed<dom::StaticRange> GetRangeExtendedToIncludeInvisibleNodes(
      const dom::AbstractRange& aAbstractRange);

  /**
   * HandleDeleteCollapsedSelectionAtWhiteSpaces() handles deletion of
   * collapsed selection at whitespaces in a text node.
   *
   * @param aDirectionAndAmount Direction of the deletion.
   * @param aWSRunObjectAtCaret WSRunObject instance which was initialized with
   *                            the caret point.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT EditActionResult
  HandleDeleteCollapsedSelectionAtWhiteSpaces(
      nsIEditor::EDirection aDirectionAndAmount,
      WSRunObject& aWSRunObjectAtCaret);

  /**
   * HandleDeleteCollapsedSelectionAtTextNode() handles deletion of
   * collapsed selection in a text node.
   *
   * @param aDirectionAndAmount Direction of the deletion.
   * @param aPointToDelete      The point in a text node to delete character(s).
   *                            Caller must guarantee that this is in a text
   *                            node.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT EditActionResult
  HandleDeleteCollapsedSelectionAtTextNode(
      nsIEditor::EDirection aDirectionAndAmount,
      const EditorDOMPoint& aPointToDelete);

  /**
   * HandleDeleteCollapsedSelectionAtAtomicContent() handles deletion of
   * atomic elements like `<br>`, `<hr>`, `<img>`, `<input>`, etc and
   * data nodes except text node (e.g., comment node).
   * If aAtomicContent is a invisible `<br>` element, this will call
   * `WillDeleteSelection()` recursively after deleting it.
   *
   * @param aDirectionAndAmount Direction of the deletion.
   * @param aStripWrappers      Must be eStrip or eNoStrip.
   * @param aAtomicContent      The atomic content to be deleted.
   * @param aCaretPoint         The caret point (i.e., selection start or
   *                            end).
   * @param aWSRunScannerAtCaret WSRunScanner instance which was initialized
   *                             with the caret point.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT EditActionResult
  HandleDeleteCollapsedSelectionAtAtomicContent(
      nsIEditor::EDirection aDirectionAndAmount,
      nsIEditor::EStripWrappers aStripWrappers, nsIContent& aAtomicContent,
      const EditorDOMPoint& aCaretPoint, WSRunScanner& aWSRunScannerAtCaret);

  /**
   * HandleDeleteCollapsedSelectionAtOtherBlockBoundary() handles deletion at
   * other block boundary (i.e., immediately before or after a block).
   * If this does not join blocks, `WillDeleteSelection()` may be called
   * recursively.
   *
   * @param aDirectionAndAmount Direction of the deletion.
   * @param aStripWrappers      Must be eStrip or eNoStrip.
   * @param aOtherBlockElement  The block element which follows the caret or
   *                            is followed by caret.
   * @param aCaretPoint         The caret point (i.e., selection start or
   *                            end).
   * @param aWSRunScannerAtCaret WSRunScanner instance which was initialized
   *                             with the caret point.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT EditActionResult
  HandleDeleteCollapsedSelectionAtOtherBlockBoundary(
      nsIEditor::EDirection aDirectionAndAmount,
      nsIEditor::EStripWrappers aStripWrappers, Element& aOtherBlockElement,
      const EditorDOMPoint& aCaretPoint, WSRunScanner& aWSRunScannerAtCaret);

  /**
   * HandleDeleteCollapsedSelectionAtCurrentBlockBoundary() handles deletion
   * at current block boundary (i.e., at start or end of current block).
   *
   * @param aDirectionAndAmount         Direction of the deletion.
   * @param aCurrentBlockElement        The current block element.
   * @param aCaretPoint                 The caret point (i.e., selection start
   *                                    or end).
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT EditActionResult
  HandleDeleteCollapsedSelectionAtCurrentBlockBoundary(
      nsIEditor::EDirection aDirectionAndAmount, Element& aCurrentBlockElement,
      const EditorDOMPoint& aCaretPoint);

  /**
   * DeleteUnnecessaryNodesAndCollapseSelection() removes unnecessary nodes
   * around aSelectionStartPoint and aSelectionEndPoint.  Then, collapse
   * selection at aSelectionStartPoint or aSelectionEndPoint (depending on
   * aDirectionAndAmount).
   *
   * @param aDirectionAndAmount         Direction of the deletion.
   *                                    If nsIEditor::ePrevious, selection will
   *                                    be collapsed to aSelectionEndPoint.
   *                                    Otherwise, selection will be collapsed
   *                                    to aSelectionStartPoint.
   * @param aSelectionStartPoint        First selection range start after
   *                                    computing the deleting range.
   * @param aSelectionEndPoint          First selection range end after
   *                                    computing the deleting range.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  DeleteUnnecessaryNodesAndCollapseSelection(
      nsIEditor::EDirection aDirectionAndAmount,
      const EditorDOMPoint& aSelectionStartPoint,
      const EditorDOMPoint& aSelectionEndPoint);

  /**
   * HandleDeleteAroundCollapsedSelection() handles deletion with collapsed
   * `Selection`.  Callers must guarantee that this is called only when
   * `Selection` is collapsed.
   *
   * @param aDirectionAndAmount Direction of the deletion.
   * @param aStripWrappers      Must be eStrip or eNoStrip.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT EditActionResult
  HandleDeleteAroundCollapsedSelection(
      nsIEditor::EDirection aDirectionAndAmount,
      nsIEditor::EStripWrappers aStripWrappers);

  /**
   * HandleDeleteNonCollapsedSelection() handles deletion with non-collapsed
   * `Selection`.  Callers must guarantee that this is called only when
   * `Selection` is NOT collapsed.
   *
   * @param aDirectionAndAmount         Direction of the deletion.
   * @param aStripWrappers              Must be eStrip or eNoStrip.
   * @param aSelectionWasCollpased      If the caller extended `Selection`
   *                                    from collapsed, set this to `Yes`.
   *                                    Otherwise, i.e., `Selection` is not
   *                                    collapsed from the beginning, set
   *                                    this to `No`.
   */
  enum class SelectionWasCollapsed { Yes, No };
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT EditActionResult
  HandleDeleteNonCollapsedSelection(
      nsIEditor::EDirection aDirectionAndAmount,
      nsIEditor::EStripWrappers aStripWrappers,
      SelectionWasCollapsed aSelectionWasCollapsed);

  /**
   * DeleteElementsExceptTableRelatedElements() removes elements except
   * table related elements (except <table> itself) and their contents
   * from the DOM tree.
   *
   * @param aNode               If this is not a table related element, this
   *                            node will be removed from the DOM tree.
   *                            Otherwise, this method calls itself recursively
   *                            with its children.
   *
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  DeleteElementsExceptTableRelatedElements(nsINode& aNode);

  /**
   * HandleDeleteSelectionInternal() is a helper method of
   * HandleDeleteSelection().  This can be called recursively by the helper
   * methods.
   * NOTE: This method creates SelectionBatcher.  Therefore, each caller
   *       needs to check if the editor is still available even if this returns
   *       NS_OK.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT EditActionResult
  HandleDeleteSelectionInternal(nsIEditor::EDirection aDirectionAndAmount,
                                nsIEditor::EStripWrappers aStripWrappers);

  /**
   * This method handles "delete selection" commands.
   * NOTE: Don't call this method recursively from the helper methods since
   *       when nobody handled it without canceling and returing an error,
   *       this falls it back to `DeleteSelectionWithTransaction()`.
   *
   * @param aDirectionAndAmount Direction of the deletion.
   * @param aStripWrappers      Must be eStrip or eNoStrip.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT virtual EditActionResult
  HandleDeleteSelection(nsIEditor::EDirection aDirectionAndAmount,
                        nsIEditor::EStripWrappers aStripWrappers) final;

  /**
   * DeleteMostAncestorMailCiteElementIfEmpty() deletes most ancestor
   * mail cite element (`<blockquote type="cite">` or
   * `<span _moz_quote="true">`, the former can be created with middle click
   * paste with `Control` or `Command` even in the web) of aContent if it
   * becomes empty.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  DeleteMostAncestorMailCiteElementIfEmpty(nsIContent& aContent);

  /**
   * LiftUpListItemElement() moves aListItemElement outside its parent.
   * If it's in a middle of a list element, the parent list element is split
   * before aListItemElement.  Then, moves aListItemElement to before its
   * parent list element.  I.e., moves aListItemElement between the 2 list
   * elements if original parent was split.  Then, if new parent becomes not a
   * list element, the list item element is removed and its contents are moved
   * to where the list item element was.  If aListItemElement becomse not a
   * child of list element, its contents are unwrapped from aListItemElement.
   *
   * @param aListItemElement    Must be a <li>, <dt> or <dd> element.
   * @param aLiftUpFromAllParentListElements
   *                            If Yes, this method calls itself recursively
   *                            to unwrap the contents in aListItemElement
   *                            from any ancestor list elements.
   *                            XXX This checks only direct parent of list
   *                                elements.  Therefore, if a parent list
   *                                element in a list item element, the
   *                                list item element and its list element
   *                                won't be unwrapped.
   */
  enum class LiftUpFromAllParentListElements { Yes, No };
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult LiftUpListItemElement(
      dom::Element& aListItemElement,
      LiftUpFromAllParentListElements aLiftUpFromAllParentListElements);

  /**
   * DestroyListStructureRecursively() destroys the list structure of
   * aListElement recursively.
   * If aListElement has <li>, <dl> or <dt> as a child, the element is removed
   * but its descendants are moved to where the list item element was.
   * If aListElement has another <ul>, <ol> or <dl> as a child, this method is
   * called recursively.
   * If aListElement has other nodes as its child, they are just removed.
   * Finally, aListElement is removed. and its all children are moved to
   * where the aListElement was.
   *
   * @param aListElement        A <ul>, <ol> or <dl> element.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  DestroyListStructureRecursively(Element& aListElement);

  /**
   * RemoveListAtSelectionAsSubAction() removes list elements and list item
   * elements at Selection.  And move contents in them where the removed list
   * was.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult RemoveListAtSelectionAsSubAction();

  /**
   * ChangeMarginStart() changes margin of aElement to indent or outdent.
   * If it's rtl text, margin-right will be changed.  Otherwise, margin-left.
   * XXX This is not aware of vertical writing-mode.
   */
  enum class ChangeMargin { Increase, Decrease };
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  ChangeMarginStart(Element& aElement, ChangeMargin aChangeMargin);

  /**
   * HandleCSSIndentAtSelectionInternal() indents around Selection with CSS.
   * This method creates AutoSelectionRestorer.  Therefore, each caller
   * need to check if the editor is still available even if this returns
   * NS_OK.
   * NOTE: Use HandleCSSIndentAtSelection() instead.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  HandleCSSIndentAtSelectionInternal();

  /**
   * HandleHTMLIndentAtSelectionInternal() indents around Selection with HTML.
   * This method creates AutoSelectionRestorer.  Therefore, each caller
   * need to check if the editor is still available even if this returns
   * NS_OK.
   * NOTE: Use HandleHTMLIndentAtSelection() instead.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  HandleHTMLIndentAtSelectionInternal();

  /**
   * HandleCSSIndentAtSelection() indents around Selection with CSS.
   * NOTE: This is a helper method of `HandleIndentAtSelection()`.  If you
   *       want to call this directly, you should check whether you need
   *       do do something which `HandleIndentAtSelection()` does.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult HandleCSSIndentAtSelection();

  /**
   * HandleHTMLIndentAtSelection() indents around Selection with HTML.
   * NOTE: This is a helper method of `HandleIndentAtSelection()`.  If you
   *       want to call this directly, you should check whether you need
   *       do do something which `HandleIndentAtSelection()` does.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult HandleHTMLIndentAtSelection();

  /**
   * HandleIndentAtSelection() indents around Selection with HTML or CSS.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT EditActionResult HandleIndentAtSelection();

  /**
   * OutdentPartOfBlock() outdents the nodes between aStartOfOutdent and
   * aEndOfOutdent.  This splits the range off from aBlockElement first.
   * Then, removes the middle element if aIsBlockIndentedWithCSS is false.
   * Otherwise, decreases the margin of the middle element.
   *
   * @param aBlockElement       A block element which includes both
   *                            aStartOfOutdent and aEndOfOutdent.
   * @param aStartOfOutdent     First node which is descendant of
   *                            aBlockElement will be outdented.
   * @param aEndOfOutdent       Last node which is descandant of
   *                            aBlockElement will be outdented.
   * @param aBlockIndentedWith  `CSS` if aBlockElement is indented with
   *                            CSS margin property.
   *                            `HTML` if aBlockElement is `<blockquote>`
   *                            or something.
   * @return                    The left content is new created element
   *                            splitting before aStartOfOutdent.
   *                            The right content is existing element.
   *                            The middle content is outdented element
   *                            if aBlockIndentedWith is `CSS`.
   *                            Otherwise, nullptr.
   */
  enum class BlockIndentedWith { CSS, HTML };
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT SplitRangeOffFromNodeResult
  OutdentPartOfBlock(Element& aBlockElement, nsIContent& aStartOfOutdent,
                     nsIContent& aEndOutdent,
                     BlockIndentedWith aBlockIndentedWith);

  /**
   * HandleOutdentAtSelectionInternal() outdents contents around Selection.
   * This method creates AutoSelectionRestorer.  Therefore, each caller
   * needs to check if the editor is still available even if this returns
   * NS_OK.
   * NOTE: Call `HandleOutdentAtSelection()` instead.
   *
   * @return                    The left content is left content of last
   *                            outdented element.
   *                            The right content is right content of last
   *                            outdented element.
   *                            The middle content is middle content of last
   *                            outdented element.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT SplitRangeOffFromNodeResult
  HandleOutdentAtSelectionInternal();

  /**
   * HandleOutdentAtSelection() outdents contents around Selection.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT EditActionResult HandleOutdentAtSelection();

  /**
   * AlignBlockContentsWithDivElement() sets align attribute of <div> element
   * which is only child of aBlockElement to aAlignType.  If aBlockElement
   * has 2 or more children or does not have a `<div>` element, inserts a
   * new `<div>` element into aBlockElement and move all children of
   * aBlockElement into the new `<div>` element.
   *
   * @param aBlockElement       The element node whose contents should be
   *                            aligned to aAlignType.  This should be
   *                            an element which can have `<div>` element
   *                            as its child.
   * @param aAlignType          New value of align attribute of `<div>`
   *                            element.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult AlignBlockContentsWithDivElement(
      dom::Element& aBlockElement, const nsAString& aAlignType);

  /**
   * AlignContentsInAllTableCellsAndListItems() calls
   * AlignBlockContentsWithDivElement() for aligning contents in every list
   * item element and table cell element in aElement.
   *
   * @param aElement            The node which is or whose descendants should
   *                            be aligned to aAlignType.
   * @param aAlignType          New value of `align` attribute of `<div>`.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  AlignContentsInAllTableCellsAndListItems(dom::Element& aElement,
                                           const nsAString& aAlignType);

  /**
   * MakeTransitionList() detects all the transitions in the array, where a
   * transition means that adjacent nodes in the array don't have the same
   * parent.
   */
  static void MakeTransitionList(
      const nsTArray<OwningNonNull<nsIContent>>& aArrayOfContents,
      nsTArray<bool>& aTransitionArray);

  /**
   * EnsureHardLineBeginsWithFirstChildOf() inserts `<br>` element before
   * first child of aRemovingContainerElement if it will not be start of a
   * hard line after removing aRemovingContainerElement.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  EnsureHardLineBeginsWithFirstChildOf(dom::Element& aRemovingContainerElement);

  /**
   * EnsureHardLineEndsWithLastChildOf() inserts `<br>` element after last
   * child of aRemovingContainerElement if it will not be end of a hard line
   * after removing aRemovingContainerElement.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  EnsureHardLineEndsWithLastChildOf(dom::Element& aRemovingContainerElement);

  /**
   * RemoveAlignFromDescendants() removes align attributes, text-align
   * properties and <center> elements in aElement.
   *
   * @param aElement    Alignment information of the node and/or its
   *                    descendants will be removed.
   *                    NOTE: aElement must not be a `<table>` element.
   * @param aAlignType  New align value to be set only when it's in
   *                    CSS mode and this method meets <table> or <hr>.
   *                    XXX This is odd and not clear when you see caller of
   *                    this method.  Do you have better idea?
   * @param aEditTarget If `OnlyDescendantsExceptTable`, modifies only
   *                    descendants of aElement.
   *                    If `NodeAndDescendantsExceptTable`, modifies `aElement`
   *                    and its descendants.
   */
  enum class EditTarget {
    OnlyDescendantsExceptTable,
    NodeAndDescendantsExceptTable
  };
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult RemoveAlignFromDescendants(
      Element& aElement, const nsAString& aAlignType, EditTarget aEditTarget);

  /**
   * SetBlockElementAlign() resets `align` attribute, `text-align` property
   * of descendants of aBlockOrHRElement except `<table>` element descendants.
   * Then, set `align` attribute or `text-align` property of aBlockOrHRElement.
   *
   * @param aBlockOrHRElement   The element whose contents will be aligned.
   *                            This must be a block element or `<hr>` element.
   *                            If we're not in CSS mode, this element has
   *                            to support `align` attribute (i.e.,
   *                            `HTMLEditUtils::SupportsAlignAttr()` must
   *                            return true).
   * @param aAlignType          Boundary or "center" which contents should be
   *                            aligned on.
   * @param aEditTarget         If `OnlyDescendantsExceptTable`, modifies only
   *                            descendants of aBlockOrHRElement.
   *                            If `NodeAndDescendantsExceptTable`, modifies
   *                            aBlockOrHRElement and its descendants.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  SetBlockElementAlign(Element& aBlockOrHRElement, const nsAString& aAlignType,
                       EditTarget aEditTarget);

  /**
   * AlignContentsAtSelectionWithEmptyDivElement() inserts new `<div>` element
   * at `Selection` to align selected contents.  This returns as "handled"
   * if this modifies `Selection` so that callers shouldn't modify `Selection`
   * in such case especially when using AutoSelectionRestorer.
   *
   * @param aAlignType          New align attribute value where the contents
   *                            should be aligned to.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT EditActionResult
  AlignContentsAtSelectionWithEmptyDivElement(const nsAString& aAlignType);

  /**
   * AlignNodesAndDescendants() make contents of nodes in aArrayOfContents and
   * their descendants aligned to aAlignType.
   *
   * @param aAlignType          New align attribute value where the contents
   *                            should be aligned to.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult AlignNodesAndDescendants(
      nsTArray<OwningNonNull<nsIContent>>& aArrayOfContents,
      const nsAString& aAlignType);

  /**
   * AlignContentsAtSelection() aligns contents around Selection to aAlignType.
   * This creates AutoSelectionRestorer.  Therefore, even if this returns
   * NS_OK, we might have been destroyed.  So, every caller needs to check if
   * Destroyed() returns false before modifying the DOM tree or changing
   * Selection.
   * NOTE: Call AlignAsSubAction() instead.
   *
   * @param aAlignType          New align attribute value where the contents
   *                            should be aligned to.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  AlignContentsAtSelection(const nsAString& aAlignType);

  /**
   * AlignAsSubAction() handles "align" command with `Selection`.
   *
   * @param aAlignType          New align attribute value where the contents
   *                            should be aligned to.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT EditActionResult
  AlignAsSubAction(const nsAString& aAlignType);

  /**
   * StartOrEndOfSelectionRangesIsIn() returns true if start or end of one
   * of selection ranges is in aContent.
   */
  bool StartOrEndOfSelectionRangesIsIn(nsIContent& aContent) const;

  /**
   * FindNearEditableContent() tries to find an editable node near aPoint.
   *
   * @param aPoint      The DOM point where to start to search from.
   * @param aDirection  If nsIEditor::ePrevious is set, this searches an
   *                    editable node from next nodes.  Otherwise, from
   *                    previous nodes.
   * @return            If found, returns non-nullptr.  Otherwise, nullptr.
   *                    Note that if found node is in different table element,
   *                    this returns nullptr.
   *                    And also if aDirection is not nsIEditor::ePrevious,
   *                    the result may be the node pointed by aPoint.
   */
  template <typename PT, typename CT>
  nsIContent* FindNearEditableContent(const EditorDOMPointBase<PT, CT>& aPoint,
                                      nsIEditor::EDirection aDirection);

  /**
   * AdjustCaretPositionAndEnsurePaddingBRElement() may adjust caret
   * position to nearest editable content and if padding `<br>` element is
   * necessary at caret position, this creates it.
   *
   * @param aDirectionAndAmount Direction of the edit action.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  AdjustCaretPositionAndEnsurePaddingBRElement(
      nsIEditor::EDirection aDirectionAndAmount);

  /**
   * EnsureSelectionInBodyOrDocumentElement() collapse `Selection` to the
   * primary `<body>` element or document element when `Selection` crosses
   * `<body>` element's boundary.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  EnsureSelectionInBodyOrDocumentElement();

  /**
   * InsertBRElementToEmptyListItemsAndTableCellsInRange() inserts
   * `<br>` element into empty list item or table cell elements between
   * aStartRef and aEndRef.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  InsertBRElementToEmptyListItemsAndTableCellsInRange(
      const RawRangeBoundary& aStartRef, const RawRangeBoundary& aEndRef);

  /**
   * RemoveEmptyNodesIn() removes all empty nodes in aRange.  However, if
   * mail-cite node has only a `<br>` element, the node will be removed
   * but <br> element is moved to where the mail-cite node was.
   * XXX This method is expensive if aRange is too wide and may remove
   *     unexpected empty element, e.g., it was created by JS, but we haven't
   *     touched it.  Cannot we remove this method and make guarantee that
   *     empty nodes won't be created?
   *
   * @param aRange      Must be positioned.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult RemoveEmptyNodesIn(nsRange& aRange);

  /**
   * SetSelectionInterlinePosition() may set interline position if caret is
   * positioned around `<br>` or block boundary.  Don't call this when
   * `Selection` is not collapsed.
   */
  void SetSelectionInterlinePosition();

  /**
   * EnsureSelectionInBlockElement() may move caret into aElement or its
   * parent block if caret is outside of them.  Don't call this when
   * `Selection` is not collapsed.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  EnsureCaretInBlockElement(dom::Element& aElement);

  /**
   * Called by `HTMLEditor::OnEndHandlingTopLevelEditSubAction()`.  This may
   * adjust Selection, remove unnecessary empty nodes, create `<br>` elements
   * if needed, etc.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  OnEndHandlingTopLevelEditSubActionInternal();

  /**
   * MoveSelectedContentsToDivElementToMakeItAbsolutePosition() looks for
   * a `<div>` element in selection first.  If not, creates new `<div>`
   * element.  Then, move all selected contents into the target `<div>`
   * element.
   * Note that this creates AutoSelectionRestorer.  Therefore, callers need
   * to check whether we have been destroyed even when this returns NS_OK.
   *
   * @param aTargetElement      Returns target `<div>` element which should be
   *                            changed to absolute positioned.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  MoveSelectedContentsToDivElementToMakeItAbsolutePosition(
      RefPtr<Element>* aTargetElement);

  /**
   * SetSelectionToAbsoluteAsSubAction() move selected contents to first
   * selected `<div>` element or newly created `<div>` element and make
   * the `<div>` element positioned absolutely.
   * mNewBlockElement of TopLevelEditSubActionData will be set to the `<div>`
   * element.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT EditActionResult
  SetSelectionToAbsoluteAsSubAction();

  /**
   * SetSelectionToStaticAsSubAction() sets the `position` property of a
   * selection parent's block whose `position` is `absolute` to `static`.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT EditActionResult
  SetSelectionToStaticAsSubAction();

  /**
   * AddZIndexAsSubAction() adds aChange to `z-index` of nearest parent
   * absolute-positioned element from current selection.
   *
   * @param aChange     Amount to change `z-index`.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT EditActionResult
  AddZIndexAsSubAction(int32_t aChange);

  /**
   * OnDocumentModified() is called when editor content is changed.
   */
  MOZ_CAN_RUN_SCRIPT nsresult OnDocumentModified();

 protected:  // Called by helper classes.
  MOZ_CAN_RUN_SCRIPT virtual void OnStartToHandleTopLevelEditSubAction(
      EditSubAction aTopLevelEditSubAction,
      nsIEditor::EDirection aDirectionOfTopLevelEditSubAction,
      ErrorResult& aRv) override;
  MOZ_CAN_RUN_SCRIPT virtual nsresult OnEndHandlingTopLevelEditSubAction()
      override;

 protected:  // Shouldn't be used by friend classes
  virtual ~HTMLEditor();

  template <typename PT, typename CT>
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT MOZ_NEVER_INLINE_DEBUG nsresult
  CollapseSelectionTo(const EditorDOMPointBase<PT, CT>& aPoint) {
    ErrorResult error;
    CollapseSelectionTo(aPoint, error);
    return error.StealNSResult();
  }

  template <typename PT, typename CT>
  MOZ_CAN_RUN_SCRIPT MOZ_NEVER_INLINE_DEBUG void CollapseSelectionTo(
      const EditorDOMPointBase<PT, CT>& aPoint, ErrorResult& aRv) {
    MOZ_ASSERT(IsEditActionDataAvailable());
    MOZ_ASSERT(!aRv.Failed());

    SelectionRefPtr()->Collapse(aPoint, aRv);
    if (NS_WARN_IF(Destroyed())) {
      aRv = NS_ERROR_EDITOR_DESTROYED;
      return;
    }
    NS_WARNING_ASSERTION(!aRv.Failed(), "Selection::Collapse() failed");
  }

  [[nodiscard]] MOZ_CAN_RUN_SCRIPT MOZ_NEVER_INLINE_DEBUG nsresult
  CollapseSelectionToStartOf(nsINode& aNode) {
    return CollapseSelectionTo(EditorRawDOMPoint(&aNode, 0));
  }

  MOZ_CAN_RUN_SCRIPT MOZ_NEVER_INLINE_DEBUG void CollapseSelectionToStartOf(
      nsINode& aNode, ErrorResult& aRv) {
    CollapseSelectionTo(EditorRawDOMPoint(&aNode, 0), aRv);
  }

  /**
   * InitEditorContentAndSelection() may insert `<br>` elements and padding
   * `<br>` elements if they are required for `<body>` or document element.
   * And collapse selection at the end if there is no selection ranges.
   * XXX I think that this should work with active editing host unless
   *     all over the document is ediable (i.e., in design mode or `<body>`
   *     or `<html>` has `contenteditable` attribute).
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult InitEditorContentAndSelection();

  MOZ_CAN_RUN_SCRIPT virtual nsresult SelectAllInternal() override;

  /**
   * SelectContentInternal() sets Selection to aContentToSelect to
   * aContentToSelect + 1 in parent of aContentToSelect.
   *
   * @param aContentToSelect    The content which should be selected.
   */
  MOZ_CAN_RUN_SCRIPT nsresult
  SelectContentInternal(nsIContent& aContentToSelect);

  /**
   * CollapseSelectionAfter() collapses Selection after aElement.
   * If aElement is an orphan node or not in editing host, returns error.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  CollapseSelectionAfter(Element& aElement);

  /**
   * GetInclusiveAncestorByTagNameAtSelection() looks for an element node whose
   * name matches aTagName from anchor node of Selection to <body> element.
   *
   * @param aTagName        The tag name which you want to look for.
   *                        Must not be nsGkAtoms::_empty.
   *                        If nsGkAtoms::list, the result may be <ul>, <ol> or
   *                        <dl> element.
   *                        If nsGkAtoms::td, the result may be <td> or <th>.
   *                        If nsGkAtoms::href, the result may be <a> element
   *                        which has "href" attribute with non-empty value.
   *                        If nsGkAtoms::anchor, the result may be <a> which
   *                        has "name" attribute with non-empty value.
   * @return                If an element which matches aTagName, returns
   *                        an Element.  Otherwise, nullptr.
   */
  Element* GetInclusiveAncestorByTagNameAtSelection(
      const nsStaticAtom& aTagName) const;

  /**
   * GetInclusiveAncestorByTagNameInternal() looks for an element node whose
   * name matches aTagName from aNode to <body> element.
   *
   * @param aTagName        The tag name which you want to look for.
   *                        Must not be nsGkAtoms::_empty.
   *                        If nsGkAtoms::list, the result may be <ul>, <ol> or
   *                        <dl> element.
   *                        If nsGkAtoms::td, the result may be <td> or <th>.
   *                        If nsGkAtoms::href, the result may be <a> element
   *                        which has "href" attribute with non-empty value.
   *                        If nsGkAtoms::anchor, the result may be <a> which
   *                        has "name" attribute with non-empty value.
   * @param aContent        Start node to look for the element.  This should
   *                        not be an orphan node.
   * @return                If an element which matches aTagName, returns
   *                        an Element.  Otherwise, nullptr.
   */
  Element* GetInclusiveAncestorByTagNameInternal(const nsStaticAtom& aTagName,
                                                 nsIContent& aContent) const;

  /**
   * GetSelectedElement() returns a "selected" element node.  "selected" means:
   * - there is only one selection range
   * - the range starts from an element node or in an element
   * - the range ends at immediately after same element
   * - and the range does not include any other element nodes.
   * Additionally, only when aTagName is nsGkAtoms::href, this thinks that an
   * <a> element which has non-empty "href" attribute includes the range, the
   * <a> element is selected.
   *
   * NOTE: This method is implementation of nsIHTMLEditor.getSelectedElement()
   * and comm-central depends on this behavior.  Therefore, if you need to use
   * this method internally but you need to change, perhaps, you should create
   * another method for avoiding breakage of comm-central apps.
   *
   * @param aTagName    The atom of tag name in lower case.  Set this to
   *                    result  of EditorUtils::GetTagNameAtom() if you have a
   *                    tag name with nsString.
   *                    If nullptr, this returns any element node or nullptr.
   *                    If nsGkAtoms::href, this returns an <a> element which
   *                    has non-empty "href" attribute or nullptr.
   *                    If nsGkAtoms::anchor, this returns an <a> element which
   *                    has non-empty "name" attribute or nullptr.
   *                    Otherwise, returns an element node whose name is
   *                    same as aTagName or nullptr.
   * @param aRv         Returns error code.
   * @return            A "selected" element.
   */
  already_AddRefed<Element> GetSelectedElement(const nsAtom* aTagName,
                                               ErrorResult& aRv);

  /**
   * GetFirstTableRowElement() returns the first <tr> element in the most
   * nearest ancestor of aTableOrElementInTable or itself.
   *
   * @param aTableOrElementInTable      <table> element or another element.
   *                                    If this is a <table> element, returns
   *                                    first <tr> element in it.  Otherwise,
   *                                    returns first <tr> element in nearest
   *                                    ancestor <table> element.
   * @param aRv                         Returns an error code.  When
   *                                    aTableOrElementInTable is neither
   *                                    <table> nor in a <table> element,
   *                                    returns NS_ERROR_FAILURE.
   *                                    However, if <table> does not have
   *                                    <tr> element, returns NS_OK.
   */
  Element* GetFirstTableRowElement(Element& aTableOrElementInTable,
                                   ErrorResult& aRv) const;

  /**
   * GetNextTableRowElement() returns next <tr> element of aTableRowElement.
   * This won't cross <table> element boundary but may cross table section
   * elements like <tbody>.
   *
   * @param aTableRowElement    A <tr> element.
   * @param aRv                 Returns error.  If given element is <tr> but
   *                            there is no next <tr> element, this returns
   *                            nullptr but does not return error.
   */
  Element* GetNextTableRowElement(Element& aTableRowElement,
                                  ErrorResult& aRv) const;

  struct CellAndIndexes;
  struct CellData;

  /**
   * CellIndexes store both row index and column index of a table cell.
   */
  struct MOZ_STACK_CLASS CellIndexes final {
    int32_t mRow;
    int32_t mColumn;

    /**
     * This constructor initializes mRowIndex and mColumnIndex with indexes of
     * aCellElement.
     *
     * @param aCellElement      An <td> or <th> element.
     * @param aRv               Returns error if layout information is not
     *                          available or given element is not a table cell.
     */
    MOZ_CAN_RUN_SCRIPT CellIndexes(Element& aCellElement, PresShell* aPresShell,
                                   ErrorResult& aRv)
        : mRow(-1), mColumn(-1) {
      MOZ_ASSERT(!aRv.Failed());
      Update(aCellElement, aPresShell, aRv);
    }

    /**
     * Update mRowIndex and mColumnIndex with indexes of aCellElement.
     *
     * @param                   See above.
     */
    MOZ_CAN_RUN_SCRIPT void Update(Element& aCellElement, PresShell* aPresShell,
                                   ErrorResult& aRv);

    /**
     * This constructor initializes mRowIndex and mColumnIndex with indexes of
     * cell element which contains anchor of Selection.
     *
     * @param aHTMLEditor       The editor which creates the instance.
     * @param aSelection        The Selection for the editor.
     * @param aRv               Returns error if there is no cell element
     *                          which contains anchor of Selection, or layout
     *                          information is not available.
     */
    MOZ_CAN_RUN_SCRIPT CellIndexes(HTMLEditor& aHTMLEditor,
                                   Selection& aSelection, ErrorResult& aRv)
        : mRow(-1), mColumn(-1) {
      Update(aHTMLEditor, aSelection, aRv);
    }

    /**
     * Update mRowIndex and mColumnIndex with indexes of cell element which
     * contains anchor of Selection.
     *
     * @param                   See above.
     */
    MOZ_CAN_RUN_SCRIPT void Update(HTMLEditor& aHTMLEditor,
                                   Selection& aSelection, ErrorResult& aRv);

    bool operator==(const CellIndexes& aOther) const {
      return mRow == aOther.mRow && mColumn == aOther.mColumn;
    }
    bool operator!=(const CellIndexes& aOther) const {
      return mRow != aOther.mRow || mColumn != aOther.mColumn;
    }

   private:
    CellIndexes() : mRow(-1), mColumn(-1) {}

    friend struct CellAndIndexes;
    friend struct CellData;
  };

  struct MOZ_STACK_CLASS CellAndIndexes final {
    RefPtr<Element> mElement;
    CellIndexes mIndexes;

    /**
     * This constructor initializes the members with cell element which is
     * selected by first range of the Selection.  Note that even if the
     * first range is in the cell element, this does not treat it as the
     * cell element is selected.
     */
    MOZ_CAN_RUN_SCRIPT CellAndIndexes(HTMLEditor& aHTMLEditor,
                                      Selection& aSelection, ErrorResult& aRv) {
      Update(aHTMLEditor, aSelection, aRv);
    }

    /**
     * Update mElement and mIndexes with cell element which is selected by
     * first range of the Selection.  Note that even if the first range is
     * in the cell element, this does not treat it as the cell element is
     * selected.
     */
    MOZ_CAN_RUN_SCRIPT void Update(HTMLEditor& aHTMLEditor,
                                   Selection& aSelection, ErrorResult& aRv);
  };

  struct MOZ_STACK_CLASS CellData final {
    RefPtr<Element> mElement;
    // Current indexes which this is initialized with.
    CellIndexes mCurrent;
    // First column/row indexes of the cell.  When current position is spanned
    // from other column/row, this value becomes different from mCurrent.
    CellIndexes mFirst;
    // Computed rowspan/colspan values which are specified to the cell.
    // Note that if the cell has larger rowspan/colspan value than actual
    // table size, these values are the larger values.
    int32_t mRowSpan;
    int32_t mColSpan;
    // Effective rowspan/colspan value at the index.  For example, if first
    // cell element in first row has rowspan="3", then, if this is initialized
    // with 0-0 indexes, effective rowspan is 3.  However, if this is
    // initialized with 1-0 indexes, effective rowspan is 2.
    int32_t mEffectiveRowSpan;
    int32_t mEffectiveColSpan;
    // mIsSelected is set to true if mElement itself or its parent <tr> or
    // <table> is selected.  Otherwise, e.g., the cell just contains selection
    // range, this is set to false.
    bool mIsSelected;

    CellData()
        : mRowSpan(-1),
          mColSpan(-1),
          mEffectiveRowSpan(-1),
          mEffectiveColSpan(-1),
          mIsSelected(false) {}

    /**
     * Those constructors initializes the members with a <table> element and
     * both row and column index to specify a cell element.
     */
    CellData(HTMLEditor& aHTMLEditor, Element& aTableElement, int32_t aRowIndex,
             int32_t aColumnIndex, ErrorResult& aRv) {
      Update(aHTMLEditor, aTableElement, aRowIndex, aColumnIndex, aRv);
    }

    CellData(HTMLEditor& aHTMLEditor, Element& aTableElement,
             const CellIndexes& aIndexes, ErrorResult& aRv) {
      Update(aHTMLEditor, aTableElement, aIndexes, aRv);
    }

    /**
     * Those Update() methods updates the members with a <table> element and
     * both row and column index to specify a cell element.
     */
    void Update(HTMLEditor& aHTMLEditor, Element& aTableElement,
                int32_t aRowIndex, int32_t aColumnIndex, ErrorResult& aRv) {
      mCurrent.mRow = aRowIndex;
      mCurrent.mColumn = aColumnIndex;
      Update(aHTMLEditor, aTableElement, aRv);
    }

    void Update(HTMLEditor& aHTMLEditor, Element& aTableElement,
                const CellIndexes& aIndexes, ErrorResult& aRv) {
      mCurrent = aIndexes;
      Update(aHTMLEditor, aTableElement, aRv);
    }

    void Update(HTMLEditor& aHTMLEditor, Element& aTableElement,
                ErrorResult& aRv);

    /**
     * FailedOrNotFound() returns true if this failed to initialize/update
     * or succeeded but found no cell element.
     */
    bool FailedOrNotFound() const { return !mElement; }

    /**
     * IsSpannedFromOtherRowOrColumn(), IsSpannedFromOtherColumn and
     * IsSpannedFromOtherRow() return true if there is no cell element
     * at the index because of spanning from other row and/or column.
     */
    bool IsSpannedFromOtherRowOrColumn() const {
      return mElement && mCurrent != mFirst;
    }
    bool IsSpannedFromOtherColumn() const {
      return mElement && mCurrent.mColumn != mFirst.mColumn;
    }
    bool IsSpannedFromOtherRow() const {
      return mElement && mCurrent.mRow != mFirst.mRow;
    }

    /**
     * NextColumnIndex() and NextRowIndex() return column/row index of
     * next cell.  Note that this does not check whether there is next
     * cell or not actually.
     */
    int32_t NextColumnIndex() const {
      if (NS_WARN_IF(FailedOrNotFound())) {
        return -1;
      }
      return mCurrent.mColumn + mEffectiveColSpan;
    }
    int32_t NextRowIndex() const {
      if (NS_WARN_IF(FailedOrNotFound())) {
        return -1;
      }
      return mCurrent.mRow + mEffectiveRowSpan;
    }

    /**
     * LastColumnIndex() and LastRowIndex() return column/row index of
     * column/row which is spanned by the cell.
     */
    int32_t LastColumnIndex() const {
      if (NS_WARN_IF(FailedOrNotFound())) {
        return -1;
      }
      return NextColumnIndex() - 1;
    }
    int32_t LastRowIndex() const {
      if (NS_WARN_IF(FailedOrNotFound())) {
        return -1;
      }
      return NextRowIndex() - 1;
    }

    /**
     * NumberOfPrecedingColmuns() and NumberOfPrecedingRows() return number of
     * preceding columns/rows if current index is spanned from other column/row.
     * Otherwise, i.e., current point is not spanned form other column/row,
     * returns 0.
     */
    int32_t NumberOfPrecedingColmuns() const {
      if (NS_WARN_IF(FailedOrNotFound())) {
        return -1;
      }
      return mCurrent.mColumn - mFirst.mColumn;
    }
    int32_t NumberOfPrecedingRows() const {
      if (NS_WARN_IF(FailedOrNotFound())) {
        return -1;
      }
      return mCurrent.mRow - mFirst.mRow;
    }

    /**
     * NumberOfFollowingColumns() and NumberOfFollowingRows() return
     * number of remaining columns/rows if the cell spans to other
     * column/row.
     */
    int32_t NumberOfFollowingColumns() const {
      if (NS_WARN_IF(FailedOrNotFound())) {
        return -1;
      }
      return mEffectiveColSpan - 1;
    }
    int32_t NumberOfFollowingRows() const {
      if (NS_WARN_IF(FailedOrNotFound())) {
        return -1;
      }
      return mEffectiveRowSpan - 1;
    }
  };

  /**
   * TableSize stores and computes number of rows and columns of a <table>
   * element.
   */
  struct MOZ_STACK_CLASS TableSize final {
    int32_t mRowCount;
    int32_t mColumnCount;

    /**
     * @param aHTMLEditor               The editor which creates the instance.
     * @param aTableOrElementInTable    If a <table> element, computes number
     *                                  of rows and columns of it.
     *                                  If another element in a <table> element,
     *                                  computes number of rows and columns
     *                                  of nearest ancestor <table> element.
     *                                  Otherwise, i.e., non-<table> element
     *                                  not in <table>, returns error.
     * @param aRv                       Returns error if the element is not
     *                                  in <table> or layout information is
     *                                  not available.
     */
    TableSize(HTMLEditor& aHTMLEditor, Element& aTableOrElementInTable,
              ErrorResult& aRv)
        : mRowCount(-1), mColumnCount(-1) {
      MOZ_ASSERT(!aRv.Failed());
      Update(aHTMLEditor, aTableOrElementInTable, aRv);
    }

    /**
     * Update mRowCount and mColumnCount for aTableOrElementInTable.
     * See above for the detail.
     */
    void Update(HTMLEditor& aHTMLEditor, Element& aTableOrElementInTable,
                ErrorResult& aRv);

    bool IsEmpty() const { return !mRowCount || !mColumnCount; }
  };

  /**
   * GetTableCellElementAt() returns a <td> or <th> element of aTableElement
   * if there is a cell at the indexes.
   *
   * @param aTableElement       Must be a <table> element.
   * @param aCellIndexes        Indexes of cell which you want.
   *                            If rowspan and/or colspan is specified 2 or
   *                            larger, any indexes are allowed to retrieve
   *                            the cell in the area.
   * @return                    The cell element if there is in the <table>.
   *                            Returns nullptr without error if the indexes
   *                            are out of bounds.
   */
  Element* GetTableCellElementAt(Element& aTableElement,
                                 const CellIndexes& aCellIndexes) const {
    return GetTableCellElementAt(aTableElement, aCellIndexes.mRow,
                                 aCellIndexes.mColumn);
  }
  Element* GetTableCellElementAt(Element& aTableElement, int32_t aRowIndex,
                                 int32_t aColumnIndex) const;

  /**
   * GetSelectedOrParentTableElement() returns <td>, <th>, <tr> or <table>
   * element:
   *   #1 if the first selection range selects a cell, returns it.
   *   #2 if the first selection range does not select a cell and
   *      the selection anchor refers a <table>, returns it.
   *   #3 if the first selection range does not select a cell and
   *      the selection anchor refers a <tr>, returns it.
   *   #4 if the first selection range does not select a cell and
   *      the selection anchor refers a <td>, returns it.
   *   #5 otherwise, nearest ancestor <td> or <th> element of the
   *      selection anchor if there is.
   * In #1 and #4, *aIsCellSelected will be set to true (i.e,, when
   * a selection range selects a cell element).
   */
  already_AddRefed<Element> GetSelectedOrParentTableElement(
      ErrorResult& aRv, bool* aIsCellSelected = nullptr) const;

  /**
   * PasteInternal() pasts text with replacing selected content.
   * This tries to dispatch ePaste event first.  If its defaultPrevent() is
   * called, this does nothing but returns NS_OK.
   *
   * @param aClipboardType      nsIClipboard::kGlobalClipboard or
   *                            nsIClipboard::kSelectionClipboard.
   */
  MOZ_CAN_RUN_SCRIPT nsresult PasteInternal(int32_t aClipboardType);

  /**
   * InsertWithQuotationsAsSubAction() inserts aQuotedText with appending ">"
   * to start of every line.
   *
   * @param aQuotedText         String to insert.  This will be quoted by ">"
   *                            automatically.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT virtual nsresult
  InsertWithQuotationsAsSubAction(const nsAString& aQuotedText) final;

  /**
   * InsertAsCitedQuotationInternal() inserts a <blockquote> element whose
   * cite attribute is aCitation and whose content is aQuotedText.
   * Note that this shouldn't be called when IsPlaintextEditor() is true.
   *
   * @param aQuotedText     HTML source if aInsertHTML is true.  Otherwise,
   *                        plain text.  This is inserted into new <blockquote>
   *                        element.
   * @param aCitation       cite attribute value of new <blockquote> element.
   * @param aInsertHTML     true if aQuotedText should be treated as HTML
   *                        source.
   *                        false if aQuotedText should be treated as plain
   *                        text.
   * @param aNodeInserted   [OUT] The new <blockquote> element.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult InsertAsCitedQuotationInternal(
      const nsAString& aQuotedText, const nsAString& aCitation,
      bool aInsertHTML, nsINode** aNodeInserted);

  /**
   * InsertNodeIntoProperAncestorWithTransaction() attempts to insert aNode
   * into the document, at aPointToInsert.  Checks with strict dtd to see if
   * containment is allowed.  If not allowed, will attempt to find a parent
   * in the parent hierarchy of aPointToInsert.GetContainer() that will accept
   * aNode as a child.  If such a parent is found, will split the document
   * tree from aPointToInsert up to parent, and then insert aNode.
   * aPointToInsert is then adjusted to point to the actual location that
   * aNode was inserted at.  aSplitAtEdges specifies if the splitting process
   * is allowed to result in empty nodes.
   *
   * @param aNode             Node to insert.
   * @param aPointToInsert    Insertion point.
   * @param aSplitAtEdges     Splitting can result in empty nodes?
   * @return                  Returns inserted point if succeeded.
   *                          Otherwise, the result is not set.
   */
  MOZ_CAN_RUN_SCRIPT EditorDOMPoint InsertNodeIntoProperAncestorWithTransaction(
      nsIContent& aNode, const EditorDOMPoint& aPointToInsert,
      SplitAtEdges aSplitAtEdges);

  /**
   * InsertBRElementAtSelectionWithTransaction() inserts a new <br> element at
   * selection.  If there is non-collapsed selection ranges, the selected
   * ranges is deleted first.
   */
  MOZ_CAN_RUN_SCRIPT nsresult InsertBRElementAtSelectionWithTransaction();

  /**
   * InsertTextWithQuotationsInternal() replaces selection with new content.
   * First, this method splits aStringToInsert to multiple chunks which start
   * with non-linebreaker except first chunk and end with a linebreaker except
   * last chunk.  Then, each chunk starting with ">" is inserted after wrapping
   * with <span _moz_quote="true">, and each chunk not starting with ">" is
   * inserted as normal text.
   */
  MOZ_CAN_RUN_SCRIPT nsresult
  InsertTextWithQuotationsInternal(const nsAString& aStringToInsert);

  /**
   * ReplaceContainerWithTransactionInternal() is implementation of
   * ReplaceContainerWithTransaction() and
   * ReplaceContainerAndCloneAttributesWithTransaction().
   *
   * @param aOldContainer       The element which will be replaced with new
   *                            element.
   * @param aTagName            The name of new element node.
   * @param aAttribute          Attribute name which will be set to the new
   *                            element.  This will be ignored if
   *                            aCloneAllAttributes is set to true.
   * @param aAttributeValue     Attribute value which will be set to
   *                            aAttribute.
   * @param aCloneAllAttributes If true, all attributes of aOldContainer will
   *                            be copied to the new element.
   */
  MOZ_CAN_RUN_SCRIPT already_AddRefed<Element>
  ReplaceContainerWithTransactionInternal(Element& aElement, nsAtom& aTagName,
                                          nsAtom& aAttribute,
                                          const nsAString& aAttributeValue,
                                          bool aCloneAllAttributes);

  /**
   * InsertContainerWithTransactionInternal() creates new element whose name is
   * aTagName, moves aContent into the new element, then, inserts the new
   * element into where aContent was.  If aAttribute is not nsGkAtoms::_empty,
   * aAttribute of the new element will be set to aAttributeValue.
   *
   * @param aContent            The content which will be wrapped with new
   *                            element.
   * @param aTagName            Element name of new element which will wrap
   *                            aContent and be inserted into where aContent
   *                            was.
   * @param aAttribute          Attribute which should be set to the new
   *                            element.  If this is nsGkAtoms::_empty,
   *                            this does not set any attributes to the new
   *                            element.
   * @param aAttributeValue     Value to be set to aAttribute.
   * @return                    The new element.
   */
  MOZ_CAN_RUN_SCRIPT already_AddRefed<Element>
  InsertContainerWithTransactionInternal(nsIContent& aContent, nsAtom& aTagName,
                                         nsAtom& aAttribute,
                                         const nsAString& aAttributeValue);

  /**
   * DeleteSelectionAndCreateElement() creates a element whose name is aTag.
   * And insert it into the DOM tree after removing the selected content.
   *
   * @param aTag                The element name to be created.
   * @return                    Created new element.
   */
  MOZ_CAN_RUN_SCRIPT already_AddRefed<Element> DeleteSelectionAndCreateElement(
      nsAtom& aTag);

  /**
   * This method first deletes the selection, if it's not collapsed.  Then if
   * the selection lies in a CharacterData node, it splits it.  If the
   * selection is at this point collapsed in a CharacterData node, it's
   * adjusted to be collapsed right before or after the node instead (which is
   * always possible, since the node was split).
   */
  MOZ_CAN_RUN_SCRIPT nsresult DeleteSelectionAndPrepareToCreateNode();

  /**
   * PrepareToInsertBRElement() returns a point where new <br> element should
   * be inserted.  If aPointToInsert points middle of a text node, this method
   * splits the text node and returns the point before right node.
   *
   * @param aPointToInsert      Candidate point to insert new <br> element.
   * @return                    Computed point to insert new <br> element.
   *                            If something failed, this is unset.
   */
  MOZ_CAN_RUN_SCRIPT EditorDOMPoint
  PrepareToInsertBRElement(const EditorDOMPoint& aPointToInsert);

  /**
   * IndentAsSubAction() indents the content around Selection.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT EditActionResult IndentAsSubAction();

  /**
   * OutdentAsSubAction() outdents the content around Selection.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT EditActionResult OutdentAsSubAction();

  MOZ_CAN_RUN_SCRIPT nsresult LoadHTML(const nsAString& aInputString);

  /**
   * SetInlinePropertyInternal() stores new style with `mTypeInState` if
   * `Selection` is collapsed.  Otherwise, applying the style at all selection
   * ranges.
   *
   * @param aProperty           One of the presentation tag names which we
   *                            support in style editor.
   * @param aAttribute          For some aProperty values, needs to be set to
   *                            its attribute name.  Otherwise, nullptr.
   * @param aAttributeValue     The value of aAttribute.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult SetInlinePropertyInternal(
      nsAtom& aProperty, nsAtom* aAttribute, const nsAString& aValue);

  /**
   * RemoveInlinePropertyInternal() removes specified style from `mTypeInState`
   * if `Selection` is collapsed.  Otherwise, removing the style.
   *
   * @param aHTMLProperty       nullptr if you want to remove all inline styles.
   *                            Otherwise, one of the presentation tag names
   *                            which we support in style editor.
   * @param aAttribute          For some aHTMLProperty values, need to be set to
   *                            its attribute name.  Otherwise, nullptr.
   * @param aRemoveRelatedElements      If Yes, this method removes different
   *                                    name's elements in the block if
   *                                    necessary.  For example, if
   *                                    aHTMLProperty is nsGkAtoms::b,
   *                                    `<strong>` elements are also removed.
   */
  enum class RemoveRelatedElements { Yes, No };
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult RemoveInlinePropertyInternal(
      nsStaticAtom* aHTMLProperty, nsStaticAtom* aAttribute,
      RemoveRelatedElements aRemoveRelatedElements);

  /**
   * ReplaceHeadContentsWithSourceWithTransaction() replaces all children of
   * <head> element with given source code.  This is undoable.
   *
   * @param aSourceToInsert     HTML source fragment to replace the children
   *                            of <head> element.
   */
  MOZ_CAN_RUN_SCRIPT nsresult ReplaceHeadContentsWithSourceWithTransaction(
      const nsAString& aSourceToInsert);

  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult GetCSSBackgroundColorState(
      bool* aMixed, nsAString& aOutColor, bool aBlockLevel);
  nsresult GetHTMLBackgroundColorState(bool* aMixed, nsAString& outColor);

  nsresult GetLastCellInRow(nsINode* aRowNode, nsINode** aCellNode);

  /**
   * This sets background on the appropriate container element (table, cell,)
   * or calls into nsTextEditor to set the page background.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  SetCSSBackgroundColorWithTransaction(const nsAString& aColor);
  MOZ_CAN_RUN_SCRIPT nsresult
  SetHTMLBackgroundColorWithTransaction(const nsAString& aColor);

  MOZ_CAN_RUN_SCRIPT_BOUNDARY virtual void InitializeSelectionAncestorLimit(
      nsIContent& aAncestorLimit) override;

  /**
   * Make the given selection span the entire document.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT virtual nsresult SelectEntireDocument()
      override;

  /**
   * Use this to assure that selection is set after attribute nodes when
   * trying to collapse selection at begining of a block node
   * e.g., when setting at beginning of a table cell
   * This will stop at a table, however, since we don't want to
   * "drill down" into nested tables.
   */
  MOZ_CAN_RUN_SCRIPT void CollapseSelectionToDeepestNonTableFirstChild(
      nsINode* aNode);
  /**
   * MaybeCollapseSelectionAtFirstEditableNode() may collapse selection at
   * proper position to staring to edit.  If there is a non-editable node
   * before any editable text nodes or inline elements which can have text
   * nodes as their children, collapse selection at start of the editing
   * host.  If there is an editable text node which is not collapsed, collapses
   * selection at the start of the text node.  If there is an editable inline
   * element which cannot have text nodes as its child, collapses selection at
   * before the element node.  Otherwise, collapses selection at start of the
   * editing host.
   *
   * @param aIgnoreIfSelectionInEditingHost
   *                        This method does nothing if selection is in the
   *                        editing host except if it's collapsed at start of
   *                        the editing host.
   *                        Note that if selection ranges were outside of
   *                        current selection limiter, selection was collapsed
   *                        at the start of the editing host therefore, if
   *                        you call this with setting this to true, you can
   *                        keep selection ranges if user has already been
   *                        changed.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  MaybeCollapseSelectionAtFirstEditableNode(
      bool aIgnoreIfSelectionInEditingHost);

  class BlobReader final {
    typedef EditorBase::AutoEditActionDataSetter AutoEditActionDataSetter;

   public:
    BlobReader(dom::BlobImpl* aBlob, HTMLEditor* aHTMLEditor, bool aIsSafe,
               Document* aSourceDoc, const EditorDOMPoint& aPointToInsert,
               bool aDoDeleteSelection);

    NS_INLINE_DECL_CYCLE_COLLECTING_NATIVE_REFCOUNTING(BlobReader)
    NS_DECL_CYCLE_COLLECTION_NATIVE_CLASS(BlobReader)

    MOZ_CAN_RUN_SCRIPT nsresult OnResult(const nsACString& aResult);
    nsresult OnError(const nsAString& aErrorName);

   private:
    ~BlobReader() = default;

    RefPtr<dom::BlobImpl> mBlob;
    RefPtr<HTMLEditor> mHTMLEditor;
    RefPtr<dom::DataTransfer> mDataTransfer;
    nsCOMPtr<Document> mSourceDoc;
    EditorDOMPoint mPointToInsert;
    EditAction mEditAction;
    bool mIsSafe;
    bool mDoDeleteSelection;
    bool mNeedsToDispatchBeforeInputEvent;
  };

  virtual void CreateEventListeners() override;
  virtual nsresult InstallEventListeners() override;
  virtual void RemoveEventListeners() override;

  bool ShouldReplaceRootElement() const;
  MOZ_CAN_RUN_SCRIPT void NotifyRootChanged();
  Element* GetBodyElement() const;

  /**
   * Get the focused node of this editor.
   * @return    If the editor has focus, this returns the focused node.
   *            Otherwise, returns null.
   */
  nsINode* GetFocusedNode() const;

  virtual already_AddRefed<Element> GetInputEventTargetElement() const override;

  /**
   * Return TRUE if aElement is a table-related elemet and caret was set.
   */
  MOZ_CAN_RUN_SCRIPT bool SetCaretInTableCell(dom::Element* aElement);

  /**
   * HandleTabKeyPressInTable() handles "Tab" key press in table if selection
   * is in a `<table>` element.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT EditActionResult
  HandleTabKeyPressInTable(WidgetKeyboardEvent* aKeyboardEvent);

  /**
   * InsertPosition is an enum to indicate where the method should insert to.
   */
  enum class InsertPosition {
    // Before selected cell or a cell containing first selection range.
    eBeforeSelectedCell,
    // After selected cell or a cell containing first selection range.
    eAfterSelectedCell,
  };

  /**
   * InsertTableCellsWithTransaction() inserts <td> elements before or after
   * a cell element containing first selection range.  I.e., if the cell
   * spans columns and aInsertPosition is eAfterSelectedCell, new columns
   * will be inserted after the right-most column which contains the cell.
   * Note that this simply inserts <td> elements, i.e., colspan and rowspan
   * around the cell containing selection are not modified.  So, for example,
   * adding a cell to rectangular table changes non-rectangular table.
   * And if the cell containing selection is at left of row-spanning cell,
   * it may be moved to right side of the row-spanning cell after inserting
   * some cell elements before it.  Similarly, colspan won't be adjusted
   * for keeping table rectangle.
   * If first selection range is not in table cell element, this does nothing
   * but does not return error.
   *
   * @param aNumberOfCellssToInsert     Number of cells to insert.
   * @param aInsertPosition             Before or after the target cell which
   *                                    contains first selection range.
   */
  MOZ_CAN_RUN_SCRIPT nsresult InsertTableCellsWithTransaction(
      int32_t aNumberOfCellsToInsert, InsertPosition aInsertPosition);

  /**
   * InsertTableColumnsWithTransaction() inserts columns before or after
   * a cell element containing first selection range.  I.e., if the cell
   * spans columns and aInsertPosition is eAfterSelectedCell, new columns
   * will be inserted after the right-most row which contains the cell.
   * If first selection range is not in table cell element, this does nothing
   * but does not return error.
   *
   * @param aNumberOfColumnsToInsert    Number of columns to insert.
   * @param aInsertPosition             Before or after the target cell which
   *                                    contains first selection range.
   */
  MOZ_CAN_RUN_SCRIPT nsresult InsertTableColumnsWithTransaction(
      int32_t aNumberOfColumnsToInsert, InsertPosition aInsertPosition);

  /**
   * InsertTableRowsWithTransaction() inserts <tr> elements before or after
   * a cell element containing first selection range.  I.e., if the cell
   * spans rows and aInsertPosition is eAfterSelectedCell, new rows will be
   * inserted after the most-bottom row which contains the cell.  If first
   * selection range is not in table cell element, this does nothing but
   * does not return error.
   *
   * @param aNumberOfRowsToInsert       Number of rows to insert.
   * @param aInsertPosition             Before or after the target cell which
   *                                    contains first selection range.
   */
  MOZ_CAN_RUN_SCRIPT nsresult InsertTableRowsWithTransaction(
      int32_t aNumberOfRowsToInsert, InsertPosition aInsertPosition);

  /**
   * Insert a new cell after or before supplied aCell.
   * Optional: If aNewCell supplied, returns the newly-created cell (addref'd,
   * of course)
   * This doesn't change or use the current selection.
   */
  MOZ_CAN_RUN_SCRIPT nsresult InsertCell(Element* aCell, int32_t aRowSpan,
                                         int32_t aColSpan, bool aAfter,
                                         bool aIsHeader, Element** aNewCell);

  /**
   * DeleteSelectedTableColumnsWithTransaction() removes cell elements which
   * belong to same columns of selected cell elements.
   * If only one cell element is selected or first selection range is
   * in a cell, removes cell elements which belong to same column.
   * If 2 or more cell elements are selected, removes cell elements which
   * belong to any of all selected columns.  In this case,
   * aNumberOfColumnsToDelete is ignored.
   * If there is no selection ranges, returns error.
   * If selection is not in a cell element, this does not return error,
   * just does nothing.
   * WARNING: This does not remove <col> nor <colgroup> elements.
   *
   * @param aNumberOfColumnsToDelete    Number of columns to remove.  This is
   *                                    ignored if 2 ore more cells are
   *                                    selected.
   */
  MOZ_CAN_RUN_SCRIPT nsresult
  DeleteSelectedTableColumnsWithTransaction(int32_t aNumberOfColumnsToDelete);

  /**
   * DeleteTableColumnWithTransaction() removes cell elements which belong
   * to the specified column.
   * This method adjusts colspan attribute value if cells spanning the
   * column to delete.
   * WARNING: This does not remove <col> nor <colgroup> elements.
   *
   * @param aTableElement       The <table> element which contains the
   *                            column which you want to remove.
   * @param aRowIndex           Index of the column which you want to remove.
   *                            0 is the first column.
   */
  MOZ_CAN_RUN_SCRIPT nsresult DeleteTableColumnWithTransaction(
      Element& aTableElement, int32_t aColumnIndex);

  /**
   * DeleteSelectedTableRowsWithTransaction() removes <tr> elements.
   * If only one cell element is selected or first selection range is
   * in a cell, removes <tr> elements starting from a <tr> element
   * containing the selected cell or first selection range.
   * If 2 or more cell elements are selected, all <tr> elements
   * which contains selected cell(s).  In this case, aNumberOfRowsToDelete
   * is ignored.
   * If there is no selection ranges, returns error.
   * If selection is not in a cell element, this does not return error,
   * just does nothing.
   *
   * @param aNumberOfRowsToDelete   Number of rows to remove.  This is ignored
   *                                if 2 or more cells are selected.
   */
  MOZ_CAN_RUN_SCRIPT nsresult
  DeleteSelectedTableRowsWithTransaction(int32_t aNumberOfRowsToDelete);

  /**
   * DeleteTableRowWithTransaction() removes a <tr> element whose index in
   * the <table> is aRowIndex.
   * This method adjusts rowspan attribute value if the <tr> element contains
   * cells which spans rows.
   *
   * @param aTableElement       The <table> element which contains the
   *                            <tr> element which you want to remove.
   * @param aRowIndex           Index of the <tr> element which you want to
   *                            remove.  0 is the first row.
   */
  MOZ_CAN_RUN_SCRIPT nsresult
  DeleteTableRowWithTransaction(Element& aTableElement, int32_t aRowIndex);

  /**
   * DeleteTableCellWithTransaction() removes table cell elements.  If two or
   * more cell elements are selected, this removes all selected cell elements.
   * Otherwise, this removes some cell elements starting from selected cell
   * element or a cell containing first selection range.  When this removes
   * last cell element in <tr> or <table>, this removes the <tr> or the
   * <table> too.  Note that when removing a cell causes number of its row
   * becomes less than the others, this method does NOT fill the place with
   * rowspan nor colspan.  This does not return error even if selection is not
   * in cell element, just does nothing.
   *
   * @param aNumberOfCellsToDelete  Number of cells to remove.  This is ignored
   *                                if 2 or more cells are selected.
   */
  MOZ_CAN_RUN_SCRIPT nsresult
  DeleteTableCellWithTransaction(int32_t aNumberOfCellsToDelete);

  /**
   * DeleteAllChildrenWithTransaction() removes all children of aElement from
   * the tree.
   *
   * @param aElement        The element whose children you want to remove.
   */
  MOZ_CAN_RUN_SCRIPT nsresult
  DeleteAllChildrenWithTransaction(Element& aElement);

  /**
   * Move all contents from aCellToMerge into aTargetCell (append at end).
   */
  MOZ_CAN_RUN_SCRIPT nsresult MergeCells(RefPtr<Element> aTargetCell,
                                         RefPtr<Element> aCellToMerge,
                                         bool aDeleteCellToMerge);

  /**
   * DeleteTableElementAndChildren() removes aTableElement (and its children)
   * from the DOM tree with transaction.
   *
   * @param aTableElement   The <table> element which you want to remove.
   */
  MOZ_CAN_RUN_SCRIPT nsresult
  DeleteTableElementAndChildrenWithTransaction(Element& aTableElement);

  MOZ_CAN_RUN_SCRIPT nsresult SetColSpan(Element* aCell, int32_t aColSpan);
  MOZ_CAN_RUN_SCRIPT nsresult SetRowSpan(Element* aCell, int32_t aRowSpan);

  /**
   * Helper used to get nsTableWrapperFrame for a table.
   */
  static nsTableWrapperFrame* GetTableFrame(Element* aTable);

  /**
   * GetNumberOfCellsInRow() returns number of actual cell elements in the row.
   * If some cells appear by "rowspan" in other rows, they are ignored.
   *
   * @param aTableElement   The <table> element.
   * @param aRowIndex       Valid row index in aTableElement.  This method
   *                        counts cell elements in the row.
   * @return                -1 if this meets unexpected error.
   *                        Otherwise, number of cells which this method found.
   */
  int32_t GetNumberOfCellsInRow(Element& aTableElement, int32_t aRowIndex);

  /**
   * Test if all cells in row or column at given index are selected.
   */
  bool AllCellsInRowSelected(Element* aTable, int32_t aRowIndex,
                             int32_t aNumberOfColumns);
  bool AllCellsInColumnSelected(Element* aTable, int32_t aColIndex,
                                int32_t aNumberOfRows);

  bool IsEmptyCell(Element* aCell);

  /**
   * Most insert methods need to get the same basic context data.
   * Any of the pointers may be null if you don't need that datum (for more
   * efficiency).
   * Input: *aCell is a known cell,
   *        if null, cell is obtained from the anchor node of the selection.
   * Returns NS_EDITOR_ELEMENT_NOT_FOUND if cell is not found even if aCell is
   * null.
   */
  MOZ_CAN_RUN_SCRIPT nsresult GetCellContext(Element** aTable, Element** aCell,
                                             nsINode** aCellParent,
                                             int32_t* aCellOffset,
                                             int32_t* aRowIndex,
                                             int32_t* aColIndex);

  nsresult GetCellSpansAt(Element* aTable, int32_t aRowIndex, int32_t aColIndex,
                          int32_t& aActualRowSpan, int32_t& aActualColSpan);

  MOZ_CAN_RUN_SCRIPT nsresult SplitCellIntoColumns(
      Element* aTable, int32_t aRowIndex, int32_t aColIndex,
      int32_t aColSpanLeft, int32_t aColSpanRight, Element** aNewCell);

  MOZ_CAN_RUN_SCRIPT nsresult SplitCellIntoRows(
      Element* aTable, int32_t aRowIndex, int32_t aColIndex,
      int32_t aRowSpanAbove, int32_t aRowSpanBelow, Element** aNewCell);

  MOZ_CAN_RUN_SCRIPT nsresult CopyCellBackgroundColor(Element* aDestCell,
                                                      Element* aSourceCell);

  /**
   * Reduce rowspan/colspan when cells span into nonexistent rows/columns.
   */
  MOZ_CAN_RUN_SCRIPT nsresult FixBadRowSpan(Element* aTable, int32_t aRowIndex,
                                            int32_t& aNewRowCount);
  MOZ_CAN_RUN_SCRIPT nsresult FixBadColSpan(Element* aTable, int32_t aColIndex,
                                            int32_t& aNewColCount);

  /**
   * XXX NormalizeTableInternal() is broken.  If it meets a cell which has
   *     bigger or smaller rowspan or colspan than actual number of cells,
   *     this always failed to scan the table.  Therefore, this does nothing
   *     when the table should be normalized.
   *
   * @param aTableOrElementInTable  An element which is in a <table> element
   *                                or <table> element itself.  Otherwise,
   *                                this returns NS_OK but does nothing.
   */
  MOZ_CAN_RUN_SCRIPT nsresult
  NormalizeTableInternal(Element& aTableOrElementInTable);

  /**
   * Fallback method: Call this after using ClearSelection() and you
   * failed to set selection to some other content in the document.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult SetSelectionAtDocumentStart();

  // Methods for handling plaintext quotations
  MOZ_CAN_RUN_SCRIPT nsresult PasteAsPlaintextQuotation(int32_t aSelectionType);

  /**
   * Insert a string as quoted text, replacing the selected text (if any).
   * @param aQuotedText     The string to insert.
   * @param aAddCites       Whether to prepend extra ">" to each line
   *                        (usually true, unless those characters
   *                        have already been added.)
   * @return aNodeInserted  The node spanning the insertion, if applicable.
   *                        If aAddCites is false, this will be null.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult InsertAsPlaintextQuotation(
      const nsAString& aQuotedText, bool aAddCites, nsINode** aNodeInserted);

  /**
   * InsertObject() inserts given object at aPointToInsert.
   */
  MOZ_CAN_RUN_SCRIPT nsresult InsertObject(const nsACString& aType,
                                           nsISupports* aObject, bool aIsSafe,
                                           Document* aSourceDoc,
                                           const EditorDOMPoint& aPointToInsert,
                                           bool aDoDeleteSelection);

  // factored methods for handling insertion of data from transferables
  // (drag&drop or clipboard)
  virtual nsresult PrepareTransferable(
      nsITransferable** aTransferable) override;
  nsresult PrepareHTMLTransferable(nsITransferable** aTransferable);
  MOZ_CAN_RUN_SCRIPT nsresult InsertFromTransferable(
      nsITransferable* aTransferable, Document* aSourceDoc,
      const nsAString& aContextStr, const nsAString& aInfoStr,
      bool aHavePrivateHTMLFlavor, bool aDoDeleteSelection);

  /**
   * InsertFromDataTransfer() is called only when user drops data into
   * this editor.  Don't use this method for other purposes.
   */
  MOZ_CAN_RUN_SCRIPT nsresult InsertFromDataTransfer(
      dom::DataTransfer* aDataTransfer, int32_t aIndex, Document* aSourceDoc,
      const EditorDOMPoint& aDroppedAt, bool aDoDeleteSelection);

  bool HavePrivateHTMLFlavor(nsIClipboard* clipboard);
  nsresult ParseCFHTML(nsCString& aCfhtml, char16_t** aStuffToPaste,
                       char16_t** aCfcontext);

  nsresult StripFormattingNodes(nsIContent& aNode, bool aOnlyList = false);
  nsresult CreateDOMFragmentFromPaste(
      const nsAString& aInputString, const nsAString& aContextStr,
      const nsAString& aInfoStr, nsCOMPtr<nsINode>* aOutFragNode,
      nsCOMPtr<nsINode>* aOutStartNode, nsCOMPtr<nsINode>* aOutEndNode,
      int32_t* aOutStartOffset, int32_t* aOutEndOffset, bool aTrustedInput);
  nsresult ParseFragment(const nsAString& aStr, nsAtom* aContextLocalName,
                         Document* aTargetDoc,
                         dom::DocumentFragment** aFragment, bool aTrustedInput);
  /**
   * CollectTopMostChildContentsCompletelyInRange() collects topmost child
   * contents which are completely in the given range.
   * For example, if the range points a node with its container node, the
   * result is only the node (meaning does not include its descendants).
   * If the range starts start of a node and ends end of it, and if the node
   * does not have children, returns no nodes, otherwise, if the node has
   * some children, the result includes its all children (not including their
   * descendants).
   *
   * @param aStartPoint         Start point of the range.
   * @param aEndPoint           End point of the range.
   * @param aOutArrayOfContents [Out] Topmost children which are completely in
   *                            the range.
   */
  static void CollectTopMostChildNodesCompletelyInRange(
      const EditorRawDOMPoint& aStartPoint, const EditorRawDOMPoint& aEndPoint,
      nsTArray<OwningNonNull<nsIContent>>& aOutArrayOfContents);

  /**
   * AutoHTMLFragmentBoundariesFixer fixes both edges of topmost child nodes
   * which are created with SubtreeContentIterator.
   */
  class MOZ_STACK_CLASS AutoHTMLFragmentBoundariesFixer final {
   public:
    /**
     * @param aArrayOfTopMostChildContents
     *                         [in/out] The topmost child nodes which will be
     *                         inserted into the DOM tree.  Both edges, i.e.,
     *                         first node and last node in this array will be
     *                         checked whether they can be insertted into
     *                         another DOM tree.  If not, it'll replaces some
     *                         orphan nodes around nodes with proper parent.
     */
    explicit AutoHTMLFragmentBoundariesFixer(
        nsTArray<OwningNonNull<nsIContent>>& aArrayOfTopMostChildContents);

   private:
    /**
     * EnsureBeginsOrEndsWithValidContent() replaces some nodes starting from
     * start or end with proper element node if it's necessary.
     * If first or last node of aArrayOfTopMostChildContents is in list and/or
     * `<table>` element, looks for topmost list element or `<table>` element
     * with `CollectListAndTableRelatedElementsAt()` and
     * `GetMostAncestorListOrTableElement()`.  Then, checks whether
     * some nodes are in aArrayOfTopMostChildContents are the topmost list/table
     * element or its descendant and if so, removes the nodes from
     * aArrayOfTopMostChildContents and inserts the list/table element instead.
     * Then, aArrayOfTopMostChildContents won't start/end with list-item nor
     * table cells.
     */
    enum class StartOrEnd { start, end };
    void EnsureBeginsOrEndsWithValidContent(
        StartOrEnd aStartOrEnd,
        nsTArray<OwningNonNull<nsIContent>>& aArrayOfTopMostChildContents)
        const;

    /**
     * CollectListAndTableRelatedElementsAt() collects list elements and
     * table related elements from aNode (meaning aNode may be in the first of
     * the result) to the root element.
     */
    void CollectListAndTableRelatedElementsAt(
        nsIContent& aContent,
        nsTArray<OwningNonNull<Element>>& aOutArrayOfListAndTableElements)
        const;

    /**
     * GetMostAncestorListOrTableElement() returns a list or a `<table>`
     * element which is in aArrayOfListAndTableElements and they are
     * actually valid ancestor of at least one of aArrayOfTopMostChildContents.
     */
    Element* GetMostAncestorListOrTableElement(
        const nsTArray<OwningNonNull<nsIContent>>& aArrayOfTopMostChildContents,
        const nsTArray<OwningNonNull<Element>>&
            aArrayOfListAndTableRelatedElements) const;

    /**
     * FindReplaceableTableElement() is a helper method of
     * EnsureBeginsOrEndsWithValidContent().  If aNodeMaybeInTableElement is
     * a descendant of aTableElement, returns aNodeMaybeInTableElement or its
     * nearest ancestor whose tag name is `<td>`, `<th>`, `<tr>`, `<thead>`,
     * `<tfoot>`, `<tbody>` or `<caption>`.
     *
     * @param aTableElement               Must be a `<table>` element.
     * @param aContentMaybeInTableElement A node which may be in aTableElement.
     */
    Element* FindReplaceableTableElement(
        Element& aTableElement, nsIContent& aContentMaybeInTableElement) const;

    /**
     * IsReplaceableListElement() is a helper method of
     * EnsureBeginsOrEndsWithValidContent().  If aNodeMaybeInListElement is a
     * descendant of aListElement, returns true.  Otherwise, false.
     *
     * @param aListElement                Must be a list element.
     * @param aContentMaybeInListElement  A node which may be in aListElement.
     */
    bool IsReplaceableListElement(Element& aListElement,
                                  nsIContent& aContentMaybeInListElement) const;
  };

  /**
   * GetBetterInsertionPointFor() returns better insertion point to insert
   * aContentToInsert.
   *
   * @param aContentToInsert    The content to insert.
   * @param aPointToInsert      A candidate point to insert the node.
   * @return                    Better insertion point if next visible node
   *                            is a <br> element and previous visible node
   *                            is neither none, another <br> element nor
   *                            different block level element.
   */
  EditorRawDOMPoint GetBetterInsertionPointFor(
      nsIContent& aContentToInsert, const EditorRawDOMPoint& aPointToInsert);

  /**
   * MakeDefinitionListItemWithTransaction() replaces parent list of current
   * selection with <dl> or create new <dl> element and creates a definition
   * list item whose name is aTagName.
   *
   * @param aTagName            Must be nsGkAtoms::dt or nsGkAtoms::dd.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  MakeDefinitionListItemWithTransaction(nsAtom& aTagName);

  /**
   * FormatBlockContainerAsSubAction() inserts a block element whose name
   * is aTagName at selection.  If selection is not collapsed and aTagName is
   * nsGkAtoms::normal or nsGkAtoms::_empty, this removes block containers.
   *
   * @param aTagName            A block level element name.  Must NOT be
   *                            nsGkAtoms::dt nor nsGkAtoms::dd.
   */
  MOZ_CAN_RUN_SCRIPT nsresult FormatBlockContainerAsSubAction(nsAtom& aTagName);

  /**
   * Increase/decrease the font size of selection.
   */
  MOZ_CAN_RUN_SCRIPT nsresult RelativeFontChange(FontSize aDir);

  MOZ_CAN_RUN_SCRIPT nsresult RelativeFontChangeOnNode(int32_t aSizeChange,
                                                       nsIContent* aNode);
  MOZ_CAN_RUN_SCRIPT nsresult RelativeFontChangeHelper(int32_t aSizeChange,
                                                       nsINode* aNode);

  /**
   * Helper routines for inline style.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult SetInlinePropertyOnTextNode(
      Text& aData, uint32_t aStartOffset, uint32_t aEndOffset,
      nsAtom& aProperty, nsAtom* aAttribute, const nsAString& aValue);

  nsresult PromoteInlineRange(nsRange& aRange);
  nsresult PromoteRangeIfStartsOrEndsInNamedAnchor(nsRange& aRange);

  /**
   * RemoveStyleInside() removes elements which represent aProperty/aAttribute
   * and removes CSS style.  This handles aElement and all its descendants
   * (including leaf text nodes) recursively.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  RemoveStyleInside(Element& aElement, nsAtom* aProperty, nsAtom* aAttribute);

  /**
   * CollectEditableLeafTextNodes() collects text nodes in aElement.
   */
  void CollectEditableLeafTextNodes(
      Element& aElement, nsTArray<OwningNonNull<Text>>& aLeafTextNodes) const;

  /**
   * IsRemovableParentStyleWithNewSpanElement() checks whether
   * aProperty/aAttribute of parent block can be removed from aContent with
   * creating `<span>` element.  Note that this does NOT check whether the
   * specified style comes from parent block or not.
   * XXX This may destroy the editor, but using `Result<bool, nsresult>`
   *     is not reasonable because code for accessing the result becomes
   *     messy.  However, anybody must forget to check `Destroyed()` after
   *     calling this.  Which is the way to smart to make every caller
   *     must check the editor state?
   */
  MOZ_CAN_RUN_SCRIPT bool IsRemovableParentStyleWithNewSpanElement(
      nsIContent& aContent, nsAtom* aHTMLProperty, nsAtom* aAttribute) const;

  /**
   * XXX These methods seem odd and except the only caller,
   *     `PromoteInlineRange()`, cannot use them.
   */
  bool IsStartOfContainerOrBeforeFirstEditableChild(
      const EditorRawDOMPoint& aPoint) const;
  bool IsEndOfContainerOrEqualsOrAfterLastEditableChild(
      const EditorRawDOMPoint& aPoint) const;

  bool IsOnlyAttribute(const Element* aElement, nsAtom* aAttribute);

  /**
   * HasStyleOrIdOrClassAttribute() returns true when at least one of
   * `style`, `id` or `class` attribute value of aElement is not empty.
   */
  static bool HasStyleOrIdOrClassAttribute(Element& aElement);

  /**
   * Whether the outer window of the DOM event target has focus or not.
   */
  bool OurWindowHasFocus() const;

  /**
   * This function is used to insert a string of HTML input optionally with some
   * context information into the editable field.  The HTML input either comes
   * from a transferable object created as part of a drop/paste operation, or
   * from the InsertHTML method.  We may want the HTML input to be sanitized
   * (for example, if it's coming from a transferable object), in which case
   * aTrustedInput should be set to false, otherwise, the caller should set it
   * to true, which means that the HTML will be inserted in the DOM verbatim.
   *
   * aClearStyle should be set to false if you want the paste to be affected by
   * local style (e.g., for the insertHTML command).
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult DoInsertHTMLWithContext(
      const nsAString& aInputString, const nsAString& aContextStr,
      const nsAString& aInfoStr, const nsAString& aFlavor, Document* aSourceDoc,
      const EditorDOMPoint& aPointToInsert, bool aDeleteSelection,
      bool aTrustedInput, bool aClearStyle = true);

  /**
   * sets the position of an element; warning it does NOT check if the
   * element is already positioned or not and that's on purpose.
   * @param aElement [IN] the element
   * @param aX       [IN] the x position in pixels.
   * @param aY       [IN] the y position in pixels.
   */
  MOZ_CAN_RUN_SCRIPT void SetTopAndLeft(Element& aElement, int32_t aX,
                                        int32_t aY);

  /**
   * Reset a selected cell or collapsed selection (the caret) after table
   * editing.
   *
   * @param aTable      A table in the document.
   * @param aRow        The row ...
   * @param aCol        ... and column defining the cell where we will try to
   *                    place the caret.
   * @param aSelected   If true, we select the whole cell instead of setting
   *                    caret.
   * @param aDirection  If cell at (aCol, aRow) is not found, search for
   *                    previous cell in the same column (aPreviousColumn) or
   *                    row (ePreviousRow) or don't search for another cell
   *                    (aNoSearch).  If no cell is found, caret is place just
   *                    before table; and if that fails, at beginning of
   *                    document.  Thus we generally don't worry about the
   *                    return value and can use the
   *                    AutoSelectionSetterAfterTableEdit stack-based object to
   *                    insure we reset the caret in a table-editing method.
   */
  MOZ_CAN_RUN_SCRIPT void SetSelectionAfterTableEdit(Element* aTable,
                                                     int32_t aRow, int32_t aCol,
                                                     int32_t aDirection,
                                                     bool aSelected);

  void RemoveListenerAndDeleteRef(const nsAString& aEvent,
                                  nsIDOMEventListener* aListener,
                                  bool aUseCapture, ManualNACPtr aElement,
                                  PresShell* aPresShell);
  void DeleteRefToAnonymousNode(ManualNACPtr aContent, PresShell* aPresShell);

  /**
   * RefreshEditingUI() may refresh editing UIs for current Selection, focus,
   * etc.  If this shows or hides some UIs, it causes reflow.  So, this is
   * not safe method.
   */
  MOZ_CAN_RUN_SCRIPT nsresult RefreshEditingUI();

  /**
   * Returns the offset of an element's frame to its absolute containing block.
   */
  nsresult GetElementOrigin(Element& aElement, int32_t& aX, int32_t& aY);
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult GetPositionAndDimensions(
      Element& aElement, int32_t& aX, int32_t& aY, int32_t& aW, int32_t& aH,
      int32_t& aBorderLeft, int32_t& aBorderTop, int32_t& aMarginLeft,
      int32_t& aMarginTop);

  bool IsInObservedSubtree(nsIContent* aChild);

  void UpdateRootElement();

  /**
   * SetAllResizersPosition() moves all resizers to proper position.
   * If the resizers are hidden or replaced with another set of resizers
   * while this is running, this returns error.  So, callers shouldn't
   * keep handling the resizers if this returns error.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult SetAllResizersPosition();

  /**
   * Shows active resizers around an element's frame
   * @param aResizedElement [IN] a DOM Element
   */
  MOZ_CAN_RUN_SCRIPT nsresult ShowResizersInternal(Element& aResizedElement);

  /**
   * Hide resizers if they are visible.  If this is called while there is no
   * visible resizers, this does not return error, but does nothing.
   */
  nsresult HideResizersInternal();

  /**
   * RefreshResizersInternal() moves resizers to proper position.  This does
   * nothing if there is no resizing target.
   */
  MOZ_CAN_RUN_SCRIPT nsresult RefreshResizersInternal();

  ManualNACPtr CreateResizer(int16_t aLocation, nsIContent& aParentContent);
  MOZ_CAN_RUN_SCRIPT void SetAnonymousElementPosition(int32_t aX, int32_t aY,
                                                      Element* aResizer);

  ManualNACPtr CreateShadow(nsIContent& aParentContent,
                            Element& aOriginalObject);

  /**
   * SetShadowPosition() moves the shadow element to proper position.
   *
   * @param aShadowElement      Must be mResizingShadow or mPositioningShadow.
   * @param aElement            The element which has the shadow.
   * @param aElementX           Left of aElement.
   * @param aElementY           Top of aElement.
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  SetShadowPosition(Element& aShadowElement, Element& aElement,
                    int32_t aElementLeft, int32_t aElementTop);

  ManualNACPtr CreateResizingInfo(nsIContent& aParentContent);
  MOZ_CAN_RUN_SCRIPT nsresult SetResizingInfoPosition(int32_t aX, int32_t aY,
                                                      int32_t aW, int32_t aH);

  enum class ResizeAt {
    eX,
    eY,
    eWidth,
    eHeight,
  };
  int32_t GetNewResizingIncrement(int32_t aX, int32_t aY, ResizeAt aResizeAt);

  MOZ_CAN_RUN_SCRIPT nsresult StartResizing(Element* aHandle);
  int32_t GetNewResizingX(int32_t aX, int32_t aY);
  int32_t GetNewResizingY(int32_t aX, int32_t aY);
  int32_t GetNewResizingWidth(int32_t aX, int32_t aY);
  int32_t GetNewResizingHeight(int32_t aX, int32_t aY);
  void HideShadowAndInfo();
  MOZ_CAN_RUN_SCRIPT void SetFinalSize(int32_t aX, int32_t aY);
  void SetResizeIncrements(int32_t aX, int32_t aY, int32_t aW, int32_t aH,
                           bool aPreserveRatio);

  /**
   * HideAnonymousEditingUIs() forcibly hides all editing UIs (resizers,
   * inline-table-editing UI, absolute positioning UI).
   */
  void HideAnonymousEditingUIs();

  /**
   * HideAnonymousEditingUIsIfUnnecessary() hides all editing UIs if some of
   * visible UIs are now unnecessary.
   */
  void HideAnonymousEditingUIsIfUnnecessary();

  /**
   * sets the z-index of an element.
   * @param aElement [IN] the element
   * @param aZorder  [IN] the z-index
   */
  MOZ_CAN_RUN_SCRIPT void SetZIndex(Element& aElement, int32_t aZorder);

  /**
   * shows a grabber attached to an arbitrary element. The grabber is an image
   * positioned on the left hand side of the top border of the element. Draggin
   * and dropping it allows to change the element's absolute position in the
   * document. See chrome://editor/content/images/grabber.gif
   * @param aElement [IN] the element
   */
  MOZ_CAN_RUN_SCRIPT nsresult ShowGrabberInternal(Element& aElement);

  /**
   * Setting grabber to proper position for current mAbsolutelyPositionedObject.
   * For example, while an element has grabber, the element may be resized
   * or repositioned by script or something.  Then, you need to reset grabber
   * position with this.
   */
  MOZ_CAN_RUN_SCRIPT nsresult RefreshGrabberInternal();

  /**
   * hide the grabber if it shown.
   */
  void HideGrabberInternal();

  /**
   * CreateGrabberInternal() creates a grabber for moving aParentContent.
   * This sets mGrabber to the new grabber.  If this returns true, it's
   * always non-nullptr.  Otherwise, i.e., the grabber is hidden during
   * creation, this returns false.
   */
  bool CreateGrabberInternal(nsIContent& aParentContent);

  MOZ_CAN_RUN_SCRIPT nsresult StartMoving();
  MOZ_CAN_RUN_SCRIPT nsresult SetFinalPosition(int32_t aX, int32_t aY);
  void AddPositioningOffset(int32_t& aX, int32_t& aY);
  void SnapToGrid(int32_t& newX, int32_t& newY);
  nsresult GrabberClicked();
  MOZ_CAN_RUN_SCRIPT nsresult EndMoving();
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  GetTemporaryStyleForFocusedPositionedElement(Element& aElement,
                                               nsAString& aReturn);

  /**
   * Shows inline table editing UI around a <table> element which contains
   * aCellElement.  This returns error if creating UI is hidden during this,
   * or detects another set of UI during this.  In such case, callers
   * shouldn't keep handling anything for the UI.
   *
   * @param aCellElement    Must be an <td> or <th> element.
   */
  MOZ_CAN_RUN_SCRIPT nsresult
  ShowInlineTableEditingUIInternal(Element& aCellElement);

  /**
   * Hide all inline table editing UI.
   */
  void HideInlineTableEditingUIInternal();

  /**
   * RefreshInlineTableEditingUIInternal() moves inline table editing UI to
   * proper position.  This returns error if the UI is hidden or replaced
   * during moving.
   */
  MOZ_CAN_RUN_SCRIPT nsresult RefreshInlineTableEditingUIInternal();

  /**
   * IsEmptyTextNode() returns true if aNode is a text node and does not have
   * any visible characters.
   */
  bool IsEmptyTextNode(nsINode& aNode) const {
    return aNode.IsText() && IsEmptyNode(aNode);
  }

  MOZ_CAN_RUN_SCRIPT bool IsSimpleModifiableNode(nsIContent* aContent,
                                                 nsAtom* aProperty,
                                                 nsAtom* aAttribute,
                                                 const nsAString* aValue);
  MOZ_CAN_RUN_SCRIPT nsresult
  SetInlinePropertyOnNodeImpl(nsIContent& aNode, nsAtom& aProperty,
                              nsAtom* aAttribute, const nsAString& aValue);
  typedef enum { eInserted, eAppended } InsertedOrAppended;
  MOZ_CAN_RUN_SCRIPT void DoContentInserted(
      nsIContent* aChild, InsertedOrAppended aInsertedOrAppended);

  /**
   * Returns an anonymous Element of type aTag,
   * child of aParentContent. If aIsCreatedHidden is true, the class
   * "hidden" is added to the created element. If aAnonClass is not
   * the empty string, it becomes the value of the attribute "_moz_anonclass"
   * @return a Element
   * @param aTag             [IN] desired type of the element to create
   * @param aParentContent   [IN] the parent node of the created anonymous
   *                              element
   * @param aAnonClass       [IN] contents of the _moz_anonclass attribute
   * @param aIsCreatedHidden [IN] a boolean specifying if the class "hidden"
   *                              is to be added to the created anonymous
   *                              element
   */
  ManualNACPtr CreateAnonymousElement(nsAtom* aTag, nsIContent& aParentContent,
                                      const nsAString& aAnonClass,
                                      bool aIsCreatedHidden);

  /**
   * Reads a blob into memory and notifies the BlobReader object when the read
   * operation is finished.
   *
   * @param aBlob       The input blob
   * @param aWindow     The global object under which the read should happen.
   * @param aBlobReader The blob reader object to be notified when finished.
   */
  static nsresult SlurpBlob(dom::Blob* aBlob, nsPIDOMWindowOuter* aWindow,
                            BlobReader* aBlobReader);

  /**
   * OnModifyDocumentInternal() is called by OnModifyDocument().
   */
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult OnModifyDocumentInternal();

  /**
   * For saving allocation cost in the constructor of
   * EditorBase::TopLevelEditSubActionData, we should reuse same RangeItem
   * instance with all top level edit sub actions.
   * The instance is always cleared when TopLevelEditSubActionData is
   * destructed and the class is stack only class so that we don't need
   * to (and also should not) add the RangeItem into the cycle collection.
   */
  already_AddRefed<RangeItem> GetSelectedRangeItemForTopLevelEditSubAction()
      const {
    if (!mSelectedRangeForTopLevelEditSubAction) {
      mSelectedRangeForTopLevelEditSubAction = new RangeItem();
    }
    return do_AddRef(mSelectedRangeForTopLevelEditSubAction);
  }

  /**
   * For saving allocation cost in the constructor of
   * EditorBase::TopLevelEditSubActionData, we should reuse same nsRange
   * instance with all top level edit sub actions.
   * The instance is always cleared when TopLevelEditSubActionData is
   * destructed, but AbstractRange::mOwner keeps grabbing the owner document
   * so that we need to make it in the cycle collection.
   */
  already_AddRefed<nsRange> GetChangedRangeForTopLevelEditSubAction() const {
    if (!mChangedRangeForTopLevelEditSubAction) {
      mChangedRangeForTopLevelEditSubAction = nsRange::Create(GetDocument());
    }
    return do_AddRef(mChangedRangeForTopLevelEditSubAction);
  }

 protected:
  // Helper for Handle[CSS|HTML]IndentAtSelectionInternal
  [[nodiscard]] MOZ_CAN_RUN_SCRIPT nsresult
  IndentListChild(RefPtr<Element>* aCurList, const EditorDOMPoint& aCurPoint,
                  nsIContent& aContent);

  RefPtr<TypeInState> mTypeInState;
  RefPtr<ComposerCommandsUpdater> mComposerCommandsUpdater;

  // Used by TopLevelEditSubActionData::mSelectedRange.
  mutable RefPtr<RangeItem> mSelectedRangeForTopLevelEditSubAction;
  // Used by TopLevelEditSubActionData::mChangedRange.
  mutable RefPtr<nsRange> mChangedRangeForTopLevelEditSubAction;

  RefPtr<Runnable> mPendingRootElementUpdatedRunner;
  RefPtr<Runnable> mPendingDocumentModifiedRunner;

  bool mCRInParagraphCreatesParagraph;

  bool mCSSAware;
  UniquePtr<CSSEditUtils> mCSSEditUtils;

  // mSelectedCellIndex is reset by GetFirstSelectedTableCellElement(),
  // then, it'll be referred and incremented by
  // GetNextSelectedTableCellElement().
  mutable uint32_t mSelectedCellIndex;

  // resizing
  bool mIsObjectResizingEnabled;
  bool mIsResizing;
  bool mPreserveRatio;
  bool mResizedObjectIsAnImage;

  // absolute positioning
  bool mIsAbsolutelyPositioningEnabled;
  bool mResizedObjectIsAbsolutelyPositioned;
  bool mGrabberClicked;
  bool mIsMoving;

  bool mSnapToGridEnabled;

  // inline table editing
  bool mIsInlineTableEditingEnabled;

  // resizing
  ManualNACPtr mTopLeftHandle;
  ManualNACPtr mTopHandle;
  ManualNACPtr mTopRightHandle;
  ManualNACPtr mLeftHandle;
  ManualNACPtr mRightHandle;
  ManualNACPtr mBottomLeftHandle;
  ManualNACPtr mBottomHandle;
  ManualNACPtr mBottomRightHandle;

  RefPtr<Element> mActivatedHandle;

  ManualNACPtr mResizingShadow;
  ManualNACPtr mResizingInfo;

  RefPtr<Element> mResizedObject;

  int32_t mOriginalX;
  int32_t mOriginalY;

  int32_t mResizedObjectX;
  int32_t mResizedObjectY;
  int32_t mResizedObjectWidth;
  int32_t mResizedObjectHeight;

  int32_t mResizedObjectMarginLeft;
  int32_t mResizedObjectMarginTop;
  int32_t mResizedObjectBorderLeft;
  int32_t mResizedObjectBorderTop;

  int32_t mXIncrementFactor;
  int32_t mYIncrementFactor;
  int32_t mWidthIncrementFactor;
  int32_t mHeightIncrementFactor;

  int8_t mInfoXIncrement;
  int8_t mInfoYIncrement;

  // absolute positioning
  int32_t mPositionedObjectX;
  int32_t mPositionedObjectY;
  int32_t mPositionedObjectWidth;
  int32_t mPositionedObjectHeight;

  int32_t mPositionedObjectMarginLeft;
  int32_t mPositionedObjectMarginTop;
  int32_t mPositionedObjectBorderLeft;
  int32_t mPositionedObjectBorderTop;

  RefPtr<Element> mAbsolutelyPositionedObject;
  ManualNACPtr mGrabber;
  ManualNACPtr mPositioningShadow;

  int32_t mGridSize;

  // inline table editing
  RefPtr<Element> mInlineEditedCell;

  ManualNACPtr mAddColumnBeforeButton;
  ManualNACPtr mRemoveColumnButton;
  ManualNACPtr mAddColumnAfterButton;

  ManualNACPtr mAddRowBeforeButton;
  ManualNACPtr mRemoveRowButton;
  ManualNACPtr mAddRowAfterButton;

  void AddMouseClickListener(Element* aElement);
  void RemoveMouseClickListener(Element* aElement);

  bool mDisabledLinkHandling = false;
  bool mOldLinkHandlingEnabled = false;

  ParagraphSeparator mDefaultParagraphSeparator;

  friend class AlignStateAtSelection;
  friend class AutoSelectionSetterAfterTableEdit;
  friend class AutoSetTemporaryAncestorLimiter;
  friend class CSSEditUtils;
  friend class EditorBase;
  friend class EmptyEditableFunctor;
  friend class JoinNodeTransaction;
  friend class ListElementSelectionState;
  friend class ListItemElementSelectionState;
  friend class ParagraphStateAtSelection;
  friend class SlurpBlobEventListener;
  friend class SplitNodeTransaction;
  friend class TextEditor;
  friend class WSRunObject;
  friend class WSRunScanner;
  friend class WSScanResult;
};

/**
 * ListElementSelectionState class gets which list element is selected right
 * now.
 */
class MOZ_STACK_CLASS ListElementSelectionState final {
 public:
  ListElementSelectionState() = delete;
  ListElementSelectionState(HTMLEditor& aHTMLEditor, ErrorResult& aRv);

  bool IsOLElementSelected() const { return mIsOLElementSelected; }
  bool IsULElementSelected() const { return mIsULElementSelected; }
  bool IsDLElementSelected() const { return mIsDLElementSelected; }
  bool IsNotOneTypeListElementSelected() const {
    return (mIsOLElementSelected + mIsULElementSelected + mIsDLElementSelected +
            mIsOtherContentSelected) > 1;
  }

 private:
  bool mIsOLElementSelected = false;
  bool mIsULElementSelected = false;
  bool mIsDLElementSelected = false;
  bool mIsOtherContentSelected = false;
};

/**
 * ListItemElementSelectionState class gets which list item element is selected
 * right now.
 */
class MOZ_STACK_CLASS ListItemElementSelectionState final {
 public:
  ListItemElementSelectionState() = delete;
  ListItemElementSelectionState(HTMLEditor& aHTMLEditor, ErrorResult& aRv);

  bool IsLIElementSelected() const { return mIsLIElementSelected; }
  bool IsDTElementSelected() const { return mIsDTElementSelected; }
  bool IsDDElementSelected() const { return mIsDDElementSelected; }
  bool IsNotOneTypeDefinitionListItemElementSelected() const {
    return (mIsDTElementSelected + mIsDDElementSelected +
            mIsOtherElementSelected) > 1;
  }

 private:
  bool mIsLIElementSelected = false;
  bool mIsDTElementSelected = false;
  bool mIsDDElementSelected = false;
  bool mIsOtherElementSelected = false;
};

/**
 * AlignStateAtSelection class gets alignment at selection.
 * XXX This currently returns only first alignment.
 */
class MOZ_STACK_CLASS AlignStateAtSelection final {
 public:
  AlignStateAtSelection() = delete;
  MOZ_CAN_RUN_SCRIPT AlignStateAtSelection(HTMLEditor& aHTMLEditor,
                                           ErrorResult& aRv);

  nsIHTMLEditor::EAlignment AlignmentAtSelectionStart() const {
    return mFirstAlign;
  }
  bool IsSelectionRangesFound() const { return mFoundSelectionRanges; }

 private:
  nsIHTMLEditor::EAlignment mFirstAlign = nsIHTMLEditor::eLeft;
  bool mFoundSelectionRanges = false;
};

/**
 * ParagraphStateAtSelection class gets format block types around selection.
 */
class MOZ_STACK_CLASS ParagraphStateAtSelection final {
 public:
  ParagraphStateAtSelection() = delete;
  ParagraphStateAtSelection(HTMLEditor& aHTMLEditor, ErrorResult& aRv);

  /**
   * GetFirstParagraphStateAtSelection() returns:
   * - nullptr if there is no format blocks nor inline nodes.
   * - nsGkAtoms::_empty if first node is not in any format block.
   * - a tag name of format block at first node.
   * XXX See the private method explanations.  If selection ranges contains
   *     non-format block first, it'll be check after its siblings.  Therefore,
   *     this may return non-first paragraph state.
   */
  nsAtom* GetFirstParagraphStateAtSelection() const {
    return mFirstParagraphState;
  }

  /**
   * If selected nodes are not in same format node nor only in no-format blocks,
   * this returns true.
   */
  bool IsMixed() const { return mIsMixed; }

 private:
  using EditorType = EditorBase::EditorType;

  /**
   * AppendDescendantFormatNodesAndFirstInlineNode() appends descendant
   * format blocks and first inline child node in aNonFormatBlockElement to
   * the last of the array (not inserting where aNonFormatBlockElement is,
   * so that the node order becomes randomly).
   *
   * @param aArrayOfContents            [in/out] Found descendant format blocks
   *                                    and first inline node in each non-format
   *                                    block will be appended to this.
   * @param aNonFormatBlockElement      Must be a non-format block element.
   */
  static void AppendDescendantFormatNodesAndFirstInlineNode(
      nsTArray<OwningNonNull<nsIContent>>& aArrayOfContents,
      dom::Element& aNonFormatBlockElement);

  /**
   * CollectEditableFormatNodesInSelection() collects only editable nodes
   * around selection ranges (with
   * `HTMLEditor::CollectEditTargetNodesInExtendedSelectionRanges()`, see its
   * document for the detail).  If it includes list, list item or table
   * related elements, they will be replaced their children.
   */
  static nsresult CollectEditableFormatNodesInSelection(
      HTMLEditor& aHTMLEditor,
      nsTArray<OwningNonNull<nsIContent>>& aArrayOfContents);

  RefPtr<nsAtom> mFirstParagraphState;
  bool mIsMixed = false;
};

}  // namespace mozilla

mozilla::HTMLEditor* nsIEditor::AsHTMLEditor() {
  return static_cast<mozilla::EditorBase*>(this)->IsHTMLEditor()
             ? static_cast<mozilla::HTMLEditor*>(this)
             : nullptr;
}

const mozilla::HTMLEditor* nsIEditor::AsHTMLEditor() const {
  return static_cast<const mozilla::EditorBase*>(this)->IsHTMLEditor()
             ? static_cast<const mozilla::HTMLEditor*>(this)
             : nullptr;
}

#endif  // #ifndef mozilla_HTMLEditor_h
