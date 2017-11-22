/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
#include "nsTableColGroupFrame.h"
#include "nsTableColFrame.h"
#include "nsTableFrame.h"
#include "nsStyleContext.h"
#include "nsStyleConsts.h"
#include "nsPresContext.h"
#include "nsHTMLParts.h"
#include "nsGkAtoms.h"
#include "nsCOMPtr.h"
#include "nsCSSRendering.h"
#include "nsIPresShell.h"
#include "mozilla/GeckoStyleContext.h"

using namespace mozilla;

#define COL_GROUP_TYPE_BITS          (NS_FRAME_STATE_BIT(30) | \
                                      NS_FRAME_STATE_BIT(31))
#define COL_GROUP_TYPE_OFFSET        30

nsTableColGroupType
nsTableColGroupFrame::GetColType() const
{
  return (nsTableColGroupType)((mState & COL_GROUP_TYPE_BITS) >> COL_GROUP_TYPE_OFFSET);
}

void nsTableColGroupFrame::SetColType(nsTableColGroupType aType)
{
  NS_ASSERTION(GetColType() == eColGroupContent,
               "should only call nsTableColGroupFrame::SetColType with aType "
               "!= eColGroupContent once");
  uint32_t type = aType - eColGroupContent;
  RemoveStateBits(COL_GROUP_TYPE_BITS);
  AddStateBits(nsFrameState(type << COL_GROUP_TYPE_OFFSET));
}

void nsTableColGroupFrame::ResetColIndices(nsIFrame*       aFirstColGroup,
                                           int32_t         aFirstColIndex,
                                           nsIFrame*       aStartColFrame)
{
  nsTableColGroupFrame* colGroupFrame = (nsTableColGroupFrame*)aFirstColGroup;
  int32_t colIndex = aFirstColIndex;
  while (colGroupFrame) {
    if (colGroupFrame->IsTableColGroupFrame()) {
      // reset the starting col index for the first cg only if we should reset
      // the whole colgroup (aStartColFrame defaults to nullptr) or if
      // aFirstColIndex is smaller than the existing starting col index
      if ((colIndex != aFirstColIndex) ||
          (colIndex < colGroupFrame->GetStartColumnIndex()) ||
          !aStartColFrame) {
        colGroupFrame->SetStartColumnIndex(colIndex);
      }
      nsIFrame* colFrame = aStartColFrame;
      if (!colFrame || (colIndex != aFirstColIndex)) {
        colFrame = colGroupFrame->PrincipalChildList().FirstChild();
      }
      while (colFrame) {
        if (colFrame->IsTableColFrame()) {
          ((nsTableColFrame*)colFrame)->SetColIndex(colIndex);
          colIndex++;
        }
        colFrame = colFrame->GetNextSibling();
      }
    }
    colGroupFrame = static_cast<nsTableColGroupFrame*>
                               (colGroupFrame->GetNextSibling());
  }
}


nsresult
nsTableColGroupFrame::AddColsToTable(int32_t                   aFirstColIndex,
                                     bool                      aResetSubsequentColIndices,
                                     const nsFrameList::Slice& aCols)
{
  nsTableFrame* tableFrame = GetTableFrame();

  tableFrame->InvalidateFrameSubtree();

  // set the col indices of the col frames and and add col info to the table
  int32_t colIndex = aFirstColIndex;
  nsFrameList::Enumerator e(aCols);
  for (; !e.AtEnd(); e.Next()) {
    ((nsTableColFrame*)e.get())->SetColIndex(colIndex);
    mColCount++;
    tableFrame->InsertCol((nsTableColFrame &)*e.get(), colIndex);
    colIndex++;
  }

  for (nsFrameList::Enumerator eTail = e.GetUnlimitedEnumerator();
       !eTail.AtEnd();
       eTail.Next()) {
    ((nsTableColFrame*)eTail.get())->SetColIndex(colIndex);
    colIndex++;
  }

  // We have already set the colindex for all the colframes in this
  // colgroup that come after the first inserted colframe, but there could
  // be other colgroups following this one and their colframes need
  // correct colindices too.
  if (aResetSubsequentColIndices && GetNextSibling()) {
    ResetColIndices(GetNextSibling(), colIndex);
  }

  return NS_OK;
}


