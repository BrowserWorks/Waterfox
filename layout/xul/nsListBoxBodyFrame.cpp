/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsListBoxBodyFrame.h"

#include "nsListBoxLayout.h"

#include "mozilla/MathAlgorithms.h"
#include "nsCOMPtr.h"
#include "nsGridRowGroupLayout.h"
#include "nsIServiceManager.h"
#include "nsGkAtoms.h"
#include "nsIContent.h"
#include "nsNameSpaceManager.h"
#include "nsIDocument.h"
#include "nsIDOMMouseEvent.h"
#include "nsIDOMElement.h"
#include "nsIDOMNodeList.h"
#include "nsCSSFrameConstructor.h"
#include "nsIScrollableFrame.h"
#include "nsScrollbarFrame.h"
#include "nsView.h"
#include "nsViewManager.h"
#include "nsStyleContext.h"
#include "nsFontMetrics.h"
#include "nsITimer.h"
#include "mozilla/StyleSetHandle.h"
#include "mozilla/StyleSetHandleInlines.h"
#include "nsPIBoxObject.h"
#include "nsLayoutUtils.h"
#include "nsPIListBoxObject.h"
#include "nsContentUtils.h"
#include "ChildIterator.h"
#include "nsRenderingContext.h"
#include "prtime.h"
#include <algorithm>

#ifdef ACCESSIBILITY
#include "nsAccessibilityService.h"
#endif

using namespace mozilla;
using namespace mozilla::dom;

/////////////// nsListScrollSmoother //////////////////

/* A mediator used to smooth out scrolling. It works by seeing if 
 * we have time to scroll the amount of rows requested. This is determined
 * by measuring how long it takes to scroll a row. If we can scroll the 
 * rows in time we do so. If not we start a timer and skip the request. We
 * do this until the timer finally first because the user has stopped moving
 * the mouse. Then do all the queued requests in on shot.
 */

// the longest amount of time that can go by before the use
// notices it as a delay.
#define USER_TIME_THRESHOLD 150000

// how long it takes to layout a single row initial value.
// we will time this after we scroll a few rows.
#define TIME_PER_ROW_INITAL  50000

// if we decide we can't layout the rows in the amount of time. How long
// do we wait before checking again?
#define SMOOTH_INTERVAL 100

class nsListScrollSmoother final
{
private:
  ~nsListScrollSmoother();

public:
  NS_INLINE_DECL_REFCOUNTING(nsListScrollSmoother)

  explicit nsListScrollSmoother(nsListBoxBodyFrame* aOuter);

  void Start();
  void Stop();
  bool IsRunning();

  nsCOMPtr<nsITimer> mRepeatTimer;
  int32_t mDelta;
  nsListBoxBodyFrame* mOuter;
};

nsListScrollSmoother::nsListScrollSmoother(nsListBoxBodyFrame* aOuter)
{
  mDelta = 0;
  mOuter = aOuter;
}

nsListScrollSmoother::~nsListScrollSmoother()
{
  Stop();
}

bool
nsListScrollSmoother::IsRunning()
{
  return mRepeatTimer ? true : false;
}

void
nsListScrollSmoother::Start()
{
  nsTimerCallbackFunc scrollSmootherCallback = [](nsITimer* aTimer,
                                                  void* aClosure) {
    // The passed-in nsListScrollSmoother is always alive here. Because if
    // nsListScrollSmoother died, mRepeatTimer->Stop() would be called during
    // the destruction and this callback would never be invoked.
    auto self = static_cast<nsListScrollSmoother*>(aClosure);

    self->Stop();

    NS_ASSERTION(self->mOuter, "mOuter is null, see bug #68365");
    if (self->mOuter) {
      // actually do some work.
      self->mOuter->InternalPositionChangedCallback();
    }
  };

  Stop();
  mRepeatTimer = do_CreateInstance("@mozilla.org/timer;1");
  nsIContent* content = nullptr;
  if (mOuter) {
    content = mOuter->GetContent();
  }
  if (content) {
    mRepeatTimer->SetTarget(
        content->OwnerDoc()->EventTargetFor(TaskCategory::Other));
  }
  mRepeatTimer->InitWithNamedFuncCallback(scrollSmootherCallback,
                                          this,
                                          SMOOTH_INTERVAL,
                                          nsITimer::TYPE_ONE_SHOT,
                                          "scrollSmootherCallback");
}

void
nsListScrollSmoother::Stop()
{
  if ( mRepeatTimer ) {
    mRepeatTimer->Cancel();
    mRepeatTimer = nullptr;
  }
}

/////////////// nsListBoxBodyFrame //////////////////

nsListBoxBodyFrame::nsListBoxBodyFrame(nsStyleContext* aContext,
                                       nsBoxLayout* aLayoutManager)
  : nsBoxFrame(aContext, kClassID, false, aLayoutManager),
    mTopFrame(nullptr),
    mBottomFrame(nullptr),
    mLinkupFrame(nullptr),
    mScrollSmoother(nullptr),
    mRowsToPrepend(0),
    mRowCount(-1),
    mRowHeight(0),
    mAvailableHeight(0),
    mStringWidth(-1),
    mCurrentIndex(0),
    mOldIndex(0),
    mYPosition(0),
    mTimePerRow(TIME_PER_ROW_INITAL),
    mRowHeightWasSet(false),
    mScrolling(false),
    mAdjustScroll(false),
    mReflowCallbackPosted(false)
{
}

nsListBoxBodyFrame::~nsListBoxBodyFrame()
{
  NS_IF_RELEASE(mScrollSmoother);

#if USE_TIMER_TO_DELAY_SCROLLING
  StopScrollTracking();
  mAutoScrollTimer = nullptr;
#endif

}

NS_QUERYFRAME_HEAD(nsListBoxBodyFrame)
  NS_QUERYFRAME_ENTRY(nsIScrollbarMediator)
  NS_QUERYFRAME_ENTRY(nsListBoxBodyFrame)
NS_QUERYFRAME_TAIL_INHERITING(nsBoxFrame)

////////// nsIFrame /////////////////

