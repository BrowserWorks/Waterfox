/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
#ifndef RemoteSpellcheckEngineParent_h_
#define RemoteSpellcheckEngineParent_h_

#include "mozilla/PRemoteSpellcheckEngineParent.h"
#include "nsCOMPtr.h"
#include "nsTArray.h"

class nsISpellChecker;

namespace mozilla {

class RemoteSpellcheckEngineParent : public PRemoteSpellcheckEngineParent
{
public:
  RemoteSpellcheckEngineParent();

  virtual ~RemoteSpellcheckEngineParent();

  virtual void ActorDestroy(ActorDestroyReason aWhy) override;

  virtual mozilla::ipc::IPCResult RecvSetDictionary(const nsString& aDictionary,
                                                    bool* success) override;

  virtual mozilla::ipc::IPCResult RecvSetDictionaryFromList(
                                    nsTArray<nsString>&& aList,
                                    const intptr_t& aPromiseId) override;

  virtual mozilla::ipc::IPCResult RecvCheck(const nsString& aWord, bool* aIsMisspelled) override;

  virtual mozilla::ipc::IPCResult RecvCheckAndSuggest(const nsString& aWord,
                                                      bool* aIsMisspelled,
                                                      InfallibleTArray<nsString>* aSuggestions)
      override;

private:
  nsCOMPtr<nsISpellChecker> mSpellChecker;
};

} // namespace mozilla

#endif
