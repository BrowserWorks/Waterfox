/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim:set ts=2 sw=2 sts=2 et cindent: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_dom_JSWindowActorParent_h
#define mozilla_dom_JSWindowActorParent_h

#include "js/TypeDecls.h"
#include "mozilla/Attributes.h"
#include "mozilla/ErrorResult.h"
#include "mozilla/dom/BindingDeclarations.h"
#include "mozilla/dom/ContentParent.h"
#include "mozilla/dom/JSActor.h"
#include "nsCycleCollectionParticipant.h"
#include "nsWrapperCache.h"

namespace mozilla {
namespace dom {

class WindowGlobalParent;

}  // namespace dom
}  // namespace mozilla

namespace mozilla {
namespace dom {

class JSWindowActorParent final : public JSActor {
 public:
  NS_DECL_ISUPPORTS_INHERITED
  NS_DECL_CYCLE_COLLECTION_SCRIPT_HOLDER_CLASS_INHERITED(JSWindowActorParent,
                                                         JSActor)

  JSObject* WrapObject(JSContext* aCx,
                       JS::Handle<JSObject*> aGivenProto) override;

  static already_AddRefed<JSWindowActorParent> Constructor(
      GlobalObject& aGlobal) {
    return MakeAndAddRef<JSWindowActorParent>();
  }

  nsIGlobalObject* GetParentObject() const override;

  WindowGlobalParent* GetManager() const;
  void Init(const nsACString& aName, WindowGlobalParent* aManager);
  void StartDestroy();
  void AfterDestroy();
  CanonicalBrowsingContext* GetBrowsingContext(ErrorResult& aRv);

 protected:
  void SendRawMessage(const JSActorMessageMeta& aMeta,
                      ipc::StructuredCloneData&& aData,
                      ipc::StructuredCloneData&& aStack,
                      ErrorResult& aRv) override;

 private:
  ~JSWindowActorParent();

  bool mCanSend = true;
  RefPtr<WindowGlobalParent> mManager;
};

}  // namespace dom
}  // namespace mozilla

#endif  // mozilla_dom_JSWindowActorParent_h
