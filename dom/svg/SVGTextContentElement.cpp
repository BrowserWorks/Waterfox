/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/dom/SVGTextContentElement.h"

#include "mozilla/dom/SVGIRect.h"
#include "nsBidiUtils.h"
#include "nsISVGPoint.h"
#include "nsTextFragment.h"
#include "nsTextFrameUtils.h"
#include "nsTextNode.h"
#include "SVGTextFrame.h"

namespace mozilla {
namespace dom {

nsSVGEnumMapping SVGTextContentElement::sLengthAdjustMap[] = {
  { &nsGkAtoms::spacing, SVG_LENGTHADJUST_SPACING },
  { &nsGkAtoms::spacingAndGlyphs, SVG_LENGTHADJUST_SPACINGANDGLYPHS },
  { nullptr, 0 }
};

nsSVGElement::EnumInfo SVGTextContentElement::sEnumInfo[1] =
{
  { &nsGkAtoms::lengthAdjust, sLengthAdjustMap, SVG_LENGTHADJUST_SPACING }
};

nsSVGElement::LengthInfo SVGTextContentElement::sLengthInfo[1] =
{
  { &nsGkAtoms::textLength, 0, nsIDOMSVGLength::SVG_LENGTHTYPE_NUMBER, SVGContentUtils::XY }
};

SVGTextFrame*
SVGTextContentElement::GetSVGTextFrame()
{
  nsIFrame* frame = GetPrimaryFrame(FlushType::Layout);
  nsIFrame* textFrame =
    nsLayoutUtils::GetClosestFrameOfType(frame, LayoutFrameType::SVGText);
  return static_cast<SVGTextFrame*>(textFrame);
}

SVGTextFrame*
SVGTextContentElement::GetSVGTextFrameForNonLayoutDependentQuery()
{
  nsIFrame* frame = GetPrimaryFrame(FlushType::Frames);
  nsIFrame* textFrame =
    nsLayoutUtils::GetClosestFrameOfType(frame, LayoutFrameType::SVGText);
  return static_cast<SVGTextFrame*>(textFrame);
}

already_AddRefed<SVGAnimatedLength>
SVGTextContentElement::TextLength()
{
  return LengthAttributes()[TEXTLENGTH].ToDOMAnimatedLength(this);
}

already_AddRefed<SVGAnimatedEnumeration>
SVGTextContentElement::LengthAdjust()
{
  return EnumAttributes()[LENGTHADJUST].ToDOMAnimatedEnum(this);
}

//----------------------------------------------------------------------

template<typename T>
static bool
FragmentHasSkippableCharacter(const T* aBuffer, uint32_t aLength)
{
  for (uint32_t i = 0; i < aLength; i++) {
    if (nsTextFrameUtils::IsSkippableCharacterForTransformText(aBuffer[i])) {
      return true;
    }
  }
  return false;
}

Maybe<int32_t>
SVGTextContentElement::GetNonLayoutDependentNumberOfChars()
{
  SVGTextFrame* frame = GetSVGTextFrameForNonLayoutDependentQuery();
  if (!frame || frame != GetPrimaryFrame()) {
    // Only support this fast path on <text>, not child <tspan>s, etc.
    return Some(0);
  }

  uint32_t num = 0;

  for (nsINode* n = Element::GetFirstChild(); n; n = n->GetNextSibling()) {
    if (!n->IsNodeOfType(nsINode::eTEXT)) {
      return Nothing();
    }

    const nsTextFragment* text = static_cast<nsTextNode*>(n)->GetText();
    uint32_t length = text->GetLength();

    if (text->Is2b()) {
      if (FragmentHasSkippableCharacter(text->Get2b(), length)) {
        return Nothing();
      }
    } else {
      auto buffer = reinterpret_cast<const uint8_t*>(text->Get1b());
      if (FragmentHasSkippableCharacter(buffer, length)) {
        return Nothing();
      }
    }

    num += length;
  }

  return Some(num);
}

int32_t
SVGTextContentElement::GetNumberOfChars()
{
  Maybe<int32_t> num = GetNonLayoutDependentNumberOfChars();
  if (num) {
    return *num;
  }

  SVGTextFrame* textFrame = GetSVGTextFrame();
  return textFrame ? textFrame->GetNumberOfChars(this) : 0;
}

float
SVGTextContentElement::GetComputedTextLength()
{
  SVGTextFrame* textFrame = GetSVGTextFrame();
  return textFrame ? textFrame->GetComputedTextLength(this) : 0.0f;
}

void
SVGTextContentElement::SelectSubString(uint32_t charnum, uint32_t nchars, ErrorResult& rv)
{
  SVGTextFrame* textFrame = GetSVGTextFrame();
  if (!textFrame)
    return;

  rv = textFrame->SelectSubString(this, charnum, nchars);
}

float
SVGTextContentElement::GetSubStringLength(uint32_t charnum, uint32_t nchars, ErrorResult& rv)
{
  SVGTextFrame* textFrame = GetSVGTextFrame();
  if (!textFrame)
    return 0.0f;

  float length = 0.0f;
  rv = textFrame->GetSubStringLength(this, charnum, nchars, &length);
  return length;
}

already_AddRefed<nsISVGPoint>
SVGTextContentElement::GetStartPositionOfChar(uint32_t charnum, ErrorResult& rv)
{
  SVGTextFrame* textFrame = GetSVGTextFrame();
  if (!textFrame) {
    rv.Throw(NS_ERROR_FAILURE);
    return nullptr;
  }

  nsCOMPtr<nsISVGPoint> point;
  rv = textFrame->GetStartPositionOfChar(this, charnum, getter_AddRefs(point));
  return point.forget();
}

already_AddRefed<nsISVGPoint>
SVGTextContentElement::GetEndPositionOfChar(uint32_t charnum, ErrorResult& rv)
{
  SVGTextFrame* textFrame = GetSVGTextFrame();
  if (!textFrame) {
    rv.Throw(NS_ERROR_FAILURE);
    return nullptr;
  }

  nsCOMPtr<nsISVGPoint> point;
  rv = textFrame->GetEndPositionOfChar(this, charnum, getter_AddRefs(point));
  return point.forget();
}

already_AddRefed<SVGIRect>
SVGTextContentElement::GetExtentOfChar(uint32_t charnum, ErrorResult& rv)
{
  SVGTextFrame* textFrame = GetSVGTextFrame();

  if (!textFrame) {
    rv.Throw(NS_ERROR_FAILURE);
    return nullptr;
  }

  RefPtr<SVGIRect> rect;
  rv = textFrame->GetExtentOfChar(this, charnum, getter_AddRefs(rect));
  return rect.forget();
}

float
SVGTextContentElement::GetRotationOfChar(uint32_t charnum, ErrorResult& rv)
{
  SVGTextFrame* textFrame = GetSVGTextFrame();

  if (!textFrame) {
    rv.Throw(NS_ERROR_FAILURE);
    return 0.0f;
  }

  float rotation;
  rv = textFrame->GetRotationOfChar(this, charnum, &rotation);
  return rotation;
}

int32_t
SVGTextContentElement::GetCharNumAtPosition(nsISVGPoint& aPoint)
{
  SVGTextFrame* textFrame = GetSVGTextFrame();
  return textFrame ? textFrame->GetCharNumAtPosition(this, &aPoint) : -1;
}

} // namespace dom
} // namespace mozilla
