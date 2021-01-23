/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef __SANDBOXPRIVATE_H__
#define __SANDBOXPRIVATE_H__

#include "nsIGlobalObject.h"
#include "nsIScriptObjectPrincipal.h"
#include "nsIPrincipal.h"
#include "nsWeakReference.h"
#include "nsWrapperCache.h"

#include "js/RootingAPI.h"

class SandboxPrivate : public nsIGlobalObject,
                       public nsIScriptObjectPrincipal,
                       public nsSupportsWeakReference,
                       public nsWrapperCache {
 public:
  NS_DECL_CYCLE_COLLECTING_ISUPPORTS
  NS_DECL_CYCLE_COLLECTION_SCRIPT_HOLDER_CLASS_AMBIGUOUS(SandboxPrivate,
                                                         nsIGlobalObject)

  static void Create(nsIPrincipal* principal, JS::Handle<JSObject*> global) {
    RefPtr<SandboxPrivate> sbp = new SandboxPrivate(principal);
    sbp->SetWrapper(global);
    sbp->PreserveWrapper(ToSupports(sbp.get()));

    // Pass on ownership of sbp to |global|.
    // The type used to cast to void needs to match the one in GetPrivate.
    nsIScriptObjectPrincipal* sop =
        static_cast<nsIScriptObjectPrincipal*>(sbp.forget().take());
    JS_SetPrivate(global, sop);
  }

  static SandboxPrivate* GetPrivate(JSObject* obj) {
    // The type used to cast to void needs to match the one in Create.
    return static_cast<SandboxPrivate*>(
        static_cast<nsIScriptObjectPrincipal*>(JS_GetPrivate(obj)));
  }

  nsIPrincipal* GetPrincipal() override { return mPrincipal; }

  nsIPrincipal* GetEffectiveStoragePrincipal() override { return mPrincipal; }

  nsIPrincipal* IntrinsicStoragePrincipal() override { return mPrincipal; }

  JSObject* GetGlobalJSObject() override { return GetWrapper(); }
  JSObject* GetGlobalJSObjectPreserveColor() const override {
    return GetWrapperPreserveColor();
  }

  void ForgetGlobalObject(JSObject* obj) { ClearWrapper(obj); }

  virtual JSObject* WrapObject(JSContext* cx,
                               JS::Handle<JSObject*> aGivenProto) override {
    MOZ_CRASH("SandboxPrivate doesn't use DOM bindings!");
  }

  size_t ObjectMoved(JSObject* obj, JSObject* old) {
    UpdateWrapper(obj, old);
    return 0;
  }

 private:
  explicit SandboxPrivate(nsIPrincipal* principal) : mPrincipal(principal) {}

  virtual ~SandboxPrivate() = default;

  nsCOMPtr<nsIPrincipal> mPrincipal;
};

#endif  // __SANDBOXPRIVATE_H__
