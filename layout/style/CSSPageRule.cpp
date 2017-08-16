/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/dom/CSSPageRule.h"

#include "mozilla/dom/CSSPageRuleBinding.h"

namespace mozilla {
namespace dom {

NS_IMPL_ADDREF_INHERITED(CSSPageRule, css::Rule)
NS_IMPL_RELEASE_INHERITED(CSSPageRule, css::Rule)

// QueryInterface implementation for CSSPageRule
NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION_INHERITED(CSSPageRule)
  NS_INTERFACE_MAP_ENTRY(nsIDOMCSSPageRule)
NS_INTERFACE_MAP_END_INHERITING(css::Rule)

NS_IMETHODIMP
CSSPageRule::GetStyle(nsIDOMCSSStyleDeclaration** aStyle)
{
  NS_ADDREF(*aStyle = Style());
  return NS_OK;
}

JSObject*
CSSPageRule::WrapObject(JSContext* aCx, JS::Handle<JSObject*> aGivenProto)
{
  return CSSPageRuleBinding::Wrap(aCx, this, aGivenProto);
}

} // namespace dom
} // namespace mozilla
