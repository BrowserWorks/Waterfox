/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_dom_HTMLTextAreaElement_h
#define mozilla_dom_HTMLTextAreaElement_h

#include "mozilla/Attributes.h"
#include "nsIDOMHTMLTextAreaElement.h"
#include "nsITextControlElement.h"
#include "nsIControllers.h"
#include "nsIDOMNSEditableElement.h"
#include "nsCOMPtr.h"
#include "nsGenericHTMLElement.h"
#include "nsStubMutationObserver.h"
#include "nsIConstraintValidation.h"
#include "mozilla/dom/HTMLFormElement.h"
#include "mozilla/dom/HTMLInputElementBinding.h"
#include "nsGkAtoms.h"

#include "mozilla/TextEditor.h"
#include "nsTextEditorState.h"

class nsIControllers;
class nsIDocument;
class nsPresContext;
class nsPresState;

namespace mozilla {

class EventChainPostVisitor;
class EventChainPreVisitor;
class EventStates;

namespace dom {

class HTMLFormSubmission;

class HTMLTextAreaElement final : public nsGenericHTMLFormElementWithState,
                                  public nsIDOMHTMLTextAreaElement,
                                  public nsITextControlElement,
                                  public nsIDOMNSEditableElement,
                                  public nsStubMutationObserver,
                                  public nsIConstraintValidation
{
public:
  using nsIConstraintValidation::GetValidationMessage;

  explicit HTMLTextAreaElement(already_AddRefed<mozilla::dom::NodeInfo>& aNodeInfo,
                               FromParser aFromParser = NOT_FROM_PARSER);

  // nsISupports
  NS_DECL_ISUPPORTS_INHERITED

  virtual int32_t TabIndexDefault() override;

  // Element
  virtual bool IsInteractiveHTMLContent(bool aIgnoreTabindex) const override
  {
    return true;
  }

  // nsIDOMHTMLTextAreaElement
  NS_DECL_NSIDOMHTMLTEXTAREAELEMENT

  // nsIDOMNSEditableElement
  NS_IMETHOD GetEditor(nsIEditor** aEditor) override
  {
    nsCOMPtr<nsIEditor> editor = GetEditor();
    editor.forget(aEditor);
    return NS_OK;
  }
  NS_IMETHOD SetUserInput(const nsAString& aInput) override;

  // nsIFormControl
  NS_IMETHOD Reset() override;
  NS_IMETHOD SubmitNamesValues(HTMLFormSubmission* aFormSubmission) override;
  NS_IMETHOD SaveState() override;
  virtual bool RestoreState(nsPresState* aState) override;
  virtual bool IsDisabledForEvents(EventMessage aMessage) override;

  virtual void FieldSetDisabledChanged(bool aNotify) override;

  virtual EventStates IntrinsicState() const override;

  // nsITextControlElemet
  NS_IMETHOD SetValueChanged(bool aValueChanged) override;
  NS_IMETHOD_(bool) IsSingleLineTextControl() const override;
  NS_IMETHOD_(bool) IsTextArea() const override;
  NS_IMETHOD_(bool) IsPlainTextControl() const override;
  NS_IMETHOD_(bool) IsPasswordTextControl() const override;
  NS_IMETHOD_(int32_t) GetCols() override;
  NS_IMETHOD_(int32_t) GetWrapCols() override;
  NS_IMETHOD_(int32_t) GetRows() override;
  NS_IMETHOD_(void) GetDefaultValueFromContent(nsAString& aValue) override;
  NS_IMETHOD_(bool) ValueChanged() const override;
  NS_IMETHOD_(void) GetTextEditorValue(nsAString& aValue, bool aIgnoreWrap) const override;
  NS_IMETHOD_(mozilla::TextEditor*) GetTextEditor() override;
  NS_IMETHOD_(nsISelectionController*) GetSelectionController() override;
  NS_IMETHOD_(nsFrameSelection*) GetConstFrameSelection() override;
  NS_IMETHOD BindToFrame(nsTextControlFrame* aFrame) override;
  NS_IMETHOD_(void) UnbindFromFrame(nsTextControlFrame* aFrame) override;
  NS_IMETHOD CreateEditor() override;
  NS_IMETHOD_(Element*) GetRootEditorNode() override;
  NS_IMETHOD_(Element*) CreatePlaceholderNode() override;
  NS_IMETHOD_(Element*) GetPlaceholderNode() override;
  NS_IMETHOD_(Element*) CreatePreviewNode() override;
  NS_IMETHOD_(Element*) GetPreviewNode() override;
  NS_IMETHOD_(void) UpdateOverlayTextVisibility(bool aNotify) override;
  NS_IMETHOD_(bool) GetPlaceholderVisibility() override;
  NS_IMETHOD_(bool) GetPreviewVisibility() override;
  NS_IMETHOD_(void) SetPreviewValue(const nsAString& aValue) override;
  NS_IMETHOD_(void) GetPreviewValue(nsAString& aValue) override;
  NS_IMETHOD_(void) EnablePreview() override;
  NS_IMETHOD_(bool) IsPreviewEnabled() override;
  NS_IMETHOD_(void) InitializeKeyboardEventListeners() override;
  NS_IMETHOD_(void) OnValueChanged(bool aNotify, bool aWasInteractiveUserChange) override;
  virtual void GetValueFromSetRangeText(nsAString& aValue) override;
  virtual nsresult SetValueFromSetRangeText(const nsAString& aValue) override;
  NS_IMETHOD_(bool) HasCachedSelection() override;


  // nsIContent
  virtual nsresult BindToTree(nsIDocument* aDocument, nsIContent* aParent,
                               nsIContent* aBindingParent,
                               bool aCompileEventHandlers) override;
  virtual void UnbindFromTree(bool aDeep = true,
                              bool aNullParent = true) override;
  virtual bool ParseAttribute(int32_t aNamespaceID,
                                nsIAtom* aAttribute,
                                const nsAString& aValue,
                                nsAttrValue& aResult) override;
  virtual nsMapRuleToAttributesFunc GetAttributeMappingFunction() const override;
  virtual nsChangeHint GetAttributeChangeHint(const nsIAtom* aAttribute,
                                              int32_t aModType) const override;
  NS_IMETHOD_(bool) IsAttributeMapped(const nsIAtom* aAttribute) const override;

  virtual nsresult GetEventTargetParent(
                     EventChainPreVisitor& aVisitor) override;
  virtual nsresult PreHandleEvent(EventChainVisitor& aVisitor) override;
  virtual nsresult PostHandleEvent(
                     EventChainPostVisitor& aVisitor) override;

  virtual bool IsHTMLFocusable(bool aWithMouse, bool *aIsFocusable, int32_t *aTabIndex) override;

  virtual void DoneAddingChildren(bool aHaveNotified) override;
  virtual bool IsDoneAddingChildren() override;

  virtual nsresult Clone(mozilla::dom::NodeInfo *aNodeInfo, nsINode **aResult,
                         bool aPreallocateChildren) const override;

  nsresult CopyInnerTo(Element* aDest, bool aPreallocateChildren);

  /**
   * Called when an attribute is about to be changed
   */
  virtual nsresult BeforeSetAttr(int32_t aNameSpaceID, nsIAtom* aName,
                                 const nsAttrValueOrString* aValue,
                                 bool aNotify) override;

  // nsIMutationObserver
  NS_DECL_NSIMUTATIONOBSERVER_CHARACTERDATACHANGED
  NS_DECL_NSIMUTATIONOBSERVER_CONTENTAPPENDED
  NS_DECL_NSIMUTATIONOBSERVER_CONTENTINSERTED
  NS_DECL_NSIMUTATIONOBSERVER_CONTENTREMOVED

  NS_DECL_CYCLE_COLLECTION_CLASS_INHERITED(HTMLTextAreaElement,
                                           nsGenericHTMLFormElementWithState)

  // nsIConstraintValidation
  bool     IsTooLong();
  bool     IsTooShort();
  bool     IsValueMissing() const;
  void     UpdateTooLongValidityState();
  void     UpdateTooShortValidityState();
  void     UpdateValueMissingValidityState();
  void     UpdateBarredFromConstraintValidation();
  nsresult GetValidationMessage(nsAString& aValidationMessage,
                                ValidityStateType aType) override;

  // Web IDL binding methods
  bool Autofocus()
  {
    return GetBoolAttr(nsGkAtoms::autofocus);
  }
  void SetAutofocus(bool aAutoFocus, ErrorResult& aError)
  {
    SetHTMLBoolAttr(nsGkAtoms::autofocus, aAutoFocus, aError);
  }
  uint32_t Cols()
  {
    return GetIntAttr(nsGkAtoms::cols, DEFAULT_COLS);
  }
  void SetCols(uint32_t aCols, ErrorResult& aError)
  {
    uint32_t cols = aCols ? aCols : DEFAULT_COLS;
    SetUnsignedIntAttr(nsGkAtoms::cols, cols, DEFAULT_COLS, aError);
  }
  bool Disabled()
  {
    return GetBoolAttr(nsGkAtoms::disabled);
  }
  void SetDisabled(bool aDisabled, ErrorResult& aError)
  {
    SetHTMLBoolAttr(nsGkAtoms::disabled, aDisabled, aError);
  }
  // nsGenericHTMLFormElementWithState::GetForm is fine
  using nsGenericHTMLFormElementWithState::GetForm;
  int32_t MaxLength()
  {
    return GetIntAttr(nsGkAtoms::maxlength, -1);
  }
  void SetMaxLength(int32_t aMaxLength, ErrorResult& aError)
  {
    int32_t minLength = MinLength();
    if (aMaxLength < 0 || (minLength >= 0 && aMaxLength < minLength)) {
      aError.Throw(NS_ERROR_DOM_INDEX_SIZE_ERR);
    } else {
      SetHTMLIntAttr(nsGkAtoms::maxlength, aMaxLength, aError);
    }
  }
  int32_t MinLength()
  {
    return GetIntAttr(nsGkAtoms::minlength, -1);
  }
  void SetMinLength(int32_t aMinLength, ErrorResult& aError)
  {
    int32_t maxLength = MaxLength();
    if (aMinLength < 0 || (maxLength >= 0 && aMinLength > maxLength)) {
      aError.Throw(NS_ERROR_DOM_INDEX_SIZE_ERR);
    } else {
      SetHTMLIntAttr(nsGkAtoms::minlength, aMinLength, aError);
    }
  }
  // XPCOM GetName is fine
  void SetName(const nsAString& aName, ErrorResult& aError)
  {
    SetHTMLAttr(nsGkAtoms::name, aName, aError);
  }
  // XPCOM GetPlaceholder is fine
  void SetPlaceholder(const nsAString& aPlaceholder, ErrorResult& aError)
  {
    SetHTMLAttr(nsGkAtoms::placeholder, aPlaceholder, aError);
  }
  bool ReadOnly()
  {
    return GetBoolAttr(nsGkAtoms::readonly);
  }
  void SetReadOnly(bool aReadOnly, ErrorResult& aError)
  {
    SetHTMLBoolAttr(nsGkAtoms::readonly, aReadOnly, aError);
  }
  bool Required()
  {
    return GetBoolAttr(nsGkAtoms::required);
  }

  void SetRangeText(const nsAString& aReplacement, ErrorResult& aRv);

  void SetRangeText(const nsAString& aReplacement, uint32_t aStart,
                    uint32_t aEnd, SelectionMode aSelectMode,
                    ErrorResult& aRv);

  void SetRequired(bool aRequired, ErrorResult& aError)
  {
    SetHTMLBoolAttr(nsGkAtoms::required, aRequired, aError);
  }
  uint32_t Rows()
  {
    return GetIntAttr(nsGkAtoms::rows, DEFAULT_ROWS_TEXTAREA);
  }
  void SetRows(uint32_t aRows, ErrorResult& aError)
  {
    uint32_t rows = aRows ? aRows : DEFAULT_ROWS_TEXTAREA;
    SetUnsignedIntAttr(nsGkAtoms::rows, rows, DEFAULT_ROWS_TEXTAREA, aError);
  }
  // XPCOM GetWrap is fine
  void SetWrap(const nsAString& aWrap, ErrorResult& aError)
  {
    SetHTMLAttr(nsGkAtoms::wrap, aWrap, aError);
  }
  // XPCOM GetType is fine
  // XPCOM GetDefaultValue is fine
  void SetDefaultValue(const nsAString& aDefaultValue, ErrorResult& aError);
  // XPCOM GetValue/SetValue are fine
  uint32_t GetTextLength();

  // Override SetCustomValidity so we update our state properly when it's called
  // via bindings.
  void SetCustomValidity(const nsAString& aError);

  // XPCOM Select is fine
  Nullable<uint32_t> GetSelectionStart(ErrorResult& aError);
  void SetSelectionStart(const Nullable<uint32_t>& aSelectionStart, ErrorResult& aError);
  Nullable<uint32_t> GetSelectionEnd(ErrorResult& aError);
  void SetSelectionEnd(const Nullable<uint32_t>& aSelectionEnd, ErrorResult& aError);
  void GetSelectionDirection(nsAString& aDirection, ErrorResult& aError);
  void SetSelectionDirection(const nsAString& aDirection, ErrorResult& aError);
  void SetSelectionRange(uint32_t aSelectionStart, uint32_t aSelectionEnd, const Optional<nsAString>& aDirecton, ErrorResult& aError);
  nsIControllers* GetControllers(ErrorResult& aError);
  nsIEditor* GetEditor()
  {
    return mState.GetTextEditor();
  }

protected:
  virtual ~HTMLTextAreaElement() {}

  // get rid of the compiler warning
  using nsGenericHTMLFormElementWithState::IsSingleLineTextControl;

  virtual JSObject* WrapNode(JSContext *aCx, JS::Handle<JSObject*> aGivenProto) override;

  nsCOMPtr<nsIControllers> mControllers;
  /** Whether or not the value has changed since its default value was given. */
  bool                     mValueChanged;
  /** Whether or not the last change to the value was made interactively by the user. */
  bool                     mLastValueChangeWasInteractive;
  /** Whether or not we are already handling select event. */
  bool                     mHandlingSelect;
  /** Whether or not we are done adding children (always true if not
      created by a parser */
  bool                     mDoneAddingChildren;
  /** Whether state restoration should be inhibited in DoneAddingChildren. */
  bool                     mInhibitStateRestoration;
  /** Whether our disabled state has changed from the default **/
  bool                     mDisabledChanged;
  /** Whether we should make :-moz-ui-invalid apply on the element. **/
  bool                     mCanShowInvalidUI;
  /** Whether we should make :-moz-ui-valid apply on the element. **/
  bool                     mCanShowValidUI;
  bool                     mIsPreviewEnabled;

  void FireChangeEventIfNeeded();

  nsString mFocusedValue;

  /** The state of the text editor (selection controller and the editor) **/
  nsTextEditorState mState;

  NS_IMETHOD SelectAll(nsPresContext* aPresContext);
  /**
   * Get the value, whether it is from the content or the frame.
   * @param aValue the value [out]
   * @param aIgnoreWrap whether to ignore the wrap attribute when getting the
   *        value.  If this is true, linebreaks will not be inserted even if
   *        wrap=hard.
   */
  void GetValueInternal(nsAString& aValue, bool aIgnoreWrap) const;

  /**
   * Setting the value.
   *
   * @param aValue      String to set.
   * @param aFlags      See nsTextEditorState::SetValueFlags.
   */
  nsresult SetValueInternal(const nsAString& aValue, uint32_t aFlags);

  /**
   * Common method to call from the various mutation observer methods.
   * aContent is a content node that's either the one that changed or its
   * parent; we should only respond to the change if aContent is non-anonymous.
   */
  void ContentChanged(nsIContent* aContent);

  virtual nsresult AfterSetAttr(int32_t aNamespaceID, nsIAtom *aName,
                                const nsAttrValue* aValue,
                                const nsAttrValue* aOldValue,
                                bool aNotify) override;

  /**
   * Return if an element should have a specific validity UI
   * (with :-moz-ui-invalid and :-moz-ui-valid pseudo-classes).
   *
   * @return Whether the element should have a validity UI.
   */
  bool ShouldShowValidityUI() const {
    /**
     * Always show the validity UI if the form has already tried to be submitted
     * but was invalid.
     *
     * Otherwise, show the validity UI if the element's value has been changed.
     */

    if (mForm && mForm->HasEverTriedInvalidSubmit()) {
      return true;
    }

    return mValueChanged;
  }

  /**
   * Get the mutable state of the element.
   */
  bool IsMutable() const;

  /**
   * Returns whether the current value is the empty string.
   *
   * @return whether the current value is the empty string.
   */
  bool IsValueEmpty() const;

  /**
   * A helper to get the current selection range.  Will throw on the ErrorResult
   * if we have no editor state.
   */
  void GetSelectionRange(uint32_t* aSelectionStart,
                         uint32_t* aSelectionEnd,
                         ErrorResult& aRv);
private:
  static void MapAttributesIntoRule(const nsMappedAttributes* aAttributes,
                                    GenericSpecifiedValues* aGenericData);
};

} // namespace dom
} // namespace mozilla

#endif

