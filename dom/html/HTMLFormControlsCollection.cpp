/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/dom/HTMLFormControlsCollection.h"

#include "RadioNodeList.h"
#include "jsfriendapi.h"
#include "mozilla/FlushType.h"
#include "mozilla/dom/BindingUtils.h"
#include "mozilla/dom/Document.h"
#include "mozilla/dom/Element.h"
#include "mozilla/dom/HTMLFormControlsCollectionBinding.h"
#include "mozilla/dom/HTMLFormElement.h"
#include "nsGenericHTMLElement.h"  // nsGenericHTMLFormElement
#include "nsIFormControl.h"
#include "nsQueryObject.h"

namespace mozilla::dom {

/* static */
bool HTMLFormControlsCollection::ShouldBeInElements(
    const nsIFormControl* aFormControl) {
  // For backwards compatibility (with 4.x and IE) we must not add
  // <input type=image> elements to the list of form controls in a
  // form.

  switch (aFormControl->ControlType()) {
    case FormControlType::ButtonButton:
    case FormControlType::ButtonReset:
    case FormControlType::ButtonSubmit:
    case FormControlType::InputButton:
    case FormControlType::InputCheckbox:
    case FormControlType::InputColor:
    case FormControlType::InputEmail:
    case FormControlType::InputFile:
    case FormControlType::InputHidden:
    case FormControlType::InputReset:
    case FormControlType::InputPassword:
    case FormControlType::InputRadio:
    case FormControlType::InputSearch:
    case FormControlType::InputSubmit:
    case FormControlType::InputText:
    case FormControlType::InputTel:
    case FormControlType::InputUrl:
    case FormControlType::InputNumber:
    case FormControlType::InputRange:
    case FormControlType::InputDate:
    case FormControlType::InputTime:
    case FormControlType::InputMonth:
    case FormControlType::InputWeek:
    case FormControlType::InputDatetimeLocal:
    case FormControlType::Select:
    case FormControlType::Textarea:
    case FormControlType::Fieldset:
    case FormControlType::Object:
    case FormControlType::Output:
    case FormControlType::FormAssociatedCustomElement:
      return true;

    // These form control types are not supposed to end up in the
    // form.elements array
    // XXXbz maybe we should just return aType != InputImage or something
    // instead of the big switch?
    case FormControlType::InputImage:
      break;
  }
  return false;
}

HTMLFormControlsCollection::HTMLFormControlsCollection(HTMLFormElement* aForm)
    : mForm(aForm),
      mNameLookupTable(HTMLFormElement::FORM_CONTROL_LIST_HASHTABLE_LENGTH) {}

HTMLFormControlsCollection::~HTMLFormControlsCollection() {
  mForm = nullptr;
  Clear();
}

void HTMLFormControlsCollection::DropFormReference() {
  mForm = nullptr;
  Clear();
}

void HTMLFormControlsCollection::Clear() {
  // Null out childrens' pointer to me.  No refcounting here.
  for (nsGenericHTMLFormElement* element : mElements.AsSpan()) {
    nsCOMPtr<nsIFormControl> formControl = nsIFormControl::FromNode(element);
    MOZ_ASSERT(formControl);
    formControl->ClearForm(false, false);
  }
  mElements.Clear();

  for (nsGenericHTMLFormElement* element : mNotInElements.AsSpan()) {
    nsCOMPtr<nsIFormControl> formControl = nsIFormControl::FromNode(element);
    MOZ_ASSERT(formControl);
    formControl->ClearForm(false, false);
  }
  mNotInElements.Clear();

  mNameLookupTable.Clear();
}

NS_IMPL_CYCLE_COLLECTION_CLASS(HTMLFormControlsCollection)

NS_IMPL_CYCLE_COLLECTION_UNLINK_BEGIN_INHERITED(HTMLFormControlsCollection,
                                                HTMLCollection)
  tmp->Clear();
  NS_IMPL_CYCLE_COLLECTION_UNLINK(mForm)
NS_IMPL_CYCLE_COLLECTION_UNLINK_END
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_BEGIN_INHERITED(HTMLFormControlsCollection,
                                                  HTMLCollection)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mNameLookupTable)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mForm)
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_END
NS_IMPL_CYCLE_COLLECTION_TRACE_BEGIN_INHERITED(HTMLFormControlsCollection,
                                               HTMLCollection)
NS_IMPL_CYCLE_COLLECTION_TRACE_END

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(HTMLFormControlsCollection)
NS_INTERFACE_MAP_END_INHERITING(BaseContentList)

NS_IMPL_ADDREF_INHERITED(HTMLFormControlsCollection, HTMLCollection)
NS_IMPL_RELEASE_INHERITED(HTMLFormControlsCollection, HTMLCollection)

// HTMLCollection interfac

uint32_t HTMLFormControlsCollection::Length() { return mElements.Length(); }

nsISupports* HTMLFormControlsCollection::NamedItemInternal(
    const nsAString& aName) {
  return mNameLookupTable.GetWeak(aName);
}

nsresult HTMLFormControlsCollection::AddElementToTable(
    nsGenericHTMLFormElement* aChild, const nsAString& aName) {
  const auto* formControl = nsIFormControl::FromNode(aChild);
  MOZ_ASSERT(formControl);
  if (!mForm || !ShouldBeInElements(formControl)) {
    return NS_OK;
  }

  return mForm->AddElementToTableInternal(mNameLookupTable, aChild, aName);
}

nsresult HTMLFormControlsCollection::IndexOfContent(nsIContent* aContent,
                                                    int32_t* aIndex) {
  // Note -- not a DOM method; callers should handle flushing themselves

  NS_ENSURE_ARG_POINTER(aIndex);
  *aIndex = mElements.IndexOf(aContent);
  return NS_OK;
}

