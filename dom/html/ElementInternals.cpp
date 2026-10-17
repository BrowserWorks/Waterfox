/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/dom/ElementInternals.h"

#include "mozAutoDocUpdate.h"
#include "mozilla/dom/CustomElementRegistry.h"
#include "mozilla/dom/CustomEvent.h"
#include "mozilla/dom/CustomStateSet.h"
#include "mozilla/dom/ElementInternalsBinding.h"
#include "mozilla/dom/FormData.h"
#include "mozilla/dom/HTMLElement.h"
#include "mozilla/dom/HTMLFieldSetElement.h"
#include "mozilla/dom/LifecycleCallbackArgs.h"
#include "mozilla/dom/MutationObservers.h"
#include "mozilla/dom/ShadowRoot.h"
#include "mozilla/dom/ValidityState.h"
#include "nsContentUtils.h"
#include "nsDebug.h"
#include "nsGenericHTMLElement.h"
#include "nsIMutationObserver.h"

#ifdef ACCESSIBILITY
#  include "nsAccessibilityService.h"
#endif

namespace mozilla::dom {

NS_IMPL_CYCLE_COLLECTION_WRAPPERCACHE_CLASS(ElementInternals)

NS_IMPL_CYCLE_COLLECTION_UNLINK_BEGIN(ElementInternals)
  tmp->Unlink();
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mTarget, mSubmissionValue, mState, mValidity,
                                  mValidationAnchor, mCustomStateSet);
  NS_IMPL_CYCLE_COLLECTION_UNLINK_PRESERVED_WRAPPER
NS_IMPL_CYCLE_COLLECTION_UNLINK_END

NS_IMPL_CYCLE_COLLECTION_TRAVERSE_BEGIN(ElementInternals)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mTarget, mSubmissionValue, mState,
                                    mValidity, mValidationAnchor,
                                    mCustomStateSet, mForm);

  for (auto& tableEntry : tmp->mAttrElementsMap) {
    auto& [explicitlySetElements, cachedAttrElements] =
        *tableEntry.GetModifiableData();
    ImplCycleCollectionTraverse(cb, cachedAttrElements,
                                "cached attribute elements entry", 0);
  }
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_END

NS_IMPL_CYCLE_COLLECTING_ADDREF(ElementInternals)
NS_IMPL_CYCLE_COLLECTING_RELEASE(ElementInternals)
NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(ElementInternals)
  NS_WRAPPERCACHE_INTERFACE_MAP_ENTRY
  NS_INTERFACE_MAP_ENTRY(nsIFormControl)
  NS_INTERFACE_MAP_ENTRY(nsIConstraintValidation)
  NS_INTERFACE_MAP_ENTRY_AMBIGUOUS(nsISupports, nsIFormControl)
NS_INTERFACE_MAP_END

ElementInternals::ElementInternals(HTMLElement* aTarget)
    : nsIFormControl(FormControlType::FormAssociatedCustomElement),
      mTarget(aTarget),
      mFieldSet(nullptr),
      mControlNumber(-1) {}

nsISupports* ElementInternals::GetParentObject() { return ToSupports(mTarget); }

JSObject* ElementInternals::WrapObject(JSContext* aCx,
                                       JS::Handle<JSObject*> aGivenProto) {
  return ElementInternals_Binding::Wrap(aCx, this, aGivenProto);
}

// https://html.spec.whatwg.org/#dom-elementinternals-shadowroot
ShadowRoot* ElementInternals::GetShadowRoot() const {
  MOZ_ASSERT(mTarget);

  ShadowRoot* shadowRoot = mTarget->GetShadowRoot();
  if (shadowRoot && !shadowRoot->IsAvailableToElementInternals()) {
    return nullptr;
  }

  return shadowRoot;
}