nsTableColGroupFrame*
nsTableColGroupFrame::GetLastRealColGroup(nsTableFrame* aTableFrame)
{
  nsFrameList colGroups = aTableFrame->GetColGroups();

  nsIFrame* nextToLastColGroup = nullptr;
  nsFrameList::FrameLinkEnumerator link(colGroups);
  for ( ; !link.AtEnd(); link.Next()) {
    nextToLastColGroup = link.PrevFrame();
  }

  if (!link.PrevFrame()) {
    return nullptr; // there are no col group frames
  }

  nsTableColGroupType lastColGroupType =
    static_cast<nsTableColGroupFrame*>(link.PrevFrame())->GetColType();
  if (eColGroupAnonymousCell == lastColGroupType) {
    return static_cast<nsTableColGroupFrame*>(nextToLastColGroup);
  }

  return static_cast<nsTableColGroupFrame*>(link.PrevFrame());
}

// don't set mColCount here, it is done in AddColsToTable
void
nsTableColGroupFrame::SetInitialChildList(ChildListID     aListID,
                                          nsFrameList&    aChildList)
{
  MOZ_ASSERT(mFrames.IsEmpty(),
             "unexpected second call to SetInitialChildList");
  MOZ_ASSERT(aListID == kPrincipalList, "unexpected child list");
  if (aChildList.IsEmpty()) {
    GetTableFrame()->AppendAnonymousColFrames(this, GetSpan(),
                                              eColAnonymousColGroup, false);
    return;
  }

  mFrames.AppendFrames(this, aChildList);
}

/* virtual */ void
nsTableColGroupFrame::DidSetStyleContext(nsStyleContext* aOldStyleContext)
{
  nsContainerFrame::DidSetStyleContext(aOldStyleContext);

  if (!aOldStyleContext) //avoid this on init
    return;

  nsTableFrame* tableFrame = GetTableFrame();
  if (tableFrame->IsBorderCollapse() &&
      tableFrame->BCRecalcNeeded(aOldStyleContext, StyleContext())) {
    int32_t colCount = GetColCount();
    if (!colCount)
      return; // this is a degenerated colgroup
    TableArea damageArea(GetFirstColumn()->GetColIndex(), 0, colCount,
                         tableFrame->GetRowCount());
    tableFrame->AddBCDamageArea(damageArea);
  }
}

void
nsTableColGroupFrame::AppendFrames(ChildListID     aListID,
                                   nsFrameList&    aFrameList)
{
  NS_ASSERTION(aListID == kPrincipalList, "unexpected child list");

  nsTableColFrame* col = GetFirstColumn();
  nsTableColFrame* nextCol;
  while (col && col->GetColType() == eColAnonymousColGroup) {
    // this colgroup spans one or more columns but now that there is a
    // real column below, spanned anonymous columns should be removed,
    // since the HTML spec says to ignore the span of a colgroup if it
    // has content columns in it.
    nextCol = col->GetNextCol();
    RemoveFrame(kPrincipalList, col);
    col = nextCol;
  }

  const nsFrameList::Slice& newFrames =
    mFrames.AppendFrames(this, aFrameList);
  InsertColsReflow(GetStartColumnIndex() + mColCount, newFrames);
}

