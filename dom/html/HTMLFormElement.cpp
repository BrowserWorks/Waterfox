/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/dom/HTMLFormElement.h"

#include <utility>

#include "jsapi.h"
#include "mozilla/BasePrincipal.h"
#include "mozilla/BinarySearch.h"
#include "mozilla/ContentEvents.h"
#include "mozilla/EventDispatcher.h"
#include "mozilla/EventStates.h"
#include "mozilla/UniquePtr.h"
#include "mozilla/dom/BindContext.h"
#include "mozilla/dom/CustomEvent.h"
#include "mozilla/dom/Document.h"
#include "mozilla/dom/HTMLFormControlsCollection.h"
#include "mozilla/dom/HTMLFormElementBinding.h"
#include "mozilla/dom/nsCSPContext.h"
#include "mozilla/dom/nsCSPUtils.h"
#include "mozilla/dom/nsMixedContentBlocker.h"
#include "nsCOMArray.h"
#include "nsContentList.h"
#include "nsContentUtils.h"
#include "nsDocShell.h"
#include "nsError.h"
#include "nsGkAtoms.h"
#include "nsHTMLDocument.h"
#include "nsIFormControlFrame.h"
#include "nsInterfaceHashtable.h"
#include "nsPresContext.h"
#include "nsQueryObject.h"
#include "nsStyleConsts.h"
#include "nsTArray.h"

// form submission
#include "HTMLFormSubmissionConstants.h"
#include "mozilla/dom/FormData.h"
#include "mozilla/dom/FormDataEvent.h"
#include "mozilla/dom/SubmitEvent.h"
#include "mozilla/Telemetry.h"
#include "mozilla/StaticPrefs_prompts.h"
#include "nsIFormSubmitObserver.h"
#include "nsIObserverService.h"
#include "nsCategoryManagerUtils.h"
#include "nsISimpleEnumerator.h"
#include "nsRange.h"
#include "nsIScriptError.h"
#include "nsIScriptSecurityManager.h"
#include "nsNetUtil.h"
#include "nsIInterfaceRequestorUtils.h"
#include "nsIWebProgress.h"
#include "nsIDocShell.h"
#include "nsIPromptService.h"
#include "nsISecurityUITelemetry.h"
#include "nsIStringBundle.h"

// radio buttons
#include "mozilla/dom/HTMLInputElement.h"
#include "nsIRadioVisitor.h"
#include "RadioNodeList.h"

#include "nsLayoutUtils.h"

#include "mozAutoDocUpdate.h"
#include "nsIHTMLCollection.h"

#include "nsIConstraintValidation.h"

#include "nsSandboxFlags.h"

// images
#include "mozilla/dom/HTMLImageElement.h"
#include "mozilla/dom/HTMLButtonElement.h"

// construction, destruction
NS_IMPL_NS_NEW_HTML_ELEMENT(Form)

namespace mozilla {
namespace dom {

static const uint8_t NS_FORM_AUTOCOMPLETE_ON = 1;
static const uint8_t NS_FORM_AUTOCOMPLETE_OFF = 0;

static const nsAttrValue::EnumTable kFormAutocompleteTable[] = {
    {"on", NS_FORM_AUTOCOMPLETE_ON},
    {"off", NS_FORM_AUTOCOMPLETE_OFF},
    {nullptr, 0}};
// Default autocomplete value is 'on'.
static const nsAttrValue::EnumTable* kFormDefaultAutocomplete =
    &kFormAutocompleteTable[0];

HTMLFormElement::HTMLFormElement(
    already_AddRefed<mozilla::dom::NodeInfo>&& aNodeInfo)
    : nsGenericHTMLElement(std::move(aNodeInfo)),
      mControls(new HTMLFormControlsCollection(this)),
      mSelectedRadioButtons(2),
      mRequiredRadioButtonCounts(2),
      mValueMissingRadioGroups(2),
      mPendingSubmission(nullptr),
      mSubmittingRequest(nullptr),
      mDefaultSubmitElement(nullptr),
      mFirstSubmitInElements(nullptr),
      mFirstSubmitNotInElements(nullptr),
      mImageNameLookupTable(FORM_CONTROL_LIST_HASHTABLE_LENGTH),
      mPastNameLookupTable(FORM_CONTROL_LIST_HASHTABLE_LENGTH),
      mSubmitPopupState(PopupBlocker::openAbused),
      mInvalidElementsCount(0),
      mFormNumber(-1),
      mGeneratingSubmit(false),
      mGeneratingReset(false),
      mIsSubmitting(false),
      mDeferSubmission(false),
      mNotifiedObservers(false),
      mNotifiedObserversResult(false),
      mEverTriedInvalidSubmit(false),
      mIsConstructingEntryList(false),
      mIsFiringSubmissionEvents(false) {
  // We start out valid.
  AddStatesSilently(NS_EVENT_STATE_VALID);
}

HTMLFormElement::~HTMLFormElement() {
  if (mControls) {
    mControls->DropFormReference();
  }

  Clear();
}

// nsISupports

NS_IMPL_CYCLE_COLLECTION_CLASS(HTMLFormElement)

NS_IMPL_CYCLE_COLLECTION_TRAVERSE_BEGIN_INHERITED(HTMLFormElement,
                                                  nsGenericHTMLElement)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mControls)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mImageNameLookupTable)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mPastNameLookupTable)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mSelectedRadioButtons)
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_END

NS_IMPL_CYCLE_COLLECTION_UNLINK_BEGIN_INHERITED(HTMLFormElement,
                                                nsGenericHTMLElement)
  tmp->Clear();
  tmp->mExpandoAndGeneration.OwnerUnlinked();
NS_IMPL_CYCLE_COLLECTION_UNLINK_END

NS_IMPL_ISUPPORTS_CYCLE_COLLECTION_INHERITED(HTMLFormElement,
                                             nsGenericHTMLElement, nsIForm,
                                             nsIWebProgressListener,
                                             nsIRadioGroupContainer)

// EventTarget
void HTMLFormElement::AsyncEventRunning(AsyncEventDispatcher* aEvent) {
  if (mFormPasswordEventDispatcher == aEvent) {
    mFormPasswordEventDispatcher = nullptr;
  }
}

NS_IMPL_ELEMENT_CLONE(HTMLFormElement)

nsIHTMLCollection* HTMLFormElement::Elements() { return mControls; }

nsresult HTMLFormElement::BeforeSetAttr(int32_t aNamespaceID, nsAtom* aName,
                                        const nsAttrValueOrString* aValue,
                                        bool aNotify) {
  if (aNamespaceID == kNameSpaceID_None) {
    if (aName == nsGkAtoms::action || aName == nsGkAtoms::target) {
      // Don't forget we've notified the password manager already if the
      // page sets the action/target in the during submit. (bug 343182)
      bool notifiedObservers = mNotifiedObservers;
      ForgetCurrentSubmission();
      mNotifiedObservers = notifiedObservers;
    }
  }

  return nsGenericHTMLElement::BeforeSetAttr(aNamespaceID, aName, aValue,
                                             aNotify);
}

nsresult HTMLFormElement::AfterSetAttr(int32_t aNameSpaceID, nsAtom* aName,
                                       const nsAttrValue* aValue,
                                       const nsAttrValue* aOldValue,
                                       nsIPrincipal* aSubjectPrincipal,
                                       bool aNotify) {
  if (aName == nsGkAtoms::novalidate && aNameSpaceID == kNameSpaceID_None) {
    // Update all form elements states because they might be [no longer]
    // affected by :-moz-ui-valid or :-moz-ui-invalid.
    for (uint32_t i = 0, length = mControls->mElements.Length(); i < length;
         ++i) {
      mControls->mElements[i]->UpdateState(true);
    }

    for (uint32_t i = 0, length = mControls->mNotInElements.Length();
         i < length; ++i) {
      mControls->mNotInElements[i]->UpdateState(true);
    }
  }

  return nsGenericHTMLElement::AfterSetAttr(
      aNameSpaceID, aName, aValue, aOldValue, aSubjectPrincipal, aNotify);
}

void HTMLFormElement::GetAutocomplete(nsAString& aValue) {
  GetEnumAttr(nsGkAtoms::autocomplete, kFormDefaultAutocomplete->tag, aValue);
}

void HTMLFormElement::GetEnctype(nsAString& aValue) {
  GetEnumAttr(nsGkAtoms::enctype, kFormDefaultEnctype->tag, aValue);
}

void HTMLFormElement::GetMethod(nsAString& aValue) {
  GetEnumAttr(nsGkAtoms::method, kFormDefaultMethod->tag, aValue);
}

// https://html.spec.whatwg.org/multipage/forms.html#concept-form-submit
void HTMLFormElement::MaybeSubmit(Element* aSubmitter) {
#ifdef DEBUG
  if (aSubmitter) {
    nsCOMPtr<nsIFormControl> fc = do_QueryInterface(aSubmitter);
    MOZ_ASSERT(fc);
    MOZ_ASSERT(fc->IsSubmitControl(), "aSubmitter is not a submit control?");
  }
#endif

  // 1-4 of
  // https://html.spec.whatwg.org/multipage/forms.html#concept-form-submit
  Document* doc = GetComposedDoc();
  if (mIsConstructingEntryList || !doc ||
      (doc->GetSandboxFlags() & SANDBOXED_FORMS)) {
    return;
  }

  // 6.1. If form's firing submission events is true, then return.
  if (mIsFiringSubmissionEvents) {
    return;
  }

  // 6.2. Set form's firing submission events to true.
  AutoRestore<bool> resetFiringSubmissionEventsFlag(mIsFiringSubmissionEvents);
  mIsFiringSubmissionEvents = true;

  // 6.3. If the submitter element's no-validate state is false, then
  //      interactively validate the constraints of form and examine the result.
  //      If the result is negative (i.e., the constraint validation concluded
  //      that there were invalid fields and probably informed the user of this)
  bool noValidateState =
      HasAttr(kNameSpaceID_None, nsGkAtoms::novalidate) ||
      (aSubmitter &&
       aSubmitter->HasAttr(kNameSpaceID_None, nsGkAtoms::formnovalidate));
  if (!noValidateState && !CheckValidFormSubmission()) {
    return;
  }

  // If |PresShell::Destroy| has been called due to handling the event the pres
  // context will return a null pres shell. See bug 125624. Using presShell to
  // dispatch the event. It makes sure that event is not handled if the window
  // is being destroyed.
  if (RefPtr<PresShell> presShell = doc->GetPresShell()) {
    SubmitEventInit init;
    init.mBubbles = true;
    init.mCancelable = true;
    init.mSubmitter =
        aSubmitter ? nsGenericHTMLElement::FromNode(aSubmitter) : nullptr;
    RefPtr<SubmitEvent> event =
        SubmitEvent::Constructor(this, NS_LITERAL_STRING("submit"), init);
    event->SetTrusted(true);
    nsEventStatus status = nsEventStatus_eIgnore;
    presShell->HandleDOMEventWithTarget(this, event, &status);
  }
}

void HTMLFormElement::MaybeReset(Element* aSubmitter) {
  // If |PresShell::Destroy| has been called due to handling the event the pres
  // context will return a null pres shell. See bug 125624. Using presShell to
  // dispatch the event. It makes sure that event is not handled if the window
  // is being destroyed.
  if (RefPtr<PresShell> presShell = OwnerDoc()->GetPresShell()) {
    InternalFormEvent event(true, eFormReset);
    event.mOriginator = aSubmitter;
    nsEventStatus status = nsEventStatus_eIgnore;
    presShell->HandleDOMEventWithTarget(this, &event, &status);
  }
}