// https://html.spec.whatwg.org/commit-snapshots/912a3fe1f29649ccf8229de56f604b3c07ffd242/#dom-elementinternals-setformvalue
void ElementInternals::SetFormValue(
    const Nullable<FileOrUSVStringOrFormData>& aValue,
    const Optional<Nullable<FileOrUSVStringOrFormData>>& aState,
    ErrorResult& aRv) {
  MOZ_ASSERT(mTarget);

  /**
   * 1. Let element be this's target element.
   * 2. If element is not a form-associated custom element, then throw a
   *    "NotSupportedError" DOMException.
   */
  if (!mTarget->IsFormAssociatedElement()) {
    aRv.ThrowNotSupportedError(
        "Target element is not a form-associated custom element");
    return;
  }

  /**
   * 3. Set target element's submission value to value if value is not a
   *    FormData object, or to a clone of the entry list associated with value
   *    otherwise.
   */
  mSubmissionValue.SetNull();
  if (!aValue.IsNull()) {
    const FileOrUSVStringOrFormData& value = aValue.Value();
    OwningFileOrUSVStringOrFormData& owningValue = mSubmissionValue.SetValue();
    if (value.IsFormData()) {
      owningValue.SetAsFormData() = value.GetAsFormData().Clone();
    } else if (value.IsFile()) {
      owningValue.SetAsFile() = &value.GetAsFile();
    } else {
      owningValue.SetAsUSVString() = value.GetAsUSVString();
    }
  }

  /**
   * 4. If the state argument of the function is omitted, set element's state to
   *    its submission value.
   */
  if (!aState.WasPassed()) {
    mState = mSubmissionValue;
    return;
  }

  /**
   * 5. Otherwise, if state is a FormData object, set element's state to clone
   *    of the entry list associated with state.
   * 6. Otherwise, set element's state to state.
   */
  mState.SetNull();
  if (!aState.Value().IsNull()) {
    const FileOrUSVStringOrFormData& state = aState.Value().Value();
    OwningFileOrUSVStringOrFormData& owningState = mState.SetValue();
    if (state.IsFormData()) {
      owningState.SetAsFormData() = state.GetAsFormData().Clone();
    } else if (state.IsFile()) {
      owningState.SetAsFile() = &state.GetAsFile();
    } else {
      owningState.SetAsUSVString() = state.GetAsUSVString();
    }
  }
}

// https://html.spec.whatwg.org/#dom-elementinternals-form
Element* ElementInternals::GetFormForBindings(ErrorResult& aRv) const {
  MOZ_ASSERT(mTarget);

  if (!mTarget->IsFormAssociatedElement()) {
    aRv.ThrowNotSupportedError(
        "Target element is not a form-associated custom element");
    return nullptr;
  }

  return GetFormForBindings();
}

// https://html.spec.whatwg.org/commit-snapshots/3ad5159be8f27e110a70cefadcb50fc45ec21b05/#dom-elementinternals-setvalidity
void ElementInternals::SetValidity(
    const ValidityStateFlags& aFlags, const Optional<nsAString>& aMessage,
    const Optional<NonNull<nsGenericHTMLElement>>& aAnchor, ErrorResult& aRv) {
  MOZ_ASSERT(mTarget);

  /**
   * 1. Let element be this's target element.
   * 2. If element is not a form-associated custom element, then throw a
   *    "NotSupportedError" DOMException.
   */
  if (!mTarget->IsFormAssociatedElement()) {
    aRv.ThrowNotSupportedError(
        "Target element is not a form-associated custom element");
    return;
  }

  /**
   * 3. If flags contains one or more true values and message is not given or is
   *    the empty string, then throw a TypeError.
   */
  if ((aFlags.mBadInput || aFlags.mCustomError || aFlags.mPatternMismatch ||
       aFlags.mRangeOverflow || aFlags.mRangeUnderflow ||
       aFlags.mStepMismatch || aFlags.mTooLong || aFlags.mTooShort ||
       aFlags.mTypeMismatch || aFlags.mValueMissing) &&
      (!aMessage.WasPassed() || aMessage.Value().IsEmpty())) {
    aRv.ThrowTypeError("Need to provide validation message");
    return;
  }

  /**
   * 4. For each entry flag → value of flags, set element's validity flag with
   *    the name flag to value.
   */
  SetValidityState(VALIDITY_STATE_VALUE_MISSING, aFlags.mValueMissing);
  SetValidityState(VALIDITY_STATE_TYPE_MISMATCH, aFlags.mTypeMismatch);
  SetValidityState(VALIDITY_STATE_PATTERN_MISMATCH, aFlags.mPatternMismatch);
  SetValidityState(VALIDITY_STATE_TOO_LONG, aFlags.mTooLong);
  SetValidityState(VALIDITY_STATE_TOO_SHORT, aFlags.mTooShort);
  SetValidityState(VALIDITY_STATE_RANGE_UNDERFLOW, aFlags.mRangeUnderflow);
  SetValidityState(VALIDITY_STATE_RANGE_OVERFLOW, aFlags.mRangeOverflow);
  SetValidityState(VALIDITY_STATE_STEP_MISMATCH, aFlags.mStepMismatch);
  SetValidityState(VALIDITY_STATE_BAD_INPUT, aFlags.mBadInput);
  SetValidityState(VALIDITY_STATE_CUSTOM_ERROR, aFlags.mCustomError);
  mTarget->UpdateValidityElementStates(true);

  /**
   * 5. Set element's validation message to the empty string if message is not
   *    given or all of element's validity flags are false, or to message
   *    otherwise.
   * 6. If element's customError validity flag is true, then set element's
   *    custom validity error message to element's validation message.
   *    Otherwise, set element's custom validity error message to the empty
   *    string.
   */
  mValidationMessage =
      (!aMessage.WasPassed() || IsValid()) ? EmptyString() : aMessage.Value();

  nsGenericHTMLElement* anchor;
  if (!aAnchor.WasPassed()) {
    // 7. If anchor is not given, then set it to element.
    anchor = mTarget;
  } else {
    anchor = &aAnchor.Value();
    // 8. Otherwise, if anchor is not a shadow-including inclusive
    //    descendant of element, then throw a "NotFoundError" DOMException.
    if (!anchor->IsShadowIncludingInclusiveDescendantOf(mTarget)) {
      aRv.ThrowNotFoundError(
          "Validation anchor is not a shadow-including inclusive "
          "descendant of target element");
      return;
    }
  }
  // 9. Set element's validation anchor to anchor.
  mValidationAnchor = anchor;
}

