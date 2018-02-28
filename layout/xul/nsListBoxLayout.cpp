/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsListBoxLayout.h"

#include "nsListBoxBodyFrame.h"
#include "nsBox.h"
#include "nsBoxLayoutState.h"
#include "nsIScrollableFrame.h"
#include "nsIReflowCallback.h"
#include "mozilla/dom/NameSpaceConstants.h"
#include "nsGkAtoms.h"
#include "nsContentUtils.h"

nsListBoxLayout::nsListBoxLayout() : nsGridRowGroupLayout()
{
}

////////// nsBoxLayout //////////////

nsSize
nsListBoxLayout::GetXULPrefSize(nsIFrame* aBox, nsBoxLayoutState& aBoxLayoutState)
{
  nsSize pref = nsGridRowGroupLayout::GetXULPrefSize(aBox, aBoxLayoutState);

  nsListBoxBodyFrame* frame = static_cast<nsListBoxBodyFrame*>(aBox);
  if (frame) {
    nscoord rowheight = frame->GetRowHeightAppUnits();
    pref.height = frame->GetRowCount() * rowheight;
    // Pad the height.
    nscoord y = frame->GetAvailableHeight();
    if (pref.height > y && y > 0 && rowheight > 0) {
      nscoord m = (pref.height-y)%rowheight;
      nscoord remainder = m == 0 ? 0 : rowheight - m;
      pref.height += remainder;
    }
    if (nsContentUtils::HasNonEmptyAttr(frame->GetContent(), kNameSpaceID_None,
                                        nsGkAtoms::sizemode)) {
      nscoord width = frame->ComputeIntrinsicISize(aBoxLayoutState);
      if (width > pref.width)
        pref.width = width;
    }
  }
  return pref;
}

nsSize
nsListBoxLayout::GetXULMinSize(nsIFrame* aBox, nsBoxLayoutState& aBoxLayoutState)
{
  nsSize minSize = nsGridRowGroupLayout::GetXULMinSize(aBox, aBoxLayoutState);

  nsListBoxBodyFrame* frame = static_cast<nsListBoxBodyFrame*>(aBox);
  if (frame) {
    nscoord rowheight = frame->GetRowHeightAppUnits();
    minSize.height = frame->GetRowCount() * rowheight;
    // Pad the height.
    nscoord y = frame->GetAvailableHeight();
    if (minSize.height > y && y > 0 && rowheight > 0) {
      nscoord m = (minSize.height-y)%rowheight;
      nscoord remainder = m == 0 ? 0 : rowheight - m;
      minSize.height += remainder;
    }
    if (nsContentUtils::HasNonEmptyAttr(frame->GetContent(), kNameSpaceID_None,
                                        nsGkAtoms::sizemode)) {
      nscoord width = frame->ComputeIntrinsicISize(aBoxLayoutState);
      if (width > minSize.width)
        minSize.width = width;
    }
  }
  return minSize;
}

nsSize
nsListBoxLayout::GetXULMaxSize(nsIFrame* aBox, nsBoxLayoutState& aBoxLayoutState)
{
  nsSize maxSize = nsGridRowGroupLayout::GetXULMaxSize(aBox, aBoxLayoutState);

  nsListBoxBodyFrame* frame = static_cast<nsListBoxBodyFrame*>(aBox);
  if (frame) {
    nscoord rowheight = frame->GetRowHeightAppUnits();
    maxSize.height = frame->GetRowCount() * rowheight;
    // Pad the height.
    nscoord y = frame->GetAvailableHeight();
    if (maxSize.height > y && y > 0 && rowheight > 0) {
      nscoord m = (maxSize.height-y)%rowheight;
      nscoord remainder = m == 0 ? 0 : rowheight - m;
      maxSize.height += remainder;
    }
  }
  return maxSize;
}

NS_IMETHODIMP
nsListBoxLayout::XULLayout(nsIFrame* aBox, nsBoxLayoutState& aState)
{
  return LayoutInternal(aBox, aState);
}


/////////// nsListBoxLayout /////////////////////////

/**
 * Called to layout our our children. Does no frame construction
 */
NS_IMETHODIMP
nsListBoxLayout::LayoutInternal(nsIFrame* aBox, nsBoxLayoutState& aState)
{
  int32_t redrawStart = -1;

  // Get the start y position.
  nsListBoxBodyFrame* body = static_cast<nsListBoxBodyFrame*>(aBox);
  if (!body) {
    NS_ERROR("Frame encountered that isn't a listboxbody!");
    return NS_ERROR_FAILURE;
  }

  nsMargin margin;

  // Get our client rect.
  nsRect clientRect;
  aBox->GetXULClientRect(clientRect);

  // Get the starting y position and the remaining available
  // height.
  nscoord availableHeight = body->GetAvailableHeight();
  nscoord yOffset = body->GetYPosition();

  if (availableHeight <= 0) {
    bool fixed = (body->GetFixedRowSize() != -1);
    if (fixed)
      availableHeight = 10;
    else
      return NS_OK;
  }

  // run through all our currently created children
  nsIFrame* box = nsBox::GetChildXULBox(body);

  // if the reason is resize or initial we must relayout.
  nscoord rowHeight = body->GetRowHeightAppUnits();

  while (box) {
    // If this box is dirty or if it has dirty children, we
    // call layout on it.
    nsRect childRect(box->GetRect());
    box->GetXULMargin(margin);

    // relayout if we must or we are dirty or some of our children are dirty
    //   or the client area is wider than us
    // XXXldb There should probably be a resize check here too!
    if (NS_SUBTREE_DIRTY(box) || childRect.width < clientRect.width) {
      childRect.x = 0;
      childRect.y = yOffset;
      childRect.width = clientRect.width;

      nsSize size = box->GetXULPrefSize(aState);
      body->SetRowHeight(size.height);

      childRect.height = rowHeight;

      childRect.Deflate(margin);
      box->SetXULBounds(aState, childRect);
      box->XULLayout(aState);
    } else {
      // if the child did not need to be relayed out. Then its easy.
      // Place the child by just grabbing its rect and adjusting the y.
      int32_t newPos = yOffset+margin.top;

      // are we pushing down or pulling up any rows?
      // Then we may have to redraw everything below the moved
      // rows.
      if (redrawStart == -1 && childRect.y != newPos)
        redrawStart = newPos;

      childRect.y = newPos;
      box->SetXULBounds(aState, childRect);
    }

    // Ok now the available size gets smaller and we move the
    // starting position of the next child down some.
    nscoord size = childRect.height + margin.top + margin.bottom;

    yOffset += size;
    availableHeight -= size;

    box = nsBox::GetNextXULBox(box);
  }

  // We have enough available height left to add some more rows
  // Since we can't do this during layout, we post a callback
  // that will be processed after the reflow completes.
  body->PostReflowCallback();

  // if rows were pushed down or pulled up because some rows were added
  // before them then redraw everything under the inserted rows. The inserted
  // rows will automatically be redrawn because the were marked dirty on insertion.
  if (redrawStart > -1) {
    aBox->XULRedraw(aState);
  }

  return NS_OK;
}

// Creation Routines ///////////////////////////////////////////////////////////////////////

already_AddRefed<nsBoxLayout> NS_NewListBoxLayout()
{
  RefPtr<nsBoxLayout> layout = new nsListBoxLayout();
  return layout.forget();
}