void HTMLFormElement::Submit(ErrorResult& aRv) {
  // Send the submit event
  if (mPendingSubmission) {
    // aha, we have a pending submission that was not flushed
    // (this happens when form.submit() is called twice)
    // we have to delete it and build a new one since values
    // might have changed inbetween (we emulate IE here, that's all)
    mPendingSubmission = nullptr;
  }

  aRv = DoSubmit();
}

// https://html.spec.whatwg.org/multipage/forms.html#dom-form-requestsubmit
void HTMLFormElement::RequestSubmit(nsGenericHTMLElement* aSubmitter,
                                    ErrorResult& aRv) {
  // 1. If submitter is not null, then:
  if (aSubmitter) {
    nsCOMPtr<nsIFormControl> fc = do_QueryObject(aSubmitter);

    // 1.1. If submitter is not a submit button, then throw a TypeError.
    if (!fc || !fc->IsSubmitControl()) {
      aRv.ThrowTypeError("The submitter is not a submit button.");
      return;
    }

    // 1.2. If submitter's form owner is not this form element, then throw a
    //      "NotFoundError" DOMException.
    if (fc->GetFormElement() != this) {
      aRv.Throw(NS_ERROR_DOM_NOT_FOUND_ERR);
      return;
    }
  }

  // 2. Otherwise, set submitter to this form element.
  // 3. Submit this form element, from submitter.
  MaybeSubmit(aSubmitter);
}

void HTMLFormElement::Reset() {
  InternalFormEvent event(true, eFormReset);
  EventDispatcher::Dispatch(static_cast<nsIContent*>(this), nullptr, &event);
}

bool HTMLFormElement::ParseAttribute(int32_t aNamespaceID, nsAtom* aAttribute,
                                     const nsAString& aValue,
                                     nsIPrincipal* aMaybeScriptedPrincipal,
                                     nsAttrValue& aResult) {
  if (aNamespaceID == kNameSpaceID_None) {
    if (aAttribute == nsGkAtoms::method) {
      if (StaticPrefs::dom_dialog_element_enabled()) {
        return aResult.ParseEnumValue(aValue, kFormMethodTableDialogEnabled,
                                      false);
      }
      return aResult.ParseEnumValue(aValue, kFormMethodTable, false);
    }
    if (aAttribute == nsGkAtoms::enctype) {
      return aResult.ParseEnumValue(aValue, kFormEnctypeTable, false);
    }
    if (aAttribute == nsGkAtoms::autocomplete) {
      return aResult.ParseEnumValue(aValue, kFormAutocompleteTable, false);
    }
  }

  return nsGenericHTMLElement::ParseAttribute(aNamespaceID, aAttribute, aValue,
                                              aMaybeScriptedPrincipal, aResult);
}

nsresult HTMLFormElement::BindToTree(BindContext& aContext, nsINode& aParent) {
  nsresult rv = nsGenericHTMLElement::BindToTree(aContext, aParent);
  NS_ENSURE_SUCCESS(rv, rv);

  if (IsInUncomposedDoc() && aContext.OwnerDoc().IsHTMLOrXHTML()) {
    aContext.OwnerDoc().AsHTMLDocument()->AddedForm();
  }

  return rv;
}

template <typename T>
static void MarkOrphans(const nsTArray<T*>& aArray) {
  uint32_t length = aArray.Length();
  for (uint32_t i = 0; i < length; ++i) {
    aArray[i]->SetFlags(MAYBE_ORPHAN_FORM_ELEMENT);
  }
}

static void CollectOrphans(nsINode* aRemovalRoot,
                           const nsTArray<nsGenericHTMLFormElement*>& aArray
#ifdef DEBUG
                           ,
                           HTMLFormElement* aThisForm
#endif
) {
  // Put a script blocker around all the notifications we're about to do.
  nsAutoScriptBlocker scriptBlocker;

  // Walk backwards so that if we remove elements we can just keep iterating
  uint32_t length = aArray.Length();
  for (uint32_t i = length; i > 0; --i) {
    nsGenericHTMLFormElement* node = aArray[i - 1];

    // Now if MAYBE_ORPHAN_FORM_ELEMENT is not set, that would mean that the
    // node is in fact a descendant of the form and hence should stay in the
    // form.  If it _is_ set, then we need to check whether the node is a
    // descendant of aRemovalRoot.  If it is, we leave it in the form.
#ifdef DEBUG
    bool removed = false;
#endif
    if (node->HasFlag(MAYBE_ORPHAN_FORM_ELEMENT)) {
      node->UnsetFlags(MAYBE_ORPHAN_FORM_ELEMENT);
      if (!node->IsInclusiveDescendantOf(aRemovalRoot)) {
        node->ClearForm(true, false);

        // When a form control loses its form owner, its state can change.
        node->UpdateState(true);
#ifdef DEBUG
        removed = true;
#endif
      }
    }

#ifdef DEBUG
    if (!removed) {
      HTMLFormElement* form = node->GetForm();
      NS_ASSERTION(form == aThisForm, "How did that happen?");
    }
#endif /* DEBUG */
  }
}

static void CollectOrphans(nsINode* aRemovalRoot,
                           const nsTArray<HTMLImageElement*>& aArray
#ifdef DEBUG
                           ,
                           HTMLFormElement* aThisForm
#endif
) {
  // Walk backwards so that if we remove elements we can just keep iterating
  uint32_t length = aArray.Length();
  for (uint32_t i = length; i > 0; --i) {
    HTMLImageElement* node = aArray[i - 1];

    // Now if MAYBE_ORPHAN_FORM_ELEMENT is not set, that would mean that the
    // node is in fact a descendant of the form and hence should stay in the
    // form.  If it _is_ set, then we need to check whether the node is a
    // descendant of aRemovalRoot.  If it is, we leave it in the form.
#ifdef DEBUG
    bool removed = false;
#endif
    if (node->HasFlag(MAYBE_ORPHAN_FORM_ELEMENT)) {
      node->UnsetFlags(MAYBE_ORPHAN_FORM_ELEMENT);
      if (!node->IsInclusiveDescendantOf(aRemovalRoot)) {
        node->ClearForm(true);

#ifdef DEBUG
        removed = true;
#endif
      }
    }

#ifdef DEBUG
    if (!removed) {
      HTMLFormElement* form = node->GetForm();
      NS_ASSERTION(form == aThisForm, "How did that happen?");
    }
#endif /* DEBUG */
  }
}

void HTMLFormElement::UnbindFromTree(bool aNullParent) {
  // Note, this is explicitly using uncomposed doc, since we count
  // only forms in document.
  RefPtr<Document> oldDocument = GetUncomposedDoc();

  // Mark all of our controls as maybe being orphans
  MarkOrphans(mControls->mElements);
  MarkOrphans(mControls->mNotInElements);
  MarkOrphans(mImageElements);

  nsGenericHTMLElement::UnbindFromTree(aNullParent);

  nsINode* ancestor = this;
  nsINode* cur;
  do {
    cur = ancestor->GetParentNode();
    if (!cur) {
      break;
    }
    ancestor = cur;
  } while (1);

  CollectOrphans(ancestor, mControls->mElements
#ifdef DEBUG
                 ,
                 this
#endif
  );
  CollectOrphans(ancestor, mControls->mNotInElements
#ifdef DEBUG
                 ,
                 this
#endif
  );
  CollectOrphans(ancestor, mImageElements
#ifdef DEBUG
                 ,
                 this
#endif
  );

  if (oldDocument && oldDocument->IsHTMLOrXHTML()) {
    oldDocument->AsHTMLDocument()->RemovedForm();
  }
  ForgetCurrentSubmission();
}

void HTMLFormElement::GetEventTargetParent(EventChainPreVisitor& aVisitor) {
  aVisitor.mWantsWillHandleEvent = true;
  if (aVisitor.mEvent->mOriginalTarget == static_cast<nsIContent*>(this)) {
    uint32_t msg = aVisitor.mEvent->mMessage;
    if (msg == eFormSubmit) {
      if (mGeneratingSubmit) {
        aVisitor.mCanHandle = false;
        return;
      }
      mGeneratingSubmit = true;

      // let the form know that it needs to defer the submission,
      // that means that if there are scripted submissions, the
      // latest one will be deferred until after the exit point of the handler.
      mDeferSubmission = true;
    } else if (msg == eFormReset) {
      if (mGeneratingReset) {
        aVisitor.mCanHandle = false;
        return;
      }
      mGeneratingReset = true;
    }
  }
  nsGenericHTMLElement::GetEventTargetParent(aVisitor);
}

void HTMLFormElement::WillHandleEvent(EventChainPostVisitor& aVisitor) {
  // If this is the bubble stage and there is a nested form below us which
  // received a submit event we do *not* want to handle the submit event
  // for this form too.
  if ((aVisitor.mEvent->mMessage == eFormSubmit ||
       aVisitor.mEvent->mMessage == eFormReset) &&
      aVisitor.mEvent->mFlags.mInBubblingPhase &&
      aVisitor.mEvent->mOriginalTarget != static_cast<nsIContent*>(this)) {
    aVisitor.mEvent->StopPropagation();
  }
}

nsresult HTMLFormElement::PostHandleEvent(EventChainPostVisitor& aVisitor) {
  if (aVisitor.mEvent->mOriginalTarget == static_cast<nsIContent*>(this)) {
    EventMessage msg = aVisitor.mEvent->mMessage;
    if (msg == eFormSubmit) {
      // let the form know not to defer subsequent submissions
      mDeferSubmission = false;
    }

    if (aVisitor.mEventStatus == nsEventStatus_eIgnore) {
      switch (msg) {
        case eFormReset: {
          DoReset();
          break;
        }
        case eFormSubmit: {
          if (mPendingSubmission) {
            // tell the form to forget a possible pending submission.
            // the reason is that the script returned true (the event was
            // ignored) so if there is a stored submission, it will miss
            // the name/value of the submitting element, thus we need
            // to forget it and the form element will build a new one
            mPendingSubmission = nullptr;
          }
          DoSubmit(aVisitor.mDOMEvent);
          break;
        }
        default:
          break;
      }
    } else {
      if (msg == eFormSubmit) {
        // tell the form to flush a possible pending submission.
        // the reason is that the script returned false (the event was
        // not ignored) so if there is a stored submission, it needs to
        // be submitted immediatelly.
        FlushPendingSubmission();
      }
    }

    if (msg == eFormSubmit) {
      mGeneratingSubmit = false;
    } else if (msg == eFormReset) {
      mGeneratingReset = false;
    }
  }
  return NS_OK;
}

nsresult HTMLFormElement::DoReset() {
  // Make sure the presentation is up-to-date
  Document* doc = GetComposedDoc();
  if (doc) {
    doc->FlushPendingNotifications(FlushType::ContentAndNotify);
  }

  mEverTriedInvalidSubmit = false;
  // JBK walk the elements[] array instead of form frame controls - bug 34297
  uint32_t numElements = GetElementCount();
  for (uint32_t elementX = 0; elementX < numElements; ++elementX) {
    // Hold strong ref in case the reset does something weird
    nsCOMPtr<nsIFormControl> controlNode = GetElementAt(elementX);
    if (controlNode) {
      controlNode->Reset();
    }
  }

  return NS_OK;
}

