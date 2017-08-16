/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_dom_SVGFESpotLightElement_h
#define mozilla_dom_SVGFESpotLightElement_h

#include "nsSVGFilters.h"
#include "nsSVGNumber2.h"

nsresult NS_NewSVGFESpotLightElement(nsIContent **aResult,
                                     already_AddRefed<mozilla::dom::NodeInfo>&& aNodeInfo);

namespace mozilla {
namespace dom {

typedef SVGFELightElement SVGFESpotLightElementBase;

class SVGFESpotLightElement : public SVGFESpotLightElementBase
{
  friend nsresult (::NS_NewSVGFESpotLightElement(nsIContent **aResult,
                                                 already_AddRefed<mozilla::dom::NodeInfo>&& aNodeInfo));
  friend class ::nsSVGFELightingElement;
protected:
  explicit SVGFESpotLightElement(already_AddRefed<mozilla::dom::NodeInfo>& aNodeInfo)
    : SVGFESpotLightElementBase(aNodeInfo)
  {
  }
  virtual JSObject* WrapNode(JSContext* aCx, JS::Handle<JSObject*> aGivenProto) override;

public:
  virtual AttributeMap ComputeLightAttributes(nsSVGFilterInstance* aInstance) override;
  virtual bool AttributeAffectsRendering(
          int32_t aNameSpaceID, nsIAtom* aAttribute) const override;

  virtual nsresult Clone(mozilla::dom::NodeInfo *aNodeInfo, nsINode **aResult,
                         bool aPreallocateChildren) const override;

  // WebIDL
  already_AddRefed<SVGAnimatedNumber> X();
  already_AddRefed<SVGAnimatedNumber> Y();
  already_AddRefed<SVGAnimatedNumber> Z();
  already_AddRefed<SVGAnimatedNumber> PointsAtX();
  already_AddRefed<SVGAnimatedNumber> PointsAtY();
  already_AddRefed<SVGAnimatedNumber> PointsAtZ();
  already_AddRefed<SVGAnimatedNumber> SpecularExponent();
  already_AddRefed<SVGAnimatedNumber> LimitingConeAngle();

protected:
  virtual NumberAttributesInfo GetNumberInfo() override;

  enum { ATTR_X, ATTR_Y, ATTR_Z, POINTS_AT_X, POINTS_AT_Y, POINTS_AT_Z,
         SPECULAR_EXPONENT, LIMITING_CONE_ANGLE };
  nsSVGNumber2 mNumberAttributes[8];
  static NumberInfo sNumberInfo[8];
};

} // namespace dom
} // namespace mozilla

#endif // mozilla_dom_SVGFESpotLightElement_h