nsresult HTMLFormControlsCollection::RemoveElementFromTable(
    nsGenericHTMLFormElement* aChild, const nsAString& aName) {
  const auto* formControl = nsIFormControl::FromNode(aChild);
  MOZ_ASSERT(formControl);
  if (!mForm || !ShouldBeInElements(formControl)) {
    return NS_OK;
  }

  return mForm->RemoveElementFromTableInternal(mNameLookupTable, aChild, aName);
}

nsresult HTMLFormControlsCollection::GetSortedControls(
    nsTArray<RefPtr<nsGenericHTMLFormElement>>& aControls) const {
  aControls.Clear();

  // Merge the elements list and the not in elements list. Both lists are
  // already sorted.
  auto elements = mElements.AsSpan();
  auto notInElements = mNotInElements.AsSpan();
  uint32_t elementsLen = elements.Length();
  uint32_t notInElementsLen = notInElements.Length();
  aControls.SetCapacity(elementsLen + notInElementsLen);

  uint32_t elementsIdx = 0;
  uint32_t notInElementsIdx = 0;

  nsContentUtils::NodeIndexCache indexCache;
  while (elementsIdx < elementsLen || notInElementsIdx < notInElementsLen) {
    // Check whether we're done with mElements
    if (elementsIdx == elementsLen) {
      NS_ASSERTION(notInElementsIdx < notInElementsLen,
                   "Should have remaining not-in-elements");
      // Append the remaining mNotInElements elements
      // XXX(Bug 1631371) Check if this should use a fallible operation as it
      // pretended earlier.
      aControls.AppendElements(notInElements.From(notInElementsIdx));
      break;
    }
    // Check whether we're done with mNotInElements
    if (notInElementsIdx == notInElementsLen) {
      NS_ASSERTION(elementsIdx < elementsLen,
                   "Should have remaining in-elements");
      // Append the remaining mElements elements
      // XXX(Bug 1631371) Check if this should use a fallible operation as it
      // pretended earlier.
      aControls.AppendElements(elements.From(elementsIdx));
      break;
    }
    // Both lists have elements left.
    NS_ASSERTION(elements[elementsIdx] && notInElements[notInElementsIdx],
                 "Should have remaining elements");
    // Determine which of the two elements should be ordered
    // first and add it to the end of the list.
    nsGenericHTMLFormElement* elementToAdd;
    if (nsContentUtils::CompareTreePosition<TreeKind::DOM>(
            elements[elementsIdx], notInElements[notInElementsIdx], mForm,
            &indexCache) < 0) {
      elementToAdd = elements[elementsIdx];
      ++elementsIdx;
    } else {
      elementToAdd = notInElements[notInElementsIdx];
      ++notInElementsIdx;
    }
    // Add the first element to the list.
    // XXX(Bug 1631371) Check if this should use a fallible operation as it
    // pretended earlier.
    aControls.AppendElement(elementToAdd);
  }

  NS_ASSERTION(aControls.Length() == elementsLen + notInElementsLen,
               "Not all form controls were added to the sorted list");
  return NS_OK;
}

Element* HTMLFormControlsCollection::Item(uint32_t aIndex) {
  return mElements.SafeElementAt(aIndex, nullptr);
}

/* virtual */
nsINode* HTMLFormControlsCollection::GetParentObject() { return mForm; }

/* virtual */
Element* HTMLFormControlsCollection::GetFirstNamedElement(
    const nsAString& aName, bool& aFound) {
  Nullable<OwningRadioNodeListOrElement> maybeResult;
  NamedGetter(aName, aFound, maybeResult);
  if (!aFound) {
    return nullptr;
  }
  MOZ_ASSERT(!maybeResult.IsNull());
  const OwningRadioNodeListOrElement& result = maybeResult.Value();
  if (result.IsElement()) {
    return result.GetAsElement().get();
  }
  if (result.IsRadioNodeList()) {
    RadioNodeList& nodelist = result.GetAsRadioNodeList();
    return nodelist.Item(0)->AsElement();
  }
  MOZ_ASSERT_UNREACHABLE("Should only have Elements and NodeLists here.");
  return nullptr;
}

void HTMLFormControlsCollection::NamedGetter(
    const nsAString& aName, bool& aFound,
    Nullable<OwningRadioNodeListOrElement>& aResult) {
  nsISupports* item = NamedItemInternal(aName);
  if (!item) {
    aFound = false;
    return;
  }
  aFound = true;
  if (nsCOMPtr<Element> element = do_QueryInterface(item)) {
    aResult.SetValue().SetAsElement() = element;
    return;
  }
  if (nsCOMPtr<RadioNodeList> nodelist = do_QueryInterface(item)) {
    aResult.SetValue().SetAsRadioNodeList() = nodelist;
    return;
  }
  MOZ_ASSERT_UNREACHABLE("Should only have Elements and NodeLists here.");
}

void HTMLFormControlsCollection::GetSupportedNames(nsTArray<nsString>& aNames) {
  // Just enumerate mNameLookupTable.  This won't guarantee order, but
  // that's OK, because the HTML5 spec doesn't define an order for
  // this enumeration.
  AppendToArray(aNames, mNameLookupTable.Keys());
}

/* virtual */
JSObject* HTMLFormControlsCollection::WrapObject(
    JSContext* aCx, JS::Handle<JSObject*> aGivenProto) {
  return HTMLFormControlsCollection_Binding::Wrap(aCx, this, aGivenProto);
}

}  // namespace mozilla::dom