// https://html.spec.whatwg.org/#dom-elementinternals-willvalidate
bool ElementInternals::GetWillValidate(ErrorResult& aRv) const {
  MOZ_ASSERT(mTarget);

  if (!mTarget->IsFormAssociatedElement()) {
    aRv.ThrowNotSupportedError(
        "Target element is not a form-associated custom element");
    return false;
  }
  return WillValidate();
}

// https://html.spec.whatwg.org/#dom-elementinternals-validity
ValidityState* ElementInternals::GetValidity(ErrorResult& aRv) {
  MOZ_ASSERT(mTarget);

  if (!mTarget->IsFormAssociatedElement()) {
    aRv.ThrowNotSupportedError(
        "Target element is not a form-associated custom element");
    return nullptr;
  }
  return Validity();
}

// https://html.spec.whatwg.org/#dom-elementinternals-validationmessage
void ElementInternals::GetValidationMessage(nsAString& aValidationMessage,
                                            ErrorResult& aRv) const {
  MOZ_ASSERT(mTarget);

  if (!mTarget->IsFormAssociatedElement()) {
    aRv.ThrowNotSupportedError(
        "Target element is not a form-associated custom element");
    return;
  }
  aValidationMessage = mValidationMessage;
}

// https://html.spec.whatwg.org/#dom-elementinternals-checkvalidity
bool ElementInternals::CheckValidity(ErrorResult& aRv) {
  MOZ_ASSERT(mTarget);

  if (!mTarget->IsFormAssociatedElement()) {
    aRv.ThrowNotSupportedError(
        "Target element is not a form-associated custom element");
    return false;
  }
  return nsIConstraintValidation::CheckValidity(*mTarget);
}

// https://html.spec.whatwg.org/#dom-elementinternals-reportvalidity
bool ElementInternals::ReportValidity(ErrorResult& aRv) {
  MOZ_ASSERT(mTarget);

  if (!mTarget->IsFormAssociatedElement()) {
    aRv.ThrowNotSupportedError(
        "Target element is not a form-associated custom element");
    return false;
  }

  bool defaultAction = true;
  if (nsIConstraintValidation::CheckValidity(*mTarget, &defaultAction)) {
    return true;
  }

  if (!defaultAction) {
    return false;
  }

  AutoTArray<RefPtr<Element>, 1> invalidElements;
  invalidElements.AppendElement(mTarget);

  AutoJSAPI jsapi;
  if (!jsapi.Init(mTarget->GetRelevantGlobal())) {
    return false;
  }
  JS::Rooted<JS::Value> detail(jsapi.cx());
  if (!ToJSValue(jsapi.cx(), invalidElements, &detail)) {
    return false;
  }

  RefPtr<CustomEvent> event =
      NS_NewDOMCustomEvent(mTarget->OwnerDoc(), nullptr, nullptr);
  event->InitCustomEvent(jsapi.cx(), u"MozInvalidForm"_ns,
                         /* CanBubble */ true,
                         /* Cancelable */ true, detail);
  event->SetTrusted(true);
  event->WidgetEventPtr()->mFlags.mOnlyChromeDispatch = true;
  mTarget->DispatchEvent(*event);

  return false;
}

