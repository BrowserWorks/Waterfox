/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/**
 * Code responsible for managing style changes: tracking what style
 * changes need to happen, scheduling them, and doing them.
 */

#include "mozilla/RestyleManager.h"

#include <algorithm> // For std::max
#include "mozilla/EffectSet.h"
#include "mozilla/EventStates.h"
#include "nsLayoutUtils.h"
#include "AnimationCommon.h" // For GetLayerAnimationInfo
#include "FrameLayerBuilder.h"
#include "GeckoProfiler.h"
#include "LayerAnimationInfo.h" // For LayerAnimationInfo::sRecords
#include "nsAutoPtr.h"
#include "nsStyleChangeList.h"
#include "nsRuleProcessorData.h"
#include "nsStyleSet.h"
#include "nsStyleUtil.h"
#include "nsCSSFrameConstructor.h"
#include "nsSVGEffects.h"
#include "nsCSSPseudoElements.h"
#include "nsCSSRendering.h"
#include "nsAnimationManager.h"
#include "nsTransitionManager.h"
#include "nsViewManager.h"
#include "nsRenderingContext.h"
#include "nsSVGIntegrationUtils.h"
#include "nsCSSAnonBoxes.h"
#include "nsContainerFrame.h"
#include "nsPlaceholderFrame.h"
#include "nsBlockFrame.h"
#include "nsViewportFrame.h"
#include "SVGTextFrame.h"
#include "StickyScrollContainer.h"
#include "nsIRootBox.h"
#include "nsIDOMMutationEvent.h"
#include "nsContentUtils.h"
#include "nsIFrameInlines.h"
#include "ActiveLayerTracker.h"
#include "nsDisplayList.h"
#include "RestyleTrackerInlines.h"
#include "nsSMILAnimationController.h"
#include "nsCSSRuleProcessor.h"
#include "ChildIterator.h"
#include "Layers.h"

#ifdef ACCESSIBILITY
#include "nsAccessibilityService.h"
#endif

