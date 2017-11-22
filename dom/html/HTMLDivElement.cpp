/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "HTMLDivElement.h"
#include "nsGenericHTMLElement.h"
#include "nsStyleConsts.h"
#include "nsMappedAttributes.h"
#include "mozilla/dom/HTMLDivElementBinding.h"

NS_IMPL_NS_NEW_HTML_ELEMENT(Div)

namespace mozilla {
namespace dom {

HTMLDivElement::~HTMLDivElement()
{
}

NS_IMPL_ELEMENT_CLONE(HTMLDivElement)

JSObject*
HTMLDivElement::WrapNode(JSContext *aCx, JS::Handle<JSObject*> aGivenProto)
{
  return dom::HTMLDivElementBinding::Wrap(aCx, this, aGivenProto);
}

bool
HTMLDivElement::ParseAttribute(int32_t aNamespaceID,
                               nsIAtom* aAttribute,
                               const nsAString& aValue,
                               nsAttrValue& aResult)
{
  if (aNamespaceID == kNameSpaceID_None) {
    if (mNodeInfo->Equals(nsGkAtoms::marquee)) {
      if ((aAttribute == nsGkAtoms::width) ||
          (aAttribute == nsGkAtoms::height)) {
        return aResult.ParseSpecialIntValue(aValue);
      }
      if (aAttribute == nsGkAtoms::bgcolor) {
        return aResult.ParseColor(aValue);
      }
      if ((aAttribute == nsGkAtoms::hspace) ||
          (aAttribute == nsGkAtoms::vspace)) {
        return aResult.ParseIntWithBounds(aValue, 0);
      }
    }

    if (mNodeInfo->Equals(nsGkAtoms::div) &&
        aAttribute == nsGkAtoms::align) {
      return ParseDivAlignValue(aValue, aResult);
    }
  }

  return nsGenericHTMLElement::ParseAttribute(aNamespaceID, aAttribute, aValue,
                                              aResult);
}

void
HTMLDivElement::MapAttributesIntoRule(const nsMappedAttributes* aAttributes,
                                      GenericSpecifiedValues* aData)
{
  nsGenericHTMLElement::MapDivAlignAttributeInto(aAttributes, aData);
  nsGenericHTMLElement::MapCommonAttributesInto(aAttributes, aData);
}

static void
MapMarqueeAttributesIntoRule(const nsMappedAttributes* aAttributes, GenericSpecifiedValues* aData)
{
  nsGenericHTMLElement::MapImageMarginAttributeInto(aAttributes, aData);
  nsGenericHTMLElement::MapImageSizeAttributesInto(aAttributes, aData);
  nsGenericHTMLElement::MapCommonAttributesInto(aAttributes, aData);
  nsGenericHTMLElement::MapBGColorInto(aAttributes, aData);
}

NS_IMETHODIMP_(bool)
HTMLDivElement::IsAttributeMapped(const nsIAtom* aAttribute) const
{
  if (mNodeInfo->Equals(nsGkAtoms::div)) {
    static const MappedAttributeEntry* const map[] = {
      sDivAlignAttributeMap,
      sCommonAttributeMap
    };
    return FindAttributeDependence(aAttribute, map);
  }
  if (mNodeInfo->Equals(nsGkAtoms::marquee)) {
    static const MappedAttributeEntry* const map[] = {
      sImageMarginSizeAttributeMap,
      sBackgroundColorAttributeMap,
      sCommonAttributeMap
    };
    return FindAttributeDependence(aAttribute, map);
  }

  return nsGenericHTMLElement::IsAttributeMapped(aAttribute);
}

nsMapRuleToAttributesFunc
HTMLDivElement::GetAttributeMappingFunction() const
{
  if (mNodeInfo->Equals(nsGkAtoms::div)) {
    return &MapAttributesIntoRule;
  }
  if (mNodeInfo->Equals(nsGkAtoms::marquee)) {
    return &MapMarqueeAttributesIntoRule;
  }
  return nsGenericHTMLElement::GetAttributeMappingFunction();
}

} // namespace dom
} // namespace mozilla
