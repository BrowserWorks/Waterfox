/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_dom_nsRadioGroupStruct_h
#define mozilla_dom_nsRadioGroupStruct_h

#include "nsClassHashtable.h"
#include "nsCycleCollectionParticipant.h"
#include "nsISupportsImpl.h"

class nsIContent;

namespace mozilla::dom {

class HTMLInputElement;
struct nsRadioGroupStruct;

class RadioGroupContainer final {
 public:
  NS_INLINE_DECL_CYCLE_COLLECTING_NATIVE_REFCOUNTING(RadioGroupContainer)
  NS_DECL_CYCLE_COLLECTION_NATIVE_CLASS(RadioGroupContainer)

  RadioGroupContainer();

  size_t SizeOfIncludingThis(MallocSizeOf aMallocSizeOf) const;

  template <typename VisitCallback>
  void WalkRadioGroup(const nsAString& aName, VisitCallback&& aCallback,
                      const HTMLInputElement* aExcludedElement) {
    nsRadioGroupStruct* radioGroup = GetOrCreateRadioGroup(aName);
    for (HTMLInputElement* button : GetButtonsInGroup(radioGroup)) {
      if (button != aExcludedElement && !aCallback(button)) {
        return;
      }
    }
  }

  void SetCurrentRadioButton(const nsAString& aName, HTMLInputElement* aRadio);
  HTMLInputElement* GetCurrentRadioButton(const nsAString& aName);
  nsresult GetNextRadioButton(const nsAString& aName, const bool aPrevious,
                              HTMLInputElement* aFocusedRadio,
                              HTMLInputElement** aRadioOut);
  HTMLInputElement* GetFirstRadioButton(const nsAString& aName);
  void AddToRadioGroup(const nsAString& aName, HTMLInputElement* aRadio,
                       nsIContent* aAncestor);
  void RemoveFromRadioGroup(const nsAString& aName, HTMLInputElement* aRadio);
  uint32_t GetRequiredRadioCount(const nsAString& aName) const;
  void RadioRequiredWillChange(const nsAString& aName, bool aRequiredAdded);
  bool GetValueMissingState(const nsAString& aName) const;
  void SetValueMissingState(const nsAString& aName, bool aValue);

  // for radio group
  nsRadioGroupStruct* GetRadioGroup(const nsAString& aName) const;
  nsRadioGroupStruct* GetOrCreateRadioGroup(const nsAString& aName);

 private:
  ~RadioGroupContainer();

  Span<const RefPtr<HTMLInputElement>> GetButtonsInGroup(
      nsRadioGroupStruct* aGroup) const;

  nsClassHashtable<nsStringHashKey, nsRadioGroupStruct> mRadioGroups;
};

}  // namespace mozilla::dom

#endif  // mozilla_dom_nsRadioGroupStruct_h
