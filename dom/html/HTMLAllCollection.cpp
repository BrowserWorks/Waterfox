/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/dom/HTMLAllCollection.h"

#include "jsfriendapi.h"
#include "mozilla/dom/ContentList.h"
#include "mozilla/dom/Element.h"
#include "mozilla/dom/HTMLAllCollectionBinding.h"
#include "mozilla/dom/Nullable.h"
#include "nsGenericHTMLElement.h"

namespace mozilla::dom {

HTMLAllCollection::HTMLAllCollection(mozilla::dom::Document* aDocument)
    : mDocument(aDocument) {
  MOZ_ASSERT(mDocument);
}

HTMLAllCollection::~HTMLAllCollection() = default;

NS_IMPL_CYCLE_COLLECTION_WRAPPERCACHE(HTMLAllCollection, mDocument, mCollection,
                                      mNamedMap)

NS_IMPL_CYCLE_COLLECTING_ADDREF(HTMLAllCollection)
NS_IMPL_CYCLE_COLLECTING_RELEASE(HTMLAllCollection)

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(HTMLAllCollection)
  NS_WRAPPERCACHE_INTERFACE_MAP_ENTRY
  NS_INTERFACE_MAP_ENTRY(nsISupports)
NS_INTERFACE_MAP_END

nsINode* HTMLAllCollection::GetParentObject() const { return mDocument; }

uint32_t HTMLAllCollection::Length() { return Collection()->Length(); }

Element* HTMLAllCollection::Item(uint32_t aIndex) {
  nsIContent* item = Collection()->Item(aIndex);
  return item ? item->AsElement() : nullptr;
}

void HTMLAllCollection::Item(const Optional<nsAString>& aNameOrIndex,
                             Nullable<OwningHTMLCollectionOrElement>& aResult) {
  if (!aNameOrIndex.WasPassed()) {
    aResult.SetNull();
    return;
  }

  const nsAString& nameOrIndex = aNameOrIndex.Value();
  uint32_t indexVal;
  if (js::StringIsArrayIndex(nameOrIndex.BeginReading(), nameOrIndex.Length(),
                             &indexVal)) {
    Element* element = Item(indexVal);
    if (element) {
      aResult.SetValue().SetAsElement() = element;
    } else {
      aResult.SetNull();
    }
    return;
  }

  NamedItem(nameOrIndex, aResult);
}

ContentList* HTMLAllCollection::Collection() {
  if (!mCollection) {
    Document* document = mDocument;
    mCollection = document->GetElementsByTagName(u"*"_ns);
    MOZ_ASSERT(mCollection);
  }
  return mCollection;
}

static bool IsAllNamedElement(nsIContent* aContent) {
  return aContent->IsAnyOfHTMLElements(
      nsGkAtoms::a, nsGkAtoms::button, nsGkAtoms::embed, nsGkAtoms::form,
      nsGkAtoms::iframe, nsGkAtoms::img, nsGkAtoms::input, nsGkAtoms::map,
      nsGkAtoms::meta, nsGkAtoms::object, nsGkAtoms::select,
      nsGkAtoms::textarea, nsGkAtoms::frame, nsGkAtoms::frameset);
}

static bool DocAllResultMatch(Element* aElement, int32_t aNamespaceID,
                              nsAtom* aAtom, void* aData) {
  if (aElement->GetID() == aAtom) {
    return true;
  }

  nsGenericHTMLElement* elm = nsGenericHTMLElement::FromNode(aElement);
  if (!elm) {
    return false;
  }

  if (!IsAllNamedElement(elm)) {
    return false;
  }

  const nsAttrValue* val = elm->GetParsedAttr(nsGkAtoms::name);
  return val && val->Type() == nsAttrValue::eAtom &&
         val->GetAtomValue() == aAtom;
}

ContentList* HTMLAllCollection::GetDocumentAllList(const nsAString& aID) {
  return mNamedMap
      .LookupOrInsertWith(aID,
                          [this, &aID] {
                            RefPtr<nsAtom> id = NS_Atomize(aID);
                            return new ContentList(mDocument, DocAllResultMatch,
                                                   nullptr, nullptr, true, id);
                          })
      .get();
}

void HTMLAllCollection::NamedGetter(
    const nsAString& aID, bool& aFound,
    Nullable<OwningHTMLCollectionOrElement>& aResult) {
  if (aID.IsEmpty()) {
    aFound = false;
    aResult.SetNull();
    return;
  }

  ContentList* docAllList = GetDocumentAllList(aID);
  if (!docAllList) {
    aFound = false;
    aResult.SetNull();
    return;
  }

  // Check if there are more than 1 entries. Do this by getting the second one
  // rather than the length since getting the length always requires walking
  // the entire document.
  if (docAllList->Item(1)) {
    aFound = true;
    aResult.SetValue().SetAsHTMLCollection() = docAllList;
    return;
  }

  // There's only 0 or 1 items. Return the first one or null.
  if (Element* element = docAllList->Item(0)) {
    aFound = true;
    aResult.SetValue().SetAsElement() = element;
    return;
  }

  aFound = false;
  aResult.SetNull();
}

void HTMLAllCollection::GetSupportedNames(nsTArray<nsString>& aNames) {
  Collection()->GetSupportedNames(aNames, IsAllNamedElement);
}

JSObject* HTMLAllCollection::WrapObject(JSContext* aCx,
                                        JS::Handle<JSObject*> aGivenProto) {
  return HTMLAllCollection_Binding::Wrap(aCx, this, aGivenProto);
}

}  // namespace mozilla::dom
