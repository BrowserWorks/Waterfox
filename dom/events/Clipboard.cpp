/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/AbstractThread.h"
#include "mozilla/BasePrincipal.h"
#include "mozilla/dom/Clipboard.h"
#include "mozilla/dom/ClipboardBinding.h"
#include "mozilla/dom/Promise.h"
#include "mozilla/dom/DataTransfer.h"
#include "mozilla/dom/DataTransferItemList.h"
#include "mozilla/dom/DataTransferItem.h"
#include "mozilla/StaticPrefs_dom.h"
#include "nsIClipboard.h"
#include "nsComponentManagerUtils.h"
#include "nsITransferable.h"
#include "nsArrayUtils.h"

static mozilla::LazyLogModule gClipboardLog("Clipboard");

namespace mozilla {
namespace dom {

Clipboard::Clipboard(nsPIDOMWindowInner* aWindow)
    : DOMEventTargetHelper(aWindow) {}

Clipboard::~Clipboard() = default;

already_AddRefed<Promise> Clipboard::ReadHelper(
    nsIPrincipal& aSubjectPrincipal, ClipboardReadType aClipboardReadType,
    ErrorResult& aRv) {
  // Create a new promise
  RefPtr<Promise> p = dom::Promise::Create(GetOwnerGlobal(), aRv);
  if (aRv.Failed()) {
    return nullptr;
  }

  // We want to disable security check for automated tests that have the pref
  //  dom.events.testing.asyncClipboard set to true
  if (!IsTestingPrefEnabled() &&
      !nsContentUtils::PrincipalHasPermission(aSubjectPrincipal,
                                              nsGkAtoms::clipboardRead)) {
    MOZ_LOG(GetClipboardLog(), LogLevel::Debug,
            ("Clipboard, ReadHelper, "
             "Don't have permissions for reading\n"));
    p->MaybeRejectWithUndefined();
    return p.forget();
  }

  // Want isExternal = true in order to use the data transfer object to perform
  // a read
  RefPtr<DataTransfer> dataTransfer = new DataTransfer(
      this, ePaste, /* is external */ true, nsIClipboard::kGlobalClipboard);

  // Create a new runnable
  RefPtr<nsIRunnable> r = NS_NewRunnableFunction(
      "Clipboard::Read",
      [p, dataTransfer, &aSubjectPrincipal, aClipboardReadType]() {
        IgnoredErrorResult ier;
        switch (aClipboardReadType) {
          case eRead:
            MOZ_LOG(GetClipboardLog(), LogLevel::Debug,
                    ("Clipboard, ReadHelper, read case\n"));
            dataTransfer->FillAllExternalData();
            // If there are items on the clipboard, data transfer will contain
            // those, else, data transfer will be empty and we will be resolving
            // with an empty data transfer
            p->MaybeResolve(dataTransfer);
            break;
          case eReadText:
            MOZ_LOG(GetClipboardLog(), LogLevel::Debug,
                    ("Clipboard, ReadHelper, read text case\n"));
            nsAutoString str;
            dataTransfer->GetData(NS_LITERAL_STRING(kTextMime), str,
                                  aSubjectPrincipal, ier);
            // Either resolve with a string extracted from data transfer item
            // or resolve with an empty string if nothing was found
            p->MaybeResolve(str);
            break;
        }
      });
  // Dispatch the runnable
  GetParentObject()->Dispatch(TaskCategory::Other, r.forget());
  return p.forget();
}

already_AddRefed<Promise> Clipboard::Read(nsIPrincipal& aSubjectPrincipal,
                                          ErrorResult& aRv) {
  return ReadHelper(aSubjectPrincipal, eRead, aRv);
}

already_AddRefed<Promise> Clipboard::ReadText(nsIPrincipal& aSubjectPrincipal,
                                              ErrorResult& aRv) {
  return ReadHelper(aSubjectPrincipal, eReadText, aRv);
}

already_AddRefed<Promise> Clipboard::Write(DataTransfer& aData,
                                           nsIPrincipal& aSubjectPrincipal,
                                           ErrorResult& aRv) {
  // Create a promise
  RefPtr<Promise> p = dom::Promise::Create(GetOwnerGlobal(), aRv);
  if (aRv.Failed()) {
    return nullptr;
  }

  nsPIDOMWindowInner* owner = GetOwner();
  Document* doc = owner ? owner->GetDoc() : nullptr;

  // We want to disable security check for automated tests that have the pref
  //  dom.events.testing.asyncClipboard set to true
  if (!IsTestingPrefEnabled() &&
      !nsContentUtils::IsCutCopyAllowed(doc, aSubjectPrincipal)) {
    MOZ_LOG(GetClipboardLog(), LogLevel::Debug,
            ("Clipboard, Write, Not allowed to write to clipboard\n"));
    p->MaybeRejectWithUndefined();
    return p.forget();
  }

  // Get the clipboard service
  nsCOMPtr<nsIClipboard> clipboard(
      do_GetService("@mozilla.org/widget/clipboard;1"));
  if (!clipboard) {
    p->MaybeRejectWithUndefined();
    return p.forget();
  }

  nsILoadContext* context = doc ? doc->GetLoadContext() : nullptr;
  if (!context) {
    p->MaybeRejectWithUndefined();
    return p.forget();
  }

  // Get the transferable
  RefPtr<nsITransferable> transferable = aData.GetTransferable(0, context);
  if (!transferable) {
    p->MaybeRejectWithUndefined();
    return p.forget();
  }

  // Create a runnable
  RefPtr<nsIRunnable> r = NS_NewRunnableFunction(
      "Clipboard::Write", [transferable, p, clipboard]() {
        nsresult rv =
            clipboard->SetData(transferable,
                               /* owner of the transferable */ nullptr,
                               nsIClipboard::kGlobalClipboard);
        if (NS_FAILED(rv)) {
          p->MaybeRejectWithUndefined();
          return;
        }
        p->MaybeResolveWithUndefined();
        return;
      });
  // Dispatch the runnable
  GetParentObject()->Dispatch(TaskCategory::Other, r.forget());
  return p.forget();
}

already_AddRefed<Promise> Clipboard::WriteText(const nsAString& aData,
                                               nsIPrincipal& aSubjectPrincipal,
                                               ErrorResult& aRv) {
  // We create a data transfer with text/plain format so that
  //  we can reuse Clipboard::Write(...) member function
  RefPtr<DataTransfer> dataTransfer = new DataTransfer(this, eCopy,
                                                       /* is external */ true,
                                                       /* clipboard type */ -1);
  dataTransfer->SetData(NS_LITERAL_STRING(kTextMime), aData, aSubjectPrincipal,
                        aRv);
  return Write(*dataTransfer, aSubjectPrincipal, aRv);
}

JSObject* Clipboard::WrapObject(JSContext* aCx,
                                JS::Handle<JSObject*> aGivenProto) {
  return Clipboard_Binding::Wrap(aCx, this, aGivenProto);
}

/* static */
LogModule* Clipboard::GetClipboardLog() { return gClipboardLog; }

/* static */
bool Clipboard::ReadTextEnabled(JSContext* aCx, JSObject* aGlobal) {
  nsIPrincipal* prin = nsContentUtils::SubjectPrincipal(aCx);
  return IsTestingPrefEnabled() || prin->GetIsAddonOrExpandedAddonPrincipal() ||
         prin->IsSystemPrincipal();
}

/* static */
bool Clipboard::IsTestingPrefEnabled() {
  bool clipboardTestingEnabled =
      StaticPrefs::dom_events_testing_asyncClipboard_DoNotUseDirectly();
  MOZ_LOG(GetClipboardLog(), LogLevel::Debug,
          ("Clipboard, Is testing enabled? %d\n", clipboardTestingEnabled));
  return clipboardTestingEnabled;
}

NS_IMPL_CYCLE_COLLECTION_CLASS(Clipboard)

NS_IMPL_CYCLE_COLLECTION_TRAVERSE_BEGIN_INHERITED(Clipboard,
                                                  DOMEventTargetHelper)
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_END

NS_IMPL_CYCLE_COLLECTION_UNLINK_BEGIN_INHERITED(Clipboard, DOMEventTargetHelper)
NS_IMPL_CYCLE_COLLECTION_UNLINK_END

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(Clipboard)
NS_INTERFACE_MAP_END_INHERITING(DOMEventTargetHelper)

NS_IMPL_ADDREF_INHERITED(Clipboard, DOMEventTargetHelper)
NS_IMPL_RELEASE_INHERITED(Clipboard, DOMEventTargetHelper)

}  // namespace dom
}  // namespace mozilla
