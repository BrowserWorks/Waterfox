/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
#ifndef mozilla_dom_HTMLOptionsCollection_h
#define mozilla_dom_HTMLOptionsCollection_h

#include "mozilla/dom/ContentList.h"
#include "mozilla/dom/HTMLOptionElement.h"

namespace mozilla {
class ErrorResult;

namespace dom {

class DocGroup;
class HTMLElementOrLong;
class HTMLOptionElementOrHTMLOptGroupElement;
class HTMLSelectElement;

/**
 * The collection of options in the select (what you get back when you do
 * select.options in DOM)
 */
class HTMLOptionsCollection final : public ContentList {
 public:
  explicit HTMLOptionsCollection(HTMLSelectElement*);
  HTMLSelectElement* Select() const;
  DocGroup* GetDocGroup() const { return mRootNode->GetDocGroup(); }
  static bool IsValidOption(const HTMLOptionElement&, const HTMLSelectElement&);
  // nsWrapperCache
  JSObject* WrapObject(JSContext* aCx,
                       JS::Handle<JSObject*> aGivenProto) override;

  /**
   * Get the option at the index
   * @param aIndex the index
   */
  HTMLOptionElement* ItemAsOption(uint32_t aIndex) {
    return static_cast<HTMLOptionElement*>(ContentList::Item(aIndex));
  }

  /**
   * Finds the index of a given option element.
   * If the option isn't part of the collection, return NS_ERROR_FAILURE
   * without setting aIndex.
   *
   * @param aOption the option to get the index of
   * @param aStartIndex the index to start looking at
   * @param aForward TRUE to look forward, FALSE to look backward
   * @return the option index
   */
  nsresult GetOptionIndex(Element* aOption, int32_t aStartIndex, bool aForward,
                          int32_t* aIndex);

  void Add(const HTMLOptionElementOrHTMLOptGroupElement& aElement,
           const Nullable<HTMLElementOrLong>& aBefore, ErrorResult& aError);
  void Remove(int32_t aIndex);
  int32_t SelectedIndex();
  void SetSelectedIndex(int32_t aSelectedIndex);
  void IndexedSetter(uint32_t aIndex, HTMLOptionElement* aOption,
                     ErrorResult& aError);
  void SetLength(uint32_t aLength, ErrorResult& aError);
};

}  // namespace dom
}  // namespace mozilla

#endif  // mozilla_dom_HTMLOptionsCollection_h
