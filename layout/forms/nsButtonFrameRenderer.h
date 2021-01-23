/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef nsButtonFrameRenderer_h___
#define nsButtonFrameRenderer_h___

#include "nsMargin.h"
#include "nsCSSRenderingBorders.h"

class gfxContext;
class nsIFrame;
class nsFrame;
class nsDisplayList;
class nsDisplayListBuilder;
class nsPresContext;
struct nsRect;

#define NS_BUTTON_RENDERER_FOCUS_INNER_CONTEXT_INDEX 0
#define NS_BUTTON_RENDERER_LAST_CONTEXT_INDEX \
  NS_BUTTON_RENDERER_FOCUS_INNER_CONTEXT_INDEX

class nsButtonFrameRenderer {
  typedef mozilla::image::ImgDrawResult ImgDrawResult;
  typedef mozilla::ComputedStyle ComputedStyle;

 public:
  nsButtonFrameRenderer();
  ~nsButtonFrameRenderer();

  /**
   * Create display list items for the button
   */
  nsresult DisplayButton(nsDisplayListBuilder* aBuilder,
                         nsDisplayList* aBackground,
                         nsDisplayList* aForeground);

  ImgDrawResult PaintInnerFocusBorder(nsDisplayListBuilder* aBuilder,
                                      nsPresContext* aPresContext,
                                      gfxContext& aRenderingContext,
                                      const nsRect& aDirtyRect,
                                      const nsRect& aRect);

  mozilla::Maybe<nsCSSBorderRenderer> CreateInnerFocusBorderRenderer(
      nsDisplayListBuilder* aBuilder, nsPresContext* aPresContext,
      gfxContext* aRenderingContext, const nsRect& aDirtyRect,
      const nsRect& aRect, bool* aBorderIsEmpty);

  ImgDrawResult PaintBorder(nsDisplayListBuilder* aBuilder,
                            nsPresContext* aPresContext,
                            gfxContext& aRenderingContext,
                            const nsRect& aDirtyRect, const nsRect& aRect);

  void SetFrame(nsFrame* aFrame, nsPresContext* aPresContext);

  void SetDisabled(bool aDisabled, bool notify);

  bool isActive();
  bool isDisabled();

  void GetButtonInnerFocusRect(const nsRect& aRect, nsRect& aResult);

  ComputedStyle* GetComputedStyle(int32_t aIndex) const;
  void SetComputedStyle(int32_t aIndex, ComputedStyle* aComputedStyle);
  void ReResolveStyles(nsPresContext* aPresContext);

  nsIFrame* GetFrame();

 private:
  // cached style for optional inner focus outline (used on Windows).
  RefPtr<ComputedStyle> mInnerFocusStyle;

  nsFrame* mFrame;
};

#endif