namespace mozilla {

using namespace layers;
using namespace dom;

#define LOG_RESTYLE_CONTINUE(reason_, ...) \
  LOG_RESTYLE("continuing restyle since " reason_, ##__VA_ARGS__)

#ifdef RESTYLE_LOGGING
static nsCString
FrameTagToString(const nsIFrame* aFrame)
{
  nsCString result;
  aFrame->ListTag(result);
  return result;
}

static nsCString
ElementTagToString(dom::Element* aElement)
{
  nsCString result;
  nsDependentAtomString buf(aElement->NodeInfo()->NameAtom());
  result.AppendPrintf("(%s@%p)", NS_ConvertUTF16toUTF8(buf).get(), aElement);
  return result;
}
#endif

RestyleManager::RestyleManager(nsPresContext* aPresContext)
  : RestyleManagerBase(aPresContext)
  , mDoRebuildAllStyleData(false)
  , mInRebuildAllStyleData(false)
  , mSkipAnimationRules(false)
  , mHavePendingNonAnimationRestyles(false)
  , mRebuildAllExtraHint(nsChangeHint(0))
  , mRebuildAllRestyleHint(nsRestyleHint(0))
  , mAnimationGeneration(0)
  , mReframingStyleContexts(nullptr)
  , mAnimationsWithDestroyedFrame(nullptr)
  , mPendingRestyles(ELEMENT_HAS_PENDING_RESTYLE |
                     ELEMENT_IS_POTENTIAL_RESTYLE_ROOT |
                     ELEMENT_IS_CONDITIONAL_RESTYLE_ANCESTOR)
  , mIsProcessingRestyles(false)
#ifdef RESTYLE_LOGGING
  , mLoggingDepth(0)
#endif
{
  mPendingRestyles.Init(this);
}

void
RestyleManager::RestyleElement(Element*               aElement,
                               nsIFrame*              aPrimaryFrame,
                               nsChangeHint           aMinHint,
                               RestyleTracker&        aRestyleTracker,
                               nsRestyleHint          aRestyleHint,
                               const RestyleHintData& aRestyleHintData)
{
  MOZ_ASSERT(mReframingStyleContexts, "should have rsc");
  NS_ASSERTION(aPrimaryFrame == aElement->GetPrimaryFrame(),
               "frame/content mismatch");
  if (aPrimaryFrame && aPrimaryFrame->GetContent() != aElement) {
    // XXXbz this is due to image maps messing with the primary frame pointer
    // of <area>s.  See bug 135040.  We can remove this block once that's fixed.
    aPrimaryFrame = nullptr;
  }
  NS_ASSERTION(!aPrimaryFrame || aPrimaryFrame->GetContent() == aElement,
               "frame/content mismatch");

  // If we're restyling the root element and there are 'rem' units in
  // use, handle dynamic changes to the definition of a 'rem' here.
  if (PresContext()->UsesRootEMUnits() && aPrimaryFrame &&
      !mInRebuildAllStyleData) {
    nsStyleContext* oldContext = aPrimaryFrame->StyleContext();
    if (!oldContext->GetParent()) { // check that we're the root element
      RefPtr<nsStyleContext> newContext = StyleSet()->
        ResolveStyleFor(aElement, nullptr /* == oldContext->GetParent() */);
      if (oldContext->StyleFont()->mFont.size !=
          newContext->StyleFont()->mFont.size) {
        // The basis for 'rem' units has changed.
        mRebuildAllRestyleHint |= aRestyleHint;
        if (aRestyleHint & eRestyle_SomeDescendants) {
          mRebuildAllRestyleHint |= eRestyle_Subtree;
        }
        mRebuildAllExtraHint |= aMinHint;
        StartRebuildAllStyleData(aRestyleTracker);
        return;
      }
    }
  }

  if (aMinHint & nsChangeHint_ReconstructFrame) {
    FrameConstructor()->RecreateFramesForContent(aElement, false,
      nsCSSFrameConstructor::REMOVE_FOR_RECONSTRUCTION, nullptr);
  } else if (aPrimaryFrame) {
    ComputeAndProcessStyleChange(aPrimaryFrame, aMinHint, aRestyleTracker,
                                 aRestyleHint, aRestyleHintData);
  } else if (aRestyleHint & ~eRestyle_LaterSiblings) {
    // We're restyling an element with no frame, so we should try to
    // make one if its new style says it should have one.  But in order
    // to try to honor the restyle hint (which we'd like to do so that,
    // for example, an animation-only style flush doesn't flush other
    // buffered style changes), we only do this if the restyle hint says
    // we have *some* restyling for this frame.  This means we'll
    // potentially get ahead of ourselves in that case, but not as much
    // as we would if we didn't check the restyle hint.
    nsStyleContext* newContext =
      FrameConstructor()->MaybeRecreateFramesForElement(aElement);
    if (newContext &&
        newContext->StyleDisplay()->mDisplay == StyleDisplay::Contents) {
      // Style change for a display:contents node that did not recreate frames.
      ComputeAndProcessStyleChange(newContext, aElement, aMinHint,
                                   aRestyleTracker, aRestyleHint,
                                   aRestyleHintData);
    }
  }
}

RestyleManager::ReframingStyleContexts::ReframingStyleContexts(
                                          RestyleManager* aRestyleManager)
  : mRestyleManager(aRestyleManager)
  , mRestorePointer(mRestyleManager->mReframingStyleContexts)
{
  MOZ_ASSERT(!mRestyleManager->mReframingStyleContexts,
             "shouldn't construct recursively");
  mRestyleManager->mReframingStyleContexts = this;
}

RestyleManager::ReframingStyleContexts::~ReframingStyleContexts()
{
  // Before we go away, we need to flush out any frame construction that
  // was enqueued, so that we initiate transitions.
  // Note that this is a little bit evil in that we're calling into code
  // that calls our member functions from our destructor, but it's at
  // the beginning of our destructor, so it shouldn't be too bad.
  mRestyleManager->PresContext()->FrameConstructor()->CreateNeededFrames();
}

RestyleManager::AnimationsWithDestroyedFrame::AnimationsWithDestroyedFrame(
                                          RestyleManager* aRestyleManager)
  : mRestyleManager(aRestyleManager)
  , mRestorePointer(mRestyleManager->mAnimationsWithDestroyedFrame)
{
  MOZ_ASSERT(!mRestyleManager->mAnimationsWithDestroyedFrame,
             "shouldn't construct recursively");
  mRestyleManager->mAnimationsWithDestroyedFrame = this;
}

void
RestyleManager::AnimationsWithDestroyedFrame::StopAnimationsForElementsWithoutFrames()
{
  StopAnimationsWithoutFrame(mContents, CSSPseudoElementType::NotPseudo);
  StopAnimationsWithoutFrame(mBeforeContents, CSSPseudoElementType::before);
  StopAnimationsWithoutFrame(mAfterContents, CSSPseudoElementType::after);
}

void
RestyleManager::AnimationsWithDestroyedFrame::StopAnimationsWithoutFrame(
  nsTArray<RefPtr<nsIContent>>& aArray,
  CSSPseudoElementType aPseudoType)
{
  nsAnimationManager* animationManager =
    mRestyleManager->PresContext()->AnimationManager();
  nsTransitionManager* transitionManager =
    mRestyleManager->PresContext()->TransitionManager();
  for (nsIContent* content : aArray) {
    if (content->GetPrimaryFrame()) {
      continue;
    }
    dom::Element* element = content->AsElement();

    animationManager->StopAnimationsForElement(element, aPseudoType);
    transitionManager->StopTransitionsForElement(element, aPseudoType);

    // All other animations should keep running but not running on the
    // *compositor* at this point.
    EffectSet* effectSet = EffectSet::GetEffectSet(element, aPseudoType);
    if (effectSet) {
      for (KeyframeEffectReadOnly* effect : *effectSet) {
        effect->ResetIsRunningOnCompositor();
      }
    }
  }
}

static inline dom::Element*
ElementForStyleContext(nsIContent* aParentContent,
                       nsIFrame* aFrame,
                       CSSPseudoElementType aPseudoType);

// Forwarded nsIDocumentObserver method, to handle restyling (and
// passing the notification to the frame).
nsresult
RestyleManager::ContentStateChanged(nsIContent* aContent,
                                    EventStates aStateMask)
{
  // XXXbz it would be good if this function only took Elements, but
  // we'd have to make ESM guarantee that usefully.
  if (!aContent->IsElement()) {
    return NS_OK;
  }

  Element* aElement = aContent->AsElement();

  nsChangeHint changeHint;
  nsRestyleHint restyleHint;
  ContentStateChangedInternal(aElement, aStateMask, &changeHint, &restyleHint);

  PostRestyleEvent(aElement, restyleHint, changeHint);
  return NS_OK;
}

// Forwarded nsIMutationObserver method, to handle restyling.
void
RestyleManager::AttributeWillChange(Element* aElement,
                                    int32_t aNameSpaceID,
                                    nsIAtom* aAttribute,
                                    int32_t aModType,
                                    const nsAttrValue* aNewValue)
{
  RestyleHintData rsdata;
  nsRestyleHint rshint =
    StyleSet()->HasAttributeDependentStyle(aElement,
                                           aNameSpaceID,
                                           aAttribute,
                                           aModType,
                                           false,
                                           aNewValue,
                                           rsdata);
  PostRestyleEvent(aElement, rshint, nsChangeHint(0), &rsdata);
}

// Forwarded nsIMutationObserver method, to handle restyling (and
// passing the notification to the frame).
void
RestyleManager::AttributeChanged(Element* aElement,
                                 int32_t aNameSpaceID,
                                 nsIAtom* aAttribute,
                                 int32_t aModType,
                                 const nsAttrValue* aOldValue)
{
  // Hold onto the PresShell to prevent ourselves from being destroyed.
  // XXXbz how, exactly, would this attribute change cause us to be
  // destroyed from inside this function?
  nsCOMPtr<nsIPresShell> shell = PresContext()->GetPresShell();
  mozilla::Unused << shell; // Unused within this function

  // Get the frame associated with the content which is the highest in the frame tree
  nsIFrame* primaryFrame = aElement->GetPrimaryFrame();

#if 0
  NS_FRAME_LOG(NS_FRAME_TRACE_CALLS,
     ("RestyleManager::AttributeChanged: content=%p[%s] frame=%p",
      aContent, ContentTag(aElement, 0), frame));
#endif

  // the style tag has its own interpretation based on aHint
  nsChangeHint hint = aElement->GetAttributeChangeHint(aAttribute, aModType);

  bool reframe = (hint & nsChangeHint_ReconstructFrame) != 0;

#ifdef MOZ_XUL
  // The following listbox widget trap prevents offscreen listbox widget
  // content from being removed and re-inserted (which is what would
  // happen otherwise).
  if (!primaryFrame && !reframe) {
    int32_t namespaceID;
    nsIAtom* tag = PresContext()->Document()->BindingManager()->
                     ResolveTag(aElement, &namespaceID);

    if (namespaceID == kNameSpaceID_XUL &&
        (tag == nsGkAtoms::listitem ||
         tag == nsGkAtoms::listcell))
      return;
  }

  if (aAttribute == nsGkAtoms::tooltiptext ||
      aAttribute == nsGkAtoms::tooltip)
  {
    nsIRootBox* rootBox = nsIRootBox::GetRootBox(PresContext()->GetPresShell());
    if (rootBox) {
      if (aModType == nsIDOMMutationEvent::REMOVAL)
        rootBox->RemoveTooltipSupport(aElement);
      if (aModType == nsIDOMMutationEvent::ADDITION)
        rootBox->AddTooltipSupport(aElement);
    }
  }

#endif // MOZ_XUL

  if (primaryFrame) {
    // See if we have appearance information for a theme.
    const nsStyleDisplay* disp = primaryFrame->StyleDisplay();
    if (disp->mAppearance) {
      nsITheme* theme = PresContext()->GetTheme();
      if (theme && theme->ThemeSupportsWidget(PresContext(), primaryFrame, disp->mAppearance)) {
        bool repaint = false;
        theme->WidgetStateChanged(primaryFrame, disp->mAppearance, aAttribute,
            &repaint, aOldValue);
        if (repaint)
          hint |= nsChangeHint_RepaintFrame;
      }
    }

    // let the frame deal with it now, so we don't have to deal later
    primaryFrame->AttributeChanged(aNameSpaceID, aAttribute, aModType);
    // XXXwaterson should probably check for IB split siblings
    // here, and propagate the AttributeChanged notification to
    // them, as well. Currently, inline frames don't do anything on
    // this notification, so it's not that big a deal.
  }

  // See if we can optimize away the style re-resolution -- must be called after
  // the frame's AttributeChanged() in case it does something that affects the style
  RestyleHintData rsdata;
  nsRestyleHint rshint =
    StyleSet()->HasAttributeDependentStyle(aElement,
                                           aNameSpaceID,
                                           aAttribute,
                                           aModType,
                                           true,
                                           aOldValue,
                                           rsdata);
  PostRestyleEvent(aElement, rshint, hint, &rsdata);
}

/* static */ uint64_t
RestyleManager::GetAnimationGenerationForFrame(nsIFrame* aFrame)
{
  EffectSet* effectSet = EffectSet::GetEffectSet(aFrame);
  return effectSet ? effectSet->GetAnimationGeneration() : 0;
}

void
RestyleManager::RestyleForEmptyChange(Element* aContainer)
{
  // In some cases (:empty + E, :empty ~ E), a change in the content of
  // an element requires restyling its parent's siblings.
  nsRestyleHint hint = eRestyle_Subtree;
  nsIContent* grandparent = aContainer->GetParent();
  if (grandparent &&
      (grandparent->GetFlags() & NODE_HAS_SLOW_SELECTOR_LATER_SIBLINGS)) {
    hint = nsRestyleHint(hint | eRestyle_LaterSiblings);
  }
  PostRestyleEvent(aContainer, hint, nsChangeHint(0));
}

void
RestyleManager::RestyleForAppend(nsIContent* aContainer,
                                 nsIContent* aFirstNewContent)
{
  // The container cannot be a document, but might be a ShadowRoot.
  if (!aContainer->IsElement()) {
    return;
  }
  Element* container = aContainer->AsElement();

#ifdef DEBUG
  {
    for (nsIContent* cur = aFirstNewContent; cur; cur = cur->GetNextSibling()) {
      NS_ASSERTION(!cur->IsRootOfAnonymousSubtree(),
                   "anonymous nodes should not be in child lists");
    }
  }
#endif
  uint32_t selectorFlags =
    container->GetFlags() & (NODE_ALL_SELECTOR_FLAGS &
                             ~NODE_HAS_SLOW_SELECTOR_LATER_SIBLINGS);
  if (selectorFlags == 0)
    return;

  if (selectorFlags & NODE_HAS_EMPTY_SELECTOR) {
    // see whether we need to restyle the container
    bool wasEmpty = true; // :empty or :-moz-only-whitespace
    for (nsIContent* cur = container->GetFirstChild();
         cur != aFirstNewContent;
         cur = cur->GetNextSibling()) {
      // We don't know whether we're testing :empty or :-moz-only-whitespace,
      // so be conservative and assume :-moz-only-whitespace (i.e., make
      // IsSignificantChild less likely to be true, and thus make us more
      // likely to restyle).
      if (nsStyleUtil::IsSignificantChild(cur, true, false)) {
        wasEmpty = false;
        break;
      }
    }
    if (wasEmpty) {
      RestyleForEmptyChange(container);
      return;
    }
  }

  if (selectorFlags & NODE_HAS_SLOW_SELECTOR) {
    PostRestyleEvent(container, eRestyle_Subtree, nsChangeHint(0));
    // Restyling the container is the most we can do here, so we're done.
    return;
  }

  if (selectorFlags & NODE_HAS_EDGE_CHILD_SELECTOR) {
    // restyle the last element child before this node
    for (nsIContent* cur = aFirstNewContent->GetPreviousSibling();
         cur;
         cur = cur->GetPreviousSibling()) {
      if (cur->IsElement()) {
        PostRestyleEvent(cur->AsElement(), eRestyle_Subtree, nsChangeHint(0));
        break;
      }
    }
  }
}

// Needed since we can't use PostRestyleEvent on non-elements (with
// eRestyle_LaterSiblings or nsRestyleHint(eRestyle_Subtree |
// eRestyle_LaterSiblings) as appropriate).
static void
RestyleSiblingsStartingWith(RestyleManager* aRestyleManager,
                            nsIContent* aStartingSibling /* may be null */)
{
  for (nsIContent* sibling = aStartingSibling; sibling;
       sibling = sibling->GetNextSibling()) {
    if (sibling->IsElement()) {
      aRestyleManager->
        PostRestyleEvent(sibling->AsElement(),
                         nsRestyleHint(eRestyle_Subtree | eRestyle_LaterSiblings),
                         nsChangeHint(0));
      break;
    }
  }
}

// Restyling for a ContentInserted or CharacterDataChanged notification.
// This could be used for ContentRemoved as well if we got the
// notification before the removal happened (and sometimes
// CharacterDataChanged is more like a removal than an addition).
// The comments are written and variables are named in terms of it being
// a ContentInserted notification.
void
RestyleManager::RestyleForInsertOrChange(nsINode* aContainer,
                                         nsIContent* aChild)
{
  // The container might be a document or a ShadowRoot.
  if (!aContainer->IsElement()) {
    return;
  }
  Element* container = aContainer->AsElement();

  NS_ASSERTION(!aChild->IsRootOfAnonymousSubtree(),
               "anonymous nodes should not be in child lists");
  uint32_t selectorFlags =
    container ? (container->GetFlags() & NODE_ALL_SELECTOR_FLAGS) : 0;
  if (selectorFlags == 0)
    return;

  if (selectorFlags & NODE_HAS_EMPTY_SELECTOR) {
    // see whether we need to restyle the container
    bool wasEmpty = true; // :empty or :-moz-only-whitespace
    for (nsIContent* child = container->GetFirstChild();
         child;
         child = child->GetNextSibling()) {
      if (child == aChild)
        continue;
      // We don't know whether we're testing :empty or :-moz-only-whitespace,
      // so be conservative and assume :-moz-only-whitespace (i.e., make
      // IsSignificantChild less likely to be true, and thus make us more
      // likely to restyle).
      if (nsStyleUtil::IsSignificantChild(child, true, false)) {
        wasEmpty = false;
        break;
      }
    }
    if (wasEmpty) {
      RestyleForEmptyChange(container);
      return;
    }
  }

  if (selectorFlags & NODE_HAS_SLOW_SELECTOR) {
    PostRestyleEvent(container, eRestyle_Subtree, nsChangeHint(0));
    // Restyling the container is the most we can do here, so we're done.
    return;
  }

  if (selectorFlags & NODE_HAS_SLOW_SELECTOR_LATER_SIBLINGS) {
    // Restyle all later siblings.
    RestyleSiblingsStartingWith(this, aChild->GetNextSibling());
  }

  if (selectorFlags & NODE_HAS_EDGE_CHILD_SELECTOR) {
    // restyle the previously-first element child if it is after this node
    bool passedChild = false;
    for (nsIContent* content = container->GetFirstChild();
         content;
         content = content->GetNextSibling()) {
      if (content == aChild) {
        passedChild = true;
        continue;
      }
      if (content->IsElement()) {
        if (passedChild) {
          PostRestyleEvent(content->AsElement(), eRestyle_Subtree,
                           nsChangeHint(0));
        }
        break;
      }
    }
    // restyle the previously-last element child if it is before this node
    passedChild = false;
    for (nsIContent* content = container->GetLastChild();
         content;
         content = content->GetPreviousSibling()) {
      if (content == aChild) {
        passedChild = true;
        continue;
      }
      if (content->IsElement()) {
        if (passedChild) {
          PostRestyleEvent(content->AsElement(), eRestyle_Subtree,
                           nsChangeHint(0));
        }
        break;
      }
    }
  }
}

void
RestyleManager::ContentRemoved(nsINode* aContainer,
                               nsIContent* aOldChild,
                               nsIContent* aFollowingSibling)
{
  // The container might be a document or a ShadowRoot.
  if (!aContainer->IsElement()) {
    return;
  }
  Element* container = aContainer->AsElement();

  if (aOldChild->IsRootOfAnonymousSubtree()) {
    // This should be an assert, but this is called incorrectly in
    // HTMLEditor::DeleteRefToAnonymousNode and the assertions were clogging
    // up the logs.  Make it an assert again when that's fixed.
    MOZ_ASSERT(aOldChild->GetProperty(nsGkAtoms::restylableAnonymousNode),
               "anonymous nodes should not be in child lists (bug 439258)");
  }
  uint32_t selectorFlags =
    container ? (container->GetFlags() & NODE_ALL_SELECTOR_FLAGS) : 0;
  if (selectorFlags == 0)
    return;

  if (selectorFlags & NODE_HAS_EMPTY_SELECTOR) {
    // see whether we need to restyle the container
    bool isEmpty = true; // :empty or :-moz-only-whitespace
    for (nsIContent* child = container->GetFirstChild();
         child;
         child = child->GetNextSibling()) {
      // We don't know whether we're testing :empty or :-moz-only-whitespace,
      // so be conservative and assume :-moz-only-whitespace (i.e., make
      // IsSignificantChild less likely to be true, and thus make us more
      // likely to restyle).
      if (nsStyleUtil::IsSignificantChild(child, true, false)) {
        isEmpty = false;
        break;
      }
    }
    if (isEmpty) {
      RestyleForEmptyChange(container);
      return;
    }
  }

  if (selectorFlags & NODE_HAS_SLOW_SELECTOR) {
    PostRestyleEvent(container, eRestyle_Subtree, nsChangeHint(0));
    // Restyling the container is the most we can do here, so we're done.
    return;
  }

  if (selectorFlags & NODE_HAS_SLOW_SELECTOR_LATER_SIBLINGS) {
    // Restyle all later siblings.
    RestyleSiblingsStartingWith(this, aFollowingSibling);
  }

  if (selectorFlags & NODE_HAS_EDGE_CHILD_SELECTOR) {
    // restyle the now-first element child if it was after aOldChild
    bool reachedFollowingSibling = false;
    for (nsIContent* content = container->GetFirstChild();
         content;
         content = content->GetNextSibling()) {
      if (content == aFollowingSibling) {
        reachedFollowingSibling = true;
        // do NOT continue here; we might want to restyle this node
      }
      if (content->IsElement()) {
        if (reachedFollowingSibling) {
          PostRestyleEvent(content->AsElement(), eRestyle_Subtree,
                           nsChangeHint(0));
        }
        break;
      }
    }
    // restyle the now-last element child if it was before aOldChild
    reachedFollowingSibling = (aFollowingSibling == nullptr);
    for (nsIContent* content = container->GetLastChild();
         content;
         content = content->GetPreviousSibling()) {
      if (content->IsElement()) {
        if (reachedFollowingSibling) {
          PostRestyleEvent(content->AsElement(), eRestyle_Subtree, nsChangeHint(0));
        }
        break;
      }
      if (content == aFollowingSibling) {
        reachedFollowingSibling = true;
      }
    }
  }
}

void
RestyleManager::RebuildAllStyleData(nsChangeHint aExtraHint,
                                    nsRestyleHint aRestyleHint)
{
  NS_ASSERTION(!(aExtraHint & nsChangeHint_ReconstructFrame),
               "Should not reconstruct the root of the frame tree.  "
               "Use ReconstructDocElementHierarchy instead.");
  MOZ_ASSERT(!(aRestyleHint & ~(eRestyle_Subtree | eRestyle_ForceDescendants)),
             "the only bits allowed in aRestyleHint are eRestyle_Subtree and "
             "eRestyle_ForceDescendants");

  mRebuildAllExtraHint |= aExtraHint;
  mRebuildAllRestyleHint |= aRestyleHint;

  // Processing the style changes could cause a flush that propagates to
  // the parent frame and thus destroys the pres shell, so we must hold
  // a reference.
  nsCOMPtr<nsIPresShell> presShell = PresContext()->GetPresShell();
  if (!presShell || !presShell->GetRootFrame()) {
    mDoRebuildAllStyleData = false;
    return;
  }

  // Make sure that the viewmanager will outlive the presshell
  RefPtr<nsViewManager> vm = presShell->GetViewManager();
  mozilla::Unused << vm; // Not used within this function

  // We may reconstruct frames below and hence process anything that is in the
  // tree. We don't want to get notified to process those items again after.
  presShell->GetDocument()->FlushPendingNotifications(Flush_ContentAndNotify);

  nsAutoScriptBlocker scriptBlocker;

  mDoRebuildAllStyleData = true;

  ProcessPendingRestyles();
}

void
RestyleManager::StartRebuildAllStyleData(RestyleTracker& aRestyleTracker)
{
  MOZ_ASSERT(mIsProcessingRestyles);

  nsIFrame* rootFrame = PresContext()->PresShell()->GetRootFrame();
  if (!rootFrame) {
    // No need to do anything.
    return;
  }

  mInRebuildAllStyleData = true;

  // Tell the style set to get the old rule tree out of the way
  // so we can recalculate while maintaining rule tree immutability
  nsresult rv = StyleSet()->BeginReconstruct();
  if (NS_FAILED(rv)) {
    MOZ_CRASH("unable to rebuild style data");
  }

  nsRestyleHint restyleHint = mRebuildAllRestyleHint;
  nsChangeHint changeHint = mRebuildAllExtraHint;
  mRebuildAllExtraHint = nsChangeHint(0);
  mRebuildAllRestyleHint = nsRestyleHint(0);

  restyleHint |= eRestyle_ForceDescendants;

  if (!(restyleHint & eRestyle_Subtree) &&
      (restyleHint & ~(eRestyle_Force | eRestyle_ForceDescendants))) {
    // We want this hint to apply to the root node's primary frame
    // rather than the root frame, since it's the primary frame that has
    // the styles for the root element (rather than the ancestors of the
    // primary frame whose mContent is the root node but which have
    // different styles).  If we use up the hint for one of the
    // ancestors that we hit first, then we'll fail to do the restyling
    // we need to do.
    Element* root = PresContext()->Document()->GetRootElement();
    if (root) {
      // If the root element is gone, dropping the hint on the floor
      // should be fine.
      aRestyleTracker.AddPendingRestyle(root, restyleHint, nsChangeHint(0));
    }
    restyleHint = nsRestyleHint(0);
  }

  // Recalculate all of the style contexts for the document, from the
  // root frame.  We can't do this with a change hint, since we can't
  // post a change hint for the root frame.
  // Note that we can ignore the return value of ComputeStyleChangeFor
  // because we never need to reframe the root frame.
  // XXX Does it matter that we're passing aExtraHint to the real root
  // frame and not the root node's primary frame?  (We could do
  // roughly what we do for aRestyleHint above.)
  ComputeAndProcessStyleChange(rootFrame,
                               changeHint, aRestyleTracker, restyleHint,
                               RestyleHintData());
}

void
RestyleManager::FinishRebuildAllStyleData()
{
  MOZ_ASSERT(mInRebuildAllStyleData, "bad caller");

  // Tell the style set it's safe to destroy the old rule tree.  We
  // must do this after the ProcessRestyledFrames call in case the
  // change list has frame reconstructs in it (since frames to be
  // reconstructed will still have their old style context pointers
  // until they are destroyed).
  StyleSet()->EndReconstruct();

  mInRebuildAllStyleData = false;
}

void
RestyleManager::ProcessPendingRestyles()
{
  NS_PRECONDITION(PresContext()->Document(), "No document?  Pshaw!");
  NS_PRECONDITION(!nsContentUtils::IsSafeToRunScript(),
                  "Missing a script blocker!");

  // First do any queued-up frame creation.  (We should really
  // merge this into the rest of the process, though; see bug 827239.)
  PresContext()->FrameConstructor()->CreateNeededFrames();

  // Process non-animation restyles...
  MOZ_ASSERT(!mIsProcessingRestyles,
             "Nesting calls to ProcessPendingRestyles?");
  mIsProcessingRestyles = true;

  // Before we process any restyles, we need to ensure that style
  // resulting from any animations is up-to-date, so that if any style
  // changes we cause trigger transitions, we have the correct old style
  // for starting the transition.
  bool haveNonAnimation =
    mHavePendingNonAnimationRestyles || mDoRebuildAllStyleData;
  if (haveNonAnimation) {
    ++mAnimationGeneration;
    UpdateOnlyAnimationStyles();
  } else {
    // If we don't have non-animation style updates, then we have queued
    // up animation style updates from the refresh driver tick.  This
    // doesn't necessarily include *all* animation style updates, since
    // we might be suppressing main-thread updates for some animations,
    // so we don't want to call UpdateOnlyAnimationStyles, which updates
    // all animations.  In other words, the work that we're about to do
    // to process the pending restyles queue is a *subset* of the work
    // that UpdateOnlyAnimationStyles would do, since we're *not*
    // updating transitions that are running on the compositor thread
    // and suppressed on the main thread.
    //
    // But when we update those styles, we want to suppress updates to
    // transitions just like we do in UpdateOnlyAnimationStyles.  So we
    // want to tell the transition manager to act as though we're in
    // UpdateOnlyAnimationStyles.
    //
    // FIXME: In the future, we might want to refactor the way the
    // animation and transition manager do their refresh driver ticks so
    // that we can use UpdateOnlyAnimationStyles, with a different
    // boolean argument, for this update as well, instead of having them
    // post style updates in their WillRefresh methods.
    PresContext()->TransitionManager()->SetInAnimationOnlyStyleUpdate(true);
  }

  ProcessRestyles(mPendingRestyles);

  if (!haveNonAnimation) {
    PresContext()->TransitionManager()->SetInAnimationOnlyStyleUpdate(false);
  }

  mIsProcessingRestyles = false;

  NS_ASSERTION(haveNonAnimation || !mHavePendingNonAnimationRestyles,
               "should not have added restyles");
  mHavePendingNonAnimationRestyles = false;

  if (mDoRebuildAllStyleData) {
    // We probably wasted a lot of work up above, but this seems safest
    // and it should be rarely used.
    // This might add us as a refresh observer again; that's ok.
    ProcessPendingRestyles();

    NS_ASSERTION(!mDoRebuildAllStyleData,
                 "repeatedly setting mDoRebuildAllStyleData?");
  }

  MOZ_ASSERT(!mInRebuildAllStyleData,
             "should have called FinishRebuildAllStyleData");
}

void
RestyleManager::BeginProcessingRestyles(RestyleTracker& aRestyleTracker)
{
  // Make sure to not rebuild quote or counter lists while we're
  // processing restyles
  PresContext()->FrameConstructor()->BeginUpdate();

  mInStyleRefresh = true;

  if (ShouldStartRebuildAllFor(aRestyleTracker)) {
    mDoRebuildAllStyleData = false;
    StartRebuildAllStyleData(aRestyleTracker);
  }
}

void
RestyleManager::EndProcessingRestyles()
{
  FlushOverflowChangedTracker();

  MOZ_ASSERT(mAnimationsWithDestroyedFrame);
  mAnimationsWithDestroyedFrame->
    StopAnimationsForElementsWithoutFrames();

  // Set mInStyleRefresh to false now, since the EndUpdate call might
  // add more restyles.
  mInStyleRefresh = false;

  if (mInRebuildAllStyleData) {
    FinishRebuildAllStyleData();
  }

  PresContext()->FrameConstructor()->EndUpdate();

#ifdef DEBUG
  PresContext()->PresShell()->VerifyStyleTree();
#endif
}

void
RestyleManager::UpdateOnlyAnimationStyles()
{
  bool doCSS = PresContext()->EffectCompositor()->HasPendingStyleUpdates();

  nsIDocument* document = PresContext()->Document();
  nsSMILAnimationController* animationController =
    document->HasAnimationController() ?
    document->GetAnimationController() :
    nullptr;
  bool doSMIL = animationController &&
                animationController->MightHavePendingStyleUpdates();

  if (!doCSS && !doSMIL) {
    return;
  }

  nsTransitionManager* transitionManager = PresContext()->TransitionManager();

  transitionManager->SetInAnimationOnlyStyleUpdate(true);

  RestyleTracker tracker(ELEMENT_HAS_PENDING_ANIMATION_ONLY_RESTYLE |
                         ELEMENT_IS_POTENTIAL_ANIMATION_ONLY_RESTYLE_ROOT);
  tracker.Init(this);

  if (doCSS) {
    // FIXME:  We should have the transition manager and animation manager
    // add only the elements for which animations are currently throttled
    // (i.e., animating on the compositor with main-thread style updates
    // suppressed).
    PresContext()->EffectCompositor()->AddStyleUpdatesTo(tracker);
  }

  if (doSMIL) {
    animationController->AddStyleUpdatesTo(tracker);
  }

  ProcessRestyles(tracker);

  transitionManager->SetInAnimationOnlyStyleUpdate(false);
}

void
RestyleManager::PostRestyleEvent(Element* aElement,
                                 nsRestyleHint aRestyleHint,
                                 nsChangeHint aMinChangeHint,
                                 const RestyleHintData* aRestyleHintData)
{
  if (MOZ_UNLIKELY(IsDisconnected()) ||
      MOZ_UNLIKELY(PresContext()->PresShell()->IsDestroying())) {
    return;
  }

  if (aRestyleHint == 0 && !aMinChangeHint) {
    // Nothing to do here
    return;
  }

  mPendingRestyles.AddPendingRestyle(aElement, aRestyleHint, aMinChangeHint,
                                     aRestyleHintData);

  // Set mHavePendingNonAnimationRestyles for any restyle that could
  // possibly contain non-animation styles (i.e., those that require us
  // to do an animation-only style flush before processing style changes
  // to ensure correct initialization of CSS transitions).
  if (aRestyleHint & ~eRestyle_AllHintsWithAnimations) {
    mHavePendingNonAnimationRestyles = true;
  }

  PostRestyleEventInternal(false);
}

void
RestyleManager::PostRebuildAllStyleDataEvent(nsChangeHint aExtraHint,
                                             nsRestyleHint aRestyleHint)
{
  NS_ASSERTION(!(aExtraHint & nsChangeHint_ReconstructFrame),
               "Should not reconstruct the root of the frame tree.  "
               "Use ReconstructDocElementHierarchy instead.");
  MOZ_ASSERT(!(aRestyleHint & eRestyle_SomeDescendants),
             "PostRebuildAllStyleDataEvent does not handle "
             "eRestyle_SomeDescendants");

  mDoRebuildAllStyleData = true;
  mRebuildAllExtraHint |= aExtraHint;
  mRebuildAllRestyleHint |= aRestyleHint;

  // Get a restyle event posted if necessary
  PostRestyleEventInternal(false);
}

// aContent must be the content for the frame in question, which may be
// :before/:after content
/* static */ bool
RestyleManager::TryInitiatingTransition(nsPresContext* aPresContext,
                                        nsIContent* aContent,
                                        nsStyleContext* aOldStyleContext,
                                        RefPtr<nsStyleContext>*
                                          aNewStyleContext /* inout */)
{
  if (!aContent || !aContent->IsElement()) {
    return false;
  }

  // Notify the transition manager.  If it starts a transition,
  // it might modify the new style context.
  RefPtr<nsStyleContext> sc = *aNewStyleContext;
  aPresContext->TransitionManager()->StyleContextChanged(
    aContent->AsElement(), aOldStyleContext, aNewStyleContext);
  return *aNewStyleContext != sc;
}

static dom::Element*
ElementForStyleContext(nsIContent* aParentContent,
                       nsIFrame* aFrame,
                       CSSPseudoElementType aPseudoType)
{
  // We don't expect XUL tree stuff here.
  NS_PRECONDITION(aPseudoType == CSSPseudoElementType::NotPseudo ||
                  aPseudoType == CSSPseudoElementType::AnonBox ||
                  aPseudoType < CSSPseudoElementType::Count,
                  "Unexpected pseudo");
  // XXX see the comments about the various element confusion in
  // ElementRestyler::Restyle.
  if (aPseudoType == CSSPseudoElementType::NotPseudo) {
    return aFrame->GetContent()->AsElement();
  }

  if (aPseudoType == CSSPseudoElementType::AnonBox) {
    return nullptr;
  }

  if (aPseudoType == CSSPseudoElementType::firstLetter) {
    NS_ASSERTION(aFrame->GetType() == nsGkAtoms::letterFrame,
                 "firstLetter pseudoTag without a nsFirstLetterFrame");
    nsBlockFrame* block = nsBlockFrame::GetNearestAncestorBlock(aFrame);
    return block->GetContent()->AsElement();
  }

  if (aPseudoType == CSSPseudoElementType::mozColorSwatch) {
    MOZ_ASSERT(aFrame->GetParent() &&
               aFrame->GetParent()->GetParent(),
               "Color swatch frame should have a parent & grandparent");

    nsIFrame* grandparentFrame = aFrame->GetParent()->GetParent();
    MOZ_ASSERT(grandparentFrame->GetType() == nsGkAtoms::colorControlFrame,
               "Color swatch's grandparent should be nsColorControlFrame");

    return grandparentFrame->GetContent()->AsElement();
  }

  if (aPseudoType == CSSPseudoElementType::mozNumberText ||
      aPseudoType == CSSPseudoElementType::mozNumberWrapper ||
      aPseudoType == CSSPseudoElementType::mozNumberSpinBox ||
      aPseudoType == CSSPseudoElementType::mozNumberSpinUp ||
      aPseudoType == CSSPseudoElementType::mozNumberSpinDown) {
    // Get content for nearest nsNumberControlFrame:
    nsIFrame* f = aFrame->GetParent();
    MOZ_ASSERT(f);
    while (f->GetType() != nsGkAtoms::numberControlFrame) {
      f = f->GetParent();
      MOZ_ASSERT(f);
    }
    return f->GetContent()->AsElement();
  }

  if (aParentContent) {
    return aParentContent->AsElement();
  }

  MOZ_ASSERT(aFrame->GetContent()->GetParent(),
             "should not have got here for the root element");
  return aFrame->GetContent()->GetParent()->AsElement();
}

/**
 * Some pseudo-elements actually have a content node created for them,
 * whereas others have only a frame but not a content node.  In some
 * cases, we want to support style attributes or states on those
 * elements.  For those pseudo-elements, we need to pass the
 * anonymous pseudo-element content to selector matching processes in
 * addition to the element that the pseudo-element is for; in other
 * cases we should pass null instead.  This function returns the
 * pseudo-element content that we should pass.
 */
static dom::Element*
PseudoElementForStyleContext(nsIFrame* aFrame,
                             CSSPseudoElementType aPseudoType)
{
  if (aPseudoType >= CSSPseudoElementType::Count) {
    return nullptr;
  }

  if (nsCSSPseudoElements::PseudoElementSupportsStyleAttribute(aPseudoType) ||
      nsCSSPseudoElements::PseudoElementSupportsUserActionState(aPseudoType)) {
    return aFrame->GetContent()->AsElement();
  }

  return nullptr;
}

/**
 * FIXME: Temporary.  Should merge with following function.
 */
static nsIFrame*
GetPrevContinuationWithPossiblySameStyle(nsIFrame* aFrame)
{
  // Account for {ib} splits when looking for "prevContinuation".  In
  // particular, for the first-continuation of a part of an {ib} split
  // we want to use the previous ib-split sibling of the previous
  // ib-split sibling of aFrame, which should have the same style
  // context as aFrame itself.  In particular, if aFrame is the first
  // continuation of an inline part of a block-in-inline split then its
  // previous ib-split sibling is a block, and the previous ib-split
  // sibling of _that_ is an inline, just like aFrame.  Similarly, if
  // aFrame is the first continuation of a block part of an
  // block-in-inline split (a block-in-inline wrapper block), then its
  // previous ib-split sibling is an inline and the previous ib-split
  // sibling of that is either another block-in-inline wrapper block box
  // or null.
  nsIFrame* prevContinuation = aFrame->GetPrevContinuation();
  if (!prevContinuation &&
      (aFrame->GetStateBits() & NS_FRAME_PART_OF_IBSPLIT)) {
    // We're the first continuation, so we can just get the frame
    // property directly
    prevContinuation =
      aFrame->Properties().Get(nsIFrame::IBSplitPrevSibling());
    if (prevContinuation) {
      prevContinuation =
        prevContinuation->Properties().Get(nsIFrame::IBSplitPrevSibling());
    }
  }

  NS_ASSERTION(!prevContinuation ||
               prevContinuation->GetContent() == aFrame->GetContent(),
               "unexpected content mismatch");

  return prevContinuation;
}

/**
 * Get the previous continuation or similar ib-split sibling (assuming
 * block/inline alternation), conditionally on it having the same style.
 * This assumes that we're not between resolving the two (i.e., that
 * they're both already resolved.
 */
static nsIFrame*
GetPrevContinuationWithSameStyle(nsIFrame* aFrame)
{
  nsIFrame* prevContinuation = GetPrevContinuationWithPossiblySameStyle(aFrame);
  if (!prevContinuation) {
    return nullptr;
  }

  nsStyleContext* prevStyle = prevContinuation->StyleContext();
  nsStyleContext* selfStyle = aFrame->StyleContext();
  if (prevStyle != selfStyle) {
    NS_ASSERTION(prevStyle->GetPseudo() != selfStyle->GetPseudo() ||
                 prevStyle->GetParent() != selfStyle->GetParent(),
                 "continuations should have the same style context");
    prevContinuation = nullptr;
  }
  return prevContinuation;
}

nsresult
RestyleManager::ReparentStyleContext(nsIFrame* aFrame)
{
  nsIAtom* frameType = aFrame->GetType();
  if (frameType == nsGkAtoms::placeholderFrame) {
    // Also reparent the out-of-flow and all its continuations.
    nsIFrame* outOfFlow =
      nsPlaceholderFrame::GetRealFrameForPlaceholder(aFrame);
    NS_ASSERTION(outOfFlow, "no out-of-flow frame");
    do {
      ReparentStyleContext(outOfFlow);
    } while ((outOfFlow = outOfFlow->GetNextContinuation()));
  } else if (frameType == nsGkAtoms::backdropFrame) {
    // Style context of backdrop frame has no parent style context, and
    // thus we do not need to reparent it.
    return NS_OK;
  }

  // DO NOT verify the style tree before reparenting.  The frame
  // tree has already been changed, so this check would just fail.
  nsStyleContext* oldContext = aFrame->StyleContext();

  RefPtr<nsStyleContext> newContext;
  nsIFrame* providerFrame;
  nsStyleContext* newParentContext = aFrame->GetParentStyleContext(&providerFrame);
  bool isChild = providerFrame && providerFrame->GetParent() == aFrame;
  nsIFrame* providerChild = nullptr;
  if (isChild) {
    ReparentStyleContext(providerFrame);
    // Get the style context again after ReparentStyleContext() which might have
    // changed it.
    newParentContext = providerFrame->StyleContext();
    providerChild = providerFrame;
  }
  NS_ASSERTION(newParentContext, "Reparenting something that has no usable"
               " parent? Shouldn't happen!");
  // XXX need to do something here to produce the correct style context for
  // an IB split whose first inline part is inside a first-line frame.
  // Currently the first IB anonymous block's style context takes the first
  // part's style context as parent, which is wrong since first-line style
  // should not apply to the anonymous block.

#ifdef DEBUG
  {
    // Check that our assumption that continuations of the same
    // pseudo-type and with the same style context parent have the
    // same style context is valid before the reresolution.  (We need
    // to check the pseudo-type and style context parent because of
    // :first-letter and :first-line, where we create styled and
    // unstyled letter/line frames distinguished by pseudo-type, and
    // then need to distinguish their descendants based on having
    // different parents.)
    nsIFrame* nextContinuation = aFrame->GetNextContinuation();
    if (nextContinuation) {
      nsStyleContext* nextContinuationContext =
        nextContinuation->StyleContext();
      NS_ASSERTION(oldContext == nextContinuationContext ||
                   oldContext->GetPseudo() !=
                     nextContinuationContext->GetPseudo() ||
                   oldContext->GetParent() !=
                     nextContinuationContext->GetParent(),
                   "continuations should have the same style context");
    }
  }
#endif

  nsIFrame* prevContinuation =
    GetPrevContinuationWithPossiblySameStyle(aFrame);
  nsStyleContext* prevContinuationContext;
  bool copyFromContinuation =
    prevContinuation &&
    (prevContinuationContext = prevContinuation->StyleContext())
      ->GetPseudo() == oldContext->GetPseudo() &&
     prevContinuationContext->GetParent() == newParentContext;
  if (copyFromContinuation) {
    // Just use the style context from the frame's previous
    // continuation (see assertion about aFrame->GetNextContinuation()
    // above, which we would have previously hit for aFrame's previous
    // continuation).
    newContext = prevContinuationContext;
  } else {
    nsIFrame* parentFrame = aFrame->GetParent();
    Element* element =
      ElementForStyleContext(parentFrame ? parentFrame->GetContent() : nullptr,
                             aFrame,
                             oldContext->GetPseudoType());
    newContext = StyleSet()->
                   ReparentStyleContext(oldContext, newParentContext, element);
  }

  if (newContext) {
    if (newContext != oldContext) {
      // We probably don't want to initiate transitions from
      // ReparentStyleContext, since we call it during frame
      // construction rather than in response to dynamic changes.
      // Also see the comment at the start of
      // nsTransitionManager::ConsiderInitiatingTransition.
#if 0
      if (!copyFromContinuation) {
        TryInitiatingTransition(mPresContext, aFrame->GetContent(),
                                oldContext, &newContext);
      }
#endif

      // Make sure to call CalcStyleDifference so that the new context ends
      // up resolving all the structs the old context resolved.
      if (!copyFromContinuation) {
        uint32_t equalStructs;
        uint32_t samePointerStructs;
        DebugOnly<nsChangeHint> styleChange =
          oldContext->CalcStyleDifference(newContext, nsChangeHint(0),
                                          &equalStructs,
                                          &samePointerStructs);
        // The style change is always 0 because we have the same rulenode and
        // CalcStyleDifference optimizes us away.  That's OK, though:
        // reparenting should never trigger a frame reconstruct, and whenever
        // it's happening we already plan to reflow and repaint the frames.
        NS_ASSERTION(!(styleChange & nsChangeHint_ReconstructFrame),
                     "Our frame tree is likely to be bogus!");
      }

      aFrame->SetStyleContext(newContext);

      nsIFrame::ChildListIterator lists(aFrame);
      for (; !lists.IsDone(); lists.Next()) {
        for (nsIFrame* child : lists.CurrentList()) {
          // only do frames that are in flow
          if (!(child->GetStateBits() & NS_FRAME_OUT_OF_FLOW) &&
              child != providerChild) {
#ifdef DEBUG
            if (nsGkAtoms::placeholderFrame == child->GetType()) {
              nsIFrame* outOfFlowFrame =
                nsPlaceholderFrame::GetRealFrameForPlaceholder(child);
              NS_ASSERTION(outOfFlowFrame, "no out-of-flow frame");

              NS_ASSERTION(outOfFlowFrame != providerChild,
                           "Out of flow provider?");
            }
#endif
            ReparentStyleContext(child);
          }
        }
      }

      // If this frame is part of an IB split, then the style context of
      // the next part of the split might be a child of our style context.
      // Reparent its style context just in case one of our ancestors
      // (split or not) hasn't done so already). It's not a problem to
      // reparent the same frame twice because the "if (newContext !=
      // oldContext)" check will prevent us from redoing work.
      if ((aFrame->GetStateBits() & NS_FRAME_PART_OF_IBSPLIT) &&
          !aFrame->GetPrevContinuation()) {
        nsIFrame* sib =
          aFrame->Properties().Get(nsIFrame::IBSplitSibling());
        if (sib) {
          ReparentStyleContext(sib);
        }
      }

      // do additional contexts
      int32_t contextIndex = 0;
      for (nsStyleContext* oldExtraContext;
           (oldExtraContext = aFrame->GetAdditionalStyleContext(contextIndex));
           ++contextIndex) {
        RefPtr<nsStyleContext> newExtraContext;
        newExtraContext = StyleSet()->
                            ReparentStyleContext(oldExtraContext,
                                                 newContext, nullptr);
        if (newExtraContext) {
          if (newExtraContext != oldExtraContext) {
            // Make sure to call CalcStyleDifference so that the new
            // context ends up resolving all the structs the old context
            // resolved.
            uint32_t equalStructs;
            uint32_t samePointerStructs;
            DebugOnly<nsChangeHint> styleChange =
              oldExtraContext->CalcStyleDifference(newExtraContext,
                                                   nsChangeHint(0),
                                                   &equalStructs,
                                                   &samePointerStructs);
            // The style change is always 0 because we have the same
            // rulenode and CalcStyleDifference optimizes us away.  That's
            // OK, though: reparenting should never trigger a frame
            // reconstruct, and whenever it's happening we already plan to
            // reflow and repaint the frames.
            NS_ASSERTION(!(styleChange & nsChangeHint_ReconstructFrame),
                         "Our frame tree is likely to be bogus!");
          }

          aFrame->SetAdditionalStyleContext(contextIndex, newExtraContext);
        }
      }
#ifdef DEBUG
      DebugVerifyStyleTree(aFrame);
#endif
    }
  }

  return NS_OK;
}

ElementRestyler::ElementRestyler(nsPresContext* aPresContext,
                                 nsIFrame* aFrame,
                                 nsStyleChangeList* aChangeList,
                                 nsChangeHint aHintsHandledByAncestors,
                                 RestyleTracker& aRestyleTracker,
                                 nsTArray<nsCSSSelector*>&
                                   aSelectorsForDescendants,
                                 TreeMatchContext& aTreeMatchContext,
                                 nsTArray<nsIContent*>&
                                   aVisibleKidsOfHiddenElement,
                                 nsTArray<ContextToClear>& aContextsToClear,
                                 nsTArray<RefPtr<nsStyleContext>>&
                                   aSwappedStructOwners)
  : mPresContext(aPresContext)
  , mFrame(aFrame)
  , mParentContent(nullptr)
    // XXXldb Why does it make sense to use aParentContent?  (See
    // comment above assertion at start of ElementRestyler::Restyle.)
  , mContent(mFrame->GetContent() ? mFrame->GetContent() : mParentContent)
  , mChangeList(aChangeList)
  , mHintsHandled(aHintsHandledByAncestors &
                  ~NS_HintsNotHandledForDescendantsIn(aHintsHandledByAncestors))
  , mParentFrameHintsNotHandledForDescendants(nsChangeHint(0))
  , mHintsNotHandledForDescendants(nsChangeHint(0))
  , mRestyleTracker(aRestyleTracker)
  , mSelectorsForDescendants(aSelectorsForDescendants)
  , mTreeMatchContext(aTreeMatchContext)
  , mResolvedChild(nullptr)
  , mContextsToClear(aContextsToClear)
  , mSwappedStructOwners(aSwappedStructOwners)
  , mIsRootOfRestyle(true)
#ifdef ACCESSIBILITY
  , mDesiredA11yNotifications(eSendAllNotifications)
  , mKidsDesiredA11yNotifications(mDesiredA11yNotifications)
  , mOurA11yNotification(eDontNotify)
  , mVisibleKidsOfHiddenElement(aVisibleKidsOfHiddenElement)
#endif
#ifdef RESTYLE_LOGGING
  , mLoggingDepth(aRestyleTracker.LoggingDepth() + 1)
#endif
{
  MOZ_ASSERT_IF(mContent, !mContent->IsStyledByServo());
}

ElementRestyler::ElementRestyler(const ElementRestyler& aParentRestyler,
                                 nsIFrame* aFrame,
                                 uint32_t aConstructorFlags)
  : mPresContext(aParentRestyler.mPresContext)
  , mFrame(aFrame)
  , mParentContent(aParentRestyler.mContent)
    // XXXldb Why does it make sense to use aParentContent?  (See
    // comment above assertion at start of ElementRestyler::Restyle.)
  , mContent(mFrame->GetContent() ? mFrame->GetContent() : mParentContent)
  , mChangeList(aParentRestyler.mChangeList)
  , mHintsHandled(aParentRestyler.mHintsHandled &
                  ~NS_HintsNotHandledForDescendantsIn(aParentRestyler.mHintsHandled))
  , mParentFrameHintsNotHandledForDescendants(
      aParentRestyler.mHintsNotHandledForDescendants)
  , mHintsNotHandledForDescendants(nsChangeHint(0))
  , mRestyleTracker(aParentRestyler.mRestyleTracker)
  , mSelectorsForDescendants(aParentRestyler.mSelectorsForDescendants)
  , mTreeMatchContext(aParentRestyler.mTreeMatchContext)
  , mResolvedChild(nullptr)
  , mContextsToClear(aParentRestyler.mContextsToClear)
  , mSwappedStructOwners(aParentRestyler.mSwappedStructOwners)
  , mIsRootOfRestyle(false)
#ifdef ACCESSIBILITY
  , mDesiredA11yNotifications(aParentRestyler.mKidsDesiredA11yNotifications)
  , mKidsDesiredA11yNotifications(mDesiredA11yNotifications)
  , mOurA11yNotification(eDontNotify)
  , mVisibleKidsOfHiddenElement(aParentRestyler.mVisibleKidsOfHiddenElement)
#endif
#ifdef RESTYLE_LOGGING
  , mLoggingDepth(aParentRestyler.mLoggingDepth + 1)
#endif
{
  MOZ_ASSERT_IF(mContent, !mContent->IsStyledByServo());
  if (aConstructorFlags & FOR_OUT_OF_FLOW_CHILD) {
    // Note that the out-of-flow may not be a geometric descendant of
    // the frame where we started the reresolve.  Therefore, even if
    // mHintsHandled already includes nsChangeHint_AllReflowHints we
    // don't want to pass that on to the out-of-flow reresolve, since
    // that can lead to the out-of-flow not getting reflowed when it
    // should be (eg a reresolve starting at <body> that involves
    // reflowing the <body> would miss reflowing fixed-pos nodes that
    // also need reflow).  In the cases when the out-of-flow _is_ a
    // geometric descendant of a frame we already have a reflow hint
    // for, reflow coalescing should keep us from doing the work twice.
    mHintsHandled &= ~nsChangeHint_AllReflowHints;
  }
}

ElementRestyler::ElementRestyler(ParentContextFromChildFrame,
                                 const ElementRestyler& aParentRestyler,
                                 nsIFrame* aFrame)
  : mPresContext(aParentRestyler.mPresContext)
  , mFrame(aFrame)
  , mParentContent(aParentRestyler.mParentContent)
    // XXXldb Why does it make sense to use aParentContent?  (See
    // comment above assertion at start of ElementRestyler::Restyle.)
  , mContent(mFrame->GetContent() ? mFrame->GetContent() : mParentContent)
  , mChangeList(aParentRestyler.mChangeList)
  , mHintsHandled(aParentRestyler.mHintsHandled &
                  ~NS_HintsNotHandledForDescendantsIn(aParentRestyler.mHintsHandled))
  , mParentFrameHintsNotHandledForDescendants(
      // assume the worst
      nsChangeHint_Hints_NotHandledForDescendants)
  , mHintsNotHandledForDescendants(nsChangeHint(0))
  , mRestyleTracker(aParentRestyler.mRestyleTracker)
  , mSelectorsForDescendants(aParentRestyler.mSelectorsForDescendants)
  , mTreeMatchContext(aParentRestyler.mTreeMatchContext)
  , mResolvedChild(nullptr)
  , mContextsToClear(aParentRestyler.mContextsToClear)
  , mSwappedStructOwners(aParentRestyler.mSwappedStructOwners)
  , mIsRootOfRestyle(false)
#ifdef ACCESSIBILITY
  , mDesiredA11yNotifications(aParentRestyler.mDesiredA11yNotifications)
  , mKidsDesiredA11yNotifications(mDesiredA11yNotifications)
  , mOurA11yNotification(eDontNotify)
  , mVisibleKidsOfHiddenElement(aParentRestyler.mVisibleKidsOfHiddenElement)
#endif
#ifdef RESTYLE_LOGGING
  , mLoggingDepth(aParentRestyler.mLoggingDepth + 1)
#endif
{
  MOZ_ASSERT_IF(mContent, !mContent->IsStyledByServo());
}

ElementRestyler::ElementRestyler(nsPresContext* aPresContext,
                                 nsIContent* aContent,
                                 nsStyleChangeList* aChangeList,
                                 nsChangeHint aHintsHandledByAncestors,
                                 RestyleTracker& aRestyleTracker,
                                 nsTArray<nsCSSSelector*>& aSelectorsForDescendants,
                                 TreeMatchContext& aTreeMatchContext,
                                 nsTArray<nsIContent*>&
                                   aVisibleKidsOfHiddenElement,
                                 nsTArray<ContextToClear>& aContextsToClear,
                                 nsTArray<RefPtr<nsStyleContext>>&
                                   aSwappedStructOwners)
  : mPresContext(aPresContext)
  , mFrame(nullptr)
  , mParentContent(nullptr)
  , mContent(aContent)
  , mChangeList(aChangeList)
  , mHintsHandled(aHintsHandledByAncestors &
                  ~NS_HintsNotHandledForDescendantsIn(aHintsHandledByAncestors))
  , mParentFrameHintsNotHandledForDescendants(nsChangeHint(0))
  , mHintsNotHandledForDescendants(nsChangeHint(0))
  , mRestyleTracker(aRestyleTracker)
  , mSelectorsForDescendants(aSelectorsForDescendants)
  , mTreeMatchContext(aTreeMatchContext)
  , mResolvedChild(nullptr)
  , mContextsToClear(aContextsToClear)
  , mSwappedStructOwners(aSwappedStructOwners)
  , mIsRootOfRestyle(true)
#ifdef ACCESSIBILITY
  , mDesiredA11yNotifications(eSendAllNotifications)
  , mKidsDesiredA11yNotifications(mDesiredA11yNotifications)
  , mOurA11yNotification(eDontNotify)
  , mVisibleKidsOfHiddenElement(aVisibleKidsOfHiddenElement)
#endif
{
}

void
ElementRestyler::AddLayerChangesForAnimation()
{
  uint64_t frameGeneration =
    RestyleManager::GetAnimationGenerationForFrame(mFrame);

  nsChangeHint hint = nsChangeHint(0);
  for (const LayerAnimationInfo::Record& layerInfo :
         LayerAnimationInfo::sRecords) {
    Layer* layer =
      FrameLayerBuilder::GetDedicatedLayer(mFrame, layerInfo.mLayerType);
    if (layer && frameGeneration != layer->GetAnimationGeneration()) {
      // If we have a transform layer but don't have any transform style, we
      // probably just removed the transform but haven't destroyed the layer
      // yet. In this case we will add the appropriate change hint
      // (nsChangeHint_UpdateContainingBlock) when we compare style contexts
      // so we can skip adding any change hint here. (If we *were* to add
      // nsChangeHint_UpdateTransformLayer, ApplyRenderingChangeToTree would
      // complain that we're updating a transform layer without a transform).
      if (layerInfo.mLayerType == nsDisplayItem::TYPE_TRANSFORM &&
          !mFrame->StyleDisplay()->HasTransformStyle()) {
        continue;
      }
      hint |= layerInfo.mChangeHint;
    }

    // We consider it's the first paint for the frame if we have an animation
    // for the property but have no layer.
    // Note that in case of animations which has properties preventing running
    // on the compositor, e.g., width or height, corresponding layer is not
    // created at all, but even in such cases, we normally set valid change
    // hint for such animations in each tick, i.e. restyles in each tick. As
    // a result, we usually do restyles for such animations in every tick on
    // the main-thread.  The only animations which will be affected by this
    // explicit change hint are animations that have opacity/transform but did
    // not have those properies just before. e.g,  setting transform by
    // setKeyframes or changing target element from other target which prevents
    // running on the compositor, etc.
    if (!layer &&
        nsLayoutUtils::HasEffectiveAnimation(mFrame, layerInfo.mProperty)) {
      hint |= layerInfo.mChangeHint;
    }
  }
  if (hint) {
    mChangeList->AppendChange(mFrame, mContent, hint);
  }
}

void
ElementRestyler::CaptureChange(nsStyleContext* aOldContext,
                               nsStyleContext* aNewContext,
                               nsChangeHint aChangeToAssume,
                               uint32_t* aEqualStructs,
                               uint32_t* aSamePointerStructs)
{
  static_assert(nsStyleStructID_Length <= 32,
                "aEqualStructs is not big enough");

  // Check some invariants about replacing one style context with another.
  NS_ASSERTION(aOldContext->GetPseudo() == aNewContext->GetPseudo(),
               "old and new style contexts should have the same pseudo");
  NS_ASSERTION(aOldContext->GetPseudoType() == aNewContext->GetPseudoType(),
               "old and new style contexts should have the same pseudo");

  nsChangeHint ourChange =
    aOldContext->CalcStyleDifference(aNewContext,
                                     mParentFrameHintsNotHandledForDescendants,
                                     aEqualStructs,
                                     aSamePointerStructs);
  NS_ASSERTION(!(ourChange & nsChangeHint_AllReflowHints) ||
               (ourChange & nsChangeHint_NeedReflow),
               "Reflow hint bits set without actually asking for a reflow");

  LOG_RESTYLE("CaptureChange, ourChange = %s, aChangeToAssume = %s",
              RestyleManager::ChangeHintToString(ourChange).get(),
              RestyleManager::ChangeHintToString(aChangeToAssume).get());
  LOG_RESTYLE_INDENT();

  // nsChangeHint_UpdateEffects is inherited, but it can be set due to changes
  // in inherited properties (fill and stroke).  Avoid propagating it into
  // text nodes.
  if ((ourChange & nsChangeHint_UpdateEffects) &&
      mContent && !mContent->IsElement()) {
    ourChange &= ~nsChangeHint_UpdateEffects;
  }

  ourChange |= aChangeToAssume;
  if (!NS_IsHintSubset(ourChange, mHintsHandled)) {
    mHintsHandled |= ourChange;
    if (!(ourChange & nsChangeHint_ReconstructFrame) || mContent) {
      LOG_RESTYLE("appending change %s",
                  RestyleManager::ChangeHintToString(ourChange).get());
      mChangeList->AppendChange(mFrame, mContent, ourChange);
    } else {
      LOG_RESTYLE("change has already been handled");
    }
  }
  mHintsNotHandledForDescendants |=
    NS_HintsNotHandledForDescendantsIn(ourChange);
  LOG_RESTYLE("mHintsNotHandledForDescendants = %s",
              RestyleManager::ChangeHintToString(mHintsNotHandledForDescendants).get());
}

class MOZ_RAII AutoSelectorArrayTruncater final
{
public:
  explicit AutoSelectorArrayTruncater(
        nsTArray<nsCSSSelector*>& aSelectorsForDescendants)
    : mSelectorsForDescendants(aSelectorsForDescendants)
    , mOriginalLength(aSelectorsForDescendants.Length())
  {
  }

  ~AutoSelectorArrayTruncater()
  {
    mSelectorsForDescendants.TruncateLength(mOriginalLength);
  }

private:
  nsTArray<nsCSSSelector*>& mSelectorsForDescendants;
  size_t mOriginalLength;
};

/**
 * Called when we are stopping a restyle with eRestyle_SomeDescendants, to
 * search for descendants that match any of the selectors in
 * mSelectorsForDescendants.  If the element does match one of the selectors,
 * we cause it to be restyled with eRestyle_Self.
 *
 * We traverse down the frame tree (and through the flattened content tree
 * when we find undisplayed content) unless we find an element that (a) already
 * has a pending restyle, or (b) does not have a pending restyle but does match
 * one of the selectors in mSelectorsForDescendants.  For (a), we add the
 * current mSelectorsForDescendants into the existing restyle data, and for (b)
 * we add a new pending restyle with that array.  So in both cases, when we
 * come to restyling this element back up in ProcessPendingRestyles, we will
 * again find the eRestyle_SomeDescendants hint and its selectors array.
 *
 * This ensures that we don't visit descendant elements and check them
 * against mSelectorsForDescendants more than once.
 */
void
ElementRestyler::ConditionallyRestyleChildren()
{
  MOZ_ASSERT(mContent == mFrame->GetContent());

  if (!mContent->IsElement() || mSelectorsForDescendants.IsEmpty()) {
    return;
  }

  Element* element = mContent->AsElement();

  LOG_RESTYLE("traversing descendants of frame %s (with element %s) to "
              "propagate eRestyle_SomeDescendants for these %d selectors:",
              FrameTagToString(mFrame).get(),
              ElementTagToString(element).get(),
              int(mSelectorsForDescendants.Length()));
  LOG_RESTYLE_INDENT();
#ifdef RESTYLE_LOGGING
  for (nsCSSSelector* sel : mSelectorsForDescendants) {
    LOG_RESTYLE("%s", sel->RestrictedSelectorToString().get());
  }
#endif

  Element* restyleRoot = mRestyleTracker.FindClosestRestyleRoot(element);
  ConditionallyRestyleChildren(mFrame, restyleRoot);
}

void
ElementRestyler::ConditionallyRestyleChildren(nsIFrame* aFrame,
                                              Element* aRestyleRoot)
{
  MOZ_ASSERT(aFrame->GetContent());
  MOZ_ASSERT(aFrame->GetContent()->IsElement());
  MOZ_ASSERT(!aFrame->GetContent()->IsStyledByServo());

  ConditionallyRestyleUndisplayedDescendants(aFrame, aRestyleRoot);
  ConditionallyRestyleContentChildren(aFrame, aRestyleRoot);
}

// The structure of this method parallels RestyleContentChildren.
// If you update this method, you probably want to update that one too.
void
ElementRestyler::ConditionallyRestyleContentChildren(nsIFrame* aFrame,
                                                     Element* aRestyleRoot)
{
  MOZ_ASSERT(aFrame->GetContent());
  MOZ_ASSERT(aFrame->GetContent()->IsElement());
  MOZ_ASSERT(!aFrame->GetContent()->IsStyledByServo());

  if (aFrame->GetContent()->HasFlag(mRestyleTracker.RootBit())) {
    aRestyleRoot = aFrame->GetContent()->AsElement();
  }

  for (nsIFrame* f = aFrame; f;
       f = RestyleManager::GetNextContinuationWithSameStyle(f, f->StyleContext())) {
    nsIFrame::ChildListIterator lists(f);
    for (; !lists.IsDone(); lists.Next()) {
      for (nsIFrame* child : lists.CurrentList()) {
        // Out-of-flows are reached through their placeholders.  Continuations
        // and block-in-inline splits are reached through those chains.
        if (!(child->GetStateBits() & NS_FRAME_OUT_OF_FLOW) &&
            !GetPrevContinuationWithSameStyle(child)) {
          // only do frames that are in flow
          if (child->GetType() == nsGkAtoms::placeholderFrame) { // placeholder
            // get out of flow frame and recur there
            nsIFrame* outOfFlowFrame =
              nsPlaceholderFrame::GetRealFrameForPlaceholder(child);

            // |nsFrame::GetParentStyleContext| checks being out
            // of flow so that this works correctly.
            do {
              if (GetPrevContinuationWithSameStyle(outOfFlowFrame)) {
                continue;
              }
              if (!ConditionallyRestyle(outOfFlowFrame, aRestyleRoot)) {
                ConditionallyRestyleChildren(outOfFlowFrame, aRestyleRoot);
              }
            } while ((outOfFlowFrame = outOfFlowFrame->GetNextContinuation()));
          } else {  // regular child frame
            if (child != mResolvedChild) {
              if (!ConditionallyRestyle(child, aRestyleRoot)) {
                ConditionallyRestyleChildren(child, aRestyleRoot);
              }
            }
          }
        }
      }
    }
  }
}

// The structure of this method parallels RestyleUndisplayedDescendants.
// If you update this method, you probably want to update that one too.
void
ElementRestyler::ConditionallyRestyleUndisplayedDescendants(
    nsIFrame* aFrame,
    Element* aRestyleRoot)
{
  nsIContent* undisplayedParent;
  if (MustCheckUndisplayedContent(aFrame, undisplayedParent)) {
    DoConditionallyRestyleUndisplayedDescendants(undisplayedParent,
                                                 aRestyleRoot);
  }
}

// The structure of this method parallels DoRestyleUndisplayedDescendants.
// If you update this method, you probably want to update that one too.
void
ElementRestyler::DoConditionallyRestyleUndisplayedDescendants(
    nsIContent* aParent,
    Element* aRestyleRoot)
{
  nsCSSFrameConstructor* fc = mPresContext->FrameConstructor();
  UndisplayedNode* nodes = fc->GetAllUndisplayedContentIn(aParent);
  ConditionallyRestyleUndisplayedNodes(nodes, aParent,
                                       StyleDisplay::None, aRestyleRoot);
  nodes = fc->GetAllDisplayContentsIn(aParent);
  ConditionallyRestyleUndisplayedNodes(nodes, aParent,
                                       StyleDisplay::Contents, aRestyleRoot);
}

// The structure of this method parallels RestyleUndisplayedNodes.
// If you update this method, you probably want to update that one too.
void
ElementRestyler::ConditionallyRestyleUndisplayedNodes(
    UndisplayedNode* aUndisplayed,
    nsIContent* aUndisplayedParent,
    const StyleDisplay aDisplay,
    Element* aRestyleRoot)
{
  MOZ_ASSERT(aDisplay == StyleDisplay::None ||
             aDisplay == StyleDisplay::Contents);
  if (!aUndisplayed) {
    return;
  }

  if (aUndisplayedParent &&
      aUndisplayedParent->IsElement() &&
      aUndisplayedParent->HasFlag(mRestyleTracker.RootBit())) {
    MOZ_ASSERT(!aUndisplayedParent->IsStyledByServo());
    aRestyleRoot = aUndisplayedParent->AsElement();
  }

  for (UndisplayedNode* undisplayed = aUndisplayed; undisplayed;
       undisplayed = undisplayed->mNext) {

    if (!undisplayed->mContent->IsElement()) {
      continue;
    }

    Element* element = undisplayed->mContent->AsElement();

    if (!ConditionallyRestyle(element, aRestyleRoot)) {
      if (aDisplay == StyleDisplay::None) {
        ConditionallyRestyleContentDescendants(element, aRestyleRoot);
      } else {  // StyleDisplay::Contents
        DoConditionallyRestyleUndisplayedDescendants(element, aRestyleRoot);
      }
    }
  }
}

void
ElementRestyler::ConditionallyRestyleContentDescendants(Element* aElement,
                                                        Element* aRestyleRoot)
{
  MOZ_ASSERT(!aElement->IsStyledByServo());
  if (aElement->HasFlag(mRestyleTracker.RootBit())) {
    aRestyleRoot = aElement;
  }

  FlattenedChildIterator it(aElement);
  for (nsIContent* n = it.GetNextChild(); n; n = it.GetNextChild()) {
    if (n->IsElement()) {
      Element* e = n->AsElement();
      if (!ConditionallyRestyle(e, aRestyleRoot)) {
        ConditionallyRestyleContentDescendants(e, aRestyleRoot);
      }
    }
  }
}

bool
ElementRestyler::ConditionallyRestyle(nsIFrame* aFrame, Element* aRestyleRoot)
{
  MOZ_ASSERT(aFrame->GetContent());

  if (!aFrame->GetContent()->IsElement()) {
    return true;
  }

  return ConditionallyRestyle(aFrame->GetContent()->AsElement(), aRestyleRoot);
}

bool
ElementRestyler::ConditionallyRestyle(Element* aElement, Element* aRestyleRoot)
{
  MOZ_ASSERT(!aElement->IsStyledByServo());
  LOG_RESTYLE("considering element %s for eRestyle_SomeDescendants",
              ElementTagToString(aElement).get());
  LOG_RESTYLE_INDENT();

  if (aElement->HasFlag(mRestyleTracker.RootBit())) {
    aRestyleRoot = aElement;
  }

  if (mRestyleTracker.HasRestyleData(aElement)) {
    nsRestyleHint rshint = eRestyle_SomeDescendants;
    if (SelectorMatchesForRestyle(aElement)) {
      LOG_RESTYLE("element has existing restyle data and matches a selector");
      rshint |= eRestyle_Self;
    } else {
      LOG_RESTYLE("element has existing restyle data but doesn't match selectors");
    }
    RestyleHintData data;
    data.mSelectorsForDescendants = mSelectorsForDescendants;
    mRestyleTracker.AddPendingRestyle(aElement, rshint, nsChangeHint(0), &data,
                                      Some(aRestyleRoot));
    return true;
  }

  if (SelectorMatchesForRestyle(aElement)) {
    LOG_RESTYLE("element has no restyle data but matches a selector");
    RestyleHintData data;
    data.mSelectorsForDescendants = mSelectorsForDescendants;
    mRestyleTracker.AddPendingRestyle(aElement,
                                      eRestyle_Self | eRestyle_SomeDescendants,
                                      nsChangeHint(0), &data,
                                      Some(aRestyleRoot));
    return true;
  }

  return false;
}

bool
ElementRestyler::MustCheckUndisplayedContent(nsIFrame* aFrame,
                                             nsIContent*& aUndisplayedParent)
{
  // When the root element is display:none, we still construct *some*
  // frames that have the root element as their mContent, down to the
  // DocElementContainingBlock.
  if (aFrame->StyleContext()->GetPseudo()) {
    aUndisplayedParent = nullptr;
    return aFrame == mPresContext->FrameConstructor()->
                       GetDocElementContainingBlock();
  }

  aUndisplayedParent = aFrame->GetContent();
  return !!aUndisplayedParent;
}

/**
 * Helper for MoveStyleContextsForChildren, below.  Appends the style
 * contexts to be moved to mFrame's current (new) style context to
 * aContextsToMove.
 */
bool
ElementRestyler::MoveStyleContextsForContentChildren(
    nsIFrame* aParent,
    nsStyleContext* aOldContext,
    nsTArray<nsStyleContext*>& aContextsToMove)
{
  nsIFrame::ChildListIterator lists(aParent);
  for (; !lists.IsDone(); lists.Next()) {
    for (nsIFrame* child : lists.CurrentList()) {
      // Bail out if we have out-of-flow frames.
      // FIXME: It might be safe to just continue here instead of bailing out.
      if (child->GetStateBits() & NS_FRAME_OUT_OF_FLOW) {
        return false;
      }
      if (GetPrevContinuationWithSameStyle(child)) {
        continue;
      }
      // Bail out if we have placeholder frames.
      // FIXME: It is probably safe to just continue here instead of bailing out.
      if (nsGkAtoms::placeholderFrame == child->GetType()) {
        return false;
      }
      nsStyleContext* sc = child->StyleContext();
      if (sc->GetParent() != aOldContext) {
        return false;
      }
      nsIAtom* type = child->GetType();
      if (type == nsGkAtoms::letterFrame ||
          type == nsGkAtoms::lineFrame) {
        return false;
      }
      if (sc->HasChildThatUsesGrandancestorStyle()) {
        // XXX Not sure if we need this?
        return false;
      }
      nsIAtom* pseudoTag = sc->GetPseudo();
      if (pseudoTag && !nsCSSAnonBoxes::IsNonElement(pseudoTag)) {
        return false;
      }
      aContextsToMove.AppendElement(sc);
    }
  }
  return true;
}

/**
 * Traverses to child elements (through the current frame's same style
 * continuations, just like RestyleChildren does) and moves any style context
 * for those children to be parented under mFrame's current (new) style
 * context.
 *
 * False is returned if it encounters any conditions on the child elements'
 * frames and style contexts that means it is impossible to move a
 * style context.  If false is returned, no style contexts will have been
 * moved.
 */
bool
ElementRestyler::MoveStyleContextsForChildren(nsStyleContext* aOldContext)
{
  // Bail out if there are undisplayed or display:contents children.
  // FIXME: We could get this to work if we need to.
  nsIContent* undisplayedParent;
  if (MustCheckUndisplayedContent(mFrame, undisplayedParent)) {
    nsCSSFrameConstructor* fc = mPresContext->FrameConstructor();
    if (fc->GetAllUndisplayedContentIn(undisplayedParent) ||
        fc->GetAllDisplayContentsIn(undisplayedParent)) {
      return false;
    }
  }

  nsTArray<nsStyleContext*> contextsToMove;

  MOZ_ASSERT(!MustReframeForBeforePseudo(),
             "shouldn't need to reframe ::before as we would have had "
             "eRestyle_Subtree and wouldn't get in here");

  DebugOnly<nsIFrame*> lastContinuation;
  for (nsIFrame* f = mFrame; f;
       f = RestyleManager::GetNextContinuationWithSameStyle(f, f->StyleContext())) {
    lastContinuation = f;
    if (!MoveStyleContextsForContentChildren(f, aOldContext, contextsToMove)) {
      return false;
    }
  }

  MOZ_ASSERT(!MustReframeForAfterPseudo(lastContinuation),
             "shouldn't need to reframe ::after as we would have had "
             "eRestyle_Subtree and wouldn't get in here");

  nsStyleContext* newParent = mFrame->StyleContext();
  for (nsStyleContext* child : contextsToMove) {
    // We can have duplicate entries in contextsToMove, so only move
    // each style context once.
    if (child->GetParent() != newParent) {
      child->MoveTo(newParent);
    }
  }

  return true;
}

/**
 * Recompute style for mFrame (which should not have a prev continuation
 * with the same style), all of its next continuations with the same
 * style, and all ib-split siblings of the same type (either block or
 * inline, skipping the intermediates of the other type) and accumulate
 * changes into mChangeList given that mHintsHandled is already accumulated
 * for an ancestor.
 * mParentContent is the content node used to resolve the parent style
 * context.  This means that, for pseudo-elements, it is the content
 * that should be used for selector matching (rather than the fake
 * content node attached to the frame).
 */
void
ElementRestyler::Restyle(nsRestyleHint aRestyleHint)
{
  // It would be nice if we could make stronger assertions here; they
  // would let us simplify the ?: expressions below setting |content|
  // and |pseudoContent| in sensible ways as well as making what
  // |content| and |pseudoContent| mean, and their relationship to
  // |mFrame->GetContent()|, make more sense.  However, we can't,
  // because of frame trees like the one in
  // https://bugzilla.mozilla.org/show_bug.cgi?id=472353#c14 .  Once we
  // fix bug 242277 we should be able to make this make more sense.
  NS_ASSERTION(mFrame->GetContent() || !mParentContent ||
               !mParentContent->GetParent(),
               "frame must have content (unless at the top of the tree)");
  MOZ_ASSERT(mPresContext == mFrame->PresContext(), "pres contexts match");

  NS_ASSERTION(!GetPrevContinuationWithSameStyle(mFrame),
               "should not be trying to restyle this frame separately");

  MOZ_ASSERT(!(aRestyleHint & eRestyle_LaterSiblings),
             "eRestyle_LaterSiblings must not be part of aRestyleHint");

  mPresContext->RestyledElement();

  AutoDisplayContentsAncestorPusher adcp(mTreeMatchContext, mPresContext,
      mFrame->GetContent() ? mFrame->GetContent()->GetParent() : nullptr);

  AutoSelectorArrayTruncater asat(mSelectorsForDescendants);

  // List of descendant elements of mContent we know we will eventually need to
  // restyle.  Before we return from this function, we call
  // RestyleTracker::AddRestyleRootsIfAwaitingRestyle to ensure they get
  // restyled in RestyleTracker::DoProcessRestyles.
  nsTArray<RefPtr<Element>> descendants;

  nsRestyleHint hintToRestore = nsRestyleHint(0);
  RestyleHintData hintDataToRestore;
  if (mContent && mContent->IsElement() &&
      // If we're resolving from the root of the frame tree (which
      // we do when mDoRebuildAllStyleData), we need to avoid getting the
      // root's restyle data until we get to its primary frame, since
      // it's the primary frame that has the styles for the root element
      // (rather than the ancestors of the primary frame whose mContent
      // is the root node but which have different styles).  If we use
      // up the hint for one of the ancestors that we hit first, then
      // we'll fail to do the restyling we need to do.
      // Likewise, if we're restyling something with two nested frames,
      // and we post a restyle from the transition manager while
      // computing style for the outer frame (to be computed after the
      // descendants have been resolved), we don't want to consume it
      // for the inner frame.
      mContent->GetPrimaryFrame() == mFrame) {
    mContent->OwnerDoc()->FlushPendingLinkUpdates();
    nsAutoPtr<RestyleTracker::RestyleData> restyleData;
    if (mRestyleTracker.GetRestyleData(mContent->AsElement(), restyleData)) {
      if (!NS_IsHintSubset(restyleData->mChangeHint, mHintsHandled)) {
        mHintsHandled |= restyleData->mChangeHint;
        mChangeList->AppendChange(mFrame, mContent, restyleData->mChangeHint);
      }
      mSelectorsForDescendants.AppendElements(
          restyleData->mRestyleHintData.mSelectorsForDescendants);
      hintToRestore = restyleData->mRestyleHint;
      hintDataToRestore = Move(restyleData->mRestyleHintData);
      aRestyleHint = nsRestyleHint(aRestyleHint | restyleData->mRestyleHint);
      descendants.SwapElements(restyleData->mDescendants);
    }
  }

  // If we are restyling this frame with eRestyle_Self or weaker hints,
  // we restyle children with nsRestyleHint(0).  But we pass the
  // eRestyle_ForceDescendants flag down too.
  nsRestyleHint childRestyleHint =
    nsRestyleHint(aRestyleHint & (eRestyle_SomeDescendants |
                                  eRestyle_Subtree |
                                  eRestyle_ForceDescendants));

  RefPtr<nsStyleContext> oldContext = mFrame->StyleContext();

  nsTArray<SwapInstruction> swaps;

  // TEMPORARY (until bug 918064):  Call RestyleSelf for each
  // continuation or block-in-inline sibling.

  // We must make a single decision on how to process this frame and
  // its descendants, yet RestyleSelf might return different RestyleResult
  // values for the different same-style continuations.  |result| is our
  // overall decision.
  RestyleResult result = RestyleResult::eNone;
  uint32_t swappedStructs = 0;

  nsRestyleHint thisRestyleHint = aRestyleHint;

  bool haveMoreContinuations = false;
  for (nsIFrame* f = mFrame; f; ) {
    RestyleResult thisResult =
      RestyleSelf(f, thisRestyleHint, &swappedStructs, swaps);

    if (thisResult != RestyleResult::eStop) {
      // Calls to RestyleSelf for later same-style continuations must not
      // return RestyleResult::eStop, so pass eRestyle_Force in to them.
      thisRestyleHint = nsRestyleHint(thisRestyleHint | eRestyle_Force);

      if (result == RestyleResult::eStop) {
        // We received RestyleResult::eStop for earlier same-style
        // continuations, and RestyleResult::eStopWithStyleChange or
        // RestyleResult::eContinue(AndForceDescendants) for this one; go
        // back and force-restyle the earlier continuations.
        result = thisResult;
        f = mFrame;
        continue;
      }
    }

    if (thisResult > result) {
      // We take the highest RestyleResult value when working out what to do
      // with this frame and its descendants.  Higher RestyleResult values
      // represent a superset of the work done by lower values.
      result = thisResult;
    }

    f = RestyleManager::GetNextContinuationWithSameStyle(f,
                                                         oldContext,
                                                         &haveMoreContinuations);
  }

  // Some changes to animations don't affect the computed style and yet still
  // require the layer to be updated. For example, pausing an animation via
  // the Web Animations API won't affect an element's style but still
  // requires us to pull the animation off the layer.
  //
  // Although we only expect this code path to be called when computed style
  // is not changing, we can sometimes reach this at the end of a transition
  // when the animated style is being removed. Since
  // AddLayerChangesForAnimation checks if mFrame has a transform style or not,
  // we need to call it *after* calling RestyleSelf to ensure the animated
  // transform has been removed first.
  AddLayerChangesForAnimation();

  if (haveMoreContinuations && hintToRestore) {
    // If we have more continuations with different style (e.g., because
    // we're inside a ::first-letter or ::first-line), put the restyle
    // hint back.
    mRestyleTracker.AddPendingRestyleToTable(mContent->AsElement(),
                                             hintToRestore, nsChangeHint(0));
  }

  if (result == RestyleResult::eStop) {
    MOZ_ASSERT(mFrame->StyleContext() == oldContext,
               "frame should have been left with its old style context");

    nsIFrame* unused;
    nsStyleContext* newParent = mFrame->GetParentStyleContext(&unused);
    if (oldContext->GetParent() != newParent) {
      // If we received RestyleResult::eStop, then the old style context was
      // left on mFrame.  Since we ended up restyling our parent, change
      // this old style context to point to its new parent.
      LOG_RESTYLE("moving style context %p from old parent %p to new parent %p",
                  oldContext.get(), oldContext->GetParent(), newParent);
      // We keep strong references to the new parent around until the end
      // of the restyle, in case:
      //   (a) we swapped structs between the old and new parent,
      //   (b) some descendants of the old parent are not getting restyled
      //       (which is the reason for the existence of
      //       ClearCachedInheritedStyleDataOnDescendants),
      //   (c) something under ProcessPendingRestyles (which notably is called
      //       *before* ClearCachedInheritedStyleDataOnDescendants is called
      //       on the old context) causes the new parent to be destroyed, thus
      //       destroying its owned structs, and
      //   (d) something under ProcessPendingRestyles then wants to use of those
      //       now destroyed structs (through the old parent's descendants).
      mSwappedStructOwners.AppendElement(newParent);
      oldContext->MoveTo(newParent);
    }

    // Send the accessibility notifications that RestyleChildren otherwise
    // would have sent.
    if (!(mHintsHandled & nsChangeHint_ReconstructFrame)) {
      InitializeAccessibilityNotifications(mFrame->StyleContext());
      SendAccessibilityNotifications();
    }

    mRestyleTracker.AddRestyleRootsIfAwaitingRestyle(descendants);
    if (aRestyleHint & eRestyle_SomeDescendants) {
      ConditionallyRestyleChildren();
    }
    return;
  }

  if (result == RestyleResult::eStopWithStyleChange &&
      !(mHintsHandled & nsChangeHint_ReconstructFrame)) {
    MOZ_ASSERT(mFrame->StyleContext() != oldContext,
               "RestyleResult::eStopWithStyleChange should only be returned "
               "if we got a new style context or we will reconstruct");
    MOZ_ASSERT(swappedStructs == 0,
               "should have ensured we didn't swap structs when "
               "returning RestyleResult::eStopWithStyleChange");

    // We need to ensure that all of the frames that inherit their style
    // from oldContext are able to be moved across to newContext.
    // MoveStyleContextsForChildren will check for certain conditions
    // to ensure it is safe to move all of the relevant child style
    // contexts to newContext.  If these conditions fail, it will
    // return false, and we'll have to continue restyling.
    const bool canStop = MoveStyleContextsForChildren(oldContext);

    if (canStop) {
      // Send the accessibility notifications that RestyleChildren otherwise
      // would have sent.
      if (!(mHintsHandled & nsChangeHint_ReconstructFrame)) {
        InitializeAccessibilityNotifications(mFrame->StyleContext());
        SendAccessibilityNotifications();
      }

      mRestyleTracker.AddRestyleRootsIfAwaitingRestyle(descendants);
      if (aRestyleHint & eRestyle_SomeDescendants) {
        ConditionallyRestyleChildren();
      }
      return;
    }

    // Turns out we couldn't stop restyling here.  Process the struct
    // swaps that RestyleSelf would've done had we not returned
    // RestyleResult::eStopWithStyleChange.
    for (SwapInstruction& swap : swaps) {
      LOG_RESTYLE("swapping style structs between %p and %p",
                  swap.mOldContext.get(), swap.mNewContext.get());
      swap.mOldContext->SwapStyleData(swap.mNewContext, swap.mStructsToSwap);
      swappedStructs |= swap.mStructsToSwap;
    }
    swaps.Clear();
  }

  if (!swappedStructs) {
    // If we swapped any structs from the old context, then we need to keep
    // it alive until after the RestyleChildren call so that we can fix up
    // its descendants' cached structs.
    oldContext = nullptr;
  }

  if (result == RestyleResult::eContinueAndForceDescendants) {
    childRestyleHint =
      nsRestyleHint(childRestyleHint | eRestyle_ForceDescendants);
  }

  // No need to do this if we're planning to reframe already.
  // It's also important to check mHintsHandled since we use
  // mFrame->StyleContext(), which is out of date if mHintsHandled
  // has a ReconstructFrame hint.  Using an out of date style
  // context could trigger assertions about mismatched rule trees.
  if (!(mHintsHandled & nsChangeHint_ReconstructFrame)) {
    RestyleChildren(childRestyleHint);
  }

  if (oldContext && !oldContext->HasSingleReference()) {
    // If we swapped some structs out of oldContext in the RestyleSelf call
    // and after the RestyleChildren call we still have other strong references
    // to it, we need to make ensure its descendants don't cache any of the
    // structs that were swapped out.
    //
    // Much of the time we will not get in here; we do for example when the
    // style context is shared with a later IB split sibling (which we won't
    // restyle until a bit later) or if other code is holding a strong reference
    // to the style context (as is done by nsTransformedTextRun objects, which
    // can be referenced by a text frame's mTextRun longer than the frame's
    // mStyleContext).
    //
    // Also, we don't want this style context to get any more uses by being
    // returned from nsStyleContext::FindChildWithRules, so we add the
    // NS_STYLE_INELIGIBLE_FOR_SHARING bit to it.
    oldContext->SetIneligibleForSharing();

    ContextToClear* toClear = mContextsToClear.AppendElement();
    toClear->mStyleContext = Move(oldContext);
    toClear->mStructs = swappedStructs;
  }

  mRestyleTracker.AddRestyleRootsIfAwaitingRestyle(descendants);
}

/**
 * Depending on the details of the frame we are restyling or its old style
 * context, we may or may not be able to stop restyling after this frame if
 * we find we had no style changes.
 *
 * This function returns RestyleResult::eStop if it does not find any
 * conditions that would preclude stopping restyling, and
 * RestyleResult::eContinue if it does.
 */
void
ElementRestyler::ComputeRestyleResultFromFrame(nsIFrame* aSelf,
                                               RestyleResult& aRestyleResult,
                                               bool& aCanStopWithStyleChange)
{
  // We can't handle situations where the primary style context of a frame
  // has not had any style data changes, but its additional style contexts
  // have, so we don't considering stopping if this frame has any additional
  // style contexts.
  if (aSelf->GetAdditionalStyleContext(0)) {
    LOG_RESTYLE_CONTINUE("there are additional style contexts");
    aRestyleResult = RestyleResult::eContinue;
    aCanStopWithStyleChange = false;
    return;
  }

  // Style changes might have moved children between the two nsLetterFrames
  // (the one matching ::first-letter and the one containing the rest of the
  // content).  Continue restyling to the children of the nsLetterFrame so
  // that they get the correct style context parent.  Similarly for
  // nsLineFrames.
  nsIAtom* type = aSelf->GetType();

  if (type == nsGkAtoms::letterFrame) {
    LOG_RESTYLE_CONTINUE("frame is a letter frame");
    aRestyleResult = RestyleResult::eContinue;
    aCanStopWithStyleChange = false;
    return;
  }

  if (type == nsGkAtoms::lineFrame) {
    LOG_RESTYLE_CONTINUE("frame is a line frame");
    aRestyleResult = RestyleResult::eContinue;
    aCanStopWithStyleChange = false;
    return;
  }

  // Some style computations depend not on the parent's style, but a grandparent
  // or one the grandparent's ancestors.  An example is an explicit 'inherit'
  // value for align-self, where if the parent frame's value for the property is
  // 'auto' we end up inheriting the computed value from the grandparent.  We
  // can't stop the restyling process on this frame (the one with 'auto', in
  // this example), as the grandparent's computed value might have changed
  // and we need to recompute the child's 'inherit' to that new value.
  nsStyleContext* oldContext = aSelf->StyleContext();
  if (oldContext->HasChildThatUsesGrandancestorStyle()) {
    LOG_RESTYLE_CONTINUE("the old context uses grandancestor style");
    aRestyleResult = RestyleResult::eContinue;
    aCanStopWithStyleChange = false;
    return;
  }

  // We ignore all situations that involve :visited style.
  if (oldContext->GetStyleIfVisited()) {
    LOG_RESTYLE_CONTINUE("the old style context has StyleIfVisited");
    aRestyleResult = RestyleResult::eContinue;
    aCanStopWithStyleChange = false;
    return;
  }

  nsStyleContext* parentContext = oldContext->GetParent();
  if (parentContext && parentContext->GetStyleIfVisited()) {
    LOG_RESTYLE_CONTINUE("the old style context's parent has StyleIfVisited");
    aRestyleResult = RestyleResult::eContinue;
    aCanStopWithStyleChange = false;
    return;
  }

  // We also ignore frames for pseudos, as their style contexts have
  // inheritance structures that do not match the frame inheritance
  // structure.  To avoid enumerating and checking all of the cases
  // where we have this kind of inheritance, we keep restyling past
  // pseudos.
  nsIAtom* pseudoTag = oldContext->GetPseudo();
  if (pseudoTag && !nsCSSAnonBoxes::IsNonElement(pseudoTag)) {
    LOG_RESTYLE_CONTINUE("the old style context is for a pseudo");
    aRestyleResult = RestyleResult::eContinue;
    aCanStopWithStyleChange = false;
    return;
  }

  nsIFrame* parent = mFrame->GetParent();

  if (parent) {
    // Also if the parent has a pseudo, as this frame's style context will
    // be inheriting from a grandparent frame's style context (or a further
    // ancestor).
    nsIAtom* parentPseudoTag = parent->StyleContext()->GetPseudo();
    if (parentPseudoTag &&
        parentPseudoTag != nsCSSAnonBoxes::mozOtherNonElement) {
      MOZ_ASSERT(parentPseudoTag != nsCSSAnonBoxes::mozText,
                 "Style of text node should not be parent of anything");
      LOG_RESTYLE_CONTINUE("the old style context's parent is for a pseudo");
      aRestyleResult = RestyleResult::eContinue;
      // Parent style context pseudo-ness doesn't affect whether we can
      // return RestyleResult::eStopWithStyleChange.
      //
      // If we had later conditions to check in this function, we would
      // continue to check them, in case we set aCanStopWithStyleChange to
      // false.
    }
  }
}

void
ElementRestyler::ComputeRestyleResultFromNewContext(nsIFrame* aSelf,
                                                    nsStyleContext* aNewContext,
                                                    RestyleResult& aRestyleResult,
                                                    bool& aCanStopWithStyleChange)
{
  // If we've already determined that we must continue styling, we don't
  // need to check anything.
  if (aRestyleResult == RestyleResult::eContinue && !aCanStopWithStyleChange) {
    return;
  }

  // Keep restyling if the new style context has any style-if-visted style, so
  // that we can avoid the style context tree surgery having to deal to deal
  // with visited styles.
  if (aNewContext->GetStyleIfVisited()) {
    LOG_RESTYLE_CONTINUE("the new style context has StyleIfVisited");
    aRestyleResult = RestyleResult::eContinue;
    aCanStopWithStyleChange = false;
    return;
  }

  // If link-related information has changed, or the pseudo for the frame has
  // changed, or the new style context points to a different rule node, we can't
  // leave the old style context on the frame.
  nsStyleContext* oldContext = aSelf->StyleContext();
  if (oldContext->IsLinkContext() != aNewContext->IsLinkContext() ||
      oldContext->RelevantLinkVisited() != aNewContext->RelevantLinkVisited() ||
      oldContext->GetPseudo() != aNewContext->GetPseudo() ||
      oldContext->GetPseudoType() != aNewContext->GetPseudoType()) {
    LOG_RESTYLE_CONTINUE("the old and new style contexts have different link/"
                         "visited/pseudo");
    aRestyleResult = RestyleResult::eContinue;
    aCanStopWithStyleChange = false;
    return;
  }

  if (oldContext->RuleNode() != aNewContext->RuleNode()) {
    LOG_RESTYLE_CONTINUE("the old and new style contexts have different "
                         "rulenodes");
    aRestyleResult = RestyleResult::eContinue;
    // Continue to check other conditions if aCanStopWithStyleChange might
    // still need to be set to false.
    if (!aCanStopWithStyleChange) {
      return;
    }
  }

  // If the old and new style contexts differ in their
  // NS_STYLE_HAS_TEXT_DECORATION_LINES or NS_STYLE_HAS_PSEUDO_ELEMENT_DATA
  // bits, then we must keep restyling so that those new bit values are
  // propagated.
  if (oldContext->HasTextDecorationLines() !=
        aNewContext->HasTextDecorationLines()) {
    LOG_RESTYLE_CONTINUE("NS_STYLE_HAS_TEXT_DECORATION_LINES differs between old"
                         " and new style contexts");
    aRestyleResult = RestyleResult::eContinue;
    aCanStopWithStyleChange = false;
    return;
  }

  if (oldContext->HasPseudoElementData() !=
        aNewContext->HasPseudoElementData()) {
    LOG_RESTYLE_CONTINUE("NS_STYLE_HAS_PSEUDO_ELEMENT_DATA differs between old"
                         " and new style contexts");
    aRestyleResult = RestyleResult::eContinue;
    aCanStopWithStyleChange = false;
    return;
  }

  if (oldContext->ShouldSuppressLineBreak() !=
        aNewContext->ShouldSuppressLineBreak()) {
    LOG_RESTYLE_CONTINUE("NS_STYLE_SUPPRESS_LINEBREAK differs"
                         "between old and new style contexts");
    aRestyleResult = RestyleResult::eContinue;
    aCanStopWithStyleChange = false;
    return;
  }

  if (oldContext->IsInDisplayNoneSubtree() !=
        aNewContext->IsInDisplayNoneSubtree()) {
    LOG_RESTYLE_CONTINUE("NS_STYLE_IN_DISPLAY_NONE_SUBTREE differs between old"
                         " and new style contexts");
    aRestyleResult = RestyleResult::eContinue;
    aCanStopWithStyleChange = false;
    return;
  }

  if (oldContext->IsTextCombined() != aNewContext->IsTextCombined()) {
    LOG_RESTYLE_CONTINUE("NS_STYLE_IS_TEXT_COMBINED differs between "
                         "old and new style contexts");
    aRestyleResult = RestyleResult::eContinue;
    aCanStopWithStyleChange = false;
    return;
  }
}

bool
ElementRestyler::SelectorMatchesForRestyle(Element* aElement)
{
  if (!aElement) {
    return false;
  }
  for (nsCSSSelector* selector : mSelectorsForDescendants) {
    if (nsCSSRuleProcessor::RestrictedSelectorMatches(aElement, selector,
                                                      mTreeMatchContext)) {
      return true;
    }
  }
  return false;
}

bool
ElementRestyler::MustRestyleSelf(nsRestyleHint aRestyleHint,
                                 Element* aElement)
{
  return (aRestyleHint & (eRestyle_Self | eRestyle_Subtree)) ||
         ((aRestyleHint & eRestyle_SomeDescendants) &&
          SelectorMatchesForRestyle(aElement));
}

bool
ElementRestyler::CanReparentStyleContext(nsRestyleHint aRestyleHint)
{
  // If we had any restyle hints other than the ones listed below,
  // which don't control whether the current frame/element needs
  // a new style context by looking up a new rule node, or if
  // we are reconstructing the entire rule tree, then we can't
  // use ReparentStyleContext.
  return !(aRestyleHint & ~(eRestyle_Force |
                            eRestyle_ForceDescendants |
                            eRestyle_SomeDescendants)) &&
         !StyleSet()->IsInRuleTreeReconstruct();
}

// Returns true iff any rule node that is an ancestor-or-self of the
// two specified rule nodes, but which is not an ancestor of both,
// has any inherited style data.  If false is returned, then we know
// that a change from one rule node to the other must not result in
// any change in inherited style data.
static bool
CommonInheritedStyleData(nsRuleNode* aRuleNode1, nsRuleNode* aRuleNode2)
{
  if (aRuleNode1 == aRuleNode2) {
    return true;
  }

  nsRuleNode* n1 = aRuleNode1->GetParent();
  nsRuleNode* n2 = aRuleNode2->GetParent();

  if (n1 == n2) {
    // aRuleNode1 and aRuleNode2 sharing a parent is a common case, e.g.
    // when modifying a style="" attribute.  (We must null check GetRule()'s
    // result since although we know the two parents are the same, it might
    // be null, as in the case of the two rule nodes being roots of two
    // different rule trees.)
    if (aRuleNode1->GetRule() &&
        aRuleNode1->GetRule()->MightMapInheritedStyleData()) {
      return false;
    }
    if (aRuleNode2->GetRule() &&
        aRuleNode2->GetRule()->MightMapInheritedStyleData()) {
      return false;
    }
    return true;
  }

  // Compute the depths of aRuleNode1 and aRuleNode2.
  int d1 = 0, d2 = 0;
  while (n1) {
    ++d1;
    n1 = n1->GetParent();
  }
  while (n2) {
    ++d2;
    n2 = n2->GetParent();
  }

  // Make aRuleNode1 be the deeper node.
  if (d2 > d1) {
    std::swap(d1, d2);
    std::swap(aRuleNode1, aRuleNode2);
  }

  // Check all of the rule nodes in the deeper branch until we reach
  // the same depth as the shallower branch.
  n1 = aRuleNode1;
  n2 = aRuleNode2;
  while (d1 > d2) {
    nsIStyleRule* rule = n1->GetRule();
    MOZ_ASSERT(rule, "non-root rule node should have a rule");
    if (rule->MightMapInheritedStyleData()) {
      return false;
    }
    n1 = n1->GetParent();
    --d1;
  }

  // Check both branches simultaneously until we reach a common ancestor.
  while (n1 != n2) {
    MOZ_ASSERT(n1);
    MOZ_ASSERT(n2);
    // As above, we must null check GetRule()'s result since we won't find
    // a common ancestor if the two rule nodes come from different rule trees,
    // and thus we might reach the root (which has a null rule).
    if (n1->GetRule() && n1->GetRule()->MightMapInheritedStyleData()) {
      return false;
    }
    if (n2->GetRule() && n2->GetRule()->MightMapInheritedStyleData()) {
      return false;
    }
    n1 = n1->GetParent();
    n2 = n2->GetParent();
  }

  return true;
}

ElementRestyler::RestyleResult
ElementRestyler::RestyleSelf(nsIFrame* aSelf,
                             nsRestyleHint aRestyleHint,
                             uint32_t* aSwappedStructs,
                             nsTArray<SwapInstruction>& aSwaps)
{
  MOZ_ASSERT(!(aRestyleHint & eRestyle_LaterSiblings),
             "eRestyle_LaterSiblings must not be part of aRestyleHint");

  // XXXldb get new context from prev-in-flow if possible, to avoid
  // duplication.  (Or should we just let |GetContext| handle that?)
  // Getting the hint would be nice too, but that's harder.

  // XXXbryner we may be able to avoid some of the refcounting goop here.
  // We do need a reference to oldContext for the lifetime of this function, and it's possible
  // that the frame has the last reference to it, so AddRef it here.

  LOG_RESTYLE("RestyleSelf %s, aRestyleHint = %s",
              FrameTagToString(aSelf).get(),
              RestyleManagerBase::RestyleHintToString(aRestyleHint).get());
  LOG_RESTYLE_INDENT();

  // Initially assume that it is safe to stop restyling.
  //
  // Throughout most of this function, we update the following two variables
  // independently.  |result| is set to RestyleResult::eContinue when we
  // detect a condition that would not allow us to return RestyleResult::eStop.
  // |canStopWithStyleChange| is set to false when we detect a condition
  // that would not allow us to return RestyleResult::eStopWithStyleChange.
  //
  // Towards the end of this function, we reconcile these two variables --
  // if |canStopWithStyleChange| is true, we convert |result| into
  // RestyleResult::eStopWithStyleChange.
  RestyleResult result = RestyleResult::eStop;
  bool canStopWithStyleChange = true;

  if (aRestyleHint & ~eRestyle_SomeDescendants) {
    // If we are doing any restyling of the current element, or if we're
    // forced to continue, we must.
    result = RestyleResult::eContinue;

    // If we have to restyle children, we can't return
    // RestyleResult::eStopWithStyleChange.
    if (aRestyleHint & (eRestyle_Subtree | eRestyle_Force |
                        eRestyle_ForceDescendants)) {
      canStopWithStyleChange = false;
    }
  }

  // We only consider returning RestyleResult::eStopWithStyleChange if this
  // is the root of the restyle.  (Otherwise, we would need to track the
  // style changes of the ancestors we just restyled.)
  if (!mIsRootOfRestyle) {
    canStopWithStyleChange = false;
  }

  // Look at the frame and its current style context for conditions
  // that would change our RestyleResult.
  ComputeRestyleResultFromFrame(aSelf, result, canStopWithStyleChange);

  nsChangeHint assumeDifferenceHint = nsChangeHint(0);
  RefPtr<nsStyleContext> oldContext = aSelf->StyleContext();
  nsStyleSet* styleSet = StyleSet();

#ifdef ACCESSIBILITY
  mWasFrameVisible = nsIPresShell::IsAccessibilityActive() ?
    oldContext->StyleVisibility()->IsVisible() : false;
#endif

  nsIAtom* const pseudoTag = oldContext->GetPseudo();
  const CSSPseudoElementType pseudoType = oldContext->GetPseudoType();

  // Get the frame providing the parent style context.  If it is a
  // child, then resolve the provider first.
  nsIFrame* providerFrame;
  nsStyleContext* parentContext = aSelf->GetParentStyleContext(&providerFrame);
  bool isChild = providerFrame && providerFrame->GetParent() == aSelf;
  if (isChild) {
    MOZ_ASSERT(providerFrame->GetContent() == aSelf->GetContent(),
               "Postcondition for GetParentStyleContext() violated. "
               "That means we need to add the current element to the "
               "ancestor filter.");

    // resolve the provider here (before aSelf below).
    LOG_RESTYLE("resolving child provider frame");

    // assumeDifferenceHint forces the parent's change to be also
    // applied to this frame, no matter what
    // nsStyleContext::CalcStyleDifference says. CalcStyleDifference
    // can't be trusted because it assumes any changes to the parent
    // style context provider will be automatically propagated to
    // the frame(s) with child style contexts.

    ElementRestyler providerRestyler(PARENT_CONTEXT_FROM_CHILD_FRAME,
                                     *this, providerFrame);
    providerRestyler.Restyle(aRestyleHint);
    assumeDifferenceHint = providerRestyler.HintsHandledForFrame();

    // The provider's new context becomes the parent context of
    // aSelf's context.
    parentContext = providerFrame->StyleContext();
    // Set |mResolvedChild| so we don't bother resolving the
    // provider again.
    mResolvedChild = providerFrame;
    LOG_RESTYLE_CONTINUE("we had a provider frame");
    // Continue restyling past the odd style context inheritance.
    result = RestyleResult::eContinue;
    canStopWithStyleChange = false;
  }

  if (providerFrame != aSelf->GetParent()) {
    // We don't actually know what the parent style context's
    // non-inherited hints were, so assume the worst.
    mParentFrameHintsNotHandledForDescendants =
      nsChangeHint_Hints_NotHandledForDescendants;
  }

  LOG_RESTYLE("parentContext = %p", parentContext);

  // do primary context
  RefPtr<nsStyleContext> newContext;
  nsIFrame* prevContinuation =
    GetPrevContinuationWithPossiblySameStyle(aSelf);
  nsStyleContext* prevContinuationContext;
  bool copyFromContinuation =
    prevContinuation &&
    (prevContinuationContext = prevContinuation->StyleContext())
      ->GetPseudo() == oldContext->GetPseudo() &&
     prevContinuationContext->GetParent() == parentContext;
  if (copyFromContinuation) {
    // Just use the style context from the frame's previous
    // continuation.
    LOG_RESTYLE("using previous continuation's context");
    newContext = prevContinuationContext;
  } else if (pseudoTag == nsCSSAnonBoxes::mozText) {
    MOZ_ASSERT(aSelf->GetType() == nsGkAtoms::textFrame);
    newContext =
      styleSet->ResolveStyleForText(aSelf->GetContent(), parentContext);
  } else if (nsCSSAnonBoxes::IsNonElement(pseudoTag)) {
    newContext = styleSet->ResolveStyleForOtherNonElement(parentContext);
  }
  else {
    Element* element = ElementForStyleContext(mParentContent, aSelf, pseudoType);
    if (!MustRestyleSelf(aRestyleHint, element)) {
      if (CanReparentStyleContext(aRestyleHint)) {
        LOG_RESTYLE("reparenting style context");
        newContext =
          styleSet->ReparentStyleContext(oldContext, parentContext, element);
      } else {
        // Use ResolveStyleWithReplacement either for actual replacements
        // or, with no replacements, as a substitute for
        // ReparentStyleContext that rebuilds the path in the rule tree
        // rather than reusing the rule node, as we need to do during a
        // rule tree reconstruct.
        Element* pseudoElement = PseudoElementForStyleContext(aSelf, pseudoType);
        MOZ_ASSERT(!element || element != pseudoElement,
                   "pseudo-element for selector matching should be "
                   "the anonymous content node that we create, "
                   "not the real element");
        LOG_RESTYLE("resolving style with replacement");
        nsRestyleHint rshint = aRestyleHint & ~eRestyle_SomeDescendants;
        newContext =
          styleSet->ResolveStyleWithReplacement(element, pseudoElement,
                                                parentContext, oldContext,
                                                rshint);
      }
    } else if (pseudoType == CSSPseudoElementType::AnonBox) {
      newContext = styleSet->ResolveAnonymousBoxStyle(pseudoTag,
                                                      parentContext);
    }
    else {
      if (pseudoTag) {
        if (pseudoTag == nsCSSPseudoElements::before ||
            pseudoTag == nsCSSPseudoElements::after) {
          // XXX what other pseudos do we need to treat like this?
          newContext = styleSet->ProbePseudoElementStyle(element,
                                                         pseudoType,
                                                         parentContext,
                                                         mTreeMatchContext);
          if (!newContext) {
            // This pseudo should no longer exist; gotta reframe
            mHintsHandled |= nsChangeHint_ReconstructFrame;
            mChangeList->AppendChange(aSelf, element,
                                      nsChangeHint_ReconstructFrame);
            // We're reframing anyway; just keep the same context
            newContext = oldContext;
#ifdef DEBUG
            // oldContext's parent might have had its style structs swapped out
            // with parentContext, so to avoid any assertions that might
            // otherwise trigger in oldContext's parent's destructor, we set a
            // flag on oldContext to skip it and its descendants in
            // nsStyleContext::AssertStructsNotUsedElsewhere.
            if (oldContext->GetParent() != parentContext) {
              oldContext->AddStyleBit(NS_STYLE_IS_GOING_AWAY);
            }
#endif
          }
        } else {
          // Don't expect XUL tree stuff here, since it needs a comparator and
          // all.
          NS_ASSERTION(pseudoType < CSSPseudoElementType::Count,
                       "Unexpected pseudo type");
          Element* pseudoElement =
            PseudoElementForStyleContext(aSelf, pseudoType);
          MOZ_ASSERT(element != pseudoElement,
                     "pseudo-element for selector matching should be "
                     "the anonymous content node that we create, "
                     "not the real element");
          newContext = styleSet->ResolvePseudoElementStyle(element,
                                                           pseudoType,
                                                           parentContext,
                                                           pseudoElement);
        }
      }
      else {
        NS_ASSERTION(aSelf->GetContent(),
                     "non pseudo-element frame without content node");
        // Skip parent display based style fixup for anonymous subtrees:
        TreeMatchContext::AutoParentDisplayBasedStyleFixupSkipper
          parentDisplayBasedFixupSkipper(mTreeMatchContext,
                                 element->IsRootOfNativeAnonymousSubtree());
        newContext = styleSet->ResolveStyleFor(element, parentContext,
                                               mTreeMatchContext);
      }
    }
  }

  MOZ_ASSERT(newContext);

  if (!parentContext) {
    if (oldContext->RuleNode() == newContext->RuleNode() &&
        oldContext->IsLinkContext() == newContext->IsLinkContext() &&
        oldContext->RelevantLinkVisited() ==
          newContext->RelevantLinkVisited()) {
      // We're the root of the style context tree and the new style
      // context returned has the same rule node.  This means that
      // we can use FindChildWithRules to keep a lot of the old
      // style contexts around.  However, we need to start from the
      // same root.
      LOG_RESTYLE("restyling root and keeping old context");
      LOG_RESTYLE_IF(this, result != RestyleResult::eContinue,
                     "continuing restyle since this is the root");
      newContext = oldContext;
      // Never consider stopping restyling at the root.
      result = RestyleResult::eContinue;
      canStopWithStyleChange = false;
    }
  }

  LOG_RESTYLE("oldContext = %p, newContext = %p%s",
              oldContext.get(), newContext.get(),
              oldContext == newContext ? (const char*) " (same)" :
                                         (const char*) "");

  if (newContext != oldContext) {
    if (oldContext->IsShared()) {
      // If the old style context was shared, then we can't return
      // RestyleResult::eStop and patch its parent to point to the
      // new parent style context, as that change might not be valid
      // for the other frames sharing the style context.
      LOG_RESTYLE_CONTINUE("the old style context is shared");
      result = RestyleResult::eContinue;

      // It is not safe to return RestyleResult::eStopWithStyleChange
      // when oldContext is shared and newContext has different
      // inherited style data, regardless of whether the oldContext has
      // that inherited style data cached.  We can't simply rely on the
      // samePointerStructs check later on, as the descendent style
      // contexts just might not have had their inherited style data
      // requested yet (which is possible for example if we flush style
      // between resolving an initial style context for a frame and
      // building its display list items).  Therefore we must compare
      // the rule nodes of oldContext and newContext to see if the
      // restyle results in new inherited style data.  If not, then
      // we can continue assuming that RestyleResult::eStopWithStyleChange
      // is safe.  Without this check, we could end up with style contexts
      // shared between elements which should have different styles.
      if (!CommonInheritedStyleData(oldContext->RuleNode(),
                                    newContext->RuleNode())) {
        canStopWithStyleChange = false;
      }
    }

    // Look at some details of the new style context to see if it would
    // be safe to stop restyling, if we discover it has the same style
    // data as the old style context.
    ComputeRestyleResultFromNewContext(aSelf, newContext,
                                       result, canStopWithStyleChange);

    uint32_t equalStructs = 0;
    uint32_t samePointerStructs = 0;

    if (copyFromContinuation) {
      // In theory we should know whether there was any style data difference,
      // since we would have calculated that in the previous call to
      // RestyleSelf, so until we perform only one restyling per chain-of-
      // same-style continuations (bug 918064), we need to check again here to
      // determine whether it is safe to stop restyling.
      if (result == RestyleResult::eStop) {
        oldContext->CalcStyleDifference(newContext, nsChangeHint(0),
                                        &equalStructs,
                                        &samePointerStructs);
        if (equalStructs != NS_STYLE_INHERIT_MASK) {
          // At least one struct had different data in it, so we must
          // continue restyling children.
          LOG_RESTYLE_CONTINUE("there is different style data: %s",
                      RestyleManager::StructNamesToString(
                        ~equalStructs & NS_STYLE_INHERIT_MASK).get());
          result = RestyleResult::eContinue;
        }
      }
    } else {
      bool changedStyle =
        RestyleManager::TryInitiatingTransition(mPresContext,
                                                aSelf->GetContent(),
                                                oldContext, &newContext);
      if (changedStyle) {
        LOG_RESTYLE_CONTINUE("TryInitiatingTransition changed the new style "
                             "context");
        result = RestyleResult::eContinue;
        canStopWithStyleChange = false;
      }
      CaptureChange(oldContext, newContext, assumeDifferenceHint,
                    &equalStructs, &samePointerStructs);
      if (equalStructs != NS_STYLE_INHERIT_MASK) {
        // At least one struct had different data in it, so we must
        // continue restyling children.
        LOG_RESTYLE_CONTINUE("there is different style data: %s",
                    RestyleManager::StructNamesToString(
                      ~equalStructs & NS_STYLE_INHERIT_MASK).get());
        result = RestyleResult::eContinue;
      }
    }

    if (canStopWithStyleChange) {
      // If any inherited struct pointers are different, or if any
      // reset struct pointers are different and we have descendants
      // that rely on those reset struct pointers, we can't return
      // RestyleResult::eStopWithStyleChange.
      if ((samePointerStructs & NS_STYLE_INHERITED_STRUCT_MASK) !=
            NS_STYLE_INHERITED_STRUCT_MASK) {
        LOG_RESTYLE("can't return RestyleResult::eStopWithStyleChange since "
                    "there is different inherited data");
        canStopWithStyleChange = false;
      } else if ((samePointerStructs & NS_STYLE_RESET_STRUCT_MASK) !=
                   NS_STYLE_RESET_STRUCT_MASK &&
                 oldContext->HasChildThatUsesResetStyle()) {
        LOG_RESTYLE("can't return RestyleResult::eStopWithStyleChange since "
                    "there is different reset data and descendants use it");
        canStopWithStyleChange = false;
      }
    }

    if (result == RestyleResult::eStop) {
      // Since we currently have RestyleResult::eStop, we know at this
      // point that all of our style structs are equal in terms of styles.
      // However, some of them might be different pointers.  Since our
      // descendants might share those pointers, we have to continue to
      // restyling our descendants.
      //
      // However, because of the swapping of equal structs we've done on
      // ancestors (later in this function), we've ensured that for structs
      // that cannot be stored in the rule tree, we keep the old equal structs
      // around rather than replacing them with new ones.  This means that we
      // only time we hit this deoptimization is either
      //
      // (a) when at least one of the (old or new) equal structs could be stored
      //     in the rule tree, and those structs are then inherited (by pointer
      //     sharing) to descendant style contexts; or
      //
      // (b) when we were unable to swap the structs on the parent because
      //     either or both of the old parent and new parent are shared.
      //
      // FIXME This loop could be rewritten as bit operations on
      //       oldContext->mBits and samePointerStructs.
      for (nsStyleStructID sid = nsStyleStructID(0);
           sid < nsStyleStructID_Length;
           sid = nsStyleStructID(sid + 1)) {
        if (oldContext->HasCachedDependentStyleData(sid) &&
            !(samePointerStructs & nsCachedStyleData::GetBitForSID(sid))) {
          LOG_RESTYLE_CONTINUE("there are different struct pointers");
          result = RestyleResult::eContinue;
          break;
        }
      }
    }

    // From this point we no longer do any assignments of
    // RestyleResult::eContinue to |result|.  If canStopWithStyleChange is true,
    // it means that we can convert |result| (whether it is
    // RestyleResult::eContinue or RestyleResult::eStop) into
    // RestyleResult::eStopWithStyleChange.
    if (canStopWithStyleChange) {
      LOG_RESTYLE("converting %s into RestyleResult::eStopWithStyleChange",
                  RestyleResultToString(result).get());
      result = RestyleResult::eStopWithStyleChange;
    }

    if (aRestyleHint & eRestyle_ForceDescendants) {
      result = RestyleResult::eContinueAndForceDescendants;
    }

    if (!(mHintsHandled & nsChangeHint_ReconstructFrame)) {
      // If the frame gets regenerated, let it keep its old context,
      // which is important to maintain various invariants about
      // frame types matching their style contexts.
      // Note that this check even makes sense if we didn't call
      // CaptureChange because of copyFromContinuation being true,
      // since we'll have copied the existing context from the
      // previous continuation, so newContext == oldContext.

      if (result != RestyleResult::eStop) {
        if (copyFromContinuation) {
          LOG_RESTYLE("not swapping style structs, since we copied from a "
                      "continuation");
        } else if (oldContext->IsShared() && newContext->IsShared()) {
          LOG_RESTYLE("not swapping style structs, since both old and contexts "
                      "are shared");
        } else if (oldContext->IsShared()) {
          LOG_RESTYLE("not swapping style structs, since the old context is "
                      "shared");
        } else if (newContext->IsShared()) {
          LOG_RESTYLE("not swapping style structs, since the new context is "
                      "shared");
        } else {
          if (result == RestyleResult::eStopWithStyleChange) {
            LOG_RESTYLE("recording a style struct swap between %p and %p to "
                        "do if RestyleResult::eStopWithStyleChange fails",
                        oldContext.get(), newContext.get());
            SwapInstruction* swap = aSwaps.AppendElement();
            swap->mOldContext = oldContext;
            swap->mNewContext = newContext;
            swap->mStructsToSwap = equalStructs;
          } else {
            LOG_RESTYLE("swapping style structs between %p and %p",
                        oldContext.get(), newContext.get());
            oldContext->SwapStyleData(newContext, equalStructs);
            *aSwappedStructs |= equalStructs;
          }
#ifdef RESTYLE_LOGGING
          uint32_t structs = RestyleManager::StructsToLog() & equalStructs;
          if (structs) {
            LOG_RESTYLE_INDENT();
            LOG_RESTYLE("old style context now has: %s",
                        oldContext->GetCachedStyleDataAsString(structs).get());
            LOG_RESTYLE("new style context now has: %s",
                        newContext->GetCachedStyleDataAsString(structs).get());
          }
#endif
        }
        LOG_RESTYLE("setting new style context");
        aSelf->SetStyleContext(newContext);
      }
    } else {
      LOG_RESTYLE("not setting new style context, since we'll reframe");
      // We need to keep the new parent alive, in case it had structs
      // swapped into it that our frame's style context still has cached.
      // This is a similar scenario to the one described in the
      // ElementRestyler::Restyle comment where we append to
      // mSwappedStructOwners.
      //
      // We really only need to do this if we did swap structs on the
      // parent, but we don't have that information here.
      mSwappedStructOwners.AppendElement(newContext->GetParent());
    }
  } else {
    if (aRestyleHint & eRestyle_ForceDescendants) {
      result = RestyleResult::eContinueAndForceDescendants;
    }
  }
  oldContext = nullptr;

  // do additional contexts
  // XXXbz might be able to avoid selector matching here in some
  // cases; won't worry about it for now.
  int32_t contextIndex = 0;
  for (nsStyleContext* oldExtraContext;
       (oldExtraContext = aSelf->GetAdditionalStyleContext(contextIndex));
       ++contextIndex) {
    LOG_RESTYLE("extra context %d", contextIndex);
    LOG_RESTYLE_INDENT();
    RefPtr<nsStyleContext> newExtraContext;
    nsIAtom* const extraPseudoTag = oldExtraContext->GetPseudo();
    const CSSPseudoElementType extraPseudoType =
      oldExtraContext->GetPseudoType();
    NS_ASSERTION(extraPseudoTag &&
                 !nsCSSAnonBoxes::IsNonElement(extraPseudoTag),
                 "extra style context is not pseudo element");
    Element* element = extraPseudoType != CSSPseudoElementType::AnonBox
                         ? mContent->AsElement() : nullptr;
    if (!MustRestyleSelf(aRestyleHint, element)) {
      if (CanReparentStyleContext(aRestyleHint)) {
        newExtraContext =
          styleSet->ReparentStyleContext(oldExtraContext, newContext, element);
      } else {
        // Use ResolveStyleWithReplacement as a substitute for
        // ReparentStyleContext that rebuilds the path in the rule tree
        // rather than reusing the rule node, as we need to do during a
        // rule tree reconstruct.
        Element* pseudoElement =
          PseudoElementForStyleContext(aSelf, extraPseudoType);
        MOZ_ASSERT(!element || element != pseudoElement,
                   "pseudo-element for selector matching should be "
                   "the anonymous content node that we create, "
                   "not the real element");
        newExtraContext =
          styleSet->ResolveStyleWithReplacement(element, pseudoElement,
                                                newContext, oldExtraContext,
                                                nsRestyleHint(0));
      }
    } else if (extraPseudoType == CSSPseudoElementType::AnonBox) {
      newExtraContext = styleSet->ResolveAnonymousBoxStyle(extraPseudoTag,
                                                           newContext);
    } else {
      // Don't expect XUL tree stuff here, since it needs a comparator and
      // all.
      NS_ASSERTION(extraPseudoType < CSSPseudoElementType::Count,
                   "Unexpected type");
      newExtraContext = styleSet->ResolvePseudoElementStyle(mContent->AsElement(),
                                                            extraPseudoType,
                                                            newContext,
                                                            nullptr);
    }

    MOZ_ASSERT(newExtraContext);

    LOG_RESTYLE("newExtraContext = %p", newExtraContext.get());

    if (oldExtraContext != newExtraContext) {
      uint32_t equalStructs;
      uint32_t samePointerStructs;
      CaptureChange(oldExtraContext, newExtraContext, assumeDifferenceHint,
                    &equalStructs, &samePointerStructs);
      if (!(mHintsHandled & nsChangeHint_ReconstructFrame)) {
        LOG_RESTYLE("setting new extra style context");
        aSelf->SetAdditionalStyleContext(contextIndex, newExtraContext);
      } else {
        LOG_RESTYLE("not setting new extra style context, since we'll reframe");
      }
    }
  }

  LOG_RESTYLE("returning %s", RestyleResultToString(result).get());

  return result;
}

void
ElementRestyler::RestyleChildren(nsRestyleHint aChildRestyleHint)
{
  MOZ_ASSERT(!(mHintsHandled & nsChangeHint_ReconstructFrame),
             "No need to do this if we're planning to reframe already.");

  // We'd like style resolution to be exact in the sense that an
  // animation-only style flush flushes only the styles it requests
  // flushing and doesn't update any other styles.  This means avoiding
  // constructing new frames during such a flush.
  //
  // For a ::before or ::after, we'll do an eRestyle_Subtree due to
  // RestyleHintForOp in nsCSSRuleProcessor.cpp (via its
  // HasAttributeDependentStyle or HasStateDependentStyle), given that
  // we store pseudo-elements in selectors like they were children.
  //
  // Also, it's faster to skip the work we do on undisplayed children
  // and pseudo-elements when we can skip it.
  bool mightReframePseudos = aChildRestyleHint & eRestyle_Subtree;

  RestyleUndisplayedDescendants(aChildRestyleHint);

  // Check whether we might need to create a new ::before frame.
  // There's no need to do this if we're planning to reframe already
  // or if we're not forcing restyles on kids.
  // It's also important to check mHintsHandled since we use
  // mFrame->StyleContext(), which is out of date if mHintsHandled has a
  // ReconstructFrame hint.  Using an out of date style context could
  // trigger assertions about mismatched rule trees.
  if (!(mHintsHandled & nsChangeHint_ReconstructFrame) &&
      mightReframePseudos) {
    MaybeReframeForBeforePseudo();
  }

  // There is no need to waste time crawling into a frame's children
  // on a frame change.  The act of reconstructing frames will force
  // new style contexts to be resolved on all of this frame's
  // descendants anyway, so we want to avoid wasting time processing
  // style contexts that we're just going to throw away anyway. - dwh
  // It's also important to check mHintsHandled since reresolving the
  // kids would use mFrame->StyleContext(), which is out of date if
  // mHintsHandled has a ReconstructFrame hint; doing this could trigger
  // assertions about mismatched rule trees.
  nsIFrame* lastContinuation;
  if (!(mHintsHandled & nsChangeHint_ReconstructFrame)) {
    InitializeAccessibilityNotifications(mFrame->StyleContext());

    for (nsIFrame* f = mFrame; f;
         f = RestyleManager::GetNextContinuationWithSameStyle(f, f->StyleContext())) {
      lastContinuation = f;
      RestyleContentChildren(f, aChildRestyleHint);
    }

    SendAccessibilityNotifications();
  }

  // Check whether we might need to create a new ::after frame.
  // See comments above regarding :before.
  if (!(mHintsHandled & nsChangeHint_ReconstructFrame) &&
      mightReframePseudos) {
    MaybeReframeForAfterPseudo(lastContinuation);
  }
}

void
ElementRestyler::RestyleChildrenOfDisplayContentsElement(
  nsIFrame*              aParentFrame,
  nsStyleContext*        aNewContext,
  nsChangeHint           aMinHint,
  RestyleTracker&        aRestyleTracker,
  nsRestyleHint          aRestyleHint,
  const RestyleHintData& aRestyleHintData)
{
  MOZ_ASSERT(!(mHintsHandled & nsChangeHint_ReconstructFrame), "why call me?");

  const bool mightReframePseudos = aRestyleHint & eRestyle_Subtree;
  DoRestyleUndisplayedDescendants(nsRestyleHint(0), mContent, aNewContext);
  if (!(mHintsHandled & nsChangeHint_ReconstructFrame) && mightReframePseudos) {
    MaybeReframeForPseudo(CSSPseudoElementType::before,
                          aParentFrame, nullptr, mContent, aNewContext);
  }
  if (!(mHintsHandled & nsChangeHint_ReconstructFrame) && mightReframePseudos) {
    MaybeReframeForPseudo(CSSPseudoElementType::after,
                          aParentFrame, nullptr, mContent, aNewContext);
  }
  if (!(mHintsHandled & nsChangeHint_ReconstructFrame)) {
    InitializeAccessibilityNotifications(aNewContext);

    // Then process child frames for content that is a descendant of mContent.
    // XXX perhaps it's better to walk child frames (before reresolving
    // XXX undisplayed contexts above) and mark those that has a stylecontext
    // XXX leading up to mContent's old context? (instead of the
    // XXX ContentIsDescendantOf check below)
    nsIFrame::ChildListIterator lists(aParentFrame);
    for ( ; !lists.IsDone(); lists.Next()) {
      for (nsIFrame* f : lists.CurrentList()) {
        if (nsContentUtils::ContentIsDescendantOf(f->GetContent(), mContent) &&
            !f->GetPrevContinuation()) {
          if (!(f->GetStateBits() & NS_FRAME_OUT_OF_FLOW)) {
            ComputeStyleChangeFor(f, mChangeList, aMinHint, aRestyleTracker,
                                  aRestyleHint, aRestyleHintData,
                                  mContextsToClear, mSwappedStructOwners);
          }
        }
      }
    }
  }
  if (!(mHintsHandled & nsChangeHint_ReconstructFrame)) {
    SendAccessibilityNotifications();
  }
}

void
ElementRestyler::ComputeStyleChangeFor(nsIFrame*          aFrame,
                                       nsStyleChangeList* aChangeList,
                                       nsChangeHint       aMinChange,
                                       RestyleTracker&    aRestyleTracker,
                                       nsRestyleHint      aRestyleHint,
                                       const RestyleHintData& aRestyleHintData,
                                       nsTArray<ContextToClear>&
                                         aContextsToClear,
                                       nsTArray<RefPtr<nsStyleContext>>&
                                         aSwappedStructOwners)
{
  nsIContent* content = aFrame->GetContent();
  nsAutoCString localDescriptor;
  if (profiler_is_active() && content) {
    std::string elemDesc = ToString(*content);
    localDescriptor.Assign(elemDesc.c_str());
  }

  PROFILER_LABEL_PRINTF("ElementRestyler", "ComputeStyleChangeFor",
                        js::ProfileEntry::Category::CSS,
                        content ? "Element: %s" : "%s",
                        content ? localDescriptor.get() : "");
  if (aMinChange) {
    aChangeList->AppendChange(aFrame, content, aMinChange);
  }

  NS_ASSERTION(!aFrame->GetPrevContinuation(),
               "must start with the first continuation");

  // We want to start with this frame and walk all its next-in-flows,
  // as well as all its ib-split siblings and their next-in-flows,
  // reresolving style on all the frames we encounter in this walk that
  // we didn't reach already.  In the normal case, this will mean only
  // restyling the first two block-in-inline splits and no
  // continuations, and skipping everything else.  However, when we have
  // a style change targeted at an element inside a context where styles
  // vary between continuations (e.g., a style change on an element that
  // extends from inside a styled ::first-line to outside of that first
  // line), we might restyle more than that.

  nsPresContext* presContext = aFrame->PresContext();
  FramePropertyTable* propTable = presContext->PropertyTable();

  TreeMatchContext treeMatchContext(true,
                                    nsRuleWalker::eRelevantLinkUnvisited,
                                    presContext->Document());
  Element* parent =
    content ? content->GetParentElementCrossingShadowRoot() : nullptr;
  treeMatchContext.InitAncestors(parent);
  nsTArray<nsCSSSelector*> selectorsForDescendants;
  selectorsForDescendants.AppendElements(
      aRestyleHintData.mSelectorsForDescendants);
  nsTArray<nsIContent*> visibleKidsOfHiddenElement;
  nsIFrame* nextIBSibling;
  for (nsIFrame* ibSibling = aFrame; ibSibling; ibSibling = nextIBSibling) {
    nextIBSibling = RestyleManager::GetNextBlockInInlineSibling(propTable, ibSibling);

    if (nextIBSibling) {
      // Don't allow some ib-split siblings to be processed with
      // RestyleResult::eStopWithStyleChange and others not.
      aRestyleHint |= eRestyle_Force;
    }

    // Outer loop over ib-split siblings
    for (nsIFrame* cont = ibSibling; cont; cont = cont->GetNextContinuation()) {
      if (GetPrevContinuationWithSameStyle(cont)) {
        // We already handled this element when dealing with its earlier
        // continuation.
        continue;
      }

      // Inner loop over next-in-flows of the current frame
      ElementRestyler restyler(presContext, cont, aChangeList,
                               aMinChange, aRestyleTracker,
                               selectorsForDescendants,
                               treeMatchContext,
                               visibleKidsOfHiddenElement,
                               aContextsToClear, aSwappedStructOwners);

      restyler.Restyle(aRestyleHint);

      if (restyler.HintsHandledForFrame() & nsChangeHint_ReconstructFrame) {
        // If it's going to cause a framechange, then don't bother
        // with the continuations or ib-split siblings since they'll be
        // clobbered by the frame reconstruct anyway.
        NS_ASSERTION(!cont->GetPrevContinuation(),
                     "continuing frame had more severe impact than first-in-flow");
        return;
      }
    }
  }
}

// The structure of this method parallels ConditionallyRestyleUndisplayedDescendants.
// If you update this method, you probably want to update that one too.
void
ElementRestyler::RestyleUndisplayedDescendants(nsRestyleHint aChildRestyleHint)
{
  nsIContent* undisplayedParent;
  if (MustCheckUndisplayedContent(mFrame, undisplayedParent)) {
    DoRestyleUndisplayedDescendants(aChildRestyleHint, undisplayedParent,
                                    mFrame->StyleContext());
  }
}

// The structure of this method parallels DoConditionallyRestyleUndisplayedDescendants.
// If you update this method, you probably want to update that one too.
void
ElementRestyler::DoRestyleUndisplayedDescendants(nsRestyleHint aChildRestyleHint,
                                                 nsIContent* aParent,
                                                 nsStyleContext* aParentContext)
{
  nsCSSFrameConstructor* fc = mPresContext->FrameConstructor();
  UndisplayedNode* nodes = fc->GetAllUndisplayedContentIn(aParent);
  RestyleUndisplayedNodes(aChildRestyleHint, nodes, aParent,
                          aParentContext, StyleDisplay::None);
  nodes = fc->GetAllDisplayContentsIn(aParent);
  RestyleUndisplayedNodes(aChildRestyleHint, nodes, aParent,
                          aParentContext, StyleDisplay::Contents);
}

// The structure of this method parallels ConditionallyRestyleUndisplayedNodes.
// If you update this method, you probably want to update that one too.
void
ElementRestyler::RestyleUndisplayedNodes(nsRestyleHint      aChildRestyleHint,
                                         UndisplayedNode*   aUndisplayed,
                                         nsIContent*        aUndisplayedParent,
                                         nsStyleContext*    aParentContext,
                                         const StyleDisplay aDisplay)
{
  nsIContent* undisplayedParent = aUndisplayedParent;
  UndisplayedNode* undisplayed = aUndisplayed;
  TreeMatchContext::AutoAncestorPusher pusher(mTreeMatchContext);
  if (undisplayed) {
    pusher.PushAncestorAndStyleScope(undisplayedParent);
  }
  for (; undisplayed; undisplayed = undisplayed->mNext) {
    NS_ASSERTION(undisplayedParent ||
                 undisplayed->mContent ==
                   mPresContext->Document()->GetRootElement(),
                 "undisplayed node child of null must be root");
    NS_ASSERTION(!undisplayed->mStyle->GetPseudo(),
                 "Shouldn't have random pseudo style contexts in the "
                 "undisplayed map");

    LOG_RESTYLE("RestyleUndisplayedChildren: undisplayed->mContent = %p",
                undisplayed->mContent.get());

    // Get the parent of the undisplayed content and check if it is a XBL
    // children element. Push the children element as an ancestor here because it does
    // not have a frame and would not otherwise be pushed as an ancestor.
    nsIContent* parent = undisplayed->mContent->GetParent();
    TreeMatchContext::AutoAncestorPusher insertionPointPusher(mTreeMatchContext);
    if (parent && nsContentUtils::IsContentInsertionPoint(parent)) {
      insertionPointPusher.PushAncestorAndStyleScope(parent);
    }

    nsRestyleHint thisChildHint = aChildRestyleHint;
    nsAutoPtr<RestyleTracker::RestyleData> undisplayedRestyleData;
    Element* element = undisplayed->mContent->AsElement();
    if (mRestyleTracker.GetRestyleData(element,
                                       undisplayedRestyleData)) {
      thisChildHint =
        nsRestyleHint(thisChildHint | undisplayedRestyleData->mRestyleHint);
    }
    RefPtr<nsStyleContext> undisplayedContext;
    nsStyleSet* styleSet = StyleSet();
    if (MustRestyleSelf(thisChildHint, element)) {
      undisplayedContext =
        styleSet->ResolveStyleFor(element, aParentContext, mTreeMatchContext);
    } else if (CanReparentStyleContext(thisChildHint)) {
      undisplayedContext =
        styleSet->ReparentStyleContext(undisplayed->mStyle,
                                       aParentContext,
                                       element);
    } else {
      // Use ResolveStyleWithReplacement either for actual
      // replacements, or as a substitute for ReparentStyleContext
      // that rebuilds the path in the rule tree rather than reusing
      // the rule node, as we need to do during a rule tree
      // reconstruct.
      nsRestyleHint rshint = thisChildHint & ~eRestyle_SomeDescendants;
      undisplayedContext =
        styleSet->ResolveStyleWithReplacement(element, nullptr,
                                              aParentContext,
                                              undisplayed->mStyle,
                                              rshint);
    }
    const nsStyleDisplay* display = undisplayedContext->StyleDisplay();
    if (display->mDisplay != aDisplay) {
      NS_ASSERTION(element, "Must have undisplayed content");
      mChangeList->AppendChange(nullptr, element,
                                nsChangeHint_ReconstructFrame);
      // The node should be removed from the undisplayed map when
      // we reframe it.
    } else {
      // update the undisplayed node with the new context
      undisplayed->mStyle = undisplayedContext;

      if (aDisplay == StyleDisplay::Contents) {
        DoRestyleUndisplayedDescendants(aChildRestyleHint, element,
                                        undisplayed->mStyle);
      }
    }
  }
}

void
ElementRestyler::MaybeReframeForBeforePseudo()
{
  MaybeReframeForPseudo(CSSPseudoElementType::before,
                        mFrame, mFrame, mFrame->GetContent(),
                        mFrame->StyleContext());
}

/**
 * aFrame is the last continuation or block-in-inline sibling that this
 * ElementRestyler is restyling.
 */
void
ElementRestyler::MaybeReframeForAfterPseudo(nsIFrame* aFrame)
{
  MOZ_ASSERT(aFrame);
  MaybeReframeForPseudo(CSSPseudoElementType::after,
                        aFrame, aFrame, aFrame->GetContent(),
                        aFrame->StyleContext());
}

#ifdef DEBUG
bool
ElementRestyler::MustReframeForBeforePseudo()
{
  return MustReframeForPseudo(CSSPseudoElementType::before,
                              mFrame, mFrame, mFrame->GetContent(),
                              mFrame->StyleContext());
}

bool
ElementRestyler::MustReframeForAfterPseudo(nsIFrame* aFrame)
{
  MOZ_ASSERT(aFrame);
  return MustReframeForPseudo(CSSPseudoElementType::after,
                              aFrame, aFrame, aFrame->GetContent(),
                              aFrame->StyleContext());
}
#endif

void
ElementRestyler::MaybeReframeForPseudo(CSSPseudoElementType aPseudoType,
                                       nsIFrame* aGenConParentFrame,
                                       nsIFrame* aFrame,
                                       nsIContent* aContent,
                                       nsStyleContext* aStyleContext)
{
  if (MustReframeForPseudo(aPseudoType, aGenConParentFrame, aFrame, aContent,
                           aStyleContext)) {
    // Have to create the new ::before/::after frame.
    LOG_RESTYLE("MaybeReframeForPseudo, appending "
                "nsChangeHint_ReconstructFrame");
    mHintsHandled |= nsChangeHint_ReconstructFrame;
    mChangeList->AppendChange(aFrame, aContent, nsChangeHint_ReconstructFrame);
  }
}

bool
ElementRestyler::MustReframeForPseudo(CSSPseudoElementType aPseudoType,
                                      nsIFrame* aGenConParentFrame,
                                      nsIFrame* aFrame,
                                      nsIContent* aContent,
                                      nsStyleContext* aStyleContext)
{
  MOZ_ASSERT(aPseudoType == CSSPseudoElementType::before ||
             aPseudoType == CSSPseudoElementType::after);

  // Make sure not to do this for pseudo-frames...
  if (aStyleContext->GetPseudo()) {
    return false;
  }

  // ... or frames that can't have generated content.
  if (!(aGenConParentFrame->GetStateBits() & NS_FRAME_MAY_HAVE_GENERATED_CONTENT)) {
    // Our content insertion frame might have gotten flagged.
    nsContainerFrame* cif = aGenConParentFrame->GetContentInsertionFrame();
    if (!cif || !(cif->GetStateBits() & NS_FRAME_MAY_HAVE_GENERATED_CONTENT)) {
      return false;
    }
  }

  if (aPseudoType == CSSPseudoElementType::before) {
    // Check for a ::before pseudo style and the absence of a ::before content,
    // but only if aFrame is null or is the first continuation/ib-split.
    if ((aFrame && !nsLayoutUtils::IsFirstContinuationOrIBSplitSibling(aFrame)) ||
        nsLayoutUtils::GetBeforeFrameForContent(aGenConParentFrame, aContent)) {
      return false;
    }
  } else {
    // Similarly for ::after, but check for being the last continuation/
    // ib-split.
    if ((aFrame && nsLayoutUtils::GetNextContinuationOrIBSplitSibling(aFrame)) ||
        nsLayoutUtils::GetAfterFrameForContent(aGenConParentFrame, aContent)) {
      return false;
    }
  }

  // Checking for a ::before frame (which we do above) is cheaper than getting
  // the ::before style context here.
  return nsLayoutUtils::HasPseudoStyle(aContent, aStyleContext, aPseudoType,
                                       mPresContext);
}

void
ElementRestyler::InitializeAccessibilityNotifications(nsStyleContext* aNewContext)
{
#ifdef ACCESSIBILITY
  // Notify a11y for primary frame only if it's a root frame of visibility
  // changes or its parent frame was hidden while it stays visible and
  // it is not inside a {ib} split or is the first frame of {ib} split.
  if (nsIPresShell::IsAccessibilityActive() &&
      (!mFrame ||
       (!mFrame->GetPrevContinuation() &&
        !mFrame->FrameIsNonFirstInIBSplit()))) {
    if (mDesiredA11yNotifications == eSendAllNotifications) {
      bool isFrameVisible = aNewContext->StyleVisibility()->IsVisible();
      if (isFrameVisible != mWasFrameVisible) {
        if (isFrameVisible) {
          // Notify a11y the element (perhaps with its children) was shown.
          // We don't fall into this case if this element gets or stays shown
          // while its parent becomes hidden.
          mKidsDesiredA11yNotifications = eSkipNotifications;
          mOurA11yNotification = eNotifyShown;
        } else {
          // The element is being hidden; its children may stay visible, or
          // become visible after being hidden previously. If we'll find
          // visible children then we should notify a11y about that as if
          // they were inserted into tree. Notify a11y this element was
          // hidden.
          mKidsDesiredA11yNotifications = eNotifyIfShown;
          mOurA11yNotification = eNotifyHidden;
        }
      }
    } else if (mDesiredA11yNotifications == eNotifyIfShown &&
               aNewContext->StyleVisibility()->IsVisible()) {
      // Notify a11y that element stayed visible while its parent was hidden.
      nsIContent* c = mFrame ? mFrame->GetContent() : mContent;
      mVisibleKidsOfHiddenElement.AppendElement(c);
      mKidsDesiredA11yNotifications = eSkipNotifications;
    }
  }
#endif
}

// The structure of this method parallels ConditionallyRestyleContentChildren.
// If you update this method, you probably want to update that one too.
void
ElementRestyler::RestyleContentChildren(nsIFrame* aParent,
                                        nsRestyleHint aChildRestyleHint)
{
  LOG_RESTYLE("RestyleContentChildren");

  nsIFrame::ChildListIterator lists(aParent);
  TreeMatchContext::AutoAncestorPusher ancestorPusher(mTreeMatchContext);
  if (!lists.IsDone()) {
    ancestorPusher.PushAncestorAndStyleScope(mContent);
  }
  for (; !lists.IsDone(); lists.Next()) {
    for (nsIFrame* child : lists.CurrentList()) {
      // Out-of-flows are reached through their placeholders.  Continuations
      // and block-in-inline splits are reached through those chains.
      if (!(child->GetStateBits() & NS_FRAME_OUT_OF_FLOW) &&
          !GetPrevContinuationWithSameStyle(child)) {
        // Get the parent of the child frame's content and check if it
        // is a XBL children element. Push the children element as an
        // ancestor here because it does not have a frame and would not
        // otherwise be pushed as an ancestor.

        // Check if the frame has a content because |child| may be a
        // nsPageFrame that does not have a content.
        nsIContent* parent = child->GetContent() ? child->GetContent()->GetParent() : nullptr;
        TreeMatchContext::AutoAncestorPusher insertionPointPusher(mTreeMatchContext);
        if (parent && nsContentUtils::IsContentInsertionPoint(parent)) {
          insertionPointPusher.PushAncestorAndStyleScope(parent);
        }

        // only do frames that are in flow
        if (nsGkAtoms::placeholderFrame == child->GetType()) { // placeholder
          // get out of flow frame and recur there
          nsIFrame* outOfFlowFrame =
            nsPlaceholderFrame::GetRealFrameForPlaceholder(child);
          NS_ASSERTION(outOfFlowFrame, "no out-of-flow frame");
          NS_ASSERTION(outOfFlowFrame != mResolvedChild,
                       "out-of-flow frame not a true descendant");

          // |nsFrame::GetParentStyleContext| checks being out
          // of flow so that this works correctly.
          do {
            if (GetPrevContinuationWithSameStyle(outOfFlowFrame)) {
              // Later continuations are likely restyled as a result of
              // the restyling of the previous continuation.
              // (Currently that's always true, but it's likely to
              // change if we implement overflow:fragments or similar.)
              continue;
            }
            ElementRestyler oofRestyler(*this, outOfFlowFrame,
                                        FOR_OUT_OF_FLOW_CHILD);
            oofRestyler.Restyle(aChildRestyleHint);
          } while ((outOfFlowFrame = outOfFlowFrame->GetNextContinuation()));

          // reresolve placeholder's context under the same parent
          // as the out-of-flow frame
          ElementRestyler phRestyler(*this, child, 0);
          phRestyler.Restyle(aChildRestyleHint);
        }
        else {  // regular child frame
          if (child != mResolvedChild) {
            ElementRestyler childRestyler(*this, child, 0);
            childRestyler.Restyle(aChildRestyleHint);
          }
        }
      }
    }
  }
  // XXX need to do overflow frames???
}

void
ElementRestyler::SendAccessibilityNotifications()
{
#ifdef ACCESSIBILITY
  // Send notifications about visibility changes.
  if (mOurA11yNotification == eNotifyShown) {
    nsAccessibilityService* accService = nsIPresShell::AccService();
    if (accService) {
      nsIPresShell* presShell = mPresContext->GetPresShell();
      nsIContent* content = mFrame ? mFrame->GetContent() : mContent;

      accService->ContentRangeInserted(presShell, content->GetParent(),
                                       content,
                                       content->GetNextSibling());
    }
  } else if (mOurA11yNotification == eNotifyHidden) {
    nsAccessibilityService* accService = nsIPresShell::AccService();
    if (accService) {
      nsIPresShell* presShell = mPresContext->GetPresShell();
      nsIContent* content = mFrame ? mFrame->GetContent() : mContent;
      accService->ContentRemoved(presShell, content);

      // Process children staying shown.
      uint32_t visibleContentCount = mVisibleKidsOfHiddenElement.Length();
      for (uint32_t idx = 0; idx < visibleContentCount; idx++) {
        nsIContent* childContent = mVisibleKidsOfHiddenElement[idx];
        accService->ContentRangeInserted(presShell, childContent->GetParent(),
                                         childContent,
                                         childContent->GetNextSibling());
      }
      mVisibleKidsOfHiddenElement.Clear();
    }
  }
#endif
}

static void
ClearCachedInheritedStyleDataOnDescendants(
    nsTArray<ElementRestyler::ContextToClear>& aContextsToClear)
{
  for (size_t i = 0; i < aContextsToClear.Length(); i++) {
    auto& entry = aContextsToClear[i];
    if (!entry.mStyleContext->HasSingleReference()) {
      entry.mStyleContext->ClearCachedInheritedStyleDataOnDescendants(
          entry.mStructs);
    }
    entry.mStyleContext = nullptr;
  }
}

void
RestyleManager::ComputeAndProcessStyleChange(nsIFrame*              aFrame,
                                             nsChangeHint           aMinChange,
                                             RestyleTracker&        aRestyleTracker,
                                             nsRestyleHint          aRestyleHint,
                                             const RestyleHintData& aRestyleHintData)
{
  MOZ_ASSERT(mReframingStyleContexts, "should have rsc");
  nsStyleChangeList changeList;
  nsTArray<ElementRestyler::ContextToClear> contextsToClear;

  // swappedStructOwners needs to be kept alive until after
  // ProcessRestyledFrames and ClearCachedInheritedStyleDataOnDescendants
  // calls; see comment in ElementRestyler::Restyle.
  nsTArray<RefPtr<nsStyleContext>> swappedStructOwners;
  ElementRestyler::ComputeStyleChangeFor(aFrame, &changeList, aMinChange,
                                         aRestyleTracker, aRestyleHint,
                                         aRestyleHintData,
                                         contextsToClear, swappedStructOwners);
  ProcessRestyledFrames(changeList);
  ClearCachedInheritedStyleDataOnDescendants(contextsToClear);
}

void
RestyleManager::ComputeAndProcessStyleChange(nsStyleContext*        aNewContext,
                                             Element*               aElement,
                                             nsChangeHint           aMinChange,
                                             RestyleTracker&        aRestyleTracker,
                                             nsRestyleHint          aRestyleHint,
                                             const RestyleHintData& aRestyleHintData)
{
  MOZ_ASSERT(mReframingStyleContexts, "should have rsc");
  MOZ_ASSERT(aNewContext->StyleDisplay()->mDisplay == StyleDisplay::Contents);
  nsIFrame* frame = GetNearestAncestorFrame(aElement);
  MOZ_ASSERT(frame, "display:contents node in map although it's a "
                    "display:none descendant?");
  TreeMatchContext treeMatchContext(true,
                                    nsRuleWalker::eRelevantLinkUnvisited,
                                    frame->PresContext()->Document());
  nsIContent* parent = aElement->GetParent();
  Element* parentElement =
    parent && parent->IsElement() ? parent->AsElement() : nullptr;
  treeMatchContext.InitAncestors(parentElement);

  nsTArray<nsCSSSelector*> selectorsForDescendants;
  nsTArray<nsIContent*> visibleKidsOfHiddenElement;
  nsTArray<ElementRestyler::ContextToClear> contextsToClear;

  // swappedStructOwners needs to be kept alive until after
  // ProcessRestyledFrames and ClearCachedInheritedStyleDataOnDescendants
  // calls; see comment in ElementRestyler::Restyle.
  nsTArray<RefPtr<nsStyleContext>> swappedStructOwners;
  nsStyleChangeList changeList;
  ElementRestyler r(frame->PresContext(), aElement, &changeList, aMinChange,
                    aRestyleTracker, selectorsForDescendants, treeMatchContext,
                    visibleKidsOfHiddenElement, contextsToClear,
                    swappedStructOwners);
  r.RestyleChildrenOfDisplayContentsElement(frame, aNewContext, aMinChange,
                                            aRestyleTracker,
                                            aRestyleHint, aRestyleHintData);
  ProcessRestyledFrames(changeList);
  ClearCachedInheritedStyleDataOnDescendants(contextsToClear);
}

nsStyleSet*
ElementRestyler::StyleSet() const
{
  MOZ_ASSERT(mPresContext->StyleSet()->IsGecko(),
             "ElementRestyler should only be used with a Gecko-flavored "
             "style backend");
  return mPresContext->StyleSet()->AsGecko();
}

AutoDisplayContentsAncestorPusher::AutoDisplayContentsAncestorPusher(
  TreeMatchContext& aTreeMatchContext, nsPresContext* aPresContext,
  nsIContent* aParent)
  : mTreeMatchContext(aTreeMatchContext)
  , mPresContext(aPresContext)
{
  if (aParent) {
    nsFrameManager* fm = mPresContext->FrameManager();
    // Push display:contents mAncestors onto mTreeMatchContext.
    for (nsIContent* p = aParent; p && fm->GetDisplayContentsStyleFor(p);
         p = p->GetParent()) {
      mAncestors.AppendElement(p->AsElement());
    }
    bool hasFilter = mTreeMatchContext.mAncestorFilter.HasFilter();
    nsTArray<mozilla::dom::Element*>::size_type i = mAncestors.Length();
    while (i--) {
      if (hasFilter) {
        mTreeMatchContext.mAncestorFilter.PushAncestor(mAncestors[i]);
      }
      mTreeMatchContext.PushStyleScope(mAncestors[i]);
    }
  }
}

AutoDisplayContentsAncestorPusher::~AutoDisplayContentsAncestorPusher()
{
  // Pop the ancestors we pushed in the CTOR, if any.
  typedef nsTArray<mozilla::dom::Element*>::size_type sz;
  sz len = mAncestors.Length();
  bool hasFilter = mTreeMatchContext.mAncestorFilter.HasFilter();
  for (sz i = 0; i < len; ++i) {
    if (hasFilter) {
      mTreeMatchContext.mAncestorFilter.PopAncestor();
    }
    mTreeMatchContext.PopStyleScope(mAncestors[i]);
  }
}

#ifdef RESTYLE_LOGGING
uint32_t
RestyleManager::StructsToLog()
{
  static bool initialized = false;
  static uint32_t structs;
  if (!initialized) {
    structs = 0;
    const char* value = getenv("MOZ_DEBUG_RESTYLE_STRUCTS");
    if (value) {
      nsCString s(value);
      while (!s.IsEmpty()) {
        int32_t index = s.FindChar(',');
        nsStyleStructID sid;
        bool found;
        if (index == -1) {
          found = nsStyleContext::LookupStruct(s, sid);
          s.Truncate();
        } else {
          found = nsStyleContext::LookupStruct(Substring(s, 0, index), sid);
          s = Substring(s, index + 1);
        }
        if (found) {
          structs |= nsCachedStyleData::GetBitForSID(sid);
        }
      }
    }
    initialized = true;
  }
  return structs;
}
#endif

#ifdef DEBUG
/* static */ nsCString
RestyleManager::StructNamesToString(uint32_t aSIDs)
{
  nsCString result;
  bool any = false;
  for (nsStyleStructID sid = nsStyleStructID(0);
       sid < nsStyleStructID_Length;
       sid = nsStyleStructID(sid + 1)) {
    if (aSIDs & nsCachedStyleData::GetBitForSID(sid)) {
      if (any) {
        result.AppendLiteral(",");
      }
      result.AppendPrintf("%s", nsStyleContext::StructName(sid));
      any = true;
    }
  }
  return result;
}

/* static */ nsCString
ElementRestyler::RestyleResultToString(RestyleResult aRestyleResult)
{
  nsCString result;
  switch (aRestyleResult) {
    case RestyleResult::eStop:
      result.AssignLiteral("RestyleResult::eStop");
      break;
    case RestyleResult::eStopWithStyleChange:
      result.AssignLiteral("RestyleResult::eStopWithStyleChange");
      break;
    case RestyleResult::eContinue:
      result.AssignLiteral("RestyleResult::eContinue");
      break;
    case RestyleResult::eContinueAndForceDescendants:
      result.AssignLiteral("RestyleResult::eContinueAndForceDescendants");
      break;
    default:
      MOZ_ASSERT(aRestyleResult == RestyleResult::eNone,
                 "Unexpected RestyleResult");
  }
  return result;
}
#endif

} // namespace mozilla