void
nsListBoxBodyFrame::Init(nsIContent*       aContent,
                         nsContainerFrame* aParent, 
                         nsIFrame*         aPrevInFlow)
{
  nsBoxFrame::Init(aContent, aParent, aPrevInFlow);
  // Don't call nsLayoutUtils::GetScrollableFrameFor since we are not its
  // scrollframe child yet.
  nsIScrollableFrame* scrollFrame = do_QueryFrame(aParent);
  if (scrollFrame) {
    nsIFrame* verticalScrollbar = scrollFrame->GetScrollbarBox(true);
    nsScrollbarFrame* scrollbarFrame = do_QueryFrame(verticalScrollbar);
    if (scrollbarFrame) {
      scrollbarFrame->SetScrollbarMediatorContent(GetContent());
    }
  }
  RefPtr<nsFontMetrics> fm =
    nsLayoutUtils::GetFontMetricsForFrame(this, 1.0f);
  mRowHeight = fm->MaxHeight();
}

void
nsListBoxBodyFrame::DestroyFrom(nsIFrame* aDestructRoot)
{
  // make sure we cancel any posted callbacks.
  if (mReflowCallbackPosted)
     PresContext()->PresShell()->CancelReflowCallback(this);

  // Revoke any pending position changed events
  for (uint32_t i = 0; i < mPendingPositionChangeEvents.Length(); ++i) {
    mPendingPositionChangeEvents[i]->Revoke();
  }

  // Make sure we tell our listbox's box object we're being destroyed.
  if (mBoxObject) {
    mBoxObject->ClearCachedValues();
  }

  nsBoxFrame::DestroyFrom(aDestructRoot);
}

nsresult
nsListBoxBodyFrame::AttributeChanged(int32_t aNameSpaceID,
                                     nsIAtom* aAttribute, 
                                     int32_t aModType)
{
  nsresult rv = NS_OK;

  if (aAttribute == nsGkAtoms::rows) {
    PresContext()->PresShell()->
      FrameNeedsReflow(this, nsIPresShell::eStyleChange, NS_FRAME_IS_DIRTY);
  }
  else
    rv = nsBoxFrame::AttributeChanged(aNameSpaceID, aAttribute, aModType);

  return rv;
 
}

/* virtual */ void
nsListBoxBodyFrame::MarkIntrinsicISizesDirty()
{
  mStringWidth = -1;
  nsBoxFrame::MarkIntrinsicISizesDirty();
}

/////////// nsBox ///////////////

NS_IMETHODIMP
nsListBoxBodyFrame::DoXULLayout(nsBoxLayoutState& aBoxLayoutState)
{
  if (mScrolling)
    aBoxLayoutState.SetPaintingDisabled(true);

  nsresult rv = nsBoxFrame::DoXULLayout(aBoxLayoutState);

  // determine the real height for the scrollable area from the total number
  // of rows, since non-visible rows don't yet have frames
  nsRect rect(nsPoint(0, 0), GetSize());
  nsOverflowAreas overflow(rect, rect);
  if (mLayoutManager) {
    nsIFrame* childFrame = mFrames.FirstChild();
    while (childFrame) {
      ConsiderChildOverflow(overflow, childFrame);
      childFrame = childFrame->GetNextSibling();
    }

    nsSize prefSize = mLayoutManager->GetXULPrefSize(this, aBoxLayoutState);
    NS_FOR_FRAME_OVERFLOW_TYPES(otype) {
      nsRect& o = overflow.Overflow(otype);
      o.height = std::max(o.height, prefSize.height);
    }
  }
  FinishAndStoreOverflow(overflow, GetSize());

  if (mScrolling)
    aBoxLayoutState.SetPaintingDisabled(false);

  // if we are scrolled and the row height changed
  // make sure we are scrolled to a correct index.
  if (mAdjustScroll)
     PostReflowCallback();

  return rv;
}

nsSize
nsListBoxBodyFrame::GetXULMinSizeForScrollArea(nsBoxLayoutState& aBoxLayoutState)
{
  nsSize result(0, 0);
  if (nsContentUtils::HasNonEmptyAttr(GetContent(), kNameSpaceID_None,
                                      nsGkAtoms::sizemode)) {
    result = GetXULPrefSize(aBoxLayoutState);
    result.height = 0;
    nsIScrollableFrame* scrollFrame = nsLayoutUtils::GetScrollableFrameFor(this);
    if (scrollFrame &&
        scrollFrame->GetScrollbarStyles().mVertical == NS_STYLE_OVERFLOW_AUTO) {
      nsMargin scrollbars =
        scrollFrame->GetDesiredScrollbarSizes(&aBoxLayoutState);
      result.width += scrollbars.left + scrollbars.right;
    }
  }
  return result;
}

nsSize
nsListBoxBodyFrame::GetXULPrefSize(nsBoxLayoutState& aBoxLayoutState)
{  
  nsSize pref = nsBoxFrame::GetXULPrefSize(aBoxLayoutState);

  int32_t size = GetFixedRowSize();
  if (size > -1)
    pref.height = size*GetRowHeightAppUnits();

  nsIScrollableFrame* scrollFrame = nsLayoutUtils::GetScrollableFrameFor(this);
  if (scrollFrame &&
      scrollFrame->GetScrollbarStyles().mVertical == NS_STYLE_OVERFLOW_AUTO) {
    nsMargin scrollbars = scrollFrame->GetDesiredScrollbarSizes(&aBoxLayoutState);
    pref.width += scrollbars.left + scrollbars.right;
  }
  return pref;
}

///////////// nsIScrollbarMediator ///////////////

void
nsListBoxBodyFrame::ScrollByPage(nsScrollbarFrame* aScrollbar, int32_t aDirection,
                                 nsIScrollbarMediator::ScrollSnapMode aSnap)
{
  // CSS Scroll Snapping is not enabled for XUL, aSnap is ignored
  MOZ_ASSERT(aScrollbar != nullptr);
  aScrollbar->SetIncrementToPage(aDirection);
  AutoWeakFrame weakFrame(this);
  int32_t newPos = aScrollbar->MoveToNewPosition();
  if (!weakFrame.IsAlive()) {
    return;
  }
  UpdateIndex(newPos);
}

void
nsListBoxBodyFrame::ScrollByWhole(nsScrollbarFrame* aScrollbar, int32_t aDirection,
                                  nsIScrollbarMediator::ScrollSnapMode aSnap)
{
  // CSS Scroll Snapping is not enabled for XUL, aSnap is ignored
  MOZ_ASSERT(aScrollbar != nullptr);
  aScrollbar->SetIncrementToWhole(aDirection);
  AutoWeakFrame weakFrame(this);
  int32_t newPos = aScrollbar->MoveToNewPosition();
  if (!weakFrame.IsAlive()) {
    return;
  }
  UpdateIndex(newPos);
}

