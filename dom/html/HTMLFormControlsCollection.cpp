/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/dom/HTMLFormControlsCollection.h"

#include "mozFlushType.h"
#include "mozilla/dom/BindingUtils.h"
#include "mozilla/dom/Element.h"
#include "mozilla/dom/HTMLFormControlsCollectionBinding.h"
#include "mozilla/dom/HTMLFormElement.h"
#include "nsGenericHTMLElement.h" // nsGenericHTMLFormElement
#include "nsIDocument.h"
#include "nsIDOMNode.h"
#include "nsIDOMNodeList.h"
#include "nsIFormControl.h"
#include "RadioNodeList.h"
#include "jsfriendapi.h"

namespace mozilla {
namespace dom {

/* static */ bool
HTMLFormControlsCollection::ShouldBeInElements(nsIFormControl* aFormControl)
{
  // For backwards compatibility (with 4.x and IE) we must not add
  // <input type=image> elements to the list of form controls in a
  // form.

  switch (aFormControl->GetType()) {
  case NS_FORM_BUTTON_BUTTON :
  case NS_FORM_BUTTON_RESET :
  case NS_FORM_BUTTON_SUBMIT :
  case NS_FORM_INPUT_BUTTON :
  case NS_FORM_INPUT_CHECKBOX :
  case NS_FORM_INPUT_COLOR :
  case NS_FORM_INPUT_EMAIL :
  case NS_FORM_INPUT_FILE :
  case NS_FORM_INPUT_HIDDEN :
  case NS_FORM_INPUT_RESET :
  case NS_FORM_INPUT_PASSWORD :
  case NS_FORM_INPUT_RADIO :
  case NS_FORM_INPUT_SEARCH :
  case NS_FORM_INPUT_SUBMIT :
  case NS_FORM_INPUT_TEXT :
  case NS_FORM_INPUT_TEL :
  case NS_FORM_INPUT_URL :
  case NS_FORM_INPUT_NUMBER :
  case NS_FORM_INPUT_RANGE :
  case NS_FORM_INPUT_DATE :
  case NS_FORM_INPUT_TIME :
  case NS_FORM_INPUT_MONTH :
  case NS_FORM_INPUT_WEEK :
  case NS_FORM_INPUT_DATETIME_LOCAL :
  case NS_FORM_SELECT :
  case NS_FORM_TEXTAREA :
  case NS_FORM_FIELDSET :
  case NS_FORM_OBJECT :
  case NS_FORM_OUTPUT :
    return true;
  }

  // These form control types are not supposed to end up in the
  // form.elements array
  //
  // NS_FORM_INPUT_IMAGE
  //
  // XXXbz maybe we should just check for that type here instead of the big
  // switch?

  return false;
}

HTMLFormControlsCollection::HTMLFormControlsCollection(HTMLFormElement* aForm)
  : mForm(aForm)
  // Initialize the elements list to have an initial capacity
  // of 8 to reduce allocations on small forms.
  , mElements(8)
  , mNameLookupTable(HTMLFormElement::FORM_CONTROL_LIST_HASHTABLE_LENGTH)
{
}

HTMLFormControlsCollection::~HTMLFormControlsCollection()
{
  mForm = nullptr;
  Clear();
}

void
HTMLFormControlsCollection::DropFormReference()
{
  mForm = nullptr;
  Clear();
}

void
HTMLFormControlsCollection::Clear()
{
  // Null out childrens' pointer to me.  No refcounting here
  for (int32_t i = mElements.Length() - 1; i >= 0; i--) {
    mElements[i]->ClearForm(false);
  }
  mElements.Clear();

  for (int32_t i = mNotInElements.Length() - 1; i >= 0; i--) {
    mNotInElements[i]->ClearForm(false);
  }
  mNotInElements.Clear();

  mNameLookupTable.Clear();
}

void
HTMLFormControlsCollection::FlushPendingNotifications()
{
  if (mForm) {
    nsIDocument* doc = mForm->GetUncomposedDoc();
    if (doc) {
      doc->FlushPendingNotifications(Flush_Content);
    }
  }
}

NS_IMPL_CYCLE_COLLECTION_CLASS(HTMLFormControlsCollection)

NS_IMPL_CYCLE_COLLECTION_UNLINK_BEGIN(HTMLFormControlsCollection)
  // Note: We intentionally don't set tmp->mForm to nullptr here, since doing
  // so may result in crashes because of inconsistent null-checking after the
  // object gets unlinked.
  tmp->Clear();
  NS_IMPL_CYCLE_COLLECTION_UNLINK_PRESERVED_WRAPPER
NS_IMPL_CYCLE_COLLECTION_UNLINK_END
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_BEGIN(HTMLFormControlsCollection)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE(mNameLookupTable)
  NS_IMPL_CYCLE_COLLECTION_TRAVERSE_SCRIPT_OBJECTS
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_END
NS_IMPL_CYCLE_COLLECTION_TRACE_BEGIN(HTMLFormControlsCollection)
  NS_IMPL_CYCLE_COLLECTION_TRACE_PRESERVED_WRAPPER
NS_IMPL_CYCLE_COLLECTION_TRACE_END

// XPConnect interface list for HTMLFormControlsCollection
NS_INTERFACE_TABLE_HEAD(HTMLFormControlsCollection)
  NS_WRAPPERCACHE_INTERFACE_TABLE_ENTRY
  NS_INTERFACE_TABLE(HTMLFormControlsCollection,
                     nsIHTMLCollection,
                     nsIDOMHTMLCollection)
  NS_INTERFACE_TABLE_TO_MAP_SEGUE_CYCLE_COLLECTION(HTMLFormControlsCollection)
NS_INTERFACE_MAP_END


NS_IMPL_CYCLE_COLLECTING_ADDREF(HTMLFormControlsCollection)
NS_IMPL_CYCLE_COLLECTING_RELEASE(HTMLFormControlsCollection)


// nsIDOMHTMLCollection interface

NS_IMETHODIMP
HTMLFormControlsCollection::GetLength(uint32_t* aLength)
{
  FlushPendingNotifications();
  *aLength = mElements.Length();
  return NS_OK;
}

NS_IMETHODIMP
HTMLFormControlsCollection::Item(uint32_t aIndex, nsIDOMNode** aReturn)
{
  nsISupports* item = GetElementAt(aIndex);
  if (!item) {
    *aReturn = nullptr;

    return NS_OK;
  }

  return CallQueryInterface(item, aReturn);
}

NS_IMETHODIMP 
HTMLFormControlsCollection::NamedItem(const nsAString& aName,
                                      nsIDOMNode** aReturn)
{
  FlushPendingNotifications();

  *aReturn = nullptr;

  nsCOMPtr<nsISupports> supports;

  if (!mNameLookupTable.Get(aName, getter_AddRefs(supports))) {
    // key not found
    return NS_OK;
  }

  if (!supports) {
    return NS_OK;
  }

  // We found something, check if it's a node
  CallQueryInterface(supports, aReturn);
  if (*aReturn) {
    return NS_OK;
  }

  // If not, we check if it's a node list.
  nsCOMPtr<nsIDOMNodeList> nodeList = do_QueryInterface(supports);
  NS_ASSERTION(nodeList, "Huh, what's going one here?");
  if (!nodeList) {
    return NS_OK;
  }

  // And since we're only asking for one node here, we return the first
  // one from the list.
  return nodeList->Item(0, aReturn);
}

nsISupports*
HTMLFormControlsCollection::NamedItemInternal(const nsAString& aName,
                                              bool aFlushContent)
{
  if (aFlushContent) {
    FlushPendingNotifications();
  }

  return mNameLookupTable.GetWeak(aName);
}

nsresult
HTMLFormControlsCollection::AddElementToTable(nsGenericHTMLFormElement* aChild,
                                              const nsAString& aName)
{
  if (!ShouldBeInElements(aChild)) {
    return NS_OK;
  }

  return mForm->AddElementToTableInternal(mNameLookupTable, aChild, aName);
}

nsresult
HTMLFormControlsCollection::IndexOfControl(nsIFormControl* aControl,
                                           int32_t* aIndex)
{
  // Note -- not a DOM method; callers should handle flushing themselves
  
  NS_ENSURE_ARG_POINTER(aIndex);

  *aIndex = mElements.IndexOf(aControl);

  return NS_OK;
}

nsresult
HTMLFormControlsCollection::RemoveElementFromTable(
  nsGenericHTMLFormElement* aChild, const nsAString& aName)
{
  if (!ShouldBeInElements(aChild)) {
    return NS_OK;
  }

  return mForm->RemoveElementFromTableInternal(mNameLookupTable, aChild, aName);
}

nsresult
HTMLFormControlsCollection::GetSortedControls(
  nsTArray<nsGenericHTMLFormElement*>& aControls) const
{
#ifdef DEBUG
  HTMLFormElement::AssertDocumentOrder(mElements, mForm);
  HTMLFormElement::AssertDocumentOrder(mNotInElements, mForm);
#endif

  aControls.Clear();

  // Merge the elements list and the not in elements list. Both lists are
  // already sorted.
  uint32_t elementsLen = mElements.Length();
  uint32_t notInElementsLen = mNotInElements.Length();
  aControls.SetCapacity(elementsLen + notInElementsLen);

  uint32_t elementsIdx = 0;
  uint32_t notInElementsIdx = 0;

  while (elementsIdx < elementsLen || notInElementsIdx < notInElementsLen) {
    // Check whether we're done with mElements
    if (elementsIdx == elementsLen) {
      NS_ASSERTION(notInElementsIdx < notInElementsLen,
                   "Should have remaining not-in-elements");
      // Append the remaining mNotInElements elements
      if (!aControls.AppendElements(mNotInElements.Elements() +
                                      notInElementsIdx,
                                    notInElementsLen -
                                      notInElementsIdx)) {
        return NS_ERROR_OUT_OF_MEMORY;
      }
      break;
    }
    // Check whether we're done with mNotInElements
    if (notInElementsIdx == notInElementsLen) {
      NS_ASSERTION(elementsIdx < elementsLen,
                   "Should have remaining in-elements");
      // Append the remaining mElements elements
      if (!aControls.AppendElements(mElements.Elements() +
                                      elementsIdx,
                                    elementsLen -
                                      elementsIdx)) {
        return NS_ERROR_OUT_OF_MEMORY;
      }
      break;
    }
    // Both lists have elements left.
    NS_ASSERTION(mElements[elementsIdx] &&
                 mNotInElements[notInElementsIdx],
                 "Should have remaining elements");
    // Determine which of the two elements should be ordered
    // first and add it to the end of the list.
    nsGenericHTMLFormElement* elementToAdd;
    if (HTMLFormElement::CompareFormControlPosition(
          mElements[elementsIdx], mNotInElements[notInElementsIdx], mForm) < 0) {
      elementToAdd = mElements[elementsIdx];
      ++elementsIdx;
    } else {
      elementToAdd = mNotInElements[notInElementsIdx];
      ++notInElementsIdx;
    }
    // Add the first element to the list.
    if (!aControls.AppendElement(elementToAdd)) {
      return NS_ERROR_OUT_OF_MEMORY;
    }
  }

  NS_ASSERTION(aControls.Length() == elementsLen + notInElementsLen,
               "Not all form controls were added to the sorted list");
#ifdef DEBUG
  HTMLFormElement::AssertDocumentOrder(aControls, mForm);
#endif

  return NS_OK;
}

Element*
HTMLFormControlsCollection::GetElementAt(uint32_t aIndex)
{
  FlushPendingNotifications();

  return mElements.SafeElementAt(aIndex, nullptr);
}

/* virtual */ nsINode*
HTMLFormControlsCollection::GetParentObject()
{
  return mForm;
}

/* virtual */ Element*
HTMLFormControlsCollection::GetFirstNamedElement(const nsAString& aName, bool& aFound)
{
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

void
HTMLFormControlsCollection::NamedGetter(const nsAString& aName,
                                        bool& aFound,
                                        Nullable<OwningRadioNodeListOrElement>& aResult)
{
  nsISupports* item = NamedItemInternal(aName, true);
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

void
HTMLFormControlsCollection::GetSupportedNames(nsTArray<nsString>& aNames)
{
  FlushPendingNotifications();
  // Just enumerate mNameLookupTable.  This won't guarantee order, but
  // that's OK, because the HTML5 spec doesn't define an order for
  // this enumeration.
  for (auto iter = mNameLookupTable.Iter(); !iter.Done(); iter.Next()) {
    aNames.AppendElement(iter.Key());
  }
}

/* virtual */ JSObject*
HTMLFormControlsCollection::WrapObject(JSContext* aCx, JS::Handle<JSObject*> aGivenProto)
{
  return HTMLFormControlsCollectionBinding::Wrap(aCx, this, aGivenProto);
}

} // namespace dom
} // namespace mozilla