// https://html.spec.whatwg.org/#dom-elementinternals-labels
already_AddRefed<NodeList> ElementInternals::GetLabels(ErrorResult& aRv) const {
  MOZ_ASSERT(mTarget);

  if (!mTarget->IsFormAssociatedElement()) {
    aRv.ThrowNotSupportedError(
        "Target element is not a form-associated custom element");
    return nullptr;
  }
  return mTarget->LabelsInternal();
}

nsGenericHTMLElement* ElementInternals::GetValidationAnchor(
    ErrorResult& aRv) const {
  MOZ_ASSERT(mTarget);

  if (!mTarget->IsFormAssociatedElement()) {
    aRv.ThrowNotSupportedError(
        "Target element is not a form-associated custom element");
    return nullptr;
  }
  return mValidationAnchor;
}

CustomStateSet* ElementInternals::States() {
  if (!mCustomStateSet) {
    mCustomStateSet = new CustomStateSet(mTarget);
  }
  return mCustomStateSet;
}

Element* ElementInternals::GetFormForBindings() const {
  return GetFormInternal();
};

void ElementInternals::SetForm(HTMLFormElement* aForm) { mForm = aForm; }

void ElementInternals::ClearForm(bool aRemoveFromForm, bool aUnbindOrDelete) {
  if (mTarget) {
    mTarget->ClearForm(aRemoveFromForm, aUnbindOrDelete);
  }
}

NS_IMETHODIMP ElementInternals::Reset() {
  if (mTarget) {
    MOZ_ASSERT(mTarget->IsFormAssociatedElement());
    nsContentUtils::EnqueueLifecycleCallback(ElementCallbackType::eFormReset,
                                             mTarget, {});
  }
  return NS_OK;
}

NS_IMETHODIMP ElementInternals::SubmitNamesValues(FormData* aFormData) {
  if (!mTarget) {
    return NS_ERROR_UNEXPECTED;
  }

  MOZ_ASSERT(mTarget->IsFormAssociatedElement());

  // https://html.spec.whatwg.org/#face-entry-construction
  if (!mSubmissionValue.IsNull()) {
    if (mSubmissionValue.Value().IsFormData()) {
      aFormData->Append(mSubmissionValue.Value().GetAsFormData());
      return NS_OK;
    }

    // Get the name
    nsAutoString name;
    if (!mTarget->GetAttr(nsGkAtoms::name, name) || name.IsEmpty()) {
      return NS_OK;
    }

    if (mSubmissionValue.Value().IsUSVString()) {
      return aFormData->AddNameValuePair(
          name, mSubmissionValue.Value().GetAsUSVString());
    }

    return aFormData->AddNameBlobPair(name,
                                      mSubmissionValue.Value().GetAsFile());
  }
  return NS_OK;
}

void ElementInternals::UpdateFormOwner() {
  if (mTarget) {
    mTarget->UpdateFormOwner();
  }
}

void ElementInternals::UpdateBarredFromConstraintValidation() {
  if (mTarget) {
    MOZ_ASSERT(mTarget->IsFormAssociatedElement());
    SetBarredFromConstraintValidation(
        mTarget->IsDisabled() || mTarget->HasAttr(nsGkAtoms::readonly) ||
        mTarget->HasFlag(ELEMENT_IS_DATALIST_OR_HAS_DATALIST_ANCESTOR));
  }
}

void ElementInternals::Unlink() {
  if (mForm) {
    // Don't notify, since we're being destroyed in any case.
    ClearForm(true, true);
    MOZ_DIAGNOSTIC_ASSERT(!mForm);
  }
  if (mFieldSet) {
    mFieldSet->RemoveElement(mTarget);
    mFieldSet = nullptr;
  }
  mAttrElementsMap.Clear();
}

void ElementInternals::GetAttr(const nsAtom* aName, nsAString& aResult) const {
  MOZ_ASSERT(aResult.IsEmpty(), "Should have empty string coming in");

  const nsAttrValue* val = mAttrs.GetAttr(aName);
  if (val) {
    val->ToString(aResult);
    return;
  }
  SetDOMStringToNull(aResult);
}