void
nsListBoxBodyFrame::ScrollByLine(nsScrollbarFrame* aScrollbar, int32_t aDirection,
                                 nsIScrollbarMediator::ScrollSnapMode aSnap)
{
  // CSS Scroll Snapping is not enabled for XUL, aSnap is ignored
  MOZ_ASSERT(aScrollbar != nullptr);
  aScrollbar->SetIncrementToLine(aDirection);
  AutoWeakFrame weakFrame(this);
  int32_t newPos = aScrollbar->MoveToNewPosition();
  if (!weakFrame.IsAlive()) {
    return;
  }
  UpdateIndex(newPos);
}

void
nsListBoxBodyFrame::RepeatButtonScroll(nsScrollbarFrame* aScrollbar)
{
  AutoWeakFrame weakFrame(this);
  int32_t newPos = aScrollbar->MoveToNewPosition();
  if (!weakFrame.IsAlive()) {
    return;
  }
  UpdateIndex(newPos);
}

int32_t
nsListBoxBodyFrame::ToRowIndex(nscoord aPos) const
{
  return NS_roundf(float(std::max(aPos, 0)) / mRowHeight);
}

void
nsListBoxBodyFrame::ThumbMoved(nsScrollbarFrame* aScrollbar,
                               nscoord aOldPos,
                               nscoord aNewPos)
{ 
  if (mScrolling || mRowHeight == 0)
    return;

  int32_t newIndex = ToRowIndex(aNewPos);
  if (newIndex == mCurrentIndex) {
    return;
  }
  int32_t rowDelta = newIndex - mCurrentIndex;

  nsListScrollSmoother* smoother = GetSmoother();

  // if we can't scroll the rows in time then start a timer. We will eat
  // events until the user stops moving and the timer stops.
  if (smoother->IsRunning() || Abs(rowDelta)*mTimePerRow > USER_TIME_THRESHOLD) {

     smoother->Stop();

     smoother->mDelta = rowDelta;

     smoother->Start();

     return;
  }

  smoother->Stop();

  mCurrentIndex = newIndex;
  smoother->mDelta = 0;
  
  if (mCurrentIndex < 0) {
    mCurrentIndex = 0;
    return;
  }
  InternalPositionChanged(rowDelta < 0, Abs(rowDelta));
}

void
nsListBoxBodyFrame::VisibilityChanged(bool aVisible)
{
  if (mRowHeight == 0)
    return;

  int32_t lastPageTopRow = GetRowCount() - (GetAvailableHeight() / mRowHeight);
  if (lastPageTopRow < 0)
    lastPageTopRow = 0;
  int32_t delta = mCurrentIndex - lastPageTopRow;
  if (delta > 0) {
    mCurrentIndex = lastPageTopRow;
    InternalPositionChanged(true, delta);
  }
}

nsIFrame*
nsListBoxBodyFrame::GetScrollbarBox(bool aVertical)
{
  nsIScrollableFrame* scrollFrame = nsLayoutUtils::GetScrollableFrameFor(this);
  return scrollFrame ? scrollFrame->GetScrollbarBox(true) : nullptr;
}

void
nsListBoxBodyFrame::UpdateIndex(int32_t aNewPos)
{
  int32_t newIndex = ToRowIndex(nsPresContext::CSSPixelsToAppUnits(aNewPos));
  if (newIndex == mCurrentIndex) {
    return;
  }
  bool up = newIndex < mCurrentIndex;
  int32_t indexDelta = Abs(newIndex - mCurrentIndex);
  mCurrentIndex = newIndex;
  InternalPositionChanged(up, indexDelta);
}
 
///////////// nsIReflowCallback ///////////////

bool
nsListBoxBodyFrame::ReflowFinished()
{
  nsAutoScriptBlocker scriptBlocker;
  // now create or destroy any rows as needed
  CreateRows();

  // keep scrollbar in sync
  if (mAdjustScroll) {
     VerticalScroll(mYPosition);
     mAdjustScroll = false;
  }

  // if the row height changed then mark everything as a style change. 
  // That will dirty the entire listbox
  if (mRowHeightWasSet) {
    PresContext()->PresShell()->
      FrameNeedsReflow(this, nsIPresShell::eStyleChange, NS_FRAME_IS_DIRTY);
     int32_t pos = mCurrentIndex * mRowHeight;
     if (mYPosition != pos) 
       mAdjustScroll = true;
    mRowHeightWasSet = false;
  }

  mReflowCallbackPosted = false;
  return true;
}

void
nsListBoxBodyFrame::ReflowCallbackCanceled()
{
  mReflowCallbackPosted = false;
}

///////// ListBoxObject ///////////////

int32_t
nsListBoxBodyFrame::GetNumberOfVisibleRows()
{
  return mRowHeight ? GetAvailableHeight() / mRowHeight : 0;
}

int32_t
nsListBoxBodyFrame::GetIndexOfFirstVisibleRow()
{
  return mCurrentIndex;
}

nsresult
nsListBoxBodyFrame::EnsureIndexIsVisible(int32_t aRowIndex)
{
  if (aRowIndex < 0)
    return NS_ERROR_ILLEGAL_VALUE;

  int32_t rows = 0;
  if (mRowHeight)
    rows = GetAvailableHeight()/mRowHeight;
  if (rows <= 0)
    rows = 1;
  int32_t bottomIndex = mCurrentIndex + rows;
  
  // if row is visible, ignore
  if (mCurrentIndex <= aRowIndex && aRowIndex < bottomIndex)
    return NS_OK;

  int32_t delta;

  bool up = aRowIndex < mCurrentIndex;
  if (up) {
    delta = mCurrentIndex - aRowIndex;
    mCurrentIndex = aRowIndex;
  }
  else {
    // Check to be sure we're not scrolling off the bottom of the tree
    if (aRowIndex >= GetRowCount())
      return NS_ERROR_ILLEGAL_VALUE;

    // Bring it just into view.
    delta = 1 + (aRowIndex-bottomIndex);
    mCurrentIndex += delta; 
  }

  // Safe to not go off an event here, since this is coming from the
  // box object.
  DoInternalPositionChangedSync(up, delta);
  return NS_OK;
}

