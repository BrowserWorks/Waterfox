/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
#ifndef nsPageContentFrame_h___
#define nsPageContentFrame_h___

#include "mozilla/Attributes.h"
#include "mozilla/ViewportFrame.h"

class nsPageFrame;
class nsSharedPageData;

// Page frame class used by the simple page sequence frame
class nsPageContentFrame final : public mozilla::ViewportFrame
{
public:
  NS_DECL_FRAMEARENA_HELPERS(nsPageContentFrame)

  friend nsPageContentFrame* NS_NewPageContentFrame(nsIPresShell* aPresShell,
                                                    nsStyleContext* aContext);
  friend class nsPageFrame;

  // nsIFrame
  virtual void Reflow(nsPresContext*      aPresContext,
                      ReflowOutput& aDesiredSize,
                      const ReflowInput& aMaxSize,
                      nsReflowStatus&      aStatus) override;

  virtual bool IsFrameOfType(uint32_t aFlags) const override
  {
    return ViewportFrame::IsFrameOfType(aFlags &
             ~(nsIFrame::eCanContainOverflowContainers));
  }

  virtual void SetSharedPageData(nsSharedPageData* aPD) { mPD = aPD; }

  virtual bool HasTransformGetter() const override { return true; }

  /**
   * Return our canvas frame.
   */
  void AppendDirectlyOwnedAnonBoxes(nsTArray<OwnedAnonBox>& aResult) override;

#ifdef DEBUG_FRAME_DUMP
  // Debugging
  virtual nsresult  GetFrameName(nsAString& aResult) const override;
#endif

protected:
  explicit nsPageContentFrame(nsStyleContext* aContext)
    : ViewportFrame(aContext, kClassID)
  {}

  nsSharedPageData*         mPD;
};

#endif /* nsPageContentFrame_h___ */