#define NS_ENSURE_SUBMIT_SUCCESS(rv) \
  if (NS_FAILED(rv)) {               \
    ForgetCurrentSubmission();       \
    return rv;                       \
  }

nsresult HTMLFormElement::DoSubmit(Event* aEvent) {
  Document* doc = GetComposedDoc();
  NS_ASSERTION(doc, "Should never get here without a current doc");

  // Make sure the presentation is up-to-date
  if (doc) {
    doc->FlushPendingNotifications(FlushType::ContentAndNotify);
  }

  // Don't submit if we're not in a document or if we're in
  // a sandboxed frame and form submit is disabled.
  if (mIsConstructingEntryList || !doc ||
      (doc->GetSandboxFlags() & SANDBOXED_FORMS)) {
    return NS_OK;
  }

  if (mIsSubmitting) {
    NS_WARNING("Preventing double form submission");
    // XXX Should this return an error?
    return NS_OK;
  }

  // Mark us as submitting so that we don't try to submit again
  mIsSubmitting = true;
  NS_ASSERTION(!mWebProgress && !mSubmittingRequest,
               "Web progress / submitting request should not exist here!");

  UniquePtr<HTMLFormSubmission> submission;

  //
  // prepare the submission object
  //
  nsresult rv = BuildSubmission(getter_Transfers(submission), aEvent);

  // Don't raise an error if form cannot navigate.
  if (StaticPrefs::dom_formdata_event_enabled() &&
      rv == NS_ERROR_NOT_AVAILABLE) {
    mIsSubmitting = false;
    return NS_OK;
  }

  if (NS_FAILED(rv)) {
    mIsSubmitting = false;
    return rv;
  }

  // XXXbz if the script global is that for an sXBL/XBL2 doc, it won't
  // be a window...
  nsPIDOMWindowOuter* window = OwnerDoc()->GetWindow();
  if (window) {
    mSubmitPopupState = PopupBlocker::GetPopupControlState();
  } else {
    mSubmitPopupState = PopupBlocker::openAbused;
  }

  if (mDeferSubmission) {
    // we are in an event handler, JS submitted so we have to
    // defer this submission. let's remember it and return
    // without submitting
    mPendingSubmission = std::move(submission);
    // ensure reentrancy
    mIsSubmitting = false;
    return NS_OK;
  }

  //
  // perform the submission
  //
  if (!submission) {
    mIsSubmitting = false;
#ifdef DEBUG
    HTMLDialogElement* dialog = nullptr;
    for (nsIContent* parent = GetParent(); parent;
         parent = parent->GetParent()) {
      dialog = HTMLDialogElement::FromNodeOrNull(parent);
      if (dialog) {
        break;
      }
    }
    MOZ_ASSERT(!dialog || !dialog->Open());
#endif
    return NS_OK;
  }

  if (DialogFormSubmission* dialogSubmission =
          submission->GetAsDialogSubmission()) {
    return SubmitDialog(dialogSubmission);
  }
  return SubmitSubmission(submission.get());
}

nsresult HTMLFormElement::BuildSubmission(HTMLFormSubmission** aFormSubmission,
                                          Event* aEvent) {
  NS_ASSERTION(!mPendingSubmission, "tried to build two submissions!");

  // Get the submitter element
  nsGenericHTMLElement* submitter = nullptr;
  if (aEvent) {
    SubmitEvent* submitEvent = aEvent->AsSubmitEvent();
    if (submitEvent) {
      submitter = submitEvent->GetSubmitter();
    }
  }

  nsresult rv;

  //
  // Walk over the form elements and call SubmitNamesValues() on them to get
  // their data.
  //
  auto encoding = GetSubmitEncoding()->OutputEncoding();
  RefPtr<FormData> formData =
      new FormData(GetOwnerGlobal(), encoding, submitter);
  rv = ConstructEntryList(formData);
  NS_ENSURE_SUBMIT_SUCCESS(rv);

  // Step 9. If form cannot navigate, then return.
  // https://html.spec.whatwg.org/multipage/form-control-infrastructure.html#form-submission-algorithm
  if (StaticPrefs::dom_formdata_event_enabled() && !GetComposedDoc()) {
    return NS_ERROR_NOT_AVAILABLE;
  }

  //
  // Get the submission object
  //
  rv = HTMLFormSubmission::GetFromForm(this, submitter, encoding,
                                       aFormSubmission);
  NS_ENSURE_SUBMIT_SUCCESS(rv);

  //
  // Dump the data into the submission object
  //
  if (!(*aFormSubmission)->GetAsDialogSubmission()) {
    rv = formData->CopySubmissionDataTo(*aFormSubmission);
    NS_ENSURE_SUBMIT_SUCCESS(rv);
  }

  return NS_OK;
}

nsresult HTMLFormElement::SubmitSubmission(
    HTMLFormSubmission* aFormSubmission) {
  nsresult rv;

  nsCOMPtr<nsIURI> actionURI = aFormSubmission->GetActionURL();
  if (!actionURI) {
    mIsSubmitting = false;
    return NS_OK;
  }

  // If there is no link handler, then we won't actually be able to submit.
  Document* doc = GetComposedDoc();
  nsCOMPtr<nsIDocShell> container = doc ? doc->GetDocShell() : nullptr;
  if (!container || IsEditable()) {
    mIsSubmitting = false;
    return NS_OK;
  }

  // javascript URIs are not really submissions; they just call a function.
  // Also, they may synchronously call submit(), and we want them to be able to
  // do so while still disallowing other double submissions. (Bug 139798)
  // Note that any other URI types that are of equivalent type should also be
  // added here.
  // XXXbz this is a mess.  The real issue here is that nsJSChannel sets the
  // LOAD_BACKGROUND flag, so doesn't notify us, compounded by the fact that
  // the JS executes before we forget the submission in OnStateChange on
  // STATE_STOP.  As a result, we have to make sure that we simply pretend
  // we're not submitting when submitting to a JS URL.  That's kinda bogus, but
  // there we are.
  bool schemeIsJavaScript = actionURI->SchemeIs("javascript");
  if (schemeIsJavaScript) {
    mIsSubmitting = false;
  }

  //
  // Notify observers of submit
  //
  bool cancelSubmit = false;
  if (mNotifiedObservers) {
    cancelSubmit = mNotifiedObserversResult;
  } else {
    rv = NotifySubmitObservers(actionURI, &cancelSubmit, true);
    NS_ENSURE_SUBMIT_SUCCESS(rv);
  }

  if (cancelSubmit) {
    mIsSubmitting = false;
    return NS_OK;
  }

  cancelSubmit = false;
  rv = NotifySubmitObservers(actionURI, &cancelSubmit, false);
  NS_ENSURE_SUBMIT_SUCCESS(rv);

  if (cancelSubmit) {
    mIsSubmitting = false;
    return NS_OK;
  }

  //
  // Submit
  //
  nsCOMPtr<nsIDocShell> docShell;

  {
    AutoPopupStatePusher popupStatePusher(mSubmitPopupState);

    AutoHandlingUserInputStatePusher userInpStatePusher(
        aFormSubmission->IsInitiatedFromUserInput());

    nsCOMPtr<nsIInputStream> postDataStream;
    rv = aFormSubmission->GetEncodedSubmission(
        actionURI, getter_AddRefs(postDataStream), actionURI);
    NS_ENSURE_SUBMIT_SUCCESS(rv);

    nsAutoString target;
    aFormSubmission->GetTarget(target);
    rv = nsDocShell::Cast(container)->OnLinkClickSync(
        this, actionURI, target, VoidString(), postDataStream, nullptr, false,
        getter_AddRefs(docShell), getter_AddRefs(mSubmittingRequest),
        aFormSubmission->IsInitiatedFromUserInput());
    NS_ENSURE_SUBMIT_SUCCESS(rv);
  }

  // Even if the submit succeeds, it's possible for there to be no docshell
  // or request; for example, if it's to a named anchor within the same page
  // the submit will not really do anything.
  if (docShell) {
    // If the channel is pending, we have to listen for web progress.
    bool pending = false;
    mSubmittingRequest->IsPending(&pending);
    if (pending && !schemeIsJavaScript) {
      nsCOMPtr<nsIWebProgress> webProgress = do_GetInterface(docShell);
      NS_ASSERTION(webProgress, "nsIDocShell not converted to nsIWebProgress!");
      rv = webProgress->AddProgressListener(this,
                                            nsIWebProgress::NOTIFY_STATE_ALL);
      NS_ENSURE_SUBMIT_SUCCESS(rv);
      mWebProgress = do_GetWeakReference(webProgress);
      NS_ASSERTION(mWebProgress, "can't hold weak ref to webprogress!");
    } else {
      ForgetCurrentSubmission();
    }
  } else {
    ForgetCurrentSubmission();
  }

  return rv;
}

// https://html.spec.whatwg.org/multipage/form-control-infrastructure.html#submit-dialog
nsresult HTMLFormElement::SubmitDialog(DialogFormSubmission* aFormSubmission) {
  mIsSubmitting = false;

  // Close the dialog subject. If there is a result, let that be the return
  // value.
  HTMLDialogElement* dialog = aFormSubmission->DialogElement();
  MOZ_ASSERT(dialog);

  Optional<nsAString> retValue;
  retValue = &aFormSubmission->ReturnValue();
  dialog->Close(retValue);

  return NS_OK;
}