nsresult
nsListBoxBodyFrame::ScrollByLines(int32_t aNumLines)
{
  int32_t scrollIndex = GetIndexOfFirstVisibleRow(),
    visibleRows = GetNumberOfVisibleRows();

  scrollIndex += aNumLines;
  
  if (scrollIndex < 0)
    scrollIndex = 0;
  else {
    int32_t numRows = GetRowCount();
    int32_t lastPageTopRow = numRows - visibleRows;
    if (scrollIndex > lastPageTopRow)
      scrollIndex = lastPageTopRow;
  }
  
  ScrollToIndex(scrollIndex);

  return NS_OK;
}

// walks the DOM to get the zero-based row index of the content
nsresult
nsListBoxBodyFrame::GetIndexOfItem(nsIDOMElement* aItem, int32_t* _retval)
{
  if (aItem) {
    *_retval = 0;
    nsCOMPtr<nsIContent> itemContent(do_QueryInterface(aItem));

    FlattenedChildIterator iter(mContent);
    for (nsIContent* child = iter.GetNextChild(); child; child = iter.GetNextChild()) {
      // we hit a list row, count it
      if (child->IsXULElement(nsGkAtoms::listitem)) {
        // is this it?
        if (child == itemContent)
          return NS_OK;

        ++(*_retval);
      }
    }
  }

  // not found
  *_retval = -1;
  return NS_OK;
}

nsresult
nsListBoxBodyFrame::GetItemAtIndex(int32_t aIndex, nsIDOMElement** aItem)
{
  *aItem = nullptr;
  if (aIndex < 0)
    return NS_OK;

  int32_t itemCount = 0;
  FlattenedChildIterator iter(mContent);
  for (nsIContent* child = iter.GetNextChild(); child; child = iter.GetNextChild()) {
    // we hit a list row, check if it is the one we are looking for
    if (child->IsXULElement(nsGkAtoms::listitem)) {
      // is this it?
      if (itemCount == aIndex) {
        return CallQueryInterface(child, aItem);
      }
      ++itemCount;
    }
  }

  // not found
  return NS_OK;
}

/////////// nsListBoxBodyFrame ///////////////

int32_t
nsListBoxBodyFrame::GetRowCount()
{
  if (mRowCount < 0)
    ComputeTotalRowCount();
  return mRowCount;
}

int32_t
nsListBoxBodyFrame::GetRowHeightPixels() const
{
  return nsPresContext::AppUnitsToIntCSSPixels(mRowHeight);
}

int32_t
nsListBoxBodyFrame::GetFixedRowSize()
{
  nsresult dummy;

  nsAutoString rows;
  mContent->GetAttr(kNameSpaceID_None, nsGkAtoms::rows, rows);
  if (!rows.IsEmpty())
    return rows.ToInteger(&dummy);
 
  mContent->GetAttr(kNameSpaceID_None, nsGkAtoms::size, rows);

  if (!rows.IsEmpty())
    return rows.ToInteger(&dummy);

  return -1;
}

void
nsListBoxBodyFrame::SetRowHeight(nscoord aRowHeight)
{ 
  if (aRowHeight > mRowHeight) { 
    mRowHeight = aRowHeight;

    // signal we need to dirty everything 
    // and we want to be notified after reflow
    // so we can create or destory rows as needed
    mRowHeightWasSet = true;
    PostReflowCallback();
  }
}

nscoord
nsListBoxBodyFrame::GetAvailableHeight()
{
  nsIScrollableFrame* scrollFrame =
    nsLayoutUtils::GetScrollableFrameFor(this);
  if (scrollFrame) {
    return scrollFrame->GetScrollPortRect().height;
  }
  return 0;
}

nscoord
nsListBoxBodyFrame::GetYPosition()
{
  return mYPosition;
}

nscoord
nsListBoxBodyFrame::ComputeIntrinsicISize(nsBoxLayoutState& aBoxLayoutState)
{
  if (mStringWidth != -1)
    return mStringWidth;

  nscoord largestWidth = 0;

  int32_t index = 0;
  nsCOMPtr<nsIDOMElement> firstRowEl;
  GetItemAtIndex(index, getter_AddRefs(firstRowEl));
  nsCOMPtr<nsIContent> firstRowContent(do_QueryInterface(firstRowEl));

  if (firstRowContent) {
    RefPtr<nsStyleContext> styleContext;
    nsPresContext *presContext = aBoxLayoutState.PresContext();
    styleContext = presContext->StyleSet()->
      ResolveStyleFor(firstRowContent->AsElement(), nullptr,
                      LazyComputeBehavior::Allow);

    nscoord width = 0;
    nsMargin margin(0,0,0,0);

    if (styleContext->StylePadding()->GetPadding(margin))
      width += margin.LeftRight();
    width += styleContext->StyleBorder()->GetComputedBorder().LeftRight();
    if (styleContext->StyleMargin()->GetMargin(margin))
      width += margin.LeftRight();

    FlattenedChildIterator iter(mContent);
    for (nsIContent* child = iter.GetNextChild(); child; child = iter.GetNextChild()) {
      if (child->IsXULElement(nsGkAtoms::listitem)) {
        nsRenderingContext* rendContext = aBoxLayoutState.GetRenderingContext();
        if (rendContext) {
          nsAutoString value;
          uint32_t textCount = child->GetChildCount();
          for (uint32_t j = 0; j < textCount; ++j) {
            nsIContent* text = child->GetChildAt(j);
            if (text && text->IsNodeOfType(nsINode::eTEXT)) {
              text->AppendTextTo(value);
            }
          }

          RefPtr<nsFontMetrics> fm =
            nsLayoutUtils::GetFontMetricsForStyleContext(styleContext);

          nscoord textWidth =
            nsLayoutUtils::AppUnitWidthOfStringBidi(value, this, *fm,
                                                    *rendContext);
          textWidth += width;

          if (textWidth > largestWidth) 
            largestWidth = textWidth;
        }
      }
    }
  }

  mStringWidth = largestWidth;
  return mStringWidth;
}

void
nsListBoxBodyFrame::ComputeTotalRowCount()
{
  mRowCount = 0;
  FlattenedChildIterator iter(mContent);
  for (nsIContent* child = iter.GetNextChild(); child; child = iter.GetNextChild()) {
    if (child->IsXULElement(nsGkAtoms::listitem)) {
      ++mRowCount;
    }
  }
}

void
nsListBoxBodyFrame::PostReflowCallback()
{
  if (!mReflowCallbackPosted) {
    mReflowCallbackPosted = true;
    PresContext()->PresShell()->PostReflowCallback(this);
  }
}

