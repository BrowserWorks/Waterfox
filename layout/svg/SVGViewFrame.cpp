/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

// Keep in (case-insensitive) order:
#include "nsFrame.h"
#include "nsGkAtoms.h"
#include "nsSVGOuterSVGFrame.h"
#include "mozilla/dom/SVGSVGElement.h"
#include "mozilla/dom/SVGViewElement.h"

using namespace mozilla::dom;

/**
 * While views are not directly rendered in SVG they can be linked to
 * and thereby override attributes of an <svg> element via a fragment
 * identifier. The SVGViewFrame class passes on any attribute changes
 * the view receives to the overridden <svg> element (if there is one).
 **/
class SVGViewFrame : public nsFrame
{
  friend nsIFrame*
  NS_NewSVGViewFrame(nsIPresShell* aPresShell, nsStyleContext* aContext);
protected:
  explicit SVGViewFrame(nsStyleContext* aContext)
    : nsFrame(aContext, kClassID)
  {
    AddStateBits(NS_FRAME_IS_NONDISPLAY);
  }

public:
  NS_DECL_FRAMEARENA_HELPERS(SVGViewFrame)

#ifdef DEBUG
  virtual void Init(nsIContent*       aContent,
                    nsContainerFrame* aParent,
                    nsIFrame*         aPrevInFlow) override;
#endif

  virtual bool IsFrameOfType(uint32_t aFlags) const override
  {
    return nsFrame::IsFrameOfType(aFlags & ~(nsIFrame::eSVG));
  }

#ifdef DEBUG_FRAME_DUMP
  virtual nsresult GetFrameName(nsAString& aResult) const override
  {
    return MakeFrameName(NS_LITERAL_STRING("SVGView"), aResult);
  }
#endif

  virtual nsresult AttributeChanged(int32_t  aNameSpaceID,
                                    nsIAtom* aAttribute,
                                    int32_t  aModType) override;

  virtual bool ComputeCustomOverflow(nsOverflowAreas& aOverflowAreas) override {
    // We don't maintain a visual overflow rect
    return false;
  }
};

nsIFrame*
NS_NewSVGViewFrame(nsIPresShell* aPresShell, nsStyleContext* aContext)
{
  return new (aPresShell) SVGViewFrame(aContext);
}

NS_IMPL_FRAMEARENA_HELPERS(SVGViewFrame)

#ifdef DEBUG
void
SVGViewFrame::Init(nsIContent*       aContent,
                   nsContainerFrame* aParent,
                   nsIFrame*         aPrevInFlow)
{
  NS_ASSERTION(aContent->IsSVGElement(nsGkAtoms::view),
               "Content is not an SVG view");

  nsFrame::Init(aContent, aParent, aPrevInFlow);
}
#endif /* DEBUG */

nsresult
SVGViewFrame::AttributeChanged(int32_t  aNameSpaceID,
                               nsIAtom* aAttribute,
                               int32_t  aModType)
{
  // Ignore zoomAndPan as it does not cause the <svg> element to re-render
    
  if (aNameSpaceID == kNameSpaceID_None &&
      (aAttribute == nsGkAtoms::preserveAspectRatio ||
       aAttribute == nsGkAtoms::viewBox ||
       aAttribute == nsGkAtoms::viewTarget)) {

    nsSVGOuterSVGFrame *outerSVGFrame = nsSVGUtils::GetOuterSVGFrame(this);
    NS_ASSERTION(outerSVGFrame->GetContent()->IsSVGElement(nsGkAtoms::svg),
                 "Expecting an <svg> element");

    SVGSVGElement* svgElement =
      static_cast<SVGSVGElement*>(outerSVGFrame->GetContent());

    nsAutoString viewID;
    mContent->GetAttr(kNameSpaceID_None, nsGkAtoms::id, viewID);

    if (svgElement->IsOverriddenBy(viewID)) {
      // We're the view that's providing overrides, so pretend that the frame
      // we're overriding was updated.
      outerSVGFrame->AttributeChanged(aNameSpaceID, aAttribute, aModType);
    }
  }

  return nsFrame::AttributeChanged(aNameSpaceID, aAttribute, aModType);
}