nsresult HTMLFormElement::DoSecureToInsecureSubmitCheck(nsIURI* aActionURL,
                                                        bool* aCancelSubmit) {
  *aCancelSubmit = false;

  if (!StaticPrefs::security_warn_submit_secure_to_insecure()) {
    return NS_OK;
  }

  // Only ask the user about posting from a secure URI to an insecure URI if
  // this element is in the root document. When this is not the case, the mixed
  // content blocker will take care of security for us.
  Document* parent = OwnerDoc()->GetInProcessParentDocument();
  bool isRootDocument = (!parent || nsContentUtils::IsChromeDoc(parent));
  if (!isRootDocument) {
    return NS_OK;
  }

  nsIPrincipal* principal = NodePrincipal();
  if (!principal) {
    *aCancelSubmit = true;
    return NS_OK;
  }
  bool formIsHTTPS = principal->SchemeIs("https");
  if (principal->IsSystemPrincipal() || principal->GetIsExpandedPrincipal()) {
    formIsHTTPS = OwnerDoc()->GetDocumentURI()->SchemeIs("https");
  }
  if (!formIsHTTPS) {
    return NS_OK;
  }

  if (nsMixedContentBlocker::IsPotentiallyTrustworthyLoopbackURL(aActionURL)) {
    return NS_OK;
  }

  if (nsMixedContentBlocker::URISafeToBeLoadedInSecureContext(aActionURL)) {
    return NS_OK;
  }

  if (nsMixedContentBlocker::IsPotentiallyTrustworthyOnion(aActionURL)) {
    return NS_OK;
  }

  nsCOMPtr<nsPIDOMWindowOuter> window = OwnerDoc()->GetWindow();
  if (!window) {
    return NS_ERROR_FAILURE;
  }
  nsCOMPtr<nsIDocShell> docShell = window->GetDocShell();
  if (!docShell) {
    return NS_ERROR_FAILURE;
  }

  nsresult rv;
  nsCOMPtr<nsIPromptService> promptSvc =
      do_GetService("@mozilla.org/embedcomp/prompt-service;1", &rv);
  if (NS_FAILED(rv)) {
    return rv;
  }

  nsCOMPtr<nsIStringBundle> stringBundle;
  nsCOMPtr<nsIStringBundleService> stringBundleService =
      mozilla::services::GetStringBundleService();
  if (!stringBundleService) {
    return NS_ERROR_FAILURE;
  }
  rv = stringBundleService->CreateBundle(
      "chrome://global/locale/browser.properties",
      getter_AddRefs(stringBundle));
  if (NS_FAILED(rv)) {
    return rv;
  }
  nsAutoString title;
  nsAutoString message;
  nsAutoString cont;
  stringBundle->GetStringFromName("formPostSecureToInsecureWarning.title",
                                  title);
  stringBundle->GetStringFromName("formPostSecureToInsecureWarning.message",
                                  message);
  stringBundle->GetStringFromName("formPostSecureToInsecureWarning.continue",
                                  cont);
  int32_t buttonPressed;
  bool checkState =
      false;  // this is unused (ConfirmEx requires this parameter)
  rv = promptSvc->ConfirmExBC(
      docShell->GetBrowsingContext(),
      StaticPrefs::prompts_modalType_insecureFormSubmit(), title.get(),
      message.get(),
      (nsIPromptService::BUTTON_TITLE_IS_STRING *
       nsIPromptService::BUTTON_POS_0) +
          (nsIPromptService::BUTTON_TITLE_CANCEL *
           nsIPromptService::BUTTON_POS_1),
      cont.get(), nullptr, nullptr, nullptr, &checkState, &buttonPressed);
  if (NS_FAILED(rv)) {
    return rv;
  }
  *aCancelSubmit = (buttonPressed == 1);
  uint32_t telemetryBucket =
      nsISecurityUITelemetry::WARNING_CONFIRM_POST_TO_INSECURE_FROM_SECURE;
  mozilla::Telemetry::Accumulate(mozilla::Telemetry::SECURITY_UI,
                                 telemetryBucket);
  if (!*aCancelSubmit) {
    // The user opted to continue, so note that in the next telemetry bucket.
    mozilla::Telemetry::Accumulate(mozilla::Telemetry::SECURITY_UI,
                                   telemetryBucket + 1);
  }
  return NS_OK;
}

nsresult HTMLFormElement::NotifySubmitObservers(nsIURI* aActionURL,
                                                bool* aCancelSubmit,
                                                bool aEarlyNotify) {
  if (!aEarlyNotify) {
    nsresult rv = DoSecureToInsecureSubmitCheck(aActionURL, aCancelSubmit);
    if (NS_FAILED(rv)) {
      return rv;
    }
    if (*aCancelSubmit) {
      return NS_OK;
    }
  }

  bool defaultAction = true;
  nsresult rv = nsContentUtils::DispatchEventOnlyToChrome(
      OwnerDoc(), static_cast<nsINode*>(this),
      aEarlyNotify ? NS_LITERAL_STRING("DOMFormBeforeSubmit")
                   : NS_LITERAL_STRING("DOMFormSubmit"),
      CanBubble::eYes, Cancelable::eYes, &defaultAction);
  *aCancelSubmit = !defaultAction;
  if (*aCancelSubmit) {
    return NS_OK;
  }
  return rv;
}

nsresult HTMLFormElement::ConstructEntryList(FormData* aFormData) {
  MOZ_ASSERT(aFormData, "Must have FormData!");
  bool isFormDataEventEnabled = StaticPrefs::dom_formdata_event_enabled();
  if (isFormDataEventEnabled && mIsConstructingEntryList) {
    // Step 2.2 of https://xhr.spec.whatwg.org/#dom-formdata.
    return NS_ERROR_DOM_INVALID_STATE_ERR;
  }

  AutoRestore<bool> resetConstructingEntryList(mIsConstructingEntryList);
  mIsConstructingEntryList = true;
  // This shouldn't be called recursively, so use a rather large value
  // for the preallocated buffer.
  AutoTArray<RefPtr<nsGenericHTMLFormElement>, 100> sortedControls;
  nsresult rv = mControls->GetSortedControls(sortedControls);
  NS_ENSURE_SUCCESS(rv, rv);

  uint32_t len = sortedControls.Length();

  //
  // Walk the list of nodes and call SubmitNamesValues() on the controls
  //
  for (uint32_t i = 0; i < len; ++i) {
    // Tell the control to submit its name/value pairs to the submission
    sortedControls[i]->SubmitNamesValues(aFormData);
  }

  if (isFormDataEventEnabled) {
    FormDataEventInit init;
    init.mBubbles = true;
    init.mCancelable = false;
    init.mFormData = aFormData;
    RefPtr<FormDataEvent> event =
        FormDataEvent::Constructor(this, NS_LITERAL_STRING("formdata"), init);
    event->SetTrusted(true);

    EventDispatcher::DispatchDOMEvent(ToSupports(this), nullptr, event, nullptr,
                                      nullptr);
  }

  return NS_OK;
}

NotNull<const Encoding*> HTMLFormElement::GetSubmitEncoding() {
  nsAutoString acceptCharsetValue;
  GetAttr(kNameSpaceID_None, nsGkAtoms::acceptcharset, acceptCharsetValue);

  int32_t charsetLen = acceptCharsetValue.Length();
  if (charsetLen > 0) {
    int32_t offset = 0;
    int32_t spPos = 0;
    // get charset from charsets one by one
    do {
      spPos = acceptCharsetValue.FindChar(char16_t(' '), offset);
      int32_t cnt = ((-1 == spPos) ? (charsetLen - offset) : (spPos - offset));
      if (cnt > 0) {
        nsAutoString uCharset;
        acceptCharsetValue.Mid(uCharset, offset, cnt);

        auto encoding = Encoding::ForLabelNoReplacement(uCharset);
        if (encoding) {
          return WrapNotNull(encoding);
        }
      }
      offset = spPos + 1;
    } while (spPos != -1);
  }
  // if there are no accept-charset or all the charset are not supported
  // Get the charset from document
  Document* doc = GetComposedDoc();
  if (doc) {
    return doc->GetDocumentCharacterSet();
  }
  return UTF_8_ENCODING;
}

// nsIForm

NS_IMETHODIMP_(uint32_t)
HTMLFormElement::GetElementCount() const { return mControls->Length(); }

Element* HTMLFormElement::IndexedGetter(uint32_t aIndex, bool& aFound) {
  Element* element = mControls->mElements.SafeElementAt(aIndex, nullptr);
  aFound = element != nullptr;
  return element;
}

NS_IMETHODIMP_(nsIFormControl*)
HTMLFormElement::GetElementAt(int32_t aIndex) const {
  return mControls->mElements.SafeElementAt(aIndex, nullptr);
}

/**
 * Compares the position of aControl1 and aControl2 in the document
 * @param aControl1 First control to compare.
 * @param aControl2 Second control to compare.
 * @param aForm Parent form of the controls.
 * @return < 0 if aControl1 is before aControl2,
 *         > 0 if aControl1 is after aControl2,
 *         0 otherwise
 */
/* static */
int32_t HTMLFormElement::CompareFormControlPosition(Element* aElement1,
                                                    Element* aElement2,
                                                    const nsIContent* aForm) {
  NS_ASSERTION(aElement1 != aElement2, "Comparing a form control to itself");

  // If an element has a @form, we can assume it *might* be able to not have
  // a parent and still be in the form.
  NS_ASSERTION((aElement1->HasAttr(kNameSpaceID_None, nsGkAtoms::form) ||
                aElement1->GetParent()) &&
                   (aElement2->HasAttr(kNameSpaceID_None, nsGkAtoms::form) ||
                    aElement2->GetParent()),
               "Form controls should always have parents");

  // If we pass aForm, we are assuming both controls are form descendants which
  // is not always the case. This function should work but maybe slower.
  // However, checking if both elements are form descendants may be slow too...
  // TODO: remove the prevent asserts fix, see bug 598468.
#ifdef DEBUG
  nsLayoutUtils::gPreventAssertInCompareTreePosition = true;
  int32_t rVal =
      nsLayoutUtils::CompareTreePosition(aElement1, aElement2, aForm);
  nsLayoutUtils::gPreventAssertInCompareTreePosition = false;

  return rVal;
#else   // DEBUG
  return nsLayoutUtils::CompareTreePosition(aElement1, aElement2, aForm);
#endif  // DEBUG
}

#ifdef DEBUG
/**
 * Checks that all form elements are in document order. Asserts if any pair of
 * consecutive elements are not in increasing document order.
 *
 * @param aControls List of form controls to check.
 * @param aForm Parent form of the controls.
 */
/* static */
void HTMLFormElement::AssertDocumentOrder(
    const nsTArray<nsGenericHTMLFormElement*>& aControls, nsIContent* aForm) {
  // TODO: remove the return statement with bug 598468.
  // This is done to prevent asserts in some edge cases.
  return;

  // Only iterate if aControls is not empty, since otherwise
  // |aControls.Length() - 1| will be a very large unsigned number... not what
  // we want here.
  if (!aControls.IsEmpty()) {
    for (uint32_t i = 0; i < aControls.Length() - 1; ++i) {
      NS_ASSERTION(
          CompareFormControlPosition(aControls[i], aControls[i + 1], aForm) < 0,
          "Form controls not ordered correctly");
    }
  }
}

/**
 * Copy of the above function, but with RefPtrs.
 *
 * @param aControls List of form controls to check.
 * @param aForm Parent form of the controls.
 */
/* static */
void HTMLFormElement::AssertDocumentOrder(
    const nsTArray<RefPtr<nsGenericHTMLFormElement>>& aControls,
    nsIContent* aForm) {
  // TODO: remove the return statement with bug 598468.
  // This is done to prevent asserts in some edge cases.
  return;

  // Only iterate if aControls is not empty, since otherwise
  // |aControls.Length() - 1| will be a very large unsigned number... not what
  // we want here.
  if (!aControls.IsEmpty()) {
    for (uint32_t i = 0; i < aControls.Length() - 1; ++i) {
      NS_ASSERTION(
          CompareFormControlPosition(aControls[i], aControls[i + 1], aForm) < 0,
          "Form controls not ordered correctly");
    }
  }
}
#endif

void HTMLFormElement::PostPasswordEvent() {
  // Don't fire another add event if we have a pending add event.
  if (mFormPasswordEventDispatcher.get()) {
    return;
  }

  mFormPasswordEventDispatcher =
      new AsyncEventDispatcher(this, NS_LITERAL_STRING("DOMFormHasPassword"),
                               CanBubble::eYes, ChromeOnlyDispatch::eYes);
  mFormPasswordEventDispatcher->PostDOMEvent();
}

namespace {

struct FormComparator {
  Element* const mChild;
  HTMLFormElement* const mForm;
  FormComparator(Element* aChild, HTMLFormElement* aForm)
      : mChild(aChild), mForm(aForm) {}
  int operator()(Element* aElement) const {
    return HTMLFormElement::CompareFormControlPosition(mChild, aElement, mForm);
  }
};

}  // namespace