////////// scrolling

nsresult
nsListBoxBodyFrame::ScrollToIndex(int32_t aRowIndex)
{
  if (( aRowIndex < 0 ) || (mRowHeight == 0))
    return NS_OK;
    
  int32_t newIndex = aRowIndex;
  int32_t delta = mCurrentIndex > newIndex ? mCurrentIndex - newIndex : newIndex - mCurrentIndex;
  bool up = newIndex < mCurrentIndex;

  // Check to be sure we're not scrolling off the bottom of the tree
  int32_t lastPageTopRow = GetRowCount() - (GetAvailableHeight() / mRowHeight);
  if (lastPageTopRow < 0)
    lastPageTopRow = 0;

  if (aRowIndex > lastPageTopRow)
    return NS_OK;

  mCurrentIndex = newIndex;

  AutoWeakFrame weak(this);

  // Since we're going to flush anyway, we need to not do this off an event
  DoInternalPositionChangedSync(up, delta);

  if (!weak.IsAlive()) {
    return NS_OK;
  }

  // This change has to happen immediately.
  // Flush any pending reflow commands.
  // XXXbz why, exactly?
  mContent->GetComposedDoc()->FlushPendingNotifications(FlushType::Layout);

  return NS_OK;
}

nsresult
nsListBoxBodyFrame::InternalPositionChangedCallback()
{
  nsListScrollSmoother* smoother = GetSmoother();

  if (smoother->mDelta == 0)
    return NS_OK;

  mCurrentIndex += smoother->mDelta;

  if (mCurrentIndex < 0)
    mCurrentIndex = 0;

  return DoInternalPositionChangedSync(smoother->mDelta < 0,
                                       smoother->mDelta < 0 ?
                                         -smoother->mDelta : smoother->mDelta);
}

nsresult
nsListBoxBodyFrame::InternalPositionChanged(bool aUp, int32_t aDelta)
{
  RefPtr<nsPositionChangedEvent> event =
    new nsPositionChangedEvent(this, aUp, aDelta);
  nsresult rv = mContent->OwnerDoc()->Dispatch("nsPositionChangedEvent",
                                               TaskCategory::Other,
                                               do_AddRef(event));
  if (NS_SUCCEEDED(rv)) {
    if (!mPendingPositionChangeEvents.AppendElement(event)) {
      rv = NS_ERROR_OUT_OF_MEMORY;
      event->Revoke();
    }
  }
  return rv;
}

nsresult
nsListBoxBodyFrame::DoInternalPositionChangedSync(bool aUp, int32_t aDelta)
{
  AutoWeakFrame weak(this);
  
  // Process all the pending position changes first
  nsTArray< RefPtr<nsPositionChangedEvent> > temp;
  temp.SwapElements(mPendingPositionChangeEvents);
  for (uint32_t i = 0; i < temp.Length(); ++i) {
    if (weak.IsAlive()) {
      temp[i]->Run();
    }
    temp[i]->Revoke();
  }

  if (!weak.IsAlive()) {
    return NS_OK;
  }

  return DoInternalPositionChanged(aUp, aDelta);
}

nsresult
nsListBoxBodyFrame::DoInternalPositionChanged(bool aUp, int32_t aDelta)
{
  if (aDelta == 0)
    return NS_OK;

  RefPtr<nsPresContext> presContext(PresContext());
  nsBoxLayoutState state(presContext);

  // begin timing how long it takes to scroll a row
  PRTime start = PR_Now();

  AutoWeakFrame weakThis(this);
  mContent->GetComposedDoc()->FlushPendingNotifications(FlushType::Layout);
  if (!weakThis.IsAlive()) {
    return NS_OK;
  }

  {
    nsAutoScriptBlocker scriptBlocker;

    int32_t visibleRows = 0;
    if (mRowHeight)
      visibleRows = GetAvailableHeight()/mRowHeight;
  
    if (aDelta < visibleRows) {
      int32_t loseRows = aDelta;
      if (aUp) {
        // scrolling up, destroy rows from the bottom downwards
        ReverseDestroyRows(loseRows);
        mRowsToPrepend += aDelta;
        mLinkupFrame = nullptr;
      }
      else {
        // scrolling down, destroy rows from the top upwards
        DestroyRows(loseRows);
        mRowsToPrepend = 0;
      }
    }
    else {
      // We have scrolled so much that all of our current frames will
      // go off screen, so blow them all away. Weeee!
      nsIFrame *currBox = mFrames.FirstChild();
      nsCSSFrameConstructor* fc = presContext->PresShell()->FrameConstructor();
      fc->BeginUpdate();
      while (currBox) {
        nsIFrame *nextBox = currBox->GetNextSibling();
        RemoveChildFrame(state, currBox);
        currBox = nextBox;
      }
      fc->EndUpdate();
    }

    // clear frame markers so that CreateRows will re-create
    mTopFrame = mBottomFrame = nullptr; 
  
    mYPosition = mCurrentIndex*mRowHeight;
    mScrolling = true;
    presContext->PresShell()->
      FrameNeedsReflow(this, nsIPresShell::eResize, NS_FRAME_HAS_DIRTY_CHILDREN);
  }
  if (!weakThis.IsAlive()) {
    return NS_OK;
  }
  // Flush calls CreateRows
  // XXXbz there has to be a better way to do this than flushing!
  presContext->PresShell()->FlushPendingNotifications(FlushType::Layout);
  if (!weakThis.IsAlive()) {
    return NS_OK;
  }

  mScrolling = false;
  
  VerticalScroll(mYPosition);

  PRTime end = PR_Now();

  int32_t newTime = int32_t(end - start) / aDelta;

  // average old and new
  mTimePerRow = (newTime + mTimePerRow)/2;
  
  return NS_OK;
}

nsListScrollSmoother* 
nsListBoxBodyFrame::GetSmoother()
{
  if (!mScrollSmoother) {
    mScrollSmoother = new nsListScrollSmoother(this);
    NS_ASSERTION(mScrollSmoother, "out of memory");
    NS_IF_ADDREF(mScrollSmoother);
  }

  return mScrollSmoother;
}

void
nsListBoxBodyFrame::VerticalScroll(int32_t aPosition)
{
  nsIScrollableFrame* scrollFrame
    = nsLayoutUtils::GetScrollableFrameFor(this);
  if (!scrollFrame) {
    return;
  }

  nsPoint scrollPosition = scrollFrame->GetScrollPosition();
 
  AutoWeakFrame weakFrame(this);
  scrollFrame->ScrollTo(nsPoint(scrollPosition.x, aPosition),
                        nsIScrollableFrame::INSTANT);
  if (!weakFrame.IsAlive()) {
    return;
  }

  mYPosition = aPosition;
}

