/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
// vim:cindent:ts=2:et:sw=2:
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* base class of all rendering objects */

#include "nsFrame.h"

#include <stdarg.h>
#include <algorithm>

#include "gfx2DGlue.h"
#include "gfxUtils.h"
#include "mozilla/Attributes.h"
#include "mozilla/DebugOnly.h"
#include "mozilla/gfx/2D.h"
#include "mozilla/gfx/PathHelpers.h"
#include "mozilla/Sprintf.h"

#include "nsCOMPtr.h"
#include "nsFrameList.h"
#include "nsPlaceholderFrame.h"
#include "nsIContent.h"
#include "nsIContentInlines.h"
#include "nsContentUtils.h"
#include "nsCSSPseudoElements.h"
#include "nsIAtom.h"
#include "nsString.h"
#include "nsReadableUtils.h"
#include "nsStyleContext.h"
#include "nsTableWrapperFrame.h"
#include "nsView.h"
#include "nsViewManager.h"
#include "nsIScrollableFrame.h"
#include "nsPresContext.h"
#include "nsStyleConsts.h"
#include "nsIPresShell.h"
#include "mozilla/Logging.h"
#include "mozilla/Sprintf.h"
#include "nsFrameManager.h"
#include "nsLayoutUtils.h"
#include "LayoutLogging.h"
#include "mozilla/RestyleManager.h"
#include "mozilla/RestyleManagerHandle.h"
#include "mozilla/RestyleManagerHandleInlines.h"

#include "nsIDOMNode.h"
#include "nsISelection.h"
#include "nsISelectionPrivate.h"
#include "nsFrameSelection.h"
#include "nsGkAtoms.h"
#include "nsHtml5Atoms.h"
#include "nsCSSAnonBoxes.h"

#include "nsFrameTraversal.h"
#include "nsRange.h"
#include "nsITextControlFrame.h"
#include "nsNameSpaceManager.h"
#include "nsIPercentBSizeObserver.h"
#include "nsStyleStructInlines.h"
#include "FrameLayerBuilder.h"
#include "ImageLayers.h"

#include "nsBidiPresUtils.h"
#include "RubyUtils.h"
#include "nsAnimationManager.h"

// For triple-click pref
#include "imgIContainer.h"
#include "imgIRequest.h"
#include "nsError.h"
#include "nsContainerFrame.h"
#include "nsBoxLayoutState.h"
#include "nsBlockFrame.h"
#include "nsDisplayList.h"
#include "nsSVGIntegrationUtils.h"
#include "nsSVGEffects.h"
#include "nsChangeHint.h"
#include "nsDeckFrame.h"
#include "nsSubDocumentFrame.h"
#include "SVGTextFrame.h"

#include "gfxContext.h"
#include "nsRenderingContext.h"
#include "nsAbsoluteContainingBlock.h"
#include "DisplayItemScrollClip.h"
#include "StickyScrollContainer.h"
#include "nsFontInflationData.h"
#include "nsRegion.h"
#include "nsIFrameInlines.h"

#include "mozilla/AsyncEventDispatcher.h"
#include "mozilla/EffectCompositor.h"
#include "mozilla/EffectSet.h"
#include "mozilla/EventListenerManager.h"
#include "mozilla/EventStateManager.h"
#include "mozilla/EventStates.h"
#include "mozilla/Preferences.h"
#include "mozilla/LookAndFeel.h"
#include "mozilla/MouseEvents.h"
#include "mozilla/css/ImageLoader.h"
#include "mozilla/gfx/Tools.h"
#include "nsPrintfCString.h"
#include "ActiveLayerTracker.h"

#include "nsITheme.h"
#include "nsThemeConstants.h"

using namespace mozilla;
using namespace mozilla::css;
using namespace mozilla::dom;
using namespace mozilla::gfx;
using namespace mozilla::layers;
using namespace mozilla::layout;
typedef nsAbsoluteContainingBlock::AbsPosReflowFlags AbsPosReflowFlags;

// Struct containing cached metrics for box-wrapped frames.
struct nsBoxLayoutMetrics
{
  nsSize mPrefSize;
  nsSize mMinSize;
  nsSize mMaxSize;

  nsSize mBlockMinSize;
  nsSize mBlockPrefSize;
  nscoord mBlockAscent;

  nscoord mFlex;
  nscoord mAscent;

  nsSize mLastSize;
};

struct nsContentAndOffset
{
  nsIContent* mContent;
  int32_t mOffset;
};

// Some Misc #defines
#define SELECTION_DEBUG        0
#define FORCE_SELECTION_UPDATE 1
#define CALC_DEBUG             0

// This is faster than nsBidiPresUtils::IsFrameInParagraphDirection,
// because it uses the frame pointer passed in without drilling down to
// the leaf frame.
static bool
IsReversedDirectionFrame(nsIFrame* aFrame)
{
  FrameBidiData bidiData = aFrame->GetBidiData();
  return !IS_SAME_DIRECTION(bidiData.embeddingLevel, bidiData.baseLevel);
}

#include "nsILineIterator.h"

//non Hack prototypes
#if 0
static void RefreshContentFrames(nsPresContext* aPresContext, nsIContent * aStartContent, nsIContent * aEndContent);
#endif

#include "prenv.h"

NS_DECLARE_FRAME_PROPERTY_DELETABLE(BoxMetricsProperty, nsBoxLayoutMetrics)

static void
InitBoxMetrics(nsIFrame* aFrame, bool aClear)
{
  FrameProperties props = aFrame->Properties();
  if (aClear) {
    props.Delete(BoxMetricsProperty());
  }

  nsBoxLayoutMetrics* metrics = new nsBoxLayoutMetrics();
  props.Set(BoxMetricsProperty(), metrics);

  static_cast<nsFrame*>(aFrame)->nsFrame::MarkIntrinsicISizesDirty();
  metrics->mBlockAscent = 0;
  metrics->mLastSize.SizeTo(0, 0);
}

static bool
IsXULBoxWrapped(const nsIFrame* aFrame)
{
  return aFrame->GetParent() &&
         aFrame->GetParent()->IsXULBoxFrame() &&
         !aFrame->IsXULBoxFrame();
}

// Formerly the nsIFrameDebug interface

#ifdef DEBUG
static bool gShowFrameBorders = false;

void nsFrame::ShowFrameBorders(bool aEnable)
{
  gShowFrameBorders = aEnable;
}

bool nsFrame::GetShowFrameBorders()
{
  return gShowFrameBorders;
}

static bool gShowEventTargetFrameBorder = false;

void nsFrame::ShowEventTargetFrameBorder(bool aEnable)
{
  gShowEventTargetFrameBorder = aEnable;
}

bool nsFrame::GetShowEventTargetFrameBorder()
{
  return gShowEventTargetFrameBorder;
}

/**
 * Note: the log module is created during library initialization which
 * means that you cannot perform logging before then.
 */
mozilla::LazyLogModule nsFrame::sFrameLogModule("frame");

static mozilla::LazyLogModule sStyleVerifyTreeLogModuleInfo("styleverifytree");

static uint32_t gStyleVerifyTreeEnable = 0x55;

bool
nsFrame::GetVerifyStyleTreeEnable()
{
  if (gStyleVerifyTreeEnable == 0x55) {
      gStyleVerifyTreeEnable = 0 != (int)((mozilla::LogModule*)sStyleVerifyTreeLogModuleInfo)->Level();
  }
  return gStyleVerifyTreeEnable;
}

void
nsFrame::SetVerifyStyleTreeEnable(bool aEnabled)
{
  gStyleVerifyTreeEnable = aEnabled;
}

#endif

NS_DECLARE_FRAME_PROPERTY_DELETABLE(AbsoluteContainingBlockProperty,
                                    nsAbsoluteContainingBlock)

bool
nsIFrame::HasAbsolutelyPositionedChildren() const {
  return IsAbsoluteContainer() && GetAbsoluteContainingBlock()->HasAbsoluteFrames();
}

nsAbsoluteContainingBlock*
nsIFrame::GetAbsoluteContainingBlock() const {
  NS_ASSERTION(IsAbsoluteContainer(), "The frame is not marked as an abspos container correctly");
  nsAbsoluteContainingBlock* absCB = Properties().Get(AbsoluteContainingBlockProperty());
  NS_ASSERTION(absCB, "The frame is marked as an abspos container but doesn't have the property");
  return absCB;
}

void
nsIFrame::MarkAsAbsoluteContainingBlock()
{
  MOZ_ASSERT(GetStateBits() & NS_FRAME_CAN_HAVE_ABSPOS_CHILDREN);
  NS_ASSERTION(!Properties().Get(AbsoluteContainingBlockProperty()),
               "Already has an abs-pos containing block property?");
  NS_ASSERTION(!HasAnyStateBits(NS_FRAME_HAS_ABSPOS_CHILDREN),
               "Already has NS_FRAME_HAS_ABSPOS_CHILDREN state bit?");
  AddStateBits(NS_FRAME_HAS_ABSPOS_CHILDREN);
  Properties().Set(AbsoluteContainingBlockProperty(), new nsAbsoluteContainingBlock(GetAbsoluteListID()));
}

void
nsIFrame::MarkAsNotAbsoluteContainingBlock()
{
  NS_ASSERTION(!HasAbsolutelyPositionedChildren(), "Think of the children!");
  NS_ASSERTION(Properties().Get(AbsoluteContainingBlockProperty()),
               "Should have an abs-pos containing block property");
  NS_ASSERTION(HasAnyStateBits(NS_FRAME_HAS_ABSPOS_CHILDREN),
               "Should have NS_FRAME_HAS_ABSPOS_CHILDREN state bit");
  MOZ_ASSERT(HasAnyStateBits(NS_FRAME_CAN_HAVE_ABSPOS_CHILDREN));
  RemoveStateBits(NS_FRAME_HAS_ABSPOS_CHILDREN);
  Properties().Delete(AbsoluteContainingBlockProperty());
}

bool
nsIFrame::CheckAndClearPaintedState()
{
  bool result = (GetStateBits() & NS_FRAME_PAINTED_THEBES);
  RemoveStateBits(NS_FRAME_PAINTED_THEBES);
  
  nsIFrame::ChildListIterator lists(this);
  for (; !lists.IsDone(); lists.Next()) {
    nsFrameList::Enumerator childFrames(lists.CurrentList());
    for (; !childFrames.AtEnd(); childFrames.Next()) {
      nsIFrame* child = childFrames.get();
      if (child->CheckAndClearPaintedState()) {
        result = true;
      }
    }
  }
  return result;
}

bool
nsIFrame::IsVisibleConsideringAncestors(uint32_t aFlags) const
{
  if (!StyleVisibility()->IsVisible()) {
    return false;
  }

  const nsIFrame* frame = this;
  while (frame) {
    nsView* view = frame->GetView();
    if (view && view->GetVisibility() == nsViewVisibility_kHide)
      return false;
    
    nsIFrame* parent = frame->GetParent();
    nsDeckFrame* deck = do_QueryFrame(parent);
    if (deck) {
      if (deck->GetSelectedBox() != frame)
        return false;
    }

    if (parent) {
      frame = parent;
    } else {
      parent = nsLayoutUtils::GetCrossDocParentFrame(frame);
      if (!parent)
        break;

      if ((aFlags & nsIFrame::VISIBILITY_CROSS_CHROME_CONTENT_BOUNDARY) == 0 &&
          parent->PresContext()->IsChrome() && !frame->PresContext()->IsChrome()) {
        break;
      }

      if (!parent->StyleVisibility()->IsVisible())
        return false;

      frame = parent;
    }
  }

  return true;
}

void
nsIFrame::FindCloserFrameForSelection(
                                 nsPoint aPoint,
                                 nsIFrame::FrameWithDistance* aCurrentBestFrame)
{
  if (nsLayoutUtils::PointIsCloserToRect(aPoint, mRect,
                                         aCurrentBestFrame->mXDistance,
                                         aCurrentBestFrame->mYDistance)) {
    aCurrentBestFrame->mFrame = this;
  }
}

void
nsIFrame::ContentStatesChanged(mozilla::EventStates aStates)
{
}

void
NS_MergeReflowStatusInto(nsReflowStatus* aPrimary, nsReflowStatus aSecondary)
{
  *aPrimary |= aSecondary &
    (NS_FRAME_NOT_COMPLETE | NS_FRAME_OVERFLOW_INCOMPLETE |
     NS_FRAME_TRUNCATED | NS_FRAME_REFLOW_NEXTINFLOW);
  if (*aPrimary & NS_FRAME_NOT_COMPLETE) {
    *aPrimary &= ~NS_FRAME_OVERFLOW_INCOMPLETE;
  }
}

void
nsWeakFrame::Init(nsIFrame* aFrame)
{
  Clear(mFrame ? mFrame->PresContext()->GetPresShell() : nullptr);
  mFrame = aFrame;
  if (mFrame) {
    nsIPresShell* shell = mFrame->PresContext()->GetPresShell();
    NS_WARNING_ASSERTION(shell, "Null PresShell in nsWeakFrame!");
    if (shell) {
      shell->AddWeakFrame(this);
    } else {
      mFrame = nullptr;
    }
  }
}

nsIFrame*
NS_NewEmptyFrame(nsIPresShell* aPresShell, nsStyleContext* aContext)
{
  return new (aPresShell) nsFrame(aContext);
}

nsFrame::nsFrame(nsStyleContext* aContext)
{
  MOZ_COUNT_CTOR(nsFrame);

  mState = NS_FRAME_FIRST_REFLOW | NS_FRAME_IS_DIRTY;
  mStyleContext = aContext;
  mStyleContext->AddRef();
#ifdef DEBUG
  mStyleContext->FrameAddRef();
#endif
}

nsFrame::~nsFrame()
{
  MOZ_COUNT_DTOR(nsFrame);

  MOZ_ASSERT(GetVisibility() != Visibility::APPROXIMATELY_VISIBLE,
             "Visible nsFrame is being destroyed");

  NS_IF_RELEASE(mContent);
#ifdef DEBUG
  mStyleContext->FrameRelease();
#endif
  mStyleContext->Release();
}

NS_IMPL_FRAMEARENA_HELPERS(nsFrame)

// Dummy operator delete.  Will never be called, but must be defined
// to satisfy some C++ ABIs.
void
nsFrame::operator delete(void *, size_t)
{
  NS_RUNTIMEABORT("nsFrame::operator delete should never be called");
}

NS_QUERYFRAME_HEAD(nsFrame)
  NS_QUERYFRAME_ENTRY(nsIFrame)
NS_QUERYFRAME_TAIL_INHERITANCE_ROOT

/////////////////////////////////////////////////////////////////////////////
// nsIFrame

static bool
IsFontSizeInflationContainer(nsIFrame* aFrame,
                             const nsStyleDisplay* aStyleDisplay)
{
  /*
   * Font size inflation is built around the idea that we're inflating
   * the fonts for a pan-and-zoom UI so that when the user scales up a
   * block or other container to fill the width of the device, the fonts
   * will be readable.  To do this, we need to pick what counts as a
   * container.
   *
   * From a code perspective, the only hard requirement is that frames
   * that are line participants
   * (nsIFrame::IsFrameOfType(nsIFrame::eLineParticipant)) are never
   * containers, since line layout assumes that the inflation is
   * consistent within a line.
   *
   * This is not an imposition, since we obviously want a bunch of text
   * (possibly with inline elements) flowing within a block to count the
   * block (or higher) as its container.
   *
   * We also want form controls, including the text in the anonymous
   * content inside of them, to match each other and the text next to
   * them, so they and their anonymous content should also not be a
   * container.
   *
   * However, because we can't reliably compute sizes across XUL during
   * reflow, any XUL frame with a XUL parent is always a container.
   *
   * There are contexts where it would be nice if some blocks didn't
   * count as a container, so that, for example, an indented quotation
   * didn't end up with a smaller font size.  However, it's hard to
   * distinguish these situations where we really do want the indented
   * thing to count as a container, so we don't try, and blocks are
   * always containers.
   */

  // The root frame should always be an inflation container.
  if (!aFrame->GetParent()) {
    return true;
  }

  nsIContent *content = aFrame->GetContent();
  nsIAtom* frameType = aFrame->GetType();
  bool isInline = (aFrame->GetDisplay() == StyleDisplay::Inline ||
                   RubyUtils::IsRubyBox(frameType) ||
                   (aFrame->IsFloating() &&
                    frameType == nsGkAtoms::letterFrame) ||
                   // Given multiple frames for the same node, only the
                   // outer one should be considered a container.
                   // (Important, e.g., for nsSelectsAreaFrame.)
                   (aFrame->GetParent()->GetContent() == content) ||
                   (content && (content->IsAnyOfHTMLElements(nsGkAtoms::option,
                                                             nsGkAtoms::optgroup,
                                                             nsGkAtoms::select) ||
                                content->IsInNativeAnonymousSubtree()))) &&
                  !(aFrame->IsXULBoxFrame() && aFrame->GetParent()->IsXULBoxFrame());
  NS_ASSERTION(!aFrame->IsFrameOfType(nsIFrame::eLineParticipant) ||
               isInline ||
               // br frames and mathml frames report being line
               // participants even when their position or display is
               // set
               aFrame->GetType() == nsGkAtoms::brFrame ||
               aFrame->IsFrameOfType(nsIFrame::eMathML),
               "line participants must not be containers");
  NS_ASSERTION(aFrame->GetType() != nsGkAtoms::bulletFrame || isInline,
               "bullets should not be containers");
  return !isInline;
}

void
nsFrame::Init(nsIContent*       aContent,
              nsContainerFrame* aParent,
              nsIFrame*         aPrevInFlow)
{
  NS_PRECONDITION(!mContent, "Double-initing a frame?");
  NS_ASSERTION(IsFrameOfType(eDEBUGAllFrames) &&
               !IsFrameOfType(eDEBUGNoFrames),
               "IsFrameOfType implementation that doesn't call base class");

  mContent = aContent;
  mParent = aParent;

  if (aContent) {
    NS_ADDREF(aContent);
  }

  if (aPrevInFlow) {
    // Make sure the general flags bits are the same
    nsFrameState state = aPrevInFlow->GetStateBits();

    // Make bits that are currently off (see constructor) the same:
    mState |= state & (NS_FRAME_INDEPENDENT_SELECTION |
                       NS_FRAME_PART_OF_IBSPLIT |
                       NS_FRAME_MAY_BE_TRANSFORMED |
                       NS_FRAME_MAY_HAVE_GENERATED_CONTENT |
                       NS_FRAME_CAN_HAVE_ABSPOS_CHILDREN);
  } else {
    PresContext()->ConstructedFrame();
  }
  if (GetParent()) {
    nsFrameState state = GetParent()->GetStateBits();

    // Make bits that are currently off (see constructor) the same:
    mState |= state & (NS_FRAME_INDEPENDENT_SELECTION |
                       NS_FRAME_GENERATED_CONTENT |
                       NS_FRAME_IS_SVG_TEXT |
                       NS_FRAME_IN_POPUP |
                       NS_FRAME_IS_NONDISPLAY);

    if (HasAnyStateBits(NS_FRAME_IN_POPUP) && TrackingVisibility()) {
      // Assume all frames in popups are visible.
      IncApproximateVisibleCount();
    }
  }
  const nsStyleDisplay *disp = StyleDisplay();
  if (disp->HasTransform(this) ||
      (IsFrameOfType(eSupportsCSSTransforms) &&
       nsLayoutUtils::HasAnimationOfProperty(this, eCSSProperty_transform))) {
    // The frame gets reconstructed if we toggle the -moz-transform
    // property, so we can set this bit here and then ignore it.
    mState |= NS_FRAME_MAY_BE_TRANSFORMED;
  }
  if (disp->mPosition == NS_STYLE_POSITION_STICKY &&
      !aPrevInFlow &&
      !(mState & NS_FRAME_IS_NONDISPLAY) &&
      !disp->IsInnerTableStyle()) {
    // Note that we only add first continuations, but we really only
    // want to add first continuation-or-ib-split-siblings.  But since we
    // don't yet know if we're a later part of a block-in-inline split,
    // we'll just add later members of a block-in-inline split here, and
    // then StickyScrollContainer will remove them later.
    // We don't currently support relative positioning of inner table
    // elements (bug 35168), so exclude them from sticky positioning too.
    StickyScrollContainer* ssc =
      StickyScrollContainer::GetStickyScrollContainerForFrame(this);
    if (ssc) {
      ssc->AddFrame(this);
    }
  }

  if (nsLayoutUtils::FontSizeInflationEnabled(PresContext()) || !GetParent()
#ifdef DEBUG
      // We have assertions that check inflation invariants even when
      // font size inflation is not enabled.
      || true
#endif
      ) {
    if (IsFontSizeInflationContainer(this, disp)) {
      AddStateBits(NS_FRAME_FONT_INFLATION_CONTAINER);
      if (!GetParent() ||
          // I'd use NS_FRAME_OUT_OF_FLOW, but it's not set yet.
          disp->IsFloating(this) || disp->IsAbsolutelyPositioned(this)) {
        AddStateBits(NS_FRAME_FONT_INFLATION_FLOW_ROOT);
      }
    }
    NS_ASSERTION(GetParent() ||
                 (GetStateBits() & NS_FRAME_FONT_INFLATION_CONTAINER),
                 "root frame should always be a container");
  }

  if (PresContext()->PresShell()->AssumeAllFramesVisible() &&
      TrackingVisibility()) {
    IncApproximateVisibleCount();
  }

  DidSetStyleContext(nullptr);

  if (::IsXULBoxWrapped(this))
    ::InitBoxMetrics(this, false);
}

void
nsFrame::DestroyFrom(nsIFrame* aDestructRoot)
{
  NS_ASSERTION(!nsContentUtils::IsSafeToRunScript(),
    "destroy called on frame while scripts not blocked");
  NS_ASSERTION(!GetNextSibling() && !GetPrevSibling(),
               "Frames should be removed before destruction.");
  NS_ASSERTION(aDestructRoot, "Must specify destruct root");
  MOZ_ASSERT(!HasAbsolutelyPositionedChildren());

  nsSVGEffects::InvalidateDirectRenderingObservers(this);

  if (StyleDisplay()->mPosition == NS_STYLE_POSITION_STICKY) {
    StickyScrollContainer* ssc =
      StickyScrollContainer::GetStickyScrollContainerForFrame(this);
    if (ssc) {
      ssc->RemoveFrame(this);
    }
  }

  // Get the view pointer now before the frame properties disappear
  // when we call NotifyDestroyingFrame()
  nsView* view = GetView();
  nsPresContext* presContext = PresContext();

  nsIPresShell *shell = presContext->GetPresShell();
  if (mState & NS_FRAME_OUT_OF_FLOW) {
    nsPlaceholderFrame* placeholder =
      shell->FrameManager()->GetPlaceholderFrameFor(this);
    NS_ASSERTION(!placeholder || (aDestructRoot != this),
                 "Don't call Destroy() on OOFs, call Destroy() on the placeholder.");
    NS_ASSERTION(!placeholder ||
                 nsLayoutUtils::IsProperAncestorFrame(aDestructRoot, placeholder),
                 "Placeholder relationship should have been torn down already; "
                 "this might mean we have a stray placeholder in the tree.");
    if (placeholder) {
      shell->FrameManager()->UnregisterPlaceholderFrame(placeholder);
      placeholder->SetOutOfFlowFrame(nullptr);
    }
  }

  // If we have any IB split siblings, clear their references to us.
  // (Note: This has to happen before we call shell->NotifyDestroyingFrame,
  // because that clears our Properties() table.)
  if (mState & NS_FRAME_PART_OF_IBSPLIT) {
    // Delete previous sibling's reference to me.
    nsIFrame* prevSib = Properties().Get(nsIFrame::IBSplitPrevSibling());
    if (prevSib) {
      NS_WARNING_ASSERTION(
        this == prevSib->Properties().Get(nsIFrame::IBSplitSibling()),
        "IB sibling chain is inconsistent");
      prevSib->Properties().Delete(nsIFrame::IBSplitSibling());
    }

    // Delete next sibling's reference to me.
    nsIFrame* nextSib = Properties().Get(nsIFrame::IBSplitSibling());
    if (nextSib) {
      NS_WARNING_ASSERTION(
        this == nextSib->Properties().Get(nsIFrame::IBSplitPrevSibling()),
        "IB sibling chain is inconsistent");
      nextSib->Properties().Delete(nsIFrame::IBSplitPrevSibling());
    }
  }

  bool isPrimaryFrame = (mContent && mContent->GetPrimaryFrame() == this);
  if (isPrimaryFrame) {
    // This needs to happen before shell->NotifyDestroyingFrame because
    // that clears our Properties() table.
    ActiveLayerTracker::TransferActivityToContent(this, mContent);

    // Unfortunately, we need to do this for all frames being reframed
    // and not only those whose current style involves CSS transitions,
    // because what matters is whether the new style (not the old)
    // specifies CSS transitions.
    if (presContext->RestyleManager()->IsGecko()) {
      // stylo: ServoRestyleManager does not handle transitions yet, and when
      // it does it probably won't need to track reframed style contexts to
      // initiate transitions correctly.
      RestyleManager::ReframingStyleContexts* rsc =
        presContext->RestyleManager()->AsGecko()->GetReframingStyleContexts();
      if (rsc) {
        rsc->Put(mContent, mStyleContext);
      }
    }
  }

  if (HasCSSAnimations() || HasCSSTransitions() ||
      EffectSet::GetEffectSet(this)) {
    // If no new frame for this element is created by the end of the
    // restyling process, stop animations and transitions for this frame
    if (presContext->RestyleManager()->IsGecko()) {
      RestyleManager::AnimationsWithDestroyedFrame* adf =
        presContext->RestyleManager()->AsGecko()->GetAnimationsWithDestroyedFrame();
      // AnimationsWithDestroyedFrame only lives during the restyling process.
      if (adf) {
        adf->Put(mContent, mStyleContext);
      }
    } else {
      NS_ERROR("stylo: ServoRestyleManager does not support animations yet");
    }
  }

  // Disable visibility tracking. Note that we have to do this before calling
  // NotifyDestroyingFrame(), which will clear frame properties and make us lose
  // track of whether we were previously visible or not.
  // XXX(seth): It'd be ideal to assert that we're already marked nonvisible
  // here, but it's unfortunately tricky to guarantee in the face of things like
  // frame reconstruction induced by style changes.
  DisableVisibilityTracking();

  // Ensure that we're not in the approximately visible list anymore.
  PresContext()->GetPresShell()->RemoveFrameFromApproximatelyVisibleList(this);

  shell->NotifyDestroyingFrame(this);

  if (mState & NS_FRAME_EXTERNAL_REFERENCE) {
    shell->ClearFrameRefs(this);
  }

  if (view) {
    // Break association between view and frame
    view->SetFrame(nullptr);

    // Destroy the view
    view->Destroy();
  }

  // Make sure that our deleted frame can't be returned from GetPrimaryFrame()
  if (isPrimaryFrame) {
    mContent->SetPrimaryFrame(nullptr);
  }

  // Must retrieve the object ID before calling destructors, so the
  // vtable is still valid.
  //
  // Note to future tweakers: having the method that returns the
  // object size call the destructor will not avoid an indirect call;
  // the compiler cannot devirtualize the call to the destructor even
  // if it's from a method defined in the same class.

  nsQueryFrame::FrameIID id = GetFrameId();
  this->~nsFrame();

  // Now that we're totally cleaned out, we need to add ourselves to
  // the presshell's recycler.
  shell->FreeFrame(id, this);
}

nsresult
nsFrame::GetOffsets(int32_t &aStart, int32_t &aEnd) const
{
  aStart = 0;
  aEnd = 0;
  return NS_OK;
}

static
void
AddAndRemoveImageAssociations(nsFrame* aFrame,
                              const nsStyleImageLayers* aOldLayers,
                              const nsStyleImageLayers* aNewLayers)
{
   ImageLoader* imageLoader =
     aFrame->PresContext()->Document()->StyleImageLoader();

  // If the old context had a background-image image, or mask-image image,
  // and new context does not have the same image, clear the image load
  // notifier (which keeps the image loading, if it still is) for the frame.
  // We want to do this conservatively because some frames paint their
  // backgrounds from some other frame's style data, and we don't want
  // to clear those notifiers unless we have to.  (They'll be reset
  // when we paint, although we could miss a notification in that
  // interval.)

  if (aOldLayers) {
    NS_FOR_VISIBLE_IMAGE_LAYERS_BACK_TO_FRONT(i, (*aOldLayers)) {
      // If there is an image in oldBG that's not in newBG, drop it.
      if (i >= aNewLayers->mImageCount ||
          !aOldLayers->mLayers[i].mImage.ImageDataEquals(
            aNewLayers->mLayers[i].mImage)) {
        const nsStyleImage& oldImage = aOldLayers->mLayers[i].mImage;
        if (oldImage.GetType() != eStyleImageType_Image) {
          continue;
        }

        if (imgRequestProxy* req = oldImage.GetImageData()) {
          imageLoader->DisassociateRequestFromFrame(req, aFrame);
        }
      }
    }
  }

  NS_FOR_VISIBLE_IMAGE_LAYERS_BACK_TO_FRONT(i, (*aNewLayers)) {
    // If there is an image in newBG that's not in oldBG, add it.
    if (!aOldLayers || i >= aOldLayers->mImageCount ||
        !aNewLayers->mLayers[i].mImage.ImageDataEquals(
          aOldLayers->mLayers[i].mImage)) {
      const nsStyleImage& newImage = aNewLayers->mLayers[i].mImage;
      if (newImage.GetType() != eStyleImageType_Image) {
        continue;
      }

      if (imgRequestProxy* req = newImage.GetImageData()) {
        imageLoader->AssociateRequestToFrame(req, aFrame);
      }
    }
  }
}

// Subclass hook for style post processing
/* virtual */ void
nsFrame::DidSetStyleContext(nsStyleContext* aOldStyleContext)
{
  if (IsSVGText()) {
    SVGTextFrame* svgTextFrame = static_cast<SVGTextFrame*>(
        nsLayoutUtils::GetClosestFrameOfType(this, nsGkAtoms::svgTextFrame));
    nsIFrame* anonBlock = svgTextFrame->PrincipalChildList().FirstChild();
    // Just as in SVGTextFrame::DidSetStyleContext, we need to ensure that
    // any non-display SVGTextFrames get reflowed when a child text frame
    // gets new style.
    //
    // Note that we must check NS_FRAME_FIRST_REFLOW on our SVGTextFrame's
    // anonymous block frame rather than our self, since NS_FRAME_FIRST_REFLOW
    // may be set on us if we're a new frame that has been inserted after the
    // document's first reflow. (In which case this DidSetStyleContext call may
    // be happening under frame construction under a Reflow() call.)
    if (anonBlock && !(anonBlock->GetStateBits() & NS_FRAME_FIRST_REFLOW) &&
        (svgTextFrame->GetStateBits() & NS_FRAME_IS_NONDISPLAY) &&
        !(svgTextFrame->GetStateBits() & NS_STATE_SVG_TEXT_IN_REFLOW)) {
      svgTextFrame->ScheduleReflowSVGNonDisplayText(nsIPresShell::eStyleChange);
    }
  }

  const nsStyleImageLayers *oldLayers = aOldStyleContext ?
                              &aOldStyleContext->StyleBackground()->mImage :
                              nullptr;
  const nsStyleImageLayers *newLayers = &StyleBackground()->mImage;
  AddAndRemoveImageAssociations(this, oldLayers, newLayers);

  oldLayers = aOldStyleContext ? &aOldStyleContext->StyleSVGReset()->mMask :
                                  nullptr;
  newLayers = &StyleSVGReset()->mMask;
  AddAndRemoveImageAssociations(this, oldLayers, newLayers);

  if (aOldStyleContext) {
    // If we detect a change on margin, padding or border, we store the old
    // values on the frame itself between now and reflow, so if someone
    // calls GetUsed(Margin|Border|Padding)() before the next reflow, we
    // can give an accurate answer.
    // We don't want to set the property if one already exists.
    FrameProperties props = Properties();
    nsMargin oldValue(0, 0, 0, 0);
    nsMargin newValue(0, 0, 0, 0);
    const nsStyleMargin* oldMargin = aOldStyleContext->PeekStyleMargin();
    if (oldMargin && oldMargin->GetMargin(oldValue)) {
      if ((!StyleMargin()->GetMargin(newValue) || oldValue != newValue) &&
          !props.Get(UsedMarginProperty())) {
        props.Set(UsedMarginProperty(), new nsMargin(oldValue));
      }
    }

    const nsStylePadding* oldPadding = aOldStyleContext->PeekStylePadding();
    if (oldPadding && oldPadding->GetPadding(oldValue)) {
      if ((!StylePadding()->GetPadding(newValue) || oldValue != newValue) &&
          !props.Get(UsedPaddingProperty())) {
        props.Set(UsedPaddingProperty(), new nsMargin(oldValue));
      }
    }

    const nsStyleBorder* oldBorder = aOldStyleContext->PeekStyleBorder();
    if (oldBorder) {
      oldValue = oldBorder->GetComputedBorder();
      newValue = StyleBorder()->GetComputedBorder();
      if (oldValue != newValue &&
          !props.Get(UsedBorderProperty())) {
        props.Set(UsedBorderProperty(), new nsMargin(oldValue));
      }
    }
  }

  ImageLoader* imageLoader = PresContext()->Document()->StyleImageLoader();
  imgIRequest *oldBorderImage = aOldStyleContext
    ? aOldStyleContext->StyleBorder()->GetBorderImageRequest()
    : nullptr;
  imgIRequest *newBorderImage = StyleBorder()->GetBorderImageRequest();
  // FIXME (Bug 759996): The following is no longer true.
  // For border-images, we can't be as conservative (we need to set the
  // new loaders if there has been any change) since the CalcDifference
  // call depended on the result of GetComputedBorder() and that result
  // depends on whether the image has loaded, start the image load now
  // so that we'll get notified when it completes loading and can do a
  // restyle.  Otherwise, the image might finish loading from the
  // network before we start listening to its notifications, and then
  // we'll never know that it's finished loading.  Likewise, we want to
  // do this for freshly-created frames to prevent a similar race if the
  // image loads between reflow (which can depend on whether the image
  // is loaded) and paint.  We also don't really care about any callers
  // who try to paint borders with a different style context, because
  // they won't have the correct size for the border either.
  if (oldBorderImage != newBorderImage) {
    // stop and restart the image loading/notification
    if (oldBorderImage) {
      imageLoader->DisassociateRequestFromFrame(oldBorderImage, this);
    }
    if (newBorderImage) {
      imageLoader->AssociateRequestToFrame(newBorderImage, this);
    }
  }

  // If the page contains markup that overrides text direction, and
  // does not contain any characters that would activate the Unicode
  // bidi algorithm, we need to call |SetBidiEnabled| on the pres
  // context before reflow starts.  See bug 115921.
  if (StyleVisibility()->mDirection == NS_STYLE_DIRECTION_RTL) {
    PresContext()->SetBidiEnabled();
  }

  RemoveStateBits(NS_FRAME_SIMPLE_EVENT_REGIONS);
}

// MSVC fails with link error "one or more multiply defined symbols found",
// gcc fails with "hidden symbol `nsIFrame::kPrincipalList' isn't defined"
// etc if they are not defined.
#ifndef _MSC_VER
// static nsIFrame constants; initialized in the header file.
const nsIFrame::ChildListID nsIFrame::kPrincipalList;
const nsIFrame::ChildListID nsIFrame::kAbsoluteList;
const nsIFrame::ChildListID nsIFrame::kBulletList;
const nsIFrame::ChildListID nsIFrame::kCaptionList;
const nsIFrame::ChildListID nsIFrame::kColGroupList;
const nsIFrame::ChildListID nsIFrame::kExcessOverflowContainersList;
const nsIFrame::ChildListID nsIFrame::kFixedList;
const nsIFrame::ChildListID nsIFrame::kFloatList;
const nsIFrame::ChildListID nsIFrame::kOverflowContainersList;
const nsIFrame::ChildListID nsIFrame::kOverflowList;
const nsIFrame::ChildListID nsIFrame::kOverflowOutOfFlowList;
const nsIFrame::ChildListID nsIFrame::kPopupList;
const nsIFrame::ChildListID nsIFrame::kPushedFloatsList;
const nsIFrame::ChildListID nsIFrame::kSelectPopupList;
const nsIFrame::ChildListID nsIFrame::kNoReflowPrincipalList;
#endif

/* virtual */ nsMargin
nsIFrame::GetUsedMargin() const
{
  nsMargin margin(0, 0, 0, 0);
  if (((mState & NS_FRAME_FIRST_REFLOW) &&
       !(mState & NS_FRAME_IN_REFLOW)) ||
      IsSVGText())
    return margin;

  nsMargin *m = Properties().Get(UsedMarginProperty());
  if (m) {
    margin = *m;
  } else {
    if (!StyleMargin()->GetMargin(margin)) {
      // If we get here, our caller probably shouldn't be calling us...
      NS_ERROR("Returning bogus 0-sized margin, because this margin "
               "depends on layout & isn't cached!");
    }
  }
  return margin;
}

/* virtual */ nsMargin
nsIFrame::GetUsedBorder() const
{
  nsMargin border(0, 0, 0, 0);
  if (((mState & NS_FRAME_FIRST_REFLOW) &&
       !(mState & NS_FRAME_IN_REFLOW)) ||
      IsSVGText())
    return border;

  // Theme methods don't use const-ness.
  nsIFrame *mutable_this = const_cast<nsIFrame*>(this);

  const nsStyleDisplay *disp = StyleDisplay();
  if (mutable_this->IsThemed(disp)) {
    nsIntMargin result;
    nsPresContext *presContext = PresContext();
    presContext->GetTheme()->GetWidgetBorder(presContext->DeviceContext(),
                                             mutable_this, disp->mAppearance,
                                             &result);
    border.left = presContext->DevPixelsToAppUnits(result.left);
    border.top = presContext->DevPixelsToAppUnits(result.top);
    border.right = presContext->DevPixelsToAppUnits(result.right);
    border.bottom = presContext->DevPixelsToAppUnits(result.bottom);
    return border;
  }

  nsMargin *b = Properties().Get(UsedBorderProperty());
  if (b) {
    border = *b;
  } else {
    border = StyleBorder()->GetComputedBorder();
  }
  return border;
}

/* virtual */ nsMargin
nsIFrame::GetUsedPadding() const
{
  nsMargin padding(0, 0, 0, 0);
  if (((mState & NS_FRAME_FIRST_REFLOW) &&
       !(mState & NS_FRAME_IN_REFLOW)) ||
      IsSVGText())
    return padding;

  // Theme methods don't use const-ness.
  nsIFrame *mutable_this = const_cast<nsIFrame*>(this);

  const nsStyleDisplay *disp = StyleDisplay();
  if (mutable_this->IsThemed(disp)) {
    nsPresContext *presContext = PresContext();
    nsIntMargin widget;
    if (presContext->GetTheme()->GetWidgetPadding(presContext->DeviceContext(),
                                                  mutable_this,
                                                  disp->mAppearance,
                                                  &widget)) {
      padding.top = presContext->DevPixelsToAppUnits(widget.top);
      padding.right = presContext->DevPixelsToAppUnits(widget.right);
      padding.bottom = presContext->DevPixelsToAppUnits(widget.bottom);
      padding.left = presContext->DevPixelsToAppUnits(widget.left);
      return padding;
    }
  }

  nsMargin *p = Properties().Get(UsedPaddingProperty());
  if (p) {
    padding = *p;
  } else {
    if (!StylePadding()->GetPadding(padding)) {
      // If we get here, our caller probably shouldn't be calling us...
      NS_ERROR("Returning bogus 0-sized padding, because this padding "
               "depends on layout & isn't cached!");
    }
  }
  return padding;
}

nsIFrame::Sides
nsIFrame::GetSkipSides(const ReflowInput* aReflowInput) const
{
  if (MOZ_UNLIKELY(StyleBorder()->mBoxDecorationBreak ==
                     StyleBoxDecorationBreak::Clone) &&
      !(GetStateBits() & NS_FRAME_IS_OVERFLOW_CONTAINER)) {
    return Sides();
  }

  // Convert the logical skip sides to physical sides using the frame's
  // writing mode
  WritingMode writingMode = GetWritingMode();
  LogicalSides logicalSkip = GetLogicalSkipSides(aReflowInput);
  Sides skip;

  if (logicalSkip.BStart()) {
    if (writingMode.IsVertical()) {
      skip |= writingMode.IsVerticalLR() ? eSideBitsLeft : eSideBitsRight;
    } else {
      skip |= eSideBitsTop;
    }
  }

  if (logicalSkip.BEnd()) {
    if (writingMode.IsVertical()) {
      skip |= writingMode.IsVerticalLR() ? eSideBitsRight : eSideBitsLeft;
    } else {
      skip |= eSideBitsBottom;
    }
  }

  if (logicalSkip.IStart()) {
    if (writingMode.IsVertical()) {
      skip |= eSideBitsTop;
    } else {
      skip |= writingMode.IsBidiLTR() ? eSideBitsLeft : eSideBitsRight;
    }
  }

  if (logicalSkip.IEnd()) {
    if (writingMode.IsVertical()) {
      skip |= eSideBitsBottom;
    } else {
      skip |= writingMode.IsBidiLTR() ? eSideBitsRight : eSideBitsLeft;
    }
  }
  return skip;
}

nsRect
nsIFrame::GetPaddingRectRelativeToSelf() const
{
  nsMargin border(GetUsedBorder());
  border.ApplySkipSides(GetSkipSides());
  nsRect r(0, 0, mRect.width, mRect.height);
  r.Deflate(border);
  return r;
}

nsRect
nsIFrame::GetPaddingRect() const
{
  return GetPaddingRectRelativeToSelf() + GetPosition();
}

WritingMode
nsIFrame::GetWritingMode(nsIFrame* aSubFrame) const
{
  WritingMode writingMode = GetWritingMode();

  if (StyleTextReset()->mUnicodeBidi & NS_STYLE_UNICODE_BIDI_PLAINTEXT) {
    nsBidiLevel frameLevel = nsBidiPresUtils::GetFrameBaseLevel(aSubFrame);
    writingMode.SetDirectionFromBidiLevel(frameLevel);
  }

  return writingMode;
}

nsRect
nsIFrame::GetMarginRectRelativeToSelf() const
{
  nsMargin m = GetUsedMargin();
  m.ApplySkipSides(GetSkipSides());
  nsRect r(0, 0, mRect.width, mRect.height);
  r.Inflate(m);
  return r;
}

bool
nsIFrame::IsTransformed() const
{
  return ((mState & NS_FRAME_MAY_BE_TRANSFORMED) &&
          (StyleDisplay()->HasTransform(this) ||
           IsSVGTransformed() ||
           (mContent &&
            nsLayoutUtils::HasAnimationOfProperty(this,
                                                  eCSSProperty_transform) &&
            IsFrameOfType(eSupportsCSSTransforms) &&
            mContent->GetPrimaryFrame() == this)));
}

bool
nsIFrame::HasOpacityInternal(float aThreshold) const
{
  MOZ_ASSERT(0.0 <= aThreshold && aThreshold <= 1.0, "Invalid argument");
  return StyleEffects()->mOpacity < aThreshold ||
         (StyleDisplay()->mWillChangeBitField & NS_STYLE_WILL_CHANGE_OPACITY) ||
         (mContent &&
           nsLayoutUtils::HasAnimationOfProperty(this, eCSSProperty_opacity) &&
           mContent->GetPrimaryFrame() == this);
}

bool
nsIFrame::IsSVGTransformed(gfx::Matrix *aOwnTransforms,
                           gfx::Matrix *aFromParentTransforms) const
{
  return false;
}

bool
nsIFrame::Extend3DContext() const
{
  const nsStyleDisplay* disp = StyleDisplay();
  if (disp->mTransformStyle != NS_STYLE_TRANSFORM_STYLE_PRESERVE_3D ||
      !IsFrameOfType(nsIFrame::eSupportsCSSTransforms)) {
    return false;
  }

  // If we're all scroll frame, then all descendants will be clipped, so we can't preserve 3d.
  if (GetType() == nsGkAtoms::scrollFrame) {
    return false;
  }

  if (HasOpacity()) {
    return false;
  }

  const nsStyleEffects* effects = StyleEffects();
  return !nsFrame::ShouldApplyOverflowClipping(this, disp) &&
         !GetClipPropClipRect(disp, effects, GetSize()) &&
         !nsSVGIntegrationUtils::UsingEffectsForFrame(this);
}

bool
nsIFrame::Combines3DTransformWithAncestors() const
{
  if (!GetParent() || !GetParent()->Extend3DContext()) {
    return false;
  }
  return IsTransformed() || BackfaceIsHidden();
}

bool
nsIFrame::In3DContextAndBackfaceIsHidden() const
{
  return Combines3DTransformWithAncestors() && BackfaceIsHidden();
}

bool
nsIFrame::HasPerspective() const
{
  if (!IsTransformed()) {
    return false;
  }
  nsIFrame* containingBlock = GetContainingBlock(SKIP_SCROLLED_FRAME);
  if (!containingBlock) {
    return false;
  }
  return containingBlock->ChildrenHavePerspective();
}

bool
nsIFrame::ChildrenHavePerspective() const
{
  return StyleDisplay()->HasPerspectiveStyle();
}

nsRect
nsIFrame::GetContentRectRelativeToSelf() const
{
  nsMargin bp(GetUsedBorderAndPadding());
  bp.ApplySkipSides(GetSkipSides());
  nsRect r(0, 0, mRect.width, mRect.height);
  r.Deflate(bp);
  return r;
}

nsRect
nsIFrame::GetContentRect() const
{
  return GetContentRectRelativeToSelf() + GetPosition();
}

bool
nsIFrame::ComputeBorderRadii(const nsStyleCorners& aBorderRadius,
                             const nsSize& aFrameSize,
                             const nsSize& aBorderArea,
                             Sides aSkipSides,
                             nscoord aRadii[8])
{
  // Percentages are relative to whichever side they're on.
  NS_FOR_CSS_HALF_CORNERS(i) {
    const nsStyleCoord c = aBorderRadius.Get(i);
    nscoord axis =
      NS_HALF_CORNER_IS_X(i) ? aFrameSize.width : aFrameSize.height;

    if (c.IsCoordPercentCalcUnit()) {
      aRadii[i] = nsRuleNode::ComputeCoordPercentCalc(c, axis);
      if (aRadii[i] < 0) {
        // clamp calc()
        aRadii[i] = 0;
      }
    } else {
      NS_NOTREACHED("ComputeBorderRadii: bad unit");
      aRadii[i] = 0;
    }
  }

  if (aSkipSides.Top()) {
    aRadii[NS_CORNER_TOP_LEFT_X] = 0;
    aRadii[NS_CORNER_TOP_LEFT_Y] = 0;
    aRadii[NS_CORNER_TOP_RIGHT_X] = 0;
    aRadii[NS_CORNER_TOP_RIGHT_Y] = 0;
  }

  if (aSkipSides.Right()) {
    aRadii[NS_CORNER_TOP_RIGHT_X] = 0;
    aRadii[NS_CORNER_TOP_RIGHT_Y] = 0;
    aRadii[NS_CORNER_BOTTOM_RIGHT_X] = 0;
    aRadii[NS_CORNER_BOTTOM_RIGHT_Y] = 0;
  }

  if (aSkipSides.Bottom()) {
    aRadii[NS_CORNER_BOTTOM_RIGHT_X] = 0;
    aRadii[NS_CORNER_BOTTOM_RIGHT_Y] = 0;
    aRadii[NS_CORNER_BOTTOM_LEFT_X] = 0;
    aRadii[NS_CORNER_BOTTOM_LEFT_Y] = 0;
  }

  if (aSkipSides.Left()) {
    aRadii[NS_CORNER_BOTTOM_LEFT_X] = 0;
    aRadii[NS_CORNER_BOTTOM_LEFT_Y] = 0;
    aRadii[NS_CORNER_TOP_LEFT_X] = 0;
    aRadii[NS_CORNER_TOP_LEFT_Y] = 0;
  }

  // css3-background specifies this algorithm for reducing
  // corner radii when they are too big.
  bool haveRadius = false;
  double ratio = 1.0f;
  NS_FOR_CSS_SIDES(side) {
    uint32_t hc1 = NS_SIDE_TO_HALF_CORNER(side, false, true);
    uint32_t hc2 = NS_SIDE_TO_HALF_CORNER(side, true, true);
    nscoord length =
      NS_SIDE_IS_VERTICAL(side) ? aBorderArea.height : aBorderArea.width;
    nscoord sum = aRadii[hc1] + aRadii[hc2];
    if (sum)
      haveRadius = true;

    // avoid floating point division in the normal case
    if (length < sum)
      ratio = std::min(ratio, double(length)/sum);
  }
  if (ratio < 1.0) {
    NS_FOR_CSS_HALF_CORNERS(corner) {
      aRadii[corner] *= ratio;
    }
  }

  return haveRadius;
}

/* static */ void
nsIFrame::InsetBorderRadii(nscoord aRadii[8], const nsMargin &aOffsets)
{
  NS_FOR_CSS_SIDES(side) {
    nscoord offset = aOffsets.Side(side);
    uint32_t hc1 = NS_SIDE_TO_HALF_CORNER(side, false, false);
    uint32_t hc2 = NS_SIDE_TO_HALF_CORNER(side, true, false);
    aRadii[hc1] = std::max(0, aRadii[hc1] - offset);
    aRadii[hc2] = std::max(0, aRadii[hc2] - offset);
  }
}

/* static */ void
nsIFrame::OutsetBorderRadii(nscoord aRadii[8], const nsMargin &aOffsets)
{
  NS_FOR_CSS_SIDES(side) {
    nscoord offset = aOffsets.Side(side);
    uint32_t hc1 = NS_SIDE_TO_HALF_CORNER(side, false, false);
    uint32_t hc2 = NS_SIDE_TO_HALF_CORNER(side, true, false);
    if (aRadii[hc1] > 0)
      aRadii[hc1] += offset;
    if (aRadii[hc2] > 0)
      aRadii[hc2] += offset;
  }
}

/* virtual */ bool
nsIFrame::GetBorderRadii(const nsSize& aFrameSize, const nsSize& aBorderArea,
                         Sides aSkipSides, nscoord aRadii[8]) const
{
  if (IsThemed()) {
    // When we're themed, the native theme code draws the border and
    // background, and therefore it doesn't make sense to tell other
    // code that's interested in border-radius that we have any radii.
    //
    // In an ideal world, we might have a way for the them to tell us an
    // border radius, but since we don't, we're better off assuming
    // zero.
    NS_FOR_CSS_HALF_CORNERS(corner) {
      aRadii[corner] = 0;
    }
    return false;
  }
  return ComputeBorderRadii(StyleBorder()->mBorderRadius,
                            aFrameSize, aBorderArea,
                            aSkipSides, aRadii);
}

bool
nsIFrame::GetBorderRadii(nscoord aRadii[8]) const
{
  nsSize sz = GetSize();
  return GetBorderRadii(sz, sz, GetSkipSides(), aRadii);
}

bool
nsIFrame::GetPaddingBoxBorderRadii(nscoord aRadii[8]) const
{
  if (!GetBorderRadii(aRadii))
    return false;
  InsetBorderRadii(aRadii, GetUsedBorder());
  NS_FOR_CSS_HALF_CORNERS(corner) {
    if (aRadii[corner])
      return true;
  }
  return false;
}

bool
nsIFrame::GetContentBoxBorderRadii(nscoord aRadii[8]) const
{
  if (!GetBorderRadii(aRadii))
    return false;
  InsetBorderRadii(aRadii, GetUsedBorderAndPadding());
  NS_FOR_CSS_HALF_CORNERS(corner) {
    if (aRadii[corner])
      return true;
  }
  return false;
}

nsStyleContext*
nsFrame::GetAdditionalStyleContext(int32_t aIndex) const
{
  NS_PRECONDITION(aIndex >= 0, "invalid index number");
  return nullptr;
}

void
nsFrame::SetAdditionalStyleContext(int32_t aIndex, 
                                   nsStyleContext* aStyleContext)
{
  NS_PRECONDITION(aIndex >= 0, "invalid index number");
}

nscoord
nsFrame::GetLogicalBaseline(WritingMode aWritingMode) const
{
  NS_ASSERTION(!NS_SUBTREE_DIRTY(this),
               "frame must not be dirty");
  // Baseline for inverted line content is the top (block-start) margin edge,
  // as the frame is in effect "flipped" for alignment purposes.
  if (aWritingMode.IsLineInverted()) {
    return -GetLogicalUsedMargin(aWritingMode).BStart(aWritingMode);
  }
  // Otherwise, the bottom margin edge, per CSS2.1's definition of the
  // 'baseline' value of 'vertical-align'.
  return BSize(aWritingMode) +
         GetLogicalUsedMargin(aWritingMode).BEnd(aWritingMode);
}

const nsFrameList&
nsFrame::GetChildList(ChildListID aListID) const
{
  if (IsAbsoluteContainer() &&
      aListID == GetAbsoluteListID()) {
    return GetAbsoluteContainingBlock()->GetChildList();
  } else {
    return nsFrameList::EmptyList();
  }
}

void
nsFrame::GetChildLists(nsTArray<ChildList>* aLists) const
{
  if (IsAbsoluteContainer()) {
    nsFrameList absoluteList = GetAbsoluteContainingBlock()->GetChildList();
    absoluteList.AppendIfNonempty(aLists, GetAbsoluteListID());
  }
}

void
nsIFrame::GetCrossDocChildLists(nsTArray<ChildList>* aLists)
{
  nsSubDocumentFrame* subdocumentFrame = do_QueryFrame(this);
  if (subdocumentFrame) {
    // Descend into the subdocument
    nsIFrame* root = subdocumentFrame->GetSubdocumentRootFrame();
    if (root) {
      aLists->AppendElement(nsIFrame::ChildList(
        nsFrameList(root, nsLayoutUtils::GetLastSibling(root)),
        nsIFrame::kPrincipalList));
    }
  }

  GetChildLists(aLists);
}

Visibility
nsIFrame::GetVisibility() const
{
  if (!(GetStateBits() & NS_FRAME_VISIBILITY_IS_TRACKED)) {
    return Visibility::UNTRACKED;
  }

  bool isSet = false;
  FrameProperties props = Properties();
  uint32_t visibleCount = props.Get(VisibilityStateProperty(), &isSet);

  MOZ_ASSERT(isSet, "Should have a VisibilityStateProperty value "
                    "if NS_FRAME_VISIBILITY_IS_TRACKED is set");

  return visibleCount > 0
       ? Visibility::APPROXIMATELY_VISIBLE
       : Visibility::APPROXIMATELY_NONVISIBLE;
}

void
nsIFrame::UpdateVisibilitySynchronously()
{
  nsIPresShell* presShell = PresContext()->PresShell();
  if (!presShell) {
    return;
  }

  if (presShell->AssumeAllFramesVisible()) {
    presShell->EnsureFrameInApproximatelyVisibleList(this);
    return;
  }

  bool visible = true;
  nsIFrame* f = GetParent();
  nsRect rect = GetRectRelativeToSelf();
  nsIFrame* rectFrame = this;
  while (f) {
    nsIScrollableFrame* sf = do_QueryFrame(f);
    if (sf) {
      nsRect transformedRect =
        nsLayoutUtils::TransformFrameRectToAncestor(rectFrame, rect, f);
      if (!sf->IsRectNearlyVisible(transformedRect)) {
        visible = false;
        break;
      }

      // In this code we're trying to synchronously update *approximate*
      // visibility. (In the future we may update precise visibility here as
      // well, which is why the method name does not contain 'approximate'.) The
      // IsRectNearlyVisible() check above tells us that the rect we're checking
      // is approximately visible within the scrollframe, but we still need to
      // ensure that, even if it was scrolled into view, it'd be visible when we
      // consider the rest of the document. To do that, we move transformedRect
      // to be contained in the scrollport as best we can (it might not fit) to
      // pretend that it was scrolled into view.
      rect = transformedRect.MoveInsideAndClamp(sf->GetScrollPortRect());
      rectFrame = f;
    }
    nsIFrame* parent = f->GetParent();
    if (!parent) {
      parent = nsLayoutUtils::GetCrossDocParentFrame(f);
      if (parent && parent->PresContext()->IsChrome()) {
        break;
      }
    }
    f = parent;
  }

  if (visible) {
    presShell->EnsureFrameInApproximatelyVisibleList(this);
  } else {
    presShell->RemoveFrameFromApproximatelyVisibleList(this);
  }
}

void
nsIFrame::EnableVisibilityTracking()
{
  if (GetStateBits() & NS_FRAME_VISIBILITY_IS_TRACKED) {
    return;  // Nothing to do.
  }

  FrameProperties props = Properties();
  MOZ_ASSERT(!props.Has(VisibilityStateProperty()),
             "Shouldn't have a VisibilityStateProperty value "
             "if NS_FRAME_VISIBILITY_IS_TRACKED is not set");

  // Add the state bit so we know to track visibility for this frame, and
  // initialize the frame property.
  AddStateBits(NS_FRAME_VISIBILITY_IS_TRACKED);
  props.Set(VisibilityStateProperty(), 0);

  nsIPresShell* presShell = PresContext()->PresShell();
  if (!presShell) {
    return;
  }

  // Schedule a visibility update. This method will virtually always be called
  // when layout has changed anyway, so it's very unlikely that any additional
  // visibility updates will be triggered by this, but this way we guarantee
  // that if this frame is currently visible we'll eventually find out.
  presShell->ScheduleApproximateFrameVisibilityUpdateSoon();
}

void
nsIFrame::DisableVisibilityTracking()
{
  if (!(GetStateBits() & NS_FRAME_VISIBILITY_IS_TRACKED)) {
    return;  // Nothing to do.
  }

  bool isSet = false;
  FrameProperties props = Properties();
  uint32_t visibleCount = props.Remove(VisibilityStateProperty(), &isSet);

  MOZ_ASSERT(isSet, "Should have a VisibilityStateProperty value "
                    "if NS_FRAME_VISIBILITY_IS_TRACKED is set");

  RemoveStateBits(NS_FRAME_VISIBILITY_IS_TRACKED);

  if (visibleCount == 0) {
    return;  // We were nonvisible.
  }

  // We were visible, so send an OnVisibilityChange() notification.
  OnVisibilityChange(Visibility::APPROXIMATELY_NONVISIBLE);
}

void
nsIFrame::DecApproximateVisibleCount(Maybe<OnNonvisible> aNonvisibleAction
                                       /* = Nothing() */)
{
  MOZ_ASSERT(GetStateBits() & NS_FRAME_VISIBILITY_IS_TRACKED);

  bool isSet = false;
  FrameProperties props = Properties();
  uint32_t visibleCount = props.Get(VisibilityStateProperty(), &isSet);

  MOZ_ASSERT(isSet, "Should have a VisibilityStateProperty value "
                    "if NS_FRAME_VISIBILITY_IS_TRACKED is set");
  MOZ_ASSERT(visibleCount > 0, "Frame is already nonvisible and we're "
                               "decrementing its visible count?");

  visibleCount--;
  props.Set(VisibilityStateProperty(), visibleCount);
  if (visibleCount > 0) {
    return;
  }

  // We just became nonvisible, so send an OnVisibilityChange() notification.
  OnVisibilityChange(Visibility::APPROXIMATELY_NONVISIBLE, aNonvisibleAction);
}

void
nsIFrame::IncApproximateVisibleCount()
{
  MOZ_ASSERT(GetStateBits() & NS_FRAME_VISIBILITY_IS_TRACKED);

  bool isSet = false;
  FrameProperties props = Properties();
  uint32_t visibleCount = props.Get(VisibilityStateProperty(), &isSet);

  MOZ_ASSERT(isSet, "Should have a VisibilityStateProperty value "
                    "if NS_FRAME_VISIBILITY_IS_TRACKED is set");

  visibleCount++;
  props.Set(VisibilityStateProperty(), visibleCount);
  if (visibleCount > 1) {
    return;
  }

  // We just became visible, so send an OnVisibilityChange() notification.
  OnVisibilityChange(Visibility::APPROXIMATELY_VISIBLE);
}

void
nsIFrame::OnVisibilityChange(Visibility aNewVisibility,
                             Maybe<OnNonvisible> aNonvisibleAction
                               /* = Nothing() */)
{
  // XXX(seth): In bug 1218990 we'll implement visibility tracking for CSS
  // images here.
}

static nsIFrame*
GetActiveSelectionFrame(nsPresContext* aPresContext, nsIFrame* aFrame)
{
  nsIContent* capturingContent = nsIPresShell::GetCapturingContent();
  if (capturingContent) {
    nsIFrame* activeFrame = aPresContext->GetPrimaryFrameFor(capturingContent);
    return activeFrame ? activeFrame : aFrame;
  }

  return aFrame;
}

int16_t
nsFrame::DisplaySelection(nsPresContext* aPresContext, bool isOkToTurnOn)
{
  int16_t selType = nsISelectionController::SELECTION_OFF;

  nsCOMPtr<nsISelectionController> selCon;
  nsresult result = GetSelectionController(aPresContext, getter_AddRefs(selCon));
  if (NS_SUCCEEDED(result) && selCon) {
    result = selCon->GetDisplaySelection(&selType);
    if (NS_SUCCEEDED(result) && (selType != nsISelectionController::SELECTION_OFF)) {
      // Check whether style allows selection.
      bool selectable;
      IsSelectable(&selectable, nullptr);
      if (!selectable) {
        selType = nsISelectionController::SELECTION_OFF;
        isOkToTurnOn = false;
      }
    }
    if (isOkToTurnOn && (selType == nsISelectionController::SELECTION_OFF)) {
      selCon->SetDisplaySelection(nsISelectionController::SELECTION_ON);
      selType = nsISelectionController::SELECTION_ON;
    }
  }
  return selType;
}

class nsDisplaySelectionOverlay : public nsDisplayItem {
public:
  nsDisplaySelectionOverlay(nsDisplayListBuilder* aBuilder,
                            nsFrame* aFrame, int16_t aSelectionValue)
    : nsDisplayItem(aBuilder, aFrame), mSelectionValue(aSelectionValue) {
    MOZ_COUNT_CTOR(nsDisplaySelectionOverlay);
  }
#ifdef NS_BUILD_REFCNT_LOGGING
  virtual ~nsDisplaySelectionOverlay() {
    MOZ_COUNT_DTOR(nsDisplaySelectionOverlay);
  }
#endif

  virtual void Paint(nsDisplayListBuilder* aBuilder,
                     nsRenderingContext* aCtx) override;
  NS_DISPLAY_DECL_NAME("SelectionOverlay", TYPE_SELECTION_OVERLAY)
private:
  int16_t mSelectionValue;
};

void nsDisplaySelectionOverlay::Paint(nsDisplayListBuilder* aBuilder,
                                      nsRenderingContext* aCtx)
{
  DrawTarget& aDrawTarget = *aCtx->GetDrawTarget();

  LookAndFeel::ColorID colorID;
  if (mSelectionValue == nsISelectionController::SELECTION_ON) {
    colorID = LookAndFeel::eColorID_TextSelectBackground;
  } else if (mSelectionValue == nsISelectionController::SELECTION_ATTENTION) {
    colorID = LookAndFeel::eColorID_TextSelectBackgroundAttention;
  } else {
    colorID = LookAndFeel::eColorID_TextSelectBackgroundDisabled;
  }

  Color c = Color::FromABGR(LookAndFeel::GetColor(colorID, NS_RGB(255, 255, 255)));
  c.a = .5;
  ColorPattern color(ToDeviceColor(c));

  nsIntRect pxRect =
    mVisibleRect.ToOutsidePixels(mFrame->PresContext()->AppUnitsPerDevPixel());
  Rect rect(pxRect.x, pxRect.y, pxRect.width, pxRect.height);
  MaybeSnapToDevicePixels(rect, aDrawTarget, true);

  aDrawTarget.FillRect(rect, color);
}

/********************************************************
* Refreshes each content's frame
*********************************************************/

void
nsFrame::DisplaySelectionOverlay(nsDisplayListBuilder*   aBuilder,
                                 nsDisplayList*          aList,
                                 uint16_t                aContentType)
{
  if (!IsSelected() || !IsVisibleForPainting(aBuilder))
    return;
    
  nsPresContext* presContext = PresContext();
  nsIPresShell *shell = presContext->PresShell();
  if (!shell)
    return;

  int16_t displaySelection = shell->GetSelectionFlags();
  if (!(displaySelection & aContentType))
    return;

  const nsFrameSelection* frameSelection = GetConstFrameSelection();
  int16_t selectionValue = frameSelection->GetDisplaySelection();

  if (selectionValue <= nsISelectionController::SELECTION_HIDDEN)
    return; // selection is hidden or off

  nsIContent *newContent = mContent->GetParent();

  //check to see if we are anonymous content
  int32_t offset = 0;
  if (newContent) {
    // XXXbz there has GOT to be a better way of determining this!
    offset = newContent->IndexOf(mContent);
  }

  SelectionDetails *details;
  //look up to see what selection(s) are on this frame
  details = frameSelection->LookUpSelection(newContent, offset, 1, false);
  if (!details)
    return;
  
  bool normal = false;
  while (details) {
    if (details->mSelectionType == SelectionType::eNormal) {
      normal = true;
    }
    SelectionDetails *next = details->mNext;
    delete details;
    details = next;
  }

  if (!normal && aContentType == nsISelectionDisplay::DISPLAY_IMAGES) {
    // Don't overlay an image if it's not in the primary selection.
    return;
  }

  aList->AppendNewToTop(new (aBuilder)
    nsDisplaySelectionOverlay(aBuilder, this, selectionValue));
}

void
nsFrame::DisplayOutlineUnconditional(nsDisplayListBuilder*   aBuilder,
                                     const nsDisplayListSet& aLists)
{
  if (StyleOutline()->mOutlineStyle == NS_STYLE_BORDER_STYLE_NONE) {
    return;
  }

  aLists.Outlines()->AppendNewToTop(
    new (aBuilder) nsDisplayOutline(aBuilder, this));
}

void
nsFrame::DisplayOutline(nsDisplayListBuilder*   aBuilder,
                        const nsDisplayListSet& aLists)
{
  if (!IsVisibleForPainting(aBuilder))
    return;

  DisplayOutlineUnconditional(aBuilder, aLists);
}

void
nsIFrame::DisplayCaret(nsDisplayListBuilder* aBuilder,
                       const nsRect& aDirtyRect, nsDisplayList* aList)
{
  if (!IsVisibleForPainting(aBuilder))
    return;

  aList->AppendNewToTop(new (aBuilder) nsDisplayCaret(aBuilder, this));
}

nscolor
nsIFrame::GetCaretColorAt(int32_t aOffset)
{
  // Use text color.
  return StyleColor()->mColor;
}

bool
nsFrame::DisplayBackgroundUnconditional(nsDisplayListBuilder* aBuilder,
                                        const nsDisplayListSet& aLists,
                                        bool aForceBackground)
{
  // Here we don't try to detect background propagation. Frames that might
  // receive a propagated background should just set aForceBackground to
  // true.
  if (aBuilder->IsForEventDelivery() || aForceBackground ||
      !StyleBackground()->IsTransparent() || StyleDisplay()->mAppearance) {
    return nsDisplayBackgroundImage::AppendBackgroundItemsToTop(
        aBuilder, this, GetRectRelativeToSelf(), aLists.BorderBackground());
  }
  return false;
}

void
nsFrame::DisplayBorderBackgroundOutline(nsDisplayListBuilder*   aBuilder,
                                        const nsDisplayListSet& aLists,
                                        bool                    aForceBackground)
{
  // The visibility check belongs here since child elements have the
  // opportunity to override the visibility property and display even if
  // their parent is hidden.
  if (!IsVisibleForPainting(aBuilder)) {
    return;
  }

  nsCSSShadowArray* shadows = StyleEffects()->mBoxShadow;
  if (shadows && shadows->HasShadowWithInset(false)) {
    aLists.BorderBackground()->AppendNewToTop(new (aBuilder)
      nsDisplayBoxShadowOuter(aBuilder, this));
  }

  bool bgIsThemed = DisplayBackgroundUnconditional(aBuilder, aLists,
                                                   aForceBackground);

  if (shadows && shadows->HasShadowWithInset(true)) {
    aLists.BorderBackground()->AppendNewToTop(new (aBuilder)
      nsDisplayBoxShadowInner(aBuilder, this));
  }

  // If there's a themed background, we should not create a border item.
  // It won't be rendered.
  if (!bgIsThemed && StyleBorder()->HasBorder()) {
    aLists.BorderBackground()->AppendNewToTop(new (aBuilder)
      nsDisplayBorder(aBuilder, this));
  }

  DisplayOutlineUnconditional(aBuilder, aLists);
}

inline static bool IsSVGContentWithCSSClip(const nsIFrame *aFrame)
{
  // The CSS spec says that the 'clip' property only applies to absolutely
  // positioned elements, whereas the SVG spec says that it applies to SVG
  // elements regardless of the value of the 'position' property. Here we obey
  // the CSS spec for outer-<svg> (since that's what we generally do), but
  // obey the SVG spec for other SVG elements to which 'clip' applies.
  return (aFrame->GetStateBits() & NS_FRAME_SVG_LAYOUT) &&
          aFrame->GetContent()->IsAnyOfSVGElements(nsGkAtoms::svg,
                                                   nsGkAtoms::foreignObject);
}

Maybe<nsRect>
nsIFrame::GetClipPropClipRect(const nsStyleDisplay* aDisp,
                              const nsStyleEffects* aEffects,
                              const nsSize& aSize) const
{
  if (!(aEffects->mClipFlags & NS_STYLE_CLIP_RECT) ||
      !(aDisp->IsAbsolutelyPositioned(this) || IsSVGContentWithCSSClip(this))) {
    return Nothing();
  }

  nsRect rect = aEffects->mClip;
  if (MOZ_LIKELY(StyleBorder()->mBoxDecorationBreak ==
                   StyleBoxDecorationBreak::Slice)) {
    // The clip applies to the joined boxes so it's relative the first
    // continuation.
    nscoord y = 0;
    for (nsIFrame* f = GetPrevContinuation(); f; f = f->GetPrevContinuation()) {
      y += f->GetRect().height;
    }
    rect.MoveBy(nsPoint(0, -y));
  }

  if (NS_STYLE_CLIP_RIGHT_AUTO & aEffects->mClipFlags) {
    rect.width = aSize.width - rect.x;
  }
  if (NS_STYLE_CLIP_BOTTOM_AUTO & aEffects->mClipFlags) {
    rect.height = aSize.height - rect.y;
  }
  return Some(rect);
}

/**
 * If the CSS 'overflow' property applies to this frame, and is not
 * handled by constructing a dedicated nsHTML/XULScrollFrame, set up clipping
 * for that overflow in aBuilder->ClipState() to clip all containing-block
 * descendants.
 */
static void
ApplyOverflowClipping(nsDisplayListBuilder* aBuilder,
                      const nsIFrame* aFrame,
                      const nsStyleDisplay* aDisp,
                      DisplayListClipState::AutoClipMultiple& aClipState)
{
  // Only -moz-hidden-unscrollable is handled here (and 'hidden' for table
  // frames, and any non-visible value for blocks in a paginated context).
  // We allow -moz-hidden-unscrollable to apply to any kind of frame. This
  // is required by comboboxes which make their display text (an inline frame)
  // have clipping.
  if (!nsFrame::ShouldApplyOverflowClipping(aFrame, aDisp)) {
    return;
  }
  nsRect clipRect;
  bool haveRadii = false;
  nscoord radii[8];
  if (aFrame->StyleDisplay()->mOverflowClipBox ==
        NS_STYLE_OVERFLOW_CLIP_BOX_PADDING_BOX) {
    clipRect = aFrame->GetPaddingRectRelativeToSelf() +
      aBuilder->ToReferenceFrame(aFrame);
    haveRadii = aFrame->GetPaddingBoxBorderRadii(radii);
  } else {
    clipRect = aFrame->GetContentRectRelativeToSelf() +
      aBuilder->ToReferenceFrame(aFrame);
    // XXX border-radius
  }
  aClipState.ClipContainingBlockDescendantsExtra(clipRect, haveRadii ? radii : nullptr);
}

#ifdef DEBUG
static void PaintDebugBorder(nsIFrame* aFrame, DrawTarget* aDrawTarget,
     const nsRect& aDirtyRect, nsPoint aPt)
{
  nsRect r(aPt, aFrame->GetSize());
  int32_t appUnitsPerDevPixel = aFrame->PresContext()->AppUnitsPerDevPixel();
  Color blueOrRed(aFrame->HasView() ? Color(0.f, 0.f, 1.f, 1.f) :
                                      Color(1.f, 0.f, 0.f, 1.f));
  aDrawTarget->StrokeRect(NSRectToRect(r, appUnitsPerDevPixel),
                          ColorPattern(ToDeviceColor(blueOrRed)));
}

static void PaintEventTargetBorder(nsIFrame* aFrame, DrawTarget* aDrawTarget,
     const nsRect& aDirtyRect, nsPoint aPt)
{
  nsRect r(aPt, aFrame->GetSize());
  int32_t appUnitsPerDevPixel = aFrame->PresContext()->AppUnitsPerDevPixel();
  ColorPattern purple(ToDeviceColor(Color(.5f, 0.f, .5f, 1.f)));
  aDrawTarget->StrokeRect(NSRectToRect(r, appUnitsPerDevPixel), purple);
}

static void
DisplayDebugBorders(nsDisplayListBuilder* aBuilder, nsIFrame* aFrame,
                    const nsDisplayListSet& aLists) {
  // Draw a border around the child
  // REVIEW: From nsContainerFrame::PaintChild
  if (nsFrame::GetShowFrameBorders() && !aFrame->GetRect().IsEmpty()) {
    aLists.Outlines()->AppendNewToTop(new (aBuilder)
        nsDisplayGeneric(aBuilder, aFrame, PaintDebugBorder, "DebugBorder",
                         nsDisplayItem::TYPE_DEBUG_BORDER));
  }
  // Draw a border around the current event target
  if (nsFrame::GetShowEventTargetFrameBorder() &&
      aFrame->PresContext()->PresShell()->GetDrawEventTargetFrame() == aFrame) {
    aLists.Outlines()->AppendNewToTop(new (aBuilder)
        nsDisplayGeneric(aBuilder, aFrame, PaintEventTargetBorder, "EventTargetBorder",
                         nsDisplayItem::TYPE_EVENT_TARGET_BORDER));
  }
}
#endif

static bool
IsScrollFrameActive(nsDisplayListBuilder* aBuilder, nsIScrollableFrame* aScrollableFrame)
{
  return aScrollableFrame && aScrollableFrame->IsScrollingActive(aBuilder);
}

class AutoSaveRestoreContainsBlendMode
{
  nsDisplayListBuilder& mBuilder;
  bool mSavedContainsBlendMode;
public:
  explicit AutoSaveRestoreContainsBlendMode(nsDisplayListBuilder& aBuilder)
    : mBuilder(aBuilder)
    , mSavedContainsBlendMode(aBuilder.ContainsBlendMode())
  { }

  ~AutoSaveRestoreContainsBlendMode() {
    mBuilder.SetContainsBlendMode(mSavedContainsBlendMode);
  }
};

static void
CheckForApzAwareEventHandlers(nsDisplayListBuilder* aBuilder, nsIFrame* aFrame)
{
  nsIContent* content = aFrame->GetContent();
  if (!content) {
    return;
  }

  if (content->IsNodeApzAware()) {
    aBuilder->SetAncestorHasApzAwareEventHandler(true);
  }
}

/**
 * True if aDescendant participates the context aAncestor participating.
 */
static bool
FrameParticipatesIn3DContext(nsIFrame* aAncestor, nsIFrame* aDescendant) {
  MOZ_ASSERT(aAncestor != aDescendant);
  MOZ_ASSERT(aAncestor->Extend3DContext());
  nsIFrame* frame;
  for (frame = nsLayoutUtils::GetCrossDocParentFrame(aDescendant);
       frame && aAncestor != frame;
       frame = nsLayoutUtils::GetCrossDocParentFrame(frame)) {
    if (!frame->Extend3DContext()) {
      return false;
    }
  }
  MOZ_ASSERT(frame == aAncestor);
  return true;
}

static bool
ItemParticipatesIn3DContext(nsIFrame* aAncestor, nsDisplayItem* aItem)
{
  nsIFrame* transformFrame;
  if (aItem->GetType() == nsDisplayItem::TYPE_TRANSFORM) {
    transformFrame = aItem->Frame();
  } else if (aItem->GetType() == nsDisplayItem::TYPE_PERSPECTIVE) {
    transformFrame = static_cast<nsDisplayPerspective*>(aItem)->TransformFrame();
  } else {
    return false;
  }
  if (aAncestor == transformFrame) {
    return true;
  }
  return FrameParticipatesIn3DContext(aAncestor, transformFrame);
}

static void
WrapSeparatorTransform(nsDisplayListBuilder* aBuilder, nsIFrame* aFrame,
                       nsRect& aDirtyRect,
                       nsDisplayList* aSource, nsDisplayList* aTarget,
                       int aIndex) {
  if (!aSource->IsEmpty()) {
    nsDisplayTransform *sepIdItem =
      new (aBuilder) nsDisplayTransform(aBuilder, aFrame, aSource,
                                        aDirtyRect, Matrix4x4(), aIndex);
    sepIdItem->SetNoExtendContext();
    aTarget->AppendToTop(sepIdItem);
  }
}

void
nsIFrame::BuildDisplayListForStackingContext(nsDisplayListBuilder* aBuilder,
                                             const nsRect&         aDirtyRect,
                                             nsDisplayList*        aList) {
  if (GetStateBits() & NS_FRAME_TOO_DEEP_IN_FRAME_TREE)
    return;

  // Replaced elements have their visibility handled here, because
  // they're visually atomic
  if (IsFrameOfType(eReplaced) && !IsVisibleForPainting(aBuilder))
    return;

  const nsStyleDisplay* disp = StyleDisplay();
  const nsStyleEffects* effects = StyleEffects();
  // We can stop right away if this is a zero-opacity stacking context and
  // we're painting, and we're not animating opacity. Don't do this
  // if we're going to compute plugin geometry, since opacity-0 plugins
  // need to have display items built for them.
  bool needEventRegions =
    aBuilder->IsBuildingLayerEventRegions() &&
    StyleUserInterface()->GetEffectivePointerEvents(this) !=
      NS_STYLE_POINTER_EVENTS_NONE;
  bool opacityItemForEventsAndPluginsOnly = false;
  if (effects->mOpacity == 0.0 && aBuilder->IsForPainting() &&
      !(disp->mWillChangeBitField & NS_STYLE_WILL_CHANGE_OPACITY) &&
      !nsLayoutUtils::HasAnimationOfProperty(this, eCSSProperty_opacity)) {
    if (needEventRegions ||
        aBuilder->WillComputePluginGeometry()) {
      opacityItemForEventsAndPluginsOnly = true;
    } else {
      return;
    }
  }

  if (disp->mWillChangeBitField != 0) {
    aBuilder->AddToWillChangeBudget(this, GetSize());
  }

  bool extend3DContext = Extend3DContext();
  Maybe<nsDisplayListBuilder::AutoPreserves3DContext> autoPreserves3DContext;
  if (extend3DContext && !Combines3DTransformWithAncestors()) {
    // Start a new preserves3d context to keep informations on
    // nsDisplayListBuilder.
    autoPreserves3DContext.emplace(aBuilder);
    // Save dirty rect on the builder to avoid being distorted for
    // multiple transforms along the chain.
    aBuilder->SetPreserves3DDirtyRect(aDirtyRect);
  }

  // For preserves3d, use the dirty rect already installed on the
  // builder, since aDirtyRect maybe distorted for transforms along
  // the chain.
  nsRect dirtyRect = aDirtyRect;

  bool inTransform = aBuilder->IsInTransform();
  bool isTransformed = IsTransformed();
  bool hasPerspective = HasPerspective();
  // reset blend mode so we can keep track if this stacking context needs have
  // a nsDisplayBlendContainer. Set the blend mode back when the routine exits
  // so we keep track if the parent stacking context needs a container too.
  AutoSaveRestoreContainsBlendMode autoRestoreBlendMode(*aBuilder);
  aBuilder->SetContainsBlendMode(false);
 
  nsRect dirtyRectOutsideTransform = dirtyRect;
  if (isTransformed) {
    const nsRect overflow = GetVisualOverflowRectRelativeToSelf();
    if (nsDisplayTransform::ShouldPrerenderTransformedContent(aBuilder,
                                                              this)) {
      dirtyRect = overflow;
    } else {
      if (overflow.IsEmpty() && !extend3DContext) {
        return;
      }

      // If we're in preserve-3d then grab the dirty rect that was given to the root
      // and transform using the combined transform.
      if (Combines3DTransformWithAncestors()) {
        dirtyRect = aBuilder->GetPreserves3DDirtyRect(this);
      }

      nsRect untransformedDirtyRect;
      if (nsDisplayTransform::UntransformRect(dirtyRect, overflow, this,
            &untransformedDirtyRect)) {
        dirtyRect = untransformedDirtyRect;
      } else {
        NS_WARNING("Unable to untransform dirty rect!");
        // This should only happen if the transform is singular, in which case nothing is visible anyway
        dirtyRect.SetEmpty();
      }
    }
    inTransform = true;
  }
  bool usingFilter = StyleEffects()->HasFilters();
  bool usingMask = nsSVGIntegrationUtils::UsingMaskOrClipPathForFrame(this);
  bool usingSVGEffects = usingFilter || usingMask;

  nsRect dirtyRectOutsideSVGEffects = dirtyRect;
  nsDisplayList hoistedScrollInfoItemsStorage;
  if (usingSVGEffects) {
    dirtyRect =
      nsSVGIntegrationUtils::GetRequiredSourceForInvalidArea(this, dirtyRect);
    aBuilder->EnterSVGEffectsContents(&hoistedScrollInfoItemsStorage);
  }

  // We build an opacity item if it's not going to be drawn by SVG content, or
  // SVG effects. SVG effects won't handle the opacity if we want an active
  // layer (for async animations), see
  // nsSVGIntegrationsUtils::PaintMaskAndClipPath or
  // nsSVGIntegrationsUtils::PaintFilter.
  bool useOpacity = HasVisualOpacity() && !nsSVGUtils::CanOptimizeOpacity(this) &&
                    (!usingSVGEffects || nsDisplayOpacity::NeedsActiveLayer(aBuilder, this));
  bool useBlendMode = effects->mMixBlendMode != NS_STYLE_BLEND_NORMAL;
  bool useStickyPosition = disp->mPosition == NS_STYLE_POSITION_STICKY &&
    IsScrollFrameActive(aBuilder,
                        nsLayoutUtils::GetNearestScrollableFrame(GetParent(),
                        nsLayoutUtils::SCROLLABLE_SAME_DOC |
                        nsLayoutUtils::SCROLLABLE_INCLUDE_HIDDEN));
  bool useFixedPosition = nsLayoutUtils::IsFixedPosFrameInDisplayPort(this);

  nsDisplayListBuilder::AutoBuildingDisplayList
    buildingDisplayList(aBuilder, this, dirtyRect, true);

  // Depending on the effects that are applied to this frame, we can create
  // multiple container display items and wrap them around our contents.
  // This enum lists all the potential container display items, in the order
  // outside to inside.
  enum class ContainerItemType : uint8_t {
    eNone = 0,
    eOwnLayerIfNeeded,
    eBlendMode,
    eFixedPosition,
    eStickyPosition,
    eOwnLayerForTransformWithRoundedClip,
    ePerspective,
    eTransform,
    eSeparatorTransforms,
    eOpacity,
    eFilter,
    eBlendContainer
  };

  DisplayListClipState::AutoSaveRestore clipState(aBuilder);

  // If there is a current clip, then depending on the container items we
  // create, different things can happen to it. Some container items simply
  // propagate the clip to their children and aren't clipped themselves.
  // But other container items, especially those that establish a different
  // geometry for their contents (e.g. transforms), capture the clip on
  // themselves and unset the clip for their contents. If we create more than
  // one of those container items, the clip will be captured on the outermost
  // one and the inner container items will be unclipped.
  ContainerItemType clipCapturedBy = ContainerItemType::eNone;
  if (useFixedPosition) {
    clipCapturedBy = ContainerItemType::eFixedPosition;
  } else if (useStickyPosition) {
    clipCapturedBy = ContainerItemType::eStickyPosition;
  } else if (isTransformed) {
    if ((hasPerspective || extend3DContext) && clipState.SavedStateHasRoundedCorners()) {
      // If we're creating an nsDisplayTransform item that is going to combine
      // its transform with its children (preserve-3d or perspective), then we
      // can't have an intermediate surface. Mask layers force an intermediate
      // surface, so if we're going to need both then create a separate
      // wrapping layer for the mask.
      clipCapturedBy = ContainerItemType::eOwnLayerForTransformWithRoundedClip;
    } else if (hasPerspective) {
      clipCapturedBy = ContainerItemType::ePerspective;
    } else {
      clipCapturedBy = ContainerItemType::eTransform;
    }
  } else if (usingFilter) {
    clipCapturedBy = ContainerItemType::eFilter;
  }

  bool clearClip = false;
  if (clipCapturedBy != ContainerItemType::eNone) {
    // We don't need to pass ancestor clipping down to our children;
    // everything goes inside a display item's child list, and the display
    // item itself will be clipped.
    // For transforms we also need to clear ancestor clipping because it's
    // relative to the wrong display item reference frame anyway.
    clearClip = true;
  }

  clipState.EnterStackingContextContents(clearClip);

  nsDisplayListCollection set;
  {
    DisplayListClipState::AutoSaveRestore nestedClipState(aBuilder);
    nsDisplayListBuilder::AutoInTransformSetter
      inTransformSetter(aBuilder, inTransform);
    nsDisplayListBuilder::AutoSaveRestorePerspectiveIndex
      perspectiveIndex(aBuilder, this);

    CheckForApzAwareEventHandlers(aBuilder, this);

    Maybe<nsRect> clipPropClip = GetClipPropClipRect(disp, effects, GetSize());
    if (clipPropClip) {
      dirtyRect.IntersectRect(dirtyRect, *clipPropClip);
      nestedClipState.ClipContentDescendants(
        *clipPropClip + aBuilder->ToReferenceFrame(this));
    }

    // extend3DContext also guarantees that applyAbsPosClipping and usingSVGEffects are false
    // We only modify the preserve-3d rect if we are the top of a preserve-3d heirarchy
    if (extend3DContext) {
      // Mark these first so MarkAbsoluteFramesForDisplayList knows if we are
      // going to be forced to descend into frames.
      aBuilder->MarkPreserve3DFramesForDisplayList(this);
    }

    MarkAbsoluteFramesForDisplayList(aBuilder, dirtyRect);

    nsDisplayLayerEventRegions* eventRegions = nullptr;
    if (aBuilder->IsBuildingLayerEventRegions()) {
      eventRegions = new (aBuilder) nsDisplayLayerEventRegions(aBuilder, this);
      eventRegions->AddFrame(aBuilder, this);
      aBuilder->SetLayerEventRegions(eventRegions);
    }
    aBuilder->AdjustWindowDraggingRegion(this);
    BuildDisplayList(aBuilder, dirtyRect, set);
    if (eventRegions) {
      // If the event regions item ended up empty, throw it away rather than
      // adding it to the display list.
      if (!eventRegions->IsEmpty()) {
        set.BorderBackground()->AppendToBottom(eventRegions);
      } else {
        aBuilder->SetLayerEventRegions(nullptr);
        eventRegions->~nsDisplayLayerEventRegions();
        eventRegions = nullptr;
      }
    }
  }

  if (aBuilder->IsBackgroundOnly()) {
    set.BlockBorderBackgrounds()->DeleteAll();
    set.Floats()->DeleteAll();
    set.Content()->DeleteAll();
    set.PositionedDescendants()->DeleteAll();
    set.Outlines()->DeleteAll();
  }

  // Sort PositionedDescendants() in CSS 'z-order' order.  The list is already
  // in content document order and SortByZOrder is a stable sort which
  // guarantees that boxes produced by the same element are placed together
  // in the sort. Consider a position:relative inline element that breaks
  // across lines and has absolutely positioned children; all the abs-pos
  // children should be z-ordered after all the boxes for the position:relative
  // element itself.
  set.PositionedDescendants()->SortByZOrder();

  nsDisplayList resultList;
  // Now follow the rules of http://www.w3.org/TR/CSS21/zindex.html
  // 1,2: backgrounds and borders
  resultList.AppendToTop(set.BorderBackground());
  // 3: negative z-index children.
  for (;;) {
    nsDisplayItem* item = set.PositionedDescendants()->GetBottom();
    if (item && item->ZIndex() < 0) {
      set.PositionedDescendants()->RemoveBottom();
      resultList.AppendToTop(item);
      continue;
    }
    break;
  }
  // 4: block backgrounds
  resultList.AppendToTop(set.BlockBorderBackgrounds());
  // 5: floats
  resultList.AppendToTop(set.Floats());
  // 7: general content
  resultList.AppendToTop(set.Content());
  // 7.5: outlines, in content tree order. We need to sort by content order
  // because an element with outline that breaks and has children with outline
  // might have placed child outline items between its own outline items.
  // The element's outline items need to all come before any child outline
  // items.
  nsIContent* content = GetContent();
  if (!content) {
    content = PresContext()->Document()->GetRootElement();
  }
  if (content) {
    set.Outlines()->SortByContentOrder(content);
  }
#ifdef DEBUG
  DisplayDebugBorders(aBuilder, this, set);
#endif
  resultList.AppendToTop(set.Outlines());
  // 8, 9: non-negative z-index children
  resultList.AppendToTop(set.PositionedDescendants());

  // Get the scroll clip to use for the container items that we create here.
  // If we cleared the clip, and we create multiple container items, then the
  // items we create before we restore the clip will have a different scroll
  // clip from the items we create after we restore the clip.
  const DisplayItemScrollClip* containerItemScrollClip =
    aBuilder->ClipState().CurrentAncestorScrollClipForStackingContextContents();

  /* If adding both a nsDisplayBlendContainer and a nsDisplayBlendMode to the
   * same list, the nsDisplayBlendContainer should be added first. This only
   * happens when the element creating this stacking context has mix-blend-mode
   * and also contains a child which has mix-blend-mode.
   * The nsDisplayBlendContainer must be added to the list first, so it does not
   * isolate the containing element blending as well.
   */

  if (aBuilder->ContainsBlendMode()) {
    DisplayListClipState::AutoSaveRestore blendContainerClipState(aBuilder);
    blendContainerClipState.Clear();
    resultList.AppendNewToTop(
      nsDisplayBlendContainer::CreateForMixBlendMode(aBuilder, this, &resultList,
                                                     containerItemScrollClip));
  }

  /* If there are any SVG effects, wrap the list up in an SVG effects item
   * (which also handles CSS group opacity). Note that we create an SVG effects
   * item even if resultList is empty, since a filter can produce graphical
   * output even if the element being filtered wouldn't otherwise do so.
   */
  if (usingSVGEffects) {
    MOZ_ASSERT(usingFilter ||usingMask,
               "Beside filter & mask/clip-path, what else effect do we have?");

    if (clipCapturedBy == ContainerItemType::eFilter) {
      clipState.ExitStackingContextContents(&containerItemScrollClip);
    }
    // Revert to the post-filter dirty rect.
    buildingDisplayList.SetDirtyRect(dirtyRectOutsideSVGEffects);

    // Skip all filter effects while generating glyph mask.
    if (usingFilter && !aBuilder->IsForGenerateGlyphMask()) {
      // If we are going to create a mask display item, handle opacity effect
      // in that mask display item; Otherwise, take care of opacity in this
      // filter display item.
      bool handleOpacity = !usingMask && !useOpacity;

      /* List now emptied, so add the new list to the top. */
      resultList.AppendNewToTop(
        new (aBuilder) nsDisplayFilter(aBuilder, this, &resultList,
                                       handleOpacity));
    }

    if (usingMask) {
      DisplayListClipState::AutoSaveRestore maskClipState(aBuilder);
      maskClipState.Clear();
      /* List now emptied, so add the new list to the top. */
      resultList.AppendNewToTop(
          new (aBuilder) nsDisplayMask(aBuilder, this, &resultList,
                                       !useOpacity, containerItemScrollClip));
    }

    // Also add the hoisted scroll info items. We need those for APZ scrolling
    // because nsDisplayMask items can't build active layers.
    aBuilder->ExitSVGEffectsContents();
    resultList.AppendToTop(&hoistedScrollInfoItemsStorage);
  }

  /* If the list is non-empty and there is CSS group opacity without SVG
   * effects, wrap it up in an opacity item.
   */
  if (useOpacity && !resultList.IsEmpty()) {
    // Don't clip nsDisplayOpacity items. We clip their descendants instead.
    // The clip we would set on an element with opacity would clip
    // all descendant content, but some should not be clipped.
    DisplayListClipState::AutoSaveRestore opacityClipState(aBuilder);
    opacityClipState.Clear();
    resultList.AppendNewToTop(
        new (aBuilder) nsDisplayOpacity(aBuilder, this, &resultList,
                                        containerItemScrollClip, opacityItemForEventsAndPluginsOnly));
  }

  /* If we're going to apply a transformation and don't have preserve-3d set, wrap
   * everything in an nsDisplayTransform. If there's nothing in the list, don't add
   * anything.
   *
   * For the preserve-3d case we want to individually wrap every child in the list with
   * a separate nsDisplayTransform instead. When the child is already an nsDisplayTransform,
   * we can skip this step, as the computed transform will already include our own.
   *
   * We also traverse into sublists created by nsDisplayWrapList, so that we find all the
   * correct children.
   */
  if (isTransformed && !resultList.IsEmpty() && extend3DContext) {
    // Install dummy nsDisplayTransform as a leaf containing
    // descendants not participating this 3D rendering context.
    nsDisplayList nonparticipants;
    nsDisplayList participants;
    int index = 1;

    while (nsDisplayItem* item = resultList.RemoveBottom()) {
      if (ItemParticipatesIn3DContext(this, item) && !item->GetClip().HasClip()) {
        // The frame of this item participates the same 3D context.
        WrapSeparatorTransform(aBuilder, this, dirtyRect,
                               &nonparticipants, &participants, index++);
        participants.AppendToTop(item);
      } else {
        // The frame of the item doesn't participate the current
        // context, or has no transform.
        //
        // For items participating but not transformed, they are add
        // to nonparticipants to get a separator layer for handling
        // clips, if there is, on an intermediate surface.
        // \see ContainerLayer::DefaultComputeEffectiveTransforms().
        nonparticipants.AppendToTop(item);
      }
    }
    WrapSeparatorTransform(aBuilder, this, dirtyRect,
                           &nonparticipants, &participants, index++);
    resultList.AppendToTop(&participants);
  }

  if (isTransformed && !resultList.IsEmpty()) {
    if (clipCapturedBy == ContainerItemType::eTransform) {
      // Restore clip state now so nsDisplayTransform is clipped properly.
      clipState.ExitStackingContextContents(&containerItemScrollClip);
    }
    // Revert to the dirtyrect coming in from the parent, without our transform
    // taken into account.
    buildingDisplayList.SetDirtyRect(dirtyRectOutsideTransform);
    // Revert to the outer reference frame and offset because all display
    // items we create from now on are outside the transform.
    nsPoint toOuterReferenceFrame;
    const nsIFrame* outerReferenceFrame = this;
    if (this != aBuilder->RootReferenceFrame()) {
      outerReferenceFrame =
        aBuilder->FindReferenceFrameFor(GetParent(), &toOuterReferenceFrame);
    }
    buildingDisplayList.SetReferenceFrameAndCurrentOffset(outerReferenceFrame,
      GetOffsetToCrossDoc(outerReferenceFrame));

    if (!aBuilder->IsForGenerateGlyphMask() &&
        !aBuilder->IsForPaintingSelectionBG()) {
      bool isFullyVisible =
        dirtyRectOutsideSVGEffects.Contains(GetVisualOverflowRectRelativeToSelf());
      nsDisplayTransform *transformItem =
        new (aBuilder) nsDisplayTransform(aBuilder, this,
                                          &resultList, dirtyRect, 0,
                                          isFullyVisible);
      resultList.AppendNewToTop(transformItem);
    }

    if (hasPerspective) {
      if (clipCapturedBy == ContainerItemType::ePerspective) {
        clipState.ExitStackingContextContents(&containerItemScrollClip);
      }
      resultList.AppendNewToTop(
        new (aBuilder) nsDisplayPerspective(
          aBuilder, this,
          GetContainingBlock()->GetContent()->GetPrimaryFrame(), &resultList));
    }
  }

  if (clipCapturedBy == ContainerItemType::eOwnLayerForTransformWithRoundedClip) {
    clipState.ExitStackingContextContents(&containerItemScrollClip);
    resultList.AppendNewToTop(
      new (aBuilder) nsDisplayOwnLayer(aBuilder, this, &resultList, 0,
                                       mozilla::layers::FrameMetrics::NULL_SCROLL_ID,
                                       0.0f, /* aForceActive = */ false));
  }

  /* If we have sticky positioning, wrap it in a sticky position item.
   */
  if (useFixedPosition) {
    if (clipCapturedBy == ContainerItemType::eFixedPosition) {
      clipState.ExitStackingContextContents(&containerItemScrollClip);
    }
    resultList.AppendNewToTop(
        new (aBuilder) nsDisplayFixedPosition(aBuilder, this, &resultList));
  } else if (useStickyPosition) {
    if (clipCapturedBy == ContainerItemType::eStickyPosition) {
      clipState.ExitStackingContextContents(&containerItemScrollClip);
    }
    resultList.AppendNewToTop(
        new (aBuilder) nsDisplayStickyPosition(aBuilder, this, &resultList));
  }

  /* If there's blending, wrap up the list in a blend-mode item. Note
   * that opacity can be applied before blending as the blend color is
   * not affected by foreground opacity (only background alpha).
   */

  if (useBlendMode && !resultList.IsEmpty()) {
    DisplayListClipState::AutoSaveRestore mixBlendClipState(aBuilder);
    mixBlendClipState.Clear();
    resultList.AppendNewToTop(
        new (aBuilder) nsDisplayBlendMode(aBuilder, this, &resultList,
                                          effects->mMixBlendMode,
                                          containerItemScrollClip));
  }

  CreateOwnLayerIfNeeded(aBuilder, &resultList);

  aList->AppendToTop(&resultList);
}

static nsDisplayItem*
WrapInWrapList(nsDisplayListBuilder* aBuilder,
               nsIFrame* aFrame, nsDisplayList* aList,
               const DisplayItemScrollClip* aScrollClip)
{
  nsDisplayItem* item = aList->GetBottom();
  if (!item) {
    return nullptr;
  }

  // For perspective items we want to treat the 'frame' as being the transform
  // frame that created it. This stops the transform frame from wrapping another
  // nsDisplayWrapList around it (with mismatching reference frames), but still
  // makes the perspective frame create one (so we have an atomic entry for z-index
  // sorting).
  nsIFrame *itemFrame = item->Frame();
  if (item->GetType() == nsDisplayItem::TYPE_PERSPECTIVE) {
    itemFrame = static_cast<nsDisplayPerspective*>(item)->TransformFrame();
  }

  if (item->GetAbove() || itemFrame != aFrame) {
    return new (aBuilder) nsDisplayWrapList(aBuilder, aFrame, aList, aScrollClip);
  }
  aList->RemoveBottom();
  return item;
}

void
nsIFrame::BuildDisplayListForChild(nsDisplayListBuilder*   aBuilder,
                                   nsIFrame*               aChild,
                                   const nsRect&           aDirtyRect,
                                   const nsDisplayListSet& aLists,
                                   uint32_t                aFlags) {
  // If painting is restricted to just the background of the top level frame,
  // then we have nothing to do here.
  if (aBuilder->IsBackgroundOnly())
    return;

  if (aBuilder->IsForGenerateGlyphMask() ||
      aBuilder->IsForPaintingSelectionBG()) {
    if (nsGkAtoms::textFrame != aChild->GetType() && aChild->IsLeaf()) {
      return;
    }
  }

  nsIFrame* child = aChild;
  if (child->GetStateBits() & NS_FRAME_TOO_DEEP_IN_FRAME_TREE)
    return;

  bool isSVG = (child->GetStateBits() & NS_FRAME_SVG_LAYOUT);

  // true if this is a real or pseudo stacking context
  bool pseudoStackingContext =
    (aFlags & DISPLAY_CHILD_FORCE_PSEUDO_STACKING_CONTEXT) != 0;
  if (!isSVG &&
      (aFlags & DISPLAY_CHILD_INLINE) &&
      !child->IsFrameOfType(eLineParticipant)) {
    // child is a non-inline frame in an inline context, i.e.,
    // it acts like inline-block or inline-table. Therefore it is a
    // pseudo-stacking-context.
    pseudoStackingContext = true;
  }

  // dirty rect in child-relative coordinates
  nsRect dirty = aDirtyRect - child->GetOffsetTo(this);

  nsIAtom* childType = child->GetType();
  nsDisplayListBuilder::OutOfFlowDisplayData* savedOutOfFlowData = nullptr;
  bool isPlaceholder = false;
  if (childType == nsGkAtoms::placeholderFrame) {
    isPlaceholder = true;
    nsPlaceholderFrame* placeholder = static_cast<nsPlaceholderFrame*>(child);
    child = placeholder->GetOutOfFlowFrame();
    NS_ASSERTION(child, "No out of flow frame?");
    // If 'child' is a pushed float then it's owned by a block that's not an
    // ancestor of the placeholder, and it will be painted by that block and
    // should not be painted through the placeholder.
    if (!child || nsLayoutUtils::IsPopup(child) ||
        (child->GetStateBits() & NS_FRAME_IS_PUSHED_FLOAT))
      return;
    MOZ_ASSERT(child->GetStateBits() & NS_FRAME_OUT_OF_FLOW);
    // If the out-of-flow frame is in the top layer, the viewport frame
    // will paint it. Skip it here. Note that, only out-of-flow frames
    // with this property should be skipped, because non-HTML elements
    // may stop their children from being out-of-flow. Those frames
    // should still be handled in the normal in-flow path.
    if (placeholder->GetStateBits() & PLACEHOLDER_FOR_TOPLAYER) {
      return;
    }
    // Make sure that any attempt to use childType below is disappointed. We
    // could call GetType again but since we don't currently need it, let's
    // avoid the virtual call.
    childType = nullptr;
    // Recheck NS_FRAME_TOO_DEEP_IN_FRAME_TREE
    if (child->GetStateBits() & NS_FRAME_TOO_DEEP_IN_FRAME_TREE)
      return;
    savedOutOfFlowData = nsDisplayListBuilder::GetOutOfFlowData(child);
    if (savedOutOfFlowData) {
      dirty = savedOutOfFlowData->mDirtyRect;
    } else {
      // The out-of-flow frame did not intersect the dirty area. We may still
      // need to traverse into it, since it may contain placeholders we need
      // to enter to reach other out-of-flow frames that are visible.
      dirty.SetEmpty();
    }
    pseudoStackingContext = true;
  }

  NS_ASSERTION(childType != nsGkAtoms::placeholderFrame,
               "Should have dealt with placeholders already");
  if (aBuilder->GetSelectedFramesOnly() &&
      child->IsLeaf() &&
      !aChild->IsSelected()) {
    return;
  }

  if (aBuilder->GetIncludeAllOutOfFlows() &&
      (child->GetStateBits() & NS_FRAME_OUT_OF_FLOW)) {
    dirty = child->GetVisualOverflowRect();
  } else if (!(child->GetStateBits() & NS_FRAME_FORCE_DISPLAY_LIST_DESCEND_INTO)) {
    // No need to descend into child to catch placeholders for visible
    // positioned stuff. So see if we can short-circuit frame traversal here.

    // We can stop if child's frame subtree's intersection with the
    // dirty area is empty.
    // If the child is a scrollframe that we want to ignore, then we need
    // to descend into it because its scrolled child may intersect the dirty
    // area even if the scrollframe itself doesn't.
    // There are cases where the "ignore scroll frame" on the builder is not set
    // correctly, and so we additionally want to catch cases where the child is
    // a root scrollframe and we are ignoring scrolling on the viewport.
    nsIPresShell* shell = PresContext()->PresShell();
    bool keepDescending = child == aBuilder->GetIgnoreScrollFrame() ||
        (shell->IgnoringViewportScrolling() && child == shell->GetRootScrollFrame());
    if (!keepDescending) {
      nsRect childDirty;
      if (!childDirty.IntersectRect(dirty, child->GetVisualOverflowRect()))
        return;
      // Usually we could set dirty to childDirty now but there's no
      // benefit, and it can be confusing. It can especially confuse
      // situations where we're going to ignore a scrollframe's clipping;
      // we wouldn't want to clip the dirty area to the scrollframe's
      // bounds in that case.
    }
  }

  // XXX need to have inline-block and inline-table set pseudoStackingContext
  
  const nsStyleDisplay* ourDisp = StyleDisplay();
  // REVIEW: Taken from nsBoxFrame::Paint
  // Don't paint our children if the theme object is a leaf.
  if (IsThemed(ourDisp) &&
      !PresContext()->GetTheme()->WidgetIsContainer(ourDisp->mAppearance))
    return;

  // Since we're now sure that we're adding this frame to the display list
  // (which means we're painting it, modulo occlusion), mark it as visible
  // within the displayport.
  if (aBuilder->IsPaintingToWindow() && child->TrackingVisibility()) {
    child->PresContext()->PresShell()->EnsureFrameInApproximatelyVisibleList(child);
  }

  // Child is composited if it's transformed, partially transparent, or has
  // SVG effects or a blend mode..
  const nsStyleDisplay* disp = child->StyleDisplay();
  const nsStyleEffects* effects = child->StyleEffects();
  const nsStylePosition* pos = child->StylePosition();
  bool isVisuallyAtomic = child->HasOpacity()
    || child->IsTransformed()
    // strictly speaking, 'perspective' doesn't require visual atomicity,
    // but the spec says it acts like the rest of these
    || disp->mChildPerspective.GetUnit() == eStyleUnit_Coord
    || effects->mMixBlendMode != NS_STYLE_BLEND_NORMAL
    || nsSVGIntegrationUtils::UsingEffectsForFrame(child);

  bool isPositioned = disp->IsAbsPosContainingBlock(child);
  bool isStackingContext =
    (isPositioned && (disp->IsPositionForcingStackingContext() ||
                      pos->mZIndex.GetUnit() == eStyleUnit_Integer)) ||
     (disp->mWillChangeBitField & NS_STYLE_WILL_CHANGE_STACKING_CONTEXT) ||
     disp->mIsolation != NS_STYLE_ISOLATION_AUTO ||
     isVisuallyAtomic || (aFlags & DISPLAY_CHILD_FORCE_STACKING_CONTEXT);

  if (isVisuallyAtomic || isPositioned || (!isSVG && disp->IsFloating(child)) ||
      ((effects->mClipFlags & NS_STYLE_CLIP_RECT) &&
       IsSVGContentWithCSSClip(child)) ||
       disp->mIsolation != NS_STYLE_ISOLATION_AUTO ||
       (disp->mWillChangeBitField & NS_STYLE_WILL_CHANGE_STACKING_CONTEXT) ||
      (aFlags & DISPLAY_CHILD_FORCE_STACKING_CONTEXT)) {
    // If you change this, also change IsPseudoStackingContextFromStyle()
    pseudoStackingContext = true;
  }
  NS_ASSERTION(!isStackingContext || pseudoStackingContext,
               "Stacking contexts must also be pseudo-stacking-contexts");

  nsDisplayListBuilder::AutoBuildingDisplayList
    buildingForChild(aBuilder, child, dirty, pseudoStackingContext);
  DisplayListClipState::AutoClipMultiple clipState(aBuilder);
  CheckForApzAwareEventHandlers(aBuilder, child);

  if (savedOutOfFlowData) {
    aBuilder->SetBuildingInvisibleItems(false);

    clipState.SetClipForContainingBlockDescendants(
      &savedOutOfFlowData->mContainingBlockClip);
    clipState.SetScrollClipForContainingBlockDescendants(aBuilder,
      savedOutOfFlowData->mContainingBlockScrollClip);
  } else if (GetStateBits() & NS_FRAME_FORCE_DISPLAY_LIST_DESCEND_INTO &&
             isPlaceholder) {
    NS_ASSERTION(dirty.IsEmpty(), "should have empty dirty rect");
    // Every item we build from now until we descent into an out of flow that
    // does have saved out of flow data should be invisible. This state gets
    // restored when AutoBuildingDisplayList gets out of scope.
    aBuilder->SetBuildingInvisibleItems(true);

    // If we have nested out-of-flow frames and the outer one isn't visible
    // then we won't have stored clip data for it. We can just clear the clip
    // instead since we know we won't render anything, and the inner out-of-flow
    // frame will setup the correct clip for itself.
    clipState.SetClipForContainingBlockDescendants(nullptr);
    clipState.SetScrollClipForContainingBlockDescendants(aBuilder, nullptr);
  }

  // Setup clipping for the parent's overflow:-moz-hidden-unscrollable,
  // or overflow:hidden on elements that don't support scrolling (and therefore
  // don't create nsHTML/XULScrollFrame). This clipping needs to not clip
  // anything directly rendered by the parent, only the rendering of its
  // children.
  // Don't use overflowClip to restrict the dirty rect, since some of the
  // descendants may not be clipped by it. Even if we end up with unnecessary
  // display items, they'll be pruned during ComputeVisibility.
  nsIFrame* parent = child->GetParent();
  const nsStyleDisplay* parentDisp =
    parent == this ? ourDisp : parent->StyleDisplay();
  ApplyOverflowClipping(aBuilder, parent, parentDisp, clipState);

  nsDisplayList list;
  nsDisplayList extraPositionedDescendants;
  if (isStackingContext) {
    if (effects->mMixBlendMode != NS_STYLE_BLEND_NORMAL) {
      aBuilder->SetContainsBlendMode(true);
    }
    // True stacking context.
    // For stacking contexts, BuildDisplayListForStackingContext handles
    // clipping and MarkAbsoluteFramesForDisplayList.
    child->BuildDisplayListForStackingContext(aBuilder, dirty, &list);
    aBuilder->DisplayCaret(child, dirty, &list);
  } else {
    Maybe<nsRect> clipPropClip =
      child->GetClipPropClipRect(disp, effects, child->GetSize());
    if (clipPropClip) {
      dirty.IntersectRect(dirty, *clipPropClip);
      clipState.ClipContentDescendants(
        *clipPropClip + aBuilder->ToReferenceFrame(child));
    }

    child->MarkAbsoluteFramesForDisplayList(aBuilder, dirty);

    if (aBuilder->IsBuildingLayerEventRegions()) {
      // If this frame has a different animated geometry root than its parent,
      // make sure we accumulate event regions for its layer.
      if (buildingForChild.IsAnimatedGeometryRoot() || isPositioned) {
        nsDisplayLayerEventRegions* eventRegions =
          new (aBuilder) nsDisplayLayerEventRegions(aBuilder, child);
        eventRegions->AddFrame(aBuilder, child);
        aBuilder->SetLayerEventRegions(eventRegions);

        if (isPositioned) {
          // We need this nsDisplayLayerEventRegions to be sorted with the positioned
          // elements as positioned elements will be sorted on top of normal elements
          list.AppendNewToTop(eventRegions);
        } else {
          aLists.BorderBackground()->AppendNewToTop(eventRegions);
        }
      } else {
        nsDisplayLayerEventRegions* eventRegions = aBuilder->GetLayerEventRegions();
        if (eventRegions) {
          eventRegions->AddFrame(aBuilder, child);
        }
      }
    }

    if (!pseudoStackingContext) {
      // THIS IS THE COMMON CASE.
      // Not a pseudo or real stacking context. Do the simple thing and
      // return early.

      aBuilder->AdjustWindowDraggingRegion(child);
      child->BuildDisplayList(aBuilder, dirty, aLists);
      aBuilder->DisplayCaret(child, dirty, aLists.Content());
#ifdef DEBUG
      DisplayDebugBorders(aBuilder, child, aLists);
#endif
      return;
    }

    // A pseudo-stacking context (e.g., a positioned element with z-index auto).
    // We allow positioned descendants of the child to escape to our parent
    // stacking context's positioned descendant list, because they might be
    // z-index:non-auto
    nsDisplayListCollection pseudoStack;
    aBuilder->AdjustWindowDraggingRegion(child);
    child->BuildDisplayList(aBuilder, dirty, pseudoStack);
    aBuilder->DisplayCaret(child, dirty, pseudoStack.Content());

    list.AppendToTop(pseudoStack.BorderBackground());
    list.AppendToTop(pseudoStack.BlockBorderBackgrounds());
    list.AppendToTop(pseudoStack.Floats());
    list.AppendToTop(pseudoStack.Content());
    list.AppendToTop(pseudoStack.Outlines());
    extraPositionedDescendants.AppendToTop(pseudoStack.PositionedDescendants());
#ifdef DEBUG
    DisplayDebugBorders(aBuilder, child, aLists);
#endif
  }

  buildingForChild.RestoreBuildingInvisibleItemsValue();
 
  // Clear clip rect for the construction of the items below. Since we're
  // clipping all their contents, they themselves don't need to be clipped.
  clipState.Clear();

  const DisplayItemScrollClip* containerItemScrollClip =
    aBuilder->ClipState().CurrentAncestorScrollClipForStackingContextContents();

  if (isPositioned || isVisuallyAtomic ||
      (aFlags & DISPLAY_CHILD_FORCE_STACKING_CONTEXT)) {
    // Genuine stacking contexts, and positioned pseudo-stacking-contexts,
    // go in this level.
    if (!list.IsEmpty()) {
      nsDisplayItem* item = WrapInWrapList(aBuilder, child, &list, containerItemScrollClip);
      if (isSVG) {
        aLists.Content()->AppendNewToTop(item);
      } else {
        aLists.PositionedDescendants()->AppendNewToTop(item);
      }
    }
  } else if (!isSVG && disp->IsFloating(child)) {
    if (!list.IsEmpty()) {
      aLists.Floats()->AppendNewToTop(WrapInWrapList(aBuilder, child, &list, containerItemScrollClip));
    }
  } else {
    aLists.Content()->AppendToTop(&list);
  }
  // We delay placing the positioned descendants of positioned frames to here,
  // because in the absence of z-index this is the correct order for them.
  // This doesn't affect correctness because the positioned descendants list
  // is sorted by z-order and content in BuildDisplayListForStackingContext,
  // but it means that sort routine needs to do less work.
  aLists.PositionedDescendants()->AppendToTop(&extraPositionedDescendants);
}

void
nsIFrame::MarkAbsoluteFramesForDisplayList(nsDisplayListBuilder* aBuilder,
                                           const nsRect& aDirtyRect)
{
  if (IsAbsoluteContainer()) {
    aBuilder->MarkFramesForDisplayList(this, GetAbsoluteContainingBlock()->GetChildList(), aDirtyRect);
  }
}

nsresult  
nsFrame::GetContentForEvent(WidgetEvent* aEvent,
                            nsIContent** aContent)
{
  nsIFrame* f = nsLayoutUtils::GetNonGeneratedAncestor(this);
  *aContent = f->GetContent();
  NS_IF_ADDREF(*aContent);
  return NS_OK;
}

void
nsFrame::FireDOMEvent(const nsAString& aDOMEventName, nsIContent *aContent)
{
  nsIContent* target = aContent ? aContent : mContent;

  if (target) {
    RefPtr<AsyncEventDispatcher> asyncDispatcher =
      new AsyncEventDispatcher(target, aDOMEventName, true, false);
    DebugOnly<nsresult> rv = asyncDispatcher->PostDOMEvent();
    NS_ASSERTION(NS_SUCCEEDED(rv), "AsyncEventDispatcher failed to dispatch");
  }
}

nsresult
nsFrame::HandleEvent(nsPresContext* aPresContext, 
                     WidgetGUIEvent* aEvent,
                     nsEventStatus* aEventStatus)
{

  if (aEvent->mMessage == eMouseMove) {
    // XXX If the second argument of HandleDrag() is WidgetMouseEvent,
    //     the implementation becomes simpler.
    return HandleDrag(aPresContext, aEvent, aEventStatus);
  }

  if ((aEvent->mClass == eMouseEventClass &&
       aEvent->AsMouseEvent()->button == WidgetMouseEvent::eLeftButton) ||
      aEvent->mClass == eTouchEventClass) {
    if (aEvent->mMessage == eMouseDown || aEvent->mMessage == eTouchStart) {
      HandlePress(aPresContext, aEvent, aEventStatus);
    } else if (aEvent->mMessage == eMouseUp || aEvent->mMessage == eTouchEnd) {
      HandleRelease(aPresContext, aEvent, aEventStatus);
    }
  }
  return NS_OK;
}

NS_IMETHODIMP
nsFrame::GetDataForTableSelection(const nsFrameSelection* aFrameSelection,
                                  nsIPresShell* aPresShell,
                                  WidgetMouseEvent* aMouseEvent, 
                                  nsIContent** aParentContent,
                                  int32_t* aContentOffset,
                                  int32_t* aTarget)
{
  if (!aFrameSelection || !aPresShell || !aMouseEvent || !aParentContent || !aContentOffset || !aTarget)
    return NS_ERROR_NULL_POINTER;

  *aParentContent = nullptr;
  *aContentOffset = 0;
  *aTarget = 0;

  int16_t displaySelection = aPresShell->GetSelectionFlags();

  bool selectingTableCells = aFrameSelection->GetTableCellSelection();

  // DISPLAY_ALL means we're in an editor.
  // If already in cell selection mode, 
  //  continue selecting with mouse drag or end on mouse up,
  //  or when using shift key to extend block of cells
  //  (Mouse down does normal selection unless Ctrl/Cmd is pressed)
  bool doTableSelection =
     displaySelection == nsISelectionDisplay::DISPLAY_ALL && selectingTableCells &&
     (aMouseEvent->mMessage == eMouseMove ||
      (aMouseEvent->mMessage == eMouseUp &&
       aMouseEvent->button == WidgetMouseEvent::eLeftButton) ||
      aMouseEvent->IsShift());

  if (!doTableSelection)
  {  
    // In Browser, special 'table selection' key must be pressed for table selection
    // or when just Shift is pressed and we're already in table/cell selection mode
#ifdef XP_MACOSX
    doTableSelection = aMouseEvent->IsMeta() || (aMouseEvent->IsShift() && selectingTableCells);
#else
    doTableSelection = aMouseEvent->IsControl() || (aMouseEvent->IsShift() && selectingTableCells);
#endif
  }
  if (!doTableSelection) 
    return NS_OK;

  // Get the cell frame or table frame (or parent) of the current content node
  nsIFrame *frame = this;
  bool foundCell = false;
  bool foundTable = false;

  // Get the limiting node to stop parent frame search
  nsIContent* limiter = aFrameSelection->GetLimiter();

  // If our content node is an ancestor of the limiting node,
  // we should stop the search right now.
  if (limiter && nsContentUtils::ContentIsDescendantOf(limiter, GetContent()))
    return NS_OK;

  //We don't initiate row/col selection from here now,
  //  but we may in future
  //bool selectColumn = false;
  //bool selectRow = false;
  
  while (frame)
  {
    // Check for a table cell by querying to a known CellFrame interface
    nsITableCellLayout *cellElement = do_QueryFrame(frame);
    if (cellElement)
    {
      foundCell = true;
      //TODO: If we want to use proximity to top or left border
      //      for row and column selection, this is the place to do it
      break;
    }
    else
    {
      // If not a cell, check for table
      // This will happen when starting frame is the table or child of a table,
      //  such as a row (we were inbetween cells or in table border)
      nsTableWrapperFrame *tableFrame = do_QueryFrame(frame);
      if (tableFrame)
      {
        foundTable = true;
        //TODO: How can we select row when along left table edge
        //  or select column when along top edge?
        break;
      } else {
        frame = frame->GetParent();
        // Stop if we have hit the selection's limiting content node
        if (frame && frame->GetContent() == limiter)
          break;
      }
    }
  }
  // We aren't in a cell or table
  if (!foundCell && !foundTable) return NS_OK;

  nsIContent* tableOrCellContent = frame->GetContent();
  if (!tableOrCellContent) return NS_ERROR_FAILURE;

  nsCOMPtr<nsIContent> parentContent = tableOrCellContent->GetParent();
  if (!parentContent) return NS_ERROR_FAILURE;

  int32_t offset = parentContent->IndexOf(tableOrCellContent);
  // Not likely?
  if (offset < 0) return NS_ERROR_FAILURE;

  // Everything is OK -- set the return values
  parentContent.forget(aParentContent);

  *aContentOffset = offset;

#if 0
  if (selectRow)
    *aTarget = nsISelectionPrivate::TABLESELECTION_ROW;
  else if (selectColumn)
    *aTarget = nsISelectionPrivate::TABLESELECTION_COLUMN;
  else 
#endif
  if (foundCell)
    *aTarget = nsISelectionPrivate::TABLESELECTION_CELL;
  else if (foundTable)
    *aTarget = nsISelectionPrivate::TABLESELECTION_TABLE;

  return NS_OK;
}

nsresult
nsFrame::IsSelectable(bool* aSelectable, StyleUserSelect* aSelectStyle) const
{
  if (!aSelectable) //it's ok if aSelectStyle is null
    return NS_ERROR_NULL_POINTER;

  // Like 'visibility', we must check all the parents: if a parent
  // is not selectable, none of its children is selectable.
  //
  // The -moz-all value acts similarly: if a frame has 'user-select:-moz-all',
  // all its children are selectable, even those with 'user-select:none'.
  //
  // As a result, if 'none' and '-moz-all' are not present in the frame hierarchy,
  // aSelectStyle returns the first style that is not AUTO. If these values
  // are present in the frame hierarchy, aSelectStyle returns the style of the
  // topmost parent that has either 'none' or '-moz-all'.
  //
  // The -moz-text value acts as a way to override an ancestor's all/-moz-all value.
  //
  // For instance, if the frame hierarchy is:
  //    AUTO     -> _MOZ_ALL  -> NONE -> TEXT,      the returned value is ALL
  //    AUTO     -> _MOZ_ALL  -> NONE -> _MOZ_TEXT, the returned value is TEXT.
  //    TEXT     -> NONE      -> AUTO -> _MOZ_ALL,  the returned value is TEXT
  //    _MOZ_ALL -> TEXT      -> AUTO -> AUTO,      the returned value is ALL
  //    _MOZ_ALL -> _MOZ_TEXT -> AUTO -> AUTO,      the returned value is TEXT.
  //    AUTO     -> CELL      -> TEXT -> AUTO,      the returned value is TEXT
  //
  StyleUserSelect selectStyle  = StyleUserSelect::Auto;
  nsIFrame* frame              = const_cast<nsFrame*>(this);
  bool containsEditable        = false;

  while (frame) {
    const nsStyleUIReset* userinterface = frame->StyleUIReset();
    switch (userinterface->mUserSelect) {
      case StyleUserSelect::All:
      case StyleUserSelect::MozAll:
      {
        // override the previous values
        if (selectStyle != StyleUserSelect::MozText) {
          selectStyle = userinterface->mUserSelect;
        }
        nsIContent* frameContent = frame->GetContent();
        containsEditable = frameContent &&
          frameContent->EditableDescendantCount() > 0;
        break;
      }
      default:
        // otherwise return the first value which is not 'auto'
        if (selectStyle == StyleUserSelect::Auto) {
          selectStyle = userinterface->mUserSelect;
        }
        break;
    }
    frame = nsLayoutUtils::GetParentOrPlaceholderFor(frame);
  }

  // convert internal values to standard values
  if (selectStyle == StyleUserSelect::Auto ||
      selectStyle == StyleUserSelect::MozText) {
    selectStyle = StyleUserSelect::Text;
  } else if (selectStyle == StyleUserSelect::MozAll) {
    selectStyle = StyleUserSelect::All;
  }

  // If user tries to select all of a non-editable content,
  // prevent selection if it contains editable content.
  bool allowSelection = true;
  if (selectStyle == StyleUserSelect::All) {
    allowSelection = !containsEditable;
  }

  // return stuff
  if (aSelectStyle) {
    *aSelectStyle = selectStyle;
  }

  if (mState & NS_FRAME_GENERATED_CONTENT) {
    *aSelectable = false;
  } else {
    *aSelectable = allowSelection && (selectStyle != StyleUserSelect::None);
  }

  return NS_OK;
}

/**
  * Handles the Mouse Press Event for the frame
 */
NS_IMETHODIMP
nsFrame::HandlePress(nsPresContext* aPresContext, 
                     WidgetGUIEvent* aEvent,
                     nsEventStatus* aEventStatus)
{
  NS_ENSURE_ARG_POINTER(aEventStatus);
  if (nsEventStatus_eConsumeNoDefault == *aEventStatus) {
    return NS_OK;
  }

  NS_ENSURE_ARG_POINTER(aEvent);
  if (aEvent->mClass == eTouchEventClass) {
    return NS_OK;
  }

  //We often get out of sync state issues with mousedown events that
  //get interrupted by alerts/dialogs.
  //Check with the ESM to see if we should process this one
  if (!aPresContext->EventStateManager()->EventStatusOK(aEvent)) 
    return NS_OK;

  nsresult rv;
  nsIPresShell *shell = aPresContext->GetPresShell();
  if (!shell)
    return NS_ERROR_FAILURE;

  // if we are in Navigator and the click is in a draggable node, we don't want
  // to start selection because we don't want to interfere with a potential
  // drag of said node and steal all its glory.
  int16_t isEditor = shell->GetSelectionFlags();
  //weaaak. only the editor can display frame selection not just text and images
  isEditor = isEditor == nsISelectionDisplay::DISPLAY_ALL;

  WidgetMouseEvent* mouseEvent = aEvent->AsMouseEvent();

  if (!mouseEvent->IsAlt()) {
    for (nsIContent* content = mContent; content;
         content = content->GetParent()) {
      if (nsContentUtils::ContentIsDraggable(content) &&
          !content->IsEditable()) {
        // coordinate stuff is the fix for bug #55921
        if ((mRect - GetPosition()).Contains(
              nsLayoutUtils::GetEventCoordinatesRelativeTo(mouseEvent, this))) {
          return NS_OK;
        }
      }
    }
  }

  // check whether style allows selection
  // if not, don't tell selection the mouse event even occurred.  
  bool    selectable;
  StyleUserSelect selectStyle;
  rv = IsSelectable(&selectable, &selectStyle);
  if (NS_FAILED(rv)) return rv;
  
  // check for select: none
  if (!selectable)
    return NS_OK;

  // When implementing StyleUserSelect::Element, StyleUserSelect::Elements and
  // StyleUserSelect::Toggle, need to change this logic
  bool useFrameSelection = (selectStyle == StyleUserSelect::Text);

  // If the mouse is dragged outside the nearest enclosing scrollable area
  // while making a selection, the area will be scrolled. To do this, capture
  // the mouse on the nearest scrollable frame. If there isn't a scrollable
  // frame, or something else is already capturing the mouse, there's no
  // reason to capture.
  bool hasCapturedContent = false;
  if (!nsIPresShell::GetCapturingContent()) {
    nsIScrollableFrame* scrollFrame =
      nsLayoutUtils::GetNearestScrollableFrame(this,
        nsLayoutUtils::SCROLLABLE_SAME_DOC |
        nsLayoutUtils::SCROLLABLE_INCLUDE_HIDDEN);
    if (scrollFrame) {
      nsIFrame* capturingFrame = do_QueryFrame(scrollFrame);
      nsIPresShell::SetCapturingContent(capturingFrame->GetContent(),
                                        CAPTURE_IGNOREALLOWED);
      hasCapturedContent = true;
    }
  }

  // XXX This is screwy; it really should use the selection frame, not the
  // event frame
  const nsFrameSelection* frameselection = nullptr;
  if (useFrameSelection)
    frameselection = GetConstFrameSelection();
  else
    frameselection = shell->ConstFrameSelection();

  if (!frameselection || frameselection->GetDisplaySelection() == nsISelectionController::SELECTION_OFF)
    return NS_OK;//nothing to do we cannot affect selection from here

#ifdef XP_MACOSX
  if (mouseEvent->IsControl())
    return NS_OK;//short circuit. hard coded for mac due to time restraints.
  bool control = mouseEvent->IsMeta();
#else
  bool control = mouseEvent->IsControl();
#endif

  RefPtr<nsFrameSelection> fc = const_cast<nsFrameSelection*>(frameselection);
  if (mouseEvent->mClickCount > 1) {
    // These methods aren't const but can't actually delete anything,
    // so no need for nsWeakFrame.
    fc->SetDragState(true);
    fc->SetMouseDoubleDown(true);
    return HandleMultiplePress(aPresContext, mouseEvent, aEventStatus, control);
  }

  nsPoint pt = nsLayoutUtils::GetEventCoordinatesRelativeTo(mouseEvent, this);
  ContentOffsets offsets = GetContentOffsetsFromPoint(pt, SKIP_HIDDEN);

  if (!offsets.content)
    return NS_ERROR_FAILURE;

  // On touchables devices, touch the screen is usually a pan action,
  // so let's reposition the caret if needed but do not select text
  // if the touch did not happen over an editable element.  Otherwise,
  // let the user move the caret by tapping and dragging.
  if (!offsets.content->IsEditable() &&
      Preferences::GetBool("browser.ignoreNativeFrameTextSelection", false)) {
    // On touchables devices, mouse events are generated if the gesture is a tap.
    // Such events are never going to generate a drag action, so let's release
    // captured content if any.
    if (hasCapturedContent) {
      nsIPresShell::SetCapturingContent(nullptr, 0);
    }

    return fc->HandleClick(offsets.content, offsets.StartOffset(),
                           offsets.EndOffset(), false, false,
                           offsets.associate);
  }

  // Let Ctrl/Cmd+mouse down do table selection instead of drag initiation
  nsCOMPtr<nsIContent>parentContent;
  int32_t  contentOffset;
  int32_t target;
  rv = GetDataForTableSelection(frameselection, shell, mouseEvent,
                                getter_AddRefs(parentContent), &contentOffset,
                                &target);
  if (NS_SUCCEEDED(rv) && parentContent)
  {
    fc->SetDragState(true);
    return fc->HandleTableSelection(parentContent, contentOffset, target,
                                    mouseEvent);
  }

  fc->SetDelayedCaretData(0);

  // Check if any part of this frame is selected, and if the
  // user clicked inside the selected region. If so, we delay
  // starting a new selection since the user may be trying to
  // drag the selected region to some other app.

  SelectionDetails *details = 0;
  if (GetContent()->IsSelectionDescendant())
  {
    bool inSelection = false;
    details = frameselection->LookUpSelection(offsets.content, 0,
        offsets.EndOffset(), false);

    //
    // If there are any details, check to see if the user clicked
    // within any selected region of the frame.
    //

    SelectionDetails *curDetail = details;

    while (curDetail)
    {
      //
      // If the user clicked inside a selection, then just
      // return without doing anything. We will handle placing
      // the caret later on when the mouse is released. We ignore
      // the spellcheck, find and url formatting selections.
      //
      if (curDetail->mSelectionType != SelectionType::eSpellCheck &&
          curDetail->mSelectionType != SelectionType::eFind &&
          curDetail->mSelectionType != SelectionType::eURLSecondary &&
          curDetail->mSelectionType != SelectionType::eURLStrikeout &&
          curDetail->mStart <= offsets.StartOffset() &&
          offsets.EndOffset() <= curDetail->mEnd)
      {
        inSelection = true;
      }

      SelectionDetails *nextDetail = curDetail->mNext;
      delete curDetail;
      curDetail = nextDetail;
    }

    if (inSelection) {
      fc->SetDragState(false);
      fc->SetDelayedCaretData(mouseEvent);
      return NS_OK;
    }
  }

  fc->SetDragState(true);

  // Do not touch any nsFrame members after this point without adding
  // weakFrame checks.
  rv = fc->HandleClick(offsets.content, offsets.StartOffset(),
                       offsets.EndOffset(), mouseEvent->IsShift(), control,
                       offsets.associate);

  if (NS_FAILED(rv))
    return rv;

  if (offsets.offset != offsets.secondaryOffset)
    fc->MaintainSelection();

  if (isEditor && !mouseEvent->IsShift() &&
      (offsets.EndOffset() - offsets.StartOffset()) == 1)
  {
    // A single node is selected and we aren't extending an existing
    // selection, which means the user clicked directly on an object (either
    // -moz-user-select: all or a non-text node without children).
    // Therefore, disable selection extension during mouse moves.
    // XXX This is a bit hacky; shouldn't editor be able to deal with this?
    fc->SetDragState(false);
  }

  return rv;
}

/*
 * SelectByTypeAtPoint
 *
 * Search for selectable content at point and attempt to select
 * based on the start and end selection behaviours.
 *
 * @param aPresContext Presentation context
 * @param aPoint Point at which selection will occur. Coordinates
 * should be relaitve to this frame.
 * @param aBeginAmountType, aEndAmountType Selection behavior, see
 * nsIFrame for definitions.
 * @param aSelectFlags Selection flags defined in nsFame.h.
 * @return success or failure at finding suitable content to select.
 */
nsresult
nsFrame::SelectByTypeAtPoint(nsPresContext* aPresContext,
                             const nsPoint& aPoint,
                             nsSelectionAmount aBeginAmountType,
                             nsSelectionAmount aEndAmountType,
                             uint32_t aSelectFlags)
{
  NS_ENSURE_ARG_POINTER(aPresContext);

  // No point in selecting if selection is turned off
  if (DisplaySelection(aPresContext) == nsISelectionController::SELECTION_OFF)
    return NS_OK;

  ContentOffsets offsets = GetContentOffsetsFromPoint(aPoint, SKIP_HIDDEN);
  if (!offsets.content)
    return NS_ERROR_FAILURE;

  int32_t offset;
  const nsFrameSelection* frameSelection =
    PresContext()->GetPresShell()->ConstFrameSelection();
  nsIFrame* theFrame = frameSelection->
    GetFrameForNodeOffset(offsets.content, offsets.offset,
                          offsets.associate, &offset);
  if (!theFrame)
    return NS_ERROR_FAILURE;

  nsFrame* frame = static_cast<nsFrame*>(theFrame);
  return frame->PeekBackwardAndForward(aBeginAmountType, aEndAmountType, offset,
                                       aBeginAmountType != eSelectWord,
                                       aSelectFlags);
}

/**
  * Multiple Mouse Press -- line or paragraph selection -- for the frame.
  * Wouldn't it be nice if this didn't have to be hardwired into Frame code?
 */
NS_IMETHODIMP
nsFrame::HandleMultiplePress(nsPresContext* aPresContext,
                             WidgetGUIEvent* aEvent,
                             nsEventStatus* aEventStatus,
                             bool aControlHeld)
{
  NS_ENSURE_ARG_POINTER(aEvent);
  NS_ENSURE_ARG_POINTER(aEventStatus);

  if (nsEventStatus_eConsumeNoDefault == *aEventStatus ||
      DisplaySelection(aPresContext) == nsISelectionController::SELECTION_OFF) {
    return NS_OK;
  }

  // Find out whether we're doing line or paragraph selection.
  // If browser.triple_click_selects_paragraph is true, triple-click selects paragraph.
  // Otherwise, triple-click selects line, and quadruple-click selects paragraph
  // (on platforms that support quadruple-click).
  nsSelectionAmount beginAmount, endAmount;
  WidgetMouseEvent* mouseEvent = aEvent->AsMouseEvent();
  if (!mouseEvent) {
    return NS_OK;
  }

  if (mouseEvent->mClickCount == 4) {
    beginAmount = endAmount = eSelectParagraph;
  } else if (mouseEvent->mClickCount == 3) {
    if (Preferences::GetBool("browser.triple_click_selects_paragraph")) {
      beginAmount = endAmount = eSelectParagraph;
    } else {
      beginAmount = eSelectBeginLine;
      endAmount = eSelectEndLine;
    }
  } else if (mouseEvent->mClickCount == 2) {
    // We only want inline frames; PeekBackwardAndForward dislikes blocks
    beginAmount = endAmount = eSelectWord;
  } else {
    return NS_OK;
  }

  nsPoint relPoint =
    nsLayoutUtils::GetEventCoordinatesRelativeTo(mouseEvent, this);
  return SelectByTypeAtPoint(aPresContext, relPoint, beginAmount, endAmount,
                             (aControlHeld ? SELECT_ACCUMULATE : 0));
}

nsresult
nsFrame::PeekBackwardAndForward(nsSelectionAmount aAmountBack,
                                nsSelectionAmount aAmountForward,
                                int32_t aStartPos,
                                bool aJumpLines,
                                uint32_t aSelectFlags)
{
  nsIFrame* baseFrame = this;
  int32_t baseOffset = aStartPos;
  nsresult rv;

  if (aAmountBack == eSelectWord) {
    // To avoid selecting the previous word when at start of word,
    // first move one character forward.
    nsPeekOffsetStruct pos(eSelectCharacter,
                           eDirNext,
                           aStartPos,
                           nsPoint(0, 0),
                           aJumpLines,
                           true,  //limit on scrolled views
                           false,
                           false,
                           false);
    rv = PeekOffset(&pos);
    if (NS_SUCCEEDED(rv)) {
      baseFrame = pos.mResultFrame;
      baseOffset = pos.mContentOffset;
    }
  }

  // Use peek offset one way then the other:
  nsPeekOffsetStruct startpos(aAmountBack,
                              eDirPrevious,
                              baseOffset,
                              nsPoint(0, 0),
                              aJumpLines,
                              true,  //limit on scrolled views
                              false,
                              false,
                              false);
  rv = baseFrame->PeekOffset(&startpos);
  if (NS_FAILED(rv))
    return rv;

  nsPeekOffsetStruct endpos(aAmountForward,
                            eDirNext,
                            aStartPos,
                            nsPoint(0, 0),
                            aJumpLines,
                            true,  //limit on scrolled views
                            false,
                            false,
                            false);
  rv = PeekOffset(&endpos);
  if (NS_FAILED(rv))
    return rv;

  // Keep frameSelection alive.
  RefPtr<nsFrameSelection> frameSelection = GetFrameSelection();

  rv = frameSelection->HandleClick(startpos.mResultContent,
                                   startpos.mContentOffset, startpos.mContentOffset,
                                   false, (aSelectFlags & SELECT_ACCUMULATE),
                                   CARET_ASSOCIATE_AFTER);
  if (NS_FAILED(rv))
    return rv;

  rv = frameSelection->HandleClick(endpos.mResultContent,
                                   endpos.mContentOffset, endpos.mContentOffset,
                                   true, false,
                                   CARET_ASSOCIATE_BEFORE);
  if (NS_FAILED(rv))
    return rv;

  // maintain selection
  return frameSelection->MaintainSelection(aAmountBack);
}

NS_IMETHODIMP nsFrame::HandleDrag(nsPresContext* aPresContext, 
                                  WidgetGUIEvent* aEvent,
                                  nsEventStatus* aEventStatus)
{
  MOZ_ASSERT(aEvent->mClass == eMouseEventClass,
             "HandleDrag can only handle mouse event");

  RefPtr<nsFrameSelection> frameselection = GetFrameSelection();
  bool mouseDown = frameselection->GetDragState();
  if (!mouseDown) {
    return NS_OK;
  }

  nsIFrame* scrollbar =
    nsLayoutUtils::GetClosestFrameOfType(this, nsGkAtoms::scrollbarFrame);
  if (!scrollbar) {
    // XXX Do we really need to exclude non-selectable content here?
    // GetContentOffsetsFromPoint can handle it just fine, although some
    // other stuff might not like it.
    // NOTE: DisplaySelection() returns SELECTION_OFF for non-selectable frames.
    if (DisplaySelection(aPresContext) == nsISelectionController::SELECTION_OFF) {
      return NS_OK;
    }
  }

  frameselection->StopAutoScrollTimer();

  // Check if we are dragging in a table cell
  nsCOMPtr<nsIContent> parentContent;
  int32_t contentOffset;
  int32_t target;
  WidgetMouseEvent* mouseEvent = aEvent->AsMouseEvent();
  nsCOMPtr<nsIPresShell> presShell = aPresContext->PresShell();
  nsresult result;
  result = GetDataForTableSelection(frameselection, presShell, mouseEvent,
                                    getter_AddRefs(parentContent),
                                    &contentOffset, &target);      

  nsWeakFrame weakThis = this;
  if (NS_SUCCEEDED(result) && parentContent) {
    frameselection->HandleTableSelection(parentContent, contentOffset, target,
                                         mouseEvent);
  } else {
    nsPoint pt = nsLayoutUtils::GetEventCoordinatesRelativeTo(mouseEvent, this);
    frameselection->HandleDrag(this, pt);
  }

  // The frameselection object notifies selection listeners synchronously above
  // which might have killed us.
  if (!weakThis.IsAlive()) {
    return NS_OK;
  }

  // get the nearest scrollframe
  nsIScrollableFrame* scrollFrame =
    nsLayoutUtils::GetNearestScrollableFrame(this,
        nsLayoutUtils::SCROLLABLE_SAME_DOC |
        nsLayoutUtils::SCROLLABLE_INCLUDE_HIDDEN);

  if (scrollFrame) {
    nsIFrame* capturingFrame = scrollFrame->GetScrolledFrame();
    if (capturingFrame) {
      nsPoint pt = nsLayoutUtils::GetEventCoordinatesRelativeTo(mouseEvent,
                                                                capturingFrame);
      frameselection->StartAutoScrollTimer(capturingFrame, pt, 30);
    }
  }

  return NS_OK;
}

/**
 * This static method handles part of the nsFrame::HandleRelease in a way
 * which doesn't rely on the nsFrame object to stay alive.
 */
static nsresult
HandleFrameSelection(nsFrameSelection*         aFrameSelection,
                     nsIFrame::ContentOffsets& aOffsets,
                     bool                      aHandleTableSel,
                     int32_t                   aContentOffsetForTableSel,
                     int32_t                   aTargetForTableSel,
                     nsIContent*               aParentContentForTableSel,
                     WidgetGUIEvent*           aEvent,
                     nsEventStatus*            aEventStatus)
{
  if (!aFrameSelection) {
    return NS_OK;
  }

  nsresult rv = NS_OK;

  if (nsEventStatus_eConsumeNoDefault != *aEventStatus) {
    if (!aHandleTableSel) {
      if (!aOffsets.content || !aFrameSelection->HasDelayedCaretData()) {
        return NS_ERROR_FAILURE;
      }

      // We are doing this to simulate what we would have done on HandlePress.
      // We didn't do it there to give the user an opportunity to drag
      // the text, but since they didn't drag, we want to place the
      // caret.
      // However, we'll use the mouse position from the release, since:
      //  * it's easier
      //  * that's the normal click position to use (although really, in
      //    the normal case, small movements that don't count as a drag
      //    can do selection)
      aFrameSelection->SetDragState(true);

      rv = aFrameSelection->HandleClick(aOffsets.content,
                                        aOffsets.StartOffset(),
                                        aOffsets.EndOffset(),
                                        aFrameSelection->IsShiftDownInDelayedCaretData(),
                                        false,
                                        aOffsets.associate);
      if (NS_FAILED(rv)) {
        return rv;
      }
    } else if (aParentContentForTableSel) {
      aFrameSelection->SetDragState(false);
      rv = aFrameSelection->HandleTableSelection(
                              aParentContentForTableSel,
                              aContentOffsetForTableSel,
                              aTargetForTableSel,
                              aEvent->AsMouseEvent());
      if (NS_FAILED(rv)) {
        return rv;
      }
    }
    aFrameSelection->SetDelayedCaretData(0);
  }

  aFrameSelection->SetDragState(false);
  aFrameSelection->StopAutoScrollTimer();

  return NS_OK;
}

NS_IMETHODIMP nsFrame::HandleRelease(nsPresContext* aPresContext,
                                     WidgetGUIEvent* aEvent,
                                     nsEventStatus* aEventStatus)
{
  if (aEvent->mClass != eMouseEventClass) {
    return NS_OK;
  }

  nsIFrame* activeFrame = GetActiveSelectionFrame(aPresContext, this);

  nsCOMPtr<nsIContent> captureContent = nsIPresShell::GetCapturingContent();

  // We can unconditionally stop capturing because
  // we should never be capturing when the mouse button is up
  nsIPresShell::SetCapturingContent(nullptr, 0);

  bool selectionOff =
    (DisplaySelection(aPresContext) == nsISelectionController::SELECTION_OFF);

  RefPtr<nsFrameSelection> frameselection;
  ContentOffsets offsets;
  nsCOMPtr<nsIContent> parentContent;
  int32_t contentOffsetForTableSel = 0;
  int32_t targetForTableSel = 0;
  bool handleTableSelection = true;

  if (!selectionOff) {
    frameselection = GetFrameSelection();
    if (nsEventStatus_eConsumeNoDefault != *aEventStatus && frameselection) {
      // Check if the frameselection recorded the mouse going down.
      // If not, the user must have clicked in a part of the selection.
      // Place the caret before continuing!

      if (frameselection->MouseDownRecorded()) {
        nsPoint pt = nsLayoutUtils::GetEventCoordinatesRelativeTo(aEvent, this);
        offsets = GetContentOffsetsFromPoint(pt, SKIP_HIDDEN);
        handleTableSelection = false;
      } else {
        GetDataForTableSelection(frameselection, PresContext()->PresShell(),
                                 aEvent->AsMouseEvent(),
                                 getter_AddRefs(parentContent),
                                 &contentOffsetForTableSel,
                                 &targetForTableSel);
      }
    }
  }

  // We might be capturing in some other document and the event just happened to
  // trickle down here. Make sure that document's frame selection is notified.
  // Note, this may cause the current nsFrame object to be deleted, bug 336592.
  RefPtr<nsFrameSelection> frameSelection;
  if (activeFrame != this &&
      static_cast<nsFrame*>(activeFrame)->DisplaySelection(activeFrame->PresContext())
        != nsISelectionController::SELECTION_OFF) {
      frameSelection = activeFrame->GetFrameSelection();
  }

  // Also check the selection of the capturing content which might be in a
  // different document.
  if (!frameSelection && captureContent) {
    nsIDocument* doc = captureContent->GetUncomposedDoc();
    if (doc) {
      nsIPresShell* capturingShell = doc->GetShell();
      if (capturingShell && capturingShell != PresContext()->GetPresShell()) {
        frameSelection = capturingShell->FrameSelection();
      }
    }
  }

  if (frameSelection) {
    frameSelection->SetDragState(false);
    frameSelection->StopAutoScrollTimer();
    nsIScrollableFrame* scrollFrame =
      nsLayoutUtils::GetNearestScrollableFrame(this,
        nsLayoutUtils::SCROLLABLE_SAME_DOC |
        nsLayoutUtils::SCROLLABLE_INCLUDE_HIDDEN);
    if (scrollFrame) {
      // Perform any additional scrolling needed to maintain CSS snap point
      // requirements when autoscrolling is over.
      scrollFrame->ScrollSnap();
    }
  }

  // Do not call any methods of the current object after this point!!!
  // The object is perhaps dead!

  return selectionOff
    ? NS_OK
    : HandleFrameSelection(frameselection, offsets, handleTableSelection,
                           contentOffsetForTableSel, targetForTableSel,
                           parentContent, aEvent, aEventStatus);
}

struct MOZ_STACK_CLASS FrameContentRange {
  FrameContentRange(nsIContent* aContent, int32_t aStart, int32_t aEnd) :
    content(aContent), start(aStart), end(aEnd) { }
  nsCOMPtr<nsIContent> content;
  int32_t start;
  int32_t end;
};

// Retrieve the content offsets of a frame
static FrameContentRange GetRangeForFrame(nsIFrame* aFrame) {
  nsCOMPtr<nsIContent> content, parent;
  content = aFrame->GetContent();
  if (!content) {
    NS_WARNING("Frame has no content");
    return FrameContentRange(nullptr, -1, -1);
  }
  nsIAtom* type = aFrame->GetType();
  if (type == nsGkAtoms::textFrame) {
    int32_t offset, offsetEnd;
    aFrame->GetOffsets(offset, offsetEnd);
    return FrameContentRange(content, offset, offsetEnd);
  }
  if (type == nsGkAtoms::brFrame) {
    parent = content->GetParent();
    int32_t beginOffset = parent->IndexOf(content);
    return FrameContentRange(parent, beginOffset, beginOffset);
  }
  // Loop to deal with anonymous content, which has no index; this loop
  // probably won't run more than twice under normal conditions
  do {
    parent  = content->GetParent();
    if (parent) {
      int32_t beginOffset = parent->IndexOf(content);
      if (beginOffset >= 0)
        return FrameContentRange(parent, beginOffset, beginOffset + 1);
      content = parent;
    }
  } while (parent);

  // The root content node must act differently
  return FrameContentRange(content, 0, content->GetChildCount());
}

// The FrameTarget represents the closest frame to a point that can be selected
// The frame is the frame represented, frameEdge says whether one end of the
// frame is the result (in which case different handling is needed), and
// afterFrame says which end is repersented if frameEdge is true
struct FrameTarget {
  FrameTarget(nsIFrame* aFrame, bool aFrameEdge, bool aAfterFrame,
              bool aEmptyBlock = false) :
    frame(aFrame), frameEdge(aFrameEdge), afterFrame(aAfterFrame),
    emptyBlock(aEmptyBlock) { }
  static FrameTarget Null() {
    return FrameTarget(nullptr, false, false);
  }
  bool IsNull() {
    return !frame;
  }
  nsIFrame* frame;
  bool frameEdge;
  bool afterFrame;
  bool emptyBlock;
};

// See function implementation for information
static FrameTarget GetSelectionClosestFrame(nsIFrame* aFrame, nsPoint aPoint,
                                            uint32_t aFlags);

static bool SelfIsSelectable(nsIFrame* aFrame, uint32_t aFlags)
{
  if ((aFlags & nsIFrame::SKIP_HIDDEN) &&
      !aFrame->StyleVisibility()->IsVisible()) {
    return false;
  }
  return !aFrame->IsGeneratedContentFrame() &&
    aFrame->StyleUIReset()->mUserSelect != StyleUserSelect::None;
}

static bool SelectionDescendToKids(nsIFrame* aFrame) {
  StyleUserSelect style = aFrame->StyleUIReset()->mUserSelect;
  nsIFrame* parent = aFrame->GetParent();
  // If we are only near (not directly over) then don't traverse
  // frames with independent selection (e.g. text and list controls)
  // unless we're already inside such a frame (see bug 268497).  Note that this
  // prevents any of the users of this method from entering form controls.
  // XXX We might want some way to allow using the up-arrow to go into a form
  // control, but the focus didn't work right anyway; it'd probably be enough
  // if the left and right arrows could enter textboxes (which I don't believe
  // they can at the moment)
  return !aFrame->IsGeneratedContentFrame() &&
         style != StyleUserSelect::All  &&
         style != StyleUserSelect::None &&
         ((parent->GetStateBits() & NS_FRAME_INDEPENDENT_SELECTION) ||
          !(aFrame->GetStateBits() & NS_FRAME_INDEPENDENT_SELECTION));
}

static FrameTarget GetSelectionClosestFrameForChild(nsIFrame* aChild,
                                                    nsPoint aPoint,
                                                    uint32_t aFlags)
{
  nsIFrame* parent = aChild->GetParent();
  if (SelectionDescendToKids(aChild)) {
    nsPoint pt = aPoint - aChild->GetOffsetTo(parent);
    return GetSelectionClosestFrame(aChild, pt, aFlags);
  }
  return FrameTarget(aChild, false, false);
}

// When the cursor needs to be at the beginning of a block, it shouldn't be
// before the first child.  A click on a block whose first child is a block
// should put the cursor in the child.  The cursor shouldn't be between the
// blocks, because that's not where it's expected.
// Note that this method is guaranteed to succeed.
static FrameTarget DrillDownToSelectionFrame(nsIFrame* aFrame,
                                             bool aEndFrame, uint32_t aFlags) {
  if (SelectionDescendToKids(aFrame)) {
    nsIFrame* result = nullptr;
    nsIFrame *frame = aFrame->PrincipalChildList().FirstChild();
    if (!aEndFrame) {
      while (frame && (!SelfIsSelectable(frame, aFlags) ||
                        frame->IsEmpty()))
        frame = frame->GetNextSibling();
      if (frame)
        result = frame;
    } else {
      // Because the frame tree is singly linked, to find the last frame,
      // we have to iterate through all the frames
      // XXX I have a feeling this could be slow for long blocks, although
      //     I can't find any slowdowns
      while (frame) {
        if (!frame->IsEmpty() && SelfIsSelectable(frame, aFlags))
          result = frame;
        frame = frame->GetNextSibling();
      }
    }
    if (result)
      return DrillDownToSelectionFrame(result, aEndFrame, aFlags);
  }
  // If the current frame has no targetable children, target the current frame
  return FrameTarget(aFrame, true, aEndFrame);
}

// This method finds the closest valid FrameTarget on a given line; if there is
// no valid FrameTarget on the line, it returns a null FrameTarget
static FrameTarget GetSelectionClosestFrameForLine(
                      nsBlockFrame* aParent,
                      nsBlockFrame::LineIterator aLine,
                      nsPoint aPoint,
                      uint32_t aFlags)
{
  nsIFrame *frame = aLine->mFirstChild;
  // Account for end of lines (any iterator from the block is valid)
  if (aLine == aParent->LinesEnd())
    return DrillDownToSelectionFrame(aParent, true, aFlags);
  nsIFrame *closestFromIStart = nullptr, *closestFromIEnd = nullptr;
  nscoord closestIStart = aLine->IStart(), closestIEnd = aLine->IEnd();
  WritingMode wm = aLine->mWritingMode;
  LogicalPoint pt(wm, aPoint, aLine->mContainerSize);
  bool canSkipBr = false;
  for (int32_t n = aLine->GetChildCount(); n;
       --n, frame = frame->GetNextSibling()) {
    // Skip brFrames. Can only skip if the line contains at least
    // one selectable and non-empty frame before
    if (!SelfIsSelectable(frame, aFlags) || frame->IsEmpty() ||
        (canSkipBr && frame->GetType() == nsGkAtoms::brFrame)) {
      continue;
    }
    canSkipBr = true;
    LogicalRect frameRect = LogicalRect(wm, frame->GetRect(),
                                        aLine->mContainerSize);
    if (pt.I(wm) >= frameRect.IStart(wm)) {
      if (pt.I(wm) < frameRect.IEnd(wm)) {
        return GetSelectionClosestFrameForChild(frame, aPoint, aFlags);
      }
      if (frameRect.IEnd(wm) >= closestIStart) {
        closestFromIStart = frame;
        closestIStart = frameRect.IEnd(wm);
      }
    } else {
      if (frameRect.IStart(wm) <= closestIEnd) {
        closestFromIEnd = frame;
        closestIEnd = frameRect.IStart(wm);
      }
    }
  }
  if (!closestFromIStart && !closestFromIEnd) {
    // We should only get here if there are no selectable frames on a line
    // XXX Do we need more elaborate handling here?
    return FrameTarget::Null();
  }
  if (closestFromIStart &&
      (!closestFromIEnd ||
       (abs(pt.I(wm) - closestIStart) <= abs(pt.I(wm) - closestIEnd)))) {
    return GetSelectionClosestFrameForChild(closestFromIStart, aPoint,
                                            aFlags);
  }
  return GetSelectionClosestFrameForChild(closestFromIEnd, aPoint, aFlags);
}

// This method is for the special handling we do for block frames; they're
// special because they represent paragraphs and because they are organized
// into lines, which have bounds that are not stored elsewhere in the
// frame tree.  Returns a null FrameTarget for frames which are not
// blocks or blocks with no lines except editable one.
static FrameTarget GetSelectionClosestFrameForBlock(nsIFrame* aFrame,
                                                    nsPoint aPoint,
                                                    uint32_t aFlags)
{
  nsBlockFrame* bf = nsLayoutUtils::GetAsBlock(aFrame); // used only for QI
  if (!bf)
    return FrameTarget::Null();

  // This code searches for the correct line
  nsBlockFrame::LineIterator firstLine = bf->LinesBegin();
  nsBlockFrame::LineIterator end = bf->LinesEnd();
  if (firstLine == end) {
    nsIContent *blockContent = aFrame->GetContent();
    if (blockContent) {
      // Return with empty flag true.
      return FrameTarget(aFrame, false, false, true);
    }
    return FrameTarget::Null();
  }
  nsBlockFrame::LineIterator curLine = firstLine;
  nsBlockFrame::LineIterator closestLine = end;
  // Convert aPoint into a LogicalPoint in the writing-mode of this block
  WritingMode wm = curLine->mWritingMode;
  LogicalPoint pt(wm, aPoint, curLine->mContainerSize);
  while (curLine != end) {
    // Check to see if our point lies within the line's block-direction bounds
    nscoord BCoord = pt.B(wm) - curLine->BStart();
    nscoord BSize = curLine->BSize();
    if (BCoord >= 0 && BCoord < BSize) {
      closestLine = curLine;
      break; // We found the line; stop looking
    }
    if (BCoord < 0)
      break;
    ++curLine;
  }

  if (closestLine == end) {
    nsBlockFrame::LineIterator prevLine = curLine.prev();
    nsBlockFrame::LineIterator nextLine = curLine;
    // Avoid empty lines
    while (nextLine != end && nextLine->IsEmpty())
      ++nextLine;
    while (prevLine != end && prevLine->IsEmpty())
      --prevLine;

    // This hidden pref dictates whether a point above or below all lines comes
    // up with a line or the beginning or end of the frame; 0 on Windows,
    // 1 on other platforms by default at the writing of this code
    int32_t dragOutOfFrame =
      Preferences::GetInt("browser.drag_out_of_frame_style");

    if (prevLine == end) {
      if (dragOutOfFrame == 1 || nextLine == end)
        return DrillDownToSelectionFrame(aFrame, false, aFlags);
      closestLine = nextLine;
    } else if (nextLine == end) {
      if (dragOutOfFrame == 1)
        return DrillDownToSelectionFrame(aFrame, true, aFlags);
      closestLine = prevLine;
    } else { // Figure out which line is closer
      if (pt.B(wm) - prevLine->BEnd() < nextLine->BStart() - pt.B(wm))
        closestLine = prevLine;
      else
        closestLine = nextLine;
    }
  }

  do {
    FrameTarget target = GetSelectionClosestFrameForLine(bf, closestLine,
                                                         aPoint, aFlags);
    if (!target.IsNull())
      return target;
    ++closestLine;
  } while (closestLine != end);
  // Fall back to just targeting the last targetable place
  return DrillDownToSelectionFrame(aFrame, true, aFlags);
}

// GetSelectionClosestFrame is the helper function that calculates the closest
// frame to the given point.
// It doesn't completely account for offset styles, so needs to be used in
// restricted environments.
// Cannot handle overlapping frames correctly, so it should receive the output
// of GetFrameForPoint
// Guaranteed to return a valid FrameTarget
static FrameTarget GetSelectionClosestFrame(nsIFrame* aFrame, nsPoint aPoint,
                                            uint32_t aFlags)
{
  {
    // Handle blocks; if the frame isn't a block, the method fails
    FrameTarget target = GetSelectionClosestFrameForBlock(aFrame, aPoint, aFlags);
    if (!target.IsNull())
      return target;
  }

  nsIFrame *kid = aFrame->PrincipalChildList().FirstChild();

  if (kid) {
    // Go through all the child frames to find the closest one
    nsIFrame::FrameWithDistance closest = { nullptr, nscoord_MAX, nscoord_MAX };
    for (; kid; kid = kid->GetNextSibling()) {
      if (!SelfIsSelectable(kid, aFlags) || kid->IsEmpty())
        continue;

      kid->FindCloserFrameForSelection(aPoint, &closest);
    }
    if (closest.mFrame) {
      if (closest.mFrame->IsSVGText())
        return FrameTarget(closest.mFrame, false, false);
      return GetSelectionClosestFrameForChild(closest.mFrame, aPoint, aFlags);
    }
  }
  return FrameTarget(aFrame, false, false);
}

nsIFrame::ContentOffsets OffsetsForSingleFrame(nsIFrame* aFrame, nsPoint aPoint)
{
  nsIFrame::ContentOffsets offsets;
  FrameContentRange range = GetRangeForFrame(aFrame);
  offsets.content = range.content;
  // If there are continuations (meaning it's not one rectangle), this is the
  // best this function can do
  if (aFrame->GetNextContinuation() || aFrame->GetPrevContinuation()) {
    offsets.offset = range.start;
    offsets.secondaryOffset = range.end;
    offsets.associate = CARET_ASSOCIATE_AFTER;
    return offsets;
  }

  // Figure out whether the offsets should be over, after, or before the frame
  nsRect rect(nsPoint(0, 0), aFrame->GetSize());

  bool isBlock = aFrame->GetDisplay() != StyleDisplay::Inline;
  bool isRtl = (aFrame->StyleVisibility()->mDirection == NS_STYLE_DIRECTION_RTL);
  if ((isBlock && rect.y < aPoint.y) ||
      (!isBlock && ((isRtl  && rect.x + rect.width / 2 > aPoint.x) || 
                    (!isRtl && rect.x + rect.width / 2 < aPoint.x)))) {
    offsets.offset = range.end;
    if (rect.Contains(aPoint))
      offsets.secondaryOffset = range.start;
    else
      offsets.secondaryOffset = range.end;
  } else {
    offsets.offset = range.start;
    if (rect.Contains(aPoint))
      offsets.secondaryOffset = range.end;
    else
      offsets.secondaryOffset = range.start;
  }
  offsets.associate =
      offsets.offset == range.start ? CARET_ASSOCIATE_AFTER : CARET_ASSOCIATE_BEFORE;
  return offsets;
}

static nsIFrame* AdjustFrameForSelectionStyles(nsIFrame* aFrame) {
  nsIFrame* adjustedFrame = aFrame;
  for (nsIFrame* frame = aFrame; frame; frame = frame->GetParent())
  {
    // These are the conditions that make all children not able to handle
    // a cursor.
    StyleUserSelect userSelect = frame->StyleUIReset()->mUserSelect;
    if (userSelect == StyleUserSelect::MozText) {
      // If we see a -moz-text element, we shouldn't look further up the parent
      // chain!
      break;
    }
    if (userSelect == StyleUserSelect::All ||
        frame->IsGeneratedContentFrame()) {
      adjustedFrame = frame;
    }
  }
  return adjustedFrame;
}

nsIFrame::ContentOffsets nsIFrame::GetContentOffsetsFromPoint(nsPoint aPoint,
                                                              uint32_t aFlags)
{
  nsIFrame *adjustedFrame;
  if (aFlags & IGNORE_SELECTION_STYLE) {
    adjustedFrame = this;
  }
  else {
    // This section of code deals with special selection styles.  Note that
    // -moz-all exists, even though it doesn't need to be explicitly handled.
    //
    // The offset is forced not to end up in generated content; content offsets
    // cannot represent content outside of the document's content tree.

    adjustedFrame = AdjustFrameForSelectionStyles(this);

    // -moz-user-select: all needs special handling, because clicking on it
    // should lead to the whole frame being selected
    if (adjustedFrame && adjustedFrame->StyleUIReset()->mUserSelect ==
        StyleUserSelect::All) {
      nsPoint adjustedPoint = aPoint + this->GetOffsetTo(adjustedFrame);
      return OffsetsForSingleFrame(adjustedFrame, adjustedPoint);
    }

    // For other cases, try to find a closest frame starting from the parent of
    // the unselectable frame
    if (adjustedFrame != this)
      adjustedFrame = adjustedFrame->GetParent();
  }

  nsPoint adjustedPoint = aPoint + this->GetOffsetTo(adjustedFrame);

  FrameTarget closest =
    GetSelectionClosestFrame(adjustedFrame, adjustedPoint, aFlags);

  if (closest.emptyBlock) {
    ContentOffsets offsets;
    NS_ASSERTION(closest.frame,
                 "closest.frame must not be null when it's empty");
    offsets.content = closest.frame->GetContent();
    offsets.offset = 0;
    offsets.secondaryOffset = 0;
    offsets.associate = CARET_ASSOCIATE_AFTER;
    return offsets;
  }

  // If the correct offset is at one end of a frame, use offset-based
  // calculation method
  if (closest.frameEdge) {
    ContentOffsets offsets;
    FrameContentRange range = GetRangeForFrame(closest.frame);
    offsets.content = range.content;
    if (closest.afterFrame)
      offsets.offset = range.end;
    else
      offsets.offset = range.start;
    offsets.secondaryOffset = offsets.offset;
    offsets.associate = offsets.offset == range.start ?
        CARET_ASSOCIATE_AFTER : CARET_ASSOCIATE_BEFORE;
    return offsets;
  }

  nsPoint pt;
  if (closest.frame != this) {
    if (closest.frame->IsSVGText()) {
      pt = nsLayoutUtils::TransformAncestorPointToFrame(closest.frame,
                                                        aPoint, this);
    } else {
      pt = aPoint - closest.frame->GetOffsetTo(this);
    }
  } else {
    pt = aPoint;
  }
  return static_cast<nsFrame*>(closest.frame)->CalcContentOffsetsFromFramePoint(pt);

  // XXX should I add some kind of offset standardization?
  // consider <b>xxxxx</b><i>zzzzz</i>; should any click between the last
  // x and first z put the cursor in the same logical position in addition
  // to the same visual position?
}

nsIFrame::ContentOffsets nsFrame::CalcContentOffsetsFromFramePoint(nsPoint aPoint)
{
  return OffsetsForSingleFrame(this, aPoint);
}

void
nsIFrame::AssociateImage(const nsStyleImage& aImage, nsPresContext* aPresContext)
{
  if (aImage.GetType() != eStyleImageType_Image) {
    return;
  }

  imgRequestProxy* req = aImage.GetImageData();
  if (!req) {
    return;
  }

  mozilla::css::ImageLoader* loader =
    aPresContext->Document()->StyleImageLoader();

  // If this fails there's not much we can do ...
  loader->AssociateRequestToFrame(req, this);
}

nsresult
nsFrame::GetCursor(const nsPoint& aPoint,
                   nsIFrame::Cursor& aCursor)
{
  FillCursorInformationFromStyle(StyleUserInterface(), aCursor);
  if (NS_STYLE_CURSOR_AUTO == aCursor.mCursor) {
    // If this is editable, I-beam cursor is better for most elements.
    aCursor.mCursor =
      (mContent && mContent->IsEditable())
      ? NS_STYLE_CURSOR_TEXT : NS_STYLE_CURSOR_DEFAULT;
  }
  if (NS_STYLE_CURSOR_TEXT == aCursor.mCursor &&
      GetWritingMode().IsVertical()) {
    // Per CSS UI spec, UA may treat value 'text' as
    // 'vertical-text' for vertical text.
    aCursor.mCursor = NS_STYLE_CURSOR_VERTICAL_TEXT;
  }

  return NS_OK;
}

// Resize and incremental reflow

/* virtual */ void
nsFrame::MarkIntrinsicISizesDirty()
{
  // This version is meant only for what used to be box-to-block adaptors.
  // It should not be called by other derived classes.
  if (::IsXULBoxWrapped(this)) {
    nsBoxLayoutMetrics *metrics = BoxMetrics();

    SizeNeedsRecalc(metrics->mPrefSize);
    SizeNeedsRecalc(metrics->mMinSize);
    SizeNeedsRecalc(metrics->mMaxSize);
    SizeNeedsRecalc(metrics->mBlockPrefSize);
    SizeNeedsRecalc(metrics->mBlockMinSize);
    CoordNeedsRecalc(metrics->mFlex);
    CoordNeedsRecalc(metrics->mAscent);
  }

  if (GetStateBits() & NS_FRAME_FONT_INFLATION_FLOW_ROOT) {
    nsFontInflationData::MarkFontInflationDataTextDirty(this);
  }
}

/* virtual */ nscoord
nsFrame::GetMinISize(nsRenderingContext *aRenderingContext)
{
  nscoord result = 0;
  DISPLAY_MIN_WIDTH(this, result);
  return result;
}

/* virtual */ nscoord
nsFrame::GetPrefISize(nsRenderingContext *aRenderingContext)
{
  nscoord result = 0;
  DISPLAY_PREF_WIDTH(this, result);
  return result;
}

/* virtual */ void
nsFrame::AddInlineMinISize(nsRenderingContext* aRenderingContext,
                           nsIFrame::InlineMinISizeData* aData)
{
  nscoord isize = nsLayoutUtils::IntrinsicForContainer(aRenderingContext,
                    this, nsLayoutUtils::MIN_ISIZE);
  aData->DefaultAddInlineMinISize(this, isize);
}

/* virtual */ void
nsFrame::AddInlinePrefISize(nsRenderingContext* aRenderingContext,
                            nsIFrame::InlinePrefISizeData* aData)
{
  nscoord isize = nsLayoutUtils::IntrinsicForContainer(aRenderingContext,
                    this, nsLayoutUtils::PREF_ISIZE);
  aData->DefaultAddInlinePrefISize(isize);
}

void
nsIFrame::InlineMinISizeData::DefaultAddInlineMinISize(nsIFrame* aFrame,
                                                       nscoord   aISize,
                                                       bool      aAllowBreak)
{
  auto parent = aFrame->GetParent();
  MOZ_ASSERT(parent, "Must have a parent if we get here!");
  const bool mayBreak = aAllowBreak &&
    !aFrame->CanContinueTextRun() &&
    !parent->StyleContext()->ShouldSuppressLineBreak() &&
    parent->StyleText()->WhiteSpaceCanWrap(parent);
  if (mayBreak) {
    OptionallyBreak();
  }
  mTrailingWhitespace = 0;
  mSkipWhitespace = false;
  mCurrentLine += aISize;
  mAtStartOfLine = false;
  if (mayBreak) {
    OptionallyBreak();
  }
}

void
nsIFrame::InlinePrefISizeData::DefaultAddInlinePrefISize(nscoord aISize)
{
  mCurrentLine = NSCoordSaturatingAdd(mCurrentLine, aISize);
  mTrailingWhitespace = 0;
  mSkipWhitespace = false;
}

void
nsIFrame::InlineMinISizeData::ForceBreak()
{
  mCurrentLine -= mTrailingWhitespace;
  mPrevLines = std::max(mPrevLines, mCurrentLine);
  mCurrentLine = mTrailingWhitespace = 0;

  for (uint32_t i = 0, i_end = mFloats.Length(); i != i_end; ++i) {
    nscoord float_min = mFloats[i].Width();
    if (float_min > mPrevLines)
      mPrevLines = float_min;
  }
  mFloats.Clear();
  mSkipWhitespace = true;
}

void
nsIFrame::InlineMinISizeData::OptionallyBreak(nscoord aHyphenWidth)
{
  // If we can fit more content into a smaller width by staying on this
  // line (because we're still at a negative offset due to negative
  // text-indent or negative margin), don't break.  Otherwise, do the
  // same as ForceBreak.  it doesn't really matter when we accumulate
  // floats.
  if (mCurrentLine + aHyphenWidth < 0 || mAtStartOfLine)
    return;
  mCurrentLine += aHyphenWidth;
  ForceBreak();
}

void
nsIFrame::InlinePrefISizeData::ForceBreak()
{
  if (mFloats.Length() != 0) {
            // preferred widths accumulated for floats that have already
            // been cleared past
    nscoord floats_done = 0,
            // preferred widths accumulated for floats that have not yet
            // been cleared past
            floats_cur_left = 0,
            floats_cur_right = 0;

    for (uint32_t i = 0, i_end = mFloats.Length(); i != i_end; ++i) {
      const FloatInfo& floatInfo = mFloats[i];
      const nsStyleDisplay* floatDisp = floatInfo.Frame()->StyleDisplay();
      StyleClear breakType = floatDisp->PhysicalBreakType(mLineContainerWM);
      if (breakType == StyleClear::Left ||
          breakType == StyleClear::Right ||
          breakType == StyleClear::Both) {
        nscoord floats_cur = NSCoordSaturatingAdd(floats_cur_left,
                                                  floats_cur_right);
        if (floats_cur > floats_done) {
          floats_done = floats_cur;
        }
        if (breakType != StyleClear::Right) {
          floats_cur_left = 0;
        }
        if (breakType != StyleClear::Left) {
          floats_cur_right = 0;
        }
      }

      StyleFloat floatStyle = floatDisp->PhysicalFloats(mLineContainerWM);
      nscoord& floats_cur =
        floatStyle == StyleFloat::Left ? floats_cur_left : floats_cur_right;
      nscoord floatWidth = floatInfo.Width();
      // Negative-width floats don't change the available space so they
      // shouldn't change our intrinsic line width either.
      floats_cur =
        NSCoordSaturatingAdd(floats_cur, std::max(0, floatWidth));
    }

    nscoord floats_cur =
      NSCoordSaturatingAdd(floats_cur_left, floats_cur_right);
    if (floats_cur > floats_done)
      floats_done = floats_cur;

    mCurrentLine = NSCoordSaturatingAdd(mCurrentLine, floats_done);

    mFloats.Clear();
  }

  mCurrentLine =
    NSCoordSaturatingSubtract(mCurrentLine, mTrailingWhitespace, nscoord_MAX);
  mPrevLines = std::max(mPrevLines, mCurrentLine);
  mCurrentLine = mTrailingWhitespace = 0;
  mSkipWhitespace = true;
}

static void
AddCoord(const nsStyleCoord& aStyle,
         nsIFrame* aFrame,
         nscoord* aCoord, float* aPercent,
         bool aClampNegativeToZero)
{
  switch (aStyle.GetUnit()) {
    case eStyleUnit_Coord: {
      NS_ASSERTION(!aClampNegativeToZero || aStyle.GetCoordValue() >= 0,
                   "unexpected negative value");
      *aCoord += aStyle.GetCoordValue();
      return;
    }
    case eStyleUnit_Percent: {
      NS_ASSERTION(!aClampNegativeToZero || aStyle.GetPercentValue() >= 0.0f,
                   "unexpected negative value");
      *aPercent += aStyle.GetPercentValue();
      return;
    }
    case eStyleUnit_Calc: {
      const nsStyleCoord::Calc *calc = aStyle.GetCalcValue();
      if (aClampNegativeToZero) {
        // This is far from ideal when one is negative and one is positive.
        *aCoord += std::max(calc->mLength, 0);
        *aPercent += std::max(calc->mPercent, 0.0f);
      } else {
        *aCoord += calc->mLength;
        *aPercent += calc->mPercent;
      }
      return;
    }
    default: {
      return;
    }
  }
}

static nsIFrame::IntrinsicISizeOffsetData
IntrinsicSizeOffsets(nsIFrame* aFrame, bool aForISize)
{
  nsIFrame::IntrinsicISizeOffsetData result;
  WritingMode wm = aFrame->GetWritingMode();
  const nsStyleMargin* styleMargin = aFrame->StyleMargin();
  bool verticalAxis = aForISize == wm.IsVertical();
  AddCoord(verticalAxis ? styleMargin->mMargin.GetTop()
                        : styleMargin->mMargin.GetLeft(),
           aFrame, &result.hMargin, &result.hPctMargin,
           false);
  AddCoord(verticalAxis ? styleMargin->mMargin.GetBottom()
                        : styleMargin->mMargin.GetRight(),
           aFrame, &result.hMargin, &result.hPctMargin,
           false);

  const nsStylePadding* stylePadding = aFrame->StylePadding();
  AddCoord(verticalAxis ? stylePadding->mPadding.GetTop()
                        : stylePadding->mPadding.GetLeft(),
           aFrame, &result.hPadding, &result.hPctPadding,
           true);
  AddCoord(verticalAxis ? stylePadding->mPadding.GetBottom()
                        : stylePadding->mPadding.GetRight(),
           aFrame, &result.hPadding, &result.hPctPadding,
           true);

  const nsStyleBorder* styleBorder = aFrame->StyleBorder();
  if (verticalAxis) {
    result.hBorder += styleBorder->GetComputedBorderWidth(NS_SIDE_TOP);
    result.hBorder += styleBorder->GetComputedBorderWidth(NS_SIDE_BOTTOM);
  } else {
    result.hBorder += styleBorder->GetComputedBorderWidth(NS_SIDE_LEFT);
    result.hBorder += styleBorder->GetComputedBorderWidth(NS_SIDE_RIGHT);
  }

  const nsStyleDisplay* disp = aFrame->StyleDisplay();
  if (aFrame->IsThemed(disp)) {
    nsPresContext* presContext = aFrame->PresContext();

    nsIntMargin border;
    presContext->GetTheme()->GetWidgetBorder(presContext->DeviceContext(),
                                             aFrame, disp->mAppearance,
                                             &border);
    result.hBorder =
      presContext->DevPixelsToAppUnits(verticalAxis ? border.TopBottom()
                                                    : border.LeftRight());

    nsIntMargin padding;
    if (presContext->GetTheme()->GetWidgetPadding(presContext->DeviceContext(),
                                                  aFrame, disp->mAppearance,
                                                  &padding)) {
      result.hPadding =
        presContext->DevPixelsToAppUnits(verticalAxis ? padding.TopBottom()
                                                      : padding.LeftRight());
      result.hPctPadding = 0;
    }
  }
  return result;
}

/* virtual */ nsIFrame::IntrinsicISizeOffsetData
nsFrame::IntrinsicISizeOffsets()
{
  return IntrinsicSizeOffsets(this, true);
}

nsIFrame::IntrinsicISizeOffsetData
nsIFrame::IntrinsicBSizeOffsets()
{
  return IntrinsicSizeOffsets(this, false);
}

/* virtual */ IntrinsicSize
nsFrame::GetIntrinsicSize()
{
  return IntrinsicSize(); // default is width/height set to eStyleUnit_None
}

/* virtual */ nsSize
nsFrame::GetIntrinsicRatio()
{
  return nsSize(0, 0);
}

/* virtual */
LogicalSize
nsFrame::ComputeSize(nsRenderingContext* aRenderingContext,
                     WritingMode         aWM,
                     const LogicalSize&  aCBSize,
                     nscoord             aAvailableISize,
                     const LogicalSize&  aMargin,
                     const LogicalSize&  aBorder,
                     const LogicalSize&  aPadding,
                     ComputeSizeFlags    aFlags)
{
  MOZ_ASSERT(GetIntrinsicRatio() == nsSize(0,0),
             "Please override this method and call "
             "nsFrame::ComputeSizeWithIntrinsicDimensions instead.");
  LogicalSize result = ComputeAutoSize(aRenderingContext, aWM,
                                       aCBSize, aAvailableISize,
                                       aMargin, aBorder, aPadding,
                                       aFlags);
  const nsStylePosition *stylePos = StylePosition();

  LogicalSize boxSizingAdjust(aWM);
  if (stylePos->mBoxSizing == StyleBoxSizing::Border) {
    boxSizingAdjust = aBorder + aPadding;
  }
  nscoord boxSizingToMarginEdgeISize =
    aMargin.ISize(aWM) + aBorder.ISize(aWM) + aPadding.ISize(aWM) -
    boxSizingAdjust.ISize(aWM);

  const nsStyleCoord* inlineStyleCoord = &stylePos->ISize(aWM);
  const nsStyleCoord* blockStyleCoord = &stylePos->BSize(aWM);

  nsIAtom* parentFrameType = GetParent() ? GetParent()->GetType() : nullptr;
  auto alignCB = GetParent();
  bool isGridItem = (parentFrameType == nsGkAtoms::gridContainerFrame &&
                     !(GetStateBits() & NS_FRAME_OUT_OF_FLOW));
  if (parentFrameType == nsGkAtoms::tableWrapperFrame &&
      GetType() == nsGkAtoms::tableFrame) {
    // An inner table frame is sized as a grid item if its table wrapper is,
    // because they actually have the same CB (the wrapper's CB).
    // @see ReflowInput::InitCBReflowInput
    auto tableWrapper = GetParent();
    auto grandParent = tableWrapper->GetParent();
    isGridItem = (grandParent->GetType() == nsGkAtoms::gridContainerFrame &&
                  !(tableWrapper->GetStateBits() & NS_FRAME_OUT_OF_FLOW));
    if (isGridItem) {
      // When resolving justify/align-self below, we want to use the grid
      // container's justify/align-items value and WritingMode.
      alignCB = grandParent;
    }
  }
  bool isFlexItem = (parentFrameType == nsGkAtoms::flexContainerFrame &&
                     !(GetStateBits() & NS_FRAME_OUT_OF_FLOW));
  bool isInlineFlexItem = false;
  if (isFlexItem) {
    // Flex items use their "flex-basis" property in place of their main-size
    // property (e.g. "width") for sizing purposes, *unless* they have
    // "flex-basis:auto", in which case they use their main-size property after
    // all.
    uint32_t flexDirection = GetParent()->StylePosition()->mFlexDirection;
    isInlineFlexItem =
      flexDirection == NS_STYLE_FLEX_DIRECTION_ROW ||
      flexDirection == NS_STYLE_FLEX_DIRECTION_ROW_REVERSE;

    // NOTE: The logic here should match the similar chunk for determining
    // inlineStyleCoord and blockStyleCoord in
    // nsFrame::ComputeSizeWithIntrinsicDimensions().
    const nsStyleCoord* flexBasis = &(stylePos->mFlexBasis);
    if (flexBasis->GetUnit() != eStyleUnit_Auto) {
      if (isInlineFlexItem) {
        inlineStyleCoord = flexBasis;
      } else {
        // One caveat for vertical flex items: We don't support enumerated
        // values (e.g. "max-content") for height properties yet. So, if our
        // computed flex-basis is an enumerated value, we'll just behave as if
        // it were "auto", which means "use the main-size property after all"
        // (which is "height", in this case).
        // NOTE: Once we support intrinsic sizing keywords for "height",
        // we should remove this check.
        if (flexBasis->GetUnit() != eStyleUnit_Enumerated) {
          blockStyleCoord = flexBasis;
        }
      }
    }
  }

  // Compute inline-axis size

  if (inlineStyleCoord->GetUnit() != eStyleUnit_Auto) {
    result.ISize(aWM) =
      ComputeISizeValue(aRenderingContext, aCBSize.ISize(aWM),
                        boxSizingAdjust.ISize(aWM), boxSizingToMarginEdgeISize,
                        *inlineStyleCoord, aFlags);
  } else if (MOZ_UNLIKELY(isGridItem) &&
             !IS_TRUE_OVERFLOW_CONTAINER(this)) {
    // 'auto' inline-size for grid-level box - fill the CB for 'stretch' /
    // 'normal' and clamp it to the CB if requested:
    bool stretch = false;
    if (!(aFlags & nsIFrame::eShrinkWrap) &&
        !StyleMargin()->HasInlineAxisAuto(aWM)) {
      auto inlineAxisAlignment =
        aWM.IsOrthogonalTo(alignCB->GetWritingMode()) ?
          StylePosition()->UsedAlignSelf(alignCB->StyleContext()) :
          StylePosition()->UsedJustifySelf(alignCB->StyleContext());
      stretch = inlineAxisAlignment == NS_STYLE_ALIGN_NORMAL ||
                inlineAxisAlignment == NS_STYLE_ALIGN_STRETCH;
    }
    if (stretch || (aFlags & ComputeSizeFlags::eIClampMarginBoxMinSize)) {
      auto iSizeToFillCB = std::max(nscoord(0), aCBSize.ISize(aWM) -
                                                aPadding.ISize(aWM) -
                                                aBorder.ISize(aWM) -
                                                aMargin.ISize(aWM));
      if (stretch || result.ISize(aWM) > iSizeToFillCB) {
        result.ISize(aWM) = iSizeToFillCB;
      }
    }
  }

  // Flex items ignore their min & max sizing properties in their
  // flex container's main-axis.  (Those properties get applied later in
  // the flexbox algorithm.)
  const nsStyleCoord& maxISizeCoord = stylePos->MaxISize(aWM);
  nscoord maxISize = NS_UNCONSTRAINEDSIZE;
  if (maxISizeCoord.GetUnit() != eStyleUnit_None &&
      !(isFlexItem && isInlineFlexItem)) {
    maxISize =
      ComputeISizeValue(aRenderingContext, aCBSize.ISize(aWM),
                        boxSizingAdjust.ISize(aWM), boxSizingToMarginEdgeISize,
                        maxISizeCoord, aFlags);
    result.ISize(aWM) = std::min(maxISize, result.ISize(aWM));
  }

  const nsStyleCoord& minISizeCoord = stylePos->MinISize(aWM);
  nscoord minISize;
  if (minISizeCoord.GetUnit() != eStyleUnit_Auto &&
      !(isFlexItem && isInlineFlexItem)) {
    minISize =
      ComputeISizeValue(aRenderingContext, aCBSize.ISize(aWM),
                        boxSizingAdjust.ISize(aWM), boxSizingToMarginEdgeISize,
                        minISizeCoord, aFlags);
  } else if (MOZ_UNLIKELY(isGridItem)) {
    // This implements "Implied Minimum Size of Grid Items".
    // https://drafts.csswg.org/css-grid/#min-size-auto
    minISize = std::min(maxISize, GetMinISize(aRenderingContext));
    if (inlineStyleCoord->IsCoordPercentCalcUnit()) {
      minISize = std::min(minISize, result.ISize(aWM));
    } else if (aFlags & eIClampMarginBoxMinSize) {
      // "if the grid item spans only grid tracks that have a fixed max track
      // sizing function, its automatic minimum size in that dimension is
      // further clamped to less than or equal to the size necessary to fit
      // its margin box within the resulting grid area (flooring at zero)"
      // https://drafts.csswg.org/css-grid/#min-size-auto
      auto maxMinISize = std::max(nscoord(0), aCBSize.ISize(aWM) -
                                              aPadding.ISize(aWM) -
                                              aBorder.ISize(aWM) -
                                              aMargin.ISize(aWM));
      minISize = std::min(minISize, maxMinISize);
    }
  } else {
    // Treat "min-width: auto" as 0.
    // NOTE: Technically, "auto" is supposed to behave like "min-content" on
    // flex items. However, we don't need to worry about that here, because
    // flex items' min-sizes are intentionally ignored until the flex
    // container explicitly considers them during space distribution.
    minISize = 0;
  }
  result.ISize(aWM) = std::max(minISize, result.ISize(aWM));

  // Compute block-axis size
  // (but not if we have auto bsize or if we recieved the "eUseAutoBSize"
  // flag -- then, we'll just stick with the bsize that we already calculated
  // in the initial ComputeAutoSize() call.)
  if (!(aFlags & nsIFrame::eUseAutoBSize)) {
    if (!nsLayoutUtils::IsAutoBSize(*blockStyleCoord, aCBSize.BSize(aWM))) {
      result.BSize(aWM) =
        nsLayoutUtils::ComputeBSizeValue(aCBSize.BSize(aWM),
                                         boxSizingAdjust.BSize(aWM),
                                         *blockStyleCoord);
    } else if (MOZ_UNLIKELY(isGridItem) &&
               blockStyleCoord->GetUnit() == eStyleUnit_Auto &&
               !IS_TRUE_OVERFLOW_CONTAINER(this)) {
      auto cbSize = aCBSize.BSize(aWM);
      if (cbSize != NS_AUTOHEIGHT) {
        // 'auto' block-size for grid-level box - fill the CB for 'stretch' /
        // 'normal' and clamp it to the CB if requested:
        bool stretch = false;
        if (!StyleMargin()->HasBlockAxisAuto(aWM)) {
          auto blockAxisAlignment =
            !aWM.IsOrthogonalTo(alignCB->GetWritingMode()) ?
              StylePosition()->UsedAlignSelf(alignCB->StyleContext()) :
              StylePosition()->UsedJustifySelf(alignCB->StyleContext());
          stretch = blockAxisAlignment == NS_STYLE_ALIGN_NORMAL ||
                    blockAxisAlignment == NS_STYLE_ALIGN_STRETCH;
        }
        if (stretch || (aFlags & ComputeSizeFlags::eBClampMarginBoxMinSize)) {
          auto bSizeToFillCB = std::max(nscoord(0), cbSize -
                                                    aPadding.BSize(aWM) -
                                                    aBorder.BSize(aWM) -
                                                    aMargin.BSize(aWM));
          if (stretch || (result.BSize(aWM) != NS_AUTOHEIGHT &&
                          result.BSize(aWM) > bSizeToFillCB)) {
            result.BSize(aWM) = bSizeToFillCB;
          }
        }
      }
    }
  }

  const nsStyleCoord& maxBSizeCoord = stylePos->MaxBSize(aWM);

  if (result.BSize(aWM) != NS_UNCONSTRAINEDSIZE) {
    if (!nsLayoutUtils::IsAutoBSize(maxBSizeCoord, aCBSize.BSize(aWM)) &&
        !(isFlexItem && !isInlineFlexItem)) {
      nscoord maxBSize =
        nsLayoutUtils::ComputeBSizeValue(aCBSize.BSize(aWM),
                                         boxSizingAdjust.BSize(aWM),
                                         maxBSizeCoord);
      result.BSize(aWM) = std::min(maxBSize, result.BSize(aWM));
    }

    const nsStyleCoord& minBSizeCoord = stylePos->MinBSize(aWM);

    if (!nsLayoutUtils::IsAutoBSize(minBSizeCoord, aCBSize.BSize(aWM)) &&
        !(isFlexItem && !isInlineFlexItem)) {
      nscoord minBSize =
        nsLayoutUtils::ComputeBSizeValue(aCBSize.BSize(aWM),
                                         boxSizingAdjust.BSize(aWM),
                                         minBSizeCoord);
      result.BSize(aWM) = std::max(minBSize, result.BSize(aWM));
    }
  }

  const nsStyleDisplay *disp = StyleDisplay();
  if (IsThemed(disp)) {
    LayoutDeviceIntSize widget;
    bool canOverride = true;
    nsPresContext *presContext = PresContext();
    presContext->GetTheme()->
      GetMinimumWidgetSize(presContext, this, disp->mAppearance,
                           &widget, &canOverride);

    // Convert themed widget's physical dimensions to logical coords
    LogicalSize size(aWM,
                     nsSize(presContext->DevPixelsToAppUnits(widget.width),
                            presContext->DevPixelsToAppUnits(widget.height)));

    // GMWS() returns border-box; we need content-box
    size.ISize(aWM) -= aBorder.ISize(aWM) + aPadding.ISize(aWM);
    size.BSize(aWM) -= aBorder.BSize(aWM) + aPadding.BSize(aWM);

    if (size.BSize(aWM) > result.BSize(aWM) || !canOverride) {
      result.BSize(aWM) = size.BSize(aWM);
    }
    if (size.ISize(aWM) > result.ISize(aWM) || !canOverride) {
      result.ISize(aWM) = size.ISize(aWM);
    }
  }

  result.ISize(aWM) = std::max(0, result.ISize(aWM));
  result.BSize(aWM) = std::max(0, result.BSize(aWM));

  return result;
}

LogicalSize
nsFrame::ComputeSizeWithIntrinsicDimensions(nsRenderingContext*  aRenderingContext,
                                            WritingMode          aWM,
                                            const IntrinsicSize& aIntrinsicSize,
                                            nsSize               aIntrinsicRatio,
                                            const LogicalSize&   aCBSize,
                                            const LogicalSize&   aMargin,
                                            const LogicalSize&   aBorder,
                                            const LogicalSize&   aPadding,
                                            ComputeSizeFlags     aFlags)
{
  const nsStylePosition* stylePos = StylePosition();
  const nsStyleCoord* inlineStyleCoord = &stylePos->ISize(aWM);
  const nsStyleCoord* blockStyleCoord = &stylePos->BSize(aWM);
  const nsIAtom* parentFrameType =
    GetParent() ? GetParent()->GetType() : nullptr;
  const bool isGridItem = (parentFrameType == nsGkAtoms::gridContainerFrame &&
                           !(GetStateBits() & NS_FRAME_OUT_OF_FLOW));
  const bool isFlexItem = (parentFrameType == nsGkAtoms::flexContainerFrame &&
                           !(GetStateBits() & NS_FRAME_OUT_OF_FLOW));
  bool isInlineFlexItem = false;
  Maybe<nsStyleCoord> imposedMainSizeStyleCoord;

  // If this is a flex item, and we're measuring its cross size after flexing
  // to resolve its main size, then we need to use the resolved main size
  // that the container provides to us *instead of* the main-size coordinate
  // from our style struct. (Otherwise, we'll be using an irrelevant value in
  // the aspect-ratio calculations below.)
  if (isFlexItem) {
    uint32_t flexDirection =
      GetParent()->StylePosition()->mFlexDirection;
    isInlineFlexItem =
      flexDirection == NS_STYLE_FLEX_DIRECTION_ROW ||
      flexDirection == NS_STYLE_FLEX_DIRECTION_ROW_REVERSE;

    // If FlexItemMainSizeOverride frame-property is set, then that means the
    // flex container is imposing a main-size on this flex item for it to use
    // as its size in the container's main axis.
    FrameProperties props = Properties();
    bool didImposeMainSize;
    nscoord imposedMainSize =
      props.Get(nsIFrame::FlexItemMainSizeOverride(), &didImposeMainSize);
    if (didImposeMainSize) {
      imposedMainSizeStyleCoord.emplace(imposedMainSize,
                                        nsStyleCoord::CoordConstructor);
      if (isInlineFlexItem) {
        inlineStyleCoord = imposedMainSizeStyleCoord.ptr();
      } else {
        blockStyleCoord = imposedMainSizeStyleCoord.ptr();
      }

    } else {
      // Flex items use their "flex-basis" property in place of their main-size
      // property (e.g. "width") for sizing purposes, *unless* they have
      // "flex-basis:auto", in which case they use their main-size property
      // after all.
      // NOTE: The logic here should match the similar chunk for determining
      // inlineStyleCoord and blockStyleCoord in nsFrame::ComputeSize().
      const nsStyleCoord* flexBasis = &(stylePos->mFlexBasis);
      if (flexBasis->GetUnit() != eStyleUnit_Auto) {
        if (isInlineFlexItem) {
          inlineStyleCoord = flexBasis;
        } else {
          // One caveat for vertical flex items: We don't support enumerated
          // values (e.g. "max-content") for height properties yet. So, if our
          // computed flex-basis is an enumerated value, we'll just behave as if
          // it were "auto", which means "use the main-size property after all"
          // (which is "height", in this case).
          // NOTE: Once we support intrinsic sizing keywords for "height",
          // we should remove this check.
          if (flexBasis->GetUnit() != eStyleUnit_Enumerated) {
            blockStyleCoord = flexBasis;
          }
        }
      }
    }
  }

  // Handle intrinsic sizes and their interaction with
  // {min-,max-,}{width,height} according to the rules in
  // http://www.w3.org/TR/CSS21/visudet.html#min-max-widths

  // Note: throughout the following section of the function, I avoid
  // a * (b / c) because of its reduced accuracy relative to a * b / c
  // or (a * b) / c (which are equivalent).

  const bool isAutoISize = inlineStyleCoord->GetUnit() == eStyleUnit_Auto;
  const bool isAutoBSize =
    nsLayoutUtils::IsAutoBSize(*blockStyleCoord, aCBSize.BSize(aWM));

  LogicalSize boxSizingAdjust(aWM);
  if (stylePos->mBoxSizing == StyleBoxSizing::Border) {
    boxSizingAdjust = aBorder + aPadding;
  }
  nscoord boxSizingToMarginEdgeISize =
    aMargin.ISize(aWM) + aBorder.ISize(aWM) + aPadding.ISize(aWM) -
      boxSizingAdjust.ISize(aWM);

  nscoord iSize, minISize, maxISize, bSize, minBSize, maxBSize;
  enum class Stretch {
    // stretch to fill the CB (preserving intrinsic ratio) in the relevant axis
    eStretchPreservingRatio,
    // stretch to fill the CB in the relevant axis
    eStretch,
    // no stretching in the relevant axis
    eNoStretch,
  };
  // just to avoid having to type these out everywhere:
  const auto eStretchPreservingRatio = Stretch::eStretchPreservingRatio;
  const auto eStretch = Stretch::eStretch;
  const auto eNoStretch = Stretch::eNoStretch;

  Stretch stretchI = eNoStretch; // stretch behavior in the inline axis
  Stretch stretchB = eNoStretch; // stretch behavior in the block axis

  if (!isAutoISize) {
    iSize = ComputeISizeValue(aRenderingContext,
              aCBSize.ISize(aWM), boxSizingAdjust.ISize(aWM),
              boxSizingToMarginEdgeISize, *inlineStyleCoord, aFlags);
  } else if (MOZ_UNLIKELY(isGridItem)) {
    MOZ_ASSERT(!IS_TRUE_OVERFLOW_CONTAINER(this));
    // 'auto' inline-size for grid-level box - apply 'stretch' as needed:
    auto cbSize = aCBSize.ISize(aWM);
    if (cbSize != NS_UNCONSTRAINEDSIZE) {
      if (!StyleMargin()->HasInlineAxisAuto(aWM)) {
        auto inlineAxisAlignment =
          aWM.IsOrthogonalTo(GetParent()->GetWritingMode()) ?
            stylePos->UsedAlignSelf(GetParent()->StyleContext()) :
            stylePos->UsedJustifySelf(GetParent()->StyleContext());
        if (inlineAxisAlignment == NS_STYLE_ALIGN_NORMAL) {
          stretchI = eStretchPreservingRatio;
        } else if (inlineAxisAlignment == NS_STYLE_ALIGN_STRETCH) {
          stretchI = eStretch;
        }
      }
      if (stretchI != eNoStretch ||
          (aFlags & ComputeSizeFlags::eIClampMarginBoxMinSize)) {
        iSize = std::max(nscoord(0), cbSize -
                                     aPadding.ISize(aWM) -
                                     aBorder.ISize(aWM) -
                                     aMargin.ISize(aWM));
      }
    } else {
      // Reset this flag to avoid applying the clamping below.
      aFlags = ComputeSizeFlags(aFlags &
                                ~ComputeSizeFlags::eIClampMarginBoxMinSize);
    }
  }

  const nsStyleCoord& maxISizeCoord = stylePos->MaxISize(aWM);

  if (maxISizeCoord.GetUnit() != eStyleUnit_None &&
      !(isFlexItem && isInlineFlexItem)) {
    maxISize = ComputeISizeValue(aRenderingContext,
                 aCBSize.ISize(aWM), boxSizingAdjust.ISize(aWM),
                 boxSizingToMarginEdgeISize, maxISizeCoord, aFlags);
  } else {
    maxISize = nscoord_MAX;
  }

  // NOTE: Flex items ignore their min & max sizing properties in their
  // flex container's main-axis.  (Those properties get applied later in
  // the flexbox algorithm.)

  const nsStyleCoord& minISizeCoord = stylePos->MinISize(aWM);

  if (minISizeCoord.GetUnit() != eStyleUnit_Auto &&
      !(isFlexItem && isInlineFlexItem)) {
    minISize = ComputeISizeValue(aRenderingContext,
                 aCBSize.ISize(aWM), boxSizingAdjust.ISize(aWM),
                 boxSizingToMarginEdgeISize, minISizeCoord, aFlags);
  } else {
    // Treat "min-width: auto" as 0.
    // NOTE: Technically, "auto" is supposed to behave like "min-content" on
    // flex items. However, we don't need to worry about that here, because
    // flex items' min-sizes are intentionally ignored until the flex
    // container explicitly considers them during space distribution.
    minISize = 0;
  }

  if (!isAutoBSize) {
    bSize = nsLayoutUtils::ComputeBSizeValue(aCBSize.BSize(aWM),
                boxSizingAdjust.BSize(aWM),
                *blockStyleCoord);
  } else if (MOZ_UNLIKELY(isGridItem)) {
    MOZ_ASSERT(!IS_TRUE_OVERFLOW_CONTAINER(this));
    // 'auto' block-size for grid-level box - apply 'stretch' as needed:
    auto cbSize = aCBSize.BSize(aWM);
    if (cbSize != NS_AUTOHEIGHT) {
      if (!StyleMargin()->HasBlockAxisAuto(aWM)) {
        auto blockAxisAlignment =
          !aWM.IsOrthogonalTo(GetParent()->GetWritingMode()) ?
            stylePos->UsedAlignSelf(GetParent()->StyleContext()) :
            stylePos->UsedJustifySelf(GetParent()->StyleContext());
        if (blockAxisAlignment == NS_STYLE_ALIGN_NORMAL) {
          stretchB = eStretchPreservingRatio;
        } else if (blockAxisAlignment == NS_STYLE_ALIGN_STRETCH) {
          stretchB = eStretch;
        }
      }
      if (stretchB != eNoStretch ||
          (aFlags & ComputeSizeFlags::eBClampMarginBoxMinSize)) {
        bSize = std::max(nscoord(0), cbSize -
                                     aPadding.BSize(aWM) -
                                     aBorder.BSize(aWM) -
                                     aMargin.BSize(aWM));
      }
    } else {
      // Reset this flag to avoid applying the clamping below.
      aFlags = ComputeSizeFlags(aFlags &
                                ~ComputeSizeFlags::eBClampMarginBoxMinSize);
    }
  }

  const nsStyleCoord& maxBSizeCoord = stylePos->MaxBSize(aWM);

  if (!nsLayoutUtils::IsAutoBSize(maxBSizeCoord, aCBSize.BSize(aWM)) &&
      !(isFlexItem && !isInlineFlexItem)) {
    maxBSize = nsLayoutUtils::ComputeBSizeValue(aCBSize.BSize(aWM),
                  boxSizingAdjust.BSize(aWM), maxBSizeCoord);
  } else {
    maxBSize = nscoord_MAX;
  }

  const nsStyleCoord& minBSizeCoord = stylePos->MinBSize(aWM);

  if (!nsLayoutUtils::IsAutoBSize(minBSizeCoord, aCBSize.BSize(aWM)) &&
      !(isFlexItem && !isInlineFlexItem)) {
    minBSize = nsLayoutUtils::ComputeBSizeValue(aCBSize.BSize(aWM),
                  boxSizingAdjust.BSize(aWM), minBSizeCoord);
  } else {
    minBSize = 0;
  }

  // Resolve percentage intrinsic iSize/bSize as necessary:

  NS_ASSERTION(aCBSize.ISize(aWM) != NS_UNCONSTRAINEDSIZE,
               "Our containing block must not have unconstrained inline-size!");

  const bool isVertical = aWM.IsVertical();
  const nsStyleCoord& isizeCoord =
    isVertical ? aIntrinsicSize.height : aIntrinsicSize.width;
  const nsStyleCoord& bsizeCoord =
    isVertical ? aIntrinsicSize.width : aIntrinsicSize.height;

  bool hasIntrinsicISize, hasIntrinsicBSize;
  nscoord intrinsicISize, intrinsicBSize;

  if (isizeCoord.GetUnit() == eStyleUnit_Coord) {
    hasIntrinsicISize = true;
    intrinsicISize = isizeCoord.GetCoordValue();
    if (intrinsicISize < 0)
      intrinsicISize = 0;
  } else {
    NS_ASSERTION(isizeCoord.GetUnit() == eStyleUnit_None,
                 "unexpected unit");
    hasIntrinsicISize = false;
    intrinsicISize = 0;
  }

  if (bsizeCoord.GetUnit() == eStyleUnit_Coord) {
    hasIntrinsicBSize = true;
    intrinsicBSize = bsizeCoord.GetCoordValue();
    if (intrinsicBSize < 0)
      intrinsicBSize = 0;
  } else {
    NS_ASSERTION(bsizeCoord.GetUnit() == eStyleUnit_None,
                 "unexpected unit");
    hasIntrinsicBSize = false;
    intrinsicBSize = 0;
  }

  NS_ASSERTION(aIntrinsicRatio.width >= 0 && aIntrinsicRatio.height >= 0,
               "Intrinsic ratio has a negative component!");
  LogicalSize logicalRatio(aWM, aIntrinsicRatio);

  // Now calculate the used values for iSize and bSize:

  if (isAutoISize) {
    if (isAutoBSize) {

      // 'auto' iSize, 'auto' bSize

      // Get tentative values - CSS 2.1 sections 10.3.2 and 10.6.2:

      nscoord tentISize, tentBSize;

      if (hasIntrinsicISize) {
        tentISize = intrinsicISize;
      } else if (hasIntrinsicBSize && logicalRatio.BSize(aWM) > 0) {
        tentISize = NSCoordMulDiv(intrinsicBSize, logicalRatio.ISize(aWM), logicalRatio.BSize(aWM));
      } else if (logicalRatio.ISize(aWM) > 0) {
        tentISize = aCBSize.ISize(aWM) - boxSizingToMarginEdgeISize; // XXX scrollbar?
        if (tentISize < 0) tentISize = 0;
      } else {
        tentISize = nsPresContext::CSSPixelsToAppUnits(300);
      }

      // If we need to clamp the inline size to fit the CB, we use the 'stretch'
      // or 'normal' codepath.  We use the ratio-preserving 'normal' codepath
      // unless we have 'stretch' in the other axis.
      if ((aFlags & ComputeSizeFlags::eIClampMarginBoxMinSize) &&
          stretchI != eStretch && tentISize > iSize) {
        stretchI = (stretchB == eStretch ? eStretch : eStretchPreservingRatio);
      }

      if (hasIntrinsicBSize) {
        tentBSize = intrinsicBSize;
      } else if (logicalRatio.ISize(aWM) > 0) {
        tentBSize = NSCoordMulDiv(tentISize, logicalRatio.BSize(aWM), logicalRatio.ISize(aWM));
      } else {
        tentBSize = nsPresContext::CSSPixelsToAppUnits(150);
      }

      // (ditto the comment about clamping the inline size above)
      if ((aFlags & ComputeSizeFlags::eBClampMarginBoxMinSize) &&
          stretchB != eStretch && tentBSize > bSize) {
        stretchB = (stretchI == eStretch ? eStretch : eStretchPreservingRatio);
      }

      if (aIntrinsicRatio != nsSize(0, 0)) {
        if (stretchI == eStretch) {
          tentISize = iSize;  // * / 'stretch'
          if (stretchB == eStretch) {
            tentBSize = bSize;  // 'stretch' / 'stretch'
          } else if (stretchB == eStretchPreservingRatio && logicalRatio.ISize(aWM) > 0) {
            // 'normal' / 'stretch'
            tentBSize = NSCoordMulDiv(iSize, logicalRatio.BSize(aWM), logicalRatio.ISize(aWM));
          }
        } else if (stretchB == eStretch) {
          tentBSize = bSize;  // 'stretch' / * (except 'stretch')
          if (stretchI == eStretchPreservingRatio && logicalRatio.BSize(aWM) > 0) {
            // 'stretch' / 'normal'
            tentISize = NSCoordMulDiv(bSize, logicalRatio.ISize(aWM), logicalRatio.BSize(aWM));
          }
        } else if (stretchI == eStretchPreservingRatio) {
          tentISize = iSize;  // * (except 'stretch') / 'normal'
          if (logicalRatio.ISize(aWM) > 0) {
            tentBSize = NSCoordMulDiv(iSize, logicalRatio.BSize(aWM), logicalRatio.ISize(aWM));
          }
          if (stretchB == eStretchPreservingRatio && tentBSize > bSize) {
            // Stretch within the CB size with preserved intrinsic ratio.
            tentBSize = bSize;  // 'normal' / 'normal'
            if (logicalRatio.BSize(aWM) > 0) {
              tentISize = NSCoordMulDiv(bSize, logicalRatio.ISize(aWM), logicalRatio.BSize(aWM));
            }
          }
        } else if (stretchB == eStretchPreservingRatio) {
          tentBSize = bSize;  // 'normal' / * (except 'normal' and 'stretch')
          if (logicalRatio.BSize(aWM) > 0) {
            tentISize = NSCoordMulDiv(bSize, logicalRatio.ISize(aWM), logicalRatio.BSize(aWM));
          }
        }
      }

      // ComputeAutoSizeWithIntrinsicDimensions preserves the ratio when applying
      // the min/max-size.  We don't want that when we have 'stretch' in either
      // axis because tentISize/tentBSize is likely not according to ratio now.
      if (aIntrinsicRatio != nsSize(0, 0) &&
          stretchI != eStretch && stretchB != eStretch) {
        nsSize autoSize = nsLayoutUtils::
          ComputeAutoSizeWithIntrinsicDimensions(minISize, minBSize,
                                                 maxISize, maxBSize,
                                                 tentISize, tentBSize);
        // The nsSize that ComputeAutoSizeWithIntrinsicDimensions returns will
        // actually contain logical values if the parameters passed to it were
        // logical coordinates, so we do NOT perform a physical-to-logical
        // conversion here, but just assign the fields directly to our result.
        iSize = autoSize.width;
        bSize = autoSize.height;
      } else {
        // Not honoring an intrinsic ratio: clamp the dimensions independently.
        iSize = NS_CSS_MINMAX(tentISize, minISize, maxISize);
        bSize = NS_CSS_MINMAX(tentBSize, minBSize, maxBSize);
      }
    } else {

      // 'auto' iSize, non-'auto' bSize
      bSize = NS_CSS_MINMAX(bSize, minBSize, maxBSize);
      if (stretchI != eStretch) {
        if (logicalRatio.BSize(aWM) > 0) {
          iSize = NSCoordMulDiv(bSize, logicalRatio.ISize(aWM), logicalRatio.BSize(aWM));
        } else if (hasIntrinsicISize) {
          if (!((aFlags & ComputeSizeFlags::eIClampMarginBoxMinSize) &&
                intrinsicISize > iSize)) {
            iSize = intrinsicISize;
          } // else - leave iSize as is to fill the CB
        } else {
          iSize = nsPresContext::CSSPixelsToAppUnits(300);
        }
      } // else - leave iSize as is to fill the CB
      iSize = NS_CSS_MINMAX(iSize, minISize, maxISize);

    }
  } else {
    if (isAutoBSize) {

      // non-'auto' iSize, 'auto' bSize
      iSize = NS_CSS_MINMAX(iSize, minISize, maxISize);
      if (stretchB != eStretch) {
        if (logicalRatio.ISize(aWM) > 0) {
          bSize = NSCoordMulDiv(iSize, logicalRatio.BSize(aWM), logicalRatio.ISize(aWM));
        } else if (hasIntrinsicBSize) {
          if (!((aFlags & ComputeSizeFlags::eBClampMarginBoxMinSize) &&
                intrinsicBSize > bSize)) {
            bSize = intrinsicBSize;
          } // else - leave bSize as is to fill the CB
        } else {
          bSize = nsPresContext::CSSPixelsToAppUnits(150);
        }
      } // else - leave bSize as is to fill the CB
      bSize = NS_CSS_MINMAX(bSize, minBSize, maxBSize);

    } else {

      // non-'auto' iSize, non-'auto' bSize
      iSize = NS_CSS_MINMAX(iSize, minISize, maxISize);
      bSize = NS_CSS_MINMAX(bSize, minBSize, maxBSize);

    }
  }

  return LogicalSize(aWM, iSize, bSize);
}

nsRect
nsIFrame::ComputeTightBounds(DrawTarget* aDrawTarget) const
{
  return GetVisualOverflowRect();
}

nsRect
nsFrame::ComputeSimpleTightBounds(DrawTarget* aDrawTarget) const
{
  if (StyleOutline()->mOutlineStyle != NS_STYLE_BORDER_STYLE_NONE ||
      StyleBorder()->HasBorder() || !StyleBackground()->IsTransparent() ||
      StyleDisplay()->mAppearance) {
    // Not necessarily tight, due to clipping, negative
    // outline-offset, and lots of other issues, but that's OK
    return GetVisualOverflowRect();
  }

  nsRect r(0, 0, 0, 0);
  ChildListIterator lists(this);
  for (; !lists.IsDone(); lists.Next()) {
    nsFrameList::Enumerator childFrames(lists.CurrentList());
    for (; !childFrames.AtEnd(); childFrames.Next()) {
      nsIFrame* child = childFrames.get();
      r.UnionRect(r, child->ComputeTightBounds(aDrawTarget) + child->GetPosition());
    }
  }
  return r;
}

/* virtual */ nsresult
nsIFrame::GetPrefWidthTightBounds(nsRenderingContext* aContext,
                                  nscoord* aX,
                                  nscoord* aXMost)
{
  return NS_ERROR_NOT_IMPLEMENTED;
}

/* virtual */
LogicalSize
nsFrame::ComputeAutoSize(nsRenderingContext*         aRenderingContext,
                         WritingMode                 aWM,
                         const mozilla::LogicalSize& aCBSize,
                         nscoord                     aAvailableISize,
                         const mozilla::LogicalSize& aMargin,
                         const mozilla::LogicalSize& aBorder,
                         const mozilla::LogicalSize& aPadding,
                         ComputeSizeFlags            aFlags)
{
  // Use basic shrink-wrapping as a default implementation.
  LogicalSize result(aWM, 0xdeadbeef, NS_UNCONSTRAINEDSIZE);

  // don't bother setting it if the result won't be used
  if (StylePosition()->ISize(aWM).GetUnit() == eStyleUnit_Auto) {
    nscoord availBased = aAvailableISize - aMargin.ISize(aWM) -
                         aBorder.ISize(aWM) - aPadding.ISize(aWM);
    result.ISize(aWM) = ShrinkWidthToFit(aRenderingContext, availBased, aFlags);
  }
  return result;
}

nscoord
nsFrame::ShrinkWidthToFit(nsRenderingContext* aRenderingContext,
                          nscoord             aISizeInCB,
                          ComputeSizeFlags    aFlags)
{
  // If we're a container for font size inflation, then shrink
  // wrapping inside of us should not apply font size inflation.
  AutoMaybeDisableFontInflation an(this);

  nscoord result;
  nscoord minISize = GetMinISize(aRenderingContext);
  if (minISize > aISizeInCB) {
    const bool clamp = aFlags & ComputeSizeFlags::eIClampMarginBoxMinSize;
    result = MOZ_UNLIKELY(clamp) ? aISizeInCB : minISize;
  } else {
    nscoord prefISize = GetPrefISize(aRenderingContext);
    if (prefISize > aISizeInCB) {
      result = aISizeInCB;
    } else {
      result = prefISize;
    }
  }
  return result;
}

nscoord
nsIFrame::ComputeISizeValue(nsRenderingContext* aRenderingContext,
                            nscoord             aContainingBlockISize,
                            nscoord             aContentEdgeToBoxSizing,
                            nscoord             aBoxSizingToMarginEdge,
                            const nsStyleCoord& aCoord,
                            ComputeSizeFlags    aFlags)
{
  NS_PRECONDITION(aRenderingContext, "non-null rendering context expected");
  LAYOUT_WARN_IF_FALSE(aContainingBlockISize != NS_UNCONSTRAINEDSIZE,
                       "have unconstrained inline-size; this should only result from "
                       "very large sizes, not attempts at intrinsic inline-size "
                       "calculation");
  NS_PRECONDITION(aContainingBlockISize >= 0,
                  "inline-size less than zero");

  nscoord result;
  if (aCoord.IsCoordPercentCalcUnit()) {
    result = nsRuleNode::ComputeCoordPercentCalc(aCoord,
                                                 aContainingBlockISize);
    // The result of a calc() expression might be less than 0; we
    // should clamp at runtime (below).  (Percentages and coords that
    // are less than 0 have already been dropped by the parser.)
    result -= aContentEdgeToBoxSizing;
  } else {
    MOZ_ASSERT(eStyleUnit_Enumerated == aCoord.GetUnit());
    // If 'this' is a container for font size inflation, then shrink
    // wrapping inside of it should not apply font size inflation.
    AutoMaybeDisableFontInflation an(this);

    int32_t val = aCoord.GetIntValue();
    switch (val) {
      case NS_STYLE_WIDTH_MAX_CONTENT:
        result = GetPrefISize(aRenderingContext);
        NS_ASSERTION(result >= 0, "inline-size less than zero");
        break;
      case NS_STYLE_WIDTH_MIN_CONTENT:
        result = GetMinISize(aRenderingContext);
        NS_ASSERTION(result >= 0, "inline-size less than zero");
        if (MOZ_UNLIKELY(aFlags & ComputeSizeFlags::eIClampMarginBoxMinSize)) {
          auto available = aContainingBlockISize -
                           (aBoxSizingToMarginEdge + aContentEdgeToBoxSizing);
          result = std::min(available, result);
        }
        break;
      case NS_STYLE_WIDTH_FIT_CONTENT:
        {
          nscoord pref = GetPrefISize(aRenderingContext),
                   min = GetMinISize(aRenderingContext),
                  fill = aContainingBlockISize -
                         (aBoxSizingToMarginEdge + aContentEdgeToBoxSizing);
          if (MOZ_UNLIKELY(aFlags & ComputeSizeFlags::eIClampMarginBoxMinSize)) {
            min = std::min(min, fill);
          }
          result = std::max(min, std::min(pref, fill));
          NS_ASSERTION(result >= 0, "inline-size less than zero");
        }
        break;
      case NS_STYLE_WIDTH_AVAILABLE:
        result = aContainingBlockISize -
                 (aBoxSizingToMarginEdge + aContentEdgeToBoxSizing);
    }
  }

  return std::max(0, result);
}

void
nsFrame::DidReflow(nsPresContext*           aPresContext,
                   const ReflowInput*  aReflowInput,
                   nsDidReflowStatus         aStatus)
{
  NS_FRAME_TRACE_MSG(NS_FRAME_TRACE_CALLS,
                     ("nsFrame::DidReflow: aStatus=%d", static_cast<uint32_t>(aStatus)));

  nsSVGEffects::InvalidateDirectRenderingObservers(this, nsSVGEffects::INVALIDATE_REFLOW);

  if (nsDidReflowStatus::FINISHED == aStatus) {
    mState &= ~(NS_FRAME_IN_REFLOW | NS_FRAME_FIRST_REFLOW | NS_FRAME_IS_DIRTY |
                NS_FRAME_HAS_DIRTY_CHILDREN);
  }

  // Notify the percent bsize observer if there is a percent bsize.
  // The observer may be able to initiate another reflow with a computed
  // bsize. This happens in the case where a table cell has no computed
  // bsize but can fabricate one when the cell bsize is known.
  if (aReflowInput && aReflowInput->mPercentBSizeObserver &&
      !GetPrevInFlow()) {
    const nsStyleCoord &bsize =
      aReflowInput->mStylePosition->BSize(aReflowInput->GetWritingMode());
    if (bsize.HasPercent()) {
      aReflowInput->mPercentBSizeObserver->NotifyPercentBSize(*aReflowInput);
    }
  }

  aPresContext->ReflowedFrame();
}

void
nsFrame::FinishReflowWithAbsoluteFrames(nsPresContext*           aPresContext,
                                        ReflowOutput&     aDesiredSize,
                                        const ReflowInput& aReflowInput,
                                        nsReflowStatus&          aStatus,
                                        bool                     aConstrainBSize)
{
  ReflowAbsoluteFrames(aPresContext, aDesiredSize, aReflowInput, aStatus, aConstrainBSize);

  FinishAndStoreOverflow(&aDesiredSize);
}

void
nsFrame::ReflowAbsoluteFrames(nsPresContext*           aPresContext,
                              ReflowOutput&     aDesiredSize,
                              const ReflowInput& aReflowInput,
                              nsReflowStatus&          aStatus,
                              bool                     aConstrainBSize)
{
  if (HasAbsolutelyPositionedChildren()) {
    nsAbsoluteContainingBlock* absoluteContainer = GetAbsoluteContainingBlock();

    // Let the absolutely positioned container reflow any absolutely positioned
    // child frames that need to be reflowed

    // The containing block for the abs pos kids is formed by our padding edge.
    nsMargin usedBorder = GetUsedBorder();
    nscoord containingBlockWidth =
      std::max(0, aDesiredSize.Width() - usedBorder.LeftRight());
    nscoord containingBlockHeight =
      std::max(0, aDesiredSize.Height() - usedBorder.TopBottom());
    nsContainerFrame* container = do_QueryFrame(this);
    NS_ASSERTION(container, "Abs-pos children only supported on container frames for now");

    nsRect containingBlock(0, 0, containingBlockWidth, containingBlockHeight);
    AbsPosReflowFlags flags =
      AbsPosReflowFlags::eCBWidthAndHeightChanged; // XXX could be optimized
    if (aConstrainBSize) {
      flags |= AbsPosReflowFlags::eConstrainHeight;
    }
    absoluteContainer->Reflow(container, aPresContext, aReflowInput, aStatus,
                              containingBlock, flags,
                              &aDesiredSize.mOverflowAreas);
  }
}

void
nsFrame::PushDirtyBitToAbsoluteFrames()
{
  if (!(GetStateBits() & NS_FRAME_IS_DIRTY)) {
    return;  // No dirty bit to push.
  }
  if (!HasAbsolutelyPositionedChildren()) {
    return;  // No absolute children to push to.
  }
  GetAbsoluteContainingBlock()->MarkAllFramesDirty();
}

/* virtual */ bool
nsFrame::CanContinueTextRun() const
{
  // By default, a frame will *not* allow a text run to be continued
  // through it.
  return false;
}

void
nsFrame::Reflow(nsPresContext*          aPresContext,
                ReflowOutput&     aDesiredSize,
                const ReflowInput& aReflowInput,
                nsReflowStatus&          aStatus)
{
  MarkInReflow();
  DO_GLOBAL_REFLOW_COUNT("nsFrame");
  aDesiredSize.ClearSize();
  aStatus = NS_FRAME_COMPLETE;
  NS_FRAME_SET_TRUNCATION(aStatus, aReflowInput, aDesiredSize);
}

nsresult
nsFrame::CharacterDataChanged(CharacterDataChangeInfo* aInfo)
{
  NS_NOTREACHED("should only be called for text frames");
  return NS_OK;
}

nsresult
nsFrame::AttributeChanged(int32_t         aNameSpaceID,
                          nsIAtom*        aAttribute,
                          int32_t         aModType)
{
  return NS_OK;
}

// Flow member functions

nsSplittableType
nsFrame::GetSplittableType() const
{
  return NS_FRAME_NOT_SPLITTABLE;
}

nsIFrame* nsFrame::GetPrevContinuation() const
{
  return nullptr;
}

void
nsFrame::SetPrevContinuation(nsIFrame* aPrevContinuation)
{
  MOZ_ASSERT(false, "not splittable");
}

nsIFrame* nsFrame::GetNextContinuation() const
{
  return nullptr;
}

void
nsFrame::SetNextContinuation(nsIFrame*)
{
  MOZ_ASSERT(false, "not splittable");
}

nsIFrame* nsFrame::GetPrevInFlowVirtual() const
{
  return nullptr;
}

void
nsFrame::SetPrevInFlow(nsIFrame* aPrevInFlow)
{
  MOZ_ASSERT(false, "not splittable");
}

nsIFrame* nsFrame::GetNextInFlowVirtual() const
{
  return nullptr;
}

void
nsFrame::SetNextInFlow(nsIFrame*)
{
  MOZ_ASSERT(false, "not splittable");
}

nsIFrame* nsIFrame::GetTailContinuation()
{
  nsIFrame* frame = this;
  while (frame->GetStateBits() & NS_FRAME_IS_OVERFLOW_CONTAINER) {
    frame = frame->GetPrevContinuation();
    NS_ASSERTION(frame, "first continuation can't be overflow container");
  }
  for (nsIFrame* next = frame->GetNextContinuation();
       next && !(next->GetStateBits() & NS_FRAME_IS_OVERFLOW_CONTAINER);
       next = frame->GetNextContinuation())  {
    frame = next;
  }
  NS_POSTCONDITION(frame, "illegal state in continuation chain.");
  return frame;
}

NS_DECLARE_FRAME_PROPERTY_WITHOUT_DTOR(ViewProperty, nsView)

// Associated view object
nsView*
nsIFrame::GetView() const
{
  // Check the frame state bit and see if the frame has a view
  if (!(GetStateBits() & NS_FRAME_HAS_VIEW))
    return nullptr;

  // Check for a property on the frame
  nsView* value = Properties().Get(ViewProperty());
  NS_ASSERTION(value, "frame state bit was set but frame has no view");
  return value;
}

nsresult
nsIFrame::SetView(nsView* aView)
{
  if (aView) {
    aView->SetFrame(this);

#ifdef DEBUG
    nsIAtom* frameType = GetType();
    NS_ASSERTION(frameType == nsGkAtoms::scrollFrame ||
                 frameType == nsGkAtoms::subDocumentFrame ||
                 frameType == nsGkAtoms::listControlFrame ||
                 frameType == nsGkAtoms::objectFrame ||
                 frameType == nsGkAtoms::viewportFrame ||
                 frameType == nsGkAtoms::menuPopupFrame,
                 "Only specific frame types can have an nsView");
#endif

    // Set a property on the frame
    Properties().Set(ViewProperty(), aView);

    // Set the frame state bit that says the frame has a view
    AddStateBits(NS_FRAME_HAS_VIEW);

    // Let all of the ancestors know they have a descendant with a view.
    for (nsIFrame* f = GetParent();
         f && !(f->GetStateBits() & NS_FRAME_HAS_CHILD_WITH_VIEW);
         f = f->GetParent())
      f->AddStateBits(NS_FRAME_HAS_CHILD_WITH_VIEW);
  }

  return NS_OK;
}

// Find the first geometric parent that has a view
nsIFrame* nsIFrame::GetAncestorWithView() const
{
  for (nsIFrame* f = GetParent(); nullptr != f; f = f->GetParent()) {
    if (f->HasView()) {
      return f;
    }
  }
  return nullptr;
}

nsPoint nsIFrame::GetOffsetTo(const nsIFrame* aOther) const
{
  NS_PRECONDITION(aOther,
                  "Must have frame for destination coordinate system!");

  NS_ASSERTION(PresContext() == aOther->PresContext(),
               "GetOffsetTo called on frames in different documents");

  nsPoint offset(0, 0);
  const nsIFrame* f;
  for (f = this; f != aOther && f; f = f->GetParent()) {
    offset += f->GetPosition();
  }

  if (f != aOther) {
    // Looks like aOther wasn't an ancestor of |this|.  So now we have
    // the root-frame-relative position of |this| in |offset|.  Convert back
    // to the coordinates of aOther
    while (aOther) {
      offset -= aOther->GetPosition();
      aOther = aOther->GetParent();
    }
  }

  return offset;
}

nsPoint nsIFrame::GetOffsetToCrossDoc(const nsIFrame* aOther) const
{
  return GetOffsetToCrossDoc(aOther, PresContext()->AppUnitsPerDevPixel());
}

nsPoint
nsIFrame::GetOffsetToCrossDoc(const nsIFrame* aOther, const int32_t aAPD) const
{
  NS_PRECONDITION(aOther,
                  "Must have frame for destination coordinate system!");
  NS_ASSERTION(PresContext()->GetRootPresContext() ==
                 aOther->PresContext()->GetRootPresContext(),
               "trying to get the offset between frames in different document "
               "hierarchies?");
  if (PresContext()->GetRootPresContext() !=
        aOther->PresContext()->GetRootPresContext()) {
    // crash right away, we are almost certainly going to crash anyway.
    NS_RUNTIMEABORT("trying to get the offset between frames in different "
                    "document hierarchies?");
  }

  const nsIFrame* root = nullptr;
  // offset will hold the final offset
  // docOffset holds the currently accumulated offset at the current APD, it
  // will be converted and added to offset when the current APD changes.
  nsPoint offset(0, 0), docOffset(0, 0);
  const nsIFrame* f = this;
  int32_t currAPD = PresContext()->AppUnitsPerDevPixel();
  while (f && f != aOther) {
    docOffset += f->GetPosition();
    nsIFrame* parent = f->GetParent();
    if (parent) {
      f = parent;
    } else {
      nsPoint newOffset(0, 0);
      root = f;
      f = nsLayoutUtils::GetCrossDocParentFrame(f, &newOffset);
      int32_t newAPD = f ? f->PresContext()->AppUnitsPerDevPixel() : 0;
      if (!f || newAPD != currAPD) {
        // Convert docOffset to the right APD and add it to offset.
        offset += docOffset.ScaleToOtherAppUnits(currAPD, aAPD);
        docOffset.x = docOffset.y = 0;
      }
      currAPD = newAPD;
      docOffset += newOffset;
    }
  }
  if (f == aOther) {
    offset += docOffset.ScaleToOtherAppUnits(currAPD, aAPD);
  } else {
    // Looks like aOther wasn't an ancestor of |this|.  So now we have
    // the root-document-relative position of |this| in |offset|. Subtract the
    // root-document-relative position of |aOther| from |offset|.
    // This call won't try to recurse again because root is an ancestor of
    // aOther.
    nsPoint negOffset = aOther->GetOffsetToCrossDoc(root, aAPD);
    offset -= negOffset;
  }

  return offset;
}

nsIntRect nsIFrame::GetScreenRect() const
{
  return GetScreenRectInAppUnits().ToNearestPixels(PresContext()->AppUnitsPerCSSPixel());
}

nsRect nsIFrame::GetScreenRectInAppUnits() const
{
  nsPresContext* presContext = PresContext();
  nsIFrame* rootFrame =
    presContext->PresShell()->FrameManager()->GetRootFrame();
  nsPoint rootScreenPos(0, 0);
  nsPoint rootFrameOffsetInParent(0, 0);
  nsIFrame* rootFrameParent =
    nsLayoutUtils::GetCrossDocParentFrame(rootFrame, &rootFrameOffsetInParent);
  if (rootFrameParent) {
    nsRect parentScreenRectAppUnits = rootFrameParent->GetScreenRectInAppUnits();
    nsPresContext* parentPresContext = rootFrameParent->PresContext();
    double parentScale = double(presContext->AppUnitsPerDevPixel())/
        parentPresContext->AppUnitsPerDevPixel();
    nsPoint rootPt = parentScreenRectAppUnits.TopLeft() + rootFrameOffsetInParent;
    rootScreenPos.x = NS_round(parentScale*rootPt.x);
    rootScreenPos.y = NS_round(parentScale*rootPt.y);
  } else {
    nsCOMPtr<nsIWidget> rootWidget;
    presContext->PresShell()->GetViewManager()->GetRootWidget(getter_AddRefs(rootWidget));
    if (rootWidget) {
      LayoutDeviceIntPoint rootDevPx = rootWidget->WidgetToScreenOffset();
      rootScreenPos.x = presContext->DevPixelsToAppUnits(rootDevPx.x);
      rootScreenPos.y = presContext->DevPixelsToAppUnits(rootDevPx.y);
    }
  }

  return nsRect(rootScreenPos + GetOffsetTo(rootFrame), GetSize());
}

// Returns the offset from this frame to the closest geometric parent that
// has a view. Also returns the containing view or null in case of error
void
nsIFrame::GetOffsetFromView(nsPoint& aOffset, nsView** aView) const
{
  NS_PRECONDITION(nullptr != aView, "null OUT parameter pointer");
  nsIFrame* frame = const_cast<nsIFrame*>(this);

  *aView = nullptr;
  aOffset.MoveTo(0, 0);
  do {
    aOffset += frame->GetPosition();
    frame = frame->GetParent();
  } while (frame && !frame->HasView());

  if (frame) {
    *aView = frame->GetView();
  }
}

nsIWidget*
nsIFrame::GetNearestWidget() const
{
  return GetClosestView()->GetNearestWidget(nullptr);
}

nsIWidget*
nsIFrame::GetNearestWidget(nsPoint& aOffset) const
{
  nsPoint offsetToView;
  nsPoint offsetToWidget;
  nsIWidget* widget =
    GetClosestView(&offsetToView)->GetNearestWidget(&offsetToWidget);
  aOffset = offsetToView + offsetToWidget;
  return widget;
}

nsIAtom*
nsFrame::GetType() const
{
  return nullptr;
}

bool
nsIFrame::IsLeaf() const
{
  return true;
}

Matrix4x4
nsIFrame::GetTransformMatrix(const nsIFrame* aStopAtAncestor,
                             nsIFrame** aOutAncestor)
{
  NS_PRECONDITION(aOutAncestor, "Need a place to put the ancestor!");

  /* If we're transformed, we want to hand back the combination
   * transform/translate matrix that will apply our current transform, then
   * shift us to our parent.
   */
  if (IsTransformed()) {
    /* Compute the delta to the parent, which we need because we are converting
     * coordinates to our parent.
     */
    NS_ASSERTION(nsLayoutUtils::GetCrossDocParentFrame(this),
                 "Cannot transform the viewport frame!");
    int32_t scaleFactor = PresContext()->AppUnitsPerDevPixel();

    Matrix4x4 result = nsDisplayTransform::GetResultingTransformMatrix(this,
                         nsPoint(0,0), scaleFactor,
                         nsDisplayTransform::INCLUDE_PERSPECTIVE|nsDisplayTransform::OFFSET_BY_ORIGIN,
                         nullptr);
    *aOutAncestor = nsLayoutUtils::GetCrossDocParentFrame(this);
    nsPoint delta = GetOffsetToCrossDoc(*aOutAncestor);
    /* Combine the raw transform with a translation to our parent. */
    result.PostTranslate(NSAppUnitsToFloatPixels(delta.x, scaleFactor),
                         NSAppUnitsToFloatPixels(delta.y, scaleFactor),
                         0.0f);

    return result;
  }

  if (nsLayoutUtils::IsPopup(this) &&
      GetType() == nsGkAtoms::listControlFrame) {
    nsPresContext* presContext = PresContext();
    nsIFrame* docRootFrame = presContext->PresShell()->GetRootFrame();

    // Compute a matrix that transforms from the popup widget to the toplevel
    // widget. We use the widgets because they're the simplest and most
    // accurate approach --- this should work no matter how the widget position
    // was chosen.
    nsIWidget* widget = GetView()->GetWidget();
    nsPresContext* rootPresContext = PresContext()->GetRootPresContext();
    // Maybe the widget hasn't been created yet? Popups without widgets are
    // treated as regular frames. That should work since they'll be rendered
    // as part of the page if they're rendered at all.
    if (widget && rootPresContext) {
      nsIWidget* toplevel = rootPresContext->GetNearestWidget();
      if (toplevel) {
        LayoutDeviceIntRect screenBounds = widget->GetClientBounds();
        LayoutDeviceIntRect toplevelScreenBounds = toplevel->GetClientBounds();
        LayoutDeviceIntPoint translation =
          screenBounds.TopLeft() - toplevelScreenBounds.TopLeft();

        Matrix4x4 transformToTop;
        transformToTop._41 = translation.x;
        transformToTop._42 = translation.y;

        *aOutAncestor = docRootFrame;
        Matrix4x4 docRootTransformToTop =
          nsLayoutUtils::GetTransformToAncestor(docRootFrame, nullptr);
        if (docRootTransformToTop.IsSingular()) {
          NS_WARNING("Containing document is invisible, we can't compute a valid transform");
        } else {
          docRootTransformToTop.Invert();
          return transformToTop * docRootTransformToTop;
        }
      }
    }
  }

  *aOutAncestor = nsLayoutUtils::GetCrossDocParentFrame(this);

  /* Otherwise, we're not transformed.  In that case, we'll walk up the frame
   * tree until we either hit the root frame or something that may be
   * transformed.  We'll then change coordinates into that frame, since we're
   * guaranteed that nothing in-between can be transformed.  First, however,
   * we have to check to see if we have a parent.  If not, we'll set the
   * outparam to null (indicating that there's nothing left) and will hand back
   * the identity matrix.
   */
  if (!*aOutAncestor)
    return Matrix4x4();

  /* Keep iterating while the frame can't possibly be transformed. */
  while (!(*aOutAncestor)->IsTransformed() &&
         !nsLayoutUtils::IsPopup(*aOutAncestor) &&
         *aOutAncestor != aStopAtAncestor) {
    /* If no parent, stop iterating.  Otherwise, update the ancestor. */
    nsIFrame* parent = nsLayoutUtils::GetCrossDocParentFrame(*aOutAncestor);
    if (!parent)
      break;

    *aOutAncestor = parent;
  }

  NS_ASSERTION(*aOutAncestor, "Somehow ended up with a null ancestor...?");

  /* Translate from this frame to our ancestor, if it exists.  That's the
   * entire transform, so we're done.
   */
  nsPoint delta = GetOffsetToCrossDoc(*aOutAncestor);
  int32_t scaleFactor = PresContext()->AppUnitsPerDevPixel();
  return Matrix4x4::Translation(NSAppUnitsToFloatPixels(delta.x, scaleFactor),
                                NSAppUnitsToFloatPixels(delta.y, scaleFactor),
                                0.0f);
}

static void InvalidateRenderingObservers(nsIFrame* aFrame)
{
  nsSVGEffects::InvalidateDirectRenderingObservers(aFrame);
  nsIFrame* displayRoot = nsLayoutUtils::GetDisplayRootFrame(aFrame);
  nsIFrame* parent = aFrame;
  while (parent != displayRoot &&
         (parent = nsLayoutUtils::GetCrossDocParentFrame(parent)) &&
         !parent->HasAnyStateBits(NS_FRAME_DESCENDANT_NEEDS_PAINT)) {
    nsSVGEffects::InvalidateDirectRenderingObservers(parent);
  }
}

void
SchedulePaintInternal(nsIFrame* aFrame, nsIFrame::PaintType aType = nsIFrame::PAINT_DEFAULT)
{
  nsIFrame* displayRoot = nsLayoutUtils::GetDisplayRootFrame(aFrame);
  nsPresContext* pres = displayRoot->PresContext()->GetRootPresContext();

  // No need to schedule a paint for an external document since they aren't
  // painted directly.
  if (!pres || (pres->Document() && pres->Document()->IsResourceDoc())) {
    return;
  }
  if (!pres->GetContainerWeak()) {
    NS_WARNING("Shouldn't call SchedulePaint in a detached pres context");
    return;
  }

  pres->PresShell()->ScheduleViewManagerFlush(aType == nsIFrame::PAINT_DELAYED_COMPRESS ?
                                              nsIPresShell::PAINT_DELAYED_COMPRESS :
                                              nsIPresShell::PAINT_DEFAULT);

  if (aType == nsIFrame::PAINT_DELAYED_COMPRESS) {
    return;
  }

  if (aType == nsIFrame::PAINT_DEFAULT) {
    displayRoot->AddStateBits(NS_FRAME_UPDATE_LAYER_TREE);
  }
  nsIPresShell* shell = aFrame->PresContext()->PresShell();
  if (shell) {
    shell->AddInvalidateHiddenPresShellObserver(pres->RefreshDriver());
  }
}

static void InvalidateFrameInternal(nsIFrame *aFrame, bool aHasDisplayItem = true)
{
  if (aHasDisplayItem) {
    aFrame->AddStateBits(NS_FRAME_NEEDS_PAINT);
  }
  nsSVGEffects::InvalidateDirectRenderingObservers(aFrame);
  bool needsSchedulePaint = false;
  if (nsLayoutUtils::IsPopup(aFrame)) {
    needsSchedulePaint = true;
  } else {
    nsIFrame *parent = nsLayoutUtils::GetCrossDocParentFrame(aFrame);
    while (parent && !parent->HasAnyStateBits(NS_FRAME_DESCENDANT_NEEDS_PAINT)) {
      if (aHasDisplayItem && !parent->HasAnyStateBits(NS_FRAME_IS_NONDISPLAY)) {
        parent->AddStateBits(NS_FRAME_DESCENDANT_NEEDS_PAINT);
      }
      nsSVGEffects::InvalidateDirectRenderingObservers(parent);

      // If we're inside a popup, then we need to make sure that we
      // call schedule paint so that the NS_FRAME_UPDATE_LAYER_TREE
      // flag gets added to the popup display root frame.
      if (nsLayoutUtils::IsPopup(parent)) {
        needsSchedulePaint = true;
        break;
      }
      parent = nsLayoutUtils::GetCrossDocParentFrame(parent);
    }
    if (!parent) {
      needsSchedulePaint = true;
    }
  }
  if (!aHasDisplayItem) {
    return;
  }
  if (needsSchedulePaint) {
    SchedulePaintInternal(aFrame);
  }
  if (aFrame->HasAnyStateBits(NS_FRAME_HAS_INVALID_RECT)) {
    aFrame->Properties().Delete(nsIFrame::InvalidationRect());
    aFrame->RemoveStateBits(NS_FRAME_HAS_INVALID_RECT);
  }
}

void
nsIFrame::InvalidateFrameSubtree(uint32_t aDisplayItemKey)
{
  bool hasDisplayItem = 
    !aDisplayItemKey || FrameLayerBuilder::HasRetainedDataFor(this, aDisplayItemKey);
  InvalidateFrame(aDisplayItemKey);

  if (HasAnyStateBits(NS_FRAME_ALL_DESCENDANTS_NEED_PAINT) || !hasDisplayItem) {
    return;
  }

  AddStateBits(NS_FRAME_ALL_DESCENDANTS_NEED_PAINT);
  
  AutoTArray<nsIFrame::ChildList,4> childListArray;
  GetCrossDocChildLists(&childListArray);

  nsIFrame::ChildListArrayIterator lists(childListArray);
  for (; !lists.IsDone(); lists.Next()) {
    nsFrameList::Enumerator childFrames(lists.CurrentList());
    for (; !childFrames.AtEnd(); childFrames.Next()) {
      childFrames.get()->InvalidateFrameSubtree();
    }
  }
}

void
nsIFrame::ClearInvalidationStateBits()
{
  if (HasAnyStateBits(NS_FRAME_DESCENDANT_NEEDS_PAINT)) {
    AutoTArray<nsIFrame::ChildList,4> childListArray;
    GetCrossDocChildLists(&childListArray);

    nsIFrame::ChildListArrayIterator lists(childListArray);
    for (; !lists.IsDone(); lists.Next()) {
      nsFrameList::Enumerator childFrames(lists.CurrentList());
      for (; !childFrames.AtEnd(); childFrames.Next()) {
        childFrames.get()->ClearInvalidationStateBits();
      }
    }
  }

  RemoveStateBits(NS_FRAME_NEEDS_PAINT | 
                  NS_FRAME_DESCENDANT_NEEDS_PAINT | 
                  NS_FRAME_ALL_DESCENDANTS_NEED_PAINT);
}

void
nsIFrame::InvalidateFrame(uint32_t aDisplayItemKey)
{
  bool hasDisplayItem = 
    !aDisplayItemKey || FrameLayerBuilder::HasRetainedDataFor(this, aDisplayItemKey);
  InvalidateFrameInternal(this, hasDisplayItem);
}

void
nsIFrame::InvalidateFrameWithRect(const nsRect& aRect, uint32_t aDisplayItemKey)
{
  bool hasDisplayItem = 
    !aDisplayItemKey || FrameLayerBuilder::HasRetainedDataFor(this, aDisplayItemKey);
  bool alreadyInvalid = false;
  if (!HasAnyStateBits(NS_FRAME_NEEDS_PAINT)) {
    InvalidateFrameInternal(this, hasDisplayItem);
  } else {
    alreadyInvalid = true;
  } 

  if (!hasDisplayItem) {
    return;
  }

  nsRect* rect = Properties().Get(InvalidationRect());
  if (!rect) {
    if (alreadyInvalid) {
      return;
    }
    rect = new nsRect();
    Properties().Set(InvalidationRect(), rect);
    AddStateBits(NS_FRAME_HAS_INVALID_RECT);
  }

  *rect = rect->Union(aRect);
}

/*static*/ uint8_t nsIFrame::sLayerIsPrerenderedDataKey;

static bool
DoesLayerHaveOutOfDateFrameMetrics(Layer* aLayer)
{
  for (uint32_t i = 0; i < aLayer->GetScrollMetadataCount(); i++) {
    const FrameMetrics& metrics = aLayer->GetFrameMetrics(i);
    if (!metrics.IsScrollable()) {
      continue;
    }
    nsIScrollableFrame* scrollableFrame =
      nsLayoutUtils::FindScrollableFrameFor(metrics.GetScrollId());
    if (!scrollableFrame) {
      // This shouldn't happen, so let's do the safe thing and trigger a full
      // paint if it does.
      return true;
    }
    nsPoint scrollPosition = scrollableFrame->GetScrollPosition();
    if (metrics.GetScrollOffset() != CSSPoint::FromAppUnits(scrollPosition)) {
      return true;
    }
  }
  return false;
}

static bool
DoesLayerOrAncestorsHaveOutOfDateFrameMetrics(Layer* aLayer)
{
  for (Layer* layer = aLayer; layer; layer = layer->GetParent()) {
    if (DoesLayerHaveOutOfDateFrameMetrics(layer)) {
      return true;
    }
  }
  return false;
}

bool
nsIFrame::TryUpdateTransformOnly(Layer** aLayerResult)
{
  Layer* layer = FrameLayerBuilder::GetDedicatedLayer(
    this, nsDisplayItem::TYPE_TRANSFORM);
  if (!layer || !layer->HasUserData(LayerIsPrerenderedDataKey())) {
    // If this layer isn't prerendered or we clip composites to our OS
    // window, then we can't correctly optimize to an empty
    // transaction in general.
    return false;
  }

  if (DoesLayerOrAncestorsHaveOutOfDateFrameMetrics(layer)) {
    // At least one scroll frame that can affect the position of this layer
    // has changed its scroll offset since the last paint. Schedule a full
    // paint to make sure that this layer's transform and all the frame
    // metrics that affect it are in sync.
    return false;
  }

  gfx::Matrix4x4 transform3d;
  if (!nsLayoutUtils::GetLayerTransformForFrame(this, &transform3d)) {
    // We're not able to compute a layer transform that we know would
    // be used at the next layers transaction, so we can't only update
    // the transform and will need to schedule an invalidating paint.
    return false;
  }
  gfx::Matrix transform;
  gfx::Matrix previousTransform;
  // FIXME/bug 796690 and 796705: in general, changes to 3D
  // transforms, or transform changes to properties other than
  // translation, may lead us to choose a different rendering
  // resolution for our layer.  So if the transform is 3D or has a
  // non-translation change, bail and schedule an invalidating paint.
  // (We can often do better than this, for example for scale-down
  // changes.)
 static const gfx::Float kError = 0.0001f;
  if (!transform3d.Is2D(&transform) ||
      !layer->GetBaseTransform().Is2D(&previousTransform) ||
      !gfx::FuzzyEqual(transform._11, previousTransform._11, kError) ||
      !gfx::FuzzyEqual(transform._22, previousTransform._22, kError) ||
      !gfx::FuzzyEqual(transform._21, previousTransform._21, kError) ||
      !gfx::FuzzyEqual(transform._12, previousTransform._12, kError)) {
    return false;
  }
  layer->SetBaseTransformForNextTransaction(transform3d);
  *aLayerResult = layer;
  return true;
}

bool 
nsIFrame::IsInvalid(nsRect& aRect)
{
  if (!HasAnyStateBits(NS_FRAME_NEEDS_PAINT)) {
    return false;
  }
  
  if (HasAnyStateBits(NS_FRAME_HAS_INVALID_RECT)) {
    nsRect* rect = Properties().Get(InvalidationRect());
    NS_ASSERTION(rect, "Must have an invalid rect if NS_FRAME_HAS_INVALID_RECT is set!");
    aRect = *rect;
  } else {
    aRect.SetEmpty();
  }
  return true;
}

void
nsIFrame::SchedulePaint(PaintType aType)
{
  InvalidateRenderingObservers(this);
  SchedulePaintInternal(this, aType);
}

Layer*
nsIFrame::InvalidateLayer(uint32_t aDisplayItemKey,
                          const nsIntRect* aDamageRect,
                          const nsRect* aFrameDamageRect,
                          uint32_t aFlags /* = 0 */)
{
  NS_ASSERTION(aDisplayItemKey > 0, "Need a key");

  Layer* layer = FrameLayerBuilder::GetDedicatedLayer(this, aDisplayItemKey);

  InvalidateRenderingObservers(this);

  // If the layer is being updated asynchronously, and it's being forwarded
  // to a compositor, then we don't need to invalidate.
  if ((aFlags & UPDATE_IS_ASYNC) && layer &&
      layer->Manager()->GetBackendType() == LayersBackend::LAYERS_CLIENT) {
    return layer;
  }

  if (!layer) {
    if (aFrameDamageRect && aFrameDamageRect->IsEmpty()) {
      return nullptr;
    }

    // Plugins can transition from not rendering anything to rendering,
    // and still only call this. So always invalidate, with specifying
    // the display item type just in case.
    //
    // In the bug 930056, dialer app startup but not shown on the
    // screen because sometimes we don't have any retainned data
    // for remote type displayitem and thus Repaint event is not
    // triggered. So, always invalidate here as well.
    uint32_t displayItemKey = aDisplayItemKey;
    if (aDisplayItemKey == nsDisplayItem::TYPE_PLUGIN ||
        aDisplayItemKey == nsDisplayItem::TYPE_REMOTE) {
      displayItemKey = 0;
    }

    if (aFrameDamageRect) {
      InvalidateFrameWithRect(*aFrameDamageRect, displayItemKey);
    } else {
      InvalidateFrame(displayItemKey);
    }

    return nullptr;
  }

  if (aDamageRect && aDamageRect->IsEmpty()) {
    return layer;
  }

  if (aDamageRect) {
    layer->AddInvalidRect(*aDamageRect);
  } else {
    layer->SetInvalidRectToVisibleRegion();
  }

  SchedulePaintInternal(this, PAINT_COMPOSITE_ONLY);
  return layer;
}

static nsRect
ComputeEffectsRect(nsIFrame* aFrame, const nsRect& aOverflowRect,
                   const nsSize& aNewSize)
{
  nsRect r = aOverflowRect;

  if (aFrame->GetStateBits() & NS_FRAME_SVG_LAYOUT) {
    // For SVG frames, we only need to account for filters.
    // TODO: We could also take account of clipPath and mask to reduce the
    // visual overflow, but that's not essential.
    if (aFrame->StyleEffects()->HasFilters()) {
      aFrame->Properties().
        Set(nsIFrame::PreEffectsBBoxProperty(), new nsRect(r));
      r = nsSVGUtils::GetPostFilterVisualOverflowRect(aFrame, aOverflowRect);
    }
    return r;
  }

  // box-shadow
  r.UnionRect(r, nsLayoutUtils::GetBoxShadowRectForFrame(aFrame, aNewSize));

  // border-image-outset.
  // We need to include border-image-outset because it can cause the
  // border image to be drawn beyond the border box.

  // (1) It's important we not check whether there's a border-image
  //     since the style hint for a change in border image doesn't cause
  //     reflow, and that's probably more important than optimizing the
  //     overflow areas for the silly case of border-image-outset without
  //     border-image
  // (2) It's important that we not check whether the border-image
  //     is actually loaded, since that would require us to reflow when
  //     the image loads.
  const nsStyleBorder* styleBorder = aFrame->StyleBorder();
  nsMargin outsetMargin = styleBorder->GetImageOutset();

  if (outsetMargin != nsMargin(0, 0, 0, 0)) {
    nsRect outsetRect(nsPoint(0, 0), aNewSize);
    outsetRect.Inflate(outsetMargin);
    r.UnionRect(r, outsetRect);
  }

  // Note that we don't remove the outlineInnerRect if a frame loses outline
  // style. That would require an extra property lookup for every frame,
  // or a new frame state bit to track whether a property had been stored,
  // or something like that. It's not worth doing that here. At most it's
  // only one heap-allocated rect per frame and it will be cleaned up when
  // the frame dies.

  if (nsSVGIntegrationUtils::UsingEffectsForFrame(aFrame)) {
    aFrame->Properties().
      Set(nsIFrame::PreEffectsBBoxProperty(), new nsRect(r));
    r = nsSVGIntegrationUtils::ComputePostEffectsVisualOverflowRect(aFrame, r);
  }

  return r;
}

void
nsIFrame::MovePositionBy(const nsPoint& aTranslation)
{
  nsPoint position = GetNormalPosition() + aTranslation;

  const nsMargin* computedOffsets = nullptr;
  if (IsRelativelyPositioned()) {
    computedOffsets = Properties().Get(nsIFrame::ComputedOffsetProperty());
  }
  ReflowInput::ApplyRelativePositioning(this, computedOffsets ?
                                              *computedOffsets : nsMargin(),
                                              &position);
  SetPosition(position);
}

nsRect
nsIFrame::GetNormalRect() const
{
  // It might be faster to first check
  // StyleDisplay()->IsRelativelyPositionedStyle().
  nsPoint* normalPosition = Properties().Get(NormalPositionProperty());
  if (normalPosition) {
    return nsRect(*normalPosition, GetSize());
  }
  return GetRect();
}

nsPoint
nsIFrame::GetNormalPosition() const
{
  // It might be faster to first check
  // StyleDisplay()->IsRelativelyPositionedStyle().
  nsPoint* normalPosition = Properties().Get(NormalPositionProperty());
  if (normalPosition) {
    return *normalPosition;
  }
  return GetPosition();
}

nsPoint
nsIFrame::GetPositionIgnoringScrolling()
{
  return GetParent() ? GetParent()->GetPositionOfChildIgnoringScrolling(this)
    : GetPosition();
}

nsRect
nsIFrame::GetOverflowRect(nsOverflowType aType) const
{
  MOZ_ASSERT(aType == eVisualOverflow || aType == eScrollableOverflow,
             "unexpected type");

  // Note that in some cases the overflow area might not have been
  // updated (yet) to reflect any outline set on the frame or the area
  // of child frames. That's OK because any reflow that updates these
  // areas will invalidate the appropriate area, so any (mis)uses of
  // this method will be fixed up.

  if (mOverflow.mType == NS_FRAME_OVERFLOW_LARGE) {
    // there is an overflow rect, and it's not stored as deltas but as
    // a separately-allocated rect
    return static_cast<nsOverflowAreas*>(const_cast<nsIFrame*>(this)->
             GetOverflowAreasProperty())->Overflow(aType);
  }

  if (aType == eVisualOverflow &&
      mOverflow.mType != NS_FRAME_OVERFLOW_NONE) {
    return GetVisualOverflowFromDeltas();
  }

  return nsRect(nsPoint(0, 0), GetSize());
}

nsOverflowAreas
nsIFrame::GetOverflowAreas() const
{
  if (mOverflow.mType == NS_FRAME_OVERFLOW_LARGE) {
    // there is an overflow rect, and it's not stored as deltas but as
    // a separately-allocated rect
    return *const_cast<nsIFrame*>(this)->GetOverflowAreasProperty();
  }

  return nsOverflowAreas(GetVisualOverflowFromDeltas(),
                         nsRect(nsPoint(0, 0), GetSize()));
}

nsOverflowAreas
nsIFrame::GetOverflowAreasRelativeToSelf() const
{
  if (IsTransformed()) {
    nsOverflowAreas* preTransformOverflows =
      Properties().Get(PreTransformOverflowAreasProperty());
    if (preTransformOverflows) {
      return nsOverflowAreas(preTransformOverflows->VisualOverflow(),
                             preTransformOverflows->ScrollableOverflow());
    }
  }
  return nsOverflowAreas(GetVisualOverflowRect(),
                         GetScrollableOverflowRect());
}

nsRect
nsIFrame::GetScrollableOverflowRectRelativeToParent() const
{
  return GetScrollableOverflowRect() + mRect.TopLeft();
}

nsRect
nsIFrame::GetVisualOverflowRectRelativeToParent() const
{
  return GetVisualOverflowRect() + mRect.TopLeft();
}

nsRect
nsIFrame::GetScrollableOverflowRectRelativeToSelf() const
{
  if (IsTransformed()) {
    nsOverflowAreas* preTransformOverflows =
      Properties().Get(PreTransformOverflowAreasProperty());
    if (preTransformOverflows)
      return preTransformOverflows->ScrollableOverflow();
  }
  return GetScrollableOverflowRect();
}

nsRect
nsIFrame::GetVisualOverflowRectRelativeToSelf() const
{
  if (IsTransformed()) {
    nsOverflowAreas* preTransformOverflows =
      Properties().Get(PreTransformOverflowAreasProperty());
    if (preTransformOverflows)
      return preTransformOverflows->VisualOverflow();
  }
  return GetVisualOverflowRect();
}

nsRect
nsIFrame::GetPreEffectsVisualOverflowRect() const
{
  nsRect* r = Properties().Get(nsIFrame::PreEffectsBBoxProperty());
  return r ? *r : GetVisualOverflowRectRelativeToSelf();
}

bool
nsIFrame::UpdateOverflow()
{
  MOZ_ASSERT(FrameMaintainsOverflow(),
             "Non-display SVG do not maintain visual overflow rects");

  nsRect rect(nsPoint(0, 0), GetSize());
  nsOverflowAreas overflowAreas(rect, rect);

  if (!ComputeCustomOverflow(overflowAreas)) {
    return false;
  }

  UnionChildOverflow(overflowAreas);

  if (FinishAndStoreOverflow(overflowAreas, GetSize())) {
    nsView* view = GetView();
    if (view) {
      uint32_t flags = GetXULLayoutFlags();

      if ((flags & NS_FRAME_NO_SIZE_VIEW) == 0) {
        // Make sure the frame's view is properly sized.
        nsViewManager* vm = view->GetViewManager();
        vm->ResizeView(view, overflowAreas.VisualOverflow(), true);
      }
    }

    return true;
  }

  return false;
}

/* virtual */ bool
nsFrame::ComputeCustomOverflow(nsOverflowAreas& aOverflowAreas)
{
  return true;
}

/* virtual */ void
nsFrame::UnionChildOverflow(nsOverflowAreas& aOverflowAreas)
{
  if (!DoesClipChildren() &&
      !(IsXULCollapsed() && (IsXULBoxFrame() || ::IsXULBoxWrapped(this)))) {
    nsLayoutUtils::UnionChildOverflow(this, aOverflowAreas);
  }
}


// Define the MAX_FRAME_DEPTH to be the ContentSink's MAX_REFLOW_DEPTH plus
// 4 for the frames above the document's frames: 
//  the Viewport, GFXScroll, ScrollPort, and Canvas
#define MAX_FRAME_DEPTH (MAX_REFLOW_DEPTH+4)

bool
nsFrame::IsFrameTreeTooDeep(const ReflowInput& aReflowInput,
                            ReflowOutput& aMetrics,
                            nsReflowStatus& aStatus)
{
  if (aReflowInput.mReflowDepth >  MAX_FRAME_DEPTH) {
    NS_WARNING("frame tree too deep; setting zero size and returning");
    mState |= NS_FRAME_TOO_DEEP_IN_FRAME_TREE;
    ClearOverflowRects();
    aMetrics.ClearSize();
    aMetrics.SetBlockStartAscent(0);
    aMetrics.mCarriedOutBEndMargin.Zero();
    aMetrics.mOverflowAreas.Clear();

    if (GetNextInFlow()) {
      // Reflow depth might vary between reflows, so we might have
      // successfully reflowed and split this frame before.  If so, we
      // shouldn't delete its continuations.
      aStatus = NS_FRAME_NOT_COMPLETE;
    } else {
      aStatus = NS_FRAME_COMPLETE;
    }

    return true;
  }
  mState &= ~NS_FRAME_TOO_DEEP_IN_FRAME_TREE;
  return false;
}

bool
nsIFrame::IsBlockWrapper() const
{
  nsIAtom *pseudoType = StyleContext()->GetPseudo();
  return (pseudoType == nsCSSAnonBoxes::mozAnonymousBlock ||
          pseudoType == nsCSSAnonBoxes::mozAnonymousPositionedBlock ||
          pseudoType == nsCSSAnonBoxes::buttonContent ||
          pseudoType == nsCSSAnonBoxes::cellContent);
}

static nsIFrame*
GetNearestBlockContainer(nsIFrame* frame)
{
  // The block wrappers we use to wrap blocks inside inlines aren't
  // described in the CSS spec.  We need to make them not be containing
  // blocks.
  // Since the parent of such a block is either a normal block or
  // another such pseudo, this shouldn't cause anything bad to happen.
  // Also the anonymous blocks inside table cells are not containing blocks.
  while (frame->IsFrameOfType(nsIFrame::eLineParticipant) ||
         frame->IsBlockWrapper() ||
         // Table rows are not containing blocks either
         frame->GetType() == nsGkAtoms::tableRowFrame) {
    frame = frame->GetParent();
    NS_ASSERTION(frame, "How come we got to the root frame without seeing a containing block?");
  }
  return frame;
}

nsIFrame*
nsIFrame::GetContainingBlock(uint32_t aFlags) const
{
  if (!GetParent()) {
    return nullptr;
  }
  // MathML frames might have absolute positioning style, but they would
  // still be in-flow.  So we have to check to make sure that the frame
  // is really out-of-flow too.
  nsIFrame* f;
  if (IsAbsolutelyPositioned() &&
      (GetStateBits() & NS_FRAME_OUT_OF_FLOW)) {
    f = GetParent(); // the parent is always the containing block
  } else {
    f = GetNearestBlockContainer(GetParent());
  }

  if (aFlags & SKIP_SCROLLED_FRAME && f &&
      f->StyleContext()->GetPseudo() == nsCSSAnonBoxes::scrolledContent) {
    f = f->GetParent();
  }
  return f;
}

#ifdef DEBUG_FRAME_DUMP

int32_t nsFrame::ContentIndexInContainer(const nsIFrame* aFrame)
{
  int32_t result = -1;

  nsIContent* content = aFrame->GetContent();
  if (content) {
    nsIContent* parentContent = content->GetParent();
    if (parentContent) {
      result = parentContent->IndexOf(content);
    }
  }

  return result;
}

/**
 * List a frame tree to stderr. Meant to be called from gdb.
 */
void
DebugListFrameTree(nsIFrame* aFrame)
{
  ((nsFrame*)aFrame)->List(stderr);
}

void
nsIFrame::ListTag(nsACString& aTo) const
{
  ListTag(aTo, this);
}

/* static */
void
nsIFrame::ListTag(nsACString& aTo, const nsIFrame* aFrame) {
  nsAutoString tmp;
  aFrame->GetFrameName(tmp);
  aTo += NS_ConvertUTF16toUTF8(tmp).get();
  aTo += nsPrintfCString("@%p", static_cast<const void*>(aFrame));
}

// Debugging
void
nsIFrame::ListGeneric(nsACString& aTo, const char* aPrefix, uint32_t aFlags) const
{
  aTo =+ aPrefix;
  ListTag(aTo);
  if (HasView()) {
    aTo += nsPrintfCString(" [view=%p]", static_cast<void*>(GetView()));
  }
  if (GetNextSibling()) {
    aTo += nsPrintfCString(" next=%p", static_cast<void*>(GetNextSibling()));
  }
  if (GetPrevContinuation()) {
    bool fluid = GetPrevInFlow() == GetPrevContinuation();
    aTo += nsPrintfCString(" prev-%s=%p", fluid?"in-flow":"continuation",
            static_cast<void*>(GetPrevContinuation()));
  }
  if (GetNextContinuation()) {
    bool fluid = GetNextInFlow() == GetNextContinuation();
    aTo += nsPrintfCString(" next-%s=%p", fluid?"in-flow":"continuation",
            static_cast<void*>(GetNextContinuation()));
  }
  void* IBsibling = Properties().Get(IBSplitSibling());
  if (IBsibling) {
    aTo += nsPrintfCString(" IBSplitSibling=%p", IBsibling);
  }
  void* IBprevsibling = Properties().Get(IBSplitPrevSibling());
  if (IBprevsibling) {
    aTo += nsPrintfCString(" IBSplitPrevSibling=%p", IBprevsibling);
  }
  aTo += nsPrintfCString(" {%d,%d,%d,%d}", mRect.x, mRect.y, mRect.width, mRect.height);

  mozilla::WritingMode wm = GetWritingMode();
  if (wm.IsVertical() || !wm.IsBidiLTR()) {
    aTo += nsPrintfCString(" wm=%s: logical size={%d,%d}", wm.DebugString(),
                           ISize(), BSize());
  }

  nsIFrame* parent = GetParent();
  if (parent) {
    WritingMode pWM = parent->GetWritingMode();
    if (pWM.IsVertical() || !pWM.IsBidiLTR()) {
      nsSize containerSize = parent->mRect.Size();
      LogicalRect lr(pWM, mRect, containerSize);
      aTo += nsPrintfCString(" parent wm=%s, cs={%d,%d}, "
                             " logicalRect={%d,%d,%d,%d}",
                             pWM.DebugString(),
                             containerSize.width, containerSize.height,
                             lr.IStart(pWM), lr.BStart(pWM),
                             lr.ISize(pWM), lr.BSize(pWM));
    }
  }
  nsIFrame* f = const_cast<nsIFrame*>(this);
  if (f->HasOverflowAreas()) {
    nsRect vo = f->GetVisualOverflowRect();
    if (!vo.IsEqualEdges(mRect)) {
      aTo += nsPrintfCString(" vis-overflow=%d,%d,%d,%d", vo.x, vo.y, vo.width, vo.height);
    }
    nsRect so = f->GetScrollableOverflowRect();
    if (!so.IsEqualEdges(mRect)) {
      aTo += nsPrintfCString(" scr-overflow=%d,%d,%d,%d", so.x, so.y, so.width, so.height);
    }
  }
  if (0 != mState) {
    aTo += nsPrintfCString(" [state=%016llx]", (unsigned long long)mState);
  }
  if (IsTransformed()) {
    aTo += nsPrintfCString(" transformed");
  }
  if (ChildrenHavePerspective()) {
    aTo += nsPrintfCString(" perspective");
  }
  if (Extend3DContext()) {
    aTo += nsPrintfCString(" preserves-3d-children");
  }
  if (Combines3DTransformWithAncestors()) {
    aTo += nsPrintfCString(" preserves-3d");
  }
  if (mContent) {
    aTo += nsPrintfCString(" [content=%p]", static_cast<void*>(mContent));
  }
  aTo += nsPrintfCString(" [sc=%p", static_cast<void*>(mStyleContext));
  if (mStyleContext) {
    nsIAtom* pseudoTag = mStyleContext->GetPseudo();
    if (pseudoTag) {
      nsAutoString atomString;
      pseudoTag->ToString(atomString);
      aTo += nsPrintfCString("%s", NS_LossyConvertUTF16toASCII(atomString).get());
    }
    if (!mStyleContext->GetParent() ||
        (GetParent() && GetParent()->StyleContext() != mStyleContext->GetParent())) {
      aTo += nsPrintfCString("^%p", mStyleContext->GetParent());
      if (mStyleContext->GetParent()) {
        aTo += nsPrintfCString("^%p", mStyleContext->GetParent()->GetParent());
        if (mStyleContext->GetParent()->GetParent()) {
          aTo += nsPrintfCString("^%p", mStyleContext->GetParent()->GetParent()->GetParent());
        }
      }
    }
  }
  aTo += "]";
}

void
nsIFrame::List(FILE* out, const char* aPrefix, uint32_t aFlags) const
{
  nsCString str;
  ListGeneric(str, aPrefix, aFlags);
  fprintf_stderr(out, "%s\n", str.get());
}

nsresult
nsFrame::GetFrameName(nsAString& aResult) const
{
  return MakeFrameName(NS_LITERAL_STRING("Frame"), aResult);
}

nsresult
nsFrame::MakeFrameName(const nsAString& aType, nsAString& aResult) const
{
  aResult = aType;
  if (mContent && !mContent->IsNodeOfType(nsINode::eTEXT)) {
    nsAutoString buf;
    mContent->NodeInfo()->NameAtom()->ToString(buf);
    if (GetType() == nsGkAtoms::subDocumentFrame) {
      nsAutoString src;
      mContent->GetAttr(kNameSpaceID_None, nsGkAtoms::src, src);
      buf.AppendLiteral(" src=");
      buf.Append(src);
    }
    aResult.Append('(');
    aResult.Append(buf);
    aResult.Append(')');
  }
  char buf[40];
  SprintfLiteral(buf, "(%d)", ContentIndexInContainer(this));
  AppendASCIItoUTF16(buf, aResult);
  return NS_OK;
}

void
nsIFrame::DumpFrameTree() const
{
  RootFrameList(PresContext(), stderr);
}

void
nsIFrame::DumpFrameTreeLimited() const
{
  List(stderr);
}

void
nsIFrame::RootFrameList(nsPresContext* aPresContext, FILE* out, const char* aPrefix)
{
  if (!aPresContext || !out)
    return;

  nsIPresShell *shell = aPresContext->GetPresShell();
  if (shell) {
    nsIFrame* frame = shell->FrameManager()->GetRootFrame();
    if(frame) {
      frame->List(out, aPrefix);
    }
  }
}
#endif

#ifdef DEBUG
nsFrameState
nsFrame::GetDebugStateBits() const
{
  // We'll ignore these flags for the purposes of comparing frame state:
  //
  //   NS_FRAME_EXTERNAL_REFERENCE
  //     because this is set by the event state manager or the
  //     caret code when a frame is focused. Depending on whether
  //     or not the regression tests are run as the focused window
  //     will make this value vary randomly.
#define IRRELEVANT_FRAME_STATE_FLAGS NS_FRAME_EXTERNAL_REFERENCE

#define FRAME_STATE_MASK (~(IRRELEVANT_FRAME_STATE_FLAGS))

  return GetStateBits() & FRAME_STATE_MASK;
}

void
nsFrame::XMLQuote(nsString& aString)
{
  int32_t i, len = aString.Length();
  for (i = 0; i < len; i++) {
    char16_t ch = aString.CharAt(i);
    if (ch == '<') {
      nsAutoString tmp(NS_LITERAL_STRING("&lt;"));
      aString.Cut(i, 1);
      aString.Insert(tmp, i);
      len += 3;
      i += 3;
    }
    else if (ch == '>') {
      nsAutoString tmp(NS_LITERAL_STRING("&gt;"));
      aString.Cut(i, 1);
      aString.Insert(tmp, i);
      len += 3;
      i += 3;
    }
    else if (ch == '\"') {
      nsAutoString tmp(NS_LITERAL_STRING("&quot;"));
      aString.Cut(i, 1);
      aString.Insert(tmp, i);
      len += 5;
      i += 5;
    }
  }
}
#endif

bool
nsIFrame::IsVisibleForPainting(nsDisplayListBuilder* aBuilder) {
  if (!StyleVisibility()->IsVisible())
    return false;
  nsISelection* sel = aBuilder->GetBoundingSelection();
  return !sel || IsVisibleInSelection(sel);
}

bool
nsIFrame::IsVisibleForPainting() {
  if (!StyleVisibility()->IsVisible())
    return false;

  nsPresContext* pc = PresContext();
  if (!pc->IsRenderingOnlySelection())
    return true;

  nsCOMPtr<nsISelectionController> selcon(do_QueryInterface(pc->PresShell()));
  if (selcon) {
    nsCOMPtr<nsISelection> sel;
    selcon->GetSelection(nsISelectionController::SELECTION_NORMAL,
                         getter_AddRefs(sel));
    if (sel)
      return IsVisibleInSelection(sel);
  }
  return true;
}

bool
nsIFrame::IsVisibleInSelection(nsDisplayListBuilder* aBuilder) {
  nsISelection* sel = aBuilder->GetBoundingSelection();
  return !sel || IsVisibleInSelection(sel);
}

bool
nsIFrame::IsVisibleOrCollapsedForPainting(nsDisplayListBuilder* aBuilder) {
  if (!StyleVisibility()->IsVisibleOrCollapsed())
    return false;
  nsISelection* sel = aBuilder->GetBoundingSelection();
  return !sel || IsVisibleInSelection(sel);
}

bool
nsIFrame::IsVisibleInSelection(nsISelection* aSelection)
{
  if (!GetContent() || !GetContent()->IsSelectionDescendant()) {
    return false;
  }
  
  nsCOMPtr<nsIDOMNode> node(do_QueryInterface(mContent));
  bool vis;
  nsresult rv = aSelection->ContainsNode(node, true, &vis);
  return NS_FAILED(rv) || vis;
}

/* virtual */ bool
nsFrame::IsEmpty()
{
  return false;
}

bool
nsIFrame::CachedIsEmpty()
{
  NS_PRECONDITION(!(GetStateBits() & NS_FRAME_IS_DIRTY),
                  "Must only be called on reflowed lines");
  return IsEmpty();
}

/* virtual */ bool
nsFrame::IsSelfEmpty()
{
  return false;
}

nsresult
nsFrame::GetSelectionController(nsPresContext *aPresContext, nsISelectionController **aSelCon)
{
  if (!aPresContext || !aSelCon)
    return NS_ERROR_INVALID_ARG;

  nsIFrame *frame = this;
  while (frame && (frame->GetStateBits() & NS_FRAME_INDEPENDENT_SELECTION)) {
    nsITextControlFrame *tcf = do_QueryFrame(frame);
    if (tcf) {
      return tcf->GetOwnedSelectionController(aSelCon);
    }
    frame = frame->GetParent();
  }

  return CallQueryInterface(aPresContext->GetPresShell(), aSelCon);
}

already_AddRefed<nsFrameSelection>
nsIFrame::GetFrameSelection()
{
  RefPtr<nsFrameSelection> fs =
    const_cast<nsFrameSelection*>(GetConstFrameSelection());
  return fs.forget();
}

const nsFrameSelection*
nsIFrame::GetConstFrameSelection() const
{
  nsIFrame* frame = const_cast<nsIFrame*>(this);
  while (frame && (frame->GetStateBits() & NS_FRAME_INDEPENDENT_SELECTION)) {
    nsITextControlFrame* tcf = do_QueryFrame(frame);
    if (tcf) {
      return tcf->GetOwnedFrameSelection();
    }
    frame = frame->GetParent();
  }

  return PresContext()->PresShell()->ConstFrameSelection();
}

#ifdef DEBUG
nsresult
nsFrame::DumpRegressionData(nsPresContext* aPresContext, FILE* out, int32_t aIndent)
{
  IndentBy(out, aIndent);
  fprintf(out, "<frame va=\"%p\" type=\"", (void*)this);
  nsAutoString name;
  GetFrameName(name);
  XMLQuote(name);
  fputs(NS_LossyConvertUTF16toASCII(name).get(), out);
  fprintf(out, "\" state=\"%016llx\" parent=\"%p\">\n",
          (unsigned long long)GetDebugStateBits(), (void*)GetParent());

  aIndent++;
  DumpBaseRegressionData(aPresContext, out, aIndent);
  aIndent--;

  IndentBy(out, aIndent);
  fprintf(out, "</frame>\n");

  return NS_OK;
}

void
nsFrame::DumpBaseRegressionData(nsPresContext* aPresContext, FILE* out, int32_t aIndent)
{
  if (GetNextSibling()) {
    IndentBy(out, aIndent);
    fprintf(out, "<next-sibling va=\"%p\"/>\n", (void*)GetNextSibling());
  }

  if (HasView()) {
    IndentBy(out, aIndent);
    fprintf(out, "<view va=\"%p\">\n", (void*)GetView());
    aIndent++;
    // XXX add in code to dump out view state too...
    aIndent--;
    IndentBy(out, aIndent);
    fprintf(out, "</view>\n");
  }

  IndentBy(out, aIndent);
  fprintf(out, "<bbox x=\"%d\" y=\"%d\" w=\"%d\" h=\"%d\"/>\n",
          mRect.x, mRect.y, mRect.width, mRect.height);

  // Now dump all of the children on all of the child lists
  ChildListIterator lists(this);
  for (; !lists.IsDone(); lists.Next()) {
    IndentBy(out, aIndent);
    if (lists.CurrentID() != kPrincipalList) {
      fprintf(out, "<child-list name=\"%s\">\n", mozilla::layout::ChildListName(lists.CurrentID()));
    }
    else {
      fprintf(out, "<child-list>\n");
    }
    aIndent++;
    nsFrameList::Enumerator childFrames(lists.CurrentList());
    for (; !childFrames.AtEnd(); childFrames.Next()) {
      nsIFrame* kid = childFrames.get();
      kid->DumpRegressionData(aPresContext, out, aIndent);
    }
    aIndent--;
    IndentBy(out, aIndent);
    fprintf(out, "</child-list>\n");
  }
}
#endif

bool
nsIFrame::IsFrameSelected() const
{
  NS_ASSERTION(!GetContent() || GetContent()->IsSelectionDescendant(),
               "use the public IsSelected() instead");
  return nsRange::IsNodeSelected(GetContent(), 0,
                                 GetContent()->GetChildCount());
}

nsresult
nsFrame::GetPointFromOffset(int32_t inOffset, nsPoint* outPoint)
{
  NS_PRECONDITION(outPoint != nullptr, "Null parameter");
  nsRect contentRect = GetContentRectRelativeToSelf();
  nsPoint pt = contentRect.TopLeft();
  if (mContent)
  {
    nsIContent* newContent = mContent->GetParent();
    if (newContent){
      int32_t newOffset = newContent->IndexOf(mContent);

      // Find the direction of the frame from the EmbeddingLevelProperty,
      // which is the resolved bidi level set in
      // nsBidiPresUtils::ResolveParagraph (odd levels = right-to-left).
      // If the embedding level isn't set, just use the CSS direction
      // property.
      bool hasBidiData;
      FrameBidiData bidiData =
        Properties().Get(BidiDataProperty(), &hasBidiData);
      bool isRTL = hasBidiData
        ? IS_LEVEL_RTL(bidiData.embeddingLevel)
        : StyleVisibility()->mDirection == NS_STYLE_DIRECTION_RTL;
      if ((!isRTL && inOffset > newOffset) ||
          (isRTL && inOffset <= newOffset)) {
        pt = contentRect.TopRight();
      }
    }
  }
  *outPoint = pt;
  return NS_OK;
}

nsresult
nsFrame::GetCharacterRectsInRange(int32_t aInOffset, int32_t aLength,
                                  nsTArray<nsRect>& aOutRect)
{
  /* no text */
  return NS_ERROR_FAILURE;
}

nsresult
nsFrame::GetChildFrameContainingOffset(int32_t inContentOffset, bool inHint, int32_t* outFrameContentOffset, nsIFrame **outChildFrame)
{
  NS_PRECONDITION(outChildFrame && outFrameContentOffset, "Null parameter");
  *outFrameContentOffset = (int32_t)inHint;
  //the best frame to reflect any given offset would be a visible frame if possible
  //i.e. we are looking for a valid frame to place the blinking caret 
  nsRect rect = GetRect();
  if (!rect.width || !rect.height)
  {
    //if we have a 0 width or height then lets look for another frame that possibly has
    //the same content.  If we have no frames in flow then just let us return 'this' frame
    nsIFrame* nextFlow = GetNextInFlow();
    if (nextFlow)
      return nextFlow->GetChildFrameContainingOffset(inContentOffset, inHint, outFrameContentOffset, outChildFrame);
  }
  *outChildFrame = this;
  return NS_OK;
}

//
// What I've pieced together about this routine:
// Starting with a block frame (from which a line frame can be gotten)
// and a line number, drill down and get the first/last selectable
// frame on that line, depending on aPos->mDirection.
// aOutSideLimit != 0 means ignore aLineStart, instead work from
// the end (if > 0) or beginning (if < 0).
//
nsresult
nsFrame::GetNextPrevLineFromeBlockFrame(nsPresContext* aPresContext,
                                        nsPeekOffsetStruct *aPos,
                                        nsIFrame *aBlockFrame, 
                                        int32_t aLineStart, 
                                        int8_t aOutSideLimit
                                        )
{
  //magic numbers aLineStart will be -1 for end of block 0 will be start of block
  if (!aBlockFrame || !aPos)
    return NS_ERROR_NULL_POINTER;

  aPos->mResultFrame = nullptr;
  aPos->mResultContent = nullptr;
  aPos->mAttach =
      aPos->mDirection == eDirNext ? CARET_ASSOCIATE_AFTER : CARET_ASSOCIATE_BEFORE;

  nsAutoLineIterator it = aBlockFrame->GetLineIterator();
  if (!it)
    return NS_ERROR_FAILURE;
  int32_t searchingLine = aLineStart;
  int32_t countLines = it->GetNumLines();
  if (aOutSideLimit > 0) //start at end
    searchingLine = countLines;
  else if (aOutSideLimit <0)//start at beginning
    searchingLine = -1;//"next" will be 0  
  else 
    if ((aPos->mDirection == eDirPrevious && searchingLine == 0) || 
       (aPos->mDirection == eDirNext && searchingLine >= (countLines -1) )){
      //we need to jump to new block frame.
           return NS_ERROR_FAILURE;
    }
  int32_t lineFrameCount;
  nsIFrame *resultFrame = nullptr;
  nsIFrame *farStoppingFrame = nullptr; //we keep searching until we find a "this" frame then we go to next line
  nsIFrame *nearStoppingFrame = nullptr; //if we are backing up from edge, stop here
  nsIFrame *firstFrame;
  nsIFrame *lastFrame;
  nsRect  rect;
  bool isBeforeFirstFrame, isAfterLastFrame;
  bool found = false;

  nsresult result = NS_OK;
  while (!found)
  {
    if (aPos->mDirection == eDirPrevious)
      searchingLine --;
    else
      searchingLine ++;
    if ((aPos->mDirection == eDirPrevious && searchingLine < 0) || 
       (aPos->mDirection == eDirNext && searchingLine >= countLines ))
    {
      //we need to jump to new block frame.
      return NS_ERROR_FAILURE;
    }
    result = it->GetLine(searchingLine, &firstFrame, &lineFrameCount,
                         rect);
    if (!lineFrameCount) 
      continue;
    if (NS_SUCCEEDED(result)){
      lastFrame = firstFrame;
      for (;lineFrameCount > 1;lineFrameCount --){
        //result = lastFrame->GetNextSibling(&lastFrame, searchingLine);
        result = it->GetNextSiblingOnLine(lastFrame, searchingLine);
        if (NS_FAILED(result) || !lastFrame){
          NS_ERROR("GetLine promised more frames than could be found");
          return NS_ERROR_FAILURE;
        }
      }
      GetLastLeaf(aPresContext, &lastFrame);

      if (aPos->mDirection == eDirNext){
        nearStoppingFrame = firstFrame;
        farStoppingFrame = lastFrame;
      }
      else{
        nearStoppingFrame = lastFrame;
        farStoppingFrame = firstFrame;
      }
      nsPoint offset;
      nsView * view; //used for call of get offset from view
      aBlockFrame->GetOffsetFromView(offset,&view);
      nsPoint newDesiredPos =
        aPos->mDesiredPos - offset; //get desired position into blockframe coords
      result = it->FindFrameAt(searchingLine, newDesiredPos, &resultFrame,
                               &isBeforeFirstFrame, &isAfterLastFrame);
      if(NS_FAILED(result))
        continue;
    }

    if (NS_SUCCEEDED(result) && resultFrame)
    {
      //check to see if this is ANOTHER blockframe inside the other one if so then call into its lines
      nsAutoLineIterator newIt = resultFrame->GetLineIterator();
      if (newIt)
      {
        aPos->mResultFrame = resultFrame;
        return NS_OK;
      }
      //resultFrame is not a block frame
      result = NS_ERROR_FAILURE;

      nsCOMPtr<nsIFrameEnumerator> frameTraversal;
      result = NS_NewFrameTraversal(getter_AddRefs(frameTraversal),
                                    aPresContext, resultFrame,
                                    ePostOrder,
                                    false, // aVisual
                                    aPos->mScrollViewStop,
                                    false, // aFollowOOFs
                                    false  // aSkipPopupChecks
                                    );
      if (NS_FAILED(result))
        return result;

      nsIFrame *storeOldResultFrame = resultFrame;
      while ( !found ){
        nsPoint point;
        nsRect tempRect = resultFrame->GetRect();
        nsPoint offset;
        nsView * view; //used for call of get offset from view
        resultFrame->GetOffsetFromView(offset, &view);
        if (!view) {
          return NS_ERROR_FAILURE;
        }
        if (resultFrame->GetWritingMode().IsVertical()) {
          point.y = aPos->mDesiredPos.y;
          point.x = tempRect.width + offset.x;
        } else {
          point.y = tempRect.height + offset.y;
          point.x = aPos->mDesiredPos.x;
        }

        //special check. if we allow non-text selection then we can allow a hit location to fall before a table.
        //otherwise there is no way to get and click signal to fall before a table (it being a line iterator itself)
        nsIPresShell *shell = aPresContext->GetPresShell();
        if (!shell)
          return NS_ERROR_FAILURE;
        int16_t isEditor = shell->GetSelectionFlags();
        isEditor = isEditor == nsISelectionDisplay::DISPLAY_ALL;
        if ( isEditor )
        {
          if (resultFrame->GetType() == nsGkAtoms::tableWrapperFrame)
          {
            if (((point.x - offset.x + tempRect.x)<0) ||  ((point.x - offset.x+ tempRect.x)>tempRect.width))//off left/right side
            {
              nsIContent* content = resultFrame->GetContent();
              if (content)
              {
                nsIContent* parent = content->GetParent();
                if (parent)
                {
                  aPos->mResultContent = parent;
                  aPos->mContentOffset = parent->IndexOf(content);
                  aPos->mAttach = CARET_ASSOCIATE_BEFORE;
                  if ((point.x - offset.x+ tempRect.x)>tempRect.width)
                  {
                    aPos->mContentOffset++;//go to end of this frame
                    aPos->mAttach = CARET_ASSOCIATE_AFTER;
                  }
                  //result frame is the result frames parent.
                  aPos->mResultFrame = resultFrame->GetParent();
                  return NS_POSITION_BEFORE_TABLE;
                }
              }
            }
          }
        }

        if (!resultFrame->HasView())
        {
          nsView* view;
          nsPoint offset;
          resultFrame->GetOffsetFromView(offset, &view);
          ContentOffsets offsets =
              resultFrame->GetContentOffsetsFromPoint(point - offset);
          aPos->mResultContent = offsets.content;
          aPos->mContentOffset = offsets.offset;
          aPos->mAttach = offsets.associate;
          if (offsets.content)
          {
            bool selectable;
            resultFrame->IsSelectable(&selectable, nullptr);
            if (selectable)
            {
              found = true;
              break;
            }
          }
        }

        if (aPos->mDirection == eDirPrevious && (resultFrame == farStoppingFrame))
          break;
        if (aPos->mDirection == eDirNext && (resultFrame == nearStoppingFrame))
          break;
        //always try previous on THAT line if that fails go the other way
        frameTraversal->Prev();
        resultFrame = frameTraversal->CurrentItem();
        if (!resultFrame)
          return NS_ERROR_FAILURE;
      }

      if (!found){
        resultFrame = storeOldResultFrame;

        result = NS_NewFrameTraversal(getter_AddRefs(frameTraversal),
                                      aPresContext, resultFrame,
                                      eLeaf,
                                      false, // aVisual
                                      aPos->mScrollViewStop,
                                      false, // aFollowOOFs
                                      false  // aSkipPopupChecks
                                      );
      }
      while ( !found ){
        nsPoint point = aPos->mDesiredPos;
        nsView* view;
        nsPoint offset;
        resultFrame->GetOffsetFromView(offset, &view);
        ContentOffsets offsets =
            resultFrame->GetContentOffsetsFromPoint(point - offset);
        aPos->mResultContent = offsets.content;
        aPos->mContentOffset = offsets.offset;
        aPos->mAttach = offsets.associate;
        if (offsets.content)
        {
          bool selectable;
          resultFrame->IsSelectable(&selectable, nullptr);
          if (selectable)
          {
            found = true;
            if (resultFrame == farStoppingFrame)
              aPos->mAttach = CARET_ASSOCIATE_BEFORE;
            else
              aPos->mAttach = CARET_ASSOCIATE_AFTER;
            break;
          }
        }
        if (aPos->mDirection == eDirPrevious && (resultFrame == nearStoppingFrame))
          break;
        if (aPos->mDirection == eDirNext && (resultFrame == farStoppingFrame))
          break;
        //previous didnt work now we try "next"
        frameTraversal->Next();
        nsIFrame *tempFrame = frameTraversal->CurrentItem();
        if (!tempFrame)
          break;
        resultFrame = tempFrame;
      }
      aPos->mResultFrame = resultFrame;
    }
    else {
        //we need to jump to new block frame.
      aPos->mAmount = eSelectLine;
      aPos->mStartOffset = 0;
      aPos->mAttach = aPos->mDirection == eDirNext ?
          CARET_ASSOCIATE_BEFORE : CARET_ASSOCIATE_AFTER;
      if (aPos->mDirection == eDirPrevious)
        aPos->mStartOffset = -1;//start from end
     return aBlockFrame->PeekOffset(aPos);
    }
  }
  return NS_OK;
}

nsIFrame::CaretPosition
nsIFrame::GetExtremeCaretPosition(bool aStart)
{
  CaretPosition result;

  FrameTarget targetFrame = DrillDownToSelectionFrame(this, !aStart, 0);
  FrameContentRange range = GetRangeForFrame(targetFrame.frame);
  result.mResultContent = range.content;
  result.mContentOffset = aStart ? range.start : range.end;
  return result;
}

// Find the first (or last) descendant of the given frame
// which is either a block frame or a BRFrame.
static nsContentAndOffset
FindBlockFrameOrBR(nsIFrame* aFrame, nsDirection aDirection)
{
  nsContentAndOffset result;
  result.mContent =  nullptr;
  result.mOffset = 0;

  if (aFrame->IsGeneratedContentFrame())
    return result;

  // Treat form controls as inline leaves
  // XXX we really need a way to determine whether a frame is inline-level
  nsIFormControlFrame* fcf = do_QueryFrame(aFrame);
  if (fcf)
    return result;
  
  // Check the frame itself
  // Fall through block-in-inline split frames because their mContent is
  // the content of the inline frames they were created from. The
  // first/last child of such frames is the real block frame we're
  // looking for.
  if ((nsLayoutUtils::GetAsBlock(aFrame) &&
       !(aFrame->GetStateBits() & NS_FRAME_PART_OF_IBSPLIT)) ||
      aFrame->GetType() == nsGkAtoms::brFrame) {
    nsIContent* content = aFrame->GetContent();
    result.mContent = content->GetParent();
    // In some cases (bug 310589, bug 370174) we end up here with a null content.
    // This probably shouldn't ever happen, but since it sometimes does, we want
    // to avoid crashing here.
    NS_ASSERTION(result.mContent, "Unexpected orphan content");
    if (result.mContent)
      result.mOffset = result.mContent->IndexOf(content) + 
        (aDirection == eDirPrevious ? 1 : 0);
    return result;
  }

  // If this is a preformatted text frame, see if it ends with a newline
  if (aFrame->HasSignificantTerminalNewline()) {
    int32_t startOffset, endOffset;
    aFrame->GetOffsets(startOffset, endOffset);
    result.mContent = aFrame->GetContent();
    result.mOffset = endOffset - (aDirection == eDirPrevious ? 0 : 1);
    return result;
  }

  // Iterate over children and call ourselves recursively
  if (aDirection == eDirPrevious) {
    nsIFrame* child = aFrame->GetChildList(nsIFrame::kPrincipalList).LastChild();
    while(child && !result.mContent) {
      result = FindBlockFrameOrBR(child, aDirection);
      child = child->GetPrevSibling();
    }
  } else { // eDirNext
    nsIFrame* child = aFrame->PrincipalChildList().FirstChild();
    while(child && !result.mContent) {
      result = FindBlockFrameOrBR(child, aDirection);
      child = child->GetNextSibling();
    }
  }
  return result;
}

nsresult
nsIFrame::PeekOffsetParagraph(nsPeekOffsetStruct *aPos)
{
  nsIFrame* frame = this;
  nsContentAndOffset blockFrameOrBR;
  blockFrameOrBR.mContent = nullptr;
  bool reachedBlockAncestor = false;

  // Go through containing frames until reaching a block frame.
  // In each step, search the previous (or next) siblings for the closest
  // "stop frame" (a block frame or a BRFrame).
  // If found, set it to be the selection boundray and abort.
  
  if (aPos->mDirection == eDirPrevious) {
    while (!reachedBlockAncestor) {
      nsIFrame* parent = frame->GetParent();
      // Treat a frame associated with the root content as if it were a block frame.
      if (!frame->mContent || !frame->mContent->GetParent()) {
        reachedBlockAncestor = true;
        break;
      }
      nsIFrame* sibling = frame->GetPrevSibling();
      while (sibling && !blockFrameOrBR.mContent) {
        blockFrameOrBR = FindBlockFrameOrBR(sibling, eDirPrevious);
        sibling = sibling->GetPrevSibling();
      }
      if (blockFrameOrBR.mContent) {
        aPos->mResultContent = blockFrameOrBR.mContent;
        aPos->mContentOffset = blockFrameOrBR.mOffset;
        break;
      }
      frame = parent;
      reachedBlockAncestor = (nsLayoutUtils::GetAsBlock(frame) != nullptr);
    }
    if (reachedBlockAncestor) { // no "stop frame" found
      aPos->mResultContent = frame->GetContent();
      aPos->mContentOffset = 0;
    }
  } else { // eDirNext
    while (!reachedBlockAncestor) {
      nsIFrame* parent = frame->GetParent();
      // Treat a frame associated with the root content as if it were a block frame.
      if (!frame->mContent || !frame->mContent->GetParent()) {
        reachedBlockAncestor = true;
        break;
      }
      nsIFrame* sibling = frame;
      while (sibling && !blockFrameOrBR.mContent) {
        blockFrameOrBR = FindBlockFrameOrBR(sibling, eDirNext);
        sibling = sibling->GetNextSibling();
      }
      if (blockFrameOrBR.mContent) {
        aPos->mResultContent = blockFrameOrBR.mContent;
        aPos->mContentOffset = blockFrameOrBR.mOffset;
        break;
      }
      frame = parent;
      reachedBlockAncestor = (nsLayoutUtils::GetAsBlock(frame) != nullptr);
    }
    if (reachedBlockAncestor) { // no "stop frame" found
      aPos->mResultContent = frame->GetContent();
      if (aPos->mResultContent)
        aPos->mContentOffset = aPos->mResultContent->GetChildCount();
    }
  }
  return NS_OK;
}

// Determine movement direction relative to frame
static bool IsMovingInFrameDirection(nsIFrame* frame, nsDirection aDirection, bool aVisual)
{
  bool isReverseDirection = aVisual && IsReversedDirectionFrame(frame);
  return aDirection == (isReverseDirection ? eDirPrevious : eDirNext);
}

nsresult
nsIFrame::PeekOffset(nsPeekOffsetStruct* aPos)
{
  if (!aPos)
    return NS_ERROR_NULL_POINTER;
  nsresult result = NS_ERROR_FAILURE;

  if (mState & NS_FRAME_IS_DIRTY)
    return NS_ERROR_UNEXPECTED;

  // Translate content offset to be relative to frame
  FrameContentRange range = GetRangeForFrame(this);
  int32_t offset = aPos->mStartOffset - range.start;
  nsIFrame* current = this;
  
  switch (aPos->mAmount) {
    case eSelectCharacter:
    case eSelectCluster:
    {
      bool eatingNonRenderableWS = false;
      nsIFrame::FrameSearchResult peekSearchState = CONTINUE;
      bool jumpedLine = false;
      bool movedOverNonSelectableText = false;
      
      while (peekSearchState != FOUND) {
        bool movingInFrameDirection =
          IsMovingInFrameDirection(current, aPos->mDirection, aPos->mVisual);

        if (eatingNonRenderableWS)
          peekSearchState = current->PeekOffsetNoAmount(movingInFrameDirection, &offset); 
        else
          peekSearchState = current->PeekOffsetCharacter(movingInFrameDirection, &offset,
                                              aPos->mAmount == eSelectCluster);

        movedOverNonSelectableText |= (peekSearchState == CONTINUE_UNSELECTABLE);

        if (peekSearchState != FOUND) {
          bool movedOverNonSelectable = false;
          result =
            current->GetFrameFromDirection(aPos->mDirection, aPos->mVisual,
                                           aPos->mJumpLines, aPos->mScrollViewStop,
                                           &current, &offset, &jumpedLine,
                                           &movedOverNonSelectable);
          if (NS_FAILED(result))
            return result;

          // If we jumped lines, it's as if we found a character, but we still need
          // to eat non-renderable content on the new line.
          if (jumpedLine)
            eatingNonRenderableWS = true;

          // Remember if we moved over non-selectable text when finding another frame.
          if (movedOverNonSelectable) {
            movedOverNonSelectableText = true;
          }
        }

        // Found frame, but because we moved over non selectable text we want the offset
        // to be at the frame edge. Note that if we are extending the selection, this
        // doesn't matter.
        if (peekSearchState == FOUND && movedOverNonSelectableText &&
            !aPos->mExtend)
        {
          int32_t start, end;
          current->GetOffsets(start, end);
          offset = aPos->mDirection == eDirNext ? 0 : end - start;
        }
      }

      // Set outputs
      range = GetRangeForFrame(current);
      aPos->mResultFrame = current;
      aPos->mResultContent = range.content;
      // Output offset is relative to content, not frame
      aPos->mContentOffset = offset < 0 ? range.end : range.start + offset;
      // If we're dealing with a text frame and moving backward positions us at
      // the end of that line, decrease the offset by one to make sure that
      // we're placed before the linefeed character on the previous line.
      if (offset < 0 && jumpedLine &&
          aPos->mDirection == eDirPrevious &&
          current->HasSignificantTerminalNewline()) {
        --aPos->mContentOffset;
      }
      
      break;
    }
    case eSelectWordNoSpace:
      // eSelectWordNoSpace means that we should not be eating any whitespace when
      // moving to the adjacent word.  This means that we should set aPos->
      // mWordMovementType to eEndWord if we're moving forwards, and to eStartWord
      // if we're moving backwards.
      if (aPos->mDirection == eDirPrevious) {
        aPos->mWordMovementType = eStartWord;
      } else {
        aPos->mWordMovementType = eEndWord;
      }
      // Intentionally fall through the eSelectWord case.
      MOZ_FALLTHROUGH;
    case eSelectWord:
    {
      // wordSelectEatSpace means "are we looking for a boundary between whitespace
      // and non-whitespace (in the direction we're moving in)".
      // It is true when moving forward and looking for a beginning of a word, or
      // when moving backwards and looking for an end of a word.
      bool wordSelectEatSpace;
      if (aPos->mWordMovementType != eDefaultBehavior) {
        // aPos->mWordMovementType possible values:
        //       eEndWord: eat the space if we're moving backwards
        //       eStartWord: eat the space if we're moving forwards
        wordSelectEatSpace = ((aPos->mWordMovementType == eEndWord) == (aPos->mDirection == eDirPrevious));
      }
      else {
        // Use the hidden preference which is based on operating system behavior.
        // This pref only affects whether moving forward by word should go to the end of this word or start of the next word.
        // When going backwards, the start of the word is always used, on every operating system.
        wordSelectEatSpace = aPos->mDirection == eDirNext &&
          Preferences::GetBool("layout.word_select.eat_space_to_next_word");
      }
      
      // mSawBeforeType means "we already saw characters of the type
      // before the boundary we're looking for". Examples:
      // 1. If we're moving forward, looking for a word beginning (i.e. a boundary
      //    between whitespace and non-whitespace), then eatingWS==true means
      //    "we already saw some whitespace".
      // 2. If we're moving backward, looking for a word beginning (i.e. a boundary
      //    between non-whitespace and whitespace), then eatingWS==true means
      //    "we already saw some non-whitespace".
      PeekWordState state;
      int32_t offsetAdjustment = 0;
      bool done = false;
      while (!done) {
        bool movingInFrameDirection =
          IsMovingInFrameDirection(current, aPos->mDirection, aPos->mVisual);
        
        done = current->PeekOffsetWord(movingInFrameDirection, wordSelectEatSpace,
                                       aPos->mIsKeyboardSelect, &offset, &state) == FOUND;
        
        if (!done) {
          nsIFrame* nextFrame;
          int32_t nextFrameOffset;
          bool jumpedLine, movedOverNonSelectableText;
          result =
            current->GetFrameFromDirection(aPos->mDirection, aPos->mVisual,
                                           aPos->mJumpLines, aPos->mScrollViewStop,
                                           &nextFrame, &nextFrameOffset, &jumpedLine,
                                           &movedOverNonSelectableText);
          // We can't jump lines if we're looking for whitespace following
          // non-whitespace, and we already encountered non-whitespace.
          if (NS_FAILED(result) ||
              (jumpedLine && !wordSelectEatSpace && state.mSawBeforeType)) {
            done = true;
            // If we've crossed the line boundary, check to make sure that we
            // have not consumed a trailing newline as whitesapce if it's significant.
            if (jumpedLine && wordSelectEatSpace &&
                current->HasSignificantTerminalNewline()) {
              offsetAdjustment = -1;
            }
          } else {
            if (jumpedLine) {
              state.mContext.Truncate();
            }
            current = nextFrame;
            offset = nextFrameOffset;
            // Jumping a line is equivalent to encountering whitespace
            if (wordSelectEatSpace && jumpedLine)
              state.SetSawBeforeType();
          }
        }
      }
      
      // Set outputs
      range = GetRangeForFrame(current);
      aPos->mResultFrame = current;
      aPos->mResultContent = range.content;
      // Output offset is relative to content, not frame
      aPos->mContentOffset = (offset < 0 ? range.end : range.start + offset) + offsetAdjustment;
      break;
    }
    case eSelectLine :
    {
      nsAutoLineIterator iter;
      nsIFrame *blockFrame = this;

      while (NS_FAILED(result)){
        int32_t thisLine = nsFrame::GetLineNumber(blockFrame, aPos->mScrollViewStop, &blockFrame);
        if (thisLine < 0) 
          return  NS_ERROR_FAILURE;
        iter = blockFrame->GetLineIterator();
        NS_ASSERTION(iter, "GetLineNumber() succeeded but no block frame?");
        result = NS_OK;

        int edgeCase = 0; // no edge case. this should look at thisLine
        
        bool doneLooping = false; // tells us when no more block frames hit.
        // this part will find a frame or a block frame. if it's a block frame
        // it will "drill down" to find a viable frame or it will return an error.
        nsIFrame *lastFrame = this;
        do {
          result = nsFrame::GetNextPrevLineFromeBlockFrame(PresContext(),
                                                           aPos, 
                                                           blockFrame, 
                                                           thisLine, 
                                                           edgeCase); // start from thisLine

          // we came back to same spot! keep going
          if (NS_SUCCEEDED(result) &&
              (!aPos->mResultFrame || aPos->mResultFrame == lastFrame)) {
            aPos->mResultFrame = nullptr;
            if (aPos->mDirection == eDirPrevious)
              thisLine--;
            else
              thisLine++;
          } else // if failure or success with different frame.
            doneLooping = true; // do not continue with while loop

          lastFrame = aPos->mResultFrame; // set last frame

          // make sure block element is not the same as the one we had before
          if (NS_SUCCEEDED(result) &&
              aPos->mResultFrame &&
              blockFrame != aPos->mResultFrame) {
            /* SPECIAL CHECK FOR TABLE NAVIGATION
               tables need to navigate also and the frame that supports it is
               nsTableRowGroupFrame which is INSIDE nsTableWrapperFrame.
               If we have stumbled onto an nsTableWrapperFrame we need to drill
               into nsTableRowGroup if we hit a header or footer that's ok just
               go into them.
             */
            bool searchTableBool = false;
            if (aPos->mResultFrame->GetType() == nsGkAtoms::tableWrapperFrame ||
                aPos->mResultFrame->GetType() == nsGkAtoms::tableCellFrame) {
              nsIFrame* frame = aPos->mResultFrame->PrincipalChildList().FirstChild();
              // got the table frame now
              // ok time to drill down to find iterator
              while (frame) {
                iter = frame->GetLineIterator();
                if (iter) {
                  aPos->mResultFrame = frame;
                  searchTableBool = true;
                  result = NS_OK;
                  break; // while(frame)
                }
                result = NS_ERROR_FAILURE;
                frame = frame->PrincipalChildList().FirstChild();
              }
            }

            if (!searchTableBool) {
              iter = aPos->mResultFrame->GetLineIterator();
              result = iter ? NS_OK : NS_ERROR_FAILURE;
            }

            // we've struck another block element!
            if (NS_SUCCEEDED(result) && iter) {
              doneLooping = false;
              if (aPos->mDirection == eDirPrevious)
                edgeCase = 1; // far edge, search from end backwards
              else
                edgeCase = -1; // near edge search from beginning onwards
              thisLine = 0; // this line means nothing now.
              // everything else means something so keep looking "inside" the block
              blockFrame = aPos->mResultFrame;
            } else {
              // THIS is to mean that everything is ok to the containing while loop
              result = NS_OK;
              break;
            }
          }
        } while (!doneLooping);
      }
      return result;
    }

    case eSelectParagraph:
      return PeekOffsetParagraph(aPos);

    case eSelectBeginLine:
    case eSelectEndLine:
    {
      // Adjusted so that the caret can't get confused when content changes
      nsIFrame* blockFrame = AdjustFrameForSelectionStyles(this);
      int32_t thisLine = nsFrame::GetLineNumber(blockFrame, aPos->mScrollViewStop, &blockFrame);
      if (thisLine < 0)
        return NS_ERROR_FAILURE;
      nsAutoLineIterator it = blockFrame->GetLineIterator();
      NS_ASSERTION(it, "GetLineNumber() succeeded but no block frame?");

      int32_t lineFrameCount;
      nsIFrame *firstFrame;
      nsRect usedRect;
      nsIFrame* baseFrame = nullptr;
      bool endOfLine = (eSelectEndLine == aPos->mAmount);

      if (aPos->mVisual && PresContext()->BidiEnabled()) {
        bool lineIsRTL = it->GetDirection();
        bool isReordered;
        nsIFrame *lastFrame;
        result = it->CheckLineOrder(thisLine, &isReordered, &firstFrame, &lastFrame);
        baseFrame = endOfLine ? lastFrame : firstFrame;
        if (baseFrame) {
          bool frameIsRTL =
            (nsBidiPresUtils::FrameDirection(baseFrame) == NSBIDI_RTL);
          // If the direction of the frame on the edge is opposite to
          // that of the line, we'll need to drill down to its opposite
          // end, so reverse endOfLine.
          if (frameIsRTL != lineIsRTL) {
            endOfLine = !endOfLine;
          }
        }
      } else {
        it->GetLine(thisLine, &firstFrame, &lineFrameCount, usedRect);

        nsIFrame* frame = firstFrame;
        for (int32_t count = lineFrameCount; count;
             --count, frame = frame->GetNextSibling()) {
          if (!frame->IsGeneratedContentFrame()) {
            // When jumping to the end of the line with the "end" key,
            // skip over brFrames
            if (endOfLine && lineFrameCount > 1 &&
                frame->GetType() == nsGkAtoms::brFrame) {
              continue;
            }
            baseFrame = frame;
            if (!endOfLine)
              break;
          }
        }
      }
      if (!baseFrame)
        return NS_ERROR_FAILURE;
      FrameTarget targetFrame = DrillDownToSelectionFrame(baseFrame,
                                                          endOfLine, 0);
      FrameContentRange range = GetRangeForFrame(targetFrame.frame);
      aPos->mResultContent = range.content;
      aPos->mContentOffset = endOfLine ? range.end : range.start;
      if (endOfLine && targetFrame.frame->HasSignificantTerminalNewline()) {
        // Do not position the caret after the terminating newline if we're
        // trying to move to the end of line (see bug 596506)
        --aPos->mContentOffset;
      }
      aPos->mResultFrame = targetFrame.frame;
      aPos->mAttach = aPos->mContentOffset == range.start ?
          CARET_ASSOCIATE_AFTER : CARET_ASSOCIATE_BEFORE;
      if (!range.content)
        return NS_ERROR_FAILURE;
      return NS_OK;
    }

    default: 
    {
      NS_ASSERTION(false, "Invalid amount");
      return NS_ERROR_FAILURE;
    }
  }
  return NS_OK;
}

nsIFrame::FrameSearchResult
nsFrame::PeekOffsetNoAmount(bool aForward, int32_t* aOffset)
{
  NS_ASSERTION (aOffset && *aOffset <= 1, "aOffset out of range");
  // Sure, we can stop right here.
  return FOUND;
}

nsIFrame::FrameSearchResult
nsFrame::PeekOffsetCharacter(bool aForward, int32_t* aOffset,
                             bool aRespectClusters)
{
  NS_ASSERTION (aOffset && *aOffset <= 1, "aOffset out of range");
  int32_t startOffset = *aOffset;
  // A negative offset means "end of frame", which in our case means offset 1.
  if (startOffset < 0)
    startOffset = 1;
  if (aForward == (startOffset == 0)) {
    // We're before the frame and moving forward, or after it and moving backwards:
    // skip to the other side and we're done.
    *aOffset = 1 - startOffset;
    return FOUND;
  }
  return CONTINUE;
}

nsIFrame::FrameSearchResult
nsFrame::PeekOffsetWord(bool            aForward,
                        bool            aWordSelectEatSpace,
                        bool            aIsKeyboardSelect,
                        int32_t*        aOffset,
                        PeekWordState*  aState)
{
  NS_ASSERTION (aOffset && *aOffset <= 1, "aOffset out of range");
  int32_t startOffset = *aOffset;
  // This isn't text, so truncate the context
  aState->mContext.Truncate();
  if (startOffset < 0)
    startOffset = 1;
  if (aForward == (startOffset == 0)) {
    // We're before the frame and moving forward, or after it and moving backwards.
    // If we're looking for non-whitespace, we found it (without skipping this frame).
    if (!aState->mAtStart) {
      if (aState->mLastCharWasPunctuation) {
        // We're not punctuation, so this is a punctuation boundary.
        if (BreakWordBetweenPunctuation(aState, aForward, false, false, aIsKeyboardSelect))
          return FOUND;
      } else {
        // This is not a punctuation boundary.
        if (aWordSelectEatSpace && aState->mSawBeforeType)
          return FOUND;
      }
    }
    // Otherwise skip to the other side and note that we encountered non-whitespace.
    *aOffset = 1 - startOffset;
    aState->Update(false, // not punctuation
                   false     // not whitespace
                   );
    if (!aWordSelectEatSpace)
      aState->SetSawBeforeType();
  }
  return CONTINUE;
}

bool
nsFrame::BreakWordBetweenPunctuation(const PeekWordState* aState,
                                     bool aForward,
                                     bool aPunctAfter, bool aWhitespaceAfter,
                                     bool aIsKeyboardSelect)
{
  NS_ASSERTION(aPunctAfter != aState->mLastCharWasPunctuation,
               "Call this only at punctuation boundaries");
  if (aState->mLastCharWasWhitespace) {
    // We always stop between whitespace and punctuation
    return true;
  }
  if (!Preferences::GetBool("layout.word_select.stop_at_punctuation")) {
    // When this pref is false, we never stop at a punctuation boundary unless
    // it's followed by whitespace (in the relevant direction).
    return aWhitespaceAfter;
  }
  if (!aIsKeyboardSelect) {
    // mouse caret movement (e.g. word selection) always stops at every punctuation boundary
    return true;
  }
  bool afterPunct = aForward ? aState->mLastCharWasPunctuation : aPunctAfter;
  if (!afterPunct) {
    // keyboard caret movement only stops after punctuation (in content order)
    return false;
  }
  // Stop only if we've seen some non-punctuation since the last whitespace;
  // don't stop after punctuation that follows whitespace.
  return aState->mSeenNonPunctuationSinceWhitespace;
}

nsresult
nsFrame::CheckVisibility(nsPresContext* , int32_t , int32_t , bool , bool *, bool *)
{
  return NS_ERROR_NOT_IMPLEMENTED;
}


int32_t
nsFrame::GetLineNumber(nsIFrame *aFrame, bool aLockScroll, nsIFrame** aContainingBlock)
{
  NS_ASSERTION(aFrame, "null aFrame");
  nsFrameManager* frameManager = aFrame->PresContext()->FrameManager();
  nsIFrame *blockFrame = aFrame;
  nsIFrame *thisBlock;
  nsAutoLineIterator it;
  nsresult result = NS_ERROR_FAILURE;
  while (NS_FAILED(result) && blockFrame)
  {
    thisBlock = blockFrame;
    if (thisBlock->GetStateBits() & NS_FRAME_OUT_OF_FLOW) {
      //if we are searching for a frame that is not in flow we will not find it. 
      //we must instead look for its placeholder
      if (thisBlock->GetStateBits() & NS_FRAME_IS_OVERFLOW_CONTAINER) {
        // abspos continuations don't have placeholders, get the fif
        thisBlock = thisBlock->FirstInFlow();
      }
      thisBlock = frameManager->GetPlaceholderFrameFor(thisBlock);
      if (!thisBlock)
        return -1;
    }  
    blockFrame = thisBlock->GetParent();
    result = NS_OK;
    if (blockFrame) {
      if (aLockScroll && blockFrame->GetType() == nsGkAtoms::scrollFrame)
        return -1;
      it = blockFrame->GetLineIterator();
      if (!it)
        result = NS_ERROR_FAILURE;
    }
  }
  if (!blockFrame || !it)
    return -1;

  if (aContainingBlock)
    *aContainingBlock = blockFrame;
  return it->FindLineContaining(thisBlock);
}

nsresult
nsIFrame::GetFrameFromDirection(nsDirection aDirection, bool aVisual,
                                bool aJumpLines, bool aScrollViewStop,
                                nsIFrame** aOutFrame, int32_t* aOutOffset,
                                bool* aOutJumpedLine, bool* aOutMovedOverNonSelectableText)
{
  nsresult result;

  if (!aOutFrame || !aOutOffset || !aOutJumpedLine)
    return NS_ERROR_NULL_POINTER;
  
  nsPresContext* presContext = PresContext();
  *aOutFrame = nullptr;
  *aOutOffset = 0;
  *aOutJumpedLine = false;
  *aOutMovedOverNonSelectableText = false;

  // Find the prev/next selectable frame
  bool selectable = false;
  nsIFrame *traversedFrame = this;
  while (!selectable) {
    nsIFrame *blockFrame;
    
    int32_t thisLine = nsFrame::GetLineNumber(traversedFrame, aScrollViewStop, &blockFrame);
    if (thisLine < 0)
      return NS_ERROR_FAILURE;

    nsAutoLineIterator it = blockFrame->GetLineIterator();
    NS_ASSERTION(it, "GetLineNumber() succeeded but no block frame?");

    bool atLineEdge;
    nsIFrame *firstFrame;
    nsIFrame *lastFrame;
    if (aVisual && presContext->BidiEnabled()) {
      bool lineIsRTL = it->GetDirection();
      bool isReordered;
      result = it->CheckLineOrder(thisLine, &isReordered, &firstFrame, &lastFrame);
      nsIFrame** framePtr = aDirection == eDirPrevious ? &firstFrame : &lastFrame;
      if (*framePtr) {
        bool frameIsRTL =
          (nsBidiPresUtils::FrameDirection(*framePtr) == NSBIDI_RTL);
        if ((frameIsRTL == lineIsRTL) == (aDirection == eDirPrevious)) {
          nsFrame::GetFirstLeaf(presContext, framePtr);
        } else {
          nsFrame::GetLastLeaf(presContext, framePtr);
        }
        atLineEdge = *framePtr == traversedFrame;
      } else {
        atLineEdge = true;
      }
    } else {
      nsRect  nonUsedRect;
      int32_t lineFrameCount;
      result = it->GetLine(thisLine, &firstFrame, &lineFrameCount,
                           nonUsedRect);
      if (NS_FAILED(result))
        return result;

      if (aDirection == eDirPrevious) {
        nsFrame::GetFirstLeaf(presContext, &firstFrame);
        atLineEdge = firstFrame == traversedFrame;
      } else { // eDirNext
        lastFrame = firstFrame;
        for (;lineFrameCount > 1;lineFrameCount --){
          result = it->GetNextSiblingOnLine(lastFrame, thisLine);
          if (NS_FAILED(result) || !lastFrame){
            NS_ERROR("should not be reached nsFrame");
            return NS_ERROR_FAILURE;
          }
        }
        nsFrame::GetLastLeaf(presContext, &lastFrame);
        atLineEdge = lastFrame == traversedFrame;
      }
    }

    if (atLineEdge) {
      *aOutJumpedLine = true;
      if (!aJumpLines)
        return NS_ERROR_FAILURE; //we are done. cannot jump lines
    }

    nsCOMPtr<nsIFrameEnumerator> frameTraversal;
    result = NS_NewFrameTraversal(getter_AddRefs(frameTraversal),
                                  presContext, traversedFrame,
                                  eLeaf,
                                  aVisual && presContext->BidiEnabled(),
                                  aScrollViewStop,
                                  true,  // aFollowOOFs
                                  false  // aSkipPopupChecks
                                  );
    if (NS_FAILED(result))
      return result;

    if (aDirection == eDirNext)
      frameTraversal->Next();
    else
      frameTraversal->Prev();

    traversedFrame = frameTraversal->CurrentItem();

    // Skip anonymous elements, but watch out for generated content
    if (!traversedFrame ||
        (!traversedFrame->IsGeneratedContentFrame() &&
         traversedFrame->GetContent()->IsRootOfNativeAnonymousSubtree())) {
      return NS_ERROR_FAILURE;
    }

    // Skip brFrames, but only if they are not the only frame in the line
    if (atLineEdge && aDirection == eDirPrevious &&
        traversedFrame->GetType() == nsGkAtoms::brFrame) {
      int32_t lineFrameCount;
      nsIFrame *currentBlockFrame, *currentFirstFrame;
      nsRect usedRect;
      int32_t currentLine = nsFrame::GetLineNumber(traversedFrame, aScrollViewStop, &currentBlockFrame);
      nsAutoLineIterator iter = currentBlockFrame->GetLineIterator();
      result = iter->GetLine(currentLine, &currentFirstFrame, &lineFrameCount, usedRect);
      if (NS_FAILED(result)) {
        return result;
      }
      if (lineFrameCount > 1) {
        continue;
      }
    }

    traversedFrame->IsSelectable(&selectable, nullptr);
    if (!selectable) {
      *aOutMovedOverNonSelectableText = true;
    }
  } // while (!selectable)

  *aOutOffset = (aDirection == eDirNext) ? 0 : -1;

  if (aVisual && IsReversedDirectionFrame(traversedFrame)) {
    // The new frame is reverse-direction, go to the other end
    *aOutOffset = -1 - *aOutOffset;
  }
  *aOutFrame = traversedFrame;
  return NS_OK;
}

nsView* nsIFrame::GetClosestView(nsPoint* aOffset) const
{
  nsPoint offset(0,0);
  for (const nsIFrame *f = this; f; f = f->GetParent()) {
    if (f->HasView()) {
      if (aOffset)
        *aOffset = offset;
      return f->GetView();
    }
    offset += f->GetPosition();
  }

  NS_NOTREACHED("No view on any parent?  How did that happen?");
  return nullptr;
}


/* virtual */ void
nsFrame::ChildIsDirty(nsIFrame* aChild)
{
  NS_NOTREACHED("should never be called on a frame that doesn't inherit from "
                "nsContainerFrame");
}


#ifdef ACCESSIBILITY
a11y::AccType
nsFrame::AccessibleType()
{
  if (IsTableCaption() && !GetRect().IsEmpty()) {
    return a11y::eHTMLCaptionType;
  }
  return a11y::eNoType;
}
#endif

NS_DECLARE_FRAME_PROPERTY_DELETABLE(OverflowAreasProperty, nsOverflowAreas)

bool
nsIFrame::ClearOverflowRects()
{
  if (mOverflow.mType == NS_FRAME_OVERFLOW_NONE) {
    return false;
  }
  if (mOverflow.mType == NS_FRAME_OVERFLOW_LARGE) {
    Properties().Delete(OverflowAreasProperty());
  }
  mOverflow.mType = NS_FRAME_OVERFLOW_NONE;
  return true;
}

/** Create or retrieve the previously stored overflow area, if the frame does 
 * not overflow and no creation is required return nullptr.
 * @return pointer to the overflow area rectangle 
 */
nsOverflowAreas*
nsIFrame::GetOverflowAreasProperty()
{
  FrameProperties props = Properties();
  nsOverflowAreas* overflow = props.Get(OverflowAreasProperty());

  if (overflow) {
    return overflow; // the property already exists
  }

  // The property isn't set yet, so allocate a new rect, set the property,
  // and return the newly allocated rect
  overflow = new nsOverflowAreas;
  props.Set(OverflowAreasProperty(), overflow);
  return overflow;
}

/** Set the overflowArea rect, storing it as deltas or a separate rect
 * depending on its size in relation to the primary frame rect.
 */
bool
nsIFrame::SetOverflowAreas(const nsOverflowAreas& aOverflowAreas)
{
  if (mOverflow.mType == NS_FRAME_OVERFLOW_LARGE) {
    nsOverflowAreas* overflow = Properties().Get(OverflowAreasProperty());
    bool changed = *overflow != aOverflowAreas;
    *overflow = aOverflowAreas;

    // Don't bother with converting to the deltas form if we already
    // have a property.
    return changed;
  }

  const nsRect& vis = aOverflowAreas.VisualOverflow();
  uint32_t l = -vis.x, // left edge: positive delta is leftwards
           t = -vis.y, // top: positive is upwards
           r = vis.XMost() - mRect.width, // right: positive is rightwards
           b = vis.YMost() - mRect.height; // bottom: positive is downwards
  if (aOverflowAreas.ScrollableOverflow().IsEqualEdges(nsRect(nsPoint(0, 0), GetSize())) &&
      l <= NS_FRAME_OVERFLOW_DELTA_MAX &&
      t <= NS_FRAME_OVERFLOW_DELTA_MAX &&
      r <= NS_FRAME_OVERFLOW_DELTA_MAX &&
      b <= NS_FRAME_OVERFLOW_DELTA_MAX &&
      // we have to check these against zero because we *never* want to
      // set a frame as having no overflow in this function.  This is
      // because FinishAndStoreOverflow calls this function prior to
      // SetRect based on whether the overflow areas match aNewSize.
      // In the case where the overflow areas exactly match mRect but
      // do not match aNewSize, we need to store overflow in a property
      // so that our eventual SetRect/SetSize will know that it has to
      // reset our overflow areas.
      (l | t | r | b) != 0) {
    VisualDeltas oldDeltas = mOverflow.mVisualDeltas;
    // It's a "small" overflow area so we store the deltas for each edge
    // directly in the frame, rather than allocating a separate rect.
    // If they're all zero, that's fine; we're setting things to
    // no-overflow.
    mOverflow.mVisualDeltas.mLeft   = l;
    mOverflow.mVisualDeltas.mTop    = t;
    mOverflow.mVisualDeltas.mRight  = r;
    mOverflow.mVisualDeltas.mBottom = b;
    // There was no scrollable overflow before, and there isn't now.
    return oldDeltas != mOverflow.mVisualDeltas;
  } else {
    bool changed = !aOverflowAreas.ScrollableOverflow().IsEqualEdges(nsRect(nsPoint(0, 0), GetSize())) ||
      !aOverflowAreas.VisualOverflow().IsEqualEdges(GetVisualOverflowFromDeltas());

    // it's a large overflow area that we need to store as a property
    mOverflow.mType = NS_FRAME_OVERFLOW_LARGE;
    nsOverflowAreas* overflow = GetOverflowAreasProperty();
    NS_ASSERTION(overflow, "should have created areas");
    *overflow = aOverflowAreas;
    return changed;
  }
}

inline bool
IsInlineFrame(nsIFrame *aFrame)
{
  nsIAtom *type = aFrame->GetType();
  return type == nsGkAtoms::inlineFrame;
}

/**
 * Compute the union of the border boxes of aFrame and its descendants,
 * in aFrame's coordinate space (if aApplyTransform is false) or its
 * post-transform coordinate space (if aApplyTransform is true).
 */
static nsRect
UnionBorderBoxes(nsIFrame* aFrame, bool aApplyTransform,
                 bool& aOutValid,
                 const nsSize* aSizeOverride = nullptr,
                 const nsOverflowAreas* aOverflowOverride = nullptr)
{
  const nsRect bounds(nsPoint(0, 0),
                      aSizeOverride ? *aSizeOverride : aFrame->GetSize());

  // The SVG container frames do not maintain an accurate mRect.
  // It will make the outline be larger than we expect, we need
  // to make them narrow to their children's outline.
  // aOutValid is set to false if the returned nsRect is not valid
  // and should not be included in the outline rectangle.
  aOutValid = !aFrame->IsFrameOfType(nsIFrame::eSVGContainer);

  // Start from our border-box, transformed.  See comment below about
  // transform of children.
  nsRect u;
  bool doTransform = aApplyTransform && aFrame->IsTransformed();
  if (doTransform) {
    u = nsDisplayTransform::TransformRect(bounds, aFrame, &bounds);
  } else {
    u = bounds;
  }

  // Only iterate through the children if the overflow areas suggest
  // that we might need to, and if the frame doesn't clip its overflow
  // anyway.
  if (aOverflowOverride) {
    if (!doTransform &&
        bounds.IsEqualEdges(aOverflowOverride->VisualOverflow()) &&
        bounds.IsEqualEdges(aOverflowOverride->ScrollableOverflow())) {
      return u;
    }
  } else {
    if (!doTransform &&
        bounds.IsEqualEdges(aFrame->GetVisualOverflowRect()) &&
        bounds.IsEqualEdges(aFrame->GetScrollableOverflowRect())) {
      return u;
    }
  }
  const nsStyleDisplay* disp = aFrame->StyleDisplay();
  nsIAtom* fType = aFrame->GetType();
  if (nsFrame::ShouldApplyOverflowClipping(aFrame, disp) ||
      fType == nsGkAtoms::scrollFrame ||
      fType == nsGkAtoms::listControlFrame ||
      fType == nsGkAtoms::svgOuterSVGFrame) {
    return u;
  }

  const nsStyleEffects* effects = aFrame->StyleEffects();
  Maybe<nsRect> clipPropClipRect =
    aFrame->GetClipPropClipRect(disp, effects, bounds.Size());

  // Iterate over all children except pop-ups.
  const nsIFrame::ChildListIDs skip(nsIFrame::kPopupList |
                                    nsIFrame::kSelectPopupList);
  for (nsIFrame::ChildListIterator childLists(aFrame);
       !childLists.IsDone(); childLists.Next()) {
    if (skip.Contains(childLists.CurrentID())) {
      continue;
    }

    nsFrameList children = childLists.CurrentList();
    for (nsFrameList::Enumerator e(children); !e.AtEnd(); e.Next()) {
      nsIFrame* child = e.get();
      // Note that passing |true| for aApplyTransform when
      // child->Combines3DTransformWithAncestors() is incorrect if our
      // aApplyTransform is false... but the opposite would be as
      // well.  This is because elements within a preserve-3d scene
      // are always transformed up to the top of the scene.  This
      // means we don't have a mechanism for getting a transform up to
      // an intermediate point within the scene.  We choose to
      // over-transform rather than under-transform because this is
      // consistent with other overflow areas.
      bool validRect = true;
      nsRect childRect = UnionBorderBoxes(child, true, validRect) +
                         child->GetPosition();

      if (!validRect) {
        continue;
      }

      if (clipPropClipRect) {
        // Intersect with the clip before transforming.
        childRect.IntersectRect(childRect, *clipPropClipRect);
      }

      // Note that we transform each child separately according to
      // aFrame's transform, and then union, which gives a different
      // (smaller) result from unioning and then transforming the
      // union.  This doesn't match the way we handle overflow areas
      // with 2-D transforms, though it does match the way we handle
      // overflow areas in preserve-3d 3-D scenes.
      if (doTransform && !child->Combines3DTransformWithAncestors()) {
        childRect = nsDisplayTransform::TransformRect(childRect, aFrame, &bounds);
      }

      // If a SVGContainer has a non-SVGContainer child, we assign
      // its child's outline to this SVGContainer directly.
      if (!aOutValid && validRect) {
        u = childRect;
        aOutValid = true;
      } else {
        u.UnionRectEdges(u, childRect);
      }
    }
  }

  return u;
}

static void
ComputeAndIncludeOutlineArea(nsIFrame* aFrame, nsOverflowAreas& aOverflowAreas,
                             const nsSize& aNewSize)
{
  const nsStyleOutline* outline = aFrame->StyleOutline();
  const uint8_t outlineStyle = outline->mOutlineStyle;
  if (outlineStyle == NS_STYLE_BORDER_STYLE_NONE) {
    return;
  }

  nscoord width = outline->GetOutlineWidth();
  if (width <= 0 && outlineStyle != NS_STYLE_BORDER_STYLE_AUTO) {
    return;
  }

  // When the outline property is set on :-moz-anonymous-block or
  // :-moz-anonymous-positioned-block pseudo-elements, it inherited
  // that outline from the inline that was broken because it
  // contained a block.  In that case, we don't want a really wide
  // outline if the block inside the inline is narrow, so union the
  // actual contents of the anonymous blocks.
  nsIFrame *frameForArea = aFrame;
  do {
    nsIAtom *pseudoType = frameForArea->StyleContext()->GetPseudo();
    if (pseudoType != nsCSSAnonBoxes::mozAnonymousBlock &&
        pseudoType != nsCSSAnonBoxes::mozAnonymousPositionedBlock)
      break;
    // If we're done, we really want it and all its later siblings.
    frameForArea = frameForArea->PrincipalChildList().FirstChild();
    NS_ASSERTION(frameForArea, "anonymous block with no children?");
  } while (frameForArea);

  // Find the union of the border boxes of all descendants, or in
  // the block-in-inline case, all descendants we care about.
  //
  // Note that the interesting perspective-related cases are taken
  // care of by the code that handles those issues for overflow
  // calling FinishAndStoreOverflow again, which in turn calls this
  // function again.  We still need to deal with preserve-3d a bit.
  nsRect innerRect;
  bool validRect;
  if (frameForArea == aFrame) {
    innerRect = UnionBorderBoxes(aFrame, false, validRect, &aNewSize, &aOverflowAreas);
  } else {
    for (; frameForArea; frameForArea = frameForArea->GetNextSibling()) {
      nsRect r(UnionBorderBoxes(frameForArea, true, validRect));

      // Adjust for offsets transforms up to aFrame's pre-transform
      // (i.e., normal) coordinate space; see comments in
      // UnionBorderBoxes for some of the subtlety here.
      for (nsIFrame *f = frameForArea, *parent = f->GetParent();
           /* see middle of loop */;
           f = parent, parent = f->GetParent()) {
        r += f->GetPosition();
        if (parent == aFrame) {
          break;
        }
        if (parent->IsTransformed() && !f->Combines3DTransformWithAncestors()) {
          r = nsDisplayTransform::TransformRect(r, parent);
        }
      }

      innerRect.UnionRect(innerRect, r);
    }
  }

  // Keep this code in sync with GetOutlineInnerRect in nsCSSRendering.cpp.
  aFrame->Properties().Set(nsIFrame::OutlineInnerRectProperty(),
                           new nsRect(innerRect));
  const nscoord offset = outline->mOutlineOffset;
  nsRect outerRect(innerRect);
  bool useOutlineAuto = false;
  if (nsLayoutUtils::IsOutlineStyleAutoEnabled()) {
    useOutlineAuto = outlineStyle == NS_STYLE_BORDER_STYLE_AUTO;
    if (MOZ_UNLIKELY(useOutlineAuto)) {
      nsPresContext* presContext = aFrame->PresContext();
      nsITheme* theme = presContext->GetTheme();
      if (theme && theme->ThemeSupportsWidget(presContext, aFrame,
                                              NS_THEME_FOCUS_OUTLINE)) {
        outerRect.Inflate(offset);
        theme->GetWidgetOverflow(presContext->DeviceContext(), aFrame,
                                 NS_THEME_FOCUS_OUTLINE, &outerRect);
      } else {
        useOutlineAuto = false;
      }
    }
  }
  if (MOZ_LIKELY(!useOutlineAuto)) {
    outerRect.Inflate(width + offset);
  }

  nsRect& vo = aOverflowAreas.VisualOverflow();
  vo.UnionRectEdges(vo, innerRect.Union(outerRect));
}

bool
nsIFrame::FinishAndStoreOverflow(nsOverflowAreas& aOverflowAreas,
                                 nsSize aNewSize, nsSize* aOldSize)
{
  NS_ASSERTION(FrameMaintainsOverflow(),
               "Don't call - overflow rects not maintained on these SVG frames");

  nsRect bounds(nsPoint(0, 0), aNewSize);
  // Store the passed in overflow area if we are a preserve-3d frame or we have
  // a transform, and it's not just the frame bounds.
  if (Combines3DTransformWithAncestors() || IsTransformed()) {
    if (!aOverflowAreas.VisualOverflow().IsEqualEdges(bounds) ||
        !aOverflowAreas.ScrollableOverflow().IsEqualEdges(bounds)) {
      nsOverflowAreas* initial =
        Properties().Get(nsIFrame::InitialOverflowProperty());
      if (!initial) {
        Properties().Set(nsIFrame::InitialOverflowProperty(),
                         new nsOverflowAreas(aOverflowAreas));
      } else if (initial != &aOverflowAreas) {
        *initial = aOverflowAreas;
      }
    } else {
      Properties().Delete(nsIFrame::InitialOverflowProperty());
    }
#ifdef DEBUG
    Properties().Set(nsIFrame::DebugInitialOverflowPropertyApplied(), true);
#endif
  } else {
#ifdef DEBUG
    Properties().Delete(nsIFrame::DebugInitialOverflowPropertyApplied());
#endif
  }

  // This is now called FinishAndStoreOverflow() instead of 
  // StoreOverflow() because frame-generic ways of adding overflow
  // can happen here, e.g. CSS2 outline and native theme.
  // If the overflow area width or height is nscoord_MAX, then a
  // saturating union may have encounted an overflow, so the overflow may not
  // contain the frame border-box. Don't warn in that case.
  // Don't warn for SVG either, since SVG doesn't need the overflow area
  // to contain the frame bounds.
  NS_FOR_FRAME_OVERFLOW_TYPES(otype) {
    DebugOnly<nsRect*> r = &aOverflowAreas.Overflow(otype);
    NS_ASSERTION(aNewSize.width == 0 || aNewSize.height == 0 ||
                 r->width == nscoord_MAX || r->height == nscoord_MAX ||
                 (mState & NS_FRAME_SVG_LAYOUT) ||
                 r->Contains(nsRect(nsPoint(0,0), aNewSize)),
                 "Computed overflow area must contain frame bounds");
  }

  // If we clip our children, clear accumulated overflow area. The
  // children are actually clipped to the padding-box, but since the
  // overflow area should include the entire border-box, just set it to
  // the border-box here.
  const nsStyleDisplay* disp = StyleDisplay();
  NS_ASSERTION((disp->mOverflowY == NS_STYLE_OVERFLOW_CLIP) ==
               (disp->mOverflowX == NS_STYLE_OVERFLOW_CLIP),
               "If one overflow is clip, the other should be too");
  if (nsFrame::ShouldApplyOverflowClipping(this, disp)) {
    // The contents are actually clipped to the padding area 
    aOverflowAreas.SetAllTo(bounds);
  }

  // Overflow area must always include the frame's top-left and bottom-right,
  // even if the frame rect is empty (so we can scroll to those positions).
  // Pending a real fix for bug 426879, don't do this for inline frames
  // with zero width.
  // Do not do this for SVG either, since it will usually massively increase
  // the area unnecessarily.
  if ((aNewSize.width != 0 || !IsInlineFrame(this)) &&
      !(GetStateBits() & NS_FRAME_SVG_LAYOUT)) {
    NS_FOR_FRAME_OVERFLOW_TYPES(otype) {
      nsRect& o = aOverflowAreas.Overflow(otype);
      o.UnionRectEdges(o, bounds);
    }
  }

  // Note that NS_STYLE_OVERFLOW_CLIP doesn't clip the frame background,
  // so we add theme background overflow here so it's not clipped.
  if (!::IsXULBoxWrapped(this) && IsThemed(disp)) {
    nsRect r(bounds);
    nsPresContext *presContext = PresContext();
    if (presContext->GetTheme()->
          GetWidgetOverflow(presContext->DeviceContext(), this,
                            disp->mAppearance, &r)) {
      nsRect& vo = aOverflowAreas.VisualOverflow();
      vo.UnionRectEdges(vo, r);
    }
  }

  ComputeAndIncludeOutlineArea(this, aOverflowAreas, aNewSize);

  // Nothing in here should affect scrollable overflow.
  aOverflowAreas.VisualOverflow() =
    ComputeEffectsRect(this, aOverflowAreas.VisualOverflow(), aNewSize);

  // Absolute position clipping
  const nsStyleEffects* effects = StyleEffects();
  Maybe<nsRect> clipPropClipRect =
    GetClipPropClipRect(disp, effects, aNewSize);
  if (clipPropClipRect) {
    NS_FOR_FRAME_OVERFLOW_TYPES(otype) {
      nsRect& o = aOverflowAreas.Overflow(otype);
      o.IntersectRect(o, *clipPropClipRect);
    }
  }

  /* If we're transformed, transform the overflow rect by the current transformation. */
  bool hasTransform = IsTransformed();
  nsSize oldSize = mRect.Size();
  bool sizeChanged = ((aOldSize ? *aOldSize : oldSize) != aNewSize);

  /* Since our size might not actually have been computed yet, we need to make sure that we use the
   * correct dimensions by overriding the stored bounding rectangle with the value the caller has
   * ensured us we'll use.
   */
  SetSize(aNewSize);

  if (ChildrenHavePerspective() && sizeChanged) {
    nsRect newBounds(nsPoint(0, 0), aNewSize);
    RecomputePerspectiveChildrenOverflow(this);
  }

  if (hasTransform) {
    Properties().Set(nsIFrame::PreTransformOverflowAreasProperty(),
                     new nsOverflowAreas(aOverflowAreas));

    if (Combines3DTransformWithAncestors()) {
      /* If we're a preserve-3d leaf frame, then our pre-transform overflow should be correct. Our
       * post-transform overflow is empty though, because we only contribute to the overflow area
       * of the preserve-3d root frame.
       * If we're an intermediate frame then the pre-transform overflow should contain all our
       * non-preserve-3d children, which is what we want. Again we have no post-transform overflow.
       */
      aOverflowAreas.SetAllTo(nsRect());
    } else {
      NS_FOR_FRAME_OVERFLOW_TYPES(otype) {
        nsRect& o = aOverflowAreas.Overflow(otype);
        o = nsDisplayTransform::TransformRect(o, this);
      }

      /* If we're the root of the 3d context, then we want to include the overflow areas of all
       * the participants. This won't have happened yet as the code above set their overflow
       * area to empty. Manually collect these overflow areas now.
       */
      if (Extend3DContext()) {
        ComputePreserve3DChildrenOverflow(aOverflowAreas);
      }
    }
  } else {
    Properties().Delete(nsIFrame::PreTransformOverflowAreasProperty());
  }

  /* Revert the size change in case some caller is depending on this. */
  SetSize(oldSize);

  bool anyOverflowChanged;
  if (aOverflowAreas != nsOverflowAreas(bounds, bounds)) {
    anyOverflowChanged = SetOverflowAreas(aOverflowAreas);
  } else {
    anyOverflowChanged = ClearOverflowRects();
  }

  if (anyOverflowChanged) {
    nsSVGEffects::InvalidateDirectRenderingObservers(this);
  }
  return anyOverflowChanged;
}

void
nsIFrame::RecomputePerspectiveChildrenOverflow(const nsIFrame* aStartFrame)
{
  nsIFrame::ChildListIterator lists(this);
  for (; !lists.IsDone(); lists.Next()) {
    nsFrameList::Enumerator childFrames(lists.CurrentList());
    for (; !childFrames.AtEnd(); childFrames.Next()) {
      nsIFrame* child = childFrames.get();
      if (!child->FrameMaintainsOverflow()) {
        continue; // frame does not maintain overflow rects
      }
      if (child->HasPerspective()) {
        nsOverflowAreas* overflow = 
          child->Properties().Get(nsIFrame::InitialOverflowProperty());
        nsRect bounds(nsPoint(0, 0), child->GetSize());
        if (overflow) {
          nsOverflowAreas overflowCopy = *overflow;
          child->FinishAndStoreOverflow(overflowCopy, bounds.Size());
        } else {
          nsOverflowAreas boundsOverflow;
          boundsOverflow.SetAllTo(bounds);
          child->FinishAndStoreOverflow(boundsOverflow, bounds.Size());
        }
      } else if (child->GetContainingBlock(SKIP_SCROLLED_FRAME) == aStartFrame) {
        // If a frame is using perspective, then the size used to compute
        // perspective-origin is the size of the frame belonging to its parent
        // style context. We must find any descendant frames using our size
        // (by recursing into frames that have the same containing block)
        // to update their overflow rects too.
        child->RecomputePerspectiveChildrenOverflow(aStartFrame);
      }
    }
  }
}

void
nsIFrame::ComputePreserve3DChildrenOverflow(nsOverflowAreas& aOverflowAreas)
{
  // Find all descendants that participate in the 3d context, and include their overflow.
  // These descendants have an empty overflow, so won't have been included in the normal
  // overflow calculation. Any children that don't participate have normal overflow,
  // so will have been included already.

  nsRect childVisual;
  nsRect childScrollable;
  nsIFrame::ChildListIterator lists(this);
  for (; !lists.IsDone(); lists.Next()) {
    nsFrameList::Enumerator childFrames(lists.CurrentList());
    for (; !childFrames.AtEnd(); childFrames.Next()) {
      nsIFrame* child = childFrames.get();

      // If this child participates in the 3d context, then take the pre-transform
      // region (which contains all descendants that aren't participating in the 3d context)
      // and transform it into the 3d context root coordinate space.
      if (child->Combines3DTransformWithAncestors()) {
        nsOverflowAreas childOverflow = child->GetOverflowAreasRelativeToSelf();

        NS_FOR_FRAME_OVERFLOW_TYPES(otype) {
          nsRect& o = childOverflow.Overflow(otype);
          o = nsDisplayTransform::TransformRect(o, child);
        }

        aOverflowAreas.UnionWith(childOverflow);

        // If this child also extends the 3d context, then recurse into it
        // looking for more participants.
        if (child->Extend3DContext()) {
          child->ComputePreserve3DChildrenOverflow(aOverflowAreas);
        }
      }
    }
  }
}

uint32_t
nsIFrame::GetDepthInFrameTree() const
{
  uint32_t result = 0;
  for (nsContainerFrame* ancestor = GetParent(); ancestor;
       ancestor = ancestor->GetParent()) {
    result++;
  }
  return result;
}

void
nsFrame::ConsiderChildOverflow(nsOverflowAreas& aOverflowAreas,
                               nsIFrame* aChildFrame)
{
  aOverflowAreas.UnionWith(aChildFrame->GetOverflowAreas() +
                           aChildFrame->GetPosition());
}

/**
 * This function takes a frame that is part of a block-in-inline split,
 * and _if_ that frame is an anonymous block created by an ib split it
 * returns the block's preceding inline.  This is needed because the
 * split inline's style context is the parent of the anonymous block's
 * style context.
 *
 * If aFrame is not an anonymous block, null is returned.
 */
static nsIFrame*
GetIBSplitSiblingForAnonymousBlock(const nsIFrame* aFrame)
{
  NS_PRECONDITION(aFrame, "Must have a non-null frame!");
  NS_ASSERTION(aFrame->GetStateBits() & NS_FRAME_PART_OF_IBSPLIT,
               "GetIBSplitSibling should only be called on ib-split frames");

  nsIAtom* type = aFrame->StyleContext()->GetPseudo();
  if (type != nsCSSAnonBoxes::mozAnonymousBlock &&
      type != nsCSSAnonBoxes::mozAnonymousPositionedBlock) {
    // it's not an anonymous block
    return nullptr;
  }

  // Find the first continuation of the frame.  (Ugh.  This ends up
  // being O(N^2) when it is called O(N) times.)
  aFrame = aFrame->FirstContinuation();

  /*
   * Now look up the nsGkAtoms::IBSplitPrevSibling
   * property.
   */
  nsIFrame *ibSplitSibling =
    aFrame->Properties().Get(nsIFrame::IBSplitPrevSibling());
  NS_ASSERTION(ibSplitSibling, "Broken frame tree?");
  return ibSplitSibling;
}

/**
 * Get the parent, corrected for the mangled frame tree resulting from
 * having a block within an inline.  The result only differs from the
 * result of |GetParent| when |GetParent| returns an anonymous block
 * that was created for an element that was 'display: inline' because
 * that element contained a block.
 *
 * Also skip anonymous scrolled-content parents; inherit directly from the
 * outer scroll frame.
 */
static nsIFrame*
GetCorrectedParent(const nsIFrame* aFrame)
{
  nsIFrame* parent = aFrame->GetParent();
  if (!parent) {
    return nullptr;
  }

  // For a table caption we want the _inner_ table frame (unless it's anonymous)
  // as the style parent.
  if (aFrame->IsTableCaption()) {
    nsIFrame* innerTable = parent->PrincipalChildList().FirstChild();
    if (!innerTable->StyleContext()->GetPseudo()) {
      return innerTable;
    }
  }

  // Table wrappers are always anon boxes; if we're in here for an outer
  // table, that actually means its the _inner_ table that wants to
  // know its parent. So get the pseudo of the inner in that case.
  nsIAtom* pseudo = aFrame->StyleContext()->GetPseudo();
  if (pseudo == nsCSSAnonBoxes::tableWrapper) {
    pseudo = aFrame->PrincipalChildList().FirstChild()->StyleContext()->GetPseudo();
  }
  return nsFrame::CorrectStyleParentFrame(parent, pseudo);
}

/* static */
nsIFrame*
nsFrame::CorrectStyleParentFrame(nsIFrame* aProspectiveParent,
                                 nsIAtom* aChildPseudo)
{
  NS_PRECONDITION(aProspectiveParent, "Must have a prospective parent");

  // Anon boxes are parented to their actual parent already, except
  // for non-elements.  Those should not be treated as an anon box.
  if (aChildPseudo && !nsCSSAnonBoxes::IsNonElement(aChildPseudo) &&
      nsCSSAnonBoxes::IsAnonBox(aChildPseudo)) {
    NS_ASSERTION(aChildPseudo != nsCSSAnonBoxes::mozAnonymousBlock &&
                 aChildPseudo != nsCSSAnonBoxes::mozAnonymousPositionedBlock,
                 "Should have dealt with kids that have "
                 "NS_FRAME_PART_OF_IBSPLIT elsewhere");
    return aProspectiveParent;
  }

  // Otherwise, walk up out of all anon boxes.  For placeholder frames, walk out
  // of all pseudo-elements as well.  Otherwise ReparentStyleContext could cause
  // style data to be out of sync with the frame tree.
  nsIFrame* parent = aProspectiveParent;
  do {
    if (parent->GetStateBits() & NS_FRAME_PART_OF_IBSPLIT) {
      nsIFrame* sibling = GetIBSplitSiblingForAnonymousBlock(parent);

      if (sibling) {
        // |parent| was a block in an {ib} split; use the inline as
        // |the style parent.
        parent = sibling;
      }
    }
      
    nsIAtom* parentPseudo = parent->StyleContext()->GetPseudo();
    if (!parentPseudo ||
        (!nsCSSAnonBoxes::IsAnonBox(parentPseudo) &&
         // nsPlaceholderFrame pases in nsGkAtoms::placeholderFrame for
         // aChildPseudo (even though that's not a valid pseudo-type) just to
         // trigger this behavior of walking up to the nearest non-pseudo
         // ancestor.
         aChildPseudo != nsGkAtoms::placeholderFrame)) {
      return parent;
    }

    parent = parent->GetParent();
  } while (parent);

  if (aProspectiveParent->StyleContext()->GetPseudo() ==
      nsCSSAnonBoxes::viewportScroll) {
    // aProspectiveParent is the scrollframe for a viewport
    // and the kids are the anonymous scrollbars
    return aProspectiveParent;
  }

  // We can get here if the root element is absolutely positioned.
  // We can't test for this very accurately, but it can only happen
  // when the prospective parent is a canvas frame.
  NS_ASSERTION(aProspectiveParent->GetType() == nsGkAtoms::canvasFrame,
               "Should have found a parent before this");
  return nullptr;
}

nsStyleContext*
nsFrame::DoGetParentStyleContext(nsIFrame** aProviderFrame) const
{
  *aProviderFrame = nullptr;
  nsFrameManager* fm = PresContext()->FrameManager();
  if (MOZ_LIKELY(mContent)) {
    nsIContent* parentContent = mContent->GetFlattenedTreeParent();
    if (MOZ_LIKELY(parentContent)) {
      nsIAtom* pseudo = StyleContext()->GetPseudo();
      if (!pseudo || !mContent->IsElement() ||
          (!nsCSSAnonBoxes::IsAnonBox(pseudo) &&
           // Ensure that we don't return the display:contents style
           // of the parent content for pseudos that have the same content
           // as their primary frame (like -moz-list-bullets do):
           mContent->GetPrimaryFrame() == this) ||
          /* if next is true then it's really a request for the table frame's
             parent context, see nsTable[Outer]Frame::GetParentStyleContext. */
          pseudo == nsCSSAnonBoxes::tableWrapper) {
        nsStyleContext* sc = fm->GetDisplayContentsStyleFor(parentContent);
        if (MOZ_UNLIKELY(sc)) {
          return sc;
        }
      }
    } else {
      if (!StyleContext()->GetPseudo()) {
        // we're a frame for the root.  We have no style context parent.
        return nullptr;
      }
    }
  }

  if (!(mState & NS_FRAME_OUT_OF_FLOW)) {
    /*
     * If this frame is an anonymous block created when an inline with a block
     * inside it got split, then the parent style context is on its preceding
     * inline. We can get to it using GetIBSplitSiblingForAnonymousBlock.
     */
    if (mState & NS_FRAME_PART_OF_IBSPLIT) {
      nsIFrame* ibSplitSibling = GetIBSplitSiblingForAnonymousBlock(this);
      if (ibSplitSibling) {
        return (*aProviderFrame = ibSplitSibling)->StyleContext();
      }
    }

    // If this frame is one of the blocks that split an inline, we must
    // return the "special" inline parent, i.e., the parent that this
    // frame would have if we didn't mangle the frame structure.
    *aProviderFrame = GetCorrectedParent(this);
    return *aProviderFrame ? (*aProviderFrame)->StyleContext() : nullptr;
  }

  // We're an out-of-flow frame.  For out-of-flow frames, we must
  // resolve underneath the placeholder's parent.  The placeholder is
  // reached from the first-in-flow.
  nsIFrame* placeholder = fm->GetPlaceholderFrameFor(FirstInFlow());
  if (!placeholder) {
    NS_NOTREACHED("no placeholder frame for out-of-flow frame");
    *aProviderFrame = GetCorrectedParent(this);
    return *aProviderFrame ? (*aProviderFrame)->StyleContext() : nullptr;
  }
  return placeholder->GetParentStyleContext(aProviderFrame);
}

void
nsFrame::GetLastLeaf(nsPresContext* aPresContext, nsIFrame **aFrame)
{
  if (!aFrame || !*aFrame)
    return;
  nsIFrame *child = *aFrame;
  //if we are a block frame then go for the last line of 'this'
  while (1){
    child = child->PrincipalChildList().FirstChild();
    if (!child)
      return;//nothing to do
    nsIFrame* siblingFrame;
    nsIContent* content;
    //ignore anonymous elements, e.g. mozTableAdd* mozTableRemove*
    //see bug 278197 comment #12 #13 for details
    while ((siblingFrame = child->GetNextSibling()) &&
           (content = siblingFrame->GetContent()) &&
           !content->IsRootOfNativeAnonymousSubtree())
      child = siblingFrame;
    *aFrame = child;
  }
}

void
nsFrame::GetFirstLeaf(nsPresContext* aPresContext, nsIFrame **aFrame)
{
  if (!aFrame || !*aFrame)
    return;
  nsIFrame *child = *aFrame;
  while (1){
    child = child->PrincipalChildList().FirstChild();
    if (!child)
      return;//nothing to do
    *aFrame = child;
  }
}

/* virtual */ bool
nsIFrame::IsFocusable(int32_t *aTabIndex, bool aWithMouse)
{
  int32_t tabIndex = -1;
  if (aTabIndex) {
    *aTabIndex = -1; // Default for early return is not focusable
  }
  bool isFocusable = false;

  if (mContent && mContent->IsElement() && IsVisibleConsideringAncestors() &&
      StyleContext()->GetPseudo() != nsCSSAnonBoxes::anonymousFlexItem &&
      StyleContext()->GetPseudo() != nsCSSAnonBoxes::anonymousGridItem) {
    const nsStyleUserInterface* ui = StyleUserInterface();
    if (ui->mUserFocus != StyleUserFocus::Ignore &&
        ui->mUserFocus != StyleUserFocus::None) {
      // Pass in default tabindex of -1 for nonfocusable and 0 for focusable
      tabIndex = 0;
    }
    isFocusable = mContent->IsFocusable(&tabIndex, aWithMouse);
    if (!isFocusable && !aWithMouse &&
        GetType() == nsGkAtoms::scrollFrame &&
        mContent->IsHTMLElement() &&
        !mContent->IsRootOfNativeAnonymousSubtree() &&
        mContent->GetParent() &&
        !mContent->HasAttr(kNameSpaceID_None, nsGkAtoms::tabindex)) {
      // Elements with scrollable view are focusable with script & tabbable
      // Otherwise you couldn't scroll them with keyboard, which is
      // an accessibility issue (e.g. Section 508 rules)
      // However, we don't make them to be focusable with the mouse,
      // because the extra focus outlines are considered unnecessarily ugly.
      // When clicked on, the selection position within the element 
      // will be enough to make them keyboard scrollable.
      nsIScrollableFrame *scrollFrame = do_QueryFrame(this);
      if (scrollFrame &&
          !scrollFrame->GetScrollbarStyles().IsHiddenInBothDirections() &&
          !scrollFrame->GetScrollRange().IsEqualEdges(nsRect(0, 0, 0, 0))) {
        // Scroll bars will be used for overflow
        isFocusable = true;
        tabIndex = 0;
      }
    }
  }

  if (aTabIndex) {
    *aTabIndex = tabIndex;
  }
  return isFocusable;
}

/**
 * @return true if this text frame ends with a newline character which is
 * treated as preformatted. It should return false if this is not a text frame.
 */
bool
nsIFrame::HasSignificantTerminalNewline() const
{
  return false;
}

static uint8_t
ConvertSVGDominantBaselineToVerticalAlign(uint8_t aDominantBaseline)
{
  // Most of these are approximate mappings.
  switch (aDominantBaseline) {
  case NS_STYLE_DOMINANT_BASELINE_HANGING:
  case NS_STYLE_DOMINANT_BASELINE_TEXT_BEFORE_EDGE:
    return NS_STYLE_VERTICAL_ALIGN_TEXT_TOP;
  case NS_STYLE_DOMINANT_BASELINE_TEXT_AFTER_EDGE:
  case NS_STYLE_DOMINANT_BASELINE_IDEOGRAPHIC:
    return NS_STYLE_VERTICAL_ALIGN_TEXT_BOTTOM;
  case NS_STYLE_DOMINANT_BASELINE_CENTRAL:
  case NS_STYLE_DOMINANT_BASELINE_MIDDLE:
  case NS_STYLE_DOMINANT_BASELINE_MATHEMATICAL:
    return NS_STYLE_VERTICAL_ALIGN_MIDDLE;
  case NS_STYLE_DOMINANT_BASELINE_AUTO:
  case NS_STYLE_DOMINANT_BASELINE_ALPHABETIC:
    return NS_STYLE_VERTICAL_ALIGN_BASELINE;
  case NS_STYLE_DOMINANT_BASELINE_USE_SCRIPT:
  case NS_STYLE_DOMINANT_BASELINE_NO_CHANGE:
  case NS_STYLE_DOMINANT_BASELINE_RESET_SIZE:
    // These three should not simply map to 'baseline', but we don't
    // support the complex baseline model that SVG 1.1 has and which
    // css3-linebox now defines.
    return NS_STYLE_VERTICAL_ALIGN_BASELINE;
  default:
    NS_NOTREACHED("unexpected aDominantBaseline value");
    return NS_STYLE_VERTICAL_ALIGN_BASELINE;
  }
}

uint8_t
nsIFrame::VerticalAlignEnum() const
{
  if (IsSVGText()) {
    uint8_t dominantBaseline;
    for (const nsIFrame* frame = this; frame; frame = frame->GetParent()) {
      dominantBaseline = frame->StyleSVGReset()->mDominantBaseline;
      if (dominantBaseline != NS_STYLE_DOMINANT_BASELINE_AUTO ||
          frame->GetType() == nsGkAtoms::svgTextFrame) {
        break;
      }
    }
    return ConvertSVGDominantBaselineToVerticalAlign(dominantBaseline);
  }

  const nsStyleCoord& verticalAlign = StyleDisplay()->mVerticalAlign;
  if (verticalAlign.GetUnit() == eStyleUnit_Enumerated) {
    return verticalAlign.GetIntValue();
  }

  return eInvalidVerticalAlign;
}

/* static */
void nsFrame::FillCursorInformationFromStyle(const nsStyleUserInterface* ui,
                                             nsIFrame::Cursor& aCursor)
{
  aCursor.mCursor = ui->mCursor;
  aCursor.mHaveHotspot = false;
  aCursor.mLoading = false;
  aCursor.mHotspotX = aCursor.mHotspotY = 0.0f;

  for (const nsCursorImage& item : ui->mCursorImages) {
    uint32_t status;
    nsresult rv = item.GetImage()->GetImageStatus(&status);
    if (NS_SUCCEEDED(rv)) {
      if (!(status & imgIRequest::STATUS_LOAD_COMPLETE)) {
        // If we are falling back because any cursor before is loading,
        // let the consumer know.
        aCursor.mLoading = true;
      } else if (!(status & imgIRequest::STATUS_ERROR)) {
        // This is the one we want
        item.GetImage()->GetImage(getter_AddRefs(aCursor.mContainer));
        aCursor.mHaveHotspot = item.mHaveHotspot;
        aCursor.mHotspotX = item.mHotspotX;
        aCursor.mHotspotY = item.mHotspotY;
        break;
      }
    }
  }
}

NS_IMETHODIMP
nsFrame::RefreshSizeCache(nsBoxLayoutState& aState)
{
  // XXXbz this comment needs some rewriting to make sense in the
  // post-reflow-branch world.
  
  // Ok we need to compute our minimum, preferred, and maximum sizes.
  // 1) Maximum size. This is easy. Its infinite unless it is overloaded by CSS.
  // 2) Preferred size. This is a little harder. This is the size the block would be 
  //      if it were laid out on an infinite canvas. So we can get this by reflowing
  //      the block with and INTRINSIC width and height. We can also do a nice optimization
  //      for incremental reflow. If the reflow is incremental then we can pass a flag to 
  //      have the block compute the preferred width for us! Preferred height can just be
  //      the minimum height;
  // 3) Minimum size. This is a toughy. We can pass the block a flag asking for the max element
  //    size. That would give us the width. Unfortunately you can only ask for a maxElementSize
  //    during an incremental reflow. So on other reflows we will just have to use 0.
  //    The min height on the other hand is fairly easy we need to get the largest
  //    line height. This can be done with the line iterator.

  // if we do have a rendering context
  nsRenderingContext* rendContext = aState.GetRenderingContext();
  if (rendContext) {
    nsPresContext* presContext = aState.PresContext();

    // If we don't have any HTML constraints and it's a resize, then nothing in the block
    // could have changed, so no refresh is necessary.
    nsBoxLayoutMetrics* metrics = BoxMetrics();
    if (!DoesNeedRecalc(metrics->mBlockPrefSize))
      return NS_OK;

    // the rect we plan to size to.
    nsRect rect = GetRect();

    nsMargin bp(0,0,0,0);
    GetXULBorderAndPadding(bp);

    {
      // If we're a container for font size inflation, then shrink
      // wrapping inside of us should not apply font size inflation.
      AutoMaybeDisableFontInflation an(this);

      metrics->mBlockPrefSize.width =
        GetPrefISize(rendContext) + bp.LeftRight();
      metrics->mBlockMinSize.width =
        GetMinISize(rendContext) + bp.LeftRight();
    }

    // do the nasty.
    const WritingMode wm = aState.OuterReflowInput() ?
      aState.OuterReflowInput()->GetWritingMode() : GetWritingMode();
    ReflowOutput desiredSize(wm);
    BoxReflow(aState, presContext, desiredSize, rendContext,
              rect.x, rect.y,
              metrics->mBlockPrefSize.width, NS_UNCONSTRAINEDSIZE);

    metrics->mBlockMinSize.height = 0;
    // ok we need the max ascent of the items on the line. So to do this
    // ask the block for its line iterator. Get the max ascent.
    nsAutoLineIterator lines = GetLineIterator();
    if (lines) 
    {
      metrics->mBlockMinSize.height = 0;
      int count = 0;
      nsIFrame* firstFrame = nullptr;
      int32_t framesOnLine;
      nsRect lineBounds;

      do {
         lines->GetLine(count, &firstFrame, &framesOnLine, lineBounds);

         if (lineBounds.height > metrics->mBlockMinSize.height)
           metrics->mBlockMinSize.height = lineBounds.height;

         count++;
      } while(firstFrame);
    } else {
      metrics->mBlockMinSize.height = desiredSize.Height();
    }

    metrics->mBlockPrefSize.height = metrics->mBlockMinSize.height;

    if (desiredSize.BlockStartAscent() ==
        ReflowOutput::ASK_FOR_BASELINE) {
      if (!nsLayoutUtils::GetFirstLineBaseline(wm, this,
                                               &metrics->mBlockAscent))
        metrics->mBlockAscent = GetLogicalBaseline(wm);
    } else {
      metrics->mBlockAscent = desiredSize.BlockStartAscent();
    }

#ifdef DEBUG_adaptor
    printf("min=(%d,%d), pref=(%d,%d), ascent=%d\n", metrics->mBlockMinSize.width,
                                                     metrics->mBlockMinSize.height,
                                                     metrics->mBlockPrefSize.width,
                                                     metrics->mBlockPrefSize.height,
                                                     metrics->mBlockAscent);
#endif
  }

  return NS_OK;
}

/* virtual */ nsILineIterator*
nsFrame::GetLineIterator()
{
  return nullptr;
}

nsSize
nsFrame::GetXULPrefSize(nsBoxLayoutState& aState)
{
  nsSize size(0,0);
  DISPLAY_PREF_SIZE(this, size);
  // If the size is cached, and there are no HTML constraints that we might
  // be depending on, then we just return the cached size.
  nsBoxLayoutMetrics *metrics = BoxMetrics();
  if (!DoesNeedRecalc(metrics->mPrefSize)) {
    return metrics->mPrefSize;
  }

  if (IsXULCollapsed())
    return size;

  // get our size in CSS.
  bool widthSet, heightSet;
  bool completelyRedefined = nsIFrame::AddXULPrefSize(this, size, widthSet, heightSet);

  // Refresh our caches with new sizes.
  if (!completelyRedefined) {
    RefreshSizeCache(aState);
    nsSize blockSize = metrics->mBlockPrefSize;

    // notice we don't need to add our borders or padding
    // in. That's because the block did it for us.
    if (!widthSet)
      size.width = blockSize.width;
    if (!heightSet)
      size.height = blockSize.height;
  }

  metrics->mPrefSize = size;
  return size;
}

nsSize
nsFrame::GetXULMinSize(nsBoxLayoutState& aState)
{
  nsSize size(0,0);
  DISPLAY_MIN_SIZE(this, size);
  // Don't use the cache if we have HTMLReflowInput constraints --- they might have changed
  nsBoxLayoutMetrics *metrics = BoxMetrics();
  if (!DoesNeedRecalc(metrics->mMinSize)) {
    size = metrics->mMinSize;
    return size;
  }

  if (IsXULCollapsed())
    return size;

  // get our size in CSS.
  bool widthSet, heightSet;
  bool completelyRedefined =
    nsIFrame::AddXULMinSize(aState, this, size, widthSet, heightSet);

  // Refresh our caches with new sizes.
  if (!completelyRedefined) {
    RefreshSizeCache(aState);
    nsSize blockSize = metrics->mBlockMinSize;

    if (!widthSet)
      size.width = blockSize.width;
    if (!heightSet)
      size.height = blockSize.height;
  }

  metrics->mMinSize = size;
  return size;
}

nsSize
nsFrame::GetXULMaxSize(nsBoxLayoutState& aState)
{
  nsSize size(NS_INTRINSICSIZE, NS_INTRINSICSIZE);
  DISPLAY_MAX_SIZE(this, size);
  // Don't use the cache if we have HTMLReflowInput constraints --- they might have changed
  nsBoxLayoutMetrics *metrics = BoxMetrics();
  if (!DoesNeedRecalc(metrics->mMaxSize)) {
    size = metrics->mMaxSize;
    return size;
  }

  if (IsXULCollapsed())
    return size;

  size = nsBox::GetXULMaxSize(aState);
  metrics->mMaxSize = size;

  return size;
}

nscoord
nsFrame::GetXULFlex()
{
  nsBoxLayoutMetrics *metrics = BoxMetrics();
  if (!DoesNeedRecalc(metrics->mFlex))
     return metrics->mFlex;

  metrics->mFlex = nsBox::GetXULFlex();

  return metrics->mFlex;
}

nscoord
nsFrame::GetXULBoxAscent(nsBoxLayoutState& aState)
{
  nsBoxLayoutMetrics *metrics = BoxMetrics();
  if (!DoesNeedRecalc(metrics->mAscent))
    return metrics->mAscent;

  if (IsXULCollapsed()) {
    metrics->mAscent = 0;
  } else {
    // Refresh our caches with new sizes.
    RefreshSizeCache(aState);
    metrics->mAscent = metrics->mBlockAscent;
  }

  return metrics->mAscent;
}

nsresult
nsFrame::DoXULLayout(nsBoxLayoutState& aState)
{
  nsRect ourRect(mRect);

  nsRenderingContext* rendContext = aState.GetRenderingContext();
  nsPresContext* presContext = aState.PresContext();
  WritingMode ourWM = GetWritingMode();
  const WritingMode outerWM = aState.OuterReflowInput() ?
    aState.OuterReflowInput()->GetWritingMode() : ourWM;
  ReflowOutput desiredSize(outerWM);
  LogicalSize ourSize = GetLogicalSize(outerWM);

  if (rendContext) {

    BoxReflow(aState, presContext, desiredSize, rendContext,
              ourRect.x, ourRect.y, ourRect.width, ourRect.height);

    if (IsXULCollapsed()) {
      SetSize(nsSize(0, 0));
    } else {

      // if our child needs to be bigger. This might happend with
      // wrapping text. There is no way to predict its height until we
      // reflow it. Now that we know the height reshuffle upward.
      if (desiredSize.ISize(outerWM) > ourSize.ISize(outerWM) ||
          desiredSize.BSize(outerWM) > ourSize.BSize(outerWM)) {

#ifdef DEBUG_GROW
        XULDumpBox(stdout);
        printf(" GREW from (%d,%d) -> (%d,%d)\n",
               ourSize.ISize(outerWM), ourSize.BSize(outerWM),
               desiredSize.ISize(outerWM), desiredSize.BSize(outerWM));
#endif

        if (desiredSize.ISize(outerWM) > ourSize.ISize(outerWM)) {
          ourSize.ISize(outerWM) = desiredSize.ISize(outerWM);
        }

        if (desiredSize.BSize(outerWM) > ourSize.BSize(outerWM)) {
          ourSize.BSize(outerWM) = desiredSize.BSize(outerWM);
        }
      }

      // ensure our size is what we think is should be. Someone could have
      // reset the frame to be smaller or something dumb like that. 
      SetSize(ourSize.ConvertTo(ourWM, outerWM));
    }
  }

  // Should we do this if IsXULCollapsed() is true?
  LogicalSize size(GetLogicalSize(outerWM));
  desiredSize.ISize(outerWM) = size.ISize(outerWM);
  desiredSize.BSize(outerWM) = size.BSize(outerWM);
  desiredSize.UnionOverflowAreasWithDesiredBounds();

  if (HasAbsolutelyPositionedChildren()) {
    // Set up a |reflowInput| to pass into ReflowAbsoluteFrames
    ReflowInput reflowInput(aState.PresContext(), this,
                                  aState.GetRenderingContext(),
                                  LogicalSize(ourWM, ISize(),
                                              NS_UNCONSTRAINEDSIZE),
                                  ReflowInput::DUMMY_PARENT_REFLOW_STATE);

    AddStateBits(NS_FRAME_IN_REFLOW);
    // Set up a |reflowStatus| to pass into ReflowAbsoluteFrames
    // (just a dummy value; hopefully that's OK)
    nsReflowStatus reflowStatus = NS_FRAME_COMPLETE;
    ReflowAbsoluteFrames(aState.PresContext(), desiredSize,
                         reflowInput, reflowStatus);
    RemoveStateBits(NS_FRAME_IN_REFLOW);
  }

  nsSize oldSize(ourRect.Size());
  FinishAndStoreOverflow(desiredSize.mOverflowAreas,
                         size.GetPhysicalSize(outerWM), &oldSize);

  SyncLayout(aState);

  return NS_OK;
}

void
nsFrame::BoxReflow(nsBoxLayoutState&        aState,
                   nsPresContext*           aPresContext,
                   ReflowOutput&     aDesiredSize,
                   nsRenderingContext*     aRenderingContext,
                   nscoord                  aX,
                   nscoord                  aY,
                   nscoord                  aWidth,
                   nscoord                  aHeight,
                   bool                     aMoveFrame)
{
  DO_GLOBAL_REFLOW_COUNT("nsBoxToBlockAdaptor");

#ifdef DEBUG_REFLOW
  nsAdaptorAddIndents();
  printf("Reflowing: ");
  nsFrame::ListTag(stdout, mFrame);
  printf("\n");
  gIndent2++;
#endif

  nsBoxLayoutMetrics *metrics = BoxMetrics();
  nsReflowStatus status = NS_FRAME_COMPLETE;
  WritingMode wm = aDesiredSize.GetWritingMode();

  bool needsReflow = NS_SUBTREE_DIRTY(this);

  // if we don't need a reflow then 
  // lets see if we are already that size. Yes? then don't even reflow. We are done.
  if (!needsReflow) {
      
      if (aWidth != NS_INTRINSICSIZE && aHeight != NS_INTRINSICSIZE) {
      
          // if the new calculated size has a 0 width or a 0 height
          if ((metrics->mLastSize.width == 0 || metrics->mLastSize.height == 0) && (aWidth == 0 || aHeight == 0)) {
               needsReflow = false;
               aDesiredSize.Width() = aWidth; 
               aDesiredSize.Height() = aHeight; 
               SetSize(aDesiredSize.Size(wm).ConvertTo(GetWritingMode(), wm));
          } else {
            aDesiredSize.Width() = metrics->mLastSize.width;
            aDesiredSize.Height() = metrics->mLastSize.height;

            // remove the margin. The rect of our child does not include it but our calculated size does.
            // don't reflow if we are already the right size
            if (metrics->mLastSize.width == aWidth && metrics->mLastSize.height == aHeight)
                  needsReflow = false;
            else
                  needsReflow = true;
   
          }
      } else {
          // if the width or height are intrinsic alway reflow because
          // we don't know what it should be.
         needsReflow = true;
      }
  }

  // ok now reflow the child into the spacers calculated space
  if (needsReflow) {

    aDesiredSize.ClearSize();

    // create a reflow state to tell our child to flow at the given size.

    // Construct a bogus parent reflow state so that there's a usable
    // containing block reflow state.
    nsMargin margin(0,0,0,0);
    GetXULMargin(margin);

    nsSize parentSize(aWidth, aHeight);
    if (parentSize.height != NS_INTRINSICSIZE)
      parentSize.height += margin.TopBottom();
    if (parentSize.width != NS_INTRINSICSIZE)
      parentSize.width += margin.LeftRight();

    nsIFrame *parentFrame = GetParent();
    nsFrameState savedState = parentFrame->GetStateBits();
    WritingMode parentWM = parentFrame->GetWritingMode();
    ReflowInput
      parentReflowInput(aPresContext, parentFrame, aRenderingContext,
                        LogicalSize(parentWM, parentSize),
                        ReflowInput::DUMMY_PARENT_REFLOW_STATE);
    parentFrame->RemoveStateBits(~nsFrameState(0));
    parentFrame->AddStateBits(savedState);

    // This may not do very much useful, but it's probably worth trying.
    if (parentSize.width != NS_INTRINSICSIZE)
      parentReflowInput.SetComputedWidth(std::max(parentSize.width, 0));
    if (parentSize.height != NS_INTRINSICSIZE)
      parentReflowInput.SetComputedHeight(std::max(parentSize.height, 0));
    parentReflowInput.ComputedPhysicalMargin().SizeTo(0, 0, 0, 0);
    // XXX use box methods
    parentFrame->GetXULPadding(parentReflowInput.ComputedPhysicalPadding());
    parentFrame->GetXULBorder(parentReflowInput.ComputedPhysicalBorderPadding());
    parentReflowInput.ComputedPhysicalBorderPadding() +=
      parentReflowInput.ComputedPhysicalPadding();

    // Construct the parent chain manually since constructing it normally
    // messes up dimensions.
    const ReflowInput *outerReflowInput = aState.OuterReflowInput();
    NS_ASSERTION(!outerReflowInput || outerReflowInput->mFrame != this,
                 "in and out of XUL on a single frame?");
    const ReflowInput* parentRI;
    if (outerReflowInput && outerReflowInput->mFrame == parentFrame) {
      // We're a frame (such as a text control frame) that jumps into
      // box reflow and then straight out of it on the child frame.
      // This means we actually have a real parent reflow state.
      // nsLayoutUtils::InflationMinFontSizeFor used to need this to be
      // linked up correctly for text control frames, so do so here).
      parentRI = outerReflowInput;
    } else {
      parentRI = &parentReflowInput;
    }

    // XXX Is it OK that this reflow state has only one ancestor?
    // (It used to have a bogus parent, skipping all the boxes).
    WritingMode wm = GetWritingMode();
    LogicalSize logicalSize(wm, nsSize(aWidth, aHeight));
    logicalSize.BSize(wm) = NS_INTRINSICSIZE;
    ReflowInput reflowInput(aPresContext, *parentRI, this,
                                  logicalSize, nullptr,
                                  ReflowInput::DUMMY_PARENT_REFLOW_STATE);

    // XXX_jwir3: This is somewhat fishy. If this is actually changing the value
    //            here (which it might be), then we should make sure that it's
    //            correct the first time around, rather than changing it later.
    reflowInput.mCBReflowInput = parentRI;

    reflowInput.mReflowDepth = aState.GetReflowDepth();

    // mComputedWidth and mComputedHeight are content-box, not
    // border-box
    if (aWidth != NS_INTRINSICSIZE) {
      nscoord computedWidth =
        aWidth - reflowInput.ComputedPhysicalBorderPadding().LeftRight();
      computedWidth = std::max(computedWidth, 0);
      reflowInput.SetComputedWidth(computedWidth);
    }

    // Most child frames of box frames (e.g. subdocument or scroll frames)
    // need to be constrained to the provided size and overflow as necessary.
    // The one exception are block frames, because we need to know their
    // natural height excluding any overflow area which may be caused by
    // various CSS effects such as shadow or outline.
    if (!IsFrameOfType(eBlockFrame)) {
      if (aHeight != NS_INTRINSICSIZE) {
        nscoord computedHeight =
          aHeight - reflowInput.ComputedPhysicalBorderPadding().TopBottom();
        computedHeight = std::max(computedHeight, 0);
        reflowInput.SetComputedHeight(computedHeight);
      } else {
        reflowInput.SetComputedHeight(
          ComputeSize(aRenderingContext, wm,
                      logicalSize,
                      logicalSize.ISize(wm),
                      reflowInput.ComputedLogicalMargin().Size(wm),
                      reflowInput.ComputedLogicalBorderPadding().Size(wm) -
                        reflowInput.ComputedLogicalPadding().Size(wm),
                      reflowInput.ComputedLogicalPadding().Size(wm),
                      ComputeSizeFlags::eDefault).Height(wm));
      }
    }

    // Box layout calls SetRect before XULLayout, whereas non-box layout
    // calls SetRect after Reflow.
    // XXX Perhaps we should be doing this by twiddling the rect back to
    // mLastSize before calling Reflow and then switching it back, but
    // However, mLastSize can also be the size passed to BoxReflow by
    // RefreshSizeCache, so that doesn't really make sense.
    if (metrics->mLastSize.width != aWidth) {
      reflowInput.SetHResize(true);

      // When font size inflation is enabled, a horizontal resize
      // requires a full reflow.  See ReflowInput::InitResizeFlags
      // for more details.
      if (nsLayoutUtils::FontSizeInflationEnabled(aPresContext)) {
        AddStateBits(NS_FRAME_IS_DIRTY);
      }
    }
    if (metrics->mLastSize.height != aHeight) {
      reflowInput.SetVResize(true);
    }

    #ifdef DEBUG_REFLOW
      nsAdaptorAddIndents();
      printf("Size=(%d,%d)\n",reflowInput.ComputedWidth(),
             reflowInput.ComputedHeight());
      nsAdaptorAddIndents();
      nsAdaptorPrintReason(reflowInput);
      printf("\n");
    #endif

       // place the child and reflow

    Reflow(aPresContext, aDesiredSize, reflowInput, status);

    NS_ASSERTION(NS_FRAME_IS_COMPLETE(status), "bad status");

    uint32_t layoutFlags = aState.LayoutFlags();
    nsContainerFrame::FinishReflowChild(this, aPresContext, aDesiredSize,
                                        &reflowInput, aX, aY, layoutFlags | NS_FRAME_NO_MOVE_FRAME);

    // Save the ascent.  (bug 103925)
    if (IsXULCollapsed()) {
      metrics->mAscent = 0;
    } else {
      if (aDesiredSize.BlockStartAscent() ==
          ReflowOutput::ASK_FOR_BASELINE) {
        if (!nsLayoutUtils::GetFirstLineBaseline(wm, this, &metrics->mAscent))
          metrics->mAscent = GetLogicalBaseline(wm);
      } else
        metrics->mAscent = aDesiredSize.BlockStartAscent();
    }

  } else {
    aDesiredSize.SetBlockStartAscent(metrics->mBlockAscent);
  }

#ifdef DEBUG_REFLOW
  if (aHeight != NS_INTRINSICSIZE && aDesiredSize.Height() != aHeight)
  {
          nsAdaptorAddIndents();
          printf("*****got taller!*****\n");
         
  }
  if (aWidth != NS_INTRINSICSIZE && aDesiredSize.Width() != aWidth)
  {
          nsAdaptorAddIndents();
          printf("*****got wider!******\n");
         
  }
#endif

  if (aWidth == NS_INTRINSICSIZE)
     aWidth = aDesiredSize.Width();

  if (aHeight == NS_INTRINSICSIZE)
     aHeight = aDesiredSize.Height();

  metrics->mLastSize.width = aDesiredSize.Width();
  metrics->mLastSize.height = aDesiredSize.Height();

#ifdef DEBUG_REFLOW
  gIndent2--;
#endif
}

nsBoxLayoutMetrics*
nsFrame::BoxMetrics() const
{
  nsBoxLayoutMetrics* metrics = Properties().Get(BoxMetricsProperty());
  NS_ASSERTION(metrics, "A box layout method was called but InitBoxMetrics was never called");
  return metrics;
}

/* static */ void
nsIFrame::AddInPopupStateBitToDescendants(nsIFrame* aFrame)
{
  if (!aFrame->HasAnyStateBits(NS_FRAME_IN_POPUP) &&
      aFrame->TrackingVisibility()) {
    // Assume all frames in popups are visible.
    aFrame->IncApproximateVisibleCount();
  }

  aFrame->AddStateBits(NS_FRAME_IN_POPUP);

  AutoTArray<nsIFrame::ChildList,4> childListArray;
  aFrame->GetCrossDocChildLists(&childListArray);

  nsIFrame::ChildListArrayIterator lists(childListArray);
  for (; !lists.IsDone(); lists.Next()) {
    nsFrameList::Enumerator childFrames(lists.CurrentList());
    for (; !childFrames.AtEnd(); childFrames.Next()) {
      AddInPopupStateBitToDescendants(childFrames.get());
    }
  }
}

/* static */ void
nsIFrame::RemoveInPopupStateBitFromDescendants(nsIFrame* aFrame)
{
  if (!aFrame->HasAnyStateBits(NS_FRAME_IN_POPUP) ||
      nsLayoutUtils::IsPopup(aFrame)) {
    return;
  }

  aFrame->RemoveStateBits(NS_FRAME_IN_POPUP);

  if (aFrame->TrackingVisibility()) {
    // We assume all frames in popups are visible, so this decrement balances
    // out the increment in AddInPopupStateBitToDescendants above.
    aFrame->DecApproximateVisibleCount();
  }

  AutoTArray<nsIFrame::ChildList,4> childListArray;
  aFrame->GetCrossDocChildLists(&childListArray);

  nsIFrame::ChildListArrayIterator lists(childListArray);
  for (; !lists.IsDone(); lists.Next()) {
    nsFrameList::Enumerator childFrames(lists.CurrentList());
    for (; !childFrames.AtEnd(); childFrames.Next()) {
      RemoveInPopupStateBitFromDescendants(childFrames.get());
    }
  }
}

void
nsIFrame::SetParent(nsContainerFrame* aParent)
{
  // Note that the current mParent may already be destroyed at this point.
  mParent = aParent;
  if (::IsXULBoxWrapped(this)) {
    ::InitBoxMetrics(this, true);
  } else {
    // We could call Properties().Delete(BoxMetricsProperty()); here but
    // that's kind of slow and re-parenting in such a way that we were
    // IsXULBoxWrapped() before but not now should be very rare, so we'll just
    // keep this unused frame property until this frame dies instead.
  }

  if (GetStateBits() & (NS_FRAME_HAS_VIEW | NS_FRAME_HAS_CHILD_WITH_VIEW)) {
    for (nsIFrame* f = aParent;
         f && !(f->GetStateBits() & NS_FRAME_HAS_CHILD_WITH_VIEW);
         f = f->GetParent()) {
      f->AddStateBits(NS_FRAME_HAS_CHILD_WITH_VIEW);
    }
  }

  if (HasAnyStateBits(NS_FRAME_CONTAINS_RELATIVE_BSIZE)) {
    for (nsIFrame* f = aParent; f; f = f->GetParent()) {
      if (f->HasAnyStateBits(NS_FRAME_CONTAINS_RELATIVE_BSIZE)) {
        break;
      }
      f->AddStateBits(NS_FRAME_CONTAINS_RELATIVE_BSIZE);
    }
  }

  if (HasAnyStateBits(NS_FRAME_DESCENDANT_INTRINSIC_ISIZE_DEPENDS_ON_BSIZE)) {
    for (nsIFrame* f = aParent; f; f = f->GetParent()) {
      if (f->HasAnyStateBits(NS_FRAME_DESCENDANT_INTRINSIC_ISIZE_DEPENDS_ON_BSIZE)) {
        break;
      }
      f->AddStateBits(NS_FRAME_DESCENDANT_INTRINSIC_ISIZE_DEPENDS_ON_BSIZE);
    }
  }

  if (HasInvalidFrameInSubtree()) {
    for (nsIFrame* f = aParent;
         f && !f->HasAnyStateBits(NS_FRAME_DESCENDANT_NEEDS_PAINT | NS_FRAME_IS_NONDISPLAY);
         f = nsLayoutUtils::GetCrossDocParentFrame(f)) {
      f->AddStateBits(NS_FRAME_DESCENDANT_NEEDS_PAINT);
    }
  }

  if (aParent->HasAnyStateBits(NS_FRAME_IN_POPUP)) {
    AddInPopupStateBitToDescendants(this);
  } else {
    RemoveInPopupStateBitFromDescendants(this);
  }
  
  // If our new parent only has invalid children, then we just invalidate
  // ourselves too. This is probably faster than clearing the flag all
  // the way up the frame tree.
  if (aParent->HasAnyStateBits(NS_FRAME_ALL_DESCENDANTS_NEED_PAINT)) {
    InvalidateFrame();
  }
}

void
nsIFrame::CreateOwnLayerIfNeeded(nsDisplayListBuilder* aBuilder, 
                                 nsDisplayList* aList)
{
  if (GetContent() &&
      GetContent()->IsXULElement() &&
      GetContent()->HasAttr(kNameSpaceID_None, nsGkAtoms::layer)) {
    aList->AppendNewToTop(new (aBuilder) 
        nsDisplayOwnLayer(aBuilder, this, aList));
  }
}

bool
nsIFrame::IsSelected() const
{
  return (GetContent() && GetContent()->IsSelectionDescendant()) ?
    IsFrameSelected() : false;
}

/*static*/ void
nsIFrame::DestroyContentArray(ContentArray* aArray)
{
  for (nsIContent* content : *aArray) {
    content->UnbindFromTree();
    NS_RELEASE(content);
  }
  delete aArray;
}

bool
nsIFrame::IsPseudoStackingContextFromStyle() {
  // If you change this, also change the computation of pseudoStackingContext
  // in BuildDisplayListForChild()
  if (StyleEffects()->mOpacity != 1.0f) {
    return true;
  }
  const nsStyleDisplay* disp = StyleDisplay();
  return disp->IsAbsPosContainingBlock(this) ||
         disp->IsFloating(this) ||
         (disp->mWillChangeBitField & NS_STYLE_WILL_CHANGE_STACKING_CONTEXT);
}

Element*
nsIFrame::GetPseudoElement(CSSPseudoElementType aType)
{
  nsIFrame* frame = nullptr;

  if (aType == CSSPseudoElementType::before) {
    frame = nsLayoutUtils::GetBeforeFrame(this);
  } else if (aType == CSSPseudoElementType::after) {
    frame = nsLayoutUtils::GetAfterFrame(this);
  }

  if (frame) {
    nsIContent* content = frame->GetContent();
    if (content->IsElement()) {
      return content->AsElement();
    }
  }

  return nullptr;
}

static bool
IsFrameScrolledOutOfView(nsIFrame *aFrame)
{
  nsIScrollableFrame* scrollableFrame =
    nsLayoutUtils::GetNearestScrollableFrame(aFrame,
      nsLayoutUtils::SCROLLABLE_SAME_DOC |
      nsLayoutUtils::SCROLLABLE_INCLUDE_HIDDEN);
  if (!scrollableFrame) {
    return false;
  }

  nsIFrame *scrollableParent = do_QueryFrame(scrollableFrame);
  nsRect rect = aFrame->GetVisualOverflowRect();

  nsRect transformedRect =
    nsLayoutUtils::TransformFrameRectToAncestor(aFrame,
                                                rect,
                                                scrollableParent);

  nsRect scrollableRect = scrollableParent->GetVisualOverflowRect();
  if (!transformedRect.Intersects(scrollableRect)) {
    return true;
  }

  nsIFrame* parent = scrollableParent->GetParent();
  if (!parent) {
    return false;
  }

  return IsFrameScrolledOutOfView(parent);
}

bool
nsIFrame::IsScrolledOutOfView()
{
  return IsFrameScrolledOutOfView(this);
}

nsIFrame::CaretPosition::CaretPosition()
  : mContentOffset(0)
{
}

nsIFrame::CaretPosition::~CaretPosition()
{
}

bool
nsFrame::HasCSSAnimations()
{
  auto collection =
    AnimationCollection<CSSAnimation>::GetAnimationCollection(this);
  return collection && collection->mAnimations.Length() > 0;
}

bool
nsFrame::HasCSSTransitions()
{
  auto collection =
    AnimationCollection<CSSTransition>::GetAnimationCollection(this);
  return collection && collection->mAnimations.Length() > 0;
}

// Box layout debugging
#ifdef DEBUG_REFLOW
int32_t gIndent2 = 0;

void
nsAdaptorAddIndents()
{
    for(int32_t i=0; i < gIndent2; i++)
    {
        printf(" ");
    }
}

void
nsAdaptorPrintReason(ReflowInput& aReflowInput)
{
    char* reflowReasonString;

    switch(aReflowInput.reason) 
    {
        case eReflowReason_Initial:
          reflowReasonString = "initial";
          break;

        case eReflowReason_Resize:
          reflowReasonString = "resize";
          break;
        case eReflowReason_Dirty:
          reflowReasonString = "dirty";
          break;
        case eReflowReason_StyleChange:
          reflowReasonString = "stylechange";
          break;
        case eReflowReason_Incremental: 
        {
            switch (aReflowInput.reflowCommand->Type()) {
              case eReflowType_StyleChanged:
                 reflowReasonString = "incremental (StyleChanged)";
              break;
              case eReflowType_ReflowDirty:
                 reflowReasonString = "incremental (ReflowDirty)";
              break;
              default:
                 reflowReasonString = "incremental (Unknown)";
            }
        }                             
        break;
        default:
          reflowReasonString = "unknown";
          break;
    }

    printf("%s",reflowReasonString);
}

#endif
#ifdef DEBUG_LAYOUT
void
nsFrame::GetBoxName(nsAutoString& aName)
{
  GetFrameName(aName);
}
#endif

#ifdef DEBUG
static void
GetTagName(nsFrame* aFrame, nsIContent* aContent, int aResultSize,
           char* aResult)
{
  if (aContent) {
    snprintf(aResult, aResultSize, "%s@%p",
             nsAtomCString(aContent->NodeInfo()->NameAtom()).get(), aFrame);
  }
  else {
    snprintf(aResult, aResultSize, "@%p", aFrame);
  }
}

void
nsFrame::Trace(const char* aMethod, bool aEnter)
{
  if (NS_FRAME_LOG_TEST(sFrameLogModule, NS_FRAME_TRACE_CALLS)) {
    char tagbuf[40];
    GetTagName(this, mContent, sizeof(tagbuf), tagbuf);
    PR_LogPrint("%s: %s %s", tagbuf, aEnter ? "enter" : "exit", aMethod);
  }
}

void
nsFrame::Trace(const char* aMethod, bool aEnter, nsReflowStatus aStatus)
{
  if (NS_FRAME_LOG_TEST(sFrameLogModule, NS_FRAME_TRACE_CALLS)) {
    char tagbuf[40];
    GetTagName(this, mContent, sizeof(tagbuf), tagbuf);
    PR_LogPrint("%s: %s %s, status=%scomplete%s",
                tagbuf, aEnter ? "enter" : "exit", aMethod,
                NS_FRAME_IS_NOT_COMPLETE(aStatus) ? "not" : "",
                (NS_FRAME_REFLOW_NEXTINFLOW & aStatus) ? "+reflow" : "");
  }
}

void
nsFrame::TraceMsg(const char* aFormatString, ...)
{
  if (NS_FRAME_LOG_TEST(sFrameLogModule, NS_FRAME_TRACE_CALLS)) {
    // Format arguments into a buffer
    char argbuf[200];
    va_list ap;
    va_start(ap, aFormatString);
    PR_vsnprintf(argbuf, sizeof(argbuf), aFormatString, ap);
    va_end(ap);

    char tagbuf[40];
    GetTagName(this, mContent, sizeof(tagbuf), tagbuf);
    PR_LogPrint("%s: %s", tagbuf, argbuf);
  }
}

void
nsFrame::VerifyDirtyBitSet(const nsFrameList& aFrameList)
{
  for (nsFrameList::Enumerator e(aFrameList); !e.AtEnd(); e.Next()) {
    NS_ASSERTION(e.get()->GetStateBits() & NS_FRAME_IS_DIRTY,
                 "dirty bit not set");
  }
}

// Start Display Reflow
#ifdef DEBUG

DR_cookie::DR_cookie(nsPresContext*          aPresContext,
                     nsIFrame*                aFrame, 
                     const ReflowInput& aReflowInput,
                     ReflowOutput&     aMetrics,
                     nsReflowStatus&          aStatus)
  :mPresContext(aPresContext), mFrame(aFrame), mReflowInput(aReflowInput), mMetrics(aMetrics), mStatus(aStatus)
{
  MOZ_COUNT_CTOR(DR_cookie);
  mValue = nsFrame::DisplayReflowEnter(aPresContext, mFrame, mReflowInput);
}

DR_cookie::~DR_cookie()
{
  MOZ_COUNT_DTOR(DR_cookie);
  nsFrame::DisplayReflowExit(mPresContext, mFrame, mMetrics, mStatus, mValue);
}

DR_layout_cookie::DR_layout_cookie(nsIFrame* aFrame)
  : mFrame(aFrame)
{
  MOZ_COUNT_CTOR(DR_layout_cookie);
  mValue = nsFrame::DisplayLayoutEnter(mFrame);
}

DR_layout_cookie::~DR_layout_cookie()
{
  MOZ_COUNT_DTOR(DR_layout_cookie);
  nsFrame::DisplayLayoutExit(mFrame, mValue);
}

DR_intrinsic_width_cookie::DR_intrinsic_width_cookie(
                     nsIFrame*                aFrame, 
                     const char*              aType,
                     nscoord&                 aResult)
  : mFrame(aFrame)
  , mType(aType)
  , mResult(aResult)
{
  MOZ_COUNT_CTOR(DR_intrinsic_width_cookie);
  mValue = nsFrame::DisplayIntrinsicISizeEnter(mFrame, mType);
}

DR_intrinsic_width_cookie::~DR_intrinsic_width_cookie()
{
  MOZ_COUNT_DTOR(DR_intrinsic_width_cookie);
  nsFrame::DisplayIntrinsicISizeExit(mFrame, mType, mResult, mValue);
}

DR_intrinsic_size_cookie::DR_intrinsic_size_cookie(
                     nsIFrame*                aFrame, 
                     const char*              aType,
                     nsSize&                  aResult)
  : mFrame(aFrame)
  , mType(aType)
  , mResult(aResult)
{
  MOZ_COUNT_CTOR(DR_intrinsic_size_cookie);
  mValue = nsFrame::DisplayIntrinsicSizeEnter(mFrame, mType);
}

DR_intrinsic_size_cookie::~DR_intrinsic_size_cookie()
{
  MOZ_COUNT_DTOR(DR_intrinsic_size_cookie);
  nsFrame::DisplayIntrinsicSizeExit(mFrame, mType, mResult, mValue);
}

DR_init_constraints_cookie::DR_init_constraints_cookie(
                     nsIFrame*                aFrame,
                     ReflowInput*       aState,
                     nscoord                  aCBWidth,
                     nscoord                  aCBHeight,
                     const nsMargin*          aMargin,
                     const nsMargin*          aPadding)
  : mFrame(aFrame)
  , mState(aState)
{
  MOZ_COUNT_CTOR(DR_init_constraints_cookie);
  mValue = ReflowInput::DisplayInitConstraintsEnter(mFrame, mState,
                                                          aCBWidth, aCBHeight,
                                                          aMargin, aPadding);
}

DR_init_constraints_cookie::~DR_init_constraints_cookie()
{
  MOZ_COUNT_DTOR(DR_init_constraints_cookie);
  ReflowInput::DisplayInitConstraintsExit(mFrame, mState, mValue);
}

DR_init_offsets_cookie::DR_init_offsets_cookie(
                     nsIFrame*                aFrame,
                     SizeComputationInput*        aState,
                     const LogicalSize&       aPercentBasis,
                     const nsMargin*          aMargin,
                     const nsMargin*          aPadding)
  : mFrame(aFrame)
  , mState(aState)
{
  MOZ_COUNT_CTOR(DR_init_offsets_cookie);
  mValue = SizeComputationInput::DisplayInitOffsetsEnter(mFrame, mState,
                                                     aPercentBasis,
                                                     aMargin, aPadding);
}

DR_init_offsets_cookie::~DR_init_offsets_cookie()
{
  MOZ_COUNT_DTOR(DR_init_offsets_cookie);
  SizeComputationInput::DisplayInitOffsetsExit(mFrame, mState, mValue);
}

DR_init_type_cookie::DR_init_type_cookie(
                     nsIFrame*                aFrame,
                     ReflowInput*       aState)
  : mFrame(aFrame)
  , mState(aState)
{
  MOZ_COUNT_CTOR(DR_init_type_cookie);
  mValue = ReflowInput::DisplayInitFrameTypeEnter(mFrame, mState);
}

DR_init_type_cookie::~DR_init_type_cookie()
{
  MOZ_COUNT_DTOR(DR_init_type_cookie);
  ReflowInput::DisplayInitFrameTypeExit(mFrame, mState, mValue);
}

struct DR_FrameTypeInfo;
struct DR_FrameTreeNode;
struct DR_Rule;

struct DR_State
{
  DR_State();
  ~DR_State();
  void Init();
  void AddFrameTypeInfo(nsIAtom* aFrameType,
                        const char* aFrameNameAbbrev,
                        const char* aFrameName);
  DR_FrameTypeInfo* GetFrameTypeInfo(nsIAtom* aFrameType);
  DR_FrameTypeInfo* GetFrameTypeInfo(char* aFrameName);
  void InitFrameTypeTable();
  DR_FrameTreeNode* CreateTreeNode(nsIFrame*                aFrame,
                                   const ReflowInput* aReflowInput);
  void FindMatchingRule(DR_FrameTreeNode& aNode);
  bool RuleMatches(DR_Rule&          aRule,
                     DR_FrameTreeNode& aNode);
  bool GetToken(FILE* aFile,
                  char* aBuf,
                  size_t aBufSize);
  DR_Rule* ParseRule(FILE* aFile);
  void ParseRulesFile();
  void AddRule(nsTArray<DR_Rule*>& aRules,
               DR_Rule&            aRule);
  bool IsWhiteSpace(int c);
  bool GetNumber(char*    aBuf, 
                 int32_t&  aNumber);
  void PrettyUC(nscoord aSize,
                char*   aBuf,
                int     aBufSize);
  void PrintMargin(const char* tag, const nsMargin* aMargin);
  void DisplayFrameTypeInfo(nsIFrame* aFrame,
                            int32_t   aIndent);
  void DeleteTreeNode(DR_FrameTreeNode& aNode);

  bool        mInited;
  bool        mActive;
  int32_t     mCount;
  int32_t     mAssert;
  int32_t     mIndent;
  bool        mIndentUndisplayedFrames;
  bool        mDisplayPixelErrors;
  nsTArray<DR_Rule*>          mWildRules;
  nsTArray<DR_FrameTypeInfo>  mFrameTypeTable;
  // reflow specific state
  nsTArray<DR_FrameTreeNode*> mFrameTreeLeaves;
};

static DR_State *DR_state; // the one and only DR_State

struct DR_RulePart 
{
  explicit DR_RulePart(nsIAtom* aFrameType) : mFrameType(aFrameType), mNext(0) {}
  void Destroy();

  nsIAtom*     mFrameType;
  DR_RulePart* mNext;
};

void DR_RulePart::Destroy()
{
  if (mNext) {
    mNext->Destroy();
  }
  delete this;
}

struct DR_Rule 
{
  DR_Rule() : mLength(0), mTarget(nullptr), mDisplay(false) {
    MOZ_COUNT_CTOR(DR_Rule);
  }
  ~DR_Rule() {
    if (mTarget) mTarget->Destroy();
    MOZ_COUNT_DTOR(DR_Rule);
  }
  void AddPart(nsIAtom* aFrameType);

  uint32_t      mLength;
  DR_RulePart*  mTarget;
  bool          mDisplay;
};

void DR_Rule::AddPart(nsIAtom* aFrameType)
{
  DR_RulePart* newPart = new DR_RulePart(aFrameType);
  newPart->mNext = mTarget;
  mTarget = newPart;
  mLength++;
}

struct DR_FrameTypeInfo
{
  DR_FrameTypeInfo(nsIAtom* aFrmeType, const char* aFrameNameAbbrev, const char* aFrameName);
  ~DR_FrameTypeInfo() { 
      int32_t numElements;
      numElements = mRules.Length();
      for (int32_t i = numElements - 1; i >= 0; i--) {
        delete mRules.ElementAt(i);
      }
   }

  nsIAtom*    mType;
  char        mNameAbbrev[16];
  char        mName[32];
  nsTArray<DR_Rule*> mRules;
private:
  DR_FrameTypeInfo& operator=(const DR_FrameTypeInfo&) = delete;
};

DR_FrameTypeInfo::DR_FrameTypeInfo(nsIAtom* aFrameType, 
                                   const char* aFrameNameAbbrev, 
                                   const char* aFrameName)
{
  mType = aFrameType;
  PL_strncpyz(mNameAbbrev, aFrameNameAbbrev, sizeof(mNameAbbrev));
  PL_strncpyz(mName, aFrameName, sizeof(mName));
}

struct DR_FrameTreeNode
{
  DR_FrameTreeNode(nsIFrame* aFrame, DR_FrameTreeNode* aParent) : mFrame(aFrame), mParent(aParent), mDisplay(0), mIndent(0)
  {
    MOZ_COUNT_CTOR(DR_FrameTreeNode);
  }

  ~DR_FrameTreeNode()
  {
    MOZ_COUNT_DTOR(DR_FrameTreeNode);
  }

  nsIFrame*         mFrame;
  DR_FrameTreeNode* mParent;
  bool              mDisplay;
  uint32_t          mIndent;
};

// DR_State implementation

DR_State::DR_State() 
: mInited(false), mActive(false), mCount(0), mAssert(-1), mIndent(0), 
  mIndentUndisplayedFrames(false), mDisplayPixelErrors(false)
{
  MOZ_COUNT_CTOR(DR_State);
}

void DR_State::Init() 
{
  char* env = PR_GetEnv("GECKO_DISPLAY_REFLOW_ASSERT");
  int32_t num;
  if (env) {
    if (GetNumber(env, num)) 
      mAssert = num;
    else 
      printf("GECKO_DISPLAY_REFLOW_ASSERT - invalid value = %s", env);
  }

  env = PR_GetEnv("GECKO_DISPLAY_REFLOW_INDENT_START");
  if (env) {
    if (GetNumber(env, num)) 
      mIndent = num;
    else 
      printf("GECKO_DISPLAY_REFLOW_INDENT_START - invalid value = %s", env);
  }

  env = PR_GetEnv("GECKO_DISPLAY_REFLOW_INDENT_UNDISPLAYED_FRAMES");
  if (env) {
    if (GetNumber(env, num)) 
      mIndentUndisplayedFrames = num;
    else 
      printf("GECKO_DISPLAY_REFLOW_INDENT_UNDISPLAYED_FRAMES - invalid value = %s", env);
  }

  env = PR_GetEnv("GECKO_DISPLAY_REFLOW_FLAG_PIXEL_ERRORS");
  if (env) {
    if (GetNumber(env, num)) 
      mDisplayPixelErrors = num;
    else 
      printf("GECKO_DISPLAY_REFLOW_FLAG_PIXEL_ERRORS - invalid value = %s", env);
  }

  InitFrameTypeTable();
  ParseRulesFile();
  mInited = true;
}

DR_State::~DR_State()
{
  MOZ_COUNT_DTOR(DR_State);
  int32_t numElements, i;
  numElements = mWildRules.Length();
  for (i = numElements - 1; i >= 0; i--) {
    delete mWildRules.ElementAt(i);
  }
  numElements = mFrameTreeLeaves.Length();
  for (i = numElements - 1; i >= 0; i--) {
    delete mFrameTreeLeaves.ElementAt(i);
  }
}

bool DR_State::GetNumber(char*     aBuf, 
                           int32_t&  aNumber)
{
  if (sscanf(aBuf, "%d", &aNumber) > 0) 
    return true;
  else 
    return false;
}

bool DR_State::IsWhiteSpace(int c) {
  return (c == ' ') || (c == '\t') || (c == '\n') || (c == '\r');
}

bool DR_State::GetToken(FILE* aFile,
                          char* aBuf,
                          size_t aBufSize)
{
  bool haveToken = false;
  aBuf[0] = 0;
  // get the 1st non whitespace char
  int c = -1;
  for (c = getc(aFile); (c > 0) && IsWhiteSpace(c); c = getc(aFile)) {
  }

  if (c > 0) {
    haveToken = true;
    aBuf[0] = c;
    // get everything up to the next whitespace char
    size_t cX;
    for (cX = 1; cX + 1 < aBufSize ; cX++) {
      c = getc(aFile);
      if (c < 0) { // EOF
        ungetc(' ', aFile); 
        break;
      }
      else {
        if (IsWhiteSpace(c)) {
          break;
        }
        else {
          aBuf[cX] = c;
        }
      }
    }
    aBuf[cX] = 0;
  }
  return haveToken;
}

DR_Rule* DR_State::ParseRule(FILE* aFile)
{
  char buf[128];
  int32_t doDisplay;
  DR_Rule* rule = nullptr;
  while (GetToken(aFile, buf, sizeof(buf))) {
    if (GetNumber(buf, doDisplay)) {
      if (rule) { 
        rule->mDisplay = !!doDisplay;
        break;
      }
      else {
        printf("unexpected token - %s \n", buf);
      }
    }
    else {
      if (!rule) {
        rule = new DR_Rule;
      }
      if (strcmp(buf, "*") == 0) {
        rule->AddPart(nullptr);
      }
      else {
        DR_FrameTypeInfo* info = GetFrameTypeInfo(buf);
        if (info) {
          rule->AddPart(info->mType);
        }
        else {
          printf("invalid frame type - %s \n", buf);
        }
      }
    }
  }
  return rule;
}

void DR_State::AddRule(nsTArray<DR_Rule*>& aRules,
                       DR_Rule&            aRule)
{
  int32_t numRules = aRules.Length();
  for (int32_t ruleX = 0; ruleX < numRules; ruleX++) {
    DR_Rule* rule = aRules.ElementAt(ruleX);
    NS_ASSERTION(rule, "program error");
    if (aRule.mLength > rule->mLength) {
      aRules.InsertElementAt(ruleX, &aRule);
      return;
    }
  }
  aRules.AppendElement(&aRule);
}

void DR_State::ParseRulesFile()
{
  char* path = PR_GetEnv("GECKO_DISPLAY_REFLOW_RULES_FILE");
  if (path) {
    FILE* inFile = fopen(path, "r");
    if (inFile) {
      for (DR_Rule* rule = ParseRule(inFile); rule; rule = ParseRule(inFile)) {
        if (rule->mTarget) {
          nsIAtom* fType = rule->mTarget->mFrameType;
          if (fType) {
            DR_FrameTypeInfo* info = GetFrameTypeInfo(fType);
            if (info) {
              AddRule(info->mRules, *rule);
            }
          }
          else {
            AddRule(mWildRules, *rule);
          }
          mActive = true;
        }
      }

      fclose(inFile);
    }
  }
}


void DR_State::AddFrameTypeInfo(nsIAtom* aFrameType,
                                const char* aFrameNameAbbrev,
                                const char* aFrameName)
{
  mFrameTypeTable.AppendElement(DR_FrameTypeInfo(aFrameType, aFrameNameAbbrev, aFrameName));
}

DR_FrameTypeInfo* DR_State::GetFrameTypeInfo(nsIAtom* aFrameType)
{
  int32_t numEntries = mFrameTypeTable.Length();
  NS_ASSERTION(numEntries != 0, "empty FrameTypeTable");
  for (int32_t i = 0; i < numEntries; i++) {
    DR_FrameTypeInfo& info = mFrameTypeTable.ElementAt(i);
    if (info.mType == aFrameType) {
      return &info;
    }
  }
  return &mFrameTypeTable.ElementAt(numEntries - 1); // return unknown frame type
}

DR_FrameTypeInfo* DR_State::GetFrameTypeInfo(char* aFrameName)
{
  int32_t numEntries = mFrameTypeTable.Length();
  NS_ASSERTION(numEntries != 0, "empty FrameTypeTable");
  for (int32_t i = 0; i < numEntries; i++) {
    DR_FrameTypeInfo& info = mFrameTypeTable.ElementAt(i);
    if ((strcmp(aFrameName, info.mName) == 0) || (strcmp(aFrameName, info.mNameAbbrev) == 0)) {
      return &info;
    }
  }
  return &mFrameTypeTable.ElementAt(numEntries - 1); // return unknown frame type
}

void DR_State::InitFrameTypeTable()
{  
  AddFrameTypeInfo(nsGkAtoms::blockFrame,            "block",     "block");
  AddFrameTypeInfo(nsGkAtoms::brFrame,               "br",        "br");
  AddFrameTypeInfo(nsGkAtoms::bulletFrame,           "bullet",    "bullet");
  AddFrameTypeInfo(nsGkAtoms::colorControlFrame,     "color",     "colorControl");
  AddFrameTypeInfo(nsGkAtoms::gfxButtonControlFrame, "button",    "gfxButtonControl");
  AddFrameTypeInfo(nsGkAtoms::HTMLButtonControlFrame, "HTMLbutton",    "HTMLButtonControl");
  AddFrameTypeInfo(nsGkAtoms::HTMLCanvasFrame,       "HTMLCanvas","HTMLCanvas");
  AddFrameTypeInfo(nsGkAtoms::subDocumentFrame,      "subdoc",    "subDocument");
  AddFrameTypeInfo(nsGkAtoms::imageFrame,            "img",       "image");
  AddFrameTypeInfo(nsGkAtoms::inlineFrame,           "inline",    "inline");
  AddFrameTypeInfo(nsGkAtoms::letterFrame,           "letter",    "letter");
  AddFrameTypeInfo(nsGkAtoms::lineFrame,             "line",      "line");
  AddFrameTypeInfo(nsGkAtoms::listControlFrame,      "select",    "select");
  AddFrameTypeInfo(nsGkAtoms::objectFrame,           "obj",       "object");
  AddFrameTypeInfo(nsGkAtoms::pageFrame,             "page",      "page");
  AddFrameTypeInfo(nsGkAtoms::placeholderFrame,      "place",     "placeholder");
  AddFrameTypeInfo(nsGkAtoms::canvasFrame,           "canvas",    "canvas");
  AddFrameTypeInfo(nsGkAtoms::rootFrame,             "root",      "root");
  AddFrameTypeInfo(nsGkAtoms::scrollFrame,           "scroll",    "scroll");
  AddFrameTypeInfo(nsGkAtoms::tableCellFrame,        "cell",      "tableCell");
  AddFrameTypeInfo(nsGkAtoms::bcTableCellFrame,      "bcCell",    "bcTableCell");
  AddFrameTypeInfo(nsGkAtoms::tableColFrame,         "col",       "tableCol");
  AddFrameTypeInfo(nsGkAtoms::tableColGroupFrame,    "colG",      "tableColGroup");
  AddFrameTypeInfo(nsGkAtoms::tableFrame,            "tbl",       "table");
  AddFrameTypeInfo(nsGkAtoms::tableWrapperFrame,     "tblW",      "tableWrapper");
  AddFrameTypeInfo(nsGkAtoms::tableRowGroupFrame,    "rowG",      "tableRowGroup");
  AddFrameTypeInfo(nsGkAtoms::tableRowFrame,         "row",       "tableRow");
  AddFrameTypeInfo(nsGkAtoms::textInputFrame,        "textCtl",   "textInput");
  AddFrameTypeInfo(nsGkAtoms::textFrame,             "text",      "text");
  AddFrameTypeInfo(nsGkAtoms::viewportFrame,         "VP",        "viewport");
#ifdef MOZ_XUL
  AddFrameTypeInfo(nsGkAtoms::XULLabelFrame,         "XULLabel",  "XULLabel");
  AddFrameTypeInfo(nsGkAtoms::boxFrame,              "Box",       "Box");
  AddFrameTypeInfo(nsGkAtoms::sliderFrame,           "Slider",    "Slider");
  AddFrameTypeInfo(nsGkAtoms::popupSetFrame,         "PopupSet",  "PopupSet");
#endif
  AddFrameTypeInfo(nullptr,                          "unknown",   "unknown");
}


void DR_State::DisplayFrameTypeInfo(nsIFrame* aFrame,
                                    int32_t   aIndent)
{ 
  DR_FrameTypeInfo* frameTypeInfo = GetFrameTypeInfo(aFrame->GetType());
  if (frameTypeInfo) {
    for (int32_t i = 0; i < aIndent; i++) {
      printf(" ");
    }
    if(!strcmp(frameTypeInfo->mNameAbbrev, "unknown")) {
      if (aFrame) {
       nsAutoString  name;
       aFrame->GetFrameName(name);
       printf("%s %p ", NS_LossyConvertUTF16toASCII(name).get(), (void*)aFrame);
      }
      else {
        printf("%s %p ", frameTypeInfo->mNameAbbrev, (void*)aFrame);
      }
    }
    else {
      printf("%s %p ", frameTypeInfo->mNameAbbrev, (void*)aFrame);
    }
  }
}

bool DR_State::RuleMatches(DR_Rule&          aRule,
                             DR_FrameTreeNode& aNode)
{
  NS_ASSERTION(aRule.mTarget, "program error");

  DR_RulePart* rulePart;
  DR_FrameTreeNode* parentNode;
  for (rulePart = aRule.mTarget->mNext, parentNode = aNode.mParent;
       rulePart && parentNode;
       rulePart = rulePart->mNext, parentNode = parentNode->mParent) {
    if (rulePart->mFrameType) {
      if (parentNode->mFrame) {
        if (rulePart->mFrameType != parentNode->mFrame->GetType()) {
          return false;
        }
      }
      else NS_ASSERTION(false, "program error");
    }
    // else wild card match
  }
  return true;
}

void DR_State::FindMatchingRule(DR_FrameTreeNode& aNode)
{
  if (!aNode.mFrame) {
    NS_ASSERTION(false, "invalid DR_FrameTreeNode \n");
    return;
  }

  bool matchingRule = false;

  DR_FrameTypeInfo* info = GetFrameTypeInfo(aNode.mFrame->GetType());
  NS_ASSERTION(info, "program error");
  int32_t numRules = info->mRules.Length();
  for (int32_t ruleX = 0; ruleX < numRules; ruleX++) {
    DR_Rule* rule = info->mRules.ElementAt(ruleX);
    if (rule && RuleMatches(*rule, aNode)) {
      aNode.mDisplay = rule->mDisplay;
      matchingRule = true;
      break;
    }
  }
  if (!matchingRule) {
    int32_t numWildRules = mWildRules.Length();
    for (int32_t ruleX = 0; ruleX < numWildRules; ruleX++) {
      DR_Rule* rule = mWildRules.ElementAt(ruleX);
      if (rule && RuleMatches(*rule, aNode)) {
        aNode.mDisplay = rule->mDisplay;
        break;
      }
    }
  }
}
    
DR_FrameTreeNode* DR_State::CreateTreeNode(nsIFrame*                aFrame,
                                           const ReflowInput* aReflowInput)
{
  // find the frame of the parent reflow state (usually just the parent of aFrame)
  nsIFrame* parentFrame;
  if (aReflowInput) {
    const ReflowInput* parentRI = aReflowInput->mParentReflowInput;
    parentFrame = (parentRI) ? parentRI->mFrame : nullptr;
  } else {
    parentFrame = aFrame->GetParent();
  }

  // find the parent tree node leaf
  DR_FrameTreeNode* parentNode = nullptr;
  
  DR_FrameTreeNode* lastLeaf = nullptr;
  if(mFrameTreeLeaves.Length())
    lastLeaf = mFrameTreeLeaves.ElementAt(mFrameTreeLeaves.Length() - 1);
  if (lastLeaf) {
    for (parentNode = lastLeaf; parentNode && (parentNode->mFrame != parentFrame); parentNode = parentNode->mParent) {
    }
  }
  DR_FrameTreeNode* newNode = new DR_FrameTreeNode(aFrame, parentNode);
  FindMatchingRule(*newNode);

  newNode->mIndent = mIndent;
  if (newNode->mDisplay || mIndentUndisplayedFrames) {
    ++mIndent;
  }

  if (lastLeaf && (lastLeaf == parentNode)) {
    mFrameTreeLeaves.RemoveElementAt(mFrameTreeLeaves.Length() - 1);
  }
  mFrameTreeLeaves.AppendElement(newNode);
  mCount++;

  return newNode;
}

void DR_State::PrettyUC(nscoord aSize,
                        char*   aBuf,
                        int     aBufSize)
{
  if (NS_UNCONSTRAINEDSIZE == aSize) {
    strcpy(aBuf, "UC");
  }
  else {
    if ((nscoord)0xdeadbeefU == aSize)
    {
      strcpy(aBuf, "deadbeef");
    }
    else {
      snprintf(aBuf, aBufSize, "%d", aSize);
    }
  }
}

void DR_State::PrintMargin(const char *tag, const nsMargin* aMargin)
{
  if (aMargin) {
    char t[16], r[16], b[16], l[16];
    PrettyUC(aMargin->top, t, 16);
    PrettyUC(aMargin->right, r, 16);
    PrettyUC(aMargin->bottom, b, 16);
    PrettyUC(aMargin->left, l, 16);
    printf(" %s=%s,%s,%s,%s", tag, t, r, b, l);
  } else {
    // use %p here for consistency with other null-pointer printouts
    printf(" %s=%p", tag, (void*)aMargin);
  }
}

void DR_State::DeleteTreeNode(DR_FrameTreeNode& aNode)
{
  mFrameTreeLeaves.RemoveElement(&aNode);
  int32_t numLeaves = mFrameTreeLeaves.Length();
  if ((0 == numLeaves) || (aNode.mParent != mFrameTreeLeaves.ElementAt(numLeaves - 1))) {
    mFrameTreeLeaves.AppendElement(aNode.mParent);
  }

  if (aNode.mDisplay || mIndentUndisplayedFrames) {
    --mIndent;
  }
  // delete the tree node 
  delete &aNode;
}

static void
CheckPixelError(nscoord aSize,
                int32_t aPixelToTwips)
{
  if (NS_UNCONSTRAINEDSIZE != aSize) {
    if ((aSize % aPixelToTwips) > 0) {
      printf("VALUE %d is not a whole pixel \n", aSize);
    }
  }
}

static void DisplayReflowEnterPrint(nsPresContext*          aPresContext,
                                    nsIFrame*                aFrame,
                                    const ReflowInput& aReflowInput,
                                    DR_FrameTreeNode&        aTreeNode,
                                    bool                     aChanged)
{
  if (aTreeNode.mDisplay) {
    DR_state->DisplayFrameTypeInfo(aFrame, aTreeNode.mIndent);

    char width[16];
    char height[16];

    DR_state->PrettyUC(aReflowInput.AvailableWidth(), width, 16);
    DR_state->PrettyUC(aReflowInput.AvailableHeight(), height, 16);
    printf("Reflow a=%s,%s ", width, height);

    DR_state->PrettyUC(aReflowInput.ComputedWidth(), width, 16);
    DR_state->PrettyUC(aReflowInput.ComputedHeight(), height, 16);
    printf("c=%s,%s ", width, height);

    if (aFrame->GetStateBits() & NS_FRAME_IS_DIRTY)
      printf("dirty ");

    if (aFrame->GetStateBits() & NS_FRAME_HAS_DIRTY_CHILDREN)
      printf("dirty-children ");

    if (aReflowInput.mFlags.mSpecialBSizeReflow)
      printf("special-bsize ");

    if (aReflowInput.IsHResize())
      printf("h-resize ");

    if (aReflowInput.IsVResize())
      printf("v-resize ");

    nsIFrame* inFlow = aFrame->GetPrevInFlow();
    if (inFlow) {
      printf("pif=%p ", (void*)inFlow);
    }
    inFlow = aFrame->GetNextInFlow();
    if (inFlow) {
      printf("nif=%p ", (void*)inFlow);
    }
    if (aChanged) 
      printf("CHANGED \n");
    else 
      printf("cnt=%d \n", DR_state->mCount);
    if (DR_state->mDisplayPixelErrors) {
      int32_t p2t = aPresContext->AppUnitsPerDevPixel();
      CheckPixelError(aReflowInput.AvailableWidth(), p2t);
      CheckPixelError(aReflowInput.AvailableHeight(), p2t);
      CheckPixelError(aReflowInput.ComputedWidth(), p2t);
      CheckPixelError(aReflowInput.ComputedHeight(), p2t);
    }
  }
}

void* nsFrame::DisplayReflowEnter(nsPresContext*          aPresContext,
                                  nsIFrame*                aFrame,
                                  const ReflowInput& aReflowInput)
{
  if (!DR_state->mInited) DR_state->Init();
  if (!DR_state->mActive) return nullptr;

  NS_ASSERTION(aFrame, "invalid call");

  DR_FrameTreeNode* treeNode = DR_state->CreateTreeNode(aFrame, &aReflowInput);
  if (treeNode) {
    DisplayReflowEnterPrint(aPresContext, aFrame, aReflowInput, *treeNode, false);
  }
  return treeNode;
}

void* nsFrame::DisplayLayoutEnter(nsIFrame* aFrame)
{
  if (!DR_state->mInited) DR_state->Init();
  if (!DR_state->mActive) return nullptr;

  NS_ASSERTION(aFrame, "invalid call");

  DR_FrameTreeNode* treeNode = DR_state->CreateTreeNode(aFrame, nullptr);
  if (treeNode && treeNode->mDisplay) {
    DR_state->DisplayFrameTypeInfo(aFrame, treeNode->mIndent);
    printf("XULLayout\n");
  }
  return treeNode;
}

void* nsFrame::DisplayIntrinsicISizeEnter(nsIFrame* aFrame,
                                          const char* aType)
{
  if (!DR_state->mInited) DR_state->Init();
  if (!DR_state->mActive) return nullptr;

  NS_ASSERTION(aFrame, "invalid call");

  DR_FrameTreeNode* treeNode = DR_state->CreateTreeNode(aFrame, nullptr);
  if (treeNode && treeNode->mDisplay) {
    DR_state->DisplayFrameTypeInfo(aFrame, treeNode->mIndent);
    printf("Get%sWidth\n", aType);
  }
  return treeNode;
}

void* nsFrame::DisplayIntrinsicSizeEnter(nsIFrame* aFrame,
                                         const char* aType)
{
  if (!DR_state->mInited) DR_state->Init();
  if (!DR_state->mActive) return nullptr;

  NS_ASSERTION(aFrame, "invalid call");

  DR_FrameTreeNode* treeNode = DR_state->CreateTreeNode(aFrame, nullptr);
  if (treeNode && treeNode->mDisplay) {
    DR_state->DisplayFrameTypeInfo(aFrame, treeNode->mIndent);
    printf("Get%sSize\n", aType);
  }
  return treeNode;
}

void nsFrame::DisplayReflowExit(nsPresContext*      aPresContext,
                                nsIFrame*            aFrame,
                                ReflowOutput& aMetrics,
                                nsReflowStatus       aStatus,
                                void*                aFrameTreeNode)
{
  if (!DR_state->mActive) return;

  NS_ASSERTION(aFrame, "DisplayReflowExit - invalid call");
  if (!aFrameTreeNode) return;

  DR_FrameTreeNode* treeNode = (DR_FrameTreeNode*)aFrameTreeNode;
  if (treeNode->mDisplay) {
    DR_state->DisplayFrameTypeInfo(aFrame, treeNode->mIndent);

    char width[16];
    char height[16];
    char x[16];
    char y[16];
    DR_state->PrettyUC(aMetrics.Width(), width, 16);
    DR_state->PrettyUC(aMetrics.Height(), height, 16);
    printf("Reflow d=%s,%s", width, height);

    if (!NS_FRAME_IS_FULLY_COMPLETE(aStatus)) {
      printf(" status=0x%x", aStatus);
    }
    if (aFrame->HasOverflowAreas()) {
      DR_state->PrettyUC(aMetrics.VisualOverflow().x, x, 16);
      DR_state->PrettyUC(aMetrics.VisualOverflow().y, y, 16);
      DR_state->PrettyUC(aMetrics.VisualOverflow().width, width, 16);
      DR_state->PrettyUC(aMetrics.VisualOverflow().height, height, 16);
      printf(" vis-o=(%s,%s) %s x %s", x, y, width, height);

      nsRect storedOverflow = aFrame->GetVisualOverflowRect();
      DR_state->PrettyUC(storedOverflow.x, x, 16);
      DR_state->PrettyUC(storedOverflow.y, y, 16);
      DR_state->PrettyUC(storedOverflow.width, width, 16);
      DR_state->PrettyUC(storedOverflow.height, height, 16);
      printf(" vis-sto=(%s,%s) %s x %s", x, y, width, height);

      DR_state->PrettyUC(aMetrics.ScrollableOverflow().x, x, 16);
      DR_state->PrettyUC(aMetrics.ScrollableOverflow().y, y, 16);
      DR_state->PrettyUC(aMetrics.ScrollableOverflow().width, width, 16);
      DR_state->PrettyUC(aMetrics.ScrollableOverflow().height, height, 16);
      printf(" scr-o=(%s,%s) %s x %s", x, y, width, height);

      storedOverflow = aFrame->GetScrollableOverflowRect();
      DR_state->PrettyUC(storedOverflow.x, x, 16);
      DR_state->PrettyUC(storedOverflow.y, y, 16);
      DR_state->PrettyUC(storedOverflow.width, width, 16);
      DR_state->PrettyUC(storedOverflow.height, height, 16);
      printf(" scr-sto=(%s,%s) %s x %s", x, y, width, height);
    }
    printf("\n");
    if (DR_state->mDisplayPixelErrors) {
      int32_t p2t = aPresContext->AppUnitsPerDevPixel();
      CheckPixelError(aMetrics.Width(), p2t);
      CheckPixelError(aMetrics.Height(), p2t);
    }
  }
  DR_state->DeleteTreeNode(*treeNode);
}

void nsFrame::DisplayLayoutExit(nsIFrame*            aFrame,
                                void*                aFrameTreeNode)
{
  if (!DR_state->mActive) return;

  NS_ASSERTION(aFrame, "non-null frame required");
  if (!aFrameTreeNode) return;

  DR_FrameTreeNode* treeNode = (DR_FrameTreeNode*)aFrameTreeNode;
  if (treeNode->mDisplay) {
    DR_state->DisplayFrameTypeInfo(aFrame, treeNode->mIndent);
    nsRect rect = aFrame->GetRect();
    printf("XULLayout=%d,%d,%d,%d\n", rect.x, rect.y, rect.width, rect.height);
  }
  DR_state->DeleteTreeNode(*treeNode);
}

void nsFrame::DisplayIntrinsicISizeExit(nsIFrame*            aFrame,
                                        const char*          aType,
                                        nscoord              aResult,
                                        void*                aFrameTreeNode)
{
  if (!DR_state->mActive) return;

  NS_ASSERTION(aFrame, "non-null frame required");
  if (!aFrameTreeNode) return;

  DR_FrameTreeNode* treeNode = (DR_FrameTreeNode*)aFrameTreeNode;
  if (treeNode->mDisplay) {
    DR_state->DisplayFrameTypeInfo(aFrame, treeNode->mIndent);
    char width[16];
    DR_state->PrettyUC(aResult, width, 16);
    printf("Get%sWidth=%s\n", aType, width);
  }
  DR_state->DeleteTreeNode(*treeNode);
}

void nsFrame::DisplayIntrinsicSizeExit(nsIFrame*            aFrame,
                                       const char*          aType,
                                       nsSize               aResult,
                                       void*                aFrameTreeNode)
{
  if (!DR_state->mActive) return;

  NS_ASSERTION(aFrame, "non-null frame required");
  if (!aFrameTreeNode) return;

  DR_FrameTreeNode* treeNode = (DR_FrameTreeNode*)aFrameTreeNode;
  if (treeNode->mDisplay) {
    DR_state->DisplayFrameTypeInfo(aFrame, treeNode->mIndent);

    char width[16];
    char height[16];
    DR_state->PrettyUC(aResult.width, width, 16);
    DR_state->PrettyUC(aResult.height, height, 16);
    printf("Get%sSize=%s,%s\n", aType, width, height);
  }
  DR_state->DeleteTreeNode(*treeNode);
}

/* static */ void
nsFrame::DisplayReflowStartup()
{
  DR_state = new DR_State();
}

/* static */ void
nsFrame::DisplayReflowShutdown()
{
  delete DR_state;
  DR_state = nullptr;
}

void DR_cookie::Change() const
{
  DR_FrameTreeNode* treeNode = (DR_FrameTreeNode*)mValue;
  if (treeNode && treeNode->mDisplay) {
    DisplayReflowEnterPrint(mPresContext, mFrame, mReflowInput, *treeNode, true);
  }
}

/* static */ void*
ReflowInput::DisplayInitConstraintsEnter(nsIFrame* aFrame,
                                               ReflowInput* aState,
                                               nscoord aContainingBlockWidth,
                                               nscoord aContainingBlockHeight,
                                               const nsMargin* aBorder,
                                               const nsMargin* aPadding)
{
  NS_PRECONDITION(aFrame, "non-null frame required");
  NS_PRECONDITION(aState, "non-null state required");

  if (!DR_state->mInited) DR_state->Init();
  if (!DR_state->mActive) return nullptr;

  DR_FrameTreeNode* treeNode = DR_state->CreateTreeNode(aFrame, aState);
  if (treeNode && treeNode->mDisplay) {
    DR_state->DisplayFrameTypeInfo(aFrame, treeNode->mIndent);

    printf("InitConstraints parent=%p",
           (void*)aState->mParentReflowInput);

    char width[16];
    char height[16];

    DR_state->PrettyUC(aContainingBlockWidth, width, 16);
    DR_state->PrettyUC(aContainingBlockHeight, height, 16);
    printf(" cb=%s,%s", width, height);

    DR_state->PrettyUC(aState->AvailableWidth(), width, 16);
    DR_state->PrettyUC(aState->AvailableHeight(), height, 16);
    printf(" as=%s,%s", width, height);

    DR_state->PrintMargin("b", aBorder);
    DR_state->PrintMargin("p", aPadding);
    putchar('\n');
  }
  return treeNode;
}

/* static */ void
ReflowInput::DisplayInitConstraintsExit(nsIFrame* aFrame,
                                              ReflowInput* aState,
                                              void* aValue)
{
  NS_PRECONDITION(aFrame, "non-null frame required");
  NS_PRECONDITION(aState, "non-null state required");

  if (!DR_state->mActive) return;
  if (!aValue) return;

  DR_FrameTreeNode* treeNode = (DR_FrameTreeNode*)aValue;
  if (treeNode->mDisplay) {
    DR_state->DisplayFrameTypeInfo(aFrame, treeNode->mIndent);
    char cmiw[16], cw[16], cmxw[16], cmih[16], ch[16], cmxh[16];
    DR_state->PrettyUC(aState->ComputedMinWidth(), cmiw, 16);
    DR_state->PrettyUC(aState->ComputedWidth(), cw, 16);
    DR_state->PrettyUC(aState->ComputedMaxWidth(), cmxw, 16);
    DR_state->PrettyUC(aState->ComputedMinHeight(), cmih, 16);
    DR_state->PrettyUC(aState->ComputedHeight(), ch, 16);
    DR_state->PrettyUC(aState->ComputedMaxHeight(), cmxh, 16);
    printf("InitConstraints= cw=(%s <= %s <= %s) ch=(%s <= %s <= %s)",
           cmiw, cw, cmxw, cmih, ch, cmxh);
    DR_state->PrintMargin("co", &aState->ComputedPhysicalOffsets());
    putchar('\n');
  }
  DR_state->DeleteTreeNode(*treeNode);
}


/* static */ void*
SizeComputationInput::DisplayInitOffsetsEnter(nsIFrame* aFrame,
                                          SizeComputationInput* aState,
                                          const LogicalSize& aPercentBasis,
                                          const nsMargin* aBorder,
                                          const nsMargin* aPadding)
{
  NS_PRECONDITION(aFrame, "non-null frame required");
  NS_PRECONDITION(aState, "non-null state required");

  if (!DR_state->mInited) DR_state->Init();
  if (!DR_state->mActive) return nullptr;

  // aState is not necessarily a ReflowInput
  DR_FrameTreeNode* treeNode = DR_state->CreateTreeNode(aFrame, nullptr);
  if (treeNode && treeNode->mDisplay) {
    DR_state->DisplayFrameTypeInfo(aFrame, treeNode->mIndent);

    char horizPctBasisStr[16];
    char vertPctBasisStr[16];
    WritingMode wm = aState->GetWritingMode();
    DR_state->PrettyUC(aPercentBasis.ISize(wm), horizPctBasisStr, 16);
    DR_state->PrettyUC(aPercentBasis.BSize(wm), vertPctBasisStr, 16);
    printf("InitOffsets pct_basis=%s,%s", horizPctBasisStr, vertPctBasisStr);

    DR_state->PrintMargin("b", aBorder);
    DR_state->PrintMargin("p", aPadding);
    putchar('\n');
  }
  return treeNode;
}

/* static */ void
SizeComputationInput::DisplayInitOffsetsExit(nsIFrame* aFrame,
                                         SizeComputationInput* aState,
                                         void* aValue)
{
  NS_PRECONDITION(aFrame, "non-null frame required");
  NS_PRECONDITION(aState, "non-null state required");

  if (!DR_state->mActive) return;
  if (!aValue) return;

  DR_FrameTreeNode* treeNode = (DR_FrameTreeNode*)aValue;
  if (treeNode->mDisplay) {
    DR_state->DisplayFrameTypeInfo(aFrame, treeNode->mIndent);
    printf("InitOffsets=");
    DR_state->PrintMargin("m", &aState->ComputedPhysicalMargin());
    DR_state->PrintMargin("p", &aState->ComputedPhysicalPadding());
    DR_state->PrintMargin("p+b", &aState->ComputedPhysicalBorderPadding());
    putchar('\n');
  }
  DR_state->DeleteTreeNode(*treeNode);
}

/* static */ void*
ReflowInput::DisplayInitFrameTypeEnter(nsIFrame* aFrame,
                                             ReflowInput* aState)
{
  NS_PRECONDITION(aFrame, "non-null frame required");
  NS_PRECONDITION(aState, "non-null state required");

  if (!DR_state->mInited) DR_state->Init();
  if (!DR_state->mActive) return nullptr;

  // we don't print anything here
  return DR_state->CreateTreeNode(aFrame, aState);
}

/* static */ void
ReflowInput::DisplayInitFrameTypeExit(nsIFrame* aFrame,
                                            ReflowInput* aState,
                                            void* aValue)
{
  NS_PRECONDITION(aFrame, "non-null frame required");
  NS_PRECONDITION(aState, "non-null state required");

  if (!DR_state->mActive) return;
  if (!aValue) return;

  DR_FrameTreeNode* treeNode = (DR_FrameTreeNode*)aValue;
  if (treeNode->mDisplay) {
    DR_state->DisplayFrameTypeInfo(aFrame, treeNode->mIndent);
    printf("InitFrameType");

    const nsStyleDisplay *disp = aState->mStyleDisplay;

    if (aFrame->GetStateBits() & NS_FRAME_OUT_OF_FLOW)
      printf(" out-of-flow");
    if (aFrame->GetPrevInFlow())
      printf(" prev-in-flow");
    if (aFrame->IsAbsolutelyPositioned())
      printf(" abspos");
    if (aFrame->IsFloating())
      printf(" float");

    // This array must exactly match the StyleDisplay enum.
    const char *const displayTypes[] = {
      "none", "block", "inline", "inline-block", "list-item", "table",
      "inline-table", "table-row-group", "table-column", "table-column",
      "table-column-group", "table-header-group", "table-footer-group",
      "table-row", "table-cell", "table-caption", "flex", "inline-flex",
      "grid", "inline-grid", "ruby", "ruby-base", "ruby-base-container",
      "ruby-text", "ruby-text-container", "contents", "-webkit-box",
      "-webkit-inline-box", "box", "inline-box",
#ifdef MOZ_XUL
      "grid", "inline-grid", "grid-group", "grid-line", "stack",
      "inline-stack", "deck", "groupbox", "popup",
#endif
    };
    const uint32_t display = static_cast<uint32_t>(disp->mDisplay);
    if (display >= ArrayLength(displayTypes))
      printf(" display=%u", display);
    else
      printf(" display=%s", displayTypes[display]);

    // This array must exactly match the NS_CSS_FRAME_TYPE constants.
    const char *const cssFrameTypes[] = {
      "unknown", "inline", "block", "floating", "absolute", "internal-table"
    };
    nsCSSFrameType bareType = NS_FRAME_GET_TYPE(aState->mFrameType);
    bool repNoBlock = NS_FRAME_IS_REPLACED_NOBLOCK(aState->mFrameType);
    bool repBlock = NS_FRAME_IS_REPLACED_CONTAINS_BLOCK(aState->mFrameType);

    if (bareType >= ArrayLength(cssFrameTypes)) {
      printf(" result=type %u", bareType);
    } else {
      printf(" result=%s", cssFrameTypes[bareType]);
    }
    printf("%s%s\n", repNoBlock ? " +rep" : "", repBlock ? " +repBlk" : "");
  }
  DR_state->DeleteTreeNode(*treeNode);
}

#endif
// End Display Reflow

#endif