// This function return true if the element, once appended, is the last one in
// the array.
template <typename ElementType>
static bool AddElementToList(nsTArray<ElementType*>& aList, ElementType* aChild,
                             HTMLFormElement* aForm) {
  NS_ASSERTION(aList.IndexOf(aChild) == aList.NoIndex,
               "aChild already in aList");

  const uint32_t count = aList.Length();
  ElementType* element;
  bool lastElement = false;

  // Optimize most common case where we insert at the end.
  int32_t position = -1;
  if (count > 0) {
    element = aList[count - 1];
    position =
        HTMLFormElement::CompareFormControlPosition(aChild, element, aForm);
  }

  // If this item comes after the last element, or the elements array is
  // empty, we append to the end. Otherwise, we do a binary search to
  // determine where the element should go.
  if (position >= 0 || count == 0) {
    // WEAK - don't addref
    aList.AppendElement(aChild);
    lastElement = true;
  } else {
    size_t idx;
    BinarySearchIf(aList, 0, count, FormComparator(aChild, aForm), &idx);

    // WEAK - don't addref
    aList.InsertElementAt(idx, aChild);
  }

  return lastElement;
}

nsresult HTMLFormElement::AddElement(nsGenericHTMLFormElement* aChild,
                                     bool aUpdateValidity, bool aNotify) {
  // If an element has a @form, we can assume it *might* be able to not have
  // a parent and still be in the form.
  NS_ASSERTION(aChild->HasAttr(kNameSpaceID_None, nsGkAtoms::form) ||
                   aChild->GetParent(),
               "Form control should have a parent");

  // Determine whether to add the new element to the elements or
  // the not-in-elements list.
  bool childInElements = HTMLFormControlsCollection::ShouldBeInElements(aChild);
  nsTArray<nsGenericHTMLFormElement*>& controlList =
      childInElements ? mControls->mElements : mControls->mNotInElements;

  bool lastElement = AddElementToList(controlList, aChild, this);

#ifdef DEBUG
  AssertDocumentOrder(controlList, this);
#endif

  int32_t type = aChild->ControlType();

  // If it is a password control, inform the password manager.
  if (type == NS_FORM_INPUT_PASSWORD) {
    PostPasswordEvent();
  }

  // Default submit element handling
  if (aChild->IsSubmitControl()) {
    // Update mDefaultSubmitElement, mFirstSubmitInElements,
    // mFirstSubmitNotInElements.

    nsGenericHTMLFormElement** firstSubmitSlot =
        childInElements ? &mFirstSubmitInElements : &mFirstSubmitNotInElements;

    // The new child is the new first submit in its list if the firstSubmitSlot
    // is currently empty or if the child is before what's currently in the
    // slot.  Note that if we already have a control in firstSubmitSlot and
    // we're appending this element can't possibly replace what's currently in
    // the slot.  Also note that aChild can't become the mDefaultSubmitElement
    // unless it replaces what's in the slot.  If it _does_ replace what's in
    // the slot, it becomes the default submit if either the default submit is
    // what's in the slot or the child is earlier than the default submit.
    nsGenericHTMLFormElement* oldDefaultSubmit = mDefaultSubmitElement;
    if (!*firstSubmitSlot ||
        (!lastElement &&
         CompareFormControlPosition(aChild, *firstSubmitSlot, this) < 0)) {
      // Update mDefaultSubmitElement if it's currently in a valid state.
      // Valid state means either non-null or null because there are in fact
      // no submit elements around.
      if ((mDefaultSubmitElement ||
           (!mFirstSubmitInElements && !mFirstSubmitNotInElements)) &&
          (*firstSubmitSlot == mDefaultSubmitElement ||
           CompareFormControlPosition(aChild, mDefaultSubmitElement, this) <
               0)) {
        mDefaultSubmitElement = aChild;
      }
      *firstSubmitSlot = aChild;
    }

    MOZ_ASSERT(mDefaultSubmitElement == mFirstSubmitInElements ||
                   mDefaultSubmitElement == mFirstSubmitNotInElements ||
                   !mDefaultSubmitElement,
               "What happened here?");

    // Notify that the state of the previous default submit element has changed
    // if the element which is the default submit element has changed.  The new
    // default submit element is responsible for its own state update.
    if (oldDefaultSubmit && oldDefaultSubmit != mDefaultSubmitElement) {
      oldDefaultSubmit->UpdateState(aNotify);
    }
  }

  // If the element is subject to constraint validaton and is invalid, we need
  // to update our internal counter.
  if (aUpdateValidity) {
    nsCOMPtr<nsIConstraintValidation> cvElmt = do_QueryObject(aChild);
    if (cvElmt && cvElmt->IsCandidateForConstraintValidation() &&
        !cvElmt->IsValid()) {
      UpdateValidity(false);
    }
  }

  // Notify the radio button it's been added to a group
  // This has to be done _after_ UpdateValidity() call to prevent the element
  // being count twice.
  if (type == NS_FORM_INPUT_RADIO) {
    RefPtr<HTMLInputElement> radio = static_cast<HTMLInputElement*>(aChild);
    radio->AddedToRadioGroup();
  }

  return NS_OK;
}

nsresult HTMLFormElement::AddElementToTable(nsGenericHTMLFormElement* aChild,
                                            const nsAString& aName) {
  return mControls->AddElementToTable(aChild, aName);
}

nsresult HTMLFormElement::RemoveElement(nsGenericHTMLFormElement* aChild,
                                        bool aUpdateValidity) {
  RemoveElementFromPastNamesMap(aChild);

  //
  // Remove it from the radio group if it's a radio button
  //
  nsresult rv = NS_OK;
  if (aChild->ControlType() == NS_FORM_INPUT_RADIO) {
    RefPtr<HTMLInputElement> radio = static_cast<HTMLInputElement*>(aChild);
    radio->WillRemoveFromRadioGroup();
  }

  // Determine whether to remove the child from the elements list
  // or the not in elements list.
  bool childInElements = HTMLFormControlsCollection::ShouldBeInElements(aChild);
  nsTArray<nsGenericHTMLFormElement*>& controls =
      childInElements ? mControls->mElements : mControls->mNotInElements;

  // Find the index of the child. This will be used later if necessary
  // to find the default submit.
  size_t index = controls.IndexOf(aChild);
  NS_ENSURE_STATE(index != controls.NoIndex);

  controls.RemoveElementAt(index);

  // Update our mFirstSubmit* values.
  nsGenericHTMLFormElement** firstSubmitSlot =
      childInElements ? &mFirstSubmitInElements : &mFirstSubmitNotInElements;
  if (aChild == *firstSubmitSlot) {
    *firstSubmitSlot = nullptr;

    // We are removing the first submit in this list, find the new first submit
    uint32_t length = controls.Length();
    for (uint32_t i = index; i < length; ++i) {
      nsGenericHTMLFormElement* currentControl = controls[i];
      if (currentControl->IsSubmitControl()) {
        *firstSubmitSlot = currentControl;
        break;
      }
    }
  }

  if (aChild == mDefaultSubmitElement) {
    // Need to reset mDefaultSubmitElement.  Do this asynchronously so
    // that we're not doing it while the DOM is in flux.
    mDefaultSubmitElement = nullptr;
    nsContentUtils::AddScriptRunner(new RemoveElementRunnable(this));

    // Note that we don't need to notify on the old default submit (which is
    // being removed) because it's either being removed from the DOM or
    // changing attributes in a way that makes it responsible for sending its
    // own notifications.
  }

  // If the element was subject to constraint validaton and is invalid, we need
  // to update our internal counter.
  if (aUpdateValidity) {
    nsCOMPtr<nsIConstraintValidation> cvElmt = do_QueryObject(aChild);
    if (cvElmt && cvElmt->IsCandidateForConstraintValidation() &&
        !cvElmt->IsValid()) {
      UpdateValidity(true);
    }
  }

  return rv;
}

void HTMLFormElement::HandleDefaultSubmitRemoval() {
  if (mDefaultSubmitElement) {
    // Already got reset somehow; nothing else to do here
    return;
  }

  if (!mFirstSubmitNotInElements) {
    mDefaultSubmitElement = mFirstSubmitInElements;
  } else if (!mFirstSubmitInElements) {
    mDefaultSubmitElement = mFirstSubmitNotInElements;
  } else {
    NS_ASSERTION(mFirstSubmitInElements != mFirstSubmitNotInElements,
                 "How did that happen?");
    // Have both; use the earlier one
    mDefaultSubmitElement =
        CompareFormControlPosition(mFirstSubmitInElements,
                                   mFirstSubmitNotInElements, this) < 0
            ? mFirstSubmitInElements
            : mFirstSubmitNotInElements;
  }

  MOZ_ASSERT(mDefaultSubmitElement == mFirstSubmitInElements ||
                 mDefaultSubmitElement == mFirstSubmitNotInElements,
             "What happened here?");

  // Notify about change if needed.
  if (mDefaultSubmitElement) {
    mDefaultSubmitElement->UpdateState(true);
  }
}

nsresult HTMLFormElement::RemoveElementFromTableInternal(
    nsInterfaceHashtable<nsStringHashKey, nsISupports>& aTable,
    nsIContent* aChild, const nsAString& aName) {
  auto entry = aTable.Lookup(aName);
  if (!entry) {
    return NS_OK;
  }
  // Single element in the hash, just remove it if it's the one
  // we're trying to remove...
  if (entry.Data() == aChild) {
    entry.Remove();
    ++mExpandoAndGeneration.generation;
    return NS_OK;
  }

  nsCOMPtr<nsIContent> content(do_QueryInterface(entry.Data()));
  if (content) {
    return NS_OK;
  }

  // If it's not a content node then it must be a RadioNodeList.
  MOZ_ASSERT(nsCOMPtr<RadioNodeList>(do_QueryInterface(entry.Data())));
  auto* list = static_cast<RadioNodeList*>(entry.Data().get());

  list->RemoveElement(aChild);

  uint32_t length = list->Length();

  if (!length) {
    // If the list is empty we remove if from our hash, this shouldn't
    // happen tho
    entry.Remove();
    ++mExpandoAndGeneration.generation;
  } else if (length == 1) {
    // Only one element left, replace the list in the hash with the
    // single element.
    nsIContent* node = list->Item(0);
    if (node) {
      entry.Data() = node;
    }
  }

  return NS_OK;
}

nsresult HTMLFormElement::RemoveElementFromTable(
    nsGenericHTMLFormElement* aElement, const nsAString& aName) {
  return mControls->RemoveElementFromTable(aElement, aName);
}

already_AddRefed<nsISupports> HTMLFormElement::NamedGetter(
    const nsAString& aName, bool& aFound) {
  aFound = true;

  nsCOMPtr<nsISupports> result = DoResolveName(aName, true);
  if (result) {
    AddToPastNamesMap(aName, result);
    return result.forget();
  }

  result = mImageNameLookupTable.GetWeak(aName);
  if (result) {
    AddToPastNamesMap(aName, result);
    return result.forget();
  }

  result = mPastNameLookupTable.GetWeak(aName);
  if (result) {
    return result.forget();
  }

  aFound = false;
  return nullptr;
}

void HTMLFormElement::GetSupportedNames(nsTArray<nsString>& aRetval) {
  // TODO https://github.com/whatwg/html/issues/1731
}