////////// frame and box retrieval

nsIFrame*
nsListBoxBodyFrame::GetFirstFrame()
{
  mTopFrame = mFrames.FirstChild();
  return mTopFrame;
}

nsIFrame*
nsListBoxBodyFrame::GetLastFrame()
{
  return mFrames.LastChild();
}

bool
nsListBoxBodyFrame::SupportsOrdinalsInChildren()
{
  return false;
}

////////// lazy row creation and destruction

void
nsListBoxBodyFrame::CreateRows()
{
  // Get our client rect.
  nsRect clientRect;
  GetXULClientRect(clientRect);

  // Get the starting y position and the remaining available
  // height.
  nscoord availableHeight = GetAvailableHeight();
  
  if (availableHeight <= 0) {
    bool fixed = (GetFixedRowSize() != -1);
    if (fixed)
      availableHeight = 10;
    else
      return;
  }
  
  // get the first tree box. If there isn't one create one.
  bool created = false;
  nsIFrame* box = GetFirstItemBox(0, &created);
  nscoord rowHeight = GetRowHeightAppUnits();
  while (box) {  
    if (created && mRowsToPrepend > 0)
      --mRowsToPrepend;

    // if the row height is 0 then fail. Wait until someone 
    // laid out and sets the row height.
    if (rowHeight == 0)
        return;
     
    availableHeight -= rowHeight;
    
    // should we continue? Is the enought height?
    if (!ContinueReflow(availableHeight))
      break;

    // get the next tree box. Create one if needed.
    box = GetNextItemBox(box, 0, &created);
  }

  mRowsToPrepend = 0;
  mLinkupFrame = nullptr;
}

void
nsListBoxBodyFrame::DestroyRows(int32_t& aRowsToLose) 
{
  // We need to destroy frames until our row count has been properly
  // reduced.  A reflow will then pick up and create the new frames.
  nsIFrame* childFrame = GetFirstFrame();
  nsBoxLayoutState state(PresContext());

  nsCSSFrameConstructor* fc = PresContext()->PresShell()->FrameConstructor();
  fc->BeginUpdate();
  while (childFrame && aRowsToLose > 0) {
    --aRowsToLose;

    nsIFrame* nextFrame = childFrame->GetNextSibling();
    RemoveChildFrame(state, childFrame);

    mTopFrame = childFrame = nextFrame;
  }
  fc->EndUpdate();

  PresContext()->PresShell()->
    FrameNeedsReflow(this, nsIPresShell::eTreeChange,
                     NS_FRAME_HAS_DIRTY_CHILDREN);
}

void
nsListBoxBodyFrame::ReverseDestroyRows(int32_t& aRowsToLose) 
{
  // We need to destroy frames until our row count has been properly
  // reduced.  A reflow will then pick up and create the new frames.
  nsIFrame* childFrame = GetLastFrame();
  nsBoxLayoutState state(PresContext());

  nsCSSFrameConstructor* fc = PresContext()->PresShell()->FrameConstructor();
  fc->BeginUpdate();
  while (childFrame && aRowsToLose > 0) {
    --aRowsToLose;
    
    nsIFrame* prevFrame;
    prevFrame = childFrame->GetPrevSibling();
    RemoveChildFrame(state, childFrame);

    mBottomFrame = childFrame = prevFrame;
  }
  fc->EndUpdate();

  PresContext()->PresShell()->
    FrameNeedsReflow(this, nsIPresShell::eTreeChange,
                     NS_FRAME_HAS_DIRTY_CHILDREN);
}

static bool
IsListItemChild(nsListBoxBodyFrame* aParent, nsIContent* aChild,
                nsIFrame** aChildFrame)
{
  *aChildFrame = nullptr;
  if (!aChild->IsXULElement(nsGkAtoms::listitem)) {
    return false;
  }
  nsIFrame* existingFrame = aChild->GetPrimaryFrame();
  if (existingFrame && existingFrame->GetParent() != aParent) {
    return false;
  }
  *aChildFrame = existingFrame;
  return true;
}

//
// Get the nsIFrame for the first visible listitem, and if none exists,
// create one.
//
nsIFrame*
nsListBoxBodyFrame::GetFirstItemBox(int32_t aOffset, bool* aCreated)
{
  if (aCreated)
   *aCreated = false;

  // Clear ourselves out.
  mBottomFrame = mTopFrame;

  if (mTopFrame) {
    return mTopFrame->IsXULBoxFrame() ? mTopFrame.GetFrame() : nullptr;
  }

  // top frame was cleared out
  mTopFrame = GetFirstFrame();
  mBottomFrame = mTopFrame;

  if (mTopFrame && mRowsToPrepend <= 0) {
    return mTopFrame->IsXULBoxFrame() ? mTopFrame.GetFrame() : nullptr;
  }

  // At this point, we either have no frames at all, 
  // or the user has scrolled upwards, leaving frames
  // to be created at the top.  Let's determine which
  // content needs a new frame first.

  nsCOMPtr<nsIContent> startContent;
  if (mTopFrame && mRowsToPrepend > 0) {
    // We need to insert rows before the top frame
    nsIContent* topContent = mTopFrame->GetContent();
    nsIContent* topParent = topContent->GetParent();
    int32_t contentIndex = topParent->IndexOf(topContent);
    contentIndex -= aOffset;
    if (contentIndex < 0)
      return nullptr;
    startContent = topParent->GetChildAt(contentIndex - mRowsToPrepend);
  } else {
    // This will be the first item frame we create.  Use the content
    // at the current index, which is the first index scrolled into view
    GetListItemContentAt(mCurrentIndex+aOffset, getter_AddRefs(startContent));
  }

  if (startContent) {  
    nsIFrame* existingFrame;
    if (!IsListItemChild(this, startContent, &existingFrame)) {
      return GetFirstItemBox(++aOffset, aCreated);
    }
    if (existingFrame) {
      return existingFrame->IsXULBoxFrame() ? existingFrame : nullptr;
    }

    // Either append the new frame, or prepend it (at index 0)
    // XXX check here if frame was even created, it may not have been if
    //     display: none was on listitem content
    bool isAppend = mRowsToPrepend <= 0;
    
    nsPresContext* presContext = PresContext();
    nsCSSFrameConstructor* fc = presContext->PresShell()->FrameConstructor();
    nsIFrame* topFrame = nullptr;
    fc->CreateListBoxContent(this, nullptr, startContent, &topFrame, isAppend);
    mTopFrame = topFrame;
    if (mTopFrame) {
      if (aCreated)
        *aCreated = true;

      mBottomFrame = mTopFrame;

      return mTopFrame->IsXULBoxFrame() ? mTopFrame.GetFrame() : nullptr;
    } else
      return GetFirstItemBox(++aOffset, 0);
  }

  return nullptr;
}