nsresult ElementInternals::SetAttr(nsAtom* aName, const nsAString& aValue) {
  Document* document = mTarget->GetComposedDoc();
  mozAutoDocUpdate updateBatch(document, true);

#ifdef ACCESSIBILITY
  const AttrModType modType =
      mAttrs.HasAttr(aName) ? AttrModType::Modification : AttrModType::Addition;
  if (auto* accService = GetAccService()) {
    accService->NotifyARIAAttributeDefaultWillChange(mTarget, aName, modType);
  }
#endif

  nsAttrValue attrValue(aValue);
  nsresult rs = NS_OK;
  if (DOMStringIsNull(aValue)) {
    auto attrPos = mAttrs.IndexOfAttr(aName);
    if (attrPos >= 0) {
      rs = mAttrs.RemoveAttrAt(attrPos, attrValue);
    }
  } else {
    bool attrHadValue = false;
    rs = mAttrs.SetAndSwapAttr(aName, attrValue, &attrHadValue);
  }
  nsMutationGuard::DidMutate();

#ifdef ACCESSIBILITY
  if (auto* accService = GetAccService()) {
    accService->NotifyARIAAttributeDefaultChanged(mTarget, aName, modType);
  }
#endif
  return rs;
}

nsresult ElementInternals::SetAttrInternal(nsAtom* aName,
                                           const nsAString& aValue) {
  bool attrHadValue;
  nsAttrValue attrValue(aValue);
  return mAttrs.SetAndSwapAttr(aName, attrValue, &attrHadValue);
}

nsresult ElementInternals::UnsetAttrInternal(nsAtom* aName) {
  nsAttrValue attrValue;
  auto attrPos = mAttrs.IndexOfAttr(aName);
  if (attrPos >= 0) {
    return mAttrs.RemoveAttrAt(attrPos, attrValue);
  }

  return NS_OK;
}

DocGroup* ElementInternals::GetDocGroup() {
  return mTarget->OwnerDoc()->GetDocGroup();
}

void ElementInternals::RestoreFormValue(
    Nullable<OwningFileOrUSVStringOrFormData>&& aValue,
    Nullable<OwningFileOrUSVStringOrFormData>&& aState) {
  mSubmissionValue = aValue;
  mState = aState;

  if (!mState.IsNull()) {
    LifecycleCallbackArgs args;
    args.mState = mState;
    args.mReason = RestoreReason::Restore;
    nsContentUtils::EnqueueLifecycleCallback(
        ElementCallbackType::eFormStateRestore, mTarget, args);
  }
}

void ElementInternals::InitializeControlNumber() {
  MOZ_ASSERT(mControlNumber == -1,
             "FACE control number should only be initialized once!");
  mControlNumber = mTarget->OwnerDoc()->GetNextControlNumber();
}

void ElementInternals::SetAttrElement(nsAtom* aAttr, Element* aElement) {
  // Accessibility requires that no other attribute changes occur between
  // AttrElementWillChange and AttrElementChanged. Scripts could cause
  // this, so don't let them run here. We do this even if accessibility isn't
  // running so that the JS behavior is consistent regardless of accessibility.
  // Otherwise, JS might be able to use this difference to determine whether
  // accessibility is running, which would be a privacy concern.
  nsAutoScriptBlocker scriptBlocker;

#ifdef ACCESSIBILITY
  // If the target has this attribute defined then it overrides the defaults
  // defined here in the Internals instance. In that case we don't need to
  // notify the change to a11y since the attribute hasn't changed, just the
  // underlying default. We can set accService to null and not notify.
  nsAccessibilityService* accService =
      !mTarget->HasAttr(aAttr) ? GetAccService() : nullptr;
  if (accService) {
    accService->NotifyAttrElementWillChange(mTarget, aAttr);
  }
#endif

  if (aElement) {
    mAttrElementMap.InsertOrUpdate(aAttr, do_GetWeakReference(aElement));
    SetAttrInternal(aAttr, EmptyString());
  } else {
    mAttrElementMap.Remove(aAttr);
    UnsetAttrInternal(aAttr);
  }

#ifdef ACCESSIBILITY
  if (accService) {
    accService->NotifyAttrElementChanged(mTarget, aAttr);
  }
#endif
}

Element* ElementInternals::GetAttrElement(nsAtom* aAttr) const {
  nsWeakPtr weakAttrEl = mAttrElementMap.Get(aAttr);
  nsCOMPtr<Element> attrEl = do_QueryReferent(weakAttrEl);
  return attrEl;
}

