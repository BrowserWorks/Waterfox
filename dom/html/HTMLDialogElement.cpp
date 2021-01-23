/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/dom/HTMLDialogElement.h"
#include "mozilla/dom/HTMLDialogElementBinding.h"
#include "mozilla/dom/HTMLUnknownElement.h"
#include "mozilla/StaticPrefs_dom.h"

// Expand NS_IMPL_NS_NEW_HTML_ELEMENT(Dialog) with pref check
nsGenericHTMLElement* NS_NewHTMLDialogElement(
    already_AddRefed<mozilla::dom::NodeInfo>&& aNodeInfo,
    mozilla::dom::FromParser aFromParser) {
  RefPtr<mozilla::dom::NodeInfo> nodeInfo(aNodeInfo);
  auto* nim = nodeInfo->NodeInfoManager();
  if (!mozilla::dom::HTMLDialogElement::IsDialogEnabled()) {
    return new (nim) mozilla::dom::HTMLUnknownElement(nodeInfo.forget());
  }

  return new (nim) mozilla::dom::HTMLDialogElement(nodeInfo.forget());
}

namespace mozilla {
namespace dom {

HTMLDialogElement::~HTMLDialogElement() = default;

NS_IMPL_ELEMENT_CLONE(HTMLDialogElement)

bool HTMLDialogElement::IsDialogEnabled() {
  return StaticPrefs::dom_dialog_element_enabled();
}

void HTMLDialogElement::Close(
    const mozilla::dom::Optional<nsAString>& aReturnValue) {
  if (!Open()) {
    return;
  }
  if (aReturnValue.WasPassed()) {
    SetReturnValue(aReturnValue.Value());
  }

  SetOpen(false, IgnoreErrors());

  RemoveFromTopLayerIfNeeded();

  RefPtr<AsyncEventDispatcher> eventDispatcher = new AsyncEventDispatcher(
      this, NS_LITERAL_STRING("close"), CanBubble::eNo);
  eventDispatcher->PostDOMEvent();
}

void HTMLDialogElement::Show() {
  if (Open()) {
    return;
  }
  SetOpen(true, IgnoreErrors());
  FocusDialog();
}

bool HTMLDialogElement::IsInTopLayer() const {
  return State().HasState(NS_EVENT_STATE_MODAL_DIALOG);
}

void HTMLDialogElement::RemoveFromTopLayerIfNeeded() {
  if (!IsInTopLayer()) {
    return;
  }
  auto predictFunc = [&](Element* element) { return element == this; };

  DebugOnly<Element*> removedElement = OwnerDoc()->TopLayerPop(predictFunc);
  MOZ_ASSERT(removedElement == this);
  RemoveStates(NS_EVENT_STATE_MODAL_DIALOG);
}

void HTMLDialogElement::UnbindFromTree(bool aNullParent) {
  RemoveFromTopLayerIfNeeded();
  nsGenericHTMLElement::UnbindFromTree(aNullParent);
}

void HTMLDialogElement::ShowModal(ErrorResult& aError) {
  if (!IsInComposedDoc()) {
    aError.ThrowInvalidStateError("Dialog element is not connected");
    return;
  }

  if (Open()) {
    aError.ThrowInvalidStateError(
        "Dialog element already has an 'open' attribute");
    return;
  }

  if (!IsInTopLayer() && OwnerDoc()->TopLayerPush(this)) {
    AddStates(NS_EVENT_STATE_MODAL_DIALOG);
  }

  SetOpen(true, aError);
  FocusDialog();

  aError.SuppressException();
}

void HTMLDialogElement::FocusDialog() {
  // 1) If subject is inert, return.
  // 2) Let control be the first descendant element of subject, in tree
  // order, that is not inert and has the autofocus attribute specified.
  if (RefPtr<Document> doc = GetComposedDoc()) {
    doc->FlushPendingNotifications(FlushType::Frames);
  }

  Element* control = nullptr;
  nsIContent* child = GetFirstChild();
  while (child) {
    if (child->IsElement()) {
      nsIFrame* frame = child->GetPrimaryFrame();
      if (frame && frame->IsFocusable()) {
        if (child->AsElement()->HasAttr(kNameSpaceID_None,
                                        nsGkAtoms::autofocus)) {
          // Find the first descendant of element of subject that this
          // not inert and has autofucus attribute
          // inert bug: https://bugzilla.mozilla.org/show_bug.cgi?id=921504
          control = child->AsElement();
          break;
        }
        // If there isn't one, then let control be the first non-inert
        // descendant element of subject, in tree order.
        if (!control) {
          control = child->AsElement();
        }
      }
    }
    child = child->GetNextNode(this);
  }
  // If there isn't one of those either, then let control be subject.
  if (!control) {
    control = this;
  }

  // 3) Run the focusing steps for control.
  ErrorResult rv;
  nsIFrame* frame = control->GetPrimaryFrame();
  if (frame && frame->IsFocusable()) {
    control->Focus(FocusOptions(), CallerType::NonSystem, rv);
    if (rv.Failed()) {
      return;
    }
  } else {
    nsIFocusManager* fm = nsFocusManager::GetFocusManager();
    if (fm) {
      // Clear the focus which ends up making the body gets focused
      fm->ClearFocus(OwnerDoc()->GetWindow());
    }
  }

  // 4) Let topDocument be the active document of control's node document's
  // browsing context's top-level browsing context.
  // 5) If control's node document's origin is not the same as the origin of
  // topDocument, then return.
  BrowsingContext* bc = control->OwnerDoc()->GetBrowsingContext();
  if (bc && bc->SameOriginWithTop()) {
    nsCOMPtr<nsIDocShell> docShell = bc->Top()->GetDocShell();
    if (docShell) {
      if (Document* topDocument = docShell->GetDocument()) {
        // 6) Empty topDocument's autofocus candidates.
        // 7) Set topDocument's autofocus processed flag to true.
        topDocument->SetAutoFocusFired();
      }
    }
  }
}

void HTMLDialogElement::QueueCancelDialog() {
  // queues an element task on the user interaction task source
  OwnerDoc()
      ->EventTargetFor(TaskCategory::UI)
      ->Dispatch(NewRunnableMethod("HTMLDialogElement::RunCancelDialogSteps",
                                   this,
                                   &HTMLDialogElement::RunCancelDialogSteps));
}

void HTMLDialogElement::RunCancelDialogSteps() {
  // 1) Let close be the result of firing an event named cancel at dialog, with
  // the cancelable attribute initialized to true.
  bool defaultAction = true;
  nsContentUtils::DispatchTrustedEvent(
      OwnerDoc(), this, NS_LITERAL_STRING("cancel"), CanBubble::eNo,
      Cancelable::eYes, &defaultAction);

  // 2) If close is true and dialog has an open attribute, then close the dialog
  // with no return value.
  if (defaultAction) {
    Optional<nsAString> retValue;
    Close(retValue);
  }
}

JSObject* HTMLDialogElement::WrapNode(JSContext* aCx,
                                      JS::Handle<JSObject*> aGivenProto) {
  return HTMLDialogElement_Binding::Wrap(aCx, this, aGivenProto);
}

}  // namespace dom
}  // namespace mozilla