//
// Get the nsIFrame for the next visible listitem after aBox, and if none
// exists, create one.
//
nsIFrame*
nsListBoxBodyFrame::GetNextItemBox(nsIFrame* aBox, int32_t aOffset,
                                   bool* aCreated)
{
  if (aCreated)
    *aCreated = false;

  nsIFrame* result = aBox->GetNextSibling();

  if (!result || result == mLinkupFrame || mRowsToPrepend > 0) {
    // No result found. See if there's a content node that wants a frame.
    nsIContent* prevContent = aBox->GetContent();
    nsIContent* parentContent = prevContent->GetParent();

    int32_t i = parentContent->IndexOf(prevContent);

    uint32_t childCount = parentContent->GetChildCount();
    if (((uint32_t)i + aOffset + 1) < childCount) {
      // There is a content node that wants a frame.
      nsIContent *nextContent = parentContent->GetChildAt(i + aOffset + 1);

      nsIFrame* existingFrame;
      if (!IsListItemChild(this, nextContent, &existingFrame)) {
        return GetNextItemBox(aBox, ++aOffset, aCreated);
      }
      if (!existingFrame) {
        // Either append the new frame, or insert it after the current frame
        bool isAppend = result != mLinkupFrame && mRowsToPrepend <= 0;
        nsIFrame* prevFrame = isAppend ? nullptr : aBox;
      
        nsPresContext* presContext = PresContext();
        nsCSSFrameConstructor* fc = presContext->PresShell()->FrameConstructor();
        fc->CreateListBoxContent(this, prevFrame, nextContent,
                                 &result, isAppend);

        if (result) {
          if (aCreated)
            *aCreated = true;
        } else
          return GetNextItemBox(aBox, ++aOffset, aCreated);
      } else {
        result = existingFrame;
      }
            
      mLinkupFrame = nullptr;
    }
  }

  if (!result)
    return nullptr;

  mBottomFrame = result;

  NS_ASSERTION(!result->IsXULBoxFrame() || result->GetParent() == this,
               "returning frame that is not in childlist");

  return result->IsXULBoxFrame() ? result : nullptr;
}

bool
nsListBoxBodyFrame::ContinueReflow(nscoord height) 
{
#ifdef ACCESSIBILITY
  if (nsIPresShell::IsAccessibilityActive()) {
    // Create all the frames at once so screen readers and
    // onscreen keyboards can see the full list right away
    return true;
  }
#endif

  if (height <= 0) {
    nsIFrame* lastChild = GetLastFrame();
    nsIFrame* startingPoint = mBottomFrame;
    if (startingPoint == nullptr) {
      // We just want to delete everything but the first item.
      startingPoint = GetFirstFrame();
    }

    if (lastChild != startingPoint) {
      // We have some hangers on (probably caused by shrinking the size of the window).
      // Nuke them.
      nsIFrame* currFrame = startingPoint->GetNextSibling();
      nsBoxLayoutState state(PresContext());

      nsCSSFrameConstructor* fc =
        PresContext()->PresShell()->FrameConstructor();
      fc->BeginUpdate();
      while (currFrame) {
        nsIFrame* nextFrame = currFrame->GetNextSibling();
        RemoveChildFrame(state, currFrame);
        currFrame = nextFrame;
      }
      fc->EndUpdate();

      PresContext()->PresShell()->
        FrameNeedsReflow(this, nsIPresShell::eTreeChange,
                         NS_FRAME_HAS_DIRTY_CHILDREN);
    }
    return false;
  }
  else
    return true;
}

NS_IMETHODIMP
nsListBoxBodyFrame::ListBoxAppendFrames(nsFrameList& aFrameList)
{
  // append them after
  nsBoxLayoutState state(PresContext());
  const nsFrameList::Slice& newFrames = mFrames.AppendFrames(nullptr, aFrameList);
  if (mLayoutManager)
    mLayoutManager->ChildrenAppended(this, state, newFrames);
  PresContext()->PresShell()->
    FrameNeedsReflow(this, nsIPresShell::eTreeChange,
                     NS_FRAME_HAS_DIRTY_CHILDREN);
  
  return NS_OK;
}

NS_IMETHODIMP
nsListBoxBodyFrame::ListBoxInsertFrames(nsIFrame* aPrevFrame,
                                        nsFrameList& aFrameList)
{
  // insert the frames to our info list
  nsBoxLayoutState state(PresContext());
  const nsFrameList::Slice& newFrames =
    mFrames.InsertFrames(nullptr, aPrevFrame, aFrameList);
  if (mLayoutManager)
    mLayoutManager->ChildrenInserted(this, state, aPrevFrame, newFrames);
  PresContext()->PresShell()->
    FrameNeedsReflow(this, nsIPresShell::eTreeChange,
                     NS_FRAME_HAS_DIRTY_CHILDREN);

  return NS_OK;
}

// 
// Called by nsCSSFrameConstructor when a new listitem content is inserted.
//
void
nsListBoxBodyFrame::OnContentInserted(nsIContent* aChildContent)
{
  if (mRowCount >= 0)
    ++mRowCount;

  // The RDF content builder will build content nodes such that they are all 
  // ready when OnContentInserted is first called, meaning the first call
  // to CreateRows will create all the frames, but OnContentInserted will
  // still be called again for each content node - so we need to make sure
  // that the frame for each content node hasn't already been created.
  nsIFrame* childFrame = aChildContent->GetPrimaryFrame();
  if (childFrame)
    return;

  int32_t siblingIndex;
  nsCOMPtr<nsIContent> nextSiblingContent;
  GetListItemNextSibling(aChildContent, getter_AddRefs(nextSiblingContent), siblingIndex);
  
  // if we're inserting our item before the first visible content,
  // then we need to shift all rows down by one
  if (siblingIndex >= 0 &&  siblingIndex-1 <= mCurrentIndex) {
    mTopFrame = nullptr;
    mRowsToPrepend = 1;
  } else if (nextSiblingContent) {
    // we may be inserting before a frame that is on screen
    nsIFrame* nextSiblingFrame = nextSiblingContent->GetPrimaryFrame();
    mLinkupFrame = nextSiblingFrame;
  }
  
  CreateRows();
  PresContext()->PresShell()->
    FrameNeedsReflow(this, nsIPresShell::eTreeChange,
                     NS_FRAME_HAS_DIRTY_CHILDREN);
}