void ElementInternals::SetAttrElements(
    nsAtom* aAttr,
    const Nullable<Sequence<OwningNonNull<Element>>>& aElements) {
#ifdef ACCESSIBILITY
  nsAccessibilityService* accService = GetAccService();
#endif
  // Accessibility requires that no other attribute changes occur between
  // AttrElementWillChange and AttrElementChanged. Scripts could cause
  // this, so don't let them run here. We do this even if accessibility isn't
  // running so that the JS behavior is consistent regardless of accessibility.
  // Otherwise, JS might be able to use this difference to determine whether
  // accessibility is running, which would be a privacy concern.
  nsAutoScriptBlocker scriptBlocker;
#ifdef ACCESSIBILITY
  if (accService) {
    accService->NotifyAttrElementWillChange(mTarget, aAttr);
  }
#endif

  nsAttrValue emptyAttr;
  if (aElements.IsNull()) {
    mAttrElementsMap.Remove(aAttr);
    UnsetAttrInternal(aAttr);
  } else {
    auto& [attrElements, cachedAttrElements] =
        mAttrElementsMap.LookupOrInsert(aAttr);
    attrElements.Clear();
    for (Element* el : aElements.Value()) {
      attrElements.AppendElement(do_GetWeakReference(el));
    }
    SetAttrInternal(aAttr, EmptyString());
  }

#ifdef ACCESSIBILITY
  if (accService) {
    accService->NotifyAttrElementChanged(mTarget, aAttr);
  }
#endif
}

void ElementInternals::GetAttrElements(
    nsAtom* aAttr, bool* aUseCachedValue,
    Nullable<nsTArray<RefPtr<Element>>>& aElements) {
  MOZ_ASSERT(aElements.IsNull());

  auto attrElementsMaybeEntry = mAttrElementsMap.Lookup(aAttr);
  if (!attrElementsMaybeEntry) {
    return;
  }

  aElements.SetValue(nsTArray<RefPtr<Element>>());
  auto& [attrElements, cachedAttrElements] = attrElementsMaybeEntry.Data();

  auto getAttrAssociatedElements = [&, &attrElements = attrElements]() {
    CopyableTArray<RefPtr<Element>> elements;

    for (const nsWeakPtr& weakEl : attrElements) {
      // For each attrElement in reflectedTarget's explicitly set attr-elements:
      if (RefPtr<Element> attrEl = do_QueryReferent(weakEl)) {
        // Append attrElement to elements.
        elements.AppendElement(std::move(attrEl));
      }
    }

    return elements;
  };

  // https://html.spec.whatwg.org/multipage/common-dom-interfaces.html#attr-associated-elements
  // Getter steps:
  // 1. Let elements be the result of running this's get the attr-associated
  // elements.
  auto elements = getAttrAssociatedElements();

  // aUseCachedValue is null when the binding has no cached attr-associated
  // elements object to reuse yet (e.g. the first getter call). In that case we
  // must return the freshly computed elements below rather than signalling a
  // cache hit, otherwise we would dereference a null pointer.
  if (aUseCachedValue && elements == cachedAttrElements) {
    // 2. If the contents of elements is equal to the contents of this's cached
    // attr-associated elements, then return this's cached attr-associated
    // elements object.
    MOZ_ASSERT(!*aUseCachedValue);
    *aUseCachedValue = true;
    return;
  }

  // 3. Let elementsAsFrozenArray be elements, converted to a FrozenArray<T>?.
  //    (the binding code takes aElements and returns it as a FrozenArray)
  // 5. Set this's cached attr-associated elements object to
  // elementsAsFrozenArray.
  //    (the binding code stores the attr-associated elements object in a slot)
  // 6. Return elementsAsFrozenArray.
  aElements.SetValue(elements.Clone());

  // 4. Set this's cached attr-associated elements to elements.
  cachedAttrElements = std::move(elements);
}

Maybe<nsTArray<RefPtr<Element>>> ElementInternals::GetAttrElements(
    nsAtom* aAttr) {
  auto attrElementsMaybeEntry = mAttrElementsMap.Lookup(aAttr);
  if (!attrElementsMaybeEntry) {
    return Nothing();
  }

  nsTArray<RefPtr<Element>> elements;
  auto& [attrElements, cachedAttrElements] = attrElementsMaybeEntry.Data();
  for (const nsWeakPtr& weakEl : attrElements) {
    if (RefPtr<Element> attrEl = do_QueryReferent(weakEl)) {
      elements.AppendElement(std::move(attrEl));
    }
  }

  return Some(std::move(elements));
}

}  // namespace mozilla::dom