already_AddRefed<nsISupports> HTMLFormElement::FindNamedItem(
    const nsAString& aName, nsWrapperCache** aCache) {
  // FIXME Get the wrapper cache from DoResolveName.

  bool found;
  nsCOMPtr<nsISupports> result = NamedGetter(aName, found);
  if (result) {
    *aCache = nullptr;
    return result.forget();
  }

  return nullptr;
}

already_AddRefed<nsISupports> HTMLFormElement::DoResolveName(
    const nsAString& aName, bool aFlushContent) {
  nsCOMPtr<nsISupports> result =
      mControls->NamedItemInternal(aName, aFlushContent);
  return result.forget();
}

void HTMLFormElement::OnSubmitClickBegin(Element* aOriginatingElement) {
  mDeferSubmission = true;

  // Prepare to run NotifySubmitObservers early before the
  // scripts on the page get to modify the form data, possibly
  // throwing off any password manager. (bug 257781)
  nsCOMPtr<nsIURI> actionURI;
  nsresult rv;

  rv = GetActionURL(getter_AddRefs(actionURI), aOriginatingElement);
  if (NS_FAILED(rv) || !actionURI) return;

  // Notify observers of submit if the form is valid.
  // TODO: checking for mInvalidElementsCount is a temporary fix that should be
  // removed with bug 610402.
  if (mInvalidElementsCount == 0) {
    bool cancelSubmit = false;
    rv = NotifySubmitObservers(actionURI, &cancelSubmit, true);
    if (NS_SUCCEEDED(rv)) {
      mNotifiedObservers = true;
      mNotifiedObserversResult = cancelSubmit;
    }
  }
}

void HTMLFormElement::OnSubmitClickEnd() { mDeferSubmission = false; }

void HTMLFormElement::FlushPendingSubmission() {
  if (mPendingSubmission) {
    // Transfer owning reference so that the submission doesn't get deleted
    // if we reenter
    UniquePtr<HTMLFormSubmission> submission = std::move(mPendingSubmission);

    SubmitSubmission(submission.get());
  }
}

void HTMLFormElement::GetAction(nsString& aValue) {
  if (!GetAttr(kNameSpaceID_None, nsGkAtoms::action, aValue) ||
      aValue.IsEmpty()) {
    Document* document = OwnerDoc();
    nsIURI* docURI = document->GetDocumentURI();
    if (docURI) {
      nsAutoCString spec;
      nsresult rv = docURI->GetSpec(spec);
      if (NS_FAILED(rv)) {
        return;
      }

      CopyUTF8toUTF16(spec, aValue);
    }
  } else {
    GetURIAttr(nsGkAtoms::action, nullptr, aValue);
  }
}

nsresult HTMLFormElement::GetActionURL(nsIURI** aActionURL,
                                       Element* aOriginatingElement) {
  nsresult rv = NS_OK;

  *aActionURL = nullptr;

  //
  // Grab the URL string
  //
  // If the originating element is a submit control and has the formaction
  // attribute specified, it should be used. Otherwise, the action attribute
  // from the form element should be used.
  //
  nsAutoString action;

  if (aOriginatingElement &&
      aOriginatingElement->HasAttr(kNameSpaceID_None, nsGkAtoms::formaction)) {
#ifdef DEBUG
    nsCOMPtr<nsIFormControl> formControl =
        do_QueryInterface(aOriginatingElement);
    NS_ASSERTION(formControl && formControl->IsSubmitControl(),
                 "The originating element must be a submit form control!");
#endif  // DEBUG

    HTMLInputElement* inputElement =
        HTMLInputElement::FromNode(aOriginatingElement);
    if (inputElement) {
      inputElement->GetFormAction(action);
    } else {
      auto buttonElement = HTMLButtonElement::FromNode(aOriginatingElement);
      if (buttonElement) {
        buttonElement->GetFormAction(action);
      } else {
        NS_ERROR("Originating element must be an input or button element!");
        return NS_ERROR_UNEXPECTED;
      }
    }
  } else {
    GetAction(action);
  }

  //
  // Form the full action URL
  //

  // Get the document to form the URL.
  // We'll also need it later to get the DOM window when notifying form submit
  // observers (bug 33203)
  if (!IsInComposedDoc()) {
    return NS_OK;  // No doc means don't submit, see Bug 28988
  }

  // Get base URL
  Document* document = OwnerDoc();
  nsIURI* docURI = document->GetDocumentURI();
  NS_ENSURE_TRUE(docURI, NS_ERROR_UNEXPECTED);

  // If an action is not specified and we are inside
  // a HTML document then reload the URL. This makes us
  // compatible with 4.x browsers.
  // If we are in some other type of document such as XML or
  // XUL, do nothing. This prevents undesirable reloading of
  // a document inside XUL.

  nsCOMPtr<nsIURI> actionURL;
  if (action.IsEmpty()) {
    if (!document->IsHTMLOrXHTML()) {
      // Must be a XML, XUL or other non-HTML document type
      // so do nothing.
      return NS_OK;
    }

    actionURL = docURI;
  } else {
    nsIURI* baseURL = GetBaseURI();
    NS_ASSERTION(baseURL, "No Base URL found in Form Submit!\n");
    if (!baseURL) {
      return NS_OK;  // No base URL -> exit early, see Bug 30721
    }
    rv = NS_NewURI(getter_AddRefs(actionURL), action, nullptr, baseURL);
    NS_ENSURE_SUCCESS(rv, rv);
  }

  //
  // Verify the URL should be reached
  //
  // Get security manager, check to see if access to action URI is allowed.
  //
  nsIScriptSecurityManager* securityManager =
      nsContentUtils::GetSecurityManager();
  rv = securityManager->CheckLoadURIWithPrincipal(
      NodePrincipal(), actionURL, nsIScriptSecurityManager::STANDARD,
      OwnerDoc()->InnerWindowID());
  NS_ENSURE_SUCCESS(rv, rv);

  // Potentially the page uses the CSP directive 'upgrade-insecure-requests'. In
  // such a case we have to upgrade the action url from http:// to https://.
  // If the actionURL is not http, then there is nothing to do.
  bool isHttpScheme = actionURL->SchemeIs("http");
  if (isHttpScheme && document->GetUpgradeInsecureRequests(false)) {
    // let's use the old specification before the upgrade for logging
    AutoTArray<nsString, 2> params;
    nsAutoCString spec;
    rv = actionURL->GetSpec(spec);
    NS_ENSURE_SUCCESS(rv, rv);
    CopyUTF8toUTF16(spec, *params.AppendElement());

    // upgrade the actionURL from http:// to use https://
    nsCOMPtr<nsIURI> upgradedActionURL;
    rv = NS_GetSecureUpgradedURI(actionURL, getter_AddRefs(upgradedActionURL));
    NS_ENSURE_SUCCESS(rv, rv);
    actionURL = std::move(upgradedActionURL);

    // let's log a message to the console that we are upgrading a request
    nsAutoCString scheme;
    rv = actionURL->GetScheme(scheme);
    NS_ENSURE_SUCCESS(rv, rv);
    CopyUTF8toUTF16(scheme, *params.AppendElement());

    CSP_LogLocalizedStr(
        "upgradeInsecureRequest", params,
        EmptyString(),  // aSourceFile
        EmptyString(),  // aScriptSample
        0,              // aLineNumber
        0,              // aColumnNumber
        nsIScriptError::warningFlag,
        NS_LITERAL_CSTRING("upgradeInsecureRequest"), document->InnerWindowID(),
        !!document->NodePrincipal()->OriginAttributesRef().mPrivateBrowsingId);
  }

  //
  // Assign to the output
  //
  actionURL.forget(aActionURL);

  return rv;
}

NS_IMETHODIMP_(nsIFormControl*)
HTMLFormElement::GetDefaultSubmitElement() const {
  MOZ_ASSERT(mDefaultSubmitElement == mFirstSubmitInElements ||
                 mDefaultSubmitElement == mFirstSubmitNotInElements,
             "What happened here?");

  return mDefaultSubmitElement;
}

bool HTMLFormElement::IsDefaultSubmitElement(
    const nsIFormControl* aControl) const {
  MOZ_ASSERT(aControl, "Unexpected call");

  if (aControl == mDefaultSubmitElement) {
    // Yes, it is
    return true;
  }

  if (mDefaultSubmitElement || (aControl != mFirstSubmitInElements &&
                                aControl != mFirstSubmitNotInElements)) {
    // It isn't
    return false;
  }

  // mDefaultSubmitElement is null, but we have a non-null submit around
  // (aControl, in fact).  figure out whether it's in fact the default submit
  // and just hasn't been set that way yet.  Note that we can't just call
  // HandleDefaultSubmitRemoval because we might need to notify to handle that
  // correctly and we don't know whether that's safe right here.
  if (!mFirstSubmitInElements || !mFirstSubmitNotInElements) {
    // We only have one first submit; aControl has to be it
    return true;
  }

  // We have both kinds of submits.  Check which comes first.
  nsIFormControl* defaultSubmit =
      CompareFormControlPosition(mFirstSubmitInElements,
                                 mFirstSubmitNotInElements, this) < 0
          ? mFirstSubmitInElements
          : mFirstSubmitNotInElements;
  return aControl == defaultSubmit;
}

bool HTMLFormElement::ImplicitSubmissionIsDisabled() const {
  // Input text controls are always in the elements list.
  uint32_t numDisablingControlsFound = 0;
  uint32_t length = mControls->mElements.Length();
  for (uint32_t i = 0; i < length && numDisablingControlsFound < 2; ++i) {
    if (mControls->mElements[i]->IsSingleLineTextControl(false)) {
      numDisablingControlsFound++;
    }
  }
  return numDisablingControlsFound != 1;
}

bool HTMLFormElement::IsLastActiveElement(
    const nsIFormControl* aControl) const {
  MOZ_ASSERT(aControl, "Unexpected call");

  for (auto* element : Reversed(mControls->mElements)) {
    // XXX How about date/time control?
    if (element->IsTextControl(false) && !element->IsDisabled()) {
      return element == aControl;
    }
  }
  return false;
}

int32_t HTMLFormElement::Length() { return mControls->Length(); }

void HTMLFormElement::ForgetCurrentSubmission() {
  mNotifiedObservers = false;
  mIsSubmitting = false;
  mSubmittingRequest = nullptr;
  nsCOMPtr<nsIWebProgress> webProgress = do_QueryReferent(mWebProgress);
  if (webProgress) {
    webProgress->RemoveProgressListener(this);
  }
  mWebProgress = nullptr;
}

bool HTMLFormElement::CheckFormValidity(
    nsTArray<RefPtr<Element>>* aInvalidElements) const {
  bool ret = true;

  // This shouldn't be called recursively, so use a rather large value
  // for the preallocated buffer.
  AutoTArray<RefPtr<nsGenericHTMLFormElement>, 100> sortedControls;
  if (NS_FAILED(mControls->GetSortedControls(sortedControls))) {
    return false;
  }

  uint32_t len = sortedControls.Length();

  for (uint32_t i = 0; i < len; ++i) {
    nsCOMPtr<nsIConstraintValidation> cvElmt =
        do_QueryObject(sortedControls[i]);
    if (cvElmt && cvElmt->IsCandidateForConstraintValidation() &&
        !cvElmt->IsValid()) {
      ret = false;
      bool defaultAction = true;
      nsContentUtils::DispatchTrustedEvent(
          sortedControls[i]->OwnerDoc(),
          static_cast<nsIContent*>(sortedControls[i]),
          NS_LITERAL_STRING("invalid"), CanBubble::eNo, Cancelable::eYes,
          &defaultAction);

      // Add all unhandled invalid controls to aInvalidElements if the caller
      // requested them.
      if (defaultAction && aInvalidElements) {
        aInvalidElements->AppendElement(sortedControls[i]);
      }
    }
  }

  return ret;
}