void
nsTableColGroupFrame::InsertFrames(ChildListID     aListID,
                                   nsIFrame*       aPrevFrame,
                                   nsFrameList&    aFrameList)
{
  NS_ASSERTION(aListID == kPrincipalList, "unexpected child list");
  NS_ASSERTION(!aPrevFrame || aPrevFrame->GetParent() == this,
               "inserting after sibling frame with different parent");

  nsTableColFrame* col = GetFirstColumn();
  nsTableColFrame* nextCol;
  while (col && col->GetColType() == eColAnonymousColGroup) {
    // this colgroup spans one or more columns but now that there is a
    // real column below, spanned anonymous columns should be removed,
    // since the HTML spec says to ignore the span of a colgroup if it
    // has content columns in it.
    nextCol = col->GetNextCol();
    if (col == aPrevFrame) {
      // This can happen when we're being appended to
      NS_ASSERTION(!nextCol || nextCol->GetColType() != eColAnonymousColGroup,
                   "Inserting in the middle of our anonymous cols?");
      // We'll want to insert at the beginning
      aPrevFrame = nullptr;
    }
    RemoveFrame(kPrincipalList, col);
    col = nextCol;
  }

  NS_ASSERTION(!aPrevFrame || aPrevFrame == aPrevFrame->LastContinuation(),
               "Prev frame should be last in continuation chain");
  NS_ASSERTION(!aPrevFrame || !GetNextColumn(aPrevFrame) ||
               GetNextColumn(aPrevFrame)->GetColType() != eColAnonymousCol,
               "Shouldn't be inserting before a spanned colframe");

  const nsFrameList::Slice& newFrames =
    mFrames.InsertFrames(this, aPrevFrame, aFrameList);
  nsIFrame* prevFrame = nsTableFrame::GetFrameAtOrBefore(
    this, aPrevFrame, LayoutFrameType::TableCol);

  int32_t colIndex = (prevFrame) ? ((nsTableColFrame*)prevFrame)->GetColIndex() + 1 : GetStartColumnIndex();
  InsertColsReflow(colIndex, newFrames);
}

void
nsTableColGroupFrame::InsertColsReflow(int32_t                   aColIndex,
                                       const nsFrameList::Slice& aCols)
{
  AddColsToTable(aColIndex, true, aCols);

  PresContext()->PresShell()->FrameNeedsReflow(this,
                                               nsIPresShell::eTreeChange,
                                               NS_FRAME_HAS_DIRTY_CHILDREN);
}

void
nsTableColGroupFrame::RemoveChild(nsTableColFrame& aChild,
                                  bool             aResetSubsequentColIndices)
{
  int32_t colIndex = 0;
  nsIFrame* nextChild = nullptr;
  if (aResetSubsequentColIndices) {
    colIndex = aChild.GetColIndex();
    nextChild = aChild.GetNextSibling();
  }
  mFrames.DestroyFrame(&aChild);
  mColCount--;
  if (aResetSubsequentColIndices) {
    if (nextChild) { // reset inside this and all following colgroups
      ResetColIndices(this, colIndex, nextChild);
    }
    else {
      nsIFrame* nextGroup = GetNextSibling();
      if (nextGroup) // reset next and all following colgroups
        ResetColIndices(nextGroup, colIndex);
    }
  }

  PresContext()->PresShell()->FrameNeedsReflow(this,
                                               nsIPresShell::eTreeChange,
                                               NS_FRAME_HAS_DIRTY_CHILDREN);
}

void
nsTableColGroupFrame::RemoveFrame(ChildListID     aListID,
                                  nsIFrame*       aOldFrame)
{
  NS_ASSERTION(aListID == kPrincipalList, "unexpected child list");

  if (!aOldFrame) {
    return;
  }
  bool contentRemoval = false;

  if (aOldFrame->IsTableColFrame()) {
    nsTableColFrame* colFrame = (nsTableColFrame*)aOldFrame;
    if (colFrame->GetColType() == eColContent) {
      contentRemoval = true;
      // Remove any anonymous column frames this <col> produced via a colspan
      nsTableColFrame* col = colFrame->GetNextCol();
      nsTableColFrame* nextCol;
      while (col && col->GetColType() == eColAnonymousCol) {
#ifdef DEBUG
        nsIFrame* providerFrame;
        nsStyleContext* psc = colFrame->GetParentStyleContext(&providerFrame);
        if (psc->IsGecko()) {
          // This check code is useful only in Gecko-backed style system.
          if (colFrame->StyleContext()->AsGecko()->GetParent() == psc->AsGecko()) {
            NS_ASSERTION(col->StyleContext() == colFrame->StyleContext() &&
                         col->GetContent() == colFrame->GetContent(),
                         "How did that happen??");
          }
          // else colFrame is being removed because of a frame
          // reconstruct on it, and its style context is still the old
          // one, so we can't assert anything about how it compares to
          // col's style context.
        }
#endif
        nextCol = col->GetNextCol();
        RemoveFrame(kPrincipalList, col);
        col = nextCol;
      }
    }

    int32_t colIndex = colFrame->GetColIndex();
    // The RemoveChild call handles calling FrameNeedsReflow on us.
    RemoveChild(*colFrame, true);

    nsTableFrame* tableFrame = GetTableFrame();
    tableFrame->RemoveCol(this, colIndex, true, true);
    if (mFrames.IsEmpty() && contentRemoval &&
        GetColType() == eColGroupContent) {
      tableFrame->AppendAnonymousColFrames(this, GetSpan(),
                                           eColAnonymousColGroup, true);
    }
  }
  else {
    mFrames.DestroyFrame(aOldFrame);
  }
}

