/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/dom/HTMLOptionsCollection.h"

#include "mozilla/dom/HTMLOptionElement.h"
#include "mozilla/dom/HTMLOptionsCollectionBinding.h"
#include "mozilla/dom/HTMLSelectElement.h"
#include "nsContentUtils.h"

namespace mozilla::dom {

// https://html.spec.whatwg.org/#concept-select-option-list
bool HTMLOptionsCollection::IsValidOption(const HTMLOptionElement& aOption,
                                          const HTMLSelectElement& aRoot) {
  bool seenOptgroup = false;
  for (nsINode* ancestor = aOption.GetParent(); ancestor;
       ancestor = ancestor->GetParentNode()) {
    if (ancestor == &aRoot) {
      return true;
    }
    if (HTMLOptionElement::IsOptionListBoundary(*ancestor)) {
      return false;
    }
    if (ancestor->IsHTMLElement(nsGkAtoms::optgroup)) {
      if (seenOptgroup) {
        return false;
      }
      seenOptgroup = true;
    }
  }
  return false;
}

static bool MatchOption(Element* aElement, int32_t aNamespaceID, nsAtom* aAtom,
                        void* aData) {
  auto* option = HTMLOptionElement::FromNode(aElement);
  if (!option) {
    return false;
  }
  auto* root = static_cast<HTMLSelectElement*>(aData);
  return HTMLOptionsCollection::IsValidOption(*option, *root);
}

HTMLOptionsCollection::HTMLOptionsCollection(HTMLSelectElement* aRoot)
    : ContentList(aRoot, MatchOption, nullptr, aRoot,
                  /* aDeep = */ true, /* aMatchAtom = */ nullptr,
                  /* aMatchNameSpaceId = */ kNameSpaceID_None,
                  /* aFuncMayDependOnAttr = */ false,
                  /* aLiveList = */ true) {}

HTMLSelectElement* HTMLOptionsCollection::Select() const {
  return static_cast<HTMLSelectElement*>(mRootNode);
}

nsresult HTMLOptionsCollection::GetOptionIndex(Element* aOption,
                                               int32_t aStartIndex,
                                               bool aForward, int32_t* aIndex) {
  MOZ_ASSERT(!nsContentUtils::IsSafeToRunScript(),
             "Callers must hold a script blocker");
  BringSelfUpToDate();

  // NOTE: aIndex shouldn't be set if the returned value isn't NS_OK.
  int32_t index;

  // Make the common case fast
  if (aStartIndex == 0 && aForward) {
    index = mElements.IndexOf(aOption);
    if (index == -1) {
      return NS_ERROR_FAILURE;
    }

    *aIndex = index;
    return NS_OK;
  }

  int32_t high = mElements.Length();
  int32_t step = aForward ? 1 : -1;

  for (index = aStartIndex; index < high && index > -1; index += step) {
    if (mElements[index] == aOption) {
      *aIndex = index;
      return NS_OK;
    }
  }

  return NS_ERROR_FAILURE;
}
JSObject* HTMLOptionsCollection::WrapObject(JSContext* aCx,
                                            JS::Handle<JSObject*> aGivenProto) {
  return HTMLOptionsCollection_Binding::Wrap(aCx, this, aGivenProto);
}

void HTMLOptionsCollection::SetLength(uint32_t aLength, ErrorResult& aError) {
  RefPtr<HTMLSelectElement> select = Select();
  select->SetLength(aLength, aError);
}

void HTMLOptionsCollection::IndexedSetter(uint32_t aIndex,
                                          HTMLOptionElement* aOption,
                                          ErrorResult& aError) {
  RefPtr<HTMLSelectElement> select = Select();

  // if the new option is null, just remove this option.  Note that it's safe
  // to pass a too-large aIndex in here.
  if (!aOption) {
    select->Remove(aIndex);

    // We're done.
    return;
  }

  // Now we're going to be setting an option in our collection
  if (aIndex > Length()) {
    // Fill our array with blank options up to (but not including, since we're
    // about to change it) aIndex, for compat with other browsers.
    SetLength(aIndex, aError);
    if (NS_WARN_IF(aError.Failed())) {
      return;
    }
  }

  NS_ASSERTION(aIndex <= mElements.Length(), "SetLength lied");

  if (aIndex == mElements.Length()) {
    select->AppendChild(*aOption, aError);
    return;
  }

  // Find the option they're talking about and replace it
  // hold a strong reference to follow COM rules.
  RefPtr<HTMLOptionElement> refChild = ItemAsOption(aIndex);
  if (!refChild) {
    aError.Throw(NS_ERROR_UNEXPECTED);
    return;
  }

  nsCOMPtr<nsINode> parent = refChild->GetParent();
  if (!parent) {
    return;
  }

  parent->ReplaceChild(*aOption, *refChild, aError);
}

int32_t HTMLOptionsCollection::SelectedIndex() {
  return Select()->SelectedIndex();
}

void HTMLOptionsCollection::SetSelectedIndex(int32_t aSelectedIndex) {
  Select()->SetSelectedIndex(aSelectedIndex);
}

void HTMLOptionsCollection::Add(
    const HTMLOptionElementOrHTMLOptGroupElement& aElement,
    const Nullable<HTMLElementOrLong>& aBefore, ErrorResult& aError) {
  RefPtr<HTMLSelectElement> select = Select();
  select->Add(aElement, aBefore, aError);
}

void HTMLOptionsCollection::Remove(int32_t aIndex) {
  RefPtr<HTMLSelectElement> select = Select();
  select->Remove(aIndex);
}

}  // namespace mozilla::dom