bool HTMLFormElement::CheckValidFormSubmission() {
  /**
   * Check for form validity: do not submit a form if there are unhandled
   * invalid controls in the form.
   * This should not be done if the form has been submitted with .submit().
   *
   * NOTE: for the moment, we are also checking that there is an observer for
   * NS_INVALIDFORMSUBMIT_SUBJECT so it will prevent blocking form submission
   * if the browser does not have implemented a UI yet.
   *
   * TODO: the check for observer should be removed later when HTML5 Forms will
   * be spread enough and authors will assume forms can't be submitted when
   * invalid. See bug 587671.
   */

  NS_ASSERTION(!HasAttr(kNameSpaceID_None, nsGkAtoms::novalidate),
               "We shouldn't be there if novalidate is set!");

  // When .submit() is called aEvent = nullptr so we can rely on that to know if
  // we have to check the validity of the form.
  nsCOMPtr<nsIObserverService> service =
      mozilla::services::GetObserverService();
  if (!service) {
    NS_WARNING("No observer service available!");
    return true;
  }

  AutoTArray<RefPtr<Element>, 32> invalidElements;
  if (CheckFormValidity(&invalidElements)) {
    return true;
  }

  // For the first invalid submission, we should update element states.
  // We have to do that _before_ calling the observers so we are sure they
  // will not interfere (like focusing the element).
  if (!mEverTriedInvalidSubmit) {
    mEverTriedInvalidSubmit = true;

    /*
     * We are going to call update states assuming elements want to
     * be notified because we can't know.
     * Submissions shouldn't happen during parsing so it _should_ be safe.
     */

    nsAutoScriptBlocker scriptBlocker;

    for (uint32_t i = 0, length = mControls->mElements.Length(); i < length;
         ++i) {
      // Input elements can trigger a form submission and we want to
      // update the style in that case.
      if (mControls->mElements[i]->IsHTMLElement(nsGkAtoms::input) &&
          // We don't use nsContentUtils::IsFocusedContent here, because it
          // doesn't really do what we want for number controls: it's true
          // for the anonymous textnode inside, but not the number control
          // itself.  We can use the focus state, though, because that gets
          // synced to the number control by the anonymous text control.
          mControls->mElements[i]->State().HasState(NS_EVENT_STATE_FOCUS)) {
        static_cast<HTMLInputElement*>(mControls->mElements[i])
            ->UpdateValidityUIBits(true);
      }

      mControls->mElements[i]->UpdateState(true);
    }

    // Because of backward compatibility, <input type='image'> is not in
    // elements but can be invalid.
    // TODO: should probably be removed when bug 606491 will be fixed.
    for (uint32_t i = 0, length = mControls->mNotInElements.Length();
         i < length; ++i) {
      mControls->mNotInElements[i]->UpdateState(true);
    }
  }

  AutoJSAPI jsapi;
  if (!jsapi.Init(GetOwnerGlobal())) {
    return false;
  }
  JS::Rooted<JS::Value> detail(jsapi.cx());
  if (!ToJSValue(jsapi.cx(), invalidElements, &detail)) {
    return false;
  }

  RefPtr<CustomEvent> event =
      NS_NewDOMCustomEvent(OwnerDoc(), nullptr, nullptr);
  event->InitCustomEvent(jsapi.cx(), NS_LITERAL_STRING("MozInvalidForm"),
                         /* CanBubble */ true,
                         /* Cancelable */ true, detail);
  event->SetTrusted(true);
  event->WidgetEventPtr()->mFlags.mOnlyChromeDispatch = true;

  DispatchEvent(*event);

  bool result = !event->DefaultPrevented();

  nsCOMPtr<nsISimpleEnumerator> theEnum;
  nsresult rv = service->EnumerateObservers(NS_INVALIDFORMSUBMIT_SUBJECT,
                                            getter_AddRefs(theEnum));
  NS_ENSURE_SUCCESS(rv, result);

  bool hasObserver = false;
  rv = theEnum->HasMoreElements(&hasObserver);

  if (NS_SUCCEEDED(rv) && hasObserver) {
    result = false;

    nsCOMPtr<nsISupports> inst;
    nsCOMPtr<nsIFormSubmitObserver> observer;
    bool more = true;
    while (NS_SUCCEEDED(theEnum->HasMoreElements(&more)) && more) {
      theEnum->GetNext(getter_AddRefs(inst));
      observer = do_QueryInterface(inst);

      if (observer) {
        observer->NotifyInvalidSubmit(this, invalidElements);
      }
    }
  }

  if (result) {
    NS_WARNING(
        "There is no observer for \"invalidformsubmit\". \
One should be implemented!");
  }

  return result;
}

void HTMLFormElement::UpdateValidity(bool aElementValidity) {
  if (aElementValidity) {
    --mInvalidElementsCount;
  } else {
    ++mInvalidElementsCount;
  }

  NS_ASSERTION(mInvalidElementsCount >= 0, "Something went seriously wrong!");

  // The form validity has just changed if:
  // - there are no more invalid elements ;
  // - or there is one invalid elmement and an element just became invalid.
  // If we have invalid elements and we used to before as well, do nothing.
  if (mInvalidElementsCount &&
      (mInvalidElementsCount != 1 || aElementValidity)) {
    return;
  }

  /*
   * We are going to update states assuming submit controls want to
   * be notified because we can't know.
   * UpdateValidity shouldn't be called so much during parsing so it _should_
   * be safe.
   */

  nsAutoScriptBlocker scriptBlocker;

  // Inform submit controls that the form validity has changed.
  for (uint32_t i = 0, length = mControls->mElements.Length(); i < length;
       ++i) {
    if (mControls->mElements[i]->IsSubmitControl()) {
      mControls->mElements[i]->UpdateState(true);
    }
  }

  // Because of backward compatibility, <input type='image'> is not in elements
  // so we have to check for controls not in elements too.
  uint32_t length = mControls->mNotInElements.Length();
  for (uint32_t i = 0; i < length; ++i) {
    if (mControls->mNotInElements[i]->IsSubmitControl()) {
      mControls->mNotInElements[i]->UpdateState(true);
    }
  }

  UpdateState(true);
}

// nsIWebProgressListener
NS_IMETHODIMP
HTMLFormElement::OnStateChange(nsIWebProgress* aWebProgress,
                               nsIRequest* aRequest, uint32_t aStateFlags,
                               nsresult aStatus) {
  // If STATE_STOP is never fired for any reason (redirect?  Failed state
  // change?) the form element will leak.  It will be kept around by the
  // nsIWebProgressListener (assuming it keeps a strong pointer).  We will
  // consequently leak the request.
  if (aRequest == mSubmittingRequest &&
      aStateFlags & nsIWebProgressListener::STATE_STOP) {
    ForgetCurrentSubmission();
  }

  return NS_OK;
}

NS_IMETHODIMP
HTMLFormElement::OnProgressChange(nsIWebProgress* aWebProgress,
                                  nsIRequest* aRequest,
                                  int32_t aCurSelfProgress,
                                  int32_t aMaxSelfProgress,
                                  int32_t aCurTotalProgress,
                                  int32_t aMaxTotalProgress) {
  MOZ_ASSERT_UNREACHABLE("notification excluded in AddProgressListener(...)");
  return NS_OK;
}

NS_IMETHODIMP
HTMLFormElement::OnLocationChange(nsIWebProgress* aWebProgress,
                                  nsIRequest* aRequest, nsIURI* location,
                                  uint32_t aFlags) {
  MOZ_ASSERT_UNREACHABLE("notification excluded in AddProgressListener(...)");
  return NS_OK;
}

NS_IMETHODIMP
HTMLFormElement::OnStatusChange(nsIWebProgress* aWebProgress,
                                nsIRequest* aRequest, nsresult aStatus,
                                const char16_t* aMessage) {
  MOZ_ASSERT_UNREACHABLE("notification excluded in AddProgressListener(...)");
  return NS_OK;
}

NS_IMETHODIMP
HTMLFormElement::OnSecurityChange(nsIWebProgress* aWebProgress,
                                  nsIRequest* aRequest, uint32_t aState) {
  MOZ_ASSERT_UNREACHABLE("notification excluded in AddProgressListener(...)");
  return NS_OK;
}

NS_IMETHODIMP
HTMLFormElement::OnContentBlockingEvent(nsIWebProgress* aWebProgress,
                                        nsIRequest* aRequest, uint32_t aEvent) {
  MOZ_ASSERT_UNREACHABLE("notification excluded in AddProgressListener(...)");
  return NS_OK;
}

NS_IMETHODIMP_(int32_t)
HTMLFormElement::IndexOfControl(nsIFormControl* aControl) {
  int32_t index = 0;
  return mControls->IndexOfControl(aControl, &index) == NS_OK ? index : 0;
}

void HTMLFormElement::SetCurrentRadioButton(const nsAString& aName,
                                            HTMLInputElement* aRadio) {
  mSelectedRadioButtons.Put(aName, RefPtr{aRadio});
}

HTMLInputElement* HTMLFormElement::GetCurrentRadioButton(
    const nsAString& aName) {
  return mSelectedRadioButtons.GetWeak(aName);
}

NS_IMETHODIMP
HTMLFormElement::GetNextRadioButton(const nsAString& aName,
                                    const bool aPrevious,
                                    HTMLInputElement* aFocusedRadio,
                                    HTMLInputElement** aRadioOut) {
  // Return the radio button relative to the focused radio button.
  // If no radio is focused, get the radio relative to the selected one.
  *aRadioOut = nullptr;

  RefPtr<HTMLInputElement> currentRadio;
  if (aFocusedRadio) {
    currentRadio = aFocusedRadio;
  } else {
    mSelectedRadioButtons.Get(aName, getter_AddRefs(currentRadio));
  }

  nsCOMPtr<nsISupports> itemWithName = DoResolveName(aName, true);
  nsCOMPtr<nsINodeList> radioGroup(do_QueryInterface(itemWithName));

  if (!radioGroup) {
    return NS_ERROR_FAILURE;
  }

  int32_t index = radioGroup->IndexOf(currentRadio);
  if (index < 0) {
    return NS_ERROR_FAILURE;
  }

  uint32_t numRadios = radioGroup->Length();
  RefPtr<HTMLInputElement> radio;

  bool isRadio = false;
  do {
    if (aPrevious) {
      if (--index < 0) {
        index = numRadios - 1;
      }
    } else if (++index >= (int32_t)numRadios) {
      index = 0;
    }
    radio = HTMLInputElement::FromNodeOrNull(radioGroup->Item(index));
    isRadio = radio && radio->ControlType() == NS_FORM_INPUT_RADIO;
    if (!isRadio) {
      continue;
    }

    nsAutoString name;
    radio->GetName(name);
    isRadio = aName.Equals(name);
  } while (!isRadio || (radio->Disabled() && radio != currentRadio));

  NS_IF_ADDREF(*aRadioOut = radio);
  return NS_OK;
}

