/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "CustomEvent.h"
#include "mozilla/dom/CustomEventBinding.h"

#include "mozilla/dom/BindingUtils.h"
#include "nsContentUtils.h"
#include "nsIXPConnect.h"

using namespace mozilla;
using namespace mozilla::dom;

CustomEvent::CustomEvent(mozilla::dom::EventTarget* aOwner,
                         nsPresContext* aPresContext,
                         mozilla::WidgetEvent* aEvent)
  : Event(aOwner, aPresContext, aEvent)
  , mDetail(JS::NullValue())
{
  mozilla::HoldJSObjects(this);
}

CustomEvent::~CustomEvent()
{
  mozilla::DropJSObjects(this);
}

NS_IMPL_CYCLE_COLLECTION_CLASS(CustomEvent)
NS_IMPL_CYCLE_COLLECTION_UNLINK_BEGIN_INHERITED(CustomEvent, Event)
  tmp->mDetail.setUndefined();
  mozilla::DropJSObjects(this);
NS_IMPL_CYCLE_COLLECTION_UNLINK_END

NS_IMPL_CYCLE_COLLECTION_TRAVERSE_BEGIN_INHERITED(CustomEvent, Event)
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_END

NS_IMPL_CYCLE_COLLECTION_TRACE_BEGIN_INHERITED(CustomEvent, Event)
  NS_IMPL_CYCLE_COLLECTION_TRACE_JS_MEMBER_CALLBACK(mDetail)
NS_IMPL_CYCLE_COLLECTION_TRACE_END

NS_IMPL_ADDREF_INHERITED(CustomEvent, Event)
NS_IMPL_RELEASE_INHERITED(CustomEvent, Event)

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION_INHERITED(CustomEvent)
  NS_INTERFACE_MAP_ENTRY(nsIDOMCustomEvent)
NS_INTERFACE_MAP_END_INHERITING(Event)

already_AddRefed<CustomEvent>
CustomEvent::Constructor(const GlobalObject& aGlobal,
                         const nsAString& aType,
                         const CustomEventInit& aParam,
                         ErrorResult& aRv)
{
  nsCOMPtr<mozilla::dom::EventTarget> t = do_QueryInterface(aGlobal.GetAsSupports());
  RefPtr<CustomEvent> e = new CustomEvent(t, nullptr, nullptr);
  bool trusted = e->Init(t);
  JS::Rooted<JS::Value> detail(aGlobal.Context(), aParam.mDetail);
  e->InitCustomEvent(aGlobal.Context(), aType, aParam.mBubbles, aParam.mCancelable, detail, aRv);
  e->SetTrusted(trusted);
  e->SetComposed(aParam.mComposed);
  return e.forget();
}

JSObject*
CustomEvent::WrapObjectInternal(JSContext* aCx, JS::Handle<JSObject*> aGivenProto)
{
  return mozilla::dom::CustomEventBinding::Wrap(aCx, this, aGivenProto);
}

NS_IMETHODIMP
CustomEvent::InitCustomEvent(const nsAString& aType,
                             bool aCanBubble,
                             bool aCancelable,
                             nsIVariant* aDetail)
{
  NS_ENSURE_TRUE(!mEvent->mFlags.mIsBeingDispatched, NS_OK);

  AutoJSAPI jsapi;
  NS_ENSURE_STATE(jsapi.Init(GetParentObject()));
  JSContext* cx = jsapi.cx();
  JS::Rooted<JS::Value> detail(cx);

  if (!aDetail) {
    detail = JS::NullValue();
  } else if (NS_WARN_IF(!VariantToJsval(cx, aDetail, &detail))) {
    JS_ClearPendingException(cx);
    return NS_ERROR_FAILURE;
  }

  Event::InitEvent(aType, aCanBubble, aCancelable);
  mDetail = detail;

  return NS_OK;
}

void
CustomEvent::InitCustomEvent(JSContext* aCx,
                             const nsAString& aType,
                             bool aCanBubble,
                             bool aCancelable,
                             JS::Handle<JS::Value> aDetail,
                             ErrorResult& aRv)
{
  NS_ENSURE_TRUE_VOID(!mEvent->mFlags.mIsBeingDispatched);

  Event::InitEvent(aType, aCanBubble, aCancelable);
  mDetail = aDetail;
}

NS_IMETHODIMP
CustomEvent::GetDetail(nsIVariant** aDetail)
{
  if (mDetail.isNull()) {
    *aDetail = nullptr;
    return NS_OK;
  }

  AutoJSAPI jsapi;
  NS_ENSURE_STATE(jsapi.Init(GetParentObject()));
  JSContext* cx = jsapi.cx();
  JS::Rooted<JS::Value> detail(cx, mDetail);
  nsIXPConnect* xpc = nsContentUtils::XPConnect();

  if (NS_WARN_IF(!xpc)) {
    return NS_ERROR_FAILURE;
  }

  return xpc->JSToVariant(cx, detail, aDetail);
}

void
CustomEvent::GetDetail(JSContext* aCx,
                       JS::MutableHandle<JS::Value> aRetval)
{
  aRetval.set(mDetail);
}

already_AddRefed<CustomEvent>
NS_NewDOMCustomEvent(EventTarget* aOwner,
                     nsPresContext* aPresContext,
                     mozilla::WidgetEvent* aEvent)
{
  RefPtr<CustomEvent> it =
    new CustomEvent(aOwner, aPresContext, aEvent);
  return it.forget();
}