nsIFrame::LogicalSides
nsTableColGroupFrame::GetLogicalSkipSides(const ReflowInput* aReflowInput) const
{
  if (MOZ_UNLIKELY(StyleBorder()->mBoxDecorationBreak ==
                     StyleBoxDecorationBreak::Clone)) {
    return LogicalSides();
  }

  LogicalSides skip;
  if (nullptr != GetPrevInFlow()) {
    skip |= eLogicalSideBitsBStart;
  }
  if (nullptr != GetNextInFlow()) {
    skip |= eLogicalSideBitsBEnd;
  }
  return skip;
}

void
nsTableColGroupFrame::Reflow(nsPresContext*          aPresContext,
                             ReflowOutput&     aDesiredSize,
                             const ReflowInput& aReflowInput,
                             nsReflowStatus&          aStatus)
{
  MarkInReflow();
  DO_GLOBAL_REFLOW_COUNT("nsTableColGroupFrame");
  DISPLAY_REFLOW(aPresContext, this, aReflowInput, aDesiredSize, aStatus);
  NS_ASSERTION(nullptr!=mContent, "bad state -- null content for frame");

  const nsStyleVisibility* groupVis = StyleVisibility();
  bool collapseGroup = (NS_STYLE_VISIBILITY_COLLAPSE == groupVis->mVisible);
  if (collapseGroup) {
    GetTableFrame()->SetNeedToCollapse(true);
  }
  // for every content child that (is a column thingy and does not already have a frame)
  // create a frame and adjust it's style

  for (nsIFrame *kidFrame = mFrames.FirstChild(); kidFrame;
       kidFrame = kidFrame->GetNextSibling()) {
    // Give the child frame a chance to reflow, even though we know it'll have 0 size
    ReflowOutput kidSize(aReflowInput);
    ReflowInput kidReflowInput(aPresContext, aReflowInput, kidFrame,
                                     LogicalSize(kidFrame->GetWritingMode()));

    nsReflowStatus status;
    ReflowChild(kidFrame, aPresContext, kidSize, kidReflowInput, 0, 0, 0, status);
    FinishReflowChild(kidFrame, aPresContext, kidSize, nullptr, 0, 0, 0);
  }

  aDesiredSize.ClearSize();
  aStatus.Reset();
  NS_FRAME_SET_TRUNCATION(aStatus, aReflowInput, aDesiredSize);
}

void
nsTableColGroupFrame::BuildDisplayList(nsDisplayListBuilder*   aBuilder,
                                       const nsRect&           aDirtyRect,
                                       const nsDisplayListSet& aLists)
{
  nsTableFrame::DisplayGenericTablePart(aBuilder, this, aDirtyRect, aLists);
}

nsTableColFrame * nsTableColGroupFrame::GetFirstColumn()
{
  return GetNextColumn(nullptr);
}

nsTableColFrame * nsTableColGroupFrame::GetNextColumn(nsIFrame *aChildFrame)
{
  nsTableColFrame *result = nullptr;
  nsIFrame *childFrame = aChildFrame;
  if (!childFrame) {
    childFrame = mFrames.FirstChild();
  }
  else {
    childFrame = childFrame->GetNextSibling();
  }
  while (childFrame)
  {
    if (mozilla::StyleDisplay::TableColumn ==
        childFrame->StyleDisplay()->mDisplay)
    {
      result = (nsTableColFrame *)childFrame;
      break;
    }
    childFrame = childFrame->GetNextSibling();
  }
  return result;
}