NS_IMETHODIMP
HTMLFormElement::WalkRadioGroup(const nsAString& aName,
                                nsIRadioVisitor* aVisitor, bool aFlushContent) {
  if (aName.IsEmpty()) {
    //
    // XXX If the name is empty, it's not stored in the control list.  There
    // *must* be a more efficient way to do this.
    //
    nsCOMPtr<nsIFormControl> control;
    uint32_t len = GetElementCount();
    for (uint32_t i = 0; i < len; i++) {
      control = GetElementAt(i);
      if (control->ControlType() == NS_FORM_INPUT_RADIO) {
        nsCOMPtr<Element> controlElement = do_QueryInterface(control);
        if (controlElement &&
            controlElement->AttrValueIs(kNameSpaceID_None, nsGkAtoms::name,
                                        EmptyString(), eCaseMatters) &&
            !aVisitor->Visit(control)) {
          break;
        }
      }
    }
    return NS_OK;
  }

  // Get the control / list of controls from the form using form["name"]
  nsCOMPtr<nsISupports> item = DoResolveName(aName, aFlushContent);
  if (!item) {
    return NS_ERROR_FAILURE;
  }

  // If it's just a lone radio button, then select it.
  nsCOMPtr<nsIFormControl> formControl = do_QueryInterface(item);
  if (formControl) {
    if (formControl->ControlType() == NS_FORM_INPUT_RADIO) {
      aVisitor->Visit(formControl);
    }
    return NS_OK;
  }

  nsCOMPtr<nsINodeList> nodeList = do_QueryInterface(item);
  if (!nodeList) {
    return NS_OK;
  }
  uint32_t length = nodeList->Length();
  for (uint32_t i = 0; i < length; i++) {
    nsIContent* node = nodeList->Item(i);
    nsCOMPtr<nsIFormControl> formControl = do_QueryInterface(node);
    if (formControl && formControl->ControlType() == NS_FORM_INPUT_RADIO &&
        !aVisitor->Visit(formControl)) {
      break;
    }
  }
  return NS_OK;
}

void HTMLFormElement::AddToRadioGroup(const nsAString& aName,
                                      HTMLInputElement* aRadio) {
  if (aRadio->IsRequired()) {
    auto entry = mRequiredRadioButtonCounts.LookupForAdd(aName);
    if (!entry) {
      entry.OrInsert([]() { return 1; });
    } else {
      ++entry.Data();
    }
  }
}

void HTMLFormElement::RemoveFromRadioGroup(const nsAString& aName,
                                           HTMLInputElement* aRadio) {
  if (aRadio->IsRequired()) {
    auto entry = mRequiredRadioButtonCounts.Lookup(aName);
    if (!entry) {
      MOZ_ASSERT_UNREACHABLE("At least one radio button has to be required!");
    } else {
      MOZ_ASSERT(entry.Data() >= 1,
                 "At least one radio button has to be required!");
      if (entry.Data() <= 1) {
        entry.Remove();
      } else {
        --entry.Data();
      }
    }
  }
}

uint32_t HTMLFormElement::GetRequiredRadioCount(const nsAString& aName) const {
  return mRequiredRadioButtonCounts.Get(aName);
}

void HTMLFormElement::RadioRequiredWillChange(const nsAString& aName,
                                              bool aRequiredAdded) {
  if (aRequiredAdded) {
    mRequiredRadioButtonCounts.Put(aName,
                                   mRequiredRadioButtonCounts.Get(aName) + 1);
  } else {
    uint32_t requiredNb = mRequiredRadioButtonCounts.Get(aName);
    NS_ASSERTION(requiredNb >= 1,
                 "At least one radio button has to be required!");
    if (requiredNb == 1) {
      mRequiredRadioButtonCounts.Remove(aName);
    } else {
      mRequiredRadioButtonCounts.Put(aName, requiredNb - 1);
    }
  }
}

bool HTMLFormElement::GetValueMissingState(const nsAString& aName) const {
  return mValueMissingRadioGroups.Get(aName);
}

void HTMLFormElement::SetValueMissingState(const nsAString& aName,
                                           bool aValue) {
  mValueMissingRadioGroups.Put(aName, aValue);
}

EventStates HTMLFormElement::IntrinsicState() const {
  EventStates state = nsGenericHTMLElement::IntrinsicState();

  if (mInvalidElementsCount) {
    state |= NS_EVENT_STATE_INVALID;
  } else {
    state |= NS_EVENT_STATE_VALID;
  }

  return state;
}

void HTMLFormElement::Clear() {
  for (int32_t i = mImageElements.Length() - 1; i >= 0; i--) {
    mImageElements[i]->ClearForm(false);
  }
  mImageElements.Clear();
  mImageNameLookupTable.Clear();
  mPastNameLookupTable.Clear();
}

namespace {

struct PositionComparator {
  nsIContent* const mElement;
  explicit PositionComparator(nsIContent* const aElement)
      : mElement(aElement) {}

  int operator()(nsIContent* aElement) const {
    if (mElement == aElement) {
      return 0;
    }
    if (nsContentUtils::PositionIsBefore(mElement, aElement)) {
      return -1;
    }
    return 1;
  }
};

struct RadioNodeListAdaptor {
  RadioNodeList* const mList;
  explicit RadioNodeListAdaptor(RadioNodeList* aList) : mList(aList) {}
  nsIContent* operator[](size_t aIdx) const { return mList->Item(aIdx); }
};

}  // namespace

nsresult HTMLFormElement::AddElementToTableInternal(
    nsInterfaceHashtable<nsStringHashKey, nsISupports>& aTable,
    nsIContent* aChild, const nsAString& aName) {
  auto entry = aTable.LookupForAdd(aName);
  if (!entry) {
    // No entry found, add the element
    entry.OrInsert([&aChild]() { return aChild; });
    ++mExpandoAndGeneration.generation;
  } else {
    // Found something in the hash, check its type
    nsCOMPtr<nsIContent> content = do_QueryInterface(entry.Data());

    if (content) {
      // Check if the new content is the same as the one we found in the
      // hash, if it is then we leave it in the hash as it is, this will
      // happen if a form control has both a name and an id with the same
      // value
      if (content == aChild) {
        return NS_OK;
      }

      // Found an element, create a list, add the element to the list and put
      // the list in the hash
      RadioNodeList* list = new RadioNodeList(this);

      // If an element has a @form, we can assume it *might* be able to not have
      // a parent and still be in the form.
      NS_ASSERTION(
          (content->IsElement() &&
           content->AsElement()->HasAttr(kNameSpaceID_None, nsGkAtoms::form)) ||
              content->GetParent(),
          "Item in list without parent");

      // Determine the ordering between the new and old element.
      bool newFirst = nsContentUtils::PositionIsBefore(aChild, content);

      list->AppendElement(newFirst ? aChild : content.get());
      list->AppendElement(newFirst ? content.get() : aChild);

      nsCOMPtr<nsISupports> listSupports = do_QueryObject(list);

      // Replace the element with the list.
      entry.Data() = listSupports;
    } else {
      // There's already a list in the hash, add the child to the list.
      MOZ_ASSERT(nsCOMPtr<RadioNodeList>(do_QueryInterface(entry.Data())));
      auto* list = static_cast<RadioNodeList*>(entry.Data().get());

      NS_ASSERTION(list->Length() > 1,
                   "List should have been converted back to a single element");

      // Fast-path appends; this check is ok even if the child is
      // already in the list, since if it tests true the child would
      // have come at the end of the list, and the PositionIsBefore
      // will test false.
      if (nsContentUtils::PositionIsBefore(list->Item(list->Length() - 1),
                                           aChild)) {
        list->AppendElement(aChild);
        return NS_OK;
      }

      // If a control has a name equal to its id, it could be in the
      // list already.
      if (list->IndexOf(aChild) != -1) {
        return NS_OK;
      }

      size_t idx;
      DebugOnly<bool> found =
          BinarySearchIf(RadioNodeListAdaptor(list), 0, list->Length(),
                         PositionComparator(aChild), &idx);
      MOZ_ASSERT(!found, "should not have found an element");

      list->InsertElementAt(aChild, idx);
    }
  }

  return NS_OK;
}

nsresult HTMLFormElement::AddImageElement(HTMLImageElement* aChild) {
  AddElementToList(mImageElements, aChild, this);
  return NS_OK;
}

nsresult HTMLFormElement::AddImageElementToTable(HTMLImageElement* aChild,
                                                 const nsAString& aName) {
  return AddElementToTableInternal(mImageNameLookupTable, aChild, aName);
}

nsresult HTMLFormElement::RemoveImageElement(HTMLImageElement* aChild) {
  RemoveElementFromPastNamesMap(aChild);

  size_t index = mImageElements.IndexOf(aChild);
  NS_ENSURE_STATE(index != mImageElements.NoIndex);

  mImageElements.RemoveElementAt(index);
  return NS_OK;
}

nsresult HTMLFormElement::RemoveImageElementFromTable(
    HTMLImageElement* aElement, const nsAString& aName) {
  return RemoveElementFromTableInternal(mImageNameLookupTable, aElement, aName);
}

void HTMLFormElement::AddToPastNamesMap(const nsAString& aName,
                                        nsISupports* aChild) {
  // If candidates contains exactly one node. Add a mapping from name to the
  // node in candidates in the form element's past names map, replacing the
  // previous entry with the same name, if any.
  nsCOMPtr<nsIContent> node = do_QueryInterface(aChild);
  if (node) {
    mPastNameLookupTable.Put(aName, node);
    node->SetFlags(MAY_BE_IN_PAST_NAMES_MAP);
  }
}

void HTMLFormElement::RemoveElementFromPastNamesMap(Element* aElement) {
  if (!aElement->HasFlag(MAY_BE_IN_PAST_NAMES_MAP)) {
    return;
  }

  aElement->UnsetFlags(MAY_BE_IN_PAST_NAMES_MAP);

  uint32_t oldCount = mPastNameLookupTable.Count();
  for (auto iter = mPastNameLookupTable.Iter(); !iter.Done(); iter.Next()) {
    if (aElement == iter.Data()) {
      iter.Remove();
    }
  }
  if (oldCount != mPastNameLookupTable.Count()) {
    ++mExpandoAndGeneration.generation;
  }
}

JSObject* HTMLFormElement::WrapNode(JSContext* aCx,
                                    JS::Handle<JSObject*> aGivenProto) {
  return HTMLFormElement_Binding::Wrap(aCx, this, aGivenProto);
}

int32_t HTMLFormElement::GetFormNumberForStateKey() {
  if (mFormNumber == -1) {
    mFormNumber = OwnerDoc()->GetNextFormNumber();
  }
  return mFormNumber;
}

void HTMLFormElement::NodeInfoChanged(Document* aOldDoc) {
  nsGenericHTMLElement::NodeInfoChanged(aOldDoc);

  // When a <form> element is adopted into a new document, we want any state
  // keys generated from it to no longer consider this element to be parser
  // inserted, and so have state keys based on the position of the <form>
  // element in the document, rather than the order it was inserted in.
  //
  // This is not strictly necessary, since we only ever look at the form number
  // for parser inserted form controls, and we do that at the time the form
  // control element is inserted into its original document by the parser.
  mFormNumber = -1;
}

}  // namespace dom
}  // namespace mozilla
