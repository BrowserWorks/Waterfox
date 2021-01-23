/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef __NS_SVGVIEWPORTFRAME_H__
#define __NS_SVGVIEWPORTFRAME_H__

#include "mozilla/Attributes.h"
#include "nsSVGContainerFrame.h"
#include "nsISVGSVGFrame.h"

class gfxContext;
/**
 * Superclass for inner SVG frames and symbol frames.
 */
class nsSVGViewportFrame : public nsSVGDisplayContainerFrame,
                           public nsISVGSVGFrame {
 protected:
  nsSVGViewportFrame(ComputedStyle* aStyle, nsPresContext* aPresContext,
                     nsIFrame::ClassID aID)
      : nsSVGDisplayContainerFrame(aStyle, aPresContext, aID) {}

 public:
  NS_DECL_ABSTRACT_FRAME(nsSVGViewportFrame)

  virtual nsresult AttributeChanged(int32_t aNameSpaceID, nsAtom* aAttribute,
                                    int32_t aModType) override;

  // nsSVGDisplayableFrame interface:
  virtual void PaintSVG(gfxContext& aContext, const gfxMatrix& aTransform,
                        imgDrawingParams& aImgParams,
                        const nsIntRect* aDirtyRect = nullptr) override;
  virtual void ReflowSVG() override;
  virtual void NotifySVGChanged(uint32_t aFlags) override;
  SVGBBox GetBBoxContribution(const Matrix& aToBBoxUserspace,
                              uint32_t aFlags) override;
  virtual nsIFrame* GetFrameForPoint(const gfxPoint& aPoint) override;

  // nsSVGContainerFrame methods:
  virtual bool HasChildrenOnlyTransform(Matrix* aTransform) const override;

  // nsISVGSVGFrame interface:
  virtual void NotifyViewportOrTransformChanged(uint32_t aFlags) override;
};

#endif  // __NS_SVGVIEWPORTFRAME_H__