// 
// Called by nsCSSFrameConstructor when listitem content is removed.
//
void
nsListBoxBodyFrame::OnContentRemoved(nsPresContext* aPresContext,
                                     nsIContent* aContainer,
                                     nsIFrame* aChildFrame,
                                     nsIContent* aOldNextSibling)
{
  NS_ASSERTION(!aChildFrame || aChildFrame->GetParent() == this,
               "Removing frame that's not our child... Not good");
  
  if (mRowCount >= 0)
    --mRowCount;

  if (aContainer) {
    if (!aChildFrame) {
      // The row we are removing is out of view, so we need to try to
      // determine the index of its next sibling.
      int32_t siblingIndex = -1;
      if (aOldNextSibling) {
        nsCOMPtr<nsIContent> nextSiblingContent;
        GetListItemNextSibling(aOldNextSibling,
                               getter_AddRefs(nextSiblingContent),
                               siblingIndex);
      }
    
      // if the row being removed is off-screen and above the top frame, we need to
      // adjust our top index and tell the scrollbar to shift up one row.
      if (siblingIndex >= 0 && siblingIndex-1 < mCurrentIndex) {
        NS_PRECONDITION(mCurrentIndex > 0, "mCurrentIndex > 0");
        --mCurrentIndex;
        mYPosition = mCurrentIndex*mRowHeight;
        AutoWeakFrame weakChildFrame(aChildFrame);
        VerticalScroll(mYPosition);
        if (!weakChildFrame.IsAlive()) {
          return;
        }
      }
    } else if (mCurrentIndex > 0) {
      // At this point, we know we have a scrollbar, and we need to know 
      // if we are scrolled to the last row.  In this case, the behavior
      // of the scrollbar is to stay locked to the bottom.  Since we are
      // removing visible content, the first visible row will have to move
      // down by one, and we will have to insert a new frame at the top.

      // if the last content node has a frame, we are scrolled to the bottom
      nsIContent* lastChild = nullptr;
      FlattenedChildIterator iter(mContent);
      for (nsIContent* child = iter.GetNextChild(); child; child = iter.GetNextChild()) {
        lastChild = child;
      }

      if (lastChild) {
        nsIFrame* lastChildFrame = lastChild->GetPrimaryFrame();

        if (lastChildFrame) {
          mTopFrame = nullptr;
          mRowsToPrepend = 1;
          --mCurrentIndex;
          mYPosition = mCurrentIndex*mRowHeight;
          AutoWeakFrame weakChildFrame(aChildFrame);
          VerticalScroll(mYPosition);
          if (!weakChildFrame.IsAlive()) {
            return;
          }
        }
      }
    }
  }

  // if we're removing the top row, the new top row is the next row
  if (mTopFrame && mTopFrame == aChildFrame)
    mTopFrame = mTopFrame->GetNextSibling();

  // Go ahead and delete the frame.
  nsBoxLayoutState state(aPresContext);
  if (aChildFrame) {
    RemoveChildFrame(state, aChildFrame);
  }

  PresContext()->PresShell()->
    FrameNeedsReflow(this, nsIPresShell::eTreeChange,
                     NS_FRAME_HAS_DIRTY_CHILDREN);
}

void
nsListBoxBodyFrame::GetListItemContentAt(int32_t aIndex, nsIContent** aContent)
{
  *aContent = nullptr;

  int32_t itemsFound = 0;
  FlattenedChildIterator iter(mContent);
  for (nsIContent* child = iter.GetNextChild(); child; child = iter.GetNextChild()) {
    if (child->IsXULElement(nsGkAtoms::listitem)) {
      ++itemsFound;
      if (itemsFound-1 == aIndex) {
        *aContent = child;
        NS_IF_ADDREF(*aContent);
        return;
      }
    }
  }
}

void
nsListBoxBodyFrame::GetListItemNextSibling(nsIContent* aListItem, nsIContent** aContent, int32_t& aSiblingIndex)
{
  *aContent = nullptr;
  aSiblingIndex = -1;
  nsIContent *prevKid = nullptr;
  FlattenedChildIterator iter(mContent);
  for (nsIContent* child = iter.GetNextChild(); child; child = iter.GetNextChild()) {
    if (child->IsXULElement(nsGkAtoms::listitem)) {
      ++aSiblingIndex;
      if (prevKid == aListItem) {
        *aContent = child;
        NS_IF_ADDREF(*aContent);
        return;
      }
    }
    prevKid = child;
  }

  aSiblingIndex = -1; // no match, so there is no next sibling
}

void
nsListBoxBodyFrame::RemoveChildFrame(nsBoxLayoutState &aState,
                                     nsIFrame         *aFrame)
{
  MOZ_ASSERT(mFrames.ContainsFrame(aFrame));
  MOZ_ASSERT(aFrame != GetContentInsertionFrame());

#ifdef ACCESSIBILITY
  nsAccessibilityService* accService = nsIPresShell::AccService();
  if (accService) {
    nsIContent* content = aFrame->GetContent();
    accService->ContentRemoved(PresContext()->PresShell(), content);
  }
#endif

  mFrames.RemoveFrame(aFrame);
  if (mLayoutManager)
    mLayoutManager->ChildrenRemoved(this, aState, aFrame);
  aFrame->Destroy();
}

// Creation Routines ///////////////////////////////////////////////////////////////////////

already_AddRefed<nsBoxLayout> NS_NewListBoxLayout();

nsIFrame*
NS_NewListBoxBodyFrame(nsIPresShell* aPresShell, nsStyleContext* aContext)
{
  nsCOMPtr<nsBoxLayout> layout = NS_NewListBoxLayout();
  return new (aPresShell) nsListBoxBodyFrame(aContext, layout);
}

NS_IMPL_FRAMEARENA_HELPERS(nsListBoxBodyFrame)