int32_t nsTableColGroupFrame::GetSpan()
{
  return StyleTable()->mSpan;
}

void nsTableColGroupFrame::SetContinuousBCBorderWidth(LogicalSide aForSide,
                                                      BCPixelSize aPixelValue)
{
  switch (aForSide) {
    case eLogicalSideBStart:
      mBStartContBorderWidth = aPixelValue;
      return;
    case eLogicalSideBEnd:
      mBEndContBorderWidth = aPixelValue;
      return;
    default:
      NS_ERROR("invalid side arg");
  }
}

void nsTableColGroupFrame::GetContinuousBCBorderWidth(WritingMode aWM,
                                                      LogicalMargin& aBorder)
{
  int32_t aPixelsToTwips = nsPresContext::AppUnitsPerCSSPixel();
  nsTableColFrame* col = GetTableFrame()->
    GetColFrame(mStartColIndex + mColCount - 1);
  col->GetContinuousBCBorderWidth(aWM, aBorder);
  aBorder.BStart(aWM) = BC_BORDER_END_HALF_COORD(aPixelsToTwips,
                                                 mBStartContBorderWidth);
  aBorder.BEnd(aWM) = BC_BORDER_START_HALF_COORD(aPixelsToTwips,
                                                 mBEndContBorderWidth);
}

/* ----- global methods ----- */

nsTableColGroupFrame*
NS_NewTableColGroupFrame(nsIPresShell* aPresShell, nsStyleContext* aContext)
{
  return new (aPresShell) nsTableColGroupFrame(aContext);
}

NS_IMPL_FRAMEARENA_HELPERS(nsTableColGroupFrame)

void
nsTableColGroupFrame::InvalidateFrame(uint32_t aDisplayItemKey)
{
  nsIFrame::InvalidateFrame(aDisplayItemKey);
  GetParent()->InvalidateFrameWithRect(GetVisualOverflowRect() + GetPosition(), aDisplayItemKey);
}

void
nsTableColGroupFrame::InvalidateFrameWithRect(const nsRect& aRect,
                                              uint32_t aDisplayItemKey)
{
  nsIFrame::InvalidateFrameWithRect(aRect, aDisplayItemKey);
  // If we have filters applied that would affects our bounds, then
  // we get an inactive layer created and this is computed
  // within FrameLayerBuilder
  GetParent()->InvalidateFrameWithRect(aRect + GetPosition(), aDisplayItemKey);
}

#ifdef DEBUG_FRAME_DUMP
nsresult
nsTableColGroupFrame::GetFrameName(nsAString& aResult) const
{
  return MakeFrameName(NS_LITERAL_STRING("TableColGroup"), aResult);
}

void nsTableColGroupFrame::Dump(int32_t aIndent)
{
  char* indent = new char[aIndent + 1];
  if (!indent) return;
  for (int32_t i = 0; i < aIndent + 1; i++) {
    indent[i] = ' ';
  }
  indent[aIndent] = 0;

  printf("%s**START COLGROUP DUMP**\n%s startcolIndex=%d  colcount=%d span=%d coltype=",
    indent, indent, GetStartColumnIndex(),  GetColCount(), GetSpan());
  nsTableColGroupType colType = GetColType();
  switch (colType) {
  case eColGroupContent:
    printf(" content ");
    break;
  case eColGroupAnonymousCol:
    printf(" anonymous-column  ");
    break;
  case eColGroupAnonymousCell:
    printf(" anonymous-cell ");
    break;
  }
  // verify the colindices
  int32_t j = GetStartColumnIndex();
  nsTableColFrame* col = GetFirstColumn();
  while (col) {
    NS_ASSERTION(j == col->GetColIndex(), "wrong colindex on col frame");
    col = col->GetNextCol();
    j++;
  }
  NS_ASSERTION((j - GetStartColumnIndex()) == GetColCount(),
               "number of cols out of sync");
  printf("\n%s**END COLGROUP DUMP** ", indent);
  delete [] indent;
}
#endif

